-- @date: 2022-12-26

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--> Fusion
local Fusion = require(ReplicatedStorage.Loader.Utils.Fusion)

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value

--> Components

local Components = ReplicatedStorage.Hoarcekat.BuildUI.Components
local ModelPort = require(Components.ModelPort)

--> Variables

local BuildablesFolder = ReplicatedStorage.Resources.Buildables:Clone():GetChildren()

local AddedListChildren = Value(nil)

local scrollingList = New("ScrollingFrame")({

	--> Styling

	BorderSizePixel = 0,
	BackgroundColor3 = Color3.fromRGB(51, 51, 55),

	ScrollingDirection = Enum.ScrollingDirection.X,
	CanvasSize = UDim2.fromScale(1, 1),

	--> ScrollBar
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = Color3.fromRGB(108, 108, 110),
	TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
	BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",

	--> Fitting

	AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.fromScale(0.95, 0.85),
	Position = UDim2.fromScale(0.5, 0.5),

	--> Children

	[Children] = {
		New("UICorner")({
			CornerRadius = UDim.new(0.03, 0),
		}),
		New("UIListLayout")({
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0.01, 0),
		}),

		AddedListChildren,
	},
	--> Events
})

for _, model in pairs(BuildablesFolder) do
	model.CFrame = CFrame.new(0, 0, 0)
	local modelViewPort = ModelPort({
		Model = model,
		Size = UDim2.fromScale(0.1, 1),
	})

	if AddedListChildren:get() then
		AddedListChildren:set({ table.unpack(AddedListChildren:get()), modelViewPort })
	else
		AddedListChildren:set({ modelViewPort })
	end
end

return scrollingList
