if game.PlaceId ~= 103854444055060 and game.GameId ~= 103854444055060 then return end
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Silent Assassins - v1.8.0",
    LoadingTitle = "Silent Assassins",
    LoadingSubtitle = "made by LSS",
    ConfigurationSaving = { Enabled = false, FolderName = nil, FileName = "SilentAssassins" },
    Discord = { Enabled = false, Invite = "noinvitelink", RememberJoins = true },
    KeySystem = false,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local bodyParts = {
    ["Head"] = true, ["Torso"] = true, ["Left Arm"] = true, ["Right Arm"] = true, ["Left Leg"] = true, ["Right Leg"] = true,
    ["UpperTorso"] = true, ["LowerTorso"] = true,
    ["LeftUpperArm"] = true, ["LeftLowerArm"] = true, ["LeftHand"] = true,
    ["RightUpperArm"] = true, ["RightLowerArm"] = true, ["RightHand"] = true,
    ["LeftUpperLeg"] = true, ["LeftLowerLeg"] = true, ["LeftFoot"] = true,
    ["RightUpperLeg"] = true, ["RightLowerLeg"] = true, ["RightFoot"] = true
}

local AimlockEnabled, AimConfig = false, { Smoothness = 0.6, AimPart = "HumanoidRootPart" }
local AutoAttackAllEnabled = false
local SpamSpeedEnabled = false
local DupeMultiplier = 1000
local FastSlashEnabled, SlashSpeedValue = false, 0.2
local HideFootstepEnabled, HideJumpDustEnabled, InvisibleSlashingEnabled, BypassInitialized = false, false, false, false
local AutoChestEnabled, SelectedChest, ChestMultiplier = false, "Basic", 15
local AutoEquipEnabled, LastEquippedWeapon = false, nil
local WeaponRanks = {"Steel", "Obsidian", "Thunder", "Sakura", "Frostbite", "Astra", "Hydra", "Gaia", "Pheonix", "Draco", "Aether", "Terraprisma"}
local TargetPlayerCount = 5
local AutoHopEnabled = false
local HopLeaveCount = 3
local HopJoinCount = 6
local AntiFlingEnabled, lastSafePos = true, nil
local NoclipEnabled = false
local WalkSpeedEnabled, WalkSpeedValue = false, 16
local InfJumpEnabled = false
local AntiStaffEnabled = true
local STAFF_USER_ID = 71552399

local ChamsEnabled = false
local ChamsCache = {}
local ChamsConnections = {}
local ESPConnections = {}
local OriginalStates = setmetatable({}, {__mode = "k"})
local ScriptConnections = {}
local Unloaded = false

local GameRemoteFunction = ReplicatedStorage:WaitForChild("Events"):WaitForChild("GameRemoteFunction")
local WeaponCache = {}
local WeaponCachePopulated = false
local UIRefs = {}

local function isAlive(player)
    local char = player.Character
    return char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and char:FindFirstChild("HumanoidRootPart")
end

local function IsVisible(targetChar)
    local myChar = LocalPlayer.Character
    if not myChar or not targetChar then return false end
    local origin = myChar:FindFirstChild("Head") and myChar.Head.Position or myChar.HumanoidRootPart.Position
    local targetPart = targetChar:FindFirstChild(AimConfig.AimPart)
    if not targetPart then return false end
    local direction = targetPart.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {myChar, Camera}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, direction, raycastParams)
    return (not result or result.Instance:IsDescendantOf(targetChar))
end

local function GetNearestTarget()
    local nearest, minDistance = nil, math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isAlive(p) and IsVisible(p.Character) then
            local dist = (myChar.HumanoidRootPart.Position - p.Character[AimConfig.AimPart].Position).Magnitude
            if dist < minDistance then
                minDistance = dist
                nearest = p
            end
        end
    end
    return nearest
end

