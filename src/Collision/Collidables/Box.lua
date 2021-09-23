--Documentation:
--[[
	
	An implementation of a box hitbox.
	
	---
	
	Box.Origin -> CFrame; the origin of the box
	
	Box.Size -> Vector3; the size of the box
	
	---
	
	Box.new(Function onDetection, CFrame origin, Vector3 size) --> Collidable; creates a box hitbox and returns it
	
	Box:Calculate(OverlapParams overlap) --> table; runs a collision calculation and returns a table of results
	
--]]

local Collidable = require(script.Parent.Collidable)

local Box = setmetatable({}, Collidable)
Box.__index = Box

function Box.new(onDetection: ({BasePart}) -> (), origin: CFrame, size: Vector3)
	
	local Object = setmetatable(Collidable.new(onDetection), Box)
	
	Object.Origin = origin
	Object.Size = size
	
	return Object

end

function Box:Calculate(overlap: OverlapParams): {BasePart}
	return workspace:GetPartBoundsInBox(self.Origin, self.Size, overlap)
end

return Box 
