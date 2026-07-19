local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")

-- // Remote URLs
local ELEMENTS_URL = "https://raw.githubusercontent.com/moon-82O/OriginUi/refs/heads/main/elements.lua"
local ICONS_URL    = "https://raw.githubusercontent.com/moon-82O/OriginUi/refs/heads/main/icons.lua"

-- // Library
local OriginUI = {
  Version = "2.0.0",
  Theme   = nil,
  Flags   = {},
}

-- // Themes
OriginUI.Themes = {
  Default = {
    Name       = "Default",
    Accent     = Color3.fromRGB(100, 160, 255),
    Background = Color3.fromRGB(20, 20, 24),
    Surface    = Color3.fromRGB(28, 28, 33),
    Card       = Color3.fromRGB(34, 34, 40),
    Border     = Color3.fromRGB(50, 50, 60),
    Text       = Color3.fromRGB(240, 240, 245),
    SubText    = Color3.fromRGB(140, 140, 155),
    Success    = Color3.fromRGB(80, 200, 120),
    Warning    = Color3.fromRGB(255, 185, 50),
    Danger     = Color3.fromRGB(220, 70, 70),
  },
  Midnight = {
    Name       = "Midnight",
    Accent     = Color3.fromRGB(140, 100, 255),
    Background = Color3.fromRGB(10, 10, 16),
    Surface    = Color3.fromRGB(18, 18, 26),
    Card       = Color3.fromRGB(24, 24, 36),
    Border     = Color3.fromRGB(40, 40, 60),
    Text       = Color3.fromRGB(240, 235, 255),
    SubText    = Color3.fromRGB(130, 120, 160),
    Success    = Color3.fromRGB(80, 200, 130),
    Warning    = Color3.fromRGB(255, 180, 50),
    Danger     = Color3.fromRGB(220, 70, 80),
  },
  Rose = {
    Name       = "Rose",
    Accent     = Color3.fromRGB(240, 90, 120),
    Background = Color3.fromRGB(20, 16, 18),
    Surface    = Color3.fromRGB(30, 22, 26),
    Card       = Color3.fromRGB(38, 28, 33),
    Border     = Color3.fromRGB(58, 40, 48),
    Text       = Color3.fromRGB(245, 235, 240),
    SubText    = Color3.fromRGB(160, 130, 140),
    Success    = Color3.fromRGB(80, 200, 120),
    Warning    = Color3.fromRGB(255, 185, 50),
    Danger     = Color3.fromRGB(220, 70, 70),
  },
  Forest = {
    Name       = "Forest",
    Accent     = Color3.fromRGB(80, 200, 130),
    Background = Color3.fromRGB(14, 20, 16),
    Surface    = Color3.fromRGB(20, 28, 22),
    Card       = Color3.fromRGB(26, 36, 28),
    Border     = Color3.fromRGB(40, 58, 44),
    Text       = Color3.fromRGB(230, 245, 235),
    SubText    = Color3.fromRGB(130, 155, 138),
    Success    = Color3.fromRGB(80, 200, 130),
    Warning    = Color3.fromRGB(255, 185, 50),
    Danger     = Color3.fromRGB(220, 70, 70),
  },
}

OriginUI.Theme = OriginUI.Themes.Default

-- // Utility Functions
local Utility = {}

function Utility.Create(class, props, children)
  local inst = Instance.new(class)
  for k, v in pairs(props or {}) do
    if k ~= "Parent" then
      inst[k] = v
    end
  end
  for _, child in ipairs(children or {}) do
    child.Parent = inst
  end
  if props and props.Parent then
    inst.Parent = props.Parent
  end
  return inst
end

function Utility.Corner(parent, radius)
  return Utility.Create("UICorner", {
    CornerRadius = UDim.new(0, radius or 8),
    Parent = parent,
  })
end

function Utility.Stroke(parent, color, thickness, transparency)
  return Utility.Create("UIStroke", {
    Color        = color or Color3.new(1, 1, 1),
    Thickness    = thickness or 1,
    Transparency = transparency or 0.85,
    Parent       = parent,
  })
end

