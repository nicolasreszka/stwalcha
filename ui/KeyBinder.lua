--Author : Nicolas Reszka

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
			uiSfx.no:stop()
			uiSfx.no:play()
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
		uiSfx.yes:stop()
		uiSfx.yes:play()
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
			uiSfx.yes:stop()
			uiSfx.yes:play()
			self.rebinding = not self.rebinding
		end
	else
		self.rebinding = false
	end

	self.keyOK = false
	self.mouseOK = false
end

function KeyBinder:draw(playerColor)
	BLACK:set()
	love.graphics.rectangle(
		"line",
		self.rect.left-2,
		self.rect.top-2,
		self.rect.w,
		self.rect.h
	)
	love.graphics.setColor(0,0,0,128)
	self.rect:draw("fill")
	BLACK:set()
	love.graphics.setFont(font32)
	love.graphics.printf(
		self.key,
		self.rect.left-2, 
		self.rect.top+12-2,
		self.rect.w, "center"
	)

	if self.active then
		if self.rebinding then
			CYAN:set()
		else
			chatColor:set()
		end
	else 
		playerColor:set()
	end

	self.rect:draw("line")
	love.graphics.setFont(font32)
	love.graphics.printf(
		self.key,
		self.rect.left, 
		self.rect.top+12,
		self.rect.w, "center"
	)
end