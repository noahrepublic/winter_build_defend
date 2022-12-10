--[[
    Runs client sided modules on start
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local loader = require(ReplicatedStorage.Loader)
local Component = require(ReplicatedStorage.Loader.Utils.Component)
local Modules = script.Parent.Modules

loader.Shared = game.ReplicatedStorage.Shared
loader.InitModules(Modules:GetChildren())
loader.Start()

Component.Load(Modules.Component)
loader.log.Print(script, "Client Loader Complete")
