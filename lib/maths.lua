function sign(n)
	if n < 0 then
		return -1
	elseif n > 0 then
		return 1
	else
		return 0
	end
end

function round(n,decimal) 
	decimal = 10^(decimal or 0) 
	return math.floor(n*decimal+0.5)/decimal
end

function clamp(n,low,high) 
	return math.min(math.max(low, n), high) 
end

function lengthDirectionX(length,direction)
	return length * math.cos(direction)
end

function lengthDirectionY(length,direction)
	return length * math.sin(direction)
end

function distance(a,b)
	return math.sqrt((a.x-b.x)^2+(a.y-b.y)^2)
end

function angle(a,b) 
	return math.atan2(b.y-a.y, b.x-a.x) 
end

function approachValues(begin,change,shift)
	if begin < change then
		return math.min(begin + shift, change)
	else 
		return math.max(begin - shift, change)
	end
end