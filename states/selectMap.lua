--Author : Nicolas Reszka

selectMap = State.new()

local backgroundImage = love.graphics.newImage("backgrounds/otherMenusBackground.png")

local mapScreens = {
	love.graphics.newImage('maps/neon.png'),
	love.graphics.newImage('maps/neon2.png'),
	love.graphics.newImage('maps/lava.png'),
	love.graphics.newImage('maps/clouds.png'),
	love.graphics.newImage('maps/getTheEye.png')
}

function selectMap:load()
	self.interface = ListInterface.new()
	local left = 64
	local top = 160
	local margin = 64+16
	self.interface:add(Button.new(
		"Mountains",
		Rect.new(left-64,top,256,64),
		function() 
			mapName = "maps.neon"
			dj:setTrack("mountains")
			game:load()
			game:set()
			dj:reset()
		end
	))
	self.interface:add(Button.new(
		"Jungle",
		Rect.new(left,top+margin,128,64),
		function() 
			mapName = "maps.neon2"
			dj:setTrack("jungle")
			game:load()
			game:set()
			dj:reset()
		end
	))
	self.interface:add(Button.new(
		"Lava",
		Rect.new(left,top+margin*2,128,64),
		function() 
			mapName = "maps.lava"
			dj:setTrack("lava")
			game:load()
			game:set()
			dj:reset()
		end
	))
	self.interface:add(Button.new(
		"Clouds",
		Rect.new(left,top+margin*3,128,64),
		function() 
			mapName = "maps.clouds"
			dj:setTrack("clouds")
			game:load()
			game:set()
			dj:reset()
		end
	))
	self.interface:add(Button.new(
		"Karma",
		Rect.new(left,top+margin*4,128,64),
		function() 
			mapName = "maps.getTheEye"
			dj:setTrack("karma")
			game:load()
			game:set()
			dj:reset()
		end
	))
	self.interface:add(Button.new(
		"<< Back",
		Rect.new(left,top+margin*5,128,64),
		function() 
			uiSfx.no:play()
			selectCharacters:reload()
			selectCharacters:set()
		end
	))
	self.title = AnimatedText.new(
		0,48,"Map selection",
		1.5,10,screen.w
	)
end

function selectMap:mousemoved(x,y,dx,dy,istouch) 
	self.interface:mousemoved(x,y,dx,dy,istouch)
end

function selectMap:mousepressed(x,y,button,istouch)
	self.interface:mousepressed(x,y,button,istouch)
end

function selectMap:keypressed(key,scancode,isrepeat)
	self.interface:keypressed(key,scancode,isreapeat)

	if scancode == "escape" then
		uiSfx.no:play()
		selectCharacters:reload()
		selectCharacters:set()
	end
end

function selectMap:keyreleased(key,scancode)
	self.interface:keyreleased(key,scancode)
end

function selectMap:gamepadpressed(joystick,button) 
	self.interface:gamepadpressed(joystick,button)

	if button == "b" then
		uiSfx.no:play()
		selectCharacters:reload()
		selectCharacters:set()
	end
end

function selectMap:gamepadreleased(joystick,button) 
	self.interface:gamepadreleased(joystick,button)
end

function selectMap:gamepadaxis(joystick,axis,value) 
	self.interface:gamepadaxis(joystick,axis,value) 
end

function selectMap:update(dt)
	self.interface:update(dt)
	self.title:update(dt)
end

function selectMap:draw()
	WHITE:set()
	love.graphics.draw(
		backgroundImage,
		0,0
	)

	if self.interface.index ~= self.interface.size then
		local screenX = 256
		local screenY = 160
		local screenScale = 0.6
		BLACK:set()
		love.graphics.rectangle(
			"line",
			screenX,screenY,
			screen.w*screenScale,
			screen.h*screenScale
		)
		WHITE:set()
		love.graphics.draw(
			mapScreens[self.interface.index], 
			screenX, screenY, 0, screenScale
		)
	end

	self.interface:draw()
	love.graphics.setFont(font72)
	self.title:draw()
end
