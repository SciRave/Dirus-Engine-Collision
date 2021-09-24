# Dirus Framework: Collision

A top-level collision manager object. Originally bundled into the Dirus Framework.

## Practical advantages

* Extensibility of the Collidable and Wrapper objects help unify redundant collision-related code

* Assortment of default Collidable and Wrapper implementations saves time

* Seperation of the core methods between objects allow flexibility in use

* Wrappers and the ability to create seperate Collision objects let the user easily create more complex hitbox interactions and functionality

## Use cases

* Fighting games, espeically ones with a diverse set of moves that have different shapes and interactions

* Boss battles with dynamic and unique attacks

* Parkours and obbies that involve hazards, especially moving ones and ones that change shape or state

## Usage

Usage of the Collision object is fairly simple. Documentation for each module is located at the top in comments. An example script is listed at the end of the Collision module.

### Creating the object

All the default hitbox implementations require the Collision object to be supplied with an OverlapParams object.

```lua
local Collision = require(PathToCollision.Collision.Collision)

local CollisionObject = Collision.new(OverlapParamsOfChoice)
```

### Creating a hitbox

For an object to be a 'Collidable', it must have a Detect method. The default inherented Detect method also requires a Calculate method. All the default implementations of Collidable need a function to run when the hitbox detects something.

Keep in mind that the function will by default not be called if the detection yields no results (table has no values!).

```lua
local PartHitbox = require(PathToCollision.Collision.Collidables.Part) -- Part hitbox implementation

-- Note: Function won't be called if the table was empty!
function hitboxDetectedThings(Parts: {BasePart})
    print(unpack(Parts)) -- Prints parts detected that frame
end

local Hitbox = PartHitbox.new(hitboxDetectedThings, PartOfChoice) -- Creates part hitbox

Collision:Add(Hitbox) -- Adds it to the Collision object

-- Additionally you can also do:

Hitbox:Detect(OverlapParamsOfChoice)

-- to force a detection outside of the Collision object

Collision:Remove(Hitbox) -- Removes it from the Collision object
```

### Running hitboxes

The Collision object does not automatically check it's hitboxes upon creation. You have several options in order to get it to check them.

```lua
Collision:Check() -- Iterates through it's list of hitboxes and calls the Detect method 

Collision:Start() -- Connects the Check method to a RunService event so it runs it every frame

Collision:Stop() -- If there is a registered connection to an event, it disconnects and discards the connection
```
Due to how roblox event ordering works, the first Collision object that calls Start will be the last to run it's hitboxes.

The default hitbox implementations will return what they contain every frame.

### Wrappers

Wrappers modify the functionality of Collidables. They can be stacked on to each other. 

Note that the order in which wrappers are applied may affect their functionality.

```lua
local UpdateWrapper = require(PathToCollision.Collision.Wrappers.Update) -- A wrapper that is supplied with a function 
-- The function runs before the Calculate method logic

function onUpdated()
    print("Hitbox ran!") -- Prints before the hitbox runs
end

local NewCollisionWrapper = require(PathToCollision.Collision.Wrappers.NewCollision) -- A wrapper that reduces the detected collisions to new ones
-- Behaves similarly to the .Touched event

local WrappedCollidable = UpdateWrapper.apply(NewCollisionWrapper.apply(Collidable), onUpdated) -- The result is a double-wrapped collidable!
-- When added to a Collision object, this wrapped collidable will run onUpdated before calculating and only detect new collisions!

```
Documentation for each wrapper is at it's module's head in comments.

## Installation

The latest release always carries a pre-made rbxm file.
