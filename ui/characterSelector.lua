CharacterSelector = {}
CharacterSelector.__index = CharacterSelector

function CharacterSelector.new(slot)
	selector = {}
	setmetatable(selector, CharacterSelector)
	selector.state = "inactive"
	selector.slot = slot
	selector.w, selector.h = screen.w/2, screen.h/2-64
	local colorMode
	if slot == 1 then
		selector.x, selector.y = 0, 8
		colorMode = 5
	elseif slot == 2 then
		selector.x, selector.y = selector.w, 8
		colorMode = 6
	elseif slot == 3 then
		selector.x, selector.y = 0, selector.h+8
		colorMode = 2
	elseif slot == 4 then 
		selector.x, selector.y = selector.w, selector.h+8
		colorMode = 4
	end

	selector.joinButton = Rect.new(
		selector.x, selector.y+32, selector.w, selector.h-32
	)

	selector.leaveButton = Rect.new(
		selector.x, selector.y+300, selector.w, 32
	)

	selector.readyButton = Rect.new(
		selector.x, selector.y+256, selector.w, 32
	)


	selector.leftButton = Rect.new(
		selector.x+96,selector.y+128,32,32
	)

	selector.leftText = AnimatedText.new(
		selector.x+96,selector.y+128,
		"<",1,
		10,selector.leftButton.w,colorMode
	)

	selector.rightButton = Rect.new(
		selector.x+selector.w-128,selector.y+128,32,32
	)

	selector.rightText = AnimatedText.new(
		selector.x+selector.w-128,selector.y+128,
		">",1,
		10,selector.rightButton.w,colorMode
	)


	selector.readyButtonText = AnimatedText.new(
		selector.x,selector.y+256,
		"Press [jump] when ready",1,
		10,selector.w,colorMode,"horizontal"
	)

	selector.leaveText = AnimatedText.new(
		selector.x,selector.y+300,
		"Press [back] to leave",1,
		10,selector.w,colorMode,"horizontal"
	)

	selector.joinText = AnimatedText.new(
		selector.x,selector.y+128,
		"Press [jump] to join",1,
		10,selector.w,colorMode
	)

	selector.readyText = AnimatedText.new(
		selector.x,selector.y+128,
		"Player " .. slot .. " is ready !",.5,
		10,selector.w,colorMode
	)

	selector.color = selector.joinText.color:clone()
	selector.index = 1
	selector.delay = Clock.new(.2)

	return selector
end

function CharacterSelector:setState(state)
	self.state = state
end

function CharacterSelector:getState()
	return self.state
end

function CharacterSelector:update(dt)
	if self.state == "inactive" then
		if inputs[self.slot].jumpPressed 
		or pointVsRect(mouse,self.joinButton) and mouse.leftPressed then
			self.state = "joined"
		end
		self.joinText:update(dt)
	elseif self.state == "joined" then
		if inputs[self.slot].jumpPressed then
			self.state = "ready"
		end
		if pointVsRect(mouse,self.readyButton)  then
			if mouse.leftPressed then
				self.state = "ready"
			end
			self.readyButtonText:update(dt)
		end

		if inputs[self.slot].backPressed then
			self.state = "inactive"
		end

		if pointVsRect(mouse,self.leaveButton)  then
			if mouse.leftPressed then
				self.state = "inactive"
			end
			self.leaveText:update(dt)
		end

		local leftHover = pointVsRect(mouse,self.leftButton)

		if leftHover then
			self.leftText:update(dt)
		end

		local rightHover = pointVsRect(mouse,self.rightButton)

		if rightHover then
			self.rightText:update(dt)
		end

		if inputs[self.slot].leftDown ~= 0 
		or leftHover and mouse.leftPressed then
			if self.delay:zero() then
				if self.index > 1 then
					self.index = self.index - 1 
				else 	
					self.index = #characters
				end
				self.delay:tick()
			end
		elseif inputs[self.slot].rightDown ~= 0
		or rightHover and mouse.leftPressed then
			if self.delay:zero() then
				if self.index < #characters then
					self.index = self.index + 1 
				else 	
					self.index = 1
				end
				self.delay:tick()
			end
		else 
			self.delay:reset()
		end

		if not self.delay:zero() then
			self.delay:tick()
			if self.delay:alarm() then
				self.delay:reset()
			end
		end

		if self.state == "ready" then
			choosenCharacters[self.slot] = characters[self.index]
		end

	elseif self.state == "ready" then
		if inputs[self.slot].backPressed
		or pointVsRect(mouse,self.joinButton) and mouse.leftPressed then
			self.state = "joined"
		end
		self.readyText:update(dt)
	end
end

function CharacterSelector:draw()
	self.color:set()
	--self.joinButton:draw("line")

	if self.state == "inactive" then
		self.joinText:draw()
	elseif self.state == "joined" then
		love.graphics.printf(
			"Choose your character",
			self.x,self.y+16,
			self.w,"center"
		)
		if pointVsRect(mouse,self.readyButton)  then
			self.readyButtonText:draw()
		else
			love.graphics.printf(
				"Press [jump] when ready",
				self.x,self.y+256,
				self.w,"center"
			)
		end
		self.color:set()
		if pointVsRect(mouse,self.leaveButton)  then
			self.leaveText:draw()
		else
			love.graphics.printf(
				"Press [back] to leave",
				self.x,self.y+300,
				self.w,"center"
			)
		end

		self.color:set()
		self.leftButton:draw("line")
		
		if pointVsRect(mouse,self.leftButton)  then
			self.leftText:draw()
		else
			love.graphics.printf(
				"<",
				self.leftText.x,self.leftText.y,
				self.leftButton.w,"center"
			)
		end

		self.color:set()
		self.rightButton:draw("line")

		if pointVsRect(mouse,self.rightButton)  then
			self.rightText:draw()
		else
			love.graphics.printf(
				">",
				self.rightText.x,self.rightText.y,
				self.rightButton.w,"center"
			)
		end

		colors[self.slot]:set()
		love.graphics.setFont(font32)


		love.graphics.printf(
			characters[self.index].name,
			self.x, 
			self.y+192, 
			self.w,"center"
		)
		love.graphics.printf(
			"^",
			self.x, 
			self.y+172, 
			self.w,"center"
		)
		love.graphics.draw(
			characters[self.index].image,
			self.x+self.w/2-characters[self.index].width/2, 
			self.y+160-characters[self.index].height, 
			0
		)

		local otherCharacter = self.index-1
		if otherCharacter < 1 then
			otherCharacter = #characters
		elseif otherCharacter > #characters then 
			otherCharacter = 1
		end
		love.graphics.draw(
			characters[otherCharacter].image,
			self.x+self.w/2-characters[otherCharacter].width/2-64, 
			self.y+160-characters[otherCharacter].height, 
			0
		)
		otherCharacter = self.index+1
		if otherCharacter < 1 then
			otherCharacter = #characters
		elseif otherCharacter > #characters then 
			otherCharacter = 1
		end
		love.graphics.draw(
			characters[otherCharacter].image,
			self.x+self.w/2-characters[otherCharacter].width/2+64, 
			self.y+160-characters[otherCharacter].height, 
			0
		)
	elseif self.state == "ready" then
		self.readyText:draw()
	end
end