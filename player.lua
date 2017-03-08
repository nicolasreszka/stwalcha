Player = {
	moveDirection = 0,
	grounded = false,
	groundedBefore = false,
	vx = 0,
	vy = 0,
	thrown = false,
	touched = false,
	xScale = 1,
	yScale = 1,
	colorShift = 0,
	colorCurrent = 0, 
	protected = false
}
Player.__index = Player

local width = 32
local height = 32

local squashX = 1.50
local squashY = 0.75
local stretchX = 0.50
local stretchY = 1.25
local restitution = 0.05

local accelerationGround = .4
local accelerationAir = .6
local accelerationDuration = 1

local frictionGround = .4
local frictionAir = .2
local frictionDuration = .2

local maxSpeedGround = 8
local maxSpeedAir = 10

local jumpForce = 8
local gravity = .4
local maxGravity = 32

local thrownDuration = 0.3
local touchedDuration = 0.15
local explosionDuration = 6

local colors = {
	{106, 255, 106},
	{0, 191, 255},
	{0, 128, 255},
	{255, 128, 0}
}

local chatColor = {255, 40, 222}

local startColorShift = 2
local targetColorShift = 50

function Player.new(x,y,slot)
	local player = {}
	setmetatable(player, Player)

	player.slot = slot
	player.input = inputs[slot]

	player.pos = Point.new(x,y)
	player.rect = Rect.new(x,y,width,height)

	player.accelerationTimer = Clock.new(accelerationDuration)
	player.frictionTimer = Clock.new(frictionDuration)
	player.thrownTimer = Clock.new(thrownDuration)
	player.touchedTimer = Clock.new(touchedDuration)
	player.explosionTimer = Clock.new(explosionDuration)

	player.color = {
		colors[slot][1],
		colors[slot][2],
		colors[slot][3]
	}

	return player
end

function Player:update()

	self.moveDirection = self.input.rightDown - self.input.leftDown
 	self.grounded = blocks:rectsVsLine(self.rect:bboxBottom())
 	self:squashAndStretch()
	
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
			self:move(accelerationAir,frictionAir,maxSpeedAir)
			self:wallJump()
		else 
			self:move(accelerationGround,frictionGround,maxSpeedGround)
			self:jump()
		end
	end

	if self.touched then
		self.touchedTimer:tick()
		if self.touchedTimer:alarm() then
			self.touchedTimer:reset()
			self.touched = false
		end
	end

	self:horizontalCollisions()
	self:verticalCollisions()

	-- Keep previous grounded value
	self.groundedBefore = self.grounded
	self:applyRestitution()

	if chat == self.slot then
		self:blink()
		self.explosionTimer:tick()
		if self.explosionTimer:alarm() then
			self.input:vibration(2)
			explosions:add(Explosion.new(self.pos.x,self.pos.y))
			players:remove(self)
		end
	else 
		self.explosionTimer:reset()
	end
end

function Player:squashAndStretch()
	-- Squash
	if not self.groundedBefore and self.grounded then
		self:squash() 
		instantiateDustBottom(self.rect.left,self.rect.bottom-2,4)
		instantiateDustBottom(self.rect.right,self.rect.bottom-2,4)
	-- Stretch
	elseif self.groundedBefore and not self.grounded then
		self:stretch()
	end
end

function Player:fall()
	if self.vy < maxGravity then
		self.vy = self.vy + gravity
	end
end

function Player:move(acceleration,friction,maxSpeed) 
	-- Slow down
	if self.moveDirection == 0 then
		self.vx = approachValues(
			self.vx, 0,
			tween.inExpo(0.1,friction,self.frictionTimer)
		)
		self.frictionTimer:tick()
		self.accelerationTimer:rewind()
	-- Accelerate
	else 
		self.vx = approachValues(
			self.vx, maxSpeed*self.moveDirection,
			tween.outExpo(0.1,acceleration,self.accelerationTimer)
		)
		self.frictionTimer:reset()
		self.accelerationTimer:tick()
	end 
end

function Player:wallJump()
	-- Left
	if blocks:rectsVsLine(self.rect:bboxLeft()) 
	and not blocks:rectsVsLine(self.rect:bboxRight()) then
		instantiateDustLeft(
			self.rect.left+4,
			self.rect.top+height/4,
			2
		)
		if self.input.jumpPressed then
			self.vx = jumpForce
			self.vy = -jumpForce
			self:stretch()
		end
	-- Right
	elseif not blocks:rectsVsLine(self.rect:bboxLeft()) 
	and blocks:rectsVsLine(self.rect:bboxRight()) then
		instantiateDustRight(
			self.rect.right-4,
			self.rect.top+height/4,
			2
		)
		if self.input.jumpPressed then
			self.vx = -jumpForce
			self.vy = -jumpForce
			self:stretch()
		end
	end 
end

function Player:jump()
	if self.input.jumpPressed then
		self.vy = -jumpForce
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
end

