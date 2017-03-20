Button = {}
Button.__index = Button

function Button.new(text,rect,callBack,index)
	local button = {}
	setmetatable(button, Button)
	button.text = text
	button.rect = rect
	button.callBack = callBack
	button.hover = false
	button.index = index
	return button
end

function Button:update()
	self.hover = (buttonIndex == self.index)
end

function Button:mousemoved() 
	if pointVsRect(mouse,self.rect) then
		self.hover = true
		buttonIndex = self.index
	else 
		self.hover = false
	end
end

function Button:keypressed()
	if self.hover then
		self.callBack()
	end
end

function Button:draw()
	if self.hover then
		RED:set()
	else
		GREEN:set()
	end
	self.rect:draw("line")
	love.graphics.print(self.text, self.rect.left+8, self.rect.top+8);

end