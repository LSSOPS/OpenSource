local replicatedStorage = game:GetService("ReplicatedStorage")
local workspaceService = game:GetService("Workspace")
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local httpService = game:GetService("HttpService")
local virtualUser = game:GetService("VirtualUser")

pcall(function()
  if not table.find then
    function table:find(p1)
      if type(self) ~= "table" then
        return nil
      end

      for index, value in ipairs(self) do
        if value == p1 then
          return index
        end
      end

      return nil
    end
  end
end)

_G.RoxyHubInstanceId = (_G.RoxyHubInstanceId or 0) + 1
local roxyHubInstanceId = _G.RoxyHubInstanceId

if _G.RoxyHubInstance and typeof(_G.RoxyHubInstance) == "table" and _G.RoxyHubInstance.Destroy then
  pcall(function() _G.RoxyHubInstance:Destroy() end)
end

if _G.RoxyHubConnections and type(_G.RoxyHubConnections) == "table" then
  for index2, value2 in ipairs(_G.RoxyHubConnections) do
    local v1 = value2
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
    for index3, value3 in ipairs(renderedEggs:GetChildren()) do
      local roxyEggESP = value3:FindFirstChild("RoxyEggESP")

      if roxyEggESP then
        pcall(function() roxyEggESP:Destroy() end)
      end

      local roxyEggTag = value3:FindFirstChild("RoxyEggTag")

      if roxyEggTag then
        pcall(function() roxyEggTag:Destroy() end)
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

local function f1(p2)
  v2 = false

  pcall(function()
    if roxyHubLoadingScreen2 then
      roxyHubLoadingScreen2.Enabled = false
      roxyHubLoadingScreen2:Destroy()
    end
  end)

  pcall(function()
    local playerGui = localPlayer2
    local v4 = { robloxGui, coreGui }

    if localPlayer2 then
      playerGui = localPlayer2:FindFirstChild("PlayerGui")
    end

    local v5 = playerGui

    if v5 then
      table.insert(v4, v5)
    end

    if gethui then
      table.insert(v4, gethui())
    end

    for index4, value4 in ipairs(v4) do
      if value4 then
        for index5, value5 in ipairs(value4:GetChildren()) do
          if value5.Name == "RoxyHub_LoadingScreen" then
            value5.Enabled = false
            value5:Destroy()
          end
        end
      end
    end
  end)
end

local function f2(p3, p4)
  pcall(function()
    tweenService:Create(
      barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
      { Size = UDim2.new(math.clamp(p3, 0, 1), 0, 1, 0) }
    ):Play()

    if p4 then
      statusLabel.Text = p4
    end
  end)
end

task.delay(30, function()
  if v2 then
    f1(true)
  end
end)

pcall(function()
  local connect = localPlayer2.Idled:Connect(function()
    virtualUser:Button2Down(Vector2.new(0, 0), workspaceService.CurrentCamera.CFrame)
    task.wait(0.5)
    virtualUser:Button2Up(Vector2.new(0, 0), workspaceService.CurrentCamera.CFrame)
  end)
end)

local v6 = getrenv and type(getrenv) == "function" and getrenv().require
local v7 = getgenv and type(getgenv) == "function" and getgenv().require
local roxyMODULES = _G._ROXY_MODULES or {}

local function f3(p5, p6, p7)
  if roxyMODULES and roxyMODULES[p6] then
    return roxyMODULES[p6]
  end

  if not p5 then
    return p7 or {}
  end

  if v6 then
    local v8, v9 = pcall(v6, p5)

    if v8 and v9 and (type(v9) == "table" or type(v9) == "userdata") then
      return v9
    end
  end

  if v7 and v7 ~= v6 then
    local v10, v11 = pcall(v7, p5)

    if v10 and v11 and (type(v11) == "table" or type(v11) == "userdata") then
      return v11
    end

    return p7 or {}
  end

  return p7 or {}
end

