-- @title: Base.lua
-- @author: noahrepublic
-- @date: 2022-12-10

--> Services
local Players = game:GetService("Players")
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

	local base = self.Instance
	local player = Players:GetPlayerByUserId(self.Owner)

	-- Claim ownership

	base.Name = player.Name

	local baseIcon = base.PlayerIcon.BillboardGui.Icon
	local playerBust =
		Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)

	baseIcon.Image = playerBust

	local buildFolder = Instance.new("Folder")
	buildFolder.Name = "Builds"
	buildFolder.Parent = base

	player.RespawnLocation = base.Spawn
	player:LoadCharacter()
end

function Base:Clean()
	local base = self.Instance

	base.Name = "Plot"
	local baseIcon = base.PlayerIcon.BillboardGui.Icon
	baseIcon.Image = "rbxassetid://9569335969" -- Default

	base.Builds:Destroy()

	base:SetAttribute("Owner", nil)
end

return Base
