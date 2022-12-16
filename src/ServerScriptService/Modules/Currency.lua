-- @title: CurrencyService.lua
-- @author: noahrepublic
-- @date: 2022-12-16

--> Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Loader, Modules, and Util
local loader = require(ReplicatedStorage.Loader)
local PlayerRegistry
print(PlayerRegistry)

--> Module Definition
local Currency = {}
local SETTINGS = {
	MAIN_CURRENCY = "Coins",
	SECONDARY_CURRENCY = "CandyCanes",
}

--> Variables

--> Private Functions

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

function Currency.Start()
	PlayerRegistry = loader.Get("PlayerRegistry")
	Players.PlayerAdded:Connect(function(player)
		local playerClass = PlayerRegistry.AddPlayer(player)
		playerClass.onLoad:Once(function()
			local playerData = playerClass.Data
			player:SetAttribute(SETTINGS.MAIN_CURRENCY, playerData[SETTINGS.MAIN_CURRENCY])
			player:SetAttribute(SETTINGS.SECONDARY_CURRENCY, playerData[SETTINGS.SECONDARY_CURRENCY])
		end)
	end)
end

return Currency