function Player:getNextX(speed)
	local v = sign(speed)
	local nextP = self.rect.pos.x + v
	if nextP >= mapWidth then
		nextP = 4
	elseif nextP <= 0 then
		nextP = mapWidth-4
	end
	return nextP
end

function Player:getNextY(speed)
	local v = sign(speed)
	local nextP = self.rect.pos.y + v
	if nextP > mapHeight then
		nextP = 4
	elseif nextP < 0 then
		nextP = mapHeight-4
	end
	return nextP
end

function Player:changeChat(player)
	if chat == self.slot and not self.touched then
		chat = player.slot
		player.touched = true
	elseif chat == player.slot and not player.touched 
		and not player.thrown then
		chat = self.slot
		self.touched = true
	end
end

function Player:kickOtherPlayers() 
	-- Check for players
	local player = players:rectsVsRect(self.rect)
	if not player then
		return -1
	else 
		self:changeChat(player)
		-- Move only the rectangle
		player.rect:translate(player:getNextX(self.vx),player.rect.pos.y)
		-- Check for other players or walls
		local otherPlayer = players:rectsVsRect(player.rect)
		if otherPlayer and otherPlayer ~= self or blocks:rectsVsRect(player.rect) then
			player.rect:translate(player.pos.x,player.rect.pos.y)	
			return 0
		else 
			-- Throw player
			if not player.thrown then
				player.vx = self.vx*1.75 
				player.thrown = true
				if player.grounded then
					player.vy = -math.max(math.abs(self.vx)*0.75,4)
				end
				player.pos.x = player.rect.pos.x
				player.input:vibration(player.thrownTimer.duration)
			end
			-- Move player to avoid mutual contact
			player.rect:translate(player.pos.x,player.rect.pos.y)
			return 1
		end
	end
end

function Player:horizontalCollisions()
	for i = 1, math.abs(self.vx) do
		-- Move only the rectangle
		self.rect:translate(self:getNextX(self.vx),self.rect.pos.y)
		-- Check for other players and kick them in the ass
		local kick = self:kickOtherPlayers()
		-- Other player was kicked
		if kick == 1 then
			self.rect:translate(self.pos.x,self.rect.pos.y)	
		-- Wall detected for player or other player
		elseif kick == 0 or blocks:rectsVsRect(self.rect) then
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
		self.rect:translate(self.rect.pos.x,self:getNextY(self.vy))
		-- Check for other players 
		local player = players:rectsVsRect(self.rect)
		if player then
			self:changeChat(player)
		end
		-- Jump on other player
		if self.vy > 0 and player then
			self.rect:translate(self.rect.pos.x,self.pos.y)	
			self.vy = -jumpForce
			self:stretch()
			player:squash()
			player.input:vibration(player.thrownTimer.duration)
			break
		-- Wall detected for player or other player
		elseif blocks:rectsVsRect(self.rect)
		or self.vy < 0 and player then
			self.rect:translate(self.rect.pos.x,self.pos.y)	
			if self.vy < 0 then
				self:squash()
			end
			self.vy = 0
			break
		-- Move position
		else 
			self.pos.y = self.rect.pos.y
		end
	end
end

function Player:squash()
	self.xScale = squashX
	self.yScale = squashY
end

function Player:stretch()
	self.xScale = stretchX
	self.yScale = stretchY
end

function Player:applyRestitution()
	self.xScale = approachValues(self.xScale,1,restitution)
	self.yScale = approachValues(self.yScale,1,restitution)
end

function Player:colorTransition(targetColor)
	self.color[1] = approachValues(self.color[1],targetColor[1],self.colorShift)
	self.color[2] =	approachValues(self.color[2],targetColor[2],self.colorShift)
	self.color[3] = approachValues(self.color[3],targetColor[3],self.colorShift)
end

function Player:colorCompare(targetColor)
	if self.color[1] == targetColor[1]
	and self.color[2] == targetColor[2]
	and self.color[3] == targetColor[3] then
		return true
	else 
		return false
	end
end

function Player:blink()
	self.colorShift = tween.inOutExpo(startColorShift,targetColorShift,self.explosionTimer);
	if self.colorCurrent == 0 then
		self:colorTransition(chatColor)
		if self:colorCompare(chatColor) then
			self.colorCurrent = 1
		end
	else 
		self:colorTransition(colors[self.slot])
		if self:colorCompare(colors[self.slot]) then
			self.colorCurrent = 0
		end
	end
end

function Player:draw()
	if chat == self.slot then
		love.graphics.setColor(self.color)
	else 
		love.graphics.setColor(colors[self.slot])
	end
	
	love.graphics.rectangle(
		"fill", 
		self.pos.x-self.xScale*width/2+width/2, 
		self.pos.y-self.yScale*height/2+height/2, 
		width*self.xScale, 
		height*self.yScale
	)
end
