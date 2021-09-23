--Documentation:
--[[
	
	A basic empty implementation of a Wrapper object.
	
	Notes:
	
		* Wrappers inherent the functionality, albeit with the capacity to modify it, of the objects they 'wrap'.
		
		* Wrappers can be stacked by applying a wrapper to an already-wrapped collidable.
	
		* It does not by default contain a metatable, as it is only inherented and not used verbatim.
	
	---
	
	Wrapper.Wrapped -> Collidable | Wrapper; the object from which the wrapper derives its base functionality
	
	Wrapper.Parent -> Wrapper; the 'Parent' of the wrapper from which it derives its modified functionality
	
	---
	
	Wrapper.apply(Collidable|Wrapper collidable) --> Wrapper; applies the wrapper to an object
	
--]]

local Wrapper = {}

function Wrapper.__index(tab, index)

	local Parent = rawget(tab, 'Parent')[index]

	if (Parent) then
		return Parent
	end

	return rawget(tab, 'Wrapped')[index]

end

function Wrapper.__newindex(tab, index, value)
	rawget(tab, 'Wrapped')[index] = value
end

function Wrapper.apply(collidable)
	
	local Object = {}
		
	rawset(Object, 'Wrapped', collidable)
	
	return Object
	
end

return Wrapper
