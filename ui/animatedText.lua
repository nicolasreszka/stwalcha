--Author : Nicolas Reszka

AnimatedText = {}
AnimatedText.__index = AnimatedText

function AnimatedText.new(x,y,text,time,offset,limit)
	local animatedText = {}
	setmetatable(animatedText, AnimatedText)
	animatedText.x = x
	animatedText.y = y
	animatedText.text = text
	animatedText.clock = Clock.new(time)
	animatedText.finished = false
	animatedText.xOffset = 1
	animatedText.xOffsetMax = offset or 10 
	animatedText.direction = -1
	animatedText.colors = {
		RED:clone(),
		Color.new(255,16,0),
		Color.new(255,128,0),
		YELLOW:clone(),
		GREEN:clone(),
		BLUE:clone(),
		Color.new(128,0,255)
	}
	animatedText.colorIndex = 1
	animatedText.color = RED:clone()
	animatedText.limit = limit
	return animatedText
end

function AnimatedText:update(dt) 
	if self.finished then
		self.clock:rewind()
		if self.clock:zero() then
			self.finished = false
			self.direction = self.direction * -1
		end
	else
		self.clock:tick()
		if self.clock:alarm() then
			self.finished = true
		end
	end
	self.xOffset = linear(1, self.xOffsetMax, self.clock)
	local nextColorIndex = self.colorIndex + 1
	if nextColorIndex > 7 then
		nextColorIndex = 1
		self.colorIndex = 1
	end
	self.color:transform(4,self.colors[nextColorIndex])
	if self.color:compare(self.colors[nextColorIndex]) then
		self.colorIndex = self.colorIndex + 1
	end

end

function AnimatedText:draw()
	for i = 0, self.xOffset do
		local p = (i/self.xOffset)
		love.graphics.setColor(
			p*self.color.red,
			p*self.color.green,
			p*self.color.blue
		)
		love.graphics.printf(
			self.text,
			self.x+i*self.direction,self.y+i,
			self.limit,"center",
			math.rad(self.xOffset/2*self.direction)
		)
	end
end