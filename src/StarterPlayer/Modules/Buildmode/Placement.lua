--# selene: allow(unused_variable)

-- @title: Placement.lua
-- @author: qweekertom
-- @date: 2022-12-11

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Variables
local Placement = {}
local CurrentBlock = "None"

--> Private Functions
function _onUpdate()
	-- runs on renderstep and updates the ghost
end

function _snapVector3(position: Vector3, snap: number): Vector3
	-- snap a vector 3 to the grid snap
end

function _checkPlacementInBounds(position: Vector3, boundSize: Vector3, boundCenter: Vector3)
	-- check if the placement is within the given bounds
end

function _calculatePlacementBounds(buildZone: Part): { BoundSize: Vector3, BoundCenter: Vector3 }
	-- calculate the bounds for the plot
end

--> Module Functions
function Placement.SetBlock(blockName: string)
	CurrentBlock = blockName
end

function Placement.ShowGhost()
	-- show the placement ghost
end

function Placement.HideGhost()
	-- hide the placement ghost
end

function Placement.Place()
	-- send to server the placement
end

function Placement.UpdateGhostAppearance()
	-- update the ghost to the CurrentBlock
end

return Placement
