--Author : Nicolas Reszka

Block = Object.new()
Block.__index = Block

local image = love.graphics.newImage("backgrounds/neonBlock.png")

function Block.new(x,y)
	local block = {}
	setmetatable(block, Block)
	block.type = "block"
	block.rect = Rect.new(x,y,16,16)
	return block
end

function Block:draw()
	if mapName == "maps.neon2" then
		love.graphics.setColor(233, 255,0)
	else
		love.graphics.setColor(255, 0, 128)
	end
		
	WHITE:set()
	love.graphics.draw(
		image,
		self.rect.left,self.rect.top
	)
end