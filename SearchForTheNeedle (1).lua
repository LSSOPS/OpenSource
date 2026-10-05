local HubName = "Kyrenox Hub"
local ScriptName = "Search For The Needle by " .. HubName
local gameName = "Chapter 1 (FARMHOUSE)"
local FollowLink = "https://rscripts.net/@_LSS"

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer

local Unloaded = false
local State = {}
local Registry = {}

local ThemeName = "Dark"
pcall(function()
    WindUI:AddTheme({
        Name = "Needle",
        Accent = "#282828",
        Dialog = "#161616",
        Outline = "#5865F2",
        Text = "#FFFFFF",
        Placeholder = "#8A8A8A",
        Background = "#0D0D0D",
        Button = "#3A3A3A",
        Icon = "#C9CCFF",
    })
    ThemeName = "Needle"
end)

local Window = WindUI:CreateWindow({
    Title = "Search For The Needle",
    Author = "by " .. HubName,
    Icon = "search",
    Folder = "KyrenoxHub",
    Size = UDim2.fromOffset(640, 480),
    Theme = ThemeName,
    Transparent = false,
    Resizable = true,
    SideBarWidth = 200,
    HideSearchBar = true,
})

pcall(function() Window:SetToggleKey(Enum.KeyCode.RightShift) end)
pcall(function()
    Window:EditOpenButton({
        Title = "Search For The Needle",
        Icon = "search",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 2,
        Color = ColorSequence.new(Color3.fromHex("#5865F2"), Color3.fromHex("#8EA1FF")),
        OnlyMobile = false,
        Enabled = true,
        Draggable = true,
    })
end)
pcall(function() Window:Tag({ Title = gameName, Color = Color3.fromHex("#5865F2") }) end)

local ConfigManager = Window.ConfigManager

local function Notify(title, content, duration, icon)
    pcall(function()
        WindUI:Notify({ Title = title, Content = content, Duration = duration or 3, Icon = icon })
    end)
end

local function Header(tab, title)
    pcall(function() tab:Section({ Title = title }) end)
end

local function Info(tab, text)
    return tab:Paragraph({ Title = text })
end

local function AddToggle(tab, key, title, default, desc)
    State[key] = default and true or false
    local el = tab:Toggle({
        Title = title,
        Desc = desc,
        Value = State[key],
        Callback = function(v) State[key] = v end,
    })
    Registry[key] = el
    return el
end

local function AddSlider(tab, key, title, min, max, default, step, desc)
    State[key] = default
    local el = tab:Slider({
        Title = title,
        Desc = desc,
        Step = step or 1,
        Value = { Min = min, Max = max, Default = default },
        Callback = function(v) State[key] = tonumber(v) or default end,
    })
    Registry[key] = el
    return el
end

local NeedleHaystack = ReplicatedStorage:WaitForChild("NeedleHaystack")
local GameConfig = require(NeedleHaystack:WaitForChild("Config"))
local UpgradeConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Configs"):WaitForChild("UpgradeConfig"))
local BuyUpgrade = NeedleHaystack:WaitForChild("BuyUpgrade")
local BuyShopItem = NeedleHaystack:WaitForChild("BuyShopItem")
local PickHay = NeedleHaystack:WaitForChild("PickHay")
local PickDroppedHay = NeedleHaystack:WaitForChild("PickDroppedHay")
local SellHay = NeedleHaystack:WaitForChild("SellHay")
local CollectGem = NeedleHaystack:WaitForChild("CollectGem")
local DeployDrone = NeedleHaystack:WaitForChild("DeployDrone")
local PitchforkDig = NeedleHaystack:WaitForChild("PitchforkDig")
local TntAction = NeedleHaystack:WaitForChild("TntAction")
local VacuumAction = NeedleHaystack:WaitForChild("VacuumAction")
local NeedleHandIn = NeedleHaystack:WaitForChild("NeedleHandIn")

local BarnShop = Workspace:WaitForChild("BarnShop")
local DroppedHayFolder = Workspace:FindFirstChild("DroppedHay")
local GemsClientFolder = Workspace:FindFirstChild("GemsClient")

local function getCash()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    local cash = ls and ls:FindFirstChild("Cash")
    return cash and cash.Value or 0
end

local function getGems()
    return tonumber(LocalPlayer:GetAttribute("Gems")) or 0
end

local function getHayHeld()
    local v = LocalPlayer:GetAttribute("HayHeld")
    if v ~= nil then return tonumber(v) or 0 end
    return 0
end

local function getHayCapacity()
    return tonumber(LocalPlayer:GetAttribute("HayCapacity")) or 25
end

local function owns(attr)
    return LocalPlayer:GetAttribute(attr) == true
end

