function inExpo(begin, change, clock)
	if clock.time == 0 then 
		return begin
	else 
		return change*math.pow(2, 10 * (clock.time/clock.duration - 1)) + begin
	end
end

function outExpo(begin, change, clock)
	if clock.time == clock.duration then 
		return begin + change 
	else
		return change*(-math.pow(2, -10 * clock.time/clock.duration)+1) + begin
	end
end

function inOutExpo(begin, change, clock)
	if clock.time == 0 then 
		return begin
	end
	if clock.time == d then 
		return begin + change
	end
	local time = clock.time/clock.duration * 2
	if time < 1 then 
		return change/2 * math.pow(2, 10 * (time-1)) + begin
	end
	return change/2 * (-math.pow(2, -10 * (time-1)) + 2) + begin
end