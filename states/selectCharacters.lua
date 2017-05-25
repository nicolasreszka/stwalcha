--Author : Nicolas Reszka

selectCharacters = State.new()

function selectCharacters:load()
	self.selectors = {}
	for slot = 1, 4 do
		self.selectors[slot] = CharacterSelector.new(slot)
	end
	self.selectors[1]:setState("joined")
	self.selectors[2]:setState("joined")
	self.selectors[3]:setState("inactive")
	self.selectors[4]:setState("inactive")
	self.backText = AnimatedText.new(
		32,692,
		"Back",1,
		10,4*32
	)
	self.backButton = Rect.new(32,680,128,64)
	self.backHover = false
	self.wait = Clock.new(.2)
end

function selectCharacters:isEveryoneReady()
	local count = 0
	local someoneIsntReady = false
	for i, selector in pairs(self.selectors) do
		local state = selector:getState()
		if state == "ready" then
			count = count + 1
		elseif state == "joined" then
			someoneIsntReady = true
		end 
	end

	if not someoneIsntReady and count > 1 then
		return true
	else 
		return false
	end
end

function selectCharacters:update(dt)
	
	for i, input in pairs(inputs) do
		input:update()
	end
	
	local isEveryoneLeft = true
	for i, selector in pairs(self.selectors) do
		if not self.wait:alarm() then 
			self.wait:tick()	
		else
			selector:update(dt)
		end
		if selector:getState() ~= "inactive" then
			isEveryoneLeft = false
		end
	end
	if self:isEveryoneReady() then
		for i, selector in pairs(self.selectors) do
			isPlaying[i] = (selector:getState() == "ready")
		end
		game:set()
		game:load()
	end

	self.backHover = pointVsRect(mouse,self.backButton)
	if self.backHover then
		self.backText:update(dt)
	end

	if isEveryoneLeft or self.backHover and mouse.leftPressed then
		menu:set()
		menu:load()
	end

end

function selectCharacters:draw()
	for i, selector in pairs(self.selectors) do
		selector:draw()
	end
	if self.backHover then
		self.backText:draw()
	else
		GREEN:set()
		love.graphics.printf(
			"Back",
			self.backText.x,self.backText.y,
			self.backText.limit,"center"
		)
	end
	self.backButton:draw("line")
end
