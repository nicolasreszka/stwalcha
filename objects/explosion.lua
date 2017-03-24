Explosion = Object.new()
Explosion.__index = Explosion

local maxRadius = 200
local explosionShake = 4
local aftermathShake = 2

function Explosion.new(x,y)
	local explosion = {}
	setmetatable(explosion, Explosion)
	explosion.range = Circle.new(x,y,16)
	explosion.clock = Clock.new(1.5)
	explosion.speed = 0
	for i,player in pairs(game.players.objects) do
		inputs[player.slot]:vibration(3)
	end
	sfx.explosion:playAt(explosion.range.pos)
	return explosion
end

function Explosion:update()
	self.clock:tick()
	self.speed = inOutExpo(6,32,self.clock)
	self.range.radius = self.range.radius + self.speed

	if self.range.radius < maxRadius then
		local list = game.players:rectsVsCircleList(self.range)
		for i, player in pairs(list) do
			game.players:remove(player)
		end

		local list = game.blocks:rectsVsCircleList(self.range)
		for i, block in pairs(list) do
			instantiateConfettis(
				block.rect.left+block.rect.w/2,
				block.rect.top+block.rect.h/2,
				1
			)
			game.blocks:remove(block)
		end

		camera:move(
			love.math.random(-explosionShake,explosionShake),
			love.math.random(-explosionShake,explosionShake)
		)
	else
		camera:move(
			love.math.random(-aftermathShake,aftermathShake),
			love.math.random(-aftermathShake,aftermathShake)
		)
	end

	if self.clock:alarm() then
		game.halfTime = true
		game.explosions:remove(self)
	end
end

function Explosion:draw()
	love.graphics.setColor(255,255,255)
	if self.range.radius < maxRadius then
		self.range:draw("fill")
	else 
		self.range:draw("line")
	end
end