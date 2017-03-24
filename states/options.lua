options = State.new()

function options:load()
	self.interface = ListInterface.new()
	self.interface:add(Switch.new(
		"fullscreen",
		Rect.new(64,64,256,64),
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
		"volume",
		Rect.new(64,192,256,64),
		love.audio.getVolume(),
		function(value) 
			love.audio.setVolume(value)
		end
	))
	self.interface:add(Button.new(
		"back",
		Rect.new(64,320,128,64),
		function() 
			menu:set()
			gameState:load()
		end
	))
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
end

function options:keyreleased(key,scancode)
	self.interface:keyreleased(key,scancode)
end

function options:gamepadpressed(joystick,button) 
	self.interface:gamepadpressed(inputs[1].joystick,button)
end

function options:gamepadreleased(joystick,button) 
	self.interface:gamepadreleased(inputs[1].joystick,button)
end

function options:gamepadaxis(joystick,axis,value) 
	self.interface:gamepadaxis(inputs[1].joystick,axis,value) 
end

function options:update(dt)
	self.interface:update(dt)
end

function options:draw()
	self.interface:draw()
end
