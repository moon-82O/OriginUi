local OriginUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/moon-82O/OriginUi/main/Main.lua"))()

local Window = OriginUI:CreateWindow({
    Title      = "OriginUI Demo",
    Subtitle   = "v1.0 · All Elements",
    Icon       = "◈",
    Theme      = OriginUI.Themes.Default,
    ToggleKey  = Enum.KeyCode.RightAlt,
    Size       = Vector2.new(450, 500),
})

local Home = Window:Tab({ Title = "Home", Icon = "⌂" })

Home:ProfileFrame({
    UserId   = game.Players.LocalPlayer.UserId,
    Username = game.Players.LocalPlayer.Name,
    Desc     = "@" .. game.Players.LocalPlayer.Name,
    Role     = "★ Admin",
    Bar      = false,
    Badges   = {
        { Text = "VIP",   Color = Color3.fromRGB(218,175,55) },
        { Text = "Beta",  Color = Color3.fromRGB(88,148,255) },
        { Text = "Pro",   Color = Color3.fromRGB(58,188,98)  },
    },
})

Home:CardRow({
    { Title = "Level",    Value = "42",     Sub = "+12 today",    ValueColor = Color3.fromRGB(218,175,55) },
    { Title = "Balance",  Value = "1,250",  Sub = "Coins",        ValueColor = Color3.fromRGB(58,188,98)  },
    { Title = "Streak",   Value = "7d",     Sub = "Current",      ValueColor = Color3.fromRGB(88,148,255) },
})

Home:Section({ Title = "PROGRESS" })

local xpBar = Home:ProgressBar({
    Title     = "Experience",
    Desc      = "Level 42 → Level 43",
    Value     = 68,
    Suffix    = "%",
    ShowValue = true,
    FillColor = Color3.fromRGB(218, 175, 55),
})

local hpBar = Home:ProgressBar({
    Title     = "Health",
    Value     = 84,
    Suffix    = "%",
    ShowValue = true,
    FillColor = Color3.fromRGB(58, 188, 98),
})

local mpBar = Home:ProgressBar({
    Title     = "Mana",
    Value     = 45,
    Suffix    = "%",
    ShowValue = true,
    FillColor = Color3.fromRGB(88, 148, 255),
})

Home:Section({ Title = "TIMERS" })

local daily = Home:Countdown({
    Title     = "Daily Reset",
    Seconds   = 3600,
    Format    = "MM:SS",
    AutoStart = true,
    FillColor = Color3.fromRGB(218, 175, 55),
    OnEnd     = function()
        Window:Notify({
            Title = "Daily Reset",
            Desc  = "Rewards have been refreshed!",
            Type  = "success",
        })
    end,
})

Home:Section({ Title = "STATUS" })

local statusCard = Home:Card({
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
        statusCard:SetValue("Checking…")
        task.wait(1.5)
        statusCard:SetValue("Online")
        Window:Notify({ Title = "Status Refreshed", Desc = "All systems are online.", Type = "success", Duration = 3 })
    end,
})

Home:Paragraph({
    Desc      = "Welcome to OriginUI v1.0. All elements shown here are available in Main.lua.",
    AccentBar = Color3.fromRGB(218, 175, 55),
})

local Elements = Window:Tab({ Title = "Elements", Icon = "✦" })

Elements:Section({ Title = "BUTTONS" })

Elements:Button({
    Title    = "Primary Action",
    Desc     = "Fires callback with ripple animation",
    Icon     = "→",
    Callback = function()
        Window:Notify({ Title = "Button Clicked!", Type = "success", Duration = 2 })
    end,
})

Elements:Button({
    Title    = "Danger Action",
    Icon     = "!",
    Callback = function()
        Window:Notify({ Title = "Danger!", Desc = "This action is destructive.", Type = "error", Duration = 3 })
    end,
})

Elements:Button({
    Title    = "Disabled Button",
    Disabled = true,
    Callback = function() end,
})

Elements:Section({ Title = "TOGGLES" })

local fpsToggle = Elements:Toggle({
    Title    = "Show FPS Counter",
    Desc     = "Displays performance overlay",
    Value    = true,
    Callback = function(v)
        Window:Notify({ Title = "FPS Counter", Desc = v and "Enabled" or "Disabled", Type = "info", Duration = 2 })
    end,
})

Elements:Toggle({
    Title = "Auto-Save",
    Value = false,
})

Elements:Toggle({
    Title = "Checkbox Mode",
    Type  = "Checkbox",
    Value = true,
})

