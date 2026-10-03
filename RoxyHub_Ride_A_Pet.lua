local replicatedStorage = game:GetService("ReplicatedStorage")
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local workspaceService = game:GetService("Workspace")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local httpService = game:GetService("HttpService")
local virtualUser = game:GetService("VirtualUser")
local virtualInputManager = game:GetService("VirtualInputManager")
_G.RoxyHubInstanceId = (_G.RoxyHubInstanceId or 0) + 1
local roxyHubInstanceId = _G.RoxyHubInstanceId

if _G.RoxyHubInstance and typeof(_G.RoxyHubInstance) == "table" and _G.RoxyHubInstance.Destroy then
  pcall(function() _G.RoxyHubInstance:Destroy() end)
end

if _G.RoxyHubConnections and type(_G.RoxyHubConnections) == "table" then
  for index, value in ipairs(_G.RoxyHubConnections) do
    local v1 = value
    pcall(function() v1:Disconnect() end)
  end
end

_G.RoxyHubConnections = {}

pcall(function()
  local rayfield = coreGui:FindFirstChild("Rayfield")

  if rayfield then
    rayfield:Destroy()
  end

  if gethui and gethui():FindFirstChild("RoxyHub_MobileToggle") then
    gethui().RoxyHub_MobileToggle:Destroy()
  end

  if coreGui:FindFirstChild("RoxyHub_MobileToggle") then
    coreGui.RoxyHub_MobileToggle:Destroy()
  end

  local localPlayer = players.LocalPlayer

  if localPlayer and localPlayer:FindFirstChild("PlayerGui")
    and localPlayer.PlayerGui:FindFirstChild("RoxyHub_MobileToggle") then
    localPlayer.PlayerGui.RoxyHub_MobileToggle:Destroy()
  end

  if localPlayer and localPlayer.Character then
    local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = localPlayer.Character:FindFirstChild("Humanoid")

    if humanoidRootPart then
      local roxyFlightStabilizer = humanoidRootPart:FindFirstChild("RoxyFlightStabilizer")

      if roxyFlightStabilizer then
        roxyFlightStabilizer:Destroy()
      end

      humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
      humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
    end

    if humanoid then
      humanoid.PlatformStand = false
      humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
  end

  local renderedEggs = workspaceService:FindFirstChild("RenderedEggs")

  if renderedEggs then
    for index2, value2 in ipairs(renderedEggs:GetChildren()) do
      local roxyEggESP = value2:FindFirstChild("RoxyEggESP")

      if roxyEggESP then
        pcall(function() roxyEggESP:Destroy() end)
      end
    end
  end
end)

local localPlayer2 = players.LocalPlayer
local robloxGui

pcall(function()
  if gethui then
    robloxGui = gethui()
  elseif syn and syn.protect_gui then
    robloxGui = coreGui:FindFirstChild("RobloxGui") or coreGui
  else
    robloxGui = coreGui:FindFirstChild("RobloxGui") or coreGui
  end
end)

if not robloxGui then
  robloxGui = localPlayer2:WaitForChild("PlayerGui", 3)
    or localPlayer2:FindFirstChild("PlayerGui")
end

pcall(function()
  local roxyHubLoadingScreen = robloxGui:FindFirstChild("RoxyHub_LoadingScreen")

  if roxyHubLoadingScreen then
    roxyHubLoadingScreen:Destroy()
  end
end)

local roxyHubLoadingScreen2 = Instance.new("ScreenGui")
roxyHubLoadingScreen2.Name = "RoxyHub_LoadingScreen"
roxyHubLoadingScreen2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
roxyHubLoadingScreen2.DisplayOrder = 99999
roxyHubLoadingScreen2.IgnoreGuiInset = true
roxyHubLoadingScreen2.ResetOnSpawn = false
roxyHubLoadingScreen2.Parent = robloxGui

local background = Instance.new("Frame")
background.Name = "Background"
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundColor3 = Color3.fromHex("#0B0F19")
background.BackgroundTransparency = 0.15
background.BorderSizePixel = 0
background.Parent = roxyHubLoadingScreen2

local centerContainer = Instance.new("Frame")
centerContainer.Name = "CenterContainer"
centerContainer.Size = UDim2.new(0, 440, 0, 220)
centerContainer.Position = UDim2.new(0.5, -220, 0.5, -110)
centerContainer.BackgroundTransparency = 1
centerContainer.Parent = background

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 52)
titleLabel.Position = UDim2.new(0, 0, 0, 15)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "RoxyHub"
titleLabel.TextColor3 = Color3.fromHex("#3B82F6")
titleLabel.TextSize = 44
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = centerContainer

local subLabel = Instance.new("TextLabel")
subLabel.Name = "SubLabel"
subLabel.Size = UDim2.new(1, 0, 0, 24)
subLabel.Position = UDim2.new(0, 0, 0, 70)
subLabel.BackgroundTransparency = 1
subLabel.Text = "Ride A Pet - Egg Farm & ESP"
subLabel.TextColor3 = Color3.fromHex("#38BDF8")
subLabel.TextSize = 19
subLabel.Font = Enum.Font.GothamMedium
subLabel.Parent = centerContainer

local barBackground = Instance.new("Frame")
barBackground.Name = "BarBackground"
barBackground.Size = UDim2.new(1, -60, 0, 10)
barBackground.Position = UDim2.new(0, 30, 0, 115)
barBackground.BackgroundColor3 = Color3.fromHex("#1E293B")
barBackground.BorderSizePixel = 0
barBackground.ClipsDescendants = true
barBackground.Parent = centerContainer

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = barBackground

local barFill = Instance.new("Frame")
barFill.Name = "BarFill"
barFill.Size = UDim2.new(0.05, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromHex("#38BDF8")
barFill.BorderSizePixel = 0
barFill.Parent = barBackground

local uiCorner2 = Instance.new("UICorner")
uiCorner2.CornerRadius = UDim.new(1, 0)
uiCorner2.Parent = barFill

local glow = Instance.new("Frame")
glow.Name = "Glow"
glow.Size = UDim2.new(0.3, 0, 1, 4)
glow.Position = UDim2.new(-0.3, 0, 0, -2)
glow.BackgroundColor3 = Color3.fromHex("#60A5FA")
glow.BackgroundTransparency = 0.5
glow.BorderSizePixel = 0
glow.Parent = barFill

local uiCorner3 = Instance.new("UICorner")
uiCorner3.CornerRadius = UDim.new(1, 0)
uiCorner3.Parent = glow

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 138)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Initializing runtime..."
statusLabel.TextColor3 = Color3.fromHex("#94A3B8")
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = centerContainer

local creditLabel = Instance.new("TextLabel")
creditLabel.Name = "CreditLabel"
creditLabel.Size = UDim2.new(1, 0, 0, 18)
creditLabel.Position = UDim2.new(0, 0, 0, 172)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "by RoxyHub"
creditLabel.TextColor3 = Color3.fromHex("#64748B")
creditLabel.TextSize = 12
creditLabel.Font = Enum.Font.Gotham
creditLabel.Parent = centerContainer

local particles = Instance.new("Frame")
particles.Name = "Particles"
particles.Size = UDim2.new(1, 0, 1, 0)
particles.BackgroundTransparency = 1
particles.ClipsDescendants = true
particles.Parent = background

local v2 = true

task.spawn(function()
  while v2 and roxyHubLoadingScreen2 and roxyHubLoadingScreen2.Parent do
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
    frame.Position = UDim2.new(math.random() * 0.95, 0, 1.05, 0)
    frame.BackgroundColor3 = Color3.fromHex(math.random() > 0.5 and "#3B82F6" or "#38BDF8")
    frame.BackgroundTransparency = math.random() * 0.3 + 0.3
    frame.BorderSizePixel = 0
    frame.Parent = particles

    local uiCorner4 = Instance.new("UICorner")
    uiCorner4.CornerRadius = UDim.new(1, 0)
    uiCorner4.Parent = frame

    local v3 = math.random(20, 35)

    local create = tweenService:Create(frame, TweenInfo.new(v3 / 10, Enum.EasingStyle.Linear), {
      Position = UDim2.new(frame.Position.X.Scale + (math.random() - 0.5) * 0.15, 0, -0.05, 0),
      BackgroundTransparency = 1,
    })

    create:Play()
    create.Completed:Connect(function() frame:Destroy() end)

    task.wait(0.1)
  end
end)

task.spawn(function()
  while v2 and roxyHubLoadingScreen2 and roxyHubLoadingScreen2.Parent do
    local create2 = tweenService:Create(glow, TweenInfo.new(1.1, Enum.EasingStyle.Linear), {
      Position = UDim2.new(1, 0, 0, -2),
    })

    create2:Play()
    create2.Completed:Wait()

    glow.Position = UDim2.new(-0.3, 0, 0, -2)
  end
end)

local function f1(p1, p2)
end

local function f2(p3)
  v2 = false

  pcall(function()
    if roxyHubLoadingScreen2 then
      roxyHubLoadingScreen2.Enabled = false
      roxyHubLoadingScreen2:Destroy()
    end
  end)

  pcall(function()
    local v4 = { robloxGui, coreGui }
    local playerGui = localPlayer2 and localPlayer2:FindFirstChild("PlayerGui")

    if playerGui then
      table.insert(v4, playerGui)
    end

    if gethui then
      table.insert(v4, gethui())
    end

    for index3, value3 in ipairs(v4) do
      if value3 then
        for index4, value4 in ipairs(value3:GetChildren()) do
          if value4.Name == "RoxyHub_LoadingScreen" then
            value4.Enabled = false
            value4:Destroy()
          end
        end
      end
    end
  end)
end

task.delay(90, function()
  if v2 then
    f2(true)
  end
end)

pcall(function()
  local connect = localPlayer2.Idled:Connect(function()
    virtualUser:Button2Down(Vector2.new(0, 0), workspaceService.CurrentCamera.CFrame)
    task.wait(0.5)
    virtualUser:Button2Up(Vector2.new(0, 0), workspaceService.CurrentCamera.CFrame)
  end)
end)

local require = getrenv and type(getrenv) == "function" and getrenv().require
local require2 = getgenv and type(getgenv) == "function" and getgenv().require
local roxyMODULES = _G._ROXY_MODULES or {}

local function f3(p4, p5, p6)
  if roxyMODULES and roxyMODULES[p5] then
    return roxyMODULES[p5]
  end

  if not p4 then
    return p6 or {}
  end

  if require then
    local v5, v6 = pcall(require, p4)

    if v5 and v6 and (type(v6) == "table" or type(v6) == "userdata") then
      return v6
    end
  end

  if require2 and require2 ~= require then
    local v7, v8 = pcall(require2, p4)

    if v7 and v8 and (type(v8) == "table" or type(v8) == "userdata") then
      return v8
    end

    return p6 or {}
  end

  return p6 or {}
end

local v9 = {
  ["White Egg"] = { GrowthTime = 3, Rarity = "Common", Luck = 1 },
  ["Brown Egg"] = { GrowthTime = 3, Rarity = "Common", Luck = 5 },
  ["Cracked Egg"] = { GrowthTime = 5, Rarity = "Rare", Luck = 30 },
  ["Easter Egg"] = { GrowthTime = 6, Rarity = "Rare", Luck = 50 },
  ["Stone Egg"] = { GrowthTime = 7, Rarity = "Rare", Luck = 100 },
  ["Leaf Egg"] = { GrowthTime = 8, Rarity = "Rare", Luck = 200 },
  ["Mushroom Egg"] = { GrowthTime = 60, Rarity = "Epic", Luck = 500 },
  ["Flower Egg"] = { GrowthTime = 180, Rarity = "Epic", Luck = 750 },
  ["Slime Egg"] = { GrowthTime = 180, Rarity = "Epic", Luck = 1000 },
  ["Ice Egg"] = { GrowthTime = 180, Rarity = "Epic", Luck = 3000 },
  ["Glass Egg"] = { GrowthTime = 300, Rarity = "Legendary", Luck = 10000 },
  ["Golden Egg"] = { GrowthTime = 300, Rarity = "Legendary", Luck = 30000 },
  ["Diamond Egg"] = { GrowthTime = 600, Rarity = "Mythic", Luck = 90000 },
  ["Crystal Egg"] = { GrowthTime = 900, Rarity = "Mythic", Luck = 150000 },
  ["Skull Egg"] = { GrowthTime = 3600, Rarity = "Mythic", Luck = 250000 },
  ["Asteroid Egg"] = { GrowthTime = 7200, Rarity = "Mythic", Luck = 500000 },
  ["Dominus Egg"] = { GrowthTime = 7200, Rarity = "Mythic", Luck = 700000 },
  ["Flaming Egg"] = { GrowthTime = 7200, Rarity = "Mythic", Luck = 1000000 },
  ["Sinister Egg"] = { GrowthTime = 7200, Rarity = "Mythic", Luck = 3000000 },
  ["Soul Egg"] = { GrowthTime = 7200, Rarity = "Mythic", Luck = 7000000 },
  ["Tidal Egg"] = { GrowthTime = 7200, Rarity = "Mythic", Luck = 8000000 },
  ["Aurora Egg"] = { GrowthTime = 10800, Rarity = "Divine", Luck = 300000000 },
  ["Galaxy Egg"] = { GrowthTime = 10800, Rarity = "Divine", Luck = 1500000000 },
  ["Bloom Egg"] = { GrowthTime = 10800, Rarity = "Divine", Luck = 2000000000 },
  ["Blackhole Egg"] = { GrowthTime = 21600, Rarity = "Ethereal", Luck = 100000000000 },
  ["Solaris Egg"] = { GrowthTime = 25200, Rarity = "Ethereal", Luck = 300000000000 },
  ["Cherub Egg"] = { GrowthTime = 28800, Rarity = "Ethereal", Luck = 1000000000000 },
  ["Volcanic Egg"] = { GrowthTime = 32400, Rarity = "Ethereal", Luck = 2500000000000 },
}

local gameData = replicatedStorage:FindFirstChild("GameData")
  or replicatedStorage:WaitForChild("GameData", 1.5)

local eggs = gameData and (gameData:FindFirstChild("Eggs") or gameData:WaitForChild("Eggs", 1))
local v10 = eggs and f3(eggs, "Eggs", v9) or v9

local hatchLuck = gameData
  and (gameData:FindFirstChild("HatchLuck") or gameData:WaitForChild("HatchLuck", 1))

local v11 = hatchLuck and f3(hatchLuck, "HatchLuck")

local rebirths = gameData
  and (gameData:FindFirstChild("Rebirths") or gameData:WaitForChild("Rebirths", 1))

local v12 = rebirths and f3(rebirths, "Rebirths", {
  Cap = 6,
  RiggedCost = { 1000000, 500000000, 2500000000, 125000000000, 6250000000000, 1000000000000000 },
}) or {
  Cap = 6,
  RiggedCost = { 1000000, 500000000, 2500000000, 125000000000, 6250000000000, 1000000000000000 },
}

if gameData then
  v61 = gameData:FindFirstChild("Pets") or gameData:WaitForChild("Pets", 1)
end

local general = gameData
  and (gameData:FindFirstChild("General") or gameData:WaitForChild("General", 1))

local v13 = general and f3(general, "GeneralConfig")

local remotes = replicatedStorage:FindFirstChild("Remotes")
  or replicatedStorage:WaitForChild("Remotes", 1.5)

local v14 = remotes and (remotes:FindFirstChild("Game") or remotes:WaitForChild("Game", 1))
local eggPickup = v14 and (v14:FindFirstChild("EggPickup") or v14:WaitForChild("EggPickup", 1))

local basketDrop = v14
  and (v14:FindFirstChild("BasketDrop") or v14:WaitForChild("BasketDrop", 1))

local teleportToPlot = v14
  and (v14:FindFirstChild("TeleportToPlot") or v14:WaitForChild("TeleportToPlot", 1))

local eggPlaced = v14 and (v14:FindFirstChild("EggPlaced") or v14:WaitForChild("EggPlaced", 1))
local rebirth = v14 and (v14:FindFirstChild("Rebirth") or v14:WaitForChild("Rebirth", 1))
local hatch = v14 and (v14:FindFirstChild("Hatch") or v14:WaitForChild("Hatch", 1))
local plot = v14 and (v14:FindFirstChild("Plot") or v14:WaitForChild("Plot", 1))
local nests = plot and (plot:FindFirstChild("Nests") or plot:WaitForChild("Nests", 1))

local gameServices = replicatedStorage:FindFirstChild("GameServices")
  or replicatedStorage:WaitForChild("GameServices", 1.5)

local general2 = gameServices
  and (gameServices:FindFirstChild("General") or gameServices:WaitForChild("General", 1))

local v15 = general2 and f3(general2, "General")

local dayNight = gameServices
  and (gameServices:FindFirstChild("DayNight") or gameServices:WaitForChild("DayNight", 1))

local v16 = dayNight and f3(dayNight, "DayNight")

local v17 = {
  Ethereal = 1000,
  Divine = 900,
  Mythic = 800,
  Legendary = 700,
  Epic = 600,
  Rare = 500,
  Common = 100,
  Unknown = 0,
}

local v18 = {
  Ethereal = Color3.fromRGB(255, 60, 255),
  Divine = Color3.fromRGB(0, 240, 255),
  Mythic = Color3.fromRGB(255, 50, 50),
  Legendary = Color3.fromRGB(255, 190, 0),
  Epic = Color3.fromRGB(180, 70, 255),
  Rare = Color3.fromRGB(60, 150, 255),
  Common = Color3.fromRGB(190, 190, 190),
  Unknown = Color3.fromRGB(255, 255, 255),
}

local function f4(p7)
  local v19 = v10 and v10[p7] or v9[p7]
  return v19 and v19.Rarity or "Common"
end

local function f5(p8)
  local v20 = v10 and v10[p8] or v9[p8]
  return v20 and v20.Luck or 1
end

local v21 = {
  Shocked = 2,
  Volted = 3,
  Rage = 4,
  Void = 10,
  Magma = 10,
  Eternal = 100,
}

local v22 = {
  Eternal = 100000,
  Magma = 75000,
  Void = 50000,
  Rage = 20000,
  Volted = 10000,
  Shocked = 5000,
}

local v23 = {
  Eternal = Color3.fromRGB(255, 100, 220),
  Magma = Color3.fromRGB(255, 120, 20),
  Void = Color3.fromRGB(130, 60, 255),
  Rage = Color3.fromRGB(255, 60, 60),
  Volted = Color3.fromRGB(255, 230, 40),
  Shocked = Color3.fromRGB(80, 190, 255),
}

local v24 = {
  Thunder = "Shocked",
  Volt = "Volted",
  Raging = "Rage",
  Dreadful = "Void",
  Eternal = "Eternal",
}

local vector = Vector3.new(-5102.8, 41408, -3489.1)

local cframe = CFrame.new(
  -4917.03369, 41285.5312, -3704.17505, -0.710648835, -0.151280612, 0.68708986, 1.78015469e-8,
  0.976608396, 0.215025634, -0.703546941, 0.152807727, -0.694025576
)

local cframe2 = CFrame.new(
  -4972.5, 41276.5, -3650, 0.83177793, 0, -0.555108488, 0, 1, 0, 0.555108488, 0, 0.83177793
)

local function f6(p9)
  if not p9 or p9 == "" then
    return false
  else
    local minMutationTier = _G.RoxyHubState and _G.RoxyHubState.MinMutationTier
      or "All Mutations (Shocked+)"

    local v25 = v21[p9] or 1

    if minMutationTier == "Eternal Only (100x)" then
      return v25 >= 100
    end

    if minMutationTier == "Magma & Above (10x+)" or minMutationTier == "Void & Above (10x+)" then
      return v25 >= 10
    elseif minMutationTier == "Rage & Above (4x+)" then
      return v25 >= 4
    else
      if minMutationTier == "Volted & Above (3x+)" then
        return v25 >= 3
      end

      return v25 >= 2
    end
  end
end

local function f7()
  local cook45VolcanoPlatform = workspaceService:FindFirstChild("Cook45_VolcanoPlatform")
  local cframe3 = CFrame.new(cframe.Position - Vector3.new(0, 3.2, 0))

  if not cook45VolcanoPlatform then
    cook45VolcanoPlatform = Instance.new("Part")
    cook45VolcanoPlatform.Name = "Cook45_VolcanoPlatform"
    cook45VolcanoPlatform.Size = Vector3.new(14, 1, 14)
    cook45VolcanoPlatform.Anchored = true
    cook45VolcanoPlatform.CanCollide = true
    cook45VolcanoPlatform.CFrame = cframe3
    cook45VolcanoPlatform.Material = Enum.Material.SmoothPlastic
    cook45VolcanoPlatform.Transparency = 0.5
    cook45VolcanoPlatform.Parent = workspaceService
  else
    cook45VolcanoPlatform.CFrame = cframe3
  end

  return cook45VolcanoPlatform
end

local f8

local function f9(p10)
  if not p10 then
    return nil
  else
    local mutation = p10:GetAttribute("Mutation")

    if mutation and mutation ~= "" then
      return mutation
    else
      local serverData = replicatedStorage:FindFirstChild("ServerData")
      local activeEggs = serverData and serverData:FindFirstChild("ActiveEggs")

      if activeEggs then
        local position = p10:GetPivot().Position

        for index5, value5 in ipairs(activeEggs:GetChildren()) do
          local getAttributes = value5:GetAttributes()

          if getAttributes.Mutation and getAttributes.Mutation ~= "" then
            local position2 = getAttributes.Position

            local position3 = position2

            position3 = position2
              or getAttributes.SpawnCFrame and getAttributes.SpawnCFrame.Position

            if position3 and (position3 - position).Magnitude <= 6 then
              return getAttributes.Mutation
            end
          end
        end

        if p10:FindFirstChild("MutationHitbox") then
          local v26 = f8()

          if v26 and v26.Variant and v24[v26.Variant] then
            return v24[v26.Variant]
          end

          return "Shocked"
        end

        return nil
      elseif p10:FindFirstChild("MutationHitbox") then
        local v27 = f8()

        if v27 and v27.Variant and v24[v27.Variant] then
          return v24[v27.Variant]
        end

        return "Shocked"
      else
        return nil
      end
    end
  end
end

function f8()
  local serverData2 = replicatedStorage:FindFirstChild("ServerData")

  if not serverData2 then
    return nil
  end

  local activeWeathers = serverData2:GetAttribute("ActiveWeathers")

  if not activeWeathers or activeWeathers == "" or activeWeathers == "[]" then
    return nil
  else
    local v28, v29 = pcall(function() return httpService:JSONDecode(activeWeathers) end)

    if not v28 or type(v29) ~= "table" then
      return nil
    else
      local getServerTimeNow = workspaceService:GetServerTimeNow()

      for index6, value6 in ipairs(v29) do
        if value6.Type == "Storm" and value6.Variant
          and (not value6.EndsAt or value6.EndsAt > getServerTimeNow) then
          return value6
        end
      end

      return nil
    end
  end
end

local g = _G
g.RoxyHubState = _G.RoxyHubState or {}

local roxyHubState = _G.RoxyHubState
roxyHubState.AutoFarm = false
roxyHubState.AutoRebirth = false
roxyHubState.AutoMagmaDip = false

if roxyHubState.FarmMode == nil then
  roxyHubState.FarmMode = "Safe Tween"
end

if roxyHubState.TweenSpeed == nil then
  roxyHubState.TweenSpeed = 300
end

if roxyHubState.SyncDelay == nil then
  roxyHubState.SyncDelay = 0.35
end

if roxyHubState.PostPickupDelay == nil then
  roxyHubState.PostPickupDelay = 0.15
end

if roxyHubState.PriorityRarity == nil then
  roxyHubState.PriorityRarity = true
end

if roxyHubState.AutoDropUnwanted == nil then
  roxyHubState.AutoDropUnwanted = false
end

if roxyHubState.AutoReturnPlot == nil then
  roxyHubState.AutoReturnPlot = false
end

if roxyHubState.AutoPlaceNest == nil then
  roxyHubState.AutoPlaceNest = false
end

if roxyHubState.SpawnNest == nil then
  roxyHubState.SpawnNest = false
end

if roxyHubState.AutoHatchPlot == nil then
  roxyHubState.AutoHatchPlot = false
end

if roxyHubState.AutoUnlockNests == nil then
  roxyHubState.AutoUnlockNests = false
end

if roxyHubState.AutoUpgradeLuck == nil then
  roxyHubState.AutoUpgradeLuck = false
end

if roxyHubState.AutoFeedPets == nil then
  roxyHubState.AutoFeedPets = false
end

if roxyHubState.FeedTargetMode == nil then
  roxyHubState.FeedTargetMode = "Smart Priority (Highest Headroom)"
end

if roxyHubState.SelectedPetKey == nil then
  roxyHubState.SelectedPetKey = nil
end

if roxyHubState.FeedPriorityMode == nil then
  roxyHubState.FeedPriorityMode = "Smart Potential (Highest Headroom)"
end

