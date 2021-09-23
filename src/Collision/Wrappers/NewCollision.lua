--Documentation:
--[[
	
	A wrapper that makes a Collidable only register a collision on a collision's beginning.
	
	---
	
	NewCollision.Collisions -> table; table that keeps track of active collisions
	
	---
	
	NewCollision:Calculate(OverlapParams overlap) --> table; a modified calculate method that instead returns parts only when their collision with the Collidable first begins
	
--]]

local Wrapper = require(script.Parent.Wrapper)

local NewCollision = setmetatable({}, {__index = Wrapper})

function NewCollision.apply(collidable)
	
	local Object = setmetatable(Wrapper.apply(collidable), Wrapper)
	
	rawset(Object, 'Parent', NewCollision)
	
	rawset(Object, 'Collisions', {})

	return Object

end

function NewCollision:Calculate(overlap: OverlapParams): {BasePart}
	
	local Collisions = self.Wrapped:Calculate(overlap)
	
	local Filtered = {}	
		
	for i,v in next, Collisions do
		if not table.find(self.Collisions, v) then
			table.insert(Filtered, v)
		end
	end
	
	self.Collisions = Collisions
	
	return Filtered
end

return NewCollision
