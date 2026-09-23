if _G.primas then return end
_G.primas = true

setfpscap(9999)
repeat task.wait() until game:IsLoaded()

cloneref = cloneref or function(x) return x end

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))
local Debris = cloneref(game:GetService("Debris"))
local Stats = cloneref(game:GetService("Stats"))
local LocalPlayer = Players.LocalPlayer

_G.config = {
    accuracy = nil,
    spam_threshold = nil,
    curve_keybind = nil,
    manual_notify = nil,
    curve_notify = nil,
    curve_method = '',
    anti_phantom = nil,
    anti_cooldown = nil,
    skin_changer = nil,
    manual_spam = nil,
    manual_spam_kps = nil,
    ability_esp = nil,
    auto_parry = nil,
    ball_debug = nil,
    auto_spam = nil,
    ping_fix = nil,
    names = '',
    avatar_changer = nil,
    avatar_name = '',
    random_target = nil,
    theme_accent = nil,
    theme_accent_dark = nil,
    theme_background = nil,
    theme_text = nil,
    ui_keybind = nil,
    det_infinity = nil,
    det_deathslash = nil,
    det_timehole = nil,
    det_pull = nil,
    det_singularity = nil,
    det_slashes = nil,
    det_slashes_delay = nil,
    det_slashes_max = nil,
    det_forcefield = nil,
    det_staff = nil,
    det_staff_action = nil,
    animfix_parry = nil,
    animfix_spam = nil,
    animfix_manual = nil,
    player_cosmetics = nil,
    triggerbot_notify = nil,
    manual_spam_ui = nil,
    triggerbot_ui = nil,
    thunder_dash_nocd = nil,
    super_jump_nocd = nil,
    dash_nocd = nil,
    immortality = nil,
    immortal_notify = nil,
    immortal_radius = nil,
    immortal_height = nil,
    custom_announcer = nil,
    announcer_text = nil,
}

if not isfolder("angeli/configs") then
    makefolder("angeli/configs")
end
local CONFIG_PATH = "angeli/configs/blade_ball.json"

local function save_cfg()
    writefile(CONFIG_PATH, HttpService:JSONEncode(_G.config))
end

local function load_cfg()
    if isfile(CONFIG_PATH) then
        _G.config = HttpService:JSONDecode(readfile(CONFIG_PATH))
    end
end

load_cfg()

task.spawn(function()
    repeat
        save_cfg()
        task.wait(1)
    until not _G.primas
end)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Library = {}

Library.Flags = {}
Library.Windows = {}

local function normalize(source, map)
    local opts = {}
    if type(source) == "string" then
        opts.Name = source
    elseif type(source) == "table" then
        for key, value in pairs(source) do
            opts[key] = value
        end
    end
    for from, to in pairs(map or {}) do
        if opts[to] == nil and opts[from] ~= nil then
            opts[to] = opts[from]
        end
    end
    if opts.Range then
        opts.Min = opts.Min or opts.Range[1]
        opts.Max = opts.Max or opts.Range[2]
    end
    return opts
end

local function finishElement(tab, opts, element, frame, kind)
    element._type = kind
    element._frame = frame
    element._listeners = element._listeners or {}
    local window = tab and tab.Window
    if opts.Flag then
        Library.Flags[opts.Flag] = element
        if window then
            local callback = opts.Callback
            opts.Callback = function(...)
                if type(callback) == "function" then
                    callback(...)
                end
                window:_autoSave()
            end
        end
    end
    function element:Destroy()
        if element._destroyed then
            return
        end
        element._destroyed = true
        for _, disconnect in ipairs(element._listeners) do
            disconnect()
        end
        element._listeners = {}
        if opts.Flag and Library.Flags[opts.Flag] == element then
            Library.Flags[opts.Flag] = nil
        end
        if window then
            window._controlsDirty = true
        end
        if frame then
            frame:Destroy()
        end
    end
    return element
end

Library.Theme = {
    Background = Color3.fromRGB(13, 17, 24),
    Surface = Color3.fromRGB(17, 23, 32),
    Surface2 = Color3.fromRGB(23, 31, 43),
    Surface3 = Color3.fromRGB(33, 45, 63),
    Stroke = Color3.fromRGB(30, 40, 57),
    StrokeHover = Color3.fromRGB(70, 100, 150),
    Accent = Color3.fromRGB(125, 211, 252),
    AccentDark = Color3.fromRGB(30, 64, 175),
    Text = Color3.fromRGB(235, 240, 248),
    Muted = Color3.fromRGB(129, 145, 166),
    Warning = Color3.fromRGB(240, 176, 108),
    Success = Color3.fromRGB(150, 220, 170),
    Error = Color3.fromRGB(240, 120, 120),
}

Library.Assets = {
    Shadow = "rbxassetid://6014261993",
    Glow = "rbxassetid://8992230677",
    Logo = "rbxassetid://103859712365480",
}

local LUCIDE_URL = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"
local lucideSet = nil

local function loadLucide()
    if lucideSet ~= nil then
        return lucideSet
    end
    local ok, result = pcall(function()
        local source = game:HttpGet(LUCIDE_URL)
        return loadstring(source)()
    end)
    if ok and type(result) == "table" then
        lucideSet = result
    else
        lucideSet = false
        warn("[AirFlow] lucide icons unavailable: " .. tostring(result))
    end
    return lucideSet
end

local FONT_PRESETS = {
    ValleySans = {
        Regular = "https://raw.githubusercontent.com/HelsinkiTypeStudio/valley-sans/main/fonts/ttf/ValleySans-Regular.ttf",
        Medium = "https://raw.githubusercontent.com/HelsinkiTypeStudio/valley-sans/main/fonts/ttf/ValleySans-Medium.ttf",
        SemiBold = "https://raw.githubusercontent.com/HelsinkiTypeStudio/valley-sans/main/fonts/ttf/ValleySans-SemiBold.ttf",
    },
}

local FONT_WEIGHTS = {
    Regular = { 400, Enum.FontWeight.Regular },
    Medium = { 500, Enum.FontWeight.Medium },
    SemiBold = { 600, Enum.FontWeight.SemiBold },
    Bold = { 700, Enum.FontWeight.Bold },
}

function Library:LoadFont(opts)
    opts = normalize(opts, {})
    if type(writefile) ~= "function" or type(isfile) ~= "function" or typeof(getcustomasset) ~= "function" then
        warn("[AirFlow] custom fonts need writefile, isfile and getcustomasset")
        return false
    end
    local name = opts.Name or "CustomFont"
    local weights = opts.Weights or FONT_PRESETS[name]
    if type(weights) ~= "table" then
        warn("[AirFlow] no font weights for " .. name)
        return false
    end
    local folder = opts.Folder or "AirFlowFonts"
    pcall(function()
        if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(folder) then
            makefolder(folder)
        end
    end)
    local faces = {}
    for weightName, url in pairs(weights) do
        local info = FONT_WEIGHTS[weightName]
        if info then
            local path = folder .. "/" .. name .. "-" .. weightName .. ".ttf"
            local ok = true
            if not isfile(path) then
                ok = pcall(function()
                    writefile(path, game:HttpGet(url))
                end)
            end
            if ok then
                table.insert(faces, { name = weightName, weight = info[1], style = "normal", assetId = getcustomasset(path) })
            else
                warn("[AirFlow] could not download " .. weightName .. " weight of " .. name)
            end
        end
    end
    if #faces == 0 then
        return false
    end
    local familyPath = folder .. "/" .. name .. ".json"
    local okWrite = pcall(function()
        writefile(familyPath, HttpService:JSONEncode({ name = name, faces = faces }))
    end)
    if not okWrite then
        return false
    end
    local family = getcustomasset(familyPath)
    local function face(weightName, fallback)
        local info = FONT_WEIGHTS[weightName]
        if info and weights[weightName] then
            return Font.new(family, info[2])
        end
        return fallback
    end
    Library.Fonts.Regular = face("Regular", Library.Fonts.Regular)
    Library.Fonts.Medium = face("Medium", face("Regular", Library.Fonts.Medium))
    Library.Fonts.Bold = face("SemiBold", face("Bold", Library.Fonts.Bold))
    return true
end

function Library:PreloadIcons()
    return loadLucide() ~= false
end

local function resolveIcon(icon)
    if typeof(icon) == "table" then
        return icon.Image, icon.RectOffset, icon.RectSize
    end
    if type(icon) ~= "string" then
        return nil
    end
    if icon:find("^rbxassetid://") or icon:find("^rbxasset://") or icon:find("^http") then
        return icon
    end
    local name = icon:gsub("^lucide:", "")
    local set = loadLucide()
    if not set then
        return nil
    end
    local entry = (set.Icons and set.Icons[name]) or set[name]
    if type(entry) == "table" then
        local image = entry.Image
        if type(image) == "number" then
            image = "rbxassetid://" .. tostring(image)
        end
        local sheet = (set.Spritesheets and set.Spritesheets[tostring(image)]) or image
        return sheet, entry.ImageRectPosition, entry.ImageRectSize
    elseif type(entry) == "string" then
        return entry
    end
    warn("[AirFlow] unknown lucide icon: " .. name)
    return nil
end

local BUTTON_HINT_ICON = "chevron-right"

local FONT_FAMILY = "rbxasset://fonts/families/BuilderSans.json"
Library.Fonts = {
    Regular = Font.new(FONT_FAMILY, Enum.FontWeight.Regular),
    Medium = Font.new(FONT_FAMILY, Enum.FontWeight.Medium),
    Bold = Font.new(FONT_FAMILY, Enum.FontWeight.SemiBold),
}

local Theme = Library.Theme
local Assets = Library.Assets
local Fonts = Library.Fonts

local TOUCH = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
Library.Touch = TOUCH

local SIDEBAR_WIDTH = 170
local HEADER_HEIGHT = 72
local CARD_HEIGHT = TOUCH and 54 or 48
local CARD_HEIGHT_DESC = TOUCH and 70 or 64
local DROPDOWN_OPTION_HEIGHT = TOUCH and 40 or 34
local CHIP_HEIGHT = TOUCH and 34 or 28

local tweenInfoCache = {}

local function tween(object, props, duration, style, direction)
    duration = duration or 0.2
    if duration <= 0 then
        for key, value in pairs(props) do
            object[key] = value
        end
        return nil
    end
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    local key = duration .. style.Name .. direction.Name
    local info = tweenInfoCache[key]
    if not info then
        info = TweenInfo.new(duration, style, direction)
        tweenInfoCache[key] = info
    end
    local t = TweenService:Create(object, info, props)
    t:Play()
    return t
end

local function create(className, props, children)
    local inst = Instance.new(className)
    for key, value in pairs(props) do
        if key ~= "Parent" then
            inst[key] = value
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = inst
        end
    end

    if props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function corner(parent, radius)
    return create("UICorner", {
        CornerRadius = radius or UDim.new(0, 8),
        Parent = parent,
    })
end

local function stroke(parent, color, transparency, thickness)
    return create("UIStroke", {
        Color = color or Theme.Stroke,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

local function padding(parent, left, right, top, bottom)
    return create("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        Parent = parent,
    })
end

local function label(props)
    local defaults = {
        BackgroundTransparency = 1,
        TextColor3 = Theme.Text,
        TextSize = 14,
        FontFace = Fonts.Medium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }
    for key, value in pairs(props) do
        defaults[key] = value
    end
    return create("TextLabel", defaults)
end

local function glow(parent, size, position, transparency, rotation)
    local image = create("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = position,
        Size = size,
        BackgroundTransparency = 1,
        Image = Assets.Glow,
        ImageColor3 = Color3.fromRGB(205, 222, 245),
        ImageTransparency = transparency,
        ZIndex = 0,
        Parent = parent,
    })
    create("UIGradient", {
        Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Theme.Accent),
        Rotation = rotation or 90,
        Parent = image,
    })
    return image
end

local function edgeHighlight(parent)
    return create("Frame", {
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.93,
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = parent,
    })
end

local function applyIcon(imageLabel, icon)
    local image, rectOffset, rectSize = resolveIcon(icon)
    if not image then
        return
    end
    imageLabel.Image = image
    imageLabel.ImageRectOffset = rectOffset or Vector2.zero
    imageLabel.ImageRectSize = rectSize or Vector2.zero
end

local function defaultParent()
    local hidden
    pcall(function()
        if typeof(gethui) == "function" then
            hidden = gethui()
        end
    end)
    if typeof(hidden) == "Instance" then
        return hidden
    end
    local core
    pcall(function()
        core = game:GetService("CoreGui")
        local probe = Instance.new("Folder")
        probe.Parent = core
        probe:Destroy()
    end)
    if core then
        return core
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local insetFrame, insetValue = nil, Vector2.zero
local function pointerPosition()
    local frame = time()
    if insetFrame ~= frame then
        insetFrame = frame
        insetValue = GuiService:GetGuiInset()
    end
    return UserInputService:GetMouseLocation() - insetValue
end

local function isPress(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end

local function glowIcon(parent, icon, color, position)
    local holder = create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = position,
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    local image = create("ImageLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ImageColor3 = color,
        ScaleType = Enum.ScaleType.Fit,
        Parent = holder,
    })
    applyIcon(image, icon)
    return holder, image
end

local function arrowIndicator(parent, anchorX, offsetX)
    local holder = create("Frame", {
        AnchorPoint = Vector2.new(anchorX, 0.5),
        Position = UDim2.new(anchorX, offsetX, 0.5, 0),
        Size = UDim2.fromOffset(18, 18),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    local indicator = {}
    local image = create("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        ImageColor3 = Theme.Muted,
        ScaleType = Enum.ScaleType.Fit,
        Parent = holder,
    })
    applyIcon(image, "chevron-down")
    if image.Image ~= "" then
        function indicator:Set(open)
            tween(image, {
                Rotation = open and 180 or 0,
                ImageColor3 = open and Theme.Accent or Theme.Muted,
            }, 0.3, Enum.EasingStyle.Quint)
        end
        return indicator
    end
    image:Destroy()
    local function glyph(rotation, transparency)
        return label({
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(18, 18),
            Text = "â€º",
            TextSize = 22,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextColor3 = Theme.Muted,
            TextTransparency = transparency,
            Rotation = rotation,
            Parent = holder,
        })
    end
    local down = glyph(90, 0)
    local up = glyph(270, 1)
    function indicator:Set(open)
        tween(down, { TextTransparency = open and 1 or 0 }, 0.2)
        tween(up, { TextTransparency = open and 0 or 1, TextColor3 = open and Theme.Accent or Theme.Muted }, 0.2)
    end
    return indicator
end

local ripplePool = {}

local function ripple(button)
    local mouse = pointerPosition()
    local diameter = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.2
    local circle = table.remove(ripplePool)
    if not circle then
        circle = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
        })
        corner(circle, UDim.new(1, 0))
    end
    circle.Position = UDim2.fromOffset(mouse.X - button.AbsolutePosition.X, mouse.Y - button.AbsolutePosition.Y)
    circle.Size = UDim2.fromOffset(0, 0)
    circle.BackgroundTransparency = 0.82
    circle.ZIndex = button.ZIndex + 1
    circle.Parent = button
    tween(circle, { Size = UDim2.fromOffset(diameter, diameter), BackgroundTransparency = 1 }, 0.55)
    task.delay(0.55, function()
        circle.Parent = nil
        if #ripplePool < 4 then
            table.insert(ripplePool, circle)
        else
            circle:Destroy()
        end
    end)
end

local function flashStroke(strokeObject)
    if not strokeObject then
        return
    end
    tween(strokeObject, { Color = Theme.Accent, Transparency = 0.2 }, 0.08)
    task.delay(0.12, function()
        tween(strokeObject, { Color = Theme.Stroke, Transparency = 0 }, 0.35)
    end)
end

local function hoverStroke(target, strokeObject)
    target.MouseEnter:Connect(function()
        tween(strokeObject, { Color = Theme.StrokeHover }, 0.12)
    end)
    target.MouseLeave:Connect(function()
        tween(strokeObject, { Color = Theme.Stroke }, 0.25)
    end)
end

local KEY_NAMES = {
    [Enum.KeyCode.LeftControl] = "LCtrl",
    [Enum.KeyCode.RightControl] = "RCtrl",
    [Enum.KeyCode.LeftShift] = "LShift",
    [Enum.KeyCode.RightShift] = "RShift",
    [Enum.KeyCode.LeftAlt] = "LAlt",
    [Enum.KeyCode.RightAlt] = "RAlt",
    [Enum.KeyCode.Return] = "Enter",
    [Enum.KeyCode.Escape] = "Esc",
    [Enum.KeyCode.Backspace] = "Backspace",
}

local function keyName(keyCode)
    if keyCode == nil then
        return "None"
    end
    return KEY_NAMES[keyCode] or keyCode.Name
end

local function safeCall(callback, ...)
    if type(callback) ~= "function" then
        return
    end
    local ok, err = pcall(callback, ...)
    if not ok then
        warn("[AirFlow] callback error: " .. tostring(err))
    end
end

local function numberFormat(min, max, step)
    local decimals = 0
    local text = tostring(step)
    local dot = text:find("%.")
    if dot then
        decimals = #text - dot
    end
    local pattern = "%." .. decimals .. "f"
    return {
        snap = function(value)
            value = math.floor(value / step + 0.5) * step
            return math.clamp(value, min, max)
        end,
        format = function(value)
            return string.format(pattern, value)
        end,
    }
end

local function card(tab, className, height, opts)
    local props = {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        LayoutOrder = tab:_nextOrder(),
        Parent = tab.List,
    }
    if className == "TextButton" then
        props.AutoButtonColor = false
        props.Text = ""
    end
    local frame = create(className, props)
    frame:SetAttribute("NoDrag", true)
    corner(frame)
    local frameStroke = stroke(frame, Theme.Stroke)
    return frame, frameStroke
end

local function titleDesc(parent, name, desc, rightReserve)
    local title, descLabel
    if desc then
        local top = (CARD_HEIGHT_DESC - 38) / 2
        title = label({
            Position = UDim2.fromOffset(14, top),
            Size = UDim2.new(1, -(14 + rightReserve), 0, 18),
            Text = name,
            Parent = parent,
        })
        descLabel = label({
            Position = UDim2.fromOffset(14, top + 20),
            Size = UDim2.new(1, -(14 + rightReserve), 0, 17),
            Text = desc,
            TextSize = 13,
            FontFace = Fonts.Regular,
            TextColor3 = Theme.Muted,
            Parent = parent,
        })
    else
        title = label({
            Position = UDim2.fromOffset(14, 0),
            Size = UDim2.new(1, -(14 + rightReserve), 1, 0),
            Text = name,
            Parent = parent,
        })
    end
    return title, descLabel
end

local function beginElement(tab, opts, map, className, rightReserve, fallbackName)
    opts = normalize(opts, map)
    local height = opts.Desc and CARD_HEIGHT_DESC or CARD_HEIGHT
    local frame, frameStroke = card(tab, className or "Frame", height, opts)
    hoverStroke(frame, frameStroke)
    local title, descLabel
    if rightReserve then
        title, descLabel = titleDesc(frame, opts.Name or fallbackName, opts.Desc, rightReserve)
    end
    return opts, frame, frameStroke, height, title, descLabel
end

local function reserveRight(title, descLabel, width)
    if title then
        title.Size = UDim2.new(1, -(14 + width), title.Size.Y.Scale, title.Size.Y.Offset)
    end
    if descLabel then
        descLabel.Size = UDim2.new(1, -(14 + width), 0, descLabel.Size.Y.Offset)
    end
end

local Tab = {}
Tab.__index = Tab

function Tab:_nextOrder()
    self._order = self._order + 1
    return self._order
end

function Tab:Section(text)
    if type(text) == "table" then
        text = text.Name or text.Title or ""
    end
    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        LayoutOrder = self:_nextOrder(),
        Parent = self.List,
    })
    local text_ = label({
        Position = UDim2.fromOffset(2, 8),
        Size = UDim2.new(0, 0, 0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = string.upper(text),
        TextSize = 12,
        TextColor3 = Theme.Muted,
        TextTruncate = Enum.TextTruncate.None,
        Parent = holder,
    })
    local rule = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0, 16),
        Size = UDim2.new(1, -12, 0, 1),
        BackgroundColor3 = Theme.Stroke,
        BorderSizePixel = 0,
        Parent = holder,
    })
    text_:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        rule.Size = UDim2.new(1, -(text_.AbsoluteSize.X + 14), 0, 1)
    end)
    task.defer(function()
        rule.Size = UDim2.new(1, -(text_.AbsoluteSize.X + 14), 0, 1)
    end)
    return finishElement(self, {}, {
        Set = function(_, value)
            text_.Text = string.upper(value)
        end,
    }, holder, "Section")
end

function Tab:Divider()
    local line = create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Theme.Stroke,
        BorderSizePixel = 0,
        LayoutOrder = self:_nextOrder(),
        Parent = self.List,
    })
    return finishElement(self, {}, {}, line, "Divider")
end

function Tab:Label(opts)
    opts = normalize(opts, { Name = "Text", Title = "Text" })
    local text_ = label({
        Size = UDim2.new(1, 0, 0, 18),
        Text = opts.Text or "",
        TextSize = 13,
        FontFace = Fonts.Regular,
        TextColor3 = opts.Color or Theme.Muted,
        LayoutOrder = self:_nextOrder(),
        Parent = self.List,
    })
    padding(text_, 2)
    local handle = {
        Set = function(_, value)
            text_.Text = tostring(value)
        end,
        Get = function()
            return text_.Text
        end,
    }
    if type(opts.Update) == "function" then
        local rate = math.max(tonumber(opts.UpdateRate) or 1, 0.05)
        local running = true
        handle._listeners = handle._listeners or {}
        table.insert(handle._listeners, function()
            running = false
        end)
        task.spawn(function()
            while running and text_.Parent do
                local ok, value = pcall(opts.Update)
                if ok and value ~= nil then
                    text_.Text = tostring(value)
                elseif not ok then
                    warn("[AirFlow] label update error: " .. tostring(value))
                end
                task.wait(rate)
            end
        end)
        function handle:SetUpdateRate(seconds)
            rate = math.max(tonumber(seconds) or rate, 0.05)
        end
    end
    return finishElement(self, opts, handle, text_, "Label")
end

function Tab:Paragraph(opts)
    opts = normalize(opts, { Title = "Name" })
    local frame = card(self, "Frame", 0, opts)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    padding(frame, 14, 14, 11, 12)
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = frame,
    })
    label({
        Size = UDim2.new(1, 0, 0, 14),
        Text = opts.Name or "",
        LayoutOrder = 1,
        Parent = frame,
    })
    local content = label({
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Text = opts.Content or "",
        TextSize = 13,
        FontFace = Fonts.Regular,
        TextColor3 = Theme.Muted,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.None,
        TextYAlignment = Enum.TextYAlignment.Top,
        LayoutOrder = 2,
        Parent = frame,
    })
    return finishElement(self, opts, {
        Set = function(_, value)
            content.Text = value
        end,
    }, frame, "Paragraph")
end

function Tab:Button(opts)
    opts = normalize(opts, { Title = "Name", Description = "Desc" })
    local primary = opts.Style == "Primary"
    local height = opts.Desc and CARD_HEIGHT_DESC or CARD_HEIGHT
    local button, buttonStroke = card(self, "TextButton", height, opts)
    button.ClipsDescendants = true

    if primary then
        button.BackgroundColor3 = Theme.Accent
        button.BackgroundTransparency = 0.12
        buttonStroke.Color = Theme.Accent
        buttonStroke.Transparency = 0.4
        button.MouseEnter:Connect(function()
            tween(button, { BackgroundTransparency = 0 }, 0.12)
            tween(buttonStroke, { Transparency = 0 }, 0.12)
        end)
        button.MouseLeave:Connect(function()
            tween(button, { BackgroundTransparency = 0.12 }, 0.25)
            tween(buttonStroke, { Transparency = 0.4 }, 0.25)
        end)
    else
        hoverStroke(button, buttonStroke)
    end

    local textColor = primary and Theme.AccentDark or Theme.Text
    local iconOffset = 0
    if opts.Icon then
        glowIcon(button, opts.Icon, primary and Theme.AccentDark or Theme.Accent, UDim2.new(0, 14, 0.5, 0))
        iconOffset = 26
    end
    local title = titleDesc(button, opts.Name or "Button", opts.Desc, 30)
    if iconOffset > 0 then
        for _, child in ipairs(button:GetChildren()) do
            if child:IsA("TextLabel") then
                child.Position = child.Position + UDim2.fromOffset(iconOffset, 0)
                child.Size = child.Size - UDim2.fromOffset(iconOffset, 0)
            end
        end
    end
    if primary then
        for _, child in ipairs(button:GetChildren()) do
            if child:IsA("TextLabel") then
                child.TextColor3 = textColor
            end
        end
    end

    glowIcon(button, BUTTON_HINT_ICON, primary and Theme.AccentDark or Theme.Muted, UDim2.new(1, -30, 0.5, 0))

    button.MouseButton1Click:Connect(function()
        ripple(button)
        safeCall(opts.Callback)
    end)

    return finishElement(self, opts, {
        SetText = function(_, value)
            title.Text = value
        end,
    }, button, "Button")
end

