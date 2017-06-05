--Author : Nicolas Reszka

game = State.new()

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
		-- for tileX = 0, 63 do
		-- 	self.blocks:add(SolidBlock.new(tileX*16,-16))
		-- end
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
			uiSfx.no:play()
			selectMap:load()
			selectMap:set()	
		end
	))
	self.interface:add(Button.new(
		"Back to main menu",
		Rect.new(left-32,top + margin * 2,320,64),
		function()
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

	if scancode == "r" then
		self:load()
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
		self.interface:update(dt)
		self.title:update(dt)
	else 
		if self.halfTime then
			self.god:update()
		end

		self.bombs:update()
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
	end
end

function game:draw()
	camera:set()

	if mapName == "maps.clouds" then
		love.graphics.setColor(30, 147, 206)
		love.graphics.rectangle(
			"fill",
			camera.pos.x,
			camera.pos.y,
			screen.w,
			screen.h
		)
	end

	self.blocks:draw()

	if self.halfTime then
		self.god:draw()
	end
	self.specialObjects:draw()

	self.bombs:draw()
	self.explosions:draw()
	self.customParticles:draw()
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

	-- RED:set()
	-- love.graphics.print(self.god.state,64,64)
end
