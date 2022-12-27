local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Loader.Utils.Fusion)

--> Fusion UI

local BuildablesList = require(script.BuildablesList)

--> Components
local Components = ReplicatedStorage.Hoarcekat.BuildUI.Components
local TextButton = require(Components.TextButton)
local Frame = require(Components.Frame)

--> Fusion Variables
local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Computed = Fusion.Computed

local Observer = Fusion.Observer
local Spring = Fusion.Spring

local globalStates = {
	mainFrameActive = Value(true),
}

return function(target)
	local MainSpringGoal = Value(UDim2.fromScale(0.5, 0.89))
	local MainSpring = Spring(MainSpringGoal, 15, 1)

	local ButtonSpringGoal = Value(UDim2.fromScale(0.5, 0.89))
	local ButtonSpring = Spring(ButtonSpringGoal, 15, 1)
	do
		local ActiveState = globalStates.mainFrameActive
		local ActiveObserver = Observer(ActiveState)
		ActiveObserver:onChange(function()
			local Active = ActiveState:get()

			if Active then
				MainSpringGoal:set(UDim2.fromScale(0.5, 0.89))
				ButtonSpringGoal:set(UDim2.fromScale(0.5, 0.75))
			else
				MainSpringGoal:set(UDim2.fromScale(0.5, 1.1))
				ButtonSpringGoal:set(UDim2.fromScale(0.5, 0.95))
			end
		end)
	end

	New("Frame")({
		Parent = target,
		Transparency = 1,
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),

		[Children] = {
			TextButton({
				Text = "Build",

				Size = UDim2.fromScale(0.1, 0.05),
				Position = ButtonSpring,

				Visible = Computed(function()
					return not globalStates.mainFrameActive:get()
				end),

				[Children] = {
					New("UICorner")({
						CornerRadius = UDim.new(0.15, 0),
					}),
				},

				OnActivated = function()
					globalStates.mainFrameActive:set(not globalStates.mainFrameActive:get())
				end,
			}),

			--> Main Frame
			Frame({
				Size = UDim2.fromScale(0.8, 0.2),
				Position = MainSpring,

				[Children] = {
					New("UICorner")({
						CornerRadius = UDim.new(0.05, 0),
					}),

					BuildablesList,
				},
			}),
		},
	})

	globalStates.mainFrameActive:set(false)
end
