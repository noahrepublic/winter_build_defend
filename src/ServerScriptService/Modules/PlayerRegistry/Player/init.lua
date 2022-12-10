--[[
	Handles player's data and information
]]

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables --

local Data_Template = require(script.DataTemplate)
local ProfileService = require(script.ProfileService)
local Loader = require(ReplicatedStorage.Loader)

local DataStore = ProfileService.GetProfileStore("DevelopmentData", Data_Template)

local Player = {}
Player.__index = Player

-- Functions --

--Private:

local function init(self)
	local player = self.Player

	self.Maid = Loader.Maid()

	do
		local profile = DataStore:LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")

		if profile == nil then
			player:Kick()
			return
		end

		profile:AddUserId(player.UserId)
		profile:Reconcile() -- rebuild

		self._soap_bar:Add(profile:ListenToRelease(function()
			player:Kick()
		end))

		-- player left
		if not player:IsDescendantOf(Players) then
			profile:Release()
			return
		end

		self.Data = profile.Data
		self.Profile = profile
	end
end

--Public:
function Player.new(plr: Player)
	local player_class = setmetatable({}, Player)
	player_class.Player = plr
	player_class.Attributes = {}
	init(player_class)
	return player_class
end

function Player:Disconnect()
	self._soap_bar:Scrub() -- Disconnect everything
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
