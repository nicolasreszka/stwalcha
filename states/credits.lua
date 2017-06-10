credits = State.new()

local backgroundImage = love.graphics.newImage("backgrounds/otherMenusBackground.png")

function credits:load()
	self.title = AnimatedText.new(
		0,64,"Created By Nicolas Reszka",
		1.5,8,screen.w
	)

	self.title2 = AnimatedText.new(
		0,256,"Powered by Löve",
		1.5,10,screen.w
	)

	self.title3 = AnimatedText.new(
		0,620,"Press any key to leave this screen",
		0.75,8,screen.w
	)
end

function credits:mousepressed(x,y,button,istouch)
	if button then 
		uiSfx.no:stop()
		uiSfx.no:play()
		menu:load()
		menu:set()
	end
end

function credits:keypressed(key,scancode,isrepeat)
	if key then 
		uiSfx.no:stop()
		uiSfx.no:play()
		menu:load()
		menu:set()
	end
end

function credits:gamepadpressed(joystick,button) 
	if button then 
		uiSfx.no:stop()
		uiSfx.no:play()
		menu:load()
		menu:set()
	end
end

function credits:update(dt)
	self.title:update(dt)
	self.title2:update(dt)
	self.title3:update(dt)
end

function credits:draw()
	WHITE:set()
	love.graphics.draw(
		backgroundImage,
		0,0
	)

	love.graphics.setFont(font72)
	self.title:draw()
	self.title2:draw()
	love.graphics.setFont(font32)
	self.title3:draw()
end