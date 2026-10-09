if not game:IsLoaded() then
    game.Loaded:Wait()
end
-----
pcall(function() setfflag("AdornShadingAPI", "true") end)
task.wait(2) 
local Players = game:GetService("Players")
if not Players.LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse() 
local function HookVFX()
    local RS = game:GetService("ReplicatedStorage")
    local VFXLibPos = RS:FindFirstChild("Components") and RS.Components:FindFirstChild("Common") and RS.Components.Common:FindFirstChild("VFXLibary") 
    if not VFXLibPos then 
        VFXLibPos = RS:FindFirstChild("Components") and RS.Components:FindFirstChild("Common") and RS.Components.Common:FindFirstChild("VFXLibrary")
    end
    if VFXLibPos then
        local success, lib = pcall(require, VFXLibPos)
        if success and lib and lib.CreateTracer then
            local oldCreateTracer = lib.CreateTracer
            lib.CreateTracer = function(self, ...)
                local args = {...}
                local s, err = pcall(function()
                     oldCreateTracer(self, unpack(args))
                end)
            end
        end
    end
end
-- task.spawn(HookVFX)
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local IsMobile = UserInputService.TouchEnabled
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local BacktrackHistory = {} 
_G.LoadStage = 0 
local Window = nil
local Library = nil
local Network = nil
local Packet_UpdateLookAngle = nil
local Packet_ShootWeapon = nil
local Packet_UpdateState = nil
local _isProcessing = false
_G.Config = {
    Esp = false, 
    EspBoxes = false, 
    EspNames = false, 
    EspHealthBar = false, 
    EspDistance = false, 
    EspTracers = false,  
    EspHeadDot = false,
    EspWeapon = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    HealthBarColor = Color3.fromRGB(0, 255, 0),
    DistColor = Color3.fromRGB(255, 255, 255),
    TracerColor = Color3.fromRGB(255, 255, 255),
    HeadDotColor = Color3.fromRGB(255, 0, 0),
    WeaponColor = Color3.fromRGB(255, 255, 255),
    EnemyColor = Color3.fromRGB(150, 200, 60),
    TeammateColor = Color3.fromRGB(60, 150, 200),
    EspTeamMode = "Enemies",
    UseTeamCheck = false,
    SilentAim = false,
    NoSpread = false,
    ShowTracers = false,
    PlayHitSound = false,
    ShowHitLogs = false,
    ShowPenetration = false, 
    FovRadius = 100,
    ShowFov = false,
    AimPart = "Head",
    HeadOnly = false,
    ShowHitmark = false,
    NoRecoilVisual = true, 
    NoRecoilReal = true,   
    CustomFov = 90, 
    EnableFov = false,
    WorldSkyboxEnabled = false,
    WorldSkybox = "Standard",
    WorldTimeEnabled = false,
    WorldClockTime = 12,
    WorldBrightEnabled = false,
    WorldBrightness = 2,
    WorldAmbient = Color3.fromRGB(127, 127, 127),
    WorldOutdoorAmbient = Color3.fromRGB(127, 127, 127),
    Bhop = false,
    BhopSpeed = 18,
    NoFallDamage = false, 
    NoFlash = false, 
    NoSmoke = false, 
    ColoredSmoke = false, 
    CustomParticles = false, 
    ParticleColor = Color3.fromRGB(170, 0, 255), 
    KillEffect = false, 
    KillEffectMode = "Rocket", 
    MinDamage = 10,
    MinDamageOverride = 50,
    MinDamageOverrideActive = false, 
    KillEffectDuration = 3, 
    SmokeColor = Color3.fromRGB(255, 0, 0), 
    GrenadeZoneESP = false, 
    GrenadeZoneColor = Color3.fromRGB(255, 0, 0), 
    AutoFire = false,
    MinHitChance = 50, 
    WallBang = false,
    WallDepth = 1.0,
    AutoWallDepth = false,
    ShowWallbangIndicator = false,
    BacktrackTime = 0.33,
    AntiAim = false,
    AntiAimPitchMode = "Down", 
    AntiAimBackwards = false, 
    FollowBackwardsAA = false, 
    AntiAimYaw = 0, 
    FakeDuck = false,
    FakeDuckKey = nil, 
    ThirdPerson = false,
    ThirdPersonDist = 10,
    GrenadeTracers = false,
    GrenadeESP = false,
    AutoStop = false, 
    AutoPeek = false, 
    IsPeeking = false, 
    AutoPeekReturning = false, 
    AutoPeekKey = nil, 
    SilentAimKey = nil, 
    AutoFireKey = nil, 
    WallBangKey = nil, 
    GuiToggleKey = nil, 
    NoScopeOverlay = false,
    CustomScopeFov = false,
    ScopeFovValue = 40,
    ShowSpread = false,
    AutoScope = false,
    SpreadColor = Color3.fromRGB(0, 255, 0),
    TargetMode = "Near Crosshair", 
    AimHitboxes = {"Head", "HumanoidRootPart", "Torso"}, 
    Multipoint = false,
    QuickStopOptions = {"Early"}, 
    HistoryPreset = "Low", 
    Weather = "None",
    BacktrackChams = false,
    BacktrackChamsColor = Color3.fromRGB(80, 0, 255),
    BacktrackChamsStyle = "Glow",
    BacktrackChamsTransparency = 0.5,
    BulletTracers = false,
    TracerDuration = 2, 
    SelfBacktrack = false, 
    RemoveScope = false, 
    ShowImpactBox = false,
    ShowImpacts = true,
    ImpactColor = Color3.fromRGB(255, 0, 0),
    ImpactTransparency = 0.5,
    BulletTracerColor = Color3.fromRGB(0, 100, 255),
    EspOffscreenArrows = false,
    EspChams = false,
    ChamHiddenColor = Color3.fromRGB(255, 0, 0),
    EspSoulParticles = false,
    EspOnShotChams = false,
    EspChinaHat = false,
    EspSelfChinaHat = false,
    EspChinaHatRainbow = false,
    HitmarkColor = Color3.fromRGB(255, 255, 255),
    HitmarkDuration = 0.5,
    LegitAim = false,
    LegitSmooth = 10,
    LegitFov = 100,
    LegitBone = "Head",
    LegitKey = nil,
    LegitDrawFov = false,
    LegitAutoScope = false,
    LegitAutoStop = false
}
_G.LocalShots = {} 
local function SpawnHitmarker(position)
    if not _G.Config.ShowHitmark then return end
    local hitpart = Instance.new("Part", workspace)
    hitpart.Transparency = 1
    hitpart.CanCollide = false
    hitpart.CanQuery = false
    hitpart.Size = Vector3.new(0.01,0.01,0.01)
    hitpart.Anchored = true
    hitpart.Position = position
    hitpart.Name = "BloxStrikeHitmarker"
    local hit = Instance.new("BillboardGui")
    hit.Name = "hit"
    hit.AlwaysOnTop = true
    hit.Parent = hitpart
    hit.Size = UDim2.new(0, 50, 0, 50) 
    hit.Adornee = hitpart
    local hit_img = Instance.new("ImageLabel")
    hit_img.Name = "hit_img"
    hit_img.Image = "http://www.roblox.com/asset/?id=10922361372"
    hit_img.BackgroundTransparency = 1
    hit_img.Size = UDim2.new(0, 23, 0, 23)
    hit_img.Visible = true
    hit_img.ImageColor3 = _G.Config.HitmarkColor or Color3.new(1,1,1)
    hit_img.Rotation = 45
    hit_img.AnchorPoint = Vector2.new(0.5, 0.5)
    hit_img.Position = UDim2.new(0.5, 0, 0.5, 0)
    hit_img.Parent = hit
    task.spawn(function()
        local duration = _G.Config.HitmarkDuration or 0.5
        local ts = game:GetService("TweenService")
        local tweninfo = TweenInfo.new(duration, Enum.EasingStyle.Sine)
        local tweninfo2 = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        ts:Create(hit_img, tweninfo, {ImageTransparency = 1}):Play()
        ts:Create(hit_img, tweninfo2, {Rotation = 180}):Play()
        task.wait(duration)
        if hit_img then hit_img:Destroy() end
        if hit then hit:Destroy() end
        if hitpart then hitpart:Destroy() end
    end)
end
local CameraController = nil
local OldWeaponKick = nil
local function isEnemy(p)
    if not p or not p.Character then return false end
    if not _G.Config.UseTeamCheck then return true end
    if p == LP then return _G.Config.SelfBacktrack end 
    local LPTeamFolder = LP.Character and LP.Character.Parent
    local PlayerTeamFolder = p.Character.Parent
    if LP.Team and p.Team then
        return LP.Team ~= p.Team
    elseif LPTeamFolder and PlayerTeamFolder and LPTeamFolder.Name ~= "Players" then
         return LPTeamFolder ~= PlayerTeamFolder
    end
    return true 
end
local function SafeNum(val, default)
    if type(val) == "number" and val == val then return val end
    return default
end
local function UpdateRecoil()
    if not CameraController then
        local success, cc = pcall(function() return require(game.ReplicatedStorage.Controllers.CameraController) end)
        if success and cc then
            CameraController = cc
            OldWeaponKick = cc.weaponKick
            OldSetRecoil = cc.setWeaponRecoil
        end
    end
    if CameraController then
        if _G.Config.NoRecoilVisual then
            CameraController.weaponKick = function() end
        else
            if OldWeaponKick then CameraController.weaponKick = OldWeaponKick end
        end
        if _G.Config.NoRecoilReal then
            CameraController.setWeaponRecoil = function() end
        else
            if OldSetRecoil then CameraController.setWeaponRecoil = OldSetRecoil end
        end
    end
end
UpdateRecoil()
local function playHitSound()
    if not _G.Config.PlayHitSound then return end
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://1255040462" 
    s.Volume = 1
    s.PlayOnRemove = true
    s.Parent = Workspace
    s:Destroy()
end
local function CreateHitMarker()
    if not _G.Config.ShowHitmark then return end
    local gui = LP.PlayerGui:FindFirstChild("BloxStrikeHitMarker")
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "BloxStrikeHitMarker"
        gui.Parent = LP.PlayerGui
        gui.ResetOnSpawn = false
    end
    local img = Instance.new("ImageLabel")
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://131362846"
    img.Size = UDim2.new(0, 30, 0, 30)
    img.Position = UDim2.new(0.5, 0, 0.5, 0)
    img.AnchorPoint = Vector2.new(0.5, 0.5)
    img.ImageColor3 = Color3.fromRGB(255, 255, 255)
    img.Parent = gui
    game:GetService("TweenService"):Create(img, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 15, 0, 15),
        ImageTransparency = 1
    }):Play()
    task.delay(0.3, function() img:Destroy() end)
end
local function VisualizeShrapnel(pos)
    if not _G.Config.GrenadeTracers then return end
    local lines = {}
    local numLines = 16
    local length = 12
    for i = 1, numLines do
        local line = Drawing.new("Line")
        line.Visible = true
        line.Color = _G.Config.GrenadeZoneColor or Color3.fromRGB(255, 100, 0)
        line.Thickness = 2
        line.Transparency = 1
        local x = math.random() * 2 - 1
        local y = math.random() * 2 - 1
        local z = math.random() * 2 - 1
        local dir = Vector3.new(x, y, z).Unit
        table.insert(lines, {obj = line, dir = dir})
    end
    task.spawn(function()
        local t = 0
        local duration = 0.8 
        local startTick = tick()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            t = tick() - startTick
            if t > duration then
                connection:Disconnect()
                for _, item in ipairs(lines) do item.obj:Remove() end
                return
            end
            local alpha = math.clamp(t / duration, 0, 1)
            local expansion = (1 - (1 - alpha) * (1 - alpha)) * length 
            for _, item in ipairs(lines) do
                local line = item.obj
                local dir = item.dir
                local worldStart = pos + (dir * (expansion * 0.2)) 
                local worldEnd = pos + (dir * expansion)
                local screenStart, onScreen1 = Camera:WorldToViewportPoint(worldStart)
                local screenEnd, onScreen2 = Camera:WorldToViewportPoint(worldEnd)
                if onScreen1 or onScreen2 then
                    line.Visible = true
                    line.From = Vector2.new(screenStart.X, screenStart.Y)
                    line.To = Vector2.new(screenEnd.X, screenEnd.Y)
                    line.Transparency = 1 - alpha
                else
                    line.Visible = false
                end
            end
        end)
    end)
end
local function AttachGrenadeESP(child)
    if not child then return end
    local name = child.Name
    local isSmoke = name:find("VoxelSmoke")
    local isFire = name:find("VoxelFire")
    if isSmoke or isFire then
        task.wait()
        if not child or not child.Parent then return end
        local showZone = (isFire and _G.Config.MolotovZoneESP) or (isSmoke and _G.Config.SmokeZoneESP)
        if showZone then
             local function AdornVoxel(part)
                 if part:IsA("BasePart") and not part:FindFirstChild("BS_ZoneBox") then
                     local box = Instance.new("BoxHandleAdornment")
                     box.Name = "BS_ZoneBox"
                     box.Adornee = part
                     box.Size = part.Size
                     box.Color3 = _G.Config.GrenadeZoneColor
                     box.Transparency = 0.6
                     box.AlwaysOnTop = true
                     box.ZIndex = 0
                     box.Parent = part
                 end
             end
             for _, v in ipairs(child:GetChildren()) do AdornVoxel(v) end
             child.ChildAdded:Connect(AdornVoxel)
        end
        if isSmoke and _G.Config.ColoredSmoke then
             for _, v in ipairs(child:GetDescendants()) do
                 if v:IsA("BasePart") then 
                    v.Color = _G.Config.SmokeColor 
                    v.Material = Enum.Material.Neon
                 elseif v:IsA("ParticleEmitter") then
                    v.Color = ColorSequence.new(_G.Config.SmokeColor)
                 end
             end
        elseif isSmoke and _G.Config.NoSmoke then
             child:Destroy()
        end
        return
    end
    if not _G.Config.GrenadeESP and not _G.Config.GrenadeTracers then return end
    local lowName = name:lower()
    local isUUID = name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$")
    local matchesUUID = isUUID and (not isSmoke and not isFire) 
    local isNameMatch = lowName:find("grenade") or lowName:find("flashbang") or lowName:find("molotov") or lowName:find("projectile")
    if matchesUUID or isNameMatch then
         if not child or not child.Parent then return end
         local part = child
         if not part:IsA("BasePart") then
             part = child:FindFirstChildWhichIsA("BasePart")
         end
         if part then
             if _G.Config.GrenadeESP then
                 local box = Instance.new("BoxHandleAdornment")
                 box.Name = "GrenadeBox"
                 box.Adornee = part
                 box.Size = part.Size + Vector3.new(0.2, 0.2, 0.2)
                 box.Color3 = Color3.fromRGB(255, 60, 0)
                 box.Transparency = 0.3
                 box.AlwaysOnTop = true
                 box.ZIndex = 5
                 box.Parent = part
                 local bg = Instance.new("BillboardGui")
                 bg.Name = "GrenadeLabel"
                 bg.Adornee = part
                 bg.Size = UDim2.new(0,100,0,50)
                 bg.StudsOffset = Vector3.new(0, 1, 0)
                 bg.AlwaysOnTop = true
                 bg.Parent = part
                 local text = Instance.new("TextLabel")
                 text.BackgroundTransparency = 1
                 text.Size = UDim2.new(1,0,1,0)
                 text.Text = "GRENADE"
                 text.TextColor3 = Color3.fromRGB(255, 0, 0)
                 text.TextStrokeTransparency = 0
                 text.Parent = bg
                 local att0 = Instance.new("Attachment", part)
                 local att1 = Instance.new("Attachment", part)
                 att0.Position = Vector3.new(0, 0.05, 0)
                 att1.Position = Vector3.new(0, -0.05, 0)
                 local trail = Instance.new("Trail")
                 trail.Name = "GrenadeTrail"
                 trail.Attachment0 = att0
                 trail.Attachment1 = att1
                 trail.Color = ColorSequence.new(Color3.fromRGB(255, 60, 0))
                 trail.Lifetime = 2
                 trail.MinLength = 0
                 trail.FaceCamera = true
                 trail.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.8, 0),
                    NumberSequenceKeypoint.new(1, 1)
                 })
                 trail.Parent = part
             end
         task.spawn(function()
            local lastPos = part.Position
            while part and part.Parent do
                lastPos = part.Position
                task.wait()
            end
            if lastPos then
                VisualizeShrapnel(lastPos)
            end
         end)
     end
    end
end
local function AttachImpactESP(child)
    if not _G.Config.ShowImpacts then return end
    if not child then return end
    if child.Name == "HitMarker" or child.Name == "HitPart" then 
         task.wait() 
         if not child or not child.Parent then return end
         
         local isLocal = false
         local now = tick()
         for i = #_G.LocalShots, 1, -1 do
             local shot = _G.LocalShots[i]
             if now - shot.Time > 1.0 then
                 table.remove(_G.LocalShots, i)
             elseif (child.Position - shot.Position).Magnitude < 5.0 then
                 isLocal = true
             end
         end
         
         if isLocal and child:IsA("BasePart") then
             local box = Instance.new("BoxHandleAdornment")
             box.Name = "ImpactBox"
             box.Adornee = child
             box.Size = child.Size + Vector3.new(0.05, 0.05, 0.05)
             box.Color3 = _G.Config.ImpactColor
             box.Transparency = _G.Config.ImpactTransparency
             box.AlwaysOnTop = true
             box.ZIndex = 5
             box.Parent = child
         end
    end
end
local DebrisConnections = {}
local function MonitorDebris(folder)
   if DebrisConnections[folder] then return end
   DebrisConnections[folder] = true
   folder.ChildAdded:Connect(function(c)
       AttachGrenadeESP(c)
       AttachImpactESP(c)
   end)
   for _, child in ipairs(folder:GetChildren()) do
       AttachGrenadeESP(child)
       AttachImpactESP(child)
   end
end
local debrisFolder = workspace:FindFirstChild("Debris")
if debrisFolder then
    MonitorDebris(debrisFolder)
end
workspace.ChildAdded:Connect(function(child)
    if child.Name == "Debris" then
        MonitorDebris(child)
    else
        AttachGrenadeESP(child)
        AttachImpactESP(child)
    end
end)
task.spawn(function()
    for i, child in ipairs(workspace:GetChildren()) do
        if i % 100 == 0 then task.wait() end
        AttachGrenadeESP(child)
        AttachImpactESP(child)
    end
end)
task.spawn(function()
    local scannedCount = 0
    local RS = game:GetService("ReplicatedStorage")
    local function CheckModule(module)
        scannedCount = scannedCount + 1
        if not module or not module:IsA("ModuleScript") then return false end
        local name = module.Name:lower()
        -- Only require potential network/game modules. Improve this list if needed.
        if not (name:find("network") or name:find("game") or name:find("controller") or name:find("system")) then
             return false
        end
        if name:match("test") or name:match("spec") or name == "bytenet" or name == "promise" or name == "trove" then 
            return false 
        end
        
        local s, r = pcall(require, module)
        if s and type(r) == "table" then
            local success, isNetwork = pcall(function()
                return r.Character and r.Inventory and r.Inventory.ShootWeapon
            end)
            if success and isNetwork then
                Packet_ShootWeapon = r.Inventory.ShootWeapon
                Network = r
                Packet_UpdateState = Network.Character and Network.Character.UpdateCrouchState
                if Packet_UpdateState and Packet_UpdateState.Send then
                     local oldSend
                     oldSend = hookfunction(Packet_UpdateState.Send, function(...)
                         local args = {...}
                         if _G.Config.FakeDuck then
                             args[1] = true 
                             print("[BloxStrike] Fake Duck: Sending Crouch=true")
                             return oldSend(unpack(args))
                         end
                         return oldSend(...)
                     end)
                end
                
                if Network.VFX and Network.VFX.FlashPlayer then
                    if Network.VFX.FlashPlayer.Listen then
                         Network.VFX.FlashPlayer.Listen(function(...)
                             if _G.Config.NoFlash then end
                         end)
                    end
                end

                 if Network.Character and Network.Character.FallDamage then
                     if Network.Character.FallDamage.Send then
                        local oldSend
                        oldSend = hookfunction(Network.Character.FallDamage.Send, function(...)
                            if _G.Config.NoFallDamage then return end
                            return oldSend(...)
                        end)
                     end
                 end
                 
                -- task.spawn(function() 
                --     game:GetService("StarterGui"):SetCore("SendNotification", {
                --         Title = "BloxStrike",
                --         Text = "Network Found & Hooked",
                --         Duration = 5
                --     })
                -- end)
                return true
            end
        end
        return false
    end
    
    local function SmartScan(folder)
        if not folder then return false end
        for _, v in ipairs(folder:GetChildren()) do
             if CheckModule(v) then return true end
        end
        return false
    end

    -- Priority check known folders
    if SmartScan(RS:FindFirstChild("Systems")) then return end
    if SmartScan(RS:FindFirstChild("Controllers")) then return end
    
    -- Fallback: Scan likely folders only
    local foldersToCheck = {"Shared", "Common", "Definitions", "Packets", "Game"}
    for _, name in ipairs(foldersToCheck) do
        local folder = RS:FindFirstChild(name)
        if folder then
            for i, v in ipairs(folder:GetDescendants()) do
                 if i % 100 == 0 then task.wait() end -- Slower scan is safer
                 if CheckModule(v) then return end
            end
        end
    end
end)
task.spawn(function()
    if getrawmetatable and setreadonly then
        local mt = getrawmetatable(game)
        local oldNewIndex = mt.__newindex
        setreadonly(mt, false)
        mt.__newindex = newcclosure(function(self, key, value)
            if self == LP then
                if _G.Config.ThirdPerson then
                    if key == "CameraMode" then
                        return oldNewIndex(self, key, Enum.CameraMode.Classic)
                    elseif key == "CameraMaxZoomDistance" then
                        return oldNewIndex(self, key, _G.Config.ThirdPersonDist)
                    elseif key == "CameraMinZoomDistance" then
                        return oldNewIndex(self, key, _G.Config.ThirdPersonDist)
                    end
                end
            end
            return oldNewIndex(self, key, value)
        end)
        setreadonly(mt, true)
    end
end)


if makefolder and writefile and isfile and isfolder then
    pcall(function() 
        if not isfolder("Icanstoplarping Hub") then makefolder("Icanstoplarping Hub") end
        if not isfolder("Icanstoplarping Hub/configs") then makefolder("Icanstoplarping Hub/configs") end
    end)
end
UpdateRecoil()
local skyboxtable = {
    ["Standard"] = {
        SkyboxBk = "http://www.roblox.com/asset/?id=91458024",  
        SkyboxDn = "http://www.roblox.com/asset/?id=91457980",
        SkyboxFt = "http://www.roblox.com/asset/?id=91458024",
        SkyboxLf = "http://www.roblox.com/asset/?id=91458024",
        SkyboxRt = "http://www.roblox.com/asset/?id=91458024",
        SkyboxUp = "http://www.roblox.com/asset/?id=91458002"
    },
    ["Minecraft"] = {
        SkyboxBk = "rbxassetid://8735166756",
        SkyboxDn = "http://www.roblox.com/asset/?id=8735166707",
        SkyboxFt = "http://www.roblox.com/asset/?id=8735231668",
        SkyboxLf = "http://www.roblox.com/asset/?id=8735166755",
        SkyboxRt = "http://www.roblox.com/asset/?id=8735166751",
        SkyboxUp = "http://www.roblox.com/asset/?id=8735166729"
    },
    ["Spongebob"] = {
        SkyboxBk = "rbxassetid://277099484",
        SkyboxDn = "rbxassetid://277099500",
        SkyboxFt = "rbxassetid://277099554",
        SkyboxLf = "rbxassetid://277099531",
        SkyboxRt = "rbxassetid://277099589",
        SkyboxUp = "rbxassetid://277101591"
    },
    ["Deep Space"] = {
        SkyboxBk = "rbxassetid://159248188",
        SkyboxDn = "rbxassetid://159248183",
        SkyboxFt = "rbxassetid://159248187",
        SkyboxLf = "rbxassetid://159248173",
        SkyboxRt = "rbxassetid://159248192",
        SkyboxUp = "rbxassetid://159248176"
    },
    ["Clouded Sky"] = {
        SkyboxBk = "rbxassetid://252760981",
        SkyboxDn = "rbxassetid://252763035",
        SkyboxFt = "rbxassetid://252761439",
        SkyboxLf = "rbxassetid://252760980",
        SkyboxRt = "rbxassetid://252760986",
        SkyboxUp = "rbxassetid://252762652"
    },
    ["Retro"] = {
        SkyboxBk = "rbxasset://sky/null_plainsky512_bk.jpg",
        SkyboxDn = "rbxasset://sky/null_plainsky512_dn.jpg",
        SkyboxFt = "rbxasset://sky/null_plainsky512_ft.jpg",
        SkyboxLf = "rbxasset://sky/null_plainsky512_lf.jpg",
        SkyboxRt = "rbxasset://sky/null_plainsky512_rt.jpg",
        SkyboxUp = "rbxasset://sky/null_plainsky512_up.jpg"
    },
    ["City"] = {
        SkyboxBk = "rbxassetid://9134792889",
        SkyboxDn = "rbxassetid://9134791975",
        SkyboxFt = "rbxassetid://9134793457",
        SkyboxLf = "rbxassetid://9134791234",
        SkyboxRt = "rbxassetid://9134790419",
        SkyboxUp = "rbxassetid://9134791633"
    },
    ["Purple Nebula"] = {
        SkyboxBk = "rbxassetid://15983968922",
        SkyboxDn = "rbxassetid://15983966825",
        SkyboxFt = "rbxassetid://15983965025",
        SkyboxLf = "rbxassetid://15983967420",
        SkyboxRt = "rbxassetid://15983966246",
        SkyboxUp = "rbxassetid://15983964246"
    }
}
local function UpdateSkybox(name)
    local data = skyboxtable[name]
    if not data then return end
    local L = game:GetService("Lighting")
    for _, v in pairs(L:GetChildren()) do
        if v:IsA("Atmosphere") or v:IsA("Clouds") then
            v:Destroy()
        end
    end
    local sky = L:FindFirstChild("BloxStrike_Sky")
    if not sky then
        for _, v in pairs(L:GetChildren()) do
            if v:IsA("Sky") then v:Destroy() end
        end
        sky = Instance.new("Sky")
        sky.Name = "BloxStrike_Sky"
        sky.Parent = L
    end
    sky.SkyboxBk = data.SkyboxBk
    sky.SkyboxDn = data.SkyboxDn
    sky.SkyboxFt = data.SkyboxFt
    sky.SkyboxLf = data.SkyboxLf
    sky.SkyboxRt = data.SkyboxRt
    sky.SkyboxUp = data.SkyboxUp
    sky.SunTextureId = "" 
    sky.MoonTextureId = ""
    sky.StarCount = 0
