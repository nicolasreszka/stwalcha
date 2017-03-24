Object = {}
Object.__index = Object

function Object.new()
	local object = {}
	setmetatable(object, Object)
	return object
end

function Object:update(dt) end

function Object:draw() end
