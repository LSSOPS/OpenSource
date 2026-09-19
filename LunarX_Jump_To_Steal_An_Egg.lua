local prev_lib = getgenv().lx_jts_lib
local gen = (getgenv().lx_jts_gen or 0) + 1
getgenv().lx_jts_gen = gen
getgenv().lx_jts_abort = true
if prev_lib then pcall(function() prev_lib:unload() end) end
task.wait(0.6)
getgenv().lx_jts_abort = false

local function check(func, optional)
    local f = _G[func] or getfenv(0)[func] or
    (func == "gethui" and gethui) or
    (func == "setclipboard" and setclipboard) or
    (func == "loadstring" and loadstring) or
    (func == "fireproximityprompt" and fireproximityprompt) or
    (func == "firesignal" and firesignal) or
    (func == "setproximitypromptduration" and setproximitypromptduration)

    if not f or type(f) ~= "function" then
        if optional then
            warn("missing optional function '" .. func .. "' (some features disabled)")
            return true
        end
        warn("your executor does not support '" .. func .. "', bye")
        return false
    end
    return true
end

local funcs = {
    {"getgenv", false}, {"loadstring", false}, {"gethui", false}, {"setclipboard", false},
    {"fireproximityprompt", true}, {"firesignal", true}, {"setproximitypromptduration", true}
}
for _, e in ipairs(funcs) do
    if not check(e[1], e[2]) then return end
end

if not game.HttpGet then
    warn("your executor does not support 'HttpGet', bye")
    return
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/potassiumm/lx/main/ui/fware/library.luau"))()
getgenv().lx_jts_lib = library
getgenv().lx_jts_on = true

library.directory = "LunarX/jump-to-steal"

local players = game:GetService("Players")
local gen = getgenv().lx_jts_gen
local function alive()
    return getgenv().lx_jts_gen == gen
end

local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local rs = game:GetService("ReplicatedStorage")
local ws = workspace
local plr = players.LocalPlayer
local hs = game:GetService("HttpService")
local tps = game:GetService("TeleportService")
local light = game:GetService("Lighting")
local setclipboard = setclipboard or function() end
local gethui = gethui or function() return game:GetService("CoreGui") end
local n = rs:WaitForChild("EggGameRemotes")
local gamestate = rs:WaitForChild("EggGameState")

