local function __KysHub_Init_Main__()
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local Teams             = game:GetService("Teams")
local GuiService        = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer       = Players.LocalPlayer
local Camera            = Workspace.CurrentCamera
local Character, Humanoid, Root

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local UI = {}

local ok, result = pcall(require, "./src/Init")
local ModernV2 = ok and result or nil
if not ModernV2 then
    -- Primary: Vercel mirror (no rate limit)
    local loaderOk, loaderResult = pcall(function()
        local source = game:HttpGet("https://raw.githubusercontent.com/Kys-lol/KysHubNewUI/refs/heads/main/ModernLua.txt")
        local fn, compileErr = loadstring(source)
        if not fn then error(compileErr) end
        return fn()
    end)
    if loaderOk then
        ModernV2 = loaderResult
    else
        warn("[KysHub] Vercel mirror failed, trying GitHub fallback:", loaderResult)
        -- Fallback: GitHub raw (may be rate-limited)
        local fallbackOk, fallbackResult = pcall(function()
            local source = game:HttpGet("https://raw.githubusercontent.com/Kys-lol/KysHubNewUI/refs/heads/main/MainV2.lua")
            local fn, compileErr = loadstring(source)
            if not fn then error(compileErr) end
            return fn()
        end)
        if fallbackOk then
            ModernV2 = fallbackResult
        else
            warn("[KysHub] Failed to load ModernV2 from all sources:", fallbackResult)
        end
    end
end

if isMobile then UI.Mobile = true end
print("[Universal] Platform:", isMobile and "MOBILE" or "PC")

-- =====================================================
local HttpService = game:GetService("HttpService")
local UIConfigPath = "KysHub_UI_Theme.json"
local KysUI_Solid = false
local KysUI_Color = "Red"

pcall(function()
    if isfile and readfile and isfile(UIConfigPath) then
        local data = HttpService:JSONDecode(readfile(UIConfigPath))
        KysUI_Solid = data.Solid
        KysUI_Color = data.Color or "Red"
    end
end)

if KysUI_Color == "Default" then
    KysUI_Color = "Red"
end

-- =====================================================

if ModernV2 then
    pcall(function()
        ModernV2:AddTheme({
            Name = "Lumi red",
            Accent = Color3.fromRGB(255, 0, 0),
            Outline = Color3.fromRGB(255, 0, 0),
            Text = Color3.fromRGB(255, 255, 255),
            PlaceholderText = Color3.fromRGB(200, 200, 200)
        })
    end)
end

local MenuIcon
if ModernV2 and ModernV2.CreateMenuIcon then
    MenuIcon = ModernV2:CreateMenuIcon({
        Image = "rbxassetid://80891639562743",
        Size = 48,
        IconColor = Color3.fromRGB(255, 255, 255),
        BGColor = Color3.fromRGB(20, 22, 27),
        StrokeColor = Color3.fromRGB(255, 0, 0),
        StrokeThick = 1.5,
        Draggable = true,
    })
end
local Window
if ModernV2 then
    -- =====================================
    -- MAIN SCRIPT
    -- =====================================
    Window = ModernV2:Window({
        Title = "KysHub CRACKED√ by <iry hub>",
        Content = "Violence District v1.5.7",
        Uitransparent = 0.15,
        Size = UDim2.fromOffset(500, 320),
        Color = Color3.fromRGB(255, 0, 0),
        Image = "80891639562743",
        ShowUser = true,
        Search = true,
        ConfigEnabled = true,
        NotifyOnCallbackError = false,
        Loadingscreen = false,
        Enable3DRenderer = false,
        Keybind = "RightControl",
        Config = {
            ConfigFolder = "KysHubViolenceDistrict",
            AutoSaveFile = "KYS_VD",
            AutoSave = false,
            AutoLoad = false,
            Overwrite = true,
            Format = "JSON",
            ShowAutoSaveToggle = true,
            TextGradient = true,
        }
    })

    if MenuIcon and Window.AttachMenuIcon then
        Window:AttachMenuIcon(MenuIcon)
    end

    Window:SetAccount({
        Username = LocalPlayer.DisplayName,
        Profile = ModernV2.UserProfile,
        Expires = "crack by @inlawry",
    })

    Window:CreateHomeTab({
        Name = "Dashboard",
        Icon = "lucide:layout-dashboard",
        Content = "KysHub crack Violence District Script",
        DiscordInvite = "",
          SupportedExecutors = { "Delta", "Synapse X", "Krnl", "Codex", "Arceus X" },
          UnsupportedExecutors = { "Roblox Studio" },
          Segments = {
              Details = { Text = "Details", Icon = "lucide:grid-2x2" },
              Script = { Text = "Script Logs", Icon = "lucide:code" },
              UI = { Text = "UI Logs", Icon = "lucide:file-text", Show = true }
          },
        Changelog = {
            {
                Title = "KysHub crack VD v1.5.7",
                Description = "Added Fake Perks (Flowstate, Quick Recovery, Perfect Landing, Adrenaline Rush) with stack support and shared cooldown (Premium Only). Added Copy Avatar feature with accurate skin/mesh restoration.",
            },
            {
                Title = "KysHub crack VD v1.5.6",
                Description = "Improved Weather & Sky Theme particles and fixed Fullbright compatibility with active weather themes.",
            },
            {
                Title = "KysHub crack VD v1.5.5",
                Description = "Improved Aimbot, Spear Aimbot, Silent Aim Spear, and added new Auto Dodge Spear feature.",
            },
            {
                Title = "KysHub crack VD v1.5.4",
                Description = "Added Fake Parry, Fake Generator, Fake Attack, and fixed Infinite Skills backend.",
            },
        },
        UIChangelog = {
            {
                Title = "ModernV2 Framework",
                Date = "Latest",
                Description = "Added Lumi red Theme",
            },
        }
    })
end

-- =====================================================
-- PC CURSOR UNLOCK (ALT key toggle)
-- Hanya aktif di PC, tidak mengganggu mobile
-- =====================================================
if not isMobile then
    local _cursorOn = false
    local _cursorManual = false

    local function _setCursor(state)
        _cursorOn = state
        _cursorManual = true
        pcall(function()
            UserInputService.MouseIconEnabled = state
            UserInputService.MouseBehavior = state
                and Enum.MouseBehavior.Default
                or Enum.MouseBehavior.LockCenter
        end)

        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = not state
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        
        if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
            _setCursor(not _cursorOn)
        end
    end)

    task.spawn(function()
        while true do
            if _cursorManual then
                pcall(function()
                    if _cursorOn then
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                        UserInputService.MouseIconEnabled = true
                    else
                        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                        UserInputService.MouseIconEnabled = false
                    end
                end)
            end
            task.wait(0.1)
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if _cursorOn then _setCursor(true) end
    end)

    print("[VD] ALT Toggle Cursor Ready (PC only)")
end

-- =====================================================
-- SAFE DRAWING UTILS
-- =====================================================
local DrawingAvailable = (function()
    if isMobile then return false end  --
    local ok, result = pcall(function()
        return typeof(Drawing) == "table" and Drawing.new ~= nil
    end)
    return ok and result or false
end)()

function SafeDrawing(typ)
    if not DrawingAvailable then return nil end
    local ok, res = pcall(function() return Drawing.new(typ) end)
    return ok and res or nil
end

function SafeRemove(obj)
    if obj and obj.Remove then pcall(function() obj:Remove() end) end
end

local MobileESP = {}

-- =====================================================
-- UTILITY FUNCTIONS
-- =====================================================
function clamp(v, min, max)
    return math.max(min, math.min(max, v))
end



-- =====================================================
-- CONFIG
-- =====================================================
getgenv().VD = getgenv().VD or {

    -- Generator / Healing
    AutoSkillcheck        = false,
    AutoSkillcheckMode    = "Normal",
    -- Visual / UI
    HideSkillUI           = false,
    Fullbright            = false,
    -- Movement
    Speed                 = false,
    SpeedValue            = 16,
    Jump                  = false,
    JumpValue             = 50,
    InfiniteJump          = false,
    Noclip                = false,
    Moonwalk              = false,
    MoonwalkButton        = false,
    MoonwalkButtonLocked  = false,
    MoonwalkZigzagSpeed   = 11,
    MoonwalkBoostPower    = 1.08,
    AimLock               = false,
    AimLockButton         = false,
    AimLockButtonLocked   = false,
    AimLockMaxDistance    = 50,
    InvisibleNotVisual    = false,
    InvisibleSpeed        = 5,
    AntiAFK               = false,
    BypassGate            = false,
    -- Internal
    Destroyed             = false,
    -- Auto features

    AUTO_LeaveGen         = false,
    AUTO_LeaveDist        = 18,
    AUTO_Attack           = false,
    AUTO_AttackRange      = 12,
    HITBOX_Enabled        = false,
    HITBOX_Size           = 15,
    TOF_SilentAim         = false,
    TOF_Laser             = true,
    TOF_WallCheck         = false,
    TOF_BlockKnocked      = true,
    TOF_TargetMode        = "Killer",
    TOF_Key               = "None",
    FLASH_SilentAim       = false,
    FLASH_Laser           = true,
    FLASH_TargetPart      = "Head",
    FLASH_Range           = 120,
    FLASH_Smooth          = 0.35,
    SURV_FleeKiller       = false,
    SURV_FleeDistance     = 40,
    SURV_SwiftVault        = false,  -- Auto Vault saat dekat window
    SURV_SwiftVaultV2       = false,  -- Custom vault speed
    SURV_SwiftVaultSpeed       = 13,
    SURV_AutoPallet       = false,  -- Auto Pallet Drop saat killer dekat
    SURV_AutoPalletDist   = 20,     -- Jarak killer (studs) untuk trigger pallet drop
    SURV_AutoParry        = false,
    SURV_ParryDistance    = 8,
    SURV_ShowParryCircle  = false,
    SURV_FakeParry        = false,
    SURV_FakeParryAnim    = "Enten",
    SURV_FakeGen          = false,
    SURV_AntiKnock        = false,
    -- Killer features
    KILLER_DestroyPallets = false,
    KILLER_NoPalletStun   = false,
    KILLER_AutoHook       = false,
    KILLER_AutoBreakGene  = false,
    KILLER_BlockVaults    = false,
    KILLER_BlockPallets   = false,
    KILLER_BlockPalletDrop = false,
    KILLER_BypassCooldown = false,
    KILLER_BypassLeap     = false,
    KILLER_AntiBlind      = false,
    KILLER_NoSlowdown     = false,
    KILLER_CustomMasked   = "Richard",
    -- Speed
    SPEED_Enabled         = false,
    SPEED_Value           = 32,
    SPEED_Method          = "Attribute",
    -- Visual extras
    NO_Fog                = false,
    NoCutscene            = false,
    CAM_FOVEnabled        = false,
    CAM_FOV               = 90,
    CAM_ThirdPerson       = false,
    CAM_ShiftLock         = false,
    CAM_InfinityZoom      = false,
    -- Config
    AntiFallDamage        = false,
    FLING_Enabled         = false,
    FLING_Strength        = 10000,
    -- Beat game
    BEAT_Survivor         = false,
    BEAT_Killer           = false,
    TP_Offset             = 3,
    VIS_KystKiller        = false,
    VIS_SpectatorCounter  = false,
    VIS_KillerPerks       = false,
    VIS_PredictMap        = false,
    VIS_HideSurvivorIcon  = false,
    VIS_ShowPingFPS       = false,
    VIS_ShowHookCounter   = false,
    VIS_WeatherTheme      = "Default",
    CROSS_Enabled         = false,
    CROSS_Style           = "Dot",
    CROSS_Size            = 3,
    CROSS_Thickness       = 4,
    CROSS_Gap             = 6,
    CROSS_PosX            = 0,
    CROSS_PosY            = 0,
    CROSS_Color           = Color3.fromRGB(255, 255, 255),

    ESP_ClosestHook       = false,    -- Aimbot
    AIM_Enabled           = false,

    AIM_UseRMB            = false,
    AIM_FOV               = 120,
    AIM_Smooth            = 0.3,
    AIM_TargetPart        = "Head",
    AIM_VisCheck          = false,
    AIM_ShowFOV           = false,
    AIM_Predict           = false,
    SURV_FirstPerson       = false,
    -- Spear aimbot
    SPEAR_Aimbot          = false,
    SPEAR_Gravity         = 50,
    SPEAR_Speed           = 100,
    -- Radar
    RADAR_Enabled         = false,
    RADAR_Size            = 150,
    RADAR_Range           = 250,
    RADAR_Transparency    = 0.2,
    RADAR_Circle          = false,
    RADAR_ShowKiller      = false,
    RADAR_ShowSurvivor    = false,
    RADAR_ShowGenerator   = false,
    RADAR_ShowPallet      = false,
    RADAR_ShowHook        = false,
    RADAR_ShowGate        = false,
    RADAR_ShowWindow      = false,
    RADAR_ShowZombie      = false,
    SURV_WarnKiller       = false,
    SURV_AutoDodgeSpear   = false
}

local VD = getgenv().VD

-- =====================================================
-- ADVANCED CROSSHAIR (GUI Fallback / Port)
-- =====================================================
local CrosshairGui = nil

function clearCrosshair()
    if CrosshairGui then
        pcall(function() CrosshairGui:Destroy() end)
        CrosshairGui = nil
    end
end

function VD_UpdateCrosshair()
    clearCrosshair()
    if not VD.CROSS_Enabled then return end

    local cam = workspace.CurrentCamera
    if not cam then return end

    local style = VD.CROSS_Style or "Dot"
    local size = tonumber(VD.CROSS_Size) or 3
    local gap = tonumber(VD.CROSS_Gap) or 6
    local thick = tonumber(VD.CROSS_Thickness) or 4
    local color = typeof(VD.CROSS_Color) == "Color3" and VD.CROSS_Color or Color3.fromRGB(255, 255, 255)
    
    local offsetX = tonumber(VD.CROSS_PosX) or 0
    local offsetY = tonumber(VD.CROSS_PosY) or 0

    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    local parent = (ok and core) and core or game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if not parent then return end

    CrosshairGui = Instance.new("ScreenGui")
    CrosshairGui.Name = "KYS_Crosshair"
    CrosshairGui.DisplayOrder = 999999
    CrosshairGui.IgnoreGuiInset = true
    CrosshairGui.Parent = parent

    local centerFrame = Instance.new("Frame")
    centerFrame.Name = "Center"
    centerFrame.BackgroundTransparency = 1
    centerFrame.Position = UDim2.new(0.5, offsetX, 0.5, offsetY)
    centerFrame.Size = UDim2.new(0,0,0,0)
    centerFrame.Parent = CrosshairGui

    if style == "Dot" then
        local dot = Instance.new("Frame")
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Size = UDim2.new(0, size * 2, 0, size * 2)
        dot.BackgroundColor3 = color
        dot.BorderSizePixel = 0
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = dot
        dot.Parent = centerFrame

    elseif style == "Plus" or style == "X" then
        local length = size * 3
        for i = 1, 4 do
            local line = Instance.new("Frame")
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.BackgroundColor3 = color
            line.BorderSizePixel = 0
            
            local angle = (i - 1) * 90
            if style == "X" then angle = angle + 45 end
            
            line.Rotation = angle
            line.Size = UDim2.new(0, length, 0, thick)
            
            local rad = math.rad(angle)
            local dirX = math.cos(rad)
            local dirY = math.sin(rad)
            
            local dist = gap + (length / 2)
            -- Snap values to avoid weird float sub-pixel rendering blur
            line.Position = UDim2.new(0, math.floor(dirX * dist + 0.5), 0, math.floor(dirY * dist + 0.5))
            line.Parent = centerFrame
        end

    elseif style == "Box" then
        local half = gap + size * 2
        
        local t = Instance.new("Frame")
        t.BackgroundColor3 = color; t.BorderSizePixel = 0; t.AnchorPoint = Vector2.new(0.5, 0.5)
        t.Size = UDim2.new(0, half * 2 + thick, 0, thick)
        t.Position = UDim2.new(0, 0, 0, -half)
        t.Parent = centerFrame

        local b = Instance.new("Frame")
        b.BackgroundColor3 = color; b.BorderSizePixel = 0; b.AnchorPoint = Vector2.new(0.5, 0.5)
        b.Size = UDim2.new(0, half * 2 + thick, 0, thick)
        b.Position = UDim2.new(0, 0, 0, half)
        b.Parent = centerFrame

        local l = Instance.new("Frame")
        l.BackgroundColor3 = color; l.BorderSizePixel = 0; l.AnchorPoint = Vector2.new(0.5, 0.5)
        l.Size = UDim2.new(0, thick, 0, half * 2 - thick)
        l.Position = UDim2.new(0, -half, 0, 0)
        l.Parent = centerFrame

        local r = Instance.new("Frame")
        r.BackgroundColor3 = color; r.BorderSizePixel = 0; r.AnchorPoint = Vector2.new(0.5, 0.5)
        r.Size = UDim2.new(0, thick, 0, half * 2 - thick)
        r.Position = UDim2.new(0, half, 0, 0)
        r.Parent = centerFrame
    end
end
getgenv().VD_UpdateCrosshair = VD_UpdateCrosshair

-- All runtime features are intentionally reset on every execute.
-- This prevents stale getgenv/config/UI state from enabling anything
-- before the user turns it on manually.
local VD_DefaultOffFlags = {
    "AutoSkillcheck",
    "HideSkillUI",
    "Fullbright",
    "Speed",
    "Jump",
    "InfiniteJump",
    "Noclip",
    "Moonwalk",
    "MoonwalkButton",
    "MoonwalkButtonLocked",
    "AimLock",
    "AimLockButton",
    "AimLockButtonLocked",
    "AimLockMaxDistance",
    "InvisibleNotVisual",
    "AntiAFK",
    "BypassGate",
    "AUTO_Attack",
    "HITBOX_Enabled",
    "TOF_SilentAim",
    "FLASH_SilentAim",
    "SURV_FleeKiller",
    "SURV_SwiftVault",
    "SURV_SwiftVaultV2",
    "SURV_AutoPallet",
    "SURV_AutoParry",
    "SURV_ShowParryCircle",
    "SURV_FakeParry",
    "SURV_FakeParryAnim",
    "SURV_FakeGen",
    "SURV_AntiKnock",
    "KILLER_DestroyPallets",
    "KILLER_NoPalletStun",
    "KILLER_AutoHook",
    "KILLER_AutoBreakGene",
    "KILLER_BlockVaults",
    "KILLER_BlockPallets",
    "KILLER_BlockPalletDrop",
    "KILLER_BypassCooldown",
    "KILLER_BypassLeap",
    "KILLER_BypassVeilCooldown",
    "KILLER_AntiBlind",
    "KILLER_NoSlowdown",
    "SPEED_Enabled",
    "NO_Fog",
    "NoCutscene",
    "VIS_KystKiller",
    "CAM_FOVEnabled",
    "CAM_ThirdPerson",
    "CAM_ShiftLock",
    "CAM_InfinityZoom",
    "AntiFallDamage",
    "FLING_Enabled",
    "BEAT_Survivor",
    "BEAT_Killer",
    "ESP_ClosestHook",
    "VIS_SpectatorCounter",
    "VIS_KillerPerks",
    "VIS_PredictMap",
    "VIS_HideSurvivorIcon",
    "VIS_ShowPingFPS",
    "VIS_ShowHookCounter",
    "CROSS_Enabled",
    "CROSS_Style",
    "CROSS_Size",
    "CROSS_Thickness",
    "CROSS_Gap",
    "CROSS_PosX",
    "CROSS_PosY",
    "CROSS_Color",
    "AIM_Enabled",

    "AIM_UseRMB",
    "AIM_VisCheck",
    "AIM_ShowFOV",
    "AIM_Predict",
    "SURV_FirstPerson",
    "SPEAR_Aimbot",
    "RADAR_Enabled",
    "RADAR_Circle",
    "RADAR_ShowKiller",
    "RADAR_ShowSurvivor",
    "RADAR_ShowGenerator",
    "RADAR_ShowPallet",
    "RADAR_ShowHook",
    "RADAR_ShowGate",
    "RADAR_ShowWindow",
    "RADAR_ShowZombie",
    "SURV_WarnKiller",
}

for _, flagName in ipairs(VD_DefaultOffFlags) do
    VD[flagName] = false
end

if VD.TOF_Laser == nil then VD.TOF_Laser = true end
if VD.TOF_WallCheck == nil then VD.TOF_WallCheck = false end
if VD.TOF_BlockKnocked == nil then VD.TOF_BlockKnocked = true end
if VD.TOF_TargetMode == nil then VD.TOF_TargetMode = "Killer" end
if VD.TOF_Key == nil then VD.TOF_Key = "None" end
if VD.FLASH_TargetPart == nil then VD.FLASH_TargetPart = "Head" end
if VD.FLASH_Laser == nil then VD.FLASH_Laser = true end
if VD.FLASH_Range == nil then VD.FLASH_Range = 120 end
if VD.FLASH_Smooth == nil then VD.FLASH_Smooth = 0.35 end

-- =====================================================
-- CONFIGURATION SYSTEM (Save & Load)
-- =====================================================
function GetSafeGuiParent()
    if gethui then return gethui() end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then return core end
    return LocalPlayer:FindFirstChild("PlayerGui")
end


local VD_ChamsFolder = nil
function GetSafeChamsFolder()
    local pg = GetSafeGuiParent()
    if not pg then return workspace end
    if VD_ChamsFolder and VD_ChamsFolder.Parent then return VD_ChamsFolder end

    local f = pg:FindFirstChild("KYS_WorkspaceChams")
    if not f then
        f = Instance.new("Folder")
        f.Name = "KYS_WorkspaceChams"
        f.Parent = pg
    end
    VD_ChamsFolder = f
    return f
end

local ConfigFolderName = "KysHub_VD"
local HttpService = game:GetService("HttpService")

if makefolder and isfolder and not isfolder(ConfigFolderName) then
    makefolder(ConfigFolderName)
end

getgenv().CurrentConfigName = "Default"

function GetConfigList()
    local list = {}
    if listfiles and isfolder and isfolder(ConfigFolderName) then
        for _, file in pairs(listfiles(ConfigFolderName)) do
            if file:sub(-5) == ".json" then
                local filename = file:match("([^/\\]+)%.json$")
                if filename then
                    table.insert(list, filename)
                end
            end
        end
    end
    if #list == 0 then table.insert(list, "Default") end
    return list
end

function KYS_SaveConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" then name = "Default" end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if writefile then
            writefile(path, HttpService:JSONEncode(VD))
        end
    end)
end

local VD_To_Flag = {
    InfiniteJump = "Infinite Jump",
    KILLER_AntiBlind = "Anti Blind (Flashlight)",
    Fullbright = "Fullbright (lighting preset)",
    AIM_VisCheck = "Visibility Check",
    AutoSkillcheck = "Auto Skillcheck",
    AutoSkillcheckMode = "Skillcheck Mode",
    HideSkillUI = "Hide Skillcheck UI",
    SpeedValue = "Speed Value",
    AIM_Enabled = "Enable Aimbot",
    HITBOX_Size = "Hitbox Size",
    SURV_FleeKiller = "Flee Killer",
    SURV_FleeDistance = "Flee Distance",
    SURV_AutoVault      = "SwiftVault",
    SURV_FastVault      = "SwiftVaultV2",
    SURV_VaultSpeed     = "SwiftVaultSpeed",
    SURV_AutoPallet     = "Pallet Reflex",
    SURV_AutoPalletDist = "Pallet Trigger Range",
    SURV_AutoParry      = "Auto Parry",
    SURV_ParryDistance  = "Parry Distance Trigger",
    SURV_ShowParryCircle = "Show Parry Range Circle",
    SURV_FakeParry      = "Fake Parry (Press V)",
    SURV_FakeParryAnim  = "Fake Parry Animation",
    SURV_FakeGen        = "Fake Generator (Press B)",
    SURV_AntiKnock = "Anti Knock",
    KILLER_DestroyPallets = "Destroy Pallets",
    KILLER_AutoBreakGene  = "Auto Kick Generator",
    KILLER_BlockVaults    = "Block All Vaults",
    KILLER_BlockPallets   = "Auto Drop All Pallets",
    KILLER_BlockPalletDrop = "Break All Pallet",
    KILLER_BypassCooldown = "Infinite Abyssal Burst (Abyss)",
    KILLER_BypassLeap     = "Infinite Skill (Hidden)",
    KILLER_FakeAttack     = "Fake Attack (Counter Parry)",
    KILLER_BypassVeilCooldown = "Bypass Cooldown (Veil)",
    KILLER_CustomMasked = "Custom Masked",
    Speed = "Speed Hack",
    CAM_FOV = "Camera FOV",
    CAM_FOVEnabled = "Enable Camera FOV override",
    FLING_Strength = "Fling Strength",
    Noclip = "Noclip",
    Moonwalk = "Moonwalk",
    MoonwalkButton = "Moonwalk",
    MoonwalkButtonLocked = "Lock Moonwalk Button",
    MoonwalkZigzagSpeed = "Moonwalk Zigzag Speed",
    MoonwalkBoostPower = "Moonwalk Boost Power",
    AimLock = "Target Lock",
    AimLockButton = "Target Lock",
    AimLockButtonLocked = "Lock Target Lock Button",
    AimLockMaxDistance = "Target Lock Max Distance",
    BEAT_Killer = "Beat Killer (auto kill)",
    AIM_Predict = "Prediction",
    AIM_ShowFOV = "Show FOV Circle",
    KILLER_AutoHook = "Auto Hook",
    Jump = "Jump Hack",
    KILLER_NoSlowdown = "No Slowdown",
    SPEAR_Gravity = "Spear Gravity",
    AIM_UseRMB = "Use RMB to aim",
    CAM_ShiftLock = "Shift Lock (auto face camera)",
    Destroyed = "Solid UI Mode (No Transparency)",
    AUTO_AttackRange = "Attack Range",
    AIM_FOV = "FOV Size (aim radius on screen)",
    KILLER_NoPalletStun = "Remove Palletwrong (All)",
    CAM_ThirdPerson = "Third Person (Killer only)",
    CAM_InfinityZoom = "Infinity Zoom Out",
    AntiFallDamage = "Anti Fall Damage",
    InvisibleNotVisual = "Invisible Not Visual",
    InvisibleSpeed = "Invisible Speed",
    AntiAFK = "Anti AFK",
    BypassGate = "Bypass Gate",
    HITBOX_Enabled = "Hitbox Expand",
    TOF_SilentAim = "Silent Aim Twist Of Fate",
    TOF_Laser = "ToF Laser",
    TOF_WallCheck = "ToF Wall Check",
    TOF_BlockKnocked = "ToF Block When Knocked",
    TOF_TargetMode = "ToF Target Mode",
    TOF_Key = "Silent Aim Key",
    FLASH_SilentAim = "Silent Aim Flashlight",
    FLASH_Laser = "Flashlight Laser",
    FLASH_TargetPart = "Flashlight Target Part",
    FLASH_Range = "Flashlight Range",
    FLASH_Smooth = "Flashlight Smoothness",
    NO_Fog = "No Fog (remove fog/post effects)",
    NoCutscene = "No Cutscene",
    FLING_Enabled = "Enable Fling",
    AIM_Smooth = "Smoothness",
    SPEAR_Speed = "Spear Speed",
    SPEAR_Aimbot = "Spear Aimbot",
    SURV_FirstPerson = "First Person Camera (Survivor)",
    JumpValue = "Jump Power",
    AUTO_Attack = "Auto Attack",
    BEAT_Survivor = "Beat Survivor (auto exit)",
    SURV_WarnKiller = "Survivor Killer Warning",
    VIS_KystKiller = "Kyst Killer Display",
    VIS_SpectatorCounter = "Enable Spectator Counter",
    VIS_KillerPerks = "Killer Perks Display",
    VIS_PredictMap = "Predict Map",
    VIS_HideSurvivorIcon = "Hide Survivor Icon",
    VIS_ShowPingFPS = "Show Ping & FPS",
    VIS_ShowHookCounter = "Show Hook Counter",
}

function KYS_LoadConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" then name = "Default" end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if readfile and isfile and isfile(path) then
            local data = HttpService:JSONDecode(readfile(path))
            for key, value in pairs(data) do
                VD[key] = value
                -- Sync to UI visual state if mapping exists
                local flagName = VD_To_Flag[key]
                if flagName and Window and Window.ConfigElements and Window.ConfigElements[flagName] then
                    pcall(function()
                        local elem = Window.ConfigElements[flagName]
                        if elem.Set then elem:Set(value) end
                    end)
                end
            end
            if getgenv().KYS_SyncLoadedFeatures then pcall(getgenv().KYS_SyncLoadedFeatures) end
        end
    end)
end

function KYS_DeleteConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" or name == "Default" then return end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if isfile and isfile(path) and delfile then
            delfile(path)
            print("[VD Config] Deleted:", name)
        end
    end)
end

-- Auto-load dimatikan: config hanya dimuat saat user memilih Load manual dari UI.

-- =====================================================
-- SAVE ORIGINAL LIGHTING
-- =====================================================
local originalLighting = {
    Brightness     = Lighting.Brightness,
    ClockTime      = Lighting.ClockTime,
    FogEnd         = Lighting.FogEnd,
    FogStart       = Lighting.FogStart,
    GlobalShadows  = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient
}
do
    local atm  = Lighting:FindFirstChildOfClass("Atmosphere")
    local blur = Lighting:FindFirstChildOfClass("BlurEffect")
    local cc   = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    local sr   = Lighting:FindFirstChildOfClass("SunRaysEffect")
    if atm then
        originalLighting.Atmosphere = {
            Density = atm.Density,
            Offset = atm.Offset,
            Glare = atm.Glare,
            Haze = atm
                .Haze
        }
    end
    if blur then originalLighting.Blur = { Size = blur.Size } end
    if cc then originalLighting.ColorCorrection = { Enabled = cc.Enabled } end
    if sr then originalLighting.SunRays = { Enabled = sr.Enabled } end
end

-- =====================================================
-- WEATHER ENGINE
-- =====================================================
getgenv().VD_CurrentSky = nil
getgenv().VD_ParticleAnchor = nil

local KYS_WeatherPresets = {
    ["Default"] = {},
    ["Christmas (Snow)"] = {
        Lighting = { FogColor = Color3.fromRGB(150, 180, 220), FogEnd = 200, ClockTime = 8, OutdoorAmbient = Color3.fromRGB(100, 120, 150) },
        Atmosphere = { Density = 0.5, Color = Color3.fromRGB(180, 200, 220), Decay = Color3.fromRGB(150, 180, 220), Haze = 5, Glare = 0 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)), Size = NumberSequence.new(1.5), Rate = 150, Speed = NumberRange.new(15, 25), Lifetime = NumberRange.new(4, 6), EmissionDirection = Enum.NormalId.Bottom, RotSpeed = NumberRange.new(-45, 45) }
    },
    ["Heavy Rain (Storm)"] = {
        Lighting = { FogColor = Color3.fromRGB(50, 50, 60), FogEnd = 150, OutdoorAmbient = Color3.fromRGB(40, 40, 50), Brightness = 0.2, ClockTime = 12 },
        CC = { TintColor = Color3.fromRGB(150, 150, 180), Contrast = 0.2, Saturation = -0.5 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", AnchorSize = Vector3.new(260, 1, 260), CameraOffset = Vector3.new(0, 38, -18), Squash = NumberSequence.new(16), Color = ColorSequence.new(Color3.fromRGB(235, 245, 255)), Size = NumberSequence.new(1.25), Rate = 2600, Speed = NumberRange.new(110, 145), Lifetime = NumberRange.new(0.85, 1.25), EmissionDirection = Enum.NormalId.Bottom, Transparency = NumberSequence.new(0), Acceleration = Vector3.new(-18, -75, 0), SpreadAngle = Vector2.new(3, 3), LightEmission = 1 }
    },
    ["Autumn (Musim Gugur)"] = {
        Lighting = { FogColor = Color3.fromRGB(200, 150, 80), FogEnd = 500, OutdoorAmbient = Color3.fromRGB(180, 140, 70), ClockTime = 16.5 },
        CC = { TintColor = Color3.fromRGB(255, 220, 180), Contrast = 0.1, Saturation = 0.2 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", AnchorSize = Vector3.new(210, 1, 210), CameraOffset = Vector3.new(0, 28, -16), Squash = NumberSequence.new(3.2), Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 45)), ColorSequenceKeypoint.new(0.45, Color3.fromRGB(235, 95, 20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 45, 10)) }), Size = NumberSequence.new(2.05), Rate = 360, Speed = NumberRange.new(8, 15), Lifetime = NumberRange.new(6, 10), EmissionDirection = Enum.NormalId.Bottom, Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-220, 220), Transparency = NumberSequence.new(0), Acceleration = Vector3.new(18, -8, 6), SpreadAngle = Vector2.new(38, 38), LightEmission = 0.6 }
    },
    ["Cherry Blossom (Sakura)"] = {
        Lighting = { FogColor = Color3.fromRGB(255, 200, 220), FogEnd = 600, OutdoorAmbient = Color3.fromRGB(255, 180, 200), ClockTime = 9 },
        CC = { TintColor = Color3.fromRGB(255, 230, 240), Saturation = 0.3 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", AnchorSize = Vector3.new(160, 1, 160), CameraOffset = Vector3.new(0, 25, -18), Squash = NumberSequence.new(1.2), Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 235)), ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 165, 205)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 180)) }), Size = NumberSequence.new(1.25), Rate = 190, Speed = NumberRange.new(5, 10), Lifetime = NumberRange.new(7, 10), EmissionDirection = Enum.NormalId.Bottom, Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-170, 170), Transparency = NumberSequence.new(0), Acceleration = Vector3.new(14, -5, 5), SpreadAngle = Vector2.new(32, 32), LightEmission = 0.55 }
    },
    ["Sunset (Golden Hour)"] = {
        Lighting = { FogColor = Color3.fromRGB(255, 120, 50), FogEnd = 1200, OutdoorAmbient = Color3.fromRGB(200, 100, 50), ClockTime = 17.5, Brightness = 1.5 },
        CC = { TintColor = Color3.fromRGB(255, 200, 150), Contrast = 0.2, Saturation = 0.4 }
    },
    ["Blood Moon (Spooky)"] = {
        Lighting = { FogColor = Color3.fromRGB(150, 10, 10), FogEnd = 500, OutdoorAmbient = Color3.fromRGB(80, 0, 0), ClockTime = 0, Brightness = 0.3 },
        CC = { TintColor = Color3.fromRGB(255, 50, 50), Contrast = 0.4, Saturation = 0.5 },
        Atmosphere = { Density = 0.35, Color = Color3.fromRGB(255, 0, 0), Decay = Color3.fromRGB(100, 0, 0), Haze = 5, Glare = 0 }
    },
    ["Toxic Wasteland"] = {
        Lighting = { FogColor = Color3.fromRGB(80, 150, 50), FogEnd = 250, OutdoorAmbient = Color3.fromRGB(50, 120, 40), ClockTime = 12, Brightness = 1 },
        CC = { TintColor = Color3.fromRGB(150, 255, 150), Contrast = 0.1, Saturation = 0.3 },
        Particle = { Texture = "rbxasset://textures/particles/sparkles_main.dds", Color = ColorSequence.new(Color3.fromRGB(100, 255, 50)), Size = NumberSequence.new(0.8), Rate = 200, Speed = NumberRange.new(50, 60), Lifetime = NumberRange.new(2, 3), EmissionDirection = Enum.NormalId.Bottom, Transparency = NumberSequence.new(0.5) }
    },
    ["Vaporwave (Synthwave)"] = {
        Lighting = { FogColor = Color3.fromRGB(200, 50, 255), FogEnd = 500, OutdoorAmbient = Color3.fromRGB(150, 0, 200), ClockTime = 20, Brightness = 1 },
        CC = { TintColor = Color3.fromRGB(255, 100, 255), Contrast = 0.3, Saturation = 0.5 }
    },
    ["Midnight (Pitch Black)"] = {
        Lighting = { FogColor = Color3.fromRGB(0, 0, 0), FogEnd = 100, OutdoorAmbient = Color3.fromRGB(0, 0, 0), Brightness = 0, ClockTime = 0 },
        CC = { TintColor = Color3.fromRGB(50, 50, 50), Contrast = 0.5, Saturation = -0.8 }
    }
}

function VD_ApplyWeather(themeName)
    local theme = KYS_WeatherPresets[themeName]
    if not theme then theme = KYS_WeatherPresets["Default"] end
    
    -- Cleanup old sky, cc, atm
    if getgenv().VD_CurrentSky and getgenv().VD_CurrentSky.Parent then getgenv().VD_CurrentSky:Destroy() end
    getgenv().VD_CurrentSky = nil
    
    if getgenv().VD_WeatherCC and getgenv().VD_WeatherCC.Parent then getgenv().VD_WeatherCC:Destroy() end
    getgenv().VD_WeatherCC = nil
    
    if getgenv().VD_WeatherAtmosphere and getgenv().VD_WeatherAtmosphere.Parent then getgenv().VD_WeatherAtmosphere:Destroy() end
    getgenv().VD_WeatherAtmosphere = nil
    
    -- Apply Atmosphere
    if theme.Atmosphere then
        local atm = Instance.new("Atmosphere")
        atm.Name = "VD_WeatherAtmosphere"
        for k, v in pairs(theme.Atmosphere) do pcall(function() atm[k] = v end) end
        atm.Parent = Lighting
        getgenv().VD_WeatherAtmosphere = atm
    end
    
    -- Apply ColorCorrection
    if theme.CC then
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "VD_WeatherCC"
        for k, v in pairs(theme.CC) do pcall(function() cc[k] = v end) end
        cc.Parent = Lighting
        getgenv().VD_WeatherCC = cc
    end
    
    -- Apply Lighting
    if theme.Lighting then
        for k, v in pairs(theme.Lighting) do
            pcall(function() Lighting[k] = v end)
        end
    else
        -- Restore original lighting if no specific lighting is set, but respect Fullbright & NoFog
        if not VD.Fullbright and not VD.NO_Fog then
            Lighting.Brightness = originalLighting.Brightness
            Lighting.ClockTime = originalLighting.ClockTime
            Lighting.FogEnd = originalLighting.FogEnd
            Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        end
    end
    
    -- Re-apply Fullbright & NoFog if they are on
    if VD.Fullbright then pcall(VD_SetFullbright, true) end
    if VD.NO_Fog then pcall(VD_SetNoFog, true) end

    -- Setup Particles
    if getgenv().VD_ParticleAnchor and getgenv().VD_ParticleAnchor.Parent then
        getgenv().VD_ParticleAnchor:Destroy()
    end
    getgenv().VD_ParticleAnchor = nil
    
    if theme.Particle then
        local anchor = Instance.new("Part")
        anchor.Name = "VD_WeatherAnchor"
        anchor.Transparency = 0.99 -- Almost invisible but guarantees rendering
        anchor.CanCollide = false
        anchor.Anchored = true
        anchor.Size = theme.Particle.AnchorSize or Vector3.new(120, 1, 120)
        anchor:SetAttribute("VD_CameraOffsetX", theme.Particle.CameraOffset and theme.Particle.CameraOffset.X or 0)
        anchor:SetAttribute("VD_CameraOffsetY", theme.Particle.CameraOffset and theme.Particle.CameraOffset.Y or 30)
        anchor:SetAttribute("VD_CameraOffsetZ", theme.Particle.CameraOffset and theme.Particle.CameraOffset.Z or 0)
        
        local pe = Instance.new("ParticleEmitter")
        pe.Name = "VD_WeatherEmitter"
        
        -- Default important settings for Weather Emitters
        pe.Enabled = true
        pe.EmissionDirection = Enum.NormalId.Bottom
        pe.LockedToPart = false
        pe.ZOffset = 2 -- Make it render over most things
        pe.LightEmission = 0.25
        pe.SpreadAngle = Vector2.new(10, 10)
        pcall(function() pe.Shape = Enum.ParticleEmitterShape.Box end)
        pcall(function() pe.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
        
        for k, v in pairs(theme.Particle) do
            if k ~= "AnchorSize" and k ~= "CameraOffset" then
                pcall(function() pe[k] = v end)
            end
        end
        
        pe.Parent = anchor
        if themeName == "Heavy Rain (Storm)" then
            local nearRain = Instance.new("ParticleEmitter")
            nearRain.Name = "VD_WeatherRainNearEmitter"
            nearRain.Enabled = true
            nearRain.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            nearRain.Color = ColorSequence.new(Color3.fromRGB(230, 240, 255))
            nearRain.Transparency = NumberSequence.new(0)
            nearRain.Size = NumberSequence.new(1.65)
            nearRain.Squash = NumberSequence.new(20)
            nearRain.Rate = 1800
            nearRain.Speed = NumberRange.new(70, 95)
            nearRain.Lifetime = NumberRange.new(0.75, 1.05)
            nearRain.EmissionDirection = Enum.NormalId.Bottom
            nearRain.Acceleration = Vector3.new(-24, -90, 0)
            nearRain.SpreadAngle = Vector2.new(2, 2)
            nearRain.LockedToPart = false
            nearRain.ZOffset = 6
            nearRain.LightEmission = 1
            pcall(function() nearRain.Shape = Enum.ParticleEmitterShape.Box end)
            pcall(function() nearRain.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
            nearRain.Parent = anchor

            local rainSheet = Instance.new("ParticleEmitter")
            rainSheet.Name = "VD_WeatherRainSheetEmitter"
            rainSheet.Enabled = true
            rainSheet.Texture = "rbxasset://textures/particles/smoke_main.dds"
            rainSheet.Color = ColorSequence.new(Color3.fromRGB(170, 195, 225))
            rainSheet.Transparency = NumberSequence.new(0.45)
            rainSheet.Size = NumberSequence.new(3.2)
            rainSheet.Squash = NumberSequence.new(7)
            rainSheet.Rate = 650
            rainSheet.Speed = NumberRange.new(45, 65)
            rainSheet.Lifetime = NumberRange.new(1.0, 1.5)
            rainSheet.EmissionDirection = Enum.NormalId.Bottom
            rainSheet.Acceleration = Vector3.new(-14, -55, 0)
            rainSheet.SpreadAngle = Vector2.new(8, 8)
            rainSheet.LockedToPart = false
            rainSheet.ZOffset = 3
            rainSheet.LightEmission = 0.35
            pcall(function() rainSheet.Shape = Enum.ParticleEmitterShape.Box end)
            pcall(function() rainSheet.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
            rainSheet.Parent = anchor
        elseif themeName == "Autumn (Musim Gugur)" then
            local bigLeaves = Instance.new("ParticleEmitter")
            bigLeaves.Name = "VD_WeatherAutumnBigLeavesEmitter"
            bigLeaves.Enabled = true
            bigLeaves.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            bigLeaves.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 205, 55)),
                ColorSequenceKeypoint.new(0.35, Color3.fromRGB(230, 95, 25)),
                ColorSequenceKeypoint.new(0.7, Color3.fromRGB(165, 65, 20)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 40, 8))
            })
            bigLeaves.Transparency = NumberSequence.new(0)
            bigLeaves.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 2.4),
                NumberSequenceKeypoint.new(0.5, 3.1),
                NumberSequenceKeypoint.new(1, 1.8)
            })
            bigLeaves.Squash = NumberSequence.new(4.5)
            bigLeaves.Rate = 150
            bigLeaves.Speed = NumberRange.new(5, 10)
            bigLeaves.Lifetime = NumberRange.new(8, 12)
            bigLeaves.EmissionDirection = Enum.NormalId.Bottom
            bigLeaves.Rotation = NumberRange.new(0, 360)
            bigLeaves.RotSpeed = NumberRange.new(-280, 280)
            bigLeaves.Acceleration = Vector3.new(24, -5, 10)
            bigLeaves.SpreadAngle = Vector2.new(45, 45)
            bigLeaves.LockedToPart = false
            bigLeaves.ZOffset = 5
            bigLeaves.LightEmission = 0.65
            pcall(function() bigLeaves.Shape = Enum.ParticleEmitterShape.Box end)
            pcall(function() bigLeaves.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume end)
            bigLeaves.Parent = anchor
        end
        anchor.Parent = workspace
        getgenv().VD_ParticleAnchor = anchor
        
        -- FORCE PRELOAD FOR MOBILE CLIENTS
        if theme.Particle.Texture then
            task.spawn(function()
                pcall(function()
                    game:GetService("ContentProvider"):PreloadAsync({pe})
                end)
            end)
        end
        
        -- Initial position
        pcall(VD_UpdateWeatherAnchor)
    end
end

function VD_UpdateWeatherAnchor()
    local anchor = getgenv().VD_ParticleAnchor
    if not anchor then return end
    
    -- Keep the emitter in Workspace; ParticleEmitters under CurrentCamera can be culled on some clients.
    if anchor.Parent ~= workspace then
        pcall(function() anchor.Parent = workspace end)
    end
    
    local camera = workspace.CurrentCamera
    if camera then
        local offset = Vector3.new(
            anchor:GetAttribute("VD_CameraOffsetX") or 0,
            anchor:GetAttribute("VD_CameraOffsetY") or 30,
            anchor:GetAttribute("VD_CameraOffsetZ") or 0
        )
        local worldPos = camera.CFrame.Position
            + camera.CFrame.RightVector * offset.X
            + Vector3.new(0, offset.Y, 0)
            + camera.CFrame.LookVector * math.abs(offset.Z)
        anchor.CFrame = CFrame.new(worldPos)
        return
    end

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        local head = char.Head
        anchor.CFrame = CFrame.new(head.Position + Vector3.new(0, 30, 0))
    end
end

-- =====================================================
-- CHARACTER REFS
-- =====================================================
-- Character, Humanoid, and Root are declared at the top of __KysHub_Init_Main__

function updateChar(char)
    Character = char or LocalPlayer.Character
    if Character then
        task.spawn(function()
            Humanoid = Character:WaitForChild("Humanoid", 5)
            Root     = Character:WaitForChild("HumanoidRootPart", 5)
        end)
    else
        Humanoid, Root = nil, nil
    end
end
updateChar()
LocalPlayer.CharacterAdded:Connect(updateChar)
LocalPlayer.CharacterRemoving:Connect(function(char)
    if char == Character or char == LocalPlayer.Character then
        Character, Humanoid, Root = nil, nil, nil
    end
end)

-- =====================================================
-- HELPERS: TEAM / COLORS
-- =====================================================
local TeamColor  = Color3.fromRGB(0, 255, 0)
local EnemyColor = Color3.fromRGB(255, 0, 0)

function isTeammate(player)
    return LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team
end

function getPlayerColor(player)
    return isTeammate(player) and TeamColor or EnemyColor
end

-- =====================================================
-- CENTRALIZED METAMETHOD HOOK (__namecall)
-- =====================================================
local KYS_WorldReg
getgenv().KYS_oldNamecall = nil

function setupAntiFail()
    if getgenv().KYS_AntiFailHooked then return end
    getgenv().KYS_AntiFailHooked = true
    task.spawn(function()
        local ok, err = pcall(function()
            local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
            local Events  = ReplicatedStorage:WaitForChild("Events", 10)
            if not Remotes then
                warn("AntiFail: Remotes not found")
                return
            end
-- PENTING: Cache getgenv() sekali saja sebagai upvalue lokal.
-- Memanggil getgenv() di dalam __namecall hook bisa trigger namecall lagi
-- → infinite recursion → stack overflow → force close.
            local _genv = getgenv()

            _genv.KYS_oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()

                if VD.AntiFallDamage and method == "FireServer" then
                    local ok, name = pcall(function() return self.Name:lower() end)
                    if ok and (name:find("falldamage") or name:find("fall") or name:find("ragdollfall")) then
                        return
                    end
                end

                if VD.KILLER_InfFrenzy and method == "FireServer" then
                    local ok, name = pcall(function() return self.Name end)
                    if ok and (name == "Deactivatefromclient" or name == "PowerDoneDeactivating") then
                        return
                    end
                end

                if VD.KILLER_SilentAimFlask and method == "FireServer" then
                    local ok, name = pcall(function() return self.Name end)
                    if ok and name == "ThrowFlask" then
                        local args = {...}
                        local closest = nil
                        local minDst = math.huge
                        local lp = game:GetService("Players").LocalPlayer
                        local myPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
                        
                        if myPos then
                            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                    if not v.Character:GetAttribute("IsKiller") then
                                        local dst = (v.Character.HumanoidRootPart.Position - myPos).Magnitude
                                        if dst < minDst then
                                            minDst = dst
                                            closest = v
                                        end
                                    end
                                end
                            end
                        end
                        
                        if closest then
                            local targetPos = closest.Character.HumanoidRootPart.Position
                            -- args[1] = LookVector, args[2] = OriginPosition
                            if args[2] and typeof(args[2]) == "Vector3" then
                                args[1] = (targetPos - args[2]).Unit
                            end

                            setnamecallmethod(method)
                            return _genv.KYS_oldNamecall(self, unpack(args))
                        end
                    end
                end

                if method == "FireServer" and not checkcaller() then
                    local flashRemote = _genv.KYS_FlashlightActivateRemote
                    if flashRemote and self == flashRemote and _genv.KYS_SetFlashlightAimActive then
                        local args = { ... }
                        pcall(_genv.KYS_SetFlashlightAimActive, args[2] == true, args[1])
                    end
                end

                if _genv.KYS_oldNamecall then
                    return _genv.KYS_oldNamecall(self, ...)
                end
            end)

            print("AntiFail: hooked")
        end)
        if not ok then warn("AntiFail setup failed:", err) end
    end)
end
setupAntiFail()

-- =====================================================
-- FIRST PERSON CAMERA (Survivor)
-- =====================================================
getgenv().KYS_fpWasSet = false
getgenv().KYS_fpOriginal = nil

function RestoreFirstPersonCamera()
    if not getgenv().KYS_fpWasSet then return end
    getgenv().KYS_fpWasSet = false

    pcall(function()
        if getgenv().KYS_fpOriginal then
            LocalPlayer.CameraMode = getgenv().KYS_fpOriginal.CameraMode or Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = getgenv().KYS_fpOriginal.CameraMaxZoomDistance or 128
            LocalPlayer.CameraMinZoomDistance = getgenv().KYS_fpOriginal.CameraMinZoomDistance or 0.5
        else
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = 128
        end
    end)

    local char = LocalPlayer.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then head.LocalTransparencyModifier = 0 end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Accessory") then
                local handle = obj:FindFirstChild("Handle")
                if handle then handle.LocalTransparencyModifier = 0 end
            end
        end
    end

    getgenv().KYS_fpOriginal = nil
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        if VD.SURV_FirstPerson then
            local isSurvivor = LocalPlayer.Team and LocalPlayer.Team.Name == "Survivors"
            if isSurvivor then
                if not getgenv().KYS_fpWasSet then
                    getgenv().KYS_fpOriginal = {
                        CameraMode = LocalPlayer.CameraMode,
                        CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance,
                        CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance,
                    }
                end

                -- Paksa LockFirstPerson hanya saat toggle aktif agar game tidak bisa override
                if LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
                    LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
                end
                if LocalPlayer.CameraMaxZoomDistance ~= 0 then
                    LocalPlayer.CameraMaxZoomDistance = 0
                end

                -- Sembunyikan kepala & aksesoris wajah agar tidak menghalangi pandangan
                -- (LocalTransparencyModifier hanya berlaku untuk kita sendiri, orang lain tetap melihat kepala kita)
                local char = LocalPlayer.Character
                if char then
                    local head = char:FindFirstChild("Head")
                    if head then
                        head.LocalTransparencyModifier = 1
                    end
                    -- Sembunyikan juga aksesoris yang menempel di kepala (hat, face, hair)
                    for _, obj in ipairs(char:GetChildren()) do
                        if obj:IsA("Accessory") then
                            local handle = obj:FindFirstChild("Handle")
                            if handle then
                                handle.LocalTransparencyModifier = 1
                            end
                        end
                    end
                end

                getgenv().KYS_fpWasSet = true
            elseif getgenv().KYS_fpWasSet then
                RestoreFirstPersonCamera()
            end
        elseif getgenv().KYS_fpWasSet then
            RestoreFirstPersonCamera()
        end
    end)
end)

-- =====================================================
-- VISUAL HIGHLIGHT ESP V2 (Player + World)
-- Stabil, anti double nametag, anti duplicate highlight, dan safe re-execute.
-- Kontrol ditambahkan ke tab Visual lewat getgenv().KYS_AddVisualESPControls.
-- =====================================================
do
    if getgenv().KYS_VD_VisualESP_Cleanup then
        pcall(getgenv().KYS_VD_VisualESP_Cleanup)
    end

    local LP = LocalPlayer
    local KYS_Dead = false
    local KYS_ControlsAdded = false

    local KYS_ESPState = {
        PlayerMasterESP = false,
        WorldMasterESP = false,
        ESPFillTransparency = 0.95,
        ESPOutlineTransparency = 0.3,
        ESPTextSize = 12,

        SurvivorESP = false,
        KillerESP = false,
        SpectatorESP = false,
        Nametags = false,
        DistanceESP = false,
        SurvivorItemsESP = false,

        SurvivorColor = Color3.fromRGB(0, 255, 0),
        KillerColor = Color3.fromRGB(255, 0, 0),
        SpectatorColor = Color3.fromRGB(255, 255, 255),

        GeneratorESP = false,
        HookESP = false,
        GateESP = false,
        WindowESP = false,
        PalletESP = false,
        SCPZombieESP = false,
        WorldNametags = false,
        WorldDistanceESP = false,

        GeneratorColor = Color3.fromRGB(0, 170, 255),
        HookColor = Color3.fromRGB(255, 0, 0),
        GateColor = Color3.fromRGB(255, 225, 0),
        WindowColor = Color3.fromRGB(255, 255, 255),
        PalletColor = Color3.fromRGB(255, 140, 0),
        SCPZombieColor = Color3.fromRGB(128, 0, 128),
    }

    getgenv().KYS_VD_VisualESP_State = KYS_ESPState

    KYS_WorldReg = {
        Generator = {},
        Hook = {},
        Gate = {},
        Window = {},
        Palletwrong = {},
        SCPZombie = {},
    }

    local KYS_MapAdd, KYS_MapRem = {}, {}
    local KYS_PlayerConns = {}
    local KYS_Connections = {}
    local KYS_PalletState = setmetatable({}, { __mode = "k" })
    local KYS_WindowState = setmetatable({}, { __mode = "k" })
    local KYS_InstanceIds = setmetatable({}, { __mode = "k" })
    local KYS_KystId = 0
    local KYS_PlayerLoopThread = nil
    local KYS_WorldLoopThread = nil
    local KYS_ESPFolder = nil

    local KYS_DisplayNames = {
        ["Motion Tracker"] = true,
        ["Gate"] = true,
        ["Flashlight"] = true,
        ["Bandage"] = true,
        ["Parrying Dagger"] = true,
        ["Adrenaline Shot"] = true,
        ["Twist of Fate"] = true,
        ["Shadow Clone"] = true,
        ["Holy Water"] = true,
        ["WaxBound Candle"] = true,
        ["Riot Shield"] = true,
        ["Emperor"] = true,
        ["AWP"] = true,
    }

    local function KYS_Alive(inst)
        if not inst then return false end
        local ok, parent = pcall(function() return inst.Parent end)
        return ok and parent ~= nil
    end

    local function KYS_Clamp(n, lo, hi)
        n = tonumber(n) or lo
        if n < lo then return lo end
        if n > hi then return hi end
        return n
    end

    local function KYS_PlayerKey(player)
        local id = player and player.UserId
        if id and id ~= 0 then return tostring(id) end
        return tostring(player and player.Name or "Unknown")
    end

    local function KYS_EspId(inst)
        if not inst then return "nil" end
        local id = KYS_InstanceIds[inst]
        if id then return id end
        KYS_KystId = KYS_KystId + 1
        id = tostring(KYS_KystId)
        KYS_InstanceIds[inst] = id
        return id
    end

    local function KYS_GetESPParent()
        local okCore, core = pcall(function() return game:GetService("CoreGui") end)
        if okCore and core then return core end
        if gethui then
            local okHui, hui = pcall(gethui)
            if okHui and hui then return hui end
        end
        local playerGui = LP and LP:FindFirstChildOfClass("PlayerGui")
        if playerGui then return playerGui end
        return Workspace
    end

    local function KYS_GetESPFolder()
        if KYS_ESPFolder and KYS_ESPFolder.Parent then
            return KYS_ESPFolder
        end

        local parent = KYS_GetESPParent()
        local old = parent:FindFirstChild("KysHub_VisualESP") or parent:FindFirstChild("ZiaanHub_ESP")
        if old then old:Destroy() end

        local folder = Instance.new("Folder")
        folder.Name = "KysHub_VisualESP"
        folder.Parent = parent
        KYS_ESPFolder = folder
        return folder
    end

    local function KYS_ClearPrefix(prefix, keepName)
        local folder = KYS_GetESPFolder()
        local keptExact = false
        for _, child in ipairs(folder:GetChildren()) do
            if child.Name:sub(1, #prefix) == prefix then
                if child.Name == keepName and not keptExact then
                    keptExact = true
                else
                    child:Destroy()
                end
            end
        end
    end

    local function KYS_SafeNotify(title, content, duration)
        pcall(function()
            if Window and Window.Notify then
                Window:Notify({
                    Title = title,
                    Content = content,
                    Duration = duration or 2,
                    Icon = "lucide:info",
                })
            end
        end)
    end

    local function KYS_ValidPart(part)
        return part and KYS_Alive(part) and part:IsA("BasePart")
    end

    local function KYS_FirstBasePart(inst)
        if not KYS_Alive(inst) then return nil end
        if inst:IsA("BasePart") then return inst end
        if inst:IsA("Model") then
            if inst.PrimaryPart and inst.PrimaryPart:IsA("BasePart") and KYS_Alive(inst.PrimaryPart) then
                return inst.PrimaryPart
            end
            local part = inst:FindFirstChildWhichIsA("BasePart", true)
            if KYS_ValidPart(part) then return part end
        end
        if inst:IsA("Tool") then
            local handle = inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart")
            if KYS_ValidPart(handle) then return handle end
        end
        return nil
    end

    local function KYS_GetRole(player)
        local teamName = player.Team and player.Team.Name and player.Team.Name:lower() or ""
        if teamName:find("killer") then return "Killer" end
        if teamName:find("survivor") then return "Survivor" end
        if teamName:find("spect") then return "Spectator" end
        return "Survivor"
    end

    local function KYS_PlayerRoleEnabled(player)
        local role = KYS_GetRole(player)
        if role == "Killer" then return KYS_ESPState.KillerESP end
        if role == "Spectator" then return KYS_ESPState.SpectatorESP end
        return KYS_ESPState.SurvivorESP
    end

    local function KYS_PlayerColor(player)
        local role = KYS_GetRole(player)
        if role == "Killer" then return KYS_ESPState.KillerColor end
        if role == "Spectator" then return KYS_ESPState.SpectatorColor end
        return KYS_ESPState.SurvivorColor
    end

    getgenv().KYS_VD_VisualESP_HasPlayerText = function(player)
        if not player or player == LP then return false end
        return KYS_ESPState.PlayerMasterESP
            and KYS_PlayerRoleEnabled(player)
            and (KYS_ESPState.Nametags or KYS_ESPState.DistanceESP)
    end

    local function KYS_EnsureHighlight(name, adornee, color, isPlayer)
        if not (adornee and KYS_Alive(adornee)) then return nil end
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix(name, name)

        local hl = folder:FindFirstChild(name)
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = name
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = folder
        end

        hl.Adornee = adornee
        hl.FillColor = color
        hl.OutlineColor = color
        if isPlayer then
            hl.FillTransparency = KYS_ESPState.ESPFillTransparency
            hl.OutlineTransparency = KYS_ESPState.ESPOutlineTransparency
        else
            hl.FillTransparency = 0.98
            hl.OutlineTransparency = 0.5
        end
        hl.Enabled = true
        return hl
    end

    local function KYS_DestroyChild(name)
        local folder = KYS_GetESPFolder()
        local child = folder:FindFirstChild(name)
        if child then child:Destroy() end
    end

    local function KYS_ClearPlayerESP(player)
        if not player or player == LP then return end
        local key = KYS_PlayerKey(player)
        KYS_DestroyChild("KYS_PlayerHL_" .. key)
        KYS_DestroyChild("KYS_PlayerTag_" .. key)
        KYS_DestroyChild("KYS_PlayerItem_" .. key)
    end

    local function KYS_ClearAllPlayerESP()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                KYS_ClearPlayerESP(player)
            end
        end
    end

    local function KYS_GetSurvivorItem(player)
        local character = player.Character
        if not character then return nil end
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("Tool") or obj:IsA("Accessory") or obj:IsA("Model") then
                if KYS_DisplayNames[obj.Name] then
                    return obj.Name
                end
            end
        end
        return nil
    end

    local function KYS_GetItemImageId(itemName)
        local itemsFolder = ReplicatedStorage:FindFirstChild("Items")
        if not itemsFolder then return nil end
        local itemObj = itemsFolder:FindFirstChild(itemName)
        if not itemObj then return nil end

        if itemObj:IsA("Decal") or itemObj:IsA("Texture") then return itemObj.Texture end
        local texture = itemObj:FindFirstChildWhichIsA("Decal", true) or itemObj:FindFirstChildWhichIsA("Texture", true)
        if texture then return texture.Texture end
        local namedTexture = itemObj:FindFirstChild("Texture", true)
        if namedTexture and (namedTexture:IsA("Decal") or namedTexture:IsA("Texture")) then
            return namedTexture.Texture
        end
        return nil
    end

    local function KYS_SetBillboardLine(parent, index, count, data)
        local label = parent:FindFirstChild("Line" .. index)
        if not label then
            label = Instance.new("TextLabel")
            label.Name = "Line" .. index
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.Font = Enum.Font.Gotham
            label.TextStrokeTransparency = 0.65
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.Parent = parent
        end
        label.Size = UDim2.new(1, 0, 1 / count, 0)
        label.Position = UDim2.new(0, 0, (index - 1) / count, 0)
        label.TextSize = KYS_ESPState.ESPTextSize
        label.TextColor3 = data.Color
        label.Text = data.Text
    end

    local function KYS_PruneBillboardLines(parent, count)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("TextLabel") then
                local index = tonumber(child.Name:match("%d+"))
                if index and index > count then
                    child:Destroy()
                end
            end
        end
    end

    local function KYS_UpdatePlayerTag(player, character, head, color)
        local key = KYS_PlayerKey(player)
        local tagName = "KYS_PlayerTag_" .. key
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix("KYS_PlayerTag_" .. key, tagName)

        if not KYS_ValidPart(head) then
            KYS_DestroyChild(tagName)
            return
        end

        local lines = {}
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
        local distanceText = ""
        if KYS_ESPState.DistanceESP and root and targetRoot then
            distanceText = "[" .. tostring(math.floor((root.Position - targetRoot.Position).Magnitude)) .. "m]"
        end

        local nameText = KYS_ESPState.Nametags and player.Name or ""
        local mainLine = ""
        if nameText ~= "" and distanceText ~= "" then
            mainLine = nameText .. " " .. distanceText
        elseif nameText ~= "" then
            mainLine = nameText
        elseif distanceText ~= "" then
            mainLine = distanceText
        end

        if mainLine ~= "" then
            table.insert(lines, { Text = mainLine, Color = color })
        end

        if #lines == 0 then
            KYS_DestroyChild(tagName)
            return
        end

        local tag = folder:FindFirstChild(tagName)
        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Name = tagName
            tag.AlwaysOnTop = true
            tag.LightInfluence = 0
            tag.MaxDistance = 0
            tag.Parent = folder
        end

        tag.Adornee = head
        tag.Enabled = true
        tag.Size = UDim2.new(0, 220, 0, #lines * 20)
        tag.StudsOffset = Vector3.new(0, 2.65, 0)

        for i, data in ipairs(lines) do
            KYS_SetBillboardLine(tag, i, #lines, data)
        end
        KYS_PruneBillboardLines(tag, #lines)
    end

    local function KYS_UpdatePlayerItemIcon(player, torso)
        local key = KYS_PlayerKey(player)
        local iconName = "KYS_PlayerItem_" .. key
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix("KYS_PlayerItem_" .. key, iconName)

        if not KYS_ValidPart(torso) then
            KYS_DestroyChild(iconName)
            return
        end

        local itemName = KYS_GetSurvivorItem(player)
        local imageId = itemName and KYS_GetItemImageId(itemName) or nil
        if not imageId then
            KYS_DestroyChild(iconName)
            return
        end

        local icon = folder:FindFirstChild(iconName)
        if not icon then
            icon = Instance.new("BillboardGui")
            icon.Name = iconName
            icon.AlwaysOnTop = true
            icon.LightInfluence = 0
            icon.MaxDistance = 0
            icon.Size = UDim2.fromOffset(20, 20)
            icon.StudsOffset = Vector3.new(0, 0, -1.6)
            icon.Parent = folder

            local image = Instance.new("ImageLabel")
            image.Name = "ImageLabel"
            image.BackgroundTransparency = 1
            image.Size = UDim2.fromScale(1, 1)
            image.Parent = icon
        end

        icon.Adornee = torso
        icon.Enabled = true
        local image = icon:FindFirstChild("ImageLabel")
        if image then image.Image = imageId end
    end

    local KYS_ApplyPlayerESP
    KYS_ApplyPlayerESP = function(player)
        if KYS_Dead or not player or player == LP then return end
        local character = player.Character
        if not (character and KYS_Alive(character)) then
            KYS_ClearPlayerESP(player)
            return
        end

        local key = KYS_PlayerKey(player)
        local enabled = KYS_ESPState.PlayerMasterESP and KYS_PlayerRoleEnabled(player)
        if not enabled then
            KYS_ClearPlayerESP(player)
            return
        end

        local color = KYS_PlayerColor(player)
        local head = character:FindFirstChild("Head")
        local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")

        KYS_EnsureHighlight("KYS_PlayerHL_" .. key, character, color, true)
        KYS_UpdatePlayerTag(player, character, head, color)

        if KYS_GetRole(player) == "Survivor" and KYS_ESPState.SurvivorItemsESP then
            KYS_UpdatePlayerItemIcon(player, torso)
        else
            KYS_DestroyChild("KYS_PlayerItem_" .. key)
        end
    end

    local function KYS_RefreshAllPlayers()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                pcall(KYS_ApplyPlayerESP, player)
            end
        end
    end

    local function KYS_StartPlayerLoop()
        if KYS_PlayerLoopThread then return end
        KYS_PlayerLoopThread = task.spawn(function()
            while not KYS_Dead and KYS_ESPState.PlayerMasterESP do
                KYS_RefreshAllPlayers()
                task.wait(0.25)
            end
            KYS_PlayerLoopThread = nil
        end)
    end

    local function KYS_WatchPlayer(player)
        if player == LP then return end
        if KYS_PlayerConns[player] then
            for _, conn in ipairs(KYS_PlayerConns[player]) do
                if conn then pcall(function() conn:Disconnect() end) end
            end
        end

        KYS_PlayerConns[player] = {}
        table.insert(KYS_PlayerConns[player], player.CharacterAdded:Connect(function(char)
            KYS_ClearPlayerESP(player)
            task.delay(0.15, function()
                if not KYS_Dead then pcall(KYS_ApplyPlayerESP, player) end
            end)
        end))
        table.insert(KYS_PlayerConns[player], player.CharacterRemoving:Connect(function()
            KYS_ClearPlayerESP(player)
        end))
        table.insert(KYS_PlayerConns[player], player:GetPropertyChangedSignal("Team"):Connect(function()
            KYS_ClearPlayerESP(player)
            pcall(KYS_ApplyPlayerESP, player)
        end))

        if player.Character then
            pcall(KYS_ApplyPlayerESP, player)
        end
    end

    local function KYS_UnwatchPlayer(player)
        KYS_ClearPlayerESP(player)
        if KYS_PlayerConns[player] then
            for _, conn in ipairs(KYS_PlayerConns[player]) do
                if conn then pcall(function() conn:Disconnect() end) end
            end
        end
        KYS_PlayerConns[player] = nil
    end

    local function KYS_PickWorldPart(model, cat)
        if not (model and KYS_Alive(model)) then return nil end
        if cat == "Generator" then
            local hitbox = model:FindFirstChild("HitBox", true) or model:FindFirstChild("GeneratorPoint", true)
            if KYS_ValidPart(hitbox) then return hitbox end
        elseif cat == "Palletwrong" then
            local candidates = {
                model:FindFirstChild("HumanoidRootPart", true),
                model:FindFirstChild("PrimaryPartPallet", true),
                model:FindFirstChild("Primary1", true),
                model:FindFirstChild("Primary2", true),
                model:FindFirstChild("PalletPoint", true),
                model:FindFirstChild("PalletPointSlide", true),
            }
            for _, part in ipairs(candidates) do
                if KYS_ValidPart(part) then return part end
            end
        elseif cat == "Window" then
            local vault = model:FindFirstChild("VaultPoint", true) or model:FindFirstChild("VaultTrigger", true)
            if KYS_ValidPart(vault) then return vault end
        elseif cat == "SCPZombie" then
            local root = model:FindFirstChild("HumanoidRootPart", true)
            if KYS_ValidPart(root) then return root end
            local torso = model:FindFirstChild("UpperTorso", true) or model:FindFirstChild("Torso", true)
            if KYS_ValidPart(torso) then return torso end
            return nil
        end
        return KYS_FirstBasePart(model)
    end

    local function KYS_GeneratorLabel(model)
        local pct = tonumber(model:GetAttribute("RepairProgress")) or 0
        if pct >= 0 and pct <= 1.001 then pct = pct * 100 end
        pct = KYS_Clamp(pct, 0, 100)

        local repairers = tonumber(model:GetAttribute("PlayersRepairingCount")) or 0
        local paused = model:GetAttribute("ProgressPaused") == true
        local kickcount = tonumber(model:GetAttribute("kickcount")) or 0
        local abyss50 = model:GetAttribute("Abyss50Triggered") == true

        local parts = { "Gen " .. tostring(math.floor(pct + 0.5)) .. "%" }
        if repairers > 0 then table.insert(parts, "(" .. repairers .. "p)") end
        if paused then table.insert(parts, "Pause") end
        if abyss50 then table.insert(parts, "Warn") end
        if kickcount > 0 then table.insert(parts, "K:" .. kickcount) end

        local hue = KYS_Clamp((pct / 100) * 0.33, 0, 0.33)
        return table.concat(parts, " "), Color3.fromHSV(hue, 1, 1)
    end

    local function KYS_HasBasePart(model)
        if not (model and KYS_Alive(model)) then return false end
        return model:FindFirstChildWhichIsA("BasePart", true) ~= nil
    end

    local function KYS_IsPalletGone(model)
        if not KYS_Alive(model) then return true end
        if not model:IsDescendantOf(Workspace) then return true end
        if KYS_PalletState[model] == "DEST" then return true end
        local ok, destroyed = pcall(function() return model:GetAttribute("Destroyed") end)
        if ok and destroyed == true then return true end
        return not KYS_HasBasePart(model)
    end

    local function KYS_WorldKey(cat, model)
        return "KYS_World_" .. cat .. "_" .. KYS_EspId(model)
    end

    local function KYS_ClearWorldVisual(cat, model)
        if not model then return end
        KYS_DestroyChild(KYS_WorldKey(cat, model) .. "_HL")
        KYS_DestroyChild(KYS_WorldKey(cat, model) .. "_Tag")
    end

    local function KYS_RemoveWorldEntry(cat, model)
        if not KYS_WorldReg[cat] or not KYS_WorldReg[cat][model] then return end
        KYS_ClearWorldVisual(cat, model)
        KYS_WorldReg[cat][model] = nil
    end

    local function KYS_EnsureWorldEntry(cat, model)
        if not KYS_Alive(model) or not KYS_WorldReg[cat] or KYS_WorldReg[cat][model] then return end
        if cat == "Palletwrong" and KYS_IsPalletGone(model) then return end
        local part = KYS_PickWorldPart(model, cat)
        if not KYS_ValidPart(part) then return end
        KYS_WorldReg[cat][model] = { part = part }
    end

    local function KYS_RegisterWorldDescendant(obj)
        if not KYS_Alive(obj) then return end
        local validCats = { Generator = true, Hook = true, Gate = true, Window = true, Palletwrong = true }

        if obj:IsA("Model") then
            if validCats[obj.Name] then
                KYS_EnsureWorldEntry(obj.Name, obj)
                return
            end
            local lower = obj.Name:lower()
            if lower:find("scp") or lower:find("zombie") then
                KYS_EnsureWorldEntry("SCPZombie", obj)
            end
            return
        end

        if obj:IsA("BasePart") then
            local parent = obj.Parent
            while parent and parent ~= Workspace do
                if parent:IsA("Model") then
                    if validCats[parent.Name] then
                        KYS_EnsureWorldEntry(parent.Name, parent)
                        return
                    end
                    local lower = parent.Name:lower()
                    if lower:find("scp") or lower:find("zombie") then
                        KYS_EnsureWorldEntry("SCPZombie", parent)
                        return
                    end
                end
                parent = parent.Parent
            end
        end
    end

    local function KYS_UnregisterWorldDescendant(obj)
        if not obj then return end
        local validCats = { Generator = true, Hook = true, Gate = true, Window = true, Palletwrong = true }

        if obj:IsA("Model") then
            if validCats[obj.Name] then
                KYS_RemoveWorldEntry(obj.Name, obj)
                return
            end
            local lower = obj.Name:lower()
            if lower:find("scp") or lower:find("zombie") then
                KYS_RemoveWorldEntry("SCPZombie", obj)
            end
            return
        end

        if obj:IsA("BasePart") then
            for cat, models in pairs(KYS_WorldReg) do
                for model, entry in pairs(models) do
                    if entry.part == obj then
                        KYS_RemoveWorldEntry(cat, model)
                    end
                end
            end
        end
    end

    local function KYS_AttachESPRoot(root)
        if not root or KYS_MapAdd[root] then return end
        KYS_MapAdd[root] = root.DescendantAdded:Connect(KYS_RegisterWorldDescendant)
        KYS_MapRem[root] = root.DescendantRemoving:Connect(KYS_UnregisterWorldDescendant)
        for _, descendant in ipairs(root:GetDescendants()) do
            KYS_RegisterWorldDescendant(descendant)
        end
    end

    local function KYS_RefreshESPRoots()
        for _, conn in pairs(KYS_MapAdd) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        for _, conn in pairs(KYS_MapRem) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        KYS_MapAdd, KYS_MapRem = {}, {}

        for cat, models in pairs(KYS_WorldReg) do
            for model in pairs(models) do
                KYS_ClearWorldVisual(cat, model)
            end
            KYS_WorldReg[cat] = {}
        end

        local map = Workspace:FindFirstChild("Map")
        local map1 = Workspace:FindFirstChild("Map1")
        if map then KYS_AttachESPRoot(map) end
        if map1 then KYS_AttachESPRoot(map1) end
    end

    local function KYS_LabelForPallet(model)
        local state = KYS_PalletState[model] or "UP"
        if state == "DOWN" then return "Pallet (down)" end
        if state == "DEST" then return "Pallet (destroyed)" end
        if state == "SLIDE" then return "Pallet (slide)" end
        return "Pallet"
    end

    local function KYS_LabelForWindow(model)
        local state = KYS_WindowState[model] or "READY"
        if state == "BUSY" then return "Window (busy)" end
        return "Window"
    end

    local function KYS_AnyWorldEnabled()
        return KYS_ESPState.WorldMasterESP and (
            KYS_ESPState.GeneratorESP or
            KYS_ESPState.HookESP or
            KYS_ESPState.GateESP or
            KYS_ESPState.WindowESP or
            KYS_ESPState.PalletESP or
            KYS_ESPState.SCPZombieESP
        )
    end

    local function KYS_WorldCategoryData(cat)
        if cat == "Generator" then return KYS_ESPState.GeneratorESP, KYS_ESPState.GeneratorColor end
        if cat == "Hook" then return KYS_ESPState.HookESP, KYS_ESPState.HookColor end
        if cat == "Gate" then return KYS_ESPState.GateESP, KYS_ESPState.GateColor end
        if cat == "Window" then return KYS_ESPState.WindowESP, KYS_ESPState.WindowColor end
        if cat == "Palletwrong" then return KYS_ESPState.PalletESP, KYS_ESPState.PalletColor end
        if cat == "SCPZombie" then return KYS_ESPState.SCPZombieESP, KYS_ESPState.SCPZombieColor end
        return false, Color3.new(1, 1, 1)
    end

    local function KYS_UpdateWorldTag(cat, model, part, color)
        local key = KYS_WorldKey(cat, model)
        local tagName = key .. "_Tag"
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix(tagName, tagName)

        if not KYS_ValidPart(part) then
            KYS_DestroyChild(tagName)
            return
        end

        local lines = {}
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local distanceText = ""
        if KYS_ESPState.WorldDistanceESP and root then
            distanceText = "[" .. tostring(math.floor((root.Position - part.Position).Magnitude)) .. "m]"
        end

        local nameText = ""
        local labelColor = color
        if KYS_ESPState.WorldNametags then
            if cat == "Generator" then
                local txt, genColor = KYS_GeneratorLabel(model)
                nameText = txt
                labelColor = genColor
            elseif cat == "Palletwrong" then
                nameText = KYS_LabelForPallet(model)
            elseif cat == "Window" then
                nameText = KYS_LabelForWindow(model)
            elseif cat == "SCPZombie" then
                nameText = model.Name
            else
                nameText = cat
            end
        end

        local mainLine = ""
        if nameText ~= "" and distanceText ~= "" then
            mainLine = nameText .. " " .. distanceText
        elseif nameText ~= "" then
            mainLine = nameText
        elseif distanceText ~= "" then
            mainLine = distanceText
        end

        if mainLine ~= "" then
            table.insert(lines, { Text = mainLine, Color = labelColor })
        end

        if #lines == 0 then
            KYS_DestroyChild(tagName)
            return
        end

        local tag = folder:FindFirstChild(tagName)
        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Name = tagName
            tag.AlwaysOnTop = true
            tag.LightInfluence = 0
            tag.MaxDistance = 0
            tag.Parent = folder
        end

        tag.Adornee = part
        tag.Enabled = true
        tag.Size = UDim2.new(0, 220, 0, #lines * 20)
        tag.StudsOffset = Vector3.new(0, 2.5, 0)

        for i, data in ipairs(lines) do
            KYS_SetBillboardLine(tag, i, #lines, data)
        end
        KYS_PruneBillboardLines(tag, #lines)
    end

    local function KYS_ClearAllWorldESP()
        for cat, models in pairs(KYS_WorldReg) do
            for model in pairs(models) do
                KYS_ClearWorldVisual(cat, model)
            end
        end
    end

    local function KYS_StartWorldLoop()
        if KYS_WorldLoopThread then return end
        KYS_WorldLoopThread = task.spawn(function()
            while not KYS_Dead and KYS_AnyWorldEnabled() do
                for cat, models in pairs(KYS_WorldReg) do
                    local enabled, color = KYS_WorldCategoryData(cat)
                    if enabled and KYS_ESPState.WorldMasterESP then
                        local n = 0
                        for model, entry in pairs(models) do
                            if cat == "Palletwrong" and KYS_IsPalletGone(model) then
                                KYS_RemoveWorldEntry(cat, model)
                            elseif model and KYS_Alive(model) then
                                local part = entry.part
                                if not KYS_ValidPart(part) or (model:IsA("Model") and not part:IsDescendantOf(model)) then
                                    entry.part = KYS_PickWorldPart(model, cat)
                                    part = entry.part
                                end

                                if KYS_ValidPart(part) then
                                    local key = KYS_WorldKey(cat, model)
                                    KYS_EnsureHighlight(key .. "_HL", model, color, false)
                                    KYS_UpdateWorldTag(cat, model, part, color)
                                else
                                    KYS_RemoveWorldEntry(cat, model)
                                end
                            else
                                KYS_RemoveWorldEntry(cat, model)
                            end

                            n = n + 1
                            if n % 60 == 0 then task.wait() end
                        end
                    else
                        for model in pairs(models) do
                            KYS_ClearWorldVisual(cat, model)
                        end
                    end
                end
                task.wait(0.25)
            end
            KYS_WorldLoopThread = nil
        end)
    end

    local function KYS_Selected(selected, name)
        if type(selected) ~= "table" then return false end
        if selected[name] ~= nil then return selected[name] == true end
        for _, value in pairs(selected) do
            if value == name then return true end
        end
        return false
    end

    getgenv().KYS_AddVisualESPControls = function(VisualTabRef)
        if not VisualTabRef or KYS_ControlsAdded then return end
        KYS_ControlsAdded = true

        local settingsSection = VisualTabRef:AddSection({
            Position = "Center",
            Name = "Highlight ESP Settings",
            Icon = "solar:settings-bold",
            Box = true,
            BoxBorder = true,
            Opened = false,
        })

        settingsSection:AddSlider({
            Name = "ESP Fill Transparency",
            Flag = "KYS ESP Fill Transparency",
            Min = 0,
            Max = 1,
            Default = KYS_ESPState.ESPFillTransparency,
            Increment = 0.01,
            Callback = function(value)
                KYS_ESPState.ESPFillTransparency = value
                KYS_RefreshAllPlayers()
            end,
        })

        settingsSection:AddSlider({
            Name = "ESP Outline Transparency",
            Flag = "KYS ESP Outline Transparency",
            Min = 0,
            Max = 1,
            Default = KYS_ESPState.ESPOutlineTransparency,
            Increment = 0.01,
            Callback = function(value)
                KYS_ESPState.ESPOutlineTransparency = value
                KYS_RefreshAllPlayers()
            end,
        })

        settingsSection:AddSlider({
            Name = "ESP Text Size",
            Flag = "KYS ESP Text Size",
            Min = 8,
            Max = 22,
            Default = KYS_ESPState.ESPTextSize,
            Increment = 1,
            Callback = function(value)
                KYS_ESPState.ESPTextSize = value
                KYS_RefreshAllPlayers()
            end,
        })

        local playerSection = VisualTabRef:AddSection({
            Position = "Center",
            Name = "Player Highlight ESP",
            Icon = "solar:users-group-rounded-bold",
            Box = true,
            BoxBorder = true,
            Opened = false,
        })

        playerSection:AddToggle({
            Name = "Enable Player ESP",
            Flag = "KYS Enable Player ESP",
            Default = false,
            Callback = function(state)
                KYS_ESPState.PlayerMasterESP = state
                if state then
                    KYS_StartPlayerLoop()
                    KYS_RefreshAllPlayers()
                else
                    KYS_ClearAllPlayerESP()
                end
            end,
        })

        playerSection:AddDropdown({
            Name = "Select Player ESP",
            Flag = "KYS Select Player ESP",
            Values = { "Survivor ESP", "Killer ESP", "Spectator ESP", "Survivor Items ESP" },
            Multi = true,
            AllowNone = true,
            Default = {},
            Callback = function(selected)
                KYS_ESPState.SurvivorESP = KYS_Selected(selected, "Survivor ESP")
                KYS_ESPState.KillerESP = KYS_Selected(selected, "Killer ESP")
                KYS_ESPState.SpectatorESP = KYS_Selected(selected, "Spectator ESP")
                KYS_ESPState.SurvivorItemsESP = KYS_Selected(selected, "Survivor Items ESP")

                if KYS_ESPState.PlayerMasterESP then
                    KYS_StartPlayerLoop()
                    KYS_RefreshAllPlayers()
                else
                    KYS_ClearAllPlayerESP()
                end
            end,
        })

        playerSection:AddToggle({
            Name = "Player Nametags",
            Flag = "KYS Player Nametags",
            Default = false,
            Callback = function(state)
                KYS_ESPState.Nametags = state
                if KYS_ESPState.PlayerMasterESP then
                    KYS_StartPlayerLoop()
                    KYS_RefreshAllPlayers()
                else
                    KYS_ClearAllPlayerESP()
                end
            end,
        })

        playerSection:AddToggle({
            Name = "Player Distance ESP",
            Flag = "KYS Player Distance ESP",
            Default = false,
            Callback = function(state)
                KYS_ESPState.DistanceESP = state
                if KYS_ESPState.PlayerMasterESP then
                    KYS_StartPlayerLoop()
                    KYS_RefreshAllPlayers()
                else
                    KYS_ClearAllPlayerESP()
                end
            end,
        })

        playerSection:AddToggle({
            Name = "Survivor Killer Warning (!)",
            Flag = "Survivor Killer Warning",
            Default = false,
            Callback = function(state)
                VD.SURV_WarnKiller = state
            end,
        })

        pcall(function() playerSection:AddDivider({ Text = "Colors" }) end)
        playerSection:AddColorPicker({ Name = "Survivor Color", Flag = "KYS Survivor Color", Default = KYS_ESPState.SurvivorColor, Callback = function(color) KYS_ESPState.SurvivorColor = color; KYS_RefreshAllPlayers() end })
        playerSection:AddColorPicker({ Name = "Killer Color", Flag = "KYS Killer Color", Default = KYS_ESPState.KillerColor, Callback = function(color) KYS_ESPState.KillerColor = color; KYS_RefreshAllPlayers() end })
        playerSection:AddColorPicker({ Name = "Spectator Color", Flag = "KYS Spectator Color", Default = KYS_ESPState.SpectatorColor, Callback = function(color) KYS_ESPState.SpectatorColor = color; KYS_RefreshAllPlayers() end })

        local worldSection = VisualTabRef:AddSection({
            Position = "Center",
            Name = "World Highlight ESP",
            Icon = "solar:map-point-wave-bold",
            Box = true,
            BoxBorder = true,
            Opened = false,
        })

        worldSection:AddToggle({
            Name = "Enable World ESP",
            Flag = "KYS Enable World ESP",
            Default = false,
            Callback = function(state)
                KYS_ESPState.WorldMasterESP = state
                if state then
                    KYS_RefreshESPRoots()
                    if KYS_AnyWorldEnabled() then KYS_StartWorldLoop() end
                else
                    KYS_ClearAllWorldESP()
                end
            end,
        })

        worldSection:AddDropdown({
            Name = "Select World Objects",
            Flag = "KYS Select World Objects",
            Values = { "Generators", "Hooks", "Gates", "Windows", "Pallets", "SCP / Zombie" },
            Multi = true,
            AllowNone = true,
            Default = {},
            Callback = function(selected)
                KYS_ESPState.GeneratorESP = KYS_Selected(selected, "Generators")
                KYS_ESPState.HookESP = KYS_Selected(selected, "Hooks")
                KYS_ESPState.GateESP = KYS_Selected(selected, "Gates")
                KYS_ESPState.WindowESP = KYS_Selected(selected, "Windows")
                KYS_ESPState.PalletESP = KYS_Selected(selected, "Pallets")
                KYS_ESPState.SCPZombieESP = KYS_Selected(selected, "SCP / Zombie")

                if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then
                    KYS_RefreshESPRoots()
                    KYS_StartWorldLoop()
                else
                    KYS_ClearAllWorldESP()
                end
            end,
        })

        worldSection:AddToggle({
            Name = "World Nametags",
            Flag = "KYS World Nametags",
            Default = false,
            Callback = function(state)
                KYS_ESPState.WorldNametags = state
                if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then KYS_StartWorldLoop() else KYS_ClearAllWorldESP() end
            end,
        })

        worldSection:AddToggle({
            Name = "World Distance ESP",
            Flag = "KYS World Distance ESP",
            Default = false,
            Callback = function(state)
                KYS_ESPState.WorldDistanceESP = state
                if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then KYS_StartWorldLoop() else KYS_ClearAllWorldESP() end
            end,
        })

        pcall(function() worldSection:AddDivider({ Text = "Colors" }) end)
        worldSection:AddColorPicker({ Name = "Generator Color", Flag = "KYS Generator Color", Default = KYS_ESPState.GeneratorColor, Callback = function(color) KYS_ESPState.GeneratorColor = color end })
        worldSection:AddColorPicker({ Name = "Hook Color", Flag = "KYS Hook Color", Default = KYS_ESPState.HookColor, Callback = function(color) KYS_ESPState.HookColor = color end })
        worldSection:AddColorPicker({ Name = "Gate Color", Flag = "KYS Gate Color", Default = KYS_ESPState.GateColor, Callback = function(color) KYS_ESPState.GateColor = color end })
        worldSection:AddColorPicker({ Name = "Window Color", Flag = "KYS Window Color", Default = KYS_ESPState.WindowColor, Callback = function(color) KYS_ESPState.WindowColor = color end })
        worldSection:AddColorPicker({ Name = "Pallet Color", Flag = "KYS Pallet Color", Default = KYS_ESPState.PalletColor, Callback = function(color) KYS_ESPState.PalletColor = color end })
        worldSection:AddColorPicker({ Name = "SCP / Zombie Color", Flag = "KYS SCP Zombie Color", Default = KYS_ESPState.SCPZombieColor, Callback = function(color) KYS_ESPState.SCPZombieColor = color end })
    end

    for _, player in ipairs(Players:GetPlayers()) do
        KYS_WatchPlayer(player)
    end

    table.insert(KYS_Connections, Players.PlayerAdded:Connect(KYS_WatchPlayer))
    table.insert(KYS_Connections, Players.PlayerRemoving:Connect(KYS_UnwatchPlayer))
    table.insert(KYS_Connections, Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" or child.Name == "Map1" then
            KYS_AttachESPRoot(child)
            if KYS_ESPState.WorldMasterESP and KYS_AnyWorldEnabled() then KYS_StartWorldLoop() end
        end
    end))
    table.insert(KYS_Connections, Workspace.ChildRemoved:Connect(function(child)
        if child.Name == "Map" or child.Name == "Map1" then
            KYS_RefreshESPRoots()
        end
    end))

    KYS_RefreshESPRoots()

    getgenv().KYS_VD_VisualESP_Cleanup = function()
        KYS_Dead = true
        KYS_ClearAllPlayerESP()
        KYS_ClearAllWorldESP()

        for _, conn in ipairs(KYS_Connections) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        for _, conns in pairs(KYS_PlayerConns) do
            for _, conn in ipairs(conns) do
                if conn then pcall(function() conn:Disconnect() end) end
            end
        end
        for _, conn in pairs(KYS_MapAdd) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        for _, conn in pairs(KYS_MapRem) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        if KYS_ESPFolder and KYS_ESPFolder.Parent then
            KYS_ESPFolder:Destroy()
        end
    end

    KYS_SafeNotify("Visual ESP", "Highlight ESP V2 loaded. Anti double nametag aktif.", 3)
end



-- =====================================================
-- FULLBRIGHT
-- =====================================================
task.spawn(function()
    while not VD.Destroyed do
        if VD.Fullbright then
            local weatherTheme = VD.VIS_WeatherTheme and KYS_WeatherPresets[VD.VIS_WeatherTheme]
            local keepWeatherLighting = VD.VIS_WeatherTheme and VD.VIS_WeatherTheme ~= "Default" and weatherTheme and weatherTheme.Lighting
            if keepWeatherLighting then
                for k, v in pairs(weatherTheme.Lighting) do
                    pcall(function() Lighting[k] = v end)
                end
                Lighting.Brightness = math.max(Lighting.Brightness, 2)
                Lighting.GlobalShadows = false
                if VD.NO_Fog then
                    Lighting.FogStart = 0
                    Lighting.FogEnd = 100000
                end
            else
                Lighting.Brightness     = 2
                Lighting.ClockTime      = 14
                Lighting.GlobalShadows  = false
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                Lighting.FogStart       = 0
                Lighting.FogEnd         = 100000
            end
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("Atmosphere") and v.Name ~= "VD_WeatherAtmosphere" then
                    v.Density = 0; v.Offset = 0; v.Glare = 0; v.Haze = 0
                end
                if v:IsA("BlurEffect") then v.Size = 0 end
                if v:IsA("ColorCorrectionEffect") and v.Name ~= "VD_WeatherCC" then v.Enabled = false end
                if v:IsA("SunRaysEffect") then v.Enabled = false end
            end
        else
            if VD.VIS_WeatherTheme and VD.VIS_WeatherTheme ~= "Default" and KYS_WeatherPresets[VD.VIS_WeatherTheme] then
                local theme = KYS_WeatherPresets[VD.VIS_WeatherTheme]
                if theme.Lighting then
                    for k, v in pairs(theme.Lighting) do
                        pcall(function() Lighting[k] = v end)
                    end
                end
            else
                Lighting.Brightness     = originalLighting.Brightness
                Lighting.ClockTime      = originalLighting.ClockTime
                Lighting.FogEnd         = originalLighting.FogEnd
                Lighting.FogStart       = originalLighting.FogStart or 0
                Lighting.GlobalShadows  = originalLighting.GlobalShadows
                Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
                for _, v in pairs(Lighting:GetChildren()) do
                    if v:IsA("Atmosphere") and originalLighting.Atmosphere then
                        v.Density = originalLighting.Atmosphere.Density or 0.3
                        v.Offset  = originalLighting.Atmosphere.Offset or 0.25
                        v.Glare   = originalLighting.Atmosphere.Glare or 0
                        v.Haze    = originalLighting.Atmosphere.Haze or 0
                    end
                    if v:IsA("BlurEffect") and originalLighting.Blur then v.Size = originalLighting.Blur.Size or 0 end
                    if v:IsA("ColorCorrectionEffect") and originalLighting.ColorCorrection then
                        v.Enabled = originalLighting
                            .ColorCorrection.Enabled or false
                    end
                    if v:IsA("SunRaysEffect") and originalLighting.SunRays then
                        v.Enabled = originalLighting.SunRays.Enabled or
                            false
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

-- =====================================================-- =====================================================
-- MOVEMENT & NOCLIP
-- =====================================================
local originalCanCollide = {}

RunService.Stepped:Connect(function()
    if VD.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, descendant in ipairs(char:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    if originalCanCollide[descendant] == nil then
                        originalCanCollide[descendant] = descendant.CanCollide
                    end
                    descendant.CanCollide = false
                end
            end
        end
    end
end)

getgenv().VD_DisableNoclip = function()
    for part, canCollide in pairs(originalCanCollide) do
        if part and part.Parent then
            pcall(function() part.CanCollide = canCollide end)
        end
    end
    originalCanCollide = {}
end

LocalPlayer.CharacterRemoving:Connect(function(char)
    if char == LocalPlayer.Character then
        originalCanCollide = {}
    end
end)

RunService.Heartbeat:Connect(function(deltaTime)
    local myChar = LocalPlayer.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if myHum then
        if VD.Speed and myHum.WalkSpeed ~= VD.SpeedValue then myHum.WalkSpeed = VD.SpeedValue end
        if VD.Jump and myHum.JumpPower ~= VD.JumpValue then myHum.JumpPower = VD.JumpValue end
    end

end)

UserInputService.JumpRequest:Connect(function()
    local myChar = LocalPlayer.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if VD.InfiniteJump and myHum then
        myHum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- =====================================================
-- HIDE SKILL CHECK UI
-- =====================================================
local cachedPlayerGui = LocalPlayer:WaitForChild("PlayerGui")
RunService.RenderStepped:Connect(function()
    if VD.HideSkillUI then
        if not cachedPlayerGui then cachedPlayerGui = LocalPlayer:FindFirstChild("PlayerGui") end
        local a = cachedPlayerGui and cachedPlayerGui:FindFirstChild("SkillCheckPromptGui")
        local b = cachedPlayerGui and cachedPlayerGui:FindFirstChild("SkillCheckPromptGui-con")
        if a and a.Enabled then a.Enabled = false end
        if b and b.Enabled then b.Enabled = false end
    end
end)

-- =====================================================
-- AUTO PARRY + AUTO SKILLCHECK (ported from survivor)
-- =====================================================
function VD_Notify(title, content, duration)
    pcall(function()
        if Window and Window.Notify then
            Window:Notify({
                Title = title,
                Content = content,
                Duration = duration or 2,
                Icon = "lucide:info",
            })
        end
    end)
end

-- =====================================================
-- SILENT AIM: TWIST OF FATE
-- =====================================================
(function()
local KYS_ToFState = {
    Connection = nil,
    LaserBeam = nil,
    TargetGui = nil,
    InputBegan = nil,
    InputEnded = nil,
    TouchInput = nil,
    IsAiming = false,
    SavedUIPos = UDim2.new(0.5, -120, 0, 110),
    SCPCache = {},
    SCPCacheTimer = 0,
}

local KYS_ToFKeyCodes = {
    None = nil,
    Q = Enum.KeyCode.Q,
    E = Enum.KeyCode.E,
    R = Enum.KeyCode.R,
    T = Enum.KeyCode.T,
    F = Enum.KeyCode.F,
    G = Enum.KeyCode.G,
    H = Enum.KeyCode.H,
    J = Enum.KeyCode.J,
    K = Enum.KeyCode.K,
    L = Enum.KeyCode.L,
    X = Enum.KeyCode.X,
    Z = Enum.KeyCode.Z,
}

local function KYS_ToFGetEvent()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local items = remotes and remotes:FindFirstChild("Items")
    local tof = items and items:FindFirstChild("Twist of Fate")
    local fire = tof and tof:FindFirstChild("Fire")
    if fire and fire:IsA("RemoteEvent") then
        return fire
    end
    return nil
end

local function KYS_ToFGetGunObject()
    local char = LocalPlayer.Character
    if not char then return nil end

    local baseToF = char:FindFirstChild("Twist of Fate", true)
    if not baseToF then return nil end

    local rightArm = baseToF:FindFirstChild("Right Arm")
    if rightArm then
        local gunPart = rightArm:FindFirstChild("gun")
        if gunPart then return gunPart end

        local emperorGun = rightArm:FindFirstChild("EmperorGun")
        if emperorGun then return emperorGun end
    end

    return baseToF
end

local function KYS_ToFIsTargetVisible(originPos, targetPos, targetCharacter)
    local direction = targetPos - originPos
    local distance = direction.Magnitude
    if distance < 0.1 then return true end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local excludeList = {}
    local localChar = LocalPlayer.Character
    if localChar then table.insert(excludeList, localChar) end
    if targetCharacter and targetCharacter ~= localChar then table.insert(excludeList, targetCharacter) end
    if KYS_ToFState.LaserBeam then table.insert(excludeList, KYS_ToFState.LaserBeam) end

    rayParams.FilterDescendantsInstances = excludeList

    local result = workspace:Raycast(originPos, direction.Unit * distance, rayParams)
    return result == nil
end

local function KYS_ToFGetSCPs()
    if tick() - KYS_ToFState.SCPCacheTimer < 0.5 then
        return KYS_ToFState.SCPCache
    end

    local newTargets = {}
    local mapFolder = workspace:FindFirstChild("Map")
    if mapFolder then
        for _, container in pairs(mapFolder:GetDescendants()) do
            if container:IsA("Model") then
                local attributes = container:GetAttributes()
                if container:GetAttribute("CorpseCreated0492") or next(attributes) ~= nil then
                    local root = container:FindFirstChild("HumanoidRootPart")
                    if root then table.insert(newTargets, root) end
                end
            end
        end
    end

    KYS_ToFState.SCPCache = newTargets
    KYS_ToFState.SCPCacheTimer = tick()
    return KYS_ToFState.SCPCache
end

local function KYS_ToFGetTargetPosition()
    local gunObj = KYS_ToFGetGunObject()
    local char = LocalPlayer.Character
    if not (gunObj and char) then return nil, nil, nil, nil end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil, nil, nil end

    local myPos = hrp.Position
    local originPos
    if char:GetAttribute("IsCarried") then
        originPos = hrp.Position + (hrp.CFrame.LookVector * 2)
    else
        pcall(function()
            originPos = gunObj:IsA("BasePart") and gunObj.Position
                or (gunObj:FindFirstChildOfClass("BasePart") and gunObj:FindFirstChildOfClass("BasePart").Position)
        end)
        originPos = originPos or Vector3.new(myPos.X, myPos.Y + 1.5, myPos.Z)
    end

    local function predictTarget(torso, targetCharacter)
        local targetPos = torso.Position
        if VD.TOF_WallCheck and not KYS_ToFIsTargetVisible(originPos, targetPos, targetCharacter) then
            return nil, nil, nil, nil
        end

        local targetVel = Vector3.new(0, 0, 0)
        local rootPart = targetCharacter and (targetCharacter:FindFirstChild("HumanoidRootPart") or torso)
        if rootPart then targetVel = rootPart.Velocity end

        local directionRaw = targetPos - originPos
        local distance = directionRaw.Magnitude
        if distance < 0.1 then return nil, nil, nil, nil end
        if distance < 5 then return directionRaw.Unit, gunObj, originPos, targetPos end

        local travelTime = distance / 400
        local predictedPos = targetPos + (targetVel * travelTime)
        for _ = 1, 2 do
            local newDist = (predictedPos - originPos).Magnitude
            travelTime = newDist / 400
            predictedPos = targetPos + (targetVel * travelTime)
        end

        local finalDirection = predictedPos - originPos
        if finalDirection.Magnitude < 0.1 then return nil, nil, nil, nil end

        return finalDirection.Unit, gunObj, originPos, predictedPos
    end

    local targetMode = VD.TOF_TargetMode or "Killer"
    if targetMode == "Killer" then
        local closestTorso, closestChar, shortestDist = nil, nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team and player.Team.Name == "Killer" and player.Character then
                local torso = player.Character:FindFirstChild("Torso")
                    or player.Character:FindFirstChild("UpperTorso")
                    or player.Character:FindFirstChild("HumanoidRootPart")
                if torso then
                    local dist = (myPos - torso.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestTorso = torso
                        closestChar = player.Character
                    end
                end
            end
        end
        if not closestTorso then return nil, nil, nil, nil end
        return predictTarget(closestTorso, closestChar)
    elseif targetMode == "Survivors" then
        local bestTorso, bestChar, bestDot = nil, nil, -math.huge
        local cam = workspace.CurrentCamera
        local camLook = cam.CFrame.LookVector

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team and player.Team.Name == "Survivors" and player.Character then
                local torso = player.Character:FindFirstChild("Torso")
                    or player.Character:FindFirstChild("UpperTorso")
                    or player.Character:FindFirstChild("HumanoidRootPart")
                if torso then
                    local dirToTarget = torso.Position - cam.CFrame.Position
                    if dirToTarget.Magnitude > 0.1 then
                        local dot = camLook:Dot(dirToTarget.Unit)
                        if dot > 0.5 and dot > bestDot then
                            bestDot = dot
                            bestTorso = torso
                            bestChar = player.Character
                        end
                    end
                end
            end
        end
        if not bestTorso then return nil, nil, nil, nil end
        return predictTarget(bestTorso, bestChar)
    elseif targetMode == "Zombie" then
        local bestPart, bestDot = nil, -math.huge
        local cam = workspace.CurrentCamera
        local camLook = cam.CFrame.LookVector

        for _, root in ipairs(KYS_ToFGetSCPs()) do
            if root and root.Parent then
                local dirToTarget = root.Position - cam.CFrame.Position
                if dirToTarget.Magnitude > 0.1 then
                    local dot = camLook:Dot(dirToTarget.Unit)
                    if dot > 0.5 and dot > bestDot then
                        bestDot = dot
                        bestPart = root
                    end
                end
            end
        end
        if not bestPart then return nil, nil, nil, nil end
        return predictTarget(bestPart, bestPart.Parent)
    end

    return nil, nil, nil, nil
end

local function KYS_ToFUpdateLaser(originPos, targetPos)
    if not KYS_ToFState.LaserBeam then
        local laser = Instance.new("Part")
        laser.Name = "ToFLaser"
        laser.Anchored = true
        laser.CanCollide = false
        laser.CanTouch = false
        laser.CastShadow = false
        laser.Material = Enum.Material.Neon
        laser.Color = Color3.fromRGB(255, 50, 50)
        laser.Parent = workspace
        KYS_ToFState.LaserBeam = laser
    end

    local dist = (targetPos - originPos).Magnitude
    KYS_ToFState.LaserBeam.Size = Vector3.new(0.05, 0.05, dist)
    KYS_ToFState.LaserBeam.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
    KYS_ToFState.LaserBeam.Transparency = 0
end

local function KYS_ToFClearLaser()
    if KYS_ToFState.LaserBeam then
        pcall(function() KYS_ToFState.LaserBeam:Destroy() end)
        KYS_ToFState.LaserBeam = nil
    end
end

local AimConfig = {
    Pistol_BlockKnocked = true,
}

local function IsDowned(char)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    local state = char:GetAttribute("State")
    return state == "Downed" or state == "Dead"
end

local function KYS_ToFGetMobileShootButton()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local survivorMob = playerGui and playerGui:FindFirstChild("Survivor-mob")
    local controls = survivorMob and survivorMob:FindFirstChild("Controls")
    local guiMob = controls and controls:FindFirstChild("Gui-mob")
    if not guiMob then return nil end

    local directNames = { "attack", "Attack", "shoot", "Shoot", "fire", "Fire" }
    for _, name in ipairs(directNames) do
        local btn = guiMob:FindFirstChild(name, true)
        if btn and btn:IsA("GuiObject") then return btn end
    end

    for _, obj in ipairs(guiMob:GetDescendants()) do
        if obj:IsA("GuiButton") and obj.Visible then
            return obj
        end
    end

    return guiMob:IsA("GuiObject") and guiMob or nil
end

local function KYS_ToFIsTouchOnShootButton(input)
    local shootButton = KYS_ToFGetMobileShootButton()
    if not (shootButton and shootButton.Visible) then return false end

    local pos = input.Position
    local absPos = shootButton.AbsolutePosition
    local absSize = shootButton.AbsoluteSize

    return pos.X >= absPos.X and pos.X <= absPos.X + absSize.X
        and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y
end

local function KYS_ToFDoShoot()
    if not VD.TOF_SilentAim then return end

    AimConfig.Pistol_BlockKnocked = VD.TOF_BlockKnocked ~= false
    local char = LocalPlayer.Character
    if char then
        if AimConfig.Pistol_BlockKnocked and IsDowned(char) then
            return
        end
    end

    local targetDirection, gunObject, originPos, targetPos = KYS_ToFGetTargetPosition()
    if not (targetDirection and gunObject and targetPos and originPos) then return end

    local tofEvent = KYS_ToFGetEvent()
    if not tofEvent then return end

    local freshDirection = targetPos - originPos
    if freshDirection.Magnitude < 0.1 then return end

    pcall(function()
        tofEvent:FireServer(gunObject, freshDirection.Unit)
    end)
end

local KYS_ToFModeButtons = {}
local function KYS_ToFRefreshTargetButtons()
    local modes = {
        Killer = { Color3.fromRGB(180, 45, 45), Color3.fromRGB(255, 180, 180) },
        Survivors = { Color3.fromRGB(25, 80, 150), Color3.fromRGB(160, 210, 255) },
        Zombie = { Color3.fromRGB(120, 80, 10), Color3.fromRGB(255, 210, 100) },
    }

    for modeName, btn in pairs(KYS_ToFModeButtons) do
        if btn and btn.Parent then
            local active = modeName == (VD.TOF_TargetMode or "Killer")
            local colors = modes[modeName]
            btn.BackgroundColor3 = active and colors[1] or Color3.fromRGB(30, 32, 40)
            btn.TextColor3 = active and colors[2] or Color3.fromRGB(155, 160, 175)
        end
    end
end

local function KYS_ToFSetTargetMode(modeName, notify)
    if modeName ~= "Killer" and modeName ~= "Survivors" and modeName ~= "Zombie" then return end
    VD.TOF_TargetMode = modeName
    KYS_ToFRefreshTargetButtons()
    if notify then VD_Notify("Target Mode", modeName, 1) end
end

local function KYS_ToFCreateTargetSelectorUI()
    local parent = GetSafeGuiParent()
    if not parent then return end
    if KYS_ToFState.TargetGui and KYS_ToFState.TargetGui.Parent then return end

    local old = parent:FindFirstChild("ToFTargetSelector")
    if old then pcall(function() old:Destroy() end) end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ToFTargetSelector"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.new(0, 180, 0, 126)
    frame.Position = KYS_ToFState.SavedUIPos
    frame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(96, 72, 160)
    stroke.Thickness = 1

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 28)
    header.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
    header.BorderSizePixel = 0
    header.Parent = frame
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 10)
    headerFix.Position = UDim2.new(0, 0, 1, -10)
    headerFix.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header

    local headerDiv = Instance.new("Frame")
    headerDiv.Size = UDim2.new(1, 0, 0, 1)
    headerDiv.Position = UDim2.new(0, 0, 1, -1)
    headerDiv.BackgroundColor3 = Color3.fromRGB(48, 42, 72)
    headerDiv.BorderSizePixel = 0
    headerDiv.Parent = header

    local dragArea = Instance.new("Frame")
    dragArea.Size = UDim2.new(1, -34, 1, 0)
    dragArea.BackgroundTransparency = 1
    dragArea.Parent = header

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 28, 1, 0)
    minimizeBtn.Position = UDim2.new(1, -30, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(185, 190, 205)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 14
    minimizeBtn.Parent = header

    local headerLbl = Instance.new("TextLabel")
    headerLbl.Size = UDim2.new(1, -44, 1, 0)
    headerLbl.Position = UDim2.new(0, 10, 0, 0)
    headerLbl.BackgroundTransparency = 1
    headerLbl.Text = "TOF TARGET MODE"
    headerLbl.TextColor3 = Color3.fromRGB(210, 215, 230)
    headerLbl.Font = Enum.Font.GothamBold
    headerLbl.TextSize = 10
    headerLbl.TextXAlignment = Enum.TextXAlignment.Left
    headerLbl.Parent = header

    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, -16, 0, 86)
    btnContainer.Position = UDim2.new(0, 8, 0, 34)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = frame

    local layout = Instance.new("UIListLayout", btnContainer)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        minimizeBtn.Text = isMinimized and "+" or "-"
        btnContainer.Visible = not isMinimized
        frame.Size = isMinimized and UDim2.new(0, 180, 0, 28) or UDim2.new(0, 180, 0, 126)
    end)

    local modes = {
        { Internal = "Killer", Display = "KILLER        K" },
        { Internal = "Survivors", Display = "SURVIVOR      J" },
        { Internal = "Zombie", Display = "ZOMBIE        L" },
    }

    KYS_ToFModeButtons = {}
    for i, mode in ipairs(modes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Text = mode.Display
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.LayoutOrder = i
        btn.Parent = btnContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Color3.fromRGB(58, 62, 78)
        btnStroke.Thickness = 1

        btn.MouseButton1Click:Connect(function()
            KYS_ToFSetTargetMode(mode.Internal, false)
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                KYS_ToFSetTargetMode(mode.Internal, false)
            end
        end)

        KYS_ToFModeButtons[mode.Internal] = btn
    end
    KYS_ToFRefreshTargetButtons()

    local dragging = false
    local dragStart, startPos
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startPos = frame.Position
            dragging = true
        end
    end)
    dragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            frame.Position = newPos
            KYS_ToFState.SavedUIPos = newPos
        end
    end)

    KYS_ToFState.TargetGui = gui
end

local function KYS_ToFDestroyTargetSelectorUI()
    if KYS_ToFState.TargetGui then
        pcall(function() KYS_ToFState.TargetGui:Destroy() end)
        KYS_ToFState.TargetGui = nil
    end
    KYS_ToFModeButtons = {}
end

local function KYS_ToFStartConnection()
    if KYS_ToFState.Connection then return end
    KYS_ToFState.Connection = RunService.Heartbeat:Connect(function()
        if not VD.TOF_SilentAim or not KYS_ToFState.IsAiming then
            if KYS_ToFState.LaserBeam then KYS_ToFState.LaserBeam.Transparency = 1 end
            return
        end

        local _, _, originPos, targetPos = KYS_ToFGetTargetPosition()
        if originPos and targetPos then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and not char:GetAttribute("IsCarried") then
                    hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
                end
            end)

            if VD.TOF_Laser then
                KYS_ToFUpdateLaser(originPos, targetPos)
            elseif KYS_ToFState.LaserBeam then
                KYS_ToFState.LaserBeam.Transparency = 1
            end
        elseif KYS_ToFState.LaserBeam then
            KYS_ToFState.LaserBeam.Transparency = 1
        end
    end)
end

local function KYS_ToFStopConnection()
    if KYS_ToFState.Connection then
        pcall(function() KYS_ToFState.Connection:Disconnect() end)
        KYS_ToFState.Connection = nil
    end
    KYS_ToFState.IsAiming = false
    KYS_ToFClearLaser()
end

local function KYS_ToFDisconnectInputs()
    if KYS_ToFState.InputBegan then pcall(function() KYS_ToFState.InputBegan:Disconnect() end) end
    if KYS_ToFState.InputEnded then pcall(function() KYS_ToFState.InputEnded:Disconnect() end) end
    KYS_ToFState.InputBegan = nil
    KYS_ToFState.InputEnded = nil
end

local KYS_SetToFSilentAim

local function KYS_ToFEnsureInputs()
    if not KYS_ToFState.InputBegan then
        KYS_ToFState.InputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end

            local keyCode = KYS_ToFKeyCodes[VD.TOF_Key or "None"]
            if keyCode and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keyCode then
                KYS_SetToFSilentAim(not VD.TOF_SilentAim)
                return
            end

            if not VD.TOF_SilentAim then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or (input.UserInputType == Enum.UserInputType.Touch and KYS_ToFIsTouchOnShootButton(input)) then
                KYS_ToFState.IsAiming = true
                if input.UserInputType == Enum.UserInputType.Touch then
                    KYS_ToFState.TouchInput = input
                end
                KYS_ToFDoShoot()
                return
            end

            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.K then
                    KYS_ToFSetTargetMode("Killer", true)
                elseif input.KeyCode == Enum.KeyCode.J then
                    KYS_ToFSetTargetMode("Survivors", true)
                elseif input.KeyCode == Enum.KeyCode.L then
                    KYS_ToFSetTargetMode("Zombie", true)
                end
            end
        end)
    end
    if not KYS_ToFState.InputEnded then
        KYS_ToFState.InputEnded = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or (input.UserInputType == Enum.UserInputType.Touch and input == KYS_ToFState.TouchInput) then
                KYS_ToFState.IsAiming = false
                if input == KYS_ToFState.TouchInput then KYS_ToFState.TouchInput = nil end
                if KYS_ToFState.LaserBeam then KYS_ToFState.LaserBeam.Transparency = 1 end
            end
        end)
    end
end

KYS_SetToFSilentAim = function(enabled)
    VD.TOF_SilentAim = enabled and true or false
    KYS_ToFEnsureInputs()
    if VD.TOF_SilentAim then
        KYS_ToFCreateTargetSelectorUI()
        KYS_ToFStartConnection()
    else
        KYS_ToFDestroyTargetSelectorUI()
        KYS_ToFStopConnection()
    end
end

KYS_ToFEnsureInputs()
getgenv().KYS_SetToFSilentAim = KYS_SetToFSilentAim
getgenv().KYS_ToFClearLaser = KYS_ToFClearLaser
getgenv().KYS_ToFSetTargetMode = KYS_ToFSetTargetMode
end)();

-- =====================================================
-- HIDE SURVIVOR ICON
-- =====================================================
(function()
local KYS_HideSurvivorIconState = {
    Connection = nil,
    Originals = {},
}

local KYS_HideSurvivorIconImage = "rbxassetid://80891639562743"
local KYS_HideSurvivorIconText = "NxH"

local function KYS_GetSurvivorSlots()
    local slots = {}
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return slots end

    for _, gui in ipairs(playerGui:GetChildren()) do
        if not (gui:IsA("ScreenGui") and gui.Name:match("%-mob$")) then
            continue
        end
        local frame = gui and gui:FindFirstChild("Frame")
        if frame then
            for i = 1, 5 do
                local survivorFrame = frame:FindFirstChild("Survivor" .. i)
                local imageLabel = survivorFrame and survivorFrame:FindFirstChild("ImageLabel")
                local textLabel = survivorFrame and survivorFrame:FindFirstChild("TextLabel")
                if (imageLabel and imageLabel:IsA("ImageLabel")) or (textLabel and textLabel:IsA("TextLabel")) then
                    table.insert(slots, {
                        ImageLabel = imageLabel,
                        TextLabel = textLabel,
                    })
                end
            end
        end
    end

    return slots
end

local function KYS_ApplyHideSurvivorIcon()
    for _, slot in ipairs(KYS_GetSurvivorSlots()) do
        local imageLabel = slot.ImageLabel
        if imageLabel and imageLabel:IsA("ImageLabel") then
            if not KYS_HideSurvivorIconState.Originals[imageLabel] then
                KYS_HideSurvivorIconState.Originals[imageLabel] = {
                    Image = imageLabel.Image,
                    ImageColor3 = imageLabel.ImageColor3,
                    ImageTransparency = imageLabel.ImageTransparency,
                    ImageRectOffset = imageLabel.ImageRectOffset,
                    ImageRectSize = imageLabel.ImageRectSize,
                    ScaleType = imageLabel.ScaleType,
                }
            end

            imageLabel.Image = KYS_HideSurvivorIconImage
            imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
            imageLabel.ImageTransparency = 0
            imageLabel.ImageRectOffset = Vector2.new(0, 0)
            imageLabel.ImageRectSize = Vector2.new(0, 0)
            imageLabel.ScaleType = Enum.ScaleType.Crop
        end

        local textLabel = slot.TextLabel
        if textLabel and textLabel:IsA("TextLabel") then
            if not KYS_HideSurvivorIconState.Originals[textLabel] then
                KYS_HideSurvivorIconState.Originals[textLabel] = {
                    Text = textLabel.Text,
                    TextColor3 = textLabel.TextColor3,
                    TextTransparency = textLabel.TextTransparency,
                }
            end

            textLabel.Text = KYS_HideSurvivorIconText
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextTransparency = 0
        end
    end
end

local function KYS_RestoreSurvivorIcons()
    for object, original in pairs(KYS_HideSurvivorIconState.Originals) do
        if object and object.Parent and original then
            pcall(function()
                if original.Image ~= nil and object:IsA("ImageLabel") then
                    object.Image = original.Image
                    object.ImageColor3 = original.ImageColor3
                    object.ImageTransparency = original.ImageTransparency
                    object.ImageRectOffset = original.ImageRectOffset
                    object.ImageRectSize = original.ImageRectSize
                    object.ScaleType = original.ScaleType
                end
                if original.Text ~= nil and object:IsA("TextLabel") then
                    object.Text = original.Text
                    object.TextColor3 = original.TextColor3
                    object.TextTransparency = original.TextTransparency
                end
            end)
        end
    end
    KYS_HideSurvivorIconState.Originals = {}
end

local function KYS_SetHideSurvivorIcon(enabled)
    VD.VIS_HideSurvivorIcon = enabled and true or false

    if VD.VIS_HideSurvivorIcon then
        KYS_ApplyHideSurvivorIcon()
        if not KYS_HideSurvivorIconState.Connection then
            KYS_HideSurvivorIconState.Connection = RunService.Heartbeat:Connect(function()
                if VD.VIS_HideSurvivorIcon then
                    KYS_ApplyHideSurvivorIcon()
                end
            end)
        end
    else
        if KYS_HideSurvivorIconState.Connection then
            pcall(function() KYS_HideSurvivorIconState.Connection:Disconnect() end)
            KYS_HideSurvivorIconState.Connection = nil
        end
        KYS_RestoreSurvivorIcons()
    end
end

getgenv().KYS_SetHideSurvivorIcon = KYS_SetHideSurvivorIcon
end)();

-- =====================================================
-- SHOW HOOK COUNTER (SURVIVOR & KILLER)
-- =====================================================
(function()
local KYS_HookCounterState = {
    Connection = nil,
}

local function KYS_UpdateHookCounter(enabled)
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name:match("%-mob$") then
            local frame = gui:FindFirstChild("Frame")
            if frame then
                for i = 1, 5 do
                    local survivorFrame = frame:FindFirstChild("Survivor" .. i)
                    local imageLabel = survivorFrame and survivorFrame:FindFirstChild("ImageLabel")
                    local textLabel = survivorFrame and survivorFrame:FindFirstChild("TextLabel")
                    
                    if imageLabel and textLabel then
                        -- Handle original Counter if exists
                        local counter = imageLabel:FindFirstChild("Counter")
                        if counter then
                            pcall(function()
                                if counter.Visible ~= enabled then
                                    counter.Visible = enabled
                                end
                            end)
                        end

                        -- Handle Custom Text Hook Counter
                        local labelName = "KYS_CustomHookCounter"
                        local customLabel = imageLabel:FindFirstChild(labelName)
                        
                        if enabled then
                            local playerName = textLabel.Text
                            local player = nil
                            for _, p in ipairs(game.Players:GetPlayers()) do
                                if p.Name == playerName or p.DisplayName == playerName then
                                    player = p
                                    break
                                end
                            end

                            local hookCount = 0
                            if player then
                                hookCount = player:GetAttribute("HookCount") or (player.Character and player.Character:GetAttribute("HookCount")) or 0
                            end

                            if not customLabel then
                                customLabel = Instance.new("TextLabel")
                                customLabel.Name = labelName
                                customLabel.Size = UDim2.new(1, 0, 0.35, 0)
                                customLabel.Position = UDim2.new(0, 0, 0.65, 0)
                                customLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                customLabel.BackgroundTransparency = 0.5
                                customLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                customLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                customLabel.TextStrokeTransparency = 0
                                customLabel.TextScaled = true
                                customLabel.Font = Enum.Font.SourceSansBold
                                customLabel.Parent = imageLabel
                            end

                            customLabel.Visible = true
                            if hookCount >= 3 then
                                customLabel.Text = "DEAD"
                                customLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
                            else
                                customLabel.Text = "Hooks: " .. tostring(hookCount)
                                if hookCount == 2 then
                                    customLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
                                elseif hookCount == 1 then
                                    customLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                                else
                                    customLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                end
                            end
                        else
                            if customLabel then
                                customLabel.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end
end

local function KYS_SetShowHookCounter(enabled)
    VD.VIS_ShowHookCounter = enabled and true or false

    if VD.VIS_ShowHookCounter then
        KYS_UpdateHookCounter(true)
        if not KYS_HookCounterState.Connection then
            KYS_HookCounterState.Connection = RunService.Heartbeat:Connect(function()
                if VD.VIS_ShowHookCounter then
                    KYS_UpdateHookCounter(true)
                end
            end)
        end
    else
        if KYS_HookCounterState.Connection then
            pcall(function() KYS_HookCounterState.Connection:Disconnect() end)
            KYS_HookCounterState.Connection = nil
        end
        KYS_UpdateHookCounter(false)
        -- Delete the custom label to keep GUI clean
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name:match("%-mob$") then
                    local frame = gui:FindFirstChild("Frame")
                    if frame then
                        for i = 1, 5 do
                            local survivorFrame = frame:FindFirstChild("Survivor" .. i)
                            local imageLabel = survivorFrame and survivorFrame:FindFirstChild("ImageLabel")
                            customLabel = imageLabel and imageLabel:FindFirstChild("KYS_CustomHookCounter")
                            if customLabel then
                                pcall(function() customLabel:Destroy() end)
                            end
                        end
                    end
                end
            end
        end
    end
end

getgenv().KYS_SetShowHookCounter = KYS_SetShowHookCounter
end)();

-- =====================================================
-- SHOW PING & FPS
-- =====================================================
(function()
local KYS_PingFPSState = {
    Gui = nil,
    Connection = nil,
    Frames = 0,
    LastUpdate = 0,
}

local function KYS_GetPingValue()
    local ok, value = pcall(function()
        local stats = game:GetService("Stats")
        local network = stats and stats:FindFirstChild("Network")
        local serverStats = network and network:FindFirstChild("ServerStatsItem")
        local dataPing = serverStats and serverStats:FindFirstChild("Data Ping")
        if dataPing and dataPing.GetValue then
            return math.floor(dataPing:GetValue() + 0.5)
        end
        if dataPing and dataPing.GetValueString then
            local raw = tostring(dataPing:GetValueString())
            return tonumber(raw:match("%d+"))
        end
    end)
    if ok and value then return value end
    return nil
end

local function KYS_CreatePingFPSGui()
    local parent = GetSafeGuiParent()
    if not parent then return nil end

    local old = parent:FindFirstChild("KYS_PingFPSGui")
    if old then pcall(function() old:Destroy() end) end

    local sg = Instance.new("ScreenGui")
    sg.Name = "KYS_PingFPSGui"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.Parent = parent

    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.new(0, 118, 0, 44)
    frame.Position = UDim2.new(0, 12, 0, 120)
    frame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = sg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(96, 72, 160)
    stroke.Thickness = 1

    local label = Instance.new("TextLabel")
    label.Name = "PingFPSLabel"
    label.Size = UDim2.new(1, -12, 1, -8)
    label.Position = UDim2.new(0, 6, 0, 4)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(230, 235, 245)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Text = "PING: --ms\nFPS: --"
    label.Parent = frame

    return sg
end

local function KYS_SetShowPingFPS(enabled)
    VD.VIS_ShowPingFPS = enabled and true or false

    if VD.VIS_ShowPingFPS then
        KYS_PingFPSState.Gui = KYS_PingFPSState.Gui or KYS_CreatePingFPSGui()
        KYS_PingFPSState.Frames = 0
        KYS_PingFPSState.LastUpdate = tick()

        if not KYS_PingFPSState.Connection then
            KYS_PingFPSState.Connection = RunService.RenderStepped:Connect(function()
                if not VD.VIS_ShowPingFPS then return end

                KYS_PingFPSState.Frames = KYS_PingFPSState.Frames + 1
                local now = tick()
                if now - KYS_PingFPSState.LastUpdate < 0.5 then return end

                local fps = math.floor(KYS_PingFPSState.Frames / (now - KYS_PingFPSState.LastUpdate) + 0.5)
                local ping = KYS_GetPingValue()
                KYS_PingFPSState.Frames = 0
                KYS_PingFPSState.LastUpdate = now

                if not (KYS_PingFPSState.Gui and KYS_PingFPSState.Gui.Parent) then
                    KYS_PingFPSState.Gui = KYS_CreatePingFPSGui()
                end

                local label = KYS_PingFPSState.Gui and KYS_PingFPSState.Gui:FindFirstChild("PingFPSLabel", true)
                if label then
                    label.Text = ("PING: %sms\nFPS: %d"):format(ping and tostring(ping) or "--", fps)
                end
            end)
        end
    else
        if KYS_PingFPSState.Connection then
            pcall(function() KYS_PingFPSState.Connection:Disconnect() end)
            KYS_PingFPSState.Connection = nil
        end
        if KYS_PingFPSState.Gui then
            pcall(function() KYS_PingFPSState.Gui:Destroy() end)
            KYS_PingFPSState.Gui = nil
        end
    end
end

getgenv().KYS_SetShowPingFPS = KYS_SetShowPingFPS
end)();

-- =====================================================
-- SILENT AIM: FLASHLIGHT
-- =====================================================
(function()
local KYS_FlashlightAimState = {
    Connection = nil,
    LaserBeam = nil,
    FlashlightPart = nil,
    Active = false,
}

local function KYS_GetFlashlightActivateRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local items = remotes and remotes:FindFirstChild("Items")
    local flashlight = items and items:FindFirstChild("Flashlight")
    local activate = flashlight and flashlight:FindFirstChild("Activate")
    if activate and activate:IsA("RemoteEvent") then
        return activate
    end
    return nil
end

local function KYS_GetFlashlightTargetPart(char)
    if not char then return nil end
    local preferred = VD.FLASH_TargetPart or "Head"
    local part = char:FindFirstChild(preferred)
    if part and part:IsA("BasePart") then return part end
    return char:FindFirstChild("Head")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("HumanoidRootPart")
end

local function KYS_IsAliveCharacter(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local state = char:GetAttribute("State")
    return state ~= "Dead"
end

local function KYS_GetFlashlightTarget()
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end

    local maxRange = tonumber(VD.FLASH_Range) or 120
    local bestPart, bestScore = nil, math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and KYS_IsAliveCharacter(player.Character) then
            local isKiller = player.Team and player.Team.Name == "Killer"
            if isKiller then
                local part = KYS_GetFlashlightTargetPart(player.Character)
                if part then
                    local dist = (localRoot.Position - part.Position).Magnitude
                    if dist <= maxRange and dist < bestScore then
                        bestScore = dist
                        bestPart = part
                    end
                end
            end
        end
    end

    return bestPart
end

local function KYS_ClearFlashlightLaser()
    if KYS_FlashlightAimState.LaserBeam then
        pcall(function() KYS_FlashlightAimState.LaserBeam:Destroy() end)
        KYS_FlashlightAimState.LaserBeam = nil
    end
end

local function KYS_GetFlashlightOrigin(cam)
    local source = KYS_FlashlightAimState.FlashlightPart
    if typeof and typeof(source) == "Instance" then
        if source:IsA("BasePart") then
            return source.Position
        end
        local part = source:FindFirstChildWhichIsA("BasePart", true)
        if part then
            return part.Position
        end
    end

    local char = LocalPlayer.Character
    local hand = char and (
        char:FindFirstChild("RightHand")
        or char:FindFirstChild("Right Arm")
        or char:FindFirstChild("HumanoidRootPart")
    )
    if hand and hand:IsA("BasePart") then
        return hand.Position
    end

    return cam and cam.CFrame.Position or nil
end

local function KYS_UpdateFlashlightLaser(originPos, targetPos)
    if not KYS_FlashlightAimState.LaserBeam then
        local laser = Instance.new("Part")
        laser.Name = "FlashlightSilentAimLaser"
        laser.Anchored = true
        laser.CanCollide = false
        laser.CanTouch = false
        laser.CastShadow = false
        laser.Material = Enum.Material.Neon
        laser.Color = Color3.fromRGB(80, 220, 255)
        laser.Transparency = 0
        laser.Parent = workspace
        KYS_FlashlightAimState.LaserBeam = laser
    end

    local dist = (targetPos - originPos).Magnitude
    if dist < 0.1 then return end

    local laser = KYS_FlashlightAimState.LaserBeam
    laser.Size = Vector3.new(0.16, 0.16, dist)
    laser.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
    laser.Transparency = 0
end

local function KYS_FlashlightAimStep()
    if false then
        if KYS_FlashlightAimState.LaserBeam then
            KYS_FlashlightAimState.LaserBeam.Transparency = 1
        end
        return
    end

    if not (VD.FLASH_SilentAim and KYS_FlashlightAimState.Active) then
        if KYS_FlashlightAimState.LaserBeam then
            KYS_FlashlightAimState.LaserBeam.Transparency = 1
        end
        return
    end

    local cam = workspace.CurrentCamera
    local targetPart = KYS_GetFlashlightTarget()
    if not (cam and targetPart) then
        if KYS_FlashlightAimState.LaserBeam then
            KYS_FlashlightAimState.LaserBeam.Transparency = 1
        end
        return
    end

    local targetPos = targetPart.Position
    local smooth = math.clamp(tonumber(VD.FLASH_Smooth) or 0.35, 0.05, 1)
    local originPos = KYS_GetFlashlightOrigin(cam)

    if VD.FLASH_Laser and originPos then
        KYS_UpdateFlashlightLaser(originPos, targetPos)
    elseif KYS_FlashlightAimState.LaserBeam then
        KYS_FlashlightAimState.LaserBeam.Transparency = 1
    end

    pcall(function()
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, targetPos), smooth)
    end)

    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
        end
    end)
end

local function KYS_StartFlashlightSilentAim()
    getgenv().KYS_FlashlightActivateRemote = KYS_GetFlashlightActivateRemote()
    if KYS_FlashlightAimState.Connection then return end
    KYS_FlashlightAimState.Connection = RunService.RenderStepped:Connect(KYS_FlashlightAimStep)
end

local function KYS_StopFlashlightSilentAim()
    KYS_FlashlightAimState.Active = false
    KYS_FlashlightAimState.FlashlightPart = nil
    KYS_ClearFlashlightLaser()
    if KYS_FlashlightAimState.Connection then
        pcall(function() KYS_FlashlightAimState.Connection:Disconnect() end)
        KYS_FlashlightAimState.Connection = nil
    end
end

local function KYS_SetFlashlightSilentAim(enabled)
    if enabled and false then
        VD.FLASH_SilentAim = false
        KYS_StopFlashlightSilentAim()
        return
    end

    VD.FLASH_SilentAim = enabled and true or false
    if VD.FLASH_SilentAim then
        KYS_StartFlashlightSilentAim()
    else
        KYS_StopFlashlightSilentAim()
    end
end

getgenv().KYS_SetFlashlightSilentAim = KYS_SetFlashlightSilentAim
getgenv().KYS_ClearFlashlightLaser = KYS_ClearFlashlightLaser
getgenv().KYS_SetFlashlightAimActive = function(active, flashlightPart)
    KYS_FlashlightAimState.Active = active and true or false
    if KYS_FlashlightAimState.Active and flashlightPart then
        KYS_FlashlightAimState.FlashlightPart = flashlightPart
    elseif not KYS_FlashlightAimState.Active then
        KYS_FlashlightAimState.FlashlightPart = nil
    end
    if not KYS_FlashlightAimState.Active and KYS_FlashlightAimState.LaserBeam then
        KYS_FlashlightAimState.LaserBeam.Transparency = 1
    end
end
getgenv().KYS_FlashlightActivateRemote = KYS_GetFlashlightActivateRemote()
end)();

local VD_Parry = {
    PreciseDistanceEnabled = true,
    MaxDistance = 14,
    CanParry = true,
    IsParrying = false,
    CooldownEndTime = 0,
    KillerAnimator = nil,
    KillerChar = nil,
    KillerPlayer = nil,
    Connections = {},
    FiredTracks = {},
    RenderConnection = nil,
    LastStatus = "Off",
}

local VD_ParryAnimation = Instance.new("Animation")
VD_ParryAnimation.AnimationId = "rbxassetid://109133187196613"

local VD_ParryRange = Instance.new("CylinderHandleAdornment")
VD_ParryRange.Name = "KYS_ParryRange"
VD_ParryRange.Radius = VD.SURV_ParryDistance or 8
VD_ParryRange.InnerRadius = math.max(0.1, (VD.SURV_ParryDistance or 8) - 0.15)
VD_ParryRange.Height = 0.01
VD_ParryRange.Color3 = Color3.fromRGB(128, 128, 128)
VD_ParryRange.AlwaysOnTop = false
VD_ParryRange.Adornee = Workspace:FindFirstChildOfClass("Terrain")
VD_ParryRange.Transparency = 1
VD_ParryRange.Parent = GetSafeGuiParent()

local VD_ATTACK_ANIMS = {
    ["rbxassetid://113255068724446"] = true,
    ["rbxassetid://74968262036854"] = true,
    ["rbxassetid://110355011987939"] = true,
    ["rbxassetid://139369275981139"] = true,
    ["rbxassetid://132817836308238"] = true,
    ["rbxassetid://129784271201071"] = true,
    ["rbxassetid://133963973694098"] = true,
    ["rbxassetid://117042998468241"] = true,
    ["rbxassetid://105374834496520"] = true,
    ["rbxassetid://111920872708571"] = true,
    ["rbxassetid://78432063483146"] = true,
    ["rbxassetid://118907603246885"] = true,
    ["rbxassetid://138720291317243"] = true,
    ["rbxassetid://115244153053858"] = true,
    ["rbxassetid://130593238885843"] = true,
    ["rbxassetid://122812055447896"] = true,
    ["rbxassetid://78935059863801"] = true,
    ["rbxassetid://135002183282873"] = true,
    ["rbxassetid://121216847022485"] = true,
}

function VD_UpdateParryRange()
    if not VD.SURV_ShowParryCircle or not VD.SURV_AutoParry then
        VD_ParryRange.Transparency = 1
        return
    end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        VD_ParryRange.Transparency = 1
        return
    end

    local currentMaxDist = VD_Parry.PreciseDistanceEnabled and (VD.SURV_ParryDistance or 8) or VD_Parry.MaxDistance
    VD_ParryRange.Transparency = 0.4
    VD_ParryRange.Radius = currentMaxDist
    VD_ParryRange.InnerRadius = math.max(0.1, currentMaxDist - 0.15)

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = { char }
    params.FilterType = Enum.RaycastFilterType.Exclude

    local ray = Workspace:Raycast(root.Position, Vector3.new(0, -15, 0), params)
    local groundPos = ray and ray.Position or (root.Position - Vector3.new(0, 3, 0))
    VD_ParryRange.CFrame = CFrame.new(groundPos + Vector3.new(0, 0.05, 0)) * CFrame.Angles(math.pi / 2, 0, 0)
end

function VD_GetParryRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local items = remotes and remotes:FindFirstChild("Items")
    local dagger = items and items:FindFirstChild("Parrying Dagger")
    return dagger and dagger:FindFirstChild("parry")
end

function VD_RefreshLocalCombatCache()
    local char = LocalPlayer.Character
    Root = char and char:FindFirstChild("HumanoidRootPart") or Root
    Humanoid = char and char:FindFirstChildOfClass("Humanoid") or Humanoid
end

local State = { ParryCooldown = false, ParryCooldownThread = nil }
local Attached = {}
function IsKiller(p) return p.Team and p.Team.Name == "Killer" end
function IsDowned(char) local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return true end; local state = char:GetAttribute("State"); return state == "Downed" or state == "Dead" end
function TriggerCrouch()
    local startT = tick()
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        -- Toggle crouch ON: replicate mobile SurvivorAnimationsController logic
        pcall(function() char:SetAttribute("Crouching", true) end)
        pcall(function() ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", true) end)
        pcall(function() ReplicatedStorage.Remotes.Chase.Runevent:FireServer(char, false) end)
        if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Landed) end) end
        
        -- Also fire the mobile crouch button signal for visual sync
        pcall(function()
            local survMob = LocalPlayer:FindFirstChildOfClass("PlayerGui"):FindFirstChild("Survivor-mob")
            if survMob then
                local controls = survMob:FindFirstChild("Controls")
                if controls then
                    local crouchBtn = controls:FindFirstChild("crouch")
                    if crouchBtn then
                        firesignal(crouchBtn.MouseButton1Click)
                    end
                end
            end
        end)
        
        while tick() - startT < 1.2 do
            pcall(function() ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", true) end)
            task.wait(0.1)
        end
        
        -- Toggle crouch OFF
        pcall(function() char:SetAttribute("Crouching", false) end)
        pcall(function() ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", false) end)
        if humanoid then pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Landed) end) end
        
        -- Fire crouch button again to toggle OFF visually
        pcall(function()
            local survMob = LocalPlayer:FindFirstChildOfClass("PlayerGui"):FindFirstChild("Survivor-mob")
            if survMob then
                local controls = survMob:FindFirstChild("Controls")
                if controls then
                    local crouchBtn = controls:FindFirstChild("crouch")
                    if crouchBtn then
                        firesignal(crouchBtn.MouseButton1Click)
                    end
                end
            end
        end)
    end)
end
function IsSafeToParry(char) return not IsDowned(char) end
local player = LocalPlayer
-- ==================== AUTO PARRY SENSOR ====================
function tapMobileParryButton()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local survivorMob = playerGui:FindFirstChild("Survivor-mob")
    local parryBtn = survivorMob
        and survivorMob:FindFirstChild("Controls")
        and survivorMob.Controls:FindFirstChild("Gui-mob")

    if parryBtn and parryBtn.Visible then
        if firesignal then
            pcall(function()
                firesignal(parryBtn.MouseButton1Down)
                task.wait(0.01)
                firesignal(parryBtn.MouseButton1Up)
            end)
        end
    else
        pcall(function()
            if mouse2click then
                mouse2click()
                return
            end
            if mouse2press and mouse2release then
                mouse2press()
                task.wait(0.01)
                mouse2release()
                return
            end
            if MouseButton2Click then
                MouseButton2Click()
                return
            end
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
        end)
    end
end

function ExecuteParry()
    if State.ParryCooldown then return end
    pcall(function()
        local parryRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Items"):FindFirstChild("Parrying Dagger"):FindFirstChild("parry")
        if parryRemote then
            for i = 1, 10 do parryRemote:FireServer() end
        end
        task.spawn(tapMobileParryButton)
    end)
end

function ListenToParryResult()
    task.spawn(function()
        local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5)
        local dagger = remotes and remotes:WaitForChild("Items", 5):WaitForChild("Parrying Dagger", 5)
        local parryResultRemote = dagger and dagger:WaitForChild("parryResult", 5)
        
        if parryResultRemote then
            parryResultRemote.OnClientEvent:Connect(function(arg1, arg2)
                local cdDur = tonumber(arg2) or ((arg1 == true) and 90 or 60)
                State.ParryCooldown = true
                if State.ParryCooldownThread then task.cancel(State.ParryCooldownThread) end
                State.ParryCooldownThread = task.delay(cdDur, function()
                    State.ParryCooldown = false
                end)
            end)
        end
    end)
end
ListenToParryResult()

function AttachParrySensor(kChar)
    if not kChar or Attached[kChar] then return end
    Attached[kChar] = true
    local humanoid = kChar:FindFirstChild("Humanoid")
    if not humanoid then
        humanoid = kChar:WaitForChild("Humanoid", 5)
        if not humanoid then return end
    end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = humanoid:WaitForChild("Animator", 5)
        if not animator then return end
    end

    humanoid.ChildAdded:Connect(function(child)
        if child:IsA("Animator") then
            Attached[kChar] = nil
            AttachParrySensor(kChar)
        end
    end)

    kChar.AncestryChanged:Connect(function(_, parent)
        if not parent then
            Attached[kChar] = nil
        end
    end)

    animator.AnimationPlayed:Connect(function(track)
        local animId = track.Animation and track.Animation.AnimationId or ""
        local id = animId:match("%d+")
        
        -- Auto Crouch untuk Abyssal S1
        if id == "80411309607666" and VD.AutoCrouch then
            local myChar = LocalPlayer.Character
            if IsDowned(myChar) then return end
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local kHRP = kChar:FindFirstChild("HumanoidRootPart")
            if myHRP and kHRP then
                local dist = (myHRP.Position - kHRP.Position).Magnitude
                if dist <= 40 then
                    TriggerCrouch()
                end
            end
            return 
        end
        
        local attackName = VD_ATTACK_ANIMS[animId]
        if not attackName then return end
        
        if not VD.SURV_AutoParry then return end
        if State.ParryCooldown then return end 
        if VD.Ignored_Skills_List and VD.Ignored_Skills_List[attackName] then return end

        local myChar = LocalPlayer.Character
        if IsDowned(myChar) or not IsSafeToParry(myChar) then return end
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local kHRP = kChar:FindFirstChild("HumanoidRootPart")
        if not myHRP or not kHRP then return end
        
        local delta = myHRP.Position - kHRP.Position
        local startDistance = delta.Magnitude

        if VD.SURV_ParryAggressive then
            local aggressiveRadius = 12
            local detectionRadius = VD.SURV_ParryDistance + 5
            if startDistance > detectionRadius then return end
            if startDistance <= aggressiveRadius then
                ExecuteParry()
            else
                local tracker
                local startTime = os.clock()
                tracker = RunService.Heartbeat:Connect(function()
                    if os.clock() - startTime >= 1.5 or State.ParryCooldown or not myHRP or not kHRP or IsDowned(myChar) then
                        if tracker then tracker:Disconnect() end
                        return
                    end
                    local currentDist = (myHRP.Position - kHRP.Position).Magnitude
                    if currentDist <= aggressiveRadius then
                        ExecuteParry()
                        if tracker then tracker:Disconnect() end
                    end
                end)
            end
        else
            if startDistance > VD.SURV_ParryDistance then return end
            local myPosFlat = Vector3.new(myHRP.Position.X, 0, myHRP.Position.Z)
            local kPosFlat = Vector3.new(kHRP.Position.X, 0, kHRP.Position.Z)
            local flatDelta = myPosFlat - kPosFlat
            if flatDelta.Magnitude > 0 then
                local flatDirection = flatDelta.Unit
                local kLookFlat = Vector3.new(kHRP.CFrame.LookVector.X, 0, kHRP.CFrame.LookVector.Z).Unit
                local isFacing = kLookFlat:Dot(flatDirection)
                if isFacing < 0.6 then return end
            end
            ExecuteParry()
        end
    end)
end

function TryAttach(p)
    if p ~= player and IsKiller(p) and p.Character then 
        AttachParrySensor(p.Character) 
    end
end

function SetupPlayer(p)
    if p == player then return end
    p.CharacterAdded:Connect(function() TryAttach(p) end)
    p:GetPropertyChangedSignal("Team"):Connect(function() TryAttach(p) end)
    if p.Character then TryAttach(p) end
end

-- Setup Parry Sensor
for _, p in pairs(Players:GetPlayers()) do 
    SetupPlayer(p) 
end
Players.PlayerAdded:Connect(SetupPlayer)

task.spawn(function()
    while true do 
        task.wait(5) 
        for _, p in pairs(Players:GetPlayers()) do 
            TryAttach(p) 
        end 
    end
end)


function VD_SetAutoParry(state)
    VD.SURV_AutoParry = state == true
    if VD.SURV_AutoParry then
        if not _G.VD_ParryRenderConnection then
            _G.VD_ParryRenderConnection = game:GetService('RunService').RenderStepped:Connect(function()
                if type(VD_UpdateParryRange) == 'function' then VD_UpdateParryRange() end
            end)
        end
    else
        if typeof(VD_ParryRange) == 'Instance' then VD_ParryRange.Transparency = 1 end
        if _G.VD_ParryRenderConnection then
            _G.VD_ParryRenderConnection:Disconnect()
            _G.VD_ParryRenderConnection = nil
        end
    end
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local AutoSkill = {
    LastGoalRotation = nil,
    HasClickedThisGoal = false,
    LastLineRotation = nil,
    LastTick = nil,
    WasActive = false,
    PerfectLastGoalRotation = nil,
    PerfectHasClickedThisGoal = false,
    PerfectLastLineRotation = nil,
    PerfectLastTick = nil,
    PerfectWasActive = false,
    InstantLastTriggerTick = 0,
    InstantLastGoalRotation = 0,
    InstantLastGoalInstance = nil,
    InstantCurrentGoalID = 0,
    InstantHasClicked = false,
    InstantForcingRotation = false,
    InstantRotationConnection = nil,
}

function VD_PressSkill()
    if isMobile then
        local btn = PlayerGui:FindFirstChild("check", true)
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local x = pos.X + (size.X / 2) + inset.X
            local y = pos.Y + (size.Y / 2) + inset.Y
            pcall(function() VirtualInputManager:SendTouchEvent(8822, Enum.UserInputState.Begin.Value, x, y) end)
            task.wait(0.01)
            pcall(function() VirtualInputManager:SendTouchEvent(8822, Enum.UserInputState.End.Value, x, y) end)
            pcall(function()
                if firesignal and btn.MouseButton1Click then
                    firesignal(btn.MouseButton1Click)
                end
            end)
        end
    else
        pcall(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game) end)
        task.wait(0.01)
        pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game) end)
    end
end

function VD_GetSkillCheck()
    for _, guiName in ipairs({ "SkillCheckPromptGui", "SkillCheckPromptGui-con" }) do
        local gui = PlayerGui:FindFirstChild(guiName, true)
        if gui then
            local check = gui:FindFirstChild("Check", true)
            if check and check.Visible then
                local line = check:FindFirstChild("Line", true)
                local goal = check:FindFirstChild("Goal", true)
                if line and goal then return line, goal end
            end
        end
    end
end

function VD_AngularDelta(from, to)
    local d = to - from
    if d > 180 then d = d - 360 end
    if d < -180 then d = d + 360 end
    return d
end

function VD_CrossedZone(prevLr, lr, startPos, endPos)
    local function inZone(r)
        if startPos > endPos then
            return r >= startPos or r <= endPos
        end
        return r >= startPos and r <= endPos
    end
    if inZone(lr) then return true end
    if prevLr == nil then return false end
    local delta = VD_AngularDelta(prevLr, lr)
    local steps = math.abs(math.floor(delta))
    if steps < 2 then return false end
    local stepSize = delta / steps
    for i = 1, steps do
        if inZone((prevLr + stepSize * i) % 360) then return true end
    end
    return false
end

function VD_NormalSkillcheckUpdate()
    local line, goal = VD_GetSkillCheck()
    if not (line and goal) then
        AutoSkill.LastGoalRotation = nil
        AutoSkill.HasClickedThisGoal = false
        AutoSkill.LastLineRotation = nil
        AutoSkill.LastTick = nil
        AutoSkill.WasActive = false
        return
    end

    local lr = line.Rotation % 360
    local gr = goal.Rotation % 360
    local now = os.clock()
    if not AutoSkill.WasActive then
        AutoSkill.WasActive = true
        AutoSkill.HasClickedThisGoal = false
        AutoSkill.LastGoalRotation = gr
        AutoSkill.LastLineRotation = lr
        AutoSkill.LastTick = now
        return
    end
    if AutoSkill.LastGoalRotation and math.abs(VD_AngularDelta(AutoSkill.LastGoalRotation, gr)) > 5 then
        AutoSkill.HasClickedThisGoal = false
        AutoSkill.LastLineRotation = nil
        AutoSkill.LastTick = nil
    end
    AutoSkill.LastGoalRotation = gr
    if AutoSkill.HasClickedThisGoal then
        AutoSkill.LastLineRotation = lr
        AutoSkill.LastTick = now
        return
    end
    if AutoSkill.LastLineRotation and AutoSkill.LastTick then
        local dt = now - AutoSkill.LastTick
        if dt > 0 then
            local lineSpeed = VD_AngularDelta(AutoSkill.LastLineRotation, lr) / dt
            local predicted = (lr + lineSpeed * dt * 0) % 360
            if VD_CrossedZone(AutoSkill.LastLineRotation, predicted, (gr + 104) % 360, (gr + 109) % 360) then
                AutoSkill.HasClickedThisGoal = true
                task.spawn(function()
                    task.wait(0.03)
                    VD_PressSkill()
                end)
            end
        end
    end
    AutoSkill.LastLineRotation = lr
    AutoSkill.LastTick = now
end

function VD_PerfectSkillcheckUpdate()
    local line, goal = VD_GetSkillCheck()
    if not (line and goal) then
        AutoSkill.PerfectLastGoalRotation = nil
        AutoSkill.PerfectHasClickedThisGoal = false
        AutoSkill.PerfectLastLineRotation = nil
        AutoSkill.PerfectLastTick = nil
        AutoSkill.PerfectWasActive = false
        return
    end

    local lr = line.Rotation % 360
    local gr = goal.Rotation % 360
    local now = os.clock()
    if not AutoSkill.PerfectWasActive then
        AutoSkill.PerfectWasActive = true
        AutoSkill.PerfectHasClickedThisGoal = false
        AutoSkill.PerfectLastGoalRotation = gr
        AutoSkill.PerfectLastLineRotation = lr
        AutoSkill.PerfectLastTick = now
        return
    end
    if AutoSkill.PerfectLastGoalRotation and math.abs(VD_AngularDelta(AutoSkill.PerfectLastGoalRotation, gr)) > 5 then
        AutoSkill.PerfectHasClickedThisGoal = false
        AutoSkill.PerfectLastLineRotation = nil
        AutoSkill.PerfectLastTick = nil
    end
    AutoSkill.PerfectLastGoalRotation = gr
    if AutoSkill.PerfectHasClickedThisGoal then
        AutoSkill.PerfectLastLineRotation = lr
        AutoSkill.PerfectLastTick = now
        return
    end
    if AutoSkill.PerfectLastLineRotation and AutoSkill.PerfectLastTick then
        local dt = now - AutoSkill.PerfectLastTick
        if dt > 0 then
            local lineSpeed = VD_AngularDelta(AutoSkill.PerfectLastLineRotation, lr) / dt
            local predicted = (lr + lineSpeed * dt * 0) % 360
            if VD_CrossedZone(AutoSkill.PerfectLastLineRotation, predicted, (gr + 104) % 360, (gr + 108) % 360) then
                AutoSkill.PerfectHasClickedThisGoal = true
                VD_PressSkill()
            end
        end
    end
    AutoSkill.PerfectLastLineRotation = lr
    AutoSkill.PerfectLastTick = now
end

function VD_InstantSkillcheckUpdate()
    if AutoSkill.InstantHasClicked then return end

    -- Exact Fallens.lua logic: non-recursive FindFirstChild
    local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
    if not prompt then
        prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui-con")
    end
    if not prompt then return end

    local check = prompt:FindFirstChild("Check")
    if not check or not check.Visible then return end

    local line = check:FindFirstChild("Line")
    local goal = check:FindFirstChild("Goal")
    if not line or not goal then return end

    -- Exact Fallens.lua logic: raw rotation WITHOUT modulo
    line.Rotation = goal.Rotation + 109

    AutoSkill.InstantHasClicked = true
    task.spawn(function()
        VD_PressSkill()
        task.wait(0.2)
        AutoSkill.InstantHasClicked = false
    end)
end

RunService.RenderStepped:Connect(function()
    if not VD.AutoSkillcheck then return end
    if VD.AutoSkillcheckMode == "Perfect" then
        VD_PerfectSkillcheckUpdate()
    elseif VD.AutoSkillcheckMode == "Instant" then
        VD_InstantSkillcheckUpdate()
    else
        VD_NormalSkillcheckUpdate()
    end
end)

function VD_SetAutoSkillcheck(state)
    VD.AutoSkillcheck = state == true
    if not VD.AutoSkillcheck then
        if AutoSkill.InstantRotationConnection then
            AutoSkill.InstantRotationConnection:Disconnect()
            AutoSkill.InstantRotationConnection = nil
        end
        AutoSkill.InstantHasClicked = false
        AutoSkill.WasActive = false
        AutoSkill.PerfectWasActive = false
        VD_Notify("Auto Skillcheck", "Disabled", 2)
    else
        VD_Notify("Auto Skillcheck", "Enabled (" .. tostring(VD.AutoSkillcheckMode or "Normal") .. " Mode)", 2)
    end
end

-- =====================================================
-- INSTANT HEAL & AUTO HEAL ALL
-- =====================================================
InstantHealSelf = false
AutoHealAll = false
AutoSelfUnhook = false
AutoHealAllConnection = nil
InstantHealConnection = nil
AutoSelfUnhookConnection = nil

function doSelfHeal()
	local char = LocalPlayer.Character
	if not char then return end
	local skillCheckRemote = ReplicatedStorage.Remotes.Healing.SkillCheckResultEvent
	pcall(function() skillCheckRemote:FireServer("success", 100, char) end)
end

function doSelfHealTrue()
	local char = LocalPlayer.Character
	if not char then return end
	local healRemote = ReplicatedStorage.Remotes.Healing.HealEvent
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	pcall(function() healRemote:FireServer(hrp, true) end)
end

function doSelfHealFalse()
	local char = LocalPlayer.Character
	if not char then return end
	local healRemote = ReplicatedStorage.Remotes.Healing.HealEvent
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	pcall(function() healRemote:FireServer(hrp, false) end)
end

function doOthersHealSkillCheck(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local skillCheckRemote = ReplicatedStorage.Remotes.Healing.SkillCheckResultEvent
	pcall(function() skillCheckRemote:FireServer("success", 100, targetPlayer.Character) end)
end

function doOthersHealTrue(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end
	local healRemote = ReplicatedStorage.Remotes.Healing.HealEvent
	pcall(function() healRemote:FireServer(targetHRP, true) end)
end

function doOthersHealFalse(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end
	local healRemote = ReplicatedStorage.Remotes.Healing.HealEvent
	pcall(function() healRemote:FireServer(targetHRP, false) end)
end

function setInstantHealSelf(v)
    InstantHealSelf = v
    if v then
        local healActive = false
        if InstantHealConnection then InstantHealConnection:Disconnect() end
        InstantHealConnection = RunService.Heartbeat:Connect(function(dt)
            if not InstantHealSelf then return end
            local myChar = LocalPlayer.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if not myHum then return end
            
            if myHum.Health >= myHum.MaxHealth * 0.9 then 
                -- Auto stop heal when HP is full
                if healActive then
                    healActive = false
                    doSelfHealFalse()
                end
                return 
            end
            
            -- Check if game cancelled our heal (e.g. player moved)
            if healActive then
                local checkScript = myChar:FindFirstChild("CheckInterractable")
                if checkScript and not checkScript:GetAttribute("isHealing") then
                    -- Game cancelled our heal, reset so we can restart
                    healActive = false
                end
            end
            
            -- Start heal (or restart after being cancelled)
            if not healActive then
                healActive = true
                doSelfHealTrue()
            end
        end)
    else
        if InstantHealConnection then InstantHealConnection:Disconnect(); InstantHealConnection = nil end
        -- Send stop heal just in case
        pcall(doSelfHealFalse)
    end
end

function setAutoHealAll(v)
    AutoHealAll = v
    if v then
        local activeHeals = {} -- [player] = true if we're currently healing them
        if AutoHealAllConnection then AutoHealAllConnection:Disconnect() end
        AutoHealAllConnection = RunService.Heartbeat:Connect(function(dt)
            if not AutoHealAll then return end
            for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					local hrp = player.Character:FindFirstChild("HumanoidRootPart")
					local hum = player.Character:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 and hum.Health < hum.MaxHealth * 0.9 and hrp then
						-- Check if game cancelled our heal on this player (e.g. we or they moved)
						if activeHeals[player] then
							local myChar = LocalPlayer.Character
							local checkScript = myChar and myChar:FindFirstChild("CheckInterractable")
							if checkScript and not checkScript:GetAttribute("isHealing") then
								activeHeals[player] = nil
							end
						end
						-- Start healing this player if not already
						if not activeHeals[player] then
							activeHeals[player] = true
							doOthersHealTrue(player)
						end
					else
						-- Stop healing if HP is full or dead
						if activeHeals[player] then
							activeHeals[player] = nil
							doOthersHealFalse(player)
						end
					end
				else
					-- Player left or no character
					if activeHeals[player] then
						activeHeals[player] = nil
						pcall(function() doOthersHealFalse(player) end)
					end
				end
			end
        end)
    else
        if AutoHealAllConnection then AutoHealAllConnection:Disconnect(); AutoHealAllConnection = nil end
    end
end





-- =====================================================
-- GEN BOOST BYPASS
-- =====================================================
GenBypass = {
    Enabled     = false,
    Button      = nil,
    UI          = nil,
    Cache       = {},
    CacheTimer  = 0,
    Processed   = {},
    HotkeyCode  = Enum.KeyCode.G,
}

function GB_GetAllGenerators()
    local now = tick()
    if now - GenBypass.CacheTimer < 5 then return GenBypass.Cache end
    GenBypass.Cache = {}
    GenBypass.CacheTimer = now
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return GenBypass.Cache end
    pcall(function()
        for _, v in pairs(mapFolder:GetDescendants()) do
            if not v:IsA("Model") then continue end
            if v.Name ~= "Generator" then continue end
            local isReal = v:GetAttribute("RepairProgress") ~= nil
                or v:GetAttribute("kickcount") ~= nil
                or v:GetAttribute("ProgressRepair") ~= nil
            if isReal then table.insert(GenBypass.Cache, v) end
        end
    end)
    return GenBypass.Cache
end

function GB_GetPoints(genModel)
    local points = {}
    pcall(function()
        for _, obj in pairs(genModel:GetChildren()) do
            if obj.Name:find("GeneratorPoint") and obj:IsA("BasePart") then
                table.insert(points, obj)
            end
        end
    end)
    return points
end

function GB_WaitRepairing(point, timeout)
    local start = tick()
    while tick() - start < (timeout or 1) do
        if point:GetAttribute("IsRepairing") == true then return true end
        task.wait(0.05)
    end
    return false
end

function GB_DoRepair(targetPoint)
    local genModel = targetPoint.Parent
    if GenBypass.Processed[genModel] then return end
    GenBypass.Processed[genModel] = true

    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then GenBypass.Processed[genModel] = nil return end

    local RepairEvent = ReplicatedStorage:FindFirstChild("Remotes")
        and ReplicatedStorage.Remotes:FindFirstChild("Generator")
        and ReplicatedStorage.Remotes.Generator:FindFirstChild("RepairEvent")

    local originalCFrame = hrp.CFrame
    pcall(function()
        for _, point in pairs(GB_GetPoints(genModel)) do
            if point ~= targetPoint and point.Parent then
                hrp.Anchored = true
                hrp.CFrame = point.CFrame
                task.wait(0.15)
                pcall(function() if RepairEvent then RepairEvent:FireServer(point, true) end end)
                if not GB_WaitRepairing(point, 0.8) then
                    pcall(function() if RepairEvent then RepairEvent:FireServer(point, false) end end)
                    task.wait(0.1)
                    hrp.CFrame = point.CFrame
                    task.wait(0.15)
                    pcall(function() if RepairEvent then RepairEvent:FireServer(point, true) end end)
                    GB_WaitRepairing(point, 0.5)
                end
                hrp.Anchored = false
                task.wait(0.05)
            end
        end
    end)
    pcall(function()
        if hrp and hrp.Parent then
            hrp.Anchored = false
            hrp.CFrame = originalCFrame
        end
    end)
    task.wait(0.1)
    pcall(function() if RepairEvent then RepairEvent:FireServer(targetPoint, false) end end)
end

function GB_GetNearestPoint()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local bestPoint, bestDist = nil, math.huge
    for _, gen in pairs(GB_GetAllGenerators()) do
        for _, point in pairs(GB_GetPoints(gen)) do
            local d = (hrp.Position - point.Position).Magnitude
            if d < bestDist then bestDist = d; bestPoint = point end
        end
    end
    return bestPoint, bestDist
end

function GB_IsPromptVisible()
    local ok, frame = pcall(function()
        return LocalPlayer.PlayerGui.pcprompts.Frame.GeneratorRepair
    end)
    return ok and frame and frame.Visible
end

function GB_UpdateButton()
    if GenBypass.Button then
        GenBypass.Button.Visible = GenBypass.Enabled and isMobile
    end
end

function GB_CreateButton()
    local oldUI = LocalPlayer.PlayerGui:FindFirstChild("BypassGenUI")
    if oldUI then oldUI:Destroy() end

    GenBypass.UI = Instance.new("ScreenGui")
    GenBypass.UI.Name = "BypassGenUI"
    GenBypass.UI.ResetOnSpawn = false
    GenBypass.UI.IgnoreGuiInset = true
    GenBypass.UI.Parent = LocalPlayer:WaitForChild("PlayerGui")

    GenBypass.Button = Instance.new("ImageButton")
    GenBypass.Button.Name = "BypassGenButton"
    GenBypass.Button.Size = UDim2.new(0, 60, 0, 60)
    GenBypass.Button.Position = UDim2.new(0.88, 0, 0.55, 0)
    GenBypass.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    GenBypass.Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GenBypass.Button.BackgroundTransparency = 0.15
    GenBypass.Button.AutoButtonColor = true
    GenBypass.Button.Visible = false
    GenBypass.Button.ZIndex = 10
    GenBypass.Button.Parent = GenBypass.UI
    Instance.new("UICorner", GenBypass.Button).CornerRadius = UDim.new(1, 0)
    
    local s = Instance.new("UIStroke", GenBypass.Button)
    s.Color = Color3.fromRGB(255, 255, 255)
    s.Thickness = 2; s.Transparency = 0.2
    
    local lbl = Instance.new("TextLabel", GenBypass.Button)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "BYPASS"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    local function applyShine(obj, baseColor)
        local grad = Instance.new("UIGradient", obj)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, baseColor),
            ColorSequenceKeypoint.new(0.4, baseColor),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.6, baseColor),
            ColorSequenceKeypoint.new(1, baseColor)
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(-1, -1)
        
        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local ti = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
            local tw = TweenService:Create(grad, ti, { Offset = Vector2.new(1, 1) })
            tw:Play()
        end)
    end
    
    applyShine(GenBypass.Button, Color3.fromRGB(20, 0, 30))
    applyShine(lbl, Color3.fromRGB(255, 0, 255))
    applyShine(s, Color3.fromRGB(255, 0, 255))

    GenBypass.Button.MouseButton1Click:Connect(function()
        if not GenBypass.Enabled then return end
        local bestPoint, bestDist = GB_GetNearestPoint()
        if bestPoint and bestDist <= 8 then GB_DoRepair(bestPoint) end
    end)
end

GB_CreateButton()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    GB_CreateButton()
    GB_UpdateButton()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if isMobile then return end
    if input.KeyCode == GenBypass.HotkeyCode and GenBypass.Enabled then
        if not GB_IsPromptVisible() then return end
        local bestPoint, bestDist = GB_GetNearestPoint()
        if not bestPoint or bestDist > 8 then return end
        if GenBypass.Processed[bestPoint.Parent] then return end
        GB_DoRepair(bestPoint)
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not GenBypass.Enabled then return end
    if not GB_IsPromptVisible() then return end
    local bestPoint, bestDist = GB_GetNearestPoint()
    if not bestPoint or bestDist > 8 then return end
    if GenBypass.Processed[bestPoint.Parent] then return end
    GB_DoRepair(bestPoint)
end)

task.spawn(function()
    while true do
        task.wait(2)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for genModel in pairs(GenBypass.Processed) do
                if not genModel or not genModel.Parent then
                    GenBypass.Processed[genModel] = nil
                    continue
                end
                local nearAny = false
                for _, point in pairs(GB_GetPoints(genModel)) do
                    if point.Parent and (hrp.Position - point.Position).Magnitude <= 10 then
                        nearAny = true; break
                    end
                end
                if not nearAny then GenBypass.Processed[genModel] = nil end
            end
        end
    end
end)

function setGenBypass(v)
    GenBypass.Enabled = v
    GB_UpdateButton()
end

function setAutoCrouch(v) VD.AutoCrouch = v end

-- =====================================================
-- INF GRAB (MYERS)
-- =====================================================
MyersGrabData = {
    Enabled = false,
    UI = nil,
    Button = nil,
    DragLocked = false,
    Dragging = false,
    DragStart = nil,
    DragStartPos = nil,
    HotkeyCode = Enum.KeyCode.H,
}

function getMyersTarget()
    local char = LocalPlayer.Character
    if not char then return nil end
    local myHRP = char:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    local candidates = {}
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                table.insert(candidates, {
                    player = player,
                    dist   = (hrp.Position - myHRP.Position).Magnitude,
                    health = hum.Health
                })
            end
        end
    end
    table.sort(candidates, function(a, b) return a.dist < b.dist end)
    for _, c in ipairs(candidates) do
        return c.player
    end
    return nil
end

function doMyersGrab()
    if not MyersGrabData.Enabled then return end
    local target = getMyersTarget()
    if not target or not target.Character then return end
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        ReplicatedStorage.Remotes.Killers.Stalker.grab:FireServer(target.Character)
    end)
end

function setupMyersGrabBtn()
    local oldUI = LocalPlayer.PlayerGui:FindFirstChild("MyersGrabUI")
    if oldUI then oldUI:Destroy() end

    MyersGrabData.UI = Instance.new("ScreenGui")
    MyersGrabData.UI.Name = "MyersGrabUI"
    MyersGrabData.UI.ResetOnSpawn = false
    MyersGrabData.UI.IgnoreGuiInset = true
    MyersGrabData.UI.Parent = LocalPlayer:WaitForChild("PlayerGui")

    MyersGrabData.Button = Instance.new("ImageButton")
    MyersGrabData.Button.Name = "MyersGrabButton"
    MyersGrabData.Button.Size = UDim2.new(0, 60, 0, 60)
    MyersGrabData.Button.Position = UDim2.new(0.7, 0, 0.75, 0)
    MyersGrabData.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    MyersGrabData.Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MyersGrabData.Button.BackgroundTransparency = 0.15
    MyersGrabData.Button.AutoButtonColor = true
    MyersGrabData.Button.Visible = false
    MyersGrabData.Button.ZIndex = 10
    MyersGrabData.Button.Parent = MyersGrabData.UI
    Instance.new("UICorner", MyersGrabData.Button).CornerRadius = UDim.new(1, 0)
    
    local s = Instance.new("UIStroke", MyersGrabData.Button)
    s.Color = Color3.fromRGB(255, 255, 255)
    s.Thickness = 2; s.Transparency = 0.2
    
    local lbl = Instance.new("TextLabel", MyersGrabData.Button)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "GRAB"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    local function applyShine(obj, baseColor)
        local grad = Instance.new("UIGradient", obj)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, baseColor),
            ColorSequenceKeypoint.new(0.4, baseColor),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.6, baseColor),
            ColorSequenceKeypoint.new(1, baseColor)
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(-1, -1)
        
        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local ti = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
            local tw = TweenService:Create(grad, ti, { Offset = Vector2.new(1, 1) })
            tw:Play()
        end)
    end
    
    applyShine(MyersGrabData.Button, Color3.fromRGB(20, 0, 30))
    applyShine(lbl, Color3.fromRGB(255, 0, 255))
    applyShine(s, Color3.fromRGB(255, 0, 255))

    MyersGrabData.Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if MyersGrabData.DragLocked then return end
            MyersGrabData.Dragging = true
            MyersGrabData.DragStart = input.Position
            MyersGrabData.DragStartPos = MyersGrabData.Button.Position
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if MyersGrabData.Dragging and not MyersGrabData.DragLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - MyersGrabData.DragStart
            MyersGrabData.Button.Position = UDim2.new(
                MyersGrabData.DragStartPos.X.Scale, MyersGrabData.DragStartPos.X.Offset + delta.X, 
                MyersGrabData.DragStartPos.Y.Scale, MyersGrabData.DragStartPos.Y.Offset + delta.Y
            )
        end
    end)

    MyersGrabData.Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            MyersGrabData.Dragging = false
        end
    end)

    MyersGrabData.Button.MouseButton1Click:Connect(doMyersGrab)
end

setupMyersGrabBtn()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    setupMyersGrabBtn()
    if MyersGrabData.Button then
        MyersGrabData.Button.Visible = MyersGrabData.Enabled
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == MyersGrabData.HotkeyCode and MyersGrabData.Enabled then
        doMyersGrab()
    end
end)

function setMyersGrab(v)
    MyersGrabData.Enabled = v
    if MyersGrabData.Button then
        MyersGrabData.Button.Visible = v
    end
end

function setMyersDragLocked(v)
    MyersGrabData.DragLocked = v
end

-- =====================================================
-- VEIL AIMBOT (PREDICTION)
-- =====================================================
VeilConfig = {
    Enabled              = false,
    ShowFOV              = true,
    ShowTargetLaser      = true,
    FOV                  = 150,
    SpearSpeed           = 165,
    Gravity              = workspace.Gravity * 0.5,
    MaxDist              = 200,
    AutoPredict          = false,
    TargetPart           = "Torso",
    HorizontalPredictFactor = 1.0,
}

VeilState = {
    chargingSpear    = false,
    touchInput       = nil,
    attackCooldown   = false,
    passiveCooldown  = false,
    remoteHooked     = false,
    lastPredictedPos = nil,
}

VeilVelocityCache = {}

VeilDraw = {
    FOVCircle = Drawing.new("Circle"),
    Highlight = Instance.new("Highlight"),
    Tracer    = Drawing.new("Circle"),
}

VeilDraw.FOVCircle.Color     = Color3.fromRGB(255, 0, 255)
VeilDraw.FOVCircle.Thickness = 1.5
VeilDraw.FOVCircle.Filled    = false
VeilDraw.FOVCircle.Visible   = false

VeilDraw.Highlight.Name                = "VD_VeilTarget"
VeilDraw.Highlight.FillColor           = Color3.fromRGB(255, 0, 0)
VeilDraw.Highlight.OutlineColor        = Color3.fromRGB(255, 255, 255)
VeilDraw.Highlight.FillTransparency    = 0.5
VeilDraw.Highlight.OutlineTransparency = 0

VeilDraw.Tracer.Thickness = 2
VeilDraw.Tracer.Radius    = 5
VeilDraw.Tracer.Color     = Color3.fromRGB(255, 0, 255)
VeilDraw.Tracer.Filled    = true
VeilDraw.Tracer.Visible   = false

function Veil_GetRealVelocity(part, playerName)
    if not part then return Vector3.zero end
    local currentPos = part.Position
    local currentTime = tick()
    if not VeilVelocityCache[playerName] then
        VeilVelocityCache[playerName] = {lastPos = currentPos, lastTime = currentTime, velocity = Vector3.zero}
        return Vector3.zero
    end
    local cache = VeilVelocityCache[playerName]
    local dt = currentTime - cache.lastTime
    if dt > 0.01 then
        local rawVelocity = (currentPos - cache.lastPos) / dt
        if rawVelocity.Magnitude < 100 then
            cache.velocity = cache.velocity:Lerp(rawVelocity, 0.4)
        end
    end
    cache.lastPos = currentPos
    cache.lastTime = currentTime
    return cache.velocity
end

function veil_getTargetPart(char)
    if VeilConfig.TargetPart == "Head" then
        return char:FindFirstChild("Head")
    elseif VeilConfig.TargetPart == "Root" then
        return char:FindFirstChild("HumanoidRootPart")
    else
        return char:FindFirstChild("Torso")
            or char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("HumanoidRootPart")
    end
end

function veil_getClosestSurvivor()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local cam      = workspace.CurrentCamera
    local center   = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local bestDist = VeilConfig.FOV
    local bestTarget = nil

    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= LocalPlayer and p.Team and p.Team.Name == "Survivors" and p.Character then
            local char = p.Character
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local part = veil_getTargetPart(char)
            if hum and hum.Health > 0 and part then
                local dist3D = (part.Position - myRoot.Position).Magnitude
                if dist3D <= VeilConfig.MaxDist then
                    local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist2D < bestDist then
                            bestDist   = dist2D
                            bestTarget = { Player = p, Part = part }
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

function veil_setupInterceptor()
    if VeilState.remoteHooked then return end
    task.spawn(function()
        pcall(function()
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                if not checkcaller() then
                    if string.lower(method) == "kick" then
                        return nil
                    end

                    if method == "GetAttribute" then
                        if args[1] == "LakeMist" and VD.KILLER_InfLakeMist then
                            local caller = getcallingscript()
                            if caller and caller.Name == "AwardLog" then return 0 end
                            return false
                        end
                        if args[1] == "Pursuit" and VD.KILLER_InfPursuit then
                            local caller = getcallingscript()
                            if caller and caller.Name == "AwardLog" then return 0 end
                            return false
                        end
                    end

                    if method == "GetAttributes" then
                        if VD.KILLER_InfLakeMist or VD.KILLER_InfPursuit then
                            local attrs = oldNamecall(self, ...)
                            if type(attrs) == "table" then
                                local caller = getcallingscript()
                                if caller and caller.Name == "AwardLog" then
                                    if VD.KILLER_InfLakeMist then attrs.LakeMist = 0 end
                                    if VD.KILLER_InfPursuit then attrs.Pursuit = 0 end
                                else
                                    if VD.KILLER_InfLakeMist then attrs.LakeMist = false end
                                    if VD.KILLER_InfPursuit then attrs.Pursuit = false end
                                end
                                return attrs
                            end
                        end
                    end

                    if method == "FireServer" then
                        if self.Name == "Spearthrow" and VeilConfig.Enabled then
                            return nil
                        end

                        if VD.KILLER_InfLakeMist and self.Name == "LakeMist" then
                            local a1 = args[1]
                            if a1 == false then
                                return nil
                            elseif a1 == true then
                                task.delay(0.2, function()
                                    pcall(function()
                                        local c = game:GetService("Players").LocalPlayer.Character
                                        if c and c:GetAttribute("action") == true then
                                            c:SetAttribute("action", false)
                                        end
                                    end)
                                end)
                            end
                        end

                        if VD.KILLER_InfPursuit and self.Name == "Pursuit" then
                            local a1 = args[1]
                            if a1 == false then
                                return nil
                            elseif a1 == true then
                                task.delay(0.2, function()
                                    pcall(function()
                                        local c = game:GetService("Players").LocalPlayer.Character
                                        if c and c:GetAttribute("action") == true then
                                            c:SetAttribute("action", false)
                                        end
                                    end)
                                end)
                            end
                        end
                    end
                end
                return oldNamecall(self, ...)
            end)
            VeilState.remoteHooked = true
        end)
    end)
end
veil_setupInterceptor()

function veil_fire()
    if VeilState.attackCooldown then return end
    VeilState.attackCooldown = true
    task.delay(2, function() VeilState.attackCooldown = false end)

    local myChar    = LocalPlayer.Character
    local startPart = myChar and (myChar:FindFirstChild("Head") or myChar:FindFirstChild("HumanoidRootPart"))
    if not startPart then return end

    local startPos   = startPart.Position
    local targetInfo = veil_getClosestSurvivor()
    local aimDir

    if targetInfo and targetInfo.Part then
        local targetPart = targetInfo.Part
        local targetPlayer = targetInfo.Player
        local targetPos = targetPart.Position

        local velocity = Veil_GetRealVelocity(targetPart, targetPlayer.Name)
        local horizontalVel = Vector3.new(velocity.X, 0, velocity.Z)
        local speed = horizontalVel.Magnitude

        local distance = (targetPos - startPos).Magnitude
        local timeToHit = distance / VeilConfig.SpearSpeed

        local horizontalPrediction = Vector3.zero
        if speed > 4 and VeilConfig.AutoPredict then
            local factor = VeilConfig.HorizontalPredictFactor
            horizontalPrediction = horizontalVel * timeToHit * factor
        end
        local predictedPos = targetPos + horizontalPrediction

        local autoGravity = math.max(0, distance - 8)
        local gravity = VeilConfig.AutoPredict and autoGravity or VeilConfig.Gravity
        local drop = 0.5 * gravity * (timeToHit ^ 2)
        local finalPos = predictedPos + Vector3.new(0, drop, 0)

        aimDir = (finalPos - startPos).Unit
        VeilState.lastPredictedPos = finalPos
    else
        aimDir = workspace.CurrentCamera.CFrame.LookVector
        VeilState.lastPredictedPos = nil
    end

    pcall(function()
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if remotes then
            local killers = remotes:FindFirstChild("Killers")
            if killers then
                local veil = killers:FindFirstChild("Veil")
                if veil and veil:FindFirstChild("Spearthrow") then
                    veil.Spearthrow:FireServer(aimDir, VeilConfig.SpearSpeed, startPos)
                end
            end
        end
    end)

    VeilDraw.FOVCircle.Color = Color3.fromRGB(255, 0, 255)
    if not VeilState.passiveCooldown then
        VeilState.passiveCooldown = true
        task.delay(30, function()
            VeilDraw.FOVCircle.Color = Color3.fromRGB(255, 0, 255)
            VeilState.passiveCooldown = false
        end)
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    if gp and not isTouch then return end
    local char = LocalPlayer.Character
    local isSpearMode = char and char:GetAttribute("spearmode") == true
    if not VeilConfig.Enabled then return end
    if not isSpearMode then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        VeilState.chargingSpear = true
    elseif isTouch then
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            local slasher = pGui:FindFirstChild("Slasher-mob")
            if slasher then
                local ctrl = slasher:FindFirstChild("Controls")
                if ctrl then
                    local attackBtn = ctrl:FindFirstChild("attack")
                    if attackBtn and attackBtn.Visible then
                        local pos     = input.Position
                        local absPos  = attackBtn.AbsolutePosition
                        local absSize = attackBtn.AbsoluteSize
                        if pos.X >= absPos.X and pos.X <= absPos.X + absSize.X
                        and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y then
                            VeilState.chargingSpear = true
                            VeilState.touchInput    = input
                        end
                    end
                end
            end
        end
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, gp)
    if VeilState.chargingSpear
    and (input == VeilState.touchInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
        VeilState.chargingSpear = false
        if VeilState.touchInput == input then VeilState.touchInput = nil end
        veil_fire()
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    local cam         = workspace.CurrentCamera
    local myChar      = LocalPlayer.Character
    local isSpearMode = myChar and myChar:GetAttribute("spearmode") == true

    if VeilConfig.Enabled and VeilConfig.ShowFOV and isSpearMode then
        VeilDraw.FOVCircle.Visible  = true
        VeilDraw.FOVCircle.Radius   = VeilConfig.FOV
        VeilDraw.FOVCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    else
        VeilDraw.FOVCircle.Visible = false
    end

    if VeilState.chargingSpear and VeilConfig.Enabled and isSpearMode then
        local target = veil_getClosestSurvivor()
        if target and target.Part and target.Part.Parent then
            VeilDraw.Highlight.Parent = target.Part.Parent
            
            if VeilConfig.ShowTargetLaser then
                if not getgenv().KYS_SpearLaserPart then
                    local laser = Instance.new("Part")
                    laser.Name = "SpearSilentAimLaser"
                    laser.Anchored = true
                    laser.CanCollide = false
                    laser.CanTouch = false
                    laser.CastShadow = false
                    laser.Material = Enum.Material.Neon
                    laser.Color = Color3.fromRGB(255, 50, 50)
                    laser.Transparency = 0
                    laser.Parent = workspace
                    getgenv().KYS_SpearLaserPart = laser
                end
                
                local originPart = myChar and (myChar:FindFirstChild("Head") or myChar:FindFirstChild("HumanoidRootPart"))
                if originPart then
                    local originPos = originPart.Position
                    local targetPos = target.Part.Position
                    local dist = (targetPos - originPos).Magnitude
                    if dist > 0.1 then
                        local laser = getgenv().KYS_SpearLaserPart
                        laser.Size = Vector3.new(0.16, 0.16, dist)
                        laser.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
                        laser.Transparency = 0.5
                    end
                end
            else
                if getgenv().KYS_SpearLaserPart then getgenv().KYS_SpearLaserPart.Transparency = 1 end
            end
        else
            VeilDraw.Highlight.Parent = nil
            if getgenv().KYS_SpearLaserPart then getgenv().KYS_SpearLaserPart.Transparency = 1 end
        end
    else
        VeilDraw.Highlight.Parent = nil
        if getgenv().KYS_SpearLaserPart then getgenv().KYS_SpearLaserPart.Transparency = 1 end
    end

    if VeilConfig.Enabled and isSpearMode and VeilState.lastPredictedPos then
        local screenPos, onScreen = cam:WorldToViewportPoint(VeilState.lastPredictedPos)
        local viewport = cam.ViewportSize
        local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

        if onScreen then
            VeilDraw.Tracer.Position = Vector2.new(screenPos.X, screenPos.Y)
        else
            local dx = screenPos.X - center.X
            local dy = screenPos.Y - center.Y
            if math.abs(dx) < 1 and math.abs(dy) < 1 then
                VeilDraw.Tracer.Position = center
            else
                local angle = math.atan2(dy, dx)
                local maxX = viewport.X / 2 - 10
                local maxY = viewport.Y / 2 - 10
                local scaleX = maxX / math.abs(dx)
                local scaleY = maxY / math.abs(dy)
                local scale = math.min(scaleX, scaleY)
                local borderPos = Vector2.new(
                    center.X + dx * scale,
                    center.Y + dy * scale
                )
                VeilDraw.Tracer.Position = borderPos
            end
        end
        VeilDraw.Tracer.Visible = true
    else
        VeilDraw.Tracer.Visible = false
    end
end)

-- =====================================================
-- UI TABS
-- =====================================================
local Main, ESPTab, MapTab, FOVTab
local SurvivorTab, KillerTab, GeneratorTab, FlingTab, SettingsTab, ResetTab
local VisualTab, MainTab, AimTab, MappingTab, PlayerTab
local VisualFeatureTabs, MainFeatureTabs, MainKillerFeatureTabs, AimFeatureTabs, MappingFeatureTabs, PlayerFeatureTabs, PlayerMiscFeatureTabs
local KYS_MainInfoPanel = {
    Widgets = {},
    Texts = {},
}

function KYS_InfoPlainText(text)
    text = tostring(text or "")
    text = text:gsub("<br%s*/?>", "\n")
    text = text:gsub("<[^>]->", "")
    text = text:gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&amp;", "&")
    return text
end

function KYS_UpdateInfoWidget(widget, text)
    if not widget then return end
    local title, content = tostring(text or ""):match("^(.-)\n(.*)$")
    title = title or tostring(text or "")
    content = content or ""
    pcall(function()
        if type(widget.Set) == "function" then
            pcall(function() widget:Set({ Name = title, Title = title, Content = content, Description = content, Text = content }) end)
            widget:Set(text)
        elseif type(widget.SetText) == "function" then
            widget:SetText(text)
        elseif type(widget.SetContent) == "function" then
            widget:SetContent(content)
        elseif type(widget.SetDescription) == "function" then
            widget:SetDescription(content)
        elseif type(widget.Update) == "function" then
            pcall(function() widget:Update({ Name = title, Title = title, Content = content, Description = content, Text = content }) end)
            widget:Update(text)
        elseif type(widget.SetValue) == "function" then
            widget:SetValue(text)
        end
    end)
    pcall(function()
        if widget.Text ~= nil then widget.Text = text end
        if widget.Name ~= nil and type(widget.Name) == "string" then widget.Name = title end
        if widget.TextLabel then widget.TextLabel.Text = content ~= "" and content or text end
        if widget.Label then widget.Label.Text = text end
        if widget.Title then widget.Title.Text = title end
        if widget.Content then widget.Content.Text = content ~= "" and content or text end
        if widget.Description then widget.Description.Text = content end
    end)
end

function KYS_SetMainInfoPanelText(key, title, text)
    local value = tostring(title or key) .. "\n" .. KYS_InfoPlainText(text)
    KYS_MainInfoPanel.Texts[key] = value
    KYS_UpdateInfoWidget(KYS_MainInfoPanel.Widgets[key], value)
end

function KYS_RegisterMainInfoWidget(key, widget)
    KYS_MainInfoPanel.Widgets[key] = widget
    if KYS_MainInfoPanel.Texts[key] then
        KYS_UpdateInfoWidget(widget, KYS_MainInfoPanel.Texts[key])
    end
end

function KYS_AddMainInfoLine(section, key, title, defaultText)
    local defaultValue = tostring(title) .. "\n" .. tostring(defaultText or "Off")
    KYS_MainInfoPanel.Texts[key] = KYS_MainInfoPanel.Texts[key] or defaultValue

    local ok, widget = pcall(function()
        if section.AddParagraph then
            return section:AddParagraph({
                Name = title,
                Title = title,
                Content = tostring(defaultText or "Off"),
                Description = tostring(defaultText or "Off"),
                Text = tostring(defaultText or "Off"),
            })
        end
    end)
    if ok and widget then return KYS_RegisterMainInfoWidget(key, widget) end

    ok, widget = pcall(function()
        if section.AddLabel then
            return section:AddLabel({
                Name = defaultValue,
                Text = defaultValue,
            })
        end
    end)
    if ok and widget then return KYS_RegisterMainInfoWidget(key, widget) end

    ok, widget = pcall(function()
        if section.AddButton then
            return section:AddButton({
                Name = defaultValue,
                Callback = function() end,
            })
        end
    end)
    if ok and widget then return KYS_RegisterMainInfoWidget(key, widget) end
end

if Window then

    local function makeModernAdapter(section)
        local adapter = {}
        setmetatable(adapter, {
            __index = function(t, k)
                if k == "AddSection" then
                    return function(self, cfg)
                        if cfg and cfg.Name then
                            pcall(function() section:AddDivider({ Text = cfg.Name }) end)
                        end
                        return adapter
                    end
                end
                if k == "AddSlider" then
                    return function(self, cfg)
                        if cfg and cfg.Name then
                            local modernCfg = {
                                Name = cfg.Name,
                                Flag = cfg.Flag or cfg.Name,
                                Min = cfg.Min or 0,
                                Max = cfg.Max or 100,
                                Default = cfg.Default or cfg.Min or 0,
                                Value = cfg.Default or cfg.Min or 0,
                                Increment = cfg.Increment or 1,
                            }
                            local isFloat = false
                            if modernCfg.Increment < 1 or (math.floor(modernCfg.Min) ~= modernCfg.Min) or (math.floor(modernCfg.Max) ~= modernCfg.Max) then
                                isFloat = true
                            end
                            if isFloat then
                                modernCfg.Rounding = 1
                                if modernCfg.Increment <= 0.01 then
                                    modernCfg.Rounding = 2
                                end
                            else
                                modernCfg.Rounding = 0
                            end
                            modernCfg.Callback = function(Value)
                                if cfg.Callback then
                                    pcall(function() cfg.Callback(Value) end)
                                end
                            end
                            pcall(function() section:AddSlider(modernCfg) end)
                        end
                        return adapter
                    end
                end

                if type(section[k]) == "function" then
                    return function(self, ...)
                        return section[k](section, ...)
                    end
                end
                return section[k]
            end
        })
        return adapter
    end

    local Tabs = {
        Visual = Window:AddTab({ Name = "Visual", Icon = "lucide:eye", Type = "Single" }),
        Main = Window:AddTab({ Name = "Main", Icon = "lucide:cpu", Type = "Single" }),
        Aim = Window:AddTab({ Name = "Aim", Icon = "lucide:crosshair", Type = "Single" }),
        Mapping = Window:AddTab({ Name = "Mapping", Icon = "lucide:map", Type = "Single" }),
        Player = Window:AddTab({ Name = "Player", Icon = "lucide:user", Type = "Single" }),
    }

    local function adaptTab(tab)
        local adapter = {}
        setmetatable(adapter, {
            __index = function(t, k)
                if k == "AddSection" then
                    return function(self, cfg)
                        if cfg and cfg.Name then
                            pcall(function() tab:AddDivider({ Text = cfg.Name }) end)
                        end
                        return makeModernAdapter(tab)
                    end
                end
                return tab[k]
            end
        })
        return adapter
    end

    local function addCenterFeatureTabbox(tab, name, entries)
        local tabbox = tab:AddCenterTabbox(name)
        local created = {}

        for _, entry in ipairs(entries) do
            created[entry.Key] = makeModernAdapter(tabbox:AddTab({
                Name = entry.Name,
                Icon = entry.Icon,
            }))
        end

        return created
    end

    VisualFeatureTabs = addCenterFeatureTabbox(Tabs.Visual, "Visual Features", {
        { Key = "ESP", Name = "ESP", Icon = "lucide:eye" },
        { Key = "Camera", Name = "Camera", Icon = "solar:camera-bold" },
        { Key = "Lighting", Name = "Lighting", Icon = "solar:sun-bold" },
    })

    MainFeatureTabs = addCenterFeatureTabbox(Tabs.Main, "Main Features", {
        { Key = "Survivor", Name = "Survivor", Icon = "solar:shield-bold" },
        { Key = "Escape", Name = "Escape", Icon = "solar:exit-bold" },
        { Key = "Automation", Name = "Automation", Icon = "solar:bolt-bold" },
    })

    MainKillerFeatureTabs = addCenterFeatureTabbox(Tabs.Main, "Killer & Utilities", {
        { Key = "Killer", Name = "Killer", Icon = "solar:danger-bold" },
        { Key = "Ability", Name = "Killer Ability", Icon = "solar:bolt-bold" },
        { Key = "Utilities", Name = "Utilities", Icon = "solar:settings-bold" },
    })

    AimFeatureTabs = addCenterFeatureTabbox(Tabs.Aim, "Aim Features", {
        { Key = "Aimbot", Name = "Aimbot", Icon = "solar:target-bold" },
        { Key = "Spear", Name = "Killer Aim", Icon = "lucide:sword" },
        { Key = "AutoAim", Name = "Survivor Aim", Icon = "solar:magic-stick-3-bold" },
    })

    MappingFeatureTabs = addCenterFeatureTabbox(Tabs.Mapping, "Mapping Features", {
        { Key = "Teleport", Name = "Teleport", Icon = "solar:map-point-bold" },
        { Key = "Radar", Name = "Radar", Icon = "solar:radar-bold" },
    })

    PlayerFeatureTabs = addCenterFeatureTabbox(Tabs.Player, "Player Features", {
        { Key = "Movement", Name = "Movement", Icon = "solar:running-round-bold" },
        { Key = "Fling", Name = "Fling", Icon = "solar:wind-bold" },
        { Key = "Emote", Name = "Emote [BETA]", Icon = "solar:music-note-bold" },
    })

    PlayerMiscFeatureTabs = addCenterFeatureTabbox(Tabs.Player, "Player Misc", {
        { Key = "Fun", Name = "Fun", Icon = "solar:gamepad-bold" },
        { Key = "Streamer", Name = "Streamer Mode", Icon = "solar:settings-bold" },
        { Key = "Avatar", Name = "Avatar Tools", Icon = "solar:users-group-rounded-bold" },
    })

    VisualTab = VisualFeatureTabs.ESP
    MainTab = adaptTab(Tabs.Main)
    AimTab = adaptTab(Tabs.Aim)
    MappingTab = MappingFeatureTabs.Teleport
    PlayerTab = adaptTab(Tabs.Player)

end

if Window then

do -- Player Tab
    local movSection = PlayerFeatureTabs.Movement:AddSection({
        Position = "Center",
        Name = "Movement",
        Icon      = "solar:running-round-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    movSection:AddToggle({
        Default = false,
        Name = "Auto Crouch BETA",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "Auto Crouch BETA",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur Auto Crouch BETA hanya untuk pengguna Key Premium!", 5)
                return
            end
            setAutoCrouch(v)
        end
    })

    movSection:AddToggle({
        Default = false,
        Name = "Speed Hack", Flag = "Speed Hack",
        Callback = function(v)
            VD.Speed = v
            if not v then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.WalkSpeed = 16 end) end
            end
        end
    })
    movSection:AddSlider({
        Name = "Speed Value", Flag = "Speed Value",
        Min = 16, Max = 200, Default = 16,
        Callback = function(v)
            VD.SpeedValue =
                v
        end
    })
    movSection:AddToggle({
        Default = false,
        Name = "Jump Hack", Flag = "Jump Hack",
        Callback = function(v)
            VD.Jump = v
            if not v then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.JumpPower = 0 end) end
            end
        end
    })
    movSection:AddSlider({
        Name = "Jump Power", Flag = "Jump Power",
        Min = 50, Max = 300, Default = 50,
        Callback = function(v)
            VD.JumpValue =
                v
        end
    })
    movSection:AddToggle({ Default = false, Name = "Infinite Jump", Flag = "Infinite Jump", Callback = function(v) VD.InfiniteJump = v end })
    movSection:AddToggle({ Default = false, Name = "Anti Fall Damage", Flag = "Anti Fall Damage", Callback = function(v) VD.AntiFallDamage = v end })
    movSection:AddToggle({ Default = false, Name = "Noclip", Flag = "Noclip", Callback = function(v) 
        VD.Noclip = v 
        if not v and getgenv().VD_DisableNoclip then pcall(getgenv().VD_DisableNoclip) end
    end })
    movSection:AddToggle({ Default = false, Name = "Moonwalk", Flag = "Moonwalk", Callback = function(v)
        if getgenv().VD_SetMoonwalkButtonVisible then
            getgenv().VD_SetMoonwalkButtonVisible(v)
        else
            VD.MoonwalkButton = v
        end
    end })
    movSection:AddToggle({ Default = false, Name = "Lock Moonwalk Button", Flag = "Lock Moonwalk Button", Callback = function(v)
        VD.MoonwalkButtonLocked = v and true or false
    end })
    movSection:AddSlider({
        Name = "Moonwalk Zigzag Speed", Flag = "Moonwalk Zigzag Speed",
        Min = 1, Max = 30, Default = 11,
        Callback = function(v)
            VD.MoonwalkZigzagSpeed = v
        end
    })
    movSection:AddSlider({
        Name = "Moonwalk Boost Power", Flag = "Moonwalk Boost Power",
        Min = 1, Max = 2, Default = 1.08, Increment = 0.01,
        Callback = function(v)
            VD.MoonwalkBoostPower = v
        end
    })
    movSection:AddToggle({ Default = false, Name = "Invisible Not Visual", Locked = false, TextLocked = "Premium Required", Flag = "Invisible Not Visual", Callback = function(v) 
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Invisible Not Visual hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.InvisibleNotVisual = v; if not v and VD_InvisibleNV.Active then pcall(VD_SetInvisibleNotVisual, false) end 
    end })
    movSection:AddSlider({
        Name = "Invisible Speed", Flag = "Invisible Speed",
        Min = 1, Max = 999, Default = 5,
        Callback = function(v)
            VD.InvisibleSpeed = v
        end
    })
    movSection:AddToggle({ Default = false, Name = "Anti AFK", Flag = "Anti AFK", Callback = function(v) VD.AntiAFK = v end })

    -- removed PlayerTab AddDivider
end

do -- ESP Tab
    -- Visual Highlight ESP baru masuk di sini.
    -- Drawing ESP PC lama tetap dipertahankan.
    pcall(function()
        if getgenv().KYS_AddVisualESPControls then
            getgenv().KYS_AddVisualESPControls(VisualTab)
        end
    end)

end

do -- Aim Tab
    local aimbotSection = AimFeatureTabs.Aimbot:AddSection({
        Position = "Center",
        Name = "Aimbot",
        Icon      = "solar:target-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    aimbotSection:AddToggle({ Default = false, Name = "Enable Aimbot", Flag = "Enable Aimbot", Callback = function(v) VD.AIM_Enabled = v end })

    aimbotSection:AddToggle({ Default = false, Name = "Use RMB to aim", Flag = "Use RMB to aim", Callback = function(v) VD.AIM_UseRMB = v end })
    aimbotSection:AddToggle({ Default = false, Name = "Show FOV Circle", Flag = "Show FOV Circle", Callback = function(v) VD.AIM_ShowFOV = v end })
    aimbotSection:AddSlider({
        Name = "FOV Size (aim radius on screen)", Flag = "FOV Size (aim radius on screen)",
        Min = 20, Max = 400, Default = 120,
        Callback = function(
            v)
            VD.AIM_FOV = v
        end
    })
    aimbotSection:AddSlider({
        Name = "Smoothness (Speed Aim)", Flag = "Smoothness",
        Min = 0.1, Max = 10, Default = 0.3, Increment = 0.05,
        Callback = function(v)
            VD.AIM_Smooth = v
        end
    })

    aimbotSection:AddToggle({ Default = false, Name = "Visibility Check", Flag = "Visibility Check", Callback = function(v) VD.AIM_VisCheck = v end })
    aimbotSection:AddToggle({ Default = false, Name = "Prediction", Flag = "Prediction", Callback = function(v) VD.AIM_Predict = v end })

    local crosshairSection = AimFeatureTabs.Aimbot:AddSection({
        Position = "Center",
        Name = "Advanced Crosshair",
        Icon      = "solar:target-broken",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    crosshairSection:AddToggle({ Default = false, Name = "Enable Crosshair", Flag = "CROSS_Enabled", Callback = function(v) VD.CROSS_Enabled = v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddColorPicker({ Name = "Crosshair Color", Flag = "CROSS_Color", Default = VD.CROSS_Color or Color3.fromRGB(255, 255, 255), Callback = function(v) VD.CROSS_Color = v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddDropdown({ Name = "Crosshair Style", Flag = "CROSS_Style", Default = "Dot", Values = { "Dot", "Plus", "X", "Box" }, Multi = false, Callback = function(v) VD.CROSS_Style = type(v) == "table" and v[1] or v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddSlider({ Name = "Crosshair Size", Flag = "CROSS_Size", Min = 1, Max = 100, Default = 3, Increment = 1, Callback = function(v) VD.CROSS_Size = v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddSlider({ Name = "Crosshair Thickness", Flag = "CROSS_Thickness", Min = 1, Max = 20, Default = 4, Increment = 1, Callback = function(v) VD.CROSS_Thickness = v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddSlider({ Name = "Crosshair Gap", Flag = "CROSS_Gap", Min = 0, Max = 50, Default = 6, Increment = 1, Callback = function(v) VD.CROSS_Gap = v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddSlider({ Name = "Position X Offset", Flag = "CROSS_PosX", Min = -500, Max = 500, Default = 0, Increment = 1, Callback = function(v) VD.CROSS_PosX = v pcall(VD_UpdateCrosshair) end })
    crosshairSection:AddSlider({ Name = "Position Y Offset", Flag = "CROSS_PosY", Min = -500, Max = 500, Default = 0, Increment = 1, Callback = function(v) VD.CROSS_PosY = v pcall(VD_UpdateCrosshair) end })

    local spearSection = AimFeatureTabs.Spear:AddSection({
        Position = "Center",
        Name = "Aimbot Spear (Veil)",
        Icon      = "lucide:sword",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    spearSection:AddToggle({ Default = false, Name = "Spear Aimbot", Flag = "Spear Aimbot", Callback = function(v) VD.SPEAR_Aimbot = v end })

    spearSection:AddSlider({
        Name = "Spear Gravity", Flag = "Spear Gravity",
        Min = 10, Max = 200, Default = 50,
        Callback = function(v)
            VD.SPEAR_Gravity =
                v
        end
    })
    spearSection:AddSlider({
        Name = "Spear Speed", Flag = "Spear Speed",
        Min = 50, Max = 300, Default = 100,
        Callback = function(v)
            VD.SPEAR_Speed =
                v
        end
    })
    spearSection:AddKeybind({
        Name = "Toggle Keybind (PC)", Flag = "Spear Keybind", Default = "None",
        Callback = function()
            if not VD.SPEAR_Aimbot or GetRole() ~= "Killer" then return end
            SpearBtnData.Active = not SpearBtnData.Active
            if SpearBtnData.Active then
                pcall(VD_Notify, "Spear Aimbot", "Spear Aimbot AKTIF!", 3)
            else
                pcall(VD_Notify, "Spear Aimbot", "Spear Aimbot NONAKTIF", 3)
            end
        end
    })

    spearSection:AddDivider({ Text = "Silent Aim (Veil)" })

    spearSection:AddToggle({ Default = false, Name = "Silent Aim Spear (Veil)", Locked = false, TextLocked = "Premium Required", Flag = "Silent Aim Spear (Veil)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Silent Aim Spear hanya untuk pengguna Key Premium!", 5)
            return
        end
        VeilConfig.Enabled = v
    end })
    spearSection:AddToggle({ Default = true, Name = "Show FOV Circle", Flag = "Show FOV Circle", Callback = function(v) VeilConfig.ShowFOV = v end })
    spearSection:AddToggle({ Default = true, Name = "Show Target Laser", Flag = "Show Target Laser", Callback = function(v) VeilConfig.ShowTargetLaser = v end })
    spearSection:AddSlider({ Name = "FOV Radius", Flag = "FOV Radius", Min = 50, Max = 500, Default = 150, Callback = function(v) VeilConfig.FOV = v end })
    spearSection:AddToggle({ Default = false, Name = "Auto Predict", Flag = "Auto Predict", Callback = function(v) VeilConfig.AutoPredict = v end })
    spearSection:AddSlider({ Name = "Spear Speed", Flag = "Spear Speed", Min = 50, Max = 300, Default = 165, Callback = function(v) VeilConfig.SpearSpeed = v end })
    spearSection:AddSlider({ Name = "Gravity", Flag = "Gravity", Min = 0, Max = 300, Default = math.floor(workspace.Gravity * 0.5), Callback = function(v) VeilConfig.Gravity = v end })
    spearSection:AddSlider({ Name = "Horizontal Vector", Flag = "Horizontal Vector", Min = 0, Max = 5, Default = 1.0, Decimals = 2, Callback = function(v) VeilConfig.HorizontalPredictFactor = v end })
    spearSection:AddDropdown({ Name = "Target Part", Flag = "Target Part", Values = {"Torso", "Head", "Root"}, Default = "Torso", Multi = false, Callback = function(v)
        if type(v) == "table" then v = v[1] end
        VeilConfig.TargetPart = v
    end })

    local flaskSection = AimFeatureTabs.Spear:AddSection({
        Position = "Center",
        Name = "Silent Aim Flask (Cure)",
        Icon      = "lucide:flask-conical",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    flaskSection:AddToggle({ Default = false, Name = "Silent Aim Flask (Cure)", Locked = false, TextLocked = "Premium Required", Flag = "Silent Aim Flask (Cure)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Silent Aim Flask (Cure) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_SilentAimFlask = v
    end })
    flaskSection:AddToggle({ Default = false, Name = "Flask Laser (Cure)", Locked = false, TextLocked = "Premium Required", Flag = "Flask Laser (Cure)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Flask Laser (Cure) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_FlaskLaser = v
        if v then
            pcall(KYS_StartCureFlaskLaser)
        else
            if getgenv().KYS_CureFlaskLaserThread then
                getgenv().KYS_CureFlaskLaserThread:Disconnect()
                getgenv().KYS_CureFlaskLaserThread = nil
            end
            if getgenv().KYS_CureFlaskLaserPart then
                pcall(function() getgenv().KYS_CureFlaskLaserPart:Destroy() end)
                getgenv().KYS_CureFlaskLaserPart = nil
            end
        end
    end })

    local tofSection = AimFeatureTabs.AutoAim:AddSection({
        Position = "Center",
        Name = "Silent Aim Twist Of Fate",
        Icon      = "solar:magic-stick-3-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    tofSection:AddToggle({
        Default = false,
        Name = "Silent Aim Twist Of Fate",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "Silent Aim Twist Of Fate",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur Silent Aim Twist Of Fate hanya untuk pengguna Key Premium!", 5)
                return
            end
            if getgenv().KYS_SetToFSilentAim then
                getgenv().KYS_SetToFSilentAim(v)
            end
        end
    })
    tofSection:AddToggle({
        Default = true,
        Name = "ToF Laser",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "ToF Laser",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur ToF Laser hanya untuk pengguna Key Premium!", 5)
                return
            end
            VD.TOF_Laser = v
            if not v and getgenv().KYS_ToFClearLaser then
                getgenv().KYS_ToFClearLaser()
            end
        end
    })
    tofSection:AddToggle({
        Default = false,
        Name = "ToF Wall Check",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "ToF Wall Check",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur ToF Wall Check hanya untuk pengguna Key Premium!", 5)
                return
            end
            VD.TOF_WallCheck = v
        end
    })
    tofSection:AddToggle({
        Default = true,
        Name = "ToF Block When Knocked",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "ToF Block When Knocked",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur ToF Block When Knocked hanya untuk pengguna Key Premium!", 5)
                return
            end
            VD.TOF_BlockKnocked = v
        end
    })
    tofSection:AddDropdown({
        Name = "ToF Target Mode",
        Flag = "ToF Target Mode",
        Values = { "Killer", "Survivors", "Zombie" },
        Default = VD.TOF_TargetMode or "Killer",
        Multi = false,
        Callback = function(v)
            if type(v) == "table" then v = v[1] end
            if getgenv().KYS_ToFSetTargetMode then
                getgenv().KYS_ToFSetTargetMode(v or "Killer", false)
            else
                VD.TOF_TargetMode = v or "Killer"
            end
        end
    })
    tofSection:AddDropdown({
        Name = "Silent Aim Key",
        Flag = "Silent Aim Key",
        Values = { "None", "Q", "E", "R", "T", "F", "G", "H", "J", "K", "L", "X", "Z" },
        Default = VD.TOF_Key or "None",
        Multi = false,
        Callback = function(v)
            if type(v) == "table" then v = v[1] end
            VD.TOF_Key = v or "None"
        end
    })

    local flashlightSection = AimFeatureTabs.AutoAim:AddSection({
        Position = "Center",
        Name = "Silent Aim Flashlight",
        Icon      = "lucide:flashlight",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    flashlightSection:AddToggle({
        Default = false,
        Name = "Silent Aim Flashlight",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "Silent Aim Flashlight",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur Silent Aim Flashlight hanya untuk pengguna Key Premium!", 5)
                return
            end
            if getgenv().KYS_SetFlashlightSilentAim then
                getgenv().KYS_SetFlashlightSilentAim(v)
            else
                VD.FLASH_SilentAim = v
            end
        end
    })
    flashlightSection:AddToggle({
        Default = true,
        Name = "Flashlight Laser",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "Flashlight Laser",
        Callback = function(v)
            if v and false then
                pcall(VD_Notify, "Premium Required ✨", "Fitur Flashlight Laser hanya untuk pengguna Key Premium!", 5)
                return
            end
            VD.FLASH_Laser = v
            if not v and getgenv().KYS_ClearFlashlightLaser then
                getgenv().KYS_ClearFlashlightLaser()
            end
        end
    })
    flashlightSection:AddDropdown({
        Name = "Flashlight Target Part",
        Flag = "Flashlight Target Part",
        Values = { "Head", "HumanoidRootPart", "UpperTorso", "Torso" },
        Default = VD.FLASH_TargetPart or "Head",
        Multi = false,
        Callback = function(v)
            if type(v) == "table" then v = v[1] end
            VD.FLASH_TargetPart = v or "Head"
        end
    })
    flashlightSection:AddSlider({
        Name = "Flashlight Range",
        Flag = "Flashlight Range",
        Min = 20,
        Max = 250,
        Default = tonumber(VD.FLASH_Range) or 120,
        Callback = function(v)
            VD.FLASH_Range = tonumber(v) or 120
        end
    })
    flashlightSection:AddSlider({
        Name = "Flashlight Smoothness",
        Flag = "Flashlight Smoothness",
        Min = 0.05,
        Max = 1,
        Default = tonumber(VD.FLASH_Smooth) or 0.35,
        Decimals = 2,
        Callback = function(v)
            VD.FLASH_Smooth = tonumber(v) or 0.35
        end
    })

end

do -- FOV Tab
    local camSection = VisualFeatureTabs.Camera:AddSection({
        Position = "Center",
        Name = "Camera",
        Icon      = "solar:camera-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    camSection:AddToggle({ Default = false, Name = "Enable Camera FOV override", Flag = "Enable Camera FOV override", Callback = function(v) VD.CAM_FOVEnabled = v end })
    camSection:AddSlider({
        Name = "Camera FOV", Flag = "Camera FOV",
        Min = 30, Max = 140, Default = 90,
        Callback = function(v)
            VD.CAM_FOV =
                v
        end
    })
    camSection:AddToggle({ Default = false, Name = "Third Person (Killer only)", Flag = "Third Person (Killer only)", Callback = function(v) VD.CAM_ThirdPerson = v end })
    camSection:AddToggle({ Default = false, Name = "Shift Lock (auto face camera)", Flag = "Shift Lock (auto face camera)", Callback = function(v) VD.CAM_ShiftLock = v end })
    camSection:AddToggle({ Default = false, Name = "Infinity Zoom Out", Flag = "Infinity Zoom Out", Callback = function(v) 
        VD.CAM_InfinityZoom = v 
        LocalPlayer.CameraMaxZoomDistance = v and math.huge or 128 
        LocalPlayer.CameraMinZoomDistance = v and 0 or 0.5 
    end })
    camSection:AddToggle({ Default = false, Name = "No Cutscene", Flag = "No Cutscene", Callback = function(v) VD.NoCutscene = v end })

    -- removed FOVTab AddDivider

    local visualSection = VisualFeatureTabs.Lighting:AddSection({
        Position = "Center",
        Name = "Visual",
        Icon      = "solar:sun-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    visualSection:AddToggle({ Default = false, Name = "No Fog (remove fog/post effects)", Flag = "No Fog (remove fog/post effects)", Callback = function(v) VD.NO_Fog = v end })
    visualSection:AddToggle({ Default = false, Name = "Fullbright (lighting preset)", Flag = "Fullbright (lighting preset)", Callback = function(v)
        VD.Fullbright = v
        if VD.VIS_WeatherTheme and VD.VIS_WeatherTheme ~= "Default" then
            pcall(VD_ApplyWeather, VD.VIS_WeatherTheme)
        end
    end })
    visualSection:AddDropdown({
        Name = "Weather & Sky Theme",
        Default = "Default",
        Values = {"Default", "Christmas (Snow)", "Heavy Rain (Storm)", "Autumn (Musim Gugur)", "Cherry Blossom (Sakura)", "Sunset (Golden Hour)", "Blood Moon (Spooky)", "Toxic Wasteland", "Vaporwave (Synthwave)", "Midnight (Pitch Black)"},
        Flag = "Weather & Sky Theme",
        Callback = function(v)
            VD.VIS_WeatherTheme = v
            pcall(VD_ApplyWeather, v)
        end
    })

    local infoPanelSection = VisualFeatureTabs.Lighting:AddSection({
        Position = "Center",
        Name = "Game Info Panel",
        Icon      = "lucide:panel-top",
        Box       = true,
        BoxBorder = true,
        Opened    = true,
    })

    KYS_AddMainInfoLine(infoPanelSection, "KystKiller", "Kyst Killer Display", "Off")
    KYS_AddMainInfoLine(infoPanelSection, "KillerPerks", "Spectate Killer Perks", "Off")
    KYS_AddMainInfoLine(infoPanelSection, "PredictMap", "Predict Map", "Off")

    visualSection:AddToggle({ Default = false, Name = "Kyst Killer Display", Flag = "Kyst Killer Display", Callback = function(v) 
        VD.VIS_KystKiller = v 
        if v then
            StartKystKiller()
        else
            StopKystKiller()
        end
    end })
    visualSection:AddToggle({ Default = false, Name = "Enable Spectator Counter", Flag = "Enable Spectator Counter", Callback = function(v)
        VD.VIS_SpectatorCounter = v
        if v then
            StartSpectatorCounter()
        else
            StopSpectatorCounter()
        end
    end })
    visualSection:AddToggle({ Default = false, Name = "Killer Perks Display", Flag = "Killer Perks Display", Callback = function(v)
        VD.VIS_KillerPerks = v
        if v then
            StartKillerPerksDisplay()
        else
            StopKillerPerksDisplay()
        end
    end })
    visualSection:AddToggle({ Default = false, Name = "Predict Map", Flag = "Predict Map", Callback = function(v)
        VD.VIS_PredictMap = v
        if v then
            StartPredictMap()
        else
            StopPredictMap()
        end
    end })
    visualSection:AddToggle({ Default = false, Name = "Hide Survivor Icon", Flag = "Hide Survivor Icon", Callback = function(v)
        if getgenv().KYS_SetHideSurvivorIcon then
            getgenv().KYS_SetHideSurvivorIcon(v)
        else
            VD.VIS_HideSurvivorIcon = v
        end
    end })
    visualSection:AddToggle({ Default = false, Name = "Show Ping & FPS", Flag = "Show Ping & FPS", Callback = function(v)
        if getgenv().KYS_SetShowPingFPS then
            getgenv().KYS_SetShowPingFPS(v)
        else
            VD.VIS_ShowPingFPS = v
        end
    end })
    visualSection:AddToggle({ Default = false, Name = "Show Hook Counter", Flag = "Show Hook Counter", Callback = function(v)
        if getgenv().KYS_SetShowHookCounter then
            getgenv().KYS_SetShowHookCounter(v)
        else
            VD.VIS_ShowHookCounter = v
        end
    end })
end

do -- Survivor Tab
    local combatSurv = MainFeatureTabs.Survivor:AddSection({
        Position = "Center",
        Name = "Survivor",
        Icon      = "solar:shield-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    combatSurv:AddToggle({ Default = false, Name = "Swift Vault", Flag = "SwiftVault", Callback = function(v) VD.SURV_AutoVault = v end })
    combatSurv:AddToggle({ Default = false, Name = "Swift Vault V2", Locked = false, TextLocked = "Premium Required", Flag = "SURV_SwiftVaultV2", Callback = function(v) 
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Swift Vault V2 hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.SURV_FastVault = v 
        if not v then
            local char = LocalPlayer.Character
            if char then char:SetAttribute("vaultspeed", 1) end
        end
    end })
    combatSurv:AddSlider({
        Name = "Vault Speed", Flag = "SURV_SwiftVaultSpeed",
        Min = 10, Max = 20, Default = 13, Increment = 1,
        Callback = function(v) VD.SURV_VaultSpeed = v end
    })
    combatSurv:AddToggle({ Default = false, Name = "Pallet Reflex", Flag = "Pallet Reflex", Callback = function(v) VD.SURV_AutoPallet = v end })
    combatSurv:AddSlider({
        Name = "Pallet Trigger Range (studs)", Flag = "Pallet Trigger Range",
        Min = 5, Max = 50, Default = 20, Increment = 0.1,
        Callback = function(v) VD.SURV_AutoPalletDist = v end
    })
    combatSurv:AddToggle({ Default = false, Name = "Anti Knock", Locked = false, TextLocked = "Premium Required", Flag = "Anti Knock", Callback = function(v) 
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Anti Knock hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.SURV_AntiKnock = v 
    end })
    combatSurv:AddToggle({ Default = false, Name = "Aura Heal (Self)", Flag = "Instant Heal (Self)", Callback = function(v) setInstantHealSelf(v) end })
    combatSurv:AddToggle({ Default = false, Name = "Auto Dodge Spear (Veil)", Locked = false, TextLocked = "Premium Required", Flag = "Auto Dodge Spear", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Auto Dodge Spear hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.SURV_AutoDodgeSpear = v
    end })
    combatSurv:AddToggle({ Default = false, Name = "Aura Heal All", Locked = false, TextLocked = "Premium Required", Flag = "Auto Heal All", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Aura Heal All hanya untuk pengguna Key Premium!", 5)
            return
        end
        setAutoHealAll(v)
    end })

    combatSurv:AddToggle({
        Default = false, Name = "First Person Camera (Survivor)", Flag = "First Person Camera (Survivor)", Callback = function(v)
        VD.SURV_FirstPerson = v
        if not v then
            pcall(RestoreFirstPersonCamera)
        end
    end })
    combatSurv:AddToggle({ Default = false, Name = "Auto Parry", Locked = false, TextLocked = "Premium Required", Flag = "Auto Parry", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Auto Parry hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD_SetAutoParry(v)
    end })
    combatSurv:AddToggle({ Default = false, Name = "Auto Parry Agresif", Flag = "Auto Parry Agresif", Callback = function(v) VD.SURV_ParryAggressive = v end })
    
    combatSurv:AddSlider({
        Name = "Parry Distance Trigger", Flag = "Parry Distance Trigger",
        Min = 2, Max = 25, Default = 8, Increment = 0.1,
        Callback = function(v)
            VD.SURV_ParryDistance = v
        end
    })
    combatSurv:AddToggle({
        Default = false, Name = "Show Parry Range Circle", Flag = "Show Parry Range Circle", Callback = function(v)
        VD.SURV_ShowParryCircle = v
        if VD_ParryRange then VD_ParryRange.Transparency = 1 end
    end })
    
    combatSurv:AddToggle({ Default = false, Name = "Fake Parry (Press V)", Flag = "Fake Parry (Press V)", Callback = function(v) 
        VD.SURV_FakeParry = v
        if FakeParryData.Button then FakeParryData.Button.Visible = v end
    end })
    
    combatSurv:AddDropdown({
        Name = "Fake Parry Animation",
        Values = {"Enten", "Stopwatch", "Fih", "BloodShield"},
        Default = "Enten",
        Multi = false,
        Flag = "Fake Parry Animation",
        Callback = function(v)
            VD.SURV_FakeParryAnim = v
        end
    })
    
    combatSurv:AddToggle({ Default = false, Name = "Undraggable Button (Fake Parry)", Locked = false, TextLocked = "Premium Required", Flag = "Undraggable Button (Fake Parry)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Undraggable Button hanya untuk pengguna Key Premium!", 5)
            return
        end
        FakeParryData.DragLocked = v
    end })
    
    combatSurv:AddToggle({ Default = false, Name = "Fake Generator (Press B)", Flag = "Fake Generator (Press B)", Callback = function(v) 
        VD.SURV_FakeGen = v
        if FakeGenData and FakeGenData.Button then FakeGenData.Button.Visible = v end
    end })

    combatSurv:AddToggle({ Default = false, Name = "Undraggable Button (Fake Gen)", Locked = false, TextLocked = "Premium Required", Flag = "Undraggable Button (Fake Gen)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Undraggable Button hanya untuk pengguna Key Premium!", 5)
            return
        end
        if FakeGenData then FakeGenData.DragLocked = v end
    end })

    -- removed SurvivorTab AddDivider
end

local FakeParryAnimations = {
    ["Enten"]       = "rbxassetid://127096285501517",
    ["Stopwatch"]   = "rbxassetid://81793464499285",
    ["Fih"]         = "rbxassetid://123307242865945",
    ["BloodShield"] = "rbxassetid://75939529748815",
}
getgenv().KYS_FakeParryTrack = nil

-- FAKE PARRY MOBILE UI DATA
FakeParryData = {
    UI = nil,
    Button = nil,
    DragLocked = false,
    Dragging = false,
    DragStart = nil,
    DragStartPos = nil
}

function setupFakeParryBtn()
    local player = game:GetService("Players").LocalPlayer
    local oldUI = player.PlayerGui:FindFirstChild("FakeParryUI")
    if oldUI then oldUI:Destroy() end

    FakeParryData.UI = Instance.new("ScreenGui")
    FakeParryData.UI.Name = "FakeParryUI"
    FakeParryData.UI.ResetOnSpawn = false
    FakeParryData.UI.IgnoreGuiInset = true
    FakeParryData.UI.Parent = player:WaitForChild("PlayerGui")

    FakeParryData.Button = Instance.new("ImageButton")
    FakeParryData.Button.Name = "FakeParryButton"
    FakeParryData.Button.Size = UDim2.new(0, 60, 0, 60)
    FakeParryData.Button.Position = UDim2.new(0.3, 0, 0.75, 0)
    FakeParryData.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    FakeParryData.Button.BackgroundColor3 = Color3.fromRGB(20, 0, 30)
    FakeParryData.Button.BackgroundTransparency = 0.15
    FakeParryData.Button.AutoButtonColor = true
    if type(VD) == "table" then FakeParryData.Button.Visible = VD.SURV_FakeParry else FakeParryData.Button.Visible = false end
    FakeParryData.Button.ZIndex = 10
    FakeParryData.Button.Parent = FakeParryData.UI
    Instance.new("UICorner", FakeParryData.Button).CornerRadius = UDim.new(1, 0)
    
    local s = Instance.new("UIStroke", FakeParryData.Button)
    s.Color = Color3.fromRGB(150, 70, 255)
    s.Thickness = 2; s.Transparency = 0.2
    
    local lbl = Instance.new("TextLabel", FakeParryData.Button)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "FAKE\nPARRY"
    lbl.TextColor3 = Color3.fromRGB(200, 150, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    FakeParryData.Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if FakeParryData.DragLocked then return end
            FakeParryData.Dragging = true
            FakeParryData.DragStart = input.Position
            FakeParryData.DragStartPos = FakeParryData.Button.Position
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if FakeParryData.Dragging and not FakeParryData.DragLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - FakeParryData.DragStart
            FakeParryData.Button.Position = UDim2.new(
                FakeParryData.DragStartPos.X.Scale, FakeParryData.DragStartPos.X.Offset + delta.X, 
                FakeParryData.DragStartPos.Y.Scale, FakeParryData.DragStartPos.Y.Offset + delta.Y
            )
        end
    end)

    FakeParryData.Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            FakeParryData.Dragging = false
        end
    end)

    FakeParryData.Button.MouseButton1Click:Connect(VD_PlayFakeParry)
end

function VD_PlayFakeParry()
    if not VD.SURV_FakeParry then return end
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = humanoid
        end

        if getgenv().KYS_FakeParryTrack then
            pcall(function() getgenv().KYS_FakeParryTrack:Stop() end)
            getgenv().KYS_FakeParryTrack = nil
        end

        local animation = Instance.new("Animation")
        animation.AnimationId = FakeParryAnimations[VD.SURV_FakeParryAnim] or FakeParryAnimations["Enten"]

        local track = animator:LoadAnimation(animation)
        track.Priority = Enum.AnimationPriority.Action
        track:Play()
        getgenv().KYS_FakeParryTrack = track
    end)
end

if not getgenv().KYS_FakeParryInputConn then
    getgenv().KYS_FakeParryInputConn = game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.V then
            VD_PlayFakeParry()
        end
        if input.KeyCode == Enum.KeyCode.B then
            if type(VD_ToggleFakeGen) == "function" then VD_ToggleFakeGen() end
        end
    end)
end

setupFakeParryBtn()
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    setupFakeParryBtn()
    if FakeParryData.Button and type(VD) == "table" then
        FakeParryData.Button.Visible = VD.SURV_FakeParry
    end
end)

-- ==========================================
-- FAKE GENERATOR LOGIC & MOBILE BUTTON
-- ==========================================
getgenv().KYS_FakeGenTrack = nil
FakeGenData = {
    UI = nil,
    Button = nil,
    DragLocked = false,
    Dragging = false,
    DragStart = nil,
    DragStartPos = nil
}

function VD_ToggleFakeGen()
    if not VD.SURV_FakeGen then
        if getgenv().KYS_FakeGenTrack then
            pcall(function() getgenv().KYS_FakeGenTrack:Stop() end)
            getgenv().KYS_FakeGenTrack = nil
        end
        if FakeGenData.Button then
            FakeGenData.Button.BackgroundColor3 = Color3.fromRGB(20, 30, 0)
        end
        return
    end

    if getgenv().KYS_FakeGenTrack then
        pcall(function() getgenv().KYS_FakeGenTrack:Stop() end)
        getgenv().KYS_FakeGenTrack = nil
        if FakeGenData.Button then
            FakeGenData.Button.BackgroundColor3 = Color3.fromRGB(20, 30, 0)
        end
    else
        pcall(function()
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character
            if not character then return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end

            local animator = humanoid:FindFirstChildOfClass("Animator")
            if not animator then
                animator = Instance.new("Animator")
                animator.Parent = humanoid
            end

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://83160743983246"

            local track = animator:LoadAnimation(animation)
            track.Looped = true
            track.Priority = Enum.AnimationPriority.Action
            track:Play()
            getgenv().KYS_FakeGenTrack = track
            
            if FakeGenData.Button then
                FakeGenData.Button.BackgroundColor3 = Color3.fromRGB(80, 180, 100)
            end
        end)
    end
end

function setupFakeGenBtn()
    local player = game:GetService("Players").LocalPlayer
    local oldUI = player.PlayerGui:FindFirstChild("FakeGenUI")
    if oldUI then oldUI:Destroy() end

    FakeGenData.UI = Instance.new("ScreenGui")
    FakeGenData.UI.Name = "FakeGenUI"
    FakeGenData.UI.ResetOnSpawn = false
    FakeGenData.UI.IgnoreGuiInset = true
    FakeGenData.UI.Parent = player:WaitForChild("PlayerGui")

    FakeGenData.Button = Instance.new("ImageButton")
    FakeGenData.Button.Name = "FakeGenButton"
    FakeGenData.Button.Size = UDim2.new(0, 60, 0, 60)
    FakeGenData.Button.Position = UDim2.new(0.4, 0, 0.75, 0)
    FakeGenData.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    FakeGenData.Button.BackgroundColor3 = Color3.fromRGB(20, 30, 0)
    FakeGenData.Button.BackgroundTransparency = 0.15
    FakeGenData.Button.AutoButtonColor = true
    if type(VD) == "table" then FakeGenData.Button.Visible = VD.SURV_FakeGen else FakeGenData.Button.Visible = false end
    FakeGenData.Button.ZIndex = 10
    FakeGenData.Button.Parent = FakeGenData.UI
    Instance.new("UICorner", FakeGenData.Button).CornerRadius = UDim.new(1, 0)
    
    local s = Instance.new("UIStroke", FakeGenData.Button)
    s.Color = Color3.fromRGB(150, 255, 70)
    s.Thickness = 2; s.Transparency = 0.2
    
    local lbl = Instance.new("TextLabel", FakeGenData.Button)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "FAKE\nGEN"
    lbl.TextColor3 = Color3.fromRGB(200, 255, 150)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    FakeGenData.Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if FakeGenData.DragLocked then return end
            FakeGenData.Dragging = true
            FakeGenData.DragStart = input.Position
            FakeGenData.DragStartPos = FakeGenData.Button.Position
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if FakeGenData.Dragging and not FakeGenData.DragLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - FakeGenData.DragStart
            FakeGenData.Button.Position = UDim2.new(
                FakeGenData.DragStartPos.X.Scale, FakeGenData.DragStartPos.X.Offset + delta.X, 
                FakeGenData.DragStartPos.Y.Scale, FakeGenData.DragStartPos.Y.Offset + delta.Y
            )
        end
    end)

    FakeGenData.Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            FakeGenData.Dragging = false
        end
    end)

    FakeGenData.Button.MouseButton1Click:Connect(VD_ToggleFakeGen)
end

setupFakeGenBtn()

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if getgenv().KYS_FakeGenTrack then
        pcall(function() getgenv().KYS_FakeGenTrack:Stop() end)
        getgenv().KYS_FakeGenTrack = nil
    end
    task.wait(0.5)
    setupFakeGenBtn()
    if FakeGenData.Button and type(VD) == "table" then
        FakeGenData.Button.Visible = VD.SURV_FakeGen
    end
end)

    -- =====================================================
    -- FAKE PERKS (CLIENT-SIDE PERK SIMULATOR)
    -- =====================================================
    local fakePerkSection = MainFeatureTabs.Survivor:AddSection({
        Position = "Center",
        Name = "Fake Perks",
        Icon      = "solar:stars-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    local FP = {
        Conns = {},
        ActiveBuffs = {},
        HB = nil,
        LastBuffEnd = 0,
        CooldownTime = 10,
    }

    local function FP_Char()
        return LocalPlayer.Character
    end

    local function FP_Hum()
        local c = FP_Char()
        return c and c:FindFirstChildOfClass("Humanoid")
    end

    local function FP_GetTotalSpeedBuff()
        local total = 0
        for name, b in pairs(FP.ActiveBuffs) do
            if tick() < b.endTime then
                total = total + b.amt
            end
        end
        return total
    end

    local function FP_ApplySpeedToCharacter()
        local char = FP_Char()
        local hum = FP_Hum()
        local totalBuff = FP_GetTotalSpeedBuff()

        if char then
            if totalBuff > 0 then
                local multiplier = 1 + (totalBuff / 14)
                char:SetAttribute("speedboost", multiplier)
            else
                char:SetAttribute("speedboost", 1)
            end
        end

        if hum then
            local base = 16
            if totalBuff > 0 then
                hum.WalkSpeed = base + totalBuff
            end
        end
    end

    local function FP_EnsureHB()
        if FP.HB then return end
        FP.HB = game:GetService("RunService").Heartbeat:Connect(function()
            local expired = {}
            for name, b in pairs(FP.ActiveBuffs) do
                if tick() >= b.endTime then
                    table.insert(expired, name)
                end
            end
            for _, name in ipairs(expired) do
                FP.ActiveBuffs[name] = nil
            end

            if #expired > 0 then
                if FP_GetTotalSpeedBuff() <= 0 then
                    FP.LastBuffEnd = tick()
                end
            end

            FP_ApplySpeedToCharacter()

            if FP_GetTotalSpeedBuff() <= 0 and next(FP.ActiveBuffs) == nil then
                if FP.HB then FP.HB:Disconnect(); FP.HB = nil end
                local char = FP_Char()
                if char then char:SetAttribute("speedboost", 1) end
            end
        end)
    end

    local function FP_StopHB()
        if FP.HB then FP.HB:Disconnect(); FP.HB = nil end
        FP.ActiveBuffs = {}
        local char = FP_Char()
        if char then char:SetAttribute("speedboost", 1) end
    end

    local function FP_TryBuff(name, amt, dur)
        if FP.ActiveBuffs[name] then return end
        if tick() - FP.LastBuffEnd < FP.CooldownTime and next(FP.ActiveBuffs) == nil then return end

        FP.ActiveBuffs[name] = { amt = amt, endTime = tick() + dur }
        FP_ApplySpeedToCharacter()
        FP_EnsureHB()
        VD_Notify("Fake Perks", "[" .. name .. "] Aktif! +" .. amt .. " Speed (" .. dur .. "s)", 3)
    end

    local function FP_Clean(name)
        if FP.Conns[name] then
            for _, c in ipairs(FP.Conns[name]) do pcall(function() c:Disconnect() end) end
            FP.Conns[name] = nil
        end
    end

    local function FP_Reg(name, conn)
        if not FP.Conns[name] then FP.Conns[name] = {} end
        table.insert(FP.Conns[name], conn)
    end

    -- SHARED COOLDOWN SLIDER
    fakePerkSection:AddSlider({
        Name = "Cooldown (semua perks)",
        Flag = "FP_Cooldown",
        Min = 0,
        Max = 60,
        Default = 10,
        Increment = 1,
        Suffix = "s",
        Callback = function(val) FP.CooldownTime = val end
    })

    -- ========================
    -- FLOWSTATE
    -- Trigger: Vault window / pallet slide
    -- Effect: +5 speed for 3 seconds + Finesse Vault
    -- ========================
    local flowstateOn = false
    fakePerkSection:AddToggle({
        Name = "Flowstate",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "FP_Flowstate",
        Default = false,
        Callback = function(val)
            if val and false then
                pcall(VD_Notify, "Premium Required ??", "Fitur Fake Perks hanya untuk pengguna Key Premium!", 5)
                return
            end
            flowstateOn = val
            local char = FP_Char()
            if char then
                char:SetAttribute("Flowstate", val)
            end

            if val then
                local r = ReplicatedStorage:FindFirstChild("Remotes")
                local w = r and r:FindFirstChild("Window")
                local p = r and r:FindFirstChild("Pallet")

                local function onVaultAction()
                    if not flowstateOn then return end
                    task.delay(0.5, function()
                        if flowstateOn then
                            FP_TryBuff("Flowstate", 5, 3)
                        end
                    end)
                end

                if w then
                    local vb = w:FindFirstChild("Vaultbindable")
                    if vb and vb:IsA("BindableEvent") then
                        FP_Reg("Flowstate", vb.Event:Connect(onVaultAction))
                    end
                end

                if p then
                    local sb = p:FindFirstChild("Slidebindable")
                    if sb and sb:IsA("BindableEvent") then
                        FP_Reg("Flowstate", sb.Event:Connect(onVaultAction))
                    end
                end

                -- Backup trigger via character animation/attributes
                local function hookChar(c)
                    if not c then return end
                    local conn = c:GetAttributeChangedSignal("__VaultFireCount"):Connect(function()
                        if flowstateOn then onVaultAction() end
                    end)
                    FP_Reg("Flowstate", conn)
                end
                hookChar(LocalPlayer.Character)
                FP_Reg("Flowstate", LocalPlayer.CharacterAdded:Connect(function(c)
                    if flowstateOn then
                        c:SetAttribute("Flowstate", true)
                        hookChar(c)
                    end
                end))

                VD_Notify("Fake Perks", "Flowstate ON � +5 speed selama 3 detik setelah vault/slide", 4)
            else
                FP_Clean("Flowstate")
                FP.ActiveBuffs["Flowstate"] = nil
                local c = FP_Char()
                if c then c:SetAttribute("Flowstate", false) end
                VD_Notify("Fake Perks", "Flowstate OFF", 3)
            end
        end
    })

    -- ========================
    -- QUICK RECOVERY
    -- Trigger: Selesai di-heal
    -- Effect: +6 speed for 3 seconds
    -- ========================
    local quickRecOn = false
    fakePerkSection:AddToggle({
        Name = "Quick Recovery",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "FP_QuickRecovery",
        Default = false,
        Callback = function(val)
            if val and false then
                pcall(VD_Notify, "Premium Required ??", "Fitur Fake Perks hanya untuk pengguna Key Premium!", 5)
                return
            end
            quickRecOn = val
            if val then
                local function onHealed()
                    if not quickRecOn then return end
                    FP_TryBuff("QuickRecovery", 6, 3)
                end

                local r = ReplicatedStorage:FindFirstChild("Remotes")
                local healFolder = r and r:FindFirstChild("Healing")
                if healFolder then
                    local hd = healFolder:FindFirstChild("Healdone")
                    if hd and hd:IsA("BindableEvent") then
                        FP_Reg("QuickRecovery", hd.Event:Connect(onHealed))
                    end
                    local scv = healFolder:FindFirstChild("Skillcheckvalidated")
                    if scv and scv:IsA("BindableEvent") then
                        FP_Reg("QuickRecovery", scv.Event:Connect(onHealed))
                    end
                end

                local function hookHealth(c)
                    if not c then return end
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local lastHP = hum.Health
                        local conn = hum.HealthChanged:Connect(function(newHP)
                            if not quickRecOn then return end
                            if newHP > lastHP and (newHP >= hum.MaxHealth or (newHP - lastHP) >= 15) then
                                onHealed()
                            end
                            lastHP = newHP
                        end)
                        FP_Reg("QuickRecovery", conn)
                    end
                    local conn2 = c:GetAttributeChangedSignal("IsBeingHealed"):Connect(function()
                        if not quickRecOn then return end
                        if c:GetAttribute("IsBeingHealed") == false then
                            onHealed()
                        end
                    end)
                    FP_Reg("QuickRecovery", conn2)
                end
                hookHealth(LocalPlayer.Character)
                FP_Reg("QuickRecovery", LocalPlayer.CharacterAdded:Connect(hookHealth))

                VD_Notify("Fake Perks", "Quick Recovery ON � +6 speed selama 3 detik setelah di-heal", 4)
            else
                FP_Clean("QuickRecovery")
                FP.ActiveBuffs["QuickRecovery"] = nil
                VD_Notify("Fake Perks", "Quick Recovery OFF", 3)
            end
        end
    })

    -- ========================
    -- PERFECT LANDING
    -- Trigger: Landing dari ketinggian
    -- Effect: +8 speed for 3 seconds
    -- ========================
    local perfLandOn = false
    fakePerkSection:AddToggle({
        Name = "Perfect Landing",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "FP_PerfectLanding",
        Default = false,
        Callback = function(val)
            if val and false then
                pcall(VD_Notify, "Premium Required ??", "Fitur Fake Perks hanya untuk pengguna Key Premium!", 5)
                return
            end
            perfLandOn = val
            if val then
                local function hookFall(c)
                    if not c then return end
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if not hum then return end

                    local wasFalling = false
                    local fallStart = 0
                    local conn = hum.StateChanged:Connect(function(old, new)
                        if not perfLandOn then return end
                        if new == Enum.HumanoidStateType.Freefall then
                            wasFalling = true
                            fallStart = tick()
                        end
                        if wasFalling and (new == Enum.HumanoidStateType.Landed or new == Enum.HumanoidStateType.Running) then
                            local fallTime = tick() - fallStart
                            wasFalling = false
                            if fallTime >= 0.25 then
                                FP_TryBuff("PerfectLanding", 8, 3)
                            end
                        end
                    end)
                    FP_Reg("PerfectLanding", conn)
                end
                hookFall(LocalPlayer.Character)
                FP_Reg("PerfectLanding", LocalPlayer.CharacterAdded:Connect(hookFall))

                VD_Notify("Fake Perks", "Perfect Landing ON � +8 speed selama 3 detik setelah landing", 4)
            else
                FP_Clean("PerfectLanding")
                FP.ActiveBuffs["PerfectLanding"] = nil
                VD_Notify("Fake Perks", "Perfect Landing OFF", 3)
            end
        end
    })

    -- ========================
    -- ADRENALINE RUSH
    -- Trigger: HP drop <= 50 (kena hit killer)
    -- Effect: +4 speed for 5 seconds
    -- ========================
    local adrenalineOn = false
    fakePerkSection:AddToggle({
        Name = "Adrenaline Rush",
        Locked = false,
        TextLocked = "Premium Required",
        Flag = "FP_AdrenalineRush",
        Default = false,
        Callback = function(val)
            if val and false then
                pcall(VD_Notify, "Premium Required ??", "Fitur Fake Perks hanya untuk pengguna Key Premium!", 5)
                return
            end
            adrenalineOn = val
            if val then
                local function hookDamage(c)
                    if not c then return end
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if not hum then return end

                    local lastHP = hum.Health
                    local conn = hum.HealthChanged:Connect(function(newHP)
                        if not adrenalineOn then return end
                        if newHP < lastHP and newHP <= 50 and newHP > 0 then
                            FP_TryBuff("AdrenalineRush", 4, 5)
                        end
                        lastHP = newHP
                    end)
                    FP_Reg("AdrenalineRush", conn)
                end
                hookDamage(LocalPlayer.Character)
                FP_Reg("AdrenalineRush", LocalPlayer.CharacterAdded:Connect(hookDamage))

                VD_Notify("Fake Perks", "Adrenaline Rush ON � +4 speed selama 5 detik saat HP drop ke 50", 4)
            else
                FP_Clean("AdrenalineRush")
                FP.ActiveBuffs["AdrenalineRush"] = nil
                VD_Notify("Fake Perks", "Adrenaline Rush OFF", 3)
            end
        end
    })
do -- Killer Tab
    local combatKiller = MainKillerFeatureTabs.Killer:AddSection({
        Position = "Center",
        Name = "Killer",
        Icon      = "solar:danger-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    combatKiller:AddToggle({ Default = false, Name = "Auto Attack", Flag = "Auto Attack", Callback = function(v) VD.AUTO_Attack = v end })
    combatKiller:AddSlider({
        Name = "Attack Range", Flag = "Attack Range",
        Min = 5, Max = 20, Default = 12,
        Callback = function(v)
            VD.AUTO_AttackRange =
                v
        end
    })
    combatKiller:AddToggle({ Default = false, Name = "Hitbox Expand", Flag = "Hitbox Expand", Callback = function(v) VD.HITBOX_Enabled = v end })
    combatKiller:AddSlider({
        Name = "Hitbox Size", Flag = "Hitbox Size",
        Min = 5, Max = 40, Default = 15,
        Callback = function(v)
            VD.HITBOX_Size =
                v
        end
    })
    combatKiller:AddToggle({ Default = false, Name = "Infinite Lunge (Basic Attack)", Flag = "Infinite Lunge (Basic Attack)", Callback = function(v)
        VD.KILLER_InfLunge = v
    end })

    -- removed KillerTab AddDivider

    local abilityKiller = MainKillerFeatureTabs.Ability:AddSection({
        Position = "Center",
        Name = "Killer Ability",
        Icon      = "solar:bolt-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })


    abilityKiller:AddToggle({ Default = false, Name = "Infinite Abyssal Burst (Abyss)", Locked = false, TextLocked = "Premium Required", Flag = "Infinite Abyssal Burst (Abyss)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Infinite Abyssal Burst (Abyss) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_BypassCooldown = v
        if v then
            KYS_StartAbyssCooldownBypass()
        else
            KYS_StopAbyssCooldownBypass()
        end
    end })
    abilityKiller:AddToggle({ Default = false, Name = "Infinite Skill (Hidden)", Locked = false, TextLocked = "Premium Required", Flag = "Infinite Skill (Hidden)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Infinite Skill (Hidden) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_BypassLeap = v
        if v then
            pcall(KYS_StartHiddenCooldownBypass)
        else
            pcall(KYS_StopHiddenCooldownBypass)
        end
    end })
    abilityKiller:AddToggle({ Default = false, Name = "Infinite Frenzy (Jeff)", Locked = false, TextLocked = "Premium Required", Flag = "Infinite Frenzy (Jeff)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Infinite Frenzy (Jeff) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_InfFrenzy = v
        if v then
            pcall(KYS_StartJeffCooldownBypass)
        else
            pcall(KYS_StopJeffCooldownBypass)
        end
    end })

    abilityKiller:AddToggle({ Default = false, Name = "Infinite Lake Mist (Jason)", Locked = false, TextLocked = "Premium Required", Flag = "Infinite Lake Mist (Jason)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Infinite Lake Mist (Jason) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_InfLakeMist = v
        if v then
            pcall(KYS_StartSlasherCooldownBypass)
        else
            pcall(KYS_StopSlasherCooldownBypass)
        end
    end })

    abilityKiller:AddToggle({ Default = false, Name = "Infinite Pursuit (Jason)", Locked = false, TextLocked = "Premium Required", Flag = "Infinite Pursuit (Jason)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Infinite Pursuit (Jason) hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_InfPursuit = v
        if v then
            pcall(KYS_StartSlasherCooldownBypass)
        else
            pcall(KYS_StopSlasherCooldownBypass)
        end
    end })



    abilityKiller:AddToggle({ Default = false, Name = "Infinite Grab (Myers)", Locked = false, TextLocked = "Premium Required", Flag = "Infinite Grab (Myers)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Infinite Grab (Myers) hanya untuk pengguna Key Premium!", 5)
            return
        end
        setMyersGrab(v)
    end })
    
    abilityKiller:AddToggle({ Default = false, Name = "Fake Attack (Counter Parry)", Locked = false, TextLocked = "Premium Required", Flag = "Fake Attack (Counter Parry)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Fake Attack hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_FakeAttack = v
        pcall(KYS_ToggleFakeAttack, v)
    end })

    abilityKiller:AddToggle({ Default = false, Name = "Undraggable Button (Inf Grab)", Locked = false, TextLocked = "Premium Required", Flag = "Undraggable Button (Inf Grab)", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Undraggable Button hanya untuk pengguna Key Premium!", 5)
            return
        end
        setMyersDragLocked(v)
    end })
    pcall(function()
        local customMaskedMasks = {"Richard", "Tony", "Brandon", "Jake", "Richter", "Graham", "Alex"}
        abilityKiller:AddDropdown({
            Name = "Custom Masked",
            Locked = false,
            TextLocked = "Premium Required",
            Flag = "Custom Masked",
            Values = customMaskedMasks,
            Multi = false,
            Default = VD.KILLER_CustomMasked or "Richard",
            Callback = function(v)
                if v and false then
                    return
                end
                if type(v) == "table" then
                    v = v[1]
                end
                VD.KILLER_CustomMasked = v or "Richard"
            end
        })
        abilityKiller:AddButton({
            Name = "Apply Custom Masked",
            Locked = false,
            TextLocked = "Premium Required",
            Callback = function()
                if false then
                    pcall(VD_Notify, "Premium Required ✨", "Fitur Custom Masked hanya untuk pengguna Key Premium!", 5)
                    return
                end
                pcall(KYS_ApplyCustomMasked, VD.KILLER_CustomMasked)
            end
        })
        abilityKiller:AddButton({
            Name = "Random Custom Masked",
            Locked = false,
            TextLocked = "Premium Required",
            Callback = function()
                if false then
                    pcall(VD_Notify, "Premium Required ✨", "Fitur Custom Masked hanya untuk pengguna Key Premium!", 5)
                    return
                end
                local mask = customMaskedMasks[math.random(1, #customMaskedMasks)]
                VD.KILLER_CustomMasked = mask
                pcall(KYS_ApplyCustomMasked, mask)
            end
        })
    end)

    local utilKiller = MainKillerFeatureTabs.Utilities:AddSection({
        Position = "Center",
        Name = "Utilities",
        Icon      = "solar:settings-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    utilKiller:AddToggle({ Default = false, Name = "Auto Hook", Flag = "Auto Hook", Callback = function(v) VD.KILLER_AutoHook = v end })
    utilKiller:AddToggle({ Default = false, Name = "Destroy Pallets", Flag = "Destroy Pallets", Callback = function(v) VD.KILLER_DestroyPallets = v end })
    utilKiller:AddToggle({ Default = false, Name = "Auto Kick Generator", Flag = "Auto Kick Generator", Callback = function(v) VD.KILLER_AutoBreakGene = v end })
    utilKiller:AddToggle({ Default = false, Name = "Block All Vaults", Locked = false, TextLocked = "Premium Required", Flag = "Block All Vaults", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Block All Vaults hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_BlockVaults = v
    end })
    utilKiller:AddToggle({ Default = false, Name = "Auto Drop All Pallets", Locked = false, TextLocked = "Premium Required", Flag = "Auto Drop All Pallets", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Auto Drop All Pallets hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_BlockPallets = v
    end })
    utilKiller:AddToggle({ Default = false, Name = "Break All Pallet", Locked = false, TextLocked = "Premium Required", Flag = "Break All Pallet", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Break All Pallet hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.KILLER_BlockPalletDrop = v
    end })

    utilKiller:AddToggle({
        Default = false,
        Name = "Anti Blind (Flashlight)", Flag = "Anti Blind (Flashlight)",
        Callback = function(v)
            VD.KILLER_AntiBlind = v; pcall(SetupAntiBlind)
        end
    })
    utilKiller:AddToggle({
        Default = false,
        Name = "Remove Palletwrong (All)", Flag = "Remove Palletwrong (All)",
        Callback = function(v)
            VD.KILLER_NoPalletStun = v; pcall(SetupNoPalletStun)
        end
    })
    utilKiller:AddToggle({ Default = false, Name = "No Slowdown", Flag = "No Slowdown", Callback = function(v) VD.KILLER_NoSlowdown = v end })
    utilKiller:AddToggle({ Default = false, Name = "Beat Killer (auto kill)", Flag = "Beat Killer (auto kill)", Callback = function(v) VD.BEAT_Killer = v end })

    utilKiller:AddDivider({ Text = "Target Lock" })

    utilKiller:AddToggle({ Default = false, Name = "Target Lock", Flag = "Target Lock", Callback = function(v)
        if getgenv().VD_SetAimLockButtonVisible then
            getgenv().VD_SetAimLockButtonVisible(v)
        else
            VD.AimLockButton = v
        end
    end })
    utilKiller:AddToggle({ Default = false, Name = "Lock Target Lock Button", Flag = "Lock Target Lock Button", Callback = function(v)
        VD.AimLockButtonLocked = v and true or false
    end })
    utilKiller:AddSlider({
        Name = "Target Lock Max Distance", Flag = "Target Lock Max Distance",
        Min = 10, Max = 200, Default = 50,
        Callback = function(v)
            VD.AimLockMaxDistance = v
        end
    })
end

do -- Escape Tab
    local escapeSurv = MainFeatureTabs.Escape:AddSection({
        Position = "Center",
        Name = "Escape",
        Icon      = "solar:exit-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    escapeSurv:AddToggle({ Default = false, Name = "Bypass Gate", Flag = "Bypass Gate", Callback = function(v) VD.BypassGate = v; if not v then pcall(VD_RestoreGateParts) end end })
    escapeSurv:AddToggle({ Default = false, Name = "Beat Survivor (auto exit)", Locked = false, TextLocked = "Premium Required", Flag = "Beat Survivor (auto exit)", Callback = function(v) 
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Beat Survivor hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.BEAT_Survivor = v 
    end })

    escapeSurv:AddToggle({ Default = false, Name = "Flee Killer", Flag = "Flee Killer", Callback = function(v) VD.SURV_FleeKiller = v end })
    escapeSurv:AddSlider({
        Name = "Flee Distance", Flag = "Flee Distance",
        Min = 15, Max = 80, Default = 40,
        Callback = function(v) VD.SURV_FleeDistance = v end
    })
end

do -- Generator Tab

    -- removed GeneratorTab AddDivider

    local genAuto = MainFeatureTabs.Automation:AddSection({
        Position = "Center",
        Name = "Automation",
        Icon      = "solar:bolt-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })


    genAuto:AddToggle({ Default = false, Name = "Auto Skillcheck", Flag = "Auto Skillcheck", Callback = function(v) VD_SetAutoSkillcheck(v) end })
    genAuto:AddToggle({ Default = false, Name = "Hide Skillcheck UI", Flag = "Hide Skillcheck UI", Callback = function(v) VD.HideSkillUI = v end })
    genAuto:AddToggle({ Default = false, Name = "Boost Gen Bypass", Locked = false, TextLocked = "Premium Required", Flag = "Boost Gen Bypass", Callback = function(v)
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Boost Gen Bypass hanya untuk pengguna Key Premium!", 5)
            return
        end
        setGenBypass(v)
    end })
    genAuto:AddDropdown({
        Name = "Skillcheck Mode",
        Flag = "Skillcheck Mode",
        Values = { "Normal", "Perfect", "Instant" },
        Default = "Normal",
        DisabledOptions = false and { "Instant" } or {},
        Multi = false,
        Callback = function(option)
            if type(option) == "table" then option = option[1] end
            if option == "Instant" and false then
                pcall(VD_Notify, "Premium Required ✨", "Opsi Instant hanya untuk pengguna Key Premium!", 5)
                return
            end
            VD.AutoSkillcheckMode = option or "Normal"
            if VD.AutoSkillcheckMode ~= "Instant" and AutoSkill.InstantRotationConnection then
                AutoSkill.InstantRotationConnection:Disconnect()
                AutoSkill.InstantRotationConnection = nil
                AutoSkill.InstantHasClicked = false
            end
            VD_Notify("Skillcheck Mode", tostring(VD.AutoSkillcheckMode) .. " selected", 2)
        end
    })
end

do -- Fling Tab
    local flingSection = PlayerFeatureTabs.Fling:AddSection({
        Position = "Center",
        Name = "Fling",
        Icon      = "solar:wind-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    flingSection:AddToggle({ Default = false, Name = "Enable Fling", Locked = false, TextLocked = "Premium Required", Flag = "Enable Fling", Callback = function(v) 
        if v and false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Fling hanya untuk pengguna Key Premium!", 5)
            return
        end
        VD.FLING_Enabled = v 
    end })
    flingSection:AddSlider({
        Name = "Fling Strength", Flag = "Fling Strength",
        Min = 1000, Max = 50000, Default = 10000,
        Callback = function(
            v)
            VD.FLING_Strength = v
        end
    })

    -- removed FlingTab AddDivider

    flingSection:AddButton({ Name = "Fling Nearest", Locked = false, TextLocked = "Premium Required", Callback = function() 
        if false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Fling hanya untuk pengguna Key Premium!", 5)
            return
        end
        pcall(function() KYS_FlingNearest() end) 
    end })
    flingSection:AddButton({ Name = "Fling All", Locked = false, TextLocked = "Premium Required", Callback = function() 
        if false then
            pcall(VD_Notify, "Premium Required ✨", "Fitur Fling hanya untuk pengguna Key Premium!", 5)
            return
        end
        pcall(KYS_FlingAll) 
    end })
end

-- =====================================================
-- PLAYER EMOTE SYSTEM (Logic from PanduHub1.lua)
-- =====================================================
local SelectedAnim = "rbxassetid://83229063951016"
local SelectedSound = "rbxassetid://85355610204255"
local currentTrack = nil
local currentSound = nil

local EmoteOptions = {
    "Friday Night",
    "WarCry",
    "24 Hour Cinderella",
    "Applause",
    "Arm Swing",
    "Backflip",
    "California Girls",
    "Christmas Spirit",
    "Floating Rest",
    "Ghoul",
    "Griddy",
    "Kyoufuu",
    "OnePlays",
    "Vulnerable",
}

local function SelectEmoteData(value)
    if value == "Friday Night" then
        SelectedAnim = "rbxassetid://83229063951016"
        SelectedSound = "rbxassetid://85355610204255"
    elseif value == "WarCry" then
        SelectedAnim = "rbxassetid://82600868380136"
        SelectedSound = "rbxassetid://120101930689931"
    elseif value == "24 Hour Cinderella" then
        SelectedAnim = "rbxassetid://137195203725366"
        SelectedSound = "rbxassetid://121099446613414"
    elseif value == "Applause" then
        SelectedAnim = "rbxassetid://96328361165090"
        SelectedSound = "rbxassetid://115490787020749"
    elseif value == "Arm Swing" then
        SelectedAnim = "rbxassetid://80552139463944"
        SelectedSound = "rbxassetid://74216458932348"
    elseif value == "Backflip" then
        SelectedAnim = "rbxassetid://74705617908505"
        SelectedSound = nil
    elseif value == "California Girls" then
        SelectedAnim = "rbxassetid://123552803041504"
        SelectedSound = "rbxassetid://87899327891544"
    elseif value == "Christmas Spirit" then
        SelectedAnim = "rbxassetid://137859761110514"
        SelectedSound = nil
    elseif value == "Floating Rest" then
        SelectedAnim = "rbxassetid://114593021219597"
        SelectedSound = nil
    elseif value == "Ghoul" then
        SelectedAnim = "rbxassetid://130415594909401"
        SelectedSound = "rbxassetid://123004139176580"
    elseif value == "Griddy" then
        SelectedAnim = "rbxassetid://75586690784894"
        SelectedSound = nil
    elseif value == "Kyoufuu" then
        SelectedAnim = "rbxassetid://137322894494527"
        SelectedSound = "rbxassetid://129064643026442"
    elseif value == "OnePlays" then
        SelectedAnim = "rbxassetid://140625405103474"
        SelectedSound = "rbxassetid://94749073728335"
    elseif value == "Vulnerable" then
        SelectedAnim = "rbxassetid://121773684313913"
        SelectedSound = "rbxassetid://135265751184744"
    end
end

local function PlayEmote()
    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if currentTrack then
        currentTrack:Stop()
        currentTrack = nil
    end
    if currentSound then
        currentSound:Destroy()
        currentSound = nil
    end

    if SelectedAnim then
        local anim = Instance.new("Animation")
        anim.AnimationId = SelectedAnim
        currentTrack = hum:LoadAnimation(anim)
        currentTrack.Looped = true
        currentTrack:Play()
    end

    if SelectedSound then
        currentSound = Instance.new("Sound")
        currentSound.SoundId = SelectedSound
        currentSound.Looped = true
        currentSound.Volume = 2
        currentSound.Parent = hrp
        currentSound:Play()
    end
end

local function StopEmote()
    if currentTrack then
        currentTrack:Stop()
        currentTrack = nil
    end
    if currentSound then
        currentSound:Destroy()
        currentSound = nil
    end
end

do -- Emote Tab
    local emoteSection = PlayerFeatureTabs.Emote:AddSection({
        Position = "Center",
        Name = "Player Emote [BETA]",
        Icon      = "solar:music-note-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    VD.SelectedEmote = "Friday Night"
    VD.EmoteEnabled = false

    emoteSection:AddToggle({
        Default = false,
        Name = "Enable Emote",
        Flag = "Enable Emote",
        Callback = function(v)
            VD.EmoteEnabled = v
            if v then
                PlayEmote()
            else
                StopEmote()
            end
        end
    })

    emoteSection:AddDropdown({
        Name = "Select Emote",
        Flag = "Select Emote",
        Values = EmoteOptions,
        Default = "Friday Night",
        Multi = false,
        Callback = function(option)
            if type(option) == "table" then option = option[1] end
            VD.SelectedEmote = option or "Friday Night"
            SelectEmoteData(VD.SelectedEmote)
            if VD.EmoteEnabled then
                PlayEmote()
            end
        end
    })
end

do -- Fun Tab
    local funSection = PlayerMiscFeatureTabs.Fun:AddSection({
        Position = "Center",
        Name = "Spoof Stats [Visual Only]",
        Icon = "solar:gamepad-bold",
        Box = true,
        BoxBorder = true,
        Opened = true,
    })

    local spoofLevel, spoofGears, spoofScrews = "0", "0", "0"

    funSection:AddTextInput({
        Name = "Set Level",
        Flag = "SpoofLevel",
        Numeric = true,
        Default = "0",
        Callback = function(value) spoofLevel = value end
    })

    funSection:AddTextInput({
        Name = "Set Gears",
        Flag = "SpoofGears",
        Numeric = true,
        Default = "0",
        Callback = function(value) spoofGears = value end
    })

    funSection:AddTextInput({
        Name = "Set Screws",
        Flag = "SpoofScrews",
        Numeric = true,
        Default = "0",
        Callback = function(value) spoofScrews = value end
    })

    funSection:AddButton({
        Name = "Apply Spoof Data",
        Callback = function()
            local p = LocalPlayer
            if p then
                p:SetAttribute("Level", tonumber(spoofLevel) or 0)
                p:SetAttribute("Gears", tonumber(spoofGears) or 0)
                p:SetAttribute("Screws", tonumber(spoofScrews) or 0)
                if VD_Notify then
                    VD_Notify("Spoof Data", "Level, Gears, dan Screws diperbarui", 3)
                end
            end
        end
    })
end

do -- Streamer Mode Tab
    local streamerSection = PlayerMiscFeatureTabs.Streamer:AddSection({
        Position = "Center",
        Name = "Streamer Mode",
        Icon      = "solar:users-group-rounded-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    local FakeNameConnection = nil

    local function shouldHideNameObject(object)
        local ok, isTextObj = pcall(function()
            return object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")
        end)
        if not ok or not isTextObj then
            return false
        end
        local text = ""
        pcall(function() text = tostring(object.Text or "") end)
        return text == LocalPlayer.Name or text == LocalPlayer.DisplayName or text:find(LocalPlayer.Name, 1, true) ~= nil
    end

    local function enableFakeName(enabled)
        if FakeNameConnection then
            pcall(function() FakeNameConnection:Disconnect() end)
            FakeNameConnection = nil
        end
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then
            return
        end
        local function process(object)
            if shouldHideNameObject(object) then
                object.Visible = not enabled
            end
        end
        for _, descendant in ipairs(playerGui:GetDescendants()) do
            process(descendant)
        end
        if enabled then
            FakeNameConnection = playerGui.DescendantAdded:Connect(function(object)
                task.defer(process, object)
            end)
        end
    end

    streamerSection:AddToggle({
        Default = false,
        Name = "Hide Name",
        Flag = "Hide Name",
        Callback = function(v)
            pcall(enableFakeName, v)
        end
    })
end

local KorlessMorph = {
    Connection = nil
}

local function ApplyKorless()
    local function Morph()
        repeat task.wait()
        until LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            and LocalPlayer.Character:FindFirstChild("Right Leg")

        task.wait(0.1)
        local char = LocalPlayer.Character

        pcall(function()
            char.Head.Transparency = 1

            local face = char.Head:FindFirstChild("face")
            if face then
                face:Destroy()
            end

            char["Right Leg"].Transparency = 1

            local mesh = Instance.new("MeshPart")
            mesh.Name = "KorlessHead"
            mesh.Size = Vector3.new(1.5, 1.5, 1.5)
            mesh.CanCollide = false
            mesh.MeshId = "rbxassetid://902942096"
            mesh.TextureID = "rbxassetid://902843398"
            mesh.CFrame = char["Right Leg"].CFrame * CFrame.new(0, 0.5, 0)
            mesh.Parent = char

            local weld = Instance.new("WeldConstraint")
            weld.Part0 = char["Right Leg"]
            weld.Part1 = mesh
            weld.Parent = mesh
        end)
    end

    Morph()

    if KorlessMorph.Connection then
        KorlessMorph.Connection:Disconnect()
    end

    KorlessMorph.Connection = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        Morph()
    end)
end

do -- Korless Tab
    local avatarSection = PlayerMiscFeatureTabs.Avatar:AddSection({
        Position = "Center",
        Name = "Korless Morph",
        Icon      = "solar:users-group-rounded-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    avatarSection:AddButton({
        Name = "APPLY KORLESS",
        Callback = function()
            ApplyKorless()
            VD_Notify("Korless Morph", "Korless Morph Applied successfully!", 3)
        end
    })

    avatarSection:AddButton({
        Name = "RESET KORLESS",
        Callback = function()
            if KorlessMorph.Connection then
                pcall(function() KorlessMorph.Connection:Disconnect() end)
                KorlessMorph.Connection = nil
            end
            pcall(function()
                local korHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("KorlessHead")
                if korHead then korHead:Destroy() end
            end)
            VD_Notify("Korless Morph", "Korless Morph berhasil direset!", 3)
        end
    })

    local copyAvatarSection = PlayerMiscFeatureTabs.Avatar:AddSection({
        Position = "Center",
        Name = "Copy Avatar",
        Icon      = "solar:user-id-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })

    local selectedAvatarPlayer = nil

    local copyAvatarDropdown = copyAvatarSection:AddDropdown({
        Name = "Select Player",
        Flag = "CopyAvatar_SelectPlayer",
        Values = {},
        Multi = false,
        Callback = function(v)
            if type(v) == "table" then
                selectedAvatarPlayer = v[1]
            else
                selectedAvatarPlayer = v
            end
        end
    })

    local function UpdatePlayerDropdown()
        local list = {}
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(list, p.Name)
            end
        end
        pcall(function() copyAvatarDropdown:SetValues(list) end)
    end
    
    UpdatePlayerDropdown()
    game:GetService("Players").PlayerAdded:Connect(UpdatePlayerDropdown)
    game:GetService("Players").PlayerRemoving:Connect(UpdatePlayerDropdown)

    local originalAvatarCache = {}
    local originalAvatarSaved = false
    local originalHeadMeshScale = nil

    local function AddAccessoryLocal(char, accessory)
        local handle = accessory:FindFirstChild("Handle")
        if not handle then return end
        
        local accAtt = nil
        for _, v in ipairs(handle:GetChildren()) do
            if v:IsA("Attachment") then
                accAtt = v
                break
            end
        end
        if not accAtt then return end
        
        local charAtt, targetPart = nil, nil
        local fh = char:FindFirstChild("FakeCopiedHead")
        if fh then
            local att = fh:FindFirstChild(accAtt.Name)
            if att and att:IsA("Attachment") then
                charAtt = att
                targetPart = fh
            end
        end
        if not charAtt then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "FakeCopiedHead" then
                    local att = part:FindFirstChild(accAtt.Name)
                    if att and att:IsA("Attachment") then
                        charAtt = att
                        targetPart = part
                        break
                    end
                end
            end
        end
        if not charAtt then return end
        
        for _, v in ipairs(handle:GetChildren()) do
            if v:IsA("JointInstance") or v:IsA("WeldConstraint") or v:IsA("Constraint") or v:IsA("Script") or v:IsA("LocalScript") then
                v:Destroy()
            end
        end
        
        accessory.Parent = char
        local weld = Instance.new("Weld")
        weld.Name = "AccessoryWeld"
        weld.Part0 = handle
        weld.Part1 = targetPart
        weld.C0 = accAtt.CFrame
        weld.C1 = charAtt.CFrame
        weld.Parent = handle
    end

    local standardParts = {
        Head=true, Torso=true, ["Left Arm"]=true, ["Right Arm"]=true, ["Left Leg"]=true, ["Right Leg"]=true, HumanoidRootPart=true,
        UpperTorso=true, LowerTorso=true, LeftUpperArm=true, LeftLowerArm=true, LeftHand=true, RightUpperArm=true, RightLowerArm=true, RightHand=true, LeftUpperLeg=true, LeftLowerLeg=true, LeftFoot=true, RightUpperLeg=true, RightLowerLeg=true, RightFoot=true
    }

    local function SaveOriginalAvatar()
        if originalAvatarSaved then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") or obj:IsA("BodyColors") then
                table.insert(originalAvatarCache, obj:Clone())
            elseif obj:IsA("BasePart") and not standardParts[obj.Name] and obj.Name ~= "FakeCopiedHead" then
                table.insert(originalAvatarCache, obj:Clone())
            end
        end
        local head = char:FindFirstChild("Head")
        if head then
            local sm = head:FindFirstChildOfClass("SpecialMesh")
            if sm then originalHeadMeshScale = sm.Scale end
            for _, v in ipairs(head:GetChildren()) do
                if v:IsA("Decal") or v:IsA("Texture") then
                    table.insert(originalAvatarCache, v:Clone())
                end
            end
        end
        originalAvatarSaved = true
    end

    local function ApplyTargetAvatar(targetChar)
        local myChar = LocalPlayer.Character
        if not myChar or not targetChar then return false end
        
        for _, obj in ipairs(myChar:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") or obj:IsA("BodyColors") then
                obj:Destroy()
            elseif obj:IsA("BasePart") and not standardParts[obj.Name] and obj.Name ~= "FakeCopiedHead" then
                obj:Destroy()
            end
        end
        
        local myHead = myChar:FindFirstChild("Head")
        if myHead then
            for _, v in ipairs(myHead:GetChildren()) do
                if v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                end
            end
        end
        
        local targetHead = targetChar:FindFirstChild("Head")
        if targetHead and myHead then
            myHead.Transparency = 1
            local oldFake = myChar:FindFirstChild("FakeCopiedHead")
            if oldFake then oldFake:Destroy() end
            
            local fakeHead = targetHead:Clone()
            fakeHead.Name = "FakeCopiedHead"
            fakeHead.CanCollide = false
            fakeHead.Massless = true
            local targetBc = targetChar:FindFirstChildOfClass("BodyColors")
            if targetBc then fakeHead.Color = targetBc.HeadColor3 else fakeHead.Color = targetHead.Color end
            local mySm = myHead:FindFirstChildOfClass("SpecialMesh")
            if mySm then mySm.Scale = Vector3.new(0, 0, 0) end
            myHead.LocalTransparencyModifier = 1
            for _, v in ipairs(fakeHead:GetChildren()) do
                if v:IsA("Motor6D") or v:IsA("Weld") or v:IsA("WeldConstraint") or v:IsA("Script") or v:IsA("LocalScript") then
                    v:Destroy()
                end
            end
            fakeHead.Parent = myChar
            
            local hw = Instance.new("Weld")
            hw.Name = "FakeHeadWeld"
            hw.Part0 = myHead
            hw.Part1 = fakeHead
            hw.C0 = CFrame.new()
            hw.C1 = CFrame.new()
            hw.Parent = fakeHead
        end
        
        for _, obj in ipairs(targetChar:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") then
                AddAccessoryLocal(myChar, obj:Clone())
            elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") or obj:IsA("BodyColors") then
                obj:Clone().Parent = myChar
            elseif obj:IsA("BasePart") and not standardParts[obj.Name] and obj.Name ~= "FakeCopiedHead" then
                local clone = obj:Clone()
                for _, v in ipairs(clone:GetDescendants()) do
                    if v:IsA("JointInstance") or v:IsA("WeldConstraint") or v:IsA("Constraint") or v:IsA("Script") or v:IsA("LocalScript") then
                        v:Destroy()
                    end
                end
                
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso")
                local myRoot = myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("UpperTorso")
                
                if targetRoot and myRoot then
                    local offset = targetRoot.CFrame:Inverse() * obj.CFrame
                    clone.CFrame = myRoot.CFrame * offset
                    
                    local wc = Instance.new("WeldConstraint")
                    wc.Part0 = clone
                    wc.Part1 = myRoot
                    wc.Parent = clone
                end
                
                clone.Parent = myChar
            end
        end
        return true
    end

    copyAvatarSection:AddButton({
        Name = "Apply Ava",
        Callback = function()
            if not selectedAvatarPlayer or selectedAvatarPlayer == "" then
                VD_Notify("Copy Avatar", "Pilih player dulu!", 3)
                return
            end
            local targetPlayer = game:GetService("Players"):FindFirstChild(selectedAvatarPlayer)
            if targetPlayer and targetPlayer.Character then
                pcall(SaveOriginalAvatar)
                local success = ApplyTargetAvatar(targetPlayer.Character)
                if success then
                    VD_Notify("Copy Avatar", "Berhasil copy avatar " .. targetPlayer.Name .. "!", 3)
                else
                    VD_Notify("Copy Avatar", "Gagal mengcopy avatar!", 3)
                end
            else
                VD_Notify("Copy Avatar", "Player / Character tidak ditemukan!", 3)
            end
        end
    })

    copyAvatarSection:AddButton({
        Name = "Reset Ava",
        Callback = function()
            local char = LocalPlayer.Character
            if not char or not originalAvatarSaved then
                VD_Notify("Reset Avatar", "Tidak ada data original avatar tersimpan!", 3)
                return
            end
            pcall(function()
                for _, obj in ipairs(char:GetChildren()) do
                    if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") or obj:IsA("BodyColors") then
                        obj:Destroy()
                    end
                end
                local head = char:FindFirstChild("Head")
                if head then
                    local face = head:FindFirstChildOfClass("Decal")
                    if face then face:Destroy() end
                    local oldFake = char:FindFirstChild("FakeCopiedHead")
                    if oldFake then oldFake:Destroy() end
                    head.Transparency = 0
                    head.LocalTransparencyModifier = 0
                    local mySm = head:FindFirstChildOfClass("SpecialMesh")
                    if mySm and originalHeadMeshScale then
                        mySm.Scale = originalHeadMeshScale
                    elseif mySm then
                        mySm.Scale = Vector3.new(1.25, 1.25, 1.25)
                    end
                end
                local myHum = char:FindFirstChildOfClass("Humanoid")
                for _, obj in ipairs(originalAvatarCache) do
                    local clone = obj:Clone()
                    if clone:IsA("Decal") then
                        if head then clone.Parent = head end
                    elseif clone:IsA("Accessory") then
                        AddAccessoryLocal(char, clone)
                    else
                        clone.Parent = char
                    end
                end
            end)
            VD_Notify("Copy Avatar", "Avatar dikembalikan ke semula!", 3)
        end
    })

end

end -- end if Window then

print("KYS HUB Violence District v1.5.7 Loaded")
pcall(function()
    VD_Notify("KysHub crack", "Violence District v1.5.7 Loaded Successfully!", 5)
end)

-- =====================================================
-- ROLE HELPERS
-- =====================================================
function GetRole()
    if not LocalPlayer.Team then return "Unknown" end
    local name = LocalPlayer.Team.Name
    if name == "Killer" then return "Killer" end
    if name == "Survivors" then return "Survivor" end
    return "Lobby"
end

function IsKiller(player)
    return player and player.Team and player.Team.Name == "Killer"
end

function IsSurvivor(player)
    return player and player.Team and player.Team.Name == "Survivors"
end

function KYS_ApplyCustomMasked(maskName)
    local selectedMask = maskName or VD.KILLER_CustomMasked or "Richard"
    if type(selectedMask) == "table" then
        selectedMask = selectedMask[1]
    end
    if type(selectedMask) ~= "string" or selectedMask == "" then
        selectedMask = "Richard"
    end

    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local killers = remotes and remotes:FindFirstChild("Killers")
    local masked = killers and killers:FindFirstChild("Masked")
    local activatePower = masked and masked:FindFirstChild("Activatepower")

    if activatePower and activatePower:IsA("RemoteEvent") then
        activatePower:FireServer(selectedMask)
        return true
    end
    return false
end

function VD_GetGameValue(obj, name)
    if typeof(obj) ~= "Instance" then return nil end
    local attr = obj:GetAttribute(name)
    if attr ~= nil then return attr end
    local child = obj:FindFirstChild(name)
    if child and child:IsA("ValueBase") then return child.Value end
    return nil
end

function VD_IsStatusActive(value)
    return value == true or (type(value) == "number" and value > 0)
end

function VD_RunAntiKnock()
    if not VD.SURV_AntiKnock or GetRole() ~= "Survivor" then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum then return end

    local isKnocked = VD_IsStatusActive(VD_GetGameValue(char, "Knocked"))
        or VD_IsStatusActive(VD_GetGameValue(char, "IsKnocked"))
    local isCarried = VD_IsStatusActive(VD_GetGameValue(char, "Carried"))
        or VD_IsStatusActive(VD_GetGameValue(char, "IsCarried"))
        or VD_IsStatusActive(VD_GetGameValue(char, "Grabbed"))

    if not isKnocked and not isCarried then return end
    local now = tick()
    if VD._LastAntiKnock and now - VD._LastAntiKnock < 0.3 then return end
    VD._LastAntiKnock = now

    for _, flag in ipairs({ "Knocked", "IsKnocked", "Carried", "IsCarried", "Grabbed", "Ragdolled", "Captured", "Disabled" }) do
        pcall(function()
            if char:GetAttribute(flag) ~= nil then char:SetAttribute(flag, false) end
            local obj = char:FindFirstChild(flag)
            if obj and obj:IsA("BoolValue") then
                obj.Value = false
            elseif obj and (obj:IsA("NumberValue") or obj:IsA("IntValue")) then
                obj.Value = 0
            end
        end)
    end

    pcall(function()
        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        if hum:GetState() == Enum.HumanoidStateType.Physics
            or hum:GetState() == Enum.HumanoidStateType.Ragdoll
            or hum:GetState() == Enum.HumanoidStateType.FallingDown
            or hum:GetState() == Enum.HumanoidStateType.PlatformStanding then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        if root then root.AssemblyLinearVelocity = Vector3.zero end
        task.defer(function()
            pcall(function()
                hum.Health = hum.MaxHealth
                hum.WalkSpeed = math.max(hum.WalkSpeed, 16)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end)
    end)
end

function VD_ClearSurvivorWarnings()
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local warn = root and root:FindFirstChild("KYS_SurvivorKillerWarn")
        if warn then warn:Destroy() end
    end
end

local VD_WarnIconPaths = {
    Yellow = "/tmp/codex-web-uploads/f-LtzTRl/file_000000004f9871fa9d73773e3af21740.png",
    red = "/tmp/codex-web-uploads/f-Yo5gYu/file_00000000fb90720782fb54bce5fe8099.png",
}
local VD_WarnIconAssetIds = {
    Yellow = "113063284092207",
    red = "87337602602637",
}
local VD_WarnIconCache = {}

function VD_FormatAssetId(assetId)
    assetId = tostring(assetId or "")
    if assetId == "" then return nil end
    if assetId:find("rbxassetid://", 1, true) then return assetId end
    if assetId:find("rbxthumb://", 1, true) then return assetId end
    if assetId:match("^%d+$") then
        return "rbxthumb://type=Asset&id=" .. assetId .. "&w=150&h=150"
    end
    return "rbxassetid://" .. assetId
end

function VD_GetWarnIcon(colorName, path)
    local asset = VD_FormatAssetId(VD_WarnIconAssetIds[colorName])
    if asset then return asset end
    if VD_WarnIconCache[path] ~= nil then return VD_WarnIconCache[path] or nil end
    if not getcustomasset then
        VD_WarnIconCache[path] = false
        return nil
    end
    local ok, asset = pcall(getcustomasset, path)
    VD_WarnIconCache[path] = ok and asset or false
    return VD_WarnIconCache[path] or nil
end

function VD_EnsureWarnImage(parent, name, image, position)
    local img = parent:FindFirstChild(name)
    if not img then
        img = Instance.new("ImageLabel")
        img.Name = name
        img.BackgroundTransparency = 1
        img.ImageTransparency = 0
        img.ScaleType = Enum.ScaleType.Fit
        img.ZIndex = 2
        img.Parent = parent
    end
    img.Image = image or ""
    img.Position = position or UDim2.fromScale(0, 0)
    img.Size = UDim2.fromScale(0.5, 1)
    img.Visible = image ~= nil
    return img
end

function VD_UpdateSurvivorWarnings()
    if not VD.SURV_WarnKiller then
        if VD._WarnKillerActive then
            VD_ClearSurvivorWarnings()
            VD._WarnKillerActive = false
        end
        return
    end
    local now = tick()
    if VD._WarnKillerKyst and now < VD._WarnKillerKyst then return end
    VD._WarnKillerKyst = now + 0.15
    VD._WarnKillerActive = true

    local killers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsKiller(player) and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then table.insert(killers, root) end
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if IsSurvivor(player) and player.Character then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local nearest = math.huge
                for _, killerRoot in ipairs(killers) do
                    nearest = math.min(nearest, (root.Position - killerRoot.Position).Magnitude)
                end

                local warn = root:FindFirstChild("KYS_SurvivorKillerWarn")
                if nearest <= 60 then
                    local danger = nearest <= 40
                    if not warn then
                        warn = Instance.new("BillboardGui")
                        warn.Name = "KYS_SurvivorKillerWarn"
                        warn.Adornee = root
                        warn.AlwaysOnTop = true
                        warn.Size = UDim2.new(0, 76, 0, 44)
                        warn.StudsOffset = Vector3.new(0, 4.8, 0)
                        warn.MaxDistance = 2000
                        warn.Parent = root

                        local label = Instance.new("TextLabel")
                        label.Name = "FallbackLabel"
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.fromScale(1, 1)
                        label.Font = Enum.Font.GothamBlack
                        label.TextScaled = true
                        label.Visible = false
                        label.Parent = warn

                        local stroke = Instance.new("UIStroke")
                        stroke.Thickness = 1.5
                        stroke.Color = Color3.new(0, 0, 0)
                        stroke.Parent = label
                    end
                    local yellowIcon = VD_GetWarnIcon("Yellow", VD_WarnIconPaths.Yellow)
                    local purpleIcon = VD_GetWarnIcon("Red", VD_WarnIconPaths.red)
                    local canUseImages = yellowIcon ~= nil and (not danger or purpleIcon ~= nil)
                    warn.Size = danger and UDim2.new(0, 76, 0, 56) or UDim2.new(0, 56, 0, 56)

                    local yellow = VD_EnsureWarnImage(warn, "YellowIcon", yellowIcon, UDim2.fromScale(0, 0))
                    local purple = VD_EnsureWarnImage(warn, "redIcon", purpleIcon, UDim2.fromScale(0.38, 0))
                    yellow.Size = danger and UDim2.fromScale(0.62, 1) or UDim2.fromScale(1, 1)
                    purple.Size = UDim2.fromScale(0.62, 1)
                    yellow.Visible = canUseImages
                    purple.Visible = canUseImages and danger

                    local label = warn:FindFirstChild("FallbackLabel")
                    if label then
                        label.Visible = not canUseImages
                        label.Text = danger and "!!" or "!"
                        label.TextColor3 = danger and Color3.fromRGB(255, 40, 40) or Color3.fromRGB(255, 225, 0)
                    end
                elseif warn then
                    warn:Destroy()
                end
            end
        end
    end
end

local VD_GateOriginal = setmetatable({}, { __mode = "k" })
function VD_SetPartState(part, props)
    if not part or not part:IsA("BasePart") then return end
    if not VD_GateOriginal[part] then
        VD_GateOriginal[part] = {
            Transparency = part.Transparency,
            CanCollide = part.CanCollide,
        }
    end
    pcall(function()
        if props.Transparency ~= nil then part.Transparency = props.Transparency end
        if props.CanCollide ~= nil then part.CanCollide = props.CanCollide end
    end)
end

function VD_RestoreGateParts()
    for part, props in pairs(VD_GateOriginal) do
        if part and part.Parent then
            pcall(function()
                part.Transparency = props.Transparency
                part.CanCollide = props.CanCollide
            end)
        end
    end
    VD_GateOriginal = setmetatable({}, { __mode = "k" })
end

function VD_UpdateBypassGate()
    if not VD.BypassGate then
        if next(VD_GateOriginal) then VD_RestoreGateParts() end
        return
    end
    if VD._KystBypassGate and tick() < VD._KystBypassGate then return end
    VD._KystBypassGate = tick() + 1
    for _, gate in ipairs(Workspace:GetDescendants()) do
        if gate:IsA("Model") and gate.Name == "Gate" then
            VD_SetPartState(gate:FindFirstChild("LeftGate"), { Transparency = 1, CanCollide = false })
            VD_SetPartState(gate:FindFirstChild("RightGate"), { Transparency = 1, CanCollide = false })
            VD_SetPartState(gate:FindFirstChild("LeftGate-end"), { Transparency = 0, CanCollide = true })
            VD_SetPartState(gate:FindFirstChild("RightGate-end"), { Transparency = 0, CanCollide = true })
            VD_SetPartState(gate:FindFirstChild("Box"), { CanCollide = false })
        end
    end
end

local VD_InvisibleNV = {
    Active = false,
    Seat = nil,
    Weld = nil,
    OriginalSpeed = nil,
    Position = Vector3.new(-25.95, 84, 3537.55),
}

function VD_SetCharacterTransparency(character, transparency)
    for _, descendant in ipairs(character:GetDescendants()) do
        if (descendant:IsA("BasePart") or descendant:IsA("Decal")) and descendant.Name ~= "HumanoidRootPart" then
            pcall(function() descendant.Transparency = transparency end)
        end
    end
end

function VD_SetInvisibleNotVisual(state)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not hum or not root or not torso then return end

    if state then
        if VD_InvisibleNV.Active then
            hum.WalkSpeed = VD.InvisibleSpeed or 16
            return
        end

        VD_InvisibleNV.Active = true
        VD_InvisibleNV.OriginalSpeed = hum.WalkSpeed
        local savedCFrame = root.CFrame

        char:MoveTo(VD_InvisibleNV.Position)
        task.wait(0.15)

        local seat = Instance.new("Seat")
        seat.Name = "KYS_InvisibleSeat"
        seat.Anchored = false
        seat.CanCollide = false
        seat.Transparency = 1
        seat.CFrame = CFrame.new(VD_InvisibleNV.Position)
        seat.Parent = Workspace

        local weld = Instance.new("Weld")
        weld.Part0 = seat
        weld.Part1 = torso
        weld.Parent = seat

        VD_InvisibleNV.Seat = seat
        VD_InvisibleNV.Weld = weld

        task.wait()
        seat.CFrame = savedCFrame
        VD_SetCharacterTransparency(char, 0.5)
        hum.WalkSpeed = VD.InvisibleSpeed or 16
    else
        VD.InvisibleNotVisual = false
        VD_InvisibleNV.Active = false
        if VD_InvisibleNV.Seat and VD_InvisibleNV.Seat.Parent then
            pcall(function() VD_InvisibleNV.Seat:Destroy() end)
        end
        VD_InvisibleNV.Seat = nil
        VD_InvisibleNV.Weld = nil
        VD_SetCharacterTransparency(char, 0)
        if VD_InvisibleNV.OriginalSpeed then
            hum.WalkSpeed = VD_InvisibleNV.OriginalSpeed
        end
        VD_InvisibleNV.OriginalSpeed = nil
    end
end

local VD_OriginalLungeBoost = nil
function VD_UpdateInfiniteLunge()
    local char = LocalPlayer.Character
    if not char then return end
    
    if VD.KILLER_InfLunge then
        if char:GetAttribute("lungeboost") ~= 999999 then
            VD_OriginalLungeBoost = char:GetAttribute("lungeboost") or 1
            char:SetAttribute("lungeboost", 999999)
        end
    else
        if VD_OriginalLungeBoost then
            char:SetAttribute("lungeboost", VD_OriginalLungeBoost)
            VD_OriginalLungeBoost = nil
        end
    end
end

function VD_UpdateInvisibleNotVisual()
    if not VD.InvisibleNotVisual then
        if VD_InvisibleNV.Active then VD_SetInvisibleNotVisual(false) end
        return
    end
    VD_SetInvisibleNotVisual(true)
end

local VD_MoonwalkState = {
    LastEnabled = false,
    Yaw = nil,
    Sway = 0,
    ButtonGui = nil,
    Button = nil,
    ButtonLabel = nil,
    SyncingUI = false,
}

function VD_RefreshMoonwalkButton()
    local btn = VD_MoonwalkState.Button
    if not (btn and btn.Parent) then return end
    btn.BackgroundColor3 = VD.Moonwalk and Color3.fromRGB(35, 185, 95) or Color3.fromRGB(20, 0, 30)
    local label = VD_MoonwalkState.ButtonLabel
    if label and label.Parent then
        label.Text = VD.Moonwalk and "ON" or "OFF"
        label.TextColor3 = VD.Moonwalk and Color3.fromRGB(190, 255, 210) or Color3.fromRGB(255, 255, 255)
    end
end

function VD_SetMoonwalk(state)
    VD.Moonwalk = state and true or false
    VD_RefreshMoonwalkButton()
end
getgenv().VD_SetMoonwalk = VD_SetMoonwalk

function VD_DestroyMoonwalkButton()
    if VD_MoonwalkState.ButtonGui then
        pcall(function() VD_MoonwalkState.ButtonGui:Destroy() end)
    end
    VD_MoonwalkState.ButtonGui = nil
    VD_MoonwalkState.Button = nil
    VD_MoonwalkState.ButtonLabel = nil
end

function VD_CreateMoonwalkButton()
    local parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
    if not parent then
        task.delay(1, VD_CreateMoonwalkButton)
        return
    end
    if VD_MoonwalkState.ButtonGui and VD_MoonwalkState.ButtonGui.Parent then
        VD_RefreshMoonwalkButton()
        return
    end

    local old = parent:FindFirstChild("KYS_MoonwalkButton")
    if old then pcall(function() old:Destroy() end) end

    local sg = Instance.new("ScreenGui")
    sg.Name = "KYS_MoonwalkButton"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999999
    sg.Parent = parent

    local btn = Instance.new("ImageButton")
    btn.Name = "MoonwalkButton"
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = UDim2.new(0.88, 0, 0.43, 0)
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(20, 0, 30)
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Visible = true
    btn.ZIndex = 10
    btn.Parent = sg
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.2

    local lbl = Instance.new("TextLabel", btn)
    lbl.Name = "StateLabel"
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "OFF"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    local function applyShine(obj, baseColor)
        local grad = Instance.new("UIGradient", obj)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, baseColor),
            ColorSequenceKeypoint.new(0.4, baseColor),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.6, baseColor),
            ColorSequenceKeypoint.new(1, baseColor)
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(-1, -1)

        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local ti = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
            local tw = TweenService:Create(grad, ti, { Offset = Vector2.new(1, 1) })
            tw:Play()
        end)
    end

    pcall(applyShine, btn, Color3.fromRGB(20, 0, 30))
    pcall(applyShine, lbl, Color3.fromRGB(255, 0, 255))
    pcall(applyShine, stroke, Color3.fromRGB(255, 0, 255))

    local dragging = false
    local dragStart, startPos
    local moved = false
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            moved = false
            if VD.MoonwalkButtonLocked then return end
            dragging = true
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
        if VD.MoonwalkButtonLocked then return end
        if not dragging or not dragStart or not startPos then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then moved = true end
        btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end)

    btn.MouseButton1Click:Connect(function()
        if moved and not VD.MoonwalkButtonLocked then return end
        moved = false
        VD_SetMoonwalk(not VD.Moonwalk)
    end)

    VD_MoonwalkState.ButtonGui = sg
    VD_MoonwalkState.Button = btn
    VD_MoonwalkState.ButtonLabel = lbl
    VD_RefreshMoonwalkButton()
end

function VD_SetMoonwalkButtonVisible(state)
    VD.MoonwalkButton = state and true or false
    local flagName = VD_To_Flag and VD_To_Flag.MoonwalkButton
    local elem = flagName and Window and Window.ConfigElements and Window.ConfigElements[flagName]
    if elem and elem.Set and not VD_MoonwalkState.SyncingUI then
        VD_MoonwalkState.SyncingUI = true
        pcall(function() elem:Set(VD.MoonwalkButton) end)
        VD_MoonwalkState.SyncingUI = false
    end

    if VD.MoonwalkButton then
        VD_CreateMoonwalkButton()
    else
        VD_SetMoonwalk(false)
        VD_DestroyMoonwalkButton()
    end
end
getgenv().VD_SetMoonwalkButtonVisible = VD_SetMoonwalkButtonVisible

task.spawn(function()
    while getgenv().VD and not getgenv().VD.Destroyed do
        if VD.MoonwalkButton and not (VD_MoonwalkState.ButtonGui and VD_MoonwalkState.ButtonGui.Parent) then
            pcall(VD_CreateMoonwalkButton)
        elseif VD.MoonwalkButton then
            VD_RefreshMoonwalkButton()
        elseif VD_MoonwalkState.ButtonGui then
            VD_DestroyMoonwalkButton()
        end
        task.wait(3)
    end
end)

-- =====================================================
-- AIM LOCK - External Toggle Button + Logic
-- =====================================================
do
local VD_AimLockState = {
    Active = false,
    CurrentTarget = nil,
    ButtonGui = nil,
    Button = nil,
    ButtonLabel = nil,
    SyncingUI = false,
}

local function VD_AimLock_IsSurvivor(p)
    return p.Team and p.Team.Name == "Survivors"
end

local function VD_AimLock_IsDowned(character)
    if not character then return true end
    if character:GetAttribute("Knocked") == true then return true end
    if character:GetAttribute("IsHooked") == true then return true end
    local hum = character:FindFirstChild("Humanoid")
    if hum and hum.Health <= 0 then return true end
    return false
end

local function VD_AimLock_GetClosest()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local maxDist = VD.AimLockMaxDistance or 50
    local bestTarget = nil
    local bestDistance = maxDist + 1

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer and otherPlayer.Character and VD_AimLock_IsSurvivor(otherPlayer) then
            if not VD_AimLock_IsDowned(otherPlayer.Character) then
                local otherHrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                local otherHum = otherPlayer.Character:FindFirstChild("Humanoid")

                if otherHrp and otherHum and otherHum.Health > 0 then
                    local distance = (otherHrp.Position - hrp.Position).Magnitude
                    if distance <= maxDist and distance < bestDistance then
                        bestDistance = distance
                        bestTarget = otherHrp
                    end
                end
            end
        end
    end

    return bestTarget
end

local function VD_RefreshAimLockButton()
    local btn = VD_AimLockState.Button
    if not (btn and btn.Parent) then return end
    btn.BackgroundColor3 = VD_AimLockState.Active and Color3.fromRGB(185, 50, 50) or Color3.fromRGB(20, 0, 30)
    local label = VD_AimLockState.ButtonLabel
    if label and label.Parent then
        label.Text = VD_AimLockState.Active and "ON" or "OFF"
        label.TextColor3 = VD_AimLockState.Active and Color3.fromRGB(255, 200, 200) or Color3.fromRGB(255, 255, 255)
    end
end

local function VD_SetAimLockActive(state)
    VD_AimLockState.Active = state and true or false
    if not VD_AimLockState.Active then
        VD_AimLockState.CurrentTarget = nil
    end
    VD_RefreshAimLockButton()
end
getgenv().VD_SetAimLockActive = VD_SetAimLockActive

local function VD_DestroyAimLockButton()
    if VD_AimLockState.ButtonGui then
        pcall(function() VD_AimLockState.ButtonGui:Destroy() end)
    end
    VD_AimLockState.ButtonGui = nil
    VD_AimLockState.Button = nil
    VD_AimLockState.ButtonLabel = nil
end

local function VD_CreateAimLockButton()
    local parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
    if not parent then
        task.delay(1, VD_CreateAimLockButton)
        return
    end
    if VD_AimLockState.ButtonGui and VD_AimLockState.ButtonGui.Parent then
        VD_RefreshAimLockButton()
        return
    end

    local old = parent:FindFirstChild("KYS_AimLockButton")
    if old then pcall(function() old:Destroy() end) end

    local sg = Instance.new("ScreenGui")
    sg.Name = "KYS_AimLockButton"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999998
    sg.Parent = parent

    local btn = Instance.new("ImageButton")
    btn.Name = "AimLockButton"
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = UDim2.new(0.88, 0, 0.55, 0)
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(20, 0, 30)
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Visible = true
    btn.ZIndex = 10
    btn.Parent = sg
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255, 70, 70)
    stroke.Thickness = 2
    stroke.Transparency = 0.2

    local lbl = Instance.new("TextLabel", btn)
    lbl.Name = "StateLabel"
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "OFF"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBlack
    lbl.ZIndex = 11

    local function applyShine(obj, baseColor)
        local grad = Instance.new("UIGradient", obj)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, baseColor),
            ColorSequenceKeypoint.new(0.4, baseColor),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.6, baseColor),
            ColorSequenceKeypoint.new(1, baseColor)
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(-1, -1)

        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local ti = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
            local tw = TweenService:Create(grad, ti, { Offset = Vector2.new(1, 1) })
            tw:Play()
        end)
    end

    pcall(applyShine, btn, Color3.fromRGB(20, 0, 30))
    pcall(applyShine, lbl, Color3.fromRGB(255, 50, 50))
    pcall(applyShine, stroke, Color3.fromRGB(255, 50, 50))

    local dragging = false
    local dragStart, startPos
    local moved = false
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            moved = false
            if VD.AimLockButtonLocked then return end
            dragging = true
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
        if VD.AimLockButtonLocked then return end
        if not dragging or not dragStart or not startPos then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then moved = true end
        btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end)

    btn.MouseButton1Click:Connect(function()
        if moved and not VD.AimLockButtonLocked then return end
        moved = false
        VD_SetAimLockActive(not VD_AimLockState.Active)
    end)

    VD_AimLockState.ButtonGui = sg
    VD_AimLockState.Button = btn
    VD_AimLockState.ButtonLabel = lbl
    VD_RefreshAimLockButton()
end

local function VD_SetAimLockButtonVisible(state)
    VD.AimLockButton = state and true or false
    local flagName = VD_To_Flag and VD_To_Flag.AimLockButton
    local elem = flagName and Window and Window.ConfigElements and Window.ConfigElements[flagName]
    if elem and elem.Set and not VD_AimLockState.SyncingUI then
        VD_AimLockState.SyncingUI = true
        pcall(function() elem:Set(VD.AimLockButton) end)
        VD_AimLockState.SyncingUI = false
    end

    if VD.AimLockButton then
        VD_CreateAimLockButton()
    else
        VD_SetAimLockActive(false)
        VD_DestroyAimLockButton()
    end
end
getgenv().VD_SetAimLockButtonVisible = VD_SetAimLockButtonVisible

-- Keybind B untuk toggle Aim Lock
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.B and VD.AimLockButton then
        VD_SetAimLockActive(not VD_AimLockState.Active)
    end
end)

-- Reset aim lock saat respawn
LocalPlayer.CharacterAdded:Connect(function()
    if VD_AimLockState.Active then
        VD_SetAimLockActive(false)
    end
    VD_AimLockState.CurrentTarget = nil
end)

-- Keep-alive loop untuk Aim Lock button
task.spawn(function()
    while getgenv().VD and not getgenv().VD.Destroyed do
        if VD.AimLockButton and not (VD_AimLockState.ButtonGui and VD_AimLockState.ButtonGui.Parent) then
            pcall(VD_CreateAimLockButton)
        elseif VD.AimLockButton then
            VD_RefreshAimLockButton()
        elseif VD_AimLockState.ButtonGui then
            VD_DestroyAimLockButton()
        end
        task.wait(3)
    end
end)

-- Aim Lock update setiap frame (RenderStepped)
RunService.RenderStepped:Connect(function()
    if not VD_AimLockState.Active or not VD.AimLockButton then
        VD_AimLockState.CurrentTarget = nil
        return
    end

    local targetPart = VD_AimLock_GetClosest()
    if not targetPart then
        VD_AimLockState.CurrentTarget = nil
        return
    end

    VD_AimLockState.CurrentTarget = targetPart
    pcall(function()
        local cam = Workspace.CurrentCamera
        cam.CFrame = CFrame.new(cam.CFrame.Position, targetPart.Position)
    end)
end)
end -- end AimLock scope

function VD_UpdateMoonwalk(deltaTime)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local cam = Workspace.CurrentCamera

    if VD.Moonwalk ~= VD_MoonwalkState.LastEnabled then
        if hum then hum.AutoRotate = not VD.Moonwalk end
        VD_MoonwalkState.LastEnabled = VD.Moonwalk
        if VD.Moonwalk and root then
            local _, y = root.CFrame:ToEulerAnglesYXZ()
            VD_MoonwalkState.Yaw = math.deg(y)
        end
    end

    if not VD.Moonwalk then
        return
    end
    if not root or not hum or not cam or hum.Health <= 0 then return end

    hum.AutoRotate = false
    local look = cam.CFrame.LookVector
    local targetYaw = math.deg(math.atan2(look.X, look.Z)) + 180
    local currentYaw = VD_MoonwalkState.Yaw or targetYaw
    local diff = (targetYaw - currentYaw + 180) % 360 - 180
    local lerpSpeed = 0.22 * math.clamp((deltaTime or 1 / 60) * 60, 0, 3)
    currentYaw = currentYaw + diff * lerpSpeed
    VD_MoonwalkState.Yaw = currentYaw

    local moving = hum.MoveDirection.Magnitude > 0.01
    local targetSway = 0
    if moving then
        targetSway = math.sin(tick() * (VD.MoonwalkZigzagSpeed or 11)) * 48
    end
    VD_MoonwalkState.Sway = (VD_MoonwalkState.Sway or 0) + (targetSway - (VD_MoonwalkState.Sway or 0)) * 0.38
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(currentYaw + VD_MoonwalkState.Sway), 0)

    if moving then
        hum:Move(hum.MoveDirection * (VD.MoonwalkBoostPower or 1.08), false)
    end
end

LocalPlayer.CharacterRemoving:Connect(function()
    if VD_InvisibleNV.Seat and VD_InvisibleNV.Seat.Parent then
        pcall(function() VD_InvisibleNV.Seat:Destroy() end)
    end
    VD_InvisibleNV.Active = false
    VD_InvisibleNV.Seat = nil
    VD_InvisibleNV.Weld = nil
    VD_MoonwalkState.LastEnabled = false
    VD_MoonwalkState.Yaw = nil
    VD_MoonwalkState.Sway = 0
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if VD.InvisibleNotVisual then pcall(VD_SetInvisibleNotVisual, true) end
end)

local VD_PalletwrongConnection = nil
local VD_PalletwrongScanning = false

function VD_DestroyPalletwrong(inst)
    if inst and inst:IsA("Model") and inst.Name == "Palletwrong" then
        pcall(function() inst:Destroy() end)
    end
end

function VD_StartRemovePalletwrong()
    if VD_PalletwrongConnection then return end

    VD_PalletwrongConnection = Workspace.DescendantAdded:Connect(function(inst)
        if VD.KILLER_NoPalletStun then
            VD_DestroyPalletwrong(inst)
        end
    end)

    if VD_PalletwrongScanning then return end
    VD_PalletwrongScanning = true
    task.spawn(function()
        local descendants = Workspace:GetDescendants()
        for i, inst in ipairs(descendants) do
            if not VD.KILLER_NoPalletStun then break end
            VD_DestroyPalletwrong(inst)
            if i % 250 == 0 then task.wait() end
        end
        VD_PalletwrongScanning = false
    end)
end

function VD_StopRemovePalletwrong()
    if VD_PalletwrongConnection then
        pcall(function() VD_PalletwrongConnection:Disconnect() end)
        VD_PalletwrongConnection = nil
    end
    VD_PalletwrongScanning = false
end

function VD_UpdateRemovePalletwrong()
    if VD.KILLER_NoPalletStun then
        VD_StartRemovePalletwrong()
    else
        VD_StopRemovePalletwrong()
    end
end

do
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if not VD.AntiAFK then return end
        pcall(function()
            vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            task.wait(0.2)
            vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        end)
    end)
end

-- =====================================================
-- MAP CACHE (Generators / Gates / Hooks / Pallets / Windows)
-- =====================================================
local KYS_Cache = {
    Generators  = {},
    Gates       = {},
    Hooks       = {},
    Pallets     = {},
    Windows     = {},
    ClosestHook = nil,
    ExitPos     = nil
}

function KYS_ScanMap()
    local map = Workspace:FindFirstChild("Map")
    if not map then
        KYS_Cache = {
            Generators = {}, Zombies = {}, Gates = {}, Hooks = {}, Pallets = {}, Windows = {}, ClosestHook = nil, ExitPos = nil, ExitPart = nil
        }
        return
    end

    local newGens, newZombies, newGates, newHooks, newPallets, newWindows = {}, {}, {}, {}, {}, {}
    local exitPos = nil
    local exitPart = nil

    if map:FindFirstChild("churchbell") then
        exitPart = map:FindFirstChild("churchbell")
        if exitPart:IsA("Model") then exitPart = exitPart.PrimaryPart or exitPart:FindFirstChildWhichIsA("BasePart") end
        if exitPart then exitPos = exitPart.Position else exitPos = Vector3.new(760.98, -20.14, -78.48) end
    end

    local finish = map:FindFirstChild("Finishline") or map:FindFirstChild("FinishLine") or map:FindFirstChild("Fininshline")
    if finish then
        local fp = finish:IsA("BasePart") and finish or (finish:IsA("Model") and finish:FindFirstChildWhichIsA("BasePart"))
        if fp then exitPos = fp.Position; exitPart = fp end
    end

    for _, obj in ipairs(map:GetDescendants()) do
        if obj:IsA("Model") then
            local part = obj:FindFirstChild("HitBox", true) or obj:FindFirstChild("GeneratorPoint", true) or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
            if part then
                local n = obj.Name
                if n == "Generator" then
                    table.insert(newGens, { model = obj, part = part })
                elseif n == "Gate" or n == "ExitGate" or obj:FindFirstChild("ExitLever") then
                    table.insert(newGates, { model = obj, part = part })
                elseif n == "Hook" then
                    table.insert(newHooks, { model = obj, part = part })
                elseif n == "Palletwrong" or n:lower():find("pallet") then
                    table.insert(newPallets, { model = obj, part = part })
                elseif n == "Window" then
                    table.insert(newWindows, { model = obj, part = part })
                end
            end
        elseif obj:IsA("BasePart") then
            if not exitPos and obj.Name:lower():find("finish") then
                exitPos = obj.Position
                exitPart = obj
            end
            if not exitPos and obj:IsA("MeshPart") then
                if obj.Material == Enum.Material.Limestone then
                    exitPos = Vector3.new(-947.90, 152.12, -7579.52)
                    exitPart = obj
                elseif obj.Material == Enum.Material.Leather then
                    exitPos = Vector3.new(1546.12, 152.21, -796.72)
                    exitPart = obj
                end
            end
            -- Tambahkan VaultTrigger ke cache window jika ditemukan
            if obj.Name == "VaultTrigger" then
                table.insert(newWindows, { model = obj.Parent, part = obj })
            end
            -- Tambahkan VaultPoint di dalam VaultTrigger (untuk path workspace.Map.Vaults:GetChildren()[4]:GetChildren()[2].VaultPoint)
            if obj.Name == "VaultPoint" and obj.Parent and obj.Parent.Name == "VaultTrigger" then
                table.insert(newWindows, { model = obj.Parent, part = obj })
            end
            -- Tambahkan PalletPoint dan PalletPointSlide ke cache pallet
            -- Spy confirmed: server menerima PalletPointSlide sebagai target drop
            if obj.Name == "PalletPoint" or obj.Name == "PalletPointSlide" then
                table.insert(newPallets, { model = obj.Parent, part = obj })
            end
        end
    end

    KYS_Cache.Generators = newGens
    KYS_Cache.Gates      = newGates
    KYS_Cache.Hooks      = newHooks
    KYS_Cache.Pallets    = newPallets
    KYS_Cache.Windows    = newWindows
    KYS_Cache.ExitPos    = exitPos
    KYS_Cache.ExitPart   = exitPart
    print("[KYS ScanMap] Generators:", #newGens, "Gates:", #newGates, "Hooks:", #newHooks, "Windows:", #newWindows)

    local root           = Root
    if root and #KYS_Cache.Hooks > 0 then
        local closest, closestDist = nil, math.huge
        for _, hook in ipairs(KYS_Cache.Hooks) do
            if hook.part then
                local d = (hook.part.Position - root.Position).Magnitude
                if d < closestDist then
                    closestDist = d; closest = hook
                end
            end
        end
        KYS_Cache.ClosestHook = closest
    end
end

-- =====================================================
-- RADAR SYSTEM
-- =====================================================
local radarGui = nil
local radarFrame = nil
local radarDots = {}
local radarObjectDots = {}

local RADAR_COLORS = {
    Killer = Color3.fromRGB(255, 0, 0), -- Merah untuk Killer
    Survivor = Color3.fromRGB(255, 165, 0), -- Oranye untuk Survivor (tim)
    Generator = Color3.fromRGB(255, 140, 0),
    Gate = Color3.fromRGB(100, 200, 255),
    Pallet = Color3.fromRGB(53, 189, 166),
    Hook = Color3.fromRGB(252, 116, 116),
    Window = Color3.fromRGB(80, 160, 255),
    Zombie = Color3.fromRGB(150, 255, 50)
}

local MaskColors = {
    Abysswalker = Color3.fromRGB(110, 20, 255),
    Cure = Color3.fromRGB(0, 100, 255),
    Hidden = Color3.fromRGB(170, 170, 170),
    Killer = Color3.fromRGB(255, 40, 40),
    Masked = Color3.fromRGB(255, 90, 20),
    Stalker = Color3.fromRGB(255, 0, 140),
    Veil = Color3.fromRGB(0, 200, 255),
    Slasher = Color3.fromRGB(180, 0, 255),
}

function GetKillerColorForRadar(killerPlayer)
    return RADAR_COLORS.Killer -- Selalu merah sesuai permintaan
end

function CreateRadarGUI()
    local parent = GetSafeGuiParent()
    if not parent then return false end
    
    if radarGui then pcall(function() radarGui:Destroy() end) end
    
    radarGui = Instance.new("ScreenGui")
    radarGui.Name = "KysHub_RadarGUI"
    radarGui.ResetOnSpawn = false
    radarGui.IgnoreGuiInset = true
    radarGui.Parent = parent
    
    radarFrame = Instance.new("Frame")
    radarFrame.Name = "RadarFrame"
    radarFrame.Size = UDim2.new(0, VD.RADAR_Size, 0, VD.RADAR_Size)
    radarFrame.Position = UDim2.new(0, 10, 0, 120)
    radarFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    radarFrame.BackgroundTransparency = 1 - VD.RADAR_Transparency
    radarFrame.BorderSizePixel = 0
    radarFrame.Active = true
    radarFrame.Draggable = true
    radarFrame.Parent = radarGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = VD.RADAR_Circle and UDim.new(1, 0) or UDim.new(0, 8)
    corner.Parent = radarFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 2
    stroke.Parent = radarFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, 0, 0, 20)
    titleText.BackgroundTransparency = 1
    titleText.Text = "KysHub RADAR"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.Font = Enum.Font.SourceSansBold
    titleText.TextSize = 12
    titleText.Parent = radarFrame
    
    local crossH = Instance.new("Frame")
    crossH.Size = UDim2.new(1, -40, 0, 1)
    crossH.Position = UDim2.new(0, 20, 0.5, 0)
    crossH.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    crossH.BorderSizePixel = 0
    crossH.Parent = radarFrame
    
    local crossV = Instance.new("Frame")
    crossV.Size = UDim2.new(0, 1, 1, -40)
    crossV.Position = UDim2.new(0.5, 0, 0, 20)
    crossV.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    crossV.BorderSizePixel = 0
    crossV.Parent = radarFrame
    
    local centerDot = Instance.new("Frame")
    centerDot.Size = UDim2.new(0, 8, 0, 8)
    centerDot.Position = UDim2.new(0.5, -4, 0.5, -4)
    centerDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Hijau untuk kita
    centerDot.BorderSizePixel = 0
    centerDot.Parent = radarFrame
    
    local centerCorner = Instance.new("UICorner")
    centerCorner.CornerRadius = UDim.new(1, 0)
    centerCorner.Parent = centerDot
    
    local rangeText = Instance.new("TextLabel")
    rangeText.Name = "RangeText"
    rangeText.Size = UDim2.new(1, 0, 0, 14)
    rangeText.Position = UDim2.new(0, 0, 1, -14)
    rangeText.BackgroundTransparency = 1
    rangeText.Text = "Range: ".. VD.RADAR_Range.. "m"
    rangeText.TextColor3 = Color3.fromRGB(200, 200, 200)
    rangeText.Font = Enum.Font.SourceSans
    rangeText.TextSize = 10
    rangeText.Parent = radarFrame
    
    radarDots = {}
    for i = 1, 30 do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
        dot.BorderSizePixel = 0
        dot.Visible = false
        dot.Parent = radarFrame
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot
        table.insert(radarDots, dot)
    end
    
    radarObjectDots = {}
    for i = 1, 80 do
        local objDot = Instance.new("Frame")
        objDot.Size = UDim2.new(0, 4, 0, 4)
        objDot.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
        objDot.BorderSizePixel = 0
        objDot.Visible = false
        objDot.Parent = radarFrame
        local objCorner = Instance.new("UICorner")
        objCorner.CornerRadius = UDim.new(1, 0)
        objCorner.Parent = objDot
        table.insert(radarObjectDots, objDot)
    end
    
    return true
end

function UpdateRadar()
    if not VD.RADAR_Enabled then
        if radarGui then radarGui.Enabled = false end
        return
    end
    
    if not radarGui or not radarFrame or not radarGui.Parent then
        if not CreateRadarGUI() then return end
    end
    
    radarGui.Enabled = true
    radarFrame.Visible = true
    
    local camera = workspace.CurrentCamera
    local root = Root or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
    if not camera or not root then return end
    
    radarFrame.Size = UDim2.new(0, VD.RADAR_Size, 0, VD.RADAR_Size)
    radarFrame.BackgroundTransparency = 1 - VD.RADAR_Transparency
    
    local corner = radarFrame:FindFirstChildOfClass("UICorner")
    if corner then
        corner.CornerRadius = VD.RADAR_Circle and UDim.new(1, 0) or UDim.new(0, 8)
    end
    
    local rangeText = radarFrame:FindFirstChild("RangeText")
    if rangeText then rangeText.Text = "Range: ".. VD.RADAR_Range.. "m" end
    
    for _, dot in ipairs(radarDots) do dot.Visible = false end
    for _, dot in ipairs(radarObjectDots) do dot.Visible = false end
    
    local halfSize = VD.RADAR_Size / 2
    local margin = 5
    local usableHalf = halfSize - margin
    local scale = usableHalf / VD.RADAR_Range
    
    local cameraLook = camera.CFrame.LookVector
    local playerAngle = math.atan2(-cameraLook.X, -cameraLook.Z)
    local cosAngle = math.cos(playerAngle)
    local sinAngle = math.sin(playerAngle)
    local playerPos = root.Position
    
    local function WorldToRadar(worldPos)
        local deltaX = worldPos.X - playerPos.X
        local deltaZ = worldPos.Z - playerPos.Z
        local distance = math.sqrt(deltaX * deltaX + deltaZ * deltaZ)
        if distance > VD.RADAR_Range then return nil end
        
        local rotatedX = deltaX * cosAngle - deltaZ * sinAngle
        local rotatedZ = deltaX * sinAngle + deltaZ * cosAngle
        local radarX = rotatedX * scale
        local radarY = rotatedZ * scale
        local clampedX = math.clamp(radarX, -usableHalf + 4, usableHalf - 4)
        local clampedY = math.clamp(radarY, -usableHalf + 4, usableHalf - 4)
        return Vector2.new(halfSize + clampedX, halfSize + clampedY)
    end
    
    local dotIndex = 1
    local objIndex = 1
    local drawnPlayers = {}
    local drawnObjects = {}
    
    local function AddObjectDot(pos, color, size, identifier)
        if not pos or drawnObjects[identifier] then return end
        drawnObjects[identifier] = true
        if objIndex <= #radarObjectDots then
            local dot = radarObjectDots[objIndex]
            dot.Size = UDim2.new(0, size, 0, size)
            dot.Position = UDim2.new(0, pos.X - (size/2), 0, pos.Y - (size/2))
            dot.BackgroundColor3 = color
            dot.Visible = true
            objIndex = objIndex + 1
        end
    end
    
    -- Player dots
    if VD.RADAR_ShowKiller or VD.RADAR_ShowSurvivor then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if playerRoot then
                    local isKiller = IsKiller(player)
                    local shouldShow = (isKiller and VD.RADAR_ShowKiller) or (not isKiller and VD.RADAR_ShowSurvivor)
                    if shouldShow and not drawnPlayers[player.UserId] then
                        local pos = WorldToRadar(playerRoot.Position)
                        if pos and dotIndex <= #radarDots then
                            drawnPlayers[player.UserId] = true
                            local dot = radarDots[dotIndex]
                            if isKiller then
                                dot.Size = UDim2.new(0, 7, 0, 7)
                                dot.Position = UDim2.new(0, pos.X - 3.5, 0, pos.Y - 3.5)
                                dot.BackgroundColor3 = GetKillerColorForRadar(player)
                            else
                                dot.Size = UDim2.new(0, 6, 0, 6)
                                dot.Position = UDim2.new(0, pos.X - 3, 0, pos.Y - 3)
                                dot.BackgroundColor3 = RADAR_COLORS.Survivor -- Oranye untuk Survivor (tim)
                            end
                            dot.Visible = true
                            dotIndex = dotIndex + 1
                        end
                    end
                end
            end
        end
    end
    
    -- Generator dots
    if VD.RADAR_ShowGenerator then
        for _, gen in ipairs(KYS_Cache.Generators or {}) do
            if gen.model and gen.model.Parent and gen.part then
                local pos = WorldToRadar(gen.part.Position)
                if pos then AddObjectDot(pos, RADAR_COLORS.Generator, 5, "gen_" .. tostring(gen.model)) end
            end
        end
    end
    
    -- Pallet dots
    if VD.RADAR_ShowPallet then
        for _, pallet in ipairs(KYS_Cache.Pallets or {}) do
            if pallet.model and pallet.model.Parent and pallet.part then
                local isBroken = false
                local ok, db = pcall(function() return pallet.model:GetAttribute("Destroyed") or pallet.model:GetAttribute("Broken") or pallet.model:GetAttribute("IsBroken") end)
                if ok and db then isBroken = true end
                if not isBroken and not pallet.model:FindFirstChildWhichIsA("BasePart", true) then
                    isBroken = true
                end
                if not isBroken then
                    local pos = WorldToRadar(pallet.part.Position)
                    if pos then AddObjectDot(pos, RADAR_COLORS.Pallet, 4, "pallet_" .. tostring(pallet.model)) end
                end
            end
        end
    end
    
    -- Hook dots
    if VD.RADAR_ShowHook then
        for _, hook in ipairs(KYS_Cache.Hooks or {}) do
            if hook.model and hook.model.Parent and hook.part then
                local pos = WorldToRadar(hook.part.Position)
                if pos then AddObjectDot(pos, RADAR_COLORS.Hook, 5, "hook_" .. tostring(hook.model)) end
            end
        end
    end
    
    -- Gate dots
    if VD.RADAR_ShowGate then
        for _, gate in ipairs(KYS_Cache.Gates or {}) do
            if gate.model and gate.model.Parent and gate.part then
                local pos = WorldToRadar(gate.part.Position)
                if pos then AddObjectDot(pos, RADAR_COLORS.Gate, 5, "gate_" .. tostring(gate.model)) end
            end
        end
    end
    
    -- Window dots
    if VD.RADAR_ShowWindow then
        for _, window in ipairs(KYS_Cache.Windows or {}) do
            if window.model and window.model.Parent and window.part then
                local pos = WorldToRadar(window.part.Position)
                if pos then AddObjectDot(pos, RADAR_COLORS.Window, 4, "window_" .. tostring(window.model)) end
            end
        end
    end
    
    -- Zombie/SCP dots
    if VD.RADAR_ShowZombie then
        if KYS_WorldReg and KYS_WorldReg.SCPZombie then
            for model, entry in pairs(KYS_WorldReg.SCPZombie) do
                if model and model.Parent then
                    local refPart = model:FindFirstChild("HumanoidRootPart") or (entry and entry.part) or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                    if refPart then
                        local pos = WorldToRadar(refPart.Position)
                        if pos then AddObjectDot(pos, RADAR_COLORS.Zombie, 5, "zombie_" .. tostring(model)) end
                    end
                end
            end
        end
    end
end

-- =====================================================
-- TELEPORT HELPERS
-- =====================================================
local originalCanCollide = {}

function KYS_TeleportToPosition(pos)
    if not pos then return false end
    local root = Root
    if not root then return false end

    if LocalPlayer.Character then
        root.Anchored = true -- Tahan agar tidak jatuh ke luar map saat CanCollide mati
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                if originalCanCollide[part] == nil then originalCanCollide[part] = part.CanCollide end
                part.CanCollide = false
            end
        end
    end

    root.CFrame = CFrame.new(pos + Vector3.new(0, VD.TP_Offset, 0))

    task.delay(0.3, function()
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    pcall(function()
                        part.CanCollide = (originalCanCollide[part] ~= nil) and originalCanCollide[part] or true
                    end)
                end
            end
            root.Anchored = false -- Lepas tahanan setelah collision aktif
        end
        originalCanCollide = {}
    end)
    return true
end

function KYS_TeleportToGenerator(index)
    if not KYS_Cache or not KYS_Cache.Generators or #KYS_Cache.Generators == 0 then print("[KYS HUB] Generator tidak ditemukan") return false end

    local sorted = {}
    for _, gen in ipairs(KYS_Cache.Generators) do
        table.insert(sorted, {gen = gen, dist = (Root and (gen.part.Position - Root.Position).Magnitude) or math.huge})
    end
    table.sort(sorted, function(a, b) return a.dist < b.dist end)

    local target = sorted[index or 1]
    if not target then return false end
    return KYS_TeleportToPosition(target.gen.part.Position)
end

function KYS_TeleportToGate()
    if not KYS_Cache or not KYS_Cache.Gates or #KYS_Cache.Gates == 0 then print("[KYS HUB] Gate tidak ditemukan") return false end
    local closest, closestDist = nil, math.huge
    for _, gate in ipairs(KYS_Cache.Gates) do
        local dist = (Root and (gate.part.Position - Root.Position).Magnitude) or math.huge
        if dist < closestDist then
            closestDist = dist
            closest = gate
        end
    end

    if not closest then return false end
    return KYS_TeleportToPosition(closest.part.Position)
end

function KYS_TeleportToHook()
    if not KYS_Cache or not KYS_Cache.ClosestHook then print("[KYS HUB] Hook tidak ditemukan") return false end
    return KYS_TeleportToPosition(KYS_Cache.ClosestHook.part.Position)
end

-- MAP CHANGE DETECTION
local CurrentMapName = nil
local MapWatchConnections = {}
local MapScanQueued       = false

function DisconnectMapWatchers()
    for _, conn in ipairs(MapWatchConnections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    MapWatchConnections = {}
end

function CheckMapChange()
    local map = Workspace:FindFirstChild("Map")
    local mapName = map and map.Name or "Unknown"
    if CurrentMapName ~= mapName then
        -- print("[KYS HUB] Map berubah: " .. tostring(CurrentMapName) .. " -> " .. mapName)
        VD._BeatSurvivorDone = false
        VD._BeatKillerDone = false
        VD._LastTeleAway = 0
        VD._KillerTarget = nil
    end
    CurrentMapName = mapName

    KYS_ScanMap()
end

function QueueMapScan(delaySec)
    if MapScanQueued then return end
    MapScanQueued = true
    task.delay(delaySec or 0.15, function()
        MapScanQueued = false
        if VD.Destroyed then return end
        CheckMapChange()
    end)
end

function WatchCurrentMap(map)
    DisconnectMapWatchers()
    if not map then return end

    local function onDescendantAdded(descendant)
        if descendant:IsA("Model") or descendant:IsA("Folder") then
            local n = descendant.Name:lower()
            if n:find("generator") or n:find("mesin") or n:find("pallet") or n:find("window") or n:find("hook") or n:find("gate") then
                task.delay(0.5, function()
                    if not descendant.Parent then return end
                    local part = descendant:FindFirstChild("HitBox", true) or descendant:FindFirstChild("GeneratorPoint", true) or descendant.PrimaryPart or descendant:FindFirstChildWhichIsA("BasePart", true)
                    if part then
                        if n:find("generator") or n:find("mesin") then table.insert(KYS_Cache.Generators, {model=descendant, part=part})
                        elseif n:find("pallet") then table.insert(KYS_Cache.Pallets, {model=descendant, part=part})
                        elseif n:find("window") then table.insert(KYS_Cache.Windows, {model=descendant, part=part})
                        elseif n:find("hook") then table.insert(KYS_Cache.Hooks, {model=descendant, part=part})
                        elseif n:find("gate") then table.insert(KYS_Cache.Gates, {model=descendant, part=part})
                        end
                    end
                end)
            end
        end
    end

    table.insert(MapWatchConnections, map.DescendantAdded:Connect(onDescendantAdded))

    table.insert(MapWatchConnections, map.AncestryChanged:Connect(function(_, parent)
        if not parent then QueueMapScan(0.05) end
    end))
end

Workspace.ChildAdded:Connect(function(child)
    if child and child.Name == "Map" then
        WatchCurrentMap(child)
        QueueMapScan(0.05)
    end
    
    if child and child.Name == "Spearprojectile" and VD.SURV_AutoDodgeSpear and GetRole() == "Survivor" then
        task.spawn(function()
            if getgenv().KYS_IsDodging then return end
            
            local root = Root
            if not root then return end
            
            -- Biarkan projectile inisialisasi arahnya beberapa frame
            task.wait(0.05)
            
            -- Cari part fisiknya (Hitbox atau Spear1)
            -- Cari part fisiknya
            local mainPart = child:WaitForChild("Hitbox", 1) or child:WaitForChild("Spear1", 1) or child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
            if not mainPart then return end
            
            -- Biarkan posisinya set set dulu oleh gamenya (1 frame)
            task.wait()
            
            local originPos = mainPart.Position
            -- Berdasarkan bedah module game, Spear diputar CFrame.Angles(-math.pi/2, 0, 0)
            -- Ini membuat UpVector (Y) berubah menjadi arah lintasan (LookVector/Z).
            local spearDir = mainPart.CFrame.UpVector
            
            local toPlayer = (root.Position - originPos).Unit
            local dot = spearDir:Dot(toPlayer)
            
            -- Jika dot mendekati 1, tombak mengarah sangat dekat ke kita
            if dot > 0.85 then 
                if dot > 0.85 then -- Sudut cukup sempit, berbahaya!
                    getgenv().KYS_IsDodging = true
                    
                    local originalCFrame = root.CFrame
                    
                    -- Teleport ke samping sejauh 8 stud
                    local rightVector = root.CFrame.RightVector
                    root.CFrame = root.CFrame + (rightVector * 8)
                    
                    pcall(VD_Notify, "Auto Dodge", "Spear terdeteksi! Menghindar otomatis...", 2)
                    
                    -- Tunggu 1 detik lalu balik ke posisi awal
                    task.wait(1)
                    
                    if Root then
                        Root.CFrame = originalCFrame
                    end
                    
                    getgenv().KYS_IsDodging = false
                end
            end
        end)
    end
end)

Workspace.ChildRemoved:Connect(function(child)
    if child and child.Name == "Map" then
        DisconnectMapWatchers()
        QueueMapScan(0.05)
    end
end)

do
    local map = Workspace:FindFirstChild("Map")
    if map then WatchCurrentMap(map) end
    CheckMapChange()
end

-- =====================================================
-- AUTO ATTACK (Killer)
-- =====================================================
do -- begin Auto Features scope
local function KYS_AutoAttack()
    if not VD.AUTO_Attack or GetRole() ~= "Killer" then return end
    local root = Root
    if not root then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local tRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local tHum = player.Character:FindFirstChildOfClass("Humanoid")

            if tRoot and tHum and tHum.MaxHealth > 0 then
                local pct = tHum.Health / tHum.MaxHealth
                if pct > 0.25 and (tRoot.Position - root.Position).Magnitude <= VD.AUTO_AttackRange then
                    pcall(function()
                        local r = ReplicatedStorage:FindFirstChild("Remotes")
                        local a = r and r:FindFirstChild("Attacks")
                        local b = a and a:FindFirstChild("BasicAttack")
                        if b then b:FireServer(false) end
                    end)
                    break
                end
            end
        end
    end
end

-- =====================================================
-- AUTO VAULT (Survivor) - otomatis saat dekat Window
-- =====================================================
-- Lacak window yang sudah di-vault agar tidak loop terus
local _vaultedWindows  = {}  -- [rootWindow] = lastTime
local _lastVaultScan   = 0

RunService.Heartbeat:Connect(function()
    if VD.SURV_FastVault then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                char:SetAttribute("vaultspeed", (VD.SURV_VaultSpeed or 13) / 10)
            end
        end)
    end
    
    if VD.SURV_FleeKiller then
        pcall(function()
            local root = Root
            if not root then return end
            if GetRole() == "Killer" then return end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and IsKiller(player) then
                    local killerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if killerRoot and (killerRoot.Position - root.Position).Magnitude <= (VD.SURV_FleeDistance or 40) then
                        local direction = (root.Position - killerRoot.Position).Unit
                        root.CFrame = CFrame.new(root.Position + direction * ((VD.SURV_FleeDistance or 40) + 15), root.Position + direction * 100)
                        break
                    end
                end
            end
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    if not VD.SURV_AutoVault then return end
    if GetRole() ~= "Survivor" then return end
    if tick() - _lastVaultScan < 0.15 then return end  -- cek 6-7x per detik
    _lastVaultScan = tick()

    pcall(function()
        local char   = LocalPlayer.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        local hum    = char and char:FindFirstChildOfClass("Humanoid")
        if not myRoot or not hum or hum.Health <= 0 then return end

        -- Hanya vault kalau sedang bergerak (kecepatan > 1)
        local vel = myRoot.AssemblyLinearVelocity
        if vel.Magnitude < 1 then return end

        local remotes   = ReplicatedStorage:FindFirstChild("Remotes")
        local winFolder = remotes and remotes:FindFirstChild("Window")
        local vaultEv   = winFolder and winFolder:FindFirstChild("VaultCommit")
        if not vaultEv then return end

        -- Kelompokkan part vault per window secara akurat
        local windowGroups = {}
        for _, win in ipairs(KYS_Cache.Windows or {}) do
            local part = win.part or win.model
            if part then
                local rootWindow = part.Parent
                -- Jika part adalah VaultPoint, root windownya adalah parent dari VaultTrigger
                if part.Name == "VaultPoint" and part.Parent and part.Parent.Name == "VaultTrigger" then
                    rootWindow = part.Parent.Parent
                elseif part.Name == "VaultTrigger" and part.Parent then
                    rootWindow = part.Parent
                end

                if rootWindow then
                    windowGroups[rootWindow] = windowGroups[rootWindow] or {}
                    -- Hindari duplikasi
                    local exists = false
                    for _, p in ipairs(windowGroups[rootWindow]) do
                        if p == part then exists = true break end
                    end
                    if not exists then
                        table.insert(windowGroups[rootWindow], part)
                    end
                end
            end
        end

        -- Untuk setiap group window, cek jika player dekat salah satu part
        for rootWindow, parts in pairs(windowGroups) do

            -- Kumpulkan SEMUA VaultTrigger dari rootWindow secara langsung.
            -- Dikonfirmasi dari remote spy:
            --   Aâ†’B pakai VaultTrigger ke-2 (GetChildren()[4])
            --   Bâ†’A pakai VaultTrigger pertama (.VaultTrigger = FindFirstChild)
            -- Arah ditentukan dari VaultTrigger MANA yang dikirim, bukan posisi player.
            -- VaultTrigger terdekat dengan player = sisi yang sama = trigger yang benar.
            local function getVTPosition(vt)
                if vt:IsA("BasePart") then
                    return vt.Position
                end
                -- Jika Model, ambil dari PrimaryPart atau BasePart pertama
                if vt:IsA("Model") then
                    if vt.PrimaryPart then return vt.PrimaryPart.Position end
                    local bp = vt:FindFirstChildWhichIsA("BasePart", true)
                    if bp then return bp.Position end
                end
                return nil
            end

            local allVTs = {}
            for _, child in ipairs(rootWindow:GetChildren()) do
                if child.Name == "VaultTrigger" then
                    table.insert(allVTs, child)
                end
            end

            -- Jika tidak ada VaultTrigger di rootWindow, skip window ini
            if #allVTs == 0 then continue end

            -- Cari VaultTrigger TERDEKAT dengan player (= trigger sisi yang sama = benar)
            local nearestVT, nearestVTDist = nil, math.huge
            for _, vt in ipairs(allVTs) do
                local pos = getVTPosition(vt)
                if pos then
                    local d = (myRoot.Position - pos).Magnitude
                    if d < nearestVTDist then
                        nearestVTDist = d
                        nearestVT = vt
                    end
                end
            end

            -- Player harus dalam radius 6.0 studs dari VaultTrigger terdekat
            if not nearestVT or nearestVTDist > 6.0 then continue end

            -- Cek cooldown per-rootWindow (3.0s)
            local lastUsed = _vaultedWindows[rootWindow] or 0
            if tick() - lastUsed < 3.0 then continue end

            -- finalTarget = VaultTrigger terdekat (sesuai sisi player)
            local finalTarget = nearestVT

            local remotes2 = ReplicatedStorage:FindFirstChild("Remotes")
            local winFold  = remotes2 and remotes2:FindFirstChild("Window")
            if winFold and finalTarget then
                local vaultEvent     = winFold:FindFirstChild("VaultEvent")
                local vaultBindable  = winFold:FindFirstChild("Vaultbindable")
                local fastvault      = winFold:FindFirstChild("fastvault")
                local vaultComplete1 = winFold:FindFirstChild("VaultCompleteEventpart1")
                local vaultComplete  = winFold:FindFirstChild("VaultCompleteEvent")

                -- Sesuai spy: VaultEvent(nearestVT, true) â†’ fastvault â†’ Complete1 â†’ CompleteEvent(nearestVT, false)
                if vaultEvent    then pcall(function() vaultEvent:FireServer(finalTarget, true) end) end
                if vaultBindable then pcall(function() vaultBindable:Fire(finalTarget, true) end) end
                if fastvault     then pcall(function() fastvault:FireServer(LocalPlayer) end) end
                if vaultComplete1 then pcall(function() vaultComplete1:FireServer() end) end
                if vaultComplete  then pcall(function() vaultComplete:FireServer(finalTarget, false) end) end
            end

            _vaultedWindows[rootWindow] = tick()
            break
        end

    end)
end)

-- =====================================================
-- AUTO PALLET DROP (Survivor) - otomatis saat killer dekat
-- =====================================================
-- Spy confirmed: PalletDropEvent:FireServer(PalletPointSlide)
-- Hanya 1 event yang perlu dikirim (bukan Commit/Anim)
-- Pallet ada di workspace.Map.Rooftop â†’ scan scope diperluas
local _lastPalletDrop  = 0
local _usedPallets     = {}  -- [palletwrong model] = true

local function getKillerRoot()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if IsSurvivor and IsSurvivor(plr) then continue end
        local char = plr.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then return root end
        end
    end
    return nil
end

local _lastPalletScan = 0
RunService.Heartbeat:Connect(function()
    if not VD.SURV_AutoPallet then return end
    if GetRole() ~= "Survivor" then return end
    if tick() - _lastPalletScan < 0.2 then return end
    _lastPalletScan = tick()
    if tick() - _lastPalletDrop < 2.5 then return end

    pcall(function()
        local char   = LocalPlayer.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        local hum    = char and char:FindFirstChildOfClass("Humanoid")
        if not myRoot or not hum or hum.Health <= 0 then return end

        local killerRoot = getKillerRoot()
        if not killerRoot then return end
        if (myRoot.Position - killerRoot.Position).Magnitude > VD.SURV_AutoPalletDist then return end

        local remotes    = ReplicatedStorage:FindFirstChild("Remotes")
        local palletFold = remotes and remotes:FindFirstChild("Pallet")
        local dropEvent  = palletFold and palletFold:FindFirstChild("PalletDropEvent")
        if not dropEvent then return end

        -- Scan pallet dari KYS_Cache + langsung dari workspace
        -- Cari Palletwrong terdekat yang belum di-drop
        local bestPalletwrong, bestDist = nil, 8  -- max 8 studs

        -- Helper: cari PalletPointSlide di dalam Palletwrong model
        local function findPalletPointSlide(model)
            -- Spy: target = Palletwrong.PalletPointSlide
            local slide = model:FindFirstChild("PalletPointSlide")
            if slide then return slide end
            -- Fallback: cari di descendants
            for _, child in ipairs(model:GetDescendants()) do
                if child.Name == "PalletPointSlide" then return child end
            end
            -- Fallback terakhir: PalletPoint
            return model:FindFirstChild("PalletPoint")
        end

        -- Iterasi KYS_Cache.Pallets untuk cari Palletwrong terdekat
        for _, pal in ipairs(KYS_Cache.Pallets or {}) do
            local palModel = pal.model  -- ini adalah Palletwrong model
            if not palModel then continue end
            if _usedPallets[palModel] then continue end

            -- Gunakan PalletPoint/PalletPointSlide sebagai referensi posisi
            local refPart = pal.part or palModel:FindFirstChild("PalletPoint")
                         or palModel:FindFirstChild("PalletPointSlide")
            if not refPart then continue end

            local ok, pos = pcall(function() return refPart.Position end)
            if not ok or not pos then continue end

            local d = (myRoot.Position - pos).Magnitude
            if d < bestDist then
                bestDist = d
                bestPalletwrong = palModel
            end
        end

        if bestPalletwrong then
            -- Cari PalletPointSlide di dalam Palletwrong (sesuai spy)
            local fireTarget = findPalletPointSlide(bestPalletwrong)
            if fireTarget then
                -- Spy confirmed: hanya PalletDropEvent(PalletPointSlide)
                pcall(function() dropEvent:FireServer(fireTarget) end)
                _usedPallets[bestPalletwrong] = true
                _lastPalletDrop = tick()
            end
        end
    end)
end)

-- =====================================================
-- HITBOX EXPAND (Killer)
-- =====================================================
local OriginalHitboxSizes = {}

local function KYS_UpdateHitboxes()
    local function restoreAll()
        for player, originalSize in pairs(OriginalHitboxSizes) do
            if player and player.Character then
                local r = player.Character:FindFirstChild("HumanoidRootPart")
                if r then
                    r.Size = originalSize; r.Transparency = 1; r.CanCollide = true
                end
            end
        end
        OriginalHitboxSizes = {}
    end

    if GetRole() ~= "Killer" or not VD.HITBOX_Enabled then
        restoreAll()
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) then
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum  = char:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health > 0 then
                    if not OriginalHitboxSizes[player] then
                        OriginalHitboxSizes[player] = root.Size
                    end
                    local sz          = VD.HITBOX_Size
                    root.Size         = Vector3.new(sz, sz, sz)
                    root.CanCollide   = false
                    root.Transparency = 0.7
                elseif root and OriginalHitboxSizes[player] then
                    root.Size                   = OriginalHitboxSizes[player]
                    root.Transparency           = 1
                    root.CanCollide             = true
                    OriginalHitboxSizes[player] = nil
                end
            end
        end
    end
end

-- =====================================================
-- DESTROY ALL PALLETS (Killer)
-- =====================================================
local IsBreakingPallet = false

local function KYS_DestroyAllPallets()
    if not VD.KILLER_DestroyPallets or GetRole() ~= "Killer" then return end
    if IsBreakingPallet then return end

    local char = LocalPlayer.Character
    local root = Root
    if not char or not root then return end

    -- Check character attributes to prevent breaking while stunned, carrying, etc.
    local stunned = char:GetAttribute("IsStunned") or char:GetAttribute("isStunned")
    local immobile = char:GetAttribute("Immobile") or char:GetAttribute("immobile")
    local carrying = char:GetAttribute("IsCarrying") or char:GetAttribute("isCarrying")
    local pursuit = char:GetAttribute("Pursuit") or char:GetAttribute("pursuit")
    local ci = char:FindFirstChild("CheckInterractable")
    local action = ci and (ci:GetAttribute("action") or ci:GetAttribute("Action"))

    if stunned or immobile or carrying or pursuit or action then return end

    -- Find nearby pallet using the PalletPointSlide tag
    local CollectionService = game:GetService("CollectionService")
    local pts = CollectionService:GetTagged("PalletPointSlide")
    local nearest, minDist = nil, 6 -- 6 studs range
    for _, p in ipairs(pts) do
        if p:IsA("BasePart") and not CollectionService:HasTag(p, "doing action") then
            local d = (p.Position - root.Position).Magnitude
            if d < minDist then
                minDist = d
                nearest = p
            end
        end
    end

    if nearest then
        IsBreakingPallet = true
        task.spawn(function()
            pcall(function()
                local r = ReplicatedStorage:FindFirstChild("Remotes")
                local p = r and r:FindFirstChild("Pallet")
                local j = p and p:FindFirstChild("Jason")
                if j then
                    local dg = j:FindFirstChild("Destroy-Global")
                    local commit = j:FindFirstChild("PalletBreakCommit")
                    
                    if dg and dg:IsA("RemoteEvent") then
                        dg:FireServer(nearest)
                    end
                    if commit and commit:IsA("RemoteEvent") then
                        commit:FireServer(nearest)
                    end
                end
            end)

            -- Wait for breaking animation to finish (based on Immobile attribute)
            task.wait(0.2)
            local startTime = os.clock()
            while char and char.Parent and (char:GetAttribute("Immobile") or char:GetAttribute("immobile")) do
                if os.clock() - startTime > 3 then break end -- timeout safety
                task.wait(0.1)
            end
            IsBreakingPallet = false
        end)
    end
end

-- =====================================================
-- AUTO KICK GENERATOR (Killer)
-- =====================================================
getgenv().KYS_IsBreakingGenerator = false

function KYS_AutoBreakGene()
    if not VD.KILLER_AutoBreakGene or GetRole() ~= "Killer" then return end
    if getgenv().KYS_IsBreakingGenerator then return end

    local char = LocalPlayer.Character
    local root = Root
    if not char or not root then return end

    -- Check character attributes to prevent breaking while stunned, carrying, etc.
    local stunned = char:GetAttribute("IsStunned") or char:GetAttribute("isStunned")
    local immobile = char:GetAttribute("Immobile") or char:GetAttribute("immobile")
    local carrying = char:GetAttribute("IsCarrying") or char:GetAttribute("isCarrying")
    local pursuit = char:GetAttribute("Pursuit") or char:GetAttribute("pursuit")
    local ci = char:FindFirstChild("CheckInterractable")
    local action = ci and (ci:GetAttribute("action") or ci:GetAttribute("Action"))

    if stunned or immobile or carrying or pursuit or action then return end

    -- Find nearby generator using the GeneratorPoint tag
    local CollectionService = game:GetService("CollectionService")
    local pts = CollectionService:GetTagged("GeneratorPoint")
    local nearest, minDist = nil, 6 -- 6 studs range
    for _, p in ipairs(pts) do
        if p:IsA("BasePart") and not CollectionService:HasTag(p, "doing action") then
            -- Check if generator can be kicked (progress > 0, progress < 100, kickcount <= 7)
            local genModel = p.Parent
            if genModel then
                local progress = genModel:GetAttribute("RepairProgress") or genModel:GetAttribute("repairProgress") or 0
                local kickcount = genModel:GetAttribute("kickcount") or genModel:GetAttribute("KickCount") or 0
                if progress > 0 and progress < 100 and kickcount <= 7 then
                    local d = (p.Position - root.Position).Magnitude
                    if d < minDist then
                        minDist = d
                        nearest = p
                    end
                end
            end
        end
    end

    if nearest then
        getgenv().KYS_IsBreakingGenerator = true
        task.spawn(function()
            pcall(function()
                local r = ReplicatedStorage:FindFirstChild("Remotes")
                local g = r and r:FindFirstChild("Generator")
                if g then
                    local event = g:FindFirstChild("BreakGenEvent")
                    local commit = g:FindFirstChild("BreakGenCommit")
                    
                    if event and event:IsA("RemoteEvent") then
                        event:FireServer(nearest)
                    end
                    if commit and commit:IsA("RemoteEvent") then
                        commit:FireServer(nearest)
                    end
                end
            end)

            -- Wait for breaking animation to finish (based on Immobile attribute)
            task.wait(0.2)
            local startTime = os.clock()
            while char and char.Parent and (char:GetAttribute("Immobile") or char:GetAttribute("immobile")) do
                if os.clock() - startTime > 3 then break end -- timeout safety
                task.wait(0.1)
            end
            task.wait(0.3)
            getgenv().KYS_IsBreakingGenerator = false
        end)
    end
end

-- =====================================================
-- BLOCK ALL VAULTS (Killer)
-- =====================================================
getgenv().KYS_LastVaultBlockTime = 0

function KYS_BlockAllVaults()
    if not VD.KILLER_BlockVaults or GetRole() ~= "Killer" then return end
    
    local now = tick()
    if now - getgenv().KYS_LastVaultBlockTime < 1.5 then return end
    getgenv().KYS_LastVaultBlockTime = now

    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local vaultEvent = remotes and remotes:FindFirstChild("Window") and remotes.Window:FindFirstChild("VaultEvent")
        if not vaultEvent then return end

        local map = workspace:FindFirstChild("Map")
        local vaultsFolder = map and map:FindFirstChild("Vaults")
        
        if vaultsFolder then
            for _, vault in ipairs(vaultsFolder:GetChildren()) do
                for _, part in ipairs(vault:GetChildren()) do
                    if part:IsA("BasePart") then
                        pcall(function() vaultEvent:FireServer(part, true) end)
                    end
                end
            end
        else
            -- Fallback using KYS_Cache.Windows if Map structure is not default
            for _, win in ipairs(KYS_Cache.Windows or {}) do
                local window = win.model
                if window and window.Parent then
                    for _, child in ipairs(window:GetDescendants()) do
                        if child:IsA("BasePart") then
                            pcall(function() vaultEvent:FireServer(child, true) end)
                        end
                    end
                end
            end
        end
    end)
end

-- =====================================================
-- AUTO DROP ALL PALLETS (Killer)
-- =====================================================
getgenv().KYS_LastPalletBlockTime = 0

function KYS_BlockAllPalletDrops()
    if not VD.KILLER_BlockPallets or GetRole() ~= "Killer" then return end

    local now = tick()
    if now - getgenv().KYS_LastPalletBlockTime < 2 then return end
    getgenv().KYS_LastPalletBlockTime = now

    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local palletFold = remotes and remotes:FindFirstChild("Pallet")
        local dropEvent = palletFold and palletFold:FindFirstChild("PalletDropEvent")
        if not dropEvent then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end

        -- Scan semua Palletwrong di Map
        for _, obj in ipairs(map:GetDescendants()) do
            if obj.Name == "Palletwrong" and (obj:IsA("Model") or obj:IsA("Folder")) then
                local target = obj:FindFirstChild("PalletPointSlide") or obj:FindFirstChild("PalletPoint")
                if target then
                    pcall(function() dropEvent:FireServer(target) end)
                end
            end
        end

        -- Fallback: gunakan KYS_Cache.Pallets
        for _, pal in ipairs(KYS_Cache.Pallets or {}) do
            local palModel = pal.model
            if palModel and palModel.Parent then
                local target = palModel:FindFirstChild("PalletPointSlide") or palModel:FindFirstChild("PalletPoint") or pal.part
                if target then
                    pcall(function() dropEvent:FireServer(target) end)
                end
            end
        end
    end)
end

-- =====================================================
-- BLOCK PALLET DROP (Killer) - Drop + TP Break semua pallet
-- =====================================================
getgenv().KYS_LastPalletBlockDropTime = 0
getgenv().KYS_IsBlockingPallets = false

-- Helper: force bersihkan semua attribute yang bisa bikin stuck
local function KYS_ForceUnstuck(char)
    pcall(function()
        char:SetAttribute("Immobile", nil)
        char:SetAttribute("immobile", nil)
        char:SetAttribute("IsStunned", nil)
        char:SetAttribute("isStunned", nil)
        char:SetAttribute("Pursuit", nil)
        char:SetAttribute("pursuit", nil)
    end)
    -- Pastikan WalkSpeed tidak nol
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed <= 0 then
            hum.WalkSpeed = 16
        end
    end)
end

function KYS_BlockPalletDrop()
    if not VD.KILLER_BlockPalletDrop or GetRole() ~= "Killer" then return end
    if getgenv().KYS_IsBlockingPallets then return end

    local now = tick()
    if now - getgenv().KYS_LastPalletBlockDropTime < 4 then return end
    getgenv().KYS_LastPalletBlockDropTime = now

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Skip jika sedang stunned/carrying
    local stunned = char:GetAttribute("IsStunned") or char:GetAttribute("isStunned")
    local immobile = char:GetAttribute("Immobile") or char:GetAttribute("immobile")
    local carrying = char:GetAttribute("IsCarrying") or char:GetAttribute("isCarrying")
    if stunned or immobile or carrying then return end

    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local palletFold = remotes and remotes:FindFirstChild("Pallet")
        local dropEvent = palletFold and palletFold:FindFirstChild("PalletDropEvent")
        local jasonFold = palletFold and palletFold:FindFirstChild("Jason")
        local destroyGlobal = jasonFold and jasonFold:FindFirstChild("Destroy-Global")
        local breakCommit = jasonFold and jasonFold:FindFirstChild("PalletBreakCommit")
        local destroySingle = jasonFold and jasonFold:FindFirstChild("Destroy")
        if not dropEvent or not destroyGlobal or not breakCommit then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end

        -- Helper: kumpulkan semua target pallet yang masih ada
        local function collectTargets()
            local targets = {}
            local seen = {}
            for _, obj in ipairs(map:GetDescendants()) do
                if obj.Name == "Palletwrong" and (obj:IsA("Model") or obj:IsA("Folder")) then
                    local target = obj:FindFirstChild("PalletPointSlide") or obj:FindFirstChild("PalletPoint")
                    if target and target:IsA("BasePart") and not seen[target] then
                        table.insert(targets, target)
                        seen[target] = true
                    end
                end
            end
            for _, pal in ipairs(KYS_Cache.Pallets or {}) do
                local palModel = pal.model
                if palModel and palModel.Parent then
                    local target = palModel:FindFirstChild("PalletPointSlide") or palModel:FindFirstChild("PalletPoint") or pal.part
                    if target and target:IsA("BasePart") and not seen[target] then
                        table.insert(targets, target)
                        seen[target] = true
                    end
                end
            end
            return targets
        end

        local targets = collectTargets()
        if #targets == 0 then return end

        getgenv().KYS_IsBlockingPallets = true

        -- Simpan WalkSpeed awal
        local hum = char:FindFirstChildOfClass("Humanoid")
        local origWalkSpeed = hum and hum.WalkSpeed or 16

        task.spawn(function()
            pcall(function()
                local originalCF = root.CFrame

                -- Helper: proses satu pallet (drop → teleport → break)
                local function processPallet(target)
                    if not target or not target.Parent then return end
                    pcall(function()
                        -- Drop pallet dulu
                        dropEvent:FireServer(target)
                        task.wait(0.12)

                        -- Teleport ke pallet
                        root.CFrame = target.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.15)

                        -- Hancurkan pallet - kirim semua remote
                        destroyGlobal:FireServer(target)
                        breakCommit:FireServer(target)
                        if destroySingle then
                            destroySingle:FireServer(target)
                        end

                        task.wait(0.12)

                        -- Force unstuck
                        KYS_ForceUnstuck(char)
                    end)
                end

                -- Pass 1: proses semua pallet
                for _, target in ipairs(targets) do
                    processPallet(target)
                end

                -- Teleport balik dulu
                task.wait(0.1)
                pcall(function() root.CFrame = originalCF end)
                KYS_ForceUnstuck(char)

                -- Pass 2: cek pallet yang masih tersisa, proses lagi
                task.wait(0.5)
                local remaining = collectTargets()
                if #remaining > 0 then
                    originalCF = root.CFrame
                    for _, target in ipairs(remaining) do
                        processPallet(target)
                    end
                    task.wait(0.1)
                    pcall(function() root.CFrame = originalCF end)
                end

                -- Final unstuck + restore
                task.wait(0.1)
                KYS_ForceUnstuck(char)
                if hum then
                    pcall(function() hum.WalkSpeed = origWalkSpeed end)
                end
            end)

            -- Safety net: loop unstuck selama 1 detik
            task.spawn(function()
                for i = 1, 10 do
                    task.wait(0.1)
                    if char and char.Parent then
                        KYS_ForceUnstuck(char)
                        if hum and hum.WalkSpeed <= 0 then
                            pcall(function() hum.WalkSpeed = origWalkSpeed end)
                        end
                    end
                end
            end)

            getgenv().KYS_IsBlockingPallets = false
        end)
    end)
end

-- =====================================================
-- BYPASS COOLDOWN (Abyss) (Killer)
-- =====================================================
getgenv().KYS_AbyssCooldownBypassConnection = nil
getgenv().KYS_CorruptHandlerFunc = nil

function KYS_StartAbyssCooldownBypass()
    if not getgenv().KYS_CorruptHandlerFunc then
        for _, v in pairs(getgc(true)) do
            if type(v) == "function" and islclosure(v) then
                local constants = debug.getconstants(v)
                if table.find(constants, "corrupt") and table.find(constants, "Immobile") then
                    getgenv().KYS_CorruptHandlerFunc = v
                    break
                end
            end
        end
    end

    if not getgenv().KYS_CorruptHandlerFunc then
        return
    end
    
    if getgenv().KYS_AbyssCooldownBypassConnection then 
        getgenv().KYS_AbyssCooldownBypassConnection:Disconnect() 
    end
    
    getgenv().KYS_AbyssCooldownBypassConnection = RunService.Heartbeat:Connect(function()
        if not VD.KILLER_BypassCooldown then return end
        if getgenv().KYS_CorruptHandlerFunc then
            local upvalues = debug.getupvalues(getgenv().KYS_CorruptHandlerFunc)
            for idx, val in pairs(upvalues) do
                if type(val) == "boolean" then
                    if val == false then
                        debug.setupvalue(getgenv().KYS_CorruptHandlerFunc, idx, true)
                    end
                end
            end
        end
    end)
end

function KYS_StopAbyssCooldownBypass()
    if getgenv().KYS_AbyssCooldownBypassConnection then
        getgenv().KYS_AbyssCooldownBypassConnection:Disconnect()
        getgenv().KYS_AbyssCooldownBypassConnection = nil
    end
end

-- =====================================================
-- BYPASS COOLDOWN (Jeff / The Killer)
-- =====================================================
getgenv().KYS_JeffCooldownBypassThread = nil

function KYS_StartJeffCooldownBypass()
    if getgenv().KYS_JeffCooldownBypassThread then return end
    getgenv().KYS_JeffCooldownBypassThread = task.spawn(function()
        local rs = game:GetService("RunService")
        local player = game:GetService("Players").LocalPlayer

        while task.wait() do
            if not VD.KILLER_InfFrenzy then
                break
            end
            pcall(function()
                local char = player.Character
                if char and char:GetAttribute("Frenzy") ~= true then
                    char:SetAttribute("Frenzy", true)
                end
            end)
        end
        
        getgenv().KYS_JeffCooldownBypassThread = nil
    end)
end

function KYS_StopJeffCooldownBypass()
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local char = player.Character
        if char and char:GetAttribute("Frenzy") == true then
            char:SetAttribute("Frenzy", false)
            
            -- Tell server we are deactivating so the real cooldown can start
            local killer = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Killers"):FindFirstChild("Killer")
            if killer then
                local deact = killer:FindFirstChild("Deactivatefromclient")
                if deact then
                    deact:FireServer()
                end
            end
        end
    end)
end

getgenv().KYS_SlasherCooldownBypassThread = nil

function KYS_StartSlasherCooldownBypass()
    if getgenv().KYS_SlasherCooldownBypassThread then return end
    
    -- BOOLEAN ARITHMETIC FAILSAFE FOR AWARDLOG
    pcall(function()
        local b = true
        local mt = debug.getmetatable(b)
        if not mt then
            mt = {}
            debug.setmetatable(b, mt)
        end
        if setreadonly then setreadonly(mt, false) end
        mt.__div = function() return 0 end
        mt.__mul = function() return 0 end
        mt.__add = function() return 0 end
        mt.__sub = function() return 0 end
        if setreadonly then setreadonly(mt, true) end
    end)
    
    getgenv().KYS_SlasherCooldownBypassThread = task.spawn(function()
        local toggleFunc = nil
        local pursuitHandler = nil
        
        local function scanGCForSlasher()
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "function" and islclosure(v) then
                        local consts = debug.getconstants(v)
                        local hasOffset, hasLinear, hasAction, hasTweenInfo = false, false, false, false
                        local hasPursuit, hasWalkSpeed = false, false
                        
                        for _, c in pairs(consts) do
                            if c == "Offset" then hasOffset = true end
                            if c == "Linear" then hasLinear = true end
                            if c == "action" then hasAction = true end
                            if c == "TweenInfo" then hasTweenInfo = true end
                            if c == "Pursuit" then hasPursuit = true end
                            if c == "WalkSpeed" then hasWalkSpeed = true end
                        end
                        
                        if hasOffset and hasLinear and hasAction and hasTweenInfo and not hasPursuit then
                            toggleFunc = v
                        end
                        
                        if hasPursuit and hasTweenInfo and hasAction and hasWalkSpeed then
                            pursuitHandler = v
                        end
                    end
                    if toggleFunc and pursuitHandler then break end
                end
            end)
        end

        scanGCForSlasher()
        local lastScan = os.clock()
        local wasLakeMistActive = false
        local wasPursuitActive = false
        
        while task.wait(0.1) do
            if not VD.KILLER_InfLakeMist and not VD.KILLER_InfPursuit then
                break
            end
            
            if not (toggleFunc and pursuitHandler) then
                if os.clock() - lastScan >= 2 then
                    scanGCForSlasher()
                    lastScan = os.clock()
                end
            end
            
            if toggleFunc and VD.KILLER_InfLakeMist then
                pcall(function()
                    debug.setupvalue(toggleFunc, 6, false) -- v_u_13 (LakeMist cooldown)
                    debug.setupvalue(toggleFunc, 10, false) -- v_u_12 (Anti-spam)
                end)
            end
            
            if pursuitHandler and VD.KILLER_InfPursuit then
                pcall(function()
                    debug.setupvalue(pursuitHandler, 5, false) -- v_u_12 (Anti-spam)
                    debug.setupvalue(pursuitHandler, 6, false) -- v_u_14 (Pursuit cooldown)
                end)
            end
        end
        
        getgenv().KYS_SlasherCooldownBypassThread = nil
    end)
end

function KYS_StopSlasherCooldownBypass()
    -- Loop will exit automatically when both VD.KILLER_InfLakeMist and VD.KILLER_InfPursuit are false
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local jason = rs:FindFirstChild("Remotes") and rs.Remotes:FindFirstChild("Killers") and rs.Remotes.Killers:FindFirstChild("Jason")
        if jason then
            if not VD.KILLER_InfLakeMist then
                local lm = jason:FindFirstChild("LakeMist")
                if lm then lm:FireServer(false) end
            end
            if not VD.KILLER_InfPursuit then
                local ps = jason:FindFirstChild("Pursuit")
                if ps then ps:FireServer(false) end
            end
        end
    end)
end

-- ==============================================
-- KILLER FAKE ATTACK (COUNTER AUTO PARRY)
-- ==============================================
getgenv().KYS_FakeAttackThread = nil
function KYS_ToggleFakeAttack(enabled)
    if not enabled then
        if getgenv().KYS_FakeAttackThread then
            task.cancel(getgenv().KYS_FakeAttackThread)
            getgenv().KYS_FakeAttackThread = nil
        end
        return
    end
    
    if getgenv().KYS_FakeAttackThread then return end
    
    getgenv().KYS_FakeAttackThread = task.spawn(function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        while VD.KILLER_FakeAttack do
            local char = LocalPlayer.Character
            if char then
                local Animator = char:FindFirstChild("Humanoid") and char.Humanoid:FindFirstChild("Animator")
                if Animator then
                    local myRoot = char:FindFirstChild("HumanoidRootPart")
                    local near = false
                    if myRoot then
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Team and p.Team.Name == "Survivors" then
                                local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                                if r and (myRoot.Position - r.Position).Magnitude <= 15 then
                                    near = true
                                    break
                                end
                            end
                        end
                    end
                    
                    if near then
                        pcall(function()
                            local bait = Instance.new("Animation")
                            bait.AnimationId = "rbxassetid://117042998468241"
                            local track = Animator:LoadAnimation(bait)
                            track:Play()
                            track:AdjustWeight(0) -- event AnimationPlayed terpancar, killer tetap diam
                            task.wait(0.05)
                            track:Stop()
                        end)
                    end
                end
            end
            task.wait(0.3)
        end
        getgenv().KYS_FakeAttackThread = nil
    end)
end


getgenv().KYS_CureFlaskLaserThread = nil
getgenv().KYS_CureFlaskLaserPart = nil

function KYS_UpdateCureFlaskLaser()
    local char = game:GetService("Players").LocalPlayer.Character
    if not char then return end
    
    local targetPos = nil
    local originPos = nil

    local closest = nil
    local minDst = math.huge
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
        originPos = hand and hand.Position or hrp.Position
        
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= game:GetService("Players").LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if not v.Character:GetAttribute("IsKiller") then
                    local dst = (v.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dst < minDst then
                        minDst = dst
                        closest = v
                    end
                end
            end
        end
    end
    
    if closest then
        targetPos = closest.Character.HumanoidRootPart.Position
    end
    
    -- Check if we have action attribute true (which means charging/holding flask)
    local actionActive = false
    for _, child in pairs(char:GetChildren()) do
        if child:IsA("LocalScript") and child:GetAttribute("action") == true then
            actionActive = true
            break
        end
    end

    if originPos and targetPos and actionActive then
        if not getgenv().KYS_CureFlaskLaserPart then
            local laser = Instance.new("Part")
            laser.Name = "FlaskSilentAimLaser"
            laser.Anchored = true
            laser.CanCollide = false
            laser.CanTouch = false
            laser.CastShadow = false
            laser.Material = Enum.Material.Neon
            laser.Color = Color3.fromRGB(0, 100, 255)
            laser.Transparency = 0
            laser.Parent = workspace
            getgenv().KYS_CureFlaskLaserPart = laser
        end
        
        local dist = (targetPos - originPos).Magnitude
        if dist > 0.1 then
            local laser = getgenv().KYS_CureFlaskLaserPart
            laser.Size = Vector3.new(0.16, 0.16, dist)
            laser.CFrame = CFrame.new((originPos + targetPos) / 2, targetPos)
            laser.Transparency = 0
        end
    else
        if getgenv().KYS_CureFlaskLaserPart then
            getgenv().KYS_CureFlaskLaserPart.Transparency = 1
        end
    end
end

function KYS_StartCureFlaskLaser()
    if getgenv().KYS_CureFlaskLaserThread then return end
    getgenv().KYS_CureFlaskLaserThread = game:GetService("RunService").RenderStepped:Connect(function()
        if not VD.KILLER_FlaskLaser then
            if getgenv().KYS_CureFlaskLaserPart then
                pcall(function() getgenv().KYS_CureFlaskLaserPart:Destroy() end)
                getgenv().KYS_CureFlaskLaserPart = nil
            end
            if getgenv().KYS_CureFlaskLaserThread then
                getgenv().KYS_CureFlaskLaserThread:Disconnect()
                getgenv().KYS_CureFlaskLaserThread = nil
            end
            return
        end
        pcall(KYS_UpdateCureFlaskLaser)
    end)
end

-- =====================================================
-- BYPASS COOLDOWN (Hidden)
-- =====================================================
getgenv().KYS_HiddenLeapBypassThread = nil

function KYS_StartHiddenCooldownBypass()
    if getgenv().KYS_HiddenLeapBypassThread then return end
    getgenv().KYS_HiddenLeapBypassThread = task.spawn(function()
        local leapFunction, m2Function, toggleFunc, pursuitFunc
        
        local function scanGC()
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "function" and islclosure(v) then
                        local info
                        pcall(function() info = debug.getinfo(v) end)
                        if info then
                            if info.name == "tryActivate" then
                                leapFunction = v
                            elseif info.name == "playM2Animation" then
                                m2Function = v
                            end
                        end
                    end
                    if leapFunction and m2Function then break end
                end
            end)
        end

        scanGC()

        local lastScan = os.clock()
        while task.wait(0.1) do
            if not VD.KILLER_BypassLeap then
                break
            end
            
            -- If functions are not found, retry scanning every 2 seconds
            if not (leapFunction and m2Function) then
                local now = os.clock()
                if now - lastScan >= 2 then
                    lastScan = now
                    scanGC()
                end
            end
            
            -- Bypass cooldown by setting boolean upvalues from true to false
            if leapFunction then
                pcall(function()
                    for i, val in pairs(debug.getupvalues(leapFunction)) do
                        if type(val) == "boolean" and val == true then
                            debug.setupvalue(leapFunction, i, false)
                        end
                    end
                end)
            end
            if m2Function then
                pcall(function()
                    for i, val in pairs(debug.getupvalues(m2Function)) do
                        if type(val) == "boolean" and val == true then
                            debug.setupvalue(m2Function, i, false)
                        end
                    end
                end)
            end
        end
        getgenv().KYS_HiddenLeapBypassThread = nil
    end)
end

function KYS_StopHiddenCooldownBypass()
    -- Loop terminates automatically when VD.KILLER_BypassLeap is false
end



-- =====================================================
-- FLING
-- =====================================================
function KYS_FlingNearest()
    if not VD.FLING_Enabled then return end
    local root = Root
    if not root then return end
    local closest, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local dist = (tr.Position - root.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist; closest = player
                end
            end
        end
    end
    if closest and closest.Character then
        local tr = closest.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local originalPos = root.CFrame
            for _ = 1, 10 do
                root.CFrame      = tr.CFrame
                root.Velocity    = Vector3.new(VD.FLING_Strength, VD.FLING_Strength / 2, VD.FLING_Strength)
                root.RotVelocity = Vector3.new(9999, 9999, 9999)
                task.wait()
            end
            root.CFrame      = originalPos
            root.Velocity    = Vector3.zero
            root.RotVelocity = Vector3.zero
        end
    end
end

function KYS_FlingAll()
    if not VD.FLING_Enabled then return end
    local root = Root
    if not root then return end
    local originalPos = root.CFrame
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                for _ = 1, 5 do
                    root.CFrame      = tr.CFrame
                    root.Velocity    = Vector3.new(VD.FLING_Strength, VD.FLING_Strength / 2, VD.FLING_Strength)
                    root.RotVelocity = Vector3.new(9999, 9999, 9999)
                    task.wait()
                end
            end
        end
    end
    root.CFrame      = originalPos
    root.Velocity    = Vector3.zero
    root.RotVelocity = Vector3.zero
end


-- =====================================================
-- BEAT GAME SURVIVOR (teleport to exit)
-- =====================================================
local function KYS_BeatGameSurvivor()
    if not VD.BEAT_Survivor or GetRole() ~= "Survivor" then return end
    local root = Root
    if not root then return end
    local map = Workspace:FindFirstChild("Map")

    local exitPos = nil
    local finishPart = nil
    
    -- Cara 1: Scan finishline dari seluruh workspace descendants (Seperti di fallens.lua)
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            local nameLower = string.lower(obj.Name)
            if (nameLower == "fininshline" or nameLower == "finishline") and obj:IsA("BasePart") then
                finishPart = obj
                exitPos = obj.Position
                break
            end
        end
    end)

    -- Cara 2: Fallback ke pengecekan spesifik map
    if not exitPos and map then
        pcall(function()
            if map:FindFirstChild("RooftopHitbox") or map:FindFirstChild("Rooftop") then
                finishPart = map:FindFirstChild("RooftopHitbox") or map:FindFirstChild("Rooftop")
                if finishPart:IsA("Model") then finishPart = finishPart.PrimaryPart or finishPart:FindFirstChildWhichIsA("BasePart") end
                if finishPart then exitPos = finishPart.Position else exitPos = Vector3.new(3098.16, 454.04, -4918.74) end
                return
            end
            if map:FindFirstChild("HooksMeat") then
                finishPart = map:FindFirstChild("HooksMeat")
                if finishPart:IsA("Model") then finishPart = finishPart.PrimaryPart or finishPart:FindFirstChildWhichIsA("BasePart") end
                if finishPart then exitPos = finishPart.Position else exitPos = Vector3.new(1546.12, 152.21, -796.72) end
                return
            end
            if KYS_Cache and KYS_Cache.ExitPos then
                exitPos = KYS_Cache.ExitPos
                finishPart = KYS_Cache.ExitPart
                return
            end
        end)
    end

    if not exitPos then return end
    VD._LastFinishPos    = VD._LastFinishPos or nil
    VD._BeatSurvivorDone = VD._BeatSurvivorDone or false
    if VD._BeatSurvivorDone then return end

    VD._BeatSurvivorDone = true
    VD._LastFinishPos    = exitPos

    task.spawn(function()
        task.delay(4, function()
            if VD._BeatSurvivorDone then VD._BeatSurvivorDone = false end
        end)

        for i = 1, 10 do
            if not Root or not Root.Parent then break end

            pcall(function()
                local event = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Game"):FindFirstChild("PlayerActionEvent")
                if event then
                    if event:IsA("RemoteEvent") then
                        event:FireServer("ESCAPED", 200)
                    elseif event:IsA("BindableEvent") then
                        event:Fire("ESCAPED", 200)
                    end
                end
            end)

            if firetouchinterest and finishPart then
                pcall(function() firetouchinterest(Root, finishPart, 0) end)
                pcall(function() firetouchinterest(Root, finishPart, 1) end)
            end

            if i == 1 then
                Root.Velocity = Vector3.zero
                if exitPos then
                    Root.CFrame = CFrame.new(exitPos + Vector3.new(0, 3, 0))
                end
            end

            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:MoveTo(exitPos) --
                end
            end)

            task.wait(0.2)
        end
    end)
end

-- =====================================================
-- BEAT GAME KILLER (auto chase & attack survivors)
-- =====================================================
local function KYS_BeatGameKiller()
    if not VD.BEAT_Killer then
        VD._KillerTarget = nil; return
    end
    if GetRole() ~= "Killer" then
        VD._KillerTarget = nil; return
    end
    local root = Root
    if not root then return end

    local target        = VD._KillerTarget
    local needNewTarget = true
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        local th = target.Character:FindFirstChildOfClass("Humanoid")
        if tr and th and th.MaxHealth > 0 and (th.Health / th.MaxHealth) > 0.25 then
            needNewTarget = false
        else
            VD._KillerTarget = nil
        end
    end

    if needNewTarget then
        local survivors = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
                local pr = player.Character:FindFirstChild("HumanoidRootPart")
                local ph = player.Character:FindFirstChildOfClass("Humanoid")
                if pr and ph and ph.MaxHealth > 0 and (ph.Health / ph.MaxHealth) > 0.25 then table.insert(survivors, player) end
            end
        end
        if #survivors > 0 then
            local closest, closestDist = nil, math.huge
            for _, player in ipairs(survivors) do
                local pr   = player.Character:FindFirstChild("HumanoidRootPart")
                local dist = (pr.Position - root.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist; closest = player
                end
            end
            VD._KillerTarget = closest
            target           = closest
        else
            VD._KillerTarget = nil; return
        end
    end

    if not target or not target.Character then return end
    local tr = target.Character:FindFirstChild("HumanoidRootPart")
    local th = target.Character:FindFirstChildOfClass("Humanoid")
    if not tr or not th then
        VD._KillerTarget = nil; return
    end
    if th.MaxHealth <= 0 or (th.Health / th.MaxHealth) <= 0.25 then
        VD._KillerTarget = nil; return
    end

    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then pcall(function() part.CanCollide = false end) end
    end

    local dir = (root.Position - tr.Position).Unit
    if dir.Magnitude ~= dir.Magnitude then dir = Vector3.new(1, 0, 0) end
    root.CFrame = CFrame.new(tr.Position + dir * 3 + Vector3.new(0, 1, 0), tr.Position)

    pcall(function()
        local r  = ReplicatedStorage:FindFirstChild("Remotes")
        local a  = r and r:FindFirstChild("Attacks")
        local ba = a and a:FindFirstChild("BasicAttack")
        if ba then ba:FireServer(false) end
    end)
end

-- =====================================================
-- AUTO HOOK (Killer)
-- =====================================================
local IsAutoHooking = false

local function KYS_AutoHook()
    if not VD.KILLER_AutoHook or GetRole() ~= "Killer" then return end
    if IsAutoHooking then return end

    local root = Root
    if not root then return end

    -- Check if we are already carrying a survivor
    local char = LocalPlayer.Character
    local isCarrying = false
    if char then
        isCarrying = char:GetAttribute("IsCarrying") or char:GetAttribute("isCarrying")
    end

    -- If we are already carrying, we bypass pickup and look straight for a hook
    if isCarrying then
        -- Find occupied hooks
        local occupiedPositions = {}
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local isHooked = v.Character:GetAttribute("IsHooked") or v.Character:GetAttribute("isHooked")
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                if isHooked and hrp then
                    table.insert(occupiedPositions, hrp.Position)
                end
            end
        end

        -- Find nearest empty hook to our current position
        local closestHook, hDist = nil, math.huge
        for _, h in ipairs(KYS_Cache.Hooks or {}) do
            if h.part then
                local isOccupied = false
                for _, occPos in ipairs(occupiedPositions) do
                    if (h.part.Position - occPos).Magnitude < 10 then
                        isOccupied = true
                        break
                    end
                end
                if not isOccupied then
                    local hd = (h.part.Position - root.Position).Magnitude
                    if hd < hDist then
                        hDist = hd; closestHook = h
                    end
                end
            end
        end

        if closestHook then
            IsAutoHooking = true
            task.spawn(function()
                -- Teleport to Hook
                root.CFrame = CFrame.new(closestHook.part.Position + Vector3.new(0, 3, 0))
                task.wait(0.4)

                -- Fire Hook Event and Hook Commit
                pcall(function()
                    local carryFolder = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Carry")
                    local event = carryFolder and carryFolder:FindFirstChild("HookEvent")
                    local commit = carryFolder and carryFolder:FindFirstChild("HookCommit")
                    
                    local hookPoint = nil
                    if closestHook.model then
                        hookPoint = closestHook.model:FindFirstChild("HookPoint") or closestHook.model:FindFirstChild("HookHitbox")
                    end
                    if not hookPoint then hookPoint = closestHook.part end

                    if event and event:IsA("RemoteEvent") then
                        event:FireServer(hookPoint)
                    end
                    if commit and commit:IsA("RemoteEvent") then
                        commit:FireServer(hookPoint)
                    end
                end)
                task.wait(0.5)
                IsAutoHooking = false
            end)
        end
        return
    end

    -- If not carrying, find the closest downed survivor
    local closestDowned, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local tr  = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum then
                local pct = (hum.MaxHealth > 0) and (hum.Health / hum.MaxHealth) or 0
                if pct <= 0.25 and pct > 0 then
                    local isHooked = false
                    if KYS_Cache and KYS_Cache.Hooks then
                        for _, hh in ipairs(KYS_Cache.Hooks) do
                            if hh.part and (hh.part.Position - tr.Position).Magnitude < 4.5 then
                                isHooked = true; break
                            end
                        end
                    end

                    if not isHooked then
                        local dist = (tr.Position - root.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist; closestDowned = tr
                        end
                    end
                end
            end
        end
    end

    if closestDowned then
        -- Find occupied hooks
        local occupiedPositions = {}
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local isHooked = v.Character:GetAttribute("IsHooked") or v.Character:GetAttribute("isHooked")
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                if isHooked and hrp then
                    table.insert(occupiedPositions, hrp.Position)
                end
            end
        end

        -- Find nearest empty hook to the downed survivor
        local closestHook, hDist = nil, math.huge
        for _, h in ipairs(KYS_Cache.Hooks or {}) do
            if h.part then
                local isOccupied = false
                for _, occPos in ipairs(occupiedPositions) do
                    if (h.part.Position - occPos).Magnitude < 10 then
                        isOccupied = true
                        break
                    end
                end
                if not isOccupied then
                    local hd = (h.part.Position - closestDowned.Position).Magnitude
                    if hd < hDist then
                        hDist = hd; closestHook = h
                    end
                end
            end
        end

        if closestHook then
            IsAutoHooking = true
            task.spawn(function()
                -- Teleport to downed survivor
                root.CFrame = CFrame.new(closestDowned.Position + Vector3.new(0, 3, 0), closestDowned.Position)
                task.wait(0.3)

                -- Perform Carry via RemoteEvent directly!
                pcall(function()
                    local carryFolder = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Carry")
                    local carryEvent = carryFolder and carryFolder:FindFirstChild("CarrySurvivorEvent")
                    if carryEvent and carryEvent:IsA("RemoteEvent") then
                        carryEvent:FireServer(closestDowned.Parent)
                    end
                end)

                -- Wait for pickup to complete/register
                task.wait(0.8)

                -- Verify if we successfully picked them up
                local currentCarrying = false
                local myChar = LocalPlayer.Character
                if myChar then
                    currentCarrying = myChar:GetAttribute("IsCarrying") or myChar:GetAttribute("isCarrying")
                end

                -- If successfully carrying, teleport to hook
                if currentCarrying and root and root.Parent then
                    -- Teleport to Hook
                    root.CFrame = CFrame.new(closestHook.part.Position + Vector3.new(0, 3, 0))
                    task.wait(0.4)

                    -- Fire Hook Event and Hook Commit
                    pcall(function()
                        local carryFolder = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Carry")
                        local event = carryFolder and carryFolder:FindFirstChild("HookEvent")
                        local commit = carryFolder and carryFolder:FindFirstChild("HookCommit")
                        
                        local hookPoint = nil
                        if closestHook.model then
                            hookPoint = closestHook.model:FindFirstChild("HookPoint") or closestHook.model:FindFirstChild("HookHitbox")
                        end
                        if not hookPoint then hookPoint = closestHook.part end

                        if event and event:IsA("RemoteEvent") then
                            event:FireServer(hookPoint)
                        end
                        if commit and commit:IsA("RemoteEvent") then
                            commit:FireServer(hookPoint)
                        end
                    end)
                end

                task.wait(1)
                IsAutoHooking = false
            end)
        end
    end
end

-- =====================================================
-- MAP SCAN LOOP & MAIN AUTO LOOP
-- =====================================================
task.spawn(function()
    while not VD.Destroyed do
        if Root and KYS_Cache.Hooks and #KYS_Cache.Hooks > 0 then
            local closest, closestDist = nil, math.huge
            for _, hook in ipairs(KYS_Cache.Hooks) do
                if hook.part then
                    local d = (hook.part.Position - Root.Position).Magnitude
                    if d < closestDist then
                        closestDist = d; closest = hook
                    end
                end
            end
            KYS_Cache.ClosestHook = closest
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while not VD.Destroyed do
        pcall(KYS_AutoAttack)
        pcall(KYS_UpdateHitboxes)
        pcall(KYS_DestroyAllPallets)
        pcall(KYS_AutoBreakGene)
        pcall(KYS_BlockAllVaults)
        pcall(KYS_BlockAllPalletDrops)
        pcall(KYS_BlockPalletDrop)

        pcall(KYS_BeatGameSurvivor)
        pcall(KYS_BeatGameKiller)
        pcall(KYS_AutoHook)
        task.wait(0.12)
    end
end)
end -- end Auto Features scope



-- =====================================================
-- AIMBOT (Camera-based) + Spear Aimbot
-- =====================================================
local Aimbot = {}
local State  = { AimTarget = nil, AimHolding = false }

function Aimbot.GetClosestTarget(cam)
    if not cam then return nil end
    if GetRole() ~= "Survivor" then return nil end

    local root = Root
    if not root then return nil end

    local closestPlayer = nil
    local closestDist   = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsKiller(player) and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local dist = (tr.Position - root.Position).Magnitude

                local passVis = true
                if VD.AIM_VisCheck then
                    local camPos = cam.CFrame.Position
                    local params = RaycastParams.new()
                    params.FilterType = Enum.RaycastFilterType.Blacklist
                    params.FilterDescendantsInstances = { cam, LocalPlayer.Character, player.Character }
                    local ray = workspace:Raycast(camPos, tr.Position - camPos, params)
                    passVis = (ray == nil)
                end

                if passVis and dist < closestDist then
                    closestDist = dist
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

function Aimbot.GetPredictedPosition(target, targetPart)
    if not target or not targetPart then return nil end
    local pos = targetPart.Position
    if VD.AIM_Predict then
        local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if root then pos = pos + root.AssemblyLinearVelocity * 0.1 end
    end
    return pos
end

function Aimbot.AimAt(cam, targetPos)
    if not cam or not targetPos then return end
    local cur    = cam.CFrame
    local smooth = VD.AIM_Smooth or 0.3
    cam.CFrame   = cur:Lerp(CFrame.new(cur.Position, targetPos), smooth)
end

function Aimbot.Update(cam, screenSize, screenCenter)
    if not VD.AIM_Enabled or GetRole() ~= "Survivor" then
        State.AimTarget = nil; return
    end
    if VD.AIM_UseRMB and not State.AimHolding then
        State.AimTarget = nil; return
    end
    local target = Aimbot.GetClosestTarget(cam)
    State.AimTarget = target
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local pred = Aimbot.GetPredictedPosition(target, tr)
            if pred then Aimbot.AimAt(cam, pred) end
        end
    end
end

-- Spear Aimbot (gravity compensation)
function SpearAimbotCalc(targetPos)
    if not VD.SPEAR_Aimbot or GetRole() ~= "Killer" then return nil end
    local root = Root
    if not root then return nil end
    local startPos = root.Position + Vector3.new(0, 2, 0)
    local distance = (targetPos - startPos).Magnitude
    local gravity  = VD.SPEAR_Gravity or 50
    local speed    = VD.SPEAR_Speed or 100
    local time     = distance / speed
    local drop     = 0.5 * gravity * time * time
    return targetPos + Vector3.new(0, drop, 0)
end

-- =====================================================
-- SPEAR AIMBOT: Manual Target List + Cycle (Panah GUI)
-- =====================================================
function GetSpearTargetList()
    local root = Root
    local list = {}
    if not root then return list end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            local th = player.Character:FindFirstChildOfClass("Humanoid")
            if tr and th and th.MaxHealth > 0 and (th.Health / th.MaxHealth) > 0.25 then
                local dist = (tr.Position - root.Position).Magnitude
                table.insert(list, { Player = player, Dist = dist })
            end
        end
    end
    table.sort(list, function(a, b) return a.Dist < b.Dist end)
    local players = {}
    for _, v in ipairs(list) do table.insert(players, v.Player) end
    return players
end

function CycleSpearTarget(direction)
    local list = GetSpearTargetList()
    if #list == 0 then
        SpearBtnData.ManualTarget = nil
        SpearBtnData.TargetIndex = 0
        pcall(VD_Notify, "Spear Aimbot", "Tidak ada target survivor.", 2)
        return
    end

    -- Cari index target saat ini di list terbaru (posisi survivor berubah tiap saat)
    local curIdx = nil
    if SpearBtnData.ManualTarget then
        for i, p in ipairs(list) do
            if p == SpearBtnData.ManualTarget then curIdx = i; break end
        end
    end

    local nextIdx
    if curIdx then
        nextIdx = curIdx + direction
        if nextIdx > #list then nextIdx = 1 end
        if nextIdx < 1 then nextIdx = #list end
    else
        nextIdx = 1
    end

    SpearBtnData.TargetIndex  = nextIdx
    SpearBtnData.ManualTarget = list[nextIdx]

    pcall(VD_Notify, "Spear Aimbot", "Target: " .. SpearBtnData.ManualTarget.Name, 2)
    pcall(UpdateSpearTargetLabel)
end

function UpdateSpearTargetLabel()
    if not (SpearBtnData and SpearBtnData.TargetLabel) then return end
    if SpearBtnData.ManualTarget and SpearBtnData.ManualTarget.Parent then
        SpearBtnData.TargetLabel.Text = SpearBtnData.ManualTarget.Name
        SpearBtnData.TargetLabel.Visible = true
    else
        SpearBtnData.TargetLabel.Text = "AUTO"
        SpearBtnData.TargetLabel.Visible = true
    end
end

function UpdateSpearAim()
    if not VD.SPEAR_Aimbot or (SpearBtnData and not SpearBtnData.Active) or GetRole() ~= "Killer" then return end
    local root = Root
    if not root then return end

    local target = nil

    -- Pakai target manual kalau masih valid (masih di server, karakter ada, hidup, HP > 25%)
    if SpearBtnData.ManualTarget then
        local p = SpearBtnData.ManualTarget
        local valid = p.Parent and IsSurvivor(p) and p.Character
        if valid then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local th = p.Character:FindFirstChildOfClass("Humanoid")
            valid = tr and th and th.MaxHealth > 0 and (th.Health / th.MaxHealth) > 0.25
        end
        if valid then
            target = p
        else
            -- Target manual sudah tidak valid (mati/keluar) -> balik ke auto
            SpearBtnData.ManualTarget = nil
            pcall(UpdateSpearTargetLabel)
        end
    end

    -- Fallback: auto pilih target terdekat
    if not target then
        local closest, closestDist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
                local tr = player.Character:FindFirstChild("HumanoidRootPart")
                local th = player.Character:FindFirstChildOfClass("Humanoid")
                if tr and th and th.MaxHealth > 0 and (th.Health / th.MaxHealth) > 0.25 then
                    local dist = (tr.Position - root.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist; closest = player
                    end
                end
            end
        end
        target = closest
    end

    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local aimPos = SpearAimbotCalc(tr.Position)
            if aimPos then
                local cam = workspace.CurrentCamera
                if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, aimPos) end
            end
        end
    end
end

-- Helper: check if touch is on Gui-mob shoot button (mobile)
local function KYS_IsTouchOnAttackButton(input)
    local pos = input.Position
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return false end
    
    local survMob = playerGui:FindFirstChild("Survivor-mob")
    if not survMob then return false end
    local controls = survMob:FindFirstChild("Controls")
    if not controls then return false end
    local guiMob = controls:FindFirstChild("Gui-mob")
    if not guiMob or not guiMob:IsA("GuiObject") or not guiMob.Visible then return false end
    
    local absPos = guiMob.AbsolutePosition
    local absSize = guiMob.AbsoluteSize
    return pos.X >= absPos.X and pos.X <= absPos.X + absSize.X
        and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if State.Unloaded then return end
    if VD.AIM_Enabled and VD.AIM_UseRMB then
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            State.AimHolding = true
        elseif input.UserInputType == Enum.UserInputType.Touch and not gpe then
            -- Mobile: only lock aimbot when touching attack/shoot button
            if KYS_IsTouchOnAttackButton(input) then
                State.AimHolding = true
            end
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if State.Unloaded then return end
    if VD.AIM_Enabled and VD.AIM_UseRMB then
        if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
            State.AimHolding = false
            State.AimTarget  = nil
        end
    end
end)


do -- Teleport Tab
    local tpMapSection = MappingTab:AddSection({
        Position = "Center",
        Name = "Teleport",
        Icon      = "solar:map-point-bold",
        Box       = true,
        BoxBorder = true,
        Opened    = false,
    })
    local function getTeleportPlayerNames()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(names, p.Name) end
        end
        table.sort(names)
        return names
    end

    local tpPlayerDropdown = tpMapSection:AddDropdown({
        Name = "Select Player to Teleport",
        Flag = "TP_TargetPlayer",
        Values = getTeleportPlayerNames(),
        Multi = false,
        Callback = function(option)
            if type(option) == "table" then option = option[1] end
            VD.TP_TargetPlayer = option or ""
        end
    })

    tpMapSection:AddButton({ Name = "Refresh Players", Callback = function()
        pcall(function() tpPlayerDropdown:SetValues(getTeleportPlayerNames()) end)
    end })

    tpMapSection:AddButton({ Name = "Teleport to Player", Callback = function()
        pcall(function()
            local targetName = VD.TP_TargetPlayer
            if not targetName or targetName == "" then return end
            local player = Players:FindFirstChild(targetName)
            local root = Root
            local targetRoot = player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root and targetRoot then
                root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
            end
        end)
    end })

    tpMapSection:AddButton({ Name = "TP to Gen", Callback = function() pcall(function() KYS_TeleportToGenerator(1) end) end })
    tpMapSection:AddButton({ Name = "TP to Gate", Callback = function() pcall(KYS_TeleportToGate) end })
    tpMapSection:AddButton({ Name = "TP to Hook", Callback = function() pcall(KYS_TeleportToHook) end })
end

do -- Radar Tab
    local radarTab = MappingFeatureTabs.Radar
    if radarTab then
        local radarSection = radarTab:AddSection({
            Position = "Center",
            Name = "Radar Configuration",
            Icon      = "solar:radar-bold",
            Box       = true,
            BoxBorder = true,
            Opened    = false,
        })
        
        radarSection:AddToggle({
            Default = false,
            Name = "Radar Enabled", Flag = "Radar Enabled",
            Callback = function(state)
                VD.RADAR_Enabled = state
                if not state and radarGui then radarGui.Enabled = false end
            end
        })
        
        radarSection:AddSlider({
            Name = "Radar Size", Flag = "Radar Size",
            Min = 100, Max = 300, Default = 150,
            Callback = function(value) VD.RADAR_Size = value end
        })
        
        radarSection:AddSlider({
            Name = "Radar Range", Flag = "Radar Range",
            Min = 50, Max = 500, Default = 250,
            Callback = function(value) VD.RADAR_Range = value end
        })
        
        radarSection:AddSlider({
            Name = "Radar Transparency", Flag = "Radar Transparency",
            Min = 0, Max = 100, Default = 20,
            Callback = function(value) VD.RADAR_Transparency = value / 100 end
        })
        
        radarSection:AddToggle({
            Default = false,
            Name = "Radar Circle Mode", Flag = "Radar Circle Mode",
            Callback = function(state) VD.RADAR_Circle = state end
        })
        
        local radarFilterSection = radarTab:AddSection({
            Position = "Center",
            Name = "Radar Filters",
            Icon      = "solar:filter-bold",
            Box       = true,
            BoxBorder = true,
            Opened    = false,
        })
        
        radarFilterSection:AddToggle({ Default = false, Name = "Show Killer", Flag = "Radar Show Killer", Callback = function(state) VD.RADAR_ShowKiller = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "Show Survivor", Flag = "Radar Show Survivor", Callback = function(state) VD.RADAR_ShowSurvivor = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "Show Generator", Flag = "Radar Show Generator", Callback = function(state) VD.RADAR_ShowGenerator = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "Show Pallet", Flag = "Radar Show Pallet", Callback = function(state) VD.RADAR_ShowPallet = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "Show Hook", Flag = "Radar Show Hook", Callback = function(state) VD.RADAR_ShowHook = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "Show Gate", Flag = "Radar Show Gate", Callback = function(state) VD.RADAR_ShowGate = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "ShowWindow", Flag = "Radar Show Window", Callback = function(state) VD.RADAR_ShowWindow = state end })
        radarFilterSection:AddToggle({ Default = false, Name = "Show Zombie", Flag = "Radar Show Zombie", Callback = function(state) VD.RADAR_ShowZombie = state end })
    end
end


-- =====================================================
-- REMOVE PALLETWRONG (replaces patched No Pallet Stun)
-- =====================================================
function SetupNoPalletStun()
    pcall(VD_UpdateRemovePalletwrong)
end

-- =====================================================
-- ANTI BLIND (Flashlight)
-- =====================================================
function SetupAntiBlind()
    pcall(function()
        local r  = ReplicatedStorage:FindFirstChild("Remotes")
        local i  = r and r:FindFirstChild("Items")
        local fl = i and i:FindFirstChild("Flashlight")
        local gb = fl and fl:FindFirstChild("GotBlinded")
        if not (gb and gb:IsA("RemoteEvent")) then return end

        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            pcall(function()
                setreadonly(mt, false)
                local old = mt.__namecall
                local _genv = getgenv()
                mt.__namecall = newcclosure(function(self, ...)
                    if not checkcaller() and _genv.VD and _genv.VD.KILLER_AntiBlind and self == gb then
                        local method = getnamecallmethod()
                        if method == "FireServer" and GetRole() == "Killer" then
                            return nil -- Block pengiriman sinyal buta
                        end
                    end
                    return old(self, ...)
                end)
                setreadonly(mt, true)
            end)
        end
    end)
end
pcall(SetupAntiBlind)

-- =====================================================
-- KYST KILLER DISPLAY
-- =====================================================
getgenv().KYS_KystKillerGui = nil
getgenv().KYS_KystKillerRunning = false

function SetupKystKillerIndicator()
    if getgenv().KYS_KystKillerGui then pcall(function() getgenv().KYS_KystKillerGui:Destroy() end) end
    getgenv().KYS_KystKillerGui = nil
    KYS_SetMainInfoPanelText("KystKiller", "Kyst Killer Display", "Waiting...")
end

function StartKystKiller()
    if getgenv().KYS_KystKillerRunning then return end
    getgenv().KYS_KystKillerRunning = true
    SetupKystKillerIndicator()
    task.spawn(function()
        local _genv = getgenv()
        while _genv.VD and _genv.VD.VIS_KystKiller and _genv.KYS_KystKillerRunning do
            local playersList = Players:GetPlayers()
            table.sort(playersList, function(a, b)
                local aA = a:GetAttribute("AllowKiller") or false
                local bB = b:GetAttribute("AllowKiller") or false
                if aA ~= bB then return aA == true end
                return (a:GetAttribute("KillerChance") or 0) > (b:GetAttribute("KillerChance") or 0)
            end)
            
            local nk = playersList[1]
            if nk then
                KYS_SetMainInfoPanelText("KystKiller", "Kyst Killer Display", "Kyst Killer: " .. (nk == LocalPlayer and "YOU" or nk.DisplayName or nk.Name))
            else
                KYS_SetMainInfoPanelText("KystKiller", "Kyst Killer Display", "Kyst Killer: None")
            end
            task.wait(2)
        end
    end)
end

function StopKystKiller()
    getgenv().KYS_KystKillerRunning = false
    if getgenv().KYS_KystKillerGui then
        pcall(function() getgenv().KYS_KystKillerGui:Destroy() end)
        getgenv().KYS_KystKillerGui = nil
    end
    KYS_SetMainInfoPanelText("KystKiller", "Kyst Killer Display", "Off")
end

-- =====================================================
-- SPECTATOR COUNTER
-- =====================================================
if getgenv().KYS_SpectatorCounterGui then
    pcall(function() getgenv().KYS_SpectatorCounterGui:Destroy() end)
end
getgenv().KYS_SpectatorCounterGui = nil
getgenv().KYS_SpectatorCounterRunning = false

function SetupSpectatorCounter()
    if getgenv().KYS_SpectatorCounterGui then pcall(function() getgenv().KYS_SpectatorCounterGui:Destroy() end) end

    local sg = Instance.new("ScreenGui")
    sg.Name = "KYS_SpectatorCounterGui"
    sg.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Name = "CounterFrame"
    frame.Size = UDim2.new(0, 88, 0, 28)
    frame.Position = UDim2.new(0.02, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    frame.BackgroundTransparency = 0.18
    frame.BorderSizePixel = 0
    frame.Parent = sg

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 9)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 1
    stroke.Transparency = 0.35
    stroke.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 8)
    layout.Parent = frame

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://13321848320"
    icon.ImageColor3 = Color3.fromRGB(205, 185, 255)
    icon.Parent = frame

    local label = Instance.new("TextLabel")
    label.Name = "SpectatorCount"
    label.Size = UDim2.new(0, 42, 0, 28)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = "0"
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local pg = GetSafeGuiParent()
    if pg then
        local oldGui = pg:FindFirstChild("KYS_SpectatorCounterGui")
        if oldGui then pcall(function() oldGui:Destroy() end) end
        sg.Parent = pg
    else
        task.spawn(function()
            local pgui = LocalPlayer:WaitForChild("PlayerGui", 10)
            if pgui then sg.Parent = pgui end
        end)
    end

    getgenv().KYS_SpectatorCounterGui = sg
end

function StartSpectatorCounter()
    if getgenv().KYS_SpectatorCounterRunning then return end
    getgenv().KYS_SpectatorCounterRunning = true
    SetupSpectatorCounter()

    task.spawn(function()
        local _genv = getgenv()
        while _genv.VD and _genv.VD.VIS_SpectatorCounter and _genv.KYS_SpectatorCounterRunning and getgenv().KYS_SpectatorCounterGui do
            local sg = getgenv().KYS_SpectatorCounterGui
            if not sg or not sg.Parent then break end

            local count = 0
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Team and player.Team.Name == "Spectator" then
                    count = count + 1
                end
            end

            local label = sg:FindFirstChild("SpectatorCount", true)
            if label then
                label.Text = tostring(count)
            end

            task.wait(1)
        end
    end)
end

function StopSpectatorCounter()
    getgenv().KYS_SpectatorCounterRunning = false
    if getgenv().KYS_SpectatorCounterGui then
        pcall(function() getgenv().KYS_SpectatorCounterGui:Destroy() end)
        getgenv().KYS_SpectatorCounterGui = nil
    end
end

-- =====================================================
-- KILLER PERKS DISPLAY
-- Reads killer perk objects directly from Workspace character models.
-- =====================================================
do -- begin Killer Perks scope
if getgenv().KYS_KillerPerksGui then
    pcall(function() getgenv().KYS_KillerPerksGui:Destroy() end)
end
getgenv().KYS_KillerPerksGui = nil

local KYS_KillerPerksCollapsed = false
local KYS_KillerPerksLocked = false
getgenv().KYS_KillerPerksRunning = false

local KYS_KillerPerkNames = {
    KystInLine = "Kyst in Line",
    ["Kyst in Line"] = "Kyst in Line",
    EchoLocation = "Echo Location",
    ["Echo Location"] = "Echo Location",
    KingsScourge = "King's Scourge",
    KingScourge = "King's Scourge",
    ["King's Scourge"] = "King's Scourge",
}

function KYS_EscapeRichText(text)
    text = tostring(text or "")
    text = text:gsub("&", "&amp;")
    text = text:gsub("<", "&lt;")
    text = text:gsub(">", "&gt;")
    return text
end

local function KYS_FormatPerkName(name)
    name = tostring(name or "")
    if KYS_KillerPerkNames[name] then return KYS_KillerPerkNames[name] end

    local clean = name:gsub("_", " "):gsub("-", " ")
    clean = clean:gsub("(%l)(%u)", "%1 %2")
    clean = clean:gsub("(%a)(%d)", "%1 %2")
    clean = clean:gsub("(%d)(%a)", "%1 %2")
    clean = clean:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    return clean ~= "" and clean or "Unknown Perk"
end

local function KYS_GetKillerPlayer()
    for _, player in ipairs(Players:GetPlayers()) do
        local teamName = player.Team and player.Team.Name
        if teamName and teamName:lower():find("killer") then
            return player
        end
    end
    return nil
end

local function KYS_AddWorkspacePerk(result, seen, rawName, displayName, level)
    if not rawName then return end
    rawName = tostring(rawName)
    if rawName == "" or rawName == "nil" then return end
    if rawName:lower():find("template") then return end
    if seen[rawName] then return end

    seen[rawName] = true
    table.insert(result, {
        Raw = rawName,
        Name = displayName and tostring(displayName) or KYS_FormatPerkName(rawName),
        Level = level and tostring(level) or nil,
    })
end

local function KYS_IsPerkContainer(inst)
    local name = inst.Name:lower()
    return name == "perks"
        or name == "killerperks"
        or name == "equippedperks"
        or name == "equippedkillerperks"
        or name:find("perkfolder") ~= nil
        or name:find("perklist") ~= nil
end

local function KYS_ParseWorkspacePerkName(name)
    name = tostring(name or "")
    local perkName, level = name:match("^(.+)%s+(%d+)$")
    if not perkName then return nil end

    perkName = perkName:gsub("^%s+", ""):gsub("%s+$", "")
    if perkName == "" then return nil end

    local lower = perkName:lower()
    local excluded = {
        head = true,
        torso = true,
        humanoid = true,
        ["left arm"] = true,
        ["right arm"] = true,
        ["left leg"] = true,
        ["right leg"] = true,
        ["humanoidrootpart"] = true,
    }
    if excluded[lower] then return nil end

    return perkName, level
end

local function KYS_ReadPerksFromWorkspace(killer)
    if not killer then return {} end

    local char = killer.Character or Workspace:FindFirstChild(killer.Name) or Workspace:FindFirstChild(killer.DisplayName)
    if not char then return {} end

    local result = {}
    local seen = {}

    local function scanAttributes(inst)
        if not inst.GetAttributes then return end
        local attrs = inst:GetAttributes()
        for key, value in pairs(attrs) do
            local lowerKey = tostring(key):lower()
            if lowerKey:find("perk") then
                if type(value) == "string" then
                    KYS_AddWorkspacePerk(result, seen, value)
                elseif value == true then
                    KYS_AddWorkspacePerk(result, seen, key)
                elseif type(value) == "number" and lowerKey:find("level") then
                    local baseName = tostring(key):gsub("[Ll]evel", ""):gsub("[Pp]erk", "")
                    if baseName ~= "" then
                        KYS_AddWorkspacePerk(result, seen, baseName, nil, value)
                    end
                end
            end
        end
    end

    local function readValueObject(inst)
        if inst:IsA("StringValue") then
            return inst.Value
        elseif inst:IsA("IntValue") or inst:IsA("NumberValue") then
            return inst.Name, inst.Value
        elseif inst:IsA("BoolValue") and inst.Value == true then
            return inst.Name
        end
        return nil
    end

    scanAttributes(char)

    for _, child in ipairs(char:GetChildren()) do
        local perkName, level = KYS_ParseWorkspacePerkName(child.Name)
        if perkName then
            KYS_AddWorkspacePerk(result, seen, child.Name, perkName, level)
        end
    end

    for _, inst in ipairs(char:GetDescendants()) do
        scanAttributes(inst)

        if KYS_IsPerkContainer(inst) then
            for _, child in ipairs(inst:GetChildren()) do
                local value, level = readValueObject(child)
                KYS_AddWorkspacePerk(result, seen, value or child.Name, nil, level)
            end
        else
            local lowerName = inst.Name:lower()
            if lowerName:find("perk") then
                local value, level = readValueObject(inst)
                KYS_AddWorkspacePerk(result, seen, value or inst.Name, nil, level)
            end
        end
    end

    table.sort(result, function(a, b) return tostring(a.Name) < tostring(b.Name) end)
    return result
end

local function KYS_BuildKillerPerksText()
    local killer = KYS_GetKillerPlayer()
    local killerName = killer and (killer.DisplayName or killer.Name) or "Unknown"
    local perks = KYS_ReadPerksFromWorkspace(killer)

    if #perks == 0 then
        for _, player in ipairs(Players:GetPlayers()) do
            local candidatePerks = KYS_ReadPerksFromWorkspace(player)
            if #candidatePerks > 0 then
                killer = player
                killerName = player.DisplayName or player.Name
                perks = candidatePerks
                break
            end
        end
    end

    local lines = {
        'Killer Perks [<font color="rgb(255,80,80)">' .. KYS_EscapeRichText(killerName) .. '</font>]',
    }

    if #perks == 0 then
        table.insert(lines, '<font color="rgb(255,204,80)">- Waiting for perk data...</font>')
    else
        for i = 1, math.min(#perks, 4) do
            local perk = perks[i]
            local levelText = perk.Level and (" lvl " .. tostring(perk.Level)) or ""
            table.insert(lines, '<font color="rgb(255,204,80)">- ' .. KYS_EscapeRichText(perk.Name) .. KYS_EscapeRichText(levelText) .. '</font>')
        end
    end

    return table.concat(lines, "\n"), #perks
end

local function SetupKillerPerksDisplay()
    if getgenv().KYS_KillerPerksGui then pcall(function() getgenv().KYS_KillerPerksGui:Destroy() end) end
    getgenv().KYS_KillerPerksGui = nil
    KYS_SetMainInfoPanelText("KillerPerks", "Spectate Killer Perks", "Waiting for perk data...")
end

function StartKillerPerksDisplay()
    if getgenv().KYS_KillerPerksRunning then return end
    getgenv().KYS_KillerPerksRunning = true
    SetupKillerPerksDisplay()

    task.spawn(function()
        local _genv = getgenv()
        while _genv.VD and _genv.VD.VIS_KillerPerks and _genv.KYS_KillerPerksRunning do
            local text = KYS_BuildKillerPerksText()
            KYS_SetMainInfoPanelText("KillerPerks", "Spectate Killer Perks", text)
            task.wait(1)
        end
    end)
end

function StopKillerPerksDisplay()
    getgenv().KYS_KillerPerksRunning = false
    if getgenv().KYS_KillerPerksGui then
        pcall(function() getgenv().KYS_KillerPerksGui:Destroy() end)
        getgenv().KYS_KillerPerksGui = nil
    end
    KYS_SetMainInfoPanelText("KillerPerks", "Spectate Killer Perks", "Off")
end
end -- end Killer Perks scope

-- =====================================================
-- PREDICT MAP
-- Tries early map data remotes first, then confirms from workspace.Map.
-- =====================================================
do -- begin Predict Map scope
if getgenv().KYS_PredictMapGui then
    pcall(function() getgenv().KYS_PredictMapGui:Destroy() end)
end
if getgenv().KYS_PredictMapConnections then
    for _, conn in ipairs(getgenv().KYS_PredictMapConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
getgenv().KYS_PredictMapGui = nil
getgenv().KYS_PredictMapConnections = {}
getgenv().KYS_PredictMapRunning = false

local KYS_PredictMapState = {
    Name = "Unknown",
    Desc = "Waiting for map data...",
    Source = "Idle",
    Phase = "",
    TimeLeft = nil,
}

local function KYS_MapStringFromValue(value)
    if type(value) == "string" then
        return value
    elseif typeof and typeof(value) == "Instance" then
        return value.Name
    elseif type(value) == "table" then
        return value.Title
            or value.title
            or value.Name
            or value.name
            or value.Map
            or value.map
            or value.MapName
            or value.mapName
            or value.Location
            or value.location
    end
    return nil
end

local function KYS_MapDescFromValue(value)
    if type(value) ~= "table" then return nil end
    return value.Desc or value.desc or value.Description or value.description
end

local function KYS_SetPredictedMap(name, desc, source)
    name = KYS_MapStringFromValue(name) or name
    if not name or tostring(name) == "" then return end
    KYS_PredictMapState.Name = tostring(name)
    if desc and tostring(desc) ~= "" then
        KYS_PredictMapState.Desc = tostring(desc)
    end
    KYS_PredictMapState.Source = source or "Detected"
end

local function KYS_ReadCurrentWorkspaceMap()
    local map = Workspace:FindFirstChild("Map")
    if not map then return nil end

    local camScene = map:FindFirstChild("Camerascene1", true)
    local title = camScene and camScene:GetAttribute("title")
    local desc = camScene and camScene:GetAttribute("desc")
    if title then
        return tostring(title), desc and tostring(desc) or nil
    end

    for _, child in ipairs(map:GetChildren()) do
        local childTitle = child:GetAttribute("title") or child:GetAttribute("Title") or child:GetAttribute("MapName")
        if childTitle then
            return tostring(childTitle), child:GetAttribute("desc") or child:GetAttribute("Description")
        end
    end

    return map.Name ~= "Map" and map.Name or "Map Loaded", nil
end

local function KYS_TryPredictMapRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local mechanics = remotes and remotes:FindFirstChild("Mechanics")
    local chat = mechanics and mechanics:FindFirstChild("Chat")
    local getMapData = chat and chat:FindFirstChild("GetMapData")
    if not (getMapData and getMapData:IsA("RemoteFunction")) then return false end

    local attempts = {
        {},
        { "Current" },
        { "Kyst" },
        { "Map" },
    }

    for _, args in ipairs(attempts) do
        local ok, data = pcall(function()
            return getMapData:InvokeServer(table.unpack(args))
        end)
        if ok and data ~= nil then
            local name = KYS_MapStringFromValue(data)
            local desc = KYS_MapDescFromValue(data)
            if name then
                KYS_SetPredictedMap(name, desc, "Predicted")
                return true
            end
        end
    end

    return false
end

local function KYS_PredictMapText()
    local name = KYS_EscapeRichText(KYS_PredictMapState.Name or "Unknown")
    local source = KYS_EscapeRichText(KYS_PredictMapState.Source or "Idle")
    local phase = tostring(KYS_PredictMapState.Phase or "")
    local timeLeft = KYS_PredictMapState.TimeLeft
    local timerText = ""
    if timeLeft then
        timerText = " [" .. phase .. " " .. tostring(timeLeft) .. "s]"
    elseif phase ~= "" then
        timerText = " [" .. phase .. "]"
    end

    local lines = {
        'Map: <font color="rgb(255,204,80)">' .. name .. '</font>',
        '<font color="rgb(190,170,255)">' .. source .. timerText .. '</font>',
    }

    return table.concat(lines, "\n")
end

local function SetupPredictMapGui()
    if getgenv().KYS_PredictMapGui then pcall(function() getgenv().KYS_PredictMapGui:Destroy() end) end
    getgenv().KYS_PredictMapGui = nil
    KYS_SetMainInfoPanelText("PredictMap", "Predict Map", KYS_PredictMapText())
end

local function KYS_BindPredictMapEvents()
    local conns = getgenv().KYS_PredictMapConnections
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return end

    local messages = remotes:FindFirstChild("Messages")
    local mapInfo = messages and messages:FindFirstChild("Mapinfo")
    if mapInfo and mapInfo:IsA("RemoteEvent") then
        table.insert(conns, mapInfo.OnClientEvent:Connect(function(a, b, c)
            local name = KYS_MapStringFromValue(a) or KYS_MapStringFromValue(b) or KYS_MapStringFromValue(c)
            local desc = KYS_MapDescFromValue(a) or KYS_MapDescFromValue(b) or KYS_MapDescFromValue(c)
            if name then
                KYS_SetPredictedMap(name, desc, "Predicted")
            end
        end))
    end

    local timeEvent = remotes:FindFirstChild("TimeUpdateEvent")
    if timeEvent and timeEvent:IsA("RemoteEvent") then
        table.insert(conns, timeEvent.OnClientEvent:Connect(function(phase, timeLeft)
            KYS_PredictMapState.Phase = tostring(phase or "")
            KYS_PredictMapState.TimeLeft = tonumber(timeLeft)
            if tostring(phase) == "Intermission" and tonumber(timeLeft) and tonumber(timeLeft) <= 20 then
                pcall(KYS_TryPredictMapRemote)
            end
        end))
    end

    table.insert(conns, Workspace.ChildAdded:Connect(function(child)
        if child and child.Name == "Map" then
            task.delay(0.25, function()
                local name, desc = KYS_ReadCurrentWorkspaceMap()
                if name then KYS_SetPredictedMap(name, desc, "Confirmed") end
            end)
        end
    end))
end

function StartPredictMap()
    if getgenv().KYS_PredictMapRunning then return end
    getgenv().KYS_PredictMapRunning = true
    SetupPredictMapGui()
    KYS_BindPredictMapEvents()

    task.spawn(function()
        while VD and VD.VIS_PredictMap and getgenv().KYS_PredictMapRunning do
            local currentName, currentDesc = KYS_ReadCurrentWorkspaceMap()
            if currentName then
                KYS_SetPredictedMap(currentName, currentDesc, "Confirmed")
            else
                pcall(KYS_TryPredictMapRemote)
            end

            KYS_SetMainInfoPanelText("PredictMap", "Predict Map", KYS_PredictMapText())

            task.wait(1)
        end
    end)
end

function StopPredictMap()
    getgenv().KYS_PredictMapRunning = false
    if getgenv().KYS_PredictMapGui then
        pcall(function() getgenv().KYS_PredictMapGui:Destroy() end)
        getgenv().KYS_PredictMapGui = nil
    end
    if getgenv().KYS_PredictMapConnections then
        for _, conn in ipairs(getgenv().KYS_PredictMapConnections) do
            pcall(function() conn:Disconnect() end)
        end
    end
    getgenv().KYS_PredictMapConnections = {}
    KYS_SetMainInfoPanelText("PredictMap", "Predict Map", "Off")
end
end -- end Predict Map scope

-- =====================================================
-- CAMERA / FOV / THIRD PERSON / SHIFT LOCK
-- =====================================================
getgenv().KYS_OriginalFOV          = nil
getgenv().KYS_OriginalCameraType   = nil
getgenv().KYS_OriginalCameraOffset = nil
getgenv().KYS_ThirdPersonWasActive = false
getgenv().KYS_FOVWasActive         = false

function UpdateCameraFOV()
    local cam = workspace.CurrentCamera
    if not cam then return end

    if VD.CAM_FOVEnabled then
        if not getgenv().KYS_FOVWasActive then
            getgenv().KYS_OriginalFOV = cam.FieldOfView
            getgenv().KYS_FOVWasActive = true
        end
        cam.FieldOfView = VD.CAM_FOV or 90
    elseif getgenv().KYS_FOVWasActive then
        if getgenv().KYS_OriginalFOV then cam.FieldOfView = getgenv().KYS_OriginalFOV end
        getgenv().KYS_OriginalFOV = nil
        getgenv().KYS_FOVWasActive = false
    end
end

function UpdateThirdPerson()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local shouldBeActive = VD.CAM_ThirdPerson and GetRole() == "Killer"
    if shouldBeActive then
        if not getgenv().KYS_ThirdPersonWasActive then
            getgenv().KYS_OriginalCameraType = cam.CameraType
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            getgenv().KYS_OriginalCameraOffset = hum and hum.CameraOffset or Vector3.new(0, 0, 0)
        end
        cam.CameraType = Enum.CameraType.Custom
        local char     = LocalPlayer.Character
        local hum      = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.CameraOffset = Vector3.new(2, 1, 8) end
        getgenv().KYS_ThirdPersonWasActive = true
    elseif getgenv().KYS_ThirdPersonWasActive then
        if getgenv().KYS_OriginalCameraType then
            cam.CameraType = getgenv().KYS_OriginalCameraType; getgenv().KYS_OriginalCameraType = nil
        end
        local char = LocalPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.CameraOffset = getgenv().KYS_OriginalCameraOffset or Vector3.new(0, 0, 0) end
        getgenv().KYS_OriginalCameraOffset = nil
        getgenv().KYS_ThirdPersonWasActive = false
    end
end

getgenv().KYS_shiftLockWasActive = false

function UpdateShiftLock()
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local cam  = workspace.CurrentCamera

    if VD.CAM_ShiftLock then
        if not char or not root or not cam then return end

        -- Matikan rotasi bawaan game saat jalan
        if hum then hum.AutoRotate = false end
        getgenv().KYS_shiftLockWasActive = true

        local flatLook = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
        -- Cegah NaN kalau arah kamera tegak lurus ke atas/bawah
        if flatLook.Magnitude > 0.001 then
            local lookUnit = flatLook.Unit
            root.CFrame = CFrame.new(root.Position, root.Position + lookUnit)
        end
    else
        -- Kembalikan rotasi bawaan kalau shiftlock dimatikan
        if getgenv().KYS_shiftLockWasActive then
            if hum then hum.AutoRotate = true end
            getgenv().KYS_shiftLockWasActive = false
        end
    end
end

-- =====================================================
-- NO FOG
-- =====================================================
getgenv().KYS_FogCache = {}

function RemoveFog()
    pcall(function()
        local map = Workspace:FindFirstChild("Map")
        if map then
            for _, obj in ipairs(map:GetDescendants()) do
                if obj.Name:lower():find("fog") or obj:IsA("Atmosphere") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") then
                    if not getgenv().KYS_FogCache[obj] then
                        getgenv().KYS_FogCache[obj] = {
                            enabled = obj:IsA("PostEffect") and obj.Enabled or true,
                            parent =
                                obj.Parent
                        }
                    end
                    if obj:IsA("PostEffect") then obj.Enabled = false else obj.Parent = nil end
                end
            end
        end
    end)
    pcall(function()
        local lt = game:GetService("Lighting")
        for _, obj in ipairs(lt:GetChildren()) do
            if obj:IsA("Atmosphere") or obj.Name:lower():find("fog") then
                if not getgenv().KYS_FogCache[obj] then getgenv().KYS_FogCache[obj] = { enabled = true, parent = obj.Parent } end
                if obj:IsA("Atmosphere") then obj.Density = 0 else obj.Parent = nil end
            end
        end
        lt.FogEnd   = 100000
        lt.FogStart = 0
    end)
end

function RestoreFog()
    pcall(function()
        for obj, data in pairs(getgenv().KYS_FogCache) do
            if obj and data.parent then
                if obj:IsA("PostEffect") then obj.Enabled = data.enabled else obj.Parent = data.parent end
            end
        end
        getgenv().KYS_FogCache = {}
        game:GetService("Lighting").FogEnd = 1000
    end)
end

-- =====================================================
-- NO SLOWDOWN
-- =====================================================
function UpdateNoSlowdown()
    if not VD.KILLER_NoSlowdown or GetRole() ~= "Killer" then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.WalkSpeed < 16 then hum.WalkSpeed = VD.SPEED_Value or 16 end
end

-- =====================================================
-- KUNCI KECEPATAN / ANTI BEKU (__newindex Hook)
-- =====================================================
function SetupAntiStunSlowdown()
    if getgenv().KYS_AntiStunHooked then return end
    getgenv().KYS_AntiStunHooked = true

    pcall(function()
        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            pcall(function()
                setreadonly(mt, false)
                local oldNI = mt.__newindex
                local _genv = getgenv()
                mt.__newindex = newcclosure(function(t, k, v)
                    if k == "WalkSpeed" or k == "Anchored" then
                        if not checkcaller() and _genv.VD and _genv.VD.KILLER_NoSlowdown and GetRole() == "Killer" then
                            -- Cegah perintah yang mengurangi WalkSpeed drastis (Efek Stun/Kesandung)
                            if k == "WalkSpeed" and typeof(v) == "number" and v < 16 and typeof(t) == "Instance" and t:IsA("Humanoid") then
                                return oldNI(t, k, _genv.VD.SPEED_Value or 16)
                            end
                            -- Cegah perintah yang membekukan posisi karakter (Anchored Stun)
                            if k == "Anchored" and v == true and typeof(t) == "Instance" and t:IsA("BasePart") and t.Name == "HumanoidRootPart" then
                                return oldNI(t, k, false)
                            end
                        end
                    end
                    return oldNI(t, k, v)
                end)
                setreadonly(mt, true)
            end)
        end
    end)
end
task.spawn(SetupAntiStunSlowdown)

-- =====================================================
-- FOV CIRCLE
-- =====================================================
local FOVCircle = nil
if DrawingAvailable then
    FOVCircle = SafeDrawing("Circle")
    if FOVCircle then
        FOVCircle.Thickness    = 1
        FOVCircle.Color        = Color3.fromRGB(220, 70, 70)
        FOVCircle.Filled       = false
        FOVCircle.NumSides     = 64
        FOVCircle.Transparency = 0.8
        FOVCircle.Visible      = false
    end
end

-- =====================================================
-- NO CUTSCENE BYPASS & HOOK
-- =====================================================
local fakeBindable = Instance.new("BindableEvent")
local fakeRemote = Instance.new("RemoteEvent")

function SetupNoCutsceneHook()
    if getgenv().KYS_NoCutsceneHooked then return end
    getgenv().KYS_NoCutsceneHooked = true

    pcall(function()
        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            pcall(function()
                setreadonly(mt, false)
                local oldIndex = mt.__index
                local _genv = getgenv()
                
                mt.__index = newcclosure(function(t, k)
                    if k == "OnClientEvent" or k == "Event" then
                        if _genv.VD and _genv.VD.NoCutscene and not checkcaller() and typeof(t) == "Instance" then
                            local name = t.Name
                            if name == "cutscene" and k == "Event" then
                                local parent = t.Parent
                                if parent and parent.Name == "Game" then
                                    return fakeBindable.Event
                                end
                            elseif (name == "cutsceneEnd" or name == "cutsceneEnd2" or name == "cutsceneEndwithownchar" or name == "endscreencutscene") then
                                local parent = t.Parent
                                if parent and parent.Name == "Game" then
                                    return fakeRemote.OnClientEvent
                                end
                            end
                        end
                    end
                    return oldIndex(t, k)
                end)
                setreadonly(mt, true)
            end)
        end
    end)
end

function KYS_SetupNoCutsceneListeners()
    task.spawn(function()
        local gameFolder = ReplicatedStorage:WaitForChild("Remotes", 10):WaitForChild("Game", 10)
        if not gameFolder then return end
        
        local endscreencutscene = gameFolder:WaitForChild("endscreencutscene", 10)
        local cutsceneEnd = gameFolder:WaitForChild("cutsceneEnd", 10)
        local cutsceneEnd2 = gameFolder:WaitForChild("cutsceneEnd2", 10)
        local cutsceneEndwithownchar = gameFolder:WaitForChild("cutsceneEndwithownchar", 10)
        
        function showInstantResults()
            if not getgenv().VD or not getgenv().VD.NoCutscene then return end
            
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CameraType = Enum.CameraType.Custom
                    cam.FieldOfView = 70
                end
                game:GetService("UserInputService").MouseIconEnabled = true
                pcall(function() game:GetService("SoundService"):WaitForChild("chase").Volume = 0 end)
                LocalPlayer:SetAttribute("isspectating", true)
                
                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                if pg then
                    local Results = pg:FindFirstChild("Results")
                    local EndScreen = pg:FindFirstChild("EndScreen")
                    local Darkness = pg:FindFirstChild("Darkness")
                    
                    if Results then Results.Enabled = true end
                    if EndScreen then 
                        EndScreen.Enabled = true 
                        local blackout = EndScreen:FindFirstChild("blackout")
                        if blackout then blackout.BackgroundTransparency = 1 end
                    end
                    if Darkness then
                        Darkness.Enabled = true
                        local frame2 = Darkness:FindFirstChild("Frame2")
                        if frame2 then frame2.BackgroundTransparency = 1 end
                    end
                end
            end)
        end
        
        if endscreencutscene then endscreencutscene.OnClientEvent:Connect(showInstantResults) end
        if cutsceneEnd then cutsceneEnd.OnClientEvent:Connect(showInstantResults) end
        if cutsceneEnd2 then cutsceneEnd2.OnClientEvent:Connect(showInstantResults) end
        if cutsceneEndwithownchar then cutsceneEndwithownchar.OnClientEvent:Connect(showInstantResults) end
    end)
end

task.spawn(SetupNoCutsceneHook)
task.spawn(KYS_SetupNoCutsceneListeners)

-- =====================================================
-- RENDERSTEP: Drawing ESP / Aimbot / Camera
-- =====================================================
function OnRenderStep()
    if VD.Destroyed then
        if DrawingAvailable then
            if FOVCircle then SafeRemove(FOVCircle) end
        end
        return
    end

    Camera = Workspace.CurrentCamera or Camera
    local cam = Camera
    if not cam then return end
    local screenSize   = cam.ViewportSize
    local screenCenter = Vector2.new(screenSize.X / 2, screenSize.Y / 2)

    -- Aimbot
    pcall(function()
        if VD.AIM_Enabled then
            Aimbot.Update(cam, cam.ViewportSize, Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2))
        end
    end)

    pcall(UpdateSpearAim)
    UpdateCameraFOV()
    UpdateThirdPerson()
    UpdateShiftLock()

    -- FOV circle
    if FOVCircle and DrawingAvailable then
        if VD.AIM_Enabled and VD.AIM_ShowFOV then
            FOVCircle.Position = screenCenter
            FOVCircle.Radius   = VD.AIM_FOV or 120
            FOVCircle.Color    = State.AimTarget and Color3.fromRGB(90, 220, 120) or Color3.fromRGB(220, 70, 70)
            FOVCircle.Visible  = true
        else
            FOVCircle.Visible = false
        end
    end
end


-- =====================================================
-- MOBILE GUI (Aimbot Button + FOV Circle)
-- =====================================================
getgenv().KYS_MobileGui = getgenv().KYS_MobileGui or { AimBtn=nil, FOVFrame=nil, FOVStroke=nil }

function CreateMobileUI()
    local pg = GetSafeGuiParent()
    if not pg then return end

    -- === MAIN SCREENGUI ===
    local sg = Instance.new("ScreenGui")
    sg.Name           = "KYS_MobileUI"
    sg.ResetOnSpawn   = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 100
    sg.Parent         = pg
    -- === FOV CIRCLE ===
    local fovF = Instance.new("Frame")
    fovF.Name                 = "FOVCircle"
    fovF.BackgroundTransparency = 1
    fovF.AnchorPoint          = Vector2.new(0.5,0.5)
    fovF.Position             = UDim2.new(0.5,0,0.5,0)
    fovF.Size                 = UDim2.new(0,240,0,240)
    fovF.Visible              = false
    fovF.Parent               = sg
    Instance.new("UICorner", fovF).CornerRadius = UDim.new(1,0)
    local fovStk = Instance.new("UIStroke")
    fovStk.Color = Color3.fromRGB(220,70,70); fovStk.Thickness = 1.5; fovStk.Transparency = 0.2
    fovStk.Parent = fovF
    getgenv().KYS_MobileGui.FOVFrame = fovF; getgenv().KYS_MobileGui.FOVStroke = fovStk

    -- === AIMBOT BUTTON (ScreenGui terpisah agar AlwaysOnTop) ===
    local aimSG = Instance.new("ScreenGui")
    aimSG.Name           = "KYS_AimBtn"
    aimSG.ResetOnSpawn   = false
    aimSG.IgnoreGuiInset = true
    aimSG.ZIndexBehavior = Enum.ZIndexBehavior.AlwaysOnTop
    aimSG.Parent         = pg
    local btn = Instance.new("TextButton")
    btn.Name                = "AimHold"
    btn.Size                = UDim2.new(0,75,0,75)
    btn.Position            = UDim2.new(1,-95,1,-170)
    btn.BackgroundColor3    = Color3.fromRGB(200,55,55)
    btn.BackgroundTransparency = 0.2
    btn.Text                = "🎯\nAIM"
    btn.TextColor3          = Color3.new(1,1,1)
    btn.TextSize            = 14
    btn.Font                = Enum.Font.GothamBold
    btn.Visible             = false
    btn.ZIndex              = 20
    btn.Parent              = aimSG
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    local aStk = Instance.new("UIStroke")
    aStk.Color = Color3.fromRGB(255,100,100); aStk.Thickness = 2; aStk.Parent = btn

    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            State.AimHolding = true
            btn.BackgroundColor3 = Color3.fromRGB(50,200,80)
            aStk.Color = Color3.fromRGB(50,230,80)
        end
    end)
    btn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            State.AimHolding = false; State.AimTarget = nil
            btn.BackgroundColor3 = Color3.fromRGB(200,55,55)
            aStk.Color = Color3.fromRGB(255,100,100)
        end
    end)
    getgenv().KYS_MobileGui.AimBtn = btn
end

-- =====================================================
-- SPEAR AIMBOT MOBILE FLOATING BUTTON
-- =====================================================
SpearBtnData = {
    UI = nil,
    Button = nil,
    Active = true,
    DragLocked = false,
    Dragging = false,
    DragStart = nil,
    DragStartPos = nil,
    ManualTarget = nil,   -- Player yang dipilih manual lewat panah, nil = auto (terdekat)
    TargetIndex = 0,
    TargetLabel = nil,    -- label kecil nampilin nama target / "AUTO"
    LeftArrow = nil,
    RightArrow = nil,
}

function setupSpearAimbotBtn()
    if SpearBtnData.UI then pcall(function() SpearBtnData.UI:Destroy() end) end

    local player = game:GetService("Players").LocalPlayer
    local pg = player:WaitForChild("PlayerGui")

    SpearBtnData.UI = Instance.new("ScreenGui")
    SpearBtnData.UI.Name = "SpearAimbotUI"
    SpearBtnData.UI.ResetOnSpawn = false
    SpearBtnData.UI.IgnoreGuiInset = true
    SpearBtnData.UI.Parent = pg

    -- Main toggle button
    SpearBtnData.Button = Instance.new("TextButton")
    SpearBtnData.Button.Name = "SpearAimbotButton"
    SpearBtnData.Button.Size = UDim2.new(0, 65, 0, 65)
    SpearBtnData.Button.Position = UDim2.new(0.15, 0, 0.75, 0)
    SpearBtnData.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    SpearBtnData.Button.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    SpearBtnData.Button.BackgroundTransparency = 0.15
    SpearBtnData.Button.AutoButtonColor = true
    SpearBtnData.Button.Text = "SPEAR\nAIM"
    SpearBtnData.Button.TextColor3 = Color3.fromRGB(255, 100, 100)
    SpearBtnData.Button.TextSize = 11
    SpearBtnData.Button.Font = Enum.Font.GothamBold
    SpearBtnData.Button.Visible = false
    SpearBtnData.Button.ZIndex = 10
    SpearBtnData.Button.Parent = SpearBtnData.UI
    Instance.new("UICorner", SpearBtnData.Button).CornerRadius = UDim.new(1, 0)

    local spearStk = Instance.new("UIStroke", SpearBtnData.Button)
    spearStk.Color = Color3.fromRGB(255, 80, 80)
    spearStk.Thickness = 2
    spearStk.Transparency = 0.2

    -- Lock/Unlock drag button (small, top-right corner)
    local lockBtn = Instance.new("TextButton")
    lockBtn.Name = "LockDrag"
    lockBtn.Size = UDim2.new(0, 22, 0, 22)
    lockBtn.Position = UDim2.new(1, -5, 0, -5)
    lockBtn.AnchorPoint = Vector2.new(1, 0)
    lockBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    lockBtn.BackgroundTransparency = 0.3
    lockBtn.Text = "L"
    lockBtn.TextSize = 10
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.TextColor3 = Color3.new(1, 1, 1)
    lockBtn.ZIndex = 11
    lockBtn.Parent = SpearBtnData.Button
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(1, 0)

    lockBtn.MouseButton1Click:Connect(function()
        SpearBtnData.DragLocked = not SpearBtnData.DragLocked
        lockBtn.Text = SpearBtnData.DragLocked and "X" or "L"
        lockBtn.BackgroundColor3 = SpearBtnData.DragLocked and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(60, 60, 60)
    end)

    -- Target label (nampilin nama target aktif / "AUTO"), muncul di atas tombol utama
    local targetLabel = Instance.new("TextLabel")
    targetLabel.Name = "SpearTargetLabel"
    targetLabel.Size = UDim2.new(0, 90, 0, 18)
    targetLabel.Position = UDim2.new(0.5, 0, 0, -22)
    targetLabel.AnchorPoint = Vector2.new(0.5, 0)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Text = "AUTO"
    targetLabel.TextColor3 = Color3.fromRGB(255, 220, 220)
    targetLabel.TextSize = 12
    targetLabel.Font = Enum.Font.GothamBold
    targetLabel.TextTruncate = Enum.TextTruncate.AtEnd
    targetLabel.ZIndex = 11
    targetLabel.Visible = false
    targetLabel.Parent = SpearBtnData.Button
    SpearBtnData.TargetLabel = targetLabel

    -- Tombol panah kiri: ganti target ke arah sebelumnya di daftar
    local leftArrow = Instance.new("TextButton")
    leftArrow.Name = "SpearTargetLeft"
    leftArrow.Size = UDim2.new(0, 28, 0, 28)
    leftArrow.Position = UDim2.new(0, -34, 0.5, 0)
    leftArrow.AnchorPoint = Vector2.new(0.5, 0.5)
    leftArrow.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    leftArrow.BackgroundTransparency = 0.15
    leftArrow.Text = "<"
    leftArrow.TextColor3 = Color3.fromRGB(255, 150, 150)
    leftArrow.TextSize = 16
    leftArrow.Font = Enum.Font.GothamBold
    leftArrow.ZIndex = 10
    leftArrow.Parent = SpearBtnData.Button
    Instance.new("UICorner", leftArrow).CornerRadius = UDim.new(1, 0)
    local leftStk = Instance.new("UIStroke", leftArrow)
    leftStk.Color = Color3.fromRGB(255, 80, 80)
    leftStk.Thickness = 1.5
    leftStk.Transparency = 0.3
    SpearBtnData.LeftArrow = leftArrow

    leftArrow.MouseButton1Click:Connect(function()
        pcall(CycleSpearTarget, -1)
    end)

    -- Tombol panah kanan: ganti target ke arah berikutnya di daftar
    local rightArrow = Instance.new("TextButton")
    rightArrow.Name = "SpearTargetRight"
    rightArrow.Size = UDim2.new(0, 28, 0, 28)
    rightArrow.Position = UDim2.new(1, 34, 0.5, 0)
    rightArrow.AnchorPoint = Vector2.new(0.5, 0.5)
    rightArrow.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    rightArrow.BackgroundTransparency = 0.15
    rightArrow.Text = ">"
    rightArrow.TextColor3 = Color3.fromRGB(255, 150, 150)
    rightArrow.TextSize = 16
    rightArrow.Font = Enum.Font.GothamBold
    rightArrow.ZIndex = 10
    rightArrow.Parent = SpearBtnData.Button
    Instance.new("UICorner", rightArrow).CornerRadius = UDim.new(1, 0)
    local rightStk = Instance.new("UIStroke", rightArrow)
    rightStk.Color = Color3.fromRGB(255, 80, 80)
    rightStk.Thickness = 1.5
    rightStk.Transparency = 0.3
    SpearBtnData.RightArrow = rightArrow

    rightArrow.MouseButton1Click:Connect(function()
        pcall(CycleSpearTarget, 1)
    end)

    -- Drag logic
    SpearBtnData.Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if SpearBtnData.DragLocked then return end
            SpearBtnData.Dragging = true
            SpearBtnData.DragStart = input.Position
            SpearBtnData.DragStartPos = SpearBtnData.Button.Position
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if SpearBtnData.Dragging and not SpearBtnData.DragLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - SpearBtnData.DragStart
            SpearBtnData.Button.Position = UDim2.new(
                SpearBtnData.DragStartPos.X.Scale, SpearBtnData.DragStartPos.X.Offset + delta.X,
                SpearBtnData.DragStartPos.Y.Scale, SpearBtnData.DragStartPos.Y.Offset + delta.Y
            )
        end
    end)

    SpearBtnData.Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            SpearBtnData.Dragging = false
        end
    end)

    -- Toggle Spear Aimbot function on/off (GUI stays visible)
    SpearBtnData.Button.MouseButton1Click:Connect(function()
        SpearBtnData.Active = not SpearBtnData.Active
        if SpearBtnData.Active then
            SpearBtnData.Button.BackgroundColor3 = Color3.fromRGB(10, 40, 10)
            SpearBtnData.Button.TextColor3 = Color3.fromRGB(80, 255, 120)
            spearStk.Color = Color3.fromRGB(80, 255, 120)
            pcall(VD_Notify, "Spear Aimbot", "Spear Aimbot AKTIF!", 3)
        else
            SpearBtnData.Button.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
            SpearBtnData.Button.TextColor3 = Color3.fromRGB(255, 100, 100)
            spearStk.Color = Color3.fromRGB(255, 80, 80)
            pcall(VD_Notify, "Spear Aimbot", "Spear Aimbot NONAKTIF", 3)
        end
    end)
    
    print("[KysHub crack] Spear Aimbot Button created successfully")
end

task.spawn(function()
    task.wait(3)
    setupSpearAimbotBtn()
end)

function UpdateMobileFOV()
    if not getgenv().KYS_MobileGui.FOVFrame then return end
    if VD.AIM_Enabled and VD.AIM_ShowFOV then
        local r = (VD.AIM_FOV or 120)
        getgenv().KYS_MobileGui.FOVFrame.Size = UDim2.new(0, r*2, 0, r*2)
        getgenv().KYS_MobileGui.FOVStroke.Color = State.AimTarget and Color3.fromRGB(90,220,120) or Color3.fromRGB(220,70,70)
        getgenv().KYS_MobileGui.FOVFrame.Visible = true
    else
        getgenv().KYS_MobileGui.FOVFrame.Visible = false
    end
end

task.spawn(function()
    task.wait(2)
    pcall(CreateMobileUI)
end)

-- =====================================================
-- RENDER LOOP: PC (RenderStepped, pakai Drawing)
-- =====================================================
if DrawingAvailable then
    RunService.RenderStepped:Connect(OnRenderStep)
end
RunService.RenderStepped:Connect(function()
    pcall(VD_RunCrosshairLoop)
end)

-- =====================================================
-- HEARTBEAT UNIVERSAL: Berjalan di PC & Mobile
-- =====================================================
RunService.Heartbeat:Connect(function(deltaTime)
    if VD.Destroyed then return end
    local cam = workspace.CurrentCamera
    if not cam then return end



    if not DrawingAvailable and (not getgenv().KYS_MobileGui.FOVFrame or not getgenv().KYS_MobileGui.FOVFrame.Parent) then
        pcall(CreateMobileUI)
    end

    if not DrawingAvailable then
        UpdateCameraFOV()
        UpdateThirdPerson()
        UpdateShiftLock()
        pcall(UpdateSpearAim)
    end
    if not DrawingAvailable and VD.AIM_Enabled and State.AimHolding then
        local sc = cam.ViewportSize
        pcall(function() Aimbot.Update(cam, sc, Vector2.new(sc.X/2, sc.Y/2)) end)
    end


    if not DrawingAvailable then
        if getgenv().KYS_MobileGui.AimBtn then getgenv().KYS_MobileGui.AimBtn.Visible = VD.AIM_Enabled end
        pcall(UpdateMobileFOV)
    end
    -- Spear Aimbot button: always update (works on all executors)
    if SpearBtnData and SpearBtnData.Button then
        local spearVisible = (VD.SPEAR_Aimbot and GetRole() == "Killer")
        SpearBtnData.Button.Visible = spearVisible
        if spearVisible then pcall(UpdateSpearTargetLabel) end
    end
    pcall(UpdateRadar)
    pcall(VD_RunAntiKnock)
    pcall(VD_UpdateSurvivorWarnings)
    pcall(VD_UpdateBypassGate)
    pcall(VD_UpdateInfiniteLunge)
    pcall(VD_UpdateWeatherAnchor)
    pcall(VD_UpdateInvisibleNotVisual)
    pcall(VD_UpdateMoonwalk, deltaTime)
    pcall(VD_UpdateRemovePalletwrong)
end)

-- =====================================================
getgenv().KYS_SyncLoadedFeatures = function()

    -- Sync Killer Modifiers
    if type(SetupAntiBlind) == "function" then pcall(SetupAntiBlind) end
    if type(SetupNoPalletStun) == "function" then pcall(SetupNoPalletStun) end
    if type(VD_UpdateCrosshair) == "function" then pcall(VD_UpdateCrosshair) end
    
    -- Sync Kyst Killer Display
    if VD.VIS_KystKiller then
        pcall(StartKystKiller)
    else
        pcall(StopKystKiller)
    end

    -- Sync Spectator Counter
    if VD.VIS_SpectatorCounter then
        pcall(StartSpectatorCounter)
    else
        pcall(StopSpectatorCounter)
    end

    -- Sync Killer Perks Display
    if VD.VIS_KillerPerks then
        pcall(StartKillerPerksDisplay)
    else
        pcall(StopKillerPerksDisplay)
    end

    -- Sync Predict Map
    if VD.VIS_PredictMap then
        pcall(StartPredictMap)
    else
        pcall(StopPredictMap)
    end

    -- Sync Hide Survivor Icon
    if getgenv().KYS_SetHideSurvivorIcon then
        pcall(getgenv().KYS_SetHideSurvivorIcon, VD.VIS_HideSurvivorIcon)
    end

    -- Sync Ping & FPS Display
    if getgenv().KYS_SetShowPingFPS then
        pcall(getgenv().KYS_SetShowPingFPS, VD.VIS_ShowPingFPS)
    end

    -- Sync Hook Counter
    if getgenv().KYS_SetShowHookCounter then
        pcall(getgenv().KYS_SetShowHookCounter, VD.VIS_ShowHookCounter)
    end

    -- Sync Twist of Fate silent aim
    if getgenv().KYS_SetToFSilentAim then
        pcall(getgenv().KYS_SetToFSilentAim, VD.TOF_SilentAim)
    end

    -- Sync Flashlight silent aim
    if getgenv().KYS_SetFlashlightSilentAim then
        pcall(getgenv().KYS_SetFlashlightSilentAim, VD.FLASH_SilentAim)
    end

    -- Sync Moonwalk external button
    if getgenv().VD_SetMoonwalkButtonVisible then
        pcall(getgenv().VD_SetMoonwalkButtonVisible, VD.MoonwalkButton)
    end

    -- Sync Hidden Cooldown Bypass
    if VD.KILLER_BypassLeap then
        pcall(KYS_StartHiddenCooldownBypass)
    end
end

;(function()
local function readConfigElementValue(flagName)
    local elem = Window and Window.ConfigElements and Window.ConfigElements[flagName]
    if not elem then return nil end

    local ok, value = pcall(function()
        if type(elem.Get) == "function" then return elem:Get() end
        if type(elem.GetValue) == "function" then return elem:GetValue() end
        if elem.Value ~= nil then return elem.Value end
        if elem.CurrentValue ~= nil then return elem.CurrentValue end
        if elem.State ~= nil then return elem.State end
        if elem.Enabled ~= nil then return elem.Enabled end
        if elem.Default ~= nil then return elem.Default end
        if type(elem.Config) == "table" then
            if elem.Config.Value ~= nil then return elem.Config.Value end
            if elem.Config.Default ~= nil then return elem.Config.Default end
        end
    end)

    if ok then return value end
    return nil
end

getgenv().KYS_SyncUILibraryConfigRuntime = function()
    local tofValue = readConfigElementValue("Silent Aim Twist Of Fate")
    if type(tofValue) == "boolean" and tofValue ~= VD.TOF_SilentAim and getgenv().KYS_SetToFSilentAim then
        pcall(getgenv().KYS_SetToFSilentAim, tofValue)
    elseif type(tofValue) == "boolean" then
        VD.TOF_SilentAim = tofValue
        if tofValue and getgenv().KYS_SetToFSilentAim then
            pcall(getgenv().KYS_SetToFSilentAim, true)
        end
    end

    local flashValue = readConfigElementValue("Silent Aim Flashlight")
    if type(flashValue) == "boolean" and flashValue ~= VD.FLASH_SilentAim and getgenv().KYS_SetFlashlightSilentAim then
        pcall(getgenv().KYS_SetFlashlightSilentAim, flashValue)
    elseif type(flashValue) == "boolean" then
        VD.FLASH_SilentAim = flashValue
        if flashValue and getgenv().KYS_SetFlashlightSilentAim then
            pcall(getgenv().KYS_SetFlashlightSilentAim, true)
        end
    end
end

task.spawn(function()
    local lastToF, lastFlash = nil, nil
    while getgenv().VD and not getgenv().VD.Destroyed do
        local tofValue = readConfigElementValue("Silent Aim Twist Of Fate")
        local flashValue = readConfigElementValue("Silent Aim Flashlight")

        if type(tofValue) == "boolean" and tofValue ~= lastToF then
            lastToF = tofValue
            if getgenv().KYS_SetToFSilentAim then
                pcall(getgenv().KYS_SetToFSilentAim, tofValue)
            else
                VD.TOF_SilentAim = tofValue
            end
        end

        if type(flashValue) == "boolean" and flashValue ~= lastFlash then
            lastFlash = flashValue
            if getgenv().KYS_SetFlashlightSilentAim then
                pcall(getgenv().KYS_SetFlashlightSilentAim, flashValue)
            else
                VD.FLASH_SilentAim = flashValue
            end
        end

        task.wait(1)
    end
end)
end)();
end
__KysHub_Init_Main__()
-- =============================================
-- ПАТЧ ДЛЯ ОТКЛЮЧЕНИЯ PREMIUM (вставить в конец)
-- =============================================
local function KillPremium()
    -- 1. Блокируем все уведомления о Premium
    local oldNotify = VD_Notify
    VD_Notify = function(title, content, duration)
        if content and tostring(content):find("Premium") then return end
        if oldNotify then oldNotify(title, content, duration) end
    end

    -- 2. Перехватываем добавление UI-элементов и удаляем у них Locked/TextLocked
    local mt = getrawmetatable(game)
    if mt then
        local oldIndex = mt.__index
        local oldNewIndex = mt.__newindex
        local blocked = { Locked = true, TextLocked = true }

        setreadonly(mt, false)
        mt.__index = function(t, k)
            if blocked[k] and type(t) == "table" and t.Name and t.Name:find("Premium") then
                return nil
            end
            return oldIndex(t, k)
        end

        mt.__newindex = function(t, k, v)
            if blocked[k] and type(t) == "table" then
                return -- не даём записать
            end
            return oldNewIndex(t, k, v)
        end
        setreadonly(mt, true)
    end

    -- 3. Отключаем саму проверку в функциях-обработчиках
    --    (через перехват метамтода __call у функций-замыканий – сложно, но не нужно)
    print("[KysHub] Premium-ограничения отключены.")
end

task.spawn(KillPremium)