local function HopToServer(targetAmount)
    local endpoints = {
        "https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100",
        "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    }
    local decodedData
    for _, url in ipairs(endpoints) do
        local success, response = pcall(function() return game:HttpGet(url) end)
        if success and response then
            local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response) end)
            if decodeSuccess and data and data.data then decodedData = data; break end
        end
    end
    if decodedData and decodedData.data then
        local validServers = {}
        for _, v in ipairs(decodedData.data) do
            if type(v) == "table" and v.playing == targetAmount and v.id ~= game.JobId then table.insert(validServers, v.id) end
        end
        if #validServers > 0 then
            Rayfield:Notify({ Title = "Server Hop", Content = "Teleporting...", Duration = 3, Image = 4483362458 })
            TeleportService:TeleportToPlaceInstance(game.PlaceId, validServers[math.random(1, #validServers)])
        else
            Rayfield:Notify({ Title = "Server Hop", Content = "No server found with " .. targetAmount .. " players.", Duration = 4, Image = 4483362458 })
        end
    else
        Rayfield:Notify({ Title = "Server Hop", Content = "Failed to fetch servers.", Duration = 4, Image = 4483362458 })
    end
end

local function HopToServerClosest(targetAmount)
    local endpoints = {
        "https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100",
        "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    }
    local decodedData
    for _, url in ipairs(endpoints) do
        local success, response = pcall(function() return game:HttpGet(url) end)
        if success and response then
            local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response) end)
            if decodeSuccess and data and data.data then decodedData = data; break end
        end
    end
    if decodedData and decodedData.data then
        local bestServers = {}
        local minDiff = math.huge
        local bestPlayingCount = 0
        for _, v in ipairs(decodedData.data) do
            if type(v) == "table" and type(v.playing) == "number" and v.id ~= game.JobId then
                local diff = math.abs(v.playing - targetAmount)
                if diff < minDiff then
                    minDiff = diff
                    bestServers = {v.id};
                    bestPlayingCount = v.playing
                elseif diff == minDiff then table.insert(bestServers, v.id) end
            end
        end
        if #bestServers > 0 then
            Rayfield:Notify({ Title = "Auto Hop", Content = "Teleporting to server (" .. bestPlayingCount .. " players)...", Duration = 3, Image = 4483362458 })
            TeleportService:TeleportToPlaceInstance(game.PlaceId, bestServers[math.random(1, #bestServers)])
        else
            Rayfield:Notify({ Title = "Auto Hop", Content = "No suitable server found. Retrying...", Duration = 3, Image = 4483362458 })
        end
    end
end

local function HopToRandomServer()
    local endpoints = {
        "https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100",
        "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    }
    local decodedData
    for _, url in ipairs(endpoints) do
        local success, response = pcall(function() return game:HttpGet(url) end)
        if success and response then
            local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response) end)
            if decodeSuccess and data and data.data then decodedData = data; break end
        end
    end
    if decodedData and decodedData.data then
        local validServers = {}
        for _, v in ipairs(decodedData.data) do
            if type(v) == "table" and v.id ~= game.JobId then table.insert(validServers, v.id) end
        end
        if #validServers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, validServers[math.random(1, #validServers)])
        end
    end
end

local function CheckAndHopFromStaff()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.UserId == STAFF_USER_ID then
            Rayfield:Notify({ Title = "Anti Staff", Content = "Staff detected! Hopping to random server...", Duration = 3, Image = 4483362458 })
            task.wait(0.3)
            HopToRandomServer()
            return true
        end
    end
    return false
end

local function GetCurrentLocation(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local ignoreList = {char}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then table.insert(ignoreList, player.Character) end
    end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = ignoreList
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(root.Position, Vector3.new(0, -500, 0), params)
    if result and result.Instance then
        local hitInstance = result.Instance
        local lobbyFolder = workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("Ground")
        if lobbyFolder and hitInstance:IsDescendantOf(lobbyFolder) then return "Lobby" end
        local functionalFolder = workspace:FindFirstChild("Functional")
        if functionalFolder then
            local votingModel = functionalFolder:FindFirstChild("VotingModel")
            if votingModel and hitInstance:IsDescendantOf(votingModel) then return "Lobby" end
            local gachaChestsFolder = functionalFolder:FindFirstChild("GachaChests")
            if gachaChestsFolder then
                local chest1 = gachaChestsFolder:FindFirstChild("GachaChest1")
                local chest2 = gachaChestsFolder:FindFirstChild("GachaChest2")
                if chest1 and hitInstance:IsDescendantOf(chest1) then return "Lobby" end
                if chest2 and hitInstance:IsDescendantOf(chest2) then return "Lobby" end
            end
            local limitedFolder = functionalFolder:FindFirstChild("Limited")
            if limitedFolder and hitInstance:IsDescendantOf(limitedFolder) then return "Lobby" end
        end
        return "Match"
    end
    return nil
end

local function ApplyFastSlashConfig()
    local c_speed = FastSlashEnabled and SlashSpeedValue or 0.65
    local c_slowMult = FastSlashEnabled and 1 or 0.2
    local c_slowTime = FastSlashEnabled and 0 or 1.5
    pcall(function()
        if not WeaponCachePopulated then
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "attackOrder") and rawget(v, "attackCycle") then
                    table.insert(WeaponCache, v)
                end
            end
            WeaponCachePopulated = true
        end
        for _, v in ipairs(WeaponCache) do
            local cycle = rawget(v, "attackCycle")
            if type(cycle) == "table" then
                for key, data in pairs(cycle) do
                    if type(data) == "table" then
                        data.attackTime = c_speed
                        data.slowMult = c_slowMult
                        data.slowTime = c_slowTime
                    end
                end
            end
        end
    end)
end

local function SetupCharacterHooks(char)
    table.insert(ScriptConnections, char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then task.wait(0.2); ApplyFastSlashConfig() end
    end))
end
table.insert(ScriptConnections, LocalPlayer.CharacterAdded:Connect(SetupCharacterHooks))
if LocalPlayer.Character then SetupCharacterHooks(LocalPlayer.Character) end

local function AttackAllTargetsOnce(EquippedTool)
    pcall(function()
        local MyCharacter = LocalPlayer.Character
        if not MyCharacter or not MyCharacter:FindFirstChild("HumanoidRootPart") then return end
        local enemiesTable = {}
        for _, OtherPlayer in ipairs(Players:GetPlayers()) do
            if OtherPlayer ~= LocalPlayer and isAlive(OtherPlayer) then
                local TargetRoot = OtherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if TargetRoot then
                    table.insert(enemiesTable, {
                        knockback = 50, isClosestEnemy = true, origin = MyCharacter.HumanoidRootPart.Position,
                        enemyModel = OtherPlayer.Character, distance = 5,
                        direction = (TargetRoot.Position - MyCharacter.HumanoidRootPart.Position).Unit
                    })
                end
            end
        end
        if #enemiesTable == 0 then return end
        local c_speed = FastSlashEnabled and SlashSpeedValue or 0.65
        local c_slowMult = FastSlashEnabled and 1 or 0.2
        local c_slowTime = FastSlashEnabled and 0 or 1.5
        local AttackArgs = {
            "AttemptWeaponHit",
            {
                attackCycleData = {knockbackMul = 1, slowMult = c_slowMult, attackTime = c_speed, lungeMul = 1, slowTime = c_slowTime},
                knockback = 50, shouldLock = true, shouldLunge = true,
                hitboxOffset = Vector3.new(0, 0, -1.5), isCritical = false, shouldSlow = not FastSlashEnabled,
                attackCooldown = 0.05, damage = 100, lungeKnockback = 55, cycleIndex = 1, slowMult = c_slowMult,
                hitboxSize = Vector3.new(9, 14, 8),
                weaponDefinition = {
                    attackCycle = {
                        ["1"] = {knockbackMul = 1, slowMult = c_slowMult, attackTime = c_speed, lungeMul = 1, slowTime = c_slowTime},
                        ["4"] = {lungeMult = 2.25, attackTime = c_speed, slowMult = c_slowMult, hitboxOffsetAdd = Vector3.new(0, 0, -1.5), hitboxSizeAdd = Vector3.new(0, 0, 3), knockbackMult = 2.25, slowTime = c_slowTime},
                        ["3"] = {lungeMult = 0.75, slowMult = c_slowMult, attackTime = c_speed, knockbackMult = 1.5, slowTime = c_slowTime},
                        ["2"] = {lungeMult = 1, slowMult = c_slowMult, attackTime = c_speed, knockbackMult = 1, slowTime = c_slowTime}
                    },
                    attackOrder = {"1", "2", "3", "4"}
                },
                tool = EquippedTool, slowTime = c_slowTime
            },
            enemiesTable
        }
        task.spawn(function() pcall(function() GameRemoteFunction:InvokeServer(unpack(AttackArgs)) end) end)
    end)
end

local function AttackSingleTarget(TargetName)
    local TargetPlayer = Players:FindFirstChild(TargetName)
    if not TargetPlayer or not isAlive(TargetPlayer) then
        Rayfield:Notify({Title = "Manual Kill", Content = "Target is dead or left.", Duration = 3})
        return
    end
    local MyCharacter = LocalPlayer.Character
    if not MyCharacter or not MyCharacter:FindFirstChild("HumanoidRootPart") then return end
    local CurrentTool = MyCharacter:FindFirstChildOfClass("Tool")
    if not CurrentTool then
        local BackpackTool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if BackpackTool and MyCharacter:FindFirstChild("Humanoid") then
            MyCharacter.Humanoid:EquipTool(BackpackTool)
            CurrentTool = BackpackTool
        else
            Rayfield:Notify({Title = "Manual Kill", Content = "No weapon equipped!", Duration = 3})
            return
        end
    end
    local TargetRoot = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not TargetRoot then return end
    local enemiesTable = {{
        knockback = 50, isClosestEnemy = true, origin = MyCharacter.HumanoidRootPart.Position,
        enemyModel = TargetPlayer.Character, distance = 5,
        direction = (TargetRoot.Position - MyCharacter.HumanoidRootPart.Position).Unit
    }}
    local c_speed = FastSlashEnabled and SlashSpeedValue or 0.65
    local c_slowMult = FastSlashEnabled and 1 or 0.2
    local c_slowTime = FastSlashEnabled and 0 or 1.5
    local AttackArgs = {
        "AttemptWeaponHit",
        {
            attackCycleData = {knockbackMul = 1, slowMult = c_slowMult, attackTime = c_speed, lungeMul = 1, slowTime = c_slowTime},
            knockback = 50, shouldLock = true, shouldLunge = true,
            hitboxOffset = Vector3.new(0, 0, -1.5), isCritical = false, shouldSlow = not FastSlashEnabled,
            attackCooldown = 0.05, damage = 100, lungeKnockback = 55, cycleIndex = 1, slowMult = c_slowMult,
            hitboxSize = Vector3.new(9, 14, 8),
            weaponDefinition = {
                attackCycle = {
                    ["1"] = {knockbackMul = 1, slowMult = c_slowMult, attackTime = c_speed, lungeMul = 1, slowTime = c_slowTime},
                    ["4"] = {lungeMult = 2.25, attackTime = c_speed, slowMult = c_slowMult, hitboxOffsetAdd = Vector3.new(0, 0, -1.5), hitboxSizeAdd = Vector3.new(0, 0, 3), knockbackMult = 2.25, slowTime = c_slowTime},
                    ["3"] = {lungeMult = 0.75, slowMult = c_slowMult, attackTime = c_speed, knockbackMult = 1.5, slowTime = c_slowTime},
                    ["2"] = {lungeMult = 1, slowMult = c_slowMult, attackTime = c_speed, knockbackMult = 1, slowTime = c_slowTime}
                },
                attackOrder = {"1", "2", "3", "4"}
            },
            tool = CurrentTool, slowTime = c_slowTime
        },
        enemiesTable
    }
    task.spawn(function() pcall(function() GameRemoteFunction:InvokeServer(unpack(AttackArgs)) end) end)
    Rayfield:Notify({Title = "Manual Kill", Content = "Attempted kill on " .. TargetName, Duration = 2})
end

local function ClearESP()
    for _, conn in ipairs(ESPConnections) do
        if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    table.clear(ESPConnections)
    for part, states in pairs(OriginalStates) do
        if part and part.Parent then
            pcall(function()
                part.Transparency = states.Transparency
                if states.LocalTransparencyModifier then
                    part.LocalTransparencyModifier = states.LocalTransparencyModifier
                end
            end)
        end
    end
    table.clear(OriginalStates)
end

local function SetupPartESP(part)
    if part:IsA("BasePart") then
        if bodyParts[part.Name] or (part.Parent and part.Parent:IsA("Accessory")) then
            if not OriginalStates[part] then
                OriginalStates[part] = { Transparency = part.Transparency, LocalTransparencyModifier = part.LocalTransparencyModifier }
            end
            if part.Transparency > 0 then part.Transparency = 0 end
            if part.LocalTransparencyModifier > 0 then part.LocalTransparencyModifier = 0 end
            table.insert(ESPConnections, part:GetPropertyChangedSignal("Transparency"):Connect(function()
                if part.Transparency > 0 then part.Transparency = 0 end
            end))
            table.insert(ESPConnections, part:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
                if part.LocalTransparencyModifier > 0 then part.LocalTransparencyModifier = 0 end
            end))
        end
    elseif part:IsA("Decal") then
        if not OriginalStates[part] then OriginalStates[part] = { Transparency = part.Transparency } end
        if part.Transparency > 0 then part.Transparency = 0 end
        table.insert(ESPConnections, part:GetPropertyChangedSignal("Transparency"):Connect(function()
            if part.Transparency > 0 then part.Transparency = 0 end
        end))
    end
end

local function SetupCharESP(char)
    for _, part in ipairs(char:GetDescendants()) do SetupPartESP(part) end
    table.insert(ESPConnections, char.DescendantAdded:Connect(SetupPartESP))
end

local function ApplyChams(player)
    if player == LocalPlayer or not ChamsEnabled then return end
    local char = player.Character
    if not char then return end
    local isFriend = false
    pcall(function() isFriend = LocalPlayer:IsFriendsWith(player.UserId) end)
    if not ChamsCache[player] then ChamsCache[player] = {} end
    if not ChamsCache[player].Highlight or not ChamsCache[player].Highlight.Parent then
        local hl = Instance.new("Highlight")
        hl.Name = "PlayerCham"
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineTransparency = 0.1
        hl.FillTransparency = 0.65
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        if isFriend then
            hl.FillColor = Color3.fromRGB(50, 220, 50)
        else
            hl.FillColor = Color3.fromRGB(200, 50, 50)
        end
        pcall(function()
            local coreGui = game:GetService("CoreGui")
            if coreGui then hl.Parent = coreGui else hl.Parent = char end
        end)
        if not hl.Parent then hl.Parent = char end
        ChamsCache[player].Highlight = hl
    end
    ChamsCache[player].Highlight.Adornee = char
    if isFriend then
        local head = char:FindFirstChild("Head")
        if head then
            if not ChamsCache[player].Billboard or not ChamsCache[player].Billboard.Parent then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "FriendTag"
                billboard.Size = UDim2.new(5, 0, 1.2, 0) 
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.AlwaysOnTop = true
                local txt = Instance.new("TextLabel")
                txt.Parent = billboard
                txt.BackgroundTransparency = 1
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.Text = "Your Friend"
                txt.TextColor3 = Color3.fromRGB(50, 255, 50)
                txt.TextStrokeTransparency = 0
                txt.TextStrokeColor3 = Color3.new(0,0,0)
                txt.TextScaled = true 
                txt.Font = Enum.Font.GothamBold
                pcall(function()
                    local coreGui = game:GetService("CoreGui")
                    if coreGui then billboard.Parent = coreGui else billboard.Parent = char end
                end)
                if not billboard.Parent then billboard.Parent = char end
                ChamsCache[player].Billboard = billboard
            end
            ChamsCache[player].Billboard.Adornee = head
        end
    else
        if ChamsCache[player].Billboard then
            ChamsCache[player].Billboard:Destroy()
            ChamsCache[player].Billboard = nil
        end
    end
end

local function ClearChams()
    for player, cache in pairs(ChamsCache) do
        if cache.Highlight then cache.Highlight:Destroy() end
        if cache.Billboard then cache.Billboard:Destroy() end
    end
    table.clear(ChamsCache)
end

local function UnloadScript()
    Unloaded = true
    ClearESP()
    ClearChams()
    if _G.AntiAfkConn then
        _G.AntiAfkConn:Disconnect()
        _G.AntiAfkConn = nil
    end
    if AntiStaffConnection then
        AntiStaffConnection:Disconnect()
        AntiStaffConnection = nil
    end
    for _, conn in ipairs(ScriptConnections) do
        if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    table.clear(ScriptConnections)
    pcall(function()
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = 16 end
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end)
    Rayfield:Destroy()
end

task.spawn(function()
    while task.wait(0.1) do
        if Unloaded then break end
        if ChamsEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    ApplyChams(player)
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and bodyParts[part.Name] then
                            if part.Transparency == 1 then
                                 part.Transparency = 0.95
                            end
                            if part.LocalTransparencyModifier == 1 then
                                part.LocalTransparencyModifier = 0.95
                            end
                        end
                    end
                 end
            end
        end
    end
end)

local function ToggleChams(state)
    ChamsEnabled = state
    if not state then
        ClearChams()
    end
end

local function InitBypasses()
    if BypassInitialized then return end
    BypassInitialized = true
    task.spawn(function()
        pcall(function()
            local JumpControllerPath = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ClientGameHandler"):WaitForChild("ClientCharacterHandler"):WaitForChild("JumpController")
            local success1, JumpController = pcall(require, JumpControllerPath)
            if success1 and type(JumpController) == "table" then
                if JumpController.spawnJumpAttachment then
                    local old1 = JumpController.spawnJumpAttachment
                    JumpController.spawnJumpAttachment = function(...)
                        if Unloaded or not HideJumpDustEnabled then return old1(...) end
                    end
                end
                if JumpController.onJump then
                    local old2 = JumpController.onJump
                    JumpController.onJump = function(...)
                        if Unloaded or not HideJumpDustEnabled then return old2(...) end
                    end
                end
            end
            
            local controllerPath = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ClientGameHandler"):WaitForChild("ClientCharacterHandler"):WaitForChild("FootstepController")
            local success2, FootstepController = pcall(require, controllerPath)
            if success2 and type(FootstepController) == "table" and FootstepController.spawnFootstep then
                local old3 = FootstepController.spawnFootstep
                FootstepController.spawnFootstep = function(...)
                    if Unloaded or not HideFootstepEnabled then return old3(...) end
                end
            end
            
            local ClientRoundPath = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ClientGameHandler"):WaitForChild("ClientRound")
            local success3, ClientRoundModule = pcall(require, ClientRoundPath)
            if success3 and type(ClientRoundModule) == "table" then
                local oldReveal = ClientRoundModule.revealPlayer
                if oldReveal then
                    ClientRoundModule.revealPlayer = function(self, player, ...)
                        if Unloaded or not InvisibleSlashingEnabled then return oldReveal(self, player, ...) end
                        if player == LocalPlayer then return end
                        return oldReveal(self, player, ...)
                    end
                end
                local oldSetTrans = ClientRoundModule._setPlrTransparency
                if oldSetTrans then
                    ClientRoundModule._setPlrTransparency = function(self, player, transparency, info)
                        if Unloaded or not InvisibleSlashingEnabled then return oldSetTrans(self, player, transparency, info) end
                        if player == LocalPlayer then return oldSetTrans(self, player, 0.999, info) end
                        return oldSetTrans(self, player, transparency, info)
                    end
                end
                local oldInitPlaying = ClientRoundModule._initPlaying
                if oldInitPlaying then
                    ClientRoundModule._initPlaying = function(self, ...)
                        local res = oldInitPlaying(self, ...)
                        if not Unloaded and InvisibleSlashingEnabled then
                            task.spawn(function() if self.hitRevealCon then self.hitRevealCon:Disconnect(); self.hitRevealCon = nil end end)
                        end
                        return res
                    end
                end
            end
            
            local GameRemote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("GameRemoteEvent")
            local oldFireServer
            oldFireServer = hookmetamethod(game, "__namecall", function(self, ...)
                if Unloaded then return oldFireServer(self, ...) end
                local args = {...}
                local method = getnamecallmethod()
                if self == GameRemote and method == "FireServer" and args[1] == "ReplicationEvent" and args[2] == "RevealPlayerEvent" and args[3] == LocalPlayer then
                    if InvisibleSlashingEnabled then return nil end
                end
                return oldFireServer(self, ...)
            end)
        end)
    end)
end

local MainTab = Window:CreateTab("Main", "home")
MainTab:CreateSection("ESP & Visuals")

UIRefs.ShowAllPlayerToggle = MainTab:CreateToggle({
    Name = "Show All Players", CurrentValue = false, Flag = "ShowAllPlayerToggle",
    Callback = function(Value)
        ClearESP()
        if Value then
            local function onPlayerAdded(player)
                if player == LocalPlayer then return end
                if player.Character then SetupCharESP(player.Character) end
                table.insert(ESPConnections, player.CharacterAdded:Connect(SetupCharESP))
            end
            for _, player in ipairs(Players:GetPlayers()) do onPlayerAdded(player) end
            table.insert(ESPConnections, Players.PlayerAdded:Connect(onPlayerAdded))
        end
    end,
})

UIRefs.ChamsToggle = MainTab:CreateToggle({
    Name = "Chams", CurrentValue = false, Flag = "ChamsToggle",
    Callback = function(Value)
        ToggleChams(Value)
    end,
})

MainTab:CreateSection("Combat Enhancement")

UIRefs.FastSlashToggle = MainTab:CreateToggle({
    Name = "Fast Slash", CurrentValue = false, Flag = "FastSlashToggle",
    Callback = function(Value) FastSlashEnabled = Value; ApplyFastSlashConfig() end,
})

UIRefs.SlashSpeedSlider = MainTab:CreateSlider({
    Name = "Slash Speed", Range = {0, 1}, Increment = 0.01, CurrentValue = 0.2, Flag = "SlashSpeedSlider",
    Callback = function(Value) SlashSpeedValue = Value; if FastSlashEnabled then ApplyFastSlashConfig() end end,
})

UIRefs.AimlockToggle = MainTab:CreateToggle({
    Name = "Aimlock Player", CurrentValue = false, Flag = "AimlockToggle",
    Callback = function(Value) AimlockEnabled = Value end,
})

UIRefs.AimSmoothSlider = MainTab:CreateSlider({
    Name = "Aimlock Smoothness", Range = {0.1, 1}, Increment = 0.1, CurrentValue = 0.6, Flag = "AimSmoothSlider",
    Callback = function(Value) AimConfig.Smoothness = Value end,
})

MainTab:CreateSection("Detection Bypass")
InitBypasses()

UIRefs.HideFootstepToggle = MainTab:CreateToggle({
    Name = "Hide Footstep", CurrentValue = false, Flag = "HideFootstepToggle",
    Callback = function(Value) HideFootstepEnabled = Value end,
})

UIRefs.HideJumpDustToggle = MainTab:CreateToggle({
    Name = "Hide Jump Dust", CurrentValue = false, Flag = "HideJumpDustToggle",
    Callback = function(Value) HideJumpDustEnabled = Value end,
})

UIRefs.InvisibleSlashingToggle = MainTab:CreateToggle({
    Name = "Invisible While Slashing", CurrentValue = false, Flag = "InvisibleSlashingToggle",
    Callback = function(Value) InvisibleSlashingEnabled = Value end,
})

local AutoFarmTab = Window:CreateTab("Auto Farm", "repeat")
AutoFarmTab:CreateSection("OP Feature")

UIRefs.AutoAttackAllToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Kill All (Instant Kill)", CurrentValue = false, Flag = "AutoAttackAllToggle",
    Callback = function(Value) AutoAttackAllEnabled = Value end,
})

