dj = {}
dj.__index = dj

function dj:load()
	self.index = 1
	self.track = ""
	self.music = {}
	self.music["mountains"] = {
		love.audio.newSource("music/mountainsIntro.wav", "stream"),
		love.audio.newSource("music/mountains.wav", "stream")
	} 
	self.music["jungle"] = {
		love.audio.newSource("music/jungleIntro.wav", "stream"),
		love.audio.newSource("music/jungle.wav", "stream")
	} 
	self.music["lava"] = {
		love.audio.newSource("music/lavaIntro.wav", "stream"),
		love.audio.newSource("music/lava.wav", "stream")
	} 
	self.music["clouds"] = {
		love.audio.newSource("music/cloudsIntro.wav", "stream"),
		love.audio.newSource("music/clouds.wav", "stream")
	} 
	self.music["karma"] = {
		love.audio.newSource("music/karmaIntro.wav", "stream"),
		love.audio.newSource("music/karma.wav", "stream")
	} 
end

function dj:update()	
	if self.music[self.track][self.index]:isStopped() then
		if self.index == 1 then
			self.index = 2
			self.music[self.track][self.index]:setLooping(true)
			self:play()
		end
	end
end

function dj:setTrack(trackName)
	self.track = trackName
	self.index = 1
end

function dj:reset()
	self.music[self.track][1]:stop()
	self.music[self.track][2]:stop()
	self.music[self.track][self.index]:play()
end

function dj:play()
	self.music[self.track][self.index]:play()
end

function dj:pause()
	self.music[self.track][self.index]:pause()
end

function dj:isPlaying()
	return self.music[self.track][self.index]:isPlaying()
end

function dj:setVolume(volume)
	for i,tracks in pairs(self.music) do
		for i,track in pairs(tracks) do
			track:setVolume(volume)
		end
	end
end