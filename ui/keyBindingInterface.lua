--Author : Nicolas Reszka

KeyBindingInterface = {}
KeyBindingInterface.__index = KeyBindingInterface

local deadZone = 0.5

function KeyBindingInterface.new()
	local interface = {}
	setmetatable(interface, KeyBindingInterface)
	interface.objects = {}
	interface.width = 4
	interface.height = 5
	for i=1,4 do
		table.insert(interface.objects,{})
	end
	interface.index = Point.new(1,1)
	interface.keyLeft = false
	interface.keyRight = false
	interface.keyUp = false
	interface.keyDown = false
	interface.delay = Clock.new(0.2)
	return interface
end

function KeyBindingInterface:add(x,object)
	table.insert(self.objects[x], object)
	return object
end

function KeyBindingInterface:mousemoved(x,y,dx,dy,istouch) 
	if not self.objects[self.index.x][self.index.y].rebinding then
		for x=1,self.width do
			for y,object in pairs(self.objects[x]) do 
				if object:hover() 
				and not (x == self.index.x and y == self.index.y)
				and not (x > 1 and y == 5) then
					self.index.x = x
					self.index.y = y
					uiSfx.move:stop()
					uiSfx.move:play()
				end
			end
		end
	end
end

function KeyBindingInterface:mousepressed(x,y,button,istouch)
	self.objects[self.index.x][self.index.y]:mousepressed(x,y,button,istouch)
end

function KeyBindingInterface:keypressed(key,scancode,isrepeat)
	if not self.objects[self.index.x][self.index.y].rebinding then
		if scancode == "left" then
			self.keyLeft = true
		end
		if scancode == "right" then
			self.keyRight = true
		end
		if scancode == "up" then
			self.keyUp = true
		end
		if scancode == "down" then
			self.keyDown = true
		end
	end

	if scancode == "escape" then
		if self.objects[self.index.x][self.index.y].rebinding then
			self.objects[self.index.x][self.index.y].rebinding = false
		else 	
			controls.backButton.callback()
			menu:load()
			menu:set()
		end
	end

	self.objects[self.index.x][self.index.y]:keypressed(key,scancode,isrepeat)
end

function KeyBindingInterface:keyreleased(key,scancode)
	if scancode == "left" then
		self.keyLeft = false
	end
	if scancode == "right" then
		self.keyRight = false
	end
	if scancode == "up" then
		self.keyUp = false
	end
	if scancode == "down" then
		self.keyDown = false
	end
end

function KeyBindingInterface:gamepadpressed(joystick,button) 
	if button == "dpleft" then
		self.keyLeft = true
	end
	if button == "dpright" then
		self.keyRight = true
	end
	if button == "dpup" then
		self.keyUp = true
	end
	if button == "dpdown" then
		self.keyDown = true
	end
	
	if button == "b" then
		if self.objects[self.index.x][self.index.y].rebinding then
			self.objects[self.index.x][self.index.y].rebinding = false
		else 	
			controls.backButton.callback()
			menu:load()
			menu:set()
		end
	end

	self.objects[self.index.x][self.index.y]:gamepadpressed(joystick,button) 
end

function KeyBindingInterface:gamepadreleased(joystick,button) 
	if button == "dpleft" then
		self.keyLeft = false
	end
	if button == "dpright" then
		self.keyRight = false
	end
	if button == "dpup" then
		self.keyUp = false
	end
	if button == "dpdown" then
		self.keyDown = false
	end
end

function KeyBindingInterface:gamepadaxis(joystick,axis,value) 

	if axis == "lefty" then
		if value > deadZone then
			self.keyDown = true
			self.keyUp = false
		elseif value < -deadZone then
			self.keyDown = false
			self.keyUp = true
		else 
			self.keyDown = false
			self.keyUp = false
		end
	end
	if axis == "leftx" then
		if value > deadZone then
			self.keyRight = true
			self.keyLeft = false
		elseif value < -deadZone then
			self.keyRight = false
			self.keyLeft = true
		else 
			self.keyRight = false
			self.keyLeft = false
		end
	end
end

function KeyBindingInterface:update(dt)
	if not self.objects[self.index.x][self.index.y].rebinding then
		if self.keyUp then
			if self.delay:zero() then
				if self.index.y > 1 then
					self.index.y = self.index.y - 1 
				else 	
					self.index.y = self.height
				end
				uiSfx.move:stop()
				uiSfx.move:play()
				self.delay:tick()
			end
		elseif self.keyDown then
			if self.delay:zero() then
				if self.index.y < self.height then
					self.index.y = self.index.y + 1 
				else 	
					self.index.y = 1
				end
				uiSfx.move:stop()
				uiSfx.move:play()
				self.delay:tick()
			end
		elseif self.keyLeft then
			if self.delay:zero() then
				if self.index.x > 1 then
					self.index.x = self.index.x - 1 
				else 	
					self.index.x = self.width
				end
				uiSfx.move:stop()
				uiSfx.move:play()
				self.delay:tick()
			end
		elseif self.keyRight then
			if self.delay:zero() then
				if self.index.x < self.width then
					self.index.x = self.index.x + 1 
				else 	
					self.index.x = 1
				end
				uiSfx.move:stop()
				uiSfx.move:play()
				self.delay:tick()
			end
		else 
			self.delay:reset()
		end
	end

	if not self.delay:zero() then
		self.delay:tick()
		if self.delay:alarm() then
			self.delay:reset()
		end
	end

	for x=1,self.width do
		for y,object in pairs(self.objects[x]) do 
			if x == self.index.x and y == self.index.y then
				if not object.active then
					object.active = true
					object.rebinding = false
				end
			elseif self.objects[self.index.x][self.index.y] ~= object then
				object.active = false
			end
			if not (x > 1 and y == 5) then
				object:update(dt)
			end
		end
	end
end

function KeyBindingInterface:draw()
	love.graphics.setFont(font32)
	if self.objects[self.index.x][self.index.y].rebinding then
		YELLOW:set()
		love.graphics.print("[Any]: rebind key, [Escape]: cancel",420,620)
	elseif self.index.y == 5 then
		RED:set()
		love.graphics.print("Back to main menu",420,620)
	else
		GREEN:set()
		love.graphics.print("[Enter]: select key",420,620)
	end

	for x=1,self.width do
		for y,object in pairs(self.objects[x]) do 
			object:draw()
		end
	end


end



	