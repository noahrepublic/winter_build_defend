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
local Value = Fusion.Value
local Observer = Fusion.Observer
local Spring = Fusion.Spring

return function(states)
	local buildableSelectGoal = Value(UDim2.fromScale(0.5, 0.5))
	local buildableSelectSpring = Spring(buildableSelectGoal, 15, 1)

	Observer(states.buildableSelectVisible):onChange(function()
		if states.buildableSelectVisible:get() then
			buildableSelectGoal:set(UDim2.fromScale(0.5, 0.5))
		else
			buildableSelectGoal:set(UDim2.fromScale(0.5, 1.25))
		end
	end)
	local element = New("Frame")({

		--> Styling

		BackgroundColor3 = PrimaryColor,

		--> Fitting

		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = buildableSelectSpring,
		Size = UDim2.fromScale(0.3, 0.5),

		--> Children

		[Children] = {
			New("UICorner")({
				CornerRadius = UDim.new(0.03, 0),
			}),
		},

		--> Events
	})

	states.buildableSelectVisible:set(false)

	return element
end
