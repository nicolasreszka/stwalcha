--Author : Nicolas Reszka

God = Object.new()
God.__index = God

local baseEyeColor = YELLOW:clone()
local shake = 4
local eyeSpeed = 5

function God.new()
	local god = {}
	setmetatable(god, God)

	god.state = "arrival"

	god.arrivalTimer = Clock.new(1)

	if mapName == "maps.lava" then
		god.lookTimer = Clock.new(0.5)
		god.lookSubTimer = Clock.new(0.25)
		god.waitTimer = Clock.new(0.5)
	else
		god.lookTimer = Clock.new(1.5)
		god.lookSubTimer = Clock.new(0.5)
		god.waitTimer = Clock.new(1.25)
	end
	
	
	god.lookSubTimer:forceAlarm()
	
	god.victoryWaitTimer = Clock.new(1.5)
	god.lightingTimer = Clock.new(0.5)
	god.fireworksTimer = Clock.new(.15)

	god.choice = love.math.random(1,game.players.size)
	god.player = nil

	god.pos = Point.new(mapWidth/2,-128)

	god.eyeColor = baseEyeColor:clone()
	-- god.leftEye = Point.new(god.pos.x-40,god.pos.y-8)
	-- god.rightEye = Point.new(god.pos.x+24,god.pos.y-8)
	god.eye = Point.new(god.pos.x,god.pos.y)
	god.lookAngle = math.rad(270)
	god.lightingPoints = {}

	return god
end

function God:update()
	if game.players.size > 1 then
		self:choiceAutomate()
		if self.state == "arrival" then
			self.lookAngle = math.rad(90)
		else
			self:eyeMovement(self.player)
		end
	else 
		self:victoryAutomate()
		if game.players.size == 1 then
			self:eyeMovement(game.players.objects[1])
		else 
			self.lookAngle = math.rad(90)
		end
	end
	self.eye.x = self.pos.x + lengthDirectionX(8,self.lookAngle)
	self.eye.y = self.pos.y + lengthDirectionY(8,self.lookAngle)
	
	-- self.leftEye.x = self.pos.x-40 + lengthDirectionX(8,self.lookAngle)
	-- self.leftEye.y = self.pos.y-8 + lengthDirectionY(8,self.lookAngle)
	-- self.rightEye.x = self.pos.x+32 + lengthDirectionX(8,self.lookAngle)
	-- self.rightEye.y = self.pos.y-8 + lengthDirectionY(8,self.lookAngle)
end

function God:choiceAutomate()
	if self.state == "arrival" then
		if self.arrivalTimer:zero() then
			sfx.god:stop()
			sfx.god:playAt(self.pos)
		end
		self.arrivalTimer:tick()
		self.pos.y = inExpo(-128,mapHeight/2-56,self.arrivalTimer)
		sfx.god:setPosition(self.pos)
		if self.arrivalTimer:alarm() then
			self.state = "lookAround"
		end
	elseif self.state == "lookAround" then
		self.lookSubTimer:tick()
		if self.lookSubTimer:alarm() then
			if self.choice == game.players.size then
				self.choice = 0
			end
			self.choice = approachValues(self.choice,game.players.size,1)
			self.player = game.players.objects[self.choice]
			self.lookSubTimer:reset()
		end
		self.lookTimer:tick()
		if self.lookTimer:alarm() then
			self.choice = love.math.random(1,game.players.size)
			self.player = game.players.objects[self.choice]
			self.lookTimer:reset()
			self.state = "wait"
		end
	elseif self.state == "wait" then
		self.waitTimer:tick()
		self.eyeColor:transform(
			inExpo(1,50,self.waitTimer),
			RED
		)
		if self.waitTimer:alarm() then
			self.player.input:vibration(0.5)
			sfx.lighting:stop()
			sfx.lighting:playAt(self.player.pos)

			self.waitTimer:reset()
			self.state = "lighting"
		end
	elseif self.state == "lighting" then
		camera:move(
			love.math.random(-shake,shake),
			love.math.random(-shake,shake)
		)
		self.lightingTimer:tick()
		self.lightingPoints = self:createLighting(self.player)
		if self.lightingTimer:alarm() then
			self.player.touched = true
			self.player.colorCurrent = 0
			self.player.color = chatColor:clone()
			self.player.sfx.tick:playAt(self.player.pos)
			game.chat[self.player.slot] = true
			self.lightingTimer:reset()
			self.state = "departure"
		end
	elseif self.state == "departure" then
		if self.arrivalTimer:alarm() then
			sfx.god:playAt(self.pos)
		end
		self.pos.y = outExpo(-128,mapHeight/2-56,self.arrivalTimer)
		self.arrivalTimer:rewind()
		sfx.god:setPosition(self.pos)
		if self.arrivalTimer:zero() then
			game.halfTime = false
			self.state = "arrival"
			self.eyeColor = baseEyeColor:clone()
		end
	end
