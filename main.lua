--Author : Nicolas Reszka

require "lib.maths"
require "lib.color"
require "lib.shapes"
require "lib.collisions"
require "lib.screen"
require "lib.camera"
require "lib.clock"
require "lib.tween"
require "lib.state"
require "lib.object"
require "lib.group"
require "lib.sound"
require "lib.strings"

require "ui.interfaceComponent"
require "ui.button"
require "ui.switch"
require "ui.slider"
require "ui.keyBinder"
require "ui.listInterface"
require "ui.gridInterface"
require "ui.keyBindingInterface"
require "ui.characterSelector"
require "ui.animatedText"

require "objects.input"
require "objects.block"
require "objects.player"
require "objects.god"
require "objects.explosion"
require "objects.particles"

require "states.menu"
require "states.controls"
require "states.options"
require "states.selectCharacters"
require "states.selectMap"
require "states.game"

function loadData(filename)
	local text = love.filesystem.read(filename)
	local strings = text:split(";")
	local data = {}
	for i = 1, #strings do
		local variable = strings[i]:split(" = ")
		local value = variable[2]
		if value == "true" then
			value = true
		elseif value == "false" then
			value = false
		elseif value == "nil" then
			value = nil
		elseif tonumber(value) then
			value = tonumber(value)
		end
		data[variable[1]] = value
	end
	return data
end

function love.load()
	screen = Screen.new(1024,768)
	camera = Camera.new()
	mouse = Point.new(0,0)
	audioListener = Point.new(screen.w/2,screen.h/2)

	font16 = love.graphics.newFont("sprites/font.ttf", 16)
	font32 = love.graphics.newFont("sprites/font.ttf", 32)
	font48 = love.graphics.newFont("sprites/font.ttf", 48)
	font72 = love.graphics.newFont("sprites/font.ttf", 72)

	love.audio.setPosition(0,0,0)
	sfx = {
		jump = 		love.audio.newSource("sounds/jump.wav", "static"),
		bump = 		love.audio.newSource("sounds/bump.wav", "static"),
		land = 		love.audio.newSource("sounds/land.wav", "static"),
		slide = 	love.audio.newSource("sounds/slide.wav", "static"),
		tick = 		love.audio.newSource("sounds/tick.wav", "static"),
		fireworks = love.audio.newSource("sounds/fireworks.wav", "stream"),
		lighting =  Sound.new(love.audio.newSource("sounds/lighting.wav", "stream")),
		explosion = Sound.new(love.audio.newSource("sounds/explosion.wav", "stream")),
		god = 		Sound.new(love.audio.newSource("sounds/god.wav", "stream"))
	}

	if love.filesystem.exists("settings.txt") then
		local data = loadData("settings.txt")
		love.window.setFullscreen(data["fullscreen"])
		love.audio.setVolume(data["volume"])
	end

	if love.filesystem.exists("controls.txt") then
		local data = loadData("controls.txt")
		inputs = {}
		for i = 1, 4 do
			inputs[i] = Input.new(
				data["left" .. i],
				data["right" .. i],
				data["jump" .. i],
				data["back" .. i]
			)
		end
	else 
		inputs = {
			Input.new("left","right","up","down"),
			Input.new("q","d","z","s"),
			Input.new("j","l","i","k"),
			Input.new("kp4","kp6","kp8","kp5")
		}
	end

	chatColor =  Color.new(255, 40, 222)
	colors = {
		Color.new(106, 255, 106),
		Color.new(0, 191, 255),
		Color.new(255, 0, 50),
		Color.new(255, 128, 0)
	}
	isPlaying = {false,false,false,false}

	menu:set()
	gameState:load()
end

function love.joystickadded(joystick)
	for i, input in pairs(inputs) do
		if input.joystick == nil 
		or not input.joystick:isConnected() then
			input.joystick = joystick
			break
		end
	end
end

function love.mousemoved(x,y,dx,dy,istouch)
	mouse.x = (x-screen.x)/screen.scale+camera.pos.x
	mouse.y = (y-screen.y)/screen.scale+camera.pos.y

	gameState:mousemoved(x,y)
end

function love.mousepressed(x,y,button,istouch)
	gameState:mousepressed(x,y,button,istouch)
end

function love.mousereleased(x,y,button,istouch)
	gameState:mousereleased(x,y,button,istouch)
end

function love.keypressed(key,scancode,isrepeat)
	gameState:keypressed(key,scancode,isrepeat)
end

function love.keyreleased(key,scancode)
	gameState:keyreleased(key,scancode)
end

function love.gamepadpressed(joystick,button)
	gameState:gamepadpressed(joystick,button)
end

function love.gamepadreleased(joystick,button)
	gameState:gamepadreleased(joystick,button)
end

function love.gamepadaxis(joystick,axis,value)
	gameState:gamepadaxis(joystick,axis,value)
end

function love.update(dt)
	if dt < 1/60 then
		love.timer.sleep(1/60 - dt)
	end
	gameState:update(dt)
end

function love.resize(w,h)
	screen:resize(w,h)
end

function love.draw()
	screen:set()
	gameState:draw()
	screen:unset()
	screen:draw()
end

