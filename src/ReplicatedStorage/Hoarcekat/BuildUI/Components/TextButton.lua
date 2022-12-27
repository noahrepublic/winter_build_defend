-- @date: 2022-12-26

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Variables
local Fusion = require(ReplicatedStorage.Loader.Utils.Fusion)

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

return function(props)
	return New("TextButton")({
		--> Styling
		Text = props.Text,
		TextScaled = props.TextScaled or true,
		TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255),
		BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(26, 25, 28),

		--> Fitting
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		Position = props.Position or UDim2.fromScale(0.5, 0.5),
		Size = props.Size,

		--> Children
		[Children] = {
			props[Children],
		},

		--> Events
		[OnEvent("Activated")] = props.OnActivated,
	})
end
