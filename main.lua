require "lib.maths"
require "lib.shapes"
require "lib.collisions"
require "lib.group"
require "lib.clock"
require "lib.tween"
require "lib.color"
require "lib.camera"
require "lib.screen"

require "objects.block"
require "objects.player"
require "objects.god"
require "objects.explosion"

require "specific.input"
require "specific.particles"
require "specific.sound"
require "specific.button"

menu = require "states.menu"
game = require "states.game"

function switchState(state)
	gameState = state
end

function setState(state)
	gameState = state
	gameState:load()
end

function love.load()
	screen = Screen.new(1024,768)
	camera = Camera.new()

	font = love.graphics.newFont("sprites/font.ttf",32)
	love.graphics.setFont(font)

	love.audio.setPosition(0,0,0)
	audioListener = Point.new(512,384)
	sfx = {
		jump = love.audio.newSource("sounds/jump.wav", "static"),
		bump = love.audio.newSource("sounds/bump.wav", "static"),
		land = love.audio.newSource("sounds/land.wav", "static"),
		slide = love.audio.newSource("sounds/slide.wav", "static"),
		tick = love.audio.newSource("sounds/tick.wav", "static"),
		fireworks = love.audio.newSource("sounds/fireworks.wav", "stream"),
		lighting = Sound.new(love.audio.newSource("sounds/lighting.wav", "stream")),
		explosion = Sound.new(love.audio.newSource("sounds/explosion.wav", "stream")),
		god = Sound.new(love.audio.newSource("sounds/god.wav", "stream"))
	}
	
	mouse = Point.new(0,0)
	menuInput = require("specific.menuInput")
	inputs = {
		Input.new("left","right","up"),
		Input.new("q","d","z"),
		Input.new("j","l","i"),
		Input.new("kp4","kp6","kp8")
	}
	
	chatColor =  Color.new(255, 40, 222)
	colors = {
		Color.new(106, 255, 106),
		Color.new(0, 191, 255),
		Color.new(255, 0, 50),
		Color.new(255, 128, 0)
	}

	numberOfPlayers = 2
	mapName = "maps.test0"
	setState(menu)
end

function love.joystickadded(joystick)
	if menuInput.joystick == nil 
	or not menuInput.joystick:isConnected()	then
		menuInput.joystick = joystick
	end

	for i, input in pairs(inputs) do
		if input.joystick == nil 
		or not input.joystick:isConnected() then
			input.joystick = joystick
			break
		end
	end
end

function love.mousemoved(x,y)
	mouse.x = (x - screen.x)/screen.scale + camera.pos.x
	mouse.y = (y - screen.y)/screen.scale + camera.pos.y

	if gameState.mousemoved ~= nil then
		gameState:mousemoved()
	end
end

function love.mousepressed(x,y,button)
	if gameState.mousepressed ~= nil then
		gameState:mousepressed(x,y,button)
	end
end

function love.keypressed(key)
	if key == "kp0" then
		setState(menu)
	end 

	if key == "kp1" then 
		mapName = "maps.test0"
		setState(game)
	end

	if key == "kp2" then 
		mapName = "maps.test1"
		setState(game)
	end

	if gameState.keypressed ~= nil then
		gameState:keypressed(key)
	end
end

function love.update(dt)
	if dt < 1/60 then
		love.timer.sleep(1/60 - dt)
	end

	menuInput:update()
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

