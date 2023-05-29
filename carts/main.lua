-- quake engine
-- by @freds72

-- game globals
local _particles,_futures,_cam,_plyr,_model,_leaves,_bsps,_models,_start_pos,_start_angle={},{}
local plane_dot,plane_isfront,plane_get,plane_bbox

-- lightmap memory address + flat u/v array + bsp content types
local _maps,_texcoords={},{}

-- maths & cam
local function lerp(a,b,t)
	return a*(1-t)+b*t
end

local function make_v(a,b)
	return {
		b[1]-a[1],
		b[2]-a[2],
		b[3]-a[3]}
end
function v_clone(v)
	return {v[1],v[2],v[3]}
end
local function v_dot(a,b)
	return a[1]*b[1]+a[2]*b[2]+a[3]*b[3]
end
-- returns scaled down dot, safe for overflow
local function v_dotsign(a,b)
  local x0,y0,z0=a[1]>>4,a[2]>>4,a[3]>>4
  local x1,y1,z1=b[1]>>4,b[2]>>4,b[3]>>4
	return x0*x1+y0*y1+z0*z1
end

local function v_scale(v,scale)
	v[1]*=scale
	v[2]*=scale
	v[3]*=scale
end
local function v_add(v,dv,scale)
	scale=scale or 1
	return {
		v[1]+scale*dv[1],
		v[2]+scale*dv[2],
		v[3]+scale*dv[3]}
end
local function v_lerp(a,b,t,uv)
  local ax,ay,az,u,v=a[1],a[2],a[3],a.u,a.v
	return {
    ax+(b[1]-ax)*t,
    ay+(b[2]-ay)*t,
    az+(b[3]-az)*t,
    u=uv and u+(b.u-u)*t,
    v=uv and v+(b.v-v)*t
  }
end

function v_cross(a,b)
	local ax,ay,az=a[1],a[2],a[3]
	local bx,by,bz=b[1],b[2],b[3]
	return {ay*bz-az*by,az*bx-ax*bz,ax*by-ay*bx}
end

-- safe for overflow len
-- faster than sqrt variant (23.5+14 vs. 27.5)
-- credits: https://www.lexaloffle.com/bbs/?tid=49827
function v_len(v)
  local x,y,z=v[1],v[2],v[3]
  local ax=atan2(x,y)
  local d2=x*cos(ax)+y*sin(ax)
  local az=atan2(d2,z)
  return d2*cos(az)+z*sin(az)
end 

function v_normz(v)
  local d=v_len(v)
	return {v[1]/d,v[2]/d,v[3]/d},d
end

-- matrix functions
function make_m_from_euler(x,y,z)
		local a,b = cos(x),-sin(x)
		local c,d = cos(y),-sin(y)
		local e,f = cos(z),-sin(z)
  
    -- yxz order
  local ce,cf,de,df=c*e,c*f,d*e,d*f
	 return {
	  ce+df*b,a*f,cf*b-de,0,
	  de*b-cf,a*e,df+ce*b,0,
	  a*d,-b,a*c,0,
	  0,0,0,1}
end

-- returns basis vectors from matrix
function m_right(m)
	return {m[1],m[2],m[3]}
end
function m_up(m)
	return {m[5],m[6],m[7]}
end
function m_fwd(m)
	return {m[9],m[10],m[11]}
end

-- print helper
function printb(s,x,y,c0,c1)
  x=x or (64-print(s,0,-128)/2)
  ?s,x,y+1,c1
  ?s,x,y,c0
end

-- registers a new coroutine
-- returns a handle to the coroutine
-- used to cancel a coroutine
function do_async(fn)
  return add(_futures,{co=cocreate(fn)})
end
-- wait until timer
function wait_async(t)
	for i=1,t do
		yield()
	end
end

