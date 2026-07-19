local Elements = {}
Elements.__index = Elements

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

local ELEMENT_H   = 46
local ELEMENT_PAD = 5
local CORNER_EL   = UDim.new(0, 7)
local CORNER_SM   = UDim.new(0, 5)
local ANIM_FAST   = 0.10
local ANIM_MED    = 0.16

local function tw(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or ANIM_MED, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or CORNER_EL
    c.Parent = p
    return c
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.fromRGB(40,40,40)
    s.Thickness = th or 1
    s.LineJoinMode = Enum.LineJoinMode.Round
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function pad(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 6)
    u.PaddingBottom = UDim.new(0, b or 6)
    u.PaddingLeft   = UDim.new(0, l or 10)
    u.PaddingRight  = UDim.new(0, r or 10)
    u.Parent = p
    return u
end

local function frame(parent, bg, size, pos, zi)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bg or Color3.fromRGB(20,20,20)
    f.Size = size or UDim2.fromScale(1,1)
    f.Position = pos or UDim2.new(0,0,0,0)
    f.BorderSizePixel = 0
    if zi then f.ZIndex = zi end
    f.Parent = parent
    return f
end

local function lbl(parent, text, col, sz, font, xa)
    local l = Instance.new("TextLabel")
    l.Text = text or ""
    l.TextColor3 = col or Color3.fromRGB(240,240,240)
    l.TextSize = sz or 13
    l.Font = font or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = parent
    return l
end

local function btn(parent, size, pos, zi)
    local b = Instance.new("TextButton")
    b.Size = size or UDim2.fromScale(1,1)
    b.Position = pos or UDim2.new(0,0,0,0)
    b.BackgroundTransparency = 1
    b.Text = ""
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.ZIndex = zi or 2
    b.Parent = parent
    return b
end

local function ripple(parent, theme)
    local r = frame(parent, theme.Accent, UDim2.new(0,0,0,0))
    r.AnchorPoint = Vector2.new(0.5,0.5)
    r.Position = UDim2.new(0.5,0,0.5,0)
    r.BackgroundTransparency = 0.82
    r.ZIndex = 8
    corner(r, UDim.new(1,0))
    local sz = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.4
    tw(r, {Size=UDim2.new(0,sz,0,sz), BackgroundTransparency=1}, 0.48, Enum.EasingStyle.Quart)
    task.delay(0.5, function() r:Destroy() end)
end

local keyNames = {
    [Enum.KeyCode.LeftControl]="L-CTRL",[Enum.KeyCode.RightControl]="R-CTRL",
    [Enum.KeyCode.LeftShift]="L-SHIFT",[Enum.KeyCode.RightShift]="R-SHIFT",
    [Enum.KeyCode.LeftAlt]="L-ALT",[Enum.KeyCode.RightAlt]="R-ALT",
    [Enum.KeyCode.Return]="ENTER",[Enum.KeyCode.Space]="SPACE",
    [Enum.KeyCode.Tab]="TAB",[Enum.KeyCode.Delete]="DEL",
    [Enum.KeyCode.Up]="↑",[Enum.KeyCode.Down]="↓",
    [Enum.KeyCode.Left]="←",[Enum.KeyCode.Right]="→",
    [Enum.KeyCode.F1]="F1",[Enum.KeyCode.F2]="F2",[Enum.KeyCode.F3]="F3",
    [Enum.KeyCode.F4]="F4",[Enum.KeyCode.F5]="F5",[Enum.KeyCode.F6]="F6",
    [Enum.KeyCode.F7]="F7",[Enum.KeyCode.F8]="F8",[Enum.KeyCode.F9]="F9",
    [Enum.KeyCode.F10]="F10",[Enum.KeyCode.F11]="F11",[Enum.KeyCode.F12]="F12",
}
local function keyName(kc) return keyNames[kc] or kc.Name:upper() end

local activeDropdownClose = nil

function Elements.Button(parent, page, theme, cfg)
    cfg = cfg or {}
    local disabled = cfg.Disabled or false

    local f = frame(page, cfg.Color or theme.Element, UDim2.new(1,0,0,ELEMENT_H))
    f.ClipsDescendants = true
    corner(f, CORNER_EL); stroke(f, theme.ElementStroke, 1); pad(f, 0,0,14,14)

    local hasDesc = cfg.Desc and cfg.Desc ~= ""
    if hasDesc then f.Size = UDim2.new(1,0,0,ELEMENT_H+16) end

    local tl = lbl(f, cfg.Title or "Button", theme.TextPrimary, 13, Enum.Font.GothamMedium)
    tl.Size = UDim2.new(1,-34,0,16); tl.Position = UDim2.new(0,0,0,hasDesc and 8 or math.floor((ELEMENT_H-16)/2))
    if hasDesc then
        local dl = lbl(f, cfg.Desc, theme.TextSecondary, 11, Enum.Font.Gotham)
        dl.Size = UDim2.new(1,-34,0,14); dl.Position = UDim2.new(0,0,0,26)
    end

    local arr = lbl(f, "›", theme.Accent, 22, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    arr.Size = UDim2.new(0,22,1,0); arr.Position = UDim2.new(1,-26,0,0)

    local b = btn(f)
    b.MouseEnter:Connect(function() if disabled then return end; tw(f,{BackgroundColor3=theme.ElementHover}); tw(arr,{TextColor3=theme.AccentLight}) end)
    b.MouseLeave:Connect(function() if disabled then return end; tw(f,{BackgroundColor3=cfg.Color or theme.Element}); tw(arr,{TextColor3=theme.Accent}) end)
    b.MouseButton1Click:Connect(function() if disabled then return end; ripple(f,theme); task.spawn(function() pcall(cfg.Callback or function()end) end) end)
    if disabled then f.BackgroundTransparency=0.4 end

    local obj = {_frame=f}
    function obj:SetDisabled(v) disabled=v; tw(f,{BackgroundTransparency=v and 0.4 or 0}) end
    function obj:Trigger() task.spawn(function() pcall(cfg.Callback or function()end) end) end
    return obj
end

function Elements.Toggle(parent, page, theme, cfg)
    cfg = cfg or {}
    local value    = cfg.Value ~= nil and cfg.Value or false
    local disabled = cfg.Disabled or false
    local ttype    = cfg.Type or "Default"

    local f = frame(page, cfg.Color or theme.Element, UDim2.new(1,0,0,ELEMENT_H))
    f.ClipsDescendants = true
    corner(f, CORNER_EL); stroke(f, theme.ElementStroke, 1); pad(f, 0,0,14,14)
    if cfg.Desc and cfg.Desc~="" then f.Size=UDim2.new(1,0,0,ELEMENT_H+16) end

    local tl = lbl(f, cfg.Title or "Toggle", theme.TextPrimary, 13, Enum.Font.GothamMedium)
    tl.Size=UDim2.new(1,-58,0,16); tl.Position=UDim2.new(0,0,0,math.floor((ELEMENT_H-16)/2))

    local updateFn
    if ttype=="Checkbox" then
        local box=frame(f,value and theme.Accent or theme.InputBg,UDim2.new(0,20,0,20))
        box.Position=UDim2.new(1,-24,0.5,-10); corner(box,UDim.new(0,5))
        local bs=stroke(box,value and theme.Accent or theme.ElementStroke,1.5)
        local chk=lbl(box,"✓",Color3.fromRGB(255,255,255),12,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
        chk.Size=UDim2.fromScale(1,1); chk.TextTransparency=value and 0 or 1
        updateFn=function(v) tw(box,{BackgroundColor3=v and theme.Accent or theme.InputBg}); tw(chk,{TextTransparency=v and 0 or 1}); bs.Color=v and theme.Accent or theme.ElementStroke end
    else
        local track=frame(f,value and theme.Accent or theme.ElementStroke,UDim2.new(0,38,0,20))
        track.Position=UDim2.new(1,-44,0.5,-10); corner(track,UDim.new(1,0))
        local thumb=frame(track,Color3.fromRGB(255,255,255),UDim2.new(0,14,0,14))
        thumb.AnchorPoint=Vector2.new(0,0.5); thumb.Position=value and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0); corner(thumb,UDim.new(1,0))
        updateFn=function(v) tw(track,{BackgroundColor3=v and theme.Accent or theme.ElementStroke}); tw(thumb,{Position=v and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)}) end
    end

    local b=btn(f)
    b.MouseEnter:Connect(function() if not disabled then tw(f,{BackgroundColor3=theme.ElementHover}) end end)
    b.MouseLeave:Connect(function() if not disabled then tw(f,{BackgroundColor3=cfg.Color or theme.Element}) end end)
    b.MouseButton1Click:Connect(function()
        if disabled then return end
        value=not value; updateFn(value)
        task.spawn(function() pcall(cfg.Callback or function()end,value) end)
    end)
    if disabled then f.BackgroundTransparency=0.4 end

    local obj={_frame=f}
    function obj:Set(v) value=v; updateFn(v) end
    function obj:Get() return value end
    function obj:SetDisabled(v) disabled=v; tw(f,{BackgroundTransparency=v and 0.4 or 0}) end
    return obj
end

function Elements.Slider(parent, page, theme, cfg)
    cfg = cfg or {}
    local mn=cfg.Min or 0; local mx=cfg.Max or 100
    local value=math.clamp(cfg.Value or mn,mn,mx)
    local suffix=cfg.Suffix or ""; local step=cfg.Step or 1
    local disabled=cfg.Disabled or false
    local hasDesc=cfg.Desc and cfg.Desc~=""
    local h=hasDesc and 82 or 66

    local f=frame(page,cfg.Color or theme.Element,UDim2.new(1,0,0,h))
    f.BorderSizePixel=0; corner(f,CORNER_EL); stroke(f,theme.ElementStroke,1); pad(f,0,0,14,14)

    local valLbl=lbl(f,tostring(value)..suffix,theme.Accent,12,Enum.Font.GothamBold,Enum.TextXAlignment.Right)
    valLbl.Size=UDim2.new(0,60,0,16); valLbl.Position=UDim2.new(1,-62,0,10)

    local tl=lbl(f,cfg.Title or "Slider",theme.TextPrimary,13,Enum.Font.GothamMedium)
    tl.Size=UDim2.new(1,-68,0,16); tl.Position=UDim2.new(0,0,0,10)
    if hasDesc then
        local dl=lbl(f,cfg.Desc,theme.TextSecondary,11,Enum.Font.Gotham)
        dl.Size=UDim2.new(1,-68,0,13); dl.Position=UDim2.new(0,0,0,27)
    end

    local trackY=hasDesc and 50 or 36
    local trackBg=frame(f,theme.ElementStroke,UDim2.new(1,0,0,6))
    trackBg.Position=UDim2.new(0,0,0,trackY); corner(trackBg,UDim.new(1,0))

    local pct=(value-mn)/(mx-mn)
    local fill=frame(trackBg,theme.Accent,UDim2.new(pct,0,1,0)); corner(fill,UDim.new(1,0))
    local thumb=frame(trackBg,Color3.fromRGB(255,255,255),UDim2.new(0,16,0,16))
    thumb.AnchorPoint=Vector2.new(0.5,0.5); thumb.Position=UDim2.new(pct,0,0.5,0)
    thumb.ZIndex=3; corner(thumb,UDim.new(1,0)); stroke(thumb,theme.Accent,2)

    local dragging=false
    local function update(x)
        if disabled then return end
        local rel=math.clamp((x-trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
        value=math.clamp(math.floor((mn+rel*(mx-mn))/step+0.5)*step,mn,mx)
        local p2=(value-mn)/(mx-mn)
        tw(fill,{Size=UDim2.new(p2,0,1,0)},0.06); tw(thumb,{Position=UDim2.new(p2,0,0.5,0)},0.06)
        valLbl.Text=tostring(value)..suffix
        task.spawn(function() pcall(cfg.Callback or function()end,value) end)
    end

    trackBg.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; page.ScrollingEnabled=false; update(i.Position.X)
        end
    end)
    thumb.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; page.ScrollingEnabled=false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then update(i.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            if dragging then dragging=false; page.ScrollingEnabled=true end
        end
    end)

    if disabled then f.BackgroundTransparency=0.4 end
    local obj={_frame=f}
    function obj:Get() return value end
    function obj:Set(v) value=math.clamp(v,mn,mx); local p2=(value-mn)/(mx-mn); tw(fill,{Size=UDim2.new(p2,0,1,0)}); tw(thumb,{Position=UDim2.new(p2,0,0.5,0)}); valLbl.Text=tostring(value)..suffix end
    function obj:SetDisabled(v) disabled=v; tw(f,{BackgroundTransparency=v and 0.4 or 0}) end
    return obj
end

function Elements.Dropdown(parent, page, theme, cfg, gui)
    cfg = cfg or {}
    local values=cfg.Values or {}; local value=cfg.Value or (values[1] or "")
    local multi=cfg.Multi or false; local selected={}
    local open=false; local disabled=cfg.Disabled or false; local posConn=nil

    local f=frame(page,cfg.Color or theme.Element,UDim2.new(1,0,0,ELEMENT_H))
    f.ClipsDescendants=false; corner(f,CORNER_EL); stroke(f,theme.ElementStroke,1); pad(f,0,0,14,14)

    local tl=lbl(f,cfg.Title or "Dropdown",theme.TextPrimary,13,Enum.Font.GothamMedium)
    tl.Size=UDim2.new(1,-116,0,16); tl.Position=UDim2.new(0,0,0,math.floor((ELEMENT_H-16)/2))

    local selBox=frame(f,theme.InputBg,UDim2.new(0,104,0,26))
    selBox.Position=UDim2.new(1,-106,0.5,-13); corner(selBox,CORNER_SM); stroke(selBox,theme.ElementStroke2,1)
    local selLbl=lbl(selBox,value,theme.TextPrimary,11,Enum.Font.Gotham)
    selLbl.Size=UDim2.new(1,-22,1,0); selLbl.Position=UDim2.new(0,7,0,0); selLbl.TextTruncate=Enum.TextTruncate.AtEnd
    local chev=lbl(selBox,"▾",theme.TextSecondary,11,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    chev.Size=UDim2.new(0,18,1,0); chev.Position=UDim2.new(1,-20,0,0)

    local listCont=frame(nil,theme.BackgroundAlt,UDim2.new(0,104,0,0))
    listCont.ClipsDescendants=true; listCont.ZIndex=200; corner(listCont,CORNER_EL); stroke(listCont,theme.Accent,1)

    local function doClose()
        open=false
        if posConn then posConn:Disconnect(); posConn=nil end
        tw(listCont,{Size=UDim2.new(0,math.max(listCont.AbsoluteSize.X,104),0,0)})
        task.delay(ANIM_MED+0.02,function() if not open then listCont.Parent=nil end end)
        tw(chev,{Rotation=0})
        if activeDropdownClose==doClose then activeDropdownClose=nil end
    end

    local function doOpen()
        if activeDropdownClose and activeDropdownClose~=doClose then activeDropdownClose() end
        open=true; activeDropdownClose=doClose
        if not gui then return end
        listCont.Parent=gui
        local abs=selBox.AbsolutePosition; local sz=selBox.AbsoluteSize
        local w=math.max(sz.X+2,104); local ih=math.min(#values,6)*30+8
        listCont.Size=UDim2.new(0,w,0,0); listCont.Position=UDim2.new(0,abs.X,0,abs.Y+sz.Y+2)
        tw(listCont,{Size=UDim2.new(0,w,0,ih)}); tw(chev,{Rotation=180})
        posConn=RunService.RenderStepped:Connect(function()
            if not open or not listCont.Parent then return end
            local a2=selBox.AbsolutePosition; local s2=selBox.AbsoluteSize
            listCont.Position=UDim2.new(0,a2.X,0,a2.Y+s2.Y+2)
        end)
    end

    local listScroll=Instance.new("ScrollingFrame")
    listScroll.Size=UDim2.fromScale(1,1); listScroll.BackgroundTransparency=1
    listScroll.ScrollBarThickness=2; listScroll.ScrollBarImageColor3=theme.ScrollBar
    listScroll.CanvasSize=UDim2.new(0,0,0,0); listScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    listScroll.BorderSizePixel=0; listScroll.ZIndex=201; listScroll.Parent=listCont; pad(listScroll,4,4,4,4)
    local listLay=Instance.new("UIListLayout"); listLay.Padding=UDim.new(0,2); listLay.Parent=listScroll

    local function getDisplay()
        if multi then if #selected==0 then return "None" elseif #selected==1 then return selected[1] else return selected[1].." +"..tostring(#selected-1) end end
        return value
    end

    local function buildList()
        for _,c in ipairs(listScroll:GetChildren()) do if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end end
        for _,v in ipairs(values) do
            local isSel=multi and (table.find(selected,v)~=nil) or (v==value)
            local itemF=frame(listScroll,isSel and theme.ElementActive or theme.Element,UDim2.new(1,0,0,28))
            itemF.ZIndex=202; corner(itemF,UDim.new(0,5)); if isSel then stroke(itemF,theme.Accent,1) end
            local itemL=lbl(itemF,v,isSel and theme.Accent or theme.TextPrimary,11,Enum.Font.Gotham)
            itemL.Size=UDim2.new(1,-28,1,0); itemL.Position=UDim2.new(0,8,0,0); itemL.ZIndex=203
            if isSel then
                local ck=lbl(itemF,"✓",theme.Accent,10,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
                ck.Size=UDim2.new(0,18,1,0); ck.Position=UDim2.new(1,-20,0,0); ck.ZIndex=203
            end
            local ib=btn(itemF,UDim2.fromScale(1,1),nil,204)
            ib.MouseEnter:Connect(function() if not isSel then tw(itemF,{BackgroundColor3=theme.ElementHover}) end end)
            ib.MouseLeave:Connect(function() if not isSel then tw(itemF,{BackgroundColor3=theme.Element}) end end)
            ib.MouseButton1Click:Connect(function()
                if multi then
                    local idx=table.find(selected,v); if idx then table.remove(selected,idx) else table.insert(selected,v) end
                    selLbl.Text=getDisplay(); buildList(); task.spawn(function() pcall(cfg.Callback or function()end,selected) end)
                else value=v; selLbl.Text=v; doClose(); buildList(); task.spawn(function() pcall(cfg.Callback or function()end,value) end) end
            end)
        end
    end
    buildList()

    local mb=btn(f,UDim2.new(1,0,0,ELEMENT_H))
    mb.MouseEnter:Connect(function() if not disabled then tw(f,{BackgroundColor3=theme.ElementHover}) end end)
    mb.MouseLeave:Connect(function() if not disabled then tw(f,{BackgroundColor3=cfg.Color or theme.Element}) end end)
    mb.MouseButton1Click:Connect(function() if disabled then return end; if open then doClose() else doOpen() end end)
    if disabled then f.BackgroundTransparency=0.4 end

    local obj={_frame=f,_close=doClose}
    function obj:Get() return multi and selected or value end
    function obj:Set(v) if multi then selected=v else value=v end; selLbl.Text=getDisplay(); buildList() end
    function obj:Refresh(nv) values=nv; buildList() end
    function obj:SetDisabled(v) disabled=v; tw(f,{BackgroundTransparency=v and 0.4 or 0}) end
    return obj
end

function Elements.ColorPicker(parent, page, theme, cfg)
    cfg = cfg or {}
    local value=cfg.Value or Color3.fromRGB(255,255,255)
    local disabled=cfg.Disabled or false; local open=false
    local baseH=ELEMENT_H+(cfg.Desc and cfg.Desc~="" and 16 or 0)
    local ROW_H=26; local PANEL_H=ROW_H*3+6*2+16+12

    local f=frame(page,cfg.Color or theme.Element,UDim2.new(1,0,0,baseH))
    f.ClipsDescendants=true; corner(f,CORNER_EL); stroke(f,theme.ElementStroke,1); pad(f,0,0,14,14)

    local tl=lbl(f,cfg.Title or "Color",theme.TextPrimary,13,Enum.Font.GothamMedium)
    tl.Size=UDim2.new(1,-48,0,16); tl.Position=UDim2.new(0,0,0,math.floor((ELEMENT_H-16)/2))

    local preview=frame(f,value,UDim2.new(0,30,0,22))
    preview.Position=UDim2.new(1,-32,0.5,-11); corner(preview,CORNER_SM); stroke(preview,theme.ElementStroke,1)

    local sep=frame(f,theme.ElementStroke,UDim2.new(1,0,0,1)); sep.Position=UDim2.new(0,0,0,baseH)

    local panelInner=Instance.new("Frame"); panelInner.Size=UDim2.new(1,0,0,PANEL_H)
    panelInner.Position=UDim2.new(0,0,0,baseH+1); panelInner.BackgroundTransparency=1; panelInner.ZIndex=4; panelInner.Parent=f
    pad(panelInner,8,8,0,0)
    local play=Instance.new("UIListLayout"); play.Padding=UDim.new(0,6); play.Parent=panelInner

    local rgb={math.floor(value.R*255),math.floor(value.G*255),math.floor(value.B*255)}
    local function updateColor()
        value=Color3.fromRGB(rgb[1],rgb[2],rgb[3]); tw(preview,{BackgroundColor3=value})
        task.spawn(function() pcall(cfg.Callback or function()end,value) end)
    end

    for _,ch in ipairs({{name="R",idx=1,col=Color3.fromRGB(220,60,60)},{name="G",idx=2,col=Color3.fromRGB(60,200,80)},{name="B",idx=3,col=Color3.fromRGB(60,120,220)}}) do
        local row=frame(panelInner,Color3.fromRGB(0,0,0),UDim2.new(1,0,0,ROW_H)); row.BackgroundTransparency=1
        local cl=lbl(row,ch.name,theme.TextSecondary,10,Enum.Font.GothamBold); cl.Size=UDim2.new(0,14,1,0)
        local tr=frame(row,theme.ElementStroke,UDim2.new(1,-54,0,5)); tr.Position=UDim2.new(0,18,0.5,-2); corner(tr,UDim.new(1,0))
        local fi=frame(tr,ch.col,UDim2.new(rgb[ch.idx]/255,0,1,0)); corner(fi,UDim.new(1,0)); fi.BackgroundTransparency=0.2
        local th2=frame(tr,Color3.fromRGB(255,255,255),UDim2.new(0,12,0,12)); th2.AnchorPoint=Vector2.new(0.5,0.5); th2.Position=UDim2.new(rgb[ch.idx]/255,0,0.5,0); th2.ZIndex=5; corner(th2,UDim.new(1,0)); stroke(th2,ch.col,1.5)
        local vi=Instance.new("TextBox"); vi.Size=UDim2.new(0,30,0,18); vi.Position=UDim2.new(1,-30,0.5,-9); vi.BackgroundColor3=theme.InputBg; vi.Text=tostring(rgb[ch.idx]); vi.TextColor3=theme.TextPrimary; vi.TextSize=10; vi.Font=Enum.Font.Gotham; vi.TextXAlignment=Enum.TextXAlignment.Center; vi.ClearTextOnFocus=true; vi.BorderSizePixel=0; vi.ZIndex=6; corner(vi,UDim.new(0,3)); vi.Parent=row
        vi.FocusLost:Connect(function() local v=math.clamp(tonumber(vi.Text) or rgb[ch.idx],0,255); rgb[ch.idx]=math.floor(v); vi.Text=tostring(rgb[ch.idx]); tw(fi,{Size=UDim2.new(v/255,0,1,0)},0.06); tw(th2,{Position=UDim2.new(v/255,0,0.5,0)},0.06); updateColor() end)
        local drag2=false
        tr.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag2=true; page.ScrollingEnabled=false; local r2=math.clamp((i.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1); rgb[ch.idx]=math.floor(r2*255); vi.Text=tostring(rgb[ch.idx]); tw(fi,{Size=UDim2.new(r2,0,1,0)},0.05); tw(th2,{Position=UDim2.new(r2,0,0.5,0)},0.05); updateColor() end end)
        UserInputService.InputChanged:Connect(function(i) if drag2 and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local r2=math.clamp((i.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1); rgb[ch.idx]=math.floor(r2*255); vi.Text=tostring(rgb[ch.idx]); tw(fi,{Size=UDim2.new(r2,0,1,0)},0.05); tw(th2,{Position=UDim2.new(r2,0,0.5,0)},0.05); updateColor() end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then if drag2 then drag2=false; page.ScrollingEnabled=true end end end)
    end

    local hb=btn(f,UDim2.new(1,0,0,baseH),nil,3)
    hb.MouseButton1Click:Connect(function() if disabled then return end; open=not open; if open then tw(f,{Size=UDim2.new(1,0,0,baseH+1+PANEL_H+8)}); tw(sep,{BackgroundColor3=theme.Accent},ANIM_FAST) else tw(f,{Size=UDim2.new(1,0,0,baseH)}); tw(sep,{BackgroundColor3=theme.ElementStroke},ANIM_FAST) end end)
    hb.MouseEnter:Connect(function() if not disabled then tw(f,{BackgroundColor3=theme.ElementHover}) end end)
    hb.MouseLeave:Connect(function() if not disabled then tw(f,{BackgroundColor3=cfg.Color or theme.Element}) end end)
    if disabled then f.BackgroundTransparency=0.4 end

    local obj={_frame=f}
    function obj:Get() return value end
    function obj:Set(col) value=col; rgb={math.floor(col.R*255),math.floor(col.G*255),math.floor(col.B*255)}; tw(preview,{BackgroundColor3=value}) end
    return obj
end

function Elements.Input(parent, page, theme, cfg)
    cfg = cfg or {}
    local multiline=cfg.MultiLine or false; local disabled=cfg.Disabled or false
    local boxH=multiline and 52 or 28; local totalH=12+16+6+boxH+8
    local f=frame(page,cfg.Color or theme.Element,UDim2.new(1,0,0,totalH))
    f.ClipsDescendants=true; corner(f,CORNER_EL); stroke(f,theme.ElementStroke,1); pad(f,0,0,14,14)
    local tl=lbl(f,cfg.Title or "Input",theme.TextPrimary,13,Enum.Font.GothamMedium); tl.Size=UDim2.new(1,0,0,16); tl.Position=UDim2.new(0,0,0,12)
    local box=frame(f,theme.InputBg,UDim2.new(1,0,0,boxH)); box.Position=UDim2.new(0,0,0,34); corner(box,CORNER_SM); local bs=stroke(box,theme.ElementStroke2,1)
    local inp=Instance.new("TextBox"); inp.Size=UDim2.new(1,-12,1,0); inp.Position=UDim2.new(0,6,0,0); inp.BackgroundTransparency=1; inp.Text=cfg.Value or ""; inp.PlaceholderText=cfg.Placeholder or "Enter value..."; inp.TextColor3=theme.TextPrimary; inp.PlaceholderColor3=theme.TextDisabled; inp.TextSize=12; inp.Font=Enum.Font.Gotham; inp.TextXAlignment=Enum.TextXAlignment.Left; inp.ClearTextOnFocus=cfg.ClearOnFocus~=nil and cfg.ClearOnFocus or false; inp.MultiLine=multiline; inp.TextWrapped=multiline; inp.TextEditable=not disabled; inp.Parent=box
    inp.Focused:Connect(function() tw(box,{BackgroundColor3=theme.ElementHover}); tw(bs,{Color=theme.Accent},ANIM_FAST) end)
    inp.FocusLost:Connect(function(enter) tw(box,{BackgroundColor3=theme.InputBg}); tw(bs,{Color=theme.ElementStroke2},ANIM_FAST); if enter then task.spawn(function() pcall(cfg.Callback or function()end,inp.Text) end) end end)
    if disabled then f.BackgroundTransparency=0.4 end
    local obj={_frame=f}
    function obj:Get() return inp.Text end
    function obj:Set(v) inp.Text=v end
    function obj:SetDisabled(v) disabled=v; inp.TextEditable=not v; tw(f,{BackgroundTransparency=v and 0.4 or 0}) end
    return obj
end

function Elements.ProgressBar(parent, page, theme, cfg)
    cfg = cfg or {}
    local value=math.clamp(cfg.Value or 0,0,100); local suffix=cfg.Suffix or "%"; local showPct=cfg.ShowValue~=false
    local hasDesc=cfg.Desc and cfg.Desc~=""; local h=hasDesc and 72 or 58
    local f=frame(page,cfg.Color or theme.Element,UDim2.new(1,0,0,h))
    f.ClipsDescendants=true; corner(f,CORNER_EL); stroke(f,theme.ElementStroke,1); pad(f,0,0,14,14)
    local tl=lbl(f,cfg.Title or "Progress",theme.TextPrimary,13,Enum.Font.GothamMedium); tl.Size=UDim2.new(1,-60,0,16); tl.Position=UDim2.new(0,0,0,10)
    local pctLbl=nil
    if showPct then pctLbl=lbl(f,tostring(math.floor(value))..suffix,theme.Accent,11,Enum.Font.GothamBold,Enum.TextXAlignment.Right); pctLbl.Size=UDim2.new(0,54,0,16); pctLbl.Position=UDim2.new(1,-56,0,10) end
    if hasDesc then local dl=lbl(f,cfg.Desc,theme.TextSecondary,11,Enum.Font.Gotham); dl.Size=UDim2.new(1,-60,0,13); dl.Position=UDim2.new(0,0,0,27) end
    local trackBg=frame(f,theme.ElementStroke,UDim2.new(1,0,0,7)); trackBg.Position=UDim2.new(0,0,0,hasDesc and 50 or 34); corner(trackBg,UDim.new(1,0))
    local fill=frame(trackBg,cfg.FillColor or theme.Accent,UDim2.new(value/100,0,1,0)); corner(fill,UDim.new(1,0))
    local obj={_frame=f}
    function obj:Set(v) v=math.clamp(v,0,100); value=v; tw(fill,{Size=UDim2.new(v/100,0,1,0)}); if pctLbl then pctLbl.Text=tostring(math.floor(v))..suffix end end
    function obj:Get() return value end
    return obj
end

function Elements.Countdown(parent, page, theme, cfg)
    cfg = cfg or {}
    local seconds=cfg.Seconds or 60; local fmt=cfg.Format or "MM:SS"
    local remaining=seconds; local running=false; local heartbeat=nil
    local f=frame(page,cfg.Color or theme.Element,UDim2.new(1,0,0,58))
    f.ClipsDescendants=true; corner(f,CORNER_EL); stroke(f,theme.ElementStroke,1); pad(f,0,0,14,14)
    local tl=lbl(f,cfg.Title or "Countdown",theme.TextPrimary,13,Enum.Font.GothamMedium); tl.Size=UDim2.new(1,-100,0,16); tl.Position=UDim2.new(0,0,0,10)
    local function formatTime(s) if fmt=="SS" then return tostring(math.floor(s)).."s" end; return string.format("%02d:%02d",math.floor(s/60),math.floor(s%60)) end
    local timeLbl=lbl(f,formatTime(remaining),theme.Accent,18,Enum.Font.GothamBold,Enum.TextXAlignment.Right); timeLbl.Size=UDim2.new(0,90,0,26); timeLbl.Position=UDim2.new(1,-92,0.5,-13)
    local trackBg=frame(f,theme.ElementStroke,UDim2.new(1,0,0,4)); trackBg.Position=UDim2.new(0,0,1,-6); corner(trackBg,UDim.new(1,0))
    local fill=frame(trackBg,cfg.FillColor or theme.Accent,UDim2.new(1,0,1,0)); corner(fill,UDim.new(1,0))
    local function stop() running=false; if heartbeat then heartbeat:Disconnect(); heartbeat=nil end end
    local function start()
        if running then return end; running=true; local last=tick()
        heartbeat=RunService.Heartbeat:Connect(function() local now=tick(); local dt=now-last; last=now; remaining=math.max(0,remaining-dt); timeLbl.Text=formatTime(remaining); fill.Size=UDim2.new(remaining/seconds,0,1,0); if remaining<=0 then stop(); task.spawn(function() pcall(cfg.OnEnd or function()end) end) end end)
    end
    if cfg.AutoStart~=false then start() end
    local obj={_frame=f}
    function obj:Start() start() end; function obj:Stop() stop() end
    function obj:Reset() stop(); remaining=seconds; timeLbl.Text=formatTime(remaining); fill.Size=UDim2.new(1,0,1,0) end
    function obj:Get() return remaining end
    return obj
end

function Elements.Table(parent, page, theme, cfg)
    cfg = cfg or {}
    local headers=cfg.Headers or {}; local rows=cfg.Rows or {}
    local rowH=28; local headH=30; local totalH=headH+#rows*rowH+20
    local f=frame(page,cfg.Color or theme.Element,UDim2.new(1,0,0,totalH))
    f.ClipsDescendants=true; corner(f,CORNER_EL); stroke(f,theme.ElementStroke,1)
    if cfg.Title and cfg.Title~="" then
        local tl=lbl(f,cfg.Title,theme.TextPrimary,13,Enum.Font.GothamBold); tl.Size=UDim2.new(1,0,0,16); tl.Position=UDim2.new(0,14,0,8); f.Size=UDim2.new(1,0,0,totalH+24)
    end
    local yOff=(cfg.Title and cfg.Title~="") and 28 or 8; local colW=#headers>0 and (1/#headers) or 1
    local headRow=frame(f,theme.BackgroundAlt,UDim2.new(1,-2,0,headH)); headRow.Position=UDim2.new(0,1,0,yOff)
    for i,h in ipairs(headers) do local hl=lbl(headRow,h,theme.TextSecondary,10,Enum.Font.GothamBold); hl.Size=UDim2.new(colW,0,1,0); hl.Position=UDim2.new(colW*(i-1),0,0,0); pad(hl,0,0,10,0) end
    for ri,row in ipairs(rows) do
        local rowBg=frame(f,ri%2==0 and theme.Element or theme.BackgroundAlt,UDim2.new(1,-2,0,rowH)); rowBg.Position=UDim2.new(0,1,0,yOff+headH+(ri-1)*rowH)
        for ci,cell in ipairs(row) do local cl=lbl(rowBg,tostring(cell),theme.TextPrimary,11,Enum.Font.Gotham); cl.Size=UDim2.new(colW,0,1,0); cl.Position=UDim2.new(colW*(ci-1),0,0,0); pad(cl,0,0,10,0) end
    end
    return {_frame=f}
end

function Elements.Card(parent, page, theme, cfg)
    cfg = cfg or {}
    local h=cfg.Height or 78
    local f=frame(page,cfg.Color or theme.CardBg,UDim2.new(1,0,0,h))
    f.ClipsDescendants=true; corner(f,CORNER_EL); stroke(f,theme.CardStroke,1); pad(f,10,10,14,14)
    if cfg.Icon then local ic=lbl(f,cfg.Icon,theme.Accent,20,Enum.Font.GothamBold,Enum.TextXAlignment.Center); ic.Size=UDim2.new(0,26,0,26); ic.Position=UDim2.new(1,-30,0,0) end
    if cfg.Title and cfg.Title~="" then local tl=lbl(f,cfg.Title,theme.TextPrimary,13,Enum.Font.GothamBold); tl.Size=UDim2.new(1,-36,0,17); tl.Position=UDim2.new(0,0,0,2) end
    local valLbl=nil
    if cfg.Value~=nil then valLbl=lbl(f,tostring(cfg.Value),cfg.ValueColor or theme.Accent,22,Enum.Font.GothamBold); valLbl.Size=UDim2.new(1,0,0,28); valLbl.Position=UDim2.new(0,0,0,22) end
    if cfg.Desc and cfg.Desc~="" then local dl=lbl(f,cfg.Desc,theme.TextSecondary,11,Enum.Font.Gotham); dl.Size=UDim2.new(1,0,0,14); dl.Position=UDim2.new(0,0,1,-16) end
    if cfg.Callback then
        local b=btn(f); b.MouseButton1Click:Connect(function() ripple(f,theme); task.spawn(function() pcall(cfg.Callback) end) end)
        b.MouseEnter:Connect(function() tw(f,{BackgroundColor3=theme.ElementHover}) end)
        b.MouseLeave:Connect(function() tw(f,{BackgroundColor3=cfg.Color or theme.CardBg}) end)
    end
    local obj={_frame=f}
    function obj:SetValue(v) if valLbl then valLbl.Text=tostring(v) end end
    return obj
end

function Elements.Paragraph(parent, page, theme, cfg)
    cfg = cfg or {}
    local leftPad=(cfg.AccentBar and cfg.AccentBar~=false) and 18 or 14
    local outer=Instance.new("Frame"); outer.Size=UDim2.new(1,0,0,0); outer.AutomaticSize=Enum.AutomaticSize.Y
    outer.BackgroundColor3=cfg.Color or theme.Element; outer.BorderSizePixel=0; outer.ClipsDescendants=true
    if cfg.Transparency then outer.BackgroundTransparency=cfg.Transparency end
    corner(outer,CORNER_EL); stroke(outer,theme.ElementStroke,1)
    if cfg.AccentBar and cfg.AccentBar~=false then
        local abar=frame(outer,cfg.AccentBar,UDim2.new(0,3,0,500)); abar.Position=UDim2.new(0,0,0,0); abar.ZIndex=2; corner(abar,UDim.new(0,2))
    end
    local inner=Instance.new("Frame"); inner.Size=UDim2.new(1,0,0,0); inner.AutomaticSize=Enum.AutomaticSize.Y
    inner.BackgroundTransparency=1; inner.BorderSizePixel=0; inner.Parent=outer; pad(inner,10,10,leftPad,14)
    local lay=Instance.new("UIListLayout"); lay.Padding=UDim.new(0,5); lay.Parent=inner
    if cfg.Title and cfg.Title~="" then local tl=lbl(inner,cfg.Title,theme.TextPrimary,13,Enum.Font.GothamBold); tl.Size=UDim2.new(1,0,0,0); tl.AutomaticSize=Enum.AutomaticSize.Y; tl.TextWrapped=true; tl.TextYAlignment=Enum.TextYAlignment.Top end
    if cfg.Desc and cfg.Desc~="" then local dl=lbl(inner,cfg.Desc,theme.TextSecondary,12,Enum.Font.Gotham); dl.Size=UDim2.new(1,0,0,0); dl.AutomaticSize=Enum.AutomaticSize.Y; dl.TextWrapped=true; dl.TextYAlignment=Enum.TextYAlignment.Top end
    outer.Parent=page; return outer
end

function Elements.Section(parent, page, theme, cfg)
    cfg = cfg or {}
    local f=frame(page,Color3.fromRGB(0,0,0),UDim2.new(1,0,0,26)); f.BackgroundTransparency=1
    local accent=frame(f,theme.Accent,UDim2.new(0,3,0.7,0)); accent.Position=UDim2.new(0,0,0.15,0); corner(accent,UDim.new(0,2))
    local sl=lbl(f,cfg.Title or "Section",theme.TextSecondary,11,Enum.Font.GothamBold); sl.Size=UDim2.new(1,-10,1,0); sl.Position=UDim2.new(0,10,0,0)
    f.Parent=page; return f
end

function Elements.Divider(parent, page, theme, cfg)
    cfg = cfg or {}
    local f=frame(page,Color3.fromRGB(0,0,0),UDim2.new(1,0,0,20)); f.BackgroundTransparency=1
    local line=frame(f,cfg.Color or theme.ElementStroke,UDim2.new(1,0,0,1)); line.Position=UDim2.new(0,0,0.5,0); line.AnchorPoint=Vector2.new(0,0.5)
    if cfg.Label and cfg.Label~="" then
        local bg=frame(f,theme.Background,UDim2.new(0,0,1,0)); bg.AutomaticSize=Enum.AutomaticSize.X; bg.AnchorPoint=Vector2.new(0.5,0); bg.Position=UDim2.new(0.5,0,0,0); bg.BorderSizePixel=0
        local ll=lbl(bg,"  "..cfg.Label.."  ",theme.TextDisabled,11,Enum.Font.Gotham,Enum.TextXAlignment.Center); ll.Size=UDim2.new(1,0,1,0)
    end
    f.Parent=page; return f
end

function Elements.Label(parent, page, theme, cfg)
    cfg = cfg or {}
    local f=frame(page,Color3.fromRGB(0,0,0),UDim2.new(1,0,0,cfg.Height or 22)); f.BackgroundTransparency=1
    local l=lbl(f,cfg.Text or "",cfg.Color or theme.TextSecondary,cfg.Size or 12,cfg.Font or Enum.Font.Gotham,cfg.Align or Enum.TextXAlignment.Left); l.Size=UDim2.fromScale(1,1); l.TextWrapped=cfg.Wrap or false
    f.Parent=page; local obj={_frame=f,_lbl=l}; function obj:Set(v) l.Text=v end; function obj:SetColor(v) l.TextColor3=v end; return obj
end

function Elements.Space(parent, page, theme, cfg)
    cfg = cfg or {}
    local f=frame(page,Color3.fromRGB(0,0,0),UDim2.new(1,0,0,cfg.Height or 8)); f.BackgroundTransparency=1; f.Parent=page; return f
end

return Elements
