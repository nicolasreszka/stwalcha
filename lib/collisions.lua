function pointVsRect(point, rect) 
	if point.x <= rect.left or point.x >= rect.right 
	or point.y <= rect.top  or point.y >= rect.bottom then
		return false
	else
		return true
	end
end

function pointVsCircle(point, circle)
	local d = distance(point, circle.pos)

	if d > circle.radius then
		return false
	else 
		return true
	end
end

function circleVsRect(circle, rect) 
	if pointVsCircle(rect:getTopLeft(),circle)
	or pointVsCircle(rect:getTopRight(),circle)
	or pointVsCircle(rect:getBottomLeft(),circle)
	or pointVsCircle(rect:getBottomRight(),circle) then
		return true
	else 
		return false
	end
end

function rectVsRect(rect1,rect2) 
	if rect1.left >= rect2.right or rect1.right <= rect2.left
	or rect1.top >= rect2.bottom or rect1.bottom <= rect2.top then
		return false
	else
		return true
	end
end

function lineVsRect(line, rect)
	
	if (line.a.x <= rect.left and line.b.x <= rect.left) 
	or (line.a.y <= rect.top  and line.b.y <= rect.top) 
	or (line.a.x >= rect.right  and line.b.x >= rect.right) 
	or (line.a.y >= rect.bottom and line.b.y >= rect.bottom) then
		return false
	end

	if pointVsRect(line.a,rect) or pointVsRect(line.b,rect) then
		return true
	end

	local slope = (line.b.y - line.a.y) / (line.b.x - line.a.x)

	local y = slope * (rect.left - line.a.x) + line.a.y
	if y > rect.top and y < rect.bottom then
		return true
	end

	y = slope * (rect.right - line.a.x) + line.a.y
	if y > rect.top and y < rect.bottom then
		return true
	end

	local x = (rect.top - line.a.y) / slope + line.a.x
	if x > rect.left and x < rect.right then
		return true
	end

	x = (rect.bottom - line.a.y) / slope + line.a.x 
	if x > rect.left and x < rect.right then
		return true
	end

	return false
end

