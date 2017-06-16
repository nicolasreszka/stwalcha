Eye = {}
Eye.__index = Eye

local shake = 8
local image = love.graphics.newImage('sprites/Eye.png')

function Eye.new(x,y)
	local eye = {}
	setmetatable(eye, Eye)
	eye.rect = Rect.new(x,y,32,32)
	eye.taken = false
	eye.lightingTimer = Clock.new(0.5)
	eye.player = nil
	eye.lightingPoints = {nil,nil,nil,nil}
	eye.float = 0
	return eye
end

function Eye:update(dt)
	if self.taken then
		if self.lightingTimer:alarm() then
			for i=1,4 do
				if i ~= self.player.slot then
					game.chat[i] = true
				end
			end
			game.specialObjects:remove(self)
		else 
			self.lightingTimer:tick()
			camera:move(
				love.math.random(-shake,shake),
				love.math.random(-shake,shake)
			)
			for i,player in pairs(game.players.objects) do
				if player.slot ~= self.player.slot then
					self.lightingPoints[i] = game.god:createLighting(player)
				end
			end
		end
	else 
		self.float = self.float + 3
		if self.float >= 360 then
			self.float = 0
		end

		self.player = game.players:rectsVsRect(self.rect)
		if self.player then
			self.taken = true
			sfx.lighting:stop()
			sfx.lighting:playAt({x=0,y=0})
			for i,player in pairs(game.players.objects) do
				player.input:vibration(0.5)
			end
		end
	end
end

function Eye:draw()
	if self.taken then
		for i, lightingPoint in pairs(self.lightingPoints) do
			game.god:drawLighting(lightingPoint)
		end
	else
		WHITE:set()
		love.graphics.draw(
			image,
			self.rect.pos.x,
			self.rect.pos.y + 6*math.cos(math.rad(self.float))
		)
	end
end