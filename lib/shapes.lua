Point = {}
Point.__index = Point

function Point.new(x,y)
	local point = {}
	setmetatable(point, Point)
	point.x = x
	point.y = y
	return point
end

function Point:distanceTo(point)
	return distance(self,point)
end

function Point:draw()
	love.graphics.points(self.x,self.y)
end

Line = {}
Line.__index = Line

function Line.new(ax,ay,bx,by)
	local line = {}
	setmetatable(line, Line)
	line.a = Point.new(ax,ay)
	line.b = Point.new(bx,by)
	return line
end

function Line:length() 
	return distance(self.a,self.b)
end

function Line:draw()
	love.graphics.line(
		self.a.x, self.a.y, 
		self.b.x, self.b.y
	)
end

Rect = {}
Rect.__index = Rect

function Rect.new(x,y,w,h)
	local rect = {}
	setmetatable(rect,Rect)  
	rect.pos = Point.new(x,y)
	rect.w = w
	rect.h = h
	rect:translate(x,y)
	return rect
end

function Rect:setX(x)
	self.pos.x = x
	self.left  = self.pos.x
	self.right = self.pos.x+self.w
end

function Rect:setY(y)
	self.pos.y  = y
	self.top    = self.pos.y
	self.bottom = self.pos.y+self.h 
end

function Rect:translate(x,y)
	self:setX(x)
	self:setY(y)
end

function Rect:move(dx,dy)
	self:translate(
		self.pos.x + (dx or 0),
		self.pos.y + (dy or 0)
	)
end

function Rect:bboxLeft()
	return Line.new(
		self.left-1, self.top,
		self.left-1, self.bottom
	)
end

function Rect:bboxRight()
	return Line.new(
		self.right+1, self.top,
		self.right+1, self.bottom
	)
end

function Rect:bboxTop()
	return Line.new(
		self.left, self.top-1,
		self.right, self.top-1
	)
end

function Rect:bboxBottom()
	return Line.new(
		self.left, self.bottom+1,
		self.right, self.bottom+1
	)
end

function Rect:getTopLeft()
	return self.pos
end

function Rect:getBottomLeft()
	return Point.new(self.left,self.bottom)
end

function Rect:getTopRight()
	return Point.new(self.right,self.top)
end

function Rect:getBottomRight()
	return Point.new(self.right,self.bottom)
end

function Rect:draw(style)
	love.graphics.rectangle(
		style, 
		self.pos.x, self.pos.y, 
		self.w, self.h
	)
end

Circle = {}
Circle.__index = Circle

function Circle.new(x,y,radius)
	local circle = {}
	setmetatable(circle, Circle)
	circle.pos = Point.new(x,y)
	circle.radius = radius
	return circle
end

function Circle:draw(style)
	love.graphics.circle(
		style, 
		self.pos.x,
		self.pos.y,
		self.radius
	)
end