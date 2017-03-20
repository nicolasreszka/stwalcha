local menuInput = {
	up = false,
	down = false,
	okBefore = false,
	okPressed = false,
	backBefore = false,
	backPressed = false,
	pauseBefore = false,
	pausePressed = false,
	joystick = nil
}

local deadzone = 0.25

function menuInput:update()
	if love.keyboard.isDown("up")
	or self.joystick and (self.joystick:isGamepadDown("dpup")
	or self.joystick:getGamepadAxis("lefty") < -deadzone) then
		self.up = true 
	else 
		self.up = false
	end

	if love.keyboard.isDown("down")
	or self.joystick and (self.joystick:isGamepadDown("dpdown")
	or self.joystick:getGamepadAxis("lefty") > deadzone) then
		self.down = true
	else 
		self.down = false 
	end

	local ok = false
	if love.keyboard.isDown("return")
	or self.joystick and self.joystick:isGamepadDown("a")
	or love.mouse.isDown(1) then
		ok = true
	end

	self.okPressed = false
	if not self.okBefore and ok then
		self.okPressed = true
	end

	self.okBefore = ok

	local back = false
	if love.keyboard.isDown("escape")
	or self.joystick and self.joystick:isGamepadDown("b") then
		back = true
	end

	self.backPressed = false
	if not self.backBefore and back then
		self.backPressed = true
	end

	self.backBefore = back

	local pause = false
	if love.keyboard.isDown("escape") 
	or self.joystick and self.joystick:isGamepadDown("start") then
		pause = true
	end

	self.pausePressed = false
	if not self.pauseBefore and pause then
		self.pausePressed = true
	end

	self.pauseBefore = pause
end

return menuInput