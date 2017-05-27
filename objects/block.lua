--Author : Nicolas Reszka

Block = Object.new()
Block.__index = Block

function Block.new(x,y)
	local block = {}
	setmetatable(block, Block)
	block.type = "block"
	block.rect = Rect.new(x,y,16,16)
	return block
end

function Block:draw()
	love.graphics.setColor(255, 0, 128)
	self.rect:draw("line")
end