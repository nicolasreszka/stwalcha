--Author : Nicolas Reszka

menu = State.new()

function menu:load()
	self.interface = ListInterface.new()
	self.interface:add(Button.new(
		"play",
		Rect.new(64,64,256,64),
		function() 
			selectCharacters:set()
			gameState:load()
		end
	))
	self.interface:add(Button.new(
		"controls",
		Rect.new(64,192,256,64),
		function() 
			controls:set()
			gameState:load()
		end
	))
	self.interface:add(Button.new(
		"options",
		Rect.new(64,320,256,64),
		function() 
			options:set()
			gameState:load()
		end
	))
	self.interface:add(Button.new(
		"quit",
		Rect.new(64,448,128,64),
		function() 
			love.event.quit()
		end
	))
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
end

function menu:draw()
	WHITE:set()
	love.graphics.setFont(font48)
	love.graphics.print("Stwalcha",512,64)
	love.graphics.setFont(font32)
	love.graphics.print("2017 Nicolas Reszka", 512,600)
	self.interface:draw()
end