end
local WeatherPart = nil
local GroundPart = nil
local CurrentWeatherType = "None"
local function UpdateWeather(wType)
    _G.Config.Weather = wType
    CurrentWeatherType = wType
    if WeatherPart then WeatherPart:Destroy() WeatherPart = nil end
    if GroundPart then GroundPart:Destroy() GroundPart = nil end
    if wType == "None" then return end
    WeatherPart = Instance.new("Part")
    WeatherPart.Name = "BloxStrike_Weather_Sky"
    WeatherPart.Size = Vector3.new(100, 1, 100)
    WeatherPart.Transparency = 1
    WeatherPart.Anchored = true
    WeatherPart.CanCollide = false
    WeatherPart.Parent = workspace.CurrentCamera
    local SkyEmitter = Instance.new("ParticleEmitter")
    SkyEmitter.Parent = WeatherPart
    SkyEmitter.EmissionDirection = Enum.NormalId.Bottom
    GroundPart = Instance.new("Part")
    GroundPart.Name = "BloxStrike_Weather_Ground"
    GroundPart.Size = Vector3.new(50, 1, 50)
    GroundPart.Transparency = 1
    GroundPart.Anchored = true
    GroundPart.CanCollide = false
    GroundPart.Parent = workspace.CurrentCamera
    local GroundEmitter = nil
    if wType == "Rain" then
        SkyEmitter.Texture = "rbxassetid://0" 
        SkyEmitter.Rate = 2000 
        SkyEmitter.Color = ColorSequence.new(Color3.fromRGB(200, 200, 255))
        SkyEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        })
        SkyEmitter.Size = NumberSequence.new(0.1, 0) 
        SkyEmitter.Lifetime = NumberRange.new(1, 1.5)
        SkyEmitter.Speed = NumberRange.new(100, 150) 
        SkyEmitter.SpreadAngle = Vector2.new(0, 0)
        SkyEmitter.Orientation = Enum.ParticleOrientation.VelocityParallel 
        SkyEmitter.Acceleration = Vector3.new(0, -50, 0)
        GroundEmitter = Instance.new("ParticleEmitter")
        GroundEmitter.Parent = GroundPart
        GroundEmitter.Texture = "rbxassetid://2015509923" 
        GroundEmitter.Orientation = Enum.ParticleOrientation.VelocityPerpendicular 
        GroundEmitter.Rate = 300
        GroundEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        GroundEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2), 
            NumberSequenceKeypoint.new(1, 1)
        })
        GroundEmitter.Size = NumberSequence.new(1, 2) 
        GroundEmitter.Lifetime = NumberRange.new(0.2, 0.3) 
        GroundEmitter.Speed = NumberRange.new(0, 0)
    elseif wType == "Snow" then
        SkyEmitter.Texture = "rbxassetid://241396659" 
        SkyEmitter.Rate = 300
        SkyEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        SkyEmitter.Size = NumberSequence.new(0.5, 0.2)
        SkyEmitter.Speed = NumberRange.new(10, 25)
        SkyEmitter.Lifetime = NumberRange.new(3, 5)
        SkyEmitter.Acceleration = Vector3.new(0, -5, 0)
        SkyEmitter.Rotation = NumberRange.new(0, 360)
        SkyEmitter.RotSpeed = NumberRange.new(-50, 50)
    elseif wType == "Hell Fire" then
        SkyEmitter.Texture = "rbxassetid://242205518" 
        SkyEmitter.Rate = 400
        SkyEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0), Color3.fromRGB(150, 0, 0))
        SkyEmitter.Size = NumberSequence.new(2, 4)
        SkyEmitter.Speed = NumberRange.new(40, 60)
        SkyEmitter.Lifetime = NumberRange.new(2, 3)
        SkyEmitter.Acceleration = Vector3.new(0, -10, 0)
        SkyEmitter.RotSpeed = NumberRange.new(50, 100)
    end
end
local function UpdateWeather(wType)
    if WeatherPart then WeatherPart:Destroy() WeatherPart = nil end
    if GroundPart then GroundPart:Destroy() GroundPart = nil end
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "BloxStrike_RainDrop" then v:Destroy() end
    end
    _G.WeatherState = {Balls = {}, LastBall = tick(), Type = wType}
    if wType == "None" then return end
    WeatherPart = Instance.new("Part")
    WeatherPart.Name = "BloxStrike_Weather_Sky"
    WeatherPart.Size = Vector3.new(100, 1, 100)
    WeatherPart.Transparency = 1
    WeatherPart.Anchored = true
    WeatherPart.CanCollide = false
    WeatherPart.Parent = workspace.CurrentCamera
    local SkyEmitter = Instance.new("ParticleEmitter")
    SkyEmitter.Parent = WeatherPart
    SkyEmitter.EmissionDirection = Enum.NormalId.Bottom
    SkyEmitter.Enabled = true
    GroundPart = Instance.new("Part")
    GroundPart.Name = "BloxStrike_Weather_Ground"
    GroundPart.Size = Vector3.new(50, 1, 50)
    GroundPart.Transparency = 1
    GroundPart.Anchored = true
    GroundPart.CanCollide = false
    GroundPart.Parent = workspace.CurrentCamera
    local GroundEmitter = Instance.new("ParticleEmitter")
    GroundEmitter.Parent = GroundPart
    GroundEmitter.Enabled = false 
    if wType == "Rain" then
        SkyEmitter.Texture = "rbxassetid://241868005" 
        SkyEmitter.Rate = 10000 
        SkyEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        SkyEmitter.LightEmission = 0.2 
        SkyEmitter.Transparency = NumberSequence.new(0) 
        SkyEmitter.Size = NumberSequence.new(3, 6) 
        SkyEmitter.Lifetime = NumberRange.new(2, 2.5)
        SkyEmitter.Speed = NumberRange.new(80, 100)
        SkyEmitter.SpreadAngle = Vector2.new(0, 0)
        SkyEmitter.Acceleration = Vector3.new(0, -50, 0)
        SkyEmitter.Orientation = Enum.ParticleOrientation.FacingCamera
        local sound = Instance.new("Sound", WeatherPart)
        sound.SoundId = "rbxassetid://3786250088"
        sound.Volume = 9
        sound.Looped = true
        sound.Playing = true
    elseif wType == "Snow" then
        SkyEmitter.Texture = "rbxassetid://99851851"
        SkyEmitter.Rate = 200 
        SkyEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        SkyEmitter.Size = NumberSequence.new(0.25, 0.35) 
        SkyEmitter.Speed = NumberRange.new(30, 30)
        SkyEmitter.Lifetime = NumberRange.new(5, 10)
        SkyEmitter.Acceleration = Vector3.new(0, 0, 0) 
        SkyEmitter.SpreadAngle = Vector2.new(50, 50)
        SkyEmitter.LightEmission = 0.5
        SkyEmitter.Rotation = NumberRange.new(0, 0)
        SkyEmitter.RotSpeed = NumberRange.new(0, 0)
    elseif wType == "Hell Fire" then
        SkyEmitter.Texture = "rbxassetid://242205518"
        SkyEmitter.Rate = 400
        SkyEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0), Color3.fromRGB(150, 0, 0))
        SkyEmitter.Size = NumberSequence.new(2, 4)
        SkyEmitter.Speed = NumberRange.new(40, 60)
        SkyEmitter.Lifetime = NumberRange.new(2, 3)
        SkyEmitter.Acceleration = Vector3.new(0, -10, 0)
        SkyEmitter.RotSpeed = NumberRange.new(50, 100)
    end
end
    
    local rayParamsCover = RaycastParams.new()
    local upVec = Vector3.new(0, 100, 0)
    
    RunService.RenderStepped:Connect(function()
    if not workspace.CurrentCamera then return end
    local CamCF = workspace.CurrentCamera.CFrame
    if WeatherPart then
        WeatherPart.CFrame = CamCF * CFrame.new(0, 30, 0) 
    end
    local underCover = false
    if LP.Character and LP.Character:FindFirstChild("Head") then
        rayParamsCover.FilterDescendantsInstances = {LP.Character, WeatherPart, GroundPart, workspace.CurrentCamera} 
        local headPos = LP.Character.Head.Position
        local res = workspace:Raycast(headPos, upVec, rayParamsCover)
        if res and res.Instance.Transparency < 1 then
             underCover = true
        end
    end
    if WeatherPart and WeatherPart:FindFirstChild("ParticleEmitter") then
        WeatherPart.ParticleEmitter.Enabled = not underCover
    end
    if _G.WeatherState and _G.WeatherState.Type == "Rain" and not underCover then
        if tick() - (_G.WeatherState.LastBall or 0) >= math.random() * 0.05 then 
            _G.WeatherState.LastBall = tick()
            local dist = math.random(5, 25) 
            local offset = Vector3.new(math.random(-15, 15), math.random(-5, 5), -dist)
            local spawnPos = CamCF:PointToWorldSpace(offset)
            
            local rayParams = RaycastParams.new() 
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            
            local ignoreList = {WeatherPart, GroundPart, workspace.CurrentCamera, LP.Character}
            rayParams.FilterDescendantsInstances = ignoreList
            local res = workspace:Raycast(spawnPos, Vector3.new(0, -60, 0), rayParams)
            if res then
                local splashPart = Instance.new("Part")
                splashPart.Name = "BS_Splash"
                splashPart.Transparency = 1
                splashPart.CanCollide = false
                splashPart.Anchored = true
                splashPart.Size = Vector3.new(0.1, 0.1, 0.1)
                splashPart.Position = res.Position + Vector3.new(0, 0.2, 0)
                splashPart.Parent = workspace.CurrentCamera
                local splash = Instance.new("ParticleEmitter")
                splash.Parent = splashPart
                splash.Texture = "rbxassetid://241576804" 
                splash.Size = NumberSequence.new(0.05, 0.1) 
                splash.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.4), 
                    NumberSequenceKeypoint.new(1, 1)    
                })
                splash.Lifetime = NumberRange.new(0.2, 0.35) 
                splash.Rate = 0
                splash.Speed = NumberRange.new(3, 5) 
                splash.Drag = 15 
                splash.Acceleration = Vector3.new(0, -20, 0) 
                splash.Rotation = NumberRange.new(0, 360)
                splash.Orientation = Enum.ParticleOrientation.FacingCamera 
                splash.LightEmission = 0.1 
                splash:Emit(1)
                game:GetService("Debris"):AddItem(splashPart, 1)
            end
        end
    end
end)
local DefaultLighting = {
    Ambient = game:GetService("Lighting").Ambient,
    OutdoorAmbient = game:GetService("Lighting").OutdoorAmbient,
    Brightness = game:GetService("Lighting").Brightness,
    ClockTime = game:GetService("Lighting").ClockTime,
    FogEnd = game:GetService("Lighting").FogEnd,
    FogStart = game:GetService("Lighting").FogStart,
    GlobalShadows = game:GetService("Lighting").GlobalShadows
}
local function UpdateLighting()
    local L = game:GetService("Lighting")
    if _G.Config.WorldTimeEnabled then
        L.ClockTime = _G.Config.WorldClockTime
    else
        L.ClockTime = DefaultLighting.ClockTime
    end
    if _G.Config.WorldBrightEnabled then
        L.Brightness = _G.Config.WorldBrightness
    else
        L.Brightness = DefaultLighting.Brightness
    end
    if _G.Config.WorldColorEnabled then
        L.Ambient = _G.Config.WorldAmbient
        L.OutdoorAmbient = _G.Config.WorldOutdoorAmbient
    else
        L.Ambient = DefaultLighting.Ambient
        L.OutdoorAmbient = DefaultLighting.OutdoorAmbient
    end
    if _G.Config.WorldSkyboxEnabled or _G.Config.WorldTimeEnabled or _G.Config.WorldColorEnabled then
        L.FogEnd = 9e9
        L.FogStart = 9e9
        L.GlobalShadows = false
    else
        L.FogEnd = DefaultLighting.FogEnd
        L.FogStart = DefaultLighting.FogStart
        L.GlobalShadows = DefaultLighting.GlobalShadows
    end
end
local function SafeNum(val, default)
    if type(val) == "number" and val == val then
        return val
    end
    return default or 0
end


if not tonumber(_G.Config.MinDamage) or _G.Config.MinDamage ~= _G.Config.MinDamage then 
    _G.Config.MinDamage = 101 
end
if not tonumber(_G.Config.MinDamageOverride) or _G.Config.MinDamageOverride ~= _G.Config.MinDamageOverride then
    _G.Config.MinDamageOverride = 10
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ewenja/HihiHub.gui-new/refs/heads/main/leake_gui_fix_KeyCode.Z_v4.lua"))()
local Window = Library:Window({
    Name = "Icanstoplarping Hub",
    SubName = "BETA",
    Logo = "120959262762131"
})
local KeybindList = Library:KeybindList("Keybinds")
if Library.KeyList and Library.KeyList.Add then
    local _OriginalAdd = Library.KeyList.Add
    Library.KeyList.Add = function(self, Name, Key)
        local Item = _OriginalAdd(self, Name, Key)
        if Item and Item.Set then
            local _OriginalSet = Item.Set
            Item.Set = function(s, n, v)
                if v == "[None]" or v == "None" or v == "[Unknown]" or v == "Unknown" or v == "" then
                        if Item.Instance then Item.Instance.Visible = false end
                        if Item.SetVisible then Item:SetVisible(false) end
                else
                        if Item.Instance then Item.Instance.Visible = true end
                        if Item.SetVisible then Item:SetVisible(true) end
                        _OriginalSet(s, n, v)
                end
            end
        end
        return Item
    end
end

Window:Category("Legit")
local LegitPage = Window:Page({Name = "Legit Aimbot", Icon = "108839695397679", Columns = 2})
local LegitAimSection = LegitPage:Section({Name = "Aimbot", Description = "Assists & Triggerbot", Icon = "108839695397679", Side = 1})
local LegitAimToggle = LegitAimSection:Toggle({Name = "Legit Aimbot", Flag = "BS_LegitAim", Default = _G.Config.LegitAim, Callback = function(v) _G.Config.LegitAim = v end})
LegitAimSection:Keybind({Name = "Aimbot Key", Flag = "LegitKey", Default = Enum.UserInputType.None, Callback = function() LegitAimToggle:Set(not _G.Config.LegitAim) end})
LegitAimSection:Slider({Name = "Smoothing", Flag = "LegitSmooth", Min = 1, Max = 30, Default = SafeNum(_G.Config.LegitSmooth, 10), Decimals = 1, Suffix = "", Callback = function(v) _G.Config.LegitSmooth = v end})
LegitAimSection:Slider({Name = "Legit FOV", Flag = "LegitFov", Min = 10, Max = 400, Default = SafeNum(_G.Config.LegitFov, 100), Decimals = 1, Suffix = "px", Callback = function(v) _G.Config.LegitFov = v end})
LegitAimSection:Toggle({Name = "Draw Legit FOV", Flag = "BS_LegitDrawFov", Default = _G.Config.LegitDrawFov, Callback = function(v) _G.Config.LegitDrawFov = v end})
LegitAimSection:Toggle({Name = "Wall Check", Flag = "BS_LegitWallCheck", Default = _G.Config.LegitWallCheck, Callback = function(v) _G.Config.LegitWallCheck = v end}) 
LegitAimSection:Toggle({Name = "Auto Wallbang", Flag = "BS_LegitAutoWallbang", Default = _G.Config.LegitAutoWallbang, Callback = function(v) _G.Config.LegitAutoWallbang = v end}) 
LegitAimSection:Dropdown({Name = "Aim Bone", Flag = "LegitBone", Default = {_G.Config.LegitBone}, Items = {"Head", "Neck", "UpperTorso", "HumanoidRootPart"}, Multi = false, Callback = function(v) _G.Config.LegitBone = v end})
LegitAimSection:Toggle({Name = "Auto Fire (Triggerbot)", Flag = "BS_AutoFire", Default = _G.Config.AutoFire, Callback = function(v) _G.Config.AutoFire = v end})
LegitAimSection:Keybind({Name = "Triggerbot Key", Flag = "AutoFireKey", Default = Enum.UserInputType.None, Callback = function() AutoFireToggle:Set(not _G.Config.AutoFire) end})
LegitAimSection:Toggle({Name = "Quick Scope", Flag = "BS_AutoScope", Default = _G.Config.AutoScope, Callback = function(v) _G.Config.AutoScope = v end}) 
LegitAimSection:Toggle({Name = "Legit Auto Scope (Triggerbot)", Flag = "BS_LegitAutoScope", Default = _G.Config.LegitAutoScope, Callback = function(v) _G.Config.LegitAutoScope = v end})
LegitAimSection:Toggle({Name = "Legit Auto Stop", Flag = "BS_LegitAutoStop", Default = _G.Config.LegitAutoStop, Callback = function(v) _G.Config.LegitAutoStop = v end})
LegitAimSection:Toggle({Name = "Multipoint", Flag = "BS_Multipoint", Default = _G.Config.Multipoint, Callback = function(v) _G.Config.Multipoint = v end})

Window:Category("Rage")
local RagePage = Window:Page({Name = "Rage Aimbot", Icon = "108839695397679", Columns = 2})
local RageAimSection = RagePage:Section({Name = "Aimbot", Description = "Silent Aim & Exploits", Icon = "108839695397679", Side = 1})
local SilentAimToggle = RageAimSection:Toggle({Name = "Silent Aim", Flag = "BS_SilentAim", Default = _G.Config.SilentAim, Callback = function(v) _G.Config.SilentAim = v end})
RageAimSection:Keybind({Name = "Silent Aim Key", Flag = "SilentAimKey", Default = Enum.UserInputType.None, Callback = function() SilentAimToggle:Set(not _G.Config.SilentAim) end})
RageAimSection:Dropdown({Name = "Target Mode", Flag = "TargetMode", Default = {_G.Config.TargetMode}, Items = {"Highest Damage", "Near Crosshair"}, Multi = false, Callback = function(v) _G.Config.TargetMode = v end})
RageAimSection:Dropdown({Name = "Hitboxes", Flag = "AimHitboxes", Default = _G.Config.AimHitboxes, Items = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "RightUpperArm", "LeftUpperArm", "RightUpperLeg", "LeftUpperLeg"}, Multi = true, Callback = function(v) _G.Config.AimHitboxes = v end})
RageAimSection:Toggle({Name = "Wall Bang", Flag = "BS_WallBang", Default = _G.Config.WallBang, Callback = function(v) _G.Config.WallBang = v end})
RageAimSection:Keybind({Name = "Wall Bang Key", Flag = "WallBangKey", Default = Enum.UserInputType.None, Callback = function() WallBangToggle:Set(not _G.Config.WallBang) end})
RageAimSection:Toggle({Name = "Wallbang Indicator", Flag = "BS_ShowWallbangIndicator", Default = _G.Config.ShowWallbangIndicator, Callback = function(v) _G.Config.ShowWallbangIndicator = v end})
RageAimSection:Toggle({Name = "Auto Fire", Flag = "BS_AutoFire", Default = _G.Config.AutoFire, Callback = function(v) _G.Config.AutoFire = v end})
RageAimSection:Slider({Name = "Silent Aim FOV", Flag = "FovRadius", Min = 10, Max = 800, Default = SafeNum(_G.Config.FovRadius, 100), Decimals = 1, Suffix = "px", Callback = function(v) _G.Config.FovRadius = v end})
RageAimSection:Toggle({Name = "Show FOV Circle", Flag = "BS_ShowFov", Default = _G.Config.ShowFov, Callback = function(v) _G.Config.ShowFov = v end})

local defaultMinDamage = 10
if type(_G.Config.MinDamage) == "number" and _G.Config.MinDamage == _G.Config.MinDamage then
    defaultMinDamage = _G.Config.MinDamage
end

local defaultOverride = 50
if type(_G.Config.MinDamageOverride) == "number" and _G.Config.MinDamageOverride == _G.Config.MinDamageOverride then
    defaultOverride = _G.Config.MinDamageOverride
end

RageAimSection:Slider({Name = "Min Damage", Flag = "MinDamage_V5", Min = 0, Max = 120, Default = defaultMinDamage, Decimals = 1, Suffix = "hp", Callback = function(v) _G.Config.MinDamage = v end})
RageAimSection:Slider({Name = "Override Damage", Flag = "MinDamageOverride_V5", Min = 0, Max = 120, Default = defaultOverride, Decimals = 1, Suffix = "hp", Callback = function(v) _G.Config.MinDamageOverride = v end})
RageAimSection:Keybind({Name = "Override Key", Flag = "MinDamageOverrideKey", Default = Enum.UserInputType.None, Callback = function() 
    _G.Config.MinDamageOverrideActive = not _G.Config.MinDamageOverrideActive
    if Library and Library.Notify then
        Library:Notify({Title = "Damage Override", Content = _G.Config.MinDamageOverrideActive and "Active (" .. tostring(_G.Config.MinDamageOverride) .. ")" or "Inactive", Duration = 1})
    end
end})
RageAimSection:Slider({Name = "Min Hit Chance", Flag = "MinHitChance_V2", Min = 0, Max = 100, Default = SafeNum(_G.Config.MinHitChance, 50), Decimals = 1, Suffix = "%", Callback = function(v) _G.Config.MinHitChance = v end})

local AntiAimSection = RagePage:Section({Name = "Anti-Aim", Description = "Spinbot & Angles", Icon = "108839695397679", Side = 2})
local AntiAimToggle = AntiAimSection:Toggle({Name = "Anti-Aim", Flag = "BS_AntiAim", Default = _G.Config.AntiAim, Callback = function(v) _G.Config.AntiAim = v end})
AntiAimSection:Keybind({Name = "Anti-Aim Key", Flag = "AntiAimKey", Default = Enum.UserInputType.None, Callback = function() AntiAimToggle:Set(not _G.Config.AntiAim) end})
AntiAimSection:Dropdown({Name = "Pitch Mode", Flag = "AntiAimPitchMode", Default = {_G.Config.AntiAimPitchMode}, Items = {"Down", "Up"}, Multi = false, Callback = function(v) _G.Config.AntiAimPitchMode = v end})
AntiAimSection:Toggle({Name = "Backwards AA", Flag = "AntiAimBackwards", Default = _G.Config.AntiAimBackwards, Callback = function(v) _G.Config.AntiAimBackwards = v end})
AntiAimSection:Toggle({Name = "Follow Backwards AA", Flag = "FollowBackwardsAA", Default = _G.Config.FollowBackwardsAA, Callback = function(v) _G.Config.FollowBackwardsAA = v end})
local AllDirectionsToggle = AntiAimSection:Toggle({Name = "360 Mode (Rage)", Flag = "BS_AllDirections", Default = _G.Config.AllDirections, Callback = function(v) _G.Config.AllDirections = v end})
AntiAimSection:Keybind({Name = "360 Mode Key", Flag = "Mode360Key", Default = Enum.UserInputType.None, Callback = function() AllDirectionsToggle:Set(not _G.Config.AllDirections) end})

local BacktrackSection = RagePage:Section({Name = "Backtrack", Description = "History Manipulation", Icon = "108839695397679", Side = 2})
BacktrackSection:Dropdown({Name = "History Amount", Flag = "HistoryPreset", Default = {_G.Config.HistoryPreset}, Items = {"Low", "Medium", "High", "Maximum"}, Multi = false, Callback = function(v) _G.Config.HistoryPreset = v; if v == "Low" then _G.Config.BacktrackTime = 0.1 elseif v == "Medium" then _G.Config.BacktrackTime = 0.2 elseif v == "High" then _G.Config.BacktrackTime = 0.5 elseif v == "Maximum" then _G.Config.BacktrackTime = 1.0 end end})
BacktrackSection:Toggle({Name = "History Visuals", Flag = "BS_BacktrackChams", Default = _G.Config.BacktrackChams, Callback = function(v) _G.Config.BacktrackChams = v end}):Settings(250):Label("Color"):Colorpicker({Name = "Color", Flag = "BacktrackChamsColor", Default = _G.Config.BacktrackChamsColor, Callback = function(v) _G.Config.BacktrackChamsColor = v end})
BacktrackSection:Dropdown({Name = "Visual Style", Flag = "BacktrackChamsStyle", Default = {_G.Config.BacktrackChamsStyle}, Items = {"Shaded", "Solid", "Glow", "Glow Outline", "Hyper Glow", "Iridescent", "Water Flow"}, Multi = false, Callback = function(v) _G.Config.BacktrackChamsStyle = v end})
BacktrackSection:Toggle({Name = "Self Backtrack", Flag = "SelfBacktrack", Default = _G.Config.SelfBacktrack, Callback = function(v) _G.Config.SelfBacktrack = v end})

Window:Category("Visuals")
local VisualsPage = Window:Page({Name = "Visuals & ESP", Icon = "100050851789190", Columns = 2})

local EspSection = VisualsPage:Section({Name = "ESP", Description = "Wallhack Settings", Icon = "100050851789190", Side = 1})
local EspToggle = EspSection:Toggle({Name = "Enable ESP", Flag = "BS_Esp", Default = _G.Config.Esp, Callback = function(Value) _G.Config.Esp = Value end})
EspSection:Keybind({Name = "ESP Key", Flag = "EspKey", Default = Enum.UserInputType.None, Callback = function(Value) EspToggle:Set(not _G.Config.Esp) end})
EspSection:Toggle({Name = "Boxes", Flag = "BS_EspBoxes", Default = _G.Config.EspBoxes, Callback = function(v) _G.Config.EspBoxes = v end}):Settings(250):Label("Box Color"):Colorpicker({Name = "Color", Flag = "BoxColor", Default = _G.Config.BoxColor, Callback = function(v) _G.Config.BoxColor = v end})
EspSection:Toggle({Name = "Names", Flag = "BS_EspNames", Default = _G.Config.EspNames, Callback = function(v) _G.Config.EspNames = v end}):Settings(250):Label("Name Color"):Colorpicker({Name = "Color", Flag = "NameColor", Default = _G.Config.NameColor, Callback = function(v) _G.Config.NameColor = v end})
EspSection:Toggle({Name = "Health Bar", Flag = "BS_EspHealthBar", Default = _G.Config.EspHealthBar, Callback = function(v) _G.Config.EspHealthBar = v end}):Settings(250):Label("Health Bar Color"):Colorpicker({Name = "Color", Flag = "HealthBarColor", Default = _G.Config.HealthBarColor, Callback = function(v) _G.Config.HealthBarColor = v end})
EspSection:Toggle({Name = "Distance", Flag = "BS_EspDistance", Default = _G.Config.EspDistance, Callback = function(v) _G.Config.EspDistance = v end}):Settings(250):Label("Distance Color"):Colorpicker({Name = "Color", Flag = "DistColor", Default = _G.Config.DistColor, Callback = function(v) _G.Config.DistColor = v end})
EspSection:Toggle({Name = "Head Dot", Flag = "BS_EspHeadDot", Default = _G.Config.EspHeadDot, Callback = function(v) _G.Config.EspHeadDot = v end}):Settings(250):Label("Head Dot Color"):Colorpicker({Name = "Color", Flag = "HeadDotColor", Default = _G.Config.HeadDotColor, Callback = function(v) _G.Config.HeadDotColor = v end})
EspSection:Toggle({Name = "Weapon", Flag = "BS_EspWeapon", Default = _G.Config.EspWeapon, Callback = function(v) _G.Config.EspWeapon = v end}):Settings(250):Label("Weapon Color"):Colorpicker({Name = "Color", Flag = "WeaponColor", Default = _G.Config.WeaponColor, Callback = function(v) _G.Config.WeaponColor = v end})
EspSection:Toggle({Name = "Inventory", Flag = "BS_EspInventory", Default = _G.Config.EspInventory, Callback = function(v) _G.Config.EspInventory = v end})

local ChamsSection = VisualsPage:Section({Name = "Chams & Effects & Team", Description = "Advanced Visuals", Icon = "100050851789190", Side = 1})
ChamsSection:Toggle({Name = "Offscreen Arrows", Flag = "BS_EspOffscreenArrows", Default = _G.Config.EspOffscreenArrows, Callback = function(v) _G.Config.EspOffscreenArrows = v end})
ChamsSection:Toggle({Name = "Chams (Bypass)", Flag = "BS_EspChams", Default = _G.Config.EspChams, Callback = function(v) _G.Config.EspChams = v end}):Settings(250):Label("AlwaysOnTop"):Colorpicker({Name = "Hidden Color", Flag = "ChamHiddenColor", Default = Color3.fromRGB(255, 0, 0), Callback = function(v) _G.Config.ChamHiddenColor = v end}) 
ChamsSection:Toggle({Name = "Soul Particles", Flag = "BS_EspSoulParticles", Default = _G.Config.EspSoulParticles, Callback = function(v) _G.Config.EspSoulParticles = v end})
ChamsSection:Toggle({Name = "On Shot Effect", Flag = "BS_EspOnShotChams", Default = _G.Config.EspOnShotChams, Callback = function(v) _G.Config.EspOnShotChams = v end})
ChamsSection:Toggle({Name = "Bullet Impacts", Flag = "BS_ShowImpacts", Default = _G.Config.ShowImpacts, Callback = function(v) _G.Config.ShowImpacts = v end})
ChamsSection:Toggle({Name = "China Hat", Flag = "BS_EspChinaHat", Default = _G.Config.EspChinaHat, Callback = function(v) _G.Config.EspChinaHat = v end})
ChamsSection:Toggle({Name = "Self China Hat", Flag = "BS_EspSelfChinaHat", Default = _G.Config.EspSelfChinaHat, Callback = function(v) _G.Config.EspSelfChinaHat = v end})
ChamsSection:Toggle({Name = "Rainbow Hat", Flag = "BS_EspChinaHatRainbow", Default = _G.Config.EspChinaHatRainbow, Callback = function(v) _G.Config.EspChinaHatRainbow = v end})

