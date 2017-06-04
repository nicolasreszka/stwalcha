--Author : Nicolas Reszka

options = State.new()

function options:load()
	self.interface = ListInterface.new()
	local left = 160
	local top = 256
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
	self.interface:add(Slider.new(
		"Volume",
		Rect.new(left,top + margin,720,32),
		love.audio.getVolume(),
		function(value) 
			love.audio.setVolume(value)
		end
	))
	self.interface:add(Button.new(
		"Back",
		Rect.new(left,top + margin * 2,128,64),
		function() 
			local data = ""
			data = data .. "fullscreen = " .. booleanToString(love.window.getFullscreen())
			data = data .. ";"
			data = data .. "volume = " .. love.audio.getVolume()
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
		self.interface.objects[3].callback()
	end
end

function options:keyreleased(key,scancode)
	self.interface:keyreleased(key,scancode)
end

function options:gamepadpressed(joystick,button) 
	self.interface:gamepadpressed(inputs[1].joystick,button)

	if joystick == inputs[1].joystick and button == "b" then
		self.interface.objects[3].callback()
	end
end

function options:gamepadreleased(joystick,button) 
	self.interface:gamepadreleased(inputs[1].joystick,button)
end

function options:gamepadaxis(joystick,axis,value) 
	self.interface:gamepadaxis(inputs[1].joystick,axis,value) 
end

function options:update(dt)
	self.interface:update(dt)
	self.title:update(dt)
end

function options:draw()
	
	love.graphics.setFont(font72)
	self.title:draw()
	self.interface:draw()
end
