--Author : Nicolas Reszka

Input = {
	leftDown = 0,
	rightDown = 0,
	jumpDown = false,
	jumpPressed = false,
	jumpBefore = false,
	backDown = false,
	backPressed = false,
	backBefore = false
}
Input.__index = Input

local deadzone = 0.25

function Input.new(left,right,jump,back)
	local input = {}
	setmetatable(input, Input)
	input.left = left
	input.right = right
	input.jump = jump
	input.back = back
	input.joystick = nil
	return input
end

function Input:vibration(duration)
	if self.joystick then
		if self.joystick:isVibrationSupported() then
			self.joystick:setVibration(1,1,duration)
		end
	end
end

function Input:update()
	if love.keyboard.isDown(self.left)
	or self.joystick and (self.joystick:isGamepadDown("dpleft")
	or self.joystick:getGamepadAxis("leftx") < -deadzone) then
		self.leftDown = 1
	else 
		self.leftDown = 0
	end

	if love.keyboard.isDown(self.right)
	or self.joystick and (self.joystick:isGamepadDown("dpright")
	or self.joystick:getGamepadAxis("leftx") > deadzone) then
		self.rightDown = 1
	else 
		self.rightDown = 0
	end

	if love.keyboard.isDown(self.jump)
	or self.joystick and self.joystick:isGamepadDown("a") then
		self.jumpDown = true
	else 
		self.jumpDown = false
	end

	self.jumpPressed = false
	if not self.jumpBefore and self.jumpDown then
		self.jumpPressed = true
	end

	self.jumpBefore = self.jumpDown

	if love.keyboard.isDown(self.back)
	or self.joystick and self.joystick:isGamepadDown("b") then
		self.backDown = true
	else 
		self.backDown = false
	end

	self.backPressed = false
	if not self.backBefore and self.backDown then
		self.backPressed = true
	end

	self.backBefore = self.backDown
end