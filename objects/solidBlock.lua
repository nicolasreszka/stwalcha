--Author : Nicolas Reszka

SolidBlock = Object.new()
SolidBlock.__index = SolidBlock

function SolidBlock.new(x,y)
	local block = {}
	setmetatable(block, SolidBlock)
	block.type = "solid"
	block.rect = Rect.new(x,y,16,16)
	return block
end

function SolidBlock:draw()
	love.graphics.setColor(21,5,28)
	self.rect:draw("fill")
end