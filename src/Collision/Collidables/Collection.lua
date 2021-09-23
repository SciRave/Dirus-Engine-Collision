--Documentation:
--[[
	
	An object that is a collection of Collidables.
	
	---
	
	Collection.Collected -> table; the collection of collidables
		
	---
	
	Collection.new(Function onDetection, table collected) --> Collidable; creates a collection object and returns it
	
	Collection:Calculate(OverlapParams overlap) --> table; runs a collision calculation on the values of Collected and returns a unified table of results
	
--]]

local Collidable = require(script.Parent.Collidable)

local Collection = setmetatable({}, Collidable)
Collection.__index = Collection

function Collection.new(onDetection: ({BasePart}) -> (), collected: {{any}})
	
	local Object = setmetatable(Collidable.new(onDetection), Collection)
	
	Object.Collected = collected
	
	return Object

end

function Collection:Calculate(overlap: OverlapParams): {BasePart}
	
	local Collisions = {}
	
	for a,b in next, self.Collected do
		for c,d in next, b:Calculate(overlap) do
			if not table.find(Collisions, d) then
				table.insert(Collisions, d)
			end
		end
	end
	
	return Collisions
	
end

return Collection
