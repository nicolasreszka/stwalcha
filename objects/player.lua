--Author : Nicolas Reszka

Player = Object.new()
Player.__index = Player

local thrownDuration = .3
local touchedDuration = .2
local explosionDuration = 10

local startColorShift = 2
local endColorShift = 50

function Player.new(x,y,slot,character)
	local player = {}
	setmetatable(player, Player)

	player.moveDirection = 0
	player.grounded = false
	player.groundedBefore = false
	player.vx = 0
	player.vy = 0
	player.thrown = false
	player.touched = false
	player.xScale = 1
	player.yScale = 1
	player.colorCurrent = 0

	player.slot = slot
	player.input = inputs[slot]

	player.pos = Point.new(x,y)
	player.rect = Rect.new(x,y,character.width,character.height)

	player.accelerationTimer = Clock.new(character.accelerationDuration)
	player.frictionTimer = Clock.new(character.frictionDuration)

	player.thrownTimer = Clock.new(thrownDuration)
	player.touchedTimer = Clock.new(touchedDuration)
	player.explosionTimer = Clock.new(explosionDuration)

	player.color = chatColor:clone()

	player.sfx = {
		jump = Sound.new(sfx.jump),
		bump = Sound.new(sfx.bump),
		land = Sound.new(sfx.land),
		slide = Sound.new(sfx.slide),
		tick = Sound.new(sfx.tick),
		splash = Sound.new(sfx.splash)
	}

	player.width = character.width
	player.height = character.height

	player.squashX = character.squashX
	player.squashY = character.squashY
	player.stretchX = character.stretchX
	player.stretchY =  character.stretchY
	player.restitution = character.restitution

	player.accelerationGround =  character.accelerationGround
	player.accelerationAir =  character.accelerationAir

	player.frictionGround = character.frictionGround
	player.frictionAir = character.frictionAir
	player.maxSpeedGround = character.maxSpeedGround
	player.maxSpeedAir = character.maxSpeedAir

	player.jumpForce = character.jumpForce
	player.gravity = character.gravity
	player.maxGravity = character.maxGravity
	player.image = character.image
	player.sprite = love.graphics.newQuad(
		player.width*(player.slot-1), 0, player.width, player.height, 
		player.image:getDimensions()
	)

	player.name = character.name
	player.weedClock = Clock.new(0.15)
	player.rainbowClock = Clock.new(0.01)
	player.waitForParticles = false

	return player
end

function Player:update()
	self.moveDirection = self.input.rightDown - self.input.leftDown

	self:getGrounded()

 	self:landAndTakeOff()
	
 	if self.name == "Mary" then
 		if self.waitForParticles then
	 		self.weedClock:tick()
	 		if self.weedClock:alarm() then
	 			self.waitForParticles = false
	 			self.weedClock:reset()
	 		end
	 	elseif self.vx ~= 0 or self.vy ~= 0 then
	 		game.customParticles:add(
	 			Weed.new(
	 				self.pos.x,self.pos.y,colors[self.slot]
	 			)
	 		)
	 		self.waitForParticles = true
	 	end
 	end

 	if self.name == "Henry" then
 		if self.waitForParticles then
	 		self.rainbowClock:tick()
	 		if self.rainbowClock:alarm() then
	 			self.waitForParticles = false
	 			self.rainbowClock:reset()
	 		end
	 	elseif self.vx ~= 0 or self.vy ~= 0 then
	 		game.customParticles:add(
	 			Rainbow.new(
	 				self.pos.x+self.width/2,
	 				self.pos.y+self.height/2,
	 				angle({x=0,y=0},{x=self.vx,y=self.vy}) 
	 			)
	 		)
	 		self.waitForParticles = true
	 	end
 	end

	if self.thrown then
		if not self.grounded then
			self:fall()
		end
		self.thrownTimer:tick()
		if self.thrownTimer:alarm() then
			self.thrownTimer:reset()
			self.thrown = false
		end
	else 
		if not self.grounded then
			self:fall()
			if self.name == "Lama" then
				if self.input.jumpPressed then
					self.vy = -2
				end
			end
			self:move(self.accelerationAir,self.frictionAir,self.maxSpeedAir)
			self:wallJump()
		else 
			self.vy = 0
			self:move(self.accelerationGround,self.frictionGround,self.maxSpeedGround)
			self:jump()
			
			if self.moveDirection > 0 and self.vx < 0 then
				self.sfx.slide:playAt(self.pos)
				if self.vx > -self.maxSpeedGround*0.6 and self.name ~= "Mary" then
					instantiateDustRight(self.rect.left,self.rect.bottom-4,2)
				end
			elseif self.moveDirection < 0 and self.vx > 0 then
				self.sfx.slide:playAt(self.pos)
				if self.vx < self.maxSpeedGround*0.6 and self.name ~= "Mary" then
					instantiateDustLeft(self.rect.right,self.rect.bottom-4,2)
				end
			else 
				if self.sfx.slide:isPlaying() then
					self.sfx.slide:pause()
				end
			end
		end
	end

	if self.touched then
		self.touchedTimer:tick()
		if self.touchedTimer:alarm() then
			self.touchedTimer:reset()
			self.touched = false
		end
	end

	self.vx = clamp(self.vx,-72,72)
	self:horizontalCollisions()
	self:verticalCollisions()

	self.groundedBefore = self.grounded
	self:applyRestitution()

	if game.chat == self.slot then
		self:blink()
		self.explosionTimer:tick()
		if self.explosionTimer:alarm() then
			self:explode()
		end
	else 
		self.explosionTimer:reset()
	end
