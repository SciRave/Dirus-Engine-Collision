--Documentation:
--[[
	
	A wrapper that makes a Collidable only register a collision on a collision's end.
	
	---
	
	CollisionEnd.Collisions -> table; table that keeps track of active collisions
	
	---
	
	CollisionEnd:Calculate(OverlapParams overlap) --> table; a modified calculate method that instead returns parts when their collision with the Collidable ends
	
--]]

local Wrapper = require(script.Parent.Wrapper)

local CollisionEnd = setmetatable({}, {__index = Wrapper})

function CollisionEnd.apply(collidable)

	local Object = setmetatable(Wrapper.apply(collidable), Wrapper)

	rawset(Object, 'Parent', CollisionEnd)

	rawset(Object, 'Collisions', {})

	return Object

end

function CollisionEnd:Calculate(overlap: OverlapParams): {BasePart}

	local Collisions = self.Wrapped:Calculate(overlap)

	local Filtered = {}	

	for i,v in next, self.Collisions do
		if not table.find(Collisions, v) then
			table.insert(Filtered, v)
		end
	end

	self.Collisions = Collisions

	return Filtered
end

return CollisionEnd -- Return module