function Utility.Padding(parent, top, right, bottom, left)
  return Utility.Create("UIPadding", {
    PaddingTop    = UDim.new(0, top    or 0),
    PaddingRight  = UDim.new(0, right  or 0),
    PaddingBottom = UDim.new(0, bottom or 0),
    PaddingLeft   = UDim.new(0, left   or 0),
    Parent        = parent,
  })
end

function Utility.List(parent, direction, padding, alignment)
  return Utility.Create("UIListLayout", {
    FillDirection       = direction  or Enum.FillDirection.Vertical,
    Padding             = UDim.new(0, padding or 4),
    SortOrder           = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = alignment or Enum.HorizontalAlignment.Left,
    Parent              = parent,
  })
end

function Utility.Tween(inst, props, duration, style, direction)
  local tween = TweenService:Create(
    inst,
    TweenInfo.new(
      duration  or 0.2,
      style     or Enum.EasingStyle.Quint,
      direction or Enum.EasingDirection.Out
    ),
    props
  )
  tween:Play()
  return tween
end

function Utility.Ripple(button, color)
  local ripple = Utility.Create("Frame", {
    Size                  = UDim2.new(0, 0, 0, 0),
    AnchorPoint           = Vector2.new(0.5, 0.5),
    BackgroundColor3      = color or Color3.new(1, 1, 1),
    BackgroundTransparency = 0.7,
    BorderSizePixel       = 0,
    ZIndex                = button.ZIndex + 1,
    Parent                = button,
  })
  Utility.Corner(ripple, 100)

  local mousePos = UserInputService:GetMouseLocation()
  local relPos   = Vector2.new(
    mousePos.X - button.AbsolutePosition.X,
    mousePos.Y - button.AbsolutePosition.Y
  )
  ripple.Position = UDim2.new(0, relPos.X, 0, relPos.Y)

  local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
  Utility.Tween(ripple, { Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1 }, 0.4)
  task.delay(0.4, function() ripple:Destroy() end)
end

OriginUI.Utility = Utility

-- // Load Modules
local Elements = loadstring(game:HttpGet(ELEMENTS_URL))()
local Icons    = loadstring(game:HttpGet(ICONS_URL))()

-- // Notification System
local NotificationHolder

local function initNotifications(screenGui)
  NotificationHolder = Utility.Create("Frame", {
    Size                  = UDim2.new(0, 300, 1, -20),
    Position              = UDim2.new(1, -310, 0, 10),
    BackgroundTransparency = 1,
    Parent                = screenGui,
  })
  Utility.List(NotificationHolder, Enum.FillDirection.Vertical, 8, Enum.HorizontalAlignment.Right)
  Utility.Create("UIListLayout", { -- already added above; override to align right
    FillDirection         = Enum.FillDirection.Vertical,
    VerticalAlignment     = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment   = Enum.HorizontalAlignment.Right,
    SortOrder             = Enum.SortOrder.LayoutOrder,
    Padding               = UDim.new(0, 8),
    Parent                = NotificationHolder,
  })
end

function OriginUI:Notify(config)
  config = config or {}
  local theme = self.Theme

  local notif = Utility.Create("Frame", {
    Size                  = UDim2.new(1, 0, 0, 0),
    AutomaticSize         = Enum.AutomaticSize.Y,
    BackgroundColor3      = theme.Surface,
    BackgroundTransparency = 0.1,
    BorderSizePixel       = 0,
    ClipsDescendants      = true,
    Parent                = NotificationHolder,
  })
  Utility.Corner(notif, 10)
  Utility.Stroke(notif, theme.Border, 1, 0.7)
  Utility.Padding(notif, 12, 14, 12, 14)

  -- Accent bar
  local barColor = config.Type == "Success" and theme.Success
    or config.Type == "Warning" and theme.Warning
    or config.Type == "Error"   and theme.Danger
    or theme.Accent

  Utility.Create("Frame", {
    Size             = UDim2.new(0, 3, 1, 0),
    BackgroundColor3 = barColor,
    BorderSizePixel  = 0,
    Parent           = notif,
  })
  Utility.Corner(Utility.Create("Frame", { Size = UDim2.new(0, 3, 1, 0), BackgroundColor3 = barColor, BorderSizePixel = 0, Parent = notif }), 4)

  local inner = Utility.Create("Frame", {
    Size                  = UDim2.new(1, -10, 0, 0),
    Position              = UDim2.new(0, 10, 0, 0),
    AutomaticSize         = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    Parent                = notif,
  })

  Utility.Create("TextLabel", {
    Size                  = UDim2.new(1, 0, 0, 18),
    BackgroundTransparency = 1,
    Font                  = Enum.Font.GothamBold,
    TextSize              = 13,
    TextColor3            = theme.Text,
    TextXAlignment        = Enum.TextXAlignment.Left,
    Text                  = config.Title or "Notification",
    Parent                = inner,
  })

  if config.Description then
    Utility.Create("TextLabel", {
      Size                  = UDim2.new(1, 0, 0, 0),
      Position              = UDim2.new(0, 0, 0, 22),
      AutomaticSize         = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      Font                  = Enum.Font.Gotham,
      TextSize              = 11,
      TextColor3            = theme.SubText,
      TextXAlignment        = Enum.TextXAlignment.Left,
      TextWrapped           = true,
      Text                  = config.Description,
      Parent                = inner,
    })
  end

  -- Animate in
  notif.BackgroundTransparency = 1
  Utility.Tween(notif, { BackgroundTransparency = 0.1 }, 0.3)

  -- Auto dismiss
  local duration = config.Duration or 4
  task.delay(duration, function()
    Utility.Tween(notif, { BackgroundTransparency = 1 }, 0.3)
    task.delay(0.3, function() notif:Destroy() end)
  end)

  return notif