local function getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function findClosestHay()
    local hrp = getHRP()
    if not hrp then return nil end
    local best, bestDist = nil, math.huge

    for _, inst in ipairs(Workspace:GetDescendants()) do
        if inst:GetAttribute("HayId") and inst:IsA("BasePart") and inst.Parent then
            local d = (inst.Position - hrp.Position).Magnitude
            if d < bestDist and d < 30 then
                bestDist = d
                best = inst
            end
        end
    end
    return best
end

local function getGrabCandidates(centerPart)

    local radius = tonumber(LocalPlayer:GetAttribute("HayGrabRadius")) or 0
    if radius <= 0 then return {} end
    local out = {}
    if not centerPart then return out end
    local cp = centerPart.Position
    for _, inst in ipairs(Workspace:GetDescendants()) do
        if inst ~= centerPart and inst:GetAttribute("HayId") and inst:IsA("BasePart") then
            if (inst.Position - cp).Magnitude <= radius + 1 then
                table.insert(out, inst:GetAttribute("HayId"))
                if #out >= 6 then break end
            end
        end
    end
    return out
end

local function findClosestDropped()
    if not DroppedHayFolder then DroppedHayFolder = Workspace:FindFirstChild("DroppedHay") end
    if not DroppedHayFolder then return nil end
    local hrp = getHRP()
    if not hrp then return nil end
    local best, bestDist = nil, 28
    for _, m in ipairs(DroppedHayFolder:GetChildren()) do
        local part = m:IsA("BasePart") and m or m:FindFirstChildWhichIsA("BasePart")
        if part then
            local d = (part.Position - hrp.Position).Magnitude
            if d < bestDist then
                bestDist = d
                best = part.Parent:IsA("BasePart") and part.Parent or m
            end
        end
    end
    return best
end

local function findClosestGem()
    if not GemsClientFolder then GemsClientFolder = Workspace:FindFirstChild("GemsClient") end
    local root = GemsClientFolder or Workspace
    local hrp = getHRP()
    if not hrp then return nil end
    local best, bestDist, bestId = nil, 35, nil
    for _, mdl in ipairs(root:GetDescendants()) do
        if mdl:IsA("BasePart") and mdl:GetAttribute("GemId") then
            local d = (mdl.Position - hrp.Position).Magnitude
            if d < bestDist then
                bestDist = d
                best = mdl
                bestId = mdl:GetAttribute("GemId")
            end
        end
    end
    if best and bestId then return best, bestId end

    for _, mdl in ipairs(Workspace:GetDescendants()) do
        if mdl:GetAttribute("GemId") and mdl:IsA("BasePart") then
            local d = (mdl.Position - hrp.Position).Magnitude
            if d < bestDist then
                bestDist = d
                best = mdl
                bestId = mdl:GetAttribute("GemId")
            end
        end
    end
    if best then return best, bestId end
    return nil, nil
end

local function isBagFull()
    return getHayHeld() >= getHayCapacity()
end

local function getNearestSellPart()
    local camPos = Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.Position
        or (LocalPlayer.Character and LocalPlayer.Character:GetPivot().Position or Vector3.new(0, 0, 0))
    local best, bestDist = nil, math.huge
    for _, part in ipairs(CollectionService:GetTagged(GameConfig.SELL_PART_NAME)) do
        if part:IsA("BasePart") and part:IsDescendantOf(Workspace) then
            local d = (part.Position - camPos).Magnitude

            local hrp = getHRP()
            if hrp then
                local cd = (part.Position - hrp.Position).Magnitude
                d = math.min(d, cd)
            end
            if d < bestDist then
                bestDist = d
                best = part
            end
        end
    end
    if not best then

        local sellModel = Workspace:FindFirstChild("SellModel")
        if sellModel then
            for _, inst in ipairs(sellModel:GetDescendants()) do
                if inst.Name == "SellPart" and inst:IsA("BasePart") then
                    return inst
                end
            end
        end
    end
    return best
end

