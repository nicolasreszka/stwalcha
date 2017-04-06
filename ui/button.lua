--Author : Nicolas Reszka

Button = InterfaceComponent.new()
Button.__index = Button

function Button.new(label,rect,callback)
	local button = {}
	setmetatable(button, Button)
	button.label = label
	button.rect = rect
	button.callback = callback
	button.active = false
	button.keyOK = false
	button.mouseOK = false
	return button
end

function Button:mousepressed(x,y,button,istouch)
	if button == 1 then
		self.mouseOK = true
	end
end

function Button:keypressed(key,scancode,isrepeat)
	if scancode == "return" then
		self.keyOK = true
	end
end

function Button:gamepadpressed(joystick,button) 
	if button == "a" then
		self.keyOK = true
	end
end

function Button:hover() 
	return pointVsRect(mouse,self.rect)
end

function Button:update(dt) 
	if self.active then
		if self.keyOK 
		or self.mouseOK and self:hover() then
			self.callback()
		end
	end
	self.keyOK = false
	self.mouseOK = false
end

function Button:draw()
	if self.active then
		RED:set()
	else 
		GREEN:set()
	end

	self.rect:draw("line")
	love.graphics.setFont(font32)
	love.graphics.print(self.label, self.rect.left+8, self.rect.top+8);
end