end

-- // Window Constructor
function OriginUI:CreateWindow(config)
  config = config or {}

  -- Apply theme if specified
  if config.Theme and self.Themes[config.Theme] then
    self.Theme = self.Themes[config.Theme]
  end

  local theme  = self.Theme
  local player = Players.LocalPlayer
  local gui    = player:WaitForChild("PlayerGui")

  -- // ScreenGui
  local screenGui = Utility.Create("ScreenGui", {
    Name           = config.Name or "OriginUI",
    ResetOnSpawn   = false,
    DisplayOrder   = 999,
    IgnoreGuiInset = true,
    Parent         = gui,
  })

  initNotifications(screenGui)

  -- // Main Frame
  local main = Utility.Create("Frame", {
    Name                  = "Window",
    AnchorPoint           = Vector2.new(0.5, 0.5),
    Position              = config.Position or UDim2.new(0.5, 0, 0.5, 0),
    Size                  = config.Size     or UDim2.new(0, 560, 0, 380),
    BackgroundColor3      = theme.Background,
    BackgroundTransparency = 0.05,
    BorderSizePixel       = 0,
    ClipsDescendants      = true,
    Parent                = screenGui,
  })
  Utility.Corner(main, 12)
  Utility.Stroke(main, theme.Border, 1, 0.6)

  -- Intro animation
  main.Size = UDim2.new(0, 0, 0, 0)
  main.BackgroundTransparency = 1
  Utility.Tween(main, {
    Size                  = config.Size or UDim2.new(0, 560, 0, 380),
    BackgroundTransparency = 0.05,
  }, 0.35)

  -- // Top bar
  local topBar = Utility.Create("Frame", {
    Name                  = "TopBar",
    Size                  = UDim2.new(1, 0, 0, 44),
    BackgroundColor3      = theme.Surface,
    BackgroundTransparency = 0.1,
    BorderSizePixel       = 0,
    Parent                = main,
  })
  Utility.Corner(topBar, 12)
  -- Fix bottom corners
  Utility.Create("Frame", {
    Size             = UDim2.new(1, 0, 0.5, 0),
    Position         = UDim2.new(0, 0, 0.5, 0),
    BackgroundColor3 = theme.Surface,
    BackgroundTransparency = 0.1,
    BorderSizePixel  = 0,
    Parent           = topBar,
  })

  -- Accent line
  Utility.Create("Frame", {
    Size             = UDim2.new(1, 0, 0, 1),
    Position         = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = theme.Border,
    BackgroundTransparency = 0.5,
    BorderSizePixel  = 0,
    Parent           = topBar,
  })

  -- // Title
  local titleLabel = Utility.Create("TextLabel", {
    Size                  = UDim2.new(1, -100, 0, 20),
    Position              = UDim2.new(0, 16, 0, config.SubTitle and 5 or 0),
    BackgroundTransparency = 1,
    Font                  = Enum.Font.GothamBold,
    TextSize              = 14,
    TextColor3            = theme.Text,
    TextXAlignment        = Enum.TextXAlignment.Left,
    Text                  = config.Title or "OriginUI",
    Parent                = topBar,
  })

  if config.SubTitle then
    Utility.Create("TextLabel", {
      Size                  = UDim2.new(1, -100, 0, 14),
      Position              = UDim2.new(0, 16, 0, 24),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.Gotham,
      TextSize              = 11,
      TextColor3            = theme.SubText,
      TextXAlignment        = Enum.TextXAlignment.Left,
      Text                  = config.SubTitle,
      Parent                = topBar,
    })
  end

  -- // Window Buttons
  local function makeWinBtn(pos, color, symbol)
    local btn = Utility.Create("TextButton", {
      Size             = UDim2.new(0, 14, 0, 14),
      Position         = UDim2.new(1, pos, 0.5, -7),
      BackgroundColor3 = color,
      BorderSizePixel  = 0,
      Text             = "",
      ZIndex           = 5,
      Parent           = topBar,
    })
    Utility.Corner(btn, 100)

    local lbl = Utility.Create("TextLabel", {
      Size                  = UDim2.new(1, 0, 1, 0),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.GothamBold,
      TextSize              = 9,
      TextColor3            = Color3.new(0, 0, 0),
      Text                  = symbol,
      TextTransparency      = 1,
      Parent                = btn,
    })

    btn.MouseEnter:Connect(function()
      Utility.Tween(lbl, { TextTransparency = 0 }, 0.15)
      Utility.Tween(btn, { BackgroundTransparency = 0.2 }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
      Utility.Tween(lbl, { TextTransparency = 1 }, 0.15)
      Utility.Tween(btn, { BackgroundTransparency = 0 }, 0.15)
    end)

    return btn
  end

  local closeBtn    = makeWinBtn(-22, Color3.fromRGB(220, 70, 70),  "x")
  local minimizeBtn = makeWinBtn(-42, Color3.fromRGB(230, 175, 50), "-")

  -- // Dragging
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
      local delta = input.Position - dragStart
      main.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
      )
    end
  end)
  UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
      dragging = false
    end
  end)

  -- // Content Area
  local content = Utility.Create("Frame", {
    Name                  = "Content",
    Size                  = UDim2.new(1, 0, 1, -44),
    Position              = UDim2.new(0, 0, 0, 44),
    BackgroundTransparency = 1,
    BorderSizePixel       = 0,
    Parent                = main,
  })

  -- // Tab Bar (left sidebar)
  local tabBar = Utility.Create("ScrollingFrame", {
    Name                  = "TabBar",
    Size                  = UDim2.new(0, 130, 1, 0),
    BackgroundColor3      = theme.Surface,
    BackgroundTransparency = 0.3,
    BorderSizePixel       = 0,
    ScrollBarThickness    = 0,
    CanvasSize            = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize   = Enum.AutomaticSize.Y,
    Parent                = content,
  })
  Utility.Padding(tabBar, 8, 6, 8, 6)
  Utility.List(tabBar, Enum.FillDirection.Vertical, 4)

  -- Separator
  Utility.Create("Frame", {
    Name             = "Divider",
    Size             = UDim2.new(0, 1, 1, 0),
    Position         = UDim2.new(0, 130, 0, 0),
    BackgroundColor3 = theme.Border,
    BackgroundTransparency = 0.5,
    BorderSizePixel  = 0,
    Parent           = content,
  })

  -- // Page Holder
  local pageHolder = Utility.Create("Frame", {
    Name                  = "PageHolder",
    Size                  = UDim2.new(1, -138, 1, 0),
    Position              = UDim2.new(0, 138, 0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel       = 0,
    Parent                = content,
  })

  -- // Window Object
  local Window = { Tabs = {} }

  -- Close & minimize
  local minimized = false
  local normalSize = config.Size or UDim2.new(0, 560, 0, 380)

  closeBtn.MouseButton1Click:Connect(function()
    Utility.Tween(main, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 }, 0.3)
    task.delay(0.3, function() screenGui:Destroy() end)
  end)

  minimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
      minimized = false
      content.Visible = true
      Utility.Tween(main, { Size = normalSize }, 0.3)
    else
      minimized = true
      Utility.Tween(main, { Size = UDim2.new(0, normalSize.X.Offset, 0, 44) }, 0.3)
      task.delay(0.3, function()
        if minimized then content.Visible = false end
      end)
    end
  end)

  -- // CreateTab Method
  function Window:CreateTab(config)
    config = config or (type(config) == "string" and { Name = config } or {})
    if type(config) == "string" then config = { Name = config } end

    local tabName = config.Name or "Tab"
    local tabIcon = config.Icon

    -- Tab button
    local tabBtn = Utility.Create("TextButton", {
      Size                  = UDim2.new(1, 0, 0, 32),
      BackgroundColor3      = theme.Accent,
      BackgroundTransparency = 1,
      BorderSizePixel       = 0,
      Font                  = Enum.Font.Gotham,
      TextSize              = 12,
      TextColor3            = theme.SubText,
      TextXAlignment        = Enum.TextXAlignment.Left,
      Text                  = tabIcon and ("  " .. tabName) or tabName,
      AutoButtonColor       = false,
      Parent                = tabBar,
    })
    Utility.Corner(tabBtn, 6)
    Utility.Padding(tabBtn, 0, 0, 0, tabIcon and 30 or 8)

    -- Icon (if provided)
    if tabIcon then
      local iconFrame = Icons.Create(tabIcon, {
        Size     = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 8, 0.5, -8),
        Color    = theme.SubText,
        Parent   = tabBtn,
      })
    end

    -- Active indicator
    local indicator = Utility.Create("Frame", {
      Size             = UDim2.new(0, 3, 0, 0),
      Position         = UDim2.new(0, 0, 0.5, 0),
      AnchorPoint      = Vector2.new(0, 0.5),
      BackgroundColor3 = theme.Accent,
      BorderSizePixel  = 0,
      Parent           = tabBtn,
    })
    Utility.Corner(indicator, 4)

    -- Page (scrolling content)
    local page = Utility.Create("ScrollingFrame", {
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
    Utility.Padding(page, 10, 10, 10, 10)
    Utility.List(page, Enum.FillDirection.Vertical, 6)

    -- Tab logic
    local Tab = { Container = page, Button = tabBtn }

    local function selectTab()
      for _, t in ipairs(Window.Tabs) do
        t.Button.TextColor3 = theme.SubText
        t.Button.Font = Enum.Font.Gotham
        Utility.Tween(t.Button, { BackgroundTransparency = 1 }, 0.15)
        Utility.Tween(t._indicator, { Size = UDim2.new(0, 3, 0, 0) }, 0.2)
        if t._iconFrame then
          Utility.Tween(t._iconFrame, { ImageColor3 = theme.SubText }, 0.15)
        end
        t.Container.Visible = false
      end

      tabBtn.TextColor3 = theme.Text
      tabBtn.Font = Enum.Font.GothamSemibold
      Utility.Tween(tabBtn, { BackgroundTransparency = 0.9 }, 0.15)
      Utility.Tween(indicator, { Size = UDim2.new(0, 3, 0, 20) }, 0.2)
      page.Visible = true
    end

    Tab._indicator  = indicator
    tabBtn.MouseButton1Click:Connect(selectTab)

    -- Hover
    tabBtn.MouseEnter:Connect(function()
      if page.Visible then return end
      Utility.Tween(tabBtn, { BackgroundTransparency = 0.94 }, 0.15)
    end)
    tabBtn.MouseLeave:Connect(function()
      if page.Visible then return end
      Utility.Tween(tabBtn, { BackgroundTransparency = 1 }, 0.15)
    end)

    Elements.Attach(Tab, Utility, theme, page, Icons, self)
    table.insert(Window.Tabs, Tab)

    if #Window.Tabs == 1 then
      selectTab()
    end

    return Tab
  end

  -- // SetTheme
  function Window:SetTheme(themeName)
    if OriginUI.Themes[themeName] then
      OriginUI.Theme = OriginUI.Themes[themeName]
      -- Live-update would require re-rendering; this takes effect on next creation
    end
  end

  -- // Notify shortcut
  function Window:Notify(config)
    return OriginUI:Notify(config)
  end

  return Window
end

return OriginUI
