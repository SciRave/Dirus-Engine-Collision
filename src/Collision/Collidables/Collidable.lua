--Documentation:
--[[
	
	A basic empty implementation of a Collidable object.
	
	Note: It does not by default contain a metatable, as it is only inherented and not used verbatim.
	
	---
	
	Collidable.onDetection -> Function; function used when a collision is detected
	
	---
	
	Collidable.new(Function onDetection) --> Collidable; creates a Collidable object that only contains a onDetection function
	
	Collidable:Detect(OverlapParams Overlap) --> nil;  abstract method for running the hitbox
	
	-- Note: it relies on a Calculate method that does not exist by default
	
	-- Note: if the table is empty then the onDetection function is never called
	
--]]

local Collidable = {}
Collidable.__index = Collidable


function Collidable.new(onDetection: ({BasePart}) -> ())
	
	local Object = {}
	
	Object.onDetection = onDetection
	
	return Object
	
end


function Collidable:Detect(overlap: OverlapParams)
		
	local Detected = self:Calculate(overlap)
	
	if #Detected > 0 then
		task.spawn(self.onDetection, Detected)
	end
	
end

return Collidable