local TeamSection = VisualsPage:Section({Name = "Team Settings", Description = "Colors & Management", Icon = "100050851789190", Side = 2})
TeamSection:Dropdown({Name = "Team Mode", Flag = "EspTeamMode", Default = {_G.Config.EspTeamMode}, Items = {"Enemies", "Teammates", "All"}, Multi = false, Callback = function(v) _G.Config.EspTeamMode = v end})
TeamSection:Toggle({Name = "Team Check", Flag = "BS_UseTeamCheck", Default = _G.Config.UseTeamCheck, Callback = function(v) _G.Config.UseTeamCheck = v end})
TeamSection:Label("Colors"):Colorpicker({Name = "Enemy Color", Flag = "EnemyColor", Default = _G.Config.EnemyColor, Callback = function(v) _G.Config.EnemyColor = v end})
TeamSection:Label("Teammate Color"):Colorpicker({Name = "Teammate Color", Flag = "TeammateColor", Default = _G.Config.TeammateColor, Callback = function(v) _G.Config.TeammateColor = v end})

local WeaponAndWorldPage = Window:Page({Name = "World & Combat", Icon = "100050851789190", Columns = 2})

local WorldSection = WeaponAndWorldPage:Section({Name = "World", Description = "Skybox & Lighting", Icon = "123944728972740", Side = 1})
local skyNames = {}
if skyboxtable then for k, v in pairs(skyboxtable) do table.insert(skyNames, k) end table.sort(skyNames) end
WorldSection:Toggle({Name = "Enable Skybox", Flag = "BS_WorldSkyboxEnabled", Default = _G.Config.WorldSkyboxEnabled, Callback = function(v) _G.Config.WorldSkyboxEnabled = v; if v then UpdateSkybox(_G.Config.WorldSkybox) end end})
WorldSection:Dropdown({Name = "Skybox Preset", Flag = "WorldSkybox", Default = {_G.Config.WorldSkybox}, Items = skyNames, Multi = false, Callback = function(v) _G.Config.WorldSkybox = v; if _G.Config.WorldSkyboxEnabled then UpdateSkybox(v) end end})
WorldSection:Dropdown({Name = "Weather", Flag = "WeatherType", Default = {"None"}, Items = {"None", "Rain", "Snow", "Hell Fire"}, Multi = false, Callback = function(v) UpdateWeather(v) end})
WorldSection:Toggle({Name = "Enable Time", Flag = "BS_WorldTimeEnabled", Default = _G.Config.WorldTimeEnabled, Callback = function(v) _G.Config.WorldTimeEnabled = v; UpdateLighting() end})
WorldSection:Slider({Name = "Clock Time", Flag = "WorldClockTime", Min = 0, Max = 24, Default = SafeNum(_G.Config.WorldClockTime, 12), Decimals = 1, Suffix = "h", Callback = function(v) _G.Config.WorldClockTime = v; UpdateLighting() end})
WorldSection:Toggle({Name = "Enable Brightness", Flag = "BS_WorldBrightEnabled", Default = _G.Config.WorldBrightEnabled, Callback = function(v) _G.Config.WorldBrightEnabled = v; UpdateLighting() end})
WorldSection:Slider({Name = "Brightness", Flag = "WorldBrightness", Min = 0, Max = 10, Default = SafeNum(_G.Config.WorldBrightness, 2), Decimals = 1, Suffix = "x", Callback = function(v) _G.Config.WorldBrightness = v; UpdateLighting() end})
WorldSection:Toggle({Name = "Enable Colors", Flag = "BS_WorldColorEnabled", Default = _G.Config.WorldColorEnabled, Callback = function(v) _G.Config.WorldColorEnabled = v; UpdateLighting() end})
WorldSection:Label("Ambient Color"):Colorpicker({Name = "Ambient", Flag = "WorldAmbient", Default = _G.Config.WorldAmbient, Callback = function(v) _G.Config.WorldAmbient = v; UpdateLighting() end})
WorldSection:Label("Outdoor Color"):Colorpicker({Name = "Outdoor", Flag = "WorldOutdoorAmbient", Default = _G.Config.WorldOutdoorAmbient, Callback = function(v) _G.Config.WorldOutdoorAmbient = v; UpdateLighting() end})

local CombatVisualsSection = WeaponAndWorldPage:Section({Name = "Combat Visuals", Description = "Impacts & Tracers", Icon = "103180437044643", Side = 2})
CombatVisualsSection:Toggle({Name = "Bullet Tracers", Flag = "BS_ShowTracers", Default = _G.Config.ShowTracers, Callback = function(v) _G.Config.ShowTracers = v end}):Settings(250):Label("Tracer Color"):Colorpicker({Name = "Color", Flag = "BulletTracerColor", Default = _G.Config.BulletTracerColor, Callback = function(v) _G.Config.BulletTracerColor = v end})
CombatVisualsSection:Slider({Name = "Tracer Time", Flag = "TracerDuration", Min = 1, Max = 10, Default = _G.Config.TracerDuration, Decimals = 1, Suffix = "s", Callback = function(v) _G.Config.TracerDuration = v end})
CombatVisualsSection:Toggle({Name = "Hit Marker", Flag = "BS_ShowHitmark", Default = _G.Config.ShowHitmark, Callback = function(v) _G.Config.ShowHitmark = v end}):Settings(250):Label("Color"):Colorpicker({Name = "Hit Color", Flag = "HitmarkColor", Default = _G.Config.HitmarkColor, Callback = function(v) _G.Config.HitmarkColor = v end})
CombatVisualsSection:Slider({Name = "Hit Marker Time", Flag = "HitmarkDuration", Min = 0.1, Max = 5, Default = _G.Config.HitmarkDuration, Decimals = 1, Suffix = "s", Callback = function(v) _G.Config.HitmarkDuration = v end})
CombatVisualsSection:Toggle({Name = "Hit Sound", Flag = "BS_PlayHitSound", Default = _G.Config.PlayHitSound, Callback = function(v) _G.Config.PlayHitSound = v end})
CombatVisualsSection:Toggle({Name = "Hit Logs (Console)", Flag = "BS_ShowHitLogs", Default = _G.Config.ShowHitLogs, Callback = function(v) _G.Config.ShowHitLogs = v end})
CombatVisualsSection:Toggle({Name = "Show Penetration", Flag = "BS_ShowPenetration", Default = _G.Config.ShowPenetration, Callback = function(v) _G.Config.ShowPenetration = v end})
CombatVisualsSection:Toggle({Name = "Show Real Spread", Flag = "BS_ShowSpread", Default = _G.Config.ShowSpread, Callback = function(v) _G.Config.ShowSpread = v end}):Settings(250):Label("Spread Color"):Colorpicker({Name = "Color", Flag = "SpreadColor", Default = _G.Config.SpreadColor, Callback = function(v) _G.Config.SpreadColor = v end})

local EffectsSection = WeaponAndWorldPage:Section({Name = "Effects", Description = "Kill & Particles", Icon = "100050851789190", Side = 1})
EffectsSection:Toggle({Name = "Kill Effects", Flag = "BS_KillEffect", Default = _G.Config.KillEffect, Callback = function(v) _G.Config.KillEffect = v end})
EffectsSection:Dropdown({Name = "Effect Mode", Flag = "KillEffectMode", Default = {_G.Config.KillEffectMode}, Items = {"Rocket", "Lightning", "Nuke", "Black Hole", "Disintegrate", "Ascension", "Digital"}, Multi = false, Callback = function(v) _G.Config.KillEffectMode = v end})
EffectsSection:Slider({Name = "Duration", Flag = "KillEffectDuration", Min = 1, Max = 10, Default = SafeNum(_G.Config.KillEffectDuration, 3), Decimals = 1, Suffix = "s", Callback = function(v) _G.Config.KillEffectDuration = v end})
EffectsSection:Toggle({Name = "Custom Particles", Flag = "BS_CustomParticles", Default = _G.Config.CustomParticles, Callback = function(v) _G.Config.CustomParticles = v end})
EffectsSection:Label("Particle Color"):Colorpicker({Name = "Color", Flag = "ParticleColor", Default = _G.Config.ParticleColor, Callback = function(v) _G.Config.ParticleColor = v end})

local TacticalSection = WeaponAndWorldPage:Section({Name = "Tactical", Description = "Grenades & C4", Icon = "100050851789190", Side = 2})
TacticalSection:Toggle({Name = "Molotov Zones", Flag = "BS_MolotovZoneESP", Default = _G.Config.MolotovZoneESP, Callback = function(v) _G.Config.MolotovZoneESP = v end}):Settings(250):Label("Zone Color"):Colorpicker({Name = "Color", Flag = "GrenadeZoneColor", Default = _G.Config.GrenadeZoneColor, Callback = function(v) _G.Config.GrenadeZoneColor = v end})
TacticalSection:Toggle({Name = "Smoke Zones", Flag = "BS_SmokeZoneESP", Default = _G.Config.SmokeZoneESP, Callback = function(v) _G.Config.SmokeZoneESP = v end})
TacticalSection:Toggle({Name = "Grenade Warning", Flag = "BS_GrenadeESP", Default = _G.Config.GrenadeESP, Callback = function(v) _G.Config.GrenadeESP = v end})
TacticalSection:Toggle({Name = "Grenade Shrapnel", Flag = "BS_GrenadeTracers", Default = _G.Config.GrenadeTracers, Callback = function(v) _G.Config.GrenadeTracers = v end})
TacticalSection:Toggle({Name = "Grenade ESP", Flag = "BS_GrenadeESP", Default = _G.Config.GrenadeESP, Callback = function(v) _G.Config.GrenadeESP = v end})
TacticalSection:Toggle({Name = "Grenade Tracers", Flag = "BS_GrenadeTracers", Default = _G.Config.GrenadeTracers, Callback = function(v) _G.Config.GrenadeTracers = v end})

Window:Category("Misc")
local MiscPage = Window:Page({Name = "Misc", Icon = "134236649319095", Columns = 2})

local MovementSection = MiscPage:Section({Name = "Movement", Description = "Bhop & Peeking", Icon = "103180437044643", Side = 1})
local BhopToggle = MovementSection:Toggle({Name = "Bunny Hop", Flag = "BS_Bhop", Default = _G.Config.Bhop, Callback = function(v) _G.Config.Bhop = v end})
MovementSection:Keybind({Name = "Bhop Key", Flag = "BhopKey", Default = Enum.UserInputType.None, Callback = function() BhopToggle:Set(not _G.Config.Bhop) end})
MovementSection:Slider({Name = "Bhop Speed", Flag = "BhopSpeed", Min = 1, Max = 30, Default = SafeNum(_G.Config.BhopSpeed, 18), Decimals = 1, Suffix = "spd", Callback = function(v) _G.Config.BhopSpeed = v end})
MovementSection:Toggle({Name = "No Fall Damage", Flag = "BS_NoFallDamage", Default = _G.Config.NoFallDamage, Callback = function(v) _G.Config.NoFallDamage = v end})
local QuickStopToggle = MovementSection:Toggle({Name = "Quick Stop", Flag = "BS_AutoStop", Default = _G.Config.AutoStop, Callback = function(v) _G.Config.AutoStop = v end})
MovementSection:Keybind({Name = "Quick Stop Key", Flag = "AutoStopKey", Default = Enum.UserInputType.None, Callback = function() QuickStopToggle:Set(not _G.Config.AutoStop) end})
MovementSection:Dropdown({Name = "Stop Options", Flag = "QuickStopOptions", Default = _G.Config.QuickStopOptions, Items = {"Early", "In Air", "Duck", "Move Between Shots", "On Land"}, Multi = true, Callback = function(v) _G.Config.QuickStopOptions = v end})
local AutoPeekToggle = MovementSection:Toggle({Name = "Auto Peek", Flag = "BS_AutoPeek", Default = _G.Config.AutoPeek, Callback = function(v) _G.Config.AutoPeek = v end})
MovementSection:Keybind({Name = "Auto Peek Key", Flag = "AutoPeekKey", Default = Enum.UserInputType.None, Callback = function() AutoPeekToggle:Set(not _G.Config.AutoPeek) end})
local FakeDuckToggle = MovementSection:Toggle({Name = "Fake Duck", Flag = "BS_FakeDuck", Default = _G.Config.FakeDuck, Callback = function(v) _G.Config.FakeDuck = v end})
MovementSection:Keybind({Name = "Fake Duck Key", Flag = "FakeDuckKey", Default = Enum.UserInputType.None, Callback = function() FakeDuckToggle:Set(not _G.Config.FakeDuck) end})

local CameraSection = MiscPage:Section({Name = "Camera & View", Description = "View Options", Icon = "103180437044643", Side = 2})
local ThirdPersonToggle = CameraSection:Toggle({
    Name = "Third Person",
    Flag = "ThirdPerson",
    Default = _G.Config.ThirdPerson,
    Callback = function(Value)
        _G.Config.ThirdPerson = Value
        if Value then
            LP.CameraMode = Enum.CameraMode.Classic
            LP.CameraMaxZoomDistance = _G.Config.ThirdPersonDist
            LP.CameraMinZoomDistance = _G.Config.ThirdPersonDist
        else
            LP.CameraMode = Enum.CameraMode.LockFirstPerson
            LP.CameraMaxZoomDistance = 0.5
            LP.CameraMinZoomDistance = 0.5
        end
    end
})
CameraSection:Keybind({Name = "Third Person Key", Flag = "ThirdPersonKey", Default = Enum.UserInputType.None, Callback = function() ThirdPersonToggle:Set(not _G.Config.ThirdPerson) end})
CameraSection:Slider({Name = "Distance", Flag = "ThirdPersonDist", Min = 5, Max = 50, Default = SafeNum(_G.Config.ThirdPersonDist, 10), Decimals = 1, Suffix = "studs", Callback = function(Value)
    _G.Config.ThirdPersonDist = Value
    if _G.Config.ThirdPerson then
        LP.CameraMaxZoomDistance = Value
        LP.CameraMinZoomDistance = Value
    end
end})
local CustomFovToggle = CameraSection:Toggle({Name = "Custom FOV (Base)", Flag = "BS_EnableFov", Default = _G.Config.EnableFov, Callback = function(v) _G.Config.EnableFov = v end})
CameraSection:Keybind({Name = "Custom FOV Key", Flag = "CustomFovKey", Default = Enum.UserInputType.None, Callback = function() CustomFovToggle:Set(not _G.Config.EnableFov) end})
CameraSection:Slider({Name = "FOV Amount", Flag = "CustomFovValue", Min = 30, Max = 150, Default = SafeNum(_G.Config.CustomFovValue, 100), Decimals = 0, Suffix = "簞", Callback = function(v) _G.Config.CustomFovValue = v end})
CameraSection:Toggle({Name = "Custom Scope FOV", Flag = "BS_CustomScopeFov", Default = _G.Config.CustomScopeFov, Callback = function(v) _G.Config.CustomScopeFov = v end})
CameraSection:Slider({Name = "Scope FOV", Flag = "ScopeFovValue_V2", Min = 10, Max = 100, Default = SafeNum(_G.Config.ScopeFovValue, 40), Decimals = 1, Suffix = "deg", Callback = function(v) _G.Config.ScopeFovValue = v end})
CameraSection:Toggle({Name = "Remove Scope", Flag = "BS_RemoveScope", Default = _G.Config.RemoveScope, Callback = function(v) _G.Config.RemoveScope = v end})
CameraSection:Toggle({Name = "Show FOV Circle", Flag = "BS_ShowFov", Default = _G.Config.ShowFov, Callback = function(v) _G.Config.ShowFov = v end})
CameraSection:Slider({Name = "FOV Radius", Flag = "FovRadius", Min = 10, Max = 800, Default = SafeNum(_G.Config.FovRadius, 100), Decimals = 1, Suffix = "px", Callback = function(v) _G.Config.FovRadius = v end})

local RemovalsSection = MiscPage:Section({Name = "Removals", Description = "No Flash/Smoke", Icon = "123944728972740", Side = 2})
local NoFlashToggle = RemovalsSection:Toggle({Name = "No Flash", Flag = "BS_NoFlash", Default = _G.Config.NoFlash, Callback = function(v) _G.Config.NoFlash = v end})
RemovalsSection:Keybind({Name = "No Flash Key", Flag = "NoFlashKey", Default = Enum.UserInputType.None, Callback = function() NoFlashToggle:Set(not _G.Config.NoFlash) end})
local NoSmokeToggle = RemovalsSection:Toggle({Name = "No Smoke", Flag = "BS_NoSmoke", Default = _G.Config.NoSmoke, Callback = function(v) _G.Config.NoSmoke = v end})
RemovalsSection:Keybind({Name = "No Smoke Key", Flag = "NoSmokeKey", Default = Enum.UserInputType.None, Callback = function() NoSmokeToggle:Set(not _G.Config.NoSmoke) end})
RemovalsSection:Toggle({Name = "Colored Smoke", Flag = "BS_ColoredSmoke", Default = _G.Config.ColoredSmoke, Callback = function(v) _G.Config.ColoredSmoke = v end}):Settings(250):Label("Smoke Color"):Colorpicker({Name = "Color", Flag = "SmokeColor", Default = _G.Config.SmokeColor, Callback = function(v) _G.Config.SmokeColor = v end})
RemovalsSection:Toggle({Name = "No Recoil (Visual)", Flag = "BS_NoRecoilVisual", Default = _G.Config.NoRecoilVisual, Callback = function(v) _G.Config.NoRecoilVisual = v; UpdateRecoil() end})
RemovalsSection:Toggle({Name = "No Recoil (Real)", Flag = "BS_NoRecoilReal", Default = _G.Config.NoRecoilReal, Callback = function(v) _G.Config.NoRecoilReal = v; UpdateRecoil() end})
RemovalsSection:Toggle({Name = "No Spread", Flag = "BS_NoSpread", Default = _G.Config.NoSpread, Callback = function(v) _G.Config.NoSpread = v end})

Window:Category("Config")
    
    local SettingsPage = Window:Page({Name = "Configuration", Icon = "108839695397679", Columns = 2})
    

    local ConfigSection = SettingsPage:Section({Name = "Config Manager", Description = "Save/Load Settings", Icon = "108839695397679", Side = 1})
    local ConfigName = "Legit"
    local SelectedConfig = nil
    
    local function GetConfigList()
        local list = {}
        if isfolder and isfolder("Icantsoplarping Hub/configs") then
            if listfiles then
                for _, file in ipairs(listfiles("Icantsoplarping Hub/configs")) do
                    if file:match("%.json$") then
                        local name = file:match("[^\\/]+$"):gsub("%.json$", "")
                        table.insert(list, name)
                    end
                end
            end
        end
        return list
    end
    
    local ConfigList = GetConfigList()
    
    local ConfigDropdown = ConfigSection:Dropdown({
        Name = "Select Config",
        Flag = "ConfigSelect",
        List = ConfigList,
        Default = ConfigList[1],
        Callback = function(val)
            SelectedConfig = val
            ConfigName = val 
        end
    })
    
    ConfigSection:Textbox({
        Name = "New Config Name",
        Flag = "ConfigNameInput",
        Default = "",
        Placeholder = "Type name to save...",
        Callback = function(text)
            ConfigName = text
        end
    })
    
    ConfigSection:Button({
        Name = "Refresh List",
        Callback = function()
            local newList = GetConfigList()
            ConfigDropdown:Refresh(newList)
            if #newList > 0 then
                ConfigDropdown:Set(newList[1])
            end
        end
    })
    
    ConfigSection:Button({
        Name = "Save Config",
        Callback = function()
            if not writefile then return end
            if not isfolder("Icantsoplarping Hub/configs") then makefolder("Icantsoplarping Hub/configs") end
            
            local nameToSave = ConfigName
            if not nameToSave or nameToSave == "" then 
                 nameToSave = SelectedConfig or "default" 
            end
            

            local SaveData = {}
            for k, v in pairs(_G.Config) do
                
                if Library.Flags and Library.Flags[k] then
                    v = Library.Flags[k]
                elseif Library.Flags and Library.Flags["BS_"..k] then
                    v = Library.Flags["BS_"..k]
                end
                
                
                if typeof(v) == "EnumItem" then
                    SaveData[k] = {__ENUM = tostring(v)} 
                elseif typeof(v) == "Color3" then
                     SaveData[k] = {R=v.R, G=v.G, B=v.B} 
                else
                    SaveData[k] = v
                end
            end
            
            local json = game:GetService("HttpService"):JSONEncode(SaveData)
            writefile("Icanstoplarping Hub/configs/" .. nameToSave .. ".json", json)
            
            
            local newList = GetConfigList()
            ConfigDropdown:Refresh(newList)
            
            if Library and Library.Notify then
                Library:Notify({Title = "Config Saved", Content = "Saved " .. nameToSave .. ".json", Duration = 3})
            end
        end
    })
    
    ConfigSection:Button({
        Name = "Load Config",
        Callback = function()
            if not readfile or not isfile then return end
            if not SelectedConfig then 
                if Library.Notify then Library:Notify({Title = "Error", Content = "No config selected!", Duration = 3}) end
                return 
            end
            
            local path = "Icanstoplarping Hub/configs/" .. SelectedConfig .. ".json"
            if isfile(path) then
                local content = readfile(path)
                local data = game:GetService("HttpService"):JSONDecode(content)
                if data then
                    for k, v in pairs(data) do
                        
                        if type(v) == "table" and v.__ENUM then
                             
                             local enumStr = v.__ENUM
                             local enumTypeStr = enumStr:match("Enum%.([^%.]+)")
                             local enumItemStr = enumStr:match("Enum%.[^%.]+%.(.+)")
                             if enumTypeStr and enumItemStr then
                                 local enumType = Enum[enumTypeStr]
                                 if enumType then
                                     pcall(function()
                                         v = enumType[enumItemStr]
                                     end)
                                 end
                             end
                        elseif type(v) == "table" and v.R and v.G and v.B then
                             v = Color3.new(v.R, v.G, v.B)
                        end
                        
                        _G.Config[k] = v
                        

                        local flagsToCheck = {k, "BS_"..k}
                        for _, flag in ipairs(flagsToCheck) do
                            if Library.SetFlags and Library.SetFlags[flag] then
                                pcall(function()
                                    if typeof(v) == "EnumItem" then
                                        Library.SetFlags[flag]({Key = tostring(v), Mode = "Toggle"})
                                    else
                                        Library.SetFlags[flag](v)
                                    end
                                end)
                            end
                        end
                    end
                    if Library and Library.Notify then
                        Library:Notify({Title = "Config Loaded", Content = "Loaded " .. SelectedConfig, Duration = 3})
                    end
                end
            else
                if Library and Library.Notify then
                    Library:Notify({Title = "Load Failed", Content = "File not found!", Duration = 3})
                end
            end
        end
    })
    
    
    local UISettings = SettingsPage:Section({Name = "UI Settings", Description = "Keybinds & Theme", Icon = "103180437044643", Side = 2})
    UISettings:Keybind({
        Name = "Menu Toggle",
        Flag = "GuiToggleKey",
        Default = Enum.KeyCode.RightControl,
        Callback = function(Value)
            local newState = not Window.IsOpen
            Window:SetOpen(newState)
            
            if _G.SyncPreviewVisibility then _G.SyncPreviewVisibility(newState) end
        end
    })

    
Window:Init()
_G.LoadStage = 2
local MaterialLimits = {
    [Enum.Material.Asphalt] = 0.25,
    [Enum.Material.Basalt] = 0.25,
    [Enum.Material.Brick] = 0.25,
    [Enum.Material.Cobblestone] = 0.25,
    [Enum.Material.Concrete] = 0.25,
    [Enum.Material.CrackedLava] = 0.25,
    [Enum.Material.DiamondPlate] = 0.25,
    [Enum.Material.Foil] = 0.25,
    [Enum.Material.Glacier] = 0.25,
    [Enum.Material.Granite] = 0.25,
    [Enum.Material.Grass] = 0.25,
    [Enum.Material.Ground] = 0.25,
    [Enum.Material.Ice] = 0.25,
    [Enum.Material.LeafyGrass] = 0.25,
    [Enum.Material.Limestone] = 0.25,
    [Enum.Material.Marble] = 0.25,
    [Enum.Material.Metal] = 0.25,
    [Enum.Material.Mud] = 0.25,
    [Enum.Material.Pavement] = 0.25,
    [Enum.Material.Rock] = 0.25,
    [Enum.Material.Salt] = 0.25,
    [Enum.Material.Sand] = 0.25,
    [Enum.Material.Sandstone] = 0.25,
    [Enum.Material.Slate] = 0.25,
    [Enum.Material.Snow] = 0.25,
    [Enum.Material.ForceField] = 0.25,
    [Enum.Material.Neon] = 0.25,
    [Enum.Material.CorrodedMetal] = 0.25,
    [Enum.Material.Pebble] = 0.25,
    [Enum.Material.CeramicTiles] = 0.25,
    [Enum.Material.Plaster] = 0.25,
    [Enum.Material.Plastic] = 7,
    [Enum.Material.SmoothPlastic] = 7,
    [Enum.Material.Wood] = 7,
    [Enum.Material.WoodPlanks] = 7,
    [Enum.Material.Cardboard] = 7,
    [Enum.Material.Glass] = 100,
    [Enum.Material.Fabric] = 100
}

local LegitFovCircle = Drawing.new("Circle")
LegitFovCircle.Thickness = 1
LegitFovCircle.Transparency = 1 
LegitFovCircle.Color = Color3.fromRGB(0, 255, 0)
LegitFovCircle.Filled = false
LegitFovCircle.Visible = false

local function isVisibleForAimbot(targetChar)
    if not targetChar or not LP.Character then return false end
    
    
    
    local origin = LP.Character:FindFirstChild("Head")
    if not origin then origin = LP.Character:FindFirstChild("HumanoidRootPart") end
    if not origin then return false end
    local targetHead = targetChar:FindFirstChild(_G.Config.LegitBone or "Head") 
    if not targetHead then return false end
    local originPos = origin.Position
    local targetPos = targetHead.Position
    local direction = (targetPos - originPos)
    local distance = direction.Magnitude
    if distance == 0 then return true end
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LP.Character, Camera, workspace.CurrentCamera}
    if workspace:FindFirstChild("BacktrackChams") then
        local t = rayParams.FilterDescendantsInstances
        table.insert(t, workspace.BacktrackChams)
        rayParams.FilterDescendantsInstances = t
    end
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true
    
    local result = workspace:Raycast(originPos, direction, rayParams)
    
    return result == nil or result.Instance:IsDescendantOf(targetChar) or result.Distance >= distance - 1
end

RunService.RenderStepped:Connect(function()
    
    if _G.Config.LegitDrawFov and _G.Config.LegitAim then
        LegitFovCircle.Visible = true
        LegitFovCircle.Radius = _G.Config.LegitFov or 100
        LegitFovCircle.Position = UserInputService:GetMouseLocation()
    else
        LegitFovCircle.Visible = false
    end
    
    
    if _G.Config.LegitAim then
        local target = nil
        local dist = _G.Config.LegitFov or 100
        
        
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and isEnemy(p) and p.Character and p.Character:FindFirstChild(_G.Config.LegitBone or "Head") and 
                   p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                    
                    if _G.Config.LegitWallCheck then
                         local vis = isVisibleForAimbot(p.Character)
                         if not vis and _G.Config.LegitAutoWallbang then
                              
                              
                              local weaponPen = 2.5
                              if CurrentWeaponData and CurrentWeaponData.Penetration then
                                  weaponPen = CurrentWeaponData.Penetration
                              end
                              local bone = p.Character[_G.Config.LegitBone or "Head"]
                              if bone and IsHitPossible and IsHitPossible(p.Character, LP.Character.Head.Position, weaponPen, bone.Position) then
                                   vis = true
                              end
                         end
                         isTargetVisible = vis
                    end
                    
                    if isTargetVisible then 
                        local bone = p.Character[_G.Config.LegitBone or "Head"]
                        local pos, vis = Camera:WorldToViewportPoint(bone.Position)
                        if vis then
                            local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                            if mag < dist then
                                dist = mag
                                target = p
                            end
                        end
                    end
                end
            end
            
            if target and target.Character then
                local bone = target.Character:FindFirstChild(_G.Config.LegitBone or "Head")
                if bone then
                     local tPos = Camera:WorldToViewportPoint(bone.Position)
                     local mPos = UserInputService:GetMouseLocation()
                     
                         local baseSmooth = math.max(_G.Config.LegitSmooth or 10, 1)
                     if mousemoverel then
                         local targetX = tPos.X - mPos.X
                         local targetY = tPos.Y - mPos.Y
                         
                         local baseSmooth = math.max(_G.Config.LegitSmooth or 10, 1)
                         local dist = math.sqrt(targetX^2 + targetY^2)
                         
                         local dynamicFactor = 1
                         if dist > 100 then
                             dynamicFactor = 0.5
                         elseif dist < 30 then
                             dynamicFactor = 1.5
                         end
                         
                         local finalSmooth = baseSmooth * dynamicFactor
                         
                         local jitterX = math.random(-10, 10) / 10
                         local jitterY = math.random(-10, 10) / 10
                         
                         local moveX = (targetX / finalSmooth) + jitterX
                         local moveY = (targetY / finalSmooth) + jitterY
                         
                         mousemoverel(moveX, moveY)
                     else
                         
                         local currentCF = Camera.CFrame
                         local targetPos = bone.Position
                         local limit = (_G.Config.LegitSmooth or 10)
                         local goalCF = CFrame.new(currentCF.Position, targetPos)
                         Camera.CFrame = currentCF:Lerp(goalCF, 1 / limit)
                     end
                end
            end
        end
    end
end)


UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        if _G.Config.AutoScope and CurrentWeaponName and LP.Character then
            local isScoped = (LP:GetAttribute("ScopeIncrement") or 0) > 0
            if not isScoped then
                task.spawn(function()
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendMouseButtonEvent(0, 0, 1, true, game, 1)  
                    task.wait(math.random(0.15, 0.2))
                    
                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)  
                    task.wait()
                    vim:SendMouseButtonEvent(0, 0, 0, false, game, 1) 
                    
                    task.wait(math.random(0.1, 0.15))

                    vim:SendMouseButtonEvent(0, 0, 1, false, game, 1) 
                end)
            end
        end
    end
end)
local MaterialVariantLimits = {
    ["IndoorWall"] = 0.25,
    ["Sandy Brick"] = 0.25
}
local AdvancedVisuals = {
    Highlights = {},
    Particles = {},
    Arrows = {}
}
local function CreateArrow()
    local arrow = Drawing.new("Triangle")
    arrow.Thickness = 1
    arrow.Filled = true
    arrow.Color = Color3.fromRGB(255, 50, 50)
    arrow.Visible = false
    arrow.ZIndex = 2
    return arrow
end
local function EnsureHighlight(char, color, style)
    if not char then return nil end
    local hl = char:FindFirstChild("BloxStrikeHighlight") 
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "BloxStrikeHighlight"
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 1
        hl.Parent = char
    end
    hl.FillColor = color
    hl.OutlineColor = color 
    if style == "Hidden" then
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    else 
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
    return hl
end


local function CleanupDebris()
    local debris = workspace:FindFirstChild("Debris")
    if debris then
        debris.ChildAdded:Connect(function(child)
            task.delay(0.1, function() 
                if child:IsA("Model") then
                    local hl = child:FindFirstChild("BloxStrikeHighlight")
                    if hl then hl:Destroy() end
                end
            end)
        end)
    end
end
task.spawn(CleanupDebris)
local function EnsureParticles(root)
    if not root then return end
    local emitter = root:FindFirstChild("SoulParticles")
    if not emitter then
        emitter = Instance.new("ParticleEmitter")
        emitter.Name = "SoulParticles"
        emitter.Parent = root
        emitter.Texture = "rbxassetid://244221604" 
        emitter.Lifetime = NumberRange.new(0.5, 1)
        emitter.Rate = 5
        emitter.Speed = NumberRange.new(2, 4)
        emitter.SpreadAngle = Vector2.new(360, 360)
        emitter.Color = ColorSequence.new(Color3.fromRGB(150, 100, 255))
        emitter.LightEmission = 1
        emitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 1)})
        emitter.Enabled = true
    end
    return emitter
end
RunService.RenderStepped:Connect(function()
    if not _G.LoadStage or _G.LoadStage < 1 then return end
    local EnableArrows = _G.Config.EspOffscreenArrows 
    local EnableChams = _G.Config.EspChams 
    local EnableParticles = _G.Config.EspSoulParticles 
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, p in pairs(Players:GetPlayers()) do
        local is_enemy = isEnemy(p)
        local keepSelf = (p == LP and _G.Config.EspSelfChinaHat)
        local keepEnemy = (is_enemy)
        if (not keepEnemy and not keepSelf and _G.Config.EspTeamMode == "Enemies") or (not _G.Config.Esp and not keepSelf) then 
            local char = p.Character
            if char then
                local hl = char:FindFirstChild("BloxStrikeHighlight")
                if hl then hl:Destroy() end
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and root:FindFirstChild("SoulParticles") then root.SoulParticles:Destroy() end
                local head = char:FindFirstChild("Head")
                if head and head:FindFirstChild("ChinaHat") then head.ChinaHat:Destroy() end
            end
             if AdvancedVisuals.Arrows[p] then 
                 AdvancedVisuals.Arrows[p].Visible = false 
             end
            continue 
        end
        local char = p.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local root = char.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if not AdvancedVisuals.Arrows[p] then AdvancedVisuals.Arrows[p] = CreateArrow() end
            local arrow = AdvancedVisuals.Arrows[p]
            if EnableArrows and is_enemy and p ~= LP then
                if onScreen then
                    arrow.Visible = false
                else
                    arrow.Visible = true
                    local relative = (root.Position - Camera.CFrame.Position)
                    local forward = Camera.CFrame.LookVector
                    local side = Camera.CFrame.RightVector
                    local up = Camera.CFrame.UpVector
                    local relX = relative:Dot(side)
                    local relY = relative:Dot(up)
                    local relZ = relative:Dot(forward)
                    local angle = math.atan2(relY, relX)
                    local size = 15
                    local arrowPos = center + Vector2.new(math.cos(angle) * (center.X - 50), math.sin(angle) * (center.Y - 50))
                    local tip = arrowPos
                    local backLeft = arrowPos + Vector2.new(math.cos(angle + 2.5) * size, math.sin(angle + 2.5) * size)
                    local backRight = arrowPos + Vector2.new(math.cos(angle - 2.5) * size, math.sin(angle - 2.5) * size)
                    arrow.PointA = tip
                    arrow.PointB = backLeft
                    arrow.PointC = backRight
                    arrow.Color = _G.Config.EnemyColor or Color3.fromRGB(255, 0, 0)
                end
            else
                arrow.Visible = false
            end
            if EnableChams and is_enemy and p ~= LP then
                local ray = Ray.new(Camera.CFrame.Position, (root.Position - Camera.CFrame.Position).Unit * 500)
                local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LP.Character, Camera, char})
                local isVisible = (not hit or hit:IsDescendantOf(char))
                local color = isVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                if not isVisible then 
                    color = Color3.fromRGB(255, 0, 0) 
                else
                    color = Color3.fromRGB(0, 255, 0) 
                end
                EnsureHighlight(char, color, "Visible")
            else
                local hl = char:FindFirstChild("BloxStrikeHighlight")
                if hl then hl:Destroy() end
            end
            if EnableParticles and is_enemy and p ~= LP then
                EnsureParticles(root)
            else
                if root:FindFirstChild("SoulParticles") then root.SoulParticles:Destroy() end
            end
            local showHat = false
            local hatColor = _G.Config.EnemyColor or Color3.fromRGB(255, 0, 0)
            if p == LP then
                if _G.Config.EspSelfChinaHat then
                    showHat = true
                    hatColor = _G.Config.TeammateColor or Color3.fromRGB(0, 255, 0)
                end
            elseif is_enemy then
                if _G.Config.EspChinaHat then
                    showHat = true
                    hatColor = _G.Config.EnemyColor or Color3.fromRGB(255, 0, 0)
                end
            end
            if showHat and _G.Config.EspChinaHatRainbow then
                local t = tick()
                hatColor = Color3.fromHSV((t % 2) / 2, 1, 1) 
            end
            if showHat then
                 local head = char:FindFirstChild("Head")
                 if head then
                     local m = head:FindFirstChild("ChinaHat")
                     if not m then
                         m = Instance.new("Part")
                         m.Name = "ChinaHat"
                         m.Size = Vector3.new(3, 1, 3) 
                         m.Anchored = true
                         m.CanCollide = false
                         m.CanQuery = false
                         m.Transparency = 0.5
                         m.Material = Enum.Material.ForceField
                         m.Parent = head
                         local mesh = Instance.new("SpecialMesh")
                         mesh.MeshType = Enum.MeshType.FileMesh
                         mesh.MeshId = "http://www.roblox.com/asset/?id=1033714" 
                         mesh.Scale = Vector3.new(2, 2, 2)
                         mesh.Parent = m
                     end
                     m.Color = hatColor
                     local spinSpeed = 2
                     local rotation = (tick() * spinSpeed) % (math.pi * 2)
                     m.CFrame = head.CFrame * CFrame.new(0, 1.2, 0) * CFrame.Angles(0, rotation, 0)
                 end
            else
                 local head = char:FindFirstChild("Head")
                 if head and head:FindFirstChild("ChinaHat") then head.ChinaHat:Destroy() end
            end
        else
             if AdvancedVisuals.Arrows[p] then AdvancedVisuals.Arrows[p].Visible = false end
             if char then
                 local hl = char:FindFirstChild("BloxStrikeHighlight")
                 if hl then hl:Destroy() end
                 if char:FindFirstChild("HumanoidRootPart") then
                     local root = char.HumanoidRootPart
                     if root:FindFirstChild("SoulParticles") then root.SoulParticles:Destroy() end
                 end
                 local head = char:FindFirstChild("Head")
                 if head and head:FindFirstChild("ChinaHat") then head.ChinaHat:Destroy() end
             end
        end
    end
end)
local InventoryController
task.spawn(function()
    local s, r = pcall(function() return require(game:GetService("ReplicatedStorage").Controllers.InventoryController) end)
    if s and r then InventoryController = r end
end)
local function GetPenetrationStats(origin, direction, maxPen, ignoreList, targetRoot)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.CollisionGroup = "Bullet"
    local filter = ignoreList or {LP.Character, Camera}
    params.FilterDescendantsInstances = filter
    local currentOrigin = origin
    local currentDir = direction 
    local accMat = {} 
    local accVar = {} 
    local stats = {
        TotalThickness = 0,
        MaterialStats = {},
        Success = false,
        FailReason = "Max Steps",
        EndPos = Vector3.zero
    }
    
    
    local backParams = RaycastParams.new()
    backParams.FilterType = Enum.RaycastFilterType.Include
    backParams.CollisionGroup = "Bullet"

    for i = 1, 100 do
        if not currentOrigin or not currentDir then break end
        local result = Workspace:Raycast(currentOrigin, currentDir * 1000, params)
        if not result then 
            if not targetRoot then
                stats.Success = true
                stats.EndPos = currentOrigin + (currentDir * 1000)
            else
                stats.FailReason = "Void (Missed)"
            end
            break 
        end
        if not result.Instance or not result.Instance.Parent then
             stats.FailReason = "Destroyed Instance"
             break
        end
        if targetRoot and result.Instance:IsDescendantOf(targetRoot) then
            stats.Success = true
            stats.EndPos = result.Position
            stats.FailReason = "Hit"
            return stats
        end
        table.insert(filter, result.Instance)
        params.FilterDescendantsInstances = filter
        local enterPos = result.Position
        local fakeEnd = enterPos + (currentDir * 1000)
        
        
        backParams.FilterDescendantsInstances = {result.Instance}
        local backRes = Workspace:Raycast(fakeEnd, enterPos - fakeEnd, backParams)
        local thickness = 0.5 
        local limit = 0.25
        local matName = result.Instance.Material.Name
        if not backRes then
             thickness = 5
             stats.FailReason = "Infinite/Block"
        else
             thickness = (enterPos - backRes.Position).Magnitude
             local variant = backRes.Instance.MaterialVariant
             if variant ~= "" and MaterialVariantLimits[variant] then
                 matName = variant
                 limit = MaterialVariantLimits[variant]
                 accVar[variant] = (accVar[variant] or 0) + thickness
                 if accVar[variant] > limit + maxPen then
                     stats.FailReason = string.format("Var: %s (%.1f > %.1f)", variant, accVar[variant], limit + maxPen)
                     stats.MaterialStats = {Type = "Variant", Name = variant, Thickness = accVar[variant], Limit = limit + maxPen}
                     return stats 
                 end
             else
                 local mat = backRes.Material
                 matName = mat.Name
                 limit = MaterialLimits[mat] or 0.25
                 accMat[mat] = (accMat[mat] or 0) + thickness
                 if accMat[mat] > limit + maxPen then
                      stats.FailReason = string.format("%s (%.1f / %.1f)", matName, accMat[mat], limit + maxPen)
                      stats.MaterialStats = {Type = "Material", Name = matName, Thickness = accMat[mat], Limit = limit + maxPen}
                      return stats 
                 end
             end
             currentOrigin = backRes.Position 
        end
        stats.TotalThickness = stats.TotalThickness + thickness
    end
    return stats
end
local function IsHitPossible(targetInstance, origin, maxPen, explicitPos)
    if not targetInstance then return false end
    local targetRoot
    local targetPart
    if targetInstance:IsA("Model") then
        targetRoot = targetInstance
        targetPart = targetRoot:FindFirstChild(_G.Config.AimPart or "Head") or targetRoot:FindFirstChild("Head")
    elseif targetInstance:IsA("BasePart") then
         targetRoot = targetInstance.Parent
         targetPart = targetInstance 
    end
    if not targetPart or not targetRoot then return false end
    local targetPos = explicitPos or targetPart.Position
    local dir = (targetPos - origin).Unit
    local stats = GetPenetrationStats(origin, dir, maxPen, {LP.Character, Camera}, targetRoot)
    

    local minDmgToCheck = _G.Config.MinDamage or 0
    if _G.Config.MinDamageOverrideActive and _G.Config.MinDamageOverride then
        minDmgToCheck = _G.Config.MinDamageOverride
    end
    
    if stats.Success and (minDmgToCheck > 0) then
        local baseDmg = 30
        if CurrentWeaponData and CurrentWeaponData.Damage then
            baseDmg = CurrentWeaponData.Damage
        elseif CurrentWeaponData and CurrentWeaponData.BaseDamage then
            baseDmg = CurrentWeaponData.BaseDamage
        end
        

        local factor = 1 - (stats.TotalThickness / maxPen)
        if factor < 0 then factor = 0 end
        local estDmg = baseDmg * factor
        

        
        if estDmg < minDmgToCheck then
             stats.Success = false
             stats.FailReason = string.format("Min Dmg (%.0f < %d)", estDmg, minDmgToCheck)
        end
    end

    return stats.Success, stats.FailReason, stats.TotalThickness
end
local Drawing = Drawing or require(script.Parent.Drawing) 
if not Drawing and getgenv and getgenv().Drawing then Drawing = getgenv().Drawing end
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Transparency = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Filled = false
fovCircle.Visible = (type(_G.Config.ShowFov) == "boolean" and _G.Config.ShowFov or false)
local spreadCircle = Drawing.new("Circle")
spreadCircle.Thickness = 1.5
spreadCircle.Transparency = 1
spreadCircle.Color = Color3.fromRGB(0, 255, 0)
spreadCircle.Filled = false
spreadCircle.Visible = false
local wbBox = Drawing.new("Square")
wbBox.Visible = false
wbBox.Color = Color3.fromRGB(255, 0, 0)
wbBox.Thickness = 2
wbBox.Filled = true
wbBox.Transparency = 0.5 
wbBox.Size = Vector2.new(20, 20)
local wbText = Drawing.new("Text")
wbText.Visible = false
wbText.Color = Color3.fromRGB(255, 255, 255)
wbText.Size = 18
wbText.Center = true
wbText.Outline = true
local function spawn_tracer_beam(origin, target_pos)
    if not _G.Config.ShowTracers then return end
    local Workspace = game:GetService("Workspace")
    local p0 = Instance.new("Part")
    p0.Size = Vector3.new(0.05, 0.05, 0.05)
    p0.Position = origin
    p0.Anchored = true
    p0.CanCollide = false
    p0.Transparency = 1
    p0.Parent = Workspace
    local p1 = Instance.new("Part")
    p1.Size = Vector3.new(0.05, 0.05, 0.05)
    p1.Position = target_pos
    p1.Anchored = true
    p1.CanCollide = false
    p1.Transparency = 1
    p1.Parent = Workspace
    local a0 = Instance.new("Attachment", p0)
    local a1 = Instance.new("Attachment", p1)
    local beam = Instance.new("Beam")
    beam.Attachment0 = a0
    beam.Attachment1 = a1
    beam.FaceCamera = true
    beam.Width0 = 0.1 
    beam.Width1 = 0.1
    beam.Color = ColorSequence.new(_G.Config.BulletTracerColor or Color3.fromRGB(0, 100, 255))
    beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1) 
    })
    beam.TextureSpeed = 0 
    beam.Parent = Workspace
    task.delay(1, function()
        if p0 then p0:Destroy() end
        if p1 then p1:Destroy() end
        if beam then beam:Destroy() end
    end)
end
local function calculateHitChance(startPos, targetPos, targetCharacter, spreadAmount, raycastParams)
    if spreadAmount <= 0 then return 100 end 
    local hits = 0
    local samples = 20 
    for i = 1, samples do
        local angle = math.random() * math.pi * 2
        local radius = math.random() * spreadAmount * 0.1 
        local offset = Vector3.new(math.cos(angle) * radius, math.sin(angle) * radius, 0)
        local dir = (targetPos - startPos).Unit
        local perturbedDir = (dir + Vector3.new(math.random()-0.5, math.random()-0.5, math.random()-0.5) * (spreadAmount/100)).Unit
        local res = Workspace:Raycast(startPos, perturbedDir * 1000, raycastParams)
        if res and res.Instance:IsDescendantOf(targetCharacter) then
            hits = hits + 1
        end
    end
    return (hits / samples) * 100
end
local function GetScanPoints(part, partName)
    local points = {part.Position}
    if _G.Config.Multipoint then
        local s = _G.Config.MultipointScale or 0.6 
        local cf = part.CFrame
        local size = part.Size * 0.5 * s
        if partName == "Head" then
             table.insert(points, cf * Vector3.new(size.X, 0, 0)) 
             table.insert(points, cf * Vector3.new(-size.X, 0, 0))
        elseif partName == "HumanoidRootPart" or partName == "UpperTorso" then
             table.insert(points, cf * Vector3.new(size.X, 0, 0))
             table.insert(points, cf * Vector3.new(-size.X, 0, 0))
        end
    end
    return points
end
local function spawn_tracer_beam(from, to)
    local dist = (to - from).Magnitude
    local laser = Instance.new("Part")
    laser.Name = "Tracer"
    laser.Anchored = true
    laser.CanCollide = false
    laser.Shape = Enum.PartType.Block
    laser.Size = Vector3.new(0.1, 0.1, dist)
    laser.Color = _G.Config.BulletTracerColor or Color3.fromRGB(255, 255, 255)
    laser.CFrame = CFrame.new(from, to) * CFrame.new(0, 0, -dist / 2)
    laser.Material = Enum.Material.Neon
    laser.Parent = workspace
    local duration = _G.Config.TracerDuration or 1
    game:GetService("Debris"):AddItem(laser, duration)
end
local function isEnemy(p)
     if p == LP or not LP.Character or not p.Character then return false end
    if not _G.Config.UseTeamCheck then return true end 
    local LPTeamFolder = LP.Character.Parent
    local PlayerTeamFolder = p.Character.Parent
    local inSameTeam = false
    if LPTeamFolder and PlayerTeamFolder and LPTeamFolder == PlayerTeamFolder then
        if LPTeamFolder ~= workspace then inSameTeam = true end
    end
    if not inSameTeam and LP.Team and p.Team and LP.Team == p.Team then
         inSameTeam = true
    end
    return not inSameTeam
end
local function UpdateAATarget()
    if not _G.Config.AntiAim then 
        if _G.AA_Target then _G.AA_Target = nil end
        return 
    end
    pcall(function()
        local current = _G.AA_Target
        local bestCandidate = nil
        local bestScore = math.huge 
        local origin = Camera.CFrame.Position
        local lookVec = Camera.CFrame.LookVector
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Parent and p.Character and p.Character.Parent and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if isEnemy(p) then
                    local root = p.Character.HumanoidRootPart
                    local diff = (root.Position - origin)
                    if diff.Magnitude > 0.1 then
                        local dir = diff.Unit
                        local dot = lookVec:Dot(dir)
                        local score = 1 - dot 
                        if score < bestScore then
                            bestScore = score
                            bestCandidate = p
                        end
                    end
                end
            end
        end
        _G.AA_Target = bestCandidate
    end)