function Tab:Toggle(opts)
    local button, buttonStroke
    opts, button, buttonStroke = beginElement(self, opts, { Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default" }, "TextButton", 56, "Toggle")

    local pill = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = TOUCH and UDim2.fromOffset(44, 24) or UDim2.fromOffset(36, 20),
        BackgroundColor3 = Theme.Surface3,
        BorderSizePixel = 0,
        Parent = button,
    })
    corner(pill, UDim.new(1, 0))
    stroke(pill, Theme.Stroke)

    local knob = create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 3, 0.5, 0),
        Size = TOUCH and UDim2.fromOffset(18, 18) or UDim2.fromOffset(14, 14),
        BackgroundColor3 = Theme.Muted,
        BorderSizePixel = 0,
        Parent = pill,
    })
    corner(knob, UDim.new(1, 0))
    local pillGlow = create("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 24, 1, 24),
        BackgroundTransparency = 1,
        Image = Assets.Glow,
        ImageColor3 = Theme.Accent,
        ImageTransparency = 1,
        ZIndex = 0,
        Parent = pill,
    })

    local self_ = { Value = opts.Default == true }

    local function render(animate)
        local on = self_.Value
        local duration = animate and 0.25 or 0
        tween(pill, { BackgroundColor3 = on and Theme.Accent or Theme.Surface3 }, duration)
        tween(pillGlow, { ImageTransparency = on and 0.75 or 1 }, duration)
        local knobSize = TOUCH and 18 or 14
        tween(knob, {
            Position = on and UDim2.new(0, (TOUCH and 44 or 36) - 3 - knobSize, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
            BackgroundColor3 = on and Theme.AccentDark or Theme.Muted,
        }, duration, Enum.EasingStyle.Back)
        if animate then
            tween(knob, { Size = UDim2.fromOffset(knobSize + 4, knobSize - 2) }, 0.08)
            task.delay(0.08, function()
                tween(knob, { Size = UDim2.fromOffset(knobSize, knobSize) }, 0.2, Enum.EasingStyle.Back)
            end)
        end
    end

    local fromClick = false
    function self_:Set(value, silent)
        value = value == true
        if value == self_.Value then
            return
        end
        self_.Value = value
        render(true)
        if not fromClick then
            flashStroke(buttonStroke)
        end
        if not silent then
            safeCall(opts.Callback, value)
        end
    end

    function self_:Get()
        return self_.Value
    end

    render(false)
    button.MouseButton1Click:Connect(function()
        fromClick = true
        self_:Set(not self_.Value)
        fromClick = false
    end)

    local handle = finishElement(self, opts, self_, button, "Toggle")
    if self_.Value then
        safeCall(opts.Callback, true)
    end
    return handle
end

function Tab:Slider(opts)
    opts = normalize(opts, { Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default", Increment = "Step" })
    local min = opts.Min or 0
    local max = opts.Max or 100
    local step = opts.Step or 1
    local suffix = opts.Suffix or ""
    local numbers = numberFormat(min, max, step)

    local frame, frameStroke = card(self, "Frame", CARD_HEIGHT_DESC, opts)
    hoverStroke(frame, frameStroke)

    label({
        Position = UDim2.fromOffset(14, 12),
        Size = UDim2.new(1, -120, 0, 18),
        Text = opts.Name or "Slider",
        Parent = frame,
    })

    local valueChip = create("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -10, 0, 9),
        Size = UDim2.fromOffset(40, 24),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = frame,
    })
    corner(valueChip, UDim.new(0, 6))
    local chipStroke = stroke(valueChip)
    local valueLabel = label({
        Size = UDim2.new(1, 0, 1, 0),
        TextSize = 13,
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTruncate = Enum.TextTruncate.None,
        Parent = valueChip,
    })
    local valueBox = create("TextBox", {
        Position = UDim2.fromOffset(9, 0),
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Theme.Text,
        TextSize = 13,
        FontFace = Fonts.Medium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Visible = false,
        Parent = valueChip,
    })
    create("UISizeConstraint", { MinSize = Vector2.new(14, 0), Parent = valueBox })
    local suffixLabel = label({
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = suffix,
        TextSize = 13,
        TextColor3 = Theme.Accent,
        TextTruncate = Enum.TextTruncate.None,
        Visible = false,
        Parent = valueChip,
    })
    local chipButton = create("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 2,
        Parent = valueChip,
    })
    local editing = false
    local function fitChip(instant)
        local width
        if editing then
            width = 9 + valueBox.AbsoluteSize.X / (self.Window.Scale.Scale) + suffixLabel.TextBounds.X + 9
            suffixLabel.Position = UDim2.fromOffset(9 + valueBox.AbsoluteSize.X / (self.Window.Scale.Scale), 0)
        else
            width = valueLabel.TextBounds.X + 18
        end
        width = math.max(width, 36)
        if instant then
            valueChip.Size = UDim2.fromOffset(width, 24)
        else
            tween(valueChip, { Size = UDim2.fromOffset(width, 24) }, 0.2)
        end
    end
    valueLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
        if not editing then
            fitChip(false)
        end
    end)
    valueBox:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if editing then
            fitChip(false)
        end
    end)

    local track = create("Frame", {
        Position = UDim2.new(0, 14, 0, CARD_HEIGHT_DESC - 18),
        Size = UDim2.new(1, -28, 0, 5),
        BackgroundColor3 = Theme.Surface3,
        BorderSizePixel = 0,
        Parent = frame,
    })
    corner(track, UDim.new(1, 0))
    local fill = create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = track,
    })
    corner(fill, UDim.new(1, 0))

    local knobGlow = create("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(28, 28),
        BackgroundTransparency = 1,
        Image = Assets.Glow,
        ImageColor3 = Theme.Accent,
        ImageTransparency = 0.85,
        ZIndex = 2,
        Parent = track,
    })
    local knob = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = track,
    })
    corner(knob, UDim.new(1, 0))

    local hit = create("TextButton", {
        Position = UDim2.new(0, 8, 0, CARD_HEIGHT_DESC - (TOUCH and 37 or 31)),
        Size = UDim2.new(1, -16, 0, TOUCH and 40 or 28),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 4,
        Parent = frame,
    })

    local self_ = { Value = math.clamp(opts.Default or min, min, max) }
    local dragging = false
    chipButton.MouseEnter:Connect(function()
        tween(chipStroke, { Color = Theme.StrokeHover }, 0.12)
    end)
    chipButton.MouseLeave:Connect(function()
        if not valueBox:IsFocused() then
            tween(chipStroke, { Color = Theme.Stroke }, 0.2)
        end
    end)
    chipButton.MouseButton1Click:Connect(function()
        editing = true
        valueBox.Text = numbers.format(self_.Value)
        valueLabel.Visible = false
        valueBox.Visible = true
        suffixLabel.Visible = suffix ~= ""
        chipButton.Visible = false
        tween(chipStroke, { Color = Theme.StrokeHover }, 0.12)
        valueBox:CaptureFocus()
        task.defer(fitChip, false)
    end)
    valueBox.FocusLost:Connect(function()
        local typed = tonumber(valueBox.Text)
        editing = false
        valueBox.Visible = false
        suffixLabel.Visible = false
        valueLabel.Visible = true
        chipButton.Visible = true
        tween(chipStroke, { Color = Theme.Stroke }, 0.2)
        if typed then
            self_:Set(typed)
        end
        fitChip(false)
    end)
    hit.MouseEnter:Connect(function()
        if not dragging then
            tween(knobGlow, { ImageTransparency = 0.78, Size = UDim2.fromOffset(34, 34) }, 0.15)
        end
    end)
    hit.MouseLeave:Connect(function()
        if not dragging then
            tween(knobGlow, { ImageTransparency = 0.85, Size = UDim2.fromOffset(28, 28) }, 0.2)
        end
    end)

    local snap = numbers.snap

    local function fraction()
        return (max - min) == 0 and 0 or (self_.Value - min) / (max - min)
    end

    local function moveTo(frac, duration, style)
        style = style or Enum.EasingStyle.Linear
        tween(fill, { Size = UDim2.new(frac, 0, 1, 0) }, duration, style)
        tween(knob, { Position = UDim2.new(frac, 0, 0.5, 0) }, duration, style)
        tween(knobGlow, { Position = UDim2.new(frac, 0, 0.5, 0) }, duration, style)
    end

    local function render(duration, style)
        moveTo(fraction(), duration, style)
        valueLabel.Text = numbers.format(self_.Value) .. suffix
    end

    local function settleTo(previousFrac)
        local target = fraction()
        local width = math.max(track.AbsoluteSize.X, 1)
        local overshoot = (target >= previousFrac and 1 or -1) * (5 / width)
        moveTo(math.clamp(target + overshoot, 0, 1), 0.22, Enum.EasingStyle.Quint)
        task.delay(0.22, function()
            if not dragging then
                moveTo(fraction(), 0.18, Enum.EasingStyle.Quint)
            end
        end)
        valueLabel.Text = numbers.format(self_.Value) .. suffix
    end

    local function bounceKnob()
        tween(knob, { Size = UDim2.fromOffset(14, 12) }, 0.08)
        tween(knobGlow, { Size = UDim2.fromOffset(32, 32), ImageTransparency = 0.78 }, 0.12)
        task.delay(0.1, function()
            tween(knob, { Size = UDim2.fromOffset(12, 12) }, 0.25, Enum.EasingStyle.Quint)
            tween(knobGlow, { Size = UDim2.fromOffset(28, 28), ImageTransparency = 0.85 }, 0.25)
        end)
    end

    function self_:Set(value, silent)
        value = snap(tonumber(value) or min)
        if value == self_.Value then
            return
        end
        local previousFrac = fraction()
        self_.Value = value
        if dragging then
            render(0.05)
        else
            settleTo(previousFrac)
            bounceKnob()
            flashStroke(frameStroke)
        end
        if not silent then
            safeCall(opts.Callback, value)
        end
    end

    function self_:Get()
        return self_.Value
    end

    local function updateFromX(x)
        local frac = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        self_:Set(min + (max - min) * frac)
    end

    hit.InputBegan:Connect(function(input)
        if isPress(input) then
            dragging = true
            tween(knob, { Size = UDim2.fromOffset(16, 16) }, 0.15, Enum.EasingStyle.Back)
            tween(knobGlow, { Size = UDim2.fromOffset(44, 44), ImageTransparency = 0.7 }, 0.15)
            updateFromX(pointerPosition().X)
        end
    end)

    self.Window:_listen("Changed", function(input)
        if dragging and isMove(input) then
            updateFromX(pointerPosition().X)
        end
    end, self_)

    self.Window:_listen("Ended", function(input)
        if dragging and isPress(input) then
            dragging = false
            tween(knob, { Size = UDim2.fromOffset(12, 12) }, 0.2)
            tween(knobGlow, { Size = UDim2.fromOffset(28, 28), ImageTransparency = 0.85 }, 0.2)
        end
    end, self_)

    self_.Value = snap(self_.Value)
    render(0)
    task.defer(fitChip, true)
    return finishElement(self, opts, self_, frame, "Slider")
end

function Tab:Dropdown(opts)
    opts = normalize(opts, { Title = "Name", Description = "Desc", CurrentOption = "Default", Value = "Default", MultipleOptions = "Multi", Values = "Options" })
    if opts.Multi and type(opts.Default) ~= "table" and opts.Default ~= nil then
        opts.Default = { opts.Default }
    elseif not opts.Multi and type(opts.Default) == "table" then
        opts.Default = opts.Default[1]
    end
    local multi = opts.Multi == true
    local options = opts.Options or {}
    local frame, frameStroke, height
    opts, frame, frameStroke, height = beginElement(self, opts, {}, "Frame")
    frame.ClipsDescendants = true

    local header = create("TextButton", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = frame,
    })
    local titleLabel, descLabel = titleDesc(header, opts.Name or "Dropdown", opts.Desc, 180)

    local chip = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(60, CHIP_HEIGHT),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = header,
    })
    corner(chip, UDim.new(0, 6))
    local chipStroke = stroke(chip)
    local valueLabel = label({
        Position = UDim2.fromOffset(10, 0),
        Size = UDim2.new(1, -34, 1, 0),
        TextColor3 = Theme.Muted,
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.None,
        ClipsDescendants = true,
        Parent = chip,
    })
    local arrow = arrowIndicator(chip, 1, -6)
    local measure = label({
        Size = UDim2.fromOffset(0, CHIP_HEIGHT),
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 13,
        Visible = false,
        Parent = chip,
    })
    local fullText = ""
    local function trimmed()
        local maxText = 190 - 10 - 34
        measure.Text = fullText
        if measure.TextBounds.X <= maxText then
            return fullText
        end
        local text = fullText
        while #text > 1 do
            text = text:sub(1, -2)
            measure.Text = text .. ".."
            if measure.TextBounds.X <= maxText then
                return text .. ".."
            end
        end
        return ".."
    end
    local function fitChip(instant)
        local width = math.clamp(valueLabel.TextBounds.X + 10 + 34, 60, 190)
        reserveRight(titleLabel, descLabel, width + 20)
        if instant then
            chip.Size = UDim2.fromOffset(width, CHIP_HEIGHT)
        else
            tween(chip, { Size = UDim2.fromOffset(width, CHIP_HEIGHT) }, 0.2)
        end
    end
    valueLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
        fitChip(false)
    end)

    local listHolder = create("Frame", {
        Position = UDim2.new(0, 10, 0, height),
        Size = UDim2.new(1, -20, 0, 0),
        BackgroundTransparency = 1,
        Parent = frame,
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = listHolder,
    })

    local self_ = { Open = false }
    local selected = {}
    local optionButtons = {}
    local filter = ""
    local SEARCH_THRESHOLD = opts.SearchAfter or 6

    local searchHolder = create("Frame", {
        Size = UDim2.new(1, 0, 0, DROPDOWN_OPTION_HEIGHT),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 0,
        Visible = false,
        Parent = listHolder,
    })
    corner(searchHolder, UDim.new(0, 6))
    local searchStroke = stroke(searchHolder, Theme.Stroke, 1)
    local searchBox = create("TextBox", {
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Search",
        PlaceholderColor3 = Theme.Muted,
        TextColor3 = Theme.Text,
        TextSize = 13,
        FontFace = Fonts.Regular,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        TextTransparency = 1,
        Parent = searchHolder,
    })

    local function matches(option)
        return filter == "" or string.find(string.lower(tostring(option)), filter, 1, true) ~= nil
    end

    if multi then
        for _, value in ipairs(opts.Default or {}) do
            selected[value] = true
        end
    elseif opts.Default ~= nil then
        selected[opts.Default] = true
    end

    local function currentValue()
        if multi then
            local list = {}
            for _, option in ipairs(options) do
                if selected[option] then
                    table.insert(list, option)
                end
            end
            return list
        end
        for _, option in ipairs(options) do
            if selected[option] then
                return option
            end
        end
        return nil
    end

    local function renderValueLabel()
        local value = currentValue()
        if multi then
            fullText = #value > 0 and table.concat(value, ", ") or "None"
        else
            fullText = value ~= nil and tostring(value) or "None"
        end
        valueLabel.Text = trimmed()
        for option, button in pairs(optionButtons) do
            local on = selected[option] == true
            if button.On ~= on then
                button.On = on
                tween(button.Label, { TextColor3 = on and Theme.Text or Theme.Muted }, 0.15)
                if self_.Open then
                    tween(button.Check, { ImageTransparency = on and 0 or 1 }, 0.15)
                    tween(button.CheckScale, { Scale = on and 1 or 0.6 }, on and 0.3 or 0.15, on and Enum.EasingStyle.Back or Enum.EasingStyle.Quint)
                end
            end
        end
    end

    local function visibleCount()
        local count = 0
        for _, option in ipairs(options) do
            if matches(option) then
                count = count + 1
            end
        end
        return count
    end

    local function applyFilter()
        for option, button in pairs(optionButtons) do
            button.Frame.Visible = matches(option)
        end
    end

    local function expandedHeight()
        local rows = visibleCount() + (searchHolder.Visible and 1 or 0)
        return height + rows * (DROPDOWN_OPTION_HEIGHT + 4) + 8
    end

    local function setOpen(open)
        self_.Open = open
        searchHolder.Visible = #options > SEARCH_THRESHOLD
        if not open then
            filter = ""
            searchBox.Text = ""
            applyFilter()
        end
        tween(frame, { Size = UDim2.new(1, 0, 0, open and expandedHeight() or height) }, 0.3, Enum.EasingStyle.Quint)
        tween(searchHolder, { BackgroundTransparency = open and 0 or 1 }, 0.2)
        tween(searchStroke, { Transparency = open and 0 or 1 }, 0.2)
        tween(searchBox, { TextTransparency = open and 0 or 1 }, 0.2)
        arrow:Set(open)
        tween(chipStroke, { Color = open and Theme.StrokeHover or Theme.Stroke }, 0.2)
        local function show(button)
            if not button.Stroke then
                button.Stroke = stroke(button.Frame, Theme.Stroke, 1)
            end
            local on = open and button.On
            tween(button.Check, { ImageTransparency = on and 0 or 1 }, 0.18)
            button.CheckScale.Scale = on and 1 or 0.6
            tween(button.Label, { TextTransparency = open and 0 or 1 }, 0.18)
            tween(button.Stroke, { Transparency = open and 0 or 1 }, 0.18)
            tween(button.Frame, { BackgroundTransparency = open and 0 or 1 }, 0.18)
        end
        if open then
            local generation = (self_._openGeneration or 0) + 1
            self_._openGeneration = generation
            task.spawn(function()
                local first = true
                for _, option in ipairs(options) do
                    local button = optionButtons[option]
                    if button and button.Frame.Visible then
                        if not first then
                            task.wait(0.025)
                            if self_._openGeneration ~= generation or not self_.Open then
                                return
                            end
                        end
                        first = false
                        show(button)
                    end
                end
            end)
        else
            local generation = (self_._openGeneration or 0) + 1
            self_._openGeneration = generation
            local visible = {}
            for _, option in ipairs(options) do
                local button = optionButtons[option]
                if button and button.Frame.Visible then
                    table.insert(visible, button)
                end
            end
            task.spawn(function()
                for index = #visible, 1, -1 do
                    show(visible[index])
                    if index > 1 then
                        task.wait(0.015)
                        if self_._openGeneration ~= generation or self_.Open then
                            return
                        end
                    end
                end
            end)
        end
    end

    local function buildOptions()
        local keep = {}
        for index, option in ipairs(options) do
            keep[option] = index
        end
        for option, button in pairs(optionButtons) do
            if not keep[option] then
                button.Frame:Destroy()
                optionButtons[option] = nil
            end
        end
        for index, option in ipairs(options) do
            local existing = optionButtons[option]
            if existing then
                existing.Frame.LayoutOrder = index
                continue
            end
            local button = create("TextButton", {
                Size = UDim2.new(1, 0, 0, DROPDOWN_OPTION_HEIGHT),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                LayoutOrder = index,
                Parent = listHolder,
            })
            corner(button, UDim.new(0, 6))
            local check = create("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(14, 14),
                BackgroundTransparency = 1,
                ImageColor3 = Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Fit,
                Parent = button,
            })
            applyIcon(check, "check")
            local checkScale = create("UIScale", { Scale = 0.6, Parent = check })
            local text_ = label({
                Position = UDim2.fromOffset(12, -1),
                Size = UDim2.new(1, -36, 1, 0),
                Text = tostring(option),
                TextSize = 13,
                TextColor3 = Theme.Muted,
                TextTransparency = 1,
                Parent = button,
            })
            button.MouseEnter:Connect(function()
                tween(text_, { TextColor3 = Theme.Text }, 0.15)
                local entry = optionButtons[option]
                if entry and entry.Stroke then
                    tween(entry.Stroke, { Color = Theme.StrokeHover }, 0.12)
                end
            end)
            button.MouseLeave:Connect(function()
                tween(text_, { TextColor3 = selected[option] and Theme.Text or Theme.Muted }, 0.2)
                local entry = optionButtons[option]
                if entry and entry.Stroke then
                    tween(entry.Stroke, { Color = Theme.Stroke }, 0.2)
                end
            end)
            button.MouseButton1Click:Connect(function()
                if selected[option] then
                    selected[option] = nil
                else
                    if not multi then
                        selected = {}
                    end
                    selected[option] = true
                end
                renderValueLabel()
                safeCall(opts.Callback, currentValue())
                if not multi and selected[option] then
                    setOpen(false)
                end
            end)
            optionButtons[option] = { Frame = button, Label = text_, Check = check, CheckScale = checkScale, Stroke = nil, On = nil }
        end
        applyFilter()
        if self_.Open then
            frame.Size = UDim2.new(1, 0, 0, expandedHeight())
        end
    end

    function self_:Set(value, silent)
        selected = {}
        if multi then
            for _, item in ipairs(type(value) == "table" and value or { value }) do
                selected[item] = true
            end
        elseif value ~= nil then
            selected[value] = true
        end
        renderValueLabel()
        flashStroke(frameStroke)
        if not silent then
            safeCall(opts.Callback, currentValue())
        end
    end

    function self_:Get()
        return currentValue()
    end

    function self_:Refresh(newOptions, keepSelection)
        options = newOptions or {}
        if not keepSelection then
            selected = {}
        end
        buildOptions()
        renderValueLabel()
        if self_.Open then
            setOpen(true)
        end
    end

    function self_:SetOpen(open)
        setOpen(open == true)
    end

    header.MouseButton1Click:Connect(function()
        setOpen(not self_.Open)
    end)
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        filter = string.lower(searchBox.Text)
        applyFilter()
        if self_.Open then
            tween(frame, { Size = UDim2.new(1, 0, 0, expandedHeight()) }, 0.2, Enum.EasingStyle.Quint)
        end
    end)
    buildOptions()
    renderValueLabel()
    task.defer(fitChip, true)
    return finishElement(self, opts, self_, frame, "Dropdown")
end

function Tab:Input(opts)
    local frame, frameStroke, _, titleLabel, descLabel
    opts, frame, frameStroke, _, titleLabel, descLabel = beginElement(self, opts, { Title = "Name", Description = "Desc", PlaceholderText = "Placeholder", CurrentValue = "Default", Value = "Default" }, "Frame", 160, "Input")

    local boxHolder = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(170, 30),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = frame,
    })
    corner(boxHolder, UDim.new(0, 6))
    local boxStroke = stroke(boxHolder)

    local boxIcon = opts.Icon
    if boxIcon then
        glowIcon(boxHolder, boxIcon, Theme.Muted, UDim2.new(0, 8, 0.5, 0))
    end
    local box = create("TextBox", {
        Position = UDim2.fromOffset(boxIcon and 30 or 8, 0),
        Size = UDim2.new(1, boxIcon and -38 or -16, 1, 0),
        BackgroundTransparency = 1,
        Text = opts.Default or "",
        PlaceholderText = opts.Placeholder or "",
        PlaceholderColor3 = Theme.Muted,
        TextColor3 = Theme.Text,
        TextSize = 14,
        FontFace = Fonts.Regular,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        TextTruncate = Enum.TextTruncate.None,
        ClipsDescendants = true,
        Parent = boxHolder,
    })
    boxHolder.ClipsDescendants = true

    local focused = false
    local textInset = (boxIcon and 30 or 8) + 8
    local function fitBox(instant)
        local cardWidth = frame.AbsoluteSize.X / self.Window.Scale.Scale
        local maxWidth = math.clamp(cardWidth - 14 - 110 - 20, 100, 200)
        local content = box.Text
        local measured = box.TextBounds.X
        if #content == 0 then
            measured = math.min(box.TextBounds.X, 90)
        end
        local width = math.clamp(measured + textInset + 12, 90, maxWidth) + (focused and 8 or 0)
        width = math.min(width, maxWidth + 8)
        reserveRight(titleLabel, descLabel, width + 20)
        if instant then
            boxHolder.Size = UDim2.fromOffset(width, 30)
        else
            tween(boxHolder, { Size = UDim2.fromOffset(width, 30) }, 0.18)
        end
    end
    frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        fitBox(true)
    end)
    box:GetPropertyChangedSignal("Text"):Connect(function()
        fitBox(false)
    end)
    box:GetPropertyChangedSignal("TextBounds"):Connect(function()
        fitBox(false)
    end)
    task.defer(fitBox, true)

    box.Focused:Connect(function()
        focused = true
        tween(boxStroke, { Color = Theme.StrokeHover }, 0.15)
        fitBox(false)
    end)
    box.FocusLost:Connect(function(enterPressed)
        focused = false
        tween(boxStroke, { Color = Theme.Stroke }, 0.15)
        fitBox(false)
        if opts.Numeric then
            local number = tonumber(box.Text)
            if not number then
                box.Text = ""
                return
            end
        end
        safeCall(opts.Callback, box.Text, enterPressed)
    end)

    return finishElement(self, opts, {
        Set = function(_, value)
            box.Text = tostring(value)
            flashStroke(frameStroke)
        end,
        Get = function()
            return box.Text
        end,
    }, frame, "Input")
end

function Tab:Keybind(opts)
    local frame, frameStroke, _, titleLabel, descLabel
    opts, frame, frameStroke, _, titleLabel, descLabel = beginElement(self, opts, { Title = "Name", Description = "Desc", CurrentKeybind = "Default", Value = "Default" }, "Frame", 110, "Keybind")
    if type(opts.Default) == "string" then
        opts.Default = Enum.KeyCode[opts.Default]
    end

    local chip = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(44, CHIP_HEIGHT),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ClipsDescendants = true,
        Parent = frame,
    })
    corner(chip, UDim.new(0, 6))
    local chipStroke = stroke(chip)
    local chipLabel = label({
        Size = UDim2.new(1, 0, 1, 0),
        TextSize = 13,
        TextColor3 = Theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTruncate = Enum.TextTruncate.None,
        Parent = chip,
    })

    local self_ = { Value = opts.Default, Listening = false }

    local function fitChip(instant)
        local width = math.max(chipLabel.TextBounds.X + 20, TOUCH and 44 or 36)
        reserveRight(titleLabel, descLabel, width + 20)
        if instant then
            chip.Size = UDim2.fromOffset(width, CHIP_HEIGHT)
        else
            tween(chip, { Size = UDim2.fromOffset(width, CHIP_HEIGHT) }, 0.2)
        end
    end
    chipLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
        fitChip(false)
    end)

    local function render()
        chipLabel.Text = self_.Listening and "..." or keyName(self_.Value)
        tween(chipStroke, { Color = self_.Listening and Theme.StrokeHover or Theme.Stroke }, 0.15)
        tween(chipLabel, { TextColor3 = self_.Listening and Theme.Accent or Theme.Muted }, 0.15)
    end

    function self_:Set(keyCode, silent)
        local wasListening = self_.Listening
        self_.Value = keyCode
        self_.Listening = false
        render()
        if not wasListening then
            flashStroke(frameStroke)
        end
        if not silent then
            safeCall(opts.OnChanged, keyCode)
        end
    end

    chip.MouseButton1Click:Connect(function()
        self_.Listening = not self_.Listening
        render()
    end)

    self.Window:_listen("Began", function(input, gameProcessed)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end
        if self_.Listening then
            self.Window._consumedKey = input.KeyCode
            self.Window._consumedAt = os.clock()
            if input.KeyCode == Enum.KeyCode.Escape then
                self_.Listening = false
                render()
            else
                self_:Set(input.KeyCode)
            end
            return
        end
        if not gameProcessed and self_.Value ~= nil and input.KeyCode == self_.Value then
            safeCall(opts.Callback, input.KeyCode)
        end
    end, self_)

    render()
    task.defer(fitChip, true)
    function self_:Get()
        return self_.Value
    end
    return finishElement(self, opts, self_, frame, "Keybind")
end

