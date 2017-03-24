ListInterface = {}
ListInterface.__index = ListInterface

local deadZone = 0.5

function ListInterface.new(orientation)
	local interface = {}
	setmetatable(interface, ListInterface)
	interface.orientation = orientation or "vertical"
	interface.objects = {}
	interface.size = 0
	interface.index = 1
	interface.keyNext = false
	interface.keyPrevious = false
	interface.delay = Clock.new(0.2)
	return interface
end

function ListInterface:add(object)
	table.insert(self.objects, object)
	self.size = self.size + 1
	return object
end

function ListInterface:remove(objectToRemove)
	for i, object in pairs(self.objects) do
		if object == objectToRemove then
			table.remove(self.objects,i)
			self.size = self.size - 1
		end
	end
end

function ListInterface:mousemoved(x,y,dx,dy,istouch) 
	for i, object in pairs(self.objects) do
		if object:hover() then
			self.index = i
		end
	end
end

function ListInterface:mousepressed(x,y,button,istouch)
	self.objects[self.index]:mousepressed(x,y,button,istouch)
end

function ListInterface:mousereleased(x,y,button,istouch)
	self.objects[self.index]:mousereleased(x,y,button,istouch)
end

function ListInterface:keypressed(key,scancode,isrepeat)
	if self.orientation == "horizontal" then
		if scancode == "left" then
			self.keyPrevious = true
		end
		if scancode == "right" then
			self.keyNext = true
		end
	else
		if scancode == "up" then
			self.keyPrevious = true
		end
		if scancode == "down" then
			self.keyNext = true
		end
	end
	self.objects[self.index]:keypressed(key,scancode,isrepeat)
end

function ListInterface:keyreleased(key,scancode)
	if self.orientation == "horizontal" then
		if scancode == "left" then
			self.keyPrevious = false
		end
		if scancode == "right" then
			self.keyNext = false
		end
	else
		if scancode == "up" then
			self.keyPrevious = false
		end
		if scancode == "down" then
			self.keyNext = false
		end
	end
	self.objects[self.index]:keyreleased(key,scancode)
end

function ListInterface:gamepadpressed(joystick,button) 
	if self.orientation == "horizontal" then
		if button == "dpleft" then
			self.keyPrevious = true
		end
		if button == "dpright" then
			self.keyNext = true
		end
	else
		if button == "dpup" then
			self.keyPrevious = true
		end
		if button == "dpdown" then
			self.keyNext = true
		end
	end
	self.objects[self.index]:gamepadpressed(joystick,button) 
end

function ListInterface:gamepadreleased(joystick,button) 
	if self.orientation == "horizontal" then
		if button == "dpleft" then
			self.keyPrevious = false
		end
		if button == "dpright" then
			self.keyNext = false
		end
	else
		if button == "dpup" then
			self.keyPrevious = false
		end
		if button == "dpdown" then
			self.keyNext = false
		end
	end
	self.objects[self.index]:gamepadreleased(joystick,button) 
end

function ListInterface:gamepadaxis(joystick,axis,value) 

	if self.orientation == "vertical" and axis == "lefty" 
	or self.orientation == "horizontal" and axis == "leftx" then
		if value > deadZone then
			self.keyNext = true
			self.keyPrevious = false
		elseif value < -deadZone then
			self.keyNext = false
			self.keyPrevious = true
		else 
			self.keyNext = false
			self.keyPrevious = false
		end
	end

	self.objects[self.index]:gamepadaxis(joystick,axis,value)
end

function ListInterface:update(dt)
	if self.keyPrevious then
		if self.delay:zero() then
			if self.index > 1 then
				self.index = self.index - 1 
			else 	
				self.index = self.size
			end
			self.delay:tick()
		end
	elseif self.keyNext then
		if self.delay:zero() then
			if self.index < self.size then
				self.index = self.index + 1 
			else 	
				self.index = 1
			end
			self.delay:tick()
		end
	else 
		self.delay:reset()
	end

	if not self.delay:zero() then
		self.delay:tick()
		if self.delay:alarm() then
			self.delay:reset()
		end
	end

	for i, object in pairs(self.objects) do
		if i == self.index then
			object.active = true
		else 
			object.active = false
		end
		object:update(dt)
	end
end

function ListInterface:draw()
	for i, object in pairs(self.objects) do
		object:draw()
	end
end
