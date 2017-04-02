KeyBinder = InterfaceComponent.new()
KeyBinder.__index = KeyBinder

function KeyBinder.new(label,key,rect,callback)
	local keyBinder = {}
	setmetatable(keyBinder, KeyBinder)
	keyBinder.label = label
	keyBinder.key = key
	keyBinder.rect = rect
	keyBinder.callback = callback
	keyBinder.active = false
	keyBinder.rebinding = false
	keyBinder.keyOK = false
	keyBinder.mouseOK = false
	keyBinder.keyLastkey = false
	return keyBinder
end

function KeyBinder:mousepressed(x,y,button,istouch)
	if button == 1 then
		self.mouseOK = true
		if self.rebinding and not self:hover() then
			self.rebinding = false
			gameState:mousemoved(mouse.x,mouse.y)
		end
	end
end

function KeyBinder:keypressed(key,scancode,isrepeat)
	if scancode == "return" then
		self.keyOK = true
	end

	if self.rebinding then
		self.key = key
		self.callback(key)
		self.rebinding = false
	end
end

function KeyBinder:gamepadpressed(joystick,button) 
	if button == "a" then
		self.keyOK = true
	end
end

function KeyBinder:hover() 
	return pointVsRect(mouse,self.rect)
end

function KeyBinder:update(dt) 
	if self.active then
		if self.keyOK 
		or self.mouseOK and self:hover() then
			self.rebinding = not self.rebinding
		end
	else
		self.rebinding = false
	end

	self.keyOK = false
	self.mouseOK = false
end

function KeyBinder:draw()
	if self.active then
		if self.rebinding then
			YELLOW:set()
		else
			RED:set()
		end
	else 
		GREEN:set()
	end

	self.rect:draw("line")
	love.graphics.print(self.key, self.rect.left+8, self.rect.top+8);
end