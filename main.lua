require "lib.maths"
require "lib.shapes"
require "lib.collisions"
require "lib.group"
require "lib.clock"
require "lib.tween"
require "lib.camera"

require "bubble"
require "explosion"
require "player"
require "block"
require "input"
require "particles"
require "game"

function love.load()
	local joysticks = love.joystick.getJoysticks()

	inputs = {
		Input.new("left","right","up",joysticks[1]),
		Input.new("q","d","z",joysticks[2]),
		Input.new("j","l","i",joysticks[3]),
		Input.new("kp4","kp6","kp8",joysticks[3])
	}

	camera = Camera.new()
	
	pause = false
	numberOfPlayers = 2
	loadMap("maps.test0")
end

function love.keypressed(key)
	if key == "r" then 
		loadMap("maps.test0")
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
	bubbles:draw()
	explosions:draw()
	drawParticles()
	camera:unset()
end

