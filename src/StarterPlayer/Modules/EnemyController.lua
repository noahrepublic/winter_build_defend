-- @title: EnemyController.lua
-- @author: noahrepublic
-- @date: 2022-12-23

--> Services
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Loader, Modules, and Util
--local loader = require(ReplicatedStorage.Loader)

--> Module Definition
local EnemyController = {}
local SETTINGS = {
	DEBUG = false,
}

--> Variables

local Remotes = ReplicatedStorage.Remotes
local Enemy = Remotes.Enemy

--> Private Functions

local function DebugPrint(...)
	if SETTINGS.DEBUG then
		print(...)
	end
end

local function newWave(NPCs)
	DebugPrint("New wave of enemies spawned.")
	for _, npc in pairs(NPCs) do
		CollectionService:AddTag(npc, "Enemy")
	end
end

--> Module Functions

--> Loader Methods
function EnemyController.Start()
	Enemy.OnClientEvent:Connect(newWave)
	-- FUTURE: JUST FIRE THE EVENT BACK TO DEAL DAMAGE TO A BUILDABLE
end

return EnemyController
