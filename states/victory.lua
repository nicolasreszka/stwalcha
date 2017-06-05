--Author : Nicolas Reszka

victory = State.new()

function victory:load()
	self.fireworksTimer = Clock.new(.15)
	self.winners = {}
	self.numberOfPlayers = 0
	local maxVictoryPoints = math.max(unpack(victoryPoints))
	for i=1,4 do
		if isPlaying[i] then
			self.numberOfPlayers = self.numberOfPlayers + 1
			if victoryPoints[i] == maxVictoryPoints then
				table.insert(self.winners,i)
			end	
		end
	end

	mapWidth = screen.w 
	mapHeight = screen.h

	game.chat = {false,false,false,false}
	game.halfTime = false

	game.blocks = Group.new()
	game.players = Group.new()
	game.customParticles = Group.new()
	game.explosions = Group.new()
	game.god = God.new()
	initializeParticles() 

	self.playerSpawnPoints = {nil,nil,nil,nil}

	local map = require("maps.victory")
	local playerCounter = 0
	for i, layer in pairs(map.layers) do
		local tile = 1
		for tileY = 0, layer.height-1 do
			for tileX = 0, layer.width-1 do
				local x = tileX * map.tilewidth  + layer.offsetx
				local y = tileY * map.tileheight + layer.offsety
				if layer.data[tile] == 2  then
					playerCounter = playerCounter + 1
					self.playerSpawnPoints[playerCounter] = Point.new(x,y)
				elseif layer.data[tile] == 4 then
					game.blocks:add(SolidBlock.new(x,y))
				end
				tile = tile + 1
			end
		end
	end

	for i,slot in pairs(self.winners) do
		game.players:add(
			Player.new(
				self.playerSpawnPoints[slot].x,
				self.playerSpawnPoints[slot].y,
				slot,choosenCharacters[slot]
			)
		)
	end

	if self.numberOfPlayers == #self.winners then
		game.lava = Lava.new()
		self.text = AnimatedText.new(
			0,128,"Deadlock !",
			1,10,screen.w
		)
		self.clock = Clock.new(10)
	else 	
		self.text = AnimatedText.new(
			0,128,"Victory !",
			1,10,screen.w
		)
		self.clock = Clock.new(5.5)
	end

end

function victory:update(dt)
	for i, input in pairs(inputs) do
		input:update()
	end

	if self.numberOfPlayers == #self.winners then
		if not sfx.lava:isPlaying() then
			sfx.lava.source:play()
		end
		game.lava:update(dt)
	else
		self.fireworksTimer:tick()
		if self.fireworksTimer:alarm() 
		and self.fireworksTimer.duration < 0.5 then
			local fireX = love.math.random(256,700)
			local fireY = love.math.random(128,512)
			local fire = Sound.new(sfx.fireworks)
			fire:playAt(Point.new(fireX,fireY))
			instantiateFireworks(fireX,fireY,love.math.random(8,12))
			self.fireworksTimer:setDuration(self.fireworksTimer.duration*1.1)
			self.fireworksTimer:reset()
		end
	end

	game.blocks:update(dt)
	game.customParticles:update(dt)
	game.players:update()
	updateParticles()

	self.text:update(dt)

	self.clock:tick()
	if self.clock:alarm() then
		if sfx.lava:isPlaying() then
			sfx.lava:stop()
		end
		selectMap:load()
		selectMap:set()
	end
end

function victory:draw()
	game.blocks:draw()
	game.customParticles:draw()
	game.players:draw()
	drawParticles()

	if self.numberOfPlayers == #self.winners then
		game.lava:draw()
	end

	love.graphics.setFont(font72)
	self.text:draw()
end