local v12 = {
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
local v13 = eggs and f3(eggs, "Eggs", v12) or v12

local hatchLuck = gameData
  and (gameData:FindFirstChild("HatchLuck") or gameData:WaitForChild("HatchLuck", 1))

local v14 = hatchLuck and f3(hatchLuck, "HatchLuck")

local rebirths = gameData
  and (gameData:FindFirstChild("Rebirths") or gameData:WaitForChild("Rebirths", 1))

local v15 = rebirths and f3(rebirths, "Rebirths", {
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

local v16 = general and f3(general, "GeneralConfig")

local remotes = replicatedStorage:FindFirstChild("Remotes")
  or replicatedStorage:WaitForChild("Remotes", 1.5)

local v17 = remotes and (remotes:FindFirstChild("Game") or remotes:WaitForChild("Game", 1))
local eggPickup = v17 and (v17:FindFirstChild("EggPickup") or v17:WaitForChild("EggPickup", 1))

local basketDrop = v17
  and (v17:FindFirstChild("BasketDrop") or v17:WaitForChild("BasketDrop", 1))

local teleportToPlot = v17
  and (v17:FindFirstChild("TeleportToPlot") or v17:WaitForChild("TeleportToPlot", 1))

local eggPlaced = v17 and (v17:FindFirstChild("EggPlaced") or v17:WaitForChild("EggPlaced", 1))
local rebirth = v17 and (v17:FindFirstChild("Rebirth") or v17:WaitForChild("Rebirth", 1))
local hatch = v17 and (v17:FindFirstChild("Hatch") or v17:WaitForChild("Hatch", 1))
local plot = v17 and (v17:FindFirstChild("Plot") or v17:WaitForChild("Plot", 1))
local nests = plot and (plot:FindFirstChild("Nests") or plot:WaitForChild("Nests", 1))

local gameServices = replicatedStorage:FindFirstChild("GameServices")
  or replicatedStorage:WaitForChild("GameServices", 1.5)

local general2 = gameServices
  and (gameServices:FindFirstChild("General") or gameServices:WaitForChild("General", 1))

local v18 = general2 and f3(general2, "General")

local dayNight = gameServices
  and (gameServices:FindFirstChild("DayNight") or gameServices:WaitForChild("DayNight", 1))

local v19 = dayNight and f3(dayNight, "DayNight")

local v20 = {
  Ethereal = 1000,
  Divine = 900,
  Mythic = 800,
  Legendary = 700,
  Epic = 600,
  Rare = 500,
  Common = 100,
  Unknown = 0,
}

Color3.fromRGB(255, 60, 255)
Color3.fromRGB(0, 240, 255)
Color3.fromRGB(255, 50, 50)
Color3.fromRGB(255, 190, 0)
Color3.fromRGB(180, 70, 255)
Color3.fromRGB(60, 150, 255)
Color3.fromRGB(190, 190, 190)
Color3.fromRGB(255, 255, 255)

local function f4(p8)
  local v21 = v13 and v13[p8] or v12[p8]
  return v21 and v21.Rarity or "Common"
end

local function f5(p9)
  local v22 = v13 and v13[p9] or v12[p9]
  return v22 and v22.Luck or 1
end

local v23 = {
  Shocked = 2,
  Volted = 3,
  Rage = 4,
  Void = 10,
  Magma = 10,
  Eternal = 100,
}

local v24 = {
  Eternal = 100000,
  Magma = 75000,
  Void = 50000,
  Rage = 20000,
  Volted = 10000,
  Shocked = 5000,
}

local v25 = {
  Eternal = Color3.fromRGB(255, 100, 220),
  Magma = Color3.fromRGB(255, 120, 20),
  Void = Color3.fromRGB(130, 60, 255),
  Rage = Color3.fromRGB(255, 60, 60),
  Volted = Color3.fromRGB(255, 230, 40),
  Shocked = Color3.fromRGB(80, 190, 255),
}

local v26 = {
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

local function f6()
  local serverData = replicatedStorage:FindFirstChild("ServerData")

  if not serverData then
    return nil
  end

  local activeWeathers = serverData:GetAttribute("ActiveWeathers")

  if not activeWeathers or activeWeathers == "" or activeWeathers == "[]" then
    return nil
  else
    local v27, v28 = pcall(function() return httpService:JSONDecode(activeWeathers) end)

    if not v27 or type(v28) ~= "table" then
      return nil
    else
      local getServerTimeNow = workspaceService:GetServerTimeNow()

      for index6, value6 in ipairs(v28) do
        if value6.Type == "Storm" and value6.Variant
          and (not value6.EndsAt or value6.EndsAt > getServerTimeNow) then
          return value6
        end
      end

      return nil
    end
  end
end

local function f7(p10)
  if not p10 or p10 == "" then
    return false
  else
    local minMutationTier = _G.RoxyHubState and _G.RoxyHubState.MinMutationTier
      or "All Mutations (Shocked+)"

    local v29 = v23[p10] or 1

    if minMutationTier == "Eternal Only (100x)" then
      return v29 >= 100
    end

    if minMutationTier == "Magma & Above (10x+)" or minMutationTier == "Void & Above (10x+)" then
      return v29 >= 10
    elseif minMutationTier == "Rage & Above (4x+)" then
      return v29 >= 4
    else
      if minMutationTier == "Volted & Above (3x+)" then
        return v29 >= 3
      end

      return v29 >= 2
    end
  end
end

local function f8()
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

local function f9(p11)
  if not p11 then
    return nil
  else
    local mutation = p11:GetAttribute("Mutation")

    if mutation and mutation ~= "" then
      return mutation
    else
      local serverData2 = replicatedStorage:FindFirstChild("ServerData")
      local activeEggs = serverData2 and serverData2:FindFirstChild("ActiveEggs")

      if activeEggs then
        local position = p11:GetPivot().Position

        for index7, value7 in ipairs(activeEggs:GetChildren()) do
          local getAttributes = value7:GetAttributes()

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

        if p11:FindFirstChild("MutationHitbox") then
          local v30 = f6()

          if v30 and v30.Variant and v26[v30.Variant] then
            return v26[v30.Variant]
          end

          return "Shocked"
        end

        return nil
      elseif p11:FindFirstChild("MutationHitbox") then
        local v31 = f6()

        if v31 and v31.Variant and v26[v31.Variant] then
          return v26[v31.Variant]
        end

        return "Shocked"
      else
        return nil
      end
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

if roxyHubState.AutoFuse == nil then
  roxyHubState.AutoFuse = false
end

if roxyHubState.FuseProtectFavorited == nil then
  roxyHubState.FuseProtectFavorited = true
end

if roxyHubState.AutoFavoriteFuse == nil then
  roxyHubState.AutoFavoriteFuse = true
end

if roxyHubState.AutoFavoriteFuseList == nil then
  roxyHubState.AutoFavoriteFuseList = {
    "Hydra Dragon ($165M/s - Val: $99B)", "Hellhound ($140M/s - Val: $84B)",
    "Fenrir ($120M/s - Val: $72B)", "Stone Golem ($60M/s - Val: $36B)",
    "El Toro ($20M/s - Val: $12B)",
  }
end

if roxyHubState.FuseRarities == nil then
  roxyHubState.FuseRarities = {
    Legendary = true,
    Mythic = true,
    Divine = false,
    Ethereal = false,
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

if roxyHubState.ESP_MinRarity == nil or roxyHubState.ESP_MinRarity == "Rare" then
  roxyHubState.ESP_MinRarity = "Rare & Above"
end

if type(roxyHubState.ESP_MaxDistance) ~= "number" then
  roxyHubState.ESP_MaxDistance = tonumber(roxyHubState.ESP_MaxDistance) or 5000
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

local function f10(p12)
  roxyHubState.MinFarmRarity = p12

  local v32 = ({
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

  if v32 then
    for key, value8 in pairs(v32) do
      roxyHubState.AllowedRarities[key] = value8
    end
  end
end

local function f11(p13)
  roxyHubState.ESP_VisualPreset = p13

  if p13 == "All Visuals (Highlight + Text + Tracer)" then
    roxyHubState.ESP_Highlights = true
    roxyHubState.ESP_Billboards = true
    roxyHubState.ESP_Tracers = true
  elseif p13 == "Highlights + Floating Text" then
    roxyHubState.ESP_Highlights = true
    roxyHubState.ESP_Billboards = true
    roxyHubState.ESP_Tracers = false
  elseif p13 == "Floating Text Only (Clean)" then
    roxyHubState.ESP_Highlights = false
    roxyHubState.ESP_Billboards = true
    roxyHubState.ESP_Tracers = false
  elseif p13 == "Highlights Only (Minimal)" then
    roxyHubState.ESP_Highlights = true
    roxyHubState.ESP_Billboards = false
    roxyHubState.ESP_Tracers = false
  elseif p13 == "Tracers Only" then
    roxyHubState.ESP_Highlights = false
    roxyHubState.ESP_Billboards = false
    roxyHubState.ESP_Tracers = true
  end
end

local v33 = false
local profile = "default"

pcall(function()
  if isfile and isfile("RoxyHub_RideAPet/configs/autoload.json") then
    local jsonDecode = httpService:JSONDecode((readfile("RoxyHub_RideAPet/configs/autoload.json")))

    if jsonDecode and type(jsonDecode) == "table" then
      if jsonDecode.AutoLoad == true then
        v33 = true
      end

      if jsonDecode.Profile and type(jsonDecode.Profile) == "string"
        and jsonDecode.Profile ~= "" and jsonDecode.Profile ~= "autoload" then
        profile = jsonDecode.Profile
      end
    end
  end

  if v33 and profile ~= "" then
    local v34 = "RoxyHub_RideAPet/configs" .. "/" .. profile .. ".json"

    if isfile and isfile(v34) then
      local jsonDecode2 = httpService:JSONDecode((readfile(v34)))

      if jsonDecode2 and type(jsonDecode2) == "table" then
        for key2, value9 in pairs(jsonDecode2) do
          if key2 ~= "AutoFarm" and key2 ~= "AutoRebirth" then
            roxyHubState[key2] = value9
          end
        end

        if roxyHubState.MinFarmRarity and f10 then
          f10(roxyHubState.MinFarmRarity)
        end

        if roxyHubState.ESP_VisualPreset and f11 then
          f11(roxyHubState.ESP_VisualPreset)
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

local v35 = {
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
  if v18 and v18.GetPlot then
    local getPlot = v18:GetPlot(localPlayer2)

    if getPlot then
      return getPlot
    end
  end

  local plots = workspaceService:FindFirstChild("Plots")

  if plots then
    for index8, value10 in ipairs(plots:GetChildren()) do
      local nestsOwnerLoaded = value10:GetAttribute("NestsOwnerLoaded")
        or value10:GetAttribute("OwnerUserId") or value10:GetAttribute("Owner")

      if nestsOwnerLoaded == localPlayer2.UserId
        or tostring(nestsOwnerLoaded) == tostring(localPlayer2.UserId) then
        return value10
      else
        local data = value10:FindFirstChild("Data")

        local owner = data
        owner = data and data:FindFirstChild("Owner")

        if owner
          and (owner.Value == localPlayer2 or tostring(owner.Value) == localPlayer2.Name
            or tostring(owner.Value) == tostring(localPlayer2.UserId)) then
          return value10
        end

        if value10.Name == tostring(localPlayer2.UserId) or value10.Name == localPlayer2.Name then
          return value10
        elseif value10:FindFirstChild("Pets") then
          for index9, value11 in ipairs(value10.Pets:GetChildren()) do
            if value11:IsA("Model")
              and (value11:GetAttribute("OwnerUserId") == localPlayer2.UserId
                or tostring(value11:GetAttribute("OwnerUserId"))
                  == tostring(localPlayer2.UserId)) then
              return value10
            end
          end
        end
      end
    end

    return nil
  end

  return nil
end

local function f14()
  local v36 = f13()
  local eggs2 = v36 and v36:FindFirstChild("Eggs")

  if eggs2 then
    return #eggs2:GetChildren()
  end

  return 0
end

local function f15()
  local count = 0
  local v37 = f13()
  local nests2 = v37 and v37:FindFirstChild("Nests")

  if nests2 then
    for index10, value12 in ipairs(nests2:GetChildren()) do
      if value12:GetAttribute("Occupied") == true then
        count = count + 1
      end
    end
  end

  return count
end

local function f16(p14)
  if not p14 then
    return
  end

  local waitForChild = p14:WaitForChild("Humanoid", 5)
  local waitForChild2 = p14:WaitForChild("HumanoidRootPart", 5)

  if not waitForChild then
    return
  end

  pcall(function()
    waitForChild:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    waitForChild:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    waitForChild:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    waitForChild:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
  end)

  waitForChild.StateChanged:Connect(function(p15, p16)
    if _G.RoxyHubInstanceId ~= roxyHubInstanceId then
      return
    end

    if p16 == Enum.HumanoidStateType.Ragdoll or p16 == Enum.HumanoidStateType.Physics
      or p16 == Enum.HumanoidStateType.FallingDown then
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

if localPlayer2.Character then
  f16(localPlayer2.Character)
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

  f16(character2)
end)

pcall(function()
  local net = replicatedStorage:FindFirstChild("packages")
    and replicatedStorage.packages:FindFirstChild("Net")

  local reRagdoll = net and net:FindFirstChild("RE/Ragdoll")

  if reRagdoll and reRagdoll:IsA("RemoteEvent") then
    reRagdoll.OnClientEvent:Connect(function(p17, p18)
      if _G.RoxyHubInstanceId ~= roxyHubInstanceId then
        return
      end

      if p17 then
        task.defer(function()
          local v38, v39, v40 = f12()

          if v40 then
            pcall(function()
              v40:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
              v40:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
          end

          if v39 and v39:IsA("BasePart") then
            v39.AssemblyLinearVelocity = Vector3.zero
          end
        end)
      end
    end)
  end
end)

local function f17(p19)
  local v41 = f13()
  local nests3 = v41 and v41:FindFirstChild("Nests")

  if not nests3 then
    return
  end

  for index11, value13 in ipairs(nests3:GetChildren()) do
    local v42 = value13

    for index12, value14 in ipairs(v42:GetDescendants()) do
      local v43 = value14

      if v43:IsA("BasePart") and v43.Name ~= "Cook45_NestAnchor" then
        v43.LocalTransparencyModifier = p19 and 0 or 1

        if not v43:GetAttribute("NestWatched") then
          v43:SetAttribute("NestWatched", true)

          v43:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
            if roxyHubState.SpawnNest and v43.LocalTransparencyModifier ~= 0 then
              v43.LocalTransparencyModifier = 0
            end
          end)
        end
      end
    end

    local cook45NestAnchor = v42:FindFirstChild("Cook45_NestAnchor")

    if p19 then
      if not cook45NestAnchor then
        cook45NestAnchor = Instance.new("Part")
        cook45NestAnchor.Name = "Cook45_NestAnchor"
        cook45NestAnchor.Size = Vector3.new(2, 2, 2)
        cook45NestAnchor.CFrame = v42:GetPivot() * CFrame.new(0, 1.5, 0)
        cook45NestAnchor.Transparency = 1
        cook45NestAnchor.CanCollide = false
        cook45NestAnchor.CanTouch = false
        cook45NestAnchor.CanQuery = false
        cook45NestAnchor.Anchored = true
        cook45NestAnchor.Parent = v42
      end

      local nestPlacePrompt = cook45NestAnchor:FindFirstChildOfClass("ProximityPrompt")

      if not nestPlacePrompt then
        nestPlacePrompt = Instance.new("ProximityPrompt")
        nestPlacePrompt.Name = "NestPlacePrompt"
        nestPlacePrompt.ActionText = "Place Egg"
        nestPlacePrompt.ObjectText = "Nest " .. v42.Name
        nestPlacePrompt.HoldDuration = 0
        nestPlacePrompt.MaxActivationDistance = 25
        nestPlacePrompt.RequiresLineOfSight = false
        nestPlacePrompt.Parent = cook45NestAnchor

        nestPlacePrompt.Triggered:Connect(function(p20)
          if p20 == localPlayer2 then
            if v42:GetAttribute("Occupied") then
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
              local v44 = nil

              if character3 then
                for index13, value15 in ipairs(character3:GetChildren()) do
                  if value15:IsA("Tool")
                    and (value15:HasTag("Egg") or string.find(value15.Name, "Egg")) then
                    v44 = value15
                    break
                  end
                end
              end

              if not v44 and localPlayer2:FindFirstChild("Backpack") then
                for index14, value16 in ipairs(localPlayer2.Backpack:GetChildren()) do
                  if value16:IsA("Tool")
                    and (value16:HasTag("Egg") or string.find(value16.Name, "Egg")) then
                    v44 = value16
                    break
                  end
                end
              end

              if not v44 then
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

              if humanoid3 and v44.Parent ~= character3 then
                humanoid3:EquipTool(v44)
                local v45 = os.clock()

                while v44.Parent ~= character3 and os.clock() - v45 < 0.8 do
                  task.wait(0.05)
                end
              end

              if v44.Parent == character3 and eggPlaced then
                task.wait(0.1)
                eggPlaced:FireServer({ NestId = v42.Name })

                if WindUI then
                  WindUI:Notify({
                    Title = "Nest Placed",
                    Content = "Placed " .. v44.Name .. " in Nest " .. v42.Name .. "!",
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
        local v46 = v42:GetAttribute("Occupied") == true
        local v47 = cook45NestAnchor
        local v48 = v42:GetAttribute("Unlocked") ~= false

        local statusLabel3 = v47:FindFirstChild("NestStatusESP")
          and cook45NestAnchor.NestStatusESP:FindFirstChild("StatusLabel")

        if statusLabel3 then
          if not v48 then
            statusLabel3.Text = "[Locked] Nest " .. v42.Name
            statusLabel3.TextColor3 = Color3.fromRGB(220, 80, 80)
          elseif v46 then
            statusLabel3.Text = "[Incubating] Nest " .. v42.Name
            statusLabel3.TextColor3 = Color3.fromRGB(255, 200, 50)
          else
            statusLabel3.Text = "[Ready] Nest " .. v42.Name
            statusLabel3.TextColor3 = Color3.fromRGB(80, 255, 120)
          end
        end

        if nestPlacePrompt then
          local v49 = nestPlacePrompt
          v49.Enabled = v48 and not v46
        end
      end

      v42:GetAttributeChangedSignal("Occupied"):Connect(f18)
      v42:GetAttributeChangedSignal("Unlocked"):Connect(f18)

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

local function f19(p21)
  local v50 = tonumber(p21) or 0

  if v50 >= 1000000000000000 then
    return string.format("%.2fQa", v50 / 1000000000000000)
  elseif v50 >= 1000000000000 then
    return string.format("%.2fT", v50 / 1000000000000)
  elseif v50 >= 1000000000 then
    return string.format("%.2fB", v50 / 1000000000)
  elseif v50 >= 1000000 then
    return string.format("%.2fM", v50 / 1000000)
  else
    if v50 >= 1000 then
      return string.format("%.2fK", v50 / 1000)
    end

    return tostring(math.floor(v50))
  end
end

local v51 = {}

local function f20(p22)
  if not p22 then
    return {}
  elseif v51[p22] then
    return v51[p22]
  else
    if v14 and v14.GetOdds then
      local v52, v53 = pcall(function() return v14.GetOdds(p22) end)

      if v52 and type(v53) == "table" then
        local v54 = {}

        for index15, value17 in ipairs(v53) do
          if value17.PetName and value17.Chance then
            v54[value17.PetName] = value17.Chance
          end
        end

        v51[p22] = v54
        return v54
      end

      return {}
    end

    return {}
  end
end

local function f21(p23)
  local v55 = tonumber(p23) or 0

  if v55 >= 1000 then
    return f19(v55) .. " KG"
  end

  if v55 >= 10 then
    return string.format("%.1f KG", v55)
  end

  return string.format("%.2f KG", v55)
end

local function f22(p24, p25)
  if not p24 then
    return false
  end

  local create3

  if localPlayer2:GetAttribute("InVolcano") == true
    and localPlayer2:GetAttribute("VolcanoValidated") == true then
    return true
  else
    v35.Status = "Warping to Volcano Sky Platform..."
    f8()

    p24.AssemblyLinearVelocity = Vector3.zero
    p24.AssemblyAngularVelocity = Vector3.zero
    p24.CFrame = cframe

    task.wait(0.12)
    local volcano = workspaceService:FindFirstChild("Volcano")
    local volcanoEntrance = volcano and volcano:FindFirstChild("VolcanoEntrance")
    local volcanoValidate = volcano and volcano:FindFirstChild("VolcanoValidate")
    v35.Status = "Tweening into Cave Doors..."
    local v56 = math.clamp((cframe2.Position - p24.Position).Magnitude / 40, 0.6, 1.6)

    create3 = tweenService:Create(p24, TweenInfo.new(v56, Enum.EasingStyle.Linear), {
      CFrame = cframe2,
    })

    create3:Play()

    local v57 = os.clock()

    while os.clock() - v57 < v56 + 0.5 do
      if firetouchinterest then
        if volcanoEntrance then
          pcall(firetouchinterest, p24, volcanoEntrance, 0)
        end

        if volcanoValidate then
          pcall(firetouchinterest, p24, volcanoValidate, 0)
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
      if volcanoEntrance then
        pcall(firetouchinterest, p24, volcanoEntrance, 1)
      end

      if volcanoValidate then
        pcall(firetouchinterest, p24, volcanoValidate, 1)
      end
    end

    p24.AssemblyLinearVelocity = Vector3.zero
    p24.AssemblyAngularVelocity = Vector3.zero

    task.wait(0.05)
    return localPlayer2:GetAttribute("InVolcano") == true
  end
end

local function f23(p26, p27)
  if not p26 then
    return false
  else
    local v58 = (p26.Position - vector).Magnitude < 1500
    local v59 = false
    local basket = localPlayer2:FindFirstChild("Basket")

    if basket then
      for index16, value18 in ipairs(basket:GetChildren()) do
        if value18.Name == "Volcanic Egg" or value18:GetAttribute("Egg") == "Volcanic Egg"
          or value18:GetAttribute("Escaping") == true
          or value18:GetAttribute("VolcanoUntil") ~= nil then
          v59 = true
          break
        end
      end
    end

    if v58 and (v59 or localPlayer2:GetAttribute("InVolcano") == true) then
      v35.Status = "Escaping Volcano through Lair Door..."

      p26.AssemblyLinearVelocity = Vector3.zero
      p26.AssemblyAngularVelocity = Vector3.zero
      p26.CFrame = cframe2

      task.wait(0.08)
      local volcano2 = workspaceService:FindFirstChild("Volcano")

      local volcanoEntrance2 = volcano2
      volcanoEntrance2 = volcano2 and volcano2:FindFirstChild("VolcanoEntrance")

      local volcanoValidate2 = volcano2
      volcanoValidate2 = volcano2 and volcano2:FindFirstChild("VolcanoValidate")

      if firetouchinterest then
        if volcanoValidate2 then
          pcall(firetouchinterest, p26, volcanoValidate2, 0)
        end

        if volcanoEntrance2 then
          pcall(firetouchinterest, p26, volcanoEntrance2, 0)
        end
      end

      p26.AssemblyLinearVelocity = Vector3.zero
      p26.AssemblyAngularVelocity = Vector3.zero
      p26.CFrame = cframe

      if firetouchinterest then
        if volcanoValidate2 then
          pcall(firetouchinterest, p26, volcanoValidate2, 1)
        end

        if volcanoEntrance2 then
          pcall(firetouchinterest, p26, volcanoEntrance2, 1)
        end
      end

      local v60 = os.clock()

      while os.clock() - v60 < 0.5 do
        if localPlayer2:GetAttribute("InVolcano") ~= true then
          break
        end

        task.wait(0.04)
      end

      v35.Status = "Volcano Escaped!"
      return true
    end

    return false
  end
end

local v62 = {
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

local function f24(p28)
  if not p28 or p28 == "" then
    return false, "No Target"
  else
    local savedData = localPlayer2:FindFirstChild("SavedData")
    local ownedPets = savedData and savedData:FindFirstChild("OwnedPets")

    if ownedPets and ownedPets.Value then
      if string.find(tostring(ownedPets.Value), p28 .. ",") then
        return true, "SavedData"
      end
    end

    local backpack = localPlayer2:FindFirstChild("Backpack")

    if backpack then
      for index17, value19 in ipairs(backpack:GetChildren()) do
        if value19:IsA("Tool") then
          local petKey = value19:GetAttribute("PetKey")
          local match = value19.Name:match("^(.-) %[") or value19.Name

          if petKey and string.find(petKey, p28) or match == p28 then
            return true, "Backpack"
          end
        end
      end
    end

    local character4 = localPlayer2.Character

    if character4 then
      for index18, value20 in ipairs(character4:GetChildren()) do
        if value20:IsA("Tool") then
          local petKey2 = value20:GetAttribute("PetKey")
          local match2 = value20.Name:match("^(.-) %[") or value20.Name

          if petKey2 and string.find(petKey2, p28) or match2 == p28 then
            return true, "Character"
          end
        end
      end
    end

    local v63 = f13()

    if v63 and v63:FindFirstChild("Pets") then
      for index19, value21 in ipairs(v63.Pets:GetChildren()) do
        if (value21.Name:match("^(.-) %[") or value21.Name) == p28 then
          return true, "Plot"
        end
      end

      return false, "Not Owned"
    end

    return false, "Not Owned"
  end
end

local function f25(p29)
  local v64 = not p29 or not p29.Parent
  local v65, placeTime, weight, v66, isReady, v67, v68

  if v64 then
    return nil
  else
    local eggKey = p29:GetAttribute("EggKey")
    local eggData = p29:FindFirstChild("EggData")

    placeTime = eggData and eggData:FindFirstChild("PlaceTime")
      and tonumber(eggData.PlaceTime.Value)

    weight = eggData and eggData:FindFirstChild("Weight") and tonumber(eggData.Weight.Value)
      or 1

    v65 = v13 and v13[p29.Name] or v12[p29.Name]

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

    v66 = nil
    isReady = false
    v67 = nil
    v68 = false

    if placeTime and v65 and v65.GrowthTime and v16 and v16.GrowthTimeFor and v19
      and v19.GrowthElapsed then
      pcall(function()
        local v69 = v16.GrowthTimeFor(v65.GrowthTime, weight)
        local v70 = v19.GrowthElapsed(placeTime)
        v66 = math.max(0, v69 - v70)

        if math.clamp(v70 / math.max(v69, 1), 0, 1) >= 1 or v66 <= 0 then
          isReady = true
          v67 = "Ready to Hatch!"
        else
          local v71 = math.floor(v66 / 3600)
          local v72 = math.floor(v66 % 3600 / 60)
          local v73 = math.floor(v66 % 60)

          v67 = v71 > 0 and string.format("%d:%02d:%02d", v71, v72, v73)
            or string.format("%d:%02d", v72, v73)
        end

        v68 = true
      end)
    end

    if not v68 and placeTime and v65 and v65.GrowthTime then
      local getServerTimeNow2 = workspace:GetServerTimeNow()
      local v74 = math.max(0, getServerTimeNow2 - placeTime)
      local v75 = v65.GrowthTime * (weight or 1)
      v66 = math.max(0, v75 - v74)

      if math.clamp(v74 / math.max(v75, 1), 0, 1) >= 1 or v66 <= 0 then
        isReady = true
        v67 = "Ready to Hatch!"
      else
        local v76 = math.floor(v66 / 3600)
        local v77 = math.floor(v66 % 3600 / 60)
        local v78 = math.floor(v66 % 60)

        v67 = v76 > 0 and string.format("%d:%02d:%02d", v76, v77, v78)
          or string.format("%d:%02d", v77, v78)
      end

      v68 = true
    end

    if not v68 then
      if findFirstChild3 and findFirstChild3.Text and findFirstChild3.Text ~= "" then
        v67 = findFirstChild3.Text

        if string.lower(v67):find("ready") then
          isReady = true
          v67 = "Ready to Hatch!"
          v66 = 0
        end

        v68 = true
      else
        local findFirstChild4 = p29:FindFirstChild("HatchingUI", true)

        local timer = findFirstChild4
        timer = findFirstChild4 and findFirstChild4:FindFirstChild("Timer")

        if timer and timer.Text and timer.Text ~= "" then
          v67 = timer.Text

          if string.find(string.lower(tostring(v67)), "ready") then
            isReady = true
            v67 = "Ready to Hatch!"
            v66 = 0
          end

          v68 = true
        else
          v67 = "Incubating..."
        end
      end
    end

    return {
      isReady = isReady,
      timeStr = v67 or "Incubating...",
      timeLeft = v66,
      eggKey = eggKey,
    }
  end
end

local function f26(p30)
  if not p30 or p30 == "" then
    return false
  else
    local v79 = f13()
    local eggs3 = v79 and v79:FindFirstChild("Eggs")

    if eggs3 then
      for index20, value22 in ipairs(eggs3:GetChildren()) do
        local name = value22.Name
        local v80 = f20((f5(name)))[p30] or 0
        local v81 = v62[p30] and v62[p30][name] == true

        if v80 and v80 > 0 or v81 then
          local v82 = f25(value22)
          return true, name, v80, v82 and v82.timeStr or "Incubating..."
        end
      end
    end

    local basket2 = localPlayer2:FindFirstChild("Basket")

    if basket2 then
      for index21, value23 in ipairs(basket2:GetChildren()) do
        local egg = value23:GetAttribute("Egg") or value23.Name
        local v83 = f20((f5(egg)))[p30] or 0
        local v84 = v62[p30] and v62[p30][egg] == true

        if v83 and v83 > 0 or v84 then
          return true, egg, v83, "In Basket"
        end
      end
    end

    local v85 = {}

    if localPlayer2:FindFirstChild("Backpack") then
      for index22, value24 in ipairs(localPlayer2.Backpack:GetChildren()) do
        table.insert(v85, value24)
      end
    end

    if localPlayer2.Character then
      for index23, value25 in ipairs(localPlayer2.Character:GetChildren()) do
        table.insert(v85, value25)
      end
    end

    for index24, value26 in ipairs(v85) do
      if value26:IsA("Tool") and (value26:HasTag("Egg") or string.find(value26.Name, "Egg")) then
        local match3 = value26.Name:match("^(.-) %[") or value26.Name
        local v86 = f20((f5(match3)))[p30] or 0
        local v87 = v62[p30] and v62[p30][match3] == true

        if v86 and v86 > 0 or v87 then
          return true, match3, v86, "In Backpack"
        end
      end
    end

    return false
  end
end

local function f27()
  local savedData2 = localPlayer2:FindFirstChild("SavedData")

  local value27 = savedData2 and savedData2:FindFirstChild("Rebirths")
    and savedData2.Rebirths.Value

  local value28 = savedData2
  local v88 = value27 or 0

  if savedData2 then
    value28 = savedData2:FindFirstChild("Cash") and savedData2.Cash.Value
  end

  local v89 = value28 or 0
  local cap = v15 and v15.Cap or 6
  local v90 = v88 >= cap
  local v91 = v88 + 1
  local v92 = 1000000

  if v15 and v15.RiggedCost and v15.RiggedCost[v91] then
    v92 = v15.RiggedCost[v91]
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

  local v93 = { "Horse", "Fox", "Unicorn", "Phoenix", "Kitsune", "Dragon" }

  if text == "" and v91 <= #v93 then
    text = v93[v91]
  end

  local v94 = false
  local petLoc = "N/A"

  if text ~= "" then
    v94, petLoc = f24(text)
  end

  local isIncubating = false
  local incubatingOdds = 0
  local incubatingTime, incubatingEggName

  if text ~= "" and not v94 then
    isIncubating, incubatingEggName, incubatingOdds, incubatingTime = f26(text)
  end

  local canRebirth = not v90 and v94 and v89 >= v92

  return {
    currentRebirth = v88,
    nextTier = v91,
    maxCap = cap,
    isMaxCap = v90,
    currentCash = v89,
    reqCash = v92,
    hasCash = v89 >= v92,
    reqPet = text,
    hasPet = v94,
    petLoc = petLoc,
    isIncubating = isIncubating,
    incubatingEggName = incubatingEggName,
    incubatingOdds = incubatingOdds,
    incubatingTime = incubatingTime,
    canRebirth = canRebirth,
  }
end

local function f28()
  local v95 = f27()

  if not v95.canRebirth or v95.isMaxCap then
    return false
  end

  if rebirth then
    rebirth:FireServer()
  end

  pcall(function()
    local rebirth3 = localPlayer2.PlayerGui.Main.Rebirth.Rebirth

    if getconnections then
      for key3, value29 in pairs(getconnections(rebirth3.Activated)) do
        value29:Fire()
      end
    end
  end)

  return true
end

runService.Stepped:Connect(function()
  if roxyHubState.NoClip or v35.IsFarming or v35.CurrentTween ~= nil then
    local character5 = localPlayer2.Character

    if character5 then
      for index25, value30 in ipairs(character5:GetDescendants()) do
        if value30:IsA("BasePart") then
          if value30.CanCollide then
            value30.CanCollide = false
          end

          if v35.CurrentTween ~= nil then
            value30.AssemblyLinearVelocity = Vector3.zero
            value30.AssemblyAngularVelocity = Vector3.zero
          end
        end
      end
    end
  end
end)

userInputService.JumpRequest:Connect(function()
  if roxyHubState.InfiniteJump then
    local v96, v97, v98 = f12()

    if v98 then
      v98:ChangeState(Enum.HumanoidStateType.Jumping)
    end
  end
end)

runService.RenderStepped:Connect(function()
  if roxyHubState.SpeedModEnabled and roxyHubState.SpeedMultiplier > 1 then
    local v99, v100, v101 = f12()

    if v101 then
      v101.WalkSpeed = 92 * roxyHubState.SpeedMultiplier
    end
  end
end)

local v102 = {}
local v103 = {}

local function f29(p31)
  local v104 = v102[p31]

  if v104 then
    if v104.Billboard and v104.Billboard.Parent then
      v104.Billboard:Destroy()
    end

    if v104.Highlight then
      pcall(function() v104.Highlight:Destroy() end)
    end

    if v104.Tracer then
      pcall(function()
        v104.Tracer.Visible = false
        v104.Tracer:Remove()
      end)
    end

    v102[p31] = nil
  end

  local roxyEggESP2

  if p31 and p31.Parent then
    roxyEggESP2 = p31:FindFirstChild("RoxyEggESP")

    if roxyEggESP2 then
      pcall(function() roxyEggESP2:Destroy() end)
    end

    local roxyEggTag2 = p31:FindFirstChild("RoxyEggTag")

    if roxyEggTag2 then
      pcall(function() roxyEggTag2:Destroy() end)
    end
  end
end

local function f30()
  for key4, value31 in pairs(v102) do
    f29(key4)
  end

  local renderedEggs2 = workspaceService:FindFirstChild("RenderedEggs")

  if renderedEggs2 then
    for index26, value32 in ipairs(renderedEggs2:GetChildren()) do
      local roxyEggESP3 = value32:FindFirstChild("RoxyEggESP")

      if roxyEggESP3 then
        pcall(function() roxyEggESP3:Destroy() end)
      end

      local roxyEggTag3 = value32:FindFirstChild("RoxyEggTag")

      if roxyEggTag3 then
        pcall(function() roxyEggTag3:Destroy() end)
      end
    end
  end

  for index27, value33 in ipairs(v103) do
    local v105 = value33

    pcall(function()
      v105.Visible = false
      v105:Remove()
    end)
  end

  table.clear(v103)
  table.clear(v102)
end

local v106 = setmetatable({}, { __mode = "k" })

local function f31(p32)
  local v107

  if not p32 then
    return 0
  else
    local v108 = v106[p32]

    if v108 ~= nil then
      return v108
    else
      local position4 = p32:GetPivot().Position
      local activeEggs2 = (replicatedStorage:FindFirstChild("ServerData") or replicatedStorage):FindFirstChild("ActiveEggs")

      if activeEggs2 then
        for index28, value34 in ipairs(activeEggs2:GetChildren()) do
          local position5 = value34:GetAttribute("Position")

          if position5 and (position5 - position4).Magnitude < 10 then
            v107 = tonumber(value34:GetAttribute("Weight")) or 0
            local v109 = v107

            if v16 and v16.ShownEggKG then
              local v110, v111 = pcall(function() return v16.ShownEggKG(v107) end)

              if v110 and type(v111) == "number" then
                v109 = v111
              end
            end

            local v112 = math.floor(v109 * 10 + 0.5) / 10
            v106[p32] = v112
            return v112, value34
          end
        end

        v106[p32] = 0
        return 0, nil
      end

      v106[p32] = 0
      return 0, nil
    end
  end
end

-- ============================================================
-- RoxyHub ESP renderer (rewritten: highlight / floating text / tracer)
-- ============================================================
do
  local ESP_COLORS = {
    Ethereal = Color3.fromRGB(255, 60, 255),
    Divine = Color3.fromRGB(0, 240, 255),
    Mythic = Color3.fromRGB(255, 50, 50),
    Legendary = Color3.fromRGB(255, 190, 0),
    Epic = Color3.fromRGB(180, 70, 255),
    Rare = Color3.fromRGB(60, 150, 255),
    Common = Color3.fromRGB(190, 190, 190),
    Unknown = Color3.fromRGB(255, 255, 255),
  }

  -- Roblox renders at most ~31 Highlights at once, so keep a safe cap
  -- and give the slots to the rarest / closest eggs first.
  local HIGHLIGHT_LIMIT = 22

  local function espMinWeight()
    local setting = tostring(roxyHubState.ESP_MinRarity or "All Eggs")
    local word = setting:match("^(%a+)")

    if not word or word == "All" then
      return 0
    end

    return v20[word] or 0
  end

  local function espAnchor(model)
    if model:IsA("BasePart") then
      return model
    end

    return model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
  end

  local function espNewTracer()
    local ok, line = pcall(function()
      local drawing = Drawing.new("Line")
      drawing.Thickness = 1.5
      drawing.Transparency = 1
      drawing.Visible = false
      return drawing
    end)

    if ok then
      return line
    end

    return nil
  end

  local function espBuildBillboard(model)
    local anchor = espAnchor(model)

    if not anchor then
      return nil
    end

    local gui = Instance.new("BillboardGui")
    gui.Name = "RoxyEggTag"
    gui.Adornee = anchor
    gui.AlwaysOnTop = true
    gui.Size = UDim2.fromOffset(210, 50)
    gui.StudsOffset = Vector3.new(0, 3.5, 0)
    gui.MaxDistance = math.huge
    gui.ResetOnSpawn = false

    local label = Instance.new("TextLabel")
    label.Name = "Info"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.RichText = true
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.25
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextWrapped = true
    label.Parent = gui

    gui.Parent = model
    return gui, label
  end

  local function espRefreshText(entry, model, rarity, color, dist)
    if not entry.Label then
      return
    end

    local now = os.clock()

    if not entry.NextInfo or now >= entry.NextInfo then
      entry.NextInfo = now + 2
      local okW, weight = pcall(f31, model)
      local okM, mutation = pcall(f9, model)
      entry.Weight = okW and tonumber(weight) or 0
      entry.Mutation = okM and mutation or nil
    end

    local extra = {}

    if entry.Weight and entry.Weight > 0 then
      table.insert(extra, string.format("%.1fkg", entry.Weight))
    end

    if entry.Mutation and entry.Mutation ~= "" then
      table.insert(extra, tostring(entry.Mutation))
    end

    table.insert(extra, string.format("%d studs", math.floor(dist)))

    entry.Label.Text = string.format(
      '<font color="#%s">%s</font> <font color="#FFFFFF">[%s]</font>\n<font color="#E2E8F0" size="12">%s</font>',
      color:ToHex(), model.Name, rarity, table.concat(extra, " | ")
    )
  end

  local function espHideAll()
    if next(v102) ~= nil then
      f30()
    end
  end

  task.spawn(function()
    local warned = false

    while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
      task.wait(0.2)

      local ok, err = pcall(function()
        local folder = workspaceService:FindFirstChild("RenderedEggs")

        if not roxyHubState.ESP_Enabled or not folder then
          espHideAll()
          return
        end

        local _, root = f12()
        local camera = workspaceService.CurrentCamera
        local origin = root and root.Position or (camera and camera.CFrame.Position)

        if not origin then
          return
        end

        local maxDist = tonumber(roxyHubState.ESP_MaxDistance) or 5000
        local minWeight = espMinWeight()
        local wantHighlight = roxyHubState.ESP_Highlights == true
        local wantBillboard = roxyHubState.ESP_Billboards == true
        local wantTracer = roxyHubState.ESP_Tracers == true
        local candidates = {}

        for _, egg in ipairs(folder:GetChildren()) do
          local okPos, pos = pcall(function() return egg:GetPivot().Position end)

          if okPos and pos then
            local rarity = f4(egg.Name) or "Unknown"
            local weight = v20[rarity] or 0
            local dist = (pos - origin).Magnitude

            if dist <= maxDist and weight >= minWeight then
              table.insert(candidates, {
                Egg = egg, Rarity = rarity, Weight = weight, Dist = dist,
              })
            end
          end
        end

        table.sort(candidates, function(a, b)
          if a.Weight ~= b.Weight then
            return a.Weight > b.Weight
          end

          return a.Dist < b.Dist
        end)

        local alive = {}

        for index, c in ipairs(candidates) do
          local egg = c.Egg
          local color = ESP_COLORS[c.Rarity] or ESP_COLORS.Unknown
          local entry = v102[egg]

          if not entry then
            entry = {}
            v102[egg] = entry
          end

          alive[egg] = true
          entry.Color = color

          -- Highlight (clear fill + white outline, always on top)
          if wantHighlight and index <= HIGHLIGHT_LIMIT then
            if not (entry.Highlight and entry.Highlight.Parent) then
              local old = egg:FindFirstChild("RoxyEggESP")

              if old then
                pcall(function() old:Destroy() end)
              end

              local highlight = Instance.new("Highlight")
              highlight.Name = "RoxyEggESP"
              highlight.Adornee = egg
              highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
              highlight.OutlineTransparency = 0
              highlight.OutlineColor = Color3.new(1, 1, 1)
              highlight.FillTransparency = 0.35
              highlight.Parent = egg
              entry.Highlight = highlight
            end

            entry.Highlight.FillColor = color
            entry.Highlight.Enabled = true
          elseif entry.Highlight then
            pcall(function() entry.Highlight:Destroy() end)
            entry.Highlight = nil
          end

          -- Floating text
          if wantBillboard then
            if not (entry.Billboard and entry.Billboard.Parent) then
              local gui, label = espBuildBillboard(egg)
              entry.Billboard = gui
              entry.Label = label
              entry.NextInfo = nil
            end

            if entry.Billboard then
              espRefreshText(entry, egg, c.Rarity, color, c.Dist)
            end
          elseif entry.Billboard then
            pcall(function() entry.Billboard:Destroy() end)
            entry.Billboard = nil
            entry.Label = nil
          end

          -- Tracer (needs Drawing API)
          if wantTracer then
            if not entry.Tracer then
              entry.Tracer = espNewTracer()
            end
          elseif entry.Tracer then
            pcall(function()
              entry.Tracer.Visible = false
              entry.Tracer:Remove()
            end)
            entry.Tracer = nil
          end
        end

        for egg in pairs(v102) do
          if not alive[egg] then
            f29(egg)
          end
        end
      end)

      if not ok and not warned then
        warned = true
        warn("[RoxyHub ESP] " .. tostring(err))
      end
    end
  end)

  -- per-frame work: tracer lines + highlight pulse
  local espFrame = runService.RenderStepped:Connect(function()
    if _G.RoxyHubInstanceId ~= roxyHubInstanceId or next(v102) == nil then
      return
    end

    local camera = workspaceService.CurrentCamera

    if not camera then
      return
    end

    local viewport = camera.ViewportSize
    local from = Vector2.new(viewport.X / 2, viewport.Y)
    local pulse = 0.3 + 0.18 * math.sin(os.clock() * 4)

    for egg, entry in pairs(v102) do
      if entry.Highlight and entry.Highlight.Parent then
        entry.Highlight.FillTransparency = pulse
      end

      local tracer = entry.Tracer

      if tracer then
        local shown = false

        if egg.Parent then
          local okPos, pos = pcall(function() return egg:GetPivot().Position end)

          if okPos then
            local screen, onScreen = camera:WorldToViewportPoint(pos)

            if onScreen and screen.Z > 0 then
              tracer.From = from
              tracer.To = Vector2.new(screen.X, screen.Y)
              tracer.Color = entry.Color or Color3.new(1, 1, 1)
              tracer.Visible = true
              shown = true
            end
          end
        end

        if not shown then
          tracer.Visible = false
        end
      end
    end
  end)

  table.insert(_G.RoxyHubConnections, espFrame)
end

local f32

local function f33()
  local renderedEggs4 = workspaceService:FindFirstChild("RenderedEggs")
  local gsub

  if not renderedEggs4 then
    return nil
  else
    local v113, v114 = f12()

    if not v114 then
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
        local v115 = {}

        for index30, value36 in ipairs(renderedEggs4:GetChildren()) do
          local name2 = value36.Name
          local v116 = f4(name2)

          if f34(name2, v116) then
            local v117 = f9(value36)

            if v117 and f7(v117) then
              local v118 = f32(value36)

              if v118 then
                local v119 = f31(value36)
                local v120 = true

                if roxyHubState.MinEggWeight and roxyHubState.MinEggWeight > 0 and v119 > 0
                  and v119 < roxyHubState.MinEggWeight then
                  v120 = false
                end

                if v120 then
                  local getPivot = value36:GetPivot()

                  table.insert(v115, {
                    Model = value36,
                    Name = name2,
                    Rarity = v116,
                    Prompt = v118,
                    Position = getPivot.Position,
                    Distance = (getPivot.Position - v114.Position).Magnitude,
                    Luck = f5(name2),
                    Weight = v20[v116] or 0,
                    EggWeight = v119,
                    Mutation = v117,
                    MutationWeight = v24[v117] or 1000,
                  })
                end
              end
            end
          end
        end

        if #v115 > 0 then
          table.sort(v115, function(p35, p36)
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

          return v115[1]
        end
      end

      if roxyHubState.AutoFarm and roxyHubState.WeatherEggWait then
        local v121 = f6()

        if v121 and v121.Variant then
          local v122 = v26[v121.Variant]

          if not v122 or f7(v122) then
            local getServerTimeNow3 = workspaceService:GetServerTimeNow()

            local v123 = v121.EndsAt
                and math.max(0, math.floor(v121.EndsAt - getServerTimeNow3))
              or 0

            if v123 > 0 then
              local v124 = false

              for index31, value37 in ipairs(renderedEggs4:GetChildren()) do
                local name3 = value37.Name

                if f34(name3, (f4(name3))) then
                  v124 = true
                  break
                end
              end

              if v124 then
                return {
                  IsWaitingWeather = true,
                  StormVariant = v121.Variant,
                  MutationType = v122 or "Mutation",
                  TimeLeft = v123,
                }
              end
            end
          end
        end
      end

      local allowedRarities = roxyHubState.AllowedRarities

      local v125 = allowedRarities
      v125 = allowedRarities and roxyHubState.AllowedRarities.Ethereal == true

      local v126 = v125
      v126 = v125 or gsub and f4(gsub) == "Ethereal"

      if roxyHubState.AutoFarm and v126 then
        local v127 = {}

        for index32, value38 in ipairs(renderedEggs4:GetChildren()) do
          local name4 = value38.Name
          local v128 = f4(name4)

          if v128 == "Ethereal" and f34(name4, v128) then
            local v129 = f32(value38)

            if v129 then
              local v130 = f31(value38)
              local v131 = true

              if roxyHubState.MinEggWeight and roxyHubState.MinEggWeight > 0 and v130 > 0
                and v130 < roxyHubState.MinEggWeight then
                v131 = false
              end

              if v131 then
                local getPivot2 = value38:GetPivot()

                table.insert(v127, {
                  Model = value38,
                  Name = name4,
                  Rarity = v128,
                  Prompt = v129,
                  Position = getPivot2.Position,
                  Distance = (getPivot2.Position - v114.Position).Magnitude,
                  Luck = f5(name4),
                  Weight = v20[v128] or 1000,
                  EggWeight = v130,
                })
              end
            end
          end
        end

        if #v127 > 0 then
          if roxyHubState.PrioritizeHeaviest then
            table.sort(v127, function(p37, p38)
              if math.abs(p37.EggWeight - p38.EggWeight) > 0.05 then
                return p37.EggWeight > p38.EggWeight
              end

              return p37.Distance < p38.Distance
            end)
          else
            table.sort(v127, function(p39, p40) return p39.Distance < p40.Distance end)
          end

          return v127[1]
        end
      end

      if roxyHubState.AutoRebirth and roxyHubState.PrioritizeRebirthPet then
        local v132 = f27()

        if v132 and not v132.isMaxCap and not v132.hasPet and v132.reqPet and v132.reqPet ~= "" then
          if not v132.isIncubating then
            local v133 = {}

            for index33, value39 in ipairs(renderedEggs4:GetChildren()) do
              local v134 = f32(value39)

              if v134 then
                local name5 = value39.Name
                local v135 = f5(name5)
                local v136 = false
                local v137 = f20(v135)[v132.reqPet] or 0

                if v62[v132.reqPet] and v62[v132.reqPet][name5] then
                  v136 = true
                end

                if v137 > 0 or v136 then
                  local getPivot3 = value39:GetPivot()
                  local v138 = f4(name5)

                  table.insert(v133, {
                    Model = value39,
                    Name = name5,
                    Rarity = v138,
                    Prompt = v134,
                    Position = getPivot3.Position,
                    Distance = (getPivot3.Position - v114.Position).Magnitude,
                    Luck = v135,
                    Weight = v20[v138] or 0,
                    PetChance = v137,
                    IsFallback = v136,
                  })
                end
              end
            end

            if #v133 > 0 then
              table.sort(v133, function(p41, p42)
                if math.abs(p41.PetChance - p42.PetChance) > 1e-7 then
                  return p41.PetChance > p42.PetChance
                end

                if p41.IsFallback ~= p42.IsFallback then
                  return p41.IsFallback == true
                end

                return p41.Distance < p42.Distance
              end)

              local v139 = v133[1]

              v35.RebirthTargetPet = v132.reqPet
              v35.RebirthEggName = v139.Name
              v35.RebirthEggChance = v139.PetChance

              return v139
            end
          end
        end
      end

      if not roxyHubState.AutoFarm then
        return nil
      else
        local v140 = {}

        for index34, value40 in ipairs(renderedEggs4:GetChildren()) do
          local name6 = value40.Name
          local v141 = f4(name6)

          if f34(name6, v141) then
            local v142 = f32(value40)

            if v142 then
              local v143 = f31(value40)
              local v144 = true

              if roxyHubState.MinEggWeight and roxyHubState.MinEggWeight > 0 and v143 > 0
                and v143 < roxyHubState.MinEggWeight then
                v144 = false
              end

              if v144 then
                local getPivot4 = value40:GetPivot()
                local luck = f5(name6)

                table.insert(v140, {
                  Model = value40,
                  Name = name6,
                  Rarity = v141,
                  Prompt = v142,
                  Position = getPivot4.Position,
                  Distance = (getPivot4.Position - v114.Position).Magnitude,
                  Luck = luck,
                  Weight = v20[v141] or 0,
                  EggWeight = v143,
                })
              end
            end
          end
        end

        if #v140 == 0 then
          return nil
        else
          local farmPriority = roxyHubState.FarmPriority

          local priorityRarity = farmPriority

          priorityRarity = farmPriority
            or roxyHubState.PriorityRarity and "Highest Rarity First"
            or "Closest Distance First"

          if priorityRarity == "Heaviest Weight First" then
            table.sort(v140, function(p43, p44)
              if math.abs(p43.EggWeight - p44.EggWeight) > 0.05 then
                return p43.EggWeight > p44.EggWeight
              end

              if p43.Weight ~= p44.Weight then
                return p43.Weight > p44.Weight
              end

              return p43.Distance < p44.Distance
            end)
          elseif priorityRarity == "Highest Rarity First" then
            table.sort(v140, function(p45, p46)
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
            table.sort(v140, function(p47, p48)
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
            table.sort(v140, function(p49, p50)
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
            table.sort(v140, function(p51, p52) return p51.Distance < p52.Distance end)
          end

          return v140[1]
        end
      end
    end
  end
end

function f32(p53)
  return p53:FindFirstChildWhichIsA("ProximityPrompt", true)
end

local function f35(p54, p55)
  local roxyFlightStabilizer2 = p54:FindFirstChild("RoxyFlightStabilizer")

  if not roxyFlightStabilizer2 then
    roxyFlightStabilizer2 = Instance.new("BodyVelocity")
    roxyFlightStabilizer2.Name = "RoxyFlightStabilizer"
    roxyFlightStabilizer2.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
    roxyFlightStabilizer2.Velocity = Vector3.zero
    roxyFlightStabilizer2.Parent = p54
  end

  if p55 then
    p55.PlatformStand = true
  end

  if p54 then
    p54.AssemblyLinearVelocity = Vector3.zero
    p54.AssemblyAngularVelocity = Vector3.zero
  end

  return roxyFlightStabilizer2
end

local function f36(p56, p57)
  local v145 = p57 or p56 and f32(p56)

  pcall(function()
    if v145 and v145:IsA("ProximityPrompt") then
      v145.HoldDuration = 0

      if fireproximityprompt then
        fireproximityprompt(v145, 0)
      else
        v145:InputHoldBegin()
        task.wait(0.05)
        v145:InputHoldEnd()
      end
    end
  end)

  pcall(function()
    if eggPickup and p56 then
      local activeEggs3 = replicatedStorage:FindFirstChild("ServerData")
          and replicatedStorage.ServerData:FindFirstChild("ActiveEggs")
        or replicatedStorage:FindFirstChild("ActiveEggs")

      if activeEggs3 then
        local getPivot5 = p56:GetPivot()
        local v146 = nil
        local v147 = 25

        for index35, value41 in ipairs(activeEggs3:GetChildren()) do
          local position6 = value41:GetAttribute("Position")

          if position6 then
            local magnitude = (position6 - getPivot5.Position).Magnitude

            if magnitude < v147 then
              v147 = magnitude
              v146 = value41
            end
          end
        end

        if v146 then
          eggPickup:FireServer(v146.Name)
        end
      end
    end
  end)
end

local f37

local function f38(p58, p59)
  local v148, v149, v150 = f12()
  local cframe4, magnitude2, v151, connect2

  if not v149 then
    return false, "no_hrp"
  else
    local magnitude3 = (p58 - v149.Position).Magnitude
    local v152 = p58 - v149.Position

    if v152.Magnitude > 0.05 then
      local vector2 = Vector3.new(v152.X, 0, v152.Z)

      if vector2.Magnitude > 0.05 then
        cframe4 = CFrame.lookAt(
          p58 + Vector3.new(0, 1.8, 0), p58 + Vector3.new(0, 1.8, 0) + vector2.Unit
        )
      else
        cframe4 = CFrame.new(p58 + Vector3.new(0, 1.8, 0))
      end
    else
      cframe4 = CFrame.new(p58 + Vector3.new(0, 1.8, 0))
    end

    if roxyHubState.FarmMode == "Safe Tween" and true then
      local v153 = math.max(magnitude3 / 300, 0.05)
      f35(v149, v150)

      local create4 = tweenService:Create(v149, TweenInfo.new(v153, Enum.EasingStyle.Linear), {
        CFrame = cframe4,
      })

      v35.CurrentTween = create4
      create4:Play()
      v151 = false
      connect2 = create4.Completed:Connect(function() v151 = true end)
      local v154 = os.clock()

      while true do
        if not v151 and os.clock() - v154 < v153 + 1.2 then
          if not (roxyHubState.AutoFarm
            or roxyHubState.AutoRebirth and roxyHubState.PrioritizeRebirthPet) then
            create4:Cancel()
            pcall(function() connect2:Disconnect() end)
            v35.CurrentTween = nil
            f37(v149, v150)
            magnitude2 = (p58 - v149.Position).Magnitude

            if magnitude2 > 20 then
              if magnitude2 < 80 then
                v149.CFrame = cframe4
                return true, "ok"
              end

              return false, "not_arrived"
            end

            return true, "ok"
          end

          if p59 and not p59.Parent then
            break
          end

          task.wait(0.05)
        else
          pcall(function() connect2:Disconnect() end)
          v35.CurrentTween = nil
          f37(v149, v150)
          magnitude2 = (p58 - v149.Position).Magnitude

          if magnitude2 > 20 then
            if magnitude2 < 80 then
              v149.CFrame = cframe4
              return true, "ok"
            end

            return false, "not_arrived"
          end

          return true, "ok"
        end
      end

      create4:Cancel()
      pcall(function() connect2:Disconnect() end)
      v35.CurrentTween = nil
      f37(v149, v150)
      return false, "despawned"
    end

    if v149 then
      v149.AssemblyLinearVelocity = Vector3.zero
      v149.AssemblyAngularVelocity = Vector3.zero
      v149.CFrame = cframe4
    end

    return true, "ok"
  end
end

function f37(p60, p61)
  local roxyFlightStabilizer3 = p60:FindFirstChild("RoxyFlightStabilizer")

  if roxyFlightStabilizer3 then
    roxyFlightStabilizer3:Destroy()
  end

  if p61 then
    p61.PlatformStand = false
    p61:ChangeState(Enum.HumanoidStateType.GettingUp)
  end

  if p60 then
    p60.AssemblyLinearVelocity = Vector3.zero
    p60.AssemblyAngularVelocity = Vector3.zero
  end
end

local f39

local function f40(p62)
  local v155, v156, v157 = f12()
  local v158 = f13()
  local v159 = not v158 or not v156 or not v157
  local cframe5, v160, connect3

  if v159 then
    return
  else
    local baseplate = v158:FindFirstChild("Baseplate")

    if not baseplate then
      return
    else
      f23(v156, v157)
      local v161, v162, v163 = f12()

      if not v162 or not v163 then
        return
      else
        if roxyHubState.AutoMagmaDip and not v35.IsMagmaDipping and p62 ~= "Return to Plot" then
          v35.IsMagmaDipping = true
          f39(p62)
          v35.IsMagmaDipping = false
          local v164 = { f12() }
          v162 = v164[2]
          local v165 = not v162
          v163 = v164[3]

          if v165 or not v163 then
            return
          end
        end

        v35.Status = "Delivering to Plot..."
        local v166 = baseplate.Position + Vector3.new(0, 3.5, 0)
        local magnitude4 = (v166 - v162.Position).Magnitude

        if magnitude4 > 15 then
          if roxyHubState.FarmMode == "Instant" then
            v35.Status = "Instant Warp to Plot..."

            if v35.CurrentTween then
              pcall(function() v35.CurrentTween:Cancel() end)
              v35.CurrentTween = nil
            end

            f37(v162, v163)

            if v162 then
              v162.AssemblyLinearVelocity = Vector3.zero
              v162.AssemblyAngularVelocity = Vector3.zero
              v162.CFrame = CFrame.new(v166)
            end

            task.wait(0.08)
            local v167, v168, v169 = f12()

            if v168 then
              v162 = v168

              if (v166 - v162.Position).Magnitude > 15 then
                v162.AssemblyLinearVelocity = Vector3.zero
                v162.AssemblyAngularVelocity = Vector3.zero
                v162.CFrame = CFrame.new(v166)

                task.wait(0.05)
              end
            end
          else
            local v170 = v166 - v162.Position

            if v170.Magnitude > 0.05 then
              cframe5 = CFrame.lookAt(v166, v166 + v170.Unit)
            else
              cframe5 = CFrame.new(v166)
            end

            f35(v162, v163)
            local v171 = math.max(magnitude4 / 320, 0.05)

            local create5 = tweenService:Create(
              v162, TweenInfo.new(v171, Enum.EasingStyle.Linear), { CFrame = cframe5 }
            )

            v35.CurrentTween = create5
            create5:Play()
            v160 = false
            connect3 = create5.Completed:Connect(function() v160 = true end)
            local v172 = os.clock()

            while not v160 and os.clock() - v172 < v171 + 1.5 do
              if not (roxyHubState.AutoFarm
                or roxyHubState.AutoRebirth and roxyHubState.PrioritizeRebirthPet) then
                create5:Cancel()
                break
              end

              task.wait(0.05)
            end

            pcall(function() connect3:Disconnect() end)
            v35.CurrentTween = nil
            f37(v162, v163)
          end
        end

        if firetouchinterest then
          pcall(firetouchinterest, v162, baseplate, 0)
          task.wait(0.04)
          pcall(firetouchinterest, v162, baseplate, 1)
        end

        local v173 = os.clock()

        while os.clock() - v173 < 1.5 do
          local basket3 = localPlayer2:FindFirstChild("Basket")

          if not basket3 or #basket3:GetChildren() == 0 then
            break
          end

          if firetouchinterest then
            pcall(firetouchinterest, v162, baseplate, 0)
            task.wait(0.03)
            pcall(firetouchinterest, v162, baseplate, 1)
          end

          task.wait(0.05)
        end

        if roxyHubState.AutoHatchPlot then
          local eggs4 = v158:FindFirstChild("Eggs")

          if eggs4 then
            for index36, value42 in ipairs(eggs4:GetChildren()) do
              local findFirstChild8 = value42:FindFirstChild("Hatch", true)
                or value42:FindFirstChildWhichIsA("ProximityPrompt", true)

              if findFirstChild8 and findFirstChild8:IsA("ProximityPrompt")
                and findFirstChild8.Enabled then
                v35.Status = "Hatching " .. value42.Name .. "..."
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
              for index37, value43 in ipairs(holder2:GetChildren()) do
                local findFirstChild9 = value43:FindFirstChild("Open", true)

                if findFirstChild9 and findFirstChild9:IsA("GuiButton")
                  and findFirstChild9.Visible then
                  if getconnections then
                    for key5, value44 in pairs(getconnections(findFirstChild9.Activated)) do
                      value44:Fire()
                    end

                    for key6, value45 in pairs(getconnections(findFirstChild9.MouseButton1Click)) do
                      value45:Fire()
                    end
                  end
                end
              end
            end
          end)
        end

        if roxyHubState.AutoPlaceNest then
          local spawnNest = roxyHubState.SpawnNest and 15 or 10
          local v174 = f14()

          if v174 < spawnNest then
            local v175 = v174 - f15()
            local v176 = 0

            if roxyHubState.SpawnNest then
              local nests4 = v158:FindFirstChild("Nests")

              if nests4 then
                for index38, value46 in ipairs(nests4:GetChildren()) do
                  if value46:GetAttribute("Unlocked") ~= false
                    and not value46:GetAttribute("Occupied") then
                    v176 = v176 + 1
                  end
                end
              end
            end

            if v176 > 0 or v175 < 10 then
              local v177 = {}

              for index39, value47 in ipairs(localPlayer2.Backpack:GetChildren()) do
                if value47:IsA("Tool")
                  and (value47:HasTag("Egg") or string.find(value47.Name, "Egg")) then
                  table.insert(v177, value47)
                end
              end

              local character6 = localPlayer2.Character

              if character6 then
                for index40, value48 in ipairs(character6:GetChildren()) do
                  if value48:IsA("Tool")
                    and (value48:HasTag("Egg") or string.find(value48.Name, "Egg")) then
                    table.insert(v177, value48)
                  end
                end
              end

              for index41, value49 in ipairs(v177) do
                local v178 = f14()
                local v179 = v178 - f15()

                if v178 >= spawnNest then
                  break
                else
                  local v180 = false

                  if roxyHubState.SpawnNest and v176 > 0 then
                    local nests5 = v158:FindFirstChild("Nests")

                    if nests5 then
                      for index42, value50 in ipairs(nests5:GetChildren()) do
                        if value50:GetAttribute("Unlocked") ~= false
                          and not value50:GetAttribute("Occupied") then
                          v35.Status = "Placing " .. value49.Name .. " in Nest..."

                          if character6 and v163 and value49.Parent ~= character6 then
                            v163:EquipTool(value49)
                            local v181 = os.clock()

                            while value49.Parent ~= character6 and os.clock() - v181 < 0.8 do
                              task.wait(0.05)
                            end
                          end

                          if value49.Parent == character6 and eggPlaced then
                            task.wait(0.1)
                            eggPlaced:FireServer({ NestId = value50.Name })
                            local v182 = os.clock()

                            while value49.Parent == character6 and os.clock() - v182 < 1 do
                              task.wait(0.05)
                            end

                            task.wait(0.2)
                            f14()

                            v35.Status = "Placed " .. value49.Name .. " in Nest "
                              .. value50.Name .. "!"

                            v180 = true
                            v176 = math.max(0, v176 - 1)
                          end

                          break
                        end
                      end
                    end
                  end

                  if not v180 then
                    if v179 < 10 then
                      v35.Status = "Placing " .. value49.Name .. " on Plot..."
                      local v183 = math.random()
                      local v184 = math.random()

                      local vector3 = Vector3.new(
                        (v183 * 2 - 1) * 20, 0.55, (v184 * 2 - 1) * 20
                      )

                      local pointToWorldSpace = baseplate.CFrame:PointToWorldSpace(vector3)

                      if character6 and v163 and value49.Parent ~= character6 then
                        v163:EquipTool(value49)
                        local v185 = os.clock()

                        while value49.Parent ~= character6 and os.clock() - v185 < 0.8 do
                          task.wait(0.05)
                        end
                      end

                      if value49.Parent == character6 and eggPlaced then
                        task.wait(0.1)
                        eggPlaced:FireServer({ PlantPosition = pointToWorldSpace })
                        local v186 = os.clock()

                        while value49.Parent == character6 and os.clock() - v186 < 1 do
                          task.wait(0.05)
                        end

                        task.wait(0.2)
                        f14()
                        v35.Status = "Placed " .. value49.Name .. " on Plot!"
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
          local nests6 = v158:FindFirstChild("Nests")

          if nests6 then
            for index43, value51 in ipairs(nests6:GetChildren()) do
              if value51:GetAttribute("Unlocked") ~= true then
                local findFirstChildWhichIsA = value51:FindFirstChildWhichIsA(
                  "ProximityPrompt", true
                )

                if findFirstChildWhichIsA and fireproximityprompt then
                  fireproximityprompt(findFirstChildWhichIsA, 0)
                end

                local v187 = tonumber(value51.Name)

                if v187 and nests then
                  pcall(function() nests:FireServer(v187) end)
                end

                task.wait(0.05)
              end
            end
          end
        end

        v35.Status = "Delivery Complete!"
        task.wait(0.05)
        return
      end
    end
  end
end

function f39(p63)
  local v188

  if not roxyHubState.AutoMagmaDip then
    return false
  else
    local basket4 = localPlayer2:FindFirstChild("Basket")

    if not basket4 or #basket4:GetChildren() == 0 then
      return false
    else
      local v189, v190, v191 = f12()

      if not v190 or not v191 then
        return false
      end

      v188 = nil

      for index44, value52 in ipairs(basket4:GetChildren()) do
        if value52:GetAttribute("VolcanoDipped") ~= true
          and value52:GetAttribute("Delivering") ~= true then
          local mutation2 = value52:GetAttribute("Mutation")

          if mutation2 ~= "Eternal" and mutation2 ~= "Magma" then
            v188 = value52
            break
          end
        end
      end

      if not v188 then
        return false
      else
        if v35.CurrentTween then
          pcall(function() v35.CurrentTween:Cancel() end)
          v35.CurrentTween = nil
        end

        f37(v190, v191)
        v35.Status = "Warping directly to Volcano Top..."

        v190.AssemblyLinearVelocity = Vector3.zero
        v190.AssemblyAngularVelocity = Vector3.zero
        v190.CFrame = CFrame.new(vector)

        task.wait(0.2)

        if (v190.Position - vector).Magnitude > 25 then
          v190.AssemblyLinearVelocity = Vector3.zero
          v190.AssemblyAngularVelocity = Vector3.zero
          v190.CFrame = CFrame.new(vector)

          task.wait(0.1)
        end

        v35.Status = "Triggering Magma Lava Dip..."

        local reVolcanoDip = replicatedStorage:FindFirstChild("packages")
          and replicatedStorage.packages:FindFirstChild("Net")
          and replicatedStorage.packages.Net:FindFirstChild("RE/VolcanoDip")

        local v192 = os.clock()

        while os.clock() - v192 < 3.5 do
          if not v188.Parent then
            break
          else
            local volcanoUntil = v188:GetAttribute("VolcanoUntil")

            if volcanoUntil and type(volcanoUntil) == "number"
                and volcanoUntil > workspace:GetServerTimeNow()
              or v188:GetAttribute("VolcanoDipped") == true then
              break
            end

            if reVolcanoDip then
              pcall(function() reVolcanoDip:FireServer() end)
            else
              pcall(function()
                local v193 = f3(replicatedStorage.packages:FindFirstChild("Net"), "Net")

                if v193 and v193.RemoteEvent then
                  local volcanoDip = v193:RemoteEvent("VolcanoDip")

                  if volcanoDip then
                    volcanoDip:FireServer()
                  end
                end
              end)
            end

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

            task.wait(0.3)
          end
        end

        local v194 = os.clock()
        local magmaDipDuration = roxyHubState.MagmaDipDuration or 9.5

        while os.clock() - v194 < magmaDipDuration do
          if not v188.Parent then
            break
          else
            local v195, v196 = f12()

            if v196 and (v196.Position - vector).Magnitude > 30 then
              v196.AssemblyLinearVelocity = Vector3.zero
              v196.AssemblyAngularVelocity = Vector3.zero
              v196.CFrame = CFrame.new(vector)
            end

            local volcanoUntil2 = v188:GetAttribute("VolcanoUntil")

            if volcanoUntil2 and type(volcanoUntil2) == "number"
              and workspace:GetServerTimeNow() >= volcanoUntil2 then
              break
            else
              local v197 = os.clock()
              local v198 = math.max(0, math.ceil(magmaDipDuration - (v197 - v194)))
              v35.Status = string.format("Dipping Egg in Lava (Magma Gamble)... %ds", v198)
              task.wait(0.2)
            end
          end
        end

        pcall(function() v188:SetAttribute("VolcanoDipped", true) end)

 
        if (v188.Parent and v188:GetAttribute("Mutation")) == "Magma" then
          v35.Status = "Magma Mutation Succeeded! (10x)"

          pcall(function()
            WindUI:Notify({
              Title = "Magma Mutation (10x)!",
              Content = string.format("Successfully mutated %s to Magma!", v188.Name),
              Duration = 4,
              Icon = "flame",
            })
          end)
        else
          v35.Status = "Dip Complete (No Magma)"
        end

        return true
      end
    end
  end
end

task.spawn(function()
  while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
    task.wait(0.1)
    local autoRebirth = roxyHubState.AutoRebirth and f27() or nil

    local v199 = autoRebirth and not autoRebirth.isMaxCap and not autoRebirth.hasPet
      and not autoRebirth.isIncubating and autoRebirth.reqPet ~= ""

    if roxyHubState.AutoFarm or v199 then
      local v200, v201 = f12()

      if v200 and v201 then
        local basket5 = localPlayer2:FindFirstChild("Basket")

        if basket5 and #basket5:GetChildren() >= 1 then
          v35.Status = "Basket Full (1/1) - Delivering..."
          f40("Carried Egg")
          local basket6 = localPlayer2:FindFirstChild("Basket")

          if basket6 and #basket6:GetChildren() >= 1 then
            v35.Status = "Offloading egg at Baseplate..."
            task.wait(0.4)
          end
        end

        local basket7 = localPlayer2:FindFirstChild("Basket")
          and #localPlayer2.Basket:GetChildren() >= 1

        if basket7 then
          v35.Status = "Plot Full - Waiting for Hatch..."
          task.wait(1.5)
        elseif not basket7 then
          local v202 = f33()

          if v202 and v202.IsWaitingWeather then
            v35.IsFarming = true
            local timeLeft = v202.TimeLeft or 0

            v35.Status = string.format(
              "[Weather: %s] Waiting for %s eggs (%ds)...", v202.StormVariant or "Storm",
              v202.MutationType or "Mutation", timeLeft
            )

            v35.Target = "Waiting for " .. (v202.MutationType or "Mutation")
            v35.TargetRarity = v202.StormVariant or "Weather"
            v35.TargetWeight = 0

            task.wait(0.5)
          elseif v202 and v202.Model and v202.Model.Parent then
            v35.IsFarming = true

            local v203 = v202.Mutation
                and string.format(" [%s x%d]", v202.Mutation, v23[v202.Mutation] or 1)
              or ""

            v35.Status = "Targeting " .. v202.Name .. v203
            v35.Target = v202.Name .. v203

            v35.TargetRarity = v202.Mutation and v202.Mutation .. " (" .. v202.Rarity .. ")"
              or v202.Rarity

            v35.TargetWeight = v202.EggWeight or 0

            local v204 = false
            local v205 = v202.Name == "Volcanic Egg"

            if v205
              and (localPlayer2:GetAttribute("InVolcano") ~= true
                or localPlayer2:GetAttribute("VolcanoValidated") ~= true) then
              v35.Status = "Entering Volcano (Activating Scorching)..."
              f22(v201, hum)
              v1477, v201 = f12()
            end

            if v201 then
              if v205 then
                if v35.CurrentTween then
                  pcall(function() v35.CurrentTween:Cancel() end)
                  v35.CurrentTween = nil
                end

                f37(v201, hum)
                v1480, v201 = f12()

                if v201 then
                  v201.AssemblyLinearVelocity = Vector3.zero
                  v201.AssemblyAngularVelocity = Vector3.zero

                  local position7 = v202.Position
                  local parent = v202.Prompt and v202.Prompt.Parent

                  if parent and parent:IsA("BasePart") then
                    position7 = parent.Position
                  end

                  v201.CFrame = CFrame.new(position7.X, position7.Y + 2, position7.Z)
                  task.wait(0.08)

                  if (v201.Position - position7).Magnitude > 25 then
                    v201.AssemblyLinearVelocity = Vector3.zero
                    v201.AssemblyAngularVelocity = Vector3.zero
                    v201.CFrame = CFrame.new(position7.X, position7.Y + 2, position7.Z)

                    task.wait(0.05)
                  end

                  v204 = true
                end
              else
                local v206, v207 = f38(v202.Position, v202.Model)

                if not v206 then
                  if v207 == "despawned" then
                    v35.Status = v202.Name .. " despawned, retargeting..."
                  else
                    v35.Status = "Retrying move to " .. v202.Name .. "..."
                  end

                  task.wait(0.2)
                else
                  v204 = true
                end
              end
            end

            if v204 then
              local v208 = math.clamp(roxyHubState.SyncDelay, 0.25, 0.6)
              task.wait(v208)

              local basket8 = localPlayer2:FindFirstChild("Basket")
                  and #localPlayer2.Basket:GetChildren()
                or 0

              v1492, v201 = f12()

              if v201 then
                v201.AssemblyLinearVelocity = Vector3.zero
                v201.AssemblyAngularVelocity = Vector3.zero

                local position8 = v202.Position
                local parent2 = v202.Prompt and v202.Prompt.Parent

                if parent2 and parent2:IsA("BasePart") then
                  position8 = parent2.Position
                end

                v201.CFrame = CFrame.new(position8.X, position8.Y + 2, position8.Z)
              end

              pcall(function()
                if workspaceService.CurrentCamera and v201 then
                  workspaceService.CurrentCamera.CFrame = CFrame.lookAt(v201.Position
                    + Vector3.new(0, 3, 4), v202.Position)
                end
              end)

              if v202.Model and v202.Model.Parent then
                v35.Status = "Collecting " .. v202.Name
                f36(v202.Model, v202.Prompt)
              end

              local v209 = math.clamp(roxyHubState.PostPickupDelay + 1.8, 1.8, 3)
              local v210 = os.clock()
              local v211 = false
              local v212 = os.clock()

              while os.clock() - v210 < v209 do
                if (localPlayer2:FindFirstChild("Basket") and #localPlayer2.Basket:GetChildren()
                    or 0)
                  > basket8 then
                  v211 = true
                  break
                end

                if not v202.Model or not v202.Model.Parent then
                  v211 = true
                  break
                end

                if os.clock() - v212 >= 0.3 then
                  v212 = os.clock()
                  v1509, v201 = f12()

                  if v201 then
                    v201.AssemblyLinearVelocity = Vector3.zero
                    v201.AssemblyAngularVelocity = Vector3.zero

                    local position9 = v202.Position
                    local parent3 = v202.Prompt and v202.Prompt.Parent

                    if parent3 and parent3:IsA("BasePart") then
                      position9 = parent3.Position
                    end

                    v201.CFrame = CFrame.new(position9.X, position9.Y + 2, position9.Z)
                  end

                  f36(v202.Model, v202.Prompt)
                end

                task.wait(0.05)
              end

              if v211 then
                v35.CollectedCount = v35.CollectedCount + 1
                v35.Status = "Collected " .. v202.Name .. " (1/1) - Delivering..."
                f40(v202.Name)
              else
                v35.Status = "Missed " .. v202.Name .. ", retargeting..."
                task.wait(0.2)
              end
            end
          else
            if autoRebirth and autoRebirth.isIncubating then
              local incubatingTime2 = autoRebirth.incubatingTime
                  and " (" .. autoRebirth.incubatingTime .. ")"
                or ""

              v35.Status = string.format(
                "Waiting for Ethereal / Incubating 1 %s%s",
                autoRebirth.incubatingEggName or "Egg", incubatingTime2
              )
            else
              v35.Status = "Searching for targets..."
            end

            v35.Target = "None"
            v35.TargetWeight = 0

            if roxyHubState.AutoReturnPlot then
              local v213 = f13()

              local baseplate2 = v213
              baseplate2 = v213 and v213:FindFirstChild("Baseplate")

              if baseplate2 and (baseplate2.Position - v201.Position).Magnitude > 25 then
                f40("Return to Plot")
              end
            end

            task.wait(0.5)
          end
        end
      end
    else
      v35.IsFarming = false

      if v35.CurrentTween then
        pcall(function() v35.CurrentTween:Cancel() end)
        v35.CurrentTween = nil
      end

      if roxyHubState.AutoRebirth and autoRebirth and not autoRebirth.isMaxCap then
        if autoRebirth.hasPet then
          v35.Status = string.format("Pet Owned (%s) - Waiting for Cash...", autoRebirth.reqPet)
        elseif autoRebirth.isIncubating then
          local incubatingTime3 = autoRebirth.incubatingTime
              and " (" .. autoRebirth.incubatingTime .. ")"
            or ""

          v35.Status = string.format(
            "Incubating 1 %s%s - Waiting to Hatch...", autoRebirth.incubatingEggName or "Egg",
            incubatingTime3
          )
        else
          v35.Status = "Idle"
        end
      else
        v35.Status = "Idle"
      end

      v35.Target = "None"
      v35.TargetWeight = 0
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

        local v214 = f13()

        local eggs5 = v214
        eggs5 = v214 and v214:FindFirstChild("Eggs")

        if eggs5 then
          for index46, value56 in ipairs(eggs5:GetChildren()) do
            local eggKey2 = value56:GetAttribute("EggKey")
            local v215 = f25(value56)

            if v215 and v215.isReady and eggKey2 then
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
        local v216 = f27()

        if v216.canRebirth and not v216.isMaxCap then
          v35.Status = "Executing Rebirth Tier " .. v216.nextTier .. "!"

          if f28() and WindUI and WindUI.Notify then
            WindUI:Notify({
              Title = "Rebirth Completed",
              Content = string.format(
                "Tier %d unlocked! Requirements fulfilled.", v216.nextTier
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

    if roxyHubState.AutoPlaceNest and not v35.CurrentTween then
      pcall(function()
        local v217 = f13()
        local baseplate3 = v217 and v217:FindFirstChild("Baseplate")
        local v218, v219, v220 = f12()

        if not v217 or not baseplate3 or not v220 or not v219 then
          return
        elseif (v219.Position - baseplate3.Position).Magnitude > 85 then
          return
        else
          local spawnNest2 = roxyHubState.SpawnNest and 15 or 10

          if f14() >= spawnNest2 then
            return
          else
            local v221 = {}

            for index47, value57 in ipairs(localPlayer2.Backpack:GetChildren()) do
              if value57:IsA("Tool")
                and (value57:HasTag("Egg") or string.find(value57.Name, "Egg")) then
                table.insert(v221, value57)
              end
            end

            if v218 then
              for index48, value58 in ipairs(v218:GetChildren()) do
                if value58:IsA("Tool")
                  and (value58:HasTag("Egg") or string.find(value58.Name, "Egg")) then
                  table.insert(v221, value58)
                end
              end
            end

            if #v221 > 0 then
              for index49, value59 in ipairs(v221) do
                local v222 = f14()

                if v222 >= spawnNest2 then
                  break
                else
                  local v223 = false

                  if roxyHubState.SpawnNest then
                    local nests7 = v217:FindFirstChild("Nests")

                    if nests7 then
                      for index50, value60 in ipairs(nests7:GetChildren()) do
                        if value60:GetAttribute("Unlocked") ~= false
                          and not value60:GetAttribute("Occupied") then
                          if value59.Parent ~= v218 then
                            v220:EquipTool(value59)
                            local v224 = os.clock()

                            while value59.Parent ~= v218 and os.clock() - v224 < 0.8 do
                              task.wait(0.05)
                            end
                          end

                          if value59.Parent == v218 and eggPlaced then
                            task.wait(0.1)
                            eggPlaced:FireServer({ NestId = value60.Name })
                            local v225 = os.clock()

                            while value59.Parent == v218 and os.clock() - v225 < 1 do
                              task.wait(0.05)
                            end

                            task.wait(0.25)
                            v223 = true
                            v222 = f14()
                          end

                          break
                        end
                      end
                    end
                  end

                  if not v223 then
                    if v222 - f15() < 10 then
                      local v226 = math.random()
                      local v227 = math.random()

                      local vector4 = Vector3.new(
                        (v226 * 2 - 1) * 20, 0.55, (v227 * 2 - 1) * 20
                      )

                      local pointToWorldSpace2 = baseplate3.CFrame:PointToWorldSpace(vector4)

                      if value59.Parent ~= v218 then
                        v220:EquipTool(value59)
                        local v228 = os.clock()

                        while value59.Parent ~= v218 and os.clock() - v228 < 0.8 do
                          task.wait(0.05)
                        end
                      end

                      if value59.Parent == v218 and eggPlaced then
                        task.wait(0.1)
                        eggPlaced:FireServer({ PlantPosition = pointToWorldSpace2 })
                        local v229 = os.clock()

                        while value59.Parent == v218 and os.clock() - v229 < 1 do
                          task.wait(0.05)
                        end

                        task.wait(0.25)
                        f14()
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

local values2 = {
  "Hydra Dragon ($165M/s - Val: $99B)", "Hellhound ($140M/s - Val: $84B)",
  "Fenrir ($120M/s - Val: $72B)", "Stone Golem ($60M/s - Val: $36B)",
  "El Toro ($20M/s - Val: $12B)", "Black Panther ($180K/s - Val: $108M)",
  "Jackalope ($125K/s - Val: $75M)", "Grizzly Bear ($75K/s - Val: $45M)",
  "Scorpion ($45K/s - Val: $27M)", "Black Stallion ($5.4K/s - Val: $3.2M)",
  "Anaconda ($4K/s - Val: $2.4M)", "White Tiger ($2.8K/s - Val: $1.7M)",
  "Okapi ($2K/s - Val: $1.2M)", "Fennec ($900/s - Val: $540K)", "Bison ($625/s - Val: $375K)",
  "Llama ($425/s - Val: $255K)",
}

local v230 = {
  ["Hydra Dragon ($165M/s - Val: $99B)"] = "Hydra Dragon",
  ["Hellhound ($140M/s - Val: $84B)"] = "Hellhound",
  ["Fenrir ($120M/s - Val: $72B)"] = "Fenrir",
  ["Stone Golem ($60M/s - Val: $36B)"] = "Stone Golem",
  ["El Toro ($20M/s - Val: $12B)"] = "El Toro",
  ["Black Panther ($180K/s - Val: $108M)"] = "Black Panther",
  ["Jackalope ($125K/s - Val: $75M)"] = "Jackalope",
  ["Grizzly Bear ($75K/s - Val: $45M)"] = "Grizzly Bear",
  ["Scorpion ($45K/s - Val: $27M)"] = "Scorpion",
  ["Black Stallion ($5.4K/s - Val: $3.2M)"] = "Black Stallion",
  ["Anaconda ($4K/s - Val: $2.4M)"] = "Anaconda",
  ["White Tiger ($2.8K/s - Val: $1.7M)"] = "White Tiger",
  ["Okapi ($2K/s - Val: $1.2M)"] = "Okapi",
  ["Fennec ($900/s - Val: $540K)"] = "Fennec",
  ["Bison ($625/s - Val: $375K)"] = "Bison",
  ["Llama ($425/s - Val: $255K)"] = "Llama",
}

local function f41(p64)
  if not p64 then
    return
  end

  pcall(function()
    local favoritePet = replicatedStorage:FindFirstChild("Remotes")
      and replicatedStorage.Remotes:FindFirstChild("Game")
      and replicatedStorage.Remotes.Game:FindFirstChild("FavoritePet")

    if favoritePet then
      favoritePet:FireServer(p64)
    end
  end)
end

local function f42(p65)
  if not roxyHubState.AutoFavoriteFuse then
    return false
  end

  if not roxyHubState.AutoFavoriteFuseList or type(roxyHubState.AutoFavoriteFuseList) ~= "table" then
    return false
  end

  for index51, value61 in ipairs(roxyHubState.AutoFavoriteFuseList) do
    if v230[value61] == p65 or string.find(value61, p65, 1, true) then
      return true
    end
  end

  return false
end

task.spawn(function()
  while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
    task.wait(0.5)
  end
end)

task.spawn(function()
  while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
    task.wait(1.5)

    if roxyHubState.AutoFavoriteFuse then
      pcall(function()
        for index52, value62 in ipairs(localPlayer2.Backpack:GetChildren()) do
          if value62:IsA("Tool") and value62:HasTag("Pet")
            and value62:GetAttribute("Favorited") ~= true then
            local petName = value62:GetAttribute("PetName") or value62.Name

            if f42(string.match(petName, "^(.-)%s*%[") or petName) then
              value62:GetAttribute("PetKey")
            end
          end
        end
      end)
    end

    if roxyHubState.AutoFuse then
      pcall(function()
        local v231, v232, v233 = f12()
        local v234 = not v231 or not v232 or not v233
        local petKey3

        if v234 then
          return
        else
          local fusionSlots = localPlayer2:FindFirstChild("FusionSlots")
          local fusionResult = localPlayer2:FindFirstChild("FusionResult")

          local v235 = replicatedStorage:FindFirstChild("Remotes")
            and replicatedStorage.Remotes:FindFirstChild("Game")

          local fusionAction = v235 and v235:FindFirstChild("FusionAction")

          local fusionPetPlace = v235
          fusionPetPlace = v235 and v235:FindFirstChild("FusionPetPlace")

          local v236 = not fusionSlots
          local v237 = fusionPetPlace

          if v236 or not fusionAction or not v237 then
            return
          else
            local vector5 = Vector3.new(387.9, 40328.8, 751.3)
            local fusionStatus = fusionSlots:GetAttribute("FusionStatus")

            local cash = localPlayer2:FindFirstChild("SavedData")
                and localPlayer2.SavedData:FindFirstChild("Cash")
                and tonumber(localPlayer2.SavedData.Cash.Value)
              or localPlayer2:FindFirstChild("leaderstats")
                and localPlayer2.leaderstats:FindFirstChild("Cash")
                and tonumber(localPlayer2.leaderstats.Cash.Value)
              or 0

            local v238 = require(replicatedStorage.GameServices.FusionRules)

            if fusionStatus == "Result" then
              if (v232.Position - vector5).Magnitude > 25 then
                v232.CFrame = CFrame.new(vector5 + Vector3.new(0, 3, 0))
                task.wait(0.4)
              end

              if fusionSlots:GetAttribute("FusionFailed") == true then
                fusionAction:FireServer("Claim", fusionSlots:GetAttribute("FusionResultKey"))
              else
                local pet = fusionResult and fusionResult:FindFirstChild("Pet")
                petKey3 = pet and pet:GetAttribute("PetKey")

                if petKey3 then
                  fusionAction:FireServer("Claim", petKey3)

                  if roxyHubState.AutoFavoriteFuse then
                    task.delay(0.5, function() f41(petKey3) end)
                  end
                else
                  local fusionOutput = workspaceService:FindFirstChild("Functionals")
                    and workspaceService.Functionals:FindFirstChild("Fusion")
                    and workspaceService.Functionals.Fusion:FindFirstChild("FusionOutput")

                  local findFirstChildWhichIsA2 = fusionOutput and fusionOutput:FindFirstChildWhichIsA(
                    "ProximityPrompt", true
                  )

                  if findFirstChildWhichIsA2 and fireproximityprompt then
                    fireproximityprompt(findFirstChildWhichIsA2, 0)
                  end
                end
              end

              task.wait(1)
              return
            elseif fusionStatus == "Waiting" then
              local endsAt = fusionSlots:GetAttribute("EndsAt")

              if workspace:GetServerTimeNow() >= (endsAt or 0) then
                if (v232.Position - vector5).Magnitude > 25 then
                  v232.CFrame = CFrame.new(vector5 + Vector3.new(0, 3, 0))
                  task.wait(0.4)
                end

                fusionAction:FireServer("Fuse")
                task.wait(2)
              end

              return
            else
              local v239 = {}

              for i = 1, 4 do
                if not fusionSlots:FindFirstChild(tostring(i)) then
                  table.insert(v239, i)
                end
              end

              if #v239 == 0 or fusionSlots:GetAttribute("Ready") == true then
                local v240 = {}
                local count2 = 0

                while true do
                  count2 = 1 + count2

                  if not (count2 <= 4) then
                    break
                  end

                  local findFirstChild13 = fusionSlots:FindFirstChild(tostring(count2))

                  if findFirstChild13 then
                    table.insert(v240, findFirstChild13:GetAttributes())
                  end
                end

                local v241 = v238.Preview(v240)

                if cash < (v241 and v241.FuseCost or 0) then
                  return
                end

                if (v232.Position - vector5).Magnitude > 25 then
                  v232.CFrame = CFrame.new(vector5 + Vector3.new(0, 3, 0))
                  task.wait(0.4)
                end

                fusionAction:FireServer("Start")
                task.wait(2)
                return
              else
                local v242 = require(replicatedStorage.GameData.Pets)
                local v243 = {}

                for index53, value63 in ipairs(localPlayer2.Backpack:GetChildren()) do
                  if value63:IsA("Tool") and value63:HasTag("Pet") then
                    local petName2 = value63:GetAttribute("PetName") or value63.Name

                    local v244 = v242[string.match(petName2, "^(.-)%s*%[") or petName2]
                      or v242[petName2]

                    local rarity = v244 and v244.Rarity or value63:GetAttribute("Rarity")
                    local v245 = value63:GetAttribute("Favorited") == true

                    if rarity and roxyHubState.FuseRarities
                      and roxyHubState.FuseRarities[rarity] == true then
                      if not (roxyHubState.FuseProtectFavorited and v245) then
                        table.insert(v243, value63)
                      end
                    end
                  end
                end

                if #v243 >= #v239 then
                  local v246 = {}
                  local count3 = 0

                  while true do
                    count3 = 1 + count3

                    if not (4 >= count3) then
                      break
                    end

                    local findFirstChild14 = fusionSlots:FindFirstChild(tostring(count3))

                    if findFirstChild14 then
                      table.insert(v246, findFirstChild14:GetAttributes())
                    end
                  end

                  for index54, value64 in ipairs(v243) do
                    if #v246 >= 4 then
                      break
                    end

                    table.insert(v246, value64:GetAttributes())
                  end

                  if #v246 == 4 then
                    local v247 = v238.Preview(v246)

                    if cash < (v247 and v247.FuseCost or 0) then
                      return
                    end
                  end

                  if (v232.Position - vector5).Magnitude > 25 then
                    v232.CFrame = CFrame.new(vector5 + Vector3.new(0, 3, 0))
                    task.wait(0.4)
                  end

                  for index55, value65 in ipairs(v239) do
                    if #v243 == 0 then
                      break
                    else
                      local v248 = table.remove(v243, 1)

                      if v248 and v248.Parent == localPlayer2.Backpack and v233 then
                        v233:UnequipTools()
                        task.wait(0.05)
                        v233:EquipTool(v248)
                        local v249 = os.clock()

                        while v248.Parent ~= v231 and os.clock() - v249 < 0.8 do
                          task.wait(0.05)
                        end

                        if v248.Parent == v231 then
                          task.wait(0.1)
                          v237:FireServer(value65)
                          task.wait(0.25)
                        end
                      end
                    end
                  end

                  task.wait(0.5)

                  if fusionSlots:GetAttribute("Ready") == true
                    or #fusionSlots:GetChildren() >= 4 then
                    fusionAction:FireServer("Start")
                    task.wait(2)
                  end

                  return
                end

                return
              end
            end
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
          local v250 = f13()

          if v250 and v250:FindFirstChild("Nests") then
            for index56, value66 in ipairs(v250.Nests:GetChildren()) do
              if value66:GetAttribute("Unlocked") ~= true then
                local findFirstChildWhichIsA3 = value66:FindFirstChildWhichIsA(
                  "ProximityPrompt", true
                )

                if findFirstChildWhichIsA3 and fireproximityprompt then
                  fireproximityprompt(findFirstChildWhichIsA3, 0)
                end

                local nests8 = replicatedStorage:FindFirstChild("Remotes", true)
                  and replicatedStorage.Remotes:FindFirstChild("Game", true)
                  and replicatedStorage.Remotes.Game:FindFirstChild("Plot", true)
                  and replicatedStorage.Remotes.Game.Plot:FindFirstChild("Nests")

                if nests8 then
                  local v251 = tonumber(value66.Name)

                  if v251 then
                    nests8:FireServer(v251)
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

local function f43(p66)
  local v252 = f13()
  local baseplate4 = v252 and v252:FindFirstChild("Baseplate")
  local v253, v254, v255 = f12()
  local v256 = v252 and baseplate4 and v253 and v254 and v255
  local v257, bestPetsStrategy

  if not v256 then
    return false, "Not near plot or character missing"
  elseif (v254.Position - baseplate4.Position).Magnitude > 45 then
    return false, "Too far from plot baseplate"
  else
    local petAging = replicatedStorage:FindFirstChild("GameServices")
      and replicatedStorage.GameServices:FindFirstChild("PetAging")

    local pets = replicatedStorage:FindFirstChild("GameData")
      and replicatedStorage.GameData:FindFirstChild("Pets")

    local mutations = replicatedStorage:FindFirstChild("GameData")
      and replicatedStorage.GameData:FindFirstChild("Mutations")

    local playerScripts = localPlayer2:FindFirstChild("PlayerScripts")
    local v258 = playerScripts and playerScripts:FindFirstChild("Game")
    local pets2 = v258 and v258:FindFirstChild("Pets")
    local petRenderer = pets2 and pets2:FindFirstChild("PetRenderer")
    local v259 = petAging and f3(petAging, "PetAging", {}) or {}
    local v260 = pets and f3(pets, "Pets", {}) or {}
    local v261 = mutations and f3(mutations, "Mutations", {}) or {}
    v257 = petRenderer and f3(petRenderer, "PetRenderer", {}) or {}

    local v262 = replicatedStorage:FindFirstChild("Remotes")
      and replicatedStorage.Remotes:FindFirstChild("Game")

    local placePet = v262 and v262:FindFirstChild("PlacePet")
    local pickupPet = v262 and v262:FindFirstChild("PickupPet")

    if not (placePet and pickupPet) then
      return false, "Place/Pickup remotes not found"
    else
      local v263 = {}

      if v257 and v257.GetAll then
        for key9, value67 in pairs(v257.GetAll()) do
          if value67.OwnerUserId == localPlayer2.UserId and value67.Model
            and value67.Model.Parent then
            local v264 = tonumber(value67.Model:GetAttribute("Age")) or 1
            local v265 = tonumber(value67.Model:GetAttribute("Weight")) or 1
            local petName3 = value67.Model:GetAttribute("PetName") or value67.Model.Name
            local v266 = v260 and v260[petName3] and tonumber(v260[petName3].Income) or 0
            local mutation3 = value67.Model:GetAttribute("Mutation")
            local spawnMutation = value67.Model:GetAttribute("SpawnMutation")

            local combinedFactor = v261 and v261.CombinedFactor
                and v261.CombinedFactor(mutation3, spawnMutation)
              or 1

            local multiplierFor = v259 and v259.MultiplierFor and v259.MultiplierFor(v264) or 1

            if multiplierFor <= 0 then
              multiplierFor = 1
            end

            local v267 = v265 / multiplierFor
            local maxAge = v259 and v259.MaxAge or 100

            local v268 = v267
              * (v259 and v259.MultiplierFor and v259.MultiplierFor(maxAge) or 1.99)

            local weightStandardKG = v259 and v259.WeightStandardKG or 10
            local v269 = math.floor(v266 * (v265 / weightStandardKG))
            local v270 = math.floor(v269 * combinedFactor)
            local v271 = math.floor(v266 * (v268 / weightStandardKG))
            local v272 = math.floor(v271 * combinedFactor)
            local model = value67.Model

            table.insert(v263, {
              Key = value67.PetKey,
              Name = petName3,
              Placed = true,
              Age = v264,
              CurWeight = v265,
              BaseWeight = v267,
              CurIncome = v270,
              MaxIncome = v272,
              Position = model:GetPivot().Position,
            })
          end
        end
      end

      if localPlayer2:FindFirstChild("Backpack") then
        for index57, value68 in ipairs(localPlayer2.Backpack:GetChildren()) do
          if value68:IsA("Tool") and value68:HasTag("Pet") and value68:GetAttribute("PetKey") then
            local v273 = tonumber(value68:GetAttribute("Age")) or 1
            local v274 = tonumber(value68:GetAttribute("Weight")) or 1
            local petName4 = value68:GetAttribute("PetName") or value68.Name
            local v275 = v260 and v260[petName4] and tonumber(v260[petName4].Income) or 0
            local mutation4 = value68:GetAttribute("Mutation")
            local combinedFactor2 = v261
            local spawnMutation2 = value68:GetAttribute("SpawnMutation")

            if v261 then
              combinedFactor2 = v261.CombinedFactor
                and v261.CombinedFactor(mutation4, spawnMutation2)
            end

            local v276 = combinedFactor2 or 1
            local multiplierFor2 = v259 and v259.MultiplierFor and v259.MultiplierFor(v273) or 1

            if multiplierFor2 <= 0 then
              multiplierFor2 = 1
            end

            local v277 = v274 / multiplierFor2
            local maxAge2 = v259 and v259.MaxAge or 100

            local v278 = v277
              * (v259 and v259.MultiplierFor and v259.MultiplierFor(maxAge2) or 1.99)

            local weightStandardKG2 = v259 and v259.WeightStandardKG or 10
            local v279 = math.floor(v275 * (v274 / weightStandardKG2))
            local v280 = math.floor(v279 * v276)
            local v281 = math.floor(v275 * (v278 / weightStandardKG2))
            local v282 = math.floor(v281 * v276)

            table.insert(v263, {
              Key = value68:GetAttribute("PetKey"),
              Name = petName4,
              Placed = false,
              Age = v273,
              CurWeight = v274,
              BaseWeight = v277,
              CurIncome = v280,
              MaxIncome = v282,
              Tool = value68,
            })
          end
        end
      end

      if #v263 == 0 then
        return false, "No pets found"
      else
        bestPetsStrategy = p66 or roxyHubState.BestPetsStrategy
          or "Smart Potential (Lv 100 Max Income)"

        table.sort(v263, function(p67, p68)
          if bestPetsStrategy == "Current Cash/s (Game Default)" then
            if p67.CurIncome ~= p68.CurIncome then
              return p67.CurIncome > p68.CurIncome
            end

            return p67.MaxIncome > p68.MaxIncome
          end

          if p67.MaxIncome ~= p68.MaxIncome then
            return p67.MaxIncome > p68.MaxIncome
          end

          return p67.BaseWeight > p68.BaseWeight
        end)

        local maxPets = localPlayer2:GetAttribute("MaxPets")
        local v283 = math.min(maxPets or 5, #v263)
        local v284 = {}
        local count4 = 0

        while true do
          count4 = 1 + count4

          if not (v283 >= count4) then
            break
          end

          v284[v263[count4].Key] = true
        end

        local v285 = {}
        local count5 = 0

        for index58, value69 in ipairs(v263) do
          local v286 = value69

          if v286.Placed and not v284[v286.Key] then
            if v286.Position then
              table.insert(v285, v286.Position)
            end

            pcall(function() v257.Remove(localPlayer2.UserId, v286.Key) end)
            pickupPet:FireServer(v286.Key)
            count5 = count5 + 1
            task.wait(0.2)
          end
        end

        local count6 = 0

        local function f44(p69)
          local v287 = math.floor((p69 - 1) / 3)
          local cframe6 = CFrame.new(((p69 - 1) % 3 - 1) * 4, 0, -(v287 * 4 + 8))
          local pointToObjectSpace = baseplate4.CFrame:PointToObjectSpace((v254.CFrame * cframe6).Position)
          local v288 = baseplate4.Size.X / 2 - 3
          local v289 = baseplate4.Size.Z / 2 - 3
          local v290 = math.clamp(pointToObjectSpace.X, -v288, v288)
          local v291 = math.clamp(pointToObjectSpace.Z, -v289, v289)

          return baseplate4.CFrame:PointToWorldSpace(Vector3.new(
            v290, pointToObjectSpace.Y, v291
          ))
        end

        for j = 1, v283 do
          local v292 = v263[j]

          if not v292.Placed then
            local tool = v292.Tool

            if not tool or tool.Parent ~= localPlayer2.Backpack then
              for index59, value70 in ipairs(localPlayer2.Backpack:GetChildren()) do
                if value70:IsA("Tool") and value70:GetAttribute("PetKey") == v292.Key then
                  tool = value70
                  break
                end
              end
            end

            if tool then
              v255:EquipTool(tool)
              local v293 = os.clock()

              while tool.Parent ~= v253 and os.clock() - v293 < 1 do
                task.wait(0.05)
              end

              if tool.Parent == v253 then
                local v294 = table.remove(v285, 1) or f44(j)
                placePet:FireServer(v292.Key, v294)
                count6 = count6 + 1
                task.wait(0.25)
              end
            end
          end
        end

        if v255 and localPlayer2:GetAttribute("IsRiding") ~= true then
          pcall(function() v255:UnequipTools() end)
        end

        return true, string.format(
          "Optimized %d placed, %d picked up (%s)", count6, count5, bestPetsStrategy
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
      pcall(function() f43(roxyHubState.BestPetsStrategy) end)
    end
  end
end)

local function f45(p70)
  local v295 = f13()
  local v296, v297, v298 = f12()
  local v299 = v295 and v296 and v297 and v298
  local v300, feedTargetMode

  if not v299 then
    return false, "Character or plot missing"
  elseif v35.IsFarming then
    return false, "Cannot feed while farming is active"
  else
    local petAging2 = replicatedStorage:FindFirstChild("GameServices")
      and replicatedStorage.GameServices:FindFirstChild("PetAging")

    local pets3 = replicatedStorage:FindFirstChild("GameData")
      and replicatedStorage.GameData:FindFirstChild("Pets")

    local mutations2 = replicatedStorage:FindFirstChild("GameData")
      and replicatedStorage.GameData:FindFirstChild("Mutations")

    local playerScripts2 = localPlayer2:FindFirstChild("PlayerScripts")
    local v301 = playerScripts2 and playerScripts2:FindFirstChild("Game")
    local pets4 = v301 and v301:FindFirstChild("Pets")
    local petRenderer2 = pets4 and pets4:FindFirstChild("PetRenderer")

    local foods = replicatedStorage:FindFirstChild("GameData")
      and replicatedStorage.GameData:FindFirstChild("Foods")

    local v302 = petAging2 and f3(petAging2, "PetAging", {}) or {}
    local v303 = pets3 and f3(pets3, "Pets", {}) or {}
    local v304 = mutations2 and f3(mutations2, "Mutations", {}) or {}
    local v305 = petRenderer2 and f3(petRenderer2, "PetRenderer", {}) or {}
    v300 = foods and f3(foods, "Foods", {}) or {}

    local v306 = replicatedStorage:FindFirstChild("Remotes")
      and replicatedStorage.Remotes:FindFirstChild("Game")

    local feedPet = v306 and v306:FindFirstChild("FeedPet")
      or replicatedStorage:FindFirstChild("FeedPet", true)

    if not feedPet then
      return false, "FeedPet remote not found"
    else
      local v307 = {}
      local maxAge3 = v302 and v302.MaxAge
      local multiplierFor3 = v302
      local v308 = maxAge3 or 100

      if v302 then
        multiplierFor3 = v302.MultiplierFor and v302.MultiplierFor(v308)
      end

      local v309 = multiplierFor3 or 1.99
      local weightStandardKG3 = v302 and v302.WeightStandardKG or 10

      if v305 and v305.GetAll then
        for key10, value71 in pairs(v305.GetAll()) do
          if value71.OwnerUserId == localPlayer2.UserId and value71.Model
            and value71.Model.Parent and value71.Model.PrimaryPart then
            local v310 = tonumber(value71.Model:GetAttribute("Age")) or 1
            local v311 = tonumber(value71.Model:GetAttribute("Weight")) or 1
            local petName5 = value71.Model:GetAttribute("PetName") or value71.Model.Name
            local v312 = v303 and v303[petName5] and tonumber(v303[petName5].Income) or 0
            local mutation5 = value71.Model:GetAttribute("Mutation")
            local model2 = value71.Model
            local combinedFactor3 = v304
            local spawnMutation3 = model2:GetAttribute("SpawnMutation")

            if v304 then
              combinedFactor3 = v304.CombinedFactor
                and v304.CombinedFactor(mutation5, spawnMutation3)
            end

            local v313 = combinedFactor3 or 1
            local multiplierFor4 = v302 and v302.MultiplierFor and v302.MultiplierFor(v310) or 1

            if multiplierFor4 <= 0 then
              multiplierFor4 = 1
            end

            local v314 = v311 / multiplierFor4
            local v315 = math.floor(math.floor(v312 * (v311 / weightStandardKG3)) * v313)
            local v316 = math.floor(math.floor(v312 * (v314 * v309 / weightStandardKG3)) * v313)

            table.insert(v307, {
              PetKey = value71.PetKey,
              Name = petName5,
              Model = value71.Model,
              PrimaryPart = value71.Model.PrimaryPart,
              Age = v310,
              CurWeight = v311,
              BaseWeight = v314,
              CurIncome = v315,
              MaxIncome = v316,
              Headroom = v316 - v315,
            })
          end
        end
      end

      if #v307 == 0 and v295:FindFirstChild("Pets") then
        for index60, value72 in ipairs(v295.Pets:GetChildren()) do
          if value72:IsA("Model") and value72.PrimaryPart then
            local ownerUserId = value72:GetAttribute("OwnerUserId")

            local owner2 = ownerUserId
            owner2 = ownerUserId or value72:GetAttribute("Owner")

            if owner2 == localPlayer2.UserId
              or tostring(owner2) == tostring(localPlayer2.UserId)
              or v295:GetAttribute("NestsOwnerLoaded") == localPlayer2.UserId
              or v295.Name == tostring(localPlayer2.UserId) then
              local petKey4 = value72:GetAttribute("PetKey") or value72.Name
              local v317 = tonumber(value72:GetAttribute("Age")) or 1
              local v318 = tonumber(value72:GetAttribute("Weight")) or 1
              local petName6 = value72:GetAttribute("PetName") or value72.Name
              local v319 = v303 and v303[petName6] and tonumber(v303[petName6].Income) or 0
              local mutation6 = value72:GetAttribute("Mutation")
              local combinedFactor4 = v304
              local spawnMutation4 = value72:GetAttribute("SpawnMutation")

              if v304 then
                combinedFactor4 = v304.CombinedFactor
                  and v304.CombinedFactor(mutation6, spawnMutation4)
              end

              local v320 = combinedFactor4 or 1

              local multiplierFor5 = v302 and v302.MultiplierFor and v302.MultiplierFor(v317)
                or 1

              if multiplierFor5 <= 0 then
                multiplierFor5 = 1
              end

              local v321 = v318 / multiplierFor5
              local v322 = math.floor(math.floor(v319 * (v318 / weightStandardKG3)) * v320)
              local v323 = math.floor(math.floor(v319 * (v321 * v309 / weightStandardKG3)) * v320)

              table.insert(v307, {
                PetKey = petKey4,
                Name = petName6,
                Model = value72,
                PrimaryPart = value72.PrimaryPart,
                Age = v317,
                CurWeight = v318,
                BaseWeight = v321,
                CurIncome = v322,
                MaxIncome = v323,
                Headroom = v323 - v322,
              })
            end
          end
        end
      end

      if #v307 == 0 then
        return false, "No placed pets found on plot"
      else
        local v324 = {}

        if (roxyHubState.FeedTargetMode == "Selected Pet Only"
            or roxyHubState.FeedTargetMode == nil)
          and roxyHubState.SelectedPetKey then
          for index61, value73 in ipairs(v307) do
            if value73.PetKey == roxyHubState.SelectedPetKey then
              if roxyHubState.FeedSkipMaxAge == false or value73.Age < v308 then
                table.insert(v324, value73)
              end

              break
            end
          end
        end

        if #v324 == 0 then
          for index62, value74 in ipairs(v307) do
            local v325 = true

            if roxyHubState.FeedSkipMaxAge ~= false and value74.Age >= v308 then
              v325 = false
            end

            if v325 and roxyHubState.FeedAllPets == false
              and type(roxyHubState.FeedPetList) == "table" then
              local v326 = false

              for key11, value75 in pairs(roxyHubState.FeedPetList) do
                if type(key11) == "number"
                    and (value75 == value74.Name or value75 == value74.PetKey)
                  or type(key11) == "string"
                    and (key11 == value74.Name or key11 == value74.PetKey) and value75 == true then
                  v326 = true
                  break
                end
              end

              if not v326 then
                v325 = false
              end
            end

            if v325 then
              table.insert(v324, value74)
            end
          end

          if #v324 == 0 then
            return false, roxyHubState.FeedSkipMaxAge ~= false
                and "All placed pets are already max level (Age 100)"
              or "No matching pets selected"
          end

          feedTargetMode = roxyHubState.FeedTargetMode or roxyHubState.FeedPriorityMode
            or "Smart Priority (Highest Headroom)"

          table.sort(v324, function(p71, p72)
            if feedTargetMode == "Highest Max Income (VIP First)" then
              if p71.MaxIncome ~= p72.MaxIncome then
                return p71.MaxIncome > p72.MaxIncome
              end

              return p71.Headroom > p72.Headroom
            elseif feedTargetMode == "Lowest Level First (Balance Ages)" then
              if p71.Age ~= p72.Age then
                return p71.Age < p72.Age
              end

              return p71.Headroom > p72.Headroom
            elseif p71.Headroom ~= p72.Headroom then
              return p71.Headroom > p72.Headroom
            else
              if p71.MaxIncome ~= p72.MaxIncome then
                return p71.MaxIncome > p72.MaxIncome
              end

              return p71.BaseWeight > p72.BaseWeight
            end
          end)
        end

        local function f46()
          local v327 = {}

          for index63, value76 in ipairs({
            localPlayer2.Character, localPlayer2:FindFirstChild("Backpack"),
          }) do
            if value76 then
              for index64, value77 in ipairs(value76:GetChildren()) do
                if value77:IsA("Tool") and not value77:HasTag("Pet")
                  and not value77:HasTag("Egg") and not value77:HasTag("Radar") then
                  if value77:HasTag("Food") or v300 and v300[value77.Name] ~= nil then
                    local v328 = v300 and v300[value77.Name] or {}
                    local v329 = v328.NoFeedAll == true

                    local v330 = v329

                    v330 = v329 or value77.Name == "Dragonfruit"
                      or value77.Name == "Magic Apple"

                    local v331 = roxyHubState.FeedAllowPremiumFood ~= false
                    local v332 = true

                    if v330 and not v331 then
                      v332 = false
                    end

                    if roxyHubState.FeedFoodSelection
                      and roxyHubState.FeedFoodSelection ~= "All Foods"
                      and value77.Name ~= roxyHubState.FeedFoodSelection then
                      v332 = false
                    end

                    local v333 = 1
                    local data2 = value77:FindFirstChild("Data")

                    if data2 and data2:FindFirstChild("Amount") then
                      v333 = tonumber(data2.Amount.Value) or 0
                    end

                    if v332 and v333 > 0 then
                      table.insert(v327, {
                        Tool = value77,
                        Name = value77.Name,
                        XP = tonumber(v328.XP) or 0,
                        Amount = v333,
                      })
                    end
                  end
                end
              end
            end
          end

          table.sort(v327, function(p73, p74) return p73.XP > p74.XP end)
          return v327
        end

        local v334 = f46()

        if #v334 == 0 then
          return false, "No valid food items available in backpack"
        else
          local v335 = v324[1]
          local v336 = v334[1]
          local tool2 = v336.Tool

          if tool2.Parent ~= localPlayer2.Character and v298 then
            v298:EquipTool(tool2)
            local v337 = os.clock()

            while tool2.Parent ~= localPlayer2.Character and os.clock() - v337 < 0.8 do
              task.wait(0.05)
            end
          end

          if tool2.Parent ~= localPlayer2.Character then
            return false, "Failed to equip food tool " .. tostring(v336.Name)
          else
            local cframe7 = nil
            local primaryPart = v335.PrimaryPart

            local basePart = primaryPart
            basePart = primaryPart or v335.Model:FindFirstChildWhichIsA("BasePart")

            if basePart and v297 then
              if (v297.Position - basePart.Position).Magnitude > 7 and not v35.IsFarming then
                cframe7 = v297.CFrame
                v297.CFrame = basePart.CFrame * CFrame.new(0, 1, 3.5)
                task.wait(0.1)
              end
            end

            local feed = basePart
              and (basePart:FindFirstChild("Feed") or v335.Model:FindFirstChild("Feed", true))

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

            feedPet:FireServer(v335.PetKey, v336.Name)
            task.wait(0.4)
            local v338 = 1

            if p70 then
              local v339 = 1

              while true do
                v339 = 1 + v339

                if not (5 >= v339) then
                  break
                end

                local age = tonumber(v335.Model:GetAttribute("Age")) or v335.Age

                if roxyHubState.FeedSkipMaxAge ~= false and age >= v308 then
                  break
                else
                  local data3 = tool2:FindFirstChild("Data")

                  if (data3 and data3:FindFirstChild("Amount") and tonumber(data3.Amount.Value)
                      or 0)
                    <= 0 then
                    break
                  end

                  feedPet:FireServer(v335.PetKey, v336.Name)
                  v338 = v338 + 1
                  task.wait(0.4)
                end
              end
            end

            if cframe7 and v297 and v297.Parent then
              v297.CFrame = cframe7
            end

            return true, string.format(
              "Fed %d %s to %s (Age %s)", v338, v336.Name, v335.Name,
              tostring(v335.Model:GetAttribute("Age") or v335.Age)
            )
          end
        end
      end
    end
  end
end

task.spawn(function()
  while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
    if roxyHubState.AutoFeedPets and not v35.IsFarming then
      pcall(function() f45(false) end)
      task.wait(0.1)
    else
      task.wait(0.5)
    end
  end
end)

task.spawn(function()
  local function f47(p75)
    if not p75 then
      return
    end

    for index65, value78 in ipairs(p75:GetChildren()) do
      local v340 = value78

      if v340:IsA("GuiObject") and v340.Name:find("-") then
        local petHolder = v340:FindFirstChild("PetHolder") or v340

        if petHolder and not v340:GetAttribute("RoxyHooked") then
          v340:SetAttribute("RoxyHooked", true)

          petHolder.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
              or input.UserInputType == Enum.UserInputType.Touch then
              roxyHubState.SelectedPetKey = v340.Name
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
        f47(holder4)
      end
    end)

    task.wait(2)
  end
end)

local v341

pcall(function()
  if isfile and readfile and isfile("WindUI_Cache.lua") then
    local windUICacheLua = readfile("WindUI_Cache.lua")

    if windUICacheLua and #windUICacheLua > 5000 then
      v341 = windUICacheLua
    end
  end
end)

if not v341 then
  local v342, v343 = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")
  end)

  if v342 and v343 and #v343 > 5000 then
    v341 = v343

    if writefile then
      pcall(function() writefile("WindUI_Cache.lua", v341) end)
    end
  end
end

if not v341 then
  error("[RoxyHub] Failed to load WindUI engine. Check connection or WindUI_Cache.lua.", 0)
end

local v344, v345 = loadstring(v341)

if not v344 then
  error("[RoxyHub] WindUI compile failed: " .. tostring(v345), 0)
end

local v346, v347 = pcall(v344)

if not v346 or type(v347) ~= "table" then
  error("[RoxyHub] WindUI initialization failed: " .. tostring(v347), 0)
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

local function f48(p76)
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

  local v348 = false
  local v349 = 0
  local v350 = false
  local position10, position11

  local function f49(p77)
    local v351 = p77.Position - position11

    local viewportSize = workspaceService.CurrentCamera
        and workspaceService.CurrentCamera.ViewportSize
      or Vector2.new(1920, 1080)

    local v352 = math.clamp(position10.X.Offset + v351.X, 5, viewportSize.X - 61)
    local v353 = math.clamp(position10.Y.Offset + v351.Y, 5, viewportSize.Y - 61)
    roxyToggleBtn.Position = UDim2.new(0, v352, 0, v353)
  end

  roxyToggleBtn.InputBegan:Connect(function(input2)
    if input2.UserInputType == Enum.UserInputType.MouseButton1
      or input2.UserInputType == Enum.UserInputType.Touch then
      v348 = true
      v350 = false
      position10 = roxyToggleBtn.Position
      position11 = input2.Position
      v349 = tick()

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
          v348 = false
        end
      end)
    end
  end)

  roxyToggleBtn.InputChanged:Connect(function(input3)
    if v348
      and (input3.UserInputType == Enum.UserInputType.MouseMovement
        or input3.UserInputType == Enum.UserInputType.Touch) then
      if (input3.Position - position11).Magnitude > 6 then
        v350 = true
      end

      if v350 then
        f49(input3)
      end
    end
  end)

  roxyToggleBtn.InputEnded:Connect(function(input4)
    if input4.UserInputType == Enum.UserInputType.MouseButton1
      or input4.UserInputType == Enum.UserInputType.Touch then
      v348 = false

      tweenService:Create(
        roxyToggleBtn, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 56, 0, 56) }
      ):Play()

      tweenService:Create(uiStroke, TweenInfo.new(0.15), {
        Color = Color3.fromHex("#38BDF8"),
        Thickness = 2.5,
      }):Play()

      local v354 = tick() - v349
      local magnitude5 = (input4.Position - (position11 or input4.Position)).Magnitude

      if not v350 and magnitude5 < 10 and v354 < 0.35 then
        pcall(function()
          if v2 then
            f1()
          end

          if p76.Closed then
            p76:Open()
          else
            p76:Close()
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

-- ============================================================
-- Register the "RoxyHub" theme (it was never registered before, which is
-- what caused: attempt to index nil with 'PanelBackground')
-- ============================================================
local roxyThemeName = "Dark"
local window

do
  local base = {}

  pcall(function()
    local themes = v347.GetThemes and v347:GetThemes() or v347.Themes

    if type(themes) == "table" and type(themes.Dark) == "table" then
      for key, value in pairs(themes.Dark) do
        base[key] = value
      end
    end
  end)

  local hadBase = next(base) ~= nil

  local colors = {
    Accent = "#3B82F6", Dialog = "#0F172A", Outline = "#1E3A8A", Text = "#F8FAFC",
    Placeholder = "#94A3B8", Background = "#0B0F19", Button = "#1E293B", Icon = "#60A5FA",
    Hover = "#F8FAFC", WindowBackground = "#0B0F19", WindowShadow = "#000000",
    DialogBackground = "#0F172A", DialogTitle = "#F8FAFC", DialogContent = "#94A3B8",
    DialogIcon = "#60A5FA", WindowTopbarButtonIcon = "#60A5FA", WindowTopbarTitle = "#F8FAFC",
    WindowTopbarAuthor = "#94A3B8", WindowTopbarIcon = "#60A5FA", TabBackground = "#1E293B",
    TabTitle = "#F8FAFC", TabIcon = "#60A5FA", ElementBackground = "#1E293B",
    ElementTitle = "#F8FAFC", ElementDesc = "#94A3B8", ElementIcon = "#60A5FA",
    PopupBackground = "#0F172A", PopupTitle = "#F8FAFC", PopupContent = "#94A3B8",
    PopupIcon = "#60A5FA", Toggle = "#2563EB", ToggleBar = "#F8FAFC", Checkbox = "#2563EB",
    CheckboxIcon = "#F8FAFC", Slider = "#2563EB", SliderThumb = "#F8FAFC",
    Tooltip = "#1E293B", TooltipText = "#F8FAFC", TooltipSecondary = "#0F172A",
    TooltipSecondaryText = "#94A3B8", PanelBackground = "#1E293B",
  }

  local numbers = {
    BackgroundTransparency = 0, DialogBackgroundTransparency = 0,
    PopupBackgroundTransparency = 0, PanelBackgroundTransparency = 0.5,
  }

  for key, hex in pairs(colors) do
    -- keep the key set of the library's own Dark theme, only recolour it
    if not hadBase or typeof(base[key]) == "Color3" or base[key] == nil and key == "PanelBackground" then
      pcall(function() base[key] = Color3.fromHex(hex) end)
    end
  end

  if not hadBase then
    for key, value in pairs(numbers) do
      base[key] = value
    end
  elseif base.PanelBackgroundTransparency == nil then
    base.PanelBackgroundTransparency = numbers.PanelBackgroundTransparency
  end

  base.Name = "RoxyHub"

  local addOk = pcall(function() v347:AddTheme(base) end)
  local registered = true

  pcall(function()
    local themes = v347.GetThemes and v347:GetThemes() or v347.Themes

    if type(themes) == "table" then
      registered = themes.RoxyHub ~= nil
    end
  end)

  if addOk and registered then
    roxyThemeName = "RoxyHub"
  else
    warn("[RoxyHub] Could not register custom theme, falling back to Dark")
  end

  local function openWindow(themeName)
    return pcall(function()
      return v347:CreateWindow({
        Title = "Ride A Pet",
        Icon = "rbxassetid://85047195026655",
        IconSize = 44,
        Author = "by RoxyHub",
        Folder = "RoxyHub_RideAPet",
        Size = UDim2.fromOffset(620, 510),
        Transparent = true,
        Theme = themeName,
        Resizable = true,
        OpenButton = { Enabled = false },
      })
    end)
  end

  local ok, result = openWindow(roxyThemeName)

  if not ok and roxyThemeName ~= "Dark" then
    warn("[RoxyHub] CreateWindow failed with RoxyHub theme: " .. tostring(result))
    roxyThemeName = "Dark"
    ok, result = openWindow("Dark")
  end

  if not ok or not result then
    f1()
    error("[RoxyHub] CreateWindow failed: " .. tostring(result), 0)
  end

  window = result
end

_G.RoxyHubInstance = window

pcall(function()
  if window and window.UIElements and window.UIElements.Main and window.UIElements.Main.Main then
    for index66, value79 in ipairs(window.UIElements.Main.Main.Topbar.Left:GetChildren()) do
      if value79:IsA("Frame") and value79.Name == "Frame" then
        value79.Size = UDim2.new(0, 44, 0, 44)

        for index67, value80 in ipairs(value79:GetChildren()) do
          if value80:IsA("Frame") then
            value80.Size = UDim2.new(0, 44, 0, 44)
            value80.AnchorPoint = Vector2.new(0.5, 0.5)
            value80.Position = UDim2.new(0.5, 0, 0.5, 0)
          end
        end
      end
    end
  end
end)

local v355 = f48(window)
window:Tag({ Title = "Free", Color = Color3.fromHex("#1E3A8A"), Border = true })
local infoTab = window:Tab({ Title = "Info", Icon = "info" })
local autoFarmTab = window:Tab({ Title = "Auto Farm", Icon = "flame" })
local eventTab = window:Tab({ Title = "Event", Icon = "zap" })
local plotPetsTab = window:Tab({ Title = "Plot & Pets", Icon = "box" })
local eggESPTab = window:Tab({ Title = "Egg ESP", Icon = "eye" })
local teleportsTab = window:Tab({ Title = "Teleports", Icon = "navigation" })
local playerTab = window:Tab({ Title = "Player", Icon = "user" })
local settingsTab = window:Tab({ Title = "Settings", Icon = "settings" })

local function f50(p78, p79, p80)
  local v356 = os.clock()
  f2(0.76, "Building " .. p79 .. " tab...")

  local v357, v358 = xpcall(p80, function(p81)
    if debug and debug.traceback then
      return debug.traceback(tostring(p81), 2)
    end

    return tostring(p81)
  end)

  if not v357 then
    warn(string.format("[RoxyHub %s Error]: %s", p79, tostring(v358)))

    pcall(function()
      p78:Section({ Title = p79 .. " Status", Opened = true }):Paragraph({
        Title = "Initialization Notice",
        Desc = string.sub(tostring(v358), 1, 180),
      })

      if v347 and v347.Notify then
        v347:Notify({
          Title = p79 .. " Status",
          Content = string.sub(tostring(v358), 1, 80),
          Duration = 6,
          Icon = "alert-triangle",
        })
      end
    end)
  else
    print(string.format("[RoxyHub] %s tab built in %.2fs", p79, os.clock() - v356))
  end

  task.wait()
end

local v359 = {}

f50(infoTab, "Info", function()
  infoTab:Section({ Title = "Script Information", Opened = true }):Paragraph({
    Title = "RoxyHub | Ride a Pet",
    Desc = "Version: v1.2.0 [Release]",
  })

  local section = infoTab:Section({ Title = "Latest Patch Notes", Opened = true })

  section:Paragraph({
    Title = "v1.2.0 - Fusion & Volcano Overhaul",
    Desc = [[
- Added Event Tab: Auto Fuse Machine with Rarity & Multi-Select Filters
- Added Real-time Fuse Monitor (Countdown & Slots)
- Fixed Auto Magma Lava Dip (Volcanic Egg support + Retry Handshake)
- Fixed Egg Delivery & Hatching deadlocks]],
  })

  section:Paragraph({
    Title = "Keybinds & Controls",
    Desc = [[
Toggle Menu: RightShift (Configurable in Settings)
Mobile Button: Draggable floating widget]],
  })
end)

task.wait()

f50(autoFarmTab, "Auto Farm", function()
  local section2 = autoFarmTab:Section({ Title = "Farm Realtime Monitor", Opened = true })

  local function f51()
    local v360 = ""

    if v35.TargetWeight and v35.TargetWeight > 0 then
      v360 = " | " .. f21(v35.TargetWeight)
    end

    return string.format([[
Target: %s [%s]%s
Collected: %d eggs
Mode: %s | Sync Delay: %.2fs]], tostring(v35.Target or "None"), tostring(v35.TargetRarity or "None"), v360, tonumber(v35.CollectedCount or 0), tostring(roxyHubState.FarmMode or "Safe Tween"), tonumber(roxyHubState.SyncDelay or 0.35))
  end

  local paragraph = section2:Paragraph({
    Title = "Status: " .. tostring(v35.Status or "Idle"),
    Desc = f51(),
  })

  task.spawn(function()
    while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
      task.wait(0.3)
    end
  end)

  task.spawn(function()
    local v361

    while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
      task.wait(1.5)
      local serverData3 = replicatedStorage:FindFirstChild("ServerData")
      local activeWeathers2 = serverData3 and serverData3:GetAttribute("ActiveWeathers")

      if activeWeathers2 and activeWeathers2 ~= "" and activeWeathers2 ~= "[]" then
        local v362, v363 = pcall(function() return httpService:JSONDecode(activeWeathers2) end)

        if v362 and type(v363) == "table" and #v363 > 0 then
          local v364 = false
          local getServerTimeNow4 = workspaceService:GetServerTimeNow()

          for index68, value81 in ipairs(v363) do
            if not value81.EndsAt or value81.EndsAt > getServerTimeNow4 then
              v364 = true

              local v365 = (value81.Type or "Weather") .. ":"
                .. tostring(value81.Variant or value81.Name or "Event")

              if v365 ~= v361 then
                v361 = v365

                if roxyHubState.WeatherNotify and v347 and v347.Notify then
                  local v366 = value81.EndsAt
                      and math.max(0, math.floor(value81.EndsAt - getServerTimeNow4))
                    or 0

                  if value81.Type == "Storm" and value81.Variant then
                  else
                    local variant = value81.Variant or value81.Name or value81.Type
                      or "Special Event"

                    local description = value81.Description
                      or "Special weather event is now active!"

                    pcall(function()
                      v347:Notify({
                        Title = "EVENT ALERT: " .. string.upper(variant),
                        Content = string.format("%s (%ds remaining)", description, v366),
                        Duration = 6,
                        Icon = "sparkles",
                      })
                    end)
                  end
                end
              end

              break
            end
          end

          if not v364 then
            v361 = nil
          end
        else
          v361 = nil
        end
      else
        v361 = nil
      end
    end
  end)

  local section3 = autoFarmTab:Section({ Title = "Auto Farm Controls", Opened = true })

  v359.AutoFarm = section3:Toggle({
    Title = "Master Auto Farm",
    Value = roxyHubState.AutoFarm,
    Callback = function(value82) roxyHubState.AutoFarm = value82 end,
  })

  v359.FarmMode = section3:Dropdown({
    Title = "Farm Mode",
    Values = { "Safe Tween", "Instant" },
    Value = roxyHubState.FarmMode or "Instant",
    Callback = function(value83) roxyHubState.FarmMode = value83 end,
  })

  v359.MinFarmRarity = section3:Dropdown({
    Title = "Minimum Egg Rarity",
    Values = {
      "All Eggs", "Rare & Above", "Epic & Above", "Legendary & Above", "Mythic & Above",
      "Divine & Above", "Ethereal Only",
    },
    Value = roxyHubState.MinFarmRarity,
    Callback = function(value84) f10(value84) end,
  })

  v359.TargetSpecificEgg = section3:Dropdown({
    Title = "Target Specific Egg",
    Values = values,
    Value = roxyHubState.TargetSpecificEgg,
    Callback = function(value85) roxyHubState.TargetSpecificEgg = value85 end,
  })

  v359.FarmPriority = section3:Dropdown({
    Title = "Target Priority Order",
    Values = {
      "Highest Rarity First", "Closest Distance First", "Highest Luck First",
      "Heaviest Weight First",
    },
    Value = roxyHubState.FarmPriority,
    Callback = function(value86) roxyHubState.FarmPriority = value86 end,
  })

  v359.PrioritizeHeaviest = section3:Toggle({
    Title = "Prioritize Heaviest Eggs",
    Value = roxyHubState.PrioritizeHeaviest or false,
    Callback = function(value87) roxyHubState.PrioritizeHeaviest = value87 end,
  })

  v359.MinEggWeight = section3:Slider({
    Title = "Minimum Egg Weight (KG)",
    Step = 10,
    Value = { Min = 0, Max = 10000, Default = roxyHubState.MinEggWeight or 0 },
    Callback = function(value88) roxyHubState.MinEggWeight = tonumber(value88) or 0 end,
  })

  local section4 = autoFarmTab:Section({ Title = "Weather & Mutation Sniper", Opened = true })

  v359.PrioritizeMutations = section4:Toggle({
    Title = "Prioritize Mutated Eggs",
    Value = roxyHubState.PrioritizeMutations,
    Callback = function(value89) roxyHubState.PrioritizeMutations = value89 end,
  })

  v359.WeatherEggWait = section4:Toggle({
    Title = "Wait for Storm Mutations",
    Value = roxyHubState.WeatherEggWait,
    Callback = function(value90) roxyHubState.WeatherEggWait = value90 end,
  })

  v359.MinMutationTier = section4:Dropdown({
    Title = "Minimum Mutation Tier",
    Values = {
      "All Mutations (Shocked+)", "Volted & Above (3x+)", "Rage & Above (4x+)",
      "Void & Above (10x+)", "Magma & Above (10x+)", "Eternal Only (100x)",
    },
    Value = roxyHubState.MinMutationTier or "All Mutations (Shocked+)",
    Callback = function(value91) roxyHubState.MinMutationTier = value91 end,
  })

  v359.WeatherNotify = section4:Toggle({
    Title = "Weather Storm Alerts",
    Value = roxyHubState.WeatherNotify,
    Callback = function(value92) roxyHubState.WeatherNotify = value92 end,
  })

  v359.AutoMagmaDip = section4:Toggle({
    Title = "Auto Magma Lava Dip (10x)",
    Value = roxyHubState.AutoMagmaDip,
    Callback = function(value93) roxyHubState.AutoMagmaDip = value93 end,
  })

  local section5 = autoFarmTab:Section({ Title = "Smart Auto Rebirth Engine", Opened = true })
  local v367
  local title = v367 or "Rebirth: In Progress"
  local v368
  section5:Paragraph({ Title = title, Desc = v368 or "Auto Rebirth: Initialized" })

  task.defer(function() end)

  task.spawn(function()
    while not (_G.RoxyHubInstanceId ~= roxyHubInstanceId) do
      task.wait(0.5)
    end
  end)

  v359.AutoRebirth = section5:Toggle({
    Title = "Master Auto Rebirth",
    Value = roxyHubState.AutoRebirth,
    Callback = function(value94)
      roxyHubState.AutoRebirth = value94

      if value94 then
        roxyHubState.AutoHatchPlot = true
        roxyHubState.AutoPlaceNest = true
      end
    end,
  })

  v359.PrioritizeRebirthPet = section5:Toggle({
    Title = "Prioritize Rebirth Pet",
    Value = roxyHubState.PrioritizeRebirthPet,
    Callback = function(value95) roxyHubState.PrioritizeRebirthPet = value95 end,
  })

  v359.AutoRebirthWhenReady = section5:Toggle({
    Title = "Auto-Rebirth When Ready",
    Value = roxyHubState.AutoRebirthWhenReady,
    Callback = function(value96) roxyHubState.AutoRebirthWhenReady = value96 end,
  })

  section5:Button({
    Title = "Manual Rebirth Now",
    Callback = function()
      local v369 = f27()

      if v369.canRebirth and not v369.isMaxCap then
        f28()

        if v347 and v347.Notify then
          v347:Notify({
            Title = "Rebirth Request Sent",
            Content = string.format("Rebirth Tier %d requested.", v369.nextTier),
            Duration = 3,
            Icon = "award",
          })
        end
      else
        local v370 = ""

        if not v369.hasPet then
          v370 = v370 .. "Missing Pet: " .. v369.reqPet .. " "
        end

        if not v369.hasCash then
          v370 = v370 .. "Insufficient Cash ($" .. f19(v369.currentCash) .. " / $"
            .. f19(v369.reqCash) .. ") "
        end

        if v369.isMaxCap then
          v370 = "Max Rebirth Cap Reached"
        end

        if v347 and v347.Notify then
          v347:Notify({
            Title = "Cannot Rebirth",
            Content = v370,
            Duration = 4,
            Icon = "alert-triangle",
          })
        end
      end
    end,
  })
end)

local dropdown

f50(plotPetsTab, "Plot & Pets", function()
  local section6 = plotPetsTab:Section({ Title = "Plot Eggs & Planting", Opened = true })

  v359.AutoHatchPlot = section6:Toggle({
    Title = "Auto-Hatch Ready Eggs",
    Value = roxyHubState.AutoHatchPlot,
    Callback = function(value97) roxyHubState.AutoHatchPlot = value97 end,
  })

  v359.AutoPlaceNest = section6:Toggle({
    Title = "Auto-Plant Eggs on Plot",
    Value = roxyHubState.AutoPlaceNest,
    Callback = function(value98) roxyHubState.AutoPlaceNest = value98 end,
  })

  v359.SpawnNest = section6:Toggle({
    Title = "Spawn Nest (15/10 Glitch)",
    Value = roxyHubState.SpawnNest,
    Callback = function(value99)
      roxyHubState.SpawnNest = value99

      if f17 then
        pcall(function() f17(value99) end)
      end
    end,
  })

  local section7 = plotPetsTab:Section({ Title = "Plot Upgrades & Placement", Opened = true })

  v359.AutoUpgradeLuck = section7:Toggle({
    Title = "Auto-Upgrade Hatch Luck",
    Value = roxyHubState.AutoUpgradeLuck,
    Callback = function(value100) roxyHubState.AutoUpgradeLuck = value100 end,
  })

  if roxyHubState.AutoPlaceBestPets == nil then
    roxyHubState.AutoPlaceBestPets = false
  end

  if roxyHubState.BestPetsStrategy == nil then
    roxyHubState.BestPetsStrategy = "Smart Potential (Lv 100 Max Income)"
  end

  v359.AutoPlaceBestPets = section7:Toggle({
    Title = "Auto-Place Best Pets",
    Value = roxyHubState.AutoPlaceBestPets,
    Callback = function(value101) roxyHubState.AutoPlaceBestPets = value101 end,
  })

  v359.BestPetsStrategy = section7:Dropdown({
    Title = "Best Pets Strategy",
    Values = { "Smart Potential (Lv 100 Max Income)", "Current Cash/s (Game Default)" },
    Value = roxyHubState.BestPetsStrategy,
    Callback = function(value102) roxyHubState.BestPetsStrategy = value102 end,
  })

  section7:Button({
    Title = "Equip / Place Best Pets Now",
    Callback = function()
      local v371, v372 = pcall(function() return f43(roxyHubState.BestPetsStrategy) end)

      if v371 and v347 and v347.Notify then
        v347:Notify({
          Title = "Smart Best Pets",
          Content = tostring(v372 or "Complete!"),
          Duration = 3,
        })
      end
    end,
  })

  local section8 = plotPetsTab:Section({ Title = "Auto Feed Pets", Opened = false })

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

  local function f52()
    local v373 = { "All Placed Pets (Smart Priority)" }
    local v374 = { ["All Placed Pets (Smart Priority)"] = "ALL" }
    local v375 = { ALL = "All Placed Pets (Smart Priority)" }

    pcall(function()
      local v376 = f13()
      local pets5 = v376 and (v376:FindFirstChild("Pets") or v376:FindFirstChild("PlacedPets"))

      if pets5 then
        for index69, value103 in ipairs(pets5:GetChildren()) do
          local petName7 = value103:GetAttribute("PetName") or value103.Name
          local v377 = tonumber(value103:GetAttribute("Age")) or 1
          local v378 = tonumber(value103:GetAttribute("Weight")) or 1
          local petKey5 = value103:GetAttribute("PetKey") or value103.Name
          local v379 = v377 >= 100 and " [MAX]" or ""

          local v380 = string.format(
            "%d. %s (Age %d | %.1f KG)%s", index69, tostring(petName7), v377, v378, v379
          )

          table.insert(v373, v380)
          v374[v380] = petKey5
          v375[petKey5] = v380
        end
      end
    end)

    return v373, v374, v375
  end

  local v381, v382, v383 = f52()
  local v384 = v382
  local v385 = v383

  v359.AutoFeedPets = section8:Toggle({
    Title = "Auto Feed Pets",
    Value = roxyHubState.AutoFeedPets,
    Callback = function(value104) roxyHubState.AutoFeedPets = value104 end,
  })

  v359.FeedTargetMode = section8:Dropdown({
    Title = "Target Mode",
    Values = {
      "Smart Priority (Highest Headroom)", "Selected Pet Only",
      "Highest Max Income (VIP First)", "Lowest Level First (Balance Ages)",
    },
    Value = roxyHubState.FeedTargetMode or "Smart Priority (Highest Headroom)",
    Callback = function(value105) roxyHubState.FeedTargetMode = value105 end,
  })

  dropdown = section8:Dropdown({
    Title = "Select Target Pet",
    Values = v381,
    Value = roxyHubState.SelectedPetKey and v385 and v385[roxyHubState.SelectedPetKey]
      or v381[1] or "No Placed Pets Detected",
    Callback = function(value106)
      if v384[value106] then
        roxyHubState.SelectedPetKey = v384[value106]
        roxyHubState.FeedTargetMode = "Selected Pet Only"

        if v359.FeedTargetMode and v359.FeedTargetMode.Set then
          pcall(function() v359.FeedTargetMode:Set("Selected Pet Only") end)
        end

        if v347 and v347.Notify then
          v347:Notify({
            Title = "Target Pet Locked",
            Content = tostring(value106),
            Duration = 2,
            Icon = "shield-check",
          })
        end
      end
    end,
  })

  v359.SelectedPetKey = dropdown

  section8:Button({
    Title = "Feed Target Pet Now",
    Callback = function()
      local v386, v387 = pcall(function() return f45(true) end)

      if v386 and v347 and v347.Notify then
        v347:Notify({
          Title = "Smart Feed",
          Content = tostring(v387 or "Complete!"),
          Duration = 3,
          Icon = "shield-check",
        })
      end
    end,
  })

  section8:Button({
    Title = "Refresh Pets List",
    Callback = function()
      local v388, v389, v390 = f52()
      v384 = v389
      v385 = v390

      if dropdown and dropdown.Refresh then
        pcall(function() dropdown:Refresh(v388) end)
      end

      if v347 and v347.Notify then
        v347:Notify({
          Title = "Pet List Refreshed",
          Content = string.format("Detected %d pets on ranch", #v388),
          Duration = 2,
          Icon = "refresh-cw",
        })
      end
    end,
  })

  v359.FeedSkipMaxAge = section8:Toggle({
    Title = "Skip Max Age Pets (Age 100)",
    Value = roxyHubState.FeedSkipMaxAge,
    Callback = function(value107) roxyHubState.FeedSkipMaxAge = value107 end,
  })

  v359.FeedAllowPremiumFood = section8:Toggle({
    Title = "Allow Premium Food (Dragonfruit / Apple)",
    Value = roxyHubState.FeedAllowPremiumFood,
    Callback = function(value108) roxyHubState.FeedAllowPremiumFood = value108 end,
  })

  v359.FeedFoodSelection = section8:Dropdown({
    Title = "Food Type Filter",
    Values = { "All Foods", "Dragonfruit", "Magic Apple", "Meat", "Bone", "Grass" },
    Value = roxyHubState.FeedFoodSelection,
    Callback = function(value109) roxyHubState.FeedFoodSelection = value109 end,
  })
end)

f50(eggESPTab, "Egg ESP", function()
  local espControlsSection = eggESPTab:Section({ Title = "ESP Controls", Opened = true })

  v359.ESP_Enabled = espControlsSection:Toggle({
    Title = "Egg ESP Master Toggle",
    Value = roxyHubState.ESP_Enabled,
    Callback = function(value110)
      roxyHubState.ESP_Enabled = value110

      if value110 then
        -- re-apply the selected visual mode (Highlights / Text / Tracers)
        f11(roxyHubState.ESP_VisualPreset or "Highlights + Floating Text")

        pcall(function()
          v347:Notify({
            Title = "Egg ESP ON",
            Content = "Mode: " .. tostring(roxyHubState.ESP_VisualPreset),
            Duration = 3,
            Icon = "eye",
          })
        end)
      else
        f30()
      end
    end,
  })

  v359.ESP_VisualPreset = espControlsSection:Dropdown({
    Title = "ESP Visual Mode",
    Values = {
      "All Visuals (Highlight + Text + Tracer)", "Highlights + Floating Text",
      "Floating Text Only (Clean)", "Highlights Only (Minimal)", "Tracers Only",
    },
    Value = roxyHubState.ESP_VisualPreset,
    Callback = function(value111)
      f11(value111)

      -- drop old visuals so the new mode is rebuilt immediately
      if roxyHubState.ESP_Enabled then
        f30()
      end
    end,
  })

  v359.ESP_MinRarity = espControlsSection:Dropdown({
    Title = "Minimum ESP Rarity",
    Values = {
      "All Eggs", "Rare & Above", "Epic & Above", "Legendary & Above", "Mythic & Above",
      "Divine & Above", "Ethereal Only",
    },
    Value = roxyHubState.ESP_MinRarity,
    Callback = function(value112)
      roxyHubState.ESP_MinRarity = value112
      f30()
    end,
  })

  v359.ESP_MaxDistance = espControlsSection:Slider({
    Title = "ESP Max Render Distance",
    Step = 250,
    Value = {
      Min = 500,
      Max = 15000,
      Default = math.clamp(tonumber(roxyHubState.ESP_MaxDistance) or 5000, 500, 15000),
    },
    Callback = function(value113)
      roxyHubState.ESP_MaxDistance = tonumber(value113) or 5000
    end,
  })

  local paragraph2 = eggESPTab:Section({ Title = "Live High-Tier Radar", Opened = true }):Paragraph({
    Title = "Scanning Active Eggs...",
    Desc = "Searching map for rare eggs...",
  })

  task.spawn(function()
    while task.wait(2) do
      pcall(function()
        local renderedEggs5 = workspaceService:FindFirstChild("RenderedEggs")
        local v391, v392 = f12()

        if renderedEggs5 and v392 then
          local v393 = {}

          for index70, value114 in ipairs(renderedEggs5:GetChildren()) do
            local v394 = f4(value114.Name)
            local v395 = v20[v394] or 0

            if v395 >= 600 then
              local eggWeight = f31(value114)
              local getPivot6 = value114:GetPivot()
              local v396 = math.floor((getPivot6.Position - v392.Position).Magnitude)

              table.insert(v393, {
                Name = value114.Name,
                Rarity = v394,
                Weight = v395,
                EggWeight = eggWeight,
                Dist = v396,
              })
            end
          end

          table.sort(v393, function(p82, p83)
            if p82.Weight ~= p83.Weight then
              return p82.Weight > p83.Weight
            end

            if p82.EggWeight ~= p83.EggWeight then
              return p82.EggWeight > p83.EggWeight
            end

            return p82.Dist < p83.Dist
          end)

          local v397 = {}
          local v398 = math.min(6, #v393)
          local count7 = 0

          while true do
            count7 = 1 + count7

            if not (count7 <= v398) then
              break
            end

            local v399 = count7

            if v393[v399].EggWeight and v393[v399].EggWeight > 0 then
              table.insert(v397, string.format(
                "- %s [%s] | %s - %d studs", v393[v399].Name, v393[v399].Rarity,
                f21(v393[v399].EggWeight), v393[v399].Dist
              ))
            else
              table.insert(v397, string.format(
                "- %s [%s] - %d studs", v393[v399].Name, v393[v399].Rarity, v393[v399].Dist
              ))
            end
          end

          if #v397 == 0 then
            paragraph2:SetTitle("Top Eggs Scanner")
            paragraph2:SetDesc("No high-tier eggs currently spawned on map.")
          else
            paragraph2:SetTitle(string.format("Top Eggs Scanner (%d Rare+ Found)", #v393))
            paragraph2:SetDesc(table.concat(v397, "\n"))
          end
        end
      end)
    end
  end)
end)

f50(teleportsTab, "Teleports", function()
  local section9 = teleportsTab:Section({ Title = "Base & Plot Fast Travel", Opened = true })
  local v400 = "My Plot (Baseplate)"

  section9:Dropdown({
    Title = "Quick Travel Destination",
    Values = {
      "My Plot (Baseplate)", "My Plot (Nests)", "My Plot (Hatch Upgrade Area)",
      "Map Spawn Center", "Volcano (Top - Magma Altar)", "Volcano (Entrance / Volkaris Lair)",
      "Volcano Lair Door (Entrance)",
    },
    Value = "My Plot (Baseplate)",
    Callback = function(value115) v400 = value115 end,
  })

  section9:Button({
    Title = "Teleport to Destination",
    Callback = function()
      local v401, v402, v403 = f12()
      local v404 = f13()

      if not v402 then
        return
      end

      if not v400:find("Volcano") then
        f23(v402, v403)
        v2663, v402 = f12()

        if not v402 then
          return
        end
      end

      if v400 == "My Plot (Baseplate)" then
        if teleportToPlot then
          teleportToPlot:FireServer()
        end

        if v404 and v404:FindFirstChild("Baseplate") then
          v402.CFrame = v404.Baseplate.CFrame * CFrame.new(0, 4, 0)
        end

        v347:Notify({
          Title = "Teleport",
          Content = "Warped to Plot Baseplate!",
          Duration = 2,
          Icon = "check",
        })
      elseif v400 == "My Plot (Nests)" then
        if v404 and v404:FindFirstChild("Nests") then
          local nests9 = v404.Nests
          v402.CFrame = CFrame.new(nests9:GetPivot().Position + Vector3.new(0, 3, 0))

          v347:Notify({
            Title = "Teleport",
            Content = "Warped to Plot Nests!",
            Duration = 2,
            Icon = "check",
          })
        end
      elseif v400 == "My Plot (Hatch Upgrade Area)" then
        if v404 and v404:FindFirstChild("HatchUpgrade") then
          local hatchUpgrade = v404.HatchUpgrade
          v402.CFrame = CFrame.new(hatchUpgrade:GetPivot().Position + Vector3.new(0, 3, 0))

          v347:Notify({
            Title = "Teleport",
            Content = "Warped to Hatch Upgrade!",
            Duration = 2,
            Icon = "check",
          })
        end
      elseif v400 == "Map Spawn Center" then
        v402.CFrame = CFrame.new(110, 40316, 750)

        v347:Notify({
          Title = "Teleport",
          Content = "Warped to Map Center!",
          Duration = 2,
          Icon = "check",
        })
      elseif v400 == "Volcano (Top - Magma Altar)" then
        f22(v402, v403)
        local v405, v406 = f12()

        if v406 then
          v406.AssemblyLinearVelocity = Vector3.zero
          v406.AssemblyAngularVelocity = Vector3.zero
          v406.CFrame = CFrame.new(vector)

          v347:Notify({
            Title = "Teleport",
            Content = "Warped to Volcano Top (Magma Altar)!",
            Duration = 2,
            Icon = "check",
          })
        end
      elseif v400 == "Volcano (Entrance / Volkaris Lair)"
        or v400 == "Volcano Lair Door (Entrance)" then
        v402.AssemblyLinearVelocity = Vector3.zero
        v402.AssemblyAngularVelocity = Vector3.zero
        v402.CFrame = cframe

        v347:Notify({
          Title = "Teleport",
          Content = "Warped to Volcano Lair Door (Entrance)!",
          Duration = 2,
          Icon = "check",
        })
      end
    end,
  })

  section9:Button({
    Title = "Validate & Clear Checkpoints",
    Callback = function()
      local v407, v408, v409 = f12()

      if not v408 or not v409 then
        return
      end

      f23(v408, v409)

      v347:Notify({
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
        local basket9 = localPlayer2:FindFirstChild("Basket")

        if basket9 and basketDrop then
          for index71, value116 in ipairs(basket9:GetChildren()) do
            basketDrop:FireServer(value116:GetAttribute("Egg") or value116.Name)
          end

          v347:Notify({
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

f50(playerTab, "Player", function()
  local movementModificationsSection = playerTab:Section({
    Title = "Movement Modifications",
    Opened = true,
  })

  v359.SpeedPreset = movementModificationsSection:Dropdown({
    Title = "Speed Multiplier Preset",
    Values = {
      "Default (1x Normal)", "Fast Rider (1.5x)", "High Velocity (2.5x)", "Sonic Speed (4x)",
    },
    Value = roxyHubState.SpeedPreset or "Default (1x Normal)",
    Callback = function(value117)
      roxyHubState.SpeedPreset = value117

      if value117 == "Default (1x Normal)" then
        roxyHubState.SpeedMultiplier = 1
        roxyHubState.SpeedModEnabled = false
      elseif value117 == "Fast Rider (1.5x)" then
        roxyHubState.SpeedMultiplier = 1.5
        roxyHubState.SpeedModEnabled = true
      elseif value117 == "High Velocity (2.5x)" then
        roxyHubState.SpeedMultiplier = 2.5
        roxyHubState.SpeedModEnabled = true
      elseif value117 == "Sonic Speed (4x)" then
        roxyHubState.SpeedMultiplier = 4
        roxyHubState.SpeedModEnabled = true
      end

      if v359.SpeedMultiplier and v359.SpeedMultiplier.Set then
        pcall(function() v359.SpeedMultiplier:Set(roxyHubState.SpeedMultiplier) end)
      end

      if v359.SpeedModEnabled and v359.SpeedModEnabled.Set then
        pcall(function() v359.SpeedModEnabled:Set(roxyHubState.SpeedModEnabled) end)
      end
    end,
  })

  v359.SpeedModEnabled = movementModificationsSection:Toggle({
    Title = "WalkSpeed Multiplier Active",
    Value = roxyHubState.SpeedModEnabled,
    Callback = function(value118) roxyHubState.SpeedModEnabled = value118 end,
  })

  v359.SpeedMultiplier = movementModificationsSection:Slider({
    Title = "Speed Multiplier",
    Step = 0.25,
    Value = { Min = 1, Max = 4, Default = roxyHubState.SpeedMultiplier },
    Callback = function(value119) roxyHubState.SpeedMultiplier = value119 end,
  })

  v359.NoClip = movementModificationsSection:Toggle({
    Title = "NoClip (Pass through obstacles)",
    Value = roxyHubState.NoClip,
    Callback = function(value120) roxyHubState.NoClip = value120 end,
  })

  v359.InfiniteJump = movementModificationsSection:Toggle({
    Title = "Infinite Jump",
    Value = roxyHubState.InfiniteJump,
    Callback = function(value121) roxyHubState.InfiniteJump = value121 end,
  })
end)

f50(eventTab, "Event", function()
  local fuseMachineSection = eventTab:Section({ Title = "Fuse Machine", Opened = true })

  v35.FuseMonitorParagraph = fuseMachineSection:Paragraph({
    Title = "Fuse Status: Initializing...",
    Desc = "Pedestals: 0/4 | Machine: Loading...",
  })

  v359.AutoFuse = fuseMachineSection:Toggle({
    Title = "Auto Fuse Machine",
    Description = "Auto deposit 4 pets and start fusing",
    Value = roxyHubState.AutoFuse,
    Callback = function(value122) roxyHubState.AutoFuse = value122 end,
  })

  v359.FuseProtectFavorited = fuseMachineSection:Toggle({
    Title = "Protect Favorited Pets",
    Description = "Never fuse pets marked as favorite",
    Value = roxyHubState.FuseProtectFavorited,
    Callback = function(value123) roxyHubState.FuseProtectFavorited = value123 end,
  })

  v359.AutoFavoriteFuse = fuseMachineSection:Toggle({
    Title = "Auto Favorite Fused Pets",
    Description = "Enable auto favoriting of selected fused pets",
    Value = roxyHubState.AutoFavoriteFuse,
    Callback = function(value124) roxyHubState.AutoFavoriteFuse = value124 end,
  })

  v359.AutoFavoriteFuseDropdown = fuseMachineSection:Dropdown({
    Title = "Auto Favorite Pets (Multi-Select)",
    Desc = "Choose exclusive pets to auto-favorite upon receiving",
    Values = values2,
    Value = roxyHubState.AutoFavoriteFuseList,
    Multi = true,
    Callback = function(value125) roxyHubState.AutoFavoriteFuseList = value125 end,
  })

  fuseMachineSection:Button({
    Title = "Teleport to Fuse Machine",
    Callback = function()
      local v410, v411 = f12()

      if v411 then
        v411.CFrame = CFrame.new(388, 40329, 751)
      end
    end,
  })

  local section10 = eventTab:Section({ Title = "Allowed Rarities to Fuse", Opened = true })

  v359.FuseLegendary = section10:Toggle({
    Title = "Fuse Legendary",
    Value = roxyHubState.FuseRarities.Legendary,
    Callback = function(value126) roxyHubState.FuseRarities.Legendary = value126 end,
  })

  v359.FuseMythic = section10:Toggle({
    Title = "Fuse Mythic",
    Value = roxyHubState.FuseRarities.Mythic,
    Callback = function(value127) roxyHubState.FuseRarities.Mythic = value127 end,
  })

  v359.FuseDivine = section10:Toggle({
    Title = "Fuse Divine",
    Value = roxyHubState.FuseRarities.Divine,
    Callback = function(value128) roxyHubState.FuseRarities.Divine = value128 end,
  })

  v359.FuseEthereal = section10:Toggle({
    Title = "Fuse Ethereal",
    Value = roxyHubState.FuseRarities.Ethereal,
    Callback = function(value129) roxyHubState.FuseRarities.Ethereal = value129 end,
  })
end)

task.wait()

f50(settingsTab, "Settings", function()
  local interfaceControlsSection = settingsTab:Section({
    Title = "Interface & Controls",
    Opened = true,
  })

  interfaceControlsSection:Keybind({
    Title = "Toggle Menu Keybind",
    Value = "RightShift",
    Callback = function() window:Toggle() end,
  })

  interfaceControlsSection:Toggle({
    Title = "Mobile Floating Button",
    Default = true,
    Callback = function(value130)
      if v355 then
        v355.Enabled = value130
      end
    end,
  })

  interfaceControlsSection:Dropdown({
    Title = "Window Theme",
    Values = { "RoxyHub", "Dark", "Rose", "Plant", "Indigo" },
    Value = roxyThemeName,
    Callback = function(value131) pcall(function() v347:SetTheme(value131) end) end,
  })

  interfaceControlsSection:Button({
    Title = "Unload / Close RoxyHub",
    Callback = function()
      if _G.RoxyHubConnections then
        for index72, value132 in ipairs(_G.RoxyHubConnections) do
          local v412 = value132
          pcall(function() v412:Disconnect() end)
        end
      end

      _G.RoxyHubConnections = {}
      -- stop every background loop (they all check this id)
      _G.RoxyHubInstanceId = (_G.RoxyHubInstanceId or 0) + 1
      pcall(f30)

      if v355 then
        pcall(function() v355:Destroy() end)
      end

      if window then
        window:Destroy()
      end
    end,
  })

  local section11 = settingsTab:Section({ Title = "Profiles & AutoLoad", Opened = true })

  local function f53()
    local v413 = {}
    table.sort(v413)

    if #v413 == 0 then
      table.insert(v413, "default")
    end

    return v413
  end

  local function f54(p84)
    if not writefile then
      return false, "writefile not supported"
    end

    local v414, v415, v416

    if not p84 or p84 == "" or p84 == "autoload" then
      return false, "Invalid profile name"
    else
      v414 = "RoxyHub_RideAPet/configs" .. "/" .. p84 .. ".json"
      v415 = {}

      for key13, value135 in pairs(roxyHubState) do
        v415[key13] = value135
      end

      local v417
      v417, v416 = pcall(function() return httpService:JSONEncode(v415) end)

      if not v417 then
        return false, "JSON encoding error"
      else
        local v418, v419 = pcall(function() writefile(v414, v416) end)

        if not v418 then
          return false, tostring(v419)
        end

        return true
      end
    end
  end

  local function f55(p85, p86)
    if not readfile or not isfile then
      return false, "readfile not supported"
    end

    if not p85 or p85 == "" or p85 == "autoload" then
      return false, "Invalid profile name"
    end

    local v420 = "RoxyHub_RideAPet/configs" .. "/" .. p85 .. ".json"
    local v421

    if not isfile(v420) then
      return false, "Profile not found"
    else
      local v422
      v422, v421 = pcall(function() return readfile(v420) end)

      if not v422 or not v421 then
        return false, "Read error"
      else
        local v423, v424 = pcall(function() return httpService:JSONDecode(v421) end)

        if not v423 or type(v424) ~= "table" then
          return false, "Corrupted profile"
        end

        for key14, value136 in pairs(v424) do
          if p86 and (key14 == "AutoFarm" or key14 == "AutoRebirth") then
            roxyHubState[key14] = false
          else
            roxyHubState[key14] = value136
          end
        end

        return true
      end
    end
  end

  local v425 = ""

  section11:Input({
    Title = "Create New Profile",
    Placeholder = "e.g. my_config",
    Value = "",
    Callback = function(value137)
      if value137 and value137 ~= "" then
        v425 = value137
      end
    end,
  })

  local selectProfileDropdown

  local function f56(p87)
    local v426 = f53()

    if selectProfileDropdown then
      if selectProfileDropdown.SetValues then
        pcall(function() selectProfileDropdown:SetValues(v426) end)
      end

      if selectProfileDropdown.Refresh then
        pcall(function() selectProfileDropdown:Refresh(v426, true) end)
      end

      if p87 then
        if selectProfileDropdown.Select then
          pcall(function() selectProfileDropdown:Select(p87) end)
        elseif selectProfileDropdown.Set then
          pcall(function() selectProfileDropdown:Set(p87) end)
        end
      end
    end
  end

  section11:Button({
    Title = "Create Profile",
    Callback = function()
      if v425 ~= "" then
        profile = v425
        local v427, v428 = f54(profile)

        if v427 then
          if v33 then
            pcall(function()
              writefile(
                "RoxyHub_RideAPet/configs/autoload.json",
                httpService:JSONEncode({ AutoLoad = true, Profile = profile })
              )
            end)
          end

          f56(profile)

          v347:Notify({
            Title = "Created",
            Content = string.format("Created '%s.json'!", profile),
            Duration = 3,
            Icon = "check",
          })
        else
          v347:Notify({
            Title = "Error",
            Content = tostring(v428),
            Duration = 3,
            Icon = "x",
          })
        end
      else
        v347:Notify({
          Title = "Notice",
          Content = "Please enter a profile name first!",
          Duration = 3,
          Icon = "alert-circle",
        })
      end
    end,
  })

  selectProfileDropdown = section11:Dropdown({
    Title = "Select Profile",
    Values = f53(),
    Value = profile,
    Callback = function(value138)
      if value138 and value138 ~= "" then
        profile = value138

        if v33 then
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

  section11:Button({
    Title = "Overwrite Config",
    Callback = function()
      local v429 = profile
      local v430, v431 = f54(v429)

      if v430 then
        if v33 then
          pcall(function()
            writefile(
              "RoxyHub_RideAPet/configs/autoload.json",
              httpService:JSONEncode({ AutoLoad = true, Profile = profile })
            )
          end)
        end

        v347:Notify({
          Title = "Saved",
          Content = string.format("Overwrote '%s.json'!", v429),
          Duration = 3,
          Icon = "check",
        })
      else
        v347:Notify({
          Title = "Error",
          Content = tostring(v431),
          Duration = 3,
          Icon = "x",
        })
      end
    end,
  })

  section11:Button({
    Title = "Load Selected Config",
    Callback = function()
      local v432 = profile
      local v433, v434 = f55(v432, false)

      if v433 then
        v347:Notify({
          Title = "Loaded",
          Content = string.format("Loaded '%s.json' & updated UI!", v432),
          Duration = 3,
          Icon = "check",
        })
      else
        v347:Notify({
          Title = "Error",
          Content = tostring(v434),
          Duration = 3,
          Icon = "x",
        })
      end
    end,
  })

  section11:Toggle({
    Title = "Auto Load Profile On Startup",
    Value = v33,
    Callback = function(value139)
      v33 = value139

      if value139 then
        v347:Notify({
          Title = "AutoLoad ON",
          Content = string.format("Will auto-load '%s.json' on start", profile),
          Duration = 3,
          Icon = "check",
        })
      else
        v347:Notify({
          Title = "AutoLoad OFF",
          Content = "Disabled auto-load on start",
          Duration = 3,
          Icon = "x",
        })
      end
    end,
  })
end)

if v33 then
  pcall(function() loadProfile(profile, true) end)
end

task.wait()
f1()
task.wait(0.15)

pcall(function()
  if v355 then
    v355.Enabled = true
  end

  if window and window.Open then
    window:Open()
  end

  if window and window.SelectTab then
    window:SelectTab(1)
  end
end)

pcall(function()
  v347:Notify({
    Title = "RoxyHub Loaded",
    Content = "Ride A Pet is ready!",
    Duration = 4,
    Icon = "sparkles",
  })
end)
