Bubble = {}
Bubble.__index = Bubble

function Bubble.new(x,y)
	local bubble = {}
	setmetatable(bubble, Bubble)
	bubble.circle = Circle.new(x,y,32)
	bubble.touched = false
	bubble.color = {255,255,255}
	return bubble
end

function Bubble:update()
	if not self.touched then
		local player = players:rectsVsCircle(self.circle)
		if player and not player.protected then
			self.touched = true
			self.color = player.color
			player.protected = true
			bubblesLeft = bubblesLeft - 1
		end
	end
end

function Bubble:draw()
	love.graphics.setColor(self.color)
	self.circle:draw("line")
end