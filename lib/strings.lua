function string:split(delimiter)
	local result = {}
	local from = 1
	local delimiterFrom, delimiterTo = string.find(self,delimiter,from)

	while delimiterFrom do
		table.insert(result, string.sub(self, from, delimiterFrom-1))
		from = delimiterTo + 1
		delimiterFrom, delimiterTo = string.find(self,delimiter,from)
	end

	table.insert(result, string.sub(self, from))

	return result
end

function booleanToString(boolean) 
	if boolean == true then
		return "true"
	else 
		return "false"
	end
end