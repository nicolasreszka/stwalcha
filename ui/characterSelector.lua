CharacterSelector = {}
CharacterSelector.__index = CharacterSelector

function CharacterSelector.new(slot)
	selector = {}
	setmetatable(selector, CharacterSelector)
	selector.state = "inactive"
	selector.slot = slot
	selector.w, selector.h = screen.w/2, screen.h/2
	if slot == 1 then
		selector.x, selector.y = 0, 0
	elseif slot == 2 then
		selector.x, selector.y = selector.w, 0
	elseif slot == 3 then
		selector.x, selector.y = 0, selector.h
	elseif slot == 4 then 
		selector.x, selector.y = selector.w, selector.h
	end

	return selector
end

function CharacterSelector:setState(state)
	self.state = state
end

function CharacterSelector:getState()
	return self.state
end

function CharacterSelector:update(dt)
	if self.state == "inactive" then
		if inputs[self.slot].jumpPressed then
			self.state = "joined"
		end
	elseif self.state == "joined" then
		if inputs[self.slot].jumpPressed then
			self.state = "ready"
		end
		if inputs[self.slot].backPressed then
			self.state = "inactive"
		end
	elseif self.state == "ready" then
		if inputs[self.slot].backPressed then
			self.state = "joined"
		end
	end
end

function CharacterSelector:draw()
	colors[self.slot]:set()
	local lineWidth = 2
	love.graphics.setLineWidth(lineWidth)
	love.graphics.rectangle(
		"line", 
		self.x+lineWidth+1, 
		self.y+lineWidth+1, 
		self.w-lineWidth-3, 
		self.h-lineWidth-3
	)
	love.graphics.setLineWidth(1)
	love.graphics.print(
		self.state,
		self.x+self.w/2,
		self.y+self.h/2
	)
end