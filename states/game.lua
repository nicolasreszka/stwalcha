game = State.new()

function loadMap()
	local map = require(mapName)

	mapWidth  = map.width  * map.tilewidth
	mapHeight = map.height * map.tileheight

	game.players = Group.new()
	game.blocks = Group.new()
	game.explosions = Group.new()
	game.god = God.new()
	initializeParticles() 

	for i, layer in pairs(map.layers) do
		local tile = 1
		for tileY = 0, layer.height-1 do
			for tileX = 0, layer.width-1 do
				local x = tileX * map.tilewidth  + layer.offsetx
				local y = tileY * map.tileheight + layer.offsety
				if layer.data[tile] == 1 then
					game.blocks:add(Block.new(x,y))
				elseif layer.data[tile] == 2 and game.players.size < numberOfPlayers then
					game.players:add(Player.new(x,y,game.players.size+1))
				end
				tile = tile + 1
			end
		end
	end
end

function game:load()
	camera:translate(0,0)
	self.pause = false
	self.chat = 0
	self.halfTime = true
	loadMap()
end

function game:keypressed(key,scancode,isrepeat)
	if scancode == "escape" then
		self.pause = not self.pause
	end
end

function game:update(dt)
	if self.pause then
		
	else 
		if self.halfTime then
			self.god:update()
		end

		self.explosions:update()
		if self.explosions.size == 0 and self.god.state ~= "lighting" then
			if camera.pos.x ~= 0 or camera.pos.y ~= 0 then
				camera.pos.x = approachValues(camera.pos.x,0,1)
				camera.pos.y = approachValues(camera.pos.y,0,1)
			end
		end

		for i, input in pairs(inputs) do
			input:update()
		end

		self.players:update()
		updateParticles()
	end
end

function game:draw()
	camera:set()
	self.blocks:draw()

	self.players:draw()
	self.explosions:draw()
	
	if self.halfTime then
		self.god:draw()
	end

	drawParticles()
	camera:unset()
end
