-- @title: PlacementService.lua
-- @author: noahrepublic
-- @date: 2022-12-11

--> Services

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Loader, Modules, and Util
local loader = require(ReplicatedStorage.Loader)
local BuildableSettings = ReplicatedStorage.Shared.BuildableSettings -- Contains different attributes for each buildable (cost, health)
local CurrencyService = require(script.Parent.LoaderIgnore.Currency)

--> Module Definition
local module = {}
local SETTINGS = {
	MAX_BUILDS = 10,
	HEIGHT_LIMIT = 100,
}

--> Variables

local Remotes = ReplicatedStorage.Remotes
local BuildablesFolder = ReplicatedStorage.Resources.Buildables

local PlacementEvent = Remotes.Placement
local PlotsFolder = game.Workspace.Plots
--> Private Functions

local function getBuildFromName(buildName: string)
	local build = BuildablesFolder:FindFirstChild(buildName)
	if build then
		return build
	end
end

local function buildRequest(player: Player, buildData: table)
	local buildType = buildData.Type
	local location = buildData.Location
	local rotation = buildData.Rotation

	local base = PlotsFolder:FindFirstChild(player.Name)

	if #base.Builds:GetChildren() >= SETTINGS.MAX_BUILDS then
		return
	end

	if location.Y >= SETTINGS.HEIGHT_LIMIT then
		return
	end

	if not CurrencyService.Purchase(player, require(BuildableSettings:FindFirstAncestor(buildType)).Cost, "Coins") then
		print("Not enough coins")
		return
	end

	local build = getBuildFromName(buildType)
	if build then
		local newBuild = build:Clone()
		newBuild.CFrame = location * CFrame.Angles(0, rotation, 0)
		newBuild.Anchored = true
		newBuild.Parent = base.Builds
		CollectionService:AddTag(newBuild, "Buildable")
	end
end

--> Module Functions

--> Loader Methods
function module.Start()
	-- Implement Currency Service
	PlacementEvent.OnServerEvent:Connect(buildRequest)
end

return module
