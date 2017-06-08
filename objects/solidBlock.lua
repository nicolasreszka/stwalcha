--Author : Nicolas Reszka

SolidBlock = Object.new()
SolidBlock.__index = SolidBlock

local image = love.graphics.newImage("backgrounds/solidBlock.png")

function SolidBlock.new(x,y)
	local block = {}
	setmetatable(block, SolidBlock)
	block.type = "solid"
	block.rect = Rect.new(x,y,16,16)
	return block
end

function SolidBlock:draw()
	WHITE:set()
	love.graphics.draw(
		image,
		self.rect.left,self.rect.top
	)
end