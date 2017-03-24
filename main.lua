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

require "ui.interfaceComponent"
require "ui.button"
require "ui.switch"
require "ui.slider"
require "ui.listInterface"
require "ui.gridInterface"

require "objects.input"
require "objects.block"
require "objects.player"
require "objects.god"
require "objects.explosion"
require "objects.particles"

require "states.menu"
require "states.options"
require "states.selectMode"
require "states.selectMap"
require "states.game"

function love.load()
	screen = Screen.new(1024,768)
	camera = Camera.new()
	mouse = Point.new(0,0)

	love.audio.setPosition(0,0,0)
	audioListener = Point.new(screen.w/2,screen.h/2)

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

