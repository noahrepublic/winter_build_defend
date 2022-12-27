-- @date: 2022-12-26

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Variables
local Fusion = require(ReplicatedStorage.Loader.Utils.Fusion)

local New = Fusion.New
local Children = Fusion.Children

return function(props)
	return New("Frame")({

		--> Styling
		BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(26, 25, 28),
		BackgroundTransparency = props.BackgroundTransparency or 0,
		BorderColor3 = props.BorderColor3 or Color3.fromRGB(26, 25, 28),
		BorderSizePixel = props.BorderSizePixel or 0,

		Visible = props.Visible or true,

		--> Fitting

		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		Position = props.Position,
		Size = props.Size,

		--> Children

		[Children] = {
			props[Children],
		},

		--> Eventss
	})
end
