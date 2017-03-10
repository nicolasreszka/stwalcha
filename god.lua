God = {}
God.__index = God

local shake = 4

function God.new()
	local god = {}
	setmetatable(god, God)

	god.waitTimer = Clock.new(2)
	god.wait = true

	god.lightingTimer = Clock.new(0.5)
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
				self.player.input:vibration(0.5)
				sfx.lighting:playAt(self.player.pos)

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

				self.player.touched = true
				self.player.colorCurrent = 0
				self.player.color = chatColor:clone()
				self.player.sfx.tick:playAt(self.player.pos)
				
				chat = self.player.slot
				halfTime = false
			end
		end
	end
end

function God:draw()
	if self.lighting then 
		WHITE:set()
		local lastY = self.player.pos.y
		local lastX = self.player.pos.x+self.player.rect.w/2
		for y = lastY-love.math.random(32,64), -64, -love.math.random(32,64) do
			local x = lastX + love.math.random(-48,48)
			love.graphics.setLineWidth(love.graphics.getLineWidth()+1)
			love.graphics.line(lastX, lastY, x, y)
			lastX = x
			lastY = y
		end	
		love.graphics.setLineWidth(1)
	end
end