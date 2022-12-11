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
local SETTINGS = {
	MaxBuilds = 10,
	HeightLimit = 100,
}

--> Variables

local Remotes = ReplicatedStorage.Remotes
local BuildablesFolder = ReplicatedStorage.Resources.Buildables

local PlacementEvent = Remotes.Placement

--> Private Functions

local function getBuildFromName(buildName: string)
	local build = BuildablesFolder:FindFirstChild(buildName)
	if build then
		return build
	end
end

local function buildRequest(player: Player, buildData: table)
	local buildType = buildData.Type
	local position = buildData.Position
	local rotation = buildData.Rotation

	local base = game.Workspace:FindFirstChild(player.Name)

	if #base.Builds:GetChildren() >= SETTINGS.MaxBuilds then
		return
	end

	if position.Y >= SETTINGS.HeightLimit then
		return
	end

	local build = getBuildFromName(buildType)
	if build then
		local newBuild = build:Clone()
		newBuild.CFrame = CFrame.new(position) * CFrame.Angles(0, rotation, 0)
		newBuild.Parent = base.Builds
		CollectionService:AddTag(newBuild, "Build")
	end
end

--> Module Functions

--> Loader Methods
function module.Start()
	-- Incorroporate Currency Service

	PlacementEvent.OnServerEvent:Connect(buildRequest)
end

return module
