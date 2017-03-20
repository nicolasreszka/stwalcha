local menu = {}

function menu:load()
	camera:translate(0,0)
	buttons = Group.new()
	buttons:add(Button.new(
		"play",
		Rect.new(64,64,128,64),
		function() setState(game) end,
		1
	))
	buttons:add(Button.new(
		"options",
		Rect.new(64,192,128,64),
		function() end,
		2
	))
	buttons:add(Button.new(
		"quit",
		Rect.new(64,320,128,64),
		function() love.event.quit() end,
		3
	))
	buttonIndex = 1
	buttons:update()
	buttonTimer = Clock.new(0.2)
end

function menu:mousemoved()
	buttons:mousemoved()
end

function menu:update(dt)
	if menuInput.okPressed then
		buttons:keypressed()
	end

	if menuInput.up then
		if buttonTimer:zero() then
			if buttonIndex > 1 then
				buttonIndex = buttonIndex - 1
			else
				buttonIndex = buttons.size
			end
			buttons:update()
			buttonTimer:tick()
		end
	elseif menuInput.down then
		if buttonTimer:zero() then
			if buttonIndex < buttons.size then
				buttonIndex = buttonIndex + 1
			else
				buttonIndex = 1
			end
			buttons:update()
			buttonTimer:tick()
		end
	else 
		buttonTimer:reset()
	end
		
	if not buttonTimer:zero() then
		buttonTimer:tick()
		if buttonTimer:alarm() then
			buttonTimer:reset()
		end
	end
end

function menu:draw()
	camera:set()
	buttons:draw()
	camera:unset()
end

return menu