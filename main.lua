--Author : Nicolas Reszka

-- TO DO :
-- Add music?

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
require "objects.solidBlock"
require "objects.cloud"
require "objects.player"
require "objects.god"
require "objects.explosion"
require "objects.particles"
require "objects.characters"
require "objects.customParticles"
require "objects.lava"
require "objects.bomb"
require "objects.eye"

require "states.menu"
require "states.controls"
require "states.options"
require "states.selectCharacters"
require "states.selectMap"
require "states.game"
require "states.credits"

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
	mouse.leftDown = false
	mouse.leftPressed = false
	audioListener = Point.new(screen.w/2,screen.h/2)

	font16 = love.graphics.newFont("sprites/font.ttf", 16)
	font32 = love.graphics.newFont("sprites/font.ttf", 32)
	font48 = love.graphics.newFont("sprites/font.ttf", 48)
	font72 = love.graphics.newFont("sprites/font.ttf", 72)
	font128 = love.graphics.newFont("sprites/font.ttf", 128)

	love.audio.setPosition(0,0,0)
	sfx = {
		jump = 		love.audio.newSource("sounds/jump.wav", "static"),
		bump = 		love.audio.newSource("sounds/bump.wav", "static"),
		land = 		love.audio.newSource("sounds/land.wav", "static"),
		slide = 	love.audio.newSource("sounds/slide.wav", "static"),
		tick = 		love.audio.newSource("sounds/tick.wav", "static"),
		fireworks = love.audio.newSource("sounds/fireworks.wav", "static"),
		splash =    love.audio.newSource("sounds/splash.wav", "static"),
		lava =      Sound.new(love.audio.newSource("sounds/lava.wav", "static")),
		lighting =  Sound.new(love.audio.newSource("sounds/lighting.wav", "static")),
		explosion = Sound.new(love.audio.newSource("sounds/explosion.wav", "static")),
		god = 		Sound.new(love.audio.newSource("sounds/god.wav", "static"))
	}

	uiSfx = {
		move = love.audio.newSource("sounds/UI/move.wav", "static"),
		yes = love.audio.newSource("sounds/UI/yes.wav", "static"),
		no = love.audio.newSource("sounds/UI/no.wav", "static"),
		minus = love.audio.newSource("sounds/UI/minus.wav", "static"),
		plus = love.audio.newSource("sounds/UI/plus.wav", "static")
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

	chatColor =  Color.new(255, 0, 208)
	colors = {
		Color.new(0, 255, 85),
		Color.new(255, 0, 60),
		Color.new(0, 165, 255),
		Color.new(212, 255, 0)
	}
	-- colors = {
	-- 	GREEN:clone(),
	-- 	RED:clone(),
	-- 	BLUE:clone(),
	-- 	YELLOW:clone()
	-- }

	isPlaying = {false,false,false,false}
	choosenCharacters = {nil,nil,nil,nil}

	menu:load()
	menu:set()

	--debug
	-- isPlaying = {true,true,true,true}
	-- choosenCharacters = {characters[1],characters[1],characters[1],characters[1]}
	-- mapName = "maps.getTheEye"
	-- game:load()
	-- -- game.halfTime = false
	-- game:set()

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
	if button == 1 then
		if mouse.leftDown == false then
			mouse.leftPressed = true
		end
		mouse.leftDown = true
	end
end

function love.mousereleased(x,y,button,istouch)
	gameState:mousereleased(x,y,button,istouch)
	if button == 1 then
		mouse.leftDown = false
	end
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
	mouse.leftPressed = false
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