local SelectedManualPlayer = ""
local function GetServerPlayerNames()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    if #list == 0 then table.insert(list, "No Players") end
    return list
end

local PlayerDropdown = AutoFarmTab:CreateDropdown({
    Name = "Select Player", Options = GetServerPlayerNames(), CurrentOption = {""}, MultipleOptions = false, Flag = "TargetDropdown",
    Callback = function(Option) SelectedManualPlayer = Option[1] end,
})

table.insert(ScriptConnections, Players.PlayerAdded:Connect(function() PlayerDropdown:Refresh(GetServerPlayerNames()) end))
table.insert(ScriptConnections, Players.PlayerRemoving:Connect(function() PlayerDropdown:Refresh(GetServerPlayerNames()) end))

AutoFarmTab:CreateButton({
    Name = "Manual Kill",
    Callback = function()
        if SelectedManualPlayer and SelectedManualPlayer ~= "" and SelectedManualPlayer ~= "No Players" then
            AttackSingleTarget(SelectedManualPlayer)
        else
            Rayfield:Notify({Title = "Error", Content = "Invalid player selected.", Duration = 3})
        end
    end,
})

AutoFarmTab:CreateSection("Kill/Yen Multiplier")

UIRefs.SpamSpeedToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Dupe Kill/Yen (OP)", 
    CurrentValue = false, 
    Flag = "SpamSpeedToggle",
    Callback = function(Value)
        SpamSpeedEnabled = Value
    end,
})

