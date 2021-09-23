--Documentation:
--[[
	
	An implementation of a part hitbox.
	
	---
	
	Part.Part -> BasePart; the part the collision calculation is based off of
	
	---
	
	Part.new(Function onDetection, BasePart partCast) --> Collidable; creates a part hitbox and returns it
	
	Part:Calculate(OverlapParams overlap) --> table; runs a collision calculation and returns a table of results
	
--]]

local Collidable = require(script.Parent.Collidable)

local Part = setmetatable({}, Collidable)
Part.__index = Part

function Part.new(onDetection: ({BasePart}) -> (), partCast: BasePart)
	
	local Object = setmetatable(Collidable.new(onDetection), Part)
	
	Object.Part = partCast
	
	return Object

end

function Part:Calculate(overlap: OverlapParams): {BasePart}
	return workspace:GetPartsInPart(self.Part, overlap)
end

return Part
