Group = {}
Group.__index = Group 

function Group.new()
	local group = {}
	setmetatable(group, Group)
	group.objects = {}
	group.size = 0
	return group
end

function Group:add(object)
	table.insert(self.objects, object)
	self.size = self.size + 1
	return object
end

function Group:remove(objectToRemove)
	for i, object in pairs(self.objects) do
		if object == objectToRemove then
			table.remove(self.objects,i)
			self.size = self.size - 1
		end
	end
end

function Group:update(dt)
	for i, object in pairs(self.objects) do
		object:update(dt)
	end
end

function Group:draw()
	for i, object in pairs(self.objects) do
		object:draw()
	end
end

function Group:rectsVsRect(rect)
	for i, object in pairs(self.objects) do
		if object.rect ~= nil and object.rect ~= rect then
			if rectVsRect(rect,object.rect) then
				return object
			end
		end
	end
	return nil 
end

function Group:rectsVsLine(line)
	for i, object in pairs(self.objects) do
		if object.rect ~= nil then
			if lineVsRect(line,object.rect) then
				return object
			end
		end
	end
	return nil 
end

function Group:rectsVsCircle(circle)
	for i, object in pairs(self.objects) do
		if object.rect ~= nil then
			if circleVsRect(circle,object.rect) then
				return object
			end
		end
	end
	return nil 
end


function Group:rectsVsCircleList(circle)
	local list = {}
	for i, object in pairs(self.objects) do
		if object.rect ~= nil then
			if circleVsRect(circle,object.rect) then
				table.insert(list,object)
			end
		end
	end
	return list 
end

