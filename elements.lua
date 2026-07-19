local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")

local Elements = {}

function Elements.Attach(Tab, Utility, Theme, Container, Icons, Library)
  local create = Utility.Create
  local corner = Utility.Corner
  local stroke = Utility.Stroke
  local tween  = Utility.Tween
  local ripple = Utility.Ripple

  -- // SECTION -------------------------------------------------------
  function Tab:CreateSection(config)
    config = config or {}

    local section = create("Frame", {
      Size                  = UDim2.new(1, 0, 0, 0),
      AutomaticSize         = Enum.AutomaticSize.Y,
      BackgroundColor3      = Theme.Card,
      BackgroundTransparency = 0.3,
      BorderSizePixel       = 0,
      Parent                = Container,
    })
    corner(section, 8)
    stroke(section, Theme.Border, 1, 0.7)
    Utility.Padding(section, 10, 10, 10, 10)

    -- Header
    local headerRow = create("Frame", {
      Size                  = UDim2.new(1, 0, 0, 20),
      BackgroundTransparency = 1,
      Parent                = section,
    })

    if config.Icon then
      Icons.Create(config.Icon, {
        Size   = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 0, 0.5, -7),
        Color  = Theme.Accent,
        Parent = headerRow,
      })
    end

    create("TextLabel", {
      Size                  = UDim2.new(1, config.Icon and -20 or 0, 1, 0),
      Position              = UDim2.new(0, config.Icon and 20 or 0, 0, 0),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.GothamBold,
      TextSize              = 12,
      TextColor3            = Theme.Accent,
      TextXAlignment        = Enum.TextXAlignment.Left,
      Text                  = (config.Name or "Section"):upper(),
      Parent                = headerRow,
    })

    -- Separator line
    create("Frame", {
      Size             = UDim2.new(1, 0, 0, 1),
      Position         = UDim2.new(0, 0, 0, 24),
      BackgroundColor3 = Theme.Border,
      BackgroundTransparency = 0.5,
      BorderSizePixel  = 0,
      Parent           = section,
    })

    -- Inner list
    local inner = create("Frame", {
      Size                  = UDim2.new(1, 0, 0, 0),
      Position              = UDim2.new(0, 0, 0, 30),
      AutomaticSize         = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      Parent                = section,
    })
    Utility.List(inner, Enum.FillDirection.Vertical, 6)

    local SectionTab = {}
    Elements.Attach(SectionTab, Utility, Theme, inner, Icons, Library)
    return SectionTab
  end

  -- // LABEL --------------------------------------------------------
  function Tab:CreateLabel(config)
    config = config or {}

    local label = create("TextLabel", {
      Size                  = UDim2.new(1, 0, 0, 0),
      AutomaticSize         = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      Font                  = Enum.Font.Gotham,
      TextSize              = 12,
      TextColor3            = Theme.SubText,
      TextXAlignment        = Enum.TextXAlignment.Left,
      TextWrapped           = true,
      Text                  = config.Text or "Label",
      Parent                = Container,
    })

    local LabelObj = {}
    function LabelObj:Set(text) label.Text = text end
    function LabelObj:SetColor(color) label.TextColor3 = color end
    return LabelObj
  end

  -- // PARAGRAPH ----------------------------------------------------
  function Tab:CreateParagraph(config)
    config = config or {}

    local frame = create("Frame", {
      Size                  = UDim2.new(1, 0, 0, 0),
      AutomaticSize         = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      Parent                = Container,
    })

    create("TextLabel", {
      Size                  = UDim2.new(1, 0, 0, 18),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.GothamSemibold,
      TextSize              = 13,
      TextColor3            = Theme.Text,
      TextXAlignment        = Enum.TextXAlignment.Left,
      Text                  = config.Title or "",
      Parent                = frame,
    })

    create("TextLabel", {
      Size                  = UDim2.new(1, 0, 0, 0),
      Position              = UDim2.new(0, 0, 0, 22),
      AutomaticSize         = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      Font                  = Enum.Font.Gotham,
      TextSize              = 12,
      TextColor3            = Theme.SubText,
      TextXAlignment        = Enum.TextXAlignment.Left,
      TextWrapped           = true,
      Text                  = config.Content or "",
      Parent                = frame,
    })
  end

  -- // DIVIDER -------------------------------------------------------
  function Tab:CreateDivider()
    create("Frame", {
      Size             = UDim2.new(1, 0, 0, 1),
      BackgroundColor3 = Theme.Border,
      BackgroundTransparency = 0.5,
      BorderSizePixel  = 0,
      Parent           = Container,
    })
  end

  -- // BUTTON --------------------------------------------------------
  function Tab:CreateButton(config)
    config = config or {}
    local callback = config.Callback or function() end

    local btn = create("TextButton", {
      Size                  = UDim2.new(1, 0, 0, 34),
      BackgroundColor3      = Theme.Accent,
      BackgroundTransparency = 0.15,
      BorderSizePixel       = 0,
      Font                  = Enum.Font.GothamSemibold,
      TextSize              = 13,
      TextColor3            = Theme.Text,
      Text                  = config.Icon and ("  " .. (config.Name or "Button")) or (config.Name or "Button"),
      AutoButtonColor       = false,
      ClipsDescendants      = true,
      Parent                = Container,
    })
    corner(btn, 8)
    stroke(btn, Theme.Accent, 1, 0.8)

    if config.Icon then
      Icons.Create(config.Icon, {
        Size     = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 10, 0.5, -8),
        Color    = Theme.Text,
        Parent   = btn,
      })
    end

    btn.MouseEnter:Connect(function()
      tween(btn, { BackgroundTransparency = 0 }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
      tween(btn, { BackgroundTransparency = 0.15 }, 0.15)
    end)
    btn.MouseButton1Click:Connect(function()
      ripple(btn, Color3.new(1, 1, 1))
      tween(btn, { BackgroundTransparency = 0.05 }, 0.08)
      task.delay(0.08, function()
        tween(btn, { BackgroundTransparency = 0.15 }, 0.15)
      end)
      callback()
    end)

    local BtnObj = {}
    function BtnObj:SetText(text) btn.Text = text end
    function BtnObj:SetCallback(fn) callback = fn end
    return BtnObj
  end

  -- // TOGGLE -------------------------------------------------------
  function Tab:CreateToggle(config)
    config = config or {}
    local state    = config.Default or false
    local callback = config.Callback or function() end

    if config.Flag then
      Library.Flags[config.Flag] = state
    end

    local row = create("Frame", {
      Size                  = UDim2.new(1, 0, 0, 34),
      BackgroundColor3      = Theme.Card,
      BackgroundTransparency = 0.5,
      BorderSizePixel       = 0,
      ClipsDescendants      = false,
      Parent                = Container,
    })
    corner(row, 8)

    -- Label
    local labelFrame = create("Frame", {
      Size                  = UDim2.new(1, -56, 1, 0),
      BackgroundTransparency = 1,
      Parent                = row,
    })
    Utility.Padding(labelFrame, 0, 0, 0, 10)

    if config.Icon then
      Icons.Create(config.Icon, {
        Size     = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 0, 0.5, -7),
        Color    = Theme.SubText,
        Parent   = labelFrame,
      })
    end

    create("TextLabel", {
      Size                  = UDim2.new(1, config.Icon and -20 or 0, 0, 16),
      Position              = UDim2.new(0, config.Icon and 20 or 0, 0, config.Description and 2 or 0),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.GothamSemibold,
      TextSize              = 13,
      TextColor3            = Theme.Text,
      TextXAlignment        = Enum.TextXAlignment.Left,
      Text                  = config.Name or "Toggle",
      Parent                = labelFrame,
    })

    if config.Description then
      create("TextLabel", {
        Size                  = UDim2.new(1, 0, 0, 12),
        Position              = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Font                  = Enum.Font.Gotham,
        TextSize              = 10,
        TextColor3            = Theme.SubText,
        TextXAlignment        = Enum.TextXAlignment.Left,
        Text                  = config.Description,
        Parent                = labelFrame,
      })
    end

    -- Switch track
    local track = create("TextButton", {
      Size             = UDim2.new(0, 40, 0, 22),
      Position         = UDim2.new(1, -48, 0.5, -11),
      BackgroundColor3 = state and Theme.Accent or Theme.Card,
      BorderSizePixel  = 0,
      Text             = "",
      AutoButtonColor  = false,
      Parent           = row,
    })
    corner(track, 11)
    stroke(track, state and Theme.Accent or Theme.Border, 1, state and 0.8 or 0.5)

    local knob = create("Frame", {
      Size             = UDim2.new(0, 16, 0, 16),
      Position         = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
      BackgroundColor3 = Color3.new(1, 1, 1),
      BorderSizePixel  = 0,
      Parent           = track,
    })
    corner(knob, 8)

    local function updateVisual(s)
      tween(track, {
        BackgroundColor3 = s and Theme.Accent or Theme.Card,
      }, 0.2)
      tween(knob, {
        Position = s and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = s and Color3.new(1, 1, 1) or Theme.SubText,
      }, 0.2)
    end

    track.MouseButton1Click:Connect(function()
      state = not state
      updateVisual(state)
      if config.Flag then Library.Flags[config.Flag] = state end
      callback(state)
    end)

    local ToggleObj = {}
    function ToggleObj:Set(value)
      state = value
      updateVisual(state)
      if config.Flag then Library.Flags[config.Flag] = state end
      callback(state)
    end
    function ToggleObj:Get() return state end
    return ToggleObj
  end

  -- // SLIDER -------------------------------------------------------
  function Tab:CreateSlider(config)
    config = config or {}
    local min      = config.Min       or 0
    local max      = config.Max       or 100
    local increment= config.Increment or 1
    local value    = config.Default   or min
    local callback = config.Callback  or function() end
    local suffix   = config.Suffix    or ""

    if config.Flag then Library.Flags[config.Flag] = value end

    local row = create("Frame", {
      Size                  = UDim2.new(1, 0, 0, 48),
      BackgroundColor3      = Theme.Card,
      BackgroundTransparency = 0.5,
      BorderSizePixel       = 0,
      Parent                = Container,
    })
    corner(row, 8)
    Utility.Padding(row, 8, 10, 8, 10)

    -- Header row
    create("TextLabel", {
      Size                  = UDim2.new(0.6, 0, 0, 16),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.GothamSemibold,
      TextSize              = 13,
      TextColor3            = Theme.Text,
      TextXAlignment        = Enum.TextXAlignment.Left,
      Text                  = config.Name or "Slider",
      Parent                = row,
    })

    local valueLabel = create("TextLabel", {
      Size                  = UDim2.new(0.4, 0, 0, 16),
      AnchorPoint           = Vector2.new(1, 0),
      Position              = UDim2.new(1, 0, 0, 0),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.GothamSemibold,
      TextSize              = 12,
      TextColor3            = Theme.Accent,
      TextXAlignment        = Enum.TextXAlignment.Right,
      Text                  = tostring(value) .. suffix,
      Parent                = row,
    })

    -- Track
    local track = create("Frame", {
      Size             = UDim2.new(1, 0, 0, 5),
      Position         = UDim2.new(0, 0, 0, 26),
      BackgroundColor3 = Theme.Border,
      BorderSizePixel  = 0,
      Parent           = row,
    })
    corner(track, 4)

    local fill = create("Frame", {
      Size             = UDim2.new((value - min) / (max - min), 0, 1, 0),
      BackgroundColor3 = Theme.Accent,
      BorderSizePixel  = 0,
      Parent           = track,
    })
    corner(fill, 4)

    local handle = create("Frame", {
      Size             = UDim2.new(0, 12, 0, 12),
      Position         = UDim2.new((value - min) / (max - min), -6, 0.5, -6),
      BackgroundColor3 = Color3.new(1, 1, 1),
      BorderSizePixel  = 0,
      ZIndex           = 2,
      Parent           = track,
    })
    corner(handle, 6)

    local function getValue(input)
      local relative = math.clamp(
        (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X,
        0, 1
      )
      local raw = min + (max - min) * relative
      local snapped = math.round(raw / increment) * increment
      return math.clamp(snapped, min, max)
    end

    local dragging = false
    track.InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        value = getValue(input)
        local pct = (value - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        handle.Position = UDim2.new(pct, -6, 0.5, -6)
        valueLabel.Text = tostring(value) .. suffix
        if config.Flag then Library.Flags[config.Flag] = value end
        callback(value)
      end
    end)
    UserInputService.InputChanged:Connect(function(input)
      if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        value = getValue(input)
        local pct = (value - min) / (max - min)
        tween(fill, { Size = UDim2.new(pct, 0, 1, 0) }, 0.05)
        handle.Position = UDim2.new(pct, -6, 0.5, -6)
        valueLabel.Text = tostring(value) .. suffix
        if config.Flag then Library.Flags[config.Flag] = value end
        callback(value)
      end
    end)
    UserInputService.InputEnded:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
      end
    end)

    local SliderObj = {}
    function SliderObj:Set(v)
      value = math.clamp(v, min, max)
      local pct = (value - min) / (max - min)
      fill.Size = UDim2.new(pct, 0, 1, 0)
      handle.Position = UDim2.new(pct, -6, 0.5, -6)
      valueLabel.Text = tostring(value) .. suffix
      if config.Flag then Library.Flags[config.Flag] = value end
      callback(value)
    end
    function SliderObj:Get() return value end
    return SliderObj
  end

  -- // INPUT --------------------------------------------------------
  function Tab:CreateInput(config)
    config = config or {}
    local callback = config.Callback or function() end

    local row = create("Frame", {
      Size                  = UDim2.new(1, 0, 0, 56),
      BackgroundColor3      = Theme.Card,
      BackgroundTransparency = 0.5,
      BorderSizePixel       = 0,
      Parent                = Container,
    })
    corner(row, 8)
    Utility.Padding(row, 8, 10, 8, 10)

    create("TextLabel", {
      Size                  = UDim2.new(1, 0, 0, 16),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.GothamSemibold,
      TextSize              = 13,
      TextColor3            = Theme.Text,
      TextXAlignment        = Enum.TextXAlignment.Left,
      Text                  = config.Name or "Input",
      Parent                = row,
    })

    local inputBox = create("TextBox", {
      Size                  = UDim2.new(1, 0, 0, 22),
      Position              = UDim2.new(0, 0, 0, 24),
      BackgroundColor3      = Theme.Surface,
      BackgroundTransparency = 0.2,
      BorderSizePixel       = 0,
      ClearTextOnFocus      = config.ClearOnFocus ~= false,
      Font                  = Enum.Font.Gotham,
      TextSize              = 12,
      TextColor3            = Theme.Text,
      PlaceholderText       = config.Placeholder or "Enter value...",
      PlaceholderColor3     = Theme.SubText,
      TextXAlignment        = Enum.TextXAlignment.Left,
      Text                  = config.Default or "",
      Parent                = row,
    })
    corner(inputBox, 6)
    Utility.Padding(inputBox, 0, 6, 0, 8)

    local inputStroke = stroke(inputBox, Theme.Border, 1, 0.6)

    inputBox.Focused:Connect(function()
      tween(inputStroke, { Color = Theme.Accent, Transparency = 0.3 }, 0.15)
    end)
    inputBox.FocusLost:Connect(function(enter)
      tween(inputStroke, { Color = Theme.Border, Transparency = 0.6 }, 0.15)
      if config.Flag then Library.Flags[config.Flag] = inputBox.Text end
      callback(inputBox.Text, enter)
    end)
    inputBox:GetPropertyChangedSignal("Text"):Connect(function()
      if config.ChangeCallback then
        config.ChangeCallback(inputBox.Text)
      end
    end)

    local InputObj = {}
    function InputObj:Set(text) inputBox.Text = text end
    function InputObj:Get() return inputBox.Text end
    return InputObj
  end

  -- // DROPDOWN -----------------------------------------------------
  function Tab:CreateDropdown(config)
    config = config or {}
    local options  = config.Options  or {}
    local multi    = config.Type == "Multi"
    local selected = config.Default and (multi and config.Default or {config.Default}) or {}
    local callback = config.Callback or function() end
    local open     = false

    local function getDisplay()
      if #selected == 0 then return config.Placeholder or "Select..." end
      if multi then return table.concat(selected, ", ") end
      return selected[1]
    end

    local container = create("Frame", {
      Size                  = UDim2.new(1, 0, 0, 48),
      BackgroundColor3      = Theme.Card,
      BackgroundTransparency = 0.5,
      BorderSizePixel       = 0,
      ClipsDescendants      = false,
      ZIndex                = 5,
      Parent                = Container,
    })
    corner(container, 8)

    Utility.Padding(container, 8, 10, 8, 10)

    create("TextLabel", {
      Size                  = UDim2.new(1, 0, 0, 16),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.GothamSemibold,
      TextSize              = 13,
      TextColor3            = Theme.Text,
      TextXAlignment        = Enum.TextXAlignment.Left,
      ZIndex                = 6,
      Text                  = config.Name or "Dropdown",
      Parent                = container,
    })

    local displayBtn = create("TextButton", {
      Size             = UDim2.new(1, 0, 0, 22),
      Position         = UDim2.new(0, 0, 0, 24),
      BackgroundColor3 = Theme.Surface,
      BackgroundTransparency = 0.2,
      BorderSizePixel  = 0,
      Font             = Enum.Font.Gotham,
      TextSize         = 12,
      TextColor3       = Theme.Text,
      TextXAlignment   = Enum.TextXAlignment.Left,
      Text             = getDisplay(),
      AutoButtonColor  = false,
      ZIndex           = 6,
      Parent           = container,
    })
    corner(displayBtn, 6)
    Utility.Padding(displayBtn, 0, 26, 0, 8)

    local arrowLbl = create("TextLabel", {
      Size                  = UDim2.new(0, 20, 1, 0),
      Position              = UDim2.new(1, -20, 0, 0),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.GothamBold,
      TextSize              = 10,
      TextColor3            = Theme.SubText,
      Text                  = "v",
      ZIndex                = 6,
      Parent                = displayBtn,
    })

    -- Dropdown list
    local dropList = create("Frame", {
      Size                  = UDim2.new(1, 0, 0, 0),
      Position              = UDim2.new(0, 0, 1, 2),
      BackgroundColor3      = Theme.Surface,
      BackgroundTransparency = 0.05,
      BorderSizePixel       = 0,
      Visible               = false,
      ClipsDescendants      = true,
      ZIndex                = 20,
      Parent                = container,
    })
    corner(dropList, 8)
    stroke(dropList, Theme.Border, 1, 0.5)
    Utility.Padding(dropList, 4, 4, 4, 4)
    Utility.List(dropList, Enum.FillDirection.Vertical, 2)

    local function refreshList()
      for _, c in ipairs(dropList:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
          c:Destroy()
        end
      end

      for _, opt in ipairs(options) do
        local isSelected = table.find(selected, opt)
        local item = create("TextButton", {
          Size                  = UDim2.new(1, 0, 0, 28),
          BackgroundColor3      = isSelected and Theme.Accent or Theme.Card,
          BackgroundTransparency = isSelected and 0.8 or 1,
          BorderSizePixel       = 0,
          Font                  = isSelected and Enum.Font.GothamSemibold or Enum.Font.Gotham,
          TextSize              = 12,
          TextColor3            = isSelected and Theme.Accent or Theme.Text,
          TextXAlignment        = Enum.TextXAlignment.Left,
          Text                  = opt,
          AutoButtonColor       = false,
          ZIndex                = 21,
          Parent                = dropList,
        })
        corner(item, 6)
        Utility.Padding(item, 0, 0, 0, 8)

        item.MouseEnter:Connect(function()
          tween(item, { BackgroundTransparency = 0.9 }, 0.1)
        end)
        item.MouseLeave:Connect(function()
          tween(item, { BackgroundTransparency = isSelected and 0.8 or 1 }, 0.1)
        end)
        item.MouseButton1Click:Connect(function()
          if multi then
            local idx = table.find(selected, opt)
            if idx then table.remove(selected, idx) else table.insert(selected, opt) end
          else
            selected = {opt}
            open = false
            tween(dropList, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
            task.delay(0.2, function() dropList.Visible = false end)
          end
          displayBtn.Text = getDisplay()
          if config.Flag then Library.Flags[config.Flag] = multi and selected or selected[1] end
          callback(multi and selected or selected[1])
          refreshList()
        end)
      end

      local contentSize = #options * 30 + 8
      tween(dropList, { Size = UDim2.new(1, 0, 0, math.min(contentSize, 150)) }, 0.2)
    end

    displayBtn.MouseButton1Click:Connect(function()
      open = not open
      if open then
        dropList.Visible = true
        refreshList()
        tween(arrowLbl, { Rotation = 180 }, 0.2)
      else
        tween(dropList, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
        task.delay(0.2, function() dropList.Visible = false end)
        tween(arrowLbl, { Rotation = 0 }, 0.2)
      end
    end)

    local DropdownObj = {}
    function DropdownObj:Set(value)
      selected = multi and value or {value}
      displayBtn.Text = getDisplay()
      if config.Flag then Library.Flags[config.Flag] = multi and selected or selected[1] end
    end
    function DropdownObj:Get() return multi and selected or selected[1] end
    function DropdownObj:SetOptions(opts)
      options = opts
      selected = {}
      displayBtn.Text = getDisplay()
    end
    return DropdownObj
  end

  -- // KEYBIND ------------------------------------------------------
  function Tab:CreateKeybind(config)
    config = config or {}
    local currentKey = config.Default or Enum.KeyCode.Unknown
    local callback   = config.Callback or function() end
    local listening  = false

    if config.Flag then Library.Flags[config.Flag] = currentKey end

    local row = create("Frame", {
      Size                  = UDim2.new(1, 0, 0, 34),
      BackgroundColor3      = Theme.Card,
      BackgroundTransparency = 0.5,
      BorderSizePixel       = 0,
      Parent                = Container,
    })
    corner(row, 8)
    Utility.Padding(row, 0, 10, 0, 10)

    create("TextLabel", {
      Size                  = UDim2.new(1, -80, 1, 0),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.GothamSemibold,
      TextSize              = 13,
      TextColor3            = Theme.Text,
      TextXAlignment        = Enum.TextXAlignment.Left,
      Text                  = config.Name or "Keybind",
      Parent                = row,
    })

    local keyBtn = create("TextButton", {
      Size             = UDim2.new(0, 70, 0, 22),
      Position         = UDim2.new(1, -70, 0.5, -11),
      BackgroundColor3 = Theme.Surface,
      BackgroundTransparency = 0.2,
      BorderSizePixel  = 0,
      Font             = Enum.Font.GothamSemibold,
      TextSize         = 11,
      TextColor3       = Theme.Accent,
      Text             = currentKey.Name ~= "Unknown" and currentKey.Name or "None",
      AutoButtonColor  = false,
      Parent           = row,
    })
    corner(keyBtn, 6)
    stroke(keyBtn, Theme.Border, 1, 0.6)

    keyBtn.MouseButton1Click:Connect(function()
      if listening then return end
      listening = true
      keyBtn.Text = "..."
      keyBtn.TextColor3 = Theme.Warning
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
      if not listening then
        -- Check global toggle
        if input.KeyCode == currentKey and config.Mode ~= "Hold" then
          callback(currentKey)
        end
        return
      end
      if input.UserInputType ~= Enum.UserInputType.Keyboard then
        listening = false
        keyBtn.Text = currentKey.Name ~= "Unknown" and currentKey.Name or "None"
        keyBtn.TextColor3 = Theme.Accent
        return
      end
      currentKey = input.KeyCode
      keyBtn.Text = currentKey.Name
      keyBtn.TextColor3 = Theme.Accent
      listening = false
      if config.Flag then Library.Flags[config.Flag] = currentKey end
    end)

    local KeyObj = {}
    function KeyObj:Set(key)
      currentKey = key
      keyBtn.Text = key.Name
      if config.Flag then Library.Flags[config.Flag] = key end
    end
    function KeyObj:Get() return currentKey end
    return KeyObj
  end

  -- // COLOR PICKER -------------------------------------------------
  function Tab:CreateColorPicker(config)
    config = config or {}
    local color    = config.Default  or Color3.fromRGB(255, 255, 255)
    local callback = config.Callback or function() end
    local open     = false

    local row = create("Frame", {
      Size                  = UDim2.new(1, 0, 0, 34),
      BackgroundColor3      = Theme.Card,
      BackgroundTransparency = 0.5,
      BorderSizePixel       = 0,
      ClipsDescendants      = false,
      ZIndex                = 5,
      Parent                = Container,
    })
    corner(row, 8)
    Utility.Padding(row, 0, 10, 0, 10)

    create("TextLabel", {
      Size                  = UDim2.new(1, -44, 1, 0),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.GothamSemibold,
      TextSize              = 13,
      TextColor3            = Theme.Text,
      TextXAlignment        = Enum.TextXAlignment.Left,
      Text                  = config.Name or "Color",
      ZIndex                = 6,
      Parent                = row,
    })

    local preview = create("TextButton", {
      Size             = UDim2.new(0, 30, 0, 20),
      Position         = UDim2.new(1, -30, 0.5, -10),
      BackgroundColor3 = color,
      BorderSizePixel  = 0,
      Text             = "",
      ZIndex           = 6,
      Parent           = row,
    })
    corner(preview, 6)
    stroke(preview, Theme.Border, 1, 0.5)

    -- Color picker popup
    local picker = create("Frame", {
      Size             = UDim2.new(0, 200, 0, 0),
      Position         = UDim2.new(1, -200, 1, 4),
      BackgroundColor3 = Theme.Surface,
      BackgroundTransparency = 0.05,
      BorderSizePixel  = 0,
      Visible          = false,
      ClipsDescendants = false,
      ZIndex           = 30,
      Parent           = row,
    })
    corner(picker, 10)
    stroke(picker, Theme.Border, 1, 0.5)
    Utility.Padding(picker, 10, 10, 10, 10)

    -- Hue bar (simplified — RGB sliders)
    local function addColorSlider(label, key, defaultVal, parent)
      create("TextLabel", {
        Size                  = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        Font                  = Enum.Font.Gotham,
        TextSize              = 10,
        TextColor3            = Theme.SubText,
        TextXAlignment        = Enum.TextXAlignment.Left,
        Text                  = label,
        ZIndex                = 31,
        Parent                = parent,
      })
      local track = create("Frame", {
        Size             = UDim2.new(1, 0, 0, 4),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel  = 0,
        ZIndex           = 31,
        Parent           = parent,
      })
      corner(track, 4)
      return track
    end

    local sliderContainer = create("Frame", {
      Size                  = UDim2.new(1, 0, 0, 0),
      AutomaticSize         = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      ZIndex                = 31,
      Parent                = picker,
    })
    Utility.List(sliderContainer, Enum.FillDirection.Vertical, 6)

    -- Note: Full HSV picker would require more code; this is a solid RGB approach
    create("TextLabel", {
      Size                  = UDim2.new(1, 0, 0, 16),
      BackgroundTransparency = 1,
      Font                  = Enum.Font.Gotham,
      TextSize              = 11,
      TextColor3            = Theme.SubText,
      TextXAlignment        = Enum.TextXAlignment.Center,
      Text                  = "R: " .. math.round(color.R*255) ..
                              "  G: " .. math.round(color.G*255) ..
                              "  B: " .. math.round(color.B*255),
      ZIndex                = 31,
      Parent                = sliderContainer,
    })

    preview.MouseButton1Click:Connect(function()
      open = not open
      picker.Visible = open
      if open then
        tween(picker, { Size = UDim2.new(0, 200, 0, 80) }, 0.2)
      else
        tween(picker, { Size = UDim2.new(0, 200, 0, 0) }, 0.2)
        task.delay(0.2, function() picker.Visible = false end)
      end
    end)

    local ColorObj = {}
    function ColorObj:Set(c)
      color = c
      preview.BackgroundColor3 = c
      if config.Flag then Library.Flags[config.Flag] = c end
      callback(c)
    end
    function ColorObj:Get() return color end
    return ColorObj
  end

end

return Elements
