--Author : Nicolas Reszka

Explosion = Object.new()
Explosion.__index = Explosion

local maxRadius = 200
local explosionShake = 8
local aftermathShake = 4

function Explosion.new(x,y,radius)
	local explosion = {}
	setmetatable(explosion, Explosion)
	explosion.maxRadius = radius or maxRadius
	explosion.range = Circle.new(x,y,16)
	explosion.clock = Clock.new(1.5)
	explosion.speed = 0
	for i,player in pairs(game.players.objects) do
		inputs[player.slot]:vibration(3)
	end
	sfx.explosion:stop()
	sfx.explosion:playAt(explosion.range.pos)
	return explosion
end

function Explosion:update()
	self.clock:tick()
	self.speed = inOutExpo(6,32,self.clock)
	self.range.radius = self.range.radius + self.speed

	if self.range.radius < self.maxRadius then
		local list = game.players:rectsVsCircleList(self.range)
		for i, player in pairs(list) do
			if game.chat[player.slot] then
				player:explode()
			else
				game.players:remove(player)
			end
		end

		local list = game.blocks:rectsVsCircleList(self.range)
		for i, block in pairs(list) do
			if block.type == "block" then
				instantiateConfettis(
					block.rect.left+block.rect.w/2,
					block.rect.top+block.rect.h/2,
					1
				)
			elseif block.type == "cloud" then
				instantiateRain(
					block.rectBackup.left+block.rectBackup.w/2,
					block.rectBackup.top+block.rectBackup.h/2,
					1
				)
			end

			if block.type ~= "solid" then
				game.blocks:remove(block)
			end
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
		local thereIsChat = false
		for i,player in pairs(game.players.objects) do
			if isPlaying[player.slot] and game.chat[player.slot] then
				thereIsChat = true
			end
		end
		if not thereIsChat or game.players.size <= 1 then
			game.halfTime = true
		end
		game.explosions:remove(self)
	end
end

function Explosion:draw()
	love.graphics.setColor(255,255,255)
	if self.range.radius < self.maxRadius then
		self.range:draw("fill")
	else 
		self.range:draw("line")
	end
end