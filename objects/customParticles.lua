Weed = {}
Weed.__index = Weed

local weedImage =  love.graphics.newImage('sprites/Weed.png')

function Weed.new(x,y,color)
	local weed = {}
	setmetatable(weed, Weed)
	weed.x = x
	weed.y = y
	weed.color = color:clone()
	return weed
end

function Weed:update(dt)
	self.color.alpha = self.color.alpha - 5
	if self.color.alpha <= 0 then
		game.customParticles:remove(self)
	end
end

function Weed:draw()
	self.color:set()
	love.graphics.draw(
		weedImage,self.x,self.y
	)
end

Rainbow = {}
Rainbow.__index = Rainbow

local rainbowImage =  love.graphics.newImage('sprites/Rainbow.png')

function Rainbow.new(x,y,direction)
	local rainbow = {}
	setmetatable(rainbow, Rainbow)
	rainbow.x = x
	rainbow.y = y
	rainbow.color = WHITE:clone()
	rainbow.direction = direction
	return rainbow
end

function Rainbow:update(dt)
	self.color.alpha = self.color.alpha - 5
	if self.color.alpha <= 0 then
		game.customParticles:remove(self)
	end
end

function Rainbow:draw()
	self.color:set()
	love.graphics.draw(
		rainbowImage,self.x,self.y,self.direction,1,1,16,16
	)
end