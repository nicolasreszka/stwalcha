--Author : Nicolas Reszka

controls = State.new()

function controls:load()
	self.interface = KeyBindingInterface.new()
	local componentWidth = 128
	local componentHeight = 64
	local margin = 32
	for y=1,4 do	
		self.interface:add(1,KeyBinder.new(
			"left",
			inputs[y].left,
			Rect.new(
				256,
				128+(componentHeight+margin)*(y-1),
				componentWidth,
				componentHeight
			),
			function(key) 
				inputs[y].left = key
			end
		))
		self.interface:add(2,KeyBinder.new(
			"right",
			inputs[y].right,
			Rect.new(
				256+(componentWidth +margin),
				128+(componentHeight+margin)*(y-1),
				componentWidth,
				componentHeight
			),
			function(key) 
				inputs[y].right = key
			end
		))
		self.interface:add(3,KeyBinder.new(
			"jump",
			inputs[y].jump,
			Rect.new(
				256+(componentWidth +margin)*2,
				128+(componentHeight+margin)*(y-1),
				componentWidth,
				componentHeight
			),
			function(key) 
				inputs[y].jump = key
			end
		))
	end

	local backButton = Button.new(
		"back",
		Rect.new(
			256,
			128+(componentHeight+margin)*4,
			128,
			componentHeight
		),
		function() 
			local data = ""
			for i, input in pairs(inputs) do
				data = data .. "left" .. i .. " = " .. input.left .. ";"
				data = data .. "right" .. i .. " = " .. input.right .. ";"
				data = data .. "jump" .. i .. " = " .. input.jump .. ";"
			end
			love.filesystem.write("controls.txt",data)
			menu:set()
			gameState:load()
		end
	)
	self.interface:add(1,backButton)
	self.interface:add(2,backButton)
	self.interface:add(3,backButton)
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
end

function controls:draw()
	for i=1,4 do
		love.graphics.setFont(font32)
		love.graphics.print("player " .. i, 32, 32+96*i)
	end

	love.graphics.print("left", 256, 64)
	love.graphics.print("right", 416,64)
	love.graphics.print("jump", 576, 64)

	self.interface:draw()
end