end

function God:victoryAutomate()
	if self.state == "arrival" then
		if self.arrivalTimer:zero() then
			sfx.god:playAt(self.pos)
		end
		self.arrivalTimer:tick()
		self.pos.y = inExpo(-128,mapHeight/2-56,self.arrivalTimer)
		sfx.god:setPosition(self.pos)
		if self.arrivalTimer:alarm() then
			self.state = "wait"
		end
	elseif self.state == "wait" then
		if game.players.size == 1 then
			self.victoryWaitTimer:setDuration(5)
			self.eyeColor:transform(
				inExpo(1,50,self.victoryWaitTimer),
				baseEyeColor
			)
			self.fireworksTimer:tick()
			if self.fireworksTimer:alarm() and self.fireworksTimer.duration < 0.5 then
				local fireX = love.math.random(256,700)
				local fireY = love.math.random(128,512)
				local fire = Sound.new(sfx.fireworks)
				fire:playAt(Point.new(fireX,fireY))
				instantiateFireworks(fireX,fireY,love.math.random(8,12))
				self.fireworksTimer:setDuration(self.fireworksTimer.duration*1.1)
				self.fireworksTimer:reset()
			end
		elseif not self.fireworksTimer:zero() then
			self.eyeColor:transform(
				inExpo(1,50,self.victoryWaitTimer),
				RED
			)
			-- if not sfx.god:isPlaying() then
			-- 	sfx.god:playAt(self.pos)
			-- end
		end
		self.victoryWaitTimer:tick()
		if self.victoryWaitTimer:alarm() then
			game:load()
		end
	else
		self.state = "wait"
	end
end

function God:eyeMovement(player)
	if player ~= nil then
		local eyeDirection = angle(self.pos, player.pos)
		self.lookAngle = math.rad(
			approachValues(math.deg(self.lookAngle), math.deg(eyeDirection),eyeSpeed)
		)
	end
end


function God:createLighting(player)
	local lightingPoints = {}
	local lastX = player.pos.x+player.rect.w/2
	local lastY = player.pos.y
	table.insert(lightingPoints,Point.new(lastX,lastY))
	for y = lastY-love.math.random(32,64), -64, -love.math.random(32,64) do
		local x = lastX + love.math.random(-48,48)
		table.insert(lightingPoints,Point.new(x,y))
		lastX = x
		lastY = y
	end	

	return lightingPoints
end

function God:drawLighting(lightingPoints)
	WHITE:set()
	local lastY = lightingPoints[1].y
	local lastX = lightingPoints[1].x
	for i, point in pairs(lightingPoints) do
		love.graphics.setLineWidth(love.graphics.getLineWidth()+1)
		love.graphics.line(lastX, lastY, point.x, point.y)
		lastX = point.x
		lastY = point.y
	end	
	love.graphics.setLineWidth(1)
end

function God:draw()
	chatColor:set()
	--love.graphics.rectangle("line",self.pos.x-64,self.pos.y-64,128,128)
	love.graphics.polygon(
		"fill",
		{
			self.pos.x,self.pos.y-64,
			self.pos.x-64,self.pos.y+64,
			self.pos.x+64,self.pos.y+64
		}
	)
	GREEN:set()
	love.graphics.polygon(
		"line",
		{
			self.pos.x,self.pos.y-64,
			self.pos.x-64,self.pos.y+64,
			self.pos.x+64,self.pos.y+64
		}
	)
	WHITE:set()
	love.graphics.circle("fill",self.pos.x,self.pos.y,16)
	BLUE:set()
	love.graphics.circle("line",self.pos.x,self.pos.y,16)
	self.eyeColor:set()
	love.graphics.circle("fill",self.eye.x,self.eye.y,8)
	BLUE:set()
	love.graphics.circle("line",self.eye.x,self.eye.y,8)
	BLACK:set()
	love.graphics.circle("fill",self.eye.x,self.eye.y,2)

	-- love.graphics.rectangle("fill",self.pos.x-48,self.pos.y-16,24,24)
	-- love.graphics.rectangle("fill",self.pos.x+24,self.pos.y-16,24,24)
	-- self.eyeColor:set()
	-- love.graphics.rectangle("fill",self.leftEye.x,self.leftEye.y,8,8)
	-- love.graphics.rectangle("fill",self.rightEye.x,self.rightEye.y,8,8)

	if self.state == "lighting" then 
		if not self.lightingTimer:zero() then
			self:drawLighting(self.lightingPoints)
		end
	end
end