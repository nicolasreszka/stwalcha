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

	mapWidth = screen.w 
	mapHeight = screen.h

	game.blocks = Group.new()
	for tileX = 0, 63 do
		game.blocks:add(SolidBlock.new(tileX*16,mapHeight-16))
	end

	game.chat = {false,false,false,false}
	game.halfTime = true
	game.players = Group.new()
	game.customParticles = Group.new()
	initializeParticles() 

end

function selectCharacters:reload()
	mapWidth = screen.w 
	mapHeight = screen.h

	game.chat = {false,false,false,false}
	game.halfTime = true
	game.blocks = Group.new()
	for tileX = 0, 63 do
		game.blocks:add(SolidBlock.new(tileX*16,mapHeight-16))
	end

	game.players = Group.new()
	game.customParticles = Group.new()
	initializeParticles() 

	for i, selector in pairs(self.selectors) do
		if selector:getState() == "ready" then
			selector:setState("joined")
		end 
	end
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

function selectCharacters:keypressed(key,scancode,isrepeat)
	if scancode == "escape" then
		uiSfx.no:play()
		if competition then 
			competitionMode:load()
			competitionMode:set()
		else
			menu:load()
			menu:set()
		end	
	end
end

function selectCharacters:update(dt)
	
	for i, input in pairs(inputs) do
		input:update()
	end

	game.blocks:update(dt)
	game.customParticles:update(dt)
	game.players:update()
	updateParticles()
	
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
		selectMap:load()
		selectMap:set()
	end

	self.backHover = pointVsRect(mouse,self.backButton)
	if self.backHover then
		self.backText:update(dt)
	end

	if isEveryoneLeft or self.backHover and mouse.leftPressed then
		uiSfx.no:play()
		if competition then 
			competitionMode:load()
			competitionMode:set()
		else
			menu:load()
			menu:set()
		end
	end

end

function selectCharacters:draw()
	game.blocks:draw()
	game.customParticles:draw()
	game.players:draw()
	drawParticles()

	for i, selector in pairs(self.selectors) do
		selector:draw()
	end
	if self.backHover then
		self.backText:draw()
		self.backButton:draw("line")
	else
		BLACK:set()
		love.graphics.printf(
			"Back",
			self.backText.x-3,self.backText.y-3,
			self.backText.limit,"center"
		)
		self.backButton:draw("line")
		GREEN:set()
		love.graphics.printf(
			"Back",
			self.backText.x,self.backText.y,
			self.backText.limit,"center"
		)
		self.backButton:draw("line")
	end
	
end
