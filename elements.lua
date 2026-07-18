local UserInputService = game:GetService("UserInputService")

local Elements = {}

function Elements.Attach(Tab, Utility, Theme, Container)
	local create = Utility.Create
	local corner = Utility.Corner
	local stroke = Utility.Stroke
	local tween = Utility.Tween

	function Tab:CreateLabel(config)
		config = config or {}
		return create("TextLabel", {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = config.Text or "Label",
			Parent = Container,
		})
	end

	function Tab:CreateDivider()
		return create("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.92,
			BorderSizePixel = 0,
			Parent = Container,
		})
	end

	function Tab:CreateButton(config)
		config = config or {}
		local callback = config.Callback or function() end

		local btn = create("TextButton", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.Accent,
			BackgroundTransparency = 0.15,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			TextColor3 = Color3.new(1, 1, 1),
			Text = config.Name or "Button",
			Parent = Container,
		})
		corner(btn, 8)

		btn.MouseEnter:Connect(function()
			tween(btn, {BackgroundTransparency = 0})
		end)
		btn.MouseLeave:Connect(function()
			tween(btn, {BackgroundTransparency = 0.15})
		end)
		btn.MouseButton1Click:Connect(function()
			callback()
		end)

		return btn
	end

	function Tab:CreateToggle(config)
		config = config or {}
		local kind = config.Type or "Default"
		local state = config.Default or false
		local callback = config.Callback or function() end

		local row = create("Frame", {
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundTransparency = 1,
			Parent = Container,
		})

		create("TextLabel", {
			Size = UDim2.new(1, -50, 1, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = config.Name or "Toggle",
			Parent = row,
		})

		if kind == "Checkbox" then
			local box = create("TextButton", {
				Size = UDim2.new(0, 20, 0, 20),
				Position = UDim2.new(1, -20, 0.5, -10),
				BackgroundColor3 = state and Theme.Accent or Theme.Secondary,
				BorderSizePixel = 0,
				Text = "",
				Parent = row,
			})
			corner(box, 5)
			stroke(box, Color3.new(1, 1, 1), 1, 0.8)

			local check = create("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				TextColor3 = Color3.new(1, 1, 1),
				Text = state and "v" or "",
				Parent = box,
			})

			box.MouseButton1Click:Connect(function()
				state = not state
				tween(box, {BackgroundColor3 = state and Theme.Accent or Theme.Secondary})
				check.Text = state and "v" or ""
				callback(state)
			end)

			return {
				Set = function(_, value)
					state = value
					box.BackgroundColor3 = state and Theme.Accent or Theme.Secondary
					check.Text = state and "v" or ""
					callback(state)
				end,
				Get = function()
					return state
				end,
			}
		else
			local box = create("TextButton", {
				Size = UDim2.new(0, 38, 0, 20),
				Position = UDim2.new(1, -38, 0.5, -10),
				BackgroundColor3 = state and Theme.Accent or Theme.Secondary,
				BorderSizePixel = 0,
				Text = "",
				Parent = row,
			})
			corner(box, 10)

			local knob = create("Frame", {
				Size = UDim2.new(0, 16, 0, 16),
				Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Parent = box,
			})
			corner(knob, 8)

			box.MouseButton1Click:Connect(function()
				state = not state
				tween(box, {BackgroundColor3 = state and Theme.Accent or Theme.Secondary})
				tween(knob, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
				callback(state)
			end)

			return {
				Set = function(_, value)
					state = value
					tween(box, {BackgroundColor3 = state and Theme.Accent or Theme.Secondary})
					tween(knob, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
					callback(state)
				end,
				Get = function()
					return state
				end,
			}
		end
	end

	function Tab:CreateSlider(config)
		config = config or {}
		local min = config.Min or 0
		local max = config.Max or 100
		local increment = config.Increment or 1
		local value = config.Default or min
		local callback = config.Callback or function() end

		local row = create("Frame", {
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundTransparency = 1,
			Parent = Container,
		})

		create("TextLabel", {
			Size = UDim2.new(1, -40, 0, 16),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = config.Name or "Slider",
			Parent = row,
		})

		local valueLabel = create("TextLabel", {
			Size = UDim2.new(0, 40, 0, 16),
			Position = UDim2.new(1, -40, 0, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Right,
			Text = tostring(value),
			Parent = row,
		})

		local track = create("Frame", {
			Size = UDim2.new(1, 0, 0, 6),
			Position = UDim2.new(0, 0, 0, 24),
			BackgroundColor3 = Theme.Secondary,
			BorderSizePixel = 0,
			Parent = row,
		})
		corner(track, 3)

		local fill = create("Frame", {
			Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
			BackgroundColor3 = Theme.Accent,
			BorderSizePixel = 0,
			Parent = track,
		})
		corner(fill, 3)

		local dragging = false

		local function setFromPos(posX)
			local rel = math.clamp((posX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			local raw = min + rel * (max - min)
			value = math.floor(raw / increment + 0.5) * increment
			value = math.clamp(value, min, max)
			fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
			valueLabel.Text = tostring(value)
			callback(value)
		end

		track.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				setFromPos(input.Position.X)
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				setFromPos(input.Position.X)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		return {
			Set = function(_, v)
				value = math.clamp(v, min, max)
				fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
				valueLabel.Text = tostring(value)
				callback(value)
			end,
			Get = function()
				return value
			end,
		}
	end

	function Tab:CreateInput(config)
		config = config or {}
		local callback = config.Callback or function() end

		local row = create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundTransparency = 1,
			Parent = Container,
		})

		create("TextLabel", {
			Size = UDim2.new(0.4, 0, 1, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = config.Name or "Input",
			Parent = row,
		})

		local box = create("Frame", {
			Size = UDim2.new(0.6, 0, 1, 0),
			Position = UDim2.new(0.4, 0, 0, 0),
			BackgroundColor3 = Theme.Secondary,
			BackgroundTransparency = 0.2,
			BorderSizePixel = 0,
			Parent = row,
		})
		corner(box, 8)
		stroke(box, Color3.new(1, 1, 1), 1, 0.85)

		local textBox = create("TextBox", {
			Size = UDim2.new(1, -16, 1, 0),
			Position = UDim2.new(0, 8, 0, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextColor3 = Theme.Text,
			PlaceholderText = config.Placeholder or "",
			PlaceholderColor3 = Theme.SubText,
			Text = config.Default or "",
			ClearTextOnFocus = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = box,
		})

		textBox.FocusLost:Connect(function(enterPressed)
			callback(textBox.Text, enterPressed)
		end)

		return {
			Set = function(_, text)
				textBox.Text = text
			end,
			Get = function()
				return textBox.Text
			end,
		}
	end

	function Tab:CreateKeybind(config)
		config = config or {}
		local callback = config.Callback or function() end
		local current = config.Default or Enum.KeyCode.Unknown
		local listening = false

		local row = create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundTransparency = 1,
			Parent = Container,
		})

		create("TextLabel", {
			Size = UDim2.new(1, -90, 1, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = config.Name or "Keybind",
			Parent = row,
		})

		local box = create("TextButton", {
			Size = UDim2.new(0, 80, 0, 26),
			Position = UDim2.new(1, -80, 0.5, -13),
			BackgroundColor3 = Theme.Secondary,
			BackgroundTransparency = 0.2,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextColor3 = Theme.Text,
			Text = current.Name,
			Parent = row,
		})
		corner(box, 8)

		box.MouseButton1Click:Connect(function()
			listening = true
			box.Text = "..."
		end)

		UserInputService.InputBegan:Connect(function(input)
			if listening and input.UserInputType == Enum.UserInputType.Keyboard then
				current = input.KeyCode
				box.Text = current.Name
				listening = false
				callback(current)
			end
		end)

		return {
			Set = function(_, key)
				current = key
				box.Text = key.Name
			end,
			Get = function()
				return current
			end,
		}
	end

	function Tab:CreateDropdown(config)
		config = config or {}
		local kind = config.Type or "Single"
		local options = config.Options or {}
		local selected = {}
		local callback = config.Callback or function() end

		if config.Default then
			if kind == "Multi" then
				for _, v in ipairs(config.Default) do
					selected[v] = true
				end
			else
				selected[config.Default] = true
			end
		end

		local row = create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundTransparency = 1,
			ZIndex = 4,
			Parent = Container,
		})

		create("TextLabel", {
			Size = UDim2.new(0.4, 0, 1, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = config.Name or "Dropdown",
			ZIndex = 4,
			Parent = row,
		})

		local function summary()
			local list = {}
			for k, v in pairs(selected) do
				if v then table.insert(list, k) end
			end
			if #list == 0 then return "..." end
			return table.concat(list, ", ")
		end

		local box = create("TextButton", {
			Size = UDim2.new(0.6, 0, 1, 0),
			Position = UDim2.new(0.4, 0, 0, 0),
			BackgroundColor3 = Theme.Secondary,
			BackgroundTransparency = 0.2,
			BorderSizePixel = 0,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Theme.Text,
			Text = summary(),
			ZIndex = 4,
			Parent = row,
		})
		corner(box, 8)

		local list = create("Frame", {
			Size = UDim2.new(1, 0, 0, #options * 26),
			Position = UDim2.new(0, 0, 1, 4),
			BackgroundColor3 = Theme.Secondary,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 10,
			Parent = box,
		})
		corner(list, 8)
		stroke(list, Color3.new(1, 1, 1), 1, 0.85)

		create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = list,
		})

		local open = false

		local function refreshOptions()
			for _, child in ipairs(list:GetChildren()) do
				if child:IsA("TextButton") then
					child.BackgroundTransparency = selected[child.Text] and 0 or 1
				end
			end
		end

		for _, option in ipairs(options) do
			local opt = create("TextButton", {
				Size = UDim2.new(1, 0, 0, 26),
				BackgroundColor3 = Theme.Accent,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = Enum.Font.Gotham,
				TextSize = 12,
				TextColor3 = Theme.Text,
				Text = option,
				ZIndex = 11,
				Parent = list,
			})

			opt.MouseButton1Click:Connect(function()
				if kind == "Multi" then
					selected[option] = not selected[option]
				else
					for k in pairs(selected) do selected[k] = false end
					selected[option] = true
					open = false
					list.Visible = false
				end
				box.Text = summary()
				refreshOptions()

				local result
				if kind == "Multi" then
					result = {}
					for k, v in pairs(selected) do
						if v then table.insert(result, k) end
					end
				else
					result = option
				end
				callback(result)
			end)
		end

		refreshOptions()

		box.MouseButton1Click:Connect(function()
			open = not open
			list.Visible = open
		end)

		return {
			Get = function()
				if kind == "Multi" then
					local result = {}
					for k, v in pairs(selected) do
						if v then table.insert(result, k) end
					end
					return result
				end
				for k, v in pairs(selected) do
					if v then return k end
				end
				return nil
			end,
		}
	end
end

return Elements