local function trySell()
    local hrp = getHRP()
    local sellPart = getNearestSellPart()
    if hrp and sellPart then
        local dist = (hrp.Position - sellPart.Position).Magnitude
        if dist > 14 then

            hrp.CFrame = sellPart.CFrame + Vector3.new(0, 3, 2)

            if Workspace.CurrentCamera then
                Workspace.CurrentCamera.CFrame = CFrame.lookAt(Workspace.CurrentCamera.CFrame.Position, sellPart.Position)
            end
            task.wait(0.25)
        else

            if Workspace.CurrentCamera then
                pcall(function()
                    Workspace.CurrentCamera.CFrame = CFrame.lookAt(Workspace.CurrentCamera.CFrame.Position, sellPart.Position)
                end)
            end
            task.wait(0.05)
        end
    end
    local ok, err = pcall(function() SellHay:FireServer() end)
    if not ok then
        Notify("Sell Failed", tostring(err), 2, "x")
    end

    task.spawn(function()
        local before = getHayHeld()
        task.wait(0.6)
        if before > 0 and getHayHeld() == before and hrp and sellPart then
            hrp.CFrame = sellPart.CFrame + Vector3.new(0, 4, 0)
            task.wait(0.2)
            pcall(function() SellHay:FireServer() end)
        end
    end)

    task.spawn(function()
        task.wait(1.0)
        local needReturn = false
        if State.AutoPickHay then needReturn = true end
        if State.AutoCollectDroppedHay then needReturn = true end
        if State.AutoCollectGems then needReturn = true end
        if State.AutoVacuumCollect then needReturn = true end
        if State.AutoVacuum then needReturn = true end
        if State.AutoUsePitchfork then needReturn = true end
        if State.AutoFindNeedle then needReturn = true end
        if needReturn and getHayHeld() == 0 then
            local pile = GameConfig.PILE_CENTER
            local hrp2 = getHRP()
            if hrp2 and (hrp2.Position - pile).Magnitude > 22 then
                hrp2.CFrame = CFrame.new(pile + Vector3.new(math.random(-2, 2), 5, math.random(-2, 2)))
                if Workspace.CurrentCamera then
                    Workspace.CurrentCamera.CFrame = CFrame.new(hrp2.Position + Vector3.new(0, 4, 0), pile)
                end
            end
        end
    end)
end

local function waitInterval(optName, fallback)
    return tonumber(State[optName]) or fallback
end

local function ensureNearPileForPick()
    local pile = GameConfig.PILE_CENTER
    local hrp = getHRP()
    if not hrp then return end
    local distToPile = (hrp.Position - pile).Magnitude
    if distToPile > 28 then
        hrp.CFrame = CFrame.new(pile + Vector3.new(math.random(-3, 3), 5, math.random(-3, 3)))
        if Workspace.CurrentCamera then
            Workspace.CurrentCamera.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 4, 0), pile)
        end
        task.wait(0.25)
    end
end

local function teleportToPart(part, yOffset)
    local hrp = getHRP()
    if not hrp or not part then return end
    local dist = (hrp.Position - part.Position).Magnitude
    if dist > 15 then
        hrp.CFrame = part.CFrame + Vector3.new(0, yOffset or 4, 1.5)
        if Workspace.CurrentCamera then
            pcall(function() Workspace.CurrentCamera.CFrame = CFrame.lookAt(Workspace.CurrentCamera.CFrame.Position, part.Position) end)
        end
        task.wait(0.18)
    else
        if Workspace.CurrentCamera then
            pcall(function() Workspace.CurrentCamera.CFrame = CFrame.lookAt(Workspace.CurrentCamera.CFrame.Position, part.Position) end)
        end
    end
end

local function tryBuyTrack(trackName)

    local track = GameConfig.UPGRADE_TRACKS[trackName]
    if not track then return end
    local cur = tonumber(LocalPlayer:GetAttribute("HayUpgrade" .. trackName)) or 1
    if cur >= #track.Levels then return end
    local nxt = track.Levels[cur + 1]
    if not nxt then return end
    local cost = nxt.Cost or 0
    if getCash() >= cost then
        pcall(function() BuyUpgrade:FireServer(trackName) end)
    end
end

local function tryBuyPermanent(id)
    local u = UpgradeConfig.getUpgrade(id)
    if not u then return end
    local cur = tonumber(LocalPlayer:GetAttribute("Upgrade" .. id)) or 0
    local max = UpgradeConfig.getMaxLevel(u)
    if cur >= max then return end
    local price = UpgradeConfig.getPrice(u, cur)
    if price and getGems() >= price then
        pcall(function() BuyUpgrade:FireServer(id) end)
    end
end

local function doUnload()
    if Unloaded then return end
    Unloaded = true
    pcall(function() VacuumAction:FireServer("Stop") end)
    print("[" .. HubName .. "] Unloaded - " .. gameName)
end

pcall(function() Window:OnDestroy(doUnload) end)

local MainTab = Window:Tab({ Title = "Main", Icon = "house" })

pcall(function() Window:Divider() end)

local FarmingSection = Window:Section({ Title = "Farming", Icon = "wheat", Opened = true })
local CollectingTab = FarmingSection:Tab({ Title = "Collecting", Icon = "wheat" })
local SellingTab = FarmingSection:Tab({ Title = "Selling", Icon = "coins" })
local ToolsTab = FarmingSection:Tab({ Title = "Tools", Icon = "hammer" })
local NeedleTab = FarmingSection:Tab({ Title = "Needle", Icon = "search" })

