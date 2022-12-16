--[[
	Handles player's data and information
]]

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables --

local DataTemplate = require(script.DataTemplate)
local ProfileService = require(script.ProfileService)
local Loader = require(ReplicatedStorage.Loader)

local Signal = Loader.GetUtil("Signal")

local DataStore = ProfileService.GetProfileStore("DevelopmentData", DataTemplate)

local Player = {}
Player.__index = Player

-- Functions --

--Private:

local function init(self)
	local player = self.Player

	if self.Loaded then
		return
	end

	self.Loaded = true
	self.Maid = Loader.Maid()
	self.Maid:GiveTask(self.onLoad)

	do
		local profile = DataStore:LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")

		if profile == nil then
			player:Kick()
			return
		end

		profile:AddUserId(player.UserId)
		profile:Reconcile() -- rebuild

		self.Maid:GiveTask(profile:ListenToRelease(function()
			player:Kick()
		end))

		-- player left
		if not player:IsDescendantOf(Players) then
			profile:Release()
			return
		end

		self.Data = profile.Data
		self.Profile = profile
		self.onLoad:Fire()
	end
end

--Public:
function Player.new(plr: Player)
	local player_class = setmetatable({}, Player)
	player_class.Player = plr
	player_class.Attributes = {}
	player_class.Loaded = false
	player_class.onLoad = Signal.new()
	return player_class
end

function Player:Load()
	init(self)
end

function Player:Disconnect()
	self.Maid:DoCleaning() -- Disconnect everything
	self.Profile:Release()
	self.Player:Kick() -- kick incase it was a custom :Disconnect() call
end

function Player:SetAttribute(name: string, value: any): any
	self.Attributes[name] = value
	return self.Attributes[name]
end

function Player:GetAttribute(name: string)
	return self.Attributes[name]
end

function Player:RemoveAttribute(name: string)
	self.Attributes[name] = nil
end

return Player
