--Author : Nicolas Reszka

menu = State.new()
menu.saveClock = Clock.new(0.75)
menu.saveClock:forceAlarm()

local backgroundImage = love.graphics.newImage("backgrounds/menuBackground.png")

function menu:load()
	self.interface = ListInterface.new()
	local left = screen.w*1/6
	local top = 256
	local margin = 64+16
	self.interface:add(Button.new(
		"Play",
		Rect.new(left,top,256,64),
		function() 
			menu.saveClock:forceAlarm()
			uiSfx.yes:play()
			selectCharacters:load()
			selectCharacters:set()
		end
	))
	self.interface:add(Button.new(
		"Controls",
		Rect.new(left,top + margin,256,64),
		function() 
			uiSfx.yes:play()
			controls:load()
			controls:set()
		end
	))
	self.interface:add(Button.new(
		"Options",
		Rect.new(left,top + margin * 2,256,64),
		function() 
			uiSfx.yes:play()
			options:load()
			options:set()
		end
	))
	self.interface:add(Button.new(
		"Credits",
		Rect.new(left,top + margin * 3,256,64),
		function() 
			menu.saveClock:forceAlarm()
			uiSfx.yes:play()
			credits:load()
			credits:set()
		end
	))
	self.interface:add(Button.new(
		"Quit",
		Rect.new(left,top + margin * 4,256,64),
		function() 
			love.event.quit()
		end
	))
	self.title = AnimatedText.new(
		200,64,"Stwalcha",
		1,16,string.len("Stwalcha")*72
	)

	self.float = 0
	self.god = Point.new(screen.w*2/3,screen.h/2)
	self.eye = Point.new(self.god.x,self.god.y)
end

function menu:mousemoved(x,y,dx,dy,istouch) 
	self.interface:mousemoved(x,y,dx,dy,istouch)
end

function menu:mousepressed(x,y,button,istouch)
	self.interface:mousepressed(x,y,button,istouch)
end

function menu:mousereleased(x,y,button,istouch)
	self.interface:mousereleased(x,y,button,istouch)
end

function menu:keypressed(key,scancode,isrepeat)
	self.interface:keypressed(key,scancode,isreapeat)
end

function menu:keyreleased(key,scancode)
	self.interface:keyreleased(key,scancode)
end

function menu:gamepadpressed(joystick,button) 
	self.interface:gamepadpressed(joystick,button)
end

function menu:gamepadreleased(joystick,button) 
	self.interface:gamepadreleased(joystick,button)
end

function menu:gamepadaxis(joystick,axis,value) 
	self.interface:gamepadaxis(joystick,axis,value) 
end

function menu:update(dt)
	self.interface:update(dt)
	self.title:update(dt)

	if not self.saveClock:alarm() then
		self.saveClock:tick()
	end

	self.float = self.float + 3
	if self.float >= 360 then
		self.float = 0
	end
	self.god.y = self.god.y + math.cos(math.rad(self.float))
	local lookAngle = angle(self.god, mouse)
	self.eye.x = self.god.x + lengthDirectionX(8,lookAngle)
	self.eye.y = self.god.y + lengthDirectionY(8,lookAngle)
	
end

function menu:draw()
	WHITE:set()
	love.graphics.draw(
		backgroundImage,
		0,0
	)
	love.graphics.setColor(100, 187, 146)
	love.graphics.polygon(
		"fill",
		{
			self.god.x,self.god.y-64,
			self.god.x-64,self.god.y+64,
			self.god.x+64,self.god.y+64
		}
	)
	love.graphics.setLineWidth(2)
	BLACK:set()
	love.graphics.polygon(
		"line",
		{
			self.god.x,self.god.y-64,
			self.god.x-64,self.god.y+64,
			self.god.x+64,self.god.y+64
		}
	)
	love.graphics.setLineWidth(1)
	WHITE:set()
	love.graphics.circle("fill",self.god.x,self.god.y,16)
	BLUE:set()
	love.graphics.circle("line",self.god.x,self.god.y,16)
	YELLOW:set()
	love.graphics.circle("fill",self.eye.x,self.eye.y,8)
	BLUE:set()
	love.graphics.circle("line",self.eye.x,self.eye.y,8)
	BLACK:set()
	love.graphics.circle("fill",self.eye.x,self.eye.y,2)


	love.graphics.setFont(font128)
	self.title:draw()
	self.interface:draw()

	if not self.saveClock:alarm() then
		BLACK:set()
		love.graphics.printf(
			"Saving... ", 
			-2,
			720-2,
			screen.w, "right"
		)
		YELLOW:set()
		love.graphics.printf(
			"Saving... ", 
			0,
			720,
			screen.w, "right"
		)
	end
end
