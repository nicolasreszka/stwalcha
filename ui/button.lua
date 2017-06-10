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
	button.animatedText = AnimatedText.new(
		rect.left, 
		rect.top+12,
		label,0.75,10,rect.w
	)
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
		self.animatedText:update(dt)
	end
	self.keyOK = false
	self.mouseOK = false
end

function Button:draw(mode)
	love.graphics.setFont(font32)
	if self.active then
		self.animatedText:draw()
	else 
		BLACK:set()
		love.graphics.printf(
			self.label, 
			self.rect.left-2, 
			self.rect.top+12-2,
			self.rect.w, "center"
		);
		YELLOW:set()
		love.graphics.printf(
			self.label, 
			self.rect.left, 
			self.rect.top+12,
			self.rect.w, "center"
		);
	end

	
end