function Tab:ColorPicker(opts)
    local PANEL_HEIGHT = 168
    local frame, frameStroke, height
    opts, frame, frameStroke, height = beginElement(self, opts, { Title = "Name", Description = "Desc", Color = "Default", CurrentValue = "Default", Value = "Default" }, "Frame")
    frame.ClipsDescendants = true

    local header = create("TextButton", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = frame,
    })
    titleDesc(header, opts.Name or "Color", opts.Desc, 90)

    local swatch = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -34, 0.5, 0),
        Size = UDim2.fromOffset(36, 20),
        BorderSizePixel = 0,
        Parent = header,
    })
    corner(swatch, UDim.new(0, 6))
    stroke(swatch, Theme.Stroke)
    local arrow = arrowIndicator(header, 1, -12)

    local panel = create("Frame", {
        Position = UDim2.fromOffset(14, height + 2),
        Size = UDim2.new(1, -28, 0, PANEL_HEIGHT - 12),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = frame,
    })

    local svBox = create("TextButton", {
        Size = UDim2.new(1, -30, 0, 110),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ClipsDescendants = true,
        Parent = panel,
    })
    corner(svBox, UDim.new(0, 6))
    local svHueGradient = create("UIGradient", {
        Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 0, 0)),
        Parent = svBox,
    })
    local svDark = create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Parent = svBox,
    })
    create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Rotation = 90,
        Parent = svDark,
    })
    local svCursor = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(10, 10),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = svBox,
    })
    corner(svCursor, UDim.new(1, 0))
    stroke(svCursor, Color3.new(1, 1, 1), 0, 2)

    local hueBar = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(14, 110),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = panel,
    })
    corner(hueBar, UDim.new(0, 6))
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
        }),
        Rotation = 90,
        Parent = hueBar,
    })
    local hueCursor = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.fromOffset(18, 5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = hueBar,
    })
    corner(hueCursor, UDim.new(1, 0))
    stroke(hueCursor, Theme.AccentDark, 0.4)

    local hexHolder = create("Frame", {
        Position = UDim2.fromOffset(6, 122),
        Size = UDim2.fromOffset(118, 28),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = panel,
    })
    corner(hexHolder, UDim.new(0, 6))
    local hexStroke = stroke(hexHolder)
    local hexBox = create("TextBox", {
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -24, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        TextTruncate = Enum.TextTruncate.None,
        ClipsDescendants = false,
        TextColor3 = Theme.Text,
        TextSize = 13,
        FontFace = Fonts.Regular,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = hexHolder,
    })
    local rgbLabel = label({
        Position = UDim2.fromOffset(134, 122),
        Size = UDim2.new(1, -134, 0, 28),
        TextXAlignment = Enum.TextXAlignment.Right,
        TextSize = 13,
        FontFace = Fonts.Regular,
        TextColor3 = Theme.Muted,
        Parent = panel,
    })

    local self_ = { Open = false }
    local hue, sat, val = Color3.toHSV(opts.Default or Theme.Accent)
    local dragTarget = nil

    local function toHex(color)
        return string.format("#%02X%02X%02X",
            math.floor(color.R * 255 + 0.5),
            math.floor(color.G * 255 + 0.5),
            math.floor(color.B * 255 + 0.5))
    end

    local function render(duration)
        local color = Color3.fromHSV(hue, sat, val)
        self_.Value = color
        swatch.BackgroundColor3 = color
        svHueGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromHSV(hue, 1, 1))
        tween(svCursor, { Position = UDim2.fromScale(sat, 1 - val) }, duration, Enum.EasingStyle.Linear)
        tween(hueCursor, { Position = UDim2.new(0.5, 0, hue, 0) }, duration, Enum.EasingStyle.Linear)
        if not hexBox:IsFocused() then
            hexBox.Text = toHex(color)
        end
        rgbLabel.Text = string.format("RGB %d, %d, %d",
            math.floor(color.R * 255 + 0.5),
            math.floor(color.G * 255 + 0.5),
            math.floor(color.B * 255 + 0.5))
    end

    local function commit(duration, silent)
        render(duration)
        if not silent then
            safeCall(opts.Callback, self_.Value)
        end
    end

    function self_:Set(color, silent)
        hue, sat, val = Color3.toHSV(color)
        commit(0.25, silent)
        flashStroke(frameStroke)
    end

    function self_:Get()
        return self_.Value
    end

    local function setOpen(open)
        self_.Open = open
        tween(frame, { Size = UDim2.new(1, 0, 0, open and (height + PANEL_HEIGHT) or height) }, 0.35, Enum.EasingStyle.Quint)
        arrow:Set(open)
        if open then
            panel.Visible = true
        else
            task.delay(0.35, function()
                if not self_.Open then
                    panel.Visible = false
                end
            end)
        end
    end

    function self_:SetOpen(open)
        setOpen(open == true)
    end

    header.MouseButton1Click:Connect(function()
        setOpen(not self_.Open)
    end)

    local function updateSV(position)
        sat = math.clamp((position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
        val = 1 - math.clamp((position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
        commit(0.04)
    end
    local function updateHue(position)
        hue = math.clamp((position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 0.999)
        commit(0.04)
    end

    svBox.InputBegan:Connect(function(input)
        if isPress(input) then
            dragTarget = "sv"
            tween(svCursor, { Size = UDim2.fromOffset(14, 14) }, 0.15, Enum.EasingStyle.Back)
            updateSV(pointerPosition())
        end
    end)
    hueBar.InputBegan:Connect(function(input)
        if isPress(input) then
            dragTarget = "hue"
            tween(hueCursor, { Size = UDim2.fromOffset(20, 7) }, 0.15, Enum.EasingStyle.Back)
            updateHue(pointerPosition())
        end
    end)
    self.Window:_listen("Changed", function(input)
        if not dragTarget or not isMove(input) then
            return
        end
        local position = pointerPosition()
        if dragTarget == "sv" then
            updateSV(position)
        else
            updateHue(position)
        end
    end, self_)
    self.Window:_listen("Ended", function(input)
        if dragTarget and isPress(input) then
            dragTarget = nil
            tween(svCursor, { Size = UDim2.fromOffset(10, 10) }, 0.2)
            tween(hueCursor, { Size = UDim2.fromOffset(18, 5) }, 0.2)
        end
    end, self_)

    hexBox.Focused:Connect(function()
        tween(hexStroke, { Color = Theme.StrokeHover }, 0.15)
    end)
    hexBox.FocusLost:Connect(function()
        tween(hexStroke, { Color = Theme.Stroke }, 0.15)
        local r, g, b = hexBox.Text:match("^%s*#?(%x%x)(%x%x)(%x%x)%s*$")
        if r then
            self_:Set(Color3.fromRGB(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)))
        else
            hexBox.Text = toHex(self_.Value)
        end
    end)

    render(0)
    return finishElement(self, opts, self_, frame, "ColorPicker")
end

function Tab:Stepper(opts)
    local frame, frameStroke, _, titleLabel, descLabel
    opts, frame, frameStroke, _, titleLabel, descLabel = beginElement(self, opts, { Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default", Increment = "Step" }, "Frame", 150, "Stepper")
    local min = opts.Min or 0
    local max = opts.Max or 100
    local step = opts.Step or 1
    local suffix = opts.Suffix or ""
    local numbers = numberFormat(min, max, step)

    local group = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(0, CHIP_HEIGHT),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = frame,
    })
    corner(group, UDim.new(0, 6))
    local groupStroke = stroke(group)
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = group,
    })

    local function stepButton(text, order)
        local button = create("TextButton", {
            Size = UDim2.fromOffset(CHIP_HEIGHT, CHIP_HEIGHT),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Theme.Muted,
            TextSize = 18,
            FontFace = Fonts.Medium,
            AutoButtonColor = false,
            LayoutOrder = order,
            Parent = group,
        })
        button.MouseEnter:Connect(function()
            tween(button, { TextColor3 = Theme.Accent }, 0.12)
        end)
        button.MouseLeave:Connect(function()
            tween(button, { TextColor3 = Theme.Muted }, 0.2)
        end)
        return button
    end
    local minus = stepButton("âˆ’", 1)
    local valueLabel = label({
        Size = UDim2.new(0, 30, 1, 0),
        TextSize = 13,
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTruncate = Enum.TextTruncate.None,
        LayoutOrder = 2,
        Parent = group,
    })
    local plus = stepButton("+", 3)
    local function fitValue(instant)
        local width = math.max(valueLabel.TextBounds.X + 12, 30)
        if instant then
            valueLabel.Size = UDim2.new(0, width, 1, 0)
        else
            tween(valueLabel, { Size = UDim2.new(0, width, 1, 0) }, 0.2)
        end
    end
    valueLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
        fitValue(false)
    end)
    group:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        reserveRight(titleLabel, descLabel, group.AbsoluteSize.X / self.Window.Scale.Scale + 20)
    end)

    local self_ = { Value = math.clamp(opts.Default or min, min, max) }
    local snap = numbers.snap
    local fromButton = false
    local function render()
        valueLabel.Text = numbers.format(self_.Value) .. suffix
        tween(minus, { TextTransparency = self_.Value <= min and 0.6 or 0 }, 0.15)
        tween(plus, { TextTransparency = self_.Value >= max and 0.6 or 0 }, 0.15)
    end
    function self_:Set(value, silent)
        value = snap(tonumber(value) or min)
        if value == self_.Value then
            return
        end
        self_.Value = value
        render()
        if not fromButton then
            flashStroke(frameStroke)
        end
        if not silent then
            safeCall(opts.Callback, value)
        end
    end
    function self_:Get()
        return self_.Value
    end

    local function bump(direction)
        fromButton = true
        self_:Set(self_.Value + direction * step)
        fromButton = false
        tween(groupStroke, { Color = Theme.StrokeHover }, 0.08)
        task.delay(0.12, function()
            tween(groupStroke, { Color = Theme.Stroke }, 0.2)
        end)
    end
    local function holdRepeat(button, direction)
        local holding = false
        button.InputBegan:Connect(function(input)
            if not isPress(input) then
                return
            end
            holding = true
            bump(direction)
            task.delay(0.4, function()
                while holding do
                    bump(direction)
                    task.wait(0.07)
                end
            end)
        end)
        button.InputEnded:Connect(function(input)
            if isPress(input) then
                holding = false
            end
        end)
        button.MouseLeave:Connect(function()
            holding = false
        end)
    end
    holdRepeat(minus, -1)
    holdRepeat(plus, 1)

    render()
    task.defer(fitValue, true)
    return finishElement(self, opts, self_, frame, "Stepper")
end

function Tab:Progress(opts)
    opts = normalize(opts, { Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default" })
    local frame, frameStroke = card(self, "Frame", opts.Desc and CARD_HEIGHT_DESC + 10 or CARD_HEIGHT + 10, opts)
    hoverStroke(frame, frameStroke)
    local top = opts.Desc and (CARD_HEIGHT_DESC - 38) / 2 - 2 or 12

    label({
        Position = UDim2.fromOffset(14, top),
        Size = UDim2.new(1, -110, 0, 18),
        Text = opts.Name or "Progress",
        Parent = frame,
    })
    if opts.Desc then
        label({
            Position = UDim2.fromOffset(14, top + 20),
            Size = UDim2.new(1, -110, 0, 17),
            Text = opts.Desc,
            TextSize = 13,
            FontFace = Fonts.Regular,
            TextColor3 = Theme.Muted,
            Parent = frame,
        })
    end
    local valueLabel = label({
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -14, 0, top),
        Size = UDim2.fromOffset(90, 18),
        TextXAlignment = Enum.TextXAlignment.Right,
        TextSize = 13,
        TextColor3 = Theme.Accent,
        Parent = frame,
    })
    local track = create("Frame", {
        Position = UDim2.new(0, 14, 1, -16),
        Size = UDim2.new(1, -28, 0, 5),
        BackgroundColor3 = Theme.Surface3,
        BorderSizePixel = 0,
        Parent = frame,
    })
    corner(track, UDim.new(1, 0))
    local fill = create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = opts.Color or Theme.Accent,
        BorderSizePixel = 0,
        Parent = track,
    })
    corner(fill, UDim.new(1, 0))

    local self_ = { Value = math.clamp(opts.Default or 0, 0, 1) }
    local formatter = opts.Format
    local function render(duration)
        local frac = self_.Value
        tween(fill, { Size = UDim2.new(frac, 0, 1, 0) }, duration, Enum.EasingStyle.Quint)
        if type(formatter) == "function" then
            valueLabel.Text = tostring(formatter(frac))
        else
            valueLabel.Text = string.format("%d%%", math.floor(frac * 100 + 0.5))
        end
    end
    function self_:Set(value, silent)
        value = math.clamp(tonumber(value) or 0, 0, 1)
        if value == self_.Value then
            return
        end
        self_.Value = value
        render(0.35)
        if not silent then
            safeCall(opts.Callback, value)
        end
    end
    function self_:Get()
        return self_.Value
    end
    function self_:SetColor(color)
        fill.BackgroundColor3 = color
    end
    render(0)
    return finishElement(self, opts, self_, frame, "Progress")
end


function Tab:ConfigManager(opts)
    opts = normalize(opts, {})
    local window = self.Window
    local manager = {}
    self:Section(opts.Name or "Configs")
    local nameInput = self:Input({
        Name = "Config name",
        Placeholder = window.ConfigName,
        Callback = function(text, enterPressed)
            if enterPressed and #text > 0 then
                manager:Save(text)
            end
        end,
    })
    local list = self:Dropdown({
        Name = "Saved configs",
        Options = window:ListConfigs(),
        Default = window.ConfigName,
        Callback = function(choice)
            if choice then
                nameInput:Set(choice)
            end
        end,
    })
    function manager:Refresh()
        list:Refresh(window:ListConfigs(), true)
    end
    function manager:Save(name)
        name = name or list:Get() or window.ConfigName
        local ok, err = window:SaveConfig(name)
        manager:Refresh()
        list:Set(name, true)
        window:Notify({ Title = ok and "Config saved" or "Save failed", Content = ok and name or tostring(err), Type = ok and "Success" or "Error", Duration = 3 })
    end
    function manager:Load(name)
        name = name or list:Get()
        if not name then
            return
        end
        local ok, err = window:LoadConfig(name)
        window:Notify({ Title = ok and "Config loaded" or "Load failed", Content = ok and name or tostring(err), Type = ok and "Success" or "Error", Duration = 3 })
    end
    function manager:Delete(name)
        name = name or list:Get()
        if not name then
            return
        end
        local ok, err = window:DeleteConfig(name)
        manager:Refresh()
        window:Notify({ Title = ok and "Config deleted" or "Delete failed", Content = ok and name or tostring(err), Type = ok and "Info" or "Error", Duration = 3 })
    end
    self:Button({ Name = "Save", Desc = "Writes every flagged element to the selected name", Icon = "save", Style = "Primary", Callback = function()
        local typed = nameInput:Get()
        manager:Save(#typed > 0 and typed or nil)
    end })
    self:Button({ Name = "Load", Icon = "folder-open", Callback = function()
        manager:Load()
    end })
    self:Button({ Name = "Delete", Icon = "trash-2", Callback = function()
        local name = list:Get()
        if not name then
            return
        end
        window:Confirm({
            Title = "Delete config",
            Content = "Remove " .. name .. "? This cannot be undone.",
            Icon = "trash-2",
            ConfirmText = "Delete",
            Callback = function()
                manager:Delete(name)
            end,
        })
    end })
    self:Toggle({
        Name = "Auto save",
        Desc = "Save whenever a flagged element changes",
        Default = window._autoSaveEnabled,
        Callback = function(on)
            window._autoSaveEnabled = on
        end,
    })
    return manager
end

for name, method in pairs(table.clone(Tab)) do
    if type(method) == "function" and name:sub(1, 1) ~= "_" and name:sub(1, 6) ~= "Create" then
        Tab["Create" .. name] = method
    end
end

local function detectExecutor()
    local name
    pcall(function()
        if typeof(identifyexecutor) == "function" then
            name = (identifyexecutor())
        elseif typeof(getexecutorname) == "function" then
            name = getexecutorname()
        end
    end)
    if type(name) == "string" and #name > 0 then
        return name
    end
    return RunService:IsStudio() and "Studio" or "Unknown"
end

local function detectGameName()
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    if ok and type(info) == "table" and info.Name then
        return info.Name
    end
    return "Unknown game"
end

local REGION_NAMES = {
    US = "United States", GB = "United Kingdom", DE = "Germany", FR = "France",
    NL = "Netherlands", SG = "Singapore", JP = "Japan", AU = "Australia",
    BR = "Brazil", IN = "India", HK = "Hong Kong", CA = "Canada",
}

local function detectRegion(callback)
    task.spawn(function()
        local requester = request or http_request or (syn and syn.request) or (http and http.request)
        local region
        if type(requester) == "function" then
            pcall(function()
                local response = requester({ Url = "https://ipinfo.io/json", Method = "GET" })
                local body = type(response) == "table" and (response.Body or response.body) or nil
                if type(body) == "string" then
                    local data = HttpService:JSONDecode(body)
                    if type(data) == "table" and data.country then
                        local label = REGION_NAMES[data.country] or data.country
                        region = data.city and (data.city .. ", " .. label) or label
                    end
                end
            end)
        end
        callback(region or "Unavailable")
    end)
end

local NOTIFY_COLORS = {
    Success = Theme.Success,
    Warning = Theme.Warning,
    Error = Theme.Error,
}

local Window = {}
Window.__index = Window

function Library.Window(_, opts)
    opts = normalize(opts, { Name = "Title", LoadingSubtitle = "Subtitle", ToggleUIKeybind = "Keybind" })

    if type(opts.Keybind) == "string" then
        opts.Keybind = Enum.KeyCode[opts.Keybind]
    end
    local size = opts.Size or UDim2.fromOffset(640, 480)
    local keybind = opts.Keybind or Enum.KeyCode.RightControl

    local self = setmetatable({
        Tabs = {},
        CurrentTab = nil,
        Open = true,
        Keybind = keybind,
        _connections = {},
        _controls = {},
        _inputListeners = { Began = {}, Changed = {}, Ended = {}, Render = {} },
        _frameSteps = {},
        _destroyed = false,
    }, Window)
    local function dispatch(kind)
        return function(...)
            for _, handler in ipairs(self._inputListeners[kind]) do
                handler(...)
            end
        end
    end
    local renderDispatch = dispatch("Render")
    table.insert(self._connections, RunService.RenderStepped:Connect(function(deltaTime)
        renderDispatch(deltaTime)
        for _, step in ipairs(self._frameSteps) do
            step(deltaTime)
        end
    end))
    table.insert(self._connections, UserInputService.InputBegan:Connect(dispatch("Began")))
    table.insert(self._connections, UserInputService.InputChanged:Connect(dispatch("Changed")))
    table.insert(self._connections, UserInputService.InputEnded:Connect(dispatch("Ended")))

    local gui = create("ScreenGui", {
        Name = opts.Name or "AirflowUI",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        DisplayOrder = 999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    self.Gui = gui

    local root = create("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = size,
        BackgroundTransparency = 1,
        Parent = gui,
    })
    self.Root = root
    local scale = create("UIScale", { Parent = root })
    self.Scale = scale

    local shadow = create("ImageLabel", {
        Position = UDim2.fromOffset(-25, -25),
        Size = UDim2.new(1, 50, 1, 50),
        BackgroundTransparency = 1,
        Image = Assets.Shadow,
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Parent = root,
    })
    self.Shadow = shadow

    local body = create("CanvasGroup", {
        Name = "Body",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = root,
    })
    self.Body = body
    corner(body, UDim.new(0, 10))
    self.BodyStroke = stroke(body, Theme.Stroke)
    edgeHighlight(body)

    glow(body, UDim2.fromOffset(500, 180), UDim2.new(0.5, 0, 1, 8), 0.86, 270)
    glow(body, UDim2.fromOffset(130, 60), UDim2.new(0, -10, 1, -10), 0.75, 90)
    glow(body, UDim2.fromOffset(520, 240), UDim2.new(1, -14, 0, 10), 0.92, 90)

    local sidebar = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, SIDEBAR_WIDTH, 1, 0),
        BackgroundTransparency = 1,
        Parent = body,
    })
    create("Frame", {
        Position = UDim2.new(0, SIDEBAR_WIDTH, 0, 28),
        Size = UDim2.new(0, 1, 1, -56),
        BackgroundColor3 = Theme.Stroke,
        BorderSizePixel = 0,
        Parent = body,
    })

    local header = create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
        BackgroundTransparency = 1,
        Parent = sidebar,
    })
    local logo = create("ImageLabel", {
        Position = UDim2.fromOffset(22, 27),
        Size = UDim2.fromOffset(30, 28),
        BackgroundTransparency = 1,
        Image = "",
        ImageColor3 = Theme.Accent,
        ScaleType = Enum.ScaleType.Fit,
        Parent = header,
    })
    applyIcon(logo, opts.Icon or Assets.Logo)
    label({
        Position = UDim2.fromOffset(60, 25),
        Size = UDim2.new(1, -70, 0, 20),
        Text = opts.Title or "Airflow",
        TextSize = 20,
        Parent = header,
    })
    label({
        Position = UDim2.fromOffset(60, 45),
        Size = UDim2.new(1, -70, 0, 14),
        Text = opts.Subtitle or "",
        TextSize = 13,
        FontFace = Fonts.Regular,
        TextColor3 = Theme.Muted,
        Parent = header,
    })

    local tabList = create("ScrollingFrame", {
        Name = "Tabs",
        Position = UDim2.fromOffset(0, HEADER_HEIGHT + 8),
        Size = UDim2.new(1, 0, 1, -(HEADER_HEIGHT + 8 + 36)),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Parent = sidebar,
    })
    self.TabList = tabList
    padding(tabList, 16, 16, 4, 4)
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = tabList,
    })

    local indicator = create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromOffset(6, 0),
        Size = UDim2.fromOffset(3, 18),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 2,
        Parent = sidebar,
    })
    corner(indicator, UDim.new(1, 0))
    self.Indicator = indicator
    local lastCanvasY = tabList.CanvasPosition.Y
    table.insert(self._frameSteps, function()
        local canvasY = tabList.CanvasPosition.Y
        if canvasY == lastCanvasY or not self.CurrentTab or not self._introDone then
            return
        end
        lastCanvasY = canvasY
        local targetY = self:_indicatorY(self.CurrentTab)
        local top = tabList.Position.Y.Offset
        local bottom = top + tabList.AbsoluteSize.Y / self.Scale.Scale
        indicator.Visible = targetY > top and targetY < bottom
        indicator.Position = UDim2.fromOffset(6, targetY)
    end)

    local footer = create("Frame", {
        Position = UDim2.new(0, 22, 1, -36),
        Size = UDim2.new(1, -44, 0, 22),
        BackgroundTransparency = 1,
        Parent = sidebar,
    })
    local keyChip = create("Frame", {
        Size = UDim2.fromOffset(0, 22),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = footer,
    })
    corner(keyChip, UDim.new(0, 5))
    stroke(keyChip)
    padding(keyChip, 7, 7)
    local keyChipLabel = label({
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = keyName(keybind),
        TextSize = 11,
        TextColor3 = Theme.Muted,
        TextTruncate = Enum.TextTruncate.None,
        Parent = keyChip,
    })
    self._keyChipLabel = keyChipLabel
    local hintLabel = label({
        Size = UDim2.new(1, 0, 1, 0),
        Text = TOUCH and "or tap the pill" or "to hide",
        TextSize = 12,
        FontFace = Fonts.Regular,
        TextColor3 = Theme.Muted,
        Parent = footer,
    })
    local function placeHint()
        hintLabel.Position = UDim2.fromOffset(keyChip.AbsoluteSize.X / self.Scale.Scale + 8, 0)
    end
    keyChip:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeHint)
    task.defer(placeHint)

    local content = create("Frame", {
        Name = "Content",
        Position = UDim2.fromOffset(SIDEBAR_WIDTH + 1, 0),
        Size = UDim2.new(1, -(SIDEBAR_WIDTH + 1), 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = body,
    })
    self.Content = content
    self._outLayer = create("CanvasGroup", {
        Name = "TransitionOut",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 2,
        Parent = content,
    })
    self._inLayer = create("CanvasGroup", {
        Name = "TransitionIn",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 3,
        Parent = content,
    })

    local closeButton = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -14, 0, 14),
        Size = UDim2.fromOffset(34, 34),
        BackgroundColor3 = Theme.Surface2,
        BackgroundTransparency = 1,
        Text = "Ã—",
        TextColor3 = Theme.Muted,
        TextSize = 28,
        FontFace = Fonts.Bold,
        AutoButtonColor = false,
        ZIndex = 5,
        Parent = content,
    })
    padding(closeButton, 0, 0, 1, 0)
    corner(closeButton, UDim.new(0, 8))
    closeButton.MouseEnter:Connect(function()
        tween(closeButton, { BackgroundTransparency = 0, TextColor3 = Theme.Text }, 0.15)
    end)
    closeButton.MouseLeave:Connect(function()
        tween(closeButton, { BackgroundTransparency = 1, TextColor3 = Theme.Muted }, 0.2)
    end)
    closeButton.MouseButton1Click:Connect(function()
        self:Toggle(false)
    end)

    local notifyHolder = create("Frame", {
        Name = "Notifications",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 280, 1, -40),
        BackgroundTransparency = 1,
        Parent = gui,
    })
    local function fitToasts()
        notifyHolder.Size = UDim2.new(0, math.min(280, gui.AbsoluteSize.X - 40), 1, -40)
    end
    table.insert(self._connections, gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitToasts))
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 4),
        Parent = notifyHolder,
    })
    self.NotifyHolder = notifyHolder
    self._notifyOrder = 0
    self._toasts = {}
    self.MaxNotifications = opts.MaxNotifications or 4

    self._controlsDirty = true
    table.insert(self._connections, body.DescendantAdded:Connect(function()
        self._controlsDirty = true
    end))
    table.insert(self._connections, body.DescendantRemoving:Connect(function()
        self._controlsDirty = true
    end))

    self:_enableDrag()
    self.MaxSize = opts.MaxSize
    self.KeepOnScreen = opts.KeepOnScreen ~= false
    self:_enableResize(opts.MinSize or Vector2.new(480, 360))

    local saving = opts.ConfigurationSaving
    if type(saving) == "table" and saving.Enabled ~= false then
        self.ConfigFolder = saving.FolderName or "AirflowUI"
        self.ConfigName = saving.FileName or "default"
        self._autoSaveEnabled = true
    else
        self.ConfigFolder = "AirflowUI"
        self.ConfigName = "default"
        self._autoSaveEnabled = false
    end

    table.insert(self._connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.Keybind then
            task.defer(function()
                local consumed = self._consumedKey == input.KeyCode and os.clock() - (self._consumedAt or 0) < 0.2
                self._consumedKey = nil
                if not consumed and not self._destroyed then
                    self:Toggle(not self.Open)
                end
            end)
        end
    end))

    pcall(function()
        if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
            syn.protect_gui(gui)
        end
    end)
    gui.Parent = opts.Parent or defaultParent()

    scale.Scale = 0.9
    body.GroupTransparency = 1
    shadow.ImageTransparency = 1
    self.BodyStroke.Transparency = 1
    root.Visible = false
    self:_fitToScreen(true)
    table.insert(self._connections, gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self:_fitToScreen()
        self:_clampToScreen()
    end))
    if (opts.OpenButton ~= nil and opts.OpenButton ~= false) or (opts.OpenButton == nil and TOUCH) then
        self:_createOpenButton(type(opts.OpenButton) == "table" and opts.OpenButton or {})
    end
    self._introDone = false

    table.insert(Library.Windows, self)

    if opts.Home then
        self:_buildHome(type(opts.Home) == "table" and opts.Home or {})
    end

    local loading = opts.Loading
    if type(loading) == "table" then
        opts.LoadingDuration = loading.Duration or opts.LoadingDuration
        opts.LoadingText = loading.Text or loading.Subtitle or opts.LoadingText
        opts.LoadingSteps = loading.Steps or opts.LoadingSteps
        opts.LoadingTitle = loading.Title or opts.LoadingTitle
        loading = loading.Enabled ~= false
    end
    if loading == false then
        task.defer(function()
            self:_playIntro()
        end)
    else
        self:_showLoader(opts)
    end
    return self