UIRefs.DupeMultiplierDropdown = AutoFarmTab:CreateDropdown({
    Name = "Choose the multiplier",
    Options = {"1000x", "2000x", "4000x", "6000x", "8000x", "10000x"},
    CurrentOption = {"1000x"},
    MultipleOptions = false,
    Flag = "DupeMultiplierDropdown",
    Callback = function(Option)
        local val = string.gsub(Option[1], "x", "")
        DupeMultiplier = tonumber(val) or 1000
    end,
})

AutoFarmTab:CreateParagraph({
    Title = "Note",
    Content = "Choose a higher multiplier to make Kill All slower, but in return you'll gain HUGE amount of kills/yen"
})

AutoFarmTab:CreateSection("AutoFarm settings (Default)")

UIRefs.AutoServerHopToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Server Hop", CurrentValue = false, Flag = "AutoServerHopToggle",
    Callback = function(Value) AutoHopEnabled = Value end,
})

UIRefs.HopLeaveSlider = AutoFarmTab:CreateSlider({
    Name = "Hop When Players ≤", Range = {1, 7}, Increment = 1, CurrentValue = 3, Flag = "HopLeaveSlider",
    Callback = function(Value) HopLeaveCount = Value end,
})

UIRefs.HopJoinSlider = AutoFarmTab:CreateSlider({
    Name = "Join Above Players ≥", Range = {1, 7}, Increment = 1, CurrentValue = 6, Flag = "HopJoinSlider",
    Callback = function(Value) HopJoinCount = Value end,
})

