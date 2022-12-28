-- @date: 2022-12-27

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Fusion UI
local Fusion = require(ReplicatedStorage.Loader.Utils.Fusion)

local ColorPalette = require(script.Parent.Parent.Parent.ColorPalette)
local PrimaryColor = ColorPalette.Primary
local SecondaryColor = ColorPalette.Secondary
local AccentColor = ColorPalette.Accent
local TextColor = ColorPalette.TextColor

--> Variables
local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

return function(states)
	return {
		New("Frame")({

			--> Styling

			BackgroundColor3 = PrimaryColor,

			--> Fitting

			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1), -- 0.6

			--> Children

			[Children] = {
				New("UICorner")({
					CornerRadius = UDim.new(0.1, 0),
				}),

				New("TextLabel")({
					--> Styling
					BackgroundColor3 = SecondaryColor,
					BackgroundTransparency = 1,
					TextColor3 = AccentColor,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextXAlignment = Enum.TextXAlignment.Center,
					Font = Enum.Font.GothamBold,

					Text = "Concrete",
					TextScaled = true,
					--> Fitting

					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.38, 0.5),
					Size = UDim2.fromScale(0.75, 0.65),
				}),

				New("ImageButton")({
					--> Styling
					BackgroundColor3 = AccentColor,

					--> Fitting
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.87, 0.5),
					Size = UDim2.fromScale(0.2, 0.8),

					[Children] = {
						New("UICorner")({
							CornerRadius = UDim.new(0.1, 0),
						}),
					},

					[OnEvent("Activated")] = function()
						states.buildableSelectVisible:set(not states.buildableSelectVisible:get())
					end,
				}),
			},

			--> Events
		}),
	}
end
