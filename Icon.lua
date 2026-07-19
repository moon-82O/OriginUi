local HttpService = game:GetService("HttpService")

local Icons = {}

-- // Icon cache to avoid duplicate requests
local Cache = {}

-- // Base URL for Lucide SVG icons
local BASE_URL = "https://raw.githubusercontent.com/lucide-icons/lucide/main/icons/"

-- // Common icons pre-mapped (add more as needed)
-- These use Roblox's rbxassetid system for performance.
-- To use custom icons, provide the icon name and it will be fetched.
Icons.Catalog = {
  -- Navigation
  home          = "home",
  settings      = "settings",
  user          = "user",
  users         = "users",
  menu          = "menu",
  ["arrow-left"]= "arrow-left",
  ["arrow-right"]="arrow-right",
  ["chevron-down"]="chevron-down",
  ["chevron-up"]= "chevron-up",
  search        = "search",

  -- Actions
  plus          = "plus",
  minus         = "minus",
  x             = "x",
  check         = "check",
  edit          = "edit",
  trash         = "trash-2",
  copy          = "copy",
  save          = "save",
  download      = "download",
  upload        = "upload",

  -- UI
  eye           = "eye",
  ["eye-off"]   = "eye-off",
  lock          = "lock",
  unlock        = "unlock",
  star          = "star",
  heart         = "heart",
  bell          = "bell",
  info          = "info",
  warning       = "triangle-alert",
  danger        = "circle-x",
  success       = "circle-check",

  -- Media
  play          = "play",
  pause         = "pause",
  stop          = "square",
  volume        = "volume-2",
  mute          = "volume-x",

  -- Game
  gamepad       = "gamepad-2",
  sword         = "sword",
  shield        = "shield",
  zap           = "zap",
  flame         = "flame",
  globe         = "globe",
  map           = "map",
  trophy        = "trophy",
  crown         = "crown",
}

-- // Resolve icon name (alias support)
local function resolve(name)
  return Icons.Catalog[name] or name
end

-- // Fetch SVG and convert to image (uses EditableImage or ImageLabel)
-- Since Roblox cannot render raw SVGs, we use a proxy service that converts
-- SVGs to PNGs. An alternative is to use pre-uploaded icon sheets.
local PROXY_URL = "https://lucide-png-proxy.example.com/" -- Replace with a real proxy

-- // Create an icon ImageLabel
-- config: { Size, Position, AnchorPoint, Color, Parent, ZIndex }
function Icons.Create(name, config)
  config = config or {}
  local iconName = resolve(name)

  -- Create a Frame as placeholder (works without external calls)
  local frame = Instance.new("ImageLabel")
  frame.Size             = config.Size       or UDim2.new(0, 16, 0, 16)
  frame.Position         = config.Position   or UDim2.new(0, 0, 0, 0)
  frame.AnchorPoint      = config.AnchorPoint or Vector2.new(0, 0)
  frame.BackgroundTransparency = 1
  frame.BorderSizePixel  = 0
  frame.ZIndex           = config.ZIndex     or 1
  frame.ImageColor3      = config.Color      or Color3.new(1, 1, 1)
  frame.ScaleType        = Enum.ScaleType.Fit

  if config.Parent then
    frame.Parent = config.Parent
  end

  -- Async fetch icon via HttpService if available
  task.spawn(function()
    local ok, result = pcall(function()
      -- Check cache first
      if Cache[iconName] then
        return Cache[iconName]
      end

      -- Fetch SVG source
      local svgUrl = BASE_URL .. iconName .. ".svg"
      local svg = game:HttpGet(svgUrl)

      -- Since Roblox can't render SVGs directly, we parse the path data
      -- and use DrawingAPI or store the SVG text for other rendering methods.
      -- For production use, upload icons as Roblox images and map them here.
      Cache[iconName] = svg
      return svg
    end)

    if ok then
      -- Icon fetched — in a real implementation, render the SVG paths
      -- using a DrawingAPI wrapper or EditableImage.
      -- For now, we just mark the icon as loaded.
      frame:SetAttribute("IconName",   iconName)
      frame:SetAttribute("IconLoaded", true)
    end
  end)

  return frame
end

-- // Set icon color
function Icons.SetColor(iconFrame, color)
  if iconFrame and iconFrame:IsA("ImageLabel") then
    iconFrame.ImageColor3 = color
  end
end

-- // Set icon size
function Icons.SetSize(iconFrame, size)
  if iconFrame then
    iconFrame.Size = size
  end
end

-- // List all available icon names
function Icons.List()
  local names = {}
  for name in pairs(Icons.Catalog) do
    table.insert(names, name)
  end
  table.sort(names)
  return names
end

-- // Check if an icon name is valid
function Icons.IsValid(name)
  return Icons.Catalog[name] ~= nil
end

return Icons
