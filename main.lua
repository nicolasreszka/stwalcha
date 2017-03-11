require "lib.maths"
require "lib.shapes"
require "lib.collisions"
require "lib.group"
require "lib.clock"
require "lib.tween"
require "lib.color"
require "lib.camera"

require "game"
require "input"
require "particles"
require "block"
require "player"
require "god"
require "explosion"
require "sound"

function love.load()

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

	chatColor =  Color.new(255, 40, 222)

	camera = Camera.new()

	pause = false
	numberOfPlayers = 3

	loadAudio()
	mapName = "maps.test0"
	loadMap()
end

function love.keypressed(key)
	if key == "kp1" then 
		mapName = "maps.test0"
		loadMap()
	end

	if key == "kp2" then 
		mapName = "maps.test1"
		loadMap()
	end

	if key == "escape" then
		pause = not pause
	end
end

function love.update(dt)
	if dt < 1/60 then
		love.timer.sleep(1/60 - dt)
	end

	updateGame()
end
 
function love.draw()
	camera:set()
	blocks:draw()
	players:draw()
	explosions:draw()
	
	if halfTime then
		god:draw()
	end

	drawParticles()
	camera:unset()
end

