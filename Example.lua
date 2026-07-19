local OriginUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/moon-82O/OriginUi/main/Main.lua"))()

local Window = OriginUI:CreateWindow({
    Title      = "OriginUI Demo",
    Subtitle   = "v1.0 · All Elements",
    Icon       = "◈",
    Theme      = OriginUI.Themes.Default,
    ToggleKey  = Enum.KeyCode.RightAlt,
})

local Home = Window:Tab({ Title = "Home", Icon = "⌂" })

Home:ProfileFrame({
    UserId   = game.Players.LocalPlayer.UserId,
    Username = game.Players.LocalPlayer.Name,
    Desc     = "@" .. game.Players.LocalPlayer.Name,
    Role     = "★ Admin",
    Bar      = false,
    Badges   = {
        { Text = "VIP",  Color = Color3.fromRGB(218,175,55) },
        { Text = "Beta", Color = Color3.fromRGB(88,148,255) },
    },
})

Home:CardRow({
    { Title = "Level",   Value = "42",    Sub = "+12 today",   ValueColor = Color3.fromRGB(218,175,55)  },
    { Title = "Balance", Value = "1,250", Sub = "Coins",       ValueColor = Color3.fromRGB(58,188,98)   },
    { Title = "Streak",  Value = "7d",    Sub = "Current",     ValueColor = Color3.fromRGB(88,148,255)  },
})

Home:Section({ Title = "QUICK ACTIONS" })

local status = Home:Card({
    Title      = "Server Status",
    Icon       = "●",
    Value      = "Online",
    ValueColor = Color3.fromRGB(58, 188, 98),
    Desc       = "All systems operational",
    Height     = 82,
})

Home:Button({
    Title    = "Refresh Status",
    Desc     = "Check server connectivity",
    Icon     = "↻",
    Callback = function()
        status:SetValue("Checking…")
        task.wait(1.5)
        status:SetValue("Online")
        Window:Notify({
            Title    = "Status Refreshed",
            Desc     = "All systems are online.",
            Type     = "success",
            Duration = 3,
        })
    end,
})

local xpBar = Home:ProgressBar({
    Title     = "Experience",
    Desc      = "Level 42 → 43",
    Value     = 68,
    Suffix    = "%",
    ShowValue = true,
    FillColor = Color3.fromRGB(218, 175, 55),
})

Home:Countdown({
    Title     = "Daily Reset",
    Seconds   = 3600,
    Format    = "MM:SS",
    AutoStart = true,
    FillColor = Color3.fromRGB(88, 148, 255),
    OnEnd     = function()
        Window:Notify({
            Title = "Daily Reset",
            Desc  = "Rewards have been refreshed!",
            Type  = "info",
        })
    end,
})

local Elements = Window:Tab({ Title = "Elements", Icon = "✦" })

Elements:Section({ Title = "BUTTONS" })

Elements:Button({
    Title    = "Primary Action",
    Desc     = "Fires a callback with ripple animation",
    Callback = function()
        Window:Notify({ Title = "Button Clicked", Type = "success", Duration = 2 })
    end,
})

Elements:Button({
    Title    = "Disabled Button",
    Disabled = true,
    Callback = function() end,
})

Elements:Section({ Title = "TOGGLES" })

Elements:Toggle({
    Title    = "Enable Feature",
    Desc     = "Default switch style",
    Value    = true,
    Callback = function(v)
        Window:Notify({ Title = "Toggle", Desc = "Value: " .. tostring(v), Type = "info", Duration = 2 })
    end,
})

Elements:Toggle({
    Title    = "Checkbox Style",
    Type     = "Checkbox",
    Value    = false,
    Callback = function(v)
        Window:Notify({ Title = "Checkbox", Desc = "Checked: " .. tostring(v), Type = "info", Duration = 2 })
    end,
})

Elements:Section({ Title = "SLIDERS" })

local volSlider = Elements:Slider({
    Title    = "Volume",
    Desc     = "Master audio level",
    Min      = 0,
    Max      = 100,
    Value    = 75,
    Suffix   = "%",
    Step     = 1,
    Callback = function(v) end,
})

local speedSlider = Elements:Slider({
    Title    = "Walk Speed",
    Min      = 16,
    Max      = 100,
    Value    = 16,
    Step     = 2,
    Input    = true,
    Callback = function(v)
        if game.Players.LocalPlayer.Character then
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
    end,
})

