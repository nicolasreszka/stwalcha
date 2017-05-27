--Author : Nicolas Reszka

Cloud = Object.new()
Cloud.__index = Cloud

local erosionDuration = 0.05

function Cloud.new(x,y)
	local block = {}
	setmetatable(block, Cloud)
	block.type = "cloud"
	block.rect = Rect.new(x,y,16,16)
	block.rectBackup = block.rect
	block.clouds = {}
	block.cloudsNumber = love.math.random(6,8)
	for i=0,block.cloudsNumber do
		local radius = love.math.random(8,16)
		block.clouds[i] = Circle.new(x+radius/2,y+radius/2,radius)
	end
	block.clock = Clock.new(erosionDuration)
	block.respawnClock = Clock.new(5)
	block.erosion = false
	return block
end

function Cloud:update(dt)
	if self.erosion then
		self.clock:tick()
		if self.clock:alarm() then
			self.clock:reset()
			if #self.clouds == 0 then
				self.rect = nil
			else
				self.clock:setDuration(
					self.clock:getDuration()*0.75
				)
				table.remove(self.clouds,1)
			end
		end
		if not game.players:rectsVsLine(self.rectBackup:bboxTop()) then
			self.erosion = false
		end
	elseif #self.clouds <= self.cloudsNumber then
		self.respawnClock:tick()
		if self.respawnClock:alarm() then
			local radius = love.math.random(12,16)
			table.insert(
				self.clouds, 
				Circle.new(
					self.rectBackup.pos.x+radius/2,
					self.rectBackup.pos.y+radius/2,
					radius
				)
			)
			if #self.clouds >= self.cloudsNumber 
			and not game.players:rectsVsRect(self.rectBackup)then
				self.respawnClock:reset()
				self.rect = self.rectBackup
				self.clock:setDuration(erosionDuration)
			end
		end
	end
end

function Cloud:draw()
	love.graphics.setColor(255, 155, 223, 128)
	if #self.clouds > 0 then
		for i,cloud in pairs(self.clouds) do
			cloud:draw("fill")
		end
	end
end