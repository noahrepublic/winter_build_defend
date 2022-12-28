local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Loader.Utils.Fusion)

--> Fusion UI

local Elements = script.Elements

--> Fusion Variables
local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value

local globalStates = {
	mainFrameActive = Value(true),
	buildableSelectVisible = Value(true),
}

return function(target)
	local frame
	local childrenTable = Value(nil)

	frame = New("Frame")({
		Parent = target,
		Transparency = 1,
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),

		--SizeConstraint = Enum.SizeConstraint.RelativeYY,
		[Children] = childrenTable,
	})

	childrenTable:set({

		require(Elements.MainMenu)(globalStates),
		require(Elements.BuildableSelect)(globalStates),
	})

	return frame
end