end
local function getClosestTarget()
    if not LP.Character then return nil, nil end
    local closestPlayer = nil
    local bestScore = math.huge
    local targetAimPart = nil
    local targetAimPoint = nil
    local mouseLocation = UserInputService:GetMouseLocation()
    local origin = Camera.CFrame.Position
    if _G.Config.ThirdPerson and LP.Character and LP.Character:FindFirstChild("Head") then
        origin = LP.Character.Head.Position
    end
    
    
    local hitParams = RaycastParams.new()
    hitParams.FilterDescendantsInstances = {LP.Character, Camera}
    hitParams.FilterType = Enum.RaycastFilterType.Exclude
    hitParams.CollisionGroup = "Bullet"

    local function checkHitStatus(targetPos, targetHrp)
         local dir = targetPos - origin
         local res = Workspace:Raycast(origin, dir, hitParams)
         if res and res.Instance:IsDescendantOf(targetHrp.Parent) then
             return 2 
         elseif _G.Config.WallBang and (CurrentWeaponData == nil or CurrentWeaponData.CanWallbang ~= false) then
             local weaponPen = (CurrentWeaponData and CurrentWeaponData.Penetration) or 2.5 
             if IsHitPossible(targetHrp.Parent, origin, weaponPen, targetPos) then
                 return 1 
             end
         end
         return 0
    end
    local candidates = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character.PrimaryPart then
            if isEnemy(player) then
                table.insert(candidates, player) 
            end
        end
    end
    if _G.Config.TargetMode == "Highest Damage" then 
        table.sort(candidates, function(a,b) 
            return a.Character.Humanoid.Health < b.Character.Humanoid.Health 
        end)
    elseif _G.Config.TargetMode == "Near Crosshair" and not _G.Config.AllDirections then
        table.sort(candidates, function(a,b) 
            local pA = Camera:WorldToViewportPoint(a.Character.PrimaryPart.Position)
            local pB = Camera:WorldToViewportPoint(b.Character.PrimaryPart.Position)
            local dA = (Vector2.new(pA.X, pA.Y) - mouseLocation).Magnitude
            local dB = (Vector2.new(pB.X, pB.Y) - mouseLocation).Magnitude
            return dA < dB
        end)
    else 
        table.sort(candidates, function(a,b) 
            return (a.Character.PrimaryPart.Position - origin).Magnitude < (b.Character.PrimaryPart.Position - origin).Magnitude 
        end)
    end
    local scanLimit = 6
    if #candidates < scanLimit then scanLimit = #candidates end
    for i = 1, scanLimit do
        local player = candidates[i]
        local char = player.Character
        if not char then continue end
        local potentialParts = _G.Config.AimHitboxes or {"Head"}
        if _G.Config.Multipoint then
            potentialParts = {
                "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart",
                "LeftHand", "RightHand", "LeftLowerLeg", "RightLowerLeg"
            }
        end
        if #potentialParts == 0 then potentialParts = {"Head"} end
        for _, pName in ipairs(potentialParts) do
            local targetPart = char:FindFirstChild(pName)
            if targetPart then
                 local pointsToCheck = GetScanPoints(targetPart, pName)
                 for _, point in ipairs(pointsToCheck) do
                     local dist = (point - origin).Magnitude
                     local screenPoint, onScreen = Camera:WorldToViewportPoint(point)
                     local score = math.huge
                     local isValid = false
                     if _G.Config.AllDirections then
                         local hitType = checkHitStatus(point, targetPart)
                         if hitType > 0 then
                             score = dist 
                             isValid = true
                         end
                     elseif _G.Config.TargetMode == "Near Crosshair" then
                         if onScreen then
                             local screenDist = (Vector2.new(mouseLocation.X, mouseLocation.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                             if screenDist <= _G.Config.FovRadius then
                                 score = screenDist
                                 if checkHitStatus(point, targetPart) > 0 then isValid = true end
                             end
                         end
                     else 
                         if onScreen then
                             local screenDist = (Vector2.new(mouseLocation.X, mouseLocation.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                             if screenDist <= _G.Config.FovRadius then
                                 score = screenDist 
                                 if checkHitStatus(point, targetPart) > 0 then isValid = true end
                             end
                         end
                     end
                     if isValid and score < bestScore then
                         bestScore = score
                         closestPlayer = player
                         targetAimPart = targetPart
                         targetAimPoint = point
                     end
                 end
            end
        end
        if _G.Config.Backtrack and workspace:FindFirstChild("BacktrackChams") then
            local ghostName = "Ghost_" .. player.Name
            local ghost = workspace.BacktrackChams:FindFirstChild(ghostName)
            if ghost then
                 local ghostParams = RaycastParams.new()
                 ghostParams.FilterDescendantsInstances = {LP.Character, Camera, ghost, player.Character}
                 ghostParams.FilterType = Enum.RaycastFilterType.Exclude
                 ghostParams.CollisionGroup = "Bullet"
                 local function checkGhostVis(pt)
                     local dir = pt - origin
                     local res = Workspace:Raycast(origin, dir, ghostParams)
                     return res == nil
                 end
                 for _, pName in ipairs(potentialParts) do
                    local targetPart = ghost:FindFirstChild(pName)
                    if targetPart then
                         local pointsToCheck = GetScanPoints(targetPart, pName)
                         for _, point in ipairs(pointsToCheck) do
                             local screendist_score = math.huge
                             local isValidBT = false
                             local dist = (point - origin).Magnitude
                             local screendist_score = math.huge
                             local isValidBT = false
                             local screenPoint, onScreen = Camera:WorldToViewportPoint(point)
                             if _G.Config.AllDirections then
                                 if checkGhostVis(point) then
                                     screendist_score = dist
                                     isValidBT = true
                                 end
                             elseif _G.Config.TargetMode == "Near Crosshair" then
                                 if onScreen then
                                     local screenDist = (Vector2.new(mouseLocation.X, mouseLocation.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                                     if screenDist <= _G.Config.FovRadius then
                                        screendist_score = screenDist
                                        if checkGhostVis(point) then isValidBT = true end
                                     end
                                 end
                             else 
                                 if onScreen then
                                     local screenDist = (Vector2.new(mouseLocation.X, mouseLocation.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                                     if screenDist <= _G.Config.FovRadius then
                                        screendist_score = screenDist 
                                        if checkGhostVis(point) then isValidBT = true end
                                     end
                                 end
                             end
                             if isValidBT and screendist_score < bestScore then
                                 bestScore = screendist_score
                                 closestPlayer = player
                                 targetAimPart = player.Character:FindFirstChild(pName) or player.Character.PrimaryPart
                                 targetAimPoint = point
                             end
                         end
                    end
                 end
            end
        end
    end
    if targetAimPoint and targetAimPart then
         return closestPlayer, targetAimPart, targetAimPoint
    end
    return nil, nil, nil
end
local function GetWallbangHits(targetPart, startPos, direction)
    local hits = {}
    local world = workspace
    local distToTarget = (targetPart.Position - startPos).Magnitude
    local rayDir = direction * (distToTarget + 5) 
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LP.Character, workspace.CurrentCamera} 
    if workspace:FindFirstChild("BacktrackChams") then
        local t = params.FilterDescendantsInstances
        table.insert(t, workspace.BacktrackChams)
        params.FilterDescendantsInstances = t
    end
    local resultEntry = world:Raycast(startPos, rayDir, params)
    if resultEntry and resultEntry.Instance and resultEntry.Instance:IsDescendantOf(targetPart.Parent) then
        return nil
    end
    if resultEntry then
        table.insert(hits, {
            Instance = resultEntry.Instance,
            Position = resultEntry.Position,
            Normal = resultEntry.Normal,
            Material = resultEntry.Material.Name, 
            Distance = resultEntry.Distance,
            Exit = false
        })
        local backDir = (startPos - targetPart.Position).Unit * distToTarget
        params.FilterDescendantsInstances = {LP.Character, targetPart.Parent, workspace.CurrentCamera} 
        local resultExit = world:Raycast(targetPart.Position, backDir, params)
        if resultExit and resultExit.Instance then
             local distFromTarget = resultExit.Distance
             local totalDist = (startPos - targetPart.Position).Magnitude
             local exitDistFromStart = totalDist - distFromTarget
             table.insert(hits, {
                Instance = resultExit.Instance,
                Position = resultExit.Position,
                Normal = resultExit.Normal,
                Material = resultExit.Material.Name, 
                Distance = exitDistFromStart,
                Exit = true 
            })
        else
            if _G.Config.AutoWallDepth then
                 local depth = _G.Config.WallDepth or 1
                 local fakeExitPos = resultEntry.Position + (direction * depth)
                 table.insert(hits, {
                    Instance = resultEntry.Instance,
                    Position = fakeExitPos,
                    Normal = -resultEntry.Normal,
                    Material = resultEntry.Material.Name, 
                    Distance = resultEntry.Distance + depth,
                    Exit = true
                })
            end
        end
        table.insert(hits, {
            Instance = targetPart,
            Position = targetPart.Position,
            Normal = Vector3.new(0, 1, 0),
            Material = targetPart.Material.Name, 
            Distance = distToTarget,
            Exit = false
        })
        return hits
    end
    return nil
end
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Transparency = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Filled = false
fovCircle.Visible = false
RunService.RenderStepped:Connect(function()
    local mouse_pos = game:GetService("UserInputService"):GetMouseLocation()
    fovCircle.Position = mouse_pos
    fovCircle.Radius = _G.Config.FovRadius or 100
    fovCircle.Visible = _G.Config.ShowFov and (_G.Config.SilentAim or _G.Config.EnableFov)
    fovCircle.Color = _G.Config.FovColor or Color3.fromRGB(255, 255, 255)
end)
local function draw_tracer(origin, target_pos)
    local beam = Instance.new("Beam")
    local att0 = Instance.new("Attachment")
    local att1 = Instance.new("Attachment")
    local part0 = Instance.new("Part", workspace)
    part0.Size = Vector3.new(0.01, 0.01, 0.01)
    part0.Position = origin
    part0.Anchored = true
    part0.Transparency = 1
    part0.CanCollide = false
    local part1 = Instance.new("Part", workspace)
    part1.Size = Vector3.new(0.01, 0.01, 0.01)
    part1.Position = target_pos
    part1.Anchored = true
    part1.Transparency = 1
    part1.CanCollide = false
    att0.Parent = part0
    att1.Parent = part1
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Parent = workspace
    beam.Texture = "http://www.roblox.com/asset/?id=446111271" 
    beam.TextureSpeed = 4
    beam.Width0 = 0.15
    beam.Width1 = 0.15
    beam.LightEmission = 1
    beam.LightInfluence = 0
    beam.Color = ColorSequence.new(Color3.fromRGB(80, 200, 255))
    beam.Transparency = NumberSequence.new(0)
    task.delay(_G.Config.TracerDuration or 1.5, function()
        beam:Destroy()
        part0:Destroy()
        part1:Destroy()
    end)
end
local function draw_impact_box(pos)
    local box = Instance.new("Part")
    box.Size = Vector3.new(0.5, 0.5, 0.5)
    box.Position = pos
    box.Anchored = true
    box.CanCollide = false
    box.Transparency = 0.6
    box.Material = Enum.Material.Neon
    box.Color = Color3.fromRGB(80, 200, 255) 
    box.Shape = Enum.PartType.Block
    box.Parent = workspace
    local sb = Instance.new("SelectionBox")
    sb.Adornee = box
    sb.Color3 = Color3.fromRGB(150, 230, 255)
    sb.LineThickness = 0.05
    sb.Transparency = 0.3
    sb.Parent = box
    task.delay(3, function()
        box:Destroy()
    end)
end
local HitLogSystem = {}
local LogGui = Instance.new("ScreenGui")
LogGui.Name = "BloxStrike_Logs"
LogGui.ResetOnSpawn = false
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
LogGui.Parent = PlayerGui
local LogList = Instance.new("Frame")
LogList.Name = "Container"
LogList.Parent = LogGui
LogList.Size = UDim2.new(0, 400, 0, 300)
LogList.Position = UDim2.new(0.5, -200, 0.5, 60)
LogList.BackgroundTransparency = 1
LogList.BorderSizePixel = 2
LogList.BorderColor3 = Color3.fromRGB(255, 255, 255)
LogList.Active = true 
LogList.Draggable = true 
local LogListCorner = Instance.new("UICorner")
LogListCorner.CornerRadius = UDim.new(0, 8)
LogListCorner.Parent = LogList
local LogListStroke = Instance.new("UIStroke")
LogListStroke.Color = Color3.fromRGB(80, 80, 80)
LogListStroke.Thickness = 1.5
LogListStroke.Transparency = 1
LogListStroke.Parent = LogList
local ActualLogs = Instance.new("Frame")
ActualLogs.Name = "ActualLogs"
ActualLogs.Parent = LogList
ActualLogs.Size = UDim2.new(1, 0, 1, 0)
ActualLogs.BackgroundTransparency = 1
local UIList = Instance.new("UIListLayout")
UIList.Parent = ActualLogs
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 5)
local LogPreviewBar = Instance.new("Frame")
LogPreviewBar.Name = "PreviewBar"
LogPreviewBar.Parent = LogList
LogPreviewBar.AnchorPoint = Vector2.new(0.5, 0)
LogPreviewBar.Position = UDim2.new(0.5, 0, 0, 0)
LogPreviewBar.Size = UDim2.new(0, 280, 0, 24)
LogPreviewBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LogPreviewBar.BackgroundTransparency = 1 
LogPreviewBar.BorderSizePixel = 0
LogPreviewBar.Visible = false
local PreviewCorner = Instance.new("UICorner")
PreviewCorner.CornerRadius = UDim.new(0, 4)
PreviewCorner.Parent = LogPreviewBar
local PreviewStroke = Instance.new("UIStroke")
PreviewStroke.Color = Color3.fromRGB(100, 100, 100)
PreviewStroke.Thickness = 1
PreviewStroke.Transparency = 1 
PreviewStroke.Parent = LogPreviewBar
local PreviewIcon = Instance.new("ImageLabel")
PreviewIcon.Parent = LogPreviewBar
PreviewIcon.BackgroundTransparency = 1
PreviewIcon.Size = UDim2.new(0, 16, 0, 16)
PreviewIcon.Position = UDim2.new(0, 5, 0.5, -8)
PreviewIcon.Image = "rbxassetid://3944680095"
PreviewIcon.ImageColor3 = Color3.fromRGB(255, 100, 100)
PreviewIcon.ImageTransparency = 1 
local PreviewText = Instance.new("TextLabel")
PreviewText.Parent = LogPreviewBar
PreviewText.BackgroundTransparency = 1
PreviewText.Size = UDim2.new(1, -35, 1, 0)
PreviewText.Position = UDim2.new(0, 28, 0, 0)
PreviewText.Font = Enum.Font.GothamMedium
PreviewText.TextSize = 12
PreviewText.Text = "Hit Log Area <font color='#AAAAAA'>[Drag to Move]</font>"
PreviewText.TextColor3 = Color3.fromRGB(255, 255, 255)
PreviewText.TextXAlignment = Enum.TextXAlignment.Left
PreviewText.RichText = true
PreviewText.TextTransparency = 1 
task.spawn(function()
    while true do
        task.wait(0.2)
        if Window then
            local isOpen = (Window.Instance and Window.Instance.Visible) or Window.IsOpen
            if isOpen then
                 LogList.Active = true
                 LogPreviewBar.Visible = true
                 LogPreviewBar.BackgroundTransparency = 0.3
                 PreviewStroke.Transparency = 0
                 PreviewText.TextTransparency = 0
                 PreviewIcon.ImageTransparency = 0
            else
                 LogList.Active = false
                 LogPreviewBar.Visible = false
                 LogPreviewBar.BackgroundTransparency = 1
                 PreviewStroke.Transparency = 1
                 PreviewText.TextTransparency = 1
                 PreviewIcon.ImageTransparency = 1
            end
        end
    end
end)
function HitLogSystem.Add(hitPart, targetName)
    local logData = {}
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 0.3
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.AutomaticSize = Enum.AutomaticSize.X 
    frame.Size = UDim2.new(0, 0, 0, 24) 
    frame.Parent = LogList:FindFirstChild("ActualLogs") or LogList
    local stroke = Instance.new("UIStroke")
    stroke.Parent = frame
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 4)
    local icon = Instance.new("ImageLabel")
    icon.Parent = frame
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 5, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://3944680095" 
    icon.ImageColor3 = Color3.fromRGB(255, 100, 100)
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.AutomaticSize = Enum.AutomaticSize.X 
    label.Size = UDim2.new(0, 0, 1, 0)
    label.Position = UDim2.new(0, 28, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.RichText = true 
    local pad = Instance.new("UIPadding")
    pad.Parent = frame
    pad.PaddingRight = UDim.new(0, 10) 
    label.Text = string.format("Hit <font color='#FF80FF'>%s</font> in the %s <font color='#AAAAAA'>[?]</font>", targetName, hitPart)
    frame.BackgroundTransparency = 1
    label.TextTransparency = 1
    icon.ImageTransparency = 1
    stroke.Transparency = 1
    game:GetService("TweenService"):Create(frame, TweenInfo.new(0.3), {BackgroundTransparency=0.3}):Play()
    game:GetService("TweenService"):Create(stroke, TweenInfo.new(0.3), {Transparency=0}):Play()
    game:GetService("TweenService"):Create(label, TweenInfo.new(0.3), {TextTransparency=0}):Play()
    game:GetService("TweenService"):Create(icon, TweenInfo.new(0.3), {ImageTransparency=0}):Play()
    local handle = {}
    function handle:Update(damage, isHeadshot, remainingHP)
        if not label then return end
        local colorName = "#FF80FF"
        local colorDmg = "#55FF55"
        if isHeadshot then colorDmg = "#FF0000" end 
        local statusText = string.format("<font color='#AAAAAA'>(%d health left)</font>", remainingHP)
        if remainingHP <= 0 then
            statusText = "<font color='#FF5555'>DIE</font>"
        end
        label.Text = string.format("Hit <font color='%s'>%s</font> in the %s for <font color='%s'>%d</font> damage %s", 
            colorName, targetName, hitPart, colorDmg, damage, statusText)
        task.delay(3.5, function()
             if not frame then return end
             game:GetService("TweenService"):Create(frame, TweenInfo.new(0.5), {BackgroundTransparency=1}):Play()
             game:GetService("TweenService"):Create(stroke, TweenInfo.new(0.5), {Transparency=1}):Play()
             game:GetService("TweenService"):Create(label, TweenInfo.new(0.5), {TextTransparency=1}):Play()
             game:GetService("TweenService"):Create(icon, TweenInfo.new(0.5), {ImageTransparency=1}):Play()
             task.wait(0.5)
             if frame then frame:Destroy() end
        end)
    end
    function handle:Destroy()
        if frame then frame:Destroy() end
    end
    return handle 
end

local function SpawnDamageText(pos, damage)
    local dmgVal = math.floor(damage + 0.5)
    if dmgVal < 1 then return end
    
    local p = Instance.new("Part", workspace)
    p.Position = pos
    p.Anchored = true
    p.Transparency = 1
    p.CanCollide = false
    p.Size = Vector3.new(0.1,0.1,0.1)
    p.Name = "DmgPopup"
    game:GetService("Debris"):AddItem(p, 3.5)
    
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 50, 0, 50)
    bb.StudsOffset = Vector3.new(0, 2, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = p
    
    local plg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if plg then bb.Parent = plg end
    
    local txt = Instance.new("TextLabel", bb)
    txt.Text = tostring(dmgVal)
    txt.TextColor3 = Color3.fromRGB(100, 255, 100) 
    txt.TextStrokeTransparency = 0
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.new(1,0,1,0)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 24
    
    
    local ts = game:GetService("TweenService")
    ts:Create(bb, TweenInfo.new(3, Enum.EasingStyle.Exponential), {StudsOffset = Vector3.new(0, 5, 0)}):Play()
    ts:Create(txt, TweenInfo.new(3, Enum.EasingStyle.Exponential), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    
    local alive = true
    task.delay(3, function()
        alive = false
        if bb then bb:Destroy() end
        if p then p:Destroy() end
    end)
    
    return function(newText, newColor)
        if not alive or not txt then return end
        txt.Text = tostring(newText)
        if newColor then txt.TextColor3 = newColor end
        
        
        
        if newText == "MISS" then
             txt.TextColor3 = Color3.fromRGB(255, 50, 50) 
             txt.TextTransparency = 0 
             txt.TextStrokeTransparency = 0
             
             ts:Create(txt, TweenInfo.new(2, Enum.EasingStyle.Exponential), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
        end
    end
end

local function TrackDamage(humanoid, timeout, callback)
    if not humanoid then return end
    local startHp = humanoid.Health
    local character = humanoid.Parent
    local conHealth, conAncestry
    
    local function cleanup()
        if conHealth then conHealth:Disconnect() end
        if conAncestry then conAncestry:Disconnect() end
    end

    conHealth = humanoid.HealthChanged:Connect(function(newHp)
        if newHp < startHp then
            local diff = startHp - newHp
            if diff > 0.1 then
                cleanup()
                callback(diff, newHp)
            end
        end
    end)
    
    
    if character then
        conAncestry = character.AncestryChanged:Connect(function(_, parent)
            if parent == workspace:FindFirstChild("Debris") then
                cleanup()
                callback(100, 0) 
            end
        end)
    end

    task.delay(timeout, function() 
        cleanup()
    end)
end

local success, bullet_module = pcall(function() 
    local mod = require(game.ReplicatedStorage.Components.Weapon.Classes.Bullet)
    print("Bullet Module Keys:")
    for k,v in pairs(mod) do print(k, type(v)) end
    return mod
end)

if success and bullet_module then
    local originalPerformRaycast = bullet_module._performRaycast
    if not originalPerformRaycast then
         warn("bullet_module._performRaycast is nil! Falling back to 'create' checking... (Debug)")
         if bullet_module.performRaycast then 
             originalPerformRaycast = bullet_module.performRaycast 
             bullet_module.performRaycast = nil 
         end
    end
    if originalPerformRaycast then
        bullet_module._performRaycast = function(self, spreadAmount)
            if _G.Config.NoSpread or _G.Config.SilentAim then
                spreadAmount = 0
            end
            local target, targetPart, targetPoint = getClosestTarget()
            local originalCFrame = Camera and Camera.CFrame
            local startPos = Camera and Camera.CFrame.Position
            if _G.Config.SilentAim and target and target.Character and targetPart and startPos then
                 targetPos = targetPoint or targetPart.Position
                 local originalCamCFrame = Camera.CFrame
                 Camera.CFrame = CFrame.new(startPos, targetPos)
                 local direction = (targetPos - startPos).Unit
                 local wbHits = nil
                 if _G.Config.WallBang then
                     wbHits = GetWallbangHits(targetPart, startPos, direction)
                 end
                 if not wbHits then
                     wbHits = {
                        {
                            Instance = targetPart,
                            Position = targetPos,
                            Normal = Vector3.new(0, 1, 0),
                            Material = targetPart.Material.Name,
                            Distance = (targetPos - startPos).Magnitude,
                            Exit = false
                        }
                     }
                 end
                 local fakeResult = {
                     Hits = wbHits,
                     Ray = Ray.new(startPos, direction),
                     Instance = targetPart,
                     Position = targetPos,
                     Material = targetPart.Material, 
                     Normal = Vector3.new(0, 1, 0),
                     Distance = (targetPos - startPos).Magnitude,
                     Direction = direction, 
                     Origin = startPos 
                 }
                 Camera.CFrame = originalCamCFrame
                 if _G.Config.ShowHitLogs then
                     task.spawn(function()
                         local character = targetPart.Parent
                         local humanoid = character:FindFirstChild("Humanoid")
                         if not humanoid or humanoid.Health <= 0 then return end
                         local initialHealth = humanoid.Health
                         local victimName = character.Name
                         local logHandle = nil
                         if HitLogSystem and HitLogSystem.Add then
                             logHandle = HitLogSystem.Add(targetPart.Name, victimName)
                         end
                         local start = tick()
                         local damageDealt = 0
                         local connectionHC, connectionDied
                         local function OnDamage(newHealth)
                             if newHealth < initialHealth then
                                 damageDealt = initialHealth - newHealth
                                 if damageDealt > 0.1 then 
                                      if logHandle then logHandle:Update(math.floor(damageDealt + 0.5), targetPart.Name == "Head", math.floor(newHealth)) end
                                      SpawnHitmarker(targetPart.Position) 
                                      local updater = SpawnDamageText(targetPart.Position, damageDealt)
                                      
                                      
                                      if damageDealt >= 99 then
                                          task.delay(0.05, function()
                                               local victimName = character.Name
                                               local stillAlive = false
                                               
                                               local chars = workspace:FindFirstChild("Characters")
                                               if chars then
                                                   if chars:FindFirstChild("Terrorists") and chars.Terrorists:FindFirstChild(victimName) then stillAlive = true end
                                                   if chars:FindFirstChild("Counter-Terrorists") and chars["Counter-Terrorists"]:FindFirstChild(victimName) then stillAlive = true end
                                               end
                                               
                                               if stillAlive then
                                                   updater("MISS")
                                               end
                                          end)
                                      end
                                      
                                      if connectionHC then connectionHC:Disconnect() connectionHC = nil end
                                      if connectionDied then connectionDied:Disconnect() connectionDied = nil end
                                 end
                             end
                         end
                         connectionHC = humanoid.HealthChanged:Connect(OnDamage)
                         connectionDied = humanoid.Died:Connect(function()
                             OnDamage(0) 
                         end)
                         
                         task.spawn(function()
                             local debr = workspace:FindFirstChild("Debris")
                             if debr and character then
                                 local ancC
                                 ancC = character.AncestryChanged:Connect(function(_, p)
                                     if p == debr then
                                         if ancC then ancC:Disconnect() end
                                         OnDamage(0)
                                     end
                                 end)
                                 task.delay(1.5, function() if ancC then ancC:Disconnect() end end)
                             end
                         end)
                         
                         while tick() - start < 1.2 do
                             if damageDealt > 0 then break end
                             if humanoid then
                                 if not humanoid.Parent then
                                     OnDamage(0)
                                     break
                                 end
                                 if humanoid.Health < initialHealth then
                                     OnDamage(humanoid.Health)
                                     break
                                 elseif humanoid.Health <= 0 then
                                     OnDamage(0)
                                     break
                                 end
                             end
                              task.wait() 
                         end
                         if connectionHC then connectionHC:Disconnect() end
                         if connectionDied then connectionDied:Disconnect() end
                          if damageDealt <= 0.1 then
                              if logHandle then logHandle:Destroy() end
                          end
                     end)
                 end

                 if _G.Config.ShowTracers then 
                     draw_tracer(startPos, targetPos) 
                     if wbHits then
                         for _, hit in ipairs(wbHits) do
                             if hit.Instance and not hit.Instance.Parent:FindFirstChild("Humanoid") then
                                  draw_impact_box(hit.Position)
                             end
                         end
                     end
                 end
                 
                 table.insert(_G.LocalShots, {
                     Position = targetPos,
                     Time = tick()
                 })

                 if _G.Config.EspOnShotChams and target and target.Character then
                      local hl = target.Character:FindFirstChild("BloxStrikeHighlight")
                      if hl then
                          task.spawn(function()
                              local oldColor = hl.FillColor
                              hl.FillColor = Color3.fromRGB(255, 255, 255)
                              hl.FillTransparency = 0.2
                              task.wait(0.1)
                              hl.FillTransparency = 0.5
                              hl.FillColor = oldColor 
                          end)
                      end
                 end
                 if _G.Config.PlayHitSound then playHitSound() end
                 return fakeResult
            end
            
            
            local result = originalPerformRaycast(self, spreadAmount)
            if result and result.Hits then
                 local finalHit = result.Hits[#result.Hits]
                 if finalHit and finalHit.Instance and finalHit.Position then
                      
                      if _G.Config.ShowTracers then
                          draw_tracer(startPos, finalHit.Position)
                      end
                      
                      
                      table.insert(_G.LocalShots, {
                          Position = finalHit.Position,
                          Time = tick()
                      })

                      
                      local character = finalHit.Instance.Parent
                      local humanoid = character:FindFirstChild("Humanoid")
                      if humanoid then
                          if _G.Config.PlayHitSound then playHitSound() end
                          if _G.Config.ShowHitmark then SpawnHitmarker(finalHit.Position) end
                          
                          local logHandle = nil
                          if _G.Config.ShowHitLogs and HitLogSystem and HitLogSystem.Add then
                              
                              if not _G.HitLogDebounce then _G.HitLogDebounce = {} end
                              local last = _G.HitLogDebounce[character.Name] or 0
                              if tick() - last > 0.05 then
                                  _G.HitLogDebounce[character.Name] = tick()
                                  logHandle = HitLogSystem.Add(finalHit.Instance.Name, character.Name)
                              end
                          end
                          
                          TrackDamage(humanoid, 1, function(dmg, newHp)
                               local updater = SpawnDamageText(finalHit.Position, dmg)
                               if logHandle then
                                   logHandle:Update(math.floor(dmg), finalHit.Instance.Name == "Head", math.floor(newHp))
                               end
                               
                               if dmg >= 99 then
                                   task.delay(0.05, function()
                                        local victimName = character.Name
                                        local stillAlive = false
                                        
                                        local chars = workspace:FindFirstChild("Characters")
                                        if chars then
                                            if chars:FindFirstChild("Terrorists") and chars.Terrorists:FindFirstChild(victimName) then stillAlive = true end
                                            if chars:FindFirstChild("Counter-Terrorists") and chars["Counter-Terrorists"]:FindFirstChild(victimName) then stillAlive = true end
                                        end
                                        
                                        if stillAlive then
                                            updater("MISS")
                                        end
                                   end)
                               end
                          end)
                      end
                 end
            end
            return result
        end
    else
         warn("Failed to hook _performRaycast")
    end
else
    warn("Bullet module not found.")
end
local ESP_Table = {}
local function SetAllVisible(data, val)
    if not data then return end
    for k, d in pairs(data) do
        if k == "InventoryPool" then continue end 
        if typeof(d) == "Instance" then
            if d:IsA("BillboardGui") then 
                d.Enabled = val 
            end
        elseif d.Visible ~= nil then 
             pcall(function() d.Visible = val end)
        end
    end
end
local function RemoveEsp(p)
    if ESP_Table[p] then
        for _, d in pairs(ESP_Table[p]) do 
            if typeof(d) == "Instance" then
                d:Destroy()
            elseif d.Remove then
                d:Remove()
            end
        end
        ESP_Table[p] = nil
    end
end
Players.PlayerRemoving:Connect(RemoveEsp)
local function GetMoveDirection()
    local Direction = Vector3.zero
    local LookVector = Camera.CFrame.LookVector
    local RightVector = Camera.CFrame.RightVector
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then Direction += LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then Direction -= LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then Direction -= RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then Direction += RightVector end
    return Vector3.new(Direction.X, 0, Direction.Z).Unit
end
local CurrentWeaponName = nil
local CurrentWeaponData = { CanWallbang = true, MaxPenetration = 4, Penetration = 4 } 
local RS = game:GetService("ReplicatedStorage")
local WeaponDB = RS:WaitForChild("Database"):WaitForChild("Custom"):WaitForChild("Weapons")
local IconCache = {}
local LoadingCache = {}
local function GetWeaponIcon(wName)
    if not wName then return nil end
    if IconCache[wName] then return IconCache[wName] end
    if LoadingCache[wName] then return nil end 
    local mod = WeaponDB:FindFirstChild(wName)
    if mod then
        LoadingCache[wName] = true
        task.spawn(function()
            local success, res = pcall(require, mod)
            if success and type(res) == "table" and res.Icon then
                 IconCache[wName] = res.Icon
            end
            LoadingCache[wName] = nil
        end)
    end
    return nil
end
local IsShifting = false
local LastShiftTime = 0
local LastFireTime = 0
RunService.RenderStepped:Connect(function()
    if not _G.LoadStage or _G.LoadStage < 2 then return end
    pcall(function() 
    UpdateAATarget()
    
    
    if _G.Config.SilentAim then
        local t = getClosestTarget()
        _G.SilentTarget = t
    else
        _G.SilentTarget = nil
    end 
    if _G.Config.NoFlash then
        local gui = LP.PlayerGui:FindFirstChild("FlashbangEffect")
        if gui then gui:Destroy() end
        local lightingEffect = game:GetService("Lighting"):FindFirstChild("FlashbangColorCorrection")
        if lightingEffect then lightingEffect:Destroy() end
    end
    Camera = workspace.CurrentCamera 
    if not Camera then return end
    if not LP.Character or not LP.Character.Parent then 
        return 
    end
    local frame = (getgenv and getgenv().FrameCount or 0) + 1
    if getgenv then getgenv().FrameCount = frame end
    if frame % 10 == 0 then
        UpdateLighting() 
        if _G.Config.WorldSkyboxEnabled then
             local L = game:GetService("Lighting")
             local mySky = L:FindFirstChild("BloxStrike_Sky")
             if not mySky then
                 UpdateSkybox(_G.Config.WorldSkybox)
             end
        end
    end
    local mouse_pos = UserInputService:GetMouseLocation()
    fovCircle.Position = mouse_pos
    fovCircle.Radius = _G.Config.FovRadius
    fovCircle.Visible = _G.Config.ShowFov and _G.Config.SilentAim
    if _G.Config.EnableFov then
        Camera.FieldOfView = _G.Config.CustomFov
    end
    local foundModel = nil
    if CurrentWeaponName and Camera:FindFirstChild(CurrentWeaponName) then
         foundModel = Camera[CurrentWeaponName]
    else
         if frame % 30 == 0 then
             for _, child in ipairs(Camera:GetChildren()) do
                  if child:IsA("Model") and WeaponDB:FindFirstChild(child.Name) then
                       foundModel = child
                       break
                  end
             end
         end
    end
    if foundModel then
         if CurrentWeaponName ~= foundModel.Name then
              CurrentWeaponName = foundModel.Name
              local wModule = WeaponDB:FindFirstChild(CurrentWeaponName)
              local wData = nil
              if wModule then
                  local s, r = pcall(require, wModule)
                  if s and r then wData = r end
              end
              CurrentWeaponData.CanWallbang = true
              CurrentWeaponData.Penetration = 0 
              CurrentWeaponData.DamagePerPart = nil 
              if wData then
                   if wData.WallbangMultiplier and wData.WallbangMultiplier <= 0 then
                        CurrentWeaponData.CanWallbang = false
                   end
                   if wData.Penetration then
                      CurrentWeaponData.Penetration = wData.Penetration
                   end
                   if wData.DamagePerPart then
                      CurrentWeaponData.DamagePerPart = wData.DamagePerPart
                   end
                   if wData.Spread then
                      CurrentWeaponData.Spread = wData.Spread
                   end
              end
         end
    else
         CurrentWeaponName = nil
    end 
    
    local scopeInc = LP:GetAttribute("ScopeIncrement") or 0
    local isScoped = scopeInc > 0
    if isScoped then
        if _G.Config.NoScopeOverlay then
            local mainGui = LP.PlayerGui:FindFirstChild("MainGui")
            if mainGui then
                local scopeUI = mainGui:FindFirstChild("Gameplay") and mainGui.Gameplay:FindFirstChild("Scope")
                if scopeUI then scopeUI.Visible = false end
            end
        end
        if _G.Config.CustomScopeFov then
            Camera.FieldOfView = _G.Config.ScopeFovValue
        end
    end
    if _G.Config.ShowSpread and CurrentWeaponName and CurrentWeaponData and CurrentWeaponData.Spread then
        local spreadData = CurrentWeaponData.Spread
        local charSpeed = 0
        if LP.Character and LP.Character.PrimaryPart then
            charSpeed = Vector3.new(LP.Character.PrimaryPart.AssemblyLinearVelocity.X, 0, LP.Character.PrimaryPart.AssemblyLinearVelocity.Z).Magnitude
        end
        local moveMult = spreadData.MovementMultiplier or 1
        local baseSpread = spreadData.Range and spreadData.Range.Min or 0
        local spreadVal = baseSpread + (charSpeed * moveMult)
        local currentFov = Camera.FieldOfView
        local viewportSize = Camera.ViewportSize
        local radSpread = math.rad(spreadVal / 2) 
        local radFov = math.rad(currentFov / 2)
        local pixelRadius = math.tan(radSpread) * (viewportSize.Y / 2) / math.tan(radFov) * 2 
        spreadCircle.Visible = true
        spreadCircle.Position = mouse_pos
        spreadCircle.Radius = math.max(pixelRadius, 2)
        spreadCircle.Color = _G.Config.SpreadColor
    else
        spreadCircle.Visible = false
    end
local function GetTriggerbotTarget()
    local mouseLoc = UserInputService:GetMouseLocation()
    local ray = Camera:ViewportPointToRay(mouseLoc.X, mouseLoc.Y)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LP.Character, Camera, workspace.CurrentCamera}
    if workspace:FindFirstChild("BacktrackChams") then
        local t = params.FilterDescendantsInstances
        table.insert(t, workspace.BacktrackChams)
        params.FilterDescendantsInstances = t
    end
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    
    local res = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
    
    
    if res and res.Instance then
         local hitInstance = res.Instance
         for _, p in pairs(Players:GetPlayers()) do
             if p ~= LP and isEnemy(p) and p.Character and hitInstance:IsDescendantOf(p.Character) then
                 local hum = p.Character:FindFirstChild("Humanoid")
                 if hum and hum.Health > 0 then
                     return p
                 end
             end
         end
    end
    
    
    if _G.Config.LegitAutoWallbang then
         
         for _, p in pairs(Players:GetPlayers()) do
             if p ~= LP and isEnemy(p) and p.Character then
                  local hum = p.Character:FindFirstChild("Humanoid")
                  local root = p.Character:FindFirstChild("HumanoidRootPart")
                  local head = p.Character:FindFirstChild("Head")
                  
                  if hum and hum.Health > 0 and root and head then
                      
                      
                      
                      local bones = {head, root, p.Character:FindFirstChild("UpperTorso")}
                      local isAiming = false
                      local targetPos = nil
                      
                      for _, bone in ipairs(bones) do
                           if not bone then continue end
                           local sPos, visible = Camera:WorldToViewportPoint(bone.Position)
                           
                           if sPos.Z > 0 then
                               local dist = (Vector2.new(sPos.X, sPos.Y) - mouseLoc).Magnitude
                               
                               if dist < (_G.Config.TriggerbotRadius or 10) then 
                                   isAiming = true
                                   targetPos = bone.Position
                                   break
                               end
                           end
                      end
                      
                      if isAiming then
                           
                           local weaponPen = 2.5
                           if CurrentWeaponData and CurrentWeaponData.Penetration then
                               weaponPen = CurrentWeaponData.Penetration
                           end
                           
                           if IsHitPossible and IsHitPossible(p.Character, ray.Origin, weaponPen, targetPos) then
                                return p
                           end
                      end
                  end
             end
         end
    end
    
    return nil
end

    if _G.Config.AutoFire then
        local holdingGrenade = false
        local cam = workspace.CurrentCamera
        if cam then
             for _, child in ipairs(cam:GetChildren()) do
                 local name = child.Name:lower()
                 if name:find("grenade") or name:find("flash") or name:find("molotov") or name:find("decoy") or name:find("smoke") then
                     holdingGrenade = true
                     break
                 end
             end
        end
        if not holdingGrenade and LP.Character then
             local tool = LP.Character:FindFirstChildWhichIsA("Tool")
             if tool then
                 local name = tool.Name:lower()
                 if name:find("grenade") or name:find("flash") or name:find("molotov") or name:find("decoy") or name:find("smoke") then
                     holdingGrenade = true
                 end
             end
             local heldItem = LP.Character:FindFirstChild("HE Grenade") or LP.Character:FindFirstChild("Flashbang") or LP.Character:FindFirstChild("Smoke Grenade") or LP.Character:FindFirstChild("Molotov") or LP.Character:FindFirstChild("Decoy Grenade")
             if heldItem then holdingGrenade = true end
        end
         local target = nil
         if not holdingGrenade then
             
             if _G.Config.SilentAim and _G.SilentTarget then
                 target = _G.SilentTarget
             else
                 
                 target = GetTriggerbotTarget()
             end
         end
         if _G.Config.DebugMode then
             print("[AutoFire Debug] HoldingGrenade:", holdingGrenade, " Target:", target)
         end
         if target and target.Character then
               if Window and Window.IsOpen then return end
               
               local canShoot = true

               
               if _G.Config.LegitAutoStop and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                   local rp = LP.Character.HumanoidRootPart
                   local vel = rp.AssemblyLinearVelocity
                   local planeVel = Vector3.new(vel.X, 0, vel.Z)
                   
                   
                   
                   rp.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
                   local hum = LP.Character:FindFirstChild("Humanoid")
                   if hum then 
                       hum:Move(Vector3.new(0,0,0), true) 
                   end
                   
                   
                   
                   if planeVel.Magnitude > 0.5 then
                       canShoot = false 
                   end
               end

               
               if _G.Config.LegitAutoScope and CurrentWeaponName then
                    local isScoped = (LP:GetAttribute("ScopeIncrement") or 0) > 0
                    if not isScoped then
                         if not _G.LegitScoping then
                             if typeof(mouse2press) == "function" then
                                 mouse2press()
                             else
                                 local vim = game:GetService("VirtualInputManager")
                                 vim:SendMouseButtonEvent(0, 0, 1, true, game, 1) 
                             end
                             _G.LegitScoping = true
                             _G.LegitScopeTime = tick()
                             _G.LegitScopeDelay = math.random(150, 300) / 1000 
                         end
                         canShoot = false 
                    else
                         
                         
                         if _G.LegitScoping and _G.LegitScopeTime and (tick() - _G.LegitScopeTime < (_G.LegitScopeDelay or 0.2)) then
                              canShoot = false 
                         end
                    end
               end

               
               if _G.Config.DebugMode then
                    
               end

               
               if canShoot then
                   local fired = false
                   local now = tick()
                   if now - (LastFireTime or 0) > 0.05 then
                       fired = true
                       LastFireTime = now
                       
                       
                       if _G.Config.IsPeeking then
                           _G.Config.AutoPeekReturning = true
                       end
                       
                       if typeof(mouse1click) == "function" then mouse1click() 
                       else
                           local vim = game:GetService("VirtualInputManager")
                           vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                           vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                       end
                       
                       
                       if _G.Config.LegitAutoScope and _G.LegitScoping then
                           task.delay(math.random(200, 400) / 1000, function() 
                               if typeof(mouse2release) == "function" then
                                   mouse2release()
                               else
                                   local vim = game:GetService("VirtualInputManager")
                                   vim:SendMouseButtonEvent(0, 0, 1, false, game, 1)
                               end
                               _G.LegitScoping = false
                           end)
                       end
                   end
               end
         else
               
               if _G.LegitScoping then
                    if typeof(mouse2release) == "function" then
                        mouse2release()
                    else
                        local vim = game:GetService("VirtualInputManager")
                        vim:SendMouseButtonEvent(0, 0, 1, false, game, 1) 
                    end
                    _G.LegitScoping = false
                    _G.LegitScopeTime = nil
               end
         end 
     end 
    if _G.Config.ShowWallbangIndicator then
        local camCFrame = Camera.CFrame
        local origin = camCFrame.Position
        local direction = camCFrame.LookVector * 1000 
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LP.Character, Camera}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.IgnoreWater = true
        local hit = Workspace:Raycast(origin, direction, rayParams)
        local isPenetrable = false
        local showIndicator = false
        if hit then
            if CurrentWeaponData.CanWallbang then
                 local penRemaining = (CurrentWeaponData.Penetration or 0)
                 local stats = GetPenetrationStats(origin, direction, penRemaining, {LP.Character, Camera}, nil)
                 if stats.Success then
                     isPenetrable = true
                 else
                     isPenetrable = false
                     if stats.MaterialStats and stats.MaterialStats.Limit then
                         local limit = stats.MaterialStats.Limit
                         local used = stats.MaterialStats.Thickness
                         debugText = string.format("Blocked | %s: %.2f / %.2f", stats.MaterialStats.Name, used, limit)
                     else
                         debugText = "Blocked | " .. (stats.FailReason or "Unknown")
                     end
                 end
            end
            showIndicator = true
        end
        if showIndicator then
            local screenPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            wbBox.Visible = true
            wbBox.Position = screenPos - (wbBox.Size / 2)
            wbText.Visible = true
            wbText.Position = screenPos + Vector2.new(0, 15)
            if isPenetrable then
                wbBox.Color = Color3.fromRGB(0, 255, 0) 
                local mat = hit.Instance.Material
                local matName = mat.Name
                local variant = hit.Instance.MaterialVariant
                local limit = MaterialLimits[mat] or 0.25
                if variant and variant ~= "" and MaterialVariantLimits[variant] then
                    matName = variant
                    limit = MaterialVariantLimits[variant]
                end
                wbText.Text = string.format("%s | %.2f", tostring(matName), limit)
                wbText.Color = Color3.fromRGB(0, 255, 0)
            else
                wbBox.Color = Color3.fromRGB(255, 0, 0) 
                wbText.Text = debugText or "Blocked"
                wbText.Color = Color3.fromRGB(255, 255, 0) 
            end
        else
            wbBox.Visible = false
            wbText.Visible = false
        end
    else
         wbBox.Visible = false
         wbText.Visible = false
    end
    end) 
end)
RunService.RenderStepped:Connect(function()
    if not _G.LoadStage or _G.LoadStage < 1 then return end
    pcall(function() 
    if not Camera then Camera = workspace.CurrentCamera end
    if not Camera then return end
    if _G.Config.EnableFov then
        Camera.FieldOfView = _G.Config.CustomFov
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p == LP then continue end
        local data = ESP_Table[p]
        local character = p.Character
        if not character or not character.Parent then
            if data then RemoveEsp(p) end
            continue
        end
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")
        local isValid = (root and humanoid and head and humanoid.Health > 0)
        if not isValid or not _G.Config.Esp then
            if data then SetAllVisible(data, false) end
            if not isValid and data then RemoveEsp(p) end 
            continue
        end
        local is_enemy = isEnemy(p)
        local shouldDraw = false
        if _G.Config.EspTeamMode == "All" then shouldDraw = true
        elseif _G.Config.EspTeamMode == "Enemies" and is_enemy then shouldDraw = true
        elseif _G.Config.EspTeamMode == "Teammates" and not is_enemy then shouldDraw = true
        end
        if not shouldDraw then
            if data then SetAllVisible(data, false) end
            continue
        end
        if not data then
            ESP_Table[p] = {
                BoxOutline = Drawing.new("Square"),
                Box = Drawing.new("Square"),
                Name = Drawing.new("Text"),
                HealthBarOutline = Drawing.new("Square"),
                HealthBar = Drawing.new("Square"),
                DistanceText = Drawing.new("Text"),
                Tracer = Drawing.new("Line"),
                HeadDot = Drawing.new("Circle"),
                Weapon = Drawing.new("Text") 
            }
            data = ESP_Table[p]
            data.BoxOutline.Visible = false
            data.BoxOutline.Color = Color3.new(0,0,0)
            data.BoxOutline.Thickness = 3
            data.BoxOutline.Filled = false
            data.HealthBarOutline.Visible = false
            data.HealthBarOutline.Color = Color3.new(0,0,0)
            data.HealthBarOutline.Filled = true
            local bb = Instance.new("BillboardGui")
            bb.Name = "EspIcon"
            bb.Size = UDim2.new(0, 40, 0, 40) 
            bb.StudsOffset = Vector3.new(0, 5, 0)
            bb.AlwaysOnTop = true
            bb.Enabled = false
            if LP.PlayerGui then bb.Parent = LP.PlayerGui end
            local img = Instance.new("ImageLabel", bb)
            img.BackgroundTransparency = 1
            img.Size = UDim2.new(1,0,1,0)
            img.Image = ""
            img.ScaleType = Enum.ScaleType.Fit 
            data.IconBillboard = bb
            data.IconImage = img
            local invBB = Instance.new("BillboardGui")
            invBB.Name = "EspInventory"
            invBB.Size = UDim2.new(0, 200, 0, 34) 
            invBB.StudsOffset = Vector3.new(0, 3.0, 0) 
            invBB.AlwaysOnTop = true
            invBB.Enabled = false
            if LP.PlayerGui then invBB.Parent = LP.PlayerGui end
            local invFrame = Instance.new("Frame", invBB)
            invFrame.Size = UDim2.new(1, 0, 1, 0)
            invFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            invFrame.BackgroundTransparency = 0.5
            invFrame.BorderSizePixel = 0
            local invList = Instance.new("UIListLayout", invFrame)
            invList.FillDirection = Enum.FillDirection.Horizontal
            invList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            invList.SortOrder = Enum.SortOrder.LayoutOrder
            invList.Padding = UDim.new(0, 2)
            data.InventoryBillboard = invBB
            data.InventoryFrame = invFrame 
            data.InventoryPool = {} 
        end
        local pos, vis = Camera:WorldToViewportPoint(root.Position)
        if vis then
            local sX = Camera.ViewportSize.X
            local sY = Camera.ViewportSize.Y
            if pos.X < 0 or pos.X > sX or pos.Y < 0 or pos.Y > sY then
                vis = false
            end
        end
        if not vis then
             SetAllVisible(data, false)
             continue
        end
        local espColor = is_enemy and _G.Config.EnemyColor or _G.Config.TeammateColor
        if not espColor then espColor = Color3.new(1,1,1) end
        local currentFov = Camera.FieldOfView
        local fovScale = 70 / currentFov
        local size = math.max((2000 * fovScale) / math.max(pos.Z, 1), 10)
        data.BoxOutline.Visible = _G.Config.EspBoxes
        data.BoxOutline.Size = Vector2.new(size, size * 1.5)
        data.BoxOutline.Position = Vector2.new(pos.X - size/2, pos.Y - (size*1.5)/2)
        data.Box.Visible = _G.Config.EspBoxes
        data.Box.Size = Vector2.new(size, size * 1.5)
        data.Box.Position = Vector2.new(pos.X - size/2, pos.Y - (size*1.5)/2)
        data.Box.Color = _G.Config.BoxColor
        data.Box.Thickness = 1
        data.Box.Filled = false
        data.Name.Visible = _G.Config.EspNames
        data.Name.Text = p.Name
        data.Name.Size = 14
        data.Name.Center = true
        data.Name.Outline = true
        data.Name.Font = 2 
        data.Name.Color = _G.Config.NameColor
        data.Name.Position = Vector2.new(pos.X, pos.Y - (size*1.5)/2 - 16)
        if _G.Config.EspHealthBar then
            local healthPer = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            data.HealthBarOutline.Visible = true
            data.HealthBarOutline.Size = Vector2.new(4, size * 1.5 + 2)
            data.HealthBarOutline.Position = Vector2.new(pos.X - size/2 - 7, pos.Y - (size*1.5)/2 - 1)
            data.HealthBar.Visible = true
            data.HealthBar.Size = Vector2.new(2, size * 1.5 * healthPer)
            data.HealthBar.Position = Vector2.new(pos.X - size/2 - 6, pos.Y - (size*1.5)/2 + (size * 1.5 * (1 - healthPer))) 
            data.HealthBar.Color = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), healthPer)
            data.HealthBar.Filled = true
        else
            data.HealthBar.Visible = false
            data.HealthBarOutline.Visible = false
        end
        if _G.Config.EspDistance then
            data.DistanceText.Visible = true
            data.DistanceText.Text = math.floor((Camera.CFrame.Position - root.Position).Magnitude) .. "m"
            data.DistanceText.Size = 12
            data.DistanceText.Center = true
            data.DistanceText.Outline = true
            data.DistanceText.Font = 2
            data.DistanceText.Color = _G.Config.DistColor
            data.DistanceText.Position = Vector2.new(pos.X, pos.Y + (size*1.5)/2 + 5)
        else
             data.DistanceText.Visible = false
        end
        if _G.Config.EspTracers then
            data.Tracer.Visible = true
            data.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            data.Tracer.To = Vector2.new(pos.X, pos.Y)
            data.Tracer.Color = _G.Config.TracerColor
            data.Tracer.Thickness = 1
        else
             data.Tracer.Visible = false
        end
        if _G.Config.EspHeadDot and head then
             local hPos, hVis = Camera:WorldToViewportPoint(head.Position)
             if hVis then
                data.HeadDot.Visible = true
                data.HeadDot.Position = Vector2.new(hPos.X, hPos.Y)
                data.HeadDot.Radius = 3
                data.HeadDot.Color = _G.Config.HeadDotColor
                data.HeadDot.Filled = true
             else
                data.HeadDot.Visible = false
             end
        else
            data.HeadDot.Visible = false
        end
        local HttpService = game:GetService("HttpService")
        if _G.Config.EspWeapon then
            local weaponName = "None"
            local attr = p:GetAttribute("CurrentEquipped")
            
            
            if data.LastWeaponAttr ~= attr then
                data.LastWeaponAttr = attr
                if attr then
                    local s, decoded = pcall(function() return HttpService:JSONDecode(attr) end)
                    if s and decoded and decoded.Name then
                        data.LastWeaponName = decoded.Name
                    else
                        data.LastWeaponName = "None"
                    end
                else
                    data.LastWeaponName = "None"
                end
            end
            weaponName = data.LastWeaponName or "None"
            if data.IconBillboard then data.IconBillboard.Enabled = false end
            data.Weapon.Visible = true
            data.Weapon.Text = weaponName or "None"
            data.Weapon.Size = 13
            data.Weapon.Center = false 
            data.Weapon.Outline = true
            data.Weapon.Font = 2
            data.Weapon.Position = Vector2.new(pos.X + size/2 + 4, pos.Y - size/2) 
            data.Weapon.Color = _G.Config.WeaponColor
        else
            if data.IconBillboard then data.IconBillboard.Enabled = false end
            data.Weapon.Visible = false
        end
        if _G.Config.EspInventory and data.InventoryBillboard then
            local folderName = p.Name .. "_WeaponAttachments"
            local folder = workspace.Debris:FindFirstChild(folderName)
            local items = folder and folder:GetChildren() or {}
            local shownCount = 0
            for i, item in ipairs(items) do
                local icon = GetWeaponIcon(item.Name)
                if icon then
                    shownCount += 1
                    local lbl = data.InventoryPool[shownCount]
                    if not lbl then
                        local parent = data.InventoryFrame or data.InventoryBillboard
                        lbl = Instance.new("ImageLabel", parent)
                        lbl.BackgroundTransparency = 1
                        lbl.Size = UDim2.new(0, 30, 0, 30) 
                        lbl.ScaleType = Enum.ScaleType.Fit
                        data.InventoryPool[shownCount] = lbl
                    end
                    if data.InventoryFrame and lbl.Parent ~= data.InventoryFrame then
                        lbl.Parent = data.InventoryFrame
                    end
                    lbl.Image = icon
                    lbl.Visible = true
                    lbl.LayoutOrder = i
                end
            end
            for i = shownCount + 1, #data.InventoryPool do
                data.InventoryPool[i].Visible = false
            end
            if shownCount > 0 then
                data.InventoryBillboard.Adornee = head
                data.InventoryBillboard.Enabled = true
                data.InventoryBillboard.Size = UDim2.new(0, shownCount * 32 + 4, 0, 34)
            else
                data.InventoryBillboard.Enabled = false
            end
        elseif data.InventoryBillboard then
            data.InventoryBillboard.Enabled = false
        end
    end
    end) 
end)
RunService.Heartbeat:Connect(function()
    local Character = LP.Character
    if not Character then return end
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not RootPart or not Humanoid then return end
    if _G.Config.Bhop then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            local RayParams = RaycastParams.new()
            RayParams.FilterDescendantsInstances = {Character}
            RayParams.FilterType = Enum.RaycastFilterType.Exclude
            local GroundCheck = Workspace:Raycast(RootPart.Position, Vector3.new(0, -4, 0), RayParams)
            if GroundCheck then
                Humanoid.Jump = true
            end
        end
        local Direction = Vector3.zero
        local Success, Result = pcall(function() return GetMoveDirection() end)
        if Success and Result.Magnitude > 0 then
            Direction = Result * _G.Config.BhopSpeed
            local Velocity = RootPart.AssemblyLinearVelocity
            local NewX = Velocity.X + (Direction.X - Velocity.X) * 0.2
            local NewZ = Velocity.Z + (Direction.Z - Velocity.Z) * 0.2
            RootPart.AssemblyLinearVelocity = Vector3.new(NewX, Velocity.Y, NewZ)
        end
    end
    if _G.Config.AutoStop and not _G.Config.AutoPeekReturning then
        local Success, Result = pcall(function() return GetMoveDirection() end)
        local Options = _G.Config.QuickStopOptions or {}
        local function HasOpt(name) 
            for _,v in pairs(Options) do if v == name then return true end end
            return false
        end
        local isMoving = Success and Result.Magnitude > 0
        local isShooting = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) 
        local shouldStop = false
        if Success and Result.Magnitude == 0 then
             shouldStop = true
        end
        if isShooting then
             shouldStop = true
        end
        local isGrounded = (Humanoid.FloorMaterial ~= Enum.Material.Air)
        local canStop = isGrounded or HasOpt("In Air")
        if HasOpt("Move Between Shots") and not isShooting and isMoving then
             shouldStop = false
             if Result.Magnitude == 0 then shouldStop = true end
        end
        if shouldStop and canStop then
            local Velocity = RootPart.AssemblyLinearVelocity
            local HorizontalVel = Vector3.new(Velocity.X, 0, Velocity.Z)
            if HorizontalVel.Magnitude > 0.1 then
                 RootPart.AssemblyLinearVelocity = Vector3.new(0, Velocity.Y, 0)
                 Humanoid:MoveTo(RootPart.Position)
                 if HasOpt("Duck") and not _G.Config.FakeDuck then
                 end
            end
        end
    end
end)
task.spawn(function()
    local PeekPart = Instance.new("Part")
    PeekPart.Name = "AutoPeekVisual"
    PeekPart.Shape = Enum.PartType.Cylinder
    PeekPart.Material = Enum.Material.Neon
    PeekPart.Color = Color3.fromRGB(0, 255, 0) 
    PeekPart.Transparency = 0.6
    PeekPart.Anchored = true
    PeekPart.CanCollide = false
    PeekPart.Size = Vector3.new(0.2, 3, 3) 
    PeekPart.Parent = nil 
    local PeekOrigin = nil
    _G.Config.IsPeeking = false
    _G.Config.AutoPeekReturning = false
    local IsPeeking = false
    local IsReturning = false
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not _G.Config.AutoPeek then return end
        local isPeekKey = false
        if _G.Config.AutoPeekKey then
            if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode == _G.Config.AutoPeekKey then
                isPeekKey = true
            elseif input.UserInputType == _G.Config.AutoPeekKey then
                isPeekKey = true
            end
        end
        if gpe and not isPeekKey then return end
        if isPeekKey then
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                PeekOrigin = LP.Character.HumanoidRootPart.Position
                IsPeeking = true
                _G.Config.IsPeeking = true
                IsReturning = false
                _G.Config.AutoPeekReturning = false
                PeekPart.Parent = Workspace
                PeekPart.CanCollide = false
                PeekPart.CanTouch = false
                PeekPart.CanQuery = false
                PeekPart.Massless = true
                PeekPart.Position = PeekOrigin - Vector3.new(0, 2, 0)
                PeekPart.CFrame = CFrame.new(PeekOrigin - Vector3.new(0, 2.8, 0)) * CFrame.Angles(0, 0, math.rad(90))
            end
        end
        if IsPeeking and input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsReturning = true
            _G.Config.AutoPeekReturning = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input, gpe)
        local isPeekKey = false
        if _G.Config.AutoPeekKey then
            if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode == _G.Config.AutoPeekKey then
                isPeekKey = true
            elseif input.UserInputType == _G.Config.AutoPeekKey then
                isPeekKey = true
            end
        end
        if isPeekKey then
            IsPeeking = false
            _G.Config.IsPeeking = false
            IsReturning = false
            _G.Config.AutoPeekReturning = false
            if PeekPart then PeekPart.Parent = nil end
            PeekOrigin = nil
        end
    end)
    game:GetService("RunService").RenderStepped:Connect(function()
        if not _G.Config.AutoPeek then 
            if PeekPart and PeekPart.Parent then PeekPart.Parent = nil end
            return 
        end
        if _G.Config.AutoPeekReturning then IsReturning = true end
        if IsPeeking and PeekOrigin and PeekPart then
            PeekPart.Parent = Workspace
            PeekPart.CFrame = CFrame.new(PeekOrigin - Vector3.new(0, 2.8, 0)) * CFrame.Angles(0, 0, math.rad(90))
        else
            if PeekPart then PeekPart.Parent = nil end
        end
        if IsReturning and PeekOrigin and LP.Character then
            local Humanoid = LP.Character:FindFirstChild("Humanoid")
            local Root = LP.Character:FindFirstChild("HumanoidRootPart")
            if Humanoid and Root then
                local flatPos = Vector3.new(Root.Position.X, PeekOrigin.Y, Root.Position.Z)
                local dist = (flatPos - PeekOrigin).Magnitude
                if dist < 1.0 then 
                    IsReturning = false
                    _G.Config.AutoPeekReturning = false
                    Humanoid:MoveTo(Root.Position) 
                else
                    Humanoid:MoveTo(PeekOrigin)
                end
            end
        end
    end)
end)
local Ghosts = {} 
local BacktrackHistory = {} 
local BacktrackFolder = workspace.CurrentCamera:FindFirstChild("BacktrackChams") or Instance.new("Folder", workspace.CurrentCamera)
BacktrackFolder.Name = "BacktrackChams"
Players.PlayerRemoving:Connect(function(player)
    BacktrackHistory[player] = nil
    if Ghosts[player] then
        Ghosts[player]:Destroy()
        Ghosts[player] = nil
    end
end)
RunService.RenderStepped:Connect(function()
    if not _G.Config.BacktrackChams then 
        BacktrackFolder:ClearAllChildren()
        Ghosts = {}
        BacktrackHistory = {}
        return 
    end
    local now = tick()
    local backtrackTime = _G.Config.BacktrackTime or 0.2 
    for _, p in pairs(Players:GetPlayers()) do
        if (p ~= LP or _G.Config.SelfBacktrack) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local is_enemy = isEnemy(p)
            if p == LP and _G.Config.SelfBacktrack then is_enemy = true end
            if is_enemy then
                local Root = p.Character.HumanoidRootPart
                if not BacktrackHistory[p] then BacktrackHistory[p] = {} end
                if not _G.GhostStates then _G.GhostStates = {} end
                if not _G.GhostStates[p] then _G.GhostStates[p] = {Active=false, StartPos=Root.Position} end
                local history = BacktrackHistory[p]
                if Root.AssemblyLinearVelocity.Magnitude > 500 then
                    BacktrackHistory[p] = {} 
                    history = BacktrackHistory[p]
                    _G.GhostStates[p] = {Active=false, StartPos=Root.Position}
                end
                if #history > 0 then
                    local lastRec = history[#history]
                    local dist = (Root.Position - lastRec.CFrame.Position).Magnitude
                    if dist > 0.1 then 
                        if dist > 25 then 
                            BacktrackHistory[p] = {} 
                            history = BacktrackHistory[p]
                            _G.GhostStates[p] = {Active=false, StartPos=Root.Position}
                        end
                        if not _G.GhostStates[p].Active then
                            if (Root.Position - _G.GhostStates[p].StartPos).Magnitude > 1.0 then 
                                 _G.GhostStates[p].Active = true
                            end
                        end
                        if _G.GhostStates[p].Active then
                            table.insert(history, {Time = now, CFrame = Root.CFrame})
                        end
                    end
                else
                     _G.GhostStates[p] = {Active=false, StartPos=Root.Position}
                     table.insert(history, {Time = now, CFrame = Root.CFrame})
                end
                for i = #history, 1, -1 do
                    if now - history[i].Time > 1.0 then table.remove(history, i) end
                end
                local targetTime = now - backtrackTime
                local finalCFrame = nil
                if #history > 0 then
                    local found = false
                    for i = #history, 2, -1 do
                        local recent = history[i]
                        local older = history[i-1]
                        if targetTime <= recent.Time and targetTime >= older.Time then
                            local alpha = (targetTime - older.Time) / (recent.Time - older.Time)
                            finalCFrame = older.CFrame:Lerp(recent.CFrame, alpha)
                            found = true
                            break
                        end
                    end
                    if not found then finalCFrame = history[1].CFrame end
                end
                if finalCFrame then
                    local ghost = Ghosts[p]
                    if not ghost or not ghost.Parent then
                        p.Character.Archivable = true
                        local rawGhost = p.Character:Clone()
                        if rawGhost then
                            ghost = rawGhost
                            ghost.Name = "Ghost_" .. p.Name
                            Ghosts[p] = ghost
                            for _, item in ipairs(ghost:GetDescendants()) do
                                if item:IsA("LuaSourceContainer") or item:IsA("Script") or item:IsA("Sound") or item:IsA("JointInstance") or item:IsA("BodyMover") or item:IsA("Constraint") then
                                    item:Destroy()
                                end
                            end
                            ghost:BreakJoints() 
                            for _, item in ipairs(ghost:GetDescendants()) do 
                                if item:IsA("BasePart") then
                                    item.Anchored = true       
                                    item.CanCollide = false    
                                    item.CanQuery = false
                                    item.Massless = true       
                                    item.AssemblyLinearVelocity = Vector3.zero 
                                    item.Material = Enum.Material.Neon
                                    item.Transparency = 0.5
                                    item.Color = _G.Config.BacktrackChamsColor or Color3.fromRGB(80, 0, 255)
                                    if item.Name == "HumanoidRootPart" then item.Transparency = 1 end
                                elseif item:IsA("Humanoid") then
                                    item.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                                    item.PlatformStand = true 
                                elseif item:IsA("Decal") then
                                    item:Destroy()
                                end
                            end
                            local hl = Instance.new("Highlight", ghost)
                            hl.Name = "BacktrackHighlight"
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.FillColor = _G.Config.BacktrackChamsColor
                            hl.OutlineColor = Color3.new(1,1,1)
                            hl.FillTransparency = 0.5
                            ghost.Parent = BacktrackFolder
                        end
                    end
                    if ghost and ghost.Parent then
                        ghost:PivotTo(finalCFrame)
                        local baseColor = _G.Config.BacktrackChamsColor or Color3.fromRGB(80, 0, 255)
                        local hl = ghost:FindFirstChild("BacktrackHighlight")
                        if hl then hl.FillColor = baseColor end
                        for _,v in pairs(ghost:GetChildren()) do
                            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Color = baseColor end
                        end
                    end
                end
            else
                if Ghosts[p] then Ghosts[p]:Destroy(); Ghosts[p] = nil end
            end
        else
            if Ghosts[p] then Ghosts[p]:Destroy(); Ghosts[p] = nil end
        end
    end
end)
task.spawn(function()
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    RunService.RenderStepped:Connect(function()
        if not LP or not LP.Character or not LP.Character:FindFirstChild("Humanoid") then return end
        local Humanoid = LP.Character.Humanoid
        local Root = LP.Character:FindFirstChild("HumanoidRootPart")
        if _G.Config.FakeDuck then
            local currentOffset = Humanoid.CameraOffset
            if currentOffset.Y < -0.5 then 
                 Humanoid.CameraOffset = Vector3.new(0, 0, 0) 
            end
        end
    end)
    while true do
        task.wait(0.1) 
        if LP.Character then
             if _G.Config.AutoScope and InventoryController then
                 local weapon = InventoryController.getCurrentEquipped()
                 local isSafeWeapon = weapon and weapon.Properties and 
                                      weapon.Properties.Slot ~= "Grenade" and 
                                      weapon.Properties.Slot ~= "C4" and
                                      weapon.Properties.Slot ~= "Knife"
                 if isSafeWeapon and weapon.Properties.HasScope then
                     local isShooting = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                     if not _G.LastAutoScopeAttempt then _G.LastAutoScopeAttempt = 0 end
                     if isShooting and not weapon.IsScoped then 
                         if tick() - _G.LastAutoScopeAttempt > 0.3 then 
                             _G.LastAutoScopeAttempt = tick()
                             pcall(function() weapon:scope(true) end)
                         end
                     end
                 end
             end
        end
    end
end)
    task.spawn(function()
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local CoreGui = game:GetService("CoreGui")
        local parent = CoreGui
        local success, _ = pcall(function() return CoreGui.Name end)
        if not success then 
            if LocalPlayer.PlayerGui then parent = LocalPlayer.PlayerGui end
        end
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "NoScopeOverlay"
        if parent:FindFirstChild("NoScopeOverlay") then parent.NoScopeOverlay:Destroy() end
        ScreenGui.Parent = parent
        local fakecrosshair = Instance.new("Frame", ScreenGui)
        fakecrosshair.Size = UDim2.new(0, 20, 0, 20)
        fakecrosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        fakecrosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        fakecrosshair.BackgroundTransparency = 1
        fakecrosshair.Visible = false
        local line0 = Instance.new("Frame", fakecrosshair)
        line0.Size = UDim2.new(1, 0, 0, 2)
        line0.Position = UDim2.new(0, 0, 0.5, 0)
        line0.AnchorPoint = Vector2.new(0, 0.5)
        line0.BackgroundColor3 = Color3.fromRGB(255, 0, 0) 
        line0.BorderSizePixel = 0
        local line1 = Instance.new("Frame", fakecrosshair)
        line1.Size = UDim2.new(0, 2, 1, 0)
        line1.Position = UDim2.new(0.5, 0, 0, 0)
        line1.AnchorPoint = Vector2.new(0.5, 0)
        line1.BackgroundColor3 = Color3.fromRGB(255, 0, 0) 
        line1.BorderSizePixel = 0
        
        local CachedSniperScope = nil
        
        RunService.RenderStepped:Connect(function()
            
            if CachedSniperScope and not CachedSniperScope.Parent then
                CachedSniperScope = nil
            end
            
            
            if not CachedSniperScope then
                 local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                 if playerGui then
                     local s, scope = pcall(function() return playerGui.MainGui.Gameplay.Middle.SniperScope end)
                     if s and scope then
                         CachedSniperScope = scope
                     end
                 end
            end

            local scopeFrame = CachedSniperScope

            if not _G.Config.RemoveScope then 
                fakecrosshair.Visible = false
                if scopeFrame then
                     if scopeFrame.Size ~= UDim2.new(1,0,1,0) then
                         scopeFrame.Size = UDim2.new(1,0,1,0)
                     end
                end
                return 
            end
            
            if scopeFrame then
                if scopeFrame.Visible == true then
                    scopeFrame.Size = UDim2.new(0, 0, 0, 0)
                    fakecrosshair.Visible = true
                else
                    fakecrosshair.Visible = false
                    if scopeFrame.Size ~= UDim2.new(1, 0, 1, 0) then
                        scopeFrame.Size = UDim2.new(1, 0, 1, 0)
                    end
                end
            else
                fakecrosshair.Visible = false
            end
        end)
end)
if Library and Library.Notification then
    Library:Notification({
        Title = "BloxStrike",
        Description = "Loaded Successfully",
        Duration = 5,
        Icon = "73789337996373"
    })
end
task.spawn(function()
    local PenText = Drawing.new("Text")
    PenText.Visible = false
    PenText.Center = true
    PenText.Size = 18
    PenText.Font = 2
    PenText.Color = Color3.fromRGB(0, 255, 0)
    PenText.Outline = true
    
    local penParams = RaycastParams.new()
    penParams.FilterType = Enum.RaycastFilterType.Exclude
    penParams.CollisionGroup = "Bullet"

    game:GetService("RunService").RenderStepped:Connect(function()
        local show = _G.Config.ShowPenetration
        local cam = workspace.CurrentCamera
        if show and cam then
            PenText.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2 - 40) 
            
            
            local ignore = {LP.Character, cam, workspace:FindFirstChild("BacktrackChams")}
            penParams.FilterDescendantsInstances = ignore
            
            local res = workspace:Raycast(cam.CFrame.Position, cam.CFrame.LookVector * 1000, penParams)
            if res then
                 local stats = GetPenetrationStats(cam.CFrame.Position, cam.CFrame.LookVector, 4, {LP.Character, cam}, nil)
                 if stats.Success then
                     PenText.Visible = true
                     PenText.Text = string.format("WALLBANG: YES\n(%.1f studs)", stats.TotalThickness or 0)
                     PenText.Color = Color3.fromRGB(0, 255, 0) 
                 else
                     PenText.Visible = true
                     PenText.Text = "WALLBANG: NO"
                     PenText.Color = Color3.fromRGB(255, 0, 0) 
                 end
            else
                 PenText.Visible = false
            end
        else
            PenText.Visible = false
        end
    end)
end)
task.spawn(function()
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    RunService.RenderStepped:Connect(function()
        pcall(function() setfflag("AdornShadingAPI", "true") end)
        
        local configChams = _G.Config.EspChams
        local hiddenColor = _G.Config.ChamHiddenColor or Color3.fromRGB(255, 0, 0)
        
        
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local shouldCham = false
                if configChams and p ~= LP then
                     if isEnemy(p) then shouldCham = true end
                end

                for _, v in pairs(p.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        
                        if v.Name ~= "HumanoidRootPart" then 
                             if v.Transparency >= 1 then v.Transparency = 0 end
                        end
                        
                        
                        local box = v:FindFirstChild("BloxStrikeChamAdorn")
                        if shouldCham and v.Name ~= "HumanoidRootPart" then
                             if not box then
                                  box = Instance.new("BoxHandleAdornment", v)
                                  box.Name = "BloxStrikeChamAdorn"
                                  box.Adornee = v
                                  box.AlwaysOnTop = false 
                                  box.ZIndex = -1 
                                  box.Transparency = -1 
                                  box.Shading = Enum.AdornShading.XRayShaded
                             end
                             if box then
                                  box.Visible = true
                                  box.Size = v.Size + Vector3.new(0.1, 0.1, 0.1)
                                  box.Color3 = hiddenColor
                             end
                        else
                             if box then box:Destroy() end
                        end
                    end
                end
                
                
                local hl = p.Character:FindFirstChild("BloxStrikeChams")
                if hl then hl:Destroy() end
            end
        end
    end)
end)
task.spawn(function()
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")
    local CC = Instance.new("ColorCorrectionEffect")
    CC.Name = "BloxStrikeDark"
    CC.Enabled = false
    CC.Parent = Lighting
    RunService.RenderStepped:Connect(function()
        if _G.Config.DarkMode then
            Lighting.Ambient = Color3.fromRGB(60, 60, 60) 
            Lighting.OutdoorAmbient = Color3.fromRGB(40, 40, 40) 
            Lighting.Brightness = 1.2 
            Lighting.GlobalShadows = true
            Lighting.FogColor = Color3.fromRGB(40, 40, 40)
            CC.Saturation = -0.2 
            CC.Contrast = 0.05 
            CC.Enabled = true
        else
            if CC.Enabled then CC.Enabled = false end
        end
    end)
end)
task.spawn(function()
    local ZoneTrackers = {} 
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local function VisualizeShrapnel(pos, color)
        if not _G.Config.GrenadeTracers then return end
        local lines = {}
        local numLines = 16 
        local length = 12
        local c = color or _G.Config.GrenadeZoneColor or Color3.fromRGB(255, 100, 0)
        for i = 1, numLines do
            local line = Drawing.new("Line")
            line.Visible = true
            line.Color = c
            line.Thickness = 2
            line.Transparency = 1
            local x = math.random() * 2 - 1
            local y = math.random() * 2 - 1
            local z = math.random() * 2 - 1
            local dir = Vector3.new(x, y, z).Unit
            table.insert(lines, {obj = line, dir = dir})
        end
        task.spawn(function()
            local t = 0
            local duration = 0.6
            local startTick = tick()
            local connection
            connection = RunService.RenderStepped:Connect(function()
                pcall(function()
                    t = tick() - startTick
                    if t > duration then
                        connection:Disconnect()
                        for _, item in ipairs(lines) do item.obj:Remove() end
                        return
                    end
                    local alpha = math.clamp(t / duration, 0, 1)
                    local expansion = (1 - (1 - alpha) * (1 - alpha)) * length 
                    if pos.X ~= pos.X then 
                        connection:Disconnect()
                         for _, item in ipairs(lines) do item.obj:Remove() end
                        return
                    end
                    for _, item in ipairs(lines) do
                        local line = item.obj
                        local dir = item.dir
                        local worldStart = pos + (dir * (expansion * 0.2)) 
                        local worldEnd = pos + (dir * expansion)
                        local screenStart, onScreen1 = Camera:WorldToViewportPoint(worldStart)
                        local screenEnd, onScreen2 = Camera:WorldToViewportPoint(worldEnd)
                        if onScreen1 or onScreen2 then
                            line.Visible = true
                            line.From = Vector2.new(screenStart.X, screenStart.Y)
                            line.To = Vector2.new(screenEnd.X, screenEnd.Y)
                            line.Transparency = 1 - alpha 
                        else
                            line.Visible = false
                        end
                    end
                end)
            end)
        end)
    end
    local function HandleObject(obj)
        if not obj or not obj.Parent then return end
        if ZoneTrackers[obj] then return end 
        local name = obj.Name
        local lowName = name:lower()
        local isMolotovZone = (lowName:find("ignite") or lowName:find("fire") or lowName:find("molotov") or lowName:find("voxelfire"))
        local isSmokeZone = (lowName:find("smoke") or lowName:find("voxelsmoke"))
        if isMolotovZone or isSmokeZone then
            if not obj:IsA("BasePart") then
                obj.ChildAdded:Connect(function(c) task.wait(); HandleObject(c) end)
                return 
            end
            local color = Color3.new(1,1,1)
            local show = false
            if isMolotovZone and _G.Config.MolotovZoneESP then 
                color = _G.Config.GrenadeZoneColor or Color3.fromRGB(255, 0, 0)
                show = true
            elseif isSmokeZone and _G.Config.SmokeZoneESP then
                color = _G.Config.SmokeColor or Color3.fromRGB(100, 100, 100)
                show = true
            end
            if show then
                local box = Instance.new("SelectionBox")
                box.Name = "BS_ZoneVisual"
                box.Adornee = obj
                box.Color3 = color
                box.LineThickness = 0.05
                box.Transparency = 0.5
                box.SurfaceTransparency = 1 
                box.Parent = obj
            end
            return
        end
        local isUUID = (#name > 30 and select(2, name:gsub("-", "")) == 4)
        local isGrenadeName = (lowName:find("grenade") or lowName:find("flash") or lowName:find("molotov") or lowName:find("bang")) 
                              and not lowName:find("launch") 
                              and not lowName:find("muzzle") 
                              and not lowName:find("light") 
                              and not lowName:find("effect")
                              and not lowName:find("gun")
                              and not lowName:find("rifle")
                              and not lowName:find("pistol")
                              and not lowName:find("bullet")
                              and not lowName:find("casing")
                              and not lowName:find("debris")
        if isGrenadeName or isUUID then
            local mainPart = obj
            if obj:IsA("Model") then
                mainPart = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart", true)
            end
            
            
            if mainPart and mainPart:IsA("BasePart") then
                 if mainPart.Size.Magnitude < 0.6 then return end
            end
            
            if not mainPart or not mainPart:IsA("BasePart") then 
                task.delay(0.1, function()
                    if obj.Parent then HandleObject(obj) end
                end)
                return 
            end
            ZoneTrackers[obj] = true
            if _G.Config.GrenadeESP then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "BS_GrenadeBox"
                box.Adornee = mainPart
                box.Size = mainPart.Size + Vector3.new(0.5, 0.5, 0.5) 
                box.Color3 = Color3.fromRGB(255, 50, 50) 
                box.Transparency = 0.2
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Parent = mainPart
            end
            if _G.Config.GrenadeTracers then
                task.spawn(function()
                    local follower = Instance.new("Part")
                    follower.Name = "BSTrackerVisual" 
                    follower.Transparency = 1
                    follower.CanCollide = false
                    follower.Anchored = true
                    follower.Size = Vector3.new(0.1, 0.1, 0.1)
                    follower.Position = mainPart.Position
                    follower.Parent = workspace.CurrentCamera 
                    local a0 = Instance.new("Attachment", follower)
                    local a1 = Instance.new("Attachment", follower)
                    a0.Position = Vector3.new(0, 0.1, 0)
                    a1.Position = Vector3.new(0, -0.1, 0)
                    local trail = Instance.new("Trail")
                    trail.Attachment0 = a0
                    trail.Attachment1 = a1
                    trail.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0))
                    trail.Lifetime = 5.5
                    trail.MinLength = 0
                    trail.WidthScale = NumberSequence.new(1, 0) 
                    trail.Parent = follower
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        pcall(function()
                            if mainPart and mainPart.Parent then
                                follower.CFrame = mainPart.CFrame
                            else
                                connection:Disconnect()
                                game:GetService("Debris"):AddItem(follower, 1) 
                                VisualizeShrapnel(follower.Position)
                            end
                        end)
                    end)
                end)
            end
        end
    end
    local function Monitor(parent)
        parent.ChildAdded:Connect(function(child)
            HandleObject(child)
        end)
        for _, v in ipairs(parent:GetChildren()) do
            HandleObject(v)
        end
    end
    Monitor(workspace)
    local debris = workspace:FindFirstChild("Debris")
    if debris then 
        Monitor(debris) 
        debris.AncestryChanged:Connect(function()
             if not debris.Parent then
                 task.wait(1)
                 local newDebris = workspace:FindFirstChild("Debris")
                 if newDebris then Monitor(newDebris) end
             end
        end)
    end
    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Debris" or child.Name == "Projectiles" then
            Monitor(child)
        else
            HandleObject(child)
        end
    end)
    RunService.Heartbeat:Connect(function()
        for obj, _ in pairs(ZoneTrackers) do
            if not obj.Parent then ZoneTrackers[obj] = nil end
        end
    end)
end)
task.spawn(function()
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
        local FallDamagePacket = Remotes.Character.FallDamage
        if FallDamagePacket and FallDamagePacket.Send then
            local oldSend
            oldSend = hookfunction(FallDamagePacket.Send, function(...)
                if _G.Config.NoFallDamage then
                    return
                end
                return oldSend(...)
            end)
            print("BloxStrike: No Fall Damage (Direct Hook)")
        end
    end)
