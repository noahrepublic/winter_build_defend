-- @title: CurrencyService.lua
-- @author: noahrepublic
-- @date: 2022-12-16

--> Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Loader, Modules, and Util
local loader = require(ReplicatedStorage.Loader)
local PlayerRegistry

--> Module Definition
local Currency = {}
local SETTINGS = {
	MAIN_CURRENCY = "Coins",
	SECONDARY_CURRENCY = "CandyCanes",
}

--> Variables

--> Private Functions

local function onPlayer(player)
	if not PlayerRegistry then
		PlayerRegistry = loader.Get("PlayerRegistry")
	end

	local playerData = PlayerRegistry.AddPlayer(player).Data

	player:SetAttribute(SETTINGS.MAIN_CURRENCY, playerData[SETTINGS.MAIN_CURRENCY])
	player:SetAttribute(SETTINGS.SECONDARY_CURRENCY, playerData[SETTINGS.SECONDARY_CURRENCY])
end

--> Module Functions

function Currency.Add(player: Player, amount: number, currencyType: string)
	local playerData = PlayerRegistry.GetPlayer(player).Data

	playerData[currencyType] += amount
	player:SetAttribute(currencyType, playerData[currencyType])
end

function Currency.Remove(player: Player, amount: number, currencyType: string)
	local playerData = PlayerRegistry.GetPlayer(player).Data

	playerData[currencyType] -= amount
	player:SetAttribute(currencyType, playerData[currencyType])
end

function Currency.Get(player: Player, currency: string)
	return player:GetAttribute(currency) -- in theory this is linked to the player's data
end

function Currency.Purchase(player: Player, cost: number, currencyType: string)
	local playerData = PlayerRegistry.GetPlayer(player).Data

	if playerData[currencyType] < cost then
		return false
	end

	playerData[currencyType] -= cost
	player:SetAttribute(currencyType, playerData[currencyType])
	return true
end

--> Loader Methods

Players.PlayerAdded:Connect(onPlayer)
Players.PlayerRemoving:Connect(function(player)
	PlayerRegistry.RemovePlayer(player)
end)

for _, player in pairs(Players:GetPlayers()) do
	onPlayer(player)
end

return Currency
