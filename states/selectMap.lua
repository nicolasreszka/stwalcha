selectMap = State.new()

function selectMap:load()
	self.interface = GridInterface.new(2,1)
	self.interface:add(1,Button.new(
		"map 1",
		Rect.new(64,64,128,64),
		function() 
			mapName = "maps.test0"
			game:set()
			gameState:load()
		end
	))
	self.interface:add(2,Button.new(
		"map 2",
		Rect.new(320,64,128,64),
		function() 
			mapName = "maps.test1"
			game:set()
			gameState:load()
		end
	))
end

function selectMap:mousemoved(x,y,dx,dy,istouch) 
	self.interface:mousemoved(x,y,dx,dy,istouch)
end

function selectMap:mousepressed(x,y,button,istouch)
	self.interface:mousepressed(x,y,button,istouch)
end

function selectMap:keypressed(key,scancode,isrepeat)
	self.interface:keypressed(key,scancode,isreapeat)
end

function selectMap:keyreleased(key,scancode)
	self.interface:keyreleased(key,scancode)
end

function selectMap:gamepadpressed(joystick,button) 
	self.interface:gamepadpressed(inputs[1].joystick,button)
end

function selectMap:gamepadreleased(joystick,button) 
	self.interface:gamepadreleased(inputs[1].joystick,button)
end

function selectMap:gamepadaxis(joystick,axis,value) 
	self.interface:gamepadaxis(inputs[1].joystick,axis,value) 
end

function selectMap:update(dt)
	self.interface:update(dt)
end

function selectMap:draw()
	self.interface:draw()
end