AutoFarmTab:CreateParagraph({
    Title = "How to use (read carefully)",
    Content = "1. Purpose: This feature allows you to automatically kill everyone, then hop to a new server to continue farming.\n2. Steps:\n• Turn on Auto Kill All first.\n• Go to Config tab, type a name in \"Config Name\" and click Create/Overwrite.\n• Select that name in the \"Config List\", then click Set Current as Autoload.\n• Now you can enable Auto Server Hop.\n• Finally press 'Overwrite config' to save all the settings and features you enabled.\nNote: Make sure your executor is set to Auto-Execute script."
})

local WeaponsTab = Window:CreateTab("Weapons", "sword")
WeaponsTab:CreateSection("Weapon Automation")

UIRefs.AutoChest = WeaponsTab:CreateToggle({
    Name = "Auto Open Chest", CurrentValue = false, Flag = "AutoChest",
    Callback = function(Value) AutoChestEnabled = Value end,
})

UIRefs.ChestMultiplierSlider = WeaponsTab:CreateSlider({
    Name = "Chest Open Multiplier", Range = {1, 100}, Increment = 1, CurrentValue = 5, Flag = "ChestMultiplierSlider",
    Callback = function(Value) ChestMultiplier = Value end,
})

UIRefs.ChestType = WeaponsTab:CreateDropdown({
    Name = "Select Chest Type", Options = {"Basic", "Divine"}, CurrentOption = {"Basic"}, MultipleOptions = false, Flag = "ChestType",
    Callback = function(Option) SelectedChest = Option[1] end,
})

UIRefs.AutoEquipBest = WeaponsTab:CreateToggle({
    Name = "Auto Equip Best Weapon", CurrentValue = false, Flag = "AutoEquipBest",
    Callback = function(Value) AutoEquipEnabled = Value end,
})

local CharacterTab = Window:CreateTab("Character", "user")
CharacterTab:CreateSection("Movement")

UIRefs.EnableWalkSpeed = CharacterTab:CreateToggle({
    Name = "Enable WalkSpeed", CurrentValue = false, Flag = "EnableWalkSpeed",
    Callback = function(Value)
        WalkSpeedEnabled = Value
        if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end,
})

UIRefs.WalkSpeedSlider = CharacterTab:CreateSlider({
    Name = "WalkSpeed Amount", Range = {16, 50}, Increment = 1, CurrentValue = 16, Flag = "WalkSpeedSlider",
    Callback = function(Value) WalkSpeedValue = Value end,
})

UIRefs.InfJumpToggle = CharacterTab:CreateToggle({
    Name = "Infinite Jump", CurrentValue = false, Flag = "InfJumpToggle",
    Callback = function(Value) InfJumpEnabled = Value end,
})

UIRefs.NoclipToggle = CharacterTab:CreateToggle({
    Name = "Noclip", CurrentValue = false, Flag = "NoclipToggle",
    Callback = function(Value)
        NoclipEnabled = Value
        if not Value and LocalPlayer.Character then
            for _, partName in ipairs({"Torso", "UpperTorso", "LowerTorso", "Head"}) do
                local part = LocalPlayer.Character:FindFirstChild(partName)
                if part then part.CanCollide = true end
            end
        end
    end,
})

CharacterTab:CreateSection("Protect yourself")

UIRefs.AntiFlingToggle = CharacterTab:CreateToggle({
    Name = "Anti-Fling", CurrentValue = true, Flag = "AntiFlingToggle",
    Callback = function(Value) AntiFlingEnabled = Value end,
})

local AntiStaffConnection = nil

UIRefs.AntiStaffToggle = CharacterTab:CreateToggle({
    Name = "Anti-Staff", CurrentValue = true, Flag = "AntiStaffToggle",
    Callback = function(Value)
        AntiStaffEnabled = Value
        if Value then
            task.spawn(CheckAndHopFromStaff)
            if not AntiStaffConnection then
                AntiStaffConnection = Players.PlayerAdded:Connect(function(p)
                    if AntiStaffEnabled and p.UserId == STAFF_USER_ID then
                        Rayfield:Notify({ Title = "Anti Staff", Content = "Staff detected! Hopping to random server...", Duration = 3, Image = 4483362458 })
                        task.wait(0.3)
                        HopToRandomServer()
                    end
                end)
            end
        else
            if AntiStaffConnection then
                AntiStaffConnection:Disconnect()
                AntiStaffConnection = nil
            end
        end
    end,
})

