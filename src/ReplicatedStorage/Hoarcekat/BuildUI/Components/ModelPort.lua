-- @date: 2022-12-26

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Fusion UI
local Fusion = require(ReplicatedStorage.Loader.Utils.Fusion)

--> Variables

local Metronome = require(ReplicatedStorage.Loader.Utils.Metronome)
Metronome.Start()

local New = Fusion.New
local Children = Fusion.Children

return function(props)
	local camera = New("Camera")({
		CameraSubject = props.Model,
		CFrame = CFrame.new(0, -0.5, 5),
		FieldOfView = props.FieldOfView or 70,
		Focus = props.Focus or CFrame.new(0, 0, 0),
	})

	return New("ViewportFrame")({

		--> Styling

		BackgroundTransparency = props.BackgroundTransparency or 1,
		Size = props.Size or UDim2.fromScale(1, 1),

		ImageColor3 = props.ImageColor or Color3.fromRGB(255, 255, 255),
		CurrentCamera = camera,

		--> Fitting

		--> Children

		[Children] = {
			camera,
			props.Model,
		},

		--> Events
	})
end
