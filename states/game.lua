--Author : Nicolas Reszka

game = State.new()


local sky = {
	love.graphics.newImage("backgrounds/neonSky.png"),
	love.graphics.newImage("backgrounds/neon2Sky.png"),
	love.graphics.newImage("backgrounds/lavaSky.png"),
	love.graphics.newImage("backgrounds/cloudsSky.png"),
	love.graphics.newImage("backgrounds/getTheEyeSky.png")
}
local background = {
	love.graphics.newImage("backgrounds/mountains.png"),
	love.graphics.newImage("backgrounds/forest.png"),
	love.graphics.newImage("backgrounds/volcanos.png"),
	love.graphics.newImage("backgrounds/moon.png"),
	love.graphics.newImage("backgrounds/clouds.png")
}

local lavaFlow = love.graphics.newImage("backgrounds/lavaFlow.png")

function game:loadMap()
	local map = require(mapName)

	mapWidth  = map.width  * map.tilewidth
	mapHeight = map.height * map.tileheight

	self.players = Group.new()
	self.blocks = Group.new()
	self.explosions = Group.new()
	self.god = God.new()
	self.customParticles = Group.new()
	initializeParticles() 
	self.bombs = Group.new()
	self.specialObjects = Group.new()

	if mapName == "maps.lava" then
		self.lava = Lava.new()
	end

	local playerCounter = 0

	for i, layer in pairs(map.layers) do
		local tile = 1
		for tileY = 0, layer.height-1 do
			for tileX = 0, layer.width-1 do
				local x = tileX * map.tilewidth  + layer.offsetx
				local y = tileY * map.tileheight + layer.offsety
				if layer.data[tile] == 1 then
					self.blocks:add(Block.new(x,y))
				elseif layer.data[tile] == 2  then
					playerCounter = playerCounter + 1
					if isPlaying[playerCounter]  then
						self.players:add(
							Player.new(
								x,y,
								playerCounter,
								choosenCharacters[playerCounter]
							)
						)
					end
				elseif layer.data[tile] == 3 then
					self.blocks:add(Cloud.new(x,y))
				elseif layer.data[tile] == 4 then
					self.blocks:add(SolidBlock.new(x,y))
				elseif layer.data[tile] == 5 then
 					self.specialObjects:add(Eye.new(x,y))
  				end
				tile = tile + 1
			end
		end
	end

	if mapName == "maps.getTheEye" then
		self.halfTime = false
	else
		self.halfTime = true
	end

	if mapName == "maps.neon" then
		self.backgroundIndex = 1
	elseif mapName == "maps.neon2" then
		self.backgroundIndex = 2
	elseif mapName == "maps.lava" then
		self.backgroundIndex = 3
	elseif mapName == "maps.clouds" then
		self.backgroundIndex = 4
	elseif mapName == "maps.getTheEye" then
		self.backgroundIndex = 5
	end
end

function game:load()
	camera:translate(0,0)
	self.pause = false
	self.chat = {false,false,false,false}
	self.halfTime = true
	self:loadMap()
	self.interface = ListInterface.new()
	local left = 384
	local top = 256
	local margin = 64+16
	self.interface:add(Button.new(
		"Resume",
		Rect.new(left,top,256,64),
		function() 
			uiSfx.yes:play()
			self.pause = not self.pause
		end
	))
	self.interface:add(Button.new(
		"Change map",
		Rect.new(left,top + margin * 1,256,64),
		function() 
			camera:translate(0,0)
			uiSfx.no:play()
			selectMap:load()
			selectMap:set()	
		end
	))
	self.interface:add(Button.new(
		"Back to main menu",
		Rect.new(left-32,top + margin * 2,320,64),
		function()
			camera:translate(0,0)
			uiSfx.no:play()
			menu:load() 
			menu:set()
		end
	))
	self.interface:add(Button.new(
		"Quit",
		Rect.new(left,top + margin * 3,256,64),
		function() 
			love.event.quit()
		end
	))
	self.title = AnimatedText.new(
		0,64,"Pause",
		2,10,screen.w
	)
end

function game:mousemoved(x,y,dx,dy,istouch) 
	if self.pause then
		self.interface:mousemoved(x,y,dx,dy,istouch)
	end
end

function game:mousepressed(x,y,button,istouch)
	if self.pause then
		self.interface:mousepressed(x,y,button,istouch)
	end
end

function game:mousereleased(x,y,button,istouch)
	if self.pause then
		self.interface:mousereleased(x,y,button,istouch)
	end
end

function game:keypressed(key,scancode,isrepeat)
	if scancode == "escape" then
		self.pause = not self.pause
	end

	if self.pause then
		self.interface:keypressed(key,scancode,isreapeat)
	end
end

function game:keyreleased(key,scancode)
	if self.pause then
		self.interface:keyreleased(key,scancode)
	end
end

function game:gamepadpressed(joystick,button) 
	if button == "start" then
		self.pause = not self.pause
	end

	if self.pause then
		if button == "b" then
			self.pause = false
		end

		self.interface:gamepadpressed(joystick,button)
	end
end

function game:gamepadreleased(joystick,button) 
	if self.pause then
		self.interface:gamepadreleased(joystick,button)
	end
end

function game:gamepadaxis(joystick,axis,value) 
	if self.pause then
		self.interface:gamepadaxis(joystick,axis,value) 
	end
end

function game:update(dt)
	if self.pause then
		if sfx.lava:isPlaying() then
			sfx.lava:pause()
		end
		if dj:isPlaying() then
			dj:pause()
		end
		self.interface:update(dt)
		self.title:update(dt)
	else 
		if self.halfTime then
			self.god:update()
		end

		self.bombs:update()
		self.explosions:update()
		if self.explosions.size == 0 
		and self.god.state ~= "lighting"
		and self.specialObjects.size == 0 then
			if camera.pos.x ~= 0 or camera.pos.y ~= 0 then
				camera.pos.x = approachValues(camera.pos.x,0,1)
				camera.pos.y = approachValues(camera.pos.y,0,1)
			end
		end

		for i, input in pairs(inputs) do
			input:update()
		end

		if mapName == "maps.lava" then
			if not sfx.lava:isPlaying() then
				sfx.lava.source:play()
			end
			self.lava:update(dt)
		end

		self.blocks:update(dt)
		self.customParticles:update(dt)
		self.players:update()
		self.specialObjects:update(dt)
		updateParticles()

		dj:update()
		if not dj:isPlaying() then
			dj:play()
		end
	end
end

function game:draw()
	camera:set()
	
	love.graphics.draw(
		sky[self.backgroundIndex],
		camera.pos.x,camera.pos.y
	)
	
	love.graphics.draw(
		background[self.backgroundIndex],
		-512,-384
	)

	if mapName == "maps.lava" then
		self.lava.color:set()
		love.graphics.draw(
			lavaFlow,
			-512,
			-384
		)
		self.lava:draw()
	end

	self.blocks:draw()

	if self.halfTime then
		self.god:draw()
	end
	self.specialObjects:draw()

	self.bombs:draw()
	self.explosions:draw()
	self.customParticles:draw()
	for i, player in pairs(self.players.objects) do
		player:drawRainbow()
	end
	chatColor:set()
	love.graphics.draw(fireParticles)
	self.players:draw()

	drawParticles()

	if mapName == "maps.lava" then
		self.lava:draw()
	end

	camera:unset()

	if self.pause then
		love.graphics.setColor(0,0,0,192)
		love.graphics.rectangle("fill",0,0,screen.w,screen.h)
		love.graphics.setFont(font72)
		self.title:draw()
		self.interface:draw()
	end
end
