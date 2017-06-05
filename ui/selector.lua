Selector = InterfaceComponent.new()
Selector.__index = Selector

local deadZone = 0.5

function Selector.new(rect,values,index,callback)
	local selector = {}
	setmetatable(selector, Selector)
	selector.keyLeft = false
	selector.keyRight = false
	selector.active = false
	selector.values = values
	selector.callback = callback
	selector.index = index
	selector.rect = rect
	selector.left = Rect.new(rect.left,rect.top,64,64)
	selector.right = Rect.new(rect.right-64,rect.top,64,64)
	selector.delay = Clock.new(0.15)
	return selector
end

function Selector:keypressed(key,scancode,isrepeat)
	if scancode == "left" then
		self.keyLeft = true
	end
	if scancode == "right" then
		self.keyRight = true
	end
end

function Selector:keyreleased(key,scancode)
	if scancode == "left" then
		self.keyLeft = false
	end
	if scancode == "right" then
		self.keyRight = false
	end
end

function Selector:gamepadpressed(joystick,button) 
	if button == "dpleft" then
		self.keyLeft = true
	end
	if button == "dpright" then
		self.keyRight = true
	end
end

function Selector:gamepadreleased(joystick,button) 
	if button == "dpleft" then
		self.keyLeft = false
	end
	if button == "dpright" then
		self.keyRight = false
	end
end

function Selector:gamepadaxis(joystick,axis,value)
	if axis == "leftx" then
		if value > deadZone then
			self.keyRight = false
			self.keyLeft = true
		elseif value < -deadZone then
			self.keyRight = true
			self.keyLeft = false
		else 
			self.keyRight = false
			self.keyLeft = false
		end
	end
end

function Selector:hover() 
	return pointVsRect(mouse,self.rect)
end

function Selector:update(dt)
	self.leftHover = pointVsRect(mouse,self.left)
	self.rightHover = pointVsRect(mouse,self.right)

	if self.active then
		if self.keyLeft or self.leftHover and mouse.leftPressed then
			if self.delay:zero() then
				if self.index > 1 then
					self.index = self.index - 1 
				else 	
					self.index = #self.values
				end
				self.callback(self.values[self.index])
				self.delay:tick()
				uiSfx.minus:stop()
				uiSfx.minus:play()
			end
		elseif self.keyRight or self.rightHover and mouse.leftPressed then
			if self.delay:zero() then
				if self.index < #self.values then
					self.index = self.index + 1 
				else 	
					self.index = 1
				end
				self.callback(self.values[self.index])
				self.delay:tick()
				uiSfx.plus:stop()
				uiSfx.plus:play()
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
end

function Selector:draw()
	love.graphics.setFont(font32)
	if self.rightHover then
		RED:set()
	else
		GREEN:set()
	end
	self.right:draw("line")
	love.graphics.printf(
		">",
		self.right.left,
		self.right.top,
		self.right.w,
		"center"
	)

	if self.leftHover then
		RED:set()
	else
		GREEN:set()
	end
	self.left:draw("line")
	love.graphics.printf(
		"<",
		self.left.left,
		self.left.top,
		self.left.w,
		"center"
	)

	if self.active then
		RED:set()
	else
		GREEN:set()
	end
	love.graphics.printf(
		self.values[self.index],
		self.rect.left,
		self.rect.top,
		self.rect.w,
		"center"
	)
end