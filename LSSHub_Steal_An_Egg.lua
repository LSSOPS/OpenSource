if not game then
    error("LSS HUB: Run this script in a Roblox executor, not a Lua editor.")
end

if type(writefile) == "function" then
    pcall(function()
        writefile("LSS HUB_RESUME.lua", [[
local path = "LSS HUBmainfix_autotreadmill_CLEAN.lua"
if type(readfile) == "function" and type(loadstring) == "function" then
    local ok, src = pcall(readfile, path)
    if ok and type(src) == "string" and #src > 0 then
        local chunk = loadstring(src, "@" .. path)
        if chunk then pcall(chunk) end
    end
end
]])
    end)
end

local function LSS HUB_BOOT_PARENT()
    local parent = nil
    pcall(function()
        if typeof(gethui) == "function" then
            parent = gethui()
        end
    end)
    if parent then return parent end
    pcall(function()
        local players = game:GetService("Players")
        local player = players.LocalPlayer
        parent = player and (player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui", 5))
    end)
    if parent then return parent end
    pcall(function()
        parent = game:GetService("CoreGui")
    end)
    return parent
end

local function LSS HUB_BOOT_CLEAR()
    pcall(function()
        local parent = LSS HUB_BOOT_PARENT()
        local old = parent and parent:FindFirstChild("LSS HUB_BOOT_PANEL")
        if old then old:Destroy() end
    end)
end

local function LSS HUB_BOOT_PANEL(title, body)
    local parent = LSS HUB_BOOT_PARENT()
    if not parent then return end
    local panel = parent:FindFirstChild("LSS HUB_BOOT_PANEL")
    if not panel then
        panel = Instance.new("ScreenGui")
        panel.Name = "LSS HUB_BOOT_PANEL"
        panel.ResetOnSpawn = false
        panel.IgnoreGuiInset = true
        panel.ZIndexBehavior = Enum.ZIndexBehavior.Global
        pcall(function() panel.DisplayOrder = 999999 end)
        panel.Parent = parent

        local card = Instance.new("Frame")
        card.Name = "WaveCard"
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.Position = UDim2.fromScale(0.5, 0.5)
        card.Size = UDim2.fromOffset(390, 190)
        card.BackgroundColor3 = Color3.fromRGB(7, 7, 10)
        card.BorderSizePixel = 0
        card.Parent = panel
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = card
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(220, 35, 55)
        stroke.Thickness = 2
        stroke.Transparency = 0.15
        stroke.Parent = card

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.BackgroundTransparency = 1
        titleLabel.Position = UDim2.fromOffset(20, 18)
        titleLabel.Size = UDim2.new(1, -40, 0, 30)
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 20
        titleLabel.TextColor3 = Color3.fromRGB(255, 240, 240)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Center
        titleLabel.Parent = card

        local bodyLabel = Instance.new("TextLabel")
        bodyLabel.Name = "Body"
        bodyLabel.BackgroundTransparency = 1
        bodyLabel.Position = UDim2.fromOffset(20, 52)
        bodyLabel.Size = UDim2.new(1, -40, 0, 24)
        bodyLabel.Font = Enum.Font.Gotham
        bodyLabel.TextSize = 13
        bodyLabel.TextColor3 = Color3.fromRGB(205, 150, 155)
        bodyLabel.TextXAlignment = Enum.TextXAlignment.Center
        bodyLabel.Parent = card

        local wave = Instance.new("Frame")
        wave.Name = "OceanWave"
        wave.BackgroundTransparency = 1
        wave.Position = UDim2.fromOffset(35, 104)
        wave.Size = UDim2.new(1, -70, 0, 48)
        wave.Parent = card
        for i = 1, 13 do
            local bar = Instance.new("Frame")
            bar.Name = "WaveBar" .. i
            bar.AnchorPoint = Vector2.new(0.5, 0.5)
            bar.Position = UDim2.new((i - 0.5) / 13, 0, 0.5, 0)
            bar.Size = UDim2.fromOffset(7, 14)
            bar.BackgroundColor3 = Color3.fromRGB(220, 35 + i * 2, 55 + i * 3)
            bar.BorderSizePixel = 0
            bar.Parent = wave
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(1, 0)
            barCorner.Parent = bar
        end

        task.spawn(function()
            local runService = game:GetService("RunService")
            local started = os.clock()
            while panel and panel.Parent do
                local t = os.clock() - started
                for i, bar in ipairs(wave:GetChildren()) do
                    if bar:IsA("Frame") then
                        local pulse = (math.sin(t * 4.2 + i * 0.72) + 1) * 0.5
                        bar.Size = UDim2.fromOffset(7, 12 + math.floor(pulse * 30))
                        bar.BackgroundTransparency = 0.05 + (1 - pulse) * 0.35
                    end
                end
                runService.Heartbeat:Wait()
            end
        end)
    end
    local card = panel:FindFirstChild("WaveCard")
    if card then
        local titleLabel = card:FindFirstChild("Title")
        local bodyLabel = card:FindFirstChild("Body")
        if titleLabel then titleLabel.Text = tostring(title or "LSS HUB") end
        if bodyLabel then bodyLabel.Text = tostring(body or "Loading...") end
    end
end

LSS HUB_BOOT_PANEL("LSS HUB", "Loading script...")

local __LSS HUB_BOOT_OK, __LSS HUB_BOOT_ERR = xpcall(function()

do
    local prev = _G.LSS HUBStealAnEgg
    if prev and type(prev.Unload) == "function" then pcall(prev.Unload) end
end
local HUB = { conns = {}, drawings = {}, highlights = {}, dead = false, paused = false }
HUB.UI = {}
HUB.Runtime = {}
HUB.V44 = { only100m = false, lockedUid = nil,
    droneFollow = false, droneTarget = nil, droneAt = 0, droneSwingAt = 0,
    autoPlaceBusy = false, hatchBusy = false, afkAt = 0, lastIdleAt = 0,
    defendEgg = false, droneGuardReached = false }

_G.LSS HUBStealAnEgg = HUB
pcall(function()
    local players = game:GetService("Players")
    local parentList = { game:GetService("CoreGui"), players.LocalPlayer and players.LocalPlayer:FindFirstChildOfClass("PlayerGui") }
    if type(gethui) == "function" then
        local ok, custom = pcall(gethui)
        if ok and custom then table.insert(parentList, custom) end
    end
    for _, parent in ipairs(parentList) do
        if parent then
            local previous = parent:FindFirstChild("LSS HUB_StealMini_V45")
            if previous then previous:Destroy() end
        end
    end
end)
local function track(conn) table.insert(HUB.conns, conn); return conn end
local function trackDrawing(d) if d then table.insert(HUB.drawings, d) end; return d end

local WindUI_VERSION = "1.6.66"
local okWindUI, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. WindUI_VERSION .. "/main.lua"))()
end)
if not okWindUI or not WindUI then
    error("LSS HUB: Failed to download WindUI " .. WindUI_VERSION)
end
pcall(function() WindUI:SetNotificationLower(true) end)
LSS HUB_BOOT_PANEL("LSS HUB", "WindUI loaded, building UI...")
local LSS HUB_TEXT = {
    ["LSS HUB"] = "LSS HUB",
    ["LSS HUB | Steal An Egg"] = "Steal An Egg",
    ["Eggs"] = "Eggs",
    ["Steal, hatch & plant"] = "Steal, place and hatch eggs",
    ["Base"] = "Base",
    ["Base / Plot"] = "Base / Plot",
    ["Homestead & training"] = "Base and pets",
    ["Combat"] = "Combat",
    ["Bat, slaps & defense"] = "Bat, aura and defense",
    ["Player"] = "Player",
    ["Movement & teleports"] = "Movement and teleports",
    ["Settings"] = "Settings",
    ["Configs & unloader"] = "Configs and unload script",
    ["Auto Steal"] = "Auto Steal Eggs",
    ["Auto Hatch & Plant"] = "Auto Hatch and Plant",
    ["Egg Tracker ESP"] = "Egg ESP",
    ["Auto Steal Eggs"] = "Auto Steal Eggs",
    ["Tween Glide"] = "Smooth Glide",
    ["Fly Glide"] = "Free Fly",
    ["Safe Walk"] = "Safe Walk",
    ["Rare Egg Hunter (Highest Rarity First)"] = "Prioritize highest value eggs",
    ["Money Hunter (Highest Money First)"] = "Prioritize highest money eggs",
    ["Filter by Rarity (Multi-Select)"] = "Filter by rarity",
    ["Filter by Area (Multi-Select)"] = "Filter by area",
    ["Filter by Mutation (Multi-Select)"] = "Filter by mutation",
    ["Glide / Travel Speed"] = "Glide / travel speed",
    ["Steal Delay Gap"] = "Delay between steals",
    ["Steal Best Available Egg Once"] = "Steal best egg once",
    ["Auto Hatch Ready Eggs"] = "Auto hatch ready eggs",
    ["Auto Place Egg (Base Pen)"] = "Auto place egg at base",
    ["Hatch Check Delay"] = "Hatch check delay",
    ["Hatch All Ready Eggs Now"] = "Hatch all ready eggs now",
    ["Place Carried Eggs in Pen Now"] = "Place carried eggs now",
    ["Egg ESP Enabled"] = "Enable egg ESP",
    ["Show 3D Pet Image Badges"] = "Show 3D pet images",
    ["Trap ESP (Highlights Enemy Traps)"] = "Enemy trap ESP",
    ["Show Mutated / Rare Eggs Only"] = "Show rare / mutated eggs only",
    ["Max ESP Distance"] = "Max ESP distance",
    ["Homestead & Treadmill"] = "Base and Treadmill",
    ["Pets & Satchel"] = "Pets and Satchel",
    ["Auto Sell"] = "Auto Sell",
    ["Events & Bosses"] = "Events and Bosses",
    ["Claim Rewards"] = "Claim Rewards",
    ["Auto Upgrade Base / Plot"] = "Auto upgrade base / plot",
    ["Auto Upgrade Treadmill Tier"] = "Auto upgrade treadmill",
    ["Auto Buy Speed Trails"] = "Auto buy speed trails",
    ["Upgrade Base Now"] = "Upgrade base now",
    ["Upgrade Treadmill Now"] = "Upgrade treadmill now",
    ["Auto Equip Best Pets"] = "Auto equip best pets",
    ["Equip Best Pets Now"] = "Equip best pets now",
    ["Auto Sell Low-Tier Pets"] = "Auto sell low-tier pets",
    ["Filter Pet Sell Rarities"] = "Pet rarities to sell",
    ["Auto Sell Low-Tier Eggs"] = "Auto sell low-tier eggs",
    ["Filter Egg Sell Rarities"] = "Egg rarities to sell",
    ["Sell Selected Pets Now"] = "Sell selected pets now",
    ["Sell Selected Eggs Now"] = "Sell selected eggs now",
    ["FULL AUTO Boss Fight (Join + Fight + Dodge + Claim)"] = "Full auto boss: join, fight, dodge, claim",
    ["Boss Targeting"] = "Boss targeting",
    ["Crystals First"] = "Crystals first",
    ["Boss First"] = "Boss first",
    ["Hazard Immunity (No Black Hole / Trap Damage)"] = "Boss damage immunity",
    ["Auto Join Boss Arena (Every 30 min)"] = "Auto join Boss Arena",
    ["Auto Claim Boss Mastery Rewards"] = "Auto claim Boss Mastery rewards",
    ["Join Boss Arena Now"] = "Join Boss Arena now",
    ["Claim Boss Mastery Now"] = "Claim Boss Mastery now",
    ["Boss Arena Status"] = "Boss Arena status",
    ["Auto Claim Away Earnings & Codex"] = "Auto claim Away Earnings and Codex",
    ["Claim Away Earnings & Codex Now"] = "Claim Away Earnings and Codex now",
    ["Bat & Slap Aura"] = "Bat and slap aura",
    ["Defense & Guards"] = "Defense and guards",
    ["Bat / Slap Aura"] = "Bat / Slap Aura",
    ["Aura Radius"] = "Aura radius",
    ["Swing Delay"] = "Swing delay",
    ["Swing Bat Once (Manual)"] = "Swing bat once",
    ["Anti-Trap (Full Immunity / Destroy Hitboxes)"] = "Anti Trap",
    ["No Knockback / Ragdoll Immunity"] = "Anti knockback / ragdoll",
    ["Anti-Ragdoll (Quick Standup)"] = "Anti ragdoll",
    ["Movement"] = "Movement",
    ["Area Travel"] = "Area travel",
    ["Plot Travel"] = "Plot travel",
    ["Player Travel"] = "Player travel",
    ["Visuals & Performance"] = "Visuals and performance",
    ["Enable WalkSpeed"] = "Enable WalkSpeed",
    ["WalkSpeed Value"] = "WalkSpeed value",
    ["Enable JumpPower"] = "Enable JumpPower",
    ["JumpPower Value"] = "JumpPower value",
    ["Infinite Jump"] = "Infinite jump",
    ["Smooth Fly (WASD + Space/Shift)"] = "Smooth fly",
    ["Fly Speed"] = "Fly speed",
    ["Anti-AFK (Bypass 20min Kick)"] = "Anti AFK",
    ["Select Area"] = "Select area",
    ["Travel to Selected Area"] = "Travel to selected area",
    ["Select Plot"] = "Select plot",
    ["My Plot"] = "My plot",
    ["Travel to Plot"] = "Travel to plot",
    ["Select Player"] = "Select player",
    ["(no other players)"] = "(no other players)",
    ["Refresh Player List"] = "Refresh player list",
    ["Travel to Player"] = "Travel to player",
    ["Fullbright (Daylight Visuals)"] = "Fullbright",
    ["Delete Own Pet Renders (FPS Boost)"] = "Delete own pet renders",
    ["Configuration"] = "Configuration",
    ["Config Name"] = "Config name",
    ["Save Config"] = "Save config",
    ["Load Config"] = "Load config",
    ["Toggle UI Keybind"] = "Toggle UI keybind",
    ["Unload LSS HUB"] = "Unload LSS HUB",
    ["Version 4.2.2 (Production)\nEquipped with UGI / Client AC Neutralizer, BAC Telemetry Spoofer, Evidence Scrubber, Strict Rarity Filtering, clean open walkway travel without wall clipping, automatic return to trigger position, and auto egg placement in pen.\nAutomated egg stealing, hatching, homestead base upgrades, treadmill speed training, rewards collector, bat aura, ESP tracker."] = "Update"
}
for key, value in pairs({
    ["Secret"] = "Secret",
    ["Legendary"] = "Legendary",
    ["Epic"] = "Epic",
    ["Rare"] = "Rare",
    ["Common"] = "Common",
    ["Enabled"] = "Enabled",
    ["Disabled"] = "Disabled",
    ["Info"] = "Info",
    ["Success"] = "Success",
    ["Error"] = "Error",
    ["Tất cả"] = "All",
    ["Đã bỏ lọc"] = "Filter cleared",
    ["Đã chọn: "] = "Selected: ",
    ["Đã bỏ: "] = "Removed: ",
    ["Steal Egg"] = "Steal Egg",
    ["Auto Hatch"] = "Auto Hatch",
    ["Auto Place Egg"] = "Auto Place Egg",
    ["Hatch"] = "Hatch",
    ["Plant Eggs"] = "Plant Eggs",
    ["Egg ESP"] = "Egg ESP",
    ["Base Upgrade"] = "Base Upgrade",
    ["Treadmill Upgrade"] = "Treadmill Upgrade",
    ["Pets"] = "Pets",
    ["Sales"] = "Sales",
    ["Boss Auto"] = "Boss Auto",
    ["Boss Hazards"] = "Boss Hazards",
    ["Boss Arena"] = "Boss Arena",
    ["Boss Mastery"] = "Boss Mastery",
    ["Rewards"] = "Rewards",
    ["Bat Aura"] = "Bat Aura",
    ["Bat"] = "Bat",
    ["Anti-Trap"] = "Anti Trap",
    ["Knockback"] = "Knockback",
    ["WalkSpeed"] = "WalkSpeed",
    ["JumpPower"] = "JumpPower",
    ["Fly"] = "Fly",
    ["Travel"] = "Travel",
    ["Plot"] = "Plot",
    ["Players"] = "Players",
    ["Performance"] = "Performance",
    ["Config"] = "Config",
    ["Stealing target egg"] = "Stealing target egg",
    ["No matching egg found for selected filters"] = "No matching egg found for selected filters",
    ["Requested base upgrade"] = "Requested base upgrade",
    ["Requested treadmill upgrade"] = "Requested treadmill upgrade",
    ["Equipped best pets"] = "Equipped best pets",
    ["Sold matching pets"] = "Sold matching pets",
    ["Sold matching eggs"] = "Sold matching eggs",
    ["Fully automatic: joins, fights the Overlord and claims rewards"] = "Fully automatic: joins, fights the Overlord and claims rewards",
    ["Immune - hazard damage reports blocked"] = "Immune - hazard damage reports blocked",
    ["Normal hazard damage"] = "Normal hazard damage",
    ["Will join whenever the arena opens"] = "Will join whenever the arena opens",
    ["Sent to Abyss Overlord"] = "Sent to Abyss Overlord",
    ["Arena is closed - opens every 30 minutes"] = "Arena is closed - opens every 30 minutes",
    ["Nothing claimable yet"] = "Nothing claimable yet",
    ["Claimed all ready rewards and earnings"] = "Claimed all ready rewards and earnings",
    ["Triggered bat swing"] = "Triggered bat swing",
    ["Immunity Active (Enemy Hitboxes Destroyed)"] = "Immunity active, enemy hitboxes destroyed",
    ["Anti-Trap Disabled"] = "Anti Trap disabled",
    ["Ragdoll Immunity Active"] = "Ragdoll immunity active",
    ["Knockback Enabled"] = "Knockback enabled",
    ["Area position not found"] = "Area position not found",
    ["Plot not found"] = "Plot not found",
    ["Refreshed player list"] = "Refreshed player list",
    ["Player unavailable"] = "Player unavailable",
    ["Hazard immunity is not supported on mobile - the boss can still hit you"] = "Hazard immunity is not supported on mobile - the boss can still hit you",
    ["Auto Treadmill"] = "Auto Treadmill",
    ["Auto Upgrade Treadmill"] = "Auto upgrade treadmill",
    ["Anti Egg Drop "] = "Anti Egg Drop ",
    ["Rare Egg Hunter (Highest Rarity First)"] = "Prioritize highest rarity eggs",
    ["Filter by Rarity (Multi-Select)"] = "Filter by rarity",
    ["Filter by Area (Multi-Select)"] = "Filter by area",
    ["Filter by Mutation (Multi-Select)"] = "Filter by mutation",
    ["Glide / Travel Speed"] = "Glide / travel speed",
    ["Steal Delay Gap"] = "Delay between steals",
    ["Steal Best Available Egg Once"] = "Steal best egg once",
    ["Auto Hatch Ready Eggs"] = "Auto hatch ready eggs",
    ["Auto Place Egg (Base Pen)"] = "Auto place egg in pen",
    ["Hatch Check Delay"] = "Hatch check delay",
    ["Hatch All Ready Eggs Now"] = "Hatch all ready eggs now",
    ["Place Carried Eggs in Pen Now"] = "Place carried eggs in pen",
    ["Egg ESP Enabled"] = "Enable egg ESP",
    ["Show 3D Pet Image Badges"] = "Show 3D pet images",
    ["Trap ESP (Highlights Enemy Traps)"] = "Enemy trap ESP",
    ["Show Mutated / Rare Eggs Only"] = "Show rare / mutated eggs only",
    ["Max ESP Distance"] = "Max ESP distance",
    ["Auto Upgrade Base / Plot"] = "Auto upgrade base / plot",
    ["Auto Upgrade Treadmill Tier"] = "Auto upgrade treadmill tier",
    ["Auto Buy Speed Trails"] = "Auto buy speed trails",
    ["Upgrade Base Now"] = "Upgrade base now",
    ["Upgrade Treadmill Now"] = "Upgrade treadmill now",
    ["Equip Best Pets Now"] = "Equip best pets now",
    ["Auto Sell Low-Tier Pets"] = "Auto sell low-tier pets",
    ["Filter Pet Sell Rarities"] = "Filter pet rarities to sell",
    ["Auto Sell Low-Tier Eggs"] = "Auto sell low-tier eggs",
    ["Filter Egg Sell Rarities"] = "Filter egg rarities to sell",
    ["Sell Selected Pets Now"] = "Sell selected pets now",
    ["Sell Selected Eggs Now"] = "Sell selected eggs now",
    ["FULL AUTO Boss Fight (Join + Fight + Dodge + Claim)"] = "Full auto boss (join + fight + dodge + claim)",
    ["Boss Targeting"] = "Boss targeting",
    ["Hazard Immunity (No Black Hole / Trap Damage)"] = "Hazard immunity",
    ["Auto Join Boss Arena (Every 30 min)"] = "Auto join boss arena every 30 min",
    ["Auto Claim Boss Mastery Rewards"] = "Auto claim boss mastery rewards",
    ["Join Boss Arena Now"] = "Join boss arena now",
    ["Claim Boss Mastery Now"] = "Claim boss mastery now",
    ["Boss Arena Status"] = "Boss arena status",
    ["Auto Claim Away Earnings & Codex"] = "Auto claim away earnings and codex",
    ["Claim Away Earnings & Codex Now"] = "Claim away earnings and codex now",
    ["Bat / Slap Aura"] = "Bat / slap aura",
    ["Aura Radius"] = "Aura radius",
    ["Swing Delay"] = "Swing delay",
    ["Swing Bat Once (Manual)"] = "Swing bat once",
    ["Anti-Trap (Full Immunity / Destroy Hitboxes)"] = "Anti trap (full immunity / destroy hitboxes)",
    ["No Knockback / Ragdoll Immunity"] = "No knockback / ragdoll immunity",
    ["Anti-Ragdoll (Quick Standup)"] = "Anti ragdoll (quick standup)",
    ["Enable WalkSpeed"] = "Enable walkspeed",
    ["WalkSpeed Value"] = "Walkspeed value",
    ["Infinite Jump"] = "Infinite jump",
    ["Anti-AFK (Bypass 20min Kick)"] = "Anti AFK (bypass 20 min kick)",
    ["Select Area"] = "Select area",
    ["Travel to Selected Area"] = "Travel to selected area",
    ["Select Plot"] = "Select plot",
    ["Travel to Plot"] = "Travel to plot",
    ["Select Player"] = "Select player",
    ["Refresh Player List"] = "Refresh player list",
    ["Travel to Player"] = "Travel to player",
    ["Fullbright (Daylight Visuals)"] = "Fullbright",
    ["Ride Light Dark Guard (Real Movement)"] = "Ride Light Dark Guard (real movement)",
    ["Delete Own Pet Renders (FPS Boost)"] = "Delete own pet renders (FPS boost)",
    ["Shop"] = "Shop",
    ["Event"] = "Event",
    ["Settings"] = "Settings",
    ["Auto Steal"] = "Auto Steal",
    ["Auto Hatch & Plant"] = "Auto hatch and plant",
    ["Egg Tracker ESP"] = "Egg tracker ESP",
    ["Homestead & Treadmill"] = "Base and treadmill",
    ["Pets & Satchel"] = "Pets and satchel",
    ["Auto Sell"] = "Auto sell",
    ["Events & Bosses"] = "Events and bosses",
    ["Claim Rewards"] = "Claim rewards",
    ["Bat & Slap Aura"] = "Bat and slap aura",
    ["Defense & Guards"] = "Defense and guards",
    ["Movement"] = "Movement",
    ["Area Travel"] = "Area travel",
    ["Plot Travel"] = "Plot travel",
    ["Player Travel"] = "Player travel",
    ["Visuals & Performance"] = "Visuals and performance",
    ["Trail Shop"] = "Trail shop",
    ["Speed & Trail"] = "Speed and trail",
    ["Drone"] = "Drone",
}) do
    LSS HUB_TEXT[key] = value
end
local function VI(text)
    if type(text) ~= "string" then return text end
    if LSS HUB_TEXT[text] then return LSS HUB_TEXT[text] end
    local patterns = {
        { "^Hatched (%d+) egg%(s%)$", "Hatched %1 egg(s)" },
        { "^Planted (%d+) egg%(s%) in pen$", "Planted %1 egg(s) in pen" },
        { "^Claimed (%d+) milestone reward%(s%)$", "Claimed %1 milestone reward(s)" },
        { "^OPEN %- (.+) HP$", "OPEN - %1 HP" },
        { "^Closed %- next in (.+)$", "Closed - next in %1" },
        { "^Traveling to (.+)$", "Traveling to %1" },
        { "^Arrived at (.+)$", "Arrived at %1" },
        { "^Removed (%d+) rendered pet model%(s%)$", "Removed %1 rendered pet model(s)" },
        { "^Saved config '(.+)'$", "Saved config '%1'" },
        { "^Save failed: (.+)$", "Save failed: %1" },
        { "^Loaded config '(.+)'$", "Loaded config '%1'" },
        { "^Load failed: (.+)$", "Load failed: %1" },
    }
    for _, item in ipairs(patterns) do
        local out, n = text:gsub(item[1], item[2])
        if n > 0 then return out end
    end
    return text
end
local function LSS HUB_NOTIFY(title, content, dur)
    return
end
local LSS HUB_CFG = {
    file = "LSS HUB_SETTINGS.json",
    resumeFile = "LSS HUB_RESUME.lua",
    controls = {}, data = {}, restoring = true, queued = false,
    autoResume = true, autoSave = true, pending = false,
}

local function LSS HUB_CFG_Copy(value)
    if type(value) ~= "table" then return value end
    local copy = {}
    for k, v in pairs(value) do
        if type(k) == "string" or type(k) == "number" then
            if type(v) == "string" or type(v) == "boolean" or type(v) == "number" then
                copy[k] = v
            end
        end
    end
    return copy
end

function LSS HUB_CFG.Read()
    if type(readfile) ~= "function" then return nil end
    local ok, config = pcall(function()
        local content = readfile(LSS HUB_CFG.file)
        return game:GetService("HttpService"):JSONDecode(content)
    end)
    return ok and type(config) == "table" and config or nil
end

local initialConfig = LSS HUB_CFG.Read()
if initialConfig then
    if type(initialConfig.values) == "table" then LSS HUB_CFG.data = initialConfig.values end
    if type(initialConfig.autoResume) == "boolean" then LSS HUB_CFG.autoResume = initialConfig.autoResume end
    if type(initialConfig.autoSave) == "boolean" then LSS HUB_CFG.autoSave = initialConfig.autoSave end
end

function LSS HUB_CFG.Save(force)
    if not force and not LSS HUB_CFG.autoSave then return false, "Auto save is off" end
    if type(writefile) ~= "function" then return false, "Executor does not support writefile" end
    local payload = {
        version = 1,
        autoResume = LSS HUB_CFG.autoResume,
        autoSave = LSS HUB_CFG.autoSave,
        values = LSS HUB_CFG.data,
    }
    local ok, err = pcall(function()
        local encoded = game:GetService("HttpService"):JSONEncode(payload)
        writefile(LSS HUB_CFG.file, encoded)
    end)
    return ok, err
end

function LSS HUB_CFG.MarkDirty()
    if LSS HUB_CFG.restoring or not LSS HUB_CFG.autoSave or LSS HUB_CFG.pending then return end
    LSS HUB_CFG.pending = true
    task.delay(0.8, function()
        LSS HUB_CFG.pending = false
        if not HUB.dead then LSS HUB_CFG.Save(false) end
    end)
end

function LSS HUB_CFG.Option(opts, kind)
    opts = opts or {}
    local key = opts.Flag or (kind .. ":" .. tostring(opts.Name or opts.Title or opts.Label or ""))
    local saved = LSS HUB_CFG.data[key]
    if kind == "toggle" then
        if type(saved) == "boolean" then opts.Default = saved end
    elseif kind == "slider" then
        if type(saved) == "number" and saved == saved then
            opts.Default = math.clamp(saved, tonumber(opts.Min) or 0, tonumber(opts.Max) or 100)
        end
    elseif kind == "multi" then
        if type(saved) == "table" then
            local available, filtered = {}, {}
            for _, option in ipairs(opts.Options or {}) do available[tostring(option)] = true end
            for _, option in ipairs(saved) do
                if available[tostring(option)] then filtered[#filtered + 1] = option end
            end
            opts.Default = filtered
        end
    elseif kind == "dropdown" then
        if type(saved) == "string" or type(saved) == "number" then
            for _, option in ipairs(opts.Options or opts.Items or {}) do
                if option == saved then opts.Default = saved; break end
            end
        end
    elseif kind == "input" then
        if type(saved) == "string" then opts.Default = saved end
    end
    local userCallback = opts.Callback
    opts.Callback = function(value, ...)
        local safeValue = LSS HUB_CFG_Copy(value)
        if (type(safeValue) == "string" or type(safeValue) == "number"
            or type(safeValue) == "boolean" or type(safeValue) == "table")
            and not LSS HUB_CFG.restoring then
            LSS HUB_CFG.data[key] = safeValue
            LSS HUB_CFG.MarkDirty()
        end
        if userCallback then return userCallback(value, ...) end
    end
    LSS HUB_CFG.controls[key] = { kind = kind, apply = opts.Callback, default = opts.Default }
    return opts, key
end

function LSS HUB_CFG.RegisterHandle(key, handle)
    if LSS HUB_CFG.controls[key] then LSS HUB_CFG.controls[key].handle = handle end
end

function LSS HUB_CFG.RestoreAll()
    LSS HUB_CFG.restoring = true
    for key, control in pairs(LSS HUB_CFG.controls) do
        local value = LSS HUB_CFG.data[key]
        if value == nil then value = control.default end
        if value ~= nil then
            pcall(control.apply, LSS HUB_CFG_Copy(value))
            local handle = control.handle
            if handle and (control.kind == "toggle" or control.kind == "slider") then
                pcall(function()
                    if type(handle.SetValue) == "function" then handle:SetValue(value)
                    elseif type(handle.Set) == "function" then handle:Set(value) end
                end)
            end
        end
    end
    LSS HUB_CFG.restoring = false
end

function LSS HUB_CFG.LoadAndApply()
    local data = LSS HUB_CFG.Read()
    if not data then return false, "Config not found or readfile not supported" end
    if type(data.values) == "table" then LSS HUB_CFG.data = data.values end
    if type(data.autoResume) == "boolean" then LSS HUB_CFG.autoResume = data.autoResume end
    if type(data.autoSave) == "boolean" then LSS HUB_CFG.autoSave = data.autoSave end
    LSS HUB_CFG.data.settings_resume = LSS HUB_CFG.autoResume
    LSS HUB_CFG.data.settings_autosave = LSS HUB_CFG.autoSave
    LSS HUB_CFG.RestoreAll()
    if LSS HUB_CFG.autoResume then LSS HUB_CFG.Queue() end
    return true
end

local LSS HUB_RESUME_CODE = [==[
if not game:IsLoaded() then game.Loaded:Wait() end
local players = game:GetService("Players")
if not players.LocalPlayer then players:GetPropertyChangedSignal("LocalPlayer"):Wait() end
local permitted = false
if type(readfile) == "function" then
    local ok, config = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile("LSS HUB_SETTINGS.json"))
    end)
    permitted = (not ok) or (type(config) == "table" and config.autoResume ~= false)
end
if permitted and type(readfile) == "function" and type(loadstring) == "function" then
    local ok, source = pcall(readfile, "LSS HUB_RESUME.lua")
    if ok and type(source) == "string" then
        local fn = loadstring(source)
        if fn then fn() end
    end
end
]==]

function LSS HUB_CFG.Queue()
    if LSS HUB_CFG.queued or not LSS HUB_CFG.autoResume then return LSS HUB_CFG.queued end
    if type(readfile) ~= "function" or type(writefile) ~= "function" then return false end
    local executorQueue = queue_on_teleport or queueonteleport
    if type(executorQueue) ~= "function" then
        local synTable = (type(syn) == "table") and syn or nil
        executorQueue = synTable and synTable.queue_on_teleport
    end
    if type(executorQueue) ~= "function" then return false end
    local ok = pcall(executorQueue, LSS HUB_RESUME_CODE)
    if ok then LSS HUB_CFG.queued = true end
    return ok
end

LSS HUB_CFG.Queue()

local function LSS HUB_WRAP_TAB(rawTab)
    local tab = {}
    local function addElement(method, opts)
        opts = opts or {}
        local ok, handle = pcall(function() return rawTab[method](rawTab, opts) end)
        if not ok then
            LSS HUB_NOTIFY("LSS HUB", tostring(opts.Title or opts.Name or method) .. " UI error", 4)
            return {}
        end
        return handle or {}
    end

    function tab:AddSubTab(name)
        local ok, section = pcall(function()
            return rawTab:Section({Title = VI(name), Opened = true})
        end)
        if ok and section then return LSS HUB_WRAP_TAB(section) end
        return tab
    end

    function tab:AddToggle(opts)
        opts = opts or {}
        local prefKey
        opts, prefKey = LSS HUB_CFG.Option(opts, "toggle")
        local callback = opts.Callback
        local title = opts.Name
        local handle = addElement("Toggle", {
            Title = title, Desc = opts.Desc and VI(opts.Desc) or nil,
            Value = opts.Default == true, Flag = opts.Flag,
            Type = opts.Type or "Toggle",
            Callback = function(v) if callback then callback(v == true) end end,
        })
        handle.Get = handle.Get or function() return opts.Default == true end
        LSS HUB_CFG.RegisterHandle(prefKey, handle)
        return handle
    end

    function tab:AddButton(opts)
        opts = opts or {}
        local callback = opts.Callback
        return addElement("Button", {
            Title = VI(opts.Name or opts.Title or "Button"),
            Desc = opts.Desc and VI(opts.Desc) or nil,
            Icon = opts.Icon, Color = opts.Color, Flag = opts.Flag,
            Callback = function() if callback then callback() end end,
        })
    end

    function tab:AddSlider(opts)
        opts = opts or {}
        local prefKey
        opts, prefKey = LSS HUB_CFG.Option(opts, "slider")
        local callback = opts.Callback
        local title = VI(opts.Name or opts.Title or "Slider")
        local min = tonumber(opts.Min or (opts.Value and opts.Value.Min)) or 0
        local max = tonumber(opts.Max or (opts.Value and opts.Value.Max)) or 100
        local value = tonumber(opts.Default or (opts.Value and opts.Value.Default)) or min
        local handle = addElement("Slider", {
            Title = title, Desc = opts.Desc and VI(opts.Desc) or nil,
            Value = {Min = min, Max = max, Default = math.clamp(value, min, max)},
            Step = tonumber(opts.Step) or 1, Flag = opts.Flag,
            Callback = function(v) if callback then callback(tonumber(v) or value) end end,
        })
        LSS HUB_CFG.RegisterHandle(prefKey, handle)
        return handle
    end

    local function makeDropdown(opts, multi)
        opts = opts or {}
        local kind = multi and "multi" or "dropdown"
        local prefKey
        opts, prefKey = LSS HUB_CFG.Option(opts, kind)
        local callback = opts.Callback
        local title = VI(opts.Name or opts.Label or opts.Title or "Dropdown")
        local options = opts.Options or opts.Items or opts.Values or {}
        local current = multi and {} or (opts.Default or options[1])
        if multi then
            for _, v in ipairs(opts.Default or {}) do current[tostring(v)] = true end
        end
        local handle
        local wrapper = {}
        local function values()
            local result = {}
            for _, v in ipairs(options) do result[#result + 1] = tostring(v) end
            return result
        end
        local function emit(v)
            if multi then
                local selected = {}
                for _, x in ipairs(v or {}) do current[tostring(x)] = true; selected[#selected + 1] = x end
                if callback then callback(selected) end
            else
                current = v
                for _, x in ipairs(options) do if tostring(x) == tostring(v) then current = x; break end end
                if callback then callback(current) end
            end
        end
        local function build()
            local config = {
                Title = title, Values = values(), Multi = multi,
                AllowNone = multi or opts.AllowNone == true,
                SearchBarEnabled = opts.SearchBarEnabled == true, Flag = opts.Flag,
                Callback = emit,
            }
            if not multi and current ~= nil then config.Value = tostring(current) end
            handle = addElement("Dropdown", config)
        end
        build()
        wrapper.Get = function()
            if not multi then return current end
            local result = {}
            for _, v in ipairs(options) do if current[tostring(v)] then result[#result + 1] = v end end
            return result
        end
        wrapper.SetOptions = function(_, newOptions)
            options = newOptions or {}
            current = multi and {} or options[1]
            if handle and handle.Destroy then pcall(function() handle:Destroy() end) end
            build()
        end
        wrapper.Select = function(_, v)
            if handle and handle.Select then pcall(function() handle:Select(v) end) end
        end
        LSS HUB_CFG.RegisterHandle(prefKey, wrapper)
        return wrapper
    end
    function tab:AddDropdown(opts) return makeDropdown(opts, false) end
    function tab:AddMultiDropdown(opts) return makeDropdown(opts, true) end

    function tab:AddInput(opts)
        opts = opts or {}
        local prefKey
        opts, prefKey = LSS HUB_CFG.Option(opts, "input")
        local callback = opts.Callback
        local handle = addElement("Input", {
            Title = VI(opts.Name or opts.Title or "Input"),
            Placeholder = VI(tostring(opts.Placeholder or opts.Default or "")),
            Value = opts.Default, Callback = function(v) if callback then callback(v) end end,
        })
        LSS HUB_CFG.RegisterHandle(prefKey, handle)
        return handle
    end
    function tab:AddKeybind(opts)
        opts = opts or {}
        return tab:AddButton({Name = opts.Name or "Toggle UI Keybind", Callback = opts.OnPress or opts.Callback})
    end
    function tab:AddDivider() pcall(function() rawTab:Divider() end) end
    function tab:AddParagraph(opts)
        opts = opts or {}
        pcall(function() rawTab:Paragraph({Title = VI(opts.Title or "LSS HUB"), Desc = VI(opts.Content or "")}) end)
    end
    return tab
end

local okWindUIWindow, WindUIWindow = pcall(function()
    return WindUI:CreateWindow({
        Title = "Steal An Egg",
        Icon = "egg",
        Author = "By LSS HUB",
        Background = "rbxassetid://76540510203010",
        BackgroundImageTransparency = 0.65,
        Theme = "Dark",
        ToggleKey = Enum.KeyCode.RightControl,
        Resizable = true,
        Size = UDim2.fromOffset(580, 460),
        MinSize = Vector2.new(560, 350),
        MaxSize = Vector2.new(850, 560),
        Transparent = true,
        SideBarWidth = 200,
        HideSearchBar = true,
        ScrollBarEnabled = false,
        User = {
            Enabled = true,
            Anonymous = false,
            Callback = function()
                print("clicked")
            end,
        },
    })
end)
if not okWindUIWindow or not WindUIWindow then
    error("LSS HUB: WindUI CreateWindow error: " .. tostring(WindUIWindow))
end

task.spawn(function()
    local backgroundAsset = "rbxassetid://76540510203010"
    for _ = 1, 24 do
        pcall(function()
            local roots = {
                game:GetService("CoreGui"),
                game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui"),
            }
            for _, root in ipairs(roots) do
                if root then
                    for _, obj in ipairs(root:GetDescendants()) do
                        if obj:IsA("ImageLabel") then
                            local name = tostring(obj.Name):lower()
                            local image = tostring(obj.Image or "")
                            if image:find("76540510203010", 1, true)
                                or name:find("background", 1, true)
                                or name:find("backdrop", 1, true)
                            then
                                obj.Image = backgroundAsset
                                obj.Visible = true
                                obj.BackgroundTransparency = 1
                                obj.ImageTransparency = 0.35
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.35)
    end
end)
LSS HUB_BOOT_PANEL("LSS HUB", "WindUI built, loading tabs...")
local Library = {}
local LSS HUB_CREATED_TABS = 0
function Library:CreateWindow()
    local win = {}
    function win:AddTab(opts)
        opts = opts or {}
        local okTab, rawTab = pcall(function()
            return WindUIWindow:Tab({Title = VI(opts.Name or "Tab"), Desc = opts.Subtitle, Icon = opts.Icon})
        end)
        if not okTab or not rawTab then
            LSS HUB_NOTIFY("LSS HUB", "Failed to create tab " .. tostring(opts.Name), 4)
            rawTab = {}
        else
            LSS HUB_CREATED_TABS = LSS HUB_CREATED_TABS + 1
        end
        return LSS HUB_WRAP_TAB(rawTab)
    end
    function win:Notify(opts)
        opts = opts or {}
        pcall(function() WindUI:Notify({Title = opts.Title or "LSS HUB", Content = opts.Content or "", Duration = opts.Duration or 3}) end)
    end
    function win:Toggle() pcall(function() WindUIWindow:Toggle() end) end
    function win:Destroy() pcall(function() WindUIWindow:Destroy() end) end
    return win
end

local Window = Library:CreateWindow()

local function LSS HUB_BRANDED_ROOT(root)
    if not root then return false end
    local ok, descendants = pcall(function()
        return root:GetDescendants()
    end)
    if not ok or type(descendants) ~= "table" then return false end
    for _, d in ipairs(descendants) do
        if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
            local text = tostring(d.Text or "")
            if text:find("LSS HUB", 1, true) or text:find("Steal", 1, true) then
                return true
            end
        end
    end
    return false
end

local function LSS HUB_STROKE(frame, thickness)
    local stroke = frame:FindFirstChild("LSS HUB_Stroke")
    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.Name = "LSS HUB_Stroke"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = frame
    end
    stroke.Thickness = thickness or 1.4
    stroke.Transparency = 0.08
    stroke.Color = Color3.fromRGB(150, 193, 255)
    local gradient = stroke:FindFirstChild("LSS HUB_Gradient")
    if not gradient then
        gradient = Instance.new("UIGradient")
        gradient.Name = "LSS HUB_Gradient"
        gradient.Parent = stroke
    end
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(245, 250, 255)),
        ColorSequenceKeypoint.new(0.34, Color3.fromRGB(92, 170, 255)),
        ColorSequenceKeypoint.new(0.68, Color3.fromRGB(138, 112, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(245, 250, 255)),
    })
    gradient.Rotation = (os.clock() * 36) % 360
end

local function LSS HUB_STYLE_UI()
    local roots = {}
    local viewport = nil
    pcall(function()
        local cam = game:GetService("Workspace").CurrentCamera
        viewport = cam and cam.ViewportSize
    end)
    local function isOuterFrame(size)
        if not viewport then return false end
        return (size.X >= viewport.X * 0.82 and size.Y >= viewport.Y * 0.72) or size.Y >= viewport.Y * 0.92
    end
    local function collect(parent)
        if not parent then return end
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("ScreenGui") and LSS HUB_BRANDED_ROOT(child) then
                table.insert(roots, child)
            end
        end
    end
    pcall(function() collect(game:GetService("CoreGui")) end)
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        collect(player and player:FindFirstChildOfClass("PlayerGui"))
    end)
    for _, root in ipairs(roots) do
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                local text = tostring(obj.Text or "")
                obj.TextColor3 = Color3.fromRGB(238, 244, 255)
                if obj:IsA("TextButton") and obj.AbsoluteSize.X >= 85 and obj.AbsoluteSize.Y >= 26 then
                    obj.BackgroundColor3 = Color3.fromRGB(19, 29, 51)
                    if obj.BackgroundTransparency < 0.92 then
                        LSS HUB_STROKE(obj, 0.85)
                        obj.BackgroundTransparency = math.max(obj.BackgroundTransparency, 0.14)
                    end
                    if not obj:FindFirstChildOfClass("UICorner") then
                        local corner = Instance.new("UICorner")
                        corner.CornerRadius = UDim.new(0, 9)
                        corner.Parent = obj
                    end
                end
                if obj:IsA("TextBox") then
                    obj.PlaceholderColor3 = Color3.fromRGB(144, 157, 184)
                end
            elseif obj:IsA("ImageButton") then
                local label = string.lower(obj.Name or "")
                local asset = tostring(obj.Image or "")
                local size = obj.AbsoluteSize
                local isFloatingToggle = (label:find("toggle", 1, true) or label:find("mobile", 1, true))
                    and size.X >= 24 and size.X <= 105 and size.Y >= 24 and size.Y <= 105
                    and (asset:find("120164064781939", 1, true))
                if isFloatingToggle then
                    obj.Visible = false
                    obj.Active = false
                end
            elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                local size = obj.AbsoluteSize
                local outerFrame = isOuterFrame(size)
                if outerFrame then
                    local stroke = obj:FindFirstChild("LSS HUB_Stroke")
                    if stroke then stroke:Destroy() end
                end
                if obj.BackgroundTransparency < 1 then
                    if size.X >= 430 and size.Y >= 280 and not outerFrame then
                        obj.BackgroundColor3 = Color3.fromRGB(4, 8, 18)
                        obj.BackgroundTransparency = math.min(obj.BackgroundTransparency, 0.06)
                        LSS HUB_STROKE(obj, 2)
                    elseif size.X >= 110 and size.Y >= 28 and not outerFrame then
                        obj.BackgroundColor3 = Color3.fromRGB(11, 18, 34)
                        obj.BackgroundTransparency = math.max(obj.BackgroundTransparency, 0.11)
                    end
                end
                if obj:IsA("ScrollingFrame") then
                    obj.ScrollBarImageColor3 = Color3.fromRGB(92, 170, 255)
                end
                if not outerFrame and not obj:FindFirstChildOfClass("UICorner") and size.X >= 70 and size.Y >= 24 then
                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(0, size.X >= 430 and 12 or 8)
                    corner.Parent = obj
                end
            end
        end
    end
end

task.spawn(function()
    for _ = 1, 28 do
        pcall(LSS HUB_STYLE_UI)
        task.wait(0.35)
    end
end)

local HAS_CONFIG = type(Library.SaveConfig) == "function"
    and type(Library.LoadConfig) == "function"
    and type(Library.ListConfigs) == "function"
local CONFIG_NAME = "LSS HUB"

local dropdownResync = {}
local function registerResync(handle, applyFn)
    if handle and applyFn then
        table.insert(dropdownResync, function() applyFn(handle:Get()) end)
    end
end
local function ResyncAll()
    for _, fn in ipairs(dropdownResync) do pcall(fn) end
end

local Players             = game:GetService("Players")
local RS                  = game:GetService("ReplicatedStorage")
local ReplicatedStorage   = RS
local RunService          = game:GetService("RunService")
local UserInputService    = game:GetService("UserInputService")
local Workspace           = game:GetService("Workspace")
local Lighting            = game:GetService("Lighting")
local TeleportService     = game:GetService("TeleportService")
local VirtualUser         = game:GetService("VirtualUser")

local LP          = Players.LocalPlayer
local LocalPlayer = LP
local function GetCamera()
    return Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
end

pcall(function()
    local pps = game:GetService("ProximityPromptService")
    track(pps.PromptButtonHoldBegan:Connect(function(prompt, player)
        if player == LP and tostring(prompt) == "CarryAreaEgg" then
            prompt.HoldDuration = 0
        end
    end))
end)

pcall(function()
    local coreGui = game:GetService("CoreGui")
    track(coreGui.ChildAdded:Connect(function(child)
        if child.Name == "PurchasePrompt" then
            task.wait(0.04)
            pcall(function()
                local cancel = child:FindFirstChild("CancelButton", true)
                if cancel and typeof(cancel) == "Instance" and cancel:IsA("GuiButton") then
                    pcall(function() cancel.MouseButton1Click:Fire() end)
                end
            end)
        end
    end))
end)

local function Notify(title, content, kind, dur)
    return
end

local function safeCallback(fn)
    return function(...)
        local ok, err = pcall(fn, ...)
        if not ok then
            pcall(Notify, "LSS HUB", "Error: " .. tostring(err), "Error", 4)
        end
    end
end

local function bypassClientDetections()
    if typeof(filtergc) ~= "function" or typeof(debug) ~= "table" or typeof(debug.getupvalues) ~= "function" then
        return false, "no filtergc"
    end
    local ok, fn = pcall(function()
        return filtergc("function", {
            Constants = { "gmatch", "GetFullName" },
        }, true)
    end)
    if not ok or type(fn) ~= "function" then
        return false, "filter miss"
    end
    local setMeta = (typeof(setrawmetatable) == "function" and setrawmetatable)
        or (typeof(setmetatable) == "function" and setmetatable)
    if not setMeta then
        return false, "no setmeta"
    end
    local blocked = 0
    local okUv, ups = pcall(debug.getupvalues, fn)
    if not okUv or type(ups) ~= "table" then
        return false, "no upvalues"
    end
    for _, tbl in pairs(ups) do
        if typeof(tbl) == "table" then
            local okSet = pcall(setMeta, tbl, {
                __newindex = function() end,
            })
            if okSet then
                blocked = blocked + 1
            end
        end
    end
    return blocked > 0, blocked
end

pcall(bypassClientDetections)

local function ScanGCHeap(step, perChunk)
    local scan = getgc or (debug and debug.getgc)
    if type(scan) ~= "function" then return end
    local ok, objects = pcall(scan, true)
    if not ok or type(objects) ~= "table" then return end
    perChunk = perChunk or 400
    for i = 1, #objects do
        local obj = objects[i]
        objects[i] = nil
        local okStep, stop = pcall(step, obj)
        if okStep and stop == true then return end
        if i % perChunk == 0 then task.wait() end
    end
end

local AcSlices = {}
do

    function AcSlices.FreezeTables()
        local setmeta = setrawmetatable or setmetatable
        local getmeta = getrawmetatable or getmetatable
        if not setmeta then return end
        ScanGCHeap(function(obj)
            if typeof(obj) ~= "table" or (getmeta and getmeta(obj)) then return end
            local mainrun = false
            for _, v in pairs(obj) do
                if v == obj then
                    mainrun = true
                    break
                end
            end
            if not mainrun then return end
            for _, v in pairs(obj) do
                if typeof(v) == "number" and v >= 1 and v <= 3 and obj[v] == nil then
                    pcall(setmeta, obj, { __newindex = function() end })
                    break
                end
            end
        end)
    end

    function AcSlices.WipeUGI()
        local getconstants = getconstants or (debug and debug.getconstants)
        local setconstant = setconstant or (debug and debug.setconstant)
        local islclosure = islclosure or function(Function)
            return not pcall(setfenv, getfenv(Function))
        end
        if not (getconstants and setconstant and debug and debug.info) then return end
        ScanGCHeap(function(Function)
            if typeof(Function) ~= "function" or not islclosure(Function) then return end
            local ok, Source = pcall(debug.info, Function, "s")
            if not ok or type(Source) ~= "string" then return end
            if not Source:find("ReplicatedFirst", 1, true) or not Source:find("UGI", 1, true) then return end
            local okC, Constants = pcall(getconstants, Function)
            if not okC or type(Constants) ~= "table" then return end
            for Index, Constant in next, Constants do
                if type(Constant) == "string" and Constant == "Humanoid" then
                    pcall(setconstant, Function, Index, "")
                end
            end
        end)
    end

    function AcSlices.ScrubX14()
        local getconstants = getconstants or (debug and debug.getconstants)
        local islclosure = islclosure or function(fn) return not pcall(setfenv, getfenv(fn)) end
        local HookFn = hookfunction or replaceclosure or hookfunc
        if not (getconstants and HookFn and debug and debug.getstack and debug.setstack) then return end
        ScanGCHeap(function(fn)
            if typeof(fn) ~= "function" or not islclosure(fn) then return end
            local ok, consts = pcall(getconstants, fn)
            if not ok or type(consts) ~= "table" or not table.find(consts, "X-14") then return end
            local cb = nil
            pcall(function()
                cb = HookFn(fn, function(...)
                    local stack = debug.getstack(1)
                    if type(stack) == "table" then
                        for idx, val in pairs(stack) do
                            if val == "X-14" then
                                pcall(debug.setstack, 1, idx, nil)
                            end
                        end
                    end
                    if cb then return cb(...) end
                end)
            end)
        end)
    end

    function AcSlices.SanitizeState()
        local islclosure = islclosure or function(v) return not pcall(setfenv, getfenv(v)) end
        local getupvalues = getupvalues or (debug and debug.getupvalues)
        local getupvalue = getupvalue or (debug and debug.getupvalue)
        local setupvalue = setupvalue or (debug and debug.setupvalue)
        local clonefunction = clonefunction or function(f) return function(...) return f(...) end end
        if not (getupvalues and getupvalue and setupvalue) then return end
        ScanGCHeap(function(v)
            if typeof(v) ~= "function" or not islclosure(v) then return end
            local ok, upvs = pcall(getupvalues, v)
            if not ok or type(upvs) ~= "table" or #upvs ~= 19 then return end
            local ok2, u2 = pcall(getupvalue, v, 2)
            if not ok2 or typeof(u2) ~= "function" then return end
            local old = clonefunction(u2)
            pcall(setupvalue, v, 2, function(a, b)
                if b and typeof(b) == "table" then
                    pcall(setmetatable, b, {})
                end
                return old(a, b)
            end)
        end)
    end
end

task.spawn(function()
    pcall(AcSlices.FreezeTables)
    task.wait()
    pcall(AcSlices.WipeUGI)
    task.wait()
    pcall(AcSlices.ScrubX14)
    task.wait()
    pcall(AcSlices.SanitizeState)
end)

local function findChar() return LP.Character end
local function findHum()
    local ch = LP.Character
    return ch and ch:FindFirstChildOfClass("Humanoid")
end
local function findHRP()
    local ch = LP.Character
    return ch and (ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart or ch:FindFirstChildWhichIsA("BasePart"))
end

local GetCharacter = findChar
local GetHumanoid  = findHum
local GetHRP       = findHRP

local function GetRootCFrame()
    local hrp = findHRP()
    return hrp and hrp.CFrame
end

local bxor = bit32.bxor
local unpack = table.unpack

local function isGuid(n)
    return #n==36 and n:sub(9,9)=="-" and n:sub(14,14)=="-" and n:sub(19,19)=="-" and n:sub(24,24)=="-" and n:gsub("-",""):match("^%x+$")~=nil
end

local remoteSet, anyRemote = {}, nil

local function scanRemotes()
    for _, s in ipairs(game:GetChildren()) do
        local ok, list = pcall(s.GetDescendants, s)
        if ok and list then
            for _, o in ipairs(list) do
                if o:IsA("RemoteEvent") and isGuid(o.Name) then
                    remoteSet[o] = true
                    anyRemote = anyRemote or o
                end
            end
        end
    end
end

scanRemotes()

local function parseCounter(v)
    if type(v) ~= "string" then return end
    local n = v:match("^X%-(%d+)$")
    return n and tonumber(n)
end

local function looksLikeState(t, r)
    if type(t) ~= "table" then return false end
    local hR, hM = false, false
    local ok = pcall(function()
        for _, v in pairs(t) do
            if v == r then hR = true
            elseif type(v) == "string" and v:match("^X%-%d+$") then hM = true end
        end
    end)
    return ok and hR and hM
end

local function findState(r)
    for l=2,24 do
        local _, fn = pcall(debug.info, l, "f")
        if type(fn) == "function" then
            local _, ups = pcall(debug.getupvalues, fn)
            if type(ups) == "table" then
                for _, v in pairs(ups) do
                    if looksLikeState(v, r) then return v end
                    if type(v) == "table" then
                        local nested
                        pcall(function()
                            for _, x in pairs(v) do
                                if looksLikeState(x, r) then nested = x; return end
                            end
                        end)
                        if nested then return nested end
                    end
                end
            end
        end
    end
end

local function mapState(st, a1, a2)
    local m = {}
    for k, v in pairs(st) do
        if type(v) == "string" then
            if v:match("^X%-%d+$") then m.marker = m.marker or k
            elseif a1 and v == a1 then m.arg1 = m.arg1 or k
            elseif a2 and v == a2 then m.arg2 = m.arg2 or k end
        end
    end
    return m
end

local model = nil

local function digits(n)
    n = n % 1000
    return math.floor(n/100), math.floor(n/10)%10, n%10
end

local function encode(m, c)
    local d1, d2, d3 = digits(c)
    return m.prefix .. string.char(bxor(d1, m.k1), bxor(d2, m.k2), bxor(d3, m.k3))
end

local function learn(r, a1, a2)
    local st = findState(r)
    if not st then return end
    local map = mapState(st, a1, a2)
    if not map.marker then return end
    local c = parseCounter(rawget(st, map.marker))
    if not c then return end
    local d1, d2, d3 = digits(c)
    local m = {
        state = st, map = map, remote = r,
        prefix = a1:sub(1, 9),
        k1 = bxor(a1:byte(10), d1),
        k2 = bxor(a1:byte(11), d2),
        k3 = bxor(a1:byte(12), d3),
        offset = c - os.time(),
        arg2 = a2
    }
    if encode(m, c) == a1 then return m end
end

local function liveCounter(m)
    if m.state and m.map.marker then
        local _, raw = pcall(rawget, m.state, m.map.marker)
        local c = parseCounter(raw)
        if c and math.abs((c - os.time()) - m.offset) <= 5 then
            return c
        end
    end
    return os.time() + m.offset
end

local function refreshArg2(m)
    if m.state and m.map.arg2 then
        local _, v = pcall(rawget, m.state, m.map.arg2)
        if type(v) == "string" then m.arg2 = v end
    end
    return m.arg2
end

local HookFn = hookfunction or replaceclosure or hookfunc or detour_function

if anyRemote and HookFn then
    local oldFire
    oldFire = HookFn(anyRemote.FireServer, function(self, ...)
        local args = table.pack(...)
        if not remoteSet[self] then
            return oldFire(self, unpack(args, 1, args.n))
        end

        local a1 = args[1]

        if type(a1) == "string" and #a1 == 12 then
            if not model then
                model = learn(self, a1, args[2])
            else
                local c = parseCounter(rawget(model.state, model.map.marker))
                if c and encode(model, c) ~= a1 then
                    local m = learn(self, a1, args[2])
                    if m then m.spoofed = model.spoofed; model = m end
                end
            end
            return oldFire(self, unpack(args, 1, args.n))
        end

        if model and type(a1) == "string" and #a1 == 4 then
            local c = liveCounter(model)
            args[1] = encode(model, c)
            args[2] = refreshArg2(model)
            model.spoofed = (model.spoofed or 0) + 1
            return oldFire(self, unpack(args, 1, math.max(args.n, 2)))
        end

        return oldFire(self, unpack(args, 1, args.n))
    end)
end

task.spawn(function()
    while not HUB.dead do
        task.wait(10)
        local alive = false
        for r in pairs(remoteSet) do
            if r:IsDescendantOf(game) then alive = true; break end
        end
        if not alive then
            table.clear(remoteSet)
            anyRemote = nil
            model = nil
            scanRemotes()
        end
    end
end)

task.spawn(function()
    if not (getgc or (debug and debug.getgc)) then return end
    local st = nil
    local misses = 0

    local function findIntegrityTable()
        local found = nil
        ScanGCHeap(function(o)
            if found then return true end
            if type(o) ~= "table" then return end
            local hit = false
            pcall(function()
                hit = (rawget(o, "ValidationLocked") ~= nil and rawget(o, "Evidence") ~= nil)
                    or (rawget(o, "ThreatLevel") ~= nil and rawget(o, "LastObservedSample") ~= nil)
            end)
            if hit then
                found = o
                return true
            end
        end, 250)
        return found
    end

    track(LP.CharacterAdded:Connect(function()
        task.wait(1)
        st = findIntegrityTable()
    end))

    while not HUB.dead do
        if not st then
            st = findIntegrityTable()
            if not st then
                misses = misses + 1
                local waitFor = math.min(5 * (2 ^ math.min(misses - 1, 3)), 30)
                local slept = 0
                while slept < waitFor and not HUB.dead do
                    task.wait(0.5)
                    slept = slept + 0.5
                end
            elseif misses > 0 then
                misses = 0
            end
        end

        if st then
            pcall(function()
                local ev = rawget(st, "Evidence")
                if type(ev) == "table" then
                    if (tonumber(ev.Speed)    or 0) > 0 then rawset(ev, "Speed", 0) end
                    if (tonumber(ev.Teleport) or 0) > 0 then rawset(ev, "Teleport", 0) end
                    if (tonumber(ev.Flight)   or 0) > 0 then rawset(ev, "Flight", 0) end
                end
                if rawget(st, "ThreatLevel") ~= "Trusted" then rawset(st, "ThreatLevel", "Trusted") end
                if rawget(st, "ValidationLocked") == true then rawset(st, "ValidationLocked", false) end
                if rawget(st, "FirstSuspiciousAt") ~= nil then rawset(st, "FirstSuspiciousAt", nil) end
                if rawget(st, "KickQueued") == true then rawset(st, "KickQueued", false) end
                if rawget(st, "TamperScore") ~= nil then rawset(st, "TamperScore", 0) end
                if rawget(st, "InvalidHeartbeatCount") ~= nil then rawset(st, "InvalidHeartbeatCount", 0) end

                local los = rawget(st, "LastObservedSample")
                if los ~= nil then
                    if rawget(st, "LastGameplayTrustedSample") == nil then rawset(st, "LastGameplayTrustedSample", los) end
                    if rawget(st, "LastValidatedSample") == nil then rawset(st, "LastValidatedSample", los) end
                    if rawget(st, "LastValidatedGroundedSample") == nil then rawset(st, "LastValidatedGroundedSample", los) end
                    if rawget(st, "LastConfirmedGroundSample") == nil then rawset(st, "LastConfirmedGroundSample", los) end
                    if rawget(st, "LastGoodSample") == nil then rawset(st, "LastGoodSample", los) end
                end
            end)
        end
        task.wait(0.2)
    end
end)

local EggState, PlotState, AreasData, RarityData, AssetsData, EggToolDisplay, AreaEggSlotIdentity
pcall(function() EggState = require(RS.Client.EggState) end)
pcall(function() PlotState = require(RS.Client.PlotState) end)
pcall(function() AreasData = require(RS.Data.Areas) end)
pcall(function() RarityData = require(RS.Data.Rarity) end)
pcall(function() AssetsData = require(RS.Data.Assets) end)
local SaveModule
pcall(function() SaveModule = require(RS.Shared.Save) end)
pcall(function() EggToolDisplay = require(RS.Shared.Eggs.EggToolDisplay) end)
pcall(function()
    AreaEggSlotIdentity = (RS:FindFirstChild("Shared") and RS.Shared:FindFirstChild("Util") and require(RS.Shared.Util.AreaEggSlotIdentity))
        or (RS:FindFirstChild("Util") and require(RS.Util.AreaEggSlotIdentity))
        or (RS:FindFirstChild("Shared") and RS.Shared:FindFirstChild("Utils") and require(RS.Shared.Utils.AreaEggSlotIdentity))
end)

local function GetNetRemote(name)
    local net = RS:FindFirstChild("Packages") and RS.Packages:FindFirstChild("Networking")
    return net and net:FindFirstChild(name)
end

local function GetLocalSlot()
    if PlotState and PlotState.ResolveLocalSlot then
        local ok, slot = pcall(PlotState.ResolveLocalSlot)
        if ok and slot then return slot end
    end
    return 1
end

local function GetLocalPlotCenter()
    local plotObj = PlotState and PlotState.ResolvePlot and PlotState.ResolvePlot()
    local pt = plotObj and plotObj.CenterPoint and (typeof(plotObj.CenterPoint) == "Vector3" and plotObj.CenterPoint or (plotObj.CenterPoint:IsA("BasePart") and plotObj.CenterPoint.Position))
    if pt then
        return Vector3.new(pt.X, math.max(pt.Y, 70.4), pt.Z), CFrame.new(pt.X, math.max(pt.Y, 70.4), pt.Z)
    end
    return Vector3.new(464.7, 70.4, -364.0), CFrame.new(464.7, 70.4, -364.0)
end

local MAIN_ROAD_Z = -364.5

local avoidTrapsEnabled       = true

local function SafeTeleport(targetPos)
    local root = findHRP()
    if not root or not targetPos then return false end
    root.CFrame = CFrame.new(targetPos.X, math.max(targetPos.Y, 70.0), targetPos.Z)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    return true
end

local function NeutralizeTraps()
    local debris = Workspace:FindFirstChild("__DEBRIS")
    if not debris then return end
    for _, d in ipairs(debris:GetChildren()) do
        if d.Name == "PlayerTrap" and d:GetAttribute("Owner") ~= LP.Name then
            if d:IsA("BasePart") then
                d.CanTouch = false
                d.CanQuery = false
            end
            for _, c in ipairs(d:GetChildren()) do
                if c:IsA("BasePart") then
                    c.CanTouch = false
                    c.CanQuery = false
                    if c.Name == "Hitbox" then
                        c.CFrame = CFrame.new(0, -999, 0)
                    end
                end
            end
            local tt = d:FindFirstChildWhichIsA("TouchTransmitter", true)
            if tt then pcall(function() tt:Destroy() end) end
        end
    end
end

local function MoveToPoint(target, speed, easeOut)
    local hrp = findHRP()
    if not hrp or not target then return false end

    local start = hrp.Position
    local dist = (target - start).Magnitude
    if dist < 1.0 then
        hrp.CFrame = CFrame.new(target.X, math.max(target.Y, 70.0), target.Z)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        return true
    end

    speed = math.clamp(tonumber(speed) or tonumber(glideSpeed) or 850, 50, 850)

    local t0 = os.clock()
    local totalDist = dist
    while not HUB.dead do
        local dt = RunService.Heartbeat:Wait()
        local curPos = hrp.Position
        local toTarget = target - curPos
        local remain = toTarget.Magnitude
        if remain < 1.0 then break end
        local stepSpeed = speed
        if easeOut then
            local progress = 1 - math.clamp(remain / totalDist, 0, 1)
            stepSpeed = math.max(speed * (1 - progress * 0.8), 35)
        end
        local step = math.min(stepSpeed * dt, remain)
        local dir = toTarget.Unit
        local nextPos = curPos + dir * step
        hrp.CFrame = CFrame.lookAt(nextPos, nextPos + dir)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if os.clock() - t0 > (totalDist / 50 + 5) then break end
    end

    hrp.CFrame = CFrame.new(target.X, math.max(target.Y, 70.0), target.Z)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    return true
end

local SAFE_BOUNDARY_X = 580
local SAFE_ZONE_SPEED = 245

local function TravelRoadPath(targetPos, speed, isApproach)
    local hrp = findHRP()
    if not hrp or not targetPos then return false end
    if avoidTrapsEnabled then pcall(NeutralizeTraps) end

    local startPos = hrp.Position
    local safeY = math.max(startPos.Y, targetPos.Y, 70.4)
    local isReturningToBase = (targetPos.X < 560)

    if isReturningToBase and startPos.X > SAFE_BOUNDARY_X then
        local p1 = Vector3.new(startPos.X, safeY, MAIN_ROAD_Z)
        MoveToPoint(p1, speed, false)

        local pSafeApproach = Vector3.new(SAFE_BOUNDARY_X, safeY, MAIN_ROAD_Z)
        MoveToPoint(pSafeApproach, speed, false)

        local pBaseRoad = Vector3.new(targetPos.X, safeY, MAIN_ROAD_Z)
        MoveToPoint(pBaseRoad, SAFE_ZONE_SPEED, false)

        local pPen = targetPos + Vector3.new(0, 1.2, 0)
        MoveToPoint(pPen, SAFE_ZONE_SPEED, isApproach == true)
        return true
    else
        local p1 = Vector3.new(startPos.X, safeY, MAIN_ROAD_Z)
        local p2 = Vector3.new(targetPos.X, safeY, MAIN_ROAD_Z)
        local p3 = targetPos + Vector3.new(0, 1.2, 0)

        MoveToPoint(p1, speed, false)
        MoveToPoint(p2, speed, false)
        MoveToPoint(p3, speed, isApproach == true)
        return true
    end
end

local RARITY_SCORE_MAP = {
    ["Light & Dark"]    = 1300,
    ["Titan"]           = 1100,
    ["Divine"]          = 1000,
    ["Transcendent"]    = 1000,
    ["Superior"]        = 1000,
    ["Eternal"]         = 900,
    ["Limited"]         = 900,
    ["Secret"]          = 800,
    ["Exotic"]          = 800,
    ["Cosmic"]          = 700,
    ["Exclusive"]       = 700,
    ["Admin"]           = 700,
    ["Mythic"]          = 600,
    ["Mythical"]        = 600,
    ["Prismatic"]       = 600,
    ["Rainbow"]         = 600,
    ["Squishy God"]     = 600,
    ["BrainrotGod"]     = 600,
    ["Legendary"]       = 500,
    ["Epic"]            = 400,
    ["Rare"]            = 300,
    ["SuperRare"]       = 200,
    ["Celestial"]       = 200,
    ["Uncommon"]        = 200,
    ["Basic"]           = 100,
    ["Common"]          = 100,
}

local AREA_COORDINATES = {
    ["Base / Plot"]      = Vector3.new(491.7, 70.4, -364.4),
    ["Stands & Shops"]   = Vector3.new(539.5, 68.0, -364.5),
    ["Forest"]           = Vector3.new(596.0, 68.0, -328.0),
    ["Lake"]             = Vector3.new(744.0, 68.5, -408.0),
    ["Desert"]           = Vector3.new(948.0, 69.5, -323.0),
    ["Jungle"]           = Vector3.new(1188.0, 68.5, -408.0),
    ["Snow"]             = Vector3.new(1492.0, 69.0, -315.0),
    ["Volcano"]          = Vector3.new(1882.0, 68.0, -398.0),
    ["Abyss Ocean"]      = Vector3.new(2280.0, 68.0, -326.0),
    ["Prehistoric"]      = Vector3.new(2812.0, 69.0, -398.0),
    ["Cosmic"]           = Vector3.new(3390.0, 68.0, -324.0),
    ["Cherry Blossom"]   = Vector3.new(4028.0, 68.5, -396.0),
    ["Titan Temple"]     = Vector3.new(4796.0, 69.5, -328.0),
    ["Light Dark"]       = Vector3.new(5660.0, 70.0, -331.0),
    ["Dragon Event"]     = Vector3.new(539.5, 68.0, -318.0),
}

local AREA_NAMES = {
    "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano",
    "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple",
    "Light Dark",
}

local RARITY_NAMES = {
    "Common", "Uncommon", "Rare", "Epic", "Legendary",
    "Myhtic", "Cosmic", "Secret", "Eternal", "Divine"
}

local MUTATION_FILTERS = {
    "Normal Only", "Mutated Only", "Parasite / Infested", "Rainbow Only", "Gold Only", "Silver Only", "Monstrous"
}

local autoStealEnabled          = false
local rareEggHunter             = true
local stealBigEggsOnly          = false
local selectedStealRarities     = {}
local selectedStealAreas        = {}
local selectedMutationTypes     = {}
local stealDelay                = 0.75
local glideSpeed                = 850
local ignoredEggs               = {}

local savedReturnCFrame         = nil

local autoHatchEnabled          = false
local autoPlantEnabled          = false
local hatchCheckDelay           = 2.0

local autoUpgradeBase           = false
local autoUpgradeTreadmill      = false
local autoTrainSpeed            = false
local autoBuyTrails             = false
local autoEquipBestPets         = false
local autoClaimRewards          = false

local autoSellPets              = false
local autoSellEggs              = false
local selectedSellPetRarities   = {}
local selectedSellEggRarities   = {}

local DEFAULT_LOW_TIER_SELL = {
    ["Common"] = true, ["Uncommon"] = true, ["Rare"] = true,
    ["Epic"] = true, ["Legendary"] = true, ["Mythic"] = true,
}
local SELL_REQUEST_DELAY = 0.1
local function getSellRarityFilter(selected)
    if not selected or next(selected) == nil then return DEFAULT_LOW_TIER_SELL end
    return selected
end

local noKnockbackEnabled        = true
local batAuraEnabled            = false
local batAuraRadius             = 20
local batAuraDelay              = 0.2
local antiRagdollEnabled        = true

local function GetEggRarityInfo(egg)
    if not egg then return "Common", 100 end

    if egg.Rarity then
        local r = egg.Rarity
        local name = type(r) == "table" and (r.DisplayName or r._id or r.Name) or tostring(r)
        local score = RARITY_SCORE_MAP[name] or (type(r) == "table" and tonumber(r.RarityNumber) and r.RarityNumber * 100) or 100
        return name, score
    end

    local cat = egg.AssetCategory or egg.Category or egg.Name
    if cat and AssetsData then
        local assetsDir = AssetsData.Directory or AssetsData
        local aInfo = assetsDir[cat]
        if aInfo and aInfo.Rarity then
            local r = aInfo.Rarity
            local name = type(r) == "table" and (r.DisplayName or r._id or r.Name) or tostring(r)
            local score = RARITY_SCORE_MAP[name] or (type(r) == "table" and tonumber(r.RarityNumber) and r.RarityNumber * 100) or 100
            return name, score
        end
    end

    local areaData = AreasData and (AreasData.Directory or AreasData) and (AreasData.Directory or AreasData)[egg.AreaId]
    local rarity = areaData and areaData.Rarity
    local rarityId = (type(rarity) == "table" and (rarity._id or rarity.DisplayName or rarity.Name)) or (type(rarity) == "string" and rarity) or "Common"
    local raritiesTable = RarityData and (RarityData.Rarities or RarityData) or {}
    local rInfo = raritiesTable[rarityId] or {}
    local rarityDisplayName = (type(rInfo) == "table" and (rInfo.DisplayName or rInfo._id)) or (type(rarity) == "table" and rarity.DisplayName) or rarityId or "Common"
    local baseScore = RARITY_SCORE_MAP[rarityDisplayName] or RARITY_SCORE_MAP[rarityId] or (type(rarity) == "table" and tonumber(rarity.RarityNumber) and rarity.RarityNumber * 100) or 100
    return rarityDisplayName, baseScore
end

local function isRarityAllowed(rarityName, filter)
    if not filter or type(filter) ~= "table" then return true end
    local count = 0
    for _ in pairs(filter) do count = count + 1 end
    if count == 0 then return true end

    if filter[rarityName] == true then return true end
    local rLower = string.lower(tostring(rarityName))
    if rLower == "mythic" then rLower = "myhtic" end
    for k, v in pairs(filter) do
        if type(v) == "string" then
            local vLower = string.lower(v)
            if vLower == "mythic" then vLower = "myhtic" end
            if vLower == rLower then return true end
        elseif type(k) == "string" then
            local kLower = string.lower(k)
            if kLower == "mythic" then kLower = "myhtic" end
            if kLower == rLower and v == true then return true end
        end
    end
    return false
end

local function ResolveAreaId(name)
    local dir = AreasData and AreasData.Directory
    if type(dir) ~= "table" then return tostring(name) end
    local lower = string.lower(tostring(name))
    for id, info in pairs(dir) do
        if string.lower(tostring(id)) == lower then return id end
        if type(info) == "table" and info.DisplayName
            and string.lower(tostring(info.DisplayName)) == lower then
            return id
        end
    end
    return tostring(name)
end

local function isAreaAllowed(areaId, filter)
    if not filter or type(filter) ~= "table" then return true end
    local count = 0
    for _ in pairs(filter) do count = count + 1 end
    if count == 0 then return true end

    if filter[areaId] == true then return true end
    local aLower = string.lower(tostring(areaId))
    for k, v in pairs(filter) do
        if type(v) == "string" and (string.lower(v) == aLower
            or string.lower(tostring(ResolveAreaId(v))) == aLower) then
            return true
        elseif type(k) == "string" and string.lower(k) == aLower and v == true then
            return true
        end
    end
    return false
end

local function isMutationAllowed(muts, record, filter)
    local isParasite = (record and record.HasParasite == true)
        or (type(muts) == "table" and (table.find(muts, "Parasite") or table.find(muts, "Monstrous")))
        or (record and (record.BaseMutation == "Parasite" or record.BaseMutation == "Monstrous"))

    if not filter or type(filter) ~= "table" then return true end
    local count = 0
    for _ in pairs(filter) do count = count + 1 end
    if count == 0 then return true end

    local hasMut = type(muts) == "table" and #muts > 0
    local allowed = false
    for _, opt in pairs(filter) do
        if type(opt) == "string" then
            if opt == "Normal Only" and not hasMut and not isParasite then
                allowed = true
            elseif opt == "Mutated Only" and (hasMut or isParasite) then
                allowed = true
            elseif (opt == "Parasite / Infested" or opt == "Monstrous") and isParasite then
                allowed = true
            elseif opt == "Silver Only" and type(muts) == "table" and table.find(muts, "Silver") then
                allowed = true
            elseif opt == "Gold Only" and type(muts) == "table" and (table.find(muts, "Gold") or table.find(muts, "Golden")) then
                allowed = true
            elseif opt == "Rainbow Only" and type(muts) == "table" and table.find(muts, "Rainbow") then
                allowed = true
            end
        end
    end
    return allowed
end

local function isBigEgg(record)
    if not record then return false end
    local scale = tonumber(record.AssetScale) or 1
    local nestScale = tonumber(record.NestScale) or 1
    return scale >= 1.35 or nestScale >= 1.0
end

local phucEggMoney

function HUB.V44.ConfirmedPerSecond(record)
    if type(record) ~= "table" then return nil end
    local fields = {"perSecond", "PerSecond", "perSecondDisplay", "IncomePerSecond", "EarningsPerSecond"}
    for _, name in ipairs(fields) do
        local number = tonumber(record[name])
        if number and number >= 0 then return number end
    end
    for _, key in ipairs({"Configuration", "Stats", "PetData"}) do
        local stats = record[key]
        if type(stats) == "table" then
            for _, name in ipairs(fields) do
                local number = tonumber(stats[name])
                if number and number >= 0 then return number end
            end
        end
    end
    return nil
end

local function GetMatchingFieldEggs(areasFilter, raritiesFilter, mutationsFilter)
    if not EggState or not EggState.ReadFieldEggs then return {} end
    local ok, snapshot = pcall(EggState.ReadFieldEggs)
    if not ok or not snapshot or not snapshot.Records then return {} end

    local matched = {}
    for _, record in ipairs(snapshot.Records) do
        if record.State == "Slot" and record.BoundsCFrame then
            local isIgnored = ignoredEggs[record.Uid] and (os.clock() - ignoredEggs[record.Uid] < 2.5)
            if not isIgnored and (not stealBigEggsOnly or isBigEgg(record))
                and (not HUB.V44.only100m or ((HUB.V44.ConfirmedPerSecond(record) or -1) >= 100000000)) then
                local areaOk = isAreaAllowed(record.AreaId, areasFilter)
                local rarityName, baseScore = GetEggRarityInfo(record)
                local rarityOk = isRarityAllowed(rarityName, raritiesFilter)
                local muts = record.Mutations or {}
                local mutOk = isMutationAllowed(muts, record, mutationsFilter)

                if areaOk and rarityOk and mutOk then
                    local mutBonus = 0
                    for _, m in ipairs(muts) do
                        if m == "Rainbow" then mutBonus = mutBonus + 35
                        elseif m == "Gold" or m == "Golden" then mutBonus = mutBonus + 20
                        elseif m == "Silver" then mutBonus = mutBonus + 10 end
                    end

                    if record.HasParasite == true or (type(muts) == "table" and (table.find(muts, "Parasite") or table.find(muts, "Monstrous"))) then
                        mutBonus = mutBonus + 800
                    end

                    if isBigEgg(record) then
                        mutBonus = mutBonus + 600
                    end
                    local rarityScore = baseScore + mutBonus
                    local moneyScore = 0
                    if phucEggMoney then
                        local okMoney, value = pcall(phucEggMoney, record)
                        if okMoney then moneyScore = tonumber(value) or 0 end
                    end

                    table.insert(matched, {
                        record = record,
                        rarity = rarityName,
                        score = moneyScore,
                        money = moneyScore,
                        rarityScore = rarityScore
                    })
                end
            end
        end
    end

    if #matched > 1 and rareEggHunter then
        table.sort(matched, function(a, b)
            local moneyA = tonumber(a.money or a.score) or 0
            local moneyB = tonumber(b.money or b.score) or 0
            if moneyA == moneyB then
                return (tonumber(a.rarityScore) or 0) > (tonumber(b.rarityScore) or 0)
            end
            return moneyA > moneyB
        end)
    end

    return matched
end

local function EnsureSavedReturnPosition()
    if not savedReturnCFrame then
        local hrp = findHRP()
        if hrp then
            savedReturnCFrame = hrp.CFrame
        end
    end
end

local function isPlayerCarryingEgg()
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    local dropGui = pg and pg:FindFirstChild("DropHeldEgg")
    if dropGui and dropGui.Enabled == true then
        return true
    end

    local char = LP.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Model") and (t.Name:lower():find("egg") or t:GetAttribute("Uid") or t:GetAttribute("AssetCategory")) then
                return true
            end
            if t:IsA("Tool") then
                if EggToolDisplay and EggToolDisplay.IsEggTool and EggToolDisplay.IsEggTool(t) then
                    return true
                end
                if t:GetAttribute("IsEgg") == true or t:GetAttribute("Uid") ~= nil or t:GetAttribute("AssetCategory") ~= nil then
                    return true
                end
                local tName = t.Name:lower()
                if tName:find("egg") or (tName ~= "bat" and tName ~= "defaulttool" and not tName:find("bat") and not tName:find("slap") and not tName:find("coil") and not tName:find("potion") and not tName:find("lantern")) then
                    return true
                end
            end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and EggToolDisplay and EggToolDisplay.IsEggTool and EggToolDisplay.IsEggTool(t) then
                return true
            end
        end
    end
    return false
end

local function PlantAllCarriedEggsInPen()
    if ImportedSteal and ImportedSteal.busy then return 0 end
    if HUB.V44.PlaceNow then return HUB.V44.PlaceNow() end
    local plotObj = PlotState and PlotState.ResolvePlot and PlotState.ResolvePlot()
    local plotCenter = plotObj and plotObj.CenterPoint and plotObj.CenterPoint.Position or Vector3.new(464.7, 68.2, -364.0)

    local toolsToPlant = {}
    for _, t in ipairs(LP.Character:GetChildren()) do
        if t:IsA("Tool") and EggToolDisplay and EggToolDisplay.IsEggTool and EggToolDisplay.IsEggTool(t) then
            local uid = EggToolDisplay.GetToolUid(t)
            if uid then table.insert(toolsToPlant, uid) end
        end
    end
    for _, t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") and EggToolDisplay and EggToolDisplay.IsEggTool and EggToolDisplay.IsEggTool(t) then
            local uid = EggToolDisplay.GetToolUid(t)
            if uid then table.insert(toolsToPlant, uid) end
        end
    end

    local plantedCount = 0
    for _, eggUid in ipairs(toolsToPlant) do
        for attempt = 1, 3 do
            local offset = CFrame.new(math.random(-6, 6), 0, math.random(-6, 6))
            local ok, res = pcall(function()
                if EggState and EggState.PlantEgg then
                    return EggState.PlantEgg(eggUid, offset)
                end
                return false
            end)
            if ok and res then
                plantedCount = plantedCount + 1
                break
            end
            task.wait(0.1)
        end
    end
    return plantedCount
end

local ImportedSteal={engine=nil,busy=false,generation=0}
local function createImportedStealEngine()
    local transferTarget, transferCollected, transferRunning = nil,false,false
    local function transferLog(...)
        local values=table.pack(...)
        for i=1,values.n do values[i]=tostring(values[i]) end
        local text=table.concat(values," ",1,values.n)
        ImportedSteal.status=text
        warn("[LSS HUB / steal.lua] "..text)
    end
local Players=game:GetService( "Players" )
local Workspace=game:GetService( "Workspace" )
local RunService=game:GetService( "RunService" )
local TweenService=game:GetService( "TweenService" )
local UserInputService=game:GetService( "UserInputService" )
local ReplicatedStorage=game:GetService( "ReplicatedStorage" )
local ProximityPromptService=game:GetService( "ProximityPromptService" )
local HttpService=game:GetService( "HttpService" )
local TeleportService=game:GetService( "TeleportService" )
local LocalPlayer=Players.LocalPlayer
local Window=nil
local currentLang="EN"
local executorCheckCaller=typeof(checkcaller)=="function" and checkcaller or function() return false end
local safeNewCClosure=typeof(newcclosure)=="function" and newcclosure or function(fn) return fn end
local PromptService=game:GetService( "ProximityPromptService" )pcall(function(...) PromptService.PromptButtonHoldBegan :Connect(function(e,...) pcall(function(...)
            if typeof(fireproximityprompt)== "function" then
                fireproximityprompt(e)
            end
        end
        )
    end
    )
end
)
local logInfo=function(...) transferLog(...) end
local logWarn=function(...) transferLog(...) end
local EggState=nil pcall(function(...) EggState=require((ReplicatedStorage:WaitForChild( "Client" , 5 )):WaitForChild( "EggState" , 5 ))
end
)
if not EggState then
    pcall(function(...) EggState=require(ReplicatedStorage.Client.EggState )
    end
    )
end
local AssetItems=nil pcall(function(...) AssetItems=require(((ReplicatedStorage:WaitForChild( "Shared" , 5 )):WaitForChild( "Util" , 5 )):WaitForChild( "AssetItems" , 5 ))
end
)
if not AssetItems then
    pcall(function(...) AssetItems=require(ReplicatedStorage.Shared.Util .AssetItems )
    end
    )
end
local RemotesModule=nil pcall(function(...) RemotesModule=require((ReplicatedStorage:WaitForChild( "Shared" , 5 )):WaitForChild( "Remotes" , 5 ))
end
)
if not RemotesModule then
    pcall(function(...) RemotesModule=require(ReplicatedStorage.Shared.Remotes )
    end
    )
end
local function findRemote(e,r,...)
    local y=(ReplicatedStorage:FindFirstChild( "Packages" )and ReplicatedStorage.Packages :FindFirstChild( "Networking" ))or ReplicatedStorage:FindFirstChild( "Network" )or ReplicatedStorage
    local u=y:FindFirstChild(e)or ReplicatedStorage:FindFirstChild(e)
    if u then
        return u
    end
    local w=y:FindFirstChild(e, true )or ReplicatedStorage:FindFirstChild(e, true )
    if w then
        return w
    end
    if r then
        local e=y:FindFirstChild(r)or ReplicatedStorage:FindFirstChild(r)
        if e then
            return e
        end
        local u=y:FindFirstChild(r, true )or ReplicatedStorage:FindFirstChild(r, true )
        if u then
            return u
        end
    end
    local k=string.match (e, "[^/]+$" )
    if k then
        local e=y:FindFirstChild(k, true )or ReplicatedStorage:FindFirstChild(k, true )
        if e then
            return e
        end
    end
    return nil
end

local AskPlaceEggRemote=findRemote( "RF/EggWorld/AskPlaceEgg" , "AskPlaceEgg" )
local AskLiveSnapshotRemote=findRemote( "RF/EggWorld/AskLiveSnapshot" , "AskLiveSnapshot" )
local AskPlotStateRemote=findRemote( "RF/Homestead/AskState" , "RF/Plots/AskState" )or findRemote( "AskState" )
local AskFieldEggCarryRemote=findRemote( "RF/EggWorld/AskFieldEggCarry" , "AskFieldEggCarry" )
local AskFieldEggSnapshotRemote=findRemote( "RF/EggWorld/AskFieldEggSnapshot" , "AskFieldEggSnapshot" )or findRemote( "Eggs: RequestAreaEggSnapshot" , "RequestAreaEggSnapshot" )
local AskHatchRemote=findRemote( "RF/EggWorld/AskHatch" , "AskHatch" )or findRemote( "Eggs: RequestHatchEgg" )
local AskFinishHatchRemote=findRemote( "RF/EggWorld/AskFinishHatch" , "AskFinishHatch" )or findRemote( "Eggs: RequestCompleteHatchEgg" )
local AskDoffTreadmillRemote=findRemote( "RF/Treadmill/AskDoff" , "AskDoff" )
local AskSkipGrowthRemote=findRemote( "RF/EggWorld/AskSkipGrowth" , "AskSkipGrowth" )
local ForestStrikeRemote=findRemote( "RE/GuardPatrol/ForestStrike" , "ForestStrike" )or(RemotesModule and(RemotesModule.GuardPatrol and RemotesModule.GuardPatrol.ForestStrike ))
local SpeedTollOfferRemote=findRemote( "SpeedTollOffer" , "RE/GuardPatrol/SpeedTollOffer" )or(RemotesModule and(RemotesModule.GuardPatrol and RemotesModule.GuardPatrol.SpeedTollOffer ))
local TreadmillUpgradeRemote=findRemote( "RF/Treadmill/AskTierRaise" , "Treadmills: RequestUpgrade" , "AskTierRaise" )
local TrailPurchaseRemote=findRemote( "RF/Trailwear/AskPurchase" , "Trailwear: RequestPurchase" , "AskPurchase" )
local TrailEquipRemote=findRemote( "RF/Trailwear/AskChoose" , "Trailwear: RequestEquip" , "AskChoose" )
local TrailUnequipRemote=findRemote( "RF/Trailwear/AskDoff" , "Trailwear: RequestUnequip" , "AskDoff" )logInfo(string.format ( "[RemoteCheck] Carry: %s | Snapshot: %s | Place: %s | Hatch: %s | FinishHatch: %s | Strike: %s | Toll: %s " ,tostring(AskFieldEggCarryRemote~=nil),tostring(AskFieldEggSnapshotRemote~=nil),tostring(AskPlaceEggRemote~=nil),tostring(AskHatchRemote~=nil),tostring(AskFinishHatchRemote~=nil),tostring(ForestStrikeRemote~=nil),tostring(SpeedTollOfferRemote~=nil)))

local ZONE_SCORE={[ "Light Dark" ]= 1300 ,[ "LightDark" ]= 1300 ;
[ "Titan Temple" ]= 1100 ,[ "Cherry Blossom" ]= 1000 ,[ "Cosmic" ]= 900 ;
[ "Prehistoric" ]= 800 ;
[ "Abyss Ocean" ]= 700 ,[ "Volcano" ]= 600 ;
[ "Snow" ]= 500 ,[ "Jungle" ]= 400 ;
[ "Desert" ]= 300 ,[ "Lake" ]= 200 ;
[ "Forest" ]= 100 }
local ZONE_ORDER={ "Light Dark" ;
"Titan Temple" ;
"Cherry Blossom" , "Cosmic" ;
"Prehistoric" , "Abyss Ocean" ;
"Volcano" ;
"Snow" , "Jungle" , "Desert" , "Lake" ;
"Forest" }
local ZONE_RETURN_SPEED={[ "Light Dark" ]= 700 ,[ "LightDark" ]= 700 ;
[ "Titan Temple" ]= 700 ,[ "Cherry Blossom" ]= 700 ,[ "Cosmic" ]= 700 ;
[ "Prehistoric" ]= 700 ,[ "Abyss Ocean" ]= 700 ;
[ "Volcano" ]= 700 ;
[ "Snow" ]= 700 ,[ "Jungle" ]= 700 ;
[ "Desert" ]= 700 ,[ "Lake" ]= 700 ,[ "Forest" ]= 125 }
local SAFE_LANE_Z= -360
local BASE_EDGE_X= 525
local FIELD_SLOWDOWN_X= 620
local BASE_RETURN_SPEED= 700
local DEFAULT_TARGET_CFRAME=CFrame.new ( 4773.7587890625 , 70.392112731934 , -315.73501586914 )

local FLIGHT_SPEED_FILE= "DiceHub_FlightSpeed.txt"
local CONFIG_FILE= "DiceHub_EggSelectConfig.json"
local ZONE_COLORS={[ "Light Dark" ]=Color3.fromRGB ( 168 , 85 , 247 ),[ "Titan Temple" ]=Color3.fromRGB ( 245 , 158 , 11 );
[ "Cherry Blossom" ]=Color3.fromRGB ( 236 , 72 , 153 );
[ "Cosmic" ]=Color3.fromRGB ( 6 , 182 , 212 ),[ "Prehistoric" ]=Color3.fromRGB ( 16 , 185 , 129 ),[ "Abyss Ocean" ]=Color3.fromRGB ( 59 , 130 , 246 );
[ "Volcano" ]=Color3.fromRGB ( 239 , 68 , 68 ),[ "Snow" ]=Color3.fromRGB ( 147 , 197 , 253 ),[ "Jungle" ]=Color3.fromRGB ( 34 , 197 , 94 ),[ "Desert" ]=Color3.fromRGB ( 234 , 179 , 8 ),[ "Lake" ]=Color3.fromRGB ( 20 , 184 , 166 ),[ "Forest" ]=Color3.fromRGB ( 22 , 163 , 74 )}
local RARITY_ORDER={ "Common", "Uncommon", "Rare", "Epic", "Legendary", "Myhtic", "Cosmic", "Secret", "Eternal", "Divine" }
local RARITY_COLORS={[ "Divine" ]=Color3.fromRGB ( 244 , 63 , 94 );
[ "Eternal" ]=Color3.fromRGB ( 217 , 70 , 239 ),[ "Secret" ]=Color3.fromRGB ( 249 , 115 , 22 ),[ "Cosmic" ]=Color3.fromRGB ( 6 , 182 , 212 ),[ "Mythic" ]=Color3.fromRGB ( 139 , 92 , 246 ),[ "Legendary" ]=Color3.fromRGB ( 251 , 191 , 36 );
[ "Epic" ]=Color3.fromRGB ( 168 , 85 , 247 );
[ "Rare" ]=Color3.fromRGB ( 59 , 130 , 246 );
[ "Uncommon" ]=Color3.fromRGB ( 34 , 197 , 94 ),[ "Common" ]=Color3.fromRGB ( 148 , 163 , 184 )}
local RARITY_TIERS={[ "Divine" ]= 6 ;
[ "Eternal" ]= 5 ;
[ "Secret" ]= 4 ,[ "Cosmic" ]= 3 ;
[ "Mythic" ]= 2 ;
[ "Legendary" ]= 1 ,[ "Epic" ]= 0.5 ,[ "Rare" ]= 0.3 ,[ "Uncommon" ]= 0.1 ;
[ "Common" ]= 0 }
local state
local function readFlightSpeed(...)
    local e= 600 pcall(function(...)
        local r= false
        if isfile then
            r=isfile(FLIGHT_SPEED_FILE)
        elseif readfile then
            local e,y=pcall(readfile,FLIGHT_SPEED_FILE)r=e and(y~=nil)
        end
        if r and readfile then
            local r=readfile(FLIGHT_SPEED_FILE)
            local u=tonumber(r)
            if u and(u>= 100 and u<= 1000 )then
                e=math.floor (u)
            end
        end
    end
    )
    return e
end
local function writeFlightSpeed(e,...) pcall(function(...)
        if writefile then
            local y=math.clamp (math.floor (tonumber(e)or 600 ), 100 , 1000 )writefile(FLIGHT_SPEED_FILE,tostring(y))
        end
    end
    )
end
local function loadConfig(...)
    local e=nil pcall(function(...)
        local r= false
        if isfile then
            r=isfile(CONFIG_FILE)
        elseif readfile then
            local e,y=pcall(readfile,CONFIG_FILE)r=e and(y~=nil)
        end
        if r and(readfile and HttpService)then
            local r=readfile(CONFIG_FILE)
            if r and r~= "" then
                local u=HttpService:JSONDecode(r)
                if type(u)== "table" then
                    e=u
                end
            end
        end
    end
    )
    local r={[ "Light Dark" ]= true ,[ "Titan Temple" ]= true ,[ "Cherry Blossom" ]= true ;
    [ "Cosmic" ]= false ;
    [ "Prehistoric" ]= false ,[ "Abyss Ocean" ]= false ;
    [ "Volcano" ]= false ,[ "Snow" ]= false ;
    [ "Jungle" ]= false ,[ "Desert" ]= false ;
    [ "Lake" ]= false ,[ "Forest" ]= false }
    local y={[ "Common" ]= false ,[ "Uncommon" ]= false ,[ "Rare" ]= false ,[ "Epic" ]= false ;
    [ "Legendary" ]= false ,[ "Myhtic" ]= true ,[ "Cosmic" ]= true ,[ "Secret" ]= true ,[ "Eternal" ]= true ,[ "Divine" ]= true }
    if type(e)~= "table" then
        e={[ "selectedZones" ]=r;
        [ "selectedRarities" ]=y,[ "alwaysCollectSecretPlus" ]= true ,[ "minRarityTier" ]= 2 ;
        [ "autoUpgradeTreadmill" ]= true ,[ "autoBuyTrails" ]= true ;
        [ "hideNotEnoughMoney" ]= true ;
        [ "performanceMode" ]= false ,[ "disable3D" ]= false ,[ "antiAFK" ]= true ,[ "language" ]= "EN" }
    else
        if type(e.selectedZones )~= "table" then
            e.selectedZones =r
        end
        if type(e.selectedRarities )~= "table" then
            e.selectedRarities =y
        else
            for r,w in ipairs(RARITY_ORDER)do
                if e.selectedRarities [w]==nil then
                    e.selectedRarities [w]=(y[w]== true )
                end
            end
        end
        if e.alwaysCollectSecretPlus ==nil then
            e.alwaysCollectSecretPlus = true
        end
        if e.minRarityTier ==nil then
            e.minRarityTier = 2
        end
        if e.autoUpgradeTreadmill ==nil then
            e.autoUpgradeTreadmill = true
        end
        if e.autoBuyTrails ==nil then
            e.autoBuyTrails = true
        end
        if e.hideNotEnoughMoney ==nil then
            e.hideNotEnoughMoney = true
        end
        if e.performanceMode ==nil then
            e.performanceMode = false
        end
        if e.disable3D ==nil then
            e.disable3D = false
        end
        if e.antiAFK ==nil then
            e.antiAFK = true
        end
        if e.language and((e.language == "EN" or e.language == "TH" ))then
            currentLang=e.language
        end
    end
    return e
end
local function saveConfig(...) pcall(function(...)
        if writefile and(HttpService and state)then
            local r={[ "selectedZones" ]=state.selectedZones or{};
            [ "selectedRarities" ]=state.selectedRarities or{};
            [ "alwaysCollectSecretPlus" ]=(state.alwaysCollectSecretPlus ~= false ),[ "minRarityTier" ]=state.minRarityTier or 2 ;
            [ "autoUpgradeTreadmill" ]=(state.autoUpgradeTreadmill == true ),[ "autoBuyTrails" ]=(state.autoBuyTrails == true );
            [ "hideNotEnoughMoney" ]=(state.hideNotEnoughMoney == true );
            [ "performanceMode" ]=(state.performanceMode == true );
            [ "disable3D" ]=(state.disable3D == true );
            [ "antiAFK" ]=(state.antiAFK == true );
            [ "language" ]=currentLang or "EN" }
            local y=HttpService:JSONEncode(r)writefile(CONFIG_FILE,y)
        end
    end
    )
end
local loadedConfig={selectedZones={},selectedRarities={}}state={[ "godmode" ]= true ,[ "autoGlide" ]= true ,[ "autoHatch" ]= false ;
[ "autoPlaceEvery5" ]= false ;
[ "batchStealCount" ]= 0 ,[ "isBatchPlacing" ]= false ,[ "isHatching" ]= false ;
[ "autoFarmLoop" ]= false ,[ "pureTweenFarm" ]= false ;
[ "glidingToTarget" ]= false ;
[ "securingEgg" ]= false ,[ "glideSpeed" ]=readFlightSpeed();
[ "selectedZones" ]=loadedConfig.selectedZones ;
[ "selectedRarities" ]=loadedConfig.selectedRarities ;
[ "alwaysCollectSecretPlus" ]=loadedConfig.alwaysCollectSecretPlus ,[ "minRarityTier" ]=loadedConfig.minRarityTier ;
[ "autoUpgradeTreadmill" ]=false ,[ "autoBuyTrails" ]=false ,[ "hideNotEnoughMoney" ]=false ;
[ "performanceMode" ]=(loadedConfig.performanceMode == true ),[ "disable3D" ]=(loadedConfig.disable3D == true ),[ "antiAFK" ]=true ,[ "laneZ" ]= -360 ,[ "swapped" ]= false ;
[ "teleporting" ]= false ,[ "isReturning" ]= false ;
[ "delivering" ]= false ,[ "holdingEggForGuard" ]= false ,[ "currentTargetModel" ]=nil,[ "targetPosition" ]=nil;
[ "returnEggUid" ]=nil ,[ "returnEggMode" ]=nil ,[ "returnEggSession" ]=nil ;
[ "returnRecoveryActive" ]=false ,[ "returnRecoveryCount" ]=0 ;
[ "returnRecoveryStartedAt" ]=0 ,[ "returnLastRecoveryAt" ]=0 ;
[ "returnMissionComplete" ]=false ,[ "returnDropGeneration" ]=0 ;
[ "nextStealZone" ]=nil,[ "stateTime" ]=os.clock (),[ "statusText" ]= "Ready" ,[ "bestEggInfo" ]= "Scanning..." ;
[ "gui" ]=nil;
[ "alive" ]= true ,[ "plot" ]=nil;
[ "pen" ]=nil,[ "origin" ]=nil;
[ "tread" ]=nil}
local isEggTool
local getEquippedEggTool
local getBackpackEggTool
local countCarriedEggs
local stashEquippedTools
local isCarryingEgg
local hasEggInInventory
local checkEggAvailability
local isCarryingLakeEgg
local getCarriedEggReturnSpeed
local createSafetyFloor
local requestForestStrike
local findPlayerPlot
local getBaseDropPosition
local chooseEggPlacementCFrame
local placeInventoryEggs
local hatchReadyEggs
local runBatchAutoPlace
local countStealAndMaybeBatchPlace
local placeAndHatchInventory
local getTrapHitboxes
local glideToTargetViaWaypoint
local tweenHomeToBase
local returnToSafeLine
local recoverDroppedEggDuringReturn
local findLakeStarterEgg
local selectBestTargetEgg
local secureEggWithGuardStrike
local runWarpStealCycle
local resetMovementState
local setGodmode
local swapHumanoidForDesync
local lockRigidJoints
local suppressRagdoll
local bindCharacterSafety
local triggerEggPromptsNearTarget
local targetCooldownUntil={}
local lastSnapshotFetchTime= 0
local cachedFieldEggRecords=nil
local readFieldEggs
local farmSessionId= 0
local currentFarmMode= "NONE"
local setFarmMode
local setTweenToggleState=nil
local setWarpToggleState=nil pcall(function(...)
    local e=game:GetService( "Lighting" );
    (e:GetPropertyChangedSignal( "ClockTime" )):Connect(function(...) targetCooldownUntil={}lastSnapshotFetchTime= 0
    end
    )
end
)pcall(function(...)
    local function e(e,...)
        if e:IsA( "RemoteEvent" )then
            local y=string.lower (e.Name )
            if string.find (y, "reset" )or string.find (y, "night" )or string.find (y, "spawn" )or string.find (y, "countdown" )then
                pcall(function(...) e.OnClientEvent :Connect(function(...) targetCooldownUntil={}lastSnapshotFetchTime= 0
                    end
                    )
                end
                )
            end
        end
    end
    for y,u in ipairs(ReplicatedStorage:GetDescendants())do
        e(u)
    end
    ReplicatedStorage.DescendantAdded :Connect(e)
end
)isEggTool=function(tool,...)
    if not tool or not tool:IsA("Tool") then return false end
    local kind = tostring(tool:GetAttribute("ItemType") or ""):lower()
    if kind == "asset" or kind == "gear" or kind == "mutationconsumable" then return false end
    if kind == "egg" or kind == "fieldegg" or kind == "eggtool" then return true end
    if tool:GetAttribute("IsEgg") == true or tool:GetAttribute("EggUid") ~= nil then return true end
    if EggToolDisplay and type(EggToolDisplay.IsEggTool) == "function" then
        local ok, isEgg = pcall(EggToolDisplay.IsEggTool, tool)
        if ok and isEgg == true then return true end
    end
    return tool.Name:lower():find("egg", 1, true) ~= nil
        and (tool:GetAttribute("UID") ~= nil or tool:GetAttribute("Uid") ~= nil)
end

getEquippedEggTool=function(...)
    local e=LocalPlayer.Character
    if e then
        for e,y in ipairs(e:GetChildren())do
            if isEggTool(y)then
                local e=y:GetAttribute( "UID" )or y:GetAttribute( "EggUid" )
                return y,e or y.Name
            end
        end
    end
    return nil,nil
end
getBackpackEggTool=function(...)
    local e=LocalPlayer:FindFirstChild( "Backpack" )
    if e then
        for e,y in ipairs(e:GetChildren())do
            if isEggTool(y)then
                local e=y:GetAttribute( "UID" )or y:GetAttribute( "EggUid" )
                return y,e or y.Name
            end
        end
    end
    return nil,nil
end
countCarriedEggs=function(...)
    local e= 0
    local r=LocalPlayer:FindFirstChild( "Backpack" )
    if r then
        for r,y in ipairs(r:GetChildren())do
            if isEggTool(y)then
                e=e+ 1
            end
        end
    end
    local y=LocalPlayer.Character
    if y then
        for r,y in ipairs(y:GetChildren())do
            if isEggTool(y)then
                e=e+ 1
            end
        end
    end
    return e
end
stashEquippedTools=function(e,...)
    if not e and not((state.pureTweenFarm or state.autoFarmLoop or state.teleporting ))then
        return
    end
    local r=LocalPlayer.Character
    local y=r and r:FindFirstChildOfClass( "Humanoid" )
    local u=LocalPlayer:FindFirstChild( "Backpack" )
    if y then
        pcall(function(...) y:UnequipTools()
        end
        )
    end
    if r and u then
        for e,r in ipairs(r:GetChildren())do
            if r:IsA( "Tool" )then
                pcall(function(...) r.Parent =u
                end
                )
            end
        end
    end
end
isCarryingEgg=function(e,...)
    if((state.pureTweenFarm or state.autoFarmLoop ))and not state.holdingEggForGuard then
        local e=getEquippedEggTool()
        if e then
            pcall(stashEquippedTools)
        end
        return false
    end
    local r,y=getEquippedEggTool()
    if r then
        if e then
            if y==e or not y then
                return true
            end
        else
            return true
        end
    end
    local u=LocalPlayer.Character
    local w=u and u:FindFirstChild( "HumanoidRootPart" )
    if w and w.Position.X <=(BASE_EDGE_X+ 15 )then
        return false
    end
    if EggState and EggState.ReadFieldEggs then
        local r,y=pcall(EggState.ReadFieldEggs )
        if r and(y and y.Records )then
            for r,y in ipairs(y.Records )do
                if((y.State == "Carried" or y.State == 2 ))and((y.CarrierUserId ==LocalPlayer.UserId or y.Carrier ==LocalPlayer.UserId ))then
                    if e then
                        if y.Uid ==e then
                            return true
                        end
                    else
                        return true
                    end
                end
            end
        end
    end
    return false
end
hasEggInInventory=function(e,...)
    local r,y=getEquippedEggTool()
    if r then
        if not e or y==e or not y then
            return true
        end
    end
    local u=LocalPlayer:FindFirstChild( "Backpack" )
    if u then
        for r,y in ipairs(u:GetChildren())do
            if isEggTool(y)then
                local r=y:GetAttribute( "UID" )or y:GetAttribute( "EggUid" )
                if not e or r==e or y.Name ==tostring(e)then
                    return true
                end
            end
        end
    end
    if e and(EggState and EggState.ReadFieldEggs )then
        local r,y=pcall(EggState.ReadFieldEggs )
        if r and(y and y.Records )then
            for r,y in ipairs(y.Records )do
                if y.Uid ==e then
                    if(y.State == "Carried" or y.State == 2 )then
                        local e=y.CarrierUserId or y.Carrier
                        if e==LocalPlayer.UserId then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end
local snapshotFetchBusy= false
local function refreshFieldEggSnapshot(...)
    if snapshotFetchBusy then
        return
    end
    local e=AskFieldEggSnapshotRemote or ReplicatedStorage:FindFirstChild( "RF/EggWorld/AskFieldEggSnapshot" , true )or ReplicatedStorage:FindFirstChild( "AskFieldEggSnapshot" , true )or ReplicatedStorage:FindFirstChild( "Eggs: RequestAreaEggSnapshot" , true )
    if not e or not e:IsA( "RemoteFunction" )then
        return
    end
    snapshotFetchBusy= true task.spawn (function(...)
        local r,y=pcall(function(...)
            return e:InvokeServer()
        end
        )
        if r and type(y)== "table" then
            local e={}
            local r=y.Records or y
            if type(r)== "table" then
                for r,y in pairs(r)do
                    if type(y)== "table" then
                        if not y.Uid and type(r)== "string" then
                            y.Uid =r
                        end
                        table.insert (e,y)
                    end
                end
            end
            if#e> 0 then
                cachedFieldEggRecords=e lastSnapshotFetchTime=os.clock ()
            end
        end
        snapshotFetchBusy= false
    end
    )
end
task.spawn (function(...)
    while true do
        task.wait ( 5 )pcall(refreshFieldEggSnapshot)
    end
end
)function readFieldEggs(e,...)
    local y=os.clock ()
    if e or(y-lastSnapshotFetchTime>= 5 )or not cachedFieldEggRecords then
        refreshFieldEggSnapshot()
    end
    local u=((cachedFieldEggRecords and#cachedFieldEggRecords> 0 ))and cachedFieldEggRecords or nil
    local w=nil
    if EggState and EggState.ReadFieldEggs then
        local e,r=pcall(EggState.ReadFieldEggs )
        if e and type(r)== "table" then
            local e={}
            local y=r.Records or r
            if type(y)== "table" then
                for r,y in pairs(y)do
                    if type(y)== "table" then
                        if not y.Uid and type(r)== "string" then
                            y.Uid =r
                        end
                        table.insert (e,y)
                    end
                end
            end
            if#e> 0 then
                w=e
            end
        end
    end
    local j={}
    local k={}
    if u then
        for e,r in ipairs(u)do
            if r.Uid then
                k[r.Uid ]= true table.insert (j,r)
            end
        end
    end
    if w then
        for e,r in ipairs(w)do
            if r.Uid and not k[r.Uid ]then
                k[r.Uid ]= true table.insert (j,r)
            end
        end
    end
    local a=Workspace:FindFirstChild( "AreaEggSlotsClient" )
    if a then
        for e,r in ipairs(a:GetChildren())do
            local y=r.Name
            if y and y~= "" then
                local e=r:GetPivot()
                local u=e.Position
                if u.X >= 530 and not string.find (tostring(y), "FirstArea" )then
                    if not k[y]then
                        k[y]= true
                        local u=r:GetAttribute( "Category" )or r:GetAttribute( "AssetCategory" )or r.Name
                        local w=r:GetAttribute( "AreaId" )or r:GetAttribute( "Area" )
                        local a=r:GetAttribute( "Rarity" )or r:GetAttribute( "RarityTier" )
                        local V=r:GetAttribute( "RarityRank" )or r:GetAttribute( "Rank" )
                        local H=r:GetAttribute( "Income" )or r:GetAttribute( "EarningRate" )
                        local t=r:GetAttribute( "Scale" )or r:GetAttribute( "AssetScale" )or 1
                        local s=r:GetAttribute( "Mutations" )or r:GetAttribute( "Mutation" )table.insert (j,{[ "Uid" ]=y,[ "AssetCategory" ]=u,[ "AreaId" ]=w;
                        [ "Rarity" ]=a,[ "Rank" ]=V,[ "Income" ]=H,[ "BoundsCFrame" ]=e;
                        [ "BottomCFrame" ]=e,[ "CFrame" ]=e;
                        [ "State" ]= "Slot" ;
                        [ "AssetScale" ]=t,[ "Mutations" ]=s,[ "PhysicalModel" ]=r})
                    else
                        for u,w in ipairs(j)do
                            if w.Uid ==y then
                                w.PhysicalModel =r
                                if not w.BoundsCFrame then
                                    w.BoundsCFrame =e
                                end
                                if not w.AreaId or w.AreaId == "" or w.AreaId == "Unknown" then
                                    w.AreaId =r:GetAttribute( "AreaId" )or r:GetAttribute( "Area" )
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    return j
end
checkEggAvailability=function(e,...)
    if not e then
        return false , "NoUid"
    end
    local y=readFieldEggs( false )
    if y and#y> 0 then
        for r,y in ipairs(y)do
            if y.Uid ==e then
                if(y.State == "Carried" or y.State == 2 )then
                    local e=y.CarrierUserId or y.Carrier
                    if e and e==LocalPlayer.UserId then
                        return true , "CarriedBySelf"
                    else
                        return false , "CarriedByOther"
                    end
                end
                if(y.State == "Slot" or y.State == "Dropped" or y.State == "GuardCarried" or y.State == 1 )then
                    return true , "Available"
                end
                local e=y.CarrierUserId or y.Carrier
                if e then
                    if e==LocalPlayer.UserId then
                        return true , "CarriedBySelf"
                    else
                        return false , "CarriedByOther"
                    end
                end
                return true , "Available"
            end
        end
    end
    local u=Workspace:FindFirstChild( "AreaEggSlotsClient" )
    if u then
        for r,y in ipairs(u:GetChildren())do
            if y.Name ==tostring(e)or y:GetAttribute( "UID" )==e or y:GetAttribute( "Uid" )==e then
                return true , "Available"
            end
        end
    end
    return true , "Unchecked"
end
isCarryingLakeEgg=function(...)
    local e,r=getEquippedEggTool()
    if not r then
        local e,y=getBackpackEggTool()r=y
    end
    if not r then
        return false
    end
    if EggState and EggState.ReadFieldEggs then
        local e,u=pcall(EggState.ReadFieldEggs )
        if e and(u and u.Records )then
            for e,u in ipairs(u.Records )do
                if u.Uid ==r then
                    local e=tostring(u.AreaId or "" )
                    if e== "Lake" or string.find (string.lower (e), "lake" )~=nil then
                        return true
                    end
                end
            end
        end
    end
    if string.find (string.lower (tostring(r)), "lake" )~=nil then
        return true
    end
    return false
end
getCarriedEggReturnSpeed=function(...)
    local e,r=getEquippedEggTool()
    if not r then
        local e,y=getBackpackEggTool()r=y
    end
    if not r then
        return state.glideSpeed or 350
    end
    if EggState and EggState.ReadFieldEggs then
        local e,u=pcall(EggState.ReadFieldEggs )
        if e and(u and u.Records )then
            for e,u in ipairs(u.Records )do
                if u.Uid ==r and u.AreaId then
                    return ZONE_RETURN_SPEED[u.AreaId ]or state.glideSpeed or 350
                end
            end
        end
    end
    return state.glideSpeed or 350
end
createSafetyFloor=function(e,y,...) y=y or 8
    local u=Instance.new ( "Part" )u.Name = "SafetyFloorPad_AntiVoid" u.Size =Vector3.new ( 28 , 1.5 , 28 )u.Position =e-Vector3.new ( 0 , 3.2 , 0 )u.Anchored = true u.Transparency = 1 u.CanCollide = true u.Parent =Workspace task.delay (y,function(...) pcall(function(...) u:Destroy()
        end
        )
    end
    )
    return u
end
requestForestStrike=function(e,...)
    if ForestStrikeRemote and e then
        pcall(function(...)
            local r=LocalPlayer.Character
            local y=r and r:FindFirstChild( "HumanoidRootPart" )
            local u=y and(y.CFrame *CFrame.new ( 0 , 0 , -3 ))or CFrame.new ()
            if ForestStrikeRemote:IsA( "RemoteFunction" )then
                ForestStrikeRemote:InvokeServer({[ "EggUid" ]=e,[ "GuardCFrame" ]=u})
            else
                ForestStrikeRemote:FireServer({[ "EggUid" ]=e;
                [ "GuardCFrame" ]=u})
            end
        end
        )
    end
end
if typeof(hookmetamethod)== "function" and not _G._DesyncAntiRagdollHooked then
    _G._DesyncAntiRagdollHooked = true
    local e e=hookmetamethod(game, "__newindex" ,safeNewCClosure(function(r,y,u,...)
        if not executorCheckCaller()and typeof(r)== "Instance" then
            if r:IsA( "Motor6D" )and(y== "Enabled" and u== false )then
                return nil
            end
            if r:IsA( "Humanoid" )then
                if y== "PlatformStand" and u== true then
                    return nil
                end
                if y== "Sit" and(u== true and((state.pureTweenFarm or state.autoFarmLoop or state.isReturning or state.glidingToTarget )))then
                    return nil
                end
            end
        end
        return e(r,y,u)
    end
    ))
end
lockRigidJoints=function(e,...) e=e or LocalPlayer.Character
    if not e then
        return
    end
    local r=e:FindFirstChild( "HumanoidRootPart" )
    local y=e:FindFirstChild( "Torso" )or e:FindFirstChild( "UpperTorso" )or r
    if not y then
        return
    end
    for e,r in ipairs(e:GetDescendants())do
        if r:IsA( "BallSocketConstraint" )or r:IsA( "HingeConstraint" )or r:IsA( "NoCollisionConstraint" )then
            pcall(function(...) r:Destroy()
            end
            )
        end
    end
    for e,r in ipairs(e:GetDescendants())do
        if r:IsA( "Motor6D" )and(r.Part0 and r.Part1 )then
            r.Enabled = true
            local e= "RigidJointWeld_" ..r.Name
            local y=r.Part1 :FindFirstChild(e)
            if not y then
                local y=Instance.new ( "WeldConstraint" )y.Name =e y.Part0 =r.Part0 y.Part1 =r.Part1 y.Parent =r.Part1
            end
        end
    end
end
suppressRagdoll=function(e,...)
    e=e or LocalPlayer.Character
    if not e then
        return
    end
    local r=e:FindFirstChildOfClass( "Humanoid" )
    if r then
        r:SetStateEnabled(Enum.HumanoidStateType.Ragdoll , false )r:SetStateEnabled(Enum.HumanoidStateType.FallingDown , false )r:SetStateEnabled(Enum.HumanoidStateType.Physics , false )r:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding , false )r:SetStateEnabled(Enum.HumanoidStateType.Seated , false )
        if r.PlatformStand then
            r.PlatformStand = false
        end
        if r.Sit then
            r.Sit = false
        end
    end
    for e,r in ipairs(e:GetDescendants())do
        if r:IsA( "LocalScript" )and((string.find (string.lower (r.Name ), "ragdoll" )or string.find (string.lower (r.Name ), "fall" )))then
            r.Disabled = true
        end
    end
    lockRigidJoints(e)
end
bindCharacterSafety=function(e,...)
    if not e then
        return
    end
    suppressRagdoll(e)
    for e,y in ipairs(e:GetDescendants())do
        if y:IsA( "Motor6D" )then
            (y:GetPropertyChangedSignal( "Enabled" )):Connect(function(...)
                if not y.Enabled then
                    y.Enabled = true
                end
            end
            )
        end
    end
    e.DescendantAdded :Connect(function(y,...)
        if y:IsA( "BallSocketConstraint" )or y:IsA( "HingeConstraint" )or y:IsA( "NoCollisionConstraint" )then
            task.defer (function(...) pcall(function(...) y:Destroy()
                end
                )suppressRagdoll(e)
            end
            )
        elseif y:IsA( "LocalScript" )and((string.find (string.lower (y.Name ), "ragdoll" )or string.find (string.lower (y.Name ), "fall" )))then
            y.Disabled = true
        end
    end
    )e.ChildAdded :Connect(function(e,...)
        if e:IsA( "Tool" )and(((state.pureTweenFarm or state.autoFarmLoop ))and not state.holdingEggForGuard )then
            task.defer (function(...) stashEquippedTools()
            end
            )
        end
    end
    )
end
resetMovementState=function(...) state.teleporting = false state.glidingToTarget = false state.securingEgg = false state.isReturning = false state.delivering = false state.holdingEggForGuard = false state.currentTargetModel =nil state.targetPosition =nil state.stateTime =os.clock ()
    local e=LocalPlayer.Character
    local r=e and e:FindFirstChild( "HumanoidRootPart" )
    if r then
        pcall(function(...) r.Anchored = false r.AssemblyLinearVelocity =Vector3.zero r.AssemblyAngularVelocity =Vector3.zero
        end
        )
    end
pcall(function(...)
        if suppressRagdoll and e then
            suppressRagdoll(e)
        end
    end
    )pcall(function(...)
        if stashEquippedTools and((state.pureTweenFarm or state.autoFarmLoop ))then
            stashEquippedTools()
        end
    end
    )
end
triggerEggPromptsNearTarget=function(e,y,...)
    if e then
        for e,r in ipairs(e:GetDescendants())do
            if r:IsA( "ProximityPrompt" )then
                pcall(function(...) r.RequiresLineOfSight = false r.HoldDuration = 0
                    if typeof(fireproximityprompt)== "function" then
                        fireproximityprompt(r, 0 )fireproximityprompt(r)
                    end
                end
                )
            end
        end
    end
    local u=Workspace:FindFirstChild( "AreaEggSlotsClient" )
    if u and y then
        for e,r in ipairs(u:GetChildren())do
            local u=r:FindFirstChildWhichIsA( "BasePart" )or r.PrimaryPart
            if u and((u.Position -y)).Magnitude <= 18 then
                for e,r in ipairs(r:GetDescendants())do
                    if r:IsA( "ProximityPrompt" )then
                        pcall(function(...) r.RequiresLineOfSight = false r.HoldDuration = 0
                            if typeof(fireproximityprompt)== "function" then
                                fireproximityprompt(r, 0 )fireproximityprompt(r)
                            end
                        end
                        )
                    end
                end
            end
        end
    end
end
setGodmode=function(e,...) state.godmode =e
    local r=LocalPlayer.Character
    if not r then
        return
    end
    local y=r:FindFirstChildOfClass( "Humanoid" )
    if y then
        y:SetStateEnabled(Enum.HumanoidStateType.Dead ,not e)
        if e and y.Health < 100 then
            y.Health = 100
        end
    end
    for r,y in ipairs(r:GetDescendants())do
        if y:IsA( "BasePart" )then
            if e then
                y.CanTouch = false y.CanCollide = false
            end
        end
    end
    suppressRagdoll(r)
end
local function enableDesyncGodmode()
    setGodmode(true)
end
local function disableDesyncGodmode()
    setGodmode(false)
end

swapHumanoidForDesync=function(...)
    local e=LocalPlayer.Character
    local y=e and e:FindFirstChildOfClass( "Humanoid" )
    if not e or not y then
        return false
    end
    pcall(function(...) y.BreakJointsOnDeath = false
        local w=y:Clone()w.Parent =e y:Destroy()
        local j=w:FindFirstChildOfClass( "Animator" )
        if not j then
            j=Instance.new ( "Animator" )j.Parent =w
        end
        Workspace.CurrentCamera.CameraSubject =w
        local k=e:FindFirstChild( "Animate" )
        if k and k:IsA( "LocalScript" )then
            k.Disabled = true task.defer (function(...) task.wait ( 0.05 )k.Disabled = false
            end
            )
        end
        w:SetStateEnabled(Enum.HumanoidStateType.Jumping , true )w:SetStateEnabled(Enum.HumanoidStateType.Freefall , true )w:SetStateEnabled(Enum.HumanoidStateType.Running , true )w:SetStateEnabled(Enum.HumanoidStateType.Climbing , true )w.JumpPower =math.max ( 50 ,w.JumpPower )w.JumpHeight =math.max ( 7.2 ,w.JumpHeight )w:ChangeState(Enum.HumanoidStateType.Running )
    end
    )state.swapped = true
    if state.godmode then
        setGodmode( true )
    end
    bindCharacterSafety(e)
    return true
end
findPlayerPlot=function(...)
    if state.plot and(state.plot.Parent and(state.pen and(state.origin and state.plotVerified )))then
        return state.plot ,state.pen ,state.origin
    end
    local e=Workspace:FindFirstChild( "Plots" )
    if not e then
        return nil,nil,nil
    end
    local y=LocalPlayer.UserId
    local u=LocalPlayer.Name
    local w=LocalPlayer.DisplayName
    local j=nil
    local k= false
    if AskPlotStateRemote then
        local r,w=pcall(function(...)
            return AskPlotStateRemote:InvokeServer()
        end
        )
        if r and(type(w)== "table" and type(w.OwnersBySlot )== "table" )then
            for r,w in pairs(w.OwnersBySlot )do
                if w==y or tostring(w)==tostring(y)or w==u then
                    j=e:FindFirstChild(tostring(r))
                    if j then
                        k= true
                        break
                    end
                end
            end
        end
    end
    if not j and AskLiveSnapshotRemote then
        local r,u=pcall(function(...)
            return AskLiveSnapshotRemote:InvokeServer()
        end
        )
        if r and type(u)== "table" then
            for r,u in pairs(u)do
                if type(u)== "table" and((u.OwnerUserId ==y or tostring(u.OwnerUserId )==tostring(y)))then
                    local y=u.Slot or r j=e:FindFirstChild(tostring(y))or e:FindFirstChild(tostring(r))
                    if j then
                        k= true
                        break
                    end
                end
            end
        end
    end
    if not j then
        for e,r in ipairs(e:GetChildren())do
            local a=r:GetAttribute( "Owner" )or r:GetAttribute( "OwnerUserId" )or r:GetAttribute( "UserId" )or r:GetAttribute( "OwnerId" )or r:GetAttribute( "Player" )
            if a and((a==y or tostring(a)==tostring(y)or a==u or tostring(a)==u or a==w))then
                j=r k= true
                break
            end
            for e,a in ipairs({ "Owner" , "OwnerUserId" , "OwnerId" ;
                "UserId" ;
                "Player" ;
                "PlayerName" })do
                local o=r:FindFirstChild(a)
                if o and((o.Value ==y or tostring(o.Value )==tostring(y)or o.Value ==u or o.Value ==w))then
                    j=r k= true
                    break
                end
            end
            if j then
                break
            end
        end
    end
    if not j then
        for e,r in ipairs(e:GetChildren())do
            for e,y in ipairs(r:GetDescendants())do
                if y:IsA( "TextLabel" )and y.Text ~= "" then
                    local e=string.lower (y.Text )
                    if string.find (e,string.lower (u), 1 , true )or(w and string.find (e,string.lower (w), 1 , true ))then
                        j=r k= true
                        break
                    end
                end
            end
            if j then
                break
            end
        end
    end
    if not j then
        local r=LocalPlayer.Character
        local y=r and r:FindFirstChild( "HumanoidRootPart" )
        if y and y.Position.X <=(BASE_EDGE_X+ 30 )then
            local r=nil
            local u= 999999
            for e,w in ipairs(e:GetChildren())do
                local j=w:FindFirstChild( "CenterPoint" )or w.PrimaryPart or w:FindFirstChildWhichIsA( "BasePart" )
                if j then
                    local e=((y.Position -j.Position )).Magnitude
                    if e<u then
                        u=e r=w
                    end
                end
            end
            if r and u< 160 then
                j=r
            end
        end
    end
    if not j then
        j=e:FindFirstChild( "2" )or e:FindFirstChild( "1" )or(e:GetChildren())[ 1 ]
    end
    if not j then
        return nil,nil,nil
    end
    state.plot =j state.plotVerified =k state.origin =j:FindFirstChild( "CenterPoint" )
    local a=j:FindFirstChild( "ToUpdate" )state.pen =(a and a:FindFirstChild( "PetArea" ))or j:FindFirstChild( "PetArea" )state.tread =j:FindFirstChild( "TreadmillBottom" )
    if not state.pen and a then
        for e,r in ipairs(a:GetChildren())do
            if r:IsA( "BasePart" )and string.find (string.lower (r.Name ), "pet" )then
                state.pen =r
                break
            end
        end
    end
    if not state.origin then
        state.origin =j:FindFirstChild( "CenterPoint" )or state.pen or j.PrimaryPart
    end
    if not state.pen then
        state.pen =state.origin
    end
    return state.plot ,state.pen ,state.origin
end
getBaseDropPosition=function(...)
    local e,r,y=findPlayerPlot()
    if r then
        return r.Position +Vector3.new ( 0 , 3.5 , 0 )
    end
    if y then
        return y.Position +Vector3.new ( 0 , 3.5 , 0 )
    end
    return Vector3.new ( 464.7 , 71.7 , -304 )
end
chooseEggPlacementCFrame=function(e,...)
    local r,y,u=findPlayerPlot()
    if not y then
        return nil
    end
    local w=y.Size
    local j=math.max ( 4 ,w.X / 2 - 5 )
    local k=math.max ( 4 ,w.Z / 2 - 5 )
    for r= 1 , 60 , 1 do
        local u=math.random (-math.floor (j),math.floor (j))
        local o=math.random (-math.floor (k),math.floor (k))
        local V=y.CFrame *CFrame.new (u,w.Y / 2 + 1 ,o)
        local H= true
        for e,r in ipairs(e)do
            if((r-V.Position )).Magnitude < 5.5 then
                H= false
                break
            end
        end
        if H then
            return V
        end
    end
    return y.CFrame *CFrame.new (math.random ( -8 , 8 ),w.Y / 2 + 1 ,math.random ( -8 , 8 ))
end
placeInventoryEggs=function(...)
    if HUB.V44.autoPlaceBusy or not AskPlaceEggRemote then return 0 end

    local plot, pen = findPlayerPlot()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not pen or not root or not hum then return 0 end

    if state.plotVerified == false then
        local valid = false
        local ok, actualPlot = pcall(function()
            return PlotState and PlotState.ResolvePlot and PlotState.ResolvePlot()
        end)
        if ok and actualPlot and actualPlot == plot then valid = true end
        if not valid then
            logWarn("[PlaceEgg] Player plot ownership was not verified; skip placement")
            return 0
        end
    end

    HUB.V44.autoPlaceBusy = true
    local placed, positions, tools, seen = 0, {}, {}, {}

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    for _, container in ipairs({character, backpack}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") and isEggTool(tool) then
                    local uid = tool:GetAttribute("UID")
                        or tool:GetAttribute("Uid")
                        or tool:GetAttribute("EggUid")

                    if uid and not seen[tostring(uid)] then
                        seen[tostring(uid)] = true
                        tools[#tools + 1] = {tool = tool, uid = uid}
                    end
                end
            end
        end
    end

    if #tools > 0 then
        local center = pen.Position + Vector3.new(0, pen.Size.Y * 0.5 + 3, 0)
        if (root.Position - center).Magnitude > 8 then
            root.CFrame = CFrame.new(center)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end
    end

    for _, item in ipairs(tools) do
        if not state.alive or HUB.paused then break end

        local tool, uid = item.tool, item.uid
        if tool and tool.Parent then
            pcall(function() hum:EquipTool(tool) end)

            local deadline = os.clock() + 0.55
            while tool.Parent ~= character and os.clock() < deadline do
                RunService.Heartbeat:Wait()
            end

            if tool.Parent == character then
                local spot = chooseEggPlacementCFrame(positions)
                if spot then
                    local localCF = pen.CFrame:ToObjectSpace(spot)
                    local success, reply = pcall(function()
                        return AskPlaceEggRemote:InvokeServer({
                            Uid = uid,
                            LocalCFrame = localCF,
                        })
                    end)

                    if success and reply ~= false and reply ~= nil then
                        placed += 1
                        positions[#positions + 1] = spot.Position
                    elseif EggState and EggState.PlantEgg then
                        local fallbackCall, fallbackResult = pcall(function()
                            return EggState.PlantEgg(uid, localCF)
                        end)
                        if fallbackCall and fallbackResult ~= false then
                            placed += 1
                            positions[#positions + 1] = spot.Position
                        else
                            logWarn("[PlaceEgg] Server rejected UID " .. tostring(uid))
                        end
                    else
                        logWarn("[PlaceEgg] Server rejected UID " .. tostring(uid))
                    end
                end
            end

            pcall(function() hum:UnequipTools() end)
            task.wait(0.04)
        end
    end

    HUB.V44.autoPlaceBusy = false
    return placed
end

hatchReadyEggs=function(force,...)
    if (not force and not state.autoHatch) or state.isHatching then return 0 end
    if not AskFinishHatchRemote and not AskHatchRemote then return 0 end

    state.isHatching = true
    local total = 0

    local function callEggRemote(remote, payload)
        if not remote then return false, nil end
        local ok, result = pcall(function()
            if remote:IsA("RemoteFunction") then
                return remote:InvokeServer(payload)
            end
            remote:FireServer(payload)
            return true
        end)
        return ok and result ~= false, result
    end

    local ok, err = pcall(function()
        local snapshot

        if EggState and EggState.ReadOwnedEggs then
            local success, result = pcall(EggState.ReadOwnedEggs, LocalPlayer.UserId)
            if success then snapshot = result end
        end

        if not snapshot and AskLiveSnapshotRemote then
            local success, result = pcall(function()
                return AskLiveSnapshotRemote:InvokeServer()
            end)
            if success then snapshot = result end
        end

        local records = {}
        if type(snapshot) == "table" then
            if type(snapshot.Records) == "table" then
                records = snapshot.Records
            else
                for _, group in pairs(snapshot) do
                    if type(group) == "table" then
                        local owner = group.OwnerUserId or group.OwnerId or group.UserId
                        if owner == nil or tostring(owner) == tostring(LocalPlayer.UserId) then
                            for uid, item in pairs(group.Records or {}) do
                                records[uid] = item
                            end
                        end
                    end
                end
            end
        end

        for uid, record in pairs(records) do
            if not state.alive or HUB.paused then break end
            if type(record) ~= "table" or not record.Placement then
                continue
            end

            local ready = false
            if EggState and EggState.IsReadyToHatch then
                local success, value = pcall(EggState.IsReadyToHatch, record)
                ready = success and value == true

                if not ready then
                    local successUid, valueUid = pcall(EggState.IsReadyToHatch, uid)
                    ready = successUid and valueUid == true
                end
            end

            if not ready then
                local placedAt = tonumber(record.Placement.PlacedAt or record.Placement.Time)
                local growthTime = tonumber(record.GrowthTime or record.HatchTime)
                if placedAt and growthTime then
                    ready = (Workspace:GetServerTimeNow() - placedAt) >= growthTime
                end
            end

            if ready then
                if AskSkipGrowthRemote then
                    pcall(function()
                        callEggRemote(AskSkipGrowthRemote, uid)
                    end)
                end

                local beginOk = true
                if AskHatchRemote then
                    beginOk = select(1, callEggRemote(AskHatchRemote, uid))
                end

                if beginOk and AskFinishHatchRemote then
                    task.wait(0.06)

                    local finished = select(1, callEggRemote(AskFinishHatchRemote, uid))
                    if finished then
                        total += 1
                        state.hatched = (state.hatched or 0) + 1
                    end
                elseif beginOk and EggState and EggState.FinishHatch then
                    local finished = pcall(EggState.FinishHatch, uid)
                    if finished then
                        total += 1
                        state.hatched = (state.hatched or 0) + 1
                    end
                end

                task.wait(0.04)
            end
        end
    end)

    state.isHatching = false
    if not ok then
        logWarn("[AutoHatch] " .. tostring(err))
    end
    return total
end

getTrapHitboxes=function(...)
    local e={}
    local y=Workspace:FindFirstChild( "__DEBRIS" )
    if y then
        for r,y in ipairs(y:GetChildren())do
            local u=y:FindFirstChild( "Hitbox" )
            if u and u:IsA( "BasePart" )then
                table.insert (e,u)
            elseif y:IsA( "BasePart" )and string.find (y.Name :lower(), "hitbox" )then
                table.insert (e,y)
            end
        end
    end
    local u=Workspace:FindFirstChild( "BossArenaTeleport" )
    if u then
        local r=u:FindFirstChild( "Hitbox" )or u:FindFirstChildWhichIsA( "BasePart" )or(u:IsA( "BasePart" )and u)
        if r and r:IsA( "BasePart" )then
            table.insert (e,r)
        end
    end
    return e
end
tweenHomeToBase=function(e,r,u,...)
    local w=LocalPlayer.Character
    local j=w and w:FindFirstChild( "HumanoidRootPart" )
    local k=w and w:FindFirstChildOfClass( "Humanoid" )
    if not j then
        return false
    end
    if k then
        k.AutoRotate = false
    end
    local a=getBaseDropPosition()e=math.max ( 100 ,e or state.glideSpeed or 600 )
    local V=state.laneZ or SAFE_LANE_Z state.isReturning = true state.stateTime =os.clock ()createSafetyFloor(a, 20 )j.AssemblyLinearVelocity =Vector3.zero j.AssemblyAngularVelocity =Vector3.zero
    local H=getCarriedEggReturnSpeed()
    local t=math.max (e,H)
    local s=os.clock ()+ 25
    local lastReturnEggCheck = 0

    state.returnEggUid = state.returnEggUid or nil
    state.returnEggMode = state.returnEggMode or nil
    state.returnEggSession = state.returnEggSession or r
    state.returnMissionComplete = false

    while state.alive and(state.isReturning and os.clock ()<s)do
        if r and farmSessionId~=r then
            if k then
                k.AutoRotate = true
            end
            state.isReturning = false
            return false
        end
        if not u and(not state.pureTweenFarm and not state.autoFarmLoop )then
            if k then
                k.AutoRotate = true
            end
            state.isReturning = false
            return false
        end

        if r and state.returnEggUid and (os.clock() - lastReturnEggCheck) >= 0.08 then
            lastReturnEggCheck = os.clock()

            if not hasEggInInventory(state.returnEggUid) then
                state.returnRecoveryActive = true
                local recovered = recoverDroppedEggDuringReturn(
                    state.returnEggUid,
                    "TWEEN",
                    r
                )

                if not recovered then
                    if k then
                        k.AutoRotate = true
                    end
                    state.isReturning = false
                    return false
                end

                j = LocalPlayer.Character
                    and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not j then
                    if k then
                        k.AutoRotate = true
                    end
                    state.isReturning = false
                    return false
                end

                j.AssemblyLinearVelocity = Vector3.zero
                j.AssemblyAngularVelocity = Vector3.zero
            end
        end

        local e=j.Position
        local w=((a-e)).Magnitude
        if(e.X <=(a.X + 3 )and math.abs (e.Z -a.Z )<= 8 )or w<= 6 then
            break
        end
        local o=RunService.Heartbeat :Wait()e=j.Position
        local H=t
        if e.X <=FIELD_SLOWDOWN_X and e.X >BASE_EDGE_X then
            local r=math.clamp (((e.X -BASE_EDGE_X))/((FIELD_SLOWDOWN_X-BASE_EDGE_X)), 0 , 1 )H=BASE_RETURN_SPEED+(((t-BASE_RETURN_SPEED))*r)
        elseif e.X <=BASE_EDGE_X then
            H=BASE_RETURN_SPEED
        end
        local s=a.Z
        if e.X > 540 then
            s=V
        end
        local B=math.sign (a.X -e.X )
        local J=B*math.min (math.abs (a.X -e.X ),H*o)
        local K=e.X +J
        local c=math.sign (a.Y -e.Y )
        local v=c*math.min (math.abs (a.Y -e.Y ),(H*o)* 0.5 )
        local i=e.Y +v
        local R=s-e.Z
        local g=math.sign (R)*math.min (math.abs (R),H*o)
        local Q=e.Z +g
        local P=getTrapHitboxes()
        local N= false
        if e.X >BASE_EDGE_X then
            for e,r in ipairs(P)do
                local y=r.Position
                local u=((Vector3.new (K,i,Q)-y)).Magnitude
                local w=math.abs (K-y.X )
                local j=math.abs (Q-y.Z )
                if u< 22 or(w< 18 and j< 14 )then
                    N= true
                    local e=y.Y + 16
                    if i<e then
                        i=math.min (i+((H*o)* 1.5 ),e)
                    end
                    break
                end
            end
        end
        local U=Vector3.new (K,i,Q)
        local l=((U-e)).Magnitude > 0.05 and((U-e)).Unit or j.CFrame.LookVector j.CFrame =CFrame.lookAt (U,U+l)j.AssemblyLinearVelocity =Vector3.zero j.AssemblyAngularVelocity =Vector3.zero
        if N then
            state.statusText =string.format ( "Tweening Home (Z: %.0f) [DODGING TRAP!]" ,Q)
        else
            state.statusText =string.format ( "Tweening Home (%.0f studs | Z: %.0f | Spd: %.0f)" ,w,Q,H)
        end
    end
    if state.returnEggUid and not hasEggInInventory(state.returnEggUid) then
        local recovered = recoverDroppedEggDuringReturn(state.returnEggUid, "TWEEN", r)
        if not recovered then
            if k then k.AutoRotate = true end
            state.isReturning = false
            state.returnMissionComplete = false
            return false
        end
    end

    j.CFrame =CFrame.new (a)j.AssemblyLinearVelocity =Vector3.zero j.AssemblyAngularVelocity =Vector3.zero
    if k then
        k.AutoRotate = true
    end
    stashEquippedTools()
    state.returnMissionComplete = true
    state.returnRecoveryActive = false
    state.returnEggUid = nil
    state.returnEggMode = nil
    state.returnEggSession = nil
    state.returnRecoveryCount = 0
    state.returnDropGeneration = 0
    state.isReturning = false state.delivering = false state.statusText = "Arrived at Base PetArea!"
    return true
end
placeAndHatchInventory=function(e,r,y,...)
    local u=LocalPlayer.Character
    local w=u and u:FindFirstChild( "HumanoidRootPart" )
    local j=u and u:FindFirstChildOfClass( "Humanoid" )
    if not w or not j then
        return
    end
    local k=getBaseDropPosition()
    local a=((w.Position -k)).Magnitude
    if a> 8 then
        state.statusText = "[Place] Tweening back to base plot..." tweenHomeToBase(e or state.glideSpeed or 600 ,r, true )
    end
    createSafetyFloor(k, 15 )w.CFrame =CFrame.new (k)w.AssemblyLinearVelocity =Vector3.zero state.statusText = "[Place] Placing All Eggs to Stand..."
    local V=os.clock ()+ 3
    while countCarriedEggs()> 0 and(os.clock ()<V and state.alive )do
        placeInventoryEggs()task.wait ( 0.06 )
    end
    state.statusText = "[Place] Hatching ready eggs..." hatchReadyEggs( true )stashEquippedTools()state.isReturning = false state.delivering = false state.currentTargetModel =nil state.targetPosition =nil
    local H=countCarriedEggs()state.statusText =string.format ( "Placed & Hatched (Left: %d)! Hands Free." ,H)
end
local AUTO_PLACE_BATCH_SIZE= 5 runBatchAutoPlace=function(e,...)
    if state.isBatchPlacing then
        return
    end
    state.isBatchPlacing = true logInfo(string.format ( "[AutoPlace] %d steals done! Batch placing (%s mode)..." ,AUTO_PLACE_BATCH_SIZE,tostring(e)))
    local r=farmSessionId state.pureTweenFarm =(e== "TWEEN" )state.autoFarmLoop =(e== "WARP" )
    local y=LocalPlayer.Character
    local u=y and y:FindFirstChild( "HumanoidRootPart" )
    local w=y and y:FindFirstChildOfClass( "Humanoid" )
    local j=getBaseDropPosition()
    local k=u and((u.Position -j)).Magnitude or 999
    if k> 8 then
        state.statusText = "[AutoPlace] Tweening home to base plot..." tweenHomeToBase(state.glideSpeed or 600 ,r, true )
    end
    if u then
        createSafetyFloor(j, 20 )u.CFrame =CFrame.new (j)u.AssemblyLinearVelocity =Vector3.zero u.AssemblyAngularVelocity =Vector3.zero
        if w then
            w.AutoRotate = true
        end
    end
    task.spawn (function(...) pcall(placeInventoryEggs)pcall(hatchReadyEggs, true )
    end
    )stashEquippedTools()state.isReturning = false state.delivering = false state.glidingToTarget = false state.securingEgg = false state.teleporting = false state.currentTargetModel =nil state.targetPosition =nil
    for e= 5 , 1 , -1 do
        if not state.alive then
            break
        end
        state.statusText =string.format ( "[AutoPlace] At Base: Resuming in %ds..." ,e)task.wait ( 1 )
    end
    state.isBatchPlacing = false
    if state.alive and farmSessionId==r then
        logInfo(string.format ( "[AutoPlace] Done! Continuing %s farm." ,e))state.statusText =string.format ( "[AutoPlace] Resuming %s farm..." ,e)
        if e== "TWEEN" then
            state.pureTweenFarm = true state.autoFarmLoop = false
        elseif e== "WARP" then
            state.autoFarmLoop = true state.pureTweenFarm = false
        end
        currentFarmMode=e
    end
end
countStealAndMaybeBatchPlace=function(e,...)
    if not state.autoPlaceEvery5 then
        return false
    end
    state.batchStealCount =((state.batchStealCount or 0 ))+ 1 logInfo(string.format ( "[AutoPlace] Steal trip %d / %d completed successfully." ,state.batchStealCount ,AUTO_PLACE_BATCH_SIZE))
    if state.batchStealCount >=AUTO_PLACE_BATCH_SIZE then
        state.batchStealCount = 0 task.spawn (function(...) runBatchAutoPlace(e)
        end
        )
        return true
    end
    return false
end
local function glideToCFrame(e,r,u,w,...)
    local j=LocalPlayer.Character
    local k=j and j:FindFirstChild( "HumanoidRootPart" )
    local a=j and j:FindFirstChildOfClass( "Humanoid" )
    if not k then
        return false
    end
    if a then
        a.AutoRotate = false
    end
    r=math.max ( 60 ,r or state.glideSpeed or 350 )
    local V=e.Position createSafetyFloor(V, 14 )pcall(function(...) LocalPlayer:RequestStreamAroundAsync(V)
    end
    )k.AssemblyLinearVelocity =Vector3.zero k.AssemblyAngularVelocity =Vector3.zero
    local H=state.laneZ or SAFE_LANE_Z state.glidingToTarget = true state.stateTime =os.clock ()
    local t= 0
    local s=os.clock ()+ 15
    while state.alive and(state.glidingToTarget and os.clock ()<s)do
        if w and farmSessionId~=w then
            if a then
                a.AutoRotate = true
            end
            state.glidingToTarget = false
            return false
        end
        if not state.pureTweenFarm and(not state.autoFarmLoop and not state.teleporting )then
            if a then
                a.AutoRotate = true
            end
            state.glidingToTarget = false
            return false
        end
        local e=k.Position
        local j=((V-e)).Magnitude
        local o=((Vector2.new (e.X ,e.Z )-Vector2.new (V.X ,V.Z ))).Magnitude
        local s=math.abs (e.Y -V.Y )
        if j<= 6 or(o<= 3.5 and s<= 6 )then
            break
        end
        local B=RunService.Heartbeat :Wait()e=k.Position j=((V-e)).Magnitude o=((Vector2.new (e.X ,e.Z )-Vector2.new (V.X ,V.Z ))).Magnitude
        local J=math.abs (e.X -V.X )
        if u and(os.clock ()-t> 0.5 )then
            t=os.clock ()
            local e,r=checkEggAvailability(u)
            if not e and r== "CarriedByOther" then
                if a then
                    a.AutoRotate = true
                end
                state.glidingToTarget = false
                return false
            end
        end
        local K=V.Z
        if J> 40 then
            K=H
        end
        local c=math.sign (V.X -e.X )
        local v=c*math.min (math.abs (V.X -e.X ),r*B)
        local i=e.X +v
        local R=(o<= 25 )and 1.2 or 0.5
        local g=math.sign (V.Y -e.Y )
        local Q=g*math.min (math.abs (V.Y -e.Y ),(r*B)*R)
        local P=e.Y +Q
        local N=K-e.Z
        local U=math.sign (N)*math.min (math.abs (N),r*B)
        local l=e.Z +U
        local D= false
        if o> 25 then
            local e=getTrapHitboxes()
            for e,y in ipairs(e)do
                local u=y.Position
                local w=((Vector3.new (i,P,l)-u)).Magnitude
                local j=math.abs (i-u.X )
                local k=math.abs (l-u.Z )
                if w< 22 or(j< 18 and k< 14 )then
                    D= true
                    local e=u.Y + 16
                    if P<e then
                        P=math.min (P+((r*B)* 1.5 ),e)
                    end
                    break
                end
            end
        end
        local C=Vector3.new (i,P,l)
        local q=((C-e)).Magnitude > 0.05 and((C-e)).Unit or k.CFrame.LookVector k.CFrame =CFrame.lookAt (C,C+q)k.AssemblyLinearVelocity =Vector3.zero k.AssemblyAngularVelocity =Vector3.zero
        if D then
            state.statusText =string.format ( "Gliding Out (Z: %.0f) [DODGING TRAP!]" ,l)
        else
            state.statusText =string.format ( "Gliding -> Egg (%.0f studs | H: %.0f)" ,j,o)
        end
    end
    k.CFrame =e*CFrame.new ( 0 , 0.4 , 0 )k.AssemblyLinearVelocity =Vector3.zero k.AssemblyAngularVelocity =Vector3.zero
    if a then
        a.AutoRotate = true
    end
    state.glidingToTarget = false
    return true
end
glideToTargetViaWaypoint=function(e,r,y,u,...)
    local w=LocalPlayer.Character
    local j=w and w:FindFirstChild( "HumanoidRootPart" )
    if j then
        local w=j.Position.X
        local a=e.Position.X
        if w<= 535 and a> 510 then
            local e=CFrame.new ( 500 , 70 , -364 )
            local a=((j.Position -e.Position )).Magnitude
            if a> 5 then
                state.statusText = "[AutoSteal] Exiting Base -> Waypoint (500, 70, -364)..." logInfo(string.format ( "[AutoSteal] Leaving base (X=%.1f): Gliding to waypoint (500, 70, -364) first (dist=%.1f studs)..." ,w,a))
                local j=glideToCFrame(e,r,y,u)
                if not j then
                    return false
                end
                task.wait ( 0.04 )
            end
        end
    end
    return glideToCFrame(e,r,y,u)
end
returnToSafeLine=function(e,r,eggUid,returnMode,...)
    local u=LocalPlayer.Character
    local w=u and u:FindFirstChild("HumanoidRootPart")
    local j=u and u:FindFirstChildOfClass("Humanoid")
    if not w then return false end

    if j then j.AutoRotate = false end

    local k=state.laneZ or SAFE_LANE_Z
    e=math.max(100,e or state.glideSpeed or 350)
    state.isReturning = true
    state.stateTime = os.clock()
    pcall(stashEquippedTools)
    w.AssemblyLinearVelocity = Vector3.zero
    w.AssemblyAngularVelocity = Vector3.zero

    local returnStartPos = w.Position
    local cruiseY = returnStartPos.Y + 50
    local ascendX = returnStartPos.X
    local ascendZ = returnStartPos.Z
    local a = Vector3.new(BASE_EDGE_X - 10, cruiseY, k)
    createSafetyFloor(Vector3.new(BASE_EDGE_X, cruiseY, k), 20)

    local V=getCarriedEggReturnSpeed()
    local H=math.max(e,V)
    local ascendSpeed=math.max(220,H*0.85)
    local s=os.clock()+22
    local lastReturnEggCheck=0
    local ascentComplete=false
    do
        local diag = Vector3.new(math.max(BASE_EDGE_X + 8, returnStartPos.X - 26), cruiseY,
            returnStartPos.Z + math.clamp(k - returnStartPos.Z, -12, 12))
        local face = w.CFrame.LookVector
        if Vector3.new(face.X, 0, face.Z).Magnitude < 0.01 then face = Vector3.new(-1,0,0) end
        w.CFrame = CFrame.lookAt(diag, diag + face)
        w.AssemblyLinearVelocity = Vector3.zero
        w.AssemblyAngularVelocity = Vector3.zero
        ascendX, ascendZ = diag.X, diag.Z
        ascentComplete = true
    end

    state.returnEggUid=eggUid or state.returnEggUid
    state.returnEggMode=returnMode or state.returnEggMode or "WARP"
    state.returnEggSession=r or state.returnEggSession
    state.returnMissionComplete=false

    while state.alive and state.isReturning and os.clock()<s do
        if r and farmSessionId~=r then
            logWarn("[Return] Aborted by session switch!")
            if j then j.AutoRotate=true end
            state.isReturning=false
            return false
        end
        if not state.pureTweenFarm and not state.autoFarmLoop then
            logWarn("[Return] Aborted (all farms disabled)")
            if j then j.AutoRotate=true end
            state.isReturning=false
            return false
        end

        local missionUid=state.returnEggUid or eggUid
        local missionMode=state.returnEggMode or returnMode or "WARP"
        if r and missionUid and (os.clock()-lastReturnEggCheck)>=0.12 then
            lastReturnEggCheck=os.clock()
            if not hasEggInInventory(missionUid) then
                state.returnRecoveryActive=true
                local recovered=recoverDroppedEggDuringReturn(missionUid,missionMode,r)
                if not recovered then
                    if j then j.AutoRotate=true end
                    state.isReturning=false
                    return false
                end

                w=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not w then
                    if j then j.AutoRotate=true end
                    state.isReturning=false
                    return false
                end
                w.AssemblyLinearVelocity=Vector3.zero
                w.AssemblyAngularVelocity=Vector3.zero
                ascendX=w.Position.X
                ascendZ=w.Position.Z
                ascentComplete=w.Position.Y>=(cruiseY-2)
            end
        end

        local current=w.Position

        if not ascentComplete then
            local dt=RunService.Heartbeat:Wait()
            current=w.Position
            local dy=cruiseY-current.Y
            if math.abs(dy)<=2 then
                ascentComplete=true
                local pos=Vector3.new(current.X,cruiseY,current.Z)
                local look=w.CFrame.LookVector
                w.CFrame=CFrame.lookAt(pos,pos+look)
            else
                local step=math.sign(dy)*math.min(math.abs(dy),ascendSpeed*dt)
                local nextPos=Vector3.new(ascendX,current.Y+step,ascendZ)
                local look=w.CFrame.LookVector
                if Vector3.new(look.X,0,look.Z).Magnitude<0.01 then
                    look=Vector3.new(-1,0,0)
                end
                w.CFrame=CFrame.lookAt(nextPos,nextPos+look)
            end
            w.AssemblyLinearVelocity=Vector3.zero
            w.AssemblyAngularVelocity=Vector3.zero
            state.statusText=string.format("Return ascent: %.0f / %.0f studs",w.Position.Y,cruiseY)
        else
            local distance=(a-current).Magnitude
            if current.X<=(BASE_EDGE_X+10) or distance<=6 then
                if eggUid and not hasEggInInventory(eggUid) then
                    local recovered=recoverDroppedEggDuringReturn(eggUid,returnMode or "WARP",r)
                    if not recovered then
                        if j then j.AutoRotate=true end
                        state.isReturning=false
                        return false
                    end
                    w=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not w then return false end
                    ascendX=w.Position.X
                    ascendZ=w.Position.Z
                    ascentComplete=w.Position.Y>=(cruiseY-2)
                else
                    stashEquippedTools()
                    break
                end
            else
                if u then
                    for _,child in ipairs(u:GetChildren()) do
                        if child:IsA("Tool") then
                            pcall(stashEquippedTools)
                            break
                        end
                    end
                end

                local dt=RunService.Heartbeat:Wait()
                current=w.Position
                local speed=H
                if current.X<=FIELD_SLOWDOWN_X and current.X>BASE_EDGE_X then
                    local ratio=math.clamp((current.X-BASE_EDGE_X)/(FIELD_SLOWDOWN_X-BASE_EDGE_X),0,1)
                    speed=BASE_RETURN_SPEED+((H-BASE_RETURN_SPEED)*ratio)
                elseif current.X<=BASE_EDGE_X then
                    speed=BASE_RETURN_SPEED
                end

                local dx=math.sign(a.X-current.X)*math.min(math.abs(a.X-current.X),speed*dt)
                local nextX=current.X+dx
                local dy=math.sign(cruiseY-current.Y)*math.min(math.abs(cruiseY-current.Y),(speed*dt)*0.75)
                local nextY=current.Y+dy
                local dz=math.sign(k-current.Z)*math.min(math.abs(k-current.Z),speed*dt)
                local nextZ=current.Z+dz

                local nextPos=Vector3.new(nextX,nextY,nextZ)
                local dir=(nextPos-current).Magnitude>0.05 and (nextPos-current).Unit or w.CFrame.LookVector
                w.CFrame=CFrame.lookAt(nextPos,nextPos+dir)
                w.AssemblyLinearVelocity=Vector3.zero
                w.AssemblyAngularVelocity=Vector3.zero
                state.statusText=string.format("Returning HIGH (Y: %.0f | %.0f studs | X: %.0f)",nextY,distance,current.X)
            end
        end
    end

    if eggUid and not hasEggInInventory(eggUid) then
        state.returnRecoveryActive=true
        local recovered=recoverDroppedEggDuringReturn(eggUid,returnMode or "WARP",r)
        if not recovered then
            if j then j.AutoRotate=true end
            state.isReturning=false
            state.returnMissionComplete=false
            state.returnEggUid=eggUid
            state.returnEggMode=returnMode or "WARP"
            state.returnEggSession=r
            logWarn(string.format("[Return] FINAL UID %s not secured; refusing completion/new target.",tostring(eggUid)))
            return false
        end
        w=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or w
    end

    w.CFrame=CFrame.new(BASE_EDGE_X,math.max(cruiseY,w.Position.Y),k)
    w.AssemblyLinearVelocity=Vector3.zero
    w.AssemblyAngularVelocity=Vector3.zero
    if j then j.AutoRotate=true end
    stashEquippedTools()

    state.returnMissionComplete=true
    state.returnRecoveryActive=false
    state.returnEggUid=nil
    state.returnEggMode=nil
    state.returnEggSession=nil
    state.returnRecoveryCount=0
    state.returnDropGeneration=0
    state.isReturning=false
    state.delivering=false
    state.statusText="Arrived at Safe Line HIGH (real HRP +80 studs)."
    return true
end
local function hideNotEnoughMoneyLabels(...)
    if not state or not state.hideNotEnoughMoney then
        return
    end
    local e=LocalPlayer:FindFirstChild( "PlayerGui" )
    if not e then
        return
    end
    pcall(function(...)
        for e,y in ipairs(e:GetDescendants())do
            if y:IsA( "TextLabel" )and y.Visible then
                local e=(tostring(y.Text or "" )):lower()
                if e:find( "not enough money" )or e:find( "not enough cash" )or(e:find( "not enough" )and((e:find( "money" )or e:find( "cash" )or e:find( "coin" )or e:find( "fund" ))))then
                    y.Visible = false y.TextTransparency = 1 y.TextStrokeTransparency = 1
                    local e=y.Parent
                    if e and(((e:IsA( "Frame" )or e:IsA( "CanvasGroup" )))and#e:GetChildren()<= 3 )then
                        e.Visible = false
                    end
                end
            end
        end
    end
    )
end
local function installMoneyAlertSuppressor(...)
    local e=LocalPlayer:FindFirstChild( "PlayerGui" )
    if not e then
        return
    end
    local function r(e,...)
        if e:IsA( "TextLabel" )then
            local function y(...)
                if not state or not state.hideNotEnoughMoney then
                    return
                end
                local y=(tostring(e.Text or "" )):lower()
                if y:find( "not enough money" )or y:find( "not enough cash" )or(y:find( "not enough" )and((y:find( "money" )or y:find( "cash" )or y:find( "coin" )or y:find( "fund" ))))then
                    e.Visible = false e.TextTransparency = 1 e.TextStrokeTransparency = 1
                    local r=e.Parent
                    if r and(((r:IsA( "Frame" )or r:IsA( "CanvasGroup" )))and#r:GetChildren()<= 3 )then
                        r.Visible = false
                    end
                end
            end
            y();
            (e:GetPropertyChangedSignal( "Text" )):Connect(y);
            (e:GetPropertyChangedSignal( "Visible" )):Connect(function(...)
                if e.Visible then
                    y()
                end
            end
            )
        end
    end
    pcall(function(...)
        for e,y in ipairs(e:GetDescendants())do
            task.spawn (r,y)
        end
        e.DescendantAdded :Connect(r)
    end
    )task.spawn (function(...)
        while state and state.alive do
            if state.hideNotEnoughMoney then
                hideNotEnoughMoneyLabels()
            end
            task.wait ( 0.25 )
        end
    end
    )
end
task.spawn (installMoneyAlertSuppressor)
local function parseCashText(e,...)
    if not e then
        return 0
    end
    local r=(((tostring(e)):gsub( "[$,]" , "" )):gsub( "%s+" , "" )):lower()
    local y=r:match( "[%d%.]+" )
    if not y then
        return 0
    end
    local u=tonumber(y)
    if not u then
        return 0
    end
    if r:find( "sp" )then
        return u* 999999999999999983222784
    elseif r:find( "sx" )then
        return u* 1000000000000000000000
    elseif r:find( "qi" )then
        return u* 1000000000000000000
    elseif r:find( "qa" )or r:find( "q" )then
        return u* 1000000000000000
    elseif r:find( "t" )then
        return u* 1000000000000
    elseif r:find( "b" )then
        return u* 1000000000
    elseif r:find( "m" )then
        return u* 1000000
    elseif r:find( "k" )then
        return u* 1000
    end
    return u
end
local function getPlayerMoney(...)
    local e=LocalPlayer:FindFirstChild( "leaderstats" )
    if e then
        for r,u in ipairs({ "Money" , "Cash" , "Coins" ;
            "Currency" })do
            local w=e:FindFirstChild(u)
            if w then
                local e=tonumber(w.Value )or parseCashText(w.Value )
                if e and e> 0 then
                    return e
                end
            end
        end
    end
    local r=LocalPlayer:FindFirstChild( "PlayerGui" )
    if r then
        local e=r:FindFirstChild( "HUD" )or r:FindFirstChild( "GameHUD" )or r:FindFirstChild( "MainHUD" )or r:FindFirstChild( "Main" )
        if e then
            for e,r in ipairs(e:GetDescendants())do
                if r:IsA( "TextLabel" )and r.Visible then
                    local e=r.Name :lower()
                    if e== "money" or e== "cash" or e== "coins" or e== "currency" or e== "value" then
                        local e=parseCashText(r.Text )
                        if e and e> 0 then
                            return e
                        end
                    end
                end
            end
        end
    end
    return 0
end
local function getTreadmillUpgradeCost(...)
    local e=state.plot or(findPlayerPlot and findPlayerPlot())
    if not e then
        return nil
    end
    local r=e:FindFirstChild( "TreadmillUpgrade" , true )
    if not r then
        return nil
    end
    local y=nil
    for e,r in ipairs(r:GetDescendants())do
        if r:IsA( "TextLabel" )or r:IsA( "TextButton" )then
            local e=tostring(r.Text or "" )
            local w=e:match( "%$([%d%.,]+%s*[kKmMbBtTqQ]?[aA]?)" )
            if w then
                local e=parseCashText(w)
                if e and e> 0 then
                    if not y or e>y then
                        y=e
                    end
                end
            end
        end
    end
    return y
end
local lastTreadmillUpgradeAttempt= 0
local TREADMILL_UPGRADE_COOLDOWN= 10
local function tryUpgradeTreadmill(...)
    if not state.autoUpgradeTreadmill then
        return
    end
    if os.clock ()-lastTreadmillUpgradeAttempt<TREADMILL_UPGRADE_COOLDOWN then
        return
    end
    local e=state.plot or(findPlayerPlot and findPlayerPlot())
    if not e then
        return
    end
    local r=e:FindFirstChild( "TreadmillUpgrade" , true )
    if not r then
        return
    end
    local y=getPlayerMoney()
    local u=getTreadmillUpgradeCost()
    if u and(u> 0 and y<u)then
        return
    end
    lastTreadmillUpgradeAttempt=os.clock ()
    if TreadmillUpgradeRemote then
        pcall(function(...) TreadmillUpgradeRemote:InvokeServer()
        end
        )
    end
    local w=LocalPlayer.Character
    local j=w and w:FindFirstChild( "HumanoidRootPart" )pcall(function(...)
        for r,y in ipairs(r:GetDescendants())do
            if y:IsA( "ProximityPrompt" )and y.Enabled then
                if typeof(fireproximityprompt)== "function" then
                    fireproximityprompt(y, 0 )fireproximityprompt(y)
                end
            end
            if y:IsA( "GuiButton" )and y.Visible then
                local r=(y:IsA( "TextButton" )and y.Text )or y.Name
                local u=string.lower (r)
                if not string.find (u, "robux" )and(not string.find (u, "r%$" )and((string.find (u, "%$" )or string.find (u, "upgrade" )or string.find (u, "cash" )or(y.BackgroundColor3 and y.BackgroundColor3.G >y.BackgroundColor3.R ))))then
                    if typeof(firesignal)== "function" and y.Activated then
                        firesignal(y.Activated )
                    elseif typeof(firesignal)== "function" and y.MouseButton1Click then
                        firesignal(y.MouseButton1Click )
                    end
                end
            end
            if y:IsA( "BasePart" )and(y.Name :find( "Pad" )and j)then
                if((j.Position -y.Position )).Magnitude < 10 then
                    if typeof(firetouchinterest)== "function" then
                        firetouchinterest(j,y, 0 )task.wait ( 0.02 )firetouchinterest(j,y, 1 )
                    end
                end
            end
        end
    end
    )
end
local TRAIL_CATALOG={{[ "id" ]= "GreyTrail" ,[ "base" ]= "Grey" ,[ "name" ]= "Grey Trail" ;
[ "price" ]= 100 ;
[ "mult" ]= 1.5 },{[ "id" ]= "GreenTrail" ;
[ "base" ]= "Green" ,[ "name" ]= "Green Trail" ;
[ "price" ]= 5000 ;
[ "mult" ]= 2 },{[ "id" ]= "BlueTrail" ,[ "base" ]= "Blue" ;
[ "name" ]= "Blue Trail" ;
[ "price" ]= 75000 ;
[ "mult" ]= 2.5 };
{[ "id" ]= "PurpleTrail" ,[ "base" ]= "Purple" ;
[ "name" ]= "Purple Trail" ;
[ "price" ]= 1500000 ;
[ "mult" ]= 3 },{[ "id" ]= "GoldenTrail" ,[ "base" ]= "Golden" ;
[ "name" ]= "Golden Trail" ;
[ "price" ]= 1500000 ;
[ "mult" ]= 3.5 };
{[ "id" ]= "RedTrail" ;
[ "base" ]= "Red" ,[ "name" ]= "Red Trail" ;
[ "price" ]= 750000000 ,[ "mult" ]= 4 },{[ "id" ]= "GalaxyTrail" ,[ "base" ]= "Galaxy" ,[ "name" ]= "Galaxy Trail" ;
[ "price" ]= 20000000000 ,[ "mult" ]= 5 },{[ "id" ]= "SecretTrail" ;
[ "base" ]= "Secret" ;
[ "name" ]= "Secret Trail" ,[ "price" ]= 500000000000 ,[ "mult" ]= 6 };
{[ "id" ]= "EternalTrail" ;
[ "base" ]= "Eternal" ,[ "name" ]= "Eternal Trail" ,[ "price" ]= 1000000000 ;
[ "mult" ]= 10 };
{[ "id" ]= "DivineTrail" ,[ "base" ]= "Divine" ;
[ "name" ]= "Divine Trail" ,[ "price" ]= 300000000000000 ;
[ "mult" ]= 14 };
{[ "id" ]= "MoonbloomTrail" ,[ "base" ]= "Moonbloom" ;
[ "name" ]= "Moonbloom Trail" ,[ "price" ]= 5000000000000000 ,[ "mult" ]= 20 }}
local function getTrailCatalog(...)
    return TRAIL_CATALOG
end
local function readOwnedTrailsFromGui(...)
    local e={}
    local r=LocalPlayer:FindFirstChild( "PlayerGui" )
    local y=r and((r:FindFirstChild( "TrailShop" )or r:FindFirstChild( "TrailShop" , true )))
    local u=y and y:FindFirstChild( "ScrollingFrame" , true )
    if u then
        pcall(function(...)
            for y,u in ipairs(u:GetChildren())do
                if u:IsA( "GuiObject" )and(not u:IsA( "UIListLayout" )and not u:IsA( "UIPadding" ))then
                    local y=u.Name
                    for u,w in ipairs(u:GetDescendants())do
                        if w:IsA( "GuiButton" )or w:IsA( "TextButton" )then
                            local u=(w:IsA( "TextButton" )and w.Text :lower())or w.Name :lower()
                            if u:find( "unequip" )or(u:find( "equip" )and not u:find( "unequip" ))then
                                e[y]= true e[y:lower()]= true
                                local u=y:gsub( "Trail" , "" )e[u]= true e[u:lower()]= true
                            end
                        end
                    end
                end
            end
        end
        )
    end
    return e
end
local function clickGuiButton(e,...)
    if not e then
        return false
    end
    pcall(function(...)
        if typeof(firebutton1click)== "function" then
            firebutton1click(e)
        elseif typeof(firesignal)== "function" and e.Activated then
            firesignal(e.Activated )
        elseif typeof(firesignal)== "function" and e.MouseButton1Click then
            firesignal(e.MouseButton1Click )
        end
    end
    )
    return true
end
local function equipBestOwnedTrail(...)
    local e=getTrailCatalog()
    local r=readOwnedTrailsFromGui()
    local y=LocalPlayer:FindFirstChild( "PlayerGui" )
    local u=y and((y:FindFirstChild( "TrailShop" )or y:FindFirstChild( "TrailShop" , true )))
    local w=u and u:FindFirstChild( "ScrollingFrame" , true )
    if w then
        for r=#e, 1 , -1 do
            local y=e[r]
            local u=w:FindFirstChild(y.id )or w:FindFirstChild(y.base )or w:FindFirstChild(y.name )
            if not u then
                for e,r in ipairs(w:GetChildren())do
                    if r:IsA( "GuiObject" )and((r.Name :lower()==y.id :lower()or r.Name :lower()==y.base :lower()or r.Name :lower()==y.name :lower()))then
                        u=r
                        break
                    end
                end
            end
            if u then
                local e= false
                local r=nil
                for y,u in ipairs(u:GetDescendants())do
                    if u:IsA( "GuiButton" )or u:IsA( "TextButton" )then
                        local y=(u:IsA( "TextButton" )and u.Text :lower())or u.Name :lower()
                        if y:find( "unequip" )then
                            e= true
                            break
                        elseif y:find( "equip" )and not y:find( "unequip" )then
                            r=u
                        end
                    end
                end
                if e then
                    return true
                end
                if r then
                    clickGuiButton(r)
                    if TrailEquipRemote then
                        pcall(function(...) TrailEquipRemote:InvokeServer(y.id )
                        end
                        )
                    end
                    task.wait ( 0.2 )
                    return true
                end
            end
        end
    end
    if TrailEquipRemote then
        for y=#e, 1 , -1 do
            local u=e[y]
            local w=r[u.id ]or r[u.id :lower()]or r[u.base ]or r[u.base :lower()]or r[u.name ]or r[u.name :lower()]
            if w then
                pcall(function(...) TrailEquipRemote:InvokeServer(u.id )
                end
                )
                return true
            end
        end
    end
    return false
end
local lastTrailBuyAttempt= 0
local TRAIL_BUY_COOLDOWN= 8
local function buyAndEquipBestTrail(...)
    if not state.autoBuyTrails then
        return
    end
    equipBestOwnedTrail()
    if os.clock ()-lastTrailBuyAttempt<TRAIL_BUY_COOLDOWN then
        return
    end
    local e=getPlayerMoney()
    if e<= 0 then
        return
    end
    local r=getTrailCatalog()
    local y=readOwnedTrailsFromGui()
    local u=LocalPlayer:FindFirstChild( "PlayerGui" )
    local w=u and((u:FindFirstChild( "TrailShop" )or u:FindFirstChild( "TrailShop" , true )))
    local j=w and w:FindFirstChild( "ScrollingFrame" , true )
    for u=#r, 1 , -1 do
        local w=r[u]
        local a=y[w.id ]or y[w.id :lower()]or y[w.base ]or y[w.base :lower()]or y[w.name ]or y[w.name :lower()]
        if not a and(w.price > 0 and e>=w.price )then
            lastTrailBuyAttempt=os.clock ()
            local e= false
            if j then
                local r=j:FindFirstChild(w.id )or j:FindFirstChild(w.base )or j:FindFirstChild(w.name )
                if not r then
                    for e,y in ipairs(j:GetChildren())do
                        if y:IsA( "GuiObject" )and((y.Name :lower()==w.id :lower()or y.Name :lower()==w.base :lower()or y.Name :lower()==w.name :lower()))then
                            r=y
                            break
                        end
                    end
                end
                if r then
                    for r,y in ipairs(r:GetDescendants())do
                        if y:IsA( "GuiButton" )or y:IsA( "TextButton" )then
                            local r=(y:IsA( "TextButton" )and y.Text :lower())or y.Name :lower()
                            if not r:find( "robux" )and(not r:find( "r%$" )and(not r:find( "unequip" )and not r:find( "equip" )))then
                                if r:find( "%$" )or r:find( "buy" )then
                                    clickGuiButton(y)e= true
                                    break
                                end
                            end
                        end
                    end
                end
            end
            if TrailPurchaseRemote then
                pcall(function(...) TrailPurchaseRemote:InvokeServer(w.id )
                end
                )e= true
            end
            if e then
                task.wait ( 0.3 )equipBestOwnedTrail()
                break
            end
        end
    end
end
findLakeStarterEgg=function(...)
    local e=LocalPlayer.Character
    local y=e and e:FindFirstChild( "HumanoidRootPart" )
    if not y then
        return nil
    end
    local u={}
    local w=Workspace:FindFirstChild( "AreaEggSlotsClient" )
    local j=readFieldEggs( false )
    if j and#j> 0 then
        for e,r in ipairs(j)do
            local w=(r.State == "Slot" or r.State == "Dropped" or r.State == 1 )
            local j=(r.AreaId == "Lake" )or(string.find (string.lower (tostring(r.AreaId )), "lake" )~=nil)or(string.find (string.lower (tostring(r.Uid )), "lake" )~=nil)
            local k=targetCooldownUntil[r.Uid ]and(os.clock ()<targetCooldownUntil[r.Uid ])
            if w and(j and(r.BoundsCFrame and not k))then
                local e=r.BoundsCFrame.Position
                local w=((y.Position -e)).Magnitude table.insert (u,{[ "Uid" ]=r.Uid ;
                [ "Model" ]=nil;
                [ "Hitbox" ]=nil;
                [ "CFrame" ]=r.BoundsCFrame ,[ "Position" ]=e,[ "Distance" ]=w;
                [ "Area" ]= "Lake" })
            end
        end
    end
    if#u== 0 and(j and#j> 0 )then
        for e,r in ipairs(j)do
            local w=(r.State == "Slot" or r.State == "Dropped" or r.State == 1 )
            local j=r.BoundsCFrame and r.BoundsCFrame.Position
            local k=j and((j.X >= 545 and j.X < 850 ))
            local o=targetCooldownUntil[r.Uid ]and(os.clock ()<targetCooldownUntil[r.Uid ])
            if w and(k and not o)then
                table.insert (u,{[ "Uid" ]=r.Uid ,[ "Model" ]=nil;
                [ "Hitbox" ]=nil;
                [ "CFrame" ]=r.BoundsCFrame ;
                [ "Position" ]=j;
                [ "Distance" ]=((y.Position -j)).Magnitude ;
                [ "Area" ]=r.AreaId or "Field" })
            end
        end
    end
    if#u== 0 then
        return nil
    end
    table.sort (u,function(e,r,...)
        return e.Distance <r.Distance
    end
    )
    local k=u[ 1 ]
    if k and w then
        for e,r in ipairs(w:GetChildren())do
            local y=r:FindFirstChildWhichIsA( "BasePart" )or r.PrimaryPart
            if y and((y.Position -k.Position )).Magnitude <= 8 then
                k.Model =r
                break
            end
        end
    end
    return k
end
local cachedLightDarkCenter=nil
local cachedLightDarkCFrame=nil
local cachedLightDarkRadius= 350
local function findLightDarkAreaContainer(...)
    local e=Workspace:FindFirstChild( "__OBJECTS" )or Workspace:FindFirstChild( "Objects" )
    local y=e and((e:FindFirstChild( "Areas" )or e:FindFirstChild( "Area" )))
    local u=y and((y:FindFirstChild( "GuardAreas" )or y:FindFirstChild( "Guards" )))
    if u then
        local e=u:FindFirstChild( "Light Dark" )or u:FindFirstChild( "LightDark" )or u:FindFirstChild( "Light_Dark" )or u:FindFirstChild( "Light-Dark" )
        if e then
            return e
        end
        for e,r in ipairs(u:GetChildren())do
            local y=string.lower (r.Name )
            if string.find (y, "light" )and string.find (y, "dark" )then
                return r
            end
        end
    end
    if y then
        local e=y:FindFirstChild( "Light Dark" )or y:FindFirstChild( "LightDark" )or y:FindFirstChild( "Light_Dark" )
        if e then
            return e
        end
        for e,r in ipairs(y:GetChildren())do
            local y=string.lower (r.Name )
            if string.find (y, "light" )and string.find (y, "dark" )then
                return r
            end
        end
    end
    for e,r in ipairs(Workspace:GetChildren())do
        local y=r.Name
        if y== "__OBJECTS" or y== "Objects" or y== "Areas" or y== "Map" then
            for e,r in ipairs(r:GetDescendants())do
                local y=string.lower (r.Name )
                if(y== "light dark" or y== "lightdark" or(string.find (y, "light" )and string.find (y, "dark" )))then
                    if r:IsA( "BasePart" )or r:IsA( "Model" )or r:IsA( "Folder" )then
                        return r
                    end
                end
            end
        end
    end
    return nil
end
local function isPositionInLightDarkArea(e,...)
    if not e then
        return false
    end
    if cachedLightDarkCenter then
        local r=((Vector3.new (e.X , 0 ,e.Z )-Vector3.new (cachedLightDarkCenter.X , 0 ,cachedLightDarkCenter.Z ))).Magnitude
        if r<=cachedLightDarkRadius then
            return true
        end
    end
    local r=findLightDarkAreaContainer()
    if not r then
        if e.X >= 5200 then
            return true
        end
        return false
    end
    local y= false pcall(function(...)
        local u,w=nil,nil
        if r:IsA( "BasePart" )then
            u=r.CFrame w=r.Size
        elseif r:IsA( "Model" )then
            u,w=r:GetBoundingBox()
        else
            local e,y=nil,nil
            for r,u in ipairs(r:GetChildren())do
                if u:IsA( "BasePart" )then
                    local r=u.CFrame
                    local w=u.Size / 2
                    local k=r.Position -w
                    local a=r.Position +w
                    if not e then
                        e=k y=a
                    else
                        e=Vector3.new (math.min (e.X ,k.X ),math.min (e.Y ,k.Y ),math.min (e.Z ,k.Z ))y=Vector3.new (math.max (y.X ,a.X ),math.max (y.Y ,a.Y ),math.max (y.Z ,a.Z ))
                    end
                end
            end
            if e and y then
                u=CFrame.new (((e+y))/ 2 )w=y-e
            end
        end
        if u and w then
            cachedLightDarkCenter=u.Position cachedLightDarkCFrame=u cachedLightDarkRadius=math.max ( 350 ,math.max (w.X ,w.Z )/ 2 + 150 )
            local r=((Vector3.new (e.X , 0 ,e.Z )-Vector3.new (u.Position.X , 0 ,u.Position.Z ))).Magnitude
            if r<=cachedLightDarkRadius then
                y= true
                return
            end
            local k=u:PointToObjectSpace(e)
            local a=w/ 2
            if math.abs (k.X )<=(a.X + 200 )and math.abs (k.Z )<=(a.Z + 200 )then
                y= true
                return
            end
        end
        for r,u in ipairs(r:GetDescendants())do
            if u:IsA( "BasePart" )then
                if((e-u.Position )).Magnitude <= 250 then
                    y= true
                    if not cachedLightDarkCenter then
                        cachedLightDarkCenter=u.Position
                    end
                    return
                end
            end
        end
    end
    )
    return y
end
local function detectEggZone(e,r,y,...)
    local u=r and r.X or 0
    local w=string.lower (tostring(e or "" ))
    local j=string.lower (tostring(y or "" ))
    if j~= "" and j~= "egg" then
        if string.find (j, "spideron" )or string.find (j, "crustacia" )or string.find (j, "bladehide" )or string.find (j, "mantaris" )or string.find (j, "rhinotaur" )or string.find (j, "mutantshark" )or string.find (j, "mutant shark" )or string.find (j, "gorillaking" )or string.find (j, "gorilla king" )or string.find (j, "nightflame" )then
            return "Titan Temple"
        end
        if string.find (j, "crane" )or string.find (j, "salamander" )or string.find (j, "redpanda" )or string.find (j, "red panda" )or string.find (j, "snowyowl" )or string.find (j, "snowy owl" )or string.find (j, "koiegg" )or string.find (j, "koi egg" )or string.find (j, "stagegg" )or string.find (j, "stag egg" )or string.find (j, "onitiger" )or string.find (j, "oni tiger" )or string.find (j, "kitsune" )then
            return "Cherry Blossom"
        end
        if string.find (j, "centapede" )or string.find (j, "cosmicgecko" )or string.find (j, "cosmic gecko" )or string.find (j, "cosmicgorilla" )or string.find (j, "cosmic gorilla" )or string.find (j, "saturno" )or string.find (j, "saturnita" )or string.find (j, "vacca" )or string.find (j, "cosmic skeleton" )or string.find (j, "skeletonboss" )or string.find (j, "skeleton boss" )or string.find (j, "cosmicdragon" )or string.find (j, "cosmic dragon" )or string.find (j, "lunardragon" )or string.find (j, "lunar dragon" )or string.find (j, "unicornegg" )or string.find (j, "unicorn egg" )then
            return "Cosmic"
        end
        if string.find (j, "dodo" )or string.find (j, "pterodactyl" )or string.find (j, "ankylosaurus" )or string.find (j, "triceratops" )or string.find (j, "bronto" )or string.find (j, "trex" )or string.find (j, "t-rex" )or string.find (j, "tralaledon" )or string.find (j, "mosasaurus" )then
            return "Prehistoric"
        end
        if string.find (j, "parrotfish" )or string.find (j, "swordfish" )or string.find (j, "whaleshark" )or string.find (j, "whale shark" )or string.find (j, "belugawhale" )or string.find (j, "beluga whale" )or string.find (j, "kraken" )or string.find (j, "elmaja" )or string.find (j, "el maja" )then
            return "Abyss Ocean"
        end
        if string.find (j, "lava gecko" )or string.find (j, "lava frog" )or string.find (j, "flaming bull" )or string.find (j, "lava iguana" )or string.find (j, "chillin chilli" )or string.find (j, "cerberus" )or string.find (j, "phoenix" )or string.find (j, "lava dragon" )then
            return "Volcano"
        end
        if string.find (j, "penguin" )or string.find (j, "walrus" )or string.find (j, "polar bear" )or string.find (j, "polarbear" )or string.find (j, "sabertooth" )or string.find (j, "mammoth" )or string.find (j, "yeti" )or string.find (j, "ice dragon" )or string.find (j, "icedragon" )then
            return "Snow"
        end
        if string.find (j, "sand spider" )or string.find (j, "sandspider" )or string.find (j, "royal sphinx" )or string.find (j, "sphinx" )or string.find (j, "tob tobi" )or string.find (j, "tobtobi" )or string.find (j, "jerboa" )or string.find (j, "fennec" )or string.find (j, "camel" )then
            return "Desert"
        end
        if string.find (j, "chimpanzee" )or string.find (j, "toucan" )or string.find (j, "crocodile" )or string.find (j, "orangutini" )or string.find (j, "ananassini" )or string.find (j, "king snake" )or string.find (j, "kingsnake" )then
            return "Jungle"
        end
        if string.find (j, "duckling" )or string.find (j, "catfish" )or string.find (j, "turtle" )or string.find (j, "trulimero" )or string.find (j, "trulicina" )or string.find (j, "swan" )or string.find (j, "axolotl" )or string.find (j, "leviathan" )then
            return "Lake"
        end
        if string.find (j, "burrowing owl" )or string.find (j, "burrowingowl" )or string.find (j, "brr brr" )or string.find (j, "patapim" )or string.find (j, "chicken" )or string.find (j, "dog" )or string.find (j, "bird" )or string.find (j, "raccoon" )or string.find (j, "fox" )then
            return "Forest"
        end
        if string.find (j, "shark" )then
            return "Abyss Ocean"
        end
        if string.find (j, "snake" )then
            return "Desert"
        end
        if string.find (j, "spider" )then
            return "Jungle"
        end
        if string.find (j, "gorilla" )then
            return "Jungle"
        end
        if string.find (j, "tiger" )then
            return "Jungle"
        end
        if string.find (j, "frog" )then
            return "Lake"
        end
        if string.find (j, "bear" )then
            return "Forest"
        end
    end
    if(string.find (w, "light" )and string.find (w, "dark" ))or w== "lightdark" then
        return "Light Dark"
    elseif string.find (w, "titan" )then
        return "Titan Temple"
    elseif string.find (w, "cherry" )then
        return "Cherry Blossom"
    elseif string.find (w, "cosmic" )then
        return "Cosmic"
    elseif string.find (w, "prehistoric" )or string.find (w, "dino" )then
        return "Prehistoric"
    elseif string.find (w, "abyss" )or string.find (w, "ocean" )then
        return "Abyss Ocean"
    elseif string.find (w, "volcano" )or string.find (w, "lava" )then
        return "Volcano"
    elseif string.find (w, "snow" )or string.find (w, "ice" )or string.find (w, "winter" )then
        return "Snow"
    elseif string.find (w, "jungle" )then
        return "Jungle"
    elseif string.find (w, "desert" )or string.find (w, "sand" )then
        return "Desert"
    elseif string.find (w, "lake" )or string.find (w, "water" )then
        return "Lake"
    elseif string.find (w, "forest" )then
        return "Forest"
    end
    if u> 0 then
        if u>= 5200 then
            return "Light Dark"
        elseif u>= 4750 then
            return "Titan Temple"
        elseif u>= 4000 then
            return "Cherry Blossom"
        elseif u>= 3350 then
            return "Cosmic"
        elseif u>= 2780 then
            return "Prehistoric"
        elseif u>= 2250 then
            return "Abyss Ocean"
        elseif u>= 1850 then
            return "Volcano"
        elseif u>= 1450 then
            return "Snow"
        elseif u>= 1150 then
            return "Jungle"
        elseif u>= 920 then
            return "Desert"
        elseif u>= 720 then
            return "Lake"
        else
            return "Forest"
        end
    end
    return "Forest"
end
selectBestTargetEgg=function() return transferTarget end
secureEggWithGuardStrike=function(e,u,w,j,...)
    local character=LocalPlayer.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then
        return false
    end

    if j and farmSessionId~=j then
        return false
    end

    state.securingEgg=true
    state.isReturning=false
    state.stateTime=os.clock()
    state.holdingEggForGuard=true

    local targetPos=u.Position
    createSafetyFloor(targetPos,14)
    state.currentTargetModel=w
    state.targetPosition=targetPos
    root.AssemblyLinearVelocity=Vector3.zero
    root.AssemblyAngularVelocity=Vector3.zero
    suppressRagdoll(character)
    pcall(function()
        LocalPlayer:RequestStreamAroundAsync(targetPos)
    end)

    if not w and Workspace:FindFirstChild("AreaEggSlotsClient") then
        for _,candidate in ipairs(Workspace.AreaEggSlotsClient:GetChildren()) do
            local part=candidate:FindFirstChildWhichIsA("BasePart") or candidate.PrimaryPart
            if part and (part.Position-targetPos).Magnitude<=16 then
                w=candidate
                state.currentTargetModel=candidate
                break
            end
        end
    end

    state.statusText="Picking up target egg..."
    logInfo(string.format("[FastPickup] Picking target egg %s; return starts on first successful carry.",tostring(e)))

    local lastRemote=0
    local pickupPending=false
    local lastAvailability=0
    if HUB.AntiEggDrop then
        HUB.AntiEggDrop.SetEnabled(true)
        HUB.AntiEggDrop.lockedUid = e
    end
    HUB.V44.lockedUid = e
    HUB.V44.lockAt = os.clock()
    while state.alive and state.securingEgg do
        if HUB.V44.DefendEgg then pcall(HUB.V44.DefendEgg, targetPos) end
        if j and farmSessionId~=j then
            break
        end
        if not state.pureTweenFarm and not state.autoFarmLoop and not state.teleporting then
            break
        end
        if os.clock() - lastAvailability > 0.55 then
            lastAvailability = os.clock()
            local available, why = checkEggAvailability(e)
            if not available and why ~= "CarriedBySelf" then
                if why == "CarriedByOther" or why == "Removed" then break end
            end
        end

        if hasEggInInventory(e) then
            state.currentTargetModel=nil
            state.targetPosition=nil
            state.securingEgg=false
            state.holdingEggForGuard=false
            pcall(stashEquippedTools)
            state.statusText="Egg secured! Returning immediately..."
            logInfo(string.format("[FastPickup] UID %s secured on first pickup; returning now.",tostring(e)))
            return true
        end

        root:PivotTo(u*CFrame.new(0,0.4,0))
        triggerEggPromptsNearTarget(w,targetPos)

        local now=os.clock()
        if e and AskFieldEggCarryRemote and not pickupPending and now-lastRemote>=0.22 then
            lastRemote=now
            pickupPending=true
            task.spawn(function()
                pcall(function()
                    if AskFieldEggCarryRemote:IsA("RemoteFunction") then
                        AskFieldEggCarryRemote:InvokeServer({["Uid"]=e})
                    else
                        AskFieldEggCarryRemote:FireServer({["Uid"]=e})
                    end
                end)
                pickupPending=false
            end)
        end

        RunService.Heartbeat:Wait()
    end

    local secured=hasEggInInventory(e)
    state.currentTargetModel=nil
    state.targetPosition=nil
    state.securingEgg=false
    state.holdingEggForGuard=false

    if secured then
        pcall(stashEquippedTools)
        state.statusText="Egg secured! Returning immediately..."
        logInfo(string.format("[FastPickup] UID %s secured; returning now.",tostring(e)))
        return true
    end

    if e then
        targetCooldownUntil[e]=os.clock()+0.4
    end
    state.statusText="[-] Initial egg pickup failed"
    logWarn(string.format("[FastPickup] Initial pickup failed for UID %s.",tostring(e)))
    return false
end
runWarpStealCycle=function(e,u,...)
    if state.teleporting or state.glidingToTarget or state.delivering or state.securingEgg then
        return false
    end
    state.teleporting = true state.isReturning = false state.stateTime =os.clock ()
    local w=LocalPlayer.Character
    local j=w and w:FindFirstChild( "HumanoidRootPart" )
    local k=w and w:FindFirstChildOfClass( "Humanoid" )
    if not j or not k then
        resetMovementState()
        return false
    end
    if k then
        k:UnequipTools()
    end
    state.statusText = "[1/7] Pre-Flight Desync..."
    if not state.swapped then
        swapHumanoidForDesync()
    end
    if not state.godmode then
        setGodmode( true )
    end
    suppressRagdoll(w)
    if not e then
        e=selectBestTargetEgg()
    end
    local a=e and e.CFrame or DEFAULT_TARGET_CFRAME
    local V=e and e.Uid
    local H=a.Position
    if V then
        local e,r=checkEggAvailability(V)
        if not e and r~= "CarriedBySelf" then
            logWarn(string.format ( "[Snipe] Target egg %s is already taken (%s)! Selecting next target..." ,tostring(V),tostring(r)))state.statusText = "Target taken by another player!" targetCooldownUntil[V]=os.clock ()+ 5 resetMovementState()
            return false
        end
    end
    local s=select( 2 ,getEquippedEggTool())
    if not s then
        local e=findLakeStarterEgg()
        if not e then
            logWarn( "[-] Lake egg not found" )state.statusText = "[-] No Lake egg found" resetMovementState()
            return false
        end
        state.currentTargetModel =e.Model state.targetPosition =e.Position
        local r=((j.Position -e.Position )).Magnitude
        local w=e.CFrame *CFrame.new ( 0 , 0.4 , 0 )pcall(function(...) LocalPlayer:RequestStreamAroundAsync(e.Position )
        end
        )createSafetyFloor(e.Position , 8 )
        if r> 60 then
            state.statusText =string.format ( "[2/7] Gliding to Lake Egg (%.0f studs)..." ,r)state.glidingToTarget = true
            local y=glideToTargetViaWaypoint(w,state.glideSpeed ,e.Uid ,u)state.glidingToTarget = false
            if not y then
                logWarn( "[-] Lake starter egg was taken during flight" )targetCooldownUntil[e.Uid ]=os.clock ()+ 5 resetMovementState()
                return false
            end
        else
            state.statusText = "[2/7] Aligning with Lake Egg..." j.CFrame =w j.AssemblyLinearVelocity =Vector3.zero task.wait ( 0.04 )
        end
        j.Anchored = true task.wait ( 0.06 )j.Anchored = false state.holdingEggForGuard = true
        local k=os.clock ()+ 3
        while not isCarryingEgg()and(os.clock ()<k and(state.alive and state.teleporting ))do
            if u and farmSessionId~=u then
                logWarn( "[Snipe] Cancelled by session switch during Lake egg pickup" )resetMovementState()
                return false
            end
            if not state.autoFarmLoop and not state.teleporting then
                resetMovementState()
                return false
            end
            triggerEggPromptsNearTarget(e.Model ,e.Position )
            if e.Uid and AskFieldEggCarryRemote then
                task.spawn (function(...) pcall(function(...)
                        if AskFieldEggCarryRemote:IsA( "RemoteFunction" )then
                            AskFieldEggCarryRemote:InvokeServer({[ "Uid" ]=e.Uid })
                        else
                            AskFieldEggCarryRemote:FireServer({[ "Uid" ]=e.Uid })
                        end
                    end
                    )
                end
                )
            end
            RunService.Heartbeat :Wait()
        end
        s=select( 2 ,getEquippedEggTool())
        if not isCarryingEgg()then
            logWarn( "[-] Lake egg pickup failed" )state.statusText = "[-] Lake pickup failed" resetMovementState()
            return false
        end
    end
    state.statusText = "[3/7] Pre-streaming Target..." pcall(function(...) LocalPlayer:RequestStreamAroundAsync(H)
    end
    )createSafetyFloor(H, 12 )state.statusText = "[4/7] Waiting for physical bounce..." j.Anchored = false k:ChangeState(Enum.HumanoidStateType.Running )
    local p=(k.WalkSpeed > 0 )and k.WalkSpeed or 16 k.WalkSpeed = 0 k:Move(Vector3.zero , false )j.AssemblyLinearVelocity =Vector3.zero j.AssemblyAngularVelocity =Vector3.zero task.wait ( 0.04 )
    local B=j.Position
    local J=B.Y
    local K=select( 2 ,getEquippedEggTool())or s
    local c= false
    local v=nil
    if SpeedTollOfferRemote and SpeedTollOfferRemote:IsA( "RemoteEvent" )then
        v=SpeedTollOfferRemote.OnClientEvent :Connect(function(...) c= true
            if v then
                v:Disconnect()
            end
        end
        )
    end
    state.holdingEggForGuard = true requestForestStrike(K)
    local R=os.clock ()
    local g= false
    local Q=os.clock ()+ 2.5
    local P= false
    while os.clock ()<Q and(state.alive and state.teleporting )do
        if u and farmSessionId~=u then
            logWarn( "[Snipe] Cancelled by session switch during strike bounce" )
            if v then
                v:Disconnect()
            end
            k.WalkSpeed =p resetMovementState()
            return false
        end
        local e=os.clock ()-R
        local r=j.AssemblyLinearVelocity
        local w=j.Position
        local a=w.Y -J
        local o=((w-B)).Magnitude
        if e>= 0.08 then
            local e=c or(r.Y >= 10 )or(a>= 1.5 and r.Magnitude >= 16 )or(o>= 2 )or(r.Magnitude >= 20 )
            if e then
                g= true
                break
            end
        end
        if e>= 0.5 and not P then
            P= true requestForestStrike(K)
        end
        RunService.Heartbeat :Wait()
    end
    if v then
        v:Disconnect()
    end
    k.WalkSpeed =p state.holdingEggForGuard = false
    if not g then
        logWarn( "[-] No bounce detected, aborting" )state.statusText = "[-] Aborted (No bounce detected)" resetMovementState()pcall(stashEquippedTools)
        return false
    end
    task.wait ( 0.05 )
    if V then
        local e,r=checkEggAvailability(V)
        if not e and r== "CarriedByOther" then
            logWarn(string.format ( "[Snipe] Target egg %s was snatched while bouncing (%s)! Aborting warp..." ,tostring(V),tostring(r)))state.statusText = "Target taken! Aborting warp..." targetCooldownUntil[V]=os.clock ()+ 5 resetMovementState()
            return false
        end
    end
    state.currentTargetModel =e and e.Model state.targetPosition =H state.statusText = "[5/7] Warping to Target Egg..." createSafetyFloor(H, 8 )w:PivotTo(a*CFrame.new ( 0 , 0.4 , 0 ))j.Anchored = true
    for e,r in ipairs(w:GetDescendants())do
        if r:IsA( "BasePart" )then
            r.AssemblyLinearVelocity =Vector3.zero r.AssemblyAngularVelocity =Vector3.zero
        end
    end
    state.statusText = "[6/7] Picking up Target Egg..."
    local U=LocalPlayer:FindFirstChild( "Backpack" )
    for e,y in ipairs(w:GetChildren())do
        if y:IsA( "Tool" )then
            pcall(function(...)
                if U then
                    y.Parent =U
                else
                    y.Parent =Workspace
                end
            end
            )
        end
    end
    task.wait ( 0.06 )j.Anchored = false k:ChangeState(Enum.HumanoidStateType.Running )
    local l=secureEggWithGuardStrike(V,a,e and e.Model ,u)j.Anchored = false k:ChangeState(Enum.HumanoidStateType.Running )
    for e,r in ipairs(w:GetDescendants())do
        if r:IsA( "BasePart" )then
            r.AssemblyLinearVelocity =Vector3.zero r.AssemblyAngularVelocity =Vector3.zero
        end
    end
    if not l then
        logWarn( "[-] Initial target pickup failed" )state.statusText = "[-] Initial target pickup failed" resetMovementState()
        return false
    else
        state.statusText = "[7/7] Target Secured! Stashing into Backpack..." state.teleporting = false pcall(stashEquippedTools)
        return true
    end
end

recoverDroppedEggDuringReturn=function(uid, mode, sessionId)
    if not uid then
        return true
    end

    local uidKey = tostring(uid)

    local function enabled()
        if not state.alive then return false end
        if sessionId and farmSessionId ~= sessionId then return false end
        if mode == "TWEEN" then
            return state.pureTweenFarm and currentFarmMode == "TWEEN"
        elseif mode == "WARP" then
            return state.autoFarmLoop and currentFarmMode == "WARP"
        end
        return false
    end

    local function sameUid(a)
        return a ~= nil and tostring(a) == uidKey
    end

    if HUB.AntiEggDrop and HUB.AntiEggDrop.enabled and HUB.AntiEggDrop.recovering
        and sameUid(HUB.AntiEggDrop.lockedUid) then
        local antiDeadline = os.clock() + 0.35
        while HUB.AntiEggDrop.recovering and os.clock() < antiDeadline do
            RunService.Heartbeat:Wait()
        end
        if hasEggInInventory(uid) then
            state.returnEggUid = uid
            state.returnRecoveryActive = false
            state.isReturning = true
            return true
        end
    end

    local function ownsExactUid()
        local tool = getEquippedEggTool()
        if tool then
            local toolUid = select(2, getEquippedEggTool())
            if sameUid(toolUid) then
                return true
            end
        end

        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if isEggTool(item) then
                    local itemUid = item:GetAttribute("UID") or item:GetAttribute("EggUid")
                    if sameUid(itemUid) or tostring(item.Name) == uidKey then
                        return true
                    end
                end
            end
        end

        if EggState and EggState.ReadFieldEggs then
            local ok, snapshot = pcall(EggState.ReadFieldEggs)
            if ok and snapshot then
                local records = snapshot.Records or snapshot
                if type(records) == "table" then
                    for _, record in pairs(records) do
                        if type(record) == "table" and sameUid(record.Uid) then
                            local carrier = record.CarrierUserId or record.Carrier
                            if (record.State == "Carried" or record.State == 2)
                                and tostring(carrier) == tostring(LocalPlayer.UserId) then
                                return true
                            end
                        end
                    end
                end
            end
        end
        return false
    end

    local function recordIsDropped(record)
        if not record or not sameUid(record.Uid) then return false end
        return record.State == "Dropped"
            or record.State == "Slot"
            or record.State == 1
            or record.State == "GuardCarried"
    end

    local function getRecordCFrame(record, model)
        if record and record.BoundsCFrame then
            return record.BoundsCFrame
        end
        if model then
            local ok, cf = pcall(function() return model:GetPivot() end)
            if ok and cf then return cf end
        end
        return nil
    end

    local function findExactDroppedUid()
        local records = readFieldEggs(true)
        local fallback
        for _, record in ipairs(records or {}) do
            if sameUid(record.Uid) and record.BoundsCFrame then
                if record.State == "Dropped" then
                    return record
                elseif recordIsDropped(record) and not fallback then
                    fallback = record
                end
            end
        end
        if fallback then return fallback end

        local slots = Workspace:FindFirstChild("AreaEggSlotsClient")
        if slots then
            for _, model in ipairs(slots:GetChildren()) do
                local attrUid = model:GetAttribute("UID") or model:GetAttribute("Uid") or model:GetAttribute("EggUid")
                if sameUid(attrUid) or tostring(model.Name) == uidKey then
                    local cf = getRecordCFrame(nil, model)
                    if cf then
                        return {
                            Uid = uid,
                            State = "Dropped",
                            BoundsCFrame = cf,
                            CFrame = cf,
                            BottomCFrame = cf,
                            PhysicalModel = model,
                        }
                    end
                end
            end
        end

        return nil
    end

    local function setRecoveryState(record)
        state.returnEggUid = uid
        state.returnEggMode = mode
        state.returnEggSession = sessionId
        state.returnRecoveryActive = true
        state.returnRecoveryStartedAt = os.clock()
        state.returnRecoveryCount = (state.returnRecoveryCount or 0) + 1
        state.returnDropGeneration = (state.returnDropGeneration or 0) + 1
        state.returnMissionComplete = false
        state.isReturning = true
    end

    if ownsExactUid() then
        state.returnEggUid = uid
        state.returnEggMode = mode
        state.returnEggSession = sessionId
        state.returnRecoveryActive = false
        state.returnMissionComplete = false
        state.isReturning = true
        pcall(stashEquippedTools)
        return true
    end

    local dropped = findExactDroppedUid()
    if not dropped then
        local deadline = os.clock() + 1.0
        while os.clock() < deadline and enabled() do
            if ownsExactUid() then
                state.returnRecoveryActive = false
                state.isReturning = true
                pcall(stashEquippedTools)
                return true
            end
            dropped = findExactDroppedUid()
            if dropped then break end
            RunService.Heartbeat:Wait()
        end
    end

    if not dropped or not enabled() then
        state.returnRecoveryActive = false
        return false
    end

    setRecoveryState(dropped)

    local dropCF = getRecordCFrame(dropped, dropped.PhysicalModel)
    if not dropCF then
        state.returnRecoveryActive = false
        return false
    end
    dropCF = dropCF * CFrame.new(0, 0.4, 0)
    local dropPos = dropCF.Position

    state.statusText = string.format(
        "[RETURN RECOVER #%d] UID %s dropped -> returning to SAME egg...",
        tonumber(state.returnRecoveryCount) or 1,
        uidKey
    )
    state.currentTargetModel = dropped.PhysicalModel
    state.targetPosition = dropPos

    pcall(function()
        LocalPlayer:RequestStreamAroundAsync(dropPos)
    end)
    createSafetyFloor(dropPos, 8)

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root then
        state.returnRecoveryActive = false
        return false
    end

    if humanoid then
        pcall(function()
            humanoid.AutoRotate = false
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end)
    end

    if mode == "WARP" then
        root.CFrame = dropCF
    else
        local oldGlide = state.glidingToTarget
        state.glidingToTarget = true
        local reached = glideToTargetViaWaypoint(dropCF, state.glideSpeed, uid, sessionId)
        state.glidingToTarget = oldGlide
        if not reached or not enabled() then
            state.returnRecoveryActive = false
            return false
        end
        root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then
            state.returnRecoveryActive = false
            return false
        end
    end
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    if humanoid then
        pcall(function() humanoid.AutoRotate = true end)
    end

    local pickupDeadline = os.clock() + 5.0
    local lastAttempt = 0
    local attempts = 0
    while os.clock() < pickupDeadline and enabled() do
        if HUB.V44.DefendEgg then pcall(HUB.V44.DefendEgg, dropPos) end
        if ownsExactUid() then
            break
        end

        attempts = attempts + 1
        local now = os.clock()
        if now - lastAttempt >= 0.07 then
            lastAttempt = now
            pcall(function()
                triggerEggPromptsNearTarget(dropped.PhysicalModel, dropPos)
            end)
            if AskFieldEggCarryRemote then
                pcall(function()
                    if AskFieldEggCarryRemote:IsA("RemoteFunction") then
                        AskFieldEggCarryRemote:InvokeServer({["Uid"] = uid})
                    else
                        AskFieldEggCarryRemote:FireServer({["Uid"] = uid})
                    end
                end)
            end
        end
        RunService.Heartbeat:Wait()
    end

    if not enabled() or not ownsExactUid() then
        state.returnRecoveryActive = false
        state.returnMissionComplete = false
        logWarn(string.format(
            "[ReturnRecovery] SAME UID %s was not recovered after %d pickup attempts.",
            uidKey, attempts
        ))
        return false
    end

    pcall(stashEquippedTools)
    state.returnRecoveryActive = false
    state.returnMissionComplete = false
    state.isReturning = true
    state.currentTargetModel = nil
    state.targetPosition = nil
    state.statusText = string.format(
        "[RETURN RECOVER #%d] UID %s picked up -> RESUMING HOME ROUTE NOW.",
        tonumber(state.returnRecoveryCount) or 1,
        uidKey
    )
    logInfo(string.format(
        "[ReturnRecovery] UID %s recovered; returning to original home destination. Next drop will use the same recovery again.",
        uidKey
    ))
    return true
end

HUB.AntiEggDrop = HUB.AntiEggDrop or {
    enabled = true,
    lockedUid = nil,
    conn = nil,
    recovering = false,
    lastOwnedAt = 0,
    lastScanAt = 0,
    lastRecoveryAt = 0,
}

function HUB.AntiEggDrop.SameUid(a, b)
    return a ~= nil and b ~= nil and tostring(a) == tostring(b)
end

function HUB.AntiEggDrop.GetHeldUid()
    if state.returnEggUid and hasEggInInventory(state.returnEggUid) then
        return state.returnEggUid
    end

    local equipped, equippedUid = getEquippedEggTool()
    if equipped and equippedUid then return equippedUid end

    if EggState and EggState.ReadFieldEggs then
        local ok, snapshot = pcall(EggState.ReadFieldEggs)
        if ok and snapshot then
            local records = snapshot.Records or snapshot
            if type(records) == "table" then
                for _, record in pairs(records) do
                    if type(record) == "table" and record.Uid then
                        local carrier = record.CarrierUserId or record.Carrier
                        if (record.State == "Carried" or record.State == 2)
                            and tostring(carrier) == tostring(LocalPlayer.UserId) then
                            return record.Uid
                        end
                    end
                end
            end
        end
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        local foundUid = nil
        local count = 0
        for _, item in ipairs(backpack:GetChildren()) do
            if isEggTool(item) then
                count = count + 1
                foundUid = item:GetAttribute("UID") or item:GetAttribute("EggUid") or item.Name
                if count > 1 then return nil end
            end
        end
        if count == 1 then return foundUid end
    end

    return nil
end

function HUB.AntiEggDrop.GetRecordCFrame(record)
    if not record then return nil end
    if record.BoundsCFrame then return record.BoundsCFrame end
    if record.CFrame then return record.CFrame end
    local model = record.PhysicalModel
    if model then
        local ok, cf = pcall(function() return model:GetPivot() end)
        if ok and cf then return cf end
    end
    return nil
end

function HUB.AntiEggDrop.FindDroppedRecord(uid)
    if not uid then return nil end
    local uidKey = tostring(uid)
    local fallback = nil

    local records = readFieldEggs(true)
    for _, record in ipairs(records or {}) do
        if type(record) == "table" and tostring(record.Uid) == uidKey then
            local cf = HUB.AntiEggDrop.GetRecordCFrame(record)
            if cf then
                if record.State == "Dropped" or record.State == "Slot" or record.State == 1 then
                    return record
                end
                fallback = fallback or record
            end
        end
    end

    local slots = Workspace:FindFirstChild("AreaEggSlotsClient")
    if slots then
        for _, model in ipairs(slots:GetChildren()) do
            local attrUid = model:GetAttribute("UID") or model:GetAttribute("Uid") or model:GetAttribute("EggUid")
            if tostring(attrUid or model.Name) == uidKey then
                local ok, cf = pcall(function() return model:GetPivot() end)
                if ok and cf then
                    return {
                        Uid = uid,
                        State = "Dropped",
                        BoundsCFrame = cf,
                        CFrame = cf,
                        PhysicalModel = model,
                    }
                end
            end
        end
    end

    return fallback
end

function HUB.AntiEggDrop.IsOnGround(record)
    local cf = HUB.AntiEggDrop.GetRecordCFrame(record)
    if not cf then return false end
    local pos = cf.Position

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local exclude = {}
    if LocalPlayer.Character then table.insert(exclude, LocalPlayer.Character) end
    if HUB.GuardRide and HUB.GuardRide.clone then table.insert(exclude, HUB.GuardRide.clone) end
    if HUB.GuardRide and HUB.GuardRide.avatar then table.insert(exclude, HUB.GuardRide.avatar) end
    if record.PhysicalModel then table.insert(exclude, record.PhysicalModel) end
    params.FilterDescendantsInstances = exclude
    params.IgnoreWater = false

    local result = Workspace:Raycast(pos + Vector3.new(0, 2.5, 0), Vector3.new(0, -18, 0), params)
    if result then
        local height = pos.Y - result.Position.Y
        if height <= 6.5 then return true end
    end

    return record.State == "Dropped" or record.State == "Slot" or record.State == 1
end

function HUB.AntiEggDrop.RecoverNow(uid, record)
    if HUB.AntiEggDrop.recovering or not HUB.AntiEggDrop.enabled or not uid then return end
    HUB.AntiEggDrop.recovering = true
    HUB.AntiEggDrop.lastRecoveryAt = os.clock()

    local cf = HUB.AntiEggDrop.GetRecordCFrame(record)
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not cf or not root then
        HUB.AntiEggDrop.recovering = false
        return
    end

    local dropPos = cf.Position
    pcall(function() LocalPlayer:RequestStreamAroundAsync(dropPos) end)

    pcall(function()
        root.CFrame = cf * CFrame.new(0, 2.0, 0)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)

    local deadline = os.clock() + 0.30
    local lastRemote = 0
    while HUB.AntiEggDrop.enabled and os.clock() <= deadline do
        if hasEggInInventory(uid) then break end

        pcall(function()
            triggerEggPromptsNearTarget(record.PhysicalModel, dropPos)
        end)

        local now = os.clock()
        if AskFieldEggCarryRemote and now - lastRemote >= 0.22 then
            lastRemote = now
            pcall(function()
                if AskFieldEggCarryRemote:IsA("RemoteFunction") then
                    AskFieldEggCarryRemote:InvokeServer({["Uid"] = uid})
                else
                    AskFieldEggCarryRemote:FireServer({["Uid"] = uid})
                end
            end)
        end
        RunService.Heartbeat:Wait()
    end

    if hasEggInInventory(uid) then
        HUB.AntiEggDrop.lockedUid = uid
        HUB.AntiEggDrop.lastOwnedAt = os.clock()
        if state.pureTweenFarm or state.autoFarmLoop or state.isReturning then
            state.returnEggUid = uid
            pcall(stashEquippedTools, true)
        end
        state.statusText = "[Anti Egg Drop] UID " .. tostring(uid) .. " recovered"
    end

    HUB.AntiEggDrop.recovering = false
end

function HUB.AntiEggDrop.Tick()
    if not HUB.AntiEggDrop.enabled or HUB.dead or HUB.paused then return end
    local now = os.clock()
    if now - (HUB.AntiEggDrop.lastScanAt or 0) < 0.025 then return end
    HUB.AntiEggDrop.lastScanAt = now

    if HUB.V44.lockedUid then
        local missionUid = HUB.V44.lockedUid
        if hasEggInInventory(missionUid) then
            HUB.AntiEggDrop.lockedUid = missionUid
            HUB.AntiEggDrop.lastOwnedAt = now
            return
        end
        if state.securingEgg then return end
    end
    local heldUid = HUB.AntiEggDrop.GetHeldUid()
    if heldUid and not HUB.V44.lockedUid then
        HUB.AntiEggDrop.lockedUid = heldUid
        HUB.AntiEggDrop.lastOwnedAt = now
        return
    end

    local uid = HUB.AntiEggDrop.lockedUid
    if not uid or HUB.AntiEggDrop.recovering then return end

    if hasEggInInventory(uid) then
        HUB.AntiEggDrop.lastOwnedAt = now
        return
    end

    local dropped = HUB.AntiEggDrop.FindDroppedRecord(uid)
    if dropped and HUB.AntiEggDrop.IsOnGround(dropped) then
        task.spawn(function()
            HUB.AntiEggDrop.RecoverNow(uid, dropped)
        end)
        return
    end

    if not dropped and now - (HUB.AntiEggDrop.lastOwnedAt or now) > 1.5 then
        if not state.returnEggUid or not HUB.AntiEggDrop.SameUid(state.returnEggUid, uid) then
            HUB.AntiEggDrop.lockedUid = nil
        end
    end
end

function HUB.AntiEggDrop.SetEnabled(value)
    HUB.AntiEggDrop.enabled = value == true
    if HUB.AntiEggDrop.enabled then
        if not HUB.AntiEggDrop.conn then
            HUB.AntiEggDrop.conn = track(RunService.Heartbeat:Connect(function()
                HUB.AntiEggDrop.Tick()
            end))
        end
    else
        if HUB.AntiEggDrop.conn then
            pcall(function() HUB.AntiEggDrop.conn:Disconnect() end)
            HUB.AntiEggDrop.conn = nil
        end
        HUB.AntiEggDrop.lockedUid = nil
        HUB.AntiEggDrop.recovering = false
    end
end

setFarmMode=function(e,...)
    if currentFarmMode==e then
        return
    end
    farmSessionId=farmSessionId+ 1
    local r=farmSessionId currentFarmMode= "SWITCHING" state.pureTweenFarm = false state.autoFarmLoop = false pcall(resetMovementState)pcall(stashEquippedTools)
    if e== "TWEEN" then
        if setWarpToggleState then
            setWarpToggleState( false , true )
        end
        if setTweenToggleState then
            setTweenToggleState( true , true )
        end
    elseif e== "WARP" then
        if setTweenToggleState then
            setTweenToggleState( false , true )
        end
        if setWarpToggleState then
            setWarpToggleState( true , true )
        end
    else
        if setTweenToggleState then
            setTweenToggleState( false , true )
        end
        if setWarpToggleState then
            setWarpToggleState( false , true )
        end
    end
    task.delay ( 0.06 ,function(...)
        if farmSessionId==r then
            currentFarmMode=e
            if e== "TWEEN" then
                state.pureTweenFarm = true state.autoFarmLoop = false pcall(stashEquippedTools)logInfo( "[FarmController] Pure Auto Steal (Tween) ACTIVATED exclusively." )
            elseif e== "WARP" then
                state.autoFarmLoop = true state.pureTweenFarm = false pcall(stashEquippedTools)logInfo( "[FarmController] Snipe Auto Loop (Warp) ACTIVATED exclusively." )
            else
                state.pureTweenFarm = false state.autoFarmLoop = false
                if not state.isBatchPlacing then
                    state.batchStealCount = 0
                end
                logInfo( "[FarmController] All farms DEACTIVATED. Bot idle." )
            end
        end
    end
    )
end

local lastTweenScanReset,lastWarpScanReset=os.clock(),os.clock()
local function transferTweenStep()
        local r,y=pcall(function(...)
            if state.pureTweenFarm and(not state.autoFarmLoop and(currentFarmMode== "TWEEN" and(not state.isBatchPlacing and(not state.teleporting and(not state.glidingToTarget and(not state.securingEgg and(not state.delivering and not state.isReturning )))))))then
                local r=LocalPlayer.Character
                local y=r and r:FindFirstChild( "HumanoidRootPart" )
                local u=r and r:FindFirstChildOfClass( "Humanoid" )
                if y and u then
                    pcall(stashEquippedTools)
                    local u=isCarryingEgg()
                    if not u then
                        local u=farmSessionId
                        local w=selectBestTargetEgg()
                        if w and(state.pureTweenFarm and(currentFarmMode== "TWEEN" and farmSessionId==u))then
                            local j,k=checkEggAvailability(w.Uid )
                            if not j and k~= "CarriedBySelf" then
                                logInfo(string.format ( "[AutoSteal] Egg %s already taken (%s). Switching to next target..." ,tostring(w.Uid ),tostring(k)))targetCooldownUntil[w.Uid ]=os.clock ()+ 5 task.wait ( 0.12 )
                                return
                            end
                            state.currentTargetModel =w.Model state.targetPosition =w.Position state.glidingToTarget = true state.stateTime =os.clock ()
                            local a=((w.Scale and w.Scale > 1.05 ))and string.format ( " | %.1fx" ,w.Scale )or "" state.statusText =string.format ( "[AutoSteal] Flying to %s (%s%s)..." ,tostring(w.Category or "Egg" ),tostring(w.Area or "Field" ),a)logInfo(string.format ( "[AutoSteal] Flying to %s | Zone: %s%s | Rank: %d (Corridor Z=-360)" ,tostring(w.Category or "Egg" ),tostring(w.Area or "Field" ),a,tonumber(w.Rank )or 1 ))
                            if not state.swapped then
                                swapHumanoidForDesync()
                            end
                            if not state.godmode then
                                setGodmode( true )
                            end
                            suppressRagdoll(r)pcall(function(...) LocalPlayer:RequestStreamAroundAsync(w.Position )
                            end
                            )
                            local V=w.CFrame *CFrame.new ( 0 , 0.4 , 0 )
                            local s=glideToTargetViaWaypoint(V,state.glideSpeed ,w.Uid ,u)state.glidingToTarget = false
                            if farmSessionId~=u or not state.pureTweenFarm or currentFarmMode~= "TWEEN" then
                                return
                            end
                            if not s then
                                logWarn( "[AutoSteal] Egg was taken during flight. Switching to next target..." )targetCooldownUntil[w.Uid ]=os.clock ()+ 5 resetMovementState()
                                return
                            end
                            if state.pureTweenFarm and(currentFarmMode== "TWEEN" and((y.Position -w.Position )).Magnitude <= 22 )then
                                local r=secureEggWithGuardStrike(w.Uid ,V,w.Model ,u)
                                if not r and isCarryingEgg()then
                                    r= true
                                end
                                if farmSessionId~=u or not state.pureTweenFarm or currentFarmMode~= "TWEEN" then
                                    return
                                end
                                if r then
                                    transferCollected=true
                                    state.nextStealZone = "Lake"
                                    pcall(stashEquippedTools)
                                    state.returnEggUid = w.Uid
                                    state.returnEggMode = "TWEEN"
                                    state.returnEggSession = u
                                    state.returnMissionComplete = false
                                    if state.autoGlide then
                                        state.statusText = "[AutoSteal] Secured! Tweening to Safe Line X=525..." logInfo( "[AutoSteal] Egg secured on first pickup! Returning immediately to Safe Line X=525 along Z=-360..." )
                                        local returnOk = returnToSafeLine(state.glideSpeed ,u,w.Uid,"TWEEN")
                                        pcall(stashEquippedTools)
                                        if not returnOk then
                                            logWarn(string.format("[AutoSteal] Return unfinished for UID %s; refusing to select a new egg.", tostring(w.Uid)))
                                            state.returnEggUid = w.Uid
                                            state.returnEggMode = "TWEEN"
                                            state.returnEggSession = u
                                            state.returnMissionComplete = false
                                            return
                                        end
                                        local r=countCarriedEggs()state.statusText =string.format ( "Stashed in Bag (%d Eggs). Next steal..." ,r)logInfo(string.format ( "[AutoSteal] Egg stashed in bag (%d total eggs). Hands-Free ready for next steal..." ,r))
                                    else
                                        state.statusText = "[AutoSteal] Secured! (Auto Return is OFF)" logInfo( "[AutoSteal] Egg secured! Staying at target (Auto Return is OFF)." )
                                    end
                                    pcall(stashEquippedTools)state.isReturning = false state.delivering = false state.glidingToTarget = false state.securingEgg = false state.currentTargetModel =nil state.targetPosition =nil
                                    if countStealAndMaybeBatchPlace( "TWEEN" )then
                                        return
                                    end
                                else
                                    if farmSessionId==u and(state.pureTweenFarm and currentFarmMode== "TWEEN" )then
                                        logWarn( "[AutoSteal] Initial pickup failed. Retrying with next egg..." )targetCooldownUntil[w.Uid ]=os.clock ()+ 5 resetMovementState()
                                    end
                                end
                            else
                                state.currentTargetModel =nil state.targetPosition =nil state.glidingToTarget = false
                            end
                        else
                            if os.clock ()-lastTweenScanReset> 5 then
                                targetCooldownUntil={}lastTweenScanReset=os.clock ()
                            end
                            state.statusText = "[AutoSteal] Scanning for targets..."
                        end
                    end
                end
            end
        end
        )
        if not r then
            logWarn( "[AutoSteal Loop Recovered]:" ,tostring(y))pcall(resetMovementState)
        end

    return r,y
end
local function transferWarpStep()
        local r,y=pcall(function(...)
            if state.autoFarmLoop and(not state.pureTweenFarm and(currentFarmMode== "WARP" and(not state.isBatchPlacing and(not state.teleporting and(not state.glidingToTarget and(not state.securingEgg and(not state.delivering and not state.isReturning )))))))then
                local r=LocalPlayer.Character
                local y=r and r:FindFirstChild( "HumanoidRootPart" )
                local u=r and r:FindFirstChildOfClass( "Humanoid" )
                if y and u then
                    pcall(stashEquippedTools)
                    local r=isCarryingEgg()
                    if not r then
                        local r=farmSessionId
                        local y=selectBestTargetEgg()
                        if y and(state.autoFarmLoop and(currentFarmMode== "WARP" and farmSessionId==r))then
                            local u=((y.Scale and y.Scale > 1.05 ))and string.format ( " | %.1fx" ,y.Scale )or "" logInfo(string.format ( "[SnipeLoop] Starting Warp Snipe: %s | Zone: %s%s (Rank %d)" ,tostring(y.Category or "Egg" ),tostring(y.Area or "Field" ),u,tonumber(y.Rank )or 1 ))state.statusText =string.format ( "[SnipeLoop] Warping for %s%s..." ,tostring(y.Category or "Egg" ),u)
                            local w=runWarpStealCycle(y,r)
                            if farmSessionId~=r or not state.autoFarmLoop or currentFarmMode~= "WARP" then
                                return
                            end
                            if w then
                                transferCollected=true
                                    state.nextStealZone = "Lake"
                                pcall(stashEquippedTools)
                                state.returnEggUid = y.Uid
                                state.returnEggMode = "WARP"
                                state.returnEggSession = r
                                state.returnMissionComplete = false
                                if state.autoGlide then
                                    state.statusText = "[SnipeLoop] Target secured! Tweening to Safe Line X=525..."
                                    local returnOk = returnToSafeLine(state.glideSpeed ,r,y.Uid,"WARP")
                                    pcall(stashEquippedTools)
                                    if not returnOk then
                                        logWarn(string.format("[SnipeLoop] Return unfinished for UID %s; refusing to select a new egg.", tostring(y.Uid)))
                                        state.returnEggUid = y.Uid
                                        state.returnEggMode = "WARP"
                                        state.returnEggSession = r
                                        state.returnMissionComplete = false
                                        return
                                    end
                                    local y=countCarriedEggs()state.statusText =string.format ( "Stashed in Bag (%d Eggs). Next snipe..." ,y)logInfo(string.format ( "[SnipeLoop] Egg stashed in bag (%d total eggs). Hands-Free ready for next snipe..." ,y))
                                else
                                    state.statusText = "[SnipeLoop] Target secured! (Auto Return is OFF)" logInfo( "[SnipeLoop] Snipe successful! Staying at target (Auto Return is OFF)." )
                                end
                                pcall(stashEquippedTools)state.isReturning = false state.delivering = false
                                if countStealAndMaybeBatchPlace( "WARP" )then
                                    return
                                end
                            else
                                if farmSessionId==r and(state.autoFarmLoop and currentFarmMode== "WARP" )then
                                    logWarn( "[SnipeLoop] Snipe cycle failed. Resetting for next target..." )
                                    if y and y.Uid then
                                        targetCooldownUntil[y.Uid ]=os.clock ()+ 5
                                    end
                                    pcall(resetMovementState)
                                end
                            end
                        else
                            if os.clock ()-lastWarpScanReset> 5 then
                                targetCooldownUntil={}lastWarpScanReset=os.clock ()
                            end
                            state.statusText = "[SnipeLoop] Searching for targets..."
                        end
                    end
                end
            end
        end
        )
        if not r then
            logWarn( "[SnipeLoop Loop Recovered]:" ,tostring(y))pcall(resetMovementState)
        end

    return r,y
end

local transferHeartbeat = RunService.Heartbeat :Connect(function(...)
    if not state.alive or not transferRunning then return end
    local e=LocalPlayer.Character
    local r=e and e:FindFirstChild( "HumanoidRootPart" )
    local y=e and e:FindFirstChildOfClass( "Humanoid" )
    if not r then
        return
    end
    if y then
        if y.PlatformStand then
            y.PlatformStand = false y:ChangeState(Enum.HumanoidStateType.Running )
        end
        if y.Sit and((state.pureTweenFarm or state.autoFarmLoop or state.isReturning or state.glidingToTarget ))then
            y.Sit = false y:ChangeState(Enum.HumanoidStateType.Running )
        end
    end
    local u=r.Position
    local w=isCarryingEgg()
    if u.Y < 45 then
        r.CFrame =CFrame.new (u.X , 72 ,u.Z )r.AssemblyLinearVelocity =Vector3.zero
        return
    end
    if((state.pureTweenFarm or state.autoFarmLoop ))and not state.holdingEggForGuard then
        local r= false
        for e,y in ipairs(e:GetChildren())do
            if y:IsA( "Tool" )then
                r= true
                break
            end
        end
        if r then
            stashEquippedTools()
        end
    end
    if state.pureTweenFarm or state.autoFarmLoop or state.teleporting or state.glidingToTarget or state.delivering or state.securingEgg or state.isReturning then
        return
    end
    if state.alive and(state.autoGlide and(w and(not isCarryingLakeEgg()and u.X >BASE_EDGE_X)))then
        task.spawn (function(...) returnToSafeLine(state.glideSpeed )stashEquippedTools()state.isReturning = false state.delivering = false
        end
        )
    end
end
)

local api={}
function api:Cancel()
    farmSessionId = farmSessionId + 1
    currentFarmMode="NONE"
    state.pureTweenFarm=false
    state.autoFarmLoop=false
    transferRunning=false
    pcall(resetMovementState)
end
function api:CharacterChanged()
    self:Cancel()
    state.swapped=false
end
function api:Run(record,method,speed)
    method = "Teleport"
    if not state.alive then return false,"Steal engine disabled" end
    if transferRunning then return false,"A steal cycle is already running" end
    assert(record and record.Uid and record.BoundsCFrame,"LSS HUB selected egg is missing Uid/BoundsCFrame")
    transferTarget={
        Uid=record.Uid,
        Category=tostring(record.AssetCategory or record.Category or "Egg"),
        Area=tostring(record.AreaId or record.Area or "Field"),
        CFrame=record.BoundsCFrame,
        Position=record.BoundsCFrame.Position,
        Model=record.PhysicalModel,
        Rank=tonumber(record.Rank) or 1,
        Scale=tonumber(record.AssetScale or record.Scale) or 1,
    }
    transferCollected=false
    transferRunning=true
    farmSessionId = farmSessionId + 1
    local session=farmSessionId
    state.glideSpeed=math.clamp(tonumber(speed) or 850,50,850)
    state.autoGlide=true
    state.autoPlaceEvery5=false
    currentFarmMode=method=="Teleport" and "WARP" or "TWEEN"
    state.autoFarmLoop=currentFarmMode=="WARP"
    state.pureTweenFarm=currentFarmMode=="TWEEN"
    local ok,err
    if currentFarmMode=="WARP" then
        ok,err=transferWarpStep()
    else
        ok,err=transferTweenStep()
    end
    local collected=transferCollected and farmSessionId==session
        and (not state.autoGlide or state.returnMissionComplete == true)
    local status=state.statusText
    self:Cancel()
    transferTarget=nil
    if not ok then error(tostring(err),0) end
    return collected,status
end
function api:HatchNow()
    return hatchReadyEggs(true)
end
function api:PlaceNow()
    return placeInventoryEggs()
end
function api:ResumeLocked(uid)
    if transferRunning or not state.alive or HUB.paused then return false,"Farm busy" end
    if not uid then return false,"Missing UID" end
    transferRunning = true
    farmSessionId = farmSessionId + 1
    local session = farmSessionId
    state.autoFarmLoop = true
    state.pureTweenFarm = false
    state.autoGlide = true
    state.returnEggUid = uid
    state.returnEggMode = "WARP"
    local ok, result = pcall(returnToSafeLine, state.glideSpeed, session, uid, "WARP")
    local completed = ok and result == true and state.returnMissionComplete == true
    self:Cancel()
    if completed then HUB.V44.lockedUid = nil end
    if not ok then logWarn("[ResumeLocked] " .. tostring(result)) end
    return completed, completed and "Returned home with UID" or "Not home yet; UID still locked"
end
function api:Destroy()
    self:Cancel()
    state.alive=false
    transferHeartbeat:Disconnect()
end
return api

end
local function cancelImportedSteal()
    ImportedSteal.generation = ImportedSteal.generation + 1
    if ImportedSteal.engine then ImportedSteal.engine:Cancel() end
end

local function StealSpecificEggRobust(targetItem)
    if HUB.dead then return false,"LSS HUB is unloaded" end
    if HUB.paused then return false,"LSS HUB is paused" end
    if ImportedSteal.busy then return false,"A steal cycle is already processing" end
    local record=targetItem and (targetItem.record or targetItem)
    if not record or not record.Uid or not record.BoundsCFrame then
        return false,"Selected egg has no position data"
    end
    ImportedSteal.busy=true
    local generation=ImportedSteal.generation
    local selectedMethod = "Teleport"
    local ok,result,detail=xpcall(function()
        if not ImportedSteal.engine then
            ImportedSteal.engine=createImportedStealEngine()
        end
        if HUB.dead or generation~=ImportedSteal.generation then
            if HUB.dead then ImportedSteal.engine:Destroy() else ImportedSteal.engine:Cancel() end
            return false,"Steal cancelled"
        end
        return ImportedSteal.engine:Run(record,selectedMethod,glideSpeed)
    end,function(message)
        return debug and debug.traceback and debug.traceback(tostring(message),2) or tostring(message)
    end)
    ImportedSteal.busy=false
    if not ok then
        if ImportedSteal.engine then ImportedSteal.engine:Cancel() end
        Notify("Steal "..selectedMethod,tostring(result),"Error",5)
        return false,tostring(result)
    end
    if not result and detail then
        Notify("Steal "..selectedMethod,tostring(detail),"Info",3)
    end
    return result,detail
end

local function StealBestEggOnce()
    local eggs=GetMatchingFieldEggs(selectedStealAreas,selectedStealRarities,selectedMutationTypes)
    local locked = HUB.V44.lockedUid
    if locked then
        local ok, snapshot = pcall(function() return EggState and EggState.ReadFieldEggs and EggState.ReadFieldEggs() end)
        local records = ok and snapshot and (snapshot.Records or snapshot) or {}
        for _, record in pairs(records) do
            if type(record) == "table" and tostring(record.Uid) == tostring(locked)
                and record.BoundsCFrame then
                if record.State == "Carried" and tostring(record.CarrierUserId or record.Carrier or "")
                    ~= tostring(LocalPlayer.UserId) then
                    HUB.V44.lockedUid = nil
                    break
                end
                if record.State == "Slot" or record.State == "Dropped" or record.State == "Carried" then
                    local success, detail = StealSpecificEggRobust(record)
                    if success then HUB.V44.lockedUid = nil end
                    return success, detail
                end
            end
        end
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local carrying = false
        for _, container in ipairs({LocalPlayer.Character, backpack}) do
            if container then
                for _, tool in ipairs(container:GetChildren()) do
                    local toolUid = tool:GetAttribute("UID") or tool:GetAttribute("Uid") or tool:GetAttribute("EggUid")
                    if tool:IsA("Tool") and toolUid and tostring(toolUid) == tostring(locked) then
                        carrying = true
                        break
                    end
                end
            end
            if carrying then break end
        end
        if carrying then
            if not ImportedSteal.engine then ImportedSteal.engine = createImportedStealEngine() end
            return ImportedSteal.engine:ResumeLocked(locked)
        end
        if os.clock() - (HUB.V44.lockAt or 0) < 12 then return false, "Waiting for target UID to stream" end
        HUB.V44.lockedUid = nil
    end
    if #eggs==0 then return false,"No eggs match the LSS HUB filter" end
    HUB.V44.lockedUid = eggs[1].record.Uid
    HUB.V44.lockAt = os.clock()
    local ok, detail = StealSpecificEggRobust(eggs[1])
    if ok then HUB.V44.lockedUid = nil end
    return ok, detail
end


track(LP.CharacterAdded:Connect(function()
    cancelImportedSteal()
    if ImportedSteal.engine then ImportedSteal.engine:CharacterChanged() end
end))

HUB.V44.PlaceNow = function()
    if ImportedSteal.busy then return 0 end
    if not ImportedSteal.engine then ImportedSteal.engine = createImportedStealEngine() end
    return ImportedSteal.engine:PlaceNow()
end

local function HatchAllReadyEggs()
    if ImportedSteal.busy then return 0 end
    if not ImportedSteal.engine then ImportedSteal.engine = createImportedStealEngine() end
    return ImportedSteal.engine:HatchNow()
end

local function LegacyHatchAllReadyEggs()
    if not EggState or not EggState.ReadOwnedEggs then return 0 end
    local ok, snapshot = pcall(EggState.ReadOwnedEggs, LP.UserId)
    if not ok or not snapshot then return 0 end

    local count = 0
    local records = snapshot.Records or snapshot
    if typeof(records) == "table" then
        for uid, eggData in pairs(records) do
            if typeof(eggData) == "table" then
                local isReady = false
                if EggState.IsReadyToHatch then
                    isReady = EggState.IsReadyToHatch(eggData)
                else
                    isReady = eggData.Placement ~= nil
                end

                if isReady then
                    pcall(function()
                        if EggState.BeginHatch then EggState.BeginHatch(uid) end
                        task.wait(0.05)
                        if EggState.FinishHatch then EggState.FinishHatch(uid) end
                        count = count + 1
                    end)
                end
            end
        end
    end
    return count
end

local function UpgradeHomesteadBase()
    local re1 = GetNetRemote("RE/Homestead/AskNearbyPurchase")
    if re1 then pcall(function() re1:FireServer() end) end
    local re2 = GetNetRemote("RE/Homestead/AskBaseTierRaise")
    if re2 then pcall(function() re2:FireServer() end) end
end

local function UpgradeTreadmillTier()
    local rf = GetNetRemote("RF/Treadmill/AskTierRaise")
    if rf then pcall(function() rf:InvokeServer() end) end
end

local function EquipBestPets()
    local rf = GetNetRemote("RF/Haul/WearBest") or GetNetRemote("RF/PenRoster/ConfirmEquipBestBadge")
    if rf then pcall(function() rf:InvokeServer() end) end
end

local function DropHeldEgg()
    local rf = GetNetRemote("RF/EggWorld/AskFieldEggDrop")
    if rf then pcall(function() rf:InvokeServer() end) end
    if EggState and EggState.DropFieldEgg then pcall(EggState.DropFieldEgg) end
end

local function BuyAffordableTrails()
    local remote = GetNetRemote("RF/Trailwear/AskPurchase")
    if not remote or not remote:IsA("RemoteFunction") then return false, "Trail remote unavailable" end
    local okData, data = pcall(function()
        local mod = RS:FindFirstChild("Data") and RS.Data:FindFirstChild("Trails")
        return mod and require(mod)
    end)
    if not okData or type(data) ~= "table" then return false, "Trail catalog unavailable" end
    local money = getPlayerMoney()
    if money <= 0 then return false, "Money unreadable" end
    local save
    pcall(function() save = SaveModule and SaveModule.Get and SaveModule.Get() end)
    local owned = type(save) == "table" and save.TrailInventory or {}
    local guiOwned = readOwnedTrailsFromGui()
    local options = {}
    for key, entry in pairs(data.Directory or data) do
        if type(entry) == "table" then
            local id = tostring(entry._id or entry.Id or key)
            local price = tonumber(entry.Price or entry.Cost)
            if id ~= "" and price and price > 0 and price <= money then
                local has = owned[id] or guiOwned[id] or guiOwned[id:lower()]
                local tried = HUB.Shop and HUB.Shop.lastBought[id]
                if not has and not tried then table.insert(options, {id=id, price=price}) end
            end
        end
    end
    table.sort(options, function(a, b) return a.price > b.price end)
    local target = options[1]
    if not target then return false, "No affordable unowned trail" end
    if HUB.Shop then HUB.Shop.lastBought[target.id] = true end
    local ok, answer = pcall(function() return remote:InvokeServer(target.id) end)
    if not ok then
        logWarn("[Shop] Trail purchase request failed: " .. tostring(answer))
        return false, tostring(answer)
    end
    logInfo("[Shop] Trail purchase requested: " .. target.id)
    return true, target.id
end

local function SetNoKnockback(enabled)
    noKnockbackEnabled = enabled
    if enabled then
        pcall(function()
            local rigSync = GetNetRemote("RE/RigSync/Refresh")
            if rigSync and getconnections then
                for _, conn in ipairs(getconnections(rigSync.OnClientEvent)) do
                    pcall(function() conn:Disconnect() end)
                end
            end
        end)
    end
end

local stopFly

pcall(function() if avoidTrapsEnabled then NeutralizeTraps() end end)
pcall(function() if noKnockbackEnabled then SetNoKnockback(true) end end)

local function SellSelectedPets()
    local re = GetNetRemote("RE/PetSatchel/SellPet")
    if not re or not SaveModule then return end
    local save = nil
    pcall(function() save = SaveModule.Get and SaveModule.Get() end)
    local inv = save and save.Inventory
    if type(inv) ~= "table" then return end

    for uid, petData in pairs(inv) do
        if type(petData) == "table" and not petData.Locked then
            local rName = petData.Rarity or "Common"
            if isRarityAllowed(rName, getSellRarityFilter(selectedSellPetRarities)) then
                pcall(function() re:FireServer(uid) end)
                task.wait(0.08)
            end
        end
    end
end

local function SellSelectedEggs()
    if not SaveModule then return end
    local save = nil
    pcall(function() save = SaveModule.Get and SaveModule.Get() end)
    if not save then return end
    local inv = save.EggInventory
    if type(inv) ~= "table" then return end

    local wear = GetNetRemote("RF/EggWorld/AskWearTool")
    local sell = GetNetRemote("RE/PetSatchel/SellPet")
    if not wear or not sell then return end

    for uid, eggData in pairs(inv) do
        if type(eggData) == "table" and not eggData.Placement and not eggData.Locked then
            local rName = GetEggRarityInfo(eggData)
            if isRarityAllowed(rName, getSellRarityFilter(selectedSellEggRarities)) then
                pcall(function() wear:InvokeServer(uid) end)
                pcall(function() sell:FireServer({ uid }) end)
                task.wait(SELL_REQUEST_DELAY)
            end
        end
    end
end

local function DeleteOwnPetRenders()
    local count = 0
    local function sweep(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Model") or child:IsA("BasePart") then
                pcall(function()
                    child:Destroy()
                    count = count + 1
                end)
            end
        end
    end
    sweep(Workspace:FindFirstChild("Pets"))
    sweep(Workspace:FindFirstChild("RenderedPets"))
    return count
end

local function ClaimAllAvailableRewards()
    pcall(function()
        local rf1 = GetNetRemote("RF/AwayEarnings/AskCollect")
        if rf1 then rf1:InvokeServer() end
    end)
    pcall(function()
        local rf2 = GetNetRemote("RF/Codex/AskRedeemAll")
        if rf2 then rf2:InvokeServer() end
    end)
    pcall(function()
        local rf3 = GetNetRemote("RF/GroupPerk/RedeemPerk")
        if rf3 then rf3:InvokeServer() end
    end)
end

HUB.V44.DefendEgg = function(eggPos)
    if HUB.dead or HUB.paused or not HUB.V44.defendEgg or not eggPos then return end
    local now = os.clock()
    if now - (HUB.V44.lastDefenseAt or 0) < 0.19 then return end
    HUB.V44.lastDefenseAt = now
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or (root.Position - eggPos).Magnitude > 16 then return end
    local nearest, enemyRoot, distance = nil, nil, 50
    for _, person in ipairs(Players:GetPlayers()) do
        if person ~= LocalPlayer then
            local c = person.Character
            local er = c and c:FindFirstChild("HumanoidRootPart")
            local eh = c and c:FindFirstChildOfClass("Humanoid")
            if er and eh and eh.Health > 0 then
                local d = (root.Position - er.Position).Magnitude
                if d < distance then nearest, enemyRoot, distance = person, er, d end
            end
        end
    end
    if not enemyRoot then return end
    local bag = LocalPlayer:FindFirstChild("Backpack")
    local bat = char:FindFirstChildWhichIsA("Tool")
    if bat and bat:GetAttribute("IsBat") ~= true then bat = nil end
    if not bat and bag then
        for _, item in ipairs(bag:GetChildren()) do
            if item:IsA("Tool") and item:GetAttribute("IsBat") == true then
                bat = item
                pcall(function() hum:EquipTool(item) end)
                break
            end
        end
    end
    if not bat or not enemyRoot.Parent then return end
    local ahead = enemyRoot.Position + enemyRoot.CFrame.LookVector * 3
    pcall(function()
        root.CFrame = CFrame.lookAt(ahead, enemyRoot.Position)
        root.AssemblyLinearVelocity = Vector3.zero
        bat:Activate()
    end)
    local strike = GetNetRemote("RE/BatSwing/Trigger")
    if strike and strike:IsA("RemoteEvent") then pcall(function() strike:FireServer() end) end
    root.CFrame = CFrame.new(eggPos + Vector3.new(0, 1.8, 0))
end

task.spawn(function()
    while not HUB.dead do
        if not HUB.paused and autoStealEnabled then
            local ok, result = pcall(StealBestEggOnce)
            HUB.V44.hasEligibleEgg = false
            if not result then
                local found = GetMatchingFieldEggs(selectedStealAreas, selectedStealRarities, selectedMutationTypes)
                HUB.V44.hasEligibleEgg = #found > 0 or HUB.V44.lockedUid ~= nil
            end
        end
        task.wait(math.max(0.5, stealDelay))
    end
end)

task.spawn(function()
    while not HUB.dead do
        if not HUB.paused and autoHatchEnabled then
            pcall(HatchAllReadyEggs)
        end
        if not HUB.paused and autoPlantEnabled and not ImportedSteal.busy and not HUB.V44.droneFollow then
            pcall(PlantAllCarriedEggsInPen)
        end
        task.wait(hatchCheckDelay)
    end
end)

task.spawn(function()
    local nextRun = {}
    local function gated(key, interval, enabled, fn)
        if not enabled or HUB.dead or HUB.paused then return end
        local now = os.clock()
        if now < (nextRun[key] or 0) then return end
        nextRun[key] = now + interval
        local ok, err = pcall(fn)
        if not ok then logWarn("[Auto " .. key .. "] " .. tostring(err)) end
    end
    while not HUB.dead do
        gated("Trail", 12, autoBuyTrails, function()
            if HUB.Shop then HUB.Shop.TryAutoTrail() end
        end)
        gated("Base", 9, autoUpgradeBase, UpgradeHomesteadBase)
        gated("Treadmill", 9, autoUpgradeTreadmill, UpgradeTreadmillTier)
        gated("Equip", 10, autoEquipBestPets, EquipBestPets)
        gated("Rewards", 20, autoClaimRewards, ClaimAllAvailableRewards)
        gated("PetSell", 7, autoSellPets, SellSelectedPets)
        gated("EggSell", 7, autoSellEggs, SellSelectedEggs)
        task.wait(1)
    end
end)

task.spawn(function()
    local batRe = GetNetRemote("RE/BatSwing/Trigger")
    while not HUB.dead do
        if not HUB.paused and batAuraEnabled and batRe then
            local hrp = findHRP()
            if hrp then
                local foundNearby = false
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local oHrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if oHrp and (oHrp.Position - hrp.Position).Magnitude <= batAuraRadius then
                            foundNearby = true
                            break
                        end
                    end
                end
                if foundNearby then
                    pcall(function() batRe:FireServer() end)
                end
            end
        end
        task.wait(batAuraDelay)
    end
end)

task.spawn(function()
    local debris = Workspace:FindFirstChild("__DEBRIS")
    if debris then
        track(debris.ChildAdded:Connect(function(child)
            if not HUB.paused and avoidTrapsEnabled and child.Name == "PlayerTrap" then
                task.wait(0.05)
                if child:GetAttribute("Owner") ~= LP.Name then
                    if child:IsA("BasePart") then child.CanTouch = false end
                    for _, c in ipairs(child:GetChildren()) do
                        if c:IsA("BasePart") then c.CanTouch = false end
                    end
                end
            end
        end))
    end

    while not HUB.dead do
        if not HUB.paused and (avoidTrapsEnabled or autoStealEnabled) then
            pcall(NeutralizeTraps)
        end
        task.wait(1.5)
    end
end)

local esp = {
    enabled         = false,
    eggs            = true,
    traps           = false,
    players         = false,
    guards          = false,
    rareEggsOnly    = false,
    showPetIcons    = true,
    maxDistance     = 800,

    eggColor        = Color3.fromRGB(255, 200, 50),
    rareEggColor    = Color3.fromRGB(255, 60, 220),
    trapColor       = Color3.fromRGB(255, 60, 60),
    playerColor     = Color3.fromRGB(100, 220, 100),
    guardColor      = Color3.fromRGB(255, 60, 60),
}

local hasDrawing = type(Drawing) == "table" and type(Drawing.new) == "function"
local trackedEspObjects = {}
local espBillboards = {}
local espContainer = nil

function HUB.Runtime.getEspContainer()
    if espContainer and espContainer.Parent then return espContainer end
    local p = nil
    pcall(function() p = (gethui and gethui()) end)
    if not p then pcall(function() p = game:GetService("CoreGui") end) end
    if not p then p = LP:FindFirstChild("PlayerGui") or Workspace end

    pcall(function()
        for _, c in ipairs(p:GetChildren()) do
            if c:IsA("Folder") and c.Name == "SAE_Esp_Holder" then c:Destroy() end
        end
    end)
    espContainer = Instance.new("Folder")
    espContainer.Name = "SAE_Esp_Holder"
    pcall(function() espContainer.Parent = p end)
    return espContainer
end

function HUB.Runtime.phucFormatMoney(n)
    n = tonumber(n) or 0
    if n >= 1000000000000 then return string.format("%.2fT", n / 1000000000000) end
    if n >= 1000000000 then return string.format("%.2fB", n / 1000000000) end
    if n >= 1000000 then return string.format("%.2fM", n / 1000000) end
    if n >= 1000 then return string.format("%.2fK", n / 1000) end
    return tostring(math.floor(n + 0.5))
end

function HUB.Runtime.phucNorm(s)
    return tostring(s or ""):lower():gsub("[%s_%-%[%]%(%)%.:'/\\]", "")
end

function HUB.Runtime.phucAssetsDir()
    if type(AssetsData) ~= "table" then return nil end
    return AssetsData.Directory or AssetsData.Assets or AssetsData
end

function HUB.Runtime.phucAssetInfo(category)
    local cat = tostring(category or "")
    local dir = HUB.Runtime.phucAssetsDir()
    if not dir or cat == "" then return nil end
    if dir[cat] then return dir[cat] end
    local key = HUB.Runtime.phucNorm(cat)
    for k, v in pairs(dir) do
        if HUB.Runtime.phucNorm(k) == key then return v end
        if type(v) == "table" and (HUB.Runtime.phucNorm(v.DisplayName) == key or HUB.Runtime.phucNorm(v.Name) == key or HUB.Runtime.phucNorm(v._id) == key) then
            return v
        end
    end
    return nil
end

function HUB.Runtime.phucImageId(value)
    if value == nil then return "" end
    if type(value) == "number" then return "rbxassetid://" .. tostring(value) end
    local text = tostring(value)
    if text == "" then return "" end
    if text:match("^%d+$") then return "rbxassetid://" .. text end
    return text
end

function HUB.Runtime.phucAssetIcon(category, record)
    local icon = record and (record.Icon or record.Image or record.Thumbnail or record.Texture or record.Decal)
    local info = HUB.Runtime.phucAssetInfo(category)
    if type(info) == "table" then
        icon = icon or info.Icon or info.Image or info.Thumbnail or info.Texture or info.Decal
        if type(info.Pet) == "table" then
            icon = icon or info.Pet.Icon or info.Pet.Image or info.Pet.Thumbnail or info.Pet.Texture or info.Pet.Decal
        end
        if type(info.Animal) == "table" then
            icon = icon or info.Animal.Icon or info.Animal.Image or info.Animal.Thumbnail or info.Animal.Texture or info.Animal.Decal
        end
        if type(info.Egg) == "table" then
            icon = icon or info.Egg.Icon or info.Egg.Image or info.Egg.Thumbnail or info.Egg.Texture or info.Egg.Decal
        end
    end
    return HUB.Runtime.phucImageId(icon)
end

function HUB.Runtime.phucRecordCategory(record)
    if not record then return "Egg" end
    local direct = record.AssetCategory or record.Category or record.Name or record.DisplayName or record.EggName
    if direct and tostring(direct) ~= "" then return tostring(direct) end
    return "Egg"
end

function HUB.Runtime.phucMutationMultiplier(record)
    local mult = 1
    local muts = record and (record.Mutations or record.Mutation)
    if type(muts) == "table" then
        for _, m in pairs(muts) do
            if type(m) == "table" then
                mult = mult * (tonumber(m.Multiplier or m.Value or m.Scale) or 1.5)
            else
                local t = tostring(m):lower()
                if t:find("rainbow") then mult = mult * 3
                elseif t:find("gold") then mult = mult * 2
                elseif t:find("silver") then mult = mult * 1.5
                else mult = mult * 1.25 end
            end
        end
    elseif muts then
        mult = 1.5
    end
    if record and record.HasParasite then mult = mult * 5 end
    return mult
end

phucEggMoney = function(record)
    local cat = HUB.Runtime.phucRecordCategory(record)
    local info = HUB.Runtime.phucAssetInfo(cat)
    local raw = tonumber(record and (record.Money or record.Cash or record.Income or record.EarningRate or record.Value or record.Price))
    if (not raw or raw <= 0) and type(info) == "table" then
        raw = tonumber(info.Money or info.Cash or info.Income or info.EarningRate or info.ProfileIncome or info.SalePrice or info.Price)
        if (not raw or raw <= 0) and type(info.Egg) == "table" then
            raw = tonumber(info.Egg.Money or info.Egg.Cash or info.Egg.Income or info.Egg.EarningRate or info.Egg.SalePrice or info.Egg.Price)
        end
    end
    raw = tonumber(raw) or 0
    local scale = tonumber(record and (record.AssetScale or record.Scale or record.NestScale)) or 1
    local value = raw * scale * HUB.Runtime.phucMutationMultiplier(record)
    if value <= 0 then
        local rarityName, rarityScore = GetEggRarityInfo(record)
        local areaText = tostring(record and (record.AreaId or record.Area or record.World or record.Zone) or "")
        local zone = tonumber(areaText:match("%d+")) or 50
        value = (tonumber(rarityScore) or 100) * math.max(zone, 50) * math.max(scale, 1)
    end
    return value
end

function HUB.Runtime.updateEggBillboard(key, pos, record)
    local bb = espBillboards[key]
    if not bb or not bb.gui or not bb.gui.Parent then
        local holder = HUB.Runtime.getEspContainer()
        local part = Instance.new("Part")
        part.Name = "LSS HUB_EspAnchor"
        part.Size = Vector3.new(1, 1, 1)
        part.Transparency = 1
        part.Anchored = true
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.CFrame = CFrame.new(pos)
        part.Parent = holder

        local gui = Instance.new("BillboardGui")
        gui.Name = "LSS HUB_EggCard"
        gui.Adornee = part
        gui.Size = UDim2.fromOffset(206, 88)
        gui.StudsOffset = Vector3.new(0, 3.75, 0)
        gui.AlwaysOnTop = true
        gui.LightInfluence = 0
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = part

        local frame = Instance.new("Frame")
        frame.Name = "Card"
        frame.Size = UDim2.fromScale(1, 1)
        frame.BackgroundColor3 = Color3.fromRGB(5, 12, 30)
        frame.BackgroundTransparency = 0.14
        frame.BorderSizePixel = 0
        frame.Parent = gui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 13)
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(225, 230, 238)
        stroke.Thickness = 1.7
        stroke.Transparency = 0.05
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = frame
        local strokeGradient = Instance.new("UIGradient")
        strokeGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.36, Color3.fromRGB(153, 143, 255)),
            ColorSequenceKeypoint.new(0.70, Color3.fromRGB(71, 146, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        })
        strokeGradient.Parent = stroke
        local glass = Instance.new("UIGradient")
        glass.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 18, 42)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(24, 32, 72)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(68, 52, 125)),
        })
        glass.Rotation = 135
        glass.Parent = frame

        local iconBox = Instance.new("Frame")
        iconBox.Name = "PetIconBox"
        iconBox.Size = UDim2.fromOffset(56, 56)
        iconBox.Position = UDim2.fromOffset(8, 15)
        iconBox.BackgroundColor3 = Color3.fromRGB(3, 8, 22)
        iconBox.BackgroundTransparency = 0.08
        iconBox.BorderSizePixel = 0
        iconBox.Parent = frame
        Instance.new("UICorner", iconBox).CornerRadius = UDim.new(0, 10)
        local iconStroke = Instance.new("UIStroke")
        iconStroke.Color = Color3.fromRGB(153, 143, 255)
        iconStroke.Transparency = 0.20
        iconStroke.Thickness = 1
        iconStroke.Parent = iconBox

        local petImage = Instance.new("ImageLabel")
        petImage.Name = "Pet3DImage"
        petImage.Size = UDim2.fromScale(0.82, 0.82)
        petImage.Position = UDim2.fromScale(0.5, 0.5)
        petImage.AnchorPoint = Vector2.new(0.5, 0.5)
        petImage.BackgroundTransparency = 1
        petImage.Image = ""
        petImage.ImageTransparency = 0
        petImage.ScaleType = Enum.ScaleType.Fit
        petImage.Parent = iconBox

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, -76, 0, 20)
        title.Position = UDim2.fromOffset(72, 7)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 12
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.Parent = frame

        local rarity = Instance.new("TextLabel")
        rarity.Name = "Rarity"
        rarity.Size = UDim2.new(1, -76, 0, 16)
        rarity.Position = UDim2.fromOffset(72, 27)
        rarity.BackgroundTransparency = 1
        rarity.Font = Enum.Font.GothamSemibold
        rarity.TextSize = 9
        rarity.TextXAlignment = Enum.TextXAlignment.Left
        rarity.TextColor3 = Color3.fromRGB(225, 230, 238)
        rarity.TextTruncate = Enum.TextTruncate.AtEnd
        rarity.Parent = frame

        local money = rarity:Clone()
        money.Name = "Money"
        money.Position = UDim2.fromOffset(72, 43)
        money.Parent = frame

        local distance = rarity:Clone()
        distance.Name = "Distance"
        distance.Position = UDim2.fromOffset(72, 59)
        distance.TextColor3 = Color3.fromRGB(181, 188, 210)
        distance.Parent = frame

        local tag = Instance.new("TextLabel")
        tag.Name = "Brand"
        tag.Size = UDim2.new(1, -18, 0, 12)
        tag.Position = UDim2.new(0, 9, 1, -13)
        tag.BackgroundTransparency = 1
        tag.Font = Enum.Font.GothamBold
        tag.TextSize = 7
        tag.TextXAlignment = Enum.TextXAlignment.Right
        tag.TextColor3 = Color3.fromRGB(153, 143, 255)
        tag.Text = "BY LSS HUB"
        tag.Parent = frame

        bb = {
            part = part,
            gui = gui,
            img = petImage,
            title = title,
            rarity = rarity,
            money = money,
            distance = distance,
            gradient = strokeGradient,
            category = nil,
            icon = nil,
        }
        espBillboards[key] = bb
    else
        bb.part.CFrame = CFrame.new(pos)
        bb.gui.Enabled = true
    end

    local category = HUB.Runtime.phucRecordCategory(record)
    local rarityName = GetEggRarityInfo(record)
    local hrp = findHRP()
    local dist = hrp and (pos - hrp.Position).Magnitude or 0
    bb.title.Text = category
    bb.rarity.Text = "Rarity: " .. tostring(rarityName)
    bb.money.Text = "Money: $" .. HUB.Runtime.phucFormatMoney(phucEggMoney(record)) .. " /s"
    bb.distance.Text = "Dist: " .. tostring(math.floor(dist + 0.5)) .. " studs"
    local icon = esp.showPetIcons and HUB.Runtime.phucAssetIcon(category, record) or ""
    if bb.img then
        bb.img.Image = icon
        bb.img.Visible = icon ~= ""
    end
    if bb.category ~= category or bb.show3D ~= esp.showPetIcons or bb.icon ~= icon then
        bb.category = category
        bb.show3D = esp.showPetIcons
        bb.icon = icon
    end
    return bb
end

function HUB.Runtime.createDrawingObject()
    if not hasDrawing then return {} end
    local o = {}
    o.name = trackDrawing(Drawing.new("Text"))
    o.name.Size = 13; o.name.Center = true; o.name.Outline = true; o.name.Visible = false

    o.dist = trackDrawing(Drawing.new("Text"))
    o.dist.Size = 11; o.dist.Center = true; o.dist.Outline = true; o.dist.Visible = false

    o.box = trackDrawing(Drawing.new("Square"))
    o.box.Thickness = 1.5; o.box.Filled = false; o.box.Visible = false

    return o
end

track(RunService.RenderStepped:Connect(function()
    if HUB.dead or not esp.enabled then
        for _, obj in pairs(trackedEspObjects) do
            if obj.name then obj.name.Visible = false end
            if obj.dist then obj.dist.Visible = false end
            if obj.box then obj.box.Visible = false end
        end
        for _, bb in pairs(espBillboards) do
            if bb.gui then bb.gui.Enabled = false end
        end
        return
    end

    local hrp = findHRP()
    local myPos = hrp and hrp.Position or Vector3.zero
    local renderItems = {}
    local activeBbKeys = {}
    local borderRotation = (os.clock() * 95) % 360
    for _, bb in pairs(espBillboards) do
        if bb.gradient then bb.gradient.Rotation = borderRotation end
        if bb.img then
            bb.img.Rotation = math.sin(os.clock() * 2.2) * 2
        end
    end

    if esp.eggs and EggState and EggState.ReadFieldEggs then
        local ok, snap = pcall(EggState.ReadFieldEggs)
        if ok and snap and snap.Records then
            for _, egg in ipairs(snap.Records) do
                if egg.State == "Slot" and egg.BoundsCFrame then
                    local pos = egg.BoundsCFrame.Position
                    local dist = (pos - myPos).Magnitude
                    if esp.maxDistance <= 0 or dist <= esp.maxDistance then
                        local muts = egg.Mutations or {}
                        local isRare = #muts > 0
                        if not esp.rareEggsOnly or isRare then
                            local mutText = isRare and (" [" .. table.concat(muts, ",") .. "]") or ""
                            local rName = GetEggRarityInfo(egg)
                            activeBbKeys[egg.Uid] = true
                            HUB.Runtime.updateEggBillboard(egg.Uid, pos, egg)
                        end
                    end
                end
            end
        end
    end

    if esp.traps then
        local debris = Workspace:FindFirstChild("__DEBRIS")
        if debris then
            for _, trap in ipairs(debris:GetChildren()) do
                if trap.Name == "PlayerTrap" and trap:IsA("BasePart") then
                    local pos = trap.Position
                    local dist = (pos - myPos).Magnitude
                    if esp.maxDistance <= 0 or dist <= esp.maxDistance then
                        local owner = trap:GetAttribute("Owner") or "Enemy"
                        table.insert(renderItems, {
                            Key = trap,
                            Pos = pos + Vector3.new(0, 1.5, 0),
                            Name = "[TRAP] @" .. owner,
                            Color = esp.trapColor,
                            Dist = dist,
                        })
                    end
                end
            end
        end
    end

    if esp.players then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local oHrp = p.Character:FindFirstChild("HumanoidRootPart")
                if oHrp then
                    local dist = (oHrp.Position - myPos).Magnitude
                    if esp.maxDistance <= 0 or dist <= esp.maxDistance then
                        table.insert(renderItems, {
                            Key = p,
                            Pos = oHrp.Position,
                            Name = p.DisplayName .. " (@" .. p.Name .. ")",
                            Color = esp.playerColor,
                            Dist = dist,
                        })
                    end
                end
            end
        end
    end

    for k, bb in pairs(espBillboards) do
        if not activeBbKeys[k] and bb.gui then
            bb.gui.Enabled = false
        end
    end

    local cam = GetCamera()
    local activeKeys = {}
    for _, item in ipairs(renderItems) do
        activeKeys[item.Key] = true
        local obj = trackedEspObjects[item.Key]
        if not obj then
            obj = HUB.Runtime.createDrawingObject()
            trackedEspObjects[item.Key] = obj
        end

        local screenPos, onScreen = nil, false
        if cam then
            screenPos, onScreen = cam:WorldToViewportPoint(item.Pos)
        end
        if onScreen and hasDrawing and screenPos then
            if obj.name then
                obj.name.Text = item.Name
                obj.name.Position = Vector2.new(screenPos.X, screenPos.Y - 14)
                obj.name.Color = item.Color
                obj.name.Visible = true
            end
            if obj.dist then
                obj.dist.Text = math.floor(item.Dist) .. " studs"
                obj.dist.Position = Vector2.new(screenPos.X, screenPos.Y + 2)
                obj.dist.Color = Color3.fromRGB(220, 220, 220)
                obj.dist.Visible = true
            end
        else
            if obj.name then obj.name.Visible = false end
            if obj.dist then obj.dist.Visible = false end
            if obj.box then obj.box.Visible = false end
        end
    end

    for k, obj in pairs(trackedEspObjects) do
        if not activeKeys[k] then
            if obj.name then obj.name.Visible = false end
            if obj.dist then obj.dist.Visible = false end
            if obj.box then obj.box.Visible = false end
        end
    end
end))

local fullbrightEnabled = false
local defaultAmbient = Lighting.Ambient
local defaultOutdoor = Lighting.OutdoorAmbient
local defaultBrightness = Lighting.Brightness
local defaultClockTime = Lighting.ClockTime

function HUB.Runtime.SetFullbright(v)
    fullbrightEnabled = v
    if v then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
    else
        Lighting.Ambient = defaultAmbient
        Lighting.OutdoorAmbient = defaultOutdoor
        Lighting.Brightness = defaultBrightness
        Lighting.ClockTime = defaultClockTime
    end
end

local walkSpeedEnabled = false
local walkSpeedVal     = 24
local jumpPowerEnabled = false
local jumpPowerVal     = 60
local infiniteJump     = false
local originalWalkSpeed = nil
local lastSpeedTick = 0
function HUB.Runtime.phucMovementBusy()
    return ImportedSteal.busy or (state and (state.teleporting or state.isReturning or state.securingEgg
        or state.glidingToTarget or state.delivering))
end
local flying           = false
local flySpeed         = 60
local antiAFK          = true

function HUB.Runtime.ApplyWalkSpeed(v)
    walkSpeedVal = math.clamp(tonumber(v) or 24, 16, 300)
    local hum = findHum()
    if hum and walkSpeedEnabled and not HUB.Runtime.phucMovementBusy() and not HUB.paused then
        pcall(function() hum.WalkSpeed = walkSpeedVal end)
    end
end

function HUB.Runtime.ApplyJumpPower(v)
    jumpPowerVal = v
    local hum = findHum()
    if hum and jumpPowerEnabled then
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end

track(RunService.Heartbeat:Connect(function()
    if HUB.dead or HUB.paused or HUB.Runtime.phucMovementBusy() then return end
    local now = os.clock()
    if now - lastSpeedTick < 0.12 then return end
    lastSpeedTick = now
    local hum = findHum()
    if hum then
        if walkSpeedEnabled and math.abs(hum.WalkSpeed - walkSpeedVal) > 0.1 then
            hum.WalkSpeed = walkSpeedVal
        end
        if jumpPowerEnabled then
            hum.UseJumpPower = true
            if math.abs(hum.JumpPower - jumpPowerVal) > 0.1 then hum.JumpPower = jumpPowerVal end
        end
    end
end))

track(UserInputService.JumpRequest:Connect(function()
    if HUB.dead or HUB.paused or not infiniteJump or HUB.Runtime.phucMovementBusy() then return end
    local hum = findHum()
    if hum then
        hum.Jump = true
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

function HUB.Runtime.startFly()
    if flying then return end
    local hrp = findHRP()
    local hum = findHum()
    if not (hrp and hum) then return end
    flying = true
    hrp.Anchored = true

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 1e5
    bodyGyro.P = 1e5
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp

    HUB._fly = {
        hrp = hrp,
        gyro = bodyGyro,
        conn = track(RunService.RenderStepped:Connect(function(dt)
            if not flying or HUB.dead then return end
            local cam = GetCamera()
            if not cam then return end
            local look = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local flatLook = Vector3.new(look.X, 0, look.Z)
            flatLook = flatLook.Magnitude > 0.001 and flatLook.Unit or Vector3.new(0, 0, -1)
            local flatRight = Vector3.new(right.X, 0, right.Z)
            flatRight = flatRight.Magnitude > 0.001 and flatRight.Unit or Vector3.new(1, 0, 0)

            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + flatLook end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - flatLook end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - flatRight end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + flatRight end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

            if dir.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + dir.Unit * flySpeed * math.min(dt, 0.1)
            end
            bodyGyro.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + look)
        end))
    }
end

function stopFly()
    flying = false
    local f = HUB._fly
    if f then
        pcall(function() f.conn:Disconnect() end)
        pcall(function() f.hrp.Anchored = false end)
        pcall(function() f.gyro:Destroy() end)
        HUB._fly = nil
    end
end

local antiAfkConn = nil
task.spawn(function()
    while not HUB.dead do
        if antiAFK and not HUB.paused and os.clock() - HUB.V44.afkAt >= 210 then
            HUB.V44.afkAt = os.clock()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
            end)
        end
        task.wait(15)
    end
end)
function HUB.Runtime.SetAntiAFK(v)
    antiAFK = v
    if state then state.antiAFK = v end
    if v and not antiAfkConn then
        antiAfkConn = track(LocalPlayer.Idled:Connect(function()
            if antiAFK then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end))
    elseif not v and antiAfkConn then
        pcall(function() antiAfkConn:Disconnect() end)
        antiAfkConn = nil
    end
end

pcall(function() HUB.Runtime.SetAntiAFK(true) end)

HUB.GuardRide = HUB.GuardRide or {
    enabled = false,
    clone = nil,
    avatar = nil,
    source = nil,
    conn = nil,
    characterConn = nil,
    descendantConn = nil,
    sourceAnimConn = nil,
    realTransparency = {},
    realVisualState = {},
    saved = {},
    moveTrack = nil,
    idleTrack = nil,
    wasMoving = false,
    facing = nil,
    lastRealPos = nil,
    guardYOffset = 0,
    riderPivotAboveBottom = 0,
    headPart = nil,
    proceduralJoints = {},
    proceduralPhase = 0,
    selectedGuardKey = nil,
    selectedGuardName = nil,
}

function HUB.GuardRide.RestorePartMap(map)
    for part, value in pairs(map or {}) do
        if part and part.Parent and part:IsA("BasePart") then
            pcall(function()
                if type(value) == "table" then
                    part.LocalTransparencyModifier = value.transparency or 0
                    if value.castShadow ~= nil then part.CastShadow = value.castShadow end
                else
                    part.LocalTransparencyModifier = value
                end
            end)
        end
    end
end

function HUB.GuardRide.RestoreVisualMap(map)
    for obj, value in pairs(map or {}) do
        if obj and obj.Parent then
            pcall(function()
                if type(value) == "table" then
                    if value.kind == "transparency" then
                        obj.Transparency = value.value
                    elseif value.kind == "enabled" then
                        obj.Enabled = value.value
                    elseif value.kind == "visible" then
                        obj.Visible = value.value
                    end
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = value
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                    obj.Enabled = value
                end
            end)
        end
    end
end

function HUB.GuardRide.HideRealVisual(obj)
    if not obj then return end

    if obj:IsA("BasePart") then
        if HUB.GuardRide.realTransparency[obj] == nil then
            HUB.GuardRide.realTransparency[obj] = {
                transparency = obj.LocalTransparencyModifier,
                castShadow = obj.CastShadow,
            }
        end
        obj.LocalTransparencyModifier = 1
        obj.CastShadow = false
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        if HUB.GuardRide.realVisualState[obj] == nil then
            HUB.GuardRide.realVisualState[obj] = {kind = "transparency", value = obj.Transparency}
        end
        obj.Transparency = 1
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
        or obj:IsA("Highlight") or obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
        if HUB.GuardRide.realVisualState[obj] == nil then
            HUB.GuardRide.realVisualState[obj] = {kind = "enabled", value = obj.Enabled}
        end
        obj.Enabled = false
    elseif obj:IsA("ForceField") then
        if HUB.GuardRide.realVisualState[obj] == nil then
            HUB.GuardRide.realVisualState[obj] = {kind = "visible", value = obj.Visible}
        end
        obj.Visible = false
    end
end

function HUB.GuardRide.EnforceRealHidden(character)
    if not HUB.GuardRide.enabled or not character then return end
    for part in pairs(HUB.GuardRide.realTransparency) do
        if part and part.Parent then
            pcall(function()
                part.LocalTransparencyModifier = 1
                part.CastShadow = false
            end)
        end
    end
    for obj in pairs(HUB.GuardRide.realVisualState) do
        if obj and obj.Parent then
            pcall(function()
                if obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                elseif obj:IsA("ForceField") then
                    obj.Visible = false
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                    or obj:IsA("Highlight") or obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                    obj.Enabled = false
                end
            end)
        end
    end
end

function HUB.GuardRide.StopTracks()
    for _, trackObj in ipairs({HUB.GuardRide.moveTrack, HUB.GuardRide.idleTrack}) do
        if trackObj then
            pcall(function() trackObj:Stop(0.08) end)
        end
    end
    HUB.GuardRide.moveTrack = nil
    HUB.GuardRide.idleTrack = nil
    HUB.GuardRide.wasMoving = false
end

function HUB.GuardRide.ResetProceduralPose()
    for _, entry in ipairs(HUB.GuardRide.proceduralJoints or {}) do
        if entry.joint and entry.joint.Parent then
            pcall(function() entry.joint.Transform = CFrame.new() end)
        end
    end
    HUB.GuardRide.proceduralPhase = 0
end

function HUB.GuardRide.Stop()
    HUB.GuardRide.enabled = false

    if HUB.GuardRide.conn then
        pcall(function() HUB.GuardRide.conn:Disconnect() end)
        HUB.GuardRide.conn = nil
    end
    if HUB.GuardRide.characterConn then
        pcall(function() HUB.GuardRide.characterConn:Disconnect() end)
        HUB.GuardRide.characterConn = nil
    end
    if HUB.GuardRide.descendantConn then
        pcall(function() HUB.GuardRide.descendantConn:Disconnect() end)
        HUB.GuardRide.descendantConn = nil
    end
    if HUB.GuardRide.sourceAnimConn then
        pcall(function() HUB.GuardRide.sourceAnimConn:Disconnect() end)
        HUB.GuardRide.sourceAnimConn = nil
    end

    HUB.GuardRide.StopTracks()
    HUB.GuardRide.ResetProceduralPose()
    HUB.GuardRide.RestorePartMap(HUB.GuardRide.realTransparency)
    HUB.GuardRide.RestoreVisualMap(HUB.GuardRide.realVisualState)
    HUB.GuardRide.realTransparency = {}
    HUB.GuardRide.realVisualState = {}

    if HUB.GuardRide.avatar then
        pcall(function() HUB.GuardRide.avatar:Destroy() end)
    end
    if HUB.GuardRide.clone then
        pcall(function() HUB.GuardRide.clone:Destroy() end)
    end

    HUB.GuardRide.avatar = nil
    HUB.GuardRide.clone = nil
    HUB.GuardRide.source = nil
    HUB.GuardRide.facing = nil
    HUB.GuardRide.lastRealPos = nil
    HUB.GuardRide.guardYOffset = 0
    HUB.GuardRide.riderPivotAboveBottom = 0
    HUB.GuardRide.headPart = nil
    HUB.GuardRide.proceduralJoints = {}
    HUB.GuardRide.proceduralPhase = 0

    local saved = HUB.GuardRide.saved or {}
    pcall(function()
        if saved.cameraMin ~= nil then LocalPlayer.CameraMinZoomDistance = saved.cameraMin end
        if saved.cameraMax ~= nil then LocalPlayer.CameraMaxZoomDistance = saved.cameraMax end
        if saved.cameraMode ~= nil then LocalPlayer.CameraMode = saved.cameraMode end
        if saved.realHumanoid and saved.realHumanoid.Parent and saved.displayDistanceType ~= nil then
            saved.realHumanoid.DisplayDistanceType = saved.displayDistanceType
        end
    end)

    local camera = GetCamera()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if camera then
        pcall(function()
            camera.CameraType = Enum.CameraType.Custom
            if humanoid then camera.CameraSubject = humanoid end
        end)
    end

    HUB.GuardRide.saved = {}
end

function HUB.GuardRide.GetAnimator(model)
    if not model then return nil end
    local host = model:FindFirstChildOfClass("Humanoid") or model:FindFirstChildOfClass("AnimationController")
    if not host then
        host = Instance.new("AnimationController")
        host.Name = "LSS HUB_RideAnimationController"
        host.Parent = model
    end

    local animator = host:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = host
    end
    return animator
end

function HUB.GuardRide.SetupAnimations(source, clone)
    HUB.GuardRide.StopTracks()
    HUB.GuardRide.ResetProceduralPose()

    if HUB.GuardRide.sourceAnimConn then
        pcall(function() HUB.GuardRide.sourceAnimConn:Disconnect() end)
        HUB.GuardRide.sourceAnimConn = nil
    end

    local animator = HUB.GuardRide.GetAnimator(clone)
    if not animator then return end

    for _, obj in ipairs(clone:GetDescendants()) do
        if obj:IsA("Motor6D") then
            pcall(function() obj.Transform = CFrame.new() end)
        end
    end

    local candidates = {}
    local seenIds = {}

    local function normalizeId(value)
        if value == nil then return nil end
        local text = tostring(value)
        local digits = string.match(text, "(%d%d%d%d%d+)")
        if not digits then return nil end
        return "rbxassetid://" .. digits
    end

    local function looksMove(text)
        text = string.lower(tostring(text or ""))
        return string.find(text, "walk", 1, true)
            or string.find(text, "run", 1, true)
            or string.find(text, "move", 1, true)
            or string.find(text, "sprint", 1, true)
            or string.find(text, "chase", 1, true)
            or string.find(text, "locomotion", 1, true)
    end

    local function looksIdle(text)
        text = string.lower(tostring(text or ""))
        return string.find(text, "idle", 1, true)
            or string.find(text, "stand", 1, true)
            or string.find(text, "rest", 1, true)
    end

    local function contextName(obj, root)
        local pieces = {}
        local cur = obj
        local depth = 0
        while cur and depth < 6 do
            table.insert(pieces, tostring(cur.Name or ""))
            if cur == root then break end
            cur = cur.Parent
            depth = depth + 1
        end
        return table.concat(pieces, " ")
    end

    local function addCandidate(idValue, context, priorityHint)
        local id = normalizeId(idValue)
        if not id then return end
        context = tostring(context or "")
        local key = id .. "|" .. string.lower(context)
        if seenIds[key] then return end
        seenIds[key] = true

        local moveScore = looksMove(context) and 10 or 0
        local idleScore = looksIdle(context) and 10 or 0
        if priorityHint == Enum.AnimationPriority.Movement then moveScore = moveScore + 20 end
        if priorityHint == Enum.AnimationPriority.Idle then idleScore = idleScore + 20 end

        table.insert(candidates, {
            id = id,
            context = context,
            moveScore = moveScore,
            idleScore = idleScore,
        })
    end

    local function scanTree(root)
        if not root then return end
        local objects = {root}
        for _, obj in ipairs(root:GetDescendants()) do table.insert(objects, obj) end
        for _, obj in ipairs(objects) do
            local context = contextName(obj, root)
            if obj:IsA("Animation") then
                addCandidate(obj.AnimationId, context, nil)
            elseif obj:IsA("StringValue") then
                addCandidate(obj.Value, context, nil)
            elseif obj:IsA("IntValue") or obj:IsA("NumberValue") then
                if looksMove(context) or looksIdle(context) or string.find(string.lower(context), "anim", 1, true) then
                    addCandidate(obj.Value, context, nil)
                end
            end

            local okAttrs, attrs = pcall(function() return obj:GetAttributes() end)
            if okAttrs and attrs then
                for attrName, attrValue in pairs(attrs) do
                    local attrContext = context .. " " .. tostring(attrName)
                    if looksMove(attrContext) or looksIdle(attrContext)
                        or string.find(string.lower(tostring(attrName)), "anim", 1, true) then
                        addCandidate(attrValue, attrContext, nil)
                    end
                end
            end
        end
    end

    scanTree(source)
    scanTree(clone)

    local sourceAnimator = source and source:FindFirstChildWhichIsA("Animator", true)
    local function addTrackCandidate(track)
        if not track then return end
        local okAnim, anim = pcall(function() return track.Animation end)
        if not okAnim or not anim then return end
        local priority = nil
        pcall(function() priority = track.Priority end)
        local context = tostring(track.Name or "") .. " " .. tostring(anim.Name or "")
        addCandidate(anim.AnimationId, context, priority)
    end

    if sourceAnimator then
        local ok, tracks = pcall(function() return sourceAnimator:GetPlayingAnimationTracks() end)
        if ok and tracks then
            for _, track in ipairs(tracks) do addTrackCandidate(track) end
        end
    end

    local bestMove = nil
    local bestIdle = nil
    for _, candidate in ipairs(candidates) do
        if not bestMove or candidate.moveScore > bestMove.moveScore then bestMove = candidate end
        if not bestIdle or candidate.idleScore > bestIdle.idleScore then bestIdle = candidate end
    end

    if bestMove and bestMove.moveScore <= 0 then bestMove = nil end
    if bestIdle and bestIdle.idleScore <= 0 then bestIdle = nil end

    if not bestMove and #candidates > 1 then
        for _, candidate in ipairs(candidates) do
            if not bestIdle or candidate.id ~= bestIdle.id then
                bestMove = candidate
                break
            end
        end
    end

    local function loadCandidate(candidate, name, priority)
        if not candidate then return nil end
        local anim = Instance.new("Animation")
        anim.Name = name
        anim.AnimationId = candidate.id
        anim.Parent = clone
        local track = nil
        pcall(function()
            track = animator:LoadAnimation(anim)
            track.Looped = true
            track.Priority = priority
        end)
        return track
    end

    HUB.GuardRide.moveTrack = loadCandidate(bestMove, "LSS HUB_GuardRun_PRELOADED", Enum.AnimationPriority.Movement)
    HUB.GuardRide.idleTrack = loadCandidate(bestIdle, "LSS HUB_GuardIdle_PRELOADED", Enum.AnimationPriority.Idle)

    if HUB.GuardRide.idleTrack then
        pcall(function() HUB.GuardRide.idleTrack:Play(0) end)
    end

    if sourceAnimator then
        HUB.GuardRide.sourceAnimConn = sourceAnimator.AnimationPlayed:Connect(function(track)
            if not HUB.GuardRide.enabled or not clone.Parent then return end
            local okAnim, anim = pcall(function() return track.Animation end)
            if not okAnim or not anim or not anim.AnimationId or anim.AnimationId == "" then return end

            local priority = nil
            pcall(function() priority = track.Priority end)
            local context = tostring(track.Name or "") .. " " .. tostring(anim.Name or "")
            if looksMove(context) or priority == Enum.AnimationPriority.Movement then
                local replacement = loadCandidate({id = anim.AnimationId}, "LSS HUB_GuardRun_CAPTURED", Enum.AnimationPriority.Movement)
                if replacement then
                    if HUB.GuardRide.moveTrack then pcall(function() HUB.GuardRide.moveTrack:Stop(0) end) end
                    HUB.GuardRide.moveTrack = replacement
                    if HUB.GuardRide.wasMoving then pcall(function() replacement:Play(0) end) end
                end
            elseif (looksIdle(context) or priority == Enum.AnimationPriority.Idle) and not HUB.GuardRide.idleTrack then
                HUB.GuardRide.idleTrack = loadCandidate({id = anim.AnimationId}, "LSS HUB_GuardIdle_CAPTURED", Enum.AnimationPriority.Idle)
                if HUB.GuardRide.idleTrack and not HUB.GuardRide.wasMoving then
                    pcall(function() HUB.GuardRide.idleTrack:Play(0) end)
                end
            end
        end)
    end

    HUB.GuardRide.proceduralJoints = {}
    if not HUB.GuardRide.moveTrack then
        for _, obj in ipairs(clone:GetDescendants()) do
            if obj:IsA("Motor6D") then
                table.insert(HUB.GuardRide.proceduralJoints, {joint = obj})
                if #HUB.GuardRide.proceduralJoints >= 10 then break end
            end
        end
    end
end

function HUB.GuardRide.SetMovingAnimation(moving, speed, dt)
    if HUB.GuardRide.wasMoving ~= moving then
        HUB.GuardRide.wasMoving = moving
        local moveTrack = HUB.GuardRide.moveTrack
        local idleTrack = HUB.GuardRide.idleTrack

        if moving then
            if idleTrack then pcall(function() idleTrack:Stop(0) end) end
            if moveTrack then pcall(function() moveTrack:Play(0) end) end
        else
            if moveTrack then pcall(function() moveTrack:Stop(0.05) end) end
            HUB.GuardRide.ResetProceduralPose()
            if idleTrack then pcall(function() idleTrack:Play(0.05) end) end
        end
    end

    if moving and HUB.GuardRide.moveTrack then
        pcall(function()
            local playback = math.clamp((tonumber(speed) or 16) / 16, 0.65, 4.5)
            HUB.GuardRide.moveTrack:AdjustSpeed(playback)
        end)
    elseif moving and not HUB.GuardRide.moveTrack then
        HUB.GuardRide.proceduralPhase = (HUB.GuardRide.proceduralPhase or 0)
            + math.max(0.016, tonumber(dt) or 0.016) * math.clamp((tonumber(speed) or 16) / 2.5, 4, 14)
        for index, entry in ipairs(HUB.GuardRide.proceduralJoints or {}) do
            local joint = entry.joint
            if joint and joint.Parent then
                local phase = HUB.GuardRide.proceduralPhase + (index * 1.37)
                pcall(function()
                    joint.Transform = CFrame.Angles(math.sin(phase) * 0.07, 0, math.cos(phase) * 0.025)
                end)
            end
        end
    end
end

function HUB.GuardRide.GetFlatLook(root)
    local look = root and root.CFrame.LookVector or Vector3.new(0, 0, -1)
    local flat = Vector3.new(look.X, 0, look.Z)
    if flat.Magnitude < 0.001 then
        return Vector3.new(0, 0, -1)
    end
    return flat.Unit
end

function HUB.GuardRide.FindHeadPart(model)
    if not model then return nil end
    local exact = model:FindFirstChild("Head", true)
    if exact and exact:IsA("BasePart") then return exact end
    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "head", 1, true) then
            return obj
        end
    end
    return nil
end

function HUB.GuardRide.GetRiderCFrame(mountCF, facing)
    local head = HUB.GuardRide.headPart
    local pos = nil
    if head and head.Parent then
        local headTop = head.Position + Vector3.new(0, head.Size.Y * 0.5, 0)
        pos = headTop + Vector3.new(0, HUB.GuardRide.riderPivotAboveBottom or 0, 0)
    else
        local clone = HUB.GuardRide.clone
        if clone and clone.Parent then
            local boxCF, boxSize = clone:GetBoundingBox()
            local topY = boxCF.Position.Y + boxSize.Y * 0.5
            pos = Vector3.new(mountCF.Position.X, topY + (HUB.GuardRide.riderPivotAboveBottom or 0), mountCF.Position.Z)
        else
            pos = mountCF.Position
        end
    end
    local dir = facing or Vector3.new(0, 0, -1)
    return CFrame.lookAt(pos, pos + dir)
end

function HUB.GuardRide.Start()
    HUB.GuardRide.Stop()

    local objects = Workspace:FindFirstChild("__OBJECTS")
    local areas = objects and objects:FindFirstChild("Areas")
    local guardAreas = areas and areas:FindFirstChild("GuardAreas")

    local function collectGuardModels()
        local entries = {}
        if not guardAreas then return entries end
        local seen = {}
        for _, obj in ipairs(guardAreas:GetDescendants()) do
            if obj.Name == "Guard" then
                local model = obj:IsA("Model") and obj
                    or obj:FindFirstChild("Model")
                    or obj:FindFirstChildWhichIsA("Model", true)
                if model and model:IsA("Model") and not seen[model] then
                    seen[model] = true
                    local area = obj
                    while area.Parent and area.Parent ~= guardAreas do
                        area = area.Parent
                    end
                    local areaName = area.Name ~= "GuardAreas" and area.Name or obj.Parent and obj.Parent.Name or "Area"
                    table.insert(entries, {
                        key = tostring(areaName) .. " | " .. tostring(obj:GetFullName()),
                        model = model,
                    })
                end
            elseif obj:IsA("Model") and obj.Name == "Guard" and not seen[obj] then
                seen[obj] = true
                table.insert(entries, {
                    key = tostring(obj:GetFullName()),
                    model = obj,
                })
            end
        end
        table.sort(entries, function(a, b) return a.key < b.key end)
        return entries
    end

    local function resolveSelectedGuard()
        local entries = collectGuardModels()
        local wanted = HUB.GuardRide.selectedGuardKey
        if wanted then
            for _, entry in ipairs(entries) do
                if entry.key == wanted then return entry.model end
            end
        end
        return entries[1] and entries[1].model or nil
    end

    local source = resolveSelectedGuard()

    if not source or not source:IsA("Model") then
        Notify("Ride", "Selected Guard not found", "Error", 4)
        return false
    end

    local character = LocalPlayer.Character
    local realHumanoid = character and character:FindFirstChildOfClass("Humanoid")
    local realRoot = character and character:FindFirstChild("HumanoidRootPart")

    if not character or not realHumanoid or not realRoot then
        Notify("Ride", "Character not ready", "Error", 3)
        return false
    end

    HUB.GuardRide.saved = {
        cameraMin = LocalPlayer.CameraMinZoomDistance,
        cameraMax = LocalPlayer.CameraMaxZoomDistance,
        cameraMode = LocalPlayer.CameraMode,
        realHumanoid = realHumanoid,
        displayDistanceType = realHumanoid.DisplayDistanceType,
    }

    source.Archivable = true
    local clone = source:Clone()
    clone.Name = "LSS HUB_LightDark_GuardRide_REALMOVE"

    for _, item in ipairs(clone:GetDescendants()) do
        if item:IsA("Script") or item:IsA("LocalScript") then
            item:Destroy()
        elseif item:IsA("BasePart") then
            item.Anchored = false
            item.CanCollide = false
            item.CanTouch = false
            item.CanQuery = false
            item.Massless = true
        end
    end

    clone.Parent = Workspace
    local cloneRoot = clone.PrimaryPart
        or clone:FindFirstChild("HumanoidRootPart", true)
        or clone:FindFirstChildWhichIsA("BasePart", true)
    if cloneRoot then cloneRoot.Anchored = true end

    local initialFacing = HUB.GuardRide.GetFlatLook(realRoot)
    local initialCF = CFrame.lookAt(realRoot.Position, realRoot.Position + initialFacing)
    clone:PivotTo(initialCF)

    local guardPivot = clone:GetPivot()
    local guardBoxCF, guardBoxSize = clone:GetBoundingBox()
    local guardBottomY = guardBoxCF.Position.Y - (guardBoxSize.Y * 0.5)
    local guardPivotAboveBottom = guardPivot.Position.Y - guardBottomY
    local playerGroundY = realRoot.Position.Y - (realHumanoid.HipHeight + realRoot.Size.Y * 0.5)
    HUB.GuardRide.guardYOffset = (playerGroundY + guardPivotAboveBottom) - realRoot.Position.Y

    local guardTargetPos = realRoot.Position + Vector3.new(0, HUB.GuardRide.guardYOffset, 0)
    local guardTargetCF = CFrame.lookAt(guardTargetPos, guardTargetPos + initialFacing)
    clone:PivotTo(guardTargetCF)

    character.Archivable = true
    local avatar = character:Clone()
    avatar.Name = "LSS HUB_GuardRide_RigidAvatar"

    for _, item in ipairs(avatar:GetDescendants()) do
        if item:IsA("Script") or item:IsA("LocalScript") or item:IsA("Tool") then
            item:Destroy()
        elseif item:IsA("Animator") then
            item:Destroy()
        elseif item:IsA("BasePart") then
            item.Anchored = true
            item.CanCollide = false
            item.CanTouch = false
            item.CanQuery = false
            item.Massless = true
        end
    end

    local avatarHumanoid = avatar:FindFirstChildOfClass("Humanoid")
    if avatarHumanoid then
        avatarHumanoid.AutoRotate = false
        avatarHumanoid.PlatformStand = false
        pcall(function() avatarHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end)
    end
    avatar.Parent = Workspace

    local avatarPivot = avatar:GetPivot()
    local avatarBoxCF, avatarBoxSize = avatar:GetBoundingBox()
    local avatarBottomY = avatarBoxCF.Position.Y - avatarBoxSize.Y * 0.5
    HUB.GuardRide.riderPivotAboveBottom = avatarPivot.Position.Y - avatarBottomY
    HUB.GuardRide.headPart = HUB.GuardRide.FindHeadPart(clone)

    pcall(function() realHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end)
    for _, item in ipairs(character:GetDescendants()) do
        HUB.GuardRide.HideRealVisual(item)
    end
    HUB.GuardRide.descendantConn = character.DescendantAdded:Connect(function(item)
        if HUB.GuardRide.enabled and LocalPlayer.Character == character then
            task.defer(function()
                if item and item.Parent then HUB.GuardRide.HideRealVisual(item) end
            end)
        end
    end)

    HUB.GuardRide.source = source
    HUB.GuardRide.clone = clone
    HUB.GuardRide.avatar = avatar
    HUB.GuardRide.enabled = true
    HUB.GuardRide.facing = initialFacing
    HUB.GuardRide.lastRealPos = realRoot.Position

    HUB.GuardRide.SetupAnimations(source, clone)

    pcall(function()
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 100000
    end)

    local camera = GetCamera()
    local avatarRoot = avatar:FindFirstChild("HumanoidRootPart")
        or avatar.PrimaryPart
        or avatar:FindFirstChildWhichIsA("BasePart", true)
    if camera then
        pcall(function()
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = avatarHumanoid or avatarRoot
        end)
    end

    HUB.GuardRide.characterConn = LocalPlayer.CharacterAdded:Connect(function()
        if HUB.GuardRide.enabled then HUB.GuardRide.Stop() end
    end)

    HUB.GuardRide.conn = RunService.RenderStepped:Connect(function(dt)
        if HUB.dead or not HUB.GuardRide.enabled then return end
        if LocalPlayer.Character ~= character or not character.Parent or not realRoot.Parent then
            HUB.GuardRide.Stop()
            return
        end
        if not clone.Parent or not avatar.Parent then
            HUB.GuardRide.Stop()
            return
        end

        HUB.GuardRide.EnforceRealHidden(character)

        local currentPos = realRoot.Position
        local lastPos = HUB.GuardRide.lastRealPos or currentPos
        local delta = currentPos - lastPos
        HUB.GuardRide.lastRealPos = currentPos

        local flatDelta = Vector3.new(delta.X, 0, delta.Z)
        local velocity = realRoot.AssemblyLinearVelocity
        local flatVelocity = Vector3.new(velocity.X, 0, velocity.Z)
        local moveDirection = realHumanoid.MoveDirection

        local direction = nil
        if flatDelta.Magnitude > 0.002 then
            direction = flatDelta.Unit
        elseif flatVelocity.Magnitude > 0.15 then
            direction = flatVelocity.Unit
        elseif moveDirection.Magnitude > 0.01 then
            local flatMove = Vector3.new(moveDirection.X, 0, moveDirection.Z)
            if flatMove.Magnitude > 0.01 then direction = flatMove.Unit end
        end

        if direction then
            HUB.GuardRide.facing = direction
        else
            local rootLook = HUB.GuardRide.GetFlatLook(realRoot)
            if rootLook.Magnitude > 0.01 then HUB.GuardRide.facing = rootLook end
        end

        local facing = HUB.GuardRide.facing or Vector3.new(0, 0, -1)
        local mountPos = currentPos + Vector3.new(0, HUB.GuardRide.guardYOffset, 0)
        local mountCF = CFrame.lookAt(mountPos, mountPos + facing)
        clone:PivotTo(mountCF)

        local measuredSpeed = flatVelocity.Magnitude
        if dt and dt > 0 and flatDelta.Magnitude > 0 then
            measuredSpeed = math.max(measuredSpeed, flatDelta.Magnitude / dt)
        end
        local moving = measuredSpeed > 0.35 or moveDirection.Magnitude > 0.01
        HUB.GuardRide.SetMovingAnimation(moving, measuredSpeed, dt)

        local riderCF = HUB.GuardRide.GetRiderCFrame(mountCF, facing)
        avatar:PivotTo(riderCF)
    end)

    Notify("Ride", "Riding Guard - full stand/run animations active", "Success", 4)
    return true
end

local autoTreadmillUserEnabled = false
local autoTreadmillEnabled = false
local autoTreadmillBusy = false
local autoTreadmillLastRun = 0
local autoTreadmillLastErrorAt = 0

local AUTO_TREADMILL_AVOID = {
    "upgrade", "tier", "level", "board", "sign", "billboard",
    "gui", "shop", "buy", "display", "screen", "label", "text",
    "icon", "price", "cost", "info", "menu",
}

local function autoTreadmillIgnoredName(name)
    name = tostring(name or ""):lower()
    for _, keyword in ipairs(AUTO_TREADMILL_AVOID) do
        if name:find(keyword, 1, true) then
            return true
        end
    end
    return false
end

local function autoTreadmillPositionOf(instance)
    if not instance or typeof(instance) ~= "Instance" then
        return nil
    end

    if instance:IsA("BasePart") then
        return instance.Position
    end

    if instance:IsA("Model") then
        local ok, pivot = pcall(function()
            return instance:GetPivot()
        end)
        if ok and pivot then
            return pivot.Position
        end
    end

    return nil
end

local function autoTreadmillLooksLikeTreadmill(instance)
    if not instance or typeof(instance) ~= "Instance" then
        return false
    end

    local name = tostring(instance.Name or "")
    local lowerName = name:lower()

    if autoTreadmillIgnoredName(name) then
        return false
    end

    if lowerName:find("treadmill", 1, true) then
        return true
    end

    return false
end

local findAutoTreadmillSeat

local function autoTreadmillCollect(container, result, seen)
    if not container or typeof(container) ~= "Instance" then
        return
    end

    seen = seen or {}

    local function addCandidate(instance)
        if seen[instance] then
            return
        end
        if autoTreadmillLooksLikeTreadmill(instance) then
            seen[instance] = true
            result[#result + 1] = instance
        end
    end

    addCandidate(container)

    local ok, descendants = pcall(function()
        return container:GetDescendants()
    end)
    if not ok then
        return
    end

    for _, descendant in ipairs(descendants) do
        addCandidate(descendant)
    end
end

local function findMyAutoTreadmill()
    local st = state
    local plot = (type(st) == "table") and st.plot or nil

    if not plot or not plot.Parent then
        local ok, resolvedPlot = pcall(function()
            return findPlayerPlot and select(1, findPlayerPlot())
        end)
        if ok and resolvedPlot then
            plot = resolvedPlot
        end
    end

    if not plot or typeof(plot) ~= "Instance" or not plot.Parent then
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end

        local slot = nil
        pcall(function()
            if PlotState and PlotState.ResolveLocalSlot then
                slot = PlotState.ResolveLocalSlot()
            end
        end)
        if slot ~= nil then
            plot = plots:FindFirstChild(tostring(slot))
        end

        if not plot then
            local uid = LocalPlayer.UserId
            local uname = LocalPlayer.Name
            local dname = LocalPlayer.DisplayName
            local function matchesOwner(value)
                return value ~= nil and (value == uid
                    or tostring(value) == tostring(uid)
                    or value == uname
                    or value == dname)
            end
            for _, candidate in ipairs(plots:GetChildren()) do
                local attr = candidate:GetAttribute("Owner")
                    or candidate:GetAttribute("OwnerUserId")
                    or candidate:GetAttribute("OwnerId")
                    or candidate:GetAttribute("UserId")
                    or candidate:GetAttribute("Player")
                if matchesOwner(attr) then
                    plot = candidate
                    break
                end
                for _, key in ipairs({"Owner", "OwnerUserId", "OwnerId", "UserId", "Player", "PlayerName"}) do
                    local obj = candidate:FindFirstChild(key)
                    if obj and matchesOwner(obj.Value) then
                        plot = candidate
                        break
                    end
                end
                if plot then break end
            end
        end
    end

    if not plot or typeof(plot) ~= "Instance" or not plot.Parent then
        return nil
    end

    if type(st) == "table" then
        st.plot = plot
    end

    local known = type(st) == "table" and st.tread or nil
    if known and known.Parent and known:IsDescendantOf(plot) then
        return known
    end

    local candidates = {}
    local seen = {}

    local function collectReference(instance)
        if not instance or typeof(instance) ~= "Instance" then return end

        local function add(obj)
            if seen[obj] then return end
            if obj:IsA("Model") then
                if not autoTreadmillIgnoredName(obj.Name) then
                    seen[obj] = true
                    candidates[#candidates + 1] = obj
                end
            elseif obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if n:find("treadmill", 1, true) and not autoTreadmillIgnoredName(obj.Name) then
                    seen[obj] = true
                    candidates[#candidates + 1] = obj
                end
            end
        end

        add(instance)
        local ok, descendants = pcall(function() return instance:GetDescendants() end)
        if ok then
            for _, d in ipairs(descendants) do
                add(d)
            end
        end
    end

    collectReference(plot)
    if #candidates == 0 then
        collectReference(plot:FindFirstChild("Treadmills", true))
    end
    if #candidates == 0 then
        collectReference(plot:FindFirstChild("Stands", true))
    end
    if #candidates == 0 then
        for _, child in ipairs(Workspace:GetChildren()) do
            if child.Name:lower():find("tread", 1, true) then
                collectReference(child)
            end
        end
    end

    if #candidates == 0 then
        return nil
    end

    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local reference = root and root.Position
    if not reference then
        local ok, pivot = pcall(function() return plot:GetPivot() end)
        reference = ok and pivot.Position or nil
    end

    local best, bestScore
    for _, candidate in ipairs(candidates) do
        local pos = autoTreadmillPositionOf(candidate)
        if pos then
            local distance = reference and (pos - reference).Magnitude or 0
            local score = (candidate:IsA("Model") and 40 or 0) - distance
            local name = candidate.Name:lower()

            if name:find("treadmill", 1, true) then score += 100000 end
            if name == "treadmillbottom" then score += 200000 end

            local seat = findAutoTreadmillSeat and findAutoTreadmillSeat(candidate)
            if seat then score += 50000 end

            if not bestScore or score > bestScore then
                best = candidate
                bestScore = score
            end
        end
    end

    if best and type(st) == "table" then
        st.tread = best
    end

    return best
end

findAutoTreadmillSeat = function(treadmill)
    if not treadmill or typeof(treadmill) ~= "Instance" then
        return nil
    end

    if treadmill:IsA("Seat") or treadmill:IsA("VehicleSeat") then
        return treadmill
    end

    local ok, descendants = pcall(function()
        return treadmill:GetDescendants()
    end)
    if ok then
        for _, descendant in ipairs(descendants) do
            if descendant:IsA("Seat") or descendant:IsA("VehicleSeat") then
                return descendant
            end
        end
    end

    local parent = treadmill.Parent
    if parent and parent ~= Workspace then
        local okChildren, children = pcall(function()
            return parent:GetChildren()
        end)
        if okChildren then
            for _, child in ipairs(children) do
                if child:IsA("Seat") or child:IsA("VehicleSeat") then
                    return child
                end
            end
        end
    end

    return nil
end

local function flyToAutoTreadmill(position)
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root or not position then
        return false
    end

    local target = position + Vector3.new(0, 3, 0)
    local distance = (root.Position - target).Magnitude

    if distance <= 8 then
        pcall(function()
            root.CFrame = CFrame.new(target)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
        return true
    end

    local storedSpeed = (type(state) == "table" and tonumber(state.glideSpeed)) or nil
    local speed = math.max(120, tonumber(glideSpeed) or storedSpeed or 850)
    local duration = math.clamp(distance / speed, 0.08, 3)
    local startCF = root.CFrame
    local started = os.clock()

    while autoTreadmillEnabled
        and not autoStealEnabled
        and root.Parent
    do
        local alpha = math.clamp((os.clock() - started) / duration, 0, 1)

        pcall(function()
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = startCF:Lerp(CFrame.new(target), alpha)
        end)

        if alpha >= 1 then
            break
        end

        RunService.Heartbeat:Wait()
    end

    return autoTreadmillEnabled and not autoStealEnabled and root.Parent ~= nil
end

local function sitOnMyAutoTreadmill(treadmill)
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local seat = findAutoTreadmillSeat(treadmill)

    if not humanoid or humanoid.Health <= 0 or not root or not seat then
        return false
    end

    for _ = 1, 3 do
        if not autoTreadmillEnabled or autoStealEnabled then
            return false
        end

        if not seat.Parent then
            return false
        end

        pcall(function()
            humanoid.Sit = false
            root.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            seat:Sit(humanoid)
        end)

        task.wait(0.15)

        if humanoid.Sit or humanoid.SeatPart == seat then
            return true
        end
    end

    for _ = 1, 24 do
        if not autoTreadmillEnabled or autoStealEnabled then
            return false
        end

        if not seat.Parent then
            return false
        end

        if humanoid.Sit or humanoid.SeatPart == seat then
            return true
        end

        pcall(function()
            root.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            seat:Sit(humanoid)
        end)

        RunService.Heartbeat:Wait()
    end

    return humanoid.Sit == true or humanoid.SeatPart == seat
end

local autoTreadmillUpgradeEnabled = false
local autoTreadmillUpgradeAt = 0

local function doffAutoTreadmill()
    local remote = AskDoffTreadmillRemote
    if not remote then
        local ok, found = pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            local packages = rs:FindFirstChild("Packages")
            local networking = packages and packages:FindFirstChild("Networking")
            return networking and networking:FindFirstChild("RF/Treadmill/AskDoff")
        end)
        if ok then remote = found end
    end
    if not remote then return false end
    local ok = pcall(function()
        if remote:IsA("RemoteFunction") then
            remote:InvokeServer()
        elseif remote:IsA("RemoteEvent") then
            remote:FireServer()
        end
    end)
    return ok
end

local function upgradeAutoTreadmill()
    if not autoTreadmillUpgradeEnabled then return false end
    if os.clock() - autoTreadmillUpgradeAt < 3.5 then return false end
    autoTreadmillUpgradeAt = os.clock()

    local remote = GetNetRemote and GetNetRemote("RF/Treadmill/AskTierRaise")
    if not remote then return false end

    local ok = pcall(function()
        if remote:IsA("RemoteFunction") then
            remote:InvokeServer()
        else
            remote:FireServer()
        end
    end)
    return ok
end

local function runAutoTreadmill()
    if not autoTreadmillEnabled or autoStealEnabled then
        if not autoTreadmillBusy then
            doffAutoTreadmill()
        end
        return false
    end
    if autoTreadmillBusy then return false end

    autoTreadmillBusy = true
    local ok, result, reason = pcall(function()
        local treadmill = findMyAutoTreadmill()
        if not treadmill then
            return false, "TreadmillBottom not found in plot"
        end

        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then
            return false, "Character/Humanoid not found"
        end

        local seat = findAutoTreadmillSeat(treadmill)
        if seat then
            local distance = (root.Position - seat.Position).Magnitude
            if distance > 10 and not flyToAutoTreadmill(seat.Position) then
                return false, "Could not move to treadmill"
            end

            if not sitOnMyAutoTreadmill(treadmill) then
                return false, "Could not sit on treadmill seat"
            end

            upgradeAutoTreadmill()
            return true, "On treadmill"
        end

        local belt = treadmill
        if belt:IsA("Model") then
            local candidate
            local bestScore = -math.huge
            for _, descendant in ipairs(belt:GetDescendants()) do
                if descendant:IsA("BasePart") and not autoTreadmillIgnoredName(descendant.Name) then
                    local lower = descendant.Name:lower()
                    local score = descendant.Size.X * descendant.Size.Z
                    if lower:find("belt", 1, true)
                        or lower:find("tread", 1, true)
                        or lower:find("walk", 1, true)
                        or lower:find("run", 1, true)
                        or lower:find("platform", 1, true)
                    then
                        score += 100000
                    end
                    if score > bestScore then
                        bestScore = score
                        candidate = descendant
                    end
                end
            end
            belt = candidate or belt.PrimaryPart
        end

        local beltPosition = autoTreadmillPositionOf(belt) or autoTreadmillPositionOf(treadmill)
        if not beltPosition then
            return false, "Treadmill has no valid position"
        end

        local target = beltPosition + Vector3.new(0, 3, 0)
        if (root.Position - target).Magnitude > 10 then
            if not flyToAutoTreadmill(target) then
                return false, "Could not move to TreadmillBottom"
            end
        end

        local beltCF = nil
        pcall(function()
            if belt and belt:IsA("BasePart") then
                beltCF = belt.CFrame
            elseif treadmill:IsA("Model") then
                beltCF = treadmill:GetPivot()
            end
        end)
        beltCF = beltCF or CFrame.new(beltPosition)

        local look = beltCF.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude < 0.01 then
            flat = Vector3.new(0, 0, -1)
        else
            flat = flat.Unit
        end

        pcall(function()
            humanoid.WalkSpeed = math.max(humanoid.WalkSpeed, 60)
        end)

        local side = Vector3.new(root.Position.X - beltPosition.X, 0, root.Position.Z - beltPosition.Z)
        if side:Dot(flat) < 0 then flat = -flat end

        humanoid:Move(flat, false)
        root.CFrame = CFrame.lookAt(target, target + flat)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        upgradeAutoTreadmill()
        return true, "Standing/running on TreadmillBottom"
    end)

    autoTreadmillBusy = false

    if not ok then
        if os.clock() - autoTreadmillLastErrorAt >= 3 then
            autoTreadmillLastErrorAt = os.clock()
        end
        return false
    end

    if result ~= true and reason then
    end

    return result == true
end

local lastTreadmillActiveState = autoTreadmillEnabled
local function syncAutoTreadmillWithAutoSteal()
    local nextState = false
    if lastTreadmillActiveState and not nextState then
        doffAutoTreadmill()
    end
    autoTreadmillEnabled = nextState
    lastTreadmillActiveState = nextState
end

task.spawn(function()
    while not HUB.dead do
        if not HUB.paused then
            syncAutoTreadmillWithAutoSteal()

            if autoTreadmillEnabled
                and not autoStealEnabled
                and os.clock() - autoTreadmillLastRun >= 0.35
            then
                autoTreadmillLastRun = os.clock()

                local character = LocalPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                if humanoid and humanoid.Health > 0 then
                    runAutoTreadmill()
                end
            end
        end

        task.wait(0.2)
    end
end)

HUB.UI.EggsTab = Window:AddTab({ Name = "Eggs", Subtitle = "", Icon = "egg" })

HUB.UI.TreadmillSub = HUB.UI.EggsTab:AddSubTab("Auto Treadmill")
HUB.UI.TreadmillSub:AddToggle({
    Name = "Auto Treadmill",
    Default = false,
    Flag = "auto_treadmill",
    Callback = safeCallback(function(v)
        if autoStealEnabled then
            autoTreadmillUserEnabled = false
            autoTreadmillEnabled = false
            doffAutoTreadmill()
            return
        end
        autoTreadmillUserEnabled = v == true
        autoTreadmillEnabled = false
        if not autoTreadmillEnabled then
            doffAutoTreadmill()
        end
    end)
})
HUB.UI.TreadmillSub:AddToggle({
    Name = "Auto upgrade treadmill",
    Default = true,
    Flag = "auto_upgrade_treadmill",
    Callback = safeCallback(function(v)
        autoTreadmillUpgradeEnabled = v == true
        Notify("Treadmill Upgrade", autoTreadmillUpgradeEnabled and "Enabled" or "Disabled", autoTreadmillUpgradeEnabled and "Success" or "Info")
    end)
})

HUB.UI.BaseTab = Window:AddTab({ Name = "Base", Subtitle = "", Icon = "home" })
HUB.UI.CombatTab = Window:AddTab({ Name = "Combat", Subtitle = "", Icon = "swords" })
HUB.UI.PlayerTab = Window:AddTab({ Name = "Player", Subtitle = "", Icon = "users" })

HUB.UI.StealSub = HUB.UI.EggsTab:AddSubTab("Auto Steal")

HUB.UI.StealSub:AddToggle({
    Name = "Auto Steal Eggs", Default = false, Flag = "steal_auto",
    Callback = safeCallback(function(v)
        autoStealEnabled = v
        if v then
            autoTreadmillEnabled = false
            doffAutoTreadmill()
        else
            cancelImportedSteal()
            autoTreadmillEnabled = false
            autoTreadmillUserEnabled = false
            doffAutoTreadmill()
        end
    end)
})
HUB.UI.StealSub:AddToggle({Name = "Defend egg", Default = false,
    Flag = "phuc_defend_egg", Callback = function(v) HUB.V44.defendEgg = v == true end})
HUB.UI.StealSub:AddToggle({
    Name = "Only steal eggs with confirmed >= 100M money/s", Default = false, Flag = "phuc_100m",
    Callback = function(v) HUB.V44.only100m = v == true end
})
HUB.UI.StealSub:AddToggle({
    Name = "Anti Egg Drop ", Default = true, Flag = "anti_egg_drop",
    Callback = safeCallback(function(v)
        HUB.AntiEggDrop.SetEnabled(v)
    end)
})
HUB.UI.StealSub:AddToggle({
    Name = "Rare Egg Hunter (Highest Rarity First)", Default = true, Flag = "rare_hunter",
    Callback = function(v) rareEggHunter = v end
})
HUB.UI.StealSub:AddMultiDropdown({
    Name = "Filter by Rarity (Multi-Select)", Options = RARITY_NAMES, Default = {}, Flag = "steal_rarities",
    Callback = function(selectedList) selectedStealRarities = selectedList end
})
HUB.UI.StealSub:AddMultiDropdown({
    Name = "Filter by Area (Multi-Select)", Options = AREA_NAMES, Default = {}, Flag = "steal_areas",
    Callback = function(selectedList) selectedStealAreas = selectedList end
})
HUB.UI.StealSub:AddMultiDropdown({
    Name = "Filter by Mutation (Multi-Select)", Options = MUTATION_FILTERS, Default = {}, Flag = "steal_muts",
    Callback = function(selectedList) selectedMutationTypes = selectedList end
})
HUB.UI.StealSub:AddSlider({
    Name = "Glide / Travel Speed", Min = 150, Max = 850, Default = 850, Suffix = " studs/s", Flag = "glide_speed",
    Callback = function(v) glideSpeed = math.clamp(tonumber(v) or 850, 150, 850) end
})
HUB.UI.StealSub:AddSlider({
    Name = "Steal Delay Gap", Min = 0.35, Max = 10, Default = 0.75, Suffix = "s", Flag = "steal_gap",
    Callback = function(v) stealDelay = math.clamp(tonumber(v) or 0.75, 0.35, 10) end
})
HUB.UI.StealSub:AddButton({
    Name = "Steal Best Available Egg Once", Primary = true,
    Callback = safeCallback(function()
        local ok, reason = StealBestEggOnce()
        Notify("Steal Egg", ok and "Stole egg using selected mode" or (reason or "Could not steal egg"), ok and "Success" or "Info")
    end)
})

HUB.UI.HatchSub = HUB.UI.EggsTab:AddSubTab("Auto Hatch & Plant")
HUB.UI.HatchSub:AddToggle({
    Name = "Auto Hatch Ready Eggs", Default = false, Flag = "hatch_auto",
    Callback = safeCallback(function(v)
        autoHatchEnabled = v
        Notify("Auto Hatch", v and "Enabled" or "Disabled", v and "Success" or "Error")
    end)
})
HUB.UI.HatchSub:AddToggle({
    Name = "Auto Place Egg (Base Pen)", Default = false, Flag = "plant_auto",
    Callback = function(v)
        autoPlantEnabled = v
        Notify("Auto Place Egg", v and "Enabled" or "Disabled", v and "Success" or "Error")
    end
})
HUB.UI.HatchSub:AddSlider({
    Name = "Hatch Check Delay", Min = 0.5, Max = 10, Default = 2.0, Suffix = "s", Flag = "hatch_gap",
    Callback = function(v) hatchCheckDelay = v end
})
HUB.UI.HatchSub:AddButton({
    Name = "Hatch All Ready Eggs Now", Primary = true,
    Callback = safeCallback(function()
        local count = HatchAllReadyEggs()
        Notify("Hatch", "Hatched " .. count .. " egg(s)", "Success")
    end)
})
HUB.UI.HatchSub:AddButton({
    Name = "Place Carried Eggs in Pen Now",
    Callback = safeCallback(function()
        local count = PlantAllCarriedEggsInPen()
        Notify("Plant Eggs", "Planted " .. count .. " egg(s) in pen", "Success")
    end)
})

HUB.UI.EggEspSub = HUB.UI.EggsTab:AddSubTab("Egg Tracker ESP")
HUB.UI.EggEspSub:AddToggle({
    Name = "Egg ESP Enabled", Default = false, Flag = "esp_eggs_enabled",
    Callback = safeCallback(function(v)
        esp.enabled = v
        Notify("Egg ESP", v and "Enabled" or "Disabled", v and "Success" or "Error")
    end)
})
HUB.UI.EggEspSub:AddToggle({
    Name = "Show 3D Pet Image Badges", Default = true, Flag = "esp_pet_icons",
    Callback = function(v) esp.showPetIcons = v end
})
HUB.UI.EggEspSub:AddToggle({
    Name = "Trap ESP (Highlights Enemy Traps)", Default = false, Flag = "esp_traps",
    Callback = function(v) esp.traps = v end
})
HUB.UI.EggEspSub:AddToggle({
    Name = "Show Mutated / Rare Eggs Only", Default = false, Flag = "esp_eggs_rare_only",
    Callback = function(v) esp.rareEggsOnly = v end
})
HUB.UI.EggEspSub:AddSlider({
    Name = "Max ESP Distance", Min = 4000, Max = 9999, Default = 800, Suffix = " studs", Flag = "esp_max_dist",
    Callback = function(v) esp.maxDistance = v end
})

do
HUB.UI.UpgradesSub = HUB.UI.BaseTab:AddSubTab("Homestead & Treadmill")

HUB.UI.UpgradesSub:AddToggle({
    Name = "Auto Upgrade Base / Plot", Default = false, Flag = "up_base_auto",
    Callback = function(v) autoUpgradeBase = v end
})
HUB.UI.UpgradesSub:AddToggle({
    Name = "Auto Upgrade Treadmill Tier", Default = false, Flag = "up_tread_auto",
    Callback = function(v) autoUpgradeTreadmill = v end
})
HUB.UI.UpgradesSub:AddToggle({
    Name = "Auto Buy Speed Trails", Default = false, Flag = "auto_buy_trails",
    Callback = function(v) autoBuyTrails = v end
})
HUB.UI.UpgradesSub:AddButton({
    Name = "Upgrade Base Now", Primary = true,
    Callback = safeCallback(function()
        UpgradeHomesteadBase()
        Notify("Base Upgrade", "Requested base upgrade", "Success")
    end)
})
HUB.UI.UpgradesSub:AddButton({
    Name = "Upgrade Treadmill Now",
    Callback = safeCallback(function()
        UpgradeTreadmillTier()
        Notify("Treadmill Upgrade", "Requested treadmill upgrade", "Success")
    end)
})

HUB.UI.PetsSub = HUB.UI.BaseTab:AddSubTab("Pets & Satchel")

HUB.UI.PetsSub:AddButton({
    Name = "Equip Best Pets Now", Primary = true,
    Callback = safeCallback(function()
        EquipBestPets()
        Notify("Pets", "Equipped best pets", "Success")
    end)
})

HUB.UI.SalesSub = HUB.UI.BaseTab:AddSubTab("Auto Sell")

HUB.UI.SalesSub:AddToggle({
    Name = "Auto Sell Low-Tier Pets", Default = false, Flag = "auto_sell_pets",
    Callback = function(v) autoSellPets = v end
})
HUB.UI.SalesSub:AddMultiDropdown({
    Name = "Filter Pet Sell Rarities", Options = RARITY_NAMES, Default = {}, Flag = "sell_pet_rarities",
    Callback = function(selectedList) selectedSellPetRarities = selectedList end
})
HUB.UI.SalesSub:AddToggle({
    Name = "Auto Sell Low-Tier Eggs", Default = false, Flag = "auto_sell_eggs",
    Callback = function(v) autoSellEggs = v end
})
HUB.UI.SalesSub:AddMultiDropdown({
    Name = "Filter Egg Sell Rarities", Options = RARITY_NAMES, Default = {}, Flag = "sell_egg_rarities",
    Callback = function(selectedList) selectedSellEggRarities = selectedList end
})
HUB.UI.SalesSub:AddButton({
    Name = "Sell Selected Pets Now", Primary = true,
    Callback = safeCallback(function()
        SellSelectedPets()
        Notify("Sales", "Sold matching pets", "Success")
    end)
})
HUB.UI.SalesSub:AddButton({
    Name = "Sell Selected Eggs Now",
    Callback = safeCallback(function()
        SellSelectedEggs()
        Notify("Sales", "Sold matching eggs", "Success")
    end)
})

local abyssGuardFlyEnabled = false
local abyssGuardFlyThread = nil

local function findAbyssOceanGuard()
    local objects = Workspace:FindFirstChild("__OBJECTS")
    local areas = objects and objects:FindFirstChild("Areas")
    local guardAreas = areas and areas:FindFirstChild("GuardAreas")
    local abyss = guardAreas and guardAreas:FindFirstChild("Abyss Ocean")
    local guard = abyss and abyss:FindFirstChild("Guard")
    if not guard then return nil end
    return guard:FindFirstChild("Model") or guard:FindFirstChildWhichIsA("Model", true) or guard
end

local function getModelPosition(model)
    if not model then return nil end
    local ok, cf = pcall(function() return model:GetPivot() end)
    if ok and cf then return cf.Position end
    local part = model:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position or nil
end

local function flyToAbyssOceanGuard()
    local target = findAbyssOceanGuard()
    local pos = getModelPosition(target)
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not target or not pos or not root then return false end
    pcall(function() LocalPlayer:RequestStreamAroundAsync(pos) end)
    local ok = pcall(function() TravelRoadPath(pos + Vector3.new(0, 3, 0), glideSpeed or 200, true) end)
    if not ok then
        pcall(function() root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) end)
    end
    return true
end

HUB.UI.RewardsSub = HUB.UI.BaseTab:AddSubTab("Claim Rewards")
HUB.UI.RewardsSub:AddToggle({
    Name = "Auto Claim Away Earnings & Codex", Default = false, Flag = "claim_auto_rewards",
    Callback = function(v) autoClaimRewards = v end
})
HUB.UI.RewardsSub:AddButton({
    Name = "Claim Away Earnings & Codex Now", Primary = true,
    Callback = safeCallback(function()
        ClaimAllAvailableRewards()
        Notify("Rewards", "Claimed all ready rewards and earnings", "Success")
    end)
})
end

do
HUB.UI.BatSub = HUB.UI.CombatTab:AddSubTab("Bat & Slap Aura")

HUB.UI.BatSub:AddToggle({
    Name = "Bat / Slap Aura", Default = false, Flag = "bat_aura_enabled",
    Callback = safeCallback(function(v)
        batAuraEnabled = v
        Notify("Bat Aura", v and "Enabled" or "Disabled", v and "Success" or "Error")
    end)
})
HUB.UI.BatSub:AddSlider({
    Name = "Aura Radius", Min = 5, Max = 50, Default = 20, Suffix = " studs", Flag = "bat_radius",
    Callback = function(v) batAuraRadius = v end
})
HUB.UI.BatSub:AddSlider({
    Name = "Swing Delay", Min = 0.05, Max = 1.0, Default = 0.2, Suffix = "s", Flag = "bat_delay",
    Callback = function(v) batAuraDelay = v end
})
HUB.UI.BatSub:AddButton({
    Name = "Swing Bat Once (Manual)", Primary = true,
    Callback = safeCallback(function()
        local re = GetNetRemote("RE/BatSwing/Trigger")
        if re then re:FireServer() end
        Notify("Bat", "Triggered bat swing", "Info")
    end)
})

HUB.UI.GuardSub = HUB.UI.CombatTab:AddSubTab("Defense & Guards")
HUB.UI.GuardSub:AddToggle({
    Name = "Anti-Trap (Full Immunity / Destroy Hitboxes)", Default = true, Flag = "avoid_traps",
    Callback = safeCallback(function(v)
        avoidTrapsEnabled = v
        if v then pcall(NeutralizeTraps) end
        Notify("Anti-Trap", v and "Immunity active, enemy hitboxes destroyed" or "Anti Trap disabled", v and "Success" or "Error")
    end)
})

HUB.UI.GuardSub:AddToggle({
    Name = "No Knockback / Ragdoll Immunity", Default = true, Flag = "no_knockback",
    Callback = safeCallback(function(v)
        SetNoKnockback(v)
        Notify("Knockback", v and "Ragdoll immunity active" or "Knockback enabled", v and "Success" or "Error")
    end)
})

HUB.UI.GuardSub:AddToggle({
    Name = "Anti-Ragdoll (Quick Standup)", Default = true, Flag = "anti_ragdoll",
    Callback = function(v) antiRagdollEnabled = v end
})

track(RunService.Heartbeat:Connect(function()
    if HUB.dead or not antiRagdollEnabled then return end
    local hum = findHum()
    if hum and hum:GetState() == Enum.HumanoidStateType.Physics then
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end))
end

do
HUB.UI.MoveSub = HUB.UI.PlayerTab:AddSubTab("Movement")

HUB.UI.MoveSub:AddToggle({
    Name = "Enable WalkSpeed", Default = false, Flag = "speed_enabled",
    Callback = safeCallback(function(v)
        walkSpeedEnabled = v
        local hum = findHum()
        if hum then
            if v and not originalWalkSpeed then originalWalkSpeed = hum.WalkSpeed end
            if not v and not HUB.Runtime.phucMovementBusy() then hum.WalkSpeed = originalWalkSpeed or 500 end
        end
        Notify("WalkSpeed", v and "Enabled" or "Disabled", v and "Success" or "Error")
    end)
})
HUB.UI.MoveSub:AddSlider({
    Name = "WalkSpeed Value", Min = 500, Max = 850, Default = 24, Suffix = " studs/s", Flag = "speed_val",
    Callback = function(v) HUB.Runtime.ApplyWalkSpeed(v) end
})

HUB.UI.MoveSub:AddToggle({
    Name = "Infinite Jump", Default = false, Flag = "phuc_infinite_jump",
    Callback = function(v) infiniteJump = v == true end
})
HUB.UI.MoveSub:AddToggle({
    Name = "Anti-AFK (Bypass 20min Kick)", Default = true, Flag = "anti_afk",
    Callback = function(v) HUB.Runtime.SetAntiAFK(v) end
})

HUB.BuildPlayerExtrasUI = function()
    local selectedAreaTp = "Base / Plot"
    local areaKeys = {}
    for k in pairs(AREA_COORDINATES) do
        table.insert(areaKeys, k)
    end
    table.sort(areaKeys)

    local AreaTpSub = HUB.UI.PlayerTab:AddSubTab("Area Travel")

    AreaTpSub:AddDropdown({
        Name = "Select Area", Options = areaKeys, Items = areaKeys, Default = "Base / Plot", Flag = "tele_area",
        Callback = function(v) selectedAreaTp = v end
    })
    AreaTpSub:AddButton({
        Name = "Travel to Selected Area", Primary = true,
        Callback = safeCallback(function()
            local pos = AREA_COORDINATES[selectedAreaTp]
            if selectedAreaTp == "Base / Plot" then
                pos = GetLocalPlotCenter()
            end
            if pos then
                Notify("Travel", "Traveling to " .. selectedAreaTp, "Info")
                TravelRoadPath(pos, glideSpeed or 200)
                Notify("Travel", "Arrived at " .. selectedAreaTp, "Success")
            else
                Notify("Travel", "Area position not found", "Error")
            end
        end)
    })

    local PlotTpSub = HUB.UI.PlayerTab:AddSubTab("Plot Travel")
    local selectedPlotNum = "My Plot"
    local plotOptions = { "My Plot" }
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if plotsFolder then
        local numberedPlots = {}
        for _, plotObj in ipairs(plotsFolder:GetChildren()) do
            local n = tonumber(plotObj.Name)
            if n then table.insert(numberedPlots, n) end
        end
        table.sort(numberedPlots)
        for _, n in ipairs(numberedPlots) do
            table.insert(plotOptions, "Plot " .. tostring(n))
        end
    end

    PlotTpSub:AddDropdown({
        Name = "Select Plot", Options = plotOptions, Items = plotOptions, Default = "My Plot", Flag = "tele_plot",
        Callback = function(v) selectedPlotNum = v end
    })
    PlotTpSub:AddButton({
        Name = "Travel to Plot", Primary = true,
        Callback = safeCallback(function()
            local slotNum
            if selectedPlotNum == "My Plot" then
                slotNum = GetLocalSlot()
            else
                slotNum = tonumber(tostring(selectedPlotNum):match("%d+")) or 1
            end

            local plots = Workspace:FindFirstChild("Plots")
            local plot = plots and plots:FindFirstChild(tostring(slotNum))
            local targetPos = plot and (plot:FindFirstChild("CenterPoint") and plot.CenterPoint.Position or plot:GetPivot().Position)
            if targetPos then
                TravelRoadPath(targetPos + Vector3.new(0, 2, 0), glideSpeed or 200)
                Notify("Plot", "Arrived at Plot " .. tostring(slotNum), "Success")
            else
                Notify("Plot", "Plot not found", "Error")
            end
        end)
    })

    local selectedPlayerName = nil
    local function GetPlayerList()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then table.insert(names, p.Name) end
        end
        table.sort(names)
        if #names == 0 then names = { "(no other players)" } end
        return names
    end

    local PlayerTpSub = HUB.UI.PlayerTab:AddSubTab("Player Travel")
    local playerDropdown = PlayerTpSub:AddDropdown({
        Name = "Select Player", Options = GetPlayerList(), Items = GetPlayerList(), Default = nil, Flag = "tele_plr",
        Callback = function(v) selectedPlayerName = v end
    })

    PlayerTpSub:AddButton({
        Name = "Refresh Player List",
        Callback = function()
            playerDropdown:SetOptions(GetPlayerList())
            Notify("Players", "Refreshed player list", "Info")
        end
    })
    PlayerTpSub:AddButton({
        Name = "Travel to Player", Primary = true,
        Callback = safeCallback(function()
            if not selectedPlayerName or selectedPlayerName == "(no other players)" then return end
            local targetPlr = Players:FindFirstChild(selectedPlayerName)
            local tHrp = targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart")
            if tHrp then
                TravelRoadPath(tHrp.Position + Vector3.new(0, 2, 0), glideSpeed or 200)
                Notify("Player", "Arrived at " .. selectedPlayerName, "Success")
            else
                Notify("Player", "Player unavailable", "Error")
            end
        end)
    })

    local PerfSub = HUB.UI.PlayerTab:AddSubTab("Visuals & Performance")
    PerfSub:AddToggle({
        Name = "Fullbright (Daylight Visuals)", Default = false, Flag = "fullbright",
        Callback = function(v) HUB.Runtime.SetFullbright(v) end
    })

    local function GetGuardRideEntries()
        local entries = {}
        local objects = Workspace:FindFirstChild("__OBJECTS")
        local areas = objects and objects:FindFirstChild("Areas")
        local guardAreas = areas and areas:FindFirstChild("GuardAreas")
        local seen = {}
        if guardAreas then
            for _, obj in ipairs(guardAreas:GetDescendants()) do
                if obj.Name == "Guard" then
                    local model = obj:IsA("Model") and obj
                        or obj:FindFirstChild("Model")
                        or obj:FindFirstChildWhichIsA("Model", true)
                    if model and model:IsA("Model") and not seen[model] then
                        seen[model] = true
                        local area = obj
                        while area.Parent and area.Parent ~= guardAreas do
                            area = area.Parent
                        end
                        table.insert(entries, {
                            key = tostring(area.Name) .. " | " .. tostring(obj:GetFullName()),
                            model = model,
                        })
                    end
                end
            end
        end
        table.sort(entries, function(a, b) return a.key < b.key end)
        return entries
    end

    local function GetGuardRideList()
        local list = {}
        for _, entry in ipairs(GetGuardRideEntries()) do
            table.insert(list, entry.key)
        end
        if #list == 0 then list = {"No Guard found"} end
        return list
    end

    local guardRideDropdown = PerfSub:AddDropdown({
        Name = "Select Guard to ride", Options = GetGuardRideList(), Items = GetGuardRideList(),
        Default = HUB.GuardRide.selectedGuardKey, Flag = "guard_ride_target",
        Callback = function(v)
            if v ~= "No Guard found" then
                HUB.GuardRide.selectedGuardKey = v
                HUB.GuardRide.selectedGuardName = v
            end
        end
    })

    PerfSub:AddButton({
        Name = "Refresh Guard list",
        Callback = safeCallback(function()
            local list = GetGuardRideList()
            pcall(function() guardRideDropdown:SetOptions(list) end)
        end)
    })

    PerfSub:AddToggle({
        Name = "Ride", Default = false, Flag = "guard_ride_visual",
        Callback = safeCallback(function(v)
            if v then
                HUB.GuardRide.Start()
            else
                HUB.GuardRide.Stop()
            end
        end)
    })
    PerfSub:AddButton({
        Name = "Delete Own Pet Renders (FPS Boost)", Primary = true,
        Callback = safeCallback(function()
            local count = DeleteOwnPetRenders()
            Notify("Performance", "Removed " .. count .. " rendered pet model(s)", "Success")
        end)
    })
end

HUB.BuildPlayerExtrasUI()
HUB.BuildPlayerExtrasUI = nil

HUB.Shop = { lastAttempt = -100, lastBought = {}, selectedTrail = nil, catalog = {}, discovered = {} }
HUB.Shop.TryAutoTrail = function()
    if HUB.dead or HUB.paused or not autoBuyTrails then return false end
    if os.clock() - HUB.Shop.lastAttempt < 12 then return false end
    HUB.Shop.lastAttempt = os.clock()
    local ok, bought, detail = pcall(BuyAffordableTrails)
    if not ok then logWarn("[Shop] " .. tostring(bought)) end
    return ok and bought == true, detail
end

HUB.BuildShopUI = function()
    local shopTab = Window:AddTab({Name = "Shop", Subtitle = "", Icon = "home"})
    local trailSub = shopTab:AddSubTab("Trail Shop")
    local function readCatalog()
        local items = {}
        local ok, data = pcall(function()
            local mod = RS:FindFirstChild("Data") and RS.Data:FindFirstChild("Trails")
            return mod and require(mod)
        end)
        if ok and type(data) == "table" then
            for id, row in pairs(data.Directory or data) do
                if type(row) == "table" then
                    local name = tostring(row.DisplayName or row.Name or id)
                    local uid = tostring(row._id or row.Id or id)
                    local price = tonumber(row.Price or row.Cost)
                    if uid ~= "" and price and price >= 0 then
                        table.insert(items, {id = uid, name = name, price = price})
                    end
                end
            end
        end
        table.sort(items, function(a,b)
            if a.price ~= b.price then return a.price < b.price end
            return a.name < b.name
        end)
        HUB.Shop.catalog = items
        return items
    end
    local function trailOptions()
        local result = {}
        for _, item in ipairs(HUB.Shop.catalog) do
            table.insert(result, item.name .. " | $" .. tostring(item.price) .. " | " .. item.id)
        end
        if #result == 0 then result[1] = "(No Trails data)" end
        return result
    end
    readCatalog()
    local trailDropdown = trailSub:AddDropdown({
        Name = "Select Trail", Options = trailOptions(), Default = trailOptions()[1],
        Callback = function(value) HUB.Shop.selectedTrail = value end
    })
    trailSub:AddButton({Name = "Rescan Trail list", Callback = safeCallback(function()
        readCatalog()
        trailDropdown:SetOptions(trailOptions())
        HUB.Shop.selectedTrail = nil
        Notify("Trail Shop", "Updated " .. tostring(#HUB.Shop.catalog) .. " items", "Info")
    end)})
    trailSub:AddButton({Name = "Buy selected Trail", Primary = true, Callback = safeCallback(function()
        if HUB.dead or HUB.paused then return end
        local selected = HUB.Shop.selectedTrail or trailDropdown:Get()
        local target
        for _, item in ipairs(HUB.Shop.catalog) do
            if selected == item.name .. " | $" .. tostring(item.price) .. " | " .. item.id then
                target = item
                break
            end
        end
        if not target then Notify("Shop", "No valid Trail selected", "Info"); return end
        local money = getPlayerMoney()
        if money < target.price then
            Notify("Shop", "Not enough money: $" .. tostring(target.price), "Info")
            return
        end
        local remote = GetNetRemote("RF/Trailwear/AskPurchase")
        if not remote or not remote:IsA("RemoteFunction") then
            Notify("Shop", "Server has no RF/Trailwear/AskPurchase", "Error")
            return
        end
        if HUB.Shop.lastBought[target.id] then
            Notify("Shop", "Purchase already sent this session; check inventory first", "Info")
            return
        end
        HUB.Shop.lastBought[target.id] = true
        local ok, answer = pcall(function() return remote:InvokeServer(target.id) end)
        if not ok then
            Notify("Shop", "Purchase error: " .. tostring(answer), "Error")
        else
            Notify("Shop", "Sent purchase request for " .. target.name .. " (check shop to confirm)", "Info")
        end
    end)})
    trailSub:AddToggle({Name = "Auto buy affordable Trail", Default = false, Flag = "phuc_shop_auto_trail",
        Callback = function(value) autoBuyTrails = value == true end})
    local discoverSub = shopTab:AddSubTab("Speed & Trail")
    local function setGameShop(name, enabled)
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local gui = playerGui and playerGui:FindFirstChild(name)
        if not gui then
            Notify("Shop", name .. " not loaded into PlayerGui yet", "Info")
            return
        end
        if gui:IsA("ScreenGui") then
            gui.Enabled = enabled
            Notify("Shop", (enabled and "Opened " or "Closed ") .. name, "Info")
        else
            Notify("Shop", "Found " .. gui:GetFullName() .. "; game controls opening", "Info")
        end
    end
    discoverSub:AddButton({Name = "Open SpeedShop", Primary = true,
        Callback = safeCallback(function() setGameShop("SpeedShop", true) end)})
    discoverSub:AddButton({Name = "Close SpeedShop",
        Callback = safeCallback(function() setGameShop("SpeedShop", false) end)})
    discoverSub:AddButton({Name = "Open TrailShop",
        Callback = safeCallback(function() setGameShop("TrailShop", true) end)})
    discoverSub:AddButton({Name = "Close TrailShop",
        Callback = safeCallback(function() setGameShop("TrailShop", false) end)})
    discoverSub:AddButton({Name = "Go to Shops area", Callback = safeCallback(function()
        local pos = AREA_COORDINATES["Stands & Shops"]
        if pos then TravelRoadPath(pos, glideSpeed) end
    end)})

end
HUB.BuildShopUI()
HUB.BuildShopUI = nil

do
    local V = HUB.V44
    V.droneEntry = nil
    V.droneSkipUntil = {}
    V.droneScanAt = 0
    V.droneStreamAt = 0
    V.droneLastHp = nil
    V.droneProgressAt = 0
    V.droneHitConn = nil
    V.droneAntiDropBefore = nil

    local function positionOf(obj)
        if not obj or not obj.Parent then return nil end
        if obj:IsA("BasePart") then return obj.Position end
        if obj:IsA("Model") then
            local ok, cf = pcall(function() return obj:GetPivot() end)
            if ok and cf then return cf.Position end
        end
        return nil
    end

    local function guardInfo(areaName)
        local objects = Workspace:FindFirstChild("__OBJECTS")
        local areas = objects and objects:FindFirstChild("Areas")
        local guards = areas and areas:FindFirstChild("GuardAreas")
        local area = guards and guards:FindFirstChild(areaName)
        local guard = area and area:FindFirstChild("Guard")
        local model = guard and guard:FindFirstChild("Model")
        return positionOf(model), guards
    end

    local function moveToward(root, goal, dt, maxSpeed)
        local difference = goal - root.Position
        if difference.Magnitude < 4 then return true end
        local speed = math.clamp(tonumber(maxSpeed) or tonumber(glideSpeed) or 300, 90, 850)
        local newPos = root.Position + difference.Unit * math.min(difference.Magnitude, speed * math.min(dt, 0.15))
        local facing = Vector3.new(goal.X - newPos.X, 0, goal.Z - newPos.Z)
        if facing.Magnitude < 0.01 then facing = root.CFrame.LookVector end
        root.CFrame = CFrame.lookAt(newPos, newPos + facing)
        root.AssemblyLinearVelocity = Vector3.zero
        return false
    end

    local function hpOf(obj)
        local hp = tonumber(obj:GetAttribute("Health") or obj:GetAttribute("HP")
            or obj:GetAttribute("CurrentHealth") or obj:GetAttribute("CurrentHP"))
        local maximum = tonumber(obj:GetAttribute("MaxHealth") or obj:GetAttribute("MaxHP")
            or obj:GetAttribute("MaximumHealth"))
        if not hp or not maximum then
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("Humanoid") then
                    hp = hp or child.Health
                    maximum = maximum or child.MaxHealth
                elseif child:IsA("TextLabel") or child:IsA("TextButton") then
                    local current, cap = tostring(child.Text):match("(%d+)%s*/%s*(%d+)")
                    if current and cap then
                        hp = hp or tonumber(current)
                        maximum = maximum or tonumber(cap)
                    end
                end
                if hp and maximum then break end
            end
        end
        return hp, maximum
    end

    local function isLive(obj, visuals)
        if not obj or not obj.Parent or not obj:IsDescendantOf(visuals) then return false end
        if obj.Name:sub(1, 12) ~= "DroneVisual_" then return false end
        if not (obj:IsA("BasePart") or obj:IsA("Model")) then return false end
        local hp = hpOf(obj)
        return (hp == nil or hp > 0) and positionOf(obj) ~= nil
    end

    local function dronePriority(obj)
        local hp, maxHp = hpOf(obj)
        if hp and hp <= 0 then return math.huge end
        if maxHp == 10 then return hp == 10 and 0 or 3 end
        if maxHp == 5 then return hp == 5 and 1 or 4 end
        if maxHp == 3 then return hp == 3 and 2 or 5 end
        return 6
    end

    local function stopHitConnection()
        if V.droneHitConn then
            pcall(function() V.droneHitConn:Disconnect() end)
            V.droneHitConn = nil
        end
    end

    local function restoreAntiDrop()
        if V.droneAntiDropBefore ~= nil then
            local old = V.droneAntiDropBefore
            V.droneAntiDropBefore = nil
            if HUB.AntiEggDrop and HUB.AntiEggDrop.SetEnabled then
                pcall(HUB.AntiEggDrop.SetEnabled, old)
            end
        end
    end

    local function resetEntry()
        stopHitConnection()
        restoreAntiDrop()
        V.droneEntry = nil
        V.droneTarget = nil
        V.droneLastHp = nil
        V.droneProgressAt = 0
        V.droneGuardReached = false
        V.droneSkipUntil = {}
    end
    V.ResetDroneEntry = resetEntry

    local function requestStream(point)
        if not point or os.clock() - V.droneStreamAt < 5 then return end
        V.droneStreamAt = os.clock()
        task.spawn(function()
            pcall(function() LocalPlayer:RequestStreamAroundAsync(point) end)
        end)
    end

    local function closestEgg(root)
        local nearest, nearestPos, nearestDist = nil, nil, math.huge
        for _, record in ipairs(readFieldEggs(false)) do
            if record.Uid and (record.State == "Slot" or record.State == 0 or record.State == nil) then
                local cf = record.BoundsCFrame or record.BottomCFrame or record.CFrame
                local pos = typeof(cf) == "CFrame" and cf.Position or nil
                if not pos then pos = positionOf(record.PhysicalModel) end
                if pos then
                    local d = (root.Position - pos).Magnitude
                    if d < nearestDist then
                        nearest, nearestPos, nearestDist = record, pos, d
                    end
                end
            end
        end
        return nearest, nearestPos
    end

    local function equipSpecificEgg(uid)
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local bag = LocalPlayer:FindFirstChild("Backpack")
        if not hum or not bag then return end
        for _, tool in ipairs(bag:GetChildren()) do
            if isEggTool(tool) and tostring(tool:GetAttribute("UID") or tool:GetAttribute("EggUid") or "") == tostring(uid) then
                pcall(function() hum:EquipTool(tool) end)
                break
            end
        end
    end

    local function teleportAboveAbyss()
        if HUB.dead or HUB.paused or not V.droneFollow then return end
        local point = guardInfo("Abyss Ocean")
        local root = findHRP()
        if not point or not root then return end
        stopHitConnection()
        restoreAntiDrop()
        V.droneEntry = { stage = "ready", started = os.clock() }
        V.droneGuardReached = true
        root.CFrame = CFrame.new(point + Vector3.new(0, 50, 0))
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        requestStream(point)
    end

    local function waitForSingleGuardHit(entry, guardPosition)
        entry.stage = "wait_hit"
        entry.started = os.clock()
        entry.hitPoint = guardPosition
        entry.hadEgg = true
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        entry.humanoid = hum
        entry.healthBefore = hum and hum.Health or nil
        stopHitConnection()
        if hum then
            V.droneHitConn = track(hum.HealthChanged:Connect(function(newHealth)
                local active = V.droneEntry
                local root = findHRP()
                if active ~= entry or active.stage ~= "wait_hit" or not V.droneFollow then return end
                if not root or (root.Position - guardPosition).Magnitude > 90 then return end
                if active.healthBefore and newHealth < active.healthBefore - 0.1 then
                    teleportAboveAbyss()
                end
            end))
        end
    end

    local function doEntry(root, dt, abyssPosition)
        local entry = V.droneEntry
        if not entry then
            if (root.Position - abyssPosition).Magnitude <= 300 then
                V.droneEntry = { stage = "approach", started = os.clock() }
            else
                local record, eggPos = closestEgg(root)
                if record and eggPos then
                    local guardPoint, guards = guardInfo(tostring(record.AreaId or ""))
                    if not guardPoint and guards then
                        local closest = math.huge
                        for _, area in ipairs(guards:GetChildren()) do
                            local guard = area:FindFirstChild("Guard")
                            local model = guard and guard:FindFirstChild("Model")
                            local pos = positionOf(model)
                            if pos and (pos - eggPos).Magnitude < closest then
                                guardPoint, closest = pos, (pos - eggPos).Magnitude
                            end
                        end
                    end
                    if guardPoint and (guardPoint - eggPos).Magnitude < 200 then
                        entry = {stage = "to_egg", started = os.clock(), uid = record.Uid,
                            eggPos = eggPos, eggModel = record.PhysicalModel, guardPos = guardPoint,
                            lastCarryAt = 0, carryBusy = false}
                        V.droneEntry = entry
                        if HUB.AntiEggDrop and HUB.AntiEggDrop.SetEnabled then
                            V.droneAntiDropBefore = HUB.AntiEggDrop.enabled == true
                            pcall(HUB.AntiEggDrop.SetEnabled, false)
                        end
                        requestStream(eggPos)
                    else
                        V.droneEntry = { stage = "approach", started = os.clock() }
                    end
                else
                    V.droneEntry = { stage = "approach", started = os.clock() }
                end
            end
            entry = V.droneEntry
        end
        if not entry then return false end

        if entry.stage == "to_egg" or entry.stage == "pick" then
            if hasEggInInventory(entry.uid) then
                equipSpecificEgg(entry.uid)
                waitForSingleGuardHit(entry, entry.guardPos)
                return false
            end
            if os.clock() - entry.started > 14 then
                stopHitConnection(); restoreAntiDrop()
                entry.stage, entry.started = "approach", os.clock()
                return false
            end
            if not moveToward(root, entry.eggPos + Vector3.new(0, 1, 0), dt, glideSpeed) then return false end
            entry.stage = "pick"
            if os.clock() - entry.lastCarryAt >= 0.55 and not entry.carryBusy then
                entry.lastCarryAt, entry.carryBusy = os.clock(), true
                pcall(function() triggerEggPromptsNearTarget(entry.eggModel, entry.eggPos) end)
                local uid = entry.uid
                task.spawn(function()
                    pcall(function()
                        if AskFieldEggCarryRemote and AskFieldEggCarryRemote:IsA("RemoteFunction") then
                            AskFieldEggCarryRemote:InvokeServer({Uid = uid})
                        elseif AskFieldEggCarryRemote and AskFieldEggCarryRemote:IsA("RemoteEvent") then
                            AskFieldEggCarryRemote:FireServer({Uid = uid})
                        end
                    end)
                    entry.carryBusy = false
                end)
            end
            return false
        end

        if entry.stage == "wait_hit" then
            if os.clock() - entry.started > 22 then
                stopHitConnection(); restoreAntiDrop()
                entry.stage, entry.started = "approach", os.clock()
                return false
            end
            local dist = (root.Position - entry.hitPoint).Magnitude
            if dist > 12 then
                moveToward(root, entry.hitPoint + Vector3.new(0, 2, 0), dt, 225)
            end
            if entry.hadEgg and not hasEggInInventory(entry.uid) and dist < 90 then
                teleportAboveAbyss()
                return false
            end
            local hum = entry.humanoid
            if hum and hum.Parent and entry.healthBefore and hum.Health < entry.healthBefore - 0.1 and dist < 90 then
                teleportAboveAbyss()
            end
            return false
        end

        if entry.stage == "approach" then
            if moveToward(root, abyssPosition + Vector3.new(0, 5, 0), dt, glideSpeed) then
                restoreAntiDrop()
                V.droneGuardReached = true
                entry.stage = "ready"
                requestStream(abyssPosition)
            end
            return false
        end
        return entry.stage == "ready"
    end

    V.DroneStep = function(dt)
        if HUB.dead or HUB.paused or not V.droneFollow or ImportedSteal.busy then return end
        local root = findHRP()
        if not root then return end
        if not V.droneGuardReached then
            local abyss = guardInfo("Abyss Ocean")
            if not abyss then return end
            doEntry(root, dt, abyss)
            return
        end
        local visuals = Workspace:FindFirstChild("ScrambleLocalVisuals")
        if not visuals then V.droneTarget = nil; return end
        local selected = V.droneTarget
        if not isLive(selected, visuals) then
            V.droneTarget = nil
            selected = nil
        end
        local now = os.clock()
        local currentPosition = selected and positionOf(selected) or nil
        if currentPosition and (root.Position - currentPosition).Magnitude <= 7
            and now - V.droneProgressAt > 19 then
            V.droneSkipUntil[selected] = now + 12
            V.droneTarget = nil
            selected = nil
        end
        if not selected and now - V.droneScanAt >= 0.28 then
            V.droneScanAt = now
            local bestPriority, bestDist = math.huge, math.huge
            for _, candidate in ipairs(visuals:GetDescendants()) do
                if isLive(candidate, visuals) and (V.droneSkipUntil[candidate] or 0) <= now then
                    local priority = dronePriority(candidate)
                    local pos = positionOf(candidate)
                    local distance = (root.Position - pos).Magnitude
                    if priority < bestPriority or (priority == bestPriority and distance < bestDist) then
                        selected, bestPriority, bestDist = candidate, priority, distance
                    end
                end
            end
            V.droneTarget = selected
            V.droneLastHp = selected and hpOf(selected) or nil
            V.droneProgressAt = now
            if selected then requestStream(positionOf(selected)) end
        end
        if not selected then return end
        local position = positionOf(selected)
        if not position then V.droneTarget = nil; return end
        if (position - root.Position).Magnitude > 300 then requestStream(position) end
        local hp = hpOf(selected)
        if hp ~= V.droneLastHp then
            V.droneLastHp = hp
            V.droneProgressAt = now
        end
        local diff = position - root.Position
        local distance = diff.Magnitude
        if distance > 5 then
            local goal = position - diff.Unit * 4
            moveToward(root, goal, dt, glideSpeed)
        elseif now - V.droneSwingAt > 0.38 then
            V.droneSwingAt = now
            local char = LocalPlayer.Character
            local tool = char and char:FindFirstChildWhichIsA("Tool")
            if tool and tool:GetAttribute("IsBat") ~= true and not tool.Name:lower():find("bat") then
                tool = nil
            end
            if not tool then
                local bag = LocalPlayer:FindFirstChild("Backpack")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if bag and hum then
                    for _, candidate in ipairs(bag:GetChildren()) do
                        if candidate:IsA("Tool") and
                            (candidate:GetAttribute("IsBat") == true or candidate.Name:lower():find("bat")) then
                            hum:EquipTool(candidate)
                            tool = candidate
                            break
                        end
                    end
                end
            end
            if tool then pcall(function() tool:Activate() end) end
        end
    end
    
    local EventsSub = HUB.UI.BaseTab:AddSubTab("Events")

EventsSub:AddButton({
    Name = "Fly to event area ", Primary = true,
    Callback = safeCallback(function()
        flyToAbyssOceanGuard()
    end)
})


    HUB.BuildDroneUI = function()
        local eventTab = Window:AddTab({Name = "Event", Subtitle = "", Icon = "combat"})
        local droneSub = eventTab:AddSubTab("Drone")
        droneSub:AddToggle({Name = "Auto new event ", Default = false,
            Flag = "phuc_drone_follow", Callback = function(on)
                V.droneFollow = on == true
                resetEntry()
            end})
    end
    HUB.BuildDroneUI()
    HUB.BuildDroneUI = nil
    track(RunService.Heartbeat:Connect(function(dt)
        if V.droneFollow and not ImportedSteal.busy
            and (not autoStealEnabled or not V.hasEligibleEgg) then
            if os.clock() - V.droneAt >= 0.10 then
                V.droneAt = os.clock()
                pcall(V.DroneStep, math.max(dt, 0.10))
            end
        end
    end))
end

pcall(function() avoidTrapsEnabled = true; NeutralizeTraps() end)
pcall(function() noKnockbackEnabled = true; SetNoKnockback(true) end)
pcall(function() antiRagdollEnabled = true end)
pcall(function() HUB.Runtime.SetAntiAFK(true) end)
pcall(function() HUB.AntiEggDrop.SetEnabled(true) end)

end

function HUB.SetEnabled(value)
    if HUB.dead then return end
    local shouldPause = value ~= true
    if HUB.paused == shouldPause then return end
    HUB.paused = shouldPause
    if shouldPause then
        if HUB.V44 and HUB.V44.ResetDroneEntry then pcall(HUB.V44.ResetDroneEntry) end
        HUB.pauseSnapshot = {
            ride = HUB.GuardRide and HUB.GuardRide.enabled or false,
            antiEgg = HUB.AntiEggDrop and HUB.AntiEggDrop.enabled or false,
            antiAFK = antiAFK == true,
            fullbright = fullbrightEnabled == true,
            fly = flying == true,
        }
        pcall(cancelImportedSteal)
        if walkSpeedEnabled then
            pcall(function()
                local hum = findHum()
                if hum and not HUB.Runtime.phucMovementBusy() then hum.WalkSpeed = originalWalkSpeed or 500 end
            end)
        end
        pcall(stopFly)
        if HUB.GuardRide then pcall(function() HUB.GuardRide.Stop() end) end
        if HUB.AntiEggDrop then pcall(function() HUB.AntiEggDrop.SetEnabled(false) end) end
        pcall(function() HUB.Runtime.SetAntiAFK(false) end)
        pcall(function() HUB.Runtime.SetFullbright(false) end)
        Notify("LSS HUB", "Paused; UI remains open to re-enable.", "Info", 3)
    else
        local prev = HUB.pauseSnapshot or {}
        HUB.pauseSnapshot = nil
        if prev.antiEgg and HUB.AntiEggDrop then
            pcall(function() HUB.AntiEggDrop.SetEnabled(true) end)
        end
        if prev.antiAFK then pcall(function() HUB.Runtime.SetAntiAFK(true) end) end
        if prev.fullbright then pcall(function() HUB.Runtime.SetFullbright(true) end) end
        if prev.ride and HUB.GuardRide then pcall(function() HUB.GuardRide.Start() end) end
        if prev.fly then pcall(HUB.Runtime.startFly) end
        Notify("LSS HUB", "Resumed.", "Success", 3)
    end
end

do
HUB.UI.SettingsTab = Window:AddTab({Name = "Settings", Subtitle = "", Icon = "settings"})
HUB.UI.SettingsTab:AddToggle({
    Name = "Auto re-run on server hop", Flag = "settings_resume", Default = LSS HUB_CFG.autoResume,
    Callback = function(on)
        LSS HUB_CFG.autoResume = on == true
        LSS HUB_CFG.Save(true)
        if LSS HUB_CFG.autoResume then LSS HUB_CFG.Queue() end
    end
})
HUB.UI.SettingsTab:AddToggle({
    Name = "Auto save settings", Flag = "settings_autosave", Default = LSS HUB_CFG.autoSave,
    Callback = function(on)
        LSS HUB_CFG.autoSave = on == true
        LSS HUB_CFG.Save(true)
    end
})
HUB.UI.SettingsTab:AddButton({
    Name = "Save config", Primary = true,
    Callback = safeCallback(function()
        local ok, err = LSS HUB_CFG.Save(true)
        Notify("Settings", ok and "Saved" or ("Save failed: " .. tostring(err)), ok and "Success" or "Error")
    end)
})
HUB.UI.SettingsTab:AddButton({
    Name = "Load config",
    Callback = safeCallback(function()
        local ok, err = LSS HUB_CFG.LoadAndApply()
        Notify("Settings", ok and "Loaded" or ("Load failed: " .. tostring(err)), ok and "Success" or "Error")
    end)
})
HUB.UI.SettingsTab:AddToggle({
    Name = "Enable LSS HUB activity", Default = true, Flag = "phucmax_enabled",
    Callback = function(on) HUB.SetEnabled(on) end
})
HUB.UI.SettingsTab:AddButton({
    Name = "Unload LSS HUB",
    Callback = safeCallback(function() pcall(function() HUB.Unload() end) end)
})
end

HUB.Unload = function()
    if HUB.V44 and HUB.V44.ResetDroneEntry then pcall(HUB.V44.ResetDroneEntry) end
    HUB.dead = true
    cancelImportedSteal()
    if ImportedSteal.engine then ImportedSteal.engine:Destroy() end

    for _, c in ipairs(HUB.conns) do pcall(function() c:Disconnect() end) end
    HUB.conns = {}

    for _, d in ipairs(HUB.drawings) do pcall(function() d:Remove() end) end
    HUB.drawings = {}

    for _, h in ipairs(HUB.highlights) do pcall(function() h:Destroy() end) end
    HUB.highlights = {}

    stopFly()
    if HUB.GuardRide then pcall(function() HUB.GuardRide.Stop() end) end
    HUB.Runtime.SetFullbright(false)

    local hum = findHum()
    if hum then
        hum.PlatformStand = false
        hum.WalkSpeed = originalWalkSpeed or 500
        hum.JumpPower = 500
    end

    pcall(function() Window:Destroy() end)
    _G.LSS HUBStealAnEgg = nil
end

LSS HUB_CFG.RestoreAll()
LSS HUB_CFG.Queue()
pcall(function()
    track(LP.OnTeleport:Connect(function()
        if LSS HUB_CFG.autoSave then LSS HUB_CFG.Save(true) end
    end))
end)

do
    local PromptSvc  = game:GetService("ProximityPromptService")
    local LocalPlr   = game:GetService("Players").LocalPlayer

    HUB.AntiHit = HUB.AntiHit or {
        enabled = false, running = false, promptConn = nil,
        patchConns = {}, savedDurations = {},
        positions = {
            CFrame.new(4747.71, 70.57, -335.25),
            CFrame.new(3520.94, 70.73, -343.74),
            CFrame.new(2446.02, 70.88, -351.18),
            CFrame.new(1352.11, 71.02, -358.75),
            CFrame.new(544.49,  71.13, -364.34),
        },
    }
    local ANTI = HUB.AntiHit

    local function PatchPrompt(p)
        if not (p and typeof(p) == "Instance" and p:IsA("ProximityPrompt")) then return end
        if ANTI.enabled then
            if ANTI.savedDurations[p] == nil then ANTI.savedDurations[p] = p.HoldDuration end
            p.HoldDuration = 0
            p.RequiresLineOfSight = false
        elseif ANTI.savedDurations[p] ~= nil then
            pcall(function() p.HoldDuration = ANTI.savedDurations[p] end)
            ANTI.savedDurations[p] = nil
        end
    end

    local function SetPromptPatch(on)
        if on then
            for _, item in ipairs(Workspace:GetDescendants()) do PatchPrompt(item) end
            table.insert(ANTI.patchConns, Workspace.DescendantAdded:Connect(PatchPrompt))
            table.insert(ANTI.patchConns, PromptSvc.PromptShown:Connect(PatchPrompt))
        else
            for _, c in ipairs(ANTI.patchConns) do pcall(function() c:Disconnect() end) end
            ANTI.patchConns = {}
            for p, d in pairs(ANTI.savedDurations) do
                if p and p.Parent then pcall(function() p.HoldDuration = d end) end
            end
            ANTI.savedDurations = {}
        end
    end

    function ANTI.Trigger()
        if ANTI.running or HUB.dead or HUB.paused then return end
        local ch = LocalPlr.Character
        if not ch then return end
        local hum  = ch:FindFirstChildOfClass("Humanoid")
        local root = ch:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end

        ANTI.running = true
        local cam = Workspace.CurrentCamera
        local oldCamCF, oldCamType = cam and cam.CFrame, cam and cam.CameraType
        if cam then
            cam.CameraType = Enum.CameraType.Scriptable
            cam.CFrame = oldCamCF
        end
        hum.BreakJointsOnDeath = false
        for _, d in ipairs(ch:GetDescendants()) do
            if d:IsA("Motor6D") then d.Enabled = true end
        end

        for _, cf in ipairs(ANTI.positions) do
            if HUB.dead or HUB.paused then break end
            hum.PlatformStand = true
            hum.Health = 100
            root.CFrame = cf
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            if cam then cam.CFrame = oldCamCF end
            task.wait(0.02)
        end

        local t0 = os.clock()
        local last = ANTI.positions[#ANTI.positions]
        local hb
        hb = RunService.Heartbeat:Connect(function()
            if HUB.dead or HUB.paused or os.clock() - t0 > 0.35 then
                if hb then hb:Disconnect() end
                return
            end
            hum.Health = 100
            hum.PlatformStand = true
            root.CFrame = last
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            if cam then cam.CFrame = oldCamCF end
        end)
        task.wait(0.35)
        if hb then pcall(function() hb:Disconnect() end) end

        hum.PlatformStand = false
        if cam then cam.CameraType = oldCamType or Enum.CameraType.Custom end
        ANTI.running = false
    end

    function ANTI.SetEnabled(on)
        ANTI.enabled = on == true
        SetPromptPatch(ANTI.enabled)
        if ANTI.enabled then
            if not ANTI.promptConn then
                ANTI.promptConn = track(PromptSvc.PromptTriggered:Connect(function(prompt, plr)
                    if plr ~= LocalPlr then return end
                    local n = tostring(prompt)
                    if n == "CarryAreaEgg" or n:find("Egg") or n:find("Carry") then
                        task.spawn(ANTI.Trigger)
                    end
                end))
            end
        elseif ANTI.promptConn then
            pcall(function() ANTI.promptConn:Disconnect() end)
            ANTI.promptConn = nil
        end
    end

    local function Attach()
        if not (HUB.UI and HUB.UI.StealSub) then return false end
        HUB.UI.StealSub:AddToggle({
            Name = "Anti Hit ", Default = false, Flag = "anti_hit_steal",
            Callback = safeCallback(function(v)
                ANTI.SetEnabled(v)
                Notify("Anti Hit", v and "Enabled - chain teleport when stealing" or "Disabled", v and "Success" or "Error")
            end)
        })
        return true
    end

    if not Attach() then
        task.spawn(function()
            for _ = 1, 100 do
                if Attach() then return end
                task.wait(0.1)
            end
        end)
    end
end

Notify("LSS HUB", "Script loaded successfully!", "Success", 3.5)
if LSS HUB_CREATED_TABS <= 0 then
    LSS HUB_BOOT_PANEL("LSS HUB UI WARNING", "Script finished but no UI tab was created.")
else
    LSS HUB_BOOT_CLEAR()
end

end, function(message)
    if debug and debug.traceback then
        return debug.traceback(tostring(message), 2)
    end
    return tostring(message)
end)

if not __LSS HUB_BOOT_OK then
    LSS HUB_BOOT_PANEL("LSS HUB UI ERROR", tostring(__LSS HUB_BOOT_ERR))
end
