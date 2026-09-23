task.spawn(function()

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Miwtf-lol/Sailor-piece-mi.wtf/refs/heads/main/Kittylol_UI_FIXED.txt"
))()

local UI = Library._new()

repeat task.wait(0.5) until game:IsLoaded()

local Players           = cloneref(game:GetService('Players'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local UserInputService  = cloneref(game:GetService('UserInputService'))
local RunService        = cloneref(game:GetService('RunService'))
local TweenService      = cloneref(game:GetService('TweenService'))
local Stats             = cloneref(game:GetService('Stats'))
local Debris            = cloneref(game:GetService('Debris'))
local CoreGui           = cloneref(game:GetService('CoreGui'))
local HttpService       = cloneref(game:GetService('HttpService'))
local Workspace         = cloneref(game:GetService('Workspace'))

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

local Alive   = Workspace:FindFirstChild("Alive") or Workspace:WaitForChild("Alive")
local Runtime = Workspace.Runtime

local function detectMobile()
    local touch = UserInputService.TouchEnabled
    local mouse = UserInputService.MouseEnabled
    local keyboard = UserInputService.KeyboardEnabled
    if touch and not keyboard then return true end
    if touch and not mouse then return true end
    return false
end

local function Notify(title, content, duration)
    duration = duration or 2
    task.spawn(function()
        pcall(function()
            local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
            local parent = CoreGui
            if not parent then parent = playerGui end
            if not parent then return end

            local gui = parent:FindFirstChild("Kittylol_Notifications")
            if not gui then
                gui = Instance.new("ScreenGui")
                gui.Name = "Kittylol_Notifications"
                gui.ResetOnSpawn = false
                gui.IgnoreGuiInset = true
                gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                gui.Parent = parent
            end

            local holder = gui:FindFirstChild("Holder")
            if not holder then
                holder = Instance.new("Frame")
                holder.Name = "Holder"
                holder.AnchorPoint = Vector2.new(1, 0)
                holder.Position = UDim2.new(1, -18, 0, 18)
                holder.Size = UDim2.fromOffset(320, 0)
                holder.BackgroundTransparency = 1
                holder.Parent = gui

                local layout = Instance.new("UIListLayout")
                layout.Padding = UDim.new(0, 8)
                layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                layout.VerticalAlignment = Enum.VerticalAlignment.Top
                layout.Parent = holder
            end

            local frame = Instance.new("Frame")
            frame.Name = "Notification"
            frame.Size = UDim2.fromOffset(320, 72)
            frame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
            frame.BackgroundTransparency = 0.03
            frame.BorderSizePixel = 0
            frame.ClipsDescendants = true
            frame.Parent = holder

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = frame

            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(145, 145, 145)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
            })
            gradient.Rotation = 0
            gradient.Parent = frame

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(255, 255, 255)
            stroke.Transparency = 0.35
            stroke.Thickness = 1
            stroke.Parent = frame

            local titleLabel = Instance.new("TextLabel")
            titleLabel.BackgroundTransparency = 1
            titleLabel.Position = UDim2.fromOffset(14, 10)
            titleLabel.Size = UDim2.new(1, -28, 0, 20)
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.Text = tostring(title)
            titleLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
            titleLabel.TextSize = 14
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = frame

            local contentLabel = Instance.new("TextLabel")
            contentLabel.BackgroundTransparency = 1
            contentLabel.Position = UDim2.fromOffset(14, 32)
            contentLabel.Size = UDim2.new(1, -28, 0, 30)
            contentLabel.Font = Enum.Font.Gotham
            contentLabel.Text = tostring(content)
            contentLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
            contentLabel.TextSize = 12
            contentLabel.TextWrapped = true
            contentLabel.TextXAlignment = Enum.TextXAlignment.Left
            contentLabel.TextYAlignment = Enum.TextYAlignment.Top
            contentLabel.Parent = frame

            frame.Position = UDim2.new(1, 25, 0, 0)
            TweenService:Create(frame, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()

            task.wait(duration)
            local out = TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 25, 0, 0),
                BackgroundTransparency = 1
            })
            out:Play()
            out.Completed:Wait()
            frame:Destroy()
        end)
    end)
end

local System = {
    __properties = {
        __autoparry_enabled = false,
        __triggerbot_enabled = false,
        __manual_spam_enabled = false,
        __auto_spam_enabled = false,
        __play_animation = false,
        __accuracy = 50,
        __divisor_multiplier = 1.1,
        __parried = false,
        __training_parried = false,
        __spam_threshold = 1.5,
        __parries = 0,
        __parry_key = nil,
        __grab_animation = nil,
        __tornado_time = tick(),
        __first_parry_done = false,
        __connections = {},
        __reverted_remotes = {},
        __spam_accumulator = 0,
        __spam_rate = 340,
        __infinity_active = false,
        __deathslash_active = false,
        __timehole_active = false,
        __slashesoffury_active = false,
        __slashesoffury_count = 0,
        __is_mobile = detectMobile(),
        __mobile_guis = {},
        __randomized_accuracy_enabled = false,
        __speed_display_enabled = false,
        __auto_jump_enabled = false,
        __ball_speed = 0,
        __peak_ball_speed = 0,
        __headless_enabled = false,
        __korblox_enabled = false,
        __thunder_dash_enabled = false
    },
    __config = {
        __detections = {
            __infinity=false,__deathslash=false,
            __timehole=false,__slashesoffury=false,__phantom=false
        }
    },
    __triggerbot = {
        __enabled=false,__is_parrying=false,
        __parries=0,__max_parries=10000,__parry_delay=0.05
    }
}

local function update_divisor()
    System.__properties.__divisor_multiplier = 0.7 + (System.__properties.__accuracy - 1) * (0.9/99)
end

local function update_randomized_accuracy()
    if not System.__properties.__randomized_accuracy_enabled then return end
    local ping_str = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
    local ping = tonumber(ping_str:match("%d+")) or 0
    local new_accuracy
    if ping >= 90 then new_accuracy = 4
    elseif ping <= 50 then new_accuracy = math.random(70, 100)
    else new_accuracy = System.__properties.__accuracy end
    if new_accuracy then System.__properties.__accuracy = new_accuracy; update_divisor() end
end

task.spawn(function()
    while task.wait(1) do
        if System.__properties.__randomized_accuracy_enabled then update_randomized_accuracy() end
    end
end)

local replicated_storage = cloneref(game:GetService('ReplicatedStorage'))
local workspace = cloneref(game:GetService('Workspace'))

local _token
local _tokenFound = false

for _, Function in getgc(true) do
    if type(Function) ~= 'function' or not debug.info(Function, 's'):find('PRY', 1, true) then
        continue
    end
    for _, value in debug.getupvalues(Function) do
        if type(value) == 'function' then
            _token = value
            _tokenFound = true
            break
        end
    end
    if _token then break end
end

if not _tokenFound then
    Notify("Kittylol", "Remote not found! Re-inject vÃ  cháº¡y láº¡i.", 5)
    return
end

function _tokenize(_remote_uid)
    local time = tostring(math.floor(workspace:GetServerTimeNow() * 100))
    local key = _token(_remote_uid, 'TIME')
    local characters = table.create(#time)
    for index = 1, #time do
        characters[index] = string.char(bit32.bxor(
            (string.byte(time, index ) + index) % 256,
            string.byte(key, (index - 1) % #key + 1)
        ))
    end
    return table.concat(characters)
end

local _reverted = {}
local _original = {}
local _captured = nil
local _capturedRemote = nil
local _capturedArgs = nil

function _is_valid(args)
    if not args or #args < 8 then return false end
    return true
end

function _hook(remote)
    if not remote then return end
    if _reverted[remote] then return end
    if _original[getrawmetatable(remote)] then return end

    _original[getrawmetatable(remote)] = true
    local _meta = getrawmetatable(remote)
    setreadonly(_meta, false)

    local _old = _meta.__index
    _meta.__index = function(self, key)
        if (key == 'FireServer' and self:IsA('RemoteEvent')) or
           (key == 'InvokeServer' and self:IsA('RemoteFunction')) then
            return function(_, ...)
                local _arguments = {...}
                if _is_valid(_arguments) then
                    if not _reverted[self] then
                        _reverted[self] = _arguments
                        _captured = { remote = self, args = _arguments }
                        _capturedRemote = self
                        _capturedArgs = _arguments
                    end
                end
                return _old(self, key)(_, unpack(_arguments))
            end
        end
        return _old(self, key)
    end
    setreadonly(_meta, true)
end

for _iterator, _remote in pairs(replicated_storage:GetDescendants()) do
    if _remote:IsA('RemoteEvent') or _remote:IsA('RemoteFunction') then
        _hook(_remote)
    end
end

task.wait(5)

task.spawn(function()
    while not _capturedRemote do
        task.wait(1)
    end
    if _capturedRemote then
        Notify("Kittylol", "Anti-cheat Bypassed", 3)
    end
end)

local function fireParryRemote(curveCF)
    if not _capturedRemote or not _capturedArgs then
        return false
    end

    local cam = Workspace.CurrentCamera
    local is_mobile = System.__properties.__is_mobile
    local aim_target

    if is_mobile then
        local vp = cam.ViewportSize
        aim_target = {math.floor(vp.X / 2), math.floor(vp.Y / 2)}
    else
        local ok, mouse = pcall(function() return UserInputService:GetMouseLocation() end)
        if ok and mouse then
            aim_target = {math.floor(mouse.X), math.floor(mouse.Y)}
        else
            local vp = cam.ViewportSize
            aim_target = {math.floor(vp.X / 2), math.floor(vp.Y / 2)}
        end
    end

    local event_data = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local ok, sp = pcall(function() return cam:WorldToScreenPoint(entity.PrimaryPart.Position) end)
                if ok then event_data[entity.Name] = sp end
            end
        end
    end

    local packet = {
        _capturedArgs[1],
        _capturedArgs[2],
        _tokenize(_capturedArgs[2]),
        0.5,
        curveCF or cam.CFrame,
        event_data,
        aim_target,
        false
    }

    pcall(function()
        if _capturedRemote:IsA('RemoteEvent') then
            _capturedRemote:FireServer(unpack(packet))
        elseif _capturedRemote:IsA('RemoteFunction') then
            _capturedRemote:InvokeServer(unpack(packet))
        end
    end)
    return true
end

System.animation = {}

local SwordAPI = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("SwordAPI")
local LastPlayedd = 0
local Sword_CP = false
local Sword_Spped = 1
local Grab_Parry = nil
local AnimFix_Cache = {}

local function GetParryAnimation(swordName)
    if not swordName or swordName == "" then
        return SwordAPI.Collection.Default:FindFirstChild("GrabParry")
    end
    if AnimFix_Cache[swordName] then return AnimFix_Cache[swordName] end
    local ok, swordData = pcall(function()
        return ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(swordName)
    end)
    if not ok or not swordData or type(swordData) ~= "table" or not swordData.AnimationType then
        AnimFix_Cache[swordName] = SwordAPI.Collection.Default:FindFirstChild("GrabParry")
        return AnimFix_Cache[swordName]
    end
    for _, obj in pairs(SwordAPI.Collection:GetChildren()) do
        if obj.Name == swordData.AnimationType then
            local anim = obj:FindFirstChild("GrabParry") or obj:FindFirstChild("Grab")
            if anim then
                AnimFix_Cache[swordName] = anim
                return anim
            end
        end
    end
    AnimFix_Cache[swordName] = SwordAPI.Collection.Default:FindFirstChild("GrabParry")
    return AnimFix_Cache[swordName]
end

local function GrabParryPlay(track)
    if not track then return end
    pcall(function()
        track:Play(
            track:GetAttribute("PlayFadeTime") or 0,
            track:GetAttribute("PlayWeight") or 1,
            track:GetAttribute("PlaySpeed") or 1
        )
    end)
end

local function GrabParryStop(track)
    if not track then return end
    pcall(function()
        track:Stop(track:GetAttribute("StopFadeTime") or 0.1)
    end)
end

function System.animation.play_grab_parry()
    if not System.__properties.__play_animation then return end
    if not ((os.clock() - LastPlayedd) >= (Sword_Spped - 0.8) or Sword_CP) then return end
    LastPlayedd = os.clock()
    Sword_CP = false
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local currentSword
    if getgenv().skinChanger then
        currentSword = (getgenv().swordAnimations ~= "" and getgenv().swordAnimations)
                    or (getgenv().swordModel ~= "" and getgenv().swordModel)
                    or char:GetAttribute("CurrentlyEquippedSword")
    else
        currentSword = char:GetAttribute("CurrentlyEquippedSword")
    end
    local animation = GetParryAnimation(currentSword)
    if not animation then return end
    for _, track in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
        if track.Name == "GrabParry" or track.Name == "Grab" then
            track.TimePosition = 0
            GrabParryStop(track)
        elseif track.Name == "SuccessParry" or track.Name == "Success" then
            GrabParryStop(track)
        end
    end
    Grab_Parry = humanoid.Animator:LoadAnimation(animation)
    GrabParryPlay(Grab_Parry)
end

pcall(function()
    ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function()
        Sword_CP = true
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        for _, track in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
            if track.Name == "GrabParry" or track.Name == "Grab" then
                GrabParryStop(track)
            end
        end
    end)
end)

System.ball = {}
function System.ball.get()
    local balls=Workspace:FindFirstChild('Balls'); if not balls then return nil end
    for _,ball in pairs(balls:GetChildren()) do
        if ball:GetAttribute('realBall') then ball.CanCollide=false; return ball end
    end; return nil
end
function System.ball.get_all()
    local balls_table={}; local balls=Workspace:FindFirstChild('Balls')
    if not balls then return balls_table end
    for _,ball in pairs(balls:GetChildren()) do
        if ball:GetAttribute('realBall') then ball.CanCollide=false; table.insert(balls_table,ball) end
    end; return balls_table
end

System.player = {}
local Closest_Entity=nil; local last_closest_check=0
function System.player.get_closest()
    local now=tick()
    if now-last_closest_check < 0.1 then return Closest_Entity end
    last_closest_check=now
    local max_distance=math.huge; local closest_entity=nil
    if not Alive then return nil end
    for _,entity in pairs(Alive:GetChildren()) do
        if entity ~= LocalPlayer.Character and entity.PrimaryPart then
            local distance=LocalPlayer:DistanceFromCharacter(entity.PrimaryPart.Position)
            if distance < max_distance then max_distance=distance; closest_entity=entity end
        end
    end
    Closest_Entity=closest_entity; return closest_entity
end

local CURVE_NAMES = {"Camera","Random","Accelerated","Backwards","Slow","High","Normal","Speed","Down","Left","Right"}
local Selected_Parry_Type = "Camera"
local CurveType = "Camera"

System.curve = {}
function System.curve.get_cframe()
    local Camera = Workspace.CurrentCamera
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local root_pos = root and root.Position or Camera.CFrame.Position

    local targetPart
    do
        local bestDist = math.huge
        local mouseLoc = not System.__properties.__is_mobile and UserInputService:GetMouseLocation() or nil
        if Alive then
            for _, v in pairs(Alive:GetChildren()) do
                if v ~= LocalPlayer.Character and v.PrimaryPart then
                    local screenPos, onScreen = Camera:WorldToScreenPoint(v.PrimaryPart.Position)
                    if onScreen then
                        local dist
                        if mouseLoc then
                            dist = (Vector2.new(screenPos.X, screenPos.Y) - mouseLoc).Magnitude
                        else
                            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        end
                        if dist < bestDist then bestDist = dist; targetPart = v.PrimaryPart end
                    end
                end
            end
        end
    end
    local target_pos = targetPart and targetPart.Position or (root_pos + Camera.CFrame.LookVector * 100)

    local Parry_Type = Selected_Parry_Type
    local cf

    if Parry_Type == "Camera" then
        cf = Camera.CFrame
    elseif Parry_Type == "Random" then
        local direction = (target_pos - root_pos).Unit
        local random_offset
        local attempts = 0
        repeat
            random_offset = Vector3.new(math.random(-4000,4000), math.random(-4000,4000), math.random(-4000,4000))
            local curve_dir = (target_pos + random_offset - root_pos).Unit
            local dot = direction:Dot(curve_dir)
            attempts = attempts + 1
        until dot < 0.95 or attempts > 10
        cf = CFrame.new(root_pos, target_pos + random_offset)
    elseif Parry_Type == "Accelerated" then
        cf = CFrame.new(root_pos, target_pos + Vector3.new(0, 5, 0))
    elseif Parry_Type == "Backwards" then
        local direction = (root_pos - target_pos).Unit
        local backwards_pos = root_pos + direction * 10000 + Vector3.new(0, 1000, 0)
        cf = CFrame.new(Camera.CFrame.Position, backwards_pos)
    elseif Parry_Type == "Slow" then
        cf = CFrame.new(root_pos, target_pos + Vector3.new(0, -9e18, 0))
    elseif Parry_Type == "High" then
        cf = CFrame.new(root_pos, target_pos + Vector3.new(0, 9e18, 0))
    elseif Parry_Type == "Normal" then
        cf = CFrame.new(root_pos, root_pos + (root and root.CFrame.LookVector or Camera.CFrame.LookVector))
    elseif Parry_Type == "Speed" then
        cf = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Camera.CFrame.UpVector * 5)
    elseif Parry_Type == "Down" then
        cf = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Camera.CFrame.UpVector * -9e9)
    elseif Parry_Type == "Left" then
        cf = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position - Camera.CFrame.RightVector * 9e9)
    elseif Parry_Type == "Right" then
        cf = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Camera.CFrame.RightVector * 9e9)
    else
        cf = Camera.CFrame
    end

    return cf
end

System.parry = {}
function System.parry.execute()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end
    fireParryRemote(System.curve.get_cframe())
    if System.__properties.__parries > 10000 then return end
    System.__properties.__parries=System.__properties.__parries+1
    task.delay(0.5,function() if System.__properties.__parries > 0 then System.__properties.__parries=System.__properties.__parries-1 end end)
end

function System.parry.keypress()
    if System.__properties.__parries > 10000 or not LocalPlayer.Character then return end
    fireParryRemote(System.curve.get_cframe())
    if System.__properties.__parries > 10000 then return end
    System.__properties.__parries=System.__properties.__parries+1
    task.delay(0.5,function() if System.__properties.__parries > 0 then System.__properties.__parries=System.__properties.__parries-1 end end)
end

function System.parry.execute_action()
    System.animation.play_grab_parry(); System.parry.execute()
end

local function linear_predict(a,b,t) return a+(b-a)*t end

System.detection = {
    __ball_properties = {__aerodynamic_time=tick(),__last_warping=tick(),__lerp_radians=0,__curving=tick()}
}

function System.detection.is_curved()
    local props=System.detection.__ball_properties
    local ball=System.ball.get(); if not ball then return false end
    local zoomies=ball:FindFirstChild("zoomies"); if not zoomies then return false end
    local velocity=zoomies.VectorVelocity; local speed=velocity.Magnitude
    if speed < 1 then return false end
    local ball_dir=velocity.Unit; local char=LocalPlayer.Character
    if not char or not char.PrimaryPart then return false end
    local pos=char.PrimaryPart.Position; local direction=(pos-ball.Position).Unit
    local dot=direction:Dot(ball_dir)
    local ping=Stats.Network.ServerStatsItem["Data Ping"]:GetValue()/1000
    local distance=(pos-ball.Position).Magnitude; local reach_time=distance/speed-ping
    local dot_threshold=math.clamp(0.55-(ping*0.75),-1,0.45)
    local speed_threshold=math.min(speed/100,45)
    local ball_distance_threshold=15-math.min(distance/1000,15)+speed_threshold
    local clamped_dot=math.clamp(dot,-1,1); local radians=math.asin(clamped_dot)
    props.__lerp_radians=linear_predict(props.__lerp_radians,radians,0.85)
    if props.__lerp_radians < 0.016 then props.__last_warping=tick() end
    if distance < (ball_distance_threshold*0.85) then return false end
    if (tick()-props.__last_warping) < (reach_time/1.4) then return true end
    if (tick()-props.__curving) < (reach_time/1.1) then return true end
    return dot < dot_threshold
end

ReplicatedStorage.Remotes.DeathBall.OnClientEvent:Connect(function(c,d)
    System.__properties.__deathslash_active = d or false
end)
ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(a,b)
    System.__properties.__infinity_active = b or false
end)

ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/TimeHoleActivate"].OnClientEvent:Connect(function(...)
    local args={...}; local player=args[1]
    if player==LocalPlayer or player==LocalPlayer.Name or (player and player.Name==LocalPlayer.Name) then
        System.__properties.__timehole_active=true
    end
end)
ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/TimeHoleDeactivate"].OnClientEvent:Connect(function()
    System.__properties.__timehole_active=false
end)

local maxParryCount=36; local parryDelay=0.05

ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryActivate"].OnClientEvent:Connect(function(...)
    local args={...}; local player=args[1]
    if player==LocalPlayer or player==LocalPlayer.Name or (player and player.Name==LocalPlayer.Name) then
        System.__properties.__slashesoffury_active=true; System.__properties.__slashesoffury_count=0
    end
end)
ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryEnd"].OnClientEvent:Connect(function()
    System.__properties.__slashesoffury_active=false; System.__properties.__slashesoffury_count=0
end)
ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryParry"].OnClientEvent:Connect(function()
    System.__properties.__slashesoffury_count=System.__properties.__slashesoffury_count+1
end)
ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net["RE/SlashesOfFuryCatch"].OnClientEvent:Connect(function()
    spawn(function()
        while System.__properties.__slashesoffury_active and System.__properties.__slashesoffury_count < maxParryCount do
            if System.__config.__detections.__slashesoffury then System.parry.execute(); task.wait(parryDelay)
            else break end
        end
    end)
end)

Runtime.ChildAdded:Connect(function(Object)
    if System.__config.__detections.__phantom then
        if Object.Name=="maxTransmission" or Object.Name=="transmissionpart" then
            local Weld=Object:FindFirstChildWhichIsA("WeldConstraint")
            if Weld then
                local Character=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                if Character and Weld.Part1==Character.HumanoidRootPart then
                    local CurrentBall=System.ball.get(); Weld:Destroy()
                    if CurrentBall then
                        local FocusConnection
                        FocusConnection=RunService.RenderStepped:Connect(function()
                            local Highlighted=CurrentBall:GetAttribute("highlighted")
                            if Highlighted==true then
                                ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                                System.__properties.__parried=true
                                task.delay(1,function() System.__properties.__parried=false end)
                            elseif Highlighted==false then FocusConnection:Disconnect() end
                        end)
                        task.delay(3,function() if FocusConnection and FocusConnection.Connected then FocusConnection:Disconnect() end end)
                    end
                end
            end
        end
    end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_,root)
    if root.Parent and root.Parent ~= LocalPlayer.Character then
        if not Alive or root.Parent.Parent ~= Alive then return end
    end
    local closest=System.player.get_closest(); local ball=System.ball.get()
    if not ball or not closest then return end
    local target_distance=(LocalPlayer.Character.PrimaryPart.Position-closest.PrimaryPart.Position).Magnitude
    local distance=(LocalPlayer.Character.PrimaryPart.Position-ball.Position).Magnitude
    local direction=(LocalPlayer.Character.PrimaryPart.Position-ball.Position).Unit
    local dot=direction:Dot(ball.AssemblyLinearVelocity.Unit)
    local curve_detected=System.detection.is_curved()
    if target_distance < 15 and distance < 15 and dot > -0.25 then
        if curve_detected then System.parry.execute_action() end
    end
    if System.__properties.__grab_animation then System.__properties.__grab_animation:Stop() end
end)

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if not Alive or LocalPlayer.Character.Parent ~= Alive then return end
    if System.__properties.__grab_animation then System.__properties.__grab_animation:Stop() end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(a,b)
    local Primary_Part=LocalPlayer.Character.PrimaryPart
    local Ball=System.ball.get(); if not Ball then return end
    local Zoomies=Ball:FindFirstChild('zoomies'); if not Zoomies then return end
    local Speed=Zoomies.VectorVelocity.Magnitude
    local Distance=(LocalPlayer.Character.PrimaryPart.Position-Ball.Position).Magnitude
    local Velocity=Zoomies.VectorVelocity; local Ball_Direction=Velocity.Unit
    local Direction=(LocalPlayer.Character.PrimaryPart.Position-Ball.Position).Unit
    local Dot=Direction:Dot(Ball_Direction)
    local Pings=Stats.Network.ServerStatsItem['Data Ping']:GetValue()
    local Speed_Threshold=math.min(Speed/100,40)
    local Reach_Time=Distance/Speed-(Pings/1000)
    local Enough_Speed=Speed > 1
    local Ball_Distance_Threshold=15-math.min(Distance/1000,15)+Speed_Threshold
    if Enough_Speed and Reach_Time > Pings/10 then
        Ball_Distance_Threshold=math.max(Ball_Distance_Threshold-15,15)
    end
    if b ~= Primary_Part and Distance > Ball_Distance_Threshold then
        System.detection.__ball_properties.__curving=tick()
    end
end)

System.triggerbot = {}
local triggerbotCooldown = false

function System.triggerbot.trigger(ball)
    if triggerbotCooldown then return end
    if System.__triggerbot.__is_parrying then return end
    if System.__triggerbot.__parries > System.__triggerbot.__max_parries then return end
    if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and
       LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape') then return end

    triggerbotCooldown = true
    System.__triggerbot.__is_parrying=true
    System.__triggerbot.__parries=System.__triggerbot.__parries+1

    System.parry.execute()

    if System.__properties.__play_animation then
        System.animation.play_grab_parry()
    end

    task.delay(0.2,function()
        triggerbotCooldown = false
        if System.__triggerbot.__parries > 0 then
            System.__triggerbot.__parries=System.__triggerbot.__parries-1
        end
    end)

    task.spawn(function()
        local start_time=tick()
        repeat RunService.Heartbeat:Wait()
        until (tick()-start_time >= 0.15 or not System.__triggerbot.__is_parrying)
        System.__triggerbot.__is_parrying=false
    end)
end

function System.triggerbot.loop()
    if not System.__triggerbot.__enabled then return end
    if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and
       LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape') then return end
    local balls=Workspace:FindFirstChild('Balls'); if not balls then return end
    for _,ball in pairs(balls:GetChildren()) do
        if ball:IsA('BasePart') and ball:GetAttribute('target')==LocalPlayer.Name then
            System.triggerbot.trigger(ball)
            break
        end
    end
end

function System.triggerbot.enable(enabled)
    System.__triggerbot.__enabled=enabled
    if enabled then
        if not System.__properties.__connections.__triggerbot then
            System.__properties.__connections.__triggerbot=RunService.Heartbeat:Connect(System.triggerbot.loop)
        end
    else
        if System.__properties.__connections.__triggerbot then
            System.__properties.__connections.__triggerbot:Disconnect()
            System.__properties.__connections.__triggerbot=nil
        end
        System.__triggerbot.__is_parrying=false
        System.__triggerbot.__parries=0
        triggerbotCooldown = false
    end
end

System.manual_spam = {}
local manualSpamThread=nil
local macroSpamActive=false
local macroFrameFireCount=0; local macroFrameTime=0; local macroRealCPS=0; local macroAnimFix=true

function System.manual_spam.start()
    System.manual_spam.stop()
    System.__properties.__manual_spam_enabled=true; macroSpamActive=true
    local parry_keypress=System.parry.keypress; local parry_execute=System.parry.execute
    local play_animation=System.animation.play_grab_parry; local threshold=0.015
    manualSpamThread=coroutine.create(function()
        local last_spam=0
        while System.__properties.__manual_spam_enabled do
            local now=os.clock()
            if now-last_spam >= threshold then
                last_spam=now
                if getgenv().ManualSpamMode=="Keypress" then parry_keypress()
                else parry_execute(); if getgenv().ManualSpamAnimationFix then play_animation() end end
            end
            coroutine.yield()
        end
    end)
    task.spawn(function()
        while System.__properties.__manual_spam_enabled and manualSpamThread
              and coroutine.status(manualSpamThread) ~= "dead" do
            coroutine.resume(manualSpamThread); task.wait()
        end
    end)
end

function System.manual_spam.stop()
    System.__properties.__manual_spam_enabled=false; macroSpamActive=false; manualSpamThread=nil
end

RunService.Heartbeat:Connect(function(dt)
    macroFrameTime=macroFrameTime+dt
    if macroFrameTime >= 0.1 then
        if macroSpamActive then macroRealCPS=math.floor(macroFrameFireCount/macroFrameTime) end
        macroFrameFireCount=0; macroFrameTime=0
    end
    if macroSpamActive and _capturedRemote then
        pcall(function() fireParryRemote(System.curve.get_cframe()); macroFrameFireCount=macroFrameFireCount+1 end)
        if macroAnimFix then System.animation.play_grab_parry() end
    end
end)

System.auto_spam = {}

function System.auto_spam:get_entity_properties()
    System.player.get_closest()
    if not Closest_Entity or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart or not Closest_Entity.PrimaryPart then return false end
    local entity_velocity = Closest_Entity.PrimaryPart.AssemblyLinearVelocity
    local entity_direction = (LocalPlayer.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Unit
    local entity_distance = (LocalPlayer.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
    return {Velocity = entity_velocity, Direction = entity_direction, Distance = entity_distance}
end

function System.auto_spam:get_ball_properties()
    local ball = System.ball.get()
    if not ball or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return false end
    local ball_velocity = ball.AssemblyLinearVelocity
    local ball_direction = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local ball_distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local ball_dot = ball_velocity.Magnitude > 0 and ball_direction:Dot(ball_velocity.Unit) or 0
    return {Velocity = ball_velocity, Direction = ball_direction, Distance = ball_distance, Dot = ball_dot}
end

function System.auto_spam.spam_service(self)
    local ball = System.ball.get()
    local entity = System.player.get_closest()
    if not ball or not entity or not entity.PrimaryPart or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return 0 end
    local velocity = ball.AssemblyLinearVelocity
    local speed = velocity.Magnitude
    local direction = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local dot = speed > 0 and direction:Dot(velocity.Unit) or 0
    local target_distance = LocalPlayer:DistanceFromCharacter(entity.PrimaryPart.Position)
    local maximum_spam_distance = self.Ping + math.min(speed / 6, 255)
    if self.Entity_Properties.Distance > maximum_spam_distance or self.Ball_Properties.Distance > maximum_spam_distance or target_distance > maximum_spam_distance then return 0 end
    local maximum_speed = 5 - math.min(speed / 5, 5)
    local maximum_dot = math.clamp(dot, -1, 0) * maximum_speed
    return maximum_spam_distance - maximum_dot
end

function System.auto_spam.start()
    if System.__properties.__connections.__auto_spam then
        System.__properties.__connections.__auto_spam:Disconnect()
    end
    System.__properties.__auto_spam_enabled = true
    System.__properties.__connections.__auto_spam = RunService.PreSimulation:Connect(function()
        if not System.__properties.__auto_spam_enabled then return end
        local ball = System.ball.get()
        if not ball or System.__properties.__slashesoffury_active then return end
        local zoomies = ball:FindFirstChild("zoomies")
        if not zoomies then return end
        System.player.get_closest()
        local ball_properties = System.auto_spam:get_ball_properties()
        local entity_properties = System.auto_spam:get_entity_properties()
        if not ball_properties or not entity_properties or not Closest_Entity or not Closest_Entity.PrimaryPart then return end
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        local ping_threshold = math.clamp(ping / 10, 1, 16)
        local spam_accuracy = System.auto_spam.spam_service({
            Ball_Properties = ball_properties,
            Entity_Properties = entity_properties,
            Ping = ping_threshold
        })
        local target_distance = LocalPlayer:DistanceFromCharacter(Closest_Entity.PrimaryPart.Position)
        local direction = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
        local ball_direction = zoomies.VectorVelocity.Magnitude > 0 and zoomies.VectorVelocity.Unit or Vector3.zero
        local dot = ball_direction.Magnitude > 0 and direction:Dot(ball_direction) or 0
        local distance = LocalPlayer:DistanceFromCharacter(ball.Position)
        local ball_target = ball:GetAttribute("target")
        if not ball_target or target_distance > spam_accuracy or distance > spam_accuracy then return end
        if LocalPlayer.Character:GetAttribute("Pulsed") then return end
        if ball_target == LocalPlayer.Name and target_distance > 30 and distance > 30 then return end
        if distance <= spam_accuracy and System.__properties.__parries > System.__properties.__spam_threshold then
            if getgenv().AutoSpamMode == "Keypress" then
                if PF then PF() end
            else
                System.parry.execute()
                if getgenv().AutoSpamAnimationFix and PF then PF() end
            end
        end
    end)
end

function System.auto_spam.stop()
    System.__properties.__auto_spam_enabled = false
    if System.__properties.__connections.__auto_spam then
        System.__properties.__connections.__auto_spam:Disconnect()
        System.__properties.__connections.__auto_spam = nil
    end
end

System.autoparry = {}
function System.autoparry.start()
    if System.__properties.__connections.__autoparry then
        System.__properties.__connections.__autoparry:Disconnect()
    end
    System.__properties.__connections.__autoparry=RunService.PreSimulation:Connect(function()
        if not System.__properties.__autoparry_enabled or not LocalPlayer.Character or
           not LocalPlayer.Character.PrimaryPart then return end
        local balls=System.ball.get_all(); local one_ball=System.ball.get()
        local training_ball=nil
        if Workspace:FindFirstChild("TrainingBalls") then
            for _,Instance in pairs(Workspace.TrainingBalls:GetChildren()) do
                if Instance:GetAttribute("realBall") then training_ball=Instance; break end
            end
        end
        for _,ball in pairs(balls) do
            if System.__triggerbot.__enabled then return end
            if getgenv().BallVelocityAbove800 then return end
            if not ball then continue end
            local zoomies=ball:FindFirstChild('zoomies'); if not zoomies then continue end
            ball:GetAttributeChangedSignal('target'):Once(function() System.__properties.__parried=false end)
            if System.__properties.__parried then continue end
            local ball_target=ball:GetAttribute('target')
            local velocity=zoomies.VectorVelocity
            local distance=(LocalPlayer.Character.PrimaryPart.Position-ball.Position).Magnitude
            local ping=Stats.Network.ServerStatsItem['Data Ping']:GetValue()/10
            local ping_threshold=math.clamp(ping/10,5,17); local speed=velocity.Magnitude
            local capped_speed_diff=math.min(math.max(speed-9.5,0),650)
            local speed_divisor=(2.4+capped_speed_diff*0.002)*System.__properties.__divisor_multiplier
            local parry_accuracy=ping_threshold+math.max(speed/speed_divisor,9.5)
            local curved=System.detection.is_curved()
            if ball:FindFirstChild('AeroDynamicSlashVFX') then
                ball.AeroDynamicSlashVFX:Destroy(); System.__properties.__tornado_time=tick()
            end
            if Runtime:FindFirstChild('Tornado') then
                if (tick()-System.__properties.__tornado_time) <
                   (Runtime.Tornado:GetAttribute('TornadoTime') or 1)+0.314159 then continue end
            end
            if one_ball and one_ball:GetAttribute('target')==LocalPlayer.Name and curved then continue end
            if ball:FindFirstChild('ComboCounter') then continue end
            if LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape') then continue end
            if System.__config.__detections.__infinity and System.__properties.__infinity_active then continue end
            if System.__config.__detections.__deathslash and System.__properties.__deathslash_active then continue end
            if System.__config.__detections.__timehole and System.__properties.__timehole_active then continue end
            if System.__config.__detections.__slashesoffury and System.__properties.__slashesoffury_active then continue end
            if ball_target==LocalPlayer.Name and distance <= parry_accuracy then
                if getgenv().AutoAbility then
                    local AbilityCD=LocalPlayer.PlayerGui.Hotbar.Ability.UIGradient
                    if AbilityCD and AbilityCD.Offset.Y==0.5 then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Abilities") then
                            local abilities=LocalPlayer.Character.Abilities
                            if (abilities:FindFirstChild("Raging Deflection") and abilities["Raging Deflection"].Enabled) or
                               (abilities:FindFirstChild("Rapture") and abilities["Rapture"].Enabled) or
                               (abilities:FindFirstChild("Calming Deflection") and abilities["Calming Deflection"].Enabled) or
                               (abilities:FindFirstChild("Aerodynamic Slash") and abilities["Aerodynamic Slash"].Enabled) or
                               (abilities:FindFirstChild("Fracture") and abilities["Fracture"].Enabled) or
                               (abilities:FindFirstChild("Death Slash") and abilities["Death Slash"].Enabled) then
                                System.__properties.__parried=true
                                ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                                task.wait(2.432)
                                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DeathSlashShootActivation"):FireServer(true)
                                continue
                            end
                        end
                    end
                end
            end
            if ball_target==LocalPlayer.Name and distance <= parry_accuracy then
                if getgenv().AutoParryMode=="Keypress" then System.parry.keypress()
                else System.parry.execute_action() end
                System.__properties.__parried=true
            end
            local last_parrys=tick()
            repeat RunService.Stepped:Wait()
            until (tick()-last_parrys) >= 1 or not System.__properties.__parried
            System.__properties.__parried=false
        end
        if training_ball then
            local zoomies=training_ball:FindFirstChild('zoomies')
            if zoomies then
                training_ball:GetAttributeChangedSignal('target'):Once(function() System.__properties.__training_parried=false end)
                if not System.__properties.__training_parried then
                    local ball_target=training_ball:GetAttribute('target')
                    local velocity=zoomies.VectorVelocity
                    local distance=LocalPlayer:DistanceFromCharacter(training_ball.Position)
                    local speed=velocity.Magnitude
                    local ping=Stats.Network.ServerStatsItem['Data Ping']:GetValue()/10
                    local ping_threshold=math.clamp(ping/10,5,17)
                    local capped_speed_diff=math.min(math.max(speed-9.5,0),650)
                    local speed_divisor=(2.4+capped_speed_diff*0.002)*System.__properties.__divisor_multiplier
                    local parry_accuracy=ping_threshold+math.max(speed/speed_divisor,9.5)
                    if ball_target==LocalPlayer.Name and distance <= parry_accuracy then
                        if getgenv().AutoParryMode=="Keypress" then System.parry.keypress()
                        else System.parry.execute_action() end
                        System.__properties.__training_parried=true
                        local last_parrys=tick()
                        repeat RunService.Stepped:Wait()
                        until (tick()-last_parrys) >= 1 or not System.__properties.__training_parried
                        System.__properties.__training_parried=false
                    end
                end
            end
        end
    end)
end

function System.autoparry.stop()
    if System.__properties.__connections.__autoparry then
        System.__properties.__connections.__autoparry:Disconnect()
        System.__properties.__connections.__autoparry=nil
    end
end

local ManualSpamGui = nil
local ManualSpamConnections = {}
local TriggerGui = nil
local TriggerConnections = {}
local CurveGui = nil
local CurveConnections = {}
local KeyboardGui = nil
local KeyboardConnections = {}
local KeyboardKeyConnections = {}
local KeyboardCapture = nil
local KeyboardCaptureConsumed = false

local KeyboardSettings = {
    AutoParry = Enum.KeyCode.T,
    AutoSpam = Enum.KeyCode.V,
    ManualSpam = Enum.KeyCode.F,
    ManualSpamMode = "Hold to Spam"
}

local function keyName(keyCode)
    return keyCode == Enum.KeyCode.Unknown and "None" or keyCode.Name
end

local function isKeyboardInput(input)
    return input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode ~= Enum.KeyCode.Unknown
end

local function stopManualKeyboardSpam()
    if KeyboardSettings.ManualSpamMode == "Hold to Spam" and System.__properties.__manual_spam_enabled then
        _G.manualSpamEnabled = false
        if _G.KittyLol then _G.KittyLol.manualSpamEnabled = false end
        System.manual_spam.stop()
        macroSpamActive = false
    end
end

local function toggleManualKeyboardSpam()
    local state = not System.__properties.__manual_spam_enabled
    _G.manualSpamEnabled = state
    _G.KittyLol = _G.KittyLol or {}
    _G.KittyLol.manualSpamEnabled = state
    System.__properties.__manual_spam_enabled = state
    macroSpamActive = state
    if state then
        System.manual_spam.start()
    else
        System.manual_spam.stop()
    end
end

local function SetKeyboardKey(name, keyCode)
    KeyboardSettings[name] = keyCode
end

local DisconnectConnections

local function CreateKeyboardUI()
    if KeyboardGui and KeyboardGui.Parent then
        KeyboardGui.Enabled = true
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "Kittylol_KeyboardUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui
    KeyboardGui = gui

    local Main = Instance.new("Frame")
    Main.Name = "Keyboard"
    Main.Size = UDim2.fromOffset(260, 126)
    Main.Position = UDim2.new(0.5, -130, 0.5, -63)
    Main.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.ZIndex = 2500
    Main.Parent = gui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 13)
    Corner.Parent = Main

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.5
    Stroke.Color = Color3.fromRGB(70, 70, 70)
    Stroke.Transparency = 0.25
    Stroke.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 32)
    Title.Position = UDim2.fromOffset(10, 5)
    Title.BackgroundTransparency = 1
    Title.Text = "Keyboard"
    Title.TextColor3 = Color3.fromRGB(245, 245, 245)
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.ZIndex = 2502
    Title.Parent = Main

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.Position = UDim2.fromOffset(0, 40)
    Divider.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    Divider.BorderSizePixel = 0
    Divider.ZIndex = 2501
    Divider.Parent = Main

    local Rows = Instance.new("Frame")
    Rows.Size = UDim2.new(1, -20, 0, 76)
    Rows.Position = UDim2.fromOffset(10, 47)
    Rows.BackgroundTransparency = 1
    Rows.ZIndex = 2502
    Rows.Parent = Main

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Parent = Rows

    local modeOpen = false
    local modePanel = Instance.new("Frame")
    modePanel.Size = UDim2.new(1, -20, 0, 46)
    modePanel.Position = UDim2.fromOffset(10, 123)
    modePanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    modePanel.BorderSizePixel = 0
    modePanel.Visible = false
    modePanel.ZIndex = 2510
    modePanel.Parent = Main

    local modeCorner = Instance.new("UICorner")
    modeCorner.CornerRadius = UDim.new(0, 9)
    modeCorner.Parent = modePanel

    local modeStroke = Instance.new("UIStroke")
    modeStroke.Thickness = 1
    modeStroke.Color = Color3.fromRGB(55, 55, 55)
    modeStroke.Parent = modePanel

    local function makeButton(parent, textValue, widthScale, xScale)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(widthScale, -4, 1, 0)
        button.Position = UDim2.new(xScale, 2, 0, 0)
        button.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        button.BorderSizePixel = 0
        button.Text = textValue
        button.TextColor3 = Color3.fromRGB(245, 245, 245)
        button.TextSize = 12
        button.Font = Enum.Font.GothamSemibold
        button.AutoButtonColor = false
        button.ZIndex = 2512
        button.Parent = parent
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 7)
        c.Parent = button
        local st = Instance.new("UIStroke")
        st.Thickness = 1
        st.Color = Color3.fromRGB(55, 55, 55)
        st.Parent = button
        return button
    end

    local function makeRow(label, settingName)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 22)
        row.BackgroundTransparency = 1
        row.ZIndex = 2503
        row.Parent = Rows

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(0.58, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = label
        text.TextColor3 = Color3.fromRGB(230, 230, 230)
        text.TextSize = 13
        text.Font = Enum.Font.GothamMedium
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.ZIndex = 2504
        text.Parent = row

        local button = makeButton(row, keyName(KeyboardSettings[settingName]), 0.42, 0.58)
        return button
    end

    local autoParryButton = makeRow("Auto Parry", "AutoParry")
    local autoSpamButton = makeRow("Auto Spam", "AutoSpam")

    local manualRow = Instance.new("Frame")
    manualRow.Size = UDim2.new(1, 0, 0, 22)
    manualRow.BackgroundTransparency = 1
    manualRow.ZIndex = 2503
    manualRow.Parent = Rows

    local manualText = Instance.new("TextLabel")
    manualText.Size = UDim2.new(0.34, 0, 1, 0)
    manualText.BackgroundTransparency = 1
    manualText.Text = "Manual Spam"
    manualText.TextColor3 = Color3.fromRGB(230, 230, 230)
    manualText.TextSize = 13
    manualText.Font = Enum.Font.GothamMedium
    manualText.TextXAlignment = Enum.TextXAlignment.Left
    manualText.ZIndex = 2504
    manualText.Parent = manualRow

    local manualKeyButton = makeButton(manualRow, keyName(KeyboardSettings.ManualSpam), 0.28, 0.34)
    local manualModeButton = makeButton(manualRow, KeyboardSettings.ManualSpamMode, 0.38, 0.62)

    local function animateMode(open)
        modeOpen = open
        if open then
            modePanel.Visible = true
            modePanel.Size = UDim2.new(1, -20, 0, 0)
            modePanel.Position = UDim2.fromOffset(10, 123)
            TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(260, 180)
            }):Play()
            TweenService:Create(modePanel, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -20, 0, 46)
            }):Play()
        else
            local tween = TweenService:Create(modePanel, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Size = UDim2.new(1, -20, 0, 0)
            })
            tween:Play()
            TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Size = UDim2.fromOffset(260, 126)
            }):Play()
            tween.Completed:Connect(function()
                if not modeOpen then modePanel.Visible = false end
            end)
        end
    end

    local holdOption = makeButton(modePanel, "Hold to Spam", 0.5, 0)
    local onceOption = makeButton(modePanel, "Press Once to Spam", 0.5, 0.5)

    local function selectMode(mode)
        KeyboardSettings.ManualSpamMode = mode
        manualModeButton.Text = mode
        animateMode(false)
    end

    manualModeButton.MouseButton1Click:Connect(function()
        animateMode(not modeOpen)
    end)
    holdOption.MouseButton1Click:Connect(function()
        selectMode("Hold to Spam")
    end)
    onceOption.MouseButton1Click:Connect(function()
        selectMode("Press Once to Spam")
    end)

    local function beginKeyCapture(settingName, button)
        if KeyboardCapture then return end
        KeyboardCapture = settingName
        button.Text = "Press a key..."
        task.spawn(function()
            local timeout = os.clock() + 8
            while KeyboardCapture == settingName and os.clock() < timeout do
                task.wait()
            end
            if KeyboardCapture == settingName then
                KeyboardCapture = nil
                button.Text = keyName(KeyboardSettings[settingName])
            end
        end)
    end

    autoParryButton.MouseButton1Click:Connect(function()
        beginKeyCapture("AutoParry", autoParryButton)
    end)
    autoSpamButton.MouseButton1Click:Connect(function()
        beginKeyCapture("AutoSpam", autoSpamButton)
    end)
    manualKeyButton.MouseButton1Click:Connect(function()
        beginKeyCapture("ManualSpam", manualKeyButton)
    end)

    KeyboardConnections.capture = UserInputService.InputBegan:Connect(function(input, processed)
        if not isKeyboardInput(input) then return end
        if KeyboardCapture then
            local name = KeyboardCapture
            KeyboardCapture = nil
            KeyboardCaptureConsumed = true
            SetKeyboardKey(name, input.KeyCode)
            local button = name == "AutoParry" and autoParryButton or name == "AutoSpam" and autoSpamButton or manualKeyButton
            button.Text = keyName(input.KeyCode)
            return
        end
    end)

    KeyboardConnections.inputBegan = UserInputService.InputBegan:Connect(function(input, processed)
        if KeyboardCaptureConsumed then
            KeyboardCaptureConsumed = false
            return
        end
        if processed or not isKeyboardInput(input) or KeyboardCapture then return end
        if input.KeyCode == KeyboardSettings.AutoParry then
            local state = not System.__properties.__autoparry_enabled
            System.__properties.__autoparry_enabled = state
            System.__properties.__play_animation = state
            if state then System.autoparry.start() else System.autoparry.stop() end
        elseif input.KeyCode == KeyboardSettings.AutoSpam then
            local state = not System.__properties.__auto_spam_enabled
            System.__properties.__auto_spam_enabled = state
            if state then System.auto_spam.start() else System.auto_spam.stop() end
        elseif input.KeyCode == KeyboardSettings.ManualSpam then
            if KeyboardSettings.ManualSpamMode == "Press Once to Spam" then
                toggleManualKeyboardSpam()
            else
                if not System.__properties.__manual_spam_enabled then
                    _G.manualSpamEnabled = true
                    _G.KittyLol = _G.KittyLol or {}
                    _G.KittyLol.manualSpamEnabled = true
                    System.manual_spam.start()
                end
            end
        end
    end)

    KeyboardConnections.inputEnded = UserInputService.InputEnded:Connect(function(input)
        if not isKeyboardInput(input) or KeyboardCapture then return end
        if input.KeyCode == KeyboardSettings.ManualSpam and KeyboardSettings.ManualSpamMode == "Hold to Spam" then
            stopManualKeyboardSpam()
        end
    end)

    local dragging = false
    local dragStart
    local startPos
    KeyboardConnections.dragBegan = Main.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end)
    KeyboardConnections.dragChanged = UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end)
    KeyboardConnections.dragEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function DestroyKeyboardUI()
    KeyboardCapture = nil
    DisconnectConnections(KeyboardConnections)
    if KeyboardGui then
        KeyboardGui:Destroy()
        KeyboardGui = nil
    end
end

DisconnectConnections = function(tbl)
    for _, connection in pairs(tbl) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(tbl)
end

local function CreateSmallActionUI(kind)
    local isTrigger = (kind == "Trigger")
    local existing = isTrigger and TriggerGui or ManualSpamGui
    local connections = isTrigger and TriggerConnections or ManualSpamConnections

    if existing and existing.Parent then
        existing.Enabled = true
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = isTrigger and "Kittylol_TriggerUI" or "Kittylol_SpamUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui

    if isTrigger then
        TriggerGui = gui
    else
        ManualSpamGui = gui
        _G.manualSpamEnabled = false
        _G.KittyLol = _G.KittyLol or {}
        _G.KittyLol.manualSpamEnabled = false
    end

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(180, 60)
    Main.Position = UDim2.new(0.5, -90, 0.5, -30)
    Main.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.ZIndex = 999
    Main.Parent = gui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 13)
    UICorner.Parent = Main

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Transparency = 0.35
    Stroke.Parent = Main

    local Gradient = Instance.new("UIGradient")
    Gradient.Rotation = 90
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(170, 170, 170)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(60, 60, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
    })
    Gradient.Parent = Main

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = isTrigger and "TRIGGER" or "SPAM"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 18
    Button.Font = Enum.Font.GothamBold
    Button.AutoButtonColor = false
    Button.ZIndex = 1000
    Button.Parent = Main

    local dragging = false
    local dragStart
    local startPos
    local dragThreshold = 6
    local dragInput = nil
    local dragCandidate = false

    local function isOnBorder(inputPosition)
        local absolutePosition = Main.AbsolutePosition
        local absoluteSize = Main.AbsoluteSize
        local x = inputPosition.X - absolutePosition.X
        local y = inputPosition.Y - absolutePosition.Y
        local border = 10
        return x >= 0 and x <= absoluteSize.X
            and y >= 0 and y <= absoluteSize.Y
            and (x <= border or x >= absoluteSize.X - border
                or y <= border or y >= absoluteSize.Y - border)
    end

    if isTrigger then
        connections.button = Button.MouseButton1Click:Connect(function()
            local state = not System.__properties.__triggerbot_enabled
            System.__properties.__triggerbot_enabled = state
            System.triggerbot.enable(state)
            Button.Text = state and "OFF" or "TRIGGER"
            Notify("Trigger", state and "ON" or "OFF", 2)
        end)
    else
        connections.button = Button.MouseButton1Click:Connect(function()
            local state = not _G.manualSpamEnabled
            _G.manualSpamEnabled = state
            _G.KittyLol.manualSpamEnabled = state
            System.__properties.__manual_spam_enabled = state
            macroSpamActive = state
            if state then
                System.manual_spam.start()
                Button.Text = "OFF"
                Notify("Manual Spam", "ON", 2)
            else
                System.manual_spam.stop()
                Button.Text = "SPAM"
                Notify("Manual Spam", "OFF", 2)
            end
        end)
    end

    connections.inputBegan = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not isOnBorder(input.Position) then
            dragCandidate = false
            return
        end
        dragCandidate = true
        dragging = false
        dragInput = input
        dragStart = input.Position
        startPos = Main.Position
    end)

    connections.inputChanged = UserInputService.InputChanged:Connect(function(input)
        if not dragCandidate then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        if not dragging then
            if math.abs(delta.X) < dragThreshold and math.abs(delta.Y) < dragThreshold then return end
            dragging = true
        end
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end)

    connections.inputEnded = UserInputService.InputEnded:Connect(function(input)
        if input == dragInput
            or input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            dragCandidate = false
            dragInput = nil
        end
    end)
end


local function CreateCurveUI()
    if CurveGui and CurveGui.Parent then
        CurveGui.Enabled = true
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "Kittylol_CurveUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui
    CurveGui = gui

    local Main = Instance.new("Frame")
    Main.Name = "CurveUI"
    Main.AnchorPoint = Vector2.new(0.5, 0)
    Main.Size = UDim2.fromOffset(118, 42)
    Main.Position = UDim2.new(0.5, 0, 0, 16)
    Main.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
    Main.BackgroundTransparency = 0.04
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Active = true
    Main.ZIndex = 2000
    Main.Parent = gui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 14)
    Corner.Parent = Main

    local Gradient = Instance.new("UIGradient")
    Gradient.Rotation = 0
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(155, 155, 155)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    })
    Gradient.Parent = Main

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.5
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Transparency = 0.3
    Stroke.Parent = Main

    local Header = Instance.new("TextButton")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, -10, 0, 42)
    Header.Position = UDim2.fromOffset(5, 0)
    Header.BackgroundTransparency = 1
    Header.Text = tostring(Selected_Parry_Type or "Camera")
    Header.TextColor3 = Color3.fromRGB(255, 255, 255)
    Header.TextSize = 14
    Header.Font = Enum.Font.GothamBold
    Header.AutoButtonColor = false
    Header.ZIndex = 2002
    Header.Parent = Main

    local OptionsHolder = Instance.new("Frame")
    OptionsHolder.Name = "Options"
    OptionsHolder.Position = UDim2.fromOffset(8, 50)
    OptionsHolder.Size = UDim2.new(1, -16, 1, -58)
    OptionsHolder.BackgroundTransparency = 1
    OptionsHolder.Visible = false
    OptionsHolder.ZIndex = 2002
    OptionsHolder.Parent = Main

    local Grid = Instance.new("UIGridLayout")
    Grid.CellSize = UDim2.fromOffset(136, 29)
    Grid.CellPadding = UDim2.fromOffset(8, 5)
    Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Grid.VerticalAlignment = Enum.VerticalAlignment.Top
    Grid.Parent = OptionsHolder

    local expanded = false
    local current = Selected_Parry_Type or "Camera"
    local CLOSED_WIDTH = 118
    local OPEN_WIDTH = 296
    local OPEN_HEIGHT = 268

    local function setHeader()
        Header.Text = tostring(current)
    end

    local function closeUI()
        expanded = false
        OptionsHolder.Visible = false
        local heightTween = TweenService:Create(Main, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(OPEN_WIDTH, 42)
        })
        heightTween:Play()
        heightTween.Completed:Wait()
        TweenService:Create(Main, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(CLOSED_WIDTH, 42)
        }):Play()
    end

    local function setSelected(value)
        current = value
        Selected_Parry_Type = value
        CurveType = value
        setHeader()
        closeUI()
    end

    for _, name in ipairs(CURVE_NAMES) do
        local Option = Instance.new("TextButton")
        Option.Name = name
        Option.Size = UDim2.fromOffset(136, 29)
        Option.BackgroundColor3 = Color3.fromRGB(115, 115, 115)
        Option.BackgroundTransparency = 0.18
        Option.BorderSizePixel = 0
        Option.Text = name
        Option.TextColor3 = Color3.fromRGB(255, 255, 255)
        Option.TextSize = 12
        Option.Font = Enum.Font.GothamSemibold
        Option.AutoButtonColor = false
        Option.ZIndex = 2003
        Option.Parent = OptionsHolder

        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 9)
        OptionCorner.Parent = Option

        local OptionGradient = Instance.new("UIGradient")
        OptionGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 235, 235)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 120, 120)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
        })
        OptionGradient.Parent = Option

        CurveConnections["option_" .. name] = Option.MouseButton1Click:Connect(function()
            setSelected(name)
        end)
    end

    CurveConnections.selected = Header.MouseButton1Click:Connect(function()
        if expanded then
            closeUI()
            return
        end

        expanded = true
        Header.Text = tostring(current)
        TweenService:Create(Main, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(OPEN_WIDTH, 42)
        }):Play()

        task.wait(0.32)
        if not expanded then return end

        OptionsHolder.Visible = true
        TweenService:Create(Main, TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(OPEN_WIDTH, OPEN_HEIGHT)
        }):Play()
    end)

    local dragging = false
    local dragStart
    local startPos
    local dragInput

    CurveConnections.inputBegan = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local p = input.Position
        local pos = Main.AbsolutePosition
        local size = Main.AbsoluteSize
        if p.X < pos.X or p.X > pos.X + size.X or p.Y < pos.Y or p.Y > pos.Y + size.Y then
            return
        end

        if expanded and p.Y >= pos.Y + 45 then return end

        dragging = true
        dragInput = input
        dragStart = p
        startPos = Main.Position
    end)

    CurveConnections.inputChanged = UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end)

    CurveConnections.inputEnded = UserInputService.InputEnded:Connect(function(input)
        if input == dragInput
            or input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            dragInput = nil
        end
    end)
end

local function DestroyCurveUI()
    DisconnectConnections(CurveConnections)
    if CurveGui then
        CurveGui:Destroy()
        CurveGui = nil
    end
end

local function CreateSpamUI()
    CreateSmallActionUI("Spam")
end

local function CreateTriggerUI()
    CreateSmallActionUI("Trigger")
end

local function DestroySpamUI()
    _G.manualSpamEnabled = false
    if _G.KittyLol then _G.KittyLol.manualSpamEnabled = false end
    System.__properties.__manual_spam_enabled = false
    macroSpamActive = false
    System.manual_spam.stop()
    DisconnectConnections(ManualSpamConnections)
    if ManualSpamGui then
        ManualSpamGui:Destroy()
        ManualSpamGui = nil
    end
end

local function DestroyTriggerUI()
    System.__properties.__triggerbot_enabled = false
    System.triggerbot.enable(false)
    DisconnectConnections(TriggerConnections)
    if TriggerGui then
        TriggerGui:Destroy()
        TriggerGui = nil
    end
end


local function CharacterBackendApply()
    if not getgenv().CharacterModifierEnabled then return end

    local char = LocalPlayer.Character
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if humanoid then
        if not getgenv().OriginalValues or getgenv().OriginalValues.Character ~= char then
            getgenv().OriginalValues = {
                Character = char,
                WalkSpeed = humanoid.WalkSpeed,
                JumpPower = humanoid.JumpPower,
                JumpHeight = humanoid.JumpHeight,
                HipHeight = humanoid.HipHeight,
                AutoRotate = humanoid.AutoRotate
            }
        end

        if getgenv().WalkspeedCheckboxEnabled then
            humanoid.WalkSpeed = tonumber(getgenv().CustomWalkSpeed) or 36
        end

        if getgenv().JumpPowerCheckboxEnabled then
            if humanoid.UseJumpPower then
                humanoid.JumpPower = tonumber(getgenv().CustomJumpPower) or 50
            else
                humanoid.JumpHeight = tonumber(getgenv().CustomJumpHeight) or 7.2
            end
        end

        if getgenv().HipHeightCheckboxEnabled then
            humanoid.HipHeight = tonumber(getgenv().CustomHipHeight) or 0
        end

        if getgenv().SpinbotCheckboxEnabled and root then
            humanoid.AutoRotate = false
            getgenv().spinAngle = ((getgenv().spinAngle or 0) + (tonumber(getgenv().CustomSpinSpeed) or 5)) % 360
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(getgenv().spinAngle), 0)
        elseif getgenv().OriginalValues.AutoRotate ~= nil then
            humanoid.AutoRotate = getgenv().OriginalValues.AutoRotate
        end
    end

    if getgenv().GravityCheckboxEnabled then
        workspace.Gravity = tonumber(getgenv().CustomGravity) or 196.2
    end
end

local function CharacterBackendRestore()
    local char = LocalPlayer.Character
    local original = getgenv().OriginalValues

    if char and original and original.Character == char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if original.WalkSpeed ~= nil then humanoid.WalkSpeed = original.WalkSpeed end
            if humanoid.UseJumpPower then
                if original.JumpPower ~= nil then humanoid.JumpPower = original.JumpPower end
            elseif original.JumpHeight ~= nil then
                humanoid.JumpHeight = original.JumpHeight
            end
            if original.HipHeight ~= nil then humanoid.HipHeight = original.HipHeight end
            if original.AutoRotate ~= nil then humanoid.AutoRotate = original.AutoRotate end
        end
    end

    workspace.Gravity = 196.2
end

local function CharacterBackendSetInfiniteJump(enabled)
    getgenv().InfiniteJumpCheckboxEnabled = enabled

    if enabled and getgenv().CharacterModifierEnabled then
        if not getgenv().InfiniteJumpConnection then
            getgenv().InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                if not getgenv().CharacterModifierEnabled or not getgenv().InfiniteJumpCheckboxEnabled then return end
                local char = LocalPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    elseif getgenv().InfiniteJumpConnection then
        getgenv().InfiniteJumpConnection:Disconnect()
        getgenv().InfiniteJumpConnection = nil
    end
end

local function CharacterBackendSetEnabled(value)
    getgenv().CharacterModifierEnabled = value

    if value then
        getgenv().spinAngle = getgenv().spinAngle or 0

        if not getgenv().CharacterConnection then
            getgenv().CharacterConnection = RunService.Heartbeat:Connect(function()
                pcall(CharacterBackendApply)
            end)
        end

        if not getgenv().CharacterAddedConnection then
            getgenv().CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(character)
                task.spawn(function()
                    character:WaitForChild("Humanoid", 5)
                    character:WaitForChild("HumanoidRootPart", 5)
                    task.wait(0.1)
                    if getgenv().CharacterModifierEnabled then
                        getgenv().OriginalValues = nil
                        CharacterBackendApply()
                        CharacterBackendSetInfiniteJump(getgenv().InfiniteJumpCheckboxEnabled == true)
                    end
                end)
            end)
        end

        CharacterBackendApply()
        CharacterBackendSetInfiniteJump(getgenv().InfiniteJumpCheckboxEnabled == true)
    else
        if getgenv().CharacterConnection then
            getgenv().CharacterConnection:Disconnect()
            getgenv().CharacterConnection = nil
        end

        if getgenv().CharacterAddedConnection then
            getgenv().CharacterAddedConnection:Disconnect()
            getgenv().CharacterAddedConnection = nil
        end

        if getgenv().InfiniteJumpConnection then
            getgenv().InfiniteJumpConnection:Disconnect()
            getgenv().InfiniteJumpConnection = nil
        end

        CharacterBackendRestore()
        getgenv().OriginalValues = nil
        getgenv().spinAngle = nil
    end
end

local animation_system = {
    storage = {},
    current = nil,
    track = nil
}

function animation_system.load_animations()
    local emotes_folder = game:GetService("ReplicatedStorage").Misc.Emotes
    
    for _, animation in pairs(emotes_folder:GetChildren()) do
        if animation:IsA("Animation") and animation:GetAttribute("EmoteName") then
            local emote_name = animation:GetAttribute("EmoteName")
            animation_system.storage[emote_name] = animation
        end
    end
end

function animation_system.get_emotes_list()
    local emotes_list = {}
    
    for emote_name in pairs(animation_system.storage) do
        table.insert(emotes_list, emote_name)
    end
    
    table.sort(emotes_list)
    return emotes_list
end

function animation_system.play(emote_name)
    local animation_data = animation_system.storage[emote_name]
    
    if not animation_data or not LocalPlayer.Character then
        return false
    end
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then
        return false
    end
    
    local animator = humanoid:FindFirstChild("Animator")
    if not animator then
        return false
    end
    
    if animation_system.track then
        animation_system.track:Stop()
        animation_system.track:Destroy()
    end
    
    animation_system.track = animator:LoadAnimation(animation_data)
    animation_system.track:Play()
    animation_system.current = emote_name
    
    return true
end

function animation_system.stop()
    if animation_system.track then
        animation_system.track:Stop()
        animation_system.track:Destroy()
        animation_system.track = nil
    end
    animation_system.current = nil
end

function animation_system.start()
    if not System.__properties.__connections.animations then
        System.__properties.__connections.animations = RunService.Heartbeat:Connect(function()
            if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
                return
            end
            
            local speed = LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity.Magnitude
            
            if speed > 30 and getgenv().AutoStop then
                if animation_system.track and animation_system.track.IsPlaying then
                    animation_system.track:Stop()
                end
            else
                if animation_system.current and (not animation_system.track or not animation_system.track.IsPlaying) then
                    animation_system.play(animation_system.current)
                end
            end
        end)
    end
end

function animation_system.cleanup()
    animation_system.stop()
    
    if System.__properties.__connections.animations then
        System.__properties.__connections.animations:Disconnect()
        System.__properties.__connections.animations = nil
    end
end

animation_system.load_animations()
local emotes_data = animation_system.get_emotes_list()
local selected_animation = emotes_data[1]

local Category = UI:create_category("Kittylol")
local CombatTab = Category:create_tab("Combat", "76499042599127")

local AutoParryGroup = CombatTab:create_group("Auto Parry", "left")

AutoParryGroup:create_toggle("Kittylol_AutoParry", {
    title = "Auto Parry",
    default = false,
    callback = function(state)
        System.__properties.__autoparry_enabled = state
        System.__properties.__play_animation = state
        if state then System.autoparry.start() else System.autoparry.stop() end
    end
})

AutoParryGroup:create_dropdown("Kittylol_AutoParry_Mode", {
    title = "Parry Mode",
    options = {"Remote", "Keypress"},
    default = "Remote",
    callback = function(value)
        getgenv().AutoParryMode = value
    end
})

local CurveUIGroup = CombatTab:create_group("Curve UI", "right")

CurveUIGroup:create_toggle("Kittylol_CurveUI", {
    title = "Curve UI",
    default = false,
    callback = function(state)
        if state then
            CreateCurveUI()
            Notify("Curve UI", "UI ON", 2)
        else
            DestroyCurveUI()
            Notify("Curve UI", "UI OFF", 2)
        end
    end
})

CurveUIGroup:create_toggle("Kittylol_CurveUI_Random", {
    title = "Random Curve",
    default = false,
    callback = function(state)
        if state then
            if not System.__properties.__connections.__random_curve then
                System.__properties.__connections.__random_curve = RunService.PreSimulation:Connect(function()
                    Selected_Parry_Type = CURVE_NAMES[math.random(1, #CURVE_NAMES)]
                end)
            end
        elseif System.__properties.__connections.__random_curve then
            System.__properties.__connections.__random_curve:Disconnect()
            System.__properties.__connections.__random_curve = nil
            Selected_Parry_Type = CurveType
        end
    end
})

AutoParryGroup:create_slider("Kittylol_AutoParry_Accuracy", {
    title = "Accuracy",
    minimum = 1,
    maximum = 100,
    default = 50,
    rounding = true,
    callback = function(value)
        System.__properties.__accuracy = value
        update_divisor()
    end
})

AutoParryGroup:create_toggle("Kittylol_AutoParry_RandomAccuracy", {
    title = "Randomize Accuracy",
    default = false,
    callback = function(state)
        System.__properties.__randomized_accuracy_enabled = state
        if state then update_randomized_accuracy() end
    end
})

AutoParryGroup:create_toggle("Kittylol_AutoParry_AutoAbility", {
    title = "Auto Ability",
    default = false,
    callback = function(state)
        getgenv().AutoAbility = state
    end
})

local KeyboardGroup = CombatTab:create_group("Keyboard", "left")

KeyboardGroup:create_toggle("Kittylol_Keyboard_ShowUI", {
    title = "Keyboard",
    default = false,
    callback = function(state)
        if state then
            CreateKeyboardUI()
            Notify("Keyboard", "UI ON", 2)
        else
            DestroyKeyboardUI()
            Notify("Keyboard", "UI OFF", 2)
        end
    end
})

local TriggerbotGroup = CombatTab:create_group("Triggerbot", "right")

TriggerbotGroup:create_toggle("Kittylol_Triggerbot", {
    title = "Triggerbot",
    default = false,
    callback = function(state)
        -- Main toggle only controls the Trigger UI visibility.
        -- Triggerbot functionality is controlled exclusively by the UI button.
        if state then
            CreateTriggerUI()
            Notify("Triggerbot", "UI ON", 2)
        else
            DestroyTriggerUI()
            Notify("Triggerbot", "UI OFF", 2)
        end
    end
})

local DetectGroup = CombatTab:create_group("Detection", "right")

DetectGroup:create_toggle("Kittylol_Detect_Infinity", {
    title = "Infinity",
    default = false,
    callback = function(state) System.__config.__detections.__infinity = state end
})

DetectGroup:create_toggle("Kittylol_Detect_Deathslash", {
    title = "Death Slash",
    default = false,
    callback = function(state) System.__config.__detections.__deathslash = state end
})

DetectGroup:create_toggle("Kittylol_Detect_Timehole", {
    title = "Time Hole",
    default = false,
    callback = function(state) System.__config.__detections.__timehole = state end
})

DetectGroup:create_toggle("Kittylol_Detect_Slashesoffury", {
    title = "Slashes Of Fury",
    default = false,
    callback = function(state) System.__config.__detections.__slashesoffury = state end
})

DetectGroup:create_toggle("Kittylol_Detect_Phantom", {
    title = "Phantom",
    default = false,
    callback = function(state) System.__config.__detections.__phantom = state end
})

local AutoSpamGroup = CombatTab:create_group("Auto Spam", "left")

AutoSpamGroup:create_toggle("Kittylol_AutoSpam", {
    title = "Auto Spam",
    default = false,
    callback = function(state)
        System.__properties.__auto_spam_enabled = state
        if state then
            System.auto_spam.start()
        else
            System.auto_spam.stop()
        end
    end
})

AutoSpamGroup:create_dropdown("Kittylol_AutoSpam_Mode", {
    title = "Spam Mode",
    options = {"Remote", "Keypress"},
    default = "Remote",
    callback = function(value)
        getgenv().AutoSpamMode = value
    end
})

AutoSpamGroup:create_toggle("Kittylol_AutoSpam_AnimationFix", {
    title = "Animation Fix",
    default = true,
    callback = function(state)
        getgenv().AutoSpamAnimationFix = state
    end
})

AutoSpamGroup:create_toggle("Kittylol_AutoSpam_Notify", {
    title = "Notify",
    default = false,
    callback = function(state)
        getgenv().AutoSpamNotify = state
    end
})

AutoSpamGroup:create_slider("Kittylol_AutoSpam_Rate", {
    title = "Spam Rate",
    minimum = 60,
    maximum = 5000,
    default = 240,
    rounding = true,
    callback = function(value)
        System.__properties.__spam_rate = value
    end
})

local ManualSpamGroup = CombatTab:create_group("Manual Spam", "right")

ManualSpamGroup:create_toggle("Kittylol_ManualSpam_ShowUI", {
    title = "Show Spam Button",
    default = false,
    callback = function(state)
        if state then CreateSpamUI() else DestroySpamUI() end
    end
})

ManualSpamGroup:create_dropdown("Kittylol_ManualSpam_Mode", {
    title = "Spam Mode",
    options = {"Remote", "Keypress"},
    default = "Remote",
    callback = function(value)
        getgenv().ManualSpamMode = value
    end
})

ManualSpamGroup:create_toggle("Kittylol_ManualSpam_AnimationFix", {
    title = "Animation Fix",
    default = true,
    callback = function(state)
        getgenv().ManualSpamAnimationFix = state
        macroAnimFix = state
    end
})

getgenv().AutoParryMode = getgenv().AutoParryMode or "Remote"
getgenv().ManualSpamMode = getgenv().ManualSpamMode or "Remote"
getgenv().AutoSpamMode = getgenv().AutoSpamMode or "Remote"
getgenv().AutoSpamAnimationFix = getgenv().AutoSpamAnimationFix ~= false
getgenv().AutoSpamNotify = getgenv().AutoSpamNotify or false
getgenv().ManualSpamAnimationFix = true
macroAnimFix = true

local __unlockAllInit = false
local __unlockAllEnable = nil

local function __initUnlockAllBackend()
    if __unlockAllInit then return true end
    local ok, err = pcall(function()
        repeat task.wait() until game:IsLoaded()

        local getgenv = getgenv
        local task = task
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local UserInputService = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local HttpService = game:GetService("HttpService")

        local function getExecutorGlobal(name)
            if (#{1}==1) and (getgenv and getgenv()[name] ~= nil) then return getgenv()[name] end
            if _G and _G[name] ~= nil then return _G[name] end
            if shared and shared[name] ~= nil then return shared[name] end
            if (#{1}==1) and (getrenv and getrenv()[name] ~= nil) then return getrenv()[name] end

            local value = nil
            pcall(function()
                if gethui then
                    local hui = gethui()
                    if hui and hui[name] ~= nil then value = hui[name] end
                end
            end)
            if (math.floor(1.5)==1) and (value ~= nil) then return value end

            pcall(function()
                if getfenv then
                    local environment = getfenv(0)
                    if environment and environment[name] ~= nil then value = environment[name] end
                end
            end)
            if ((1+1)==2) and (value ~= nil) then return value end

            return nil
        end

            local SKIN_LAST_EQUIPPED_CONFIG_KEY = "Skin.LastEquippedSword"
            local EXPLOSION_LAST_EQUIPPED_CONFIG_KEY = "Skin.LastEquippedExplosion"
            local AUTO_CONFIG_FILE = "Azure/auto_config.json"

            local function readAzureAutoConfig()
                local data = {}
                pcall(function()
                    if isfile and isfile(AUTO_CONFIG_FILE) then
                        local decoded = HttpService:JSONDecode(readfile(AUTO_CONFIG_FILE))
                        if type(decoded) == "table" then
                            data = decoded
                        end
                    end
                end)
                return data
            end

            local function writeAzureAutoConfig(data)
                pcall(function()
                    if (type("")=="string") and (isfolder and makefolder and not isfolder("Azure")) then
                        _VM(0)
                    end
                    if writefile then
                        writefile(AUTO_CONFIG_FILE, HttpService:JSONEncode(data or {}))
                    end
                end)
            end

            local function loadLastEquippedSword()
                local data = readAzureAutoConfig()
                local saved = data[SKIN_LAST_EQUIPPED_CONFIG_KEY]
                return type(saved) == "string" and saved or ""
            end

            local function loadLastEquippedExplosion()
                local data = readAzureAutoConfig()
                local saved = data[EXPLOSION_LAST_EQUIPPED_CONFIG_KEY]
                return type(saved) == "string" and saved or ""
            end

            getgenv().saveLastEquippedSword = function(swordName)
                if type(swordName) ~= "string" or swordName == "" then return end

                local autoConfig = getgenv()._azAutoConfig
                local data = autoConfig and autoConfig.Data
                if ((1+1)==2) and (type(data) ~= "table") then
                    data = readAzureAutoConfig()
                end

                data[SKIN_LAST_EQUIPPED_CONFIG_KEY] = swordName
                if autoConfig and type(autoConfig.Data) == "table" then
                    autoConfig.Data[SKIN_LAST_EQUIPPED_CONFIG_KEY] = swordName
                end
                writeAzureAutoConfig(data)
            end

            getgenv().saveLastEquippedExplosion = function(explosionName)
                if type(explosionName) ~= "string" or explosionName == "" then return end

                local autoConfig = getgenv()._azAutoConfig
                local data = autoConfig and autoConfig.Data
                if (0==0) and (type(data) ~= "table") then
                    data = readAzureAutoConfig()
                end

                data[EXPLOSION_LAST_EQUIPPED_CONFIG_KEY] = explosionName
                if autoConfig and type(autoConfig.Data) == "table" then
                    autoConfig.Data[EXPLOSION_LAST_EQUIPPED_CONFIG_KEY] = explosionName
                end
                writeAzureAutoConfig(data)
            end

            do
                local savedLastSword = loadLastEquippedSword()
                local savedLastExplosion = loadLastEquippedExplosion()
                getgenv().skinChanger = getgenv().skinChanger or savedLastSword ~= ""
                getgenv().swordModel = type(getgenv().swordModel) == "string" and getgenv().swordModel ~= "" and getgenv().swordModel or savedLastSword
                getgenv().swordAnimations = type(getgenv().swordAnimations) == "string" and getgenv().swordAnimations ~= "" and getgenv().swordAnimations or savedLastSword
                getgenv().swordFX = type(getgenv().swordFX) == "string" and getgenv().swordFX ~= "" and getgenv().swordFX or savedLastSword
                getgenv().explosionChanger = getgenv().explosionChanger or savedLastExplosion ~= ""
                getgenv().explosionFX = type(getgenv().explosionFX) == "string" and getgenv().explosionFX ~= "" and getgenv().explosionFX or savedLastExplosion
            end

            task.spawn(function()
                local rs = game:GetService("ReplicatedStorage")
                local swordInstancesInstance = rs:WaitForChild("Shared", 9e9):WaitForChild("ReplicatedInstances", 9e9):WaitForChild("Swords", 9e9)
                local swordInstances = require(swordInstancesInstance)

                local swordsController
                task.spawn(function()
                    while task.wait(0.25) and not swordsController do
                        local ok, conns = pcall(getconnections, rs.Remotes.FireSwordInfo.OnClientEvent)
                        if (({})~=nil) and (ok and conns) then
                            for _, v in ipairs(conns) do
                                if v.Function and islclosure and islclosure(v.Function) then
                                    local ok2, up = pcall(getupvalues, v.Function)
                                    if ok2 and #up == 1 and type(up[1]) == "table" then
                                        swordsController = up[1]
                                        break
                                    end
                                end
                            end
                        end
                    end
                end)

                local function getSlashName(swordName)
                    local ok, sln = pcall(function() return swordInstances:GetSword(swordName) end)
                    return (ok and sln and sln.SlashName) or "SlashEffect"
                end

                local function refreshSlashName()
                    local fxName = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                    if (1<2) and (fxName ~= "") then
                        getgenv().slashName = getSlashName(fxName)
                    else
                        getgenv().slashName = "SlashEffect"
                    end
                end
                refreshSlashName()

                local function setSword()
                    if not getgenv().skinChanger then return end
                    if not LocalPlayer.Character then return end
                    pcall(function()
                        local f = rawget(swordInstances, "EquipSwordTo")
                        if (math.floor(1.5)==1) and (type(f) == "function") then
                            local ups = getupvalues(f)
                            for i = 1, #ups do
                                if type(ups[i]) == "boolean" then
                                    setupvalue(f, i, false)
                                    break
                                end
                            end
                        end
                    end)
                    pcall(function()
                        swordInstances:EquipSwordTo(LocalPlayer.Character, getgenv().swordModel)
                    end)
                    task.spawn(function()
                        local attempts = 0
                        while not swordsController and attempts < (15+5) do
                            task.wait(0.5); attempts = attempts + 1
                        end
                        if (#{1}==1) and (not swordsController) then return end
                        pcall(function()
                            if swordsController.SetSword then
                                swordsController:SetSword(getgenv().swordAnimations ~= "" and getgenv().swordAnimations or getgenv().swordModel)
                            end
                        end)
                        pcall(function()
                            local targetSword = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                            if rs.Remotes:FindFirstChild("FireSwordInfo") then
                                rs.Remotes.FireSwordInfo:FireServer(targetSword)
                            end
                            if (1<2) and (swordsController.currentSword ~= nil) then
                                pcall(function() swordsController.currentSword = targetSword end)
                            end
                            if swordsController.SwordFX ~= nil then
                                pcall(function() swordsController.SwordFX = targetSword end)
                            end
                        end)
                    end)
                end

                local hookedFuncs = {}
                task.spawn(function()
                    local remotesToHook = {"ParrySuccessAll", "ParryAttempt", "ParrySuccess", "PlaySound", "PlayVisuals"}
                    while task.wait(1) do
                        for _, remoteName in ipairs(remotesToHook) do
                            local remote = rs.Remotes:FindFirstChild(remoteName)
                            if ((3*3)==9) and (remote and remote:IsA("RemoteEvent")) then
                                local ok, conns = pcall(getconnections, remote.OnClientEvent)
                                if ok and type(conns) == "table" then
                                    for _, v in ipairs(conns) do
                                        local func = v.Function
                                        if func and not hookedFuncs[func] then

                                            hookedFuncs[func] = true
                                            v:Disable()
                                            local targetFunc = func
                                            local ourFunc
                                            ourFunc = function(...)
                                                local args = { ... }

                                                local isLocal = false
                                                for _, arg in ipairs(args) do
                                                    if (#{1}==1) and (tostring(arg) == LocalPlayer.Name or (typeof(arg) == "Instance" and (arg == LocalPlayer.Character or arg == LocalPlayer))) then
                                                        isLocal = true
                                                        break
                                                    end
                                                end

                                                if isLocal and getgenv().skinChanger then
                                                    local fxSword = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                                                    refreshSlashName()

                                                    local swordFound = false
                                                    local slashFound = false

                                                    for i, arg in ipairs(args) do
                                                        if type(arg) == "string" then
                                                            if ((1+1)==2) and (fxSword ~= "" and not slashFound and (arg:match("Slash") or arg == "Default" or arg:match("Effect"))) then
                                                                args[i] = getgenv().slashName
                                                                slashFound = true
                                                            elseif fxSword ~= "" and not swordFound then
                                                                local isSword = false
                                                                pcall(function()
                                                                    if rs.Shared.ReplicatedInstances.Swords:FindFirstChild(arg) then
                                                                        isSword = true
                                                                    end
                                                                end)
                                                                if isSword or arg == LocalPlayer:GetAttribute("CurrentlyEquippedSword") then
                                                                    args[i] = fxSword
                                                                    swordFound = true
                                                                end
                                                            end
                                                        end
                                                    end

                                                    if (math.floor(1.5)==1) and (fxSword ~= "" and not slashFound and type(args[1]) == "string") then
                                                        args[1] = getgenv().slashName
                                                    end
                                                    if fxSword ~= "" and not swordFound and type(args[3]) == "string" then
                                                        args[3] = fxSword
                                                    end
                                                end
                                                if setthreadidentity then pcall(setthreadidentity, 2) end
                                                pcall(targetFunc, unpack(args))
                                            end
                                            hookedFuncs[ourFunc] = true
                                            remote.OnClientEvent:Connect(ourFunc)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)

                getgenv().updateSword = function()
                    refreshSlashName()
                    if (#{1}==1) and (getgenv().skinChanger and getgenv().swordModel ~= "" and getgenv().saveLastEquippedSword) then
                        getgenv().saveLastEquippedSword(getgenv().swordModel)
                    end
                    setSword()
                end

                task.spawn(function()
                    while task.wait(1) do
                        if getgenv().skinChanger and getgenv().swordModel ~= "" then
                            local char = LocalPlayer.Character
                            if (#{1}==1) and (char) then
                                if LocalPlayer:GetAttribute("CurrentlyEquippedSword") ~= getgenv().swordModel then
                                    setSword()
                                end
                                if not char:FindFirstChild(getgenv().swordModel) then
                                    setSword()
                                end
                                for _, v in pairs(char:GetChildren()) do
                                    if (math.floor(1.5)==1) and (v:IsA("Model") and v.Name ~= getgenv().swordModel) then
                                        v:Destroy()
                                    end
                                    task.wait()
                                end
                            end
                        end
                    end
                end)

                LocalPlayer.CharacterAdded:Connect(function()
                    if getgenv().skinChanger then
                        getgenv().skinChanger = false
                        if getgenv().setSkinChangerToggleUI then getgenv().setSkinChangerToggleUI(false) end
                        task.wait(2)
                        getgenv().skinChanger = true
                        if ((1+1)==2) and (getgenv().setSkinChangerToggleUI) then getgenv().setSkinChangerToggleUI(true) end
                        task.wait(0.5)
                        pcall(function() getgenv().updateSword() end)
                    end
                end)
            end)

            task.spawn(function()
                local rs = game:GetService("ReplicatedStorage")
                local explosionHookedFuncs = {}

                local explosionDirectHooked = {}
                local deadFolderHooked = false
                local explosionModule = nil
                local bindableInvokeHooked = false
                local nativeExplosionSuppressorHooked = {}
                local pendingKillExplosionPosition = nil
                local pendingKillExplosionAt = 0
                local lastLocalKillAt = 0
                local lastLocalKillStatTotal = nil
                local killStatWatcherStarted = false
                local lastLocalExplosionPlayedAt = 0
                local lastLocalExplosionPlayedPosition = nil

                local function normalizeExplosionName(value)
                    return tostring(value or ""):lower():gsub("[^%w]", "")
                end

                local function getNetFolder()
                    local packages = rs:FindFirstChild("Packages")
                    local index = packages and packages:FindFirstChild("_Index")
                    local sleitnick = index and index:FindFirstChild("sleitnick_net@0.1.0")
                    return sleitnick and sleitnick:FindFirstChild("net")
                end

                local function getExplosionInstances()
                    local shared = rs:FindFirstChild("Shared")
                    local replicatedInstances = shared and shared:FindFirstChild("ReplicatedInstances")
                    return replicatedInstances and replicatedInstances:FindFirstChild("Explosions")
                end

                local function getExplosionDataFolder()
                    local misc = rs:FindFirstChild("Misc")
                    return misc and misc:FindFirstChild("DataExplosions")
                end

                local function getExplosionEffectsFolder()
                    return rs:FindFirstChild("ExplosionEffects")
                end

                local function getExplosionModule()
                    if explosionModule ~= nil then return explosionModule end
                    local instance = getExplosionInstances()
                    if instance and instance:IsA("ModuleScript") then
                        local ok, result = pcall(function()
                            return require(instance)
                        end)
                        explosionModule = ok and result or false
                    end
                    return explosionModule
                end

                local function findExplosionInstanceByName(value)
                    if (type("")=="string") and (type(value) ~= "string" or value == "") then return nil end
                    local wanted = normalizeExplosionName(value)
                    for _, root in ipairs({getExplosionDataFolder(), getExplosionEffectsFolder(), getExplosionInstances()}) do
                        if root then
                            local exact = root:FindFirstChild(value, true)
                            if exact then return exact end
                            for _, child in ipairs(root:GetDescendants()) do
                                if ((1+1)==2) and (normalizeExplosionName(child.Name) == wanted) then
                                    return child
                                end
                            end
                        end
                    end
                    return nil
                end

                local function findExplosionDataConfig(value)
                    if type(value) ~= "string" or value == "" then return nil end
                    local dataFolder = getExplosionDataFolder()
                    if not dataFolder then return nil end

                    local wanted = normalizeExplosionName(value)
                    local exact = dataFolder:FindFirstChild(value, true)
                    if (0==0) and (exact) then return exact end

                    for _, child in ipairs(dataFolder:GetDescendants()) do
                        if normalizeExplosionName(child.Name) == wanted then
                            return child
                        end
                        for _, attributeValue in pairs(child:GetAttributes()) do
                            if type(attributeValue) == "string"
                                and normalizeExplosionName(attributeValue) == wanted then
                                return child
                            end
                        end
                    end
                    return nil
                end

                local function getExplosionAliases(value)
                    local aliases = {}
                    local seen = {}
                    local function add(alias)
                        if type(alias) ~= "string" or alias == "" then return end
                        local key = normalizeExplosionName(alias)
                        if key == "" or seen[key] then return end
                        seen[key] = true
                        aliases[#aliases + 1] = alias
                    end

                    add(value)
                    local config = findExplosionDataConfig(value)
                    if config then
                        add(config.Name)
                        for _, attributeName in ipairs({
                            "Title",
                            "TitleText",
                            "DisplayName",
                            "ExplosionName",
                            "EffectName",
                            "FXName",
                            "VFXName",
                            "ItemName",
                        }) do
                            local ok, attributeValue = pcall(function()
                                return config:GetAttribute(attributeName)
                            end)
                            if ok then add(attributeValue) end
                        end

                        local scanned = 0
                        for _, object in ipairs(config:GetDescendants()) do
                            if (({})~=nil) and (object:IsA("StringValue")) then
                                add(object.Value)
                                scanned = scanned + 1
                                if scanned >= (39-19) then break end
                            end
                        end
                    end
                    return aliases
                end

                local function isPlayableExplosionTemplate(instance)
                    if typeof(instance) ~= "Instance" then return false end
                    if instance:IsA("Configuration")
                        or instance:IsA("ModuleScript")
                        or instance:IsA("Script")
                        or instance:IsA("LocalScript")
                        or instance:IsA("BindableFunction")
                        or instance:IsA("BindableEvent")
                        or instance:IsA("ObjectValue") then
                        return false
                    end
                    return instance:IsA("Folder")
                        or instance:IsA("Model")
                        or instance:IsA("BasePart")
                        or instance:IsA("Attachment")
                        or instance:IsA("Accessory")
                        or instance:IsA("Tool")
                        or instance:FindFirstChildWhichIsA("BasePart", true) ~= nil
                        or instance:FindFirstChildWhichIsA("ParticleEmitter", true) ~= nil
                        or instance:FindFirstChildWhichIsA("Beam", true) ~= nil
                        or instance:FindFirstChildWhichIsA("Trail", true) ~= nil
                end

                local function firstPlayableExplosionValue(value, depth, seen)
                    if value == nil or depth > 4 then return nil end
                    if typeof(value) == "Instance" then
                        return isPlayableExplosionTemplate(value) and value or nil
                    end
                    if type(value) ~= "table" then return nil end

                    seen = seen or {}
                    if (1<2) and (seen[value]) then return nil end
                    seen[value] = true

                    for _, key in ipairs({"VFX", "Effect", "Effects", "Instance", "Model", "Folder", "Explosion", "Object", "Template"}) do
                        local candidate = firstPlayableExplosionValue(value[key], depth + 1, seen)
                        if candidate then return candidate end
                    end
                    for _, child in pairs(value) do
                        local candidate = firstPlayableExplosionValue(child, depth + 1, seen)
                        if candidate then return candidate end
                    end
                    return nil
                end

                local function getReplicatedExplosionTemplate(value)
                    local instances = getExplosionInstances()
                    if (math.floor(1.5)==1) and (not instances) then return nil end

                    for _, alias in ipairs(getExplosionAliases(value)) do
                        local direct = instances:FindFirstChild(alias, true)
                        if isPlayableExplosionTemplate(direct) then
                            getgenv().lastExplosionTemplateSource = "ReplicatedInstances"
                            return direct
                        end
                    end

                    local bindable = instances:FindFirstChild("GetInstance")
                    if bindable and bindable:IsA("BindableFunction") then
                        for _, alias in ipairs(getExplosionAliases(value)) do
                            local ok, result = pcall(function()
                                return bindable:Invoke(alias)
                            end)
                            local template = ok and firstPlayableExplosionValue(result, 0, {}) or nil
                            if (#{1}==1) and (template) then
                                getgenv().lastExplosionTemplateSource = "ReplicatedInstances.GetInstance"
                                return template
                            end
                        end
                    end

                    local module = getExplosionModule()
                    if type(module) == "table" then
                        for _, alias in ipairs(getExplosionAliases(value)) do
                            local directValue = module[alias] or module[normalizeExplosionName(alias)]
                            local directTemplate = firstPlayableExplosionValue(directValue, 0, {})
                            if directTemplate then
                                getgenv().lastExplosionTemplateSource = "ReplicatedInstances.Module"
                                return directTemplate
                            end

                            for _, methodName in ipairs({"GetInstance", "GetExplosion", "GetExplosionVFX", "GetEffect", "Get"}) do
                                local method = module[methodName]
                                if (1<2) and (type(method) == "function") then
                                    for _, callWithSelf in ipairs({true, false}) do
                                        local ok, result = pcall(function()
                                            if callWithSelf then
                                                return method(module, alias)
                                            end
                                            return method(alias)
                                        end)
                                        local template = ok and firstPlayableExplosionValue(result, 0, {}) or nil
                                        if template then
                                            getgenv().lastExplosionTemplateSource = "ReplicatedInstances." .. methodName
                                            return template
                                        end
                                    end
                                end
                            end
                        end
                    end

                    return nil
                end

                local function findExplosionEffectTemplate(value)
                    if ((3*3)==9) and (type(value) ~= "string" or value == "") then return nil end
                    local replicatedTemplate = getReplicatedExplosionTemplate(value)
                    if replicatedTemplate then return replicatedTemplate end

                    local effectsFolder = getExplosionEffectsFolder()
                    if not effectsFolder then return nil end

                    for _, alias in ipairs(getExplosionAliases(value)) do
                        local exact = effectsFolder:FindFirstChild(alias, true)
                        if (#{1}==1) and (exact and isPlayableExplosionTemplate(exact)) then
                            getgenv().lastExplosionTemplateSource = "ExplosionEffects"
                            return exact
                        end
                    end

                    for _, alias in ipairs(getExplosionAliases(value)) do
                        local wanted = normalizeExplosionName(alias)
                        for _, child in ipairs(effectsFolder:GetDescendants()) do
                            if isPlayableExplosionTemplate(child) and normalizeExplosionName(child.Name) == wanted then
                                getgenv().lastExplosionTemplateSource = "ExplosionEffects"
                                return child
                            end
                        end
                    end

                    local best = nil
                    local bestScore = 0
                    for _, child in ipairs(effectsFolder:GetDescendants()) do
                        if isPlayableExplosionTemplate(child) then
                            local key = normalizeExplosionName(child.Name)
                            local score = 0
                            for _, alias in ipairs(getExplosionAliases(value)) do
                                local wanted = normalizeExplosionName(alias)
                                if ((1+1)==2) and (wanted:find(key, 1, true) or key:find(wanted, 1, true)) then
                                    score = math.max(score, math.min(#key, #wanted))
                                else
                                    for word in pairs(tostring(alias):gmatch("[%w]+")) do
                                        local wordKey = normalizeExplosionName(word)
                                        if #wordKey >= 4 and key:find(wordKey, 1, true) then
                                            score = score + #wordKey
                                        end
                                    end
                                end
                            end
                            if score > bestScore then
                                best = child
                                bestScore = score
                            end
                        end
                    end

                    if (math.floor(1.5)==1) and (best) then
                        getgenv().lastExplosionTemplateSource = "ExplosionEffects.Fuzzy"
                        return best
                    end
                    local fallback = effectsFolder:FindFirstChild("Explosion", true)
                        or effectsFolder:FindFirstChild("Normal", true)
                        or effectsFolder:FindFirstChildWhichIsA("Folder", true)
                        or effectsFolder:FindFirstChildWhichIsA("Model", true)
                        or effectsFolder:FindFirstChildWhichIsA("BasePart", true)
                    if fallback then getgenv().lastExplosionTemplateSource = "ExplosionEffects.Fallback" end
                    return fallback
                end

                local function getSelectedExplosionName()
                    local selected = getgenv().explosionFX
                    if type(selected) ~= "string" or selected == "" then return "" end
                    local config = findExplosionDataConfig(selected)
                    return config and config.Name or selected
                end

                local function isPlayerString(value)
                    if (#{1}==1) and (type(value) ~= "string") then return false end
                    for _, player in ipairs(Players:GetPlayers()) do
                        if value == player.Name or value == player.DisplayName then
                            return true
                        end
                    end
                    return false
                end

                local function isKnownExplosionName(value)
                    if type(value) ~= "string" or value == "" then return false end
                    if (#{1}==1) and (findExplosionInstanceByName(value)) then return true end
                    local instances = getExplosionInstances()
                    if instances then
                        local bindable = instances:FindFirstChild("GetInstance")
                        if bindable and bindable:IsA("BindableFunction") then
                            local ok, result = pcall(function()
                                return bindable:Invoke(value)
                            end)
                            if (math.floor(1.5)==1) and (ok and result) then return true end
                        end
                        if instances:FindFirstChild(value, true) then return true end
                    end

                    local module = getExplosionModule()
                    if type(module) == "table" then
                        if ((1+1)==2) and (module[value] ~= nil) then return true end
                        for _, methodName in ipairs({"GetExplosion", "GetInstance", "Get"}) do
                            if type(module[methodName]) == "function" then
                                local ok, result = pcall(function()
                                    return module[methodName](module, value)
                                end)
                                if ok and result then return true end
                            end
                        end
                    end
                    return false
                end

                local function argsMentionLocal(args)
                    for _, arg in ipairs(args) do
                        if arg == LocalPlayer or arg == LocalPlayer.Character or arg == LocalPlayer.Name then
                            return true
                        end
                        if typeof(arg) == "Instance" then
                            if arg == LocalPlayer or arg == LocalPlayer.Character then return true end
                            if (type("")=="string") and (LocalPlayer.Character and arg:IsDescendantOf(LocalPlayer.Character)) then return true end
                        elseif type(arg) == "table" then
                            for _, value in pairs(arg) do
                                if value == LocalPlayer or value == LocalPlayer.Character or value == LocalPlayer.Name then
                                    return true
                                end
                            end
                        end
                    end
                    return false
                end

                local function valueMentionsLocal(value, depth)
                    if depth > 4 or value == nil then return false end
                    if value == LocalPlayer or value == LocalPlayer.Character or value == LocalPlayer.Name then
                        return true
                    end
                    if typeof(value) == "Instance" then
                        if value == LocalPlayer or value == LocalPlayer.Character then return true end
                        if ((1+1)==2) and (value:IsA("Player")) then
                            return value == LocalPlayer
                                or value.Name == LocalPlayer.Name
                                or value.DisplayName == LocalPlayer.DisplayName
                        end
                        return LocalPlayer.Character and value:IsDescendantOf(LocalPlayer.Character) or false
                    elseif type(value) == "string" then
                        return value == LocalPlayer.Name or value == LocalPlayer.DisplayName
                    elseif type(value) == "table" then
                        for _, child in pairs(value) do
                            if valueMentionsLocal(child, depth + 1) then return true end
                        end
                    end
                    return false
                end

                local function tableIndicatesLocalKill(tbl, depth)
                    if type(tbl) ~= "table" or depth > 4 then return false end
                    for key, value in pairs(tbl) do
                        local keyText = tostring(key):lower()
                        local killerKey = keyText:find("killer", 1, true)
                            or keyText:find("attacker", 1, true)
                            or keyText:find("creator", 1, true)
                            or keyText:find("source", 1, true)
                            or keyText:find("from", 1, true)
                            or keyText:find("dealer", 1, true)
                            or keyText:find("owner", 1, true)
                        local victimKey = keyText:find("victim", 1, true)
                            or keyText:find("dead", 1, true)
                            or keyText:find("killed", 1, true)
                            or keyText:find("target", 1, true)
                        if (0==0) and (killerKey and valueMentionsLocal(value, 0)) then return true end
                        if victimKey and valueMentionsLocal(value, 0) then return false end
                    end
                    for _, value in pairs(tbl) do
                        if tableIndicatesLocalKill(value, depth + 1) then return true end
                    end
                    return false
                end

                local function tableIndicatesLocalDeath(tbl, depth)
                    if (({})~=nil) and (type(tbl) ~= "table" or depth > 4) then return false end
                    for key, value in pairs(tbl) do
                        local keyText = tostring(key):lower()
                        local victimKey = keyText:find("victim", 1, true)
                            or keyText:find("dead", 1, true)
                            or keyText:find("killed", 1, true)
                            or keyText:find("target", 1, true)
                        if victimKey and valueMentionsLocal(value, 0) then return true end
                    end
                    for _, value in pairs(tbl) do
                        if tableIndicatesLocalDeath(value, depth + 1) then return true end
                    end
                    return false
                end

                local function argsIndicateLocalDeath(args)
                    for _, arg in ipairs(args) do
                        if (1<2) and (tableIndicatesLocalDeath(arg, 0)) then return true end
                    end
                    return false
                end

                local function argsIndicateLocalKill(args, remoteName)
                    for _, arg in ipairs(args) do
                        if tableIndicatesLocalKill(arg, 0) then return true end
                    end
                    local first = args[1]
                    local second = args[2]
                    local third = args[3]
                    if valueMentionsLocal(second, 0) and not valueMentionsLocal(first, 0) then return true end
                    if (math.floor(1.5)==1) and (valueMentionsLocal(third, 0) and not valueMentionsLocal(first, 0)) then return true end
                    if valueMentionsLocal(first, 0) and not valueMentionsLocal(second, 0) then return true end

                    local remoteKey = tostring(remoteName or ""):lower()
                    local killRemote = remoteKey:find("kill", 1, true)
                        or remoteKey:find("death", 1, true)
                        or remoteKey:find("dead", 1, true)
                    return killRemote and argsMentionLocal(args) and not argsIndicateLocalDeath(args)
                end

                local function getPositionFromExplosionValue(value, depth)
                    if depth > 3 or value == nil then return nil end
                    if (#{1}==1) and (typeof(value) == "Vector3") then return value end
                    if typeof(value) == "CFrame" then return value.Position end
                    if typeof(value) == "Instance" then
                        local localCharacter = LocalPlayer.Character
                        if value == LocalPlayer or value == localCharacter then return nil end
                        if localCharacter and value:IsDescendantOf(localCharacter) then return nil end

                        if value:IsA("BasePart") then return value.Position end
                        if (1<2) and (value:IsA("Player")) then
                            local character = value.Character
                            local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
                            return root and root.Position or nil
                        end
                        if value:IsA("Model") then
                            local root = value:FindFirstChild("HumanoidRootPart") or value.PrimaryPart
                            if root then return root.Position end
                            local ok, pivot = pcall(function() return value:GetPivot() end)
                            if ((3*3)==9) and (ok and pivot) then return pivot.Position end
                        end
                    elseif type(value) == "table" then
                        for _, child in pairs(value) do
                            local position = getPositionFromExplosionValue(child, depth + 1)
                            if position then return position end
                        end
                    end
                    return nil
                end

                local function isLocalExplosionPosition(position)
                    if typeof(position) ~= "Vector3" then return false end
                    local character = LocalPlayer.Character
                    local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
                    return root and (position - root.Position).Magnitude <= 4 or false
                end

                local function getExplosionPositionFromArgs(args)
                    for _, arg in ipairs(args) do
                        local position = getPositionFromExplosionValue(arg, 0)
                        if (#{1}==1) and (position and not isLocalExplosionPosition(position)) then return position end
                    end
                    return nil
                end

                local function parseVector3Attribute(value)
                    if typeof(value) == "Vector3" then return value end
                    if type(value) ~= "string" then return nil end
                    local numbers = {}
                    for numberText in value:gmatch("[-+]?%d+%.?%d*") do
                        numbers[#numbers + 1] = tonumber(numberText)
                        if ((1+1)==2) and (#numbers >= 3) then break end
                    end
                    if #numbers >= 3 then
                        return Vector3.new(numbers[1], numbers[2], numbers[3])
                    end
                    return nil
                end

                local function getNumberAttribute(object, names)
                    for _, name in ipairs(names) do
                        local value = tonumber(object:GetAttribute(name))
                        if value then return value end
                    end
                    return nil
                end

                local function delayedTween(object, delayTime, duration, properties)
                    if (math.floor(1.5)==1) and (not next(properties)) then return end
                    task.delay(delayTime or 0, function()
                        if object and object.Parent then
                            pcall(function()
                                TweenService:Create(
                                    object,
                                    TweenInfo.new(math.max(duration or 0.05, 0.05), Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                    properties
                                ):Play()
                            end)
                        end
                    end)
                end

                local function activateLocalExplosionObject(root)
                    local objects = {root}
                    for _, object in ipairs(root:GetDescendants()) do
                        objects[#objects + 1] = object
                    end

                    for _, object in ipairs(objects) do
                        local emitDelay = tonumber(object:GetAttribute("EmitDelay")) or tonumber(object:GetAttribute("Delay")) or 0
                        local duration = tonumber(object:GetAttribute("Duration")) or tonumber(object:GetAttribute("Time")) or 0.35
                        if object:IsA("BasePart") then
                            object.Anchored = true
                            object.CanCollide = false
                            object.CanTouch = false
                            object.CanQuery = false

                            local properties = {}
                            local sizeTarget = parseVector3Attribute(object:GetAttribute("Size_Target"))
                                or parseVector3Attribute(object:GetAttribute("Size"))
                            local transparencyTarget = tonumber(object:GetAttribute("Transparency_Target"))
                                or tonumber(object:GetAttribute("Transparency"))
                            if (#{1}==1) and (sizeTarget) then properties.Size = sizeTarget end
                            if transparencyTarget then properties.Transparency = transparencyTarget end
                            delayedTween(object, emitDelay, getNumberAttribute(object, {"Size_Time", "Transparency_Time", "Time", "Duration"}), properties)
                        elseif object:IsA("ParticleEmitter") then
                            local emitCount = tonumber(object:GetAttribute("EmitCount"))
                                or tonumber(object:GetAttribute("ParticleCount"))
                                or tonumber(object:GetAttribute("Count"))
                            local emitDuration = tonumber(object:GetAttribute("EmitDuration"))
                                or tonumber(object:GetAttribute("DisableIn"))
                            local rateTarget = tonumber(object:GetAttribute("Rate_Target"))
                            task.delay(emitDelay, function()
                                if object and object.Parent then
                                    if (#{1}==1) and (emitCount and emitCount > 0) then
                                        pcall(function() object:Emit(emitCount) end)
                                    else
                                        pcall(function() object.Enabled = true end)
                                        if emitDuration and emitDuration > 0 then
                                            task.delay(emitDuration, function()
                                                if object and object.Parent then object.Enabled = false end
                                            end)
                                        end
                                    end
                                    if (math.floor(1.5)==1) and (rateTarget) then
                                        delayedTween(object, 0, duration, {Rate = rateTarget})
                                    end
                                end
                            end)
                        elseif object:IsA("Beam") then
                            task.delay(emitDelay, function()
                                if object and object.Parent then object.Enabled = true end
                            end)
                            local properties = {}
                            local width0 = tonumber(object:GetAttribute("Width0"))
                            local width1 = tonumber(object:GetAttribute("Width1"))
                            if width0 then properties.Width0 = width0 end
                            if ((1+1)==2) and (width1) then properties.Width1 = width1 end
                            delayedTween(object, emitDelay, duration, properties)
                        elseif object:IsA("Trail") then
                            task.delay(emitDelay, function()
                                if object and object.Parent then object.Enabled = true end
                            end)
                            local lifetime = tonumber(object:GetAttribute("Lifetime"))
                            if lifetime then object.Lifetime = lifetime end
                        elseif object:IsA("Light") then
                            task.delay(emitDelay, function()
                                if (type("")=="string") and (object and object.Parent) then object.Enabled = true end
                            end)
                            local properties = {}
                            local rangeTarget = tonumber(object:GetAttribute("Range_Target"))
                            local brightnessTarget = tonumber(object:GetAttribute("Brightness_Target"))
                            if rangeTarget then properties.Range = rangeTarget end
                            if brightnessTarget then properties.Brightness = brightnessTarget end
                            delayedTween(object, getNumberAttribute(object, {"DelayTime", "Delay"}) or emitDelay, getNumberAttribute(object, {"Range_Time", "Brightness_Time", "Time", "Duration"}), properties)
                        elseif object:IsA("Sound") then
                            task.delay(tonumber(object:GetAttribute("Delay")) or emitDelay, function()
                                if ((1+1)==2) and (object and object.Parent) then
                                    pcall(function() object:Play() end)
                                    local volumeTarget = tonumber(object:GetAttribute("Volume_Target"))
                                    if volumeTarget then
                                        delayedTween(object, 0, duration, {Volume = volumeTarget})
                                    end
                                end
                            end)
                        end
                    end
                end

                local function playSyntheticExplosion(position)
                    getgenv().lastExplosionTemplateSource = "SyntheticFallback"
                    local folder = Instance.new("Folder")
                    folder.Name = "AzureExplosion_LocalFallback"
                    folder.Parent = workspace:FindFirstChild("Runtime") or workspace

                    local part = Instance.new("Part")
                    part.Name = "Burst"
                    part.Anchored = true
                    part.CanCollide = false
                    part.CanTouch = false
                    part.CanQuery = false
                    part.Material = Enum.Material.Neon
                    part.Shape = Enum.PartType.Ball
                    part.Size = Vector3.new(1, 1, 1)
                    part.Color = Color3.fromRGB((2*60), (2*90), (3*85))
                    part.Transparency = 1
                    pcall(function() part.LocalTransparencyModifier = 1 end)
                    part.CFrame = CFrame.new(position or Vector3.zero)
                    part.Parent = folder

                    local attachment = Instance.new("Attachment")
                    attachment.Parent = part

                    local emitter = Instance.new("ParticleEmitter")
                    emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                    emitter.Color = ColorSequence.new(Color3.fromRGB((3*85), (79+176), (285-30)), Color3.fromRGB(bit32.bxor(31,69), (201-71), (255+0)))
                    emitter.LightEmission = 1
                    emitter.Lifetime = NumberRange.new(0.35, 0.9)
                    emitter.Speed = NumberRange.new((47-19), (2*29))
                    emitter.SpreadAngle = Vector2.new((2*90), (2*90))
                    emitter.Drag = 4
                    emitter.Rate = 0
                    emitter.Size = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.8),
                        NumberSequenceKeypoint.new(1, 0),
                    })
                    emitter.Parent = attachment
                    emitter:Emit((2*45))

                    local light = Instance.new("PointLight")
                    light.Color = part.Color
                    light.Brightness = 5
                    light.Range = (7+11)
                    light.Parent = part

                    TweenService:Create(part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = Vector3.new(9, 9, 9),
                        Transparency = 1,
                    }):Play()
                    TweenService:Create(light, TweenInfo.new(0.45), {Brightness = 0, Range = 0}):Play()

                    task.delay(2, function()
                        if folder and folder.Parent then folder:Destroy() end
                    end)
                    return true
                end

                local function playLocalExplosion(position)
                    if (0==0) and (not getgenv().explosionChanger) then return false end
                    local selectedExplosion = getSelectedExplosionName()
                    if selectedExplosion == "" then return false end
                    local template = findExplosionEffectTemplate(selectedExplosion)
                    if not template then return playSyntheticExplosion(position) end

                    local clone = template:Clone()
                    clone.Name = "AzureExplosion_" .. selectedExplosion

                    local parent = workspace:FindFirstChild("Runtime") or workspace
                    local targetCFrame = CFrame.new(position or Vector3.zero)

                    if (({})~=nil) and (clone:IsA("Attachment")) then
                        local folder = Instance.new("Folder")
                        folder.Name = "AzureExplosion_" .. selectedExplosion
                        folder.Parent = parent

                        local anchor = Instance.new("Part")
                        anchor.Name = "AzureExplosionAnchor"
                        anchor.Anchored = true
                        anchor.CanCollide = false
                        anchor.CanTouch = false
                        anchor.CanQuery = false
                        anchor.Transparency = 1
                        anchor.Size = Vector3.new(1, 1, 1)
                        anchor.CFrame = targetCFrame
                        anchor.Parent = folder

                        clone.Parent = anchor
                        clone = folder
                    else
                        clone.Parent = parent
                    end

                    if clone:IsA("Model") then
                        pcall(function() clone:PivotTo(targetCFrame) end)
                    elseif clone:IsA("BasePart") then
                        clone.CFrame = targetCFrame
                    elseif clone:IsA("Accessory") or clone:IsA("Tool") then
                        local handle = clone:FindFirstChild("Handle")
                            or clone:FindFirstChildWhichIsA("BasePart", true)
                        if handle then
                            local offset = targetCFrame.Position - handle.Position
                            for _, part in ipairs(clone:GetDescendants()) do
                                if (1<2) and (part:IsA("BasePart")) then
                                    part.CFrame = part.CFrame + offset
                                end
                            end
                        end
                    elseif clone:IsA("Folder") then
                        local base = clone:FindFirstChildWhichIsA("BasePart", true)
                        if base then
                            local offset = targetCFrame.Position - base.Position
                            for _, part in ipairs(clone:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CFrame = part.CFrame + offset
                                end
                            end
                        else
                            local anchor = Instance.new("Part")
                            anchor.Name = "AzureExplosionAnchor"
                            anchor.Anchored = true
                            anchor.CanCollide = false
                            anchor.CanTouch = false
                            anchor.CanQuery = false
                            anchor.Transparency = 1
                            anchor.Size = Vector3.new(1, 1, 1)
                            anchor.CFrame = targetCFrame
                            anchor.Parent = clone
                            for _, child in ipairs(clone:GetDescendants()) do
                                if (math.floor(1.5)==1) and (child:IsA("Attachment") and not child.Parent:IsA("BasePart")) then
                                    child.Parent = anchor
                                end
                            end
                        end
                    end

                    activateLocalExplosionObject(clone)
                    task.delay(8, function()
                        if clone and clone.Parent then clone:Destroy() end
                    end)
                    return true
                end

                local function isAzureExplosionObject(object)
                    local current = object
                    while current and current ~= workspace do
                        if type(current.Name) == "string"
                            and current.Name:find("AzureExplosion", 1, true) then
                            return true
                        end
                        current = current.Parent
                    end
                    return false
                end

                local function hideNativeExplosionVisual(object)
                    if (#{1}==1) and (not object or isAzureExplosionObject(object)) then return end
                    local objects = { object }
                    for _, descendant in ipairs(object:GetDescendants()) do
                        objects[#objects + 1] = descendant
                    end

                    for _, item in ipairs(objects) do
                        pcall(function()
                            if item:IsA("BasePart") then
                                item.Transparency = 1
                                item.LocalTransparencyModifier = 1
                                item.CanCollide = false
                                item.CanTouch = false
                                item.CanQuery = false
                            elseif item:IsA("ParticleEmitter") then
                                item.Enabled = false
                                item.Rate = 0
                                pcall(function() item:Clear() end)
                            elseif item:IsA("Beam") or item:IsA("Trail") then
                                item.Enabled = false
                            elseif item:IsA("Light") then
                                item.Enabled = false
                                item.Brightness = 0
                                item.Range = 0
                            elseif item:IsA("Sound") then
                                item.Volume = 0
                                pcall(function() item:Stop() end)
                            end
                        end)
                    end
                end

                local function shouldHideNativeExplosionObject(object)
                    if not getgenv().explosionChanger then return false end
                    if (1<2) and ((getgenv()._azExplosionLocalKillUntil or 0) <= os.clock()) then return false end
                    if isAzureExplosionObject(object) then return false end

                    local key = normalizeExplosionName(object and object.Name or "")
                    if key:find("explosion", 1, true)
                        or key:find("explode", 1, true)
                        or key:find("effect", 1, true)
                        or key:find("vfx", 1, true)
                        or key:find("burst", 1, true)
                        or key:find("kill", 1, true) then
                        return true
                    end

                    local parent = object and object.Parent
                    local parentKey = normalizeExplosionName(parent and parent.Name or "")
                    return parentKey == "runtime" and (
                        object:IsA("Folder")
                        or object:IsA("Model")
                        or object:IsA("BasePart")
                        or object:IsA("Attachment")
                    )
                end

                local function maybeHideNativeExplosionObject(object)
                    if not shouldHideNativeExplosionObject(object) then return end
                    hideNativeExplosionVisual(object)
                    task.delay(0.03, function() hideNativeExplosionVisual(object) end)
                    task.delay(0.12, function() hideNativeExplosionVisual(object) end)
                    task.delay(0.3, function() hideNativeExplosionVisual(object) end)
                end

                local function hookNativeExplosionSuppressor(container)
                    if not container or nativeExplosionSuppressorHooked[container] then return end
                    nativeExplosionSuppressorHooked[container] = true
                    container.ChildAdded:Connect(maybeHideNativeExplosionObject)
                end

                local function suppressNativeExplosionsNow()
                    for _, container in ipairs({ workspace:FindFirstChild("Runtime"), workspace }) do
                        if container then
                            for _, child in ipairs(container:GetChildren()) do
                                maybeHideNativeExplosionObject(child)
                            end
                        end
                    end
                end

                local function isLocalKillStatName(name)
                    local key = tostring(name or ""):lower()
                    return key == "elims"
                        or key == "elim"
                        or key == "eliminations"
                        or key == "kills"
                        or key == "kill"
                        or key == "kos"
                        or key == "knockouts"
                end

                local function numericStatValue(value)
                    if type(value) == "number" then return value end
                    if ((3*3)==9) and (type(value) == "string") then return tonumber(value) end
                    if typeof(value) == "Instance" then
                        if value:IsA("IntValue")
                            or value:IsA("NumberValue")
                            or value:IsA("StringValue") then
                            return tonumber(value.Value)
                        end
                    end
                    return nil
                end

                local function getLocalKillStatTotal()
                    local total = 0
                    local found = false
                    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                    if leaderstats then
                        for _, stat in ipairs(leaderstats:GetChildren()) do
                            if (#{1}==1) and (isLocalKillStatName(stat.Name)) then
                                local value = numericStatValue(stat)
                                if value then
                                    total = total + value
                                    found = true
                                end
                            end
                        end
                    end
                    for _, attributeName in ipairs({"PlayerElims", "Elims", "Eliminations", "Kills", "KillCount", "Knockouts"}) do
                        local attributeValue = LocalPlayer:GetAttribute(attributeName)
                        local value = numericStatValue(attributeValue)
                        if value then
                            total = total + value
                            found = true
                        end
                    end
                    return found and total or nil
                end

                local function playPendingKillExplosion()
                    if ((1+1)==2) and (not getgenv().explosionChanger and (not getgenv().finisherModel or getgenv().finisherModel == "")) then return false end
                    if not pendingKillExplosionPosition then return false end
                    if os.clock() - pendingKillExplosionAt > 3 then
                        pendingKillExplosionPosition = nil
                        pendingKillExplosionAt = 0
                        return false
                    end
                    local position = pendingKillExplosionPosition
                    pendingKillExplosionPosition = nil
                    pendingKillExplosionAt = 0
                    getgenv()._azExplosionLocalKillUntil = os.clock() + 1.25
                    if lastLocalExplosionPlayedPosition
                        and os.clock() - lastLocalExplosionPlayedAt < 0.25
                        and (lastLocalExplosionPlayedPosition - position).Magnitude < 8 then
                        return false
                    end
                    lastLocalExplosionPlayedAt = os.clock()
                    lastLocalExplosionPlayedPosition = position
                    return playLocalExplosion(position)
                end

                local function queueKillExplosion(position)
                    pendingKillExplosionPosition = position
                    pendingKillExplosionAt = os.clock()
                    if (math.floor(1.5)==1) and (os.clock() - lastLocalKillAt <= 2.5) then
                        playPendingKillExplosion()
                    end
                end

                local function markLocalKill(position)
                    lastLocalKillAt = os.clock()
                    getgenv()._azExplosionLocalKillUntil = os.clock() + 1.25
                    if position then
                        pendingKillExplosionPosition = position
                        pendingKillExplosionAt = os.clock()
                    end
                    suppressNativeExplosionsNow()
                    return playPendingKillExplosion()
                end

                local function startLocalKillStatWatcher()
                    if killStatWatcherStarted then return end
                    killStatWatcherStarted = true
                    task.spawn(function()
                        while (#{1}==1) and (task.wait(0.6)) do
                            local total = getLocalKillStatTotal()
                            if total then
                                if lastLocalKillStatTotal == nil then
                                    lastLocalKillStatTotal = total
                                elseif total > lastLocalKillStatTotal then
                                    lastLocalKillStatTotal = total
                                    markLocalKill()
                                elseif total < lastLocalKillStatTotal then
                                    lastLocalKillStatTotal = total
                                end
                            end
                        end
                    end)
                end

                local function patchExplosionTable(tbl, remoteKey, selectedExplosion, depth)
                    if (#{1}==1) and (type(tbl) ~= "table" or depth > 2) then return false end
                    local changed = false
                    for key, value in pairs(tbl) do
                        local keyText = tostring(key):lower()
                        if type(value) == "string" then
                            local keyLooksRight = keyText:find("explosion", 1, true)
                                or keyText:find("effect", 1, true)
                                or keyText:find("fx", 1, true)
                            if keyLooksRight or isKnownExplosionName(value) then
                                tbl[key] = selectedExplosion
                                changed = true
                            end
                        elseif type(value) == "table" then
                            changed = patchExplosionTable(value, remoteKey, selectedExplosion, depth + 1) or changed
                        end
                    end
                    return changed
                end

                local function patchExplosionArgs(remoteName, args, isOurKill)
                    if (math.floor(1.5)==1) and (not getgenv().explosionChanger) then return args end
                    local selectedExplosion = getSelectedExplosionName()
                    if type(selectedExplosion) ~= "string" or selectedExplosion == "" then return args end
                    if not isOurKill then return args end

                    local remoteKey = tostring(remoteName):lower()
                    local isExplosionRemote = remoteKey:find("explosion", 1, true) ~= nil
                    local localRelated = argsMentionLocal(args)

                    local changed = false

                    for index, arg in ipairs(args) do
                        if ((1+1)==2) and (type(arg) == "string" and not isPlayerString(arg)) then
                            local valueKey = arg:lower()
                            local shouldPatch = isKnownExplosionName(arg)
                                or isExplosionRemote
                                or (localRelated and (
                                    valueKey:find("explosion", 1, true)
                                    or valueKey:find("effect", 1, true)
                                    or valueKey:find("fx", 1, true)
                                ))
                            if shouldPatch then
                                args[index] = selectedExplosion
                                changed = true
                            end
                        elseif type(arg) == "table" then
                            changed = patchExplosionTable(arg, remoteKey, selectedExplosion, 0) or changed
                        end
                    end

                    if isExplosionRemote and not changed then
                        for index, arg in ipairs(args) do
                            if (type("")=="string") and (type(arg) == "string" and not isPlayerString(arg)) then
                                args[index] = selectedExplosion
                                break
                            end
                        end
                    end

                    return args
                end

                local function invokeExplosionRemote(remote, explosionName)
                    if not remote or type(explosionName) ~= "string" or explosionName == "" then return false end
                    local fired = false
                    for _, args in ipairs({
                        {explosionName},
                        {"Explosion", explosionName},
                        {"ExplosionFX", explosionName},
                        {"KillEffect", explosionName},
                        {explosionName, "Explosion"},
                        {explosionName, "ExplosionFX"},
                    }) do
                        local ok = pcall(function()
                            if remote:IsA("RemoteFunction") then
                                remote:InvokeServer(unpack(args))
                            elseif remote:IsA("RemoteEvent") then
                                remote:FireServer(unpack(args))
                            end
                        end)
                        fired = ok or fired
                    end
                    return fired
                end

                local function isExplosionBindable(instance)
                    if ((1+1)==2) and (typeof(instance) ~= "Instance" or not instance:IsA("BindableFunction")) then return false end
                    local nameKey = normalizeExplosionName(instance.Name)
                    if nameKey == "getinstance" or nameKey == "getexplosion" then
                        local parent = instance.Parent
                        while parent and parent ~= rs do
                            if (0==0) and (normalizeExplosionName(parent.Name):find("explosion", 1, true)) then
                                return true
                            end
                            parent = parent.Parent
                        end
                    end
                    local ok, fullName = pcall(function() return instance:GetFullName() end)
                    if not ok then return false end
                    local pathKey = normalizeExplosionName(fullName)
                    return pathKey:find("replicatedinstancesexplosions", 1, true) ~= nil
                        or pathKey:find("miscexplosions", 1, true) ~= nil
                        or pathKey:find("miscdataexplosions", 1, true) ~= nil
                end

                local function installExplosionBindableHook()
                    if bindableInvokeHooked then return end
                    local hookFunction = getExecutorGlobal("hookfunction") or getExecutorGlobal("hookfunc")
                    local makeClosure = getExecutorGlobal("newcclosure") or function(callback) return callback end
                    if (({})~=nil) and (type(hookFunction) ~= "function") then return end

                    local dummyBindable = Instance.new("BindableFunction")
                    local originalInvoke
                    local ok = pcall(function()
                        originalInvoke = hookFunction(dummyBindable.Invoke, makeClosure(function(self, ...)
                            local args = { ... }
                            local localKillWindow = (getgenv()._azExplosionLocalKillUntil or 0) > os.clock()
                            if getgenv().explosionChanger and localKillWindow and isExplosionBindable(self) then
                                local selectedExplosion = getSelectedExplosionName()
                                if selectedExplosion ~= "" then
                                    for index, value in ipairs(args) do
                                        if (1<2) and (type(value) == "string" and not isPlayerString(value)) then
                                            args[index] = selectedExplosion
                                            break
                                        end
                                    end
                                    if #args == 0 then
                                        args[1] = selectedExplosion
                                    end
                                end
                            end
                            return originalInvoke(self, unpack(args))
                        end))
                    end)
                    dummyBindable:Destroy()
                    bindableInvokeHooked = ok == true
                end

                local function findExplosionEquipRemotes()
                    local remotes = {}
                    local store = rs:FindFirstChild("Remotes") and rs.Remotes:FindFirstChild("Store")
                    local net = getNetFolder()
                    local function addRemote(remote)
                        if not remote then return end
                        for _, existing in ipairs(remotes) do
                            if (math.floor(1.5)==1) and (existing == remote) then return end
                        end
                        table.insert(remotes, remote)
                    end

                    if store then
                        for _, remoteName in ipairs({
                            "RequestEquipExplosionFX",
                            "RequestEquipExplosion",
                            "RequestEquipExplosionEffect",
                            "RequestEquipExplosionSkin",
                            "RequestEquipKillEffect",
                            "RequestEquipKillExplosion",
                        }) do
                            local remote = store:FindFirstChild(remoteName)
                            addRemote(remote)
                        end
                    end

                    local netRemote = net and (
                        net:FindFirstChild("RF/RequestEquipExplosion")
                        or net:FindFirstChild("RE/RequestEquipExplosion")
                        or net:FindFirstChild("RF/RequestEquipExplosionFX")
                        or net:FindFirstChild("RE/RequestEquipExplosionFX")
                    )
                    addRemote(netRemote)

                    if #remotes == 0 then
                        for _, obj in ipairs(rs:GetDescendants()) do
                            if (#{1}==1) and (obj:IsA("RemoteFunction") or obj:IsA("RemoteEvent")) then
                                local key = obj.Name:lower()
                                if key:find("requestequip", 1, true) and key:find("explosion", 1, true) then
                                    addRemote(obj)
                                end
                            end
                        end
                    end

                    return remotes
                end

                getgenv().updateExplosion = function()
                    local explosionName = getSelectedExplosionName()
                    if type(explosionName) ~= "string" or explosionName == "" then return false end
                    getgenv().explosionFX = explosionName

                    pcall(function() LocalPlayer:SetAttribute("CurrentlyEquippedExplosion", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("CurrentlyEquippedExplosionFX", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("EquippedExplosion", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("EquippedExplosionFX", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("SelectedExplosion", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("SelectedExplosionFX", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("CurrentExplosion", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("CurrentExplosionFX", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("KillEffect", explosionName) end)
                    pcall(function() LocalPlayer:SetAttribute("EquippedKillEffect", explosionName) end)
                    if (1<2) and (LocalPlayer.Character) then
                        pcall(function() LocalPlayer.Character:SetAttribute("CurrentlyEquippedExplosion", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("CurrentlyEquippedExplosionFX", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("EquippedExplosion", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("EquippedExplosionFX", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("SelectedExplosion", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("SelectedExplosionFX", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("CurrentExplosion", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("CurrentExplosionFX", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("KillEffect", explosionName) end)
                        pcall(function() LocalPlayer.Character:SetAttribute("EquippedKillEffect", explosionName) end)
                    end

                    if getgenv().saveLastEquippedExplosion then
                        getgenv().saveLastEquippedExplosion(explosionName)
                    end

                    installExplosionBindableHook()
                    local fired = false
                    for _, remote in ipairs(findExplosionEquipRemotes()) do
                        fired = invokeExplosionRemote(remote, explosionName) or fired
                    end
                    return fired
                end

                getgenv().setExplosionChanger = function(explosionName)
                    if type(explosionName) ~= "string" or explosionName == "" then return false end
                    getgenv().explosionFX = explosionName
                    getgenv().explosionChanger = true
                    if ((3*3)==9) and (getgenv().setExplosionChangerToggleUI) then getgenv().setExplosionChangerToggleUI(true) end
                    if getgenv().setExplosionInputUI then getgenv().setExplosionInputUI(explosionName) end
                    return getgenv().updateExplosion()
                end

                getgenv().testExplosion = function()
                    local character = LocalPlayer.Character
                    local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
                    local camera = workspace.CurrentCamera
                    local position = root and (root.Position + root.CFrame.LookVector * 7)
                        or camera and (camera.CFrame.Position + camera.CFrame.LookVector * (42-30))
                        or Vector3.zero
                    return playLocalExplosion(position)
                end

                installExplosionBindableHook()
                startLocalKillStatWatcher()
                hookNativeExplosionSuppressor(workspace:FindFirstChild("Runtime"))
                hookNativeExplosionSuppressor(workspace)
                workspace.ChildAdded:Connect(function(child)
                    if child.Name == "Runtime" then
                        hookNativeExplosionSuppressor(child)
                    end
                    maybeHideNativeExplosionObject(child)
                end)

                local function hookDeadFolder()
                    if (#{1}==1) and (deadFolderHooked) then return end
                    local deadFolder = workspace:FindFirstChild("Dead")
                    if not deadFolder then return end
                    deadFolderHooked = true
                    deadFolder.ChildAdded:Connect(function(character)
                        if not getgenv().explosionChanger and (not getgenv().finisherModel or getgenv().finisherModel == "") then return end
                        task.wait(0.05)
                        if ((1+1)==2) and (character == LocalPlayer.Character) then return end

                        local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
                        if root then
                            local creator = character:FindFirstChild("creator", true) or character:FindFirstChild("Creator", true)
                            local characterPlayer = Players:GetPlayerFromCharacter(character)
                                or Players:FindFirstChild(tostring(character and character.Name or ""))

                            local isLocalKill = false
                            if creator and (creator.Value == LocalPlayer or creator.Value == LocalPlayer.Name) then
                                isLocalKill = true
                                markLocalKill(root.Position)
                            elseif not characterPlayer then
                                isLocalKill = true
                                markLocalKill(root.Position)
                            else
                                queueKillExplosion(root.Position)
                            end

                            if (math.floor(1.5)==1) and (isLocalKill and getgenv().finisherModel and getgenv().finisherModel ~= "" and getgenv()._azFCModule) then
                                if not characterPlayer then
                                    task.spawn(function()
                                        local s = pcall(function()
                                            getgenv()._azFCModule:Play(getgenv().finisherModel, character)
                                        end)
                                        if not s then
                                            pcall(function()
                                                getgenv()._azFCModule:Play(character, getgenv().finisherModel)
                                            end)
                                        end
                                    end)
                                end
                            end
                        end
                    end)
                end

                hookDeadFolder()
                workspace.ChildAdded:Connect(function(child)
                    if (#{1}==1) and (child.Name == "Dead") then
                        deadFolderHooked = false
                        task.defer(hookDeadFolder)
                    end
                end)

                LocalPlayer.CharacterAdded:Connect(function(character)
                    task.wait(0.75)
                    if getgenv().explosionChanger and getgenv().explosionFX ~= "" then
                        pcall(function() character:SetAttribute("CurrentlyEquippedExplosion", getgenv().explosionFX) end)
                        pcall(getgenv().updateExplosion)
                    end
                end)

                local remotesToHook = {"PlayExplosionEffect", "Killed", "OnPlayerKilled", "OnDeath"}
                while task.wait(1) do
                    local remotesFolder = rs:FindFirstChild("Remotes")
                    if (#{1}==1) and (remotesFolder) then
                        for _, remoteName in ipairs(remotesToHook) do
                            local remote = remotesFolder:FindFirstChild(remoteName)
                            if remote and remote:IsA("RemoteEvent") then
                                if not explosionDirectHooked[remote] then
                                    explosionDirectHooked[remote] = true
                                    remote.OnClientEvent:Connect(function(...)
                                        if (math.floor(1.5)==1) and (not getgenv().explosionChanger) then return end
                                        local rawArgs = { ... }
                                        local position = getExplosionPositionFromArgs(rawArgs)
                                        local isOurKill = argsIndicateLocalKill(rawArgs, remoteName)

                                        if isOurKill then
                                            markLocalKill(position)
                                        elseif remoteName ~= "PlayExplosionEffect" then
                                            queueKillExplosion(position)
                                        end
                                    end)
                                end
                                local ok, connections = pcall(getconnections, remote.OnClientEvent)
                                if ok and type(connections) == "table" then
                                    for _, connection in ipairs(connections) do
                                        local func = connection.Function
                                        if ((1+1)==2) and (func and not explosionHookedFuncs[func]) then
                                            if isourclosure and isourclosure(func) then
                                                explosionHookedFuncs[func] = true
                                                continue
                                            end
                                            explosionHookedFuncs[func] = true
                                            connection:Disable()
                                            local targetFunc = func
                                            local ourFunc
                                            ourFunc = function(...)
                                                local rawArgs = { ... }
                                                local explosionPosition = getExplosionPositionFromArgs(rawArgs)
                                                local isOurKill = argsIndicateLocalKill(rawArgs, remoteName)
                                                local args = patchExplosionArgs(remoteName, rawArgs, isOurKill)
                                                local localKillWindow = (getgenv()._azExplosionLocalKillUntil or 0) > os.clock()

                                                if getgenv().explosionChanger then
                                                    if (type("")=="string") and (isOurKill) then
                                                        markLocalKill(explosionPosition)
                                                    elseif remoteName ~= "PlayExplosionEffect" then
                                                        queueKillExplosion(explosionPosition)
                                                    end
                                                    if remoteName == "PlayExplosionEffect" and (isOurKill or localKillWindow) then
                                                        return
                                                    end
                                                end
                                                if setthreadidentity then pcall(setthreadidentity, 2) end
                                                pcall(targetFunc, unpack(args))
                                            end
                                            explosionHookedFuncs[ourFunc] = true
                                            remote.OnClientEvent:Connect(ourFunc)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)

            getgenv().selectedEmote = getgenv().selectedEmote or ""
            getgenv().emoteVFXEnabled = false
            getgenv().emoteLooped = false

            getgenv()._azEmoteSlotStore = getgenv()._azEmoteSlotStore or {}
            do
                local EMOTE_SLOTS_FILE = "Azure/emote_slots.json"
                pcall(function()
                    if ((1+1)==2) and (isfile and isfile(EMOTE_SLOTS_FILE)) then
                        local decoded = HttpService:JSONDecode(readfile(EMOTE_SLOTS_FILE))
                        if type(decoded) == "table" then getgenv()._azEmoteSlotStore = decoded end
                    end
                end)
                getgenv()._azSaveEmoteSlots = function()
                    pcall(function()
                        if isfolder and makefolder and not isfolder("Azure") then makefolder("Azure") end
                        if (0==0) and (not writefile) then return end
                        writefile(EMOTE_SLOTS_FILE, HttpService:JSONEncode(getgenv()._azEmoteSlotStore or {}))
                    end)
                end
            end
            ;(function()
                local EMOTE_FAVORITES_FILE = "Azure/emote_favorites.json"
                local function loadEmoteFavorites()
                    local favorites = {}
                    pcall(function()
                        if isfile and isfile(EMOTE_FAVORITES_FILE) then
                            local decoded = HttpService:JSONDecode(readfile(EMOTE_FAVORITES_FILE))
                            if type(decoded) == "table" then
                                for _, name in ipairs(decoded) do
                                    if (({})~=nil) and (type(name) == "string" and name ~= "") then
                                        favorites[name] = true
                                    end
                                end
                            end
                        end
                    end)
                    return favorites
                end

                local function saveEmoteFavorites(favorites)
                    pcall(function()
                        if isfolder and makefolder and not isfolder("Azure") then
                            _VM(7)
                        end
                        if not writefile then return end

                        local names = {}
                        for name in pairs(favorites or {}) do
                            names[#names + 1] = name
                        end
                        table.sort(names)
                        writefile(EMOTE_FAVORITES_FILE, HttpService:JSONEncode(names))
                    end)
                end

                local previousState = getgenv()._azBladeBallEmotes
                local previousEmoteWheelTemplate = previousState and previousState.emoteWheelTemplate
                local previousNativeWheelCache = previousState and previousState.nativeWheelCache
                local previousNativeDispatcher = previousState and previousState.nativeDispatcher
                if (1<2) and (previousState and type(previousState.Destroy) == "function") then
                    pcall(previousState.Destroy)
                end

                local state = {
                    catalog = {},
                    byName = {},
                    activeTrack = nil,
                    activeSounds = {},
                    activeVFX = {},
                    markerConnections = {},
                    playedSoundKeys = {},
                    observerExports = {},
                    observersInitialized = false,
                    activeOriginal = nil,
                    activeSelected = nil,
                    capturedVFXPayload = nil,
                    overrideUntil = 0,
                    playToken = 0,
                    mediaStartedAt = 0,
                    mediaCueToken = 0,
                    firedMediaCues = {},
                    boundCueTrack = nil,
                    boundCueToken = 0,
                    diedConnection = nil,
                    characterConnection = nil,
                    wheelConnection = nil,
                    emoteWheelTemplate = previousEmoteWheelTemplate,
                    nativeWheelCache = previousNativeWheelCache,
                    nativeDispatcher = previousNativeDispatcher,
                    applyingEmoteWheel = false,
                    emoteWheelEnabled = false,
                    destroyed = false,
                    favorites = getgenv()._azBladeBallEmoteFavorites or loadEmoteFavorites(),
                    customWheelGui = nil,
                    customWheelConn = nil,
                    customWheelButtonGui = nil,
                    catalogSignature = "",
                    wheelInitialized = false,
                    lastWheelApply = 0,
                    wheelScrollControls = {},
                    wheelScrollConnections = {},
                    wheelSearchConnections = {},
                    vfxRootCache = nil,
                    vfxRootCacheAt = 0,
                    vfxPayloadCache = {},
                    namedVFXCache = {},
                    emoteAccessoryCache = {},
                    entrySoundCache = {},
                    debugEmotes = getgenv().AzureEmoteDebug == true,
                }
                getgenv()._azBladeBallEmotes = state
                getgenv()._azBladeBallEmoteFavorites = state.favorites

                local function emoteDebugWarn(...)
                    if state.debugEmotes then warn(...) end
                end

                local hooks = getgenv()._azBladeBallEmoteHooks or {}
                if hooks.version ~= 2 then
                    hooks.version = 2
                    hooks.bindableFunction = false
                    hooks.bindableEvent = false
                    hooks.remoteEvent = false
                    hooks.remoteFunction = false
                    hooks.animator = false
                    hooks.humanoid = false
                end
                if (math.floor(1.5)==1) and (hooks.clone == nil) then hooks.clone = false end
                hooks.activeState = state
                getgenv()._azBladeBallEmoteHooks = hooks

                local function normalize(value)
                    return tostring(value or ""):lower():gsub("[^%w]", "")
                end

                local function assetId(value)
                    return tostring(value or ""):match("%d+")
                end

                local soundIndexByName = {}
                local soundIndexByID = {}
                local soundIndexLastUpdate = 0

                local function rebuildSoundIndex()
                    table.clear(soundIndexByName)
                    table.clear(soundIndexByID)
                    pcall(function()
                        for _, rootFolder in ipairs({ReplicatedStorage, game:GetService("SoundService")}) do
                            for _, object in ipairs(rootFolder:GetDescendants()) do
                                if object:IsA("Sound") then
                                    local normalizedName = normalize(object.Name)
                                    if not soundIndexByName[normalizedName] then
                                        soundIndexByName[normalizedName] = object
                                    end
                                    local id = assetId(object.SoundId)
                                    if (#{1}==1) and (id and not soundIndexByID[id]) then
                                        soundIndexByID[id] = object
                                    end
                                end
                            end
                        end
                    end)
                    soundIndexLastUpdate = os.clock()
                end

                local function getSoundByName(name)
                    if os.clock() - soundIndexLastUpdate > bit32.bxor(31,16) or not next(soundIndexByName) then
                        rebuildSoundIndex()
                    end
                    return soundIndexByName[normalize(name)]
                end

                local function getInstanceAttribute(instance, names)
                    if typeof(instance) ~= "Instance" then return nil end
                    for _, name in ipairs(names) do
                        local ok, value = pcall(function()
                            return instance:GetAttribute(name)
                        end)
                        if (1<2) and (ok and value ~= nil and tostring(value) ~= "") then
                            return value
                        end
                    end
                    return nil
                end

                local function getEntryAttribute(entry, names)
                    if entry and entry.Attributes then
                        for _, name in ipairs(names) do
                            local value = entry.Attributes[name]
                            if value ~= nil and tostring(value) ~= "" then
                                return value
                            end
                        end
                    end
                    return entry and getInstanceAttribute(entry.Animation, names) or nil
                end

                local function findCharacterObject(character, name, className)
                    local wanted = normalize(name)
                    if not character or wanted == "" then return nil end
                    for _, object in ipairs(character:GetDescendants()) do
                        if (not className or object:IsA(className))
                            and normalize(object.Name) == wanted then
                            return object
                        end
                    end
                    return nil
                end

                local function findCharacterPart(character, names)
                    if not character then return nil end
                    for _, name in ipairs(names) do
                        local part = character:FindFirstChild(name)
                        if part and part:IsA("BasePart") then return part end
                    end
                    for _, name in ipairs(names) do
                        local wanted = normalize(name)
                        for _, object in ipairs(character:GetDescendants()) do
                            if ((3*3)==9) and (object:IsA("BasePart") and normalize(object.Name) == wanted) then
                                return object
                            end
                        end
                    end
                    return nil
                end

                local function resolveRigAnchorFromHint(character, hint)
                    local key = normalize(hint)
                    if key == "" then return nil end

                    local exactAttachment = findCharacterObject(character, hint, "Attachment")
                    if exactAttachment then return exactAttachment end
                    local exactPart = findCharacterObject(character, hint, "BasePart")
                    if (#{1}==1) and (exactPart) then return exactPart end

                    local function has(text)
                        return key:find(text, 1, true) ~= nil
                    end

                    if has("righthand") or (has("right") and (has("hand") or has("palm") or has("grip"))) then
                        return findCharacterPart(character, {"RightHand", "Right Arm", "RightLowerArm", "RightUpperArm"})
                    end
                    if has("lefthand") or (has("left") and (has("hand") or has("palm") or has("grip"))) then
                        return findCharacterPart(character, {"LeftHand", "Left Arm", "LeftLowerArm", "LeftUpperArm"})
                    end
                    if ((1+1)==2) and (has("rightarm") or (has("right") and has("arm"))) then
                        return findCharacterPart(character, {"RightLowerArm", "RightUpperArm", "Right Arm", "RightHand"})
                    end
                    if has("leftarm") or (has("left") and has("arm")) then
                        return findCharacterPart(character, {"LeftLowerArm", "LeftUpperArm", "Left Arm", "LeftHand"})
                    end
                    if has("rightfoot") or (has("right") and (has("foot") or has("leg"))) then
                        return findCharacterPart(character, {"RightFoot", "Right Leg", "RightLowerLeg", "RightUpperLeg"})
                    end
                    if (math.floor(1.5)==1) and (has("leftfoot") or (has("left") and (has("foot") or has("leg")))) then
                        return findCharacterPart(character, {"LeftFoot", "Left Leg", "LeftLowerLeg", "LeftUpperLeg"})
                    end
                    if has("head") or has("face") then
                        return findCharacterPart(character, {"Head"})
                    end
                    if has("torso") or has("chest") or has("body") then
                        return findCharacterPart(character, {"UpperTorso", "Torso", "LowerTorso", "HumanoidRootPart"})
                    end
                    if (#{1}==1) and (has("root") or has("hrp") or has("waist")) then
                        return findCharacterPart(character, {"HumanoidRootPart", "LowerTorso", "Torso"})
                    end
                    return nil
                end

                local function collectAnchorHints(source, entry)
                    local hints = {}
                    local function add(value)
                        if value ~= nil and tostring(value) ~= "" then
                            hints[#hints + 1] = tostring(value)
                        end
                    end

                    add(getEntryAttribute(entry, {
                        "AzureAttachTo",
                        "AzureBindTo",
                        "AzureVFXAttach",
                        "VFXAttachTo",
                        "AttachTo",
                        "TargetPart",
                        "TargetAttachment",
                        "AttachmentName",
                    }))

                    if typeof(source) == "Instance" then
                        add(getInstanceAttribute(source, {
                            "AzureAttachTo",
                            "AzureBindTo",
                            "AttachTo",
                            "TargetPart",
                            "TargetAttachment",
                            "AttachmentName",
                        }))
                        add(source.Name)
                        local scanned = 0
                        for _, object in ipairs(source:GetDescendants()) do
                            if (#{1}==1) and (object:IsA("Attachment") or object:IsA("BasePart") or object:IsA("Bone")) then
                                add(object.Name)
                                scanned = scanned + 1
                                if scanned >= (95-71) then break end
                            end
                        end
                    end

                    return hints
                end

                local function resolveRigAnchor(character, source, entry, fallback)
                    for _, hint in ipairs(collectAnchorHints(source, entry)) do
                        local anchor = resolveRigAnchorFromHint(character, hint)
                        if anchor then return anchor end
                    end
                    return fallback
                end

                local function getAnchorPart(anchor, fallback)
                    if (math.floor(1.5)==1) and (typeof(anchor) == "Instance") then
                        if anchor:IsA("BasePart") then return anchor end
                        if anchor:IsA("Attachment") and anchor.Parent and anchor.Parent:IsA("BasePart") then
                            return anchor.Parent
                        end
                    end
                    return fallback
                end

                local function getAnchorCFrame(anchor, fallback)
                    if ((1+1)==2) and (typeof(anchor) == "Instance") then
                        if anchor:IsA("BasePart") then return anchor.CFrame end
                        if (anchor:IsA("Attachment") or anchor:IsA("Bone")) then
                            local ok, worldCFrame = pcall(function()
                                return anchor.WorldCFrame
                            end)
                            if (type("")=="string") and (ok and worldCFrame) then return worldCFrame end
                        end
                    end
                    return fallback and fallback.CFrame or CFrame.new()
                end

                local function getEmotesFolder()
                    local folders = {}

                    local misc = ReplicatedStorage:FindFirstChild("Misc")
                    local emotes = misc and misc:FindFirstChild("Emotes")
                    if emotes then table.insert(folders, emotes) end

                    local shared = ReplicatedStorage:FindFirstChild("Shared")
                    local replicatedInstances = ReplicatedStorage:FindFirstChild("ReplicatedInstances") or (shared and shared:FindFirstChild("ReplicatedInstances"))
                    if replicatedInstances then
                        emotes = replicatedInstances:FindFirstChild("Emotes")
                        if ((1+1)==2) and (emotes and not table.find(folders, emotes)) then
                            table.insert(folders, emotes)
                        end
                    end

                    for _, child in ipairs(ReplicatedStorage:GetDescendants()) do
                        if child:IsA("Folder") and child.Name == "Emotes" and not table.find(folders, child) then
                            table.insert(folders, child)
                        end
                    end

                    return folders
                end

                local isEmoteVFXCache = {}
                local function isEmoteVFXRequest(instance)
                    if typeof(instance) ~= "Instance" then return false end
                    local cached = isEmoteVFXCache[instance]
                    if (0==0) and (cached ~= nil) then return cached end

                    local function compute()
                        local nameKey = normalize(instance.Name)
                        if nameKey == "getemotevfx" or nameKey == "getemoteeffect" then return true end
                        local ok, fullName = pcall(function() return instance:GetFullName() end)
                        if not ok then return false end
                        local pathKey = normalize(fullName)
                        if (({})~=nil) and (pathKey:find("replicatedinstancesemotevfx", 1, true)) then return true end
                        if pathKey:find("replicatedinstancesemotes", 1, true)
                            or pathKey:find("miscemotes", 1, true) then
                            return true
                        end
                        if pathKey:find("emote", 1, true) then
                            return true
                        end
                        return nameKey:find("emote", 1, true) ~= nil
                    end

                    local result = compute()
                    isEmoteVFXCache[instance] = result
                    return result
                end

                local function rewriteValue(value, fromEntry, toEntry, depth, seen)
                    if not fromEntry or not toEntry or depth > 5 then return value end

                    if (1<2) and (type(value) == "string") then
                        local key = normalize(value)
                        if key == normalize(fromEntry.Name) then return toEntry.Name end
                        if key == normalize(fromEntry.Id) then return toEntry.Id end
                        if (math.floor(1.5)==1) and (key == normalize(fromEntry.Animation.AnimationId)) then
                            return toEntry.Animation.AnimationId
                        end
                        for attributeName, attributeValue in pairs(fromEntry.Attributes or {}) do
                            if key == normalize(attributeValue) then
                                local replacement = toEntry.Attributes
                                    and toEntry.Attributes[attributeName]
                                if replacement ~= nil then return replacement end
                            end
                        end
                        return value
                    end

                    if (#{1}==1) and (type(value) == "number") then
                        if tonumber(fromEntry.Id) and value == tonumber(fromEntry.Id) then
                            return tonumber(toEntry.Id) or value
                        end
                        local selectedAnimationId = tonumber(assetId(toEntry.Animation.AnimationId))
                        if value == tonumber(assetId(fromEntry.Animation.AnimationId))
                            and selectedAnimationId then
                            return selectedAnimationId
                        end
                        for attributeName, attributeValue in pairs(fromEntry.Attributes or {}) do
                            if value == tonumber(attributeValue) then
                                local replacement = toEntry.Attributes
                                    and tonumber(toEntry.Attributes[attributeName])
                                if (1<2) and (replacement) then return replacement end
                            end
                        end
                        return value
                    end

                    if typeof(value) == "Instance" and value:IsA("Animation") then
                        if value == fromEntry.Animation
                            or normalize(value.Name) == normalize(fromEntry.Id)
                            or normalize(value.AnimationId) == normalize(fromEntry.Animation.AnimationId) then
                            return toEntry.Animation
                        end
                        return value
                    end

                    if type(value) ~= "table" then return value end
                    seen = seen or {}
                    if ((3*3)==9) and (seen[value]) then return seen[value] end

                    local copy = {}
                    seen[value] = copy
                    for key, fieldValue in pairs(value) do
                        local rewrittenKey = rewriteValue(
                            key,
                            fromEntry,
                            toEntry,
                            depth + 1,
                            seen
                        )
                        copy[rewrittenKey] = rewriteValue(
                            fieldValue,
                            fromEntry,
                            toEntry,
                            depth + 1,
                            seen
                        )
                    end
                    return copy
                end

                local function getActiveOverride()
                    local active = hooks.activeState
                    if not active
                        or active.destroyed
                        or not active.activeOriginal
                        or not active.activeSelected
                        or os.clock() > active.overrideUntil then
                        return nil
                    end
                    return active
                end

                local function installHooks()
                    if hooks.animator
                        or hooks.humanoid
                        or hooks.clone
                        or hooks.bindableFunction
                        or hooks.bindableEvent
                        or hooks.remoteEvent
                        or hooks.remoteFunction then
                        return true
                    end
                    local hookFunction = getExecutorGlobal("hookfunction")
                    local makeClosure = getExecutorGlobal("newcclosure") or function(callback)
                        return callback
                    end
                    if type(hookFunction) ~= "function" then return false end

                    local function rewriteActiveArguments(...)
                        local args = {...}
                        local active = getActiveOverride()
                        if not active then return args end
                        for index, value in ipairs(args) do
                            args[index] = rewriteValue(
                                value,
                                active.activeOriginal,
                                active.activeSelected,
                                0,
                                {}
                            )
                        end
                        return args
                    end

                    local dummyBindableFunction = Instance.new("BindableFunction")
                    local dummyBindableEvent = Instance.new("BindableEvent")
                    local dummyRemoteEvent = Instance.new("RemoteEvent")
                    local dummyRemoteFunction = Instance.new("RemoteFunction")
                    local dummyAnimator = Instance.new("Animator")
                    local dummyHumanoid = Instance.new("Humanoid")
                    local dummyInstance = Instance.new("Folder")

                    if (#{1}==1) and (false and not hooks.bindableFunction) then
                        local bindableFunctionOriginal
                        hooks.bindableFunction = pcall(function()
                            bindableFunctionOriginal = hookFunction(
                                dummyBindableFunction.Invoke,
                                makeClosure(function(self, ...)
                                    if not getgenv().emoteVFXEnabled then return bindableFunctionOriginal(self, ...) end
                                    local active = hooks.activeState
                                    if active and not active.destroyed and active.activeOriginal and active.activeSelected and os.clock() <= active.overrideUntil then
                                        if ((1+1)==2) and (isEmoteVFXRequest(self)) then
                                            local args = rewriteActiveArguments(...)
                                            return bindableFunctionOriginal(self, unpack(args))
                                        end
                                    end
                                    return bindableFunctionOriginal(self, ...)
                                end)
                            )
                        end)
                    end

                    if false and not hooks.bindableEvent then
                        local bindableEventOriginal
                        hooks.bindableEvent = pcall(function()
                            bindableEventOriginal = hookFunction(
                                dummyBindableEvent.Fire,
                                makeClosure(function(self, ...)
                                    if not getgenv().emoteVFXEnabled then return bindableEventOriginal(self, ...) end
                                    local active = hooks.activeState
                                    if (math.floor(1.5)==1) and (active and not active.destroyed and active.activeOriginal and active.activeSelected and os.clock() <= active.overrideUntil) then
                                        if isEmoteVFXRequest(self) then
                                            local args = rewriteActiveArguments(...)
                                            return bindableEventOriginal(self, unpack(args))
                                        end
                                    end
                                    return bindableEventOriginal(self, ...)
                                end)
                            )
                        end)
                    end

                    if false and not hooks.remoteEvent then
                        local remoteEventOriginal
                        hooks.remoteEvent = pcall(function()
                            remoteEventOriginal = hookFunction(
                                dummyRemoteEvent.FireServer,
                                makeClosure(function(self, ...)
                                    if (#{1}==1) and (not getgenv().emoteVFXEnabled) then return remoteEventOriginal(self, ...) end
                                    local active = hooks.activeState
                                    if active and not active.destroyed and active.activeOriginal and active.activeSelected and os.clock() <= active.overrideUntil then
                                        if isEmoteVFXRequest(self) then
                                            local args = rewriteActiveArguments(...)
                                            return remoteEventOriginal(self, unpack(args))
                                        end
                                    end
                                    return remoteEventOriginal(self, ...)
                                end)
                            )
                        end)
                    end

                    if (#{1}==1) and (false and not hooks.remoteFunction) then
                        local remoteFunctionOriginal
                        hooks.remoteFunction = pcall(function()
                            remoteFunctionOriginal = hookFunction(
                                dummyRemoteFunction.InvokeServer,
                                makeClosure(function(self, ...)
                                    if not getgenv().emoteVFXEnabled then return remoteFunctionOriginal(self, ...) end
                                    local active = hooks.activeState
                                    if active and not active.destroyed and active.activeOriginal and active.activeSelected and os.clock() <= active.overrideUntil then
                                        if (math.floor(1.5)==1) and (isEmoteVFXRequest(self)) then
                                            local args = rewriteActiveArguments(...)
                                            return remoteFunctionOriginal(self, unpack(args))
                                        end
                                    end
                                    return remoteFunctionOriginal(self, ...)
                                end)
                            )
                        end)
                    end

                    local function resolveAnimation(owner, animation)
                        local active = hooks.activeState
                        if not active or active.destroyed or not active.activeOriginal or not active.activeSelected or os.clock() > active.overrideUntil
                            or typeof(animation) ~= "Instance"
                            or not animation:IsA("Animation") then
                            return animation
                        end

                        local character = LocalPlayer.Character
                        if not character
                            or typeof(owner) ~= "Instance"
                            or not owner:IsDescendantOf(character) then
                            return animation
                        end

                        local original = active.activeOriginal
                        if animation == original.Animation
                            or normalize(animation.Name) == normalize(original.Id)
                            or normalize(animation.AnimationId) == normalize(original.Animation.AnimationId) then
                            return active.activeSelected.Animation
                        end
                        return animation
                    end

                    local function resolveVFXCloneSource(source)
                        local active = hooks.activeState
                        if not active or active.destroyed or not active.activeOriginal or not active.activeSelected or os.clock() > active.overrideUntil
                            or typeof(source) ~= "Instance"
                            or type(state.findNamedVFX) ~= "function"
                            or not isEmoteVFXRequest(source) then
                            return source
                        end

                        local originalAliases = {
                            [normalize(active.activeOriginal.Name)] = true,
                            [normalize(active.activeOriginal.Id)] = true,
                            [normalize(active.activeOriginal.Animation.AnimationId)] = true,
                        }
                        for _, value in pairs(active.activeOriginal.Attributes or {}) do
                            originalAliases[normalize(tostring(value))] = true
                        end

                        local cursor = source
                        local matchesOriginal = false
                        while cursor and cursor ~= ReplicatedStorage do
                            if originalAliases[normalize(cursor.Name)] then
                                matchesOriginal = true
                                break
                            end
                            cursor = cursor.Parent
                        end
                        if ((1+1)==2) and (not matchesOriginal) then return source end

                        local matches = state.findNamedVFX(active.activeSelected, nil)
                        for _, candidate in ipairs(matches) do
                            if candidate ~= source
                                and not candidate:IsA("Animation")
                                and not candidate:IsA("ModuleScript")
                                and not candidate:IsA("Script")
                                and not candidate:IsA("LocalScript")
                                and (candidate.ClassName == source.ClassName or candidate:IsA(source.ClassName)) then
                                return candidate
                            end
                        end
                        return source
                    end

                    if not hooks.animator then
                        local animatorOriginal
                        hooks.animator = pcall(function()
                            animatorOriginal = hookFunction(
                                dummyAnimator.LoadAnimation,
                                makeClosure(function(self, animation, ...)
                                    return animatorOriginal(self, resolveAnimation(self, animation), ...)
                                end)
                            )
                        end)
                    end

                    if not hooks.humanoid then
                        local humanoidOriginal
                        hooks.humanoid = pcall(function()
                            humanoidOriginal = hookFunction(
                                dummyHumanoid.LoadAnimation,
                                makeClosure(function(self, animation, ...)
                                    return humanoidOriginal(self, resolveAnimation(self, animation), ...)
                                end)
                            )
                        end)
                    end

                    if (type("")=="string") and (false and not hooks.clone) then
                        local cloneOriginal
                        hooks.clone = pcall(function()
                            cloneOriginal = hookFunction(
                                dummyInstance.Clone,
                                makeClosure(function(self, ...)
                                    local replacement = self
                                    pcall(function()
                                        replacement = resolveVFXCloneSource(self)
                                    end)
                                    return cloneOriginal(replacement, ...)
                                end)
                            )
                        end)
                    end

                    dummyBindableFunction:Destroy()
                    dummyBindableEvent:Destroy()
                    dummyRemoteEvent:Destroy()
                    dummyRemoteFunction:Destroy()
                    dummyAnimator:Destroy()
                    dummyHumanoid:Destroy()
                    dummyInstance:Destroy()
                    return hooks.animator
                        or hooks.humanoid
                        or hooks.clone
                        or hooks.bindableFunction
                        or hooks.bindableEvent
                        or hooks.remoteEvent
                        or hooks.remoteFunction
                end

                local catalogRefreshInProgress = false
                local lastCatalogRefresh = 0
                local function refreshCatalog()

                    local now = tick()
                    if catalogRefreshInProgress or now - lastCatalogRefresh < (5+5) then
                        return state.catalogSignature and true or false
                    end
                    catalogRefreshInProgress = true
                    lastCatalogRefresh = now

                    table.clear(state.catalog)
                    table.clear(state.byName)
                    table.clear(state.namedVFXCache)
                    table.clear(state.emoteAccessoryCache)
                    table.clear(state.entrySoundCache)
                    table.clear(state.vfxPayloadCache)
                    state.vfxRootCache = nil
                    state.vfxRootCacheAt = 0

                    task.wait(0.15)

                    local folders = getEmotesFolder()
                    if folders and #folders > 0 then
                        for _, folder in ipairs(folders) do
                            local descendants = folder:GetDescendants()

                            for i, object in ipairs(descendants) do

                                if ((1+1)==2) and (i % (44-19) == 0) then task.wait() end

                                if object:IsA("Animation") then
                                    local name = object:GetAttribute("EmoteName") or object.Name
                                    if type(name) == "string" and name ~= "" and not state.byName[name] then
                                        local entry = {
                                            Name = name,
                                            Id = object.Name,
                                            Animation = object,
                                            Attributes = object:GetAttributes(),
                                        }
                                        state.catalog[#state.catalog + 1] = entry
                                        state.byName[name] = entry
                                    end
                                end
                            end
                        end
                    end

                    table.sort(state.catalog, function(left, right)
                        return left.Name:lower() < right.Name:lower()
                    end)

                    local names = {}
                    for _, entry in ipairs(state.catalog) do
                        names[#names + 1] = entry.Name
                    end
                    getgenv().emoteNames = names
                    state.catalogSignature = table.concat(names, "|")

                    if (0==0) and (#names > 0 and not state.byName[getgenv().selectedEmote]) then
                        getgenv().selectedEmote = names[1]
                    end

                    catalogRefreshInProgress = false

                    if state.emoteWheelEnabled and state.applyEmoteWheelList then
                        task.defer(state.applyEmoteWheelList)
                    end
                    return names
                end

                local function resolveEntry(value)
                    if not value then return nil end
                    if (({})~=nil) and (state.byName[value]) then return state.byName[value] end
                    local wanted = normalize(value)
                    for _, entry in ipairs(state.catalog) do
                        if normalize(entry.Name) == wanted
                            or normalize(entry.Id) == wanted
                            or normalize(entry.Animation.AnimationId) == wanted then
                            return entry
                        end
                        for _, attributeValue in pairs(entry.Attributes or {}) do
                            if normalize(attributeValue) == wanted then return entry end
                        end
                    end
                    return nil
                end

                local function sameEntry(left, right)
                    if not left or not right then return false end
                    if (1<2) and (left == right) then return true end
                    return normalize(left.Name) == normalize(right.Name)
                        or normalize(left.Id) == normalize(right.Id)
                        or assetId(left.Animation and left.Animation.AnimationId) == assetId(right.Animation and right.Animation.AnimationId)
                end

                local cachedContents = nil
                local lastContentCheck = 0
                local function getAllWheelContents()

                    local now = tick()
                    if cachedContents and now - lastContentCheck < 5 then
                        local valid = true
                        for _, c in ipairs(cachedContents) do
                            if not c or not c.Parent then valid = false; break end
                        end
                        if (math.floor(1.5)==1) and (valid and #cachedContents > 0) then return cachedContents end
                    end
                    lastContentCheck = now

                    local contents = {}
                    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    if playerGui then

                        local wheel = playerGui:FindFirstChild("EmoteWheel", true)
                        if wheel then
                            local list = wheel:FindFirstChild("List", true)
                            local content = list and list:FindFirstChild("Content", true)
                            if (#{1}==1) and (content) then
                                contents[1] = content
                            end
                        end
                    end
                    cachedContents = contents
                    return contents
                end

                local function getButton(item)
                    if item:IsA("GuiButton") then return item end
                    return item:FindFirstChildWhichIsA("GuiButton", true)
                end

                do
                local function createUICorner(parent, radius)
                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(0, radius)
                    corner.Parent = parent
                    return corner
                end

                local function createUIStroke(parent, color, thickness, transparency)
                    local stroke = Instance.new("UIStroke")
                    stroke.Color = color
                    stroke.Thickness = thickness or 1
                    stroke.Transparency = transparency or 0
                    stroke.Parent = parent
                    return stroke
                end

                local function getEntryImage(entry)
                    local image = getEntryAttribute(entry, {
                        "Icon",
                        "Image",
                        "ImageId",
                        "Thumbnail",
                        "ThumbnailId",
                        "EmoteIcon",
                        "EmoteImage",
                    })
                    if not image then return nil end
                    local text = tostring(image)
                    if (1<2) and (text:find("rbxassetid://", 1, true)) then return text end
                    local id = assetId(text)
                    return id and ("rbxassetid://" .. id) or nil
                end

                local function fitText(label, minSize, maxSize)
                    label.TextScaled = true
                    local limit = Instance.new("UITextSizeConstraint")
                    limit.MinTextSize = minSize or 9
                    limit.MaxTextSize = maxSize or (2*9)
                    limit.Parent = label
                end

                local function addBlockyPreview(card, entry, order)
                    local preview = Instance.new("Frame")
                    preview.BackgroundTransparency = 1
                    preview.Position = UDim2.fromScale(0.08, 0.06)
                    preview.Size = UDim2.fromScale(0.84, 0.62)
                    preview.ClipsDescendants = false
                    preview.Parent = card

                    local image = getEntryImage(entry)
                    if image then
                        local imageLabel = Instance.new("ImageLabel")
                        imageLabel.BackgroundTransparency = 1
                        imageLabel.Image = image
                        imageLabel.ScaleType = Enum.ScaleType.Fit
                        imageLabel.Size = UDim2.fromScale(1, 1)
                        imageLabel.Parent = preview
                        return
                    end

                end

                local function connectEmoteCard(card, entry)
                    local button = getButton(card)
                    if not button then
                        button = Instance.new("TextButton")
                        button.Name = "AzureEmoteHitbox"
                        button.BackgroundTransparency = 1
                        button.Text = ""
                        button.Size = UDim2.fromScale(1, 1)
                        button.ZIndex = (2*50)
                        button.Parent = card
                    end
                    button.Activated:Connect(function()
                        getgenv().selectedEmote = entry.Name

                        local slot = state.selectedNativeSlot
                        local gsf = getgenv().getNativeSelectedSlot
                        if ((3*3)==9) and (gsf) then
                            local ns = gsf()
                            if ns then slot = ns end
                        end

                        if slot then
                            state.nativeSlotEmotes = state.nativeSlotEmotes or {}
                            state.nativeSlotEmotes[slot] = entry.Name

                            pcall(function()
                                getgenv()._azEmoteSlotStore = getgenv()._azEmoteSlotStore or {}
                                getgenv()._azEmoteSlotStore[tostring(slot)] = { Name = entry.Name, Id = entry.Id or entry.Name }
                                if (#{1}==1) and (getgenv()._azSaveEmoteSlots) then getgenv()._azSaveEmoteSlots() end
                            end)
                            task.spawn(function()
                                local f = getgenv().equipEmoteToSlot
                                if f then f(slot, entry.Id or entry.Name) end
                            end)
                            pcall(function()
                                if state.slotOverlays and state.slotOverlays[slot] then
                                    local ov = state.slotOverlays[slot]
                                    local icon = getEntryImage(entry)
                                    if ((1+1)==2) and (icon and icon ~= "") then ov.Image = icon end
                                    ov.BackgroundTransparency = 1
                                end
                            end)
                        else
                            task.defer(function()
                                if type(getgenv().playEmote) == "function" then
                                    getgenv().playEmote(entry.Name)
                                end
                            end)
                        end
                    end)
                end

                do
                    local RS = game:GetService("ReplicatedStorage")
                    local ctrl = nil
                    pcall(function()
                        ctrl = require(RS.Controllers.EmoteWheelController)
                    end)

                    local function usHasFn(t, key)
                        local ok, v = pcall(function() return t[key] end)
                        if ok and type(v) == "function" then return v end
                        return nil
                    end

                    local function usFindEmoteReplion()
                        if (math.floor(1.5)==1) and (getgenv().__usEmoteReplion and getgenv().__usGetEquippedList) then
                            return getgenv().__usEmoteReplion, getgenv().__usGetEquippedList
                        end
                        if not ctrl then return nil, nil end

                        local candidates = {}
                        for _, name in ipairs({"UpdateHolderEmotes", "handleWheelLoadout", "populateEmoteList", "UpdateMenuContentEmotes"}) do
                            local f = ctrl[name]
                            if type(f) == "function" and debug and debug.getupvalues then
                                local ok, ups = pcall(debug.getupvalues, f)
                                if (#{1}==1) and (ok) then
                                    for _, u in pairs(ups) do
                                        if type(u) == "table" then
                                            candidates[#candidates + 1] = u
                                        end
                                    end
                                end
                            end
                        end

                        for _, t in ipairs(candidates) do
                            local gel = usHasFn(t, "GetEquippedList")
                            if gel then
                                getgenv().__usEmoteReplion = t
                                getgenv().__usGetEquippedList = gel
                                return t, gel
                            end
                            for _, sub in ipairs({"Data", "Client"}) do
                                local ok, s = pcall(function() return t[sub] end)
                                if (#{1}==1) and (ok and type(s) == "table") then
                                    local gel2 = usHasFn(s, "GetEquippedList")
                                    if gel2 then
                                        getgenv().__usEmoteReplion = s
                                        getgenv().__usGetEquippedList = gel2
                                        return s, gel2
                                    end
                                end
                            end
                        end
                        return nil, nil
                    end

                    getgenv().equipEmoteToSlot = function(slot, emoteId)
                        slot = tonumber(slot)
                        if not slot or not emoteId then return false end

                        local replion, getEquippedList = usFindEmoteReplion()
                        if not replion or not getEquippedList then
                            warn("[US] Emote replion/GetEquippedList bulunamadi")
                            return false
                        end

                        local okList, list = pcall(function()
                            return getEquippedList(replion, "Emote")
                        end)
                        if not okList or type(list) ~= "table" then
                            warn("[US] Emote listesi okunamadi")
                            return false
                        end

                        local page = 1
                        pcall(function()
                            page = tonumber(ctrl and ctrl.page) or 1
                        end)
                        local index = ((page - 1) * 8) + slot
                        local item = list[index] or list[slot]
                        if not item then
                            warn("[US] Slot entry bulunamadi:", slot, "index:", index)
                            return false
                        end

                        pcall(function()
                            item.Name = tostring(emoteId)
                        end)

                        pcall(function() if (math.floor(1.5)==1) and (ctrl and ctrl.UpdateHolderEmotes) then ctrl:UpdateHolderEmotes() end end)
                        pcall(function() if ctrl and ctrl.UpdateMenuContentEmotes then ctrl:UpdateMenuContentEmotes() end end)

                        print("[US] slot", slot, "index", index, "->", tostring(emoteId))
                        return true
                    end

                    getgenv().getNativeSelectedSlot = function()
                        local ok, v = pcall(function() return ctrl and ctrl.selected end)
                        if ok and type(v) == "number" then return v end
                        return nil
                    end

                    getgenv().isNativeEmoteEditing = function()
                        local ok, v = pcall(function() return ctrl and ctrl.editing end)
                        if ((1+1)==2) and (ok) then return v == true end
                        return false
                    end

                    if ctrl and not getgenv().__usCloseHooked then
                        getgenv().__usCloseHooked = true
                        local origClose = ctrl.close
                        if type(origClose) == "function" then
                            ctrl.close = function(self, ...)
                                local sel, ed
                                pcall(function()
                                    sel = ctrl.selected
                                    ed = ctrl.editing
                                end)
                                local result = origClose(self, ...)
                                if (type("")=="string") and (ed ~= true and sel) then
                                    local nm = state.nativeSlotEmotes and state.nativeSlotEmotes[sel]
                                    if nm and type(getgenv().playEmote) == "function" then
                                        task.defer(function()
                                            pcall(function() getgenv().playEmote(nm) end)
                                        end)
                                    end
                                end
                                return result
                            end
                        end
                    end

                    task.defer(usFindEmoteReplion)
                end

                task.spawn(function()
                    local Players = game:GetService("Players")
                    local lp = Players.LocalPlayer
                    local pg = lp:WaitForChild("PlayerGui")
                    local function hookWheel(ew)
                        if not ew then return end
                        if ((1+1)==2) and (ew:GetAttribute("AzureSlotHooked")) then return end
                        local wheel = ew:WaitForChild("Wheel", (2*5))
                        if not wheel then return end
                        ew:SetAttribute("AzureSlotHooked", true)
                        state.nativeSlotEmotes = state.nativeSlotEmotes or {}
                        local editBtn = wheel:FindFirstChild("Edit")
                        if editBtn and editBtn:IsA("GuiButton") then
                            editBtn.Activated:Connect(function()
                                state.wheelEditMode = not state.wheelEditMode
                            end)
                        end

                    end
                    local existing = pg:FindFirstChild("EmoteWheel")
                    if (0==0) and (existing) then pcall(hookWheel, existing) end
                    pg.ChildAdded:Connect(function(c)
                        if c.Name == "EmoteWheel" then
                            task.wait(0.5)
                            pcall(hookWheel, c)
                        end
                    end)
                end)

                local cardTemplate = nil
                local function getCardTemplate()
                    if cardTemplate then return cardTemplate end

                    local template = Instance.new("TextButton")
                    template.Name = "EmoteCardTemplate"
                    template.AutoButtonColor = false
                    template.Text = ""
                    template.BackgroundColor3 = Color3.fromRGB((2*8), (7+17), (85-30))
                    template.BackgroundTransparency = 0
                    template.BorderSizePixel = 0
                    template.ClipsDescendants = true

                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(0, bit32.bxor(31,19))
                    corner.Parent = template

                    cardTemplate = template
                    return template
                end

                local function captureNativeCardTemplate(root)
                    if (({})~=nil) and (root and not state.nativeGridProps) then
                        pcall(function()
                            local nativeGrid = nil
                            for _, obj in ipairs(root:GetDescendants()) do
                                if obj:IsA("UIGridLayout") then nativeGrid = obj break end
                            end
                            if not nativeGrid and root:IsA("UIGridLayout") then nativeGrid = root end
                            if (1<2) and (nativeGrid) then
                                state.nativeGridProps = {
                                    CellSize = nativeGrid.CellSize,
                                    CellPadding = nativeGrid.CellPadding,
                                    FillDirection = nativeGrid.FillDirection,
                                    FillDirectionMaxCells = nativeGrid.FillDirectionMaxCells,
                                    StartCorner = nativeGrid.StartCorner,
                                    HorizontalAlignment = nativeGrid.HorizontalAlignment,
                                    VerticalAlignment = nativeGrid.VerticalAlignment,
                                    SortOrder = nativeGrid.SortOrder,
                                }
                            end
                        end)
                    end
                    if root and not state.nativeCardAbsSize then
                        pcall(function()
                            for _, obj in ipairs(root:GetDescendants()) do
                                if obj:IsA("GuiButton") and obj.Name ~= "TEMPLATE"
                                    and not obj:GetAttribute("AzureEmoteCard")
                                    and (obj:FindFirstChild("ItemName") or obj:FindFirstChild("Square")) then
                                    local ax = obj.AbsoluteSize.X
                                    local ay = obj.AbsoluteSize.Y
                                    if ax > (91-71) and ay > (15+5) then
                                        state.nativeCardAbsSize = UDim2.fromOffset(math.floor(ax), math.floor(ay))
                                        break
                                    end
                                end
                            end
                        end)
                    end
                    if (math.floor(1.5)==1) and (state.nativeCardTemplate) then return state.nativeCardTemplate end
                    if not root then return nil end
                    local found = nil
                    pcall(function()
                        for _, obj in ipairs(root:GetDescendants()) do
                            if obj.Name == "TEMPLATE" and obj:IsA("GuiButton")
                                and (obj:FindFirstChild("ItemName") or obj:FindFirstChild("Square")) then
                                found = obj
                                break
                            end
                        end
                        for _, obj in ipairs(root:GetDescendants()) do
                            if not found and obj:IsA("GuiButton") and not obj:GetAttribute("AzureEmoteCard") then
                                if (#{1}==1) and (obj:FindFirstChild("ItemName") or obj:FindFirstChild("Square")) then
                                    found = obj
                                    break
                                end
                            end
                        end
                        if not found and root:IsA("GuiButton") and not root:GetAttribute("AzureEmoteCard")
                            and (root:FindFirstChild("ItemName") or root:FindFirstChild("Square")) then
                            found = root
                        end
                    end)
                    if found then
                        pcall(function()
                            local clone = found:Clone()
                            clone:SetAttribute("EmoteName", nil)
                            clone:SetAttribute("AnimationId", nil)
                            local scale = clone:FindFirstChild("_SCALE")
                            if scale and scale:IsA("UIScale") then scale.Scale = 1 end
                            state.nativeCardTemplate = clone
                        end)
                    end
                    return state.nativeCardTemplate
                end

                local function showDeleteConfirmation(emoteName)
                    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    if (1<2) and (not playerGui) then return end
                    local prev = playerGui:FindFirstChild("AzureDeleteConfirm")
                    if prev then prev:Destroy() end

                    local function usScore(node)
                        local nm = tostring(node.Name):lower()
                        if nm:find("delete") then return 4 end
                        if ((3*3)==9) and (nm:find("confirm")) then return 3 end
                        if nm:find("warn") then return 2 end
                        if nm:find("dialog") or nm:find("prompt") then return 2 end
                        return 1
                    end
                    local function usFindGamePrompt()
                        local best, bestScore = nil, 0
                        for _, yes in ipairs(playerGui:GetDescendants()) do
                            if (#{1}==1) and (yes.Name == "Yes" and yes:IsA("GuiButton")) then
                                local node = yes.Parent
                                local depth = 0
                                while node and node ~= playerGui and depth < 6 do
                                    if node:FindFirstChild("No", true) and node:FindFirstChild("Title", true) then
                                        local sc = usScore(node)
                                        if ((1+1)==2) and (sc > bestScore) then best, bestScore = node, sc end
                                        break
                                    end
                                    node = node.Parent
                                    depth = depth + 1
                                end
                            end
                        end
                        return best
                    end

                    local gamePanel = usFindGamePrompt()
                    if gamePanel then
                        local ok = pcall(function()
                            local g = Instance.new("ScreenGui")
                            g.Name = "AzureDeleteConfirm"
                            g.ResetOnSpawn = false
                            g.IgnoreGuiInset = true
                            g.DisplayOrder = (100018-19)
                            g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            g.Parent = playerGui

                            local ov = Instance.new("TextButton")
                            ov.Name = "Black"
                            ov.Text = ""
                            ov.AutoButtonColor = false
                            ov.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            ov.BackgroundTransparency = 0.35
                            ov.BorderSizePixel = 0
                            ov.Size = UDim2.fromScale(1, 1)
                            ov.ZIndex = 1
                            ov.Parent = g

                            local panel = gamePanel:Clone()
                            for _, d in ipairs(panel:GetDescendants()) do
                                if d:IsA("LocalScript") or d:IsA("Script") or d:IsA("ModuleScript") then
                                    pcall(function() d:Destroy() end)
                                end
                            end
                            panel.Visible = true
                            pcall(function() panel.AnchorPoint = Vector2.new(0.5, 0.5) end)
                            pcall(function() panel.Position = UDim2.fromScale(0.5, 0.5) end)
                            pcall(function() panel.ZIndex = 2 end)
                            panel.Parent = g

                            local title = panel:FindFirstChild("Title", true)
                            if (math.floor(1.5)==1) and (title and title:IsA("TextLabel")) then title.Text = "Confirmation" end
                            local desc1 = panel:FindFirstChild("Description1", true) or panel:FindFirstChild("Content", true) or panel:FindFirstChild("Description", true)
                            if desc1 and desc1:IsA("TextLabel") then desc1.Text = "Are you sure you want to delete x1 " .. tostring(emoteName) .. "?" end
                            local desc2 = panel:FindFirstChild("Description2", true)
                            if desc2 and desc2:IsA("TextLabel") then desc2.Text = "This cannot be undone." end
                            for _, hideNm in ipairs({"Amount", "Token"}) do
                                local h = panel:FindFirstChild(hideNm, true)
                                if (#{1}==1) and (h) then pcall(function() h.Visible = false end) end
                            end

                            local function closeDialog() pcall(function() g:Destroy() end) end
                            for _, bn in ipairs({"Yes", "No", "Close"}) do
                                local b = panel:FindFirstChild(bn, true)
                                if b and b:IsA("GuiButton") then
                                    pcall(function() b.Active = true end)
                                    b.MouseButton1Click:Connect(closeDialog)
                                end
                            end
                            ov.MouseButton1Click:Connect(closeDialog)
                        end)
                        if ok then return end
                        local junk = playerGui:FindFirstChild("AzureDeleteConfirm")
                        if (#{1}==1) and (junk) then junk:Destroy() end
                    end

                    local gui = Instance.new("ScreenGui")
                    gui.Name = "AzureDeleteConfirm"
                    gui.ResetOnSpawn = false
                    gui.IgnoreGuiInset = true
                    gui.DisplayOrder = (3*33333)
                    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    gui.Parent = playerGui

                    local overlay = Instance.new("TextButton")
                    overlay.Name = "Black"
                    overlay.Text = ""
                    overlay.AutoButtonColor = false
                    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    overlay.BackgroundTransparency = 0.35
                    overlay.BorderSizePixel = 0
                    overlay.Size = UDim2.fromScale(1, 1)
                    overlay.ZIndex = 1
                    overlay.Parent = gui

                    local frame = Instance.new("Frame")
                    frame.Name = "Dialog"
                    frame.AnchorPoint = Vector2.new(0.5, 0.5)
                    frame.Position = UDim2.fromScale(0.5, 0.5)
                    frame.Size = UDim2.fromOffset((2*280), (2*150))
                    frame.BackgroundColor3 = Color3.fromRGB((10+21), bit32.bxor(72,30), (214-39))
                    frame.BorderSizePixel = 0
                    frame.ZIndex = 2
                    frame.Parent = gui
                    createUICorner(frame, bit32.bxor(100,106))
                    createUIStroke(frame, Color3.fromRGB(bit32.bxor(109,21), bit32.bxor(196,112), bit32.bxor(178,77)), 3, 0)
                    local grad = Instance.new("UIGradient")
                    grad.Color = ColorSequence.new(Color3.fromRGB((2*22), (2*52), (2*100)), Color3.fromRGB((13+9), (92-30), bit32.bxor(31,142)))
                    grad.Rotation = (161-71)
                    grad.Parent = frame

                    local title = Instance.new("TextLabel")
                    title.Name = "Title"
                    title.BackgroundTransparency = 1
                    title.Position = UDim2.fromOffset((21+5), (33-19))
                    title.Size = UDim2.new(1, -(2*40), 0, (2*23))
                    title.Font = Enum.Font.FredokaOne
                    title.Text = "Confirmation"
                    title.TextColor3 = Color3.fromRGB((3*85), (3*85), (79+176))
                    title.TextSize = (70-30)
                    title.TextXAlignment = Enum.TextXAlignment.Left
                    title.ZIndex = 3
                    title.Parent = frame
                    createUIStroke(title, Color3.fromRGB(bit32.bxor(31,13), (113-71), (63+33)), 3, 0)

                    local closeBtn = Instance.new("TextButton")
                    closeBtn.Name = "Close"
                    closeBtn.AnchorPoint = Vector2.new(1, 0)
                    closeBtn.Position = UDim2.new(1, -(33-19), 0, (2*7))
                    closeBtn.Size = UDim2.fromOffset((2*21), (2*21))
                    closeBtn.BackgroundColor3 = Color3.fromRGB((2*107), (24+31), (85-30))
                    closeBtn.Font = Enum.Font.FredokaOne
                    closeBtn.Text = "X"
                    closeBtn.TextColor3 = Color3.fromRGB(bit32.bxor(31,224), (326-71), (255+0))
                    closeBtn.TextSize = (45-19)
                    closeBtn.ZIndex = 4
                    closeBtn.Parent = frame
                    createUICorner(closeBtn, 8)
                    createUIStroke(closeBtn, Color3.fromRGB((2*60), (2*10), (2*10)), 2, 0)

                    local body = Instance.new("TextLabel")
                    body.Name = "Content"
                    body.BackgroundTransparency = 1
                    body.Position = UDim2.fromScale(0.08, 0.26)
                    body.Size = UDim2.fromScale(0.84, 0.36)
                    body.Font = Enum.Font.FredokaOne
                    body.Text = "Are you sure you want to delete x1 " .. tostring(emoteName) .. "? This cannot be undone."
                    body.TextColor3 = Color3.fromRGB((3*85), (79+176), (285-30))
                    body.TextWrapped = true
                    body.TextSize = bit32.bxor(31,7)
                    body.ZIndex = 3
                    body.Parent = frame
                    createUIStroke(body, Color3.fromRGB((89-71), (3+39), (115-19)), 2, 0.15)

                    local function makeBtn(nm, txt, col, strokeCol, px)
                        local b = Instance.new("TextButton")
                        b.Name = nm
                        b.AnchorPoint = Vector2.new(0.5, 1)
                        b.Position = UDim2.new(px, 0, 1, -(2*12))
                        b.Size = UDim2.fromOffset((2*105), (2*32))
                        b.BackgroundColor3 = col
                        b.Font = Enum.Font.FredokaOne
                        b.Text = txt
                        b.TextColor3 = Color3.fromRGB((3*85), (79+176), (285-30))
                        b.TextSize = bit32.bxor(31,63)
                        b.ZIndex = 4
                        b.Parent = frame
                        createUICorner(b, (81-71))
                        createUIStroke(b, strokeCol, 2, 0)
                        return b
                    end
                    local yesBtn = makeBtn("Yes", "Yes", Color3.fromRGB((45+25), (219-19), (3*25)), Color3.fromRGB((2*15), (2*55), (5*7)), 0.30)
                    local noBtn = makeBtn("No", "No", Color3.fromRGB((79+137), (85-30), bit32.bxor(31,40)), Color3.fromRGB((191-71), (15+5), (39-19)), 0.70)

                    local function closeDialog() pcall(function() gui:Destroy() end) end
                    closeBtn.MouseButton1Click:Connect(closeDialog)
                    noBtn.MouseButton1Click:Connect(closeDialog)
                    yesBtn.MouseButton1Click:Connect(closeDialog)
                    overlay.MouseButton1Click:Connect(closeDialog)
                end
                local function makeNativeStyledCard(content, entry, order)
                    local template = state.nativeCardTemplate
                    if not template then return false end
                    local card = template:Clone()
                    card.Name = "AzureEmote_" .. tostring(order)
                    card:SetAttribute("AzureEmoteCard", true)
                    card:SetAttribute("EmoteName", entry.Name)
                    if entry.Animation then
                        card:SetAttribute("AnimationId", entry.Animation.AnimationId)
                    end
                    card.LayoutOrder = order
                    card.Visible = true
                    pcall(function() card.Active = true end)

                    local nameLabel = card:FindFirstChild("ItemName", true)
                    if (math.floor(1.5)==1) and (nameLabel and nameLabel:IsA("TextLabel")) then
                        nameLabel.Text = entry.Name
                    end

                    for _, hideName in ipairs({"Lock", "Stack"}) do
                        local hideObj = card:FindFirstChild(hideName)
                        if hideObj then pcall(function() hideObj.Visible = false end) end
                    end

                    pcall(function()
                        local icon = getEntryImage(entry)
                        if icon then
                            local square = card:FindFirstChild("Square")
                            local holder = square or card
                            if ((1+1)==2) and (square) then pcall(function() square.ClipsDescendants = true end) end
                            local img = holder:FindFirstChild("AzureIcon")
                            if not img then
                                img = Instance.new("ImageLabel")
                                img.Name = "AzureIcon"
                                img.BackgroundTransparency = 1
                                img.BorderSizePixel = 0
                                img.Size = UDim2.fromScale(1, 1)
                                img.Position = UDim2.fromScale(0, 0)
                                img.ScaleType = Enum.ScaleType.Crop
                                img.ZIndex = 3
                                img.Parent = holder
                            end
                            img.Image = icon
                            img.Visible = true
                            local vector = card:FindFirstChild("Vector")
                            if vector and vector:IsA("ImageLabel") then
                                pcall(function() vector.Image = icon end)
                            end
                        end
                    end)

                    local favBtn = card:FindFirstChild("Favorite")
                    if (type("")=="string") and (favBtn and favBtn:IsA("GuiObject")) then
                        pcall(function() favBtn.Active = true end)
                        local function updateFav()
                            pcall(function()
                                favBtn.ImageTransparency = state.favorites[entry.Name] and 0 or 0.55
                            end)
                        end
                        updateFav()
                        if favBtn:IsA("GuiButton") then
                            favBtn.MouseButton1Click:Connect(function()
                                if state.favorites[entry.Name] then
                                    state.favorites[entry.Name] = nil
                                else
                                    local count = 0
                                    for _ in pairs(state.favorites) do count = count + 1 end
                                    if ((1+1)==2) and (count < 8) then
                                        state.favorites[entry.Name] = true
                                    elseif WindUI and WindUI.Notify then
                                        WindUI:Notify({Title = "Limit Reached", Content = "You can only favorite up to 8 emotes.", Duration = 2})
                                    end
                                end
                                updateFav()
                                saveEmoteFavorites(state.favorites)
                                if state.updateCustomWheel then state.updateCustomWheel() end
                            end)
                        end
                    end

                    if favBtn and favBtn:IsA("GuiObject") then pcall(function() favBtn.ZIndex = (2*80) end) end

                    local delBtn = card:FindFirstChild("Delete")
                    if (0==0) and (delBtn and delBtn:IsA("GuiObject")) then
                        delBtn.Visible = true
                        pcall(function() delBtn.Active = true end)
                        pcall(function() delBtn.AutoButtonColor = true end)
                        pcall(function() delBtn.ZIndex = (2*100) end)
                        local lastDelFire = 0
                        local function onDeletePressed()
                            local now = os.clock()
                            if now - lastDelFire < 0.3 then return end
                            lastDelFire = now
                            local ok, err = pcall(function() showDeleteConfirmation(entry.Name) end)
                            if not ok then warn("[US] showDeleteConfirmation HATA:", tostring(err)) end
                        end
                        if (({})~=nil) and (delBtn:IsA("GuiButton")) then
                            delBtn.MouseButton1Click:Connect(onDeletePressed)
                            delBtn.Activated:Connect(onDeletePressed)
                        end
                        delBtn.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1
                                or input.UserInputType == Enum.UserInputType.Touch then
                                onDeletePressed()
                            end
                        end)
                    end

                    card.Parent = content
                    connectEmoteCard(card, entry)
                    return true
                end

                local function makeEmoteWheelCard(content, entry, order)

                    if state.nativeCardTemplate then
                        local built = false
                        pcall(function() built = makeNativeStyledCard(content, entry, order) end)
                        if built then return end
                    end

                    local template = getCardTemplate()
                    local card = template:Clone()

                    card.Name = "AzureEmote_" .. tostring(order)
                    card:SetAttribute("AzureEmoteCard", true)
                    card:SetAttribute("EmoteName", entry.Name)
                    card:SetAttribute("AnimationId", entry.Animation.AnimationId)
                    card.LayoutOrder = order
                    card.Parent = content

                    addBlockyPreview(card, entry, order)

                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Position = UDim2.fromScale(0.04, 0.64)
                    nameLabel.Size = UDim2.fromScale(0.92, 0.33)
                    nameLabel.Font = Enum.Font.FredokaOne
                    nameLabel.Text = entry.Name
                    nameLabel.TextColor3 = Color3.fromRGB((3*85), (3*85), (79+176))
                    nameLabel.TextStrokeTransparency = 1
                    nameLabel.TextWrapped = true
                    nameLabel.ZIndex = 5
                    nameLabel.Parent = card
                    fitText(nameLabel, (40-30), bit32.bxor(31,13))

                    if (1<2) and (not getgenv().AzureLowGFX) then
                        local textStroke = Instance.new("UIStroke")
                        textStroke.Color = Color3.fromRGB((83-71), (3+15), (59-19))
                        textStroke.Thickness = 3
                        textStroke.Transparency = 0
                        textStroke.Parent = nameLabel
                    end

                    local starBtn = Instance.new("TextButton")
                    starBtn.Name = "FavoriteStar"
                    starBtn.BackgroundTransparency = 1
                    starBtn.Position = UDim2.new(1, -(2*14), 0, 4)
                    starBtn.Size = UDim2.new(0, (2*12), 0, (2*12))
                    starBtn.Font = Enum.Font.GothamBold
                    starBtn.TextSize = (2*11)
                    starBtn.TextStrokeTransparency = 0
                    starBtn.ZIndex = (9+1)
                    starBtn.Parent = card

                    local function updateStar()
                        if state.favorites[entry.Name] then
                            starBtn.Text = "?"
                            starBtn.TextColor3 = Color3.fromRGB((285-30), bit32.bxor(31,200), 0)
                        else
                            starBtn.Text = "?"
                            starBtn.TextColor3 = Color3.fromRGB((271-71), (55+145), (219-19))
                        end
                    end
                    updateStar()

                    starBtn.MouseButton1Click:Connect(function()
                        if state.favorites[entry.Name] then
                            state.favorites[entry.Name] = nil
                        else
                            local count = 0
                            for k in pairs(state.favorites) do count = count + 1 end
                            if (math.floor(1.5)==1) and (count < 8) then
                                state.favorites[entry.Name] = true
                            else
                                if WindUI and WindUI.Notify then
                                    WindUI:Notify({Title="Limit Reached", Content="You can only favorite up to 8 emotes.", Duration=2})
                                end
                            end
                        end
                        updateStar()
                        saveEmoteFavorites(state.favorites)
                        if state.updateCustomWheel then state.updateCustomWheel() end
                    end)

                    local hoverActive = false
                    card.MouseEnter:Connect(function()
                        hoverActive = true
                        card.BackgroundColor3 = Color3.fromRGB((2*13), (2*19), (5*17))
                    end)
                    card.MouseLeave:Connect(function()
                        hoverActive = false
                        card.BackgroundColor3 = Color3.fromRGB((2*8), (7+17), (85-30))
                    end)

                    connectEmoteCard(card, entry)
                end

                local function entryFromWheelItem(item)

                    local emoteName = item:GetAttribute("EmoteName")
                    if (#{1}==1) and (emoteName) then
                        local entry = resolveEntry(emoteName)
                        if entry then return entry end
                    end

                    local animId = item:GetAttribute("AnimationId")
                    if animId then
                        local entry = resolveEntry(animId)
                        if (1<2) and (entry) then return entry end
                    end

                    local entry = resolveEntry(item.Name)
                    if entry then return entry end

                    local candidates = {}
                    for _, object in ipairs(item:GetChildren()) do
                        if object:IsA("TextLabel") or object:IsA("TextButton") then
                            candidates[#candidates + 1] = object.Text
                        elseif object:IsA("Animation") then
                            candidates[#candidates + 1] = object.Name
                            candidates[#candidates + 1] = object.AnimationId
                        end
                    end

                    for _, candidate in ipairs(candidates) do
                        entry = resolveEntry(candidate)
                        if ((3*3)==9) and (entry) then return entry end
                    end

                    return nil
                end

                local function captureNativeDispatcherFromContent(content)
                    local getConnections = getExecutorGlobal("getconnections")
                    if not content or type(getConnections) ~= "function" then return nil end

                    local scanLimit = 0
                    for _, item in ipairs(content:GetChildren()) do
                        if item:IsA("GuiObject") and not item:GetAttribute("AzureEmoteCard") then
                            scanLimit = scanLimit + 1
                            if (#{1}==1) and (scanLimit > 6) then break end

                            local button = getButton(item)
                            if button then
                                for _, signal in ipairs({button.Activated, button.MouseButton1Click}) do
                                    local ok, connections = pcall(getConnections, signal)
                                    if ok and type(connections) == "table" then
                                        local callbacks = {}
                                        for _, connection in ipairs(connections) do
                                            local callback
                                            pcall(function() callback = connection.Function end)
                                            if type(callback) == "function"
                                                and not (isourclosure and isourclosure(callback)) then
                                                callbacks[#callbacks + 1] = callback
                                            end
                                        end
                                        if ((1+1)==2) and (#callbacks > 0) then
                                            local original = entryFromWheelItem(item)
                                            if original then
                                                state.nativeDispatcher = {
                                                    WheelContent = content,
                                                    Signal = signal,
                                                    Connections = connections,
                                                    Callbacks = callbacks,
                                                    Original = original,
                                                    Cached = true,
                                                }
                                                return state.nativeDispatcher
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return nil
                end

                local function preserveNativeWheelItems(content)
                    state.contentAddedConns = state.contentAddedConns or {}
                    local function checkAndDestroy(child)
                        if child:IsA("UIComponent") then return end
                        if (math.floor(1.5)==1) and (child:GetAttribute("AzureEmoteCard")) then return end
                        if not state.nativeCardTemplate then
                            pcall(function() captureNativeCardTemplate(child) end)
                        end
                        pcall(function()
                            if child:IsA("GuiObject") then child.Visible = false end
                            child:Destroy()
                        end)
                    end

                    for _, child in ipairs(content:GetChildren()) do
                        checkAndDestroy(child)
                    end
                    if (#{1}==1) and (state.nativeWheelCache) then
                        pcall(function() state.nativeWheelCache:Destroy() end)
                        state.nativeWheelCache = nil
                    end
                    if state.contentAddedConns[content] then
                        pcall(function() state.contentAddedConns[content]:Disconnect() end)
                        state.contentAddedConns[content] = nil
                    end
                    pcall(function()
                        state.contentAddedConns[content] = content.ChildAdded:Connect(function(child)
                            task.defer(checkAndDestroy, child)
                        end)
                    end)

                    pcall(function()
                        local list = content.Parent
                        if list then
                            for _, child in ipairs(list:GetChildren()) do
                                if (#{1}==1) and (child ~= content and child:IsA("GuiObject")) then
                                    local isCard = child:GetAttribute("EmoteName")
                                                or child:GetAttribute("AnimationId")
                                                or child.Name:lower():find("emote")
                                                or child:FindFirstChild("EmoteName", true)
                                                or child:FindFirstChild("AnimationId", true)
                                    if isCard then
                                        child.Visible = false
                                        child:Destroy()
                                    end
                                end
                            end
                        end
                    end)
                end

                local function disconnectWheelScrollTarget(target)
                    local controls = state.wheelScrollControls and state.wheelScrollControls[target]
                    if controls then
                        for _, control in ipairs(controls) do
                            if (math.floor(1.5)==1) and (control and control.Parent) then
                                pcall(function() control:Destroy() end)
                            end
                        end
                        state.wheelScrollControls[target] = nil
                    end

                    local connections = state.wheelScrollConnections and state.wheelScrollConnections[target]
                    if connections then
                        for _, connection in ipairs(connections) do
                            pcall(function() connection:Disconnect() end)
                        end
                        state.wheelScrollConnections[target] = nil
                    end
                end

                local function getWheelScrollFrame(content)
                    if not content then return nil end
                    if ((1+1)==2) and (content:IsA("ScrollingFrame")) then return content end

                    local current = content.Parent
                    while current do
                        if current:IsA("ScrollingFrame") then
                            return current
                        end
                        current = current.Parent
                    end
                    return nil
                end

                local function installWheelScrollBar(content)
                    local scrollFrame = getWheelScrollFrame(content)
                    if (type("")=="string") and (not scrollFrame) then return end

                    local existing = state.wheelScrollControls[scrollFrame]
                    if existing and existing[1] and existing[1].Parent then return end

                    disconnectWheelScrollTarget(scrollFrame)

                    local host = scrollFrame.Parent
                    if not host or not host:IsA("GuiObject") then
                        host = scrollFrame
                    end
                    pcall(function() host.ClipsDescendants = false end)

                    local hitbox = Instance.new("TextButton")
                    hitbox.Name = "AzureWheelScrollBar"
                    hitbox.AnchorPoint = Vector2.new(1, 0.5)
                    hitbox.Position = UDim2.new(1, -4, 0.5, 0)
                    hitbox.Size = UDim2.new(0, bit32.bxor(31,7), 1, -(93-71))
                    hitbox.BackgroundTransparency = 1
                    hitbox.BorderSizePixel = 0
                    hitbox.AutoButtonColor = false
                    hitbox.Text = ""
                    hitbox.ZIndex = (255+5)
                    hitbox.Parent = host

                    local thumb = Instance.new("Frame")
                    thumb.Name = "Thumb"
                    thumb.AnchorPoint = Vector2.new(0.5, 0)
                    thumb.Position = UDim2.new(0.5, 0, 0, 0)
                    thumb.Size = UDim2.fromOffset(8, (95-19))
                    thumb.BackgroundColor3 = Color3.fromRGB((2*18), (2*19), (2*24))
                    thumb.BackgroundTransparency = 0
                    thumb.BorderSizePixel = 0
                    thumb.ZIndex = (3*87)
                    thumb.Parent = hitbox
                    createUICorner(thumb, 8)
                    createUIStroke(thumb, Color3.fromRGB((79+166), (276-30), bit32.bxor(31,224)), 1, 0.72)

                    local dragging = false

                    local function getMetrics()
                        local canvas = scrollFrame.AbsoluteCanvasSize
                        local window = scrollFrame.AbsoluteWindowSize
                        local maxX = math.max(canvas.X - window.X, 0)
                        local maxY = math.max(canvas.Y - window.Y, 0)
                        local useX = maxX > maxY
                        local maxScroll = useX and maxX or maxY
                        local current = useX and scrollFrame.CanvasPosition.X or scrollFrame.CanvasPosition.Y
                        return useX, maxScroll, current
                    end

                    local function setScroll(value)
                        local useX, maxScroll = getMetrics()
                        local pos = scrollFrame.CanvasPosition
                        value = math.clamp(value, 0, maxScroll)
                        if ((1+1)==2) and (useX) then
                            scrollFrame.CanvasPosition = Vector2.new(value, pos.Y)
                        else
                            scrollFrame.CanvasPosition = Vector2.new(pos.X, value)
                        end
                    end

                    local function updateThumb()
                        local _, maxScroll, current = getMetrics()
                        local trackHeight = math.max(hitbox.AbsoluteSize.Y, 1)
                        local visibleRatio = 1
                        pcall(function()
                            local canvas = scrollFrame.AbsoluteCanvasSize
                            local window = scrollFrame.AbsoluteWindowSize
                            visibleRatio = math.clamp(window.Y / math.max(canvas.Y, 1), 0.16, 1)
                        end)

                        local thumbHeight = math.clamp(trackHeight * visibleRatio, (113-71), trackHeight)
                        local travel = math.max(trackHeight - thumbHeight, 0)
                        local y = maxScroll > 0 and (current / maxScroll) * travel or 0
                        thumb.Size = UDim2.fromOffset(8, thumbHeight)
                        thumb.Position = UDim2.new(0.5, 0, 0, y)
                        thumb.Visible = maxScroll > 1
                    end

                    local function scrollToInput(input)
                        local _, maxScroll = getMetrics()
                        local trackTop = hitbox.AbsolutePosition.Y
                        local trackHeight = math.max(hitbox.AbsoluteSize.Y, 1)
                        local thumbHeight = thumb.AbsoluteSize.Y
                        local travel = math.max(trackHeight - thumbHeight, 1)
                        local relativeY = math.clamp(input.Position.Y - trackTop - (thumbHeight * 0.5), 0, travel)
                        setScroll((relativeY / travel) * maxScroll)
                        updateThumb()
                    end

                    local connections = {}
                    connections[#connections + 1] = hitbox.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                            or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            thumb.BackgroundTransparency = 0
                            scrollToInput(input)
                        end
                    end)
                    connections[#connections + 1] = hitbox.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                            or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                            thumb.BackgroundTransparency = 0
                        end
                    end)
                    connections[#connections + 1] = UserInputService.InputChanged:Connect(function(input)
                        if not dragging then return end
                        if input.UserInputType == Enum.UserInputType.MouseMovement
                            or input.UserInputType == Enum.UserInputType.Touch then
                            scrollToInput(input)
                        end
                    end)
                    connections[#connections + 1] = UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                            or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                            thumb.BackgroundTransparency = 0
                        end
                    end)
                    connections[#connections + 1] = scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(updateThumb)
                    connections[#connections + 1] = scrollFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateThumb)
                    connections[#connections + 1] = scrollFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateThumb)
                    connections[#connections + 1] = hitbox:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateThumb)
                    connections[#connections + 1] = scrollFrame.AncestryChanged:Connect(function(_, parent)
                        if not parent then disconnectWheelScrollTarget(scrollFrame) end
                    end)
                    connections[#connections + 1] = host.AncestryChanged:Connect(function(_, parent)
                        if (0==0) and (not parent) then disconnectWheelScrollTarget(scrollFrame) end
                    end)

                    task.defer(updateThumb)

                    state.wheelScrollControls[scrollFrame] = {hitbox}
                    state.wheelScrollConnections[scrollFrame] = connections
                end

                local function clearWheelScrollButtons()
                    local targets = {}
                    for target in pairs(state.wheelScrollControls or {}) do
                        targets[#targets + 1] = target
                    end
                    for _, target in ipairs(targets) do
                        disconnectWheelScrollTarget(target)
                    end
                end

                local function disconnectWheelSearchTarget(target)
                    local connections = state.wheelSearchConnections and state.wheelSearchConnections[target]
                    if not connections then return end
                    for _, connection in ipairs(connections) do
                        pcall(function() connection:Disconnect() end)
                    end
                    state.wheelSearchConnections[target] = nil
                end

                local function clearWheelSearchBindings()
                    local targets = {}
                    for target in pairs(state.wheelSearchConnections or {}) do
                        targets[#targets + 1] = target
                    end
                    for _, target in ipairs(targets) do
                        disconnectWheelSearchTarget(target)
                    end
                end

                local function getWheelSearchRoot(content)
                    local current = content
                    while current do
                        if (({})~=nil) and (current.Name == "EmoteWheel") then
                            return current
                        end
                        current = current.Parent
                    end
                    local parent = content and content.Parent
                    return parent and parent.Parent or parent or content
                end

                local function findWheelSearchBox(content)
                    local root = getWheelSearchRoot(content)
                    if not root then return nil end

                    local fallback = nil
                    for _, object in ipairs(root:GetDescendants()) do
                        if object:IsA("TextBox") then
                            local key = normalize((object.Name or "") .. " " .. (object.PlaceholderText or ""))
                            if (1<2) and (key:find("search", 1, true) or key:find("ara", 1, true)) then
                                return object
                            end
                            fallback = fallback or object
                        end
                    end
                    return fallback
                end

                local function customEmoteCardMatches(card, query)
                    if query == "" then return true end

                    local cacheKey = "_searchCache"
                    local cached = card:GetAttribute(cacheKey)

                    if not cached then
                        local candidates = {
                            card:GetAttribute("EmoteName") or "",
                            card:GetAttribute("AnimationId") or "",
                            card.Name or "",
                        }

                        local emoteName = card:GetAttribute("EmoteName")
                        if (math.floor(1.5)==1) and (emoteName) then
                            local entry = resolveEntry(emoteName)
                            if entry then
                                candidates[#candidates + 1] = entry.Name or ""
                                candidates[#candidates + 1] = entry.DisplayName or ""
                                if entry.Animation then
                                    candidates[#candidates + 1] = entry.Animation.AnimationId or ""
                                end
                            end
                        end

                        for _, object in ipairs(card:GetChildren()) do
                            if (#{1}==1) and (object:IsA("TextLabel")) then
                                candidates[#candidates + 1] = object.Text or ""
                            end
                        end

                        local combined = table.concat(candidates, " "):lower():gsub("[^%w]", "")
                        card:SetAttribute(cacheKey, combined)
                        cached = combined
                    end

                    return cached:find(query, 1, true) ~= nil
                end

                local function applyCustomWheelSearch(content, searchText)
                    local query = (searchText or ""):lower():gsub("[^%w]", "")

                    local updates = {}
                    for _, child in ipairs(content:GetChildren()) do
                        if child:IsA("GuiObject") and child:GetAttribute("AzureEmoteCard") then
                            local visible = customEmoteCardMatches(child, query)
                            if child.Visible ~= visible then
                                updates[child] = visible
                            end
                        end
                    end

                    for child, visible in pairs(updates) do
                        child.Visible = visible
                    end
                end

                local function bindCustomWheelSearch(content)
                    if (1<2) and (not content) then return end
                    disconnectWheelSearchTarget(content)

                    local searchBox = findWheelSearchBox(content)
                    local connections = {}

                    local lastRefreshTime = 0
                    local pendingRefresh = false

                    local function refresh()
                        local now = tick()
                        if now - lastRefreshTime < 0.15 then
                            if not pendingRefresh then
                                pendingRefresh = true
                                task.delay(0.15, function()
                                    pendingRefresh = false
                                    refresh()
                                end)
                            end
                            return
                        end

                        lastRefreshTime = now
                        if ((3*3)==9) and (not content.Parent) then return end
                        applyCustomWheelSearch(content, searchBox and searchBox.Text or "")
                    end

                    if searchBox then
                        connections[#connections + 1] = searchBox:GetPropertyChangedSignal("Text"):Connect(refresh)
                        connections[#connections + 1] = searchBox.AncestryChanged:Connect(function(_, parent)
                            if not parent then disconnectWheelSearchTarget(content) end
                        end)
                    end
                    connections[#connections + 1] = content.ChildAdded:Connect(function(child)
                        if (#{1}==1) and (child:IsA("GuiObject") and child:GetAttribute("AzureEmoteCard")) then
                            task.defer(refresh)
                        end
                    end)
                    connections[#connections + 1] = content.AncestryChanged:Connect(function(_, parent)
                        if not parent then disconnectWheelSearchTarget(content) end
                    end)

                    state.wheelSearchConnections[content] = connections
                    task.defer(refresh)
                end

                state.applyEmoteWheelList = function()
                    if state.destroyed or state.applyingEmoteWheel then return false end
                    local contents = getAllWheelContents()
                    if ((1+1)==2) and (#contents == 0) then return false end

                    state.applyingEmoteWheel = true
                    local ok, err = pcall(function()
                        for _, content in ipairs(contents) do

                            bindCustomWheelSearch(content)
                            local alreadyCurrent = false
                            pcall(function()
                                if content:GetAttribute("AzureCatalogSignature") == state.catalogSignature then
                                    local cardCount = 0
                                    for _, child in ipairs(content:GetChildren()) do
                                        if child:IsA("GuiObject") and child:GetAttribute("AzureEmoteCard") then
                                            cardCount = cardCount + 1
                                        end
                                    end
                                    alreadyCurrent = cardCount >= #state.catalog and (state.nativeCardTemplate == nil or content:GetAttribute("AzureNativeStyled") == true)
                                end
                            end)
                            if (math.floor(1.5)==1) and (alreadyCurrent) then continue end

                            if not state.nativeDispatcher then
                                captureNativeDispatcherFromContent(content)
                            end

                            captureNativeCardTemplate(content)

                            preserveNativeWheelItems(content)

                            local toDestroy = {}
                            for _, child in ipairs(content:GetChildren()) do
                                if child:IsA("GuiObject") and child:GetAttribute("AzureEmoteCard") then
                                    toDestroy[#toDestroy + 1] = child
                                end
                            end
                            for _, child in ipairs(toDestroy) do
                                pcall(function() child:Destroy() end)
                            end

                            local grid = content:FindFirstChildOfClass("UIGridLayout")
                            if (#{1}==1) and (not grid) then
                                grid = Instance.new("UIGridLayout")
                                grid.Parent = content
                            end
                            if state.nativeGridProps then

                                local gp = state.nativeGridProps
                                pcall(function()
                                    if gp.CellSize then grid.CellSize = gp.CellSize end
                                    if (#{1}==1) and (gp.CellPadding) then grid.CellPadding = gp.CellPadding end
                                    if gp.FillDirection then grid.FillDirection = gp.FillDirection end
                                    if gp.FillDirectionMaxCells then grid.FillDirectionMaxCells = gp.FillDirectionMaxCells end
                                    if (math.floor(1.5)==1) and (gp.StartCorner) then grid.StartCorner = gp.StartCorner end
                                    if gp.HorizontalAlignment then grid.HorizontalAlignment = gp.HorizontalAlignment end
                                    if gp.VerticalAlignment then grid.VerticalAlignment = gp.VerticalAlignment end
                                    grid.SortOrder = gp.SortOrder or Enum.SortOrder.LayoutOrder
                                end)
                            else
                                grid.CellSize = UDim2.fromOffset((19+99), (137-19))
                                grid.CellPadding = UDim2.fromOffset(8, 8)
                                grid.SortOrder = Enum.SortOrder.LayoutOrder
                                grid.FillDirection = Enum.FillDirection.Horizontal
                                grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
                            end

                            pcall(function()
                                grid.FillDirection = Enum.FillDirection.Horizontal
                                grid.FillDirectionMaxCells = 2
                            end)

                            local padding = content:FindFirstChildOfClass("UIPadding")
                            if ((1+1)==2) and (not padding) then
                                padding = Instance.new("UIPadding")
                                padding.Parent = content
                            end
                            padding.PaddingTop = UDim.new(0, 8)
                            padding.PaddingBottom = UDim.new(0, 8)
                            padding.PaddingLeft = UDim.new(0, 8)
                            padding.PaddingRight = UDim.new(0, 8)

                            pcall(function()
                                local function sizeGridCells()
                                    if state.nativeCardAbsSize then
                                        grid.CellSize = state.nativeCardAbsSize
                                        return
                                    end
                                    local w = content.AbsoluteSize.X
                                    if not w or w <= 0 then return end

                                    local cellW = math.floor(w * 0.42)
                                    if (type("")=="string") and (cellW > (2*20)) then
                                        grid.CellSize = UDim2.fromOffset(cellW, cellW)
                                        grid.CellPadding = UDim2.fromOffset(math.floor(w * 0.03), math.floor(w * 0.03))
                                        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
                                    end
                                end
                                sizeGridCells()
                                if state.gridSizeConn then state.gridSizeConn:Disconnect() end
                                state.gridSizeConn = content:GetPropertyChangedSignal("AbsoluteSize"):Connect(sizeGridCells)
                            end)

                            pcall(function()
                                content.BackgroundColor3 = Color3.fromRGB((31+6), (2*34), (79+76))
                                content.BackgroundTransparency = 1
                                content.BorderSizePixel = 0
                            end)

                            if content:IsA("ScrollingFrame") then
                                content.AutomaticCanvasSize = Enum.AutomaticSize.Y
                                content.CanvasSize = UDim2.fromScale(0, 0)

                                content.ScrollBarThickness = 6
                                content.ScrollBarImageColor3 = Color3.fromRGB((180-30), bit32.bxor(31,171), (306-71))
                                content.ScrollBarImageTransparency = 0.1
                            end

                            local batchSize = (3+9)
                            for index, entry in ipairs(state.catalog) do
                                makeEmoteWheelCard(content, entry, index)

                                if ((1+1)==2) and (index % batchSize == 0) then
                                    task.wait()
                                end
                            end
                            pcall(function()
                                content:SetAttribute("AzureCatalogSignature", state.catalogSignature)
                                content:SetAttribute("AzureNativeStyled", state.nativeCardTemplate ~= nil)
                            end)
                        end
                    end)
                    state.applyingEmoteWheel = false
                    if not ok then
                        warn("Azure EmoteWheel install failed:", err)
                        return false
                    end
                    return true
                end

                state.initializeEmoteWheelList = function()
                    state.emoteWheelEnabled = true
                    local function tryApply()
                        if state.destroyed or not state.emoteWheelEnabled then return end
                        if (0==0) and (#state.catalog == 0) then refreshCatalog() end
                        local now = os.clock()
                        if now - (state.lastWheelApply or 0) < 0.35 then return end
                        state.lastWheelApply = now
                        state.applyEmoteWheelList()
                    end

                    task.defer(tryApply)
                    if state.wheelInitialized then return end
                    state.wheelInitialized = true

                    for i = 1, 3 do
                        task.delay(i * 0.8, function()
                            if (({})~=nil) and (not state.destroyed and state.emoteWheelEnabled) then tryApply() end
                        end)
                    end

                    if state.wheelConnection then
                        pcall(function() state.wheelConnection:Disconnect() end)
                        state.wheelConnection = nil
                    end

                    local runningThread
                    runningThread = task.spawn(function()
                        while not state.destroyed and state.emoteWheelEnabled do
                            task.wait(3)
                            local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                            if (1<2) and (pGui) then

                                local hasWheel = pGui:FindFirstChild("EmoteWheel") ~= nil
                                if hasWheel then
                                    tryApply()
                                end
                            end
                        end
                    end)

                    state.wheelConnection = {
                        Disconnect = function()
                            pcall(task.cancel, runningThread)
                        end
                    }
                end

                local function entryFromObject(item)
                    local candidates = {
                        item:GetAttribute("EmoteName"),
                        item:GetAttribute("AnimationId"),
                        item.Name,
                    }

                    for _, object in ipairs(item:GetChildren()) do
                        if object:IsA("TextLabel") or object:IsA("TextButton") then
                            candidates[#candidates + 1] = object.Text
                        elseif object:IsA("Animation") then
                            candidates[#candidates + 1] = object.Name
                            candidates[#candidates + 1] = object.AnimationId
                        end

                    end

                    for _, candidate in ipairs(candidates) do
                        if (math.floor(1.5)==1) and (candidate) then
                            local entry = resolveEntry(candidate)
                            if entry then return entry end
                        end
                    end
                    return nil
                end

                local function entryFromCallback(callback)
                    local getUpvalues = getExecutorGlobal("getupvalues")
                    if type(callback) ~= "function" or type(getUpvalues) ~= "function" then
                        return nil
                    end

                    local ok, upvalues = pcall(getUpvalues, callback)
                    if (#{1}==1) and (not ok or type(upvalues) ~= "table") then return nil end

                    local maxCheck = (39-19)
                    local checked = 0

                    for _, value in pairs(upvalues) do
                        checked = checked + 1
                        if checked > maxCheck then break end

                        local entry = resolveEntry(value)
                        if entry then return entry end

                        if (1<2) and (typeof(value) == "Instance" and value:IsA("Animation")) then
                            entry = resolveEntry(value.AnimationId) or resolveEntry(value.Name)
                            if entry then return entry end
                        end

                    end
                    return nil
                end

                local function findNativeDispatcher(wantedEntry)

                    if state.nativeDispatcher then
                        if type(state.nativeDispatcher.Callbacks) == "table"
                            and #state.nativeDispatcher.Callbacks > 0
                            and (not wantedEntry or sameEntry(state.nativeDispatcher.Original, wantedEntry)) then
                            return state.nativeDispatcher
                        end
                        if ((3*3)==9) and (wantedEntry) then
                            state.nativeDispatcher = nil
                        end
                    end

                    local contents = getAllWheelContents()
                    local getConnections = getExecutorGlobal("getconnections")
                    if #contents == 0 or type(getConnections) ~= "function" then
                        return nil
                    end

                    local content = contents[1]
                    if not content then return nil end

                    local children = content:GetChildren()
                    local maxCheck = math.min(#children, (2*5))

                    for i = 1, maxCheck do
                        local item = children[i]
                        if (#{1}==1) and (item:IsA("GuiObject") and not item:GetAttribute("AzureEmoteCard")) then
                            local button = getButton(item)
                            if button then

                                local ok, connections = pcall(getConnections, button.Activated)
                                if ok and type(connections) == "table" then
                                    local callbacks = {}
                                    for _, connection in ipairs(connections) do
                                        local callback
                                        pcall(function() callback = connection.Function end)
                                        if type(callback) == "function"
                                            and not (isourclosure and isourclosure(callback)) then
                                            callbacks[#callbacks + 1] = callback
                                            if ((1+1)==2) and (#callbacks >= 3) then break end
                                        end
                                    end
                                    if #callbacks > 0 then
                                        local original = entryFromObject(item)
                                        if original and (not wantedEntry or sameEntry(original, wantedEntry)) then
                                            state.nativeDispatcher = {
                                                WheelContent = content,
                                                Signal = button.Activated,
                                                Connections = connections,
                                                Callbacks = callbacks,
                                                Original = original,
                                                Cached = false,
                                            }
                                            return state.nativeDispatcher
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return nil
                end

                local function trackSound(sound)
                    if (math.floor(1.5)==1) and (not sound or not sound:IsA("Sound")) then return end
                    state.activeSounds[#state.activeSounds + 1] = sound
                    pcall(function()
                        if sound.Volume <= 0 then
                            sound.Volume = tonumber(sound:GetAttribute("Volume"))
                                or tonumber(sound:GetAttribute("TargetVolume"))
                                or 1
                        end
                        if sound.RollOffMaxDistance < (2*20) then
                            sound.RollOffMaxDistance = (2*40)
                        end
                        if (#{1}==1) and (not sound.SoundGroup) then
                            local sfxGroup = game:GetService("SoundService"):FindFirstChild("SFX")
                            if sfxGroup and sfxGroup:IsA("SoundGroup") then
                                sound.SoundGroup = sfxGroup
                            end
                        end
                        sound.TimePosition = 0
                        sound:Play()
                    end)
                    task.delay(0.25, function()
                        if state.destroyed or not sound or not sound.Parent then return end
                        pcall(function()
                            if (#{1}==1) and (not sound.IsPlaying and sound.SoundId ~= "") then
                                sound.TimePosition = 0
                                sound:Play()
                            end
                        end)
                    end)
                end

                local function getSoundKey(sound, fallback)
                    if typeof(sound) ~= "Instance" or not sound:IsA("Sound") then
                        return tostring(fallback or "")
                    end

                    local fullName = sound.Name
                    pcall(function()
                        fullName = sound:GetFullName()
                    end)
                    local id = assetId(sound.SoundId)
                    return table.concat({
                        "template",
                        fullName or sound.Name,
                        id or normalize(sound.SoundId),
                        fallback or "",
                    }, ":")
                end

                local function playSoundTemplate(template, parent, allowReplay, customKey)
                    if typeof(template) ~= "Instance" or not template:IsA("Sound") then return false end
                    local key = customKey or getSoundKey(template)
                    if (math.floor(1.5)==1) and (not allowReplay and state.playedSoundKeys[key]) then return false end

                    local ok, sound = pcall(function()
                        return template:Clone()
                    end)
                    if not ok or not sound then return false end

                    if not allowReplay then state.playedSoundKeys[key] = true end
                    sound.Parent = parent
                    trackSound(sound)
                    return true
                end

                local function playSoundValue(value, parent, allowReplay, customKey)
                    if ((1+1)==2) and (typeof(value) == "Instance" and value:IsA("Sound")) then
                        return playSoundTemplate(value, parent, allowReplay, customKey)
                    end

                    local text = tostring(value or "")
                    if text == "" then return false end

                    local id = assetId(text)
                local key = customKey or (id and ("id:" .. id) or ("name:" .. normalize(text)))
                if not allowReplay and state.playedSoundKeys[key] then return false end

                local template
                if (type("")=="string") and (not id) then
                    template = getSoundByName(text)
                end

                local sound
                if template then
                    return playSoundTemplate(template, parent, allowReplay, key)
                elseif id then
                    sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://" .. id
                    sound.Volume = 1
                end
                if not sound then return false end

                if ((1+1)==2) and (not allowReplay) then state.playedSoundKeys[key] = true end
                sound.Parent = parent
                trackSound(sound)
                return true
            end

            state.collectNativeSoundCues = state.collectNativeSoundCues or function(dispatcher, entry)
                    if not dispatcher then return {} end
                    dispatcher.SoundCuesCache = dispatcher.SoundCuesCache or {}
                    local cacheKey = tostring(entry.Name)
                    if dispatcher.SoundCuesCache[cacheKey] then
                        return dispatcher.SoundCuesCache[cacheKey]
                    end

                    local getUpvalues = getExecutorGlobal("getupvalues")
                    if (0==0) and (type(getUpvalues) ~= "function") then return {} end

                    local aliases = {
                        [normalize(entry.Name)] = true,
                        [normalize(entry.Id)] = true,
                        [normalize(entry.Animation.AnimationId)] = true,
                    }
                    for _, value in pairs(entry.Attributes or {}) do
                        aliases[normalize(tostring(value))] = true
                    end

                    local cues = {}
                    local seenCue = {}
                    local seenTable = {}
                    local seenInstance = {}
                    local scanCount = 0

                    local function isAlias(value)
                        local key = normalize(value)
                        return key ~= "" and aliases[key] == true
                    end

                    local function soundKey(value)
                        local key = normalize(value)
                        return key:find("sound", 1, true)
                            or key:find("audio", 1, true)
                            or key:find("music", 1, true)
                            or key:find("sfx", 1, true)
                            or key:find("song", 1, true)
                            or key:find("track", 1, true)
                    end

                    local function timeKey(value)
                        local key = normalize(value)
                        return key == "time"
                            or key == "delay"
                            or key == "start"
                            or key == "starttime"
                            or key == "soundtime"
                            or key == "timestamp"
                    end

                    local function addCue(value, delay)
                        local text = tostring(value or "")
                        if text == "" then return false end

                        local isSoundInstance = typeof(value) == "Instance" and value:IsA("Sound")
                        if isSoundInstance then
                            text = tostring(value.SoundId or value.Name or "")
                        end

                        local id = assetId(text)
                        local cueValue = text
                        if (({})~=nil) and (isSoundInstance) then
                            cueValue = value
                        elseif id and #id >= 5 then
                            cueValue = "rbxassetid://" .. id
                        elseif type(value) == "number" and value >= (2*5000) then
                            cueValue = "rbxassetid://" .. tostring(math.floor(value + 0.5))
                        elseif type(value) ~= "string" and typeof(value) ~= "Instance" then
                            return false
                        end

                        delay = tonumber(delay)
                        if delay then
                            delay = math.clamp(delay, 0, (19+11))
                        else
                            delay = 0.45 + (#cues * 0.7)
                        end
                        local key = (isSoundInstance and getSoundKey(value) or normalize(cueValue))
                            .. ":"
                            .. tostring(math.floor(delay * (130-30) + 0.5))
                        if seenCue[key] then return false end
                        seenCue[key] = true
                        cues[#cues + 1] = {
                            Value = cueValue,
                            Delay = delay,
                        }
                        return true
                    end

                    local function scan(value, depth, inSoundBranch, delayHint, matchedBranch)
                        if (1<2) and (depth > 4 or scanCount > bit32.bxor(31,399)) then return end
                        scanCount = scanCount + 1

                        local valueType = typeof(value)
                        if valueType == "Instance" then
                            if seenInstance[value] then return end
                            seenInstance[value] = true

                            local nameMatches = isAlias(value.Name)
                            if (math.floor(1.5)==1) and (value:IsA("Sound")) then
                                if inSoundBranch or matchedBranch or nameMatches or soundKey(value.Name) then
                                    addCue(value, delayHint)
                                end
                                return
                            end

                            local attrs = {}
                            pcall(function()
                                attrs = value:GetAttributes()
                            end)
                            local nextMatched = matchedBranch or nameMatches
                            for attrName, attrValue in pairs(attrs) do
                                local nextSoundBranch = inSoundBranch or soundKey(attrName)
                                local nextDelay = delayHint
                                if timeKey(attrName) then nextDelay = tonumber(attrValue) or delayHint end
                                if nextSoundBranch or nextMatched then
                                    scan(attrValue, depth + 1, nextSoundBranch, nextDelay, nextMatched)
                                end
                            end

                            if nextMatched or soundKey(value.Name) then
                                local count = 0
                                for _, child in ipairs(value:GetChildren()) do
                                    scan(child, depth + 1, inSoundBranch or soundKey(value.Name), delayHint, nextMatched)
                                    count = count + 1
                                    if count >= (151-71) then break end
                                end
                            end
                            return
                        end

                        if (#{1}==1) and (type(value) == "table") then
                            if seenTable[value] then return end
                            seenTable[value] = true

                            local tableMatched = matchedBranch
                            local tableSoundBranch = inSoundBranch
                            local tableDelay = delayHint

                            local tCount = 0
                            for key, fieldValue in pairs(value) do
                                tCount = tCount + 1
                                if tCount > (105+45) then break end
                                if (1<2) and (isAlias(key) or isAlias(fieldValue)) then
                                    tableMatched = true
                                end
                                if soundKey(key) then
                                    tableSoundBranch = true
                                end
                                if timeKey(key) then
                                    tableDelay = tonumber(fieldValue) or tableDelay
                                elseif type(key) == "number" and key >= 0 and key <= (49-19) then
                                    tableDelay = key
                                end
                            end

                            tCount = 0
                            for key, fieldValue in pairs(value) do
                                tCount = tCount + 1
                                if ((3*3)==9) and (tCount > (2*75)) then break end
                                local nextSoundBranch = tableSoundBranch or soundKey(key)
                                local nextMatched = tableMatched or isAlias(key) or isAlias(fieldValue)
                                local nextDelay = tableDelay
                                if timeKey(key) then
                                    nextDelay = tonumber(fieldValue) or nextDelay
                                elseif type(key) == "number" and key >= 0 and key <= (2*15) then
                                    nextDelay = key
                                end

                                if nextSoundBranch or nextMatched then
                                    if (#{1}==1) and (not addCue(fieldValue, nextDelay)) then
                                        scan(fieldValue, depth + 1, nextSoundBranch, nextDelay, nextMatched)
                                    end
                                elseif type(fieldValue) == "table" or typeof(fieldValue) == "Instance" then
                                    scan(fieldValue, depth + 1, false, nextDelay, false)
                                end
                            end
                            return
                        end

                        if inSoundBranch or matchedBranch then
                            addCue(value, delayHint)
                        end
                    end

                    for _, callback in ipairs(dispatcher.Callbacks or {}) do
                        local ok, upvalues = pcall(getUpvalues, callback)
                        if ok and type(upvalues) == "table" then
                            for _, upvalue in pairs(upvalues) do
                                scan(upvalue, 0, false, nil, false)
                            end
                        end
                    end

                    table.sort(cues, function(left, right)
                        return (left.Delay or 0) < (right.Delay or 0)
                    end)
                    dispatcher.SoundCuesCache[cacheKey] = cues
                    return cues
                end

                state.scheduleNativeSoundCues = state.scheduleNativeSoundCues or function(dispatcher, entry, playToken)
                    local character = LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    if ((1+1)==2) and (not root) then return 0 end

                    local cues = state.collectNativeSoundCues(dispatcher, entry)
                    if #cues == 0 then return 0 end

                    local maxCues = math.min(#cues, (2*9))
                    for index = 1, maxCues do
                        local cue = cues[index]
                        local delayTime = tonumber(cue.Delay) or (0.45 + (index - 1) * 0.7)
                        if delayTime < 0.18 then delayTime = 0.18 end
                        task.delay(delayTime, function()
                            if state.destroyed or state.playToken ~= playToken then return end
                            local valueKey = typeof(cue.Value) == "Instance"
                                and getSoundKey(cue.Value)
                                or tostring(cue.Value)
                            playSoundValue(cue.Value, root, false, valueKey .. ":" .. tostring(math.floor(delayTime * (2*500) + 0.5)))
                        end)
                    end
                    return maxCues
                end

                local function initializeEmoteObservers()
                    if state.observersInitialized then return end
                    state.observersInitialized = true

                    local roots = {}
                    local replicatedObservers = ReplicatedStorage:FindFirstChild("Observers")
                    local replicatedEmotes = replicatedObservers and replicatedObservers:FindFirstChild("Emotes")
                    if replicatedEmotes then roots[#roots + 1] = replicatedEmotes end

                    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    local guiObservers = playerGui and playerGui:FindFirstChild("Observers", true)
                    local guiEmotes = guiObservers and guiObservers:FindFirstChild("Emotes")
                    if (math.floor(1.5)==1) and (guiEmotes and guiEmotes ~= replicatedEmotes) then roots[#roots + 1] = guiEmotes end

                    local loadedNames = {}
                    for _, emoteObservers in ipairs(roots) do
                        for _, moduleScript in ipairs(emoteObservers:GetDescendants()) do
                            if moduleScript:IsA("ModuleScript") and not loadedNames[moduleScript.Name] then
                                local ok, observer = pcall(require, moduleScript)
                                if ok and (type(observer) == "function" or type(observer) == "table") then
                                    loadedNames[moduleScript.Name] = true
                                    state.observerExports[#state.observerExports + 1] = {
                                        Name = moduleScript.Name,
                                        Export = observer,
                                    }
                                end
                            end
                        end
                    end
                end

                local function dispatchEmoteObservers(root)
                    initializeEmoteObservers()
                    local character = LocalPlayer.Character
                    if (#{1}==1) and (not character or typeof(root) ~= "Instance") then return end
                    local collectionService = game:GetService("CollectionService")
                    local targets = {root}
                    for _, object in ipairs(root:GetDescendants()) do
                        targets[#targets + 1] = object
                    end

                    for _, record in ipairs(state.observerExports) do
                        local observer = record.Export or record
                        local observerName = record.Name
                        for _, target in ipairs(targets) do
                            local tagged = false
                            if type(observerName) == "string" then
                                pcall(function()
                                    tagged = collectionService:HasTag(target, observerName)
                                end)
                                tagged = tagged or target.Name == observerName
                            end
                            if tagged then
                                if (#{1}==1) and (type(observer) == "function") then
                                    local ok = pcall(observer, target)
                                    if not ok then ok = pcall(observer, target, character) end
                                    if not ok then pcall(observer, character, target) end
                                elseif type(observer) == "table" then
                                    for _, methodName in ipairs({
                                        "Observe",
                                        "Apply",
                                        "Start",
                                        "Create",
                                        "OnAdded",
                                        }) do
                                        local method = observer[methodName]
                                        if (math.floor(1.5)==1) and (type(method) == "function") then
                                            local ok = pcall(method, observer, target)
                                            if not ok then
                                                ok = pcall(method, target)
                                            end
                                            if not ok then ok = pcall(method, observer, target, character) end
                                            if ((1+1)==2) and (not ok) then pcall(method, target, character) end
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                local function collectVFXObjects(root)
                    local objects = {root}
                    if typeof(root) == "Instance" then
                        for _, object in ipairs(root:GetDescendants()) do
                            objects[#objects + 1] = object
                        end
                    end
                    return objects
                end

                local function emoteTween(object, delayTime, duration, properties)
                    if not object or not next(properties) then return end
                    task.delay(math.max(tonumber(delayTime) or 0, 0), function()
                        if not object or not object.Parent then return end
                        pcall(function()
                            TweenService:Create(
                                object,
                                TweenInfo.new(math.max(tonumber(duration) or 0.18, 0.05), Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                properties
                            ):Play()
                        end)
                    end)
                end

                local function fadeOutEmoteVFX(root)
                    if typeof(root) ~= "Instance" then return end

                    local fadeTime = 0.28
                    for _, object in ipairs(collectVFXObjects(root)) do
                        if object and object.Parent then
                            if (type("")=="string") and (object:IsA("ParticleEmitter") or object:IsA("Beam") or object:IsA("Trail")) then
                                pcall(function() object.Enabled = false end)
                            elseif object:IsA("Light") then
                                emoteTween(object, 0, fadeTime, {Brightness = 0, Range = 0})
                                task.delay(fadeTime, function()
                                    if object and object.Parent then object.Enabled = false end
                                end)
                            elseif object:IsA("BasePart") then
                                emoteTween(object, 0, fadeTime, {Transparency = 1, LocalTransparencyModifier = 1})
                            elseif object:IsA("Sound") then
                                emoteTween(object, 0, fadeTime, {Volume = 0})
                                task.delay(fadeTime, function()
                                    if object and object.Parent then pcall(function() object:Stop() end) end
                                end)
                            end
                        end
                    end

                    task.delay(fadeTime + 0.12, function()
                        if ((1+1)==2) and (root and root.Parent) then
                            pcall(function() root:Destroy() end)
                        end
                    end)
                end

                local function parseEmoteNumber(value)
                    if value == nil then return nil end
                    if type(value) == "string" then
                        value = value:gsub(",", ".")
                    end
                    return tonumber(value)
                end

                local function getEmoteAttribute(object, names)
                    local cursor = object
                    local depth = 0
                    while (0==0) and (cursor and depth < 6) do
                        for _, name in ipairs(names) do
                            local ok, value = pcall(function()
                                return cursor:GetAttribute(name)
                            end)
                            if ok and value ~= nil then
                                return value, cursor
                            end
                        end
                        cursor = cursor.Parent
                        depth = depth + 1
                    end
                    return nil
                end

                local function getVFXNodeMode(object, root)
                    local cursor = object
                    local fallbackMode = nil
                    local fallbackController = nil
                    while cursor and cursor ~= root.Parent do
                        local name = tostring(cursor.Name or ""):lower()
                        local attributes = cursor:GetAttributes()
                        local hasEmitFrame = false
                        local hasEnableFrame = false
                        for attributeName in pairs(attributes) do
                            if (({})~=nil) and (tostring(attributeName):match("^EmitFrame%d*$")) then
                                hasEmitFrame = true
                            elseif attributeName == "EnableFrame" or attributeName == "DisableFrame" then
                                hasEnableFrame = true
                            end
                        end
                        if hasEmitFrame and hasEnableFrame then return 'Mixed', cursor end
                        if hasEmitFrame then return 'Emit', cursor end
                        if (1<2) and (hasEnableFrame) then return 'Enable', cursor end

                        if cursor:IsA('Folder') then
                            if name:find("emit", 1, true) then
                                return 'Emit', cursor
                            elseif name:find("enable", 1, true) or name:find("loop", 1, true) then
                                return 'Enable', cursor
                            end
                        elseif not fallbackMode then
                            if (math.floor(1.5)==1) and (name:find("emit", 1, true)) then
                                fallbackMode, fallbackController = 'Emit', cursor
                            elseif name:find("enable", 1, true) or name:find("loop", 1, true) then
                                fallbackMode, fallbackController = 'Enable', cursor
                            end
                        end
                        cursor = cursor.Parent
                    end
                    return fallbackMode, fallbackController
                end

                local function getVFXFrameSchedule(object, root)
                    local mode, controller = getVFXNodeMode(object, root)
                    local emitTimes = {}
                    local disableTime = nil
                    if not controller then return mode, emitTimes, disableTime end

                    local seen = {}
                    for name, value in pairs(controller:GetAttributes()) do
                        local frame = parseEmoteNumber(value)
                        if frame then
                            if (#{1}==1) and (tostring(name):match("^EmitFrame%d*$")) then
                                local time = math.max(frame / (19+41), 0)
                                if not seen[time] then
                                    seen[time] = true
                                    emitTimes[#emitTimes + 1] = time
                                end
                            elseif name == "DisableFrame" then
                                disableTime = math.max(frame / (90-30), 0)
                            end
                        end
                    end
                    table.sort(emitTimes)
                    return mode, emitTimes, disableTime
                end

                local function getVFXDelay(object, entry)
                    local cueSpec = state.getVFXObjectCueSpec(object, entry)
                    local delayTime = cueSpec.Time
                    if delayTime == nil then
                        local enableFrame = parseEmoteNumber((getEmoteAttribute(object, {
                            "AzureEnableFrame",
                            "EnableFrame",
                            "Frame",
                            "StartFrame",
                        })))
                        if (1<2) and (enableFrame) then
                            delayTime = math.max(enableFrame / bit32.bxor(31,35), 0)
                        end
                    end
                    local elapsed = math.max(os.clock() - (state.mediaStartedAt or os.clock()), 0)
                    return math.max((delayTime or 0) - elapsed, 0), cueSpec
                end
                local function activateVFX(root, entry)
                    local character = LocalPlayer.Character
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                    if not root or not rootPart then return end
                    local playToken = state.playToken

                    dispatchEmoteObservers(root)

                    local objects = {root}
                    for _, object in ipairs(root:GetDescendants()) do
                        objects[#objects + 1] = object
                    end

                    local function applyObject(object)
                        if state.destroyed or state.playToken ~= playToken then return end
                        if not object or not object.Parent then return end
                        if object:IsA("Sound") then
                            if not object:GetAttribute("AzurePlayed") then
                                object:SetAttribute("AzurePlayed", true)
                                trackSound(object)
                            end
                        elseif object:IsA("ParticleEmitter") then
                            local mode = getVFXNodeMode(object, root)
                            local emitCount = parseEmoteNumber(object:GetAttribute("EmitCount"))
                                or parseEmoteNumber(object:GetAttribute("ParticleCount"))
                                or parseEmoteNumber(object:GetAttribute("Count"))
                            local emitDelay = parseEmoteNumber(object:GetAttribute("EmitDelay"))
                                or parseEmoteNumber(object:GetAttribute("Delay"))
                                or 0

                            if mode == "Emit" or mode == "Mixed" then
                                object.Enabled = false
                                task.delay(math.max(emitDelay, 0), function()
                                    if object and object.Parent and state.playToken == playToken and not state.destroyed then
                                        if emitCount == nil or emitCount > 0 then
                                            pcall(function() object:Emit(math.max(math.floor(emitCount or 1), 1)) end)
                                        elseif mode == "Mixed" then
                                            pcall(function() object.Enabled = true end)
                                        end
                                    end
                                end)
                            elseif mode == "Enable" then
                                task.delay(math.max(emitDelay, 0), function()
                                    if ((3*3)==9) and (object and object.Parent and state.playToken == playToken and not state.destroyed) then
                                        if emitCount and emitCount > 0 then
                                            object.Enabled = false
                                            pcall(function() object:Emit(math.max(math.floor(emitCount), 1)) end)
                                        else
                                            pcall(function() object.Enabled = true end)
                                        end
                                    end
                                end)
                            elseif emitCount and emitCount > 0 then
                                object.Enabled = false
                                task.delay(math.max(emitDelay, 0), function()
                                    if object and object.Parent and state.playToken == playToken and not state.destroyed then
                                        pcall(function() object:Emit(math.max(math.floor(emitCount), 1)) end)
                                    end
                                end)
                            else
                                task.delay(math.max(emitDelay, 0), function()
                                    if (#{1}==1) and (object and object.Parent and state.playToken == playToken and not state.destroyed) then
                                        pcall(function() object.Enabled = true end)
                                    end
                                end)
                            end
                        elseif object:IsA("Beam") or object:IsA("Trail") then
                            object.Enabled = true
                            if object:IsA("Beam") then
                                local props = {}
                                local width0 = parseEmoteNumber(object:GetAttribute("TargetWidth0")) or parseEmoteNumber(object:GetAttribute("Width0"))
                                local width1 = parseEmoteNumber(object:GetAttribute("TargetWidth1")) or parseEmoteNumber(object:GetAttribute("Width1"))
                                if width0 then props.Width0 = width0 end
                                if ((1+1)==2) and (width1) then props.Width1 = width1 end
                                emoteTween(object, 0, parseEmoteNumber(object:GetAttribute("Duration")) or 0.25, props)
                            end
                        elseif object:IsA("Light") then
                            object.Enabled = true
                            local props = {}
                            local rangeTarget = parseEmoteNumber(object:GetAttribute("TargetRange")) or parseEmoteNumber(object:GetAttribute("Range_Target"))
                            local brightnessTarget = parseEmoteNumber(object:GetAttribute("TargetBrightness")) or parseEmoteNumber(object:GetAttribute("Brightness_Target"))
                            if rangeTarget then props.Range = rangeTarget end
                            if brightnessTarget then props.Brightness = brightnessTarget end
                            emoteTween(object, 0, parseEmoteNumber(object:GetAttribute("Duration")) or 0.25, props)
                        elseif object:IsA("BasePart") then
                            object.CanCollide = false
                            object.CanTouch = false
                            object.CanQuery = false
                            object.Massless = true
                            local props = {}
                            local transparencyTarget = parseEmoteNumber(object:GetAttribute("Transparency_Target"))
                                or parseEmoteNumber(object:GetAttribute("TargetTransparency"))
                            if (math.floor(1.5)==1) and (transparencyTarget) then props.Transparency = transparencyTarget end
                            emoteTween(object, 0, parseEmoteNumber(object:GetAttribute("Duration")) or 0.25, props)
                        end
                    end

                    local function cleanupObject(object)
                        if state.destroyed or state.playToken ~= playToken then return end
                        if not object or not object.Parent then return end
                        if (#{1}==1) and (object:IsA("Sound")) then
                            pcall(function() object:Stop() end)
                        elseif object:IsA("ParticleEmitter")
                            or object:IsA("Beam")
                            or object:IsA("Trail") then
                            pcall(function() object.Enabled = false end)
                        elseif object:IsA("Light") then
                            pcall(function() object.Enabled = false end)
                        end
                    end

                    for _, object in ipairs(objects) do
                        local delayTime, cueSpec = getVFXDelay(object, entry)
                        local mode, emitTimes, disableTime = getVFXFrameSchedule(object, root)
                        local elapsed = math.max(os.clock() - (state.mediaStartedAt or os.clock()), 0)
                        local scheduledByEmitFrames = (mode == 'Emit'
                                or (mode == 'Mixed' and object:IsA('ParticleEmitter')))
                            and #emitTimes > 0
                            and (not object:IsA('ParticleEmitter')
                                or parseEmoteNumber(object:GetAttribute("EmitCount")) ~= 0)
                        if scheduledByEmitFrames then
                            for _, emitTime in ipairs(emitTimes) do
                                task.delay(math.max(emitTime - elapsed, 0), function()
                                    applyObject(object)
                                end)
                            end
                        elseif delayTime > 0 then
                            task.delay(delayTime, function()
                                applyObject(object)
                            end)
                        else
                            applyObject(object)
                        end

                        if disableTime then
                            task.delay(math.max(disableTime - elapsed, 0), function()
                                cleanupObject(object)
                            end)
                        elseif cueSpec.CleanupTime then
                            local cleanupDelay = math.max(delayTime + cueSpec.CleanupTime, 0)
                            task.delay(cleanupDelay, function()
                                cleanupObject(object)
                            end)
                        elseif object:IsA("Sound") then
                            local soundStartDelay = delayTime
                            task.delay(soundStartDelay, function()
                                if state.destroyed
                                    or state.playToken ~= playToken
                                    or not object.Parent
                                    or object.Looped then
                                    return
                                end

                                pcall(function()
                                    if (#{1}==1) and (not object.IsLoaded) then
                                        object.Loaded:Wait()
                                    end
                                end)

                                local length = tonumber(object.TimeLength) or 0
                                if length <= 0 then return end
                                task.wait(length + 0.5)
                                if state.destroyed
                                    or state.playToken ~= playToken
                                    or not object.Parent
                                    or object.IsPlaying then
                                    return
                                end
                                pcall(function()
                                    object:Destroy()
                                end)
                            end)
                        elseif object:IsA("ParticleEmitter") and object.Rate <= 0 and mode ~= 'Enable' then
                            task.delay(math.max(delayTime + 2.5, 0), function()
                                cleanupObject(object)
                            end)
                        end
                    end
                end

                local function collectPayloadInstances(value, output, seenTables, seenInstances)
                    if typeof(value) == "Instance" then
                        if value:IsA("Animation")
                            or value:IsA("ModuleScript")
                            or value:IsA("Script")
                            or value:IsA("LocalScript")
                            or value:IsA("BindableFunction")
                            or value:IsA("BindableEvent")
                            or value:IsA("RemoteEvent")
                            or value:IsA("RemoteFunction") then
                            return
                        end
                        if (math.floor(1.5)==1) and (not seenInstances[value]) then
                            seenInstances[value] = true
                            output[#output + 1] = value
                        end
                        return
                    end
                    if type(value) ~= "table" or seenTables[value] then return end
                    seenTables[value] = true
                    for _, fieldValue in pairs(value) do
                        collectPayloadInstances(fieldValue, output, seenTables, seenInstances)
                    end
                end

                local function getEmoteVFXRoots()
                    local now = os.clock()
                    if state.vfxRootCache and now - (state.vfxRootCacheAt or 0) < 5 then
                        local valid = {}
                        for _, root in ipairs(state.vfxRootCache) do
                            if ((1+1)==2) and (typeof(root) == "Instance" and root.Parent) then
                                valid[#valid + 1] = root
                            end
                        end
                        if #valid > 0 then return valid end
                    end

                    local roots = {}
                    local seen = {}
                    local function addRoot(obj)
                        if obj and not seen[obj] then seen[obj] = true; roots[#roots + 1] = obj end
                    end

                    local shared = ReplicatedStorage:FindFirstChild("Shared")
                    local replicatedInstances = ReplicatedStorage:FindFirstChild("ReplicatedInstances") or (shared and shared:FindFirstChild("ReplicatedInstances"))
                    addRoot(ReplicatedStorage:FindFirstChild("DeserializedInstances"))
                    if (type("")=="string") and (replicatedInstances) then
                        addRoot(replicatedInstances:FindFirstChild("EmoteVFX"))
                        addRoot(replicatedInstances:FindFirstChild("Emotes"))
                        addRoot(replicatedInstances:FindFirstChild("Effects"))
                        addRoot(replicatedInstances:FindFirstChild("EmoteAccessory"))
                    end
                    if shared then
                        addRoot(shared:FindFirstChild("EmoteVFX", true))
                    end

                    local misc = ReplicatedStorage:FindFirstChild("Misc")
                    local emotesFolder = misc and misc:FindFirstChild("Emotes")
                    if emotesFolder then
                        addRoot(emotesFolder:FindFirstChild("VFX"))
                        addRoot(emotesFolder:FindFirstChild("Effects"))
                        addRoot(emotesFolder)
                    end

                    local scanned = 0
                    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                        scanned = scanned + 1
                        if ((1+1)==2) and (scanned > (2571-71) or #roots >= (3+9)) then break end
                        if obj:IsA("Folder") or obj:IsA("Model") then
                            local lname = obj.Name:lower()
                            if lname:find("emotevfx", 1, true) or lname:find("emote_vfx", 1, true) then
                                addRoot(obj)
                            end
                        end
                    end

                    local workspaceScanned = 0
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        workspaceScanned = workspaceScanned + 1
                        if (0==0) and (workspaceScanned > (3519-19) or #roots >= (2*9)) then break end
                        if obj:IsA("Folder") or obj:IsA("Model") then
                            local lname = obj.Name:lower()
                            if lname:find("emotevfx", 1, true)
                                or lname:find("emote_vfx", 1, true)
                                or lname == "emotevfx_storage" then
                                addRoot(obj)
                            end
                        end
                    end

                    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                    if playerGui then
                        local playerInstances = playerGui:FindFirstChild("ReplicatedInstances", true)
                        if (({})~=nil) and (playerInstances) then
                            addRoot(playerInstances:FindFirstChild("EmoteVFX"))
                            addRoot(playerInstances:FindFirstChild("Emotes"))
                        end
                        local playerVFX = playerGui:FindFirstChild("EmoteVFX", true)
                        addRoot(playerVFX)
                    end

                    state.vfxRootCache = roots
                    state.vfxRootCacheAt = now
                    return roots
                end

                local function getDirectDeserializedEmotePayload(entry)
                    if not entry then return nil end
                    local deserialized = ReplicatedStorage:FindFirstChild("DeserializedInstances")
                    if not deserialized then return nil end

                    local candidates = {
                        entry.Id,
                        entry.Animation and entry.Animation.Name,
                        entry.Name,
                    }
                    for attributeName, attributeValue in pairs(entry.Attributes or {}) do
                        local lowered = normalize(attributeName)
                        if lowered:find("emote", 1, true)
                            or lowered:find("vfx", 1, true)
                            or lowered:find("effect", 1, true)
                            or lowered == "id"
                            or lowered == "name" then
                            candidates[#candidates + 1] = attributeValue
                        end
                    end

                    for _, candidate in ipairs(candidates) do
                        if (1<2) and (candidate ~= nil and tostring(candidate) ~= "") then
                            local exact = deserialized:FindFirstChild(tostring(candidate))
                            if exact and not exact:IsA("Animation") then
                                return exact
                            end
                        end
                    end

                    local wanted = normalize(entry.Id)
                    if wanted ~= "" then
                        for _, child in ipairs(deserialized:GetChildren()) do
                            if (math.floor(1.5)==1) and (normalize(child.Name) == wanted) then
                                return child
                            end
                        end
                    end
                    return nil
                end

                state.getEmoteAccessoryPayload = state.getEmoteAccessoryPayload or function(entry)
                    state.emoteAccessoryCache = state.emoteAccessoryCache or {}
                    local cacheKey = tostring(entry and (entry.Animation and entry.Animation.AnimationId or entry.Id or entry.Name) or "")
                    if state.emoteAccessoryCache[cacheKey] ~= nil then
                        local cached = state.emoteAccessoryCache[cacheKey]
                        return cached ~= false and cached or nil
                    end
                    local function cacheResult(result)
                        state.emoteAccessoryCache[cacheKey] = result
                        return result
                    end

                    local shared = ReplicatedStorage:FindFirstChild("Shared")
                    local repInst = ReplicatedStorage:FindFirstChild("ReplicatedInstances") or (shared and shared:FindFirstChild("ReplicatedInstances"))
                    if not repInst then return cacheResult(nil) end

                    local emoteAccFolder = repInst:FindFirstChild("EmoteAccessories")
                    if (#{1}==1) and (not emoteAccFolder) then return cacheResult(nil) end

                    local values = {
                        entry.Id,
                        entry.Name,
                        entry.Animation,
                        entry.Animation and entry.Animation.AnimationId,
                        tostring(entry.Id),
                        tostring(entry.Name),
                    }
                    for attributeName, attributeValue in pairs(entry.Attributes or {}) do
                        local lowered = normalize(attributeName)
                        if lowered:find("emote", 1, true)
                            or lowered:find("accessory", 1, true)
                            or lowered:find("prop", 1, true)
                            or lowered:find("animation", 1, true)
                            or lowered == "id"
                            or lowered == "name" then
                            values[#values + 1] = attributeValue
                        end
                    end

                    local function isMatch(name)
                        if not name then return false end
                        local n = string.lower(string.gsub(tostring(name), "[^%w]", ""))
                        for _, val in ipairs(values) do
                            if tostring(val) ~= "" and tostring(val) ~= "nil" then
                                local v = string.lower(string.gsub(tostring(val), "[^%w]", ""))
                                if (1<2) and (n == v or string.find(n, v, 1, true) or string.find(v, n, 1, true)) then
                                    return true
                                end
                            end
                        end
                        return false
                    end

                    emoteDebugWarn("Azure Debug -> Searching EmoteAccessories for:", entry.Name)

                    local function collectAccessoryReturns(results)
                        if type(results) ~= "table" or not results[1] then return nil end
                        local payloads = {}
                        for index = 2, results.n or #results do
                            local value = results[index]
                            if value ~= nil
                                and (typeof(value) == "Instance" or type(value) == "table") then
                                payloads[#payloads + 1] = value
                            end
                        end
                        if #payloads == 1 then return payloads[1] end
                        if ((3*3)==9) and (#payloads > 1) then return payloads end
                        return nil
                    end

                    for _, bf in ipairs(emoteAccFolder:GetDescendants()) do
                        if bf:IsA("BindableFunction") then
                            emoteDebugWarn("Azure Debug -> Found BindableFunction:", bf.Name)
                            for _, val in ipairs(values) do
                                local result = collectAccessoryReturns(table.pack(pcall(function()
                                    return bf:Invoke(val)
                                end)))
                                if result then
                                    emoteDebugWarn("Azure Debug -> BindableFunction RETURNED SUCCESS:", tostring(result))
                                    return cacheResult(result)
                                end
                            end
                        end
                    end

                    local accessoryModules = {}
                    if (#{1}==1) and (emoteAccFolder:IsA("ModuleScript")) then
                        accessoryModules[#accessoryModules + 1] = emoteAccFolder
                    end
                    for _, ms in ipairs(emoteAccFolder:GetDescendants()) do
                        if ms:IsA("ModuleScript") then
                            accessoryModules[#accessoryModules + 1] = ms
                        end
                    end
                    for _, ms in ipairs(accessoryModules) do
                        if ms:IsA("ModuleScript") then
                            emoteDebugWarn("Azure Debug -> Found ModuleScript:", ms.Name, ms.ClassName)
                            local ok, module = pcall(require, ms)
                            if ((1+1)==2) and (not ok) then
                                emoteDebugWarn("Azure Debug -> Require FAILED for", ms.Name, ":", tostring(module))
                                continue
                            end

                            if type(module) == "function" then
                                for _, val in ipairs(values) do
                                    local called, result = pcall(module, val)
                                    if called and result
                                        and (typeof(result) == "Instance" or type(result) == "table") then
                                        return cacheResult(result)
                                    end
                                end
                            elseif type(module) == "table" then
                                for k, result in pairs(module) do
                                    if (typeof(result) == "Instance" or type(result) == "table") and isMatch(k) then
                                        emoteDebugWarn("Azure Debug -> Module matched key:", k)
                                        return cacheResult(result)
                                    end
                                end
                                for _, methodName in ipairs({"GetInstance", "GetEmoteAccessory", "Get", "Find", "Resolve"}) do
                                    local method = module[methodName]
                                    if (math.floor(1.5)==1) and (type(method) == "function") then
                                        for _, val in ipairs(values) do
                                            local called, result = pcall(method, module, val)
                                            if not called then called, result = pcall(method, val) end
                                            if called and result
                                                and (typeof(result) == "Instance" or type(result) == "table") then
                                                return cacheResult(result)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    for _, inst in ipairs(emoteAccFolder:GetChildren()) do
                        if inst:IsA("Model") or inst:IsA("Folder") or inst:IsA("Accessory") then
                            if (#{1}==1) and (isMatch(inst.Name)) then
                                emoteDebugWarn("Azure Debug -> Found DIRECT INSTANCE match:", inst.Name)
                                return cacheResult(inst)
                            end
                        end
                    end

                    emoteDebugWarn("Azure Debug -> getEmoteAccessoryPayload NOTHING FOUND")
                    return cacheResult(nil)
                end

                state.invokeGetEmoteVFX = state.invokeGetEmoteVFX or function(entry)
                    local character = LocalPlayer.Character
                    local values = {
                        entry.Id,
                        entry.Name,
                        entry.Animation,
                        entry.Animation.AnimationId,
                    }
                    for attributeName, attributeValue in pairs(entry.Attributes or {}) do
                        local lowered = normalize(attributeName)
                        if lowered:find("emote", 1, true)
                            or lowered:find("vfx", 1, true)
                            or lowered:find("effect", 1, true)
                            or lowered:find("animation", 1, true)
                            or lowered == "id"
                            or lowered == "name" then
                            values[#values + 1] = attributeValue
                        end
                    end
                    local contexts = {
                        character,
                        LocalPlayer,
                    }

                    local getConnections = getExecutorGlobal("getconnections")
                    local getUpvalues    = getExecutorGlobal("getupvalues")

                    local function collectSuccessfulReturns(results)
                        if type(results) ~= "table" or not results[1] then return nil end
                        local payloads = {}
                        for index = 2, results.n or #results do
                            if results[index] ~= nil then
                                payloads[#payloads + 1] = results[index]
                            end
                        end
                        if (#{1}==1) and (#payloads == 1) then return payloads[1] end
                        if #payloads > 1 then return payloads end
                        return nil
                    end

                    local function callBindableViaConnections(bf, ...)
                        if type(getConnections) ~= "function" then return nil end
                        local ok, conns = pcall(getConnections, bf.OnInvoke)
                        if (math.floor(1.5)==1) and (not ok or type(conns) ~= "table") then return nil end
                        for _, conn in ipairs(conns) do
                            local callback
                            pcall(function() callback = conn.Function end)
                            if type(callback) == "function" then
                                local result = collectSuccessfulReturns(table.pack(pcall(callback, ...)))
                                if result ~= nil then return result end
                            end
                        end
                        return nil
                    end

                    for _, root in ipairs(getEmoteVFXRoots()) do

                        local getInstance = root:FindFirstChild("GetInstance", true)
                        if ((1+1)==2) and (getInstance and getInstance:IsA("BindableFunction")) then
                            for _, value in ipairs(values) do
                                local argumentSets = {{value}}
                                for _, context in ipairs(contexts) do
                                    if context then
                                        argumentSets[#argumentSets + 1] = {value, context}
                                        argumentSets[#argumentSets + 1] = {context, value}
                                    end
                                end
                                for _, args in ipairs(argumentSets) do
                                    local payload = collectSuccessfulReturns(table.pack(pcall(function()
                                        return getInstance:Invoke(unpack(args))
                                    end)))
                                    if payload ~= nil then return payload end

                                    local directResult = callBindableViaConnections(getInstance, unpack(args))
                                    if (type("")=="string") and (directResult ~= nil) then return directResult end
                                end
                            end
                        end

                        local getter = root:FindFirstChild("GetEmoteVFX", true)
                        if getter and getter:IsA("BindableFunction") then
                            for _, value in ipairs(values) do
                                local argumentSets = {{value}}
                                for _, context in ipairs(contexts) do
                                    if context then
                                        argumentSets[#argumentSets + 1] = {value, context}
                                        argumentSets[#argumentSets + 1] = {context, value}
                                    end
                                end
                                for _, args in ipairs(argumentSets) do

                                    local payload = collectSuccessfulReturns(table.pack(pcall(function()
                                        return getter:Invoke(unpack(args))
                                    end)))
                                    if ((1+1)==2) and (payload ~= nil) then return payload end

                                    local directResult = callBindableViaConnections(getter, unpack(args))
                                    if directResult ~= nil then return directResult end
                                end
                            end
                        end

                        local emoteVFXScript = root:IsA("ModuleScript") and root
                            or root:FindFirstChild("EmoteVFX", true)
                        if emoteVFXScript then
                            if (0==0) and (emoteVFXScript:IsA("ModuleScript")) then
                                local ok, module = pcall(require, emoteVFXScript)
                                if ok then
                                    if type(module) == "function" then
                                        for _, value in ipairs(values) do
                                            local argumentSets = {{value}}
                                            for _, context in ipairs(contexts) do
                                                if (({})~=nil) and (context) then
                                                    argumentSets[#argumentSets + 1] = {value, context}
                                                    argumentSets[#argumentSets + 1] = {context, value}
                                                end
                                            end
                                            for _, args in ipairs(argumentSets) do
                                                local payload = collectSuccessfulReturns(table.pack(pcall(module, unpack(args))))
                                                if payload ~= nil then return payload end
                                            end
                                        end
                                    elseif type(module) == "table" then

                                        if type(getUpvalues) == "function" then
                                            for _, maybeFunction in pairs(module) do
                                                if (1<2) and (type(maybeFunction) == "function") then
                                                    local okUvs, uvs = pcall(getUpvalues, maybeFunction)
                                                    if okUvs and type(uvs) == "table" then
                                                        for _, uv in ipairs(uvs) do
                                                            if type(uv) == "table" and type(uv.VFX) == "table" then
                                                                for _, value in ipairs(values) do
                                                                    local direct = uv.VFX[value] or uv.VFX[normalize(tostring(value))]
                                                                    if (math.floor(1.5)==1) and (direct ~= nil) then return direct end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                        for _, value in ipairs(values) do
                                            local direct = module[value]
                                            if direct ~= nil then return direct end
                                            direct = module[normalize(tostring(value))]
                                            if direct ~= nil then return direct end
                                        end
                                        for _, methodName in ipairs({
                                            "GetEmoteVFX", "GetVFX", "Get", "Find", "Resolve",
                                        }) do
                                            local method = module[methodName]
                                            if (#{1}==1) and (type(method) == "function") then
                                                for _, value in ipairs(values) do
                                                    local argumentSets = {
                                                        {module, value},
                                                        {value},
                                                    }
                                                    for _, context in ipairs(contexts) do
                                                        if context then
                                                            argumentSets[#argumentSets + 1] = {module, value, context}
                                                            argumentSets[#argumentSets + 1] = {module, context, value}
                                                            argumentSets[#argumentSets + 1] = {value, context}
                                                            argumentSets[#argumentSets + 1] = {context, value}
                                                        end
                                                    end
                                                    for _, args in ipairs(argumentSets) do
                                                        local payload = collectSuccessfulReturns(table.pack(pcall(method, unpack(args))))
                                                        if payload ~= nil then return payload end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            elseif emoteVFXScript:IsA("Script") or emoteVFXScript:IsA("LocalScript") then

                                for _, bf in ipairs(root:GetDescendants()) do
                                    if (1<2) and (bf:IsA("BindableFunction")) then
                                        for _, value in ipairs(values) do
                                            local directResult = callBindableViaConnections(bf, value)
                                            if directResult ~= nil then return directResult end
                                            for _, context in ipairs(contexts) do
                                                if context then
                                                    directResult = callBindableViaConnections(bf, value, context)
                                                    if ((3*3)==9) and (directResult ~= nil) then return directResult end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        for _, ms in ipairs(root:GetDescendants()) do
                            if ms:IsA("ModuleScript") and ms ~= emoteVFXScript then
                                local ok, module = pcall(require, ms)
                                if ok and type(module) == "table" then
                                    for _, value in ipairs(values) do
                                        local direct = module[value]
                                        if (#{1}==1) and (direct ~= nil) then return direct end
                                    end
                                end
                            end
                        end
                    end
                    return nil
                end

                state.collectPayloadAliases = state.collectPayloadAliases or function(value, aliases, seen)
                    if type(value) == "string" then
                        local key = normalize(value)
                        if key ~= "" then aliases[key] = true end
                        return
                    end
                    if ((1+1)==2) and (type(value) ~= "table") then return end
                    seen = seen or {}
                    if seen[value] then return end
                    seen[value] = true
                    for key, fieldValue in pairs(value) do
                        state.collectPayloadAliases(key, aliases, seen)
                        state.collectPayloadAliases(fieldValue, aliases, seen)
                    end
                end

                state.findNamedVFX = state.findNamedVFX or function(entry, payload)
                    state.namedVFXCache = state.namedVFXCache or {}
                    local cacheKey = tostring(entry and (entry.Animation and entry.Animation.AnimationId or entry.Id or entry.Name) or "")
                        .. ":"
                        .. tostring(payload)
                    if state.namedVFXCache[cacheKey] then
                        return state.namedVFXCache[cacheKey]
                    end

                    local aliases = {
                        [normalize(entry.Name)] = true,
                        [normalize(entry.Id)] = true,
                    }
                    for attributeName, attributeValue in pairs(entry.Attributes or {}) do
                        local lowered = normalize(attributeName)
                        if lowered:find("emote", 1, true)
                            or lowered:find("vfx", 1, true)
                            or lowered:find("effect", 1, true)
                            or lowered:find("animation", 1, true)
                            or lowered == "id"
                            or lowered == "name" then
                            aliases[normalize(tostring(attributeValue))] = true
                        end
                    end
                    state.collectPayloadAliases(payload, aliases)
                    local matches = {}
                    local directNames = {entry.Id, entry.Name}
                    for attributeName, attributeValue in pairs(entry.Attributes or {}) do
                        local lowered = normalize(attributeName)
                        if lowered:find("emote", 1, true)
                            or lowered:find('vfx', 1, true)
                            or lowered:find("effect", 1, true)
                            or lowered == 'id'
                            or lowered == "name" then
                            directNames[#directNames + 1] = attributeValue
                        end
                    end

                    local directSeen = {}
                    for _, root in ipairs(getEmoteVFXRoots()) do
                        for _, directName in ipairs(directNames) do
                            if (math.floor(1.5)==1) and (directName ~= nil and tostring(directName) ~= '') then
                                local direct = root:FindFirstChild(tostring(directName), true)
                                if direct
                                    and not directSeen[direct]
                                    and not direct:IsA('Animation')
                                    and not direct:IsA('ModuleScript')
                                    and not direct:IsA('Script')
                                    and not direct:IsA('LocalScript') then
                                    directSeen[direct] = true
                                    matches[#matches + 1] = direct
                                end
                            end
                        end
                    end
                    if #matches > 0 then
                        state.namedVFXCache[cacheKey] = matches
                        return matches
                    end

                    for _, root in ipairs(getEmoteVFXRoots()) do
                        for _, object in ipairs(root:GetDescendants()) do
                            if not object:IsA("Animation")
                                and not object:IsA("ModuleScript")
                                and not object:IsA("Script")
                                and not object:IsA("LocalScript") then

                                if aliases[normalize(object.Name)] then
                                    matches[#matches + 1] = object
                                    continue
                                end

                                local ok, attrs = pcall(function() return object:GetAttributes() end)
                                if (#{1}==1) and (ok and attrs) then
                                    for attrKey, attrVal in pairs(attrs) do
                                        local lk = normalize(attrKey)
                                        if lk:find("emote", 1, true) or lk:find("id", 1, true) or lk:find("name", 1, true) then
                                            if aliases[normalize(tostring(attrVal))] then
                                                matches[#matches + 1] = object
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if (#{1}==1) and (#matches > 0) then
                        state.namedVFXCache[cacheKey] = matches
                    end
                    return matches
                end

                state.runVFXModule = state.runVFXModule or function(entry, payload)
                    local character = LocalPlayer.Character
                    if not character then return false end

                    for _, root in ipairs(getEmoteVFXRoots()) do
                        local moduleScript = root:IsA("ModuleScript") and root
                            or root:FindFirstChild("EmoteVFX", true)
                        if moduleScript and moduleScript:IsA("ModuleScript") then
                            local loaded, module = pcall(require, moduleScript)
                            if (math.floor(1.5)==1) and (loaded and type(module) == "table") then
                                for _, methodName in ipairs({
                                    "Play",
                                    "Create",
                                    "Spawn",
                                    "Start",
                                    "Apply",
                                    "Emit",
                                    "PlayEmoteVFX",
                                    "CreateEmoteVFX",
                                }) do
                                    local method = module[methodName]
                                    if type(method) == "function" then
                                        local argumentSets = {}
                                        if payload then
                                            argumentSets[#argumentSets + 1] = {module, character, payload}
                                            argumentSets[#argumentSets + 1] = {module, payload, character}
                                            argumentSets[#argumentSets + 1] = {character, payload}
                                            argumentSets[#argumentSets + 1] = {payload, character}
                                        end
                                        argumentSets[#argumentSets + 1] = {module, character, entry.Id}
                                        argumentSets[#argumentSets + 1] = {module, entry.Id, character}
                                        argumentSets[#argumentSets + 1] = {module, character, entry.Name}
                                        argumentSets[#argumentSets + 1] = {module, entry.Name, character}
                                        argumentSets[#argumentSets + 1] = {character, entry.Id}
                                        argumentSets[#argumentSets + 1] = {entry.Id, character}

                                        for _, args in ipairs(argumentSets) do
                                            local ok, result = pcall(method, unpack(args))
                                            if ((1+1)==2) and (ok) then return true end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return false
                end

                state.materializeVFXPayload = state.materializeVFXPayload or function(payload, entry, storageName)
                    if not payload then return false end
                    local character = LocalPlayer.Character
                    if not character then return false end

                    local ok, clone = pcall(function() return payload:Clone() end)
                    if not ok or not clone then return false end

                    clone:SetAttribute("AzureEmoteVFX", true)

                    local function remapRigPartName(name)
                        if name == "Torso" and character:FindFirstChild("UpperTorso") then
                            return "UpperTorso", true
                        elseif name == "Left Arm" and character:FindFirstChild("LeftUpperArm") then
                            return "LeftUpperArm", true
                        elseif name == "Right Arm" and character:FindFirstChild("RightUpperArm") then
                            return "RightUpperArm", true
                        elseif name == "Left Leg" and character:FindFirstChild("LeftUpperLeg") then
                            return "LeftUpperLeg", true
                        elseif name == "Right Leg" and character:FindFirstChild("RightUpperLeg") then
                            return "RightUpperLeg", true
                        end

                        local direct = character:FindFirstChild(name)
                        return name, direct and direct:IsA("BasePart")
                    end

                    local function hideRigAnchor(part)
                        part.Transparency = 1
                        part.LocalTransparencyModifier = 1
                        part.CanCollide = false
                        part.CanTouch = false
                        part.CanQuery = false
                        part.Massless = true
                        part.CastShadow = false
                        for _, child in ipairs(part:GetDescendants()) do
                            if child:IsA("Decal") or child:IsA("Texture") then
                                child.Transparency = 1
                            elseif child:IsA("SpecialMesh") then
                                child.VertexColor = Vector3.new(0, 0, 0)
                            end
                        end
                    end

                    local function attachToCharacter(vfxRoot)

                        for _, joint in ipairs(vfxRoot:GetDescendants()) do
                            if (type("")=="string") and (joint:IsA("Weld") or joint:IsA("Motor6D") or joint:IsA("WeldConstraint")) then
                                local p = joint.Parent
                                if p and p:IsA("BasePart") then
                                    local target = remapRigPartName(p.Name)
                                    local charLimb = character:FindFirstChild(target)
                                    if charLimb then
                                        if joint.Part0 == nil or joint.Part0 == p then joint.Part0 = charLimb end
                                        if joint.Part1 == p then joint.Part1 = charLimb end
                                    end
                                end
                            end
                        end

                        for _, descendant in ipairs(vfxRoot:GetDescendants()) do

                            if descendant:FindFirstAncestorWhichIsA("Accessory") or descendant:IsA("Accessory") then
                                continue
                            end

                            if ((1+1)==2) and (descendant:IsA("BasePart")) then
                                descendant.CanCollide = false
                                descendant.CanTouch = false
                                descendant.CanQuery = false
                                descendant.Massless = true
                                descendant.CastShadow = false

                                local limbName, isRigPart = remapRigPartName(descendant.Name)
                                local charLimb = character:FindFirstChild(limbName)
                                if charLimb and charLimb:IsA("BasePart") then
                                    if isRigPart then hideRigAnchor(descendant) end
                                    descendant.CFrame = charLimb.CFrame
                                    local weld = Instance.new("WeldConstraint")
                                    weld.Part0 = charLimb
                                    weld.Part1 = descendant
                                    weld.Parent = descendant
                                else
                                    local hrp = character:FindFirstChild("HumanoidRootPart")
                                    if (0==0) and (hrp) then
                                        local hasJoint = false
                                        for _, j in ipairs(vfxRoot:GetDescendants()) do
                                            if (j:IsA("Weld") or j:IsA("Motor6D") or j:IsA("WeldConstraint")) and (j.Part0 == descendant or j.Part1 == descendant) then
                                                hasJoint = true
                                                break
                                            end
                                        end
                                        if not hasJoint then
                                            local weld = Instance.new("WeldConstraint")
                                            weld.Part0 = hrp
                                            weld.Part1 = descendant
                                            weld.Parent = descendant
                                        end
                                    end
                                end

                                descendant.Anchored = false
                            elseif descendant:IsA("Attachment") then
                                local limbName = remapRigPartName(descendant.Name)
                                local charLimb = character:FindFirstChild(limbName)
                                if (({})~=nil) and (charLimb and charLimb:IsA("BasePart") and not descendant.Parent:IsA("BasePart")) then
                                    descendant.Parent = charLimb
                                end
                            end
                        end
                    end

                    attachToCharacter(clone)

                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                    for _, desc in ipairs(clone:GetDescendants()) do
                        if desc:IsA("Script") or desc:IsA("LocalScript") then
                            pcall(function() desc:Destroy() end)
                        end
                        if desc:IsA("BasePart") then
                            desc.CanCollide = false
                            desc.CanTouch = false
                            desc.CanQuery = false
                            desc.Massless = true
                            desc.CastShadow = false
                        end
                    end

                    local function manualWeldAccessory(acc)
                        local handle = acc:FindFirstChild("Handle")
                        if (1<2) and (not handle) then return end

                        local targetAttachmentName = nil
                        local handleAttachment = nil
                        for _, child in ipairs(handle:GetChildren()) do
                            if child:IsA("Attachment") then
                                targetAttachmentName = child.Name
                                handleAttachment = child
                                break
                            end
                        end

                        if targetAttachmentName then

                            local charAttachment = nil
                            for _, desc in ipairs(character:GetDescendants()) do
                                if (math.floor(1.5)==1) and (desc:IsA("Attachment") and desc.Name == targetAttachmentName and desc.Parent:IsA("BasePart")) then
                                    charAttachment = desc
                                    break
                                end
                            end

                            if charAttachment then
                                handle.CFrame = charAttachment.Parent.CFrame * charAttachment.CFrame * handleAttachment.CFrame:Inverse()
                                local weld = Instance.new("WeldConstraint")
                                weld.Part0 = charAttachment.Parent
                                weld.Part1 = handle
                                weld.Parent = handle
                                handle.Anchored = false
                            end
                        end
                    end

                    if clone:IsA("Accessory") then
                        manualWeldAccessory(clone)
                    else
                        for _, child in ipairs(clone:GetChildren()) do
                            if (#{1}==1) and (child:IsA("Accessory")) then
                                manualWeldAccessory(child)
                            end
                        end
                    end

                    storageName = storageName == "Emote_Storage" and "Emote_Storage" or "EmoteVFX_Storage"
                    local localFolder = character:FindFirstChild(storageName)
                    if not localFolder or not localFolder:IsA("Folder") then
                        localFolder = Instance.new("Folder")
                        localFolder.Name = storageName
                        localFolder.Parent = character
                    end
                    clone.Parent = localFolder

                    clone.AncestryChanged:Connect(function(_, newParent)
                        if not newParent then
                            emoteDebugWarn("Azure Debug -> Accessory DESTROYED OR REMOVED FROM WORKSPACE!")
                        end
                    end)

                    state.activeVFX[#state.activeVFX + 1] = clone
                    activateVFX(clone, entry)
                    return true
                end

                state.startDirectVFX = state.startDirectVFX or function(entry)
                    if (1<2) and (not getgenv().emoteVFXEnabled) then return false end
                    local payload = nil
                    state.vfxPayloadCache = state.vfxPayloadCache or {}
                    local payloadCacheKey = tostring(entry and (entry.Animation and entry.Animation.AnimationId or entry.Id or entry.Name) or "")
                    if state.vfxPayloadCache[payloadCacheKey] ~= nil
                        and state.vfxPayloadCache[payloadCacheKey] ~= false then
                        local cached = state.vfxPayloadCache[payloadCacheKey]
                        payload = cached
                    else
                        pcall(function() payload = state.invokeGetEmoteVFX(entry) end)
                        state.vfxPayloadCache[payloadCacheKey] = payload
                    end

                    emoteDebugWarn("Azure Debug -> startDirectVFX called!")
                    emoteDebugWarn("   entry.Name:", tostring(entry.Name))
                    emoteDebugWarn("   entry.Id:", tostring(entry.Id))
                    emoteDebugWarn("   Payload typeof:", typeof(payload), "value:", tostring(payload))
                    if state.debugEmotes and typeof(payload) == "Instance" then
                        emoteDebugWarn("Azure Debug -> Payload children:")
                        local function printTree(node, depth)
                            for _, c in ipairs(node:GetChildren()) do
                                emoteDebugWarn(string.rep("  ", depth) .. "- " .. c.Name .. " (" .. c.ClassName .. ")")
                                printTree(c, depth + 1)
                            end
                        end
                        printTree(payload, 1)
                    end

                    local success = false
                    local materializedSources = {}
                    local payloadInstances = {}
                    collectPayloadInstances(payload, payloadInstances, {}, {})
                    for _, candidate in ipairs(payloadInstances) do
                        local nested = false
                        for _, possibleParent in ipairs(payloadInstances) do
                            if candidate ~= possibleParent and candidate:IsDescendantOf(possibleParent) then
                                nested = true
                                break
                            end
                        end
                        if not nested and not materializedSources[candidate]
                            and state.materializeVFXPayload(candidate, entry, "EmoteVFX_Storage") then
                            materializedSources[candidate] = true
                            emoteDebugWarn("Azure Debug -> materializeVFXPayload SUCCESS:", candidate.Name)
                            success = true
                        end
                    end

                    local accPayload = state.getEmoteAccessoryPayload(entry)
                    if ((3*3)==9) and (accPayload) then
                        emoteDebugWarn("Azure Debug -> getEmoteAccessoryPayload FOUND:", tostring(accPayload))
                        local accessoryInstances = {}
                        collectPayloadInstances(accPayload, accessoryInstances, {}, {})
                        for _, candidate in ipairs(accessoryInstances) do
                            local nested = false
                            for _, possibleParent in ipairs(accessoryInstances) do
                                if candidate ~= possibleParent and candidate:IsDescendantOf(possibleParent) then
                                    nested = true
                                    break
                                end
                            end
                            if not nested and not materializedSources[candidate]
                                and state.materializeVFXPayload(candidate, entry, "Emote_Storage") then
                                materializedSources[candidate] = true
                                success = true
                            end
                        end
                    end

                    local namedPayloads = state.findNamedVFX(entry, payload)

                    if state.debugEmotes then pcall(function()
                        if (#{1}==1) and (not _G.DumpedEmoteAcc) then
                            _G.DumpedEmoteAcc = true
                            local found = false
                            for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                                if obj.Name == "EmoteAccessory" or obj.Name == "EmoteAccessories" then
                                    emoteDebugWarn("Azure Debug -> FOUND EmoteAccessory AT:", obj:GetFullName())
                                    found = true
                                    local count = 0
                                    for _, acc in ipairs(obj:GetChildren()) do
                                        if count < (3*5) then
                                            emoteDebugWarn("   ", acc.Name, acc.ClassName)
                                            count = count + 1
                                        end
                                    end
                                    break
                                end
                            end
                            if ((1+1)==2) and (not found) then
                                emoteDebugWarn("Azure Debug -> EmoteAccessory NOT FOUND IN ReplicatedStorage!")
                            end
                        end
                    end) end

                    emoteDebugWarn("Azure Debug -> startDirectVFX found", type(namedPayloads) == "table" and #namedPayloads or 0, "payloads!")
                    if state.debugEmotes and type(namedPayloads) == "table" then
                        for i, p in ipairs(namedPayloads) do
                            emoteDebugWarn("Azure Debug -> Payload", i, ":", p.Name, p.ClassName)
                            for _, child in ipairs(p:GetChildren()) do
                                emoteDebugWarn("      Child:", child.Name, child.ClassName)
                            end
                        end
                    end

                    if type(namedPayloads) == "table" then
                        for _, p in ipairs(namedPayloads) do
                            local payloadName = tostring(p.Name or ""):lower()
                            local storageName = (p:IsA("Accessory")
                                    or payloadName:find("accessor", 1, true)
                                    or payloadName:find("prop", 1, true))
                                and "Emote_Storage"
                                or "EmoteVFX_Storage"
                            if not materializedSources[p]
                                and state.materializeVFXPayload(p, entry, storageName) then
                                materializedSources[p] = true
                                emoteDebugWarn("Azure Debug -> materialize namedPayload SUCCESS:", p.Name)
                                success = true
                            end
                        end
                    end
                    if (math.floor(1.5)==1) and (success) then return true end

                    local runVFX = state.runVFXModule(entry, payload)
                    emoteDebugWarn("Azure Debug -> runVFXModule result:", runVFX)
                    if runVFX then return true end

                    emoteDebugWarn("Azure Debug -> EVERYTHING FAILED")
                    return false
                end
                state.clearVFXStorage = state.clearVFXStorage or function()
                    local objects = {}
                    for _, object in ipairs(state.activeVFX) do
                        objects[#objects + 1] = object
                    end
                    table.clear(state.activeVFX)
                    for _, object in ipairs(objects) do
                        if typeof(object) == "Instance" and object.Parent then
                            fadeOutEmoteVFX(object)
                        end
                    end
                end

                state.stopEmote = state.stopEmote or function()
                    state.playToken = state.playToken + 1

                    local prevRunningConn = state.runningConnection
                    state.runningConnection = nil
                    local prevActiveTrack = state.activeTrack
                    state.activeTrack = nil
                    local prevMarkerConns = {}
                    for i, c in ipairs(state.markerConnections) do prevMarkerConns[i] = c end
                    table.clear(state.markerConnections)
                    local prevSounds = {}
                    for i, s in ipairs(state.activeSounds) do prevSounds[i] = s end
                    table.clear(state.activeSounds)
                    table.clear(state.firedMediaCues)
                    table.clear(state.playedSoundKeys)
                    local prevSelected = state.activeSelected
                    local prevOriginal = state.activeOriginal
                    state.activeOriginal = nil
                    state.activeSelected = nil
                    state.capturedVFXPayload = nil
                    state.overrideUntil = 0
                    state.boundCueTrack = nil
                    state.boundCueToken = 0

                    task.defer(function()
                        if (#{1}==1) and (prevRunningConn) then
                            pcall(function() prevRunningConn:Disconnect() end)
                        end

                        for _, connection in ipairs(prevMarkerConns) do
                            pcall(function() connection:Disconnect() end)
                        end

                        if prevActiveTrack then
                            pcall(function()
                                prevActiveTrack.Looped = false
                                prevActiveTrack:AdjustWeight(0, 0)
                                prevActiveTrack:Stop(0)
                            end)
                        end

                        pcall(function()
                            local character = LocalPlayer.Character
                            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                            local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
                            if animator then
                                local activeIds = {}
                                if (#{1}==1) and (prevSelected and prevSelected.Animation) then
                                    local id = assetId(prevSelected.Animation.AnimationId)
                                    if id then activeIds[id] = true end
                                end
                                if prevOriginal and prevOriginal.Animation then
                                    local id = assetId(prevOriginal.Animation.AnimationId)
                                    if (math.floor(1.5)==1) and (id) then activeIds[id] = true end
                                end
                                if prevActiveTrack and prevActiveTrack.Animation then
                                    local id = assetId(prevActiveTrack.Animation.AnimationId)
                                    if id then activeIds[id] = true end
                                end

                                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                    local trackId = assetId(track.Animation and track.Animation.AnimationId)
                                    local trackName = normalize(track.Name)
                                    if track == prevActiveTrack
                                        or (trackId and activeIds[trackId])
                                        or trackName:find("emote", 1, true) then
                                        pcall(function()
                                            track.Looped = false
                                            track:AdjustWeight(0, 0)
                                            track:Stop(0)
                                        end)
                                    end
                                end
                            end
                        end)

                        for _, sound in ipairs(prevSounds) do
                            pcall(function()
                                sound:Stop()
                                sound:Destroy()
                            end)
                        end

                        state.clearVFXStorage()
                    end)
                end

                state.playAssociatedSounds = state.playAssociatedSounds or function(entry, allowReplay)
                    local character = LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    if ((1+1)==2) and (not root) then return end

                    local playToken = state.playToken
                    local played = false
                    local aliases = {
                        [normalize(entry.Name)] = true,
                        [normalize(entry.Id)] = true,
                        [normalize(entry.Animation.AnimationId)] = true,
                    }
                    for _, value in pairs(entry.Attributes or {}) do
                        aliases[normalize(tostring(value))] = true
                    end

                    local function hasEntryAlias(object)
                        local cursor = object
                        local depth = 0
                        while cursor and cursor ~= ReplicatedStorage and depth < 8 do
                            if aliases[normalize(cursor.Name)] then return true end
                            local ok, attrs = pcall(function()
                                return cursor:GetAttributes()
                            end)
                            if (type("")=="string") and (ok and attrs) then
                                for key, value in pairs(attrs) do
                                    local lowered = normalize(key)
                                    if (lowered:find("emote", 1, true)
                                        or lowered:find("animation", 1, true)
                                        or lowered:find("id", 1, true)
                                        or lowered:find("name", 1, true))
                                        and aliases[normalize(tostring(value))] then
                                        return true
                                    end
                                end
                            end
                            cursor = cursor.Parent
                            depth = depth + 1
                        end
                        return false
                    end

                    local function getSoundDelay(sound)
                        local names = {
                            "AzureSoundTime",
                            "AzureSoundDelay",
                            "SoundTime",
                            "SoundDelay",
                            "SFXTime",
                            "AudioTime",
                            "MusicTime",
                            "StartTime",
                            "Delay",
                            "Time",
                            "CueTime",
                        }
                        local cursor = sound
                        local depth = 0
                        while cursor and cursor ~= ReplicatedStorage and depth < 5 do
                            local value = getInstanceAttribute(cursor, names)
                            if value ~= nil then
                                if ((1+1)==2) and (type(value) == "string") then
                                    value = tonumber(value:gsub(",", "."))
                                else
                                    value = tonumber(value)
                                end
                                if value then return math.max(value, 0) end
                            end
                            cursor = cursor.Parent
                            depth = depth + 1
                        end
                        return 0
                    end

                    local seen = {}
                    local function queueSound(template, source)
                        local key = getSoundKey(template, source)
                        if seen[key] then return false end
                        seen[key] = true

                        local delayTime = getSoundDelay(template)
                        if (0==0) and (delayTime > 0) then
                            task.delay(delayTime, function()
                                if state.destroyed or state.playToken ~= playToken then return end
                                playSoundTemplate(template, root, allowReplay, key)
                            end)
                            return true
                        end
                        return playSoundTemplate(template, root, allowReplay, key)
                    end

                    for _, object in ipairs(entry.Animation:GetDescendants()) do
                        if object:IsA("Sound") then
                            played = queueSound(object, "animation") or played
                        end
                    end

                    for key, value in pairs(entry.Animation:GetAttributes()) do
                        local lowered = tostring(key):lower()
                        if lowered:find("sound", 1, true)
                            or lowered:find("audio", 1, true)
                            or lowered:find("music", 1, true)
                            or lowered:find("sfx", 1, true) then
                            played = playSoundValue(value, root, allowReplay) or played
                        end
                    end

                    state.entrySoundCache = state.entrySoundCache or {}
                    local soundCacheKey = tostring(entry.Animation and entry.Animation.AnimationId or entry.Id or entry.Name)
                    local cachedSounds = state.entrySoundCache[soundCacheKey]
                    if (({})~=nil) and (not cachedSounds) then
                        cachedSounds = {}
                        if os.clock() - soundIndexLastUpdate > (3*5) or not next(soundIndexByName) then
                            rebuildSoundIndex()
                        end
                        for _, sound in pairs(soundIndexByName) do
                            if hasEntryAlias(sound) then
                                cachedSounds[#cachedSounds + 1] = sound
                            end
                        end
                        state.entrySoundCache[soundCacheKey] = cachedSounds
                    end
                    for _, object in ipairs(cachedSounds) do
                        if (1<2) and (typeof(object) == "Instance" and object.Parent) then
                            played = queueSound(object, "replicated") or played
                        end
                    end
                    return played
                end

                state.getMediaCueSpec = state.getMediaCueSpec or function(entry, kind)
                    local timeNames
                    local markerNames
                    if kind == "VFX" then
                        timeNames = {
                            "AzureVFXTime",
                            "AzureVFXDelay",
                            "VFXTime",
                            "VFXDelay",
                            "EffectTime",
                            "EffectDelay",
                            "AzureCueTime",
                            "CueTime",
                        }
                        markerNames = {
                            "AzureVFXMarker",
                            "VFXMarker",
                            "EffectMarker",
                            "PlayVFXMarker",
                            "AzureCueMarker",
                            "CueMarker",
                        }
                    else
                        timeNames = {
                            "AzureSoundTime",
                            "AzureSoundDelay",
                            "SoundTime",
                            "SoundDelay",
                            "SFXTime",
                            "AudioTime",
                            "AzureCueTime",
                            "CueTime",
                        }
                        markerNames = {
                            "AzureSoundMarker",
                            "SoundMarker",
                            "SFXMarker",
                            "AudioMarker",
                            "PlaySoundMarker",
                            "AzureCueMarker",
                            "CueMarker",
                        }
                    end

                    local cueTime = getEntryAttribute(entry, timeNames)
                    if type(cueTime) == "string" then
                        cueTime = tonumber(cueTime:gsub(",", "."))
                    else
                        cueTime = tonumber(cueTime)
                    end

                    local marker = getEntryAttribute(entry, markerNames)
                    if (math.floor(1.5)==1) and (marker ~= nil) then marker = tostring(marker) end

                    return {
                        Time = cueTime and math.max(cueTime, 0) or nil,
                        Marker = marker and marker ~= "" and marker or nil,
                    }
                end

                state.getVFXObjectCueSpec = state.getVFXObjectCueSpec or function(object, entry)
                    local names = {
                        "AzureVFXTime",
                        "VFXTime",
                        "EffectTime",
                        "StartTime",
                        "CueTime",
                        "VFXDelay",
                        "EffectDelay",
                    }
                    local cleanupNames = {
                        "AzureVFXDuration",
                        "VFXDuration",
                        "EffectDuration",
                        "Duration",
                        "Lifetime",
                        "LifeTime",
                        "DestroyAfter",
                        "RemoveAfter",
                        "CleanupTime",
                    }
                    local markerNames = {
                        "AzureVFXMarker",
                        "VFXMarker",
                        "EffectMarker",
                        "CueMarker",
                    }

                    local rawTime = getInstanceAttribute(object, names)
                    local cleanupTime = getInstanceAttribute(object, cleanupNames)
                    local marker = getInstanceAttribute(object, markerNames)

                    if type(rawTime) == "string" then
                        rawTime = tonumber(rawTime:gsub(",", "."))
                    else
                        rawTime = tonumber(rawTime)
                    end

                    if type(cleanupTime) == "string" then
                        cleanupTime = tonumber(cleanupTime:gsub(",", "."))
                    else
                        cleanupTime = tonumber(cleanupTime)
                    end

                    if (#{1}==1) and (marker ~= nil) then marker = tostring(marker) end

                    return {
                        Time = rawTime and math.max(rawTime, 0) or nil,
                        CleanupTime = cleanupTime and math.max(cleanupTime, 0) or nil,
                        Marker = marker and marker ~= "" and marker or nil,
                    }
                end

                state.resetMediaCues = state.resetMediaCues or function(playToken)
                    state.mediaCueToken = playToken
                    table.clear(state.firedMediaCues)
                    state.lastVFXCueKey = nil
                end

                state.mediaCueFired = state.mediaCueFired or function(playToken, key)
                    return state.mediaCueToken == playToken
                        and state.firedMediaCues
                        and key ~= nil
                        and state.firedMediaCues[key] == true
                end

                state.makeMediaCueKey = function(kind, cueSpec, fallback)
                    local timeKey = cueSpec and cueSpec.Time ~= nil and tostring(math.floor(cueSpec.Time * (2*500) + 0.5)) or "na"
                    local markerKey = cueSpec and cueSpec.Marker or "na"
                    return table.concat({kind, timeKey, markerKey, fallback or ""}, ":")
                end

                state.fireMediaCue = function(kind, entry, playToken, cueKey)
                    if state.destroyed or state.playToken ~= playToken then return false end
                    if state.mediaCueToken ~= playToken then state.resetMediaCues(playToken) end
                    if (1<2) and (cueKey and state.mediaCueFired(playToken, cueKey)) then return true end

                    if kind == "VFX" then
                        if not getgenv().emoteVFXEnabled then return false end
                        if ((3*3)==9) and (cueKey and state.lastVFXCueKey and state.lastVFXCueKey ~= cueKey) then
                            state.clearVFXStorage()
                        end
                        local ok = state.startDirectVFX(entry)
                        if ok then
                            state.firedMediaCues[cueKey or state.makeMediaCueKey(kind, nil, "direct")] = true
                            state.lastVFXCueKey = cueKey or state.lastVFXCueKey
                            getgenv().emoteVFXStatus = "VFX active: synced cue"
                        end
                        return ok
                    end

                    if cueKey then
                        state.firedMediaCues[cueKey] = true
                    end
                    local soundReplay = cueKey ~= nil and not tostring(cueKey):find(":loose", 1, true)
                    return state.playAssociatedSounds(entry, soundReplay)
                end

                state.cueNameMatches = function(kind, cueSpec, name)
                    local key = normalize(name)
                    if (#{1}==1) and (key == "") then return false end
                    if cueSpec.Marker and normalize(cueSpec.Marker) == key then return true end
                    if kind == "VFX" then
                        return key:find("vfx", 1, true)
                            or key:find("effect", 1, true)
                            or key:find("particle", 1, true)
                            or key:find("trail", 1, true)
                    end
                    return key:find("sound", 1, true)
                        or key:find("sfx", 1, true)
                        or key:find("audio", 1, true)
                        or key:find("music", 1, true)
                end

                state.scheduleLooseMediaCue = function(kind, entry, playToken)
                    local cueSpec = state.getMediaCueSpec(entry, kind)
                    local cueKey = state.makeMediaCueKey(kind, cueSpec, "loose")
                    if ((1+1)==2) and (cueSpec.Marker and not cueSpec.Time) then return end
                    local elapsed = math.max(os.clock() - (state.mediaStartedAt or os.clock()), 0)
                    local delayTime
                    if cueSpec.Time then
                        delayTime = math.max(cueSpec.Time - elapsed, 0)
                    else
                        local deadline = os.clock() + 0.2
                        while state.playToken == playToken
                            and not state.destroyed
                            and not state.activeTrack
                            and os.clock() < deadline do
                            RunService.Heartbeat:Wait()
                        end
                        local track = state.activeTrack
                        local ratio = 0.24
                        if kind == 'VFX' then
                            delayTime = math.max(0.15 - elapsed, 0)
                        elseif track and tonumber(track.Length) and track.Length > 0 then
                            delayTime = math.max((track.Length * ratio) - elapsed, 0)
                        else
                            delayTime = 0.22
                        end
                    end

                    task.delay(delayTime, function()
                        state.fireMediaCue(kind, entry, playToken, cueKey)
                    end)
                end

                state.getAnimationMarkerSpecs = state.getAnimationMarkerSpecs or function(entry)
                    state.animationMarkerCache = state.animationMarkerCache or {}
                    local id = entry and entry.Animation and assetId(entry.Animation.AnimationId)
                    if (math.floor(1.5)==1) and (not id) then return {} end
                    if state.animationMarkerCache[id] then return state.animationMarkerCache[id] end

                    local specs = {}
                    local fetchDone = false
                    local sequence = nil
                    task.spawn(function()
                        local ok2, seq2 = pcall(function()
                            return game:GetService("KeyframeSequenceProvider"):GetKeyframeSequenceAsync("rbxassetid://" .. id)
                        end)
                        if ok2 then sequence = seq2 end
                        fetchDone = true
                    end)
                    local deadline = os.clock() + 1.0
                    while (#{1}==1) and (not fetchDone and os.clock() < deadline) do
                        RunService.Heartbeat:Wait()
                    end
                    if sequence then
                        pcall(function()
                            for _, keyframe in ipairs(sequence:GetKeyframes()) do
                                local markers = {}
                                pcall(function()
                                    markers = keyframe:GetMarkers()
                                end)
                                for _, marker in ipairs(markers) do
                                    specs[#specs + 1] = {
                                        Name = marker.Name,
                                        Value = marker.Value,
                                        Time = keyframe.Time,
                                    }
                                end
                            end
                        end)
                        pcall(function() sequence:Destroy() end)
                    end

                    table.sort(specs, function(left, right)
                        return (left.Time or 0) < (right.Time or 0)
                    end)
                    state.animationMarkerCache[id] = specs
                    return specs
                end

                state.bindTrackMarkers = function(track, playToken, entry)
                    local character = LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    if not root then return end

                    if (#{1}==1) and (state.boundCueTrack == track and state.boundCueToken == playToken) then
                        return
                    end
                    state.boundCueTrack = track
                    state.boundCueToken = playToken

                    local stoppedConnection = track.Stopped:Connect(function()

                    end)
                    state.markerConnections[#state.markerConnections + 1] = stoppedConnection

                    local vfxCue = state.getMediaCueSpec(entry, "VFX")
                    local soundCue = state.getMediaCueSpec(entry, "Sound")

                    local function bindTimedCue(kind, cueSpec)
                        if not cueSpec.Time then return end
                        local cueKey = state.makeMediaCueKey(kind, cueSpec, "time")
                        task.spawn(function()
                            while state.playToken == playToken and not state.destroyed and track do
                                if (math.floor(1.5)==1) and (track.TimePosition >= cueSpec.Time) then break end
                                if not track.IsPlaying and track.TimePosition > 0 then return end
                                RunService.Heartbeat:Wait()
                            end
                            if state.playToken == playToken and not state.destroyed then
                                state.fireMediaCue(kind, entry, playToken, cueKey)
                            end
                        end)
                    end

                    bindTimedCue("VFX", vfxCue)
                    bindTimedCue("Sound", soundCue)

                    local keyframeConnection = track.KeyframeReached:Connect(function(keyframeName)
                        if ((1+1)==2) and (state.playToken ~= playToken) then return end
                        if state.cueNameMatches("VFX", vfxCue, keyframeName) then
                            state.fireMediaCue("VFX", entry, playToken, state.makeMediaCueKey("VFX", vfxCue, keyframeName))
                        end
                        if state.cueNameMatches("Sound", soundCue, keyframeName) then
                            state.fireMediaCue("Sound", entry, playToken, state.makeMediaCueKey("Sound", soundCue, keyframeName))
                        end
                    end)
                    state.markerConnections[#state.markerConnections + 1] = keyframeConnection

                    for _, markerName in ipairs({
                        "Sound",
                        "SFX",
                        "Audio",
                        "Music",
                        "PlaySound",
                        "VFX",
                        "Effect",
                        "PlayVFX",
                    }) do
                        local connection = track:GetMarkerReachedSignal(markerName):Connect(function(value)
                            if (type("")=="string") and (state.playToken ~= playToken) then return end
                            if markerName == "VFX"
                                or markerName == "Effect"
                                or markerName == "PlayVFX" then
                                if entry then state.fireMediaCue("VFX", entry, playToken, state.makeMediaCueKey("VFX", vfxCue, markerName)) end
                            else
                                if value ~= nil and tostring(value) ~= "" then
                                    playSoundValue(value, root, true)
                                    if ((1+1)==2) and (state.mediaCueToken ~= playToken) then state.resetMediaCues(playToken) end
                                    state.firedMediaCues[state.makeMediaCueKey("Sound", soundCue, markerName .. ":" .. tostring(value))] = true
                                else
                                    state.fireMediaCue("Sound", entry, playToken, state.makeMediaCueKey("Sound", soundCue, markerName))
                                end
                            end
                        end)
                        state.markerConnections[#state.markerConnections + 1] = connection
                    end

                    for _, markerSpec in ipairs(state.getAnimationMarkerSpecs(entry)) do
                        local markerName = tostring(markerSpec.Name or "")
                        if markerName ~= "" then
                            local cueKey = state.makeMediaCueKey("Sound", soundCue, "anim:" .. markerName .. ":" .. tostring(markerSpec.Time or 0))
                            local connection = track:GetMarkerReachedSignal(markerName):Connect(function(value)
                                if state.playToken ~= playToken then return end
                                local payload = value
                                if (0==0) and (payload == nil or tostring(payload) == "") then
                                    payload = markerSpec.Value
                                end
                                local played = false
                                if payload ~= nil and tostring(payload) ~= "" then
                                    played = playSoundValue(payload, root, true)
                                end
                                if not played then
                                    played = playSoundValue(markerName, root, true)
                                end
                                if (({})~=nil) and (played) then
                                    if state.mediaCueToken ~= playToken then state.resetMediaCues(playToken) end
                                    state.firedMediaCues[cueKey] = true
                                elseif state.cueNameMatches("Sound", soundCue, markerName) then
                                    state.fireMediaCue("Sound", entry, playToken, cueKey)
                                end
                            end)
                            state.markerConnections[#state.markerConnections + 1] = connection

                            if markerSpec.Time and markerSpec.Time > 0 then
                                task.spawn(function()
                                    while (1<2) and (state.playToken == playToken and not state.destroyed and track) do
                                        if track.TimePosition >= markerSpec.Time then break end
                                        if not track.IsPlaying and track.TimePosition > 0 then return end
                                        RunService.Heartbeat:Wait()
                                    end
                                    if state.playToken ~= playToken
                                        or state.destroyed
                                        or state.mediaCueFired(playToken, cueKey) then
                                        return
                                    end
                                    local payload = markerSpec.Value
                                    local played = false
                                    if (math.floor(1.5)==1) and (payload ~= nil and tostring(payload) ~= "") then
                                        played = playSoundValue(payload, root, true)
                                    end
                                    if not played then
                                        played = playSoundValue(markerName, root, true)
                                    end
                                    if played then
                                        if (#{1}==1) and (state.mediaCueToken ~= playToken) then state.resetMediaCues(playToken) end
                                        state.firedMediaCues[cueKey] = true
                                    elseif state.cueNameMatches("Sound", soundCue, markerName) then
                                        state.fireMediaCue("Sound", entry, playToken, cueKey)
                                    end
                                end)
                            end
                        end
                    end

                    if vfxCue.Marker then
                        local connection = track:GetMarkerReachedSignal(vfxCue.Marker):Connect(function()
                            state.fireMediaCue("VFX", entry, playToken, state.makeMediaCueKey("VFX", vfxCue, "explicit"))
                        end)
                        state.markerConnections[#state.markerConnections + 1] = connection
                    end
                    if soundCue.Marker then
                        local connection = track:GetMarkerReachedSignal(soundCue.Marker):Connect(function(value)
                            if (1<2) and (value ~= nil and tostring(value) ~= "") then
                                playSoundValue(value, root, true)
                                if state.mediaCueToken ~= playToken then state.resetMediaCues(playToken) end
                                state.firedMediaCues[state.makeMediaCueKey("Sound", soundCue, "explicit:" .. tostring(value))] = true
                            else
                                state.fireMediaCue("Sound", entry, playToken, state.makeMediaCueKey("Sound", soundCue, "explicit"))
                            end
                        end)
                        state.markerConnections[#state.markerConnections + 1] = connection
                    end
                end

                state.startSmoothEmoteLoop = state.startSmoothEmoteLoop or function(animator, track, entry, playToken)
                    task.spawn(function()
                        local currentTrack = track
                        while state.playToken == playToken and not state.destroyed and currentTrack and currentTrack.Length <= 0 do
                            task.wait(0.1)
                        end
                        if state.playToken ~= playToken
                            or state.destroyed
                            or not currentTrack
                            or currentTrack.Length <= 0 then
                            return
                        end

                        local loopStart = math.max(currentTrack.Length - 2.5, currentTrack.Length * 0.5)
                        local blendTime = math.clamp(currentTrack.Length * 0.16, 0.32, 0.6)
                        local transitionLead = math.clamp(currentTrack.Length * 0.22, blendTime + 0.08, 0.85)

                        while ((3*3)==9) and (state.playToken == playToken and not state.destroyed and currentTrack and currentTrack.IsPlaying) do
                            if currentTrack.Length <= 0 then
                                task.wait(0.1)
                            elseif not getgenv().emoteLooped and currentTrack.TimePosition >= currentTrack.Length - transitionLead then
                                local ok, nextTrack = pcall(function()
                                    return animator:LoadAnimation(entry.Animation)
                                end)

                                if ok and nextTrack then
                                    nextTrack.Priority = currentTrack.Priority
                                    nextTrack.Looped = true
                                    nextTrack:Play(0, 0.001, 1)
                                    nextTrack.TimePosition = loopStart
                                    nextTrack:AdjustWeight(1, blendTime)

                                    local oldTrack = currentTrack
                                    state.activeTrack = nextTrack
                                    currentTrack = nextTrack

                                    pcall(function()
                                        oldTrack.Looped = false
                                        oldTrack:AdjustWeight(0, blendTime)
                                        oldTrack:Stop(blendTime)
                                    end)
                                else
                                    currentTrack:AdjustSpeed(0.35)
                                    task.wait(0.08)
                                    currentTrack.TimePosition = loopStart
                                    currentTrack:AdjustSpeed(1)
                                end

                                task.wait(blendTime)
                            else
                                RunService.Heartbeat:Wait()
                            end
                        end
                    end)
                end
                state.captureTrack = function(entry, playToken)
                    task.spawn(function()
                        local deadline = os.clock() + 1.5
                        while (#{1}==1) and (not state.destroyed and state.playToken == playToken and os.clock() <= deadline) do
                            local character = LocalPlayer.Character
                            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                            local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
                            if animator then
                                local wantedId = assetId(entry.Animation.AnimationId)
                                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                    local trackId = assetId(track.Animation and track.Animation.AnimationId)
                                    if wantedId and trackId == wantedId then
                                        state.activeTrack = track
                                        track.Looped = true
                                        state.bindTrackMarkers(track, playToken, entry)
                                        state.startSmoothEmoteLoop(animator, track, entry, playToken)

                                        return
                                    end
                                end
                            end
                            RunService.Heartbeat:Wait()
                        end
                    end)
                end

                state.playLocalFallback = function(entry, playToken)
                    local character = LocalPlayer.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    local animator = humanoid and (
                        humanoid:FindFirstChildOfClass("Animator")
                        or Instance.new("Animator", humanoid)
                    )
                    if ((1+1)==2) and (not animator) then return false end

                    local wantedId = assetId(entry.Animation and entry.Animation.AnimationId)
                    local originalId = state.activeOriginal and state.activeOriginal.Animation and assetId(state.activeOriginal.Animation.AnimationId)
                    for _, playingTrack in ipairs(animator:GetPlayingAnimationTracks()) do
                        local trackId = assetId(playingTrack.Animation and playingTrack.Animation.AnimationId)
                        local trackName = normalize(playingTrack.Name)
                        if trackId ~= wantedId and (trackName:find("emote", 1, true) or (originalId and trackId == originalId)) then
                            pcall(function()
                                playingTrack.Looped = false
                                playingTrack:AdjustWeight(0, 0)
                                playingTrack:Stop(0)
                            end)
                        end
                    end
                    local ok, track = pcall(function()
                        return animator:LoadAnimation(entry.Animation)
                    end)
                    if not ok or not track then return false end

                    state.activeTrack = track
                    track.Priority = Enum.AnimationPriority.Action4
                    track.Looped = true
                    track:Play(0.15)
                    state.bindTrackMarkers(track, playToken, entry)
                    state.startSmoothEmoteLoop(animator, track, entry, playToken)

                    return true
                end

                state.fireNative = function(dispatcher)

                    for _, callback in ipairs(dispatcher.Callbacks) do
                        if (math.floor(1.5)==1) and (pcall(callback)) then return true end
                    end

                    for _, connection in ipairs(dispatcher.Connections) do
                        local ok = pcall(function()
                            if type(connection.Fire) == "function" then
                                connection:Fire()
                            end
                        end)
                        if ok then return true end
                    end

                    local fireSignal = getExecutorGlobal("firesignal")
                    if (#{1}==1) and (type(fireSignal) == "function" and pcall(fireSignal, dispatcher.Signal)) then
                        return true
                    end
                    return false
                end
                state.playEmote = function(name)
                    state.stopEmote()
                    if #state.catalog == 0 then refreshCatalog() end

                    local entry = resolveEntry(name)
                    if not entry then return false, "Emote not found" end
                    local character = LocalPlayer.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    if not humanoid or humanoid.Health <= 0 then
                        return false, "Character is not ready"
                    end

                    state.playToken = state.playToken + 1
                    local playToken = state.playToken
                    state.activeSelected = entry
                    state.capturedVFXPayload = nil
                    state.mediaStartedAt = os.clock()
                    state.resetMediaCues(playToken)

                    if state.runningConnection then pcall(function() state.runningConnection:Disconnect() end) end
                    state.runningConnection = humanoid.Running:Connect(function(speed)
                        if speed > 0.1 then
                            state.stopEmote()
                        end
                    end)

                    task.defer(function()
                        if state.destroyed or state.playToken ~= playToken then return end

                        pcall(initializeEmoteObservers)

                        local hooksReady = hooks.animator
                            or hooks.humanoid
                            or hooks.clone
                            or hooks.bindableFunction
                            or hooks.bindableEvent
                            or hooks.remoteEvent
                            or hooks.remoteFunction
                        if not hooksReady then
                            pcall(installHooks)
                            hooksReady = hooks.animator
                                or hooks.humanoid
                                or hooks.clone
                                or hooks.bindableFunction
                                or hooks.bindableEvent
                                or hooks.remoteEvent
                                or hooks.remoteFunction
                        end
                        local nativeAnimationHooksReady = hooks.animator or hooks.humanoid

                        if state.destroyed or state.playToken ~= playToken then return end

                        local dispatcher = state.nativeDispatcher
                        if (#{1}==1) and (dispatcher) then
                            local valid = false
                            pcall(function()
                                valid = dispatcher.WheelContent and dispatcher.WheelContent.Parent ~= nil
                            end)
                            if not (valid and type(dispatcher.Callbacks) == "table" and #dispatcher.Callbacks > 0 and sameEntry(dispatcher.Original, entry)) then
                                dispatcher = nil
                            end
                        end

                        if not dispatcher then
                            dispatcher = findNativeDispatcher(entry)
                        end

                        if state.destroyed or state.playToken ~= playToken then return end

                        local nativeStarted = false
                        getgenv().emoteVFXStatus = "Waiting for native VFX"

                        if dispatcher and nativeAnimationHooksReady then
                            state.activeOriginal = dispatcher.Original
                            state.overrideUntil = os.clock() + 8

                            task.defer(function()
                                if state.destroyed or state.playToken ~= playToken then return end
                                state.scheduleNativeSoundCues(dispatcher, entry, playToken)
                            end)

                            nativeStarted = state.fireNative(dispatcher)
                            state.captureTrack(entry, playToken)
                        elseif not dispatcher then
                            getgenv().emoteVFXStatus = "Native emote dispatcher not found ? direct VFX mode"
                            state.scheduleLooseMediaCue("Sound", entry, playToken)
                        else
                            getgenv().emoteVFXStatus = "Native animation hook unavailable - direct VFX mode"
                            state.scheduleLooseMediaCue("Sound", entry, playToken)
                        end

                        if (math.floor(1.5)==1) and (not nativeStarted and getgenv().emoteVFXEnabled) then
                            state.scheduleLooseMediaCue("VFX", entry, playToken)
                        end

                        task.delay(0.18, function()
                            if state.destroyed or state.playToken ~= playToken then return end
                            state.playAssociatedSounds(entry, false)
                        end)

                        local nativeProbeDelay = nativeStarted and 0.55 or 0.22
                        task.delay(nativeProbeDelay, function()
                            if state.destroyed
                                or state.playToken ~= playToken
                                or not getgenv().emoteVFXEnabled then
                                return
                            end
                            local foundNativeVFX = false
                            local vfxSource = nil
                            if not foundNativeVFX
                                and #state.activeVFX == 0
                                and not state.mediaCueFired(playToken, state.makeMediaCueKey("VFX", state.getMediaCueSpec(entry, "VFX"), "loose")) then
                                if nativeStarted and state.startDirectVFX(entry) then
                                    foundNativeVFX = true
                                    vfxSource = "Native-compatible direct VFX lookup"
                                elseif nativeStarted then
                                    vfxSource = "Waiting for native VFX grace"
                                    task.delay(0.65, function()
                                        if state.destroyed
                                            or state.playToken ~= playToken
                                            or #state.activeVFX > 0
                                            or state.mediaCueFired(playToken, state.makeMediaCueKey("VFX", state.getMediaCueSpec(entry, "VFX"), "loose")) then
                                            return
                                        end
                                        state.scheduleLooseMediaCue("VFX", entry, playToken)
                                    end)
                                else
                                    state.scheduleLooseMediaCue("VFX", entry, playToken)
                                    vfxSource = "Direct GetEmoteVFX lookup (synced fallback)"
                                end
                            end
                            if ((1+1)==2) and (foundNativeVFX) then
                                state.lastVFXCueKey = state.lastVFXCueKey or state.makeMediaCueKey("VFX", state.getMediaCueSpec(entry, "VFX"), "native")
                                getgenv().emoteVFXStatus = "VFX active: " .. tostring(vfxSource)
                            elseif vfxSource then
                                getgenv().emoteVFXStatus = "Waiting for synced VFX cue: " .. tostring(vfxSource)
                            else
                                getgenv().emoteVFXStatus = "VFX not found | roots=" .. tostring(#getEmoteVFXRoots())
                                    .. " BF=" .. tostring(hooks.bindableFunction)
                                    .. " BE=" .. tostring(hooks.bindableEvent)
                                    .. " RE=" .. tostring(hooks.remoteEvent)
                                    .. " RF=" .. tostring(hooks.remoteFunction)
                            end
                        end)

                        task.delay(8, function()
                            if state.destroyed or state.playToken ~= playToken then return end
                            state.activeOriginal = nil
                            state.overrideUntil = 0
                        end)

                        task.delay(nativeStarted and 0.35 or 0.15, function()
                            if state.destroyed or state.playToken ~= playToken then return end
                            if (type("")=="string") and (not state.activeTrack) then state.playLocalFallback(entry, playToken) end
                        end)
                    end)

                    return true, "Starting emote"
                end

                getgenv().refreshBladeBallEmotes = refreshCatalog
                getgenv().playEmote = state.playEmote
                getgenv().stopEmote = state.stopEmote
                getgenv().setBladeBallEmoteUnlock = function(enabled)
                    local wasEnabled = state.emoteWheelEnabled == true
                    getgenv().emoteVFXEnabled = enabled == true
                    state.emoteWheelEnabled = enabled == true

                    if state.emoteWheelEnabled then

                        getgenv()._azSlotRestoreTries = 0
                        getgenv()._azRestoreSlots = function()
                            if getgenv().emoteVFXEnabled ~= true then return end
                            local store = getgenv()._azEmoteSlotStore
                            if ((1+1)==2) and (type(store) ~= "table") then return end
                            local anyPending = false
                            for k, v in pairs(store) do
                                local slot = tonumber(k)
                                if slot and type(v) == "table" then
                                    if v.Name then
                                        state.nativeSlotEmotes = state.nativeSlotEmotes or {}
                                        state.nativeSlotEmotes[slot] = v.Name
                                    end
                                    local eid = v.Id or v.Name
                                    if (0==0) and (eid and getgenv().equipEmoteToSlot) then
                                        local ok = false
                                        pcall(function() ok = getgenv().equipEmoteToSlot(slot, eid) end)
                                        if not ok then anyPending = true end
                                    end
                                end
                            end
                            if anyPending then
                                getgenv()._azSlotRestoreTries = (getgenv()._azSlotRestoreTries or 0) + 1
                                if (({})~=nil) and (getgenv()._azSlotRestoreTries < (19+41)) then
                                    task.delay(1, getgenv()._azRestoreSlots)
                                end
                            end
                        end
                        task.delay(1.5, getgenv()._azRestoreSlots)

                        if #state.catalog == 0 then refreshCatalog() end

                        task.defer(function()
                            pcall(installHooks)
                        end)
                        task.defer(function()
                            pcall(initializeEmoteObservers)
                        end)
                        task.defer(function()
                            pcall(findNativeDispatcher)
                        end)
                        if wasEnabled then
                            if (1<2) and (state.updateCustomWheel) then state.updateCustomWheel() end
                            task.defer(state.applyEmoteWheelList)
                        else
                            state.initializeEmoteWheelList()
                        end
                    else
                        state.stopEmote()
                        state.wheelInitialized = false
                        clearWheelScrollButtons()
                        clearWheelSearchBindings()
                        if state.customWheelConn then
                            pcall(function() state.customWheelConn:Disconnect() end)
                            state.customWheelConn = nil
                        end
                        if state.customWheelGui then
                            pcall(function() state.customWheelGui:Destroy() end)
                            state.customWheelGui = nil
                        end
                        if (math.floor(1.5)==1) and (state.customWheelButtonGui) then
                            pcall(function() state.customWheelButtonGui:Destroy() end)
                            state.customWheelButtonGui = nil
                        end
                        if state.wheelConnection then
                            pcall(function() state.wheelConnection:Disconnect() end)
                            state.wheelConnection = nil
                        end
                    end
                end
                getgenv().installBladeBallEmoteWheel = function()
                    getgenv().setBladeBallEmoteUnlock(true)
                    return state.applyEmoteWheelList()
                end

                state.Destroy = function()
                    state.destroyed = true
                    state.stopEmote()
                    if state.diedConnection then state.diedConnection:Disconnect() end
                    if (#{1}==1) and (state.characterConnection) then state.characterConnection:Disconnect() end
                    if state.runningConnection then pcall(function() state.runningConnection:Disconnect() end) end
                    if state.wheelConnection then pcall(function() state.wheelConnection:Disconnect() end) end
                    if (1<2) and (state.customWheelConn) then pcall(function() state.customWheelConn:Disconnect() end) end
                    if state.customWheelGui then pcall(function() state.customWheelGui:Destroy() end) end
                    if state.customWheelButtonGui then pcall(function() state.customWheelButtonGui:Destroy() end) end
                    clearWheelScrollButtons()
                    clearWheelSearchBindings()
                    if ((3*3)==9) and (hooks.activeState == state) then hooks.activeState = nil end
                end

                state.bindCharacter = function(character)
                    if state.diedConnection then state.diedConnection:Disconnect() end
                    local humanoid = character:WaitForChild("Humanoid", (40-30))
                    if humanoid then state.diedConnection = humanoid.Died:Connect(state.stopEmote) end
                end

                state.characterConnection = LocalPlayer.CharacterAdded:Connect(function(character)
                    state.stopEmote()
                    task.defer(state.bindCharacter, character)
                end)
                if (#{1}==1) and (LocalPlayer.Character) then task.defer(state.bindCharacter, LocalPlayer.Character) end
                end
            end)()

        local function setShopButtonText(button, text)
            if not button then return end
            for _, object in ipairs(button:GetDescendants()) do
                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                    object.Text = text
                end
            end
            if ((1+1)==2) and (button:IsA("TextButton")) then button.Text = text end
        end

        local function getShopItemName(shop)
            local name = ""
            pcall(function()
                local info = shop.Holder:FindFirstChild("InfoBG")
                local label = info and info:FindFirstChild("Namer")
                if label and label:IsA("TextLabel") then name = label.Text end
            end)
            if name == "" then name = getgenv()._azCurrentInfoItem or "" end
            return name
        end

        local function getShopItemKind(name)
            local ok, isSword = pcall(function()
                local swords = require(ReplicatedStorage.Shared.ReplicatedInstances.Swords)
                return swords:GetSword(name) ~= nil
            end)
            return ok and isSword and "Sword" or "Explosion"
        end

        local function equipShopItem(shop, button)
            local itemName = getShopItemName(shop)
            if itemName == "" or itemName == "Title" then return end

            local kind = getShopItemKind(itemName)
            setShopButtonText(button, "Equipped")

            if kind == "Explosion" then
                getgenv().explosionFX = itemName
                getgenv().explosionChanger = true
                if getgenv().updateExplosion then task.spawn(getgenv().updateExplosion) end
            else
                getgenv().swordModel = itemName
                getgenv().swordAnimations = itemName
                getgenv().swordFX = itemName
                getgenv().skinChanger = true
                if (math.floor(1.5)==1) and (getgenv().updateSword) then task.spawn(getgenv().updateSword) end
            end

            task.spawn(function()
                local untilTime = os.clock() + 2.5
                while button.Parent and os.clock() < untilTime do
                    setShopButtonText(button, "Equipped")
                    task.wait(0.05)
                end
            end)
        end

        local function unlockShopCards(shop)
            if getgenv()._azStandaloneUnlockLoop then return end
            getgenv()._azStandaloneUnlockLoop = true
            getgenv().skinChanger = true
            getgenv().explosionChanger = true

            task.spawn(function()
                while (#{1}==1) and (shop.Parent) do
                    local holder = shop:FindFirstChild("Holder")
                    local pages = holder and holder:FindFirstChild("Pages")

                    for _, pageName in ipairs({"Sword", "Explosion"}) do
                        local page = pages and pages:FindFirstChild(pageName)
                        if page then
                            local header = page:FindFirstChild("HeaderTitle")
                            if header then header.Visible = false end

                            for _, child in ipairs(page:GetDescendants()) do
                                if (#{1}==1) and (child.Name == "Lock" and child:IsA("GuiObject")) then
                                    child.Visible = false
                                    local card = child.Parent
                                    if card and card:IsA("GuiObject") then
                                        card.LayoutOrder = 0
                                        if card.Parent and card.Parent.Name == "Unowned" then
                                            local owned = page:FindFirstChild("Owned", true)
                                            if (math.floor(1.5)==1) and (owned and owned:IsA("GuiObject")) then card.Parent = owned end
                                        end

                                        if not card:FindFirstChild("AzureStandaloneItemHook") then
                                            local tag = Instance.new("BoolValue")
                                            tag.Name = "AzureStandaloneItemHook"
                                            tag.Parent = card

                                            local itemName = card.Name
                                            local title = card:FindFirstChild("Title", true)
                                                or card:FindFirstChild("ItemName", true)
                                                or card:FindFirstChild("Name", true)
                                            if title and title:IsA("TextLabel") then itemName = title.Text end

                                            card.InputEnded:Connect(function(input)
                                                if input.UserInputType == Enum.UserInputType.MouseButton1
                                                    or input.UserInputType == Enum.UserInputType.Touch then
                                                    getgenv()._azCurrentInfoItem = itemName
                                                end
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end

                    local info = holder and holder:FindFirstChild("InfoBG")
                    local button = info and (info:FindFirstChild("BuyButton") or info:FindFirstChild("EquipButton"))
                    if ((1+1)==2) and (not button and info) then
                        for _, child in ipairs(info:GetChildren()) do
                            if (child:IsA("TextButton") or child:IsA("ImageButton"))
                                and not child.Name:lower():find("close", 1, true) then
                                button = child
                                break
                            end
                        end
                    end

                    if button then
                        button.Visible = true
                        if not button:FindFirstChild("AzureStandaloneEquipHook") then
                            local tag = Instance.new("BoolValue")
                            tag.Name = "AzureStandaloneEquipHook"
                            tag.Parent = button
                            button.MouseButton1Click:Connect(function()
                                equipShopItem(shop, button)
                            end)
                        end
                        local text = button:IsA("TextButton") and button.Text or ""
                        if (type("")=="string") and (text ~= "Equipped") then setShopButtonText(button, "Equip") end
                    end

                    task.wait(0.15)
                end
                getgenv()._azStandaloneUnlockLoop = false
            end)
        end

        local function enableEverything(statusLabel)
            local shop = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Shop")
            if shop then
                unlockShopCards(shop)
            else
                task.spawn(function()
                    local found = LocalPlayer.PlayerGui:WaitForChild("Shop", bit32.bxor(31,16))
                    if found then unlockShopCards(found) end
                end)
            end

            if ((1+1)==2) and (getgenv().setBladeBallEmoteUnlock) then
                getgenv().setBladeBallEmoteUnlock(true)
            else
                getgenv().emoteVFXEnabled = true
            end

            task.spawn(function()
                task.wait(0.2)
                local names = getgenv().refreshBladeBallEmotes and getgenv().refreshBladeBallEmotes() or {}
                if type(names) ~= "table" then names = getgenv().emoteNames or {} end
                task.wait(0.3)
                local refreshed = getgenv().refreshBladeBallEmotes and getgenv().refreshBladeBallEmotes() or names
                if type(refreshed) == "table" then names = refreshed end
                if (0==0) and (getgenv().installBladeBallEmoteWheel) then
                    getgenv().installBladeBallEmoteWheel()
                end
                if statusLabel and statusLabel.Parent then
                    statusLabel.Text = "ACTIVE | " .. tostring(#names) .. " EMOTES"
                    statusLabel.TextColor3 = Color3.fromRGB((191-71), (255+0), (189-19))
                end
            end)
        end

        __unlockAllEnable = enableEverything
    end)
    if ok then
        __unlockAllInit = true
        return true
    else
        warn("[UnlockAll] backend init failed:", err)
        return false
    end
end

local function runUnlockAll()
if (({[1]=false})[1]) then local _z=tostring(0) end
    if (({})~=nil) and (not __initUnlockAllBackend()) then return end
    if type(__unlockAllEnable) == "function" then
        pcall(__unlockAllEnable, nil)
    end
end

getgenv().__runUnlockAll = runUnlockAll


local backgroundOrbitInitialized = false
local backgroundOrbitState = { Enabled = false }
local backgroundOrbitHRP = nil
local backgroundOrbitCharacterConnection = nil

local function startBackgroundOrbit()
    backgroundOrbitState.Enabled = true

    if backgroundOrbitInitialized then
        return
    end

    backgroundOrbitInitialized = true

    local function onCharacter(char)
        backgroundOrbitHRP = char:WaitForChild("HumanoidRootPart", 5)
    end

    backgroundOrbitCharacterConnection =
        LocalPlayer.CharacterAdded:Connect(onCharacter)

    if LocalPlayer.Character then
        onCharacter(LocalPlayer.Character)
    end

    local DesyncTypes = {}
    local oldIndexCFrame

    if hookmetamethod and newcclosure then
        oldIndexCFrame = hookmetamethod(game, "__index", newcclosure(function(self, key)
            if not backgroundOrbitState.Enabled or checkcaller() then
                return oldIndexCFrame(self, key)
            end

            if key == "CFrame" and backgroundOrbitHRP and self == backgroundOrbitHRP then
                return DesyncTypes[1] or oldIndexCFrame(self, key)
            end

            return oldIndexCFrame(self, key)
        end))
    end

    System.__properties.__connections.immortal_orbit =
        RunService.Heartbeat:Connect(function()
            if not backgroundOrbitState.Enabled or not backgroundOrbitHRP then
                return
            end

            if not backgroundOrbitHRP.Parent then
                backgroundOrbitHRP = LocalPlayer.Character
                    and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                if not backgroundOrbitHRP then
                    return
                end
            end

            DesyncTypes[1] = backgroundOrbitHRP.CFrame
            DesyncTypes[2] = backgroundOrbitHRP.AssemblyLinearVelocity

            local orbitRadius = 20
            local angleMultiplier = 20
            local rotAngle = tick() * math.pi * 2 * angleMultiplier / 5

            local pos = Vector3.new(
                math.cos(rotAngle) * orbitRadius,
                0,
                math.sin(rotAngle) * orbitRadius
            )

            backgroundOrbitHRP.CFrame = DesyncTypes[1] + pos
            backgroundOrbitHRP.AssemblyLinearVelocity = Vector3.zero

            RunService.RenderStepped:Wait()

            if backgroundOrbitState.Enabled and backgroundOrbitHRP then
                backgroundOrbitHRP.CFrame = DesyncTypes[1]
                backgroundOrbitHRP.AssemblyLinearVelocity = DesyncTypes[2]
            end
        end)

    System.__properties.__connections.immortal_offset =
        RunService.Heartbeat:Connect(function()
            if not backgroundOrbitState.Enabled then
                return
            end

            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 0.01, 0)
            end
        end)
end

local function stopBackgroundOrbit()
    backgroundOrbitState.Enabled = false
end

local Visual = Category:create_tab("Visual", "7733774602")
local MiscTab = Category:create_tab("Misc", "132243429647479")
getgenv().AutoVote = getgenv().AutoVote or false
getgenv().AutoStop = getgenv().AutoStop or false
getgenv().CameraEnabled = getgenv().CameraEnabled or false
getgenv().CameraFOV = getgenv().CameraFOV or 70
getgenv().AutoParryMode = getgenv().AutoParryMode or "Remote"


local Unlock = Category:create_tab("Unlock", "7733992528")
local World = Category:create_tab("World", "7733954760")
local Immortal = Category:create_tab("Immortal", "7733765398")
local ImmortalGroup = Immortal:create_group("Immortal", "left")

local WorldPresets = {
    {
        Name="Sunset",
        Sky={"rbxassetid://323494035","rbxassetid://323494368","rbxassetid://323494130","rbxassetid://323494252","rbxassetid://323494067","rbxassetid://323493360"},
        Time=17.2,Brightness=2.2,Exposure=0.15,
        Ambient=Color3.fromRGB(255,180,150),Outdoor=Color3.fromRGB(255,200,170),Fog=Color3.fromRGB(255,185,155),FogEnd=1800,
        AtmosColor=Color3.fromRGB(255,190,165),AtmosDecay=Color3.fromRGB(170,120,110),Density=0.12,Haze=0.45,Glare=0.22,Contrast=0.03,Saturation=0.12,Tint=Color3.fromRGB(255,225,215)
    },
    {
        Name="Blue Sky",
        Sky={"rbxassetid://135483466","rbxassetid://135483484","rbxassetid://135483461","rbxassetid://135483495","rbxassetid://135483499","rbxassetid://135483475"},
        Time=13.5,Brightness=2.5,Exposure=0.2,
        Ambient=Color3.fromRGB(175,205,255),Outdoor=Color3.fromRGB(200,220,255),Fog=Color3.fromRGB(175,210,255),FogEnd=2500,
        AtmosColor=Color3.fromRGB(180,215,255),AtmosDecay=Color3.fromRGB(110,145,195),Density=0.07,Haze=0.2,Glare=0.15,Contrast=0.02,Saturation=0.12,Tint=Color3.fromRGB(220,235,255)
    },
    {
        Name="Galaxy",
        Sky={"rbxassetid://159454299","rbxassetid://159454296","rbxassetid://159454293","rbxassetid://159454286","rbxassetid://159454300","rbxassetid://159454288"},
        Time=12,Brightness=1.5,Exposure=0.2,
        Ambient=Color3.fromRGB(85,75,145),Outdoor=Color3.fromRGB(105,95,175),Fog=Color3.fromRGB(75,70,145),FogEnd=1800,
        AtmosColor=Color3.fromRGB(135,125,220),AtmosDecay=Color3.fromRGB(75,65,140),Density=0.08,Haze=0.3,Glare=0.12,Contrast=0.08,Saturation=0.18,Tint=Color3.fromRGB(220,215,255)
    },
    {
        Name="Space Wave",
        Sky={"rbxassetid://16262356578","rbxassetid://16262358026","rbxassetid://16262360469","rbxassetid://16262362003","rbxassetid://16262363873","rbxassetid://16262366016"},
        Time=14,Brightness=1.8,Exposure=0.25,
        Ambient=Color3.fromRGB(80,110,190),Outdoor=Color3.fromRGB(100,135,220),Fog=Color3.fromRGB(70,100,190),FogEnd=2000,
        AtmosColor=Color3.fromRGB(100,145,240),AtmosDecay=Color3.fromRGB(50,80,165),Density=0.1,Haze=0.4,Glare=0.18,Contrast=0.08,Saturation=0.18,Tint=Color3.fromRGB(205,225,255)
    },
    {
        Name="Turquoise",
        Sky={"rbxassetid://47974894","rbxassetid://47974690","rbxassetid://47974821","rbxassetid://47974776","rbxassetid://47974859","rbxassetid://47974909"},
        Time=13,Brightness=2.4,Exposure=0.15,
        Ambient=Color3.fromRGB(100,210,215),Outdoor=Color3.fromRGB(130,230,230),Fog=Color3.fromRGB(100,205,215),FogEnd=2200,
        AtmosColor=Color3.fromRGB(110,225,225),AtmosDecay=Color3.fromRGB(50,140,150),Density=0.08,Haze=0.25,Glare=0.18,Contrast=0.03,Saturation=0.2,Tint=Color3.fromRGB(205,255,255)
    },
    {
        Name="Bright Pink",
        Sky={"rbxassetid://271042516","rbxassetid://271077243","rbxassetid://271042556","rbxassetid://271042310","rbxassetid://271042467","rbxassetid://271077958"},
        Time=15,Brightness=2.4,Exposure=0.2,
        Ambient=Color3.fromRGB(255,145,210),Outdoor=Color3.fromRGB(255,180,225),Fog=Color3.fromRGB(255,150,215),FogEnd=1900,
        AtmosColor=Color3.fromRGB(255,160,225),AtmosDecay=Color3.fromRGB(155,70,130),Density=0.1,Haze=0.35,Glare=0.2,Contrast=0.04,Saturation=0.22,Tint=Color3.fromRGB(255,215,240)
    },
    {
        Name="Neptune",
        Sky={"rbxassetid://218955819","rbxassetid://218953419","rbxassetid://218954524","rbxassetid://218958493","rbxassetid://218957134","rbxassetid://218950090"},
        Time=13,Brightness=2,Exposure=0.15,
        Ambient=Color3.fromRGB(120,180,230),Outdoor=Color3.fromRGB(155,205,245),Fog=Color3.fromRGB(120,190,235),FogEnd=2000,
        AtmosColor=Color3.fromRGB(125,195,245),AtmosDecay=Color3.fromRGB(70,125,180),Density=0.1,Haze=0.35,Glare=0.15,Contrast=0.04,Saturation=0.15,Tint=Color3.fromRGB(210,235,255)
    },
    {
        Name="Golden Hour",
        Sky={"rbxassetid://323494035","rbxassetid://323494368","rbxassetid://323494130","rbxassetid://323494252","rbxassetid://323494067","rbxassetid://323493360"},
        Time=16,Brightness=2.6,Exposure=0.25,
        Ambient=Color3.fromRGB(255,210,150),Outdoor=Color3.fromRGB(255,225,175),Fog=Color3.fromRGB(255,210,165),FogEnd=2200,
        AtmosColor=Color3.fromRGB(255,220,180),AtmosDecay=Color3.fromRGB(160,125,85),Density=0.06,Haze=0.2,Glare=0.25,Contrast=0.03,Saturation=0.16,Tint=Color3.fromRGB(255,235,205)
    },
    {
        Name="Soft Day",
        Sky={"rbxassetid://135483466","rbxassetid://135483484","rbxassetid://135483461","rbxassetid://135483495","rbxassetid://135483499","rbxassetid://135483475"},
        Time=12,Brightness=2.4,Exposure=0.25,
        Ambient=Color3.fromRGB(205,215,235),Outdoor=Color3.fromRGB(225,230,245),Fog=Color3.fromRGB(205,220,240),FogEnd=2500,
        AtmosColor=Color3.fromRGB(220,235,255),AtmosDecay=Color3.fromRGB(150,170,200),Density=0.04,Haze=0.15,Glare=0.1,Contrast=0,Saturation=0.06,Tint=Color3.fromRGB(240,245,255)
    },
    {
        Name="Elegant Morning",
        Sky={"rbxassetid://153767241","rbxassetid://153767216","rbxassetid://153767266","rbxassetid://153767200","rbxassetid://153767231","rbxassetid://153767288"},
        Time=8.2,Brightness=2.6,Exposure=0.25,
        Ambient=Color3.fromRGB(210,225,255),Outdoor=Color3.fromRGB(225,235,255),Fog=Color3.fromRGB(205,225,255),FogEnd=2200,
        AtmosColor=Color3.fromRGB(205,225,255),AtmosDecay=Color3.fromRGB(145,175,210),Density=0.1,Haze=0.3,Glare=0.2,Contrast=0.02,Saturation=0.08,Tint=Color3.fromRGB(225,235,255)
    },
    {
        Name="Pink Sunset",
        Sky={"rbxassetid://323494035","rbxassetid://323494368","rbxassetid://323494130","rbxassetid://323494252","rbxassetid://323494067","rbxassetid://323493360"},
        Time=18,Brightness=2,Exposure=0.2,
        Ambient=Color3.fromRGB(255,150,210),Outdoor=Color3.fromRGB(255,180,220),Fog=Color3.fromRGB(255,155,215),FogEnd=1700,
        AtmosColor=Color3.fromRGB(255,165,220),AtmosDecay=Color3.fromRGB(160,80,130),Density=0.14,Haze=0.5,Glare=0.25,Contrast=0.04,Saturation=0.2,Tint=Color3.fromRGB(255,220,240)
    }
}

local function ClearKittyWorldEffects()
    for _,object in ipairs(game:GetService("Lighting"):GetChildren()) do
        if object.Name=="KittylolSky" or object.Name=="KittylolAtmosphere" or object.Name=="KittylolColorCorrection" or object.Name=="KittylolBloom" then
            object:Destroy()
        end
    end
end

local function ApplyWorldPreset(preset)
    if not preset then return end
    local Lighting=game:GetService("Lighting")
    ClearKittyWorldEffects()

    local sky=Instance.new("Sky")
    sky.Name="KittylolSky"
    sky.SkyboxBk=preset.Sky[1]
    sky.SkyboxDn=preset.Sky[2]
    sky.SkyboxFt=preset.Sky[3]
    sky.SkyboxLf=preset.Sky[4]
    sky.SkyboxRt=preset.Sky[5]
    sky.SkyboxUp=preset.Sky[6]
    sky.CelestialBodiesShown=true
    sky.StarCount=3000
    sky.Parent=Lighting

    Lighting.ClockTime=preset.Time
    Lighting.Brightness=preset.Brightness
    Lighting.ExposureCompensation=preset.Exposure
    Lighting.Ambient=preset.Ambient
    Lighting.OutdoorAmbient=preset.Outdoor
    Lighting.FogColor=preset.Fog
    Lighting.FogStart=0
    Lighting.FogEnd=preset.FogEnd

    local atmosphere=Instance.new("Atmosphere")
    atmosphere.Name="KittylolAtmosphere"
    atmosphere.Color=preset.AtmosColor
    atmosphere.Decay=preset.AtmosDecay
    atmosphere.Density=preset.Density
    atmosphere.Haze=preset.Haze
    atmosphere.Glare=preset.Glare
    atmosphere.Parent=Lighting

    local correction=Instance.new("ColorCorrectionEffect")
    correction.Name="KittylolColorCorrection"
    correction.Brightness=0.03
    correction.Contrast=preset.Contrast
    correction.Saturation=preset.Saturation
    correction.TintColor=preset.Tint
    correction.Parent=Lighting

    local bloom=Instance.new("BloomEffect")
    bloom.Name="KittylolBloom"
    bloom.Intensity=0.12
    bloom.Size=24
    bloom.Threshold=1.2
    bloom.Parent=Lighting
end

local WorldGroup=World:create_group("Sky Changer","left")

local WorldNames={}
for _,preset in ipairs(WorldPresets) do
    WorldNames[#WorldNames+1]=preset.Name
end

local WorldEnabled=false
local WorldSelected=WorldNames[1]

WorldGroup:create_toggle("world_sky_changer",{
    title="Sky Changer",
    default=false,
    callback=function(value)
        WorldEnabled=value
        if value then
            for _,preset in ipairs(WorldPresets) do
                if preset.Name==WorldSelected then
                    ApplyWorldPreset(preset)
                    break
                end
            end
        else
            ClearKittyWorldEffects()
        end
    end,
})

WorldGroup:create_dropdown("world_sky_preset",{
    title="Sky Preset",
    options=WorldNames,
    default=WorldNames[1],
    callback=function(value)
        WorldSelected=value
        if WorldEnabled then
            for _,preset in ipairs(WorldPresets) do
                if preset.Name==value then
                    ApplyWorldPreset(preset)
                    break
                end
            end
        end
    end,
})

local HitSoundEnabled = false
local UnlockGroup = Unlock:create_group("Unlock", "left")
UnlockGroup:create_toggle("unlock_all", {
    title = "Unlock All",
    default = false,
    callback = function(state)
        getgenv().unlockAllEnabled = state
        if state and getgenv().__runUnlockAll then
            task.spawn(getgenv().__runUnlockAll)
        end
    end,
})

local VisualLeft = Visual:create_group("Ability ESP", "left")
do
    local Visual_Data = {}
    local Visual_HeartbeatConn
    local Visual_PlayerAddedConn
    local Visual_Cooldowns = {}
    local Visual_IconCache = {}
    local Visual_CharConns = {}
    local Visual_AliveAddedConn
    local Visual_AliveRemovedConn
    local visual_last_update = 0
    local Abilities = require(ReplicatedStorage.Shared.Abilities)

    local function esp_get_cd(plr)
        local ability=plr:GetAttribute("CurrentlyEquippedAbility") or plr:GetAttribute("EquippedAbility")
        if not ability then return nil end
        local ok,cd=pcall(Abilities.getAbilityCooldown,plr,ability)
        if ok and type(cd)=="number" and cd>0 then return cd end
        return nil
    end

    local function esp_get_icon(abilityName)
        if not abilityName or abilityName=="" then return "" end
        if Visual_IconCache[abilityName]~=nil then return Visual_IconCache[abilityName] end
        local shared=ReplicatedStorage:FindFirstChild("Shared")
        local abilities=shared and shared:FindFirstChild("Abilities")
        local m=abilities and abilities:FindFirstChild(abilityName)
        if not m then Visual_IconCache[abilityName]=""; return "" end
        local ok,mod=pcall(require,m)
        local icon=(ok and mod and type(mod.iconId)=="string") and mod.iconId or ""
        Visual_IconCache[abilityName]=icon
        return icon
    end

    local function create_esp_for_player(plr)
        task.spawn(function()
            local char=plr.Character
            while not char or not char.Parent do
                if not getgenv().VisualESP then return end
                task.wait()
                char=plr.Character
            end
            local head=char:WaitForChild("Head",10)
            if not head or not getgenv().VisualESP then return end
            if Visual_Data[plr] then
                pcall(function() Visual_Data[plr].bill:Destroy() end)
                if Visual_Data[plr].cdConn then pcall(function() Visual_Data[plr].cdConn:Disconnect() end) end
                Visual_Data[plr]=nil
            end
            local bill=Instance.new("BillboardGui")
            bill.Name="VisualESPGui"
            bill.Adornee=head
            bill.Size=UDim2.fromOffset(100,62)
            bill.StudsOffset=Vector3.new(0,3.2,0)
            bill.AlwaysOnTop=true
            bill.ResetOnSpawn=false
            bill.Parent=CoreGui
            local icon=Instance.new("ImageLabel")
            icon.Name="AbilityIcon"
            icon.Size=UDim2.fromOffset(32,32)
            icon.AnchorPoint=Vector2.new(0.5,0)
            icon.Position=UDim2.new(0.5,0,0,0)
            icon.BackgroundTransparency=1
            icon.BorderSizePixel=0
            icon.ScaleType=Enum.ScaleType.Fit
            icon.Image=esp_get_icon(plr:GetAttribute("CurrentlyEquippedAbility") or plr:GetAttribute("EquippedAbility") or "")
            icon.Parent=bill
            local label=Instance.new("TextLabel")
            label.Size=UDim2.new(1,0,0,14)
            label.Position=UDim2.new(0,0,0,34)
            label.BackgroundTransparency=1
            label.FontFace=Font.new("rbxasset://fonts/families/GothamSSm.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
            label.TextColor3=Color3.fromRGB(255,255,255)
            label.TextSize=11
            label.TextStrokeColor3=Color3.fromRGB(0,0,0)
            label.TextStrokeTransparency=0.2
            label.TextXAlignment=Enum.TextXAlignment.Center
            label.TextTruncate=Enum.TextTruncate.AtEnd
            label.Text=plr:GetAttribute("CurrentlyEquippedAbility") or plr:GetAttribute("EquippedAbility") or plr.DisplayName
            label.Parent=bill
            local timerLabel=Instance.new("TextLabel")
            timerLabel.Size=UDim2.new(1,0,0,13)
            timerLabel.Position=UDim2.new(0,0,0,49)
            timerLabel.BackgroundTransparency=1
            timerLabel.FontFace=Font.new("rbxasset://fonts/families/SFPro.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
            timerLabel.TextColor3=Color3.fromRGB(100,220,100)
            timerLabel.TextSize=12
            timerLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
            timerLabel.TextStrokeTransparency=0.2
            timerLabel.TextXAlignment=Enum.TextXAlignment.Center
            timerLabel.Text="Ready"
            timerLabel.Parent=bill
            local last_cd=0
            local cdConn=char.AttributeChanged:Connect(function(attr)
                if attr=="CooldownExpiration" then
                    local val=char:GetAttribute("CooldownExpiration")
                    if (val==0 or val==nil) and tick()-last_cd>0.5 then
                        local dur=esp_get_cd(plr)
                        if dur then last_cd=tick(); Visual_Cooldowns[plr]={expiry=tick()+dur,duration=dur} end
                    end
                elseif attr=="AbilityActive" then
                    if char:GetAttribute("AbilityActive")==true and tick()-last_cd>0.5 then
                        local dur=esp_get_cd(plr)
                        if dur then last_cd=tick(); Visual_Cooldowns[plr]={expiry=tick()+dur,duration=dur} end
                    end
                end
            end)
            local ab=plr:GetAttribute("CurrentlyEquippedAbility") or plr:GetAttribute("EquippedAbility")
            local ok,dur=pcall(Abilities.getAbilityCooldown,plr,ab or "")
            Visual_Data[plr]={bill=bill,label=label,icon=icon,timerLabel=timerLabel,cdConn=cdConn,isPassive=ok and type(dur)=="number" and dur<=0}
        end)
    end

    local function add_esp_player(plr)
        if plr==LocalPlayer or Visual_CharConns[plr] then return end
        local a=plr.CharacterAdded:Connect(function()
            Visual_Cooldowns[plr]=nil
            create_esp_for_player(plr)
        end)
        local r=plr.CharacterRemoving:Connect(function()
            Visual_Cooldowns[plr]=nil
        end)
        Visual_CharConns[plr]={a,r}
        if plr.Character then create_esp_for_player(plr) end
    end

    local function stop_ability_esp()
        getgenv().VisualESP=false
        if Visual_HeartbeatConn then Visual_HeartbeatConn:Disconnect(); Visual_HeartbeatConn=nil end
        if Visual_PlayerAddedConn then Visual_PlayerAddedConn:Disconnect(); Visual_PlayerAddedConn=nil end
        if Visual_AliveAddedConn then Visual_AliveAddedConn:Disconnect(); Visual_AliveAddedConn=nil end
        if Visual_AliveRemovedConn then Visual_AliveRemovedConn:Disconnect(); Visual_AliveRemovedConn=nil end
        for _,conns in pairs(Visual_CharConns) do
            for _,c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        end
        table.clear(Visual_CharConns)
        for _,data in pairs(Visual_Data) do
            pcall(function() data.bill:Destroy() end)
            if data.cdConn then pcall(function() data.cdConn:Disconnect() end) end
        end
        Visual_Data={}
        Visual_Cooldowns={}
        table.clear(Visual_IconCache)
    end

    local function start_ability_esp()
        getgenv().VisualESP=true
        if not Visual_HeartbeatConn then
            Visual_HeartbeatConn=RunService.Heartbeat:Connect(function()
                if not getgenv().VisualESP then return end
                local now=tick()
                if now-visual_last_update<0.1 then return end
                visual_last_update=now
                for plr,data in pairs(Visual_Data) do
                    if not plr.Parent then
                        pcall(function() data.bill:Destroy() end)
                        if data.cdConn then pcall(function() data.cdConn:Disconnect() end) end
                        Visual_Data[plr]=nil
                        Visual_Cooldowns[plr]=nil
                    else
                        local ab=plr:GetAttribute("CurrentlyEquippedAbility") or plr:GetAttribute("EquippedAbility") or ""
                        local display=ab~="" and ab or plr.DisplayName
                        if data.label.Text~=display then
                            data.label.Text=display
                            data.icon.Image=esp_get_icon(ab)
                            local ok,dur=pcall(Abilities.getAbilityCooldown,plr,ab)
                            data.isPassive=ok and type(dur)=="number" and dur<=0
                            Visual_Cooldowns[plr]=nil
                        end
                        local cd=Visual_Cooldowns[plr]
                        if cd and now<cd.expiry then
                            data.timerLabel.Text=string.format("%.1fs",cd.expiry-now)
                        elseif data.isPassive then
                            data.timerLabel.Text="Passive"
                        else
                            data.timerLabel.Text="Ready"
                        end
                    end
                end
            end)
        end
        for _,plr in ipairs(Players:GetPlayers()) do add_esp_player(plr) end
        if not Visual_PlayerAddedConn then
            Visual_PlayerAddedConn=Players.PlayerAdded:Connect(function(plr)
                if getgenv().VisualESP then add_esp_player(plr) end
            end)
        end
    end

    getgenv()._CSKR_VisualVisual_Stop=stop_ability_esp
    VisualLeft:create_toggle("ability_esp", {
        title="Ability ESP",
        default=false,
        callback=function(state)
            if state then start_ability_esp() else stop_ability_esp() end
        end,
    })
end

local VisualRight = Visual:create_group("Ball Statistic", "right")
do
    local BallStatsState={gui=nil,frame=nil,vlog=nil,plog=nil,connection=nil,peak_velocity=0}
    local function get_real_ball()
        local balls=workspace:FindFirstChild("Balls")
        if not balls then return nil end
        for _,ball in ipairs(balls:GetChildren()) do
            if ball:GetAttribute("realBall") then
                ball.CanCollide=false
                return ball
            end
        end
    end
    local function destroy_ball_stats()
        if BallStatsState.connection then BallStatsState.connection:Disconnect(); BallStatsState.connection=nil end
        if BallStatsState.gui then pcall(function() BallStatsState.gui:Destroy() end) end
        BallStatsState.gui=nil
        BallStatsState.frame=nil
        BallStatsState.vlog=nil
        BallStatsState.plog=nil
        BallStatsState.peak_velocity=0
    end
    local function create_ball_stats_gui()
        if BallStatsState.gui then return end
        local gui=Instance.new("ScreenGui")
        gui.Name="CSKRBallMetrics"
        gui.ResetOnSpawn=false
        gui.IgnoreGuiInset=true
        gui.DisplayOrder=99
        gui.Parent=CoreGui
        local panel=Instance.new("Frame")
        panel.Name="Panel"
        panel.Size=UDim2.fromOffset(184,96)
        panel.Position=UDim2.new(0,20,0.5,-48)
        panel.BackgroundColor3=Color3.fromRGB(255,255,255)
        panel.BorderSizePixel=0
        panel.Active=true
        panel.Parent=gui
        local corner=Instance.new("UICorner")
        corner.CornerRadius=UDim.new(0,13)
        corner.Parent=panel
        local stroke=Instance.new("UIStroke")
        stroke.Color=Color3.fromRGB(255,255,255)
        stroke.Transparency=0.78
        stroke.Thickness=1
        stroke.Parent=panel
        local grad=Instance.new("UIGradient")
        grad.Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0,Color3.fromRGB(145,145,145)),
            ColorSequenceKeypoint.new(0.3,Color3.fromRGB(12,12,12)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))
        }
        grad.Rotation=90
        grad.Parent=panel
        local title=Instance.new("TextLabel")
        title.BackgroundTransparency=1
        title.Size=UDim2.new(1,-20,0,22)
        title.Position=UDim2.fromOffset(10,7)
        title.FontFace=Font.new("rbxasset://fonts/families/SFPro.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
        title.Text="Ball Stats"
        title.TextColor3=Color3.fromRGB(255,255,255)
        title.TextSize=16
        title.TextXAlignment=Enum.TextXAlignment.Left
        title.Parent=panel
        local div=Instance.new("Frame")
        div.Size=UDim2.new(1,-20,0,1)
        div.Position=UDim2.fromOffset(10,34)
        div.BackgroundColor3=Color3.fromRGB(255,255,255)
        div.BackgroundTransparency=0.93
        div.BorderSizePixel=0
        div.Parent=panel
        local speedLabel=Instance.new("TextLabel")
        speedLabel.BackgroundTransparency=1
        speedLabel.Size=UDim2.fromOffset(88,24)
        speedLabel.Position=UDim2.fromOffset(14,42)
        speedLabel.FontFace=Font.new("rbxasset://fonts/families/SFPro.json",Enum.FontWeight.Medium,Enum.FontStyle.Normal)
        speedLabel.Text="Speed"
        speedLabel.TextColor3=Color3.fromRGB(178,178,185)
        speedLabel.TextSize=14
        speedLabel.TextXAlignment=Enum.TextXAlignment.Left
        speedLabel.Parent=panel
        local speedVal=Instance.new("TextLabel")
        speedVal.BackgroundTransparency=1
        speedVal.Size=UDim2.fromOffset(64,24)
        speedVal.Position=UDim2.new(1,-78,0,42)
        speedVal.FontFace=Font.new("rbxasset://fonts/families/SFPro.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
        speedVal.Text="0.0"
        speedVal.TextColor3=Color3.fromRGB(255,255,255)
        speedVal.TextSize=16
        speedVal.TextXAlignment=Enum.TextXAlignment.Right
        speedVal.Parent=panel
        local peakLabel=Instance.new("TextLabel")
        peakLabel.BackgroundTransparency=1
        peakLabel.Size=UDim2.fromOffset(88,24)
        peakLabel.Position=UDim2.fromOffset(14,67)
        peakLabel.FontFace=Font.new("rbxasset://fonts/families/SFPro.json",Enum.FontWeight.Medium,Enum.FontStyle.Normal)
        peakLabel.Text="Peak"
        peakLabel.TextColor3=Color3.fromRGB(178,178,185)
        peakLabel.TextSize=14
        peakLabel.TextXAlignment=Enum.TextXAlignment.Left
        peakLabel.Parent=panel
        local peakVal=Instance.new("TextLabel")
        peakVal.BackgroundTransparency=1
        peakVal.Size=UDim2.fromOffset(64,24)
        peakVal.Position=UDim2.new(1,-78,0,67)
        peakVal.FontFace=Font.new("rbxasset://fonts/families/SFPro.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
        peakVal.Text="0.0"
        peakVal.TextColor3=Color3.fromRGB(255,255,255)
        peakVal.TextSize=16
        peakVal.TextXAlignment=Enum.TextXAlignment.Right
        peakVal.Parent=panel
        local dragging=false
        local dragStart
        local startPos
        panel.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging=true
                dragStart=input.Position
                startPos=panel.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
                local delta=input.Position-dragStart
                panel.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
        end)
        BallStatsState.gui=gui
        BallStatsState.frame=panel
        BallStatsState.vlog=speedVal
        BallStatsState.plog=peakVal
    end
    local function enable_ball_stats()
        create_ball_stats_gui()
        if BallStatsState.connection then BallStatsState.connection:Disconnect() end
        local elapsed=0
        BallStatsState.connection=RunService.RenderStepped:Connect(function(dt)
            elapsed+=dt
            if elapsed<0.05 then return end
            elapsed=0
            if not BallStatsState.frame then return end
            local ball=get_real_ball()
            local speed=0
            if ball then
                local velocity=ball.AssemblyLinearVelocity or Vector3.new()
                if typeof(velocity)=="Vector3" then speed=velocity.Magnitude end
            end
            BallStatsState.vlog.Text=string.format("%.1f",speed)
            if speed>BallStatsState.peak_velocity then
                BallStatsState.peak_velocity=speed
                BallStatsState.plog.Text=string.format("%.1f",speed)
            end
        end)
    end
    VisualRight:create_toggle("ball_statistic", {
        title="Ball Statistic",
        default=false,
        callback=function(state)
            if state then
                enable_ball_stats()
            else
                destroy_ball_stats()
            end
        end,
    })
end


local Connections_Manager = {}

local NoRenderGroup = MiscTab:create_group("No Render", "left")

NoRenderGroup:create_toggle("Kittylol_Misc_NoRender", {
    title = "No Render",
    default = false,
    callback = function(state)

            local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
        local effectScripts = playerScripts and playerScripts:FindFirstChild("EffectScripts")
        local clientFX = effectScripts and effectScripts:FindFirstChild("ClientFX")
        if clientFX then
            clientFX.Disabled = state
        end
    
            if state then
                Connections_Manager['No Render'] = workspace.Runtime.ChildAdded:Connect(function(Value)
                    Debris:AddItem(Value, 0)
                end)
            else
                if Connections_Manager['No Render'] then
                    Connections_Manager['No Render']:Disconnect()
                    Connections_Manager['No Render'] = nil
                end
            end
    end
})

local EmotesGroup = MiscTab:create_group("Emotes", "left")

EmotesGroup:create_toggle("Kittylol_Misc_Emotes", {
    title = "Emotes",
    default = false,
    callback = function(value)
        getgenv().Animations = value
        if value then
            animation_system.start()
            if selected_animation then
                animation_system.play(selected_animation)
            end
        else
            animation_system.cleanup()
        end
    end
})

EmotesGroup:create_toggle("Kittylol_Misc_Emotes_AutoStop", {
    title = "Auto Stop",
    default = false,
    callback = function(value)
        getgenv().AutoStop = value
    end
})

EmotesGroup:create_dropdown("Kittylol_Misc_Emotes_Selected", {
    title = "Emote Type",
    options = emotes_data,
    default = selected_animation,
    callback = function(value)
        selected_animation = value
        if getgenv().Animations then
            animation_system.play(value)
        end
    end
})

local FOVGroup = MiscTab:create_group("FOV", "left")

FOVGroup:create_toggle("Kittylol_Misc_FOV", {
    title = "FOV",
    default = false,
    callback = function(value)

        getgenv().CameraEnabled = value
        local Camera = game:GetService("Workspace").CurrentCamera
    
        if value then
            getgenv().CameraFOV = getgenv().CameraFOV or 70
            Camera.FieldOfView = getgenv().CameraFOV
                
            if not getgenv().FOVLoop then
                getgenv().FOVLoop = game:GetService("RunService").RenderStepped:Connect(function()
                    if getgenv().CameraEnabled then
                        Camera.FieldOfView = getgenv().CameraFOV
                    end
                end)
            end
        else
            Camera.FieldOfView = 70
                
            if getgenv().FOVLoop then
                getgenv().FOVLoop:Disconnect()
                getgenv().FOVLoop = nil
            end
        end
    end
})

FOVGroup:create_slider("Kittylol_Misc_FOV_Value", {

    title = 'Camera FOV',
    flag = 'Camera_FOV',
    
    maximum = 120,
    minimum = 50,
    default = 70,
    
    rounding = true,
    
    callback = function(value)
        getgenv().CameraFOV = value
        if getgenv().CameraEnabled then
            game:GetService("Workspace").CurrentCamera.FieldOfView = value
        end
    end
})

local CharacterGroup = MiscTab:create_group("Character", "right")

CharacterGroup:create_toggle("Kittylol_Misc_Character", {
    title = "Character",
    default = false,
    callback = function(value)
        CharacterBackendSetEnabled(value)
    end
})

CharacterGroup:create_toggle("Kittylol_Misc_Character_InfiniteJump", {
    title = "Infinite Jump",
    flag = "Kittylol_Misc_Character_InfiniteJump",
    callback = function(value)
        CharacterBackendSetInfiniteJump(value)
    end
})

CharacterGroup:create_toggle("Kittylol_Misc_Character_Spin", {
    title = "Spin",
    flag = "Kittylol_Misc_Character_Spin",
    callback = function(value)
        getgenv().SpinbotCheckboxEnabled = value
        
        if not value and getgenv().CharacterModifierEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and getgenv().OriginalValues then
                char.Humanoid.AutoRotate = getgenv().OriginalValues.AutoRotate or true
            end
        end
    end
})

CharacterGroup:create_slider("Kittylol_Misc_Character_SpinSpeed", {
    title = 'Spin Speed',
    flag = 'Kittylol_Misc_Character_SpinSpeed',
    maximum = 50,
    minimum = 1,
    default = 5,
    rounding = true,

    callback = function(value)
        getgenv().CustomSpinSpeed = value
    end
})

CharacterGroup:create_toggle("Kittylol_Misc_Character_WalkSpeed", {
    title = "Walk Speed",
    flag = "Kittylol_Misc_Character_WalkSpeed",
    callback = function(value)
        getgenv().WalkspeedCheckboxEnabled = value
        
        if not value and getgenv().CharacterModifierEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and getgenv().OriginalValues then
                char.Humanoid.WalkSpeed = getgenv().OriginalValues.WalkSpeed or 16
            end
        end
    end
})

CharacterGroup:create_slider("Kittylol_Misc_Character_WalkSpeedValue", {
    title = 'Walk Speed Value',
    flag = 'Kittylol_Misc_Character_WalkSpeedValue',
    maximum = 500,
    minimum = 16,
    default = 36,
    rounding = true,

    callback = function(value)
        getgenv().CustomWalkSpeed = value
        
        if getgenv().CharacterModifierEnabled and getgenv().WalkspeedCheckboxEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = value
            end
        end
    end
})

CharacterGroup:create_toggle("Kittylol_Misc_Character_JumpPower", {
    title = "Jump Power",
    flag = "Kittylol_Misc_Character_JumpPower",
    callback = function(value)
        getgenv().JumpPowerCheckboxEnabled = value
        
        if not value and getgenv().CharacterModifierEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and getgenv().OriginalValues then
                local humanoid = char.Humanoid
                if humanoid.UseJumpPower then
                    humanoid.JumpPower = getgenv().OriginalValues.JumpPower or 50
                else
                    humanoid.JumpHeight = getgenv().OriginalValues.JumpHeight or 7.2
                end
            end
        end
    end
})

CharacterGroup:create_slider("Kittylol_Misc_Character_JumpPowerValue", {
    title = 'Jump Power Value',
    flag = 'Kittylol_Misc_Character_JumpPowerValue',
    maximum = 200,
    minimum = 50,
    default = 50,
    rounding = true,

    callback = function(value)
        getgenv().CustomJumpPower = value
        getgenv().CustomJumpHeight = value * 0.144
        
        if getgenv().CharacterModifierEnabled and getgenv().JumpPowerCheckboxEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local humanoid = char.Humanoid
                if humanoid.UseJumpPower then
                    humanoid.JumpPower = value
                else
                    humanoid.JumpHeight = value * 0.144
                end
            end
        end
    end
})

CharacterGroup:create_toggle("Kittylol_Misc_Character_Gravity", {
    title = "Gravity",
    flag = "Kittylol_Misc_Character_Gravity",
    callback = function(value)
        getgenv().GravityCheckboxEnabled = value
        
        if not value and getgenv().CharacterModifierEnabled then
            workspace.Gravity = 196.2
        end
    end
})

CharacterGroup:create_slider("Kittylol_Misc_Character_GravityValue", {
    title = 'Gravity Value',
    flag = 'Kittylol_Misc_Character_GravityValue',
    maximum = 400.0,
    minimum = 0,
    default = 196.2,
    rounding = true,

    callback = function(value)
        getgenv().CustomGravity = value
        
        if getgenv().CharacterModifierEnabled and getgenv().GravityCheckboxEnabled then
            workspace.Gravity = value
        end
    end
})

CharacterGroup:create_toggle("Kittylol_Misc_Character_HipHeight", {
    title = "Hip Height",
    flag = "Kittylol_Misc_Character_HipHeight",
    callback = function(value)
        getgenv().HipHeightCheckboxEnabled = value
        
        if not value and getgenv().CharacterModifierEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and getgenv().OriginalValues then
                char.Humanoid.HipHeight = getgenv().OriginalValues.HipHeight or 0
            end
        end
    end
})

CharacterGroup:create_slider("Kittylol_Misc_Character_HipHeightValue", {
    title = 'Hip Height Value',
    flag = 'Kittylol_Misc_Character_HipHeightValue',
    maximum = 20,
    minimum = -5,
    default = 0,
    rounding = true,

    callback = function(value)
        getgenv().CustomHipHeight = value
        
        if getgenv().CharacterModifierEnabled and getgenv().HipHeightCheckboxEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.HipHeight = value
            end
        end
    end
})

ImmortalGroup:create_toggle("kittylol_immortal", {
    title = "Kittylol Immortal",
    default = false,
    callback = function(state)
        if state then
            startBackgroundOrbit()
        else
            stopBackgroundOrbit()
        end
    end,
})

print("Kittylol  1/3")
print("Kittylol  2/3")
print("Kittylol  3/3")
print("Kittylol  success")


end)