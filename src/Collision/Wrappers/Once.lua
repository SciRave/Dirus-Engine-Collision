--Documentation:
--[[
	
	A wrapper that makes a Collidable only register a collision once per part.
	
	---
	
	Once.Blacklist -> table; table that keeps track of previous collisions
	
	---
	
	Once:Calculate(OverlapParams overlap) --> table; a modified calculate method that only returns parts that have not been collided with before
	
--]]

local Wrapper = require(script.Parent.Wrapper)

local Once = setmetatable({}, {__index = Wrapper})

function Once.apply(collidable)

	local Object = setmetatable(Wrapper.apply(collidable), Wrapper)

	rawset(Object, 'Parent', Once)

	rawset(Object, 'Blacklist', {})

	return Object

end

function Once:Calculate(overlap: OverlapParams): {BasePart}

	local Collisions = self.Wrapped:Calculate(overlap)

	local Filtered = {}	

	for i,v in next, Collisions do
		if not table.find(self.Blacklist, v) then
			table.insert(Filtered, v)
			table.insert(self.Blacklist, v)
		end
	end

	return Filtered
end

return Once