Elements:Toggle({
    Title    = "Disabled Toggle",
    Disabled = true,
    Value    = false,
})

Elements:Section({ Title = "SLIDERS" })

local volSlider = Elements:Slider({
    Title    = "Master Volume",
    Desc     = "Global audio level",
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

Elements:Slider({
    Title    = "Jump Power",
    Min      = 50,
    Max      = 200,
    Value    = 50,
    Step     = 5,
    Suffix   = "",
    Callback = function(v)
        if game.Players.LocalPlayer.Character then
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = v end
        end
    end,
})

Elements:Section({ Title = "DROPDOWN" })

Elements:Dropdown({
    Title    = "Game Mode",
    Desc     = "Select active game mode",
    Values   = { "Normal", "Hard", "Extreme", "Sandbox", "Creative" },
    Value    = "Normal",
    Callback = function(v)
        Window:Notify({ Title = "Mode Selected", Desc = "Game mode: " .. v, Type = "info", Duration = 2 })
    end,
})

Elements:Dropdown({
    Title  = "Language",
    Values = { "English", "French", "Spanish", "Japanese", "Korean", "Chinese" },
    Value  = "English",
})

Elements:Dropdown({
    Title  = "Multi-Select Tags",
    Values = { "PvP", "Roleplay", "Racing", "FPS", "RPG", "Simulator" },
    Multi  = true,
    Callback = function(v)
        Window:Notify({ Title = "Tags Updated", Desc = "Selected: " .. tostring(#v), Type = "info", Duration = 2 })
    end,
})

Elements:Section({ Title = "INPUT" })

Elements:Input({
    Title       = "Display Name",
    Placeholder = "Enter display name…",
    Callback    = function(v)
        Window:Notify({ Title = "Name Set", Desc = v, Type = "success", Duration = 2 })
    end,
})

Elements:Input({
    Title       = "Bio",
    Placeholder = "Write something about yourself…",
    MultiLine   = true,
})

Elements:Section({ Title = "COLOR PICKER" })

Elements:ColorPicker({
    Title    = "Accent Color",
    Desc     = "Pick a custom UI accent color",
    Value    = Color3.fromRGB(218, 175, 55),
    Callback = function(v)
        Window:Notify({ Title = "Color Changed", Desc = string.format("RGB(%d, %d, %d)", v.R*255, v.G*255, v.B*255), Type = "info", Duration = 2 })
    end,
})

Elements:ColorPicker({
    Title = "Background Tint",
    Value = Color3.fromRGB(10, 10, 12),
})

Elements:Section({ Title = "KEYBINDS" })

Elements:Keybind({
    Title    = "Toggle UI",
    Desc     = "Opens or closes the window",
    Key      = Enum.KeyCode.RightAlt,
    Callback = function(k) end,
})

Elements:KeybindButton({
    Title      = "Quick Teleport",
    Key        = Enum.KeyCode.T,
    ButtonText = "Run",
    Callback   = function()
        Window:Notify({ Title = "Teleport", Desc = "Teleporting to spawn…", Type = "info", Duration = 2 })
    end,
})

Elements:Divider({ Label = "MISC" })

Elements:Badge({
    { Text = "VIP",    Color = Color3.fromRGB(218,175,55) },
    { Text = "Beta",   Color = Color3.fromRGB(88,148,255)  },
    { Text = "Verified", Color = Color3.fromRGB(58,188,98) },
})

Elements:Label({
    Text  = "OriginUI v1.0 · Built for Roblox · MIT License",
    Color = Color3.fromRGB(68,68,78),
    Size  = 11,
    Wrap  = true,
})

local Dashboard = Window:Tab({ Title = "Dashboard", Icon = "▤" })

Dashboard:Section({ Title = "LIVE STATS" })

Dashboard:CardRow({
    { Title = "Players",  Value = "124",    Sub = "Online now",    ValueColor = Color3.fromRGB(58,188,98)   },
    { Title = "Servers",  Value = "8",      Sub = "Active",        ValueColor = Color3.fromRGB(218,175,55)  },
    { Title = "Uptime",   Value = "99.8%",  Sub = "Last 30 days",  ValueColor = Color3.fromRGB(88,148,255)  },
})

Dashboard:Section({ Title = "SERVER LOAD" })

local cpu = Dashboard:ProgressBar({ Title = "CPU Usage",   Value = 34, FillColor = Color3.fromRGB(58,188,98)   })
local mem = Dashboard:ProgressBar({ Title = "Memory",      Value = 67, FillColor = Color3.fromRGB(218,158,38)  })
local net = Dashboard:ProgressBar({ Title = "Network I/O", Value = 12, FillColor = Color3.fromRGB(72,148,228)  })

Dashboard:Section({ Title = "TOP PLAYERS" })

Dashboard:Table({
    Headers = { "Rank", "Player",       "Score",  "K/D",  "Win%" },
    Rows    = {
        { "1", "StarPlayer",   "42,500", "4.2",  "78%"  },
        { "2", "NightRacer",   "38,200", "3.8",  "71%"  },
        { "3", "BluePhoenix",  "31,800", "3.1",  "65%"  },
        { "4", "SkyWatcher",   "28,400", "2.7",  "58%"  },
        { "5", "ThunderBolt",  "24,100", "2.3",  "51%"  },
    },
})

Dashboard:Section({ Title = "RECENT EVENTS" })

Dashboard:Table({
    Title   = "Activity Log",
    Headers = { "Time",     "Event",             "Player"      },
    Rows    = {
        { "Just now",  "Joined game",        "StarPlayer"  },
        { "2m ago",    "Achieved VIP rank",  "NightRacer"  },
        { "5m ago",    "New high score",     "BluePhoenix" },
        { "12m ago",   "Left game",          "OldTimer"    },
    },
})

Dashboard:Paragraph({
    Title     = "Dashboard Notes",
    Desc      = "CPU and Memory reflect server-side load. Network shows packet throughput per second. Values above 85% may cause lag.",
    AccentBar = Color3.fromRGB(218, 175, 55),
})

local Settings = Window:Tab({ Title = "Settings", Icon = "⚙" })

Settings:Section({ Title = "APPEARANCE" })

Settings:Dropdown({
    Title  = "Theme",
    Desc   = "Switch the UI color scheme",
    Values = { "Default", "Dark", "Midnight" },
    Value  = "Default",
    Callback = function(v)
        Window:SetTheme(v)
        Window:Notify({ Title = "Theme Changed", Desc = "Switched to " .. v, Type = "success", Duration = 2 })
    end,
})

Settings:Toggle({
    Title = "Compact Mode",
    Desc  = "Reduces padding and spacing",
    Value = false,
})

Settings:Toggle({
    Title = "Animations",
    Desc  = "Enable UI transition effects",
    Value = true,
})

Settings:ColorPicker({
    Title = "Custom Accent",
    Desc  = "Override the theme accent color",
    Value = Color3.fromRGB(218, 175, 55),
})

Settings:Section({ Title = "PERFORMANCE" })

Settings:Toggle({
    Title = "Low Graphics Mode",
    Desc  = "Reduces visual effects for better FPS",
    Value = false,
})

Settings:Slider({
    Title  = "Render Distance",
    Desc   = "Maximum view distance in studs",
    Min    = 128,
    Max    = 2048,
    Value  = 512,
    Step   = 64,
    Suffix = "st",
})

Settings:Section({ Title = "CONTROLS" })

Settings:Keybind({
    Title = "Toggle UI",
    Key   = Enum.KeyCode.RightAlt,
})

Settings:KeybindButton({
    Title      = "Screenshot",
    Key        = Enum.KeyCode.F9,
    ButtonText = "Capture",
    Callback   = function()
        Window:Notify({ Title = "Screenshot", Desc = "Saved to gallery.", Type = "success", Duration = 2 })
    end,
})

Settings:Section({ Title = "NOTIFICATIONS" })

Settings:Button({ Title = "Test Success",  Callback = function() Window:Notify({ Title = "Success",  Desc = "Everything worked.",         Type = "success" }) end })
Settings:Button({ Title = "Test Warning",  Callback = function() Window:Notify({ Title = "Warning",  Desc = "Proceed with caution.",      Type = "warn"    }) end })
Settings:Button({ Title = "Test Error",    Callback = function() Window:Notify({ Title = "Error",    Desc = "Something went wrong.",      Type = "error"   }) end })
Settings:Button({ Title = "Test Info",     Callback = function() Window:Notify({ Title = "Info",     Desc = "Here is some information.",  Type = "info"    }) end })

Settings:Divider({ Label = "v1.0.0 · OriginUI" })

Settings:Paragraph({
    Desc = "OriginUI is a modern Roblox UI library. Features: multiple themes, full touch/mobile support, 15+ elements, clean API.",
})
