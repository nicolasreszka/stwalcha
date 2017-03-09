God = {}
God.__index = God

local shake = 4

function God.new()
	local god = {}
	setmetatable(god, God)

	god.waitTimer = Clock.new(1)
	god.wait = true

	god.lightingTimer = Clock.new(0.2)
	god.lighting = false

	return god
end

function God:update()
	if players.size > 1 then

		if self.wait then
			self.waitTimer:tick()
			if self.waitTimer:alarm() then

				self.choice = love.math.random(1,players.size)
				self.player = players.objects[self.choice]
				
				self.wait = false
				self.lighting = true
			end
		end

		if self.lighting then
			camera:move(
				love.math.random(-shake,shake),
				love.math.random(-shake,shake)
			)

			self.lightingTimer:tick()
			if self.lightingTimer:alarm() then

				self.waitTimer:reset()
				self.lightingTimer:reset()

				self.wait = true
				self.lighting = false

				chat = self.player.slot
				halfTime = false
			end
		end
	end
end

function God:draw()
	if self.lighting then 
		WHITE:set()
		love.graphics.line(self.player.pos.x+self.player.rect.w/2, 0, self.player.pos.x+self.player.rect.w/2, self.player.pos.y)
	end
end