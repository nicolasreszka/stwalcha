Color = {}
Color.__index = Color

function Color.new(r,g,b,a)
	local color = {}
	setmetatable(color, Color)
	color.red = r
	color.green = g
	color.blue = b
	color.alpha = (a or 255)
	return color
end

function Color:clone()
	return Color.new(
		self.red, self.green, self.blue, self.alpha
	)
end

function Color:set()
	love.graphics.setColor(
		self.red, self.green, self.blue, self.alpha
	) 
end

function Color:compare(color)
	return (self.red == color.red 
		and self.green == color.green
		and self.blue == color.blue
		and self.alpha == color.alpha)
end

function Color:transform(shift, color)
	self.red = approachValues(self.red,color.red,shift)
	self.green = approachValues(self.green,color.green,shift)
	self.blue = approachValues(self.blue,color.blue,shift)
end

BLACK = Color.new(0,0,0)
WHITE = Color.new(255,255,255)
RED   = Color.new(255,0,0)
GREEN = Color.new(0,255,0)
BLUE  = Color.new(0,0,255)
CYAN  = Color.new(0,255,255)
MAGENTA = Color.new(255,0,255)
YELLOW  = Color.new(255,255,0)
