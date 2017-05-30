--Author : Nicolas Reszka

menu = State.new()

function menu:load()
	self.interface = ListInterface.new()
	local left = 384
	local top = 256
	local margin = 64+16
	self.interface:add(Button.new(
		"Play",
		Rect.new(left,top,256,64),
		function() 
			uiSfx.yes:play()
			selectCharacters:load()
			selectCharacters:set()
		end
	))
	self.interface:add(Button.new(
		"Controls",
		Rect.new(left,top + margin * 1,256,64),
		function() 
			uiSfx.yes:play()
			controls:load()
			controls:set()
		end
	))
	self.interface:add(Button.new(
		"Options",
		Rect.new(left,top + margin * 2,256,64),
		function() 
			uiSfx.yes:play()
			options:load()
			options:set()
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
		200,64,"Stwalcha",
		1,16,string.len("Stwalcha")*72
	)
end

function menu:mousemoved(x,y,dx,dy,istouch) 
	self.interface:mousemoved(x,y,dx,dy,istouch)
end

function menu:mousepressed(x,y,button,istouch)
	self.interface:mousepressed(x,y,button,istouch)
end

function menu:mousereleased(x,y,button,istouch)
	self.interface:mousereleased(x,y,button,istouch)
end

function menu:keypressed(key,scancode,isrepeat)
	self.interface:keypressed(key,scancode,isreapeat)
end

function menu:keyreleased(key,scancode)
	self.interface:keyreleased(key,scancode)
end

function menu:gamepadpressed(joystick,button) 
	self.interface:gamepadpressed(inputs[1].joystick,button)
end

function menu:gamepadreleased(joystick,button) 
	self.interface:gamepadreleased(inputs[1].joystick,button)
end

function menu:gamepadaxis(joystick,axis,value) 
	self.interface:gamepadaxis(inputs[1].joystick,axis,value) 
end

function menu:update(dt)
	self.interface:update(dt)
	self.title:update(dt)
end

function menu:draw()
	love.graphics.setFont(font72)
	self.title:draw()
	-- GREEN:set()
	-- love.graphics.setFont(font16)
	-- love.graphics.print("2017 Nicolas Reszka", 32,700)
	self.interface:draw()
end