if roxyHubState.FeedSkipMaxAge == nil then
  roxyHubState.FeedSkipMaxAge = true
end

if roxyHubState.FeedAllowPremiumFood == nil then
  roxyHubState.FeedAllowPremiumFood = true
end

if roxyHubState.FeedFoodSelection == nil then
  roxyHubState.FeedFoodSelection = "All Foods"
end

if roxyHubState.FeedAllPets == nil then
  roxyHubState.FeedAllPets = true
end

if roxyHubState.FeedPetList == nil then
  roxyHubState.FeedPetList = {}
end

if roxyHubState.PrioritizeRebirthPet == nil then
  roxyHubState.PrioritizeRebirthPet = true
end

if roxyHubState.AutoRebirthWhenReady == nil then
  roxyHubState.AutoRebirthWhenReady = true
end

if roxyHubState.AllowedRarities == nil then
  roxyHubState.AllowedRarities = {
    Ethereal = true,
    Divine = true,
    Mythic = true,
    Legendary = true,
    Epic = true,
    Rare = false,
    Common = false,
  }
end

if roxyHubState.ESP_Enabled == nil then
  roxyHubState.ESP_Enabled = false
end

if roxyHubState.ESP_Highlights == nil then
  roxyHubState.ESP_Highlights = true
end

if roxyHubState.ESP_Billboards == nil then
  roxyHubState.ESP_Billboards = true
end

if roxyHubState.ESP_Tracers == nil then
  roxyHubState.ESP_Tracers = false
end

if roxyHubState.ESP_MaxDistance == nil then
  roxyHubState.ESP_MaxDistance = 5000
end

if roxyHubState.ESP_MinRarity == nil then
  roxyHubState.ESP_MinRarity = "Rare"
end

if roxyHubState.NoClip == nil then
  roxyHubState.NoClip = false
end

if roxyHubState.SpeedMultiplier == nil then
  roxyHubState.SpeedMultiplier = 1
end

if roxyHubState.SpeedModEnabled == nil then
  roxyHubState.SpeedModEnabled = false
end

if roxyHubState.MinFarmRarity == nil then
  roxyHubState.MinFarmRarity = "Mythic & Above"
end

if roxyHubState.TargetSpecificEgg == nil then
  roxyHubState.TargetSpecificEgg = "Any Egg (Use Rarity Filter)"
end

if roxyHubState.FarmPriority == nil then
  roxyHubState.FarmPriority = "Highest Rarity First"
end

if roxyHubState.PlotStrategy == nil then
  roxyHubState.PlotStrategy = "Disabled (Never Return)"
end

if roxyHubState.ESP_VisualPreset == nil then
  roxyHubState.ESP_VisualPreset = "Highlights + Floating Text"
end

if roxyHubState.SpeedPreset == nil then
  roxyHubState.SpeedPreset = "Default (1x)"
end

if roxyHubState.MinEggWeight == nil then
  roxyHubState.MinEggWeight = 0
end

if roxyHubState.PrioritizeHeaviest == nil then
  roxyHubState.PrioritizeHeaviest = false
end

if roxyHubState.WeatherEggWait == nil then
  roxyHubState.WeatherEggWait = false
end

if roxyHubState.PrioritizeMutations == nil then
  roxyHubState.PrioritizeMutations = true
end

if roxyHubState.MinMutationTier == nil then
  roxyHubState.MinMutationTier = "All Mutations (Shocked+)"
end

if roxyHubState.WeatherNotify == nil then
  roxyHubState.WeatherNotify = true
end

local function f10(p11)
  roxyHubState.ESP_VisualPreset = p11

  if p11 == "All Visuals (Highlight + Text + Tracer)" then
    roxyHubState.ESP_Highlights = true
    roxyHubState.ESP_Billboards = true
    roxyHubState.ESP_Tracers = true
  elseif p11 == "Highlights + Floating Text" then
    roxyHubState.ESP_Highlights = true
    roxyHubState.ESP_Billboards = true
    roxyHubState.ESP_Tracers = false
  elseif p11 == "Floating Text Only (Clean)" then
    roxyHubState.ESP_Highlights = false
    roxyHubState.ESP_Billboards = true
    roxyHubState.ESP_Tracers = false
  elseif p11 == "Highlights Only (Minimal)" then
    roxyHubState.ESP_Highlights = true
    roxyHubState.ESP_Billboards = false
    roxyHubState.ESP_Tracers = false
  elseif p11 == "Tracers Only" then
    roxyHubState.ESP_Highlights = false
    roxyHubState.ESP_Billboards = false
    roxyHubState.ESP_Tracers = true
  end
end

local function f11(p12)
  roxyHubState.MinFarmRarity = p12

  local v30 = ({
    ["All Eggs"] = {
      Common = true,
      Rare = true,
      Epic = true,
      Legendary = true,
      Mythic = true,
      Divine = true,
      Ethereal = true,
    },
    ["Rare & Above"] = {
      Common = false,
      Rare = true,
      Epic = true,
      Legendary = true,
      Mythic = true,
      Divine = true,
      Ethereal = true,
    },
    ["Epic & Above"] = {
      Common = false,
      Rare = false,
      Epic = true,
      Legendary = true,
      Mythic = true,
      Divine = true,
      Ethereal = true,
    },
    ["Legendary & Above"] = {
      Common = false,
      Rare = false,
      Epic = false,
      Legendary = true,
      Mythic = true,
      Divine = true,
      Ethereal = true,
    },
    ["Mythic & Above"] = {
      Common = false,
      Rare = false,
      Epic = false,
      Legendary = false,
      Mythic = true,
      Divine = true,
      Ethereal = true,
    },
    ["Divine & Above"] = {
      Common = false,
      Rare = false,
      Epic = false,
      Legendary = false,
      Mythic = false,
      Divine = true,
      Ethereal = true,
    },
    ["Ethereal Only"] = {
      Common = false,
      Rare = false,
      Epic = false,
      Legendary = false,
      Mythic = false,
      Divine = false,
      Ethereal = true,
    },
  })[p12]

  if v30 then
    for key, value7 in pairs(v30) do
      roxyHubState.AllowedRarities[key] = value7
    end
  end
end

pcall(function()
  if makefolder and not isfolder("RoxyHub_RideAPet/configs") then
    if not isfolder("RoxyHub_RideAPet") then
      makefolder("RoxyHub_RideAPet")
    end

    makefolder("RoxyHub_RideAPet/configs")
  end
end)

local v31 = false
local profile = "default"

pcall(function()
  if isfile and isfile("RoxyHub_RideAPet/configs/autoload.json") then
    local jsonDecode = httpService:JSONDecode((readfile("RoxyHub_RideAPet/configs/autoload.json")))

    if jsonDecode and type(jsonDecode) == "table" then
      if jsonDecode.AutoLoad == true then
        v31 = true
      end

      if jsonDecode.Profile and type(jsonDecode.Profile) == "string"
        and jsonDecode.Profile ~= "" and jsonDecode.Profile ~= "autoload" then
        profile = jsonDecode.Profile
      end
    end
  end

  if v31 and profile ~= "" then
    local v32 = "RoxyHub_RideAPet/configs" .. "/" .. profile .. ".json"

    if isfile and isfile(v32) then
      local jsonDecode2 = httpService:JSONDecode((readfile(v32)))

      if jsonDecode2 and type(jsonDecode2) == "table" then
        for key2, value8 in pairs(jsonDecode2) do
          if key2 ~= "AutoFarm" and key2 ~= "AutoRebirth" then
            roxyHubState[key2] = value8
          end
        end

        if roxyHubState.MinFarmRarity and f11 then
          f11(roxyHubState.MinFarmRarity)
        end

        if roxyHubState.ESP_VisualPreset and f10 then
          f10(roxyHubState.ESP_VisualPreset)
        end
      end
    end
  end
end)

local values = {
  "Any Egg (Use Rarity Filter)", "Volcanic Egg [Ethereal]", "Cherub Egg [Ethereal]",
  "Solaris Egg [Ethereal]", "Blackhole Egg [Ethereal]", "Giant Egg [Ethereal]",
  "Dragon Egg [Ethereal]", "Bloom Egg [Divine]", "Galaxy Egg [Divine]", "Aurora Egg [Divine]",
  "Tidal Egg [Mythic]", "Soul Egg [Mythic]", "Sinister Egg [Mythic]", "Flaming Egg [Mythic]",
  "Dominus Egg [Mythic]", "Asteroid Egg [Mythic]", "Skull Egg [Mythic]", "Crystal Egg [Mythic]",
  "Diamond Egg [Mythic]", "Golden Egg [Legendary]", "Glass Egg [Legendary]", "Ice Egg [Epic]",
  "Slime Egg [Epic]", "Flower Egg [Epic]", "Mushroom Egg [Epic]", "Leaf Egg [Rare]",
  "Stone Egg [Rare]", "Easter Egg [Rare]", "Cracked Egg [Rare]", "Brown Egg [Common]",
  "White Egg [Common]",
}

local function f12()
  if v15 and v15.GetPlot then
    local getPlot = v15:GetPlot(localPlayer2)

    if getPlot then
      return getPlot
    end
  end

  local plots = workspaceService:FindFirstChild("Plots")

  if plots then
    for index7, value9 in ipairs(plots:GetChildren()) do
      local nestsOwnerLoaded = value9:GetAttribute("NestsOwnerLoaded")
        or value9:GetAttribute("OwnerUserId") or value9:GetAttribute("Owner")

      if nestsOwnerLoaded == localPlayer2.UserId
        or tostring(nestsOwnerLoaded) == tostring(localPlayer2.UserId) then
        return value9
      else
        local data = value9:FindFirstChild("Data")

        local owner = data
        owner = data and data:FindFirstChild("Owner")

        if owner
          and (owner.Value == localPlayer2 or tostring(owner.Value) == localPlayer2.Name
            or tostring(owner.Value) == tostring(localPlayer2.UserId)) then
          return value9
        end

        if value9.Name == tostring(localPlayer2.UserId) or value9.Name == localPlayer2.Name then
          return value9
        elseif value9:FindFirstChild("Pets") then
          for index8, value10 in ipairs(value9.Pets:GetChildren()) do
            if value10:IsA("Model")
              and (value10:GetAttribute("OwnerUserId") == localPlayer2.UserId
                or tostring(value10:GetAttribute("OwnerUserId"))
                  == tostring(localPlayer2.UserId)) then
              return value9
            end
          end
        end
      end
    end

    return nil
  end

  return nil
end

local v33 = {
  Status = "Idle",
  Target = "None",
  TargetRarity = "None",
  CollectedCount = 0,
  IsFarming = false,
  CurrentTween = nil,
  RebirthTargetPet = nil,
  RebirthEggName = nil,
  RebirthEggChance = 0,
  TargetWeight = 0,
}

local function f13()
  local character = localPlayer2.Character

  if not character then
    return nil
  else
    local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart")
    local humanoid2 = character:FindFirstChildOfClass("Humanoid")

    if humanoidRootPart2 and humanoid2 and humanoid2.Health > 0 then
      return character, humanoidRootPart2, humanoid2
    end

    return nil
  end
end

local function f14(p13)
  if not p13 then
    return
  end

  local waitForChild = p13:WaitForChild("Humanoid", 5)
  local waitForChild2 = p13:WaitForChild("HumanoidRootPart", 5)

  if not waitForChild then
    return
  end

  pcall(function()
    waitForChild:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    waitForChild:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    waitForChild:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    waitForChild:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
  end)

  waitForChild.StateChanged:Connect(function(p14, p15)
    if _G.RoxyHubInstanceId ~= roxyHubInstanceId then
      return
    end

    if p15 == Enum.HumanoidStateType.Ragdoll or p15 == Enum.HumanoidStateType.Physics
      or p15 == Enum.HumanoidStateType.FallingDown then
      pcall(function()
        waitForChild:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        waitForChild:ChangeState(Enum.HumanoidStateType.GettingUp)
      end)

      if waitForChild2 and waitForChild2:IsA("BasePart") then
        waitForChild2.AssemblyLinearVelocity = Vector3.zero
      end
    end
  end)
end

local function f15()
  local count = 0
  local v34 = f12()
  local nests2 = v34 and v34:FindFirstChild("Nests")

  if nests2 then
    for index9, value11 in ipairs(nests2:GetChildren()) do
      if value11:GetAttribute("Occupied") == true then
        count = count + 1
      end
    end
  end

  return count
end

local function f16()
  local v35 = f12()
  local eggs2 = v35 and v35:FindFirstChild("Eggs")

  if eggs2 then
    return #eggs2:GetChildren()
  end

  return 0
end

if localPlayer2.Character then
  f14(localPlayer2.Character)
end

localPlayer2.CharacterAdded:Connect(function(character2)
  pcall(function()
    local ragdoll = localPlayer2:FindFirstChild("PlayerScripts")
      and localPlayer2.PlayerScripts:FindFirstChild("Game")
      and localPlayer2.PlayerScripts.Game:FindFirstChild("Ragdoll")

    if ragdoll and ragdoll:IsA("LocalScript") then
      ragdoll.Disabled = true
    end
  end)

  f14(character2)
end)

pcall(function()
  local net = replicatedStorage:FindFirstChild("packages")
    and replicatedStorage.packages:FindFirstChild("Net")

  local reRagdoll = net and net:FindFirstChild("RE/Ragdoll")

  if reRagdoll and reRagdoll:IsA("RemoteEvent") then
    reRagdoll.OnClientEvent:Connect(function(p16, p17)
      if _G.RoxyHubInstanceId ~= roxyHubInstanceId then
        return
      end

      if p16 then
        task.defer(function()
          local v36, v37, v38 = f13()

          if v38 then
            pcall(function()
              v38:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
              v38:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
          end

          if v37 and v37:IsA("BasePart") then
            v37.AssemblyLinearVelocity = Vector3.zero
          end
        end)
      end
    end)
  end
end)

local function f17(p18)
  local v39 = f12()
  local nests3 = v39 and v39:FindFirstChild("Nests")

  if not nests3 then
    return
  end

  for index10, value12 in ipairs(nests3:GetChildren()) do
    local v40 = value12

    for index11, value13 in ipairs(v40:GetDescendants()) do
      local v41 = value13

      if v41:IsA("BasePart") and v41.Name ~= "Cook45_NestAnchor" then
        v41.LocalTransparencyModifier = p18 and 0 or 1

        if not v41:GetAttribute("NestWatched") then
          v41:SetAttribute("NestWatched", true)

          v41:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
            if roxyHubState.SpawnNest and v41.LocalTransparencyModifier ~= 0 then
              v41.LocalTransparencyModifier = 0
            end
          end)
        end
      end
    end

    local cook45NestAnchor = v40:FindFirstChild("Cook45_NestAnchor")

    if p18 then
      if not cook45NestAnchor then
        cook45NestAnchor = Instance.new("Part")
        cook45NestAnchor.Name = "Cook45_NestAnchor"
        cook45NestAnchor.Size = Vector3.new(2, 2, 2)
        cook45NestAnchor.CFrame = v40:GetPivot() * CFrame.new(0, 1.5, 0)
        cook45NestAnchor.Transparency = 1
        cook45NestAnchor.CanCollide = false
        cook45NestAnchor.CanTouch = false
        cook45NestAnchor.CanQuery = false
        cook45NestAnchor.Anchored = true
        cook45NestAnchor.Parent = v40
      end

      local nestPlacePrompt = cook45NestAnchor:FindFirstChildOfClass("ProximityPrompt")

      if not nestPlacePrompt then
        nestPlacePrompt = Instance.new("ProximityPrompt")
        nestPlacePrompt.Name = "NestPlacePrompt"
        nestPlacePrompt.ActionText = "Place Egg"
        nestPlacePrompt.ObjectText = "Nest " .. v40.Name
        nestPlacePrompt.HoldDuration = 0
        nestPlacePrompt.MaxActivationDistance = 25
        nestPlacePrompt.RequiresLineOfSight = false
        nestPlacePrompt.Parent = cook45NestAnchor

        nestPlacePrompt.Triggered:Connect(function(p19)
          if p19 == localPlayer2 then
            if v40:GetAttribute("Occupied") then
              if WindUI then
                WindUI:Notify({
                  Title = "Nest Full",
                  Content = "This nest is already occupied!",
                  Duration = 2,
                  Icon = "alert-circle",
                })
              end

              return
            else
              local character3 = localPlayer2.Character
              local humanoid3 = character3 and character3:FindFirstChildOfClass("Humanoid")
              local v42 = nil

              if character3 then
                for index12, value14 in ipairs(character3:GetChildren()) do
                  if value14:IsA("Tool")
                    and (value14:HasTag("Egg") or string.find(value14.Name, "Egg")) then
                    v42 = value14
                    break
                  end
                end
              end

              if not v42 and localPlayer2:FindFirstChild("Backpack") then
                for index13, value15 in ipairs(localPlayer2.Backpack:GetChildren()) do
                  if value15:IsA("Tool")
                    and (value15:HasTag("Egg") or string.find(value15.Name, "Egg")) then
                    v42 = value15
                    break
                  end
                end
              end

              if not v42 then
                if WindUI then
                  WindUI:Notify({
                    Title = "No Egg",
                    Content = "No egg tool in backpack or character!",
                    Duration = 2,
                    Icon = "x",
                  })
                end

                return
              end

              if humanoid3 and v42.Parent ~= character3 then
                humanoid3:EquipTool(v42)
                local v43 = os.clock()

                while v42.Parent ~= character3 and os.clock() - v43 < 0.8 do
                  task.wait(0.05)
                end
              end

              if v42.Parent == character3 and eggPlaced then
                task.wait(0.1)
                eggPlaced:FireServer({ NestId = v40.Name })

                if WindUI then
                  WindUI:Notify({
                    Title = "Nest Placed",
                    Content = "Placed " .. v42.Name .. " in Nest " .. v40.Name .. "!",
                    Duration = 3,
                    Icon = "check",
                  })
                end
              end

              return
            end
          else
            return
          end
        end)
      end

      if not cook45NestAnchor:FindFirstChild("NestStatusESP") then
        local nestStatusESP = Instance.new("BillboardGui")
        nestStatusESP.Name = "NestStatusESP"
        nestStatusESP.Size = UDim2.new(0, 140, 0, 30)
        nestStatusESP.StudsOffset = Vector3.new(0, 2.5, 0)
        nestStatusESP.AlwaysOnTop = true
        nestStatusESP.Adornee = cook45NestAnchor
        nestStatusESP.Enabled = true
        nestStatusESP.Parent = cook45NestAnchor

        local statusLabel2 = Instance.new("TextLabel")
        statusLabel2.Name = "StatusLabel"
        statusLabel2.Size = UDim2.new(1, 0, 1, 0)
        statusLabel2.BackgroundTransparency = 0.4
        statusLabel2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        statusLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
        statusLabel2.Font = Enum.Font.GothamBold
        statusLabel2.TextSize = 13
        statusLabel2.BorderSizePixel = 0
        statusLabel2.Parent = nestStatusESP

        local uiCorner5 = Instance.new("UICorner")
        uiCorner5.CornerRadius = UDim.new(0, 6)
        uiCorner5.Parent = statusLabel2
      end

      local function f18()
        local v44 = v40:GetAttribute("Occupied") == true
        local v45 = v40:GetAttribute("Unlocked") ~= false

        local statusLabel3 = cook45NestAnchor:FindFirstChild("NestStatusESP")
          and cook45NestAnchor.NestStatusESP:FindFirstChild("StatusLabel")

        if statusLabel3 then
          if not v45 then
            statusLabel3.Text = "[Locked] Nest " .. v40.Name
            statusLabel3.TextColor3 = Color3.fromRGB(220, 80, 80)
          elseif v44 then
            statusLabel3.Text = "[Incubating] Nest " .. v40.Name
            statusLabel3.TextColor3 = Color3.fromRGB(255, 200, 50)
          else
            statusLabel3.Text = "[Ready] Nest " .. v40.Name
            statusLabel3.TextColor3 = Color3.fromRGB(80, 255, 120)
          end
        end

        if nestPlacePrompt then
          local v46 = nestPlacePrompt
          v46.Enabled = v45 and not v44
        end
      end

      v40:GetAttributeChangedSignal("Occupied"):Connect(f18)
      v40:GetAttributeChangedSignal("Unlocked"):Connect(f18)

      f18()
    elseif cook45NestAnchor then
      local proximityPrompt = cook45NestAnchor:FindFirstChildOfClass("ProximityPrompt")

      if proximityPrompt then
        proximityPrompt.Enabled = false
      end

      local nestStatusESP2 = cook45NestAnchor:FindFirstChild("NestStatusESP")

      if nestStatusESP2 then
        nestStatusESP2.Enabled = false
      end
    end
  end
end

local function f19(p20)
  local v47 = tonumber(p20) or 0

  if v47 >= 1000000000000000 then
    return string.format("%.2fQa", v47 / 1000000000000000)
  elseif v47 >= 1000000000000 then
    return string.format("%.2fT", v47 / 1000000000000)
  elseif v47 >= 1000000000 then
    return string.format("%.2fB", v47 / 1000000000)
  elseif v47 >= 1000000 then
    return string.format("%.2fM", v47 / 1000000)
  else
    if v47 >= 1000 then
      return string.format("%.2fK", v47 / 1000)
    end

    return tostring(math.floor(v47))
  end
end

local function f20(p21)
  local v48 = tonumber(p21) or 0

  if v48 >= 1000 then
    return f19(v48) .. " KG"
  end

  if v48 >= 10 then
    return string.format("%.1f KG", v48)
  end

  return string.format("%.2f KG", v48)
end

local v49 = {}

local function f21(p22)
  if not p22 then
    return {}
  elseif v49[p22] then
    return v49[p22]
  else
    if v11 and v11.GetOdds then
      local v50, v51 = pcall(function() return v11.GetOdds(p22) end)

      if v50 and type(v51) == "table" then
        local v52 = {}

        for index14, value16 in ipairs(v51) do
          if value16.PetName and value16.Chance then
            v52[value16.PetName] = value16.Chance
          end
        end

        v49[p22] = v52
        return v52
      end

      return {}
    end

    return {}
  end
end

local function f22(p23)
  if not p23 or p23 == "" then
    return false, "No Target"
  else
    local savedData = localPlayer2:FindFirstChild("SavedData")
    local ownedPets = savedData and savedData:FindFirstChild("OwnedPets")

    if ownedPets and ownedPets.Value then
      if string.find(tostring(ownedPets.Value), p23 .. ",") then
        return true, "SavedData"
      end
    end

    local backpack = localPlayer2:FindFirstChild("Backpack")

    if backpack then
      for index15, value17 in ipairs(backpack:GetChildren()) do
        if value17:IsA("Tool") then
          local petKey = value17:GetAttribute("PetKey")
          local match = value17.Name:match("^(.-) %[") or value17.Name

          if petKey and string.find(petKey, p23) or match == p23 then
            return true, "Backpack"
          end
        end
      end
    end

    local character4 = localPlayer2.Character

    if character4 then
      for index16, value18 in ipairs(character4:GetChildren()) do
        if value18:IsA("Tool") then
          local petKey2 = value18:GetAttribute("PetKey")
          local match2 = value18.Name:match("^(.-) %[") or value18.Name

          if petKey2 and string.find(petKey2, p23) or match2 == p23 then
            return true, "Character"
          end
        end
      end
    end

    local v53 = f12()

    if v53 and v53:FindFirstChild("Pets") then
      for index17, value19 in ipairs(v53.Pets:GetChildren()) do
        if (value19.Name:match("^(.-) %[") or value19.Name) == p23 then
          return true, "Plot"
        end
      end

      return false, "Not Owned"
    end

    return false, "Not Owned"
  end
end

local v54 = {
  Horse = {
    ["Asteroid Egg"] = true,
    ["Skull Egg"] = true,
    ["Dominus Egg"] = true,
    ["Crystal Egg"] = true,
    ["Diamond Egg"] = true,
    ["Golden Egg"] = true,
  },
  Fox = { ["Soul Egg"] = true, ["Sinister Egg"] = true, ["Flaming Egg"] = true },
  Unicorn = {
    ["Cherub Egg"] = true,
    ["Solaris Egg"] = true,
    ["Blackhole Egg"] = true,
    ["Galaxy Egg"] = true,
  },
  Phoenix = { ["Cherub Egg"] = true, ["Solaris Egg"] = true, ["Blackhole Egg"] = true },
  Kitsune = { ["Cherub Egg"] = true, ["Solaris Egg"] = true, ["Blackhole Egg"] = true },
  Dragon = { ["Cherub Egg"] = true, ["Solaris Egg"] = true, ["Blackhole Egg"] = true },
}

