--Author : Nicolas Reszka

Screen = {}
Screen.__index = Screen

function Screen.new(w,h)
	screen = {}
	setmetatable(screen, Screen)
	screen.x, screen.y = 0, 0
	screen.w, screen.h = w, h
	screen.scale = 1
	screen.canvas = love.graphics.newCanvas(w,h)
	screen.canvas:setFilter("nearest")
	return screen
end

function Screen:resize(w,h)
	if h > w then
		self.scale =  w / self.w
		if self.h * self.scale > h then 
			self.scale = h / self.h
		end
	else
		self.scale =  h / self.h
		if self.w * self.scale > w then 
			self.scale =  w / self.w
		end
	end
	self.x = math.floor((w / 2) - (self.w * self.scale / 2))
    self.y = math.floor((h / 2) - (self.h * self.scale / 2))
end

function Screen:set()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()
	love.graphics.setBlendMode("alpha")
end

function Screen:unset()
	love.graphics.setCanvas()
end

function Screen:draw()
	love.graphics.setColor( 0, 0, 4 )
	love.graphics.rectangle("fill",self.x,self.y,self.w*self.scale,self.h*self.scale)
	WHITE:set()
	love.graphics.setBlendMode("alpha","premultiplied")
	love.graphics.draw(self.canvas, self.x, self.y, 0, self.scale)
end


