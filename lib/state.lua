State = {}
State.__index = State

function State.new()
	local state = {}
	setmetatable(state, State)
	return state
end

function State:set()
	gameState = self
end

function State:load() end

function State:mousemoved(x,y,dx,dy,istouch) end

function State:mousepressed(x,y,button,istouch) end

function State:mousereleased(x,y,button,istouch) end

function State:keypressed(key,scancode,isrepeat) end

function State:keyreleased(key,scancode) end

function State:gamepadpressed(joystick,button) end

function State:gamepadreleased(joystick,button) end

function State:gamepadaxis(joystick,axis,value) end

function State:update(dt) end

function State:draw() end

