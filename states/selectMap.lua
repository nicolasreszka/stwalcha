--Author : Nicolas Reszka

selectMap = State.new()

local mapScreens = {
	love.graphics.newImage('maps/neon.png')
}

function selectMap:load()
	self.interface = ListInterface.new()
	self.interface:add(Button.new(
		"Neon",
		Rect.new(64,256,128,64),
		function() 
			mapName = "maps.neon"
			game:set()
			gameState:load()
		end
	))
	self.interface:add(Button.new(
		"Back",
		Rect.new(64,448,128,64),
		function() 
			selectCharacters:set()
			for i, selector in pairs(selectCharacters.selectors) do
				if selector:getState() == "ready" then
					selector:setState("joined")
				end 
			end
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
		selectMode:set()
		gameState:load()
	end
end

function selectMap:keyreleased(key,scancode)
	self.interface:keyreleased(key,scancode)
end

function selectMap:gamepadpressed(joystick,button) 
	self.interface:gamepadpressed(inputs[1].joystick,button)

	if joystick == inputs[1].joystick and button == "b" then
		selectMode:set()
		gameState:load()
	end
end

function selectMap:gamepadreleased(joystick,button) 
	self.interface:gamepadreleased(inputs[1].joystick,button)
end

function selectMap:gamepadaxis(joystick,axis,value) 
	self.interface:gamepadaxis(inputs[1].joystick,axis,value) 
end

function selectMap:update(dt)
	self.interface:update(dt)
	self.title:update(dt)
end

function selectMap:draw()
	if self.interface.index ~= self.interface.size then
		local screenX = 256
		local screenY = 160
		local screenScale = 0.6
		GREEN:set()
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
