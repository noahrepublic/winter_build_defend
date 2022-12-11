--[[
    What do I want done here?
        - Base claiming
        - Update base settings (Player Icon, spawn)
]]

-- @title: Tycoon.lua
-- @author: noahrepublic
-- @date: 2022-12-10

--> Services

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
--local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Loader, Modules, and Util
--local loader = require(ReplicatedStorage.Loader)

--local PlayerRegistry = loader.Get("PlayerRegistry")

--> Module Definition
local BaseOwnership = {}
local InitializedPlayers = {}
--local SETTINGS = {}

--> Variables

local plotFolder

local ownedPlots = {}

--> Private Functions
function initializePlots()
	local plotBase = ServerStorage.Resources.BasePlot
	for _, plotLocation in workspace.Plots:GetChildren() do
		local clone = plotBase:Clone()
		clone:PivotTo(plotLocation.CFrame)
		clone.Parent = workspace.Plots
		plotLocation:Destroy()
	end
	plotFolder = game.Workspace.Plots:GetChildren()
end

function playerAdded(player: Player)
	--local player_class = PlayerRegistry.GetPlayer(player)
	InitializedPlayers[player] = true

	local selectedPlot = plotFolder[1]
	table.remove(plotFolder, 1)

	selectedPlot:SetAttribute("Owner", player.UserId)
	ownedPlots[player.UserId] = selectedPlot
	CollectionService:AddTag(selectedPlot, "Base")
end

--> Module Functions

--> Loader Methods
function BaseOwnership.Start()
	initializePlots()

	Players.PlayerAdded:Connect(playerAdded)
	Players.PlayerRemoving:Connect(function(player)
		local plot = ownedPlots[player.UserId]

		CollectionService:RemoveTag(plot, "Base")
		ownedPlots[player.UserId] = nil
	end)

	for _, player in Players:GetPlayers() do
		playerAdded(player)
	end
end

return BaseOwnership