end

Library.CreateWindow = Library.Window



function Library:Notify(opts)
    local window = Library.Windows[#Library.Windows]
    if window then
        return window:Notify(opts)
    end
end

function Library:Confirm(opts)
    local window = Library.Windows[#Library.Windows]
    if window then
        return window:Confirm(opts)
    end
end

function Library:Dialog(opts)
    local window = Library.Windows[#Library.Windows]
    if window then
        return window:Dialog(opts)
    end
end

local function pointInside(point, object)
    local position, size = object.AbsolutePosition, object.AbsoluteSize
    return point.X >= position.X and point.X <= position.X + size.X
        and point.Y >= position.Y and point.Y <= position.Y + size.Y
end

local function isShown(object, stopAt, point)
    local child = object
    while child and child ~= stopAt and child:IsA("GuiObject") do
        if not child.Visible then
            return false
        end
        local parent = child.Parent
        if parent and parent ~= stopAt and parent:IsA("GuiObject") and (parent.ClipsDescendants or parent:IsA("ScrollingFrame")) and not pointInside(point, parent) then
            return false
        end
        child = parent
    end
    return true
end

function Window:_refreshControls()
    local controls = {}
    for _, object in ipairs(self.Body:GetDescendants()) do
        if object:IsA("GuiButton") or object:IsA("TextBox") or object:GetAttribute("NoDrag") then
            table.insert(controls, object)
        end
    end
    self._controls = controls
    self._controlsDirty = false
end

function Window:_overControl(point)
    if self._dialog then
        return true
    end
    if self._controlsDirty then
        self:_refreshControls()
    end
    for _, object in ipairs(self._controls) do
        if object.Parent and pointInside(point, object) and isShown(object, self.Body, point) then
            return true
        end
    end
    return false
end

function Window:_enableDrag()
    local dragging = false
    local grabOffset = Vector2.zero
    local target = nil

    local function centre()
        local root = self.Root
        return root.AbsolutePosition + root.AbsoluteSize * root.AnchorPoint - self.Gui.AbsolutePosition
    end

    table.insert(self._connections, UserInputService.InputBegan:Connect(function(input)
        if not isPress(input) then
            return
        end
        if not self.Open or not self.Root.Visible then
            return
        end
        local point = pointerPosition()
        if not pointInside(point, self.Body) or self:_overControl(point) then
            return
        end
        dragging = true
        grabOffset = point - centre()
    end))

    table.insert(self._connections, UserInputService.InputEnded:Connect(function(input)
        if not dragging then
            return
        end
        if isPress(input) then
            dragging = false
            target = nil
            self:_clampToScreen()
        end
    end))

    table.insert(self._frameSteps, function(deltaTime)
        if not dragging then
            return
        end
        target = pointerPosition() - grabOffset
        local current = centre()
        local alpha = 1 - math.exp(-deltaTime * 45)
        local step = current:Lerp(target, alpha)
        self.Root.Position = UDim2.fromOffset(step.X, step.Y)
    end)
end

local function popIn(object, delay, force)
    if not object.Visible and not force then
        return
    end
    object.Visible = false
    task.delay(delay, function()
        if not object.Parent then
            return
        end
        local scaleObject = create("UIScale", { Scale = 0.94, Parent = object })
        object.Visible = true
        tween(scaleObject, { Scale = 1 }, 0.4, Enum.EasingStyle.Back)
        task.delay(0.4, function()
            scaleObject:Destroy()
        end)
    end)
end

function Window:_revealCards(tab, baseDelay)
    if tab._revealed then
        return
    end
    tab._revealed = true
    local index = 0
    for _, child in ipairs(tab.List:GetChildren()) do
        if child:IsA("GuiObject") then
            popIn(child, (baseDelay or 0) + index * 0.035)
            index += 1
        end
    end
end

function Window:_playIntro(morph)
    if self._introDone then
        return
    end
    self._introDone = true
    task.delay(1, function()
        self._autoSaveReady = true
    end)
    local root, body, shadow, scale = self.Root, self.Body, self.Shadow, self.Scale
    if self.CurrentTab then
        self:_revealCards(self.CurrentTab, morph and 0.15 or 0.25)
    end
    root.Visible = true
    if morph then
        scale.Scale = self._fitScale or 1
        root.Position = UDim2.fromScale(0.5, 0.5)
        tween(body, { GroupTransparency = 0 }, 0.3)
        tween(self.BodyStroke, { Transparency = 0 }, 0.3)
        tween(shadow, { ImageTransparency = 0.6 }, 0.3)
    else
        root.Position = UDim2.new(0.5, 0, 0.5, 24)
        tween(scale, { Scale = self._fitScale or 1 }, 0.5, Enum.EasingStyle.Back)
        tween(root, { Position = UDim2.fromScale(0.5, 0.5) }, 0.5, Enum.EasingStyle.Quint)
        tween(body, { GroupTransparency = 0 }, 0.35)
        tween(self.BodyStroke, { Transparency = 0 }, 0.35)
    end
    if not morph then
        tween(shadow, { ImageTransparency = 0.6 }, 0.5)
    end

    for index, tab in ipairs(self.Tabs) do
        popIn(tab._button, 0.1 + index * 0.05, true)
    end
    self.Indicator.Visible = false
    task.delay(0.15 + #self.Tabs * 0.05, function()
        if self.CurrentTab then
            self:_placeIndicator(self.CurrentTab)
        end
    end)
end

function Window:_showLoader(opts)
    local duration = opts.LoadingDuration or 1.6
    local gui = self.Gui
    local loader = create("CanvasGroup", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 16),
        Size = UDim2.fromOffset(300, 132),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        GroupTransparency = 1,
        ZIndex = 10,
        Parent = gui,
    })
    local loaderCorner = corner(loader, UDim.new(0, 12))
    local loaderStroke = stroke(loader, Theme.Stroke, 1)
    edgeHighlight(loader)
    glow(loader, UDim2.fromOffset(320, 140), UDim2.new(1, -20, 0, -20), 0.85, 90)
    glow(loader, UDim2.fromOffset(240, 100), UDim2.new(0, 10, 1, 10), 0.9, 270)
    local loaderScale = create("UIScale", { Scale = 0.92, Parent = loader })
    local loaderShadow = create("ImageLabel", {
        Position = UDim2.fromOffset(-25, -25),
        Size = UDim2.new(1, 50, 1, 50),
        BackgroundTransparency = 1,
        Image = Assets.Shadow,
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0,
        Parent = loader,
    })

    local logoHolder = create("Frame", {
        Position = UDim2.fromOffset(24, 26),
        Size = UDim2.fromOffset(40, 40),
        BackgroundTransparency = 1,
        Parent = loader,
    })
    local logo = create("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.5, 0.5),
        Rotation = -14,
        BackgroundTransparency = 1,
        ImageColor3 = Theme.Accent,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Fit,
        Parent = logoHolder,
    })
    applyIcon(logo, opts.Icon or Assets.Logo)
    task.delay(0.15, function()
        tween(logo, { Size = UDim2.fromScale(0.85, 0.85), Rotation = 0, ImageTransparency = 0 }, 0.6, Enum.EasingStyle.Back)
    end)
    label({
        Position = UDim2.fromOffset(78, 30),
        Size = UDim2.new(1, -100, 0, 22),
        Text = opts.LoadingTitle or opts.Title or "Airflow",
        TextSize = 20,
        Parent = loader,
    })
    local statusLabel = label({
        Position = UDim2.fromOffset(78, 52),
        Size = UDim2.new(1, -100, 0, 16),
        Text = opts.LoadingText or opts.Subtitle or "Loading",
        TextSize = 13,
        FontFace = Fonts.Regular,
        TextColor3 = Theme.Muted,
        Parent = loader,
    })
    local track = create("Frame", {
        Position = UDim2.new(0, 24, 1, -30),
        Size = UDim2.new(1, -48, 0, 4),
        BackgroundColor3 = Theme.Surface3,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = loader,
    })
    corner(track, UDim.new(1, 0))
    local fill = create("Frame", {
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = track,
    })
    corner(fill, UDim.new(1, 0))
    local sheen = create("Frame", {
        Position = UDim2.fromScale(-0.4, 0),
        Size = UDim2.fromScale(0.4, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = track,
    })
    create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = sheen,
    })

    tween(loader, { GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5) }, 0.4, Enum.EasingStyle.Quint)
    tween(loaderScale, { Scale = 1 }, 0.5, Enum.EasingStyle.Back)
    tween(loaderShadow, { ImageTransparency = 0.6 }, 0.4)
    local sweep = TweenService:Create(sheen, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), {
        Position = UDim2.fromScale(1, 0),
    })
    sweep:Play()
    tween(fill, { Size = UDim2.fromScale(0.85, 1) }, duration * 0.8, Enum.EasingStyle.Quart)

    task.spawn(loadLucide)

    local steps = opts.LoadingSteps or { "Preparing interface", "Loading icons", "Almost there" }
    for index, text in ipairs(steps) do
        task.delay(duration * (index - 1) / #steps, function()
            if loader.Parent then
                statusLabel.Text = text
            end
        end)
    end

    task.delay(duration, function()
        tween(fill, { Size = UDim2.fromScale(1, 1) }, 0.25, Enum.EasingStyle.Quint)
        task.delay(0.25, function()
            sweep:Cancel()
            for _, item in ipairs(loader:GetChildren()) do
                if item:IsA("TextLabel") then
                    tween(item, { TextTransparency = 1 }, 0.15)
                end
            end
            for _, item in ipairs(logoHolder:GetChildren()) do
                tween(item, { ImageTransparency = 1 }, 0.15)
            end
            tween(track, { BackgroundTransparency = 1 }, 0.15)
            tween(fill, { BackgroundTransparency = 1 }, 0.15)
            tween(sheen, { BackgroundTransparency = 1 }, 0.1)

            local fit = self._fitScale or 1
            local target = self.Root.Size
            tween(loader, {
                Size = UDim2.fromOffset(target.X.Offset * fit, target.Y.Offset * fit),
                Position = UDim2.fromScale(0.5, 0.5),
            }, 0.5, Enum.EasingStyle.Quint)
            tween(loaderCorner, { CornerRadius = UDim.new(0, 10) }, 0.5, Enum.EasingStyle.Quint)
            tween(loaderScale, { Scale = 1 }, 0.5, Enum.EasingStyle.Quint)

            task.delay(0.28, function()
                self:_playIntro(true)
                tween(loader, { GroupTransparency = 1 }, 0.25)
                tween(loaderStroke, { Transparency = 1 }, 0.2)
                tween(loaderShadow, { ImageTransparency = 1 }, 0.2)
            end)
            task.delay(0.6, function()
                loader:Destroy()
            end)
        end)
    end)
end

function Window:_fitToScreen(instant)
    local viewport = self.Gui.AbsoluteSize
    if viewport.X == 0 or viewport.Y == 0 then
        return
    end
    local size = self.Root.Size
    local scale = math.min(1, (viewport.X - 24) / math.max(size.X.Offset, 1), (viewport.Y - 24) / math.max(size.Y.Offset, 1))
    self._fitScale = math.max(scale, 0.45)
    if self._introDone and self.Open then
        if instant then
            self.Scale.Scale = self._fitScale
        else
            tween(self.Scale, { Scale = self._fitScale }, 0.2)
        end
    end
end

function Window:_clampToScreen()
    if not self.KeepOnScreen then
        return
    end
    local viewport = self.Gui.AbsoluteSize
    local root = self.Root
    local half = root.AbsoluteSize / 2
    local centre = root.AbsolutePosition + half - self.Gui.AbsolutePosition
    local clamped = Vector2.new(
        math.clamp(centre.X, math.min(half.X, viewport.X / 2), math.max(viewport.X - half.X, viewport.X / 2)),
        math.clamp(centre.Y, math.min(half.Y, viewport.Y / 2), math.max(viewport.Y - half.Y, viewport.Y / 2))
    )
    if (clamped - centre).Magnitude > 0.5 then
        tween(root, { Position = UDim2.fromOffset(clamped.X, clamped.Y) }, 0.25, Enum.EasingStyle.Quint)
    end
end

function Window:_createOpenButton(opts)
    local gui = self.Gui
    local pill = create("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 14),
        Size = UDim2.fromOffset(0, 40),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 30,
        Parent = gui,
    })
    corner(pill, UDim.new(1, 0))
    stroke(pill, Theme.Stroke)
    padding(pill, 12, 16)
    local icon = create("ImageLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(20, 20),
        BackgroundTransparency = 1,
        ImageColor3 = Theme.Accent,
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 31,
        Parent = pill,
    })
    applyIcon(icon, opts.Icon or Assets.Logo)
    label({
        Position = UDim2.fromOffset(28, 0),
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = opts.Title or "Airflow",
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.None,
        ZIndex = 31,
        Parent = pill,
    })
    self.OpenButton = pill

    local dragging, moved = false, false
    local grab = Vector2.zero
    pill.InputBegan:Connect(function(input)
        if isPress(input) then
            dragging = true
            moved = false
            grab = pointerPosition() - pill.AbsolutePosition
        end
    end)
    table.insert(self._connections, UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end
        if isMove(input) then
            local point = pointerPosition() - grab - gui.AbsolutePosition
            if (point - (pill.AbsolutePosition - gui.AbsolutePosition)).Magnitude > 3 then
                moved = true
            end
            pill.AnchorPoint = Vector2.new(0, 0)
            pill.Position = UDim2.fromOffset(
                math.clamp(point.X, 0, math.max(gui.AbsoluteSize.X - pill.AbsoluteSize.X, 0)),
                math.clamp(point.Y, 0, math.max(gui.AbsoluteSize.Y - pill.AbsoluteSize.Y, 0))
            )
        end
    end))
    table.insert(self._connections, UserInputService.InputEnded:Connect(function(input)
        if dragging and isPress(input) then
            dragging = false
            if not moved then
                self:Toggle()
            end
        end
    end))
end

function Window:_enableResize(minSize)
    local maxSize = self.MaxSize or Vector2.new(math.huge, math.huge)
    local grip = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, 4, 1, 4),
        Size = UDim2.fromOffset(32, 32),
        BackgroundTransparency = 1,
        Active = true,
        ZIndex = 20,
        Parent = self.Root,
    })
    local gripImage = create("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, -16, 0.5, -16),
        Size = UDim2.fromOffset(96, 96),
        BackgroundTransparency = 1,
        Image = "rbxassetid://120997033468887",
        ImageColor3 = Theme.Accent,
        ImageTransparency = 0.8,
        ZIndex = 20,
        Parent = grip,
    })

    local resizing = false
    local initialSize = self.Root.Size
    local initialPointer = Vector2.zero
    local targetSize = nil

    grip.InputBegan:Connect(function(input)
        if isPress(input) then
            resizing = true
            initialSize = self.Root.Size
            initialPointer = pointerPosition()
            tween(gripImage, { ImageTransparency = 0.35 }, 0.1)
        end
    end)
    grip.MouseEnter:Connect(function()
        if not resizing then
            tween(gripImage, { ImageTransparency = 0.35 }, 0.1)
        end
    end)
    grip.MouseLeave:Connect(function()
        if not resizing then
            tween(gripImage, { ImageTransparency = 0.8 }, 0.17)
        end
    end)
    table.insert(self._connections, UserInputService.InputEnded:Connect(function(input)
        if resizing and isPress(input) then
            resizing = false
            tween(gripImage, { ImageTransparency = 0.8 }, 0.17)
            if targetSize then
                self.Root.Size = UDim2.fromOffset(targetSize.X, targetSize.Y)
                targetSize = nil
            end
            self:_fitToScreen()
            self:_clampToScreen()
        end
    end))
    table.insert(self._frameSteps, function(deltaTime)
        if not resizing then
            return
        end
        local delta = (pointerPosition() - initialPointer) / self.Scale.Scale
        targetSize = Vector2.new(
            math.clamp(initialSize.X.Offset + delta.X * 2, minSize.X, maxSize.X),
            math.clamp(initialSize.Y.Offset + delta.Y * 2, minSize.Y, maxSize.Y)
        )
        local current = Vector2.new(self.Root.Size.X.Offset, self.Root.Size.Y.Offset)
        local alpha = 1 - math.exp(-deltaTime * 35)
        local step = current:Lerp(targetSize, alpha)
        step = Vector2.new(math.floor(step.X + 0.5), math.floor(step.Y + 0.5))
        if step ~= current then
            self.Root.Size = UDim2.fromOffset(step.X, step.Y)
        end
    end)
end

local function configPath(self, name)
    return self.ConfigFolder .. "/" .. name .. ".json"
end

local function fileApiAvailable()
    return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
end

local function ensureFolder(folder)
    if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(folder) then
        makefolder(folder)
    end
end

local function serializeFlag(element)
    local kind = element._type
    local value = element:Get()
    if kind == "Keybind" then
        return { Type = kind, Value = value and value.Name or nil }
    elseif kind == "ColorPicker" then
        return { Type = kind, Value = { value.R, value.G, value.B } }
    end
    return { Type = kind, Value = value }
end

local function deserializeFlag(element, entry, silent)
    local kind = element._type
    local value = entry.Value
    if kind == "Keybind" then
        element:Set(value and Enum.KeyCode[value] or nil, silent)
    elseif kind == "ColorPicker" then
        if type(value) == "table" then
            element:Set(Color3.new(value[1], value[2], value[3]), silent)
        end
    elseif value ~= nil then
        element:Set(value, silent)
    end
end

function Window:SaveConfig(name)
    name = name or self.ConfigName
    if not fileApiAvailable() then
        return false, "file API unavailable"
    end
    ensureFolder(self.ConfigFolder)
    local data = {}
    for flag, element in pairs(Library.Flags) do
        if element._type and type(element.Get) == "function" then
            data[flag] = serializeFlag(element)
        end
    end
    local ok, err = pcall(function()
        writefile(configPath(self, name), HttpService:JSONEncode(data))
    end)
    if ok then
        self.ConfigName = name
    end
    return ok, err
end

function Window:LoadConfig(name, silent)
    name = name or self.ConfigName
    if not fileApiAvailable() then
        return false, "file API unavailable"
    end
    local path = configPath(self, name)
    if not isfile(path) then
        return false, "no config named " .. name
    end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if not ok or type(data) ~= "table" then
        return false, "config is not valid JSON"
    end
    local previous = self._autoSaveEnabled
    self._autoSaveEnabled = false
    for flag, entry in pairs(data) do
        local element = Library.Flags[flag]
        if element and type(element.Set) == "function" and type(entry) == "table" and entry.Type == element._type then
            pcall(deserializeFlag, element, entry, silent == true)
        end
    end
    self._autoSaveEnabled = previous
    self._autoSaveReady = true
    self.ConfigName = name
    return true
end


function Window:DeleteConfig(name)
    if not fileApiAvailable() or type(delfile) ~= "function" then
        return false, "file API unavailable"
    end
    local path = configPath(self, name)
    if not isfile(path) then
        return false, "no config named " .. name
    end
    delfile(path)
    return true
end

function Window:ListConfigs()
    local names = {}
    if type(listfiles) ~= "function" or type(isfolder) ~= "function" or not isfolder(self.ConfigFolder) then
        return names
    end
    for _, path in ipairs(listfiles(self.ConfigFolder)) do
        local name = path:match("([^/\\]+)%.json$")
        if name then
            table.insert(names, name)
        end
    end
    table.sort(names)
    return names
end

function Window:_autoSave()
    if not self._autoSaveEnabled or self._destroyed or not self._autoSaveReady then
        return
    end
    if self._autoSavePending then
        return
    end
    self._autoSavePending = true
    task.delay(0.5, function()
        self._autoSavePending = false
        if not self._destroyed then
            self:SaveConfig(self.ConfigName)
        end
    end)
end

local function emptyState(parent, icon, text)
    local holder = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, -10),
        Size = UDim2.fromOffset(200, 70),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    local image = create("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.fromOffset(26, 26),
        BackgroundTransparency = 1,
        ImageColor3 = Theme.Muted,
        ImageTransparency = 0.15,
        ScaleType = Enum.ScaleType.Fit,
        Parent = holder,
    })
    applyIcon(image, icon)
    local caption = label({
        Position = UDim2.fromOffset(0, 36),
        Size = UDim2.new(1, 0, 0, 16),
        Text = text,
        TextSize = 13,
        FontFace = Fonts.Regular,
        TextColor3 = Theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = holder,
    })
    return holder, caption, image
end

local function statRow(parent, order, icon, title)
    local card = create("Frame", {
        Size = UDim2.new(0.5, -4, 0, 62),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
    })
    corner(card)
    stroke(card)
    card:SetAttribute("NoDrag", true)
    if icon then
        glowIcon(card, icon, Theme.Muted, UDim2.new(0, 14, 0, 21))
    end
    label({
        Position = UDim2.fromOffset(icon and 36 or 14, 12),
        Size = UDim2.new(1, -(icon and 50 or 28), 0, 16),
        Text = title,
        TextSize = 12,
        TextColor3 = Theme.Muted,
        Parent = card,
    })
    return label({
        Position = UDim2.fromOffset(14, 34),
        Size = UDim2.new(1, -28, 0, 18),
        Text = "â€¦",
        TextSize = 15,
        Parent = card,
    })
end

