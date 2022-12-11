-- @title: PlacementService.lua
-- @author: noahrepublic
-- @date: 2022-12-11

--> Services

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Loader, Modules, and Util
local loader = require(ReplicatedStorage.Loader)

--> Module Definition
local module = {}
local SETTINGS = {}

--> Variables

local Remotes = ReplicatedStorage.Remotes

local PlacementEvent = Remotes.Placement

--> Private Functions

--> Module Functions

--> Loader Methods
function module.Start() end

return module
