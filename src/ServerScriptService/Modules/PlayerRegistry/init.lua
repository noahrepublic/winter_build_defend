-- @title: PlayerRegistry.lua
-- @author: noahrepublic
-- @date: 2022-12-10

--> Services
--local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Loader, Modules, and Util
--local loader = require(ReplicatedStorage.Loader)
local Player = require(script.Player)
require(script.Parent.LoaderIgnore.Currency)

--> Module Definition
local PlayerRegistry = {}
PlayerRegistry.__index = PlayerRegistry

--> Variables

local Players = {}

--> Private Functions

--> Module Functions

function PlayerRegistry.AddPlayer(plr: Player)
	assert(plr ~= nil, "Passed player value is nil!")
	if Players[plr] and Players[plr].Loaded then
		return Players[plr]
	end

	local player_class = Player.new(plr)
	Players[plr] = player_class
	return player_class
end

function PlayerRegistry.GetPlayer(plr: Player)
	assert(plr ~= nil, "Passed player value is nil!")

	return Players[plr]
end

function PlayerRegistry.RemovePlayer(plr: Player)
	assert(plr ~= nil, "Passed player value is nil!")

	local player_class = PlayerRegistry.GetPlayer(plr)
	Players[plr] = nil
	player_class:Disconnect()
end

PlayerRegistry.Disconnect = PlayerRegistry.RemovePlayer

--> Loader Methods

return PlayerRegistry
