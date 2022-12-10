-- @title: Temp.lua
-- @author: noahrepublic
-- @date: 2022-12-10

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Settings
local SETTINGS = {
	Tag = "Temp",
}

--> Define Component
local Component = { Tag = SETTINGS.Tag }
Component.__index = Component

--> Private Variables

--> Constructor
function Component.new(instance: Instance)
	local self = setmetatable({
		["_initialized"] = false,
		["Instance"] = instance,
	}, Component)

	self:_init()
	return self
end

function Component:_init()
	if self._initialized == true then
		return
	end
	self._initialized = true
end

return Component
