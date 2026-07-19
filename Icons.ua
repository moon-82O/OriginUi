local Icons = {}

Icons.Catalog = {
	home            = "home",
	settings        = "settings",
	user            = "user",
	users           = "users",
	menu            = "menu",
	search          = "search",
	plus            = "plus",
	minus           = "minus",
	x               = "x",
	check           = "check",
	edit            = "edit",
	trash           = "trash-2",
	copy            = "copy",
	save            = "save",
	download        = "download",
	upload          = "upload",
	eye             = "eye",
	lock            = "lock",
	unlock          = "unlock",
	star            = "star",
	heart           = "heart",
	bell            = "bell",
	info            = "info",
	warning         = "triangle-alert",
	danger          = "circle-x",
	success         = "circle-check",
	play            = "play",
	pause           = "pause",
	volume          = "volume-2",
	mute            = "volume-x",
	gamepad         = "gamepad-2",
	sword           = "sword",
	shield          = "shield",
	zap             = "zap",
	flame           = "flame",
	globe           = "globe",
	map             = "map",
	trophy          = "trophy",
	crown           = "crown",
	["mouse-pointer-click"] = "mouse-pointer-click",
	["arrow-left"]  = "arrow-left",
	["arrow-right"] = "arrow-right",
	["eye-off"]     = "eye-off",
	["chevron-down"]= "chevron-down",
	["chevron-up"]  = "chevron-up",
}

function Icons.Create(name, config)
	config = config or {}
	local frame = Instance.new("Frame")
	frame.Size                   = config.Size       or UDim2.new(0, 16, 0, 16)
	frame.Position               = config.Position   or UDim2.new(0, 0, 0, 0)
	frame.AnchorPoint            = config.AnchorPoint or Vector2.new(0, 0)
	frame.BackgroundColor3       = config.Color       or Color3.new(1, 1, 1)
	frame.BackgroundTransparency = 0.25
	frame.BorderSizePixel        = 0
	frame.ZIndex                 = config.ZIndex      or 1
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 3)
	corner.Parent = frame
	if config.Parent then frame.Parent = config.Parent end
	return frame
end

function Icons.SetColor(frame, color)
	if frame and frame:IsA("Frame") then
		frame.BackgroundColor3 = color
	end
end

function Icons.List()
	local names = {}
	for k in pairs(Icons.Catalog) do
		table.insert(names, k)
	end
	table.sort(names)
	return names
end

return Icons
