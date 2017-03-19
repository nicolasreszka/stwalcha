menu = {}

function menu.load()
	camera:translate(0,0)
end

function menu.keypressed()

end

function menu.update(dt)

end

function menu.draw()
	screen:set()
	camera:set()
	love.graphics.print("test",128,128)
	camera:unset()
	screen:unset()
	screen:draw()
end

