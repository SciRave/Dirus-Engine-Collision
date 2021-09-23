--Documentation:
--[[
	
	A top-level collision manager object.
	
	---
	
	Collision.Collidables -> table; holds a list of managed hitboxes
	
	Collision.Params -> OverlapParams; holds the OverlapParams used for the hitboxes
	
	---

	Collision.new(OverlapParams overlap) --> New Collision object
	
	Collision:Check() --> nil; runs all the hitboxes
	
	Collision:Start() --> RBXScriptConnection; connects :Check() to a RunService event for automatic hit detection
	
	Collision:Stop() --> nil; if a connection has been created from :Start() then it will be disconnected and discarded
	
	Collision:Add(Collidable collidable) --> nil; adds a Collidable object to the list of managed hitboxes
	
	-- Note: A collidable object is anything that supplies a Detect function/method, default implementations are avalible
	
	Collision:Remove(Collidable collidable) --> nil; if the collidable is in the list of managed hitboxes then it is removed
	
	Collision:AddBox(Function onDetection, CFrame origin, Vector3 size) --> Collidable; creates a box hitbox, adds it, and returns it
	
	Collision:AddSphere(Function onDetection, Vector3 origin, Vector3 size) --> Collidable; creates a sphere hitbox, adds it, and returns it
	
	Collision:AddPart(Function onDetection, BasePart partCast) --> Collidable; creates a part hitbox, adds it, and returns it
	
--]]

local PostSim = game:GetService("RunService").Heartbeat -- Will transfer to PostSimulation once it's valid

local Collidables = script.Parent.Collidables

local Box = require(Collidables.Box)
local Sphere = require(Collidables.Sphere)
local Part = require(Collidables.Part)

local Collision = {}
Collision.__index = Collision


function Collision.new(overlap: OverlapParams)
	
	local Object = setmetatable({}, Collision)
	
	Object.Collidables = {}
	Object.Params = overlap
	
	return Object
	
end

function Collision:Check()
	
	for i,v in next, self.Collidables do
		v:Detect(self.Params)
	end
		
end

function Collision:Start()
	
	assert(self.Connection == nil, "Collision object is already active!") -- The reason for this seemingly arbitrary assert is to prevent a silent logic error
	
	self.Connection = PostSim:Connect(function()
		self:Check()
	end)
	
	return self.Connection
	
end

function Collision:Stop()
	
	if self.Connection then
		
		self.Connection:Disconnect()
		self.Connection = nil
		
	end
	
end

function Collision:Add(collidable)
	
	table.insert(self.Collidables, collidable)
	
end

function Collision:Remove(collidable)
	
	local Position = table.find(self.Collidables, collidable)
	
	if Position then
		table.remove(self.Collidables, Position)
	end
	
end

function Collision:AddBox(onDetection: ({BasePart}) -> (), origin: CFrame, size: Vector3)
	
	local boxShape = Box.new(onDetection, origin, size)
	
	self:Add(boxShape)
	
	return boxShape
	
end

function Collision:AddSphere(onDetection: ({BasePart}) -> (), origin: Vector3, radius: number)

	local sphereShape = Sphere.new(onDetection, origin, radius)
	
	self:Add(sphereShape)
	
	return sphereShape

end

function Collision:AddPart(onDetection: ({BasePart}) -> (), partCast: BasePart)

	local partShape = Part.new(onDetection, partCast)
	
	self:Add(partShape)

	return partShape

end


return Collision

--Example:
--[[

	local Overlap = OverlapParams.new()
	local Player = game.Players:FindFirstChildOfClass("Player") or game.Players.PlayerAdded:Wait()
	local Character = Player.Character or Player.CharacterAdded:Wait()
	Overlap.FilterDescendantsInstances = Character:GetChildren()
	Overlap.FilterType = Enum.RaycastFilterType.Whitelist
	Overlap.MaxParts = 0 --Actually makes the max math.huge

	local Collision = require(game.ReplicatedStorage.Collision.Collision).new(Overlap) --Top-level Collision manager

	local PartCast = require(game.ReplicatedStorage.Collision.Collidables.Part) --Part-based hitbox object

	local Part = PartCast.new(function(tab)
	  print(unpack(tab)) --Prints all resultant parts when a hit registers
	end, workspace.Part) --Initiation. The function is what is ran when the hitbox detects something. It checks every heartbeat.

	local Once = require(game.ReplicatedStorage.Collision.Wrappers.Once) --A wrapper. This one makes registered hits for parts only happen once per part.

	Collision:Add(Once.apply(Part)) --Add to the manager.

	Collision:Start() --Connects the manager to the heartbeat event. Roblox event connections are ordered in aescending order. 
	--So if you want certain groups of hitboxes to hit first, you can call :Start() methods from lowest to highest priority.
	
--]]
