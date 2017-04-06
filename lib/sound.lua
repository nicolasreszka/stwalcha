--Author : Nicolas Reszka

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
	local x = (position.x-audioListener.x)/audioListener.x
	local y = (position.y-audioListener.y)/audioListener.y
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