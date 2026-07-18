local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local ElementsUrl = "https://raw.githubusercontent.com/moon-82O/OriginUi/refs/heads/main/elements.lua"

local OriginUi = {}

OriginUi.Theme = {
	Accent = Color3.fromRGB(90, 150, 255),
	Background = Color3.fromRGB(30, 30, 34),
	Secondary = Color3.fromRGB(45, 45, 50),
	Text = Color3.fromRGB(235, 235, 240),
	SubText = Color3.fromRGB(155, 155, 162),
}

local function create(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props) do
		inst[k] = v
	end
	return inst
end

local function corner(parent, radius)
	return create("UICorner", {CornerRadius = UDim.new(0, radius), Parent = parent})
end

local function stroke(parent, color, thickness, transparency)
	return create("UIStroke", {Color = color, Thickness = thickness, Transparency = transparency, Parent = parent})
end

local function tween(inst, props, duration, style, direction)
	TweenService:Create(inst, TweenInfo.new(duration or 0.18, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), props):Play()
end

OriginUi.Utility = {
	Create = create,
	Corner = corner,
	Stroke = stroke,
	Tween = tween,
}

local Elements = loadstring(game:HttpGet(ElementsUrl))()

function OriginUi:CreateWindow(config)
	config = config or {}
	local theme = OriginUi.Theme

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = create("ScreenGui", {
		Name = config.Name or "OriginUi",
		ResetOnSpawn = false,
		DisplayOrder = 999,
		Parent = playerGui,
	})

	local main = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = config.Size or UDim2.new(0, 480, 0, 320),
		BackgroundColor3 = theme.Background,
		BackgroundTransparency = config.Transparency or 0.08,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = screenGui,
	})
	corner(main, 14)
	stroke(main, Color3.new(1, 1, 1), 1, 0.85)

	local header = create("Frame", {
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
		Active = true,
		Parent = main,
	})

	local title = create("TextLabel", {
		Size = UDim2.new(1, -80, 0, 18),
		Position = UDim2.new(0, 16, 0, config.SubTitle and 6 or 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 15,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.Title or "Window",
		Parent = header,
	})

	if config.SubTitle then
		create("TextLabel", {
			Size = UDim2.new(1, -80, 0, 14),
			Position = UDim2.new(0, 16, 0, 22),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextColor3 = theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = config.SubTitle,
			Parent = header,
		})
	end

	local closeBtn = create("TextButton", {
		Size = UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(1, -36, 0, 8),
		BackgroundColor3 = Color3.fromRGB(220, 80, 80),
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = Color3.new(1, 1, 1),
		Text = "x",
		Parent = header,
	})
	corner(closeBtn, 8)

	local minimizeBtn = create("TextButton", {
		Size = UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(1, -68, 0, 8),
		BackgroundColor3 = theme.Secondary,
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = Color3.new(1, 1, 1),
		Text = "-",
		Parent = header,
	})
	corner(minimizeBtn, 8)

	create("Frame", {
		Size = UDim2.new(1, 0, 0, 2),
		Position = UDim2.new(0, 0, 0, 42),
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Parent = main,
	})

	local tabBar = create("Frame", {
		Size = UDim2.new(0, 120, 1, -50),
		Position = UDim2.new(0, 0, 0, 50),
		BackgroundTransparency = 1,
		Parent = main,
	})

	create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
		Parent = tabBar,
	})

	create("Frame", {
		Size = UDim2.new(0, 1, 1, -50),
		Position = UDim2.new(0, 120, 0, 50),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
		Parent = main,
	})

	local pageHolder = create("Frame", {
		Size = UDim2.new(1, -132, 1, -60),
		Position = UDim2.new(0, 128, 0, 55),
		BackgroundTransparency = 1,
		Parent = main,
	})

	local Window = {}
	Window.Tabs = {}

	local dragging, dragStart, startPos
	header.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			local conn
			conn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					conn:Disconnect()
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local minimized = false
	local expandedSize = main.Size
	minimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		tween(main, {Size = minimized and UDim2.new(expandedSize.X.Scale, expandedSize.X.Offset, 0, 42) or expandedSize}, 0.25)
	end)

	closeBtn.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)

	function Window:CreateTab(name, order)
		local tabBtn = create("TextButton", {
			Size = UDim2.new(1, -8, 0, 30),
			Position = UDim2.new(0, 4, 0, 0),
			BackgroundColor3 = theme.Secondary,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextColor3 = theme.SubText,
			Text = name,
			LayoutOrder = order or (#Window.Tabs + 1),
			Parent = tabBar,
		})
		corner(tabBtn, 8)

		local page = create("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = theme.Accent,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			Parent = pageHolder,
		})

		create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
			Parent = page,
		})

		local Tab = {}
		Tab.Container = page
		Tab.Button = tabBtn

		local function select()
			for _, t in pairs(Window.Tabs) do
				t.Button.TextColor3 = theme.SubText
				tween(t.Button, {BackgroundTransparency = 1})
				t.Container.Visible = false
			end
			tabBtn.TextColor3 = theme.Text
			tween(tabBtn, {BackgroundTransparency = 0.85})
			page.Visible = true
		end

		tabBtn.MouseButton1Click:Connect(select)

		Elements.Attach(Tab, OriginUi.Utility, theme, page)

		table.insert(Window.Tabs, Tab)
		if #Window.Tabs == 1 then
			select()
		end

		return Tab
	end

	return Window
end

return OriginUi
