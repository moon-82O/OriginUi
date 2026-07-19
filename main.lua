local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")

local ELEMENTS_URL = "https://raw.githubusercontent.com/moon-82O/OriginUi/refs/heads/main/elements.lua"
local ICONS_URL    = "https://raw.githubusercontent.com/moon-82O/OriginUi/refs/heads/main/icons.lua"

local OriginUI = {
	Version = "2.0.0",
	Theme   = nil,
	Flags   = {},
}

OriginUI.Themes = {
	Default = {
		Accent     = Color3.fromRGB(100, 160, 255),
		Background = Color3.fromRGB(18, 18, 22),
		Surface    = Color3.fromRGB(25, 25, 30),
		Card       = Color3.fromRGB(32, 32, 38),
		Border     = Color3.fromRGB(48, 48, 58),
		Text       = Color3.fromRGB(240, 240, 245),
		SubText    = Color3.fromRGB(130, 130, 148),
		Success    = Color3.fromRGB(74, 195, 111),
		Warning    = Color3.fromRGB(245, 181, 64),
		Danger     = Color3.fromRGB(215, 68, 68),
	},
	Midnight = {
		Accent     = Color3.fromRGB(135, 95, 255),
		Background = Color3.fromRGB(10, 10, 16),
		Surface    = Color3.fromRGB(17, 17, 26),
		Card       = Color3.fromRGB(23, 23, 36),
		Border     = Color3.fromRGB(38, 38, 60),
		Text       = Color3.fromRGB(240, 235, 255),
		SubText    = Color3.fromRGB(120, 112, 155),
		Success    = Color3.fromRGB(74, 195, 120),
		Warning    = Color3.fromRGB(245, 178, 58),
		Danger     = Color3.fromRGB(215, 68, 78),
	},
	Rose = {
		Accent     = Color3.fromRGB(238, 88, 116),
		Background = Color3.fromRGB(20, 15, 18),
		Surface    = Color3.fromRGB(29, 21, 25),
		Card       = Color3.fromRGB(37, 27, 32),
		Border     = Color3.fromRGB(56, 38, 46),
		Text       = Color3.fromRGB(245, 235, 240),
		SubText    = Color3.fromRGB(155, 125, 138),
		Success    = Color3.fromRGB(74, 195, 111),
		Warning    = Color3.fromRGB(245, 181, 64),
		Danger     = Color3.fromRGB(215, 68, 68),
	},
	Forest = {
		Accent     = Color3.fromRGB(76, 195, 125),
		Background = Color3.fromRGB(13, 19, 15),
		Surface    = Color3.fromRGB(19, 27, 21),
		Card       = Color3.fromRGB(25, 35, 27),
		Border     = Color3.fromRGB(38, 56, 42),
		Text       = Color3.fromRGB(228, 244, 233),
		SubText    = Color3.fromRGB(122, 150, 130),
		Success    = Color3.fromRGB(76, 195, 125),
		Warning    = Color3.fromRGB(245, 181, 64),
		Danger     = Color3.fromRGB(215, 68, 68),
	},
}
OriginUI.Theme = OriginUI.Themes.Default

local U = {}

function U.New(class, props, children)
	local obj = Instance.new(class)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then obj[k] = v end
	end
	for _, child in ipairs(children or {}) do
		child.Parent = obj
	end
	if props and props.Parent then obj.Parent = props.Parent end
	return obj
end

