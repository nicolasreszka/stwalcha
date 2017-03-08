function sign(n)
	if n < 0 then
		return -1
	elseif n > 0 then
		return 1
	else
		return 0
	end
end

function distance(a,b)
	return math.sqrt((a.x-b.x)^2+(a.y-b.y)^2)
end

function approachValues(begin,change,shift)
	if begin < change then
		return math.min(begin + shift, change)
	else 
		return math.max(begin - shift, change)
	end
end
