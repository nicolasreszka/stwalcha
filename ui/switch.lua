--Author : Nicolas Reszka

Switch = InterfaceComponent.new()
Switch.__index = Switch

local deadZone = 0.5

function Switch.new(label,rect,value,callback,interfaceOrientation)
	local switch = {}
	setmetatable(switch, Switch)
	switch.label = label
	switch.rect = rect
	switch.callback = callback
	switch.on = value
	switch.interfaceOrientation = interfaceOrientation or "vertical"
	switch.active = false
	switch.keyON = false
	switch.keyOFF = false
	switch.keyOK = false
	switch.mouseOK = false
	return switch
end

function Switch:mousepressed(x,y,button,istouch)
	if button == 1 then
		self.mouseOK = true
	end
end

function Switch:keypressed(key,scancode,isrepeat)
	if scancode == "return" then
		self.keyOK = true
	end

	if self.interfaceOrientation == "horizontal" then
		if scancode == "up" then
			self.keyON = true
		end
		if scancode == "down" then
			self.keyOFF = true
		end
	else 
		if scancode == "left" then
			self.keyON = true
		end
		if scancode == "right" then
			self.keyOFF = true
		end
	end
end

function Switch:gamepadpressed(joystick,button) 
	if button == "a" then
		self.keyOK = true
	end

	if self.interfaceOrientation == "horizontal" then
		if button == "dpup" then
			self.keyON = true
		end
		if button == "dpdown" then
			self.keyOFF = true
		end
	else
		if button == "dpleft" then
			self.keyON = true
		end
		if button == "dpright" then
			self.keyOFF = true
		end
	end
end

function Switch:gamepadaxis(joystick,axis,value)
	if self.interfaceOrientation == "vertical" and axis == "leftx" 
	or self.interfaceOrientation == "horizontal" and axis == "lefty" then
		if value > deadZone then
			self.keyON = false
			self.keyOFF = true
		elseif value < -deadZone then
			self.keyON = true
			self.keyOFF = false
		else 
			self.keyON = false
			self.keyOFF = false
		end
	end
end

function Switch:hover() 
	return pointVsRect(mouse,self.rect)
end

function Switch:update(dt) 
	if self.active then
		if self.keyOK 
		or self.mouseOK and self:hover()
		or self.on and self.keyOFF 
		or not self.on and self.keyON  then
			self.on = not self.on
			self.callback(self.on)
		end
	end
	self.keyON = false
	self.keyOFF = false
	self.keyOK = false
	self.mouseOK = false
end

function Switch:draw()
	if self.active then
		RED:set()
	else 
		GREEN:set()
	end
	self.rect:draw("line")

	love.graphics.setFont(font32)
	love.graphics.print(self.label, self.rect.left+8, self.rect.top+8)

	if self.on then
		love.graphics.print("on", self.rect.right-64, self.rect.top+8);
	else
		love.graphics.print("off", self.rect.right-64, self.rect.top+8);
	
	end

end