function U.Corner(p, r)
	return U.New("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = p })
end

function U.Stroke(p, color, thickness, transparency)
	return U.New("UIStroke", {
		Color        = color or Color3.new(1, 1, 1),
		Thickness    = thickness or 1,
		Transparency = transparency or 0.8,
		Parent       = p,
	})
end

function U.Padding(p, top, right, bottom, left)
	return U.New("UIPadding", {
		PaddingTop    = UDim.new(0, top    or 0),
		PaddingRight  = UDim.new(0, right  or 0),
		PaddingBottom = UDim.new(0, bottom or 0),
		PaddingLeft   = UDim.new(0, left   or 0),
		Parent        = p,
	})
end

function U.List(p, dir, pad, halign, valign)
	return U.New("UIListLayout", {
		FillDirection       = dir    or Enum.FillDirection.Vertical,
		Padding             = UDim.new(0, pad or 4),
		SortOrder           = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = halign or Enum.HorizontalAlignment.Left,
		VerticalAlignment   = valign or Enum.VerticalAlignment.Top,
		Parent              = p,
	})
end

function U.Tween(obj, props, t, style, dir)
	local tw = TweenService:Create(
		obj,
		TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
		props
	)
	tw:Play()
	return tw
end

function U.Ripple(btn, color)
	local rip = U.New("Frame", {
		Size                   = UDim2.new(0, 0, 0, 0),
		AnchorPoint            = Vector2.new(0.5, 0.5),
		BackgroundColor3       = color or Color3.new(1, 1, 1),
		BackgroundTransparency = 0.7,
		BorderSizePixel        = 0,
		ZIndex                 = btn.ZIndex + 1,
		Parent                 = btn,
	})
	U.Corner(rip, 100)
	local mp = UserInputService:GetMouseLocation()
	rip.Position = UDim2.new(0, mp.X - btn.AbsolutePosition.X, 0, mp.Y - btn.AbsolutePosition.Y)
	local s = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2
	U.Tween(rip, { Size = UDim2.new(0, s, 0, s), BackgroundTransparency = 1 }, 0.45)
	task.delay(0.45, function() rip:Destroy() end)
end

OriginUI.Utility = U

local Elements = loadstring(game:HttpGet(ELEMENTS_URL))()
local Icons    = loadstring(game:HttpGet(ICONS_URL))()

local NotifHolder

local function initNotifs(gui)
	NotifHolder = U.New("Frame", {
		Size                   = UDim2.new(0, 300, 1, -20),
		Position               = UDim2.new(1, -308, 0, 10),
		BackgroundTransparency = 1,
		Parent                 = gui,
	})
	U.New("UIListLayout", {
		FillDirection       = Enum.FillDirection.Vertical,
		VerticalAlignment   = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder           = Enum.SortOrder.LayoutOrder,
		Padding             = UDim.new(0, 8),
		Parent              = NotifHolder,
	})
end

function OriginUI:Notify(config)
	config = config or {}
	local theme = self.Theme
	local barColor = config.Type == "Success" and theme.Success
		or config.Type == "Warning" and theme.Warning
		or config.Type == "Error"   and theme.Danger
		or theme.Accent

	local wrap = U.New("Frame", {
		Size                   = UDim2.new(1, 0, 0, 0),
		AutomaticSize          = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent                 = NotifHolder,
	})

	local notif = U.New("Frame", {
		Size                   = UDim2.new(1, 0, 0, 0),
		AutomaticSize          = Enum.AutomaticSize.Y,
		BackgroundColor3       = theme.Surface,
		BackgroundTransparency = 1,
		BorderSizePixel        = 0,
		Parent                 = wrap,
	})
	U.Corner(notif, 10)
	U.Stroke(notif, theme.Border, 1, 0.55)
	U.Padding(notif, 12, 14, 12, 18)

	local bar = U.New("Frame", {
		Size             = UDim2.new(0, 3, 1, -24),
		Position         = UDim2.new(0, 0, 0, 12),
		BackgroundColor3 = barColor,
		BorderSizePixel  = 0,
		Parent           = notif,
	})
	U.Corner(bar, 4)

	local inner = U.New("Frame", {
		Size                   = UDim2.new(1, 0, 0, 0),
		AutomaticSize          = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent                 = notif,
	})
	U.New("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		Padding       = UDim.new(0, 3),
		SortOrder     = Enum.SortOrder.LayoutOrder,
		Parent        = inner,
	})

	U.New("TextLabel", {
		Size                   = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Font                   = Enum.Font.GothamBold,
		TextSize               = 13,
		TextColor3             = theme.Text,
		TextXAlignment         = Enum.TextXAlignment.Left,
		Text                   = config.Title or "Notification",
		Parent                 = inner,
	})

	if config.Description then
		U.New("TextLabel", {
			Size                   = UDim2.new(1, 0, 0, 0),
			AutomaticSize          = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font                   = Enum.Font.Gotham,
			TextSize               = 11,
			TextColor3             = theme.SubText,
			TextXAlignment         = Enum.TextXAlignment.Left,
			TextWrapped            = true,
			Text                   = config.Description,
			Parent                 = inner,
		})
	end

	U.Tween(notif, { BackgroundTransparency = 0.08 }, 0.3)
	task.delay(config.Duration or 4, function()
		U.Tween(notif, { BackgroundTransparency = 1 }, 0.3)
		task.delay(0.3, function() wrap:Destroy() end)
	end)
	return notif
end

