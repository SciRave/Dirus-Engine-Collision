--Documentation:
--[[
	
	A wrapper that makes a Collidable run a function before the Calculate method.
	
	---
	
	Update.onUpdated -> Function; function that is supplied with the wrapped Collidable and ran before the Calculate method
	
	---
	
	Update.apply(Collidable|Wrapper collidable, Function onUpdated) --> Wrapper; applies the wrapper with the supplied onUpdated function to the Collidable
	
	Update:Calculate(OverlapParams overlap) --> table; a modified calculate method that runs onUpdated before the actual logic
	
--]]

local Wrapper = require(script.Parent.Wrapper)

local Update = setmetatable({}, {__index = Wrapper})

function Update.apply(collidable, onUpdated: (any) -> ())

	local Object = setmetatable(Wrapper.apply(collidable), Wrapper)

	rawset(Object, 'Parent', Update)

	rawset(Object, 'onUpdated', onUpdated)

	return Object

end

function Update:Calculate(overlap: OverlapParams): {BasePart}
	
	self.onUpdated(self.Wrapped)

	return self.Wrapped:Calculate(overlap)
	
end

return Update
