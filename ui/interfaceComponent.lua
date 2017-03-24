InterfaceComponent = {}
InterfaceComponent.__index = InterfaceComponent

function InterfaceComponent.new()
	local component = {}
	setmetatable(component, InterfaceComponent)
	return component
end

function InterfaceComponent:mousepressed(x,y,button,istouch) end

function InterfaceComponent:mousereleased(x,y,button,istouch) end

function InterfaceComponent:keypressed(key,scancode,isrepeat) end

function InterfaceComponent:keyreleased(key,scancode) end

function InterfaceComponent:gamepadpressed(joystick,button) end

function InterfaceComponent:gamepadreleased(joystick,button) end

function InterfaceComponent:gamepadaxis(joystick,axis,value) end

function InterfaceComponent:hover() end

function InterfaceComponent:update(dt) end

function InterfaceComponent:draw() end