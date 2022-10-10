-- plain color polygon rasterization
function polyfill(p,np,c)
	color(c)
	local miny,maxy,mini=32000,-32000
	-- find extent
	for i=1,np do
		local v=p[i]
		local y=v.y
		if (y<miny) mini,miny=i,y
		if (y>maxy) maxy=y
	end

	--data for left & right edges:
	local lj,rj,ly,ry,lx,ldx,rx,rdx=mini,mini,miny-1,miny-1
	--step through scanlines.
	if(maxy>127) maxy=127
	if(miny<0) miny=-1
	for y=1+miny&-1,maxy do
		--maybe update to next vert
		while ly<y do
			local v0=p[lj]
			lj+=1
			if (lj>np) lj=1
			local v1=p[lj]
			local y0,y1=v0.y,v1.y
			ly=y1&-1
			lx=v0.x
			ldx=(v1.x-lx)/(y1-y0)
			--sub-pixel correction
			lx+=(y-y0)*ldx
		end   
		while ry<y do
			local v0=p[rj]
			rj-=1
			if (rj<1) rj=np
			local v1=p[rj]
			local y0,y1=v0.y,v1.y
			ry=y1&-1
			rx=v0.x
			rdx=(v1.x-rx)/(y1-y0)
			--sub-pixel correction
			rx+=(y-y0)*rdx
		end
		rectfill(rx,y,lx,y)
		lx+=ldx
		rx+=rdx
	end
end

function polytex_ymajor(p,np,angle)
	local miny,maxy,mini=32000,-32000
	-- find extent
	for i=1,np do
		local v=p[i]
		local y=v.y
		if (y<miny) mini,miny=i,y
		if (y>maxy) maxy=y
	end

	--data for left & right edges:
	local lj,rj,ly,ry,lx,ldx,rx,rdx,lu,ldu,lv,ldv,ru,rdu,rv,rdv,lw,ldw,rw,rdw=mini,mini,miny-1,miny-1

	local stride=max(3,(7*(1-angle))\1)
	local len=1<<stride
	--step through scanlines.
	if(maxy>127) maxy=127
	if(miny<0) miny=-1
	for y=1+miny&-1,maxy do
		--maybe update to next vert
		while ly<y do
			local v0=p[lj]
			lj+=1
			if (lj>np) lj=1
			local v1=p[lj]
			local y0,y1=v0.y,v1.y
			ly=y1&-1
			lx=v0.x
			lw=v0.w
			lu=v0.u*lw
			lv=v0.v*lw
			ldx=(v1.x-lx)/(y1-y0)
			ldu=(v1.u*v1.w-lu)/(y1-y0)
			ldv=(v1.v*v1.w-lv)/(y1-y0)
			ldw=(v1.w-lw)/(y1-y0)
			--sub-pixel correction
			local dy=y-y0
			lx+=dy*ldx
			lu+=dy*ldu
			lv+=dy*ldv
			lw+=dy*ldw
		end   
		while ry<y do
			local v0=p[rj]
			rj-=1
			if (rj<1) rj=np
			local v1=p[rj]
			local y0,y1=v0.y,v1.y
			ry=y1&-1
			rx=v0.x
			rw=v0.w
			ru=v0.u*rw
			rv=v0.v*rw
			rdx=(v1.x-rx)/(y1-y0)
			rdu=(v1.u*v1.w-ru)/(y1-y0)
			rdv=(v1.v*v1.w-rv)/(y1-y0)
			rdw=(v1.w-rw)/(y1-y0)
			--sub-pixel correction
			local dy=y-y0
			rx+=dy*rdx
			ru+=dy*rdu
			rv+=dy*rdv
			rw+=dy*rdw
		end
		--rectfill(rx,y,lx,y,12)
		do
			local rx,lx,ru,rv,rw=rx,lx,ru,rv,rw
			local ddx=lx-rx--((lx+0x1.ffff)&-1)-(rx&-1)
			local ddu,ddv,ddw=(lu-ru)/ddx,(lv-rv)/ddx,(lw-rw)/ddx
			if(rx<0) ru-=rx*ddu rv-=rx*ddv rw-=rx*ddw rx=0
			local pix=1-rx&0x0.ffff
			ru+=pix*ddu
			rv+=pix*ddv
			rw+=pix*ddw

			-- stride factor
			ddu<<=stride
			ddv<<=stride
			ddw<<=stride

			-- clip right span edge
			if(lx>127) lx=127
			poke(0x5f22,lx+1)

			for x=rx,lx,len do
				local u,v=ru/rw,rv/rw
				rw+=ddw
				tline(x,y,x+len-1,y,u,v,((ddu-u*ddw)/rw)>>stride,((ddv-v*ddw)/rw)>>stride)
				--pset(x+len-0.5,y,15)
				ru+=ddu
				rv+=ddv
			end
		end

		lx+=ldx
		lu+=ldu
		lv+=ldv
		lw+=ldw
		rx+=rdx
		ru+=rdu
		rv+=rdv
		rw+=rdw
	end
	poke(0x5f22,128)
