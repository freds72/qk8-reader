-- plain color polygon rasterization
-- plain color polygon rasterization
-- credits: 
function polyfill(p,c)
	color(c)
	local miny,maxy,minx,maxx,mini,minix=32000,-32000,32000,-32000
	-- find extent
	for i,v in pairs(p) do
		local x,y=v.x,v.y
		if (x<minx) minix,minx=i,x
		if (x>maxx) maxx=x
		if (y<miny) mini,miny=i,y
		if (y>maxy) maxy=y
	end

	-- find smallest iteration area
	if abs(minx-maxx)<abs(miny-maxy) then
		--data for left and right edges:
		local np,li,lj,ri,rj,lx,rx,ly,ldy,ry,rdy=#p,minix,minix,minix,minix,minx-1,minx-1

		--step through scanlines.
		for x=max(0,1+minx&-1),min(maxx,127) do
			--maybe update to next vert
			while lx<x do
				li=lj
				lj+=1
				if (lj>np) lj=1
				local v0,v1=p[li],p[lj]
				local x0,x1=v0.x,v1.x
				lx=x1&-1
				ly=v0.y
				ldy=(v1.y-ly)/(x1-x0)
				--sub-pixel correction
				ly+=(x-x0)*ldy
			end   
			while rx<x do
				ri=rj
				rj-=1
				if (rj<1) rj=np
				local v0,v1=p[ri],p[rj]
				local x0,x1=v0.x,v1.x
				rx=x1&-1
				ry=v0.y
				rdy=(v1.y-ry)/(x1-x0)
				--sub-pixel correction
				ry+=(x-x0)*rdy
			end
			rectfill(x,ly,x,ry)
			--pset(x,ly,0)
			--pset(x,ry,0)
			ly+=ldy
			ry+=rdy
		end
	else
		--data for left & right edges:
		local np,li,lj,ri,rj,ly,ry,lx,ldx,rx,rdx=#p,mini,mini,mini,mini,miny-1,miny-1

		--step through scanlines.
		for y=max(0,1+miny&-1),min(maxy,127) do
			--maybe update to next vert
			while ly<y do
				li=lj
				lj+=1
				if (lj>np) lj=1
				local v0,v1=p[li],p[lj]
				local y0,y1=v0.y,v1.y
				ly=y1&-1
				lx=v0.x
				ldx=(v1.x-lx)/(y1-y0)
				--sub-pixel correction
				lx+=(y-y0)*ldx
			end   
			while ry<y do
				ri=rj
				rj-=1
				if (rj<1) rj=np
				local v0,v1=p[ri],p[rj]
				local y0,y1=v0.y,v1.y
				ry=y1&-1
				rx=v0.x
				rdx=(v1.x-rx)/(y1-y0)
				--sub-pixel correction
				rx+=(y-y0)*rdx
			end
			rectfill(lx,y,rx,y)
			--pset(lx,y,0)
			--pset(rx,y,0)
			lx+=ldx
			rx+=rdx
		end
	end
end

function polyline(v,c)
	color(c)
	local nv=#v
	for i,p1 in pairs(v) do
		local p0=v[i%nv+1]
		line(p0.x,p0.y,p1.x,p1.y)
	end
end

function tpoly(v)
	local nv,spans=#v,{}
	-- ipairs is slower for small arrays
	for i=1,#v do
		local p0,p1=v[i%nv+1],v[i]
		local x0,y0,w0,x1,y1,w1=p0.x,p0.y,p0.w,p1.x,p1.y,p1.w
		local u0,v0,u1,v1=p0.u*w0,p0.v*w0,p1.u*w1,p1.v*w1
		if(y0>y1) x0,y0,x1,y1,w0,w1,u0,v0,u1,v1=x1,y1,x0,y0,w1,w0,u1,v1,u0,v0
		local dy=y1-y0
		local cy0,dx,dw,du,dv=(y0&-1)+1,(x1-x0)/dy,(w1-w0)/dy,(u1-u0)/dy,(v1-v0)/dy
		if(y0<0) x0-=y0*dx w0-=y0*dw u0-=y0*du v0-=y0*dv y0=0 cy0=0
		-- sub-pix shift
		local sy=cy0-y0
		x0+=sy*dx
		w0+=sy*dw
		u0+=sy*du
		v0+=sy*dv
		if(y1>127) y1=127
		for y=cy0,y1 do
			local span=spans[y]
			if span then
				-- backup current edge values
				local b,bu,bv,bw,a,au,av,aw=x0,u0,v0,w0,span.x,span.u,span.v,span.w
				if(a>b) a,au,av,aw,b,bu,bv,bw=b,bu,bv,bw,span.x,span.u,span.v,span.w
			 
				local x0,x1=(a&-1)+1,b&-1
				if(x1>127) x1=127
				if x0<=x1 then
					local dab=b-a
					local dau,dav,daw=(bu-au)/dab,(bv-av)/dab,(bw-aw)/dab
					-- sub-pix shift
					local sa=x0-a
					if(x0<0) au-=x0*dau av-=x0*dav aw-=x0*daw x0=0 sa=0
					au+=sa*dau
					av+=sa*dav
					aw+=sa*daw
					
					-- 4-pixel stride deltas
					dau<<=3
					dav<<=3
					daw<<=3
					
						-- faster but produces edge artifacts
						-- local du,dv=(bu/bw-au/aw)/dab,(bv/bw-av/aw)/dab

					-- clip right span edge
					poke(0x5f22,x1+1)

					for x=x0,x1,8 do
						local u,v=au/aw,av/aw
						aw+=daw
						tline(x,y,x+7,y,u,v,((dau-u*daw)>>3)/aw,((dav-v*daw)>>3)/aw)
						au+=dau
						av+=dav
					end
				end
			else
				spans[y]={x=x0,u=u0,v=v0,w=w0}
			end
			x0+=dx
			w0+=dw
			u0+=du
			v0+=dv
		end
	end
end

function mempoly(v,col)
	col&=0xf
	local c,c0,c1=col*0x11,col<<4,col
	local nv,nodes=#v,{}
	for i=1,#v do
		local v0,v1=v[i%nv+1],v[i]
		local x0,y0,x1,y1=v0.x>>1,v0.y>>1,v1.x>>1,v1.y>>1
		if(y0>y1) x0,y0,x1,y1=x1,y1,x0,y0
		local cy0,dx=y0\1+1,(x1-x0)/(y1-y0)
		if(y0<0) x0-=y0*dx y0=0 cy0=0
		x0+=(cy0-y0)*dx
		if(y1>64) y1=64
		for y=cy0,y1 do
			local x=nodes[y]
			if x then
				local x0,x1=x,x0
				if(x0>x1) x0,x1=x1,x0
				if(x0<0) x0=0
				if(x1>64) x1=64
				if x1>=x0 then
					-- odd boundary?
					local off=x0\2
					local p,w=0x1000|y<<6|off,x1\2-off+1
					if (x0 & 1)!=0 then
						w-=1
						poke(p,@p & 0x0f | c0)
						p+=1
					end
					if x1&1==0 then
						w-=1
						poke(p+w,@(p+w) & 0xf0 | c1)
					end
					memset(p,c,w)         				
				end
			else
			nodes[y]=x0
			end
			x0+=dx					
		end			
	end
end