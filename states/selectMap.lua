--Author : Nicolas Reszka

selectMap = State.new()

function selectMap:load()
	self.interface = GridInterface.new(3,4)
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
		Rect.new(230,64,128,64),
		function() 
			mapName = "maps.test1"
			game:set()
			gameState:load()
		end
	))
	self.interface:add(3,Button.new(
		"map 3",
		Rect.new(396,64,128,64),
		function() 
			mapName = "maps.test2"
			game:set()
			gameState:load()
		end
	))
	self.interface:add(1,Button.new(
		"map 4",
		Rect.new(64,192,128,64),
		function() 
			mapName = "maps.test3"
			game:set()
			gameState:load()
		end
	))
	self.interface:add(2,Button.new(
		"map 5",
		Rect.new(230,192,128,64),
		function() 
			mapName = "maps.test4"
			game:set()
			gameState:load()
		end
	))
	self.interface:add(3,Button.new(
		"map 6",
		Rect.new(396,192,128,64),
		function() 
			mapName = "maps.test5"
			game:set()
			gameState:load()
		end
	))
	local backButton = Button.new(
		"back",
		Rect.new(64,448,128,64),
		function() 
			selectMode:set()
			gameState:load()
		end
	)
	self.interface:add(1,backButton)
	self.interface:add(2,backButton)
	self.interface:add(3,backButton)
end

function selectMap:mousemoved(x,y,dx,dy,istouch) 
	self.interface:mousemoved(x,y,dx,dy,istouch)
end

function selectMap:mousepressed(x,y,button,istouch)
	self.interface:mousepressed(x,y,button,istouch)
end

function selectMap:keypressed(key,scancode,isrepeat)
	self.interface:keypressed(key,scancode,isreapeat)

	if scancode == "escape" then
		selectMode:set()
		gameState:load()
	end
end

function selectMap:keyreleased(key,scancode)
	self.interface:keyreleased(key,scancode)
end

function selectMap:gamepadpressed(joystick,button) 
	self.interface:gamepadpressed(inputs[1].joystick,button)

	if joystick == inputs[1].joystick and button == "b" then
		selectMode:set()
		gameState:load()
	end
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
