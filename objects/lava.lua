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

	lava.color1 = Color.new(200,0,0)
	lava.color2 =  Color.new(200,128,0)
	lava.color = lava.color1:clone()
	lava.currentColor = 0
	return lava
end

function Lava:update(dt)

	if self.colorCurrent == 0 then
		self.color:transform(
			1,
			self.color2
		)
		if self.color:compare(self.color2) then
			self.colorCurrent = 1
		end
	else 
		self.color:transform(
			1,
			self.color1
		)
		if self.color:compare(self.color1) then
			self.colorCurrent = 0
	
		end
	end

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

	for i,player in pairs(game.players.objects) do
		if lineVsRect(self.line,player.rect) then
			for drops = 0, love.math.random(6,8) do
				game.customParticles:add(
					LavaDrop.new(
						player.pos.x, self.line.a.y
					)
				)
			end
			if not player.sfx.splash:isPlaying() then
				player.sfx.splash.source:setPitch(love.math.random(0.75,1))

				player.sfx.splash:playAt(player.pos)
			end

			if game.chat == player.slot 
			or game.god.state == "lighting" 
			and game.god.player.slot == player.slot then
				player:explode()
			else
				game.players:remove(player)
			end
		end
	end

	for i,customParticle in pairs(game.customParticles.objects) do
		if customParticle.type == "drop" then
			if customParticle.vy > 0 
			and customParticle.circle.pos.y > self.line.a.y then
				game.customParticles:remove(customParticle)
			end
		end
	end

	if game.explosions.size == 0
	and game.players.size <= 1 then
		game.halfTime = true
	end
end

function Lava:draw()
	self.color:set()
	love.graphics.polygon("fill",
		{
			self.line.a.x,self.line.a.y,
			self.line.b.x,self.line.b.y,
			self.line.b.x,mapHeight+32,
			self.line.a.x,mapHeight+32
		}
	)
end