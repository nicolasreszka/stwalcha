Sound = {}
Sound.__index = Sound

function Sound.new(source)
	local sound = {}
	setmetatable(sound, Sound)
	sound.source = source:clone()
	sound.source:setRelative(true)
	return sound
end

function Sound:setPosition(position)
	local w = mapWidth/2
	local h = mapHeight/2
	local x = (position.x-w)/w
	local y = (position.y-h)/h
	self.source:setPosition(x,y,0)
end

function Sound:playAt(position)
	self:setPosition(position)
	self.source:play()
end

function Sound:isPlaying()
	return self.source:isPlaying()
end

function Sound:stop()
	self.source:stop()
end

function Sound:pause()
	self.source:pause()
end