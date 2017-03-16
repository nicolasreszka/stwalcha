God = {}
God.__index = God

local baseEyeColor = YELLOW:clone()
local shake = 4

function God.new()
	local god = {}
	setmetatable(god, God)

	god.state = "arrival"

	god.arrivalTimer = Clock.new(1)
	god.lookTimer = Clock.new(3)
	god.lookSubTimer = Clock.new(0.5)
	god.lookSubTimer:forceAlarm()
	god.waitTimer = Clock.new(1.5)
	god.lightingTimer = Clock.new(0.5)
	god.fireworksTimer = Clock.new(.15)

	god.choice = love.math.random(1,players.size)
	god.player = nil

	god.pos = Point.new(mapWidth/2,-128)

	god.eyeColor = baseEyeColor:clone()
	god.leftEye = Point.new(god.pos.x-40,god.pos.y-8)
	god.rightEye = Point.new(god.pos.x+24,god.pos.y-8)

	god.lookAngle = math.rad(270)

	return god
end

function God:update()
	if players.size > 1 then

		if self.state == "arrival" then
			if self.arrivalTimer:zero() then
				sfx.god:stop()
				sfx.god:playAt(self.pos)
			end

			self.arrivalTimer:tick()
			self.pos.y = tween.inExpo(-128,mapHeight/2,self.arrivalTimer)
			
			if self.arrivalTimer:alarm() then
				self.state = "lookAround"
			end
		elseif self.state == "lookAround" then

			self.lookSubTimer:tick()
			if self.lookSubTimer:alarm() then
				if self.choice == players.size then
					self.choice = 0
				end
				self.choice = approachValues(self.choice,players.size,1)
				self.player = players.objects[self.choice]
				self.lookSubTimer:reset()
			end

			self.lookTimer:tick()
			if self.lookTimer:alarm() then
				self.choice = love.math.random(1,players.size)
				self.player = players.objects[self.choice]
				self.lookTimer:reset()
				self.state = "wait"
			end

		elseif self.state == "wait" then
			self.waitTimer:tick()

			self.eyeColor:transform(
				tween.inExpo(1,50,self.waitTimer),
				RED
			)

			if self.waitTimer:alarm() then

				self.player.input:vibration(0.5)
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
			if self.lightingTimer:alarm() then
				self.player.touched = true
				self.player.colorCurrent = 0
				self.player.color = chatColor:clone()
				self.player.sfx.tick:playAt(self.player.pos)
				
				chat = self.player.slot

				self.lightingTimer:reset()
				self.state = "departure"
			end

		elseif self.state == "departure" then
			if self.arrivalTimer:alarm() then
				sfx.god:playAt(self.pos)
			end

			self.pos.y = tween.outExpo(-128,mapHeight/2,self.arrivalTimer)
			self.arrivalTimer:rewind()

			if self.arrivalTimer:zero() then
				halfTime = false
				self.state = "arrival"
				self.eyeColor = baseEyeColor:clone()
			end
		end

	else 
		if self.state == "arrival" then
			if self.arrivalTimer:zero() then
				sfx.god:playAt(self.pos)
			end

			self.arrivalTimer:tick()
			self.pos.y = tween.inExpo(-128,mapHeight/2,self.arrivalTimer)
			
			if self.arrivalTimer:alarm() then
				if players.size == 1 then
					self.waitTimer:setDuration(5)
				end
				self.state = "wait"
			end
		elseif self.state == "wait" then
			if players.size == 1 then
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
			end

			self.waitTimer:tick()
			if self.waitTimer:alarm() then
				loadMap()
			end
		end
	end
end

function God:draw()
	GREEN:set()
	love.graphics.rectangle("line",self.pos.x-64,self.pos.y-64,128,128)
	BLUE:set()
	love.graphics.rectangle("fill",self.pos.x-48,self.pos.y-16,24,24)
	love.graphics.rectangle("fill",self.pos.x+24,self.pos.y-16,24,24)

	if players.size > 1 then
		if self.state == "arrival" then
			self.lookAngle = math.rad(90)
		else
			if self.player ~= nil then
				local eyeDirection = angle(self.pos, self.player.pos)
				self.lookAngle = math.rad(
					approachValues(math.deg(self.lookAngle), math.deg(eyeDirection),5)
				)
			end
		end
	elseif players.size == 1 then
		local eyeDirection = angle(self.pos, players.objects[1].pos)
		self.lookAngle = math.rad(
			approachValues(math.deg(self.lookAngle), math.deg(eyeDirection),5)
		)
	else 
		self.lookAngle = math.rad(90)
	end

	self.eyeColor:set()
	god.leftEye.x = god.pos.x-40 + lengthDirectionX(8,self.lookAngle)
	god.leftEye.y = god.pos.y-8 + lengthDirectionY(8,self.lookAngle)

	god.rightEye.x = god.pos.x+32 + lengthDirectionX(8,self.lookAngle)
	god.rightEye.y = god.pos.y-8 + lengthDirectionY(8,self.lookAngle)

	love.graphics.rectangle("fill",self.leftEye.x,self.leftEye.y,8,8)
	love.graphics.rectangle("fill",self.rightEye.x,self.rightEye.y,8,8)

	if self.state == "lighting" then 
		WHITE:set()
		local lastY = self.player.pos.y
		local lastX = self.player.pos.x+self.player.rect.w/2
		for y = lastY-love.math.random(32,64), -64, -love.math.random(32,64) do
			local x = lastX + love.math.random(-48,48)
			love.graphics.setLineWidth(love.graphics.getLineWidth()+1)
			love.graphics.line(lastX, lastY, x, y)
			lastX = x
			lastY = y
		end	
		love.graphics.setLineWidth(1)
	end
end