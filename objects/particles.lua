--Author : Nicolas Reszka

local squareImage = love.graphics.newImage('sprites/particle.png')
local rainImage = love.graphics.newImage('sprites/rainParticle.png')
local flameImage = love.graphics.newImage('sprites/flameParticle.png')

function initializeParticles()

	fireParticles = love.graphics.newParticleSystem(flameImage, 256)
	fireParticles:setParticleLifetime(0.2,0.35)
	fireParticles:setSizeVariation(0.5)
	fireParticles:setLinearAcceleration(-400, -500, 400, -350)
	fireParticles:setColors(255, 255, 255, 255, 255, 255, 255, 0)

	dustBottom = love.graphics.newParticleSystem(squareImage, 100)
	dustBottom:setParticleLifetime(0.2,0.4)
	dustBottom:setSizeVariation(0.5)
	dustBottom:setLinearAcceleration(-500, -200, 500, -400)
	dustBottom:setColors(255, 255, 255, 255, 255, 255, 255, 0)

	dustLeft = love.graphics.newParticleSystem(squareImage, 100)
	dustLeft:setParticleLifetime(0.5)
	dustLeft:setSizeVariation(0.5)
	dustLeft:setLinearAcceleration(10, -200, 400, -400)
	dustLeft:setColors(255, 255, 255, 255, 255, 255, 255, 0)

	dustRight = love.graphics.newParticleSystem(squareImage, 100)
	dustRight:setParticleLifetime(0.5)
	dustRight:setSizeVariation(0.5)
	dustRight:setLinearAcceleration(-300, -200, 10, -400)
	dustRight:setColors(255, 255, 255, 255, 255, 255, 255, 0)

	confettis = love.graphics.newParticleSystem(squareImage, 500)
	confettis:setParticleLifetime(2, 6) 
	confettis:setSizeVariation(1)
	confettis:setLinearAcceleration(-20, 200, 20, 300)
	confettis:setColors(255, 255, 255, 255, 255, 255, 255, 0) 

	rain = love.graphics.newParticleSystem(rainImage, 500)
	rain:setParticleLifetime(4, 6) 
	rain:setSizeVariation(1)
	rain:setLinearAcceleration(-20, 200, 20, 300)
	rain:setColors(255, 255, 255, 255, 255, 255, 255, 0) 

	redFireworks = love.graphics.newParticleSystem(squareImage, 100)
	redFireworks:setParticleLifetime(1, 2) 
	redFireworks:setSizeVariation(1)
	redFireworks:setLinearAcceleration(-300, -100, 300, 300)
	redFireworks:setColors(
		255, 0, 255, 255,
		255, 0, 0, 255, 
		255, 0, 0, 0
	) 

	blueFireworks = redFireworks:clone()
	blueFireworks:setColors(
		128, 128, 255, 255,
		0, 0, 255, 255,
		0, 0, 255, 0
	) 

	greenFireworks = redFireworks:clone()
	greenFireworks:setColors(
		255, 255, 128, 255, 
		128, 255, 0, 255,
		0, 255, 0, 0
	) 
end

function updateParticles()
	dt = love.timer.getDelta()
	dustBottom:update(dt)
	dustLeft:update(dt)
	dustRight:update(dt)
	redFireworks:update(dt)
	greenFireworks:update(dt)
	blueFireworks:update(dt)
	confettis:update(dt)
	rain:update(dt)
	fireParticles:update(dt)
end

function drawParticles()
	WHITE:set()
	love.graphics.draw(rain)
	love.graphics.draw(dustBottom)
	love.graphics.draw(dustLeft)
	love.graphics.draw(dustRight)
	love.graphics.draw(redFireworks)
	love.graphics.draw(greenFireworks)
	love.graphics.draw(blueFireworks)
	if mapName == "maps.neon2" then
		love.graphics.setColor(255,243,56)
		--love.graphics.setColor(177,177,19)
	elseif mapName == "maps.lava" then
		love.graphics.setColor(52,15,34)
	else
		love.graphics.setColor(0,6,22)
	end
	love.graphics.draw(confettis)
end

function instantiateFire(x,y,amount)
	fireParticles:setPosition(x,y)
	fireParticles:emit(amount)
end

function instantiateDustBottom(x,y,amount)
	dustBottom:setPosition(x,y)
	dustBottom:emit(amount)
end

function instantiateDustLeft(x,y,amount)
	dustLeft:setPosition(x,y)
	dustLeft:emit(amount)
end

function instantiateDustRight(x,y,amount)
	dustRight:setPosition(x,y)
	dustRight:emit(amount)
end

function instantiateConfettis(x,y,amount)
	confettis:setPosition(x,y)
	confettis:emit(amount)
end

function instantiateRain(x,y,amount)
	rain:setPosition(x,y)
	rain:emit(amount)
end

function instantiateFireworks(x,y,amount)
	redFireworks:setPosition(x,y)
	redFireworks:emit(love.math.random(amount/3,amount))
    blueFireworks:setPosition(x,y)
	blueFireworks:emit(love.math.random(amount/3,amount))
	greenFireworks:setPosition(x,y)
	greenFireworks:emit(love.math.random(amount/3,amount))
end