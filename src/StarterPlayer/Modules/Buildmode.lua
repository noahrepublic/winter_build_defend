--# selene: allow(unused_variable)
-- @title: Buildmode.lua
-- @author: noahrepublic, qweekertom
-- @date: 2022-12-11

--> Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Loader, module, and Util
local loader = require(ReplicatedStorage.Loader)

local Fusion = loader.GetUtil("Fusion")

--> Buildmode Definition
local Buildmode = {}
local SETTINGS = {}

--> Variables

local player = Players.LocalPlayer
local playerGui

--> Private Functions

--> Buildmode Functions

function Buildmode.Activate()
	-- Open the buildmode menu
	-- Turn on build grid

	local base = game.Workspace.Plots:FindFirstChild(player.Name)
	base.BuildArea.Texture.Transparency = 0.8 -- Tweens special effects later
end

--> Loader Methods
function Buildmode.Start()
	if not playerGui then
		playerGui = player.PlayerGui
	end

	local enabled = Fusion.State(false)

	local gui = Fusion.New("ScreenGui")({
		Parent = playerGui,

		[Fusion.Children] = Fusion.New("TextButton")({
			Position = UDim2.new(0.15, 0, 0.5, 0),
			Size = UDim2.new(0.05, 0, 0.05, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Text = "Buildmode",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextScaled = true,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,

			[Fusion.OnEvent("Activated")] = function()
				enabled:set(not enabled.Value)
				if enabled:get() then
					Buildmode.Activate()
				end
			end,
		}),
	})
end

return Buildmode
