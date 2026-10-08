local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local AUTOEXEC_CODE = [[loadstring(game:HttpGet("https://pastefy.app/9MooaVB6/raw"))()]]

if game.PlaceId ~= 113290951185459 then
    error("[Anime Dice - Perfectus] This script only works in Anime Dice.", 0)
end

if not game:IsLoaded() then
    local t0 = os.clock()
    while not game:IsLoaded() and os.clock() - t0 < 30 do
        task.wait(0.2)
    end
end
if LocalPlayer == nil then
    local t0 = os.clock()
    while LocalPlayer == nil and os.clock() - t0 < 30 do
        task.wait(0.2)
        pcall(function() LocalPlayer = Players.LocalPlayer end)
    end
end
if LocalPlayer == nil then
    error("[Anime Dice - Perfectus] Client still booting (no LocalPlayer yet). Re-execute in a moment.", 0)
end

if not LocalPlayer:FindFirstChildOfClass("PlayerGui") then
    local t0 = os.clock()
    while not LocalPlayer:FindFirstChildOfClass("PlayerGui") and os.clock() - t0 < 20 do
        task.wait(0.2)
    end
end

do
    local blocked = false
    pcall(function()
        if typeof(getgenv) == "function" then
            local h = getgenv().ADH_Heartbeat
            if type(h) == "table" then
                local dt = os.clock() - (tonumber(h.t) or 0)

                if dt >= 0 and dt < 6 and (h.job == nil or h.job == game.JobId) then
                    blocked = true
                end
            end
        end
    end)
    if blocked then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Anime Dice - Perfectus", Text = "Already running.", Duration = 4 })
        end)
        warn("[Anime Dice - Perfectus] Already running.")
        return
    end
end
pcall(function()
    if typeof(getgenv) == "function" then
        getgenv().ADH_Heartbeat = { t = os.clock(), job = game.JobId }
    end
end)
local Rayfield
do
    local lastErr
    for attempt = 1, 4 do
        local ok, lib = pcall(function()
            return loadstring(game:HttpGet("https://sirius.menu/gen2"))()
        end)
        if ok and type(lib) == "table" and type(lib.CreateWindow) == "function" then
            Rayfield = lib
            break
        end
        lastErr = lib
        if attempt < 4 then task.wait(2) end
    end
    if not Rayfield then
        error("[Anime Dice - Perfectus] Rayfield failed to load after 4 tries. Re-execute. Last error: " .. tostring(lastErr))
    end
end

local window = Rayfield:CreateWindow({
    name = "Anime Dice",
    subtitle = "v1.6 | Perfectus",
    sidebarLayout = true,
    theme = "default",
    icon = "rbxassetid://100284944801383",
    configuration = {
        autoSave = false,
        autoLoad = false,
        fileName = "Anime Dice - Perfectus",
        customFolder = "Anime Dice - Perfectus",
    },
})

local F = {
    collect = false, collectDelay = 2,
    levelup = false, maxLevel = 40, levelDelay = 2.5, smartLevel = false,
    placeBest = false, placeDelay = 5, replaceWorst = true,
    rebirth = false, rebirthDelay = 5,
    upgrades = false, upgradeDelay = 2, upgradeCats = {},
    buyDice = false, equipDice = true, diceDelay = 5,
    autoRoll = false,
    sellThreshold = 0, sellSync = false, sellAuto = false, sellDelay = 10, keepBest = 0, smartSell = false,
    tower = false, towerName = "Dragon Tower", towerEquipBest = true, towerDelay = 2, smartTower = false, towerExitOn = false, towerExitFloor = 0,
    potionAuto = false, potionDelay = 5, potionBest = true, potionExtend = false, potions = {},
    gradeAuto = false, gradeDelay = 2, gradeTargets = {}, gradeUnits = {}, gradeAll = false, gradePlacedOnly = false, gemReserve = 0,
    traitAuto = false, traitDelay = 2, traitTargets = {}, traitUnits = {}, traitAll = false, traitPlacedOnly = false, rerollReserve = 0,
    statHookInterval = 300,
    rollHookUrl = "", rollHookOn = false, rollHookMin = 0,
    statHookUrl = "", statHookOn = false,
    towerHookUrl = "", towerHookOn = false,
    statHookFields = {}, towerHookFields = {},
    claimQuests = false, hideRolls = false,
    codesAuto = false, codesDelay = 300,
    tradeAuto = false, tradeMoney = 0, tradeRetries = 3, tradeHop = true, tradeHopDelay = 8, tradeAutoGo = true, tradeNeedOffer = true, tradeMinItems = 1, tradeChatOn = false, tradeChatMsg = "",
    tradeHookUrl = "", tradeHookOn = false,
    saveSettings = true, autoMinimize = false, wsOn = false, wsValue = 16, flyOn = false, flySpeed = 50, noclip = false, afk = true, reexec = true, fpsOn = false,
}

local BUILD = 53
local Alive = true
local loadingCfg = false

local function hideUIAuto()
    task.spawn(function()
        local t0, sawOpen = os.clock(), false
        while os.clock() - t0 < 30 do
            local hidden, anim = nil, nil
            pcall(function() hidden = window.hidden anim = window.animating end)
            if hidden == false then sawOpen = true end
            if sawOpen and hidden == true then return end
            if sawOpen and anim == false and hidden == false then
                pcall(function() window:Hide() end)
            end
            task.wait(0.5)
        end
    end)
end
local U = {}
local noclipConn, charConn, afkConn, tradeListenerConn, rollWatchConn = nil, nil, nil, nil, nil
local adhShutdown
task.spawn(function()
    if typeof(getgenv) ~= "function" then return end
    while Alive do
        pcall(function() getgenv().ADH_Heartbeat = { t = os.clock(), job = game.JobId } end)
        task.wait(2)
    end
    pcall(function()
        if typeof(getgenv) == "function" then getgenv().ADH_Heartbeat = nil end
    end)
end)
local Busy = { place = false, tower = false, dice = false, potion = false, grade = false, trait = false, trade = false }
local Stats = { collectedMoney = 0, leveled = 0, upgraded = 0, rebirthed = 0, sold = 0, rolls = 0, towerWins = {}, towerFloors = 0, towerRewards = {}, towerGems = 0, towerTraits = 0, potions = 0, tradesSent = 0, tradesOpened = 0 }
local doInstantSell, doPotionTick, doClaimQuests, doRedeemCodes, sendTradeChat
local clog

local G = { ok = false, missing = {} }

do
    local t0 = os.clock()
    while os.clock() - t0 < 30 do
        local ok, ready = pcall(function()
            return RS:FindFirstChild("Packages") ~= nil and RS:FindFirstChild("Framework") ~= nil
        end)
        if ok and ready then break end
        task.wait(0.5)
    end
end
local function need(name, fn)
    local ok, v = pcall(fn)
    if ok and v ~= nil then G[name] = v return v end
    table.insert(G.missing, name)
    return nil
end
need("Network", function() return require(RS.Packages.Network) end)
need("DC", function() return require(RS.Framework.Features.Data.DataController) end)
need("EntryRegistry", function()
    pcall(function() require(RS.Framework.Features.Inventory.EntryTypes) end)
    return require(RS.Framework.Features.Inventory.EntryRegistry)
end)
need("PlotConfig", function() return require(RS.Framework.Features.Plot.PlotConfig) end)
need("UnitUtil", function() return require(RS.Framework.Features.Inventory.Kinds.Unit.UnitUtil) end)
need("UnitController", function() return require(RS.Framework.Features.Inventory.Kinds.Unit.UnitController) end)
need("Upgrades", function() return require(RS.Framework.Features.Upgrades.Upgrades) end)
need("TreeStructure", function() return require(RS.Framework.Features.Upgrades.TreeStructure) end)
need("Rebirths", function() return require(RS.Framework.Features.Rebirth.Rebirths) end)
need("DiceMod", function() return require(RS.Framework.Features.Rolling.Dice) end)
need("TowersMod", function() return require(RS.Framework.Features.Towers.Towers) end)
need("BoostConfig", function() return require(RS.Framework.Features.Inventory.Kinds.Boost.BoostConfig) end)
need("MonetConfig", function() return require(RS.Framework.Features.Monetization.MonetizationConfig) end)
need("QuestConfig", function() return require(RS.Framework.Features.Quests.QuestConfig) end)
need("TradeConfig", function() return require(RS.Framework.Features.Trading.TradeConfig) end)
need("GradesMod", function() return require(RS.Framework.Features.Grades.Grades) end)
need("TraitsMod", function() return require(RS.Framework.Features.Traits.Traits) end)
need("Mutations", function() return require(RS.Framework.Features.Inventory.Kinds.Unit.Mutations) end)
need("UIRefs", function() return require(RS.Framework.Features.UI.UIReferences) end)
need("NF", function() return require(RS.Packages.NumberFormatter) end)
need("BuffCtrl", function() return require(RS.Framework.Features.Buffs.BuffController) end)

local function plotComm() return G.Network.ClientComm.new(RS.Network, false, "PlotService") end
local function svcComm(svc) return G.Network.ClientComm.new(RS.Network, false, svc) end
local Sig, Fn = {}, {}
local function getSig(svc, name)
    local k = svc .. "/" .. name
    if Sig[k] then return Sig[k] end
    local ok, s = pcall(function() return svcComm(svc):GetSignal(name) end)
    if ok and s then Sig[k] = s return s end
    return nil
end
local function getFn(svc, name)
    local k = svc .. "/" .. name
    if Fn[k] then return Fn[k] end
    local ok, f = pcall(function() return svcComm(svc):GetFunction(name) end)
    if ok and f then Fn[k] = f return f end
    return nil
end
local function buyUpgradeSig()
    if Sig.BuyUpgrade then return Sig.BuyUpgrade end
    local ok, s = pcall(function() return G.Network.Client.GetSignal(RS.Network, "BuyUpgrade") end)
    if ok and s then Sig.BuyUpgrade = s return s end
    return nil
end

G.ok = G.Network ~= nil and G.DC ~= nil

local function log(...) print("[Anime Dice - Perfectus]", ...) end
local function notify(title, content)
    pcall(function() window:Notify({ title = title, content = content, duration = 4 }) end)
end

local function money() local ok, v = pcall(function() return G.DC.Money() end) return ok and (tonumber(v) or 0) or 0 end
local function rebirth() local ok, v = pcall(function() return G.DC.Rebirth() end) return ok and (tonumber(v) or 0) or 0 end
local function slots() local ok, v = pcall(function() return G.DC.Slots() end) return (ok and type(v) == "table") and v or {} end
local function inventory() local ok, v = pcall(function() return G.DC.Inventory() end) return (ok and type(v) == "table") and v or {} end
local function invEntry(key)
    local e
    local ok = pcall(function() e = G.DC.Inventory[key]() end)
    if ok and e then return e end
    return inventory()[key]
end
local function equippedKey()
    local ok, v = pcall(function() return G.UnitController.EquippedUnit() end)
    return ok and v or nil
end
local function unitChance(entry)
    if not entry or type(entry) ~= "table" then return 0 end
    local ok, cfg = pcall(function() return G.EntryRegistry.getEntryConfig(entry.name) end)
    if not ok or not cfg or cfg.kind ~= "Unit" then return 0 end
    local ok2, ch = pcall(function() return cfg.chance(entry.attributes) end)
    return (ok2 and tonumber(ch)) or 0
end
local function isUnitEntry(entry)
    if not entry or type(entry) ~= "table" or not entry.name then return false end
    local ok, cfg = pcall(function() return G.EntryRegistry.getEntryConfig(entry.name) end)
    return ok and cfg and cfg.kind == "Unit"
end
local function unlockedSlots()
    local list, s = {}, slots()
    local maxS = 14
    pcall(function() maxS = G.PlotConfig.GetMaxSlots() end)
    local rb = rebirth()
    for i = 1, maxS do
        local req = 0
        pcall(function() req = G.PlotConfig.GetSlotRebirthRequirement(i) end)
        if rb >= req then table.insert(list, i) end
    end
    return list, s
end
local function parseCompact(text)
    if not text or text == "" then return 0 end
    local clean = tostring(text):gsub("%$", ""):gsub(",", ""):gsub("%s+", "")
    if clean == "" then return 0 end
    local ok, v = pcall(function() return G.NF.ParseCompact(clean) end)
    if ok and tonumber(v) then return tonumber(v) end
    local num, suf = clean:lower():match("^([%d%.]+)([a-z]*)$")
    num = tonumber(num)
    if not num then return nil end
    local mult = { k = 1e3, m = 1e6, b = 1e9, t = 1e12, q = 1e15, qd = 1e15, qn = 1e18, aa = 1e18 }
    return num * (mult[suf] or 1)
end
local function fmt(n)
    local ok, v = pcall(function() return G.NF.FormatCompact(n) end)
    return (ok and v) or tostring(n)
end
local function applySellInput(text)
    if not text or text:gsub("%s", "") == "" then
        F.sellThreshold = 0
        notify("Auto Sell", "Threshold off.")
        if F.sellSync then local s = getSig("SellService", "UpdateAutoSell") if s then pcall(function() s:Fire(0) end) end end
        return
    end
    local v = parseCompact(text)
    if v and v >= 0 then
        F.sellThreshold = v
        notify("Auto Sell", "Threshold: " .. fmt(v) .. " (1 in " .. fmt(v) .. ")")
        if F.sellSync then local s = getSig("SellService", "UpdateAutoSell") if s then pcall(function() s:Fire(v) end) end end
    else notify("Auto Sell", "Not understood, e.g. 1t") end
end
local function applyTradeInput(text)
    if not text or text:gsub("%s", "") == "" then
        F.tradeMoney = 0
        notify("Trade", "Min money off.")
        return
    end
    local v = parseCompact(text)
    if v and v > 0 then
        F.tradeMoney = v
        notify("Trade", "Min money: " .. fmt(v))
    else notify("Trade", "Not understood, e.g. 1b") end
end
local function rolls() local ok, v = pcall(function() return G.DC.Rolls() end) return ok and (tonumber(v) or 0) or 0 end
local function setStat(h, v)
    v = tonumber(v) or 0
    if h.value ~= v then h:Set(v) end
end
local smartSellTick, smartLevelTick
do
local SMART_K = 100000
local lastSmartT = 0
local function effectiveLuck()
    local diceLuck, buff = 1, 1
    pcall(function()
        local cur = G.DC.Dice()
        local all = G.DiceMod.GetAll()
        if cur and all and all[cur] then diceLuck = tonumber(all[cur].luck) or 1 end
    end)
    pcall(function()
        local b = G.BuffCtrl.GetBuff("Luck")
        if tonumber(b) and tonumber(b) > 0 then buff = tonumber(b) end
    end)
    return math.max(1, diceLuck) * math.max(1, buff)
end
local function bestOwnedChance()
    local best = 0
    for _, e in pairs(inventory()) do
        if isUnitEntry(e) then
            local ch = unitChance(e)
            if ch > best then best = ch end
        end
    end
    return best
end
local smartErrAt, lvlErrAt = 0, 0
function smartSellTick(force)
    if not F.smartSell then return end
    if not force and os.clock() - lastSmartT < 60 then return end
    lastSmartT = os.clock()
    local ok, err = pcall(function()
        local L = effectiveLuck()
        local T = SMART_K * L
        local best = bestOwnedChance()
        if best > 0 then T = math.min(T, best / 2) end
        if T > 0 then
            local mag = 10 ^ math.max(0, math.floor(math.log10(T) - 1))
            T = math.floor(T / mag) * mag
        end
        pcall(function() if U.sellInput then U.sellInput:Set(fmt(T), true) end end)
        if T ~= F.sellThreshold then
            F.sellThreshold = T
            if F.sellSync and T > 0 then local s = getSig("SellService", "UpdateAutoSell") if s then pcall(function() s:Fire(T) end) end end
            clog("Smart sell: keep 1 in " .. fmt(T) .. "+ (luck " .. fmt(L) .. ")")
        end
    end)
    if not ok and os.clock() - smartErrAt > 60 then
        smartErrAt = os.clock()
        clog("Smart sell error: " .. tostring(err))
    end
end
local lastLvlT = 0
function smartLevelTick(force)
    if not F.smartLevel then return end
    if not force and os.clock() - lastLvlT < 30 then return end
    lastLvlT = os.clock()
    local ok, err = pcall(function()
        local list, s = unlockedSlots()
        local units = {}
        for _, slot in ipairs(list) do
            local d = s[tostring(slot)]
            if d and d.unitId then
                local e = invEntry(d.unitId)
                if e and e.attributes then
                    table.insert(units, { name = e.name, lvl = tonumber(e.attributes.level) or 1, mut = e.attributes.mutation })
                end
            end
        end
        if #units == 0 then return end
        local m = money()
        local function costTo(minL)
            local c = 0
            for _, u in ipairs(units) do
                if u.lvl < minL then
                    for lv = u.lvl, minL - 1 do
                        local p = 0
                        pcall(function() p = G.UnitUtil.GetLevelPrice(u.name, { level = lv, mutation = u.mut }) end)
                        c += p
                    end
                end
            end
            return c
        end
        local minLvl = 99
        for _, u in ipairs(units) do minLvl = math.min(minLvl, u.lvl) end

        local cap = math.clamp(minLvl, 1, 99)
        local guard, moved = 0, true
        while moved and guard < 25 do
            moved = false guard += 1
            if cap < 99 then
                local up = costTo(cap + 1)
                if up > 0 and up <= m * 0.1 then cap += 1 moved = true end
            end
            if not moved and cap > 1 and costTo(cap) > m * 0.5 then cap -= 1 moved = true end
        end
        if cap ~= math.floor(tonumber(F.maxLevel) or 40) then
            F.maxLevel = cap
            pcall(function() if U.maxLevel then U.maxLevel:Set(cap, true) end end)
            clog("Smart level cap: " .. cap)
        end
    end)
    if not ok and os.clock() - lvlErrAt > 60 then
        lvlErrAt = os.clock()
        clog("Smart level error: " .. tostring(err))
    end
end
end
local function waitVerify(fn, timeout)
    timeout = timeout or 3
    local t = 0
    while t < timeout do
        local ok, r = pcall(fn)
        if ok and r then return true end
        task.wait(0.25) t += 0.25
    end
    return false
end

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TeleportService")
local HTS = game:GetService("HttpService")
local CFG_FOLDER = "Anime Dice - Perfectus"
local CFG_FOLDER_OLD = "AnimeDiceHub"
local function existingPath(newPath, oldPath)
    local okE, has = pcall(function() return isfile(newPath) end)
    if okE and has then return newPath end
    local okO, hasO = pcall(function() return isfile(oldPath) end)
    if okO and hasO then return oldPath end
    return nil
end
local cfgPath, saveNow, applyWS, flyStop, setFly
do
local lastCfgSaved = ""
function cfgPath() return CFG_FOLDER .. "/config_" .. tostring(LocalPlayer.UserId) .. ".json" end
function saveNow()
    if typeof(writefile) ~= "function" or typeof(makefolder) ~= "function" then return false end
    pcall(function() makefolder(CFG_FOLDER) end)
    local ok, txt = pcall(function()
        return HTS:JSONEncode({ v = 1, F = F, S = Stats, thresholdText = (U.sellInput and U.sellInput.value) or "", tradeText = (U.tradeInput and U.tradeInput.value) or "",
            rollMinText = (U.rollMinT and U.rollMinT.value) or "", chatText = (U.tradeChatMsg and U.tradeChatMsg.value) or "" })
    end)
    if not ok or txt == lastCfgSaved then return false end
    local ok2 = pcall(function() writefile(cfgPath(), txt) end)
    if ok2 then lastCfgSaved = txt end
    return ok2
