--Author : Nicolas Reszka

Bomb = Object.new()
Bomb.__index = Bomb


function Bomb.new(x,y)
	local bomb = {}
	setmetatable(bomb, Bomb)
	bomb.direction = love.math.random(0,360)
	bomb.circle = Circle.new(x,y,16)
	bomb.speed = 16
	bomb.clock = Clock.new(10)
	return bomb
end

function Bomb:update(dt)
	self.circle.pos.x = self.circle.pos.x + lengthDirectionX(self.speed,math.rad(self.direction))
	self.circle.pos.y = self.circle.pos.y + lengthDirectionY(self.speed,math.rad(self.direction))

	if self.circle.pos.x > mapWidth then
		self.circle.pos.x = -self.circle.radius/4
	elseif self.circle.pos.x < -self.circle.radius/2 then
		self.circle.pos.x = mapWidth-self.circle.radius/4
	end

	if self.circle.pos.y > mapHeight then
		self.circle.pos.y = -self.circle.radius/4
	elseif self.circle.pos.y < -self.circle.radius/2 then
		self.circle.pos.y = mapHeight-self.circle.radius/4
	end

	self.clock:tick()
	if game.players:rectsVsCircle(self.circle) 
	or game.blocks:rectsVsCircle(self.circle)
	or self.clock:alarm() then
		game.explosions:add(Explosion.new(self.circle.pos.x,self.circle.pos.y,92))
		game.bombs:remove(self)
	end
end

function Bomb:draw()
	WHITE:set()
	self.circle:draw("fill")
end