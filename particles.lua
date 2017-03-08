function initializeParticles() 
	local image = love.graphics.newImage('sprites/square.png')

	dustBottom = love.graphics.newParticleSystem(image, 100)
	dustBottom:setParticleLifetime(0.2,0.4)
	dustBottom:setSizeVariation(0.5)
	dustBottom:setLinearAcceleration(-500, -200, 500, -400)
	dustBottom:setColors(255, 255, 255, 255, 255, 255, 255, 0)

	dustLeft = love.graphics.newParticleSystem(image, 100)
	dustLeft:setParticleLifetime(0.5)
	dustLeft:setSizeVariation(0.5)
	dustLeft:setLinearAcceleration(10, -200, 400, -400)
	dustLeft:setColors(255, 255, 255, 255, 255, 255, 255, 0)

	dustRight = love.graphics.newParticleSystem(image, 100)
	dustRight:setParticleLifetime(0.5)
	dustRight:setSizeVariation(0.5)
	dustRight:setLinearAcceleration(-300, -200, 10, -400)
	dustRight:setColors(255, 255, 255, 255, 255, 255, 255, 0)

	confettis = love.graphics.newParticleSystem(image, 500)
	confettis:setParticleLifetime(2, 6) 
	confettis:setSizeVariation(1)
	confettis:setLinearAcceleration(-20, 200, 20, 300)
	confettis:setColors(255, 255, 255, 255, 255, 255, 255, 0) 
end

function updateParticles()
	dt = love.timer.getDelta()
	dustBottom:update(dt)
	dustLeft:update(dt)
	dustRight:update(dt)
	confettis:update(dt)
end

function drawParticles()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(dustBottom)
	love.graphics.draw(dustLeft)
	love.graphics.draw(dustRight)
	love.graphics.setColor(255,0,128)
	love.graphics.draw(confettis)
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