function OriginUI:CreateWindow(config)
	config = config or {}
	if config.Theme and self.Themes[config.Theme] then
		self.Theme = self.Themes[config.Theme]
	end
	local theme    = self.Theme
	local player   = Players.LocalPlayer
	local gui      = player:WaitForChild("PlayerGui")
	local mainSize = config.Size or UDim2.new(0, 580, 0, 400)

	local screenGui = U.New("ScreenGui", {
		Name           = config.Name or "OriginUI",
		ResetOnSpawn   = false,
		DisplayOrder   = 999,
		IgnoreGuiInset = true,
		Parent         = gui,
	})

	initNotifs(screenGui)

	local main = U.New("Frame", {
		Name                   = "Window",
		AnchorPoint            = Vector2.new(0.5, 0.5),
		Position               = config.Position or UDim2.new(0.5, 0, 0.5, 0),
		Size                   = UDim2.new(0, 0, 0, 0),
		BackgroundColor3       = theme.Background,
		BackgroundTransparency = 1,
		BorderSizePixel        = 0,
		ClipsDescendants       = true,
		Parent                 = screenGui,
	})
	U.Corner(main, 12)
	U.Stroke(main, theme.Border, 1, 0.45)
	U.Tween(main, { Size = mainSize, BackgroundTransparency = 0 }, 0.4)

	local topBar = U.New("Frame", {
		Size             = UDim2.new(1, 0, 0, 46),
		BackgroundColor3 = theme.Surface,
		BorderSizePixel  = 0,
		Parent           = main,
	})
	U.New("Frame", {
		Size             = UDim2.new(1, 0, 0.5, 0),
		Position         = UDim2.new(0, 0, 0.5, 0),
		BackgroundColor3 = theme.Surface,
		BorderSizePixel  = 0,
		Parent           = topBar,
	})
	U.New("Frame", {
		Size                   = UDim2.new(1, 0, 0, 1),
		Position               = UDim2.new(0, 0, 1, -1),
		BackgroundColor3       = theme.Border,
		BackgroundTransparency = 0.4,
		BorderSizePixel        = 0,
		Parent                 = topBar,
	})
	U.Corner(topBar, 12)
	U.Padding(topBar, 0, 16, 0, 16)

	local function makeWinBtn(xOff, color, sym)
		local b = U.New("TextButton", {
			Size             = UDim2.new(0, 13, 0, 13),
			Position         = UDim2.new(0, xOff, 0.5, -6),
			BackgroundColor3 = color,
			BorderSizePixel  = 0,
			Text             = "",
			AutoButtonColor  = false,
			ZIndex           = 5,
			Parent           = topBar,
		})
		U.Corner(b, 100)
		local lbl = U.New("TextLabel", {
			Size                   = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.GothamBold,
			TextSize               = 8,
			TextColor3             = Color3.new(0, 0, 0),
			Text                   = sym,
			TextTransparency       = 1,
			Parent                 = b,
		})
		b.MouseEnter:Connect(function()
			U.Tween(lbl, { TextTransparency = 0.2 }, 0.1)
			U.Tween(b, { BackgroundTransparency = 0.15 }, 0.1)
		end)
		b.MouseLeave:Connect(function()
			U.Tween(lbl, { TextTransparency = 1 }, 0.1)
			U.Tween(b, { BackgroundTransparency = 0 }, 0.1)
		end)
		return b
	end

	local closeBtn    = makeWinBtn(0,  Color3.fromRGB(215, 68, 68),  "x")
	local minimizeBtn = makeWinBtn(20, Color3.fromRGB(245, 181, 64), "-")

	U.New("TextLabel", {
		Size                   = UDim2.new(1, -90, 0, 18),
		Position               = UDim2.new(0, 52, 0, config.SubTitle and 5 or 0),
		AnchorPoint            = Vector2.new(0, config.SubTitle and 0 or 0.5),
		BackgroundTransparency = 1,
		Font                   = Enum.Font.GothamBold,
		TextSize               = 13,
		TextColor3             = theme.Text,
		TextXAlignment         = Enum.TextXAlignment.Left,
		Text                   = config.Title or "OriginUI",
		Parent                 = topBar,
	})
	if config.SubTitle then
		U.New("TextLabel", {
			Size                   = UDim2.new(1, -90, 0, 13),
			Position               = UDim2.new(0, 52, 0, 24),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.Gotham,
			TextSize               = 10,
			TextColor3             = theme.SubText,
			TextXAlignment         = Enum.TextXAlignment.Left,
			Text                   = config.SubTitle,
			Parent                 = topBar,
		})
	end

	local dragging, dragStart, startPos
	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging  = true
			dragStart = input.Position
			startPos  = main.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local d = input.Position - dragStart
			main.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	local content = U.New("Frame", {
		Size                   = UDim2.new(1, 0, 1, -46),
		Position               = UDim2.new(0, 0, 0, 46),
		BackgroundTransparency = 1,
		BorderSizePixel        = 0,
		Parent                 = main,
	})

	local tabBar = U.New("ScrollingFrame", {
		Size                  = UDim2.new(0, 140, 1, 0),
		BackgroundColor3      = theme.Surface,
		BackgroundTransparency = 0.2,
		BorderSizePixel       = 0,
		ScrollBarThickness    = 0,
		CanvasSize            = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize   = Enum.AutomaticSize.Y,
		Parent                = content,
	})
	U.Padding(tabBar, 8, 6, 8, 6)
	U.List(tabBar, Enum.FillDirection.Vertical, 3)

	U.New("Frame", {
		Size             = UDim2.new(0, 1, 1, 0),
		Position         = UDim2.new(0, 140, 0, 0),
		BackgroundColor3 = theme.Border,
		BackgroundTransparency = 0.4,
		BorderSizePixel  = 0,
		Parent           = content,
	})

	local pageHolder = U.New("Frame", {
		Size                   = UDim2.new(1, -148, 1, 0),
		Position               = UDim2.new(0, 148, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel        = 0,
		Parent                 = content,
	})

	local Window = { Tabs = {} }
	local minimized = false

	closeBtn.MouseButton1Click:Connect(function()
		U.Tween(main, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 }, 0.3)
		task.delay(0.3, function() screenGui:Destroy() end)
	end)
	minimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			U.Tween(main, { Size = UDim2.new(0, mainSize.X.Offset, 0, 46) }, 0.3)
			task.delay(0.28, function() if minimized then content.Visible = false end end)
		else
			content.Visible = true
			U.Tween(main, { Size = mainSize }, 0.3)
		end
	end)

	function Window:CreateTab(tabConfig)
		if type(tabConfig) == "string" then tabConfig = { Name = tabConfig } end
		tabConfig = tabConfig or {}
		local tabName = tabConfig.Name or "Tab"

		local tabBtn = U.New("TextButton", {
			Size                   = UDim2.new(1, 0, 0, 34),
			BackgroundColor3       = theme.Accent,
			BackgroundTransparency = 1,
			BorderSizePixel        = 0,
			Text                   = "",
			AutoButtonColor        = false,
			Parent                 = tabBar,
		})
		U.Corner(tabBtn, 6)
		U.Padding(tabBtn, 0, 0, 0, tabConfig.Icon and 34 or 10)

		local indicator = U.New("Frame", {
			Size             = UDim2.new(0, 3, 0, 0),
			Position         = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint      = Vector2.new(0, 0.5),
			BackgroundColor3 = theme.Accent,
			BorderSizePixel  = 0,
			Parent           = tabBtn,
		})
		U.Corner(indicator, 4)

		local tabLabel = U.New("TextLabel", {
			Size                   = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.Gotham,
			TextSize               = 12,
			TextColor3             = theme.SubText,
			TextXAlignment         = Enum.TextXAlignment.Left,
			Text                   = tabName,
			Parent                 = tabBtn,
		})

		if tabConfig.Icon then
			Icons.Create(tabConfig.Icon, {
				Size     = UDim2.new(0, 14, 0, 14),
				Position = UDim2.new(0, 10, 0.5, -7),
				Color    = theme.SubText,
				Parent   = tabBtn,
			})
		end

		local page = U.New("ScrollingFrame", {
			Size                  = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel       = 0,
			ScrollBarThickness    = 3,
			ScrollBarImageColor3  = theme.Accent,
			CanvasSize            = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize   = Enum.AutomaticSize.Y,
			Visible               = false,
			Parent                = pageHolder,
		})
		U.Padding(page, 12, 12, 12, 12)
		U.List(page, Enum.FillDirection.Vertical, 6)

		local Tab = { Container = page, Button = tabBtn, _indicator = indicator, _label = tabLabel }

		local function selectTab()
			for _, t in ipairs(Window.Tabs) do
				t._label.TextColor3 = theme.SubText
				t._label.Font = Enum.Font.Gotham
				U.Tween(t.Button, { BackgroundTransparency = 1 }, 0.15)
				U.Tween(t._indicator, { Size = UDim2.new(0, 3, 0, 0) }, 0.15)
				t.Container.Visible = false
			end
			tabLabel.TextColor3 = theme.Text
			tabLabel.Font = Enum.Font.GothamSemibold
			U.Tween(tabBtn, { BackgroundTransparency = 0.9 }, 0.15)
			U.Tween(indicator, { Size = UDim2.new(0, 3, 0, 18) }, 0.15)
			page.Visible = true
		end

		tabBtn.MouseButton1Click:Connect(selectTab)
		tabBtn.MouseEnter:Connect(function()
			if page.Visible then return end
			U.Tween(tabBtn, { BackgroundTransparency = 0.94 }, 0.12)
		end)
		tabBtn.MouseLeave:Connect(function()
			if page.Visible then return end
			U.Tween(tabBtn, { BackgroundTransparency = 1 }, 0.12)
		end)

		Elements.Attach(Tab, U, theme, page, Icons, OriginUI)
		table.insert(Window.Tabs, Tab)
		if #Window.Tabs == 1 then selectTab() end
		return Tab
	end

	function Window:Notify(cfg)
		return OriginUI:Notify(cfg)
	end

	return Window
end

return OriginUI