end

function Player:explode()
	self.input:vibration(2)
	if self.name == "Boom" then
		game.bombs:add(Bomb.new(self.pos.x,self.pos.y))
		game.bombs:add(Bomb.new(self.pos.x,self.pos.y))
		game.bombs:add(Bomb.new(self.pos.x,self.pos.y))
	else
		game.explosions:add(Explosion.new(self.pos.x,self.pos.y))
	end
	game.players:remove(self)
end

function Player:getGrounded() 
	if self.rect.bottom >= mapHeight then
		self.grounded = game.blocks:rectsVsLine(Line.new(self.rect.left, 1, self.rect.right, 1))
		if self.grounded then
			self.pos.y = mapHeight-self.height
			self.rect:translate(self.pos.x,self.pos.y)
		end
	else 
		self.grounded = game.blocks:rectsVsLine(self.rect:bboxBottom())
	end

	if self.grounded then
		if self.grounded.type == "cloud" and self.name ~= "Feather" then
			self.grounded.erosion = true
		end
	end
end

function Player:landAndTakeOff()
	-- Squash
	if not self.groundedBefore and self.grounded then
		if self.name ~= "Mary" then
			instantiateDustBottom(self.rect.left,self.rect.bottom-2,4)
			instantiateDustBottom(self.rect.right,self.rect.bottom-2,4)
		end
		self.sfx.land:stop()
		self.sfx.land:playAt(self.pos)
		self:squash()
	-- Stretch
	elseif self.groundedBefore and not self.grounded then
		self:stretch()
	end
end

function Player:fall()
	if self.vy < self.maxGravity then
		self.vy = self.vy + self.gravity
	end
end

function Player:move(acceleration,friction,maxSpeed) 
	-- Slow down
	if self.moveDirection == 0 then
		self.vx = approachValues(
			self.vx, 0,
			inExpo(0.1,friction,self.frictionTimer)
		)
		self.frictionTimer:tick()
		self.accelerationTimer:rewind()
	-- Accelerate
	else 
		self.vx = approachValues(
			self.vx, maxSpeed*self.moveDirection,
			outExpo(0.1,acceleration,self.accelerationTimer)
		)
		self.frictionTimer:reset()
		self.accelerationTimer:tick()
	end 
end