local function f23(p24)
  local v55 = not p24
  local v56, placeTime, weight, v57, isReady, v58, v59

  if v55 or not p24.Parent then
    return nil
  else
    local eggKey = p24:GetAttribute("EggKey")
    local eggData = p24:FindFirstChild("EggData")

    placeTime = eggData and eggData:FindFirstChild("PlaceTime")
      and tonumber(eggData.PlaceTime.Value)

    weight = eggData and eggData:FindFirstChild("Weight") and tonumber(eggData.Weight.Value)
      or 1

    v56 = v10 and v10[p24.Name] or v9[p24.Name]

    local plotEggsTracker = localPlayer2:FindFirstChild("PlayerGui")
      and localPlayer2.PlayerGui:FindFirstChild("Main")
      and localPlayer2.PlayerGui.Main:FindFirstChild("PlotEggsTracker")

    local holder = plotEggsTracker and plotEggsTracker:FindFirstChild("Holder")
    local findFirstChild = eggKey and holder and holder:FindFirstChild(eggKey)
    local findFirstChild2 = findFirstChild and findFirstChild:FindFirstChild("Open", true)
    local findFirstChild3 = findFirstChild and findFirstChild:FindFirstChild("TimeLeft", true)

    if findFirstChild2 and findFirstChild2.Visible
      or findFirstChild3 and findFirstChild3.Text
        and string.lower(findFirstChild3.Text):find("ready") ~= nil then
      return {
        isReady = true,
        timeStr = "Ready to Hatch!",
        timeLeft = 0,
        eggKey = eggKey,
      }
    end

    v57 = nil
    isReady = false
    v58 = nil
    v59 = false

    if placeTime and v56 and v56.GrowthTime and v13 and v13.GrowthTimeFor and v16
      and v16.GrowthElapsed then
      pcall(function()
        local v60 = v13.GrowthTimeFor(v56.GrowthTime, weight)
        local v62 = v16.GrowthElapsed(placeTime)
        v57 = math.max(0, v60 - v62)

        if math.clamp(v62 / math.max(v60, 1), 0, 1) >= 1 or v57 <= 0 then
          isReady = true
          v58 = "Ready to Hatch!"
        else
          local v63 = math.floor(v57 / 3600)
          local v64 = math.floor(v57 % 3600 / 60)
          local v65 = math.floor(v57 % 60)

          v58 = v63 > 0 and string.format("%d:%02d:%02d", v63, v64, v65)
            or string.format("%d:%02d", v64, v65)
        end

        v59 = true
      end)
    end

    if not v59 and placeTime and v56 and v56.GrowthTime then
      local getServerTimeNow2 = workspace:GetServerTimeNow()
      local v66 = math.max(0, getServerTimeNow2 - placeTime)
      local v67 = v56.GrowthTime * (weight or 1)
      v57 = math.max(0, v67 - v66)

      if math.clamp(v66 / math.max(v67, 1), 0, 1) >= 1 or v57 <= 0 then
        isReady = true
        v58 = "Ready to Hatch!"
      else
        local v68 = math.floor(v57 / 3600)
        local v69 = math.floor(v57 % 3600 / 60)
        local v70 = math.floor(v57 % 60)

        v58 = v68 > 0 and string.format("%d:%02d:%02d", v68, v69, v70)
          or string.format("%d:%02d", v69, v70)
      end

      v59 = true
    end

    if not v59 then
      if findFirstChild3 and findFirstChild3.Text and findFirstChild3.Text ~= "" then
        v58 = findFirstChild3.Text

        if string.lower(v58):find("ready") then
          isReady = true
          v58 = "Ready to Hatch!"
          v57 = 0
        end

        v59 = true
      else
        local findFirstChild4 = p24:FindFirstChild("HatchingUI", true)

        local timer = findFirstChild4
        timer = findFirstChild4 and findFirstChild4:FindFirstChild("Timer")

        if timer and timer.Text and timer.Text ~= "" then
          v58 = timer.Text

          if string.find(string.lower(tostring(v58)), "ready") then
            isReady = true
            v58 = "Ready to Hatch!"
            v57 = 0
          end

          v59 = true
        else
          v58 = "Incubating..."
        end
      end
    end

    return {
      isReady = isReady,
      timeStr = v58 or "Incubating...",
      timeLeft = v57,
      eggKey = eggKey,
    }
  end
end

local f24

local function f25()
  local savedData2 = localPlayer2:FindFirstChild("SavedData")

  local value20 = savedData2 and savedData2:FindFirstChild("Rebirths")
    and savedData2.Rebirths.Value

  local value21 = savedData2
  local v71 = value20 or 0

  if savedData2 then
    value21 = savedData2:FindFirstChild("Cash") and savedData2.Cash.Value
  end

  local v72 = value21 or 0
  local cap = v12 and v12.Cap or 6
  local v73 = v71 >= cap
  local v74 = v71 + 1
  local v75 = 1000000

  if v12 and v12.RiggedCost and v12.RiggedCost[v74] then
    v75 = v12.RiggedCost[v74]
  end

  local text = ""

  local rebirth2 = localPlayer2:FindFirstChild("PlayerGui")
    and localPlayer2.PlayerGui:FindFirstChild("Main")
    and localPlayer2.PlayerGui.Main:FindFirstChild("Rebirth")

  if rebirth2 then
    local findFirstChild5 = rebirth2:FindFirstChild("Segment2", true)

    local findFirstChild6 = findFirstChild5
    findFirstChild6 = findFirstChild5 and findFirstChild5:FindFirstChild("pEThOLDER", true)

    local findFirstChild7 = findFirstChild6
    findFirstChild7 = findFirstChild6 and findFirstChild6:FindFirstChild("PetName", true)

    if findFirstChild7 and findFirstChild7.Text and findFirstChild7.Text ~= ""
      and findFirstChild7.Text ~= "PetName" then
      text = findFirstChild7.Text
    end
  end

  local v76 = { "Horse", "Fox", "Unicorn", "Phoenix", "Kitsune", "Dragon" }

  if text == "" and v74 <= #v76 then
    text = v76[v74]
  end

  local v77 = false
  local petLoc = "N/A"

  if text ~= "" then
    v77, petLoc = f22(text)
  end

  local incubatingOdds = 0
  local isIncubating = false
  local incubatingEggName, incubatingTime

  if text ~= "" and not v77 then
    isIncubating, incubatingEggName, incubatingOdds, incubatingTime = f24(text)
  end

  local canRebirth = not v73 and v77 and v72 >= v75

  return {
    currentRebirth = v71,
    nextTier = v74,
    maxCap = cap,
    isMaxCap = v73,
    currentCash = v72,
    reqCash = v75,
    hasCash = v72 >= v75,
    reqPet = text,
    hasPet = v77,
    petLoc = petLoc,
    isIncubating = isIncubating,
    incubatingEggName = incubatingEggName,
    incubatingOdds = incubatingOdds,
    incubatingTime = incubatingTime,
    canRebirth = canRebirth,
  }
end

function f24(p25)
  if not p25 or p25 == "" then
    return false
  else
    local v78 = f12()
    local eggs3 = v78 and v78:FindFirstChild("Eggs")

    if eggs3 then
      for index18, value22 in ipairs(eggs3:GetChildren()) do
        local name = value22.Name
        local v79 = v54[p25]
        local v80 = f21((f5(name)))[p25] or 0
        local v81 = v79 and v54[p25][name] == true

        if v80 and v80 > 0 or v81 then
          local v82 = f23(value22)
          return true, name, v80, v82 and v82.timeStr or "Incubating..."
        end
      end
    end

    local basket = localPlayer2:FindFirstChild("Basket")

    if basket then
      for index19, value23 in ipairs(basket:GetChildren()) do
        local egg = value23:GetAttribute("Egg") or value23.Name
        local v83 = f21((f5(egg)))[p25] or 0
        local v84 = v54[p25] and v54[p25][egg] == true

        if v83 and v83 > 0 or v84 then
          return true, egg, v83, "In Basket"
        end
      end
    end

    local v85 = {}

    if localPlayer2:FindFirstChild("Backpack") then
      for index20, value24 in ipairs(localPlayer2.Backpack:GetChildren()) do
        table.insert(v85, value24)
      end
    end

    if localPlayer2.Character then
      for index21, value25 in ipairs(localPlayer2.Character:GetChildren()) do
        table.insert(v85, value25)
      end
    end

    for index22, value26 in ipairs(v85) do
      if value26:IsA("Tool") and (value26:HasTag("Egg") or string.find(value26.Name, "Egg")) then
        local match3 = value26.Name:match("^(.-) %[") or value26.Name
        local v86 = f21((f5(match3)))[p25] or 0
        local v87 = v54[p25] and v54[p25][match3] == true

        if v86 and v86 > 0 or v87 then
          return true, match3, v86, "In Backpack"
        end
      end
    end

    return false
  end
end

local function f26()
  local v88 = f25()

  if not v88.canRebirth or v88.isMaxCap then
    return false
  end

  if rebirth then
    rebirth:FireServer()
  end

  pcall(function()
    local rebirth3 = localPlayer2.PlayerGui.Main.Rebirth.Rebirth

    if getconnections then
      for key3, value27 in pairs(getconnections(rebirth3.Activated)) do
        value27:Fire()
      end
    end
  end)

  return true
end

local function f27(p26, p27)
  if not p26 then
    return false
  else
    local v89 = (p26.Position - vector).Magnitude < 1500
    local v90 = false
    local basket2 = localPlayer2:FindFirstChild("Basket")

    if basket2 then
      for index23, value28 in ipairs(basket2:GetChildren()) do
        if value28.Name == "Volcanic Egg" or value28:GetAttribute("Egg") == "Volcanic Egg"
          or value28:GetAttribute("Escaping") == true
          or value28:GetAttribute("VolcanoUntil") ~= nil then
          v90 = true
          break
        end
      end
    end

    if v89 and (v90 or localPlayer2:GetAttribute("InVolcano") == true) then
      v33.Status = "Escaping Volcano through Lair Door..."

      p26.AssemblyLinearVelocity = Vector3.zero
      p26.AssemblyAngularVelocity = Vector3.zero
      p26.CFrame = cframe2

      task.wait(0.08)
      local volcano = workspaceService:FindFirstChild("Volcano")

      local volcanoEntrance = volcano
      volcanoEntrance = volcano and volcano:FindFirstChild("VolcanoEntrance")

      local volcanoValidate = volcano
      volcanoValidate = volcano and volcano:FindFirstChild("VolcanoValidate")

      if firetouchinterest then
        if volcanoValidate then
          pcall(firetouchinterest, p26, volcanoValidate, 0)
        end

        if volcanoEntrance then
          pcall(firetouchinterest, p26, volcanoEntrance, 0)
        end
      end

      p26.AssemblyLinearVelocity = Vector3.zero
      p26.AssemblyAngularVelocity = Vector3.zero
      p26.CFrame = cframe

      if firetouchinterest then
        if volcanoValidate then
          pcall(firetouchinterest, p26, volcanoValidate, 1)
        end

        if volcanoEntrance then
          pcall(firetouchinterest, p26, volcanoEntrance, 1)
        end
      end

      local v91 = os.clock()

      while os.clock() - v91 < 0.5 do
        if localPlayer2:GetAttribute("InVolcano") ~= true then
          break
        end

        task.wait(0.04)
      end

      v33.Status = "Volcano Escaped!"
      return true
    end

    return false
  end
end

runService.Stepped:Connect(function()
  if roxyHubState.NoClip or v33.IsFarming or v33.CurrentTween ~= nil then
    local character5 = localPlayer2.Character

    if character5 then
      for index24, value29 in ipairs(character5:GetDescendants()) do
        if value29:IsA("BasePart") then
          if value29.CanCollide then
            value29.CanCollide = false
          end

          if v33.CurrentTween ~= nil then
            value29.AssemblyLinearVelocity = Vector3.zero
            value29.AssemblyAngularVelocity = Vector3.zero
          end
        end
      end
    end
  end
end)

userInputService.JumpRequest:Connect(function()
  if roxyHubState.InfiniteJump then
    local v92, v93, v94 = f13()

    if v94 then
      v94:ChangeState(Enum.HumanoidStateType.Jumping)
    end
  end
end)

runService.RenderStepped:Connect(function()
  if roxyHubState.SpeedModEnabled and roxyHubState.SpeedMultiplier > 1 then
    local v95, v96, v97 = f13()

    if v97 then
      v97.WalkSpeed = 92 * roxyHubState.SpeedMultiplier
    end
  end
end)

local v98 = {}
local v99 = {}
local f28
local v103_ESPFolder
local v104_LocalTracerAttachment

local function f29()
  local keys = {}

  for key4 in pairs(v98) do
    table.insert(keys, key4)
  end

  for _, key4 in ipairs(keys) do
    pcall(function() f28(key4) end)
  end

  local renderedEggs2 = workspaceService:FindFirstChild("RenderedEggs")

  if renderedEggs2 then
    for _, value31 in ipairs(renderedEggs2:GetChildren()) do
      local roxyEggESP2 = value31:FindFirstChild("RoxyEggESP")

      if roxyEggESP2 then
        pcall(function() roxyEggESP2:Destroy() end)
      end
    end
  end

  for _, value32 in ipairs(v99) do
    pcall(function()
      if value32.Enabled ~= nil then
        value32.Enabled = false
      end
      if value32.Visible ~= nil then
        value32.Visible = false
      end
      if value32.Destroy then
        value32:Destroy()
      elseif value32.Remove then
        value32:Remove()
      end
    end)
  end

  table.clear(v99)
  table.clear(v98)

  if v104_LocalTracerAttachment then
    pcall(function() v104_LocalTracerAttachment:Destroy() end)
    v104_LocalTracerAttachment = nil
  end

  local espFolder = workspaceService:FindFirstChild("RoxyHub_ESP")
  if espFolder then
    pcall(function() espFolder:Destroy() end)
  end
  v103_ESPFolder = nil
end

function f28(p28)
  local v101 = v98[p28]

  if v101 then
    for _, object in ipairs({
      v101.Billboard,
      v101.Highlight,
      v101.Tracer,
      v101.TracerAttachment,
      v101.Anchor,
    }) do
      if object then
        pcall(function() object:Destroy() end)
      end
    end

    v98[p28] = nil
  end

  local roxyEggESP3

  if p28 and p28.Parent then
    roxyEggESP3 = p28:FindFirstChild("RoxyEggESP")

    if roxyEggESP3 then
      pcall(function() roxyEggESP3:Destroy() end)
    end
  end
end

local v102 = setmetatable({}, { __mode = "k" })

local function f30(p29)
  local v103

  if not p29 then
    return 0
  else
    local v104 = v102[p29]

    if v104 ~= nil then
      return v104
    else
      local position4 = p29:GetPivot().Position
      local activeEggs2 = (replicatedStorage:FindFirstChild("ServerData") or replicatedStorage):FindFirstChild("ActiveEggs")

      if activeEggs2 then
        for index27, value33 in ipairs(activeEggs2:GetChildren()) do
          local position5 = value33:GetAttribute("Position")

          if position5 and (position5 - position4).Magnitude < 10 then
            v103 = tonumber(value33:GetAttribute("Weight")) or 0
            local v105 = v103

            if v13 and v13.ShownEggKG then
              local v106, v107 = pcall(function() return v13.ShownEggKG(v103) end)

              if v106 and type(v107) == "number" then
                v105 = v107
              end
            end

            local v108 = math.floor(v105 * 10 + 0.5) / 10
            v102[p29] = v108
            return v108, value33
          end
        end

        v102[p29] = 0
        return 0, nil
      end

      v102[p29] = 0
      return 0, nil
    end
  end
end

local function f31(p30, p31)
  if not p30 then
    return false
  end

  local create3

  if localPlayer2:GetAttribute("InVolcano") == true
    and localPlayer2:GetAttribute("VolcanoValidated") == true then
    return true
  else
    v33.Status = "Warping to Volcano Sky Platform..."
    f7()

    p30.AssemblyLinearVelocity = Vector3.zero
    p30.AssemblyAngularVelocity = Vector3.zero
    p30.CFrame = cframe

    task.wait(0.12)
    local volcano2 = workspaceService:FindFirstChild("Volcano")
    local volcanoEntrance2 = volcano2 and volcano2:FindFirstChild("VolcanoEntrance")
    local volcanoValidate2 = volcano2 and volcano2:FindFirstChild("VolcanoValidate")
    v33.Status = "Tweening into Cave Doors..."
    local v109 = math.clamp((cframe2.Position - p30.Position).Magnitude / 40, 0.6, 1.6)

    create3 = tweenService:Create(p30, TweenInfo.new(v109, Enum.EasingStyle.Linear), {
      CFrame = cframe2,
    })

    create3:Play()

    local v110 = os.clock()

    while os.clock() - v110 < v109 + 0.5 do
      if firetouchinterest then
        if volcanoEntrance2 then
          pcall(firetouchinterest, p30, volcanoEntrance2, 0)
        end

        if volcanoValidate2 then
          pcall(firetouchinterest, p30, volcanoValidate2, 0)
        end
      end

      if localPlayer2:GetAttribute("InVolcano") == true
        and localPlayer2:GetAttribute("VolcanoValidated") == true then
        break
      end

      task.wait(0.03)
    end

    pcall(function() create3:Cancel() end)

    if firetouchinterest then
      if volcanoEntrance2 then
        pcall(firetouchinterest, p30, volcanoEntrance2, 1)
      end

      if volcanoValidate2 then
        pcall(firetouchinterest, p30, volcanoValidate2, 1)
      end
    end

    p30.AssemblyLinearVelocity = Vector3.zero
    p30.AssemblyAngularVelocity = Vector3.zero

    task.wait(0.05)
    return localPlayer2:GetAttribute("InVolcano") == true
  end
end

local function f35_ESPFolder()
  if v103_ESPFolder and v103_ESPFolder.Parent then
    return v103_ESPFolder
  end

  local existing = workspaceService:FindFirstChild("RoxyHub_ESP")
  if existing and existing:IsA("Folder") then
    v103_ESPFolder = existing
  else
    v103_ESPFolder = Instance.new("Folder")
    v103_ESPFolder.Name = "RoxyHub_ESP"
    v103_ESPFolder.Parent = workspaceService
  end

  return v103_ESPFolder
end

local function f36_ESPMinWeight()
  local minimum = roxyHubState.ESP_MinRarity

  if minimum == "All Eggs" then
    return 0
  elseif minimum == "Rare & Above" then
    return v17.Rare or 500
  elseif minimum == "Epic & Above" then
    return v17.Epic or 600
  elseif minimum == "Legendary & Above" then
    return v17.Legendary or 700
  elseif minimum == "Mythic & Above" then
    return v17.Mythic or 800
  elseif minimum == "Divine & Above" then
    return v17.Divine or 900
  elseif minimum == "Ethereal Only" then
    return v17.Ethereal or 1000
  end

  return v17.Rare or 500
end

local function f37_ESPVisualPart(egg, entry)
  if entry and entry.VisualPart and entry.VisualPart.Parent then
    return entry.VisualPart
  end

  local part = nil

  if egg.PrimaryPart and egg.PrimaryPart:IsA("BasePart") then
    part = egg.PrimaryPart
  end

  if not part then
    local named = egg:FindFirstChild("Hitbox", true)
    if named and named:IsA("BasePart") then
      part = named
    end
  end

  if not part then
    part = egg:FindFirstChildWhichIsA("BasePart", true)
  end

  if part then
    entry.VisualPart = part
    return part
  end

  local folder = f35_ESPFolder()
  local anchor = Instance.new("Part")
  anchor.Name = "RoxyESPAnchor"
  anchor.Size = Vector3.new(0.2, 0.2, 0.2)
  anchor.Transparency = 1
  anchor.Anchored = true
  anchor.CanCollide = false
  anchor.CanTouch = false
  anchor.CanQuery = false
  anchor.CastShadow = false
  anchor.CFrame = egg:GetPivot()
  anchor.Parent = folder
  entry.Anchor = anchor
  entry.VisualPart = anchor

  return anchor
end

local function f38_ESPLocalAttachment()
  local character, root = f13()

  if not root or not root:IsA("BasePart") then
    return nil
  end

  if v104_LocalTracerAttachment and v104_LocalTracerAttachment.Parent ~= root then
    pcall(function() v104_LocalTracerAttachment:Destroy() end)
    v104_LocalTracerAttachment = nil
  end

  if not v104_LocalTracerAttachment then
    v104_LocalTracerAttachment = Instance.new("Attachment")
    v104_LocalTracerAttachment.Name = "RoxyESP_LocalTracer"
    v104_LocalTracerAttachment.Position = Vector3.new(0, 1.5, 0)
    v104_LocalTracerAttachment.Parent = root
  end

  return v104_LocalTracerAttachment
end

local function f39_ESPColor(rarity, mutation)
  if mutation and mutation ~= "" then
    return v23[mutation] or v18[rarity] or v18.Unknown
  end

  return v18[rarity] or v18.Unknown
end

local function f40_ESPText(egg, rarity, eggWeight, mutation, distance)
  local name = egg.Name
  local first = string.format("%s [%s]", name, rarity)
  local details = {}

  if eggWeight and eggWeight > 0 then
    table.insert(details, f20(eggWeight))
  end

  if mutation and mutation ~= "" then
    table.insert(details, tostring(mutation))
  end

  table.insert(details, string.format("%d studs", math.floor(distance + 0.5)))

  return first, table.concat(details, " | ")
end

local function f41_ESPCreateHighlight(egg, entry)
  if not roxyHubState.ESP_Highlights then
    if entry.Highlight then
      entry.Highlight.Enabled = false
    end
    return
  end

  local highlight = entry.Highlight

  if not highlight or not highlight.Parent then
    highlight = Instance.new("Highlight")
    highlight.Name = "RoxyESPHighlight"
    highlight.Adornee = egg
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.82
    highlight.OutlineTransparency = 0.04
    highlight.Enabled = true
    highlight.Parent = f35_ESPFolder()
    entry.Highlight = highlight
  else
    highlight.Enabled = true
    highlight.Adornee = egg
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
  end
end

