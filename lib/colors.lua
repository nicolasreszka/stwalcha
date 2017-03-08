Color = {}
Color.__index = Color

function Color.new(r,g,b,a)
	local color = {}
	setmetatable(color, Color)
	color.red = r
	color.green = g
	color.blue = b
	color.alpha = a
	return color
end

function Color:set()
	love.graphics.setColor(
		self.red, self.green, self.blue, self.alpha
	)
end

function Color:compare(color)
	if self.red == color.red 
	and self.green == color.green
	and self.blue == color.blue
	and self.alpha == color.alpha then
		return true
	else 
		return false
	end
end