local rarity_rank = {Common = 1, Rare = 2, Epic = 3, Legendary = 4, Mythic = 5, Secret = 6, Celestial = 7, Divine = 8, Transcendent = 9, Eternal = 10}
local rarity_list = {"Common", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Celestial", "Divine", "Transcendent", "Eternal"}
local rarity_color = {
    Common = Color3.fromRGB(0, 255, 0),
    Rare = Color3.fromRGB(0, 170, 255),
    Epic = Color3.fromRGB(170, 0, 255),
    Legendary = Color3.fromRGB(255, 170, 0),
    Mythic = Color3.fromRGB(222, 19, 19),
    Secret = Color3.fromRGB(200, 60, 60),
    Celestial = Color3.fromRGB(61, 110, 234),
    Divine = Color3.fromRGB(255, 215, 0),
    Transcendent = Color3.fromRGB(255, 0, 100),
    Eternal = Color3.new(1, 1, 1)
}
local biome_opts = {}
local biome_seen = {}
local function rescan_biomes()
    local m = ws:FindFirstChild("Map")
    local nests = m and m:FindFirstChild("BiomeNests")
    if not nests then return biome_opts end
    local raw = {}
    for _, bf in ipairs(nests:GetChildren()) do
        table.insert(raw, bf.Name)
    end
    table.sort(raw)
    local found = {}
    for _, full in ipairs(raw) do
        local nm = string.gsub(full, "^%d+_", "")
        if not biome_seen[nm] then
            biome_seen[nm] = true
            table.insert(found, nm)
        end
    end
    biome_opts = found
    return found
end
rescan_biomes()

local w = library:window({
    title = "lunar x",
    subtitle = " - jump to steal an egg",
    size = UDim2.new(0, 650, 0, 450),
    icon = "moon",
    changelog_url = "https://raw.githubusercontent.com/potassiumm/lx/main/changelogs/jump-to-steal.md",
    discord_link = "discord.gg/n6SzrKpVnU",
    script_url = "https://raw.githubusercontent.com/potassiumm/lx/main/games/jump-to-steal.luau"
})

local t1 = w:tab({ name = "steal", icon = "target", search = true })
local t2 = w:tab({ name = "eggs", icon = "egg", search = true })
local t3 = w:tab({ name = "animals", icon = "dog", search = true })
local t4 = w:tab({ name = "farm", icon = "swords", search = true })
local t5 = w:tab({ name = "player", icon = "user", search = true })
local t6 = w:tab({ name = "visuals", icon = "eye", search = true })
local t7 = w:tab({ name = "misc", icon = "settings", search = true })

local function rcall(name, ...)
    local args = {...}
    local ok, r = pcall(function()
        return n[name]:InvokeServer(unpack(args))
    end)
    return ok and r or nil
end

local function fire(name, ...)
    local args = {...}
    pcall(function()
        n[name]:FireServer(unpack(args))
    end)
end

local notif_q = {}
local function notify(text, dur)
    if #notif_q > 8 then table.remove(notif_q, 1) end
    table.insert(notif_q, {tostring(text), tonumber(dur) or 4})
end

task.spawn(function()
    while alive() do
        local nn = table.remove(notif_q, 1)
        if nn then
            pcall(function()
                w:notification({ text = nn[1], duration = nn[2] })
            end)
            task.wait(0.35)
        else
            task.wait(0.2)
        end
    end
end)

local floor_deficit = {}
local steal_unlock_floors = true

n.PlayerNotification.OnClientEvent:Connect(function(a)
    if type(a) ~= "table" or type(a.Text) ~= "string" then return end
    local amt = string.match(a.Text, "+(%d+) Jump")
    if amt then
        floor_deficit.current = tonumber(amt)
        floor_deficit.t = os.clock()
    end
end)

local profile = nil

task.spawn(function()
    while alive() do
        local r = rcall("RequestPlayerData")
        if type(r) == "table" and type(r.Data) == "table" then profile = r.Data end
        task.wait(5)
    end
end)

local function my_plot()
    for _, p in ipairs(ws.Plots:GetChildren()) do
        local a = p:FindFirstChild("EggGameAssets")
        if a and a:GetAttribute("OwnerUserId") == plr.UserId then return p end
    end
end

local function plot_center_cf()
    local plot = my_plot()
    if not plot then return nil end
    local cp = plot:FindFirstChild("CenterPoint") or (plot:FindFirstChild("ToUpdate") and plot.ToUpdate:FindFirstChild("CenterPoint"))
    local sp = plot:FindFirstChild("SpawnPoint")
    local part = cp or sp
    if part then
        local cf = part.CFrame + Vector3.new(0, 4, 0)
        return cf
    end
    return nil
end

local function is_night()
    return gamestate:GetAttribute("IsNight") == true
end

local function night_left()
    local v = gamestate:GetAttribute("SecondsUntilNight")
    return type(v) == "number" and v or -1
end

local function carrying_egg()
    return plr:GetAttribute("CarryingEgg") == true
end

local tp_mode = true
local glide_speed = 150
local steal_status = ""
getgenv().lx_jts_status = ""

local function set_status(s)
    steal_status = s
    getgenv().lx_jts_status = s
end

local function move_to(cf, hold)
    local char = plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    if typeof(cf) ~= "CFrame" then return false end
    if tp_mode then
        hrp.Anchored = true
        hrp.CFrame = cf
        task.wait(hold or 0.15)
        hrp.Anchored = false
        return true
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return false end
    hrp.Anchored = true
    local start = hrp.CFrame
    local dist = (cf.Position - start.Position).Magnitude
    local dur = math.max(dist / math.max(glide_speed, 5), 0.05)
    local t0 = os.clock()
    while os.clock() - t0 < dur + 2 do
        if getgenv().lx_jts_abort or not alive() then break end
        if hrp.Parent == nil then break end
        local a = math.clamp((os.clock() - t0) / dur, 0, 1)
        hrp.CFrame = start:Lerp(cf, a)
        if a >= 1 then break end
        run.RenderStepped:Wait()
    end
    hrp.Anchored = false
    task.wait(hold or 0.15)
    return true
end

local egg_cache = {}
local egg_cache_t = 0

local function field_eggs()
    if os.clock() - egg_cache_t < 0.4 then return egg_cache end
    egg_cache_t = os.clock()
    local out = {}
    local nests = ws.Map:FindFirstChild("BiomeNests")
    if not nests then egg_cache = out return out end
    for _, bf in ipairs(nests:GetChildren()) do
        local biome = string.gsub(bf.Name, "^%d+_", "")
        for _, nest in ipairs(bf:GetChildren()) do
            local egg = nest:FindFirstChild("Egg")
            if egg and egg:IsA("Model") and egg.Parent then
                local root = egg:FindFirstChild("EggRoot")
                if root and root:IsA("BasePart") then
                    out[#out + 1] = {
                        egg = egg,
                        root = root,
                        biome = biome,
                        floor = tonumber(nest:GetAttribute("FloorIndex")) or 1,
                        rarity = tostring(egg:GetAttribute("Rarity") or "Common"),
                        species = tostring(egg:GetAttribute("Species") or "Egg"),
                        uid = tostring(egg:GetAttribute("EggUid") or egg.Name)
                    }
                end
            end
        end
    end
    egg_cache = out
    return out
end

local steal_biomes = {}
local steal_minrarity = 0
local steal_avoid_night = true
local steal_top_zone = false

local function fire_prompt(prompt)
    if not prompt then return false end
    local okf = pcall(function()
        fireproximityprompt(prompt, prompt.HoldDuration > 0)
    end)
    if okf then return true end
    return pcall(function()
        firesignal(prompt.Triggered, plr)
    end)
end

local function steal_pick()
    local best, bestd = nil, math.huge
    local bestscore = -1
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    local eggs = field_eggs()
    local topfloor = 0
    if steal_top_zone then
        local seen = {}
        for _, rec in ipairs(eggs) do
            if next(steal_biomes) == nil or steal_biomes[rec.biome] then
                local f = rec.floor
                if not seen[f] then seen[f] = floor_deficit[f] or 0 end
            end
        end
        local leastf, leastdf = 0, math.huge
        for f, df in pairs(seen) do
            if df == 0 and f > topfloor then topfloor = f end
            if df < leastdf then leastdf = df leastf = f end
        end
        if topfloor == 0 and leastf > 0 then topfloor = leastf end
    end
    for _, rec in ipairs(eggs) do
        if next(steal_biomes) ~= nil and not steal_biomes[rec.biome] then continue end
        if steal_top_zone and rec.floor > topfloor then continue end
        local rank = rarity_rank[rec.rarity] or (#rarity_list + 1)
        if rank < steal_minrarity then continue end
        local def = steal_top_zone and 0 or (floor_deficit[rec.floor] or 0)
        local score = (rank - def * 0.001) * 1000000 + math.min(rec.root.Position.Y, 100000)
        local d = (hrp and (hrp.Position - rec.root.Position).Magnitude) or 0
        if score > bestscore or (score == bestscore and d < bestd) then
            bestscore = score
            bestd = d
            best = rec
        end
    end
    return best
end

local function deliver_carry(timeout)
    local t0 = os.clock()
    while carrying_egg() and os.clock() - t0 < (timeout or 30) do
        if getgenv().lx_jts_abort then return false end
        local cf = plot_center_cf()
        if cf then
            move_to(cf, 0.3)
        end
        task.wait(0.8)
        if not carrying_egg() then return true end
    end
    return not carrying_egg()
end

local function steal_one(rec)
    if not rec or not rec.root or not rec.root.Parent then return false end
    if getgenv().lx_jts_abort then return false end
    if steal_avoid_night and is_night() then
        set_status("night - waiting")
        return false
    end
    set_status("egg " .. rec.species .. " [" .. rec.rarity .. "]")
    move_to(rec.root.CFrame + Vector3.new(0, 1.5, 0), 0.2)
    if getgenv().lx_jts_abort then return false end
    task.wait(0.25)
    local prompt = rec.root:FindFirstChild("CarryPrompt")
    if not prompt then
        prompt = rec.root:FindFirstChildOfClass("ProximityPrompt")
    end
    if not prompt then
        set_status("egg has no prompt")
        return false
    end
    set_status("grabbing egg")
    fire_prompt(prompt)
    local t0 = os.clock()
    while not carrying_egg() and os.clock() - t0 < 2.5 do
        task.wait(0.1)
        if getgenv().lx_jts_abort then return false end
    end
    if not carrying_egg() then
        fire_prompt(prompt)
        t0 = os.clock()
        while not carrying_egg() and os.clock() - t0 < 2.5 do
            task.wait(0.1)
            if getgenv().lx_jts_abort then return false end
        end
    end
    if not carrying_egg() then
        local def = floor_deficit.current
        if steal_unlock_floors and type(def) == "number" and def > 0 and os.clock() - (floor_deficit.t or 0) < 6 then
            floor_deficit[rec.floor] = def
            set_status("floor " .. rec.floor .. " locked - buying +" .. def .. " jump")
            local pd0 = rcall("RequestPlayerData")
            local cash0 = (type(pd0) == "table" and type(pd0.Data) == "table" and tonumber(pd0.Data.Cash)) or 0
            local bought = 0
            while bought < def and steal_unlock_floors and alive() do
                local step = math.min(10, def - bought)
                local r = rcall("RequestJumpUpgrade", step)
                local okb = type(r) == "table" and r.Success == true
                if not okb and step > 5 then step = 5 r = rcall("RequestJumpUpgrade", step) okb = type(r) == "table" and r.Success == true end
                if not okb and step > 1 then step = 1 r = rcall("RequestJumpUpgrade", step) okb = type(r) == "table" and r.Success == true end
                if not okb then break end
                bought = bought + step
                task.wait(0.4)
                local pd1 = rcall("RequestPlayerData")
                local cash1 = (type(pd1) == "table" and type(pd1.Data) == "table" and tonumber(pd1.Data.Cash)) or 0
                if cash1 < cash0 * 0.25 then
                    notify("stopped buying: cash guard", 4)
                    break
                end
            end
            if bought > 0 then
                notify("bought +" .. bought .. " jump for floor " .. rec.floor, 3)
                task.wait(1)
                fire_prompt(prompt)
                local t1 = os.clock()
                while not carrying_egg() and os.clock() - t1 < 2.5 do
                    task.wait(0.1)
                    if getgenv().lx_jts_abort then return false end
                end
            end
        end
        if not carrying_egg() then
            set_status("grab failed")
            return false
        end
    end
    set_status("securing at plot")
    local okd = deliver_carry(45)
    if okd then
        notify("stole " .. rec.species .. " [" .. rec.rarity .. "]!", 3)
        set_status("secured")
        task.wait(0.5)
    else
        set_status("deliver failed")
    end
    return okd
end

local auto_steal = false
local steal_run = 0

local function steal_loop(runid)
    while auto_steal and alive() and steal_run == runid and not getgenv().lx_jts_abort do
        local okl, lerr = pcall(function()
            if getgenv().lx_jts_abort or steal_run ~= runid then return end
            if carrying_egg() then
                set_status("carrying - securing")
                deliver_carry(45)
                return
            end
            if steal_avoid_night and is_night() then
                set_status("night - waiting (" .. math.max(night_left(), 0) .. "s)")
                task.wait(2)
                return
            end
            local rec = steal_pick()
            if not rec then
                set_status("no egg found")
                task.wait(1)
                return
            end
            local okg = steal_one(rec)
            if not okg and not getgenv().lx_jts_abort then task.wait(0.6) end
        end)
        if not okl then
            set_status("steal err")
            notify("steal error: " .. tostring(lerr), 3)
            task.wait(1)
        end
        if getgenv().lx_jts_abort or steal_run ~= runid then break end
    end
end

do

local s1 = t1:section({ name = "steal" })

library.toggle(s1, { name = "auto steal", default = false, callback = function(v)
    auto_steal = v
    if not v then
        if (steal_run or 0) > 0 then
            getgenv().lx_jts_abort = true
        end
        return
    end
    local runid = steal_run + 1
    steal_run = runid
    getgenv().lx_jts_abort = false
    task.spawn(function()
        steal_loop(runid)
        if steal_run == runid then
            set_status("")
            notify("auto steal stopped")
        end
    end)
end })

local biome_dd = library.dropdown(s1, { name = "biomes", options = biome_opts, multiple = true, default = {}, callback = function(v)
    steal_biomes = {}
    for _, b in ipairs(v) do steal_biomes[b] = true end
end })

local rar_dd = library.dropdown(s1, { name = "min rarity", options = {"any", unpack(rarity_list)}, default = "any", callback = function(v)
    steal_minrarity = v == "any" and 0 or (rarity_rank[v] or 0)
end })

local biome_sig = table.concat(biome_opts, ",")
task.spawn(function()
    while alive() do
        local opts = rescan_biomes()
        local sig = table.concat(opts, ",")
        if #opts > 0 and sig ~= biome_sig then
            biome_sig = sig
            pcall(function() biome_dd:refresh(opts) end)
        end
        local changed = false
        for _, rec in ipairs(field_eggs()) do
            local r = rec.rarity
            if r and rarity_rank[r] == nil then
                rarity_rank[r] = #rarity_list + 1
                table.insert(rarity_list, r)
                rarity_color[r] = Color3.fromHSV((#rarity_list % 10) / 10, 0.65, 1)
                changed = true
            end
        end
        if changed then
            pcall(function() rar_dd:refresh({"any", unpack(rarity_list)}) end)
        end
        task.wait(10)
    end
end)

library.toggle(s1, { name = "target best zone and under", default = false, callback = function(v) steal_top_zone = v end })

library.toggle(s1, { name = "pause at night", default = true, callback = function(v) steal_avoid_night = v end })

local inst_on = false

library.toggle(s1, { name = "instant steal", default = false, callback = function(v)
    inst_on = v
    if v then
        task.spawn(function()
            while inst_on and alive() do
                for _, pr in ipairs(ws:GetDescendants()) do
                    if pr:IsA("ProximityPrompt") and pr.HoldDuration > 0 then
                        pcall(function() pr.HoldDuration = 0 end)
                        pcall(setproximitypromptduration, pr, 0)
                    end
                end
                task.wait(5)
            end
        end)
    end
end })

library.toggle(s1, { name = "tp mode", default = true, callback = function(v) tp_mode = v end })
library.slider(s1, { name = "glide speed", min = 20, max = 400, default = 150, callback = function(v) glide_speed = v end })

local auto_drop = false

library.toggle(s1, { name = "auto buy jump for locked floors", default = false, callback = function(v) steal_unlock_floors = v end })

library.toggle(s1, { name = "auto drop held egg", default = false, callback = function(v)
    auto_drop = v
    if auto_drop then
        task.spawn(function()
            while auto_drop and alive() do
                if carrying_egg() then
                    local cf = plot_center_cf()
                    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if not cf or not hrp or (hrp.Position - cf.Position).Magnitude > 500 then
                        fire("RequestDropCarriedEgg")
                    end
                end
                task.wait(3)
            end
        end)
    end
end })

library.button(s1, { name = "steal best egg now", callback = function()
    task.spawn(function()
        local rec = steal_pick()
        if rec then steal_one(rec) end
    end)
end })

library.button(s1, { name = "secure held egg", callback = function()
    task.spawn(function()
        deliver_carry(45)
    end)
end })

library.button(s1, { name = "drop egg", callback = function()
    fire("RequestDropCarriedEgg")
end })

end

do

local s2 = t2:section({ name = "eggs" })

local plant_on = false
local plant_i = 0

local function inv_eggs()
    local out = {}
    if type(profile) == "table" and type(profile.Inventory) == "table" and type(profile.Inventory.Eggs) == "table" then
        for _, e in pairs(profile.Inventory.Eggs) do
            if type(e) == "table" and type(e.Uid) == "string" and e.PlacementId == nil then out[e.Uid] = e end
        end
    end
    return out
end

local function placed_eggs()
    local out = {}
    local plot = my_plot()
    local assets = plot and plot:FindFirstChild("EggGameAssets")
    if assets then
        for _, m in ipairs(assets:GetChildren()) do
            if m:IsA("Model") and string.sub(m.Name, 1, 4) == "Egg_" then
                out[tostring(m:GetAttribute("ItemUid") or string.sub(m.Name, 5))] = m
            end
        end
    end
    return out
end

local function try_place(uid, gx, gz)
    local plot = my_plot()
    if not plot then return nil end
    local upd = plot:FindFirstChild("ToUpdate")
    local pa = upd and upd:FindFirstChild("PetArea")
    local cp = upd and upd:FindFirstChild("CenterPoint") or plot:FindFirstChild("CenterPoint")
    if not (pa and cp) then return nil end
    local worldCF = pa.CFrame * CFrame.new(gx, 0.2, gz)
    local localCF = cp.CFrame:ToObjectSpace(worldCF)
    local here = pa:IsA("BasePart") and pa or cp
    local hit = workspace:Raycast(here.Position + Vector3.new(gx, 8, gz), Vector3.new(0, -20, 0))
    if hit and hit.Instance then
        local mdl = hit.Instance:IsA("Model") and hit.Instance or hit.Instance:FindFirstAncestorWhichIsA("Model")
        if mdl and (mdl.Name == "Egg" or string.sub(mdl.Name, 1, 4) == "Egg_") then return {Success = false, Code = "SPOT_TAKEN"} end
    end
    return rcall("RequestPlaceEgg", {Uid = uid, LocalCFrame = localCF})
end

library.toggle(s2, { name = "auto place eggs", default = false, callback = function(v)
    plant_on = v
    if plant_on then
        task.spawn(function()
            while plant_on and alive() do
                if getgenv().lx_jts_abort then task.wait(1) continue end
                local cf = plot_center_cf()
                if not cf then
                    task.wait(2)
                    continue
                end
                local placed = placed_eggs()
                local uid = nil
                for u in pairs(inv_eggs()) do
                    if not placed[u] then
                        uid = u
                        break
                    end
                end
                if not uid then
                    task.wait(2)
                    continue
                end
                local col = plant_i % 8
                local row = math.floor(plant_i / 8) % 5
                local gx = (col - 3.5) * 8
                local gz = (row - 2) * 8
                plant_i = plant_i + 1
                local r = try_place(uid, gx, gz)
                if type(r) == "table" and r.Success == true then
                    notify("placed egg " .. string.sub(uid, 1, 8), 2)
                    task.wait(0.8)
                elseif type(r) == "table" and r.Code == "SPOT_TAKEN" then
                    plant_i = plant_i + 1
                    task.wait(0.2)
                else
                    local msg = type(r) == "table" and (r.Message or r.Code) or tostring(r)
                    notify("place failed: " .. tostring(msg), 4)
                    plant_i = plant_i + 3
                    task.wait(1)
                end
            end
        end)
    end
end })

local hatch_on = false

local function hatch_uid(uid)
    local r = rcall("RequestHatchEgg", {Uid = uid})
    if type(r) ~= "table" or r.Success ~= true or type(r.HatchToken) ~= "string" then
        return false, type(r) == "table" and (r.Code or r.Message) or tostring(r)
    end
    task.wait(1)
    for i = 1, 3 do
        local r2 = rcall("RequestCompleteHatchEgg", {Token = r.HatchToken})
        if type(r2) == "table" and r2.Success == true then
            notify("hatched " .. tostring(r.Species) .. " [" .. tostring(r.Rarity) .. "]", 3)
            return true
        end
        task.wait(0.6)
    end
    return false, "complete failed"
end

library.toggle(s2, { name = "auto hatch ready eggs", default = false, callback = function(v)
    hatch_on = v
    if hatch_on then
        task.spawn(function()
            while hatch_on and alive() do
                if getgenv().lx_jts_abort then task.wait(1) continue end
                local did = false
                for uid, m in pairs(placed_eggs()) do
                    if not hatch_on then break end
                    if m:GetAttribute("Ready") == true and m:GetAttribute("IsHatching") ~= true then
                        did = true
                        local okh, err = hatch_uid(uid)
                        if not okh then notify("hatch: " .. tostring(err), 3) end
                        task.wait(1.2)
                    end
                end
                task.wait(did and 0.5 or 2)
            end
        end)
    end
end })

library.button(s2, { name = "hatch all ready now", callback = function()
    task.spawn(function()
        local n2 = 0
        for uid, m in pairs(placed_eggs()) do
            if m:GetAttribute("Ready") == true then
                hatch_uid(uid)
                n2 = n2 + 1
            end
        end
        notify("hatch pass: " .. n2 .. " attempted", 3)
    end)
end })

local auto_buy_jump = false
local jump_amount = 1

library.dropdown(s2, { name = "jump upgrade amount", options = {"1", "5", "10"}, default = "1", callback = function(v) jump_amount = tonumber(v) or 1 end })

library.toggle(s2, { name = "auto buy jump upgrade", default = false, callback = function(v)
    auto_buy_jump = v
    if auto_buy_jump then
        task.spawn(function()
            local last_cost = 0
            while auto_buy_jump and alive() do
                local pd = rcall("RequestPlayerData")
                local data = (type(pd) == "table" and type(pd.Data) == "table") and pd.Data or nil
                local cash = (data and tonumber(data.Cash)) or 0
                local jump = (data and tonumber(data.Jump)) or 0
                if cash > 300 and jump < 500 and cash >= last_cost * 1.2 then
                    local r = rcall("RequestJumpUpgrade", jump_amount)
                    if type(r) == "table" and r.Success == true then
                        last_cost = math.max(last_cost * 2, cash * 0.02)
                        notify("bought +" .. jump_amount .. " jump", 3)
                        task.wait(1)
                    else
                        last_cost = math.max(last_cost * 2, cash * 1.5)
                        task.wait(5)
                    end
                else
                    task.wait(5)
                end
            end
        end)
    end
end })

end

do

local s3 = t3:section({ name = "animals" })

library.button(s3, { name = "equip best animals", callback = function()
    local r = rcall("RequestEquipBestAnimals")
    notify(type(r) == "table" and r.Success == true and "equipped best animals" or "equip failed", 4)
end })

local best_on = false

library.toggle(s3, { name = "auto equip best animals", default = false, callback = function(v)
    best_on = v
    if best_on then
        task.spawn(function()
            while best_on and alive() do
                rcall("RequestEquipBestAnimals")
                task.wait(15)
            end
        end)
    end
end })

local sell_on = false
local sell_interval = 60

library.toggle(s3, { name = "auto sell all animals", default = false, callback = function(v)
    sell_on = v
    if sell_on then
        task.spawn(function()
            while sell_on and alive() do
                rcall("RequestSellAllAnimals")
                task.wait(sell_interval)
            end
        end)
    end
end })

library.slider(s3, { name = "sell interval", min = 15, max = 300, default = 60, callback = function(v) sell_interval = v end })

library.button(s3, { name = "sell all animals now", callback = function()
    rcall("RequestSellAllAnimals")
    notify("sell pass done", 3)
end })

local reinvest_on = false

library.toggle(s3, { name = "auto enclosure upgrade", default = false, callback = function(v)
    reinvest_on = v
    if reinvest_on then
        task.spawn(function()
            while reinvest_on and alive() do
                rcall("RequestEnclosureUpgrade")
                task.wait(10)
            end
        end)
    end
end })

end

do

local s4 = t4:section({ name = "farm" })

local function every(interval, fn)
    task.spawn(function()
        while true do
            if not fn() then break end
            task.wait(interval)
        end
    end)
end

library.toggle(s4, { name = "auto claim offline income", default = false, callback = function(v)
    local on = v
    if on then every(10, function() if not on or not alive() then return false end rcall("RequestClaimOfflineIncome") return true end) end
end })

library.toggle(s4, { name = "auto claim index rewards", default = false, callback = function(v)
    local on = v
    if on then every(30, function() if not on or not alive() then return false end rcall("RequestClaimIndexRewards") return true end) end
end })

library.toggle(s4, { name = "auto claim group reward", default = false, callback = function(v)
    local on = v
    if on then every(60, function() if not on or not alive() then return false end rcall("RequestClaimGroupReward") return true end) end
end })

local trail_on = false

library.toggle(s4, { name = "auto equip best trail", default = false, callback = function(v)
    trail_on = v
    if trail_on then
        task.spawn(function()
            while trail_on and alive() do
                local owned = (type(profile) == "table" and type(profile.Trails) == "table" and profile.Trails.Owned) or {}
                if type(owned) == "table" then
                    for nm in pairs(owned) do
                        rcall("RequestEquipTrail", nm)
                        break
                    end
                end
                task.wait(20)
            end
        end)
    end
end })

library.button(s4, { name = "rebirth now", callback = function()
    local r = rcall("RequestRebirth")
    notify(type(r) == "table" and r.Success == true and "rebirth done" or "rebirth failed: " .. tostring(r), 4)
end })

local rebirth_on = false

library.toggle(s4, { name = "auto rebirth", default = false, callback = function(v)
    rebirth_on = v
    if rebirth_on then
        task.spawn(function()
            while rebirth_on and alive() do
                local r = rcall("RequestRebirth")
                if type(r) == "table" and r.Success == true then
                    notify("rebirth done", 3)
                    task.wait(5)
                end
                task.wait(20)
            end
        end)
    end
end })

local code_in = ""

library.textbox(s4, { placeholder = "redeem code", callback = function(v) code_in = v end })
library.button(s4, { name = "redeem code", callback = function()
    if code_in == "" then return end
    local r = rcall("RequestRedeemCode", code_in)
    notify("code: " .. tostring(type(r) == "table" and (r.Message or r.Code) or r), 4)
end })

local s4b = t4:section({ name = "bat" })

library.toggle(s4b, { name = "auto equip bat", default = false, callback = function(v)
    local on = v
    if on then
        task.spawn(function()
            while on and alive() do
                local ch = plr.Character
                local held = ch and ch:FindFirstChildOfClass("Tool")
                local isbat = held and held:GetAttribute("IsBat") == true
                if not isbat then
                    local bp = plr:FindFirstChild("Backpack")
                    local ids = {}
                    if bp then
                        for _, t in ipairs(bp:GetChildren()) do
                            if t:IsA("Tool") and t:GetAttribute("IsBat") == true and t:GetAttribute("BatId") then
                                ids[#ids + 1] = t:GetAttribute("BatId")
                            end
                        end
                    end
                    ids[#ids + 1] = "DefaultBat"
                    for _, bid in ipairs(ids) do
                        local r = rcall("RequestEquipBat", bid)
                        if type(r) == "table" and r.Success == true then break end
                    end
                end
                task.wait(5)
            end
        end)
    end
end })

local bat_swing_on = false

library.toggle(s4b, { name = "auto swing bat", default = false, callback = function(v)
    bat_swing_on = v
    if bat_swing_on then
        task.spawn(function()
            while bat_swing_on and alive() do
                local ch = plr.Character
                local held = ch and ch:FindFirstChildOfClass("Tool")
                if held and held:GetAttribute("IsBat") == true and ch:GetAttribute("IsPlayerRagdoll") ~= true then
                    fire("RequestBatSwing")
                end
                task.wait(0.85)
            end
        end)
    end
end })

end

do

local s5 = t5:section({ name = "teleports" })

library.button(s5, { name = "tp base", callback = function()
    fire("RequestMenuTeleport", "Base")
end })

library.button(s5, { name = "tp shops", callback = function()
    fire("RequestMenuTeleport", "Shops")
end })

library.button(s5, { name = "go to my plot", callback = function()
    task.spawn(function()
        local cf = plot_center_cf()
        if cf then move_to(cf, 0.2) end
    end)
end })

library.button(s5, { name = "go to nearest egg", callback = function()
    task.spawn(function()
        local rec = steal_pick()
        if rec then move_to(rec.root.CFrame + Vector3.new(0, 2, 0), 0.2) end
    end)
end })

local plyr_sel = "All"
local function get_plr_list()
    local l = {"All"}
    for _, v in pairs(players:GetPlayers()) do
        if v ~= plr then table.insert(l, v.Name) end
    end
    return l
end

local s6 = t5:section({ name = "players" })

local dd1 = library.dropdown(s6, { name = "player", options = get_plr_list(), default = "All", callback = function(v) plyr_sel = v end })
players.PlayerAdded:Connect(function() pcall(function() dd1:refresh(get_plr_list()) end) end)
players.PlayerRemoving:Connect(function() pcall(function() dd1:refresh(get_plr_list()) end) end)

local function get_targets()
    if plyr_sel == "All" or not plyr_sel then
        local t = {}
        for _, v in pairs(players:GetPlayers()) do
            if v ~= plr then table.insert(t, v) end
        end
        return t
    else
        local t = players:FindFirstChild(plyr_sel)
        return t and {t} or {}
    end
end

library.button(s6, { name = "go to player", callback = function()
    task.spawn(function()
        for _, t in pairs(get_targets()) do
            local c = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
            if c then move_to(c.CFrame + Vector3.new(0, 0, 3), 0.2) end
        end
    end)
end })

end

do

local s7 = t5:section({ name = "movement" })

local jumppower_on = false
local jumppower_val = 120
local walkspeed_on = false
local walkspeed_val = 24

run.Heartbeat:Connect(function()
    if walkspeed_on then
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= walkspeed_val then hum.WalkSpeed = walkspeed_val end
    end
end)

library.toggle(s7, { name = "walk speed override", default = false, callback = function(v)
    walkspeed_on = v
    local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v and walkspeed_val or 24 end
end })

library.slider(s7, { name = "walk speed", min = 16, max = 500, default = 24, callback = function(v)
    walkspeed_val = v
    if walkspeed_on then
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end })

library.toggle(s7, { name = "jump power override", default = false, callback = function(v)
    jumppower_on = v
    if v then
        task.spawn(function()
            while jumppower_on and alive() do
                local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.UseJumpPower = true
                    hum.JumpPower = jumppower_val
                end
                task.wait(0.1)
            end
        end)
    else
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = 50 end
    end
end })

library.slider(s7, { name = "jump power", min = 50, max = 550, default = 120, callback = function(v) jumppower_val = v end })

library.toggle(s7, { name = "noclip", default = false, callback = function(v)
    getgenv().lx_jts_noclip = v
    task.spawn(function()
        while getgenv().lx_jts_noclip and alive() do
            local char = plr.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
            run.Stepped:Wait()
        end
    end)
end })

local inf_jump_on = false

library.toggle(s7, { name = "infinite jump", default = false, callback = function(v) inf_jump_on = v end })
uis.JumpRequest:Connect(function()
    if inf_jump_on then
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local fly_on = false
local fly_speed = 80
local fly_bv, fly_bg

library.toggle(s7, { name = "fly", default = false, callback = function(v)
    fly_on = v
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")
    if v then
        hum.PlatformStand = true
        fly_bv = Instance.new("BodyVelocity")
        fly_bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        fly_bv.Velocity = Vector3.new(0, 0, 0)
        fly_bv.Parent = hrp
        fly_bg = Instance.new("BodyGyro")
        fly_bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        fly_bg.P = 10000
        fly_bg.CFrame = hrp.CFrame
        fly_bg.Parent = hrp
        task.spawn(function()
            while fly_on and alive() do
                if not char or not char.Parent or not hum or hum.Health <= 0 then break end
                local cam2 = ws.CurrentCamera
                if not cam2 then break end
                local mv = Vector3.zero
                if uis:IsKeyDown(Enum.KeyCode.W) then mv = mv + cam2.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then mv = mv - cam2.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then mv = mv - cam2.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then mv = mv + cam2.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.Space) then mv = mv + Vector3.new(0, 1, 0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftShift) then mv = mv - Vector3.new(0, 1, 0) end
                fly_bv.Velocity = mv * fly_speed
                fly_bg.CFrame = cam2.CFrame
                run.RenderStepped:Wait()
            end
        end)
    else
        hum.PlatformStand = false
        if fly_bv then fly_bv:Destroy() end
        if fly_bg then fly_bg:Destroy() end
    end
end })

library.slider(s7, { name = "fly speed", min = 10, max = 300, default = 80, callback = function(v) fly_speed = v end })

end

do

local s8 = t5:section({ name = "godmode" })

local god_health = false
local anti_ragdoll = false
local anti_kb = false

run.Heartbeat:Connect(function()
    local char = plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hum then
        if god_health and hum.Health < 9e9 then
            hum.Health = 9e9
            hum.MaxHealth = 9e9
        end
        if anti_ragdoll then
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or hum.PlatformStand then
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            for _, sname in ipairs({"GettingUp", "FallingDown", "Ragdoll"}) do
                hum:SetStateEnabled(Enum.HumanoidStateType[sname], false)
            end
            hum.EvaluateStateMachine = true
            hum.AutoRotate = true
            if char:GetAttribute("IsPlayerRagdoll") then char:SetAttribute("IsPlayerRagdoll", nil) end
        end
    end
    if anti_kb and hrp then
        local v = hrp.AssemblyLinearVelocity
        local flat = Vector3.new(v.X, 0, v.Z)
        if flat.Magnitude > 60 then
            hrp.AssemblyLinearVelocity = flat.Unit * 60 + Vector3.new(0, math.max(v.Y, 0), 0)
        end
    end
end)

library.toggle(s8, { name = "anti ragdoll", default = false, callback = function(v) anti_ragdoll = v end })
library.toggle(s8, { name = "anti knockback", default = false, callback = function(v) anti_kb = v end })
library.toggle(s8, { name = "infinite health loop", default = false, callback = function(v) god_health = v end })

library.button(s8, { name = "reset character", callback = function()
    local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end })

end

local s9 = t6:section({ name = "esp" })

do

local egg_esp = false
local egg_tracers = false
local egg_draws = {}

run.RenderStepped:Connect(function()
    local c = ws.CurrentCamera
    if not (egg_esp or egg_tracers) or not c or not c.Parent then
        for _, t in pairs(egg_draws) do t.Visible = false end
        return
    end
    local drawn = {}
    for _, rec in ipairs(field_eggs()) do
        if rec.root.Parent then
            local pos = rec.root.Position
            local vp = c:WorldToViewportPoint(pos)
            local onscreen = typeof(vp) == "Vector3" and vp.Z > 0
            if onscreen then
                local d = egg_draws[rec.uid]
                if not d then
                    d = Drawing.new("Text")
                    d.Size = 13
                    d.Center = true
                    d.Outline = true
                    d.Font = 2
                    egg_draws[rec.uid] = d
                end
                d.Text = rec.species .. " [" .. rec.rarity .. "] " .. math.floor((c.CFrame.Position - pos).Magnitude) .. "m"
                d.Color = rarity_color[rec.rarity] or Color3.new(1, 1, 1)
                d.Position = Vector2.new(vp.X, vp.Y)
                d.Visible = egg_esp
                drawn[rec.uid] = true
                if egg_tracers then
                    local tk = "t_" .. rec.uid
                    local tr = egg_draws[tk]
                    if not tr then
                        tr = Drawing.new("Line")
                        tr.Thickness = 1
                        egg_draws[tk] = tr
                    end
                    tr.From = Vector2.new(c.ViewportSize.X / 2, c.ViewportSize.Y)
                    tr.To = Vector2.new(vp.X, vp.Y)
                    tr.Color = d.Color
                    tr.Visible = true
                    drawn[tk] = true
                end
            end
        end
    end
    for key, d in pairs(egg_draws) do
        if not drawn[key] then d.Visible = false end
    end
end)

library.toggle(s9, { name = "egg esp", default = false, callback = function(v) egg_esp = v end })
library.toggle(s9, { name = "egg tracers", default = false, callback = function(v) egg_tracers = v end })

end

do

local guard_esp = false
local guard_draws = {}

run.RenderStepped:Connect(function()
    local c = ws.CurrentCamera
    if not guard_esp or not c or not c.Parent then
        for _, t in pairs(guard_draws) do t.Visible = false end
        return
    end
    local drawn = {}
    local vis_folder = ws:FindFirstChild("EggGameClientVisuals")
    local g = vis_folder and vis_folder:FindFirstChild("Guardians")
    if g then
        for _, m in ipairs(g:GetChildren()) do
            if m:IsA("Model") and m.Parent then
                local p = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
                if p then
                    local vp = c:WorldToViewportPoint(p.Position)
                    if typeof(vp) == "Vector3" and vp.Z > 0 then
                        local key = m.Name .. tostring(m)
                        drawn[key] = true
                        local d = guard_draws[key]
                        if not d then
                            d = Drawing.new("Text")
                            d.Size = 14
                            d.Center = true
                            d.Outline = true
                            d.Font = 2
                            d.Color = Color3.new(1, 0.2, 0.2)
                            guard_draws[key] = d
                        end
                        d.Text = "guard [" .. math.floor((c.CFrame.Position - p.Position).Magnitude) .. "]"
                        d.Position = Vector2.new(vp.X, vp.Y)
                        d.Visible = true
                    end
                end
            end
        end
    end
    for key, d in pairs(guard_draws) do
        if not drawn[key] then d.Visible = false end
    end
end)

library.toggle(s9, { name = "guardian esp", default = false, callback = function(v) guard_esp = v end })

end

do

local plr_esp = false
local plr_tracers = false
local plr_draws = {}
local plr_lines = {}
local tr_from = "bottom center"
local tr_to = "humanoid root part"

local function anchor_of(p)
    local ch = p.Character
    if not ch then return nil end
    if tr_to == "head" then
        local h = ch:FindFirstChild("Head")
        if h then return h end
    elseif tr_to == "left hand" then
        local h = ch:FindFirstChild("LeftHand") or ch:FindFirstChild("Left Arm")
        if h then return h end
    elseif tr_to == "right hand" then
        local h = ch:FindFirstChild("RightHand") or ch:FindFirstChild("Right Arm")
        if h then return h end
    elseif tr_to == "torso" then
        local h = ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
        if h then return h end
    end
    return ch:FindFirstChild("HumanoidRootPart")
end

local function screen_anchor(c)
    local vpc = c.ViewportSize
    if tr_from == "top center" then return Vector2.new(vpc.X / 2, 0) end
    if tr_from == "bottom left" then return Vector2.new(0, vpc.Y) end
    if tr_from == "bottom right" then return Vector2.new(vpc.X, vpc.Y) end
    if tr_from == "top left" then return Vector2.new(0, 0) end
    if tr_from == "top right" then return Vector2.new(vpc.X, 0) end
    return Vector2.new(vpc.X / 2, vpc.Y)
end

run.RenderStepped:Connect(function()
    local c = ws.CurrentCamera
    if not plr_esp then
        for _, t in pairs(plr_draws) do t.Visible = false end
    end
    if not plr_tracers or not c or not c.Parent then
        for _, t in pairs(plr_lines) do t.Visible = false end
        return
    end
    local drawn = {}
    local spt = screen_anchor(c)
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= plr then
            local a = anchor_of(p)
            if a then
                local vp = c:WorldToViewportPoint(a.Position)
                local key = p.UserId
                drawn[key] = true
                if typeof(vp) == "Vector3" and vp.Z > 0 then
                    local l = plr_lines[key]
                    if not l then
                        l = Drawing.new("Line")
                        l.Thickness = 1.5
                        l.Color = Color3.new(0.4, 0.7, 1)
                        plr_lines[key] = l
                    end
                    l.From = spt
                    l.To = Vector2.new(vp.X, vp.Y)
                    l.Visible = true
                else
                    if plr_lines[key] then plr_lines[key].Visible = false end
                end
                if plr_esp and typeof(vp) == "Vector3" and vp.Z > 0 then
                    local d = plr_draws[key]
                    if not d then
                        d = Drawing.new("Text")
                        d.Size = 13
                        d.Center = true
                        d.Outline = true
                        d.Font = 2
                        plr_draws[key] = d
                    end
                    local carry = p:GetAttribute("CarryingEgg") == true
                    d.Text = p.Name .. " [" .. math.floor((c.CFrame.Position - a.Position).Magnitude) .. "]" .. (carry and " CARRYING" or "")
                    d.Color = carry and Color3.new(1, 0.3, 0.3) or Color3.new(0.4, 0.7, 1)
                    d.Position = Vector2.new(vp.X, vp.Y)
                    d.Visible = true
                end
            end
        end
    end
    for key, d in pairs(plr_draws) do
        if not drawn[key] then d.Visible = false end
    end
    for key, l in pairs(plr_lines) do
        if not drawn[key] then l.Visible = false end
    end
end)

library.toggle(s9, { name = "player esp", default = false, callback = function(v) plr_esp = v end })
library.toggle(s9, { name = "player tracers", default = false, callback = function(v) plr_tracers = v end })
library.dropdown(s9, { name = "tracer start", options = {"bottom center", "top center", "bottom left", "bottom right", "top left", "top right"}, default = "bottom center", callback = function(v) tr_from = v end })
library.dropdown(s9, { name = "tracer end (players)", options = {"humanoid root part", "head", "torso", "left hand", "right hand"}, default = "humanoid root part", callback = function(v) tr_to = v end })

end

do

local plot_esp = false
local plot_draws = {}

run.RenderStepped:Connect(function()
    local c = ws.CurrentCamera
    if not plot_esp or not c or not c.Parent then
        for _, t in pairs(plot_draws) do t.Visible = false end
        return
    end
    local drawn = {}
    for _, p in ipairs(ws.Plots:GetChildren()) do
        local sp = p:FindFirstChild("SpawnPoint") or p:FindFirstChild("CenterPoint")
        if sp then
            local vp = c:WorldToViewportPoint(sp.Position)
            local key = p.Name
            drawn[key] = true
            if typeof(vp) == "Vector3" and vp.Z > 0 then
                local d = plot_draws[key]
                if not d then
                    d = Drawing.new("Text")
                    d.Size = 13
                    d.Center = true
                    d.Outline = true
                    d.Font = 2
                    d.Color = Color3.new(1, 1, 0.4)
                    plot_draws[key] = d
                end
                local a = p:FindFirstChild("EggGameAssets")
                local owner = a and a:GetAttribute("OwnerUserId")
                local po = owner and players:GetPlayerByUserId(owner)
                local ismine = owner == plr.UserId
                d.Text = "plot " .. p.Name .. (ismine and " - YOU" or po and (" - " .. po.Name) or owner and (" - " .. tostring(owner)) or " - empty")
                if ismine then d.Color = Color3.new(0.2, 1, 0.4) else d.Color = Color3.new(1, 1, 0.4) end
                d.Position = Vector2.new(vp.X, vp.Y)
                d.Visible = true
            else
                if plot_draws[key] then plot_draws[key].Visible = false end
            end
        end
    end
    for key, d in pairs(plot_draws) do
        if not drawn[key] then d.Visible = false end
    end
end)

library.toggle(s9, { name = "plot esp", default = false, callback = function(v) plot_esp = v end })

end

do

local shop_esp = false
local shop_draw = nil

run.RenderStepped:Connect(function()
    local c = ws.CurrentCamera
    if not shop_esp or not c or not c.Parent then
        if shop_draw then shop_draw.Visible = false end
        return
    end
    local m = ws:FindFirstChild("BrainrotEgg")
    local p = m and (m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart"))
    if not p then
        if shop_draw then shop_draw.Visible = false end
        return
    end
    local vp = c:WorldToViewportPoint(p.Position)
    if typeof(vp) ~= "Vector3" or vp.Z <= 0 then
        if shop_draw then shop_draw.Visible = false end
        return
    end
    if not shop_draw then
        shop_draw = Drawing.new("Text")
        shop_draw.Size = 14
        shop_draw.Center = true
        shop_draw.Outline = true
        shop_draw.Font = 2
        shop_draw.Color = Color3.fromRGB(255, 215, 0)
    end
    shop_draw.Text = "BRAINROT EGG SHOP"
    shop_draw.Position = Vector2.new(vp.X, vp.Y)
    shop_draw.Visible = true
end)

library.toggle(s9, { name = "brainrot shop esp", default = false, callback = function(v) shop_esp = v end })

end

local s10 = t6:section({ name = "client" })

library.toggle(s10, { name = "fullbright", default = false, callback = function(v)
    if v then
        light.Brightness = 3
        light.ClockTime = 14
        light.FogEnd = 100000
        light.GlobalShadows = false
        light.Ambient = Color3.new(1, 1, 1)
    else
        light.Brightness = 1
        light.GlobalShadows = true
        light.Ambient = Color3.new(0, 0, 0)
    end
end })

local fps_conn

library.toggle(s10, { name = "ultra performance", default = false, callback = function(v)
    if v then
        for _, d in pairs(ws:GetDescendants()) do
            if d:IsA("BasePart") then
                d.Material = Enum.Material.SmoothPlastic
                d.Reflectance = 0
            elseif d:IsA("Decal") or d:IsA("Texture") then
                d.Transparency = 1
            elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Fire") or d:IsA("Smoke") then
                d.Enabled = false
            end
        end
        fps_conn = ws.DescendantAdded:Connect(function(d)
            if d:IsA("BasePart") then
                d.Material = Enum.Material.SmoothPlastic
                d.Reflectance = 0
            elseif d:IsA("Decal") or d:IsA("Texture") then
                d.Transparency = 1
            elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Fire") or d:IsA("Smoke") then
                d.Enabled = false
            end
        end)
    else
        if fps_conn then fps_conn:Disconnect() end
    end
end })


local s11 = t7:section({ name = "misc" })

local hud_on = false
local hud_tl = nil

local function hud_destroy()
    if hud_tl then hud_tl:Destroy() end
    hud_tl = nil
end

local function hud_ensure()
    if hud_tl and hud_tl.Parent then return end
    local root = library.gui
    if not root or not root.Parent then return end
    hud_tl = Instance.new("TextLabel")
    hud_tl.Name = "lx_jts_hud"
    hud_tl.Size = UDim2.new(0, 540, 0, 22)
    hud_tl.Position = UDim2.new(0.5, -270, 0, -30)
    hud_tl.BackgroundColor3 = Color3.new(0, 0, 0)
    hud_tl.BackgroundTransparency = 0.45
    hud_tl.BorderSizePixel = 0
    hud_tl.TextColor3 = Color3.new(1, 1, 1)
    hud_tl.Font = Enum.Font.Gotham
    hud_tl.TextSize = 13
    hud_tl.Text = ""
    hud_tl.Visible = false
    hud_tl.Parent = root
end

run.RenderStepped:Connect(function()
    if not hud_on then return end
    hud_ensure()
    if not hud_tl then return end
    hud_tl.Visible = true
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    local mode = tp_mode and "tp" or ("glide " .. glide_speed)
    hud_tl.Text = (carrying_egg() and "CARRYING | " or "") .. (steal_status ~= "" and (steal_status .. " | ") or "") .. mode .. " | " .. (is_night() and "NIGHT (growth 21x)" or ("night in " .. math.max(night_left(), 0) .. "s"))
end)

library.toggle(s11, { name = "status hud", default = false, callback = function(v)
    hud_on = v
    if not v then hud_destroy() end
end })

library.toggle(s11, { name = "anti afk", default = false, callback = function(v)
    local on = v
    plr.Idled:Connect(function()
        if on then
            local v = Instance.new("VirtualInputManager")
            v:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait()
            v:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
    end)
end })

library.button(s11, { name = "rejoin", callback = function()
    tps:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end })

library.button(s11, { name = "server hop", callback = function()
    local ok, r = pcall(function()
        return hs:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"))
    end)
    if not ok or not r.data then return end
    for _, s in ipairs(r.data) do
        if s.id ~= game.JobId and s.playing < s.maxPlayers then
            tps:TeleportToPlaceInstance(game.PlaceId, s.id, plr)
            return
        end
    end
end })

library.button(s11, { name = "copy job id", callback = function()
    setclipboard(game.JobId)
end })

local webhook_url = ""

library.textbox(s11, { placeholder = "discord webhook url", callback = function(v) webhook_url = v end })

library.button(s11, { name = "test webhook", callback = function()
    if webhook_url == "" then return end
    task.spawn(function()
        local req = http_request or request or (http and http.request)
        if not req then return end
        pcall(function()
            req({
                Url = webhook_url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = hs:JSONEncode({content = "lunar x - jump to steal an egg: webhook works"})
            })
        end)
    end)
end })