local function f42_ESPCreateBillboard(egg, entry, visualPart, title, details, color)
  if not roxyHubState.ESP_Billboards then
    if entry.Billboard then
      entry.Billboard.Enabled = false
    end
    return
  end

  local billboard = entry.Billboard

  if not billboard or not billboard.Parent then
    billboard = Instance.new("BillboardGui")
    billboard.Name = "RoxyESPBillboard"
    billboard.Size = UDim2.fromOffset(210, 52)
    billboard.StudsOffset = Vector3.new(0, 3.75, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = math.max(100, tonumber(roxyHubState.ESP_MaxDistance) or 5000)
    billboard.ResetOnSpawn = false
    billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    billboard.Adornee = visualPart
    billboard.Enabled = true
    billboard.Parent = f35_ESPFolder()

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.TextStrokeTransparency = 0.25
    titleLabel.TextColor3 = color
    titleLabel.Text = title
    titleLabel.Parent = billboard

    local detailLabel = Instance.new("TextLabel")
    detailLabel.Name = "Details"
    detailLabel.BackgroundTransparency = 1
    detailLabel.Size = UDim2.new(1, 0, 0, 22)
    detailLabel.Position = UDim2.new(0, 0, 0, 24)
    detailLabel.Font = Enum.Font.GothamMedium
    detailLabel.TextSize = 12
    detailLabel.TextXAlignment = Enum.TextXAlignment.Center
    detailLabel.TextStrokeTransparency = 0.35
    detailLabel.TextColor3 = Color3.fromRGB(235, 240, 255)
    detailLabel.Text = details
    detailLabel.Parent = billboard

    entry.Billboard = billboard
    entry.TitleLabel = titleLabel
    entry.DetailLabel = detailLabel
  end

  billboard.Adornee = visualPart
  billboard.Enabled = true
  billboard.MaxDistance = math.max(100, tonumber(roxyHubState.ESP_MaxDistance) or 5000)
  entry.TitleLabel.Text = title
  entry.TitleLabel.TextColor3 = color
  entry.DetailLabel.Text = details
end

local function f43_ESPCreateTracer(entry, visualPart, color)
  if not roxyHubState.ESP_Tracers then
    if entry.Tracer then
      entry.Tracer.Enabled = false
    end
    return
  end

  local localAttachment = f38_ESPLocalAttachment()

  if not localAttachment or not visualPart or not visualPart:IsA("BasePart") then
    if entry.Tracer then
      entry.Tracer.Enabled = false
    end
    return
  end

  if not entry.TracerAttachment or entry.TracerAttachment.Parent ~= visualPart then
    if entry.TracerAttachment then
      pcall(function() entry.TracerAttachment:Destroy() end)
    end

    local tracerAttachment = Instance.new("Attachment")
    tracerAttachment.Name = "RoxyESP_EggTracer"
    tracerAttachment.Parent = visualPart
    entry.TracerAttachment = tracerAttachment
  end

  local beam = entry.Tracer

  if not beam or not beam.Parent then
    beam = Instance.new("Beam")
    beam.Name = "RoxyESPTracer"
    beam.Attachment0 = localAttachment
    beam.Attachment1 = entry.TracerAttachment
    beam.FaceCamera = true
    beam.Width0 = 0.055
    beam.Width1 = 0.03
    beam.LightEmission = 1
    beam.Segments = 6
    beam.Transparency = NumberSequence.new(0.1)
    beam.Enabled = true
    beam.Parent = f35_ESPFolder()
    entry.Tracer = beam
  else
    beam.Attachment0 = localAttachment
    beam.Attachment1 = entry.TracerAttachment
    beam.Enabled = true
  end

  beam.Color = ColorSequence.new(color)
end

local function f44_ESPUpdateEgg(egg)
  if not egg or not egg.Parent or _G.RoxyHubInstanceId ~= roxyHubInstanceId then
    return
  end

  local _, root = f13()
  if not root then
    return
  end

  local entry = v98[egg]
  if not entry then
    entry = {}
    v98[egg] = entry
  end

  local rarity = f4(egg.Name)
  local rarityWeight = v17[rarity] or 0
  local distance = (egg:GetPivot().Position - root.Position).Magnitude
  local maxDistance = math.max(100, tonumber(roxyHubState.ESP_MaxDistance) or 5000)

  if rarityWeight < f36_ESPMinWeight() or distance > maxDistance then
    f28(egg)
    return
  end

  local eggWeight = f30(egg)
  local mutation = f9(egg)
  local color = f39_ESPColor(rarity, mutation)
  local visualPart = f37_ESPVisualPart(egg, entry)

  if entry.Anchor and entry.Anchor.Parent then
    entry.Anchor.CFrame = egg:GetPivot()
  end

  f41_ESPCreateHighlight(egg, entry)

  local title, details = f40_ESPText(egg, rarity, eggWeight, mutation, distance)
  f42_ESPCreateBillboard(egg, entry, visualPart, title, details, color)
  f43_ESPCreateTracer(entry, visualPart, color)

  if entry.Billboard and entry.Billboard.Parent then
    entry.Billboard.Adornee = visualPart
  end

  if entry.Highlight and entry.Highlight.Parent then
    entry.Highlight.FillColor = color
    entry.Highlight.OutlineColor = color
    entry.Highlight.Enabled = roxyHubState.ESP_Highlights == true
  end
end

local function f45_ESPRefresh()
  if _G.RoxyHubInstanceId ~= roxyHubInstanceId then
    return
  end

  if not roxyHubState.ESP_Enabled then
    f29()
    return
  end

  local renderedEggs3 = workspaceService:FindFirstChild("RenderedEggs")
  if not renderedEggs3 then
    f29()
    return
  end

  local seen = {}

  for _, egg in ipairs(renderedEggs3:GetChildren()) do
    if egg and egg.Parent then
      seen[egg] = true
      pcall(f44_ESPUpdateEgg, egg)
    end
  end

  for egg in pairs(v98) do
    if not seen[egg] or not egg or not egg.Parent then
      f28(egg)
    end
  end
end

-- Re-render instantly when an egg spawns instead of waiting for the polling interval.
do
  local renderedEggs3 = workspaceService:FindFirstChild("RenderedEggs")

  if renderedEggs3 then
    table.insert(_G.RoxyHubConnections, renderedEggs3.ChildAdded:Connect(function(child)
      if roxyHubState.ESP_Enabled then
        task.defer(function()
          if child and child.Parent then
            pcall(f44_ESPUpdateEgg, child)
          end
        end)
      end
    end))
  end

  table.insert(_G.RoxyHubConnections, workspaceService.ChildAdded:Connect(function(child)
    if child.Name == "RenderedEggs" then
      table.insert(_G.RoxyHubConnections, child.ChildAdded:Connect(function(egg)
        if roxyHubState.ESP_Enabled then
          task.defer(function()
            if egg and egg.Parent then
              pcall(f44_ESPUpdateEgg, egg)
            end
          end)
        end
      end))
    end
  end))
end

task.spawn(function()
  while _G.RoxyHubInstanceId == roxyHubInstanceId do
    task.wait(0.35)
    pcall(f45_ESPRefresh)
  end

  f29()
end)

local function f32(p32)
  return p32:FindFirstChildWhichIsA("ProximityPrompt", true)
end

local function f33()
  local renderedEggs4 = workspaceService:FindFirstChild("RenderedEggs")
  local gsub

  if not renderedEggs4 then
    return nil
  else
    local v111, v112 = f13()

    if not v112 then
      return nil
    else
      gsub = nil

      if roxyHubState.TargetSpecificEgg
        and roxyHubState.TargetSpecificEgg ~= "Any Egg (Use Rarity Filter)" then
        gsub = roxyHubState.TargetSpecificEgg:gsub("%s*%[.-%]", "")
      end

      local function f34(p33, p34)
        if gsub and gsub ~= "" then
          return p33 == gsub
        end

        return roxyHubState.AllowedRarities and roxyHubState.AllowedRarities[p34] == true
      end

      if roxyHubState.AutoFarm and roxyHubState.PrioritizeMutations then
        local v113 = {}

        for index29, value35 in ipairs(renderedEggs4:GetChildren()) do
          local name2 = value35.Name
          local v114 = f4(name2)

          if f34(name2, v114) then
            local v115 = f9(value35)

            if v115 and f6(v115) then
              local v116 = f32(value35)

              if v116 then
                local v117 = f30(value35)
                local v118 = true

                if roxyHubState.MinEggWeight and roxyHubState.MinEggWeight > 0 and v117 > 0
                  and v117 < roxyHubState.MinEggWeight then
                  v118 = false
                end

                if v118 then
                  local getPivot = value35:GetPivot()

                  table.insert(v113, {
                    Model = value35,
                    Name = name2,
                    Rarity = v114,
                    Prompt = v116,
                    Position = getPivot.Position,
                    Distance = (getPivot.Position - v112.Position).Magnitude,
                    Luck = f5(name2),
                    Weight = v17[v114] or 0,
                    EggWeight = v117,
                    Mutation = v115,
                    MutationWeight = v22[v115] or 1000,
                  })
                end
              end
            end
          end
        end

        if #v113 > 0 then
          table.sort(v113, function(p35, p36)
            if p35.MutationWeight ~= p36.MutationWeight then
              return p35.MutationWeight > p36.MutationWeight
            elseif p35.Weight ~= p36.Weight then
              return p35.Weight > p36.Weight
            else
              if roxyHubState.PrioritizeHeaviest
                and math.abs(p35.EggWeight - p36.EggWeight) > 0.05 then
                return p35.EggWeight > p36.EggWeight
              end

              return p35.Distance < p36.Distance
            end
          end)

          return v113[1]
        end
      end

      if roxyHubState.AutoFarm and roxyHubState.WeatherEggWait then
        local v119 = f8()

        if v119 and v119.Variant then
          local v120 = v24[v119.Variant]

          if not v120 or f6(v120) then
            local getServerTimeNow3 = workspaceService:GetServerTimeNow()

            local v121 = v119.EndsAt
                and math.max(0, math.floor(v119.EndsAt - getServerTimeNow3))
              or 0

            if v121 > 0 then
              local v122 = false

              for index30, value36 in ipairs(renderedEggs4:GetChildren()) do
                local name3 = value36.Name

                if f34(name3, (f4(name3))) then
                  v122 = true
                  break
                end
              end

              if v122 then
                return {
                  IsWaitingWeather = true,
                  StormVariant = v119.Variant,
                  MutationType = v120 or "Mutation",
                  TimeLeft = v121,
                }
              end
            end
          end
        end
      end

      local allowedRarities = roxyHubState.AllowedRarities

      local v123 = allowedRarities
      v123 = allowedRarities and roxyHubState.AllowedRarities.Ethereal == true

      local v124 = v123
      v124 = v123 or gsub and f4(gsub) == "Ethereal"

      if roxyHubState.AutoFarm and v124 then
        local v125 = {}

        for index31, value37 in ipairs(renderedEggs4:GetChildren()) do
          local name4 = value37.Name
          local v126 = f4(name4)

          if v126 == "Ethereal" and f34(name4, v126) then
            local v127 = f32(value37)

            if v127 then
              local v128 = f30(value37)
              local v129 = true

              if roxyHubState.MinEggWeight and roxyHubState.MinEggWeight > 0 and v128 > 0
                and v128 < roxyHubState.MinEggWeight then
                v129 = false
              end

              if v129 then
                local getPivot2 = value37:GetPivot()

                table.insert(v125, {
                  Model = value37,
                  Name = name4,
                  Rarity = v126,
                  Prompt = v127,
                  Position = getPivot2.Position,
                  Distance = (getPivot2.Position - v112.Position).Magnitude,
                  Luck = f5(name4),
                  Weight = v17[v126] or 1000,
                  EggWeight = v128,
                })
              end
            end
          end
        end

        if #v125 > 0 then
          if roxyHubState.PrioritizeHeaviest then
            table.sort(v125, function(p37, p38)
              if math.abs(p37.EggWeight - p38.EggWeight) > 0.05 then
                return p37.EggWeight > p38.EggWeight
              end

              return p37.Distance < p38.Distance
            end)
          else
            table.sort(v125, function(p39, p40) return p39.Distance < p40.Distance end)
          end

          return v125[1]
        end
      end

      if roxyHubState.AutoRebirth and roxyHubState.PrioritizeRebirthPet then
        local v130 = f25()

        if v130 and not v130.isMaxCap and not v130.hasPet and v130.reqPet and v130.reqPet ~= "" then
          if not v130.isIncubating then
            local v131 = {}

            for index32, value38 in ipairs(renderedEggs4:GetChildren()) do
              local v132 = f32(value38)

              if v132 then
                local name5 = value38.Name
                local v133 = false
                local v134 = f5(name5)
                local v135 = f21(v134)[v130.reqPet] or 0

                if v54[v130.reqPet] and v54[v130.reqPet][name5] then
                  v133 = true
                end

                if v135 > 0 or v133 then
                  local getPivot3 = value38:GetPivot()
                  local v136 = f4(name5)

                  table.insert(v131, {
                    Model = value38,
                    Name = name5,
                    Rarity = v136,
                    Prompt = v132,
                    Position = getPivot3.Position,
                    Distance = (getPivot3.Position - v112.Position).Magnitude,
                    Luck = v134,
                    Weight = v17[v136] or 0,
                    PetChance = v135,
                    IsFallback = v133,
                  })
                end
              end
            end

            if #v131 > 0 then
              table.sort(v131, function(p41, p42)
                if math.abs(p41.PetChance - p42.PetChance) > 1e-7 then
                  return p41.PetChance > p42.PetChance
                end

                if p41.IsFallback ~= p42.IsFallback then
                  return p41.IsFallback == true
                end

                return p41.Distance < p42.Distance
              end)

              local v137 = v131[1]

              v33.RebirthTargetPet = v130.reqPet
              v33.RebirthEggName = v137.Name
              v33.RebirthEggChance = v137.PetChance

              return v137
            end
          end
        end
      end

      if not roxyHubState.AutoFarm then
        return nil
      else
        local v138 = {}

        for index33, value39 in ipairs(renderedEggs4:GetChildren()) do
          local name6 = value39.Name
          local v139 = f4(name6)

          if f34(name6, v139) then
            local v140 = f32(value39)

            if v140 then
              local v141 = f30(value39)
              local v142 = true

              if roxyHubState.MinEggWeight and roxyHubState.MinEggWeight > 0 and v141 > 0
                and v141 < roxyHubState.MinEggWeight then
                v142 = false
              end

              if v142 then
                local getPivot4 = value39:GetPivot()
                local luck = f5(name6)

                table.insert(v138, {
                  Model = value39,
                  Name = name6,
                  Rarity = v139,
                  Prompt = v140,
                  Position = getPivot4.Position,
                  Distance = (getPivot4.Position - v112.Position).Magnitude,
                  Luck = luck,
                  Weight = v17[v139] or 0,
                  EggWeight = v141,
                })
              end
            end
          end
        end

        if #v138 == 0 then
          return nil
        else
          local farmPriority = roxyHubState.FarmPriority

          local priorityRarity = farmPriority

          priorityRarity = farmPriority
            or roxyHubState.PriorityRarity and "Highest Rarity First"
            or "Closest Distance First"

          if priorityRarity == "Heaviest Weight First" then
            table.sort(v138, function(p43, p44)
              if math.abs(p43.EggWeight - p44.EggWeight) > 0.05 then
                return p43.EggWeight > p44.EggWeight
              end

              if p43.Weight ~= p44.Weight then
                return p43.Weight > p44.Weight
              end

              return p43.Distance < p44.Distance
            end)
          elseif priorityRarity == "Highest Rarity First" then
            table.sort(v138, function(p45, p46)
              if p45.Weight ~= p46.Weight then
                return p45.Weight > p46.Weight
              end

              if roxyHubState.PrioritizeHeaviest
                and math.abs(p45.EggWeight - p46.EggWeight) > 0.05 then
                return p45.EggWeight > p46.EggWeight
              end

              return p45.Distance < p46.Distance
            end)
          elseif priorityRarity == "Closest Distance First" then
            table.sort(v138, function(p47, p48)
              if roxyHubState.PrioritizeHeaviest
                and math.abs(p47.EggWeight - p48.EggWeight) > 0.05 then
                return p47.EggWeight > p48.EggWeight
              end

              if p47.Distance ~= p48.Distance then
                return p47.Distance < p48.Distance
              end

              return p47.Weight > p48.Weight
            end)
          elseif priorityRarity == "Highest Luck First" then
            table.sort(v138, function(p49, p50)
              if p49.Luck ~= p50.Luck then
                return p49.Luck > p50.Luck
              end

              if roxyHubState.PrioritizeHeaviest
                and math.abs(p49.EggWeight - p50.EggWeight) > 0.05 then
                return p49.EggWeight > p50.EggWeight
              end

              return p49.Distance < p50.Distance
            end)
          else
            table.sort(v138, function(p51, p52) return p51.Distance < p52.Distance end)
          end

          return v138[1]
        end
      end
    end
  end
end

local function f35(p53, p54)
  if not p54 then
    v1109 = p53 and f32(p53)
  end

  pcall(function()
    if eggPickup and p53 then
      local activeEggs3 = replicatedStorage:FindFirstChild("ServerData")
          and replicatedStorage.ServerData:FindFirstChild("ActiveEggs")
        or replicatedStorage:FindFirstChild("ActiveEggs")

      if activeEggs3 then
        local getPivot5 = p53:GetPivot()
        local v143 = nil
        local v144 = 25

        for index34, value40 in ipairs(activeEggs3:GetChildren()) do
          local position6 = value40:GetAttribute("Position")

          if position6 then
            local magnitude = (position6 - getPivot5.Position).Magnitude

            if magnitude < v144 then
              v143 = value40
              v144 = magnitude
            end
          end
        end

        if v143 then
          eggPickup:FireServer(v143.Name)
        end
      end
    end
  end)
end

local function f36(p55, p56)
  local roxyFlightStabilizer2 = p55:FindFirstChild("RoxyFlightStabilizer")

  if not roxyFlightStabilizer2 then
    roxyFlightStabilizer2 = Instance.new("BodyVelocity")
    roxyFlightStabilizer2.Name = "RoxyFlightStabilizer"
    roxyFlightStabilizer2.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
    roxyFlightStabilizer2.Velocity = Vector3.zero
    roxyFlightStabilizer2.Parent = p55
  end

  if p56 then
    p56.PlatformStand = true
  end

  if p55 then
    p55.AssemblyLinearVelocity = Vector3.zero
    p55.AssemblyAngularVelocity = Vector3.zero
  end

  return roxyFlightStabilizer2
end

local f37

local function f38(p57)
  local v145

  if not roxyHubState.AutoMagmaDip then
    return false
  else
    local basket3 = localPlayer2:FindFirstChild("Basket")

    if not basket3 or #basket3:GetChildren() == 0 then
      return false
    else
      local v146, v147, v148 = f13()

      if not v147 or not v148 then
        return false
      end

      v145 = nil

      for index35, value41 in ipairs(basket3:GetChildren()) do
        if value41:GetAttribute("VolcanoDipped") ~= true
          and value41:GetAttribute("Delivering") ~= true then
          local mutation2 = value41:GetAttribute("Mutation")

          if mutation2 ~= "Eternal" and mutation2 ~= "Magma" then
            v145 = value41
            break
          end
        end
      end

      if not v145 then
        return false
      else
        if v33.CurrentTween then
          pcall(function() v33.CurrentTween:Cancel() end)
          v33.CurrentTween = nil
        end

        f37(v147, v148)
        v33.Status = "Warping directly to Volcano Top..."

        v147.AssemblyLinearVelocity = Vector3.zero
        v147.AssemblyAngularVelocity = Vector3.zero
        v147.CFrame = CFrame.new(vector)

        task.wait(0.2)

        if (v147.Position - vector).Magnitude > 25 then
          v147.AssemblyLinearVelocity = Vector3.zero
          v147.AssemblyAngularVelocity = Vector3.zero
          v147.CFrame = CFrame.new(vector)

          task.wait(0.1)
        end

        v33.Status = "Triggering Magma Lava Dip..."

        pcall(function()
          local v149 = f3(replicatedStorage.packages:FindFirstChild("Net"), "Net")

          if v149 and v149.RemoteEvent then
            local volcanoDip = v149:RemoteEvent("VolcanoDip")

            if volcanoDip then
              volcanoDip:FireServer()
            end
          end
        end)

        pcall(function()
          local reVolcanoDip = replicatedStorage.packages.Net:FindFirstChild("RE/VolcanoDip")

          if reVolcanoDip then
            reVolcanoDip:FireServer()
          end
        end)

        pcall(function()
          local main = localPlayer2:FindFirstChild("PlayerGui")
            and localPlayer2.PlayerGui:FindFirstChild("Main")

          local actionsHolder = main and main:FindFirstChild("ActionsHolder")

          local dropEggVolcanoButton = actionsHolder
            and actionsHolder:FindFirstChild("DropEggVolcanoButton")

          if dropEggVolcanoButton and firesignal then
            firesignal(dropEggVolcanoButton.Activated)
          end
        end)

        pcall(function()
          virtualInputManager:SendKeyEvent(true, Enum.KeyCode.G, false, game)
          task.wait(0.05)
          virtualInputManager:SendKeyEvent(false, Enum.KeyCode.G, false, game)
        end)

        local v150 = os.clock()
        local magmaDipDuration = roxyHubState.MagmaDipDuration or 9.5

        while os.clock() - v150 < magmaDipDuration do
          if not v145.Parent then
            break
          else
            local v151, v152 = f13()

            if v152 and (v152.Position - vector).Magnitude > 30 then
              v152.AssemblyLinearVelocity = Vector3.zero
              v152.AssemblyAngularVelocity = Vector3.zero
              v152.CFrame = CFrame.new(vector)
            end

            local v153 = os.clock()
            local v154 = math.max(0, math.ceil(magmaDipDuration - (v153 - v150)))
            v33.Status = string.format("Dipping Egg in Lava (Magma Gamble)... %ds", v154)
            task.wait(0.15)
          end
        end

        pcall(function() v145:SetAttribute("VolcanoDipped", true) end)

        if (v145.Parent and v145:GetAttribute("Mutation")) == "Magma" then
          v33.Status = "Magma Mutation Succeeded! (10x)"

          pcall(function()
            WindUI:Notify({
              Title = "Magma Mutation (10x)!",
              Content = string.format("Successfully mutated %s to Magma!", v145.Name),
              Duration = 4,
              Icon = "flame",
            })
          end)
        else
          v33.Status = "Dip Complete (No Magma)"
        end

        return true
      end
    end
  end
end

function f37(p58, p59)
  local roxyFlightStabilizer3 = p58:FindFirstChild("RoxyFlightStabilizer")

  if roxyFlightStabilizer3 then
    roxyFlightStabilizer3:Destroy()
  end

  if p59 then
    p59.PlatformStand = false
    p59:ChangeState(Enum.HumanoidStateType.GettingUp)
  end

  if p58 then
    p58.AssemblyLinearVelocity = Vector3.zero
    p58.AssemblyAngularVelocity = Vector3.zero
  end
end

local function f39(p60, p61)
  local v155, v156, v157 = f13()
  local cframe4, magnitude2, v158, connect2

  if not v156 then
    return false, "no_hrp"
  else
    local magnitude3 = (p60 - v156.Position).Magnitude
    local v159 = p60 - v156.Position

    if v159.Magnitude > 0.05 then
      local vector2 = Vector3.new(v159.X, 0, v159.Z)

      if vector2.Magnitude > 0.05 then
        cframe4 = CFrame.lookAt(
          p60 + Vector3.new(0, 1.8, 0), p60 + Vector3.new(0, 1.8, 0) + vector2.Unit
        )
      else
        cframe4 = CFrame.new(p60 + Vector3.new(0, 1.8, 0))
      end
    else
      cframe4 = CFrame.new(p60 + Vector3.new(0, 1.8, 0))
    end

    if roxyHubState.FarmMode == "Safe Tween" and true then
      local v160 = math.max(magnitude3 / 300, 0.05)
      f36(v156, v157)

      local create4 = tweenService:Create(v156, TweenInfo.new(v160, Enum.EasingStyle.Linear), {
        CFrame = cframe4,
      })

      v33.CurrentTween = create4
      create4:Play()
      v158 = false
      connect2 = create4.Completed:Connect(function() v158 = true end)
      local v161 = os.clock()

      while true do
        if not v158 and os.clock() - v161 < v160 + 1.2 then
          if not (roxyHubState.AutoFarm
            or roxyHubState.AutoRebirth and roxyHubState.PrioritizeRebirthPet) then
            create4:Cancel()
            pcall(function() connect2:Disconnect() end)
            v33.CurrentTween = nil
            f37(v156, v157)
            magnitude2 = (p60 - v156.Position).Magnitude

            if magnitude2 > 20 then
              if magnitude2 < 80 then
                v156.CFrame = cframe4
                return true, "ok"
              end

              return false, "not_arrived"
            end

            return true, "ok"
          end

          if p61 and not p61.Parent then
            break
          end

          task.wait(0.05)
        else
          pcall(function() connect2:Disconnect() end)
          v33.CurrentTween = nil
          f37(v156, v157)
          magnitude2 = (p60 - v156.Position).Magnitude

          if magnitude2 > 20 then
            if magnitude2 < 80 then
              v156.CFrame = cframe4
              return true, "ok"
            end

            return false, "not_arrived"
          end

          return true, "ok"
        end
      end

      create4:Cancel()
      v33.CurrentTween = nil
      f37(v156, v157)
      return false, "despawned"
    end

    if v156 then
      v156.AssemblyLinearVelocity = Vector3.zero
      v156.AssemblyAngularVelocity = Vector3.zero
      v156.CFrame = cframe4
    end

    return true, "ok"
  end
end

local function f40(p62)
  local v162, v163, v164 = f13()
  local v165 = f12()
  local v166 = not v165 or not v163 or not v164
  local cframe5, v167, connect3

  if v166 then
    return
  else
    local baseplate = v165:FindFirstChild("Baseplate")

    if not baseplate then
      return
    else
      f27(v163, v164)
      local v168, v169, v170 = f13()

      if not v169 or not v170 then
        return
      else
        local v171 = p62 == "Volcanic Egg"
        local basket4 = localPlayer2:FindFirstChild("Basket")

        if basket4 then
          for index36, value42 in ipairs(basket4:GetChildren()) do
            if value42.Name == "Volcanic Egg" or value42:GetAttribute("Egg") == "Volcanic Egg" then
              v171 = true
              break
            end
          end
        end

        if roxyHubState.AutoMagmaDip and not v171 and not v33.IsMagmaDipping
          and p62 ~= "Return to Plot" then
          v33.IsMagmaDipping = true
          f38(p62)
          v33.IsMagmaDipping = false
          v1232, v169, v170 = f13()

          if not v169 or not v170 then
            return
          end
        end

        v33.Status = "Delivering to Plot..."
        local v172 = baseplate.Position + Vector3.new(0, 3.5, 0)
        local magnitude4 = (v172 - v169.Position).Magnitude

        if magnitude4 > 15 then
          if roxyHubState.FarmMode == "Instant" then
            v33.Status = "Instant Warp to Plot..."

            if v33.CurrentTween then
              pcall(function() v33.CurrentTween:Cancel() end)
              v33.CurrentTween = nil
            end

            f37(v169, v170)

            if v169 then
              v169.AssemblyLinearVelocity = Vector3.zero
              v169.AssemblyAngularVelocity = Vector3.zero
              v169.CFrame = CFrame.new(v172)
            end

            task.wait(0.08)
            local v173, v174, v175 = f13()

            if v174 then
              v169 = v174

              if (v172 - v169.Position).Magnitude > 15 then
                v169.AssemblyLinearVelocity = Vector3.zero
                v169.AssemblyAngularVelocity = Vector3.zero
                v169.CFrame = CFrame.new(v172)

                task.wait(0.05)
              end
            end
          else
            local v176 = v172 - v169.Position

            if v176.Magnitude > 0.05 then
              cframe5 = CFrame.lookAt(v172, v172 + v176.Unit)
            else
              cframe5 = CFrame.new(v172)
            end

            f36(v169, v170)
            local v177 = math.max(magnitude4 / 320, 0.05)

            local create5 = tweenService:Create(
              v169, TweenInfo.new(v177, Enum.EasingStyle.Linear), { CFrame = cframe5 }
            )

            v33.CurrentTween = create5
            create5:Play()
            v167 = false
            connect3 = create5.Completed:Connect(function() v167 = true end)
            local v178 = os.clock()

            while not v167 and os.clock() - v178 < v177 + 1.5 do
              if not (roxyHubState.AutoFarm
                or roxyHubState.AutoRebirth and roxyHubState.PrioritizeRebirthPet) then
                create5:Cancel()
                break
              end

              task.wait(0.05)
            end

            pcall(function() connect3:Disconnect() end)
            v33.CurrentTween = nil
            f37(v169, v170)
          end
        end

        if firetouchinterest then
          pcall(firetouchinterest, v169, baseplate, 0)
          task.wait(0.04)
          pcall(firetouchinterest, v169, baseplate, 1)
        end

        local v179 = os.clock()

        while os.clock() - v179 < 1.5 do
          local basket5 = localPlayer2:FindFirstChild("Basket")

          if not basket5 or #basket5:GetChildren() == 0 then
            break
          end

          if firetouchinterest then
            pcall(firetouchinterest, v169, baseplate, 0)
            task.wait(0.03)
            pcall(firetouchinterest, v169, baseplate, 1)
          end

          task.wait(0.05)
        end

        if roxyHubState.AutoHatchPlot then
          local eggs4 = v165:FindFirstChild("Eggs")

          if eggs4 then
            for index37, value43 in ipairs(eggs4:GetChildren()) do
              local findFirstChild8 = value43:FindFirstChild("Hatch", true)
                or value43:FindFirstChildWhichIsA("ProximityPrompt", true)

              if findFirstChild8 and findFirstChild8:IsA("ProximityPrompt")
                and findFirstChild8.Enabled then
                v33.Status = "Hatching " .. value43.Name .. "..."
                findFirstChild8.HoldDuration = 0

                if fireproximityprompt then
                  fireproximityprompt(findFirstChild8, 0)
                else
                  pcall(function()
                    findFirstChild8:InputHoldBegin()
                    task.wait(0.05)
                    findFirstChild8:InputHoldEnd()
                  end)
                end

                task.wait(0.15)
              end
            end
          end

          pcall(function()
            local plotEggsTracker2 = localPlayer2.PlayerGui:FindFirstChild("Main")
              and localPlayer2.PlayerGui.Main:FindFirstChild("PlotEggsTracker")

            local holder2 = plotEggsTracker2
              and (plotEggsTracker2:FindFirstChild("Holder")
                or plotEggsTracker2:FindFirstChild("Handler"))

            if holder2 then
              for index38, value44 in ipairs(holder2:GetChildren()) do
                local findFirstChild9 = value44:FindFirstChild("Open", true)

                if findFirstChild9 and findFirstChild9:IsA("GuiButton")
                  and findFirstChild9.Visible then
                  if getconnections then
                    for key5, value45 in pairs(getconnections(findFirstChild9.Activated)) do
                      value45:Fire()
                    end

                    for key6, value46 in pairs(getconnections(findFirstChild9.MouseButton1Click)) do
                      value46:Fire()
                    end
                  end
                end
              end
            end
          end)
        end

        if roxyHubState.AutoPlaceNest then
          local spawnNest = roxyHubState.SpawnNest and 15 or 10
          local v180 = f16()

          if v180 < spawnNest then
            local v181 = 0
            local v182 = v180 - f15()

            if roxyHubState.SpawnNest then
              local nests4 = v165:FindFirstChild("Nests")

              if nests4 then
                for index39, value47 in ipairs(nests4:GetChildren()) do
                  if value47:GetAttribute("Unlocked") ~= false
                    and not value47:GetAttribute("Occupied") then
                    v181 = v181 + 1
                  end
                end
              end
            end

            if v181 > 0 or v182 < 10 then
              local v183 = {}

              for index40, value48 in ipairs(localPlayer2.Backpack:GetChildren()) do
                if value48:IsA("Tool")
                  and (value48:HasTag("Egg") or string.find(value48.Name, "Egg")) then
                  table.insert(v183, value48)
                end
              end

              local character6 = localPlayer2.Character

              if character6 then
                for index41, value49 in ipairs(character6:GetChildren()) do
                  if value49:IsA("Tool")
                    and (value49:HasTag("Egg") or string.find(value49.Name, "Egg")) then
                    table.insert(v183, value49)
                  end
                end
              end

              for index42, value50 in ipairs(v183) do
                local v184 = f16()
                local v185 = v184 - f15()

                if v184 >= spawnNest then
                  break
                else
                  local v186 = false

                  if roxyHubState.SpawnNest and v181 > 0 then
                    local nests5 = v165:FindFirstChild("Nests")

                    if nests5 then
                      for index43, value51 in ipairs(nests5:GetChildren()) do
                        if value51:GetAttribute("Unlocked") ~= false
                          and not value51:GetAttribute("Occupied") then
                          v33.Status = "Placing " .. value50.Name .. " in Nest..."

                          if character6 and v170 and value50.Parent ~= character6 then
                            v170:EquipTool(value50)
                            local v187 = os.clock()

                            while value50.Parent ~= character6 and os.clock() - v187 < 0.8 do
                              task.wait(0.05)
                            end
                          end

                          if value50.Parent == character6 and eggPlaced then
                            task.wait(0.1)
                            eggPlaced:FireServer({ NestId = value51.Name })
                            local v188 = os.clock()

                            while value50.Parent == character6 and os.clock() - v188 < 1 do
                              task.wait(0.05)
                            end

                            task.wait(0.2)
                            f16()

                            v33.Status = "Placed " .. value50.Name .. " in Nest "
                              .. value51.Name .. "!"

                            v186 = true
                            v181 = math.max(0, v181 - 1)
                          end

                          break
                        end
                      end
                    end
                  end

                  if not v186 then
                    if v185 < 10 then
                      v33.Status = "Placing " .. value50.Name .. " on Plot..."
                      local v189 = math.random()
                      local v190 = math.random()

                      local vector3 = Vector3.new(
                        (v189 * 2 - 1) * 20, 0.55, (v190 * 2 - 1) * 20
                      )

                      local pointToWorldSpace = baseplate.CFrame:PointToWorldSpace(vector3)

                      if character6 and v170 and value50.Parent ~= character6 then
                        v170:EquipTool(value50)
                        local v191 = os.clock()

                        while value50.Parent ~= character6 and os.clock() - v191 < 0.8 do
                          task.wait(0.05)
                        end
                      end

                      if value50.Parent == character6 and eggPlaced then
                        task.wait(0.1)
                        eggPlaced:FireServer({ PlantPosition = pointToWorldSpace })
                        local v192 = os.clock()

                        while value50.Parent == character6 and os.clock() - v192 < 1 do
                          task.wait(0.05)
                        end

                        task.wait(0.2)
                        f16()
                        v33.Status = "Placed " .. value50.Name .. " on Plot!"
                      end
                    else
                      break
                    end
                  end
                end
              end
            end
          end
        end

        if roxyHubState.AutoUnlockNests and localPlayer2:GetAttribute("NoNest") ~= true then
          local nests6 = v165:FindFirstChild("Nests")

          if nests6 then
            for index44, value52 in ipairs(nests6:GetChildren()) do
              if value52:GetAttribute("Unlocked") ~= true then
                local findFirstChildWhichIsA = value52:FindFirstChildWhichIsA(
                  "ProximityPrompt", true
                )

                if findFirstChildWhichIsA and fireproximityprompt then
                  fireproximityprompt(findFirstChildWhichIsA, 0)
                end

                local v193 = tonumber(value52.Name)

                if v193 and nests then
                  pcall(function() nests:FireServer(v193) end)
                end

                task.wait(0.05)
              end
            end
          end
        end

        v33.Status = "Delivery Complete!"
        task.wait(0.05)
        return
      end
    end
  end
end

task.spawn(function()
  while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
    task.wait(0.1)
    local autoRebirth = roxyHubState.AutoRebirth and f25() or nil

    local v194 = autoRebirth and not autoRebirth.isMaxCap and not autoRebirth.hasPet
      and not autoRebirth.isIncubating and autoRebirth.reqPet ~= ""

    if roxyHubState.AutoFarm or v194 then
      local v195, v196 = f13()

      if v195 and v196 then
        local basket6 = localPlayer2:FindFirstChild("Basket")

        if basket6 and #basket6:GetChildren() >= 1 then
          v33.Status = "Basket Full (1/1) - Delivering..."
          f40("Carried Egg")
          local basket7 = localPlayer2:FindFirstChild("Basket")

          if basket7 and #basket7:GetChildren() >= 1 then
            v33.Status = "Offloading egg at Baseplate..."
            task.wait(0.4)
          end
        end

        local basket8 = localPlayer2:FindFirstChild("Basket")
          and #localPlayer2.Basket:GetChildren() >= 1

        if basket8 then
          v33.Status = "Plot Full - Waiting for Hatch..."
          task.wait(1.5)
        elseif not basket8 then
          local v197 = f33()

          if v197 and v197.IsWaitingWeather then
            v33.IsFarming = true
            local timeLeft = v197.TimeLeft or 0

            v33.Status = string.format(
              "[Weather: %s] Waiting for %s eggs (%ds)...", v197.StormVariant or "Storm",
              v197.MutationType or "Mutation", timeLeft
            )

            v33.Target = "Waiting for " .. (v197.MutationType or "Mutation")
            v33.TargetRarity = v197.StormVariant or "Weather"
            v33.TargetWeight = 0

            task.wait(0.5)
          elseif v197 and v197.Model and v197.Model.Parent then
            v33.IsFarming = true

            local v198 = v197.Mutation
                and string.format(" [%s x%d]", v197.Mutation, v21[v197.Mutation] or 1)
              or ""

            v33.Status = "Targeting " .. v197.Name .. v198
            v33.Target = v197.Name .. v198

            v33.TargetRarity = v197.Mutation and v197.Mutation .. " (" .. v197.Rarity .. ")"
              or v197.Rarity

            v33.TargetWeight = v197.EggWeight or 0

            local v199 = false
            local v200 = v197.Name == "Volcanic Egg"

            if v200
              and (localPlayer2:GetAttribute("InVolcano") ~= true
                or localPlayer2:GetAttribute("VolcanoValidated") ~= true) then
              v33.Status = "Entering Volcano (Activating Scorching)..."
              f31(v196, hum)
              v1443, v196 = f13()
            end

            if v196 then
              if v200 then
                if v33.CurrentTween then
                  pcall(function() v33.CurrentTween:Cancel() end)
                  v33.CurrentTween = nil
                end

                f37(v196, hum)
                v1446, v196 = f13()

                if v196 then
                  v196.AssemblyLinearVelocity = Vector3.zero
                  v196.AssemblyAngularVelocity = Vector3.zero

                  local position7 = v197.Position
                  local parent = v197.Prompt and v197.Prompt.Parent

                  if parent and parent:IsA("BasePart") then
                    position7 = parent.Position
                  end

                  v196.CFrame = CFrame.new(position7.X, position7.Y + 2, position7.Z)
                  task.wait(0.08)

                  if (v196.Position - position7).Magnitude > 25 then
                    v196.AssemblyLinearVelocity = Vector3.zero
                    v196.AssemblyAngularVelocity = Vector3.zero
                    v196.CFrame = CFrame.new(position7.X, position7.Y + 2, position7.Z)

                    task.wait(0.05)
                  end

                  v199 = true
                end
              else
                local v201, v202 = f39(v197.Position, v197.Model)

                if not v201 then
                  if v202 == "despawned" then
                    v33.Status = v197.Name .. " despawned, retargeting..."
                  else
                    v33.Status = "Retrying move to " .. v197.Name .. "..."
                  end

                  task.wait(0.2)
                else
                  v199 = true
                end
              end
            end

            if v199 then
              local v203 = math.clamp(roxyHubState.SyncDelay, 0.25, 0.6)
              task.wait(v203)

              local basket9 = localPlayer2:FindFirstChild("Basket")
                  and #localPlayer2.Basket:GetChildren()
                or 0

              v1458, v196 = f13()

              if v196 then
                v196.AssemblyLinearVelocity = Vector3.zero
                v196.AssemblyAngularVelocity = Vector3.zero

                local position8 = v197.Position
                local parent2 = v197.Prompt and v197.Prompt.Parent

                if parent2 and parent2:IsA("BasePart") then
                  position8 = parent2.Position
                end

                v196.CFrame = CFrame.new(position8.X, position8.Y + 2, position8.Z)
              end

              pcall(function()
                if workspaceService.CurrentCamera and v196 then
                  workspaceService.CurrentCamera.CFrame = CFrame.lookAt(v196.Position
                    + Vector3.new(0, 3, 4), v197.Position)
                end
              end)

              if v197.Model and v197.Model.Parent then
                v33.Status = "Collecting " .. v197.Name
                f35(v197.Model, v197.Prompt)
              end

              local v204 = math.clamp(roxyHubState.PostPickupDelay + 1.8, 1.8, 3)
              local v205 = os.clock()
              local v206 = false
              local v207 = os.clock()

              while os.clock() - v205 < v204 do
                if (localPlayer2:FindFirstChild("Basket") and #localPlayer2.Basket:GetChildren()
                    or 0)
                  > basket9 then
                  v206 = true
                  break
                end

                if not v197.Model or not v197.Model.Parent then
                  v206 = true
                  break
                end

                if os.clock() - v207 >= 0.3 then
                  v207 = os.clock()
                  v1475, v196 = f13()

                  if v196 then
                    v196.AssemblyLinearVelocity = Vector3.zero
                    v196.AssemblyAngularVelocity = Vector3.zero

                    local position9 = v197.Position
                    local parent3 = v197.Prompt and v197.Prompt.Parent

                    if parent3 and parent3:IsA("BasePart") then
                      position9 = parent3.Position
                    end

                    v196.CFrame = CFrame.new(position9.X, position9.Y + 2, position9.Z)
                  end

                  f35(v197.Model, v197.Prompt)
                end

                task.wait(0.05)
              end

              if v206 then
                v33.CollectedCount = v33.CollectedCount + 1
                v33.Status = "Collected " .. v197.Name .. " (1/1) - Delivering..."
                f40(v197.Name)
              else
                v33.Status = "Missed " .. v197.Name .. ", retargeting..."
                task.wait(0.2)
              end
            end
          else
            if autoRebirth and autoRebirth.isIncubating then
              local incubatingTime2 = autoRebirth.incubatingTime
                  and " (" .. autoRebirth.incubatingTime .. ")"
                or ""

              v33.Status = string.format(
                "Waiting for Ethereal / Incubating 1 %s%s",
                autoRebirth.incubatingEggName or "Egg", incubatingTime2
              )
            else
              v33.Status = "Searching for targets..."
            end

            v33.Target = "None"
            v33.TargetWeight = 0

            if roxyHubState.AutoReturnPlot then
              local v208 = f12()

              local baseplate2 = v208
              baseplate2 = v208 and v208:FindFirstChild("Baseplate")

              if baseplate2 and (baseplate2.Position - v196.Position).Magnitude > 25 then
                f40("Return to Plot")
              end
            end

            task.wait(0.5)
          end
        end
      end
    else
      v33.IsFarming = false

      if v33.CurrentTween then
        pcall(function() v33.CurrentTween:Cancel() end)
        v33.CurrentTween = nil
      end

      if roxyHubState.AutoRebirth and autoRebirth and not autoRebirth.isMaxCap then
        if autoRebirth.hasPet then
          v33.Status = string.format("Pet Owned (%s) - Waiting for Cash...", autoRebirth.reqPet)
        elseif autoRebirth.isIncubating then
          local incubatingTime3 = autoRebirth.incubatingTime
              and " (" .. autoRebirth.incubatingTime .. ")"
            or ""

          v33.Status = string.format(
            "Incubating 1 %s%s - Waiting to Hatch...", autoRebirth.incubatingEggName or "Egg",
            incubatingTime3
          )
        else
          v33.Status = "Idle"
        end
      else
        v33.Status = "Idle"
      end

      v33.Target = "None"
      v33.TargetWeight = 0
    end
  end
end)

task.spawn(function()
  while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
    task.wait(0.25)

    if roxyHubState.AutoHatchPlot then
      pcall(function()
        local plotEggsTracker3 = localPlayer2:FindFirstChild("PlayerGui")
          and localPlayer2.PlayerGui:FindFirstChild("Main")
          and localPlayer2.PlayerGui.Main:FindFirstChild("PlotEggsTracker")

        local holder3 = plotEggsTracker3 and plotEggsTracker3:FindFirstChild("Holder")

        if holder3 then
          for index45, value53 in ipairs(holder3:GetChildren()) do
            if value53:IsA("GuiObject") then
              local findFirstChild10 = value53:FindFirstChild("Open", true)
              local findFirstChild11 = value53:FindFirstChild("TimeLeft", true)

              if findFirstChild10 and findFirstChild10:IsA("GuiButton")
                  and findFirstChild10.Visible
                or findFirstChild11 and findFirstChild11:IsA("TextLabel")
                  and findFirstChild11.Text
                  and string.lower(findFirstChild11.Text):find("ready") ~= nil then
                local name7 = value53.Name

                if hatch and name7 and #name7 > 10 then
                  hatch:FireServer({ EggKey = name7 })
                end

                if findFirstChild10 and findFirstChild10:IsA("GuiButton") then
                  if getconnections then
                    for key7, value54 in pairs(getconnections(findFirstChild10.Activated)) do
                    end

                    for key8, value55 in pairs(getconnections(findFirstChild10.MouseButton1Click)) do
                    end
                  elseif firesignal then
                    pcall(firesignal, findFirstChild10.Activated)
                  end
                end

                task.wait(0.06)
              end
            end
          end
        end

        local v209 = f12()

        local eggs5 = v209
        eggs5 = v209 and v209:FindFirstChild("Eggs")

        if eggs5 then
          for index46, value56 in ipairs(eggs5:GetChildren()) do
            local eggKey2 = value56:GetAttribute("EggKey")
            local v210 = f23(value56)

            if v210 and v210.isReady and eggKey2 then
              if hatch then
                hatch:FireServer({ EggKey = eggKey2 })
              end

              local findFirstChild12 = value56:FindFirstChild("Hatch", true)
                or value56:FindFirstChildWhichIsA("ProximityPrompt", true)

              if findFirstChild12 and findFirstChild12:IsA("ProximityPrompt")
                and findFirstChild12.Enabled then
                findFirstChild12.HoldDuration = 0

                if fireproximityprompt then
                  fireproximityprompt(findFirstChild12, 0)
                else
                  pcall(function()
                    findFirstChild12:InputHoldBegin()
                    task.wait(0.05)
                    findFirstChild12:InputHoldEnd()
                  end)
                end
              end

              task.wait(0.06)
            end
          end
        end
      end)
    end
  end
end)

task.spawn(function()
  while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
    task.wait(1)

    if roxyHubState.AutoRebirth and roxyHubState.AutoRebirthWhenReady then
      pcall(function()
        local v211 = f25()

        if v211.canRebirth and not v211.isMaxCap then
          v33.Status = "Executing Rebirth Tier " .. v211.nextTier .. "!"

          if f26() and WindUI and WindUI.Notify then
            WindUI:Notify({
              Title = "Rebirth Completed",
              Content = string.format(
                "Tier %d unlocked! Requirements fulfilled.", v211.nextTier
              ),
              Duration = 4,
              Icon = "award",
            })
          end

          task.wait(2.5)
        end
      end)
    end
  end
end)

task.spawn(function()
  while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
    task.wait(0.5)

    if roxyHubState.AutoPlaceNest and not v33.CurrentTween then
      pcall(function()
        local v212 = f12()

        local baseplate3 = v212
        baseplate3 = v212 and v212:FindFirstChild("Baseplate")

        local v213, v214, v215 = f13()
        local v216 = baseplate3

        if not v212 or not v216 or not v215 or not v214 then
          return
        elseif (v214.Position - v216.Position).Magnitude > 85 then
          return
        else
          local spawnNest2 = roxyHubState.SpawnNest and 15 or 10

          if f16() >= spawnNest2 then
            return
          else
            local v217 = {}

            for index47, value57 in ipairs(localPlayer2.Backpack:GetChildren()) do
              if value57:IsA("Tool")
                and (value57:HasTag("Egg") or string.find(value57.Name, "Egg")) then
                table.insert(v217, value57)
              end
            end

            if v213 then
              for index48, value58 in ipairs(v213:GetChildren()) do
                if value58:IsA("Tool")
                  and (value58:HasTag("Egg") or string.find(value58.Name, "Egg")) then
                  table.insert(v217, value58)
                end
              end
            end

            if #v217 > 0 then
              for index49, value59 in ipairs(v217) do
                local v218 = f16()

                if v218 >= spawnNest2 then
                  break
                else
                  local v219 = false

                  if roxyHubState.SpawnNest then
                    local nests7 = v212:FindFirstChild("Nests")

                    if nests7 then
                      for index50, value60 in ipairs(nests7:GetChildren()) do
                        if value60:GetAttribute("Unlocked") ~= false
                          and not value60:GetAttribute("Occupied") then
                          if value59.Parent ~= v213 then
                            v215:EquipTool(value59)
                            local v220 = os.clock()

                            while value59.Parent ~= v213 and os.clock() - v220 < 0.8 do
                              task.wait(0.05)
                            end
                          end

                          if value59.Parent == v213 and eggPlaced then
                            task.wait(0.1)
                            eggPlaced:FireServer({ NestId = value60.Name })
                            local v221 = os.clock()

                            while value59.Parent == v213 and os.clock() - v221 < 1 do
                              task.wait(0.05)
                            end

                            task.wait(0.25)
                            v218 = f16()
                            v219 = true
                          end

                          break
                        end
                      end
                    end
                  end

                  if not v219 then
                    if v218 - f15() < 10 then
                      local v222 = math.random()
                      local v223 = math.random()

                      local vector4 = Vector3.new(
                        (v222 * 2 - 1) * 20, 0.55, (v223 * 2 - 1) * 20
                      )

                      local pointToWorldSpace2 = v216.CFrame:PointToWorldSpace(vector4)

                      if value59.Parent ~= v213 then
                        v215:EquipTool(value59)
                        local v224 = os.clock()

                        while value59.Parent ~= v213 and os.clock() - v224 < 0.8 do
                          task.wait(0.05)
                        end
                      end

                      if value59.Parent == v213 and eggPlaced then
                        task.wait(0.1)
                        eggPlaced:FireServer({ PlantPosition = pointToWorldSpace2 })
                        local v225 = os.clock()

                        while value59.Parent == v213 and os.clock() - v225 < 1 do
                          task.wait(0.05)
                        end

                        task.wait(0.25)
                        f16()
                      end
                    else
                      break
                    end
                  end
                end
              end
            end

            return
          end
        end
      end)
    end
  end
end)

task.spawn(function()
  while true do
    task.wait(0.5)

    if roxyHubState.AutoUpgradeLuck then
      pcall(function()
        local upgrades = replicatedStorage:FindFirstChild("Remotes", true)
          and replicatedStorage.Remotes:FindFirstChild("Game", true)
          and replicatedStorage.Remotes.Game:FindFirstChild("Plot", true)
          and replicatedStorage.Remotes.Game.Plot:FindFirstChild("Upgrades")

        if not upgrades then
          upgrades = replicatedStorage:FindFirstChild("Upgrades", true)
        end

        if upgrades then
          upgrades:FireServer("HatchUpgrade", "BuyMax")
          upgrades:FireServer("HatchUpgrade", "BuyOne")
        end
      end)
    end
  end
end)

task.spawn(function()
  while true do
    task.wait(1)

    if roxyHubState.AutoUnlockNests then
      pcall(function()
        if localPlayer2:GetAttribute("NoNest") == true then
          return
        else
          local v226 = f12()

          if v226 and v226:FindFirstChild("Nests") then
            for index51, value61 in ipairs(v226.Nests:GetChildren()) do
              if value61:GetAttribute("Unlocked") ~= true then
                local findFirstChildWhichIsA2 = value61:FindFirstChildWhichIsA(
                  "ProximityPrompt", true
                )

                if findFirstChildWhichIsA2 and fireproximityprompt then
                  fireproximityprompt(findFirstChildWhichIsA2, 0)
                end

                local nests8 = replicatedStorage:FindFirstChild("Remotes", true)
                  and replicatedStorage.Remotes:FindFirstChild("Game", true)
                  and replicatedStorage.Remotes.Game:FindFirstChild("Plot", true)
                  and replicatedStorage.Remotes.Game.Plot:FindFirstChild("Nests")

                if nests8 then
                  local v227 = tonumber(value61.Name)

                  if v227 then
                    nests8:FireServer(v227)
                  end
                end

                task.wait(0.25)
              end
            end
          end

          return
        end
      end)
    end
  end
end)

local function f41(p63)
  local v228 = f12()
  local baseplate4 = v228 and v228:FindFirstChild("Baseplate")
  local v229, v230, v231 = f13()
  local v232 = v228 and baseplate4 and v229 and v230 and v231
  local v233, bestPetsStrategy

  if not v232 then
    return false, "Not near plot or character missing"
  elseif (v230.Position - baseplate4.Position).Magnitude > 45 then
    return false, "Too far from plot baseplate"
  else
    local petAging = replicatedStorage:FindFirstChild("GameServices")
      and replicatedStorage.GameServices:FindFirstChild("PetAging")

    local pets = replicatedStorage:FindFirstChild("GameData")
      and replicatedStorage.GameData:FindFirstChild("Pets")

    local mutations = replicatedStorage:FindFirstChild("GameData")
      and replicatedStorage.GameData:FindFirstChild("Mutations")

    local playerScripts = localPlayer2:FindFirstChild("PlayerScripts")
    local v234 = playerScripts and playerScripts:FindFirstChild("Game")
    local pets2 = v234 and v234:FindFirstChild("Pets")
    local petRenderer = pets2 and pets2:FindFirstChild("PetRenderer")
    local v235 = petAging and f3(petAging, "PetAging", {}) or {}
    local v236 = pets and f3(pets, "Pets", {}) or {}
    local v237 = mutations and f3(mutations, "Mutations", {}) or {}
    v233 = petRenderer and f3(petRenderer, "PetRenderer", {}) or {}

    local v238 = replicatedStorage:FindFirstChild("Remotes")
      and replicatedStorage.Remotes:FindFirstChild("Game")

    local placePet = v238 and v238:FindFirstChild("PlacePet")
    local pickupPet = v238 and v238:FindFirstChild("PickupPet")

    if not (placePet and pickupPet) then
      return false, "Place/Pickup remotes not found"
    else
      local v239 = {}

      if v233 and v233.GetAll then
        for key9, value62 in pairs(v233.GetAll()) do
          if value62.OwnerUserId == localPlayer2.UserId and value62.Model
            and value62.Model.Parent then
            local v240 = tonumber(value62.Model:GetAttribute("Age")) or 1
            local v241 = tonumber(value62.Model:GetAttribute("Weight")) or 1
            local petName = value62.Model:GetAttribute("PetName") or value62.Model.Name
            local v242 = v236 and v236[petName] and tonumber(v236[petName].Income) or 0
            local mutation3 = value62.Model:GetAttribute("Mutation")
            local model = value62.Model
            local combinedFactor = v237
            local spawnMutation = model:GetAttribute("SpawnMutation")

            if v237 then
              combinedFactor = v237.CombinedFactor
                and v237.CombinedFactor(mutation3, spawnMutation)
            end

            local v243 = combinedFactor or 1
            local multiplierFor = v235 and v235.MultiplierFor and v235.MultiplierFor(v240) or 1

            if multiplierFor <= 0 then
              multiplierFor = 1
            end

            local v244 = v241 / multiplierFor
            local maxAge = v235 and v235.MaxAge or 100

            local v245 = v244
              * (v235 and v235.MultiplierFor and v235.MultiplierFor(maxAge) or 1.99)

            local weightStandardKG = v235 and v235.WeightStandardKG or 10
            local v246 = math.floor(v242 * (v241 / weightStandardKG))
            local v247 = math.floor(v246 * v243)
            local v248 = math.floor(v242 * (v245 / weightStandardKG))
            local v249 = math.floor(v248 * v243)
            local model2 = value62.Model

            table.insert(v239, {
              Key = value62.PetKey,
              Name = petName,
              Placed = true,
              Age = v240,
              CurWeight = v241,
              BaseWeight = v244,
              CurIncome = v247,
              MaxIncome = v249,
              Position = model2:GetPivot().Position,
            })
          end
        end
      end

      if localPlayer2:FindFirstChild("Backpack") then
        for index52, value63 in ipairs(localPlayer2.Backpack:GetChildren()) do
          if value63:IsA("Tool") and value63:HasTag("Pet") and value63:GetAttribute("PetKey") then
            local v250 = tonumber(value63:GetAttribute("Age")) or 1
            local v251 = tonumber(value63:GetAttribute("Weight")) or 1
            local petName2 = value63:GetAttribute("PetName") or value63.Name
            local v252 = v236 and v236[petName2] and tonumber(v236[petName2].Income) or 0
            local mutation4 = value63:GetAttribute("Mutation")
            local spawnMutation2 = value63:GetAttribute("SpawnMutation")

            local combinedFactor2 = v237 and v237.CombinedFactor
                and v237.CombinedFactor(mutation4, spawnMutation2)
              or 1

            local multiplierFor2 = v235 and v235.MultiplierFor and v235.MultiplierFor(v250) or 1

            if multiplierFor2 <= 0 then
              multiplierFor2 = 1
            end

            local v253 = v251 / multiplierFor2
            local maxAge2 = v235 and v235.MaxAge or 100

            local v254 = v253
              * (v235 and v235.MultiplierFor and v235.MultiplierFor(maxAge2) or 1.99)

            local weightStandardKG2 = v235 and v235.WeightStandardKG or 10
            local v255 = math.floor(v252 * (v251 / weightStandardKG2))
            local v256 = math.floor(v255 * combinedFactor2)
            local v257 = math.floor(v252 * (v254 / weightStandardKG2))
            local v258 = math.floor(v257 * combinedFactor2)

            table.insert(v239, {
              Key = value63:GetAttribute("PetKey"),
              Name = petName2,
              Placed = false,
              Age = v250,
              CurWeight = v251,
              BaseWeight = v253,
              CurIncome = v256,
              MaxIncome = v258,
              Tool = value63,
            })
          end
        end
      end

      if #v239 == 0 then
        return false, "No pets found"
      else
        bestPetsStrategy = p63 or roxyHubState.BestPetsStrategy
          or "Smart Potential (Lv 100 Max Income)"

        table.sort(v239, function(p64, p65)
          if bestPetsStrategy == "Current Cash/s (Game Default)" then
            if p64.CurIncome ~= p65.CurIncome then
              return p64.CurIncome > p65.CurIncome
            end

            return p64.MaxIncome > p65.MaxIncome
          end

          if p64.MaxIncome ~= p65.MaxIncome then
            return p64.MaxIncome > p65.MaxIncome
          end

          return p64.BaseWeight > p65.BaseWeight
        end)

        local maxPets = localPlayer2:GetAttribute("MaxPets")
        local v259 = math.min(maxPets or 5, #v239)
        local v260 = {}

        for i = 1, v259 do
          v260[v239[i].Key] = true
        end

        local v261 = {}
        local count2 = 0

        for index53, value64 in ipairs(v239) do
          local v262 = value64

          if v262.Placed and not v260[v262.Key] then
            if v262.Position then
              table.insert(v261, v262.Position)
            end

            pcall(function() v233.Remove(localPlayer2.UserId, v262.Key) end)
            pickupPet:FireServer(v262.Key)
            count2 = count2 + 1
            task.wait(0.2)
          end
        end

        local function f42(p66)
          local v263 = math.floor((p66 - 1) / 3)
          local cframe6 = CFrame.new(((p66 - 1) % 3 - 1) * 4, 0, -(v263 * 4 + 8))
          local pointToObjectSpace = baseplate4.CFrame:PointToObjectSpace((v230.CFrame * cframe6).Position)
          local v264 = baseplate4.Size.X / 2 - 3
          local v265 = baseplate4.Size.Z / 2 - 3
          local v266 = math.clamp(pointToObjectSpace.X, -v264, v264)
          local v267 = math.clamp(pointToObjectSpace.Z, -v265, v265)

          return baseplate4.CFrame:PointToWorldSpace(Vector3.new(
            v266, pointToObjectSpace.Y, v267
          ))
        end

        local count3 = 0

        for j = 1, v259 do
          local v268 = v239[j]

          if not v268.Placed then
            local tool = v268.Tool

            if not tool or tool.Parent ~= localPlayer2.Backpack then
              for index54, value65 in ipairs(localPlayer2.Backpack:GetChildren()) do
                if value65:IsA("Tool") and value65:GetAttribute("PetKey") == v268.Key then
                  tool = value65
                  break
                end
              end
            end

            if tool then
              v231:EquipTool(tool)
              local v269 = os.clock()

              while tool.Parent ~= v229 and os.clock() - v269 < 1 do
                task.wait(0.05)
              end

              if tool.Parent == v229 then
                local v270 = table.remove(v261, 1) or f42(j)
                placePet:FireServer(v268.Key, v270)
                count3 = count3 + 1
                task.wait(0.25)
              end
            end
          end
        end

        if v231 and localPlayer2:GetAttribute("IsRiding") ~= true then
          pcall(function() v231:UnequipTools() end)
        end

        return true, string.format(
          "Optimized %d placed, %d picked up (%s)", count3, count2, bestPetsStrategy
        )
      end
    end
  end
end

task.spawn(function()
  while true do
    task.wait(10)

    if _G.RoxyHubInstanceId ~= roxyHubInstanceId then
      break
    elseif roxyHubState.AutoPlaceBestPets then
      pcall(function() f41(roxyHubState.BestPetsStrategy) end)
    end
  end
end)

local function f43(p67)
  local v271 = f12()
  local v272, v273, v274 = f13()
  local v275 = v271 and v272 and v273 and v274
  local v276, feedTargetMode

  if not v275 then
    return false, "Character or plot missing"
  elseif v33.IsFarming then
    return false, "Cannot feed while farming is active"
  else
    local petAging2 = replicatedStorage:FindFirstChild("GameServices")
      and replicatedStorage.GameServices:FindFirstChild("PetAging")

    local pets3 = replicatedStorage:FindFirstChild("GameData")
      and replicatedStorage.GameData:FindFirstChild("Pets")

    local mutations2 = replicatedStorage:FindFirstChild("GameData")
      and replicatedStorage.GameData:FindFirstChild("Mutations")

    local playerScripts2 = localPlayer2:FindFirstChild("PlayerScripts")
    local v277 = playerScripts2 and playerScripts2:FindFirstChild("Game")
    local pets4 = v277 and v277:FindFirstChild("Pets")
    local petRenderer2 = pets4 and pets4:FindFirstChild("PetRenderer")

    local foods = replicatedStorage:FindFirstChild("GameData")
      and replicatedStorage.GameData:FindFirstChild("Foods")

    local v278 = petAging2 and f3(petAging2, "PetAging", {}) or {}
    local v279 = pets3 and f3(pets3, "Pets", {}) or {}
    local v280 = mutations2 and f3(mutations2, "Mutations", {}) or {}
    local v281 = petRenderer2 and f3(petRenderer2, "PetRenderer", {}) or {}
    v276 = foods and f3(foods, "Foods", {}) or {}

    local v282 = replicatedStorage:FindFirstChild("Remotes")
      and replicatedStorage.Remotes:FindFirstChild("Game")

    local feedPet = v282 and v282:FindFirstChild("FeedPet")
      or replicatedStorage:FindFirstChild("FeedPet", true)

    if not feedPet then
      return false, "FeedPet remote not found"
    else
      local v283 = {}
      local maxAge3 = v278 and v278.MaxAge
      local multiplierFor3 = v278
      local v284 = maxAge3 or 100

      if v278 then
        multiplierFor3 = v278.MultiplierFor and v278.MultiplierFor(v284)
      end

      local v285 = multiplierFor3 or 1.99
      local weightStandardKG3 = v278 and v278.WeightStandardKG or 10

      if v281 and v281.GetAll then
        for key10, value66 in pairs(v281.GetAll()) do
          if value66.OwnerUserId == localPlayer2.UserId and value66.Model
            and value66.Model.Parent and value66.Model.PrimaryPart then
            local v286 = tonumber(value66.Model:GetAttribute("Age")) or 1
            local v287 = tonumber(value66.Model:GetAttribute("Weight")) or 1
            local petName3 = value66.Model:GetAttribute("PetName") or value66.Model.Name
            local v288 = v279 and v279[petName3] and tonumber(v279[petName3].Income) or 0
            local mutation5 = value66.Model:GetAttribute("Mutation")
            local spawnMutation3 = value66.Model:GetAttribute("SpawnMutation")

            local combinedFactor3 = v280 and v280.CombinedFactor
              and v280.CombinedFactor(mutation5, spawnMutation3)

            local multiplierFor4 = v278
            local v289 = combinedFactor3 or 1

            if v278 then
              multiplierFor4 = v278.MultiplierFor and v278.MultiplierFor(v286)
            end

            local v290 = multiplierFor4 or 1

            if v290 <= 0 then
              v290 = 1
            end

            local v291 = v287 / v290
            local v292 = math.floor(math.floor(v288 * (v287 / weightStandardKG3)) * v289)
            local v293 = math.floor(math.floor(v288 * (v291 * v285 / weightStandardKG3)) * v289)

            table.insert(v283, {
              PetKey = value66.PetKey,
              Name = petName3,
              Model = value66.Model,
              PrimaryPart = value66.Model.PrimaryPart,
              Age = v286,
              CurWeight = v287,
              BaseWeight = v291,
              CurIncome = v292,
              MaxIncome = v293,
              Headroom = v293 - v292,
            })
          end
        end
      end

      if #v283 == 0 and v271:FindFirstChild("Pets") then
        for index55, value67 in ipairs(v271.Pets:GetChildren()) do
          if value67:IsA("Model") and value67.PrimaryPart then
            local ownerUserId = value67:GetAttribute("OwnerUserId")

            local owner2 = ownerUserId
            owner2 = ownerUserId or value67:GetAttribute("Owner")

            if owner2 == localPlayer2.UserId
              or tostring(owner2) == tostring(localPlayer2.UserId)
              or v271:GetAttribute("NestsOwnerLoaded") == localPlayer2.UserId
              or v271.Name == tostring(localPlayer2.UserId) then
              local petKey3 = value67:GetAttribute("PetKey") or value67.Name
              local v294 = tonumber(value67:GetAttribute("Age")) or 1
              local v295 = tonumber(value67:GetAttribute("Weight")) or 1
              local petName4 = value67:GetAttribute("PetName") or value67.Name
              local v296 = v279 and v279[petName4] and tonumber(v279[petName4].Income) or 0
              local mutation6 = value67:GetAttribute("Mutation")
              local combinedFactor4 = v280
              local spawnMutation4 = value67:GetAttribute("SpawnMutation")

              if v280 then
                combinedFactor4 = v280.CombinedFactor
                  and v280.CombinedFactor(mutation6, spawnMutation4)
              end

              local v297 = combinedFactor4 or 1

              local multiplierFor5 = v278 and v278.MultiplierFor and v278.MultiplierFor(v294)
                or 1

              if multiplierFor5 <= 0 then
                multiplierFor5 = 1
              end

              local v298 = v295 / multiplierFor5
              local v299 = math.floor(math.floor(v296 * (v295 / weightStandardKG3)) * v297)
              local v300 = math.floor(math.floor(v296 * (v298 * v285 / weightStandardKG3)) * v297)

              table.insert(v283, {
                PetKey = petKey3,
                Name = petName4,
                Model = value67,
                PrimaryPart = value67.PrimaryPart,
                Age = v294,
                CurWeight = v295,
                BaseWeight = v298,
                CurIncome = v299,
                MaxIncome = v300,
                Headroom = v300 - v299,
              })
            end
          end
        end
      end

      if #v283 == 0 then
        return false, "No placed pets found on plot"
      else
        local v301 = {}

        if (roxyHubState.FeedTargetMode == "Selected Pet Only"
            or roxyHubState.FeedTargetMode == nil)
          and roxyHubState.SelectedPetKey then
          for index56, value68 in ipairs(v283) do
            if value68.PetKey == roxyHubState.SelectedPetKey then
              if roxyHubState.FeedSkipMaxAge == false or value68.Age < v284 then
                table.insert(v301, value68)
              end

              break
            end
          end
        end

        if #v301 == 0 then
          for index57, value69 in ipairs(v283) do
            local v302 = true

            if roxyHubState.FeedSkipMaxAge ~= false and value69.Age >= v284 then
              v302 = false
            end

            if v302 and roxyHubState.FeedAllPets == false
              and type(roxyHubState.FeedPetList) == "table" then
              local v303 = false

              for key11, value70 in pairs(roxyHubState.FeedPetList) do
                if type(key11) == "number"
                    and (value70 == value69.Name or value70 == value69.PetKey)
                  or type(key11) == "string"
                    and (key11 == value69.Name or key11 == value69.PetKey) and value70 == true then
                  v303 = true
                  break
                end
              end

              if not v303 then
                v302 = false
              end
            end

            if v302 then
              table.insert(v301, value69)
            end
          end

          if #v301 == 0 then
            return false, roxyHubState.FeedSkipMaxAge ~= false
                and "All placed pets are already max level (Age 100)"
              or "No matching pets selected"
          end

          feedTargetMode = roxyHubState.FeedTargetMode or roxyHubState.FeedPriorityMode
            or "Smart Priority (Highest Headroom)"

          table.sort(v301, function(p68, p69)
            if feedTargetMode == "Highest Max Income (VIP First)" then
              if p68.MaxIncome ~= p69.MaxIncome then
                return p68.MaxIncome > p69.MaxIncome
              end

              return p68.Headroom > p69.Headroom
            elseif feedTargetMode == "Lowest Level First (Balance Ages)" then
              if p68.Age ~= p69.Age then
                return p68.Age < p69.Age
              end

              return p68.Headroom > p69.Headroom
            elseif p68.Headroom ~= p69.Headroom then
              return p68.Headroom > p69.Headroom
            else
              if p68.MaxIncome ~= p69.MaxIncome then
                return p68.MaxIncome > p69.MaxIncome
              end

              return p68.BaseWeight > p69.BaseWeight
            end
          end)
        end

        local function f44()
          local v304 = {}

          for index58, value71 in ipairs({
            localPlayer2.Character, localPlayer2:FindFirstChild("Backpack"),
          }) do
            if value71 then
              for index59, value72 in ipairs(value71:GetChildren()) do
                if value72:IsA("Tool") and not value72:HasTag("Pet")
                  and not value72:HasTag("Egg") and not value72:HasTag("Radar") then
                  local food = value72:HasTag("Food")

                  if food then
                    if food then
                      local v305 = v276 and v276[value72.Name] or {}
                      local v306 = v305.NoFeedAll == true

                      local v307 = v306

                      v307 = v306 or value72.Name == "Dragonfruit"
                        or value72.Name == "Magic Apple"

                      local v308 = roxyHubState.FeedAllowPremiumFood ~= false
                      local v309 = true

                      if v307 and not v308 then
                        v309 = false
                      end

                      if roxyHubState.FeedFoodSelection
                        and roxyHubState.FeedFoodSelection ~= "All Foods"
                        and value72.Name ~= roxyHubState.FeedFoodSelection then
                        v309 = false
                      end

                      local v310 = 1
                      local data2 = value72:FindFirstChild("Data")

                      if data2 and data2:FindFirstChild("Amount") then
                        v310 = tonumber(data2.Amount.Value) or 0
                      end

                      if v309 and v310 > 0 then
                        table.insert(v304, {
                          Tool = value72,
                          Name = value72.Name,
                          XP = tonumber(v305.XP) or 0,
                          Amount = v310,
                        })
                      end
                    end
                  else
                    return
                  end
                end
              end
            end
          end

          table.sort(v304, function(p70, p71) return p70.XP > p71.XP end)
          return v304
        end

        local v311 = f44()

        if #v311 == 0 then
          return false, "No valid food items available in backpack"
        else
          local v312 = v301[1]
          local v313 = v311[1]
          local tool2 = v313.Tool

          if tool2.Parent ~= localPlayer2.Character and v274 then
            v274:EquipTool(tool2)
            local v314 = os.clock()

            while tool2.Parent ~= localPlayer2.Character and os.clock() - v314 < 0.8 do
              task.wait(0.05)
            end
          end

          if tool2.Parent ~= localPlayer2.Character then
            return false, "Failed to equip food tool " .. tostring(v313.Name)
          else
            local cframe7 = nil
            local primaryPart = v312.PrimaryPart

            local basePart = primaryPart
            basePart = primaryPart or v312.Model:FindFirstChildWhichIsA("BasePart")

            if basePart and v273 then
              if (v273.Position - basePart.Position).Magnitude > 7 and not v33.IsFarming then
                cframe7 = v273.CFrame
                v273.CFrame = basePart.CFrame * CFrame.new(0, 1, 3.5)
                task.wait(0.1)
              end
            end

            local feed = basePart
              and (basePart:FindFirstChild("Feed") or v312.Model:FindFirstChild("Feed", true))

            if feed and feed:IsA("ProximityPrompt") then
              pcall(function()
                feed.Enabled = true
                feed.HoldDuration = 0
                feed.RequiresLineOfSight = false
                feed.MaxActivationDistance = 9999
              end)

              if fireproximityprompt then
                pcall(fireproximityprompt, feed, 0)
              end
            end

            feedPet:FireServer(v312.PetKey, v313.Name)
            task.wait(0.4)
            local v315 = 1

            if p67 then
              local v316 = 1

              while true do
                v316 = 1 + v316

                if not (5 >= v316) then
                  break
                end

                local age = tonumber(v312.Model:GetAttribute("Age")) or v312.Age

                if roxyHubState.FeedSkipMaxAge ~= false and age >= v284 then
                  break
                else
                  local data3 = tool2:FindFirstChild("Data")

                  if (data3 and data3:FindFirstChild("Amount") and tonumber(data3.Amount.Value)
                      or 0)
                    <= 0 then
                    break
                  end

                  feedPet:FireServer(v312.PetKey, v313.Name)
                  v315 = v315 + 1
                  task.wait(0.4)
                end
              end
            end

            if cframe7 and v273 and v273.Parent then
              v273.CFrame = cframe7
            end

            return true, string.format(
              "Fed %d %s to %s (Age %s)", v315, v313.Name, v312.Name,
              tostring(v312.Model:GetAttribute("Age") or v312.Age)
            )
          end
        end
      end
    end
  end
end

task.spawn(function()
  while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
    if roxyHubState.AutoFeedPets and not v33.IsFarming then
      pcall(function() f43(false) end)
      task.wait(0.1)
    else
      task.wait(0.5)
    end
  end
end)

task.spawn(function()
  local function f45(p72)
    if not p72 then
      return
    end

    for index60, value73 in ipairs(p72:GetChildren()) do
      local v317 = value73

      if v317:IsA("GuiObject") and v317.Name:find("-") then
        local petHolder = v317:FindFirstChild("PetHolder") or v317

        if petHolder and not v317:GetAttribute("RoxyHooked") then
          v317:SetAttribute("RoxyHooked", true)

          petHolder.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
              or input.UserInputType == Enum.UserInputType.Touch then
              roxyHubState.SelectedPetKey = v317.Name
              roxyHubState.FeedTargetMode = "Selected Pet Only"

              local text2 = petHolder:FindFirstChild("PetName", true)
                  and petHolder:FindFirstChild("PetName", true).Text
                or "Pet"

              if UIControls.FeedTargetMode and UIControls.FeedTargetMode.Set then
                pcall(function() UIControls.FeedTargetMode:Set("Selected Pet Only") end)
              end

              if WindUI and WindUI.Notify then
                WindUI:Notify({
                  Title = "Target Pet Locked",
                  Content = string.format("Locked onto %s from in-game list", text2),
                  Duration = 2,
                  Icon = "shield-check",
                })
              end
            end
          end)
        end
      end
    end
  end

  while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
    pcall(function()
      local main2 = localPlayer2:FindFirstChild("PlayerGui")
        and localPlayer2.PlayerGui:FindFirstChild("Main")

      local petsTracker = main2 and main2:FindFirstChild("PetsTracker")
      local holder4 = petsTracker and petsTracker:FindFirstChild("Holder")

      if holder4 then
        f45(holder4)
      end
    end)

    task.wait(2)
  end
end)

local v318

pcall(function()
  if isfile and readfile and isfile("WindUI_Cache.lua") then
    local windUICacheLua = readfile("WindUI_Cache.lua")

    if windUICacheLua and #windUICacheLua > 5000 then
      v318 = windUICacheLua
    end
  end
end)

if not v318 then
  local v319, v320 = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")
  end)

  if v319 and v320 and #v320 > 5000 then
    v318 = v320

    if writefile then
      pcall(function() writefile("WindUI_Cache.lua", v318) end)
    end
  end
