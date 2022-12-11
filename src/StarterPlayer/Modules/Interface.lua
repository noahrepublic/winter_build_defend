--# selene: allow(unused_variable)
-- @title: Interface.lua
-- @author: noahrepublic, qweekertom
-- @date: 2022-12-10

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Loader, Modules, and Util
local loader = require(ReplicatedStorage.Loader)

local Fusion = loader.Get("Fusion")

--> Module Definition
local module = {}
local SETTINGS = {}

--> Variables

--> Private Functions

--> Module Functions

--> Loader Methods
function module.Start() end

return module
