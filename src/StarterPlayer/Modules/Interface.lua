--# selene: allow(unused_variable)

-- @title: Interface.lua
-- @author: qweekertom
-- @date: 2022-12-09

-- placeholder to keep the folder alive

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Loader, Modules, and Util
local loader = require(ReplicatedStorage.Loader)

--> Module Definition
local module = {}
local SETTINGS = {}

--> Variables

--> Private Functions

--> Module Functions

--> Loader Methods
function module.Start()
	print("Hello world!")
end

return module