end

if not v318 then
  error("[RoxyHub] Failed to load WindUI engine. Check connection or WindUI_Cache.lua.", 0)
end

-- WindUI runtime compatibility patch: use Roblox's built-in Gotham family and
-- disable the font-registry rewrite that can cross a restricted capability boundary.
pcall(function()
  v318 = v318:gsub("rbxassetid://12187365364", "rbxasset://fonts/families/GothamSSm.json")
  v318 = v318:gsub("function p.AddFontObject%(r%)%s*table%.insert%(p.FontObjects,r%)%s*p%.UpdateFont%(p%.Font%)%s*end", "function p.AddFontObject(r)\n table.insert(p.FontObjects,r)\nend")
  v318 = v318:gsub("function p.UpdateFont%(r%)%s*p%.Font=r%s*for u,v in next,p%.FontObjects do%s*v%.FontFace=Font%.new%(r,v%.FontFace%.Weight,v%.FontFace%.Style%)%s*end%s*end", "function p.UpdateFont(r)\n p.Font=r\nend")
end)

local v321, v322 = loadstring(v318)

if not v321 then
  error("[RoxyHub] WindUI compile failed: " .. tostring(v322), 0)
end

local v323, v324 = pcall(v321)

if not v323 or type(v324) ~= "table" then
  error("[RoxyHub] WindUI initialization failed: " .. tostring(v324), 0)
