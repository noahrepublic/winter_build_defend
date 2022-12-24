-- @title: Buildable.lua
-- @author: noahrepublic
-- @date: 2022-12-11

--> Services
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local loader = require(ReplicatedStorage.Loader)

--> Settings
local SETTINGS = {
	Tag = "Buildable",
}

--> Define Component
local Buildable = { Tag = SETTINGS.Tag }
Buildable.__index = Buildable

--> Private Variables

--> Constructor
function Buildable.new(instance: Instance)
	local self = setmetatable({
		["_initialized"] = false,
		["Instance"] = instance,
		["Maid"] = loader.Maid(),
	}, Buildable)

	print("New Buildable", instance)
	self:_init()
	return self
end

function Buildable:_init()
	if self._initialized == true then
		return
	end
	self._initialized = true

	self.Instance.Transparency = 0

	if self.Instance:GetAttribute("Attack") == nil then
		self.Instance:SetAttribute("Attack", false)
	end

	self.Maid:GiveTask(self.Instance:GetAttributeChangedSignal("Attack"):Connect(function()
		CollectionService:RemoveTag(self.Instance, "Buildable")
	end))
end

function Buildable:Clean()
	print("Cleaning Buildable")
	self.Maid:DoCleaning()

	self.Instance:GetAttribute("Health")
	local oldHealth = self.Instance:GetAttribute("Health")
	self.Instance:SetAttribute("Health", oldHealth - 1)
	local health = oldHealth - 1

	if health <= 0 then
		self.Instance:Destroy()
		return
	end

	self.Instance.Transparency = 0.5

	self.Instance:SetAttribute("Attack", false)
	CollectionService:AddTag(self.Instance, "Buildable")
end

return Buildable
