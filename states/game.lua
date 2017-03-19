
function loadAudio()
	sfx = {
		jump = love.audio.newSource("sounds/jump.wav", "static"),
		bump = love.audio.newSource("sounds/bump.wav", "static"),
		land = love.audio.newSource("sounds/land.wav", "static"),
		slide = love.audio.newSource("sounds/slide.wav", "static"),
		tick = love.audio.newSource("sounds/tick.wav", "static"),
		fireworks = love.audio.newSource("sounds/fireworks.wav", "stream"),
		lighting = Sound.new(love.audio.newSource("sounds/lighting.wav", "stream")),
		explosion = Sound.new(love.audio.newSource("sounds/explosion.wav", "stream")),
		god = Sound.new(love.audio.newSource("sounds/god.wav", "stream"))
	}
	love.audio.setPosition(0,0,0)
end

function loadMap()
	local map = require(mapName)

	mapWidth  = map.width  * map.tilewidth
	mapHeight = map.height * map.tileheight

	worldCreationEffect = false
	worldCreationEffectTimer = Clock.new(2.1)

	players = Group.new()
	blocks = Group.new()
	explosions = Group.new()
	god = God.new()
	initializeParticles() 

	for i, layer in pairs(map.layers) do
		local tile = 1
		for tileY = 0, layer.height-1 do
			for tileX = 0, layer.width-1 do
				local x = tileX * map.tilewidth  + layer.offsetx
				local y = tileY * map.tileheight + layer.offsety
				if layer.data[tile] == 1 then
					blocks:add(Block.new(x,y))
				elseif layer.data[tile] == 2 and players.size < numberOfPlayers then
					players:add(Player.new(x,y,players.size+1))
				end
				tile = tile+1
			end
		end
	end

	chat = 0
	halfTime = true
end

function updateGame()
	if pause then
		
	else 
		if halfTime then
			god:update()
		end

		explosions:update()
		if explosions.size == 0 and god.state ~= "lighting" then
			if camera.pos.x ~= 0 or camera.pos.y ~= 0 then
				camera.pos.x = approachValues(camera.pos.x,0,1)
				camera.pos.y = approachValues(camera.pos.y,0,1)
			end
		end

		for i, input in pairs(inputs) do
			input:update()
		end

		players:update()
		updateParticles()

	end
	
end
