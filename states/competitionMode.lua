--Author : Nicolas Reszka

competitionMode = State.new()

function competitionMode:load()
	self.interface = ListInterface.new()
	local left = 352
	local top = 352
	local margin = 92
	self.interface:add(Selector.new(
		Rect.new(left,top,320,64),
		{2,3,4,5,6,7,8,9,10},
		2,
		function(value)
			numberOfRounds = value
		end
	))
	self.interface:add(Button.new(
		"OK",
		Rect.new(left,top + margin,320,64),
		function() 
			uiSfx.yes:stop()
			uiSfx.yes:play()
			selectCharacters:load()
			selectCharacters:set()
		end
	))
	self.interface:add(Button.new(
		"Back to main menu",
		Rect.new(left,top + margin * 2,320,64),
		function() 
			uiSfx.no:stop()
			uiSfx.no:play()
			menu:load()
			menu:set()
		end
	))

	self.title = AnimatedText.new(
		0,48,"Competition mode",
		1,10,screen.w
	)
	self.title2 = AnimatedText.new(
		0,220,"Choose number of rounds",
		1,10,screen.w
	)
end

function competitionMode:mousemoved(x,y,dx,dy,istouch) 
	self.interface:mousemoved(x,y,dx,dy,istouch)
end

function competitionMode:mousepressed(x,y,button,istouch)
	self.interface:mousepressed(x,y,button,istouch)
end

function competitionMode:mousereleased(x,y,button,istouch)
	self.interface:mousereleased(x,y,button,istouch)
end

function competitionMode:keypressed(key,scancode,isrepeat)
	self.interface:keypressed(key,scancode,isreapeat)

	if scancode == "escape" then
		self.interface.objects[3].callback()
	end
end

function competitionMode:keyreleased(key,scancode)
	self.interface:keyreleased(key,scancode)
end

function competitionMode:gamepadpressed(joystick,button) 
	self.interface:gamepadpressed(inputs[1].joystick,button)

	if joystick == inputs[1].joystick and button == "b" then
		self.interface.objects[3].callback()
	end
end

function competitionMode:gamepadreleased(joystick,button) 
	self.interface:gamepadreleased(inputs[1].joystick,button)
end

function competitionMode:gamepadaxis(joystick,axis,value) 
	self.interface:gamepadaxis(inputs[1].joystick,axis,value) 
end

function competitionMode:update(dt)
	self.interface:update(dt)
	self.title:update(dt)
	self.title2:update(dt)
end

function competitionMode:draw()
	love.graphics.setFont(font72)
	self.title:draw()
	love.graphics.setFont(font32)
	self.title2:draw()
	self.interface:draw()
end
