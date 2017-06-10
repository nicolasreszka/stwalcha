--Author : Nicolas Reszka

AnimatedText = {}
AnimatedText.__index = AnimatedText

function AnimatedText.new(x,y,text,time,offset,limit,colorMode,style)
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
	animatedText.colorMode = colorMode or "rainbow"
	animatedText.colors = {
		RED:clone(),
		Color.new(255,16,0),
		Color.new(255,128,0),
		YELLOW:clone(),
		GREEN:clone(),
		CYAN:clone(),
		BLUE:clone(),
		Color.new(128,0,255)
	}
	animatedText.colorIndex = 1

	if animatedText.colorMode == "rainbow" then
		animatedText.color = RED:clone()
	else
		animatedText.color = animatedText.colors[colorMode]
	end

	animatedText.limit = limit
	animatedText.style = style or "normal"
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
	self.xOffset = linear(0, self.xOffsetMax, self.clock)
	if self.colorMode == "rainbow" then	
		local nextColorIndex = self.colorIndex + 1
		if nextColorIndex > 8 then
			nextColorIndex = 1
			self.colorIndex = 1
		end
		self.color:transform(8,self.colors[nextColorIndex])
		if self.color:compare(self.colors[nextColorIndex]) then
			self.colorIndex = self.colorIndex + 1
		end
	end
end

function AnimatedText:draw()
	for i = 0, self.xOffset+1 do
		if i == self.xOffset+1 then
			self.color:set()
		else
			local p = (i/self.xOffset)
			love.graphics.setColor(
				p*self.color.red,
				p*self.color.green,
				p*self.color.blue
			)
		end

		if self.style == "normal" then
			love.graphics.printf(
				self.text,
				self.x+i*self.direction,self.y+i,
				self.limit,"center",
				math.rad(self.xOffset/2*self.direction)
			)
		elseif self.style == "horizontal" then
			love.graphics.printf(
				self.text,
				self.x-i,self.y,
				self.limit,"center"
			)
		end
	end
end