end)
task.spawn(function()
    local Lighting = game:GetService("Lighting")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local Debris = game:GetService("Debris")
    local function GetPlayerGui()
        return LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
    end
    local BadGuiNames = {
        ["FlashbangEffect"] = true,
        ["FlashOverlay"] = true,
        ["FlashScreenshot"] = true,
        ["BlindEffect"] = true,
        ["ScreenshotImage"] = true,
        ["StunEffect"] = true
    }
    local function SafeDestroyGui(instance)
        if not instance then return end
        if instance:IsA("ScreenGui") then
            instance.Enabled = false
        elseif instance:IsA("GuiObject") then
            instance.Visible = false
        end
        Debris:AddItem(instance, 0)
    end
    Lighting.ChildAdded:Connect(function(child)
        if not _G.Config.NoFlash then return end
        if (child.Name == "FlashbangColorCorrection" or child.Name:find("Flash") or child.Name:find("Blur")) 
           and (child:IsA("ColorCorrectionEffect") or child:IsA("BlurEffect") or child:IsA("DepthOfFieldEffect")) then
            child.Enabled = false
            Debris:AddItem(child, 0)
        end
    end)
    local function HookPlayerGui(pg)
        if not pg then return end
        pg.ChildAdded:Connect(function(child)
             if not _G.Config.NoFlash then return end
             if BadGuiNames[child.Name] then
                 SafeDestroyGui(child)
             end
        end)
    end
    if LocalPlayer then
        HookPlayerGui(GetPlayerGui())
        LocalPlayer.CharacterAdded:Connect(function()
            task.wait(1)
            HookPlayerGui(GetPlayerGui())
        end)
    end
    RunService.RenderStepped:Connect(function()
        if not _G.Config.NoFlash then return end
        for _, name in ipairs({"FlashbangColorCorrection", "FlashBlur", "Blur"}) do
            local effect = Lighting:FindFirstChild(name)
            if effect then 
                effect.Enabled = false
                effect:Destroy() 
            end
        end
        local pg = GetPlayerGui()
        if pg then
            for name, _ in pairs(BadGuiNames) do
                local overlay = pg:FindFirstChild(name)
                if overlay then 
                    SafeDestroyGui(overlay)
                end
            end
        end
    end)
    print("BloxStrike: Anti-Flashbang System Loaded (Fixed Error)")
end)
task.spawn(function()
    local Workspace = game:GetService("Workspace")
    local Debris = Workspace:WaitForChild("Debris")
    Debris.ChildAdded:Connect(function(child)
        if not _G.Config.CustomParticles then return end
        task.wait() 
        local targetColor = ColorSequence.new(_G.Config.ParticleColor or Color3.fromRGB(170, 0, 255))
        for _, descendant in ipairs(child:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant.Color = targetColor
                descendant.LightEmission = 1 
            end
        end
    end)
    print("BloxStrike: Custom Particles Loaded")
end)
task.spawn(function()
    local Workspace = game:GetService("Workspace")
    local DebrisService = game:GetService("Debris")
    local DebrisFolder = Workspace:FindFirstChild("Debris") or Workspace
    local TweenService = game:GetService("TweenService")
    local function PlaySound(parent, id, vol, speed)
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. id
        s.Volume = vol or 1
        s.PlaybackSpeed = speed or 1
        s.Parent = parent
        s:Play()
        DebrisService:AddItem(s, 5)
    end
    local function ApplyRocket(model)
        local torso = model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso") or model:FindFirstChild("HumanoidRootPart")
        if not torso then return end
        PlaySound(torso, "8741569477", 6) 
        local fire = Instance.new("ParticleEmitter", torso)
        fire.Texture = "rbxassetid://242905630"
        fire.Color = ColorSequence.new(Color3.fromRGB(255, 138, 59), Color3.fromRGB(255, 0, 0))
        fire.Size = NumberSequence.new(0.8, 0)
        fire.Rate = 100
        fire.Speed = NumberRange.new(5, 10)
        fire.EmissionDirection = Enum.NormalId.Back
        fire.Lifetime = NumberRange.new(0.5, 1)
        local smoke = Instance.new("ParticleEmitter", torso)
        smoke.Texture = "rbxassetid://242905630"
        smoke.Color = ColorSequence.new(Color3.fromRGB(100, 100, 100))
        smoke.Size = NumberSequence.new(1, 3)
        smoke.Rate = 50
        smoke.Speed = NumberRange.new(2, 5)
        smoke.Lifetime = NumberRange.new(1, 2)
        smoke.ZOffset = -1
        local bv = Instance.new("BodyVelocity", torso)
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, 50, 0) 
        local bav = Instance.new("BodyAngularVelocity", torso)
        bav.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bav.AngularVelocity = Vector3.new(0, 20, 0)
        task.spawn(function()
            local t = 0
            local duration = _G.Config.KillEffectDuration or 3
            while model.Parent and t < duration do
                t += 0.1
                if bv then bv.Velocity = bv.Velocity + Vector3.new(0, 10, 0) end 
                if bav then bav.AngularVelocity = bav.AngularVelocity + Vector3.new(0, 5, 0) end 
                task.wait(0.1)
            end
            if model.Parent then
                local ex = Instance.new("Explosion", Workspace)
                ex.Position = torso.Position
                ex.BlastRadius = 15
                ex.BlastPressure = 0 
                PlaySound(Workspace, "142070127", 3)
                local sw = Instance.new("Part", Workspace)
                sw.Anchored = true; sw.CanCollide = false; sw.Shape = Enum.PartType.Ball
                sw.Material = Enum.Material.Neon; sw.Color = Color3.fromRGB(255, 100, 0)
                sw.Size = Vector3.new(1, 1, 1); sw.CFrame = torso.CFrame
                sw.Transparency = 0.2
                local tween = TweenService:Create(sw, TweenInfo.new(0.3), {Size = Vector3.new(40, 40, 40), Transparency = 1})
                tween:Play()
                tween.Completed:Connect(function() sw:Destroy() end)
                model:Destroy()
            end
        end)
    end
    local function ApplyLightning(model)
        local torso = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
        if not torso then return end
        PlaySound(torso, "5721273154", 6, 1) 
        local startPos = torso.Position + Vector3.new(0, 150, 0)
        local endPos = torso.Position
        local function CreateBolt(p1, p2, thickness)
            local dist = (p1 - p2).Magnitude
            local part = Instance.new("Part", Workspace)
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(100, 200, 255) 
            part.Anchored = true; part.CanCollide = false
            part.Size = Vector3.new(thickness, thickness, dist)
            part.CFrame = CFrame.lookAt(p1, p2) * CFrame.new(0, 0, -dist/2)
            DebrisService:AddItem(part, 0.3) 
            local light = Instance.new("PointLight", part)
            light.Color = part.Color
            light.Range = 30
            light.Brightness = 10
        end
        local points = {startPos}
        local segments = 8
        for i = 1, segments do
            local last = points[#points]
            local alpha = i / segments
            local ideal = startPos:Lerp(endPos, alpha)
            local offset = Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
            if i == segments then offset = Vector3.zero end 
            table.insert(points, ideal + offset)
        end
        for i = 1, #points - 1 do
            CreateBolt(points[i], points[i+1], 1.5)
        end
        local ex = Instance.new("Explosion", Workspace)
        ex.Position = torso.Position
        ex.BlastRadius = 0; ex.BlastPressure = 0 
        for _, v in pairs(model:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("MeshPart") then
                v.Color = Color3.fromRGB(20, 20, 20)
                v.Material = Enum.Material.Slate
                local smoke = Instance.new("ParticleEmitter", v)
                smoke.Texture = "rbxassetid://242905630"
                smoke.Color = ColorSequence.new(Color3.fromRGB(0,0,0))
                smoke.Size = NumberSequence.new(0.5, 1)
                smoke.Rate = 10
                smoke.Lifetime = NumberRange.new(1, 3)
            elseif v:IsA("Clothing") or v:IsA("Decal") then
                v:Destroy()
            end
        end
        torso.Velocity = Vector3.new(0, 50, 0) + Vector3.new(math.random(-50,50), 0, math.random(-50,50))
    end
    local function ApplyBlackHole(model)
        local torso = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
        if not torso then return end
        torso.Anchored = true
        local hole = Instance.new("Part", Workspace)
        hole.Shape = Enum.PartType.Ball
        hole.Size = Vector3.new(1, 1, 1)
        hole.Color = Color3.new(0, 0, 0)
        hole.Material = Enum.Material.Neon
        hole.Anchored = true; hole.CanCollide = false
        hole.Position = torso.Position
        PlaySound(hole, "127456481028018", 10, 1) 
        local suck = Instance.new("ParticleEmitter", hole)
        suck.Texture = "rbxassetid://242205574" 
        suck.EmissionDirection = Enum.NormalId.Front
        suck.Lifetime = NumberRange.new(1)
        suck.Speed = NumberRange.new(-5, -2) 
        suck.Rate = 200
        suck.Color = ColorSequence.new(Color3.fromRGB(100, 0, 255), Color3.new(0,0,0))
        local duration = 1.5 
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        TweenService:Create(hole, tweenInfo, {Size = Vector3.new(15, 15, 15)}):Play()
        for _, v in pairs(model:GetChildren()) do
            if v:IsA("BasePart") then
                v.Anchored = true
                v.CanCollide = false
                v.Material = Enum.Material.Neon
                v.Color = Color3.new(0,0,0)
                TweenService:Create(v, tweenInfo, {
                    Size = Vector3.new(0.01, 0.01, 0.01), 
                    Position = hole.Position, 
                    Transparency = 1
                }):Play()
            end
        end
        task.delay(duration, function()
            local pop = TweenService:Create(hole, TweenInfo.new(0.1), {Size = Vector3.new(0,0,0)})
            pop:Play()
            spawn(function()
                 local sound = hole:FindFirstChild("Sound")
                 if sound then 
                      local t = TweenService:Create(sound, TweenInfo.new(0.5), {Volume = 0})
                      t:Play()
                      t.Completed:Wait()
                      sound:Stop()
                 end
            end)
            pop.Completed:Connect(function() 
                hole:Destroy()
                model:Destroy() 
            end)
        end)
    end
    local function ApplyDisintegrate(model)
        PlaySound(model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model.PrimaryPart, "2877304553", 4) 
        task.delay(1.0, function()
             PlaySound(Workspace, "2884860176", 4) 
        end)
        for _, v in pairs(model:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Neon
                v.Color = Color3.fromRGB(255, 100, 50)
                local dust = Instance.new("ParticleEmitter", v)
                dust.Texture = "rbxassetid://242205574"
                dust.Color = ColorSequence.new(Color3.fromRGB(255, 150, 50), Color3.fromRGB(50, 50, 50))
                dust.Size = NumberSequence.new(0.3, 0)
                dust.Rate = 100
                dust.Speed = NumberRange.new(2, 5)
                dust.SpreadAngle = Vector2.new(360, 360)
                dust.Lifetime = NumberRange.new(1, 2)
                dust.Acceleration = Vector3.new(0, 5, 0) 
                dust.Enabled = false
                task.delay(math.random() * 0.5, function()
                    dust.Enabled = true
                    local tween = TweenService:Create(v, TweenInfo.new(1), {Transparency = 1})
                    tween:Play()
                    task.delay(0.2, function() dust.Enabled = false end)
                end)
            elseif v:IsA("Decal") or v:IsA("Clothing") then
                v:Destroy()
            end
        end
        task.delay(_G.Config.KillEffectDuration or 2, function() model:Destroy() end)
    end
    local function ApplyAscension(model)
        local torso = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
        if not torso then return end
        PlaySound(torso, "9022476960", 6) 
        for _, v in pairs(model:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = true
                v.CanCollide = false
                v.Material = Enum.Material.Ice 
                v.Color = Color3.fromRGB(255, 215, 0) 
                v.Transparency = 0
                local s = Instance.new("Sparkles", v)
                s.SparkleColor = Color3.fromRGB(255, 255, 255)
            end
        end
        task.spawn(function()
            local startPos = {}
            for _, v in pairs(model:GetDescendants()) do
                if v:IsA("BasePart") then startPos[v] = v.Position end
            end
            local t = 0
            local duration = _G.Config.KillEffectDuration or 3
            while t < duration and model.Parent do
                local dt = game:GetService("RunService").Heartbeat:Wait()
                t += dt
                for v, original in pairs(startPos) do
                    if v.Parent then
                        v.Position = original + Vector3.new(0, t * 5, 0) 
                        v.Transparency = 0.3 + (t/3 * 0.7) 
                    end
                end
            end
            model:Destroy()
        end)
    end
    local function ApplyNuke(model)
        local torso = model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso") or model:FindFirstChild("HumanoidRootPart")
        if not torso then return end
        PlaySound(torso, "92744460088227", 10) 
        local e = Instance.new("ParticleEmitter", torso)
        e.Texture = "rbxassetid://242905630"
        e.Color = ColorSequence.new(Color3.fromRGB(100, 255, 0))
        e.Size = NumberSequence.new(2, 5)
        e.Rate = 100
        e.Speed = NumberRange.new(5, 20)
        e.EmissionDirection = Enum.NormalId.Top
        e.Lifetime = NumberRange.new(1, 3)
        local bv = Instance.new("BodyVelocity", torso)
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, 100, 0) 
        task.delay(1.5, function()
             if model.Parent then
                 local ex = Instance.new("Explosion", Workspace)
                 ex.Position = torso.Position
                 ex.BlastRadius = 50 
                 ex.BlastPressure = 0
                 PlaySound(Workspace, "142070127", 10) 
                 local nuke = Instance.new("Part", Workspace)
                 nuke.Anchored = true; nuke.CanCollide = false
                 nuke.Shape = Enum.PartType.Ball
                 nuke.Material = Enum.Material.Neon
                 nuke.Color = Color3.fromRGB(50, 255, 50) 
                 nuke.Size = Vector3.new(10, 10, 10)
                 nuke.CFrame = torso.CFrame
                 nuke.Transparency = 0.2
                 local t = TweenService:Create(nuke, TweenInfo.new(1), {Size = Vector3.new(200, 200, 200), Transparency=1})
                 t:Play()
                 t.Completed:Connect(function() nuke:Destroy() end)
                 model:Destroy()
             end
        end)
    end
    local function ApplyDigital(model)
        PlaySound(model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso"), "2979000306", 2) 
        for _, v in pairs(model:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = true
                v.Material = Enum.Material.ForceField
                v.Color = Color3.fromRGB(0, 255, 0) 
                if v:IsA("MeshPart") then
                    v.TextureID = "" 
                end
            end
        end
        local hl = Instance.new("Highlight", model)
        hl.FillColor = Color3.fromRGB(0, 255, 0)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        task.spawn(function()
            local duration = _G.Config.KillEffectDuration or 3
            local steps = math.floor(duration * 10)
            for i = 1, steps do
                if not model.Parent then break end
                if hl then hl.FillColor = Color3.fromHSV(math.random(), 1, 1) end
                for _, v in pairs(model:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.Color = Color3.fromHSV(math.random(), 1, 1)
                        v.CFrame = v.CFrame * CFrame.new(math.random(-1,1)*0.5, math.random(-1,1)*0.5, math.random(-1,1)*0.5)
                    end
                end
                task.wait(0.1)
            end
            model:Destroy()
        end)
    end
    DebrisFolder.ChildAdded:Connect(function(child)
        if not _G.Config.KillEffect then return end
        task.wait(0.05) 
        if child:IsA("Model") and child:FindFirstChild("Humanoid") and child:FindFirstChild("Head") then
             local mode = _G.Config.KillEffectMode or "Lightning"
             if mode == "Rocket" then ApplyRocket(child)
             elseif mode == "Lightning" then ApplyLightning(child)
             elseif mode == "Nuke" then ApplyNuke(child) 
             elseif mode == "Black Hole" then ApplyBlackHole(child)
             elseif mode == "Disintegrate" then ApplyDisintegrate(child)
             elseif mode == "Ascension" then ApplyAscension(child)
             elseif mode == "Digital" then ApplyDigital(child)
             else ApplyLightning(child) 
             end
        end
    end)
    print("BloxStrike: Kill Effects Enhanced Loaded")
end)
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

local IsGrenadeActive = false
RunService.Heartbeat:Connect(function()
    if not _G.Config.AntiAim then return end
    
    local active = false
    
    local cam = workspace.CurrentCamera
    if cam then
        for _, child in ipairs(cam:GetChildren()) do
            local name = child.Name:lower()
            if name:find("grenade") or name:find("flash") or name:find("molotov") or name:find("decoy") or name:find("smoke") then
                active = true; break
            end
        end
    end
    
    
    if not active then
        local char = Players.LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildWhichIsA("Tool")
            if tool then
                local name = tool.Name:lower()
                if name:find("grenade") or name:find("flash") or name:find("molotov") or name:find("decoy") or name:find("smoke") then
                   active = true
                end
            end
        end
    end
    IsGrenadeActive = active
end)

local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index
mt.__index = newcclosure(function(self, k)
    if self == Camera and k == "CFrame" and _G.Config.AntiAim then
        if not checkcaller() then
            
            if IsGrenadeActive then
                 return oldIndex(self, k)
            end
            
            local trace = debug.traceback()
            if trace:find("Viewmodel") or trace:find("Bobble") or trace:find("WeaponComponent") or trace:find("CameraController") or trace:find("Loadout") then
                return oldIndex(self, k)
            end
            if trace:find("ByteNet") or trace:find("Spectate") or trace:find("UpdateCameraCFrame") or trace:find("Replicate") then
                local realCFrame = oldIndex(self, k)
                local _, realYaw, _ = realCFrame:ToEulerAnglesYXZ()
                local pitch = -1.57
                if _G.Config.AntiAimPitchMode == "Up" then pitch = 1.57 end
                local yawOffset = 0
                if _G.Config.AntiAimBackwards then yawOffset = math.pi end
                local targetYaw = realYaw
                local useTarget = false
                if _G.Config.FollowBackwardsAA and _G.AA_Target and _G.AA_Target.Character and _G.AA_Target.Character:FindFirstChild("HumanoidRootPart") then
                    local myChar = Players.LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local targetPos = _G.AA_Target.Character.HumanoidRootPart.Position
                        local myPos = myChar.HumanoidRootPart.Position
                        local horizontalDiff = Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(myPos.X, 0, myPos.Z)
                        if horizontalDiff.Magnitude > 0.1 then
                            local lookCFrame = CFrame.lookAt(myPos, Vector3.new(targetPos.X, myPos.Y, targetPos.Z))
                            local _, tYaw, _ = lookCFrame:ToEulerAnglesYXZ()
                            targetYaw = tYaw
                            useTarget = true
                            yawOffset = math.pi 
                        end
                    end
                end
                if useTarget then
                    if not _G.AA_LastYaw then _G.AA_LastYaw = targetYaw end
                    local diff = (targetYaw - _G.AA_LastYaw + math.pi*3) % (math.pi*2) - math.pi
                    _G.AA_LastYaw = _G.AA_LastYaw + diff * 0.2 
                    realYaw = _G.AA_LastYaw
                else
                     realYaw = realYaw 
                end
                return CFrame.new(realCFrame.Position) * CFrame.fromEulerAnglesYXZ(pitch, realYaw + yawOffset, 0)
            end
        end
    end
    return oldIndex(self, k)
end)
setreadonly(mt, true)


task.spawn(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    
    local LP = Players.LocalPlayer

    local function CreateESPPreview()
        local SCREEN_SIZE = Vector2.new(250, 350)
        
        local previewGui = Instance.new("ScreenGui")
        previewGui.Name = "BS_ESPPreview"
        previewGui.ResetOnSpawn = false 
        previewGui.Enabled = true 
        pcall(function() previewGui.Parent = LP:WaitForChild("PlayerGui") end)

        
        _G.SyncPreviewVisibility = function(isVisible)
            if previewGui then previewGui.Enabled = isVisible end
        end

        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "PreviewFrame"
        mainFrame.Size = UDim2.new(0, SCREEN_SIZE.X, 0, SCREEN_SIZE.Y)
        mainFrame.Position = UDim2.new(0.7, 0, 0.3, 0)
        mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.Parent = previewGui

        
        local topBar = Instance.new("Frame")
        topBar.Size = UDim2.new(1, 0, 0, 20)
        topBar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        topBar.BorderSizePixel = 0
        topBar.Parent = mainFrame

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -10, 1, 0)
        title.Position = UDim2.new(0, 5, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "ESP Preview"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 12
        title.TextColor3 = Color3.new(1,1,1)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = topBar

        
        local viewport = Instance.new("ViewportFrame")
        viewport.Name = "Viewport"
        viewport.Position = UDim2.new(0, 0, 0, 20)
        viewport.Size = UDim2.new(1, 0, 1, -20)
        viewport.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        viewport.BorderSizePixel = 0
        viewport.Parent = mainFrame
        



        
        local vpCamera = Instance.new("Camera")
        vpCamera.Parent = viewport
        viewport.CurrentCamera = vpCamera
        vpCamera.CFrame = CFrame.lookAt(Vector3.new(0, 3, -10), Vector3.new(0, 3, 0))

        
        local worldModel = Instance.new("WorldModel")
        worldModel.Parent = viewport

        
        local debugLabel = Instance.new("TextLabel")
        debugLabel.Name = "Debug"
        debugLabel.Size = UDim2.new(1, 0, 0, 15)
        debugLabel.Position = UDim2.new(0, 0, 1, -15)
        debugLabel.BackgroundTransparency = 1
        debugLabel.TextColor3 = Color3.new(1, 0, 0)
        debugLabel.TextSize = 10
        debugLabel.Text = "Initializing..."
        debugLabel.Visible = false 
        debugLabel.ZIndex = 20
        debugLabel.Parent = mainFrame

        
        local dummy = nil
        local highlight = nil 
        
        
        local function GetRealCharacter()
            local char = LP.Character
            if char and char.Parent then return char end
            
            
            local charsFolder = workspace:FindFirstChild("Characters")
            if charsFolder then
                
                
                
                for _, folder in ipairs(charsFolder:GetChildren()) do
                     local found = folder:FindFirstChild(LP.Name)
                     if found then return found end
                end
                 
                local foundDirect = charsFolder:FindFirstChild(LP.Name)
                if foundDirect then return foundDirect end
            end
            return nil
        end

        local function CloneRealCharacter()
            if dummy then dummy:Destroy() end
            local char = GetRealCharacter()
            if not char then return nil end
            
            char.Archivable = true
            local clone = char:Clone()
            char.Archivable = false
            
            if not clone then return nil end
            
            clone.Name = "Dummy"
            
            
            for _, v in ipairs(clone:GetDescendants()) do
                if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") or v:IsA("Sound") or v:IsA("ForceField") then
                    v:Destroy()
                elseif v:IsA("BasePart") then
                    v.Anchored = true
                    v.CanCollide = false
                    if v.Name == "HumanoidRootPart" then
                        v.Transparency = 1
                    elseif v.Transparency < 1 then
                         v.Transparency = 0 
                    end
                elseif v:IsA("Humanoid") then
                    v.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    v.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                end
            end
            
            
            highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.FillColor = _G.Config.EnemyColor or Color3.new(1, 0, 0)
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.Parent = clone
            highlight.Enabled = false 
            
            clone.Parent = worldModel 
            clone:PivotTo(CFrame.new(0, 3, 0)) 
            return clone
        end
        
        dummy = CloneRealCharacter()
        
        
        LP.CharacterAdded:Connect(function(newChar)
            
            task.delay(1.5, function()
                 if newChar and newChar.Parent then
                     dummy = CloneRealCharacter()
                     
                     lastWeaponName = "None" 
                 end
            end)
        end)

        
        
        local espContainer = Instance.new("Frame")
        espContainer.Name = "ESPContainer"
        espContainer.Size = UDim2.new(1, 0, 1, 0)
        espContainer.BackgroundTransparency = 1
        espContainer.ZIndex = 10 
        espContainer.Parent = viewport

        local boxOutline = Instance.new("Frame")
        boxOutline.Name = "Box"
        boxOutline.BackgroundTransparency = 1 
        boxOutline.BorderSizePixel = 0
        boxOutline.Visible = false
        boxOutline.ZIndex = 11
        boxOutline.Parent = espContainer
        
        local boxStroke = Instance.new("UIStroke")
        boxStroke.Parent = boxOutline
        boxStroke.Thickness = 1.5

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "Name"
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 13
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Text = LP.Name 
        nameLabel.Visible = false
        nameLabel.ZIndex = 12
        nameLabel.AnchorPoint = Vector2.new(0.5, 1) 
        nameLabel.Parent = espContainer
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "Dist"
        distLabel.BackgroundTransparency = 1
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 11
        distLabel.TextStrokeTransparency = 0
        distLabel.Text = "[15m]"
        distLabel.Visible = false
        distLabel.ZIndex = 12
        distLabel.AnchorPoint = Vector2.new(0.5, 0) 
        distLabel.Parent = espContainer

        local weaponLabel = Instance.new("TextLabel")
        weaponLabel.Name = "Weapon"
        weaponLabel.BackgroundTransparency = 1
        weaponLabel.Font = Enum.Font.Gotham
        weaponLabel.TextSize = 11
        weaponLabel.TextStrokeTransparency = 0
        weaponLabel.Text = "Rifle"
        weaponLabel.Visible = false
        weaponLabel.ZIndex = 12
        weaponLabel.AnchorPoint = Vector2.new(0, 0) 
        weaponLabel.Parent = espContainer
        
        local inventoryLabel = Instance.new("TextLabel")
        inventoryLabel.Name = "Inventory"
        inventoryLabel.BackgroundTransparency = 1
        inventoryLabel.Font = Enum.Font.Gotham
        inventoryLabel.TextSize = 10
        inventoryLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        inventoryLabel.TextStrokeTransparency = 0
        inventoryLabel.Text = ""
        inventoryLabel.Visible = false
        inventoryLabel.ZIndex = 12
        inventoryLabel.AnchorPoint = Vector2.new(0.5, 0) 
        inventoryLabel.Parent = espContainer

        local healthBarBg = Instance.new("Frame")
        healthBarBg.BorderSizePixel = 0
        healthBarBg.BackgroundColor3 = Color3.new(0,0,0)
        healthBarBg.Visible = false
        healthBarBg.ZIndex = 11
        healthBarBg.Parent = espContainer
        local healthBarFill = Instance.new("Frame")
        healthBarFill.BorderSizePixel = 0
        healthBarFill.ZIndex = 12
        healthBarFill.Parent = healthBarBg
        
        local headDot = Instance.new("Frame")
        headDot.Name = "HeadDot"
        headDot.Size = UDim2.new(0, 4, 0, 4)
        headDot.BackgroundColor3 = Color3.new(1, 0, 0)
        headDot.BorderSizePixel = 0
        headDot.Visible = false
        headDot.ZIndex = 13
        headDot.Parent = espContainer
        local headDotCorner = Instance.new("UICorner")
        headDotCorner.CornerRadius = UDim.new(1, 0)
        headDotCorner.Parent = headDot
        
        
        
        
        
        

        local function GetBoundingBox()
            if not dummy or not dummy.Parent then return end
            
            local minX, minY = 100000, 100000
            local maxX, maxY = -100000, -100000
            local onScreenAny = false
            local partCount = 0
            
            local vpSize = viewport.AbsoluteSize
            local scaleX = vpSize.X
            local scaleY = vpSize.Y

            for _, part in ipairs(dummy:GetChildren()) do
                if part:IsA("BasePart") and part.Transparency < 1 then 
                    partCount = partCount + 1
                    local size = part.Size
                    local cf = part.CFrame
                    local corners = {
                        cf * CFrame.new(size.X/2, size.Y/2, size.Z/2),
                        cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2),
                        cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2),
                        cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2),
                        cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2),
                        cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2),
                        cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2),
                        cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2),
                    }
                    for _, corner in ipairs(corners) do
                        local pos, vis = vpCamera:WorldToViewportPoint(corner.Position)
                        local posX = pos.X * scaleX
                        local posY = pos.Y * scaleY
                        
                        if vis then onScreenAny = true end
                        if posX < minX then minX = posX end
                        if posY < minY then minY = posY end
                        if posX > maxX then maxX = posX end
                        if posY > maxY then maxY = posY end
                    end
                end
            end
            return minX, minY, maxX, maxY, onScreenAny, partCount
        end

        local lastCheckTime = 0
        local lastWeaponName = "None" 
        
        
        local cachedWeaponAttr = nil
        local cachedWeaponName = "None"

        local function GetCurrentWeaponName(player)
            if not player then return "None" end
            local attr = player:GetAttribute("CurrentEquipped")
            
            if attr ~= cachedWeaponAttr then
                cachedWeaponAttr = attr
                if attr then
                    local s, decoded = pcall(function() return game:GetService("HttpService"):JSONDecode(attr) end)
                    if s and decoded and decoded.Name then
                        cachedWeaponName = decoded.Name
                    else
                        cachedWeaponName = "None"
                    end
                else
                    cachedWeaponName = "None"
                end
            end
            return cachedWeaponName
        end

        local function CheckAppearanceChanged()
            if not dummy then return true end
            local realChar = GetRealCharacter()
            if not realChar then return false end
            
            
            local realWeaponName = GetCurrentWeaponName(LP)
            if realWeaponName ~= lastWeaponName then return true end
            
            
            local realShirt = realChar:FindFirstChildWhichIsA("Shirt")
            local dummyShirt = dummy:FindFirstChildWhichIsA("Shirt")
            if (realShirt and not dummyShirt) or (not realShirt and dummyShirt) then return true end
            if realShirt and dummyShirt and realShirt.ShirtTemplate ~= dummyShirt.ShirtTemplate then return true end

             
            local realPants = realChar:FindFirstChildWhichIsA("Pants")
            local dummyPants = dummy:FindFirstChildWhichIsA("Pants")
            if (realPants and not dummyPants) or (not realPants and dummyPants) then return true end
            if realPants and dummyPants and realPants.PantsTemplate ~= dummyPants.PantsTemplate then return true end
            
            return false
        end

        local function Update()
            if not mainFrame.Visible then return end
            
            
            if tick() - lastCheckTime > 1 then
                lastCheckTime = tick()
                if CheckAppearanceChanged() then
                     dummy = CloneRealCharacter()
                     lastWeaponName = GetCurrentWeaponName(LP) 
                end
            end
            
            if not dummy then
                 dummy = CloneRealCharacter()
                 lastWeaponName = GetCurrentWeaponName(LP)
                 if not dummy then 
                     debugLabel.Text = "No Dummy"
                     return 
                 end
            end

            
            local currentWeapon = GetCurrentWeaponName(LP)
            local inventoryText = ""
            
            local backpack = LP:FindFirstChild("Backpack")
            if backpack then
                 local items = {}
                 for _, t in ipairs(backpack:GetChildren()) do
                     if t:IsA("Tool") then table.insert(items, t.Name) end
                 end
                 inventoryText = table.concat(items, ", ")
            end
            
            if nameLabel then nameLabel.Text = LP.Name end
            if weaponLabel then weaponLabel.Text = currentWeapon end
            if inventoryLabel then inventoryLabel.Text = inventoryText end
            
            if distLabel and dummy and dummy.PrimaryPart then
                 local dist = (dummy.PrimaryPart.Position - vpCamera.CFrame.Position).Magnitude
                 distLabel.Text = string.format("[%dm]", math.floor(dist))
            end

            -- Health Bar Update
            local realChar = GetRealCharacter()
            if realChar then 
                local hum = realChar:FindFirstChild("Humanoid")
                if hum then
                     local hp = hum.Health
                     local max = hum.MaxHealth
                     local alpha = math.clamp(hp/max, 0, 1)
                     healthBarFill.Size = UDim2.new(alpha, 0, 1, 0)
                     healthBarFill.BackgroundColor3 = Color3.fromHSV(alpha * 0.3, 1, 1)
                end
            end
            
            local root = dummy:FindFirstChild("HumanoidRootPart")
            if root then
                
                
                
                
                
                
                dummy:PivotTo(CFrame.lookAt(Vector3.new(0, 3, 0), vpCamera.CFrame.Position))
            end
            
            local minX, minY, maxX, maxY, onScreen, pCount = GetBoundingBox()
            
            
            local vpSize = viewport.AbsoluteSize
            if minX and minY and maxX and maxY then
                debugLabel.Text = string.format("Box: %d,%d -> %d,%d", minX, minY, maxX, maxY)
            else
                debugLabel.Text = "Waiting for valid bounds..."
                
                pCount = 0 
            end
            
            
            local headPos = nil
            local head = dummy:FindFirstChild("Head")
            if head then
                local pos, vis = vpCamera:WorldToViewportPoint(head.Position)
                if vis then
                    headPos = Vector2.new(pos.X * vpSize.X, pos.Y * vpSize.Y)
                end
            end
            
            if pCount and pCount > 0 then 
                local width = maxX - minX
                local height = maxY - minY
                
                
                if _G.Config.EspBoxes then
                    boxOutline.Visible = true
                    boxOutline.Position = UDim2.new(0, minX, 0, minY)
                    boxOutline.Size = UDim2.new(0, width, 0, height)
                    boxStroke.Color = _G.Config.BoxColor or Color3.new(1,1,1)
                else
                    boxOutline.Visible = false
                end
                
                
                
                
                if _G.Config.EspChams then
                    for _, v in ipairs(dummy:GetChildren()) do
                        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                             v.Material = Enum.Material.Neon
                             v.Color = _G.Config.EnemyColor or Color3.new(1,0,0)
                             v.Transparency = 0.5 
                        end
                    end
                else
                 
                end
                
            
                if _G.Config.EspChinaHat then
                    local head = dummy:FindFirstChild("Head")
                    if head then
                        local cha = head:FindFirstChild("ChinaHatAdornment")
                        if not cha then
                            cha = Instance.new("ConeHandleAdornment")
                            cha.Name = "ChinaHatAdornment"
                            cha.Adornee = head
                            cha.Height = 1.0  
                            cha.Radius = 1.0  
                            cha.AlwaysOnTop = true
                            cha.ZIndex = 5    
                            cha.Transparency = 0.3
                            cha.CFrame = CFrame.new(0, 0.7, 0) * CFrame.Angles(math.rad(-90), 0, 0) 
                            cha.Parent = head
                        end
                        cha.Visible = true
                        
                        
                        if _G.Config.EspChinaHatRainbow then
                            local t = tick()
                            
                            cha.Color3 = Color3.fromHSV((t % 5)/5, 1, 1)
                        else
                             cha.Color3 = _G.Config.HeadDotColor or Color3.new(1, 0, 0)
                             
                        end
                    end
                else
                    if dummy then
                        local head = dummy:FindFirstChild("Head")
                        if head then
                            local cha = head:FindFirstChild("ChinaHatAdornment")
                            if cha then cha.Visible = false end
                        end
                    end
                end
                
                
                if _G.Config.EspNames then
                    nameLabel.Visible = true
                    nameLabel.Position = UDim2.new(0, minX + (width/2), 0, minY - 2) 
                    nameLabel.TextColor3 = _G.Config.NameColor or Color3.new(1,1,1)
                    nameLabel.Text = LP.Name
                else
                    nameLabel.Visible = false
                end
                
                
                if _G.Config.EspHealthBar then
                    healthBarBg.Visible = true
                    healthBarBg.Position = UDim2.new(0, minX - 5, 0, minY)
                    healthBarBg.Size = UDim2.new(0, 2, 0, height)
                    
                    local hp = 80
                    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                        hp = LP.Character.Humanoid.Health
                    end
                    local scale = hp / 100
                    healthBarFill.Size = UDim2.new(1, 0, scale, 0)
                    healthBarFill.Position = UDim2.new(0, 0, 1 - scale, 0)
                    healthBarFill.BackgroundColor3 = _G.Config.HealthBarColor or Color3.new(0,1,0)
                else
                    healthBarBg.Visible = false
                end
                
                
                if _G.Config.EspHeadDot and headPos then
                    headDot.Visible = true
                    headDot.Position = UDim2.new(0, headPos.X - 2, 0, headPos.Y - 2) 
                    headDot.BackgroundColor3 = _G.Config.HeadDotColor or Color3.new(1, 0, 0)
                else
                    headDot.Visible = false
                end
                
                 
                if _G.Config.EspDistance then
                    distLabel.Visible = true
                    distLabel.Position = UDim2.new(0, minX + (width/2), 0, maxY + 2) 
                    distLabel.TextColor3 = _G.Config.DistColor or Color3.new(1,1,1)
                else
                    distLabel.Visible = false
                end
                
                
                if _G.Config.EspWeapon then
                    weaponLabel.Visible = true
                    weaponLabel.TextXAlignment = Enum.TextXAlignment.Left
                    
                    weaponLabel.Position = UDim2.new(0, maxX + 4, 0, minY + (height * 0.15)) 
                    weaponLabel.TextColor3 = _G.Config.WeaponColor or Color3.new(1,1,1)
                else
                    weaponLabel.Visible = false
                end
                
                
                if _G.Config.EspInventory and inventoryText ~= "" then
                    inventoryLabel.Visible = true
                     local offset = (_G.Config.EspDistance and 12 or 2) + 2
                    inventoryLabel.Position = UDim2.new(0, minX + (width/2), 0, maxY + offset) 
                else
                    inventoryLabel.Visible = false
                end
            else
                
                boxOutline.Visible = false
                nameLabel.Visible = false
                distLabel.Visible = false
                weaponLabel.Visible = false
                healthBarBg.Visible = false
                headDot.Visible = false
                inventoryLabel.Visible = false
                if highlight then highlight.Enabled = false end
            end
        end
        
        RunService.RenderStepped:Connect(Update)
    end
    CreateESPPreview()
end)
