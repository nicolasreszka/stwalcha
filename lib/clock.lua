Clock = {}
Clock.__index = Clock

function Clock.new(duration)
	local clock = {}
	setmetatable(clock, Clock)
	clock.time = 0
	clock.duration = duration
	return clock
end

function Clock:tick()
	self.time = approachValues(
		self.time, 
		self.duration, 
		love.timer.getDelta()
	)
end

function Clock:rewind()
	self.time = approachValues(
		self.time, 
		0, 
		love.timer.getDelta()
	)
end 

function Clock:setDuration(duration)
	self.duration = duration
end

function Clock:reset()
	self.time = 0
end

function Clock:alarm()
	return self.time == self.duration
end