end



function polytex_xmajor(p,np,angle)
	local minx,maxx,mini=32000,-32000
	-- find extent
	for i=1,np do
		local v=p[i]
		local x=v.x
		if (x<minx) mini,minx=i,x
		if (x>maxx) maxx=x
	end

	--data for left & right edges:
	local lj,rj,lx,rx,ly,ldy,ry,rdy,lu,ldu,lv,ldv,ru,rdu,rv,rdv,lw,ldw,rw,rdw=mini,mini,minx-1,minx-1

	local stride=max(3,(7*(1-angle))\1)
	local len=1<<stride

	--step through scanlines.
	if(maxx>127) maxx=127
	if(minx<0) minx=-1	
	for x=1+minx&-1,maxx do
		--maybe update to next vert
		while lx<x do
			local v0=p[lj]
			lj+=1
			if (lj>np) lj=1
			local v1=p[lj]
			local x0,x1=v0.x,v1.x
			lx=x1&-1
			ly=v0.y
			lw=v0.w
			lu=v0.u*lw
			lv=v0.v*lw
			local dx=x1-x0
			ldy=(v1.y-ly)/dx
			ldu=(v1.u*v1.w-lu)/dx
			ldv=(v1.v*v1.w-lv)/dx
			ldw=(v1.w-lw)/dx
			--sub-pixel correction
			dx=x-x0
			ly+=dx*ldy
			lu+=dx*ldu
			lv+=dx*ldv
			lw+=dx*ldw
		end   
		while rx<x do
			local v0=p[rj]
			rj-=1
			if (rj<1) rj=np
			local v1=p[rj]
			local x0,x1=v0.x,v1.x
			rx=x1&-1
			ry=v0.y
			rw=v0.w
			ru=v0.u*rw
			rv=v0.v*rw
			local dx=x1-x0
			rdy=(v1.y-ry)/dx
			rdu=(v1.u*v1.w-ru)/dx
			rdv=(v1.v*v1.w-rv)/dx
			rdw=(v1.w-rw)/dx
			--sub-pixel correction
			dx=x-x0
			ry+=dx*rdy
			ru+=dx*rdu
			rv+=dx*rdv
			rw+=dx*rdw
		end
		--rectfill(rx,y,lx,y,12)
		do
			local ry,ly,ru,rv,rw,lu,lv,lw=ly,ry,lu,lv,lw,ru,rv,rw
			local ddy=ly-ry--((lx+0x1.ffff)&-1)-(rx&-1)
			local ddu,ddv,ddw=(lu-ru)/ddy,(lv-rv)/ddy,(lw-rw)/ddy
			if(ry<0) ru-=ry*ddu rv-=ry*ddv rw-=ry*ddw ry=0
			local pix=1-ry&0x0.ffff
			ru+=pix*ddu
			rv+=pix*ddv
			rw+=pix*ddw

			-- stride factor
			ddu<<=stride
			ddv<<=stride
			ddw<<=stride

			-- clip right span edge
			if(ly>127) ly=127
			poke(0x5f23,ly+1)

			for y=ry,ly,len do
				local u,v=ru/rw,rv/rw
				rw+=ddw
				tline(x,y,x,y+len-1,u,v,((ddu-u*ddw)/rw)>>stride,((ddv-v*ddw)/rw)>>stride)
				--printh(rw.." "..ddu.." "..(ddu-u*ddw).." @"..stride)
				-- pset(x,y+len-0.5,12)
				ru+=ddu
				rv+=ddv
			end
		end
		
		ly+=ldy
		lu+=ldu
		lv+=ldv
		lw+=ldw
		ry+=rdy
		ru+=rdu
		rv+=rdv
		rw+=rdw
	end
	poke(0x5f23,128)
end