-- camera
function make_cam()
  local up={0,1,0}
  local visleaves,visframe,prev_leaf={},0

  -- collect bps leaves in order
  local function collect_bsp(node,origin)
    local function collect_leaf(side)
      local child=node[side]
      if child and child.visframe==visframe then
        if child.contents then          
          visleaves[#visleaves+1]=child
        else
          collect_bsp(child,origin)
        end
      end
    end  
    local side=plane_isfront(node.plane,origin)
    collect_leaf(not side)
    collect_leaf(side)
  end  

	return {
		origin={0,0,0},    
		track=function(self,origin,m)
      --origin=v_add(v_add(origin,m_fwd(m),-24),m_up(m),24)	      
      local m={unpack(m)}		
      -- inverse view matrix
      m[2],m[5]=m[5],m[2]
			m[3],m[9]=m[9],m[3]
      m[7],m[10]=m[10],m[7]
      --
      self.m={unpack(m)}
      self.origin=origin
    end,
    collect_leaves=function(self,bsp,all_leaves)
      local current_leaf=find_sub_sector(bsp,self.origin)
      -- changed sector?
      if current_leaf and current_leaf!=prev_leaf then
        prev_leaf=current_leaf
        visframe+=1
        -- find all (potentially) visible leaves
        for i,bits in pairs(current_leaf.pvs) do
          i<<=5
          for j=0,31 do
            -- visible?
            if bits&(0x0.0001<<j)!=0 then
              local leaf=all_leaves[(i|j)+2]
              -- tag visible parents (if not already tagged)
              while leaf and leaf.visframe!=visframe do
                leaf.visframe=visframe
                leaf=leaf.parent
              end
            end
          end
        end    
      end
      -- collect convex spaces back to front
      visleaves={}
      collect_bsp(bsp,self.origin)
      -- for all things on each leaves, pick closest leaf
      for leaf in all(visleaves) do
        for thing in pairs(leaf.things) do
          thing.visleaf=leaf
        end
      end
      return visleaves,visframe
    end,  
    draw_faces=function(self,verts,faces,leaves,lstart,lend,brushes)    
      local cx,cy,cz=unpack(self.origin)
      local v_cache_class={        
        __index=function(self,vi)
          local m,code,x,y,z=self.m,0,verts[vi]-cx,verts[vi+1]-cy,verts[vi+2]-cz
          local ax,ay,az=m[1]*x+m[5]*y+m[9]*z,m[2]*x+m[6]*y+m[10]*z,m[3]*x+m[7]*y+m[11]*z

          -- znear=8
          if az<8 then code=2 end
          --if az>256 then code|=1 end
          if ax>az then code|=4
          elseif ax<-az then code|=8 end
          if ay>az then code|=16
          elseif ay<-az then code|=32 end
          -- save world space coords for clipping
          -- to screen space
          local w=64/az
          local a={ax,ay,az,x=63.5+ax*w,y=63.5-ay*w,w=w,outcode=code}
          self[vi]=a          
          return a
        end
      }

      local m=self.m
      local pts,cam_u,cam_v,v_cache,f_cache,fu_cache,fv_cache,cam_pos={},{m[1],m[5],m[9]},{m[2],m[6],m[10]},setmetatable({m=m},v_cache_class),{},{},{},self.origin
      
      -- printh(cam_u[1]..","..cam_u[2]..","..cam_u[3].." | "..cam_v[1]..","..cam_v[2]..","..cam_v[3])
      
      local flick,pal0=time()%2<0.5*rnd()+0.5
      for j=lstart,lend do
        local leaf=leaves[j]
        -- faces form a convex space, render in any order        
        for i=1,#leaf do
          -- face index
          local fi=leaf[i]            
          -- face normal          
          local fn,flags=faces[fi],faces[fi+2]
          -- skip skies
          if flags&0x4==0 then
            -- some sectors are sharing faces
            -- make sure a face from a leaf is drawn only once
            if not f_cache[fi] and plane_dot(fn,cam_pos)<faces[fi+1]!=(flags&1==0) then            
              f_cache[fi]=true

              local face_verts,outcode,clipcode,uvi=faces[fi+3],0xffff,0,faces[fi+5]
              local np=#face_verts
              for k,vi in inext,face_verts do                
                local a=v_cache[vi]
                local code=a.outcode
                outcode&=code
                clipcode+=code&2
                pts[k]=a              
                if uvi!=-1 then
                  local kuv=uvi+(k<<1)
                  a.u=_texcoords[kuv-1]
                  a.v=_texcoords[kuv]
                end
              end
              if outcode==0 then 
                if(np>2 and clipcode>0) pts,np=z_poly_clip(pts,np,uvi!=-1)
                -- still a valid polygon?
                if np>2 then
                  if uvi!=-1 then
                    -- color ramp
                    local pal1=faces[fi+4]
                    if pal1==10 and flick then
                      pal1=4
                    else
                      pal1=8
                    end
                    if(pal0!=pal1) memcpy(0x5f00,0x4400|pal1<<4,16) pal0=pal1

                    -- activate texture
                    local mi=faces[fi+6]
                    if flags&8==0 then
                      -- regular texture
                      -- global offset (using 0x8000 zone) + stride
                      local texaddr=_maps[mi+1]
                      poke(0x5f56,_maps[mi],(texaddr<<16)&0xff)
                      poke4(0x5f38,texaddr)                
                    else
                      -- lightmap
                      -- reset starting point + stride
                      poke(0x5f56,0x20,_maps[mi])
                      -- reset texcoords
                      poke4(0x5f38,0)
                      poke4(0x2000,unpack(_maps[mi+1]))                  
                    end
                    
                    local u,v=fu_cache[fn],fv_cache[fn]
                    if not u then
                      -- not needed (we take abs u)
                      -- if(side) s,t=-s,-t
                      u,v=abs(plane_dot(fn,cam_u)),abs(plane_dot(fn,cam_v))
                      fu_cache[fn]=u
                      fv_cache[fn]=v
                    end

                    if u>v then
                      polytex_xmajor(pts,np,v)
                    else
                      polytex_ymajor(pts,np,u)
                    end
                  else
                    -- sky?
                    polyfill(pts,np,0)
                    -- polyline(pts,np,1)
                    --polyfill(pts,np,0)
                  end                  
                end
              end
            end
          end
        end
        if leaf.ents then
          palt(15,true)
          pal(0,7)
          palt(0,false)
          for k,v in pairs(leaf.ents) do
            local code,x,y,z=0,k.origin[1]-cx,k.origin[2]-cy,k.origin[3]-cz
            local ax,ay,az=m[1]*x+m[5]*y+m[9]*z,m[2]*x+m[6]*y+m[10]*z,m[3]*x+m[7]*y+m[11]*z
              -- znear=8
            if az<8 then code=2 end
            -- save world space coords for clipping
            -- to screen space
            if code==0 then
              local w=64/az
              local x,y=63.5+ax*w,63.5-ay*w
              w*=64
              local ratio=42/96
              sspr(0,32,42,96,x-ratio*w/2,y-w/2,ratio*w,w)            
              pset(x,y,9)
            end
          end
          pal()
          palt()
          palt(0,false)
        end
        if brushes then
          local polys=brushes[leaf]
          if polys then
            -- all "faces" (already visible)
            for i,poly in inext,polys do                          
              -- dual sided or visible?
              local fi=poly.fi
              local np,outcode,clipcode,uvi,fn,flags=#poly,0xffff,0,faces[fi+5],faces[fi],faces[fi+2]
              for k=1,np do
                -- base index in verts array
                local v=poly[k]
                -- note: no caching as clipped brush vertices are unique
                local code,x,y,z=0,v[1]-cx,v[2]-cy,v[3]-cz
                local ax,ay,az=m[1]*x+m[5]*y+m[9]*z,m[2]*x+m[6]*y+m[10]*z,m[3]*x+m[7]*y+m[11]*z
      
                -- znear=8
                if az<8 then code=2 end
                --if az>2048 then code|=1 end
                if ax>az then code|=4
                elseif ax<-az then code|=8 end
                if ay>az then code|=16
                elseif ay<-az then code|=32 end
                -- save world space coords for clipping
                -- to screen space
                local w=64/az
                pts[k]={ax,ay,az,u=v.u,v=v.v,x=63.5+ax*w,y=63.5-ay*w,w=w,outcode=code}
                outcode&=code
                clipcode+=code&2
              end
              if outcode==0 then 
                if(clipcode>0) pts,np=z_poly_clip(pts,np,uvi!=-1)
                if np>2 then
                  if uvi!=-1 then
                    -- enable texture
                    local mi=faces[fi+6]
                    if flags&8==0 then
                      -- regular texture
                      -- global offset (using 0x8000 zone) + stride
                      local texaddr=_maps[mi+1]
                      poke(0x5f56,_maps[mi],(texaddr<<16)&0xff)
                      poke4(0x5f38,texaddr)
                    else
                      -- lightmap
                      -- reset starting point + stride
                      poke(0x5f56,0x20,_maps[mi])
                      -- reset texcoords
                      poke4(0x5f38,0)
                      poke4(0x2000,unpack(_maps[mi+1]))                  
                    end

                    local u,v=abs(plane_dot(fn,cam_u)),abs(plane_dot(fn,cam_v))
                    if u>v then
                      polytex_xmajor(pts,np,v)
                    else
                      polytex_ymajor(pts,np,u)
                    end
                  else                    
                    polyfill(pts,np,0)            
                  end
                end
              end
            end
          end
        end       
      end
    end  
  }
end

-- znear=8
function z_poly_clip(v,nv,uvs)
	local res,v0={},v[nv]
	local d0=v0[3]-8
	for i=1,nv do
    local side=d0>0
    if side then
      res[#res+1]=v0
    end
		local v1=v[i]
		local d1=v1[3]-8
    -- not same sign?
		if (d1>0)!=side then
      local nv=v_lerp(v0,v1,d0/(d0-d1),uvs)
      -- project against near plane
      nv.x=63.5+(nv[1]<<3)
      nv.y=63.5-(nv[2]<<3)
      nv.w=8
      res[#res+1]=nv
    end
    v0=v1
		d0=d1
	end
	return res,#res
end

function poly_uv_clip(node,v,uvs)
  -- degenerate case
  if(#v<3) return {},{}
  local dists,side={},0
  for i=1,#v do
    local d,dist=plane_dot(node.plane,v[i])  
    d-=dist
    side|=d>0 and 1 or 2
    dists[i]=d
  end
  -- early exit tests (eg. no clipping)
  if(side==1) return v,{}
  if(side==2) return {},v
  -- straddling
  -- copy original face index
	local res,out_res,v0,d0={fi=v.fi},{fi=v.fi},v[#v],dists[#v]
	for i=1,#v do
		local v1,d1=v[i],dists[i]
    if d0<=0 then
      add(out_res,v0,1)
    end
		if (d1>0)!=(d0>0) then
      -- push in front of list
      local v2=v_lerp(v0,v1,d0/(d0-d1),uvs)
      add(out_res,v2,1)
      -- add to end
      res[#res+1]=v2
    end
    if d1>0 then
      res[#res+1]=v1
    end    
    v0=v1
		d0=d1
	end

	return res,out_res
end

function bsp_clip(node,poly,out,uvs)
  -- use hyperplane to split poly
  local res_in,res_out=poly_uv_clip(node,poly,uvs)
  if #res_in>0 then
    local child=node[true]
    if child then
      if child.contents then
        local brushes=out[child] or {}
        add(brushes,res_in)
        out[child]=brushes
      else
        bsp_clip(child,res_in,out,uvs)
      end
    end
  end
  if #res_out>0 then
    local child=node[false]
    if child then
      if child.contents then
        local brushes=out[child] or {}
        add(brushes,res_out)
        out[child]=brushes
      else   
        bsp_clip(child,res_out,out,uvs)
      end
    end
  end
end

function slide(ent,origin,velocity)
  local original_velocity,primal_velocity=v_clone(velocity),v_clone(velocity)
  local time_left,planes,wall,ground=1/30,{}

  -- check current to target origin
  for i=1,3 do
    -- try far target
    local next_pos=v_add(origin,velocity,time_left)

    local hits = hitscan(origin,next_pos,_bsps)
    if not hits.n then
      -- all clear
      origin=next_pos
      break
    end
    if hits.start_solid or hits.all_solid then
        velocity={0,0,0}
        break
    end
    -- actually covered some distance
    if hits.t>0 then
        origin=hits.origin
        planes={}
    end
    if hits.t==1 then
        break
    end

    local n_up=hits.n[2]
    if n_up>0.7 then
        -- ground?
        -- last hit ground entity
        ground=hits.ent
    elseif n_up==0 then
      -- wall?
      wall=hits.n
    end
    if hits.ent.touch then
      hits.ent:touch()
    end

    time_left-=time_left*hits.t
    if #planes>5 then
        --printh("too many planes: "..#planes)
        velocity={0,0,0}
        break
    end
    add(planes,hits.n)

    local i,np,new_vel=1,#planes,{}
    while i<=np do
      -- adjust velocity
      local n=planes[i]
      local backoff=v_dot(original_velocity,n)        
      for k,v in inext,original_velocity do
          v-=n[k]*backoff
          if v>-0.1 and v<0.1 then
              v=0
          end
          new_vel[k]=v
      end

      local j=1
      while j<=np do
          if i~=j then
              if v_dot(new_vel, planes[j])<0 then
                break
              end
          end
          j+=1
      end
      if j>np then
          break
      end
      i+=1
    end
    if i<=np then
        -- go along
        velocity=new_vel
    else
      if np~=2 then
          velocity={0,0,0}
          break
      end
      -- "crease"
      local dir=v_cross(planes[1],planes[2])
      -- project velocity on it
      v_scale(dir,v_dot(dir,velocity))
      -- new velocity along crease!
      velocity=dir
    end

    -- if original velocity is against the original velocity, stop dead
    -- to avoid tiny occilations in sloping corners
    -- !!! can overflow !!!
    if v_dotsign(velocity, primal_velocity) <= 0 then
        velocity={0,0,0}
        break
    end
  end

  return {
      origin=origin,
      velocity=velocity,
      ground=ground,
      wall=wall,
      t=time_left*30,
      touched=touched}
end

function make_player(origin,a)
  local angle,dangle,velocity,eye_offset,dead,deadangle={0,a,0},{0,0,0},{0,0,0,},0

  return {
    -- start above floor
    origin=v_add(origin,{0,1,0}),    
    m=make_m_from_euler(unpack(angle)),
    -- change orientation
    orient=function(self,origin,dir,a)
      self.origin=v_clone(origin)
      -- adjust velocity direction (keep speed)
      local vn,vl=v_normz(velocity)
      velocity=v_clone(dir)
      v_scale(velocity,vl)

      -- force turn?
      if a then
        -- turn toward exit point
        angle[2]=a
        self.m=make_m_from_euler(unpack(angle))
      end
    end,
    control=function(self)
      -- move
      local dx,dz,a,jmp=0,0,angle[2],0
      if(btn(0,1)) dx=3
      if(btn(1,1)) dx=-3
      if(btn(2,1)) dz=3
      if(btn(3,1)) dz=-3
      if(btnp(4)) jmp=6

      dangle=v_add(dangle,{stat(39),stat(38),dx/40})

      local c,s=cos(a),-sin(a)
      velocity=v_add(velocity,{s*dz-c*dx,jmp,c*dz+s*dx},30)         
    end,
    update=function(self)
      -- damping      
      angle[3]*=0.8
      v_scale(dangle,0.6)
      velocity[1]*=0.8
      --velocity[2]*=0.9
      velocity[3]*=0.8
      -- gravity
      velocity[2]-=18

      if dead then
        angle=v_lerp(angle,deadangle,0.6)
      else
        angle=v_add(angle,dangle,1/1024)
      end

      -- check next position
      local vn,vl=v_normz(velocity)      
      local new_pos,new_vel,new_ground=self.origin,velocity,self.ground
      if vl>0.1 then
				local move=slide(self,self.origin,velocity)   
				new_ground,new_pos,new_vel=move.ground,move.origin,move.velocity
				if move.wall then
					local downmove={0,velocity[2]/30-16,0}
					
					-- move up
					local uptrace = hitscan(self.origin,v_add(self.origin,{0,16,0}),_bsps)
					new_pos=uptrace.origin

					-- move fwd
					local steptrace = slide(self,new_pos,{velocity[1],0,velocity[3]})   
					if steptrace.wall then
            -- friction
            local n=v_clone(steptrace.wall)
            local d=v_dot(n,m_fwd(self.m))+0.5
            if d<0 then         
              -- cut the tangential velocity
              v_scale(n,v_dot(n,new_vel))       
              local side=v_add(new_vel,n,-1)
              new_vel[1]=side[1]*(1+d)
              new_vel[3]=side[3]*(1+d)
            end          
					end

					-- find flat ground
					local downtrace = hitscan(steptrace.origin,v_add(steptrace.origin,downmove),_bsps)

          -- ground?
					if downtrace.n and downtrace.n[2]>0.7 then
						new_pos,new_ground=downtrace.origin,downtrace.ent
						-- record how much the stairs up is changing position
						eye_offset+=new_pos[2]-move.origin[2]
					else
						-- no stairs, fallback to normal slide move
						new_pos,new_vel=move.origin,move.velocity
					end
				end	        
      else
        new_vel = {0,0,0}
      end

			-- "debug"
			self.ground=new_ground                    

			-- use corrected velocity
			self.origin=new_pos
			velocity=new_vel
      
      if dead then
        self.eye_pos=v_add(self.origin,{0,2,0})
      else
        eye_offset=lerp(eye_offset,0,0.4)
        self.eye_pos=v_add(self.origin,{0,24-eye_offset,0})
      end
      self.m=make_m_from_euler(unpack(angle))
      
      -- lava?
      if not dead then
        local node=find_sub_sector(_model.bsp,self.origin)
        -- in lava or invalid position -> kill
        if node.contents==-5 or node.contents==-2 then
          -- avoid reentrancy
          dead=true
          deadangle=v_clone(angle)
          deadangle[3]=rnd()>0.5 and 0.1 or -0.1
          velocity=v_add(velocity,{rnd(10)-5,25+rnd(5),rnd(10)-5})   
            
          next_state(gameover_state,false)
        end
      end      
    end
  } 
end

-->8
-- bsp functions

function pvs_register(node,ent)
  -- refresh attributes linked to origin
  ent.absmins=v_add(ent.origin,ent.mins)
  ent.absmaxs=v_add(ent.origin,ent.maxs)

  -- unregister from visible world
  if ent.nodes then
    for node in pairs(ent.nodes) do
        if(node.ents) node.ents[ent]=nil
        ent.nodes[node] = nil
    end    
  end

  -- register new location
  local mins,maxs=ent.absmins,ent.absmaxs
  local c={
      (mins[1]+maxs[1])>>1,
      (mins[2]+maxs[2])>>1,
      (mins[3]+maxs[3])>>1
  }

  -- register in visible world (e.g. PVS)
  ent.first_node=nil
  register_bbox(node, ent, c, make_v(c, maxs))
end

function register_bbox(node, ent, pos, size)    
  if node.contents==-2 then
      return
  end

  -- any non solid content
  if node.contents then
      -- entity -> leaf
      ent.nodes[node]=true
      -- leaf -> entity
      if not node.ents then
          node.ents={}
      end
      node.ents[ent]=true
      -- fallback?
      
      if(not ent.first_node) ent.first_node=node
      return
  end

  -- classify box
  local sides = plane_bbox(node.plane, pos, size)
  -- capture first clipping node (for moving brushes)
  if not ent.first_node and sides&3!=0 then
    ent.first_node=node
  end
  -- sides or straddling?
  if sides&1!=0 then
    register_bbox(node[false], ent, pos, size)
  end
  if sides&2!=0 then
    register_bbox(node[true], ent, pos, size)
  end

end

-- find in what convex leaf origin is
function find_sub_sector(node,origin)
  while not node.contents do
    node=node[plane_isfront(node.plane,origin)]
  end
  return node
end

-- https://github.com/id-Software/Quake/blob/bf4ac424ce754894ac8f1dae6a3981954bc9852d/WinQuake/world.c
-- hull location
-- https://github.com/id-Software/Quake/blob/bf4ac424ce754894ac8f1dae6a3981954bc9852d/QW/client/pmovetst.c
-- https://developer.valvesoftware.com/wiki/BSP
-- ray/bsp intersection
function ray_bsp_intersect(node,p0,p1,t0,t1,out)
  local contents=node.contents  
  if contents then
      -- is "solid" space (bsp)
      if contents!=-2 then
          out.all_solid = false
          if contents==-1 then
              out.in_open = true
          else
              out.in_water = true
          end
      else
          out.start_solid = true
      end
      -- empty space
      return true
  end
  local dist,node_dist=plane_dot(node.plane,p0)
  local otherdist=plane_dot(node.plane,p1)
  local side,otherside=dist>node_dist,otherdist>node_dist
  if side==otherside then
      -- go down this side
      return ray_bsp_intersect(node[side],p0,p1,t0,t1,out)
  end
  -- crossing a node
  local t=dist-node_dist
  if t<0 then
    t+=0.03125
  else
    t-=0.03125
  end  
  -- cliping fraction
  local frac=mid(t/(dist-otherdist),0,1)
  local tmid,pmid=lerp(t0,t1,frac),v_lerp(p0,p1,frac)
  if not ray_bsp_intersect(node[side],p0,pmid,t0,tmid,out) then
    return
  end

  if find_sub_sector(node[not side],pmid).contents!=-2 then
    return ray_bsp_intersect(node[not side],pmid,p1,tmid,t1,out)
  end

  -- never got out of the solid area
  if out.all_solid then
    return
  end

  local scale=side and 1 or -1
  local nx,ny,nz=plane_get(node.plane)
  out.n = {scale*nx,scale*ny,scale*nz,node_dist}
  out.t = tmid
  out.origin = pmid
end

function hitscan(p0,p1,ents)
  -- default = reaches target position
  local hits={
      t=1,
      origin=p1
  }
  for k=1,#ents do
    local other_ent = ents[k]
    -- skip "hollow" entities
    if other_ent.solid then
      local tmphits={
          t=1,
          all_solid=true,
          ent=other_ent
      }
      -- rebase ray in entity origin
      ray_bsp_intersect(other_ent.clipnodes,make_v(other_ent.origin,p0),make_v(other_ent.origin,p1),0,1,tmphits)

      -- "invalid" location
      if tmphits.start_solid or tmphits.all_solid then
        return tmphits
      end

      -- closest hit?
      if tmphits.n and tmphits.t<hits.t then                    
          -- adjust origin                        
          hits = tmphits
          -- rebase to world space
          hits.origin=v_add(hits.origin,other_ent.origin)
      end
    end
  end  
  return hits
end

-- game states
-- transition to next state
function next_state(state,...)
	draw_state,update_state=state(...)
end

function play_state(origin,angle)
  _cam=make_cam()
  _plyr=make_player(origin,angle)

  -- test
  pvs_register(
    _model.bsp,{
      nodes={},
      mins={0,0,0},
      maxs={16,16,16},
      origin=v_add(_plyr.origin,{0,0,0}),
      spr=64
    })

	return
		-- draw
		function()
		end,
		-- update
		function()
			if false then
				next_state(gameover_state)
				return
			end

      _plyr:control()	
		end
end

function gameover_state(win,total_t)
	-- record initial button state (avoid auto-skip screen)
	local ttl,last_btn,btn_press=90,btn(4),0

	music(gameover_music)

	return 
		-- draw
		function()
      if win then
      end

			-- 
			if ttl%32<16 then
				printb("🅾️ try again",nil,67,10,9)
				printb("❎ start menu",nil,57,9,4)
			end
		end,
		-- update
		function()
			ttl-=1

			if btn(4)!=last_btn then
				btn_press+=1
				last_btn=btn(4)
			end

			if btn_press>1 or ttl<0 then
				next_state(play_state,_start_pos,_start_angle)
			elseif btnp(5) then
				-- back to selection title
				load("qk.p8")
			end
		end
end

function _init()
  cartdata("q8k")
  -- custom quake font
  ?"\^@56000800⁴⁸⁶\0\0¹\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0³3#⁙3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0000#23³33323333²\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0⁷⁷⁷⁷⁷\0\0\0\0⁷⁷⁷\0\0\0\0\0⁷⁵⁷\0\0\0\0\0⁵²⁵\0\0\0\0\0⁵\0⁵\0\0\0\0\0⁵⁵⁵\0\0\0\0⁴⁶⁷⁶⁴\0\0\0¹³⁷³¹\0\0\0⁷¹¹¹\0\0\0\0\0⁴⁴⁴⁷\0\0\0⁵⁷²⁷²\0\0\0\0\0²\0\0\0\0\0\0\0\0¹²\0\0\0\0\0\0³³\0\0\0⁵⁵\0\0\0\0\0\0²⁵²\0\0\0\0\0\0\0\0\0\0\0\0\0²²²\0²\0\0\0⁵⁵\0\0\0\0\0\0⁵⁷⁵⁷⁵\0\0\0⁷³⁶⁷²\0\0\0⁵⁴²¹⁵\0\0\0³³⁶⁵⁷\0\0\0²¹\0\0\0\0\0\0²¹¹¹²\0\0\0²⁴⁴⁴²\0\0\0⁵²⁷²⁵\0\0\0\0²⁷²\0\0\0\0\0\0\0²¹\0\0\0\0\0⁷\0\0\0\0\0\0\0\0\0²\0\0\0⁴²²²¹\0\0\0゛333゛\0\0\0⁷⁶⁶⁶⁶\0\0\0゜ >¹?\0\0\0゜0、0「⁴\0\000086○0\0\0\0ᶠ¹ᶠ「ᶜ²\0\0ᵉ³゜3゛\0\0\0ᶠ⁸⁴⁶⁶\0\0\0゛3゛3゛\0\0\0゛3>0「⁴\0\0\0⁶⁶\0⁶⁶\0\0\0²\0²¹\0\0\0⁴²¹²⁴\0\0\0\0⁷\0⁷\0\0\0\0¹²⁴²¹\0\0\0⁷⁴⁶\0²\0\0\0²⁵⁵¹⁶\0\0\0\0⁶⁵⁷⁵\0\0\0\0³³⁵⁷\0\0\0\0⁶¹¹⁶\0\0\0\0³⁵⁵³\0\0\0\0⁷³¹⁶\0\0\0\0⁷³¹¹\0\0\0\0⁶¹⁵⁷\0\0\0\0⁵⁵⁷⁵\0\0\0\0⁷²²⁷\0\0\0\0⁷²²³\0\0\0\0⁵³⁵⁵\0\0\0\0¹¹¹⁶\0\0\0\0⁷⁷⁵⁵\0\0\0\0³⁵⁵⁵\0\0\0\0⁶⁵⁵³\0\0\0\0⁶⁵⁷¹\0\0\0\0²⁵³⁶\0\0\0\0³⁵³⁵\0\0\0\0⁶¹⁴³\0\0\0\0⁷²²²\0\0\0\0⁵⁵⁵⁶\0\0\0\0⁵⁵⁷²\0\0\0\0⁵⁵⁷⁷\0\0\0\0⁵²²⁵\0\0\0\0⁵⁷⁴³\0\0\0\0⁷⁴¹⁷\0\0\0³¹¹¹³\0\0\0¹²²²⁴\0\0\0⁶⁴⁴⁴⁶\0\0\0²⁵\0\0\0\0\0\0\0\0\0\0⁷\0\0\0²⁴\0\0\0\0\0\0⁸、◀>31\0\0゜3゜33゜\0\0゛⁙³³⁙゛\0\0゜3333゜\0\0?#ᶠ³#>\0\0>#ᶠ³³³\0\0>#³s36▮\00033?333\0\0⁶⁶⁶⁶⁶⁶\0\0「「「「ᶜ⁶\0\0C3••3#\0\0³³³³#?\0\0cw○omi\0\0CGOYq`\0\0>cccc>\0\0ᶠ•••ᶠ³\0\0\"cCk>⁸⁸\0゜3゜3##\0\0>¹゛01゜\0\0?-ᶜᶜᶜ⁴\0\00033333゛\0\0cw6>、⁸\0\0[[{○6\"\0\0c&ᶜ「6c\0\0001¥ᵉ⁶⁶⁶\0\0゜」ᶜ⁶⁙゜\0\0⁶²³²⁶\0\0\0²²²²²\0\0\0³²⁶²³\0\0\0\0⁴⁷¹\0\0\0\0\0²⁵²\0\0\0\0○○○○○\0\0\0U*U*U\0\0\0A○]]>\0\0\0>ccw>\0\0\0■D■D■\0\0\0⁴<、゛▮\0\0\0、.>>、\0\0\0006>>、⁸\0\0\0、6w6、\0\0\0、、>、⁘\0\0\0、>○*:\0\0\0>gcg>\0\0\0○]○A○\0\0\0008⁸⁸ᵉᵉ\0\0\0>ckc>\0\0\0⁸、>、⁸\0\0\0\0\0U\0\0\0\0\0>scs>\0\0\0⁸、○>\"\0\0\0>、⁸、>\0\0\0>wcc>\0\0\0\0⁵R \0\0\0\0\0■*D\0\0\0\0>kwk>\0\0\0○\0○\0○\0\0\0UUUUU\0\0\0ᵉ⁴゛-&\0\0\0■!!%²\0\0\0ᶜ゛  、\0\0\0⁸゛⁸$¥\0\0\0N⁴>E&\0\0\0\"_□□\n\0\0\0゛⁸<■⁶\0\0\0▮ᶜ²ᶜ▮\0\0\0\"z\"\"□\0\0\0゛ \0²<\0\0\0⁸<▮²ᶜ\0\0\0²²²\"、\0\0\0⁸>⁸ᶜ⁸\0\0\0□?□²、\0\0\0<▮~⁴8\0\0\0²⁷2²2\0\0\0ᶠ²ᵉ▮、\0\0\0>@@ 「\0\0\0>▮⁸⁸▮\0\0\0⁸8⁴²<\0\0\0002⁷□x「\0\0\0zB²\nr\0\0\0\t>Kmf\0\0\0¥'\"s2\0\0\0<JIIF\0\0\0□:□:¥\0\0\0#b\"\"、\0\0\0ᶜ\0⁸*M\0\0\0\0ᶜ□!@\0\0\0}y■=]\0\0\0><⁸゛.\0\0\0⁶$~&▮\0\0\0$N⁴F<\0\0\0\n<ZF0\0\0\0゛⁴゛D8\0\0\0⁘>$⁸⁸\0\0\0:VR0⁸\0\0\0⁴、⁴゛⁶\0\0\0⁸²> 、\0\0\0\"\"& 「\0\0\0>「$r0\0\0\0⁴6,&d\0\0\0>「$B0\0\0\0¥'\"#□\0\0\0ᵉd、(x\0\0\0⁴²⁶+」\0\0\0\0\0ᵉ▮⁸\0\0\0\0\n゜□⁴\0\0\0\0⁴ᶠ‖\r\0\0\0\0⁴ᶜ⁶ᵉ\0\0\0> ⁘⁴²\0\0\0000⁸ᵉ⁸⁸\0\0\0⁸>\" 「\0\0\0>⁸⁸⁸>\0\0\0▮~「⁘□\0\0\0⁴>$\"2\0\0\0⁸>⁸>⁸\0\0\0<$\"▮⁸\0\0\0⁴|□▮⁸\0\0\0>   >\0\0\0$~$ ▮\0\0\0⁶ &▮ᶜ\0\0\0> ▮「&\0\0\0⁴>$⁴8\0\0\0\"$ ▮ᶜ\0\0\0>\"-0ᶜ\0\0\0、⁸>⁸⁴\0\0\0** ▮ᶜ\0\0\0、\0>⁸⁴\0\0\0⁴⁴、$⁴\0\0\0⁸>⁸⁸⁴\0\0\0\0、\0\0>\0\0\0> (▮,\0\0\0⁸>0^⁸\0\0\0   ▮ᵉ\0\0\0▮$$DB\0\0\0²゛²²、\0\0\0>  ▮ᶜ\0\0\0ᶜ□!@\0\0\0\0⁸>⁸**\0\0\0> ⁘⁸▮\0\0\0<\0>\0゛\0\0\0⁸⁴$B~\0\0\0@(▮h⁶\0\0\0゛⁴゛⁴<\0\0\0⁴>$⁴⁴\0\0\0、▮▮▮>\0\0\0゛▮゛▮゛\0\0\0>\0> 「\0\0\0$$$ ▮\0\0\0⁘⁘⁘T2\0\0\0²²\"□ᵉ\0\0\0>\"\"\">\0\0\0>\" ▮ᶜ\0\0\0> < 「\0\0\0⁶  ▮ᵉ\0\0\0\0‖▮⁸⁶\0\0\0\0⁴゛⁘⁴\0\0\0\0\0ᶜ⁸゛\0\0\0\0、「▮、\0\0\0⁸⁴c▮⁸\0\0\0⁸▮c⁴⁸\0\0\0"
  poke(0x5f58,0x81)

  -- enable tile 0 + extended memory
  poke(0x5f36, 0x18)
  -- capture mouse
  -- enable lock+button alias
  poke(0x5f2d,7)

  -- unpack map
  _bsps,_leaves,_start_pos,_start_angle=decompress("q8k",0,0,unpack_map)
  _model=_bsps[1]
  -- restore spritesheet
  reload()
  -- copy unlit tiles to hi mem
  memcpy(0x8000,0x2000,0x1000)

  -- 
  palt(0,false)
  --pal({129, 133, 5, 134, 143, 15, 130, 132, 4, 137, 9, 136, 8, 13, 12},1,1)

  -- start level
  next_state(play_state,_start_pos,_start_angle)
end

function _update()
  -- any futures?
  for i=#_futures,1,-1 do
    -- get actual coroutine
    local f=_futures[i].co
    -- still active?
    if f and costatus(f)=="suspended" then
      assert(coresume(f))
    else
      deli(_futures,i)
    end
  end

	update_state()

  -- always update
  _plyr:update()
  -- always track
  _cam:track(_plyr.eye_pos,_plyr.m,_plyr.angle)
end

function padding(n)
	n=tostr(min(n,99)\1)
	return sub("00",1,2-#n)..n
end

function time_tostr(t)
	-- note: assume minutes doesn't go > 9
	return (t\1800).."'"..padding((t\30)%60).."''"..padding(flr(10*t/3)%100)
end

function _draw()
  cls()
  
  -- _cam:draw_faces(door.verts,door.faces,_leaves,door.leaf_start,door.leaf_end)

  -- collect leaves with moving brushes
  local visleaves,visframe=_cam:collect_leaves(_model.bsp,_leaves)

  local out={}
  for i=2,#_bsps do
    local door=_bsps[i]
    -- does the brush belong to a visible node?
    if door.solid and door.first_node and door.first_node.visframe==visframe then
      -- don't clip invisible places
      local cam_pos,door_pos,verts,faces=v_add(_cam.origin,door.origin,-1),door.origin,door.verts,door.faces   
      local brush_verts=setmetatable({},{__index=function(t,vi)
        -- "move" brush        
        local v=v_add({verts[vi],verts[vi+1],verts[vi+2]},door_pos)
        t[vi]=v
        return v
      end})
      for j=door.leaf_start,door.leaf_end do
        local leaf=_leaves[j]    
        -- face index
        for i,fi in inext,leaf do
          local fn=faces[fi]
          -- clip only visible faces
          if plane_dot(fn,cam_pos)<faces[fi+1]!=(faces[fi+2]&1==0) then 
            local poly,face_verts,uvi={fi=fi},faces[fi+3],faces[fi+5]
            for k,vi in inext,face_verts do
              local v=brush_verts[vi]
              -- copy v
              v={v[1],v[2],v[3]}
              if uvi!=-1 then
                local kuv=uvi+(k<<1)
                v.u=_texcoords[kuv-1]
                v.v=_texcoords[kuv]
              end
              poly[k]=v
            end
            -- clip against world
            bsp_clip(door.first_node,poly,out,uvi!=-1)
          end
        end
      end
    end
  end

  _cam:draw_faces(_model.verts,_model.faces,visleaves,1,#visleaves,out)
  
  draw_state()

  if(_msg) printb(_msg,nil,80,6,1)

  -- set screen palette (color ramp 8 is neutral)
  memcpy(0x5f10,0x4300+16*8,16)
  print(flr(stat(0)).."kB",2,2,7)
end

-->8
-- data unpacking functions
-- unpack 1 or 2 bytes
function unpack_variant()
	local h=mpeek()
	-- above 127?
  if h&0x80>0 then
    h=(h&0x7f)<<8|mpeek()
  end
	return h
end
-- unpack a fixed 16:16 value
function unpack_fixed()
	return mpeek()<<8|mpeek()|mpeek()>>8|mpeek()>>16
end

-- unpack an array of bytes
function unpack_array(fn,name)
  local mem0=stat(0)
	for i=1,unpack_variant() do
		fn(i)
	end
  if(name) printh(name..":\t"..ceil(stat(0)-mem0).."kb")
end

-- reference
function unpack_ref(a)
  local n=unpack_variant()
  local r=a[n]
  assert(r,"invalid reference: "..n)
  return r
end

-- unpack a 3d vertex
function unpack_vert(verts)
  verts=verts or {}
  for i=1,3 do
    add(verts,unpack_fixed())
  end
  return verts
end

-- valid chars for model names
function unpack_string()
	local s=""
	unpack_array(function()
		s..=chr(mpeek())
	end)
	return s
end

-- bsp map reader
function unpack_map()
  local verts,planes,faces,leaves,nodes,models,uvs,clipnodes={},{},{},{},{},{},{},{}
  
  printh("------------------------")
  -- hw colors (16 * 16 colors) + palettes
  for i=0x4300,0x44ff do
    poke(i,mpeek())
  end

  -- vertices
  local vert_sizeof=3

  unpack_array(function()
    unpack_vert(verts)
  end,"verts")

  -- planes
  local plane_sizeof=5
  plane_get=function(pi)
    return planes[pi],planes[pi+1],planes[pi+2]
  end
  plane_dot=function(pi,v)
    local t,d=planes[pi+4],planes[pi+3]
    if t<3 then    
      return planes[pi+t]*v[t+1],d
    end
    return planes[pi]*v[1]+planes[pi+1]*v[2]+planes[pi+2]*v[3],d
  end
  plane_isfront=function(pi,v)
    local t,d=planes[pi+4],planes[pi+3]
    if t<3 then
      return planes[pi+t]*v[t+1]>d
    end
    return planes[pi]*v[1]+planes[pi+1]*v[2]+planes[pi+2]*v[3]>d
  end

  -- classify bbox against plane
  plane_bbox=function(pi,c,e)
    -- cf: https://gdbooks.gitbooks.io/3dcollisions/content/Chapter2/static_aabb_plane.html

    local t,d,s,r=planes[pi+4],planes[pi+3]
    if t<3 then
      local n=planes[pi+t]
      r = e[t+1]*abs(n)    
      -- Compute distance of box center from plane
      s = n*c[t+1] - d          
    else
      -- Compute the projection interval radius of b onto L(t) = b.c + t * p.n
      local nx,ny,nz=planes[pi],planes[pi+1],planes[pi+2]
      r = e[1]*abs(nx) + e[2]*abs(ny) + e[3]*abs(nz)
  
      -- Compute distance of box center from plane
      s = nx*c[1]+ny*c[2]+nz*c[3] - d
    end
    -- Intersection occurs when distance s falls within [-r,+r] interval
    if s<=-r then
      return 1
    elseif s>=r then
      return 2
    end
    return 3  
end,

  unpack_array(function()  
    -- coords
    unpack_vert(planes)
    add(planes,unpack_fixed())
    -- plane type
    add(planes,mpeek())
  end,"planes")  

  -- temporary array
  unpack_array(function()
    add(uvs,{
      s=unpack_vert(),
      u=unpack_fixed(),
      t=unpack_vert(),
      v=unpack_fixed()
    })
  end)

  -- faces
  local face_sizeof=7
  unpack_array(function()
    local base,face_verts,pi,flags=#faces+1,{},plane_sizeof*unpack_variant()+1,mpeek()
    
    -- 0: supporting plane
    add(faces,pi)
    -- 1: cp (placeholder)
    add(faces,0)
    -- 2:flags (side, sky, texture?, lightmap?)
    add(faces,flags)

    unpack_array(function()
      add(face_verts,vert_sizeof*unpack_variant()+1)
    end)
    -- 3: verts indices
    add(faces,face_verts)

    -- texture (if any)
    if flags&0x2!=0 then      
      -- 4: base light (e.g. ramp)
      add(faces,mpeek()) 
      -- texture coordinates (reference)
      local texcoords=unpack_ref(uvs)
      -- 5: start of uv coords
      add(faces,#_texcoords)
      -- 6: texture map (reference)
      add(faces,unpack_variant())
      -- precompute textures coordinates
      local umin,vmin=unpack_fixed(),unpack_fixed()
      for vi in all(face_verts) do
        local v={verts[vi],verts[vi+1],verts[vi+2]}
        add(_texcoords,v_dot(texcoords.s,v)+texcoords.u-umin)
        add(_texcoords,v_dot(texcoords.t,v)+texcoords.v-vmin)
      end
    else
      -- 4: color (static)
      add(faces,mpeek()) 
      for i=1,2 do
        add(faces,-1)
      end      
    end

    -- "fix" cp value
    local vi=face_verts[1]
    faces[base+1]=plane_dot(pi,{verts[vi],verts[vi+1],verts[vi+2]})
  end,"faces")

  -- lightmap maps
  unpack_array(function()
    -- convert to tline coords
    local flag=mpeek()
    if flag!=0 then
      add(_maps,mpeek())
      --add(_maps,(texaddr<<16)&0xff)
      add(_maps,unpack_fixed())
    else
      local height,size,bytes=mpeek(),mpeek(),{}
      -- stride (32bits padded)
      add(_maps,(size\height)<<2)
      -- data
      add(_maps,bytes)
      -- copy to ram
      for i=1,size do
        add(bytes,unpack_fixed())
      end      
    end
  end,"maps")
  
  unpack_array(function(i)
    local pvs={}
    local l=add(leaves,{
      -- get 0-based index of leaf
      -- leaf 0 is "solid" leaf
      -- id=i-1,
      contents=mpeek()-128,
      pvs=pvs
    })

    -- potentially visible set    
    unpack_array(function()
      pvs[unpack_variant()]=unpack_fixed()
    end)
    
    unpack_array(function()
      add(l,face_sizeof*unpack_variant()+1)
    end)
  end,"leaves")

  unpack_array(function()
    local pi=plane_sizeof*unpack_variant()+1
    -- merge plane and node
    add(nodes,{
      flags=mpeek(),
      [true]=unpack_variant(),
      [false]=unpack_variant(),
      plane=pi
    })
  end,"nodes")
  -- attach nodes/leaves
  for _,node in pairs(nodes) do
    local function attach_node(side,leaf)
      local refs=leaf and leaves or nodes
      -- make sure contents is always set
      local child=refs[node[side]] or {contents=-2}
      node[side]=child
      -- used to optimize bsp traversal for rendering
      child.parent=node
    end
    attach_node(true,node.flags&0x1!=0)
    attach_node(false,node.flags&0x2!=0)
  end
  
  -- shared content leaves
  local content_types={}
  for i=1,6 do
    -- -1: ordinary leaf
    -- -2: the leaf is entirely inside a solid (nothing is displayed).
    -- -3: Water, the vision is troubled.
    -- -4: Slime, green acid that hurts the player.
    -- -5: Lava, vision turns red and the player is badly hurt.   
    -- -6: sky 
    add(content_types,{contents=-i})
  end  
  -- unpack "clipnodes" (collision hulls)
  local clipnodes={}
  unpack_array(function()
    local node,flags={plane=plane_sizeof*unpack_variant()+1},mpeek()
    -- either empty, lava, ... or reference to a another half-space
    local contents=flags&0xf
    node[true]=contents!=0 and -contents or unpack_variant()
    contents=(flags&0xf0)>>4
    node[false]=contents!=0 and -contents or unpack_variant()
    add(clipnodes,node)
  end)
  -- attach references
  for node in all(clipnodes) do
    local function attach_node(side)
      local id=node[side]
      node[side]=id<0 and content_types[-id] or clipnodes[id]
    end
    attach_node(true)
    attach_node(false)
  end

  -- unpack "models"  
  unpack_array(function(i)  
    add(models,{
      origin={0,0,0},
      solid=true,
      verts=verts,
      planes=planes,
      faces=faces,
      bsp=unpack_ref(nodes),
      clipnodes=unpack_ref(clipnodes),
      leaf_start=unpack_variant(),
      leaf_end=unpack_variant()})
  end,"models")

  -- unpack player position
  -- todo: merge with general entities decode
  local plyr_pos,plyr_angle=unpack_vert(),unpack_fixed()
  
  -- triggers
  unpack_array(function()
    -- standard triggers parameters
    local flags,model,delay,wait,msg,targets=mpeek(),unpack_ref(models),unpack_variant(),0
    -- triggers are not solid
    model.solid=nil
    if flags&2!=0 then
      msg=unpack_string()
    end
    -- wait until reactivate
    if flags&1!=0 then
      wait=unpack_variant()
    end
    -- teleport trigger
    if flags&4!=0 then
      targets={}
      wait=5
      unpack_array(function()
        add(targets,{origin=unpack_vert(),dir=unpack_vert(),angle=unpack_fixed()})
      end)
    end
    do_async(function()
      while true do
        local hit=find_sub_sector(model.clipnodes,_plyr.origin)
        -- inside volume?
        if hit and hit.contents==-2 then
          wait_async(delay)
          if(msg) _msg=msg
          -- teleport?
          if targets then
            -- todo: sfx
            local target=rnd(targets)
            _plyr:orient(target.origin,target.dir,flags&8!=0 and target.angle)
          end
          -- trigger once?
          wait_async(wait>0 and wait or 60)
          -- clear text message
          _msg=nil
          -- reapeat?
          if wait==0 then
              return
          end
        end
        yield()
      end
    end)
  end)

  -- doors
  unpack_array(function()
    -- standard triggers parameters
    local flags,pusher,wait,speed,mins,maxs,pos1,pos2,triggered=mpeek(),unpack_ref(models),unpack_variant(),unpack_variant(),unpack_vert(),unpack_vert(),unpack_vert(),unpack_vert()    
    pusher.mins=mins
    pusher.maxs=maxs
    pusher.nodes={}

    pvs_register(models[1].bsp,pusher)

    local move=make_v(pos1,pos2)
    v_scale(move,1/30)
    local function testEntityPosition(ent)
      local valid=true
      for i,model in inext,models do
        if model.solid then
          -- find if origin is not in solid space
          local is_valid=find_sub_sector(model.clipnodes,make_v(model.origin,ent.origin)).contents!=-2
          valid=valid and is_valid
        end
      end
      return valid
    end

    pusher.touch=function()    
      -- avoid reentrancy
      if(triggered) return
      triggered=true
      do_async(function()
        while true do
          -- todo: include speed
          local i=0
          while i<30 do 
            local pushorig = v_clone(pusher.origin)
            -- move the pusher to it's final position
            pusher.origin = v_add(pusher.origin,move)
      
            local old_orig
         
            -- if the entity is standing on the pusher, it will definitely be moved
            if _plyr.ground ~= pusher then
              --[[
              -- outside of move box?
              if check.absmins[1] >= maxs[1]
              or check.absmins[2] >= maxs[2]
              or check.absmins[3] >= maxs[3]
              or check.absmaxs[1] <= mins[1]
              or check.absmaxs[2] <= mins[2]
              or check.absmaxs[3] <= mins[3] then
                printh("player off path")
                goto continue
              end
              ]]
              -- see if the ent's bbox is inside the pusher's final position
              if testEntityPosition(_plyr) then
                goto continue
              end
            end

            -- try moving the contacted entity 
            old_orig=v_clone(_plyr.origin)
            _plyr.origin = v_add(_plyr.origin, move)
            -- printh("moving "..check.classname.." from: "..v_tostring(moved[check]).." to: "..v_tostring(check.origin))
            
            if testEntityPosition(_plyr) then
              goto continue
            end

            -- if it is ok to leave in the old position, do it
            -- occurs when entity blocked by something else
            _plyr.origin = old_orig
            if testEntityPosition(_plyr) then
              goto continue
            end

            -- failed move
            pusher.origin = pushorig

            -- if the pusher has a "blocked" function, call it
            --  otherwise, just stay in place until the obstacle is gone
            -- vm:call(pusher,"blocked", check)
            
            -- move back any entities we already moved
            _plyr.origin = old_orig
            goto blocked
::continue::
            -- pusher can move, increment local time
            i+=1
            pvs_register(models[1].bsp,pusher)
::blocked::
            yield()
          end

          -- trigger once?
          if wait>0 then
            wait_async(wait)
            -- flip target/end
            v_scale(move,-1)
            -- todo: snap to origin            
          else
            return
          end
        end
      end)
    end
  end)

  return models,leaves,plyr_pos,plyr_angle
end