end

Color3.fromHex("#3B82F6")
Color3.fromHex("#1D4ED8")
Color3.fromHex("#60A5FA")
Color3.fromHex("#1E3A8A")
Color3.fromHex("#0B0F19")
Color3.fromHex("#1E293B")
Color3.fromHex("#3B82F6")
Color3.fromHex("#0F172A")
Color3.fromHex("#1E3A8A")
Color3.fromHex("#1E293B")
Color3.fromHex("#2563EB")
Color3.fromHex("#F8FAFC")
Color3.fromHex("#94A3B8")
Color3.fromHex("#1E3A8A")
Color3.fromHex("#1D4ED8")
Color3.fromHex("#2563EB")
Color3.fromHex("#0F172A")
Color3.fromHex("#38BDF8")
Color3.fromHex("#000000")
Color3.fromHex("#38BDF8")
Color3.fromHex("#1E3A8A")

local function f46(p73)
  local playerGui2

  if not playerGui2 then
    playerGui2 = localPlayer2:WaitForChild("PlayerGui")
  end

  pcall(function()
    local roxyHubMobileToggle = playerGui2:FindFirstChild("RoxyHub_MobileToggle")

    if roxyHubMobileToggle then
      roxyHubMobileToggle:Destroy()
    end

    local roxyHubMobileToggle2 = localPlayer2.PlayerGui:FindFirstChild("RoxyHub_MobileToggle")

    if roxyHubMobileToggle2 then
      roxyHubMobileToggle2:Destroy()
    end

    local roxyHubMobileToggle3 = coreGui:FindFirstChild("RoxyHub_MobileToggle")

    if roxyHubMobileToggle3 then
      roxyHubMobileToggle3:Destroy()
    end
  end)

  local roxyHubMobileToggle4 = Instance.new("ScreenGui")
  roxyHubMobileToggle4.Name = "RoxyHub_MobileToggle"
  roxyHubMobileToggle4.ResetOnSpawn = false
  roxyHubMobileToggle4.DisplayOrder = 999999
  roxyHubMobileToggle4.IgnoreGuiInset = true
  roxyHubMobileToggle4.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  roxyHubMobileToggle4.Enabled = false
  roxyHubMobileToggle4.Parent = playerGui2

  local roxyToggleBtn = Instance.new("ImageButton")
  roxyToggleBtn.Name = "RoxyToggleBtn"
  roxyToggleBtn.Size = UDim2.new(0, 56, 0, 56)
  roxyToggleBtn.Position = UDim2.new(0.35, 0, 0.15, 0)
  roxyToggleBtn.BackgroundColor3 = Color3.fromHex("#0B0F19")
  roxyToggleBtn.BackgroundTransparency = 0.2
  roxyToggleBtn.Image = "rbxassetid://85047195026655"
  roxyToggleBtn.ScaleType = Enum.ScaleType.Fit
  roxyToggleBtn.AutoButtonColor = false
  roxyToggleBtn.ZIndex = 99999
  roxyToggleBtn.Parent = roxyHubMobileToggle4

  local uiCorner6 = Instance.new("UICorner")
  uiCorner6.CornerRadius = UDim.new(1, 0)
  uiCorner6.Parent = roxyToggleBtn

  local uiStroke = Instance.new("UIStroke")
  uiStroke.Thickness = 2.5
  uiStroke.Color = Color3.fromHex("#38BDF8")
  uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
  uiStroke.Parent = roxyToggleBtn

  local v325 = false
  local v326 = 0
  local v327 = false
  local position10, position11

  local function f47(p74)
    local v328 = p74.Position - position11

    local viewportSize = workspaceService.CurrentCamera
        and workspaceService.CurrentCamera.ViewportSize
      or Vector2.new(1920, 1080)

    local v329 = math.clamp(position10.X.Offset + v328.X, 5, viewportSize.X - 61)
    local v330 = math.clamp(position10.Y.Offset + v328.Y, 5, viewportSize.Y - 61)
    roxyToggleBtn.Position = UDim2.new(0, v329, 0, v330)
  end

  roxyToggleBtn.InputBegan:Connect(function(input2)
    if input2.UserInputType == Enum.UserInputType.MouseButton1
      or input2.UserInputType == Enum.UserInputType.Touch then
      v325 = true
      v327 = false
      position10 = roxyToggleBtn.Position
      position11 = input2.Position
      v326 = tick()

      tweenService:Create(
        roxyToggleBtn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 50, 0, 50) }
      ):Play()

      tweenService:Create(uiStroke, TweenInfo.new(0.12), {
        Color = Color3.fromHex("#60A5FA"),
        Thickness = 3,
      }):Play()

      input2.Changed:Connect(function()
        if input2.UserInputState == Enum.UserInputState.End then
          v325 = false
        end
      end)
    end
  end)

  roxyToggleBtn.InputChanged:Connect(function(input3)
    if v325
      and (input3.UserInputType == Enum.UserInputType.MouseMovement
        or input3.UserInputType == Enum.UserInputType.Touch) then
      if (input3.Position - position11).Magnitude > 6 then
        v327 = true
      end

      if v327 then
        f47(input3)
      end
    end
  end)

  roxyToggleBtn.InputEnded:Connect(function(input4)
    if input4.UserInputType == Enum.UserInputType.MouseButton1
      or input4.UserInputType == Enum.UserInputType.Touch then
      v325 = false

      tweenService:Create(
        roxyToggleBtn, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 56, 0, 56) }
      ):Play()

      tweenService:Create(uiStroke, TweenInfo.new(0.15), {
        Color = Color3.fromHex("#38BDF8"),
        Thickness = 2.5,
      }):Play()

      local v331 = tick() - v326
      local magnitude5 = (input4.Position - (position11 or input4.Position)).Magnitude

      if not v327 and magnitude5 < 10 and v331 < 0.35 then
        pcall(function()
          if v2 then
            f2()
          end

          if p73.Closed then
            p73:Open()
          else
            p73:Close()
          end
        end)
      end
    end
  end)

  roxyToggleBtn.MouseEnter:Connect(function()
    tweenService:Create(uiStroke, TweenInfo.new(0.2), {
      Color = Color3.fromHex("#93C5FD"),
      Thickness = 3.5,
    }):Play()
  end)

  roxyToggleBtn.MouseLeave:Connect(function()
    tweenService:Create(uiStroke, TweenInfo.new(0.2), {
      Color = Color3.fromHex("#38BDF8"),
      Thickness = 2.5,
    }):Play()
  end)

  table.insert(_G.RoxyHubConnections, {
    Disconnect = function() pcall(function() roxyHubMobileToggle4:Destroy() end) end,
  })

  return roxyHubMobileToggle4
