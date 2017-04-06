--Author : Nicolas Reszka

GridInterface = {}
GridInterface.__index = GridInterface

local deadZone = 0.5

function GridInterface.new(width,height)
	local interface = {}
	setmetatable(interface, GridInterface)
	interface.objects = {}
	for i=1,width do
		table.insert(interface.objects,{})
	end
	interface.width = width
	interface.height = height
	interface.index = Point.new(1,1)
	interface.keyLeft = false
	interface.keyRight = false
	interface.keyUp = false
	interface.keyDown = false
	interface.delay = Clock.new(0.2)
	return interface
end

function GridInterface:add(x,object)
	table.insert(self.objects[x], object)
	return object
end

function GridInterface:mousemoved(x,y,dx,dy,istouch) 
	for x=1,self.width do
		for y,object in pairs(self.objects[x]) do 
			if object:hover() then
				self.index.x = x
				self.index.y = y
			end
		end
	end
end

function GridInterface:mousepressed(x,y,button,istouch)
	self.objects[self.index.x][self.index.y]:mousepressed(x,y,button,istouch)
end

function GridInterface:keypressed(key,scancode,isrepeat)
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
	self.objects[self.index.x][self.index.y]:keypressed(key,scancode,isrepeat)
end

function GridInterface:keyreleased(key,scancode)
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

function GridInterface:gamepadpressed(joystick,button) 
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
	self.objects[self.index.x][self.index.y]:gamepadpressed(joystick,button) 
end

function GridInterface:gamepadreleased(joystick,button) 
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

function GridInterface:gamepadaxis(joystick,axis,value) 

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

function GridInterface:update(dt)
	if self.keyUp then
		if self.delay:zero() then
			if self.index.y > 1 then
				self.index.y = self.index.y - 1 
			else 	
				self.index.y = self.height
			end
			self.delay:tick()
		end
	elseif self.keyDown then
		if self.delay:zero() then
			if self.index.y < self.height then
				self.index.y = self.index.y + 1 
			else 	
				self.index.y = 1
			end
			self.delay:tick()
		end
	elseif self.keyLeft then
		if self.delay:zero() then
			if self.index.x > 1 then
				self.index.x = self.index.x - 1 
			else 	
				self.index.x = self.width
			end
			self.delay:tick()
		end
	elseif self.keyRight then
		if self.delay:zero() then
			if self.index.x < self.width then
				self.index.x = self.index.x + 1 
			else 	
				self.index.x = 1
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

	for x=1,self.width do
		for y,object in pairs(self.objects[x]) do 
			if x == self.index.x and y == self.index.y then
				object.active = true
			elseif self.objects[self.index.x][self.index.y] ~= object then
				object.active = false
			end
			object:update(dt)
		end
	end
end

function GridInterface:draw()
	for x=1,self.width do
		for y,object in pairs(self.objects[x]) do 
			object:draw()
		end
	end
end