function Player:wallJump()
	local leftWall, rightWall
	if self.rect.left <= 0 then
		leftWall = game.blocks:rectsVsLine(Line.new(mapWidth-1,self.rect.top,mapWidth-1,self.rect.bottom))
	else 
		leftWall = game.blocks:rectsVsLine(self.rect:bboxLeft())
	end

	if self.rect.right >= mapWidth then
		rightWall = game.blocks:rectsVsLine(Line.new(1,self.rect.top,1,self.rect.bottom))
	else 
		rightWall = game.blocks:rectsVsLine(self.rect:bboxRight())
	end

	if leftWall then
		if leftWall.type == "cloud" and self.name ~= "Feather" then
			leftWall.erosion = true
		end
	end

	if rightWall then
		if rightWall.type == "cloud" and self.name ~= "Feather" then
			rightWall.erosion = true
		end
	end

	-- Left
	if leftWall and not rightWall then
		if self.name == "Simon" then
			self.vy = 0
		else
			if self.name ~= "Mary" then
				instantiateDustLeft(
					self.rect.left+4,
					self.rect.top+self.height/4,
					2
				)
			end
			self.sfx.slide:playAt(self.pos)
		end

		if self.name == "Boot" or self.input.jumpPressed then
			self.vx = self.jumpForce
			self.vy = -self.jumpForce
			self:stretch()
			self.sfx.jump:stop()
			self.sfx.jump:playAt(self.pos)
		end
	-- Right
	elseif not leftWall and rightWall then
		if self.name == "Simon" then
			self.vy = 0
		else
			if self.name ~= "Mary" then
				instantiateDustRight(
					self.rect.right-4,
					self.rect.top+self.height/4,
					2
				)
			end
			self.sfx.slide:playAt(self.pos)
		end
		if self.name == "Boot" or self.input.jumpPressed then
			self.vx = -self.jumpForce
			self.vy = -self.jumpForce
			self:stretch()
			self.sfx.jump:stop()
			self.sfx.jump:playAt(self.pos)
		end
	else 
		if self.sfx.slide:isPlaying() then
			self.sfx.slide:pause()
		end
	end 
end

function Player:jump()
	if self.name == "Boot" or self.input.jumpPressed then
		self.vy = -self.jumpForce
		if self.name ~= "Mary" then
			instantiateDustBottom(
				self.rect.left+12,
				self.rect.bottom-4,
				3
			)
			instantiateDustBottom(
				self.rect.right-12,
				self.rect.bottom-4,
				3
			)
		end
		self.sfx.jump:stop()
		self.sfx.jump:playAt(self.pos)
	end
end

function Player:getNextX(speed)
	local nextP = self.rect.pos.x + sign(speed)
	if nextP > mapWidth-self.width then
		nextP = 0
	elseif nextP < 0 then
		nextP = mapWidth-self.width
	end
	return nextP
end

function Player:getNextY(speed)
	local nextP = self.rect.pos.y + sign(speed)
	if nextP > mapHeight then
		nextP = -self.height/4
	elseif nextP < -self.height/2 then
		nextP = mapHeight-self.height/4
	end
	return nextP
end

function Player:changeChat(player)
	if not self.touched and not player.touched then
		if game.chat == self.slot then
			game.chat = player.slot
			self.touched = true
			self.sfx.tick:stop()
			player.touched = true
			player.colorCurrent = 0
			player.color = chatColor:clone()
			player.sfx.tick:playAt(player.pos)
		elseif game.chat == player.slot then
			game.chat = self.slot
			player.touched = true
			player.sfx.tick:stop()
			self.touched = true
			self.colorCurrent = 0
			self.color = chatColor:clone()
			self.sfx.tick:playAt(self.pos)
		end
	end
end

function Player:kickOtherPlayers() 
	-- Check for players
	local player = game.players:rectsVsRect(self.rect)
	if not player then
		return -1
	else 
		self:changeChat(player)
		-- Move only the rectangle
		player.rect:setX(player:getNextX(self.vx))
		-- Check for other players or walls
		local otherPlayer = game.players:rectsVsRect(player.rect)
		if otherPlayer and otherPlayer ~= self or game.blocks:rectsVsRect(player.rect) then
			player.rect:translate(player.pos.x,player.rect.pos.y)	
			return 0
		else 
			-- Throw player
			if not player.thrown then
				if self.name == "Rascal" then
					player.vx = self.vx*3.5
					player.thrown = true
					if player.grounded then
						player.vy = -math.max(math.abs(self.vx)*1.25,6)
					end
				else
					player.vx = self.vx*1.75 
					player.thrown = true
					if player.grounded then
						player.vy = -math.max(math.abs(self.vx)*0.75,4)
					end
				end
				player.pos.x = player.rect.pos.x
				player.input:vibration(thrownDuration)
				self.input:vibration(thrownDuration)
			end
			-- Move player to avoid mutual contact
			player.rect:translate(player.pos.x,player.rect.pos.y)
			player.sfx.bump:playAt(player.pos)
			return 1
		end
	end
end