local InventorySection = Window:Section({ Title = "Inventory", Icon = "backpack", Opened = true })
local ShopTab = InventorySection:Tab({ Title = "Shop Items", Icon = "shopping-cart" })
local UpgradesTab = InventorySection:Tab({ Title = "Upgrades", Icon = "trending-up" })

pcall(function() Window:Divider() end)

local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

do
    Header(MainTab, "Dashboard")
    Info(MainTab, "Game: " .. gameName)
    Info(MainTab, "Hub: " .. HubName)
    Info(MainTab, "Credits: @ronzy.exe")
    Info(MainTab, "Toggle UI: RightShift")
    local sessionPara = MainTab:Paragraph({ Title = "Session", Desc = "0s elapsed" })
    MainTab:Button({
        Title = "Copy Follow Link",
        Desc = FollowLink,
        Callback = function()
            if setclipboard then setclipboard(FollowLink) end
            Notify("Copied", "Paste the link into your browser to follow me", 3, "check")
        end,
    })

    task.spawn(function()
        local s = 0
        while true do
            task.wait(1)
            if Unloaded then break end
            s += 1
            pcall(function()
                sessionPara:SetDesc(string.format(
                    "Session: %dm %ds | Cash: $%s | Gems: %s | Hay: %d/%d",
                    s // 60, s % 60, tostring(getCash()), tostring(getGems()), getHayHeld(), getHayCapacity()
                ))
            end)
        end
    end)

    Header(MainTab, "Status")
    Info(MainTab, "Farming, Inventory tabs hold all automation.")
    Info(MainTab, "Settings holds Config & Anti-AFK.")
end

do
    Header(CollectingTab, "Resource Collecting")
    AddToggle(CollectingTab, "AutoPickHay", "Auto Pick Hay", false, "Pick hay from stack continuously")
    AddToggle(CollectingTab, "AutoCollectDroppedHay", "Auto Collect Dropped Hay", false)
    AddToggle(CollectingTab, "AutoCollectGems", "Auto Collect Gems", false)
    AddToggle(CollectingTab, "AutoVacuumCollect", "Auto Vacuum Collect", false, "Uses Vacuum Start/Stop (requires Vacuum tool)")
    AddSlider(CollectingTab, "CollectInterval", "Loop Interval (s)", 0.1, 3, 1, 0.1)
    Info(CollectingTab, "Vacuum needs VacuumOwned. Gems within 35 studs.")

    Header(CollectingTab, "Collecting Stats")
    Info(CollectingTab, "HandHold, Speed & Grab affect manual speed.")
    Info(CollectingTab, "Capacity limits auto loops; auto-sell avoids full.")
end

do
    Header(SellingTab, "Selling")
    AddToggle(SellingTab, "AutoSellHay", "Auto Sell Hay", false)
    AddSlider(SellingTab, "SellThreshold", "Sell When Hay >=", 1, 250, 25, 1)
    AddToggle(SellingTab, "SellOnlyIfFull", "Only Sell If Full", false)
    Info(SellingTab, "Fires SellHay:FireServer() near cow. No distance check server-side.")

    Header(SellingTab, "Sell Info")
    Info(SellingTab, "Sell logic: if HayHeld >= Threshold then Sell. Full overrides.")
    Info(SellingTab, "VacuumLoad also counts as held.")
end

do
    Header(ToolsTab, "Auto Tool Usage")
    AddToggle(ToolsTab, "AutoUseTNT", "Auto Use TNT", false, "Light & throw TNT on cooldown")
    AddToggle(ToolsTab, "AutoUsePitchfork", "Auto Use Pitchfork", false)
    AddToggle(ToolsTab, "AutoDeployDrone", "Auto Deploy Drone", false)
    AddToggle(ToolsTab, "AutoVacuum", "Auto Vacuum (Loop)", false)
    AddSlider(ToolsTab, "ToolInterval", "Tool Interval (s)", 0.2, 5, 1, 0.1)

    Header(ToolsTab, "Requirements")
    Info(ToolsTab, "PitchforkOwned, TntOwned, DroneOwned, VacuumOwned required per tool.")
    Info(ToolsTab, "TNT cooldown & vacuum heat managed by server; script respects 1s loop.")
    ToolsTab:Button({
        Title = "Equip Pitchfork (Slot 3)",
        Callback = function()
            pcall(function() Workspace.CurrentCamera.CFrame = Workspace.CurrentCamera.CFrame end)
        end,
    })
end

