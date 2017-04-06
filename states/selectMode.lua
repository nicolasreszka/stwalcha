--Author : Nicolas Reszka

selectMode = State.new()

function selectMode:load()
	self.interface = ListInterface.new()
	self.interface:add(Button.new(
		"2 players mode",
		Rect.new(64,64,256,64),
		function() 
			numberOfPlayers = 2
			selectMap:set()
			gameState:load()
		end
	))
	self.interface:add(Button.new(
		"3 players mode",
		Rect.new(64,192,256,64),
		function() 
			numberOfPlayers = 3
			selectMap:set()
			gameState:load()
		end
	))
	self.interface:add(Button.new(
		"4 players mode",
		Rect.new(64,320,256,64),
		function() 
			numberOfPlayers = 4
			selectMap:set()
			gameState:load()
		end
	))
	self.interface:add(Button.new(
		"back",
		Rect.new(64,448,128,64),
		function() 
			menu:set()
			gameState:load()
		end
	))
end

function selectMode:mousemoved(x,y,dx,dy,istouch) 
	self.interface:mousemoved(x,y,dx,dy,istouch)
end

function selectMode:mousepressed(x,y,button,istouch)
	self.interface:mousepressed(x,y,button,istouch)
end

function selectMode:mousereleased(x,y,button,istouch)
	self.interface:mousereleased(x,y,button,istouch)
end

function selectMode:keypressed(key,scancode,isrepeat)
	self.interface:keypressed(key,scancode,isreapeat)

	if scancode == "escape" then
		menu:set()
		gameState:load()
	end
end

function selectMode:keyreleased(key,scancode)
	self.interface:keyreleased(key,scancode)
end

function selectMode:gamepadpressed(joystick,button) 
	self.interface:gamepadpressed(inputs[1].joystick,button)

	if joystick == inputs[1].joystick and button == "b" then
		menu:set()
		gameState:load()
	end
end

function selectMode:gamepadreleased(joystick,button) 
	self.interface:gamepadreleased(inputs[1].joystick,button)
end

function selectMode:gamepadaxis(joystick,axis,value) 
	self.interface:gamepadaxis(inputs[1].joystick,axis,value) 
end

function selectMode:update(dt)
	self.interface:update(dt)
end

function selectMode:draw()
	self.interface:draw()
end
