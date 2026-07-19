local OriginUI = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/moon-82O/OriginUi/refs/heads/main/main.lua"
))()

local Window = OriginUI:CreateWindow({
	Title    = "My Script",
	SubTitle = "Powered by OriginUI",
	Theme    = "Default",
	Size     = UDim2.new(0, 580, 0, 400),
})

local Main = Window:CreateTab({
	Name = "Main",
	Icon = "home",
})

local PlayerSection = Main:CreateSection({ Name = "Player", Icon = "user" })

PlayerSection:CreateToggle({
	Name     = "God Mode",
	Desc     = "Toggle invincibility",
	Default  = false,
	Flag     = "GodMode",
	Callback = function(state)
		print("God Mode:", state)
	end,
})

PlayerSection:CreateSlider({
	Name      = "Walk Speed",
	Min       = 16,
	Max       = 200,
	Increment = 2,
	Default   = 16,
	Suffix    = " WS",
	Flag      = "WalkSpeed",
	Callback  = function(value)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = value
		end
	end,
})

PlayerSection:CreateSlider({
	Name      = "Jump Power",
	Min       = 50,
	Max       = 500,
	Increment = 10,
	Default   = 50,
	Suffix    = " JP",
	Flag      = "JumpPower",
	Callback  = function(value)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.JumpPower = value
		end
	end,
})

local Visual = Window:CreateTab({
	Name = "Visual",
	Icon = "eye",
})

local EspSection = Visual:CreateSection({ Name = "ESP" })

EspSection:CreateToggle({
	Name     = "Player ESP",
	Default  = false,
	Callback = function(state)
		print("ESP:", state)
	end,
})

local UISection = Visual:CreateSection({ Name = "Interface" })

UISection:CreateDropdown({
	Name     = "Theme",
	Options  = { "Default", "Midnight", "Rose", "Forest" },
	Default  = "Default",
	Flag     = "Theme",
	Callback = function(selected)
		print("Theme:", selected)
	end,
})

local Settings = Window:CreateTab({
	Name = "Settings",
	Icon = "settings",
})

Settings:CreateKeybind({
	Name     = "Toggle UI",
	Default  = Enum.KeyCode.RightControl,
	Flag     = "UIToggle",
	Callback = function(key)
		print("Key pressed:", key.Name)
	end,
})

Settings:CreateInput({
	Name        = "Custom Message",
	Placeholder = "Type something...",
	Flag        = "CustomMsg",
	Callback    = function(text, enter)
		if enter then
			Window:Notify({
				Title       = "Message Sent",
				Description = text,
				Type        = "Success",
				Duration    = 3,
			})
		end
	end,
})

Settings:CreateColorPicker({
	Name     = "Accent Color",
	Default  = Color3.fromRGB(100, 160, 255),
	Flag     = "AccentColor",
	Callback = function(color)
		print("Color:", color)
	end,
})

Settings:CreateDivider()

Settings:CreateLabel({ Text = "OriginUI v2.0.0 — github.com/moon-82O/OriginUi" })

Window:Notify({
	Title       = "Script Loaded",
	Description = "OriginUI v2.0.0 is ready.",
	Type        = "Success",
	Duration    = 4,
})	Default = true,
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