do
    Header(NeedleTab, "Needle")
    AddToggle(NeedleTab, "AutoFindNeedle", "Auto Find Needle", false, "Continuously pick around pile center to reveal needle")
    AddToggle(NeedleTab, "AutoHandInNeedle", "Auto Hand In Needle", false, "Fires NeedleHandIn when near NPC")
    AddSlider(NeedleTab, "NeedleInterval", "Needle Interval (s)", 0.2, 3, 1, 0.1)

    Header(NeedleTab, "How Needle Works")
    Info(NeedleTab, "Needle spawns under hay. Removing hay reveals it. Hand in at farmer.")
    Info(NeedleTab, "Pile center from Config.PILE_CENTER used for automation.")
end

do
    Header(ShopTab, "Purchasing")
    State.BuyToolsList = { "Pitchfork" }
    local buyDropdown = ShopTab:Dropdown({
        Title = "Buy Tools Selection",
        Values = { "Pitchfork", "TNT", "Drone", "Vacuum", "Infinite Bag", "Capacity Bag" },
        Value = { "Pitchfork" },
        Multi = true,
        AllowNone = true,
        Callback = function(v) State.BuyToolsList = v end,
    })
    Registry.BuyToolsList = buyDropdown
    AddToggle(ShopTab, "AutoBuyTools", "Auto Buy Selected Tools", false)
    AddSlider(ShopTab, "BuyInterval", "Buy Interval (s)", 0.5, 5, 1, 0.1)
    Info(ShopTab, "Pitchfork=Tnt=Drone=Vacuum=InfiniteBag via BuyShopItem. Capacity Bag via BuyUpgrade:Capacity.")

    Header(ShopTab, "Ownership")
    Info(ShopTab, "Ownership attributes: PitchforkOwned, TntOwned, DroneOwned, VacuumOwned, InfiniteBagOwned")
    ShopTab:Button({
        Title = "Check Ownership",
        Callback = function()
            local t = {}
            for _, k in ipairs({ "PitchforkOwned", "TntOwned", "DroneOwned", "VacuumOwned", "InfiniteBagOwned", "HayUpgradeCapacity" }) do
                table.insert(t, k .. ": " .. tostring(LocalPlayer:GetAttribute(k)))
            end
            Notify("Ownership", table.concat(t, "\n"), 4)
        end,
    })
end

do
    Header(UpgradesTab, "Permanent (Gems)")
    AddToggle(UpgradesTab, "UpgBagSize", "Auto Upgrade Bag Size", false, "ExtraHoldAmount -> Gems 25,50,75,100,150,450")
    AddToggle(UpgradesTab, "UpgExtraTake", "Auto Upgrade Hand Grab Amount", false, "ExtraTakeAmount Gems")
    AddToggle(UpgradesTab, "UpgGemValue", "Auto Upgrade Gem Value", false)
    AddToggle(UpgradesTab, "UpgHayValue", "Auto Upgrade Hay Value", false)
    AddSlider(UpgradesTab, "PermInterval", "Permanent Loop (s)", 0.5, 5, 1, 0.1)
    Info(UpgradesTab, "Currency: Gems. Permanent lobby multiplier.")

    Header(UpgradesTab, "Hand Upgrades (Cash)")
    AddToggle(UpgradesTab, "UpgHandSpeed", "Auto Hand Speed", false, "Speed track 0.55->0.3")
    AddToggle(UpgradesTab, "UpgHandGrab", "Auto Hand Grasp", false)
    AddToggle(UpgradesTab, "UpgHandHold", "Auto Hand Hold", false)

    Header(UpgradesTab, "TNT Upgrades")
    AddToggle(UpgradesTab, "UpgTntLuck", "Auto TNT Lucky Blast", false)
    AddToggle(UpgradesTab, "UpgTntCooldown", "Auto TNT Cooldown", false)
    AddToggle(UpgradesTab, "UpgTntPower", "Auto TNT Power", false)

    Header(UpgradesTab, "Pitchfork Upgrades")
    AddToggle(UpgradesTab, "UpgPitchCooldown", "Auto Pitchfork Cooldown", false)
    AddToggle(UpgradesTab, "UpgPitchHold", "Auto Pitchfork Hold", false)
    AddToggle(UpgradesTab, "UpgPitchSweep", "Auto Pitchfork Sweep", false)

    Header(UpgradesTab, "Drone Upgrades")
    AddToggle(UpgradesTab, "UpgDroneSpeed", "Auto Drone Speed", false)
    AddToggle(UpgradesTab, "UpgDroneGrab", "Auto Drone Grasp", false)
    AddToggle(UpgradesTab, "UpgDroneCapacity", "Auto Drone Capacity", false)

    Header(UpgradesTab, "Vacuum Upgrades")
    AddToggle(UpgradesTab, "UpgVacPower", "Auto Vacuum Power", false)
    AddToggle(UpgradesTab, "UpgVacCooling", "Auto Vacuum Cooling", false)
    AddToggle(UpgradesTab, "UpgVacRuntime", "Auto Vacuum Runtime", false)

    Header(UpgradesTab, "Capacity")
    AddToggle(UpgradesTab, "UpgCapacity", "Auto Upgrade Carry Capacity", false, "25->250 cash upgrades")
    Info(UpgradesTab, "Cash upgrades: use BuyUpgrade with track names. Check affordability via getCash().")