CharacterTab:CreateSection("Server")

UIRefs.AntiAfk = CharacterTab:CreateToggle({
    Name = "Anti-AFK", CurrentValue = true, Flag = "AntiAfk",
    Callback = function(Value)
        if Value then
            if not _G.AntiAfkConn then
                _G.AntiAfkConn = LocalPlayer.Idled:Connect(function()
                    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
                    task.wait(1)
                    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
                end)
            end
        else
            if _G.AntiAfkConn then
                _G.AntiAfkConn:Disconnect()
                _G.AntiAfkConn = nil
            end
        end
    end,
})

CharacterTab:CreateButton({ Name = "Rejoin Server", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end })
CharacterTab:CreateButton({ Name = "Server Hop", Callback = function() HopToServer(TargetPlayerCount) end })
CharacterTab:CreateSlider({ Name = "Limit Configuration", Range = {1, 7}, Increment = 1, CurrentValue = 5, Flag = "HopTargetSlider", Callback = function(Value) TargetPlayerCount = Value end })
CharacterTab:CreateInput({ Name = "Join Jobid", PlaceholderText = "Paste Jobid Here...", RemoveTextAfterFocusLost = false, Callback = function(Text) if Text and Text ~= "" then pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, Text, LocalPlayer) end) end end })

if not _G.AntiAfkConn then
    _G.AntiAfkConn = LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end)
end

AntiStaffConnection = Players.PlayerAdded:Connect(function(p)
    if AntiStaffEnabled and p.UserId == STAFF_USER_ID then
        Rayfield:Notify({ Title = "Anti Staff", Content = "Staff detected! Hopping to random server...", Duration = 3, Image = 4483362458 })
        task.wait(0.3)
        HopToRandomServer()
    end
end)

task.spawn(function()
    task.wait(1.5)
    if AntiStaffEnabled then
        CheckAndHopFromStaff()
    end
end)

table.insert(ScriptConnections, RunService.Stepped:Connect(function()
    if Unloaded then return end
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end
    if AntiFlingEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root and (root.AssemblyAngularVelocity.Magnitude > 50 or root.AssemblyLinearVelocity.Magnitude > 100) then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end
    end
end))

table.insert(ScriptConnections, RunService.Heartbeat:Connect(function()
    if Unloaded then return end
    pcall(function()
        if WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
        end
    end)
    if AntiFlingEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                if root.AssemblyLinearVelocity.Magnitude > 250 or root.AssemblyAngularVelocity.Magnitude > 250 then
                    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    if lastSafePos then root.CFrame = lastSafePos end
                else lastSafePos = root.CFrame end
            end
        end)
    end
end))

local wasInLobby = true
table.insert(ScriptConnections, RunService.Heartbeat:Connect(function()
    if Unloaded then return end
    pcall(function()
        if not isAlive(LocalPlayer) then wasInLobby = true; return end
        if AutoAttackAllEnabled then
            local char = LocalPlayer.Character
            local currentLocation = GetCurrentLocation(char)
            if currentLocation == "Match" and wasInLobby then
                wasInLobby = false
                local humanoid = char:FindFirstChild("Humanoid")
                local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                if tool and humanoid then
                    humanoid:EquipTool(tool)
                    if SpamSpeedEnabled then
                        task.spawn(function()
                            task.wait(2.5) 
                            if isAlive(LocalPlayer) then
                                LocalPlayer.Character.Humanoid:UnequipTools()
                            end
                        end)
                    end
                end
            elseif currentLocation == "Lobby" and not wasInLobby then
                wasInLobby = true
            end
            if currentLocation == "Match" then
                local CurrentTool = char:FindFirstChildOfClass("Tool")
                if CurrentTool then
                    if SpamSpeedEnabled then
                        local remote = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("GameRemoteFunction")
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if remote and hrp then
                            local list = {}
                            for _, enemy in pairs(Players:GetPlayers()) do
                                if enemy ~= LocalPlayer and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                                    for i = 1, DupeMultiplier do 
                                        table.insert(list, {
                                            knockback = 146.25,
                                            isClosestEnemy = false,
                                            origin = Vector3.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z),
                                            enemyModel = enemy.Character,
                                            distance = 0,
                                            direction = Vector3.new(0,0,0)
                                        })
                                    end
                                end
                            end
                            if #list > 0 then
                                task.spawn(function()
                                    pcall(function()
                                        remote:InvokeServer("AttemptWeaponHit", {
                                            damage = 999999, 
                                            attackCooldown = 0, 
                                            cycleIndex = 4,
                                            tool = CurrentTool,
                                            hitboxSize = Vector3.new(999, 999, 999) 
                                        }, list)
                                    end)
                                end)
                            end
                        end
                    else
                        AttackAllTargetsOnce(CurrentTool)
                    end
                end
            end
        end
    end)
end))