function Player:horizontalCollisions()
	for i = 1, math.abs(self.vx) do
		-- Move only the rectangle
		self.rect:setX(self:getNextX(self.vx))
		-- Check for other players and kick them in the ass
		local kick = self:kickOtherPlayers()
		-- Other player was kicked
		if kick == 1 then
			self.rect:translate(self.pos.x,self.rect.pos.y)	
		-- Wall detected for player or other player
		elseif kick == 0 or game.blocks:rectsVsRect(self.rect) then
			self.rect:translate(self.pos.x,self.rect.pos.y)	
			self.vx = 0
			break
		-- Move position
		else 
			self.pos.x = self.rect.pos.x
		end
	end
end

function Player:verticalCollisions()
	for i = 1, math.abs(self.vy) do
		-- Move only the rectangle
		self.rect:setY(self:getNextY(self.vy))
		-- Check for other players 
		local player = game.players:rectsVsRect(self.rect)
		if player then
			self:changeChat(player)
		end
		-- Jump on other player
		if self.vy > 0 and player then
			self.rect:translate(self.rect.pos.x,self.pos.y)	
			self.vy = -self.jumpForce
			self:stretch()
			self.input:vibration(thrownDuration)
			player:squash()
			player.input:vibration(thrownDuration)
			player.sfx.bump:playAt(player.pos)
			break
		-- Wall detected for player or other player
		elseif game.blocks:rectsVsRect(self.rect)
		or self.vy < 0 and player then
			if player then
				self.input:vibration(thrownDuration)
				player.input:vibration(thrownDuration)
			elseif self.vy < 0 then
				self.sfx.land:stop()
				self.sfx.land:playAt(self.pos)
				self:squash()
			end
			self.rect:translate(self.rect.pos.x,self.pos.y)
			self.vy = 0
			break
		-- Move position
		else 
			self.pos.y = self.rect.pos.y
		end
	end
end

function Player:squash()
	self.xScale = self.squashX
	self.yScale = self.squashY
end

function Player:stretch()
	self.xScale = self.stretchX
	self.yScale = self.stretchY
end

function Player:applyRestitution()
	self.xScale = approachValues(self.xScale,1,self.restitution)
	self.yScale = approachValues(self.yScale,1,self.restitution)
end

function Player:blink()
	if self.colorCurrent == 0 then
		self.color:transform(
			inExpo(startColorShift,endColorShift,self.explosionTimer),
			colors[self.slot]
		)
		if self.color:compare(colors[self.slot]) then
			self.colorCurrent = 1
			self.sfx.tick:stop()
			self.sfx.tick:playAt(self.pos)
		end
	else 
		self.color:transform(
			inExpo(startColorShift,endColorShift,self.explosionTimer),
			chatColor
		)
		if self.color:compare(chatColor) then
			self.colorCurrent = 0
			self.sfx.tick:stop()
			self.sfx.tick:playAt(self.pos)
		end
	end
end

function Player:draw()
	if game.chat == self.slot then
		chatColor:set()
		love.graphics.draw(
			self.image,
			self.pos.x-self.xScale*self.width/2+self.width/2-2, 
			self.pos.y-self.yScale*self.height/2+self.height/2, 
			0,
			self.xScale, 
			self.yScale
		)
		love.graphics.draw(
			self.image,
			self.pos.x-self.xScale*self.width/2+self.width/2+2, 
			self.pos.y-self.yScale*self.height/2+self.height/2, 
			0,
			self.xScale, 
			self.yScale
		)
		love.graphics.draw(
			self.image,
			self.pos.x-self.xScale*self.width/2+self.width/2, 
			self.pos.y-self.yScale*self.height/2+self.height/2+2, 
			0,
			self.xScale, 
			self.yScale
		)
		love.graphics.draw(
			self.image,
			self.pos.x-self.xScale*self.width/2+self.width/2, 
			self.pos.y-self.yScale*self.height/2+self.height/2-2, 
			0,
			self.xScale, 
			self.yScale
		)
		self.color:set()
	else 	
		colors[self.slot]:set()
	end

	love.graphics.draw(
		self.image,
		self.pos.x-self.xScale*self.width/2+self.width/2, 
		self.pos.y-self.yScale*self.height/2+self.height/2, 
		0,
		self.xScale, 
		self.yScale
	)

end
