-- plain color polygon rasterization
function polyfill(p,np,c)
	color(c)
	local miny,maxy,mini=32000,-32000
	-- find extent
	for i=1,np do
		local y=p[i].y
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
		local y=p[i].y
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
			-- make sure w gets enough precision
			local y0,y1,w1=v0.y,v1.y,v1.w<<4
			local dy=y1-y0
			ly=y1&-1
			lx=v0.x
			lw=v0.w<<4
			lu=v0.u*lw
			lv=v0.v*lw
			ldx=(v1.x-lx)/dy
			ldu=(v1.u*w1-lu)/dy
			ldv=(v1.v*w1-lv)/dy
			ldw=(w1-lw)/dy
			--sub-pixel correction
			local dy=y-y0
			-- to be fixed when += stops evaluating twice!!
			lx=lx+dy*ldx
			lu=lu+dy*ldu
			lv=lv+dy*ldv
			lw=lw+dy*ldw
		end   
		while ry<y do
			local v0=p[rj]
			rj-=1
			if (rj<1) rj=np
			local v1=p[rj]
			local y0,y1,w1=v0.y,v1.y,v1.w<<4
			local dy=y1-y0
			ry=y1&-1
			rx=v0.x
			rw=v0.w<<4
			ru=v0.u*rw
			rv=v0.v*rw
			rdx=(v1.x-rx)/dy
			rdu=(v1.u*w1-ru)/dy
			rdv=(v1.v*w1-rv)/dy
			rdw=(w1-rw)/dy
			--sub-pixel correction
			local dy=y-y0
			-- to be fixed when += stops evaluating twice!!
			rx=rx+dy*rdx
			ru=ru+dy*rdu
			rv=rv+dy*rdv
			rw=rw+dy*rdw
		end
		--rectfill(rx,y,lx,y,12)
		do
			local rx,lx,ru,rv,rw=rx,lx,ru,rv,rw
			local ddx=lx-rx--((lx+0x1.ffff)&-1)-(rx&-1)
			local ddu,ddv,ddw=(lu-ru)/ddx,(lv-rv)/ddx,(lw-rw)/ddx
			if(rx<0) ru-=rx*ddu rv-=rx*ddv rw-=rx*ddw rx=0
			local pix=1-rx&0x0.ffff
			ru=ru+pix*ddu
			rv=rv+pix*ddv
			rw=rw+pix*ddw

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
		local x=p[i].x
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
			local x0,x1,w1=v0.x,v1.x,v1.w<<4
			lx=x1&-1
			ly=v0.y
			lw=v0.w<<4
			lu=v0.u*lw
			lv=v0.v*lw
			local dx=x1-x0
			ldy=(v1.y-ly)/dx
			ldu=(v1.u*w1-lu)/dx
			ldv=(v1.v*w1-lv)/dx
			ldw=(w1-lw)/dx
			--sub-pixel correction
			dx=x-x0
			ly=ly+dx*ldy
			lu=lu+dx*ldu
			lv=lv+dx*ldv
			lw=lw+dx*ldw
		end   
		while rx<x do
			local v0=p[rj]
			rj-=1
			if (rj<1) rj=np
			local v1=p[rj]
			local x0,x1,w1=v0.x,v1.x,v1.w<<4
			rx=x1&-1
			ry=v0.y
			rw=v0.w<<4
			ru=v0.u*rw
			rv=v0.v*rw
			local dx=x1-x0
			rdy=(v1.y-ry)/dx
			rdu=(v1.u*w1-ru)/dx
			rdv=(v1.v*w1-rv)/dx
			rdw=(w1-rw)/dx
			--sub-pixel correction
			dx=x-x0
			ry=ry+dx*rdy
			ru=ru+dx*rdu
			rv=rv+dx*rdv
			rw=rw+dx*rdw
		end
		--rectfill(rx,y,lx,y,)
		do
			local ry,ly,ru,rv,rw,lu,lv,lw=ly,ry,lu,lv,lw,ru,rv,rw
			local ddy=ly-ry--((lx+0x1.ffff)&-1)-(rx&-1)
			local ddu,ddv,ddw=(lu-ru)/ddy,(lv-rv)/ddy,(lw-rw)/ddy
			if(ry<0) ru-=ry*ddu rv-=ry*ddv rw-=ry*ddw ry=0
			local pix=1-ry&0x0.ffff
			ru=ru+pix*ddu
			rv=rv+pix*ddv
			rw=rw+pix*ddw

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