Elements:Section({ Title = "DROPDOWN" })

local gameMode = Elements:Dropdown({
    Title    = "Game Mode",
    Desc     = "Select active mode",
    Values   = { "Normal", "Hard", "Extreme", "Sandbox" },
    Value    = "Normal",
    Callback = function(v)
        Window:Notify({ Title = "Game Mode", Desc = "Set to: " .. v, Type = "info", Duration = 2 })
    end,
})

Elements:Section({ Title = "INPUT" })

local nameInput = Elements:Input({
    Title       = "Display Name",
    Placeholder = "Enter a name…",
    Value       = "",
    Callback    = function(v)
        Window:Notify({ Title = "Name Set", Desc = v, Type = "success", Duration = 2 })
    end,
})

Elements:Section({ Title = "COLOR PICKER" })

Elements:ColorPicker({
    Title    = "Accent Color",
    Desc     = "Pick a custom UI accent",
    Value    = Color3.fromRGB(218, 175, 55),
    Callback = function(v) end,
})

local Dashboard = Window:Tab({ Title = "Dashboard", Icon = "▤" })

Dashboard:Section({ Title = "STATISTICS" })

Dashboard:Table({
    Title   = "Top Players",
    Headers = { "Rank", "Player", "Score", "Level" },
    Rows    = {
        { "1", "StarPlayer",   "42,500", "98" },
        { "2", "NightRacer",   "38,200", "87" },
        { "3", "BluePhoenix",  "31,800", "76" },
        { "4", "SkyWatcher",   "28,400", "65" },
        { "5", "ThunderBolt",  "24,100", "58" },
    },
})

Dashboard:Section({ Title = "PERFORMANCE" })

local cpu = Dashboard:ProgressBar({
    Title     = "CPU Usage",
    Value     = 34,
    FillColor = Color3.fromRGB(58, 188, 98),
})

local mem = Dashboard:ProgressBar({
    Title     = "Memory",
    Value     = 67,
    FillColor = Color3.fromRGB(218, 158, 38),
})

local net = Dashboard:ProgressBar({
    Title     = "Network",
    Value     = 12,
    FillColor = Color3.fromRGB(72, 148, 228),
})

Dashboard:Paragraph({
    Title     = "How to read these stats",
    Desc      = "CPU and Memory track local client load. Network shows outbound packet rate. Values above 80% may cause performance degradation.",
    AccentBar = Color3.fromRGB(218, 175, 55),
})

local Settings = Window:Tab({ Title = "Settings", Icon = "⚙" })

Settings:Section({ Title = "APPEARANCE" })

Settings:Dropdown({
    Title  = "Theme",
    Values = { "Default", "Dark", "Midnight" },
    Value  = "Default",
    Callback = function(v)
        Window:SetTheme(v)
        Window:Notify({ Title = "Theme", Desc = "Switched to " .. v, Type = "success", Duration = 2 })
    end,
})

Settings:Toggle({
    Title = "Compact Mode",
    Desc  = "Reduces element padding",
    Value = false,
})

Settings:Section({ Title = "CONTROLS" })

Settings:Keybind({
    Title    = "Toggle UI",
    Desc     = "Opens or closes the window",
    Key      = Enum.KeyCode.RightAlt,
    Callback = function(k) end,
})

Settings:KeybindButton({
    Title      = "Quick Teleport",
    Key        = Enum.KeyCode.T,
    ButtonText = "Run",
    Callback   = function()
        Window:Notify({ Title = "Teleport", Desc = "Teleporting…", Type = "info", Duration = 2 })
    end,
})

Settings:Section({ Title = "NOTIFICATIONS" })

Settings:Button({
    Title    = "Test Success",
    Callback = function()
        Window:Notify({ Title = "Success!", Desc = "Everything worked fine.", Type = "success" })
    end,
})

Settings:Button({
    Title    = "Test Warning",
    Callback = function()
        Window:Notify({ Title = "Warning", Desc = "Something might be wrong.", Type = "warn" })
    end,
})

Settings:Button({
    Title    = "Test Error",
    Callback = function()
        Window:Notify({ Title = "Error", Desc = "Something went wrong.", Type = "error" })
    end,
})

Settings:Divider({ Label = "v1.0.0 · OriginUI" })

Settings:Paragraph({
    Desc = "OriginUI is a modern Roblox UI library with full theme support, touch/mobile compatibility, and a clean element API.",
})