end
function applyWS()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = (F.wsOn and F.wsValue) or 16 end
end
local flyGyro, flyVel, flyMoveConn, flyKeys = nil, nil, nil, {}
function flyStop()
    if flyMoveConn then pcall(function() flyMoveConn:Disconnect() end) flyMoveConn = nil end
    if flyGyro then pcall(function() flyGyro:Destroy() end) flyGyro = nil end
    if flyVel then pcall(function() flyVel:Destroy() end) flyVel = nil end
    table.clear(flyKeys)
end
local function flyStart()
    flyStop()
    local ch = LocalPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    hum.PlatformStand = true
    flyGyro = Instance.new("BodyGyro")
    flyGyro.P = 9000
    flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyGyro.CFrame = hrp.CFrame
    flyGyro.Parent = hrp
    flyVel = Instance.new("BodyVelocity")
    flyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyVel.Velocity = Vector3.zero
    flyVel.Parent = hrp
    flyMoveConn = game:GetService("RunService").RenderStepped:Connect(function()
        if not F.flyOn then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local dir = Vector3.zero
        if flyKeys[Enum.KeyCode.W] then dir += cam.CFrame.LookVector end
        if flyKeys[Enum.KeyCode.S] then dir -= cam.CFrame.LookVector end
        if flyKeys[Enum.KeyCode.A] then dir -= cam.CFrame.RightVector end
        if flyKeys[Enum.KeyCode.D] then dir += cam.CFrame.RightVector end
        if flyKeys[Enum.KeyCode.Space] then dir += Vector3.new(0, 1, 0) end
        if flyKeys[Enum.KeyCode.LeftShift] then dir -= Vector3.new(0, 1, 0) end
        if dir.Magnitude > 0 then dir = dir.Unit * F.flySpeed end
        pcall(function()
            flyVel.Velocity = dir
            flyGyro.CFrame = cam.CFrame
        end)
    end)
end
function setFly(on)
    F.flyOn = on
    if not on then
        flyStop()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
        return
    end
    flyStart()
end
UIS.InputBegan:Connect(function(i, g)
    if g or not F.flyOn then return end
    if UIS:GetFocusedTextBox() then return end
    flyKeys[i.KeyCode] = true
end)
UIS.InputEnded:Connect(function(i) flyKeys[i.KeyCode] = nil end)
charConn = LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    applyWS()
    if F.flyOn then flyStart() end
end)
noclipConn = game:GetService("RunService").Stepped:Connect(function()
    if not F.noclip then return end
    local ch = LocalPlayer.Character
    if ch then
        for _, p in ipairs(ch:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)
afkConn = LocalPlayer.Idled:Connect(function()
    if F.afk then pcall(function()
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end) end
end)
end
local applyFpsBoost, doRejoin, doHop
do
local hopBusy = false
TS.TeleportInitFailed:Connect(function(_, _, msg)
    if hopBusy then return end
    notify("Teleport", "Failed: " .. tostring(msg))
end)

local fpsRestore, fpsHidden, fpsMaintConn, fpsKeptPlot = {}, {}, nil, nil
local function fpsDisable(inst)
    pcall(function()
        if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") or inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Sparkles") then
            if inst.Enabled then table.insert(fpsRestore, { o = inst, p = "Enabled", v = true }) inst.Enabled = false end
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            if inst.Transparency < 1 then table.insert(fpsRestore, { o = inst, p = "Transparency", v = inst.Transparency }) inst.Transparency = 1 end
        elseif inst:IsA("MeshPart") then
            if inst.CastShadow then table.insert(fpsRestore, { o = inst, p = "CastShadow", v = true }) inst.CastShadow = false end
            if inst.TextureID ~= "" then table.insert(fpsRestore, { o = inst, p = "TextureID", v = inst.TextureID }) inst.TextureID = "" end
            if inst.Material ~= Enum.Material.SmoothPlastic then table.insert(fpsRestore, { o = inst, p = "Material", v = inst.Material }) inst.Material = Enum.Material.SmoothPlastic end
        elseif inst:IsA("BasePart") and not inst:IsA("Terrain") then
            if inst.CastShadow then table.insert(fpsRestore, { o = inst, p = "CastShadow", v = true }) inst.CastShadow = false end
        elseif inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight") then
            if inst.Enabled then table.insert(fpsRestore, { o = inst, p = "Enabled", v = true }) inst.Enabled = false end
        elseif inst:IsA("PostEffect") then
            if inst.Enabled then table.insert(fpsRestore, { o = inst, p = "Enabled", v = true }) inst.Enabled = false end
        end
    end)
end
local function fpsHide(inst)
    pcall(function()
        if inst and inst.Parent then
            for _, h in ipairs(fpsHidden) do if h.o == inst then return end end
            table.insert(fpsHidden, { o = inst, parent = inst.Parent })
            inst.Parent = nil
        end
    end)
end

local function fpsOwnPlot()
    local plots = workspace:FindFirstChild("Plots")
    local claimed = plots and plots:FindFirstChild("Claimed")
    if not claimed then return nil end
    local meD, meN = "", ""
    pcall(function() meD = tostring(LocalPlayer.DisplayName or ""):lower() end)
    pcall(function() meN = tostring(LocalPlayer.Name or ""):lower() end)
    for _, plot in ipairs(claimed:GetChildren()) do
        local hit = false
        pcall(function()
            for _, d in ipairs(plot:GetDescendants()) do
                if d:IsA("TextLabel") and d.Name == "PlayerName" then
                    local t = tostring(d.Text or ""):lower()
                    if (meD ~= "" and t == meD) or (meN ~= "" and t == meN) then hit = true end
                    break
                end
            end
        end)
        if hit then return plot end
    end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local best, bestD = nil, math.huge
        pcall(function()
            for _, plot in ipairs(claimed:GetChildren()) do
                local ok, cf = pcall(function() return plot:GetPivot() end)
                if ok and cf then
                    local d = (cf.Position - hrp.Position).Magnitude
                    if d < bestD then best, bestD = plot, d end
                end
            end
        end)
        if best then return best end
    end
    return nil
end

local function fpsIsDecor(c)
    local n = c.Name
    if c:IsA("Model") then
        return n == "Palm Tree" or n == "Mountain" or n == "LOW POLY ISLAND" or n == "LightHouse" or n == "Wind"
    elseif c:IsA("MeshPart") then
        return n == "Rock 1" or n == "Grass"
    end
    return false
end
local function applyAnimeDiceStrip()

    pcall(function() local lb = workspace:FindFirstChild("Leaderboards") if lb then fpsHide(lb) end end)

    pcall(function() local b = workspace:FindFirstChild("BestRollPoduium") if b then fpsHide(b) end end)
    pcall(function() local l = workspace:FindFirstChild("Limiteds") if l then fpsHide(l) end end)

    pcall(function()
        local m = workspace:FindFirstChild("Map")
        local t = m and m:FindFirstChild("CastleTower")
        if t then fpsHide(t) end
    end)

    pcall(function()
        local plots = workspace:FindFirstChild("Plots")
        local un = plots and plots:FindFirstChild("Unclaimed")
        if un then fpsHide(un) end
    end)

    pcall(function()
        local plots = workspace:FindFirstChild("Plots")
        local claimed = plots and plots:FindFirstChild("Claimed")
        if claimed then
            fpsKeptPlot = fpsOwnPlot()
            for _, plot in ipairs(claimed:GetChildren()) do
                if plot ~= fpsKeptPlot then fpsHide(plot) end
            end
        end
    end)

    pcall(function()
        local pf = workspace:FindFirstChild("Players")
        if pf then
            for _, m in ipairs(pf:GetChildren()) do
                if m:IsA("Model") and m.Name ~= LocalPlayer.Name then fpsHide(m) end
            end
        end
    end)

    pcall(function()
        local m = workspace:FindFirstChild("Map")
        if not m then return end
        for _, c in ipairs(m:GetChildren()) do
            if c:IsA("Model") and c.Name == "Model" and #c:GetDescendants() > 0 then
                local keep = false
                pcall(function()
                    for _, d in ipairs(c:GetDescendants()) do
                        if d.Name == "LobbyCircle" or d.Name == "Conveyor" then keep = true break end
                    end
                end)
                if not keep then fpsHide(c) end
            end
        end
    end)

    pcall(function()
        local m = workspace:FindFirstChild("Map")
        if m then
            for _, c in ipairs(m:GetDescendants()) do
                if fpsIsDecor(c) then fpsHide(c) end
            end
        end
    end)
end
local function fpsSweep(root)
    for _, o in ipairs(root:GetDescendants()) do fpsDisable(o) end