local function fadeCard(card)
    local parts = {}
    local function collect(object)
        for _, child in ipairs(object:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                table.insert(parts, { child, "TextTransparency", child.TextTransparency })
            elseif child:IsA("ImageLabel") or child:IsA("ImageButton") then
                table.insert(parts, { child, "ImageTransparency", child.ImageTransparency })
            elseif child:IsA("UIStroke") then
                table.insert(parts, { child, "Transparency", child.Transparency })
            elseif child:IsA("Frame") then
                table.insert(parts, { child, "BackgroundTransparency", child.BackgroundTransparency })
            end
            collect(child)
        end
    end
    if card:IsA("Frame") then
        table.insert(parts, { card, "BackgroundTransparency", card.BackgroundTransparency })
    end
    collect(card)
    for _, part in ipairs(parts) do
        part[1][part[2]] = 1
        tween(part[1], { [part[2]] = part[3] }, 0.28)
    end
end

local function fadeSlideIn(group, restY)
    restY = restY or 0
    group.GroupTransparency = 1
    group.Position = UDim2.fromOffset(0, restY + 14)
    group.Visible = true
    tween(group, { GroupTransparency = 0, Position = UDim2.fromOffset(0, restY) }, 0.32, Enum.EasingStyle.Quint)
end

function Window:_buildHome(opts)
    local tab = self:Tab({
        Name = opts.Name or "Home",
        Desc = opts.Desc,
        Icon = opts.Icon or "house",
    })
    local list = tab.List

    local pages = opts.Pages or opts.Tabs
    local panels = {}
    local strip = nil
    if type(pages) == "table" and #pages > 0 then
        strip = create("Frame", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Parent = list,
        })
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = strip,
        })
    end

    local greeting = opts.Greeting
    if greeting == nil then
        local hour = tonumber(os.date("%H")) or 12
        local part = hour < 12 and "morning" or (hour < 18 and "afternoon" or "evening")
        greeting = "Good " .. part .. "."
    end
    local header = create("Frame", {
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        LayoutOrder = 2,
        Parent = list,
    })
    header:SetAttribute("NoDrag", true)
    corner(header)
    stroke(header)
    local avatar = create("ImageLabel", {
        Position = UDim2.fromOffset(12, 11),
        Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = header,
    })
    corner(avatar, UDim.new(0, 8))
    stroke(avatar)
    task.spawn(function()
        local ok, url = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and url then
            avatar.Image = url
        end
    end)
    label({
        Position = UDim2.fromOffset(58, 11),
        Size = UDim2.new(1, -72, 0, 18),
        Text = (opts.Welcome or "Hello, ") .. LocalPlayer.DisplayName,
        TextSize = 15,
        Parent = header,
    })
    label({
        Position = UDim2.fromOffset(58, 30),
        Size = UDim2.new(1, -72, 0, 16),
        Text = greeting,
        TextSize = 13,
        FontFace = Fonts.Regular,
        TextColor3 = Theme.Muted,
        Parent = header,
    })

    local infoPanel = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        Parent = list,
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = infoPanel,
    })

    if opts.Sections ~= false then
        local heading = create("Frame", {
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Parent = infoPanel,
        })
        local headingText = label({
            Position = UDim2.fromOffset(2, 6),
            Size = UDim2.new(0, 0, 0, 16),
            AutomaticSize = Enum.AutomaticSize.X,
            Text = string.upper(opts.SectionName or "System info"),
            TextSize = 12,
            TextColor3 = Theme.Muted,
            TextTruncate = Enum.TextTruncate.None,
            Parent = heading,
        })
        local rule = create("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0, 14),
            Size = UDim2.new(1, -12, 0, 1),
            BackgroundColor3 = Theme.Stroke,
            BorderSizePixel = 0,
            Parent = heading,
        })
        local function fitRule()
            rule.Size = UDim2.new(1, -(headingText.AbsoluteSize.X + 14), 0, 1)
        end
        headingText:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitRule)
        task.defer(fitRule)
    end

    local grid = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Parent = infoPanel,
    })
    create("UIGridLayout", {
        CellSize = UDim2.new(0.5, -4, 0, 62),
        CellPadding = UDim2.fromOffset(8, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = grid,
    })

    local show = opts.Stats or { "FPS", "Ping", "Executor", "Game", "Region", "Time" }
    local enabled = {}
    for _, name in ipairs(show) do
        enabled[name] = true
    end
    local order = 0
    local function add(name, icon, title)
        if not enabled[name] then
            return nil
        end
        order += 1
        return statRow(grid, order, icon, title)
    end

    local fpsValue = add("FPS", "activity", "FPS")
    local pingValue = add("Ping", "wifi", "Ping")
    local executorValue = add("Executor", "terminal", "Executor")
    local gameValue = add("Game", "gamepad-2", "Game")
    local regionValue = add("Region", "globe", "Server region")
    local timeValue = add("Time", "clock", "Time of day")
    local playersValue = add("Players", "users", "Players")
    local uptimeValue = add("Uptime", "timer", "Session")

    if executorValue then
        executorValue.Text = detectExecutor()
    end
    if gameValue then
        gameValue.Text = "Loading"
        task.spawn(function()
            gameValue.Text = detectGameName()
        end)
    end
    if regionValue then
        regionValue.Text = "Loading"
        detectRegion(function(region)
            regionValue.Text = region
        end)
    end

    local frames = 0
    local started = os.clock()
    self:_listen("Render", function()
        frames += 1
    end)
    task.spawn(function()
        while not self._destroyed and tab.List.Parent and tab._page.Parent do
            if not self.Open or self.CurrentTab ~= tab then
                frames = 0
                task.wait(1)
                continue
            end
            if fpsValue then
                fpsValue.Text = tostring(frames)
            end
            frames = 0
            if pingValue then
                local ok, ping = pcall(function()
                    return math.floor(LocalPlayer:GetNetworkPing() * 1000)
                end)
                pingValue.Text = (ok and ping or 0) .. " ms"
            end
            if timeValue then
                timeValue.Text = os.date(opts.TimeFormat or "%H:%M")
            end
            if playersValue then
                playersValue.Text = #Players:GetPlayers() .. " / " .. Players.MaxPlayers
            end
            if uptimeValue then
                local elapsed = math.floor(os.clock() - started)
                uptimeValue.Text = string.format("%d:%02d", math.floor(elapsed / 60), elapsed % 60)
            end
            task.wait(1)
        end
    end)

    table.insert(panels, { Title = opts.SectionName or "Details", Icon = opts.TabIcon or "layout-grid", Frame = infoPanel })

    if strip then
        for _, page in ipairs(pages) do
            local panel = create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Visible = false,
                LayoutOrder = 3,
                Parent = list,
            })
            create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8),
                Parent = panel,
            })
            if type(page.Content) == "string" then
                local card = create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Theme.Surface2,
                    BorderSizePixel = 0,
                    LayoutOrder = 1,
                    Parent = panel,
                })
                card:SetAttribute("NoDrag", true)
                corner(card)
                stroke(card)
                padding(card, 14, 14, 12, 14)
                label({
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Text = page.Content,
                    TextSize = 13,
                    FontFace = Fonts.Regular,
                    TextColor3 = Theme.Muted,
                    TextWrapped = true,
                    TextTruncate = Enum.TextTruncate.None,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    Parent = card,
                })
            end
            if type(page.Entries) == "table" then
                for index, entry in ipairs(page.Entries) do
                    local card = create("Frame", {
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundColor3 = Theme.Surface2,
                        BorderSizePixel = 0,
                        LayoutOrder = index,
                        Parent = panel,
                    })
                    card:SetAttribute("NoDrag", true)
                    corner(card)
                    stroke(card)
                    padding(card, 14, 14, 12, 14)
                    create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 4),
                        Parent = card,
                    })
                    local head = create("Frame", {
                        Size = UDim2.new(1, 0, 0, 18),
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                        Parent = card,
                    })
                    label({
                        Size = UDim2.new(1, -70, 1, 0),
                        Text = entry.Title or entry.Version or "Update",
                        TextSize = 14,
                        Parent = head,
                    })
                    if entry.Date or entry.Tag then
                        local chip = create("Frame", {
                            AnchorPoint = Vector2.new(1, 0.5),
                            Position = UDim2.new(1, 0, 0.5, 0),
                            Size = UDim2.fromOffset(0, 20),
                            AutomaticSize = Enum.AutomaticSize.X,
                            BackgroundColor3 = Theme.Surface,
                            BorderSizePixel = 0,
                            Parent = head,
                        })
                        corner(chip, UDim.new(0, 5))
                        stroke(chip)
                        padding(chip, 8, 8)
                        label({
                            Size = UDim2.new(0, 0, 1, 0),
                            AutomaticSize = Enum.AutomaticSize.X,
                            Text = entry.Tag or entry.Date,
                            TextSize = 11,
                            TextColor3 = Theme.Muted,
                            TextTruncate = Enum.TextTruncate.None,
                            Parent = chip,
                        })
                    end
                    local body = entry.Content or entry.Body
                    if type(entry.Changes) == "table" then
                        body = "â€¢ " .. table.concat(entry.Changes, "\nâ€¢ ")
                    end
                    if body then
                        label({
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = Enum.AutomaticSize.Y,
                            Text = body,
                            TextSize = 13,
                            FontFace = Fonts.Regular,
                            TextColor3 = Theme.Muted,
                            TextWrapped = true,
                            TextTruncate = Enum.TextTruncate.None,
                            TextYAlignment = Enum.TextYAlignment.Top,
                            LayoutOrder = 2,
                            Parent = card,
                        })
                    end
                end
            end
            if type(page.Build) == "function" then
                safeCall(page.Build, panel)
                for _, child in ipairs(panel:GetChildren()) do
                    if child:IsA("GuiObject") then
                        child:SetAttribute("NoDrag", true)
                    end
                end
            end
            table.insert(panels, { Title = page.Name or page.Title or "Page", Icon = page.Icon, Frame = panel })
        end

        local buttons = {}
        local function select(index, instant)
            local changed = self._homeIndex ~= index
            self._homeIndex = index
            header.Visible = index == 1
            if index == 1 and changed and not instant then
                fadeCard(header)
            end
            for position, entry in ipairs(panels) do
                local on = position == index
                local frame = entry.Frame
                frame.Visible = on
                if on and changed and not instant then
                    for _, child in ipairs(frame:GetChildren()) do
                        if child:IsA("GuiObject") then
                            fadeCard(child)
                        end
                    end
                end
                local button = buttons[position]
                if button then
                    tween(button.Frame, { BackgroundTransparency = on and 0 or 1 }, 0.15)
                    tween(button.Stroke, { Transparency = on and 0 or 1 }, 0.15)
                    tween(button.Label, { TextColor3 = on and Theme.Text or Theme.Muted }, 0.15)
                    if button.Icon then
                        tween(button.Icon, { ImageColor3 = on and Theme.Accent or Theme.Muted }, 0.15)
                    end
                end
            end
        end
        for index, entry in ipairs(panels) do
            local button = create("TextButton", {
                Size = UDim2.fromOffset(0, 32),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = Theme.Surface2,
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                LayoutOrder = index,
                Parent = strip,
            })
            corner(button, UDim.new(0, 7))
            local buttonStroke = stroke(button, Theme.Stroke, 1)
            padding(button, 12, 12)
            local iconImage
            if entry.Icon then
                iconImage = create("ImageLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.fromOffset(14, 14),
                    BackgroundTransparency = 1,
                    ImageColor3 = Theme.Muted,
                    ScaleType = Enum.ScaleType.Fit,
                    Parent = button,
                })
                applyIcon(iconImage, entry.Icon)
            end
            local text = label({
                Position = UDim2.fromOffset(iconImage and 20 or 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                Text = entry.Title,
                TextSize = 13,
                TextColor3 = Theme.Muted,
                TextTruncate = Enum.TextTruncate.None,
                Parent = button,
            })
            buttons[index] = { Frame = button, Stroke = buttonStroke, Label = text, Icon = iconImage }
            button.MouseEnter:Connect(function()
                if self._homeIndex ~= index then
                    tween(button, { BackgroundTransparency = 0.4 }, 0.12)
                    tween(buttonStroke, { Transparency = 0.5 }, 0.12)
                end
            end)
            button.MouseLeave:Connect(function()
                if self._homeIndex ~= index then
                    tween(button, { BackgroundTransparency = 1 }, 0.2)
                    tween(buttonStroke, { Transparency = 1 }, 0.2)
                end
            end)
            button.MouseButton1Click:Connect(function()
                select(index)
            end)
        end
        select(1)
    end

    tab._order = 10
    self.Home = tab
    return tab
end

function Window:Tab(opts, icon)
    opts = normalize(opts, { Title = "Name", Description = "Desc" })
    if icon ~= nil and opts.Icon == nil then
        opts.Icon = icon
    end
    local tab = setmetatable({
        Name = opts.Name or "Tab",
        Window = self,
        _order = 0,
    }, Tab)

    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Surface2,
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = #self.Tabs + 1,
        Parent = self.TabList,
    })
    corner(button)
    local buttonStroke = stroke(button, Theme.Stroke, 1)
    tab._button = button

    local hasIcon = opts.Icon ~= nil
    if hasIcon then
        local iconImage = create("ImageLabel", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 12, 0.5, 0),
            Size = UDim2.fromOffset(16, 16),
            BackgroundTransparency = 1,
            ImageColor3 = Theme.Muted,
            ScaleType = Enum.ScaleType.Fit,
            Parent = button,
        })
        applyIcon(iconImage, opts.Icon)
        tab._icon = iconImage
    end
    tab._label = label({
        Position = UDim2.fromOffset(hasIcon and 36 or 14, 0),
        Size = UDim2.new(1, -(hasIcon and 44 or 22), 1, 0),
        Text = tab.Name,
        TextColor3 = Theme.Muted,
        Parent = button,
    })

    local page = create("Frame", {
        Name = tab.Name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.Content,
    })
    tab._page = page
    label({
        Position = UDim2.fromOffset(24, 20),
        Size = UDim2.new(1, -72, 0, 24),
        Text = tab.Name,
        TextSize = 22,
        Parent = page,
    })
    if opts.Desc then
        label({
            Position = UDim2.fromOffset(24, 44),
            Size = UDim2.new(1, -72, 0, 16),
            Text = opts.Desc,
            TextSize = 13,
            FontFace = Fonts.Regular,
            TextColor3 = Theme.Muted,
            Parent = page,
        })
    end
    local listTop = opts.Desc and 70 or 58
    local list = create("ScrollingFrame", {
        Position = UDim2.fromOffset(0, listTop),
        Size = UDim2.new(1, 0, 1, -listTop),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Parent = page,
    })
    padding(list, 24, 24, 2, 24)
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = list,
    })
    tab.List = list

    local empty = emptyState(page, opts.Icon or "layout-grid", opts.EmptyText or "Nothing here yet")
    local elementCount = 0
    list.ChildAdded:Connect(function(child)
        if child:IsA("GuiObject") then
            elementCount += 1
            empty.Visible = false
        end
    end)
    list.ChildRemoved:Connect(function(child)
        if child:IsA("GuiObject") then
            elementCount = math.max(elementCount - 1, 0)
            empty.Visible = elementCount <= 0
        end
    end)
    empty.Visible = true

    button.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            tween(button, { BackgroundTransparency = 0.4 }, 0.12)
            tween(buttonStroke, { Transparency = 0.5 }, 0.12)
        end
    end)
    button.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            tween(button, { BackgroundTransparency = 1 }, 0.2)
            tween(buttonStroke, { Transparency = 1 }, 0.2)
        end
    end)
    button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    tab._stroke = buttonStroke

    if not self._introDone then
        button.Visible = false
    end
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        task.defer(function()
            self:SelectTab(tab)
        end)
    end
    return tab
end

Window.CreateTab = Window.Tab

function Window:Dialog(opts)
    opts = normalize(opts, { Text = "Content", Message = "Content" })
    if self._dialog then
        self._dialog.Close()
    end
    local WIDTH = 300
    local PAD = 18

    local overlay = create("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 40,
        Parent = self.Body,
    })
    local card = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 10),
        Size = UDim2.fromOffset(WIDTH, 120),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 41,
        Parent = overlay,
    })
    corner(card, UDim.new(0, 10))
    local cardStroke = stroke(card, Theme.Stroke, 1)
    local cardScale = create("UIScale", { Scale = 0.94, Parent = card })
    local fading = {}

    local titleOffset = 0
    if opts.Icon then
        local holder, image = glowIcon(card, opts.Icon, Theme.Accent, UDim2.new(0, PAD, 0, PAD + 9))
        image.ImageTransparency = 1
        holder.ZIndex = 42
        image.ZIndex = 42
        table.insert(fading, { image, "ImageTransparency", 0 })
        titleOffset = 24
    end
    local title = label({
        Position = UDim2.fromOffset(PAD + titleOffset, PAD),
        Size = UDim2.new(1, -(PAD * 2 + titleOffset), 0, 18),
        Text = opts.Title or "Are you sure?",
        TextSize = 15,
        TextTransparency = 1,
        ZIndex = 42,
        Parent = card,
    })
    table.insert(fading, { title, "TextTransparency", 0 })

    local contentHeight = 0
    if opts.Content then
        local content = label({
            Position = UDim2.fromOffset(PAD, PAD + 24),
            Size = UDim2.new(1, -PAD * 2, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = opts.Content,
            TextSize = 13,
            FontFace = Fonts.Regular,
            TextColor3 = Theme.Muted,
            TextWrapped = true,
            TextTransparency = 1,
            TextTruncate = Enum.TextTruncate.None,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 42,
            Parent = card,
        })
        table.insert(fading, { content, "TextTransparency", 0 })
        contentHeight = math.max(content.TextBounds.Y, 16) + 6
        content:GetPropertyChangedSignal("TextBounds"):Connect(function()
            local newHeight = math.max(content.TextBounds.Y, 16) + 6
            if newHeight ~= contentHeight then
                contentHeight = newHeight
                card.Size = UDim2.fromOffset(WIDTH, PAD + 24 + contentHeight + 12 + 34 + PAD)
                local rowFrame = card:FindFirstChild("ButtonRow")
                if rowFrame then
                    rowFrame.Position = UDim2.fromOffset(PAD, PAD + 24 + contentHeight + 12)
                end
            end
        end)
    end

    local row = create("Frame", {
        Name = "ButtonRow",
        Position = UDim2.fromOffset(PAD, PAD + 24 + contentHeight + 12),
        Size = UDim2.new(1, -PAD * 2, 0, 34),
        BackgroundTransparency = 1,
        ZIndex = 42,
        Parent = card,
    })
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = row,
    })
    card.Size = UDim2.fromOffset(WIDTH, PAD + 24 + contentHeight + 12 + 34 + PAD)

    local dialog = {}
    local closed = false
    function dialog.Close()
        if closed then
            return
        end
        closed = true
        if self._dialog == dialog then
            self._dialog = nil
        end
        tween(overlay, { BackgroundTransparency = 1 }, 0.18)
        tween(card, { BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 8) }, 0.18, Enum.EasingStyle.Quint)
        tween(cardScale, { Scale = 0.96 }, 0.18, Enum.EasingStyle.Quint)
        tween(cardStroke, { Transparency = 1 }, 0.12)
        for _, entry in ipairs(fading) do
            tween(entry[1], { [entry[2]] = 1 }, 0.12)
        end
        task.delay(0.2, function()
            overlay:Destroy()
        end)
    end

    for index, spec in ipairs(opts.Buttons or {}) do
        local primary = spec.Variant == "Primary"
        local buttonFrame = create("TextButton", {
            Size = UDim2.fromOffset(0, 34),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = primary and Theme.Accent or Theme.Surface2,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ClipsDescendants = true,
            LayoutOrder = index,
            ZIndex = 43,
            Parent = row,
        })
        corner(buttonFrame, UDim.new(0, 7))
        local buttonStroke = stroke(buttonFrame, primary and Theme.Accent or Theme.Stroke, 1)
        padding(buttonFrame, 14, 14)
        local text = label({
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Text = spec.Title or spec.Name or "OK",
            TextSize = 13,
            TextColor3 = primary and Theme.AccentDark or Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextTransparency = 1,
            ZIndex = 44,
            Parent = buttonFrame,
        })
        local restBg = primary and 0.12 or 0
        local restStroke = primary and 0.4 or 0
        table.insert(fading, { buttonFrame, "BackgroundTransparency", restBg })
        table.insert(fading, { buttonStroke, "Transparency", restStroke })
        table.insert(fading, { text, "TextTransparency", 0 })
        buttonFrame.MouseEnter:Connect(function()
            if closed then
                return
            end
            if primary then
                tween(buttonFrame, { BackgroundTransparency = 0 }, 0.12)
                tween(buttonStroke, { Transparency = 0 }, 0.12)
            else
                tween(buttonStroke, { Color = Theme.StrokeHover }, 0.12)
            end
        end)
        buttonFrame.MouseLeave:Connect(function()
            if closed then
                return
            end
            if primary then
                tween(buttonFrame, { BackgroundTransparency = restBg }, 0.2)
                tween(buttonStroke, { Transparency = restStroke }, 0.2)
            else
                tween(buttonStroke, { Color = Theme.Stroke }, 0.2)
            end
        end)
        buttonFrame.MouseButton1Click:Connect(function()
            dialog.Close()
            safeCall(spec.Callback)
        end)
    end

    if opts.CloseOnBackdrop ~= false then
        overlay.MouseButton1Click:Connect(function()
            dialog.Close()
            safeCall(opts.OnCancel)
        end)
    end

    self._dialog = dialog
    tween(overlay, { BackgroundTransparency = 0.45 }, 0.25)
    tween(card, { BackgroundTransparency = 0, Position = UDim2.fromScale(0.5, 0.5) }, 0.3, Enum.EasingStyle.Quint)
    tween(cardStroke, { Transparency = 0 }, 0.25)
    tween(cardScale, { Scale = 1 }, 0.4, Enum.EasingStyle.Back)
    for _, entry in ipairs(fading) do
        tween(entry[1], { [entry[2]] = entry[3] }, 0.25)
    end
    return dialog
end

function Window:Confirm(opts)
    opts = normalize(opts, { Text = "Content", Message = "Content" })
    return self:Dialog({
        Title = opts.Title or "Are you sure?",
        Content = opts.Content,
        Icon = opts.Icon,
        OnCancel = opts.OnCancel,
        Buttons = {
            { Title = opts.CancelText or "Cancel", Callback = opts.OnCancel },
            { Title = opts.ConfirmText or "Confirm", Variant = "Primary", Callback = opts.Callback },
        },
    })
end

function Window:_listen(kind, handler, owner)
    local list = self._inputListeners[kind]
    table.insert(list, handler)
    local function disconnect()
        for index, entry in ipairs(list) do
            if entry == handler then
                table.remove(list, index)
                break
            end
        end
    end
    if owner then
        owner._listeners = owner._listeners or {}
        table.insert(owner._listeners, disconnect)
    end
    return disconnect
end

function Window:_indicatorY(tab)
    local list = self.TabList
    local scale = self.Scale.Scale
    return (tab._button.AbsolutePosition.Y - list.AbsolutePosition.Y + tab._button.AbsoluteSize.Y / 2) / scale
        + list.Position.Y.Offset
end

function Window:_placeIndicator(tab)
    local indicator = self.Indicator
    local targetY = self:_indicatorY(tab)
    if not indicator.Visible then
        indicator.Visible = true
        indicator.Position = UDim2.fromOffset(6, targetY)
        indicator.Size = UDim2.fromOffset(3, 0)
    end
    tween(indicator, { Position = UDim2.fromOffset(6, targetY), Size = UDim2.fromOffset(3, 18) }, 0.35, Enum.EasingStyle.Back)
end

function Window:SelectTab(tab)
    if self.CurrentTab == tab then
        return
    end
    local previous = self.CurrentTab
    self.CurrentTab = tab

    self:_settleTransition()
    local generation = (self._transitionGeneration or 0) + 1
    self._transitionGeneration = generation

    if previous then
        tween(previous._button, { BackgroundTransparency = 1 }, 0.2)
        tween(previous._stroke, { Transparency = 1 }, 0.2)
        tween(previous._label, { TextColor3 = Theme.Muted }, 0.2)
        if previous._icon then
            tween(previous._icon, { ImageColor3 = Theme.Muted }, 0.2)
        end
        local outLayer = self._outLayer
        previous._page.Parent = outLayer
        self._outPage = previous._page
        outLayer.GroupTransparency = 0
        outLayer.Position = UDim2.fromOffset(0, 0)
        outLayer.Visible = true
        tween(outLayer, { GroupTransparency = 1, Position = UDim2.fromOffset(0, -10) }, 0.18)
        task.delay(0.18, function()
            if self._transitionGeneration == generation then
                self:_settleOut()
            end
        end)
    end

    tween(tab._button, { BackgroundTransparency = 0 }, 0.2)
    tween(tab._stroke, { Transparency = 0 }, 0.2)
    tween(tab._label, { TextColor3 = Theme.Text }, 0.2)
    if tab._icon then
        tween(tab._icon, { ImageColor3 = Theme.Accent }, 0.2)
    end

    self:_placeIndicator(tab)

    local page = tab._page
    page.Position = UDim2.fromOffset(0, 0)
    page.Visible = true
    page.Parent = self._inLayer
    self._inPage = page
    fadeSlideIn(self._inLayer)
    task.delay(0.32, function()
        if self._transitionGeneration == generation then
            self:_settleIn()
        end
    end)
end

function Window:_settleOut()
    local page = self._outPage
    if page then
        page.Parent = self.Content
        page.Visible = false
        self._outPage = nil
    end
    self._outLayer.Visible = false
end

function Window:_settleIn()
    local page = self._inPage
    if page then
        page.Parent = self.Content
        page.Position = UDim2.fromOffset(0, 0)
        self._inPage = nil
    end
    self._inLayer.Visible = false
end

function Window:_settleTransition()
    self:_settleOut()
    self:_settleIn()
end

function Window:Toggle(open)
    if not self._introDone then
        return
    end
    if open == nil then
        open = not self.Open
    end
    if open == self.Open then
        return
    end
    self.Open = open
    if open then
        self.Root.Visible = true
        tween(self.Scale, { Scale = self._fitScale or 1 }, 0.4, Enum.EasingStyle.Back)
        tween(self.Body, { GroupTransparency = 0 }, 0.25)
        tween(self.BodyStroke, { Transparency = 0 }, 0.25)
        tween(self.Shadow, { ImageTransparency = 0.6 }, 0.3)
    else

        tween(self.Scale, { Scale = (self._fitScale or 1) * 0.94 }, 0.2, Enum.EasingStyle.Quint)
        tween(self.Body, { GroupTransparency = 1 }, 0.16)
        tween(self.BodyStroke, { Transparency = 1 }, 0.12)
        tween(self.Shadow, { ImageTransparency = 1 }, 0.16)
        task.delay(0.2, function()
            if not self.Open then
                self.Root.Visible = false
            end
        end)
    end
end

function Window:SetKeepOnScreen(enabled)
    self.KeepOnScreen = enabled ~= false
    if self.KeepOnScreen then
        self:_clampToScreen()
    end
end

function Window:SetKeybind(keyCode)
    self.Keybind = keyCode
    self._keyChipLabel.Text = keyName(keyCode)
end

function Window:Notify(opts)
    opts = normalize(opts, { Text = "Content", Message = "Content", Image = "Icon" })
    local duration = opts.Duration or 4
    local titleColor = NOTIFY_COLORS[opts.Type] or Theme.Text

    self._notifyOrder = self._notifyOrder + 1
    local outer = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = self._notifyOrder,
        Parent = self.NotifyHolder,
    })
    local slide = create("Frame", {
        Position = UDim2.fromOffset(320, 0),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = outer,
    })
    local shadow = create("ImageLabel", {
        Position = UDim2.fromOffset(-20, -20),
        Size = UDim2.new(1, 40, 1, 40),
        BackgroundTransparency = 1,
        Image = Assets.Shadow,
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0,
        Parent = slide,
    })
    local toast = create("CanvasGroup", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        GroupTransparency = 1,
        Parent = slide,
    })
    corner(toast, UDim.new(0, 10))
    local toastStroke = stroke(toast, Theme.Stroke)
    edgeHighlight(toast)
    glow(toast, UDim2.fromOffset(260, 120), UDim2.new(1, -10, 0, -10), 0.86, 90)

    local inner = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = toast,
    })
    padding(inner, 16, 16, 14, 24)

    local titleOffset = 0
    if opts.Icon then
        glowIcon(inner, opts.Icon, titleColor == Theme.Text and Theme.Accent or titleColor, UDim2.new(0, 0, 0, 8))
        titleOffset = 24
    end
    label({
        Position = UDim2.fromOffset(titleOffset, 0),
        Size = UDim2.new(1, -28 - titleOffset, 0, 16),
        Text = opts.Title or "Notification",
        TextSize = 14,
        TextColor3 = titleColor,
        Parent = inner,
    })
    local closeButton = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 6, 0, -5),
        Size = UDim2.fromOffset(24, 24),
        BackgroundTransparency = 1,
        Text = "Ã—",
        TextColor3 = Theme.Muted,
        TextSize = 22,
        FontFace = Fonts.Bold,
        AutoButtonColor = false,
        Parent = inner,
    })
    closeButton.MouseEnter:Connect(function()
        tween(closeButton, { TextColor3 = Theme.Text }, 0.15)
    end)
    closeButton.MouseLeave:Connect(function()
        tween(closeButton, { TextColor3 = Theme.Muted }, 0.2)
    end)
    if opts.Content then
        label({
            Position = UDim2.fromOffset(titleOffset, 21),
            Size = UDim2.new(1, -titleOffset, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = opts.Content,
            TextSize = 13,
            FontFace = Fonts.Regular,
            TextColor3 = Theme.Muted,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.None,
            TextYAlignment = Enum.TextYAlignment.Top,
            Parent = inner,
        })
    end

    local track = create("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 16, 1, -8),
        Size = UDim2.new(1, -32, 0, 3),
        BackgroundColor3 = Theme.Surface3,
        BorderSizePixel = 0,
        Parent = toast,
    })
    corner(track, UDim.new(1, 0))
    local progress = create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = track,
    })
    corner(progress, UDim.new(1, 0))

    task.defer(function()
        if outer.Parent then
            tween(outer, { Size = UDim2.new(1, 0, 0, toast.AbsoluteSize.Y) }, 0.3, Enum.EasingStyle.Quint)
        end
    end)
    tween(slide, { Position = UDim2.fromOffset(0, 0) }, 0.5, Enum.EasingStyle.Back)
    tween(toast, { GroupTransparency = 0 }, 0.3)
    tween(shadow, { ImageTransparency = 0.6 }, 0.4)
    tween(progress, { Size = UDim2.fromScale(0, 1) }, duration, Enum.EasingStyle.Linear)

    local dismissed = false
    local function dismiss()
        if dismissed then
            return
        end
        dismissed = true
        for index, entry in ipairs(self._toasts) do
            if entry == dismiss then
                table.remove(self._toasts, index)
                break
            end
        end
        tween(slide, { Position = UDim2.fromOffset(320, 0) }, 0.3, Enum.EasingStyle.Quint)
        tween(toast, { GroupTransparency = 1 }, 0.2)
        tween(toastStroke, { Transparency = 1 }, 0.15)
        tween(shadow, { ImageTransparency = 1 }, 0.2)
        task.delay(0.22, function()
            outer.ClipsDescendants = true
            tween(outer, { Size = UDim2.new(1, 0, 0, -4) }, 0.22, Enum.EasingStyle.Quint)
            task.delay(0.24, function()
                outer:Destroy()
            end)
        end)
    end

    task.delay(duration, dismiss)
    closeButton.MouseButton1Click:Connect(dismiss)

    table.insert(self._toasts, dismiss)
    while #self._toasts > self.MaxNotifications do
        local oldest = table.remove(self._toasts, 1)
        oldest()
    end

    return { Dismiss = dismiss }
