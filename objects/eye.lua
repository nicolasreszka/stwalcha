Eye = {}
Eye.__index = Eye

local image = love.graphics.newImage('sprites/Diplome.png')

function Eye.new(x,y)
	local eye = {}
	setmetatable(eye, Eye)
	eye.rect = Rect.new(x,y,32,32)
	return eye
end

function Eye:update(dt)
	local player = game.players:rectsVsRect(self.rect)
	if player then
		for i=1,4 do
			if i ~= player.slot then
				game.chat[i] = true
			end
		end
		game.specialObjects:remove(self)
	end
end

function Eye:draw()
	WHITE:set()
	love.graphics.draw(
		image,
		self.rect.pos.x,
		self.rect.pos.y
	)
end