end

do

    Header(SettingsTab, "Menu")
    SettingsTab:Keybind({
        Title = "Menu keybind",
        Value = "RightShift",
        Callback = function(v)
            pcall(function()
                local key = typeof(v) == "EnumItem" and v or Enum.KeyCode[v]
                Window:SetToggleKey(key)
            end)
        end,
    })

    pcall(function()
        local names = {}
        for name in pairs(WindUI:GetThemes()) do table.insert(names, name) end
        table.sort(names)
        if #names > 0 then
            SettingsTab:Dropdown({
                Title = "Theme",
                Values = names,
                Value = ThemeName,
                Callback = function(v) pcall(function() WindUI:SetTheme(v) end) end,
            })
        end
    end)

    if typeof(Window.ToggleTransparency) == "function" then
        SettingsTab:Toggle({
            Title = "Transparency",
            Value = false,
            Callback = function(v) pcall(function() Window:ToggleTransparency(v) end) end,
        })
    end

    if typeof(Window.SetUIScale) == "function" then
        SettingsTab:Slider({
            Title = "DPI Scale (%)",
            Step = 1,
            Value = { Min = 50, Max = 200, Default = 100 },
            Callback = function(v) pcall(function() Window:SetUIScale((tonumber(v) or 100) / 100) end) end,
        })
    end

    SettingsTab:Button({
        Title = "Unload",
        Callback = function()
            doUnload()
            pcall(function() Window:Destroy() end)
        end,
    })

    Header(SettingsTab, "System")
    AddToggle(SettingsTab, "AntiAFK", "Anti-AFK (jump every 5m)", true, "Enabled by default. Uses jump to keep alive.")
    AddToggle(SettingsTab, "AutoRejoin", "Notify On Rejoin", false)

    Header(SettingsTab, "Config")
    local configName = "default"

    local function buildConfig(name)
        local cfg = ConfigManager:CreateConfig(name)
        for key, el in pairs(Registry) do
            cfg:Register(key, el)
        end
        return cfg
    end

    local function listConfigs()
        local out = {}
        pcall(function()
            for _, n in ipairs(ConfigManager:AllConfigs()) do
                table.insert(out, (tostring(n):gsub("%.json$", "")))
            end
        end)
        if #out == 0 then out = { "default" } end
        return out
    end

    if ConfigManager then
        SettingsTab:Input({
            Title = "Config Name",
            Desc = "Save as 'default' to auto-load on start.",
            Value = configName,
            Placeholder = "default",
            Callback = function(v)
                if v and v ~= "" then configName = v end
            end,
        })

        local configDropdown = SettingsTab:Dropdown({
            Title = "Saved Configs",
            Values = listConfigs(),
            Value = "default",
            Callback = function(v) configName = v end,
        })

        SettingsTab:Button({
            Title = "Save Config",
            Callback = function()
                local ok, err = pcall(function() buildConfig(configName):Save() end)
                if ok then
                    Notify("Config", "Saved: " .. configName, 2, "check")
                    pcall(function() configDropdown:Refresh(listConfigs()) end)
                else
                    Notify("Config", "Save failed: " .. tostring(err), 3, "x")
                end
            end,
        })

        SettingsTab:Button({
            Title = "Load Config",
            Callback = function()
                local ok, err = pcall(function() buildConfig(configName):Load() end)
                if ok then
                    Notify("Config", "Loaded: " .. configName, 2, "check")
                else
                    Notify("Config", "Load failed: " .. tostring(err), 3, "x")
                end
            end,
        })

        SettingsTab:Button({
            Title = "Refresh Config List",
            Callback = function()
                pcall(function() configDropdown:Refresh(listConfigs()) end)
            end,
        })
    else
        Info(SettingsTab, "Config manager is not available in this WindUI build.")
    end
end

