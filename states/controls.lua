--Author : Nicolas Reszka

controls = State.new()

function controls:load()
	self.interface = KeyBindingInterface.new()
	local componentWidth = 172
	local componentHeight = 64
	local xInterface = 192
	local yInterface = 128
	local xMargin = 24
	local yMargin = 32
	for x=1,4 do	
		self.interface:add(x,KeyBinder.new(
			"left",
			inputs[x].left,
			Rect.new(
				xInterface+(componentWidth +xMargin)*(x-1),
				yInterface+(componentHeight+yMargin),
				componentWidth,
				componentHeight
			),
			function(key) 
				inputs[x].left = key
			end
		))
		self.interface:add(x,KeyBinder.new(
			"right",
			inputs[x].right,
			Rect.new(
				xInterface+(componentWidth +xMargin)*(x-1),
				yInterface+(componentHeight+yMargin)*2,
				componentWidth,
				componentHeight
			),
			function(key) 
				inputs[x].right = key
			end
		))
		self.interface:add(x,KeyBinder.new(
			"jump",
			inputs[x].jump,
			Rect.new(
				xInterface+(componentWidth +xMargin)*(x-1),
				yInterface+(componentHeight+yMargin)*3,
				componentWidth,
				componentHeight
			),
			function(key) 
				inputs[x].jump = key
			end
		))
		self.interface:add(x,KeyBinder.new(
			"back",
			inputs[x].back,
			Rect.new(
				xInterface+(componentWidth +xMargin)*(x-1),
				yInterface+(componentHeight+yMargin)*4,
				componentWidth,
				componentHeight
			),
			function(key) 
				inputs[x].back = key
			end
		))
	end

	self.backButton = Button.new(
		"Back",
		Rect.new(
			xInterface,
			yInterface+(componentHeight+yMargin)*5,
			componentWidth,
			componentHeight
		),
		function() 
			local data = ""
			for i, input in pairs(inputs) do
				data = data .. "left" .. i .. " = " .. input.left .. ";"
				data = data .. "right" .. i .. " = " .. input.right .. ";"
				data = data .. "jump" .. i .. " = " .. input.jump .. ";"
				data = data .. "back" .. i .. " = " .. input.back .. ";"
			end
			love.filesystem.write("controls.txt",data)
			uiSfx.no:stop()
			uiSfx.no:play()
			menu:load()
			menu:set()
			menu.saveClock:reset()
		end
	)
	self.interface:add(1,self.backButton)
	self.interface:add(2,self.backButton)
	self.interface:add(3,self.backButton)
	self.interface:add(4,self.backButton)

	self.title = AnimatedText.new(
		220,48,"Controls",
		1,10,string.len("Controls")*72
	)
end

function controls:mousemoved(x,y,dx,dy,istouch) 
	self.interface:mousemoved(x,y,dx,dy,istouch)
end

function controls:mousepressed(x,y,button,istouch)
	self.interface:mousepressed(x,y,button,istouch)
end

function controls:keypressed(key,scancode,isrepeat)
	self.interface:keypressed(key,scancode,isreapeat)
end

function controls:keyreleased(key,scancode)
	self.interface:keyreleased(key,scancode)
end

function controls:gamepadpressed(joystick,button) 
	self.interface:gamepadpressed(inputs[1].joystick,button)
end

function controls:gamepadreleased(joystick,button) 
	self.interface:gamepadreleased(inputs[1].joystick,button)
end

function controls:gamepadaxis(joystick,axis,value) 
	self.interface:gamepadaxis(inputs[1].joystick,axis,value) 
end

function controls:update(dt)
	self.interface:update(dt)
	self.title:update(dt)
end

function controls:draw()
	love.graphics.setFont(font72)
	self.title:draw()

	for i=1,4 do
		colors[i]:set()
		love.graphics.setFont(font32)
		love.graphics.print(
			"Player " .. i, 
			192+(string.len("Player")*32+4)*(i-1), 
			160
		)
	end

	YELLOW:set()
	love.graphics.print("Left", 48, 230)
	love.graphics.print("Right",48, 230+96)
	love.graphics.print("Jump", 48, 230+96*2)
	love.graphics.print("Back", 48, 230+96*3)

	self.interface:draw()
	self.backButton.rect:draw("line")
end
