local game = {}

function loadMap()
	local map = require(mapName)

	mapWidth  = map.width  * map.tilewidth
	mapHeight = map.height * map.tileheight

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
				tile = tile + 1
			end
		end
	end
end

function game:load()
	camera:translate(0,0)
	pause = false
	chat = 0
	halfTime = true
	loadMap()
end

function game:update(dt)
	if menuInput.pausePressed then
		pause = not pause
	end

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

function game:draw()
	camera:set()
	blocks:draw()

	players:draw()
	explosions:draw()
	
	if halfTime then
		god:draw()
	end

	drawParticles()
	camera:unset()
end

return game