end

function Window:Destroy()
    if self._destroyed then
        return
    end
    self._destroyed = true
    for index, entry in ipairs(Library.Windows) do
        if entry == self then
            table.remove(Library.Windows, index)
            break
        end
    end
    for _, connection in ipairs(self._connections) do
        connection:Disconnect()
    end
    self._connections = {}
    tween(self.Scale, { Scale = 0.9 }, 0.2)
    tween(self.Body, { GroupTransparency = 1 }, 0.2)
    tween(self.BodyStroke, { Transparency = 1 }, 0.12)
    tween(self.Shadow, { ImageTransparency = 1 }, 0.2)
    task.delay(0.22, function()
        self.Gui:Destroy()
    end)
end

local Airflow = Library
Airflow:LoadFont({ Name = "ValleySans" })

local Window = Airflow:CreateWindow({
    Name = "Floxy",
    LoadingSubtitle = "Blade Ball",
    ToggleUIKeybind = _G.config.ui_keybind or "RightShift",
})

local MainTab = Window:CreateTab({ Name = "Main", Desc = "Blade Ball", Icon = "swords" })
local DetectionsTab = Window:CreateTab({ Name = "Detections", Icon = "shield" })
local VisualTab = Window:CreateTab({ Name = "Visual", Desc = "esp and overlays", Icon = "eye" })
local noCdState = {}
local function ensureAbilityMod(name)
    local st = noCdState[name]
    if not st then
        st = {}
        noCdState[name] = st
    end
    if st.mod then return true end
    local shared = ReplicatedStorage:FindFirstChild("Shared")
    local abilities = shared and shared:FindFirstChild("Abilities")
    local m = abilities and abilities:FindFirstChild(name)
    if not m then return false end
    local ok, result = pcall(require, m)
    if ok and result then
        st.mod = result
        st.origCd = result.cooldown
        st.origCdr = result.cooldownReductionPerUpgrade
        return true
    end
    return false
end
local function applyNoCooldown(name)
    if not ensureAbilityMod(name) then return end
    local st = noCdState[name]
    pcall(function()
        st.mod.cooldown = 0
        st.mod.cooldownReductionPerUpgrade = 0
    end)
end
local function restoreCooldown(name)
    local st = noCdState[name]
    if not st or not st.mod then return end
    pcall(function()
        st.mod.cooldown = st.origCd
        st.mod.cooldownReductionPerUpgrade = st.origCdr
    end)
end
local function startNoCooldown(name)
    local st = noCdState[name]
    if not st then
        st = {}
        noCdState[name] = st
    end
    if st.conn then return end
    applyNoCooldown(name)
    st.conn = task.spawn(function()
        while st.conn do
            applyNoCooldown(name)
            task.wait(0.5)
        end
    end)
end
local function stopNoCooldown(name)
    local st = noCdState[name]
    if st then st.conn = nil end
    restoreCooldown(name)
end

local ExclusiveTab = Window:CreateTab({ Name = "Exclusive", Icon = "star" })

ExclusiveTab:CreateSection("No Cooldown")

ExclusiveTab:CreateToggle({
    Name = "Thunder Dash 0 Cooldown",
    CurrentValue = _G.config.thunder_dash_nocd or false,
    Flag = "ThunderDashNoCd",
    Callback = function(enabled)
        _G.config.thunder_dash_nocd = enabled
        if enabled then
            startNoCooldown("Thunder Dash")
        else
            stopNoCooldown("Thunder Dash")
        end
    end
})

ExclusiveTab:CreateToggle({
    Name = "Dash 0 Cooldown",
    CurrentValue = _G.config.dash_nocd or false,
    Flag = "DashNoCd",
    Callback = function(enabled)
        _G.config.dash_nocd = enabled
        if enabled then
            startNoCooldown("Dash")
        else
            stopNoCooldown("Dash")
        end
    end
})

ExclusiveTab:CreateToggle({
    Name = "Super Jump 0 Cooldown",
    CurrentValue = _G.config.super_jump_nocd or false,
    Flag = "SuperJumpNoCd",
    Callback = function(enabled)
        _G.config.super_jump_nocd = enabled
        if enabled then
            startNoCooldown("Super Jump")
        else
            stopNoCooldown("Super Jump")
        end
    end
})
local immortalState = { enabled = false, notify = false, heartbeatConnection = nil }
local immortalDesync = { originalCFrame = nil, originalVelocity = nil }
local immortalCache = { character = nil, hrp = nil, head = nil, headOffset = Vector3.new(0, 0, 0), aliveFolder = nil }
local immortalOldIndex = nil
local immortalConsts = {
    emptyCFrame = CFrame.new(),
    radius = math.clamp(tonumber(_G.config.immortal_radius) or 25, 0, 100),
    baseHeight = 5,
    riseHeight = math.clamp(tonumber(_G.config.immortal_height) or 30, 0, 60),
    cycleSpeed = 11.9,
    velocity = Vector3.new(1, 1, 1),
}
local function updateImmortalCache()
    local character = LocalPlayer.Character
    if character ~= immortalCache.character then
        immortalCache.character = character
        if character then
            immortalCache.hrp = character:FindFirstChild("HumanoidRootPart")
            immortalCache.head = character:FindFirstChild("Head")
            immortalCache.aliveFolder = workspace:FindFirstChild("Alive")
            if immortalCache.hrp then
                immortalCache.headOffset = Vector3.new(0, immortalCache.hrp.Size.Y * 0.5 + 0.5, 0)
            end
        else
            immortalCache.hrp = nil
            immortalCache.head = nil
        end
    end
end
local function isImmortalAlive()
    return immortalCache.aliveFolder and immortalCache.character and immortalCache.character.Parent == immortalCache.aliveFolder
end
local function calcOrbitPosition(hrp)
    local angle = math.random(-2147483647, 2147483647) * 1000
    local cycle = math.floor(tick() * immortalConsts.cycleSpeed) % 2
    local yOffset = cycle == 0 and 0 or immortalConsts.riseHeight
    local pos = hrp.Position
    local yBase = pos.Y - hrp.Size.Y * 0.5 + immortalConsts.baseHeight + yOffset
    return CFrame.new(
        pos.X + math.cos(angle) * immortalConsts.radius,
        yBase,
        pos.Z + math.sin(angle) * immortalConsts.radius
    )
end
local function performImmortalDesync()
    updateImmortalCache()
    if not immortalState.enabled or not immortalCache.hrp or not isImmortalAlive() then
        return
    end
    local hrp = immortalCache.hrp
    immortalDesync.originalCFrame = hrp.CFrame
    immortalDesync.originalVelocity = hrp.AssemblyLinearVelocity
    hrp.CFrame = calcOrbitPosition(hrp)
    hrp.AssemblyLinearVelocity = immortalConsts.velocity
    RunService.RenderStepped:Wait()
    hrp.CFrame = immortalDesync.originalCFrame
    hrp.AssemblyLinearVelocity = immortalDesync.originalVelocity
end
local function sendImmortalNotification(text)
    if immortalState.notify then
        Library:Notify({ Title = "Immortality", Content = text, Duration = 2 })
    end
end
local function setImmortality(enabled)
    if immortalState.enabled == enabled then return end
    immortalState.enabled = enabled
    getgenv().Walkablesemiimortal = enabled
    if enabled then
        if not immortalState.heartbeatConnection then
            immortalState.heartbeatConnection = RunService.Heartbeat:Connect(performImmortalDesync)
        end
    else
        if immortalState.heartbeatConnection then
            immortalState.heartbeatConnection:Disconnect()
            immortalState.heartbeatConnection = nil
        end
        immortalDesync.originalCFrame = nil
        immortalDesync.originalVelocity = nil
    end
    sendImmortalNotification(enabled and "ON" or "OFF")
end
LocalPlayer.CharacterRemoving:Connect(function()
    immortalCache.character = nil
    immortalCache.hrp = nil
    immortalCache.head = nil
    immortalCache.aliveFolder = nil
end)
immortalOldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if not immortalState.enabled or checkcaller() or key ~= "CFrame" or not immortalCache.hrp or not isImmortalAlive() then
        return immortalOldIndex(self, key)
    end
    if self == immortalCache.hrp then
        return immortalDesync.originalCFrame or immortalConsts.emptyCFrame
    elseif self == immortalCache.head and immortalDesync.originalCFrame then
        return immortalDesync.originalCFrame + immortalCache.headOffset
    end
    return immortalOldIndex(self, key)
end))

ExclusiveTab:CreateSection("Immortality")

ExclusiveTab:CreateToggle({
    Name = "Immortality",
    CurrentValue = _G.config.immortality or false,
    Flag = "Immortality",
    Callback = function(enabled)
        _G.config.immortality = enabled
        setImmortality(enabled)
    end
})

ExclusiveTab:CreateToggle({
    Name = "Immortal Notify",
    CurrentValue = _G.config.immortal_notify or false,
    Flag = "ImmortalNotify",
    Callback = function(enabled)
        _G.config.immortal_notify = enabled
        immortalState.notify = enabled
        getgenv().WalkablesemiimortalNotify = enabled
    end
})

ExclusiveTab:CreateSlider({
    Name = "Immortal Radius",
    Range = { 0, 100 },
    Increment = 1,
    CurrentValue = math.clamp(tonumber(_G.config.immortal_radius) or 25, 0, 100),
    Flag = "ImmortalRadius",
    Callback = function(value)
        immortalConsts.radius = value
        _G.config.immortal_radius = math.floor(value)
    end
})

ExclusiveTab:CreateSlider({
    Name = "Immortal Height",
    Range = { 0, 60 },
    Increment = 1,
    CurrentValue = math.clamp(tonumber(_G.config.immortal_height) or 30, 0, 60),
    Flag = "ImmortalHeight",
    Callback = function(value)
        immortalConsts.riseHeight = value
        _G.config.immortal_height = math.floor(value)
    end
})

local fGradients = {}
local function makeFMark(markW, markH, fontSize)
    local holder = Instance.new("Frame")
    holder.Name = "FloxyF"
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.fromOffset(markW, markH)
    local badge = Instance.new("Frame")
    badge.Name = "Badge"
    badge.BorderSizePixel = 0
    badge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    badge.Size = UDim2.fromScale(1, 1)
    badge.Parent = holder
    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 9)
    badgeCorner.Parent = badge
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Library.Theme.AccentDark),
        ColorSequenceKeypoint.new(0.55, Library.Theme.AccentDark:Lerp(Library.Theme.Accent, 0.5)),
        ColorSequenceKeypoint.new(1, Library.Theme.Accent),
    })
    grad.Rotation = 35
    grad.Parent = badge
    table.insert(fGradients, grad)
    local glowMark = Instance.new("TextLabel")
    glowMark.BackgroundTransparency = 1
    glowMark.Size = UDim2.fromScale(1, 1)
    glowMark.FontFace = Library.Fonts.Bold
    glowMark.TextSize = fontSize + 8
    glowMark.Text = "F"
    glowMark.TextColor3 = Library.Theme.Accent
    glowMark.TextTransparency = 0.55
    glowMark.TextXAlignment = Enum.TextXAlignment.Center
    glowMark.TextYAlignment = Enum.TextYAlignment.Center
    glowMark.Parent = holder
    local faceMark = Instance.new("TextLabel")
    faceMark.BackgroundTransparency = 1
    faceMark.Size = UDim2.fromScale(1, 1)
    faceMark.FontFace = Library.Fonts.Bold
    faceMark.TextSize = fontSize
    faceMark.Text = "F"
    faceMark.TextColor3 = Color3.fromRGB(255, 255, 255)
    faceMark.TextXAlignment = Enum.TextXAlignment.Center
    faceMark.TextYAlignment = Enum.TextYAlignment.Center
    faceMark.Parent = holder
    local faceStroke = Instance.new("UIStroke")
    faceStroke.Color = Library.Theme.AccentDark
    faceStroke.Thickness = 1.2
    faceStroke.Parent = faceMark
    return holder
end
local fSpinConn
fSpinConn = RunService.RenderStepped:Connect(function()
    local alive = false
    for i = #fGradients, 1, -1 do
        local g = fGradients[i]
        if g.Parent then
            alive = true
            g.Rotation = (tick() * 40) % 360
        else
            table.remove(fGradients, i)
        end
    end
    if not alive then
        fSpinConn:Disconnect()
    end
end)

local headerLogo
local headerTitle
pcall(function()
    local headerFrame = Window.Gui:FindFirstChild("Header", true)
    if headerFrame then
        for _, child in ipairs(headerFrame:GetChildren()) do
            if child:IsA("ImageLabel") then
                headerLogo = child
            elseif child:IsA("TextLabel") and child.Text == "Floxy" then
                headerTitle = child
            end
        end
    end
end)
if headerLogo then
    headerLogo.Visible = false
    local floxyMark = makeFMark(36, 34, 26)
    floxyMark.Position = UDim2.fromOffset(18, 27)
    floxyMark.Parent = headerLogo.Parent
end
if headerTitle then
    headerTitle.FontFace = Library.Fonts.Bold
    local titleConn
    titleConn = RunService.RenderStepped:Connect(function()
        if not headerTitle.Parent then
            titleConn:Disconnect()
            return
        end
        local blend = (math.sin(tick() * 2.2) + 1) / 2
        headerTitle.TextColor3 = Library.Theme.Accent:Lerp(Library.Theme.AccentDark, blend)
    end)
end

local loaderFrame
pcall(function()
    for _, child in ipairs(Window.Gui:GetChildren()) do
        if child:IsA("CanvasGroup") then
            for _, desc in ipairs(child:GetDescendants()) do
                if desc:IsA("TextLabel") and desc.Text == "Floxy" then
                    loaderFrame = child
                    break
                end
            end
        end
        if loaderFrame then break end
    end
end)
if loaderFrame then
    local loaderLogo
    local loaderTitle
    for _, desc in ipairs(loaderFrame:GetDescendants()) do
        if desc:IsA("ImageLabel") and desc.Parent ~= loaderFrame and desc.Parent:IsA("Frame") then
            loaderLogo = desc
        elseif desc:IsA("TextLabel") and desc.Text == "Floxy" then
            loaderTitle = desc
        end
    end
    if loaderLogo then
        loaderLogo.Visible = false
        local loaderMark = makeFMark(40, 40, 30)
        loaderMark.Position = UDim2.fromOffset(24, 26)
        loaderMark.Parent = loaderFrame
    end
    if loaderTitle then
        loaderTitle.FontFace = Library.Fonts.Bold
        local loadConn
        loadConn = RunService.RenderStepped:Connect(function()
            if not loaderTitle.Parent then
                loadConn:Disconnect()
                return
            end
            local blend = (math.sin(tick() * 2.2) + 1) / 2
            loaderTitle.TextColor3 = Library.Theme.Accent:Lerp(Library.Theme.AccentDark, blend)
        end)
    end
end


local Connections = {}
local BallHelper = {}
BallHelper.ball = {
    properties = {
        aerodynamic_time = tick(),
        last_warping = tick(),
        lerp_radians = 0,
        curving = tick(),
    }
}

local CurrentAnimTrack
local CurrentTarget

local _PARRY_PATCH = { ready = true }

local function findToken()
    for _, Function in getgc(true) do
        if type(Function) ~= 'function' then continue end
        local okSrc, src = pcall(function()
            return debug.info(Function, 's')
        end)
        if okSrc and src and tostring(src):find('PRY', 1, true) then
            local okUps, ups = pcall(function()
                return debug.getupvalues(Function)
            end)
            if okUps and type(ups) == 'table' then
                for _, value in ups do
                    if type(value) == 'function' then
                        return value
                    end
                end
            end
        end
    end
    return nil
end

local _token = findToken()


task.spawn(function()
    local tries = 0
    while not _token and tries < 40 do
        tries += 1
        task.wait(1)
        if not _token then _token = findToken() end
    end
end)

function _tokenize(_remote_uid)
    local time = tostring(math.floor(workspace:GetServerTimeNow() * 100))
    local key = _token(_remote_uid, 'TIME')
    local characters = table.create(#time)
    for index = 1, #time do
        characters[index] = string.char(bit32.bxor(
            (string.byte(time, index) + index) % 256,
            string.byte(key, (index - 1) % #key + 1)
        ))
    end
    return table.concat(characters)
end

local _reverted = {}
local _original = {}
local _captured = nil

function _is_valid(args)
    return #args == 8 and type(args[2]) == "string" and type(args[3]) == "string"
        and type(args[4]) == "number" and typeof(args[5]) == "CFrame"
        and type(args[6]) == "table" and type(args[7]) == "table"
        and type(args[8]) == "boolean"
end

function _hook(remote)
    if not _reverted[remote] then
        if not _original[getrawmetatable(remote)] then
            _original[getrawmetatable(remote)] = true
            local _meta = getrawmetatable(remote)
            setreadonly(_meta, false)
            local _old = _meta.__index
            _meta.__index = function(self, key)
                if (key == 'FireServer' and self:IsA('RemoteEvent'))
                or (key == 'InvokeServer' and self:IsA('RemoteFunction')) then
                    return function(_, ...)
                        local _arguments = {...}
                        if _is_valid(_arguments) then
                            if not _reverted[self] then
                                _reverted[self] = _arguments
                                _captured = { remote = self, args = _arguments }
                            end
                        end
                        return _old(self, key)(_, unpack(_arguments))
                    end
                end
                return _old(self, key)
            end
            setreadonly(_meta, true)
        end
    end
end

for _iterator, _remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
    if _remote:IsA('RemoteEvent') or _remote:IsA('RemoteFunction') then
        _hook(_remote)
    end
end


local function fireParryInput()
    if mouse1press and mouse1release then
        pcall(function()
            mouse1press()
            task.wait(0.03)
            mouse1release()
        end)
        return true
    end
    if mouse1click then
        pcall(function() mouse1click() end)
        return true
    end
    return false
end

function _PARRY_PATCH.fire(curveCFrame, screenPositions, mouseLocation)

    if not _token or not _reverted or next(_reverted) == nil then
        return fireParryInput()
    end
    if not curveCFrame then
        local cam = workspace.CurrentCamera
        curveCFrame = cam and cam.CFrame
    end
    if not curveCFrame then return false end
    local fired = false
    for _remote, _originalArgs in pairs(_reverted) do
        if type(_originalArgs) == "table" and _originalArgs[1] ~= nil then
            local okFire = pcall(function()
                _remote:FireServer(
                    _originalArgs[1],
                    _originalArgs[2],
                    _tokenize(_originalArgs[2]),
                    0.5,
                    curveCFrame,
                    screenPositions,
                    mouseLocation,
                    false
                )
            end)
            if okFire then fired = true end
        end
    end
    return fired
end

local recentlyPickedTargets = {}

local function pick_random_target()
    local livingPlayers = {}
    for _, char in workspace.Alive:GetChildren() do
        if char.Name ~= LocalPlayer.Name and char.PrimaryPart then
            table.insert(livingPlayers, char)
        end
    end

    if #livingPlayers == 0 then
        CurrentTarget = nil
        return
    end

    if #livingPlayers == 1 then
        CurrentTarget = livingPlayers[1]
        return
    end

    local candidates = {}
    for _, char in livingPlayers do
        if not recentlyPickedTargets[char.Name] then
            table.insert(candidates, char)
        end
    end

    if #candidates == 0 then
        recentlyPickedTargets = {}
        for _, char in livingPlayers do
            if not CurrentTarget or char.Name ~= CurrentTarget.Name then
                table.insert(candidates, char)
            end
        end
        if #candidates == 0 then
            candidates = livingPlayers
        end
    end

    local picked = candidates[math.random(1, #candidates)]
    recentlyPickedTargets[picked.Name] = true
    CurrentTarget = picked
end

workspace.Balls.ChildAdded:Connect(function(ball)
    if _G.config.random_target then
        pick_random_target()
    end
end)

workspace.Balls.ChildAdded:Connect(function(ball)
    task.spawn(function()
        if not ball:GetAttribute("realBall") then
            local zoomies = ball:WaitForChild("zoomies", 3)
            if not zoomies then return end
        end
        ball:GetAttributeChangedSignal("target"):Connect(function()
            if _G.config.random_target then
                pick_random_target()
            end
        end)
    end)
end)

for _, ball in workspace.Balls:GetChildren() do
    task.spawn(function()
        ball:GetAttributeChangedSignal("target"):Connect(function()
            if _G.config.random_target then
                pick_random_target()
            end
        end)
    end)
end

local function linear_predict(a, b, t)
    return a + (b - a) * t
end

function BallHelper.get_ball()
    for _, ball in workspace.Balls:GetChildren() do
        if ball:GetAttribute("realBall") then
            return ball
        end
    end
end

function BallHelper.get_balls()
    local balls = {}
    for _, ball in workspace.Balls:GetChildren() do
        if ball:GetAttribute("realBall") then
            table.insert(balls, ball)
        end
    end
    return balls
end

local function select_target_by_mouse()
    local livingPlayers = {}
    for _, char in workspace.Alive:GetChildren() do
        if char.Name ~= LocalPlayer.Name and char.PrimaryPart then
            table.insert(livingPlayers, char)
        end
    end

    local camera = workspace.CurrentCamera
    local mousePos = UserInputService:GetMouseLocation()
    local ray = camera:ScreenPointToRay(mousePos.X, mousePos.Y)
    local rayDir = ray.Direction

    local bestTarget
    local bestDot = -math.huge
    for _, char in livingPlayers do
        local toChar = (char.PrimaryPart.Position - camera.CFrame.Position).Unit
        local dot = rayDir:Dot(toChar)
        if dot > bestDot then
            bestDot = dot
            bestTarget = char
        end
    end

    CurrentTarget = bestTarget
    return bestTarget
end

function BallHelper.closest_player_by_mouse()
    if _G.config.random_target then
        if not CurrentTarget then
            pick_random_target()
        end
        return CurrentTarget
    end
    return select_target_by_mouse()
end

function BallHelper.getCurveCFrame()
    local camera = workspace.CurrentCamera
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return camera.CFrame end

    local method = _G.config.curve_method
    local target = CurrentTarget
    local targetPos = (target and target.PrimaryPart and target.PrimaryPart.Position)
        or (hrp.Position + camera.CFrame.LookVector * 1000)
    local toTarget = (targetPos - hrp.Position).Unit

    if method == "Dot" then
        return CFrame.lookAt(hrp.Position, targetPos + Vector3.new(0, 1.75, 0))
    elseif method == "Backwards" then
        return CFrame.new(hrp.Position, hrp.Position + (-toTarget) * 1000)
    elseif method == "Slow" then
        return CFrame.new(hrp.Position, hrp.Position + Vector3.new(0, -350, 0))
    elseif method == "Random" then
        return CFrame.new(hrp.Position, targetPos + Vector3.new(
            math.random(-1000, 1000),
            math.random(-350, 1000),
            math.random(-1000, 1000)
        ))
    else
        return camera.CFrame
    end
end

local parryActive = false
local parryCount = 0
function BallHelper.parry()
    if not _G.config.random_target then
        select_target_by_mouse()
    end

    local curveCFrame = BallHelper.getCurveCFrame()

    local mouseLoc
    if _G.config.random_target and CurrentTarget and CurrentTarget.PrimaryPart then
        local viewportPt = workspace.CurrentCamera:WorldToViewportPoint(CurrentTarget.PrimaryPart.Position)
        mouseLoc = { viewportPt.X, viewportPt.Y }
    else
        local mp = UserInputService:GetMouseLocation()
        mouseLoc = { mp.X, mp.Y }
    end

    local screenPositions = {}
    for _, char in workspace.Alive:GetChildren() do
        if char.PrimaryPart then
            local ok, screenPt = pcall(function()
                return workspace.CurrentCamera:WorldToScreenPoint(char.PrimaryPart.Position)
            end)
            if ok then
                screenPositions[char.Name] = screenPt
            end
        end
    end

    if _PARRY_PATCH and _PARRY_PATCH.ready then
        _PARRY_PATCH.fire(curveCFrame, screenPositions, mouseLoc)
    end

    if parryCount > 7 then return false end
    parryCount += 1
    task.delay(0.5, function() if parryCount > 0 then parryCount -= 1 end end)
end

function BallHelper.ball_curved()
    local props = BallHelper.ball.properties
    local ball = BallHelper.get_ball()
    if not ball then return false end

    local zoomies = ball:FindFirstChild("zoomies")
    if not zoomies then return false end

    local velocity = zoomies.VectorVelocity
    local velUnit = velocity.Unit
    local toMe = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local dotProduct = toMe:Dot(velUnit)
    local speed = velocity.Magnitude
    local speedFactor = math.min(speed / 100, 40)
    local accelDir = (velUnit - velocity).Unit
    local crossDot = toMe:Dot(accelDir)
    local dotDifference = dotProduct - crossDot
    local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local pingMs = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    local pingThreshold = 0.5 - (pingMs / 1000)
    local timeToImpact = distance / speed - (pingMs / 1000)
    local minDistance = 15 - math.min(distance / 1000, 15) + speedFactor
    local clampedDot = math.clamp(dotProduct, -1, 1)
    local angleRad = math.rad(math.asin(clampedDot))

    props.lerp_radians = linear_predict(props.lerp_radians, angleRad, 0.8)

    if speed > 100 and timeToImpact > pingMs / 10 then
        minDistance = math.max(minDistance - 15, 15)
    end

    if distance < minDistance then return false end
    if dotDifference < pingThreshold then return true end

    if props.lerp_radians < 0.018 then
        props.last_warping = tick()
    end

    if (tick() - props.last_warping) < (timeToImpact / 1.5) then return true end
    if (tick() - props.curving) < (timeToImpact / 1.5) then return true end

    return dotProduct < pingThreshold
end

function BallHelper.get_ball_properties(_)
    local ball = BallHelper.get_ball()
    if not ball then return end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end

    local zeroVel = Vector3.zero
    local toMe = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local dot = toMe:Dot(zeroVel.Unit)
    return { Velocity = zeroVel, Direction = toMe, Distance = distance, Dot = dot }
end

function BallHelper.players_properties()
    local target = CurrentTarget
    if not target or not target.PrimaryPart
        or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
        return false
    end

    local velocity = target.PrimaryPart.Velocity
    local direction = (LocalPlayer.Character.PrimaryPart.Position - target.PrimaryPart.Position).Unit
    local distance = (LocalPlayer.Character.PrimaryPart.Position - target.PrimaryPart.Position).Magnitude
    return { velocity = velocity, direction = direction, distance = distance }
end

local spamAccuracy = 0
function BallHelper.perfom_spam(args)
    local props = BallHelper.ball.properties
    local ball = BallHelper.get_ball()
    local target = CurrentTarget

    if not ball then return false end
    if not target or not target.PrimaryPart then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end

    local velocity = ball.AssemblyLinearVelocity
    local speed = velocity.Magnitude
    local toMe = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local dot = toMe:Dot(velocity.Unit)
    local targetPos = target.PrimaryPart.Position
    local targetDist = LocalPlayer:DistanceFromCharacter(targetPos)
    local maxDist = args.Ping + math.min(speed / 6, 95)

    if args.Entity_Properties.distance > maxDist then return spamAccuracy end
    if args.Ball_Properties.Distance > maxDist then return spamAccuracy end
    if targetDist > maxDist then return spamAccuracy end

    local maxSpeedClamp = 5 - math.min(speed / 5, 5)
    local maxDot = math.clamp(dot, -1, 0) * maxSpeedClamp
    spamAccuracy = maxDist - maxDot
    return spamAccuracy
end

local PlayerESPLabels = {}

local function qolPlayerNameVisibility()
    local function createBillboardGui(player)
        local character = player.Character
        while (not character) or (not character.Parent) do
            task.wait()
            character = player.Character
        end

        local head = character:WaitForChild("Head")
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 10
        label.TextWrapped = false
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = billboard

        PlayerESPLabels[player] = label

        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end

        local hbConn
        hbConn = RunService.Heartbeat:Connect(function()
            if not (character and character.Parent) then
                hbConn:Disconnect()
                billboard:Destroy()
                PlayerESPLabels[player] = nil
                return
            end

            if _G.config.ability_esp then
                label.Visible = true
                local ability = player:GetAttribute("EquippedAbility")
                if ability then
                    label.Text = player.DisplayName .. " [" .. ability .. "]"
                else
                    label.Text = player.DisplayName
                end
            else
                label.Visible = false
            end
        end)
    end

    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function()
                createBillboardGui(player)
            end)
            createBillboardGui(player)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            createBillboardGui(player)
        end)
    end)
end

qolPlayerNameVisibility()

_G.config.curve_method = "Camera"
local function calcSpeedDivisorBase(speed)
    return 2.2 + 0.9 * math.log(1 + speed / 80)
end

local SpeedDivisorMultiplier = 0.7 + (math.clamp(tonumber(_G.config.accuracy) or 100, 1, 100) - 1) * 0.0035353535353535

local Det = {
    Infinity_Active = false,
    DeathSlash_Active = false,
    TimeHole_Active = false,
    Pull_Active = false,
    Slashes_Active = false,
    Slashes_Count = 0,
    Forcefield_Active = false,
    Slashes_ParryDelay = _G.config.det_slashes_delay or 0.05,
    Slashes_MaxCount = _G.config.det_slashes_max or 36,
}
local DetNet = ReplicatedStorage:FindFirstChild("Packages")
DetNet = DetNet and DetNet:FindFirstChild("_Index")
DetNet = DetNet and DetNet:FindFirstChild("sleitnick_net@0.1.0")
DetNet = DetNet and DetNet:FindFirstChild("net")
ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(_, state)
    Det.Infinity_Active = state or false
end)
ReplicatedStorage.Remotes.DeathBall.OnClientEvent:Connect(function(_, state)
    Det.DeathSlash_Active = state or false
end)
pcall(function()
    ReplicatedStorage.Remotes.PlrPulled.OnClientEvent:Connect(function(a, b)
        if type(a) == "boolean" then
            Det.Pull_Active = a
        elseif type(b) == "boolean" then
            Det.Pull_Active = b
        else
            Det.Pull_Active = true
            task.delay(1.5, function() Det.Pull_Active = false end)
        end
    end)
end)
pcall(function()
    ReplicatedStorage.Remotes.PlrPulsed.OnClientEvent:Connect(function(a, b)
        if type(a) == "boolean" then
            Det.Pull_Active = a
        elseif type(b) == "boolean" then
            Det.Pull_Active = b
        else
            Det.Pull_Active = true
            task.delay(1.5, function() Det.Pull_Active = false end)
        end
    end)
end)
pcall(function()
    local function watchForcefield(c)
        c.AttributeChanged:Connect(function(attr)
            if attr == "PassiveLock_ForceField" then
                Det.Forcefield_Active = c:GetAttribute("PassiveLock_ForceField") == true
            end
        end)
    end
    if LocalPlayer.Character then watchForcefield(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(function(c)
        Det.Forcefield_Active = false
        watchForcefield(c)
    end)
end)
if DetNet then
    local TimeHoleActivate = DetNet:FindFirstChild("RE/TimeHoleActivate")
    local TimeHoleDeactivate = DetNet:FindFirstChild("RE/TimeHoleDeactivate")
    if TimeHoleActivate then
        TimeHoleActivate.OnClientEvent:Connect(function()
            Det.TimeHole_Active = true
        end)
    end
    if TimeHoleDeactivate then
        TimeHoleDeactivate.OnClientEvent:Connect(function()
            Det.TimeHole_Active = false
        end)
    end
end
if DetNet then
    local SlashesActivate = DetNet:FindFirstChild("RE/SlashesOfFuryActivate")
    local SlashesEnd = DetNet:FindFirstChild("RE/SlashesOfFuryEnd")
    local SlashesCatch = DetNet:FindFirstChild("RE/SlashesOfFuryCatch")
    local SlashesParry = DetNet:FindFirstChild("RE/SlashesOfFuryParry")
    if SlashesActivate then
        SlashesActivate.OnClientEvent:Connect(function()
            Det.Slashes_Active = true
            Det.Slashes_Count = 0
        end)
    end
    if SlashesEnd then
        SlashesEnd.OnClientEvent:Connect(function()
            Det.Slashes_Active = false
            Det.Slashes_Count = 0
        end)
    end
    if SlashesParry then
        SlashesParry.OnClientEvent:Connect(function()
            Det.Slashes_Count += 1
        end)
    end
    if SlashesCatch then
        SlashesCatch.OnClientEvent:Connect(function()
            if not _G.config.det_slashes then return end
            task.spawn(function()
                while Det.Slashes_Active and Det.Slashes_Count < Det.Slashes_MaxCount do
                    BallHelper.parry()
                    task.wait(Det.Slashes_ParryDelay)
                end
            end)
        end)
    end
end

local staffDetected = {}
local staffAction = _G.config.det_staff_action or "Notification"
local staffPlayerConn = nil
local function checkStaff(plr)
    if plr == LocalPlayer or staffDetected[plr.UserId] then return end
    local ok, rank = pcall(function() return plr:GetRankInGroup(12836673) end)
    if not ok or rank < 10 then return end
    staffDetected[plr.UserId] = true
    if staffAction == "Notification" then
        Library:Notify({ Title = "Staff Detected", Content = plr.Name .. " joined the server", Duration = 6 })
    elseif staffAction == "Kick" then
        LocalPlayer:Kick("Staff joined the server.")
    end
end
local function startStaffDetection()
    table.clear(staffDetected)
    for _, plr in pairs(Players:GetPlayers()) do
        task.spawn(checkStaff, plr)
    end
    if not staffPlayerConn then
        staffPlayerConn = Players.PlayerAdded:Connect(function(plr)
            if not _G.config.det_staff then return end
            task.spawn(checkStaff, plr)
        end)
    end
end
local function stopStaffDetection()
    if staffPlayerConn then
        staffPlayerConn:Disconnect()
        staffPlayerConn = nil
    end
    table.clear(staffDetected)
end

local lastParryFix = 0
local fixSwordAPI = nil
local fixAnimCache = {}
local fixLastPlayed = 0
local fixBypassCd = false
task.spawn(function()
    pcall(function()
        local shared = ReplicatedStorage:WaitForChild("Shared", 5)
        if shared then fixSwordAPI = shared:WaitForChild("SwordAPI", 5) end
    end)
end)
local function getFixParryAnimation()
    if not fixSwordAPI then return nil end
    local char = LocalPlayer.Character
    if not char then return nil end
    local currentSword = char:GetAttribute("CurrentlyEquippedSword")
    if not currentSword then return fixSwordAPI.Collection.Default:FindFirstChild("GrabParry") end
    if fixAnimCache[currentSword] then return fixAnimCache[currentSword] end
    local ok, swordData = pcall(function()
        return ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(currentSword)
    end)
    if not ok or type(swordData) ~= "table" then
        fixAnimCache[currentSword] = fixSwordAPI.Collection.Default:FindFirstChild("GrabParry")
        return fixAnimCache[currentSword]
    end
    for _, obj in pairs(fixSwordAPI.Collection:GetChildren()) do
        if obj.Name == swordData.AnimationType then
            local anim = obj:FindFirstChild("GrabParry") or obj:FindFirstChild("Grab")
            if anim then fixAnimCache[currentSword] = anim return anim end
        end
    end
    fixAnimCache[currentSword] = fixSwordAPI.Collection.Default:FindFirstChild("GrabParry")
    return fixAnimCache[currentSword]
end
local function playFixParryOnce()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end
    local animation = getFixParryAnimation()
    if not animation then return end
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        if track.Name == "GrabParry" or track.Name == "Grab" then
            track.TimePosition = 0
            track:Stop(track:GetAttribute("StopFadeTime") or 0.1)
        elseif track.Name == "SuccessParry" or track.Name == "Success" then
            track:Stop(track:GetAttribute("StopFadeTime") or 0.1)
        end
    end
    local grabTrack = animator:LoadAnimation(animation)
    grabTrack:Play(grabTrack:GetAttribute("PlayFadeTime") or 0, grabTrack:GetAttribute("PlayWeight") or 1, grabTrack:GetAttribute("PlaySpeed") or 1)
end
local function playParryFix()
    if (os.clock() - fixLastPlayed) >= 0.1 or fixBypassCd then
        fixLastPlayed = os.clock()
        fixBypassCd = false
        pcall(playFixParryOnce)
    end
end
pcall(function()
    ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
        fixBypassCd = true
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                if track.Name == "GrabParry" or track.Name == "Grab" then
                    track:Stop(track:GetAttribute("StopFadeTime") or 0.1)
                end
            end
        end
    end)
end)