task.spawn(function()
    while true do
        task.wait(waitInterval("CollectInterval", 1))
        if Unloaded then break end
        if State.AutoPickHay then
            if not isBagFull() then
                local hay = findClosestHay()
                if not hay then
                    ensureNearPileForPick()
                    hay = findClosestHay()
                end
                if hay then
                    teleportToPart(hay, 4)
                    local id = hay:GetAttribute("HayId")
                    if id then
                        local candidates = getGrabCandidates(hay)
                        pcall(function() PickHay:FireServer(id, candidates) end)
                    else
                        pcall(function() PickDroppedHay:FireServer(hay) end)
                    end
                else
                    ensureNearPileForPick()
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(waitInterval("CollectInterval", 1))
        if Unloaded then break end
        if State.AutoCollectDroppedHay then
            if not isBagFull() then
                local d = findClosestDropped()
                if not d then
                    ensureNearPileForPick()
                    d = findClosestDropped()
                end
                if d then
                    local part = d:IsA("BasePart") and d or d:FindFirstChildWhichIsA("BasePart")
                    if part then teleportToPart(part, 3) end
                    pcall(function() PickDroppedHay:FireServer(d) end)
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(waitInterval("CollectInterval", 1))
        if Unloaded then break end
        if State.AutoCollectGems then
            local gemPart, id = findClosestGem()
            if not gemPart then
                ensureNearPileForPick()
                gemPart, id = findClosestGem()
            end
            if gemPart and id then
                teleportToPart(gemPart, 3)
                pcall(function() CollectGem:FireServer(id) end)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if Unloaded then break end
        if State.AutoSellHay then
            local held = getHayHeld()
            local thresh = tonumber(State.SellThreshold) or 25
            local should
            if State.SellOnlyIfFull then
                should = isBagFull()
            else
                should = held >= thresh
            end
            if should and held > 0 then trySell() end
        end
    end
end)

