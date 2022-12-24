-- @title: EnemyHandler.lua
-- @author: noahrepublic
-- @date: 2022-12-22

-- This will handle the spawning cycle of enemies while another module will handle NPC functions.

--> Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--> Loader, Modules, and Util
local loader = require(ReplicatedStorage.Loader)

local NPC = require(loader.Shared.NPC)

--> Module Definition
local EnemyHandler = {}
local SETTINGS = {
	DEBUG = false,
	DEFAULT_WAVE_SIZE = 3,
	DEFAULT_WAVE_DELAY = 15,
	MAX_SPAWNED = 10,
}

--> Variables

local Remotes = ReplicatedStorage.Remotes
local EnemyNetworker = Remotes.Enemy

local timeElasped = 0

--> Private Functions

local function DebugPrint(...)
	if SETTINGS.DEBUG then
		print(...)
	end
end

local function getPlot(player)
	return game.Workspace.Plots:FindFirstChild(player.Name)
end

--> Module Functions

function EnemyHandler:Wave(amount: number)
	DebugPrint("Wave of " .. amount .. " enemies!")
	for _, player in pairs(Players:GetPlayers()) do
		if #getPlot(player).Enemies:GetChildren() >= SETTINGS.MAX_SPAWNED then
			DebugPrint("Player " .. player.Name .. " has too many enemies!")
			return
		end

		local npcs = {}
		for _ = 1, amount do
			local playerPlot = getPlot(player)
			local spawnIgloos = playerPlot.Igloos:GetChildren()
			local selectedIgloo = spawnIgloos[math.random(1, #spawnIgloos)]
			local spawnPoint = selectedIgloo.Spawn.Position
			table.insert(npcs, NPC.new(player, "Dummy", spawnPoint))
		end
		EnemyNetworker:FireClient(player, npcs)
	end
end

function EnemyHandler.Start()
	RunService.Heartbeat:Connect(function(step)
		timeElasped += step
		-- This will be the main loop for the enemy handler.
		if timeElasped >= SETTINGS.DEFAULT_WAVE_DELAY then
			timeElasped = step
			DebugPrint("Wave!")
			EnemyHandler:Wave(SETTINGS.DEFAULT_WAVE_SIZE)
		end
	end)
end

return EnemyHandler
