--# selene: allow(unused_variable)

-- @title: Buildmode.lua
-- @author: noahrepublic, qweekertom
-- @date: 2022-12-11

--> Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

--> Loader, module, and Util
local loader = require(ReplicatedStorage.Loader)
local Fusion = loader.GetUtil("Fusion")
local Children = Fusion.Children
local Computed = Fusion.Computed

--> Buildmode Definition
local Buildmode = {}
local SETTINGS = {
	TweenInfo = TweenInfo.new(),
}

--> Variables

local player = Players.LocalPlayer
local playerGui

--> Private Functions
function getMyPlot()
	--[[for _, plot in workspace.Plots:GetChildren() do
		if plot:GetAttribute("Owner") == Players.LocalPlayer.UserId then
			return plot
		end
	end]]
	return game.Workspace.Plots:FindFirstChild(player.Name)
end

function setGridTransparency(transparency: number)
	local base = getMyPlot()
	if base == nil then
		loader.log.Warn(script, "Failed to find a plot to build on!")
		return
	end

	local texture = base.BuildArea.Texture
	TweenService:Create(texture, SETTINGS.TweenInfo, { ["Transparency"] = transparency }):Play()
end

function generateFusionInterface()
	local enabled = Fusion.State(false)
	local currentBlock = Fusion.State("None")

	Computed(function()
		print(currentBlock:get())
	end)

	local gui = Fusion.New("ScreenGui")({
		Parent = playerGui,
		Name = "RootGui",

		[Children] = {
			Fusion.New("TextButton")({
				Position = UDim2.new(0, 5, 0.5, 0),
				Size = UDim2.new(0.05, 0, 0.05, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Text = "BUILD",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				Font = Enum.Font.FredokaOne,
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,

				BackgroundColor3 = Computed(function()
					if enabled:get() then
						return Color3.fromRGB(172, 172, 172)
					else
						return Color3.fromRGB(255, 255, 255)
					end
				end),

				[Fusion.OnEvent("Activated")] = function()
					local currentEnabledState = enabled:get()
					if currentEnabledState == true then
						Buildmode.Deactivate()
					else
						Buildmode.Activate()
					end

					enabled:set(not currentEnabledState)
				end,

				[Children] = {
					Fusion.New("UICorner")({
						CornerRadius = UDim.new(0, 10),
					}),
				},
			}),

			Fusion.New("Frame")({
				Position = UDim2.new(0.5, 0, 1, -5),
				Size = UDim2.new(0.6, 0, 0.15, 0),
				AnchorPoint = Vector2.new(0.5, 1),
				Name = "BuildItemsPanel",
				Visible = Computed(function()
					return enabled:get()
				end),

				[Children] = {
					Fusion.New("UICorner")({
						CornerRadius = UDim.new(0, 10),
					}),

					Fusion.New("ScrollingFrame")({
						Name = "Content",
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						ScrollBarThickness = 6,
						ScrollingDirection = Enum.ScrollingDirection.X,
						AutomaticSize = Enum.AutomaticSize.X,
						CanvasSize = UDim2.new(0, 0, 0, 0),

						[Children] = {
							Fusion.New("UIListLayout")({
								FillDirection = Enum.FillDirection.Horizontal,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								Padding = UDim.new(0, 5),
							}),
							Fusion.New("UIPadding")({
								PaddingLeft = UDim.new(0, 5),
								PaddingTop = UDim.new(0, 5),
								PaddingBottom = UDim.new(0, 5),
								PaddingRight = UDim.new(0, 5),
							}),
							Fusion.New("TextButton")({
								Name = "Concrete",
								Size = UDim2.new(1, 0, 1, 0),
								SizeConstraint = Enum.SizeConstraint.RelativeYY,
								Text = "Concrete",
								BackgroundTransparency = 0,
								BackgroundColor3 = Color3.fromRGB(210, 210, 210),
								AutoButtonColor = true,

								[Fusion.OnEvent("Activated")] = function()
									currentBlock:set("Concrete")
								end,
							}),
						},
					}),
				},
			}),
		},
	})
end

--> Buildmode Functions

function Buildmode.Activate()
	-- Open the buildmode menu
	-- Turn on build grid
	setGridTransparency(0.5)
end

function Buildmode.Deactivate()
	setGridTransparency(1)
end

--> Loader Methods
function Buildmode.Start()
	if not playerGui then
		playerGui = player.PlayerGui
	end

	generateFusionInterface()
end

return Buildmode