do
    local vacActive = false
    task.spawn(function()
        while true do
            task.wait(waitInterval("CollectInterval", 1))
            if Unloaded then break end
            local should = State.AutoVacuumCollect or State.AutoVacuum
            if should and owns("VacuumOwned") then
                if not vacActive and not isBagFull() then

                    local hay = findClosestHay()
                    if not hay then ensureNearPileForPick() hay = findClosestHay() end
                    if hay then teleportToPart(hay, 5) end
                    pcall(function() VacuumAction:FireServer("Start") end)
                    vacActive = true
                elseif isBagFull() and vacActive then
                    pcall(function() VacuumAction:FireServer("Stop") end)
                    vacActive = false
                    trySell()
                end
            else
                if vacActive then
                    pcall(function() VacuumAction:FireServer("Stop") end)
                    vacActive = false
                end
            end

            if vacActive and LocalPlayer:GetAttribute("VacuumOverheated") then
                pcall(function() VacuumAction:FireServer("Stop") end)
                vacActive = false
                task.wait(0.5)
                ensureNearPileForPick()
            end
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(waitInterval("ToolInterval", 1))
        if Unloaded then break end
        if State.AutoUseTNT and owns("TntOwned") then
            local ok = not LocalPlayer:GetAttribute("NeedleInputLocked")
            if ok then
                pcall(function() TntAction:FireServer("light") end)
                task.wait(0.4)
                local cam = Workspace.CurrentCamera
                if cam then
                    local dir = cam.CFrame.LookVector * 40 + Vector3.new(0, 8, 0)
                    local cf = cam.CFrame
                    pcall(function() TntAction:FireServer("throw", cf, dir) end)
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(waitInterval("ToolInterval", 1))
        if Unloaded then break end
        if State.AutoUsePitchfork and owns("PitchforkOwned") then
            local hay = findClosestHay()
            if not hay then ensureNearPileForPick() hay = findClosestHay() end
            if hay then teleportToPart(hay, 4) end
            local id = hay and hay:GetAttribute("HayId")
            if id then
                pcall(function() PitchforkDig:FireServer(id) end)
            else
                local fakeId = LocalPlayer:GetAttribute("HoveredHayId")
                if fakeId then

                    ensureNearPileForPick()
                    pcall(function() PitchforkDig:FireServer(fakeId) end)
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(waitInterval("ToolInterval", 1))
        if Unloaded then break end
        if State.AutoDeployDrone and owns("DroneOwned") then
            if not LocalPlayer:GetAttribute("DroneDeployed") then
                pcall(function() DeployDrone:FireServer() end)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(waitInterval("NeedleInterval", 1))
        if Unloaded then break end
        if State.AutoFindNeedle then
            if not LocalPlayer:GetAttribute("NeedleRoundComplete") then
                local hay = findClosestHay()
                if not hay then ensureNearPileForPick() hay = findClosestHay() end
                if hay then
                    teleportToPart(hay, 4)
                    local id = hay:GetAttribute("HayId")
                    if id and not isBagFull() then
                        pcall(function() PickHay:FireServer(id, getGrabCandidates(hay)) end)
                    elseif isBagFull() then
                        trySell()
                    end
                else
                    ensureNearPileForPick()
                end
            end
        end
        if State.AutoHandInNeedle then

            local farmer = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Farmer_NPC")
            if farmer and farmer:GetPivot() then
                local hrp = getHRP()
                if hrp and (hrp.Position - farmer:GetPivot().Position).Magnitude > 20 then
                    hrp.CFrame = farmer:GetPivot() * CFrame.new(0, 0, 4)
                    task.wait(0.2)
                end
            end
            pcall(function() NeedleHandIn:FireServer() end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(waitInterval("BuyInterval", 1))
        if Unloaded then break end
        if State.AutoBuyTools then
            local sel = State.BuyToolsList or {}
            local list = {}
            if typeof(sel) == "table" then
                for k, v in pairs(sel) do
                    if type(k) == "number" then
                        if type(v) == "string" then table.insert(list, v) end
                    elseif v then
                        table.insert(list, k)
                    end
                end
            end
            for _, name in ipairs(list) do
                if name == "Pitchfork" and not owns("PitchforkOwned") then
                    pcall(function() BuyShopItem:FireServer("Pitchfork") end)
                elseif name == "TNT" and not owns("TntOwned") then
                    pcall(function() BuyShopItem:FireServer("Tnt") end)
                elseif name == "Drone" and not owns("DroneOwned") then
                    pcall(function() BuyShopItem:FireServer("Drone") end)
                elseif name == "Vacuum" and not owns("VacuumOwned") then
                    pcall(function() BuyShopItem:FireServer("Vacuum") end)
                elseif name == "Infinite Bag" and not owns("InfiniteBagOwned") then
                    pcall(function() BuyShopItem:FireServer("InfiniteBag") end)
                elseif name == "Capacity Bag" then

                    local st = tonumber(LocalPlayer:GetAttribute("HayUpgradeCapacity")) or 1
                    local track = GameConfig.UPGRADE_TRACKS["Capacity"]
                    if track and st < #track.Levels then
                        local cost = track.Levels[st + 1].Cost
                        if getCash() >= (cost or 0) then
                            pcall(function() BuyUpgrade:FireServer("Capacity") end)
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(waitInterval("PermInterval", 1))
        if Unloaded then break end
        if State.UpgBagSize then tryBuyPermanent("ExtraHoldAmount") end
        if State.UpgExtraTake then tryBuyPermanent("ExtraTakeAmount") end
        if State.UpgGemValue then tryBuyPermanent("GemValue") end
        if State.UpgHayValue then tryBuyPermanent("ExtraHayValuePercentage") end
    end
end)

task.spawn(function()
    while true do
        task.wait(1.2)
        if Unloaded then break end
        if State.UpgCapacity then tryBuyTrack("Capacity") end
        if State.UpgHandSpeed then tryBuyTrack("Speed") end
        if State.UpgHandGrab then tryBuyTrack("Grab") end
        if State.UpgHandHold then tryBuyTrack("HandHold") end
        if State.UpgTntLuck then tryBuyTrack("TntLuck") end
        if State.UpgTntCooldown then tryBuyTrack("TntCooldown") end
        if State.UpgTntPower then tryBuyTrack("TntPower") end
        if State.UpgPitchCooldown then tryBuyTrack("PitchforkCooldown") end
        if State.UpgPitchHold then tryBuyTrack("PitchforkHold") end
        if State.UpgPitchSweep then tryBuyTrack("Pitchfork") end
        if State.UpgDroneSpeed then tryBuyTrack("DroneSpeed") end
        if State.UpgDroneGrab then tryBuyTrack("DroneGrab") end
        if State.UpgDroneCapacity then tryBuyTrack("DroneCapacity") end
        if State.UpgVacPower then tryBuyTrack("VacuumPower") end
        if State.UpgVacCooling then tryBuyTrack("VacuumCooling") end
        if State.UpgVacRuntime then tryBuyTrack("VacuumRuntime") end
    end
end)

task.spawn(function()
    while true do
        task.wait(300)
        if Unloaded then break end
        if State.AntiAFK then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) hum.Jump = true end
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
end)

if ConfigManager then
    pcall(function()
        for _, n in ipairs(ConfigManager:AllConfigs()) do
            local clean = tostring(n):gsub("%.json$", "")
            if clean == "default" then
                local cfg = ConfigManager:CreateConfig("default")
                for key, el in pairs(Registry) do cfg:Register(key, el) end
                cfg:Load()
                break
            end
        end
    end)
end

pcall(function()
    task.defer(function()
        pcall(function() CollectingTab:Select() end)
    end)
end)

Notify(HubName, gameName .. " loaded. Farming=collect/sell/tools | Inventory=shop/upgrades", 5, "check")
print("[" .. HubName .. "] Loaded " .. gameName .. " via WindUI")
