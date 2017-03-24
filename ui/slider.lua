Slider = InterfaceComponent.new()
Slider.__index = Slider

local deadZone = 0.5
local trackThickness = 16
local step = 0.1

function Slider.new(label,rect,value,callback,interfaceOrientation)
	local slider = {}
	setmetatable(slider, Slider)
	slider.label = label
	slider.rect = rect
	slider.value = value
	slider.callback = callback
	slider.interfaceOrientation = interfaceOrientation or "vertical"

	if interfaceOrientation == "horizontal" then
		slider.track = Rect.new(
			rect.pos.x+rect.w/2-16,
			rect.pos.y+rect.h/2-16,
			trackThickness, rect.h/2 
		)
	else 
		slider.track = Rect.new(
			rect.pos.x+rect.w/2-16,
			rect.pos.y+rect.h/2-16,
			rect.w/2, trackThickness 
		)
	end
	slider.knob = Rect.new(
		slider.track.pos.x,
		slider.track.pos.y,
		trackThickness, 
		trackThickness
	)
	slider:moveKnob()

	slider.active = false
	slider.grabbed = false

	slider.keyMinus = false
	slider.keyPlus = false

	slider.delay = Clock.new(0.15)
	slider.previousValue = value

	return slider
end

function Slider:mousepressed(x,y,button,istouch)
	if button == 1 then
		if pointVsRect(mouse,self.track) then
			self.grabbed = true
		end
	end
end

function Slider:mousereleased(x,y,button,istouch)
	if button == 1 then
		self.grabbed = false
	end
end

function Slider:keypressed(key,scancode,isrepeat)
	if self.interfaceOrientation == "horizontal" then
		if scancode == "up" then
			self.keyMinus = true
		end
		if scancode == "down" then
			self.keyPlus = true
		end
	else 
		if scancode == "left" then
			self.keyMinus = true
		end
		if scancode == "right" then
			self.keyPlus = true
		end
	end
end

function Slider:keyreleased(key,scancode)
	if self.interfaceOrientation == "horizontal" then
		if scancode == "up" then
			self.keyMinus = false
		end
		if scancode == "down" then
			self.keyPlus = false
		end
	else 
		if scancode == "left" then
			self.keyMinus = false
		end
		if scancode == "right" then
			self.keyPlus = false
		end
	end
end


function Slider:gamepadpressed(joystick,button) 
	if self.interfaceOrientation == "horizontal" then
		if button == "dpup" then
			self.keyMinus = true
		end
		if button == "dpdown" then
			self.keyPlus = true
		end
	else
		if button == "dpleft" then
			self.keyMinus = true
		end
		if button == "dpright" then
			self.keyPlus = true
		end
	end
end

function Slider:gamepadreleased(joystick,button) 
	if self.interfaceOrientation == "horizontal" then
		if button == "dpup" then
			self.keyMinus = false
		end
		if button == "dpdown" then
			self.keyPlus = false
		end
	else
		if button == "dpleft" then
			self.keyMinus = false
		end
		if button == "dpright" then
			self.keyPlus = false
		end
	end
end

function Slider:gamepadaxis(joystick,axis,value)
	if self.interfaceOrientation == "vertical" and axis == "leftx" 
	or self.interfaceOrientation == "horizontal" and axis == "lefty" then
		if value > deadZone then
			self.keyMinus = false
			self.keyPlus = true
		elseif value < -deadZone then
			self.keyMinus = true
			self.keyPlus = false
		else 
			self.keyMinus = false
			self.keyPlus = false
		end
	end
end

function Slider:hover() 
	return pointVsRect(mouse,self.rect)
end

function Slider:moveKnob()
	if self.interfaceOrientation == "horizontal" then
		self.knob:setY(
			self.track.top+self.value*(self.track.h-self.knob.h)
		)
	else
		self.knob:setX(
			self.track.left+self.value*(self.track.w-self.knob.w)
		)
	end
end

function Slider:update(dt) 
	if self.active then

		if self.keyMinus then
			if self.delay:zero() then
				self.value = approachValues(self.value,0,step)
				self:moveKnob()
				self.delay:tick()
			end
		elseif self.keyPlus then
			if self.delay:zero() then
				self.value = approachValues(self.value,1,step)
				self:moveKnob()
				self.delay:tick()
			end
		else 
			self.delay:reset()
		end

		if self.grabbed then
			if self.interfaceOrientation == "horizontal" then
				self.knob:setY(clamp(
						mouse.y,
						self.track.top,
						self.track.bottom-self.knob.h
				))
				self.value = round(
					(self.knob.top-self.track.top)/(self.track.h-self.knob.h),2
				)
			else 
				self.knob:setX(clamp(
						mouse.x,
						self.track.left,
						self.track.right-self.knob.w
				))
				self.value = round(
					(self.knob.left-self.track.left)/(self.track.w-self.knob.w),2
				)
			end
		end
			
		if self.previousValue ~= self.value then
			self.callback(self.value)
		end
		
		self.previousValue = self.value

	else 
		self.grabbed = false
		self.keyMinus = false
		self.keyPlus = false
	end

	if not self.delay:zero() then
		self.delay:tick()
		if self.delay:alarm() then
			self.delay:reset()
		end
	end
end

function Slider:draw()
	if self.active then
		RED:set()
	else 
		GREEN:set()
	end
	self.rect:draw("line")
	self.track:draw("line")
	self.knob:draw("fill")

	love.graphics.print(self.label, self.rect.left+8, self.rect.top+8)
	love.graphics.print(math.floor(self.value*100), self.track.left-32, self.track.top)
end