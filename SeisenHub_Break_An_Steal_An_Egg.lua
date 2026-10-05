local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local workspaceService = game:GetService("Workspace")
local runService = game:GetService("RunService")
local collectionService = game:GetService("CollectionService")
local localPlayer = players.LocalPlayer
local seisenUINew = loadstring(game:HttpGet("https://raw.githubusercontent.com/Seisen-z/Seisen-Library/main/SeisenUI_New.lua"))()

local f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, bsaeGeneration, v1, v2, v3, v4, v5, v6, v7,
  v8, v9, f12, f13, f14, f15, v10, f16, v11, placeAnimalRemote, v12, f17, v13, f18, f19

if not seisenUINew:SetGameId(10765288803) then
  return
else
  getgenv().BSAE_Generation = (getgenv().BSAE_Generation or 0) + 1
  bsaeGeneration = getgenv().BSAE_Generation

  local v14 = getgenv()
  v14.BSAE_Connections = getgenv().BSAE_Connections or {}

  for index, value in ipairs(getgenv().BSAE_Connections) do
    local v15 = value
    pcall(function() v15:Disconnect() end)
  end

  table.clear(getgenv().BSAE_Connections)

  getgenv().BSAE_AutoBreakStealEgg = false
  getgenv().BSAE_SelectedZone = { All = true }
  getgenv().BSAE_SelectedRarity = { All = true }
  getgenv().BSAE_AutoPlaceAnimal = true
  getgenv().BSAE_AutoEquipBestAnimals = false
  getgenv().BSAE_AutoStealDroppedPet = false
  getgenv().BSAE_StealRarities = { All = true }
  getgenv().BSAE_TargetBiggestEgg = false
  getgenv().BSAE_AutoTreadmillIdle = false
  getgenv().BSAE_AutoUnlockTreadmill = false
  getgenv().BSAE_AutoUpgradeTreadmill = false
  getgenv().BSAE_AutoUpgradePlot = false
  getgenv().BSAE_AutoBuyPickaxes = false
  getgenv().BSAE_AutoEquipBestPickaxe = false
  getgenv().BSAE_AutoBuyTrails = false
  getgenv().BSAE_AutoEquipBestTrail = false
  getgenv().BSAE_AutoSellPets = false
  getgenv().BSAE_AutoSellEggs = false
  getgenv().BSAE_AutoSellIfFull = false
  getgenv().BSAE_DontSellFavorite = true
  getgenv().BSAE_SellRarities = { Common = true, Uncommon = true }
  getgenv().BSAE_AutoPlaceMergeEgg = false
  getgenv().BSAE_AutoHatchMergeEgg = false
  getgenv().BSAE_AutoClaimIndex = false
  getgenv().BSAE_AutoClaimGroup = false
  getgenv().BSAE_AutoClaimOffline = false
  getgenv().BSAE_CustomWalkSpeed = false
  getgenv().BSAE_WalkSpeedValue = 50
  getgenv().BSAE_BatKillAura = false
  getgenv().BSAE_ShowEggEsp = false
  getgenv().BSAE_ShowAnimalEsp = false

  local v16 = getgenv()
  v16.BSAE_ActiveEsp = getgenv().BSAE_ActiveEsp or {}

  for key, value2 in pairs(getgenv().BSAE_ActiveEsp) do
    local v17 = value2
    pcall(function() v17:Destroy() end)
  end

  table.clear(getgenv().BSAE_ActiveEsp)
  v1 = nil
  v2 = nil
  pcall(function() require(replicatedStorage.Shared.TreadmillUpgradeConfig) end)
  v3 = nil
  pcall(function() v3 = require(replicatedStorage.Shared.BatConfig) end)
  v4 = nil
  pcall(function() v4 = require(replicatedStorage.Shared.EggRewards) end)
  v5 = {}

  v6 = {
    Zone1 = 1,
    Zone2 = 2,
    Zone3 = 3,
    Zone4 = 4,
    Zone5 = 5,
    Zone6 = 6,
    Zone7 = 7,
    Zone8 = 8,
    Zone9 = 9,
  }

  v7 = {
    "Forest Zone", "Desert Zone", "Snowy Zone", "Candy Zone", "Swamp Zone", "Ocean Zone",
    "Hell Zone", "Blossom Zone", "Galaxy Zone",
  }

  v8 = {
    Common = 1,
    Uncommon = 2,
    Rare = 3,
    Epic = 4,
    Legendary = 5,
    Mythic = 6,
    Divine = 7,
    Cosmic = 8,
    Secret = 9,
    Celestial = 10,
    Inferno = 11,
  }

  v9 = {
    Common = Color3.fromRGB(180, 180, 180),
    Uncommon = Color3.fromRGB(133, 255, 122),
    Rare = Color3.fromRGB(79, 232, 210),
    Epic = Color3.fromRGB(79, 168, 255),
    Legendary = Color3.fromRGB(245, 197, 66),
    Mythic = Color3.fromRGB(255, 77, 106),
    Divine = Color3.fromRGB(138, 112, 255),
    Cosmic = Color3.fromRGB(255, 105, 180),
    Secret = Color3.fromRGB(255, 215, 0),
    Celestial = Color3.fromRGB(255, 223, 110),
    Inferno = Color3.fromRGB(235, 30, 30),
  }

  local seisenHubWindow = seisenUINew:CreateWindow({
    Name = "Hub",
    SubTitle = "Break and Steal an Egg",
    Version = "v1.0.0",
    Icon = "rbxassetid://108392837079013",
    ToggleKeybind = Enum.KeyCode.LeftAlt,
    ConfigSettings = true,
    Manager = true,
    Folder = "BreakAndStealAnEgg",
    ScriptUpdate = false,
    SupportedGames = false,
    ScriptUrl = "",
  })

  function f1(p1, p2)
    if not p1 then
      return nil
    else
      local v18 = p2 or 25

      for index2, value3 in ipairs(collectionService:GetTagged("SmartPrompt")) do
        local proximityPrompt = value3:IsA("ProximityPrompt")

        local steal = proximityPrompt
          and value3.Enabled
          and (value3.Name:find("Steal") or value3.ActionText:find("Steal")
            or value3.Name:find("Animal") or value3.ActionText:find("Pick")
            or value3.ActionText:find("Take") or value3.ActionText:find("Claim"))

        if steal then
          local parent = value3.Parent

          local position = parent
            and (parent:IsA("BasePart") and parent.Position
              or parent:IsA("Attachment") and parent.WorldPosition
              or parent:IsA("Model") and parent:GetPivot().Position or nil)

          if position and (position - p1).Magnitude <= v18 then
            return value3
          end
        end
      end

      for index3, value4 in ipairs(workspaceService:GetChildren()) do
        if value4.Name == "PromptAnchor" and value4:IsA("BasePart") and value4.Position
          and (value4.Position - p1).Magnitude <= v18 then
          for index4, value5 in ipairs(value4:GetChildren()) do
            local proximityPrompt2 = value5:IsA("ProximityPrompt")

            local steal2 = proximityPrompt2
              and value5.Enabled
              and (value5.Name:find("Steal") or value5.ActionText:find("Steal")
                or value5.Name:find("Animal") or value5.ActionText:find("Pick")
                or value5.ActionText:find("Take") or value5.ActionText:find("Claim"))

            if steal2 then
              return value5
            end
          end
        end
      end

      return nil
    end
  end

  seisenHubWindow:ShowChangelog({
    {
      Version = "v1.0.1",
      Date = "Oct 4, 2026",
      Changes = {
        "[+] Added:",
        "> • Focus Biggest Egg First toggle — when enabled, auto break targets the highest HP egg instead of the nearest one.",
        "[~] Improved:",
        "> • Auto Break now works as a kill aura — fires damage without swinging while staying teleported to the egg.",
        "> • Script now fully waits for the hatch animation to finish and the pet to appear before stealing or moving to the next egg.",
      },
    },
    {
      Version = "v1.0.0",
      Date = "Oct 3, 2026",
      Changes = {
        "[+] Initial Release:",
        "> • Auto Break & Steal Egg with Biome/Zone and Rarity filtering.",
        "> • Auto Treadmill Idle (train SpeedPower), Auto Unlock, and Auto Upgrade Treadmill.",
        "> • Auto Upgrade Pen / Plot and Auto Place Animals.",
        "> • Auto Buy & Equip Pickaxes and Trails.",
        "> • Auto Sell Animals and Eggs with customizable Rarity filters.",
        "> • Auto Place & Hatch Eggs on Merge Machine.",
        "> • Auto Claim Index, Group, and Offline Rewards.",
        "> • Player WalkSpeed modification and Bat Kill Aura.",
        "> • Visual ESP for Eggs and Animal Pickups.",
      },
    },
  })

  function f2(p3)
    if getgenv().BSAE_SelectedZone.All then
      return true
    else
      local v19 = v7[p3]

      if v19 and getgenv().BSAE_SelectedZone[v19] then
        return true
      else
        local v20 = tostring(p3)
        return getgenv().BSAE_SelectedZone["Zone" .. v20] == true
      end
    end
  end

  function f3()
    local treadmillSessionRemote = replicatedStorage:FindFirstChild("TreadmillSessionRemote")

    if treadmillSessionRemote and treadmillSessionRemote:IsA("RemoteEvent") then
      pcall(function() treadmillSessionRemote:FireServer() end)
    end

    pcall(function() runService:UnbindFromRenderStep("TreadmillFaceLock") end)
    local character = localPlayer.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoidRootPart then
      humanoidRootPart.Anchored = false
    end

    if humanoid then
      humanoid.AutoRotate = true
      pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end
  end

  function f4()
    local character2 = localPlayer.Character
    local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")

    if character2 and humanoid2 and humanoidRootPart2 and humanoid2.Health > 0 then
      return character2, humanoid2, humanoidRootPart2
    end

    return nil, nil, nil
  end

  function f12(p4, p5, ...)
    local v21, v22 = xpcall(p5, function(p6)
      local v23 = tostring(p6)
      local v24 = debug.traceback(nil, 2)
      local v25 = tostring(p4)

      warn((string.format([[
[ERROR | %s]: %s
%s]], v25, v23, tostring(v24))))

      return v23
    end, ...)

    return v21, v22
  end

  function f13()
    local plots = workspaceService:FindFirstChild("Plots")

    if not plots then
      return nil
    end

    for index5, value6 in ipairs(plots:GetChildren()) do
      if value6:GetAttribute("OwnerUserId") == localPlayer.UserId then
        return value6
      end
    end

    return nil
  end

  function f5(p7)
    local eggType = p7:GetAttribute("EggType") or ""
    local rarityOf = v4 and v4.RarityOf
    local parent2, parent3

    if rarityOf then
      local v26 = v4.RarityOf(eggType)

      if v26 then
        return v26
      end

      parent2 = p7.Parent

      parent3 = parent2
      parent3 = parent2 and parent2.Parent and parent2.Parent.Parent

      if parent3 then
        return ({
          "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Cosmic",
          "Secret", "Celestial", "Inferno",
        })[v6[parent2.Parent.Parent.Name] or 1] or "Common"
      end

      return "Common"
    end

    parent2 = p7.Parent

    parent3 = parent2
    parent3 = parent2 and parent2.Parent and parent2.Parent.Parent

    if parent3 then
      return ({
        "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Cosmic",
        "Secret", "Celestial", "Inferno",
      })[v6[parent2.Parent.Parent.Name] or 1] or "Common"
    end

    return "Common"
  end

  function f6(p8)
    local character3 = localPlayer.Character

    if character3 and character3:FindFirstChild(p8) then
      return true
    else
      local backpack = localPlayer:FindFirstChildOfClass("Backpack")
      local findFirstChild = backpack and backpack:FindFirstChild(p8)

      if findFirstChild and character3 then
        local humanoid3 = character3:FindFirstChildOfClass("Humanoid")

        if humanoid3 then
          humanoid3:EquipTool(findFirstChild)
          return true
        end

        return false
      end

      return false
    end
  end

  function f14(p9)
    if not p9 then
      return nil
    end

    for index6, value7 in ipairs(p9:GetChildren()) do
      if value7.Name:find("Treadmill") and value7:FindFirstChild("Hitbox") then
        return value7
      end
    end

    return nil
  end

  function f7(p10)
    if getgenv().BSAE_SelectedRarity.All then
      return true
    end

    if getgenv().BSAE_SelectedRarity["Highest Rarity"] then
      return true
    end

    return getgenv().BSAE_SelectedRarity[p10] == true
  end

  function f15(p11, p12)
    if not (p11 and p12 and p11.Position) then
      return
    else
      local v27 = f14(p12)
      local hitbox = v27 and v27:FindFirstChild("Hitbox")

      if hitbox and hitbox.Position then
        if (p11.Position - hitbox.Position).Magnitude > 4 then
          p11.CFrame = hitbox.CFrame * CFrame.new(0, 2, 0)
        end
      end

      return
    end
  end

  function f8(p13)
    if not p13 or not p13:IsA("ProximityPrompt") then
      return nil, nil
    else
      local objectText = p13.ObjectText or ""

      if objectText == "" then
        return nil, nil
      else
        local v28 = string.gsub(objectText, "<[^>]+>", "")
        local v29 = string.gsub(v28, "^%s*(.-)%s*$", "%1")
        local v30 = string.match(v29, "%[[^%]]*Kg%]%s*(.+)") or v29
        local v31 = string.gsub(v30, "^%s*(.-)%s*$", "%1")
        local v32 = v5[string.lower(string.gsub(v31, "[%s_]+", ""))]

        if not v32 and v4 and v4.RarityOf then
          v32 = v4.RarityOf(v31)

          if not v32 then
            local v33 = string.gsub(v31, "%s+", "")
            v32 = v4.RarityOf(v33)
          end
        end

        if not v32 then
          local v34 = string.match(objectText, 'color="(#[A-Fa-f0-9]+)"')

          if v34 then
            local v35 = string.upper(v34)

            if v35 == "#B4B4B4" or v35 == "#C8C8C8" then
              v32 = "Common"
            elseif v35 == "#85FF7A" or v35 == "#58D660" then
              v32 = "Uncommon"
            elseif v35 == "#4FE8D2" or v35 == "#408CFF" then
              v32 = "Rare"
            elseif v35 == "#4FA8FF" or v35 == "#AA54FF" then
              v32 = "Epic"
            elseif v35 == "#F5C542" or v35 == "#FFAA28" then
              v32 = "Legendary"
            elseif v35 == "#FF4D6A" or v35 == "#FF5050" then
              v32 = "Mythic"
            elseif v35 == "#8A70FF" or v35 == "#78EBEB" then
              v32 = "Divine"
            elseif v35 == "#FF69B4" or v35 == "#FF5AF5" then
              v32 = "Cosmic"
            elseif v35 == "#FFD700" or v35 == "#EBEBEB" then
              v32 = "Secret"
            elseif v35 == "#FFDF6E" or v35 == "#FFDE6E" then
              v32 = "Celestial"
            elseif v35 == "#EB1E1E" or v35 == "#FF1E1E" then
              v32 = "Inferno"
            end
          end
        end

        return v32 or "Common", v31
      end
    end
  end

  function f9(p14)
    local breakableEgg = collectionService:GetTagged("BreakableEgg")
    local v36 = {}
    local v37 = os.clock()

    for index7, value8 in ipairs(breakableEgg) do
      if value8:IsA("BasePart") and value8.Parent ~= nil then
        if not (value8:GetAttribute("Broken") or value8:GetAttribute("Hatching")
          or value8:GetAttribute("Despawning")) then
          if not (v10[value8] and v37 < v10[value8]) then
            local zoneIndex = value8:GetAttribute("ZoneIndex") or 1
            local v38 = f5(value8)

            if f2(zoneIndex) and f7(v38) then
              local magnitude = p14 and value8.Position and (value8.Position - p14).Magnitude
                or 0

              local rarityScore = v8[v38] or 1

              table.insert(v36, {
                Part = value8,
                Zone = zoneIndex,
                RarityScore = rarityScore,
                Dist = magnitude,
                Health = value8:GetAttribute("Health") or 1,
                MaxHealth = value8:GetAttribute("MaxHealth") or value8:GetAttribute("Health")
                  or 1,
              })
            end
          end
        end
      end
    end

    if #v36 == 0 then
      return nil
    end

    table.sort(v36, function(p15, p16)
      if getgenv().BSAE_TargetBiggestEgg then
        if p15.MaxHealth ~= p16.MaxHealth then
          return p15.MaxHealth > p16.MaxHealth
        end
      end

      if getgenv().BSAE_SelectedRarity["Highest Rarity"] then
        if p15.RarityScore ~= p16.RarityScore then
          return p15.RarityScore > p16.RarityScore
        end

        return (p15.Dist or 0) < (p16.Dist or 0)
      end

      return (p15.Dist or 0) < (p16.Dist or 0)
    end)

    return v36[1].Part
  end

  v10 = {}

  function f10(p17)
    local v39 = {}
    local v40 = {}

    local function f20(p18)
      local v41 = p18

      if p18 then
        local proximityPrompt3 = p18:IsA("ProximityPrompt")
        local v42 = proximityPrompt3

        if proximityPrompt3 then
          local enabled = p18.Enabled

          local steal3 = enabled
            and not v40[p18]
            and (p18.Name:find("Steal") or p18.ActionText:find("Steal")
              or p18.Name:find("Animal") or p18.ActionText:find("Pick")
              or p18.ActionText:find("Take") or p18.ActionText:find("Claim"))

          v42 = steal3
        end

        v41 = v42
      end

      if v41 then
        v40[p18] = true
        local v43 = f8(p18)

        if v43 and f16(v43) then
          local parent4 = p18.Parent

          local position2 = parent4
            and (parent4:IsA("BasePart") and parent4.Position
              or parent4:IsA("Attachment") and parent4.WorldPosition
              or parent4:IsA("Model") and parent4:GetPivot().Position or nil)

          if position2 then
            local magnitude2 = p17 and position2 and (position2 - p17).Magnitude or 0

            table.insert(v39, {
              Prompt = p18,
              Pos = position2,
              RarityScore = v8[v43] or 1,
              Dist = magnitude2,
            })
          end
        end
      end
    end

    for index8, value9 in ipairs(collectionService:GetTagged("SmartPrompt")) do
      f20(value9)
    end

    for index9, value10 in ipairs(workspaceService:GetChildren()) do
      if value10.Name == "PromptAnchor" and value10:IsA("BasePart") then
        for index10, value11 in ipairs(value10:GetChildren()) do
          f20(value11)
        end
      end
    end

    if #v39 == 0 then
      return nil, nil
    end

    table.sort(v39, function(p19, p20)
      if getgenv().BSAE_StealRarities["Highest Rarity"] then
        if p19.RarityScore ~= p20.RarityScore then
          return p19.RarityScore > p20.RarityScore
        end

        return p19.Dist < p20.Dist
      end

      return p19.Dist < p20.Dist
    end)

    return v39[1].Prompt, v39[1].Pos
  end

  function f16(p21)
    if getgenv().BSAE_StealRarities.All then
      return true
    end

    if getgenv().BSAE_StealRarities["Highest Rarity"] then
      return true
    end

    return getgenv().BSAE_StealRarities[p21] == true
  end

  v11 = nil

  pcall(function()
    v11 = require(localPlayer.PlayerScripts.Client.Controllers.AnimalToolController)
  end)

  placeAnimalRemote = replicatedStorage:FindFirstChild("PlaceAnimalRemote")
  v12 = 0

  function f11(p22, p23, p24)
    f12("Auto Place Animal on Pen", function()
      if not (getgenv().BSAE_AutoPlaceAnimal and p23 and p24) then
        return
      else
        local animalsPlaced = p23:GetAttribute("AnimalsPlaced") or 0
        local maxAnimals = p23:GetAttribute("MaxAnimals") or 8

        if animalsPlaced >= maxAnimals then
          return
        else
          local v44 = math.max(0, maxAnimals - animalsPlaced)

          if v44 <= 0 then
            return
          else
            local v45 = {}

            for index11, value12 in ipairs({
              p22, (localPlayer:FindFirstChildOfClass("Backpack")),
            }) do
              if value12 then
                for index12, value13 in ipairs(value12:GetChildren()) do
                  if value13:IsA("Tool") and collectionService:HasTag(value13, "AnimalTool") then
                    table.insert(v45, value13)

                    if #v45 >= v44 then
                      break
                    end
                  end
                end
              end

              if #v45 >= v44 then
                break
              end
            end

            if #v45 == 0 then
              return
            else
              local position3 = p24.Position
              local size = p24.Size
              local v46 = math.max(2, size.X * 0.35)
              local v47 = math.max(2, size.Z * 0.35)
              local y = position3.Y

              for index13, value14 in ipairs(v45) do
                local v48 = value14

                if v48 and v48.Parent and bsaeGeneration == getgenv().BSAE_Generation
                  and getgenv().BSAE_AutoPlaceAnimal then
                  v12 = (v12 or 0) + 1
                  local v49 = math.floor(v46)
                  local v50 = math.random(-v49, math.floor(v46))
                  local v51 = math.floor(v47)
                  local v52 = math.random(-v51, math.floor(v47))
                  local vector = Vector3.new(position3.X + v50, y, position3.Z + v52)

                  pcall(function()
                    if v11 and v11.PlaceAt then
                      v11.PlaceAt(v48, vector)
                    elseif placeAnimalRemote then
                      placeAnimalRemote:FireServer(v48, vector, v12)
                    end
                  end)

                  task.wait(0.12)
                end
              end

              if getgenv().BSAE_AutoEquipBestAnimals then
                task.delay(0.5, f17)
              end

              return
            end
          end
        end
      end
    end)
  end

  function f17()
    local petsInventoryRemote = replicatedStorage:FindFirstChild("PetsInventoryRemote")

    if petsInventoryRemote and petsInventoryRemote:IsA("RemoteEvent") then
      pcall(function() petsInventoryRemote:FireServer("EquipBest", nil) end)
    end
  end

  v13 = false

  function f18(p25)
    f12("Auto Steal Pet Prompt", function()
      local v53

      if v13 then
        return
      elseif not getgenv().BSAE_AutoStealDroppedPet then
        return
      elseif not (p25 and p25.Parent and p25.Enabled) then
        return
      elseif localPlayer:GetAttribute("Carrying") ~= nil then
        return
      else
        local v54 = f8(p25)

        if not v54 then
          task.wait(0.02)
          v54 = f8(p25)
        end

        if not (v54 and f16(v54)) then
          return
        else
          local parent5 = p25.Parent

          local position4 = parent5
            and (parent5:IsA("BasePart") and parent5.Position
              or parent5:IsA("Attachment") and parent5.WorldPosition
              or parent5:IsA("Model") and parent5:GetPivot().Position or nil)

          if not position4 then
            return
          else
            local v55, v56, v57 = f4()
            local v58 = f13()

            local hitbox2 = v58
            hitbox2 = v58 and v58:FindFirstChild("Hitbox")

            if not (v57 and hitbox2) then
              return
            else
              v13 = true
              f3()
              v57.CFrame = CFrame.new(position4 + Vector3.new(0, 1.5, 0))
              local v59 = os.clock()

              while bsaeGeneration == getgenv().BSAE_Generation
                and getgenv().BSAE_AutoStealDroppedPet and p25.Parent ~= nil and p25.Enabled
                and os.clock() - (v59 or os.clock()) < 2 do
                if localPlayer:GetAttribute("Carrying") ~= nil then
                  break
                else
                  local v60, v61, v62 = f4()

                  if v62 then
                    v62.CFrame = CFrame.new(position4 + Vector3.new(0, 1.5, 0))
                  end

                  pcall(function() fireproximityprompt(p25, 0) end)
                  task.wait(0.03)
                end
              end

              if localPlayer:GetAttribute("Carrying") ~= nil and hitbox2 then
                local v63 = os.clock()

                while bsaeGeneration == getgenv().BSAE_Generation
                  and localPlayer:GetAttribute("Carrying") ~= nil
                  and os.clock() - (v63 or os.clock()) < 4 do
                  local v64, v65, v66 = f4()

                  if v66 then
                    v66.CFrame = hitbox2.CFrame * CFrame.new(0, 2, 0)
                  end

                  task.wait(0.08)
                end

                task.wait(0.15)
                f11(localPlayer.Character, v58, hitbox2)
              end

              local v67, v68, v69 = f4()
              v53 = v69 and f10(v69.Position)

              if v53 and v53 ~= p25 then
                v13 = false
                task.spawn(function() f12("Steal Next Dropped Pet", f18, v53) end)
                return
              end

              if getgenv().BSAE_AutoTreadmillIdle and v58
                and not getgenv().BSAE_AutoBreakStealEgg and v69 then
                f15(v69, v58)
              end

              v13 = false
              return
            end
          end
        end
      end
    end)
  end

  local connect = collectionService:GetInstanceAddedSignal("SmartPrompt"):Connect(function(p26)
    f12("SmartPrompt Listener", function()
      local bsaeAutoStealDroppedPet = getgenv().BSAE_AutoStealDroppedPet

      local steal4 = bsaeAutoStealDroppedPet
        and p26:IsA("ProximityPrompt")
        and (p26.Name:find("Steal") or p26.ActionText:find("Steal") or p26.Name:find("Animal")
          or p26.ActionText:find("Pick") or p26.ActionText:find("Take")
          or p26.ActionText:find("Claim"))

      if steal4 then
        task.spawn(f18, p26)
      end
    end)
  end)

  table.insert(getgenv().BSAE_Connections, connect)

  local connect2 = workspaceService.ChildAdded:Connect(function(child)
    f12("PromptAnchor Listener", function()
      if not getgenv().BSAE_AutoStealDroppedPet then
        return
      end

      if child.Name == "PromptAnchor" then
        task.spawn(function()
          for index14, value15 in ipairs(child:GetChildren()) do
            if value15:IsA("ProximityPrompt")
              and (value15.Name:find("Steal") or value15.ActionText:find("Steal")
                or value15.Name:find("Animal") or value15.ActionText:find("Pick")
                or value15.ActionText:find("Take") or value15.ActionText:find("Claim")) then
              f18(value15)
              return
            end
          end

          if not child:WaitForChild("StealPrompt", 1) then
            child:FindFirstChildWhichIsA("ProximityPrompt")
          end
        end)
      end
    end)
  end)

  table.insert(getgenv().BSAE_Connections, connect2)

  function f19()
    local mergeMachineRemote = replicatedStorage:FindFirstChild("MergeMachineRemote")

    if not (mergeMachineRemote and mergeMachineRemote:IsA("RemoteEvent")) then
      return
    else
      local getServerTimeNow = workspaceService:GetServerTimeNow()

      for index15, value16 in ipairs(collectionService:GetTagged("MergeEggPlaced")) do
        if value16:IsA("Model") and value16:GetAttribute("OwnerUserId") == localPlayer.UserId then
          local readyAtServerTime = value16:GetAttribute("ReadyAtServerTime") or 0

          if value16:GetAttribute("Ready") == true
            or readyAtServerTime > 0 and readyAtServerTime <= getServerTimeNow then
            local eggId = value16:GetAttribute("EggId")

            if eggId then
              pcall(function() mergeMachineRemote:FireServer("HatchEgg", eggId) end)
            end
          end
        end
      end

      return
    end
  end

  seisenHubWindow:AddSidebarSection("Main")
  local addTab = seisenHubWindow:AddTab("Info", "house")
  local addLeftSection = addTab:AddLeftSection("Information", "info")
  local addRightSection = addTab:AddRightSection("About Script", "sparkles")

  addLeftSection:AddLabel({ Text = "Welcome to Break and Steal an Egg!" })
  addLeftSection:AddLabel({ Text = "Automation & Utility Tool." })
  addLeftSection:AddDivider("Controls")
  addLeftSection:AddLabel({ Text = "Press Left Alt to toggle the UI Menu." })
  addLeftSection:AddDivider("Status")
  addLeftSection:AddLabel({ Text = "Script Version: v1.0.0" })
  addLeftSection:AddLabel({ Text = "Status: Operational" })

  addRightSection:AddLabel({ Text = "Features Included:" })
  addRightSection:AddDivider("Farming Tab")
  addRightSection:AddLabel({ Text = "> • Fast Auto Break & Steal Egg + Filter" })
  addRightSection:AddLabel({ Text = "> • Auto Bank & Auto Place Animals" })
  addRightSection:AddLabel({ Text = "> • Treadmill Speed Training (Idle/Upgrades)" })
  addRightSection:AddLabel({ Text = "> • Pen & Gear Shop Upgrades" })
  addRightSection:AddLabel({ Text = "> • Incubator / Merge Machine Automation" })
  addRightSection:AddDivider("Other Tab")
  addRightSection:AddLabel({ Text = "> • Auto Sell Animals & Eggs + Filters" })
  addRightSection:AddLabel({ Text = "> • WalkSpeed & Bat Kill Aura" })
  addRightSection:AddLabel({ Text = "> • Egg & Animal Drop ESP" })
  addRightSection:AddLabel({ Text = "> • Auto Claim All Rewards" })

  seisenHubWindow:AddSidebarSection("Features")
  local addTab2 = seisenHubWindow:AddTab("Farming", "egg")

  local addLeftSection2 = addTab2:AddLeftSection("Auto Break & Steal", "egg")
  addLeftSection2:AddLabel({ Text = "Select Target Zone" })

  addLeftSection2:AddDropdown({
    Name = "",
    Flag = "BSAE_SelectedZone",
    Default = { "All" },
    Multi = true,
    Options = {
      "All", "Forest Zone", "Desert Zone", "Snowy Zone", "Candy Zone", "Swamp Zone",
      "Ocean Zone", "Hell Zone", "Blossom Zone", "Galaxy Zone",
    },
    Tooltip = "Select target zones to break eggs from",
    Callback = function(value17) getgenv().BSAE_SelectedZone = value17 end,
  })

  addLeftSection2:AddLabel({ Text = "Select Target Rarity" })

  addLeftSection2:AddDropdown({
    Name = "",
    Flag = "BSAE_SelectedRarity",
    Default = { "All" },
    Multi = true,
    Options = {
      "Highest Rarity", "All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic",
      "Divine", "Cosmic", "Secret", "Celestial", "Inferno",
    },
    Tooltip = "Select target egg rarities",
    Callback = function(value18) getgenv().BSAE_SelectedRarity = value18 end,
  })
  addLeftSection2:AddToggle({
    Name = "Auto Break & Steal Egg",
    Flag = "BSAE_AutoBreakStealEgg",
    Default = false,
    Tooltip = "Breaks target eggs, steals animal drops, and delivers them to your base",
    Callback = function(value19) getgenv().BSAE_AutoBreakStealEgg = value19 end,
  })

  addLeftSection2:AddToggle({
    Name = "Focus Biggest Egg First",
    Flag = "BSAE_TargetBiggestEgg",
    Default = false,
    Tooltip = "Targets the egg with the most HP first instead of the nearest egg",
    Callback = function(value20) getgenv().BSAE_TargetBiggestEgg = value20 end,
  })

  addLeftSection2:AddToggle({
    Name = "Auto Place Animal on Pen",
    Flag = "BSAE_AutoPlaceAnimal",
    Default = true,
    Tooltip = "Places banked animals from your inventory onto your pen",
    Callback = function(value21) getgenv().BSAE_AutoPlaceAnimal = value21 end,
  })

  addLeftSection2:AddToggle({
    Name = "Auto Equip Best Animals",
    Flag = "BSAE_AutoEquipBestAnimals",
    Default = false,
    Tooltip = "Automatically equips your best animals in inventory to maximize CPS",
    Callback = function(value22) getgenv().BSAE_AutoEquipBestAnimals = value22 end,
  })

  addLeftSection2:AddDivider("Dropped Pet Stealer")

  addLeftSection2:AddToggle({
    Name = "Auto Steal Dropped Pets",
    Flag = "BSAE_AutoStealDroppedPet",
    Default = false,
    Tooltip = "Teleports to dropped pets matching selected rarities and delivers them to your base",
    Callback = function(value23) getgenv().BSAE_AutoStealDroppedPet = value23 end,
  })

  addLeftSection2:AddLabel({ Text = "Select Steal Pet Rarity" })

  addLeftSection2:AddDropdown({
    Name = "",
    Flag = "BSAE_StealRarities",
    Default = { "All" },
    Multi = true,
    Options = {
      "Highest Rarity", "All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic",
      "Divine", "Cosmic", "Secret", "Celestial", "Inferno",
    },
    Tooltip = "Select which pet rarities to automatically steal",
    Callback = function(value24) getgenv().BSAE_StealRarities = value24 end,
  })

  local addLeftSection3 = addTab2:AddLeftSection("Incubator & Merge", "sparkles")

  addLeftSection3:AddToggle({
    Name = "Auto Place Merge Eggs",
    Flag = "BSAE_AutoPlaceMergeEgg",
    Default = false,
    Tooltip = "Places Merge Eggs from backpack onto your plot's machine",
    Callback = function(value25) getgenv().BSAE_AutoPlaceMergeEgg = value25 end,
  })

  addLeftSection3:AddToggle({
    Name = "Auto Hatch / Open Ready Eggs",
    Flag = "BSAE_AutoHatchMergeEgg",
    Default = false,
    Tooltip = "Automatically claims and hatches placed incubator eggs when ready",
    Callback = function(value26) getgenv().BSAE_AutoHatchMergeEgg = value26 end,
  })

  local addRightSection2 = addTab2:AddRightSection("Treadmill Speed Training", "flame")

  addRightSection2:AddToggle({
    Name = "Auto Treadmill Idle",
    Flag = "BSAE_AutoTreadmillIdle",
    Default = false,
    Tooltip = "Stands on your plot's treadmill to automatically train SpeedPower when idle",
    Callback = function(value27) getgenv().BSAE_AutoTreadmillIdle = value27 end,
  })

  addRightSection2:AddToggle({
    Name = "Auto Unlock Treadmill",
    Flag = "BSAE_AutoUnlockTreadmill",
    Default = false,
    Tooltip = "Automatically unlocks the treadmill when you have 100 Cash",
    Callback = function(value28) getgenv().BSAE_AutoUnlockTreadmill = value28 end,
  })

  addRightSection2:AddToggle({
    Name = "Auto Upgrade Treadmill",
    Flag = "BSAE_AutoUpgradeTreadmill",
    Default = false,
    Tooltip = "Automatically purchases treadmill upgrades when affordable",
    Callback = function(value29) getgenv().BSAE_AutoUpgradeTreadmill = value29 end,
  })

  local addRightSection3 = addTab2:AddRightSection("Upgrades & Shops", "shopping-cart")

  addRightSection3:AddToggle({
    Name = "Auto Upgrade Pen",
    Flag = "BSAE_AutoUpgradePlot",
    Default = false,
    Tooltip = "Automatically upgrades pen capacity when affordable",
    Callback = function(value30) getgenv().BSAE_AutoUpgradePlot = value30 end,
  })

  addRightSection3:AddToggle({
    Name = "Auto Buy Pickaxes",
    Flag = "BSAE_AutoBuyPickaxes",
    Default = false,
    Tooltip = "Automatically buys the best affordable pickaxe from the shop",
    Callback = function(value31) getgenv().BSAE_AutoBuyPickaxes = value31 end,
  })

  addRightSection3:AddToggle({
    Name = "Auto Equip Best Pickaxe",
    Flag = "BSAE_AutoEquipBestPickaxe",
    Default = false,
    Tooltip = "Automatically equips the highest tier owned pickaxe",
    Callback = function(value32) getgenv().BSAE_AutoEquipBestPickaxe = value32 end,
  })

  addRightSection3:AddToggle({
    Name = "Auto Buy Trails",
    Flag = "BSAE_AutoBuyTrails",
    Default = false,
    Tooltip = "Automatically buys the best affordable speed trail from the shop",
    Callback = function(value33) getgenv().BSAE_AutoBuyTrails = value33 end,
  })

  addRightSection3:AddToggle({
    Name = "Auto Equip Best Trail",
    Flag = "BSAE_AutoEquipBestTrail",
    Default = false,
    Tooltip = "Automatically equips the highest owned trail",
    Callback = function(value34) getgenv().BSAE_AutoEquipBestTrail = value34 end,
  })

  local addTab3 = seisenHubWindow:AddTab("Other", "settings")

  local addLeftSection4 = addTab3:AddLeftSection("Inventory & Auto Sell", "backpack")

  addLeftSection4:AddToggle({
    Name = "Auto Sell Animals",
    Flag = "BSAE_AutoSellPets",
    Default = false,
    Tooltip = "Automatically sells animals in backpack matching selected rarities",
    Callback = function(value35) getgenv().BSAE_AutoSellPets = value35 end,
  })

  addLeftSection4:AddToggle({
    Name = "Auto Sell Eggs",
    Flag = "BSAE_AutoSellEggs",
    Default = false,
    Tooltip = "Automatically sells unhatched eggs in backpack matching selected rarities",
    Callback = function(value36) getgenv().BSAE_AutoSellEggs = value36 end,
  })

  addLeftSection4:AddToggle({
    Name = "Auto Sell If Inventory Full",
    Flag = "BSAE_AutoSellIfFull",
    Default = false,
    Tooltip = "Only sells matching animals/eggs when pen or satchel reaches capacity",
    Callback = function(value37) getgenv().BSAE_AutoSellIfFull = value37 end,
  })

  addLeftSection4:AddToggle({
    Name = "Don't Sell Favorites",
    Flag = "BSAE_DontSellFavorite",
    Default = true,
    Tooltip = "Protects favorited pets from being sold",
    Callback = function(value38) getgenv().BSAE_DontSellFavorite = value38 end,
  })

  addLeftSection4:AddLabel({ Text = "Target Sell Rarities" })

  addLeftSection4:AddDropdown({
    Name = "",
    Flag = "BSAE_SellRarities",
    Default = { "Common", "Uncommon" },
    Multi = true,
    Options = {
      "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Cosmic", "Secret",
      "Celestial", "Inferno",
    },
    Tooltip = "Select which rarities to sell",
    Callback = function(value39) getgenv().BSAE_SellRarities = value39 end,
  })

  local addLeftSection5 = addTab3:AddLeftSection("Player & Combat", "user")

  addLeftSection5:AddToggle({
    Name = "Enable WalkSpeed",
    Flag = "BSAE_CustomWalkSpeed",
    Default = false,
    Tooltip = "Overrides character walk speed",
    Callback = function(value40)
      getgenv().BSAE_CustomWalkSpeed = value40
      local v70, v71 = f4()

      if v71 and not value40 then
        v71.WalkSpeed = 18
      end
    end,
  })

  addLeftSection5:AddSlider({
    Name = "WalkSpeed",
    Flag = "BSAE_WalkSpeedValue",
    Min = 18,
    Max = 150,
    Step = 2,
    Default = 50,
    Tooltip = "Adjust movement speed",
    Callback = function(value41) getgenv().BSAE_WalkSpeedValue = value41 end,
  })

  addLeftSection5:AddToggle({
    Name = "Bat Kill Aura",
    Flag = "BSAE_BatKillAura",
    Default = false,
    Tooltip = "Automatically swings your bat at nearby hostiles/guards when equipped",
    Callback = function(value42) getgenv().BSAE_BatKillAura = value42 end,
  })

  local addRightSection4 = addTab3:AddRightSection("Visuals & ESP", "eye")

  addRightSection4:AddToggle({
    Name = "Egg ESP",
    Flag = "BSAE_ShowEggEsp",
    Default = false,
    Tooltip = "Displays floating labels above breakable eggs with type, health, and weight",
    Callback = function(value43)
      getgenv().BSAE_ShowEggEsp = value43

      if not value43 then
        for key2, value44 in pairs(getgenv().BSAE_ActiveEsp) do
          local v72 = value44

          if key2:find("Egg_") then
            pcall(function() v72:Destroy() end)
            getgenv().BSAE_ActiveEsp[key2] = nil
          end
        end
      end
    end,
  })

  addRightSection4:AddToggle({
    Name = "Animal Drop ESP",
    Flag = "BSAE_ShowAnimalEsp",
    Default = false,
    Tooltip = "Displays floating labels above dropped animals with name, weight, and rarity",
    Callback = function(value45)
      getgenv().BSAE_ShowAnimalEsp = value45

      if not value45 then
        for key3, value46 in pairs(getgenv().BSAE_ActiveEsp) do
          local v73 = value46

          if key3:find("Drop_") then
            pcall(function() v73:Destroy() end)
            getgenv().BSAE_ActiveEsp[key3] = nil
          end
        end
      end
    end,
  })

  local addRightSection5 = addTab3:AddRightSection("Rewards", "gift")

  addRightSection5:AddToggle({
    Name = "Auto Claim Index Rewards",
    Flag = "BSAE_AutoClaimIndex",
    Default = false,
    Tooltip = "Automatically claims unlocked pet collection index rewards",
    Callback = function(value47) getgenv().BSAE_AutoClaimIndex = value47 end,
  })

  addRightSection5:AddToggle({
    Name = "Auto Claim Group Reward",
    Flag = "BSAE_AutoClaimGroup",
    Default = false,
    Tooltip = "Automatically claims group chest rewards",
    Callback = function(value48) getgenv().BSAE_AutoClaimGroup = value48 end,
  })

  addRightSection5:AddToggle({
    Name = "Auto Claim Offline Rewards",
    Flag = "BSAE_AutoClaimOffline",
    Default = false,
    Tooltip = "Automatically claims offline earnings",
    Callback = function(value49) getgenv().BSAE_AutoClaimOffline = value49 end,
  })

  task.spawn(function()
    local eggHitRequest = replicatedStorage:FindFirstChild("EggHitRequest")

    while bsaeGeneration == getgenv().BSAE_Generation do
      f12("Main Harvesting & Steal Loop", function()
        local v74, v75, v76 = f4()
        local v77 = v74 and v75 and v76
        local v78

        if v77 then
          local v79 = f13()
          local hitbox3 = v79 and v79:FindFirstChild("Hitbox")
          local carrying = localPlayer:GetAttribute("Carrying")
          local v80 = nil

          if not carrying and getgenv().BSAE_AutoStealDroppedPet and not v13 then
            v80 = f10(v76.Position)
          end

          if carrying and hitbox3 and not v13 then
            local v81 = os.clock()

            while bsaeGeneration == getgenv().BSAE_Generation
              and localPlayer:GetAttribute("Carrying") ~= nil
              and os.clock() - (v81 or os.clock()) < 4 do
              local v82, v83, v84 = f4()

              if v84 then
                v84.CFrame = hitbox3.CFrame * CFrame.new(0, 2, 0)
              end

              task.wait(0.08)
            end

            task.wait(0.15)
            f11(localPlayer.Character, v79, hitbox3)

            if getgenv().BSAE_AutoTreadmillIdle and v79 and not getgenv().BSAE_AutoBreakStealEgg then
              f15(v76, v79)
            end
          elseif v80 and not v13 then
            f18(v80)
          elseif getgenv().BSAE_AutoStealDroppedPet and getgenv().BSAE_AutoTreadmillIdle
            and v79 and not getgenv().BSAE_AutoBreakStealEgg and not v13 then
            f15(v76, v79)
          elseif getgenv().BSAE_AutoBreakStealEgg and not v13 then
            if getgenv().BSAE_AutoPlaceAnimal and v79 and hitbox3 then
              if (v79:GetAttribute("AnimalsPlaced") or 0)
                < (v79:GetAttribute("MaxAnimals") or 8) then
                local backpack2 = localPlayer:FindFirstChildOfClass("Backpack")
                local v85 = false

                if backpack2 then
                  for index16, value50 in ipairs(backpack2:GetChildren()) do
                    if value50:IsA("Tool") and collectionService:HasTag(value50, "AnimalTool") then
                      v85 = true
                      break
                    end
                  end
                end

                if v85 then
                  v76.CFrame = hitbox3.CFrame * CFrame.new(0, 2, 0)
                  task.wait(0.15)
                  f11(localPlayer.Character, v79, hitbox3)
                end
              end
            end

            v78 = f9(v76.Position)

            if v78 and v78.Parent ~= nil then
              f3()
              f6("Pickaxe")
              local position5 = v78.Position
              local v86 = position5 + Vector3.new(0, 1.5, 3.2)

              if (v76.Position - v86).Magnitude > 3 then
                v76.CFrame = CFrame.lookAt(v86, position5)
                task.wait(0.08)
              end

              local health = v78:GetAttribute("Health") or 0
              local v87 = os.clock()
              local v88 = os.clock()

              while true do
                if bsaeGeneration == getgenv().BSAE_Generation
                  and getgenv().BSAE_AutoBreakStealEgg and v78.Parent ~= nil
                  and not v78:GetAttribute("Broken") and not v78:GetAttribute("Hatching")
                  and not v78:GetAttribute("Despawning")
                  and (v78:GetAttribute("Health") or 1) > 0 then
                  local v89, v90, v91 = f4()

                  if v91 and v78.Parent ~= nil then
                    if (v91.Position - v86).Magnitude > 3 then
                      v91.CFrame = CFrame.lookAt(v86, position5)
                    end
                  end

                  if eggHitRequest then
                    pcall(function() eggHitRequest:FireServer(v78) end)
                  end

                  local health2 = v78:GetAttribute("Health") or 0

                  if health2 < health then
                    health = health2
                    v87 = os.clock()
                  end

                  if os.clock() - v87 > 7 or os.clock() - v88 > 60 then
                    v10[v78] = os.clock() + 20
                    break
                  end

                  task.wait(0.18)
                else
                  break
                end
              end

              if v78:GetAttribute("Broken") or v78:GetAttribute("Hatching")
                or (v78:GetAttribute("Health") or 1) <= 0 or v78.Parent == nil then
                local v92 = os.clock()

                while bsaeGeneration == getgenv().BSAE_Generation
                  and getgenv().BSAE_AutoBreakStealEgg and os.clock() - (v92 or os.clock()) < 15 do
                  if localPlayer:GetAttribute("Carrying") ~= nil then
                    break
                  else
                    local v93 = f1(position5, 35)

                    if v93 then
                      local parent6 = v93.Parent

                      local position6 = parent6
                        and (parent6:IsA("BasePart") and parent6.Position
                          or parent6:IsA("Attachment") and parent6.WorldPosition
                          or parent6:IsA("Model") and parent6:GetPivot().Position or nil)

                      if position6 then
                        local v94, v95, v96 = f4()

                        if v96 then
                          v96.CFrame = CFrame.new(position6 + Vector3.new(0, 1.5, 0))
                        end
                      end

                      pcall(function() fireproximityprompt(v93, 0) end)
                      task.wait(0.04)

                      if localPlayer:GetAttribute("Carrying") ~= nil then
                        break
                      end
                    end

                    task.wait(0.08)
                  end
                end
              end

              if localPlayer:GetAttribute("Carrying") ~= nil and hitbox3 then
                local v97 = os.clock()

                while bsaeGeneration == getgenv().BSAE_Generation
                  and localPlayer:GetAttribute("Carrying") ~= nil
                  and os.clock() - (v97 or os.clock()) < 4 do
                  local v98, v99, v100 = f4()

                  if v100 then
                    v100.CFrame = hitbox3.CFrame * CFrame.new(0, 2, 0)
                  end

                  task.wait(0.08)
                end

                task.wait(0.15)
                f11(localPlayer.Character, v79, hitbox3)
              end
            elseif getgenv().BSAE_AutoTreadmillIdle and v79 then
              f15(v76, v79)
            end
          elseif getgenv().BSAE_AutoTreadmillIdle and v79 and not v13 then
            f15(v76, v79)
          end
        end
      end)

      task.wait(0.12)
    end
  end)

  task.spawn(function()
    while bsaeGeneration == getgenv().BSAE_Generation do
      f12("Upgrades & Shop Purchases", function()
        local v101 = f13()
        local cash = localPlayer:GetAttribute("Cash") or 0
        local bsaeAutoUnlockTreadmill = getgenv().BSAE_AutoUnlockTreadmill and v101
        local unlockTreadmillRequest

        if bsaeAutoUnlockTreadmill then
          if not v101:GetAttribute("TreadmillUnlocked") and cash >= 100 then
            unlockTreadmillRequest = replicatedStorage:FindFirstChild("UnlockTreadmillRequest")

            if unlockTreadmillRequest then
              pcall(function() unlockTreadmillRequest:FireServer() end)
            end
          end
        end

        local upgradeTreadmillRequest

        if getgenv().BSAE_AutoUpgradeTreadmill and v101 then
          upgradeTreadmillRequest = replicatedStorage:FindFirstChild("UpgradeTreadmillRequest")

          if upgradeTreadmillRequest then
            pcall(function() upgradeTreadmillRequest:FireServer() end)
          end
        end

        local upgradePlotRequest

        if getgenv().BSAE_AutoUpgradePlot and v101 then
          upgradePlotRequest = replicatedStorage:FindFirstChild("UpgradePlotRequest")

          if upgradePlotRequest then
            pcall(function() upgradePlotRequest:FireServer() end)
          end
        end

        if getgenv().BSAE_AutoEquipBestAnimals then
          f17()
        end

        local pickaxeShopRequest, v102, v103

        if v1 then
          local ownedPickaxes = localPlayer:GetAttribute("OwnedPickaxes") or "1"
          local v104 = { true }

          for match in string.gmatch(ownedPickaxes, "[^,]+") do
            local v105 = tonumber(match)

            if v105 then
              v104[v105] = true
            end
          end

          local pickaxeTier = localPlayer:GetAttribute("PickaxeTier") or 1
          pickaxeShopRequest = replicatedStorage:FindFirstChild("PickaxeShopRequest")

          if getgenv().BSAE_AutoBuyPickaxes and pickaxeShopRequest then
            v102 = nil

            for index17, value51 in ipairs(v1.Tiers) do
              if not v104[index17] and (value51.Price or 0) <= cash then
                v102 = index17
              end
            end

            if v102 then
              pcall(function() pickaxeShopRequest:FireServer("Buy", v102) end)
            end
          end

          if getgenv().BSAE_AutoEquipBestPickaxe and pickaxeShopRequest then
            v103 = 1

            for key4 in pairs(v104) do
              if key4 > v103 then
                v103 = key4
              end
            end

            if v103 > pickaxeTier then
              pcall(function() pickaxeShopRequest:FireServer("Equip", v103) end)
            end
          end
        end

        local trailShopRequest, id, v106

        if v2 then
          local getAttribute = localPlayer:GetAttribute(v2.OwnedAttribute) or ""
          local v107 = {}

          for match2 in string.gmatch(getAttribute, "[^,]+") do
            local v108 = tonumber(match2)

            if v108 then
              v107[v108] = true
            end
          end

          local getAttribute2 = localPlayer:GetAttribute(v2.EquippedAttribute) or 0
          trailShopRequest = replicatedStorage:FindFirstChild("TrailShopRequest")

          if getgenv().BSAE_AutoBuyTrails and trailShopRequest then
            id = nil

            for index18, value52 in ipairs(v2.Trails) do
              if not v107[value52.Id] and (value52.Price or 0) <= cash then
                id = value52.Id
              end
            end

            if id then
              pcall(function() trailShopRequest:FireServer("Buy", id) end)
            end
          end

          if getgenv().BSAE_AutoEquipBestTrail and trailShopRequest then
            v106 = 0

            for key5 in pairs(v107) do
              if key5 > v106 then
                v106 = key5
              end
            end

            if v106 > getAttribute2 and v106 > 0 then
              pcall(function() trailShopRequest:FireServer("Equip", v106) end)
            end
          end
        end
      end)

      task.wait(1.5)
    end
  end)

  task.spawn(function()
    while bsaeGeneration == getgenv().BSAE_Generation do
      f12("Inventory Selling & Merge Loop", function()
        local backpackSellRemote = replicatedStorage:FindFirstChild("BackpackSellRemote")
        local v109 = f13()

        local bsaeAutoSellPets = backpackSellRemote
          and (getgenv().BSAE_AutoSellPets or getgenv().BSAE_AutoSellEggs)

        local v110

        if bsaeAutoSellPets then
          local v111 = true

          if getgenv().BSAE_AutoSellIfFull and v109 then
            v111 = (v109:GetAttribute("AnimalsPlaced") or 0)
              >= (v109:GetAttribute("MaxAnimals") or 8)
          end

          if v111 then
            v110 = {}

            for index19, value53 in ipairs({
              localPlayer:FindFirstChildOfClass("Backpack"), localPlayer.Character,
            }) do
              if value53 then
                for index20, value54 in ipairs(value53:GetChildren()) do
                  if value54:IsA("Tool") then
                    local hasTag = collectionService:HasTag(value54, "AnimalTool")

                    local hasTag2 = collectionService:HasTag(value54, "EggTool")
                      or collectionService:HasTag(value54, "MergeEggTool")

                    if hasTag and getgenv().BSAE_AutoSellPets
                      or hasTag2 and getgenv().BSAE_AutoSellEggs then
                      local rarity = value54:GetAttribute("Rarity") or "Common"
                      local v112 = value54:GetAttribute("Favorite") == true

                      if getgenv().BSAE_SellRarities[rarity]
                        and not (getgenv().BSAE_DontSellFavorite and v112) then
                        table.insert(v110, value54)

                        if #v110 >= 50 then
                          break
                        end
                      end
                    end
                  end
                end
              end

              if #v110 >= 50 then
                break
              end
            end

            if #v110 > 0 then
              pcall(function() backpackSellRemote:InvokeServer(v110) end)
            end
          end
        end

        local mergeMachineRemote2 = replicatedStorage:FindFirstChild("MergeMachineRemote")
        local tool, position7

        if mergeMachineRemote2 and v109 then
          if getgenv().BSAE_AutoPlaceMergeEgg then
            local backpack3 = localPlayer:FindFirstChildOfClass("Backpack")
            tool = backpack3 and backpack3:FindFirstChildWhichIsA("Tool")

            if tool and collectionService:HasTag(tool, "MergeEggTool") then
              local spawnPoint = v109:FindFirstChild("SpawnPoint")

              position7 = spawnPoint and spawnPoint.Position + Vector3.new(0, 0, 5)
                or v109:GetPivot().Position

              pcall(function() mergeMachineRemote2:FireServer("PlaceEgg", tool, position7) end)
            end
          end

          if getgenv().BSAE_AutoHatchMergeEgg then
            f19()
          end
        end
      end)

      task.wait(1.5)
    end
  end)

  task.spawn(function()
    while bsaeGeneration == getgenv().BSAE_Generation do
      f12("Rewards & Combat Loop", function()
        local indexRemote

        if getgenv().BSAE_AutoClaimIndex then
          indexRemote = replicatedStorage:FindFirstChild("IndexRemote")

          if indexRemote then
            pcall(function() indexRemote:FireServer("ClaimAll", nil) end)
          end
        end

        local groupRewardRemote

        if getgenv().BSAE_AutoClaimGroup then
          groupRewardRemote = replicatedStorage:FindFirstChild("GroupRewardRemote")

          if groupRewardRemote then
            pcall(function() groupRewardRemote:FireServer("Claim") end)
          end
        end

        local offlineRewardRemote

        if getgenv().BSAE_AutoClaimOffline then
          offlineRewardRemote = replicatedStorage:FindFirstChild("OfflineRewardRemote")

          if offlineRewardRemote then
            pcall(function() offlineRewardRemote:FireServer("Claim") end)
          end
        end

        local findFirstChild2

        if getgenv().BSAE_BatKillAura and v3 then
          local v113, v114, v115 = f4()

          if v113 and v114 and v115 then
            if v113:FindFirstChild(v3.ToolName)
              or localPlayer.Backpack:FindFirstChild(v3.ToolName) then
              f6(v3.ToolName)
              findFirstChild2 = replicatedStorage:FindFirstChild(v3.HitRemoteName)

              if findFirstChild2 then
                local range = v3.Targeting and v3.Targeting.Range or 15

                for index21, value55 in ipairs(players:GetPlayers()) do
                  if value55 ~= localPlayer then
                    local character4 = value55.Character

                    local humanoidRootPart3 = character4
                      and character4:FindFirstChild("HumanoidRootPart")

                    local humanoid4 = character4
                      and character4:FindFirstChildOfClass("Humanoid")

                    if character4 and humanoidRootPart3 and humanoid4 and humanoid4.Health > 0 then
                      if (humanoidRootPart3.Position - v115.Position).Magnitude <= range then
                        pcall(function() findFirstChild2:FireServer(character4) end)
                        break
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end)

      task.wait(1.5)
    end
  end)

  local connect3 = runService.Heartbeat:Connect(function()
    if bsaeGeneration ~= getgenv().BSAE_Generation then
      return
    end

    if getgenv().BSAE_CustomWalkSpeed then
      local v116, v117 = f4()

      if v117 then
        v117.WalkSpeed = getgenv().BSAE_WalkSpeedValue or 50
      end
    end
  end)

  table.insert(getgenv().BSAE_Connections, connect3)

  task.spawn(function()
    while bsaeGeneration == getgenv().BSAE_Generation do
      f12("Visual ESP Loop", function()
        if getgenv().BSAE_ShowEggEsp then
          for index22, value56 in ipairs((collectionService:GetTagged("BreakableEgg"))) do
            if value56:IsA("BasePart") and value56.Parent ~= nil then
              local v118 = "Egg_" .. tostring(value56:GetDebugId())

              if not (value56:GetAttribute("Broken") or value56:GetAttribute("Hatching")
                or value56:GetAttribute("Despawning")) then
                local v119 = getgenv().BSAE_ActiveEsp[v118]
                local v120 = f5(value56)
                local health3 = value56:GetAttribute("Health") or 0
                local maxHealth = value56:GetAttribute("MaxHealth") or health3
                local weightKg = value56:GetAttribute("WeightKg") or 0
                local eggType2 = value56:GetAttribute("EggType") or "Egg"

                if not v119 or v119.Parent == nil then
                  local bsaeESP = Instance.new("BillboardGui")
                  bsaeESP.Name = "BSAE_ESP"
                  bsaeESP.Size = UDim2.new(0, 160, 0, 40)
                  bsaeESP.AlwaysOnTop = true
                  bsaeESP.Adornee = value56
                  bsaeESP.ExtentsOffset = Vector3.new(0, 2.5, 0)

                  local info = Instance.new("TextLabel")
                  info.Name = "Info"
                  info.Size = UDim2.new(1, 0, 1, 0)
                  info.BackgroundTransparency = 1
                  info.Font = Enum.Font.GothamBold
                  info.TextSize = 12
                  info.TextColor3 = v9[v120] or Color3.fromRGB(255, 255, 255)
                  info.TextStrokeTransparency = 0.2

                  info.Text = string.format([[
[%s]
%s (%d/%d HP)
%.1f Kg]], v120, eggType2, health3, maxHealth, weightKg)

                  info.Parent = bsaeESP

                  bsaeESP.Parent = value56
                  getgenv().BSAE_ActiveEsp[v118] = bsaeESP
                else
                  local info2 = v119:FindFirstChild("Info")

                  if info2 then
                    info2.Text = string.format([[
[%s]
%s (%d/%d HP)
%.1f Kg]], v120, eggType2, health3, maxHealth, weightKg)

                    info2.TextColor3 = v9[v120] or Color3.fromRGB(255, 255, 255)
                  end
                end
              elseif getgenv().BSAE_ActiveEsp[v118] then
                pcall(function() getgenv().BSAE_ActiveEsp[v118]:Destroy() end)
                getgenv().BSAE_ActiveEsp[v118] = nil
              end
            end
          end
        end

        if getgenv().BSAE_ShowAnimalEsp then
          local animalPickups = workspaceService:FindFirstChild("AnimalPickups")

          if animalPickups then
            for index23, value57 in ipairs(animalPickups:GetChildren()) do
              if value57:IsA("Model") then
                local primaryPart = value57.PrimaryPart

                local basePart = primaryPart
                basePart = primaryPart or value57:FindFirstChildWhichIsA("BasePart")

                if basePart then
                  local v121 = "Drop_" .. tostring(value57:GetDebugId())
                  local v122 = getgenv().BSAE_ActiveEsp[v121]
                  local animalName = value57:GetAttribute("AnimalName") or value57.Name
                  local rarity2 = value57:GetAttribute("Rarity") or "Common"
                  local weightKg2 = value57:GetAttribute("WeightKg") or 0

                  if not v122 or v122.Parent == nil then
                    local bsaeDropESP = Instance.new("BillboardGui")
                    bsaeDropESP.Name = "BSAE_DropESP"
                    bsaeDropESP.Size = UDim2.new(0, 140, 0, 30)
                    bsaeDropESP.AlwaysOnTop = true
                    bsaeDropESP.Adornee = basePart
                    bsaeDropESP.ExtentsOffset = Vector3.new(0, 2, 0)

                    local info3 = Instance.new("TextLabel")
                    info3.Name = "Info"
                    info3.Size = UDim2.new(1, 0, 1, 0)
                    info3.BackgroundTransparency = 1
                    info3.Font = Enum.Font.GothamBold
                    info3.TextSize = 12
                    info3.TextColor3 = v9[rarity2] or Color3.fromRGB(255, 255, 255)
                    info3.TextStrokeTransparency = 0.2

                    info3.Text = string.format(
                      "★ %s [%s]\n%.1f Kg", animalName, rarity2, weightKg2
                    )

                    info3.Parent = bsaeDropESP

                    bsaeDropESP.Parent = basePart
                    getgenv().BSAE_ActiveEsp[v121] = bsaeDropESP
                  end
                end
              end
            end
          end
        end
      end)

      task.wait(1)
    end
  end)

  seisenUINew:Notify({
    Title = "Hub",
    Content = [[
Break and Steal an Egg
Left Alt to toggle UI.]],
    Duration = 5,
  })

  seisenUINew:OnUnload(function()
    getgenv().BSAE_Generation = (getgenv().BSAE_Generation or 0) + 1

    for index24, value58 in ipairs(getgenv().BSAE_Connections) do
      local v123 = value58
      pcall(function() v123:Disconnect() end)
    end

    table.clear(getgenv().BSAE_Connections)

    for key6, value59 in pairs(getgenv().BSAE_ActiveEsp) do
      local v124 = value59
      pcall(function() v124:Destroy() end)
    end

    table.clear(getgenv().BSAE_ActiveEsp)
    local v125, v126 = f4()

    if v126 then
      v126.WalkSpeed = 18
    end
  end)

  return
end