end

-- Register custom theme BEFORE CreateWindow
if v324 and v324.AddTheme then
    v324:AddTheme({
        Name = "RoxyHub",

        Accent = Color3.fromHex("#1D4ED8"),
        Dialog = Color3.fromHex("#0F172A"),
        Text = Color3.fromHex("#F8FAFC"),
        Placeholder = Color3.fromHex("#94A3B8"),
        Background = Color3.fromHex("#0B0F19"),
        Button = Color3.fromHex("#2563EB"),
        Icon = Color3.fromHex("#38BDF8"),

        Primary = Color3.fromHex("#3B82F6"),
        Toggle = Color3.fromHex("#3B82F6"),
        Slider = Color3.fromHex("#3B82F6"),
        Checkbox = Color3.fromHex("#3B82F6"),

        PanelBackground = Color3.fromHex("#0F172A"),
        PanelBackgroundTransparency = 0.15,

        ElementBackground = Color3.fromHex("#1E293B"),
        ElementBackgroundTransparency = 0,
    })
end

local window = v324:CreateWindow({
  Title = "Ride A Pet",
  Icon = "rbxassetid://85047195026655",
  IconSize = 44,
  Author = "by RoxyHub",
  Folder = "RoxyHub_RideAPet",
  Size = UDim2.fromOffset(620, 510),
  Transparent = true,
  Theme = "RoxyHub",
  Resizable = true,
  OpenButton = { Enabled = false },
})

_G.RoxyHubInstance = window

pcall(function()
  if window and window.UIElements and window.UIElements.Main and window.UIElements.Main.Main then
    for index61, value74 in ipairs(window.UIElements.Main.Main.Topbar.Left:GetChildren()) do
      if value74:IsA("Frame") and value74.Name == "Frame" then
        value74.Size = UDim2.new(0, 44, 0, 44)

        for index62, value75 in ipairs(value74:GetChildren()) do
          if value75:IsA("Frame") then
            value75.Size = UDim2.new(0, 44, 0, 44)
            value75.AnchorPoint = Vector2.new(0.5, 0.5)
            value75.Position = UDim2.new(0.5, 0, 0.5, 0)
          end
        end
      end
    end
  end
end)

local v332 = f46(window)
window:Tag({ Title = "Free", Color = Color3.fromHex("#1E3A8A"), Border = true })
local autoFarmTab = window:Tab({ Title = "Auto Farm", Icon = "flame" })
local plotPetsTab = window:Tab({ Title = "Plot & Pets", Icon = "box" })
local eggESPTab = window:Tab({ Title = "Egg ESP", Icon = "eye" })
local teleportsTab = window:Tab({ Title = "Teleports", Icon = "navigation" })
local playerTab = window:Tab({ Title = "Player", Icon = "user" })
local settingsTab = window:Tab({ Title = "Settings", Icon = "settings" })
local v333 = {}

local function f48(p75, p76, p77)
  local v334 = os.clock()
  f1(0.76, "Building " .. p76 .. " tab...")

  local v335, v336 = xpcall(p77, function(p78)
    if debug and debug.traceback then
      return debug.traceback(tostring(p78), 2)
    end

    return tostring(p78)
  end)

  if not v335 then
    warn(string.format("[RoxyHub %s Error]: %s", p76, tostring(v336)))

    pcall(function()
      p75:Section({ Title = p76 .. " Status", Opened = true }):Paragraph({
        Title = "Initialization Notice",
        Desc = string.sub(tostring(v336), 1, 180),
      })

      if v324 and v324.Notify then
        v324:Notify({
          Title = p76 .. " Status",
          Content = string.sub(tostring(v336), 1, 80),
          Duration = 6,
          Icon = "alert-triangle",
        })
      end
    end)
  else
    print(string.format("[RoxyHub] %s tab built in %.2fs", p76, os.clock() - v334))
  end

  task.wait()
end

f48(autoFarmTab, "Auto Farm", function()
  local section = autoFarmTab:Section({ Title = "Farm Realtime Monitor", Opened = true })

  local function f49()
    local v337 = ""

    if v33.TargetWeight and v33.TargetWeight > 0 then
      v337 = " | " .. f20(v33.TargetWeight)
    end

    return string.format([[
Target: %s [%s]%s
Collected: %d eggs
Mode: %s | Sync Delay: %.2fs]], tostring(v33.Target or "None"), tostring(v33.TargetRarity or "None"), v337, tonumber(v33.CollectedCount or 0), tostring(roxyHubState.FarmMode or "Safe Tween"), tonumber(roxyHubState.SyncDelay or 0.35))
  end

  section:Paragraph({ Title = "Status: " .. tostring(v33.Status or "Idle"), Desc = f49() })

  task.spawn(function()
    while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
      task.wait(0.3)
    end
  end)

  task.spawn(function()
    local v338

    while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
      task.wait(1.5)
      local serverData3 = replicatedStorage:FindFirstChild("ServerData")
      local activeWeathers2 = serverData3 and serverData3:GetAttribute("ActiveWeathers")

      if activeWeathers2 and activeWeathers2 ~= "" and activeWeathers2 ~= "[]" then
        local v339, v340 = pcall(function() return httpService:JSONDecode(activeWeathers2) end)

        if v339 and type(v340) == "table" and #v340 > 0 then
          local getServerTimeNow4 = workspaceService:GetServerTimeNow()
          local v341 = false

          for index63, value76 in ipairs(v340) do
            if not value76.EndsAt or value76.EndsAt > getServerTimeNow4 then
              local v342 = value76.Type
              v341 = true

              local v343 = (v342 or "Weather") .. ":"
                .. tostring(value76.Variant or value76.Name or "Event")

              if v343 ~= v338 then
                v338 = v343

                if roxyHubState.WeatherNotify and v324 and v324.Notify then
                  v2331 = value76.EndsAt
                    and math.max(0, math.floor(value76.EndsAt - getServerTimeNow4))
                end
              end

              break
            end
          end

          if not v341 then
            v338 = nil
          end
        else
          v338 = nil
        end
      else
        v338 = nil
      end
    end
  end)

  local section2 = autoFarmTab:Section({ Title = "Auto Farm Controls", Opened = true })

  v333.AutoFarm = section2:Toggle({
    Title = "Master Auto Farm",
    Value = roxyHubState.AutoFarm,
    Callback = function(value77) roxyHubState.AutoFarm = value77 end,
  })

  v333.FarmMode = section2:Dropdown({
    Title = "Farm Mode",
    Values = { "Safe Tween", "Instant" },
    Value = roxyHubState.FarmMode or "Instant",
    Callback = function(value78) roxyHubState.FarmMode = value78 end,
  })

  v333.MinFarmRarity = section2:Dropdown({
    Title = "Minimum Egg Rarity",
    Values = {
      "All Eggs", "Rare & Above", "Epic & Above", "Legendary & Above", "Mythic & Above",
      "Divine & Above", "Ethereal Only",
    },
    Value = roxyHubState.MinFarmRarity,
    Callback = function(value79) f11(value79) end,
  })

  v333.TargetSpecificEgg = section2:Dropdown({
    Title = "Target Specific Egg",
    Values = values,
    Value = roxyHubState.TargetSpecificEgg,
    Callback = function(value80) roxyHubState.TargetSpecificEgg = value80 end,
  })

  v333.FarmPriority = section2:Dropdown({
    Title = "Target Priority Order",
    Values = {
      "Highest Rarity First", "Closest Distance First", "Highest Luck First",
      "Heaviest Weight First",
    },
    Value = roxyHubState.FarmPriority,
    Callback = function(value81) roxyHubState.FarmPriority = value81 end,
  })

  v333.PrioritizeHeaviest = section2:Toggle({
    Title = "Prioritize Heaviest Eggs",
    Value = roxyHubState.PrioritizeHeaviest or false,
    Callback = function(value82) roxyHubState.PrioritizeHeaviest = value82 end,
  })

  v333.MinEggWeight = section2:Slider({
    Title = "Minimum Egg Weight (KG)",
    Step = 10,
    Value = { Min = 0, Max = 10000, Default = roxyHubState.MinEggWeight or 0 },
    Callback = function(value83) roxyHubState.MinEggWeight = tonumber(value83) or 0 end,
  })

  local section3 = autoFarmTab:Section({ Title = "Weather & Mutation Sniper", Opened = true })

  v333.PrioritizeMutations = section3:Toggle({
    Title = "Prioritize Mutated Eggs",
    Value = roxyHubState.PrioritizeMutations,
    Callback = function(value84) roxyHubState.PrioritizeMutations = value84 end,
  })

  v333.WeatherEggWait = section3:Toggle({
    Title = "Wait for Storm Mutations",
    Value = roxyHubState.WeatherEggWait,
    Callback = function(value85) roxyHubState.WeatherEggWait = value85 end,
  })

  v333.MinMutationTier = section3:Dropdown({
    Title = "Minimum Mutation Tier",
    Values = {
      "All Mutations (Shocked+)", "Volted & Above (3x+)", "Rage & Above (4x+)",
      "Void & Above (10x+)", "Magma & Above (10x+)", "Eternal Only (100x)",
    },
    Value = roxyHubState.MinMutationTier or "All Mutations (Shocked+)",
    Callback = function(value86) roxyHubState.MinMutationTier = value86 end,
  })

  v333.WeatherNotify = section3:Toggle({
    Title = "Weather Storm Alerts",
    Value = roxyHubState.WeatherNotify,
    Callback = function(value87) roxyHubState.WeatherNotify = value87 end,
  })

  v333.AutoMagmaDip = section3:Toggle({
    Title = "Auto Magma Lava Dip (10x)",
    Value = roxyHubState.AutoMagmaDip,
    Callback = function(value88) roxyHubState.AutoMagmaDip = value88 end,
  })

  local section4 = autoFarmTab:Section({ Title = "Smart Auto Rebirth Engine", Opened = true })

  local function f50(p79)
    local v344

    if not p79 then
      local savedData3 = localPlayer2:FindFirstChild("SavedData")

      local rebirths2 = savedData3 and savedData3:FindFirstChild("Rebirths")
          and tonumber(savedData3.Rebirths.Value)
        or 0

      local cash = savedData3 and savedData3:FindFirstChild("Cash")
          and tonumber(savedData3.Cash.Value)
        or 0

      return string.format("Rebirth: Tier %d -> %d [Farming]", rebirths2, rebirths2 + 1), string.format([[
Required Pet: Checking...
Cash Progress: $%s
Auto Rebirth: %s]], f19(cash), roxyHubState.AutoRebirth and "ON" or "OFF")
    elseif p79.isMaxCap then
      return "Rebirth: MAX CAP REACHED", string.format([[
Current Tier: %d / %d
Congratulations! You have reached maximum rebirth cap in game.]], p79.currentRebirth, p79.maxCap)
    else
      local v345 = "Missing (Hunting Egg)"

      if p79.hasPet then
        v345 = "Owned (" .. tostring(p79.petLoc or "SavedData") .. ")"
      elseif p79.isIncubating then
        local incubatingTime4 = p79.incubatingTime and " - " .. tostring(p79.incubatingTime)
          or ""

        v345 = string.format(
          "Incubating 1 %s%s", tostring(p79.incubatingEggName or "Egg"), incubatingTime4
        )
      end

      local v346 = "$" .. f19(p79.currentCash) .. " / $" .. f19(p79.reqCash)

      local v347 = math.clamp((tonumber(p79.currentCash) or 0)
          / math.max(tonumber(p79.reqCash) or 1, 1)
        * 100, 0, 100)

      if p79.canRebirth then
        v344 = "READY TO REBIRTH"
      elseif not p79.hasPet then
        if p79.isIncubating then
          v344 = string.format("Incubating 1 %s", tostring(p79.incubatingEggName or "Egg"))
        else
          v344 = string.format("Hunting %s Egg", tostring(p79.reqPet or "Target"))
        end
      else
        v344 = "Farming Cash"
      end

      local rebirthEggName = v33.RebirthEggName
          and v33.RebirthEggName
            .. string.format(" (%.2f%%)", (v33.RebirthEggChance or 0) * 100)
        or "Auto Detecting..."

      if p79.hasPet then
        rebirthEggName = "Not Needed (Pet Owned)"
      elseif p79.isIncubating then
        local incubatingTime5 = p79.incubatingTime and " - " .. tostring(p79.incubatingTime)
          or ""

        rebirthEggName = string.format(
          "Incubating 1 %s%s", tostring(p79.incubatingEggName or "Egg"), incubatingTime5
        )
      end

      return string.format(
        "Rebirth: Tier %d -> %d [%s]", tonumber(p79.currentRebirth) or 0,
        tonumber(p79.nextTier) or 1, v344
      ), (string.format([[
Required Pet: %s [%s]
Cash Progress: %s (%.1f%%)
Auto Rebirth: %s | Target Egg: %s]], tostring(p79.reqPet or "N/A"), v345, v346, v347, roxyHubState.AutoRebirth and "ON" or "OFF", rebirthEggName))
    end
  end

  local v348, v349
  pcall(function() v348, v349 = f50((f25())) end)

  section4:Paragraph({
    Title = v348 or "Rebirth: In Progress",
    Desc = v349 or "Auto Rebirth: Initialized",
  })

  task.defer(function() end)

  task.spawn(function()
    while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
      task.wait(0.5)
    end
  end)

  v333.AutoRebirth = section4:Toggle({
    Title = "Master Auto Rebirth",
    Value = roxyHubState.AutoRebirth,
    Callback = function(value89)
      roxyHubState.AutoRebirth = value89

      if value89 then
        roxyHubState.AutoHatchPlot = true
        roxyHubState.AutoPlaceNest = true
      end
    end,
  })

  v333.PrioritizeRebirthPet = section4:Toggle({
    Title = "Prioritize Rebirth Pet",
    Value = roxyHubState.PrioritizeRebirthPet,
    Callback = function(value90) roxyHubState.PrioritizeRebirthPet = value90 end,
  })

  v333.AutoRebirthWhenReady = section4:Toggle({
    Title = "Auto-Rebirth When Ready",
    Value = roxyHubState.AutoRebirthWhenReady,
    Callback = function(value91) roxyHubState.AutoRebirthWhenReady = value91 end,
  })

  section4:Button({
    Title = "Manual Rebirth Now",
    Callback = function()
      local v350 = f25()

      if v350.canRebirth and not v350.isMaxCap then
        f26()

        if v324 and v324.Notify then
          v324:Notify({
            Title = "Rebirth Request Sent",
            Content = string.format("Rebirth Tier %d requested.", v350.nextTier),
            Duration = 3,
            Icon = "award",
          })
        end
      else
        local v351 = ""

        if not v350.hasPet then
          v351 = v351 .. "Missing Pet: " .. v350.reqPet .. " "
        end

        if not v350.hasCash then
          v351 = v351 .. "Insufficient Cash ($" .. f19(v350.currentCash) .. " / $"
            .. f19(v350.reqCash) .. ") "
        end

        if v350.isMaxCap then
          v351 = "Max Rebirth Cap Reached"
        end

        if v324 and v324.Notify then
          v324:Notify({
            Title = "Cannot Rebirth",
            Content = v351,
            Duration = 4,
            Icon = "alert-triangle",
          })
        end
      end
    end,
  })
end)

local dropdown