end
function applyFpsBoost(on)
    if on then
        pcall(function()
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            local hud = pg and pg:FindFirstChild("Root") and pg.Root:FindFirstChild("HUD")
            if hud and typeof(getnilinstances) == "function" then
                for _, o in ipairs(getnilinstances()) do
                    if o.Name == "ProductDisplay" and o:IsA("GuiObject") then
                        o.Parent = hud
                        break
                    end
                end
            end
        end)
        pcall(function()
            local s = getSig("SettingsService", "SetSetting")
            if s then s:Fire("Performance", true) end
        end)
        table.clear(fpsRestore)
        table.clear(fpsHidden)
        fpsKeptPlot = nil
        pcall(function()
            local L = game:GetService("Lighting")
            table.insert(fpsRestore, { o = L, p = "GlobalShadows", v = L.GlobalShadows })
            L.GlobalShadows = false
            table.insert(fpsRestore, { o = L, p = "FogEnd", v = L.FogEnd })
            L.FogEnd = 100000
            table.insert(fpsRestore, { o = L, p = "EnvironmentDiffuseScale", v = L.EnvironmentDiffuseScale })
            L.EnvironmentDiffuseScale = 0
            table.insert(fpsRestore, { o = L, p = "EnvironmentSpecularScale", v = L.EnvironmentSpecularScale })
            L.EnvironmentSpecularScale = 0
        end)
        pcall(function()
            local T = workspace.Terrain
            table.insert(fpsRestore, { o = T, p = "WaterWaveSize", v = T.WaterWaveSize })
            table.insert(fpsRestore, { o = T, p = "WaterWaveSpeed", v = T.WaterWaveSpeed })
            table.insert(fpsRestore, { o = T, p = "WaterReflectance", v = T.WaterReflectance })
            table.insert(fpsRestore, { o = T, p = "Decoration", v = T.Decoration })
            T.WaterWaveSize = 0
            T.WaterWaveSpeed = 0
            T.WaterReflectance = 0
            T.Decoration = false
        end)
        fpsSweep(workspace)
        applyAnimeDiceStrip()
        pcall(function() for _, e in ipairs(game:GetService("Lighting"):GetDescendants()) do fpsDisable(e) end end)
        pcall(function()
            local R = settings().Rendering
            table.insert(fpsRestore, { o = R, p = "QualityLevel", v = R.QualityLevel })
            R.QualityLevel = Enum.QualityLevel.Level01
        end)
        if not fpsMaintConn then
            fpsMaintConn = workspace.DescendantAdded:Connect(function(o)
                if not F.fpsOn then return end
                fpsDisable(o)

                pcall(function()
                    local par = o.Parent
                    if not par then return end
                    if par == workspace:FindFirstChild("Players") then
                        if o:IsA("Model") and o.Name ~= LocalPlayer.Name then fpsHide(o) end
                    elseif par.Name == "Claimed" and par.Parent and par.Parent.Name == "Plots" then
                        if o ~= fpsKeptPlot then fpsHide(o) end
                    end
                end)
            end)
        end
        task.delay(8, function() if F.fpsOn then fpsSweep(workspace) applyAnimeDiceStrip() end end)
        notify("Performance", "FPS Boost ON: leaderboards/statues/tower/other bases hidden + shadows/particles/textures off.")
    else
        local wasActive = (fpsMaintConn ~= nil) or (#fpsRestore > 0) or (#fpsHidden > 0)
        if fpsMaintConn then fpsMaintConn:Disconnect() fpsMaintConn = nil end
        for i = #fpsHidden, 1, -1 do
            local h = fpsHidden[i]
            pcall(function() h.o.Parent = h.parent end)
        end
        table.clear(fpsHidden)
        fpsKeptPlot = nil
        for _, r in ipairs(fpsRestore) do pcall(function() r.o[r.p] = r.v end) end
        table.clear(fpsRestore)
        if wasActive then notify("Performance", "FPS Boost OFF: map and effects restored.") end
    end
end
local function hopNotePath() return CFG_FOLDER .. "/lasthop_" .. tostring(LocalPlayer.UserId) .. ".json" end
local function readHopNote()
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then return nil end
    local path = existingPath(hopNotePath(), CFG_FOLDER_OLD .. "/lasthop_" .. tostring(LocalPlayer.UserId) .. ".json")
    if not path then return nil end
    local okR, txt = pcall(readfile, path)
    if not okR then return nil end
    local okD, d = pcall(function() return HTS:JSONDecode(txt) end)
    if okD and type(d) == "table" then return d end
    return nil
end
local function writeHopNote(job, tries)
    if typeof(writefile) ~= "function" then return end
    pcall(function() makefolder(CFG_FOLDER) end)
    pcall(function() writefile(hopNotePath(), HTS:JSONEncode({ job = job, tries = tries, time = os.time() })) end)
end
function doRejoin(sameServer)
    if not sameServer then
        pcall(function() TS:Teleport(game.PlaceId, LocalPlayer) end)
        return
    end
    task.spawn(function()
        notify("Rejoin", "Rejoining this server...")
        local myJob = game.JobId
        local inPrivate = false
        pcall(function() inPrivate = game.PrivateServerId ~= "" end)
        local failMsg, pending = nil, false
        local failConn = TS.TeleportInitFailed:Connect(function(plr, result, msg)
            if plr == LocalPlayer then
                pending = false
                failMsg = tostring((msg and msg ~= "") and msg or result)
            end
        end)
        local attempt = 0
        while attempt < 3 do
            attempt += 1
            failMsg, pending = nil, true
            local ok, err = pcall(function() TS:TeleportToPlaceInstance(game.PlaceId, myJob, LocalPlayer) end)
            if not ok then
                pending = false
                failMsg = tostring(err)
            end
            local t = 0
            while t < 15 and pending do task.wait(1) t += 1 end
            pending = false
            if game.JobId ~= myJob then break end
            if failMsg then notify("Rejoin", "Attempt " .. attempt .. "/3 failed: " .. failMsg) end
        end
        failConn:Disconnect()
        if game.JobId ~= myJob then return end
        if inPrivate then

            notify("Rejoin", "Private server rejoin blocked (" .. tostring(failMsg or "unknown") .. "). Rejoin manually from the Roblox menu.")
            log("Rejoin failed in private server: " .. tostring(failMsg or "unknown"))
        else
            notify("Rejoin", "Same-server blocked, hopping public...")
            task.wait(1)
            pcall(function() TS:Teleport(game.PlaceId, LocalPlayer) end)
        end
    end)
end
local VISIT_TTL = 1800
local function visitedPath() return CFG_FOLDER .. "/visited_" .. tostring(LocalPlayer.UserId) .. ".json" end
local function loadVisited()
    local t = {}
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then return t end
    local path = existingPath(visitedPath(), CFG_FOLDER_OLD .. "/visited_" .. tostring(LocalPlayer.UserId) .. ".json")
    if not path then return t end
    local okR, txt = pcall(readfile, path)
    if not okR then return t end
    local okD, d = pcall(function() return HTS:JSONDecode(txt) end)
    if not (okD and type(d) == "table") then return t end
    local now = os.time()
    for job, ts in pairs(d) do
        ts = tonumber(ts)
        if type(job) == "string" and ts and now - ts < VISIT_TTL then t[job] = ts end
    end
    return t
end
local function saveVisited(t)
    if typeof(writefile) ~= "function" then return end
    pcall(function() makefolder(CFG_FOLDER) end)
    local arr = {}
    for job, ts in pairs(t) do table.insert(arr, { job = job, ts = ts }) end
    if #arr > 200 then
        table.sort(arr, function(a, b) return a.ts > b.ts end)
        local kept = {}
        for i = 1, 200 do kept[arr[i].job] = arr[i].ts end
        t = kept
    end
    pcall(function() writefile(visitedPath(), HTS:JSONEncode(t)) end)
end
local lastHopAt = 0
function doHop(lowPop, isBlocked)
    task.spawn(function()
        if type(isBlocked) == "function" and isBlocked() then return end
        if os.clock() - lastHopAt < 30 then
            notify("Server Hop", "Cooldown, skipping.")
            return
        end
        lastHopAt = os.clock()
        notify("Server Hop", "Searching servers...")
        local visited = loadVisited()
        local cands, cursor, pages = {}, nil, 0
        local order = lowPop and "Asc" or "Desc"
        while pages < 3 do
            local url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=" .. order .. "&limit=100&excludeFullGames=true"
            if cursor then url = url .. "&cursor=" .. cursor end
            local ok, res = pcall(function() return game:HttpGet(url) end)
            if not ok then break end
            local ok2, data = pcall(function() return HTS:JSONDecode(res) end)
            if not (ok2 and data and data.data) then break end
            for _, s in ipairs(data.data) do
                if s.id ~= game.JobId and not visited[s.id] and (tonumber(s.playing) or 0) < (tonumber(s.maxPlayers) or 99) then
                    table.insert(cands, s)
                end
            end
            cursor = data.nextPageCursor
            pages += 1
            if not cursor then break end
        end
        if type(isBlocked) == "function" and isBlocked() then
            notify("Server Hop", "Trade open, hop cancelled.")
            return
        end
        if #cands == 0 then
            local oldest, oldestT = nil, nil
            for job, ts in pairs(visited) do
                if job ~= game.JobId and (not oldestT or ts < oldestT) then oldest, oldestT = job, ts end
            end
            hopBusy = true
            local myJob = game.JobId
            local failMsg, pending = nil, false
            local failConn = TS.TeleportInitFailed:Connect(function(plr, result, msg)
                if plr == LocalPlayer then
                    pending = false
                    failMsg = tostring((msg and msg ~= "") and msg or result)
                end
            end)
            local function tryInstance(job)
                if game.JobId ~= myJob then return true end
                failMsg, pending = nil, true
                local ok, err = pcall(function() TS:TeleportToPlaceInstance(game.PlaceId, job, LocalPlayer) end)
                if not ok then
                    pending = false
                    return false, tostring(err)
                end
                local t = 0
                while t < 10 and pending and game.JobId == myJob do task.wait(1) t += 1 end
                if game.JobId ~= myJob then return true end
                if pending then pending = false return true end
                return false, (failMsg or "unknown")
            end
            if oldest then
                visited[myJob] = os.time()
                visited[oldest] = os.time()
                saveVisited(visited)
                notify("Server Hop", "All recent visited, returning to oldest...")
                local ok, err = tryInstance(oldest)
                failConn:Disconnect()
                hopBusy = false
                if not ok then
                    notify("Server Hop", "Oldest failed (" .. tostring(err) .. "), hopping random...")
                    pcall(function() TS:Teleport(game.PlaceId, LocalPlayer) end)
                end
                return
            end
            notify("Server Hop", "List empty, hopping random...")
            visited[myJob] = os.time()
            saveVisited(visited)
            failConn:Disconnect()
            hopBusy = false
            pcall(function() TS:Teleport(game.PlaceId, LocalPlayer) end)
            return
        end
        if lowPop then
            table.sort(cands, function(a, b) return (a.playing or 0) < (b.playing or 0) end)
        else
            table.sort(cands, function(a, b) return (a.playing or 0) > (b.playing or 0) end)
        end
        hopBusy = true
        local myJob2 = game.JobId
        local failMsg2, pending2 = nil, false
        local failConn2 = TS.TeleportInitFailed:Connect(function(plr, result, msg)
            if plr == LocalPlayer then
                pending2 = false
                failMsg2 = tostring((msg and msg ~= "") and msg or result)
            end
        end)
        visited[myJob2] = os.time()
        local tries = math.min(5, #cands)
        for i = 1, tries do
            if type(isBlocked) == "function" and isBlocked() then
                failConn2:Disconnect()
                hopBusy = false
                notify("Server Hop", "Trade open, hop cancelled.")
                return
            end
            local s = cands[i]
            visited[s.id] = os.time()
            saveVisited(visited)
            notify("Server Hop", "Teleporting (" .. tostring(s.playing) .. " players)...")
            failMsg2, pending2 = nil, true
            local ok, err = pcall(function() TS:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer) end)
            local ferr = nil
            if ok then
                local t = 0
                while t < 10 and pending2 and game.JobId == myJob2 do task.wait(1) t += 1 end
                if game.JobId ~= myJob2 or pending2 then
                    pending2 = false
                    failConn2:Disconnect()
                    hopBusy = false
                    return
                end
                ferr = failMsg2 or "unknown"
            else
                pending2 = false
                ferr = tostring(err)
            end
            notify("Server Hop", "Attempt " .. i .. "/" .. tries .. " failed (" .. tostring(ferr) .. "), trying next...")
        end
        failConn2:Disconnect()
        hopBusy = false
        notify("Server Hop", "All tries failed, hopping random...")
        pcall(function() TS:Teleport(game.PlaceId, LocalPlayer) end)
    end)
end
end
local armReexec, rollHideConns, rollHideBackup, syncRollHidden
do
local autoexecArmed = false
function armReexec()
    if autoexecArmed then return end
    if not F.reexec then return end
    if AUTOEXEC_CODE:find("PASTE_YOUR") then
        notify("AutoExec", "Paste your loadstring into AUTOEXEC_CODE first.")
        return
    end
    autoexecArmed = true
    local q = queue_on_teleport or queueonteleport
    if typeof(q) == "function" then
        pcall(q, AUTOEXEC_CODE)
    else
        notify("AutoExec", "queue_on_teleport not supported.")
    end
end
rollHideConns = {}
function rollHideBackup(on)
    for _, c in ipairs(rollHideConns) do pcall(function() c:Disconnect() end) end
    table.clear(rollHideConns)
    if not on then return end
    pcall(function()
        local R = G.UIRefs.Root.Rolling
        for _, inst in ipairs({ R.Frame, R.DarkBackground }) do
            if inst.Visible then inst.Visible = false end
            table.insert(rollHideConns, inst:GetPropertyChangedSignal("Visible"):Connect(function()
                if F.hideRolls and inst.Visible then inst.Visible = false end
            end))
        end
    end)
end
local function pressHiddenRoll()
    local ok, btn = pcall(function() return G.UIRefs.Root.Rolling.Options.HiddenRoll end)
    if not ok or not btn or typeof(getconnections) ~= "function" then return false end
    local okC, conns = pcall(getconnections, btn.Activated)
    if not okC or type(conns) ~= "table" then return false end
    for _, c in ipairs(conns) do pcall(function() c.Function() end) end
    task.wait(0.7)
    return true
end
local function isRollHidden()
    local a, b = nil, nil
    pcall(function() a = G.UIRefs.Root.Rolling.Frame.Position end)
    task.wait(0.25)
    pcall(function() b = G.UIRefs.Root.Rolling.Frame.Position end)
    if not a or not b then return nil end
    if math.abs(a.Y.Scale - b.Y.Scale) > 0.05 or math.abs(a.Y.Offset - b.Y.Offset) > 20 then return nil end
    return b.Y.Offset > 50
end
function syncRollHidden()
    for _ = 1, 2 do
        local cur = isRollHidden()
        if cur == nil then return end
        if cur == F.hideRolls then return end
        if not pressHiddenRoll() then return end
    end
end
local function setTowerHiddenUI()
    pcall(function()
        local S = G.UIRefs.Root.Tower.Screen
        S.Visible = false
        local bg = S.Parent:FindFirstChild("Background")
        if bg then bg.Visible = false end
    end)
end
end

local gradeByLabel, traitByLabel, gradeUnitByLabel, traitUnitByLabel = {}, {}, {}, {}
local function buildGradeOptions()
    local t = {}
    if G.GradesMod then
        for name, g in pairs(G.GradesMod) do
            if type(g) == "table" and g.order then
                table.insert(t, { name = name, order = g.order, mult = g.incomeMultiplier })
            end
        end
    end
    if #t == 0 then return { "(unavailable)" } end
    table.sort(t, function(a, b) return a.order < b.order end)
    local out = {}
    for _, g in ipairs(t) do
        local lbl = g.name .. " (x" .. tostring(g.mult) .. ")"
        gradeByLabel[lbl] = g.name
        table.insert(out, lbl)
    end
    return out
end
local function traitBuffText(t)
    local im, dm, hm = t.incomeMultiplier, t.damageMultiplier, t.healthMultiplier
    if im and im == dm and im == hm then return "x" .. tostring(im) .. " all" end
    local p = {}
    if im then table.insert(p, "x" .. tostring(im) .. " income") end
    if dm then table.insert(p, "x" .. tostring(dm) .. " dmg") end
    if hm then table.insert(p, "x" .. tostring(hm) .. " hp") end
    return table.concat(p, "+")
end
local function buildTraitOptions()
    local t = {}
    if G.TraitsMod then
        for name, tr in pairs(G.TraitsMod) do
            if type(tr) == "table" and tr.order then
                table.insert(t, { name = name, order = tr.order, ref = tr })
            end
        end
    end
    if #t == 0 then return { "(unavailable)" } end
    table.sort(t, function(a, b) return a.order < b.order end)
    local out = {}
    for _, tr in ipairs(t) do
        local lbl = tr.name .. " (" .. traitBuffText(tr.ref) .. ")"
        traitByLabel[lbl] = tr.name
        table.insert(out, lbl)
    end
    return out
end
local function placedUnitKeys()
    local set = {}
    pcall(function()
        for _, d in pairs(slots()) do
            if type(d) == "table" and d.unitId then set[d.unitId] = true end
        end
    end)
    return set
end

local function buildUnitOptions(map, kind)
    local labels = {}
    for k in pairs(map) do map[k] = nil end
    local placed = placedUnitKeys()
    local seen = {}
    local function add(key)
        if seen[key] then return end
        local e = invEntry(key)
        if not isUnitEntry(e) then return end
        seen[key] = true
        local tag = "-"
        if kind == "grade" or kind == "trait" then
            local v = e.attributes and (kind == "grade" and e.attributes.grade or e.attributes.trait)
            if v ~= nil and v ~= "" then tag = tostring(v) end
        end
        local lbl = e.name .. " [" .. tag .. "]" .. (placed[key] and " ★" or "")
        local base, n = lbl, 2
        while map[lbl] do lbl = base .. " #" .. n n += 1 end
        map[lbl] = key
        table.insert(labels, lbl)
    end
    for key in pairs(inventory()) do add(key) end

    for key in pairs(placed) do add(key) end
    table.sort(labels)
    return labels
end
local function refreshUnitDrop(drop, map, keepKeys, kind)
    if not drop then return 0 end
    local keep = {}
    for _, k in ipairs(keepKeys) do keep[k] = true end
    local labels = buildUnitOptions(map, kind)
    drop:Refresh(labels)
    local resel = {}
    for lbl, k in pairs(map) do if keep[k] then table.insert(resel, lbl) end end
    if #resel > 0 then drop:Set(resel) end
    return #labels
end
local function currencyAmount(name)
    local total = 0
    for _, e in pairs(inventory()) do
        if type(e) == "table" and e.name == name then total += tonumber(e.amount) or 0 end
    end
    return total
end

local thumbOf, hookColorInt, postWebhook, hookStamp, watchRolls, sendStatsHook, statsHookTick
do
local thumbCache = {}
function thumbOf(asset)
    local id = tostring(asset or ""):match("%d+")
    if not id then return nil end
    if thumbCache[id] ~= nil then return thumbCache[id] or nil end
    local url = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. id .. "&size=150x150&format=Png"
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok then
        local ok2, data = pcall(function() return HTS:JSONDecode(res) end)
        local img = ok2 and data and data.data and data.data[1] and data.data[1].imageUrl
        if type(img) == "string" and img ~= "" then thumbCache[id] = img return img end
    end
    thumbCache[id] = false
    return nil
end
function hookColorInt(cfg)
    local hex = nil
    pcall(function()
        local g = cfg and cfg.gradient
        if g and g.Keypoints and g.Keypoints[1] then hex = g.Keypoints[1].Value:ToHex() end
    end)
    return tonumber(hex, 16) or 0x808080
end
function postWebhook(url, payload)
    if type(url) ~= "string" or not url:find("^https?://") then return false end
    local okB, body = pcall(function() return HTS:JSONEncode(payload) end)
    if not okB then return false end
    if typeof(request) == "function" then
        local ok = pcall(function()
            request({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
        end)
        return ok
    elseif typeof(http_request) == "function" then
        local ok = pcall(function()
            http_request({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
        end)
        return ok
    end
    return false
end
function hookStamp()
    return os.date("!%Y-%m-%dT%H:%M:%S.000Z")
end
local function sendRollHook(url, e, cfg, chance)
    local at = e.attributes or {}
    local mut = at.mutation
    local thumb = nil
    if mut and G.Mutations and G.Mutations[mut] then thumb = thumbOf(G.Mutations[mut].image) end
    if not thumb then
        local cur, all = nil, nil
        pcall(function() cur = G.DC.Dice() end)
        pcall(function() all = G.DiceMod.GetAll() end)
        if cur and all and all[cur] then thumb = thumbOf(all[cur].image) end
    end
    local fields = {
        { name = "Chance", value = "1 in " .. fmt(chance), inline = true },
        { name = "Mutation", value = tostring(mut or "None"), inline = true },
    }
    if at.grade then table.insert(fields, { name = "Grade", value = tostring(at.grade), inline = true }) end
    if at.trait then table.insert(fields, { name = "Trait", value = tostring(at.trait), inline = true }) end
    local emb = {
        title = e.name .. " rolled!",
        fields = fields,
        color = hookColorInt(cfg),
        footer = { text = LocalPlayer.DisplayName },
        timestamp = hookStamp(),
    }
    if thumb then emb.thumbnail = { url = thumb } end
    return postWebhook(url, { username = "Anime Dice - Perfectus", embeds = { emb } })
end
local function anyRollHook()
    return F.rollHookOn and true or false
end
local function onNewEntry(key)
    if not anyRollHook() then return end
    local e = invEntry(key)
    if not e or not isUnitEntry(e) then return end
    local ok, cfg = pcall(function() return G.EntryRegistry.getEntryConfig(e.name) end)
    if not ok or not cfg then return end
    local chance = 0
    pcall(function() chance = cfg.chance(e.attributes) or 0 end)
    if F.rollHookOn then
        local url = F.rollHookUrl
        local min = tonumber(F.rollHookMin) or 0
        if type(url) == "string" and url ~= "" and min > 0 and chance >= min then
            task.spawn(function() sendRollHook(url, e, cfg, chance) end)
        end
    end
end
function watchRolls()
    pcall(function()
        rollWatchConn = G.DC.Inventory.OnKeyAdded(function(key)
            task.spawn(function() onNewEntry(key) end)
        end)
    end)
end
function sendStatsHook(url)
    local sel = F.statHookFields
    local function want(name)
        if type(sel) ~= "table" or #sel == 0 then return true end
        for _, s in ipairs(sel) do if s == name then return true end end
        return false
    end
    local fields = {}
    if want("Money") then table.insert(fields, { name = "Money", value = fmt(money()), inline = true }) end
    if want("Rolls") then table.insert(fields, { name = "Rolls", value = tostring(rolls()), inline = true }) end
    if want("Rebirth") then table.insert(fields, { name = "Rebirth", value = tostring(rebirth()), inline = true }) end
    local emb = {
        title = "Session Stats",
        fields = fields,
        color = 0x4ADE80,
        footer = { text = LocalPlayer.DisplayName },
        timestamp = hookStamp(),
    }
    local th = thumbOf("rbxassetid://93129522258096")
    if th then emb.thumbnail = { url = th } end
    local embeds = { emb }
    for _, name in ipairs({ "Gems", "Trait Reroll" }) do
        if want(name) and currencyAmount(name) > 0 then
            local item = { title = fmt(currencyAmount(name)) .. "x " .. name, color = 0x808080 }
            pcall(function()
                local cfg = G.EntryRegistry.getEntryConfig(name)
                if cfg then
                    item.color = hookColorInt(cfg)
                    if cfg.image then
                        local ith = thumbOf(cfg.image)
                        if ith then item.thumbnail = { url = ith } end
                    end
                end
            end)
            table.insert(embeds, item)
        end
    end
    return postWebhook(url, { username = "Anime Dice - Perfectus", embeds = embeds })
end
local lastStatsHook = 0
function statsHookTick()
    if os.clock() - lastStatsHook < (tonumber(F.statHookInterval) or 300) then return end
    lastStatsHook = os.clock()
    if F.statHookOn then
        local url = F.statHookUrl
        if type(url) == "string" and url ~= "" then
            task.spawn(function() sendStatsHook(url) end)
        end
    end
end

end

local towerByLabel, potByLabel, instantSmartCheck = {}, {}, nil
do
window:CreateSection({ name = "Farm" })
local tMain = window:CreateTab({ name = "Main", icon = "rbxassetid://77304764857415" })
local tUnits = window:CreateTab({ name = "Units", icon = "rbxassetid://133003586374441" })
local tUpg = window:CreateTab({ name = "Upgrades", icon = "rbxassetid://73069486155895" })
local tDice = window:CreateTab({ name = "Dice", icon = "rbxassetid://134876970337785" })
local tSell = window:CreateTab({ name = "Sell", icon = "rbxassetid://118330449034393" })
local tTower = window:CreateTab({ name = "Tower", icon = "rbxassetid://95008289608947" })
local tPotion = window:CreateTab({ name = "Potion", icon = "rbxassetid://92709571106091" })
local tReroll = window:CreateTab({ name = "Reroll", icon = "rbxassetid://138588191124173" })
local tTrade = window:CreateTab({ name = "Trade", icon = "rbxassetid://72821498911763" })
window:CreateSection({ name = "Info" })
local tStats = window:CreateTab({ name = "Stats", icon = "rbxassetid://93129522258096" })
local tChanges = window:CreateTab({ name = "Changelogs", icon = "rbxassetid://112634880544308" })
window:CreateSection({ name = "System" })
local tSettings = window:CreateTab({ name = "Settings", icon = "rbxassetid://103326255092488" })
local tHooks = window:CreateTab({ name = "Webhook", icon = "rbxassetid://137296756955034" })

tMain:CreateDivider({ text = "Money Collection" })
U.collectLine = tMain:CreateConsole({ name = "Collected Total", height = 48, text = "Total collected: 0" })
U.collect = tMain:CreateToggle({ name = "Auto Collect Money", value = false,
    callback = function(v) F.collect = v end })
U.collectDelay = tMain:CreateSlider({ name = "Collect Delay", range = { 0.1, 15 }, increment = 0.1, value = 2, suffix = "s",
    callback = function(v) F.collectDelay = v end })

tMain:CreateDivider({ text = "Rebirth" })
U.rebirth = tMain:CreateToggle({ name = "Auto Rebirth", value = false,
    callback = function(v) F.rebirth = v end })
U.rebirthDelay = tMain:CreateSlider({ name = "Rebirth Check", range = { 0.1, 30 }, increment = 0.1, value = 5, suffix = "s",
    callback = function(v) F.rebirthDelay = v end })

tMain:CreateDivider({ text = "Roll" })
U.autoRoll = tMain:CreateToggle({ name = "Auto Roll", value = false,
    callback = function(v)
        F.autoRoll = v
        local s = getSig("RollService", "SetAutoRoll")
        if s then pcall(function() s:Fire(v) end) end
    end })
U.hideRolls = tMain:CreateToggle({ name = "Auto Hide Rolls", value = false,
    callback = function(v) F.hideRolls = v syncRollHidden() rollHideBackup(v) end })
U.claimQuests = tMain:CreateToggle({ name = "Auto Claim Quests", value = false,
    callback = function(v) F.claimQuests = v end })

tMain:CreateDivider({ text = "Codes" })
U.codesAuto = tMain:CreateToggle({ name = "Auto Redeem Codes", value = false,
    callback = function(v)
        F.codesAuto = v
        if v then task.spawn(function() pcall(doRedeemCodes) end) end
    end })
U.codesDelay = tMain:CreateSlider({ name = "Redeem Retry", range = { 60, 1800 }, increment = 60, value = 300, suffix = "s",
    callback = function(v) F.codesDelay = math.floor(v) end })
tMain:CreateButton({ name = "Redeem All Codes Now", callback = function() task.spawn(function() pcall(doRedeemCodes, true) end) end })

tUnits:CreateDivider({ text = "Levels (Level Up)" })
U.levelup = tUnits:CreateToggle({ name = "Auto Level Up", value = false,
    callback = function(v) F.levelup = v end })
U.maxLevel = tUnits:CreateSlider({ name = "Max Unit Level", range = { 1, 99 }, increment = 1, value = 40,
    callback = function(v) F.maxLevel = math.floor(v) end })
U.smartLevel = tUnits:CreateToggle({ name = "Smart Level Cap", value = false,
    callback = function(v) F.smartLevel = v if v then smartLevelTick(true) end end })
U.levelDelay = tUnits:CreateSlider({ name = "Level Delay", range = { 0.1, 15 }, increment = 0.1, value = 2.5, suffix = "s",
    callback = function(v) F.levelDelay = v end })

tUnits:CreateDivider({ text = "Place Best Units" })
U.placeBest = tUnits:CreateToggle({ name = "Auto Place Best", value = false,
    callback = function(v) F.placeBest = v end })
U.replaceWorst = tUnits:CreateToggle({ name = "Replace Worst When Full", value = true,
    callback = function(v) F.replaceWorst = v end })
U.placeDelay = tUnits:CreateSlider({ name = "Place Check", range = { 0.1, 30 }, increment = 0.1, value = 5, suffix = "s",
    callback = function(v) F.placeDelay = v end })
tUnits:CreateButton({ name = "Game's EquipBest (one-shot)", callback = function()
    local s = getSig("PlotService", "EquipBest")
    if s then pcall(function() s:Fire() end) end
end })

tUpg:CreateDivider({ text = "Skill Tree" })
U.upgrades = tUpg:CreateToggle({ name = "Auto Upgrades", value = false,
    callback = function(v) F.upgrades = v end })
U.upgradeDelay = tUpg:CreateSlider({ name = "Upgrade Delay", range = { 0.1, 10 }, increment = 0.1, value = 2, suffix = "s",
    callback = function(v) F.upgradeDelay = v end })
U.upgCats = tUpg:CreateDropdown({ name = "Category Filter", multiSelect = true,
    options = { "Money", "Luck", "Fortune", "Damage", "Roll Speed", "Sell", "Unit Storage", "Health", "Walkspeed", "Income" },
    value = {}, callback = function(sel) F.upgradeCats = (type(sel) == "table") and sel or {} end })

tDice:CreateDivider({ text = "Dice Shop" })
U.buyDice = tDice:CreateToggle({ name = "Auto Buy Best Dice", value = false,
    callback = function(v) F.buyDice = v end })
U.equipDice = tDice:CreateToggle({ name = "Auto Equip Best Dice", value = true,
    callback = function(v) F.equipDice = v end })
U.diceDelay = tDice:CreateSlider({ name = "Dice Check", range = { 0.1, 30 }, increment = 0.1, value = 5, suffix = "s",
    callback = function(v) F.diceDelay = v end })

tSell:CreateDivider({ text = "Auto Sell Threshold" })
U.sellInput = tSell:CreateInput({ name = "Rarity Threshold (e.g. 1t)", value = "",
    placeholder = "e.g. 1t, 500b, 10q",
    callback = function(text) applySellInput(text) end })
tSell:CreateButton({ name = "Set Threshold", callback = function()
    applySellInput(U.sellInput and U.sellInput.value or "")
end })
U.smartSell = tSell:CreateToggle({ name = "Smart Sell Threshold", value = false,
    callback = function(v) F.smartSell = v if v then smartSellTick(true) end end })
U.sellSync = tSell:CreateToggle({ name = "Apply Threshold To Game", value = false,
    callback = function(v)
        F.sellSync = v
        local s = getSig("SellService", "UpdateAutoSell")
        if v and F.sellThreshold > 0 then if s then pcall(function() s:Fire(F.sellThreshold) end) end
        elseif v then notify("Auto Sell", "Write a threshold first.")
        else if s then pcall(function() s:Fire(0) end) end notify("Auto Sell", "Game auto-sell off.") end
    end })
tSell:CreateDivider({ text = "Instant Bulk Sell" })
U.sellAuto = tSell:CreateToggle({ name = "Auto Instant Sell", value = false,
    callback = function(v) F.sellAuto = v end })
U.sellDelay = tSell:CreateSlider({ name = "Sell Check", range = { 0.1, 60 }, increment = 0.1, value = 10, suffix = "s",
    callback = function(v) F.sellDelay = v end })
U.keepBest = tSell:CreateSlider({ name = "Keep Top N", range = { 0, 25 }, increment = 1, value = 0,
    callback = function(v) F.keepBest = math.floor(v) end })
tSell:CreateButton({ name = "Sell Now (below threshold)", callback = function() task.spawn(function() doInstantSell() end) end })

tTower:CreateDivider({ text = "Tower Selection" })
local towerNames = { "Dragon Tower", "Cursed Tower", "Pirate Tower", "Hidden Leaf Tower", "Infinity Tower" }
local TOWER_DIFF_FALLBACK = { ["Dragon Tower"] = "Easy", ["Cursed Tower"] = "Medium", ["Pirate Tower"] = "Hard", ["Hidden Leaf Tower"] = "Extreme", ["Infinity Tower"] = "Infinity" }
local function towerLabel(name)
    local diff = TOWER_DIFF_FALLBACK[name]
    pcall(function()
        local t = G.TowersMod.Get(name)
        if t and t.difficulty and t.difficulty.name then diff = t.difficulty.name end
    end)

    local short = tostring(name):gsub(" Tower$", "")
    return diff and (short .. " [" .. diff .. "]") or short
end
pcall(function()
    local all = G.TowersMod.GetAll()
    local tmp = {}
    for k in pairs(all) do table.insert(tmp, k) end
    table.sort(tmp, function(a, b)
        local oa, ob = 99, 99
        pcall(function() oa = G.TowersMod.Get(a).order or 99 end)
        pcall(function() ob = G.TowersMod.Get(b).order or 99 end)
        if oa == ob then return a < b end
        return oa < ob
    end)
    if #tmp > 0 then towerNames = tmp end
end)
local towerLabels = {}
for _, n in ipairs(towerNames) do
    local lbl = towerLabel(n)
    towerByLabel[lbl] = n
    table.insert(towerLabels, lbl)
end
U.towerSel = tTower:CreateDropdown({ name = "Tower", options = towerLabels, value = towerLabels[1],
    callback = function(sel)
        local lbl = (type(sel) == "table") and (sel[1] or towerLabels[1]) or sel
        F.towerName = towerByLabel[lbl] or lbl
    end })
U.tower = tTower:CreateToggle({ name = "Auto Towers", value = false,
    callback = function(v)
        F.tower = v
        if not v then local c = getFn("Towers", "CancelTower") if c then pcall(c) end end
    end })
U.towerEquipBest = tTower:CreateToggle({ name = "Equip Best Tower Team", value = true,
    callback = function(v) F.towerEquipBest = v end })
U.smartTower = tTower:CreateToggle({ name = "Smart Tower (auto pick)", value = false,
    callback = function(v) F.smartTower = v if v and instantSmartCheck then task.spawn(instantSmartCheck) end end })
U.towerExitOn = tTower:CreateToggle({ name = "Exit At Floor", value = false,
    callback = function(v) F.towerExitOn = v end })
U.towerExitFloor = tTower:CreateInput({ name = "Exit Floor", value = "", numeric = true, placeholder = "e.g. 50",
    callback = function(t) F.towerExitFloor = math.floor(tonumber(t) or 0) end })
tTower:CreateButton({ name = "Stop Tower", callback = function()
    F.tower = false
    local c = getFn("Towers", "CancelTower") if c then pcall(c) end
end })
U.towerStat = tTower:CreateStat({ name = "Tower Wins", value = 0, icon = "rbxassetid://95008289608947", changeMode = "absolute" })
U.floorStat = tTower:CreateStat({ name = "Tower Steps", value = 0, icon = "rbxassetid://112002461760953", changeMode = "absolute" })
U.floorNowStat = tTower:CreateStat({ name = "Tower Floor", value = 0, icon = "rbxassetid://95008289608947", changeMode = "absolute" })
tTower:CreateDivider({ text = "Tower Rewards" })
U.towerGemStat = tTower:CreateStat({ name = "Tower Gems", value = 0, icon = "rbxassetid://99406696477560", changeMode = "absolute" })
U.towerTraitStat = tTower:CreateStat({ name = "Tower Traits", value = 0, icon = "rbxassetid://133531024200552", changeMode = "absolute" })
tTower:CreateButton({ name = "Reset Tower Stats", callback = function()
    Stats.towerWins = {}
    Stats.towerFloors = 0
    Stats.towerRewards = {}
    Stats.towerGems = 0
    Stats.towerTraits = 0
    pcall(function()
        setStat(U.towerStat, 0)
        setStat(U.floorStat, 0)
        setStat(U.towerGemStat, 0)
        setStat(U.towerTraitStat, 0)
    end)
    pcall(saveNow)
    notify("Tower", "Tower stats reset.")
end })

tPotion:CreateDivider({ text = "Auto Potion" })
U.potionAuto = tPotion:CreateToggle({ name = "Auto Potion", value = false,
    callback = function(v) F.potionAuto = v end })
local potDrop = nil
local function potBuffText(e)
    local parts = {}
    for bn, b in pairs(e.buffs or {}) do
        table.insert(parts, "x" .. tostring(b.amount) .. " " .. (bn:gsub(" Multiplier", "")))
    end
    table.sort(parts)
    return table.concat(parts, "+")
end
local function potDurText(d)
    d = tonumber(d) or 0
    if d % 60 == 0 then return (d / 60) .. "m" end
    return tostring(math.floor(d / 6) / 10) .. "m"
end
local function buildPotOptions(withCount)
    local labels = {}
    potByLabel = {}
    if not G.BoostConfig or not G.BoostConfig.entries then return { "(potion list failed to load)" } end
    local counts = {}
    if withCount then
        for _, e in pairs(inventory()) do
            if type(e) == "table" and e.name then counts[e.name] = tonumber(e.amount) or 0 end
        end
    end
    for name, e in pairs(G.BoostConfig.entries) do
        local lbl = name .. " [T" .. tostring(e.tier) .. " | " .. potBuffText(e) .. " | " .. potDurText(e.duration) .. "]"
        if withCount then lbl = lbl .. " (" .. (counts[name] or 0) .. " owned)" end
        potByLabel[lbl] = name
        table.insert(labels, lbl)
    end
    table.sort(labels)
    return labels
end
potDrop = tPotion:CreateDropdown({ name = "Potions", multiSelect = true,
    options = buildPotOptions(false), value = {},
    callback = function(sel)
        F.potions = {}
        if type(sel) == "table" then
            for _, lbl in ipairs(sel) do
                local n = potByLabel[lbl]
                if n then table.insert(F.potions, n) end
            end
        end
    end })
U.potions = potDrop
U.potionBest = tPotion:CreateToggle({ name = "Best Per Category", description = "Uses the highest owned tier per category. Lower tiers would be wasted, since only the highest tier per category applies in-game.", value = true,
    callback = function(v) F.potionBest = v end })
U.potionExtend = tPotion:CreateToggle({ name = "Extend While Active", value = false,
    callback = function(v) F.potionExtend = v end })
U.potionDelay = tPotion:CreateSlider({ name = "Potion Check", range = { 0.1, 30 }, increment = 0.1, value = 5, suffix = "s",
    callback = function(v) F.potionDelay = v end })
tPotion:CreateButton({ name = "Refresh List (show counts)", callback = function()
    if not potDrop then return end
    local keep = {}
    for _, n in ipairs(F.potions) do keep[n] = true end
    potDrop:Refresh(buildPotOptions(true))
    local resel = {}
    for lbl, n in pairs(potByLabel) do if keep[n] then table.insert(resel, lbl) end end
    if #resel > 0 then potDrop:Set(resel) end
end })

tReroll:CreateDivider({ text = "Auto Grade" })
U.gradeAuto = tReroll:CreateToggle({ name = "Auto Grade", value = false,
    callback = function(v) F.gradeAuto = v end })
U.gradeTargets = tReroll:CreateDropdown({ name = "Target Grades", multiSelect = true,
    options = buildGradeOptions(), value = {},
    callback = function(sel)
        F.gradeTargets = {}
        if type(sel) == "table" then for _, lbl in ipairs(sel) do local n = gradeByLabel[lbl] if n then table.insert(F.gradeTargets, n) end end end
    end })
U.gradeUnits = tReroll:CreateDropdown({ name = "Grade Units", multiSelect = true,
    options = buildUnitOptions(gradeUnitByLabel, "grade"), value = {},
    callback = function(sel)
        F.gradeUnits = {}
        if type(sel) == "table" then for _, lbl in ipairs(sel) do local k = gradeUnitByLabel[lbl] if k then table.insert(F.gradeUnits, k) end end end
    end })
tReroll:CreateButton({ name = "Refresh Grade Units", callback = function()
    local n = refreshUnitDrop(U.gradeUnits, gradeUnitByLabel, F.gradeUnits, "grade") or 0
    notify("Grade", n .. " units listed.")
end })
U.gradeAll = tReroll:CreateToggle({ name = "Grade: All Units", value = false,
    callback = function(v)
        F.gradeAll = v
        if v and F.gradePlacedOnly then
            F.gradePlacedOnly = false
            if U.gradePlacedOnly then pcall(function() U.gradePlacedOnly:Set(false, true) end) end
        end
    end })
U.gradePlacedOnly = tReroll:CreateToggle({ name = "Grade: Placed Units Only", description = "Only reroll units currently placed on slots, ignore idle inventory units.", value = false,
    callback = function(v)
        F.gradePlacedOnly = v
        if v and F.gradeAll then
            F.gradeAll = false
            if U.gradeAll then pcall(function() U.gradeAll:Set(false, true) end) end
        end
    end })
U.gradeDelay = tReroll:CreateSlider({ name = "Grade Delay", range = { 0.1, 10 }, increment = 0.1, value = 2, suffix = "s",
    callback = function(v) F.gradeDelay = v end })
U.gemReserve = tReroll:CreateInput({ name = "Grade: Gems Reserve", value = "", numeric = true, placeholder = "e.g. 100",
    callback = function(t) F.gemReserve = math.floor(tonumber(t) or 0) end })
tReroll:CreateDivider({ text = "Auto Trait" })
U.traitAuto = tReroll:CreateToggle({ name = "Auto Trait", value = false,
    callback = function(v) F.traitAuto = v end })
U.traitTargets = tReroll:CreateDropdown({ name = "Target Traits", multiSelect = true,
    options = buildTraitOptions(), value = {},
    callback = function(sel)
        F.traitTargets = {}
        if type(sel) == "table" then for _, lbl in ipairs(sel) do local n = traitByLabel[lbl] if n then table.insert(F.traitTargets, n) end end end
    end })
U.traitUnits = tReroll:CreateDropdown({ name = "Trait Units", multiSelect = true,
    options = buildUnitOptions(traitUnitByLabel, "trait"), value = {},
    callback = function(sel)
        F.traitUnits = {}
        if type(sel) == "table" then for _, lbl in ipairs(sel) do local k = traitUnitByLabel[lbl] if k then table.insert(F.traitUnits, k) end end end
    end })
tReroll:CreateButton({ name = "Refresh Trait Units", callback = function()
    local n = refreshUnitDrop(U.traitUnits, traitUnitByLabel, F.traitUnits, "trait") or 0
    notify("Trait", n .. " units listed.")
end })
U.traitAll = tReroll:CreateToggle({ name = "Trait: All Units", value = false,
    callback = function(v)
        F.traitAll = v
        if v and F.traitPlacedOnly then
            F.traitPlacedOnly = false
            if U.traitPlacedOnly then pcall(function() U.traitPlacedOnly:Set(false, true) end) end
        end
    end })
U.traitPlacedOnly = tReroll:CreateToggle({ name = "Trait: Placed Units Only", description = "Only reroll units currently placed on slots, ignore idle inventory units.", value = false,
    callback = function(v)
        F.traitPlacedOnly = v
        if v and F.traitAll then
            F.traitAll = false
            if U.traitAll then pcall(function() U.traitAll:Set(false, true) end) end
        end
    end })
U.traitDelay = tReroll:CreateSlider({ name = "Trait Delay", range = { 0.1, 10 }, increment = 0.1, value = 2, suffix = "s",
    callback = function(v) F.traitDelay = v end })
U.rerollReserve = tReroll:CreateInput({ name = "Trait: Trait Reroll Reserve", value = "", numeric = true, placeholder = "e.g. 50",
    callback = function(t) F.rerollReserve = math.floor(tonumber(t) or 0) end })

tTrade:CreateDivider({ text = "Auto Trade" })
U.tradeAuto = tTrade:CreateToggle({ name = "Auto Trade", value = false,
    callback = function(v) F.tradeAuto = v end })
U.tradeInput = tTrade:CreateInput({ name = "Min Money (e.g. 1b)", value = "", placeholder = "e.g. 1b, 500m, 10qd",
    callback = function(text) applyTradeInput(text) end })
tTrade:CreateButton({ name = "Set Min Money", callback = function()
    applyTradeInput(U.tradeInput and U.tradeInput.value or "")
end })
U.tradeRetries = tTrade:CreateSlider({ name = "Retries Per Player", range = { 1, 10 }, increment = 1, value = 3,
    callback = function(v) F.tradeRetries = math.floor(v) end })
U.tradeHop = tTrade:CreateToggle({ name = "Hop When Empty", value = true,
    callback = function(v) F.tradeHop = v end })
U.tradeHopDelay = tTrade:CreateSlider({ name = "Hop Delay", range = { 1, 30 }, increment = 1, value = 8, suffix = "s",
    callback = function(v) F.tradeHopDelay = math.floor(v) end })
U.tradeAutoGo = tTrade:CreateToggle({ name = "Auto Ready + Accept", value = true,
    callback = function(v) F.tradeAutoGo = v end })
U.tradeNeedOffer = tTrade:CreateToggle({ name = "Require Partner Offer", value = true,
    callback = function(v) F.tradeNeedOffer = v end })
U.tradeMinItems = tTrade:CreateSlider({ name = "Min Partner Items", range = { 0, 10 }, increment = 1, value = 1,
    callback = function(v) F.tradeMinItems = math.floor(v) end })
U.tradeChatOn = tTrade:CreateToggle({ name = "Trade Chat", value = false,
    callback = function(v) F.tradeChatOn = v end })
U.tradeChatMsg = tTrade:CreateInput({ name = "Chat Words (a, b)", value = "", placeholder = "e.g. pls, plsss",
    callback = function(t) F.tradeChatMsg = t end })
tTrade:CreateButton({ name = "Send Test Chat", callback = function()
    task.spawn(sendTradeChat)
end })
tTrade:CreateDivider({ text = "Trade Webhook" })
U.tradeHookUrl = tTrade:CreateInput({ name = "Trade Webhook URL", value = "", placeholder = "https://discord.com/api/webhooks/...",
    callback = function(t) F.tradeHookUrl = t end })
U.tradeHookOn = tTrade:CreateToggle({ name = "Trade Alerts", value = false,
    callback = function(v) F.tradeHookOn = v end })
local function stopTradeAll()
    F.tradeAuto = false
    if U.tradeAuto then pcall(function() U.tradeAuto:Set(false, true) end) end
    local c = getSig("TradeService", "CancelTrade")
    if c then pcall(function() c:Fire() end) end
    notify("Trade", "Auto Trade stopped.")
end
tTrade:CreateButton({ name = "Stop + Cancel Trade", callback = function()
    stopTradeAll()
end })
U.tradeSentStat = tTrade:CreateStat({ name = "Requests Sent", value = 0, icon = "rbxassetid://72821498911763", changeMode = "absolute" })
U.tradeOpenStat = tTrade:CreateStat({ name = "Trades Opened", value = 0, icon = "rbxassetid://72821498911763", changeMode = "absolute" })
U.moneyStat = tStats:CreateStat({ name = "Money", value = money(), icon = "rbxassetid://93129522258096", changeBaseline = "initial" })
U.rollStat = tStats:CreateStat({ name = "Rolls", value = rolls(), icon = "rbxassetid://134876970337785", changeBaseline = "initial" })
U.soldStat = tStats:CreateStat({ name = "Sold", value = 0, icon = "rbxassetid://118330449034393", changeMode = "absolute" })
U.potionStat = tStats:CreateStat({ name = "Active Potions", value = 0, icon = "rbxassetid://92709571106091", changeMode = "absolute" })
local console = tStats:CreateConsole({ name = "Log", height = 160, follow = true, maxLines = 120 })
local LogLines, LOG_KEEP = {}, 200
clog = function(m)
    pcall(function()
        table.insert(LogLines, tostring(m))
        if #LogLines > LOG_KEEP then table.remove(LogLines, 1) end
    end)
    pcall(function() console:Append(m) end)
end
tStats:CreateButton({ name = "Copy Log", callback = function()
    if typeof(setclipboard) ~= "function" then notify("Log", "setclipboard not supported.") return end
    local ok = pcall(function() setclipboard(table.concat(LogLines, "\n")) end)
    notify("Log", ok and (#LogLines .. " lines copied.") or "Copy failed.")
end })

tChanges:CreateText({
    name = '<b><font color="#60a5fa">v1.6 - Game-specific FPS Boost</font></b>',
    icon = "rbxassetid://112634880544308",
    text = [[<font color="#4ade80">•</font> FPS Boost now hides map junk: leaderboards, Best Roll podium + side statues, Towers building, other players/bases and decor meshes (yours stay, OFF restores all)
<font color="#4ade80">•</font> Mesh textures stripped + flattened to SmoothPlastic on top of the existing shadows/particles/lights/postfx pass
<font color="#4ade80">•</font> Auto Execute On Teleport fixed: no more "index nil with 'CharacterAdded'" crash on rejoin - the script now waits for the client (game loaded, LocalPlayer/PlayerGui, game modules) while the new server is still booting]]
})

tChanges:CreateText({
    name = '<b><font color="#60a5fa">v1.5 - Tower Exit & Tower Webhooks</font></b>',
    icon = "rbxassetid://112634880544308",
    text = [[<font color="#4ade80">•</font> Tower: Exit At Floor - leaves the run at your floor, then re-enters automatically
<font color="#4ade80">•</font> Webhook: Tower Alerts - posts run rewards with images on clear and on exit
<font color="#4ade80">•</font> Tower list: shorter names so difficulty tags always fit
<font color="#4ade80">•</font> Cleanup: removed Use Now, Show Active, Rebirth Now and Claim Quests Now buttons
<font color="#4ade80">•</font> Fix: script load error resolved]]
})

tChanges:CreateText({
    name = '<b><font color="#60a5fa">v1.4 - Auto Redeem Codes</font></b>',
    icon = "rbxassetid://112634880544308",
    text = [[<font color="#4ade80">•</font> Main tab: Auto Redeem Codes - code list auto-detected from the game itself (RELEASE, UPDATE1-4, 1K-40K CCU + future codes) + Redeem All Codes Now
<font color="#4ade80">•</font> Skips already-redeemed codes, retries on an interval for future codes]]
})

tChanges:CreateText({
    name = '<b><font color="#60a5fa">v1.3 - Smart Tower & Trade reliability</font></b>',
    icon = "rbxassetid://112634880544308",
    text = [[<font color="#4ade80">•</font> Smart Tower uses real buffed stats (upgrades + active potions), trusts session wins, logs full sim breakdown
<font color="#4ade80">•</font> Grade/Trait: Placed Units Only mode (ignores name filter, mutually exclusive with All Units)
<font color="#4ade80">•</font> Unit dropdowns auto-refresh after every roll + on warmup, with refresh confirmation
<font color="#4ade80">•</font> Trade counting/webhook fixed (game sends Ended+reason) and works for manual trades too
<font color="#4ade80">•</font> Trade timeout: accepted trades get 45s, then auto-cancel and move on
<font color="#4ade80">•</font> Trade never sends requests or hops while you are in a trade
<font color="#4ade80">•</font> Grade/Trait unit lists show every copy separately with its own grade/trait (placed marked ★) - pick exact units, no more merged D+S rows]]
})

tChanges:CreateText({
    name = '<b><font color="#60a5fa">v1.2 - Trade & Smart Tower</font></b>',
    icon = "rbxassetid://112634880544308",
    text = [[<font color="#4ade80">•</font> Trade webhook: completed trades post partner, what you gave and what you got (fixed: game sends Ended+reason, not a Completed event)
<font color="#4ade80">•</font> Trade timeout: accepted trades get 45s, then auto-cancel and move to the next player
<font color="#4ade80">•</font> Grade/Trait: Placed Units Only option - reroll just your slot team, not idle inventory
<font color="#4ade80">•</font> Trade stays idle until Min Money is set - no more "nobody matches" hop spam
<font color="#4ade80">•</font> Server Hop reworked: no 3-try give-up, 30s cooldown instead of hop storms
<font color="#4ade80">•</font> Smart Tower checks instantly on toggle and reports every run (already best or new pick)
<font color="#4ade80">•</font> All UI text English]]
})

tChanges:CreateText({
    name = '<b><font color="#60a5fa">v1.1 - Speed & Performance</font></b>',
    icon = "rbxassetid://112634880544308",
    text = [[<font color="#4ade80">•</font> Auto Towers rebuilt to match the game's own Auto speed (back-to-back floor calls, no artificial wait)
<font color="#4ade80">•</font> Stronger FPS Boost: shadows, particles, trails, beams, decals, lights, post effects, terrain water + render quality
<font color="#4ade80">•</font> FPS Boost is now a toggle - saved with settings and re-applied automatically after rejoin/re-execute
<font color="#4ade80">•</font> Removed obsolete Floor Wait slider (tower loop is adaptive now)]]
})

tChanges:CreateText({
    name = '<b><font color="#4ade80">v1.0 - Release</font></b>',
    icon = "rbxassetid://138588191124173",
    text = [[<font color="#4ade80">•</font> Auto Collect Money with live total counter
<font color="#4ade80">•</font> Auto Level Up with max level limit
<font color="#4ade80">•</font> Auto Place Best, replaces weakest unit when full
<font color="#4ade80">•</font> Auto Rebirth
<font color="#4ade80">•</font> Auto Upgrades with category filter
<font color="#4ade80">•</font> Auto Buy and Equip Best Dice
<font color="#4ade80">•</font> Auto Sell with instant game sync and protected bulk sell
<font color="#4ade80">•</font> Auto Towers with difficulty picker, honest wins and live floor tracker
<font color="#4ade80">•</font> Auto Potion, best tier per category
<font color="#4ade80">•</font> Auto Grade and Trait reroll with targets, chases above protected on demand
<font color="#4ade80">•</font> Auto Roll with real game HIDE, tower screen hide
<font color="#4ade80">•</font> Auto Claim Quests with one-click button
<font color="#4ade80">•</font> Discord webhooks for rolls and stats with game images
<font color="#4ade80">•</font> Settings save per player and restore on next run
<font color="#4ade80">•</font> Rayfield config profiles, apply them on other accounts
<font color="#4ade80">•</font> Server tools: Rejoin, Server Hop, Low-Player Hop
<font color="#4ade80">•</font> Character: WalkSpeed, Fly, Noclip, Anti-AFK, FPS Boost
<font color="#4ade80">•</font> Auto Execute on teleport with your own loadstring]]
})

tStats:CreateDivider({ text = "General" })
tStats:CreateButton({ name = "Reset Growth Stats", callback = function()
    pcall(function() U.moneyStat:ResetBaseline() end)
    pcall(function() U.rollStat:ResetBaseline() end)
end })
tStats:CreateButton({ name = "Close Menu (Unload)", callback = function()
    pcall(adhShutdown)
    F.tower = false
    pcall(function() local c = getFn("Towers", "CancelTower") if c then c() end end)
    pcall(function()
        if typeof(getgenv) == "function" then getgenv().ADH_Heartbeat = nil end
    end)
    pcall(function() window:Unload() end)
end })

tSettings:CreateDivider({ text = "Settings Saving" })
U.saveSettings = tSettings:CreateToggle({ name = "Auto Save Settings", value = true,
    callback = function(v)
        F.saveSettings = v
        if v then pcall(saveNow) end
    end })
U.autoMinimize = tSettings:CreateToggle({ name = "Auto Minimize UI", description = "Automatically minimizes the menu shortly after load.",
    value = false,
    callback = function(v)
        F.autoMinimize = v
        if v and not loadingCfg then hideUIAuto() end
    end })
tSettings:CreateDivider({ text = "Server" })
tSettings:CreateButton({ name = "Rejoin Server", callback = function() doRejoin(true) end })
tSettings:CreateButton({ name = "Server Hop", callback = function() doHop(false) end })
tSettings:CreateButton({ name = "Hop: Low Player Server", callback = function() doHop(true) end })
tSettings:CreateDivider({ text = "Auto Execute" })
U.reexec = tSettings:CreateToggle({ name = "Auto Execute On Teleport", value = true,
    callback = function(v) F.reexec = v end })
tSettings:CreateDivider({ text = "Character" })
U.wsOn = tSettings:CreateToggle({ name = "WalkSpeed", value = false,
    callback = function(v) F.wsOn = v applyWS() end })
U.wsValue = tSettings:CreateSlider({ name = "WalkSpeed Value", range = { 16, 250 }, increment = 1, value = 16,
    callback = function(v) F.wsValue = math.floor(v) applyWS() end })
U.flyOn = tSettings:CreateToggle({ name = "Fly (WASD + Space/Shift)", value = false,
    callback = function(v) setFly(v) end })
U.flySpeed = tSettings:CreateSlider({ name = "Fly Speed", range = { 10, 200 }, increment = 5, value = 50,
    callback = function(v) F.flySpeed = v end })
U.noclip = tSettings:CreateToggle({ name = "Noclip", value = false,
    callback = function(v) F.noclip = v end })
U.afk = tSettings:CreateToggle({ name = "Anti-AFK", value = true,
    callback = function(v) F.afk = v end })
tSettings:CreateDivider({ text = "Performance" })
U.fpsOn = tSettings:CreateToggle({ name = "FPS Boost", description = "Hides leaderboards, Best Roll podium + side statues, Towers building, other players/bases, outer islands, all trees/rocks/clovers/decor (lobby, stalls, yours + Shop stay). Plus shadows/particles/mesh-textures/lights/postfx off, render quality lowered. FPS cap is never touched. Saved and re-applied on rejoin.",
    value = false, callback = function(v) F.fpsOn = v applyFpsBoost(v) end })
tSettings:CreateDivider({ text = "Rayfield Configs" })
local cfgDrop
local cfgSelName = ""
local cfgNameInput = tSettings:CreateInput({ name = "Config Name", value = "", placeholder = "e.g. main-farm",
    callback = function() end })
local function refreshCfgList()
    if not cfgDrop then return end
    local list = {}
    pcall(function() list = window:ListConfigs() or {} end)
    if type(list) ~= "table" then list = {} end
    table.sort(list)
    pcall(function() cfgDrop:Refresh(list) end)
end
cfgDrop = tSettings:CreateDropdown({ name = "Saved Configs", options = {},
    callback = function(sel)
        cfgSelName = (type(sel) == "table") and (sel[1] or "") or (sel or "")
    end })
tSettings:CreateButton({ name = "Save New Config", callback = function()
    local nm = cfgNameInput and cfgNameInput.value or ""
    nm = nm:gsub("^%s+", ""):gsub("%s+$", "")
    if nm == "" then notify("Config", "Enter a name first.") return end
    local ok = pcall(function() window:Save(nm) end)
    notify("Config", ok and ("Saved: " .. nm) or "Save failed.")
    refreshCfgList()
end })
tSettings:CreateButton({ name = "Load Selected", callback = function()
    if cfgSelName == "" then notify("Config", "Select a config first.") return end
    local ok = pcall(function() window:Load(cfgSelName) end)
    notify("Config", ok and ("Loaded: " .. cfgSelName) or "Load failed.")
end })
tSettings:CreateButton({ name = "Overwrite Selected", callback = function()
    if cfgSelName == "" then notify("Config", "Select a config first.") return end
    local ok = pcall(function() window:Save(cfgSelName) end)
    notify("Config", ok and ("Overwritten: " .. cfgSelName) or "Save failed.")
end })
tSettings:CreateButton({ name = "Delete Selected", callback = function()
    if cfgSelName == "" then notify("Config", "Select a config first.") return end
    pcall(function() window:DeleteConfig(cfgSelName) end)
    cfgSelName = ""
    refreshCfgList()
    notify("Config", "Deleted.")
end })
tSettings:CreateButton({ name = "Refresh Config List", callback = function() refreshCfgList() end })
refreshCfgList()

tHooks:CreateDivider({ text = "Roll Alerts" })
U.rollHookUrl = tHooks:CreateInput({ name = "Roll Webhook URL", value = "", placeholder = "https://discord.com/api/webhooks/...",
    callback = function(t) F.rollHookUrl = t end })
U.rollHookOn = tHooks:CreateToggle({ name = "Roll Alerts", value = false,
    callback = function(v) F.rollHookOn = v end })
U.rollMinT = tHooks:CreateInput({ name = "Roll Min Chance", value = "", placeholder = "e.g. 1b - only above this is sent",
    callback = function(t) F.rollHookMin = parseCompact(t) or 0 end })
tHooks:CreateDivider({ text = "Stat Reports" })
U.statHookUrl = tHooks:CreateInput({ name = "Stat Webhook URL", value = "", placeholder = "https://discord.com/api/webhooks/...",
    callback = function(t) F.statHookUrl = t end })
U.statHookOn = tHooks:CreateToggle({ name = "Stat Reports", value = false,
    callback = function(v) F.statHookOn = v end })
U.statHookInterval = tHooks:CreateSlider({ name = "Stat Report Interval", range = { 60, 1800 }, increment = 60, value = 300, suffix = "s",
    callback = function(v) F.statHookInterval = math.floor(v) end })
U.statHookFields = tHooks:CreateDropdown({ name = "Stat Fields", multiSelect = true,
    options = { "Money", "Rolls", "Rebirth", "Gems", "Trait Reroll" }, value = {},
    callback = function(sel) F.statHookFields = (type(sel) == "table") and sel or {} end })
tHooks:CreateButton({ name = "Send Test Stats", callback = function()
    task.spawn(function()
        if type(F.statHookUrl) == "string" and F.statHookUrl ~= "" then
            notify("Webhook", sendStatsHook(F.statHookUrl) and "Test sent." or "Send failed.")
        else
            notify("Webhook", "Set a stat webhook URL first.")
        end
    end)
end })
tHooks:CreateDivider({ text = "Tower Clears" })
U.towerHookUrl = tHooks:CreateInput({ name = "Tower Webhook URL", value = "", placeholder = "https://discord.com/api/webhooks/...",
    callback = function(t) F.towerHookUrl = t end })
U.towerHookOn = tHooks:CreateToggle({ name = "Tower Alerts", value = false,
    callback = function(v) F.towerHookOn = v end })
U.towerHookFields = tHooks:CreateDropdown({ name = "Tower Fields", multiSelect = true,
    options = { "Floors", "Wins", "Floor Drops", "Clear Bonus", "Item Images" }, value = {},
    callback = function(sel) F.towerHookFields = (type(sel) == "table") and sel or {} end })

if not G.ok or #G.missing > 0 then
    notify("Warning", "Some modules failed to load: " .. table.concat(G.missing, ", "))
    clog("MISSING: " .. table.concat(G.missing, ", "))
else
    clog("Ready. Money: " .. fmt(money()))
end
end

local doCollect, doLevelUp, doPlaceBest, doUpgrades, doRebirth, doDice, activePotions
do
function doCollect()
    local sig = getSig("PlotService", "CollectBalance")
    if not sig then return end
    local list, s = unlockedSlots()
    for _, slot in ipairs(list) do
        if not F.collect or not Alive then break end
        local d = s[tostring(slot)]
        local amt = d and (tonumber(d.balance) or 0) or 0
        if amt > 0 then
            pcall(function() sig:Fire(slot) end)
            Stats.collectedMoney += amt
            task.wait(0.15)
        end
    end
end

function doLevelUp()
    local sig = getSig("PlotService", "LevelUpSlot")
    if not sig then return end
    local list, s = unlockedSlots()
    local cands = {}
    for _, slot in ipairs(list) do
        local d = s[tostring(slot)]
        local uid = d and d.unitId
        if uid then
            local e = invEntry(uid)
            if e and e.attributes then
                local lvl = tonumber(e.attributes.level) or 1
                if lvl < F.maxLevel then
                    local price = 0
                    pcall(function() price = G.UnitUtil.GetLevelPrice(e.name, e.attributes) end)
                    table.insert(cands, { slot = slot, lvl = lvl, price = price })
                end
            end
        end
        if not F.levelup or not Alive then break end
    end
    table.sort(cands, function(a, b) return a.lvl < b.lvl end)
    local m = money()
    for i = 1, math.min(2, #cands) do
        local c = cands[i]
        if m >= c.price then
            pcall(function() sig:Fire(c.slot) end)
            Stats.leveled += 1
            m -= c.price
            task.wait(0.4)
        end
    end
end

local function doEquip(key)
    local ok = pcall(function() return G.UnitController.Equip(key) end)
    if ok then task.wait(0.4) return true end
    return false
end
function doPlaceBest()
    if Busy.place then return end
    Busy.place = true
    local ok, err = pcall(function()
        local list, s = unlockedSlots()
        local placed, placedKeys = {}, {}
        for _, slot in ipairs(list) do
            local d = s[tostring(slot)]
            if d and d.unitId then
                local e = invEntry(d.unitId)
                if e then
                    placed[slot] = { key = d.unitId, chance = unitChance(e), name = e.name }
                    placedKeys[d.unitId] = true
                end
            end
        end
        local best, bestChance = nil, 0
        for key, e in pairs(inventory()) do
            if isUnitEntry(e) and not placedKeys[key] and key ~= equippedKey() then
                if not (e.attributes and e.attributes.locked) then
                    local ch = unitChance(e)
                    if ch > bestChance then best, bestChance = key, ch end
                end
            end
        end
        if not best then return end
        for _, slot in ipairs(list) do
            if not s[tostring(slot)] or not s[tostring(slot)].unitId then
                if doEquip(best) then
                    local sig = getSig("PlotService", "InteractSlot")
                    if sig then pcall(function() sig:Fire(slot) end) end
                    local okPlace = waitVerify(function()
                        local d = slots()[tostring(slot)]
                        return d and d.unitId == best
                    end, 3)
                    local be = invEntry(best) or {}
                    if okPlace then
                        clog("Placed: " .. tostring(be.name) .. " [1 in " .. fmt(bestChance) .. "] -> slot " .. slot)
                    else
                        clog("Place FAILED (server refused): " .. tostring(be.name) .. " [1 in " .. fmt(bestChance) .. "] -> slot " .. slot)
                    end
                end
                return
            end
        end
        if not F.replaceWorst then return end
        local worstSlot, worst = nil, nil
        for slot, info in pairs(placed) do
            if not worst or info.chance < worst then worstSlot, worst = slot, info.chance end
        end
        if worstSlot and bestChance > worst then
            local sig = getSig("PlotService", "InteractSlot")
            if not sig then return end
            pcall(function() sig:Fire(worstSlot) end)
            local emptied = waitVerify(function()
                local d = slots()[tostring(worstSlot)]
                return not (d and d.unitId)
            end, 3)
            if not emptied then
                local eb = getSig("PlotService", "EquipBest")
                if eb then pcall(function() eb:Fire() end) end
                return
            end
            task.wait(0.3)
            if doEquip(best) then
                pcall(function() sig:Fire(worstSlot) end)
                local okPlace = waitVerify(function()
                    local d = slots()[tostring(worstSlot)]
                    return d and d.unitId == best
                end, 3)
                local be = invEntry(best) or {}
                local winfo = placed[worstSlot] or {}
                if okPlace then
                    clog("Swapped slot " .. worstSlot .. ": " .. tostring(winfo.name) .. " [1 in " .. fmt(worst) .. "] -> " .. tostring(be.name) .. " [1 in " .. fmt(bestChance) .. "]")
                else
                    clog("Swap FAILED (server refused): " .. tostring(be.name) .. " [1 in " .. fmt(bestChance) .. "] -> slot " .. worstSlot)
                end
            end
        end
    end)
    if not ok then clog("Place error: " .. tostring(err)) end
    Busy.place = false
end

local function catOf(name)
    for _, c in ipairs({ "Roll Speed", "Unit Storage", "Money", "Luck", "Fortune", "Damage", "Sell", "Health", "Walkspeed", "Income" }) do
        if name:sub(1, #c) == c then return c end
    end
    return nil
end
local badUpg = {}
local lastUpgFailLog = 0
function doUpgrades()
    local sig = buyUpgradeSig()
    if not sig or not G.Upgrades or not G.TreeStructure then return end
    local owned = {}
    pcall(function() owned = G.DC.Upgrades() or {} end)
    local seen, list = {}, {}
    local function kidsOf(p)
        local ok, r = pcall(function() return G.TreeStructure.GetChildren(p) end)
        if ok and type(r) == "table" then return r end
        return {}
    end
    local function consider(name)
        if type(name) ~= "string" or owned[name] or seen[name] then return end
        seen[name] = true
        local d = G.Upgrades[name]
        if type(d) == "table" and d.price then
            table.insert(list, { name = name, price = d.price })
        end
    end
    for _, n in ipairs(kidsOf("Start")) do consider(n) end
    consider("Start")
    for name in pairs(owned) do
        for _, n in ipairs(kidsOf(name)) do consider(n) end
    end
    local flt = {}
    for _, u in ipairs(list) do
        if #F.upgradeCats == 0 then
            table.insert(flt, u)
        else
            local c = catOf(u.name)
            for _, want in ipairs(F.upgradeCats) do
                if c == want then table.insert(flt, u) break end
            end
        end
    end
    table.sort(flt, function(a, b) return a.price < b.price end)
    local m = money()
    for _, u in ipairs(flt) do
        if m >= u.price then
            if (badUpg[u.name] or 0) > os.clock() then continue end
            pcall(function() sig:Fire(u.name) end)
            task.wait(0.8)
            local got = false
            pcall(function() got = G.DC.Upgrades[u.name]() == true end)
            if got then
                badUpg[u.name] = nil
                Stats.upgraded += 1
                clog("Upgrade: " .. u.name)
            else
                badUpg[u.name] = os.clock() + 60
                if os.clock() - lastUpgFailLog > 10 then
                    lastUpgFailLog = os.clock()
                    clog("Upgrade rejected by server: " .. u.name)
                end
            end
            break
        else
            break
        end
    end
end

function doRebirth()
    local next = nil
    pcall(function() next = G.Rebirths.GetNext(rebirth()) end)
    if not next then return end
    if money() >= (next.cost or math.huge) then
        local s = getSig("RebirthService", "Rebirth")
        if s then
            pcall(function() s:Fire() end)
            Stats.rebirthed += 1
            clog("Rebirth done!")
            notify("Rebirth", "Rebirth done.")
            task.wait(8)
        end
    end
end

local function bestDiceOwned()
    local owned = {}
    pcall(function() owned = G.DC.OwnedDice() or {} end)
    local cur = nil
    pcall(function() cur = G.DC.Dice() end)
    local all = G.DiceMod.GetAll()
    local best, bestLuck = cur, -1
    for name in pairs(owned) do
        local d = all[name]
        if d and (d.luck or 0) > bestLuck then best, bestLuck = name, d.luck end
    end
    return best, cur
end
function doDice()
    if Busy.dice then return end
    Busy.dice = true
    pcall(function()
        local all = G.DiceMod.GetAll()
        local m = money()
        if F.buyDice then
            local ordered = {}
            for name, d in pairs(all) do
                if d.price then table.insert(ordered, { name = name, price = d.price, luck = d.luck or 0 }) end
            end
            table.sort(ordered, function(a, b) return a.luck > b.luck end)
            local owned = {}
            pcall(function() owned = G.DC.OwnedDice() or {} end)
            for _, d in ipairs(ordered) do
                if not owned[d.name] and m >= d.price then
                    local s = getSig("DiceShopService", "BuyDice")
                    if s then pcall(function() s:Fire(d.name) end) end
                    clog("Dice bought: " .. d.name)
                    task.wait(0.6)
                    break
                end
            end
        end
        if F.equipDice then
            local best, cur = bestDiceOwned()
            if best and best ~= cur then
                local s = getSig("DiceShopService", "EquipDice")
                if s then pcall(function() s:Fire(best) end) end
            end
        end
    end)
    Busy.dice = false
end

local function potionLeft(entry)
    if not entry or type(entry) ~= "table" then return 0 end
    if type(entry.startedAt) == "number" and type(entry.remaining) == "number" then
        local now = 0
        pcall(function() now = workspace:GetServerTimeNow() end)
        return math.max(0, entry.remaining - math.max(0, now - entry.startedAt))
    end
    if type(entry.expiresAt) == "number" then
        local t = 0
        pcall(function() t = os.time() end)
        return math.max(0, entry.expiresAt - t)
    end
    if type(entry.remaining) == "number" then return math.max(0, entry.remaining) end
    return 1e9
end
function activePotions()
    local out = {}
    local ok, ae = pcall(function() return G.DC.ActiveEntries() end)
    if not ok or type(ae) ~= "table" then return out end
    for name, e in pairs(ae) do
        if type(e) == "table" then
            if potionLeft(e) > 3 then out[name] = potionLeft(e) end
        elseif e then
            out[name] = 1e9
        end
    end
    return out
end
local function potionKeys()
    local out = {}
    for key, e in pairs(inventory()) do
        if type(e) == "table" and e.name and (tonumber(e.amount) or 0) >= 1 then
            local ok, cfg = pcall(function() return G.EntryRegistry.getEntryConfig(e.name) end)
            if ok and cfg and cfg.kind == "Boost" then out[e.name] = key end
        end
    end
    return out
end
doPotionTick = function()
    if Busy.potion then return end
    if not G.BoostConfig or not G.BoostConfig.entries then return end
    Busy.potion = true
    pcall(function()
        if #F.potions == 0 then return end
        local entries = G.BoostConfig.entries
        local have = potionKeys()
        local active = activePotions()
        local cands = {}
        for _, name in ipairs(F.potions) do
            local e = entries[name]
            if e and have[name] then
                table.insert(cands, { name = name, cat = e.category, tier = e.tier or 0, key = have[name] })
            end
        end
        if F.potionBest then
            local best = {}
            for _, c in ipairs(cands) do
                if not best[c.cat] or c.tier > best[c.cat].tier then best[c.cat] = c end
            end
            cands = {}
            for _, c in pairs(best) do table.insert(cands, c) end
        end
        local activeTier = {}
        for aname in pairs(active) do
            local ae = entries[aname]
            if ae then
                local t = ae.tier or 0
                if not activeTier[ae.category] or t > activeTier[ae.category] then activeTier[ae.category] = t end
            end
        end
        local sig = getSig("BoostService", "Use")
        if not sig then return end
        for _, c in ipairs(cands) do
            if (active[c.name] or 0) > 0 and not F.potionExtend then

            elseif (activeTier[c.cat] or 0) > c.tier then
                clog("Skipped (higher tier active in category): " .. c.name)
            else
                pcall(function() sig:Fire(c.key) end)
                Stats.potions += 1
                clog("Potion used: " .. c.name)
                task.wait(0.5)
            end
        end
    end)
    Busy.potion = false
end

doInstantSell = function()
    if F.sellThreshold <= 0 then notify("Sell", "Set a threshold first (e.g. 1t).") return 0 end
    local fn = getFn("SellService", "SellInventory")
    if not fn then return 0 end
    local ok, n = pcall(function()
        local s = slots()
        local inSlot, inTower = {}, {}
        for _, d in pairs(s) do if d.unitId then inSlot[d.unitId] = true end end
        pcall(function() for _, k in pairs(G.DC.TowerTeam() or {}) do inTower[k] = true end end)
        local eq = equippedKey()
        local cands = {}
        for key, e in pairs(inventory()) do
            if isUnitEntry(e) and key ~= eq and not inSlot[key] and not inTower[key] then
                if not (e.attributes and e.attributes.locked) then
                    local ch = unitChance(e)
                    if ch > 0 and ch < F.sellThreshold then
                        table.insert(cands, { key = key, chance = ch })
                    end
                end
            end
        end
        table.sort(cands, function(a, b) return a.chance < b.chance end)
        local keys = {}
        for i, c in ipairs(cands) do
            if i > #cands - F.keepBest then break end
            table.insert(keys, c.key)
        end
        if #keys == 0 then return 0 end
        local _, count = fn(keys)
        return tonumber(count) or #keys
    end)
    if ok and n and n > 0 then
        Stats.sold += n
        clog(n .. " units sold.")
        notify("Sell", n .. " units sold.")
        return n
    end
    return 0
end

end
local lastTowerFloor, sendTowerHook, doTowerLoop
do
local function towerRewardsAdd(rewards)
    for name, amt in pairs(rewards or {}) do
        amt = tonumber(amt) or 0
        Stats.towerRewards[name] = (Stats.towerRewards[name] or 0) + amt
        if name == "Gems" then Stats.towerGems = (Stats.towerGems or 0) + amt
        elseif name == "Trait Reroll" then Stats.towerTraits = (Stats.towerTraits or 0) + amt end
    end
end
lastTowerFloor = 1

local towerRunDrops, towerRunFloor0 = {}, 1
local function handleTowerSeq(seq, saw)
    local done = false
    for _, act in ipairs(seq) do
        if type(act) == "table" then
            if act.action == "floorStarted" and tonumber(act.floor) then
                lastTowerFloor = tonumber(act.floor)
                if lastTowerFloor % 10 == 0 then clog("Tower floor " .. lastTowerFloor) end
            elseif act.action == "floorCompleted" and type(act.rewards) == "table" then
                towerRewardsAdd(act.rewards)
                for rn, ra in pairs(act.rewards) do
                    towerRunDrops[rn] = (towerRunDrops[rn] or 0) + (tonumber(ra) or 0)
                end
            elseif act.action == "ended" then
                done = true
                local hasRewards = act.rewards and next(act.rewards)
                if hasRewards then
                    local parts = {}
                    for rn, ra in pairs(act.rewards) do table.insert(parts, ra .. "x " .. rn) end
                    clog("Tower ended: " .. table.concat(parts, ", "))
                end
                if hasRewards and saw then
                    local w = (Stats.towerWins[F.towerName] or 0) + 1
                    Stats.towerWins[F.towerName] = w
                    smartCapOrder = nil
                    clog("Tower WIN counted.")
                    if F.towerHookOn and type(F.towerHookUrl) == "string" and F.towerHookUrl ~= "" then
                        local u, nm, f0, fN, dr, bo = F.towerHookUrl, F.towerName, towerRunFloor0, lastTowerFloor, towerRunDrops, act.rewards
                        task.spawn(function() sendTowerHook(u, nm, f0, fN, dr, bo, "Cleared") end)
                    end
                elseif not hasRewards then
                    clog("Tower wiped at floor " .. lastTowerFloor .. " (not counted).")
                    pcall(function()
                        local t = G.TowersMod.Get(F.towerName)
                        if t and t.order then smartCapOrder = t.order - 1 smartCapUntil = os.clock() + 300 end
                    end)
                else
                    clog("Leftover rewards collected (not counted).")
                end
                break
            end
        end
    end
    return done
end

local function towerExitRestart()
    local at = math.floor(tonumber(F.towerExitFloor) or 0)
    if not F.towerExitOn or at <= 0 or lastTowerFloor < at then return false end
    pcall(function() local c = getFn("Towers", "CancelTower") if c then c() end end)
    clog("Tower exit floor reached (" .. lastTowerFloor .. "), restarting " .. tostring(F.towerName) .. ".")
    if F.towerHookOn and type(F.towerHookUrl) == "string" and F.towerHookUrl ~= "" then
        local u, nm, f0, fN, dr = F.towerHookUrl, F.towerName, towerRunFloor0, lastTowerFloor, towerRunDrops
        task.spawn(function() sendTowerHook(u, nm, f0, fN, dr, nil, "Exited") end)
    end
    lastTowerFloor = 1
    return true
end

local function driveTower(step)
    local done, fails = false, 0
    while F.tower and Alive and not done do
        local ok, seq = pcall(step)
        if ok and type(seq) == "table" then
            if #seq > 0 then
                fails = 0
                Stats.towerFloors += 1
                local saw = false
                for _, act in ipairs(seq) do
                    if type(act) == "table" and act.action ~= "ended" then saw = true break end
                end
                done = handleTowerSeq(seq, saw)
                if not done and towerExitRestart() then done = true end
            else
                task.wait(0.25)
            end
        else
            fails += 1
            if fails >= 8 then done = true clog("Tower step failed 8 times, restarting loop.") end
            task.wait(1)
        end
    end
end
local smartCapOrder, smartCapUntil = nil, 0

local function towerMults()
    local dmg, hp = 1, 1
    pcall(function()
        if G.Upgrades then
            local owned = {}
            pcall(function() owned = G.DC.Upgrades() or {} end)
            local du, hu = 0, 0
            for name in pairs(owned) do
                local u = G.Upgrades[name]
                if type(u) == "table" and type(u.buffs) == "table" then
                    for bn, b in pairs(u.buffs) do
                        local amt = tonumber(type(b) == "table" and b.amount or b) or 0
                        local l = tostring(bn):lower()
                        if l:find("damage") then du += amt
                        elseif l:find("health") then hu += amt end
                    end
                end
            end
            dmg *= (1 + du)
            hp *= (1 + hu)
        end
    end)
    pcall(function()
        if G.BoostConfig and G.BoostConfig.entries then
            local active = activePotions()
            local bestD, bestH = {}, {}
            for aname in pairs(active) do
                local e = G.BoostConfig.entries[aname]
                if e and type(e.buffs) == "table" then
                    local cat = tostring(e.category or "?")
                    for bn, b in pairs(e.buffs) do
                        local amt = tonumber(type(b) == "table" and b.amount or b) or 0
                        if amt > 0 then
                            local l = tostring(bn):lower()
                            if l:find("damage") then bestD[cat] = math.max(bestD[cat] or 0, amt)
                            elseif l:find("health") then bestH[cat] = math.max(bestH[cat] or 0, amt) end
                        end
                    end
                end
            end
            for _, a in pairs(bestD) do dmg *= a end
            for _, a in pairs(bestH) do hp *= a end
        end
    end)
    return dmg, hp
end
local function towerTeamMembers(dmgM, hpM)
    local ms = {}
    local ok, team = pcall(function() return G.DC.TowerTeam() end)
    if not (ok and type(team) == "table") then return ms end
    for _, key in pairs(team) do
        local e = invEntry(key)
        if e and e.attributes then
            local okc, cfg = pcall(function() return G.EntryRegistry.getEntryConfig(e.name) end)
            if okc and cfg then
                local ch, cd = 0, 0
                pcall(function() ch = cfg.health(e.attributes) end)
                pcall(function() cd = cfg.damage(e.attributes) end)
                ch, cd = tonumber(ch) or 0, tonumber(cd) or 0
                if ch > 0 and cd > 0 then table.insert(ms, { h = ch * (hpM or 1), d = cd * (dmgM or 1) }) end
            end
        end
    end
    return ms
end

local function simTower(ref, members)
    local maxF = 100
    pcall(function() maxF = ref.maxFloors or 100 end)
    local tiers = {}
    pcall(function()
        for _, t in ipairs(ref.drops or {}) do
            if tonumber(t.minFloor) then table.insert(tiers, tonumber(t.minFloor)) end
        end
    end)
    table.sort(tiers)
    local order = 0
    pcall(function() order = ref.order or 0 end)
    local hp = {}
    for i, m in ipairs(members) do hp[i] = m.h end
    local reach, score = 0, 0
    for f = 1, maxF do
        local eh, ed = 0, 0
        pcall(function() eh = ref.enemyHealth(f) end)
        pcall(function() ed = ref.enemyDamage(f) end)
        eh, ed = tonumber(eh) or math.huge, tonumber(ed) or math.huge
        local mi = 1
        while mi <= #members and eh > 0 do
            if hp[mi] <= 0 then mi += 1 continue end
            while eh > 0 and hp[mi] > 0 do
                eh -= members[mi].d
                if eh > 0 then hp[mi] -= ed end
            end
            if hp[mi] <= 0 then mi += 1 end
        end
        if eh > 0 then break end
        reach = f
        local ti = 0
        for _, mf in ipairs(tiers) do if f >= mf then ti += 1 end end
        score += order * 100 + ti * 10
    end
    return reach, score
end
local function smartTowerPick()
    if not G.TowersMod then return F.towerName, nil end
    local dmgM, hpM = towerMults()
    local members = towerTeamMembers(dmgM, hpM)
    if #members == 0 then return F.towerName, nil end
    local cands = {}
    pcall(function()
        for name in pairs(G.TowersMod.GetAll()) do
            if name ~= "Infinity Tower" then
                local t = G.TowersMod.Get(name)
                if t and t.order then table.insert(cands, { name = name, ref = t }) end
            end
        end
    end)
    if #cands == 0 then return F.towerName, nil end
    local cap = (smartCapOrder and os.clock() < smartCapUntil) and smartCapOrder or nil
    local best, bestScore, bestReach, bestOrd = nil, -1, 0, -1
    local detail = {}
    for _, c in ipairs(cands) do
        local ord = 99
        pcall(function() ord = c.ref.order or 99 end)
        if cap and ord > cap then
            table.insert(detail, c.name .. "=capped")
        else
            local reach, score = simTower(c.ref, members)
            if (Stats.towerWins[c.name] or 0) > 0 then

                local maxF = 100
                pcall(function() maxF = c.ref.maxFloors or 100 end)
                if reach < maxF then
                    reach = maxF
                    local ti = 0
                    pcall(function()
                        for _, t in ipairs(c.ref.drops or {}) do
                            if tonumber(t.minFloor) and tonumber(t.minFloor) <= maxF then ti += 1 end
                        end
                    end)
                    score = ord * 100 * maxF + ti * 10
                end
            end
            table.insert(detail, c.name .. " f" .. tostring(reach))
            if score > bestScore or (score == bestScore and ord > bestOrd) then
                best, bestScore, bestReach, bestOrd = c.name, score, reach, ord
            end
        end
    end
    table.sort(detail)
    table.insert(detail, 1, "buffs " .. fmt(dmgM) .. "dmg/" .. fmt(hpM) .. "hp")
    local info = best and { reach = bestReach, score = bestScore, detail = table.concat(detail, ", ") } or nil
    return best or F.towerName, info
end
local function syncTowerDropdown()
    pcall(function()
        for lbl, n in pairs(towerByLabel) do
            if n == F.towerName and U.towerSel then U.towerSel:Set(lbl, true) break end
        end
    end)
end
instantSmartCheck = function()
    if not F.smartTower then return end
    local pick, info = smartTowerPick()
    if pick and pick ~= F.towerName then
        F.towerName = pick
        clog("Smart tower: " .. pick .. (info and (" (f~" .. info.reach .. (info.detail and (" [" .. info.detail .. "]") or "")) .. ")" or ""))
    elseif pick then
        clog("Smart tower checked: " .. pick .. (info and (" (f~" .. info.reach .. (info.detail and (" [" .. info.detail .. "]") or "")) .. ")" or "") .. " - already best")
    else
        clog("Smart tower: no team found, keeping " .. tostring(F.towerName))
    end
    syncTowerDropdown()
end
function doTowerLoop()
    if Busy.tower then return end
    Busy.tower = true
    local play = getFn("Towers", "PlayTower")
    local step = getFn("Towers", "CompleteTowerFloor")
    if not play or not step then clog("Tower remote missing.") Busy.tower = false return end
    while F.tower and Alive do
        if F.towerEquipBest then
            local eb = getSig("Towers", "EquipBestTowerTeam")
            if eb then pcall(function() eb:Fire() end) end
            task.wait(0.5)
        end
        if F.smartTower then
            local pick, info = smartTowerPick()
            if pick and pick ~= F.towerName then
                F.towerName = pick
                clog("Smart tower: " .. pick .. (info and (" (f~" .. info.reach .. (info.detail and (" [" .. info.detail .. "]") or "")) .. ")" or ""))
            elseif pick then
                clog("Smart tower checked: " .. pick .. (info and (" (f~" .. info.reach .. (info.detail and (" [" .. info.detail .. "]") or "")) .. ")" or "") .. " - already best")
            else
                clog("Smart tower: no team found, keeping " .. tostring(F.towerName))
            end
            syncTowerDropdown()
        end
        local okStart, started = pcall(play, F.towerName)
        if okStart and started then
            clog("Tower started: " .. F.towerName)
            lastTowerFloor = 1
            towerRunDrops, towerRunFloor0 = {}, 1
            driveTower(step)
        else
            local okP, seq = pcall(step)
            if okP and type(seq) == "table" and #seq > 0 then
                clog("Found an active tower run, continuing it...")
                towerRunDrops = {}
                Stats.towerFloors += 1
                local sawP = false
                for _, act in ipairs(seq) do
                    if type(act) == "table" and act.action ~= "ended" then sawP = true break end
                end
                local runDone = handleTowerSeq(seq, sawP)
                if not runDone and towerExitRestart() then runDone = true end
                if not runDone then driveTower(step) end
            else
                clog("Tower failed to start: " .. F.towerName .. " (team/cooldown?)")
                task.wait(5)
            end
        end
    end
    pcall(function() local c = getFn("Towers", "CancelTower") if c then c() end end)
    Busy.tower = false
end

end

local doGradeTick, doTraitTick
do
local function gameSkipProtected(listName, key)
    if not key or not G.DC then return false end
    local ok, v = pcall(function()
        local ob = G.DC[listName][key]
        if type(ob) == "function" or type(ob) == "table" then return ob() end
        return ob
    end)
    return (ok and v) and true or false
end
local gradeSkipLogged = {}
local function targetAbove(mod, cur, set)
    if not mod then return false end
    local co = 0
    if cur and mod[cur] and mod[cur].order then co = mod[cur].order end
    for n in pairs(set) do
        local e = mod[n]
        if e and e.order and e.order > co then return true end
    end
    return false
end
function doGradeTick(manual)
    if Busy.grade then return end
    if #F.gradeTargets == 0 then
        if manual then notify("Grade", "Select target grades first.") end
        if os.clock() - (gradeSkipLogged._noTargetT or 0) > 60 then
            gradeSkipLogged._noTargetT = os.clock()
            clog("Grade: no target grades selected.")
        end
        return
    end
    if not G.GradesMod then
        if os.clock() - (gradeSkipLogged._noModT or 0) > 60 then
            gradeSkipLogged._noModT = os.clock()
            clog("Grade: Grades module not loaded.")
        end
        return
    end

    do
        local inv = inventory()
        local placed = placedUnitKeys()
        local pruned = false
        for i = #F.gradeUnits, 1, -1 do
            local k = F.gradeUnits[i]
            local e = inv[k]
            if not ((e and isUnitEntry(e)) or placed[k]) then
                table.remove(F.gradeUnits, i)
                pruned = true
            end
        end
        if pruned then
            clog("Grade: dropped missing copies from selection.")
            pcall(function() refreshUnitDrop(U.gradeUnits, gradeUnitByLabel, F.gradeUnits, "grade") end)
        end
    end
    if not F.gradeAll and not F.gradePlacedOnly and #F.gradeUnits == 0 then
        if os.clock() - (gradeSkipLogged._hintT or 0) > 60 then
            gradeSkipLogged._hintT = os.clock()
            clog("Grade: no units selected - pick Grade Units or enable All Units.")
        end
        return
    end
    Busy.grade = true
    local rolled = false
    pcall(function()
        if currencyAmount("Gems") <= F.gemReserve then
            if os.clock() - (gradeSkipLogged._gemT or 0) > 60 then
                gradeSkipLogged._gemT = os.clock()
                clog("Grade: waiting for Gems (reserve " .. tostring(F.gemReserve) .. ").")
            end
            return
        end
        local sig = getSig("GradeService", "Roll")
        if not sig then
            if os.clock() - (gradeSkipLogged._sigT or 0) > 60 then
                gradeSkipLogged._sigT = os.clock()
                clog("Grade: Roll remote missing.")
            end
            return
        end
        local targets = {}
        for _, n in ipairs(F.gradeTargets) do targets[n] = true end
        local sel = {}
        if not F.gradeAll then for _, k in ipairs(F.gradeUnits) do sel[k] = true end end
        local placed = F.gradePlacedOnly and placedUnitKeys() or nil

        for key, e in pairs(inventory()) do
            if isUnitEntry(e) and (not placed or placed[key]) then
                if F.gradeAll or F.gradePlacedOnly or sel[key] then
                    local g = e.attributes and e.attributes.grade
                    if not g or not targets[g] then
                        local gd = g and G.GradesMod[g]
                        if gd and gd.protected then
                            if targetAbove(G.GradesMod, g, targets) then
                                pcall(function() sig:Fire(key, true) end)
                                rolled = true
                                clog("Grade FORCE-rolled past protected: " .. tostring(e.name) .. " (" .. tostring(g) .. ")")
                                return
                            end
                            local lk = key .. "|" .. tostring(g)
                            if not gradeSkipLogged[lk] then
                                gradeSkipLogged[lk] = true
                                clog("Kept protected grade (not rolled): " .. tostring(e.name) .. " (" .. tostring(g) .. ")")
                            end
                        else
                            if g and gameSkipProtected("ProtectedGrades", g) then
                                pcall(function() sig:Fire(key, true) end)
                                rolled = true
                                clog("Grade skip-confirmed (game skip list): " .. tostring(e.name) .. " (" .. tostring(g) .. ")")
                                return
                            end
                            pcall(function() sig:Fire(key) end)
                            rolled = true
                            clog("Grade rolled: " .. tostring(e.name) .. " (" .. tostring(g) .. ")")
                            return
                        end
                    end
                end
            end
            if not Alive then return end
        end
        if not rolled and os.clock() - (gradeSkipLogged._doneT or 0) > 60 then
            gradeSkipLogged._doneT = os.clock()
            clog("Grade: all selected units already at target grade.")
        end
    end)
    if rolled then pcall(function() refreshUnitDrop(U.gradeUnits, gradeUnitByLabel, F.gradeUnits, "grade") end) end
    Busy.grade = false
end
local traitSkipLogged = {}
function doTraitTick(manual)
    if Busy.trait then return end
    if #F.traitTargets == 0 then
        if manual then notify("Trait", "Select target traits first.") end
        if os.clock() - (traitSkipLogged._noTargetT or 0) > 60 then
            traitSkipLogged._noTargetT = os.clock()
            clog("Trait: no target traits selected.")
        end
        return
    end
    if not G.TraitsMod then
        if os.clock() - (traitSkipLogged._noModT or 0) > 60 then
            traitSkipLogged._noModT = os.clock()
            clog("Trait: Traits module not loaded.")
        end
        return
    end

    do
        local inv = inventory()
        local placed = placedUnitKeys()
        local pruned = false
        for i = #F.traitUnits, 1, -1 do
            local k = F.traitUnits[i]
            local e = inv[k]
            if not ((e and isUnitEntry(e)) or placed[k]) then
                table.remove(F.traitUnits, i)
                pruned = true
            end
        end
        if pruned then
            clog("Trait: dropped missing copies from selection.")
            pcall(function() refreshUnitDrop(U.traitUnits, traitUnitByLabel, F.traitUnits, "trait") end)
        end
    end
    if not F.traitAll and not F.traitPlacedOnly and #F.traitUnits == 0 then
        if os.clock() - (traitSkipLogged._hintT or 0) > 60 then
            traitSkipLogged._hintT = os.clock()
            clog("Trait: no units selected - pick Trait Units or enable All Units.")
        end
        return
    end
    Busy.trait = true
    local rolled = false
    pcall(function()
        if currencyAmount("Trait Reroll") <= F.rerollReserve then
            if os.clock() - (traitSkipLogged._gemT or 0) > 60 then
                traitSkipLogged._gemT = os.clock()
                clog("Trait: waiting for Trait Reroll (reserve " .. tostring(F.rerollReserve) .. ").")
            end
            return
        end
        local sig = getSig("TraitService", "Roll")
        if not sig then
            if os.clock() - (traitSkipLogged._sigT or 0) > 60 then
                traitSkipLogged._sigT = os.clock()
                clog("Trait: Roll remote missing.")
            end
            return
        end
        local targets = {}
        for _, n in ipairs(F.traitTargets) do targets[n] = true end
        local sel = {}
        if not F.traitAll then for _, k in ipairs(F.traitUnits) do sel[k] = true end end
        local placed = F.traitPlacedOnly and placedUnitKeys() or nil

        for key, e in pairs(inventory()) do
            if isUnitEntry(e) and (not placed or placed[key]) then
                if F.traitAll or F.traitPlacedOnly or sel[key] then
                    local t = e.attributes and e.attributes.trait
                    if not t or not targets[t] then
                        local td = t and G.TraitsMod[t]
                        if td and td.protected then
                            if targetAbove(G.TraitsMod, t, targets) then
                                pcall(function() sig:Fire(key, true) end)
                                rolled = true
                                clog("Trait FORCE-rolled past protected: " .. tostring(e.name) .. " (" .. tostring(t) .. ")")
                                return
                            end
                            local lk = key .. "|" .. tostring(t)
                            if not traitSkipLogged[lk] then
                                traitSkipLogged[lk] = true
                                clog("Kept protected trait (not rolled): " .. tostring(e.name) .. " (" .. tostring(t) .. ")")
                            end
                        else
                            if t and gameSkipProtected("ProtectedTraits", t) then
                                pcall(function() sig:Fire(key, true) end)
                                rolled = true
                                clog("Trait skip-confirmed (game skip list): " .. tostring(e.name) .. " (" .. tostring(t) .. ")")
                                return
                            end
                            pcall(function() sig:Fire(key) end)
                            rolled = true
                            clog("Trait rolled: " .. tostring(e.name) .. " (" .. tostring(t) .. ")")
                            return
                        end
                    end
                end
            end
            if not Alive then return end
        end
        if not rolled and os.clock() - (traitSkipLogged._doneT or 0) > 60 then
            traitSkipLogged._doneT = os.clock()
            clog("Trait: all selected units already at target trait.")
        end
    end)
    if rolled then pcall(function() refreshUnitDrop(U.traitUnits, traitUnitByLabel, F.traitUnits, "trait") end) end
    Busy.trait = false
end

end
local tradeDriving, tradeScreenOpen, driveTrade, doTradeLoop
do
local DEFAULT_CODES = { "RELEASE", "UPDATE1", "UPDATE2", "UPDATE3", "UPDATE4", "1KCCU", "5KCCU", "10KCCU", "20KCCU", "30KCCU", "40KCCU", "100KLIKES" }
doRedeemCodes = function(manual)
    local sig = getSig("MonetizationService", "RedeemCode")
    if not sig then if manual then notify("Codes", "Redeem remote missing.") end return end
    local redeemed = {}
    pcall(function()
        local r = G.DC.RedeemedCodes()
        if type(r) == "table" then
            for k, v in pairs(r) do
                if v == true then redeemed[k] = true else redeemed[v] = true end
            end
        end
    end)
    local seen, queue = {}, {}

    local detected = {}
    pcall(function()
        local cfg = G.MonetConfig and G.MonetConfig.Codes
        if type(cfg) == "table" then
            for code in pairs(cfg) do
                if type(code) == "string" and code ~= "" then table.insert(detected, code) end
            end
        end
    end)
    table.sort(detected)
    for _, c in ipairs(detected) do
        if not seen[c] and not redeemed[c] then seen[c] = true table.insert(queue, c) end
    end
    for _, c in ipairs(DEFAULT_CODES) do
        if c ~= "" and not seen[c] and not redeemed[c] then seen[c] = true table.insert(queue, c) end
    end
    if #queue == 0 then if manual then notify("Codes", "All codes already redeemed.") end return end
    local okCount = 0
    for _, code in ipairs(queue) do
        if not Alive then break end
        pcall(function() sig:Fire(code) end)
        task.wait(0.6)
        local got = false
        pcall(function()
            local r = G.DC.RedeemedCodes()
            if type(r) == "table" then got = r[code] == true end
        end)
        if got then okCount += 1 clog("Code redeemed: " .. code) end
    end
    notify("Codes", "Done: " .. okCount .. "/" .. #queue .. " new redeemed.")
end

doClaimQuests = function()
    local sig = getSig("QuestService", "Claim")
    if not sig or not G.QuestConfig then return end
    local now = 0
    pcall(function() now = workspace:GetServerTimeNow() end)
    for _, period in ipairs({ "Daily", "Weekly" }) do
        local ok, q = pcall(function() return G.DC.Quests[period]() end)
        if ok and q and type(q) == "table" then
            local exp = tonumber(q.expiresAt) or 0
            if exp == 0 or exp > math.floor(now) then
                local defs = {}
                pcall(function() defs = G.QuestConfig.Periods[period].quests end)
                local prog = q.progress or {}
                local claimed = q.claimed or {}
                for _, def in ipairs(defs or {}) do
                    if def.id and not claimed[def.id] and (tonumber(prog[def.id]) or 0) >= (tonumber(def.target) or math.huge) then
                        pcall(function() sig:Fire(period, def.id, exp) end)
                        clog("Quest claimed: " .. period .. " " .. def.id)
                        task.wait(0.5)
                    end
                    if not Alive then break end
                end
            end
        end
        if not Alive then break end
    end
end

local tradeEvt = { name = "", time = 0, data = nil }
local lastTradeOffers = { own = nil, other = nil }
local inTradeSession = false
local tradeSessionPartner = nil
local tradeCounted = false
local sendTradeHook
local tradeEvtConnected = false
local function tradeEnsureListener()
    if tradeEvtConnected then return end
    local s = getSig("TradeService", "TradeEvent")
    if not s then return end
    local ok = pcall(function()
        tradeListenerConn = s:Connect(function(ev, a)
            tradeEvt = { name = tostring(ev), time = os.clock(), data = a }
            local en = tostring(ev)
            if type(a) == "table" and a.partner ~= nil then
                pcall(function()
                    local p = a.partner
                    tradeSessionPartner = p.DisplayName or p.Name or tostring(p)
                end)
            end

            if en == "Started" then
                inTradeSession = true
                if not tradeCounted then
                    tradeCounted = true
                    Stats.tradesOpened += 1
                    lastTradeOffers = { own = nil, other = nil }
                    notify("Trade", tostring(tradeSessionPartner or "?") .. " - trade opened.")
                    clog("Trade OPEN with " .. tostring(tradeSessionPartner or "?") .. ".")
                    if F.tradeChatOn then task.spawn(sendTradeChat) end
                end
            elseif en == "Ended" then
                inTradeSession = false
                local reason = "Ended"
                pcall(function()
                    if type(a) == "table" and a.reason ~= nil then reason = tostring(a.reason)
                    elseif a ~= nil then reason = tostring(a) end
                end)
                if tradeCounted then
                    tradeCounted = false
                    if reason == "Completed" then
                        clog("Trade COMPLETED with " .. tostring(tradeSessionPartner or "?") .. ".")
                        if F.tradeHookOn and type(F.tradeHookUrl) == "string" and F.tradeHookUrl ~= "" then
                            local u, o1, o2, pn = F.tradeHookUrl, lastTradeOffers.own, lastTradeOffers.other, tostring(tradeSessionPartner or "?")
                            task.spawn(function() sendTradeHook(u, pn, o1, o2, "Completed") end)
                        end
                    else
                        clog("Trade ended (" .. reason .. ") with " .. tostring(tradeSessionPartner or "?") .. ".")
                    end
                end
            elseif en == "RequestExpired" or en == "RequestClosed" then
                inTradeSession = false
            end
            pcall(function()
                if type(a) == "table" then
                    if a.otherOffer ~= nil then lastTradeOffers.other = a.otherOffer end
                    if a.ownOffer ~= nil then lastTradeOffers.own = a.ownOffer end
                end
            end)
        end)
    end)
    if ok then tradeEvtConnected = true end
end
local function otherMoney(p)
    local ls = p:FindFirstChild("leaderstats")
    local m = ls and ls:FindFirstChild("Money")
    if not (m and typeof(m.Value) == "string") then return 0 end
    return parseCompact(m.Value) or 0
end
local function otherRolls(p)
    local ls = p:FindFirstChild("leaderstats")
    local r = ls and ls:FindFirstChild("Rolls")
    if r then return tonumber(r.Value) or 0 end
    return 0
end
local function tradeTargets()
    local list = {}
    if F.tradeMoney <= 0 then return list end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local mv = otherMoney(p)
            if mv >= F.tradeMoney and otherRolls(p) >= 1000 then table.insert(list, { p = p, money = mv }) end
        end
    end
    table.sort(list, function(a, b) return a.money > b.money end)
    return list
end
local function waitTradeEvent(names, timeout)
    local t0 = os.clock()
    while os.clock() - t0 < timeout do
        if not F.tradeAuto or not Alive then return nil end
        if tradeEvt.time > t0 and names[tradeEvt.name] then return tradeEvt.name end
        task.wait(0.25)
    end
    return nil
end
local function countOffer(off)
    if type(off) ~= "table" then return 0 end
    local n = 0
    for _ in pairs(off) do n += 1 end
    return n
end
tradeDriving = false
function tradeScreenOpen()
    if inTradeSession then return true end
    local ok, v = pcall(function() return G.UIRefs.Root.Trading.TradeScreen.Visible end)
    return ok and v and true or false
end
function driveTrade()
    if tradeDriving then return end
    local adv = getSig("TradeService", "AdvanceTrade")
    if not adv then return end
    tradeDriving = true
    local readyTries, accTries = 0, 0
    local t0 = os.clock()
    while F.tradeAutoGo and Alive and tradeScreenOpen() and os.clock() - t0 < 45 do
        local d = tradeEvt.data
        if type(d) == "table" then
            local need = (not F.tradeNeedOffer) or (tonumber(F.tradeMinItems) or 1) <= 0 or countOffer(d.otherOffer) >= math.max(1, tonumber(F.tradeMinItems) or 1)
            if d.phase == "Offer" then
                local meReady = d.ownReady and true or false
                if meReady then readyTries = 0 end
                if need and not meReady and readyTries < 3 then
                    readyTries += 1
                    pcall(function() adv:Fire() end)
                    clog("Trade: auto-ready")
                    task.wait(1)
                end
            elseif d.phase == "Confirm" then
                local meAcc = d.ownAccepted and true or false
                if meAcc then accTries = 0 end
                if need and not meAcc and accTries < 3 then
                    accTries += 1
                    pcall(function() adv:Fire() end)
                    clog("Trade: auto-accept")
                    task.wait(2)
                end
            end
        end
        task.wait(0.5)
    end
    tradeDriving = false
    if F.tradeAutoGo and Alive and tradeScreenOpen() and os.clock() - t0 >= 45 then
        local c = getSig("TradeService", "CancelTrade")
        if c then pcall(function() c:Fire() end) end
        clog("Trade: timed out, cancelled.")
    end
end
local tradeActive = false
local lastTradeEnd = 0
local function fmtOffer(off)
    if type(off) ~= "table" then return "(empty)" end
    local parts = {}
    for k, v in pairs(off) do
        local name, extra = tostring(k), ""
        pcall(function()
            local e = invEntry(k) or (type(v) == "string" and invEntry(v))
            if e and type(e) == "table" and e.name then
                name = tostring(e.name)
                local ch = unitChance(e)
                if ch > 0 then
                    extra = " [1 in " .. fmt(ch) .. "]"
                elseif tonumber(e.amount) then
                    extra = " x" .. tostring(e.amount)
                end
            elseif type(v) == "table" then
                if v.name then name = tostring(v.name) end
                if tonumber(v.amount) then extra = " x" .. tostring(v.amount) end
            elseif type(v) ~= "boolean" and tostring(v) ~= "" then
                extra = " x" .. tostring(v)
            end
        end)
        table.insert(parts, name .. extra)
    end
    if #parts == 0 then return "(empty)" end
    table.sort(parts)
    local s = table.concat(parts, ", ")
    if #s > 900 then s = s:sub(1, 900) .. "..." end
    return s
end
sendTradeHook = function(url, partner, ownOff, otherOff, result)
    local emb = {
        title = "Trade " .. tostring(result or "Completed") .. " - " .. tostring(partner),
        fields = {
            { name = "You Gave", value = fmtOffer(ownOff), inline = false },
            { name = "You Got", value = fmtOffer(otherOff), inline = false },
        },
        color = 0x60A5FA,
        footer = { text = LocalPlayer.DisplayName },
        timestamp = hookStamp(),
    }
    return postWebhook(url, { username = "Anime Dice - Perfectus", embeds = { emb } })
end
sendTowerHook = function(url, towerName, floor0, floorN, drops, bonus, result)
    local cleared = (result ~= "Exited")
    local kindOf = {}
    local function kind(name)
        if kindOf[name] == nil then
            local isPot = false
            pcall(function()
                local cfg = G.EntryRegistry.getEntryConfig(name)
                isPot = cfg and cfg.kind == "Boost"
            end)
            kindOf[name] = isPot and "pot" or "item"
        end
        return kindOf[name]
    end
    local function lines(rewards)
        local pots, items = {}, {}
        for name, amt in pairs(rewards or {}) do
            table.insert(kind(name) == "pot" and pots or items, (tonumber(amt) or 0) .. "x " .. tostring(name))
        end
        table.sort(pots)
        table.sort(items)
        local parts = {}
        for _, l in ipairs(pots) do table.insert(parts, l) end
        if #pots > 0 and #items > 0 then table.insert(parts, "· Items ·") end
        for _, l in ipairs(items) do table.insert(parts, l) end
        if #parts == 0 then return "-" end
        local s = table.concat(parts, "\n")
        if #s > 900 then s = s:sub(1, 900) .. "..." end
        return s
    end
    local sel = F.towerHookFields
    local function want(name)
        if type(sel) ~= "table" or #sel == 0 then return true end
        for _, s in ipairs(sel) do if s == name then return true end end
        return false
    end
    local fields = {}
    if want("Floors") then table.insert(fields, { name = "Floors", value = tostring(floor0 or 1) .. " → " .. tostring(floorN or "?"), inline = true }) end
    if want("Wins") then table.insert(fields, { name = "Session Wins", value = tostring(Stats.towerWins[towerName] or 0), inline = true }) end
    if cleared then
        if want("Floor Drops") then table.insert(fields, { name = "Floor Drops", value = lines(drops), inline = false }) end
        if want("Clear Bonus") then table.insert(fields, { name = "Clear Bonus", value = lines(bonus), inline = false }) end
    else
        if want("Floor Drops") then table.insert(fields, { name = "Run Drops", value = lines(drops), inline = false }) end
    end
    local emb = {
        title = (cleared and "Tower Cleared - " or "Tower Exited - ") .. tostring(towerName),
        fields = fields,
        color = 0xA78BFA,
        footer = { text = LocalPlayer.DisplayName },
        timestamp = hookStamp(),
    }
    pcall(function()
        local t = G.TowersMod.Get(towerName)
        if t and t.image then
            local th = thumbOf(t.image)
            if th then emb.thumbnail = { url = th } end
        end
    end)
    local embeds = { emb }

    if want("Item Images") then
    local totals = {}
    for name, amt in pairs(drops or {}) do totals[name] = (totals[name] or 0) + (tonumber(amt) or 0) end
    for name, amt in pairs(bonus or {}) do totals[name] = (totals[name] or 0) + (tonumber(amt) or 0) end
    local order = {}
    for name in pairs(totals) do table.insert(order, name) end
    table.sort(order, function(a, b) return (totals[a] or 0) > (totals[b] or 0) end)
    for _, name in ipairs(order) do
        if #embeds >= 10 then break end
        local cfg = nil
        pcall(function() cfg = G.EntryRegistry.getEntryConfig(name) end)
        if cfg and cfg.image then
            local th = thumbOf(cfg.image)
            if th then
                table.insert(embeds, {
                    title = tostring(totals[name] or 0) .. "x " .. tostring(name),
                    thumbnail = { url = th },
                    color = (kind(name) == "pot") and hookColorInt(cfg) or 0x808080,
                })
            end
        end
    end
    end
    return postWebhook(url, { username = "Anime Dice - Perfectus", embeds = embeds })
end
sendTradeChat = function()
    local raw = tostring(F.tradeChatMsg or "")
    if raw:gsub("%s", "") == "" then return end
    local ch = nil
    pcall(function()
        ch = game:GetService("TextChatService").TextChannels.RBXGeneral
    end)
    if not ch then clog("Trade chat: channel missing.") return end
    for part in raw:gmatch("[^,]+") do
        if not Alive then return end
        local msg = part:gsub("^%s+", ""):gsub("%s+$", "")
        if msg ~= "" then
            local ok, err = pcall(function() ch:SendAsync(msg) end)
            if ok then clog("Trade chat: " .. msg) else clog("Trade chat failed: " .. tostring(err)) end
            task.wait(2)
        end
    end
end
local function tradePlayer(plr)
    local req = getSig("TradeService", "RequestTrade")
    if not req then return false end
    local tries = math.max(1, tonumber(F.tradeRetries) or 3)
    for a = 1, tries do
        if not F.tradeAuto or not Alive then return false end
        if not plr.Parent then return false end
        if tradeScreenOpen() then
            clog("Trade: already in a trade, not requesting " .. plr.DisplayName .. ".")
            return false
        end
        tradeEvt = { name = "", time = 0, data = nil }
        pcall(function() req:Fire(plr) end)
        Stats.tradesSent += 1
        clog("Trade request: " .. plr.DisplayName .. " (" .. a .. "/" .. tries .. ")")
        local ev = waitTradeEvent({ Started = true, RequestExpired = true, RequestClosed = true, Ended = true }, 8)
        if ev == "Started" then

            tradeActive = true
            tradeEvt.data = nil
            local endEv = waitTradeEvent({ Ended = true }, 45)
            if endEv == nil and F.tradeAuto and Alive then
                local c = getSig("TradeService", "CancelTrade")
                if c then pcall(function() c:Fire() end) end
                clog("Trade timed out (45s), cancelled: " .. plr.DisplayName .. ".")
                waitTradeEvent({ Ended = true }, 5)
            end
            lastTradeEnd = os.clock()
            tradeActive = false
            return true
        end
        task.wait(1)
    end
    clog("Trade: no answer from " .. plr.DisplayName)
    return false
end
local tradeTried = {}
local tradeEmptySince = 0
local tradeNoMinWarned = false
function doTradeLoop()
    if Busy.trade then return end
    Busy.trade = true
    tradeActive = false
    pcall(function()
        local en = getSig("TradeService", "SetTradeRequestsEnabled")
        if en then en:Fire(true) end
    end)
    tradeEnsureListener()
    if AUTOEXEC_CODE:find("PASTE_YOUR") then clog("Trade: set AUTOEXEC_CODE or hopping strands you.") end
    while F.tradeAuto and Alive do
        if (tonumber(F.tradeMoney) or 0) <= 0 then
            if not tradeNoMinWarned then
                tradeNoMinWarned = true
                clog("Trade: set Min Money first (idle, no hopping).")
                notify("Trade", "Set Min Money first.")
            end
            task.wait(5)
            continue
        end
        tradeNoMinWarned = false
        local cands = {}
        for _, c in ipairs(tradeTargets()) do
            if not tradeTried[c.p.UserId] then table.insert(cands, c) end
        end
        if #cands == 0 then
            if tradeEmptySince == 0 then tradeEmptySince = os.clock() end
            local hopDelay = math.clamp(tonumber(F.tradeHopDelay) or 8, 1, 30)
            if F.tradeHop and not tradeActive and not tradeScreenOpen() and (os.clock() - lastTradeEnd > hopDelay) and (os.clock() - tradeEmptySince >= hopDelay) then
                clog("Trade: nobody matches, hopping...")
                tradeTried = {}
                tradeEmptySince = 0
                doHop(false, function() return (not F.tradeAuto) or tradeScreenOpen() end)
                local t = 0
                while F.tradeAuto and Alive and t < 12 do task.wait(1) t += 1 end
            else
                task.wait(3)
            end
        else
            tradeEmptySince = 0
            if tradeScreenOpen() then
                task.wait(3)
            else
                local c = cands[1]
                tradePlayer(c.p)
                tradeTried[c.p.UserId] = true
                task.wait(1)
            end
        end
    end
    Busy.trade = false
end

end

do
local function applyLoaded(data)
    if type(data) ~= "table" then return end
    loadingCfg = true
    local sF = data.F
    if type(sF) == "table" then
        for k, v in pairs(sF) do
            local cur = F[k]
            if cur ~= nil and type(v) == type(cur) then
                if type(v) == "table" then
                    local clean, okArr = {}, true
                    for _, e in ipairs(v) do
                        if type(e) ~= "string" then okArr = false break end
                        table.insert(clean, e)
                    end
                    if okArr then F[k] = clean end
                else
                    F[k] = v
                end
            end
        end
    end
    local sS = data.S
    if type(sS) == "table" then
        for k, v in pairs(sS) do
            if type(Stats[k]) == "number" and type(v) == "number" then
                Stats[k] = v
            elseif type(Stats[k]) == "table" and type(v) == "table" then
                local clean, okMap = {}, true
                for mk, mv in pairs(v) do
                    if type(mk) ~= "string" or type(mv) ~= "number" then okMap = false break end
                    clean[mk] = mv
                end
                if okMap then Stats[k] = clean end
            end
        end
    end
    if (tonumber(Stats.towerGems) or 0) == 0 and type(Stats.towerRewards) == "table" then
        Stats.towerGems = tonumber(Stats.towerRewards["Gems"]) or 0
    end
    if (tonumber(Stats.towerTraits) or 0) == 0 and type(Stats.towerRewards) == "table" then
        Stats.towerTraits = tonumber(Stats.towerRewards["Trait Reroll"]) or 0
    end
    if U.sellInput then
        local tt = (type(data.thresholdText) == "string") and data.thresholdText or ""
        pcall(function() U.sellInput:Set(tt, true) end)
        F.sellThreshold = parseCompact(tt) or 0
    end
    if U.tradeInput then
        local tx = (type(data.tradeText) == "string") and data.tradeText or ""
        pcall(function() U.tradeInput:Set(tx, true) end)
        F.tradeMoney = parseCompact(tx) or 0
    end
    if U.rollMinT then
        local rx = (type(data.rollMinText) == "string") and data.rollMinText or ""
        pcall(function() U.rollMinT:Set(rx, true) end)
        F.rollHookMin = parseCompact(rx) or 0
    end
    if U.tradeChatMsg then
        local cx = (type(data.chatText) == "string") and data.chatText or ""
        pcall(function() U.tradeChatMsg:Set(cx, true) end)
        F.tradeChatMsg = cx
    end
    for k, h in pairs(U) do
        if h and h.Set and k ~= "sellInput" then
            if k == "towerSel" then
                for lbl, n in pairs(towerByLabel) do
                    if n == F.towerName then pcall(function() h:Set(lbl, true) end) break end
                end
            elseif k == "potions" then
                local back = {}
                for _, n in ipairs(F.potions) do
                    for lbl, m in pairs(potByLabel) do
                        if m == n then table.insert(back, lbl) break end
                    end
                end
                pcall(function() h:Set(back, true) end)
            elseif k == "upgCats" then
                pcall(function() h:Set(F.upgradeCats, true) end)
            elseif k == "statHookFields" or k == "towerHookFields" then
                pcall(function() h:Set(F[k], true) end)
            elseif k == "gradeTargets" then
                local back = {}
                for _, n in ipairs(F.gradeTargets) do for lbl, m in pairs(gradeByLabel) do if m == n then table.insert(back, lbl) break end end end
                pcall(function() h:Set(back, true) end)
            elseif k == "traitTargets" then
                local back = {}
                for _, n in ipairs(F.traitTargets) do for lbl, m in pairs(traitByLabel) do if m == n then table.insert(back, lbl) break end end end
                pcall(function() h:Set(back, true) end)
            elseif k == "gradeUnits" or k == "traitUnits" then
                local map = (k == "gradeUnits") and gradeUnitByLabel or traitUnitByLabel

                local live = {}
                buildUnitOptions(map, (k == "gradeUnits") and "grade" or "trait")
                for lbl, key in pairs(map) do live[key] = lbl end
                local clean, back = {}, {}
                for _, key in ipairs(F[k]) do
                    if live[key] then table.insert(clean, key) table.insert(back, live[key]) end
                end
                F[k] = clean
                pcall(function() h:Set(back, true) end)
            elseif F[k] ~= nil and type(F[k]) ~= "table" then
                pcall(function() h:Set(F[k], true) end)
            end
        end
    end

    if F.gradeAll and F.gradePlacedOnly then
        F.gradeAll = false
        if U.gradeAll then pcall(function() U.gradeAll:Set(false, true) end) end
    end
    if F.traitAll and F.traitPlacedOnly then
        F.traitAll = false
        if U.traitAll then pcall(function() U.traitAll:Set(false, true) end) end
    end
    local s = getSig("RollService", "SetAutoRoll")
    if s then pcall(function() s:Fire(F.autoRoll) end) end
    applyWS()
    if F.flyOn then setFly(true) end
    if F.fpsOn then task.spawn(applyFpsBoost, true) end
    if F.sellSync and F.sellThreshold > 0 then
        local s2 = getSig("SellService", "UpdateAutoSell")
        if s2 then pcall(function() s2:Fire(F.sellThreshold) end) end
    end
    if F.hideRolls then task.spawn(function() syncRollHidden() rollHideBackup(true) end) end
    loadingCfg = false
    if F.autoMinimize then hideUIAuto() end
end
local function loadConfig()
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then return end
    local path = existingPath(cfgPath(), CFG_FOLDER_OLD .. "/config_" .. tostring(LocalPlayer.UserId) .. ".json")
    if not path then return end
    local okR, txt = pcall(readfile, path)
    if not (okR and txt) then return end
    local okD, data = pcall(function() return HTS:JSONDecode(txt) end)
    if okD and type(data) == "table" then
        applyLoaded(data)
        clog("Settings loaded.")
    end
end
pcall(loadConfig)
end
pcall(armReexec)
pcall(watchRolls)

task.spawn(function()
    task.wait(6)
    if not Alive then return end
    local g = pcall(function() return refreshUnitDrop(U.gradeUnits, gradeUnitByLabel, F.gradeUnits, "grade") end)
    local t = pcall(function() return refreshUnitDrop(U.traitUnits, traitUnitByLabel, F.traitUnits, "trait") end)
    if g or t then notify("Reroll", "Unit lists refreshed.") end
    task.wait(25)
    if not Alive then return end
    pcall(function() refreshUnitDrop(U.gradeUnits, gradeUnitByLabel, F.gradeUnits, "grade") end)
    pcall(function() refreshUnitDrop(U.traitUnits, traitUnitByLabel, F.traitUnits, "trait") end)
end)
task.spawn(function()
    while Alive do
        task.wait(2)
        if F.saveSettings then pcall(saveNow) end
    end
end)

adhShutdown = function()
    Alive = false
    pcall(flyStop)
    pcall(function() applyFpsBoost(false) end)
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end)
    for _, c in ipairs(rollHideConns) do pcall(function() c:Disconnect() end) end
    table.clear(rollHideConns)
    for _, c in ipairs({ noclipConn, charConn, afkConn, tradeListenerConn, rollWatchConn }) do
        if c then pcall(function() c:Disconnect() end) end
    end
    noclipConn, charConn, afkConn, tradeListenerConn, rollWatchConn = nil, nil, nil, nil, nil
end

task.spawn(function() while Alive do task.wait(F.collectDelay) if F.collect then pcall(doCollect) end end end)
task.spawn(function() while Alive do task.wait(F.levelDelay) if F.levelup then pcall(doLevelUp) end end end)
task.spawn(function() while Alive do task.wait(F.placeDelay) if F.placeBest then pcall(doPlaceBest) end end end)
task.spawn(function() while Alive do task.wait(F.upgradeDelay) if F.upgrades then pcall(doUpgrades) end end end)
task.spawn(function() while Alive do task.wait(F.rebirthDelay) if F.rebirth then pcall(doRebirth) end end end)
task.spawn(function() while Alive do task.wait(F.diceDelay) if F.buyDice or F.equipDice then pcall(doDice) end end end)
task.spawn(function() while Alive do task.wait(F.potionDelay) if F.potionAuto then pcall(doPotionTick) end end end)
task.spawn(function() while Alive do task.wait(F.gradeDelay) if F.gradeAuto then pcall(doGradeTick) end end end)
task.spawn(function() while Alive do task.wait(F.traitDelay) if F.traitAuto then pcall(doTraitTick) end end end)
task.spawn(function() while Alive do task.wait(3) if F.hideRolls then syncRollHidden() rollHideBackup(true) end end end)
task.spawn(function() while Alive do task.wait(F.sellDelay) if F.sellAuto then pcall(doInstantSell) end end end)
task.spawn(function()
    task.wait(8)
    if F.codesAuto and Alive then pcall(doRedeemCodes) end
    while Alive do
        task.wait(math.max(60, tonumber(F.codesDelay) or 300))
        if F.codesAuto then pcall(doRedeemCodes) end
    end
end)
task.spawn(function()
    local last = 0
    while Alive do
        task.wait(30)
        if F.claimQuests then pcall(doClaimQuests) end
        if F.smartSell then pcall(smartSellTick) end
        if F.smartLevel then pcall(smartLevelTick) end
        pcall(statsHookTick)
        if F.sellSync and F.sellThreshold > 0 and os.clock() - last > 120 then
            last = os.clock()
            local s = getSig("SellService", "UpdateAutoSell")
            if s then pcall(function() s:Fire(F.sellThreshold) end) end
        end
    end
end)
task.spawn(function()
    local was = false
    while Alive do
        task.wait(0.5)
        if F.tower and not was then was = true task.spawn(doTowerLoop)
        elseif not F.tower then was = false end
    end
end)
task.spawn(function()
    local wasT = false
    while Alive do
        task.wait(0.5)
        if F.tradeAuto and not wasT then wasT = true task.spawn(doTradeLoop)
        elseif not F.tradeAuto then wasT = false end
    end
end)
task.spawn(function()
    while Alive do
        task.wait(0.5)
        if F.tradeAutoGo and not tradeDriving and tradeScreenOpen() then
            task.spawn(driveTrade)
        end
    end
end)
task.spawn(function()
    local lastCollectedTxt = ""
    while Alive do
        task.wait(1)
        pcall(function()
            local txt = "Total collected: " .. fmt(Stats.collectedMoney)
            if txt ~= lastCollectedTxt then
                lastCollectedTxt = txt
                pcall(function() U.collectLine:Set(txt) end)
            end
            setStat(U.towerStat, Stats.towerWins[F.towerName] or 0)
            setStat(U.floorStat, Stats.towerFloors)
            setStat(U.floorNowStat, lastTowerFloor)
            setStat(U.towerGemStat, Stats.towerGems or 0)
            setStat(U.towerTraitStat, Stats.towerTraits or 0)
            setStat(U.moneyStat, money())
            setStat(U.rollStat, rolls())
            setStat(U.soldStat, Stats.sold)
            local pn = 0
            pcall(function() for _ in pairs(activePotions()) do pn += 1 end end)
            setStat(U.potionStat, pn)
            setStat(U.tradeSentStat, Stats.tradesSent or 0)
            setStat(U.tradeOpenStat, Stats.tradesOpened or 0)
        end)
    end
end)

notify("Anime Dice - Perfectus", "Loaded (build " .. tostring(BUILD) .. "). Pick a tab and enable features.")
log("Hub started (build " .. tostring(BUILD) .. ").")
