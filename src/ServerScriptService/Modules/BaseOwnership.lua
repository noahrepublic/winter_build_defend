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
--local SETTINGS = {}

--> Variables

local plotFolder = game.Workspace.Plots:GetChildren()

local ownedPlots = {}

--> Private Functions

--> Module Functions
function initializePlots()
	local plotBase = ServerStorage.Resources.BasePlot
	for _, plotLocation in workspace.Plots:GetChildren() do
		local clone = plotBase:Clone()
		clone:PivotTo(plotLocation.CFrame)
		clone.Parent = workspace.Plots
		plotLocation:Destroy()
	end
end

--> Loader Methods
function module.Start()
	Players.PlayerAdded:Connect(function(player)
		--local player_class = PlayerRegistry.GetPlayer(player)

		local selectedPlot = plotFolder[1]
		table.remove(plotFolder, 1)

		selectedPlot:SetAttribute("Owner", player.UserId)
		ownedPlots[player.UserId] = selectedPlot
		CollectionService:AddTag(selectedPlot, "Base")
	end)

	Players.PlayerRemoving:Connect(function(player)
		local plot = ownedPlots[player.UserId]

		CollectionService:RemoveTag(plot, "Base")
		ownedPlots[player.UserId] = nil
	end)
end

return BaseOwnership
