-- @title: Enemy.lua
-- @author: noahrepublic
-- @date: 2022-12-23

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Settings
local SETTINGS = {
	Tag = "Enemy",
}

--> Define Component
local Component = { Tag = SETTINGS.Tag }
Component.__index = Component

--> Private Variables

local loader = require(ReplicatedStorage.Loader)
local Metronome = loader.GetUtil("Metronome")

local NPC = require(ReplicatedStorage.Shared.NPC)

--> Constructor
function Component.new(instance: Instance)
	local self = setmetatable({
		["_initialized"] = false,
		["Instance"] = instance,
		["Controller"] = NPC.new(instance),
	}, Component)

	self:_init()
	return self
end

function Component:_init()
	if self._initialized == true then
		return
	end
	self._initialized = true

	local taskId = Metronome.CreateTask(0, function()
		self.Controller:Update()
	end)

	self.Controller.Destroy = function()
		Metronome.RemoveTask(taskId)
	end
end

function Component:Clean()
	self.Controller:Destroy()
end

return Component
