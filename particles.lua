function initializeParticles() 
	local squareImage = love.graphics.newImage('sprites/square.png')

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
end

function drawParticles()
	WHITE:set()
	love.graphics.draw(dustBottom)
	love.graphics.draw(dustLeft)
	love.graphics.draw(dustRight)
	love.graphics.draw(redFireworks)
	love.graphics.draw(greenFireworks)
	love.graphics.draw(blueFireworks)
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

function instantiateFireworks(x,y,amount)
	redFireworks:setPosition(x,y)
	redFireworks:emit(love.math.random(amount/3,amount))
    blueFireworks:setPosition(x,y)
	blueFireworks:emit(love.math.random(amount/3,amount))
	greenFireworks:setPosition(x,y)
	greenFireworks:emit(love.math.random(amount/3,amount))
end