
function loadMap(mapName)
	local map = require(mapName)

	players = Group.new()
	blocks = Group.new()
	explosions = Group.new()
	god = God.new()

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

	mapWidth  = map.width  * map.tilewidth
	mapHeight = map.height * map.tileheight

	initializeParticles() 

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
		if explosions.size == 0 and not god.lighting then
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