f48(plotPetsTab, "Plot & Pets", function()
  local section5 = plotPetsTab:Section({ Title = "Plot Eggs & Planting", Opened = true })

  v333.AutoHatchPlot = section5:Toggle({
    Title = "Auto-Hatch Ready Eggs",
    Value = roxyHubState.AutoHatchPlot,
    Callback = function(value92) roxyHubState.AutoHatchPlot = value92 end,
  })

  v333.AutoPlaceNest = section5:Toggle({
    Title = "Auto-Plant Eggs on Plot",
    Value = roxyHubState.AutoPlaceNest,
    Callback = function(value93) roxyHubState.AutoPlaceNest = value93 end,
  })

  v333.SpawnNest = section5:Toggle({
    Title = "Spawn Nest (15/10 Glitch)",
    Value = roxyHubState.SpawnNest,
    Callback = function(value94)
      roxyHubState.SpawnNest = value94

      if f17 then
        pcall(function() f17(value94) end)
      end
    end,
  })

  local section6 = plotPetsTab:Section({ Title = "Plot Upgrades & Placement", Opened = true })

  v333.AutoUpgradeLuck = section6:Toggle({
    Title = "Auto-Upgrade Hatch Luck",
    Value = roxyHubState.AutoUpgradeLuck,
    Callback = function(value95) roxyHubState.AutoUpgradeLuck = value95 end,
  })

  if roxyHubState.AutoPlaceBestPets == nil then
    roxyHubState.AutoPlaceBestPets = false
  end

  if roxyHubState.BestPetsStrategy == nil then
    roxyHubState.BestPetsStrategy = "Smart Potential (Lv 100 Max Income)"
  end

  v333.AutoPlaceBestPets = section6:Toggle({
    Title = "Auto-Place Best Pets",
    Value = roxyHubState.AutoPlaceBestPets,
    Callback = function(value96) roxyHubState.AutoPlaceBestPets = value96 end,
  })

  v333.BestPetsStrategy = section6:Dropdown({
    Title = "Best Pets Strategy",
    Values = { "Smart Potential (Lv 100 Max Income)", "Current Cash/s (Game Default)" },
    Value = roxyHubState.BestPetsStrategy,
    Callback = function(value97) roxyHubState.BestPetsStrategy = value97 end,
  })

  section6:Button({
    Title = "Equip / Place Best Pets Now",
    Callback = function()
      local v352, v353 = pcall(function() return f41(roxyHubState.BestPetsStrategy) end)

      if v352 and v324 and v324.Notify then
        v324:Notify({
          Title = "Smart Best Pets",
          Content = tostring(v353 or "Complete!"),
          Duration = 3,
        })
      end
    end,
  })

  local section7 = plotPetsTab:Section({ Title = "Auto Feed Pets", Opened = false })

  if roxyHubState.AutoFeedPets == nil then
    roxyHubState.AutoFeedPets = false
  end

  if roxyHubState.FeedTargetMode == nil then
    roxyHubState.FeedTargetMode = "Smart Priority (Highest Headroom)"
  end

  if roxyHubState.SelectedPetKey == nil then
    roxyHubState.SelectedPetKey = nil
  end

  if roxyHubState.FeedPriorityMode == nil then
    roxyHubState.FeedPriorityMode = "Smart Potential (Highest Headroom)"
  end

  if roxyHubState.FeedSkipMaxAge == nil then
    roxyHubState.FeedSkipMaxAge = true
  end

  if roxyHubState.FeedAllowPremiumFood == nil then
    roxyHubState.FeedAllowPremiumFood = true
  end

  if roxyHubState.FeedFoodSelection == nil then
    roxyHubState.FeedFoodSelection = "All Foods"
  end

  local function f51()
    local v354 = { "All Placed Pets (Smart Priority)" }
    local v355 = { ["All Placed Pets (Smart Priority)"] = "ALL" }
    local v356 = { ALL = "All Placed Pets (Smart Priority)" }

    pcall(function()
      local v357 = f12()
      local pets5 = v357 and (v357:FindFirstChild("Pets") or v357:FindFirstChild("PlacedPets"))

      if pets5 then
        for index64, value98 in ipairs(pets5:GetChildren()) do
          local petName5 = value98:GetAttribute("PetName") or value98.Name
          local v358 = tonumber(value98:GetAttribute("Age")) or 1
          local v359 = tonumber(value98:GetAttribute("Weight")) or 1
          local petKey4 = value98:GetAttribute("PetKey") or value98.Name
          local v360 = v358 >= 100 and " [MAX]" or ""

          local v361 = string.format(
            "%d. %s (Age %d | %.1f KG)%s", index64, tostring(petName5), v358, v359, v360
          )

          table.insert(v354, v361)
          v355[v361] = petKey4
          v356[petKey4] = v361
        end
      end
    end)

    return v354, v355, v356
  end

  local v362, v363, v364 = f51()
  local v365 = v364

  v333.AutoFeedPets = section7:Toggle({
    Title = "Auto Feed Pets",
    Value = roxyHubState.AutoFeedPets,
    Callback = function(value99) roxyHubState.AutoFeedPets = value99 end,
  })

  v333.FeedTargetMode = section7:Dropdown({
    Title = "Target Mode",
    Values = {
      "Smart Priority (Highest Headroom)", "Selected Pet Only",
      "Highest Max Income (VIP First)", "Lowest Level First (Balance Ages)",
    },
    Value = roxyHubState.FeedTargetMode or "Smart Priority (Highest Headroom)",
    Callback = function(value100) roxyHubState.FeedTargetMode = value100 end,
  })

  dropdown = section7:Dropdown({
    Title = "Select Target Pet",
    Values = v362,
    Value = roxyHubState.SelectedPetKey and v365 and v365[roxyHubState.SelectedPetKey]
      or v362[1] or "No Placed Pets Detected",
    Callback = function(value101)
      if v363[value101] then
        roxyHubState.SelectedPetKey = v363[value101]
        roxyHubState.FeedTargetMode = "Selected Pet Only"

        if v333.FeedTargetMode and v333.FeedTargetMode.Set then
          pcall(function() v333.FeedTargetMode:Set("Selected Pet Only") end)
        end

        if v324 and v324.Notify then
          v324:Notify({
            Title = "Target Pet Locked",
            Content = tostring(value101),
            Duration = 2,
            Icon = "shield-check",
          })
        end
      end
    end,
  })

  v333.SelectedPetKey = dropdown

  section7:Button({
    Title = "Feed Target Pet Now",
    Callback = function()
      local v366, v367 = pcall(function() return f43(true) end)

      if v366 and v324 and v324.Notify then
        v324:Notify({
          Title = "Smart Feed",
          Content = tostring(v367 or "Complete!"),
          Duration = 3,
          Icon = "shield-check",
        })
      end
    end,
  })

  section7:Button({
    Title = "Refresh Pets List",
    Callback = function()
      local v368, v369, v370 = f51()
      v363 = v369
      v365 = v370

      if dropdown and dropdown.Refresh then
        pcall(function() dropdown:Refresh(v368) end)
      end

      if v324 and v324.Notify then
        v324:Notify({
          Title = "Pet List Refreshed",
          Content = string.format("Detected %d pets on ranch", #v368),
          Duration = 2,
          Icon = "refresh-cw",
        })
      end
    end,
  })

  v333.FeedSkipMaxAge = section7:Toggle({
    Title = "Skip Max Age Pets (Age 100)",
    Value = roxyHubState.FeedSkipMaxAge,
    Callback = function(value102) roxyHubState.FeedSkipMaxAge = value102 end,
  })

  v333.FeedAllowPremiumFood = section7:Toggle({
    Title = "Allow Premium Food (Dragonfruit / Apple)",
    Value = roxyHubState.FeedAllowPremiumFood,
    Callback = function(value103) roxyHubState.FeedAllowPremiumFood = value103 end,
  })

  v333.FeedFoodSelection = section7:Dropdown({
    Title = "Food Type Filter",
    Values = { "All Foods", "Dragonfruit", "Magic Apple", "Meat", "Bone", "Grass" },
    Value = roxyHubState.FeedFoodSelection,
    Callback = function(value104) roxyHubState.FeedFoodSelection = value104 end,
  })
end)

f48(eggESPTab, "Egg ESP", function()
  local espControlsSection = eggESPTab:Section({ Title = "ESP Controls", Opened = true })

  v333.ESP_Enabled = espControlsSection:Toggle({
    Title = "Egg ESP Master Toggle",
    Value = roxyHubState.ESP_Enabled,
    Callback = function(value105)
      roxyHubState.ESP_Enabled = value105 == true

      if roxyHubState.ESP_Enabled then
        task.defer(function()
          pcall(f45_ESPRefresh)
        end)
      else
        f29()
      end
    end,
  })

  v333.ESP_VisualPreset = espControlsSection:Dropdown({
    Title = "ESP Visual Mode",
    Values = {
      "All Visuals (Highlight + Text + Tracer)", "Highlights + Floating Text",
      "Floating Text Only (Clean)", "Highlights Only (Minimal)", "Tracers Only",
    },
    Value = roxyHubState.ESP_VisualPreset,
    Callback = function(value106) f10(value106)
      task.defer(function() pcall(f45_ESPRefresh) end)
    end,
  })

  v333.ESP_MinRarity = espControlsSection:Dropdown({
    Title = "Minimum ESP Rarity",
    Values = {
      "All Eggs", "Rare & Above", "Epic & Above", "Legendary & Above", "Mythic & Above",
      "Divine & Above", "Ethereal Only",
    },
    Value = roxyHubState.ESP_MinRarity,
    Callback = function(value107)
      roxyHubState.ESP_MinRarity = value107
      if roxyHubState.ESP_Enabled then
        task.defer(function() pcall(f45_ESPRefresh) end)
      else
        f29()
      end
    end,
  })

  v333.ESP_MaxDistance = espControlsSection:Slider({
    Title = "ESP Max Render Distance",
    Step = 500,
    Value = { Min = 500, Max = 15000, Default = roxyHubState.ESP_MaxDistance },
    Callback = function(value108)
      roxyHubState.ESP_MaxDistance = tonumber(value108) or 5000
      task.defer(function() pcall(f45_ESPRefresh) end)
    end,
  })

  local paragraph = eggESPTab:Section({ Title = "Live High-Tier Radar", Opened = true }):Paragraph({
    Title = "Scanning Active Eggs...",
    Desc = "Searching map for rare eggs...",
  })

  task.spawn(function()
    while task.wait(2) do
      pcall(function()
        local renderedEggs5 = workspaceService:FindFirstChild("RenderedEggs")
        local v371, v372 = f13()

        if renderedEggs5 and v372 then
          local v373 = {}

          for index65, value109 in ipairs(renderedEggs5:GetChildren()) do
            local v374 = f4(value109.Name)
            local v375 = v17[v374] or 0

            if v375 >= 600 then
              local eggWeight = f30(value109)
              local getPivot6 = value109:GetPivot()
              local v376 = math.floor((getPivot6.Position - v372.Position).Magnitude)

              table.insert(v373, {
                Name = value109.Name,
                Rarity = v374,
                Weight = v375,
                EggWeight = eggWeight,
                Dist = v376,
              })
            end
          end

          table.sort(v373, function(p80, p81)
            if p80.Weight ~= p81.Weight then
              return p80.Weight > p81.Weight
            end

            if p80.EggWeight ~= p81.EggWeight then
              return p80.EggWeight > p81.EggWeight
            end

            return p80.Dist < p81.Dist
          end)

          local v377 = {}
          local v378 = math.min(6, #v373)
          local count4 = 0

          while true do
            count4 = 1 + count4

            if not (v378 >= count4) then
              break
            end

            local v379 = count4

            if v373[v379].EggWeight and v373[v379].EggWeight > 0 then
              table.insert(v377, string.format(
                "- %s [%s] | %s - %d studs", v373[v379].Name, v373[v379].Rarity,
                f20(v373[v379].EggWeight), v373[v379].Dist
              ))
            else
              table.insert(v377, string.format(
                "- %s [%s] - %d studs", v373[v379].Name, v373[v379].Rarity, v373[v379].Dist
              ))
            end
          end

          if #v377 == 0 then
            paragraph:SetTitle("Top Eggs Scanner")
            paragraph:SetDesc("No high-tier eggs currently spawned on map.")
          else
            paragraph:SetTitle(string.format("Top Eggs Scanner (%d Rare+ Found)", #v373))
            paragraph:SetDesc(table.concat(v377, "\n"))
          end
        end
      end)
    end
  end)
end)

if roxyHubState.ESP_Enabled then
  task.defer(function() pcall(f45_ESPRefresh) end)
end

f48(teleportsTab, "Teleports", function()
  local section8 = teleportsTab:Section({ Title = "Base & Plot Fast Travel", Opened = true })
  local v380 = "My Plot (Baseplate)"

  section8:Dropdown({
    Title = "Quick Travel Destination",
    Values = {
      "My Plot (Baseplate)", "My Plot (Nests)", "My Plot (Hatch Upgrade Area)",
      "Map Spawn Center", "Volcano (Top - Magma Altar)", "Volcano (Entrance / Volkaris Lair)",
      "Volcano Lair Door (Entrance)",
    },
    Value = "My Plot (Baseplate)",
    Callback = function(value110) v380 = value110 end,
  })

  section8:Button({
    Title = "Teleport to Destination",
    Callback = function()
      local v381, v382, v383 = f13()
      local v384 = f12()

      if not v382 then
        return
      end

      if not v380:find("Volcano") then
        f27(v382, v383)
        v2529, v382 = f13()

        if not v382 then
          return
        end
      end

      if v380 == "My Plot (Baseplate)" then
        if teleportToPlot then
          teleportToPlot:FireServer()
        end

        if v384 and v384:FindFirstChild("Baseplate") then
          v382.CFrame = v384.Baseplate.CFrame * CFrame.new(0, 4, 0)
        end

        v324:Notify({
          Title = "Teleport",
          Content = "Warped to Plot Baseplate!",
          Duration = 2,
          Icon = "check",
        })
      elseif v380 == "My Plot (Nests)" then
        if v384 and v384:FindFirstChild("Nests") then
          local nests9 = v384.Nests
          v382.CFrame = CFrame.new(nests9:GetPivot().Position + Vector3.new(0, 3, 0))

          v324:Notify({
            Title = "Teleport",
            Content = "Warped to Plot Nests!",
            Duration = 2,
            Icon = "check",
          })
        end
      elseif v380 == "My Plot (Hatch Upgrade Area)" then
        if v384 and v384:FindFirstChild("HatchUpgrade") then
          local hatchUpgrade = v384.HatchUpgrade
          v382.CFrame = CFrame.new(hatchUpgrade:GetPivot().Position + Vector3.new(0, 3, 0))

          v324:Notify({
            Title = "Teleport",
            Content = "Warped to Hatch Upgrade!",
            Duration = 2,
            Icon = "check",
          })
        end
      elseif v380 == "Map Spawn Center" then
        v382.CFrame = CFrame.new(110, 40316, 750)

        v324:Notify({
          Title = "Teleport",
          Content = "Warped to Map Center!",
          Duration = 2,
          Icon = "check",
        })
      elseif v380 == "Volcano (Top - Magma Altar)" then
        f31(v382, v383)
        local v385, v386 = f13()

        if v386 then
          v386.AssemblyLinearVelocity = Vector3.zero
          v386.AssemblyAngularVelocity = Vector3.zero
          v386.CFrame = CFrame.new(vector)

          v324:Notify({
            Title = "Teleport",
            Content = "Warped to Volcano Top (Magma Altar)!",
            Duration = 2,
            Icon = "check",
          })
        end
      elseif v380 == "Volcano (Entrance / Volkaris Lair)"
        or v380 == "Volcano Lair Door (Entrance)" then
        v382.AssemblyLinearVelocity = Vector3.zero
        v382.AssemblyAngularVelocity = Vector3.zero
        v382.CFrame = cframe

        v324:Notify({
          Title = "Teleport",
          Content = "Warped to Volcano Lair Door (Entrance)!",
          Duration = 2,
          Icon = "check",
        })
      end
    end,
  })

  section8:Button({
    Title = "Validate & Clear Checkpoints",
    Callback = function()
      local v387, v388, v389 = f13()

      if not v388 or not v389 then
        return
      end

      f27(v388, v389)

      v324:Notify({
        Title = "Checkpoints Cleared",
        Content = "Validated Door and Volcano exits successfully!",
        Duration = 3,
        Icon = "shield-check",
      })
    end,
  })

  teleportsTab:Section({ Title = "Basket Management", Opened = false }):Button({
    Title = "Empty / Drop Basket Eggs",
    Callback = function()
      pcall(function()
        local basket10 = localPlayer2:FindFirstChild("Basket")

        if basket10 and basketDrop then
          for index66, value111 in ipairs(basket10:GetChildren()) do
            basketDrop:FireServer(value111:GetAttribute("Egg") or value111.Name)
          end

          v324:Notify({
            Title = "Basket",
            Content = "All basket eggs dropped!",
            Duration = 2,
            Icon = "trash-2",
          })
        end
      end)
    end,
  })
end)

f48(playerTab, "Player", function()
  local movementModificationsSection = playerTab:Section({
    Title = "Movement Modifications",
    Opened = true,
  })

  v333.SpeedPreset = movementModificationsSection:Dropdown({
    Title = "Speed Multiplier Preset",
    Values = {
      "Default (1x Normal)", "Fast Rider (1.5x)", "High Velocity (2.5x)", "Sonic Speed (4x)",
    },
    Value = roxyHubState.SpeedPreset or "Default (1x Normal)",
    Callback = function(value112)
      roxyHubState.SpeedPreset = value112

      if value112 == "Default (1x Normal)" then
        roxyHubState.SpeedMultiplier = 1
        roxyHubState.SpeedModEnabled = false
      elseif value112 == "Fast Rider (1.5x)" then
        roxyHubState.SpeedMultiplier = 1.5
        roxyHubState.SpeedModEnabled = true
      elseif value112 == "High Velocity (2.5x)" then
        roxyHubState.SpeedMultiplier = 2.5
        roxyHubState.SpeedModEnabled = true
      elseif value112 == "Sonic Speed (4x)" then
        roxyHubState.SpeedMultiplier = 4
        roxyHubState.SpeedModEnabled = true
      end

      if v333.SpeedMultiplier and v333.SpeedMultiplier.Set then
        pcall(function() v333.SpeedMultiplier:Set(roxyHubState.SpeedMultiplier) end)
      end

      if v333.SpeedModEnabled and v333.SpeedModEnabled.Set then
        pcall(function() v333.SpeedModEnabled:Set(roxyHubState.SpeedModEnabled) end)
      end
    end,
  })

  v333.SpeedModEnabled = movementModificationsSection:Toggle({
    Title = "WalkSpeed Multiplier Active",
    Value = roxyHubState.SpeedModEnabled,
    Callback = function(value113) roxyHubState.SpeedModEnabled = value113 end,
  })

  v333.SpeedMultiplier = movementModificationsSection:Slider({
    Title = "Speed Multiplier",
    Step = 0.25,
    Value = { Min = 1, Max = 4, Default = roxyHubState.SpeedMultiplier },
    Callback = function(value114) roxyHubState.SpeedMultiplier = value114 end,
  })

  v333.NoClip = movementModificationsSection:Toggle({
    Title = "NoClip (Pass through obstacles)",
    Value = roxyHubState.NoClip,
    Callback = function(value115) roxyHubState.NoClip = value115 end,
  })

  v333.InfiniteJump = movementModificationsSection:Toggle({
    Title = "Infinite Jump",
    Value = roxyHubState.InfiniteJump,
    Callback = function(value116) roxyHubState.InfiniteJump = value116 end,
  })
end)

f48(settingsTab, "Settings", function()
  local interfaceControlsSection = settingsTab:Section({
    Title = "Interface & Controls",
    Opened = true,
  })

  interfaceControlsSection:Keybind({
    Title = "Toggle Menu Keybind",
    Default = Enum.KeyCode.RightShift,
    Callback = function() window:Toggle() end,
  })

  interfaceControlsSection:Toggle({
    Title = "Mobile Floating Button",
    Default = true,
    Callback = function(value117)
      if v332 then
        v332.Enabled = value117
      end
    end,
  })

  interfaceControlsSection:Dropdown({
    Title = "Window Theme",
    Values = { "RoxyHub", "Dark", "Rose", "Plant", "Indigo" },
    Value = "RoxyHub",
    Callback = function(value118) end,
  })

  interfaceControlsSection:Button({
    Title = "Unload / Close RoxyHub",
    Callback = function()
      if _G.RoxyHubConnections then
        for index67, value119 in ipairs(_G.RoxyHubConnections) do
          local v390 = value119
          pcall(function() v390:Disconnect() end)
        end
      end

      _G.RoxyHubConnections = {}

      for index68, value120 in ipairs(v99) do
      end

      f29()

      if v332 then
        pcall(function() v332:Destroy() end)
      end

      if window then
        window:Destroy()
      end
    end,
  })

  local section9 = settingsTab:Section({ Title = "Profiles & AutoLoad", Opened = true })

  local function f52()
    local v391 = {}

    pcall(function()
      if isfolder and isfolder("RoxyHub_RideAPet/configs") and listfiles then
        for index69, value122 in ipairs(listfiles("RoxyHub_RideAPet/configs")) do
          local json = value122:match("([^\\/]+)%.json$")

          if json and json ~= "autoload" then
            table.insert(v391, json)
          end
        end
      end
    end)

    table.sort(v391)

    if #v391 == 0 then
      table.insert(v391, "default")
    end

    return v391
  end

  local function f53(p82)
    if not writefile then
      return false, "writefile not supported"
    end

    local v392, v393, v394

    if not p82 or p82 == "" or p82 == "autoload" then
      return false, "Invalid profile name"
    else
      v392 = "RoxyHub_RideAPet/configs" .. "/" .. p82 .. ".json"
      v393 = {}

      for key13, value123 in pairs(roxyHubState) do
        v393[key13] = value123
      end

      local v395
      v395, v394 = pcall(function() return httpService:JSONEncode(v393) end)

      if not v395 then
        return false, "JSON encoding error"
      else
        local v396, v397 = pcall(function() writefile(v392, v394) end)

        if not v396 then
          return false, tostring(v397)
        end

        return true
      end
    end
  end

  local function f54(p83, p84)
    if not readfile or not isfile then
      return false, "readfile not supported"
    end

    if not p83 or p83 == "" or p83 == "autoload" then
      return false, "Invalid profile name"
    end

    local v398 = "RoxyHub_RideAPet/configs" .. "/" .. p83 .. ".json"
    local v399

    if not isfile(v398) then
      return false, "Profile not found"
    else
      local v400
      v400, v399 = pcall(function() return readfile(v398) end)

      if not v400 or not v399 then
        return false, "Read error"
      else
        local v401, v402 = pcall(function() return httpService:JSONDecode(v399) end)

        if not v401 or type(v402) ~= "table" then
          return false, "Corrupted profile"
        end

        for key14, value124 in pairs(v402) do
          if p84 and (key14 == "AutoFarm" or key14 == "AutoRebirth") then
            roxyHubState[key14] = false
          else
            roxyHubState[key14] = value124
          end
        end

        return true
      end
    end
  end

  local v403 = ""

  section9:Input({
    Title = "Create New Profile",
    Placeholder = "e.g. my_config",
    Value = "",
    Callback = function(value125)
      if value125 and value125 ~= "" then
        v403 = value125
      end
    end,
  })

  local selectProfileDropdown

  local function f55(p85)
    local v404 = f52()

    if selectProfileDropdown then
      if selectProfileDropdown.SetValues then
        pcall(function() selectProfileDropdown:SetValues(v404) end)
      end

      if selectProfileDropdown.Refresh then
        pcall(function() selectProfileDropdown:Refresh(v404, true) end)
      end

      if p85 then
        if selectProfileDropdown.Select then
          pcall(function() selectProfileDropdown:Select(p85) end)
        elseif selectProfileDropdown.Set then
          pcall(function() selectProfileDropdown:Set(p85) end)
        end
      end
    end
  end

  section9:Button({
    Title = "Create Profile",
    Callback = function()
      if v403 ~= "" then
        profile = v403
        local v405, v406 = f53(profile)

        if v405 then
          if v31 then
            pcall(function()
              writefile(
                "RoxyHub_RideAPet/configs/autoload.json",
                httpService:JSONEncode({ AutoLoad = true, Profile = profile })
              )
            end)
          end

          f55(profile)

          v324:Notify({
            Title = "Created",
            Content = string.format("Created '%s.json'!", profile),
            Duration = 3,
            Icon = "check",
          })
        else
          v324:Notify({
            Title = "Error",
            Content = tostring(v406),
            Duration = 3,
            Icon = "x",
          })
        end
      else
        v324:Notify({
          Title = "Notice",
          Content = "Please enter a profile name first!",
          Duration = 3,
          Icon = "alert-circle",
        })
      end
    end,
  })

  selectProfileDropdown = section9:Dropdown({
    Title = "Select Profile",
    Values = f52(),
    Value = profile,
    Callback = function(value126)
      if value126 and value126 ~= "" then
        profile = value126

        if v31 then
          pcall(function()
            writefile(
              "RoxyHub_RideAPet/configs/autoload.json",
              httpService:JSONEncode({ AutoLoad = true, Profile = profile })
            )
          end)
        end
      end
    end,
  })

  section9:Button({
    Title = "Overwrite Config",
    Callback = function()
      local v407 = profile
      local v408, v409 = f53(v407)

      if v408 then
        if v31 then
          pcall(function()
            writefile(
              "RoxyHub_RideAPet/configs/autoload.json",
              httpService:JSONEncode({ AutoLoad = true, Profile = profile })
            )
          end)
        end

        v324:Notify({
          Title = "Saved",
          Content = string.format("Overwrote '%s.json'!", v407),
          Duration = 3,
          Icon = "check",
        })
      else
        v324:Notify({
          Title = "Error",
          Content = tostring(v409),
          Duration = 3,
          Icon = "x",
        })
      end
    end,
  })

  section9:Button({
    Title = "Load Selected Config",
    Callback = function()
      local v410 = profile
      local v411, v412 = f54(v410, false)

      if v411 then
        v324:Notify({
          Title = "Loaded",
          Content = string.format("Loaded '%s.json' & updated UI!", v410),
          Duration = 3,
          Icon = "check",
        })
      else
        v324:Notify({
          Title = "Error",
          Content = tostring(v412),
          Duration = 3,
          Icon = "x",
        })
      end
    end,
  })

  section9:Toggle({
    Title = "Auto Load Profile On Startup",
    Value = v31,
    Callback = function(value127)
      v31 = value127

      if value127 then
        v324:Notify({
          Title = "AutoLoad ON",
          Content = string.format("Will auto-load '%s.json' on start", profile),
          Duration = 3,
          Icon = "check",
        })
      else
        v324:Notify({
          Title = "AutoLoad OFF",
          Content = "Disabled auto-load on start",
          Duration = 3,
          Icon = "x",
        })
      end
    end,
  })
end)

if v31 then
  pcall(function() loadProfile(profile, true) end)
end

task.wait()
f2()
task.wait(0.15)

pcall(function()
  if v332 then
    v332.Enabled = true
  end

  if window and window.Open then
    window:Open()
  end

  if window and window.SelectTab then
    window:SelectTab(1)
  end
end)

pcall(function()
  v324:Notify({
    Title = "RoxyHub Loaded",
    Content = "Ride A Pet is ready!",
    Duration = 4,
    Icon = "sparkles",
  })
end)

