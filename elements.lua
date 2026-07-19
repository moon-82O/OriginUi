local UserInputService = game:GetService("UserInputService")

local Elements = {}

function Elements.Attach(Tab, U, Theme, Container, Icons, Library)

	local function titleRow(config, controlW)
		local hasDesc = config.Desc ~= nil and config.Desc ~= ""
		local row = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, hasDesc and 52 or 40),
			BackgroundColor3       = Theme.Card,
			BackgroundTransparency = 0.35,
			BorderSizePixel        = 0,
			Parent                 = Container,
		})
		U.Corner(row, 8)
		U.Padding(row, 0, 12, 0, 12)

		local left = U.New("Frame", {
			Size                   = UDim2.new(1, -(controlW + 10), 1, 0),
			BackgroundTransparency = 1,
			Parent                 = row,
		})
		U.New("UIListLayout", {
			FillDirection     = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding           = UDim.new(0, 2),
			SortOrder         = Enum.SortOrder.LayoutOrder,
			Parent            = left,
		})
		U.New("TextLabel", {
			Size                   = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.GothamSemibold,
			TextSize               = 13,
			TextColor3             = Theme.Text,
			TextXAlignment         = Enum.TextXAlignment.Left,
			Text                   = config.Name or "Element",
			Parent                 = left,
		})
		if hasDesc then
			U.New("TextLabel", {
				Size                   = UDim2.new(1, 0, 0, 14),
				BackgroundTransparency = 1,
				Font                   = Enum.Font.Gotham,
				TextSize               = 11,
				TextColor3             = Theme.SubText,
				TextXAlignment         = Enum.TextXAlignment.Left,
				Text                   = config.Desc,
				Parent                 = left,
			})
		end
		return row
	end

	function Tab:CreateSection(config)
		config = config or {}
		local section = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, 0),
			AutomaticSize          = Enum.AutomaticSize.Y,
			BackgroundColor3       = Theme.Card,
			BackgroundTransparency = 0.5,
			BorderSizePixel        = 0,
			Parent                 = Container,
		})
		U.Corner(section, 8)
		U.Padding(section, 10, 10, 10, 10)

		local headerRow = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, 22),
			BackgroundTransparency = 1,
			Parent                 = section,
		})
		U.New("UIListLayout", {
			FillDirection     = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding           = UDim.new(0, 6),
			SortOrder         = Enum.SortOrder.LayoutOrder,
			Parent            = headerRow,
		})
		if config.Icon then
			Icons.Create(config.Icon, {
				Size   = UDim2.new(0, 13, 0, 13),
				Color  = Theme.Accent,
				Parent = headerRow,
			})
		end
		U.New("TextLabel", {
			Size                   = UDim2.new(0, 0, 1, 0),
			AutomaticSize          = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Font                   = Enum.Font.GothamBold,
			TextSize               = 11,
			TextColor3             = Theme.Accent,
			TextXAlignment         = Enum.TextXAlignment.Left,
			Text                   = (config.Name or "Section"):upper(),
			Parent                 = headerRow,
		})

		U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, 1),
			Position               = UDim2.new(0, 0, 0, 26),
			BackgroundColor3       = Theme.Border,
			BackgroundTransparency = 0.5,
			BorderSizePixel        = 0,
			Parent                 = section,
		})

		local inner = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, 0),
			Position               = UDim2.new(0, 0, 0, 32),
			AutomaticSize          = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent                 = section,
		})
		U.List(inner, Enum.FillDirection.Vertical, 4)

		local SectionTab = {}
		Elements.Attach(SectionTab, U, Theme, inner, Icons, Library)
		return SectionTab
	end

	function Tab:CreateLabel(config)
		config = config or {}
		local lbl = U.New("TextLabel", {
			Size                   = UDim2.new(1, 0, 0, 0),
			AutomaticSize          = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font                   = Enum.Font.Gotham,
			TextSize               = 11,
			TextColor3             = Theme.SubText,
			TextXAlignment         = Enum.TextXAlignment.Left,
			TextWrapped            = true,
			Text                   = config.Text or "",
			Parent                 = Container,
		})
		local obj = {}
		function obj:Set(text) lbl.Text = text end
		return obj
	end

	function Tab:CreateDivider()
		U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, 1),
			BackgroundColor3       = Theme.Border,
			BackgroundTransparency = 0.5,
			BorderSizePixel        = 0,
			Parent                 = Container,
		})
	end

	function Tab:CreateButton(config)
		config = config or {}
		local cb      = config.Callback or function() end
		local hasDesc = config.Desc ~= nil

		local row = U.New("TextButton", {
			Size                   = UDim2.new(1, 0, 0, hasDesc and 52 or 40),
			BackgroundColor3       = Theme.Card,
			BackgroundTransparency = 0.35,
			BorderSizePixel        = 0,
			Text                   = "",
			AutoButtonColor        = false,
			ClipsDescendants       = true,
			Parent                 = Container,
		})
		U.Corner(row, 8)
		U.Padding(row, 0, 12, 0, 12)

		local left = U.New("Frame", {
			Size                   = UDim2.new(1, -30, 1, 0),
			BackgroundTransparency = 1,
			Parent                 = row,
		})
		U.New("UIListLayout", {
			FillDirection     = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding           = UDim.new(0, 2),
			SortOrder         = Enum.SortOrder.LayoutOrder,
			Parent            = left,
		})
		U.New("TextLabel", {
			Size                   = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.GothamSemibold,
			TextSize               = 13,
			TextColor3             = Theme.Text,
			TextXAlignment         = Enum.TextXAlignment.Left,
			Text                   = config.Name or "Button",
			Parent                 = left,
		})
		if hasDesc then
			U.New("TextLabel", {
				Size                   = UDim2.new(1, 0, 0, 14),
				BackgroundTransparency = 1,
				Font                   = Enum.Font.Gotham,
				TextSize               = 11,
				TextColor3             = Theme.SubText,
				TextXAlignment         = Enum.TextXAlignment.Left,
				Text                   = config.Desc,
				Parent                 = left,
			})
		end

		Icons.Create(config.Icon or "mouse-pointer-click", {
			Size        = UDim2.new(0, 18, 0, 18),
			Position    = UDim2.new(1, 0, 0.5, -9),
			AnchorPoint = Vector2.new(1, 0),
			Color       = Theme.SubText,
			Parent      = row,
		})

		row.MouseEnter:Connect(function()
			U.Tween(row, { BackgroundTransparency = 0.2 }, 0.12)
		end)
		row.MouseLeave:Connect(function()
			U.Tween(row, { BackgroundTransparency = 0.35 }, 0.12)
		end)
		row.MouseButton1Click:Connect(function()
			U.Ripple(row, Color3.new(1, 1, 1))
			U.Tween(row, { BackgroundTransparency = 0.1 }, 0.06)
			task.delay(0.06, function()
				U.Tween(row, { BackgroundTransparency = 0.35 }, 0.15)
			end)
			task.spawn(cb)
		end)

		local obj = {}
		function obj:SetCallback(fn) cb = fn end
		return obj
	end

	function Tab:CreateToggle(config)
		config = config or {}
		local state   = config.Default or false
		local cb      = config.Callback or function() end
		local hasDesc = config.Desc ~= nil
		if config.Flag then Library.Flags[config.Flag] = state end

		local row = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, hasDesc and 52 or 40),
			BackgroundColor3       = Theme.Card,
			BackgroundTransparency = 0.35,
			BorderSizePixel        = 0,
			Parent                 = Container,
		})
		U.Corner(row, 8)
		U.Padding(row, 0, 12, 0, 12)

		local left = U.New("Frame", {
			Size                   = UDim2.new(1, -58, 1, 0),
			BackgroundTransparency = 1,
			Parent                 = row,
		})
		U.New("UIListLayout", {
			FillDirection     = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding           = UDim.new(0, 2),
			SortOrder         = Enum.SortOrder.LayoutOrder,
			Parent            = left,
		})
		U.New("TextLabel", {
			Size                   = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.GothamSemibold,
			TextSize               = 13,
			TextColor3             = Theme.Text,
			TextXAlignment         = Enum.TextXAlignment.Left,
			Text                   = config.Name or "Toggle",
			Parent                 = left,
		})
		if hasDesc then
			U.New("TextLabel", {
				Size                   = UDim2.new(1, 0, 0, 14),
				BackgroundTransparency = 1,
				Font                   = Enum.Font.Gotham,
				TextSize               = 11,
				TextColor3             = Theme.SubText,
				TextXAlignment         = Enum.TextXAlignment.Left,
				Text                   = config.Desc,
				Parent                 = left,
			})
		end

		local track = U.New("TextButton", {
			Size             = UDim2.new(0, 44, 0, 24),
			Position         = UDim2.new(1, 0, 0.5, -12),
			AnchorPoint      = Vector2.new(1, 0),
			BackgroundColor3 = state and Theme.Accent or Theme.Surface,
			BorderSizePixel  = 0,
			Text             = "",
			AutoButtonColor  = false,
			Parent           = row,
		})
		U.Corner(track, 12)
		local trackStroke = U.Stroke(track, state and Theme.Accent or Theme.Border, 1, state and 0.6 or 0.4)

		local knob = U.New("Frame", {
			Size             = UDim2.new(0, 18, 0, 18),
			Position         = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
			BackgroundColor3 = state and Color3.new(1, 1, 1) or Theme.SubText,
			BorderSizePixel  = 0,
			Parent           = track,
		})
		U.Corner(knob, 9)

		local function updateViz(s)
			U.Tween(track, { BackgroundColor3 = s and Theme.Accent or Theme.Surface }, 0.2)
			U.Tween(trackStroke, { Color = s and Theme.Accent or Theme.Border, Transparency = s and 0.6 or 0.4 }, 0.2)
			U.Tween(knob, {
				Position         = s and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
				BackgroundColor3 = s and Color3.new(1, 1, 1) or Theme.SubText,
			}, 0.2)
		end

		track.MouseButton1Click:Connect(function()
			state = not state
			updateViz(state)
			if config.Flag then Library.Flags[config.Flag] = state end
			cb(state)
		end)

		local obj = {}
		function obj:Set(v)
			state = v
			updateViz(state)
			if config.Flag then Library.Flags[config.Flag] = state end
			cb(state)
		end
		function obj:Get() return state end
		return obj
	end

	function Tab:CreateSlider(config)
		config    = config or {}
		local min = config.Min       or 0
		local max = config.Max       or 100
		local step= config.Increment or 1
		local val = math.clamp(config.Default or min, min, max)
		local cb  = config.Callback  or function() end
		local suf = config.Suffix    or ""
		local hasDesc = config.Desc ~= nil
		if config.Flag then Library.Flags[config.Flag] = val end

		local rowH = hasDesc and 64 or 52
		local row = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, rowH),
			BackgroundColor3       = Theme.Card,
			BackgroundTransparency = 0.35,
			BorderSizePixel        = 0,
			Parent                 = Container,
		})
		U.Corner(row, 8)
		U.Padding(row, 10, 12, 10, 12)

		local topRow = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, 18),
			BackgroundTransparency = 1,
			Parent                 = row,
		})
		U.New("TextLabel", {
			Size                   = UDim2.new(0.6, 0, 1, 0),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.GothamSemibold,
			TextSize               = 13,
			TextColor3             = Theme.Text,
			TextXAlignment         = Enum.TextXAlignment.Left,
			Text                   = config.Name or "Slider",
			Parent                 = topRow,
		})
		local valLabel = U.New("TextLabel", {
			Size                   = UDim2.new(0.4, 0, 1, 0),
			AnchorPoint            = Vector2.new(1, 0),
			Position               = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.GothamSemibold,
			TextSize               = 12,
			TextColor3             = Theme.Accent,
			TextXAlignment         = Enum.TextXAlignment.Right,
			Text                   = tostring(val) .. suf,
			Parent                 = topRow,
		})

		if hasDesc then
			U.New("TextLabel", {
				Size                   = UDim2.new(1, 0, 0, 13),
				Position               = UDim2.new(0, 0, 0, 20),
				BackgroundTransparency = 1,
				Font                   = Enum.Font.Gotham,
				TextSize               = 11,
				TextColor3             = Theme.SubText,
				TextXAlignment         = Enum.TextXAlignment.Left,
				Text                   = config.Desc,
				Parent                 = row,
			})
		end

		local trackY = hasDesc and 38 or 26
		local track = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, 4),
			Position               = UDim2.new(0, 0, 0, trackY),
			BackgroundColor3       = Theme.Border,
			BackgroundTransparency = 0.3,
			BorderSizePixel        = 0,
			Parent                 = row,
		})
		U.Corner(track, 4)

		local pct = (val - min) / (max - min)
		local fill = U.New("Frame", {
			Size             = UDim2.new(pct, 0, 1, 0),
			BackgroundColor3 = Theme.Accent,
			BorderSizePixel  = 0,
			Parent           = track,
		})
		U.Corner(fill, 4)

		local thumb = U.New("Frame", {
			Size             = UDim2.new(0, 14, 0, 14),
			Position         = UDim2.new(pct, -7, 0.5, -7),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel  = 0,
			ZIndex           = 2,
			Parent           = track,
		})
		U.Corner(thumb, 7)
		U.Stroke(thumb, Theme.Accent, 2, 0.3)

		local function applyVal(input)
			local rel = math.clamp(
				(input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			local snapped = math.round((min + (max - min) * rel - min) / step) * step + min
			val = math.clamp(snapped, min, max)
			local p = (val - min) / (max - min)
			fill.Size = UDim2.new(p, 0, 1, 0)
			thumb.Position = UDim2.new(p, -7, 0.5, -7)
			valLabel.Text = tostring(val) .. suf
			if config.Flag then Library.Flags[config.Flag] = val end
			cb(val)
		end

		local dragging = false
		track.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				applyVal(input)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				applyVal(input)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
		end)

		local obj = {}
		function obj:Set(v)
			val = math.clamp(v, min, max)
			local p = (val - min) / (max - min)
			fill.Size = UDim2.new(p, 0, 1, 0)
			thumb.Position = UDim2.new(p, -7, 0.5, -7)
			valLabel.Text = tostring(val) .. suf
			if config.Flag then Library.Flags[config.Flag] = val end
			cb(val)
		end
		function obj:Get() return val end
		return obj
	end

	function Tab:CreateInput(config)
		config = config or {}
		local cb      = config.Callback or function() end
		local hasDesc = config.Desc ~= nil

		local row = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, hasDesc and 52 or 40),
			BackgroundColor3       = Theme.Card,
			BackgroundTransparency = 0.35,
			BorderSizePixel        = 0,
			Parent                 = Container,
		})
		U.Corner(row, 8)
		U.Padding(row, 0, 12, 0, 12)

		local left = U.New("Frame", {
			Size                   = UDim2.new(1, -162, 1, 0),
			BackgroundTransparency = 1,
			Parent                 = row,
		})
		U.New("UIListLayout", {
			FillDirection     = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding           = UDim.new(0, 2),
			SortOrder         = Enum.SortOrder.LayoutOrder,
			Parent            = left,
		})
		U.New("TextLabel", {
			Size                   = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.GothamSemibold,
			TextSize               = 13,
			TextColor3             = Theme.Text,
			TextXAlignment         = Enum.TextXAlignment.Left,
			Text                   = config.Name or "Input",
			Parent                 = left,
		})
		if hasDesc then
			U.New("TextLabel", {
				Size                   = UDim2.new(1, 0, 0, 14),
				BackgroundTransparency = 1,
				Font                   = Enum.Font.Gotham,
				TextSize               = 11,
				TextColor3             = Theme.SubText,
				TextXAlignment         = Enum.TextXAlignment.Left,
				Text                   = config.Desc,
				Parent                 = left,
			})
		end

		local box = U.New("TextBox", {
			Size              = UDim2.new(0, 150, 0, 28),
			Position          = UDim2.new(1, 0, 0.5, -14),
			AnchorPoint       = Vector2.new(1, 0),
			BackgroundColor3  = Theme.Surface,
			BackgroundTransparency = 0.15,
			BorderSizePixel   = 0,
			ClearTextOnFocus  = config.ClearOnFocus ~= false,
			Font              = Enum.Font.Gotham,
			TextSize          = 12,
			TextColor3        = Theme.Text,
			PlaceholderText   = config.Placeholder or "Enter...",
			PlaceholderColor3 = Theme.SubText,
			TextXAlignment    = Enum.TextXAlignment.Left,
			Text              = config.Default or "",
			Parent            = row,
		})
		U.Corner(box, 6)
		U.Padding(box, 0, 8, 0, 8)
		local boxStroke = U.Stroke(box, Theme.Border, 1, 0.5)

		box.Focused:Connect(function()
			U.Tween(boxStroke, { Color = Theme.Accent, Transparency = 0.2 }, 0.15)
		end)
		box.FocusLost:Connect(function(enter)
			U.Tween(boxStroke, { Color = Theme.Border, Transparency = 0.5 }, 0.15)
			if config.Flag then Library.Flags[config.Flag] = box.Text end
			cb(box.Text, enter)
		end)

		local obj = {}
		function obj:Set(v) box.Text = v end
		function obj:Get() return box.Text end
		return obj
	end

	function Tab:CreateDropdown(config)
		config = config or {}
		local options  = config.Options  or {}
		local multi    = config.Type == "Multi"
		local selected = config.Default and (multi and config.Default or { config.Default }) or {}
		local cb       = config.Callback or function() end
		local open     = false
		local hasDesc  = config.Desc ~= nil

		local function display()
			if #selected == 0 then return config.Placeholder or "Select..." end
			return multi and table.concat(selected, ", ") or selected[1]
		end

		local row = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, hasDesc and 52 or 40),
			BackgroundColor3       = Theme.Card,
			BackgroundTransparency = 0.35,
			BorderSizePixel        = 0,
			ClipsDescendants       = false,
			ZIndex                 = 5,
			Parent                 = Container,
		})
		U.Corner(row, 8)
		U.Padding(row, 0, 12, 0, 12)

		local left = U.New("Frame", {
			Size                   = UDim2.new(1, -162, 1, 0),
			BackgroundTransparency = 1,
			ZIndex                 = 5,
			Parent                 = row,
		})
		U.New("UIListLayout", {
			FillDirection     = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding           = UDim.new(0, 2),
			SortOrder         = Enum.SortOrder.LayoutOrder,
			Parent            = left,
		})
		U.New("TextLabel", {
			Size                   = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.GothamSemibold,
			TextSize               = 13,
			TextColor3             = Theme.Text,
			TextXAlignment         = Enum.TextXAlignment.Left,
			ZIndex                 = 5,
			Text                   = config.Name or "Dropdown",
			Parent                 = left,
		})
		if hasDesc then
			U.New("TextLabel", {
				Size                   = UDim2.new(1, 0, 0, 14),
				BackgroundTransparency = 1,
				Font                   = Enum.Font.Gotham,
				TextSize               = 11,
				TextColor3             = Theme.SubText,
				TextXAlignment         = Enum.TextXAlignment.Left,
				ZIndex                 = 5,
				Text                   = config.Desc,
				Parent                 = left,
			})
		end

		local dropBtn = U.New("TextButton", {
			Size                   = UDim2.new(0, 150, 0, 28),
			Position               = UDim2.new(1, 0, 0.5, -14),
			AnchorPoint            = Vector2.new(1, 0),
			BackgroundColor3       = Theme.Surface,
			BackgroundTransparency = 0.15,
			BorderSizePixel        = 0,
			Font                   = Enum.Font.Gotham,
			TextSize               = 12,
			TextColor3             = Theme.Text,
			TextXAlignment         = Enum.TextXAlignment.Left,
			Text                   = display(),
			AutoButtonColor        = false,
			ZIndex                 = 6,
			Parent                 = row,
		})
		U.Corner(dropBtn, 6)
		U.Padding(dropBtn, 0, 24, 0, 8)
		U.Stroke(dropBtn, Theme.Border, 1, 0.5)

		local arrow = U.New("TextLabel", {
			Size                   = UDim2.new(0, 20, 1, 0),
			Position               = UDim2.new(1, -20, 0, 0),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.GothamBold,
			TextSize               = 9,
			TextColor3             = Theme.SubText,
			Text                   = "▼",
			ZIndex                 = 7,
			Parent                 = dropBtn,
		})

		local list = U.New("Frame", {
			Size                   = UDim2.new(0, 150, 0, 0),
			Position               = UDim2.new(1, 0, 1, 4),
			AnchorPoint            = Vector2.new(1, 0),
			BackgroundColor3       = Theme.Surface,
			BackgroundTransparency = 0.05,
			BorderSizePixel        = 0,
			ClipsDescendants       = true,
			Visible                = false,
			ZIndex                 = 20,
			Parent                 = row,
		})
		U.Corner(list, 8)
		U.Stroke(list, Theme.Border, 1, 0.4)
		U.Padding(list, 4, 4, 4, 4)
		U.List(list, Enum.FillDirection.Vertical, 2)

		local function buildList()
			for _, c in ipairs(list:GetChildren()) do
				if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
			end
			for _, opt in ipairs(options) do
				local sel = table.find(selected, opt) ~= nil
				local item = U.New("TextButton", {
					Size                   = UDim2.new(1, 0, 0, 28),
					BackgroundColor3       = sel and Theme.Accent or Theme.Card,
					BackgroundTransparency = sel and 0.8 or 1,
					BorderSizePixel        = 0,
					Font                   = sel and Enum.Font.GothamSemibold or Enum.Font.Gotham,
					TextSize               = 12,
					TextColor3             = sel and Theme.Accent or Theme.Text,
					TextXAlignment         = Enum.TextXAlignment.Left,
					Text                   = opt,
					AutoButtonColor        = false,
					ZIndex                 = 21,
					Parent                 = list,
				})
				U.Corner(item, 5)
				U.Padding(item, 0, 0, 0, 8)
				item.MouseEnter:Connect(function()
					U.Tween(item, { BackgroundTransparency = sel and 0.75 or 0.9 }, 0.1)
				end)
				item.MouseLeave:Connect(function()
					U.Tween(item, { BackgroundTransparency = sel and 0.8 or 1 }, 0.1)
				end)
				item.MouseButton1Click:Connect(function()
					if multi then
						local idx = table.find(selected, opt)
						if idx then table.remove(selected, idx) else table.insert(selected, opt) end
					else
						selected = { opt }
						open = false
						U.Tween(list, { Size = UDim2.new(0, 150, 0, 0) }, 0.2)
						U.Tween(arrow, { Rotation = 0 }, 0.2)
						task.delay(0.2, function() list.Visible = false end)
					end
					dropBtn.Text = display()
					if config.Flag then Library.Flags[config.Flag] = multi and selected or selected[1] end
					cb(multi and selected or selected[1])
					buildList()
				end)
			end
			U.Tween(list, { Size = UDim2.new(0, 150, 0, math.min(#options * 30 + 8, 160)) }, 0.2)
		end

		dropBtn.MouseButton1Click:Connect(function()
			open = not open
			if open then
				list.Visible = true
				buildList()
				U.Tween(arrow, { Rotation = 180 }, 0.2)
			else
				U.Tween(list, { Size = UDim2.new(0, 150, 0, 0) }, 0.2)
				U.Tween(arrow, { Rotation = 0 }, 0.2)
				task.delay(0.2, function() list.Visible = false end)
			end
		end)

		local obj = {}
		function obj:Set(v)
			selected = multi and v or { v }
			dropBtn.Text = display()
			if config.Flag then Library.Flags[config.Flag] = multi and selected or selected[1] end
		end
		function obj:Get() return multi and selected or selected[1] end
		function obj:SetOptions(opts) options = opts; selected = {}; dropBtn.Text = display() end
		return obj
	end

	function Tab:CreateKeybind(config)
		config = config or {}
		local key       = config.Default or Enum.KeyCode.Unknown
		local cb        = config.Callback or function() end
		local listening = false
		local hasDesc   = config.Desc ~= nil
		if config.Flag then Library.Flags[config.Flag] = key end

		local row = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, hasDesc and 52 or 40),
			BackgroundColor3       = Theme.Card,
			BackgroundTransparency = 0.35,
			BorderSizePixel        = 0,
			Parent                 = Container,
		})
		U.Corner(row, 8)
		U.Padding(row, 0, 12, 0, 12)

		local left = U.New("Frame", {
			Size                   = UDim2.new(1, -90, 1, 0),
			BackgroundTransparency = 1,
			Parent                 = row,
		})
		U.New("UIListLayout", {
			FillDirection     = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding           = UDim.new(0, 2),
			SortOrder         = Enum.SortOrder.LayoutOrder,
			Parent            = left,
		})
		U.New("TextLabel", {
			Size                   = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.GothamSemibold,
			TextSize               = 13,
			TextColor3             = Theme.Text,
			TextXAlignment         = Enum.TextXAlignment.Left,
			Text                   = config.Name or "Keybind",
			Parent                 = left,
		})
		if hasDesc then
			U.New("TextLabel", {
				Size                   = UDim2.new(1, 0, 0, 14),
				BackgroundTransparency = 1,
				Font                   = Enum.Font.Gotham,
				TextSize               = 11,
				TextColor3             = Theme.SubText,
				TextXAlignment         = Enum.TextXAlignment.Left,
				Text                   = config.Desc,
				Parent                 = left,
			})
		end

		local keyBtn = U.New("TextButton", {
			Size                   = UDim2.new(0, 78, 0, 26),
			Position               = UDim2.new(1, 0, 0.5, -13),
			AnchorPoint            = Vector2.new(1, 0),
			BackgroundColor3       = Theme.Surface,
			BackgroundTransparency = 0.15,
			BorderSizePixel        = 0,
			Font                   = Enum.Font.GothamSemibold,
			TextSize               = 11,
			TextColor3             = Theme.Accent,
			Text                   = key ~= Enum.KeyCode.Unknown and key.Name or "None",
			AutoButtonColor        = false,
			Parent                 = row,
		})
		U.Corner(keyBtn, 6)
		U.Stroke(keyBtn, Theme.Border, 1, 0.5)

		keyBtn.MouseButton1Click:Connect(function()
			if listening then return end
			listening = true
			keyBtn.Text = "..."
			keyBtn.TextColor3 = Theme.Warning
		end)

		UserInputService.InputBegan:Connect(function(input)
			if not listening then
				if input.KeyCode == key and key ~= Enum.KeyCode.Unknown then
					cb(key)
				end
				return
			end
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				listening = false
				keyBtn.Text = key ~= Enum.KeyCode.Unknown and key.Name or "None"
				keyBtn.TextColor3 = Theme.Accent
				return
			end
			key = input.KeyCode
			keyBtn.Text = key.Name
			keyBtn.TextColor3 = Theme.Accent
			listening = false
			if config.Flag then Library.Flags[config.Flag] = key end
		end)

		local obj = {}
		function obj:Set(v)
			key = v
			keyBtn.Text = v.Name
			if config.Flag then Library.Flags[config.Flag] = v end
		end
		function obj:Get() return key end
		return obj
	end

	function Tab:CreateColorPicker(config)
		config = config or {}
		local color   = config.Default or Color3.fromRGB(255, 255, 255)
		local cb      = config.Callback or function() end
		local open    = false
		local hasDesc = config.Desc ~= nil
		local r = math.round(color.R * 255)
		local g = math.round(color.G * 255)
		local b = math.round(color.B * 255)

		local row = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, hasDesc and 52 or 40),
			BackgroundColor3       = Theme.Card,
			BackgroundTransparency = 0.35,
			BorderSizePixel        = 0,
			ClipsDescendants       = false,
			ZIndex                 = 5,
			Parent                 = Container,
		})
		U.Corner(row, 8)
		U.Padding(row, 0, 12, 0, 12)

		local left = U.New("Frame", {
			Size                   = UDim2.new(1, -46, 1, 0),
			BackgroundTransparency = 1,
			ZIndex                 = 5,
			Parent                 = row,
		})
		U.New("UIListLayout", {
			FillDirection     = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding           = UDim.new(0, 2),
			SortOrder         = Enum.SortOrder.LayoutOrder,
			Parent            = left,
		})
		U.New("TextLabel", {
			Size                   = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Font                   = Enum.Font.GothamSemibold,
			TextSize               = 13,
			TextColor3             = Theme.Text,
			TextXAlignment         = Enum.TextXAlignment.Left,
			ZIndex                 = 5,
			Text                   = config.Name or "Color",
			Parent                 = left,
		})
		if hasDesc then
			U.New("TextLabel", {
				Size                   = UDim2.new(1, 0, 0, 14),
				BackgroundTransparency = 1,
				Font                   = Enum.Font.Gotham,
				TextSize               = 11,
				TextColor3             = Theme.SubText,
				TextXAlignment         = Enum.TextXAlignment.Left,
				ZIndex                 = 5,
				Text                   = config.Desc,
				Parent                 = left,
			})
		end

		local preview = U.New("TextButton", {
			Size             = UDim2.new(0, 32, 0, 22),
			Position         = UDim2.new(1, 0, 0.5, -11),
			AnchorPoint      = Vector2.new(1, 0),
			BackgroundColor3 = color,
			BorderSizePixel  = 0,
			Text             = "",
			ZIndex           = 6,
			Parent           = row,
		})
		U.Corner(preview, 6)
		U.Stroke(preview, Theme.Border, 1, 0.4)

		local picker = U.New("Frame", {
			Size                   = UDim2.new(0, 210, 0, 0),
			Position               = UDim2.new(1, 0, 1, 6),
			AnchorPoint            = Vector2.new(1, 0),
			BackgroundColor3       = Theme.Surface,
			BackgroundTransparency = 0.05,
			BorderSizePixel        = 0,
			Visible                = false,
			ZIndex                 = 30,
			Parent                 = row,
		})
		U.Corner(picker, 10)
		U.Stroke(picker, Theme.Border, 1, 0.4)
		U.Padding(picker, 10, 10, 10, 10)

		local inner = U.New("Frame", {
			Size                   = UDim2.new(1, 0, 0, 0),
			AutomaticSize          = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ZIndex                 = 31,
			Parent                 = picker,
		})
		U.List(inner, Enum.FillDirection.Vertical, 8)

		local function addChan(label, channel, default)
			local container = U.New("Frame", {
				Size                   = UDim2.new(1, 0, 0, 36),
				BackgroundTransparency = 1,
				ZIndex                 = 31,
				Parent                 = inner,
			})
			U.New("TextLabel", {
				Size                   = UDim2.new(0.5, 0, 0, 14),
				BackgroundTransparency = 1,
				Font                   = Enum.Font.GothamSemibold,
				TextSize               = 10,
				TextColor3             = Theme.SubText,
				TextXAlignment         = Enum.TextXAlignment.Left,
				Text                   = label,
				ZIndex                 = 31,
				Parent                 = container,
			})
			local vLbl = U.New("TextLabel", {
				Size                   = UDim2.new(0.5, 0, 0, 14),
				AnchorPoint            = Vector2.new(1, 0),
				Position               = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				Font                   = Enum.Font.GothamSemibold,
				TextSize               = 10,
				TextColor3             = Theme.Accent,
				TextXAlignment         = Enum.TextXAlignment.Right,
				Text                   = tostring(default),
				ZIndex                 = 31,
				Parent                 = container,
			})
			local sTrack = U.New("Frame", {
				Size             = UDim2.new(1, 0, 0, 4),
				Position         = UDim2.new(0, 0, 0, 20),
				BackgroundColor3 = Theme.Border,
				BorderSizePixel  = 0,
				ZIndex           = 31,
				Parent           = container,
			})
			U.Corner(sTrack, 4)
			local sFill = U.New("Frame", {
				Size             = UDim2.new(default / 255, 0, 1, 0),
				BackgroundColor3 = Theme.Accent,
				BorderSizePixel  = 0,
				ZIndex           = 31,
				Parent           = sTrack,
			})
			U.Corner(sFill, 4)
			local sThumb = U.New("Frame", {
				Size             = UDim2.new(0, 10, 0, 10),
				Position         = UDim2.new(default / 255, -5, 0.5, -5),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel  = 0,
				ZIndex           = 32,
				Parent           = sTrack,
			})
			U.Corner(sThumb, 5)

			local drag = false
			local function applyDrag(input)
				local rel = math.clamp(
					(input.Position.X - sTrack.AbsolutePosition.X) / sTrack.AbsoluteSize.X, 0, 1)
				local v = math.round(rel * 255)
				if channel == "r" then r = v elseif channel == "g" then g = v else b = v end
				sFill.Size = UDim2.new(rel, 0, 1, 0)
				sThumb.Position = UDim2.new(rel, -5, 0.5, -5)
				vLbl.Text = tostring(v)
				color = Color3.fromRGB(r, g, b)
				preview.BackgroundColor3 = color
				if config.Flag then Library.Flags[config.Flag] = color end
				cb(color)
			end
			sTrack.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					drag = true; applyDrag(input)
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
					applyDrag(input)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
			end)
		end

		addChan("R", "r", r)
		addChan("G", "g", g)
		addChan("B", "b", b)

		preview.MouseButton1Click:Connect(function()
			open = not open
			picker.Visible = true
			if open then
				U.Tween(picker, { Size = UDim2.new(0, 210, 0, 148) }, 0.2)
			else
				U.Tween(picker, { Size = UDim2.new(0, 210, 0, 0) }, 0.2)
				task.delay(0.2, function() if not open then picker.Visible = false end end)
			end
		end)

		local obj = {}
		function obj:Set(c)
			color = c
			r = math.round(c.R * 255)
			g = math.round(c.G * 255)
			b = math.round(c.B * 255)
			preview.BackgroundColor3 = c
			if config.Flag then Library.Flags[config.Flag] = c end
			cb(c)
		end
		function obj:Get() return color end
		return obj
	end

end

return Elements