local BallStatsState = {
    gui = nil,
    frame = nil,
    vlog = nil,
    plog = nil,
    connection = nil,
    peak_velocity = 0
}
local function destroy_ball_stats()
    if BallStatsState.connection then
        BallStatsState.connection:Disconnect()
        BallStatsState.connection = nil
    end
    if BallStatsState.gui then
        pcall(function()
            BallStatsState.gui:Destroy()
        end)
    end
    BallStatsState.gui = nil
    BallStatsState.frame = nil
    BallStatsState.vlog = nil
    BallStatsState.plog = nil
    BallStatsState.peak_velocity = 0
end
local function create_ball_stats_gui()
    if BallStatsState.gui then return end
    local OverlayGui = Instance.new("ScreenGui")
    OverlayGui.Name = "FloxyBallMetrics"
    OverlayGui.ResetOnSpawn = false
    OverlayGui.IgnoreGuiInset = true
    OverlayGui.DisplayOrder = 99
    OverlayGui.Parent = LocalPlayer.PlayerGui
    local Panel = Instance.new("Frame")
    Panel.Name = "Panel"
    Panel.Size = UDim2.new(0, 184, 0, 96)
    Panel.Position = UDim2.new(0, 20, 0.5, -48)
    Panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Panel.BorderSizePixel = 0
    Panel.Active = true
    Panel.Parent = OverlayGui
    local PanelCorner = Instance.new("UICorner")
    PanelCorner.CornerRadius = UDim.new(0, 13)
    PanelCorner.Parent = Panel
    local PanelStroke = Instance.new("UIStroke")
    PanelStroke.Color = Color3.fromRGB(125, 211, 252)
    PanelStroke.Transparency = 0.55
    PanelStroke.Thickness = 1
    PanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    PanelStroke.Parent = Panel
    local PanelGradient = Instance.new("UIGradient")
    PanelGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(30, 64, 175)),
        ColorSequenceKeypoint.new(0.30, Color3.fromRGB(19, 30, 53)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(13, 17, 24))
    }
    PanelGradient.Rotation = 90
    PanelGradient.Parent = Panel
    local BoltIcon = Instance.new("ImageLabel")
    BoltIcon.Name = "BoltIcon"
    BoltIcon.Size = UDim2.fromOffset(18, 18)
    BoltIcon.Position = UDim2.new(0, 12, 0, 9)
    BoltIcon.BackgroundTransparency = 1
    BoltIcon.BorderSizePixel = 0
    BoltIcon.Image = "rbxassetid://100394875638012"
    BoltIcon.ImageColor3 = Color3.fromRGB(125, 211, 252)
    BoltIcon.ScaleType = Enum.ScaleType.Fit
    BoltIcon.Parent = Panel
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -46, 0, 22)
    TitleLabel.Position = UDim2.new(0, 33, 0, 7)
    TitleLabel.FontFace = Font.new("rbxasset://fonts/families/SFPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TitleLabel.Text = "Ball Stats"
    TitleLabel.TextColor3 = Color3.fromRGB(125, 211, 252)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
    TitleLabel.Parent = Panel
    local Divider = Instance.new("Frame")
    Divider.Name = "Divider"
    Divider.Size = UDim2.new(1, -20, 0, 1)
    Divider.Position = UDim2.new(0, 10, 0, 34)
    Divider.BackgroundColor3 = Color3.fromRGB(125, 211, 252)
    Divider.BackgroundTransparency = 0.7
    Divider.BorderSizePixel = 0
    Divider.Parent = Panel
    local VelocityLabel = Instance.new("TextLabel")
    VelocityLabel.BackgroundTransparency = 1
    VelocityLabel.Size = UDim2.new(0, 88, 0, 24)
    VelocityLabel.Position = UDim2.new(0, 14, 0, 42)
    VelocityLabel.FontFace = Font.new("rbxasset://fonts/families/SFPro.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    VelocityLabel.Text = "Speed"
    VelocityLabel.TextColor3 = Color3.fromRGB(148, 163, 195)
    VelocityLabel.TextSize = 14
    VelocityLabel.TextXAlignment = Enum.TextXAlignment.Left
    VelocityLabel.TextYAlignment = Enum.TextYAlignment.Center
    VelocityLabel.Parent = Panel
    local SpeedVal = Instance.new("TextLabel")
    SpeedVal.Name = "SpeedValue"
    SpeedVal.BackgroundTransparency = 1
    SpeedVal.Size = UDim2.new(0, 64, 0, 24)
    SpeedVal.Position = UDim2.new(1, -78, 0, 42)
    SpeedVal.FontFace = Font.new("rbxasset://fonts/families/SFPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    SpeedVal.Text = "0.0"
    SpeedVal.TextColor3 = Color3.fromRGB(125, 211, 252)
    SpeedVal.TextSize = 16
    SpeedVal.TextXAlignment = Enum.TextXAlignment.Right
    SpeedVal.TextYAlignment = Enum.TextYAlignment.Center
    SpeedVal.Parent = Panel
    local PeakLabel = Instance.new("TextLabel")
    PeakLabel.BackgroundTransparency = 1
    PeakLabel.Size = UDim2.new(0, 88, 0, 24)
    PeakLabel.Position = UDim2.new(0, 14, 0, 67)
    PeakLabel.FontFace = Font.new("rbxasset://fonts/families/SFPro.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    PeakLabel.Text = "Peak"
    PeakLabel.TextColor3 = Color3.fromRGB(148, 163, 195)
    PeakLabel.TextSize = 14
    PeakLabel.TextXAlignment = Enum.TextXAlignment.Left
    PeakLabel.TextYAlignment = Enum.TextYAlignment.Center
    PeakLabel.Parent = Panel
    local PeakVal = Instance.new("TextLabel")
    PeakVal.Name = "PeakValue"
    PeakVal.BackgroundTransparency = 1
    PeakVal.Size = UDim2.new(0, 64, 0, 24)
    PeakVal.Position = UDim2.new(1, -78, 0, 67)
    PeakVal.FontFace = Font.new("rbxasset://fonts/families/SFPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    PeakVal.Text = "0.0"
    PeakVal.TextColor3 = Color3.fromRGB(125, 211, 252)
    PeakVal.TextSize = 16
    PeakVal.TextXAlignment = Enum.TextXAlignment.Right
    PeakVal.TextYAlignment = Enum.TextYAlignment.Center
    PeakVal.Parent = Panel
    Panel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local dragStart = input.Position
            local startPos = Panel.Position
            local moving = true
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    moving = false
                end
            end)
            local dragConnection
            dragConnection = UserInputService.InputChanged:Connect(function(changedInput)
                if not moving then
                    dragConnection:Disconnect()
                    return
                end
                if changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput.UserInputType == Enum.UserInputType.Touch then
                    local delta = changedInput.Position - dragStart
                    Panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
        end
    end)
    BallStatsState.gui = OverlayGui
    BallStatsState.frame = Panel
    BallStatsState.vlog = SpeedVal
    BallStatsState.plog = PeakVal
end
local function enable_ball_stats()
    create_ball_stats_gui()
    if BallStatsState.connection then
        BallStatsState.connection:Disconnect()
        BallStatsState.connection = nil
    end
    local elapsed = 0
    BallStatsState.connection = RunService.RenderStepped:Connect(function(dt)
        elapsed += dt
        if elapsed < 0.05 then return end
        elapsed = 0
        if not BallStatsState.frame or not BallStatsState.vlog or not BallStatsState.plog then return end
        local ball = BallHelper.get_ball()
        local speed = 0
        if ball then
            local velocity = ball.AssemblyLinearVelocity or Vector3.new()
            if typeof(velocity) == "Vector3" then
                speed = velocity.Magnitude
            end
        end
        BallStatsState.vlog.Text = string.format("%.1f", speed)
        if speed > BallStatsState.peak_velocity then
            BallStatsState.peak_velocity = speed
            BallStatsState.plog.Text = string.format("%.1f", BallStatsState.peak_velocity)
        end
    end)
end

local cosmeticsCleanup = {}
local cosmeticsCharConn = nil
local function applyKorblox(character)
    local leg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightLeg")
    if not leg then return end
    if leg:FindFirstChild("KorbloxMesh") then return end
    for _, child in ipairs(leg:GetChildren()) do
        if child:IsA("SpecialMesh") then child:Destroy() end
    end
    local mesh = Instance.new("SpecialMesh")
    mesh.Name = "KorbloxMesh"
    mesh.MeshId = "rbxassetid://902942096"
    mesh.TextureId = "rbxassetid://902843398"
    mesh.Offset = Vector3.new(0, 0.7, 0)
    mesh.Parent = leg
end
local function restoreKorblox(character)
    local leg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightLeg")
    if not leg then return end
    for _, child in ipairs(leg:GetChildren()) do
        if child:IsA("SpecialMesh") then child:Destroy() end
    end
end
local function applyHeadless(character)
    local head = character:FindFirstChild("Head")
    if not head then return end
    if cosmeticsCleanup.headTransparency == nil then
        cosmeticsCleanup.headTransparency = head.Transparency
    end
    local face = head:FindFirstChildOfClass("Decal")
    if face then
        cosmeticsCleanup.faceDecalId = face.Texture
        cosmeticsCleanup.faceDecalName = face.Name
    end
    head.Transparency = 1
    for _, child in ipairs(head:GetChildren()) do
        if child:IsA("Decal") or child.Name == "face" then
            child.Transparency = 1
        elseif child:IsA("SpecialMesh") or child:IsA("DataModelMesh") then
            if not child:GetAttribute("OriginalScale") then
                child:SetAttribute("OriginalScale", child.Scale)
                child.Scale = Vector3.new(0, 0, 0)
            end
        end
    end
end
local function restoreHeadless(character)
    local head = character:FindFirstChild("Head")
    if not head then return end
    if cosmeticsCleanup.headTransparency ~= nil then
        head.Transparency = cosmeticsCleanup.headTransparency
    end
    if cosmeticsCleanup.faceDecalId then
        local decal = head:FindFirstChildOfClass("Decal") or Instance.new("Decal", head)
        decal.Name = cosmeticsCleanup.faceDecalName or "face"
        decal.Texture = cosmeticsCleanup.faceDecalId
        decal.Face = Enum.NormalId.Front
    end
    for _, child in ipairs(head:GetChildren()) do
        if child:IsA("Decal") or child.Name == "face" then
            child.Transparency = 0
        elseif child:IsA("SpecialMesh") or child:IsA("DataModelMesh") then
            local orig = child:GetAttribute("OriginalScale")
            if orig then
                child.Scale = orig
                child:SetAttribute("OriginalScale", nil)
            end
        end
    end
end
local function applyCosmetics(character)
    if not character then return end
    applyKorblox(character)
    applyHeadless(character)
end

MainTab:CreateSection("Automatic")

MainTab:CreateToggle({
    Name = "Auto Parry",
    CurrentValue = _G.config.auto_parry or false,
    Flag = "AutoParry",
    Callback = function(enabled)
        _G.config.auto_parry = enabled
        if enabled then
            Connections.auto_parry = RunService.PreSimulation:Connect(function()
                if _G.triggerbot then return end
                if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end

                local props = BallHelper.ball.properties
                local realBall = BallHelper.get_ball()
                local allBalls = BallHelper.get_balls()

                for _, ball in allBalls do
                    if not ball then return end

                    local zoomies = ball:FindFirstChild("zoomies")
                    if not zoomies then return end

                    ball:GetAttributeChangedSignal("target"):Once(function()
                        parryActive = false
                        if _G.config.random_target then
                            pick_random_target()
                        end
                    end)

                    if parryActive then return end

                    local ballTarget = ball:GetAttribute("target")
                    local realBallTarget = realBall:GetAttribute("target")
                    local velocity = zoomies.VectorVelocity
                    local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
                    local pingMs = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
                    local pingThreshold = math.clamp(pingMs / 8, 4, 25)
                    local rawSpeed = velocity.Magnitude
                    local speedDivisor = calcSpeedDivisorBase(rawSpeed) * SpeedDivisorMultiplier
                    local speedFactor = 1
                    if rawSpeed > 200 then
                        speedFactor = 1 + math.min((rawSpeed - 200) / 1000, 0.3)
                    end
                    local targetDistance = pingThreshold + math.max(rawSpeed / speedDivisor, 9.5) * speedFactor
                    local isCurving = BallHelper.ball_curved()

                    if ball:FindFirstChild("AeroDynamicSlashVFX") then
                        Debris:AddItem(ball.AeroDynamicSlashVFX, 0)
                        props.aerodynamic_time = tick()
                    end

                    if workspace.Runtime:FindFirstChild("Tornado") then
                        local tornadoTime = workspace.Runtime.Tornado:GetAttribute("TornadoTime") or 1
                        if (tick() - props.aerodynamic_time) < tornadoTime + 0.314159 then
                            return
                        end
                    end

                    if realBallTarget == LocalPlayer.Name and isCurving then return end

                    if _G.config.det_infinity and Det.Infinity_Active then return end
                    if _G.config.det_deathslash and Det.DeathSlash_Active then return end
                    if _G.config.det_timehole and Det.TimeHole_Active then return end
                    if _G.config.det_pull and Det.Pull_Active then return end
                    if _G.config.det_singularity and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and LocalPlayer.Character.PrimaryPart:FindFirstChild("SingularityCape") then return end
                    if _G.config.det_slashes and Det.Slashes_Active then return end
                    if _G.config.det_forcefield and Det.Forcefield_Active then return end

                    if ballTarget == LocalPlayer.Name and distance <= targetDistance then
                        if _G.config.animfix_parry and tick() - lastParryFix > 0.5 then
                            lastParryFix = tick()
                            playParryFix()
                        end
                        BallHelper.parry(_G.config.curve_method)
                        parryActive = true
                    end

                    local startTime = tick()
                    repeat
                        RunService.PreSimulation:Wait()
                    until (tick() - startTime) >= 1 or not parryActive
                    parryActive = false
                end
            end)
        else
            if Connections.auto_parry then
                Connections.auto_parry:Disconnect()
                Connections.auto_parry = nil
            end
        end
    end
})

DetectionsTab:CreateSection("Detections")

local antiPhantomActive = false

DetectionsTab:CreateToggle({
    Name = "Anti Phantom",
    CurrentValue = _G.config.anti_phantom or false,
    Flag = "AntiPhantom",
    Callback = function(enabled)
        _G.config.anti_phantom = enabled
        if enabled then
            Connections.anti_phantom = workspace.Runtime.ChildAdded:Connect(function(part)
                local character = LocalPlayer.Character
                if not character then return end
                if not (part.Name:lower() == "maxtransmission" or part.Name == "transmissionpart") then return end

                local weld = part:FindFirstChildWhichIsA("WeldConstraint")
                if not weld then return end

                for _, ball in workspace.Balls:GetChildren() do
                    if not ball:FindFirstChild("zoomies") then continue end
                    if antiPhantomActive then continue end

                    antiPhantomActive = true
                    local cancelled = false

                    task.spawn(function()
                        local startTime = tick()
                        while tick() - startTime < 1 and ball.Parent and not cancelled do
                            task.wait()
                            cloneref(game:GetService("TweenService")):Create(
                                character.HumanoidRootPart,
                                TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                                { CFrame = ball.CFrame * CFrame.new(0, 0, -3) }
                            ):Play()
                        end
                        antiPhantomActive = false
                    end)

                    ball:GetAttributeChangedSignal("target"):Once(function()
                        cancelled = true
                        antiPhantomActive = false
                    end)
                end
            end)
        else
            if Connections.anti_phantom then
                Connections.anti_phantom:Disconnect()
                Connections.anti_phantom = nil
            end
            antiPhantomActive = false
        end
    end
})


DetectionsTab:CreateToggle({
    Name = "Staff Detection",
    CurrentValue = _G.config.det_staff or false,
    Flag = "DetStaff",
    Callback = function(enabled)
        _G.config.det_staff = enabled
        if enabled then
            startStaffDetection()
        else
            stopStaffDetection()
        end
    end,
})

DetectionsTab:CreateDropdown({
    Name = "Staff Action",
    Options = { "Notification", "Kick" },
    CurrentOption = _G.config.det_staff_action or "Notification",
    Flag = "DetStaffAction",
    Callback = function(value)
        staffAction = value
        _G.config.det_staff_action = value
    end,
})

DetectionsTab:CreateToggle({
    Name = "Infinity Detection",
    CurrentValue = _G.config.det_infinity or false,
    Flag = "DetInfinity",
    Callback = function(enabled)
        _G.config.det_infinity = enabled
    end,
})

DetectionsTab:CreateToggle({
    Name = "DeathSlash Detection",
    CurrentValue = _G.config.det_deathslash or false,
    Flag = "DetDeathSlash",
    Callback = function(enabled)
        _G.config.det_deathslash = enabled
    end,
})

DetectionsTab:CreateToggle({
    Name = "TimeHole Detection",
    CurrentValue = _G.config.det_timehole or false,
    Flag = "DetTimeHole",
    Callback = function(enabled)
        _G.config.det_timehole = enabled
    end,
})

DetectionsTab:CreateToggle({
    Name = "Pull Detection",
    CurrentValue = _G.config.det_pull or false,
    Flag = "DetPull",
    Callback = function(enabled)
        _G.config.det_pull = enabled
    end,
})

DetectionsTab:CreateToggle({
    Name = "Singularity Detection",
    CurrentValue = _G.config.det_singularity or false,
    Flag = "DetSingularity",
    Callback = function(enabled)
        _G.config.det_singularity = enabled
    end,
})

DetectionsTab:CreateToggle({
    Name = "Slashes Detection",
    CurrentValue = _G.config.det_slashes or false,
    Flag = "DetSlashes",
    Callback = function(enabled)
        _G.config.det_slashes = enabled
    end,
})

DetectionsTab:CreateSlider({
    Name = "Slashes Parry Delay",
    Range = { 0.05, 0.25 },
    Increment = 0.01,
    CurrentValue = _G.config.det_slashes_delay or 0.05,
    Flag = "DetSlashesDelay",
    Callback = function(value)
        Det.Slashes_ParryDelay = value
        _G.config.det_slashes_delay = value
    end,
})

DetectionsTab:CreateSlider({
    Name = "Slashes Max Parry",
    Range = { 1, 36 },
    Increment = 1,
    CurrentValue = _G.config.det_slashes_max or 36,
    Flag = "DetSlashesMax",
    Callback = function(value)
        Det.Slashes_MaxCount = value
        _G.config.det_slashes_max = value
    end,
})

DetectionsTab:CreateToggle({
    Name = "Forcefield Detection",
    CurrentValue = _G.config.det_forcefield or false,
    Flag = "DetForcefield",
    Callback = function(enabled)
        _G.config.det_forcefield = enabled
    end,
})

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, parrier)
    if parrier.Parent and parrier.Parent ~= LocalPlayer.Character then
        if parrier.Parent.Parent ~= workspace.Alive then return end
    end

    local ball = BallHelper.get_ball()
    if not ball then return end
    if not CurrentTarget or not CurrentTarget.PrimaryPart then return end

    local distToTarget = (LocalPlayer.Character.PrimaryPart.Position - CurrentTarget.PrimaryPart.Position).Magnitude
    local distToBall = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local toBall = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local dot = toBall:Dot(ball.AssemblyLinearVelocity.Unit)
    local isCurving = BallHelper.ball_curved()

    if distToTarget < 15 and distToBall < 15 and dot > -0.25 then
        if isCurving then
            BallHelper.parry(_G.config.curve_method)
        end
    end

    if not CurrentAnimTrack then return end
    CurrentAnimTrack:Stop()
end)

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if LocalPlayer.Character.Parent ~= workspace.Alive then return end
    if not CurrentAnimTrack then return end
    CurrentAnimTrack:Stop()
end)

workspace.Balls.ChildRemoved:Connect(function(_)
    parryCount = 0
    parryActive = false
    CurrentTarget = nil
    recentlyPickedTargets = {}
    if Connections.target_change then
        Connections.target_change:Disconnect()
        Connections.target_change = nil
    end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, parrier)
    local myHrp = LocalPlayer.Character.PrimaryPart
    local ball = BallHelper.get_ball()
    if not ball then return end

    local zoomies = ball:FindFirstChild("zoomies")
    if not zoomies then return end

    local speed = zoomies.VectorVelocity.Magnitude
    local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local velocity = zoomies.VectorVelocity
    local velUnit = velocity.Unit
    local toMe = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    toMe:Dot(velUnit)

    local pingMs = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    local speedFactor = math.min(speed / 100, 40)
    local timeToImpact = distance / speed - (pingMs / 1000)
    local isFast = speed > 100
    local minDistance = 15 - math.min(distance / 1000, 15) + speedFactor

    if isFast and timeToImpact > pingMs / 10 then
        minDistance = math.max(minDistance - 15, 15)
    end

    if parrier ~= myHrp and distance > minDistance then
        BallHelper.ball.properties.curving = tick()
    end
end)

