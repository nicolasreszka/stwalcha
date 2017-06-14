--Author : Nicolas Reszka

Block = Object.new()
Block.__index = Block


local image = love.graphics.newImage("backgrounds/neon2Block.png")
local image2 = love.graphics.newImage("backgrounds/neonBlock.png")

function Block.new(x,y)
	local block = {}
	setmetatable(block, Block)
	block.type = "block"
	block.rect = Rect.new(x,y,16,16)
	return block
end

function Block:draw()
	if mapName == "maps.neon2" then
		WHITE:set()
		love.graphics.draw(
			image,
			self.rect.left,self.rect.top
		)
	elseif mapName == "maps.getTheEye" then
		WHITE:set()
		love.graphics.draw(
			image2,
			self.rect.left,self.rect.top
		)
	elseif mapName == "maps.lava" then
		love.graphics.setColor(52,15,34)
		self.rect:draw("fill")
	else
		love.graphics.setColor(0,6,22)
		self.rect:draw("fill")
	end
end