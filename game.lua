function loadMap(mapName)
	local map = require(mapName)

	players = Group.new()
	blocks = Group.new()
	spawners = Group.new()
	bubbles = Group.new()
	explosions = Group.new()

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
				elseif layer.data[tile] == 3 then
					spawners:add(Point.new(x,y))
				end
				tile = tile+1
			end
		end
	end

	mapWidth  = map.width  * map.tilewidth
	mapHeight = map.height * map.tileheight

	initializeParticles() 

	chat = 0
	bubblesLeft = 0
	halfTime = true
end

function updateGame()
	if pause then

	else 
		if halfTime then
			if bubbles.size ~= players.size-1 then
				for i = 1, players.size-1 do
					local n = love.math.random(1,spawners.size)
					local spawner = spawners.objects[n]
					bubbles:add(Bubble.new(spawner.x,spawner.y))
					bubblesLeft = bubblesLeft+1
					spawners:remove(spawner)
				end
			end

			if players.size > 1 then
				if bubblesLeft == 0 then
					for i, player in pairs(players.objects) do
						if not player.protected then
							chat = player.slot
						else 
							player.protected = false
						end
					end
					bubbles = Group.new()
					halfTime = false
				end
			elseif players.size == 1 then
				print("player " .. players.objects[1].slot .. " wins!")
				halfTime = false
			else 
				print("It's a tie !")
				halfTime = false
			end 
		end

		for i, input in pairs(inputs) do
			input:update()
		end

		explosions:update()
		players:update()
		bubbles:update()
		updateParticles()

		if explosions.size == 0 then
			if camera.pos.x ~= 0 or camera.pos.y ~= 0 then
				camera.pos.x = approachValues(camera.pos.x,0,1)
				camera.pos.y = approachValues(camera.pos.y,0,1)
			end
		end

	end
end