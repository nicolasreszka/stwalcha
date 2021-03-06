--Author : Nicolas Reszka

options = State.new()

local backgroundImage = love.graphics.newImage("backgrounds/otherMenusBackground.png")

function options:load()
	self.interface = ListInterface.new()
	local left = 160
	local top = 192
	local margin = 92
	self.interface:add(Switch.new(
		"Fullscreen",
		Rect.new(left,top,720,32),
		love.window.getFullscreen(),
		function(on) 
			if on then
				love.window.setFullscreen(true)
			else
				love.window.setFullscreen(false)
			end
		end
	))
	local filter = screen.canvas:getFilter()
	if filter == "linear" then
		filter = true
	else
		filter = false
	end
	self.filterSwitch = Switch.new(
		"Filter",
		Rect.new(left,top + margin,720,32),
		filter,
		function(on) 
			if on then
				screen.canvas:setFilter("linear","linear",16)
			else
				screen.canvas:setFilter("nearest","nearest")
			end
		end
	)
	self.interface:add(self.filterSwitch)
	self.interface:add(Switch.new(
		"Show player names",
		Rect.new(left,top + margin * 2,720,32),
		showPlayerNames,
		function(on) 
			if on then
				showPlayerNames = true
			else
				showPlayerNames = false
			end
		end
	))
	self.interface:add(Slider.new(
		"Sfx volume",
		Rect.new(left,top + margin * 3,720,32),
		soundVolume,
		function(value) 
			soundVolume = value
			for i,uiSound in pairs(uiSfx) do
				uiSound:setVolume(soundVolume)
			end
		end
	))
	self.interface:add(Slider.new(
		"Music volume",
		Rect.new(left,top + margin * 4,720,32),
		musicVolume,
		function(value) 
			musicVolume = value
		end
	))
	self.interface:add(Button.new(
		"<< Back",
		Rect.new(left,top + margin * 5,128,64),
		function() 
			for i,soundFX in pairs(sfx) do
				soundFX:setVolume(soundVolume)
			end
			dj:setVolume(musicVolume)
			local data = ""
			data = data .. "fullscreen = " .. booleanToString(love.window.getFullscreen())
			data = data .. ";"
			data = data .. "filter = " .. booleanToString(self.filterSwitch.on)
			data = data .. ";"
			data = data .. "showPlayerNames = " .. booleanToString(showPlayerNames)
			data = data .. ";"
			data = data .. "volume = " .. soundVolume
			data = data .. ";"
			data = data .. "musicvolume = " .. musicVolume
			data = data .. ";"
			love.filesystem.write("settings.txt",data)
			uiSfx.no:stop()
			uiSfx.no:play()
			menu:load()
			menu:set()
			menu.saveClock:reset()
		end
	))

	self.title = AnimatedText.new(
		220,48,"Options",
		1,10,string.len("Options")*72
	)
end

function options:mousemoved(x,y,dx,dy,istouch) 
	self.interface:mousemoved(x,y,dx,dy,istouch)
end

function options:mousepressed(x,y,button,istouch)
	self.interface:mousepressed(x,y,button,istouch)
end

function options:mousereleased(x,y,button,istouch)
	self.interface:mousereleased(x,y,button,istouch)
end

function options:keypressed(key,scancode,isrepeat)
	self.interface:keypressed(key,scancode,isreapeat)

	if scancode == "escape" then
		self.interface.objects[6].callback()
	end
end

function options:keyreleased(key,scancode)
	self.interface:keyreleased(key,scancode)
end

function options:gamepadpressed(joystick,button) 
	self.interface:gamepadpressed(joystick,button)

	if button == "b" then
		self.interface.objects[6].callback()
	end
end

function options:gamepadreleased(joystick,button) 
	self.interface:gamepadreleased(joystick,button)
end

function options:gamepadaxis(joystick,axis,value) 
	self.interface:gamepadaxis(joystick,axis,value) 
end

function options:update(dt)
	self.interface:update(dt)
	self.title:update(dt)
end

function options:draw()
	WHITE:set()
	love.graphics.draw(
		backgroundImage,
		0,0
	)

	love.graphics.setFont(font72)
	self.title:draw()
	self.interface:draw()
end
