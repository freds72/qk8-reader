-- plain color polygon rasterization
function polyfill(p,np,c)
	color(c)
	local v0=p[np]
	for i=1,np do
		local v1=p[i]
		line(v0.x,v0.y,v1.x,v1.y)
		v0=v1
	end
end

function polytex_ymajor(p,np,angle)
	polyfill(p,np,7)
end

function polytex_xmajor(p,np,angle)
	polyfill(p,np,7)
end