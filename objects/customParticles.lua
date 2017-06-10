Weed = {}
Weed.__index = Weed

local weedImage =  love.graphics.newImage('sprites/Weed.png')

function Weed.new(x,y,color)
	local weed = {}
	setmetatable(weed, Weed)
	weed.x = x
	weed.y = y
	weed.color = color:clone()
	weed.type = "weed"
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

-- Rainbow = {}
-- Rainbow.__index = Rainbow

-- local rainbowImage =  love.graphics.newImage('sprites/Rainbow.png')

-- function Rainbow.new(x,y,direction)
-- 	local rainbow = {}
-- 	setmetatable(rainbow, Rainbow)
-- 	rainbow.x = x
-- 	rainbow.y = y
-- 	rainbow.color = WHITE:clone()
-- 	rainbow.direction = direction
-- 	rainbow.type = "rainbow"
-- 	return rainbow
-- end

-- function Rainbow:update(dt)
-- 	self.color.alpha = self.color.alpha - 5
-- 	if self.color.alpha <= 0 then
-- 		game.customParticles:remove(self)
-- 	end
-- end

-- function Rainbow:draw()
-- 	self.color:set()
-- 	love.graphics.draw(
-- 		rainbowImage,self.x,self.y,self.direction,1,1,16,16
-- 	)
-- end

LavaDrop = {}
LavaDrop.__index = LavaDrop

local dropGravity = 0.4

function LavaDrop.new(x,y)
	local lavaDrop = {}
	setmetatable(lavaDrop, LavaDrop)
	lavaDrop.circle = Circle.new(
		x,y,love.math.random(3,5)
	)
	lavaDrop.direction = love.math.random(0,1)
	if lavaDrop.direction == 0 then
		lavaDrop.direction = -1
	end
	lavaDrop.vx = love.math.random(2,3)*lavaDrop.direction
	lavaDrop.vy = -love.math.random(10,12)
	lavaDrop.type = "drop"
	return lavaDrop
end

function LavaDrop:update(dt)
	self.vy = self.vy + dropGravity
	self.circle.pos.y = self.circle.pos.y + self.vy
	if self.vy > -8 then
		self.vx = approachValues(self.vx,0,0.075)
		self.circle.pos.x = self.circle.pos.x + self.vx
	end
	
end

function LavaDrop:draw()
	game.lava.color:set()
	self.circle:draw("fill")
end