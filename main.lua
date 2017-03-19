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

require "states.menu"
require "states.game"

function switchState(newState)
	state = newState
end

function setState(newState)
	state = newState
	state.load()
end

function love.load()
	screen = Screen.new(1024,768)

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
	
	local joysticks = love.joystick.getJoysticks()

	inputs = {
		Input.new("left","right","up",joysticks[1]),
		Input.new("q","d","z",joysticks[2]),
		Input.new("j","l","i",joysticks[3]),
		Input.new("kp4","kp6","kp8",joysticks[4])
	}

	colors = {
		Color.new(106, 255, 106),
		Color.new(0, 191, 255),
		Color.new(255, 0, 50),
		Color.new(255, 128, 0)
	}

	camera = Camera.new()

	chatColor =  Color.new(255, 40, 222)

	numberOfPlayers = 3

	mapName = "maps.test0"

	setState(game)
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

	state.keypressed(key)
end

function love.update(dt)
	if dt < 1/60 then
		love.timer.sleep(1/60 - dt)
	end

	state.update(dt)
end
 
function love.resize(w,h)
	screen:resize(w,h)
end

function love.draw()
	state.draw()
end