local savedAcc = math.clamp(tonumber(_G.config.accuracy) or 100, 1, 100)

MainTab:CreateSlider({
    Name = "Parry Accuracy",
    Range = { 1, 100 },
    Increment = 1,
    CurrentValue = savedAcc,
    Flag = "Accuracy",
    Callback = function(value)
        task.spawn(function()
            SpeedDivisorMultiplier = 0.7 + (value - 1) * 0.0035353535353535
            _G.config.accuracy = math.floor(value)
        end)
    end
})

local CurveMethodDropdown = MainTab:CreateDropdown({
    Name = "Curve Method",
    Options = { "Camera", "Dot", "Backwards", "Slow", "Random" },
    CurrentOption = _G.config.curve_method or "Camera",
    Flag = "CurveMethod",
    Callback = function(value)
        task.spawn(function()
            _G.config.curve_method = value
        end)
    end
})

MainTab:CreateToggle({
    Name = "Random Target",
    CurrentValue = _G.config.random_target or false,
    Flag = "RandomTarget",
    Callback = function(enabled)
        task.spawn(function()
            _G.config.random_target = enabled
            CurrentTarget = nil
            recentlyPickedTargets = {}
            if enabled then
                pick_random_target()
            end
        end)
    end
})

MainTab:CreateToggle({
    Name = "Animation Fix",
    CurrentValue = _G.config.animfix_parry or false,
    Flag = "AnimFixParry",
    Callback = function(enabled)
        _G.config.animfix_parry = enabled
    end,
})

local CurveHotkeys = {
    [Enum.KeyCode.One]   = "Camera",
    [Enum.KeyCode.Two]   = "Dot",
    [Enum.KeyCode.Three] = "Backwards",
    [Enum.KeyCode.Four]  = "Slow",
    [Enum.KeyCode.Five]  = "Random",
}

local lastSetCurveMethod
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not _G.config.curve_keybind then return end

    local newMethod = CurveHotkeys[input.KeyCode]
    if not newMethod then return end

    if _G.config.curve_method == newMethod then
        if _G.config.curve_notify then
            Library:Notify({ Title = "Curve Method", Content = "Already " .. newMethod, Duration = 3 })
        end
        return
    end

    _G.config.curve_method = newMethod
    CurveMethodDropdown:Set(newMethod, true)
    lastSetCurveMethod = newMethod

    if _G.config.curve_notify then
        Library:Notify({ Title = "Curve Method", Content = newMethod, Duration = 3 })
    end
end)



local triggerActive = false
local function Trigger(ball)
    if triggerActive then return end
    triggerActive = true
    BallHelper.parry()

    ball:GetAttributeChangedSignal("target"):Once(function()
        triggerActive = false
    end)

    local startTime = tick()
    task.spawn(function()
        repeat
            RunService.PreSimulation:Wait()
        until (tick() - startTime >= 1 or not triggerActive)
        triggerActive = false
    end)
end

MainTab:CreateSection("Utilities")

local function attachKeybind(toggleEl, keybindEl)
    pcall(function()
        local toggleFrame = toggleEl._frame
        local keyFrame = keybindEl._frame
        if not toggleFrame or not keyFrame then return end
        for _, child in ipairs(keyFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.AnchorPoint = Vector2.new(1, 0.5)
                child.Position = UDim2.new(1, -66, 0.5, 0)
                child.ZIndex = 5
                child.Parent = toggleFrame
            end
        end
        keyFrame.Visible = false
    end)
end

local manualMobileBtn = nil
local triggerMobileBtn = nil

local triggerbotToggle = MainTab:CreateToggle({
    Name = "Triggerbot",
    CurrentValue = false,
    Flag = "Triggerbot",
    Callback = function(enabled)
        _G.triggerbot = enabled
        if enabled then
            if _G.config.triggerbot_notify then
                Library:Notify({ Title = "Triggerbot", Content = "On", Duration = 2 })
            end
            Connections.triggerbot = RunService.PreSimulation:Connect(function()
                local ball = BallHelper.get_ball()
                if not ball then return end
                local target = ball:GetAttribute("target")
                if target == LocalPlayer.Name then
                    Trigger(ball)
                end
            end)
        else
            if _G.config.triggerbot_notify then
                Library:Notify({ Title = "Triggerbot", Content = "Off", Duration = 2 })
            end
            if Connections.triggerbot then
                Connections.triggerbot:Disconnect()
                Connections.triggerbot = nil
            end
        end
    end
})
local triggerbotKey = MainTab:CreateKeybind({
    Name = "Triggerbot Key",
    CurrentKeybind = "T",
    Flag = "TriggerbotKey",
    Callback = function()
        triggerbotToggle:Set(not triggerbotToggle:Get())
    end,
})
attachKeybind(triggerbotToggle, triggerbotKey)

MainTab:CreateToggle({
    Name = "Triggerbot Notify",
    CurrentValue = _G.config.triggerbot_notify or false,
    Flag = "TriggerbotNotify",
    Callback = function(enabled)
        _G.config.triggerbot_notify = enabled
    end
})

MainTab:CreateToggle({
    Name = "Triggerbot UI",
    CurrentValue = _G.config.triggerbot_ui or false,
    Flag = "TriggerbotUI",
    Callback = function(enabled)
        _G.config.triggerbot_ui = enabled
        if triggerMobileBtn then
            triggerMobileBtn.Visible = enabled
        end
    end
})

local statsService = game:GetService("Stats")
local lastAutoParryFire = 0

MainTab:CreateSection("Closest")

MainTab:CreateToggle({
    Name = "Auto Spam",
    CurrentValue = _G.config.auto_spam or false,
    Flag = "AutoSpam",
    Callback = function(enabled)
        _G.config.auto_spam = enabled
        if enabled then
            Connections.auto_spam = RunService.PreSimulation:Connect(function()
                local ball = BallHelper.get_ball()
                if not ball then return end

                local zoomies = ball:FindFirstChild("zoomies")
                if not zoomies then return end

                local target = CurrentTarget
                if not target or not target.PrimaryPart then return end

                local targetPos = target.PrimaryPart.Position
                if not targetPos then return end

                local pingMs = statsService.Network.ServerStatsItem["Data Ping"]:GetValue()
                local fireDelay = pingMs / 1000

                local pingClamped = math.clamp(pingMs / 10, 1, 16)
                local ballTarget = ball:GetAttribute("target")
                local ballProps = BallHelper:get_ball_properties()
                local playerProps = BallHelper:players_properties()
                local maxAccuracy = BallHelper.perfom_spam({
                    Ball_Properties = ballProps,
                    Entity_Properties = playerProps,
                    Ping = pingClamped,
                })

                local targetDist = LocalPlayer:DistanceFromCharacter(targetPos)
                local toBall = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
                local velUnit = zoomies.VectorVelocity.Unit
                toBall:Dot(velUnit)
                local ballDist = LocalPlayer:DistanceFromCharacter(ball.Position)

                if not ballTarget then return end
                if targetDist > maxAccuracy or ballDist > maxAccuracy then return end

                local pulsed = LocalPlayer.Character:GetAttribute("Pulsed")
                if pulsed then return end

                if ballTarget == LocalPlayer.Name and targetDist > 30 and ballDist > 30 then return end

                local threshold = _G.config.spam_threshold

                if _G.config.det_infinity and Det.Infinity_Active then return end
                if _G.config.det_deathslash and Det.DeathSlash_Active then return end
                if _G.config.det_timehole and Det.TimeHole_Active then return end
                if _G.config.det_pull and Det.Pull_Active then return end
                if _G.config.det_singularity and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and LocalPlayer.Character.PrimaryPart:FindFirstChild("SingularityCape") then return end
                if _G.config.det_slashes and Det.Slashes_Active then return end
                if _G.config.det_forcefield and Det.Forcefield_Active then return end

                if ballDist <= maxAccuracy and parryCount > threshold then
                    if tick() - lastAutoParryFire >= fireDelay then
                        lastAutoParryFire = tick()
                        if _G.config.animfix_spam then playParryFix() end
                        BallHelper.parry()
                    end
                end
            end)
        else
            if Connections.auto_spam then
                Connections.auto_spam:Disconnect()
                Connections.auto_spam = nil
            end
        end
    end
})

MainTab:CreateSlider({
    Name = "Threshold",
    Range = { 1, 3 },
    Increment = 0.1,
    CurrentValue = _G.config.spam_threshold or 3,
    Flag = "Threshold",
    Callback = function(value)
        task.spawn(function()
            _G.config.spam_threshold = tonumber(value)
        end)
    end
})

MainTab:CreateToggle({
    Name = "Animation Fix",
    CurrentValue = _G.config.animfix_spam or false,
    Flag = "AnimFixSpam",
    Callback = function(enabled)
        _G.config.animfix_spam = enabled
    end,
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        _G.manual_spam = not _G.manual_spam
    end
end)

local manualSpamToggle = MainTab:CreateToggle({
    Name = "Manual Spam",
    CurrentValue = false,
    Flag = "ManualSpam",
    Callback = function(enabled)
        if enabled then
            local lastParryTick = 0

            Connections.manual_spam = RunService.PreSimulation:Connect(function()
                local kps = math.clamp(tonumber(_G.config.manual_spam_kps) or 100, 1, 3000)
                local delay = 1 / kps

                if tick() - lastParryTick >= delay then
                    lastParryTick = tick()
                    if _G.config.animfix_manual then playParryFix() end
                    BallHelper.parry()
                end
            end)

            if _G.config.manual_notify then
                Library:Notify({ Title = "Manual Spam", Content = "On", Duration = 2 })
            end
        else
            if Connections.manual_spam then
                Connections.manual_spam:Disconnect()
                Connections.manual_spam = nil
            end
            if _G.config.manual_notify then
                Library:Notify({ Title = "Manual Spam", Content = "Off", Duration = 2 })
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Manual Notify",
    CurrentValue = _G.config.manual_notify or false,
    Flag = "ManualNotify",
    Callback = function(enabled)
        _G.config.manual_notify = enabled
    end
})

MainTab:CreateToggle({
    Name = "Manual Spam UI",
    CurrentValue = _G.config.manual_spam_ui or false,
    Flag = "ManualSpamUI",
    Callback = function(enabled)
        _G.config.manual_spam_ui = enabled
        if manualMobileBtn then
            manualMobileBtn.Visible = enabled
        end
    end
})

local manualSpamKeybind = MainTab:CreateKeybind({
    Name = "Manual Spam Key",
    CurrentKeybind = _G.config.manual_spam or "E",
    Flag = "ManualSpamKey",
    Callback = function()
        manualSpamToggle:Set(not manualSpamToggle:Get())
    end,
    OnChanged = function(Key)
        _G.config.manual_spam = Key.Name
    end,
})
attachKeybind(manualSpamToggle, manualSpamKeybind)

MainTab:CreateSlider({
    Name = "Manual Spam KPS",
    Range = { 1, 3000 },
    Increment = 1,
    CurrentValue = _G.config.manual_spam_kps or 100,
    Flag = "ManualSpamKPS",
    Callback = function(value)
        task.spawn(function()
            _G.config.manual_spam_kps = math.floor(tonumber(value) or 100)
        end)
    end
})

MainTab:CreateToggle({
    Name = "Animation Fix",
    CurrentValue = _G.config.animfix_manual or false,
    Flag = "AnimFixManual",
    Callback = function(enabled)
        _G.config.animfix_manual = enabled
    end,
})

local mobileGui = Instance.new("ScreenGui")
mobileGui.Name = "FloxyMobile"
mobileGui.ResetOnSpawn = false
mobileGui.IgnoreGuiInset = true
mobileGui.DisplayOrder = 50
mobileGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function makeMobileButton(title, yPos, getState, onTap)
    local btn = Instance.new("TextButton")
    btn.Name = title
    btn.Size = UDim2.new(0, 170, 0, 52)
    btn.Position = UDim2.new(1, -190, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(13, 17, 24)
    btn.BackgroundTransparency = 0.15
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Active = true
    btn.Parent = mobileGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(60, 60, 70)
    stroke.Parent = btn
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(10, 10)
    dot.Position = UDim2.new(0, 14, 0.5, -5)
    dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    dot.BorderSizePixel = 0
    dot.Parent = btn
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -78, 1, 0)
    label.Position = UDim2.new(0, 32, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(235, 240, 248)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Text = title
    label.Parent = btn
    local state = Instance.new("TextLabel")
    state.Size = UDim2.new(0, 40, 0, 22)
    state.Position = UDim2.new(1, -48, 0.5, -11)
    state.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    state.TextColor3 = Color3.fromRGB(255, 255, 255)
    state.Font = Enum.Font.GothamBold
    state.TextSize = 12
    state.Text = "OFF"
    state.Parent = btn
    local stateCorner = Instance.new("UICorner")
    stateCorner.CornerRadius = UDim.new(0, 8)
    stateCorner.Parent = state
    local function refresh()
        local on = getState()
        if on then
            state.Text = "ON"
            state.BackgroundColor3 = Color3.fromRGB(125, 211, 252)
            state.TextColor3 = Color3.fromRGB(13, 17, 24)
            stroke.Color = Color3.fromRGB(125, 211, 252)
            dot.BackgroundColor3 = Color3.fromRGB(125, 211, 252)
        else
            state.Text = "OFF"
            state.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            state.TextColor3 = Color3.fromRGB(255, 255, 255)
            stroke.Color = Color3.fromRGB(60, 60, 70)
            dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
    end
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local moved = false
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and dragStart and startPos and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.abs(delta.X) + math.abs(delta.Y) > 8 then
                moved = true
            end
            if moved then
                btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not moved then
                onTap()
                refresh()
            end
            dragging = false
        end
    end)
    refresh()
    return refresh, btn
end

local refreshManualMobile
refreshManualMobile, manualMobileBtn = makeMobileButton("Manual Spam", 120, function()
    return manualSpamToggle:Get()
end, function()
    manualSpamToggle:Set(not manualSpamToggle:Get())
end)
manualMobileBtn.Visible = _G.config.manual_spam_ui or false
local refreshTriggerMobile
refreshTriggerMobile, triggerMobileBtn = makeMobileButton("Triggerbot", 182, function()
    return triggerbotToggle:Get()
end, function()
    triggerbotToggle:Set(not triggerbotToggle:Get())
end)
triggerMobileBtn.Visible = _G.config.triggerbot_ui or false
task.spawn(function()
    while mobileGui.Parent do
        task.wait(0.2)
        pcall(refreshManualMobile)
        pcall(refreshTriggerMobile)
    end
end)

MainTab:CreateSection("Misc")

MainTab:CreateToggle({
    Name = "Hotkey Curve",
    CurrentValue = _G.config.curve_keybind or false,
    Flag = "HotkeyCurve",
    Callback = function(enabled)
        task.spawn(function()
            _G.config.curve_keybind = enabled
        end)
    end
})

MainTab:CreateToggle({
    Name = "Hotkey Notify",
    CurrentValue = _G.config.curve_notify or false,
    Flag = "HotkeyNotify",
    Callback = function(enabled)
        task.spawn(function()
            _G.config.curve_notify = enabled
        end)
    end
})

VisualTab:CreateSection("Visual")

VisualTab:CreateToggle({
    Name = "Ability ESP",
    CurrentValue = _G.config.ability_esp or false,
    Flag = "AbilityESP",
    Callback = function(enabled)
        _G.config.ability_esp = enabled
        for _, label in pairs(PlayerESPLabels) do
            label.Visible = enabled
        end
    end
})

VisualTab:CreateToggle({
    Name = "Ball Stats",
    CurrentValue = _G.config.ball_debug or false,
    Flag = "BallStatistic",
    Callback = function(enabled)
        _G.config.ball_debug = enabled
        if enabled then
            enable_ball_stats()
        else
            destroy_ball_stats()
        end
    end,
})

VisualTab:CreateToggle({
    Name = "Player Cosmetics",
    CurrentValue = _G.config.player_cosmetics or false,
    Flag = "PlayerCosmetics",
    Callback = function(enabled)
        _G.config.player_cosmetics = enabled
        if enabled then
            cosmeticsCleanup = {}
            if LocalPlayer.Character then applyCosmetics(LocalPlayer.Character) end
            if cosmeticsCharConn then cosmeticsCharConn:Disconnect() end
            cosmeticsCharConn = LocalPlayer.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                applyCosmetics(char)
            end)
        else
            if cosmeticsCharConn then
                cosmeticsCharConn:Disconnect()
                cosmeticsCharConn = nil
            end
            if LocalPlayer.Character then
                restoreHeadless(LocalPlayer.Character)
                restoreKorblox(LocalPlayer.Character)
            end
            cosmeticsCleanup = {}
        end
    end,
})

local function applyAnnouncerText()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local announcerGui = pg and pg:FindFirstChild("announcer")
    local winnerLabel = announcerGui and announcerGui:FindFirstChild("Winner")
    if winnerLabel then
        winnerLabel.Text = _G.config.announcer_text or "Floxy"
    end
end

VisualTab:CreateToggle({
    Name = "Custom Announcer",
    CurrentValue = _G.config.custom_announcer or false,
    Flag = "CustomAnnouncer",
    Callback = function(enabled)
        _G.config.custom_announcer = enabled
        if enabled then
            applyAnnouncerText()
            if not Connections.custom_announcer then
                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                local announcerGui = pg and pg:FindFirstChild("announcer")
                if announcerGui then
                    Connections.custom_announcer = announcerGui.ChildAdded:Connect(function(child)
                        if child.Name == "Winner" then
                            child.Changed:Connect(function(property)
                                if property == "Text" and _G.config.custom_announcer then
                                    child.Text = _G.config.announcer_text or "Floxy"
                                end
                            end)
                            if _G.config.custom_announcer then
                                child.Text = _G.config.announcer_text or "Floxy"
                            end
                        end
                    end)
                end
            end
        else
            if Connections.custom_announcer then
                Connections.custom_announcer:Disconnect()
                Connections.custom_announcer = nil
            end
        end
    end,
})

VisualTab:CreateInput({
    Name = "Announcement Text",
    Placeholder = "Enter announcement...",
    CurrentValue = _G.config.announcer_text or "",
    Flag = "AnnouncerText",
    Callback = function(text)
        _G.config.announcer_text = text
        if _G.config.custom_announcer then
            applyAnnouncerText()
        end
    end,
})

local function swapThemeColor(oldColor, newColor)
    if oldColor == newColor then return end
    for _, inst in ipairs(Window.Gui:GetDescendants()) do
        if inst:IsA("GuiObject") then
            if inst.BackgroundColor3 == oldColor then
                inst.BackgroundColor3 = newColor
            end
            if (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) and inst.TextColor3 == oldColor then
                inst.TextColor3 = newColor
            end
            if (inst:IsA("ImageLabel") or inst:IsA("ImageButton")) and inst.ImageColor3 == oldColor then
                inst.ImageColor3 = newColor
            end
        elseif inst:IsA("UIStroke") then
            if inst.Color == oldColor then
                inst.Color = newColor
            end
        end
    end
end
local function refreshFMarks()
    for i = #fGradients, 1, -1 do
        local g = fGradients[i]
        if g.Parent then
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library.Theme.AccentDark),
                ColorSequenceKeypoint.new(0.55, Library.Theme.AccentDark:Lerp(Library.Theme.Accent, 0.5)),
                ColorSequenceKeypoint.new(1, Library.Theme.Accent),
            })
        else
            table.remove(fGradients, i)
        end
    end
end
local defaultAccent = Library.Theme.Accent
local defaultAccentDark = Library.Theme.AccentDark
local defaultBackground = Library.Theme.Background
local defaultText = Library.Theme.Text
local function applyAccent(color)
    _G.config.theme_accent = { math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5) }
    swapThemeColor(Library.Theme.Accent, color)
    Library.Theme.Accent = color
    refreshFMarks()
end
local function applyAccentDark(color)
    _G.config.theme_accent_dark = { math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5) }
    swapThemeColor(Library.Theme.AccentDark, color)
    Library.Theme.AccentDark = color
    refreshFMarks()
end
local function applyBackground(color)
    _G.config.theme_background = { math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5) }
    swapThemeColor(Library.Theme.Background, color)
    Library.Theme.Background = color
end
local function applyText(color)
    _G.config.theme_text = { math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5) }
    swapThemeColor(Library.Theme.Text, color)
    Library.Theme.Text = color
end
local function themeColor(saved, fallback)
    if type(saved) == "table" and saved[1] and saved[2] and saved[3] then
        local ok, color = pcall(function()
            return Color3.fromRGB(saved[1], saved[2], saved[3])
        end)
        if ok and typeof(color) == "Color3" then return color end
    end
    return fallback
end

local SettingsTab = Window:CreateTab({ Name = "UI Settings", Desc = "menu and keybinds", Icon = "settings" })

SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = _G.config.ui_keybind or "RightShift",
    OnChanged = function(Key)
        _G.config.ui_keybind = Key.Name
        Window:SetKeybind(Key)
    end,
})

SettingsTab:CreateSection("Theme")

local accentPicker = SettingsTab:CreateColorPicker({
    Name = "Accent Color",
    Color = themeColor(_G.config.theme_accent, Library.Theme.Accent),
    Flag = "ThemeAccent",
    Callback = function(color)
        applyAccent(color)
    end,
})
local accentDarkPicker = SettingsTab:CreateColorPicker({
    Name = "Accent Dark Color",
    Color = themeColor(_G.config.theme_accent_dark, Library.Theme.AccentDark),
    Flag = "ThemeAccentDark",
    Callback = function(color)
        applyAccentDark(color)
    end,
})
local backgroundPicker = SettingsTab:CreateColorPicker({
    Name = "Background Color",
    Color = themeColor(_G.config.theme_background, Library.Theme.Background),
    Flag = "ThemeBackground",
    Callback = function(color)
        applyBackground(color)
    end,
})
local textPicker = SettingsTab:CreateColorPicker({
    Name = "Text Color",
    Color = themeColor(_G.config.theme_text, Library.Theme.Text),
    Flag = "ThemeText",
    Callback = function(color)
        applyText(color)
    end,
})
SettingsTab:CreateButton({
    Name = "Reset Colors",
    Icon = "rotate-ccw",
    Callback = function()
        applyAccent(defaultAccent)
        applyAccentDark(defaultAccentDark)
        applyBackground(defaultBackground)
        applyText(defaultText)
        pcall(function() accentPicker:Set(defaultAccent, true) end)
        pcall(function() accentDarkPicker:Set(defaultAccentDark, true) end)
        pcall(function() backgroundPicker:Set(defaultBackground, true) end)
        pcall(function() textPicker:Set(defaultText, true) end)
    end,
})

SettingsTab:CreateButton({
    Name = "Unload",
    Icon = "power",
    Callback = function()
        Window:Destroy()
    end,
})

applyAccent(themeColor(_G.config.theme_accent, Library.Theme.Accent))
applyAccentDark(themeColor(_G.config.theme_accent_dark, Library.Theme.AccentDark))
applyBackground(themeColor(_G.config.theme_background, Library.Theme.Background))
applyText(themeColor(_G.config.theme_text, Library.Theme.Text))
