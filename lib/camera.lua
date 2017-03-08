Camera = {}
Camera.__index = Camera

function Camera.new()
	camera = {}
	setmetatable(camera, Camera)
  	camera.pos = Point.new(0,0)
	camera.scaleX = 1
	camera.scaleY = 1
	camera.rotation = 0
	return camera
end

function Camera:set()
	love.graphics.push()
	love.graphics.rotate(-self.rotation)
	love.graphics.scale(1/self.scaleX, 1/self.scaleY)
	love.graphics.translate(-self.pos.x, -self.pos.y)
end

function Camera:unset()
	love.graphics.pop()
end

function Camera:translate(x, y)
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
end

function Camera:move(dx, dy)
	self:translate(
		self.pos.x + (dx or 0),
		self.pos.y + (dy or 0)
	)
end

function Camera:setRotation(rotation)
	self.rotation = rotation
end

function Camera:rotate(rotation)
	self.rotation = self.rotation + rotation
end

function Camera:scale(scaleX, scaleY)
	self.scaleX = scaleX or self.scaleX
	self.scaleY = scaleY or self.scaleY
end

function Camera:zoom(scaleX, scaleY)
	scaleX = scaleX or 1
	self.scaleX = self.scaleX * scaleX
	self.scaleY = self.scaleY * (scaleX or scaleY)
end

