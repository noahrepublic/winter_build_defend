-- @date: 2022-12-27

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Fusion UI
local Fusion = require(ReplicatedStorage.Loader.Utils.Fusion)

local ColorPalette = require(script.Parent.Parent.ColorPalette)
local PrimaryColor = ColorPalette.Primary
local SecondaryColor = ColorPalette.Secondary
local AccentColor = ColorPalette.Accent
local TextColor = ColorPalette.TextColor

--> Variables
local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Computed = Fusion.Computed
local Observer = Fusion.Observer

local Spring = Fusion.Spring

return function(states)
	--> Spring States

	local IconState = Value("rbxassetid://6031090994")

	local buttonGoal = Value(UDim2.fromScale(0.02, 0.5))
	local buttonSpring = Spring(buttonGoal, 10, 1)

	local mainMenuGoal = Value(UDim2.fromScale(-1, 0.5))
	local mainMenuSpring = Spring(mainMenuGoal, 15, 1)

	--> Observers
	Observer(states.mainFrameActive):onChange(function()
		if states.mainFrameActive:get() then
			mainMenuGoal:set(UDim2.fromScale(0.055, 0.5))
			buttonGoal:set(UDim2.fromScale(0.125, 0.5))
			IconState:set("rbxassetid://6031091002")
		else
			mainMenuGoal:set(UDim2.fromScale(-1, 0.5))
			buttonGoal:set(UDim2.fromScale(0.02, 0.5))
			IconState:set("rbxassetid://6031090994")
		end
	end)

	local element = {
		New("ImageButton")({
			--> Styling
			Image = Computed(function()
				return IconState:get()
			end),
			Transparency = 0,

			ImageColor3 = TextColor,
			ScaleType = Enum.ScaleType.Crop,

			--> Positioning

			Position = buttonSpring,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromScale(0.025, 0.06),

			[Children] = {
				New("UICorner")({
					CornerRadius = UDim.new(0.1, 0),
				}),
				New("UIStroke")({
					Color = SecondaryColor,
					Thickness = 1,
				}),
			},

			[OnEvent("Activated")] = function()
				states.mainFrameActive:set(not states.mainFrameActive:get())
			end,
		}),

		New("Frame")({
			Position = mainMenuSpring,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromScale(0.1, 0.06),

			[Children] = {
				New("UICorner")({
					CornerRadius = UDim.new(0.05, 0),
				}),

				New("UIStroke")({
					Color = SecondaryColor,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Thickness = 3,
				}),

				-- Elements

				[Children] = {
					require(script.BuildableSelectOpener)(states),
				},
			},
		}),
	}

	states.mainFrameActive:set(false)

	return element
end
