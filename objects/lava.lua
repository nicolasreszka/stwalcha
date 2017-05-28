Lava = {}
Lava.__index = Lava

function Lava.new()
	local lava = {}
	setmetatable(lava, Lava)
	lava.line = Line.new(
		-32,mapHeight*0.75,
		mapWidth+32,mapHeight*0.75
	)
	lava.move = 0
	lava.k = 0.5
	lava.divide = false
	lava.state = "low"
	lava.offsetDirection = -0.25
	lava.offsetClock = Clock.new(2)
	lava.moveClock = Clock.new(4.5)
	return lava
end

function Lava:update(dt)
	self.offsetClock:tick()
	if self.offsetClock:alarm() then
		self.offsetDirection = self.offsetDirection * -1
		self.offsetClock:reset()
	end
	
	self.line.a.y = self.line.a.y + self.offsetDirection
	self.line.b.y = self.line.b.y - self.offsetDirection


	self.moveClock:tick()
	if self.moveClock:alarm() then
		if self.state == "low" then
			self.move = -1
			self.state = "ascending"
			self.moveClock:setDuration(4.5)
		elseif self.state == "ascending" then
			self.move = 0
			self.state = "high"
			self.moveClock:setDuration(6)
		elseif self.state == "high" then
			self.move = 1
			self.state = "descending"
			self.moveClock:setDuration(4.5)
		elseif self.state == "descending" then
			self.move = 0
			self.state = "low"
			self.moveClock:setDuration(6)
			if self.divide then
				self.k = self.k / 2
				if self.k <= 0.5 then
					self.divide = false
				end
			else	
				self.k = self.k * 2
				if self.k >= 1 then
					self.divide = true
				end
			end
		end
		self.moveClock:reset()
	end
	
	self.line.a.y = self.line.a.y + (self.move * self.k)
	self.line.b.y = self.line.b.y + (self.move * self.k)
end

function Lava:draw()
	love.graphics.setColor(255,0,0,92)
	love.graphics.polygon("fill",
		{
			self.line.a.x,self.line.a.y,
			self.line.b.x,self.line.b.y,
			self.line.b.x,mapHeight+32,
			self.line.a.x,mapHeight+32
		}
	)
end