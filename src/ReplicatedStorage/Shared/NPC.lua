-- @title: NPC.lua
-- @author: noahrepublic
-- @date: 2022-12-23

--> Services
local CollectionService = game:GetService("CollectionService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

--> Loader, Modules, and Util
local loader = require(ReplicatedStorage.Loader)

local CurrencyService
if RunService:IsServer() then
	CurrencyService = require(ServerScriptService.Modules.LoaderIgnore.Currency)
end
local PlayerRegistry

--> Module Definition
local NPC = {}
NPC.__index = NPC
local SETTINGS = {
	DEBUG = false,
	COST_MULTIPLIER = 23.5,
	PATH_SETTINGS = {
		CanJump = true,
		Costs = {},
	},
}

--> Variables

local Enemies = ReplicatedStorage.Resources.Enemies

local BuildablesData = loader.Shared.BuildablesData
local EnemiesData = loader.Shared.EnemiesData

for _, buildable in pairs(BuildablesData:GetChildren()) do
	SETTINGS.PATH_SETTINGS.Costs[buildable.Name] = require(BuildablesData:FindFirstChild(buildable.Name)).Health
		or 1 * SETTINGS.COST_MULTIPLIER
end

--> Private Functions

local function getPlot(player)
	return game.Workspace.Plots:FindFirstChild(player.Name)
end

local function DebugPrint(...)
	if SETTINGS.DEBUG then
		print(...)
	end
end
--> Module Functions

if RunService:IsServer() then
	function NPC.new(targetPlayer: Player, npcType: string, startPos: Vector3)
		local model = Enemies:FindFirstChild(npcType):Clone()
		model:SetPrimaryPartCFrame(CFrame.new(startPos))

		local enemyData = require(EnemiesData:FindFirstChild(model.Name))
		model.Humanoid.MaxHealth = enemyData.Health
		model.Humanoid.Health = enemyData.Health
		model.Parent = getPlot(targetPlayer).Enemies

		model.PrimaryPart:SetNetworkOwner(targetPlayer)

		PlayerRegistry = loader.Get("PlayerRegistry")
		local Player = PlayerRegistry.GetPlayer(targetPlayer)
		Player.Maid:GiveTask(model)

		local staleDiedConnection
		staleDiedConnection = model.Humanoid.Died:Connect(function()
			staleDiedConnection:Disconnect()
			CollectionService:RemoveTag(model, "Enemy")
			model:Destroy()

			CurrencyService.Add(targetPlayer, enemyData.Coins or 0, "Coins")
			CurrencyService.Add(targetPlayer, enemyData.CandyCanes or 0, "CandyCanes")
		end)

		return model
	end
else
	function NPC.new(enemyModel)
		local self = setmetatable({}, NPC)
		self.currentPath = nil
		self.Model = enemyModel
		self.Walking = false
		self.Path = PathfindingService:CreatePath(SETTINGS.PATH_SETTINGS)

		return self
	end

	function NPC:Pathfind(endPos: Vector3)
		self.Path:ComputeAsync(self.Model.PrimaryPart.Position, endPos)
		if self.Path.Status ~= Enum.PathStatus.Success then
			DebugPrint("Pathfinding failed!", self.Path.Status)
			return
		end
		self.currentPath = self.Path:GetWaypoints()

		if self.Path.Status == Enum.PathStatus.Success and self.Walking == false then
			self:Walk()
			self.Walking = true
		end
	end

	function NPC:Walk()
		local waypoints = self.currentPath
		table.remove(waypoints, 1)
		if #waypoints == 0 then
			self.Walking = false
			return
		end
		if self.Model.Humanoid == nil or self.Model.Humanoid:GetState() == Enum.HumanoidStateType.Dead then
			return
		end
		self.Model.Humanoid:MoveTo(waypoints[1].Position)

		local moveToConnection
		moveToConnection = self.Model.Humanoid.MoveToFinished:Connect(function()
			moveToConnection:Disconnect()
			table.remove(waypoints, 1)
			self:Walk()
		end)
	end

	function NPC:Update()
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = { CollectionService:GetTagged("Buildable") }
		raycastParams.FilterType = Enum.RaycastFilterType.Whitelist

		local raycast =
			game.Workspace:Raycast(self.Model.Head.Position, self.Model.Head.CFrame.LookVector * 5, raycastParams)

		self:Pathfind(Players.LocalPlayer.Character.PrimaryPart.Position)

		if raycast then
			CollectionService:RemoveTag(raycast.Instance, "Buildable")
		end
	end
end

return NPC
