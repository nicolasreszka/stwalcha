--Author : Nicolas Reszka

SolidBlock = Object.new()
SolidBlock.__index = SolidBlock

local image = love.graphics.newImage("backgrounds/neon2Block.png")

function SolidBlock.new(x,y)
	local block = {}
	setmetatable(block, SolidBlock)
	block.type = "solid"
	block.rect = Rect.new(x,y,16,16)
	return block
end

function SolidBlock:draw()
	if mapName == "maps.neon2" then
		WHITE:set()
		love.graphics.draw(
			image,
			self.rect.left,self.rect.top
		)
	else
		love.graphics.setColor(21,5,28)
		self.rect:draw("fill")
	end
end