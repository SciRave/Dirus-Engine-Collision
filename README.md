# Collision

A top-level collision manager object. Originally bundled into the Dirus Framework.

## Usage

Usage of the Collision object is fairly simple. Documentation for each module is located at the top in comments.

```lua
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
```

## Installation

The latest release always carries a pre-made rbxm file.
