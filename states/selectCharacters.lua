--Author : Nicolas Reszka

selectCharacters = State.new()

function selectCharacters:load()
	self.selectors = {}
	for slot = 1, 4 do
		self.selectors[slot] = CharacterSelector.new(slot)
	end
	self.selectors[1]:setState("joined")
	self.selectors[2]:setState("joined")
	self.selectors[3]:setState("inactive")
	self.selectors[4]:setState("inactive")
end


function selectCharacters:isEveryoneReady()
	local count = 0
	local someoneIsntReady = false
	for i, selector in pairs(self.selectors) do
		local state = selector:getState()
		if state == "ready" then
			count = count + 1
		elseif state == "joined" then
			someoneIsntReady = true
		end 
	end

	if not someoneIsntReady and count > 1 then
		return true
	else 
		return false
	end
end

function selectCharacters:update(dt)
	for i, selector in pairs(self.selectors) do
		selector:update(dt)
	end
	for i, input in pairs(inputs) do
		input:update()
	end
	if self:isEveryoneReady() then
		for i, selector in pairs(self.selectors) do
			isPlaying[i] = (selector:getState() == "ready")
		end
		game:set()
		game:load()
	end
end

function selectCharacters:draw()
	for i, selector in pairs(self.selectors) do
		selector:draw()
	end
end
