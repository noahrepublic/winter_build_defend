-- @title: Base.lua
-- @author: noahrepublic
-- @date: 2022-12-10

--> Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Settings
local SETTINGS = {
	Tag = "Base",
}

--> Define Base
local Base = { Tag = SETTINGS.Tag }
Base.__index = Base

--> Private Variables

--> Constructor
function Base.new(instance: Instance)
	local self = setmetatable({
		["_initialized"] = false,
		["Instance"] = instance,
		["Base"] = instance,
		["Owner"] = instance:GetAttribute("Owner"),
	}, Base)

	self:_init()
	return self
end

function Base:_init()
	if self._initialized == true then
		return
	end
	self._initialized = true

	local base = self.Base
	local player = Players:GetPlayerByUserId(self.Owner)

	-- Claim ownership

	local baseIcon = base.PlayerIcon.BillboardGui.Icon
	local playerBust =
		Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)

	baseIcon.Image = playerBust

	player.RespawnLocation = base.Spawn
	player:LoadCharacter()
end

function Base:Clean()
	local base = self.Base

	local baseIcon = base.PlayerIcon.BillboardGui.Icon
	baseIcon.Image = "rbxassetid://9569335969" -- Default

	base:SetAttribute("Owner", nil)
end

return Base
