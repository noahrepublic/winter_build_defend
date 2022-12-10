--[[
	Stores custom Player Objects from the "Player" class
]]

local Player = require(script:FindFirstChild("Player"))

local Players = {} -- Stores players

local PlayerRegistry = {}
PlayerRegistry.__index = PlayerRegistry
-- Functions --

function PlayerRegistry.AddPlayer(plr: Player)
	local player_class = Player.new(plr)
	Players[plr] = player_class
	return player_class
end

function PlayerRegistry.GetPlayer(plr: Player)
	return Players[plr]
end

function PlayerRegistry.RemovePlayer(plr: Player)
	local player_class = PlayerRegistry.GetPlayer(plr)
	assert(player_class ~= nil, "Passed player value is nil!")
	Players[plr] = nil
	player_class:Disconnect()
end

PlayerRegistry.Disconnect = PlayerRegistry.RemovePlayer

return PlayerRegistry
