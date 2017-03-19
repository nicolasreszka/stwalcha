Block = {}
Block.__index = Block

function Block.new(x,y)
	local block = {}
	setmetatable(block, Block)
	block.rect = Rect.new(x,y,16,16)
	if worldCreationEffect then
		block.rect:translate(x,y-mapHeight)
		block.targetY = y
		block.delay = Clock.new(
			love.math.random()*2
		)
	end
	return block
end

function Block:update()
	self.delay:tick()
	self.rect:translate(
		self.rect.pos.x, 
		self.targetY-mapHeight+tween.inOutExpo(0,mapHeight,self.delay)
	)
	if worldCreationEffectTimer:alarm() then
		self.rect:translate(self.rect.pos.x,self.targetY)
	end
end

function Block:draw()
	love.graphics.setColor(255, 0, 128)
	self.rect:draw("line")
end