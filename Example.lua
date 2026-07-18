local OriginUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/moon-82O/OriginUi/refs/heads/main/main.lua"))()

local Window = OriginUi:CreateWindow({
	Title = "OriginUi",
	SubTitle = "v1.0",
	Size = UDim2.new(0, 480, 0, 320),
	Transparency = 0.1,
})

local MainTab = Window:CreateTab("Main")

MainTab:CreateLabel({
	Text = "Section generale",
})

MainTab:CreateButton({
	Name = "Actualiser",
	Callback = function()
		print("Actualiser cliqué")
	end,
})

MainTab:CreateDivider()

MainTab:CreateToggle({
	Name = "Notifications",
	Type = "Default",
	Default = false,
	Callback = function(state)
		print("Notifications:", state)
	end,
})

MainTab:CreateToggle({
	Name = "Mode debug",
	Type = "Checkbox",
	Default = true,
	Callback = function(state)
		print("Debug:", state)
	end,
})

MainTab:CreateSlider({
	Name = "Vitesse",
	Min = 0,
	Max = 100,
	Increment = 5,
	Default = 50,
	Callback = function(value)
		print("Vitesse:", value)
	end,
})

MainTab:CreateInput({
	Name = "Nom",
	Placeholder = "Entrer un nom",
	Callback = function(text, enterPressed)
		print("Texte:", text)
	end,
})

MainTab:CreateKeybind({
	Name = "Toggle GUI",
	Default = Enum.KeyCode.RightControl,
	Callback = function(key)
		print("Touche:", key.Name)
	end,
})

MainTab:CreateDropdown({
	Name = "Theme",
	Type = "Single",
	Options = {"Bleu", "Rouge", "Vert"},
	Default = "Bleu",
	Callback = function(selected)
		print("Selection:", selected)
	end,
})

local SettingsTab = Window:CreateTab("Parametres")

SettingsTab:CreateDropdown({
	Name = "Options",
	Type = "Multi",
	Options = {"Option A", "Option B", "Option C"},
	Callback = function(selected)
		print("Multi:", selected)
	end,
})
