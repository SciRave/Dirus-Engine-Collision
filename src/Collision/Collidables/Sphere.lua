--Documentation:
--[[
	
	An implementation of a sphere hitbox.
	
	---
	
	Sphere.Origin -> Vector3; the origin of the sphere
	
	Sphere.Radius -> number; the radius of the sphere
	
	---
	
	Sphere.new(Function onDetection, Vector3 origin, number size) --> Collidable; creates a box hitbox and returns it
	
	Sphere:Calculate(OverlapParams overlap) --> table; runs a collision calculation and returns a table of results
	
--]]

local Collidable = require(script.Parent.Collidable)

local Sphere = setmetatable({}, Collidable)
Sphere.__index = Sphere

function Sphere.new(onDetection: ({BasePart}) -> (), origin: Vector3, radius: number)

	local Object = setmetatable(Collidable.new(onDetection), Sphere)

	Object.Origin = origin
	Object.Radius = radius

	return Object

end

function Sphere:Calculate(overlap: OverlapParams): {BasePart}
	return workspace:GetPartBoundsInRadius(self.Origin, self.Radius, overlap)
end

return Sphere