task.spawn(function()
    local noEnemyTimer = 0
    while task.wait(1) do
        if Unloaded then break end
        pcall(function()
            if AutoAttackAllEnabled and isAlive(LocalPlayer) then
                local char = LocalPlayer.Character
                if GetCurrentLocation(char) == "Match" then
                    local anyoneVisible = false
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and isAlive(p) and IsVisible(p.Character) then
                            anyoneVisible = true
                            break
                        end
                    end
                    if not anyoneVisible then
                        noEnemyTimer = noEnemyTimer + 1
                        if noEnemyTimer >= 10 then
                            if char:FindFirstChild("Humanoid") then
                                char.Humanoid.Health = 0
                            end
                            noEnemyTimer = 0
                        end
                    else
                        noEnemyTimer = 0
                    end
                else
                    noEnemyTimer = 0
                end
            else
                noEnemyTimer = 0
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(5) do
        if Unloaded then break end
        if AutoHopEnabled then
            local currentPlayerCount = #Players:GetPlayers()
            if currentPlayerCount <= HopLeaveCount then
                HopToServerClosest(HopJoinCount)
                task.wait(10)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Unloaded then break end
        if AutoChestEnabled then
            for i = 1, ChestMultiplier do
                task.spawn(function()
                    pcall(function() ReplicatedStorage.Events.GameRemoteFunction:InvokeServer("AttemptRollGachaChest", SelectedChest) end)
                end)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1.5) do
        if Unloaded then break end
        if AutoEquipEnabled then
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if not playerGui then return end
                local armoryFrame = playerGui:FindFirstChild("MainGui") and playerGui.MainGui:FindFirstChild("MainFrame") and playerGui.MainGui.MainFrame:FindFirstChild("ArmoryFrame")
                if not armoryFrame then return end
                local scrollFrame = armoryFrame.Container.Bottom.WeaponContainer.ScrollingFrame
                local equipBtn = armoryFrame.Container.Bottom.EquipContainer.ButtonContainer.EquipButton
                for i = #WeaponRanks, 1, -1 do
                    local weaponName = WeaponRanks[i]
                    local weaponUI = scrollFrame:FindFirstChild(weaponName)
                    if weaponUI then
                        if LastEquippedWeapon == weaponName and equipBtn.Text:upper() == "EQUIPPED" then break end
                        local btn = weaponUI:IsA("GuiButton") and weaponUI or weaponUI:FindFirstChildWhichIsA("GuiButton", true)
                        if btn and getconnections then
                            for _, c in ipairs(getconnections(btn.MouseButton1Click)) do c:Fire() end
                            task.wait(0.15)
                            if equipBtn.Text:upper() == "EQUIPPED" then LastEquippedWeapon = weaponName; break
                            elseif equipBtn.Text:upper() == "EQUIP" then
                                for _, c in ipairs(getconnections(equipBtn.MouseButton1Click)) do c:Fire() end
                                LastEquippedWeapon = weaponName; break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

table.insert(ScriptConnections, RunService.RenderStepped:Connect(function()
    if Unloaded then return end
    pcall(function()
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if AimlockEnabled and myRoot and isAlive(LocalPlayer) and myChar:FindFirstChildOfClass("Tool") then
            local target = GetNearestTarget()
            if target and target.Character and target.Character:FindFirstChild(AimConfig.AimPart) then
                local tPos = target.Character[AimConfig.AimPart].Position
                myRoot.CFrame = myRoot.CFrame:Lerp(CFrame.lookAt(myRoot.Position, Vector3.new(tPos.X, myRoot.Position.Y, tPos.Z)), AimConfig.Smoothness)
            end
        end
    end)
end))

table.insert(ScriptConnections, UserInputService.JumpRequest:Connect(function()
    if Unloaded then return end
    pcall(function() if InfJumpEnabled and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)
end))

local ConfigTab = Window:CreateTab("Config", "settings")

local CONFIG_FOLDER = "SilentAssassins"
local CONFIGS_FOLDER = "SilentAssassins/Configs"
local AUTOLOAD_FILE = "SilentAssassins/autoload.txt"

pcall(function() if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end end)
pcall(function() if not isfolder(CONFIGS_FOLDER) then makefolder(CONFIGS_FOLDER) end end)

local FlagDefs = {
    { key = "ShowAllPlayerToggle", setUI = function(v) pcall(function() UIRefs.ShowAllPlayerToggle:Set(v == true or v == "true") end) end, applyVar = function(v) end },
    { key = "ChamsToggle", setUI = function(v) pcall(function() UIRefs.ChamsToggle:Set(v == true or v == "true") end) end, applyVar = function(v) ToggleChams(v == true or v == "true") end },
    { key = "FastSlashToggle", setUI = function(v) pcall(function() UIRefs.FastSlashToggle:Set(v == true or v == "true") end) end, applyVar = function(v) FastSlashEnabled = (v == true or v == "true"); ApplyFastSlashConfig() end },
    { key = "SlashSpeedSlider", setUI = function(v) pcall(function() UIRefs.SlashSpeedSlider:Set(tonumber(v) or v) end) end, applyVar = function(v) SlashSpeedValue = tonumber(v) or v; if FastSlashEnabled then ApplyFastSlashConfig() end end },
    { key = "AimlockToggle", setUI = function(v) pcall(function() UIRefs.AimlockToggle:Set(v == true or v == "true") end) end, applyVar = function(v) AimlockEnabled = (v == true or v == "true") end },
    { key = "AimSmoothSlider", setUI = function(v) pcall(function() UIRefs.AimSmoothSlider:Set(tonumber(v) or v) end) end, applyVar = function(v) AimConfig.Smoothness = tonumber(v) or v end },
    { key = "HideFootstepToggle", setUI = function(v) pcall(function() UIRefs.HideFootstepToggle:Set(v == true or v == "true") end) end, applyVar = function(v) HideFootstepEnabled = (v == true or v == "true") end },
    { key = "HideJumpDustToggle", setUI = function(v) pcall(function() UIRefs.HideJumpDustToggle:Set(v == true or v == "true") end) end, applyVar = function(v) HideJumpDustEnabled = (v == true or v == "true") end },
    { key = "InvisibleSlashingToggle", setUI = function(v) pcall(function() UIRefs.InvisibleSlashingToggle:Set(v == true or v == "true") end) end, applyVar = function(v) InvisibleSlashingEnabled = (v == true or v == "true") end },
    { key = "AutoAttackAllToggle", setUI = function(v) pcall(function() UIRefs.AutoAttackAllToggle:Set(v == true or v == "true") end) end, applyVar = function(v) AutoAttackAllEnabled = (v == true or v == "true") end },
    { key = "SpamSpeedToggle", setUI = function(v) pcall(function() UIRefs.SpamSpeedToggle:Set(v == true or v == "true") end) end, applyVar = function(v) SpamSpeedEnabled = (v == true or v == "true") end },
    { key = "DupeMultiplierDropdown", setUI = function(v) pcall(function() UIRefs.DupeMultiplierDropdown:Set({tostring(v)}) end) end, applyVar = function(v) local val = string.gsub(tostring(v), "x", ""); DupeMultiplier = tonumber(val) or 1000 end },
    { key = "AutoServerHopToggle", setUI = function(v) pcall(function() UIRefs.AutoServerHopToggle:Set(v == true or v == "true") end) end, applyVar = function(v) AutoHopEnabled = (v == true or v == "true") end },
    { key = "HopLeaveSlider", setUI = function(v) pcall(function() UIRefs.HopLeaveSlider:Set(tonumber(v) or v) end) end, applyVar = function(v) HopLeaveCount = tonumber(v) or v end },
    { key = "HopJoinSlider", setUI = function(v) pcall(function() UIRefs.HopJoinSlider:Set(tonumber(v) or v) end) end, applyVar = function(v) HopJoinCount = tonumber(v) or v end },
    { key = "AutoChest", setUI = function(v) pcall(function() UIRefs.AutoChest:Set(v == true or v == "true") end) end, applyVar = function(v) AutoChestEnabled = (v == true or v == "true") end },
    { key = "ChestMultiplierSlider", setUI = function(v) pcall(function() UIRefs.ChestMultiplierSlider:Set(tonumber(v) or v) end) end, applyVar = function(v) ChestMultiplier = tonumber(v) or v end },
    { key = "ChestType", setUI = function(v) pcall(function() UIRefs.ChestType:Set({tostring(v)}) end) end, applyVar = function(v) SelectedChest = tostring(v) end },
    { key = "AutoEquipBest", setUI = function(v) pcall(function() UIRefs.AutoEquipBest:Set(v == true or v == "true") end) end, applyVar = function(v) AutoEquipEnabled = (v == true or v == "true") end },
    { key = "EnableWalkSpeed", setUI = function(v) pcall(function() UIRefs.EnableWalkSpeed:Set(v == true or v == "true") end) end, applyVar = function(v) WalkSpeedEnabled = (v == true or v == "true") end },
    { key = "WalkSpeedSlider", setUI = function(v) pcall(function() UIRefs.WalkSpeedSlider:Set(tonumber(v) or v) end) end, applyVar = function(v) WalkSpeedValue = tonumber(v) or v end },
    { key = "InfJumpToggle", setUI = function(v) pcall(function() UIRefs.InfJumpToggle:Set(v == true or v == "true") end) end, applyVar = function(v) InfJumpEnabled = (v == true or v == "true") end },
    { key = "NoclipToggle", setUI = function(v) pcall(function() UIRefs.NoclipToggle:Set(v == true or v == "true") end) end, applyVar = function(v) NoclipEnabled = (v == true or v == "true") end },
    { key = "AntiFlingToggle", setUI = function(v) pcall(function() UIRefs.AntiFlingToggle:Set(v == true or v == "true") end) end, applyVar = function(v) AntiFlingEnabled = (v == true or v == "true") end },
    { key = "AntiStaffToggle", setUI = function(v) pcall(function() UIRefs.AntiStaffToggle:Set(v == true or v == "true") end) end, applyVar = function(v) AntiStaffEnabled = (v == true or v == "true") end },
    { key = "AntiAfk", setUI = function(v) pcall(function() UIRefs.AntiAfk:Set(v == true or v == "true") end) end, applyVar = function(v) end },
}

local function GetConfigList()
    local list = {}
    pcall(function()
        for _, f in ipairs(listfiles(CONFIGS_FOLDER)) do
            local name = f:match("([^/\\]+)%.json$")
            if name then table.insert(list, name) end
        end
    end)
    if #list == 0 then table.insert(list, "None") end
    return list
end

local function SaveConfig(name)
    local data = {}
    for _, def in ipairs(FlagDefs) do
        pcall(function()
            local ref = UIRefs[def.key]
            if ref then
                if ref.CurrentValue ~= nil then
                    data[def.key] = ref.CurrentValue
                elseif ref.CurrentOption ~= nil then
                    data[def.key] = ref.CurrentOption[1]
                end
            end
        end)
    end
    pcall(function()
        writefile(CONFIGS_FOLDER .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
end

local function LoadConfig(name)
    local ok, content = pcall(function() return readfile(CONFIGS_FOLDER .. "/" .. name .. ".json") end)
    if not ok or not content or content == "" then
        Rayfield:Notify({ Title = "Config", Content = "Config not found: " .. tostring(name), Duration = 3 })
        return false
    end
    local decodeOk, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not decodeOk or type(data) ~= "table" then
        Rayfield:Notify({ Title = "Config", Content = "Failed to parse config.", Duration = 3 })
        return false
    end
    for _, def in ipairs(FlagDefs) do
        local v = data[def.key]
        if v ~= nil then
            pcall(def.applyVar, v)
            task.defer(function() def.setUI(v) end)
        end
    end
    Rayfield:Notify({ Title = "Config", Content = "Loaded: " .. name, Duration = 3 })
    return true
end

local SelectedConfigName = ""
local ConfigNameInputValue = ""

ConfigTab:CreateSection("Config List")

local ConfigListDropdown = ConfigTab:CreateDropdown({
    Name = "Config List",
    Options = GetConfigList(),
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "ConfigListDropdown",
    Callback = function(Option)
        local picked = Option[1]
        SelectedConfigName = (picked ~= "None" and picked ~= "") and picked or ""
    end,
})

ConfigTab:CreateInput({
    Name = "Config Name",
    PlaceholderText = "Enter name...",
    RemoveTextAfterFocusLost = false,
    Flag = "ConfigNameInput",
    Callback = function(Text) ConfigNameInputValue = Text or "" end,
})

ConfigTab:CreateButton({
    Name = "Create / Overwrite Config",
    Callback = function()
        local name = ConfigNameInputValue
        if name == "" then name = SelectedConfigName end
        if name == "" then
            Rayfield:Notify({ Title = "Config", Content = "Enter a config name or select one from the list.", Duration = 3 })
            return
        end
        SaveConfig(name)
        task.wait(0.1)
        ConfigListDropdown:Refresh(GetConfigList())
        Rayfield:Notify({ Title = "Config", Content = "Saved: " .. name, Duration = 3 })
    end,
})

ConfigTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        if SelectedConfigName == "" then
            Rayfield:Notify({ Title = "Config", Content = "Select a config from the list first.", Duration = 3 })
            return
        end
        LoadConfig(SelectedConfigName)
    end,
})

ConfigTab:CreateButton({
    Name = "Delete Config",
    Callback = function()
        if SelectedConfigName == "" then
            Rayfield:Notify({ Title = "Config", Content = "Select a config from the list first.", Duration = 3 })
            return
        end
        local deleted = SelectedConfigName
        pcall(function() delfile(CONFIGS_FOLDER .. "/" .. deleted .. ".json") end)
        SelectedConfigName = ""
        task.wait(0.1)
        ConfigListDropdown:Refresh(GetConfigList())
        Rayfield:Notify({ Title = "Config", Content = "Deleted: " .. deleted, Duration = 3 })
    end,
})

ConfigTab:CreateButton({
    Name = "Refresh List",
    Callback = function()
        ConfigListDropdown:Refresh(GetConfigList())
        Rayfield:Notify({ Title = "Config", Content = "List refreshed.", Duration = 2 })
    end,
})

ConfigTab:CreateSection("Autoload")

ConfigTab:CreateButton({
    Name = "Set Current as Autoload",
    Callback = function()
        if SelectedConfigName == "" then
            Rayfield:Notify({ Title = "Config", Content = "Select a config from the list first.", Duration = 3 })
            return
        end
        pcall(function() writefile(AUTOLOAD_FILE, SelectedConfigName) end)
        Rayfield:Notify({ Title = "Config", Content = "Autoload set: " .. SelectedConfigName, Duration = 4 })
    end,
})

ConfigTab:CreateButton({
    Name = "Reset Autoload",
    Callback = function()
        pcall(function() if isfile(AUTOLOAD_FILE) then delfile(AUTOLOAD_FILE) end end)
        Rayfield:Notify({ Title = "Config", Content = "Autoload cleared.", Duration = 3 })
    end,
})

ConfigTab:CreateSection("System")

ConfigTab:CreateButton({
    Name = "Unload Script",
    Callback = function()
        UnloadScript()
    end,
})

task.spawn(function()
    task.wait(1)
    pcall(function()
        if not isfile(AUTOLOAD_FILE) then return end
        local autoName = readfile(AUTOLOAD_FILE)
        if not autoName or autoName == "" then return end
        autoName = autoName:gsub("[%s\n\r]+", "")
        if autoName == "" then return end
        if not isfile(CONFIGS_FOLDER .. "/" .. autoName .. ".json") then
            Rayfield:Notify({ Title = "Autoload", Content = "Config not found: " .. autoName, Duration = 4 })
            return
        end
        LoadConfig(autoName)
    end)
end)

Rayfield:LoadConfiguration()
