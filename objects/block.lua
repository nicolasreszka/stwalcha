--Author : Nicolas Reszka

Block = Object.new()
Block.__index = Block

local image = love.graphics.newImage("backgrounds/neonBlock.png")
local image2 = love.graphics.newImage("backgrounds/neon2Block.png")
local image3 = love.graphics.newImage("backgrounds/lavaBlock.png")

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
			image2,
			self.rect.left,self.rect.top
		)
	elseif mapName == "maps.lava" then
		WHITE:set()
		love.graphics.draw(
			image3,
			self.rect.left,self.rect.top
		)
	else
		WHITE:set()
		love.graphics.draw(
			image,
			self.rect.left,self.rect.top
		)
	end
		
	
end