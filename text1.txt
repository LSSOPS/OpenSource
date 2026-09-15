if _G["\76\72"] then
    pcall(function() _G["\76\72"]:Unload() end)
    _G["\76\72"] = nil
    task.wait(0.15)
end
do
    if getgenv and getgenv().__LH_SetmtBP ~= game and hookfunction and newcclosure and getrenv then
        getgenv().__LH_SetmtBP = game
        local ok = pcall(function()
            local oldsetmt
            local l1 = { hits = 0 }
            getgenv().__LH_L1 = l1
            local rawget_, rawlen_, type_ = rawget, rawlen, type
            oldsetmt = hookfunction(getrenv().setmetatable, newcclosure(function(t, mt)
                if type_(mt) == "table" and rawget_(mt, "__mode") == "kv"
                   and type_(t) == "table" and rawlen_(t) == 4
                   and type_(rawget_(t, 1)) == "table"
                   and rawget_(t, 2) == 1
                   and rawget_(t, 3) == "String"
                   and type_(rawget_(t, 4)) == "userdata" then
                    l1.hits = l1.hits + 1
                    return oldsetmt({ 1, 2, 3 }, {})
                end
                return oldsetmt(t, mt)
            end))
        end)
        if not ok then getgenv().__LH_SetmtBP = nil end
    end
end
local cloneref = clonereference or cloneref or function(x) return x end
local _CR = (getgenv and getgenv().__LH_CloneRef == true)
local function cr(x) if _CR and x then return cloneref(x) else return x end end
local Players           = cr(game:GetService("Players"))
local RunService        = cr(game:GetService("RunService"))
local UserInputService  = cr(game:GetService("UserInputService"))
local VirtualInputMgr   = cr(game:GetService("VirtualInputManager"))
local ReplicatedStorage  = cr(game:GetService("ReplicatedStorage"))
local CollectionService  = cr(game:GetService("CollectionService"))
local Lighting           = cr(game:GetService("Lighting"))
local Debris             = cr(game:GetService("Debris"))
local Workspace          = workspace
local Camera             = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end)
local lp                 = Players.LocalPlayer
local _safePlayersCache = nil
local function getSafePlayers()
    if _safePlayersCache then return _safePlayersCache end
    local list = {}
    for _, p in ipairs(Players:GetChildren()) do
        if p:IsA("Player") then list[#list+1] = p end
    end
    _safePlayersCache = list
    return list
end
Players.PlayerAdded:Connect(function() _safePlayersCache = nil end)
Players.PlayerRemoving:Connect(function() _safePlayersCache = nil end)
local function waitForGameReady()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    repeat task.wait() until game:IsLoaded()
    if not lp then
        repeat task.wait() until Players.LocalPlayer
        lp = Players.LocalPlayer
    end
    if not lp:FindFirstChild("PlayerScripts") then
        repeat task.wait() until lp:FindFirstChild("PlayerScripts")
    end
    local deadline = tick() + 5
    while lp.Character == nil and tick() < deadline do task.wait() end
    return true
end
waitForGameReady()
local function safeRequire(path, timeout)
    if not path then return nil end
    timeout = timeout or 5
    local start = tick()
    while tick() - start < timeout do
        local ok, result = pcall(require, path)
        if ok then return result end
        task.wait(0.2)
    end
    return nil
end
local function waitModule(root, names, timeout)
    timeout = timeout or 10
    local obj = root
    for _, n in ipairs(names) do
        if not obj then return nil end
        local ok, child = pcall(function() return obj:WaitForChild(n, timeout) end)
        obj = ok and child or nil
    end
    return obj
end
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local function isMouseButtonDown()
    if isMobile then
        return true
    else
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    end
end
local function isInputActive(key)
    if key == "MB1" then return isMouseButtonDown() end
    if key == "MB2" then
        if isMobile then return true end
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    end
    if key == "Always" then return true end
    local kc = Enum.KeyCode[key]
    if kc and not isMobile then
        return UserInputService:IsKeyDown(kc)
    end
    return false
end
local function awaitGameLoaded(moduleInst, timeout)
    if not moduleInst or type(getloadedmodules) ~= "function" then return end
    local deadline = tick() + (timeout or 15)
    repeat
        local ok, loaded = pcall(getloadedmodules)
        if ok and type(loaded) == "table" then
            for _, m in ipairs(loaded) do
                if m == moduleInst then return end
            end
        end
        task.wait(0.1)
    until tick() >= deadline
end
local function loadGameModule(root, names)
    local inst = waitModule(root, names)
    awaitGameLoaded(inst, 15)
    return safeRequire(inst)
end
local Rivals = { Ready = false }
local hookGunModule
local function resolveAll(jobs, timeout)
    local pending = #jobs
    for _, job in ipairs(jobs) do
        task.spawn(function()
            pcall(job)
            pending = pending - 1
        end)
    end
    local deadline = tick() + (timeout or 25)
    while pending > 0 and tick() < deadline do task.wait() end
    return pending == 0
end
resolveAll({
    function() Rivals.Util    = loadGameModule(ReplicatedStorage, {"Modules","Utility"}) end,
    function() Rivals.Fighter = loadGameModule(lp.PlayerScripts,  {"Controllers","FighterController"}) end,
    function() Rivals.Enums   = loadGameModule(ReplicatedStorage, {"Modules","EnumLibrary"}) end,
    function() Rivals.Cosmetics = loadGameModule(ReplicatedStorage, {"Modules","CosmeticLibrary"}) end,
    function() Rivals.ItemLib   = loadGameModule(ReplicatedStorage, {"Modules","ItemLibrary"}) end,
})
Rivals.Ready = (Rivals.Util ~= nil and Rivals.Fighter ~= nil)
local _weaponResolving = false
local function resolveWeaponModules()
    if _weaponResolving then return end
    if Rivals.Gun ~= nil and Rivals.Melee ~= nil and Rivals.Knife ~= nil then return end
    _weaponResolving = true
    task.spawn(function()
        resolveAll({
            function() if Rivals.Gun   == nil then Rivals.Gun   = loadGameModule(lp.PlayerScripts, {"Modules","ItemTypes","Gun"})   end end,
            function() if Rivals.Melee == nil then Rivals.Melee = loadGameModule(lp.PlayerScripts, {"Modules","ItemTypes","Melee"}) end end,
            function() if Rivals.Knife == nil then Rivals.Knife = loadGameModule(lp.PlayerScripts, {"Modules","Items","Knife"})     end end,
        })
        _weaponResolving = false
        if Rivals.Gun ~= nil and hookGunModule ~= nil then pcall(hookGunModule) end
    end)
end
resolveWeaponModules()
lp.CharacterAdded:Connect(function()
    task.wait(0.5)
    resolveWeaponModules()
    if Rivals.Ready and hookGunModule then
        hookGunModule()
    end
end)
local function getEquippedItem()
    if not Rivals.Ready then return nil end
    local f = Rivals.Fighter and Rivals.Fighter.LocalFighter
    return f and f.EquippedItem or nil
end
local ConstPatch = {}
;(function()
local _getconstants = getconstants or (debug and debug.getconstants)
local _setconstant  = setconstant  or (debug and debug.setconstant)
local _getprotos    = getprotos    or (debug and debug.getprotos)
local _getproto     = getproto     or (debug and debug.getproto)
local HAVE_CONST  = type(_getconstants) == "function" and type(_setconstant) == "function"
local HAVE_PROTOS = type(_getprotos) == "function" and type(_getproto) == "function"
local _sets = {}
local function ledger(create)
    if not getgenv then
        return nil
    end
    local g = getgenv()
    local t = rawget(g, "__LH_ConstLedger")
    if not t and create then
        t = {}
        g.__LH_ConstLedger = t
    end
    return t
end
local HASH_SEED = 5381
local STR_CAP   = 256
local function hashByte(h, b)
    return bit32.band(bit32.lshift(h, 5) + h + b, 0xFFFFFFFF)
end
local function hashString(h, s)
    local n = #s
    h = hashByte(h, bit32.band(n, 0xFF))
    h = hashByte(h, bit32.band(bit32.rshift(n, 8), 0xFF))
    local upto = math.min(n, STR_CAP)
    for i = 1, upto do
        h = hashByte(h, string.byte(s, i))
    end
    return h
end
local function hashValue(h, v)
    local t = typeof(v)
    h = hashString(h, t)
    if t == "string" then
        return hashString(h, v)
    end
    if t == "number" then
        return hashString(h, string.format("%.17g", v))
    end
    if t == "boolean" then
        if v then
            return hashByte(h, 1)
        end
        return hashByte(h, 0)
    end
    return h
end
function ConstPatch.fingerprint(fn)
    if not HAVE_CONST or type(fn) ~= "function" then
        return nil
    end
    local ok, result = pcall(function()
        local consts = _getconstants(fn)
        if type(consts) ~= "table" then
            return nil
        end
        local h = HASH_SEED
        for i, v in consts do
            h = hashValue(h, i)
            h = hashValue(h, v)
        end
        if HAVE_PROTOS then
            local protos = _getprotos(fn)
            if type(protos) == "table" then
                h = hashValue(h, #protos)
            end
        end
        return h
    end)
    if not ok then
        return nil
    end
    return result
end
local function resolveFn(src)
    if type(src.fn) == "function" then
        return src.fn
    end
    if type(src.holder) ~= "table" then
        return nil
    end
    local v = rawget(src.holder, src.name)
    if type(v) ~= "function" then
        return nil
    end
    return v
end
local function candidates(fn, src)
    if src.scan ~= "protos" then
        return { fn }
    end
    if not HAVE_PROTOS then
        return nil, "executor lacks getprotos/getproto"
    end
    local ok, protos = pcall(_getprotos, fn)
    if not ok or type(protos) ~= "table" then
        return nil, "getprotos failed"
    end
    local out = {}
    for i in protos do
        local okG, live = pcall(_getproto, fn, i, true)
        if okG and type(live) == "table" and type(live[1]) == "function" then
            out[#out + 1] = live[1]
        end
    end
    return out
end
local function collectMatches(fn, src)
    local ok, consts = pcall(_getconstants, fn)
    if not ok or type(consts) ~= "table" then
        return nil, "getconstants failed"
    end
    if src.index ~= nil then
        if src.expect == nil then
            return nil, "index mode requires `expect`"
        end
        local cur = consts[src.index]
        if cur == nil then
            return nil, "no constant at index " .. tostring(src.index)
        end
        if cur ~= src.expect then
            return nil, string.format("index %s holds %s, expected %s",
                tostring(src.index), tostring(cur), tostring(src.expect))
        end
        return { { index = src.index, old = cur } }
    end
    local hits = {}
    for i, v in consts do
        if v == src.target then
            hits[#hits + 1] = { index = i, old = v }
        end
    end
    return hits
end
local function validateSource(src)
    if type(src) ~= "table" then
        return "source is not a table"
    end
    if type(src.name) ~= "string" then
        return "needs `name`"
    end
    if type(src.fn) ~= "function" and type(src.holder) ~= "table" then
        return "needs `fn`, or `holder` + `name`"
    end
    if (src.target == nil) == (src.index == nil) then
        return "needs exactly one of `target` or `index`"
    end
    if src.new == nil then
        return "needs `new`"
    end
    if src.scan ~= nil and src.scan ~= "self" and src.scan ~= "protos" then
        return "`scan` must be \"self\" or \"protos\""
    end
    if src.index ~= nil and src.scan == "protos" then
        return "`index` mode cannot be combined with scan=\"protos\""
    end
    return nil
end
local Set = {}
Set.__index = Set
function ConstPatch.new(name, sources)
    local set = setmetatable({
        name     = name,
        sources  = sources,
        restores = nil,
    }, Set)
    _sets[#_sets + 1] = set
    return set
end
function Set:Apply()
    if not HAVE_CONST then
        return false, "executor lacks debug.getconstants/debug.setconstant"
    end
    if self.restores then
        return false, self.name .. ": already applied"
    end
    local plan = {}
    for _, src in self.sources do
        local label = self.name .. "/" .. tostring(src.name or "?")
        local shapeErr = validateSource(src)
        if shapeErr then
            return false, label .. ": " .. shapeErr
        end
        local fn = resolveFn(src)
        if not fn then
            return false, label .. ": cannot resolve target function"
        end
        if src.fingerprint ~= nil then
            local got = ConstPatch.fingerprint(fn)
            if got ~= src.fingerprint then
                return false, string.format("%s: VERSION GATE — fingerprint %s, expected %s",
                    label, tostring(got), tostring(src.fingerprint))
            end
        end
        local cands, cerr = candidates(fn, src)
        if not cands then
            return false, label .. ": " .. cerr
        end
        local found = 0
        for _, cand in cands do
            local hits, herr = collectMatches(cand, src)
            if not hits then
                return false, label .. ": " .. herr
            end
            if #hits > 1 then
                return false, string.format("%s: AMBIGUOUS — %d occurrences in one function; refusing to guess",
                    label, #hits)
            end
            if #hits == 1 then
                local hit = hits[1]
                if typeof(src.new) ~= typeof(hit.old) then
                    return false, string.format("%s: type change %s -> %s refused",
                        label, typeof(hit.old), typeof(src.new))
                end
                found = found + 1
                plan[#plan + 1] = { fn = cand, index = hit.index, old = hit.old, new = src.new }
            end
        end
        local exact = src.count
        if exact == nil and src.scan ~= "protos" then
            exact = 1
        end
        if exact ~= nil then
            if found ~= exact then
                return false, string.format("%s: found %d target sites, expected %d", label, found, exact)
            end
        elseif found == 0 then
            return false, label .. ": found no target sites"
        end
    end
    local restores = {}
    self.restores = restores
    local led = ledger(true)
    for _, p in plan do
        local ok = pcall(_setconstant, p.fn, p.index, p.new)
        if not ok then
            self:Revert()
            return false, string.format("%s: setconstant failed at index %s", self.name, tostring(p.index))
        end
        local rec = { fn = p.fn, index = p.index, old = p.old }
        restores[#restores + 1] = rec
        if led then
            led[#led + 1] = rec
        end
    end
    return true
end
function Set:Revert()
    local restores = self.restores
    if not restores then
        return
    end
    self.restores = nil
    local led = ledger()
    for i = #restores, 1, -1 do
        local rec = restores[i]
        pcall(_setconstant, rec.fn, rec.index, rec.old)
        if led then
            for j = #led, 1, -1 do
                if led[j] == rec then
                    table.remove(led, j)
                    break
                end
            end
        end
    end
end
function Set:IsApplied()
    return self.restores ~= nil
end
function ConstPatch.revertAll()
    for _, set in _sets do
        pcall(function() set:Revert() end)
    end
    local led = ledger()
    if not led or not _setconstant then
        return
    end
    for i = #led, 1, -1 do
        local rec = led[i]
        if type(rec) == "table" and type(rec.fn) == "function" then
            pcall(_setconstant, rec.fn, rec.index, rec.old)
        end
        led[i] = nil
    end
end
function ConstPatch.available()
    if not HAVE_CONST then
        return false, "no debug.getconstants/debug.setconstant"
    end
    if not HAVE_PROTOS then
        return true, "no getprotos/getproto — scan=\"protos\" sources will fail"
    end
    return true, "ok"
end
function ConstPatch.learn(sources)
    local out = {}
    for _, src in sources do
        local fn = resolveFn(src)
        if fn then
            out[#out + 1] = string.format("%s = %s", tostring(src.name), tostring(ConstPatch.fingerprint(fn)))
        else
            out[#out + 1] = string.format("%s = <unresolved>", tostring(src.name))
        end
    end
    return table.concat(out, "\n")
end
function ConstPatch.dump(fn, includeProtos)
    if not HAVE_CONST or type(fn) ~= "function" then
        return "<not a function, or executor lacks debug.getconstants>"
    end
    local out = {}
    local function poolOf(f, tag)
        local ok, consts = pcall(_getconstants, f)
        if not ok or type(consts) ~= "table" then
            out[#out + 1] = tag .. ": <unreadable>"
            return
        end
        out[#out + 1] = string.format("%s  fingerprint=%s", tag, tostring(ConstPatch.fingerprint(f)))
        for i, v in consts do
            out[#out + 1] = string.format("  [%s] %s %s", tostring(i), typeof(v), string.sub(tostring(v), 1, 120))
        end
    end
    poolOf(fn, "self")
    if includeProtos and HAVE_PROTOS then
        local ok, protos = pcall(_getprotos, fn)
        if ok and type(protos) == "table" then
            for i in protos do
                local okG, live = pcall(_getproto, fn, i, true)
                if okG and type(live) == "table" and type(live[1]) == "function" then
                    poolOf(live[1], "proto[" .. tostring(i) .. "]")
                else
                    out[#out + 1] = "proto[" .. tostring(i) .. "]: <no live closure>"
                end
            end
        end
    end
    return table.concat(out, "\n")
end
ConstPatch.revertAll()
end)()
local Config = {
    GUIToggleKey = "RightShift",
    SilentAim = false, SilentAimVisCheck = false, SilentAimJitter = true,
    SilentAimTargetPart = "Head", SilentAimFOV = 250, AvoidDeflect = true,
    SilentAimStickiness = 0.05,
    SilentAimMultipoint = false,
    SilentAimMultipointCount = 5,
    SilentAimTorsoFallback = false,
    Aimbot = false, AimbotVisCheck = true, AimbotKey = "MB2",
    AimbotSmoothness = 0,
    AimbotSmoothnessX = 0,
    AimbotSmoothnessY = 0,
    AimbotLinkAxes = true,
    AimbotJumpDamping = 40,
    AimbotCancelSprings = true,
    AimbotCurvedFlick = false,
    AimbotCurvedIntensity = 0.35,
    AimbotTrackAssist = 100,
    AimbotFOVDeg = 20,
    AimbotMaxSpeed = 0,
    AimbotDeadzoneDeg = 0,
    AimbotSwitchDeg = 2,
    AimbotStickiness = 0.15,
    AimbotForgetTime = 0.2,
    AimbotTargetPart = "Best",
    AimbotPriority = "Crosshair",
    AimbotSkipImmune = true,
    AimbotPrediction = false,
    AimbotShotOverride = false,
    AimbotShowFOV = false, AimbotShowLock = false,
    AimbotDebug = false,
    AimbotReactionMs = 0,
    AimbotNoiseDeg = 0,
    AimbotOvershoot = 0,
    AimbotDirectCamera = false,
    Trigger = false,
    TriggerKey = "Always",
    TriggerDelayMs = 0,
    TriggerRefireMs = 0,
    TriggerHeadOnly = false,
    TriggerMaxDist = 400,
    MaxDistance = 1200, TeamCheck = true,
    PredictiveLead = true, LeadCap = 15, ServerProcessingMs = 30,
    ProjectileLead = false,
    ProjectileSpeed = 300,
    Rage = false,
    RageFireRateOverride = 0,
    RageRestoreWhileFiring = false,
    RageVoidMove         = true,
    RageVoidMinStep      = 25000,
    RageVoidJitterLocal  = false,
    RageVoidJitterStuds  = 2000,
    RageEyeMuzzleSep     = 0.07,
    RageVoidDepth        = "deep",
    RageGatePoison       = true,
    RagePredictPrefire   = true,
    RageSkipImmune       = true,
    RageIdentityDance    = true,
    RagePredictResurface = true,
    RageAttackContinuity = true,
    RageKnifeBot         = true,
    RageMeleeAsk         = true,
    RageMeleeLog         = false,
    RageKnifeCamForge    = true,
    RageParkLift         = false,
    RagePolarParity      = true,
    RagePhysicsFlags     = true,
    RageRestoreMode      = "auto",
    RageCameraAnchor     = true,
    RagePartGlue         = false,
    RageGumMode          = "on",
    RageGumVoidFire      = true,
    RageAttackTranslocate = true,
    RageBaitHeldMs = 300,
    RageBaitRate   = 2,
    RageTapsPerFrame     = 1,
    RagePrioritizeHackers = true,
    RageHideJitter        = true,
    RageHPPriority       = true,
    RageFastTargetSwitch = true,
    RageVisCheck         = false,
    AvoidDeflect       = true,
    RageShieldBackstab = true,
    RageKnifeBackstab  = true,
    RageKillPlaneBuffer = 200,
    RageLab = false,
    RageVoidPhase = true,
    RageMode = "Polar",
    RageDirectFire        = true,
    RageRateLimit         = false,
    RageTaps              = 6,
    RageCombatOrbitRadius = 60,
    RageOrbitDwell        = 0.30,
    RageCombatOrbitHeight = 8,
    RageCombatOrbitJitter = true,
    RagePBEyeUp           = 3,
    RageOnEmpty          = "Swap",
    RagePreferredSlot    = "Primary",
    TriggerScopeCheck    = false,
    SilentAimHitChance   = 85,
    SilentAimBodyMix     = 25,
    SilentAimJitterDeg   = 1.5,
    AutoWeaponEnabled    = false,
    AutoWeaponPrimary    = "",
    AutoWeaponSecondary  = "",
    AutoWeaponMelee      = "",
    AutoWeaponUtility    = "",
    RageMultiTap  = 1,
    RageCombatMode = "Nullpoint",
    ESP = false, ESPTeamCheck = true,
    ESPMaxDistance = 1200, ESPMaxPlayers = 0,
    ESPFont = "Code",
    ESPTextSize = 14, ESPInfoTextSize = 12, ESPHealthTextSize = 11,
    ESPTextScale = 1,
    ESPTextCasing = 1,
    ESPDistanceScaling    = true,
    ESPDistanceScalingRef = 50,
    ESPCasingThickness = 1,
    ESPBoxScale = 1,
    ESPBox = true, ESPBoxStyle = "Full Box", ESPBoxBrackets = false, ESPCornerLength = 0.28,
    ESPBoxFill = false, ESPBoxThickness = 1,
    ESPName = true, ESPDistance = true, ESPWeapon = false,
    ESPHealth = true, ESPHealthNumberMode = "OnDamage",
    ESPSkeleton = false, ESPSkeletonThickness = 1,
    ESPChams = false,
    ESPTracers = false, ESPTracerThickness = 1, ESPTracerOrigin = "Bottom",
    ESPArrows = false,
    ESPFlagStaring = false, ESPFlagDeflect = true, ESPFlagShield = true, ESPFlagInvincible = true, ESPFlagLowHP = true,
    ESPHeadDot = false, ESPHeadDotSize = 4,
    ESPBoxColorMode      = "Solid",
    ESPBoxColor          = Color3.fromRGB(255, 255, 255),
    ESPBoxGradA          = Color3.fromRGB(255,  59,  78),
    ESPBoxGradB          = Color3.fromRGB(255, 194,  75),
    ESPBoxFillColor      = Color3.fromRGB(255,  59,  78),
    ESPHealthColorMode   = "Ramp",
    ESPHealthColor       = Color3.fromRGB( 61, 224, 122),
    ESPHealthGradA       = Color3.fromRGB(255,  68,  54),
    ESPHealthGradB       = Color3.fromRGB( 61, 224, 122),
    ESPNameColorMode     = "Solid",
    ESPNameColor         = Color3.fromRGB(255, 255, 255),
    ESPNameGradA         = Color3.fromRGB(255, 255, 255),
    ESPNameGradB         = Color3.fromRGB(255, 194,  75),
    ESPInfoColorMode     = "Solid",
    ESPInfoColor         = Color3.fromRGB(255, 255, 255),
    ESPInfoGradA         = Color3.fromRGB(255, 255, 255),
    ESPInfoGradB         = Color3.fromRGB(255, 158,  75),
    ESPFlagColorMode     = "PerFlag",
    ESPFlagColor         = Color3.fromRGB(255, 194,  75),
    ESPFlagGradA         = Color3.fromRGB(255, 194,  75),
    ESPFlagGradB         = Color3.fromRGB(255,  70,  85),
    ESPSkeletonColorMode = "Solid",
    ESPSkeletonColor     = Color3.fromRGB(255, 255, 255),
    ESPSkeletonGradA     = Color3.fromRGB(255, 255, 255),
    ESPSkeletonGradB     = Color3.fromRGB(120, 180, 255),
    ESPTracerColorMode   = "Solid",
    ESPTracerColor       = Color3.fromRGB(255, 255, 255),
    ESPTracerGradA       = Color3.fromRGB(255, 255, 255),
    ESPTracerGradB       = Color3.fromRGB(255,  59,  78),
    ESPMarkColorMode     = "Solid",
    ESPMarkColor         = Color3.fromRGB(255, 255, 255),
    ESPMarkGradA         = Color3.fromRGB(255, 255, 255),
    ESPMarkGradB         = Color3.fromRGB(255, 194,  75),
    ESPGradientSpeed     = 0,
    ESPGradientRotBox    = 0,
    ESPGradientRotText   = 90,
    ESPHeadDotColor      = Color3.fromRGB(255, 255, 255),
    ESPChamsFillColor    = Color3.fromRGB(255, 59, 78),
    ESPChamsOutlineColor = Color3.fromRGB(255, 255, 255),
    ColorEnemy       = Color3.fromRGB(255, 59, 78),
    ColorTeam        = Color3.fromRGB(53, 215, 199),
    ColorEnemyOcc    = Color3.fromRGB(168, 85, 96),
    ColorTeamOcc     = Color3.fromRGB(92, 153, 147),
    ColorVisible     = Color3.fromRGB(41, 224, 255),
    ESPDistNearColor = Color3.fromRGB(80, 255, 140),
    ESPDistFarColor  = Color3.fromRGB(255, 70, 90),
    ESPBoxTransparency          = 0,
    ESPBoxFillTransparency      = 0.75,
    ESPNameTransparency         = 0,
    ESPHealthTransparency       = 0.1,
    ESPSkeletonTransparency     = 0.2,
    ESPTracerTransparency       = 0.35,
    ESPHeadDotTransparency      = 0,
    ESPChamsFillTransparency    = 0.6,
    ESPChamsOutlineTransparency = 0,
    Visuals = false, VisualsPreset = "Neutral", VisualsPerformanceMode = false,
    VisualsFullbright = false,
    VisualsNoFog = false,
    VisualsHolograms = false, VisualsRainbowMap = false,
    VisualsRainbowMapSpeed = 0.15, VisualsStretch = 1.0,
    VisualsStretchMin = 0.5, VisualsStretchMax = 1.2,
    VisualsCameraSway = false,
    VisualsCameraSwayAmount = 0.5,
    VisualsHologramDuration = 3.5, VisualsHologramRange = 300,
    VisualsHologramVisibility = 1.4,
    VisualsHologramColor  = Color3.fromRGB(0, 220, 255),
    VisualsHologramAccent = Color3.fromRGB(255, 60, 200),
    VisualsGrade = "Crisp",
    VisualsGradeStrength = 0.6,
    VisualsBloom = false,
    VisualsBloomIntensity = 1.0,
    VisualsVignette = false,
    VisualsVignetteStrength = 0.6,
    VisualsLetterbox = false,
    VisualsLetterboxSize = 0.10,
    VisualsDOF = false,
    VisualsDOFDistance = 28,
    VisualsDOFBlur = 0.5,
    VisualsHologramStyle = "Orb",
    VisualsHologramLethal = true,
    VisualsHologramLethalColor = Color3.fromRGB(255, 200, 60),
    HUD = false,
    FXHitMarker = true,
    FXHitMarkerColor = Color3.fromRGB(255, 255, 255),
    FXHitMarkerCritColor = Color3.fromRGB(255, 194, 75),
    FXHitMarkerLethalColor = Color3.fromRGB(255, 64, 78),
    FXHitMarkerGap = 5,
    FXHitMarkerLen = 8,
    FXHitMarkerThickness = 2,
    FXHitSound = true,
    FXHitSoundId = "",
    FXKillSoundId = "",
    FXHitSoundVolume = 0.5,
    FXDamageNumbers = true,
    FXDamageAccumWindow = 0.9,
    FXKillBanner = true,
    FXKillBannerColor = Color3.fromRGB(255, 194, 75),
    FXKillFeed = true,
    FXHeadshotSpark = true,
    FXHitFlash = true,
    FXDamageDirection = true,
    FXLowHPVignette = true,
    FXLowHPThreshold = 0.35,
    FXCritDamage = 30,
    FXBeamTracer     = false,
    FXBeamStyle      = "Glow",
    FXBeamHitColor   = Color3.fromRGB(255, 194, 75),
    FXBeamMissColor  = Color3.fromRGB(143, 160, 176),
    FXFovRing        = false,
    FXFovColorA      = Color3.fromRGB(53, 215, 199),
    FXFovColorB      = Color3.fromRGB(255, 194, 75),
    FXFovThickness   = 1.5,
    FXFovDriftSpeed  = 0.15,
    FXFovFill        = false,
    FXFovRotate      = true,
    FXWorldSpark     = false,
    FXBeamWidth0    = 0.18,
    FXBeamWidth1    = 0.04,
    FXBeamDur       = 0.55,
    FXBeamGlowLight = true,
    FXBeamTravel      = true,
    FXBeamTravelSpeed = 1400,
    FXBeamImpact      = true,
    FXWorldSparkBloom = true,
    FXKillPillar      = false,
    FXKillPillarColor = Color3.fromRGB(255, 194, 75),
    FXKillShards      = false,
    FXKillShardsColor = Color3.fromRGB(155, 232, 255),
    FXKillPulse       = false,
    FXKillPulseAmount = 0.6,
    FXFovCasing     = true,
    FXCrosshair          = false,
    FXCrosshairStyle     = "Cross",
    FXCrosshairColor     = Color3.fromRGB(243, 246, 250),
    FXCrosshairDot       = true,
    FXCrosshairGap       = 4,
    FXCrosshairLen       = 7,
    FXCrosshairThickness = 2,
    FXCrosshairOutline   = true,
    FXCrosshairHitPop    = true,
    HUDWatermark      = true,
    HUDWatermarkStats = true,
    FXTargetInfo       = false,
    FXTargetInfoOffset = 110,
    HUDBindList     = false,
    HUDBindListSide = "Left",
    FXHitMarkerStyle = "X",
    FXCrosshairBloom = false,
    HUDCompass       = false,
    HUDCompassWidth  = 380,
    HUDCompassPips   = true,
    HUDThreatArc     = false,
    HUDRangeReadout  = false,
    ESPRadarGrid  = true,
    ESPRadarSweep = false,
    ESPFadeIn = true,
    ESPArrowDistFade  = true,
    ESPArrowDistLabel = false,
    ESPLookLine       = false,
    ESPLookLineLength = 8,
    ESPHealthSmooth = true,
    ESPHealthGhost = true,
    ESPDeclutter = true,
    ESPChamsVisSplit = true,
    ESPRadar = false,
    ESPRadarSize = 200,
    ESPRadarRange = 150,
    ESPRadarRotate = true,
    ESPRadarVisSplit = true,
    ESPRadarInset = 24,
    ESPPeekAlert = false,
    ESPThreatCount = false,
    ESPPrimaryEmphasis = false,
    ESPHealTick = false,
    ESPNameHealthUnderline = false,
    ESPLockChevron         = false,
    ESPChamsStyle          = "Shade",
    ESPNameMode            = "Display",
    UtilityESP            = false,
    UtilityESPMaxDistance = 250,
    UtilityESPRing        = true,
    UtilityESPLabels      = true,
    Weather          = false,
    WeatherType      = "Rain",
    WeatherIntensity = 1.0,
    WeatherMeteors   = false,
    WeatherMeteorRate = 1.0,
    WeatherStarRate  = 1.0,
    WeatherClockDial = false,
    WeatherClockCycleMin = 8,
    WeatherStorm     = false,
    WeatherStormFlash= true,
    WeatherStormMin  = 4,
    WeatherStormVar  = 8,
    WeatherThunderId = "rbxassetid://9113169432",
    WeatherSoundIds  = {
        rain  = "rbxassetid://9112858162",
        wind  = "rbxassetid://9112854440",
        fire  = "rbxassetid://2787093357",
        night = "rbxassetid://9112764573",
        birds = "rbxassetid://9112749254",
    },
    WeatherSoundVolume = 0.35,
    WeatherMood      = true,
    SkyboxPreset        = "Off",
    SkyboxHideCelestial = false,
    WeatherGodRays      = false,
    WeatherRainbow      = false,
    WeatherShootingStars = false,
    WeatherPuddles   = false,
    GameVisuals = false,
    GVUnlockAll     = true,
    GVUnlockWeapons = false,
    GVWrapInverted  = false,
    GVEveryone      = false,
    GVBirthHook     = true,
    GVFinisherClone = true,
    GVRemember      = true,
    GVRankCharmOn    = false,
    GVRankCharmRank  = "",
    GVRankCharmLb    = 0,
    GVEmotes         = false,
    SpooferNameEnabled        = false,
    SpooferName               = "ProPlayer",
    SpooferDisplayName        = "ProPlayer",
    SpooferLevelEnabled       = false,
    SpooferLevel              = 100,
    SpooferCasualWinsEnabled  = false,
    SpooferCasualWins         = 500,
    SpooferRankedWinsEnabled  = false,
    SpooferRankedWins         = 250,
    SpooferRankedEloEnabled   = false,
    SpooferRankedElo          = 2400,
    SpooferWinPercentEnabled  = false,
    SpooferWinPercent         = 75,
    SpooferWinStreakEnabled   = false,
    SpooferWinStreak          = 25,
    SpooferFavoriteMapEnabled = false,
    SpooferFavoriteMap        = "Arena",
    VMOffsetEnabled      = false,
    VMOffsetX            = 0,
    VMOffsetY            = 0,
    VMOffsetZ            = 0,
    VMOffsetPitch        = 0,
    VMOffsetYaw          = 0,
    VMOffsetRoll         = 0,
    VMChamsEnabled       = false,
    VMChamsMaterial      = "ForceField",
    VMChamsColor         = Color3.fromRGB(53, 215, 199),
    VMChamsTransparency  = 0.5,
    VMDisableTextures    = false,
    FXCrosshairAngle     = 0,
    FXCrosshairSpin      = false,
    FXCrosshairSpinSpeed = 1.0,
    FXCrosshairSniper    = false,
    FXCrosshairBounce    = false,
    FXCrosshairBounceAmt = 4,
    CameraAspectRatioEnabled = false,
    CameraAspectRatioX       = 4,
    CameraAspectRatioY       = 3,
    CameraFovOverride        = false,
    CameraFovAmount          = 90,
    ThirdPersonEnabled       = false,
    ThirdPersonDistance      = 12,
    ESPAmmoBar           = false,
    ESPHealthNumber      = true,
    AutoQueue            = false,
    AutoQueueMode        = "1v1",
    AutoCollectDrops     = false,
    CollectHealth        = true,
    CollectAmmo          = true,
}
if isMobile then
    Config.AimbotKey = "Always"
end
local ViewAngle
local State = {
    Target = nil, CamPos = Vector3.zero,
    AimbotTarget = nil, AimbotPart = nil,
    AimbotLastTarget = nil, AimbotLastTargetTime = 0,
    AimbotKeyHeld = false, SilentLastTarget = nil,
    RageAutoTransport = "kicia", RageTransportSwitches = 0, RageLastLossAt = 0,
    AutoWeaponFails = 0,
    AimbotFlickActive = false, AimbotSpringOffset = Vector2.zero,
    RageRealCF   = nil,
    RageRealChar = nil,
    RageTarget   = nil,
    RageVoidCF   = nil,
    RageVoidNext = 0,
    RageVoidBase = nil,
    RageVoidSteps = 0,
    RageLastFireTime = 0,
    RageReloadLast   = 0,
    RageSwitchLast   = 0,
    OrbitAngle        = 0,
    OrbitVantage      = nil,
    OrbitVantageUntil = 0,
    RageForging          = false,
    RageLeakCanary       = 0,
    RageTracerCanary     = 0,
    RageBlankCanary      = 0,
    RageOOBParkCanary    = 0,
    RageHitsOn           = 0,
    RageHitsOff          = 0,
    RageOffFromSelf      = 0,
    RageOffFromTarget    = 0,
    ViewAngleForged      = false,
    RageKnifeSwings      = 0,
    RageKnifeStatus      = "idle",
    RageRawSet           = false,
    RagePhysRate         = "off",
    RageFPDHPath         = "not attempted",
    RageParkDirty        = false,
    RageLastParkPos      = nil,
    RageParkLatchCanary  = 0,
    RageLatchStuds       = 0,
    RageOrderCanary      = 0,
    RagePostPark         = false,
    RageBelowPlaneFrames = 0,
    RageBelowPlaneLast   = 0,
    RageBelowPlaneDeaths = 0,
    RageParkDriftFrames  = 0,
    RageParkDrift        = 0,
    RageParkDriftY       = 0,
    RageEyeClampFrames   = 0,
    RageParkClampFrames  = 0,
    RageTranslocateBaits = 0,
    RageFireZeroFrames = 0,
    IdentitySafe = nil,
    CapabilityErrors = 0,
    CapabilityKilledAt = nil,
    CapabilityLastStatus = nil,
    CapabilityRecoveries = 0,
    CapabilityDirty = false,
    RageWhyProtected = 0,
    RageWhyNoPark = 0,
    RageWhyPrimeWait = 0,
    RageWhyPredict = 0,
    RageWhyDip = 0,
    RageWhyMeleeCd = 0,
    RageFireFrames = 0,
    RageImmuneStale = 0,
    RageAmmoUnreadable = 0,
    RageBaitHoldFrames = 0,
    RageBaitPinRefused = 0,
    RageBaitRingFallbacks = 0,
    RageVoidFires = 0,
    RagePoisonBlips = 0,
    RagePreFires = 0,
    RagePredTarget = nil,
    RagePredHide = 0, RagePredHideN = 0,
    RagePredAtk = 0,  RagePredAtkN = 0,
    RagePredPhase = "?", RagePredFor = 0,
    RagePredDue = 0,
    RagePredWindow = false,
    RagePredMag = 0,
    RageGumMode = "off",
    RageKnifeHintLast = 0,
    RageInMatch  = false,
    RageStatus   = "Idle",
    RageFireFromPos = nil,
    RageFireAimPos  = nil,
    RageFireHitPart = nil,
    RageFireStamp   = 0,
    RageDealtTotal  = 0,
    RageFiring          = false,
    RageVoidActive      = false,
    RageTranslocating   = false,
    RageTrueVelocityMap = {},
    RageSuspectedProtection = {},
    RageBacktrackBuf    = {},
    RageCharTokens      = {},
    Shots = 0, Hits = 0,
    ESPObjects = {}, RainbowHue = 0,
    VisualsCurrentPreset = nil,
    GVApplied = 0,
    GVStatus  = "idle",
}
local screenDraw
do
    local CoreGui = game:GetService("CoreGui")
    local _layers = {}
    local LAYER_ORDER = { base = 100000, fx = 100100 }
    local LAYER_NAME  = { base = "LH_Overlay", fx = "LH_Overlay_FX" }
    local FONT_MAP = {
        [0] = Enum.Font.Gotham, [1] = Enum.Font.SourceSans,
        [2] = Enum.Font.GothamMedium, [3] = Enum.Font.Code,
        [4] = Enum.Font.GothamBold, [5] = Enum.Font.SourceSansBold,
    }
    local BLACK = Color3.new(0, 0, 0)
    local function op(t) return 1 - (t or 1) end
    local function gui(layer)
        local Lr = _layers[layer]
        if not Lr then Lr = { gui = nil, z = 0, pools = {} }; _layers[layer] = Lr end
        if Lr.gui and Lr.gui.Parent then return Lr.gui end
        local g = Instance.new("ScreenGui")
        g.Name = LAYER_NAME[layer] or "LH_Overlay"
        g.IgnoreGuiInset = true
        g.ResetOnSpawn  = false
        g.DisplayOrder  = LAYER_ORDER[layer] or 100000
        g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        local ok = pcall(function() g.Parent = (gethui and gethui()) or CoreGui end)
        if not ok or not g.Parent then
            pcall(function() g.Parent = lp:FindFirstChildOfClass("PlayerGui") end)
        end
        Lr.gui = g
        return g
    end
    local function build(kind)
        if kind == "Square" then
            local f = Instance.new("Frame")
            f.BorderSizePixel = 0; f.BackgroundTransparency = 1
            f.AnchorPoint = Vector2.new(0, 0); f.Visible = false
            local st = Instance.new("UIStroke")
            st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            st.LineJoinMode = Enum.LineJoinMode.Miter
            st.Enabled = false; st.Parent = f
            local ug = nil
            local function apply(s, k)
                if k == "Position" then if s.Position then f.Position = UDim2.fromOffset(s.Position.X, s.Position.Y) end
                elseif k == "Size" then if s.Size then f.Size = UDim2.fromOffset(s.Size.X, s.Size.Y) end
                elseif k == "Color" then if s.Color then f.BackgroundColor3 = s.Color; st.Color = s.Color end
                elseif k == "Thickness" then st.Thickness = math.max(s.Thickness or 1, 0.1)
                elseif k == "Transparency" or k == "Filled" then
                    local o = op(s.Transparency)
                    if s.Filled == false then f.BackgroundTransparency = 1; st.Enabled = true; st.Transparency = o
                    else f.BackgroundTransparency = o; st.Enabled = false end
                elseif k == "Gradient" then
                    if s.Gradient then
                        if not ug then ug = Instance.new("UIGradient"); ug.Parent = st end
                        ug.Color = s.Gradient; ug.Enabled = true
                    elseif ug then ug.Enabled = false end
                elseif k == "GradientRotation" then if ug then ug.Rotation = s.GradientRotation or 0 end
                elseif k == "Visible" then f.Visible = s.Visible and true or false end
            end
            return f, apply
        elseif kind == "Line" then
            local f = Instance.new("Frame")
            f.BorderSizePixel = 0; f.AnchorPoint = Vector2.new(0.5, 0.5); f.Visible = false
            local _len = nil
            local function geom(s)
                if not (s.From and s.To) then return end
                local dx, dy = s.To.X - s.From.X, s.To.Y - s.From.Y
                local len = math.sqrt(dx * dx + dy * dy)
                _len = len
                f.Position = UDim2.fromOffset((s.From.X + s.To.X) * 0.5, (s.From.Y + s.To.Y) * 0.5)
                f.Size     = UDim2.fromOffset(len, math.max(s.Thickness or 1, 0.1))
                f.Rotation = math.deg(math.atan2(dy, dx))
            end
            local function apply(s, k)
                if k == "To" then geom(s)
                elseif k == "From" then
                elseif k == "Thickness" then if _len then f.Size = UDim2.fromOffset(_len, math.max(s.Thickness or 1, 0.1)) end
                elseif k == "Color" then if s.Color then f.BackgroundColor3 = s.Color end
                elseif k == "Transparency" then f.BackgroundTransparency = op(s.Transparency)
                elseif k == "Visible" then f.Visible = s.Visible and true or false end
            end
            return f, apply
        elseif kind == "Text" then
            local t = Instance.new("TextLabel")
            t.BackgroundTransparency = 1; t.BorderSizePixel = 0; t.Visible = false
            t.AutomaticSize = Enum.AutomaticSize.XY; t.RichText = false
            t.TextYAlignment = Enum.TextYAlignment.Top
            t.AnchorPoint = Vector2.new(0, 0); t.TextXAlignment = Enum.TextXAlignment.Left
            local st = Instance.new("UIStroke"); st.Thickness = 1; st.Color = BLACK
            st.LineJoinMode = Enum.LineJoinMode.Miter
            st.Enabled = false; st.Parent = t
            local function apply(s, k)
                if k == "Text" then t.Text = tostring(s.Text or "")
                elseif k == "Size" then t.TextSize = math.max(s.Size or 12, 1)
                elseif k == "Font" then t.Font = FONT_MAP[s.Font or 2] or Enum.Font.GothamMedium
                elseif k == "Color" then if s.Color then t.TextColor3 = s.Color end
                elseif k == "Center" or k == "RightAlign" then
                    if s.Center then t.AnchorPoint = Vector2.new(0.5, 0); t.TextXAlignment = Enum.TextXAlignment.Center
                    elseif s.RightAlign then t.AnchorPoint = Vector2.new(1, 0); t.TextXAlignment = Enum.TextXAlignment.Right
                    else t.AnchorPoint = Vector2.new(0, 0); t.TextXAlignment = Enum.TextXAlignment.Left end
                    if s.Position then t.Position = UDim2.fromOffset(s.Position.X, s.Position.Y) end
                elseif k == "Position" then if s.Position then t.Position = UDim2.fromOffset(s.Position.X, s.Position.Y) end
                elseif k == "Outline" then st.Enabled = s.Outline and true or false
                elseif k == "OutlineColor" then if s.OutlineColor then st.Color = s.OutlineColor end
                elseif k == "Transparency" then local o = op(s.Transparency); t.TextTransparency = o; st.Transparency = o
                elseif k == "Visible" then t.Visible = s.Visible and true or false end
            end
            return t, apply
        elseif kind == "Circle" then
            local f = Instance.new("Frame")
            f.BorderSizePixel = 0; f.AnchorPoint = Vector2.new(0.5, 0.5)
            f.BackgroundTransparency = 1; f.Visible = false
            local uc = Instance.new("UICorner"); uc.CornerRadius = UDim.new(1, 0); uc.Parent = f
            local st = Instance.new("UIStroke"); st.Enabled = false; st.Parent = f
            local function apply(s, k)
                if k == "Radius" then local d = 2 * (s.Radius or 0); f.Size = UDim2.fromOffset(d, d)
                elseif k == "Position" then if s.Position then f.Position = UDim2.fromOffset(s.Position.X, s.Position.Y) end
                elseif k == "Color" then if s.Color then f.BackgroundColor3 = s.Color; st.Color = s.Color end
                elseif k == "Thickness" then st.Thickness = math.max(s.Thickness or 1, 0.1)
                elseif k == "Transparency" or k == "Filled" then
                    local o = op(s.Transparency)
                    if s.Filled == false then f.BackgroundTransparency = 1; st.Enabled = true; st.Transparency = o
                    else f.BackgroundTransparency = o; st.Enabled = false end
                elseif k == "Visible" then f.Visible = s.Visible and true or false end
            end
            return f, apply
        elseif kind == "Triangle" then
            local box = Instance.new("Frame")
            box.BackgroundTransparency = 1; box.BorderSizePixel = 0
            box.AnchorPoint = Vector2.new(0, 0); box.Position = UDim2.fromOffset(0, 0)
            box.Size = UDim2.fromScale(1, 1); box.Visible = false
            local BLK = Color3.new(0, 0, 0)
            local function mkleg(col)
                local l = Instance.new("Frame")
                l.BorderSizePixel = 0; l.AnchorPoint = Vector2.new(0.5, 0.5)
                l.BackgroundColor3 = col or Color3.new(1, 1, 1); l.Visible = false; l.Parent = box
                return l
            end
            local cas1, cas2 = mkleg(BLK), mkleg(BLK)
            local leg1, leg2, leg3, leg4, leg5 = mkleg(), mkleg(), mkleg(), mkleg(), mkleg()
            local legs = { leg1, leg2, leg3, leg4, leg5 }
            local stem = mkleg()
            local function mid(p, q) return Vector2.new((p.X + q.X) * 0.5, (p.Y + q.Y) * 0.5) end
            local function leg(l, p, q, thick)
                local dx, dy = q.X - p.X, q.Y - p.Y
                local len = math.sqrt(dx * dx + dy * dy)
                l.Position = UDim2.fromOffset((p.X + q.X) * 0.5, (p.Y + q.Y) * 0.5)
                l.Size     = UDim2.fromOffset(math.max(len, 1), thick)
                l.Rotation = math.deg(math.atan2(dy, dx))
                l.Visible  = true
            end
            local function geom(s)
                local A, B, C = s.PointA, s.PointB, s.PointC
                if not (A and B and C) then return end
                local dA = (A - mid(B, C)).Magnitude
                local dB = (B - mid(A, C)).Magnitude
                local dC = (C - mid(A, B)).Magnitude
                local apex, b1, b2
                if dA >= dB and dA >= dC then apex, b1, b2 = A, B, C
                elseif dB >= dC then apex, b1, b2 = B, A, C
                else apex, b1, b2 = C, A, B end
                local base = mid(b1, b2)
                local h    = math.max((apex - base).Magnitude, 1)
                if s.Filled == true then
                    cas1.Visible = false; cas2.Visible = false; stem.Visible = false
                    local ft = h / 5 + 1
                    for k = 1, 5 do
                        local t = (k - 0.5) / 5
                        leg(legs[k], b1:Lerp(apex, t), b2:Lerp(apex, t), ft)
                    end
                else
                    local thick = math.clamp(h * 0.34, 3, 6)
                    leg(cas1, apex, b1, thick + 2)
                    leg(cas2, apex, b2, thick + 2)
                    leg(leg1, apex, b1, thick)
                    leg(leg2, apex, b2, thick)
                    local dir = apex - base
                    if dir.Magnitude > 0 then dir = dir.Unit else dir = Vector2.new(0, -1) end
                    leg(stem, apex, apex + dir * (h * 0.5), thick)
                    leg3.Visible = false; leg4.Visible = false; leg5.Visible = false
                end
            end
            local function apply(s, k)
                if k == "PointC" or k == "Filled" then geom(s)
                elseif k == "PointA" or k == "PointB" then
                elseif k == "Color" then
                    if s.Color then
                        leg1.BackgroundColor3 = s.Color; leg2.BackgroundColor3 = s.Color
                        leg3.BackgroundColor3 = s.Color; leg4.BackgroundColor3 = s.Color
                        leg5.BackgroundColor3 = s.Color; stem.BackgroundColor3 = s.Color
                    end
                elseif k == "Transparency" then
                    local o = op(s.Transparency)
                    leg1.BackgroundTransparency = o; leg2.BackgroundTransparency = o
                    leg3.BackgroundTransparency = o; leg4.BackgroundTransparency = o
                    leg5.BackgroundTransparency = o; stem.BackgroundTransparency = o
                elseif k == "Visible" then box.Visible = s.Visible and true or false end
            end
            return box, apply
        end
        return nil
    end
    screenDraw = function(kind, layer)
        layer = layer or "base"
        local Lr = _layers[layer]
        if not Lr then Lr = { gui = nil, z = 0, pools = {} }; _layers[layer] = Lr end
        local pool = Lr.pools[kind]; if not pool then pool = {}; Lr.pools[kind] = pool end
        local inst, applyFn
        local reused = table.remove(pool)
        if reused then
            inst, applyFn = reused.inst, reused.apply
        else
            inst, applyFn = build(kind)
            if not inst then return nil end
            inst.Parent = gui(layer)
        end
        Lr.z = Lr.z + 1; inst.ZIndex = Lr.z
        inst.Visible = false
        local state = {}
        return setmetatable({}, {
            __index = function(_, k)
                if k == "Remove" then
                    return function()
                        inst.Visible = false
                        pool[#pool + 1] = { inst = inst, apply = applyFn }
                    end
                elseif k == "TextBounds" then
                    return inst.TextBounds
                end
                return state[k]
            end,
            __newindex = function(_, k, v)
                if state[k] == v then return end
                state[k] = v
                applyFn(state, k)
            end,
        })
    end
end
local HEAD_PARTS    = { "HitboxHead", "HitboxHeadSmall", "Head" }
local TORSO_PARTS   = { "HitboxBody", "UpperTorso", "HumanoidRootPart", "LowerTorso" }
local CLOSEST_PARTS = {
    "HitboxHead","Head","UpperTorso","LowerTorso","HumanoidRootPart",
    "LeftHand","RightHand","LeftFoot","RightFoot",
    "LeftUpperArm","RightUpperArm","LeftUpperLeg","RightUpperLeg",
}
local function envIdOf(player)
    local id = nil
    pcall(function()
        local fc = Rivals.Fighter
        if fc == nil then return end
        local f = (player == lp) and fc.LocalFighter or (fc._player_to_fighter and fc._player_to_fighter[player])
        if f == nil then return end
        id = f:Get("EnvironmentID")
        if id == nil and f.Entity ~= nil then id = f.Entity:Get("EnvironmentID") end
    end)
    return id
end
local function isTeammate(player)
    if player == lp then return true end
    local myEnv, theirEnv = envIdOf(lp), envIdOf(player)
    if myEnv ~= nil and theirEnv ~= nil and myEnv ~= theirEnv then return true end
    local a = lp:GetAttribute("TeamID")
    local b = player:GetAttribute("TeamID")
    if a == nil or b == nil then
        if lp.Team ~= nil and player.Team ~= nil then return lp.Team == player.Team end
        return false
    end
    return a == b
end
local function isAlive(player)
    local c = player.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    return h ~= nil and h.Health > 0
end
local identityIsSafe = (function()
    local latched, killed = nil, false
    local _seamShown = {}
    State.CapabilityObserver = false
    pcall(function()
        game:GetService("LogService").MessageOut:Connect(function(msg)
            if type(msg) ~= "string" or not string.find(msg, "lacking capability", 1, true) then return end
            State.CapabilityErrors = (State.CapabilityErrors or 0) + 1
            State.CapabilityLastStatus = tostring(State.RageStatus)
            local seam = tostring(State.CapabilitySeam or "unlabelled")
            if _seamShown[seam] == nil then
                _seamShown[seam] = true
                print("[LuaHook] CAPABILITY ERROR while: " .. seam .. "   (rage status: "
                      .. tostring(State.RageStatus) .. ")")
            end
            if not killed then
                killed = true
                State.CapabilityKilledAt = tostring(State.RageStatus)
                State.CapabilityDirty = true
            end
        end)
        State.CapabilityObserver = true
    end)
    return function()
        if latched == nil then
            latched = (Config.RageIdentityDance == true)
            State.IdentitySafe = latched
        end
        return latched
    end
end)()
local SANE_POS_LIMIT = 100000
local function isSanePos(p)
    return p == p
        and math.abs(p.X) < SANE_POS_LIMIT
        and math.abs(p.Y) < SANE_POS_LIMIT
        and math.abs(p.Z) < SANE_POS_LIMIT
end
local VFR_LIM, VFR_DEAD = 2147483646, 1147483646
local function rndSkip()
    local v
    repeat v = math.random(-VFR_LIM, VFR_LIM) until v < -VFR_DEAD or v > VFR_DEAD
    return v
end
local function voidShellVec()
    return Vector3.new(rndSkip(), rndSkip(), rndSkip())
end
local function posInPart(pos, part)
    if not part or not part.Parent then return false end
    local lpv = part.CFrame:PointToObjectSpace(pos)
    local s = part.Size * 0.5
    return math.abs(lpv.X) <= s.X and math.abs(lpv.Y) <= s.Y and math.abs(lpv.Z) <= s.Z
end
local function posIsOOB(pos)
    local ok, result = pcall(function()
        for _, p in ipairs(CollectionService:GetTagged("OutOfBoundsSafePart")) do
            if posInPart(pos, p) then return false end
        end
        for _, p in ipairs(CollectionService:GetTagged("OutOfBoundsPart")) do
            if posInPart(pos, p) then return true end
        end
        return false
    end)
    return ok and result == true
end
local function clampHop(targetPos, fromPos, maxHop)
    local d = targetPos - fromPos
    local m = d.Magnitude
    if m <= maxHop or m == 0 then return targetPos end
    return fromPos + d * (maxHop / m)
end
local function getHealth(player)
    if not player.Character then return 0, 100 end
    local h = player.Character:FindFirstChildOfClass("Humanoid")
    if not h then return 0, 100 end
    return h.Health, h.MaxHealth
end
local HP_RAMP_STOPS = {
    { 0.00, Color3.fromRGB(255,  68,  54) },
    { 0.20, Color3.fromRGB(255, 122,  61) },
    { 0.40, Color3.fromRGB(255, 194,  75) },
    { 0.60, Color3.fromRGB(196, 226,  78) },
    { 1.00, Color3.fromRGB( 61, 224, 122) },
}
local function hpRamp(frac)
    frac = math.clamp(frac or 0, 0, 1)
    for i = 1, #HP_RAMP_STOPS - 1 do
        local a, b = HP_RAMP_STOPS[i], HP_RAMP_STOPS[i + 1]
        if frac <= b[1] then
            local span = b[1] - a[1]
            local t = span > 0 and (frac - a[1]) / span or 0
            return a[2]:Lerp(b[2], math.clamp(t, 0, 1))
        end
    end
    return HP_RAMP_STOPS[#HP_RAMP_STOPS][2]
end
local function getWeaponName(player)
    if not player or not player.Character then return "?" end
    local ok, res = pcall(function()
        if Rivals.Ready and Rivals.Fighter and Rivals.Fighter._player_to_fighter then
            local f = Rivals.Fighter._player_to_fighter[player]
            if f and f.EquippedItem and f.EquippedItem.Info then
                return f.EquippedItem.Info.Name
            end
        end
        return nil
    end)
    if ok and type(res) == "string" and res ~= "" then return res end
    local ok2, fallback = pcall(function()
        for _, c in ipairs(player.Character:GetChildren()) do
            if c:IsA("Model") and not c:FindFirstChildOfClass("Humanoid") then
                if c.PrimaryPart or c:FindFirstChildWhichIsA("BasePart") then
                    return c.Name
                end
            end
            if c:IsA("Tool") then return c.Name end
        end
        return "?"
    end)
    return (ok2 and type(fallback) == "string") and fallback or "?"
end
local function pickPart(char, mode)
    if not char then return nil end
    if mode == "Closest" then
        local best, bestDist = nil, math.huge
        local vp     = Camera.ViewportSize
        local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
        for _, name in ipairs(CLOSEST_PARTS) do
            local p = char:FindFirstChild(name)
            if p and p:IsA("BasePart") then
                local sp, on = Camera:WorldToViewportPoint(p.Position)
                if on and sp.Z > 0 then
                    local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if d < bestDist then best, bestDist = p, d end
                end
            end
        end
        if best then return best end
    end
    local list = mode == "Torso" and TORSO_PARTS or HEAD_PARTS
    for _, name in ipairs(list) do
        local p = char:FindFirstChild(name)
        if p and p:IsA("BasePart") then return p end
    end
    return char:FindFirstChild("HumanoidRootPart")
end
local visParams = RaycastParams.new()
visParams.FilterType = Enum.RaycastFilterType.Exclude
local _visFilterChar = nil
local function isVisible(worldPos)
    local origin = Camera.CFrame.Position
    local _vc = lp.Character
    if _vc ~= _visFilterChar then
        visParams.FilterDescendantsInstances = { _vc }
        _visFilterChar = _vc
    end
    local result = Workspace:Raycast(origin, worldPos - origin, visParams)
    if not result then return true end
    local hitModel = result.Instance and result.Instance:FindFirstAncestorOfClass("Model")
    if hitModel and Players:GetPlayerFromCharacter(hitModel) then return true end
    return (result.Position - worldPos).Magnitude < 3
end
local DEFLECT_ANIM_IDS = {
    ["14761240825"] = true, ["14761220206"] = true,
    ["14761234917"] = true, ["14761221711"] = true, ["14761223422"] = true, ["14761225204"] = true, ["14761232380"] = true,
    ["90436105114997"] = true, ["90797895557136"] = true, ["77995180947430"] = true, ["111943779640553"] = true,
    ["131072510521727"] = true, ["132022220827223"] = true, ["116315405171252"] = true, ["110358509711635"] = true, ["98242486936084"] = true, ["81132288854196"] = true,
    ["123293403148826"] = true, ["136354716301184"] = true, ["120567011479119"] = true, ["92502373956550"] = true, ["83541611040586"] = true, ["92773106977434"] = true,
    ["75844592081515"] = true, ["75381142568185"] = true,
}
local function isDeflectingAnim(player)
    if not player or not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return false end
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        if track.Name:lower():find("deflect") then return true end
        local anim = track.Animation
        local id = anim and anim.AnimationId
        if id then
            local num = id:match("(%d+)")
            if num and DEFLECT_ANIM_IDS[num] then return true end
        end
    end
    return false
end
local _deflecting = {}
local _deflGen    = {}
local _deflHookLive = false
local DEFLECT_CLEAR_PAD = 0.05
local function isDeflecting(player)
    if not player then return false end
    if _deflecting[player.UserId] then return true end
    if _deflHookLive then return false end
    return isDeflectingAnim(player)
end
;(function()
    local function recordDeflect(self)
        local fighter = self and self.ClientFighter
        local plr = fighter and fighter.Player
        if not plr then return end
        local uid = plr.UserId
        local dur = self.Info and self.Info.DeflectDuration
        if type(dur) ~= "number" then dur = 0.1 end
        _deflecting[uid] = true
        local gen = (_deflGen[uid] or 0) + 1
        _deflGen[uid] = gen
        task.delay(dur + DEFLECT_CLEAR_PAD, function()
            if _deflGen[uid] == gen then
                _deflecting[uid] = nil
            end
        end)
    end
    task.spawn(function()
        local ok, katana = pcall(loadGameModule, lp.PlayerScripts, {"Modules", "Items", "Katana"})
        if not ok or type(katana) ~= "table" or type(katana._StartDeflecting) ~= "function" then
            return
        end
        local orig = shared._LH_KatanaDeflOrig
        if not orig then orig = clonefunction(katana._StartDeflecting) end
        shared._LH_KatanaMod     = katana
        shared._LH_KatanaDeflOrig = orig
        if setreadonly then pcall(setreadonly, katana, false) end
        katana._StartDeflecting = function(self, ...)
            pcall(recordDeflect, self)
            return orig(self, ...)
        end
        _deflHookLive = true
    end)
end)()
local _invincible = {}
local _invincEnt  = {}
local function isSpawnProtected(player)
    if not player then return false end
    if not (Rivals.Ready and Rivals.Fighter) then return false end
    local map = Rivals.Fighter._player_to_fighter
    if not map then return false end
    local f = map[player]
    if not f then return false end
    local e = f.Entity
    if not e then return false end
    local uid = player.UserId
    if _invincEnt[uid] ~= e then
        _invincible[uid] = nil
        local ok = pcall(function()
            local live = e:Get("IsInvincible") == true
            e:GetDataChangedSignal("IsInvincible"):Connect(function()
                _invincible[uid] = e:Get("IsInvincible") == true
            end)
            _invincible[uid] = live
        end)
        if ok then _invincEnt[uid] = e end
    end
    local okLive, live = pcall(function() return e:Get("IsInvincible") == true end)
    if okLive then
        if live ~= (_invincible[uid] == true) then
            State.RageImmuneStale = (State.RageImmuneStale or 0) + 1
        end
        _invincible[uid] = live
        return live
    end
    return _invincible[uid] == true
end
local function isRiotShield(player)
    local w = getWeaponName(player):lower()
    return w:find("riot shield") or w:find("energy shield") or w:find("tombstone shield")
        or w:find("broken surfboard", 1, true) or w == "door" or w == "sled" or w == "masterpiece"
end
local function ownsRiotShield(player)
    if not player then return false end
    local ok, res = pcall(function()
        if not (Rivals.Ready and Rivals.Fighter and Rivals.Fighter._player_to_fighter) then return false end
        local f = Rivals.Fighter._player_to_fighter[player]
        local items = f and f.Items
        if type(items) ~= "table" then return false end
        for _, it in items do
            local n = nil
            if type(it) == "table" then
                n = it.Name
                if n == nil and it.Info then n = it.Info.Name end
            end
            if type(n) == "string" then
                local low = n:lower()
                if low:find("riot shield") or low:find("energy shield") or low:find("tombstone shield") then
                    return true
                end
            end
        end
        return false
    end)
    return ok and res == true
end
local KATANA_NAMES = { "katana", "saber", "lightning bolt", "evil trident", "tridant", "devil's trident", "linked sword", "keytana", "cutlass", "swordfish", "riptide" }
local function isKatana(player)
    local w = getWeaponName(player):lower()
    for _, n in ipairs(KATANA_NAMES) do
        if w:find(n, 1, true) then return true end
    end
    return isDeflecting(player)
end
local function isLocalKnife()
    local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
    if lf and lf.EquippedItem then
        local name = lf.EquippedItem.Name:lower()
        if name:find("knife") or name:find("karambit") or name:find("balisong") or name:find("chancla") or name:find("machete") or name:find("candy cane") or name:find("armature") or name:find("daggers") or name:find("axe") then
            return true
        end
    end
    return false
end
local KNIFE_NAMES = { "knife", "karambit", "balisong", "chancla", "machete", "candy cane", "armature", "daggers", "axe" }
local function isEnemyKnife(player)
    if not player then return false end
    local w = getWeaponName(player):lower()
    for _, n in ipairs(KNIFE_NAMES) do
        if w:find(n, 1, true) then return true end
    end
    return false
end
local function inMatch()
    local envOk = false
    pcall(function()
        local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
        if lf ~= nil and lf:Get("EnvironmentID") ~= nil and lf:IsAlive() then envOk = true end
    end)
    if envOk then return true end
    if lp:GetAttribute("TeamID") ~= nil then return true end
    if lp.Team ~= nil then return true end
    local lf = Rivals.Ready and Rivals.Fighter and Rivals.Fighter.LocalFighter
    if lf then
        local ok, objId = pcall(function() return lf.EquippedItem and lf.EquippedItem:Get("ObjectID") end)
        if ok and objId then return true end
    end
    return false
end
local function isFfaMode()
    local ok, res = pcall(function()
        local wsMode = workspace:GetAttribute("ArcadeMode")
        if wsMode == "arc_freeforall" or wsMode == "Free For All" then return true end
        local duel = Rivals and Rivals.ClientDuel
        if duel and type(duel.Get) == "function" then
            local mode = duel:Get("ArcadeMode")
            if mode == "arc_freeforall" or mode == "Free For All" then return true end
        end
        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name == "_drop" and child:IsA("BasePart") then
                return true
            end
        end
        return false
    end)
    return ok and res == true
end
local function isValidTarget(player, checkVis, keepDeflect, rageScope)
    if not player or player == lp then return false end
    if Config.TeamCheck and isTeammate(player) then return false end
    if not isAlive(player) then return false end
    if Config.AvoidDeflect and not keepDeflect and isDeflecting(player) then return false end
    if Config.RageSkipImmune and not rageScope and isSpawnProtected(player) then return false end
    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local sane = isSanePos(hrp.Position)
    if not rageScope then
        if not sane then return false end
        local myChar = lp.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if myRoot and (hrp.Position - myRoot.Position).Magnitude > Config.MaxDistance then return false end
    end
    if checkVis and sane and not isVisible(hrp.Position) then return false end
    return true
end
local _sharedVelMap = {}
do
    local _svPos, _svTime = {}, {}
    local _svAccum = 0
    local SV_INTERVAL = 1 / 30
    local function velTrackerStep(dt)
        if not (Config.Aimbot or Config.SilentAim or Config.Rage) then return end
        _svAccum = _svAccum + (dt or 0)
        if _svAccum < SV_INTERVAL then return end
        _svAccum = 0
        local now = tick()
        for _, p in ipairs(getSafePlayers() or {}) do
            if p ~= lp and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos = hrp.Position
                    local lt  = _svTime[p]
                    if _svPos[p] and lt then
                        local d = now - lt
                        if d > 0 then
                            local v = (pos - _svPos[p]) / d
                            if v.Magnitude < 500 then _sharedVelMap[p] = v end
                        end
                    end
                    _svPos[p]  = pos
                    _svTime[p] = now
                end
            end
        end
    end
    if shared._LH_velConn then pcall(function() shared._LH_velConn:Disconnect() end) end
    shared._LH_velConn = RunService.Heartbeat:Connect(velTrackerStep)
end
local function calculateLead(targetChar, fromPos, wantLead)
    if wantLead == nil then wantLead = Config.PredictiveLead end
    if not targetChar then return Vector3.new() end
    local hum = targetChar:FindFirstChildOfClass("Humanoid")
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return Vector3.new() end
    local lat = (lp:GetNetworkPing() or 0.05) + ((Config.ServerProcessingMs or 30) / 1000)
    if Config.ProjectileLead and (Config.ProjectileSpeed or 0) > 0 then
        lat = lat + (hrp.Position - fromPos).Magnitude / Config.ProjectileSpeed
    end
    local lead = Vector3.new()
    if wantLead then
        local ply     = Players:GetPlayerFromCharacter(targetChar)
        local trueVel = hrp.AssemblyLinearVelocity
        local calcVel = ply and (_sharedVelMap[ply] or State.RageTrueVelocityMap[ply])
        if calcVel then
            if (trueVel - calcVel).Magnitude > 25 then trueVel = calcVel end
        else
            if trueVel.Magnitude > 100 then trueVel = Vector3.new() end
        end
        if trueVel.Magnitude > 120 then trueVel = Vector3.new() end
        local md = hum.MoveDirection
        if md.Magnitude > 0.1 then
            lead = lead + Vector3.new(trueVel.X, 0, trueVel.Z) * lat
        end
        lead = lead + Vector3.new(0, trueVel.Y * lat, 0)
    end
    local cap = Config.LeadCap or 15
    if lead.Magnitude > cap then lead = lead.Unit * cap end
    return lead
end
local function selectTarget(opts)
    opts = opts or {}
    local fov         = opts.fov or 90
    local checkVis    = opts.checkVis or false
    local mode        = opts.partMode or "Head"
    local sticky      = opts.stickyTarget
    local stickyBonus = opts.stickyBonus or 0
    local vp     = Camera.ViewportSize
    local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    local best, bestPart, bestScore = nil, nil, math.huge
    for _, player in ipairs(getSafePlayers()) do
        if player ~= lp and isValidTarget(player, false) then
            local char = player.Character
            local part = pickPart(char, mode)
            if part and (not checkVis or isVisible(part.Position)) then
                local sp, on = Camera:WorldToViewportPoint(part.Position)
                if on and sp.Z > 0 then
                    local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if d <= fov then
                        local score = d
                        if player == sticky then score = score * (1 - stickyBonus) end
                        if score < bestScore then bestScore, best, bestPart = score, player, part end
                    end
                end
            end
        end
    end
    return best, bestPart
end
local function aimbotKeyDown()
    return isInputActive(Config.AimbotKey)
end
local Visuals = {}
;(function()
    local _origLighting, _origClones = nil, {}
    local _hologramFolder, _hologramCooldowns = nil, {}
    local _stretchBound, _rainbowConn = false, nil
    local _rainbowParts, _rainbowHue, _rainbowBatchIdx = {}, 0, 1
    local _perfBackup, _origParticleRates = nil, {}
    local _reassertConn, _reassertLastT = nil, 0
    local LIGHTING_PROPS = {
        "Brightness","ExposureCompensation","GlobalShadows","ShadowSoftness",
        "EnvironmentDiffuseScale","EnvironmentSpecularScale","ClockTime",
        "OutdoorAmbient","Ambient","FogEnd","FogStart","FogColor",
        "ColorShift_Top","ColorShift_Bottom",
    }
    local function snapshotLighting()
        if _origLighting then return end
        _origLighting = {}
        for _, p in ipairs(LIGHTING_PROPS) do
            local ok, v = pcall(function() return Lighting[p] end)
            if ok then _origLighting[p] = v end
        end
        for _, c in ipairs(Lighting:GetChildren()) do
            if not c:GetAttribute("VS_Custom") then
                local ok, clone = pcall(function() return c:Clone() end)
                if ok and clone then table.insert(_origClones, clone) end
            end
        end
    end
    local function clearTagged()
        for _, c in ipairs(Lighting:GetChildren()) do
            if c:GetAttribute("VS_Custom") then c:Destroy() end
        end
    end
    local function restore()
        if not _origLighting then return end
        clearTagged()
        for k, v in pairs(_origLighting) do pcall(function() Lighting[k] = v end) end
        local exist = {}
        for _, c in ipairs(Lighting:GetChildren()) do exist[c.Name] = true end
        for _, clone in ipairs(_origClones) do
            if not exist[clone.Name] then clone:Clone().Parent = Lighting end
        end
    end
    local function fx(cls, props)
        local f = Instance.new(cls)
        f:SetAttribute("VS_Custom", true)
        for k, v in pairs(props) do f[k] = v end
        f.Parent = Lighting
        return f
    end
    local Presets = {}
    Presets.Neutral = function()
        clearTagged()
        Lighting.Brightness = 2; Lighting.ExposureCompensation = 0
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.2
        Lighting.EnvironmentDiffuseScale = 0.5; Lighting.EnvironmentSpecularScale = 0.5
        Lighting.ClockTime = 14; Lighting.OutdoorAmbient = Color3.fromRGB(70,70,70)
        Lighting.Ambient = Color3.fromRGB(0,0,0); Lighting.FogEnd = 100000
        fx("Atmosphere", { Density=0.3, Offset=0.25, Color=Color3.fromRGB(199,199,199),
            Decay=Color3.fromRGB(106,112,125), Glare=0, Haze=0 })
    end
    Presets.Cyberpunk = function()
        clearTagged()
        Lighting.Brightness = 2.6; Lighting.ExposureCompensation = 0.5
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.7
        Lighting.EnvironmentDiffuseScale = 0.7; Lighting.EnvironmentSpecularScale = 1
        Lighting.ClockTime = 0; Lighting.OutdoorAmbient = Color3.fromRGB(120,80,165)
        Lighting.Ambient = Color3.fromRGB(80,55,120)
        fx("Atmosphere", { Density=0.3, Offset=0.3, Color=Color3.fromRGB(160,70,215),
            Decay=Color3.fromRGB(75,200,240), Glare=2.2, Haze=1 })
        fx("BloomEffect", { Intensity=1.15, Size=24, Threshold=0.72 })
        fx("ColorCorrectionEffect", { Brightness=0.04, Contrast=0.2, Saturation=0.45,
            TintColor=Color3.fromRGB(220,195,255) })
    end
    Presets.Anime = function()
        clearTagged()
        Lighting.Brightness = 2.3; Lighting.ExposureCompensation = 0.2
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.7
        Lighting.EnvironmentDiffuseScale = 0.7; Lighting.EnvironmentSpecularScale = 0.7
        Lighting.ClockTime = 15; Lighting.OutdoorAmbient = Color3.fromRGB(150,140,170)
        Lighting.Ambient = Color3.fromRGB(95,85,120)
        fx("Atmosphere", { Density=0.28, Offset=0.35, Color=Color3.fromRGB(255,200,230),
            Decay=Color3.fromRGB(150,195,255), Glare=1, Haze=0.8 })
        fx("BloomEffect", { Intensity=1.0, Size=26, Threshold=0.8 })
        fx("ColorCorrectionEffect", { Brightness=0.03, Contrast=0.14, Saturation=0.32,
            TintColor=Color3.fromRGB(255,228,242) })
    end
    Presets.Sunset = function()
        clearTagged()
        Lighting.Brightness = 2.3; Lighting.ExposureCompensation = 0.4
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.5
        Lighting.EnvironmentDiffuseScale = 0.75; Lighting.EnvironmentSpecularScale = 0.9
        Lighting.ClockTime = 17.75; Lighting.OutdoorAmbient = Color3.fromRGB(185,115,80)
        Lighting.Ambient = Color3.fromRGB(105,60,45)
        fx("Atmosphere", { Density=0.38, Offset=0.55, Color=Color3.fromRGB(255,150,80),
            Decay=Color3.fromRGB(255,105,60), Glare=1.8, Haze=1.6 })
        fx("BloomEffect", { Intensity=0.9, Size=24, Threshold=0.78 })
        fx("ColorCorrectionEffect", { Brightness=0.03, Contrast=0.16, Saturation=0.32,
            TintColor=Color3.fromRGB(255,195,150) })
    end
    Presets.Vaporwave = function()
        clearTagged()
        Lighting.Brightness = 2.3; Lighting.ExposureCompensation = 0.4
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.7
        Lighting.EnvironmentDiffuseScale = 0.6; Lighting.EnvironmentSpecularScale = 0.9
        Lighting.ClockTime = 18.4; Lighting.OutdoorAmbient = Color3.fromRGB(150,90,165)
        Lighting.Ambient = Color3.fromRGB(95,60,120)
        fx("Atmosphere", { Density=0.34, Offset=0.4, Color=Color3.fromRGB(255,130,205),
            Decay=Color3.fromRGB(110,200,255), Glare=1.8, Haze=1.3 })
        fx("BloomEffect", { Intensity=1.05, Size=26, Threshold=0.74 })
        fx("ColorCorrectionEffect", { Brightness=0.04, Contrast=0.18, Saturation=0.38,
            TintColor=Color3.fromRGB(255,205,240) })
    end
    Presets.Void = function()
        clearTagged()
        Lighting.Brightness = 2.0; Lighting.ExposureCompensation = 0.25
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.9
        Lighting.EnvironmentDiffuseScale = 0.5; Lighting.EnvironmentSpecularScale = 0.7
        Lighting.ClockTime = 0; Lighting.OutdoorAmbient = Color3.fromRGB(85,95,135)
        Lighting.Ambient = Color3.fromRGB(55,62,95)
        fx("Atmosphere", { Density=0.35, Offset=0.2, Color=Color3.fromRGB(55,65,110),
            Decay=Color3.fromRGB(95,110,180), Glare=0.3, Haze=0.8 })
        fx("BloomEffect", { Intensity=0.8, Size=22, Threshold=0.76 })
        fx("ColorCorrectionEffect", { Brightness=0.03, Contrast=0.16, Saturation=-0.2,
            TintColor=Color3.fromRGB(190,200,255) })
    end
    Presets.Clarity = function()
        clearTagged()
        Lighting.Brightness = 2.6; Lighting.ExposureCompensation = 0
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 1
        Lighting.EnvironmentDiffuseScale = 0.2; Lighting.EnvironmentSpecularScale = 0.1
        Lighting.ClockTime = 14; Lighting.OutdoorAmbient = Color3.fromRGB(150,150,155)
        Lighting.Ambient = Color3.fromRGB(120,120,125); Lighting.FogEnd = 1000000
        fx("ColorCorrectionEffect", { Brightness=0.05, Contrast=0.25, Saturation=-0.2,
            TintColor=Color3.fromRGB(255,255,255) })
    end
    Presets.Toxic = function()
        clearTagged()
        Lighting.Brightness = 2.2; Lighting.ExposureCompensation = 0.35
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.7
        Lighting.EnvironmentDiffuseScale = 0.6; Lighting.EnvironmentSpecularScale = 0.8
        Lighting.ClockTime = 1; Lighting.OutdoorAmbient = Color3.fromRGB(80,135,70)
        Lighting.Ambient = Color3.fromRGB(45,85,50)
        fx("Atmosphere", { Density=0.34, Offset=0.35, Color=Color3.fromRGB(95,220,110),
            Decay=Color3.fromRGB(55,180,80), Glare=1.8, Haze=1.4 })
        fx("BloomEffect", { Intensity=1.1, Size=24, Threshold=0.74 })
        fx("ColorCorrectionEffect", { Brightness=0.04, Contrast=0.2, Saturation=0.45,
            TintColor=Color3.fromRGB(210,255,205) })
    end
    Presets.Sakura = function()
        clearTagged()
        Lighting.Brightness = 2.2; Lighting.ExposureCompensation = 0.35
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.8
        Lighting.EnvironmentDiffuseScale = 0.7; Lighting.EnvironmentSpecularScale = 0.7
        Lighting.ClockTime = 15.5; Lighting.OutdoorAmbient = Color3.fromRGB(200,155,180)
        Lighting.Ambient = Color3.fromRGB(120,85,110)
        fx("Atmosphere", { Density=0.3, Offset=0.4, Color=Color3.fromRGB(255,205,225),
            Decay=Color3.fromRGB(255,175,215), Glare=1.2, Haze=1 })
        fx("BloomEffect", { Intensity=1.1, Size=26, Threshold=0.78 })
        fx("ColorCorrectionEffect", { Brightness=0.04, Contrast=0.15, Saturation=0.28,
            TintColor=Color3.fromRGB(255,225,240) })
    end
    Presets.Nebula = function()
        clearTagged()
        Lighting.Brightness = 2.2; Lighting.ExposureCompensation = 0.4
        Lighting.GlobalShadows = false; Lighting.ShadowSoftness = 0.9
        Lighting.EnvironmentDiffuseScale = 0.55; Lighting.EnvironmentSpecularScale = 0.85
        Lighting.ClockTime = 0; Lighting.OutdoorAmbient = Color3.fromRGB(128,94,168)
        Lighting.Ambient = Color3.fromRGB(82,60,120)
        fx("Atmosphere", { Density=0.34, Offset=0.25, Color=Color3.fromRGB(120,70,180),
            Decay=Color3.fromRGB(220,90,190), Glare=1.4, Haze=1.1 })
        fx("BloomEffect", { Intensity=1.15, Size=24, Threshold=0.72 })
        fx("ColorCorrectionEffect", { Brightness=0.03, Contrast=0.2, Saturation=0.4,
            TintColor=Color3.fromRGB(235,205,255) })
    end
    local PresetScalars = {
        Neutral   = { Brightness=2,   ExposureCompensation=0,    ClockTime=14,   OutdoorAmbient=Color3.fromRGB(70,70,70),
                      Ambient=Color3.fromRGB(0,0,0),      FogEnd=100000,
                      EnvironmentDiffuseScale=0.5,  EnvironmentSpecularScale=0.5 },
        Clarity   = { Brightness=2.6, ExposureCompensation=0,    ClockTime=14,   OutdoorAmbient=Color3.fromRGB(150,150,155),
                      Ambient=Color3.fromRGB(120,120,125), FogEnd=1000000,
                      EnvironmentDiffuseScale=0.2,  EnvironmentSpecularScale=0.1 },
        Cyberpunk = { Brightness=2.6, ExposureCompensation=0.5,  ClockTime=0,    OutdoorAmbient=Color3.fromRGB(120,80,165),
                      Ambient=Color3.fromRGB(80,55,120),
                      EnvironmentDiffuseScale=0.7,  EnvironmentSpecularScale=1 },
        Anime     = { Brightness=2.3, ExposureCompensation=0.2,  ClockTime=15,   OutdoorAmbient=Color3.fromRGB(150,140,170),
                      Ambient=Color3.fromRGB(95,85,120),
                      EnvironmentDiffuseScale=0.7,  EnvironmentSpecularScale=0.7 },
        Sunset    = { Brightness=2.3, ExposureCompensation=0.4,  ClockTime=17.75, OutdoorAmbient=Color3.fromRGB(185,115,80),
                      Ambient=Color3.fromRGB(105,60,45),
                      EnvironmentDiffuseScale=0.75, EnvironmentSpecularScale=0.9 },
        Vaporwave = { Brightness=2.3, ExposureCompensation=0.4,  ClockTime=18.4, OutdoorAmbient=Color3.fromRGB(150,90,165),
                      Ambient=Color3.fromRGB(95,60,120),
                      EnvironmentDiffuseScale=0.6,  EnvironmentSpecularScale=0.9 },
        Toxic     = { Brightness=2.2, ExposureCompensation=0.35, ClockTime=1,    OutdoorAmbient=Color3.fromRGB(80,135,70),
                      Ambient=Color3.fromRGB(45,85,50),
                      EnvironmentDiffuseScale=0.6,  EnvironmentSpecularScale=0.8 },
        Void      = { Brightness=2.0, ExposureCompensation=0.25, ClockTime=0,    OutdoorAmbient=Color3.fromRGB(85,95,135),
                      Ambient=Color3.fromRGB(55,62,95),
                      EnvironmentDiffuseScale=0.5,  EnvironmentSpecularScale=0.7 },
        Sakura    = { Brightness=2.2, ExposureCompensation=0.35, ClockTime=15.5, OutdoorAmbient=Color3.fromRGB(200,155,180),
                      Ambient=Color3.fromRGB(120,85,110),
                      EnvironmentDiffuseScale=0.7,  EnvironmentSpecularScale=0.7 },
        Nebula    = { Brightness=2.2, ExposureCompensation=0.4,  ClockTime=0,    OutdoorAmbient=Color3.fromRGB(128,94,168),
                      Ambient=Color3.fromRGB(82,60,120),
                      EnvironmentDiffuseScale=0.55, EnvironmentSpecularScale=0.85 },
    }
    local _WHITE = Color3.new(1, 1, 1)
    local function applyFullbrightOverride()
        if not Config.VisualsFullbright then return end
        pcall(function() if Lighting.Ambient ~= _WHITE then Lighting.Ambient = _WHITE end end)
        pcall(function() if Lighting.OutdoorAmbient ~= _WHITE then Lighting.OutdoorAmbient = _WHITE end end)
        pcall(function() if Lighting.GlobalShadows ~= false then Lighting.GlobalShadows = false end end)
        pcall(function() if Lighting.Brightness < 2 then Lighting.Brightness = 2 end end)
    end
    local function applyFogOverride()
        if not Config.VisualsNoFog then return end
        pcall(function() if Lighting.FogEnd ~= 1e6 then Lighting.FogEnd = 1e6 end end)
        pcall(function() if Lighting.FogStart ~= 1e6 then Lighting.FogStart = 1e6 end end)
        for _, c in ipairs(Lighting:GetChildren()) do
            if c:IsA("Atmosphere") then
                pcall(function() if c.Density ~= 0 then c.Density = 0 end end)
            end
        end
    end
    local function cfg(key, default)
        local v = Config[key]
        if v == nil then return default end
        return v
    end
    local _GRADES = {
        Crisp = { B = 0.03,  C = 0.20, S = 0.18,  tint = _WHITE },
        Cold  = { B = -0.03, C = 0.28, S = -0.22, tint = Color3.fromRGB(196, 220, 255) },
        Warm  = { B = 0.04,  C = 0.22, S = 0.15,  tint = Color3.fromRGB(255, 222, 180) },
        Comp  = { B = -0.01, C = 0.40, S = 0.28,  tint = Color3.fromRGB(255, 248, 236) },
    }
    local _gradeFx = nil
    local function getGradeFx()
        if _gradeFx and _gradeFx.Parent then return _gradeFx end
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "_vs_grade"
        cc:SetAttribute("VS_Grade", true)
        cc.Parent = Lighting
        _gradeFx = cc
        return cc
    end
    local function reassertGrade()
        local g = _GRADES[cfg("VisualsGrade", "None")]
        if not g then
            if _gradeFx and _gradeFx.Parent then
                pcall(function() if _gradeFx.Enabled then _gradeFx.Enabled = false end end)
            end
            return
        end
        local s  = math.clamp(cfg("VisualsGradeStrength", 1), 0, 1)
        local tB, tC, tS = g.B * s, g.C * s, g.S * s
        local tT = g.tint:Lerp(_WHITE, 1 - s)
        local cc = getGradeFx()
        pcall(function()
            if not cc.Enabled then cc.Enabled = true end
            if math.abs(cc.Brightness - tB) > 0.001 then cc.Brightness = tB end
            if math.abs(cc.Contrast   - tC) > 0.001 then cc.Contrast   = tC end
            if math.abs(cc.Saturation - tS) > 0.001 then cc.Saturation = tS end
            if cc.TintColor ~= tT then cc.TintColor = tT end
        end)
    end
    local function clearGrade()
        if _gradeFx then pcall(function() _gradeFx:Destroy() end); _gradeFx = nil end
    end
    local _bloomFx = nil
    local function getBloomFx()
        if _bloomFx and _bloomFx.Parent then return _bloomFx end
        local b = Instance.new("BloomEffect")
        b.Name = "_vs_bloom"; b:SetAttribute("VS_Bloom", true)
        b.Size = 24; b.Threshold = 0.8; b.Intensity = 0
        b.Parent = Lighting
        _bloomFx = b
        return b
    end
    local function reassertBloom()
        if not cfg("VisualsBloom", false) then
            if _bloomFx and _bloomFx.Parent then
                pcall(function() if _bloomFx.Enabled then _bloomFx.Enabled = false end end)
            end
            return
        end
        local tI = math.clamp(cfg("VisualsBloomIntensity", 1), 0, 3)
        local b = getBloomFx()
        pcall(function()
            if not b.Enabled then b.Enabled = true end
            if math.abs(b.Intensity - tI) > 0.01 then b.Intensity = tI end
        end)
    end
    local function clearBloom()
        if _bloomFx then pcall(function() _bloomFx:Destroy() end); _bloomFx = nil end
    end
    local function reassertScalars()
        local sc = PresetScalars[State.VisualsCurrentPreset or Config.VisualsPreset]
        if sc then
            for k, v in pairs(sc) do pcall(function() if Lighting[k] ~= v then Lighting[k] = v end end) end
            pcall(function() if Lighting.GlobalShadows ~= false then Lighting.GlobalShadows = false end end)
        end
        applyFullbrightOverride()
        applyFogOverride()
        reassertGrade()
        reassertBloom()
    end
    local function startReassert()
        if _reassertConn then return end
        _reassertConn = RunService.Heartbeat:Connect(function()
            if not Config.Visuals or Config.VisualsPerformanceMode then return end
            local now = tick()
            if (now - _reassertLastT) < 1.0 then return end
            _reassertLastT = now
            reassertScalars()
        end)
    end
    local function stopReassert()
        if _reassertConn then _reassertConn:Disconnect(); _reassertConn = nil end
    end
    Visuals.PresetOrder = { "Neutral", "Clarity", "Cyberpunk", "Anime", "Sunset", "Vaporwave", "Toxic", "Void", "Sakura", "Nebula" }
    local function applyPreset(name)
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        local fn = Presets[name]; if not fn then return end
        pcall(fn); State.VisualsCurrentPreset = name; Config.VisualsPreset = name
        reassertGrade()
        reassertBloom()
    end
    local function getHoloFolder()
        if _hologramFolder and _hologramFolder.Parent then return _hologramFolder end
        local f = Instance.new("Folder"); f.Name = "_vs_holos"; f.Parent = Workspace
        _hologramFolder = f; return f
    end
    local _GOLD = Color3.fromRGB(255, 200, 60)
    local _EDGE    = Color3.fromRGB(155, 232, 255)
    local _VISIBLE = Color3.fromRGB(41, 224, 255)
    local function easeInOut(a) return a * a * (3 - 2 * a) end
    local HOLO_SKEL_R15 = {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    }
    local HOLO_SKEL_R6 = {
        {"Head","Torso"},
        {"Torso","Left Arm"},{"Torso","Right Arm"},
        {"Torso","Left Leg"},{"Torso","Right Leg"},
    }
    local function fadePop(container, parts, hl, dur, tr0)
        tr0 = tr0 or 0.55
        local startT = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not container.Parent then if conn then conn:Disconnect() end return end
            local a  = math.clamp((tick() - startT) / dur, 0, 1)
            local e  = easeInOut(a)
            local tr = tr0 + (1 - tr0) * e
            for _, b in ipairs(parts) do b.Transparency = tr end
            if hl then hl.OutlineTransparency = e end
            if a >= 1 and conn then conn:Disconnect() end
        end)
        Debris:AddItem(container, dur + 0.2)
    end
    local function popSkeleton(char, dur, color)
        local vis = math.clamp(cfg("VisualsHologramVisibility", 1.4), 0.2, 2)
        local tr0 = math.clamp(1 - 0.45 * vis, 0, 0.91)
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local isR6 = (hum and hum.RigType == Enum.HumanoidRigType.R6) or (char:FindFirstChild("Torso") ~= nil)
        local rig  = isR6 and HOLO_SKEL_R6 or HOLO_SKEL_R15
        local model = Instance.new("Model")
        model.Name = "_hs" .. math.random(10000, 99999)
        local parts, n = {}, 0
        for _, pair in ipairs(rig) do
            local a, b = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
            if a and b then
                local ap, bp = a.Position, b.Position
                local len = (bp - ap).Magnitude
                if len > 0.05 and len < 20 then
                    local bone = Instance.new("Part")
                    bone.Shape = Enum.PartType.Cylinder
                    bone.Size = Vector3.new(len, 0.1 + 0.06 * vis, 0.1 + 0.06 * vis)
                    bone.Material = Enum.Material.Neon
                    bone.Color = color
                    bone.Transparency = tr0
                    bone.Anchored = true; bone.CanCollide = false; bone.CanQuery = false
                    bone.CanTouch = false; bone.CastShadow = false; bone.Massless = true
                    bone:SetAttribute("VS_Holo", true)
                    bone.CFrame = CFrame.lookAt((ap + bp) * 0.5, bp) * CFrame.Angles(0, math.rad(90), 0)
                    bone.Parent = model
                    n = n + 1; parts[n] = bone
                end
            end
        end
        if n == 0 then model:Destroy(); return end
        model.Parent = getHoloFolder()
        fadePop(model, parts, nil, dur, tr0)
    end
    local _wraiths = {}
    local function wraithCount()
        local n = 0
        for i = #_wraiths, 1, -1 do
            local m = _wraiths[i]
            if m and m.Parent then n = n + 1 else table.remove(_wraiths, i) end
        end
        return n
    end
    local STRIP_CLASSES = {
        "Humanoid","Sound","ParticleEmitter","Trail","Beam","Fire","Smoke","Sparkles",
        "ForceField","Highlight","BillboardGui","SurfaceGui","BaseScript",
    }
    local function popWraith(char, dur, color)
        if wraithCount() >= 4 then return end
        local vis = math.clamp(cfg("VisualsHologramVisibility", 1.4), 0.2, 2)
        local tr0 = math.clamp(1 - 0.45 * vis, 0, 0.91)
        local clone
        pcall(function()
            local was = char.Archivable
            char.Archivable = true
            clone = char:Clone()
            char.Archivable = was
        end)
        if not clone then return end
        clone.Name = "_hw" .. math.random(10000, 99999)
        local parts, n = {}, 0
        for _, d in ipairs(clone:GetDescendants()) do
            local strip = false
            for _, cls in ipairs(STRIP_CLASSES) do
                if d:IsA(cls) then strip = true break end
            end
            if strip then
                pcall(function() d:Destroy() end)
            elseif d:IsA("BasePart") then
                d.Anchored = true; d.CanCollide = false; d.CanQuery = false
                d.CanTouch = false; d.CastShadow = false; d.Massless = true
                d:SetAttribute("VS_Holo", true)
                if d.Transparency < 0.98 then
                    d.Material = Enum.Material.ForceField
                    d.Color = color
                    d.Transparency = tr0
                    n = n + 1; parts[n] = d
                else
                    d.Transparency = 1
                end
            end
        end
        if n == 0 then clone:Destroy(); return end
        clone:SetAttribute("VS_Holo", true)
        clone.Parent = getHoloFolder()
        local hl
        pcall(function()
            local h = Instance.new("Highlight")
            h.FillTransparency = 1
            h.OutlineColor = _WHITE
            h.OutlineTransparency = 0
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Adornee = clone
            h.Parent = clone
            hl = h
        end)
        table.insert(_wraiths, clone)
        fadePop(clone, parts, hl, dur, tr0)
    end
    local function createHologram(character, lethal)
        if not character or not character.Parent then return end
        local rp = character:FindFirstChild("HitboxHead")
            or character:FindFirstChild("Head")
            or character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("UpperTorso")
        if not rp then return end
        if (rp.Position - Camera.CFrame.Position).Magnitude > Config.VisualsHologramRange then return end
        if #getHoloFolder():GetChildren() >= 16 then return end
        local dur = math.clamp(Config.VisualsHologramDuration or 3.5, 0.25, 10)
        local lethalOn  = lethal and cfg("VisualsHologramLethal", true)
        local mainColor = lethalOn and cfg("VisualsHologramLethalColor", _GOLD) or Config.VisualsHologramColor
        local style = cfg("VisualsHologramStyle", "Orb")
        if Config.VisualsPerformanceMode and style == "Wraith" then style = "Orb" end
        if style == "Skeleton" then popSkeleton(character, dur, mainColor); return end
        if style == "Wraith"   then popWraith(character, dur, mainColor);   return end
        local folder = getHoloFolder()
        local function mkBall(size, transp, color)
            local b = Instance.new("Part")
            b.Shape = Enum.PartType.Ball
            b.Size = Vector3.new(size, size, size)
            b.Material = Enum.Material.Neon
            b.Color = color
            b.Transparency = transp
            b.Anchored = true; b.CanCollide = false; b.CanQuery = false
            b.CanTouch = false; b.CastShadow = false; b.Massless = true
            b:SetAttribute("VS_Holo", true)
            return b
        end
        local vis = math.clamp(cfg("VisualsHologramVisibility", 1.4), 0.2, 2)
        local sc  = 0.75 + 0.25 * vis
        local h0  = math.clamp(0.65 / vis, 0.1, 0.9)
        local core = mkBall(0.7 * sc, 0.05, mainColor)
        local halo = mkBall(1.7 * sc, h0, mainColor)
        local startCF = CFrame.new(rp.Position)
        core.CFrame = startCF; halo.CFrame = startCF
        core.Name = "_h" .. math.random(10000, 99999); halo.Name = core.Name .. "_g"
        core.Parent = folder; halo.Parent = folder
        local shockColor = Config.VisualsHologramAccent or Config.VisualsHologramColor
        local shock = mkBall(0.5, 0.15, shockColor)
        shock.Shape = Enum.PartType.Cylinder
        shock.Size  = Vector3.new(0.1, 0.5, 0.5)
        do
            local cam = workspace.CurrentCamera
            if cam then shock.CFrame = CFrame.lookAt(rp.Position, cam.CFrame.Position) * CFrame.Angles(0, math.rad(90), 0)
            else shock.CFrame = startCF * CFrame.Angles(0, 0, math.rad(90)) end
        end
        shock.Name = core.Name .. "_s"
        shock.Parent = folder
        local startT = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not core.Parent then if conn then conn:Disconnect() end return end
            local alpha = math.clamp((tick() - startT) / dur, 0, 1)
            local rise  = 2.5 * (1 - (1 - alpha) * (1 - alpha))
            local cf    = startCF + Vector3.new(0, rise, 0)
            core.CFrame = cf; halo.CFrame = cf
            core.Transparency = math.clamp(0.05 + 0.95 * alpha, 0, 1)
            halo.Transparency = math.clamp(h0 + (1 - h0) * alpha, 0, 1)
            if shock.Parent then
                local sa = math.clamp((tick() - startT) / 0.3, 0, 1)
                local se = 1 - (1 - sa) * (1 - sa)
                local sd = 0.5 + 3.5 * se
                shock.Size = Vector3.new(0.1, sd, sd)
                shock.Transparency = math.clamp(0.15 + 0.85 * sa, 0, 1)
            end
            if alpha >= 1 and conn then conn:Disconnect() end
        end)
        Debris:AddItem(core, dur + 0.2)
        Debris:AddItem(halo, dur + 0.2)
        Debris:AddItem(shock, 0.5)
    end
    local _beamPool, _beamInit = {}, false
    local function buildBeamRig()
        local model = Instance.new("Model")
        model.Name = "_bt" .. math.random(10000, 99999)
        local function anchor()
            local pt = Instance.new("Part")
            pt.Size = Vector3.new(0.05, 0.05, 0.05)
            pt.Anchored = true; pt.CanCollide = false; pt.CanQuery = false
            pt.CanTouch = false; pt.CastShadow = false; pt.Massless = true
            pt.Transparency = 1
            pt:SetAttribute("VS_Holo", true)
            pt.Parent = model
            local at = Instance.new("Attachment"); at.Parent = pt
            return pt, at
        end
        local part0, a0 = anchor()
        local part1, a1 = anchor()
        local function mkBeam()
            local b = Instance.new("Beam")
            b.Attachment0 = a0; b.Attachment1 = a1
            b.FaceCamera = true; b.Segments = 1; b.Enabled = false
            b.Parent = part0
            return b
        end
        local core, glow, halo = mkBeam(), mkBeam(), mkBeam()
        local light = Instance.new("PointLight")
        light.Range = 12; light.Brightness = 0; light.Enabled = false
        light.Parent = part1
        local impact = Instance.new("Part")
        impact.Shape = Enum.PartType.Ball
        impact.Size = Vector3.new(0.2, 0.2, 0.2)
        impact.Material = Enum.Material.Neon
        impact.Transparency = 1
        impact.Anchored = true; impact.CanCollide = false; impact.CanQuery = false
        impact.CanTouch = false; impact.CastShadow = false; impact.Massless = true
        impact:SetAttribute("VS_Holo", true)
        impact.Parent = model
        model.Parent = getHoloFolder()
        return { model = model, part0 = part0, part1 = part1, core = core, glow = glow, halo = halo,
                 light = light, impact = impact, on = false, conn = nil, startT = 0 }
    end
    local function ensureBeamPool()
        if _beamInit then return end
        _beamInit = true
        for i = 1, 8 do _beamPool[i] = buildBeamRig() end
    end
    local function beamRamp(head, tail)
        return NumberSequence.new({
            NumberSequenceKeypoint.new(0, tail),
            NumberSequenceKeypoint.new(0.55, tail + (head - tail) * 0.65),
            NumberSequenceKeypoint.new(1, head),
        })
    end
    local function spawnBeamTracer(muzzlePos, hitPos)
        if not (muzzlePos and hitPos) then return end
        local dist = (hitPos - muzzlePos).Magnitude
        if dist < 0.5 then return end
        ensureBeamPool()
        local rig, oldest, oldT = nil, nil, math.huge
        for _, r in ipairs(_beamPool) do
            if not (r.model and r.model.Parent) then
                pcall(function() if r.model then r.model.Parent = getHoloFolder() end end)
            end
            if not r.on then rig = r break end
            if r.startT < oldT then oldest, oldT = r, r.startT end
        end
        rig = rig or oldest
        if not rig then return end
        if rig.conn then rig.conn:Disconnect(); rig.conn = nil end
        local dirU  = (hitPos - muzzlePos).Unit
        local color = cfg("FXBeamHitColor", _GOLD)
        local style = cfg("FXBeamStyle", "Glow")
        local lit   = style == "Line"
        local prism = style == "Prism"
        local useLight  = (not lit) and cfg("FXBeamGlowLight", true)
        local useImpact = cfg("FXBeamImpact", true)
        local core, glow, halo = rig.core, rig.glow, rig.halo
        core.Color = ColorSequence.new(lit and color or (prism and _WHITE or color:Lerp(_WHITE, 0.78)))
        local gCol = prism and _EDGE or color
        glow.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, gCol),
            ColorSequenceKeypoint.new(0.8, gCol),
            ColorSequenceKeypoint.new(1, prism and _EDGE or color:Lerp(_WHITE, 0.5)),
        })
        halo.Color = ColorSequence.new(prism and _VISIBLE or color)
        core.LightEmission = lit and 0 or 1
        core.LightInfluence = lit and 1 or 0
        glow.LightEmission = 1; glow.LightInfluence = 0
        halo.LightEmission = 1; halo.LightInfluence = 0
        local w0, w1 = cfg("FXBeamWidth0", 0.18), cfg("FXBeamWidth1", 0.04)
        core.Width0 = w0 * 0.55; core.Width1 = w1 * 0.55
        local gw = prism and 0.45 or 1.7
        local hw = prism and 0.45 or 3.4
        glow.Width0 = w0 * gw; glow.Width1 = w1 * gw
        halo.Width0 = w0 * hw; halo.Width1 = w1 * hw
        local curve = (style == "Arc") and math.clamp(dist * 0.06, 0.5, 9) or 0
        local split = prism and math.clamp(dist * 0.02, 0.3, 1.6) or 0
        core.CurveSize0 = curve;         core.CurveSize1 = curve
        glow.CurveSize0 = curve + split; glow.CurveSize1 = curve + split
        halo.CurveSize0 = curve - split; halo.CurveSize1 = curve - split
        local seg = (curve ~= 0 or split ~= 0) and 10 or 1
        core.Segments = seg; glow.Segments = seg; halo.Segments = seg
        core.Transparency = beamRamp(0, 0.85)
        glow.Transparency = beamRamp(0.3, 0.92)
        halo.Transparency = beamRamp(0.72, 0.985)
        local travDur = 0
        if cfg("FXBeamTravel", true) then
            travDur = math.min(dist / math.max(cfg("FXBeamTravelSpeed", 1400), 100), 0.25)
            if travDur < 0.02 then travDur = 0 end
        end
        local trail = math.clamp(dist * 0.35, 4, 30)
        rig.part0.CFrame = CFrame.new(muzzlePos)
        rig.part1.CFrame = CFrame.new(travDur > 0 and (muzzlePos + dirU * 0.5) or hitPos)
        core.Enabled = true
        glow.Enabled = not lit
        halo.Enabled = not lit
        rig.light.Color = prism and _EDGE or color
        rig.light.Brightness = 2.5
        rig.light.Enabled = useLight
        rig.impact.Color = color:Lerp(_WHITE, 0.55)
        rig.impact.Transparency = 1
        rig.on = true; rig.startT = tick()
        local dur = cfg("FXBeamDur", 0.55)
        local landed = travDur <= 0
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not (rig.model and rig.model.Parent) then
                rig.on = false; if conn then conn:Disconnect() end; rig.conn = nil; return
            end
            local t = tick() - rig.startT
            if t < travDur then
                local headD = (t / travDur) * dist
                pcall(function()
                    rig.part1.CFrame = CFrame.new(muzzlePos + dirU * headD)
                    rig.part0.CFrame = CFrame.new(muzzlePos + dirU * math.max(headD - trail, 0))
                end)
                return
            end
            if not landed then
                landed = true
                pcall(function()
                    rig.part1.CFrame = CFrame.new(hitPos)
                    rig.part0.CFrame = CFrame.new(muzzlePos)
                    if useImpact then rig.impact.CFrame = CFrame.new(hitPos) end
                end)
            end
            local a = math.clamp((t - travDur) / dur, 0, 1)
            local e = 1 - (1 - a) * (1 - a)
            pcall(function()
                core.Transparency = beamRamp(0.25 + 0.75 * e, 0.9 + 0.1 * e)
                if not lit then
                    glow.Transparency = beamRamp(0.5 + 0.5 * e, 0.95 + 0.05 * e)
                    halo.Transparency = beamRamp(0.85 + 0.15 * e, 1)
                end
                if useImpact then
                    local ie = 1 - (1 - math.clamp((t - travDur) / 0.12, 0, 1)) ^ 2
                    local d = 0.25 + 0.9 * ie
                    rig.impact.Size = Vector3.new(d, d, d)
                    rig.impact.Transparency = 0.05 + 0.95 * math.clamp((t - travDur) / 0.3, 0, 1)
                end
                if useLight then rig.light.Brightness = 4 * (1 - e) end
            end)
            if a >= 1 then
                rig.on = false
                pcall(function()
                    core.Enabled = false; glow.Enabled = false; halo.Enabled = false
                    rig.light.Enabled = false; rig.light.Brightness = 0
                    rig.impact.Transparency = 1
                end)
                if conn then conn:Disconnect() end; rig.conn = nil
            end
        end)
        rig.conn = conn
    end
    local _SPARK_HIT  = Color3.fromRGB(255, 233, 184)
    local _SPARK_KILL = Color3.fromRGB(255, 194, 75)
    local _sparks = {}
    local function sparkPrune()
        for i = #_sparks, 1, -1 do
            local m = _sparks[i]
            if not (m and m.Parent) then table.remove(_sparks, i) end
        end
    end
    local function mkSparkRing(parent, pos, dia, color)
        local r = Instance.new("Part")
        r.Shape = Enum.PartType.Cylinder
        r.Size = Vector3.new(0.1, dia, dia)
        r.Material = Enum.Material.Neon
        r.Color = color
        r.Transparency = 0.1
        r.Anchored = true; r.CanCollide = false; r.CanQuery = false
        r.CanTouch = false; r.CastShadow = false; r.Massless = true
        r:SetAttribute("VS_Holo", true)
        local cam = workspace.CurrentCamera
        if cam then
            r.CFrame = CFrame.lookAt(pos, cam.CFrame.Position) * CFrame.Angles(0, math.rad(90), 0)
        else
            r.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
        end
        r.Parent = parent
        return r
    end
    local function spawnWorldSpark(pos, kill)
        if not pos then return end
        sparkPrune()
        while #_sparks >= 12 do
            local old = table.remove(_sparks, 1)
            if old then pcall(function() old:Destroy() end) end
        end
        local folder = getHoloFolder()
        local color  = kill and _SPARK_KILL or _SPARK_HIT
        local model  = Instance.new("Model")
        model.Name = (kill and "_ks" or "_hs") .. math.random(10000, 99999)
        local bloom, bloomB0 = nil, kill and 6 or 4
        if cfg("FXWorldSparkBloom", true) then
            local lpart = Instance.new("Part")
            lpart.Size = Vector3.new(0.05, 0.05, 0.05)
            lpart.Transparency = 1
            lpart.Anchored = true; lpart.CanCollide = false; lpart.CanQuery = false
            lpart.CanTouch = false; lpart.CastShadow = false; lpart.Massless = true
            lpart:SetAttribute("VS_Holo", true)
            lpart.CFrame = CFrame.new(pos)
            lpart.Parent = model
            local light = Instance.new("PointLight")
            light.Color = color; light.Range = kill and 14 or 9; light.Brightness = bloomB0
            light.Parent = lpart
            bloom = light
        end
        local rings, sparks, dirs = {}, {}, {}
        local dur
        if kill then
            dur = 0.32
            rings[1] = { p = mkSparkRing(model, pos, 0.6, color), d0 = 0.6, d1 = 6.0 }
            rings[2] = { p = mkSparkRing(model, pos, 1.0, color), d0 = 1.0, d1 = 4.4 }
        else
            dur = 0.22
            rings[1] = { p = mkSparkRing(model, pos, 0.6, color), d0 = 0.6, d1 = 4.0 }
            for i = 1, 3 do
                local b = Instance.new("Part")
                b.Shape = Enum.PartType.Ball
                b.Size = Vector3.new(0.12, 0.12, 0.12)
                b.Material = Enum.Material.Neon
                b.Color = color
                b.Transparency = 0
                b.Anchored = true; b.CanCollide = false; b.CanQuery = false
                b.CanTouch = false; b.CastShadow = false; b.Massless = true
                b:SetAttribute("VS_Holo", true)
                b.CFrame = CFrame.new(pos)
                b.Parent = model
                sparks[i] = b
                local ang  = math.random() * math.pi * 2
                local elev = (math.random() - 0.5) * 1.2
                dirs[i] = Vector3.new(math.cos(ang), elev, math.sin(ang)).Unit
            end
        end
        model.Parent = folder
        _sparks[#_sparks + 1] = model
        local startT = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not model.Parent then if conn then conn:Disconnect() end return end
            local a = math.clamp((tick() - startT) / dur, 0, 1)
            local e = 1 - (1 - a) * (1 - a)
            local tr = math.clamp(0.1 + 0.9 * a, 0, 1)
            pcall(function()
                for _, rg in ipairs(rings) do
                    local d = rg.d0 + (rg.d1 - rg.d0) * e
                    rg.p.Size = Vector3.new(0.1, d, d)
                    rg.p.Transparency = tr
                end
                for i, b in ipairs(sparks) do
                    if b and b.Parent then
                        b.CFrame = CFrame.new(pos + dirs[i] * (0.6 * e) + Vector3.new(0, 0.4 * e, 0))
                        b.Transparency = math.clamp(a, 0, 1)
                    end
                end
                if bloom then bloom.Brightness = bloomB0 * (1 - e) end
            end)
            if a >= 1 and conn then conn:Disconnect() end
        end)
        Debris:AddItem(model, dur + 0.2)
    end
    Visuals.worldSpark = spawnWorldSpark
    local spawnKillPillar, spawnKillShards, triggerKillPulse, clearKillPulse
    ;(function()
        local _pillars, _bursts = {}, {}
        local function alive(list)
            for i = #list, 1, -1 do
                local m = list[i]
                if not (m and m.Parent) then table.remove(list, i) end
            end
            return #list
        end
        local function mkNeon(model, shape, color, tr)
            local p = Instance.new("Part")
            p.Shape = shape
            p.Material = Enum.Material.Neon
            p.Color = color
            p.Transparency = tr
            p.Anchored = true; p.CanCollide = false; p.CanQuery = false
            p.CanTouch = false; p.CastShadow = false; p.Massless = true
            p:SetAttribute("VS_Holo", true)
            p.Parent = model
            return p
        end
        local VERT = CFrame.Angles(0, 0, math.rad(90))
        spawnKillPillar = function(pos)
            if alive(_pillars) >= 3 then return end
            local color = Config.FXKillPillarColor or _SPARK_KILL
            local model = Instance.new("Model")
            model.Name = "_kf" .. math.random(10000, 99999)
            local dur = 1.0
            local col = mkNeon(model, Enum.PartType.Cylinder, color, 0.3)
            col.Size = Vector3.new(3, 1.1, 1.1)
            col.CFrame = CFrame.new(pos + Vector3.new(0, 0.5, 0)) * VERT
            local ring = mkNeon(model, Enum.PartType.Cylinder, color, 0.15)
            ring.Size = Vector3.new(0.12, 1.4, 1.4)
            ring.CFrame = CFrame.new(pos - Vector3.new(0, 2.2, 0)) * VERT
            local motes, mBase, mVel = {}, {}, {}
            for i = 1, 6 do
                local m = mkNeon(model, Enum.PartType.Ball, color:Lerp(_WHITE, 0.35), 0.1)
                local s = 0.14 + math.random() * 0.12
                m.Size = Vector3.new(s, s, s)
                mBase[i] = pos + Vector3.new((math.random() - 0.5) * 2.2,
                    math.random() * 1.5 - 1.5, (math.random() - 0.5) * 2.2)
                m.CFrame = CFrame.new(mBase[i])
                local a = math.random() * math.pi * 2
                mVel[i] = Vector3.new(math.cos(a) * (0.6 + math.random()), 6 + math.random() * 5,
                    math.sin(a) * (0.6 + math.random()))
                motes[i] = m
            end
            local anchorP = mkNeon(model, Enum.PartType.Ball, color, 1)
            anchorP.Size = Vector3.new(0.05, 0.05, 0.05)
            anchorP.CFrame = CFrame.new(pos)
            local bloom = Instance.new("PointLight")
            bloom.Color = color; bloom.Range = 16; bloom.Brightness = 7
            bloom.Parent = anchorP
            model.Parent = getHoloFolder()
            _pillars[#_pillars + 1] = model
            local t0 = tick()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not model.Parent then if conn then conn:Disconnect() end return end
                local a = math.clamp((tick() - t0) / dur, 0, 1)
                local e = 1 - (1 - a) * (1 - a)
                pcall(function()
                    local h = 3 + 21 * e
                    local w = 1.1 * (1 - 0.55 * e)
                    col.Size = Vector3.new(h, w, w)
                    col.CFrame = CFrame.new(pos + Vector3.new(0, h * 0.5 - 1, 0)) * VERT
                    col.Transparency = a < 0.3 and (0.3 - 0.5 * a) or (0.15 + 0.85 * (a - 0.3) / 0.7)
                    local d = 1.4 + 8.6 * e
                    ring.Size = Vector3.new(0.12, d, d)
                    ring.Transparency = 0.15 + 0.85 * e
                    for i = 1, 6 do
                        motes[i].CFrame = CFrame.new(mBase[i] + mVel[i] * (dur * e))
                        motes[i].Transparency = 0.1 + 0.9 * a
                    end
                    bloom.Brightness = 7 * (1 - e)
                end)
                if a >= 1 and conn then conn:Disconnect() end
            end)
            Debris:AddItem(model, dur + 0.2)
        end
        spawnKillShards = function(pos)
            if alive(_bursts) >= 3 then return end
            local color = Config.FXKillShardsColor or _EDGE
            local model = Instance.new("Model")
            model.Name = "_kb" .. math.random(10000, 99999)
            local dur = 0.75
            local shards, sBase, sVel, sRot, sSpin, sSize = {}, {}, {}, {}, {}, {}
            for i = 1, 10 do
                local s = mkNeon(model, Enum.PartType.Block,
                    i % 3 == 0 and color:Lerp(_WHITE, 0.5) or color, 0.05)
                local k = 0.7 + math.random() * 0.8
                sSize[i] = Vector3.new(0.42 * k, 0.26 * k, 0.09 * k)
                s.Size = sSize[i]
                sBase[i] = pos + Vector3.new((math.random() - 0.5) * 1.4,
                    (math.random() - 0.5) * 1.8, (math.random() - 0.5) * 1.4)
                sRot[i] = CFrame.Angles(math.random() * 6.283, math.random() * 6.283, math.random() * 6.283)
                s.CFrame = CFrame.new(sBase[i]) * sRot[i]
                local a = (i / 10) * math.pi * 2 + math.random()
                sVel[i] = Vector3.new(math.cos(a) * (6 + math.random() * 7), 5 + math.random() * 9,
                    math.sin(a) * (6 + math.random() * 7))
                sSpin[i] = Vector3.new(math.random() * 10 - 5, math.random() * 10 - 5, math.random() * 10 - 5)
                shards[i] = s
            end
            model.Parent = getHoloFolder()
            _bursts[#_bursts + 1] = model
            local t0 = tick()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not model.Parent then if conn then conn:Disconnect() end return end
                local a = math.clamp((tick() - t0) / dur, 0, 1)
                local t = a * dur
                local tr = a < 0.4 and 0.05 or (0.05 + 0.95 * (a - 0.4) / 0.6)
                local sc = 1 - 0.45 * a
                pcall(function()
                    for i = 1, 10 do
                        local p = sBase[i] + sVel[i] * t - Vector3.new(0, 26 * t * t, 0)
                        local sp = sSpin[i]
                        shards[i].CFrame = CFrame.new(p) * sRot[i] * CFrame.Angles(sp.X * t, sp.Y * t, sp.Z * t)
                        shards[i].Size = sSize[i] * sc
                        shards[i].Transparency = tr
                    end
                end)
                if a >= 1 and conn then conn:Disconnect() end
            end)
            Debris:AddItem(model, dur + 0.2)
        end
        local _pulseCC, _pulseConn, _pulseT0 = nil, nil, 0
        triggerKillPulse = function()
            if not (_pulseCC and _pulseCC.Parent) then
                local cc = Instance.new("ColorCorrectionEffect")
                cc.Name = "_vs_pulse"
                cc:SetAttribute("VS_Pulse", true)
                cc.Parent = Lighting
                _pulseCC = cc
            end
            _pulseT0 = tick()
            if _pulseConn then return end
            _pulseConn = RunService.Heartbeat:Connect(function()
                local cc = _pulseCC
                if not (cc and cc.Parent) then
                    if _pulseConn then _pulseConn:Disconnect(); _pulseConn = nil end
                    return
                end
                local a = (tick() - _pulseT0) / 0.35
                if a >= 1 then
                    _pulseConn:Disconnect(); _pulseConn = nil
                    pcall(function() cc.Saturation = 0; cc.Brightness = 0; cc.Contrast = 0 end)
                    return
                end
                local k = (1 - a) * (1 - a) * math.clamp(Config.FXKillPulseAmount or 0.6, 0, 1)
                pcall(function()
                    cc.Saturation = -0.5 * k
                    cc.Brightness = 0.07 * k
                    cc.Contrast   = 0.12 * k
                end)
            end)
        end
        clearKillPulse = function()
            if _pulseConn then _pulseConn:Disconnect(); _pulseConn = nil end
            if _pulseCC then pcall(function() _pulseCC:Destroy() end); _pulseCC = nil end
        end
    end)()
    local FX = {}
    Visuals.FX = FX
    ;(function()
        local SoundService = game:GetService("SoundService")
        local StatsService = game:GetService("Stats")
        local hasDrawing = screenDraw ~= nil
        local C_GREY   = Color3.fromRGB(200, 200, 200)
        local C_AMBER  = Color3.fromRGB(255, 170, 60)
        local C_ORANGE = Color3.fromRGB(255, 120, 30)
        local C_RED    = Color3.fromRGB(255, 59, 78)
        local C_SCREENRED = Color3.fromRGB(194, 30, 47)
        local C_BLACK  = Color3.new(0, 0, 0)
        local C_GOLD   = Color3.fromRGB(255, 194, 75)
        local C_FILL   = Color3.fromRGB(13, 18, 25)
        local C_HPBG   = Color3.fromRGB(11, 15, 22)
        local C_TEXT2  = Color3.fromRGB(174, 185, 197)
        local function dnRamp(total)
            if total <= 25 then
                return C_GREY:Lerp(C_AMBER, math.clamp(total / 25, 0, 1))
            end
            return C_AMBER:Lerp(C_ORANGE, math.clamp((total - 25) / 25, 0, 1))
        end
        local _started, _alloc = false, false
        local _updConn, _gui = nil, nil
        local _hmLines, _hmLinesBlk = nil, nil
        local _hm = { on = false, t0 = 0, pop = 0, color = _WHITE }
        local _snds, _sndIdx, _sndLastT = nil, 1, 0
        local _dnPool, _dnActive, _dnByPlr = nil, {}, {}
        local _kbL1, _kbL2, _kbRing = nil, nil, nil
        local _kb = { on = false, t0 = 0, streak = 0, lastKillT = 0, line1 = "", line2 = "" }
        local _ddArcs = nil
        local _kfPool, _kfItems = nil, {}
        local _hsLines, _hsLinesBlk = nil, nil
        local _hs = { on = false, t0 = 0, pos = nil }
        local _flashFrame = nil
        local _hf = { on = false, t0 = 0 }
        local _vgFrames = nil
        local _vgHP, _vgLastPoll = 1, 0
        local _hcConn, _charConn, _lastHP = nil, nil, nil
        local _fovA, _fovB, _fovFill, _fovCas = nil, nil, nil, nil
        local _fxLastT = nil
        local _fxThrT  = 0
        local _hmRing, _hmRingBlk = nil, nil
        local _chLines, _chLinesBlk, _chDot, _chDotBlk = nil, nil, nil, nil
        local _chTri, _chTriBlk = nil, nil
        local _ch2 = { shots = 0, shotT = -10, rot = 0, rotTgt = 0 }
        local _wmBg, _wmAccent, _wmText = nil, nil, nil
        local _wm = { fps = 60, ping = 0, pingT = 0, str = "", strT = 0, bw = nil, pw = 60 }
        local _sessKills, _sessT0 = 0, tick()
        local _tiBg, _tiAccent, _tiName, _tiHpBg, _tiHpFill, _tiInfo = nil, nil, nil, nil, nil, nil
        local _ti = { tgt = nil, a = 0, hp = nil, frac = 1, pollT = 0, name = nil, info = "" }
        local _blTexts, _blHead, _blBar = nil, nil, nil
        local _bl = { scanT = 0, rows = {}, on = {}, t0 = {} }
        local _kfTicks = nil
        local function mkDraw(t, props)
            if not hasDrawing then return nil end
            local ok, d = pcall(screenDraw, t, "fx")
            if not ok then return nil end
            d.Visible = false
            if props then for k, v in pairs(props) do pcall(function() d[k] = v end) end end
            return d
        end
        local function ensureGui()
            if _gui and _gui.Parent then return _gui end
            local g = Instance.new("ScreenGui")
            g.Name = "_vs_fx"
            g.IgnoreGuiInset = true
            g.ResetOnSpawn = false
            g.DisplayOrder = 999
            local ok = pcall(function() g.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
            if not ok or not g.Parent then
                pcall(function() g.Parent = lp:FindFirstChildOfClass("PlayerGui") end)
            end
            _gui = g
            return g
        end
        local function allocate()
            if _alloc then return end
            _alloc = true
            local g = ensureGui()
            local fr = Instance.new("Frame")
            fr.Name = "_fl"; fr.BackgroundColor3 = C_SCREENRED; fr.BackgroundTransparency = 1
            fr.BorderSizePixel = 0; fr.Size = UDim2.new(1, 0, 1, 0); fr.Visible = false
            fr.ZIndex = 1; fr.Parent = g
            _flashFrame = fr
            _vgFrames = {}
            local SIDES = {
                { size = UDim2.new(1, 0, 0.16, 0),  pos = UDim2.new(0, 0, 0, 0),     rot = 90  },
                { size = UDim2.new(1, 0, 0.16, 0),  pos = UDim2.new(0, 0, 0.84, 0),  rot = 270 },
                { size = UDim2.new(0.12, 0, 1, 0),  pos = UDim2.new(0, 0, 0, 0),     rot = 0   },
                { size = UDim2.new(0.12, 0, 1, 0),  pos = UDim2.new(0.88, 0, 0, 0),  rot = 180 },
            }
            for i, s in ipairs(SIDES) do
                local f = Instance.new("Frame")
                f.Name = "_vg" .. i; f.BackgroundColor3 = C_SCREENRED; f.BackgroundTransparency = 1
                f.BorderSizePixel = 0; f.Size = s.size; f.Position = s.pos; f.Visible = false
                f.ZIndex = 2
                local grad = Instance.new("UIGradient")
                grad.Rotation = s.rot
                grad.Transparency = NumberSequence.new(0, 1)
                grad.Parent = f
                f.Parent = g
                _vgFrames[i] = f
            end
            _hmLinesBlk = {}
            for i = 1, 4 do _hmLinesBlk[i] = mkDraw("Line", { Color = C_BLACK }) end
            _hmLines = {}
            for i = 1, 4 do _hmLines[i] = mkDraw("Line") end
            _dnPool = {}
            for i = 1, 24 do _dnPool[i] = mkDraw("Text", { Center = true, Outline = true, Font = 0 }) end
            _kbL1   = mkDraw("Text", { Center = true, Outline = true, Font = 3, Size = 12 })
            _kbL2   = mkDraw("Text", { Center = true, Outline = true, Font = 0, Size = 22 })
            _kbRing = mkDraw("Circle", { Filled = false, NumSides = 48 })
            _ddArcs = {}
            for i = 1, 6 do
                local arc = { on = false, t0 = 0, ang = 0, dscale = 0, red = {}, blk = {} }
                for j = 1, 9 do
                    arc.blk[j] = mkDraw("Line", { Color = C_BLACK, Thickness = 8 })
                    arc.red[j] = mkDraw("Line", { Color = C_SCREENRED, Thickness = 4 })
                end
                _ddArcs[i] = arc
            end
            _kfPool = {}
            for i = 1, 5 do _kfPool[i] = mkDraw("Text", { Center = false, Outline = true, Font = 3, Size = 13 }) end
            _hsLinesBlk = {}
            for i = 1, 6 do _hsLinesBlk[i] = mkDraw("Line", { Color = C_BLACK, Thickness = 4 }) end
            _hsLines = {}
            for i = 1, 6 do _hsLines[i] = mkDraw("Line", { Thickness = 2 }) end
            _fovFill = mkDraw("Circle", { Filled = true,  NumSides = 96 })
            _fovCas  = mkDraw("Circle", { Filled = false, NumSides = 96 })
            _fovA    = mkDraw("Circle", { Filled = false, NumSides = 96 })
            _fovB    = mkDraw("Circle", { Filled = false, NumSides = 96 })
            _hmRingBlk = mkDraw("Circle", { Filled = false, Color = C_BLACK })
            _hmRing    = mkDraw("Circle", { Filled = false })
            _chLinesBlk = {}
            for i = 1, 4 do _chLinesBlk[i] = mkDraw("Line", { Color = C_BLACK }) end
            _chLines = {}
            for i = 1, 4 do _chLines[i] = mkDraw("Line") end
            _chDotBlk = mkDraw("Circle", { Filled = true, Color = C_BLACK })
            _chDot    = mkDraw("Circle", { Filled = true })
            _chTriBlk = {}
            for i = 1, 3 do _chTriBlk[i] = mkDraw("Circle", { Filled = true, Color = C_BLACK }) end
            _chTri = {}
            for i = 1, 3 do _chTri[i] = mkDraw("Circle", { Filled = true }) end
            _wmBg     = mkDraw("Square", { Filled = true, Color = C_FILL })
            _wmAccent = mkDraw("Line",   { Color = C_GOLD, Thickness = 2 })
            _wmText   = mkDraw("Text",   { Center = false, Outline = true, Font = 2, Size = 13, Text = "LuaHook", Color = _WHITE })
            _wm.stats = mkDraw("Text",   { Center = false, Outline = true, Font = 3, Size = 12, Color = C_TEXT2 })
            _tiBg     = mkDraw("Square", { Filled = true, Color = C_FILL })
            _tiAccent = mkDraw("Line",   { Color = C_GOLD, Thickness = 2 })
            _tiHpBg   = mkDraw("Square", { Filled = true, Color = C_HPBG })
            _tiHpFill = mkDraw("Square", { Filled = true })
            _tiName   = mkDraw("Text",   { Center = true, Outline = true, Font = 0, Size = 13 })
            _tiInfo   = mkDraw("Text",   { Center = true, Outline = true, Font = 0, Size = 11, Color = C_TEXT2 })
            _blBar  = mkDraw("Line", { Color = C_GOLD, Thickness = 2 })
            _blHead = mkDraw("Text", { Center = false, Outline = true, Font = 3, Size = 12, Color = C_GOLD })
            _blTexts = {}
            for i = 1, 10 do _blTexts[i] = mkDraw("Text", { Center = false, Outline = true, Font = 3, Size = 12 }) end
            _kfTicks = {}
            for i = 1, 5 do _kfTicks[i] = mkDraw("Line", { Color = C_GOLD, Thickness = 2 }) end
            _snds = {}
            for i = 1, 4 do
                local s = Instance.new("Sound")
                s.Name = "_fxs" .. i
                s.Volume = 0.5
                s.Parent = SoundService
                _snds[i] = s
            end
        end
        local function triggerHitMarker(crit, lethal)
            if not (_hmLines and _hmLines[1]) then return end
            local now = tick()
            if _hm.on and (now - _hm.t0) < 0.18 then
                _hm.pop = math.min(_hm.pop + 1, 3)
            else
                _hm.pop = 0
            end
            _hm.on = true; _hm.t0 = now
            _hm.color = (lethal and cfg("FXHitMarkerLethalColor", C_RED))
                or (crit and cfg("FXHitMarkerCritColor", _GOLD))
                or cfg("FXHitMarkerColor", _WHITE)
        end
        local function playHitSound(dmg, lethal)
            if not _snds then return end
            local id = lethal and cfg("FXKillSoundId", "") or cfg("FXHitSoundId", "")
            if not id or id == "" then return end
            local now = tick()
            if (now - _sndLastT) < 0.035 then return end
            _sndLastT = now
            local s = _snds[_sndIdx]
            _sndIdx = (_sndIdx % #_snds) + 1
            if not (s and s.Parent) then return end
            pcall(function()
                if s.SoundId ~= id then s.SoundId = id end
                if lethal then
                    s.PlaybackSpeed = 1.0; s.Volume = 0.7
                else
                    s.PlaybackSpeed = 0.9 + math.clamp(dmg / 50, 0, 1) * 0.45
                    s.Volume = cfg("FXHitSoundVolume", 0.5)
                end
                s:Play()
            end)
        end
        local function dnFree(d)
            for _, e in ipairs(_dnActive) do if e.d == d then return false end end
            return true
        end
        local function pushDamageNumber(p, dmg, crit, lethal, hitPos)
            if not (_dnPool and hitPos) then return end
            local now = tick()
            local e = _dnByPlr[p]
            if e and e.alive and (now - e.lastT) <= cfg("FXDamageAccumWindow", 0.9) then
                e.total = e.total + dmg
                e.t0 = now; e.lastT = now; e.popT = now; e.pos = hitPos
                e.crit = e.crit or crit; e.lethal = e.lethal or lethal
                return
            end
            local d
            for _, cand in ipairs(_dnPool) do
                if cand and dnFree(cand) then d = cand break end
            end
            if not d then return end
            e = { d = d, p = p, total = dmg, pos = hitPos, t0 = now, lastT = now, popT = now,
                  drift = math.random(-8, 8), crit = crit, lethal = lethal, alive = true }
            _dnByPlr[p] = e
            table.insert(_dnActive, e)
        end
        local function trackText(s)
            return (s:gsub("(.)", "%1 ")):sub(1, -2)
        end
        local KB_STREAK = { [2] = "DOUBLE", [3] = "TRIPLE", [4] = "QUAD" }
        local function triggerKillBanner(p)
            if not (_kbL1 and _kbL2) then return end
            local now = tick()
            if (now - _kb.lastKillT) <= 4 then _kb.streak = _kb.streak + 1 else _kb.streak = 1 end
            _kb.lastKillT = now
            _kb.on = true; _kb.t0 = now
            local label = "ELIMINATED"
            if _kb.streak >= 5 then label = _kb.streak .. "x"
            elseif _kb.streak >= 2 then label = KB_STREAK[_kb.streak] end
            _kb.line1 = trackText(label)
            _kb.line2 = tostring(p.DisplayName or p.Name)
        end
        local function pushKillFeed(p, crit)
            if not _kfPool then return end
            table.insert(_kfItems, 1, { text = "You  ·  " .. tostring(p.DisplayName or p.Name), t0 = tick(), crit = crit and true or false })
            while #_kfItems > 5 do table.remove(_kfItems) end
        end
        local function triggerSpark(hitPos)
            if not (_hsLines and hitPos) then return end
            _hs.on = true; _hs.t0 = tick(); _hs.pos = hitPos
        end
        local function triggerFlash()
            if not _flashFrame then return end
            _hf.on = true; _hf.t0 = tick()
        end
        local function nearestEnemyPos()
            local myC = lp.Character
            local myR = myC and myC:FindFirstChild("HumanoidRootPart")
            if not myR then return nil end
            local best, bestD, bestVis, bestVisD = nil, math.huge, nil, math.huge
            for plr, o in pairs(State.ESPObjects) do
                local r = o.root
                if plr ~= lp and r and r.Parent then
                    local d = (r.Position - myR.Position).Magnitude
                    if o._vis and d < bestVisD then bestVis, bestVisD = r.Position, d end
                    if d < bestD then best, bestD = r.Position, d end
                end
            end
            return bestVis or best
        end
        local function triggerDirection(drop)
            if not _ddArcs then return end
            local src = nearestEnemyPos(); if not src then return end
            local rel = Camera.CFrame:PointToObjectSpace(src)
            local ang = math.atan2(rel.X, -rel.Z)
            local arc, oldest, oldT = nil, nil, math.huge
            for _, a in ipairs(_ddArcs) do
                if not a.on then arc = a break end
                if a.t0 < oldT then oldest, oldT = a, a.t0 end
            end
            arc = arc or oldest
            if not arc then return end
            arc.on = true; arc.t0 = tick(); arc.ang = ang
            arc.dscale = math.clamp(drop / 50, 0, 1)
            local vp = Camera.ViewportSize
            local cx, cy = vp.X * 0.5, vp.Y * 0.5
            local r = 0.22 * math.min(vp.X, vp.Y)
            local width = math.rad(24 + 24 * arc.dscale)
            local step = width / 9
            local th0 = ang - width * 0.5
            for j = 1, 9 do
                local t1 = th0 + step * (j - 1)
                local t2 = t1 + step * 0.8
                local p1 = Vector2.new(cx + math.sin(t1) * r, cy - math.cos(t1) * r)
                local p2 = Vector2.new(cx + math.sin(t2) * r, cy - math.cos(t2) * r)
                local lb, lr = arc.blk[j], arc.red[j]
                if lb then lb.From = p1; lb.To = p2 end
                if lr then lr.From = p1; lr.To = p2 end
            end
            arc.built = true
        end
        function FX.onHit(p, dmg, crit, lethal, hitPos)
            if not _started then return end
            if cfg("FXHitMarker", true) then triggerHitMarker(crit, lethal) end
            if dmg > 0 or lethal then
                if cfg("FXHitSound", true) then playHitSound(dmg, lethal) end
                if dmg > 0 and cfg("FXDamageNumbers", true) then pushDamageNumber(p, dmg, crit, lethal, hitPos) end
            end
            if crit and cfg("FXHeadshotSpark", true) then triggerSpark(hitPos) end
            if lethal then
                _sessKills = _sessKills + 1
                if cfg("FXKillBanner", true) then triggerKillBanner(p) end
                if cfg("FXKillFeed", true) then pushKillFeed(p, crit) end
            end
            if hitPos then
                if cfg("FXBeamTracer", false) then
                    local cc = Camera.CFrame
                    pcall(spawnBeamTracer,
                        cc.Position + cc.RightVector * 1.4 - cc.UpVector * 1.05 + cc.LookVector * 1.5,
                        hitPos)
                end
                if cfg("FXWorldSpark", false) then pcall(spawnWorldSpark, hitPos, lethal) end
                if lethal then
                    if cfg("FXKillPillar", false) then pcall(spawnKillPillar, hitPos) end
                    if cfg("FXKillShards", false) then pcall(spawnKillShards, hitPos) end
                    if cfg("FXKillPulse", false)  then pcall(triggerKillPulse) end
                end
            end
        end
        function FX.onIncoming(drop)
            if not _started then return end
            if cfg("FXHitFlash", true) then triggerFlash() end
            if cfg("FXDamageDirection", true) then triggerDirection(drop) end
        end
        local DIAG = { Vector2.new(1, 1), Vector2.new(-1, 1), Vector2.new(1, -1), Vector2.new(-1, -1) }
        local INV_SQ2 = 0.70710678
        local PLUS = { Vector2.new(0, -1), Vector2.new(1, 0), Vector2.new(0, 1), Vector2.new(-1, 0) }
        local BL_FEATURES = {
            { "RAGE",    "Rage" },
            { "SILENT",  "SilentAim" },
            { "AIMBOT",  "Aimbot" },
            { "ESP",     "ESP" },
            { "VISUALS", "Visuals" },
        }
        local function hideMarker()
            _hm.on = false
            for _, l in ipairs(_hmLines) do if l then l.Visible = false end end
            if _hmLinesBlk then for _, l in ipairs(_hmLinesBlk) do if l then l.Visible = false end end end
            if _hmRing then _hmRing.Visible = false end
            if _hmRingBlk then _hmRingBlk.Visible = false end
        end
        local function update()
            local now = tick()
            if now - _fxThrT < 0.0083 then return end
            _fxThrT = now
            local dt = now - (_fxLastT or now)
            _fxLastT = now
            if dt > 0.1 then dt = 0.1 end
            local vp = Camera.ViewportSize
            local cx, cy = vp.X * 0.5, vp.Y * 0.5
            if _hm.on and _hmLines then
                local a = now - _hm.t0
                if a >= 0.18 then
                    hideMarker()
                else
                    local style = cfg("FXHitMarkerStyle", "X")
                    local snap = math.clamp(a / 0.07, 0, 1)
                    snap = 1 - (1 - snap) * (1 - snap)
                    local gap = cfg("FXHitMarkerGap", 5)
                    local len = cfg("FXHitMarkerLen", 8) * snap + _hm.pop
                    local th  = cfg("FXHitMarkerThickness", 2)
                    local tr  = 1 - math.clamp((a - 0.09) / 0.09, 0, 1)
                    if style == "Ring" or style == "Dot" then
                        for i, l in ipairs(_hmLines) do
                            if l then l.Visible = false end
                            local lb = _hmLinesBlk and _hmLinesBlk[i]
                            if lb then lb.Visible = false end
                        end
                        if _hmRing then
                            local ctr = Vector2.new(cx, cy)
                            if style == "Ring" then
                                local r = math.max(gap + len, 1)
                                if _hmRingBlk then
                                    _hmRingBlk.Filled = false; _hmRingBlk.Position = ctr; _hmRingBlk.Radius = r
                                    _hmRingBlk.Thickness = th + 2; _hmRingBlk.Color = C_BLACK
                                    _hmRingBlk.Transparency = tr; _hmRingBlk.Visible = true
                                end
                                _hmRing.Filled = false; _hmRing.Position = ctr; _hmRing.Radius = r
                                _hmRing.Thickness = th; _hmRing.Color = _hm.color
                                _hmRing.Transparency = tr; _hmRing.Visible = true
                            else
                                local r = (th + 1) * (1.4 - 0.4 * snap)
                                if _hmRingBlk then
                                    _hmRingBlk.Filled = true; _hmRingBlk.Position = ctr; _hmRingBlk.Radius = r + 1
                                    _hmRingBlk.Color = C_BLACK; _hmRingBlk.Transparency = tr; _hmRingBlk.Visible = true
                                end
                                _hmRing.Filled = true; _hmRing.Position = ctr; _hmRing.Radius = r
                                _hmRing.Color = _hm.color; _hmRing.Transparency = tr; _hmRing.Visible = true
                            end
                        end
                    else
                        if _hmRing then _hmRing.Visible = false end
                        if _hmRingBlk then _hmRingBlk.Visible = false end
                        local plus = style == "Plus"
                        for i, l in ipairs(_hmLines) do
                            if l then
                                local nx, ny
                                if plus then nx, ny = PLUS[i].X, PLUS[i].Y
                                else nx, ny = DIAG[i].X * INV_SQ2, DIAG[i].Y * INV_SQ2 end
                                local from = Vector2.new(cx + nx * gap, cy + ny * gap)
                                local to   = Vector2.new(cx + nx * (gap + len), cy + ny * (gap + len))
                                local lb = _hmLinesBlk and _hmLinesBlk[i]
                                if lb then
                                    lb.From = from; lb.To = to
                                    lb.Color = C_BLACK; lb.Thickness = th + 2
                                    lb.Transparency = tr; lb.Visible = true
                                end
                                l.From = from
                                l.To   = to
                                l.Color = _hm.color
                                l.Thickness = th
                                l.Transparency = tr
                                l.Visible = true
                            end
                        end
                    end
                end
            end
            if _chLines then
                local wep = getEquippedItem and getEquippedItem()
                local isScoped = wep and wep.IsAiming and wep:IsAiming()
                local crossOn = cfg("FXCrosshair", false) or (cfg("FXCrosshairSniper", false) and isScoped)
                if crossOn then
                    local style = cfg("FXCrosshairStyle", "Cross")
                    local gap  = cfg("FXCrosshairGap", 4)
                    local len  = cfg("FXCrosshairLen", 7)
                    local th   = cfg("FXCrosshairThickness", 2)
                    local col  = cfg("FXCrosshairColor", _WHITE)
                    local outl = cfg("FXCrosshairOutline", true)
                    if cfg("FXCrosshairHitPop", true) and _hm.t0 > 0 then
                        len = len + 2 * (1 - math.clamp((now - _hm.t0) / 0.06, 0, 1))
                    end
                    local sh = State.Shots or 0
                    if sh ~= _ch2.shots then
                        _ch2.rotTgt = _ch2.rotTgt + 15 * math.min(math.abs(sh - _ch2.shots), 3)
                        _ch2.shots = sh; _ch2.shotT = now
                    end
                    if cfg("FXCrosshairBloom", false) or cfg("FXCrosshairBounce", false) then
                        local bAmt = cfg("FXCrosshairBounceAmt", 4)
                        gap = gap + bAmt * (1 - math.clamp((now - _ch2.shotT) / 0.12, 0, 1))
                    end
                    local rotDeg = cfg("FXCrosshairAngle", 0)
                    if cfg("FXCrosshairSpin", false) then
                        rotDeg = (rotDeg + now * cfg("FXCrosshairSpinSpeed", 1.0) * 360) % 360
                    end
                    local rotRad = math.rad(rotDeg)
                    local cosR, sinR = math.cos(rotRad), math.sin(rotRad)
                    local chev = style == "Chevron"
                    local diag = style == "X"
                    for i = 1, 4 do
                        local l  = _chLines[i]
                        local lb = _chLinesBlk and _chLinesBlk[i]
                        local hide = style == "Dot" or (style == "T" and i == 1) or (chev and i > 2)
                        if l then
                            if hide then
                                l.Visible = false; if lb then lb.Visible = false end
                            else
                                local nx, ny
                                if chev then
                                    local sx = (i == 1) and -1 or 1
                                    nx, ny = sx * 0.707, 0.707
                                elseif diag then
                                    nx, ny = DIAG[i].X * INV_SQ2, DIAG[i].Y * INV_SQ2
                                else
                                    nx, ny = PLUS[i].X, PLUS[i].Y
                                end
                                local rnx = nx * cosR - ny * sinR
                                local rny = nx * sinR + ny * cosR
                                local from = Vector2.new(cx + rnx * gap, cy + rny * gap)
                                local to   = Vector2.new(cx + rnx * (gap + len), cy + rny * (gap + len))
                                if lb then
                                    if outl then
                                        lb.From = from; lb.To = to; lb.Thickness = th + 2
                                        lb.Color = C_BLACK; lb.Transparency = 1; lb.Visible = true
                                    else lb.Visible = false end
                                end
                                l.From = from; l.To = to; l.Thickness = th
                                l.Color = col; l.Transparency = 1; l.Visible = true
                            end
                        end
                    end
                    if _chDot then
                        if style == "Dot" or cfg("FXCrosshairDot", true) then
                            local r = math.max(th * 0.5 + 0.5, 1)
                            if style == "Dot" then r = th + 1 end
                            if _chDotBlk then
                                if outl then
                                    _chDotBlk.Filled = true; _chDotBlk.Position = Vector2.new(cx, cy)
                                    _chDotBlk.Radius = r + 1; _chDotBlk.Color = C_BLACK
                                    _chDotBlk.Transparency = 1; _chDotBlk.Visible = true
                                else _chDotBlk.Visible = false end
                            end
                            _chDot.Filled = true; _chDot.Position = Vector2.new(cx, cy)
                            _chDot.Radius = r; _chDot.Color = col
                            _chDot.Transparency = 1; _chDot.Visible = true
                        else
                            _chDot.Visible = false
                            if _chDotBlk then _chDotBlk.Visible = false end
                        end
                    end
                else
                    for i = 1, 4 do
                        local l = _chLines[i]; if l and l.Visible then l.Visible = false end
                        local lb = _chLinesBlk and _chLinesBlk[i]; if lb and lb.Visible then lb.Visible = false end
                    end
                    if _chDot and _chDot.Visible then _chDot.Visible = false end
                    if _chDotBlk and _chDotBlk.Visible then _chDotBlk.Visible = false end
                    if _chTri then
                        for i = 1, 3 do
                            local d2 = _chTri[i]; if d2 and d2.Visible then d2.Visible = false end
                            local db = _chTriBlk and _chTriBlk[i]; if db and db.Visible then db.Visible = false end
                        end
                    end
                end
            end
            if _dnActive[1] then
                for i = #_dnActive, 1, -1 do
                    local e = _dnActive[i]
                    local a = (now - e.t0) / 0.7
                    if a >= 1 then
                        if e.d then e.d.Visible = false end
                        e.alive = false
                        if _dnByPlr[e.p] == e then _dnByPlr[e.p] = nil end
                        table.remove(_dnActive, i)
                    elseif e.d then
                        local sp = Camera:WorldToViewportPoint(e.pos)
                        if sp.Z <= 0 then
                            e.d.Visible = false
                        else
                            local d = e.d
                            local ease = 1 - (1 - a) * (1 - a)
                            local pop  = 1 + 0.25 * (1 - math.clamp((now - e.popT) / 0.12, 0, 1))
                            d.Size = math.floor((14 + math.clamp(e.total / 50, 0, 1) * 8) * pop + 0.5)
                            d.Text = tostring(math.floor(e.total + 0.5))
                            if e.crit or e.lethal then d.Color = C_GOLD
                            else d.Color = dnRamp(e.total) end
                            d.Position = Vector2.new(sp.X + e.drift * a, sp.Y - 42 * ease)
                            d.Transparency = a < 0.6 and 1 or 1 - (a - 0.6) / 0.4
                            d.Visible = true
                        end
                    end
                end
            end
            if _kb.on then
                local a = now - _kb.t0
                if a >= 1.17 then
                    _kb.on = false
                    if _kbL1 then _kbL1.Visible = false end
                    if _kbL2 then _kbL2.Visible = false end
                    if _kbRing then _kbRing.Visible = false end
                else
                    local y = cy - 140
                    local scale, tr, rise = 1, 1, 0
                    if a < 0.09 then
                        scale = 0.6 + 0.4 * (a / 0.09)
                    elseif a > 0.79 then
                        local f = (a - 0.79) / 0.38
                        tr = 1 - f
                        rise = 8 * f
                    end
                    if _kbL1 then
                        local lt = math.clamp(a / 0.24, 0, 1)
                        local le = 1 - (1 - lt) * (1 - lt) * (1 - lt)
                        _kbL1.Text = _kb.line1
                        _kbL1.Size = math.floor(12 * scale + 0.5)
                        _kbL1.Color = _WHITE
                        _kbL1.Position = Vector2.new(cx, y - rise - 3 * (1 - le))
                        _kbL1.Transparency = tr * le
                        _kbL1.Visible = true
                    end
                    if _kbL2 then
                        _kbL2.Text = _kb.line2
                        _kbL2.Size = math.floor(22 * scale + 0.5)
                        _kbL2.Color = cfg("FXKillBannerColor", _GOLD)
                        _kbL2.Position = Vector2.new(cx, y - rise + 16)
                        _kbL2.Transparency = tr
                        _kbL2.Visible = true
                    end
                    if _kbRing then
                        if a < 0.32 then
                            local f = a / 0.32
                            local fe = 1 - (1 - f) * (1 - f)
                            _kbRing.Position = Vector2.new(cx, cy)
                            _kbRing.Radius = 6 + 40 * fe
                            _kbRing.Thickness = 2 - 1.5 * f
                            _kbRing.Color = cfg("FXKillBannerColor", _GOLD)
                            _kbRing.Transparency = math.min(1, 0.6 + 0.1 * (_kb.streak - 1)) * (1 - f)
                            _kbRing.Visible = true
                        else
                            _kbRing.Visible = false
                        end
                    end
                end
            end
            if _ddArcs then
                for _, arc in ipairs(_ddArcs) do
                    if arc.on then
                        local a = now - arc.t0
                        if a >= 1.12 then
                            arc.on = false
                            for j = 1, 9 do
                                if arc.red[j] then arc.red[j].Visible = false end
                                if arc.blk[j] then arc.blk[j].Visible = false end
                            end
                        else
                            local op = 0.6 + 0.35 * arc.dscale
                            if a > 0.22 then op = op * (1 - (a - 0.22) / 0.9) end
                            for j = 1, 9 do
                                local lb, lr = arc.blk[j], arc.red[j]
                                if lb then lb.Transparency = op * 0.8; lb.Visible = true end
                                if lr then lr.Transparency = op; lr.Visible = true end
                            end
                        end
                    end
                end
            end
            if _kfPool then
                local y0 = Config.ESPRadar and (Config.ESPRadarInset + Config.ESPRadarSize + 16) or 110
                for i, d in ipairs(_kfPool) do
                    local it = _kfItems[i]
                    local tk = _kfTicks and _kfTicks[i]
                    if d then
                        if not it or (now - it.t0) >= 5 then
                            d.Visible = false
                            if tk then tk.Visible = false end
                        else
                            local a = now - it.t0
                            local slide = math.clamp(a / 0.12, 0, 1)
                            slide = 1 - (1 - slide) * (1 - slide)
                            d.Text = it.text
                            d.Color = it.crit and C_GOLD or _WHITE
                            d.Size = 13
                            local rx = vp.X - 16 - d.TextBounds.X + (1 - slide) * 30
                            local ry = y0 + (i - 1) * 18
                            local tr = a < 4 and 1 or 1 - (a - 4)
                            d.Position = Vector2.new(rx, ry)
                            d.Transparency = tr
                            d.Visible = true
                            if tk then
                                tk.From = Vector2.new(rx - 8, ry + 2)
                                tk.To   = Vector2.new(rx - 8, ry + 13)
                                tk.Thickness = 2; tk.Color = C_GOLD
                                tk.Transparency = tr; tk.Visible = true
                            end
                        end
                    end
                end
                for i = #_kfItems, 1, -1 do
                    if (now - _kfItems[i].t0) >= 5 then table.remove(_kfItems, i) end
                end
            end
            if _hs.on and _hsLines then
                local a = (now - _hs.t0) / 0.18
                if a >= 1 then
                    _hs.on = false
                    for _, l in ipairs(_hsLines) do if l then l.Visible = false end end
                    if _hsLinesBlk then for _, l in ipairs(_hsLinesBlk) do if l then l.Visible = false end end end
                else
                    local sp = Camera:WorldToViewportPoint(_hs.pos)
                    if sp.Z <= 0 then
                        for _, l in ipairs(_hsLines) do if l then l.Visible = false end end
                        if _hsLinesBlk then for _, l in ipairs(_hsLinesBlk) do if l then l.Visible = false end end end
                    else
                        local rad = 4 + 8 * a
                        local tr = 1 - a * a
                        for i, l in ipairs(_hsLines) do
                            if l then
                                local th = (i - 1) * (math.pi / 3)
                                local dx, dy = math.cos(th), math.sin(th)
                                local from = Vector2.new(sp.X + dx * rad, sp.Y + dy * rad)
                                local to   = Vector2.new(sp.X + dx * (rad + 5), sp.Y + dy * (rad + 5))
                                local lb = _hsLinesBlk and _hsLinesBlk[i]
                                if lb then
                                    lb.From = from; lb.To = to
                                    lb.Transparency = tr; lb.Visible = true
                                end
                                l.From = from
                                l.To   = to
                                l.Color = C_GOLD
                                l.Transparency = tr
                                l.Visible = true
                            end
                        end
                    end
                end
            end
            if _hf.on and _flashFrame then
                local a = (now - _hf.t0) / 0.16
                if a >= 1 then
                    _hf.on = false
                    _flashFrame.Visible = false
                else
                    _flashFrame.BackgroundTransparency = 0.78 + 0.22 * a
                    _flashFrame.Visible = true
                end
            end
            if _vgFrames then
                local show = false
                if cfg("FXLowHPVignette", true) then
                    if (now - _vgLastPoll) > 0.1 then
                        _vgLastPoll = now
                        local hp, mh = getHealth(lp)
                        _vgHP = (mh and mh > 0) and hp / mh or 1
                    end
                    local thr = cfg("FXLowHPThreshold", 0.35)
                    if _vgHP > 0 and _vgHP < thr then
                        local sev = math.clamp((thr - _vgHP) / math.max(thr - 0.10, 0.01), 0, 1)
                        local freq = 0.8 + 0.6 * sev
                        local tr = (0.85 - 0.35 * sev)
                            + 0.06 * (0.5 + 0.5 * math.sin(now * freq * 6.283185))
                        tr = math.clamp(tr, 0, 1)
                        for _, f in ipairs(_vgFrames) do
                            f.BackgroundTransparency = tr
                            if not f.Visible then f.Visible = true end
                        end
                        show = true
                    end
                end
                if not show then
                    for _, f in ipairs(_vgFrames) do if f.Visible then f.Visible = false end end
                end
            end
            if _fovA then
                if cfg("FXFovRing", false) then
                    local _vpF = Camera.ViewportSize
                    local _hf  = math.tan(math.rad(Camera.FieldOfView) * 0.5)
                    local _deg = math.clamp(cfg("AimbotFOVDeg", 20), 0.1, 89)
                    local R    = (_hf > 0)
                        and math.clamp(math.tan(math.rad(_deg)) / _hf * (_vpF.Y * 0.5), 4, math.max(_vpF.X, _vpF.Y))
                        or  math.max(_vpF.X, _vpF.Y)
                    local th = math.clamp(cfg("FXFovThickness", 1.5), 0.5, 4)
                    local cA = cfg("FXFovColorA", _WHITE)
                    local cB = cfg("FXFovColorB", _GOLD)
                    local phase = cfg("FXFovRotate", true) and (now * cfg("FXFovDriftSpeed", 0.15)) or 0
                    local t = 0.5 + 0.5 * math.sin(phase * 6.283185)
                    local center = Vector2.new(cx, cy)
                    if _fovFill then
                        if cfg("FXFovFill", false) then
                            _fovFill.Position = center; _fovFill.Radius = R
                            _fovFill.Color = _SPARK_KILL
                            _fovFill.Transparency = 0.05
                            _fovFill.Visible = true
                        elseif _fovFill.Visible then
                            _fovFill.Visible = false
                        end
                    end
                    if _fovCas then
                        if cfg("FXFovCasing", true) then
                            _fovCas.Position = center; _fovCas.Radius = R
                            _fovCas.Thickness = th + 2; _fovCas.Color = C_BLACK
                            _fovCas.Transparency = 0.5; _fovCas.Visible = true
                        elseif _fovCas.Visible then
                            _fovCas.Visible = false
                        end
                    end
                    _fovA.Position = center; _fovA.Radius = R
                    _fovA.Thickness = th; _fovA.Color = cA:Lerp(cB, t)
                    _fovA.Transparency = 0.5; _fovA.Visible = true
                    if _fovB then
                        _fovB.Position = center; _fovB.Radius = math.max(1, R - th)
                        _fovB.Thickness = th; _fovB.Color = cB:Lerp(cA, t)
                        _fovB.Transparency = 0.5; _fovB.Visible = true
                    end
                else
                    if _fovA.Visible then _fovA.Visible = false end
                    if _fovB and _fovB.Visible then _fovB.Visible = false end
                    if _fovFill and _fovFill.Visible then _fovFill.Visible = false end
                    if _fovCas and _fovCas.Visible then _fovCas.Visible = false end
                end
            end
            if _wmText then
                if cfg("HUDWatermark", true) then
                    if dt > 0 then _wm.fps = _wm.fps + (1 / dt - _wm.fps) * 0.1 end
                    local stats = cfg("HUDWatermarkStats", true)
                    if stats and (now - _wm.pingT) > 1 then
                        _wm.pingT = now
                        pcall(function()
                            _wm.ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
                        end)
                    end
                    _wmText.Position = Vector2.new(26, 21)
                    _wmText.Transparency = 1
                    _wmText.Visible = true
                    if not _wm.bw then
                        pcall(function() local tb = _wmText.TextBounds; if tb and tb.X > 0 then _wm.bw = tb.X end end)
                    end
                    local bw = _wm.bw or 52
                    if (now - _wm.strT) > 0.25 then
                        _wm.strT = now
                        if stats then
                            local sess = now - _sessT0
                            _wm.str = string.format("%d fps · %d ms · %02d:%02d · %d kills",
                                math.floor(_wm.fps + 0.5), _wm.ping,
                                math.floor(sess / 60), math.floor(sess % 60), _sessKills)
                        else
                            _wm.str = ""
                        end
                        local sw = 0
                        if _wm.stats and _wm.str ~= "" then
                            _wm.stats.Text = _wm.str
                            pcall(function() local tb = _wm.stats.TextBounds; if tb then sw = tb.X end end)
                        end
                        _wm.pw = (sw > 0) and (10 + bw + 12 + sw + 10) or (10 + bw + 10)
                    end
                    if _wm.stats then
                        if _wm.str ~= "" then
                            _wm.stats.Position = Vector2.new(26 + bw + 12, 22)
                            _wm.stats.Transparency = 1
                            _wm.stats.Visible = true
                        elseif _wm.stats.Visible then _wm.stats.Visible = false end
                    end
                    if _wmBg then
                        _wmBg.Filled = true
                        _wmBg.Position = Vector2.new(16, 16); _wmBg.Size = Vector2.new(_wm.pw, 24)
                        _wmBg.Color = C_FILL; _wmBg.Transparency = 0.72; _wmBg.Visible = true
                    end
                    if _wmAccent then
                        _wmAccent.From = Vector2.new(16, 16); _wmAccent.To = Vector2.new(16, 40)
                        _wmAccent.Thickness = 2; _wmAccent.Color = C_GOLD
                        _wmAccent.Transparency = 1; _wmAccent.Visible = true
                    end
                else
                    if _wmText.Visible then _wmText.Visible = false end
                    if _wm.stats and _wm.stats.Visible then _wm.stats.Visible = false end
                    if _wmBg and _wmBg.Visible then _wmBg.Visible = false end
                    if _wmAccent and _wmAccent.Visible then _wmAccent.Visible = false end
                end
            end
            if _tiBg and _tiAccent and _tiName and _tiHpBg and _tiHpFill and _tiInfo then
                local tgt = nil
                if cfg("FXTargetInfo", false) then
                    tgt = State.PrimaryTarget
                    if tgt and not (tgt.Parent and tgt.Character and isAlive(tgt)) then tgt = nil end
                end
                if tgt ~= _ti.tgt then
                    _ti.tgt = tgt
                    if tgt then
                        _ti.name = tostring(tgt.DisplayName or tgt.Name)
                        _ti.hp = nil; _ti.pollT = 0
                    end
                end
                if tgt and (now - (_ti.pollT or 0)) > 0.1 then
                    _ti.pollT = now
                    pcall(function()
                        local hp, mh = getHealth(tgt)
                        _ti.frac = math.clamp((mh or 0) > 0 and hp / mh or 0, 0, 1)
                        local d = 0
                        local myR = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                        local tR  = tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart")
                        if myR and tR then d = (myR.Position - tR.Position).Magnitude end
                        _ti.info = string.format("%dm  ·  %s", math.floor(d + 0.5), getWeaponName(tgt))
                    end)
                end
                _ti.a = (_ti.a or 0) + ((tgt and 1 or 0) - (_ti.a or 0)) * math.clamp(dt * 16, 0, 1)
                if _ti.a > 0.02 and _ti.name then
                    local frac = _ti.frac or 1
                    if _ti.hp == nil then _ti.hp = frac
                    else _ti.hp = _ti.hp + (frac - _ti.hp) * (1 - math.exp(-18 * dt)) end
                    local aa = math.clamp(_ti.a, 0, 1)
                    local px = cx - 90
                    local py = cy + cfg("FXTargetInfoOffset", 110)
                    _tiBg.Filled = true; _tiBg.Position = Vector2.new(px, py); _tiBg.Size = Vector2.new(180, 46)
                    _tiBg.Color = C_FILL; _tiBg.Transparency = 0.62 * aa; _tiBg.Visible = true
                    _tiAccent.From = Vector2.new(px + 1, py); _tiAccent.To = Vector2.new(px + 1, py + 46)
                    _tiAccent.Thickness = 2; _tiAccent.Color = C_GOLD
                    _tiAccent.Transparency = aa; _tiAccent.Visible = true
                    _tiName.Text = _ti.name; _tiName.Position = Vector2.new(px + 90, py + 3)
                    _tiName.Color = _WHITE; _tiName.Transparency = aa; _tiName.Visible = true
                    local fillW = math.max(164 * math.clamp(_ti.hp, 0, 1), 1)
                    _tiHpBg.Filled = true; _tiHpBg.Position = Vector2.new(px + 8, py + 23)
                    _tiHpBg.Size = Vector2.new(164, 5); _tiHpBg.Color = C_HPBG
                    _tiHpBg.Transparency = 0.86 * aa; _tiHpBg.Visible = true
                    _tiHpFill.Filled = true; _tiHpFill.Position = Vector2.new(px + 8, py + 23)
                    _tiHpFill.Size = Vector2.new(fillW, 5); _tiHpFill.Color = hpRamp(_ti.hp)
                    _tiHpFill.Transparency = aa; _tiHpFill.Visible = true
                    _tiInfo.Text = _ti.info or ""; _tiInfo.Position = Vector2.new(px + 90, py + 31)
                    _tiInfo.Color = C_TEXT2; _tiInfo.Transparency = aa; _tiInfo.Visible = true
                else
                    if _tiBg.Visible then
                        _tiBg.Visible = false; _tiAccent.Visible = false; _tiName.Visible = false
                        _tiHpBg.Visible = false; _tiHpFill.Visible = false; _tiInfo.Visible = false
                    end
                end
            end
            if _blTexts then
                if cfg("HUDBindList", false) then
                    if (now - (_bl.scanT or 0)) >= 0.25 then
                        _bl.scanT = now
                        local n = 0
                        for _, f in ipairs(BL_FEATURES) do
                            if Config[f[2]] then
                                n = n + 1
                                _bl.rows[n] = f[1]
                                if not _bl.on[f[2]] then _bl.on[f[2]] = true; _bl.t0[f[1]] = now end
                            else
                                _bl.on[f[2]] = false
                            end
                        end
                        for i = #_bl.rows, n + 1, -1 do _bl.rows[i] = nil end
                    end
                    local right = cfg("HUDBindListSide", "Left") == "Right"
                    local bx = right and (vp.X - 110) or 16
                    local by = vp.Y * 0.35
                    if _blHead then
                        _blHead.Text = "LuaHook"; _blHead.Color = C_GOLD
                        _blHead.Position = Vector2.new(bx, by)
                        _blHead.Transparency = 1; _blHead.Visible = true
                    end
                    local nRows = #_bl.rows
                    for i, d in ipairs(_blTexts) do
                        local label = _bl.rows[i]
                        if label then
                            local a = math.clamp((now - (_bl.t0[label] or 0)) / 0.12, 0, 1)
                            local e = 1 - (1 - a) * (1 - a)
                            d.Text = label; d.Color = _WHITE
                            d.Position = Vector2.new(bx + (1 - e) * 14 * (right and 1 or -1), by + 17 + (i - 1) * 15)
                            d.Transparency = e
                            d.Visible = true
                        elseif d.Visible then
                            d.Visible = false
                        end
                    end
                    if _blBar then
                        _blBar.From = Vector2.new(bx - 6, by)
                        _blBar.To   = Vector2.new(bx - 6, by + 17 + nRows * 15)
                        _blBar.Thickness = 2; _blBar.Color = C_GOLD
                        _blBar.Transparency = 0.9; _blBar.Visible = true
                    end
                else
                    if _blHead and _blHead.Visible then _blHead.Visible = false end
                    if _blBar and _blBar.Visible then _blBar.Visible = false end
                    for _, d in ipairs(_blTexts) do if d.Visible then d.Visible = false end end
                end
            end
        end
        local function hideAllFX()
            if _hmLines then hideMarker() end
            for i = #_dnActive, 1, -1 do
                local e = _dnActive[i]
                if e.d then e.d.Visible = false end
                _dnActive[i] = nil
            end
            table.clear(_dnByPlr)
            _kb.on = false
            if _kbL1 then _kbL1.Visible = false end
            if _kbL2 then _kbL2.Visible = false end
            if _kbRing then _kbRing.Visible = false end
            if _ddArcs then
                for _, arc in ipairs(_ddArcs) do
                    arc.on = false
                    for j = 1, 9 do
                        if arc.red[j] then arc.red[j].Visible = false end
                        if arc.blk[j] then arc.blk[j].Visible = false end
                    end
                end
            end
            table.clear(_kfItems)
            if _kfPool then for _, d in ipairs(_kfPool) do if d then d.Visible = false end end end
            _hs.on = false
            if _hsLines then for _, l in ipairs(_hsLines) do if l then l.Visible = false end end end
            if _hsLinesBlk then for _, l in ipairs(_hsLinesBlk) do if l then l.Visible = false end end end
            _hf.on = false
            if _flashFrame then _flashFrame.Visible = false end
            if _vgFrames then for _, f in ipairs(_vgFrames) do f.Visible = false end end
            if _fovA then _fovA.Visible = false end
            if _fovB then _fovB.Visible = false end
            if _fovFill then _fovFill.Visible = false end
            if _fovCas then _fovCas.Visible = false end
            if _hmRing then _hmRing.Visible = false end
            if _hmRingBlk then _hmRingBlk.Visible = false end
            if _chLines then for _, l in ipairs(_chLines) do if l then l.Visible = false end end end
            if _chLinesBlk then for _, l in ipairs(_chLinesBlk) do if l then l.Visible = false end end end
            if _chDot then _chDot.Visible = false end
            if _chDotBlk then _chDotBlk.Visible = false end
            if _chTri then for i = 1, 3 do if _chTri[i] then _chTri[i].Visible = false end end end
            if _chTriBlk then for i = 1, 3 do if _chTriBlk[i] then _chTriBlk[i].Visible = false end end end
            if _wmBg then _wmBg.Visible = false end
            if _wmAccent then _wmAccent.Visible = false end
            if _wmText then _wmText.Visible = false end
            if _wm.stats then _wm.stats.Visible = false end
            if _tiBg then _tiBg.Visible = false end
            if _tiAccent then _tiAccent.Visible = false end
            if _tiName then _tiName.Visible = false end
            if _tiHpBg then _tiHpBg.Visible = false end
            if _tiHpFill then _tiHpFill.Visible = false end
            if _tiInfo then _tiInfo.Visible = false end
            _ti.tgt = nil; _ti.a = 0
            if _blHead then _blHead.Visible = false end
            if _blBar then _blBar.Visible = false end
            if _blTexts then for _, d in ipairs(_blTexts) do if d then d.Visible = false end end end
            if _kfTicks then for _, l in ipairs(_kfTicks) do if l then l.Visible = false end end end
        end
        local function hookHumanoid(char)
            if _hcConn then _hcConn:Disconnect(); _hcConn = nil end
            if not char then return end
            task.spawn(function()
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then
                    pcall(function() hum = char:WaitForChild("Humanoid", 5) end)
                end
                if not hum or not _started or char ~= lp.Character then return end
                _lastHP = hum.Health
                _hcConn = hum.HealthChanged:Connect(function(h)
                    local prev = _lastHP or h
                    _lastHP = h
                    local drop = prev - h
                    if drop > 0.5 then FX.onIncoming(drop) end
                end)
            end)
        end
        function FX.start()
            if _started then return end
            _started = true
            allocate()
            ensureGui()
            hookHumanoid(lp.Character)
            _charConn = lp.CharacterAdded:Connect(function(c) if _started then hookHumanoid(c) end end)
            if not _updConn then
                _updConn = RunService.RenderStepped:Connect(function()
                    if _started then pcall(update) end
                end)
            end
        end
        function FX.stop()
            if not _started then return end
            _started = false
            if _updConn then _updConn:Disconnect(); _updConn = nil end
            if _hcConn then _hcConn:Disconnect(); _hcConn = nil end
            if _charConn then _charConn:Disconnect(); _charConn = nil end
            hideAllFX()
        end
        function FX.destroy()
            FX.stop()
            local function rm(d) if d then pcall(function() d:Remove() end) end end
            if _hmLines then for _, d in ipairs(_hmLines) do rm(d) end _hmLines = nil end
            if _hmLinesBlk then for _, d in ipairs(_hmLinesBlk) do rm(d) end _hmLinesBlk = nil end
            if _dnPool then for _, d in ipairs(_dnPool) do rm(d) end _dnPool = nil end
            rm(_kbL1); rm(_kbL2); rm(_kbRing); _kbL1, _kbL2, _kbRing = nil, nil, nil
            if _ddArcs then
                for _, arc in ipairs(_ddArcs) do
                    for j = 1, 9 do rm(arc.red[j]); rm(arc.blk[j]) end
                end
                _ddArcs = nil
            end
            if _kfPool then for _, d in ipairs(_kfPool) do rm(d) end _kfPool = nil end
            if _hsLines then for _, d in ipairs(_hsLines) do rm(d) end _hsLines = nil end
            if _hsLinesBlk then for _, d in ipairs(_hsLinesBlk) do rm(d) end _hsLinesBlk = nil end
            rm(_fovA); rm(_fovB); rm(_fovFill); rm(_fovCas); _fovA, _fovB, _fovFill, _fovCas = nil, nil, nil, nil
            rm(_hmRing); rm(_hmRingBlk); _hmRing, _hmRingBlk = nil, nil
            if _chLines then for _, d in ipairs(_chLines) do rm(d) end _chLines = nil end
            if _chLinesBlk then for _, d in ipairs(_chLinesBlk) do rm(d) end _chLinesBlk = nil end
            rm(_chDot); rm(_chDotBlk); _chDot, _chDotBlk = nil, nil
            if _chTri then for _, d in ipairs(_chTri) do rm(d) end _chTri = nil end
            if _chTriBlk then for _, d in ipairs(_chTriBlk) do rm(d) end _chTriBlk = nil end
            rm(_wmBg); rm(_wmAccent); rm(_wmText); _wmBg, _wmAccent, _wmText = nil, nil, nil
            rm(_wm.stats); _wm.stats = nil
            rm(_tiBg); rm(_tiAccent); rm(_tiName); rm(_tiHpBg); rm(_tiHpFill); rm(_tiInfo)
            _tiBg, _tiAccent, _tiName, _tiHpBg, _tiHpFill, _tiInfo = nil, nil, nil, nil, nil, nil
            rm(_blHead); rm(_blBar); _blHead, _blBar = nil, nil
            if _blTexts then for _, d in ipairs(_blTexts) do rm(d) end _blTexts = nil end
            if _kfTicks then for _, d in ipairs(_kfTicks) do rm(d) end _kfTicks = nil end
            if _snds then for _, s in ipairs(_snds) do pcall(function() s:Destroy() end) end _snds = nil end
            if _gui then pcall(function() _gui:Destroy() end); _gui = nil end
            _flashFrame = nil; _vgFrames = nil
            _alloc = false
        end
    end)()
    local _hpPrev = {}
    function Visuals.notifyTarget(p, info)
        if not p or p == lp or not p.Character then return end
        local cur, maxHP = getHealth(p)
        local dmg = math.max(0, (_hpPrev[p] or maxHP) - cur)
        _hpPrev[p] = cur
        local lethal = (not isAlive(p)) or cur <= 0
        local char = p.Character
        local rp = char:FindFirstChild("HitboxHead")
            or char:FindFirstChild("Head")
            or char:FindFirstChild("HumanoidRootPart")
            or char:FindFirstChild("UpperTorso")
        local hitPos = rp and rp.Position or nil
        local crit = (info and info.crit) or (dmg >= cfg("FXCritDamage", 30))
        if Config.VisualsHolograms then
            local now = tick()
            if (now - (_hologramCooldowns[p] or 0)) >= 0.35 then
                _hologramCooldowns[p] = now
                createHologram(char, lethal)
            end
        end
        FX.onHit(p, dmg, crit, lethal, hitPos)
    end
    local applyCamFrame, clearCamFrame
    ;(function()
        local TweenService = game:GetService("TweenService")
        local _camGui, _vgFrames, _lbTop, _lbBot, _dof = nil, nil, nil, nil, nil
        local C_BLACK_FRAME = Color3.new(0, 0, 0)
        local function ensureCamGui()
            if _camGui and _camGui.Parent then return _camGui end
            local g = Instance.new("ScreenGui")
            g.Name = "_vs_cam"
            g.IgnoreGuiInset = true; g.ResetOnSpawn = false
            g.DisplayOrder = 990
            local ok = pcall(function() g.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
            if not ok or not g.Parent then
                pcall(function() g.Parent = lp:FindFirstChildOfClass("PlayerGui") end)
            end
            _camGui = g
            return g
        end
        local VG_SIDES = {
            { size = UDim2.new(1, 0, 0.24, 0),  pos = UDim2.new(0, 0, 0, 0),     rot = 90  },
            { size = UDim2.new(1, 0, 0.24, 0),  pos = UDim2.new(0, 0, 0.76, 0),  rot = 270 },
            { size = UDim2.new(0.17, 0, 1, 0),  pos = UDim2.new(0, 0, 0, 0),     rot = 0   },
            { size = UDim2.new(0.17, 0, 1, 0),  pos = UDim2.new(0.83, 0, 0, 0),  rot = 180 },
        }
        local function vgApply()
            local on = Config.Visuals and cfg("VisualsVignette", false)
            if not on then
                if _vgFrames then
                    for i = 1, #_vgFrames do _vgFrames[i].Visible = false end
                end
                return
            end
            if not _vgFrames then
                local g = ensureCamGui()
                _vgFrames = {}
                for i = 1, #VG_SIDES do
                    local s = VG_SIDES[i]
                    local f = Instance.new("Frame")
                    f.Name = "_cv" .. i
                    f.BackgroundColor3 = C_BLACK_FRAME; f.BorderSizePixel = 0
                    f.Size = s.size; f.Position = s.pos; f.Visible = false; f.ZIndex = 1
                    local grad = Instance.new("UIGradient")
                    grad.Rotation = s.rot
                    grad.Transparency = NumberSequence.new(0, 1)
                    grad.Parent = f
                    f.Parent = g
                    _vgFrames[i] = f
                end
            end
            local tr = 1 - 0.85 * math.clamp(cfg("VisualsVignetteStrength", 0.6), 0, 1)
            for i = 1, #_vgFrames do
                local f = _vgFrames[i]
                f.BackgroundTransparency = tr; f.Visible = true
            end
        end
        local LB_TI = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local function lbApply(animate)
            local on = Config.Visuals and cfg("VisualsLetterbox", false)
            if not on and not _lbTop then return end
            if not _lbTop then
                local g = ensureCamGui()
                for i = 1, 2 do
                    local f = Instance.new("Frame")
                    f.Name = "_clb" .. i
                    f.BackgroundColor3 = C_BLACK_FRAME; f.BackgroundTransparency = 0
                    f.BorderSizePixel = 0; f.ZIndex = 2
                    f.Parent = g
                    if i == 1 then _lbTop = f else _lbBot = f end
                end
                _lbTop.Position = UDim2.new(0, 0, -0.2, 0)
                _lbBot.Position = UDim2.new(0, 0, 1, 0)
            end
            local sz = math.clamp(cfg("VisualsLetterboxSize", 0.10), 0.04, 0.18)
            local topP = on and UDim2.new(0, 0, 0, 0)      or UDim2.new(0, 0, -sz - 0.02, 0)
            local botP = on and UDim2.new(0, 0, 1 - sz, 0) or UDim2.new(0, 0, 1.02, 0)
            _lbTop.Size = UDim2.new(1, 0, sz, 0); _lbBot.Size = UDim2.new(1, 0, sz, 0)
            if animate then
                pcall(function()
                    TweenService:Create(_lbTop, LB_TI, { Position = topP }):Play()
                    TweenService:Create(_lbBot, LB_TI, { Position = botP }):Play()
                end)
            else
                _lbTop.Position = topP; _lbBot.Position = botP
            end
        end
        local function dofApply()
            local on = Config.Visuals and not Config.VisualsPerformanceMode and cfg("VisualsDOF", false)
            if not on then
                if _dof then pcall(function() _dof:Destroy() end); _dof = nil end
                return
            end
            if not (_dof and _dof.Parent) then
                local d = Instance.new("DepthOfFieldEffect")
                d.Name = "_vs_dof"; d:SetAttribute("VS_DoF", true)
                d.InFocusRadius = 22
                d.Parent = Lighting
                _dof = d
            end
            local blur = math.clamp(cfg("VisualsDOFBlur", 0.5), 0, 1)
            pcall(function()
                _dof.FocusDistance = math.clamp(cfg("VisualsDOFDistance", 28), 5, 100)
                _dof.FarIntensity  = 0.75 * blur
                _dof.NearIntensity = 0.5  * blur
            end)
        end
        applyCamFrame = function(animate) vgApply(); lbApply(animate); dofApply() end
        clearCamFrame = function()
            if _camGui then pcall(function() _camGui:Destroy() end) end
            _camGui, _vgFrames, _lbTop, _lbBot = nil, nil, nil, nil
            if _dof then pcall(function() _dof:Destroy() end); _dof = nil end
        end
        function Visuals.setVignette(on) Config.VisualsVignette = on; vgApply() end
        function Visuals.setVignetteStrength(v)
            Config.VisualsVignetteStrength = math.clamp(v, 0, 1); vgApply()
        end
        function Visuals.setLetterbox(on) Config.VisualsLetterbox = on; lbApply(true) end
        function Visuals.setLetterboxSize(v)
            Config.VisualsLetterboxSize = math.clamp(v, 0.04, 0.18); lbApply(false)
        end
        function Visuals.setDOF(on) Config.VisualsDOF = on; dofApply() end
        function Visuals.setDOFDistance(v)
            Config.VisualsDOFDistance = math.clamp(v, 5, 100); dofApply()
        end
        function Visuals.setDOFBlur(v)
            Config.VisualsDOFBlur = math.clamp(v, 0, 1); dofApply()
        end
    end)()
    local _fovSaved = nil
    local _tpRP = nil
    local function bindStretch()
        if _stretchBound then return end
        _stretchBound = true
        RunService:BindToRenderStep("VS_Stretch", Enum.RenderPriority.Last.Value, function()
            if not Config.Visuals then return end
            if Config.Rage then return end
            local s = Config.VisualsStretch
            local doStretch = math.abs(s - 1.0) >= 0.001
            local doSway = Config.VisualsCameraSway
            local doAspect = Config.CameraAspectRatioEnabled
            local doThird  = Config.ThirdPersonEnabled
            if Config.CameraFovOverride then
                local want = math.clamp(Config.CameraFovAmount or 90, 40, 130)
                if _fovSaved == nil then _fovSaved = Camera.FieldOfView end
                if Camera.FieldOfView ~= want then Camera.FieldOfView = want end
            elseif _fovSaved ~= nil then
                Camera.FieldOfView = _fovSaved; _fovSaved = nil
            end
            if not (doStretch or doSway or doAspect or doThird) then return end
            local c = Camera.CFrame
            if doSway then
                local amt = math.clamp(Config.VisualsCameraSwayAmount or 0.5, 0, 1)
                local t = tick()
                local roll  = (math.sin(t * 0.9) + math.sin(t * 0.37) * 0.6) * amt
                local pitch =  math.sin(t * 1.3) * 0.7 * amt
                local yaw   =  math.sin(t * 0.7) * 0.8 * amt
                c = c * CFrame.Angles(math.rad(pitch), math.rad(yaw), math.rad(roll))
            end
            if doStretch then
                c = CFrame.fromMatrix(c.Position, c.RightVector * s, c.UpVector)
            end
            if doAspect then
                local rx = math.clamp(Config.CameraAspectRatioX or 4, 1, 21)
                local ry = math.clamp(Config.CameraAspectRatioY or 3, 1, 21)
                c = CFrame.fromMatrix(c.Position, c.RightVector * (rx / ry), c.UpVector)
            end
            if doThird and lp.Character then
                local dist = math.clamp(Config.ThirdPersonDistance or 12, 4, 30)
                local desiredPos = c.Position - c.LookVector * dist
                if _tpRP == nil then
                    _tpRP = RaycastParams.new()
                    _tpRP.FilterType = Enum.RaycastFilterType.Exclude
                end
                _tpRP.FilterDescendantsInstances = { lp.Character }
                local hit = Workspace:Raycast(c.Position, -c.LookVector * dist, _tpRP)
                if hit then desiredPos = hit.Position + c.LookVector * 0.5 end
                c = (c - c.Position) + desiredPos
            end
            Camera.CFrame = c
        end)
    end
    local _vmConn = nil
    local _vmSaved = {}
    local VM_MATERIALS = {
        ForceField = Enum.Material.ForceField, Neon = Enum.Material.Neon,
        Glass = Enum.Material.Glass, SmoothPlastic = Enum.Material.SmoothPlastic,
    }
    local function vmWanted()
        return Config.VMOffsetEnabled or Config.VMChamsEnabled or Config.VMDisableTextures
    end
    local function vmSave(obj, isPart)
        if _vmSaved[obj] ~= nil then return end
        local s = {}
        pcall(function()
            s.Transparency = obj.Transparency
            if isPart then s.Material = obj.Material; s.Color = obj.Color end
        end)
        _vmSaved[obj] = s
    end
    local function vmRestore()
        for obj, s in pairs(_vmSaved) do
            pcall(function()
                if obj.Parent == nil then return end
                if s.Material ~= nil then obj.Material = s.Material end
                if s.Color ~= nil then obj.Color = s.Color end
                if s.Transparency ~= nil then obj.Transparency = s.Transparency end
            end)
            _vmSaved[obj] = nil
        end
    end
    local function bindViewModel()
        if _vmConn or not vmWanted() then return end
        _vmConn = RunService.RenderStepped:Connect(function()
            if not vmWanted() then return end
            local wep = getEquippedItem and getEquippedItem()
            local vm = wep and wep.ViewModel
            local model = vm and (vm.Model or vm._model)
            if not model or not model.PrimaryPart then return end
            if Config.VMOffsetEnabled then
                local off = CFrame.new(Config.VMOffsetX or 0, Config.VMOffsetY or 0, Config.VMOffsetZ or 0)
                    * CFrame.Angles(math.rad(Config.VMOffsetPitch or 0), math.rad(Config.VMOffsetYaw or 0), math.rad(Config.VMOffsetRoll or 0))
                model.PrimaryPart.CFrame = model.PrimaryPart.CFrame * off
            end
            if Config.VMChamsEnabled or Config.VMDisableTextures then
                local mat = VM_MATERIALS[Config.VMChamsMaterial] or Enum.Material.ForceField
                local col = Config.VMChamsColor or Color3.fromRGB(53, 215, 199)
                local tr  = Config.VMChamsTransparency or 0.5
                for _, p in ipairs(model:GetDescendants()) do
                    if p:IsA("BasePart") then
                        if Config.VMChamsEnabled then
                            vmSave(p, true)
                            if p.Material ~= mat then p.Material = mat end
                            if p.Color ~= col then p.Color = col end
                            if p.Transparency ~= tr then p.Transparency = tr end
                        end
                    elseif Config.VMDisableTextures and (p:IsA("Decal") or p:IsA("Texture")) then
                        vmSave(p, false)
                        if p.Transparency ~= 1 then p.Transparency = 1 end
                    end
                end
            end
        end)
    end
    local function unbindViewModel()
        if _vmConn then pcall(function() _vmConn:Disconnect() end); _vmConn = nil end
        vmRestore()
    end
    local function refreshViewModel()
        if vmWanted() then bindViewModel() else unbindViewModel() end
    end
    local _spooferActive = false
    local _spooferConns = {}
    local _isSpoofing = {}
    local _origText = {}
    local function anySpoofOn()
        return Config.SpooferNameEnabled or Config.SpooferLevelEnabled or Config.SpooferCasualWinsEnabled
            or Config.SpooferRankedWinsEnabled or Config.SpooferRankedEloEnabled
            or Config.SpooferWinPercentEnabled or Config.SpooferWinStreakEnabled
            or Config.SpooferFavoriteMapEnabled
    end
    local function escPat(s) return (s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")) end
    local function escRep(s) return (s:gsub("%%", "%%%%")) end
    local function belongsToLp(obj)
        local node, depth = obj, 0
        while node ~= nil and node ~= game and depth < 12 do
            if node:IsA("BillboardGui") then
                local anchor = node.Adornee or node.Parent
                while anchor ~= nil and not anchor:IsA("Model") do anchor = anchor.Parent end
                if anchor ~= nil then
                    local plr = Players:GetPlayerFromCharacter(anchor)
                    if plr ~= nil then return plr == lp end
                end
            elseif node:IsA("Model") then
                local plr = Players:GetPlayerFromCharacter(node)
                if plr ~= nil then return plr == lp end
            end
            local asId = tonumber(node.Name)
            if asId ~= nil and Players:GetPlayerByUserId(asId) ~= nil then return asId == lp.UserId end
            node = node.Parent; depth = depth + 1
        end
        return true
    end
    local ALLOWED_TEXT_NAMES = {
        DisplayName = true, Username = true, Name = true, Handle = true, Nametag = true,
        Title = true, TitleText = true, Value = true, Text = true, Label = true,
        Wins = true, WinRate = true, Streak = true, WinStreak = true, ELO = true, Level = true,
    }
    local function applyTextSpoof(obj)
        if not (obj and obj.Parent) then return end
        if _isSpoofing[obj] then return end
        local text = obj.Text
        if not text or #text == 0 then return end
        local newText = text
        local changed = false
        if Config.SpooferNameEnabled then
            local fakeName = Config.SpooferName or "ProPlayer"
            local fakeDisp = Config.SpooferDisplayName or fakeName
            local realName = lp.Name
            local realDisp = lp.DisplayName
            if realDisp and #realDisp > 0 and newText:find(realDisp, 1, true) then
                newText = newText:gsub(escPat(realDisp), escRep(fakeDisp))
                changed = true
            end
            if realName and #realName > 0 and newText:find(realName, 1, true) then
                newText = newText:gsub(escPat(realName), escRep(fakeName))
                changed = true
            end
        end
        local pn = obj.Parent and obj.Parent.Name or ""
        local on = obj.Name
        local isVal = (on == "Value" or on == "Text")
        local is_level = (pn == "Level" or pn == "LevelContainer") and (isVal or on == "Level")
        local is_wins = (on == "Wins" or pn == "Wins" or pn == "WinsContainer") and (isVal or on == "Wins")
        local is_elo = (pn == "ELO" or pn == "RankedElo" or pn == "Rating" or pn == "Rank") and (isVal or on == "ELO")
        local is_winrate = (on == "WinRate" or on == "win rate" or pn == "WinRate") and (isVal or on == "WinRate")
        local is_streak = (pn == "Streak" or pn == "WinStreak" or pn == "StreakContainer" or on == "Streak" or on == "WinStreak")
            and (isVal or on == "Streak" or on == "WinStreak")
        if (is_level or is_wins or is_elo or is_winrate or is_streak) and belongsToLp(obj) then
            local sVal = nil
            if Config.SpooferLevelEnabled and is_level then sVal = tostring(Config.SpooferLevel or 100)
            elseif Config.SpooferCasualWinsEnabled and is_wins then sVal = tostring(Config.SpooferCasualWins or 500)
            elseif Config.SpooferRankedEloEnabled and is_elo then sVal = tostring(Config.SpooferRankedElo or 2400)
            elseif Config.SpooferWinPercentEnabled and is_winrate then sVal = tostring(Config.SpooferWinPercent or 75) .. "%"
            elseif Config.SpooferWinStreakEnabled and is_streak then sVal = tostring(Config.SpooferWinStreak or 25)
            end
            if sVal ~= nil and newText ~= sVal then newText = sVal; changed = true end
        end
        if changed and newText ~= text then
            if _origText[obj] == nil then _origText[obj] = text end
            _isSpoofing[obj] = true
            pcall(function() obj.Text = newText end)
            _isSpoofing[obj] = nil
        end
    end
    local function registerTextObj(obj)
        if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
        if _spooferConns[obj] ~= nil then return end
        local txt = nil
        pcall(function() txt = obj.Text end)
        local mine = type(txt) == "string" and #txt > 0
            and ((#lp.Name > 0 and txt:find(lp.Name, 1, true) ~= nil)
              or (#lp.DisplayName > 0 and txt:find(lp.DisplayName, 1, true) ~= nil))
        if not ALLOWED_TEXT_NAMES[obj.Name] and not mine then return end
        applyTextSpoof(obj)
        _spooferConns[obj] = obj:GetPropertyChangedSignal("Text"):Connect(function() applyTextSpoof(obj) end)
        obj.Destroying:Once(function()
            local c = _spooferConns[obj]
            if c ~= nil then pcall(function() c:Disconnect() end) end
            _spooferConns[obj] = nil; _origText[obj] = nil; _isSpoofing[obj] = nil
        end)
    end
    local function stopGuiNameSpoofer()
        for k, c in pairs(_spooferConns) do
            pcall(function() c:Disconnect() end)
            _spooferConns[k] = nil
        end
        for obj, t in pairs(_origText) do
            pcall(function()
                if obj.Parent ~= nil then
                    _isSpoofing[obj] = true; obj.Text = t; _isSpoofing[obj] = nil
                end
            end)
            _origText[obj] = nil
        end
        _isSpoofing = {}
        _spooferActive = false
    end
    local function startGuiNameSpoofer()
        if _spooferActive or not anySpoofOn() then return end
        _spooferActive = true
        local pGui = lp:FindFirstChildOfClass("PlayerGui")
        if pGui then
            for _, inst in ipairs(pGui:GetDescendants()) do registerTextObj(inst) end
            _spooferConns["pGuiDesc"] = pGui.DescendantAdded:Connect(registerTextObj)
        end
        pcall(function()
            local cGui = cloneref(game:GetService("CoreGui"))
            if cGui then
                for _, inst in ipairs(cGui:GetDescendants()) do registerTextObj(inst) end
                _spooferConns["cGuiDesc"] = cGui.DescendantAdded:Connect(registerTextObj)
            end
        end)
        if Config.SpooferNameEnabled then
            _spooferConns["wsDesc"] = Workspace.DescendantAdded:Connect(function(inst)
                if inst:IsA("BillboardGui") or inst:IsA("SurfaceGui") then
                    for _, child in ipairs(inst:GetDescendants()) do registerTextObj(child) end
                    if _spooferConns[inst] == nil then
                        _spooferConns[inst] = inst.DescendantAdded:Connect(registerTextObj)
                    end
                end
            end)
        end
    end
    local function refreshGuiNameSpoofer()
        if not anySpoofOn() then stopGuiNameSpoofer(); return end
        if not _spooferActive then startGuiNameSpoofer(); return end
        for obj in pairs(_spooferConns) do
            if typeof(obj) == "Instance" then pcall(applyTextSpoof, obj) end
        end
    end
    local _pinnedAttrs = {}
    local _pinConns = {}
    local function pinAttr(attrName, val)
        _pinnedAttrs[attrName] = val
        if not _pinConns[attrName] then
            _pinConns[attrName] = lp:GetAttributeChangedSignal(attrName):Connect(function()
                local targetVal = _pinnedAttrs[attrName]
                if targetVal ~= nil and lp:GetAttribute(attrName) ~= targetVal then
                    pcall(function() lp:SetAttribute(attrName, targetVal) end)
                end
            end)
        end
        pcall(function() lp:SetAttribute(attrName, val) end)
    end
    local function unpinAttr(attrName)
        _pinnedAttrs[attrName] = nil
        if _pinConns[attrName] then
            _pinConns[attrName]:Disconnect()
            _pinConns[attrName] = nil
        end
    end
    local function unpinAll()
        local names = {}
        for k in pairs(_pinConns) do names[#names + 1] = k end
        for _, k in ipairs(names) do unpinAttr(k) end
    end
    local function updatePlayerSpoofer()
        if not anySpoofOn() then unpinAll(); return end
        pcall(function()
            local PDC = Rivals and Rivals.PlayerDataController
            if not PDC then
                pcall(function()
                    local scr = lp:FindFirstChild("PlayerScripts")
                    local ctrls = scr and scr:FindFirstChild("Controllers")
                    local pdcMod = ctrls and ctrls:FindFirstChild("PlayerDataController")
                    if pdcMod then PDC = require(pdcMod) end
                end)
            end
            local cData = PDC and PDC.CurrentData and PDC.CurrentData.Data
            local sLev = tonumber(Config.SpooferLevel) or 100
            local sElo = tonumber(Config.SpooferRankedElo) or 2400
            local sCWins = tonumber(Config.SpooferCasualWins) or 500
            local sRWins = tonumber(Config.SpooferRankedWins) or 250
            local sWP = (tonumber(Config.SpooferWinPercent) or 75) / 100
            local sStreak = tonumber(Config.SpooferWinStreak) or 25
            local sMap = tostring(Config.SpooferFavoriteMap or "Arena")
            if Config.SpooferLevelEnabled then
                pinAttr("Level", sLev)
                if cData then cData.Level = sLev end
            else
                unpinAttr("Level")
            end
            if Config.SpooferRankedEloEnabled then
                pinAttr("DisplayELO", sElo)
                pinAttr("RankedCurrentELO", sElo)
                if cData then
                    cData.RankedCurrentELO = sElo
                    if cData.Seasons then
                        for _, season in pairs(cData.Seasons) do
                            if season.RankedPerformances then
                                for _, perf in pairs(season.RankedPerformances) do
                                    perf.CurrentELO = sElo
                                end
                            end
                        end
                    end
                end
            else
                unpinAttr("DisplayELO")
                unpinAttr("RankedCurrentELO")
            end
            if Config.SpooferCasualWinsEnabled then
                pinAttr("CasualWins", sCWins)
                pinAttr("StatisticDuelsWins", sCWins)
                if cData then cData.CasualWins = sCWins end
            else
                unpinAttr("CasualWins")
                unpinAttr("StatisticDuelsWins")
            end
            if Config.SpooferRankedWinsEnabled then
                pinAttr("RankedWins", sRWins)
                if cData then cData.RankedWins = sRWins end
            else
                unpinAttr("RankedWins")
            end
            if Config.SpooferWinPercentEnabled then
                pinAttr("CasualWinPercent", sWP)
                pinAttr("RankedWinPercent", sWP)
                pinAttr("StatisticDuelsWinRate", sWP * 100)
                pinAttr("WinRate", sWP * 100)
                if cData then
                    cData.CasualWinPercent = sWP
                    cData.RankedWinPercent = sWP
                end
            else
                unpinAttr("CasualWinPercent")
                unpinAttr("RankedWinPercent")
                unpinAttr("StatisticDuelsWinRate")
                unpinAttr("WinRate")
            end
            if Config.SpooferWinStreakEnabled then
                pinAttr("StatisticDuelsWinStreak", sStreak)
                pinAttr("WinStreak", sStreak)
                pinAttr("CurrentWinStreak", sStreak)
                if cData then
                    cData.StatisticDuelsWinStreak = sStreak
                    cData.WinStreak = sStreak
                    cData.CurrentWinStreak = sStreak
                end
            else
                unpinAttr("StatisticDuelsWinStreak")
                unpinAttr("WinStreak")
                unpinAttr("CurrentWinStreak")
            end
            if Config.SpooferFavoriteMapEnabled then
                pinAttr("FavoriteMap", sMap)
                if cData then cData.FavoriteMap = sMap end
            else
                unpinAttr("FavoriteMap")
            end
            pcall(function()
                local scr = lp:FindFirstChild("PlayerScripts")
                local ctrls = scr and scr:FindFirstChild("Controllers")
                local lcMod = ctrls and ctrls:FindFirstChild("LeaderboardController")
                local LC = lcMod and require(lcMod)
                if LC and LC.LeaderboardSerials then
                    local uid = lp.UserId
                    local function insertOrUpdate(list, val)
                        if not list then return end
                        for i = #list, 1, -1 do
                            local p = list[i]
                            if p and (p.UserId == uid or p.UserID == uid or p.PlayerId == uid) then
                                table.remove(list, i)
                            end
                        end
                        table.insert(list, 1, { key = tostring(uid), value = val, UserId = uid })
                    end
                    if Config.SpooferLevelEnabled and LC.LeaderboardSerials["Highest Level"] then
                        insertOrUpdate(LC.LeaderboardSerials["Highest Level"].Players, sLev)
                        if LC.Refreshed then LC.Refreshed:Fire("Highest Level") end
                    end
                    if Config.SpooferRankedEloEnabled and LC.LeaderboardSerials["Highest ELO"] then
                        insertOrUpdate(LC.LeaderboardSerials["Highest ELO"].Players, sElo)
                        if LC.Refreshed then LC.Refreshed:Fire("Highest ELO") end
                    end
                    if Config.SpooferCasualWinsEnabled and LC.LeaderboardSerials["Most Wins"] then
                        insertOrUpdate(LC.LeaderboardSerials["Most Wins"].Players, sCWins)
                        if LC.Refreshed then LC.Refreshed:Fire("Most Wins") end
                    end
                    if Config.SpooferWinStreakEnabled and LC.LeaderboardSerials["Current Highest Win Streak"] then
                        insertOrUpdate(LC.LeaderboardSerials["Current Highest Win Streak"].Players, sStreak)
                        if LC.Refreshed then LC.Refreshed:Fire("Current Highest Win Streak") end
                    end
                end
            end)
        end)
    end
    function Visuals.setStretch(v)
        Config.VisualsStretch = math.clamp(v, Config.VisualsStretchMin, Config.VisualsStretchMax)
    end
    local function startRainbow()
        if _rainbowConn then return end
        _rainbowBatchIdx = 1; table.clear(_rainbowParts)
        local charSet = {}
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Character then charSet[pl.Character] = true end
        end
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("BasePart") and not d:GetAttribute("VS_Holo")
                and not charSet[d.Parent]
                and d.Name ~= "Terrain" then
                table.insert(_rainbowParts, { part = d, originalColor = d.Color })
            end
        end
        _rainbowConn = RunService.Heartbeat:Connect(function(dt)
            if not Config.Visuals or not Config.VisualsRainbowMap then return end
            _rainbowHue = (_rainbowHue + dt * Config.VisualsRainbowMapSpeed) % 1
            local total = #_rainbowParts; if total == 0 then return end
            local batch = math.min(250, total)
            for i = 1, batch do
                local idx = ((_rainbowBatchIdx - 1 + i - 1) % total) + 1
                local e   = _rainbowParts[idx]
                if e and e.part and e.part.Parent then
                    e.part.Color = Color3.fromHSV((_rainbowHue + (idx / total) * 0.3) % 1, 0.85, 1)
                end
            end
            _rainbowBatchIdx = ((_rainbowBatchIdx + batch - 1) % total) + 1
        end)
    end
    local function stopRainbow()
        if _rainbowConn then _rainbowConn:Disconnect(); _rainbowConn = nil end
        for _, e in ipairs(_rainbowParts) do
            if e.part and e.part.Parent then pcall(function() e.part.Color = e.originalColor end) end
        end
        table.clear(_rainbowParts)
    end
    function Visuals.toggleRainbowMap(on)
        Config.VisualsRainbowMap = on
        if on and Config.Visuals then startRainbow() else stopRainbow() end
    end
    local function applyPerf()
        if not _perfBackup then
            _perfBackup = {
                GlobalShadows = Lighting.GlobalShadows,
                EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
                EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
                Brightness = Lighting.Brightness,
                ShadowSoftness = Lighting.ShadowSoftness,
            }
        end
        clearTagged(); clearGrade(); clearBloom()
        Lighting.GlobalShadows = false; Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0; Lighting.Brightness = 2
        Lighting.ShadowSoftness = 0
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("ParticleEmitter") and not d:GetAttribute("VS_Holo") then
                if not _origParticleRates[d] then _origParticleRates[d] = d.Rate end
                d.Rate = 0
            end
        end
    end
    local function disablePerf()
        if _perfBackup then
            for k, v in pairs(_perfBackup) do pcall(function() Lighting[k] = v end) end
            _perfBackup = nil
        end
        for em, rate in pairs(_origParticleRates) do
            if em and em.Parent then pcall(function() em.Rate = rate end) end
        end
        table.clear(_origParticleRates)
        if State.VisualsCurrentPreset then applyPreset(State.VisualsCurrentPreset) end
    end
    function Visuals.togglePerf(on)
        Config.VisualsPerformanceMode = on
        if on then applyPerf() else disablePerf() end
        applyCamFrame(false)
    end
    function Visuals.setPreset(name)
        if Presets[name] then
            Config.VisualsPreset = name
            applyPreset(name)
        end
    end
    function Visuals.toggleHolograms(on) Config.VisualsHolograms = on end
    function Visuals.setHologramStyle(name) Config.VisualsHologramStyle = name end
    Visuals.HologramStyleOrder = { "Orb", "Skeleton", "Wraith" }
    Visuals.GradeOrder = { "None", "Crisp", "Cold", "Warm", "Comp" }
    function Visuals.setGrade(name)
        Config.VisualsGrade = name
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        reassertGrade()
    end
    function Visuals.setGradeStrength(v)
        Config.VisualsGradeStrength = math.clamp(v, 0, 1)
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        reassertGrade()
    end
    function Visuals.setBloom(on)
        Config.VisualsBloom = on
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        reassertBloom()
    end
    function Visuals.setBloomIntensity(v)
        Config.VisualsBloomIntensity = math.clamp(v, 0, 3)
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        reassertBloom()
    end
    function Visuals.toggleFullbright(on)
        Config.VisualsFullbright = on
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        if on then applyFullbrightOverride()
        else applyPreset(State.VisualsCurrentPreset or Config.VisualsPreset or "Neutral") end
    end
    function Visuals.toggleNoFog(on)
        Config.VisualsNoFog = on
        if not Config.Visuals or Config.VisualsPerformanceMode then return end
        if on then applyFogOverride()
        else applyPreset(State.VisualsCurrentPreset or Config.VisualsPreset or "Neutral") end
    end
    function Visuals.enableHUD()  Config.HUD = true;  FX.start() end
    function Visuals.disableHUD() Config.HUD = false; FX.stop()  end
    Visuals.updatePlayerSpoofer = updatePlayerSpoofer
    Visuals.applyGuiNameSpoof = refreshGuiNameSpoofer
    Visuals.refreshViewModel = refreshViewModel
    function Visuals.init()
        snapshotLighting()
        if Config.Visuals then bindStretch() end
        refreshViewModel()
        updatePlayerSpoofer()
        refreshGuiNameSpoofer()
    end
    function Visuals.enable()
        Config.Visuals = true; applyPreset(Config.VisualsPreset or "Neutral")
        if not Config.VisualsPerformanceMode then
            applyFullbrightOverride(); applyFogOverride()
        end
        bindStretch()
        refreshViewModel()
        updatePlayerSpoofer()
        refreshGuiNameSpoofer()
        if Config.VisualsRainbowMap then startRainbow() end
        if Config.VisualsPerformanceMode then applyPerf() end
        startReassert()
        applyCamFrame(false)
    end
    function Visuals.disable()
        Config.Visuals = false; stopRainbow(); stopReassert()
        clearGrade(); clearBloom(); clearCamFrame()
        if Config.VisualsPerformanceMode then disablePerf() end
        if _stretchBound then
            pcall(function() RunService:UnbindFromRenderStep("VS_Stretch") end)
            _stretchBound = false
        end
        restore()
    end
    function Visuals.unload()
        Visuals.disable(); stopReassert()
        FX.destroy()
        clearKillPulse()
        unbindViewModel()
        stopGuiNameSpoofer()
        unpinAll()
        if _fovSaved ~= nil then
            pcall(function() Camera.FieldOfView = _fovSaved end)
            _fovSaved = nil
        end
        if _hologramFolder then pcall(function() _hologramFolder:Destroy() end); _hologramFolder = nil end
        if _stretchBound then
            pcall(function() RunService:UnbindFromRenderStep("VS_Stretch") end)
            _stretchBound = false
        end
    end
end)()
local Weather = {}
;(function()
    local SoundService = game:GetService("SoundService")
    local TweenService = game:GetService("TweenService")
    local function cfg(key, default)
        local v = Config[key]
        if v == nil then return default end
        return v
    end
    local function iAmt()
        return math.clamp(cfg("WeatherIntensity", 1), 0.15, 2)
    end
    local function iRate(I, kLo, kHi)
        if I < 1 then
            return math.exp(kLo * (I - 1))
        end
        return math.exp(kHi * (I - 1))
    end
    local function evRate(key)
        return math.clamp(cfg(key, 1), 0.25, 3)
    end
    local IR = {
        Snow      = { lo = 1.75, hi = 0.85, acc = 0.45, sz = 0.08, alp = 0.35, gst = 0.30 },
        Petals    = { lo = 1.75, hi = 0.85, acc = 0.40, sz = 0.08, alp = 0.30, gst = 0.30 },
        Autumn    = { lo = 1.75, hi = 0.85, acc = 0.40, sz = 0.08, alp = 0.30, gst = 0.30 },
        Mist      = { lo = 1.35, hi = 1.10, acc = 0.30, sz = 0.25, alp = 0.75, gst = 0.20 },
        Ash       = { lo = 1.45, hi = 1.05, acc = 0.35, sz = 0.15, alp = 0.55, gst = 0.20 },
        Sandstorm = { lo = 1.35, hi = 1.60, acc = 0.45, sz = 0.30, alp = 0.75, gst = 0.20 },
        Embers    = { lo = 1.45, hi = 1.05, acc = 0.30, sz = 0.10, alp = 0.25, gst = 0.20 },
        Fireflies = { lo = 1.45, hi = 1.00, acc = 0.10, sz = 0.08, alp = 0.20, gst = 0.15 },
    }
    local IR_DEF = { lo = 1.6, hi = 0.9, acc = 0.3, sz = 0.10, alp = 0.25, gst = 0.25 }
    local SET_LO, SET_HI = 0.75, 0.45
    local Vec   = Vector3.new
    local WHITE = Color3.new(1, 1, 1)
    local TX_SOFT  = "rbxasset://textures/particles/smoke_main.dds"
    local TX_SPARK = "rbxasset://textures/particles/sparkles_main.dds"
    local TX_FLAKE    = "rbxassetid://101749163393113"
    local TX_SNOWSOFT = "rbxassetid://78582616787441"
    local TX_PUFF     = "rbxassetid://77935321198144"
    local TX_PETAL    = "rbxassetid://243344623"
    local TX_LEAFA    = "rbxassetid://8590047664"
    local TX_LEAFB    = "rbxassetid://5970677338"
    local TX_LEAFC    = "rbxassetid://9239040931"
    local TX_DUST     = "rbxassetid://341828512"
    local _curType = nil
    local Wind = { x = 0, z = 0 }
    ;(function()
        local baseAng = math.random() * 6.283
        local gustT0, gustDur, gustAmp = 0, 1, 0
        local nextGustT = math.huge
        local cbs = {}
        function Wind.onGust(fn)
            cbs[#cbs + 1] = fn
        end
        function Wind.reset(now)
            nextGustT = now + 8 + math.random() * 17
            gustT0, gustAmp = 0, 0
            Wind.x, Wind.z = 0, 0
        end
        function Wind.update(now)
            if now >= nextGustT then
                gustT0 = now
                gustDur = 2 + math.random() * 2
                gustAmp = 1 + math.random()
                nextGustT = now + 8 + math.random() * 17
                for i = 1, #cbs do
                    pcall(cbs[i], gustDur, 1 + gustAmp)
                end
            end
            local ang = baseAng + 0.6 * math.sin(now * 0.013) + 0.9 * math.sin(now * 0.031 + 2.6)
            local str = 1 + 0.35 * math.sin(now * 0.17) + 0.22 * math.sin(now * 0.41 + 1.3)
                          + 0.15 * math.sin(now * 0.07 + 4.1)
            local ga = (now - gustT0) / gustDur
            if gustAmp > 0 and ga < 1 then
                str = str * (1 + gustAmp * math.sin(ga * math.pi))
            end
            Wind.x = math.cos(ang) * str
            Wind.z = math.sin(ang) * str
        end
        function Wind.vec()
            return Vec(Wind.x, 0, Wind.z)
        end
    end)()
    local _folder = nil
    local function getFolder()
        if _folder and _folder.Parent then return _folder end
        local f = Instance.new("Folder"); f.Name = "_wx"; f:SetAttribute("WX_Custom", true)
        f.Parent = Workspace
        _folder = f; return f
    end
    local _rain = { drops = {}, conn = nil, folder = nil, dir = nil, applied = nil }
    local RAIN_DIR      = Vec(-0.16, -1, 0.05).Unit
    local RAIN_LEAN_K   = 0.12
    local RAIN_LEAN_MAX = 0.2126
    local RAIN_RADIUS = 70
    local RAIN_TOP    = 70
    local RAIN_BOT    = -28
    local RAIN_MAX    = 420
    local function rainFolder()
        if _rain.folder and _rain.folder.Parent then return _rain.folder end
        local f = Instance.new("Folder"); f.Name = "_wxRain"; f:SetAttribute("WX_Custom", true)
        f.Parent = getFolder()
        _rain.folder = f; return f
    end
    local function makeDrop(parent, streakLen, width, color, glow, transp)
        local part = Instance.new("Part")
        part.Anchored = true; part.CanCollide = false; part.CanQuery = false; part.CanTouch = false
        part.CastShadow = false; part.Massless = true; part.Transparency = 1; part.Size = Vec(0.05,0.05,0.05)
        part:SetAttribute("WX_Custom", true)
        local a0 = Instance.new("Attachment"); a0.Parent = part
        local a1 = Instance.new("Attachment"); a1.Position = _rain.dir * streakLen; a1.Parent = part
        local beam = Instance.new("Beam")
        beam.Attachment0 = a0; beam.Attachment1 = a1
        beam.Segments = 1; beam.FaceCamera = true
        beam.Width0 = width; beam.Width1 = width * 0.55
        local emission = 0.35
        if glow then
            emission = 1
        end
        beam.LightEmission = emission
        beam.LightInfluence = 0
        beam.Color = ColorSequence.new(color)
        beam.Transparency = NumberSequence.new(transp)
        beam.Parent = part
        part.Parent = parent
        return part, a1, beam
    end
    local function seedDrop(d, camPos)
        local ang = math.random() * math.pi * 2
        local rad = math.sqrt(math.random()) * RAIN_RADIUS
        local y   = camPos.Y + RAIN_TOP - math.random() * (RAIN_TOP - RAIN_BOT)
        d.pos = Vec(camPos.X + math.cos(ang) * rad, y, camPos.Z + math.sin(ang) * rad)
    end
    local function newDrop(folder, i, camPos)
        local base, width, color, transp, spd0
        if (i % 3) ~= 0 then
            base, width, transp = 5 + math.random() * 3, 0.10, 0.22
            spd0 = 150 + math.random() * 30
            color = Color3.fromRGB(180, 202, 232)
        else
            base, width, transp = 3 + math.random() * 2, 0.06, 0.55
            spd0 = 120 + math.random() * 30
            color = Color3.fromRGB(158, 182, 214)
        end
        local part, a1, beam = makeDrop(folder, base, width, color, false, transp)
        local d = { part = part, a1 = a1, beam = beam, base = base, len = base,
                    w0 = width, t0 = transp, spd0 = spd0, spd = spd0 }
        seedDrop(d, camPos)
        part.CFrame = CFrame.new(d.pos)
        return d
    end
    local function tuneRain()
        local folder = rainFolder()
        local I = iAmt()
        local n = math.clamp(math.floor(150 * iRate(I, 1.75, 0.85)), 16, RAIN_MAX)
        local drops = _rain.drops
        local camPos = Vec(0, 0, 0)
        if Camera then
            camPos = Camera.CFrame.Position
        end
        for i = #drops, n + 1, -1 do
            drops[i].part:Destroy()
            drops[i] = nil
        end
        for i = #drops + 1, n do
            drops[i] = newDrop(folder, i, camPos)
        end
        local sm = 0.55 + 0.45 * I
        local wm = 0.85 + 0.15 * I
        local am = 0.78 + 0.22 * I
        local dir = _rain.applied or _rain.dir or RAIN_DIR
        for i = 1, n do
            local d = drops[i]
            d.spd = d.spd0 * sm
            d.len = d.base * sm
            d.a1.Position = dir * d.len
            local w = d.w0 * wm
            d.beam.Width0 = w
            d.beam.Width1 = w * 0.55
            d.beam.Transparency = NumberSequence.new(math.clamp(1 - (1 - d.t0) * am, 0.02, 1))
        end
    end
    local function buildRain()
        if _rain.folder then pcall(function() _rain.folder:Destroy() end); _rain.folder = nil end
        table.clear(_rain.drops)
        if not _rain.dir then _rain.dir = RAIN_DIR end
        _rain.applied = _rain.dir
        tuneRain()
    end
    local function startRain()
        if _rain.conn then return end
        _rain.conn = RunService.Heartbeat:Connect(function(dt)
            if not Config.Weather or _curType ~= "Rain" then return end
            local cam = Camera; if not cam then return end
            local camPos = cam.CFrame.Position
            local lx, lz = Wind.x * RAIN_LEAN_K, Wind.z * RAIN_LEAN_K
            local lm = math.sqrt(lx * lx + lz * lz)
            if lm > RAIN_LEAN_MAX then
                local s = RAIN_LEAN_MAX / lm
                lx, lz = lx * s, lz * s
            end
            local step = _rain.dir:Lerp(Vec(lx, -1, lz).Unit, math.min(dt * 2, 1)).Unit
            _rain.dir = step
            if (step - _rain.applied).Magnitude > 0.015 then
                _rain.applied = step
                for i = 1, #_rain.drops do
                    local d = _rain.drops[i]
                    d.a1.Position = step * d.len
                end
            end
            local r2 = RAIN_RADIUS * RAIN_RADIUS
            for i = 1, #_rain.drops do
                local d = _rain.drops[i]
                local p = d.pos + step * (d.spd * dt)
                local relX, relY, relZ = p.X - camPos.X, p.Y - camPos.Y, p.Z - camPos.Z
                if relY < RAIN_BOT or (relX * relX + relZ * relZ) > r2 then
                    seedDrop(d, camPos)
                    p = d.pos
                end
                d.pos = p
                if d.part then d.part.CFrame = CFrame.new(p) end
            end
        end)
    end
    local function stopRain()
        if _rain.conn then _rain.conn:Disconnect(); _rain.conn = nil end
        if _rain.folder then pcall(function() _rain.folder:Destroy() end); _rain.folder = nil end
        table.clear(_rain.drops)
        _rain.dir = nil; _rain.applied = nil
    end
    local ND = Enum.NormalId
    local function flutterSeq(lo, hi, n, env, flip)
        local kps = table.create(n + 1)
        for i = 0, n do
            local v = lo
            if (i + flip) % 2 == 1 then
                v = hi
            end
            kps[i + 1] = NumberSequenceKeypoint.new(i / n, v, env)
        end
        return NumberSequence.new(kps)
    end
    local PRESETS = {
        Snow = {
            { size=Vec(22,4,22), oy=5, tex=TX_FLAKE, color=WHITE,
              skeys={{0,1.7,0.35},{1,1.35,0.3}}, squash=-0.12, transp0=0.18,transp1=0.55,
              rate=0.7, speed={0.8,1.6}, life={5,7}, spread=28, rot={-60,60}, rotSpd=26,
              accel=Vec(0,-2.4,0), drag=2.2, glow=0.2, dir=ND.Bottom,
              gust={ax=1.8,az=1.2,wx=0.4,wz=0.31,ph=0.5} },
            { size=Vec(46,4,46), oy=10, tex=TX_SNOWSOFT, color=WHITE,
              skeys={{0,0.48,0.15},{1,0.38,0.10}}, squash=-0.05, transp0=0.7,transp1=0.92,
              rate=12, speed={1.5,3}, life={5,8}, spread=45, rot={-180,180}, rotSpd=10,
              accel=Vec(0,-3.5,0), drag=1.8, glow=0.12, dir=ND.Bottom,
              gust={ax=2.5,az=1.6,wx=0.37,wz=0.29,ph=0} },
            { size=Vec(140,4,140), oy=20, tex=TX_FLAKE, color=Color3.fromRGB(242,248,255),
              skeys={{0,0.5,0.2},{1,0.38,0.14}}, squash=-0.08, transp0=0.08,transp1=0.5,
              rate=190, speed={2,4}, life={7,10}, spread=50, rot={-180,180}, rotSpd=42,
              accel=Vec(0,-5,0), drag=1.7, glow=0.35, dir=ND.Bottom,
              gust={ax=2.2,az=1.4,wx=0.33,wz=0.26,ph=1.9} },
            { size=Vec(220,4,220), oy=32, tex=TX_SNOWSOFT, color=Color3.fromRGB(214,231,255),
              skeys={{0,0.3,0.08},{1,0.22,0.06}}, transp0=0.5,transp1=0.85,
              rate=265, speed={2,4}, life={8,11}, spread=55, rot={-30,30}, rotSpd=12,
              accel=Vec(0,-5.5,0), drag=1.5, glow=0.3, dir=ND.Bottom,
              gust={ax=1.5,az=1,wx=0.29,wz=0.25,ph=3.8} },
            { size=Vec(100,4,100), oy=12, tex=TX_SPARK, color=WHITE,
              skeys={{0,0.4,0.12},{1,0.32,0.1}},
              tkeys={{0,1},{0.2,0.5},{0.45,0.78},{0.62,0.42},{0.85,0.78},{1,1}},
              rate=10, speed={2,4}, life={5,8}, spread=45, rot={-180,180}, rotSpd=60,
              accel=Vec(0,-4.5,0), drag=1.6, glow=0.7, dir=ND.Bottom,
              gust={ax=2.2,az=1.4,wx=0.35,wz=0.27,ph=1} },
        },
        Mist = {
            { size=Vec(150,8,150), oy=0, tex=TX_SOFT, color=Color3.fromRGB(210,216,226),
              size0=26,size1=44, transp0=0.68,transp1=0.94,
              rate=16, speed={0.8,2.2}, life={9,13}, spread=20, rot={-5,5}, rotSpd=3,
              accel=Vec(2.2,0.25,1.2), drag=0.8, dir=ND.Top },
            { size=Vec(110,6,110), oy=1, tex=TX_SOFT, color=Color3.fromRGB(228,232,240),
              size0=12,size1=22, transp0=0.75,transp1=0.95,
              rate=10, speed={1.5,3}, life={6,9}, spread=25, rot={-8,8}, rotSpd=5,
              accel=Vec(3,0.4,1.6), drag=0.8, dir=ND.Top },
        },
        Embers = {
            { size=Vec(90,28,90), oy=2, tex=TX_SOFT, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,   Color3.fromRGB(255,170,60)),
                  ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,95,25)),
                  ColorSequenceKeypoint.new(1,   Color3.fromRGB(165,35,12)) }),
              size0=0.85,size1=0.3, transp0=0.05,transp1=0.85,
              rate=80, speed={3,7}, life={3,5}, spread=40, rot={-60,60}, rotSpd=90,
              accel=Vec(1.5,9,1), drag=1.6, glow=0.35, dir=ND.Top },
            { size=Vec(120,30,120), oy=6, tex=TX_SPARK, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(255,220,140)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(255,110,40)) }),
              size0=0.3,size1=0.08, transp0=0.05,transp1=0.9,
              rate=55, speed={2,5}, life={2.5,4}, spread=55, rot={-40,40}, rotSpd=60,
              accel=Vec(1,7,0.8), drag=1.4, glow=0.9, dir=ND.Top },
        },
        Fireflies = {
            { size=Vec(70,8,70), oy=-2, tex=TX_SNOWSOFT, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,   Color3.fromRGB(220,255,130)),
                  ColorSequenceKeypoint.new(0.5, Color3.fromRGB(205,245,100)),
                  ColorSequenceKeypoint.new(1,   Color3.fromRGB(255,200,80)) }),
              skeys={{0,0.1},{0.08,0.62,0.15},{0.45,0.5,0.1},{1,0.08}},
              tkeys={{0,1},{0.08,0.08},{0.4,0.45},{0.75,0.85},{1,1}},
              rate=18, speed={0.5,1.6}, life={2.5,4}, spread=180, rot={0,0}, rotSpd=0,
              accel=Vec(0,0.3,0), drag=2.5, glow=0.95, dir=ND.Top },
            { size=Vec(140,14,140), oy=-1, tex=TX_SNOWSOFT, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(175,225,95)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(200,190,70)) }),
              skeys={{0,0.06},{0.1,0.32,0.08},{0.5,0.26},{1,0.05}},
              tkeys={{0,1},{0.1,0.3},{0.5,0.6},{1,1}},
              rate=18, speed={0.4,1.2}, life={3,5}, spread=180, rot={0,0}, rotSpd=0,
              accel=Vec(0,0.3,0), drag=2.5, glow=0.95, dir=ND.Top },
            { size=Vec(120,4,120), oy=-4, tex=TX_PUFF, color=Color3.fromRGB(148,158,178),
              size0=13,size1=22, tkeys={{0,1},{0.2,0.8},{0.7,0.89},{1,1}},
              rate=8, speed={0.5,1.5}, life={8,12}, spread=14, rot={-180,180}, rotSpd=4,
              accel=Vec(1.2,0.12,0.7), drag=0.7, glow=0, dir=ND.Top,
              gust={ax=1.2,az=0.8,wx=0.23,wz=0.19,ph=2.2} },
        },
        Petals = {
            { size=Vec(26,6,26), oy=3, tex=TX_SNOWSOFT, zoff=3, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(255,222,232)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(250,205,220)) }),
              skeys={{0,1.75,0.5},{1,1.4,0.3}}, transp0=0.78,transp1=0.92,
              rate=7, speed={0.4,1.1}, life={5,7}, spread=30, rot={-180,180}, rotSpd=22,
              accel=Vec(0,-3,0), drag=1.7, glow=0.04, dir=ND.Bottom,
              gust={ax=2.2,az=1.5,wx=0.43,wz=0.33,ph=1.4} },
            { size=Vec(64,12,64), oy=5, tex=TX_PETAL, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,222,234)),
                  ColorSequenceKeypoint.new(0.55, Color3.fromRGB(248,178,206)),
                  ColorSequenceKeypoint.new(1,    Color3.fromRGB(226,132,176)) }),
              skeys={{0,2.05,0.5},{1,1.7,0.35}}, qseq=flutterSeq(-0.88, 0.08, 14, 0.12, 0),
              transp0=0.1,transp1=0.38,
              rate=13, speed={0.6,1.4}, life={6,8}, spread=35, rot={-180,180}, rotSpd=95,
              accel=Vec(0,-3.5,0), drag=1.6, glow=0.08, dir=ND.Bottom,
              gust={ax=2.6,az=1.8,wx=0.4,wz=0.31,ph=0.5} },
            { size=Vec(76,12,76), oy=7, tex=TX_PETAL, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,    Color3.fromRGB(250,224,200)),
                  ColorSequenceKeypoint.new(0.55, Color3.fromRGB(244,203,178)),
                  ColorSequenceKeypoint.new(1,    Color3.fromRGB(230,176,150)) }),
              skeys={{0,1.55,0.4},{1,1.28,0.28}}, qseq=flutterSeq(-0.8, 0.15, 12, 0.15, 1),
              transp0=0.14,transp1=0.44,
              rate=12, speed={0.8,1.8}, life={6,8.5}, spread=42, rot={-180,180}, rotSpd=140,
              accel=Vec(0,-3.2,0), drag=1.55, glow=0.05, dir=ND.Bottom,
              gust={ax=3,az=2,wx=0.37,wz=0.29,ph=2.1} },
            { size=Vec(130,6,130), oy=15, tex=TX_PETAL, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(255,222,234)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(246,178,204)) }),
              skeys={{0,0.85,0.26},{1,0.68,0.18}}, qseq=flutterSeq(-0.7, 0.1, 8, 0.2, 0),
              transp0=0.06,transp1=0.44,
              rate=120, speed={1.4,3}, life={7,9}, spread=48, rot={-180,180}, rotSpd=170,
              accel=Vec(0,-5.2,0), drag=1.5, glow=0.1, dir=ND.Bottom,
              gust={ax=3.2,az=2.2,wx=0.33,wz=0.26,ph=1.9} },
            { size=Vec(240,6,240), oy=26, tex=TX_PETAL, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(250,214,228)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(238,190,210)) }),
              skeys={{0,0.3,0.09},{1,0.24,0.06}}, squash=-0.5, transp0=0.42,transp1=0.8,
              rate=170, speed={1.5,3.2}, life={8,11}, spread=55, rot={-180,180}, rotSpd=90,
              accel=Vec(0,-6,0), drag=1.35, glow=0.08, dir=ND.Bottom,
              gust={ax=2.4,az=1.6,wx=0.29,wz=0.25,ph=3.8} },
            { size=Vec(56,1.2,56), oy=-3.7, tex=TX_PETAL, tag="settle",
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(255,214,228)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(240,178,204)) }),
              skeys={{0,1.1,0.3},{1,0.95,0.2}}, qseq=flutterSeq(-0.92, -0.2, 10, 0.1, 0),
              transp0=0.05,transp1=0.42,
              rate=34, speed={0.05,0.5}, life={14,20}, spread=90, rot={-180,180}, rotSpd=25,
              accel=Vec(0,-0.15,0), drag=2.6, glow=0.08, dir=ND.Bottom,
              gust={ax=3.6,az=3,wx=0.5,wz=0.44,ph=0.9} },
        },
        Autumn = {
            { size=Vec(20,6,20), oy=13, uw=8, tex=TX_LEAFA, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,    Color3.fromRGB(226,190,128)),
                  ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255,246,200)),
                  ColorSequenceKeypoint.new(1,    Color3.fromRGB(190,132,62)) }),
              skeys={{0,0.62,0.14},{1,0.54,0.10}}, qseq=flutterSeq(-0.60, 0.14, 13, 0.10, 0),
              transp0=0.08,transp1=0.42,
              rate=14, speed={0.6,1.6}, life={7,9}, spread=34, rot={-180,180}, rotSpd=130,
              accel=Vec(0,-5,0), drag=1.5, glow=0.62, dir=ND.Bottom,
              gust={ax=3.4,az=2.2,wx=0.41,wz=0.3,ph=0.5} },
            { size=Vec(22,6,22), oy=15, uw=8, tex=TX_LEAFB, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(156,74,255)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(106,46,200)) }),
              skeys={{0,0.60,0.14},{1,0.52,0.10}}, qseq=flutterSeq(-0.56, 0.20, 11, 0.14, 1),
              transp0=0.12,transp1=0.46,
              rate=9, speed={0.8,1.9}, life={7,9}, spread=40, rot={-180,180}, rotSpd=185,
              accel=Vec(0,-5.6,0), drag=1.5, glow=0.07, dir=ND.Bottom,
              gust={ax=3.9,az=2.6,wx=0.36,wz=0.27,ph=2.1} },
            { size=Vec(150,8,150), oy=16, uw=26, tex=TX_LEAFA, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,    Color3.fromRGB(226,190,128)),
                  ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255,246,200)),
                  ColorSequenceKeypoint.new(1,    Color3.fromRGB(190,132,62)) }),
              skeys={{0,0.56,0.16},{1,0.44,0.11}}, qseq=flutterSeq(-0.50, 0.10, 8, 0.16, 0),
              transp0=0.08,transp1=0.50,
              rate=24, speed={1.4,3}, life={7,9}, spread=54, rot={-180,180}, rotSpd=210,
              accel=Vec(0,-7,0), drag=1.45, glow=0.62, dir=ND.Bottom,
              gust={ax=4.2,az=2.8,wx=0.33,wz=0.24,ph=1.9} },
            { size=Vec(150,8,150), oy=16, uw=26, tex=TX_LEAFB, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(160,80,52)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(104,44,30)) }),
              skeys={{0,0.54,0.16},{1,0.42,0.11}}, qseq=flutterSeq(-0.54, 0.14, 9, 0.16, 1),
              transp0=0.10,transp1=0.50,
              rate=21, speed={1.4,3.1}, life={7,9}, spread=54, rot={-180,180}, rotSpd=200,
              accel=Vec(0,-7.2,0), drag=1.45, glow=0.07, dir=ND.Bottom,
              gust={ax=4,az=2.7,wx=0.31,wz=0.26,ph=3.3} },
            { size=Vec(150,8,150), oy=16, uw=26, tex=TX_LEAFA, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,   Color3.fromRGB(230,222,176)),
                  ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,254,228)),
                  ColorSequenceKeypoint.new(1,   Color3.fromRGB(200,180,122)) }),
              skeys={{0,0.52,0.15},{1,0.41,0.10}}, qseq=flutterSeq(-0.52, 0.12, 10, 0.16, 1),
              transp0=0.10,transp1=0.52,
              rate=17, speed={1.3,2.9}, life={7,9}, spread=52, rot={-180,180}, rotSpd=190,
              accel=Vec(0,-6.8,0), drag=1.45, glow=0.60, dir=ND.Bottom,
              gust={ax=4.1,az=2.7,wx=0.35,wz=0.28,ph=2.7} },
            { size=Vec(150,8,150), oy=16, uw=26, tex=TX_LEAFB, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(156,74,255)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(106,46,200)) }),
              skeys={{0,0.53,0.16},{1,0.42,0.11}}, qseq=flutterSeq(-0.52, 0.16, 9, 0.16, 0),
              transp0=0.10,transp1=0.50,
              rate=12, speed={1.4,3.1}, life={7,9}, spread=54, rot={-180,180}, rotSpd=220,
              accel=Vec(0,-7.1,0), drag=1.45, glow=0.07, dir=ND.Bottom,
              gust={ax=4,az=2.7,wx=0.3,wz=0.25,ph=5.1} },
            { size=Vec(150,8,150), oy=16, uw=20, tex=TX_LEAFC, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(196,156,112)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(146,110,74)) }),
              skeys={{0,0.50,0.15},{1,0.40,0.10}}, qseq=flutterSeq(-0.52, 0.10, 7, 0.16, 0),
              transp0=0.14,transp1=0.55,
              rate=11, speed={1.5,3.2}, life={7,9}, spread=56, rot={-180,180}, rotSpd=240,
              accel=Vec(0,-7.6,0), drag=1.45, glow=0.08, dir=ND.Bottom,
              gust={ax=3.8,az=2.6,wx=0.29,wz=0.23,ph=0.9} },
            { size=Vec(150,8,150), oy=16, uw=26, tex=TX_LEAFA, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(152,255,255)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(118,214,240)) }),
              skeys={{0,0.52,0.15},{1,0.41,0.10}}, qseq=flutterSeq(-0.50, 0.14, 8, 0.16, 1),
              transp0=0.12,transp1=0.52,
              rate=10, speed={1.4,3}, life={7,9}, spread=54, rot={-180,180}, rotSpd=195,
              accel=Vec(0,-7,0), drag=1.45, glow=0.16, dir=ND.Bottom,
              gust={ax=4.1,az=2.7,wx=0.34,wz=0.27,ph=4.2} },
            { size=Vec(300,30,300), oy=30, uw=60, tex=TX_LEAFA, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,    Color3.fromRGB(226,190,128)),
                  ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255,246,200)),
                  ColorSequenceKeypoint.new(1,    Color3.fromRGB(190,132,62)) }),
              skeys={{0,0.24,0.06},{1,0.18,0.04}}, squash=-0.35, transp0=0.68,transp1=0.92,
              rate=30, speed={1.5,3.2}, life={8,11}, spread=55, rot={-180,180}, rotSpd=110,
              accel=Vec(0,-8,0), drag=1.35, glow=0.55, dir=ND.Bottom,
              gust={ax=3.1,az=2.1,wx=0.27,wz=0.24,ph=1.2} },
            { size=Vec(300,30,300), oy=30, uw=60, tex=TX_LEAFB, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(160,80,52)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(104,44,30)) }),
              skeys={{0,0.23,0.06},{1,0.17,0.04}}, squash=-0.35, transp0=0.70,transp1=0.93,
              rate=24, speed={1.5,3.2}, life={8,11}, spread=55, rot={-180,180}, rotSpd=120,
              accel=Vec(0,-8,0), drag=1.35, glow=0.07, dir=ND.Bottom,
              gust={ax=3,az=2,wx=0.29,wz=0.22,ph=3.8} },
            { size=Vec(120,16,120), oy=6, tex=TX_LEAFA, tag="streak", aim=true,
              orient=Enum.ParticleOrientation.VelocityParallel,
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,    Color3.fromRGB(226,190,128)),
                  ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255,246,200)),
                  ColorSequenceKeypoint.new(1,    Color3.fromRGB(190,132,62)) }),
              skeys={{0,0.66,0.16},{1,0.46,0.10}}, squash=-0.55,
              tkeys={{0,1},{0.08,0.06},{0.72,0.34},{1,1}},
              rate=0, speed={16,26}, life={1,1.9}, spread=13, rot={-180,180}, rotSpd=300,
              accel=Vec(0,-3.4,0), drag=2.6, glow=0.62, dir=ND.Front,
              gust={ax=5,az=4,wx=0.4,wz=0.35,ph=0} },
            { size=Vec(120,16,120), oy=5, tex=TX_LEAFB, tag="streak", aim=true,
              orient=Enum.ParticleOrientation.VelocityParallel,
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(160,80,52)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(104,44,30)) }),
              skeys={{0,0.62,0.16},{1,0.44,0.10}}, squash=-0.55,
              tkeys={{0,1},{0.08,0.08},{0.72,0.38},{1,1}},
              rate=0, speed={15,24}, life={1,1.8}, spread=14, rot={-180,180}, rotSpd=280,
              accel=Vec(0,-3.6,0), drag=2.6, glow=0.07, dir=ND.Front,
              gust={ax=5,az=4,wx=0.37,wz=0.33,ph=1.7} },
            { size=Vec(96,0.9,96), oy=-3.9, tex=TX_LEAFA, tag="settle",
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,   Color3.fromRGB(200,150,86)),
                  ColorSequenceKeypoint.new(0.5, Color3.fromRGB(168,110,58)),
                  ColorSequenceKeypoint.new(1,   Color3.fromRGB(130,80,44)) }),
              skeys={{0,0.50,0.14},{1,0.44,0.10}}, qseq=flutterSeq(-0.62, -0.05, 10, 0.1, 0),
              transp0=0.06,transp1=0.46,
              rate=34, speed={0.8,3.2}, life={10,16}, spread=90, rot={-180,180}, rotSpd=90,
              accel=Vec(0,-0.15,0), drag=3.2, glow=0.32, dir=ND.Bottom,
              gust={ax=9,az=8,wx=0.5,wz=0.44,ph=0.9} },
            { size=Vec(70,0.8,70), oy=-3.85, tex=TX_LEAFB, tag="settle",
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(160,80,52)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(104,44,30)) }),
              skeys={{0,0.54,0.12},{1,0.46,0.08}}, qseq=flutterSeq(-0.66, 0.26, 16, 0.06, 0),
              transp0=0.05,transp1=0.44,
              rate=14, speed={0.6,2.2}, life={3,5}, spread=70, rot={-180,180}, rotSpd=340,
              accel=Vec(0,-1.2,0), drag=1.9, glow=0.10, dir=ND.Top,
              gust={ax=8,az=7,wx=0.62,wz=0.55,ph=2.4} },
            { size=Vec(74,0.6,74), oy=-3.95, tex=TX_LEAFC, tag="settle",
              orient=Enum.ParticleOrientation.VelocityPerpendicular,
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(190,146,96)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(150,110,72)) }),
              skeys={{0,0.76,0.16},{1,0.72,0.12}}, squash=0, transp0=0.04,transp1=0.30,
              rate=42, speed={0.04,0.1}, life={20,28}, spread=90, rot={-180,180}, rotSpd=3,
              accel=Vec(0,-0.12,0), drag=4, glow=0.22, dir=ND.Bottom },
            { size=Vec(80,0.8,80), oy=-4, tex=TX_DUST, tag="dust",
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(206,180,140)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(150,124,92)) }),
              skeys={{0,1.1,0.35},{1,3.4,0.5}}, tkeys={{0,1},{0.18,0.84},{0.7,0.93},{1,1}},
              rate=0, speed={2,6}, life={1.1,2}, spread=85, rot={-180,180}, rotSpd=22,
              accel=Vec(0,0.6,0), drag=2.4, glow=0.06, dir=ND.Top,
              gust={ax=8,az=7,wx=0.4,wz=0.35,ph=0} },
        },
        Ash = {
            { size=Vec(110,4,110), oy=16, tex=TX_SOFT, color=Color3.fromRGB(96,90,86),
              size0=0.4,size1=0.3, transp0=0.05,transp1=0.5,
              rate=140, speed={2,4}, life={6,9}, spread=45, rot={-60,60}, rotSpd=45,
              accel=Vec(-3.5,-5,2), drag=1.6, glow=0, dir=ND.Bottom },
            { size=Vec(170,4,170), oy=26, tex=TX_SPARK, color=Color3.fromRGB(255,140,70),
              size0=0.14,size1=0.05, transp0=0.15,transp1=0.9,
              rate=26, speed={1.5,3.5}, life={4,7}, spread=60, rot={-40,40}, rotSpd=70,
              accel=Vec(-2.5,-2,1.5), drag=1.5, glow=0.9, dir=ND.Bottom },
        },
        Sandstorm = {
            { size=Vec(160,20,160), oy=6, tex=TX_SOFT, color=Color3.fromRGB(194,168,120),
              size0=24,size1=38, transp0=0.58,transp1=0.93,
              rate=24, speed={8,15}, life={5,8}, spread=28, rot={-8,8}, rotSpd=6,
              accel=Vec(20,0.5,7), drag=0.6, dir=ND.Right },
        },
    }
    Weather.TypeOrder = { "Rain", "Snow", "Mist", "Embers", "Fireflies", "Petals", "Autumn",
                          "Ash", "Sandstorm", "BloodMoon" }
    local MOOD = {
        Rain      = { B=-0.03, C=0.08,  S=-0.12, tint=Color3.fromRGB(205,220,255) },
        Snow      = { B= 0.03, C=0.05,  S=-0.08, tint=Color3.fromRGB(226,240,255) },
        Mist      = { B=-0.01, C=-0.05, S=-0.20, tint=Color3.fromRGB(220,224,230) },
        Embers    = { B= 0.02, C=0.08,  S= 0.10, tint=Color3.fromRGB(255,238,220) },
        Fireflies = { B=-0.04, C=0.06,  S= 0.02, tint=Color3.fromRGB(238,228,205) },
        Petals    = { B= 0.00, C=0.09,  S= 0.05, tint=Color3.fromRGB(255,234,234) },
        Autumn    = { B= 0.005, C=0.08, S= 0.04, tint=Color3.fromRGB(253,244,232) },
        Ash       = { B=-0.04, C=0.06,  S=-0.25, tint=Color3.fromRGB(225,220,215) },
        Sandstorm = { B=-0.02, C=0.10,  S= 0.05, tint=Color3.fromRGB(224,196,150) },
        BloodMoon = { B=-0.05, C=0.12,  S=-0.20, tint=Color3.fromRGB(255,180,180) },
    }
    local SOUND = { Rain="rain", Snow="wind", Mist="wind", Embers="fire",
                    Fireflies="night", Petals="birds", Autumn="wind", Ash="wind",
                    Sandstorm="wind", BloodMoon="night" }
    local function ambientId(mood)
        local map = cfg("WeatherSoundIds", nil)
        if type(map) == "table" and map[mood] and map[mood] ~= "" then return map[mood] end
        return nil
    end
    local _partLayers = {}
    local _ambient  = nil
    local _moodCC   = nil
    local _moodTween = nil
    local FADE_TI = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local MOOD_TI = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local _followConn = nil
    local _lightFolder = nil
    local _rays = nil
    local _special = { moon = nil, shell = nil, sky = nil, cc = nil, atmo = nil, halo = nil, kind = nil }
    local _specialConn = nil
    local _clockConn = nil
    local function clearPartLayers()
        for _, L in _partLayers do
            if L.rateTween then L.rateTween:Cancel() end
            if L.host then pcall(function() L.host:Destroy() end) end
        end
        table.clear(_partLayers)
    end
    local _fadeLayers = {}
    local _fadeToken = 0
    local function killFade()
        _fadeToken = _fadeToken + 1
        for _, F in _fadeLayers do
            local host = F.host
            pcall(function() host:Destroy() end)
        end
        table.clear(_fadeLayers)
    end
    local function beginLayerFade()
        killFade()
        local maxLife = 0
        for _, L in _partLayers do
            if L.rateTween then L.rateTween:Cancel() end
            if L.emitter then
                TweenService:Create(L.emitter, FADE_TI, { Rate = 0 }):Play()
            end
            if L.life2 > maxLife then maxLife = L.life2 end
            _fadeLayers[#_fadeLayers + 1] = { host = L.host, oy = L.oy }
        end
        table.clear(_partLayers)
        local tok = _fadeToken
        task.delay(FADE_TI.Time + maxLife, function()
            if tok == _fadeToken then killFade() end
        end)
    end
    local _spectacles, _spectWeight, _spectNextT = {}, 0, 0
    local function registerSpectacle(name, weight, fn)
        _spectacles[#_spectacles + 1] = { name = name, weight = weight, fn = fn }
        _spectWeight = _spectWeight + weight
    end
    local _blizzT0, _blizzDur = 0, 1
    local function layerRate(L, I)
        if L.spec.tag == "settle" then
            return L.spec.rate * iRate(I, SET_LO, SET_HI)
        end
        return L.spec.rate * iRate(I, L.ir.lo, L.ir.hi)
    end
    local function tuneLayer(L, I)
        local spec, R, e = L.spec, L.ir, L.emitter
        local am = 1
        if spec.tag ~= "settle" then
            am = 1 - R.acc + R.acc * I
        end
        L.accel = spec.accel * am
        if not spec.gust then
            e.Acceleration = L.accel
        end
        e.Speed = NumberRange.new(spec.speed[1] * am, spec.speed[2] * am)
        if spec.gust then
            local gm = 1 - R.gst + R.gst * I
            L.gax, L.gaz = spec.gust.ax * gm, spec.gust.az * gm
        end
        local sm = 1 - R.sz + R.sz * I
        if spec.skeys then
            local ks = spec.skeys
            local kps = table.create(#ks)
            for i = 1, #ks do
                local k = ks[i]
                kps[i] = NumberSequenceKeypoint.new(k[1], k[2] * sm, (k[3] or 0) * sm)
            end
            e.Size = NumberSequence.new(kps)
        else
            e.Size = NumberSequence.new(spec.size0 * sm, spec.size1 * sm)
        end
        if not spec.tkeys then
            local om = 1 - R.alp + R.alp * I
            e.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0,    1),
                NumberSequenceKeypoint.new(0.12, math.clamp(1 - (1 - spec.transp0) * om, 0, 1)),
                NumberSequenceKeypoint.new(0.8,  math.clamp(1 - (1 - spec.transp1) * om, 0, 1)),
                NumberSequenceKeypoint.new(1,    1),
            })
        end
    end
    local function mkPartLayer(spec, ir, rampIn)
        local host = Instance.new("Part")
        host.Name = "_wxHost"; host.Anchored = true; host.CanCollide = false; host.CanQuery = false
        host.CanTouch = false; host.CastShadow = false; host.Transparency = 1; host.Massless = true
        host.Size = spec.size; host:SetAttribute("WX_Custom", true)
        host.Parent = getFolder()
        local e = Instance.new("ParticleEmitter")
        e:SetAttribute("WX_Custom", true)
        e.Texture = spec.tex
        local colorSeq = spec.color
        if typeof(colorSeq) ~= "ColorSequence" then
            colorSeq = ColorSequence.new(colorSeq)
        end
        e.Color = colorSeq
        local glow = spec.glow or 0
        e.LightEmission  = glow
        e.LightInfluence = 1 - math.min(glow, 1)
        e.Lifetime = NumberRange.new(spec.life[1], spec.life[2])
        e.SpreadAngle = Vector2.new(spec.spread, spec.spread)
        local rot0, rot1 = 0, 360
        if spec.rot then
            rot0, rot1 = spec.rot[1], spec.rot[2]
        end
        e.Rotation = NumberRange.new(rot0, rot1)
        e.RotSpeed = NumberRange.new(-(spec.rotSpd or 45), spec.rotSpd or 45)
        if spec.qseq then
            e.Squash = spec.qseq
        else
            e.Squash = NumberSequence.new(spec.squash or 0)
        end
        if spec.tkeys then
            local kps = table.create(#spec.tkeys)
            for i = 1, #spec.tkeys do kps[i] = NumberSequenceKeypoint.new(spec.tkeys[i][1], spec.tkeys[i][2]) end
            e.Transparency = NumberSequence.new(kps)
        end
        e.Drag = spec.drag or 0
        e.ZOffset = spec.zoff or 0
        e.EmissionDirection = spec.dir
        if spec.orient then
            e.Orientation = spec.orient
        end
        e.Parent = host
        local L = { host = host, oy = spec.oy, emitter = e, spec = spec, ir = ir,
                    accel = spec.accel, gust = spec.gust, tag = spec.tag,
                    gax = 0, gaz = 0, rateMul = 1,
                    uw = spec.uw, aim = spec.aim,
                    life2 = spec.life[2], rateTween = nil }
        local I = iAmt()
        tuneLayer(L, I)
        local targetRate = layerRate(L, I)
        if rampIn then
            e.Rate = 0
            L.rateTween = TweenService:Create(e, FADE_TI, { Rate = targetRate })
            L.rateTween:Play()
        else
            e.Rate = targetRate
        end
        _partLayers[#_partLayers + 1] = L
    end
    local function clearMood()
        if _moodTween then _moodTween:Cancel(); _moodTween = nil end
        if _moodCC then pcall(function() _moodCC:Destroy() end); _moodCC = nil end
    end
    local function applyMood(name)
        if not cfg("WeatherMood", true) then
            clearMood()
            return
        end
        local m = MOOD[name]
        if not m then
            clearMood()
            return
        end
        if _moodTween then _moodTween:Cancel(); _moodTween = nil end
        local g = 0.6 + 0.4 * iAmt()
        local cc = _moodCC
        if cc and cc.Parent then
            _moodTween = TweenService:Create(cc, MOOD_TI,
                { Brightness = m.B * g, Contrast = m.C * g, Saturation = m.S * g, TintColor = m.tint })
            _moodTween:Play()
            return
        end
        cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "_wxMood"; cc:SetAttribute("WX_Custom", true)
        cc.Brightness = m.B * g; cc.Contrast = m.C * g; cc.Saturation = m.S * g; cc.TintColor = m.tint
        cc.Parent = Lighting
        _moodCC = cc
    end
    local function startAmbient(mood)
        if _ambient then pcall(function() _ambient:Destroy() end); _ambient = nil end
        local id = mood and ambientId(mood)
        if not id then return end
        local s = Instance.new("Sound")
        s.Name = "_wxAmb"; s:SetAttribute("WX_Custom", true)
        s.SoundId = id; s.Looped = true; s.Volume = cfg("WeatherSoundVolume", 0.35)
        s.Parent = SoundService
        pcall(function() s:Play() end)
        _ambient = s
    end
    local function oneShot(id, vol, pitch)
        if not id or id == "" then return end
        local s = Instance.new("Sound")
        s.Name = "_wxSfx"; s:SetAttribute("WX_Custom", true)
        s.SoundId = id; s.Volume = math.clamp(vol, 0, 10)
        if pitch then s.PlaybackSpeed = pitch end
        s.Parent = SoundService
        pcall(function() s:Play() end)
        Debris:AddItem(s, 8)
    end
    local function getLightFolder()
        if _lightFolder and _lightFolder.Parent then return _lightFolder end
        local f = Instance.new("Folder"); f.Name = "_wxBolts"; f:SetAttribute("WX_Custom", true)
        f.Parent = getFolder()
        _lightFolder = f; return f
    end
    local function mkBoltPart(color, transp, size, cf, parent)
        local p = Instance.new("Part")
        p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
        p.CastShadow = false; p.Massless = true; p.Material = Enum.Material.Neon
        p.Color = color; p.Transparency = transp; p:SetAttribute("WX_Custom", true)
        p.Size = size; p.CFrame = cf; p.Parent = parent
        return p
    end
    local startStorm, stopStormLoop, stopStorm, rescheduleStorm
    ;(function()
        local TX_BGLOW   = "rbxassetid://78582616787441"
        local TX_BSTREAK = "rbxassetid://102481842205398"
        local BOLT_CORE  = Color3.fromRGB(245, 242, 255)
        local BOLT_GLOW  = Color3.fromRGB(162, 145, 255)
        local BOLT_AFTER = Color3.fromRGB(126, 96, 228)
        local ROT90 = CFrame.Angles(0, math.rad(90), 0)
        local FLICK = 0.12
        local _stormConn, _stormNextT = nil, 0
        local _boltRp = RaycastParams.new()
        _boltRp.FilterType = Enum.RaycastFilterType.Exclude
        local function mkSeg(color, transp, dia, len, cf, parent)
            local p = Instance.new("Part")
            p.Shape = Enum.PartType.Cylinder
            p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
            p.CastShadow = false; p.Massless = true; p.Material = Enum.Material.Neon
            p.Color = color; p.Transparency = transp; p:SetAttribute("WX_Custom", true)
            p.Size = Vec(len, dia, dia); p.CFrame = cf * ROT90; p.Parent = parent
            return p
        end
        local function boltChannel(model, segs, top, bot, n, thick, jitter, layer3)
            local pts = { top }
            local prev = top
            local driftAng = math.random() * 6.283
            for i = 1, n do
                local t = i / n
                local point = top:Lerp(bot, t)
                if i < n then
                    driftAng = driftAng + (math.random() - 0.5) * 2.2
                    local j = jitter * (0.5 + 0.5 * (1 - t))
                    local off = j * (0.3 + math.random() * 0.7)
                    point = point + Vec(math.cos(driftAng) * off, (math.random() - 0.5) * j * 0.25, math.sin(driftAng) * off)
                end
                local len = math.max((point - prev).Magnitude, 0.1)
                local cf = CFrame.lookAt((point + prev) * 0.5, point)
                segs[#segs + 1] = { p = mkSeg(BOLT_CORE, 0.02, thick, len + thick * 1.6, cf, model), on = 0.02, fade = 0.16 }
                segs[#segs + 1] = { p = mkSeg(BOLT_GLOW, 0.78, thick * 5.5, len + thick * 1.8, cf, model), on = 0.78, fade = 0.38 }
                if layer3 then
                    segs[#segs + 1] = { p = mkSeg(BOLT_AFTER, 0.88, thick * 2.2, len + thick * 1.6, cf, model), on = 0.75, fade = 0.85 }
                end
                pts[#pts + 1] = point
                prev = point
            end
            return pts
        end
        local function boltBranch(model, segs, fromPts, groundY, thick, depth)
            local count = 1
            if depth == 1 then count = math.random(2, 4) end
            for _ = 1, count do
                local idx = math.random(math.floor(#fromPts * 0.2), math.floor(#fromPts * 0.7))
                local a = fromPts[math.max(idx, 2)]
                local ang = math.random() * 6.283
                local drop = (a.Y - groundY) * (0.3 + math.random() * 0.25)
                local outw = drop * (0.55 + math.random() * 0.4)
                local endp = a + Vec(math.cos(ang) * outw, -drop, math.sin(ang) * outw)
                local n = 5
                if depth == 1 then n = 8 end
                local blen = (endp - a).Magnitude
                local pts = boltChannel(model, segs, a, endp, n, thick, math.max(5, blen * 0.1) / depth, false)
                if depth < 3 and math.random() < 0.5 then
                    boltBranch(model, segs, pts, groundY, thick * 0.45, depth + 1)
                end
            end
        end
        local function preFlash(pos, scale)
            local host = mkBoltPart(BOLT_CORE, 1, Vec(2, 2, 2), CFrame.new(pos), getLightFolder())
            local e = Instance.new("ParticleEmitter")
            e:SetAttribute("WX_Custom", true)
            e.Texture = TX_BGLOW
            e.Color = ColorSequence.new(Color3.fromRGB(206, 192, 255))
            e.LightEmission = 0.85; e.LightInfluence = 0
            e.Size = NumberSequence.new(60 * scale, 85 * scale)
            e.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.25, 0.55),
                NumberSequenceKeypoint.new(0.7, 0.75), NumberSequenceKeypoint.new(1, 1),
            })
            e.Lifetime = NumberRange.new(0.22, 0.3)
            e.Rate = 0; e.Speed = NumberRange.new(0, 0.5)
            e.Parent = host
            e:Emit(1)
            task.delay(0.09, function() pcall(function() e:Emit(1) end) end)
            Debris:AddItem(host, 1.2)
        end
        local function screenFlash()
            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "_wxFlash"; cc:SetAttribute("WX_Custom", true); cc.Brightness = 0.35; cc.Parent = Lighting
            local pulseA = 0.3 + math.random() * 0.25
            local pulseB = -1
            if math.random() < 0.6 then pulseB = pulseA + 0.18 + math.random() * 0.12 end
            local st = tick(); local c2
            c2 = RunService.Heartbeat:Connect(function()
                if not cc.Parent then if c2 then c2:Disconnect() end return end
                local a = (tick() - st) / 0.45
                if a >= 1 then pcall(function() cc:Destroy() end); if c2 then c2:Disconnect() end return end
                local b = 0.35 * (1 - a)
                if a >= pulseA and a < pulseA + 0.14 then
                    b = b + 0.22 * (1 - (a - pulseA) / 0.14)
                elseif pulseB > 0 and a >= pulseB and a < pulseB + 0.14 then
                    b = b + 0.16 * (1 - (a - pulseB) / 0.14)
                end
                cc.Brightness = b
            end)
            Debris:AddItem(cc, 0.7)
        end
        local function igniteBolt(ground, top)
            local model = Instance.new("Model"); model.Name = "_bolt"; model:SetAttribute("WX_Custom", true)
            local segs = {}
            local mainPts = boltChannel(model, segs, top, ground, 18, 1.0, 14, true)
            boltBranch(model, segs, mainPts, ground.Y, 0.55, 1)
            local dome = mkBoltPart(Color3.fromRGB(228, 240, 255), 0.5, Vec(0.6, 5, 5),
                CFrame.new(ground + Vec(0, 0.3, 0)) * CFrame.Angles(0, 0, math.rad(90)), model)
            dome.Shape = Enum.PartType.Cylinder
            local fl = Instance.new("PointLight"); fl.Color = BOLT_GLOW; fl.Range = 150; fl.Brightness = 8; fl.Parent = dome
            TweenService:Create(dome, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Size = Vec(0.6, 30, 30), Transparency = 1 }):Play()
            TweenService:Create(fl, TweenInfo.new(0.5), { Brightness = 0 }):Play()
            local cb = mkBoltPart(BOLT_CORE, 1, Vec(2, 2, 2), CFrame.new(ground + Vec(0, 1.5, 0)), model)
            local ce = Instance.new("ParticleEmitter")
            ce:SetAttribute("WX_Custom", true)
            ce.Texture = TX_BGLOW
            ce.Color = ColorSequence.new(Color3.fromRGB(235, 228, 255))
            ce.LightEmission = 1; ce.LightInfluence = 0
            ce.Size = NumberSequence.new(13, 17)
            ce.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1),
            })
            ce.Lifetime = NumberRange.new(0.3, 0.4)
            ce.Rate = 0; ce.Speed = NumberRange.new(0, 0.1)
            ce.Parent = cb
            local se = Instance.new("ParticleEmitter")
            se:SetAttribute("WX_Custom", true)
            se.Texture = TX_BSTREAK
            se.Color = ColorSequence.new(Color3.fromRGB(220, 205, 255))
            se.LightEmission = 1; se.LightInfluence = 0
            se.Size = NumberSequence.new(2, 3)
            se.Transparency = NumberSequence.new(0.25, 1)
            se.Lifetime = NumberRange.new(0.5, 0.9)
            se.Rate = 0; se.Speed = NumberRange.new(26, 44)
            se.SpreadAngle = Vector2.new(38, 38)
            se.Orientation = Enum.ParticleOrientation.VelocityParallel
            se.EmissionDirection = Enum.NormalId.Top
            se.Acceleration = Vec(0, -40, 0)
            se.Parent = cb
            ce:Emit(1)
            se:Emit(9)
            model.Parent = getLightFolder()
            preFlash(top + Vec(0, 10, 0), 1.5)
            local flickEnd = FLICK
            local restrikeAt = -1
            if math.random() < 0.3 then restrikeAt = FLICK + 0.08 + math.random() * 0.07 end
            local startT = tick(); local conn
            conn = RunService.Heartbeat:Connect(function()
                if not model.Parent then if conn then conn:Disconnect() end return end
                local a = tick() - startT
                if restrikeAt > 0 and a >= restrikeAt then
                    restrikeAt = -1
                    flickEnd = a + 0.1
                    fl.Brightness = 6
                    TweenService:Create(fl, TweenInfo.new(0.4), { Brightness = 0 }):Play()
                end
                if a < flickEnd then
                    local dim = 0
                    if math.random() < 0.28 then dim = 0.85 end
                    for i = 1, #segs do
                        local s = segs[i]
                        s.p.Transparency = s.on + (1 - s.on) * dim
                    end
                    return
                end
                local f = a - flickEnd
                if f >= 0.85 then
                    if conn then conn:Disconnect() end
                    pcall(function() model:Destroy() end)
                    return
                end
                for i = 1, #segs do
                    local s = segs[i]
                    local k = math.clamp(f / s.fade, 0, 1)
                    s.p.Transparency = s.on + (1 - s.on) * k
                end
            end)
            Debris:AddItem(model, 1.8)
            if cfg("WeatherStormFlash", true) then screenFlash() end
            local tid = cfg("WeatherThunderId", "")
            if tid ~= "" then
                local cam = Camera
                local dist = 120
                if cam then dist = (ground - cam.CFrame.Position).Magnitude end
                task.delay(dist * (3 / 343), function()
                    oneShot(tid, cfg("WeatherSoundVolume", 0.35) * 8 * (0.85 + math.random() * 0.3),
                        0.92 + math.random() * 0.16)
                end)
            end
        end
        local function spawnBolt()
            if not Config.Weather or not cfg("WeatherStorm", false) then return end
            local cam = Camera; if not cam then return end
            local base = cam.CFrame.Position
            local lv = cam.CFrame.LookVector
            local flat = Vec(lv.X, 0, lv.Z)
            if flat.Magnitude < 0.05 then flat = Vec(0, 0, -1) else flat = flat.Unit end
            local right = Vec(flat.Z, 0, -flat.X)
            local fwd  = 55 + math.random() * 95
            local side = (math.random() - 0.5) * 85
            local gx = base.X + flat.X * fwd + right.X * side
            local gz = base.Z + flat.Z * fwd + right.Z * side
            local ground = Vec(gx + (math.random() - 0.5) * 20, base.Y - 45, gz + (math.random() - 0.5) * 20)
            local ch = lp and lp.Character
            if ch then
                _boltRp.FilterDescendantsInstances = { getFolder(), ch }
            else
                _boltRp.FilterDescendantsInstances = { getFolder() }
            end
            local hit = Workspace:Raycast(Vec(gx, base.Y + 140, gz), Vec(0, -400, 0), _boltRp)
            if hit then ground = hit.Position end
            local top = Vec(gx + (math.random() - 0.5) * 90, base.Y + 280, gz + (math.random() - 0.5) * 90)
            preFlash(Vec(top.X, top.Y - 20, top.Z), 1)
            task.delay(0.1 + math.random() * 0.2, function()
                if not Config.Weather or not cfg("WeatherStorm", false) then return end
                pcall(function() igniteBolt(ground, top) end)
            end)
        end
        function startStorm()
            if _stormConn then return end
            _stormNextT = tick() + 2 + math.random() * 3
            _stormConn = RunService.Heartbeat:Connect(function()
                if not Config.Weather or not cfg("WeatherStorm", false) then return end
                local now = tick()
                if now >= _stormNextT then
                    _stormNextT = now + cfg("WeatherStormMin", 4)
                        + math.random() * cfg("WeatherStormVar", 8)
                    pcall(spawnBolt)
                end
            end)
        end
        function rescheduleStorm()
            if not _stormConn then
                return
            end
            local cap = tick() + cfg("WeatherStormMin", 4) + cfg("WeatherStormVar", 8)
            _stormNextT = math.min(_stormNextT, cap)
        end
        function stopStormLoop()
            if _stormConn then _stormConn:Disconnect(); _stormConn = nil end
        end
        function stopStorm()
            stopStormLoop()
            if _lightFolder then pcall(function() _lightFolder:Destroy() end); _lightFolder = nil end
        end
        registerSpectacle("StormBarrage", 1, function()
            if not Config.Weather or not cfg("WeatherStorm", false) then return end
            for i = 0, 2 do
                task.delay(i * (0.35 + math.random() * 0.3), function() pcall(spawnBolt) end)
            end
        end)
    end)()
    local function startFollow()
        if _followConn then return end
        local now0 = tick()
        Wind.reset(now0)
        _spectNextT = now0 + 120 + math.random() * 120
        _followConn = RunService.Heartbeat:Connect(function()
            if not Config.Weather then return end
            local now = tick()
            Wind.update(now)
            local amb = _ambient
            if amb then
                local vol = cfg("WeatherSoundVolume", 0.35)
                if amb.Volume ~= vol then amb.Volume = vol end
            end
            local cam = Camera; if not cam then return end
            local pos = cam.CFrame.Position
            if now >= _spectNextT then
                _spectNextT = now + 120 + math.random() * 120
                if _spectWeight > 0 then
                    local r = math.random() * _spectWeight
                    for i = 1, #_spectacles do
                        local s = _spectacles[i]
                        r = r - s.weight
                        if r <= 0 then
                            pcall(s.fn)
                            break
                        end
                    end
                end
            end
            local wgain = 1
            local bt = (now - _blizzT0) / _blizzDur
            if bt >= 0 and bt < 1 then
                wgain = 1 + 1.7 * math.sin(bt * math.pi)
            end
            local nwx, nwz = 1, 0
            local wl = math.sqrt(Wind.x * Wind.x + Wind.z * Wind.z)
            if wl > 0.05 then
                nwx = Wind.x / wl
                nwz = Wind.z / wl
            end
            for i = 1, #_partLayers do
                local L = _partLayers[i]
                if L.host and L.host.Parent then
                    local hx, hz = pos.X, pos.Z
                    if L.uw then
                        hx = hx - nwx * L.uw
                        hz = hz - nwz * L.uw
                    end
                    local hy = pos.Y + L.oy
                    if L.aim then
                        L.host.CFrame = CFrame.lookAt(Vec(hx, hy, hz), Vec(hx + nwx, hy, hz + nwz))
                    else
                        L.host.CFrame = CFrame.new(hx, hy, hz)
                    end
                    local g = L.gust
                    if g then
                        L.emitter.Acceleration = L.accel + Vec(
                            Wind.x * wgain * L.gax * (1 + 0.3 * math.sin(now * g.wx + g.ph)), 0,
                            Wind.z * wgain * L.gaz * (1 + 0.3 * math.cos(now * g.wz + g.ph)))
                    end
                end
            end
            for i = 1, #_fadeLayers do
                local F = _fadeLayers[i]
                if F.host and F.host.Parent then
                    F.host.CFrame = CFrame.new(pos.X, pos.Y + F.oy, pos.Z)
                end
            end
        end)
    end
    local function stopFollow()
        if _followConn then _followConn:Disconnect(); _followConn = nil end
    end
    do
        local SWELL_UP = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local SWELL_DOWN = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local function windSwell(kind, dur, rateMul)
            if not Config.Weather or _curType ~= kind then return end
            _blizzT0, _blizzDur = tick(), dur
            local surged = {}
            local I = iAmt()
            for _, L in _partLayers do
                if L.emitter and L.tag ~= "settle" then
                    if L.rateTween then L.rateTween:Cancel() end
                    L.rateMul = rateMul
                    local tw = TweenService:Create(L.emitter, SWELL_UP, { Rate = layerRate(L, I) * rateMul })
                    L.rateTween = tw
                    tw:Play()
                    surged[#surged + 1] = L
                end
            end
            task.delay(dur - 3, function()
                local I2 = iAmt()
                for _, L in surged do
                    local live = false
                    for _, cur in _partLayers do
                        if cur == L then live = true break end
                    end
                    if live and L.emitter and L.emitter.Parent then
                        if L.rateTween then L.rateTween:Cancel() end
                        L.rateMul = 1
                        local tw = TweenService:Create(L.emitter, SWELL_DOWN, { Rate = layerRate(L, I2) })
                        L.rateTween = tw
                        tw:Play()
                    end
                end
            end)
        end
        registerSpectacle("SnowBlizzard", 1, function()
            windSwell("Snow", 11 + math.random() * 3, 1.9)
        end)
        registerSpectacle("SakuraGale", 1, function()
            windSwell("Petals", 9 + math.random() * 4, 1.7)
        end)
    end
    do
        local GUST_UP   = TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local GUST_DOWN = TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local STREAK_BURST = { {0.3, 18}, {0.65, 14}, {1.05, 9} }
        Wind.onGust(function(dur)
            if not Config.Weather or _curType ~= "Autumn" then return end
            local I = iAmt()
            local em = iRate(I, IR.Autumn.lo, IR.Autumn.hi)
            local gm = 1 + 0.4 * I
            local surged = {}
            for _, L in _partLayers do
                if L.emitter and L.tag == "dust" then
                    local e = L.emitter
                    local n2 = math.max(1, math.floor(10 * em + 0.5))
                    e:Emit(math.max(1, math.floor(14 * em + 0.5)))
                    task.delay(0.4, function()
                        if e.Parent then e:Emit(n2) end
                    end)
                elseif L.emitter and L.tag == "streak" then
                    local e = L.emitter
                    e:Emit(math.max(1, math.floor(20 * em + 0.5)))
                    for _, b in STREAK_BURST do
                        local n = math.max(1, math.floor(b[2] * em + 0.5))
                        task.delay(b[1], function()
                            if e.Parent then e:Emit(n) end
                        end)
                    end
                elseif L.emitter and L.tag ~= "settle" then
                    if L.rateTween then L.rateTween:Cancel() end
                    L.rateMul = gm
                    local tw = TweenService:Create(L.emitter, GUST_UP, { Rate = layerRate(L, I) * gm })
                    L.rateTween = tw
                    tw:Play()
                    surged[#surged + 1] = L
                end
            end
            task.delay(dur, function()
                local I2 = iAmt()
                for _, L in surged do
                    local live = false
                    for _, cur in _partLayers do
                        if cur == L then live = true break end
                    end
                    if live and L.emitter and L.emitter.Parent then
                        if L.rateTween then L.rateTween:Cancel() end
                        L.rateMul = 1
                        local tw = TweenService:Create(L.emitter, GUST_DOWN, { Rate = layerRate(L, I2) })
                        L.rateTween = tw
                        tw:Play()
                    end
                end
            end)
        end)
    end
    local function clearSpecial()
        if _specialConn then _specialConn:Disconnect(); _specialConn = nil end
        if _special.moon  then pcall(function() _special.moon:Destroy() end);  _special.moon  = nil end
        if _special.shell then pcall(function() _special.shell:Destroy() end); _special.shell = nil end
        if _special.sky   then pcall(function() _special.sky:Destroy() end);   _special.sky   = nil end
        if _special.cc    then pcall(function() _special.cc:Destroy() end);    _special.cc    = nil end
        if _special.atmo  then pcall(function() _special.atmo:Destroy() end);  _special.atmo  = nil end
        _special.halo = nil
        _special.kind = nil
    end
    local function tuneBloodMoon(I)
        local ms = 0.72 + 0.28 * I
        local gr = 0.5 + 0.5 * I
        if _special.moon then
            _special.moon.Size = Vec(130, 130, 130) * ms
        end
        if _special.shell then
            _special.shell.Size = Vec(160, 160, 160) * ms
        end
        if _special.halo then
            _special.halo.Rate = 25 * iRate(I, 1.45, 1.05)
            _special.halo.Size = NumberSequence.new(330 * ms)
        end
        if _special.cc then
            _special.cc.Saturation = -0.15 * gr
            _special.cc.Brightness = -0.04 * gr
        end
        if _special.atmo then
            _special.atmo.Density = 0.12 + 0.18 * I
            _special.atmo.Haze    = 0.9 + 0.9 * I
            _special.atmo.Glare   = 0.4 + 0.4 * I
        end
        if _special.sky then
            _special.sky.StarCount = math.floor(4000 * (0.55 + 0.45 * I))
        end
    end
    local function buildBloodMoon()
        local folder = getFolder()
        local s = Instance.new("Sky"); s.Name = "_wxSkyBM"; s:SetAttribute("WX_Custom", true)
        s.SkyboxBk = "rbxassetid://159454299"; s.SkyboxDn = "rbxassetid://159454296"
        s.SkyboxFt = "rbxassetid://159454293"; s.SkyboxLf = "rbxassetid://159454286"
        s.SkyboxRt = "rbxassetid://159454300"; s.SkyboxUp = "rbxassetid://159454288"
        s.SunAngularSize = 0; s.MoonAngularSize = 0; s.StarCount = 4000
        s.Parent = Lighting; _special.sky = s
        local moon = Instance.new("Part")
        moon.Shape = Enum.PartType.Ball; moon.Size = Vec(130, 130, 130)
        moon.Material = Enum.Material.Neon; moon.Color = Color3.fromRGB(215, 45, 35)
        moon.Anchored = true; moon.CanCollide = false; moon.CanQuery = false; moon.CanTouch = false
        moon.CastShadow = false; moon.Massless = true; moon:SetAttribute("WX_Custom", true)
        local att = Instance.new("Attachment"); att.Parent = moon
        local halo = Instance.new("ParticleEmitter")
        halo.Texture = TX_SOFT; halo.Color = ColorSequence.new(Color3.fromRGB(255, 60, 42))
        halo.LightEmission = 1; halo.LightInfluence = 0
        halo.Rate = 25; halo.Lifetime = NumberRange.new(0.22, 0.28)
        halo.Speed = NumberRange.new(0, 0); halo.Size = NumberSequence.new(330)
        halo.Transparency = NumberSequence.new(0.72); halo.RotSpeed = NumberRange.new(0, 0)
        halo.Parent = att; _special.halo = halo
        moon.Parent = folder; _special.moon = moon
        local shell = Instance.new("Part")
        shell.Shape = Enum.PartType.Ball; shell.Size = Vec(160, 160, 160)
        shell.Material = Enum.Material.Neon; shell.Color = Color3.fromRGB(255, 60, 45); shell.Transparency = 0.7
        shell.Anchored = true; shell.CanCollide = false; shell.CanQuery = false; shell.CanTouch = false
        shell.CastShadow = false; shell.Massless = true; shell:SetAttribute("WX_Custom", true)
        shell.Parent = folder; _special.shell = shell
        local cc = Instance.new("ColorCorrectionEffect"); cc.Name = "_wxBM"; cc:SetAttribute("WX_Custom", true)
        cc.TintColor = Color3.fromRGB(255, 165, 160); cc.Saturation = -0.15; cc.Brightness = -0.04
        cc.Parent = Lighting; _special.cc = cc
        local at = Instance.new("Atmosphere"); at.Name = "_wxBMAtmo"; at:SetAttribute("WX_Custom", true)
        at.Density = 0.3; at.Color = Color3.fromRGB(125, 35, 35); at.Decay = Color3.fromRGB(190, 55, 50)
        at.Glare = 0.8; at.Haze = 1.8; at.Parent = Lighting; _special.atmo = at
        _special.kind = "BloodMoon"
        tuneBloodMoon(iAmt())
    end
    local function startSpecialAnim()
        if _specialConn then return end
        local accum = 0
        _specialConn = RunService.Heartbeat:Connect(function(dt)
            if not Config.Weather or not _special.kind then return end
            accum = accum + dt
            if accum < 0.1 then return end
            accum = 0
            local cam = Camera; if not cam then return end
            local pos = cam.CFrame.Position
            if _special.kind == "BloodMoon" and _special.moon then
                local cf = CFrame.new(pos + Vec(0.45, 0.62, -0.64).Unit * 700)
                _special.moon.CFrame = cf
                if _special.shell then _special.shell.CFrame = cf end
            end
        end)
    end
    local CSK, NSK = ColorSequenceKeypoint.new, NumberSequenceKeypoint.new
    local TX_MGLOW = "rbxassetid://78582616787441"
    local startMeteors, stopMeteors, rescheduleMeteors
    ;(function()
        local MET_TXS  = "rbxassetid://77935321198144"
        local MET_TXK  = "rbxassetid://102481842205398"
        local MET_TXD  = "rbxassetid://341828512"
        local MET_HAZE = Color3.fromRGB(128, 146, 176)
        local MET_GLOW = {
            { z = -0.80, size = 0.85, tr = 0.03, col = Color3.fromRGB(255, 246, 216), life = 0.09, rate = 34, b0 = 1.35, b1 = 2.1 },
            { z = -0.10, size = 1.75, tr = 0.55, col = Color3.fromRGB(255, 194, 106), life = 0.10, rate = 30, b0 = 0.85, b1 = 1.4 },
            { z =  1.30, size = 3.10, tr = 0.80, col = Color3.fromRGB(255, 124,  46), life = 0.11, rate = 26, b0 = 0.5, b1 = 0.8 },
            { z =  3.20, size = 5.20, tr = 0.92, col = Color3.fromRGB(224,  72,  26), life = 0.12, rate = 22, b0 = 0.4, b1 = 0.6 },
        }
        local MET_ROCK = {
            { 1.00, 0.74, 1.28,  0.00,  0.00,  0.00, 0.25, 0.40, 0.18, 58, 51, 47, 0.00, true },
            { 0.70, 0.60, 0.76,  0.40,  0.20,  0.12, 0.80, 0.50, 1.10, 47, 41, 39, 0.00, true },
            { 0.58, 0.48, 0.64, -0.38, -0.26,  0.34, 1.20, 0.90, 0.30, 36, 31, 30, 0.00, true },
            { 0.46, 0.40, 0.52,  0.06, -0.42, -0.24, 0.40, 1.30, 0.70, 52, 45, 42, 0.00, true },
            { 0.36, 0.30, 0.40, -0.32,  0.36, -0.08, 0.90, 0.20, 1.40, 42, 36, 34, 0.00, true },
            { 0.30, 0.26, 0.34,  0.22, -0.10,  0.46, 1.50, 0.70, 0.20, 38, 33, 32, 0.00, true },
            { 0.26, 0.34, 0.22, -0.20, -0.34, -0.02, 0.60, 1.10, 0.90, 33, 29, 28, 0.00, true },
            { 0.52, 0.40, 0.16,  0.10,  0.06, -0.56, 0.00, 0.00, 0.50, 255, 244, 214, 0.10, false },
            { 0.30, 0.46, 0.14, -0.30, -0.14, -0.44, 0.00, 0.00, -0.90, 255, 190, 104, 0.28, false },
            { 0.34, 0.20, 0.12,  0.16, -0.34, -0.40, 0.00, 0.00, 0.20, 255, 158,  66, 0.36, false },
            { 0.22, 0.16, 0.10, -0.10,  0.34, -0.38, 0.00, 0.00, 1.20, 255, 214, 150, 0.30, false },
        }
        local MET_ABL0 = 8
        local MET_ABLA = { 0.06, 0.20, 0.26, 0.22 }
        local MET_ABLK = { 0.20, 0.24, 0.26, 0.26 }
        local MET_UP, MET_DOWN = Vec(0, 300, 0), Vec(0, -800, 0)
        local _metConn = nil
        local _metNextFar, _metNextNear = 0, 0
        local _metFar, _metNear = 0, 0
        local _metLive = {}
        local _metRp = RaycastParams.new()
        _metRp.FilterType = Enum.RaycastFilterType.Exclude
        local function hz(c, k)
            return c:Lerp(MET_HAZE, k)
        end
        local function metPart(sx, sy, sz, cf)
            local p = Instance.new("Part")
            p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
            p.CastShadow = false; p.Massless = true
            p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
            p.Size = Vec(sx, sy, sz); p.CFrame = cf
            p:SetAttribute("WX_Custom", true)
            p.Parent = getLightFolder()
            return p
        end
        local function metFilter()
            local ch = nil
            if lp then ch = lp.Character end
            if ch then
                _metRp.FilterDescendantsInstances = { getFolder(), ch }
            else
                _metRp.FilterDescendantsInstances = { getFolder() }
            end
        end
        local function metSolveLand(base, out, tang)
            local d = 90 + math.random() * 110
            local lat = (math.random() - 0.5) * 160
            for _ = 1, 2 do
                local c = base + out * d + tang * lat
                local h = Workspace:Raycast(c + MET_UP, MET_DOWN, _metRp)
                if h then
                    return h.Position + Vec(0, 1.5, 0)
                end
                d = d * 0.5
                lat = lat * 0.5
            end
            return nil
        end
        local function metGlow(host, size, transp, color, life, rate)
            local g = Instance.new("ParticleEmitter")
            g:SetAttribute("WX_Custom", true)
            g.Texture = TX_MGLOW; g.Color = ColorSequence.new(color)
            g.LightEmission = 1; g.LightInfluence = 0
            g.Rate = rate; g.Lifetime = NumberRange.new(life, life)
            g.Size = NumberSequence.new(size); g.Transparency = NumberSequence.new(transp)
            g.Speed = NumberRange.new(0, 0); g.LockedToPart = true
            g.Parent = host
            return g
        end
        local function metRibbon(part, sep, c0, c1, a0, w1, life, emit, inf)
            local aT = Instance.new("Attachment"); aT.Position = Vec(0, sep * 0.5, 0); aT.Parent = part
            local aB = Instance.new("Attachment"); aB.Position = Vec(0, -sep * 0.5, 0); aB.Parent = part
            local tr = Instance.new("Trail")
            tr:SetAttribute("WX_Custom", true)
            tr.Attachment0 = aT; tr.Attachment1 = aB; tr.FaceCamera = true
            tr.Texture = TX_MGLOW; tr.TextureMode = Enum.TextureMode.Stretch; tr.TextureLength = 1
            tr.Color = ColorSequence.new(c0, c1)
            tr.Transparency = NumberSequence.new({ NSK(0, a0), NSK(0.6, a0 + (1 - a0) * 0.45), NSK(1, 1) })
            tr.WidthScale = NumberSequence.new({ NSK(0, 1), NSK(1, w1) })
            tr.Lifetime = life; tr.LightEmission = emit; tr.LightInfluence = inf
            tr.MinLength = 0.05
            tr.Parent = part
            return { t = tr, a = aT, b = aB, sep = sep }
        end
        local function metSmoke(host, sb, lo, hi, rate, aBase, drift, spread, k)
            local e = Instance.new("ParticleEmitter")
            e:SetAttribute("WX_Custom", true)
            e.Texture = MET_TXS
            e.Color = ColorSequence.new({
                CSK(0,   hz(Color3.fromRGB(178, 164, 152), k * 0.5)),
                CSK(0.2, hz(Color3.fromRGB(146, 142, 138), k * 0.5)),
                CSK(1,   hz(Color3.fromRGB(84, 82, 80), k * 0.5)) })
            e.LightEmission = 0.02; e.LightInfluence = 0.6
            e.Rate = rate; e.Lifetime = NumberRange.new(lo, hi)
            e.Size = NumberSequence.new({ NSK(0, sb), NSK(0.35, sb * 1.9), NSK(1, sb * 3) })
            e.Transparency = NumberSequence.new({
                NSK(0, 0.94), NSK(0.07, aBase + 0.16 * k), NSK(0.62, aBase + 0.16), NSK(1, 1) })
            e.Speed = NumberRange.new(0, spread); e.SpreadAngle = Vector2.new(60, 60)
            e.Drag = 0.5
            e.RotSpeed = NumberRange.new(-8, 8); e.Rotation = NumberRange.new(0, 360)
            e.Acceleration = Vec(Wind.x * drift, 0.35, Wind.z * drift)
            e.Parent = host
            return e
        end
        local function bez(p0, p1, p2, a)
            return p0:Lerp(p1, a):Lerp(p1:Lerp(p2, a), a)
        end
        local function metImpact(pos, sc)
            if Camera then
                sc = math.min(sc, math.max(0.85, (pos - Camera.CFrame.Position).Magnitude / 44))
            end
            local host = metPart(4 * sc, 4 * sc, 4 * sc, CFrame.new(pos))
            host.Shape = Enum.PartType.Ball; host.Material = Enum.Material.Neon
            host.Color = Color3.fromRGB(255, 240, 202); host.Transparency = 0.05
            local fl = Instance.new("PointLight")
            fl.Color = Color3.fromRGB(255, 176, 90); fl.Range = 150; fl.Brightness = 9; fl.Parent = host
            local glow = metPart(2, 2, 2, CFrame.new(pos + Vec(0, 3, 0)))
            glow.Transparency = 1
            local gl = Instance.new("PointLight")
            gl.Color = Color3.fromRGB(255, 148, 68); gl.Range = 120 * sc; gl.Brightness = 4; gl.Parent = glow
            local ring = metPart(12 * sc, 2 * sc, 12 * sc, CFrame.new(pos))
            ring.Shape = Enum.PartType.Ball; ring.Material = Enum.Material.Neon
            ring.Color = Color3.fromRGB(255, 150, 60); ring.Transparency = 0.35
            local scorch = metPart(15 * sc, 0.6, 15 * sc, CFrame.new(pos - Vec(0, 0.4, 0)))
            scorch.Shape = Enum.PartType.Ball; scorch.Material = Enum.Material.Neon
            scorch.Color = Color3.fromRGB(255, 104, 24); scorch.Transparency = 0.2
            local att = Instance.new("Attachment"); att.Parent = host
            local datt = Instance.new("Attachment"); datt.Orientation = Vec(0, 0, -90); datt.Parent = host
            local flash = Instance.new("ParticleEmitter")
            flash:SetAttribute("WX_Custom", true)
            flash.Texture = TX_MGLOW; flash.Rate = 0
            flash.Color = ColorSequence.new({
                CSK(0,    Color3.fromRGB(255, 246, 214)),
                CSK(0.45, Color3.fromRGB(255, 186, 96)),
                CSK(1,    Color3.fromRGB(226, 96, 34)) })
            flash.LightEmission = 1; flash.LightInfluence = 0
            flash.Lifetime = NumberRange.new(0.30, 0.30)
            flash.Size = NumberSequence.new({ NSK(0, 14 * sc), NSK(0.35, 34 * sc), NSK(1, 44 * sc) })
            flash.Transparency = NumberSequence.new({ NSK(0, 0.05), NSK(0.45, 0.42), NSK(1, 1) })
            flash.Speed = NumberRange.new(0, 0); flash.Rotation = NumberRange.new(0, 360)
            flash.Parent = att
            flash:Emit(2)
            local dust = Instance.new("ParticleEmitter")
            dust:SetAttribute("WX_Custom", true)
            dust.Texture = MET_TXD; dust.Rate = 0
            dust.Color = ColorSequence.new(Color3.fromRGB(198, 178, 152), Color3.fromRGB(120, 112, 104))
            dust.LightEmission = 0.05; dust.LightInfluence = 0.5
            dust.Lifetime = NumberRange.new(5.5, 9)
            dust.Size = NumberSequence.new({ NSK(0, 6 * sc), NSK(1, 22 * sc) })
            dust.Transparency = NumberSequence.new({ NSK(0, 0.6), NSK(0.1, 0.42), NSK(0.6, 0.68), NSK(1, 1) })
            dust.Speed = NumberRange.new(22, 38); dust.SpreadAngle = Vector2.new(0, 180)
            dust.Drag = 1.9; dust.EmissionDirection = ND.Top
            dust.RotSpeed = NumberRange.new(-16, 16); dust.Rotation = NumberRange.new(0, 360)
            dust.Acceleration = Vec(Wind.x * 6, 0.4, Wind.z * 6)
            dust.Parent = datt
            dust:Emit(math.floor(24 * sc))
            local fount = Instance.new("ParticleEmitter")
            fount:SetAttribute("WX_Custom", true)
            fount.Texture = MET_TXK; fount.Rate = 0
            fount.Color = ColorSequence.new(Color3.fromRGB(255, 200, 110), Color3.fromRGB(196, 52, 14))
            fount.LightEmission = 1; fount.LightInfluence = 0
            fount.Lifetime = NumberRange.new(1.1, 2.2)
            fount.Size = NumberSequence.new({ NSK(0, 1.7 * sc), NSK(1, 0.08) })
            fount.Transparency = NumberSequence.new({ NSK(0, 0), NSK(0.7, 0.35), NSK(1, 1) })
            fount.Orientation = Enum.ParticleOrientation.VelocityParallel
            fount.Speed = NumberRange.new(48, 96); fount.SpreadAngle = Vector2.new(30, 30)
            fount.Acceleration = Vec(0, -74, 0); fount.Drag = 0.35
            fount.EmissionDirection = ND.Top; fount.Parent = att
            fount:Emit(math.floor(52 * sc))
            local col = Instance.new("ParticleEmitter")
            col:SetAttribute("WX_Custom", true)
            col.Texture = TX_MGLOW; col.Rate = 0
            col.Color = ColorSequence.new({
                CSK(0,    Color3.fromRGB(255, 236, 180)),
                CSK(0.35, Color3.fromRGB(255, 130, 40)),
                CSK(1,    Color3.fromRGB(122, 40, 18)) })
            col.LightEmission = 0.9; col.LightInfluence = 0
            col.Lifetime = NumberRange.new(0.55, 1.05)
            col.Size = NumberSequence.new({ NSK(0, 5 * sc), NSK(1, 14 * sc) })
            col.Transparency = NumberSequence.new({ NSK(0, 0.12), NSK(0.6, 0.55), NSK(1, 1) })
            col.Speed = NumberRange.new(32, 62); col.SpreadAngle = Vector2.new(10, 10)
            col.EmissionDirection = ND.Top; col.Parent = att
            col:Emit(18)
            local pil = Instance.new("ParticleEmitter")
            pil:SetAttribute("WX_Custom", true)
            pil.Texture = MET_TXS; pil.Rate = 0
            pil.Color = ColorSequence.new({
                CSK(0,   Color3.fromRGB(186, 150, 118)),
                CSK(0.3, Color3.fromRGB(146, 140, 132)),
                CSK(1,   Color3.fromRGB(88, 85, 82)) })
            pil.LightEmission = 0.02; pil.LightInfluence = 0.5
            pil.Lifetime = NumberRange.new(4.5, 8)
            pil.Size = NumberSequence.new({ NSK(0, 4.5 * sc), NSK(1, 20 * sc) })
            pil.Transparency = NumberSequence.new({ NSK(0, 0.52), NSK(0.5, 0.68), NSK(1, 1) })
            pil.Speed = NumberRange.new(16, 30); pil.SpreadAngle = Vector2.new(9, 9)
            pil.Acceleration = Vec(Wind.x * 7, 2.6, Wind.z * 7); pil.Drag = 0.6
            pil.EmissionDirection = ND.Top
            pil.RotSpeed = NumberRange.new(-12, 12); pil.Rotation = NumberRange.new(0, 360)
            pil.Parent = att
            task.delay(0.12, function() if pil.Parent then pil:Emit(7) end end)
            task.delay(0.62, function() if pil.Parent then pil:Emit(5) end end)
            task.delay(1.30, function() if pil.Parent then pil:Emit(4) end end)
            local t0 = tick()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not host.Parent then
                    conn:Disconnect()
                    return
                end
                local k = tick() - t0
                local f1 = math.clamp(k / 0.10, 0, 1)
                host.Size = Vec(1, 1, 1) * (4 + 6 * f1) * sc
                host.Transparency = 0.05 + 0.95 * f1
                fl.Brightness = 9 * (1 - math.clamp(k / 0.55, 0, 1))
                gl.Brightness = 4 * (1 - math.clamp(k / 5, 0, 1))
                local f2 = math.clamp(k / 0.55, 0, 1)
                ring.Size = Vec(12 + 52 * f2, 2 - 1.2 * f2, 12 + 52 * f2) * sc
                ring.Transparency = 0.35 + 0.65 * f2
                scorch.Transparency = 0.2 + 0.8 * math.clamp(k / 7, 0, 1)
                if k > 7.2 then
                    conn:Disconnect()
                end
            end)
            Debris:AddItem(ring, 1.1)
            Debris:AddItem(glow, 5.2)
            Debris:AddItem(scorch, 7.5)
            Debris:AddItem(host, 11)
        end
        local function launch(far, opts)
            local ang = math.random() * 6.28318
            local mul = 1
            local big = false
            if opts then
                if opts.ang then ang = opts.ang end
                if opts.scaleMul then mul = opts.scaleMul end
                big = opts.big == true
            end
            local tang = Vec(-math.sin(ang), 0, math.cos(ang))
            local out = Vec(math.cos(ang), 0, math.sin(ang))
            local sgn = 1
            if math.random() < 0.5 then sgn = -1 end
            local base = Camera.CFrame.Position
            local startP, endP, spd, rs, ws, k, doImpact, smk
            if far then
                local ctr = base + out * (1400 + math.random() * 1200)
                          + Vec(0, 820 + math.random() * 360, 0)
                local travel = 3000 + math.random() * 900
                local drop = 320 + math.random() * 200
                startP = ctr - tang * (travel * 0.5 * sgn) + Vec(0, drop * 0.5, 0)
                endP = ctr + tang * (travel * 0.5 * sgn) - Vec(0, drop * 0.5, 0)
                spd = 255 + math.random() * 70
                rs = 14 + math.random() * 5
                ws = 3.9 + math.random()
                k = 0.14 + math.random() * 0.10
                doImpact = false
                smk = 1.6
            else
                metFilter()
                local land = nil
                if opts and opts.land then
                    local h = Workspace:Raycast(opts.land + MET_UP, MET_DOWN, _metRp)
                    if h then land = h.Position + Vec(0, 1.5, 0) end
                end
                if not land then land = metSolveLand(base, out, tang) end
                doImpact = land ~= nil
                if not land then
                    land = base + out * 150 + Vec(0, 40, 0)
                end
                local travel = 1750 + math.random() * 450
                startP = land - tang * (travel * sgn) + out * (190 + math.random() * 190)
                         + Vec(0, 640 + math.random() * 160, 0)
                if opts and opts.start then startP = opts.start end
                endP = land
                spd = 175 + math.random() * 38
                rs = (7.0 + math.random() * 2.6) * mul
                ws = (1.3 + math.random() * 0.28) * mul
                k = 0
                smk = 1
            end
            if big then
                rs = rs * 1.7
                ws = ws * 1.5
                spd = spd * 0.92
            end
            local flare = far or (not doImpact)
            local splitAt = nil
            if big and not (opts and opts.noSplit) then
                splitAt = 0.42 + math.random() * 0.12
            end
            local mid = startP:Lerp(endP, 0.5) + Vec(0, (endP - startP).Magnitude * 0.075, 0)
            local dur = ((startP - mid).Magnitude + (mid - endP).Magnitude) / spd
            local cf0 = CFrame.lookAt(startP, endP)
            local root = metPart(0.2, 0.2, 0.2, cf0)
            root.Transparency = 1
            local a0 = Instance.new("Attachment"); a0.Parent = root
            local glows = table.create(4)
            for i, s in MET_GLOW do
                local hp = metPart(0.2, 0.2, 0.2, cf0)
                hp.Transparency = 1
                glows[i] = { p = hp, z = s.z * rs, b0 = s.b0, b1 = s.b1,
                    e = metGlow(hp, s.size * rs, math.min(0.97, s.tr + 0.18 * k),
                        hz(s.col, k * 0.55), s.life, s.rate) }
            end
            local chunks = table.create(#MET_ROCK)
            for i, r in MET_ROCK do
                local p = metPart(r[1] * rs, r[2] * rs, r[3] * rs, cf0)
                p.Transparency = r[13]
                if r[14] then
                    p.Material = Enum.Material.Slate
                    p.Color = Color3.fromRGB(r[10], r[11], r[12])
                else
                    p.Material = Enum.Material.Neon
                    p.Color = hz(Color3.fromRGB(r[10], r[11], r[12]), k * 0.4)
                end
                chunks[i] = { p = p, tumble = r[14],
                    off = CFrame.new(r[4] * rs, r[5] * rs, r[6] * rs) * CFrame.Angles(r[7], r[8], r[9]) }
            end
            local noseLight, bodyLight = nil, nil
            if not far then
                noseLight = Instance.new("PointLight")
                noseLight.Color = Color3.fromRGB(255, 186, 108)
                noseLight.Range = 4.2 * rs; noseLight.Brightness = 11
                noseLight.Parent = glows[1].p
                bodyLight = Instance.new("PointLight")
                bodyLight.Color = Color3.fromRGB(255, 150, 70)
                bodyLight.Range = 16 * rs; bodyLight.Brightness = 3
                bodyLight.Parent = root
            end
            local ha = 0.20 * k
            local ribbons = {
                metRibbon(root, 7.5 * ws, hz(Color3.fromRGB(255, 253, 248), k * 0.3),
                    hz(Color3.fromRGB(255, 226, 156), k * 0.6), ha, 0.45, 0.26, 1, 0),
                metRibbon(root, 14 * ws, hz(Color3.fromRGB(255, 222, 146), k * 0.5),
                    hz(Color3.fromRGB(255, 136, 40), k * 0.9), 0.06 + ha, 0.36, 0.72, 1, 0),
                metRibbon(root, 23 * ws, hz(Color3.fromRGB(255, 138, 42), k * 0.9),
                    hz(Color3.fromRGB(196, 50, 14), k), 0.22 + ha, 0.28, 1.85, 1, 0),
                metRibbon(root, 33 * ws, hz(Color3.fromRGB(196, 62, 18), k),
                    hz(Color3.fromRGB(88, 26, 14), k), 0.52 + ha, 0.30, 3.20, 0.55, 0.12),
            }
            local trainRate = math.clamp(spd / (17 * ws * 0.30 * smk), 6, 30)
            local train = metSmoke(a0, 17 * ws, 5, 7.5, trainRate, 0.56, 5.6, 3, k)
            local scarRate = math.clamp(spd / (50 * ws * 0.28 * smk), 1.6, 9)
            local scar = metSmoke(a0, 50 * ws, 20, 32, scarRate, 0.74, 7.8, 7, k)
            local sparks = nil
            if not far then
                sparks = Instance.new("ParticleEmitter")
                sparks:SetAttribute("WX_Custom", true)
                sparks.Texture = MET_TXK
                sparks.Color = ColorSequence.new(Color3.fromRGB(255, 172, 70), Color3.fromRGB(186, 44, 12))
                sparks.LightEmission = 1; sparks.LightInfluence = 0
                sparks.Rate = 60; sparks.Lifetime = NumberRange.new(0.6, 1.5)
                sparks.Size = NumberSequence.new({ NSK(0, 2.2 * ws), NSK(1, 0.06) })
                sparks.Transparency = NumberSequence.new({ NSK(0, 0.08), NSK(1, 1) })
                sparks.Orientation = Enum.ParticleOrientation.VelocityParallel
                sparks.Speed = NumberRange.new(6, 20); sparks.SpreadAngle = Vector2.new(32, 32)
                sparks.Acceleration = Vec(0, -12, 0); sparks.Drag = 0.6
                sparks.Parent = a0
            end
            if far then _metFar = _metFar + 1 else _metNear = _metNear + 1 end
            local rec = { root = root }
            _metLive[#_metLive + 1] = rec
            local t0 = tick()
            local ph = math.random() * 20
            local spinX, spinY, spinZ = (math.random() - 0.5) * 3, (math.random() - 0.5) * 3.4,
                0.6 + math.random() * 1.6
            local flareAt = 0.76 + math.random() * 0.10
            local shedAt = 0.25 + math.random() * 0.2
            local dead, endT = false, nil
            local conn
            local function retire()
                if dead then
                    return
                end
                dead = true
                if far then
                    _metFar = math.max(0, _metFar - 1)
                else
                    _metNear = math.max(0, _metNear - 1)
                end
                for i = #_metLive, 1, -1 do
                    if _metLive[i] == rec then table.remove(_metLive, i) end
                end
            end
            conn = RunService.Heartbeat:Connect(function()
                if not root.Parent then
                    conn:Disconnect()
                    retire()
                    return
                end
                local now = tick()
                local a = math.clamp((now - t0) / dur, 0, 1)
                local p = bez(startP, mid, endP, a)
                local d = (mid - startP) * (2 * (1 - a)) + (endP - mid) * (2 * a)
                if d.Magnitude < 1e-3 then d = endP - startP end
                local cf = CFrame.lookAt(p, p + d)
                local n = math.clamp(0.5 + 0.27 * math.sin(now * 41 + ph)
                    + 0.17 * math.sin(now * 67.3 + ph * 2.1)
                    + 0.09 * math.sin(now * 103.7 + ph * 0.7), 0, 1)
                local burn = 1
                if flare and a > flareAt then
                    local u = (a - flareAt) / (1 - flareAt)
                    burn = math.clamp((1 + 1.7 * math.exp(-((u - 0.14) ^ 2) / 0.011))
                        * (1 - u) ^ 1.5, 0, 3)
                end
                if endT then burn = burn * math.clamp(1 - (now - endT) / 0.4, 0, 1) end
                local bw = math.clamp(burn, 0, 1)
                if not endT then
                    root.CFrame = cf
                    for _, g in glows do
                        g.p.CFrame = cf * CFrame.new(0, 0, g.z)
                    end
                    local tum = CFrame.Angles(now * spinX, now * spinY, now * spinZ)
                    for _, c in chunks do
                        if c.tumble then
                            c.p.CFrame = cf * tum * c.off
                        else
                            c.p.CFrame = cf * c.off
                        end
                    end
                end
                for _, g in glows do
                    g.e.Brightness = (g.b0 + g.b1 * n) * burn
                end
                for i = 1, 4 do
                    local c = chunks[MET_ABL0 + i - 1]
                    c.p.Transparency = math.clamp(1 - (1 - (MET_ABLA[i] + MET_ABLK[i] * (1 - n))) * bw, 0, 1)
                end
                if noseLight then
                    noseLight.Brightness = (7 + 9 * n) * bw
                    bodyLight.Brightness = (2 + 3 * n) * bw
                end
                train.Rate = trainRate * bw
                scar.Rate = scarRate * bw
                if sparks then sparks.Rate = 60 * bw * (0.6 + 0.8 * n) end
                local pinch = (0.5 + 0.5 * bw) * (0.9 + 0.2 * n)
                for _, L in ribbons do
                    local h = L.sep * 0.5 * pinch
                    L.a.Position = Vec(0, h, 0)
                    L.b.Position = Vec(0, -h, 0)
                end
                if splitAt and a >= splitAt then
                    splitAt = nil
                    if sparks then sparks:Emit(30) end
                    for _ = 1, math.random(2, 3) do
                        launch(false, {
                            ang = ang,
                            noSplit = true,
                            scaleMul = 0.40 + math.random() * 0.14,
                            start = p + Vec((math.random() - 0.5) * 30, (math.random() - 0.5) * 20,
                                (math.random() - 0.5) * 30),
                            land = endP + Vec((math.random() - 0.5) * 110, 0, (math.random() - 0.5) * 110),
                        })
                    end
                end
                if (not far) and a > shedAt then
                    shedAt = 2
                    local fp = metPart(0.3 * rs, 0.24 * rs, 0.38 * rs, CFrame.new(p))
                    fp.Material = Enum.Material.Slate
                    fp.Color = Color3.fromRGB(40, 35, 33)
                    metRibbon(fp, 6, Color3.fromRGB(255, 220, 160), Color3.fromRGB(150, 34, 12),
                        0.12, 0.2, 0.8, 1, 0)
                    local fdir = (d.Unit * 0.65
                        + Vec(math.random() - 0.5, -0.5, math.random() - 0.5).Unit * 0.5).Unit
                    local fv, ft0 = fdir * spd * 0.6, tick()
                    local fc
                    fc = RunService.Heartbeat:Connect(function()
                        if not fp.Parent then
                            fc:Disconnect()
                            return
                        end
                        local age = tick() - ft0
                        if age > 2.4 then
                            fc:Disconnect()
                            fp:Destroy()
                            return
                        end
                        fv = fv + Vec(0, -0.88, 0)
                        fp.CFrame = CFrame.new(fp.Position + fv * 0.016)
                            * CFrame.Angles(age * 5, age * 3, age * 4)
                    end)
                end
                if not endT then
                    if a >= 1 then
                        endT = now
                        if doImpact then
                            metImpact(endP, rs * 0.215 + 0.6)
                            local tid = cfg("WeatherThunderId", "")
                            if tid ~= "" then
                                task.delay(0.15, function()
                                    oneShot(tid, cfg("WeatherSoundVolume", 0.35) * 6)
                                end)
                            end
                        end
                    elseif flare and burn < 0.02 and a > flareAt then
                        endT = now
                    end
                elseif now - endT >= 0.4 then
                    retire()
                    conn:Disconnect()
                    train.Enabled = false; scar.Enabled = false
                    if sparks then sparks.Enabled = false end
                    for _, g in glows do
                        g.e.Enabled = false
                        g.p:Destroy()
                    end
                    for _, L in ribbons do L.t.Enabled = false end
                    for _, c in chunks do c.p:Destroy() end
                    if noseLight then noseLight:Destroy(); bodyLight:Destroy() end
                    Debris:AddItem(root, 42)
                end
            end)
            Debris:AddItem(root, dur + 46)
        end
        local function spawnMeteor(far, opts)
            if not Config.Weather or not cfg("WeatherMeteors", false) then
                return
            end
            local r = evRate("WeatherMeteorRate")
            local capped
            if far then
                capped = _metFar >= math.clamp(math.floor(1 + 1.5 * r), 1, 4)
            elseif r >= 2.5 then
                capped = _metNear >= 3
            elseif r >= 1.5 then
                capped = _metNear >= 2
            else
                capped = _metNear >= 1
            end
            if capped then
                return
            end
            launch(far, opts)
        end
        startMeteors = function()
            if _metConn then
                return
            end
            local t = tick()
            _metNextFar = t + 1 + math.random() * 2
            _metNextNear = t + 5 + math.random() * 6
            _metConn = RunService.Heartbeat:Connect(function()
                if not Config.Weather or not cfg("WeatherMeteors", false) then
                    return
                end
                local now = tick()
                local r = evRate("WeatherMeteorRate")
                if now >= _metNextFar then
                    _metNextFar = now + (6 + math.random() * 5) / r
                    pcall(spawnMeteor, true)
                end
                if now >= _metNextNear then
                    _metNextNear = now + (14 + math.random() * 10) / r
                    pcall(spawnMeteor, false)
                end
            end)
        end
        rescheduleMeteors = function()
            if not _metConn then
                return
            end
            local now, r = tick(), evRate("WeatherMeteorRate")
            _metNextFar = math.min(_metNextFar, now + 11 / r)
            _metNextNear = math.min(_metNextNear, now + 24 / r)
        end
        stopMeteors = function()
            if _metConn then _metConn:Disconnect(); _metConn = nil end
            for _, rec in _metLive do
                pcall(function() rec.root:Destroy() end)
            end
            table.clear(_metLive)
        end
        registerSpectacle("MeteorBigOne", 1, function()
            if not Config.Weather or not cfg("WeatherMeteors", false) then
                return
            end
            launch(false, { big = true })
        end)
    end)()
    local startStars, stopStars, rescheduleStars
    ;(function()
        local TX_SGLOW = "rbxassetid://78582616787441"
        local TX_STAR4 = "rbxassetid://17726943419"
        local GLINT_C  = Color3.fromRGB(246, 250, 255)
        local MIN_SIN  = 0.3
        local FLOOR_H  = 60
        local PAL = {
            { WHITE, Color3.fromRGB(222, 234, 255), Color3.fromRGB(150, 184, 240) },
            { Color3.fromRGB(242, 250, 255), Color3.fromRGB(160, 206, 255), Color3.fromRGB(78, 138, 255) },
            { Color3.fromRGB(255, 246, 220), Color3.fromRGB(255, 205, 122), Color3.fromRGB(222, 140, 44) },
        }
        local CLS = {
            { 80, 55, 250, 105, 50, 28, 3.6 },
            { 145, 90, 158, 62, 76, 44, 5.4 },
            { 240, 150, 98, 46, 118, 62, 7.2 },
        }
        local TR_TRANSP  = NumberSequence.new({ NSK(0, 0.04), NSK(0.12, 0.12), NSK(0.45, 0.55), NSK(1, 1) })
        local TR_WIDTH   = NumberSequence.new({ NSK(0, 0.4), NSK(0.08, 1), NSK(1, 0.02) })
        local ION_TRANSP = NumberSequence.new({ NSK(0, 0.86), NSK(0.3, 0.9), NSK(1, 1) })
        local ION_WIDTH  = NumberSequence.new({ NSK(0, 0.5), NSK(0.25, 1), NSK(1, 0.35) })
        local HEAD_TR    = NumberSequence.new({ NSK(0, 1), NSK(0.05, 0), NSK(0.72, 0.06), NSK(1, 1) })
        local HALO_TR    = NumberSequence.new({ NSK(0, 1), NSK(0.07, 0.82), NSK(0.7, 0.88), NSK(1, 1) })
        local GLINT_TR   = NumberSequence.new({ NSK(0, 1), NSK(0.3, 0.12), NSK(0.55, 0.42), NSK(1, 1) })
        local _starConn, _starNextT = nil, 0
        local _starLive = {}
        local function mkSprite(parent, tex, col, sizeSeq, transpSeq, life, emit)
            local e = Instance.new("ParticleEmitter")
            e.Texture = tex
            e.Color = ColorSequence.new(col)
            e.Size = sizeSeq
            e.Transparency = transpSeq
            e.Lifetime = NumberRange.new(life)
            e.Rate = 0
            e.Speed = NumberRange.new(0, 0)
            e.SpreadAngle = Vector2.new(0, 0)
            e.LightEmission = emit
            e.LightInfluence = 0
            e.Drag = 0
            e.Parent = parent
            return e
        end
        local function spawnStreak(start, dir, ci, pi, floorY)
            if not Config.Weather or not cfg("WeatherShootingStars", false) then
                return
            end
            if #_starLive >= math.clamp(math.floor(4 + 2 * evRate("WeatherStarRate")), 4, 8) then
                return
            end
            local cls, pal = CLS[ci], PAL[pi]
            local dist = cls[1] + math.random() * cls[2]
            local spd  = cls[3] + math.random() * cls[4]
            local tail = cls[5] + math.random() * cls[6]
            if start.Y + dir.Y * dist < floorY then
                local ny = (floorY - start.Y) / dist
                local hl = math.sqrt(dir.X * dir.X + dir.Z * dir.Z)
                if hl > 1e-4 then
                    local k = math.sqrt(math.max(0, 1 - ny * ny)) / hl
                    dir = Vec(dir.X * k, ny, dir.Z * k)
                end
            end
            local dur  = dist / spd
            local life = math.min(tail / spd, dur * 0.9)
            local sep  = cls[7] * (0.85 + math.random() * 0.3)
            local glintD = 0.3 + math.random() * 0.3
            local cf0 = CFrame.lookAt(start, start + dir)
            local host = mkBoltPart(WHITE, 1, Vec(0.2, 0.2, 0.2), cf0, getLightFolder())
            local aT = Instance.new("Attachment"); aT.Position = Vec(0, sep * 0.5, 0); aT.Parent = host
            local aB = Instance.new("Attachment"); aB.Position = Vec(0, -sep * 0.5, 0); aB.Parent = host
            local tr = Instance.new("Trail")
            tr.Attachment0 = aT; tr.Attachment1 = aB
            tr.FaceCamera = true
            tr.Texture = TX_SGLOW; tr.TextureMode = Enum.TextureMode.Stretch; tr.TextureLength = 1
            tr.Color = ColorSequence.new({ CSK(0, pal[1]), CSK(0.24, pal[2]), CSK(1, pal[3]) })
            tr.Transparency = TR_TRANSP; tr.WidthScale = TR_WIDTH
            tr.Lifetime = life; tr.LightEmission = 1; tr.LightInfluence = 0
            tr.MinLength = 0.08; tr.Enabled = false
            tr.Parent = host
            local ion = nil
            if ci == 3 then
                ion = Instance.new("Trail")
                ion.Attachment0 = aT; ion.Attachment1 = aB
                ion.FaceCamera = true
                ion.Texture = TX_SGLOW; ion.TextureMode = Enum.TextureMode.Stretch; ion.TextureLength = 1
                ion.Color = ColorSequence.new({ CSK(0, pal[2]), CSK(1, pal[3]) })
                ion.Transparency = ION_TRANSP; ion.WidthScale = ION_WIDTH
                ion.Lifetime = life * 2.6; ion.LightEmission = 0.85; ion.LightInfluence = 0
                ion.MinLength = 0.1; ion.Enabled = false
                ion.Parent = host
            end
            local hub = Instance.new("Attachment"); hub.Parent = host
            local coreS = sep * 0.62
            local core = mkSprite(hub, TX_SGLOW, pal[1], NumberSequence.new({
                NSK(0, coreS * 0.55), NSK(0.1, coreS), NSK(1, coreS * 0.3) }), HEAD_TR, dur, 1)
            core.LockedToPart = true
            local haloS = sep * 1.7
            local halo = mkSprite(hub, TX_SGLOW, pal[2], NumberSequence.new({
                NSK(0, haloS * 0.5), NSK(0.12, haloS), NSK(1, haloS * 0.35) }), HALO_TR, dur, 1)
            halo.LockedToPart = true
            local gs = sep * 1.9
            local gl = mkSprite(hub, TX_STAR4, GLINT_C, NumberSequence.new({
                NSK(0, gs * 0.1), NSK(0.32, gs), NSK(1, gs * 0.14) }), GLINT_TR, glintD * 1.2, 0.55)
            gl.Rotation = NumberRange.new(0, 90)
            gl.RotSpeed = NumberRange.new(-16, 16)
            gl:Emit(1)
            table.insert(_starLive, {
                host = host, tr = tr, ion = ion, core = core, halo = halo, aT = aT, aB = aB,
                cf0 = cf0, dir = dir, dist = dist, dur = dur, sep = sep,
                t0 = tick() + glintD, started = false,
            })
            Debris:AddItem(host, glintD + dur + life * 2.8 + 0.6)
        end
        local function pickPal()
            local r = math.random()
            if r < 0.55 then
                return 1
            end
            if r < 0.92 then
                return 2
            end
            return 3
        end
        local function pickCls(pi)
            if pi == 3 then
                if math.random() < 0.6 then
                    return 3
                end
                return 2
            end
            local r = math.random()
            if r < 0.25 then
                return 1
            end
            if r < 0.7 then
                return 2
            end
            return 3
        end
        local function viewAz(cam)
            local lv = cam.CFrame.LookVector
            local az = math.atan2(lv.Z, lv.X)
            if math.random() < 0.35 then
                return math.random() * 6.283
            end
            return az
        end
        local function spawnSingle()
            local cam = Camera
            if not cam then
                return
            end
            local base = cam.CFrame.Position
            local az = viewAz(cam) + (math.random() - 0.5) * 1.5
            local el = math.rad(24 + math.random() * 30)
            local r  = 190 + math.random() * 130
            local ce = math.cos(el)
            local start = base + Vec(ce * math.cos(az) * r, math.sin(el) * r, ce * math.sin(az) * r)
            local hd = az + 1.5708 + (math.random() - 0.5) * 2.2
            local pi = pickPal()
            spawnStreak(start, Vec(math.cos(hd), -(0.05 + math.random() * 0.34), math.sin(hd)).Unit,
                pickCls(pi), pi, base.Y + FLOOR_H)
        end
        local function spawnShower()
            local cam = Camera
            if not cam then
                return
            end
            local base = cam.CFrame.Position
            local floorY = base.Y + FLOOR_H
            local raz = viewAz(cam) + (math.random() - 0.5) * 0.9
            local rel = math.rad(36 + math.random() * 16)
            local cr = math.cos(rel)
            local rv = Vec(cr * math.cos(raz), math.sin(rel), cr * math.sin(raz))
            local dn = (Vec(0, -1, 0) + rv * rv.Y).Unit
            local sd = rv:Cross(dn).Unit
            local pi = pickPal()
            local t = 0
            for _ = 1, 3 + math.random(0, 2) do
                t = t + 0.16 + math.random() * 0.42
                task.delay(t, function()
                    if not Config.Weather or not cfg("WeatherShootingStars", false) then
                        return
                    end
                    local phi = (math.random() - 0.5) * 2.8
                    local off = dn * math.cos(phi) + sd * math.sin(phi)
                    local th = math.rad(9 + math.random() * 24)
                    local ct, st = math.cos(th), math.sin(th)
                    local u = (rv * ct + off * st).Unit
                    if u.Y < MIN_SIN then
                        off = -off
                        u = (rv * ct + off * st).Unit
                    end
                    if u.Y < MIN_SIN then
                        return
                    end
                    local ci = 2
                    if th < 0.22 then
                        ci = 1
                    elseif th > 0.44 then
                        ci = 3
                    end
                    pcall(spawnStreak, base + u * (215 + math.random() * 75),
                        (off * ct - rv * st).Unit, ci, pi, floorY)
                end)
            end
        end
        local function stepStars(now)
            for i = #_starLive, 1, -1 do
                local s = _starLive[i]
                if not s.host.Parent then
                    table.remove(_starLive, i)
                else
                    local a = (now - s.t0) / s.dur
                    if a >= 1 then
                        s.tr.Enabled = false
                        if s.ion then
                            s.ion.Enabled = false
                        end
                        table.remove(_starLive, i)
                    elseif a >= 0 then
                        if not s.started then
                            s.started = true
                            s.tr.Enabled = true
                            s.core:Emit(1)
                            s.halo:Emit(1)
                            if s.ion then
                                s.ion.Enabled = true
                            end
                        end
                        s.host.CFrame = s.cf0 + s.dir * (s.dist * a)
                        if a > 0.7 then
                            local h = s.sep * 0.5 * (1 - (a - 0.7) / 0.3)
                            s.aT.Position = Vec(0, h, 0)
                            s.aB.Position = Vec(0, -h, 0)
                        end
                    end
                end
            end
        end
        startStars = function()
            if _starConn then
                return
            end
            _starNextT = tick() + 2 + math.random() * 4
            _starConn = RunService.Heartbeat:Connect(function()
                if not Config.Weather or not cfg("WeatherShootingStars", false) then
                    return
                end
                local now = tick()
                if now >= _starNextT then
                    local r = evRate("WeatherStarRate")
                    _starNextT = now + (5 + math.random() * 6) / r
                    if math.random() < math.min(0.06 * r, 0.35) then
                        pcall(spawnShower)
                    else
                        pcall(spawnSingle)
                        if math.random() < math.min(0.22 * r, 0.6) then
                            task.delay(0.3 + math.random() * 0.5, function()
                                pcall(spawnSingle)
                            end)
                        end
                    end
                end
                pcall(stepStars, now)
            end)
        end
        rescheduleStars = function()
            if not _starConn then
                return
            end
            _starNextT = math.min(_starNextT, tick() + 11 / evRate("WeatherStarRate"))
        end
        stopStars = function()
            if _starConn then
                _starConn:Disconnect()
                _starConn = nil
            end
            for _, s in _starLive do
                pcall(function() s.host:Destroy() end)
            end
            table.clear(_starLive)
        end
        registerSpectacle("StarShower", 1, function()
            if not cfg("WeatherShootingStars", false) then
                return
            end
            spawnShower()
        end)
    end)()
    local startFireflies, stopFireflies, refreshFireflies
    ;(function()
        local FF_N     = 7
        local FF_BODY  = Color3.fromRGB(215, 255, 120)
        local FF_LIGHT = Color3.fromRGB(244, 232, 120)
        local FF_DOWN  = Vec(0, -80, 0)
        local WANDER   = 28
        local FF_STEP  = 2
        local FF_SEG   = 1.2
        local FF_TRC = ColorSequence.new({ CSK(0, Color3.fromRGB(198, 255, 128)),
            CSK(0.45, Color3.fromRGB(216, 238, 108)), CSK(1, Color3.fromRGB(255, 196, 86)) })
        local FF_TRT = NumberSequence.new({ NSK(0, 0.36), NSK(0.35, 0.66), NSK(1, 1) })
        local FF_TRW = NumberSequence.new({ NSK(0, 0.8), NSK(0.3, 1), NSK(1, 0) })
        local _ff = { list = nil, conn = nil, folder = nil, burst = nil, burstHost = nil, n = 4 }
        local _swarm = { active = false, t0 = 0, cx = 0, cz = 0, y = 0 }
        local _ffRp = RaycastParams.new()
        _ffRp.FilterType = Enum.RaycastFilterType.Exclude
        local function groundY(camPos, x, z)
            local ch = lp and lp.Character
            if ch then
                _ffRp.FilterDescendantsInstances = { getFolder(), ch }
            else
                _ffRp.FilterDescendantsInstances = { getFolder() }
            end
            local hit = Workspace:Raycast(Vec(x, camPos.Y + 6, z), FF_DOWN, _ffRp)
            if hit then
                return hit.Position.Y
            end
            return camPos.Y - 7
        end
        local function pickWaypoint(H, camPos)
            local x = camPos.X + (math.random() - 0.5) * WANDER
            local z = camPos.Z + (math.random() - 0.5) * WANDER
            H.a = H.pos
            H.bpt = Vec(x, groundY(camPos, x, z) + 0.5 + math.random() * 3, z)
            H.dur = math.clamp((H.bpt - H.a).Magnitude / 2.2, 1.5, 6)
            H.t = 0
        end
        local function stepToward(cur, target, maxStep)
            local d = target - cur
            local m = d.Magnitude
            if m <= maxStep or m < 1e-4 then
                return target
            end
            return cur + d * (maxStep / m)
        end
        local function trailOff(H)
            H.calm = 0
            if H.trail.Enabled then
                H.trail.Enabled = false
                H.trail:Clear()
            end
        end
        local function buildFlies()
            local folder = Instance.new("Folder")
            folder.Name = "_wxFlies"; folder:SetAttribute("WX_Custom", true)
            folder.Parent = getFolder()
            _ff.folder = folder
            _ff.list = {}
            local cam = Camera
            local camPos
            if cam then camPos = cam.CFrame.Position else camPos = Vec(0, 0, 0) end
            for i = 1, FF_N do
                local b = mkBoltPart(FF_BODY, 0, Vec(0.25, 0.25, 0.25), CFrame.new(camPos), folder)
                b.Shape = Enum.PartType.Ball
                local light = Instance.new("PointLight")
                light.Color = FF_LIGHT; light.Range = 8; light.Brightness = 2.5
                light.Parent = b
                local halo = Instance.new("ParticleEmitter")
                halo:SetAttribute("WX_Custom", true)
                halo.Texture = TX_MGLOW
                halo.Color = ColorSequence.new(FF_BODY)
                halo.LightEmission = 1; halo.LightInfluence = 0
                halo.Size = NumberSequence.new(1.1, 1.5)
                halo.Transparency = NumberSequence.new({ NSK(0, 0.75), NSK(1, 1) })
                halo.Rate = 12; halo.Lifetime = NumberRange.new(0.25, 0.4)
                halo.Speed = NumberRange.new(0, 0)
                halo.LockedToPart = true
                halo.Parent = b
                local a0 = Instance.new("Attachment")
                a0.Position = Vec(0, 0.6, 0); a0.Parent = b
                local a1 = Instance.new("Attachment")
                a1.Position = Vec(0, -0.6, 0); a1.Parent = b
                local tr = Instance.new("Trail")
                tr:SetAttribute("WX_Custom", true)
                tr.Attachment0 = a0; tr.Attachment1 = a1
                tr.Texture = TX_MGLOW; tr.TextureMode = Enum.TextureMode.Stretch
                tr.Color = FF_TRC; tr.Transparency = FF_TRT; tr.WidthScale = FF_TRW
                tr.Lifetime = 0.65
                tr.LightEmission = 1; tr.LightInfluence = 0
                tr.FaceCamera = true
                tr.MinLength = 0.25; tr.MaxLength = 14
                tr.Enabled = false
                tr.Parent = b
                local H = { part = b, light = light, trail = tr, halo = halo, bm = 1,
                            calm = 0, jump = true,
                            pos = camPos, a = camPos, bpt = camPos, t = 0, dur = 1,
                            ph = math.random() * 6.283, spin = 1.7 + i * 0.25,
                            blinkT = math.random() * 3, period = 2.4 + math.random() * 1.4 }
                pickWaypoint(H, camPos)
                H.pos = H.bpt
                pickWaypoint(H, camPos)
                b.CFrame = CFrame.new(H.pos)
                _ff.list[i] = H
            end
            local bh = mkBoltPart(FF_BODY, 1, Vec(1.5, 1.5, 1.5), CFrame.new(camPos), folder)
            local be = Instance.new("ParticleEmitter")
            be:SetAttribute("WX_Custom", true)
            be.Texture = TX_MGLOW
            be.Color = ColorSequence.new(Color3.fromRGB(220, 255, 130), Color3.fromRGB(255, 200, 80))
            be.LightEmission = 0.95; be.LightInfluence = 0.05
            be.Size = NumberSequence.new({ NSK(0, 0.1), NSK(0.08, 0.62, 0.15), NSK(0.45, 0.5, 0.1), NSK(1, 0.08) })
            be.Transparency = NumberSequence.new({ NSK(0, 1), NSK(0.08, 0.08), NSK(0.4, 0.45), NSK(0.75, 0.85), NSK(1, 1) })
            be.Rate = 0; be.Lifetime = NumberRange.new(1.6, 2.8)
            be.Speed = NumberRange.new(0.8, 2.2); be.SpreadAngle = Vector2.new(180, 180)
            be.Drag = 2.5; be.EmissionDirection = Enum.NormalId.Top
            be.Parent = bh
            _ff.burst = be; _ff.burstHost = bh
        end
        refreshFireflies = function()
            local list = _ff.list
            if not list then
                return
            end
            local I = iAmt()
            _ff.n = math.clamp(math.floor(1.5 + 3 * I), 1, FF_N)
            local rm, bm = 0.8 + 0.2 * I, 0.7 + 0.3 * I
            for i = 1, FF_N do
                local H = list[i]
                local on = i <= _ff.n
                H.bm = bm
                H.light.Range = 8 * rm
                H.halo.Enabled = on
                if not on then
                    H.light.Brightness = 0
                    H.part.Transparency = 1
                    H.jump = true
                    trailOff(H)
                end
            end
        end
        startFireflies = function()
            if _ff.conn then return end
            buildFlies()
            refreshFireflies()
            local accum = 0
            _ff.conn = RunService.Heartbeat:Connect(function(dt)
                if not Config.Weather then return end
                accum = accum + dt
                if accum < 0.05 then return end
                local step = accum; accum = 0
                local cam = Camera; if not cam then return end
                local camPos = cam.CFrame.Position
                local now = tick()
                local sw = -1
                if _swarm.active then
                    sw = now - _swarm.t0
                    if sw > 9 then _swarm.active = false; sw = -1 end
                end
                local list = _ff.list
                for i = 1, _ff.n do
                    local H = list[i]
                    local prev = H.pos
                    local newPos
                    if sw >= 0 then
                        local ang = H.ph + now * H.spin
                        local r
                        if sw < 2.5 then r = 10 - 7.4 * (sw / 2.5)
                        elseif sw < 6.5 then r = 2.6
                        else r = 2.6 + (sw - 6.5) * 6 end
                        local target = Vec(_swarm.cx + math.cos(ang) * r,
                            _swarm.y + 0.55 * math.sin(now * 1.3 + H.ph * 2),
                            _swarm.cz + math.sin(ang) * r)
                        newPos = stepToward(prev, prev:Lerp(target, math.min(step * 3, 1)), FF_STEP)
                        H.bpt = newPos; H.t = 1; H.dur = 1
                    else
                        H.t = H.t + step
                        local relX, relZ = prev.X - camPos.X, prev.Z - camPos.Z
                        if H.t >= H.dur or (relX * relX + relZ * relZ) > 3600 then
                            pickWaypoint(H, camPos)
                        end
                        local u = H.t / H.dur
                        u = u * u * (3 - 2 * u)
                        newPos = stepToward(prev, H.a:Lerp(H.bpt, u), FF_STEP)
                    end
                    H.pos = newPos
                    if H.jump or (sw >= 0 and (sw < 2.5 or sw >= 6.4))
                        or (newPos - prev).Magnitude > FF_SEG then
                        H.jump = false
                        trailOff(H)
                    else
                        H.calm = H.calm + step
                        if H.calm >= 0.25 and not H.trail.Enabled then
                            H.trail:Clear()
                            H.trail.Enabled = true
                        end
                    end
                    H.part.CFrame = CFrame.new(H.pos.X, H.pos.Y + 0.3 * math.sin(now * 1.7 + H.ph), H.pos.Z)
                    local pulse = math.exp(-((now + H.blinkT) % H.period) * 1.4)
                    H.light.Brightness = (0.5 + 2.6 * pulse) * H.bm
                    H.part.Transparency = 0.4 * (1 - pulse)
                end
            end)
        end
        stopFireflies = function()
            if _ff.conn then _ff.conn:Disconnect(); _ff.conn = nil end
            if _ff.folder then pcall(function() _ff.folder:Destroy() end); _ff.folder = nil end
            _ff.list = nil; _ff.burst = nil; _ff.burstHost = nil
            _swarm.active = false
        end
        registerSpectacle("FireflySwarm", 1, function()
            if not Config.Weather or _curType ~= "Fireflies" or not _ff.list then return end
            local cam = Camera; if not cam then return end
            local camPos = cam.CFrame.Position
            local ang = math.random() * 6.283
            local d = 8 + math.random() * 8
            local cx = camPos.X + math.cos(ang) * d
            local cz = camPos.Z + math.sin(ang) * d
            _swarm.cx = cx; _swarm.cz = cz
            _swarm.y = groundY(camPos, cx, cz) + 2.2
            _swarm.t0 = tick(); _swarm.active = true
            _ff.burstHost.CFrame = CFrame.new(cx, _swarm.y, cz)
            for _, H in _ff.list do
                trailOff(H)
            end
            local em = math.max(1, math.floor(7 * iRate(iAmt(), IR.Fireflies.lo, IR.Fireflies.hi) + 0.5))
            for n = 0, 5 do
                task.delay(1.6 + n * 0.7, function()
                    if _swarm.active and _ff.burst then _ff.burst:Emit(em) end
                end)
            end
        end)
    end)()
    local stopLeafDevil
    ;(function()
        local RING_N   = 11
        local DEV_H    = 25
        local DEV_R    = 9.5
        local DEV_LIFE = 14
        local DEV_HOLD = 9.6
        local DEV_DOWN = Vec(0, -80, 0)
        local RELEASE  = Vec(-8, -3.5, 3)
        local RING_TEX  = { TX_LEAFA, TX_LEAFB, TX_LEAFA, TX_LEAFB, TX_LEAFC }
        local RING_GLOW = { 0.62, 0.07, 0.6, 0.08, 0.1 }
        local RING_COL  = {
            ColorSequence.new({ CSK(0, Color3.fromRGB(226,190,128)), CSK(0.45, Color3.fromRGB(255,246,200)),
                                CSK(1, Color3.fromRGB(190,132,62)) }),
            ColorSequence.new({ CSK(0, Color3.fromRGB(160,80,52)), CSK(1, Color3.fromRGB(104,44,30)) }),
            ColorSequence.new({ CSK(0, Color3.fromRGB(230,222,176)), CSK(0.5, Color3.fromRGB(255,254,228)),
                                CSK(1, Color3.fromRGB(200,180,122)) }),
            ColorSequence.new({ CSK(0, Color3.fromRGB(156,74,255)), CSK(1, Color3.fromRGB(106,46,200)) }),
            ColorSequence.new({ CSK(0, Color3.fromRGB(196,156,112)), CSK(1, Color3.fromRGB(146,110,74)) }),
        }
        local RING_SIZE = NumberSequence.new({ NSK(0, 0.56, 0.14), NSK(1, 0.46, 0.1) })
        local RING_TR   = NumberSequence.new({ NSK(0, 1), NSK(0.07, 0.05), NSK(0.78, 0.4), NSK(1, 1) })
        local RING_SQ   = NumberSequence.new({ NSK(0, -0.6), NSK(0.25, 0.16), NSK(0.5, -0.6),
                                               NSK(0.75, 0.16), NSK(1, -0.6) })
        local SKIRT_SIZE = NumberSequence.new({ NSK(0, 1.5), NSK(1, 4.4) })
        local SKIRT_TR   = NumberSequence.new({ NSK(0, 1), NSK(0.22, 0.82), NSK(0.75, 0.92), NSK(1, 1) })
        local LEAF_SIZE  = NumberSequence.new({ NSK(0, 0.52, 0.12), NSK(1, 0.44, 0.1) })
        local LEAF_TR    = NumberSequence.new({ NSK(0, 1), NSK(0.1, 0.08), NSK(0.75, 0.42), NSK(1, 1) })
        local DUCK_TI = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local BACK_TI = TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local _dev = { folder = nil, conn = nil }
        local _devRp = RaycastParams.new()
        _devRp.FilterType = Enum.RaycastFilterType.Exclude
        local function ambientRate(mul, ti)
            local I = iAmt()
            for _, L in _partLayers do
                if L.emitter and L.tag == nil then
                    if L.rateTween then L.rateTween:Cancel() end
                    L.rateMul = mul
                    local tw = TweenService:Create(L.emitter, ti, { Rate = layerRate(L, I) * mul })
                    L.rateTween = tw
                    tw:Play()
                end
            end
        end
        stopLeafDevil = function()
            if _dev.conn then _dev.conn:Disconnect(); _dev.conn = nil end
            if _dev.folder then pcall(function() _dev.folder:Destroy() end); _dev.folder = nil end
            if _dev.rings then
                _dev.rings = nil
                ambientRate(1, BACK_TI)
            end
        end
        local function mkRing(folder, cf, i, r)
            local p = mkBoltPart(WHITE, 1, Vec(0.3, 0.3, 0.3), cf, folder)
            local k = ((i - 1) % 5) + 1
            local glow = RING_GLOW[k]
            local e = Instance.new("ParticleEmitter")
            e:SetAttribute("WX_Custom", true)
            e.Texture = RING_TEX[k]
            e.Color = RING_COL[k]
            e.LightEmission = glow; e.LightInfluence = 1 - glow
            e.Size = RING_SIZE; e.Transparency = RING_TR; e.Squash = RING_SQ
            e.Rate = 0
            e.Lifetime = NumberRange.new(2, 3)
            e.Speed = NumberRange.new(5, 9)
            e.SpreadAngle = Vector2.new(8, 8)
            e.Rotation = NumberRange.new(-180, 180)
            e.RotSpeed = NumberRange.new(-300, 300)
            e.Acceleration = Vec(0, 2.6, 0)
            e.Drag = 1.4
            e.EmissionDirection = ND.Front
            e.Parent = p
            return { part = p, e = e, r = r }
        end
        registerSpectacle("LeafDevil", 1, function()
            if not Config.Weather or _curType ~= "Autumn" or _dev.conn then return end
            local cam = Camera; if not cam then return end
            local camPos = cam.CFrame.Position
            local bearing = math.random() * 6.283
            local dist = 18 + math.random() * 12
            local cx = camPos.X + math.cos(bearing) * dist
            local cz = camPos.Z + math.sin(bearing) * dist
            local ch = lp and lp.Character
            if ch then
                _devRp.FilterDescendantsInstances = { getFolder(), ch }
            else
                _devRp.FilterDescendantsInstances = { getFolder() }
            end
            local hit = Workspace:Raycast(Vec(cx, camPos.Y + 6, cz), DEV_DOWN, _devRp)
            local gy = camPos.Y - 4.6
            if hit then gy = hit.Position.Y end
            local folder = Instance.new("Folder")
            folder.Name = "_wxDevil"; folder:SetAttribute("WX_Custom", true)
            folder.Parent = getFolder()
            _dev.folder = folder
            local em = iRate(iAmt(), IR.Autumn.lo, IR.Autumn.hi)
            local seed = CFrame.new(cx, gy + 1, cz)
            local rings = table.create(RING_N)
            for i = 1, RING_N do
                local h = 0.8 + (i - 1) * (DEV_H - 0.8) / (RING_N - 1)
                local u = h / DEV_H
                local r = DEV_R * (0.15 + 0.85 * u ^ 0.9)
                if u > 0.72 then r = r * (1 + (u - 0.72) * 1.5) end
                local R = mkRing(folder, seed, i, r)
                R.h = h
                R.ph = (i - 1) * 0.62
                R.t0 = 0.12 * (i - 1)
                R.rate = (10 + 34 * (r / DEV_R)) * em
                rings[i] = R
            end
            _dev.rings = rings
            local foot = mkBoltPart(WHITE, 1, Vec(6.5, 0.4, 6.5), CFrame.new(cx, gy + 0.35, cz), folder)
            local leafSkirt = Instance.new("ParticleEmitter")
            leafSkirt:SetAttribute("WX_Custom", true)
            leafSkirt.Texture = TX_LEAFA
            leafSkirt.Color = RING_COL[1]
            leafSkirt.LightEmission = 0.3; leafSkirt.LightInfluence = 0.7
            leafSkirt.Size = LEAF_SIZE; leafSkirt.Transparency = LEAF_TR; leafSkirt.Squash = RING_SQ
            leafSkirt.Rate = 0
            leafSkirt.Lifetime = NumberRange.new(1.2, 2.2)
            leafSkirt.Speed = NumberRange.new(2, 5)
            leafSkirt.SpreadAngle = Vector2.new(70, 70)
            leafSkirt.Rotation = NumberRange.new(-180, 180)
            leafSkirt.RotSpeed = NumberRange.new(-260, 260)
            leafSkirt.Acceleration = Vec(0, 1.2, 0)
            leafSkirt.Drag = 2.2
            leafSkirt.EmissionDirection = ND.Top
            leafSkirt.Parent = foot
            local dustSkirt = Instance.new("ParticleEmitter")
            dustSkirt:SetAttribute("WX_Custom", true)
            dustSkirt.Texture = TX_DUST
            dustSkirt.Color = ColorSequence.new(Color3.fromRGB(190,166,130), Color3.fromRGB(140,118,90))
            dustSkirt.LightEmission = 0.04; dustSkirt.LightInfluence = 0.96
            dustSkirt.Size = SKIRT_SIZE; dustSkirt.Transparency = SKIRT_TR
            dustSkirt.Rate = 0
            dustSkirt.Lifetime = NumberRange.new(0.9, 1.4)
            dustSkirt.Speed = NumberRange.new(1, 2.6)
            dustSkirt.SpreadAngle = Vector2.new(85, 85)
            dustSkirt.RotSpeed = NumberRange.new(-25, 25)
            dustSkirt.Acceleration = Vec(0, 1, 0)
            dustSkirt.Drag = 2.4
            dustSkirt.EmissionDirection = ND.Top
            dustSkirt.Parent = foot
            local scuff = mkBoltPart(WHITE, 1, Vec(15, 0.08, 15), CFrame.new(cx, gy + 0.05, cz), folder)
            scuff.Material = Enum.Material.SmoothPlastic
            local sd = Instance.new("Decal")
            sd:SetAttribute("WX_Custom", true)
            sd.Face = ND.Top; sd.Texture = TX_DUST
            sd.Color3 = Color3.fromRGB(96, 74, 52); sd.Transparency = 0.55
            sd.Parent = scuff
            ambientRate(0.45, DUCK_TI)
            local t0 = tick()
            local ang, px, pz = 0, cx, cz
            local lean = math.random() * 6.283
            _dev.conn = RunService.Heartbeat:Connect(function(dt)
                if not folder.Parent then stopLeafDevil() return end
                local t = tick() - t0
                if t > DEV_LIFE then stopLeafDevil() return end
                ang = ang + dt * 2.7
                px = px + Wind.x * dt * 0.75
                pz = pz + Wind.z * dt * 0.75
                local lx = math.cos(lean + t * 0.21) * 0.13
                local lz = math.sin(lean + t * 0.17) * 0.13
                local climb = math.min(t / 1.5, 1)
                local release = t > DEV_HOLD
                for i = 1, RING_N do
                    local R = rings[i]
                    local h = R.h * climb
                    local th = ang + R.ph
                    local cs, sn = math.cos(th), math.sin(th)
                    local r = R.r * (0.55 + 0.45 * climb)
                    local p = Vec(px + lx * h + cs * r, gy + 0.35 + h, pz + lz * h + sn * r)
                    R.part.CFrame = CFrame.lookAt(p, p + Vec(-sn, 0.3, cs))
                    if release then
                        R.e.Rate = 0
                        R.e.Acceleration = RELEASE
                    else
                        R.e.Rate = R.rate * math.clamp((t - R.t0) / 0.6, 0, 1)
                    end
                end
                foot.CFrame = CFrame.new(px, gy + 0.35, pz)
                scuff.CFrame = CFrame.new(px, gy + 0.05, pz) * CFrame.Angles(0, t * 0.35, 0)
                if release then
                    leafSkirt.Rate = 0
                    dustSkirt.Rate = 0
                    leafSkirt.Acceleration = RELEASE
                    sd.Transparency = math.min(0.55 + (t - DEV_HOLD) * 0.35, 1)
                    if t > DEV_HOLD + 0.1 and _dev.rings then
                        _dev.rings = nil
                        ambientRate(1, BACK_TI)
                    end
                else
                    local k = math.min(t / 0.8, 1)
                    leafSkirt.Rate = 26 * em * k
                    dustSkirt.Rate = 15 * em * k
                    sd.Transparency = 0.95 - 0.4 * math.min(t / 1.2, 1)
                end
            end)
        end)
    end)()
    local puddlesRefresh, puddlesIntensity, stopPuddles
    ;(function()
        local TXP_RING = "rbxassetid://17738857765"
        local TXP_DROP = "rbxassetid://14964503448"
        local TXP_STAR = "rbxassetid://17726943419"
        local WATER_C  = Color3.fromRGB(22, 28, 37)
        local SHEEN_C  = Color3.fromRGB(150, 175, 205)
        local FOAM_C   = Color3.fromRGB(236, 246, 255)
        local PUD_DOWN = Vec(0, -90, 0)
        local FIT_DOWN = Vec(0, -4.2, 0)
        local HALF_PI  = 1.5707963
        local FIT_TOL  = 1.5
        local FIT_R    = 1.09
        local FIT_K    = { 1, 0.66, 0.44, 0.28 }
        local FIT_C = {
            1, 0, 0.70711, 0.70711, 0, 1, -0.70711, 0.70711,
            -1, 0, -0.70711, -0.70711, 0, -1, 0.70711, -0.70711,
        }
        local FIT_Q = {
            1, 1, 0.333, 1, -0.333, 1, -1, 1,
            -1, 0.333, -1, -0.333, -1, -1, -0.333, -1,
            0.333, -1, 1, -1, 1, -0.333, 1, 0.333,
        }
        local CELL     = 32
        local HALF     = 16
        local NOISE_F  = 0.018
        local POOL_F   = 0.74
        local TILE_K   = 1 / 470
        local K_CAP    = 48
        local MAX_REC  = 96
        local _pud = { folder = nil, conn = nil }
        local _plist = {}
        local _pmap = {}
        local _pfail = {}
        local _cd = { i = 0, j = 0, key = 0, kind = 0, cx = 0, cz = 0, gy = 0 }
        local _units, _uIdx = {}, 1
        local _prints, _pIdx = {}, 1
        local _pstates = {}
        local _abuf = {}
        local _prp = RaycastParams.new()
        _prp.FilterType = Enum.RaycastFilterType.Exclude
        local _pfilter = {}
        local _fieldToken, _rebuild = 0, false
        local _int, _thr, _placeR, _seed = 1, 0, 50, 0
        local _wTr, _wRf = 0.35, 0.16
        local _homeI, _homeJ = 1e9, 1e9
        local function pudActive()
            if not Config.Weather or not cfg("WeatherPuddles", false) then
                return false
            end
            if _curType == "Rain" then
                return true
            end
            return cfg("WeatherStorm", false)
        end
        local function pudIntensity()
            return iAmt()
        end
        local function mkFlatPart(size, cf, parent)
            local p = Instance.new("Part")
            p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
            p.CastShadow = false; p.Transparency = 1
            p.Size = size; p.CFrame = cf
            p:SetAttribute("WX_Custom", true)
            p.Parent = parent
            return p
        end
        local function mkSlab(d1, d2, cf, parent, sheen)
            local p = Instance.new("Part")
            p.Shape = Enum.PartType.Cylinder
            p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
            p.CastShadow = false; p.Material = Enum.Material.SmoothPlastic
            if sheen then
                p.Color = SHEEN_C; p.Transparency = 0.74; p.Reflectance = 0.38
            else
                p.Color = WATER_C; p.Transparency = _wTr; p.Reflectance = _wRf
                p:SetAttribute("WX_W", true)
            end
            p.Size = Vec(0.05, d1, d2)
            p.CFrame = cf
            p:SetAttribute("WX_Custom", true)
            p.Parent = parent
        end
        local function mkTile(w, l, cf, parent)
            local p = Instance.new("Part")
            p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
            p.CastShadow = false; p.Material = Enum.Material.SmoothPlastic
            p.Color = WATER_C; p.Transparency = _wTr; p.Reflectance = _wRf
            p.Size = Vec(w, 0.05, l)
            p.CFrame = cf
            p:SetAttribute("WX_Custom", true)
            p:SetAttribute("WX_W", true)
            p.Parent = parent
        end
        local function fitSlab(cx, cz, d1, d2, yaw, gy)
            local cs, sn = math.cos(yaw), math.sin(yaw)
            for k = 1, 4 do
                local f = FIT_K[k] * FIT_R * 0.5
                local a, b = d1 * f, d2 * f
                local ok, gx, gz, n = true, 0, 0, 0
                for i = 1, 8 do
                    local ct, st = FIT_C[i * 2 - 1], FIT_C[i * 2]
                    local ox = sn * b * st - cs * a * ct
                    local oz = sn * a * ct + cs * b * st
                    local h = Workspace:Raycast(Vec(cx + ox, gy + 2, cz + oz), FIT_DOWN, _prp)
                    local sup = false
                    if h and h.Normal.Y >= 0.86 and h.Instance.CanCollide then
                        local dy = h.Position.Y - gy
                        sup = dy < FIT_TOL and dy > -FIT_TOL
                    end
                    if sup then
                        gx, gz, n = gx + ox, gz + oz, n + 1
                    else
                        ok = false
                    end
                end
                if ok then
                    return cx, cz, d1 * FIT_K[k], d2 * FIT_K[k]
                end
                if n == 0 then
                    return nil
                end
                cx, cz = cx + gx / n * 0.5, cz + gz / n * 0.5
            end
            return nil
        end
        local function fitRect(cx, cz, w, l, gy)
            for k = 1, 4 do
                local f = FIT_K[k] * FIT_R * 0.5
                local a, b = w * f, l * f
                local ok = true
                for i = 1, 12 do
                    local h = Workspace:Raycast(
                        Vec(cx + FIT_Q[i * 2 - 1] * a, gy + 2, cz + FIT_Q[i * 2] * b), FIT_DOWN, _prp)
                    local sup = false
                    if h and h.Normal.Y >= 0.86 and h.Instance.CanCollide then
                        local dy = h.Position.Y - gy
                        sup = dy < FIT_TOL and dy > -FIT_TOL
                    end
                    if not sup then
                        ok = false
                        break
                    end
                end
                if ok then
                    return w * FIT_K[k], l * FIT_K[k]
                end
            end
            return nil
        end
        local function mkHost(m, cf, size, k, I)
            local host = mkFlatPart(size, cf, m)
            local e = Instance.new("ParticleEmitter")
            e:SetAttribute("WX_Custom", true)
            e.Texture = TXP_RING
            e.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            e.EmissionDirection = Enum.NormalId.Top
            e.Speed = NumberRange.new(0.05, 0.05)
            e.Rate = (2.1 + 4.2 * I) * k
            e.Lifetime = NumberRange.new(1.1, 1.6)
            e.Size = NumberSequence.new({ NSK(0, 0.12), NSK(1, 4.4) })
            e.Transparency = NumberSequence.new({ NSK(0, 0.9), NSK(0.14, 0.12), NSK(0.62, 0.5), NSK(1, 1) })
            e.Color = ColorSequence.new(Color3.fromRGB(215, 234, 250))
            e.LightEmission = 0.45
            e.Parent = host
            local g = Instance.new("ParticleEmitter")
            g:SetAttribute("WX_Custom", true)
            g.Texture = TXP_STAR
            g.EmissionDirection = Enum.NormalId.Top
            g.Speed = NumberRange.new(0, 0)
            g.Rate = 0.8 * I * k
            g.Lifetime = NumberRange.new(0.16, 0.28)
            g.Size = NumberSequence.new({ NSK(0, 0.06), NSK(0.4, 0.3), NSK(1, 0.04) })
            g.Transparency = NumberSequence.new({ NSK(0, 0.6), NSK(1, 1) })
            g.Color = ColorSequence.new(Color3.fromRGB(240, 248, 255))
            g.LightEmission = 0.5
            g.Parent = host
            return e, g
        end
        local function mkPuddle(cd, span, nslab, I)
            local x, z, gy = cd.cx, cd.cz, cd.gy
            local m = Instance.new("Model")
            m.Name = "_pud"
            local px = x + (math.random() - 0.5) * CELL * 0.16
            local pz = z + (math.random() - 0.5) * CELL * 0.16
            local spine = math.random() * 6.28318
            local sx, sz = math.cos(spine), math.sin(spine)
            local lx, lz = -sz, sx
            local yaw0 = math.pi - spine
            local slabs, rmax = {}, 0
            local s0, s1, l0, l1 = 1e9, -1e9, 1e9, -1e9
            local function place(cx, cz, d1, d2, yaw, yoff, sheen)
                local fx, fz, fd1, fd2 = fitSlab(cx, cz, d1, d2, yaw, gy)
                if not fx then
                    return false
                end
                local rad = math.max(fd1, fd2) * 0.5
                local ex, ez = fx - x, fz - z
                if math.abs(ex) + rad > HALF or math.abs(ez) + rad > HALF then
                    return false
                end
                mkSlab(fd1, fd2, CFrame.new(fx, gy + yoff, fz)
                    * CFrame.Angles(0, yaw, 0) * CFrame.Angles(0, 0, HALF_PI), m, sheen)
                if not sheen then
                    slabs[#slabs + 1] = {
                        cx = fx, cz = fz,
                        cs = math.cos(yaw), sn = math.sin(yaw),
                        ia = 2 / fd1, ib = 2 / fd2, rect = false,
                    }
                    rmax = math.max(rmax, math.sqrt(ex * ex + ez * ez) + rad)
                end
                local dx, dz = fx - px, fz - pz
                local t, lat = dx * sx + dz * sz, dx * lx + dz * lz
                local ins = math.min(fd1, fd2) * 0.375
                s0, s1 = math.min(s0, t - ins), math.max(s1, t + ins)
                l0, l1 = math.min(l0, lat - ins), math.max(l1, lat + ins)
                return true
            end
            if not place(px, pz, span, span * 0.62, yaw0, 0.002, false) then
                m:Destroy()
                return false
            end
            for i = 1, nslab do
                local t = ((i - 0.5) / nslab - 0.5) * span * 0.62 + (math.random() - 0.5) * span * 0.14
                local lat = (math.random() - 0.5) * span * 0.24
                local d1 = span * (0.34 + math.random() * 0.3)
                place(px + sx * t + lx * lat, pz + sz * t + lz * lat,
                    d1, d1 * (0.6 + math.random() * 0.34),
                    yaw0 + (math.random() - 0.5) * 1.6, 0.008 + i * 0.004, false)
            end
            for _ = 1, 2 do
                local t = (math.random() - 0.5) * span * 0.5
                local lat = (math.random() - 0.5) * span * 0.16
                local d1 = span * (0.14 + math.random() * 0.18)
                place(px + sx * t + lx * lat, pz + sz * t + lz * lat,
                    d1, d1 * (0.4 + math.random() * 0.35), math.random() * math.pi, 0.036, true)
            end
            s0, s1 = math.max(s0, span * -0.425), math.min(s1, span * 0.425)
            l0, l1 = math.max(l0, span * -0.225), math.min(l1, span * 0.225)
            local hw, hl = math.max(s1 - s0, 1), math.max(l1 - l0, 1)
            local hm, hn = (s0 + s1) * 0.5, (l0 + l1) * 0.5
            local k = (span / 26) ^ 1.5 * hw * hl / (span * span * 0.3825)
            local e, g = mkHost(m, CFrame.new(px + sx * hm + lx * hn, gy + 0.1, pz + sz * hm + lz * hn)
                * CFrame.Angles(0, -spine, 0), Vec(hw, 0.05, hl), k, I)
            m.Parent = _pud.folder
            local P = {
                cx = x, cz = z, top = gy + 0.06, r2 = rmax * rmax, k = k,
                key = cd.key, ci = cd.i, cj = cd.j, kind = cd.kind,
                slabs = slabs, ring = e, glint = g, model = m,
            }
            _plist[#_plist + 1] = P
            _pmap[cd.key] = P
            return true
        end
        local function mkFloodCell(cd, I)
            local gy = cd.gy
            local m = Instance.new("Model")
            m.Name = "_pud"
            local slabs = {}
            local area, rmax = 0, 0
            local x0, x1, z0, z1 = 1e9, -1e9, 1e9, -1e9
            for a = 0, 1 do
                for b = 0, 1 do
                    local scx = cd.cx + (a - 0.5) * HALF
                    local scz = cd.cz + (b - 0.5) * HALF
                    local fw, fl = fitRect(scx, scz, HALF, HALF, gy)
                    if fw then
                        mkTile(fw, fl, CFrame.new(scx, gy + 0.002, scz), m)
                        slabs[#slabs + 1] = {
                            cx = scx, cz = scz, cs = 1, sn = 0,
                            ia = 2 / fw, ib = 2 / fl, rect = true,
                        }
                        area = area + fw * fl
                        rmax = math.max(rmax, 0.7072 * (HALF + fw))
                        x0 = math.min(x0, scx - fw * 0.5)
                        x1 = math.max(x1, scx + fw * 0.5)
                        z0 = math.min(z0, scz - fl * 0.5)
                        z1 = math.max(z1, scz + fl * 0.5)
                    end
                end
            end
            if area <= 0 then
                m:Destroy()
                return false
            end
            if area > CELL * CELL * 0.98 and math.random() < 0.45 then
                local d1 = CELL * (0.15 + math.random() * 0.1)
                local sx = cd.cx + (math.random() - 0.5) * CELL * 0.4
                local sz = cd.cz + (math.random() - 0.5) * CELL * 0.4
                local yaw = math.random() * math.pi
                local fx, fz, fd1, fd2 = fitSlab(sx, sz, d1, d1 * (0.4 + math.random() * 0.35), yaw, gy)
                if fx and math.abs(fx - cd.cx) + fd1 * 0.5 < HALF
                    and math.abs(fz - cd.cz) + fd1 * 0.5 < HALF then
                    mkSlab(fd1, fd2, CFrame.new(fx, gy + 0.036, fz)
                        * CFrame.Angles(0, yaw, 0) * CFrame.Angles(0, 0, HALF_PI), m, true)
                end
            end
            local hw, hl = math.max(x1 - x0, 1), math.max(z1 - z0, 1)
            local e, g = mkHost(m, CFrame.new((x0 + x1) * 0.5, gy + 0.1, (z0 + z1) * 0.5),
                Vec(hw, 0.05, hl), area * TILE_K, I)
            m.Parent = _pud.folder
            local P = {
                cx = cd.cx, cz = cd.cz, top = gy + 0.06, r2 = rmax * rmax, k = area * TILE_K,
                key = cd.key, ci = cd.i, cj = cd.j, kind = cd.kind,
                slabs = slabs, ring = e, glint = g, model = m,
            }
            _plist[#_plist + 1] = P
            _pmap[cd.key] = P
            return true
        end
        local function mkSplashUnit(parent)
            local p = mkFlatPart(Vec(1.1, 0.1, 1.1), CFrame.new(0, -900, 0), parent)
            local ring = Instance.new("ParticleEmitter")
            ring:SetAttribute("WX_Custom", true)
            ring.Texture = TXP_RING
            ring.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            ring.EmissionDirection = Enum.NormalId.Top
            ring.Speed = NumberRange.new(0.05, 0.05)
            ring.Rate = 0
            ring.Lifetime = NumberRange.new(0.45, 0.7)
            ring.Size = NumberSequence.new({ NSK(0, 0.1), NSK(1, 4) })
            ring.Transparency = NumberSequence.new({ NSK(0, 0.75), NSK(0.1, 0.05), NSK(0.5, 0.4), NSK(1, 1) })
            ring.Color = ColorSequence.new(Color3.fromRGB(230, 244, 255))
            ring.LightEmission = 0.5
            ring.Parent = p
            local foam = Instance.new("ParticleEmitter")
            foam:SetAttribute("WX_Custom", true)
            foam.Texture = TX_SNOWSOFT
            foam.Orientation = Enum.ParticleOrientation.VelocityParallel
            foam.EmissionDirection = Enum.NormalId.Top
            foam.Rate = 0
            foam.SpreadAngle = Vector2.new(56, 56)
            foam.Acceleration = Vec(0, -80, 0)
            foam.Lifetime = NumberRange.new(0.3, 0.6)
            foam.Size = NumberSequence.new({ NSK(0, 0.6, 0.22), NSK(1, 0.2) })
            foam.Squash = NumberSequence.new({ NSK(0, 1.5), NSK(1, 0.4) })
            foam.Speed = NumberRange.new(6, 12)
            foam.Color = ColorSequence.new(FOAM_C)
            foam.Transparency = NumberSequence.new({ NSK(0, 0.18), NSK(0.7, 0.45), NSK(1, 1) })
            foam.LightEmission = 0.18
            foam.Parent = p
            local drops = Instance.new("ParticleEmitter")
            drops:SetAttribute("WX_Custom", true)
            drops.Texture = TXP_DROP
            drops.Orientation = Enum.ParticleOrientation.VelocityParallel
            drops.EmissionDirection = Enum.NormalId.Top
            drops.Rate = 0
            drops.SpreadAngle = Vector2.new(52, 52)
            drops.Acceleration = Vec(0, -80, 0)
            drops.Lifetime = NumberRange.new(0.32, 0.62)
            drops.Size = NumberSequence.new({ NSK(0, 0.55, 0.18), NSK(1, 0.28) })
            drops.Speed = NumberRange.new(6, 12)
            drops.Color = ColorSequence.new(Color3.fromRGB(210, 232, 250))
            drops.Transparency = NumberSequence.new({ NSK(0, 0.1), NSK(0.75, 0.3), NSK(1, 1) })
            drops.LightEmission = 0.25
            drops.Parent = p
            local mist = Instance.new("ParticleEmitter")
            mist:SetAttribute("WX_Custom", true)
            mist.Texture = TX_SNOWSOFT
            mist.EmissionDirection = Enum.NormalId.Top
            mist.Rate = 0
            mist.Speed = NumberRange.new(1.2, 2.8)
            mist.SpreadAngle = Vector2.new(48, 48)
            mist.Lifetime = NumberRange.new(0.3, 0.5)
            mist.Size = NumberSequence.new({ NSK(0, 0.5), NSK(1, 1.6) })
            mist.Transparency = NumberSequence.new({ NSK(0, 0.75), NSK(1, 1) })
            mist.Color = ColorSequence.new(FOAM_C)
            mist.LightEmission = 0.1
            mist.Parent = p
            return { part = p, ring = ring, foam = foam, drops = drops, mist = mist }
        end
        local function fireSplash(x, y, z, speed)
            local u = _units[_uIdx]
            if not u then
                return
            end
            _uIdx = (_uIdx % #_units) + 1
            local s = math.clamp(speed, 4, 36)
            u.part.CFrame = CFrame.new(x, y + 0.12, z)
            u.ring.Size = NumberSequence.new({ NSK(0, 0.1), NSK(1, 3.2 + s * 0.18) })
            local lo, hi = 5 + s * 0.38, 8 + s * 0.6
            u.foam.Speed = NumberRange.new(lo, hi)
            u.drops.Speed = NumberRange.new(lo * 0.8, hi * 0.9)
            u.ring:Emit(2)
            u.foam:Emit(9 + math.floor(s * 0.75))
            u.drops:Emit(4 + math.floor(s * 0.3))
            u.mist:Emit(3)
        end
        local function dropPrint(x, y, z, heading, side)
            local p = _prints[_pIdx]
            if not p then
                return
            end
            _pIdx = (_pIdx % #_prints) + 1
            p.CFrame = CFrame.new(x, y + 0.02, z) * CFrame.Angles(0, heading, 0) * CFrame.new(side * 0.4, 0, 0)
            p.Transparency = 0.42
            TweenService:Create(p, TweenInfo.new(2.2), { Transparency = 1 }):Play()
        end
        local function defaultActors()
            local n = 0
            local cam = Camera
            if not cam then
                return _abuf, 0
            end
            local camPos = cam.CFrame.Position
            for _, plr in Players:GetPlayers() do
                local ch = plr.Character
                local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos = hrp.Position
                    local dx, dy, dz = pos.X - camPos.X, pos.Y - camPos.Y, pos.Z - camPos.Z
                    if dx * dx + dy * dy + dz * dz < 12100 then
                        local vel = hrp.AssemblyLinearVelocity
                        local grounded = vel.Y > -6 and vel.Y < 6
                        if not grounded then
                            local hum = ch:FindFirstChildOfClass("Humanoid")
                            grounded = hum ~= nil and hum.FloorMaterial ~= Enum.Material.Air
                        end
                        n = n + 1
                        local rec = _abuf[n]
                        if not rec then
                            rec = {}
                            _abuf[n] = rec
                        end
                        rec.key = plr
                        rec.fx, rec.fy, rec.fz = pos.X, pos.Y - 2.9, pos.Z
                        rec.vx, rec.vy, rec.vz = vel.X, vel.Y, vel.Z
                        rec.speed = math.sqrt(vel.X * vel.X + vel.Z * vel.Z)
                        rec.grounded = grounded
                    end
                end
            end
            return _abuf, n
        end
        local actorsProvider = defaultActors
        local function inPuddle(P, x, z)
            local dx, dz = x - P.cx, z - P.cz
            if dx * dx + dz * dz > P.r2 then
                return false
            end
            for _, sl in P.slabs do
                local ux, uz = x - sl.cx, z - sl.cz
                local u = (-ux * sl.cs + uz * sl.sn) * sl.ia
                local v = (ux * sl.sn + uz * sl.cs) * sl.ib
                if sl.rect then
                    if u > -1 and u < 1 and v > -1 and v < 1 then
                        return true
                    end
                elseif u * u + v * v <= 1 then
                    return true
                end
            end
            return false
        end
        local function fieldAt(wx, wz)
            return math.noise(wx * NOISE_F, wz * NOISE_F, _seed)
        end
        local function floodThr(I)
            if I <= 1 then
                return -0.4043 * (I - 0.3)
            end
            if I <= 1.6 then
                return -0.283 - 0.3417 * (I - 1)
            end
            return -0.488 - 1.405 * (I - 1.6)
        end
        local function refreshParams()
            local I = pudIntensity()
            _int = I
            _thr = floodThr(I)
            _placeR = 46 + 20 * I
            _wTr = 0.46 - 0.11 * I
            _wRf = 0.11 + 0.05 * I
        end
        local function cellKind(i, j)
            local ccx, ccz = (i + 0.5) * CELL, (j + 0.5) * CELL
            if fieldAt(ccx, ccz) <= _thr then
                return 0
            end
            if fieldAt(ccx + CELL, ccz) > _thr and fieldAt(ccx - CELL, ccz) > _thr
                and fieldAt(ccx, ccz + CELL) > _thr and fieldAt(ccx, ccz - CELL) > _thr then
                return 2
            end
            return 1
        end
        local function placeCell(i, j, key, kind, by)
            local folder = _pud.folder
            if not folder then
                return false
            end
            local ccx, ccz = (i + 0.5) * CELL, (j + 0.5) * CELL
            _pfilter[1] = folder
            local ch = lp and lp.Character
            if ch then
                _pfilter[2] = ch
            else
                _pfilter[2] = folder
            end
            _prp.FilterDescendantsInstances = _pfilter
            local hit = Workspace:Raycast(Vec(ccx, by + 6, ccz), PUD_DOWN, _prp)
            if not hit or hit.Normal.Y < 0.94 then
                return false
            end
            local inst = hit.Instance
            if not inst.CanCollide then
                return false
            end
            if inst:IsA("Terrain") and hit.Material == Enum.Material.Water then
                return false
            end
            local cd = _cd
            cd.i, cd.j, cd.key, cd.kind = i, j, key, kind
            cd.cx, cd.cz, cd.gy = ccx, ccz, hit.Position.Y
            if kind == 2 then
                return mkFloodCell(cd, _int)
            end
            local nslab = 5
            if _int > 1.15 then
                nslab = 4
            end
            return mkPuddle(cd, CELL * POOL_F * (0.82 + 0.24 * math.random()), nslab, _int)
        end
        local function tryCell(i, j, bx, bz, by)
            local key = (i + 32768) * 65536 + j + 32768
            if _pmap[key] or _pfail[key] then
                return false
            end
            local dx = (i + 0.5) * CELL - bx
            local dz = (j + 0.5) * CELL - bz
            if dx * dx + dz * dz > _placeR * _placeR then
                return false
            end
            local kind = cellKind(i, j)
            if kind == 0 then
                return false
            end
            if not placeCell(i, j, key, kind, by) then
                _pfail[key] = true
            end
            return true
        end
        local function maintain(bx, by, bz)
            local ci, cj = math.floor(bx / CELL), math.floor(bz / CELL)
            local budget = 8
            if ci ~= _homeI or cj ~= _homeJ then
                _homeI, _homeJ = ci, cj
                table.clear(_pfail)
            end
            if _rebuild then
                _rebuild = false
                refreshParams()
                table.clear(_pfail)
                budget = 18
                for _, P in _plist do
                    for _, d in P.model:GetChildren() do
                        if d:GetAttribute("WX_W") then
                            d.Transparency = _wTr
                            d.Reflectance = _wRf
                        end
                    end
                end
                local n = 1
                while n <= #_plist do
                    local P = _plist[n]
                    if P.kind == cellKind(P.ci, P.cj) then
                        n = n + 1
                    else
                        _pmap[P.key] = nil
                        P.model:Destroy()
                        _plist[n] = _plist[#_plist]
                        _plist[#_plist] = nil
                    end
                end
            end
            local cull = _placeR + CELL * 0.75
            local cull2 = cull * cull
            local n = 1
            while n <= #_plist do
                local P = _plist[n]
                local dx, dz = P.cx - bx, P.cz - bz
                if dx * dx + dz * dz > cull2 then
                    _pmap[P.key] = nil
                    P.model:Destroy()
                    _plist[n] = _plist[#_plist]
                    _plist[#_plist] = nil
                else
                    n = n + 1
                end
            end
            local nr = math.ceil(_placeR / CELL)
            for ring = 0, nr do
                for di = -ring, ring do
                    for dj = -ring, ring do
                        if budget > 0 and #_plist < MAX_REC
                            and math.max(math.abs(di), math.abs(dj)) == ring
                            and tryCell(ci + di, cj + dj, bx, bz, by) then
                            budget = budget - 1
                        end
                    end
                end
            end
            local ksum = 0
            for _, P in _plist do
                ksum = ksum + P.k
            end
            local damp = 1
            if ksum > K_CAP then
                damp = K_CAP / ksum
            end
            local rr = (2.1 + 4.2 * _int) * damp
            local gr = 0.8 * _int * damp
            for _, P in _plist do
                P.ring.Rate = rr * P.k
                P.glint.Rate = gr * P.k
            end
        end
        local function tick20(now, doMaintain)
            local bx, by, bz
            local ch = lp and lp.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                local p = hrp.Position
                bx, by, bz = p.X, p.Y, p.Z
            elseif Camera then
                local p = Camera.CFrame.Position
                bx, by, bz = p.X, p.Y, p.Z
            else
                return
            end
            if doMaintain then
                maintain(bx, by, bz)
            end
            local list, n = actorsProvider()
            for ai = 1, n do
                local a = list[ai]
                local st = _pstates[a.key]
                if not st then
                    st = { last = 0, wet = 0, side = 1, prevVy = 0 }
                    _pstates[a.key] = st
                end
                local sp = a.speed
                local pud = nil
                for _, P in _plist do
                    if math.abs(a.fy - P.top) < 4.5 and inPuddle(P, a.fx, a.fz) then
                        pud = P
                        break
                    end
                end
                local interval = math.clamp(3.6 / math.max(sp, 1), 0.15, 0.32)
                if pud and a.grounded and sp > 2.2 then
                    local landing = st.prevVy < -25
                    if landing or now - st.last >= interval then
                        st.last = now
                        st.side = -st.side
                        local fs = sp
                        if landing then
                            fs = 36
                        end
                        fireSplash(a.fx, pud.top, a.fz, fs)
                        st.wet = now + 1.7
                    end
                elseif not pud and now < st.wet and a.grounded and sp > 2.2 then
                    if now - st.last >= interval then
                        st.last = now
                        st.side = -st.side
                        dropPrint(a.fx, a.fy, a.fz, math.atan2(-a.vx, -a.vz), st.side)
                    end
                end
                st.prevVy = a.vy
            end
        end
        local function startPuddles()
            if _pud.conn then
                return
            end
            local folder = Instance.new("Folder")
            folder.Name = "_wxPuddles"
            folder:SetAttribute("WX_Custom", true)
            folder.Parent = getFolder()
            _pud.folder = folder
            _plist = {}
            _pmap = {}
            table.clear(_pfail)
            _seed = math.random() * 512
            _homeI, _homeJ = 1e9, 1e9
            refreshParams()
            _units, _uIdx = {}, 1
            for i = 1, 8 do
                _units[i] = mkSplashUnit(folder)
            end
            _prints, _pIdx = {}, 1
            for i = 1, 12 do
                local p = mkFlatPart(Vec(0.6, 0.02, 1.0), CFrame.new(0, -900, 0), folder)
                p.Material = Enum.Material.SmoothPlastic
                p.Color = Color3.fromRGB(14, 18, 25)
                p.Reflectance = 0.18
                _prints[i] = p
            end
            local accum = 0
            local mTick = 0
            _pud.conn = RunService.Heartbeat:Connect(function(dt)
                accum = accum + dt
                if accum < 0.05 then
                    return
                end
                accum = 0
                if not pudActive() then
                    return
                end
                mTick = mTick + 1
                local doMaintain = false
                if mTick >= 14 then
                    mTick = 0
                    doMaintain = true
                end
                pcall(tick20, os.clock(), doMaintain)
            end)
        end
        function stopPuddles(hard)
            if _pud.conn then
                _pud.conn:Disconnect()
                _pud.conn = nil
            end
            table.clear(_pstates)
            local folder = _pud.folder
            _pud.folder = nil
            _plist = {}
            _pmap = {}
            table.clear(_pfail)
            _units = {}
            _prints = {}
            _rebuild = false
            if not folder then
                return
            end
            if hard then
                folder:Destroy()
                return
            end
            for _, m in folder:GetDescendants() do
                if m:IsA("ParticleEmitter") then
                    m.Rate = 0
                elseif m:IsA("Part") and m.Transparency < 1 then
                    TweenService:Create(m, TweenInfo.new(1.4, Enum.EasingStyle.Sine), { Transparency = 1 }):Play()
                end
            end
            task.delay(2.2, function()
                pcall(function() folder:Destroy() end)
            end)
        end
        function puddlesRefresh()
            if pudActive() then
                startPuddles()
            else
                stopPuddles(false)
            end
        end
        function puddlesIntensity()
            if not _pud.conn then
                return
            end
            _fieldToken = _fieldToken + 1
            local token = _fieldToken
            task.delay(0.25, function()
                if token ~= _fieldToken then
                    return
                end
                _rebuild = true
            end)
        end
    end)()
    local function startClock()
        if _clockConn then return end
        local accum = 0
        _clockConn = RunService.Heartbeat:Connect(function(dt)
            accum = accum + dt
            if accum < 1 then return end
            accum = 0
            if not Config.Weather or not cfg("WeatherClockDial", false) then return end
            if Config.Visuals then return end
            local cycle = math.max(cfg("WeatherClockCycleMin", 8), 1) * 60
            local t = ((tick() % cycle) / cycle) * 24
            if math.abs(Lighting.ClockTime - t) > 0.02 then
                Lighting.ClockTime = t
            end
        end)
    end
    local function stopClock()
        if _clockConn then _clockConn:Disconnect(); _clockConn = nil end
    end
    local function normType(name)
        if name == "Rain" or name == "BloodMoon" or PRESETS[name] then
            return name
        end
        return "Rain"
    end
    local function applyType(name)
        name = normType(name)
        local prev = _curType
        stopRain(); clearSpecial()
        if #_partLayers > 0 then
            beginLayerFade()
        end
        _curType = name
        if name == "Rain" then
            buildRain(); startRain()
        elseif name == "BloodMoon" then
            buildBloodMoon(); startSpecialAnim()
        else
            local ramp = PRESETS[prev] ~= nil
            local ir = IR[name] or IR_DEF
            for _, spec in PRESETS[name] do
                mkPartLayer(spec, ir, ramp)
            end
        end
        if name == "Fireflies" then startFireflies() else stopFireflies() end
        applyMood(name)
        startAmbient(SOUND[name])
        puddlesRefresh()
    end
    function Weather.setType(name)
        name = normType(name)
        Config.WeatherType = name
        if Config.Weather then applyType(name) end
    end
    local _intensityToken = 0
    function Weather.setIntensity(v)
        Config.WeatherIntensity = math.clamp(v, 0.15, 2)
        if not Config.Weather then return end
        puddlesIntensity()
        local I = Config.WeatherIntensity
        for _, L in _partLayers do
            if L.emitter then
                pcall(tuneLayer, L, I)
                if L.rateTween then L.rateTween:Cancel(); L.rateTween = nil end
                pcall(function() L.emitter.Rate = layerRate(L, I) * L.rateMul end)
            end
        end
        if _special.kind == "BloodMoon" then pcall(tuneBloodMoon, I) end
        if _rays then
            pcall(function()
                _rays.Intensity = 0.10 + 0.18 * I
                _rays.Spread = 1.1 - 0.2 * I
            end)
        end
        _intensityToken = _intensityToken + 1
        local token = _intensityToken
        task.delay(0.12, function()
            if token ~= _intensityToken then return end
            if not Config.Weather then return end
            if _curType == "Rain" then pcall(tuneRain) end
            if _curType then pcall(applyMood, _curType) end
            pcall(refreshFireflies)
        end)
    end
    function Weather.setSoundVolume(v)
        Config.WeatherSoundVolume = v
        if _ambient then pcall(function() _ambient.Volume = v end) end
    end
    function Weather.toggleStorm(on)
        Config.WeatherStorm = on
        if not Config.Weather then return end
        if on then startStorm() else stopStormLoop() end
        puddlesRefresh()
    end
    function Weather.setStormMin(v)
        Config.WeatherStormMin = math.clamp(v, 1, 30)
        rescheduleStorm()
    end
    function Weather.setStormVar(v)
        Config.WeatherStormVar = math.clamp(v, 0, 30)
        rescheduleStorm()
    end
    function Weather.setMeteorRate(v)
        Config.WeatherMeteorRate = math.clamp(v, 0.25, 3)
        rescheduleMeteors()
    end
    function Weather.setStarRate(v)
        Config.WeatherStarRate = math.clamp(v, 0.25, 3)
        rescheduleStars()
    end
    function Weather.togglePuddles(on)
        Config.WeatherPuddles = on
        puddlesRefresh()
    end
    function Weather.toggleMood(on)
        Config.WeatherMood = on
        if Config.Weather and _curType then
            if on then applyMood(_curType) else clearMood() end
        end
    end
    function Weather.toggleMeteors(on)
        Config.WeatherMeteors = on
        if Config.Weather then if on then startMeteors() else stopMeteors() end end
    end
    function Weather.toggleShootingStars(on)
        Config.WeatherShootingStars = on
        if Config.Weather then if on then startStars() else stopStars() end end
    end
    function Weather.toggleClock(on)
        Config.WeatherClockDial = on
        if Config.Weather then if on then startClock() else stopClock() end end
    end
    function Weather.enableWeather()
        Config.Weather = true
        getFolder(); startFollow()
        applyType(cfg("WeatherType", "Rain"))
        if cfg("WeatherStorm", false) then startStorm() end
        if cfg("WeatherMeteors", false) then startMeteors() end
        if cfg("WeatherShootingStars", false) then startStars() end
        if cfg("WeatherClockDial", false) then startClock() end
    end
    function Weather.disableWeather()
        Config.Weather = false
        stopFollow(); stopStorm(); stopRain(); clearPartLayers(); killFade(); clearMood()
        clearSpecial(); stopMeteors(); stopStars(); stopFireflies(); stopLeafDevil(); stopClock()
        stopPuddles(true)
        if _ambient then pcall(function() _ambient:Destroy() end); _ambient = nil end
        _curType = nil
    end
    local SKY = {
        Space     = { Bk="rbxassetid://159454299", Dn="rbxassetid://159454296", Ft="rbxassetid://159454293", Lf="rbxassetid://159454286", Rt="rbxassetid://159454300", Up="rbxassetid://159454288" },
        Sunset    = { Bk="rbxassetid://264908339", Dn="rbxassetid://264907909", Ft="rbxassetid://264909420", Lf="rbxassetid://264909758", Rt="rbxassetid://264908886", Up="rbxassetid://264907379" },
        Clouds    = { Bk="rbxassetid://570557514", Dn="rbxassetid://570557775", Ft="rbxassetid://570557559", Lf="rbxassetid://570557620", Rt="rbxassetid://570557672", Up="rbxassetid://570557727" },
        Storm     = { Bk="rbxassetid://255027929", Dn="rbxassetid://255027967", Ft="rbxassetid://255027923", Lf="rbxassetid://255027938", Rt="rbxassetid://255027946", Up="rbxassetid://255027960" },
        Winter    = { Bk="rbxassetid://402229526", Dn="rbxassetid://402229596", Ft="rbxassetid://402229293", Lf="rbxassetid://402229368", Rt="rbxassetid://402229417", Up="rbxassetid://402229564" },
        Vaporwave = { Bk="rbxassetid://1417494030", Dn="rbxassetid://1417494146", Ft="rbxassetid://1417494253", Lf="rbxassetid://1417494402", Rt="rbxassetid://1417494499", Up="rbxassetid://1417494643" },
    }
    Weather.SkyboxOrder = { "Off", "Space", "Sunset", "Clouds", "Storm", "Winter", "Vaporwave" }
    local _sky, _skyConn = nil, nil
    local _origSkies = {}
    local function hideMapSkies()
        for _, c in ipairs(Lighting:GetChildren()) do
            if c:IsA("Sky") and not c:GetAttribute("WX_Custom") then
                table.insert(_origSkies, c)
                pcall(function() c.Parent = nil end)
            end
        end
    end
    local function restoreMapSkies()
        for i = #_origSkies, 1, -1 do
            local c = _origSkies[i]
            if c and c.Parent == nil then
                pcall(function() c.Parent = Lighting end)
            end
            _origSkies[i] = nil
        end
    end
    local function buildSky(preset)
        local set = SKY[preset]; if not set then return end
        hideMapSkies()
        local s = Instance.new("Sky")
        s.Name = "_wxSky"; s:SetAttribute("WX_Custom", true)
        s.SkyboxBk, s.SkyboxDn, s.SkyboxFt = set.Bk, set.Dn, set.Ft
        s.SkyboxLf, s.SkyboxRt, s.SkyboxUp = set.Lf, set.Rt, set.Up
        if cfg("SkyboxHideCelestial", false) then
            s.SunAngularSize = 0; s.MoonAngularSize = 0; s.StarCount = 0
            s.CelestialBodiesShown = false
        else
            s.CelestialBodiesShown = true
        end
        s.Parent = Lighting
        _sky = s
    end
    local function startSkyGuard()
        if _skyConn then return end
        _skyConn = Lighting.ChildAdded:Connect(function(c)
            if c:IsA("Sky") and not c:GetAttribute("WX_Custom") and Config.SkyboxPreset and Config.SkyboxPreset ~= "Off" then
                table.insert(_origSkies, c)
                pcall(function() c.Parent = nil end)
            end
        end)
    end
    local function stopSkyGuard()
        if _skyConn then _skyConn:Disconnect(); _skyConn = nil end
    end
    local function clearSky()
        if _sky then pcall(function() _sky:Destroy() end); _sky = nil end
        restoreMapSkies()
    end
    function Weather.setSkybox(preset)
        if preset and not SKY[preset] then preset = "Off" end
        Config.SkyboxPreset = preset
        clearSky()
        if preset == "Off" or preset == nil then stopSkyGuard(); return end
        buildSky(preset); startSkyGuard()
    end
    function Weather.toggleCelestial(hide)
        Config.SkyboxHideCelestial = hide
        if _sky then
            if hide then
                _sky.SunAngularSize = 0; _sky.MoonAngularSize = 0; _sky.StarCount = 0
                _sky.CelestialBodiesShown = false
            else
                _sky.SunAngularSize = 11; _sky.MoonAngularSize = 11; _sky.StarCount = 3000
                _sky.CelestialBodiesShown = true
            end
        end
    end
    local _rainbow = { host = nil, conn = nil }
    local RB_BANDS = {
        { Color3.fromRGB(255, 40, 40),  0.10, 24 },
        { Color3.fromRGB(255, 130, 20), 0.12, 24 },
        { Color3.fromRGB(255, 225, 40), 0.14, 24 },
        { Color3.fromRGB(60, 210, 70),  0.16, 24 },
        { Color3.fromRGB(40, 130, 255), 0.18, 24 },
        { Color3.fromRGB(85, 60, 235),  0.26, 18 },
        { Color3.fromRGB(165, 65, 230), 0.30, 16 },
    }
    local RB_DIST, RB_OY = 430, -20
    local function clearRainbow()
        if _rainbow.conn then _rainbow.conn:Disconnect(); _rainbow.conn = nil end
        if _rainbow.host then pcall(function() _rainbow.host:Destroy() end); _rainbow.host = nil end
    end
    local function buildRainbow()
        local host = Instance.new("Part")
        host.Name = "_wxRainbow"; host.Anchored = true; host.CanCollide = false; host.CanQuery = false
        host.CanTouch = false; host.CastShadow = false; host.Massless = true; host.Transparency = 1
        host.Size = Vec(1, 1, 1); host:SetAttribute("WX_Custom", true)
        local rot = CFrame.Angles(0, 0, math.rad(90))
        local function band(sp, rr, w, col, midT, emit, soft)
            local a0 = Instance.new("Attachment"); a0.CFrame = CFrame.new(-sp, 0, 0) * rot; a0.Parent = host
            local a1 = Instance.new("Attachment"); a1.CFrame = CFrame.new( sp, 0, 0) * rot; a1.Parent = host
            local b = Instance.new("Beam")
            b.Attachment0 = a0; b.Attachment1 = a1; b.Segments = 46; b.FaceCamera = true
            if soft then b.Texture = TX_SOFT; b.TextureMode = Enum.TextureMode.Stretch; b.TextureLength = 1 end
            b.Width0 = w; b.Width1 = w; b.CurveSize0 = rr; b.CurveSize1 = -rr
            b.LightEmission = emit; b.LightInfluence = 0
            b.Color = ColorSequence.new(col)
            local edge = math.min(midT + 0.25, 1)
            b.Transparency = NumberSequence.new({
                NSK(0, 1), NSK(0.08, edge), NSK(0.45, midT), NSK(0.55, midT), NSK(0.92, edge), NSK(1, 1) })
            b.Parent = host
        end
        for i = 1, #RB_BANDS do
            local B = RB_BANDS[i]
            band(340, 320 - (i - 1) * 15, B[3], B[1], B[2], 0.42, false)
        end
        band(340, 165, 52, Color3.fromRGB(242, 248, 255), 0.78, 0.6, true)
        for i = 1, #RB_BANDS do
            band(400, 355 + (i - 1) * 12, 20, RB_BANDS[i][1], 0.64 + i * 0.012, 0.42, false)
        end
        host.Parent = getFolder()
        _rainbow.host = host
    end
    local function startRainbowFollow()
        if _rainbow.conn then return end
        local accum = 0
        _rainbow.conn = RunService.Heartbeat:Connect(function(dt)
            if not cfg("WeatherRainbow", false) then return end
            accum = accum + dt; if accum < 0.08 then return end
            accum = 0
            local cam = Camera; if not cam then return end
            local host = _rainbow.host; if not host or not host.Parent then return end
            local p = cam.CFrame.Position
            local hp = Vec(p.X, p.Y + RB_OY, p.Z - RB_DIST)
            host.CFrame = CFrame.lookAt(hp, Vec(p.X, hp.Y, p.Z))
        end)
    end
    function Weather.toggleRainbow(on)
        Config.WeatherRainbow = on
        clearRainbow()
        if not on then return end
        buildRainbow(); startRainbowFollow()
    end
    function Weather.toggleGodRays(on)
        Config.WeatherGodRays = on
        if _rays then pcall(function() _rays:Destroy() end); _rays = nil end
        if not on then return end
        local r = Instance.new("SunRaysEffect")
        r.Name = "_wxRays"; r:SetAttribute("WX_Custom", true)
        local I = iAmt()
        r.Intensity = 0.10 + 0.18 * I
        r.Spread = 1.1 - 0.2 * I
        r.Parent = Lighting
        _rays = r
    end
    function Weather.init()
        if Config.Weather then pcall(Weather.enableWeather) end
        if Config.SkyboxPreset and Config.SkyboxPreset ~= "Off" then pcall(Weather.setSkybox, Config.SkyboxPreset) end
        if Config.WeatherGodRays then pcall(Weather.toggleGodRays, true) end
        if Config.WeatherRainbow then pcall(Weather.toggleRainbow, true) end
    end
    function Weather.unload()
        pcall(Weather.disableWeather)
        stopSkyGuard(); clearSky(); clearRainbow()
        if _rays then pcall(function() _rays:Destroy() end); _rays = nil end
        if _folder then pcall(function() _folder:Destroy() end); _folder = nil end
        _lightFolder = nil
    end
end)()
local HUDPlus = {}
;(function()
    local hasDrawing = screenDraw ~= nil
    local C_TEXT1  = Color3.fromRGB(243, 246, 250)
    local C_TEXT2  = Color3.fromRGB(174, 185, 197)
    local C_GOLD   = Color3.fromRGB(255, 194, 75)
    local C_ENEMY  = Color3.fromRGB(255, 59, 78)
    local C_EDGE   = Color3.fromRGB(155, 232, 255)
    local C_BLACK  = Color3.new(0, 0, 0)
    local PI  = math.pi
    local TAU = PI * 2
    local RAD60 = math.rad(60)
    local _alloc = false
    local _cRail, _cRailCas = nil, nil
    local _cTicks = nil
    local _cCard  = nil
    local _cCaret = nil
    local _cPips  = nil
    local _cPill  = nil
    local _taSeg, _taSegCas = nil, nil
    local _rng = nil
    local _conn = nil
    local _started = false
    local _thrT = 0
    local _pip = {}
    local function nd(kind, props)
        if not hasDrawing then return nil end
        local ok, d = pcall(screenDraw, kind, "fx")
        if not ok or not d then return nil end
        d.Visible = false
        if props then for k, v in pairs(props) do pcall(function() d[k] = v end) end end
        return d
    end
    local function alloc()
        if _alloc then return end
        _alloc = true
        _cRailCas = nd("Line", { Color = C_BLACK, Thickness = 3 })
        _cRail    = nd("Line", { Color = C_TEXT2, Thickness = 1 })
        _cTicks = {}
        for i = 1, 10 do _cTicks[i] = nd("Line", { Thickness = 1 }) end
        _cCard = {}
        for i = 1, 4 do _cCard[i] = nd("Text", { Center = true, Outline = true, Font = 3, Size = 11 }) end
        _cCaret = nd("Triangle")
        _cPips = {}
        for i = 1, 8 do _cPips[i] = nd("Circle", { Filled = true, NumSides = 12 }) end
        _cPill = nd("Text", { Center = true, Outline = true, Font = 3, Size = 11, Color = C_ENEMY })
        _taSegCas = {}
        for i = 1, 9 do _taSegCas[i] = nd("Line", { Color = C_BLACK, Thickness = 4 }) end
        _taSeg = {}
        for i = 1, 9 do _taSeg[i] = nd("Line", { Thickness = 2 }) end
        _rng = nd("Text", { Center = true, Outline = true, Font = 3, Size = 13, Color = C_TEXT1 })
    end
    local function hideCompass()
        if _cRail then _cRail.Visible = false; _cRailCas.Visible = false end
        if _cTicks then for i = 1, #_cTicks do _cTicks[i].Visible = false end end
        if _cCard then for i = 1, 4 do _cCard[i].Visible = false end end
        if _cCaret then _cCaret.Visible = false end
        if _cPips then for i = 1, #_cPips do _cPips[i].Visible = false end end
        if _cPill then _cPill.Visible = false end
    end
    local function hideArc()
        if _taSeg then for i = 1, 9 do _taSeg[i].Visible = false; _taSegCas[i].Visible = false end end
    end
    local function hideRange() if _rng then _rng.Visible = false end end
    local function hideAll()
        hideCompass(); hideArc(); hideRange()
    end
    local CARDINALS = {
        { "N", 0, 0, -1, true  },
        { "E", 1, 0,  0, false },
        { "S", 0, 0,  1, false },
        { "W", -1, 0, 0, false },
    }
    local function wrap(a)
        a = (a + PI) % TAU
        if a < 0 then a = a + TAU end
        return a - PI
    end
    local function drawCompass(vp, camYaw, y)
        local railW = math.floor(math.max(Config.HUDCompassWidth or 380, 120))
        local half = railW * 0.5
        local cxp = math.floor(vp.X * 0.5)
        local lx, rx = cxp - half, cxp + half
        _cRailCas.From = Vector2.new(lx, y); _cRailCas.To = Vector2.new(rx, y)
        _cRailCas.Transparency = 0.5; _cRailCas.Visible = true
        _cRail.From = Vector2.new(lx, y); _cRail.To = Vector2.new(rx, y)
        _cRail.Transparency = 0.85; _cRail.Visible = true
        local base = math.floor(math.deg(camYaw) / 15 + 0.5) * 15
        local shown = 0
        for k = -4, 4 do
            local degA = base + k * 15
            local rel = wrap(math.rad(degA) - camYaw)
            if rel >= -RAD60 and rel <= RAD60 then
                shown = shown + 1
                local L = _cTicks[shown]
                if L then
                    local tx = math.floor(cxp + (rel / RAD60) * half)
                    local tall = (degA % 45 == 0) and 7 or 4
                    L.From = Vector2.new(tx, y - tall); L.To = Vector2.new(tx, y)
                    L.Color = C_TEXT2; L.Transparency = 0.45; L.Visible = true
                end
            end
        end
        for i = shown + 1, #_cTicks do _cTicks[i].Visible = false end
        for i = 1, 4 do
            local c = CARDINALS[i]
            local bearing = math.atan2(c[2], c[4])
            local rel = wrap(bearing - camYaw)
            local T = _cCard[i]
            if T then
                if rel >= -RAD60 and rel <= RAD60 then
                    local tx = math.floor(cxp + (rel / RAD60) * half)
                    T.Position = Vector2.new(tx, y - 22)
                    T.Text = c[1]; T.Color = c[5] and C_GOLD or C_TEXT2
                    T.Transparency = 1; T.Visible = true
                else T.Visible = false end
            end
        end
        if _cCaret then
            local glint = 0.5 + 0.5 * math.sin((tick()) * 1.6 * TAU)
            _cCaret.Filled = true
            _cCaret.PointA = Vector2.new(cxp, y + 7)
            _cCaret.PointB = Vector2.new(cxp - 5, y + 1)
            _cCaret.PointC = Vector2.new(cxp + 5, y + 1)
            _cCaret.Color = C_EDGE
            _cCaret.Transparency = 0.65 + 0.35 * glint
            _cCaret.Visible = true
        end
    end
    local function update()
        if not (Config.HUD and hasDrawing) then hideAll(); return end
        local now = tick()
        if now - _thrT < 0.033 then return end
        _thrT = now
        local cam = Camera; if not cam then return end
        local vp = cam.ViewportSize
        local cx, cy = vp.X * 0.5, vp.Y * 0.5
        local compassOn = Config.HUDCompass
        local arcOn     = Config.HUDThreatArc
        local rangeOn   = Config.HUDRangeReadout
        local myC = lp.Character
        local myR = myC and myC:FindFirstChild("HumanoidRootPart")
        local myPos = myR and myR.Position
        local camPos = cam.CFrame.Position
        local look = cam.CFrame.LookVector
        local camYaw = math.atan2(look.X, look.Z)
        local nearD, nearRel = math.huge, 0
        local pipN, offCount = 0, 0
        if compassOn or arcOn or rangeOn then
            local players = getSafePlayers()
            for i = 1, #players do
                local pl = players[i]
                if pl ~= lp and not isTeammate(pl) and isAlive(pl) then
                    local ch = pl.Character
                    local r = ch and ch:FindFirstChild("HumanoidRootPart")
                    if r then
                        local pos = r.Position
                        local dx, dz = pos.X - camPos.X, pos.Z - camPos.Z
                        local rel = wrap(math.atan2(dx, dz) - camYaw)
                        local d = myPos and (myPos - pos).Magnitude
                            or math.sqrt(dx * dx + dz * dz)
                        if d < nearD then nearD = d; nearRel = rel end
                        if rel < -RAD60 or rel > RAD60 then offCount = offCount + 1 end
                        if compassOn and pipN < 8 then
                            pipN = pipN + 1
                            local e = _pip[pipN]; if not e then e = {}; _pip[pipN] = e end
                            e.rel = rel; e.dist = d
                        end
                    end
                end
            end
        end
        if compassOn then
            local y = 26
            drawCompass(vp, camYaw, y)
            local half = math.max(Config.HUDCompassWidth or 380, 120) * 0.5
            local cxp = math.floor(cx)
            local maxD = math.max(Config.ESPMaxDistance or 1200, 1)
            local drawPips = Config.HUDCompassPips and pipN or 0
            for i = 1, drawPips do
                local e = _pip[i]
                local P = _cPips[i]
                if P then
                    local rel = e.rel
                    local clamped = rel
                    if clamped < -RAD60 then clamped = -RAD60 elseif clamped > RAD60 then clamped = RAD60 end
                    local edge = (rel < -RAD60 or rel > RAD60)
                    local px = math.floor(cxp + (clamped / RAD60) * half)
                    local a = 1 - 0.6 * math.clamp(e.dist / maxD, 0, 1)
                    if edge then a = a * 0.4 end
                    P.Radius = 2; P.Position = Vector2.new(px, 26)
                    P.Color = C_ENEMY; P.Transparency = a; P.Visible = true
                end
            end
            for i = drawPips + 1, #_cPips do _cPips[i].Visible = false end
            if _cPill then
                if offCount > 0 then
                    _cPill.Text = "\226\150\178" .. offCount
                    _cPill.Position = Vector2.new(math.floor(cxp + half + 16), 20)
                    _cPill.Transparency = 1; _cPill.Visible = true
                else _cPill.Visible = false end
            end
        else hideCompass() end
        if arcOn and _taSeg and nearD < math.huge then
            local R = 42
            local width = math.rad(30)
            local step = width / 9
            local th0 = nearRel - width * 0.5
            local dfrac = math.clamp((nearD - 25) / (300 - 25), 0, 1)
            local col = C_GOLD:Lerp(C_TEXT2, dfrac)
            local a = 1 - 0.75 * dfrac
            for j = 1, 9 do
                local t1 = th0 + step * (j - 1)
                local t2 = t1 + step * 0.72
                local p1 = Vector2.new(cx + math.sin(t1) * R, cy - math.cos(t1) * R)
                local p2 = Vector2.new(cx + math.sin(t2) * R, cy - math.cos(t2) * R)
                local cs = _taSegCas[j]
                if cs then cs.From = p1; cs.To = p2; cs.Transparency = a * 0.8; cs.Visible = true end
                local L = _taSeg[j]
                if L then L.From = p1; L.To = p2; L.Color = col; L.Transparency = a; L.Visible = true end
            end
        else hideArc() end
        if rangeOn and _rng then
            if nearD < math.huge then
                _rng.Text = ("%dm"):format(math.floor(nearD + 0.5))
                _rng.Position = Vector2.new(math.floor(cx), math.floor(cy + 64))
                _rng.Transparency = 1; _rng.Visible = true
            else _rng.Visible = false end
        else hideRange() end
    end
    function HUDPlus.start()
        if _started then return end
        _started = true
        alloc()
        if not _conn then
            _conn = RunService.RenderStepped:Connect(function() if _started then pcall(update) end end)
        end
    end
    function HUDPlus.stop()
        if not _started then return end
        _started = false
        if _conn then _conn:Disconnect(); _conn = nil end
        hideAll()
    end
    function HUDPlus.init()
        if Config.HUD then pcall(HUDPlus.start) end
    end
    function HUDPlus.unload()
        pcall(HUDPlus.stop)
    end
end)()
local Rage = {}
;(function()
    local _tgtConn  = nil
    local _labConn  = nil
    local function bump(p) State.RageCharTokens[p] = (State.RageCharTokens[p] or 0) + 1 end
    local function killFloor()
        return workspace.FallenPartsDestroyHeight + Config.RageKillPlaneBuffer
    end
    local function hasLOS(fromPos, toPos, ignore)
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = ignore
        local res = workspace:Raycast(fromPos, toPos - fromPos, rp)
        if not res then return true end
        return (res.Position - toPos).Magnitude < 3
    end
    local function lookCF(fromPos, toPos)
        local dir = toPos - fromPos
        if dir.Magnitude < 1e-4 then dir = Vector3.new(0, -1, 0) end
        local up = Vector3.new(0, 1, 0)
        if math.abs(dir.Unit.Y) > 0.999 then up = Vector3.new(0, 0, 1) end
        return CFrame.lookAt(fromPos, fromPos + dir, up)
    end
    Rage._lookCF = lookCF
    local function buildShotFields(camData, eyeCF, muzzleCF, hitPart, aimWorldPos, jitter, clampFrac, jitterFrac)
        local objSpace = hitPart.CFrame:PointToObjectSpace(aimWorldPos)
        local hs = hitPart.Size * (clampFrac or 0.45)
        objSpace = Vector3.new(
            math.clamp(objSpace.X, -hs.X, hs.X),
            math.clamp(objSpace.Y, -hs.Y, hs.Y),
            math.clamp(objSpace.Z, -hs.Z, hs.Z)
        )
        if jitter then
            local jf = jitterFrac or 1.0
            objSpace = Vector3.new(
                math.clamp(objSpace.X + (math.random() - 0.5) * hs.X * jf, -hs.X, hs.X),
                math.clamp(objSpace.Y + (math.random() - 0.5) * hs.Y * jf, -hs.Y, hs.Y),
                math.clamp(objSpace.Z + (math.random() - 0.5) * hs.Z * jf, -hs.Z, hs.Z)
            )
        end
        local hitWorld   = hitPart.CFrame:PointToWorldSpace(objSpace)
        local objSpaceCF = hitPart.CFrame:ToObjectSpace(CFrame.new(hitWorld))
        camData[utf8.char(0)] = Rivals.Util:EncodeCFrame(eyeCF)
        camData[utf8.char(1)] = Rivals.Util:EncodeCFrame(muzzleCF)
        camData[utf8.char(2)] = hitPart
        camData[utf8.char(3)] = Rivals.Util:EncodeCFrame(objSpaceCF)
    end
    Rage._buildShotFields = buildShotFields
    local RAGE_CLAMP_FRAC  = 0.30
    local RAGE_JITTER_FRAC = 1.0
    local function encodeShot(camData, hitPart, targetChar, fromCamPos, claimOffset)
        if not hitPart or not camData or not Rivals.Util then return false end
        local lead      = calculateLead(targetChar, fromCamPos)
        local off       = (typeof(claimOffset) == "Vector3") and claimOffset or Vector3.zero
        local leadedPos = hitPart.Position + lead + off
        local eyeCF     = lookCF(fromCamPos, leadedPos)
        local muzzlePos = fromCamPos + (eyeCF.RightVector * 0.2) + Vector3.new(0, -Config.RageEyeMuzzleSep, 0)
        local muzzleCF  = lookCF(muzzlePos, leadedPos)
        buildShotFields(camData, eyeCF, muzzleCF, hitPart, leadedPos, Config.SilentAimJitter, 0.45, 1.0)
        return true
    end
    Rage._encodeShot = encodeShot
    local PICK_SLOT = { Primary = 1, Secondary = 2, Melee = 3 }
    ;(function()
        local function fighterItems()
            local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
            return lf and lf.Items or nil
        end
        local function itemIsMelee(item)
            if not item then return false end
            local viaInfo = false
            pcall(function()
                local info = item.Info
                if info == nil then return end
                if info.Type == "Melee" or info.Class == "Melee" then viaInfo = true return end
                if type(info.AttackReach) == "number" and info.MaxAmmo == nil then viaInfo = true end
            end)
            if viaInfo then return true end
            local okN, nm = pcall(function() return item:Get("Name") or item.Name end)
            if okN and type(nm) == "string" and nm:lower():find("melee", 1, true) then return true end
            return false
        end
        Rage._itemIsMelee = itemIsMelee
        local function itemAmmo(item)
            if not item then return nil end
            local ok, a = pcall(function() return item:Get("Ammo") or item:Get("CurrentAmmo") end)
            if ok and type(a) == "number" then return a end
            return nil
        end
        local function slotItemByIndex(idx)
            local items = fighterItems(); if not items then return nil end
            if items[idx] then return items[idx] end
            if items[tostring(idx)] then return items[tostring(idx)] end
            for key, it in pairs(items) do
                if it and typeof(it) == "table" then
                    local okS, s = pcall(function() return tonumber(it:Get("Slot") or it:Get("Index") or it:Get("ItemSlot") or key) end)
                    if okS and s == idx then return it end
                    local okT, t = pcall(function() return it:Get("ItemType") or it:Get("Type") end)
                    if okT then
                        if idx == 1 and (t == "Primary" or t == 1 or t == "1") then return it end
                        if idx == 2 and (t == "Secondary" or t == 2 or t == "2") then return it end
                        if idx == 3 and (t == "Melee" or (type(t) == "string" and t:lower():find("melee", 1, true))) then return it end
                    end
                end
            end
            return nil
        end
        local function whichSlotNow()
            local cur = getEquippedItem(); if not cur then return nil end
            local okId, oid = pcall(function() return cur:Get("ObjectID") end)
            if okId and oid then
                for idx = 1, 3 do
                    local it = slotItemByIndex(idx)
                    if it then
                        local okI, iid = pcall(function() return it:Get("ObjectID") end)
                        if okI and iid == oid then return idx end
                    end
                end
            end
            if itemIsMelee(cur) then return 3 end
            return nil
        end
        local function slotUsable(idx)
            local it = slotItemByIndex(idx); if not it then return false end
            if itemIsMelee(it) then return Config.RageSwitchMelee == true end
            local a = itemAmmo(it)
            return a == nil or a > 0
        end
        local function slotOrder()
            local pref = PICK_SLOT[Config.RageWeaponPick] or 1
            local order = { pref }
            for _, s in ipairs({ 1, 2, 3 }) do
                if s ~= pref then order[#order + 1] = s end
            end
            if not Config.RageSwitchMelee then
                local filtered = {}
                for _, s in ipairs(order) do if s ~= 3 then filtered[#filtered + 1] = s end end
                order = filtered
            end
            return order
        end
        local function nextUsableSlot(excludeIdx)
            for _, s in ipairs(slotOrder()) do
                if s ~= excludeIdx and slotUsable(s) then return s end
            end
            return nil
        end
        local function equipSlot(idx)
            if not idx then return false end
            if whichSlotNow() == idx then return true end
            local now = tick()
            if now - (State.RageSwitchLast or 0) < (Config.RageSwitchRateLimit or 0.06) then return false end
            State.RageSwitchLast = now
            local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
            local equipped = false
            if lf and lf.EquipItem then
                equipped = pcall(function() lf:EquipItem(idx) end)
            end
            if not equipped then
                pcall(function()
                    local kc = ({ Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three })[idx]
                    if kc then
                        VirtualInputMgr:SendKeyEvent(true, kc, false, game)
                        VirtualInputMgr:SendKeyEvent(false, kc, false, game)
                    end
                end)
            end
            return true
        end
        Rage._equipSlot = equipSlot
        Rage._nextUsableSlot = nextUsableSlot
        Rage._whichSlotNow = whichSlotNow
    end)()
    local function encodeRageShot(camData)
        if tick() - (State.RageFireStamp or 0) > 0.03 then return false end
        local hitPart = State.RageFireHitPart
        local eyePos  = State.RageFireFromPos
        local aimPos  = State.RageFireAimPos
        if not (hitPart and hitPart.Parent and eyePos and aimPos) then return false end
        if not isSanePos(eyePos) or not isSanePos(hitPart.Position) then return false end
        if (hitPart.Position - eyePos).Magnitude > (400 - 5) then return false end
        local ignore = { lp.Character }
        local t = State.RageTarget or State.Target
        if t and t.Character then ignore[2] = t.Character end
        if not hasLOS(eyePos, hitPart.Position, ignore) then return false end
        local item = getEquippedItem(); if not item then return false end
        local okE, equipping = pcall(function() return item:IsEquipping() end)
        if okE and equipping then return false end
        if not (Rage._itemIsMelee and Rage._itemIsMelee(item)) then
            local okR, reloading = pcall(function() return (item._reload_cooldown or 0) > tick() end)
            if okR and reloading then return false end
            local okA, ammo = pcall(function() return item:Get("Ammo") end)
            if not okA or type(ammo) ~= "number" or ammo <= 0 then return false end
        end
        local now = tick()
        local interval = 0
        if Rage._fireInterval then interval = Rage._fireInterval() end
        if now - (State.RageLastFireTime or 0) < interval then return false end
        State.RageLastFireTime = now
        local eyeCF    = lookCF(eyePos, aimPos)
        local muzzleCF = eyeCF - Vector3.new(0, Config.RageEyeMuzzleSep, 0)
        buildShotFields(camData, eyeCF, muzzleCF, hitPart, aimPos, true, RAGE_CLAMP_FRAC, RAGE_JITTER_FRAC)
        State.Shots = State.Shots + 1
        return true
    end
    local function findTarget()
        local myChar = lp.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local cands  = {}
        for _, p in ipairs(getSafePlayers()) do
            if isValidTarget(p, Config.RageVisCheck, true, true) then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local d = 9999
                local sane = myRoot ~= nil and hrp ~= nil and isSanePos(hrp.Position)
                if sane then d = (hrp.Position - myRoot.Position).Magnitude end
                if (not sane) or d <= (Config.MaxDistance or 1200) then
                    table.insert(cands, { p = p, hp = hum.Health, d = d })
                end
            end
        end
        if #cands == 0 then return nil end
        if Config.RageHPPriority then
            table.sort(cands, function(a, b)
                if math.abs(a.hp - b.hp) > 10 then return a.hp < b.hp end
                return a.d < b.d
            end)
        else
            table.sort(cands, function(a, b) return a.d < b.d end)
        end
        return cands[1].p
    end
    Rage._findTarget = findTarget
    local function findTargetHeadSane()
        local myChar = lp.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local cands  = {}
        for _, p in ipairs(getSafePlayers()) do
            if isValidTarget(p, Config.RageVisCheck, true, true) then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hh  = p.Character:FindFirstChild("HitboxHead") or p.Character:FindFirstChild("Head")
                local headSane = false
                if hh and isSanePos(hh.Position) then headSane = true end
                local d = 9999
                if myRoot and hrp and isSanePos(hrp.Position) then d = (hrp.Position - myRoot.Position).Magnitude end
                table.insert(cands, { p = p, hp = hum.Health, d = d, s = headSane })
            end
        end
        if #cands == 0 then return nil end
        table.sort(cands, function(a, b)
            if a.s ~= b.s then return a.s end
            if Config.RageHPPriority and math.abs(a.hp - b.hp) > 10 then return a.hp < b.hp end
            return a.d < b.d
        end)
        return cands[1].p
    end
    Rage._findTargetHeadSane = findTargetHeadSane
    local _meleeLogAt = 0
    local function meleeReadout()
        if Config.RageMeleeLog == false then return end
        local now = tick()
        if now - _meleeLogAt < 1 then return end
        local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
        local item = lf and lf.EquippedItem
        if not item then return end
        if not (Rage._itemIsMelee and Rage._itemIsMelee(item)) then return end
        _meleeLogAt = now
        local mode = Config.RageMode or "Polar"
        if mode ~= "Polar" then
            print("[LuaHook] melee: the knife bot is POLAR-ONLY and rage mode is " .. mode
                .. " — no melee code runs at all in this mode. Switch Rage > Mode to Polar.")
            return
        end
        local why = State.RageKnifeStatus
        if why == nil then
            why = "NEVER REACHED (rage=" .. tostring(State.RageStatus) .. ")"
        end
        print("[LuaHook] melee=" .. tostring(why)
            .. " swings=" .. tostring(State.RageKnifeSwings or 0)
            .. " rage=" .. tostring(State.RageStatus)
            .. " target=" .. tostring(State.RageTarget and State.RageTarget.Name or "none"))
    end
    local function startTargetLoop()
        if _tgtConn then _tgtConn:Disconnect() end
        local lastPosMap, lastTimeMap = {}, {}
        _tgtConn = RunService.Heartbeat:Connect(function()
            if not Config.Rage then return end
            pcall(meleeReadout)
            local nowTime = tick()
            local safe = getSafePlayers() or {}
            for i = 1, #safe do
                local p = safe[i]
                if p ~= lp and p.Character then
                    local pRoot = p.Character:FindFirstChild("HumanoidRootPart")
                    if pRoot then
                        local currentPos = pRoot.Position
                        if lastPosMap[p] and lastTimeMap[p] then
                            local dt = nowTime - lastTimeMap[p]
                            if dt > 0 then State.RageTrueVelocityMap[p] = (currentPos - lastPosMap[p]) / dt end
                        end
                        lastPosMap[p] = currentPos
                        lastTimeMap[p] = nowTime
                    end
                end
            end
            if Config.RageFastTargetSwitch and State.Target and not isValidTarget(State.Target, false, true, true) then
                State.Target = nil
            end
            State.Target = findTarget()
        end)
    end
    Rage._startTargetLoop = startTargetLoop
    local function startLabPoll()
        if _labConn then return end
        local lastHP = {}
        _labConn = RunService.Heartbeat:Connect(function()
            if not Config.RageLab then return end
            local safe = getSafePlayers() or {}
            for i = 1, #safe do
                local p = safe[i]
                if p ~= lp then
                    local c = p.Character
                    local hum = c and c:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local h, last = hum.Health, lastHP[p]
                        if last and h < last - 0.5 then
                            State.RageDealtTotal = (State.RageDealtTotal or 0) + (last - h)
                            if p == State.Target then State.Hits = State.Hits + 1 end
                        end
                        lastHP[p] = h
                    else
                        lastHP[p] = nil
                    end
                end
            end
        end)
    end
    Rage._startLabPoll = startLabPoll
    Rage._isCheater = function() return false end
    function Rage.init()
        for _, p in ipairs(getSafePlayers()) do bump(p) end
        Players.PlayerAdded:Connect(function(p)
            bump(p)
            p.CharacterAdded:Connect(function() bump(p) end)
        end)
        for _, p in ipairs(getSafePlayers()) do
            p.CharacterAdded:Connect(function() bump(p) end)
        end
        Players.PlayerRemoving:Connect(function(p)
            State.RageCharTokens[p] = nil
        end)
        lp.CharacterAdded:Connect(function()
            bump(lp)
            State.RageRealCF = nil; State.RageRealChar = nil
            State.RageParkDirty = false
            State.RageTarget = nil
        end)
        bump(lp)
        startLabPoll()
    end
    local _rageConn, _rageCharConn = nil, nil
    local _rageStepConn = nil
    local _rageRestoreName = "__lh_rage_restore"
    local _rageDiedConn = nil
    local _rageCooldownConn = nil
    local function fireInterval()
        return Config.RageFireRateOverride or 0
    end
    Rage._fireInterval = fireInterval
    local _preParkCF = nil
    local _identGet, _identSet, _identTried = nil, nil, false
    local function rawSetCFrame(hrp, cf)
        State.CapabilitySeam = "07b park write (hrp.CFrame)"
        if not _identTried then
            _identTried = true
            pcall(function()
                local g = getthreadidentity or get_thread_identity
                local s = setthreadidentity or set_thread_identity or setidentity or setthreadcontext
                if type(g) == "function" and type(s) == "function" then _identGet, _identSet = g, s end
            end)
        end
        if _identSet ~= nil and identityIsSafe() then
            local wrote = false
            task.spawn(function()
                local okPrev, prev = pcall(_identGet)
                if not okPrev then return end
                if not pcall(_identSet, 8) then return end
                wrote = pcall(function() hrp.CFrame = cf end)
                pcall(_identSet, prev)
            end)
            if wrote then return true end
        end
        return pcall(function() hrp.CFrame = cf end)
    end
    local function displace(hrp, cf)
        if _preParkCF == nil then _preParkCF = hrp.CFrame end
        return rawSetCFrame(hrp, cf)
    end
    Rage._displace = displace
    local ORBIT_PRIME_S   = 0.07
    local ORBIT_JITTER_MAX = 0.25
    local ORBIT_JUMP      = 5
    local _orbHiding      = true
    local _orbPrimeUntil  = 0
    local ORB_IMMUNE_MAX_HOLD = 6.0
    local _orbImmuneSince, _orbImmuneTgt = 0, nil
    local _orbLastDisp    = nil
    local function voidAxis()
        local v = math.random(110000, 140000)
        if math.random(0, 1) == 0 then
            return -v
        end
        return v
    end
    local function rollVoid()
        return CFrame.new(voidAxis(), math.random(110000, 140000), voidAxis())
    end
    local function stepClears(cf, prev, minStep)
        if not prev then return true end
        return (cf.Position - prev.Position).Magnitude >= minStep
    end
    local function voidCFrame()
        local now = tick()
        if not Config.RageVoidMove then
            if (not State.RageVoidCF) or now >= (State.RageVoidNext or 0) then
                State.RageVoidCF   = rollVoid()
                State.RageVoidNext = now + 4 + math.random() * 4
            end
            return State.RageVoidCF
        end
        local prev = State.RageVoidCF
        local cf
        if Config.RageVoidJitterLocal then
            if (not State.RageVoidBase) or now >= (State.RageVoidNext or 0) then
                State.RageVoidBase = rollVoid()
                State.RageVoidNext = now + 4 + math.random() * 4
            end
            local base = State.RageVoidBase.Position
            local span = Config.RageVoidJitterStuds or 2000
            local function offset()
                local v = 500 + math.random() * (span - 500)
                if math.random(0, 1) == 0 then
                    return -v
                end
                return v
            end
            local tries = 0
            repeat
                cf = CFrame.new(base.X + offset(), math.max(base.Y + offset(), 110000), base.Z + offset())
                tries = tries + 1
            until tries >= 8 or stepClears(cf, prev, 600)
        else
            local minStep = Config.RageVoidMinStep or 25000
            local tries = 0
            repeat
                cf = rollVoid()
                tries = tries + 1
            until tries >= 8 or stepClears(cf, prev, minStep)
        end
        State.RageVoidCF    = cf
        State.RageVoidSteps = (State.RageVoidSteps or 0) + 1
        return cf
    end
    local function weaponReady(it)
        if not it then return false end
        local okE, equipping = pcall(function() return it:IsEquipping() end)
        if okE and equipping then return false end
        if (it._reload_cooldown or 0) > tick() then return false end
        if Rage._itemIsMelee and Rage._itemIsMelee(it) then return true end
        local okA, ammo = pcall(function() return it:Get("Ammo") end)
        if not okA then
            State.RageAmmoUnreadable = (State.RageAmmoUnreadable or 0) + 1
            return true
        end
        return type(ammo) == "number" and ammo > 0
    end
    Rage._ensureReload = function(it)
        if it == nil then return "no item" end
        local okR, reloading = pcall(function() return (it._reload_cooldown or 0) > tick() end)
        if okR and reloading then return "waiting" end
        local okA, ammo = pcall(function() return it:Get("Ammo") end)
        if okA and type(ammo) == "number" and ammo > 0 then return "loaded" end
        local okRes, reserve = pcall(function() return it:Get("AmmoReserve") end)
        if okRes and type(reserve) == "number" and reserve <= 0 then
            local okInf, inf = pcall(function()
                return it.ClientFighter ~= nil and it.ClientFighter:Get("InfiniteAmmoReserve") == true
            end)
            if not okInf or inf ~= true then return "dry" end
        end
        if tick() - (State.RageReloadLast or 0) < 0.5 then return "throttled" end
        State.RageReloadLast = tick()
        pcall(function()
            local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
            if lf == nil then return end
            task.spawn(function()
                if pcall(function() lf:Input("StartReloading") end) then return end
                if not identityIsSafe() then return end
                local g = getthreadidentity or get_thread_identity
                local s = setthreadidentity or set_thread_identity or setidentity
                if type(s) ~= "function" then return end
                local prev
                if type(g) == "function" then local okP, p = pcall(g); if okP then prev = p end end
                pcall(s, 2)
                pcall(function() lf:Input("StartReloading") end)
                pcall(s, prev or 2)
            end)
        end)
        pcall(function() it:StartReloading() end)
        return "requested"
    end
    local function equipAtId2(lf, slot)
        if not identityIsSafe() then return end
        local g = getthreadidentity or get_thread_identity
        local s = setthreadidentity or set_thread_identity or setidentity
        if type(s) ~= "function" then return end
        task.spawn(function()
            local prev
            if type(g) == "function" then local okP, p = pcall(g); if okP then prev = p end end
            pcall(s, 2)
            pcall(function() lf.EquipItem(lf, slot) end)
            pcall(s, prev or 2)
        end)
    end
    local _SLOT_INDEX = { Primary = 1, Secondary = 2, Melee = 3 }
    Rage._weaponRecovery = function(it)
        if Rage._itemIsMelee and Rage._itemIsMelee(it) then return "loaded" end
        local mode = Config.RageOnEmpty or "Reload"
        local okA, ammo = pcall(function() return it and it:Get("Ammo") end)
        local empty = not (okA and type(ammo) == "number" and ammo > 0)
        if mode ~= "Swap" or not empty then
            return Rage._ensureReload(it)
        end
        local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
        local items = lf and lf.Items
        if type(items) ~= "table" then return Rage._ensureReload(it) end
        if tick() - (State.RageSwitchLast or 0) < 0.5 then return "swap-wait" end
        local pref = _SLOT_INDEX[Config.RagePreferredSlot or "Primary"] or 1
        local other = pref == 1 and 2 or 1
        for _, slot in ipairs({ pref, other }) do
            local w = items[slot]
            if w and w ~= it then
                local okW, wammo = pcall(function() return w:Get("Ammo") end)
                if okW and type(wammo) == "number" and wammo > 0 then
                    local busy = false
                    pcall(function()
                        if w:IsEquipping() then busy = true end
                    end)
                    pcall(function()
                        if (w._reload_cooldown or 0) > tick() then busy = true end
                    end)
                    if not busy then
                        State.RageSwitchLast = tick()
                        local okE = pcall(function() lf.EquipItem(lf, slot) end)
                        if okE then
                            State.AutoWeaponFails = 0
                            return "swap"
                        end
                        State.AutoWeaponFails = (State.AutoWeaponFails or 0) + 1
                        equipAtId2(lf, slot)
                    end
                end
            end
        end
        return Rage._ensureReload(it)
    end
    Rage._ensureSlot = function(it, wantIdx)
        local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
        if not lf then return "no item" end
        local cur
        pcall(function() cur = it and it.Data and it.Data.ItemIndex end)
        if not cur then pcall(function() cur = it and it.ItemIndex end) end
        if not cur and it and type(lf.Items) == "table" then
            for i = 1, 4 do
                if lf.Items[i] == it then cur = i break end
            end
        end
        if cur == wantIdx then return "loaded" end
        if tick() - (State.RageSwitchLast or 0) < 0.5 then return "swap-wait" end
        local busy = false
        pcall(function()
            if it and it.IsEquipping and it:IsEquipping() then busy = true end
        end)
        if busy then return "swap-wait" end
        State.RageSwitchLast = tick()
        local okE = pcall(function() lf.EquipItem(lf, wantIdx) end)
        if okE then
            State.AutoWeaponFails = 0
            return "swap"
        end
        State.AutoWeaponFails = (State.AutoWeaponFails or 0) + 1
        return "swap"
    end
    local _transportWatchStarted = false
    Rage._startTransportWatcher = function()
        if _transportWatchStarted then return end
        _transportWatchStarted = true
        task.spawn(function()
            local EF
            for _ = 1, 60 do
                local ps = lp and lp:FindFirstChildOfClass("PlayerScripts")
                if ps then
                    local ok, m = pcall(require, ps:WaitForChild("Modules", 5)
                        :WaitForChild("ClientReplicatedClasses", 5)
                        :WaitForChild("ClientDuel", 5)
                        :WaitForChild("DuelInterface", 5)
                        :WaitForChild("EliminationFeed", 5))
                    if ok and type(m) == "table" and type(m.Play) == "function" then EF = m break end
                end
                task.wait(1)
            end
            if not EF then return end
            local orig = EF.Play
            shared._LH_ElimFeedOrig = shared._LH_ElimFeedOrig or orig
            EF.Play = function(self, victim, eliminator, ...)
                local results = { pcall(orig, self, victim, eliminator, ...) }
                if not results[1] then return unpack(results, 2) end
                pcall(function()
                    if victim ~= lp then return end
                    if Config.RageRestoreMode ~= "auto" then return end
                    if eliminator == nil or typeof(eliminator) ~= "Instance" then return end
                    local tgt = State.RageTarget
                    local match = (tgt == eliminator)
                    if not match and tgt and eliminator.Name == tgt.Name then match = true end
                    if not match then return end
                    local now = tick()
                    if now - (State.RageLastLossAt or 0) < 3 then return end
                    State.RageLastLossAt = now
                    State.RageTransportSwitches = (State.RageTransportSwitches or 0) + 1
                    State.RageAutoTransport = (State.RageAutoTransport == "render") and "kicia" or "render"
                    local lib = _G["\76\72"]
                    if lib and lib.Notify then
                        pcall(function()
                            lib:Notify({
                                Title = "Park (Auto)",
                                Description = "Switched to " .. (State.RageAutoTransport == "render" and "render" or "kerp"),
                                Time = 4,
                            })
                        end)
                    end
                end)
                return unpack(results, 2)
            end
        end)
    end
    local _awLast = 0
    Rage.autoWeaponStep = function()
        if not Config.AutoWeaponEnabled then return end
        if Config.Rage then return end
        if (State.AutoWeaponFails or 0) >= 3 then return end
        if tick() - _awLast < 1 then return end
        _awLast = tick()
        local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
        local items = lf and lf.Items
        if type(items) ~= "table" then return end
        local function itemName(w)
            local n
            pcall(function() n = w.Name end)
            if type(n) ~= "string" then pcall(function() n = w.Info and w.Info.Name end) end
            return n
        end
        local want = {
            [1] = Config.AutoWeaponPrimary or "",
            [2] = Config.AutoWeaponSecondary or "",
            [3] = Config.AutoWeaponMelee or "",
            [4] = Config.AutoWeaponUtility or "",
        }
        for slot = 1, 4 do
            local name = want[slot]
            if name ~= "" then
                if itemName(items[slot]) ~= name then
                    for src = 1, 4 do
                        if itemName(items[src]) == name then
                            State.RageSwitchLast = tick()
                            local okE = pcall(function() lf.EquipItem(lf, src) end)
                            if okE then
                                State.AutoWeaponFails = 0
                            else
                                State.AutoWeaponFails = (State.AutoWeaponFails or 0) + 1
                                State.RageSwitchLast = 0
                            end
                            return
                        end
                    end
                    return
                end
            end
        end
        State.AutoWeaponFails = 0
    end
    local function flankPoint(tgt, hh)
        if not tgt or not tgt.Character or not hh or not isSanePos(hh.Position) then return nil end
        local katana = Config.AvoidDeflect and isKatana(tgt)
        local shield = Config.RageShieldBackstab and isRiotShield(tgt)
        local stowed = Config.RageShieldBackstab and ownsRiotShield(tgt)
        if not (katana or shield or stowed) then return nil end
        local thrp = tgt.Character:FindFirstChild("HumanoidRootPart")
        if not thrp then return nil end
        local look = thrp.CFrame.LookVector
        look = Vector3.new(look.X, 0, look.Z)
        if look.Magnitude < 1e-3 then return nil end
        local inv    = -look.Unit
        if not katana and not shield and stowed then inv = look.Unit end
        local anchor = hh.Position
        local kf     = killFloor()
        local dist   = shield and 2.5 or 3.0
        local ignore = { tgt.Character, lp.Character }
        local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = ignore
        local flank = anchor + inv * dist
        local wr = workspace:Raycast(anchor, inv * dist, rp)
        if wr then flank = wr.Position - inv * 0.5 end
        flank = Vector3.new(flank.X, math.max(flank.Y, kf + 3), flank.Z)
        if not hasLOS(flank, hh.Position, ignore) then return nil end
        return flank
    end
    local _shootEnum
    local function polarFire(eyePos, aimPos, hh)
        local reach = 1e9
        if hh and hh.Parent then reach = (hh.Position - eyePos).Magnitude end
        if not (reach <= 395) then
            State.RageBlankCanary = State.RageBlankCanary + 1
            return
        end
        local it = getEquippedItem()
        if not it then return end
        if Config.RageDirectFire then
            if Config.RageRateLimit then
                if tick() - (State.RageLastFireTime or 0) < fireInterval() then return end
                State.RageLastFireTime = tick()
            end
            pcall(function()
                it._shoot_cooldown = 0
                it._shoot_cooldown_no_ammo = 0
                it._last_shot = tick() - 1
            end)
            if not (Rivals.Ready and Rivals.Enums and Rivals.Util) then return end
            if _shootEnum == nil then
                pcall(function() _shootEnum = Rivals.Enums:ToEnum("StartShooting") end)
            end
            if _shootEnum == nil then return end
            local okId, objId = pcall(function() return it:Get("ObjectID") end)
            if not okId or not objId then return end
            local eyeCF    = Rage._lookCF(eyePos, aimPos)
            local muzzleCF = eyeCF - Vector3.new(0, Config.RageEyeMuzzleSep, 0)
            local taps = Config.RageTapsPerFrame
            if type(taps) ~= "number" then taps = 1 end
            taps = math.max(1, math.min(math.floor(taps), math.floor(Config.RageTaps or 6)))
            local sent     = 0
            local rayCast  = false
            pcall(function() rayCast = it.Info.IsRaycast == true end)
            State.RageForging = true
            pcall(function()
                local remote = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
                for _ = 1, taps do
                    if not (hh and hh.Parent) then break end
                    local inner = {}
                    Rage._buildShotFields(inner, eyeCF, muzzleCF, hh, aimPos, true, 0.30, 1.0)
                    local env = { [utf8.char(1)] = inner }
                    if rayCast then env[utf8.char(2)] = true end
                    remote:FireServer(objId, _shootEnum, env, nil)
                    sent = sent + 1
                end
            end)
            State.RageForging = false
            State.Shots = State.Shots + sent
            return
        end
        if not weaponReady(it) then return end
        if not hh or not hh.Parent or not isSanePos(hh.Position) then return end
        local hpos = hh.Position
        if (hpos - eyePos).Magnitude > (400 - 5) then return end
        local ignore = { lp.Character }
        local tgt = State.RageTarget or State.Target
        if tgt and tgt.Character then ignore[2] = tgt.Character end
        if not hasLOS(eyePos, hpos, ignore) then return end
        if tick() - (State.RageLastFireTime or 0) < fireInterval() then return end
        State.RageFireFromPos = eyePos
        State.RageFireAimPos  = aimPos
        State.RageFireHitPart = hh
        State.RageFireStamp   = tick()
        local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
        if not lf then return end
        task.spawn(function()
            if pcall(function() lf:Input("StartShooting") end) then return end
            if not identityIsSafe() then return end
            local g = getthreadidentity or get_thread_identity
            local s = setthreadidentity or set_thread_identity or setidentity
            if type(s) ~= "function" then return end
            local prev
            if type(g) == "function" then local okP, p = pcall(g); if okP then prev = p end end
            pcall(s, 2)
            pcall(function() lf:Input("StartShooting") end)
            pcall(s, prev or 2)
        end)
    end
    local function clearFireSolution()
        State.RageFireFromPos = nil
        State.RageFireAimPos  = nil
        State.RageFireHitPart = nil
        State.RageFireStamp   = 0
    end
    ;(function()
        local function orbitVantage(aimPos, ignore, kf, knife)
            State.OrbitAngle = ((State.OrbitAngle or 0) + 2.39996) % (math.pi * 2)
            local base = Config.RageCombatOrbitRadius or 60
            local radii
            if knife then
                radii = { math.max(base, 75), 95 }
            else
                radii = { base, base * 0.6, math.min(base * 1.5, 380) }
            end
            for _, r in ipairs(radii) do
                for i = 0, 5 do
                    local ang    = State.OrbitAngle + i * (math.pi / 3)
                    local jitter = 0
                    if Config.RageCombatOrbitJitter then jitter = (math.random() - 0.5) * 14 end
                    local h = (Config.RageCombatOrbitHeight or 8) + jitter
                    local pos = Vector3.new(aimPos.X + math.cos(ang) * r,
                        math.max(aimPos.Y + h, kf + 6),
                        aimPos.Z + math.sin(ang) * r)
                    if isSanePos(pos) and not posIsOOB(pos) and hasLOS(pos, aimPos, ignore) then
                        return pos
                    end
                end
            end
            return nil
        end
        local function orbitVoid(hrp, status)
            State.RageStatus = status
            State.OrbitVantage = nil
            State.OrbitVantageUntil = 0
            State.RageFiring = false
            State.RageVoidActive = true
            clearFireSolution()
            _orbHiding = true
            _orbPrimeUntil = 0
            _orbLastDisp = nil
            Rage._displace(hrp, voidCFrame())
        end
        local _orbDeflectSince = 0
        local function orbitTick(ch, hrp, tgt)
            local kf = killFloor()
            if not tgt or not tgt.Character then
                return orbitVoid(hrp, "No target")
            end
            local tc   = tgt.Character
            local thrp = tc:FindFirstChild("HumanoidRootPart")
            local hh   = tc:FindFirstChild("HitboxHead") or tc:FindFirstChild("Head")
            if not hh or not isSanePos(hh.Position) then
                return orbitVoid(hrp, "Hiding")
            end
            if Config.AvoidDeflect and isDeflecting(tgt) then
                if _orbDeflectSince == 0 then _orbDeflectSince = tick() end
                if tick() - _orbDeflectSince < 1.5 then
                    return orbitVoid(hrp, "Deflecting")
                end
            else
                _orbDeflectSince = 0
            end
            if not weaponReady(getEquippedItem()) then
                local act = Rage._weaponRecovery(getEquippedItem())
                if act == "dry" then
                    return orbitVoid(hrp, "Dry")
                end
                if act == "swap" or act == "swap-wait" then
                    return orbitVoid(hrp, "Swapping")
                end
                return orbitVoid(hrp, "Reloading")
            end
            local aimPos = hh.Position
            if posIsOOB(aimPos) or aimPos.Y < kf + 1 then
                return orbitVoid(hrp, "Hiding")
            end
            local ignore = { tc, lp.Character }
            local vantage, status = nil, nil
            local flank = flankPoint(tgt, hh)
            if not flank and thrp and Config.RageKnifeBackstab and isLocalKnife() then
                local inv = -thrp.CFrame.LookVector
                local rp = RaycastParams.new()
                rp.FilterType = Enum.RaycastFilterType.Exclude
                rp.FilterDescendantsInstances = ignore
                local f  = thrp.Position + inv * 3.0
                local wr = workspace:Raycast(thrp.Position, inv * 3.0, rp)
                if wr then f = wr.Position - inv * 0.5 end
                local cand = Vector3.new(f.X, math.max(f.Y, kf + 3), f.Z)
                if isSanePos(cand) and not posIsOOB(cand) and hasLOS(cand, hh.Position, ignore) then
                    flank = cand
                end
            end
            if flank then
                vantage = flank
                State.OrbitVantage = nil
                if isRiotShield(tgt) then
                    status = "Anti-riot"
                elseif isKatana(tgt) then
                    status = "Katana flank"
                else
                    status = "Backstab"
                end
            else
                local knife = isEnemyKnife(tgt)
                local held  = State.OrbitVantage
                if (not held) or tick() >= (State.OrbitVantageUntil or 0) or not hasLOS(held, aimPos, ignore) then
                    local v = orbitVantage(aimPos, ignore, kf, knife)
                    if v then
                        State.OrbitVantage = v
                        State.OrbitVantageUntil = tick() + (Config.RageOrbitDwell or 0.09)
                        held = v
                    elseif held and hasLOS(held, aimPos, ignore) then
                        State.OrbitVantageUntil = tick() + (Config.RageOrbitDwell or 0.09)
                    else
                        held = nil
                    end
                end
                if held then
                    vantage = held
                    if knife then status = "Orbit (kept dist)" else status = "Orbit" end
                end
            end
            if not vantage or not isSanePos(vantage) or posIsOOB(vantage) then
                return orbitVoid(hrp, "Orbit (hiding)")
            end
            State.RageStatus = status or "Orbit"
            State.RageVoidActive = false
            local jumped = _orbLastDisp == nil or (vantage - _orbLastDisp).Magnitude > ORBIT_JUMP
            _orbLastDisp = vantage
            if _orbHiding or jumped then
                _orbHiding = false
                local extra = 0
                if Config.RageHideJitter ~= false then extra = math.random() * ORBIT_JITTER_MAX end
                _orbPrimeUntil = tick() + ORBIT_PRIME_S + extra
            end
            Rage._displace(hrp, CFrame.new(vantage))
            local holdFire = false
            if Config.RageSkipImmune ~= false then holdFire = isSpawnProtected(tgt) end
            if not holdFire then
                _orbImmuneSince, _orbImmuneTgt = 0, nil
            else
                local nowI = tick()
                if _orbImmuneTgt ~= tgt then
                    _orbImmuneSince, _orbImmuneTgt = nowI, tgt
                end
                if nowI - _orbImmuneSince > ORB_IMMUNE_MAX_HOLD then
                    holdFire = false
                    State.RageImmuneOverride = (State.RageImmuneOverride or 0) + 1
                end
            end
            if holdFire then
                State.RageFiring = false
                State.RageStatus = "Protected — vantage held, holding fire"
            elseif tick() < _orbPrimeUntil then
                State.RageFiring = false
                State.RageStatus = "Priming"
            else
                State.RageFiring = true
                local eye = vantage + Vector3.new(0, Config.RagePBEyeUp or 3, 0)
                polarFire(eye, aimPos, hh)
            end
            pcall(Visuals.notifyTarget, tgt)
        end
        local function rageTick(ch, hrp, tgt)
            if (Config.RageMode or "Polar") ~= "Orbit" then
                State.RageStatus = "Mode error"
                return
            end
            orbitTick(ch, hrp, tgt)
        end
        Rage._rageTick = rageTick
    end)()
    local function onLocalDied()
        pcall(function()
            if tick() - State.RageBelowPlaneLast < 0.5 then
                State.RageBelowPlaneDeaths = State.RageBelowPlaneDeaths + 1
                State.RageBelowPlaneLast = 0
            end
            if not Config.Rage then
                return
            end
            if Config.RageMode == "Orbit" then
                return
            end
            if tick() - (State.RageKnifeHintLast or 0) < 90 then
                return
            end
            local knifed = false
            local tgt = State.RageTarget
            if tgt and tgt.Parent and isEnemyKnife(tgt) then
                knifed = true
            else
                local dpos = nil
                local real = State.RageRealCF
                if real then
                    dpos = real.Position
                else
                    local ch = lp.Character
                    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        dpos = hrp.Position
                    end
                end
                if dpos then
                    for _, plr in ipairs(getSafePlayers()) do
                        if plr ~= lp and not (Config.TeamCheck and isTeammate(plr)) then
                            local r = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                            if r and (r.Position - dpos).Magnitude <= 18 and isEnemyKnife(plr) then
                                knifed = true
                                break
                            end
                        end
                    end
                end
            end
            if not knifed then
                return
            end
            State.RageKnifeHintLast = tick()
            local lib = _G["\76\72"]
            if lib and lib.Notify then
                pcall(function() lib:Notify("Knifed by a melee player â€” switch Rage mode to Orbit (our knife counter)", 5) end)
            end
        end)
    end
    local function hookDied(char)
        if _rageDiedConn then
            _rageDiedConn:Disconnect()
            _rageDiedConn = nil
        end
        if not char then
            return
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            _rageDiedConn = hum.Died:Connect(onLocalDied)
        end
    end
    local function restoreHome(pin)
        if State.RagePostPark then State.RageOrderCanary = State.RageOrderCanary + 1 end
        local ch = lp.Character
        if not ch then return end
        local hrp = ch:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return end
        local back = _preParkCF
        _preParkCF = nil
        if back == nil then
            local real = State.RageRealCF
            if real and State.RageRealChar == ch then
                back = CFrame.new(real.Position) * hrp.CFrame.Rotation
            end
        end
        pcall(function()
            if back then hrp.CFrame = back end
            State.RageParkDirty = false
            if pin then
                local hu = ch:FindFirstChildOfClass("Humanoid")
                if hu and hu:GetState() == Enum.HumanoidStateType.Freefall and hu.FloorMaterial ~= Enum.Material.Air then
                    hu:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end)
    end
    local function startRage()
        if _rageConn then return end
        if Rage._setPhysicsFlags then pcall(Rage._setPhysicsFlags, true) end
        hookDied(lp.Character)
        if not _rageCharConn then
            _rageCharConn = lp.CharacterAdded:Connect(function()
                State.RageRealCF = nil; State.RageRealChar = nil
                State.RageVoidCF = nil; State.RageVoidBase = nil
                State.RageParkDirty = false; State.RageLastParkPos = nil
                hookDied(lp.Character)
            end)
        end
        local function rageRestoreActive()
            if not Config.Rage then return false end
            if not State.RageInMatch then return false end
            if State.RageRealChar ~= lp.Character then return false end
            return true
        end
        pcall(function() RunService:UnbindFromRenderStep(_rageRestoreName) end)
        RunService:BindToRenderStep(_rageRestoreName, Enum.RenderPriority.First.Value - 1000, function()
            State.RagePostPark = false
            if rageRestoreActive() then restoreHome(true) end
        end)
        if not _rageStepConn then
            _rageStepConn = RunService.Stepped:Connect(function()
                State.RagePostPark = false
                if rageRestoreActive() then restoreHome(true) end
            end)
        end
        local function defeatCooldowns()
            if not Config.Rage then return end
            local it = getEquippedItem()
            if not it then return end
            it._shoot_cooldown = 0
            it._shoot_cooldown_no_ammo = 0
            if (it._last_shot or 0) > tick() + 1 then it._last_shot = tick() - 1 end
            if it._shot_but_ammo_hasnt_updated then it._shot_but_ammo_hasnt_updated = false end
        end
        if not _rageCooldownConn then
            _rageCooldownConn = RunService.Heartbeat:Connect(function()
                pcall(defeatCooldowns)
            end)
        end
        _rageConn = RunService.Heartbeat:Connect(function()
            if not Config.Rage or (Config.RageMode or "Polar") ~= "Orbit" then
                if Rage._setPhysicsFlags then pcall(Rage._setPhysicsFlags, false) end
                restoreHome(false)
                pcall(function() RunService:UnbindFromRenderStep(_rageRestoreName) end)
                if _rageConn then _rageConn:Disconnect(); _rageConn = nil end
                if _rageStepConn then _rageStepConn:Disconnect(); _rageStepConn = nil end
                if _rageCooldownConn then _rageCooldownConn:Disconnect(); _rageCooldownConn = nil end
                if _rageCharConn then _rageCharConn:Disconnect(); _rageCharConn = nil end
                if _rageDiedConn then _rageDiedConn:Disconnect(); _rageDiedConn = nil end
                State.RageRealCF = nil; State.RageRealChar = nil
                State.RageTarget = nil; State.RageVoidCF = nil; State.RageVoidBase = nil
                State.RageParkDirty = false; State.RageLastParkPos = nil
                State.RageInMatch = false
                State.OrbitVantage = nil; State.OrbitVantageUntil = 0
                clearFireSolution()
                return
            end
            local ch  = lp.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if not hrp or not hrp.Parent then
                if tick() - State.RageBelowPlaneLast < 0.5 then
                    State.RageBelowPlaneDeaths = State.RageBelowPlaneDeaths + 1
                    State.RageBelowPlaneLast = 0
                end
                clearFireSolution()
                return
            end
            if State.RageParkDirty and State.RageRealChar == ch then
                State.RageParkLatchCanary = State.RageParkLatchCanary + 1
                if State.RageLastParkPos then
                    State.RageLatchStuds = (hrp.Position - State.RageLastParkPos).Magnitude
                end
            elseif isSanePos(hrp.Position) then
                State.RageRealCF = hrp.CFrame
                State.RageRealChar = ch
            end
            State.RageInMatch = inMatch()
            if not State.RageInMatch then
                if not isSanePos(hrp.Position) then restoreHome(false) end
                State.RageTarget = nil
                State.RageStatus = "Lobby"
                State.RageFiring = false
                clearFireSolution()
                return
            end
            if not State.RageRealCF or State.RageRealChar ~= ch then
                State.RageStatus = "Waiting"
                State.RageFiring = false
                clearFireSolution()
                return
            end
            local hum0 = ch:FindFirstChildOfClass("Humanoid")
            if hum0 and hum0.Health <= 0 then
                if not isSanePos(hrp.Position) then restoreHome(false) end
                State.RageFiring = false
                State.RageVoidActive = false
                State.RageStatus = "Dead"
                clearFireSolution()
                return
            end
            local tgt = State.RageTarget
            do
                if tgt and (not tgt.Parent or not tgt.Character or not isAlive(tgt)
                    or (Config.TeamCheck and isTeammate(tgt))) then
                    tgt = nil
                end
                if not tgt then tgt = Rage._findTarget() end
                State.RageTarget = tgt
            end
            State.RagePostPark = true
            Rage._rageTick(ch, hrp, tgt)
            local anchor    = State.RageRealCF
            local displaced = false
            if anchor then displaced = (hrp.Position - anchor.Position).Magnitude > 0.001 end
            State.RageParkDirty = displaced
            if displaced then State.RageLastParkPos = hrp.Position end
        end)
    end
    function Rage.enable()
        Config.Rage = true
        if Rage._startTargetLoop then Rage._startTargetLoop() end
        if (Config.RageMode or "Polar") ~= "Orbit" then
            if Rage._polarCoreStart then Rage._polarCoreStart() end
            return
        end
        startRage()
    end
    function Rage.disable()
        Config.Rage = false
        if Rage._polarCoreStop then Rage._polarCoreStop() end
        State.RagePostPark = false
        pcall(function() RunService:UnbindFromRenderStep(_rageRestoreName) end)
        if _rageConn then _rageConn:Disconnect(); _rageConn = nil end
        if _rageStepConn then _rageStepConn:Disconnect(); _rageStepConn = nil end
        if _rageCooldownConn then _rageCooldownConn:Disconnect(); _rageCooldownConn = nil end
        if _rageCharConn then _rageCharConn:Disconnect(); _rageCharConn = nil end
        if _rageDiedConn then _rageDiedConn:Disconnect(); _rageDiedConn = nil end
        restoreHome(false)
        State.RageRealCF = nil; State.RageRealChar = nil
        State.RageTarget = nil; State.RageVoidCF = nil; State.RageVoidBase = nil
        State.RageParkDirty = false; State.RageLastParkPos = nil
        State.RageInMatch = false
        State.OrbitVantage = nil; State.OrbitVantageUntil = 0
        State.RageFiring = false
        State.RageVoidActive = false
        State.RageStatus = "Idle"
        clearFireSolution()
    end
    function Rage.unload()
        Rage.disable()
        if _tgtConn then pcall(function() _tgtConn:Disconnect() end); _tgtConn = nil end
        if _labConn then pcall(function() _labConn:Disconnect() end); _labConn = nil end
    end
    Rage._encodeRageShot = encodeRageShot
    Rage._restoreHome = restoreHome
    Rage._polarFire   = polarFire
end)()
;(function()
    local PolarCore = {}
    local _realCF, _realChar = nil, nil
    local _voidCF     = nil
    local _target     = nil
    local _firing     = false
    local _inMatch    = false
    local _deflectSince = 0
    local _shots      = 0
    local _voidSteps  = 0
    local _shootEnum  = nil
    local _useItem    = nil
    local _notified   = nil
    local _conn, _stepConn, _charConn = nil, nil, nil
    local RENDER_NAME = "LuaHook_PolarCore_Restore"
    local CAMERA_NAME = "LuaHook_PolarCore_CamAnchor"
    local SANE_POS_LIMIT  = 100000
    local MAX_DISTANCE    = 1200
    local VOID_HIDE       = true
    local POLAR_TAPS_SANE = 6
    local EYE_UP_SANE     = 2.5
    local KILL_PLANE_BUF  = 200
    local PARK_FAIL_FALLBACK = 8
    local PARK_DRIFT_STUDS = 1.5
    local VOID_MOVE       = true
    local VOID_MIN_STEP   = 25000
    local VOID_R_MIN      = 110000
    local VOID_R_MAX      = 140000
    local HIDE_WHEN_UNREACHABLE = true
    local DEFLECT_MAX_HOLD = 1.5
    local IMMUNE_MAX_HOLD = 6.0
    local _immuneSince = 0
    local _immuneTgt   = nil
    local EYE_MUZZLE_SEP  = 0.07
    local RAGE_CLAMP_FRAC = 0.30
    local function parity()
        return Config.RagePolarParity ~= false
    end
    local _preParkCF = nil
    local FFLAGS_ON  = { DFIntS2PhysicsSenderRate = "120", DFIntAssemblyHistoryBufferSize = "2147483648", DFIntAssemblyHistorySkipSize = "0" }
    local FFLAGS_OFF = { DFIntS2PhysicsSenderRate = "15",  DFIntAssemblyHistoryBufferSize = "15",         DFIntAssemblyHistorySkipSize = "8" }
    local _fpdhOriginal = nil
    local _fpdhWrote = false
    local _flagsOn = false
    local _physSet  = false
    local _physLive = false
    local function fflagApi()
        local set, get, name = nil, nil, "none"
        pcall(function()
            if type(setfflag) == "function" then
                set, name = setfflag, "setfflag"
            elseif type(setfastflag) == "function" then
                set, name = setfastflag, "setfastflag"
            elseif type(set_fflag) == "function" then
                set, name = set_fflag, "set_fflag"
            end
            if type(getfflag) == "function" then
                get = getfflag
            elseif type(getfastflag) == "function" then
                get = getfastflag
            end
        end)
        return set, get, name
    end
    local function readsBack(get, name, want)
        if get == nil then return nil end
        local ok, v = pcall(get, name)
        if not ok or v == nil then return nil end
        if tostring(v) == want then return true end
        local got, req = tonumber(v), tonumber(want)
        if got == nil or req == nil then return false end
        if req >= 2147483647 then return got >= 2147483646 end
        return got == req
    end
    local _fpdhGetId, _fpdhSetId, _fpdhIdTried = nil, nil, false
    local _fpdhDead = false
    local function writeFPDH(value)
        if _fpdhDead then return false, "refused earlier this session, not retried" end
        if not identityIsSafe() then return false, "skipped (identity dance off)" end
        if not _fpdhIdTried then
            _fpdhIdTried = true
            pcall(function()
                local g = getthreadidentity or get_thread_identity or getidentity or getthreadcontext
                local s = setthreadidentity or set_thread_identity or setidentity or setthreadcontext
                if type(g) == "function" and type(s) == "function" then _fpdhGetId, _fpdhSetId = g, s end
            end)
        end
        if _fpdhSetId == nil then return false, "skipped (no identity API)" end
        local wrote = false
        task.spawn(function()
            local okPrev, prev = pcall(_fpdhGetId)
            if not okPrev then return end
            local setid = _fpdhSetId
            if not pcall(setid, 8) then return end
            local sp = sethiddenproperty or set_hidden_property
            local wroteVia = false
            if type(sp) == "function" then
                wroteVia = pcall(sp, workspace, "FallenPartsDestroyHeight", value)
            end
            if not wroteVia then
                pcall(function() workspace.FallenPartsDestroyHeight = value end)
            end
            pcall(setid, prev)
            local okR, v = pcall(function() return workspace.FallenPartsDestroyHeight end)
            if okR then
                if value ~= value then wrote = (v ~= v) else wrote = (v == value) end
            end
        end)
        if wrote then return true, "identity 8" end
        _fpdhDead = true
        return false, "REFUSED at identity 8 (latched off — this is the one console line per session)"
    end
    local function setPhysicsFlags(on)
        if on == _flagsOn then return end
        if on and Config.RagePhysicsFlags == false then return end
        _flagsOn = on
        if _fpdhOriginal == nil then
            local prev = workspace.FallenPartsDestroyHeight
            if prev ~= prev then prev = -500 end
            _fpdhOriginal = prev
        end
        local fpdhOk, fpdhHow = false, "not attempted"
        if on then
            fpdhOk, fpdhHow = writeFPDH(0 / 0)
            _fpdhWrote = fpdhOk
        elseif _fpdhWrote then
            local okBack, howBack = writeFPDH(_fpdhOriginal)
            fpdhHow = "restored=" .. tostring(okBack) .. " " .. tostring(howBack)
            _fpdhWrote = false
        else
            fpdhHow = "nothing to restore"
        end
        State.RageFPDHPath = fpdhHow
        local set, get, setName = fflagApi()
        if set == nil then
            _physSet, _physLive = false, false
            State.RagePhysVerified = false
            State.RagePhysRate = "no fflag setter — history decimation stays stock"
            return
        end
        local want = FFLAGS_OFF
        if on then want = FFLAGS_ON end
        local threw, detail = false, ""
        local keyOk = false
        for name, value in want do
            local wrote = pcall(set, name, value)
            if not wrote then threw = true end
            local seen = readsBack(get, name, value)
            local tag = "?"
            if seen == true then tag = "ok" end
            if seen == false then tag = "REFUSED" end
            if not wrote then tag = "THREW" end
            if name == "DFIntAssemblyHistorySkipSize" and seen == true then keyOk = true end
            detail = detail .. string.sub(name, 5) .. "=" .. tag .. " "
        end
        _physSet  = on and not threw
        _physLive = _physSet and keyOk and fpdhOk
        State.RagePhysVerified = _physLive
        State.RagePhysSet = _physSet
        State.RagePhysDetail = detail .. "FPDH=" .. tostring(fpdhOk)
        local how = "verified"
        if not on then
            how = "off"
        elseif threw then
            how = "THREW"
        elseif not fpdhOk then
            how = "FPDH refused"
        elseif not keyOk then
            how = "SkipSize unproven"
        end
        State.RagePhysRate = setName .. " " .. how
    end
    local glueActive
    local function restoreMode()
        if glueActive ~= nil and glueActive() then return "kicia" end
        local m = Config.RageRestoreMode
        if m == "kerp" then m = "kicia" end
        if m == "auto" then m = (State.RageAutoTransport == "render") and "render" or "kicia" end
        if m == "kicia" or m == "render" or m == "none" then return m end
        return "none"
    end
    local _identGet, _identSet = nil, nil
    local _identTried = false
    local function identEnsure()
        if _identTried then return _identSet ~= nil end
        _identTried = true
        pcall(function()
            local g = getthreadidentity or get_thread_identity
            local s = setthreadidentity or set_thread_identity or setidentity or setthreadcontext
            if type(g) == "function" and type(s) == "function" then
                _identGet, _identSet = g, s
            end
        end)
        State.RageRawSet = _identSet ~= nil
        return _identSet ~= nil
    end
    local function rawSetCFrame(hrp, cf)
        State.CapabilitySeam = "07c park write (hrp.CFrame)"
        identEnsure()
        if _identSet ~= nil and identityIsSafe() then
            local wrote = false
            task.spawn(function()
                local okPrev, prev = pcall(_identGet)
                if not okPrev then return end
                if not pcall(_identSet, 8) then return end
                wrote = pcall(function() hrp.CFrame = cf end)
                pcall(_identSet, prev)
            end)
            if wrote then return true end
        end
        return pcall(function() hrp.CFrame = cf end)
    end
    local _rvCF = nil
    local GLUE_PARK_OFF = Vector3.new(0, -0.7, 0.05)
    local GLUE_CHAR0 = {
        [utf8.char(0)] = -9e37,
        [utf8.char(1)] = 0,
        [utf8.char(2)] = 0,
        [utf8.char(3)] = -math.pi / 2,
        [utf8.char(4)] = math.pi,
        [utf8.char(5)] = math.pi,
    }
    local GLUE_CHAR1 = {
        [utf8.char(0)] = 0,
        [utf8.char(1)] = -90000000,
        [utf8.char(2)] = 0,
        [utf8.char(3)] = -math.pi / 2,
        [utf8.char(4)] = math.pi,
        [utf8.char(5)] = math.pi,
    }
    local GLUE_CHAR3 = {
        [utf8.char(0)] = 0,
        [utf8.char(1)] = 1,
        [utf8.char(2)] = 0,
        [utf8.char(3)] = 0,
        [utf8.char(4)] = 0,
        [utf8.char(5)] = 0,
    }
    local _glueHit       = nil
    local _glueWeld      = nil
    local _glueWeldPart1 = nil
    local _glueAnchored  = nil
    local _gluePrev   = nil
    local _gluePrevOk = false
    local function gumMode()
        local m = Config.RageGumMode
        if m ~= "off" and m ~= "lite" and m ~= "on" then
            local g = Config.RageGlueMode
            if g == "lite" or g == "off" then
                m = g
            elseif g == "full" then
                m = "on"
            else
                m = "off"
            end
        end
        if m == "off" and Config.RagePartGlue == true then return "on" end
        return m
    end
    local _liteHit    = nil
    local _liteDriven = false
    local _glueDriven = false
    local TRANSLOCATE_PULSES_PER_BURST = 6
    local TRANSLOCATE_ARM_FRAMES = 12
    local _translocateFireFrames = 0
    local _translocateNext = false
    local _translocateBurstPulses = 0
    local _translocatePart = nil
    local _translocateHoldUntil = 0
    local _translocateHoldCF = nil
    local function baitHoldSeconds()
        local ms = tonumber(Config.RageBaitHeldMs)
        if ms == nil then ms = 300 end
        ms = math.max(0, math.min(1000, ms))
        if ms <= 0 then return 0 end
        return (ms * (1 + (math.random() * 2 - 1) * 0.25)) / 1000
    end
    local function pulseBudget()
        local n = tonumber(Config.RageBaitRate)
        if n == nil then n = 2 end
        return math.max(1, math.min(TRANSLOCATE_PULSES_PER_BURST, math.floor(n)))
    end
    local _baitGateWhy = "never evaluated"
    local POISON_ARM_FRAMES = 2
    local POISON_PER_BURST  = 1
    local _poisonFireFrames = 0
    local _poisonBlips      = 0
    local function atId8(fn, a, b, c)
        if _identSet == nil or not identityIsSafe() then return pcall(fn, a, b, c) end
        local done, ok, res = false, false, nil
        task.spawn(function()
            local okPrev, prev = pcall(_identGet)
            if not okPrev then return end
            if not pcall(_identSet, 8) then return end
            done = true
            ok, res = pcall(fn, a, b, c)
            pcall(_identSet, prev)
        end)
        if done then return ok, res end
        return pcall(fn, a, b, c)
    end
    Rage._atId8 = atId8
    local function setRepRoot(part, target)
        State.CapabilitySeam = "07c glue sethiddenproperty (PhysicsRepRootPart)"
        local ok = atId8(sethiddenproperty, part, "PhysicsRepRootPart", target)
        if not ok then return false end
        local seen = nil
        if type(gethiddenproperty) == "function" then
            local okR, v = atId8(gethiddenproperty, part, "PhysicsRepRootPart")
            if okR then seen = v end
        end
        if seen == nil then
            State.RageGlueVerified = "unverified (no gethiddenproperty)"
            return true
        end
        if seen ~= target then
            State.RageGlueVerified = "REFUSED (read back " .. tostring(seen) .. ")"
            return false
        end
        State.RageGlueVerified = "verified"
        return true
    end
    local function liteRelease()
        if _liteHit == nil then return end
        _liteHit    = nil
        _liteDriven = false
        State.RageGlueBound = false
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return end
        local back = hrp
        if _gluePrevOk then back = _gluePrev end
        setRepRoot(hrp, back)
        State.RageGlueVerified = "released"
    end
    local function liteAcquire(hit, predicting, melee)
        if gumMode() ~= "lite" or predicting or melee then
            liteRelease()
            return false
        end
        if type(sethiddenproperty) ~= "function" then
            liteRelease()
            return false
        end
        if not identEnsure() then
            liteRelease()
            return false
        end
        if hit == nil or hit.Parent == nil then
            liteRelease()
            return false
        end
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then
            liteRelease()
            return false
        end
        if not _gluePrevOk and type(gethiddenproperty) == "function" then
            local okP, v = atId8(gethiddenproperty, hrp, "PhysicsRepRootPart")
            if okP then
                _gluePrev   = v
                _gluePrevOk = true
            end
        end
        if not setRepRoot(hrp, hit) then
            liteRelease()
            return false
        end
        _liteHit    = hit
        _liteDriven = true
        State.RageGlueBound = true
        return true
    end
    glueActive = function()
        return _glueHit ~= nil
    end
    local function glueSetup(hit)
        local weld = hit:FindFirstChildOfClass("WeldConstraint")
        if weld == nil then weld = hit:FindFirstChild("WeldConstraint") end
        if weld == nil then return end
        _glueWeld      = weld
        _glueWeldPart1 = weld.Part1
        _glueAnchored  = hit.Anchored
        atId8(function()
            if _glueWeldPart1 ~= nil then weld.Part1 = nil end
            hit.Anchored = true
        end)
    end
    local function glueTeardown()
        local weld, part1, hit, anch = _glueWeld, _glueWeldPart1, _glueHit, _glueAnchored
        _glueWeld, _glueWeldPart1, _glueAnchored = nil, nil, nil
        atId8(function()
            if weld ~= nil and weld.Parent ~= nil and part1 ~= nil then weld.Part1 = part1 end
            if hit ~= nil and hit.Parent ~= nil and anch ~= nil then hit.Anchored = anch end
        end)
    end
    local function glueRelease()
        State.RageTranslocating = false
        if _glueHit == nil then return end
        glueTeardown()
        _glueHit    = nil
        _glueDriven = false
        State.RageGlueBound = false
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return end
        local back = hrp
        if _gluePrevOk then
            back = _gluePrev
        end
        setRepRoot(hrp, back)
        State.RageGlueVerified = "released"
    end
    local function glueAcquire(hit)
        if gumMode() ~= "on" then return nil end
        if type(sethiddenproperty) ~= "function" then return nil end
        if not identEnsure() then return nil end
        if hit == nil or hit.Parent == nil then return nil end
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return nil end
        if not _gluePrevOk and type(gethiddenproperty) == "function" then
            local okP, v = atId8(gethiddenproperty, hrp, "PhysicsRepRootPart")
            if okP then
                _gluePrev   = v
                _gluePrevOk = true
            end
        end
        if not setRepRoot(hrp, hit) then
            glueRelease()
            return nil
        end
        if _glueHit ~= hit then
            glueTeardown()
            _glueHit = hit
            glueSetup(hit)
        end
        if _rvCF == nil then
            _rvCF = CFrame.new(math.random(-100000, -10000), 100000, math.random(-100000, 10000))
        end
        local rv = _rvCF.Position
        local moved = pcall(function() hit.CFrame = CFrame.new(rv) end)
        if not moved then
            glueRelease()
            return nil
        end
        _glueDriven = true
        State.RageGlueBound = true
        return rv
    end
    local function displace(hrp, cf)
        if _preParkCF == nil then _preParkCF = hrp.CFrame end
        return rawSetCFrame(hrp, cf)
    end
    local _parkFailStreak = 0
    local _prevPark    = nil
    local _prevParkTgt = nil
    local _lastPark    = nil
    local PRIME_S         = 0.07
    local HIDE_JITTER_MAX = 0.25
    local _hiding     = false
    local _primeUntil = 0
    local HACK_SPEED = 120
    local HACK_ACCUM = 0.15
    local _hackTag   = {}
    local _lastSeen  = {}
    local _hackAccum = {}
    local function tickHackers(dt)
        if dt <= 0 or dt > 0.5 then return end
        for _, p in Players:GetPlayers() do
            if p ~= lp and not _hackTag[p] then
                local c = p.Character
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos = hrp.Position
                    if not isSanePos(pos) then
                        _hackTag[p] = true
                    else
                        local last = _lastSeen[p]
                        if last then
                            if (pos - last).Magnitude / dt > HACK_SPEED then
                                local a = (_hackAccum[p] or 0) + dt
                                _hackAccum[p] = a
                                if a >= HACK_ACCUM then _hackTag[p] = true end
                            else
                                _hackAccum[p] = 0
                            end
                        end
                        _lastSeen[p] = pos
                    end
                end
            end
        end
    end
    local PRED_LEAD    = 0.15
    local PRED_MIN     = 0.05
    local PRED_MAX     = 120.0
    local PRED_SAMPLES = 5
    local PRED_NEEDED  = 3
    local _predHidden  = {}
    local _predDur     = {}
    local _predLast    = {}
    local PRED_MIN_PRES = 0.004
    local _predShown   = {}
    local _predPres    = {}
    local function isSanePos(p)
        return p == p
            and math.abs(p.X) < SANE_POS_LIMIT
            and math.abs(p.Y) < SANE_POS_LIMIT
            and math.abs(p.Z) < SANE_POS_LIMIT
    end
    local function tickPredict()
        local now = os.clock()
        for _, p in Players:GetPlayers() do
            if p ~= lp then
                local c = p.Character
                local hh = nil
                if c then hh = c:FindFirstChild("HitboxHead") or c:FindFirstChild("Head") end
                isSpawnProtected(p)
                local rp   = c and c:FindFirstChild("HumanoidRootPart") or nil
                local mine = hh ~= nil and hh == _glueHit
                if c == nil and _predHidden[p] ~= nil then
                    _predHidden[p] = nil
                    _predShown[p] = nil
                end
                local ref  = rp
                if ref == nil and not mine then ref = hh end
                if ref ~= nil and isSanePos(ref.Position) then
                    if hh ~= nil and not mine then _predLast[p] = hh.Position end
                    local since = _predHidden[p]
                    if since ~= nil then
                        _predHidden[p] = nil
                        _predShown[p] = now
                        local d = now - since
                        if d >= PRED_MIN and d <= PRED_MAX then
                            local r = _predDur[p]
                            if r == nil then
                                r = {}
                                _predDur[p] = r
                            end
                            r[#r + 1] = d
                            if #r > PRED_SAMPLES then table.remove(r, 1) end
                        end
                    end
                elseif ref ~= nil and _predHidden[p] == nil then
                    _predHidden[p] = now
                    local shown = _predShown[p]
                    if shown ~= nil then
                        _predShown[p] = nil
                        local dp = now - shown
                        if dp >= PRED_MIN_PRES and dp <= PRED_MAX then
                            local rr = _predPres[p]
                            if rr == nil then
                                rr = {}
                                _predPres[p] = rr
                            end
                            rr[#rr + 1] = dp
                            if #rr > PRED_SAMPLES then table.remove(rr, 1) end
                        end
                    end
                end
            end
        end
    end
    local function predMedian(p)
        local r = _predDur[p]
        if r == nil or #r < PRED_NEEDED then return nil end
        local s = {}
        for i = 1, #r do s[i] = r[i] end
        table.sort(s)
        return s[math.floor(#s / 2) + 1]
    end
    local function aboutToResurface(p)
        local since = _predHidden[p]
        if since == nil then return false end
        local m = predMedian(p)
        if m == nil then return false end
        local elapsed = os.clock() - since
        if elapsed > m + PRED_LEAD then return false end
        return elapsed >= m - PRED_LEAD
    end
    local function resurfaceIn(p)
        local since = _predHidden[p]
        if since == nil then return nil end
        local m = predMedian(p)
        if m == nil then return nil end
        return m - (os.clock() - since)
    end
    local function preFireLead()
        local ok, v = pcall(function() return lp:GetNetworkPing() end)
        local ping = 0.05
        if ok and type(v) == "number" and v == v and v > 0 then ping = v end
        if ping > 0.2 then ping = 0.2 end
        return ping
    end
    local function medianOf(tab, p, need)
        local r = tab[p]
        if r == nil or #r < need then return nil end
        local t = {}
        for i = 1, #r do t[i] = r[i] end
        table.sort(t)
        return t[math.floor(#t / 2) + 1]
    end
    local function publishPredict(p)
        if p == nil then
            State.RagePredTarget = nil
            return
        end
        State.RagePredTarget = p.Name
        State.RagePredHide   = predMedian(p) or 0
        State.RagePredHideN  = _predDur[p] and #_predDur[p] or 0
        State.RagePredAtk    = medianOf(_predPres, p, 2) or 0
        State.RagePredAtkN   = _predPres[p] and #_predPres[p] or 0
        local since = _predHidden[p]
        if since ~= nil then
            State.RagePredPhase = "HIDDEN"
            State.RagePredFor   = os.clock() - since
        else
            local shown = _predShown[p]
            State.RagePredPhase = "PRESENT"
            State.RagePredFor   = shown ~= nil and (os.clock() - shown) or 0
        end
        State.RagePredDue    = resurfaceIn(p) or 0
        State.RagePredWindow = aboutToResurface(p)
        local c  = p.Character
        local rr = c and c:FindFirstChild("HumanoidRootPart")
        State.RagePredMag = rr and rr.Position.Magnitude or 0
    end
    local function posInPart(pos, part)
        if not part or not part.Parent then return false end
        local lpv = part.CFrame:PointToObjectSpace(pos)
        local s = part.Size * 0.5
        return math.abs(lpv.X) <= s.X and math.abs(lpv.Y) <= s.Y and math.abs(lpv.Z) <= s.Z
    end
    local function posIsOOB(pos)
        local ok, result = pcall(function()
            for _, p in CollectionService:GetTagged("OutOfBoundsSafePart") do
                if posInPart(pos, p) then return false end
            end
            for _, p in CollectionService:GetTagged("OutOfBoundsPart") do
                if posInPart(pos, p) then return true end
            end
            return false
        end)
        return ok and result == true
    end
    local function killFloor()
        local ok, val = pcall(function() return Workspace.FallenPartsDestroyHeight end)
        if ok and type(val) == "number" and val == val then return val + KILL_PLANE_BUF end
        return -400
    end
    local function envIdOf(player)
        local id = nil
        pcall(function()
            local fc = Rivals.Fighter
            if fc == nil then return end
            local f = (player == lp) and fc.LocalFighter or (fc._player_to_fighter and fc._player_to_fighter[player])
            if f == nil then return end
            id = f:Get("EnvironmentID")
            if id == nil and f.Entity ~= nil then id = f.Entity:Get("EnvironmentID") end
        end)
        return id
    end
    local function isTeammate(player)
        if player == lp then return true end
        local myEnv, theirEnv = envIdOf(lp), envIdOf(player)
        if myEnv ~= nil and theirEnv ~= nil and myEnv ~= theirEnv then return true end
        local a = lp:GetAttribute("TeamID")
        local b = player:GetAttribute("TeamID")
        if a == nil or b == nil then
            if lp.Team ~= nil and player.Team ~= nil then return lp.Team == player.Team end
            return false
        end
        return a == b
    end
    local function isAlive(player)
        local c = player.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        return h ~= nil and h.Health > 0
    end
    local function isProtected(player)
        if not player or not player.Character then return false end
        if player.Character:FindFirstChildOfClass("ForceField") then return true end
        if not Config.RageSkipImmune then return false end
        return isSpawnProtected(player)
    end
    local function inMatch()
        local envOk = false
        pcall(function()
            local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
            if lf ~= nil and lf:Get("EnvironmentID") ~= nil and lf:IsAlive() then envOk = true end
        end)
        if envOk then return true end
        if lp:GetAttribute("TeamID") ~= nil then return true end
        if lp.Team ~= nil then return true end
        return false
    end
    local function getEquippedItem()
        local ok, result = pcall(function()
            local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
            if lf and lf.EquippedItem then return lf.EquippedItem end
            return nil
        end)
        if ok then return result end
        return nil
    end
    local function weaponReady(it)
        if not it then return false end
        local okE, equipping = pcall(function() return it:IsEquipping() end)
        if okE and equipping then return false end
        if (it._reload_cooldown or 0) > tick() then return false end
        local magazine = true
        pcall(function() magazine = it.Info.MaxAmmo ~= nil end)
        if not magazine then return true end
        local okA, ammo = pcall(function() return it:Get("Ammo") end)
        if not okA then
            State.RageAmmoUnreadable = (State.RageAmmoUnreadable or 0) + 1
            return true
        end
        return type(ammo) == "number" and ammo > 0
    end
    local function findTarget()
        local myChar = lp.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local cands = {}
        local unreachable = {}
        for _, p in Players:GetPlayers() do
            if p ~= lp and not isTeammate(p) and isAlive(p) then
                local c = p.Character
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = 9999
                    if myRoot then d = (hrp.Position - myRoot.Position).Magnitude end
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    local health = 9999
                    if hum then health = hum.Health end
                    local entry = { p = p, hp = health, d = d, prot = isProtected(p),
                                    hack = _hackTag[p] == true }
                    if isSanePos(hrp.Position) and d <= MAX_DISTANCE then
                        table.insert(cands, entry)
                    else
                        table.insert(unreachable, entry)
                    end
                end
            end
        end
        if #cands == 0 then cands = unreachable end
        if #cands == 0 then return nil end
        table.sort(cands, function(a, b)
            if Config.RagePrioritizeHackers ~= false and a.hack ~= b.hack then return a.hack end
            if a.prot ~= b.prot then return b.prot end
            if math.abs(a.hp - b.hp) > 10 then return a.hp < b.hp end
            return a.d < b.d
        end)
        return cands[1].p
    end
    local function voidAxis()
        local v = math.random(VOID_R_MIN, VOID_R_MAX)
        if math.random(0, 1) == 0 then return -v end
        return v
    end
    local VOID_DEEP_AXIS   = 1073741824
    local VOID_DEEP_JITTER = 0.4
    local _voidOrder       = { 1, 2, 3 }
    local function voidDeep()
        return Config.RageVoidDepth ~= "shallow"
    end
    local function deepMag(allowNeg)
        local m = VOID_DEEP_AXIS * (1 + math.random() * VOID_DEEP_JITTER)
        if allowNeg and math.random(0, 1) == 1 then return -m end
        return m
    end
    local function rollVoidDeep()
        local ang = math.random() * math.pi * 2
        local r   = math.random(1000, 1500)
        local x   = math.cos(ang) * r
        local y   = math.random(1000, 1500)
        local z   = math.sin(ang) * r
        local o   = _voidOrder
        o[1], o[2], o[3] = 1, 2, 3
        for i = 3, 2, -1 do
            local j = math.random(1, i)
            o[i], o[j] = o[j], o[i]
        end
        for i = 1, math.random(1, 3) do
            local axis = o[i]
            if axis == 1 then
                x = deepMag(true)
            elseif axis == 2 then
                y = deepMag(false)
            else
                z = deepMag(true)
            end
        end
        return CFrame.new(x, y, z)
    end
    local function rollVoid()
        if voidDeep() then return rollVoidDeep() end
        return CFrame.new(voidAxis(), math.random(VOID_R_MIN, VOID_R_MAX), voidAxis())
    end
    local function voidCFrame()
        local prev = _voidCF
        local cf = rollVoid()
        if VOID_MOVE and prev then
            local tries = 0
            while tries < 8 and (cf.Position - prev.Position).Magnitude < VOID_MIN_STEP do
                cf = rollVoid()
                tries = tries + 1
            end
        end
        _voidCF = cf
        _voidSteps = _voidSteps + 1
        return cf
    end
    local TRANSLOCATE_OFFSET = -5
    local TRANSLOCATE_FALLBACK_MIN = 10000
    local TRANSLOCATE_FALLBACK_MAX = 90000
    local function insideOBB(pos, part)
        local sz = part.Size
        local shape = part:IsA("Part") and part.Shape or Enum.PartType.Block
        if shape == Enum.PartType.Ball then
            return (pos - part.Position).Magnitude <= math.max(sz.X, sz.Y, sz.Z) / 2
        end
        local lpos = part.CFrame:PointToObjectSpace(pos)
        if shape == Enum.PartType.Cylinder then
            return math.abs(lpos.X) <= sz.X / 2
                and math.sqrt(lpos.Y * lpos.Y + lpos.Z * lpos.Z) <= math.max(sz.Y, sz.Z) / 2
        end
        return math.abs(lpos.X) <= sz.X / 2
            and math.abs(lpos.Y) <= sz.Y / 2
            and math.abs(lpos.Z) <= sz.Z / 2
    end
    local function parkIsSafe(pos)
        if not isSanePos(pos) then return false end
        local okV, hit = pcall(function()
            for _, vol in CollectionService:GetTagged("OutOfBoundsPart") do
                if insideOBB(pos, vol) then return true end
            end
            for _, kb in CollectionService:GetTagged("KillBrick") do
                if insideOBB(pos, kb) then return true end
            end
            return false
        end)
        return okV and hit == false
    end
    local _baitRetryAt = 0
    local function attackTranslocateCFrame(origin)
        if tick() < _baitRetryAt then return nil end
        local ok, result = pcall(function()
            local part = _translocatePart
            if part == nil or part.Parent == nil
               or not CollectionService:HasTag(part, "OutOfBoundsPart")
               or part:GetAttribute("KillDelay") ~= 0 then
                part = nil
                for _, candidate in CollectionService:GetTagged("OutOfBoundsPart") do
                    if candidate:GetAttribute("KillDelay") == 0
                       and candidate.Parent ~= nil
                       and candidate:IsA("Part")
                       and candidate.Shape == Enum.PartType.Block
                       and candidate.CFrame.UpVector.Y > 0.999
                       and parkIsSafe((candidate.CFrame
                            * CFrame.new(0, -candidate.Size.Y / 2 + TRANSLOCATE_OFFSET, 0)).Position) then
                        part = candidate
                        break
                    end
                end
                _translocatePart = part
            end
            if part ~= nil then
                local dest = part.CFrame * CFrame.new(0, -part.Size.Y / 2 + TRANSLOCATE_OFFSET, 0)
                if parkIsSafe(dest.Position) then return dest end
                _translocatePart = nil
            end
            local ang = math.random() * math.pi * 2
            local dist = TRANSLOCATE_FALLBACK_MIN
                + math.random() * (TRANSLOCATE_FALLBACK_MAX - TRANSLOCATE_FALLBACK_MIN)
            local ring = Vector3.new(origin.X + math.cos(ang) * dist, origin.Y, origin.Z + math.sin(ang) * dist)
            if parkIsSafe(ring) then
                State.RageBaitRingFallbacks = (State.RageBaitRingFallbacks or 0) + 1
                return CFrame.new(ring)
            end
            State.RageBaitPinRefused = (State.RageBaitPinRefused or 0) + 1
            return nil
        end)
        if not ok then
            _translocatePart = nil
            State.RageBaitPinRefused = (State.RageBaitPinRefused or 0) + 1
            _baitRetryAt = tick() + 0.5
            return nil
        end
        if result == nil then _baitRetryAt = tick() + 0.5 end
        return result
    end
    local PARK_UP_STUDS = 12
    local _parkRP = nil
    local function parkHasLOS(from, to, ourChar, tgtChar)
        if _parkRP == nil then
            _parkRP = RaycastParams.new()
            _parkRP.FilterType = Enum.RaycastFilterType.Exclude
        end
        _parkRP.FilterDescendantsInstances = { ourChar, tgtChar }
        local res = Workspace:Raycast(from, to - from, _parkRP)
        if not res then return true end
        return (res.Position - to).Magnitude < 3
    end
    local function eyeRise(fromPos, tgtChar)
        local rise = EYE_UP_SANE
        pcall(function()
            if _parkRP == nil then
                _parkRP = RaycastParams.new()
                _parkRP.FilterType = Enum.RaycastFilterType.Exclude
            end
            _parkRP.FilterDescendantsInstances = { lp.Character, tgtChar }
            local res = Workspace:Raycast(fromPos, Vector3.new(0, EYE_UP_SANE, 0), _parkRP)
            if res ~= nil then
                local room = (res.Position.Y - fromPos.Y) - 0.25
                if room < rise then
                    rise = math.max(room, 0.15)
                    State.RageEyeClampFrames = (State.RageEyeClampFrames or 0) + 1
                end
            end
        end)
        return rise
    end
    local MELEE_DWELL_S    = 0.07
    local _meleeDwellStart = nil
    local function pointBlank(hp)
        local y = math.max(hp.Y, killFloor() + 3)
        if y > hp.Y + 0.001 then
            State.RageParkClampFrames = (State.RageParkClampFrames or 0) + 1
        end
        return Vector3.new(hp.X, y, hp.Z)
    end
    local function meleeProfile(it)
        local prof = nil
        pcall(function()
            local info = it.Info
            if info == nil then return end
            if info.MaxAmmo ~= nil then return end
            local heavy = info.CriticalDamage ~= nil and type(info.HeavyAttackCooldown) == "number"
            prof = { heavy = heavy }
        end)
        return prof
    end
    local function meleeStrike(firePark, hpos, hh, tgt)
        local it = getEquippedItem()
        if it == nil then State.RageKnifeStatus = "no item" return false end
        local prof = meleeProfile(it)
        if prof == nil then State.RageKnifeStatus = "not a melee item" return false end
        local now = tick()
        if _meleeDwellStart == nil then _meleeDwellStart = now end
        if now - _meleeDwellStart < MELEE_DWELL_S then
            State.RageKnifeStatus = "dwell"
            return false
        end
        local actionName, animName = "StartShooting", "Attack1"
        if prof.heavy then
            actionName, animName = "StartAiming", "HeavyAttack1"
        end
        local actionEnum, animEnum = nil, nil
        pcall(function() actionEnum = Rivals.Enums:ToEnum(actionName) end)
        pcall(function() animEnum = Rivals.Enums:ToEnum(animName) end)
        local tc = tgt.Character
        local trp = tc and tc:FindFirstChild("HumanoidRootPart")
        if trp == nil then State.RageKnifeStatus = "target has no root" return false end
        local vp, vy = trp.CFrame:ToOrientation()
        if prof.heavy and Config.RageKnifeCamForge ~= false then
            ViewAngle.forge(vp, vy)
        end
        local eyePos   = firePark + Vector3.new(0, eyeRise(firePark, tgt and tgt.Character or nil), 0)
        local eyeCF    = Rage._lookCF(eyePos, hpos)
        local muzzleCF = eyeCF - Vector3.new(0, EYE_MUZZLE_SEP, 0)
        local sent = false
        State.RageFireFromPos = eyePos
        State.RageFireAimPos  = hpos
        State.RageFireHitPart = hh
        State.RageFireStamp   = tick()
        pcall(function()
            it._attack_cooldown = 0
            it._last_attack = tick() - 1
        end)
        local function lowerToId2()
            if not identityIsSafe() then return nil end
            local g = getthreadidentity or get_thread_identity or getidentity or getthreadcontext
            local s = setthreadidentity or set_thread_identity or setidentity or setthreadcontext
            if g == nil or s == nil then return nil end
            local prev = nil
            pcall(function() prev = g() end)
            if prev == nil or prev == 2 then return nil end
            if not pcall(s, 2) then return nil end
            return function() pcall(s, prev) end
        end
        local function atId2(fn)
            State.CapabilitySeam = "07c melee attack (atId2)"
            local ok, res = false, nil
            task.spawn(function()
                local restoreId = lowerToId2()
                ok, res = pcall(fn)
                if restoreId ~= nil then restoreId() end
            end)
            return ok, res
        end
        local hitData = { part = hh }
        if prof.heavy and type(it.HeavyAttack) == "function" then
            local ok = atId2(function() it:HeavyAttack(eyeCF, eyeCF, hitData) end)
            if ok then sent = true end
        elseif (not prof.heavy) and type(it.Attack) == "function" then
            local ok = atId2(function() it:Attack(eyeCF, eyeCF, hitData) end)
            if ok then sent = true end
        end
        local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
        if not sent then
            if Config.RageMeleeAsk ~= false then
                if lf == nil then State.RageKnifeStatus = "no LocalFighter" return false end
                local ok, err = atId2(function() lf:Input(actionName) end)
                local ran = false
                pcall(function() ran = (it._attack_cooldown or 0) > 0 end)
                sent = ok and ran
                if not ok then
                    State.RageKnifeStatus = "Input failed: " .. tostring(err)
                elseif not ran then
                    State.RageKnifeStatus = "item refused " .. actionName
                end
            else
                if _useItem == nil then
                    pcall(function() _useItem = ReplicatedStorage.Remotes.Replication.Fighter.UseItem end)
                end
                local okId, objId = pcall(function() return it:Get("ObjectID") end)
                if not okId or objId == nil then
                    pcall(function() objId = it.Info.ObjectID end)
                end
                if _useItem == nil then State.RageKnifeStatus = "no UseItem remote" return false end
                if objId == nil then State.RageKnifeStatus = "no ObjectID" return false end
                if actionEnum == nil then
                    State.RageKnifeStatus = "no " .. actionName .. " enum"
                    return false
                end
                State.RageForging = true
                local ferr = nil
                local fok = atId2(function()
                    local inner = {}
                    Rage._buildShotFields(inner, eyeCF, muzzleCF, hh, hpos, true, RAGE_CLAMP_FRAC, 1.0)
                    local env = { [utf8.char(1)] = inner }
                    if animEnum ~= nil then env[utf8.char(2)] = animEnum end
                    _useItem:FireServer(objId, actionEnum, env, nil)
                    sent = true
                end)
                State.RageForging = false
                if not fok then State.RageKnifeStatus = "FireServer failed: " .. tostring(ferr) end
            end
        end
        if sent then
            _shots = _shots + 1
            State.Shots = State.Shots + 1
            State.RageKnifeSwings = (State.RageKnifeSwings or 0) + 1
            State.RageKnifeStatus = "swinging " .. actionName
        else
            State.RageKnifeStatus = "send failed"
        end
        return sent
    end
    local _fireWhy = "no refusal yet"
    local _fireZeroFrames = 0
    local _sendErrShown = false
    local function reportSendError(err)
        if not _sendErrShown then
            _sendErrShown = true
            print("[LuaHook] SEND FAILED - the shot remote threw. This is the error that matters:")
            print("[LuaHook] >>> " .. tostring(err))
        end
        return "send threw: " .. tostring(err)
    end
    local function polarFire(eyePos, aimPos, hh, taps)
        local it = getEquippedItem()
        if not it then _fireWhy = "no equipped item"; return 0 end
        pcall(function()
            it._shoot_cooldown = 0
            it._shoot_cooldown_no_ammo = 0
            it._last_shot = tick() - 1
        end)
        if State.CapabilityDirty then
            State.CapabilityDirty = false
            _useItem, _shootEnum = nil, nil
            State.CapabilityRecoveries = (State.CapabilityRecoveries or 0) + 1
        end
        State.CapabilitySeam = "07c polarFire shot path (enum/UseItem walk/FireServer)"
        if _shootEnum == nil then
            pcall(function() _shootEnum = Rivals.Enums:ToEnum("StartShooting") end)
        end
        if _shootEnum == nil then _fireWhy = "StartShooting enum unresolved"; return 0 end
        if _useItem == nil then
            pcall(function() _useItem = ReplicatedStorage.Remotes.Replication.Fighter.UseItem end)
        end
        if _useItem == nil then _fireWhy = "UseItem remote unresolved (capability?)"; return 0 end
        local okId, objId = pcall(function() return it:Get("ObjectID") end)
        if not okId or not objId then _fireWhy = "ObjectID unreadable (capability?)"; return 0 end
        local fireEyePos = eyePos
        local base = eyePos - Vector3.new(0, EYE_UP_SANE, 0)
        local ftgt = State.RageTarget or State.Target
        local rise = eyeRise(base, ftgt and ftgt.Character or nil)
        if rise < EYE_UP_SANE then fireEyePos = base + Vector3.new(0, rise, 0) end
        local eyeCF    = Rage._lookCF(fireEyePos, aimPos)
        local muzzleCF = eyeCF - Vector3.new(0, EYE_MUZZLE_SEP, 0)
        local sent     = 0
        local rayCast = false
        pcall(function() rayCast = it.Info.IsRaycast == true end)
        local glued = glueActive()
        State.RageForging = true
        local okLoop, loopErr = pcall(function()
            for _ = 1, taps do
                local inner = {}
                if glued then
                    inner[utf8.char(0)] = GLUE_CHAR0
                    inner[utf8.char(1)] = GLUE_CHAR1
                    inner[utf8.char(2)] = hh
                    inner[utf8.char(3)] = GLUE_CHAR3
                else
                    Rage._buildShotFields(inner, eyeCF, muzzleCF, hh, aimPos, true, RAGE_CLAMP_FRAC, 1.0)
                end
                local env = { [utf8.char(1)] = inner }
                if rayCast and not parity() then env[utf8.char(2)] = true end
                _useItem:FireServer(objId, _shootEnum, env, nil)
                sent = sent + 1
            end
        end)
        State.RageForging = false
        if sent == 0 then _fireWhy = reportSendError(loopErr) end
        _shots = _shots + sent
        State.Shots = State.Shots + sent
        return sent
    end
    local function tapsPerFrame()
        local n = Config.RageTapsPerFrame
        if type(n) ~= "number" then return 1 end
        if n < 1 then return 1 end
        if n > POLAR_TAPS_SANE then return POLAR_TAPS_SANE end
        return math.floor(n)
    end
    local ATTACK_GAP_HOLD = 0.30
    local _attackGapTgt = nil
    local _attackGapUntil = 0
    local _attackReadyTgt = nil
    local function clearAttackGap()
        _attackGapTgt = nil
        _attackGapUntil = 0
    end
    local function resetAttackContinuity()
        clearAttackGap()
        _attackReadyTgt = nil
    end
    local function holdAttackGap(hrp, tgt, status)
        if Config.RageAttackContinuity == false then return false end
        local now = os.clock()
        if _attackGapTgt ~= tgt then
            if _attackReadyTgt ~= tgt or _prevPark == nil or _prevParkTgt ~= tgt then
                return false
            end
            _attackGapTgt = tgt
            _attackGapUntil = now + ATTACK_GAP_HOLD
        elseif now > _attackGapUntil then
            clearAttackGap()
            return false
        end
        _firing = false
        State.RageFiring = false
        State.RageStatus = status
        State.RageVoidActive = VOID_HIDE
        _lastPark = nil
        _meleeDwellStart = nil
        _translocateNext = false
        _translocateBurstPulses = 0
        _translocateFireFrames = 0
        _translocateHoldUntil, _translocateHoldCF = 0, nil
        _poisonFireFrames = 0
        _poisonBlips = 0
        liteRelease()
        glueRelease()
        if VOID_HIDE then
            displace(hrp, voidCFrame())
        end
        return true
    end
    local function hide(hrp, status)
        resetAttackContinuity()
        _firing = false
        State.RageFiring = false
        State.RageStatus = status
        State.RageVoidActive = VOID_HIDE
        _prevPark    = nil
        _prevParkTgt = nil
        _lastPark    = nil
        _hiding     = true
        _primeUntil = 0
        _meleeDwellStart = nil
        _translocateNext = false
        _translocateBurstPulses = 0
        _translocateFireFrames = 0
        _translocateHoldUntil, _translocateHoldCF = 0, nil
        _poisonFireFrames = 0
        _poisonBlips = 0
        liteRelease()
        glueRelease()
        if VOID_HIDE then
            displace(hrp, voidCFrame())
        end
    end
    local function polarTick(ch, hrp)
        local tgt = _target
        if tgt and (not tgt.Parent or not tgt.Character or not isAlive(tgt) or isTeammate(tgt)
                    or isProtected(tgt)) then
            tgt = nil
        end
        if not tgt then tgt = findTarget() end
        _target = tgt
        State.RageTarget = tgt
        publishPredict(tgt)
        if not tgt or not tgt.Character then return hide(hrp, "No target") end
        local holdFire = isProtected(tgt)
        if not holdFire then
            _immuneSince, _immuneTgt = 0, nil
        else
            local now = tick()
            if _immuneTgt ~= tgt then
                _immuneSince, _immuneTgt = now, tgt
            end
            if now - _immuneSince > IMMUNE_MAX_HOLD then
                holdFire = false
                State.RageImmuneOverride = (State.RageImmuneOverride or 0) + 1
            end
        end
        if Config.AvoidDeflect and isDeflecting(tgt) then
            local now = tick()
            if _deflectSince == 0 then _deflectSince = now end
            if now - _deflectSince < DEFLECT_MAX_HOLD then return hide(hrp, "Deflecting") end
        else
            _deflectSince = 0
        end
        local it = getEquippedItem()
        if not weaponReady(it) then
            local act = Rage._weaponRecovery(it)
            if act == "dry" then
                return hide(hrp, "Dry")
            end
            if act == "swap" or act == "swap-wait" then
                return hide(hrp, "Swapping")
            end
            return hide(hrp, "Reloading")
        end
        local hh = tgt.Character:FindFirstChild("HitboxHead") or tgt.Character:FindFirstChild("Head")
        if not hh then return hide(hrp, "Hiding") end
        if _hiding then
            _hiding = false
            local extra = 0
            if Config.RageHideJitter ~= false then
                extra = math.random() * HIDE_JITTER_MAX
            end
            _primeUntil = tick() + PRIME_S + extra
        end
        local trp  = tgt.Character:FindFirstChild("HumanoidRootPart")
        local mine = (hh == _glueHit)
        local hpos = hh.Position
        if mine and trp ~= nil then hpos = trp.Position end
        local predicting = false
        local voidFire   = false
        local rv         = nil
        if not isSanePos(hpos) then
            local pre = nil
            if Config.RagePredictResurface ~= false and aboutToResurface(tgt) then pre = _predLast[tgt] end
            if pre == nil or not isSanePos(pre) then
                if holdAttackGap(hrp, tgt, "Holding target swap") then
                    return nil
                end
                return hide(hrp, "Head voided")
            end
            hpos = pre
            predicting = true
            if Config.RageGumVoidFire ~= false and gumMode() == "on"
               and meleeProfile(it) == nil then
                rv = glueAcquire(hh)
                if rv ~= nil then
                    predicting = false
                    voidFire   = true
                end
            end
        end
        _firing = true
        State.RageFiring = not holdFire
        State.RageVoidActive = false
        local melee = meleeProfile(it) ~= nil
        if not melee and ViewAngle.isForging ~= nil and ViewAngle.isForging() then
            pcall(ViewAngle.restore)
        end
        local park
        if melee then
            local tc = tgt.Character
            local trp = tc and tc:FindFirstChild("HumanoidRootPart")
            if trp and (it.name == "Knife" or (meleeProfile(it) and meleeProfile(it).heavy)) then
                park = trp.Position - (trp.CFrame.LookVector * 1.2) + Vector3.new(0, 0.6, 0)
            else
                park = hpos + (trp and (trp.CFrame.LookVector * -0.8) or Vector3.new(0, -0.5, 0))
            end
        else
            park = pointBlank(hpos)
        end
        if not isSanePos(park) then
            if holdAttackGap(hrp, tgt, "Holding target swap") then
                return nil
            end
            return hide(hrp, "Hiding")
        end
        if Config.RageParkLift ~= false and not melee then
            local lifted = park + Vector3.new(0, PARK_UP_STUDS, 0)
            if isSanePos(lifted) and not posIsOOB(lifted)
               and parkHasLOS(lifted, hpos, ch, tgt.Character) then
                park = lifted
            end
        end
        local aimPos = hpos
        if rv == nil and not predicting and not melee then rv = glueAcquire(hh) end
        if rv == nil then liteAcquire(hh, predicting, melee) end
        if rv ~= nil then
            park   = rv + GLUE_PARK_OFF
            aimPos = hh.Position
        else
            glueRelease()
        end
        if posIsOOB(park) then
            if holdAttackGap(hrp, tgt, "Holding target swap") then
                return nil
            end
            return hide(hrp, "Hiding")
        end
        clearAttackGap()
        local firePark = nil
        if _prevPark ~= nil and _prevParkTgt == tgt then firePark = _prevPark end
        if restoreMode() ~= "kicia" then firePark = park end
        if firePark == nil and _parkFailStreak >= PARK_FAIL_FALLBACK then
            firePark = park
            State.RageParkFallbacks = (State.RageParkFallbacks or 0) + 1
        end
        local translocateReady = Config.RageAttackTranslocate ~= false
            and restoreMode() == "kicia"
            and not predicting and not holdFire and not melee and firePark ~= nil
            and not voidFire
            and (parity() or tick() >= _primeUntil)
        local startingTranslocate = translocateReady
            and _translocateNext
            and _translocateBurstPulses < pulseBudget()
        local translocateCF = nil
        if startingTranslocate then
            translocateCF = attackTranslocateCFrame(hrp.Position)
        end
        if translocateCF ~= nil then
            local hold = baitHoldSeconds()
            if hold > 0 then
                _translocateHoldUntil = tick() + hold
                _translocateHoldCF = translocateCF
            else
                _translocateHoldUntil, _translocateHoldCF = 0, nil
            end
        elseif _translocateHoldCF ~= nil then
            if Config.RageAttackTranslocate ~= false and restoreMode() == "kicia"
               and not melee and firePark ~= nil and tick() < _translocateHoldUntil then
                translocateCF = _translocateHoldCF
                State.RageBaitHoldFrames = (State.RageBaitHoldFrames or 0) + 1
            else
                _prevPark, _prevParkTgt = nil, nil
                _translocateHoldUntil, _translocateHoldCF = 0, nil
            end
        end
        local poisonCF = nil
        if translocateCF == nil
           and Config.RageGatePoison ~= false
           and voidDeep()
           and not predicting and not holdFire and not melee and firePark ~= nil
           and _poisonBlips < POISON_PER_BURST
           and _poisonFireFrames >= POISON_ARM_FRAMES then
            poisonCF = rollVoidDeep()
        end
        local desiredCFrame = CFrame.new(park)
        if translocateCF ~= nil then
            desiredCFrame = translocateCF
        elseif poisonCF ~= nil then
            desiredCFrame = poisonCF
        end
        local parked = displace(hrp, desiredCFrame)
        if _translocateHoldCF ~= nil then                     _baitGateWhy = "DIPPING (holding)"
        elseif startingTranslocate and translocateCF ~= nil then _baitGateWhy = "FIRING"
        elseif startingTranslocate then                       _baitGateWhy = "armed, no survivable destination"
        elseif Config.RageAttackTranslocate == false then     _baitGateWhy = "toggle off"
        elseif restoreMode() ~= "kicia" then                  _baitGateWhy = "transport not kerp"
        elseif predicting then                                _baitGateWhy = "predicting resurface"
        elseif holdFire then                                  _baitGateWhy = "hold fire"
        elseif melee then                                     _baitGateWhy = "melee equipped"
        elseif firePark == nil then                           _baitGateWhy = "no fire park"
        elseif voidFire then                                  _baitGateWhy = "target in its own void (S45)"
        elseif not (parity() or tick() >= _primeUntil) then   _baitGateWhy = "priming"
        elseif _translocateBurstPulses >= pulseBudget() then    _baitGateWhy = "burst budget spent"
        elseif _translocateFireFrames < TRANSLOCATE_ARM_FRAMES then _baitGateWhy = "arming (needs 12 fire frames)"
        elseif not _translocateNext then                      _baitGateWhy = "not armed this frame"
        else                                                  _baitGateWhy = "ready, no pulse" end
        if parked and translocateCF == nil and poisonCF == nil then
            _prevPark, _prevParkTgt = park, tgt
            _lastPark = CFrame.new(park)
        elseif not parked then
            _prevPark, _prevParkTgt = nil, nil
            _lastPark = nil
        end
        if parked then _parkFailStreak = 0 else _parkFailStreak = _parkFailStreak + 1 end
        State.RageParkFailStreak = _parkFailStreak
        if translocateCF ~= nil then
            _translocateNext = false
            if startingTranslocate then
                _translocateBurstPulses = _translocateBurstPulses + 1
                State.RageTranslocateBaits = (State.RageTranslocateBaits or 0) + 1
                _translocateFireFrames = 0
            end
            State.RageFiring = false
            State.RageTranslocating = parked
            if parked then
                State.RageWhyDip = (State.RageWhyDip or 0) + 1
                State.RageStatus = "Translocating"
            else
                State.RageStatus = "Translocate failed"
            end
        elseif poisonCF ~= nil then
            _translocateNext = false
            State.RageFiring = false
            if parked then
                _poisonBlips = _poisonBlips + 1
                _poisonFireFrames = 0
                State.RagePoisonBlips = (State.RagePoisonBlips or 0) + 1
                State.RageStatus = "Poisoning"
            else
                State.RageStatus = "Poison failed"
            end
        elseif predicting then
            _translocateNext = false
            local lead = nil
            if Config.RagePredictPrefire ~= false and firePark ~= nil then
                lead = resurfaceIn(tgt)
            end
            if lead ~= nil and lead <= preFireLead() and lead > -PRED_LEAD then
                local sent = polarFire(firePark + Vector3.new(0, EYE_UP_SANE, 0), aimPos, hh, tapsPerFrame())
                if sent > 0 then
                    _attackReadyTgt = tgt
                    _poisonFireFrames = _poisonFireFrames + 1
                    State.RagePreFires = (State.RagePreFires or 0) + 1
                end
                State.RageStatus = "Prefiring resurface"
            else
                State.RageFiring = false
                State.RageWhyPredict = (State.RageWhyPredict or 0) + 1
                State.RageStatus = "Predicting resurface"
            end
        elseif holdFire then
            _translocateNext = false
            State.RageWhyProtected = (State.RageWhyProtected or 0) + 1
            State.RageStatus = "Protected — parked, holding fire"
        elseif firePark == nil then
            _translocateNext = false
            State.RageFiring = false
            State.RageWhyNoPark = (State.RageWhyNoPark or 0) + 1
            State.RageStatus = "Priming"
            _meleeDwellStart = nil
        elseif (not parity()) and (tick() < _primeUntil) then
            _translocateNext = false
            State.RageFiring = false
            State.RageWhyPrimeWait = (State.RageWhyPrimeWait or 0) + 1
            State.RageStatus = "Priming"
            _meleeDwellStart = nil
        elseif melee and Config.RageKnifeBot ~= false then
            _translocateNext = false
            if meleeStrike(firePark, aimPos, hh, tgt) then
                _attackReadyTgt = tgt
                State.RageStatus = "Melee"
            else
                State.RageFiring = false
                State.RageWhyMeleeCd = (State.RageWhyMeleeCd or 0) + 1
                State.RageStatus = "Melee (cooldown)"
            end
        else
            local sent = polarFire(firePark + Vector3.new(0, EYE_UP_SANE, 0), aimPos, hh, tapsPerFrame())
            if sent > 0 then
                _attackReadyTgt = tgt
                _translocateFireFrames = _translocateFireFrames + 1
                _poisonFireFrames = _poisonFireFrames + 1
            end
            if voidFire and sent > 0 then
                State.RageVoidFires = (State.RageVoidFires or 0) + 1
            end
            _translocateNext = sent > 0 and parked and not melee
                and _translocateFireFrames >= TRANSLOCATE_ARM_FRAMES
                and _translocateBurstPulses < pulseBudget()
                and Config.RageAttackTranslocate ~= false
            State.RageStatus = "Attacking"
            if voidFire then State.RageStatus = "Attacking (gum void prefire)" end
            if sent == 0 then
                _fireZeroFrames = _fireZeroFrames + 1
                State.RageFireZeroFrames = _fireZeroFrames
                State.RageStatus = "PARKED, SENT NOTHING: " .. _fireWhy
            else
                State.RageFireFrames = (State.RageFireFrames or 0) + 1
            end
        end
        if _notified ~= tgt then
            _notified = tgt
            pcall(Visuals.notifyTarget, tgt)
        end
    end
    local function restoreHome(pin)
        local ch = lp.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return end
        local back = _preParkCF
        _preParkCF = nil
        pcall(function()
            if back then hrp.CFrame = back end
            if pin then
                local hu = ch:FindFirstChildOfClass("Humanoid")
                if hu and hu:GetState() == Enum.HumanoidStateType.Freefall
                   and hu.FloorMaterial ~= Enum.Material.Air then
                    hu:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end)
    end
    local function cameraAnchor()
        if Config.RageCameraAnchor == false then return end
        local back = _preParkCF
        if back == nil then return end
        local ch = lp.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return end
        local delta = back.Position - hrp.Position
        if not isSanePos(delta) then return end
        Camera.CFrame = Camera.CFrame + delta
    end
    local function reparkAfterRender()
        local cf = _lastPark
        if cf == nil then return end
        local ch = lp.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return end
        displace(hrp, cf)
    end
    Players.PlayerRemoving:Connect(function(p)
        _hackTag[p]   = nil
        _lastSeen[p]  = nil
        _hackAccum[p] = nil
        _predHidden[p] = nil
        _predDur[p]    = nil
        _predLast[p]   = nil
    end)
    function PolarCore.start()
        if _conn then return end
        _firing = false
        resetAttackContinuity()
        setPhysicsFlags(true)
        _notified = nil
        pcall(function() RunService:UnbindFromRenderStep(RENDER_NAME) end)
        pcall(function() RunService:UnbindFromRenderStep(CAMERA_NAME) end)
        RunService:BindToRenderStep(CAMERA_NAME, Enum.RenderPriority.Camera.Value + 5, function()
            pcall(cameraAnchor)
        end)
        RunService:BindToRenderStep(RENDER_NAME, Enum.RenderPriority.First.Value - 1000, function()
            if _firing and restoreMode() == "none" then return end
            restoreHome(false)
        end)
        _stepConn = RunService.Stepped:Connect(function()
            if _firing then
                local pol = restoreMode()
                if pol == "render" then return reparkAfterRender() end
                if pol ~= "kicia" then return end
            end
            restoreHome(true)
        end)
        _charConn = lp.CharacterAdded:Connect(function()
            pcall(glueTeardown)
            _glueHit = nil
            _gluePrevOk = false
            _glueDriven = false
            _liteHit = nil
            _liteDriven = false
            _translocateNext = false
            _translocateBurstPulses = 0
            _translocateFireFrames = 0
            _translocateHoldUntil, _translocateHoldCF = 0, nil
            _poisonFireFrames = 0
            _poisonBlips = 0
            _translocatePart = nil
            State.RageGlueBound = false
            State.RageTranslocating = false
            _realCF = nil
            _realChar = nil
            _voidCF = nil
            _target = nil
            _notified = nil
            _firing = false
            resetAttackContinuity()
            _preParkCF = nil
            _prevPark, _prevParkTgt = nil, nil
            _parkFailStreak = 0
            _lastPark = nil
            _hiding, _primeUntil = true, 0
        end)
        _conn = RunService.Heartbeat:Connect(function(dt)
            State.RageTranslocating = false
            tickHackers(dt or 0)
            tickPredict()
            if _glueHit ~= nil and not _glueDriven then
                pcall(glueRelease)
            end
            _glueDriven = false
            if _liteHit ~= nil and not _liteDriven then
                pcall(liteRelease)
            end
            _liteDriven = false
            State.RageGumMode = gumMode()
            if not Config.Rage or (Config.RageMode or "Polar") ~= "Polar" then
                PolarCore.stop()
                return
            end
            local ch  = lp.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if not hrp or not hrp.Parent then return end
            if _preParkCF == nil and isSanePos(hrp.Position) then
                _realCF   = hrp.CFrame
                _realChar = ch
            end
            if _lastPark ~= nil and _firing and restoreMode() == "none" then
                local ok, d, dy = pcall(function()
                    local off = hrp.Position - _lastPark.Position
                    return off.Magnitude, off.Y
                end)
                if ok and d == d and d > PARK_DRIFT_STUDS then
                    State.RageParkDriftFrames = (State.RageParkDriftFrames or 0) + 1
                    State.RageParkDrift = math.floor(d)
                    State.RageParkDriftY = math.floor(dy or 0)
                end
            end
            _inMatch = inMatch()
            State.RageInMatch = _inMatch
            if not _inMatch then
                _target = nil
                _firing = false
                resetAttackContinuity()
                _translocateNext = false
                _translocateBurstPulses = 0
                _translocateFireFrames = 0
                _translocateHoldUntil, _translocateHoldCF = 0, nil
                State.RageFiring = false
                State.RageTarget = nil
                State.RageStatus = "Lobby"
                if not isSanePos(hrp.Position) then restoreHome(false) end
                return
            end
            if not _realCF or _realChar ~= ch then
                _firing = false
                resetAttackContinuity()
                _translocateNext = false
                _translocateBurstPulses = 0
                _translocateFireFrames = 0
                _translocateHoldUntil, _translocateHoldCF = 0, nil
                State.RageFiring = false
                State.RageStatus = "Waiting"
                return
            end
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then
                _firing = false
                resetAttackContinuity()
                _translocateNext = false
                _translocateBurstPulses = 0
                _translocateFireFrames = 0
                _translocateHoldUntil, _translocateHoldCF = 0, nil
                State.RageFiring = false
                State.RageVoidActive = false
                State.RageStatus = "Dead"
                pcall(glueRelease)
                pcall(liteRelease)
                if not isSanePos(hrp.Position) then restoreHome(false) end
                return
            end
            polarTick(ch, hrp)
        end)
    end
    function PolarCore.stop()
        pcall(liteRelease)
        pcall(glueRelease)
        setPhysicsFlags(false)
        pcall(ViewAngle.restore)
        if _conn then _conn:Disconnect(); _conn = nil end
        if _stepConn then _stepConn:Disconnect(); _stepConn = nil end
        if _charConn then _charConn:Disconnect(); _charConn = nil end
        pcall(function() RunService:UnbindFromRenderStep(RENDER_NAME) end)
        pcall(function() RunService:UnbindFromRenderStep(CAMERA_NAME) end)
        _firing = false
        resetAttackContinuity()
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Parent then
            if _realCF and _realChar == lp.Character then
                pcall(function() hrp.CFrame = CFrame.new(_realCF.Position) * hrp.CFrame.Rotation end)
            elseif not isSanePos(hrp.Position) then
                pcall(function() hrp.CFrame = CFrame.new(0, 100, 0) end)
            end
        end
        _realCF = nil; _realChar = nil; _target = nil; _voidCF = nil; _notified = nil
        _translocateNext = false
        _translocateBurstPulses = 0
        _translocateFireFrames = 0
        _translocateHoldUntil, _translocateHoldCF = 0, nil
        _poisonFireFrames = 0
        _poisonBlips = 0
        _translocatePart = nil
        State.RageFiring = false
        State.RageVoidActive = false
        State.RageTranslocating = false
        State.RageTarget = nil
        State.RageInMatch = false
        State.RageStatus = "Idle"
    end
    PolarCore.shots     = function() return _shots end
    PolarCore.voidSteps = function() return _voidSteps end
    Rage._polarCoreStart = PolarCore.start
    Rage._polarCoreStop  = PolarCore.stop
    Rage._setPhysicsFlags = setPhysicsFlags
    function Rage._physDiag()
        local set, get, setName = fflagApi()
        print("[LuaHook] fflag api: setter=" .. setName .. "  getter=" .. tostring(get ~= nil))
        print("[LuaHook] flags:  " .. tostring(State.RagePhysDetail or "(never set — is rage on?)"))
        print("[LuaHook] summary: " .. tostring(State.RagePhysRate or "off")
              .. "   set=" .. tostring(_physSet) .. "  verified=" .. tostring(_physLive))
        print("[LuaHook] FPDH:   " .. tostring(State.RageFPDHPath)
              .. "   live=" .. tostring((select(2, pcall(function() return workspace.FallenPartsDestroyHeight end)))))
        print("[LuaHook] immune-hold overrides: " .. tostring(State.RageImmuneOverride or 0))
        print("[LuaHook] gum: mode=" .. tostring(gumMode())
              .. "  (RageGumMode=" .. tostring(Config.RageGumMode)
              .. ", legacy RageGlueMode=" .. tostring(Config.RageGlueMode)
              .. ", RagePartGlue=" .. tostring(Config.RagePartGlue)
              .. ", voidFire=" .. tostring(Config.RageGumVoidFire ~= false) .. ")"
              .. "  liteBound=" .. tostring(_liteHit ~= nil)
              .. "  BOUND=" .. tostring(State.RageGlueBound == true)
              .. "  readback=" .. tostring(State.RageGlueVerified or "n/a")
              .. "  (sethiddenproperty=" .. tostring(type(sethiddenproperty) == "function")
              .. ", gethiddenproperty=" .. tostring(type(gethiddenproperty) == "function")
              .. ", identity=" .. tostring(_identSet ~= nil) .. ")")
        local rvTxt = "unrolled"
        if _rvCF ~= nil then rvTxt = tostring(_rvCF.Position) end
        print("[LuaHook] rendezvous: " .. rvTxt
              .. "   glued to: " .. tostring(_glueHit or _liteHit)
              .. "   (full=" .. tostring(_glueHit ~= nil) .. ", lite=" .. tostring(_liteHit ~= nil) .. ")")
        print("[LuaHook] attack translocate: enabled=" .. tostring(Config.RageAttackTranslocate ~= false)
              .. "  active=" .. tostring(State.RageTranslocating == true)
              .. "  next=" .. tostring(_translocateNext)
              .. "  burst=" .. tostring(_translocateBurstPulses)
              .. "/" .. tostring(pulseBudget())
              .. "  part=" .. tostring(_translocatePart)
              .. "  lastGate=" .. tostring(_baitGateWhy))
        local capRemote, capObj = false, false
        pcall(function() capRemote = ReplicatedStorage.Remotes.Replication.Fighter.UseItem ~= nil end)
        pcall(function()
            local itC = getEquippedItem()
            capObj = itC ~= nil and itC:Get("ObjectID") ~= nil
        end)
        print("[LuaHook] fire refusals (S52): zeroFrames=" .. tostring(_fireZeroFrames)
              .. "   lastRefusal=" .. tostring(_fireWhy)
              .. "   capability check: remote=" .. tostring(capRemote)
              .. " objID=" .. tostring(capObj)
              .. "   (either false => thread identity poisoned, NOT a rage bug)")
        print("[LuaHook] capability (2026-08-28): identitySafe=" .. tostring(State.IdentitySafe)
              .. "  ammoUnreadable=" .. tostring(State.RageAmmoUnreadable or 0)
              .. "   identitySafe=false is CORRECT here, not a fault")
        print("[LuaHook] capability OBSERVER: armed=" .. tostring(State.CapabilityObserver == true)
              .. "  errors=" .. tostring(State.CapabilityErrors or 0)
              .. "  firstAt=" .. tostring(State.CapabilityKilledAt)
              .. "  lastAt=" .. tostring(State.CapabilityLastStatus)
              .. "  memoRecoveries=" .. tostring(State.CapabilityRecoveries or 0)
              .. "   (errors>0 while identitySafe=false => the emitter is NOT thread identity;"
              .. " see the CapabilityErrors note in 04_state for where to look next)")
        print("[LuaHook] bait dwell (S51): held=" .. tostring(Config.RageBaitHeldMs or 300) .. "ms"
              .. "  dipping=" .. tostring(_translocateHoldCF ~= nil)
              .. "  baits=" .. tostring(State.RageTranslocateBaits or 0)
              .. "  heldFrames=" .. tostring(State.RageBaitHoldFrames or 0)
              .. "  pinRefused=" .. tostring(State.RageBaitPinRefused or 0)
              .. "  ringFallbacks=" .. tostring(State.RageBaitRingFallbacks or 0))
        print("[LuaHook] restore mode: " .. restoreMode()
              .. "   (Config.RageRestoreMode=" .. tostring(Config.RageRestoreMode)
              .. ", glue forces kicia=" .. tostring(glueActive())
              .. ", fires from " .. tostring(restoreMode() == "kicia") .. "=prev-frame park)")
        print("[LuaHook] gum void prefire (S45): allowed=" .. tostring(Config.RageGumVoidFire ~= false
                  and gumMode() == "on")
              .. "   shots sent through a hide=" .. tostring(State.RageVoidFires or 0)
              .. "   (0 against a deep-voider means the seam never ran — check the gum mode above first)")
        return restoreMode()
    end
    Rage._polarForceBait = function()
        local rm = restoreMode()
        _baitRetryAt = 0
        local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        local dest = attackTranslocateCFrame(myHrp and myHrp.Position or Vector3.new(0, 0, 0))
        _translocateBurstPulses = 0
        _translocateFireFrames = TRANSLOCATE_ARM_FRAMES
        _translocateNext = true
        return string.format(
            "bait armed [toggle=%s transport=%s dest=%s held=%dms rate=%d lastGate=%s baits=%d refused=%d]",
            tostring(Config.RageAttackTranslocate ~= false),
            tostring(rm) .. (rm == "kicia" and " (kerp - OK)" or " (NEEDS kerp)"),
            dest ~= nil and tostring(dest.Position) or "nil (no survivable destination on this map)",
            math.max(0, math.min(1000, tonumber(Config.RageBaitHeldMs) or 300)),
            pulseBudget(),
            tostring(_baitGateWhy),
            State.RageTranslocateBaits or 0,
            State.RageBaitPinRefused or 0)
    end
    Rage._gumDiag = Rage._physDiag
end)()
local function silentPartVisible(part)
    if not part or not part:IsA("BasePart") then return false end
    if not Config.SilentAimMultipoint then return isVisible(part.Position) end
    if isVisible(part.Position) then return true end
    local n = math.max(1, math.floor(Config.SilentAimMultipointCount or 5))
    local r = math.min(part.Size.X, part.Size.Y, part.Size.Z) * 0.4
    for i = 1, n do
        local a   = (i / n) * math.pi * 2
        local off = Vector3.new(math.cos(a) * r, ((i % 2 == 0) and 0.5 or -0.5) * r, math.sin(a) * r)
        if isVisible(part.Position + off) then return true end
    end
    return false
end
local function pickSilentPart(char, primary)
    if not char then return primary end
    if silentPartVisible(primary) then return primary end
    for _, name in ipairs(HEAD_PARTS) do
        local p = char:FindFirstChild(name)
        if p and p ~= primary and silentPartVisible(p) then return p end
    end
    if Config.SilentAimTorsoFallback then
        for _, name in ipairs(TORSO_PARTS) do
            local p = char:FindFirstChild(name)
            if p and silentPartVisible(p) then return p end
        end
    end
    return primary
end
function hookGunModule()
    if not Rivals.Ready or not Rivals.Gun then return end
    if shared._LH_GunOrig then pcall(function() Rivals.Gun.StartShooting = shared._LH_GunOrig end) end
    if shared._LH_TracerOrig then pcall(function() Rivals.Gun._LocalTracers = shared._LH_TracerOrig end) end
    if shared._LH_ShootEffectOrig then pcall(function() Rivals.Gun._ShootEffect = shared._LH_ShootEffectOrig end) end
    if shared._LH_MeleeOrig and Rivals.Melee then
        pcall(function() Rivals.Melee.StartShooting = shared._LH_MeleeOrig end)
    end
    if shared._LH_KnifeOrig and Rivals.Knife then
        pcall(function() Rivals.Knife.StartAiming = shared._LH_KnifeOrig end)
    end
    shared._gunHooked = game
    local oldStart = Rivals.Gun.StartShooting
    shared._LH_GunOrig = oldStart
    local hookWrapper = function(self, ...)
        local suppress = (Config.Rage == true and Config.RageDirectFire == true)
        if not suppress and Config.Rage == true and State.RageTranslocating == true then suppress = true end
        if suppress then
            pcall(function()
                local cf = self.ClientFighter
                if cf and cf.IsLocalPlayer == false then suppress = false end
            end)
        end
        if suppress then return false end
        local results = { oldStart(self, ...) }
        pcall(function()
            if not self.ClientFighter or not self.ClientFighter.IsLocalPlayer then return end
            pcall(function()
                local wname = nil
                pcall(function() wname = self.Name end)
                if type(wname) ~= "string" then
                    local ci = self.ClientItem
                    pcall(function() wname = ci and ci.Name or nil end)
                end
                if type(wname) == "string" then
                    State.LastAttackWeapon = wname
                    State.LastAttackWeaponAt = tick()
                end
            end)
            local camData = results[3]
            if not camData or typeof(camData) ~= "table" then return end
            local camPos = Camera.CFrame.Position
            State.CamPos = camPos
            if Config.Rage then
                if Rage._encodeRageShot(camData) then results[4] = true end
                return
            end
            if Config.SilentAim then
                local tgt, part = selectTarget({
                    fov        = Config.SilentAimFOV,
                    checkVis   = Config.SilentAimVisCheck,
                    partMode   = Config.SilentAimTargetPart,
                    stickyTarget = State.SilentLastTarget,
                    stickyBonus  = Config.SilentAimStickiness or 0.05,
                })
                if tgt and part then
                    State.SilentLastTarget = tgt
                    Visuals.notifyTarget(tgt)
                    if math.random(1, 100) <= (Config.SilentAimHitChance or 100) then
                        local hitPart = pickSilentPart(tgt.Character, part)
                        if math.random(1, 100) <= (Config.SilentAimBodyMix or 0) then
                            local body = tgt.Character:FindFirstChild("HitboxBody")
                            if body and silentPartVisible(body.Position) then hitPart = body end
                        end
                        local jit = Vector3.zero
                        local jd = Config.SilentAimJitterDeg or 0
                        if jd > 0 then
                            local dir = jit
                            local okD, unit = pcall(function()
                                return Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5)
                            end)
                            if okD and unit.Magnitude > 1e-4 then dir = unit.Unit end
                            local dist = 0
                            pcall(function() dist = (hitPart.Position - camPos).Magnitude end)
                            local off = math.min(math.tan(math.rad(jd)) * dist, 3) * (math.random() * 0.5)
                            jit = dir * off
                        end
                        if Rage._encodeShot(camData, hitPart, tgt.Character, camPos, jit) then
                            results[4] = true
                            State.Shots = State.Shots + 1
                            State.Hits  = State.Hits  + 1
                        end
                    end
                    return
                end
            end
            if Config.Aimbot and Config.AimbotShotOverride
                and State.AimbotTarget and State.AimbotPart and State.AimbotKeyHeld then
                local tgt = State.AimbotTarget
                if tgt and tgt.Character and isValidTarget(tgt, false) then
                    Visuals.notifyTarget(tgt)
                    if Rage._encodeShot(camData, State.AimbotPart, tgt.Character, camPos) then
                        results[4] = true
                        State.Shots = State.Shots + 1
                        State.Hits  = State.Hits  + 1
                    end
                end
            end
            if Config.HUD or Config.VisualsHolograms then
                local rp = RaycastParams.new()
                rp.FilterType = Enum.RaycastFilterType.Exclude
                rp.FilterDescendantsInstances = { lp.Character }
                local res = workspace:Raycast(camPos, Camera.CFrame.LookVector * (Config.MaxDistance or 1000), rp)
                if res and res.Instance then
                    local m  = res.Instance:FindFirstAncestorOfClass("Model")
                    local pl = m and Players:GetPlayerFromCharacter(m)
                    if pl and pl ~= lp then Visuals.notifyTarget(pl) end
                end
            end
        end)
        return unpack(results)
    end
    if setfenv then pcall(setfenv, hookWrapper, getfenv(oldStart)) end
    if setreadonly then pcall(setreadonly, Rivals.Gun, false) end
    Rivals.Gun.StartShooting = hookWrapper
    local oldLocalTracers = Rivals.Gun._LocalTracers
    if type(oldLocalTracers) == "function" then
        shared._LH_TracerOrig = oldLocalTracers
        Rivals.Gun._LocalTracers = function(selfItem, ...)
            if Config.Rage == true and Config.RageDirectFire == true then
                State.RageTracerCanary = (State.RageTracerCanary or 0) + 1
                return
            end
            return oldLocalTracers(selfItem, ...)
        end
    end
    local function wrapMeleeAttack(cls, method, saveKey)
        if type(cls) ~= "table" then return end
        local orig = rawget(cls, method)
        if type(orig) ~= "function" then return end
        shared[saveKey] = shared[saveKey] or orig
        if setreadonly then pcall(setreadonly, cls, false) end
        cls[method] = function(selfItem, ...)
            local results = { orig(selfItem, ...) }
            pcall(function()
                if not selfItem.ClientFighter or not selfItem.ClientFighter.IsLocalPlayer then return end
                pcall(function()
                    local wname = nil
                    pcall(function() wname = selfItem.Name end)
                    if type(wname) ~= "string" then
                        local ci = selfItem.ClientItem
                        pcall(function() wname = ci and ci.Name or nil end)
                    end
                    if type(wname) == "string" then
                    State.LastAttackWeapon = wname
                    State.LastAttackWeaponAt = tick()
                end
                end)
                if not Config.Rage then return end
                local camData = results[3]
                if typeof(camData) ~= "table" then return end
                Rage._encodeRageShot(camData)
            end)
            return unpack(results)
        end
    end
    wrapMeleeAttack(Rivals.Melee, "StartShooting", "_LH_MeleeOrig")
    wrapMeleeAttack(Rivals.Knife, "StartAiming",  "_LH_KnifeOrig")
    local oldShootEffect = Rivals.Gun._ShootEffect
    if type(oldShootEffect) == "function" then
        shared._LH_ShootEffectOrig = oldShootEffect
        Rivals.Gun._ShootEffect = function(selfItem, results, ...)
            pcall(function()
                if Config.Rage ~= true or Config.RageDirectFire ~= true then return end
                if type(results) ~= "table" then return end
                local cf = selfItem.ClientFighter
                if not cf or not cf.IsLocalPlayer then return end
                local tgt = State.RageTarget
                local tchar = tgt and tgt.Character
                local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                for _, entry in results do
                    local hitPart = entry[utf8.char(1)]
                    local hitPos  = entry[utf8.char(0)]
                    local onTarget = false
                    if hitPart and tchar and hitPart:IsDescendantOf(tchar) then onTarget = true end
                    if onTarget then
                        State.RageHitsOn = (State.RageHitsOn or 0) + 1
                    else
                        State.RageHitsOff = (State.RageHitsOff or 0) + 1
                        if typeof(hitPos) == "Vector3" then
                            if myRoot then
                                State.RageOffFromSelf = (hitPos - myRoot.Position).Magnitude
                            end
                            local th = tchar and (tchar:FindFirstChild("HitboxHead") or tchar:FindFirstChild("Head"))
                            if th then
                                State.RageOffFromTarget = (hitPos - th.Position).Magnitude
                            end
                        end
                    end
                end
            end)
            return oldShootEffect(selfItem, results, ...)
        end
    end
end
hookGunModule()
ViewAngle = {}
;(function()
    local _remote     = nil
    local _forged     = nil
    local _loopFn, _utilIdx, _utilOrig = nil, nil, nil
    local _suppressed = false
    local _joints, _jointsOrig = nil, nil
    local function remote()
        if _remote == nil then
            pcall(function()
                _remote = ReplicatedStorage.Remotes.Replication.Fighter.UpdateCameraRotation
            end)
        end
        return _remote
    end
    local function resolveLoop()
        if _loopFn ~= nil then return true end
        if shared._LH_ViewLoopFn ~= nil and shared._LH_ViewUtilOrig ~= nil then
            _loopFn   = shared._LH_ViewLoopFn
            _utilIdx  = shared._LH_ViewUtilIdx
            _utilOrig = shared._LH_ViewUtilOrig
            return true
        end
        if type(debug) ~= "table" or type(debug.getupvalues) ~= "function"
           or type(debug.setupvalue) ~= "function" then
            return false
        end
        pcall(function()
            local F = Rivals.Fighter
            if F == nil then return end
            local fn = rawget(F, "_CameraReplicationLoop")
            if type(fn) ~= "function" then
                local mt = getmetatable(F)
                local proto = mt and rawget(mt, "__index")
                if type(proto) == "table" then fn = rawget(proto, "_CameraReplicationLoop") end
            end
            if type(fn) ~= "function" then return end
            for i, v in debug.getupvalues(fn) do
                if type(v) == "table" then
                    local vmt = getmetatable(v)
                    local vidx = vmt and rawget(vmt, "__index")
                    if type(vidx) == "table" and rawget(vidx, "EncodeCameraRotation") ~= nil then
                        _loopFn, _utilIdx, _utilOrig = fn, i, v
                        shared._LH_ViewLoopFn   = fn
                        shared._LH_ViewUtilIdx  = i
                        shared._LH_ViewUtilOrig = v
                        return
                    end
                end
            end
        end)
        return _loopFn ~= nil
    end
    local function makeShim()
        local shim = {}
        shim.EncodeCameraRotation = function(_, rot)
            local last = nil
            pcall(function()
                local F = Rivals.Fighter
                if F ~= nil then
                    F._replication_stopped = false
                    last = F._last_encoded_camera_rotation
                end
            end)
            if last ~= nil then return last end
            return _utilOrig:EncodeCameraRotation(rot)
        end
        return setmetatable(shim, { __index = _utilOrig })
    end
    local function suppress(on)
        if on == _suppressed then return end
        if on then
            if not resolveLoop() then return end
            State.CapabilitySeam = "08c viewangle debug.setupvalue"
            if pcall(debug.setupvalue, _loopFn, _utilIdx, makeShim()) then
                _suppressed = true
                State.ViewAngleForged = true
            end
            return
        end
        if _loopFn ~= nil and _utilOrig ~= nil then
            pcall(debug.setupvalue, _loopFn, _utilIdx, _utilOrig)
        end
        _suppressed = false
        State.ViewAngleForged = false
    end
    local function patchJoints(on)
        if on then
            if _jointsOrig ~= nil then return end
            pcall(function()
                _joints = loadGameModule(lp.PlayerScripts,
                    {"Modules", "ClientReplicatedClasses", "ClientFighter", "ClientFighterCharacter", "Joints"})
                if type(_joints) ~= "table" then
                    _joints = nil
                    return
                end
                local orig = shared._LH_JointsUpdateOrig or rawget(_joints, "Update")
                if type(orig) ~= "function" then
                    _joints = nil
                    return
                end
                shared._LH_JointsUpdateOrig = orig
                _jointsOrig = orig
                if setreadonly then pcall(setreadonly, _joints, false) end
                _joints.Update = function(selfJoints, dt, data)
                    if _forged ~= nil and type(data) == "table" then
                        pcall(function()
                            local cfc = selfJoints.ClientFighterCharacter
                            local cf = cfc and cfc.ClientFighter
                            if cf and cf.IsLocalPlayer == true then
                                data.CameraRotationRaw = _forged
                            end
                        end)
                    end
                    return orig(selfJoints, dt, data)
                end
            end)
            return
        end
        if _joints ~= nil and _jointsOrig ~= nil then
            pcall(function()
                if setreadonly then pcall(setreadonly, _joints, false) end
                _joints.Update = _jointsOrig
            end)
        end
        _jointsOrig = nil
    end
    function ViewAngle.forge(pitch, yaw)
        local r = remote()
        if r == nil or not Rivals.Util then return false end
        local ok = pcall(function()
            local enc = Rivals.Util:EncodeCameraRotation(Vector2.new(pitch, yaw))
            _forged = Rivals.Util:DecodeCameraRotation(enc)
            r:FireServer(enc, nil)
        end)
        if not ok then return false end
        suppress(true)
        patchJoints(true)
        return true
    end
    function ViewAngle.restore()
        _forged = nil
        suppress(false)
        patchJoints(false)
    end
    ViewAngle.isForging = function() return _forged ~= nil end
end)()
local Aimbot = {}
;(function()
    local TAU = math.pi * 2
    local D2R = math.pi / 180
    local R2D = 180 / math.pi
    local MAX_TAU     = 0.30
    local RETAIN_MUL  = 1.6
    local STICKY_MEM  = 2.0
    local FF_TAU      = 0.05
    local FF_MAX      = 12
    local UNIT_MAX    = 2000
    local RAMP_TIME   = 0.15
    local PITCH_LIMIT = 1.5690509975429023
    local CAL_MIN     = 1.5
    local CAL_FAST_N  = 8
    local BAND_LO     = 0.05
    local BAND_HI     = 6.0
    local OSC_ERR     = 0.02
    local RUNAWAY_ERR = 1.0
    local SEED_MX     = -0.008726646259971648
    local SEED_MY     = -0.006719517620178168
    local SEED_DX     = 1.0
    local SEED_DY     = 1.0
    local _bound       = false
    local _mouseMove   = mousemoverel
    local _fovC, _lockC, _dbgT = nil, nil, nil
    local _tgt, _part  = nil, nil
    local _prevTgt     = nil
    local _notified    = nil
    local _acquireAt   = 0
    local _lastSeenAt  = 0
    local _ramp        = 0
    local _gx, _gy     = SEED_MX, SEED_MY
    local _sdx, _sdy   = SEED_MX, SEED_MY
    local _nx, _ny     = 0, 0
    local _sx, _sy     = 0, 0
    local _fx, _fy     = 0, 0
    local _lyaw, _lpit = 0, 0
    local _haveCam     = false
    local _ffy, _ffp   = 0, 0
    local _lty, _ltp   = 0, 0
    local _haveTgt     = false
    local _lastPartRef = nil
    local _flickActive   = false
    local _flickT        = 0
    local _flickDur      = 0.15
    local _flickCtrl1Y   = 0
    local _flickCtrl1P   = 0
    local _flickCtrl2Y   = 0
    local _flickCtrl2P   = 0
    local _auth        = 1.0
    local _flips       = 0
    local _errEma      = 0
    local _lastSign    = nil
    local _drive       = 0
    local _trips       = 0
    local _calOff      = false
    local _lastFOV     = 0
    local _errDeg      = 0
    local _path        = "none"
    local _ctl, _ctlTried = nil, false
    local function wrapPi(a)
        return (a + math.pi) % TAU - math.pi
    end
    local function yawOf(v)
        return math.atan2(-v.X, -v.Z)
    end
    local function pitchOf(v)
        return math.asin(math.clamp(v.Y, -1, 1))
    end
    local function angTo(cf, pos)
        local d = pos - cf.Position
        local m = d.Magnitude
        if m < 1e-4 then return 0 end
        return math.acos(math.clamp(cf.LookVector:Dot(d) / m, -1, 1))
    end
    local function fovPixels(deg)
        local vp = Camera.ViewportSize
        local lim = math.max(vp.X, vp.Y)
        if deg >= 89 then return lim end
        local half = math.tan(math.rad(Camera.FieldOfView) * 0.5)
        if half <= 0 then return lim end
        return math.clamp(math.tan(deg * D2R) / half * (vp.Y * 0.5), 4, lim)
    end
    local function minJerk(s)
        s = math.clamp(s, 0, 1)
        return s * s * s * (10 + s * (-15 + 6 * s))
    end
    local function bezier(p0, p1, p2, p3, t)
        local it = 1 - t
        return it * it * it * p0 + 3 * it * it * t * p1 + 3 * it * t * t * p2 + t * t * t * p3
    end
    local function validFor(pl)
        if not isValidTarget(pl, false) then return false end
        if Config.AimbotSkipImmune and isSpawnProtected(pl) then return false end
        return true
    end
    local function firstVisible(char, list, skip)
        for _, n in ipairs(list) do
            local p = char:FindFirstChild(n)
            if p and p ~= skip and p:IsA("BasePart") and isVisible(p.Position) then return p end
        end
        return nil
    end
    local function resolveBest(char, primary)
        if not char then return primary end
        if primary and isVisible(primary.Position) then return primary end
        return firstVisible(char, HEAD_PARTS, primary)
            or firstVisible(char, TORSO_PARTS, primary)
            or primary
    end
    local function acquire(cf, fovR, retainR, cur)
        local mode = Config.AimbotTargetPart or "Best"
        local pick = (mode == "Best") and "Head" or mode
        local prio = Config.AimbotPriority or "Crosshair"
        local vis  = Config.AimbotVisCheck
        local myRoot = nil
        if prio == "Distance" then
            local mc = lp.Character
            myRoot = mc and mc:FindFirstChild("HumanoidRootPart")
        end
        local bP, bPart, bAng, bScore = nil, nil, math.huge, math.huge
        local cPart, cAng, cOK = nil, math.huge, false
        for _, pl in ipairs(getSafePlayers()) do
            if pl ~= lp and validFor(pl) then
                local char = pl.Character
                local part = pickPart(char, pick)
                if part then
                    local ang    = angTo(cf, part.Position)
                    local isCur  = (pl == cur)
                    if ang <= (isCur and retainR or fovR) then
                        local hasVis = (not vis) or isVisible(part.Position)
                        if hasVis then
                            local score = ang
                            if prio == "Health" then
                                local hp = getHealth(pl)
                                score = hp * 100 + ang
                            elseif prio == "Distance" and myRoot then
                                score = (part.Position - myRoot.Position).Magnitude * 100 + ang
                            end
                            if isCur then
                                cPart, cAng, cOK = part, ang, true
                                score = score * (1 - (Config.AimbotStickiness or 0))
                            end
                            if score < bScore then bScore, bP, bPart, bAng = score, pl, part, ang end
                        end
                    end
                end
            end
        end
        if prio == "Crosshair" and cOK and bP and bP ~= cur then
            if bAng > cAng - (Config.AimbotSwitchDeg or 0) * D2R then
                return cur, cPart, cAng
            end
        end
        return bP, bPart, bAng
    end
    local function ensureDraw()
        pcall(function()
            if not _fovC then
                local c = screenDraw("Circle")
                if c then
                    c.Thickness = 1; c.NumSides = 64
                    c.Color = Color3.fromRGB(180, 180, 180)
                    c.Transparency = 0.6; c.Filled = false; c.Visible = false
                    _fovC = c
                end
            end
            if not _lockC then
                local c = screenDraw("Circle")
                if c then
                    c.Thickness = 2; c.NumSides = 32
                    c.Color = Color3.fromRGB(255, 80, 100)
                    c.Transparency = 0.9; c.Filled = false; c.Radius = 6; c.Visible = false
                    _lockC = c
                end
            end
            if not _dbgT then
                local t = screenDraw("Text")
                if t then
                    t.Font = 3; t.Size = 13; t.Outline = true
                    t.Color = Color3.fromRGB(0, 230, 160)
                    t.Position = Vector2.new(14, 330); t.Visible = false
                    _dbgT = t
                end
            end
        end)
    end
    local function diagText()
        return string.format(
            "AIMBOT [MATH V2]  path=%s%s\ngain  x=%.6f (n%d)   y=%.6f (n%d)\nerr %.2f deg   sent %d,%d   auth %.2f   trips %d\ntarget %s",
            _path, _calOff and "  [gain PINNED]" or "",
            _gx, _nx, _gy, _ny, _errDeg, _sx, _sy, _auth, _trips,
            _tgt and _tgt.Name or "-")
    end
    local function updateDraw()
        local wantFov  = Config.Aimbot and Config.AimbotShowFOV
        local wantLock = Config.Aimbot and Config.AimbotShowLock and _part
        local wantDbg  = Config.Aimbot and Config.AimbotDebug
        if not (wantFov or wantLock or wantDbg) then
            if _fovC  and _fovC.Visible  then _fovC.Visible  = false end
            if _lockC and _lockC.Visible then _lockC.Visible = false end
            if _dbgT  and _dbgT.Visible  then _dbgT.Visible  = false end
            return
        end
        ensureDraw()
        if _fovC then
            if wantFov then
                local vp = Camera.ViewportSize
                _fovC.Position = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
                _fovC.Radius   = fovPixels(Config.AimbotFOVDeg or 20)
                _fovC.Visible  = true
            else
                _fovC.Visible = false
            end
        end
        if _lockC then
            local on = false
            if wantLock then
                local sp, vis = Camera:WorldToViewportPoint(_part.Position)
                if vis and sp.Z > 0 then
                    _lockC.Position = Vector2.new(sp.X, sp.Y)
                    on = true
                end
            end
            _lockC.Visible = on
        end
        if _dbgT then
            if wantDbg then
                _dbgT.Text = diagText(); _dbgT.Visible = true
            else
                _dbgT.Visible = false
            end
        end
    end
    local function resolvePath()
        local uis = UserInputService or game:GetService("UserInputService")
        local touchOnly = uis.TouchEnabled and not uis.MouseEnabled
        if _mouseMove and not touchOnly then return "mouse" end
        if Config.AimbotDirectCamera or touchOnly then
            if not _ctlTried then
                _ctlTried = true
                task.spawn(function()
                    local ok, m = pcall(loadGameModule, lp.PlayerScripts, { "Controllers", "CameraController" })
                    if ok and type(m) == "table" and typeof(m.Rotation) == "Vector2"
                       and type(m.ApplyRotationDelta) == "function" then
                        _ctl = m
                        _gx, _gy   = SEED_DX, SEED_DY
                        _sdx, _sdy = SEED_DX, SEED_DY
                        _nx, _ny   = 0, 0
                    end
                end)
            end
            if _ctl then return "direct" end
        end
        return "none"
    end
    local function getSpringOffset()
        if not Config.AimbotCancelSprings then return 0, 0 end
        if _ctl then
            local s = rawget(_ctl, "_aim_spring") or rawget(_ctl, "_camera_rotation_spring")
            if s and typeof(s.Position) == "Vector2" then
                return s.Position.Y, s.Position.X
            elseif s and typeof(s.Position) == "Vector3" then
                return s.Position.X, s.Position.Y
            end
        end
        return 0, 0
    end
    local function quant(v, frac)
        local w = v + frac
        local n = (w >= 0) and math.floor(w + 0.5) or math.ceil(w - 0.5)
        return n, w - n
    end
    local function emit(ux, uy)
        if _path == "mouse" then
            pcall(_mouseMove, ux, uy)
        elseif _path == "direct" and _ctl then
            pcall(function() _ctl:ApplyRotationDelta(Vector2.new(uy, ux)) end)
        end
    end
    local function calibrate(obs, sent, gain, n, seed)
        if math.abs(sent) < CAL_MIN then return gain, n end
        local s = obs / sent
        if (s * seed) <= 0 then return gain, n end
        local a  = math.abs(s)
        local lo = math.abs(seed) * BAND_LO
        local hi = math.abs(seed) * BAND_HI
        if a < lo or a > hi then return gain, n end
        if n < CAL_FAST_N then return s, n + 1 end
        local r = math.abs(s / gain)
        if r < 0.34 or r > 3.0 then return gain, n end
        return gain + (s - gain) * 0.05, n + 1
    end
    local function clearTarget()
        _tgt, _part  = nil, nil
        _prevTgt     = nil
        _notified    = nil
        _haveTgt     = false
        _lastPartRef = nil
        _ffy, _ffp   = 0, 0
        _errDeg      = 0
        _flips, _errEma, _lastSign, _drive = 0, 0, nil, 0
        _flickActive = false
        State.AimbotTarget      = nil
        State.AimbotPart        = nil
        State.AimbotFlickActive = false
    end
    local function step(dt)
        dt = math.clamp(dt or (1 / 60), 1 / 1000, 0.1)
        local cf     = Camera.CFrame
        local look   = cf.LookVector
        local curYaw, curPit = yawOf(look), pitchOf(look)
        if _haveCam and not _calOff then
            _gx, _nx = calibrate(wrapPi(curYaw - _lyaw), _sx, _gx, _nx, _sdx)
            _gy, _ny = calibrate(curPit - _lpit,         _sy, _gy, _ny, _sdy)
        end
        _lyaw, _lpit, _haveCam = curYaw, curPit, true
        local fov = Camera.FieldOfView
        if math.abs(fov - _lastFOV) > 0.5 then
            _lastFOV = fov
            _nx, _ny = 0, 0
        end
        _sx, _sy = 0, 0
        updateDraw()
        if not Config.Aimbot then
            State.AimbotKeyHeld = false
            clearTarget()
            return
        end
        if State.RageFiring then clearTarget(); return end
        if not inMatch() then
            State.AimbotKeyHeld = false
            clearTarget()
            return
        end
        local keyDown = aimbotKeyDown()
        State.AimbotKeyHeld = keyDown
        if not keyDown then
            clearTarget()
            return
        end
        _path = resolvePath()
        if _path == "none" then clearTarget(); return end
        local fovR    = math.clamp(Config.AimbotFOVDeg or 20, 0.1, 180) * D2R
        local retainR = math.min(fovR * RETAIN_MUL, math.pi)
        local sticky  = _tgt
        if not sticky then
            local last = State.AimbotLastTarget
            if last and (tick() - (State.AimbotLastTargetTime or 0)) <= STICKY_MEM then sticky = last end
        end
        local tgt, part = acquire(cf, fovR, retainR, sticky)
        local now = tick()
        if tgt and part then
            _lastSeenAt = now
        else
            local forget = Config.AimbotForgetTime or 0.2
            if _tgt and (now - _lastSeenAt) <= forget then
                tgt, part = _tgt, _part
            else
                clearTarget()
                return
            end
        end
        if (Config.AimbotTargetPart or "Best") == "Best" then
            part = resolveBest(tgt.Character, part) or part
        end
        if tgt ~= _prevTgt then
            _acquireAt   = now
            _ramp        = 0
            _haveTgt     = false
            _ffy, _ffp   = 0, 0
            _prevTgt     = tgt
            _flickActive = false
        end
        _tgt, _part = tgt, part
        State.AimbotTarget         = tgt
        State.AimbotPart           = part
        State.AimbotLastTarget     = tgt
        State.AimbotLastTargetTime = now
        if _notified ~= tgt then
            _notified = tgt
            pcall(Visuals.notifyTarget, tgt)
        end
        local targetPos = part.Position
        local targetChar = tgt.Character
        local targetRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        local targetVel = targetRP and targetRP.AssemblyLinearVelocity or Vector3.zero
        local myChar = lp.Character
        local myRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myVel = myRP and myRP.AssemblyLinearVelocity or Vector3.zero
        local vRel = targetVel - myVel
        if Config.AimbotPrediction then
            local lead = calculateLead(targetChar, cf.Position, true)
            targetPos = targetPos + lead
            local hum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
            if hum and hum.FloorMaterial == Enum.Material.Air then
                local dist = (targetPos - cf.Position).Magnitude
                local leadTime = math.clamp(dist / 1000, 0, 0.5)
                targetPos = targetPos + Vector3.new(0, 0.5 * -196.2 * leadTime * leadTime, 0)
            end
        end
        local d = targetPos - cf.Position
        local dDist = d.Magnitude
        if dDist < 1e-3 then return end
        local u = d / dDist
        local tYaw = yawOf(u)
        local tPit = math.clamp(pitchOf(u), -PITCH_LIMIT, PITCH_LIMIT)
        local errYaw = wrapPi(tYaw - curYaw)
        local errPit = tPit - curPit
        _errDeg = math.sqrt(errYaw * errYaw + errPit * errPit) * R2D
        local dH2 = d.X * d.X + d.Z * d.Z
        if _haveTgt and part == _lastPartRef and dH2 > 1e-4 then
            local vDotU = vRel:Dot(u)
            local dH = math.sqrt(dH2)
            local rawFFY = (d.Z * vRel.X - d.X * vRel.Z) / dH2
            local rawFFP = (vRel.Y - vDotU * u.Y) / dH
            local k = math.clamp(dt / FF_TAU, 0, 1)
            _ffy = _ffy + (math.clamp(rawFFY, -FF_MAX, FF_MAX) - _ffy) * k
            _ffp = _ffp + (math.clamp(rawFFP, -FF_MAX, FF_MAX) - _ffp) * k
        else
            _ffy, _ffp = 0, 0
        end
        _lty, _ltp, _haveTgt, _lastPartRef = tYaw, tPit, true, part
        if (Config.AimbotReactionMs or 0) > 0
           and (now - _acquireAt) * 1000 < Config.AimbotReactionMs then return end
        if (Config.AimbotDeadzoneDeg or 0) > 0 then
            local m = math.sqrt(errYaw * errYaw + errPit * errPit)
            if m < Config.AimbotDeadzoneDeg * D2R then return end
        end
        local smoothX = Config.AimbotLinkAxes and (Config.AimbotSmoothness or 0) or (Config.AimbotSmoothnessX or Config.AimbotSmoothness or 0)
        local smoothY = Config.AimbotLinkAxes and (Config.AimbotSmoothness or 0) or (Config.AimbotSmoothnessY or Config.AimbotSmoothness or 0)
        smoothX = math.clamp(smoothX, 0, 100)
        smoothY = math.clamp(smoothY, 0, 100)
        local isHardLock = (smoothX == 0 and smoothY == 0)
        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
        local isAirborne = (targetHum and targetHum.FloorMaterial == Enum.Material.Air) or math.abs(targetVel.Y) > 5
        if isAirborne and (Config.AimbotJumpDamping or 0) > 0 and smoothY > 0 then
            local jDamp = (Config.AimbotJumpDamping / 100)
            local vyFrac = math.clamp(math.abs(targetVel.Y) / 60, 0, 1)
            smoothY = math.clamp(smoothY + (100 - smoothY) * vyFrac * jDamp, 0, 100)
        end
        local aErr = math.sqrt(errYaw * errYaw + errPit * errPit)
        _errEma = _errEma + (aErr - _errEma) * math.clamp(dt / 0.15, 0, 1)
        _drive  = _drive + dt
        local sPos = (errYaw >= 0)
        if _lastSign ~= nil and sPos ~= _lastSign then _flips = _flips + 1 end
        _lastSign = sPos
        _flips = _flips * math.exp(-dt / 0.25)
        if _flips >= 4 and _errEma > OSC_ERR and not isHardLock then
            _auth  = math.max(0.15, _auth * 0.5)
            _flips = 0
        else
            _auth = math.min(1, _auth + dt * 0.3)
        end
        local avgSmooth = (smoothX + smoothY) * 0.5
        if _errEma > RUNAWAY_ERR and _drive > (0.15 + (avgSmooth / 100) * MAX_TAU * 3) and not isHardLock then
            _auth    = math.max(0.08, _auth * 0.5)
            _gx, _gy = _sdx, _sdy
            _nx, _ny = 0, 0
            _drive   = 0
            _trips   = _trips + 1
            if _trips >= 2 then _calOff = true end
        end
        local alphaX = 1
        if smoothX > 0 then
            alphaX = (1 - math.exp(-dt / ((smoothX / 100) * MAX_TAU))) * _auth
        end
        local alphaY = 1
        if smoothY > 0 then
            alphaY = (1 - math.exp(-dt / ((smoothY / 100) * MAX_TAU))) * _auth
        end
        local cy = errYaw * alphaX
        local cp = errPit * alphaY
        if Config.AimbotCurvedFlick and _errDeg > 3.0 and not isHardLock then
            if not _flickActive then
                _flickActive = true
                _flickT = 0
                _flickDur = math.clamp((_errDeg / 90) * 0.22 + 0.08, 0.08, 0.35)
                local intensity = (Config.AimbotCurvedIntensity or 0.35) * (_errDeg * D2R)
                local normY, normP = -errPit / (aErr + 1e-4), errYaw / (aErr + 1e-4)
                local curveSign = ((math.floor(now * 10) % 2 == 0) and 1 or -1)
                _flickCtrl1Y = normY * intensity * curveSign
                _flickCtrl1P = normP * intensity * curveSign
                _flickCtrl2Y = normY * (intensity * 0.7) * curveSign
                _flickCtrl2P = normP * (intensity * 0.7) * curveSign
            end
            _flickT = math.min(_flickDur, _flickT + dt)
            local prog = _flickT / _flickDur
            local sJerk = minJerk(prog)
            local p1Y = errYaw * 0.33 + _flickCtrl1Y
            local p1P = errPit * 0.33 + _flickCtrl1P
            local p2Y = errYaw * 0.66 + _flickCtrl2Y
            local p2P = errPit * 0.66 + _flickCtrl2P
            local targetCurveY = bezier(0, p1Y, p2Y, errYaw, sJerk)
            local targetCurveP = bezier(0, p1P, p2P, errPit, sJerk)
            cy = targetCurveY * alphaX
            cp = targetCurveP * alphaY
            if prog >= 1.0 or _errDeg < 1.0 then
                _flickActive = false
            end
        else
            _flickActive = false
        end
        State.AimbotFlickActive = _flickActive
        if not isHardLock then
            local spPit, spYaw = getSpringOffset()
            cy = cy - (spYaw * alphaX)
            cp = cp - (spPit * alphaY)
        end
        local os = Config.AimbotOvershoot or 0
        if os > 0 and not isHardLock then
            _ramp = math.min(1, _ramp + dt / RAMP_TIME)
            local k = 1 + math.sin(_ramp * math.pi) * os
            cy, cp = cy * k, cp * k
        end
        local ff = (Config.AimbotTrackAssist or 100) / 100
        if ff > 0 and not isHardLock then
            cy = cy + _ffy * dt * ff
            cp = cp + _ffp * dt * ff
        end
        local nz = Config.AimbotNoiseDeg or 0
        if nz > 0 then
            local n = nz * D2R * dt
            cy = cy + (math.random() - 0.5) * 2 * n
            cp = cp + (math.random() - 0.5) * 2 * n
        end
        local cap = Config.AimbotMaxSpeed or 0
        if cap > 0 then
            local m = math.sqrt(cy * cy + cp * cp)
            local lim = cap * D2R * dt
            if m > lim then local k = lim / m; cy, cp = cy * k, cp * k end
        end
        cp = math.clamp(curPit + cp, -PITCH_LIMIT, PITCH_LIMIT) - curPit
        if _gx == 0 or _gy == 0 then return end
        local ux, uy = cy / _gx, cp / _gy
        local um = math.max(math.abs(ux), math.abs(uy))
        if um > UNIT_MAX then local k = UNIT_MAX / um; ux, uy = ux * k, uy * k end
        if _path == "mouse" then
            ux, _fx = quant(ux, _fx)
            uy, _fy = quant(uy, _fy)
        else
            _fx, _fy = 0, 0
        end
        if ux == 0 and uy == 0 then return end
        emit(ux, uy)
        _sx, _sy = ux, uy
    end
    function Aimbot.enable()
        Config.Aimbot = true
        if _bound then return end
        RunService:BindToRenderStep("LuaHook_Aimbot", Enum.RenderPriority.Camera.Value + 1, function(dt)
            pcall(step, dt)
        end)
        _bound = true
    end
    function Aimbot.disable()
        Config.Aimbot = false
        State.AimbotKeyHeld = false
        clearTarget()
        _sx, _sy, _fx, _fy = 0, 0, 0, 0
        _haveCam, _ramp, _notified = false, 0, nil
        _auth = 1.0
        if _bound then
            pcall(function() RunService:UnbindFromRenderStep("LuaHook_Aimbot") end)
            _bound = false
        end
        if _fovC  then _fovC.Visible  = false end
        if _lockC then _lockC.Visible = false end
        if _dbgT  then _dbgT.Visible  = false end
    end
    function Aimbot.init()
        if Config.Aimbot then Aimbot.enable() end
    end
    function Aimbot.unload()
        Aimbot.disable()
        if shared._LH_velConn then
            pcall(function() shared._LH_velConn:Disconnect() end)
            shared._LH_velConn = nil
        end
        if _fovC  then pcall(function() _fovC:Remove()  end); _fovC  = nil end
        if _lockC then pcall(function() _lockC:Remove() end); _lockC = nil end
        if _dbgT  then pcall(function() _dbgT:Remove()  end); _dbgT  = nil end
    end
    function Aimbot.hasMouseMove() return _mouseMove ~= nil end
    function Aimbot._diag() return diagText() end
end)()
local Trigger = {}
do
    local _bound    = false
    local _lastFire = 0
    local _onTgtAt  = 0
    local _lastChar = nil
    local trigParams = RaycastParams.new()
    trigParams.FilterType = Enum.RaycastFilterType.Exclude
    local _filterChar = nil
    local function isHeadHit(part)
        if not part then return false end
        local n = part.Name
        for _, h in ipairs(HEAD_PARTS) do
            if n == h then return true end
        end
        return false
    end
    local function fullyScoped()
        local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
        local it = lf and lf.EquippedItem
        if not it then return true end
        local cur, pct = nil, nil
        pcall(function() cur = it.ViewModel.CurrentAimValue end)
        pcall(function() pct = it.Info.AimScopePercent end)
        if type(cur) == "number" then
            if type(pct) == "number" then return cur >= pct end
            return cur >= 1
        end
        local aiming
        pcall(function() aiming = it:Get("IsAiming") end)
        if aiming == nil then return true end
        return aiming == true
    end
    local function askToShoot()
        local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
        if not lf then return end
        task.spawn(function()
            if pcall(function() lf:Input("StartShooting") end) then return end
            if not identityIsSafe() then return end
            local g = getthreadidentity or get_thread_identity
            local s = setthreadidentity or set_thread_identity or setidentity
            if type(s) ~= "function" then return end
            local prev
            if type(g) == "function" then local okP, p = pcall(g); if okP then prev = p end end
            pcall(s, 2)
            pcall(function() lf:Input("StartShooting") end)
            pcall(s, prev or 2)
        end)
    end
    local function underCrosshair()
        local c = lp.Character
        if c ~= _filterChar then
            trigParams.FilterDescendantsInstances = { c }
            _filterChar = c
        end
        local cf   = Camera.CFrame
        local dist = math.clamp(Config.TriggerMaxDist or 400, 1, 400)
        local res  = Workspace:Raycast(cf.Position, cf.LookVector * dist, trigParams)
        if not res or not res.Instance then return nil end
        local model = res.Instance:FindFirstAncestorOfClass("Model")
        if not model then return nil end
        local pl = Players:GetPlayerFromCharacter(model)
        if not pl or pl == lp then return nil end
        return pl, res.Instance
    end
    local function step()
        if not Config.Trigger then return end
        if Config.Rage then
            _lastChar = nil
            return
        end
        if not isInputActive(Config.TriggerKey) then
            _lastChar = nil
            return
        end
        local pl, hit = underCrosshair()
        if not pl then
            _lastChar = nil
            return
        end
        if not isValidTarget(pl, false) then
            _lastChar = nil
            return
        end
        if Config.TriggerHeadOnly and not isHeadHit(hit) then
            _lastChar = nil
            return
        end
        if Config.TriggerScopeCheck and not fullyScoped() then
            _lastChar = nil
            return
        end
        local now = tick()
        if pl.Character ~= _lastChar then
            _lastChar = pl.Character
            _onTgtAt  = now
        end
        if (now - _onTgtAt) * 1000 < (Config.TriggerDelayMs or 0) then return end
        if (now - _lastFire) * 1000 < (Config.TriggerRefireMs or 0) then return end
        _lastFire = now
        askToShoot()
    end
    function Trigger.enable()
        Config.Trigger = true
        if _bound then return end
        RunService:BindToRenderStep("LuaHook_Trigger", Enum.RenderPriority.Camera.Value + 2, function()
            pcall(step)
        end)
        _bound = true
    end
    function Trigger.disable()
        Config.Trigger = false
        _lastChar = nil
        _lastFire = 0
        _onTgtAt  = 0
        if not _bound then return end
        pcall(function() RunService:UnbindFromRenderStep("LuaHook_Trigger") end)
        _bound = false
    end
    function Trigger.init()
        if Config.Trigger then Trigger.enable() end
    end
    function Trigger.unload()
        Trigger.disable()
    end
end
local ESP = {}
;(function()
    local hasDrawing  = screenDraw ~= nil
    local _renderConn = nil
    local _espFrame   = 0
    local _lastRenderT = 0
    local _dcLastT    = 0
    local _bboxCache  = {}
    local _bboxFrameN = {}
    local _ctx        = {}
    local _renderArr  = {}
    local _dcArr      = {}
    local _radarO     = { drawings = {} }
    local _module     = { drawings = {} }
    local BLACK = Color3.new(0, 0, 0)
    local WHITE = Color3.new(1, 1, 1)
    local INK   = Color3.fromRGB(4, 6, 10)
    local HPBG  = Color3.fromRGB(11, 15, 22)
    local HP_W       = 3
    local HP_GAP     = 5
    local PAD        = 5
    local FLAG_GAP   = 6
    local BASE_H     = 1080
    local MIN_W      = 8
    local MIN_H      = 13
    local BOX_W_STUDS = 4   * 1000 / 1080
    local BOX_H_STUDS = 6.5 * 1000 / 1080
    local TEXT_FLOOR  = 8
    local DIST_MIN_MUL = 0.5
    local cam        = Camera
    local FACES = {}
    for _, n in ipairs({ "Code", "RobotoMono", "Gotham", "GothamBold", "Arial", "SourceSans" }) do
        local ok, f = pcall(function() return Enum.Font[n] end)
        if ok and f then FACES[n] = f end
    end
    if FACES.Code == nil then FACES.Code = Enum.Font.SourceSans end
    local _customFaces = {}
    local function faceFor(name)
        local c = _customFaces[name]
        if c ~= nil then return c end
        return FACES[name] or FACES.Code
    end
    local GLYPH_TRI = string.char(0xE2, 0x96, 0xB2)
    local GLYPH_MID = string.char(0xC2, 0xB7)
    local function typePx(base, scale)
        local v = math.floor(base * scale + 0.5)
        if v < TEXT_FLOOR then v = TEXT_FLOOR end
        return v
    end
    local function distMul(dist)
        if not Config.ESPDistanceScaling then return 1 end
        local ref = Config.ESPDistanceScalingRef or 50
        return math.clamp(ref / math.max(dist or 1, 1), DIST_MIN_MUL, 1)
    end
    local function sizeFor(base, mul)
        local v = math.floor(base * (mul or 1) + 0.5)
        if v < TEXT_FLOOR then v = TEXT_FLOOR end
        return v
    end
    local function styleLabel(t, face, size, casing)
        if typeof(face) == "EnumItem" then
            if t.Font ~= face then t.Font = face end
        else
            if t.FontFace ~= face then t.FontFace = face end
        end
        if t.TextSize ~= size then t.TextSize = size end
        local st = t:FindFirstChildOfClass("UIStroke")
        if st then
            local c = casing or 2
            if st.Thickness ~= c then st.Thickness = c end
            if st.Enabled ~= (c > 0) then st.Enabled = c > 0 end
        end
    end
    local _seqCache = {}
    local function gradSeq(key, a, b)
        if not a or not b then return nil end
        local s = _seqCache[key]
        if s and s.a == a and s.b == b then return s.seq end
        local seq = ColorSequence.new({
            ColorSequenceKeypoint.new(0, a),
            ColorSequenceKeypoint.new(0.5, b),
            ColorSequenceKeypoint.new(1, a),
        })
        _seqCache[key] = { a = a, b = b, seq = seq }
        return seq
    end
    local function paint(inst, prop, key, mode, solid, ga, gb, rot, spin, now)
        if inst == nil then return end
        if mode == "Gradient" then
            local seq = gradSeq(key, ga, gb)
            if seq then
                if inst[prop] ~= WHITE then inst[prop] = WHITE end
                local ug = inst:FindFirstChildOfClass("UIGradient")
                if ug == nil then ug = Instance.new("UIGradient"); ug.Parent = inst end
                if ug.Color ~= seq then ug.Color = seq end
                local r = rot or 0
                if spin and spin > 0 then r = (r + (now or 0) * spin * 360) % 360 end
                if ug.Rotation ~= r then ug.Rotation = r end
                if not ug.Enabled then ug.Enabled = true end
                return
            end
        end
        local ug = inst:FindFirstChildOfClass("UIGradient")
        if ug and ug.Enabled then ug.Enabled = false end
        local c = solid or WHITE
        if inst[prop] ~= c then inst[prop] = c end
    end
    local function healthColor(frac)
        local mode = Config.ESPHealthColorMode or "Ramp"
        if mode == "Solid" then return Config.ESPHealthColor or Color3.fromRGB(61, 224, 122) end
        if mode == "Gradient" then return WHITE end
        if hpRamp then return hpRamp(frac) end
        return Config.ESPHealthColor or Color3.fromRGB(61, 224, 122)
    end
    local _lock = { obj = nil, cand = nil, candT = 0 }
    local function resolveLock(bestO, bestD, lockO, lockD, now)
        local lk = _lock
        if bestO == nil then lk.obj = nil; lk.cand = nil; return nil end
        local prev = lk.obj
        if lk.obj == nil or lockO == nil then
            lk.obj = bestO; lk.cand = nil
        elseif bestO == lk.obj then
            lk.cand = nil
        elseif bestD <= (lockD or math.huge) * 0.9 then
            if lk.cand == bestO then
                if (now - (lk.candT or now)) >= 0.5 then lk.obj = bestO; lk.cand = nil end
            else
                lk.cand = bestO; lk.candT = now
            end
        else
            lk.cand = nil
        end
        if lk.obj and lk.obj ~= prev then lk.obj._primT = now end
        return lk.obj
    end
    local SKEL_R15 = {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    }
    local SKEL_R6 = {
        {"Head","Torso"},
        {"Torso","Left Arm"},{"Torso","Right Arm"},
        {"Torso","Left Leg"},{"Torso","Right Leg"},
    }
    local FLAG_COLORS = {
        STARING     = Color3.fromRGB(255,  70,  85),
        DEFLECT     = Color3.fromRGB( 53, 215, 199),
        SHIELD      = Color3.fromRGB(255, 194,  75),
        INVINCIBLE  = Color3.fromRGB(255, 215,   0),
        LOW         = Color3.fromRGB(255,  90, 100),
    }
    local _gui, _absLayer = nil, nil
    local function mkAbsLayer(g)
        local a = Instance.new("Frame")
        a.Name = "a"; a.BackgroundTransparency = 1; a.BorderSizePixel = 0
        a.Size = UDim2.fromScale(1, 1); a.Position = UDim2.new(); a.ZIndex = 1
        a.Parent = g
        return a
    end
    local function espGui()
        if _gui and _gui.Parent then
            if _absLayer == nil or _absLayer.Parent ~= _gui then _absLayer = mkAbsLayer(_gui) end
            return _gui
        end
        local ok, g = pcall(function()
            local s = Instance.new("ScreenGui")
            s.Name = "\0" .. tostring(math.random(1e5, 1e6))
            s.IgnoreGuiInset  = true
            s.ResetOnSpawn    = false
            s.DisplayOrder    = 99990
            s.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
            local parent
            pcall(function() parent = gethui and gethui() end)
            if parent == nil then pcall(function() parent = game:GetService("CoreGui") end) end
            if parent == nil then parent = lp:FindFirstChildOfClass("PlayerGui") end
            s.Parent = parent
            return s
        end)
        if not ok or not g then return nil end
        _gui = g
        _absLayer = mkAbsLayer(g)
        return _gui
    end
    local function mkFrame(parent, z)
        local f = Instance.new("Frame")
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.ZIndex = z or 1
        f.Parent = parent
        return f
    end
    local function mkLabel(parent, z, align)
        local t = Instance.new("TextLabel")
        t.BackgroundTransparency = 1
        t.BorderSizePixel = 0
        t.RichText = true
        t.TextXAlignment = align or Enum.TextXAlignment.Center
        t.AutomaticSize = Enum.AutomaticSize.XY
        t.Size = UDim2.fromOffset(0, 0)
        t.ZIndex = z or 3
        t.TextColor3 = WHITE
        local st = Instance.new("UIStroke")
        st.Color = BLACK; st.Thickness = 1; st.Transparency = 0
        st.LineJoinMode = Enum.LineJoinMode.Round
        st.Parent = t
        t.Parent = parent
        return t
    end
    local function mkList(parent, z, pad, horizAlign, vertAlign)
        local f = mkFrame(parent, z)
        f.AutomaticSize = Enum.AutomaticSize.XY
        f.Size = UDim2.fromOffset(0, 0)
        local l = Instance.new("UIListLayout")
        l.FillDirection        = Enum.FillDirection.Vertical
        l.SortOrder            = Enum.SortOrder.LayoutOrder
        l.Padding              = UDim.new(0, pad or 2)
        l.HorizontalAlignment  = horizAlign or Enum.HorizontalAlignment.Center
        l.VerticalAlignment    = vertAlign or Enum.VerticalAlignment.Top
        l.Parent = f
        return f
    end
    local function mkRing(parent, z, colour, thick)
        local f = mkFrame(parent, z)
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.Position = UDim2.fromScale(0.5, 0.5)
        f.Size = UDim2.fromScale(1, 1)
        local s = Instance.new("UIStroke")
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.LineJoinMode    = Enum.LineJoinMode.Miter
        s.Color = colour; s.Thickness = thick; s.Transparency = 0
        s.Parent = f
        return f, s
    end
    local function mkCasedRect(parent, z)
        local box = mkFrame(parent, z)
        box.Size = UDim2.fromScale(1, 1)
        local rIn,  sIn  = mkRing(box, z + 1, INK,   1)
        local rMid, sMid = mkRing(box, z + 2, WHITE, 1)
        local rOut, sOut = mkRing(box, z + 1, INK,   1)
        return box, sMid, sOut, sIn, rMid, rOut, rIn
    end
    local function buildTree(o)
        local g = espGui(); if not g then return nil end
        local u = {}
        local root = mkFrame(g, 2)
        root.Name = "r"
        root.Visible = false
        root.Size = UDim2.fromOffset(MIN_W, MIN_H)
        u.root = root
        u.fill = mkFrame(root, 2)
        u.fill.Size = UDim2.fromScale(1, 1)
        u.fill.Visible = false
        u.box, u.boxStroke, u.caseOut, u.caseIn, u.ringMid, u.ringOut, u.ringIn = mkCasedRect(root, 3)
        u.box.Visible = false
        u.corners = {}
        for i = 1, 8 do
            local c = mkFrame(root, 6)
            c.BackgroundTransparency = 0
            c.BackgroundColor3 = WHITE
            c.Visible = false
            local cs = Instance.new("UIStroke")
            cs.Color = INK; cs.Thickness = 1; cs.Transparency = 0
            cs.LineJoinMode = Enum.LineJoinMode.Miter
            cs.Parent = c
            u.corners[i] = c
        end
        local hp = mkFrame(root, 4)
        hp.AnchorPoint = Vector2.new(1, 0)
        hp.Position = UDim2.new(0, -HP_GAP, 0, 0)
        hp.Size = UDim2.new(0, HP_W, 1, 0)
        hp.BackgroundTransparency = 0
        hp.BackgroundColor3 = HPBG
        local hs = Instance.new("UIStroke")
        hs.Color = INK; hs.Thickness = 1; hs.Transparency = 0
        hs.LineJoinMode = Enum.LineJoinMode.Miter
        hs.Parent = hp
        hp.Visible = false
        u.hp = hp
        u.hpGhost = mkFrame(hp, 5)
        u.hpGhost.BackgroundTransparency = 0
        u.hpGhost.BackgroundColor3 = WHITE
        u.hpGhost.AnchorPoint = Vector2.new(0, 1)
        u.hpGhost.Position = UDim2.fromScale(0, 1)
        u.hpGhost.Visible = false
        u.hpFill = mkFrame(hp, 6)
        u.hpFill.BackgroundTransparency = 0
        u.hpFill.BackgroundColor3 = WHITE
        u.hpFill.AnchorPoint = Vector2.new(0, 1)
        u.hpFill.Position = UDim2.fromScale(0, 1)
        u.hpFill.Size = UDim2.fromScale(1, 1)
        u.hpNum = mkLabel(root, 7, Enum.TextXAlignment.Right)
        u.hpNum.AnchorPoint = Vector2.new(1, 0)
        u.hpNum.Position = UDim2.new(0, -HP_GAP - HP_W - 3, 0, 0)
        u.hpNum.Visible = false
        local head = mkList(root, 7, 2, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Bottom)
        head.AnchorPoint = Vector2.new(0.5, 1)
        head.Position = UDim2.new(0.5, 0, 0, -PAD)
        head.Visible = false
        u.head = head
        u.name = mkLabel(head, 8)
        u.name.LayoutOrder = 1
        u.under = mkFrame(head, 8)
        u.under.LayoutOrder = 2
        u.under.BackgroundTransparency = 0
        u.under.BackgroundColor3 = WHITE
        u.under.Size = UDim2.fromOffset(0, 2)
        u.under.Visible = false
        local foot = mkList(root, 7, 2, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)
        foot.AnchorPoint = Vector2.new(0.5, 0)
        foot.Position = UDim2.new(0.5, 0, 1, PAD)
        foot.Visible = false
        u.foot = foot
        u.info = mkLabel(foot, 8)
        u.info.LayoutOrder = 1
        u.info.Visible = false
        local ammo = mkFrame(foot, 8)
        ammo.LayoutOrder = 2
        ammo.BackgroundTransparency = 0
        ammo.BackgroundColor3 = HPBG
        ammo.Size = UDim2.fromOffset(28, 3)
        local as = Instance.new("UIStroke")
        as.Color = INK; as.Thickness = 1; as.Transparency = 0
        as.LineJoinMode = Enum.LineJoinMode.Miter
        as.Parent = ammo
        ammo.Visible = false
        u.ammo = ammo
        u.ammoFill = mkFrame(ammo, 9)
        u.ammoFill.BackgroundTransparency = 0
        u.ammoFill.BackgroundColor3 = WHITE
        u.ammoFill.Size = UDim2.fromScale(1, 1)
        local flags = mkList(root, 7, 3, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Top)
        flags.AnchorPoint = Vector2.new(0, 0)
        flags.Position = UDim2.new(1, FLAG_GAP, 0, 0)
        flags.Visible = false
        u.flags = flags
        u.chips = {}
        for i = 1, 5 do
            local c = mkLabel(flags, 8, Enum.TextXAlignment.Left)
            c.LayoutOrder = i
            c.Visible = false
            u.chips[i] = c
        end
        u.chev = mkLabel(root, 9)
        u.chev.AnchorPoint = Vector2.new(0.5, 1)
        u.chev.Text = GLYPH_TRI
        u.chev.Visible = false
        u.pulse = mkFrame(root, 1)
        u.pulse.AnchorPoint = Vector2.new(0.5, 0.5)
        u.pulse.Position = UDim2.fromScale(0.5, 0.5)
        local ps = Instance.new("UIStroke")
        ps.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ps.LineJoinMode = Enum.LineJoinMode.Miter
        ps.Thickness = 2; ps.Color = WHITE
        ps.Parent = u.pulse
        u.pulseStroke = ps
        u.pulse.Visible = false
        local a = _absLayer
        u.skel = {}
        u.tracer  = mkFrame(a, 2); u.tracer.AnchorPoint = Vector2.new(0.5, 0.5)
        u.tracer.BackgroundTransparency = 0; u.tracer.BackgroundColor3 = WHITE; u.tracer.Visible = false
        u.look    = mkFrame(a, 2); u.look.AnchorPoint = Vector2.new(0.5, 0.5)
        u.look.BackgroundTransparency = 0; u.look.BackgroundColor3 = WHITE; u.look.Visible = false
        u.dot     = mkFrame(a, 3); u.dot.AnchorPoint = Vector2.new(0.5, 0.5)
        u.dot.BackgroundTransparency = 0; u.dot.BackgroundColor3 = WHITE; u.dot.Visible = false
        local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(1, 0); dc.Parent = u.dot
        local ds = Instance.new("UIStroke"); ds.Color = INK; ds.Thickness = 1; ds.Parent = u.dot
        return u
    end
    local function destroyTree(o)
        local u = o.ui; if not u then return end
        pcall(function() if u.root then u.root:Destroy() end end)
        pcall(function() if u.tracer then u.tracer:Destroy() end end)
        pcall(function() if u.look then u.look:Destroy() end end)
        pcall(function() if u.dot then u.dot:Destroy() end end)
        if u.skel then
            for i = 1, #u.skel do pcall(function() u.skel[i]:Destroy() end) end
        end
        o.ui = nil
    end
    local _createBudget = 0
    local CREATE_BUDGET_PER_FRAME = 32
    local function newDraw(t)
        if not hasDrawing then return nil end
        local ok, d = pcall(screenDraw, t)
        if not ok then return nil end
        d.Visible = false; return d
    end
    local function nd(o, key, dtype)
        local d = o[key]
        if d == nil then
            if _createBudget <= 0 then return nil end
            _createBudget = _createBudget - 1
            d = newDraw(dtype) or false
            o[key] = d
            if d then o.drawings[#o.drawings + 1] = d end
        end
        return d or nil
    end
    local function ndArr(o, key, dtype, n)
        local arr = o[key]
        if not arr then arr = {}; o[key] = arr end
        for i = #arr + 1, n do
            if _createBudget <= 0 then break end
            local d = newDraw(dtype)
            if not d then break end
            _createBudget = _createBudget - 1
            arr[i] = d
            o.drawings[#o.drawings + 1] = d
        end
        return arr
    end
    local function ensureCham(o, char)
        local hl = o.cham
        if hl == nil then
            hl = Instance.new("Highlight")
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Enabled   = false
            hl.Parent    = char
            o.cham = hl
        elseif hl and hl.Parent ~= char then
            pcall(function() hl.Parent = char end)
        end
        return o.cham
    end
    local function cleanESP(p)
        local o = State.ESPObjects[p]; if not o then return end
        destroyTree(o)
        for _, d in ipairs(o.drawings or {}) do
            pcall(function() if d.Remove then d:Remove() end end)
        end
        if o.cham and o.cham.Parent then pcall(function() o.cham:Destroy() end) end
        _bboxCache[p]  = nil
        _bboxFrameN[p] = nil
        State.ESPObjects[p] = nil
    end
    local function buildESP(player)
        if player == lp then return end
        cleanESP(player)
        local char = player.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local isR6 = (hum and hum.RigType == Enum.HumanoidRigType.R6) or (char:FindFirstChild("Torso") ~= nil)
        local rig  = isR6 and SKEL_R6 or SKEL_R15
        local bones = {}
        for i, pair in ipairs(rig) do
            bones[i] = { a = char:FindFirstChild(pair[1]), b = char:FindFirstChild(pair[2]) }
        end
        local o = { drawings = {}, root = root, rig = rig, bones = bones, _fadeT = tick() }
        o.ui = buildTree(o)
        State.ESPObjects[player] = o
    end
    local function bbox(char, player)
        local frame = _bboxFrameN[player] or -999
        if (_espFrame - frame) < 1 then
            local c = _bboxCache[player]
            if c then return c[1], c[2], c[3], c[4] end
            return nil
        end
        _bboxFrameN[player] = _espFrame
        _bboxCache[player] = nil
        local ok, pivot = pcall(function() return char:GetPivot().Position end)
        if not ok or pivot == nil then return nil end
        local sp = cam:WorldToViewportPoint(pivot)
        local depth = sp.Z
        if depth <= 0.5 then return nil end
        local vpY = _ctx.vp and _ctx.vp.Y or 1080
        local tanHalf = math.tan(math.rad(cam.FieldOfView) * 0.5)
        if tanHalf <= 0 then return nil end
        local scale = vpY / (2 * depth * tanHalf)
        local bs = Config.ESPBoxScale or 1
        local rawW = BOX_W_STUDS * scale * bs
        local rawH = BOX_H_STUDS * scale * bs
        if rawH > 4000 or rawW > 3000 then return nil end
        local x = math.floor(sp.X - rawW * 0.5)
        local y = math.floor(sp.Y - rawH * 0.5)
        local bw = math.floor(math.max(MIN_W, rawW))
        local bh = math.floor(math.max(MIN_H, rawH))
        _bboxCache[player] = { x, y, x + bw, y + bh }
        return x, y, x + bw, y + bh
    end
    local function hideTree(o)
        local u = o.ui; if not u then return end
        if u.root then u.root.Visible = false end
        if u.tracer then u.tracer.Visible = false end
        if u.look then u.look.Visible = false end
        if u.dot then u.dot.Visible = false end
        if u.skel then for i = 1, #u.skel do u.skel[i].Visible = false end end
    end
    local function hideDrawings(o)
        for _, d in ipairs(o.drawings) do d.Visible = false end
    end
    local function hideAll(o, force)
        if o._allHidden and not force then return end
        o._allHidden = true
        hideTree(o)
        hideDrawings(o)
        if o.cham then o.cham.Enabled = false end
    end
    function ESP.rebuildAll()
        for p in pairs(State.ESPObjects) do cleanESP(p) end
        if not Config.ESP then return end
        for _, p in ipairs(getSafePlayers()) do
            if p ~= lp and p.Character then buildESP(p) end
        end
    end
    function ESP.registerFace(name, font)
        if type(name) == "string" and font ~= nil then _customFaces[name] = font end
    end
    local function espWeapon(o, player)
        local now = tick()
        if not o._wepT or (now - o._wepT) > 0.5 then
            o._wep  = getWeaponName(player)
            o._wepT = now
        end
        return o._wep or "?"
    end
    local function paintBox(u, ctx)
        local mode = Config.ESPBoxColorMode or "Solid"
        paint(u.boxStroke, "Color", "box", mode, Config.ESPBoxColor, Config.ESPBoxGradA, Config.ESPBoxGradB,
              Config.ESPGradientRotBox or 0, Config.ESPGradientSpeed, ctx.now)
        local ct = math.floor(math.clamp(Config.ESPCasingThickness or 1, 1, 3))
        local bt = math.floor(math.clamp(Config.ESPBoxThickness or 1, 1, 4))
        if ctx.primary and Config.ESPPrimaryEmphasis then bt = bt + 1 end
        if u.caseOut.Thickness  ~= ct then u.caseOut.Thickness  = ct end
        if u.caseIn.Thickness   ~= ct then u.caseIn.Thickness   = ct end
        if u.boxStroke.Thickness ~= bt then u.boxStroke.Thickness = bt end
        local sOut = UDim2.fromScale(1, 1)
        local sMid = UDim2.new(1, -2 * bt, 1, -2 * bt)
        local sIn  = UDim2.new(1, -2 * bt - 2 * ct, 1, -2 * bt - 2 * ct)
        if u.ringOut.Size ~= sOut then u.ringOut.Size = sOut end
        if u.ringMid.Size ~= sMid then u.ringMid.Size = sMid end
        if u.ringIn.Size  ~= sIn  then u.ringIn.Size  = sIn  end
        local tr = math.clamp((Config.ESPBoxTransparency or 0) + (1 - (ctx.fade or 1)), 0, 1)
        if u.boxStroke.Transparency ~= tr then u.boxStroke.Transparency = tr end
        if u.caseOut.Transparency ~= tr then u.caseOut.Transparency = tr end
        if u.caseIn.Transparency  ~= tr then u.caseIn.Transparency  = tr end
    end
    local function drawCorners(u, w, h, ctx)
        local len = math.floor(math.clamp(w * (Config.ESPCornerLength or 0.28), 4, math.max(w * 0.48, 6)))
        local th  = math.max(math.floor(Config.ESPBoxThickness or 1), 1)
        local col = Config.ESPBoxColor or WHITE
        local mode = Config.ESPBoxColorMode or "Solid"
        local spec = {
            { 0, 0, len, th }, { 0, 0, th, len },
            { w - len, 0, len, th }, { w - th, 0, th, len },
            { 0, h - th, len, th }, { 0, h - len, th, len },
            { w - len, h - th, len, th }, { w - th, h - len, th, len },
        }
        for i = 1, 8 do
            local c = u.corners[i]
            local s = spec[i]
            c.Position = UDim2.fromOffset(s[1], s[2])
            c.Size     = UDim2.fromOffset(s[3], s[4])
            paint(c, "BackgroundColor3", "box", mode, col, Config.ESPBoxGradA, Config.ESPBoxGradB,
                  Config.ESPGradientRotBox or 0, Config.ESPGradientSpeed, ctx.now)
            c.Visible = true
        end
    end
    local function drawHealth(u, o, ctx, frac, hp)
        if not Config.ESPHealth then u.hp.Visible = false; u.hpNum.Visible = false; return end
        local fill = frac
        if Config.ESPHealthSmooth then
            local s = o._sHP
            if s == nil then s = frac else s = s + (frac - s) * math.clamp((ctx.dt or 0) * 16, 0, 1) end
            o._sHP = s; fill = s
        end
        u.hp.Visible = true
        u.hpFill.Size = UDim2.new(1, 0, math.clamp(fill, 0, 1), 0)
        local mode = Config.ESPHealthColorMode or "Ramp"
        paint(u.hpFill, "BackgroundColor3", "hp", mode, healthColor(fill),
              Config.ESPHealthGradA, Config.ESPHealthGradB, 90, Config.ESPGradientSpeed, ctx.now)
        u.hpFill.BackgroundTransparency = Config.ESPHealthTransparency or 0
        if Config.ESPHealthGhost and o._ghostT and o._ghostFrac and o._ghostFrac > fill
                and (ctx.now - o._ghostT) < 0.35 then
            u.hpGhost.Visible = true
            u.hpGhost.Size = UDim2.new(1, 0, math.clamp(o._ghostFrac, 0, 1), 0)
            u.hpGhost.BackgroundTransparency = 0.35 + 0.65 * math.clamp((ctx.now - o._ghostT) / 0.35, 0, 1)
        else
            u.hpGhost.Visible = false
        end
        local nm = Config.ESPHealthNumberMode or "OnDamage"
        local show = nm == "Always" or (nm == "OnDamage" and frac < 0.999)
        if show then
            u.hpNum.Visible = true
            u.hpNum.Text = tostring(math.floor(hp or 0))
            styleLabel(u.hpNum, ctx.face, sizeFor(ctx.tsHp, ctx.dmul), ctx.casing)
            u.hpNum.TextColor3 = healthColor(fill)
            u.hpNum.TextTransparency = 1 - (ctx.fade or 1)
            u.hpNum.Position = UDim2.new(0, -HP_GAP - HP_W - 3, math.clamp(1 - fill, 0, 1), 0)
        else
            u.hpNum.Visible = false
        end
    end
    local function drawText(u, o, player, ctx, dist, frac)
        local declut = Config.ESPDeclutter and o._declutter
        if Config.ESPName and not declut then
            u.head.Visible = true
            u.name.Visible = true
            styleLabel(u.name, ctx.face, sizeFor(ctx.tsName, ctx.dmul), ctx.casing)
            u.name.Text = (Config.ESPNameMode == "Username") and player.Name or player.DisplayName
            paint(u.name, "TextColor3", "name", Config.ESPNameColorMode or "Solid", Config.ESPNameColor,
                  Config.ESPNameGradA, Config.ESPNameGradB, Config.ESPGradientRotText or 90,
                  Config.ESPGradientSpeed, ctx.now)
            u.name.TextTransparency = math.clamp((Config.ESPNameTransparency or 0) + (1 - (ctx.fade or 1)), 0, 1)
            if Config.ESPNameHealthUnderline and frac then
                local tb = u.name.TextBounds
                u.under.Visible = true
                u.under.Size = UDim2.fromOffset(math.max(math.floor((tb and tb.X or 0) * frac), 1), 2)
                u.under.BackgroundColor3 = healthColor(frac)
            else
                u.under.Visible = false
            end
        else
            u.head.Visible = false
        end
        local showInfo = (Config.ESPDistance or Config.ESPWeapon) and not declut
        local showAmmo = Config.ESPAmmoBar and not declut
        u.foot.Visible = showInfo or showAmmo
        if showInfo then
            local txt
            if Config.ESPWeapon then txt = espWeapon(o, player) end
            if Config.ESPDistance then
                local d = ("%dm"):format(dist)
                txt = txt and (txt .. " " .. GLYPH_MID .. " " .. d) or d
            end
            u.info.Visible = true
            styleLabel(u.info, ctx.face, sizeFor(ctx.tsInfo, ctx.dmul), ctx.casing)
            u.info.Text = txt or ""
            paint(u.info, "TextColor3", "info", Config.ESPInfoColorMode or "Solid", Config.ESPInfoColor,
                  Config.ESPInfoGradA, Config.ESPInfoGradB, Config.ESPGradientRotText or 90,
                  Config.ESPGradientSpeed, ctx.now)
            u.info.TextTransparency = 1 - (ctx.fade or 1)
        else
            u.info.Visible = false
        end
        if showAmmo then
            local ammo, maxAmmo = 30, 30
            pcall(function()
                local item = Rivals.Fighter and Rivals.Fighter:Get(player)
                local eq = item and (item.EquippedItem or (item.GetEquippedItem and item:GetEquippedItem()))
                if eq and eq.Data then
                    ammo = eq.Data.Ammo or 30
                    maxAmmo = eq.Data.MaxAmmo or 30
                end
            end)
            local pct = math.clamp(maxAmmo > 0 and (ammo / maxAmmo) or 1, 0, 1)
            u.ammo.Visible = true
            u.ammo.Size = UDim2.fromOffset(math.max(math.floor(ctx.boxW * 0.9), 12), 3)
            u.ammoFill.Size = UDim2.new(pct, 0, 1, 0)
            paint(u.ammoFill, "BackgroundColor3", "mark", Config.ESPMarkColorMode or "Solid",
                  Config.ESPMarkColor, Config.ESPMarkGradA, Config.ESPMarkGradB, 0,
                  Config.ESPGradientSpeed, ctx.now)
        else
            u.ammo.Visible = false
        end
    end
    local function drawFlags(u, o, player, ctx, char, frac)
        local n = 0
        local function add(key, label)
            if n >= 5 then return end
            n = n + 1
            local c = u.chips[n]
            local mode = Config.ESPFlagColorMode or "PerFlag"
            c.Visible = true
            styleLabel(c, ctx.face, sizeFor(ctx.tsChip, ctx.dmul), ctx.casing)
            c.Text = label
            paint(c, "TextColor3", "flag", mode,
                  (mode == "PerFlag") and (FLAG_COLORS[key] or WHITE) or Config.ESPFlagColor,
                  Config.ESPFlagGradA, Config.ESPFlagGradB, Config.ESPGradientRotText or 90,
                  Config.ESPGradientSpeed, ctx.now)
            c.TextTransparency = 1 - (ctx.fade or 1)
        end
        if Config.ESPFlagStaring then
            local head = char:FindFirstChild("Head")
            local myPos = ctx.myRoot and ctx.myRoot.Position
            if head and myPos then
                local toMe = myPos - head.Position
                if toMe.Magnitude > 1 then
                    toMe = toMe.Unit
                    local look = head.CFrame.LookVector
                    if (look.X * toMe.X + look.Y * toMe.Y + look.Z * toMe.Z) > 0.965 then add("STARING", "[STARING]") end
                end
            end
        end
        if Config.ESPFlagDeflect and isDeflecting and isDeflecting(player) then add("DEFLECT", "[DEFLECT]") end
        if Config.ESPFlagShield then
            local wep = espWeapon(o, player)
            if wep and (wep:find("Shield") or wep:find("Riot")) then add("SHIELD", "[SHIELD]") end
        end
        if Config.ESPFlagInvincible and isSpawnProtected and isSpawnProtected(player) then add("INVINCIBLE", "[INVINCIBLE]") end
        if Config.ESPFlagLowHP and frac and frac <= 0.25 then add("LOW", "[LOW HP]") end
        u.flags.Visible = n > 0
        for i = n + 1, 5 do u.chips[i].Visible = false end
    end
    local function segment(f, ax, ay, bx, by, thick, transp)
        local dx, dy = bx - ax, by - ay
        local len = math.sqrt(dx * dx + dy * dy)
        if len < 1 then f.Visible = false; return end
        f.Position = UDim2.fromOffset(math.floor((ax + bx) * 0.5), math.floor((ay + by) * 0.5))
        f.Size = UDim2.fromOffset(math.floor(len + 0.5), thick)
        f.Rotation = math.deg(math.atan2(dy, dx))
        f.BackgroundTransparency = transp or 0
        f.Visible = true
    end
    local function drawSkeleton(u, o, ctx)
        if not Config.ESPSkeleton then
            if u.skel then for i = 1, #u.skel do u.skel[i].Visible = false end end
            return
        end
        local nb = #o.bones
        for i = #u.skel + 1, nb do
            local f = mkFrame(_absLayer, 2)
            f.AnchorPoint = Vector2.new(0.5, 0.5)
            f.BackgroundTransparency = 0
            f.BackgroundColor3 = WHITE
            local s = Instance.new("UIStroke")
            s.Color = INK; s.Thickness = 1; s.Transparency = 0
            s.Parent = f
            f.Visible = false
            u.skel[i] = f
        end
        if (not o._skelPts) or (_espFrame - (o._skelFrame or -9)) >= 2 then
            o._skelFrame = _espFrame
            local pts = o._skelPts; if not pts then pts = {}; o._skelPts = pts end
            for i, pair in ipairs(o.bones) do
                local pa, pb = pair.a, pair.b
                local e = pts[i]; if not e then e = {}; pts[i] = e end
                if pa and pb and pa.Parent and pb.Parent then
                    local s1, v1 = cam:WorldToViewportPoint(pa.Position)
                    local s2, v2 = cam:WorldToViewportPoint(pb.Position)
                    if v1 and v2 and s1.Z > 0 and s2.Z > 0 then
                        e.ok = true; e.ax = s1.X; e.ay = s1.Y; e.bx = s2.X; e.by = s2.Y
                    else e.ok = false end
                else e.ok = false end
            end
        end
        local th = math.max(math.floor(Config.ESPSkeletonThickness or 1), 1)
        local mode = Config.ESPSkeletonColorMode or "Solid"
        local pts = o._skelPts
        for i = 1, nb do
            local f = u.skel[i]
            local e = pts and pts[i]
            if f then
                if e and e.ok then
                    segment(f, e.ax, e.ay, e.bx, e.by, th, Config.ESPSkeletonTransparency or 0)
                    paint(f, "BackgroundColor3", "skel", mode, Config.ESPSkeletonColor,
                          Config.ESPSkeletonGradA, Config.ESPSkeletonGradB, 0, Config.ESPGradientSpeed, ctx.now)
                else f.Visible = false end
            end
        end
    end
    local function drawAbsExtras(u, o, ctx, char, minX, minY, maxX, maxY)
        if Config.ESPTracers then
            local vp = ctx.vp
            local ox, oy = vp.X * 0.5, vp.Y
            local m = Config.ESPTracerOrigin
            if m == "Top" then oy = 0
            elseif m == "Middle" then oy = vp.Y * 0.5
            elseif m == "Mouse" then
                local mp; pcall(function() mp = UserInputService:GetMouseLocation() end)
                if mp then ox, oy = mp.X, mp.Y end
            end
            segment(u.tracer, ox, oy, (minX + maxX) * 0.5, maxY,
                    math.max(math.floor(Config.ESPTracerThickness or 1), 1), Config.ESPTracerTransparency or 0)
            paint(u.tracer, "BackgroundColor3", "tracer", Config.ESPTracerColorMode or "Solid",
                  Config.ESPTracerColor, Config.ESPTracerGradA, Config.ESPTracerGradB, 0,
                  Config.ESPGradientSpeed, ctx.now)
        else u.tracer.Visible = false end
        if Config.ESPHeadDot then
            local head = char:FindFirstChild("Head")
            local ok = false
            if head then
                local hsp, inv = cam:WorldToViewportPoint(head.Position)
                if inv and hsp.Z > 0 then
                    local r = math.clamp(Config.ESPHeadDotSize or 4, 2, 16)
                    u.dot.Position = UDim2.fromOffset(math.floor(hsp.X), math.floor(hsp.Y))
                    u.dot.Size = UDim2.fromOffset(r * 2, r * 2)
                    paint(u.dot, "BackgroundColor3", "mark", Config.ESPMarkColorMode or "Solid",
                          Config.ESPMarkColor, Config.ESPMarkGradA, Config.ESPMarkGradB, 0,
                          Config.ESPGradientSpeed, ctx.now)
                    u.dot.Visible = true; ok = true
                end
            end
            if not ok then u.dot.Visible = false end
        else u.dot.Visible = false end
        if Config.ESPLookLine then
            local head = char:FindFirstChild("Head")
            local ok = false
            if head then
                local look = head.CFrame.LookVector
                local p1 = head.Position
                local p2 = p1 + look * math.clamp(Config.ESPLookLineLength or 8, 2, 32)
                local s1, v1 = cam:WorldToViewportPoint(p1)
                local s2, v2 = cam:WorldToViewportPoint(p2)
                if v1 and v2 and s1.Z > 0 and s2.Z > 0 then
                    segment(u.look, s1.X, s1.Y, s2.X, s2.Y, 1, 0)
                    paint(u.look, "BackgroundColor3", "mark", Config.ESPMarkColorMode or "Solid",
                          Config.ESPMarkColor, Config.ESPMarkGradA, Config.ESPMarkGradB, 0,
                          Config.ESPGradientSpeed, ctx.now)
                    ok = true
                end
            end
            if not ok then u.look.Visible = false end
        else u.look.Visible = false end
    end
    local function renderPlayer(player, o)
        local ctx  = _ctx
        local char = player.Character
        if not char or not o.root or not o.root.Parent then cleanESP(player); return end
        if not o.root:IsA("BasePart") then cleanESP(player); return end
        local rootPos = o.root.Position
        if not rootPos then cleanESP(player); return end
        if not o.ui then o.ui = buildTree(o); if not o.ui then return end end
        local u = o.ui
        local vp     = ctx.vp
        local myRoot = ctx.myRoot
        local dist   = o._dist
        if not dist then
            dist = (myRoot and myRoot.Position and rootPos)
                and (myRoot.Position - rootPos).Magnitude or 0
        end
        local oor = dist > Config.ESPMaxDistance
        if (Config.ESPTeamCheck and isTeammate(player)) or (not isAlive(player)) then
            hideAll(o); return
        end
        if (Config.ESPRadar or Config.ESPChamsVisSplit or Config.ESPPeekAlert
                or (Config.ESPChams and Config.ESPChamsStyle == "Ghost"))
            and not oor and (_espFrame - (o._visFrame or -99)) >= 3 then
            pcall(function() o._vis = isVisible(rootPos) end)
            o._visFrame = _espFrame
        end
        if oor then
            if o.cham then o.cham.Enabled = false end
            hideTree(o); hideDrawings(o); o._allHidden = true
            return
        end
        if o._allHidden and Config.ESPFadeIn then o._fadeT = ctx.now end
        o._allHidden = false
        local fade = 1
        if Config.ESPFadeIn and o._fadeT then
            fade = math.clamp((ctx.now - o._fadeT) / 0.12, 0, 1)
        end
        ctx.fade = fade
        ctx.primary = o._primary and true or false
        ctx.dmul = distMul(dist)
        local minX, minY, maxX, maxY = bbox(char, player)
        if not minX then
            hideTree(o)
        else
            local w, h = maxX - minX, maxY - minY
            ctx.boxW = w
            u.root.Position = UDim2.fromOffset(minX, minY)
            u.root.Size     = UDim2.fromOffset(w, h)
            u.root.Visible  = true
            local hp, mh, frac
            if Config.ESPHealth or Config.ESPHealthGhost or Config.ESPFlagLowHP or Config.ESPNameHealthUnderline then
                pcall(function() hp, mh = getHealth(player) end)
                if hp ~= nil then frac = math.clamp((mh or 0) > 0 and hp / mh or 0, 0, 1) end
            end
            local prevHP = o._lastHP
            if Config.ESPHealthGhost and prevHP and frac and frac < prevHP - 0.005 then
                if not o._ghostT or (ctx.now - o._ghostT) >= 0.35 then o._ghostFrac = prevHP
                else o._ghostFrac = math.max(o._ghostFrac or prevHP, prevHP) end
                o._ghostT = ctx.now
            end
            if Config.ESPHealTick and prevHP and frac and frac > prevHP + 0.005 then o._healT = ctx.now end
            local style = Config.ESPBoxStyle or "Full Box"
            local corners = Config.ESPBoxBrackets or (style == "Corner Brackets")
            if Config.ESPBox and not corners then
                u.box.Visible = true
                paintBox(u, ctx)
                for i = 1, 8 do u.corners[i].Visible = false end
            elseif Config.ESPBox then
                u.box.Visible = false
                drawCorners(u, w, h, ctx)
            else
                u.box.Visible = false
                for i = 1, 8 do u.corners[i].Visible = false end
            end
            if Config.ESPBoxFill then
                u.fill.Visible = true
                u.fill.BackgroundTransparency = Config.ESPBoxFillTransparency or 0.75
                paint(u.fill, "BackgroundColor3", "fill", Config.ESPBoxColorMode or "Solid",
                      Config.ESPBoxFillColor, Config.ESPBoxGradA, Config.ESPBoxGradB,
                      Config.ESPGradientRotBox or 0, Config.ESPGradientSpeed, ctx.now)
            else u.fill.Visible = false end
            drawHealth(u, o, ctx, frac or 1, hp)
            drawText(u, o, player, ctx, dist, frac)
            drawFlags(u, o, player, ctx, char, frac)
            if Config.ESPLockChevron and o._primary then
                local pt = o._primT and math.clamp((ctx.now - o._primT) / 0.14, 0, 1) or 1
                local e = 1 - (1 - pt) * (1 - pt)
                u.chev.Visible = true
                styleLabel(u.chev, ctx.face, sizeFor(ctx.tsChip + 2, ctx.dmul), ctx.casing)
                u.chev.TextColor3 = Color3.fromRGB(255, 194, 75)
                u.chev.TextTransparency = 1 - e
                u.chev.Position = UDim2.new(0.5, 0, 0, -PAD - math.floor(sizeFor(ctx.tsName, ctx.dmul) * 1.7) - math.floor((1 - e) * 6))
            else u.chev.Visible = false end
            local pulseT, pulseCol = nil, nil
            if Config.ESPPeekAlert then
                local v = o._vis and true or false
                if v and not o._peekWasVis then o._peekT = ctx.now end
                o._peekWasVis = v
                if o._peekT and (ctx.now - o._peekT) < 0.14 then
                    pulseT = (ctx.now - o._peekT) / 0.14; pulseCol = Config.ESPBoxColor or WHITE
                end
            end
            if Config.ESPHealTick and o._healT and (ctx.now - o._healT) < 0.2 then
                pulseT = (ctx.now - o._healT) / 0.2; pulseCol = Color3.fromRGB(61, 224, 122)
            end
            if pulseT then
                local grow = math.floor(4 + pulseT * 6)
                u.pulse.Visible = true
                u.pulse.Size = UDim2.new(1, grow * 2, 1, grow * 2)
                u.pulseStroke.Color = pulseCol
                u.pulseStroke.Transparency = pulseT
            else u.pulse.Visible = false end
            if frac ~= nil then o._lastHP = frac end
        end
        drawSkeleton(u, o, ctx)
        if minX then drawAbsExtras(u, o, ctx, char, minX, minY, maxX, maxY)
        else
            u.tracer.Visible = false; u.dot.Visible = false; u.look.Visible = false
        end
        if Config.ESPThreatCount then
            local tsp = cam:WorldToViewportPoint(rootPos)
            local tOn = tsp.Z > 0 and tsp.X >= 0 and tsp.X <= vp.X and tsp.Y >= 0 and tsp.Y <= vp.Y
            if not tOn then ctx.threat = (ctx.threat or 0) + 1 end
        end
        if Config.ESPArrows then
            local ar = nd(o, "arrow", "Triangle")
            if ar then
                local asp = cam:WorldToViewportPoint(rootPos)
                local onScreen = asp.Z > 0 and asp.X >= 0 and asp.X <= vp.X and asp.Y >= 0 and asp.Y <= vp.Y
                if not onScreen then
                    local cen  = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
                    local adir = Vector2.new(asp.X - cen.X, asp.Y - cen.Y)
                    if asp.Z <= 0 then adir = Vector2.new(-adir.X, -adir.Y) end
                    if adir.Magnitude < 1 then adir = Vector2.new(0, -1) end
                    adir = adir.Unit
                    local edge = cen + adir * (math.min(vp.X, vp.Y) * 0.38)
                    local perp = Vector2.new(-adir.Y, adir.X)
                    local aAlpha = 1 - (Config.ESPBoxTransparency or 0)
                    if Config.ESPArrowDistFade then
                        aAlpha = aAlpha * (1 - 0.65 * math.clamp(dist / math.max(Config.ESPMaxDistance, 1), 0, 1))
                    end
                    ar.Filled = false
                    ar.PointA = edge + adir * 20
                    ar.PointB = (edge - adir * 10) + perp * 8
                    ar.PointC = (edge - adir * 10) - perp * 8
                    ar.Color = Config.ESPBoxColor or WHITE
                    ar.Transparency = aAlpha; ar.Visible = true
                    if Config.ESPArrowDistLabel then
                        local dl = nd(o, "arrowDist", "Text")
                        if dl then
                            local lpos = edge - adir * 24
                            dl.Font = 3; dl.Size = 10; dl.Center = true; dl.Outline = true
                            dl.Color = Config.ESPInfoColor or WHITE
                            dl.Text = ("%dm"):format(dist)
                            dl.Position = Vector2.new(math.floor(lpos.X), math.floor(lpos.Y - 5))
                            dl.Transparency = aAlpha; dl.Visible = true
                        end
                    elseif o.arrowDist then o.arrowDist.Visible = false end
                else
                    ar.Visible = false
                    if o.arrowDist then o.arrowDist.Visible = false end
                end
            end
        elseif o.arrow then
            o.arrow.Visible = false
            if o.arrowDist then o.arrowDist.Visible = false end
        end
        if Config.ESPChams then
            local hl = ensureCham(o, char)
            if hl then
                local vc = Config.ESPChamsVisSplit
                    and (o._vis and (isTeammate(player) and Config.ColorTeam or Config.ColorEnemy)
                                 or (isTeammate(player) and Config.ColorTeamOcc or Config.ColorEnemyOcc))
                    or nil
                local state = vc or Config.ESPChamsFillColor
                local style2 = Config.ESPChamsStyle
                if style2 == "Shade" then
                    hl.FillColor = state; hl.OutlineColor = WHITE
                    hl.FillTransparency = 0.62; hl.OutlineTransparency = 0; hl.Enabled = true
                elseif style2 == "Neon" then
                    hl.FillColor = state; hl.OutlineColor = vc or Config.ESPChamsOutlineColor
                    hl.FillTransparency = 0.88; hl.OutlineTransparency = 0; hl.Enabled = true
                elseif style2 == "Ghost" then
                    hl.FillColor = state; hl.OutlineColor = WHITE
                    hl.FillTransparency = 1; hl.OutlineTransparency = 0.25; hl.Enabled = not o._vis
                else
                    hl.FillColor = vc or Config.ESPChamsFillColor
                    hl.OutlineColor = vc or Config.ESPChamsOutlineColor
                    hl.FillTransparency = Config.ESPChamsFillTransparency
                    hl.OutlineTransparency = Config.ESPChamsOutlineTransparency
                    hl.Enabled = true
                end
            end
        elseif o.cham then o.cham.Enabled = false end
    end
    local function _byDist(a, b)
        local ad, bd = a.d, b.d
        if ad ~= ad then return false end
        if bd ~= bd then return true end
        return ad < bd
    end
    local function doDeclutter(ctx)
        local myPos = ctx.myRoot and ctx.myRoot.Position
        local n = 0
        for player, o in pairs(State.ESPObjects) do
            o._declutter = false
            local c = _bboxCache[player]
            if c and o.root and o.root.Parent then
                n = n + 1
                local e = _dcArr[n]; if not e then e = {}; _dcArr[n] = e end
                e.o = o; e.c = c
                local rp = o.root.Position
                e.d = (myPos and rp) and (myPos - rp).Magnitude or math.huge
            end
        end
        for i = #_dcArr, n + 1, -1 do _dcArr[i] = nil end
        table.sort(_dcArr, _byDist)
        for i = 1, n - 1 do
            local A = _dcArr[i]; local ca = A.c
            local aMinX, aMinY, aMaxX, aMaxY = ca[1], ca[2], ca[3], ca[4]
            for j = i + 1, n do
                local B = _dcArr[j]
                if not B.o._declutter then
                    local cb = B.c
                    local ix = math.min(aMaxX, cb[3]) - math.max(aMinX, cb[1])
                    local iy = math.min(aMaxY, cb[4]) - math.max(aMinY, cb[2])
                    if ix > 0 and iy > 0 then
                        local barea = (cb[3] - cb[1]) * (cb[4] - cb[2])
                        if barea > 0 and (ix * iy) / barea > 0.6 then B.o._declutter = true end
                    end
                end
            end
        end
    end
    local function renderRadar(ctx)
        if not Config.ESPRadar then
            for _, d in ipairs(_radarO.drawings) do d.Visible = false end
            return
        end
        if (_espFrame % 2) ~= 0 then return end
        local vp = ctx.vp; if not vp then return end
        local R     = math.max((Config.ESPRadarSize or 180) * 0.5, 10)
        local inset = Config.ESPRadarInset or 20
        local cx    = vp.X - inset - R
        local cy    = inset + R
        local disc = nd(_radarO, "disc", "Circle")
        if disc then
            disc.Filled = true; disc.NumSides = 32; disc.Radius = R
            disc.Position = Vector2.new(cx, cy)
            disc.Color = Color3.fromRGB(13, 18, 25)
            disc.Transparency = 0.62; disc.Visible = true
        end
        local rring = nd(_radarO, "rangeRing", "Circle")
        if rring then
            rring.Filled = false; rring.Thickness = 1; rring.NumSides = 28; rring.Radius = R * 0.5
            rring.Position = Vector2.new(cx, cy); rring.Color = WHITE
            rring.Transparency = 0.10; rring.Visible = true
        end
        local myPos = ctx.myRoot and ctx.myRoot.Position
        if not myPos then return end
        local rot = 0
        if Config.ESPRadarRotate then
            local look = cam.CFrame.LookVector
            rot = -math.atan2(look.X, look.Z)
        end
        local cosR, sinR = math.cos(rot), math.sin(rot)
        local range = math.max(Config.ESPRadarRange or 250, 1)
        local ticks = ndArr(_radarO, "ticks", "Line", 4)
        for i = 0, 3 do
            local L = ticks[i + 1]
            if L then
                local ang = i * (math.pi * 0.5) + rot
                local dxT, dyT = math.sin(ang), -math.cos(ang)
                L.From = Vector2.new(cx + dxT * (R - 6), cy + dyT * (R - 6))
                L.To   = Vector2.new(cx + dxT * R, cy + dyT * R)
                L.Thickness = 1
                if i == 0 then L.Color = Color3.fromRGB(255, 194, 75); L.Transparency = 0.9
                else L.Color = WHITE; L.Transparency = 0.35 end
                L.Visible = true
            end
        end
        if Config.ESPRadarGrid then
            local grid = ndArr(_radarO, "grid", "Line", 2)
            for gi = 1, 2 do
                local L = grid[gi]
                if L then
                    local ang = rot + (gi - 1) * (math.pi * 0.5)
                    local gx, gy = math.sin(ang), -math.cos(ang)
                    L.From = Vector2.new(cx - gx * R, cy - gy * R)
                    L.To   = Vector2.new(cx + gx * R, cy + gy * R)
                    L.Thickness = 1
                    L.Color = Color3.fromRGB(168, 180, 192)
                    L.Transparency = 0.10
                    L.Visible = true
                end
            end
        elseif _radarO.grid then
            for _, L in ipairs(_radarO.grid) do L.Visible = false end
        end
        if Config.ESPRadarSweep then
            local sw = ndArr(_radarO, "sweep", "Line", 3)
            local baseAng = ((ctx.now or 0) % 4) / 4 * (math.pi * 2) + rot
            for si = 1, 3 do
                local L = sw[si]
                if L then
                    local ang = baseAng - (si - 1) * 0.12
                    local sx, sy = math.sin(ang), -math.cos(ang)
                    L.From = Vector2.new(cx, cy)
                    L.To   = Vector2.new(cx + sx * (R - 2), cy + sy * (R - 2))
                    L.Thickness = si == 1 and 2 or 1
                    L.Color = Color3.fromRGB(255, 194, 75)
                    L.Transparency = si == 1 and 0.35 or (si == 2 and 0.18 or 0.08)
                    L.Visible = true
                end
            end
        elseif _radarO.sweep then
            for _, L in ipairs(_radarO.sweep) do L.Visible = false end
        end
        local idx = 0
        local closestIdx, closestH = nil, math.huge
        local closestPx, closestPy, closestDotR = 0, 0, 0
        for player, o in pairs(State.ESPObjects) do
            local root = o.root
            if root and root.Parent then
                local rp = root.Position
                local dx = rp.X - myPos.X
                local dz = rp.Z - myPos.Z
                local sx = (dx / range) * R
                local sz = (dz / range) * R
                local rx = sx * cosR - sz * sinR
                local rz = sx * sinR + sz * cosR
                local mag = math.sqrt(rx * rx + rz * rz)
                if mag > R then rx = rx / mag * R; rz = rz / mag * R end
                idx = idx + 1
                local px, py = cx + rx, cy + rz
                local hdist  = math.sqrt(dx * dx + dz * dz)
                local dotR   = math.clamp(5 - (hdist / range) * 2, 3, 5)
                local team   = isTeammate(player)
                local filled = (not Config.ESPRadarVisSplit) or (o._vis and true or false)
                local col
                if Config.ESPRadarVisSplit and not o._vis then
                    col = team and Config.ColorTeamOcc or Config.ColorEnemyOcc
                else
                    col = team and Config.ColorTeam or Config.ColorEnemy
                end
                if hdist < closestH then closestH = hdist; closestIdx = idx; closestPx = px; closestPy = py; closestDotR = dotR end
                local dsh = ndArr(_radarO, "dotShadow", "Circle", idx)
                local sD = dsh[idx]
                if sD then
                    sD.Filled = true; sD.NumSides = 12; sD.Radius = dotR + 1
                    sD.Position = Vector2.new(px, py); sD.Color = BLACK
                    sD.Transparency = 0.6; sD.Visible = true
                end
                local dots = ndArr(_radarO, "dots", "Circle", idx)
                local d = dots[idx]
                if d then
                    d.Filled = filled
                    if not filled then d.Thickness = 1 end
                    d.NumSides = 12; d.Radius = dotR
                    d.Position = Vector2.new(px, py); d.Color = col
                    d.Transparency = 1; d.Visible = true
                end
                local chevs = ndArr(_radarO, "chev", "Triangle", idx)
                local cv = chevs[idx]
                if cv then
                    local dy = rp.Y - myPos.Y
                    if dy > 6 or dy < -6 then
                        local dir = dy > 6 and -1 or 1
                        cv.Filled = false
                        cv.PointA = Vector2.new(px, py + dir * (dotR + 4))
                        cv.PointB = Vector2.new(px - 3, py + dir * (dotR + 1))
                        cv.PointC = Vector2.new(px + 3, py + dir * (dotR + 1))
                        cv.Color = col; cv.Transparency = 1; cv.Visible = true
                    else cv.Visible = false end
                end
            end
        end
        local nearRing = nd(_radarO, "nearRing", "Circle")
        if nearRing then
            if closestIdx then
                local pulse = 1 + 0.28 * (0.5 + 0.5 * math.sin((ctx.now or 0) * 1.6 * math.pi * 2))
                nearRing.Filled = false; nearRing.Thickness = 1.2; nearRing.NumSides = 24
                nearRing.Radius = (closestDotR + 3) * pulse
                nearRing.Position = Vector2.new(closestPx, closestPy)
                nearRing.Color = Color3.fromRGB(255, 194, 75)
                nearRing.Transparency = 1; nearRing.Visible = true
            else
                nearRing.Visible = false
            end
        end
        if _radarO.dots      then for i = idx + 1, #_radarO.dots do _radarO.dots[i].Visible = false end end
        if _radarO.dotShadow then for i = idx + 1, #_radarO.dotShadow do _radarO.dotShadow[i].Visible = false end end
        if _radarO.chev      then for i = idx + 1, #_radarO.chev do _radarO.chev[i].Visible = false end end
        local selfTri = nd(_radarO, "self", "Triangle")
        if selfTri then
            selfTri.Filled = true
            selfTri.PointA = Vector2.new(cx, cy - 5)
            selfTri.PointB = Vector2.new(cx - 4, cy + 4)
            selfTri.PointC = Vector2.new(cx + 4, cy + 4)
            selfTri.Color = Color3.fromRGB(255, 194, 75); selfTri.Transparency = 1; selfTri.Visible = true
        end
        local rimShadow = nd(_radarO, "rimShadow", "Circle")
        if rimShadow then
            rimShadow.Filled = false; rimShadow.Thickness = 2; rimShadow.NumSides = 32; rimShadow.Radius = R
            rimShadow.Position = Vector2.new(cx, cy); rimShadow.Color = BLACK
            rimShadow.Transparency = 0.55; rimShadow.Visible = true
        end
        local rim = nd(_radarO, "rim", "Circle")
        if rim then
            rim.Filled = false; rim.Thickness = 1; rim.NumSides = 32; rim.Radius = R
            rim.Position = Vector2.new(cx, cy)
            rim.Color = Color3.fromRGB(168, 180, 192)
            rim.Transparency = 0.45; rim.Visible = true
        end
    end
    local function render()
        local _now = tick()
        local _dt  = _now - _lastRenderT
        if _now - _lastRenderT < 0.0083 then return end
        _lastRenderT = _now
        _espFrame = _espFrame + 1
        _createBudget = CREATE_BUDGET_PER_FRAME
        if not Config.ESP then
            State.PrimaryTarget = nil
            for _, o in pairs(State.ESPObjects) do hideAll(o, true) end
            for _, d in ipairs(_radarO.drawings) do d.Visible = false end
            for _, d in ipairs(_module.drawings) do d.Visible = false end
            return
        end
        local ctx = _ctx
        ctx.vp     = cam.ViewportSize
        ctx.myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        ctx.dt     = math.clamp(_dt, 0, 0.1)
        ctx.now    = _now
        ctx.threat = 0
        ctx.face   = faceFor(Config.ESPFont or "Code")
        local ts = (ctx.vp.Y / BASE_H) * (Config.ESPTextScale or 1)
        ctx.tsName = typePx(Config.ESPTextSize or 14, ts)
        ctx.tsInfo = typePx(Config.ESPInfoTextSize or 12, ts)
        ctx.tsHp   = typePx(Config.ESPHealthTextSize or 11, ts)
        ctx.tsChip = typePx(10, ts)
        ctx.casing = math.floor(math.clamp(Config.ESPTextCasing or 1, 0, 4))
        if Config.ESPDeclutter and (ctx.now - _dcLastT) >= 0.05 then
            _dcLastT = ctx.now; pcall(doDeclutter, ctx)
        end
        local cap = Config.ESPMaxPlayers or 0
        if cap and cap > 0 then
            local arr = _renderArr
            local n = 0
            local myPos = ctx.myRoot and ctx.myRoot.Position
            for player, o in pairs(State.ESPObjects) do
                n = n + 1
                local e = arr[n]; if not e then e = {}; arr[n] = e end
                e.p = player; e.o = o
                local rp = o.root and o.root.Parent and o.root.Position
                e.d = (myPos and rp) and (myPos - rp).Magnitude or math.huge
            end
            for i = #arr, n + 1, -1 do arr[i] = nil end
            pcall(table.sort, arr, _byDist)
            if Config.ESPPrimaryEmphasis or Config.ESPLockChevron or Config.FXTargetInfo then
                for i = 1, n do arr[i].o._primary = false end
                local bestO = arr[1] and arr[1].o
                local bestD = (arr[1] and arr[1].d) or math.huge
                local lockO, lockD
                for i = 1, n do if arr[i].o == _lock.obj then lockO = arr[i].o; lockD = arr[i].d; break end end
                local locked = resolveLock(bestO, bestD, lockO, lockD, ctx.now)
                State.PrimaryTarget = nil
                if locked then
                    locked._primary = true
                    for i = 1, n do if arr[i].o == locked then State.PrimaryTarget = arr[i].p break end end
                end
            else
                State.PrimaryTarget = nil
            end
            for i = 1, n do
                local e = arr[i]
                if i <= cap then
                    e.o._dist = e.d
                    pcall(renderPlayer, e.p, e.o)
                else
                    hideAll(e.o)
                end
            end
        else
            if Config.ESPPrimaryEmphasis or Config.ESPLockChevron or Config.FXTargetInfo then
                local myPos = ctx.myRoot and ctx.myRoot.Position
                local bestD, bestO = math.huge, nil
                local lockO, lockD
                for player, o in pairs(State.ESPObjects) do
                    o._primary = false
                    local rp = o.root and o.root.Parent and o.root.Position
                    local d = (myPos and rp) and (myPos - rp).Magnitude or math.huge
                    if d < bestD then bestD = d; bestO = o end
                    if o == _lock.obj then lockO = o; lockD = d end
                end
                local locked = resolveLock(bestO, bestD, lockO, lockD, ctx.now)
                State.PrimaryTarget = nil
                if locked then
                    locked._primary = true
                    for player, o in pairs(State.ESPObjects) do
                        if o == locked then State.PrimaryTarget = player break end
                    end
                end
            else
                State.PrimaryTarget = nil
            end
            for player, o in pairs(State.ESPObjects) do
                o._dist = nil
                pcall(renderPlayer, player, o)
            end
        end
        pcall(renderRadar, ctx)
        if Config.ESPThreatCount then
            pcall(function()
                local t = nd(_module, "threat", "Text")
                if t then
                    local cnt = ctx.threat or 0
                    if cnt > 0 then
                        t.Font = 3; t.Size = 14; t.Center = true; t.Outline = true
                        t.Color = Config.ColorEnemy
                        t.Text = cnt .. " <"
                        t.Position = Vector2.new(math.floor(ctx.vp.X * 0.5), math.floor(ctx.vp.Y * 0.5 + 28))
                        t.Transparency = 1; t.Visible = true
                    else t.Visible = false end
                end
            end)
        elseif _module.threat then _module.threat.Visible = false end
    end
    function ESP.init()
        for _, p in ipairs(getSafePlayers()) do
            if p ~= lp then
                p.CharacterAdded:Connect(function()
                    task.wait(0.5); if Config.ESP then buildESP(p) end
                end)
            end
        end
        Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                task.wait(0.5); if Config.ESP then buildESP(p) end
            end)
        end)
        Players.PlayerRemoving:Connect(function(p) cleanESP(p) end)
        if Config.ESP and not _renderConn then
            _renderConn = RunService.RenderStepped:Connect(render)
            ESP.rebuildAll()
        end
    end
    function ESP.enable()
        Config.ESP = true; ESP.rebuildAll()
        if not _renderConn then _renderConn = RunService.RenderStepped:Connect(render) end
    end
    function ESP.disable()
        Config.ESP = false; ESP.rebuildAll()
        State.PrimaryTarget = nil
        if _renderConn then _renderConn:Disconnect(); _renderConn = nil end
    end
    function ESP.unload()
        if _renderConn then _renderConn:Disconnect(); _renderConn = nil end
        State.PrimaryTarget = nil
        for p in pairs(State.ESPObjects) do cleanESP(p) end
        for _, pool in ipairs({ _radarO, _module }) do
            for _, d in ipairs(pool.drawings) do
                pcall(function() if d.Remove then d:Remove() end end)
            end
            pool.drawings = {}
            pool.disc, pool.rim, pool.self, pool.dots, pool.chev, pool.threat = nil, nil, nil, nil, nil, nil
            pool.rangeRing, pool.ticks, pool.dotShadow, pool.rimShadow, pool.nearRing = nil, nil, nil, nil, nil
            pool.grid, pool.sweep = nil, nil
        end
        if _gui then pcall(function() _gui:Destroy() end); _gui = nil; _absLayer = nil end
    end
end)()
local UtilESP = {}
do
    local hasDrawing = screenDraw ~= nil
    local BLACK = Color3.new(0, 0, 0)
    local C_RED  = Color3.fromRGB(255, 59, 78)
    local C_GOLD = Color3.fromRGB(255, 194, 75)
    local C_CYAN  = Color3.fromRGB(53, 215, 199)
    local C_TEXT1 = Color3.fromRGB(243, 246, 250)
    local KINDS = {
        { k = "tripmine",  label = "TRIPMINE",  color = C_GOLD, danger = true  },
        { k = "grenade",   label = "GRENADE",   color = C_RED,  danger = true  },
        { k = "molotov",   label = "MOLOTOV",   color = C_RED,  danger = true  },
        { k = "satchel",   label = "SATCHEL",   color = C_RED,  danger = true  },
        { k = "flashbang", label = "FLASHBANG", color = C_GOLD, danger = true  },
        { k = "warpstone", label = "WARPSTONE", color = C_CYAN, danger = false },
    }
    local _items = {}
    local _addConn, _renderConn = nil, nil
    local _lastT = 0
    local function matchKind(name)
        local n = string.lower(name)
        for _, kd in ipairs(KINDS) do
            if string.find(n, kd.k, 1, true) then return kd end
        end
        return nil
    end
    local function isWorldItem(inst)
        local a = inst.Parent
        while a and a ~= Workspace do
            local nm = a.Name
            if nm == "ViewModels" then return false end
            if Players:GetPlayerFromCharacter(a) then return false end
            a = a.Parent
        end
        return a == Workspace
    end
    local function rootOf(inst)
        if inst:IsA("BasePart") then return inst end
        if inst:IsA("Model") then
            return inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart")
        end
        return nil
    end
    local function drop(inst)
        local it = _items[inst]
        if not it then return end
        for _, key in ipairs({ "dot", "dotB", "ring", "label" }) do
            local d = it[key]
            if d then pcall(function() d:Remove() end) end
        end
        _items[inst] = nil
    end
    local function track(inst)
        if _items[inst] then return end
        if not (inst:IsA("Model") or inst:IsA("BasePart")) then return end
        local kd = matchKind(inst.Name)
        if not kd then return end
        if not isWorldItem(inst) then return end
        local root = rootOf(inst)
        if not root then
            task.delay(0.1, function()
                if inst.Parent and not _items[inst] then
                    local r2 = rootOf(inst)
                    if r2 then _items[inst] = { root = r2, kind = kd } end
                end
            end)
            return
        end
        _items[inst] = { root = root, kind = kd }
    end
    local function hideItem(it)
        if it.dot   then it.dot.Visible   = false end
        if it.dotB  then it.dotB.Visible  = false end
        if it.ring  then it.ring.Visible  = false end
        if it.label then it.label.Visible = false end
    end
    local function render()
        local now = tick()
        if now - _lastT < 0.033 then return end
        _lastT = now
        if not Config.UtilityESP or not hasDrawing then return end
        local cam = Camera; if not cam then return end
        local myC = lp.Character
        local myR = myC and myC:FindFirstChild("HumanoidRootPart")
        local maxD = Config.UtilityESPMaxDistance or 250
        for inst, it in pairs(_items) do
            if not inst.Parent or not it.root or not it.root.Parent then
                drop(inst)
            else
                local pos = it.root.Position
                local d = myR and (myR.Position - pos).Magnitude
                    or (cam.CFrame.Position - pos).Magnitude
                local sp, on = cam:WorldToViewportPoint(pos)
                if d <= maxD and on and sp.Z > 0 then
                    local col = it.kind.color
                    local p = Vector2.new(sp.X, sp.Y)
                    local r = math.clamp(4 - (d / maxD) * 2, 2, 4)
                    if not it.dotB then it.dotB = screenDraw("Circle") end
                    if it.dotB then
                        it.dotB.Filled = true; it.dotB.NumSides = 12; it.dotB.Radius = r + 1
                        it.dotB.Position = p; it.dotB.Color = BLACK
                        it.dotB.Transparency = 0.7; it.dotB.Visible = true
                    end
                    if not it.dot then it.dot = screenDraw("Circle") end
                    if it.dot then
                        it.dot.Filled = true; it.dot.NumSides = 12; it.dot.Radius = r
                        it.dot.Position = p; it.dot.Color = col
                        it.dot.Transparency = 1; it.dot.Visible = true
                    end
                    if it.kind.danger and Config.UtilityESPRing then
                        if not it.ring then it.ring = screenDraw("Circle") end
                        if it.ring then
                            local pulse = 0.5 + 0.5 * math.sin(now * 1.6 * math.pi * 2)
                            it.ring.Filled = false; it.ring.NumSides = 20
                            it.ring.Thickness = 1.5
                            it.ring.Radius = r + 4 + 5 * pulse
                            it.ring.Position = p; it.ring.Color = col
                            it.ring.Transparency = 1 - 0.55 * pulse
                            it.ring.Visible = true
                        end
                    elseif it.ring then it.ring.Visible = false end
                    if Config.UtilityESPLabels then
                        if not it.label then
                            it.label = screenDraw("Text")
                            if it.label then
                                it.label.Center = true; it.label.Outline = true
                                it.label.Font = 2; it.label.Size = 12
                            end
                        end
                        if it.label then
                            it.label.Text = it.kind.label .. " · " .. math.floor(d + 0.5) .. "m"
                            it.label.Position = Vector2.new(math.floor(sp.X), math.floor(sp.Y - 22))
                            it.label.Color = C_TEXT1
                            it.label.Transparency = 1
                            it.label.Visible = true
                        end
                    elseif it.label then it.label.Visible = false end
                else
                    hideItem(it)
                end
            end
        end
    end
    local function connect()
        if not _addConn then
            _addConn = Workspace.DescendantAdded:Connect(function(inst)
                if not Config.UtilityESP then return end
                if not (inst:IsA("Model") or inst:IsA("BasePart")) then return end
                if not matchKind(inst.Name) then return end
                task.defer(track, inst)
            end)
        end
        if not _renderConn then
            _renderConn = RunService.RenderStepped:Connect(function() pcall(render) end)
        end
    end
    local function disconnect()
        if _addConn then _addConn:Disconnect(); _addConn = nil end
        if _renderConn then _renderConn:Disconnect(); _renderConn = nil end
    end
    local function sweepExisting()
        for _, inst in ipairs(Workspace:GetDescendants()) do
            if inst:IsA("Model") or inst:IsA("BasePart") then
                if matchKind(inst.Name) then pcall(track, inst) end
            end
        end
    end
    function UtilESP.enable()
        Config.UtilityESP = true
        connect()
        task.spawn(sweepExisting)
    end
    function UtilESP.disable()
        Config.UtilityESP = false
        disconnect()
        for inst in pairs(_items) do drop(inst) end
    end
    function UtilESP.init()
        if Config.UtilityESP then pcall(UtilESP.enable) end
    end
    function UtilESP.unload()
        pcall(UtilESP.disable)
    end
end
local Lab = {}
do
    local _gui, _label, _conn, _hpConn, _caConn
    local s = {
        lastT = 0, lastShots = 0, lastEvents = 0,
        taken = 0, takenAtk = 0, takenHide = 0, takenReload = 0, takenTrans = 0,
        sps = 0, eps = 0,
        stT = {}, stTotal = 0, stLast = 0,
    }
    local function combatState()
        if State.RageTranslocating then return "TRANS" end
        if Config.RageVoidPhase and State.RageVoidActive then return "HIDE" end
        if State.RageFiring then return "ATTACK" end
        local item = getEquippedItem()
        if item then
            if (item._reload_cooldown or 0) > tick() then return "RELOAD" end
            local okA, ammo = pcall(function() return item:Get("Ammo") end)
            if okA and type(ammo) == "number" and ammo <= 0 then return "RELOAD" end
        end
        return "OUT"
    end
    local function enemyDesync()
        local t = State.Target;        if not t then return 0 end
        local buf = State.RageBacktrackBuf[t]; if not buf or #buf < 3 then return 0 end
        local sum, n = 0, 0
        for i = math.max(2, #buf - 8), #buf do
            sum = sum + (buf[i].pos - buf[i - 1].pos).Magnitude; n = n + 1
        end
        return n > 0 and sum / n or 0
    end
    local function selfDesync()
        local c = lp.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        return root and (root.Position - Camera.CFrame.Position).Magnitude or 0
    end
    local function pct(p, w) return w > 0 and math.floor(p / w * 100 + 0.5) or 0 end
    local function restoreLabel()
        if State.RageGlueBound and State.RageGumMode == "on" then
            return "GUM on (kerp, movement live)"
        end
        if State.RageGlueBound and State.RageGumMode == "lite" then
            return "GUM lite + " .. tostring(Config.RageRestoreMode)
        end
        local m = Config.RageRestoreMode
        if m == "kicia" or m == "kerp" then return "kerp (forced, LEAKS unglued)" end
        if m == "render" then return "render-only (forced)" end
        if m == "auto" then
            local eff = State.RageAutoTransport or "kicia"
            if eff == "render" then
                return "auto -> render (" .. tostring(State.RageTransportSwitches or 0) .. " switches)"
            end
            return "auto -> kerp" .. (State.RageGlueBound and "" or ", LEAKS unglued")
                .. " (" .. tostring(State.RageTransportSwitches or 0) .. " switches)"
        end
        return "none (S27, no movement)"
    end
    local function hookSelfHP()
        local c = lp.Character
        local h = c and c:FindFirstChildOfClass("Humanoid"); if not h then return end
        if _hpConn then _hpConn:Disconnect() end
        local last = h.Health
        _hpConn = h.HealthChanged:Connect(function(new)
            if new < last - 0.5 then
                local d, st = last - new, combatState()
                s.taken = s.taken + d
                if st == "ATTACK" then s.takenAtk = s.takenAtk + d
                elseif st == "TRANS" then s.takenTrans = s.takenTrans + d
                elseif st == "RELOAD" then s.takenReload = s.takenReload + d
                else s.takenHide = s.takenHide + d end
            end
            last = new
        end)
    end
    function Lab.reset()
        s.taken, s.takenAtk, s.takenHide, s.takenReload, s.takenTrans = 0, 0, 0, 0, 0
        s.stT, s.stTotal, s.stLast = {}, 0, 0
        State.RageDealtTotal = 0
    end
    function Lab.enable()
        Config.RageLab = true
        if not _gui then
            _gui = Instance.new("ScreenGui")
            _gui.Name = "_lh_lab"; _gui.ResetOnSpawn = false; _gui.IgnoreGuiInset = true
            local ok = pcall(function() _gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
            if not ok then _gui.Parent = lp:WaitForChild("PlayerGui") end
            _label = Instance.new("TextLabel")
            _label.Position = UDim2.fromOffset(14, 120)
            _label.Size = UDim2.fromOffset(640, 304)
            _label.BackgroundColor3 = Color3.fromRGB(8, 10, 16)
            _label.BackgroundTransparency = 0.2
            _label.TextColor3 = Color3.fromRGB(0, 230, 160)
            _label.Font = Enum.Font.Code; _label.TextSize = 14
            _label.TextXAlignment = Enum.TextXAlignment.Left
            _label.TextYAlignment = Enum.TextYAlignment.Top
            _label.Text = "LAB"; _label.Parent = _gui
        end
        _gui.Enabled = true
        s.lastT = tick(); s.lastShots = State.Shots; s.lastEvents = State.Hits
        s.stT, s.stTotal, s.stLast = {}, 0, 0
        hookSelfHP()
        if _caConn then _caConn:Disconnect() end
        _caConn = lp.CharacterAdded:Connect(function() task.wait(0.3); if Config.RageLab then hookSelfHP() end end)
        if _conn then _conn:Disconnect() end
        _conn = RunService.Heartbeat:Connect(function()
            if not Config.RageLab then return end
            local now = tick()
            if s.stLast > 0 then
                local slice = now - s.stLast
                local k = tostring(State.RageStatus or "Idle")
                s.stT[k] = (s.stT[k] or 0) + slice
                s.stTotal = s.stTotal + slice
            end
            s.stLast = now
            local dt = now - s.lastT
            if dt < 0.25 then return end
            s.lastT = now
            s.sps = math.floor((State.Shots - s.lastShots) / dt)
            s.eps = (State.Hits - s.lastEvents) / dt
            s.lastShots = State.Shots; s.lastEvents = State.Hits
            local dealt = math.floor(State.RageDealtTotal or 0)
            local taken = math.floor(s.taken)
            local ratio = taken > 0 and (dealt / taken) or (dealt > 0 and 999 or 0)
            local sd = selfDesync()
            local sdStr = isSanePos((lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position) or Vector3.zero)
                and string.format("%d studs", math.floor(sd)) or "VOID!! (flung)"
            local cheaters = 0
            for _, pl in ipairs(getSafePlayers()) do
                if pl ~= lp and Rage._isCheater and Rage._isCheater(pl) then cheaters = cheaters + 1 end
            end
            local tgtTag = (State.Target and Rage._isCheater and Rage._isCheater(State.Target)) and "  <<CHEATER>>" or ""
            local top = "-"
            if s.stTotal > 0 then
                local names = {}
                for k in s.stT do
                    names[#names + 1] = k
                end
                table.sort(names, function(a, b) return s.stT[a] > s.stT[b] end)
                top = ""
                for i = 1, math.min(3, #names) do
                    top = top .. string.format("%s %d%%  ", names[i], pct(s.stT[names[i]], s.stTotal))
                end
            end
            _label.Text = string.format(
                "── LUAHOOK LAB ──\n"
                .. "state: %-6s   self-desync: %s\n"
                .. "enemy desync: %.1f studs/frame%s\n"
                .. "cheaters detected: %d\n"
                .. "fire: %d shots/s   hit-events/s: %.1f\n"
                .. "DEALT: %d   TAKEN: %d   trade x%.2f\n"
                .. "we die while:\n"
                .. "  ATTACK %d (%d%%)  TRANS %d (%d%%)  HIDE %d (%d%%)  RELOAD %d (%d%%)\n"
                .. "BLANK %d   below-plane %d f / %d deaths   DRIFT %d f (%d st, y%+d)  CLAMP %d\n"
                .. "BAIT %d   VOIDFIRE %d   POISON %d   PREFIRE %d\n"
                .. "  dip held %d f   refused %d   ring %d\n"
                .. "  NOFIRE %d f\n"
                .. "  ident %s   ammo? %d\n"
                .. "PREDICT %s  hide %.2fs(%d)  atk %.2fs(%d)  %s %.2fs  due %+.2fs  W:%s  |pos| %s\n"
                .. "LEAK %d   TRACER %d\n"
                .. "LATCH %d (%.1f st)   ORDER %d   OOB-park %d\n"
                .. "phys %s  raw %s  RESTORE %s\n"
                .. "SERVER: on %d  off %d   last off: %.0fst from me / %.0fst from target\n"
                .. "KNIFE: %d swings   %s\n"
                .. "TIME(%ds): %s",
                combatState(), sdStr, enemyDesync(), tgtTag, cheaters,
                s.sps, s.eps, dealt, taken, ratio,
                math.floor(s.takenAtk), pct(s.takenAtk, s.taken),
                math.floor(s.takenTrans), pct(s.takenTrans, s.taken),
                math.floor(s.takenHide), pct(s.takenHide, s.taken),
                math.floor(s.takenReload), pct(s.takenReload, s.taken),
                State.RageBlankCanary or 0,
                State.RageBelowPlaneFrames or 0, State.RageBelowPlaneDeaths or 0,
                State.RageParkDriftFrames or 0, State.RageParkDrift or 0, State.RageParkDriftY or 0,
                State.RageParkClampFrames or 0,
                State.RageTranslocateBaits or 0, State.RageVoidFires or 0,
                State.RagePoisonBlips or 0, State.RagePreFires or 0,
                State.RageBaitHoldFrames or 0, State.RageBaitPinRefused or 0,
                State.RageBaitRingFallbacks or 0,
                State.RageFireZeroFrames or 0,
                tostring(State.IdentitySafe), State.RageAmmoUnreadable or 0,
                tostring(State.RagePredTarget or "-"),
                State.RagePredHide or 0, State.RagePredHideN or 0,
                State.RagePredAtk or 0, State.RagePredAtkN or 0,
                tostring(State.RagePredPhase or "?"), State.RagePredFor or 0,
                State.RagePredDue or 0,
                (State.RagePredWindow and "YES" or "no"),
                string.format("%.3g", State.RagePredMag or 0),
                State.RageLeakCanary or 0, State.RageTracerCanary or 0,
                State.RageParkLatchCanary or 0, State.RageLatchStuds or 0,
                State.RageOrderCanary or 0, State.RageOOBParkCanary or 0,
                tostring(State.RagePhysRate or "off"), tostring(State.RageRawSet == true), restoreLabel(),
                State.RageHitsOn or 0, State.RageHitsOff or 0,
                State.RageOffFromSelf or 0, State.RageOffFromTarget or 0,
                State.RageKnifeSwings or 0, tostring(State.RageKnifeStatus or "idle"),
                math.floor(s.stTotal), top)
        end)
    end
    function Lab.disable()
        Config.RageLab = false
        if _gui then _gui.Enabled = false end
        if _conn then _conn:Disconnect(); _conn = nil end
        if _hpConn then _hpConn:Disconnect(); _hpConn = nil end
        if _caConn then _caConn:Disconnect(); _caConn = nil end
    end
    function Lab.init() end
end
local GameVisuals = {}
GameVisuals.uiAlive = true
;(function()
    local NONE_COSMETIC   = "NONE_COSMETIC"
    local RANDOM_COSMETIC = "RANDOM_COSMETIC"
    local POLL_S = 0.35
    local REBUILD_COOLDOWN = 1.5
    local captureInstall, captureRestore
    local saveSoon, saveDrain
    local _log, _lastNote = {}, nil
    local function note(msg)
        State.GVStatus = msg
        if msg == _lastNote then return end
        _lastNote = msg
        table.insert(_log, os.date("%H:%M:%S") .. "  " .. msg)
        if #_log > 60 then table.remove(_log, 1) end
    end
    function GameVisuals.history(n)
        local out = {}
        local want = n or 12
        for i = #_log, math.max(1, #_log - want + 1), -1 do table.insert(out, _log[i]) end
        if #out == 0 then table.insert(out, "nothing yet") end
        return out
    end
    local ENUM = {}
    local function enumOf(key)
        if ENUM[key] ~= nil then return ENUM[key] end
        local e = nil
        pcall(function() e = Rivals.Enums:ToEnum(key) end)
        ENUM[key] = e
        return e
    end
    local M = { cvm = nil, ci = nil, pdc = nil, fctrl = nil, ilib = nil, cent = nil,
                cslot = nil, copts = nil, shop = nil }
    local function moduleAt(path)
        local m = nil
        pcall(function() m = loadGameModule(lp.PlayerScripts, path) end)
        return m
    end
    local function repModuleAt(path)
        local m = nil
        pcall(function() m = loadGameModule(ReplicatedStorage, path) end)
        return m
    end
    local _resolving, _resolveAt, _optTries = false, 0, 0
    local function resolveModules()
        if M.cvm ~= nil and M.ci ~= nil and M.pdc ~= nil and _optTries >= 3 then return end
        if M.cvm ~= nil and M.ci ~= nil and M.pdc ~= nil and M.cslot ~= nil
            and M.copts ~= nil and M.shop ~= nil then return end
        if _resolving then return end
        local now = tick()
        if now < _resolveAt then return end
        _resolveAt = now + 5
        _resolving = true
        if M.cvm == nil then
            M.cvm = moduleAt({"Modules","ClientReplicatedClasses","ClientFighter","ClientItem","ClientViewModel"})
        end
        if M.ci   == nil then M.ci   = moduleAt({"Modules","ClientReplicatedClasses","ClientFighter","ClientItem"}) end
        if M.cent == nil then M.cent = moduleAt({"Modules","ClientReplicatedClasses","ClientEntity"}) end
        if M.pdc  == nil then M.pdc  = moduleAt({"Controllers","PlayerDataController"}) end
        if _optTries < 3 then
            _optTries = _optTries + 1
            if M.cslot == nil then M.cslot = moduleAt({"Modules","CosmeticSlot"}) end
            if M.copts == nil then
                M.copts = moduleAt({"Modules","UserInterface","Equipment","Interface","Customize","Options"})
            end
            if M.shop  == nil then M.shop  = repModuleAt({"Modules","ShopLibrary"}) end
            if M.seasonLib == nil then M.seasonLib = repModuleAt({"Modules","SeasonLibrary"}) end
            if M.emoteCtl == nil then M.emoteCtl = moduleAt({"Controllers","EmoteController"}) end
        end
        if M.fctrl == nil then M.fctrl = Rivals.Fighter end
        if M.ilib  == nil then M.ilib  = Rivals.ItemLib end
        _resolving = false
    end
    GameVisuals.Choices = {}
    local function selectionFor(itemName)
        return GameVisuals.Choices[itemName]
    end
    local _maskTarget, _maskInner, _maskConn = nil, nil, nil
    local _spoof = {}
    local _favOverride = {}
    local _rsPatch, _captured, _captureBound = {}, 0, 0
    local DECOY, _lastFn = nil, nil
    local _saveAt, _fsWarned = nil, false
    local function maskActive()
        if _maskTarget == nil then return false end
        local cur = nil
        pcall(function() cur = M.pdc.CurrentData end)
        return cur == _maskTarget
    end
    local function maskRemove()
        if _maskTarget == nil then return end
        local target, inner = _maskTarget, _maskInner
        _maskTarget, _maskInner = nil, nil
        pcall(function() rawset(target, "Data", inner) end)
    end
    local function maskInstall()
        resolveModules()
        if M.pdc == nil then return false, "PlayerDataController did not resolve" end
        local cur = nil
        pcall(function() cur = M.pdc.CurrentData end)
        if cur == nil then return false, "no CurrentData yet (still loading)" end
        if cur == _maskTarget then return true, nil end
        maskRemove()
        local inner = rawget(cur, "Data")
        if type(inner) ~= "table" then return false, "CurrentData.Data is not a table" end
        local proxy = setmetatable({}, {
            __index = function(_, k)
                local p = _spoof[k]
                if p ~= nil then return p(inner[k]) end
                return inner[k]
            end,
            __newindex = function(_, k, v) inner[k] = v end,
            __iter = function() return next, inner end,
            __len  = function() return #inner end,
        })
        rawset(cur, "Data", proxy)
        _maskTarget, _maskInner = cur, inner
        return true, nil
    end
    local function refresh(key)
        pcall(function()
            local cur = M.pdc.CurrentData
            if cur ~= nil then cur:Replicate(key) end
        end)
    end
    local function refreshAll()
        refresh("CosmeticInventory")
        refresh("FavoritedCosmetics")
        refresh("WeaponInventory")
        refresh("EquippedEmotes")
    end
    local function everyCosmetic(real)
        local out = {}
        if type(real) == "table" then
            for k, v in pairs(real) do out[k] = v end
        end
        pcall(function()
            local cos = Rivals.Cosmetics.Cosmetics
            if type(cos) ~= "table" then return end
            for name, entry in pairs(cos) do
                if type(entry) == "table" and out[name] == nil then out[name] = true end
            end
        end)
        return out
    end
    local function everyFavorite(real)
        local out = {}
        if type(real) == "table" then
            for k, v in pairs(real) do out[k] = v end
        end
        for weapon, marks in pairs(_favOverride) do
            local merged = {}
            if type(out[weapon]) == "table" then
                for k, v in pairs(out[weapon]) do merged[k] = v end
            end
            for k, v in pairs(marks) do merged[k] = v end
            out[weapon] = merged
        end
        return out
    end
    local function mergeChoices(entry, weapon)
        local slot = GameVisuals.Choices[weapon]
        if slot == nil then return entry end
        for _, kind in pairs({ "Skin", "Charm", "Wrap", "Finisher" }) do
            local sel = slot[kind]
            if sel ~= nil then
                if sel.Name == NONE_COSMETIC then
                    entry[kind] = nil
                elseif sel.Name == RANDOM_COSMETIC then
                    entry[kind] = sel
                else
                    entry[kind] = sel
                end
            end
        end
        return entry
    end
    local function ownableWeapons()
        local out = {}
        pcall(function()
            if M.shop == nil or type(M.shop.GetReleasedOwnableWeapons) ~= "function" then return end
            local list = M.shop:GetReleasedOwnableWeapons()
            if type(list) ~= "table" then return end
            for _, name in pairs(list) do
                if type(name) == "string" then table.insert(out, name) end
            end
        end)
        return out
    end
    local function weaponInventory(real)
        local out, seen = {}, {}
        if type(real) == "table" then
            for i, entry in pairs(real) do
                if type(entry) == "table" then
                    local copy = {}
                    for k, v in pairs(entry) do copy[k] = v end
                    if type(copy.Name) == "string" then
                        seen[copy.Name] = true
                        mergeChoices(copy, copy.Name)
                    end
                    out[i] = copy
                else
                    out[i] = entry
                end
            end
        end
        if Config.GVUnlockWeapons == true then
            for _, wname in pairs(ownableWeapons()) do
                if not seen[wname] then
                    seen[wname] = true
                    table.insert(out, mergeChoices(
                        { Name = wname, Level = 1, XP = 0, IsFavorited = false }, wname))
                end
            end
        end
        return out
    end
    local _emoteNames = nil
    local function emoteNames()
        if _emoteNames ~= nil then return _emoteNames end
        local out = {}
        pcall(function()
            local mods = ReplicatedStorage:FindFirstChild("Modules")
            local folder = mods and mods:FindFirstChild("Emotes")
            local cos = Rivals.Cosmetics and Rivals.Cosmetics.Cosmetics
            if folder == nil or type(cos) ~= "table" then return end
            for _, node in ipairs(folder:GetChildren()) do
                local e = cos[node.Name]
                if type(e) == "table" and e.Type == "Emote" then table.insert(out, node.Name) end
            end
        end)
        table.sort(out)
        _emoteNames = out
        return out
    end
    local function equippedEmotes(real)
        if Config.GVEmotes ~= true then return real end
        local names = emoteNames()
        if #names == 0 then return real end
        local out = {}
        if type(real) == "table" then
            for k, v in pairs(real) do out[k] = v end
        end
        local nexti = 1
        for slot = 1, 8 do
            local k = tostring(slot)
            if out[k] == nil then
                out[k] = { Name = names[nexti] }
                nexti = nexti + 1
                if nexti > #names then break end
            end
        end
        return out
    end
    local function applyMaskFields()
        if Config.GVUnlockAll == true then
            _spoof.CosmeticInventory = everyCosmetic
        else
            _spoof.CosmeticInventory = nil
        end
        if Config.GVUnlockAll == true or next(_favOverride) ~= nil then
            _spoof.FavoritedCosmetics = everyFavorite
        else
            _spoof.FavoritedCosmetics = nil
        end
        if next(GameVisuals.Choices) ~= nil or Config.GVUnlockWeapons == true then
            _spoof.WeaponInventory = weaponInventory
        else
            _spoof.WeaponInventory = nil
        end
        if Config.GVEmotes == true then
            _spoof.EquippedEmotes = equippedEmotes
        else
            _spoof.EquippedEmotes = nil
        end
    end
    local function maskNeeded()
        return Config.GVUnlockAll == true or Config.GVUnlockWeapons == true
            or Config.GVEmotes == true
            or next(GameVisuals.Choices) ~= nil or next(_favOverride) ~= nil
    end
    local function watchPlayerData()
        if _maskConn ~= nil then return end
        pcall(function()
            local sig = M.pdc.PlayerDataAdded
            if sig == nil then return end
            _maskConn = sig:Connect(function()
                if not maskNeeded() then return end
                task.defer(function()
                    if maskInstall() then
                        applyMaskFields()
                        refreshAll()
                    end
                end)
            end)
        end)
    end
    local function syncMask()
        applyMaskFields()
        if not maskNeeded() then
            maskRemove()
            refreshAll()
            return true, nil
        end
        local ok, why = maskInstall()
        if not ok then return false, why end
        watchPlayerData()
        refreshAll()
        return true, nil
    end
    function GameVisuals.setUnlockAll(on)
        Config.GVUnlockAll = (on == true)
        local ok, why = syncMask()
        if ok then
            note("unlock all " .. tostring(Config.GVUnlockAll))
        else
            note("unlock all: " .. tostring(why))
        end
    end
    function GameVisuals.syncEmotes(on)
        Config.GVEmotes = (on == true)
        pcall(syncMask)
    end
    function GameVisuals.setUnlockWeapons(on)
        Config.GVUnlockWeapons = (on == true)
        local ok, why = syncMask()
        if ok then
            note("unlock weapons " .. tostring(Config.GVUnlockWeapons))
        else
            note("unlock weapons: " .. tostring(why))
        end
    end
    local function charmMetadata(charmName)
        if type(charmName) ~= "string" or string.match(charmName, "^Season %d+$") == nil then return nil end
        return GameVisuals.resolveRankStamp()
    end
    local function cloneCosmetic(name, ctype, inverted)
        local base = nil
        pcall(function() base = Rivals.Cosmetics.Cosmetics[name] end)
        if type(base) ~= "table" then return nil end
        local data = {}
        for k, v in pairs(base) do data[k] = v end
        data.Name = name
        if data.Type == nil then data.Type = ctype end
        data.Seed = math.random(1, 1000000)
        local id = enumOf(name)
        if id ~= nil then
            data.Enum     = id
            data.ObjectID = id
        end
        if inverted == true then data.Inverted = true end
        if ctype == "Charm" then
            local md = charmMetadata(name)
            if md ~= nil then data.Metadata = md end
        end
        return data
    end
    local function rankOverrideRecord(liveCharm)
        if Config.GVRankCharmOn ~= true then return nil end
        local nm = nil
        if type(liveCharm) == "table" then nm = liveCharm.Name end
        local want = charmMetadata(nm)
        if want == nil then return nil end
        local have = (type(liveCharm) == "table") and liveCharm.Metadata or nil
        if have ~= nil and have.SeasonELO == want.SeasonELO
            and have.SeasonLeaderboardRank == want.SeasonLeaderboardRank then
            return nil
        end
        return cloneCosmetic(nm, "Charm")
    end
    local function randomCosmetic(ctype, weapon, inverted)
        local pool = {}
        pcall(function()
            local cos = Rivals.Cosmetics.Cosmetics
            local inv = M.pdc and M.pdc:Get("CosmeticInventory")
            if type(cos) ~= "table" then return end
            for name, entry in pairs(cos) do
                if type(entry) == "table" and entry.Type == ctype and entry.Hidden ~= true then
                    local owned = true
                    pcall(function() owned = Rivals.Cosmetics:OwnsCosmetic(inv, name, weapon) and true or false end)
                    if owned and (ctype ~= "Skin" or entry.ItemName == weapon) then
                        table.insert(pool, name)
                    end
                end
            end
        end)
        if #pool == 0 then return nil end
        return cloneCosmetic(pool[math.random(#pool)], ctype, inverted)
    end
    local function resolveSel(weapon, ctype)
        local slot = GameVisuals.Choices[weapon]
        local sel = slot and slot[ctype]
        if sel == nil then return nil end
        if sel.Name == NONE_COSMETIC then return nil end
        if sel.Name == RANDOM_COSMETIC then
            if sel.Resolved == nil then
                sel.Resolved = randomCosmetic(ctype, weapon, sel.Inverted)
            end
            return sel.Resolved
        end
        return sel
    end
    local function hasIntent(weapon, ctype)
        local slot = GameVisuals.Choices[weapon]
        return slot ~= nil and slot[ctype] ~= nil
    end
    local function buildPayload(weapon, dst, key)
        if hasIntent(weapon, "Skin") then
            local s = resolveSel(weapon, "Skin")
            dst[key("Name")] = (s ~= nil) and s.Name or weapon
        end
        if hasIntent(weapon, "Wrap") then
            dst[key("Wrap")] = resolveSel(weapon, "Wrap")
        end
        if hasIntent(weapon, "Charm") then
            dst[key("Charm")] = resolveSel(weapon, "Charm")
        end
        return dst
    end
    local function identityKey(k) return k end
    local HOOKS = {}
    local function hookField(tbl, key, make)
        if tbl == nil then return false end
        local orig = nil
        pcall(function() orig = tbl[key] end)
        if type(orig) ~= "function" then return false end
        for _, h in pairs(HOOKS) do
            if h.tbl == tbl and h.key == key then return true end
        end
        local inherited = false
        pcall(function() inherited = (rawget(tbl, key) == nil) end)
        local ok = false
        pcall(function()
            tbl[key] = make(orig)
            ok = true
        end)
        if not ok then return false end
        table.insert(HOOKS, { tbl = tbl, key = key, orig = orig, inherited = inherited })
        return true
    end
    local function hooksRestore()
        for i = #HOOKS, 1, -1 do
            local h = HOOKS[i]
            pcall(function()
                if h.inherited then
                    h.tbl[h.key] = nil
                else
                    h.tbl[h.key] = h.orig
                end
            end)
            HOOKS[i] = nil
        end
    end
    local function origOf(tbl, key)
        if tbl == nil then return nil end
        for _, h in pairs(HOOKS) do
            if h.tbl == tbl and h.key == key then return h.orig end
        end
        local fn = nil
        pcall(function() fn = tbl[key] end)
        return fn
    end
    local function ownedByUs(item)
        local owner = nil
        pcall(function() owner = item.ClientFighter.Player end)
        if owner == lp then return true end
        if Config.GVEveryone == true and owner ~= nil then return true end
        return false
    end
    local function enumKey(k)
        local e = enumOf(k)
        if e ~= nil then return e end
        return k
    end
    local function styleSerial(serial, weapon)
        if type(serial) ~= "table" or type(weapon) ~= "string" then return false end
        if selectionFor(weapon) == nil then return false end
        local touched = false
        pcall(function()
            local dk = enumOf("Data")
            local slot = nil
            if dk ~= nil and type(serial[dk]) == "table" then
                slot = serial[dk]
            elseif type(serial.Data) == "table" then
                slot = serial.Data
            end
            if slot == nil then return end
            buildPayload(weapon, slot, enumKey)
            touched = true
        end)
        return touched
    end
    local _building = nil
    local _oidWeapon, _oidAt = {}, 0
    local function atIdentity2(fn)
        return pcall(fn)
    end
    local function bareFirst(fn)
        if pcall(fn) then return true end
        atIdentity2(fn)
        return false
    end
    local FINISHER_FOLDER = nil
    local function finisherFolder()
        if FINISHER_FOLDER == nil then
            pcall(function() FINISHER_FOLDER = ReplicatedStorage.Modules.Finishers end)
        end
        return FINISHER_FOLDER
    end
    local function cloneCharacter(model)
        local copy = nil
        pcall(function()
            local was = model.Archivable
            model.Archivable = true
            copy = model:Clone()
            model.Archivable = was
        end)
        return copy
    end
    local function hideCorpse(model)
        pcall(function()
            for _, d in pairs(model:GetDescendants()) do
                if d:IsA("BasePart") then d.Transparency = 1
                elseif d:IsA("Decal") then d:Destroy()
                elseif d:IsA("BillboardGui") then d.Enabled = false end
            end
        end)
    end
    local _finisherCopies = setmetatable({}, { __mode = "k" })
    local function playFinisherOnClone(ent, model, mod, isFinal, killer, serial)
        local copy = cloneCharacter(model)
        if copy == nil then return false end
        local hum, root = nil, nil
        pcall(function()
            hum  = copy:FindFirstChildOfClass("Humanoid")
            root = copy:FindFirstChild("HumanoidRootPart")
        end)
        if hum == nil or root == nil then
            pcall(function() copy:Destroy() end)
            return false
        end
        hideCorpse(model)
        pcall(function()
            for _, d in pairs(copy:GetDescendants()) do
                if d:IsA("BillboardGui") or d:IsA("SurfaceGui") or d:IsA("Highlight") then d:Destroy() end
            end
        end)
        local ok = false
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.zero
            hum.Health = 0
            local parts = {}
            for _, c in pairs(copy:GetChildren()) do
                if c:IsA("BasePart") then
                    pcall(function() c.CollisionGroup = "Players" end)
                    table.insert(parts, c)
                end
            end
            for i = 1, #parts do
                for j = i + 1, #parts do
                    local nc = Instance.new("NoCollisionConstraint")
                    nc.Part0 = parts[i]
                    nc.Part1 = parts[j]
                    nc.Parent = parts[i]
                end
            end
            copy:PivotTo(model:GetPivot())
            copy.Parent = model.Parent
            ok = true
        end)
        if not ok then
            pcall(function() copy:Destroy() end)
            return false
        end
        pcall(function()
            model.Destroying:Once(function()
                if copy.Parent ~= nil then copy:Destroy() end
            end)
        end)
        local prevCopy = rawget(_finisherCopies, ent)
        if prevCopy ~= nil and prevCopy ~= copy and prevCopy.Parent ~= nil then
            pcall(function() prevCopy:Destroy() end)
        end
        rawset(_finisherCopies, ent, copy)
        local prev = rawget(ent, "_current_finisher")
        if prev ~= nil then pcall(prev.Destroy, prev) end
        local fin = nil
        bareFirst(function()
            fin = mod.new(hum, isFinal, killer)
            rawset(ent, "_current_finisher", fin)
            fin:SetSerial(serial)
        end)
        if fin ~= nil then
            task.spawn(function() pcall(fin.PlayServer, fin) end)
            task.spawn(function() pcall(fin.PlayClient, fin) end)
        end
        if fin == nil then
            pcall(function() copy:Destroy() end)
            return false
        end
        return true
    end
    local function reallyOwnsEmote(name)
        local inv = nil
        pcall(function()
            if _maskInner ~= nil then inv = _maskInner.CosmeticInventory end
        end)
        if type(inv) ~= "table" then return false end
        local owned = false
        pcall(function() owned = Rivals.Cosmetics:OwnsCosmetic(inv, name) == true end)
        return owned
    end
    local function localEntity()
        local ent = nil
        pcall(function()
            local f = Rivals.Fighter:GetFighter(lp)
            ent = f and f.Entity
        end)
        return ent
    end
    local function armEmoteCancel(ent, obj, oid, hum)
        task.spawn(function()
            local origin = nil
            pcall(function()
                local rp = hum.RootPart
                if rp ~= nil then origin = rp.Position end
            end)
            local shots0 = State.Shots or 0
            local t0 = tick()
            while tick() - t0 < 600 do
                task.wait(0.2)
                if rawget(ent, "_current_emote") ~= obj then return end
                local dead, moved = false, false
                pcall(function() dead = hum.Health <= 0 end)
                pcall(function()
                    local rp = hum.RootPart
                    moved = (rp ~= nil and origin ~= nil and (rp.Position - origin).Magnitude >= 4)
                end)
                local fired = (State.Shots or 0) ~= shots0
                local expired = (type(obj.Lifetime) == "number") and (tick() - t0 > obj.Lifetime + 0.5)
                if dead or moved or fired or expired then
                    local delay = 0.15
                    pcall(function() delay = math.max(lp:GetNetworkPing(), 0.05) end)
                    task.delay(delay, function()
                        pcall(function() ent:CancelEmote(oid) end)
                    end)
                    return
                end
            end
        end)
    end
    local function localPlayEmote(name)
        local ent = localEntity()
        if ent == nil then return false end
        local hum = nil
        pcall(function() hum = ent.Humanoid end)
        if hum == nil then return false end
        local alive = true
        pcall(function() alive = hum.Health > 0 end)
        if not alive then return false end
        local node = nil
        pcall(function()
            local mods = ReplicatedStorage:FindFirstChild("Modules")
            local folder = mods and mods:FindFirstChild("Emotes")
            node = folder and folder:FindFirstChild(name)
        end)
        if node == nil then return false end
        pcall(function() ent:CancelEmote(nil) end)
        local ok = false
        atIdentity2(function()
            ok = pcall(function()
                local obj = require(node).new(hum)
                local oid = "LH" .. tostring(math.random(100000000, 999999999))
                obj:SetSerial({ ObjectID = oid, Name = name, Seed = math.random(1, 1000000) })
                rawset(ent, "_current_emote", obj)
                pcall(function() ent.EmoteStatusChanged:Fire() end)
                task.spawn(function() pcall(obj.PlayServer, obj) end)
                task.spawn(function() pcall(obj.PlayClient, obj) end)
                armEmoteCancel(ent, obj, oid, hum)
            end)
        end)
        return ok
    end
    function GameVisuals.emoteList()
        local out = { "None" }
        for _, name in ipairs(emoteNames()) do out[#out + 1] = name end
        return out
    end
    function GameVisuals.playEmote(name)
        if type(name) ~= "string" or name == "" or name == "None" then return end
        if Config.GVEmotes ~= true then
            note("turn on 'Unlock emotes' first")
            return
        end
        if reallyOwnsEmote(name) then
            local ok = false
            pcall(function()
                if M.emoteCtl ~= nil then M.emoteCtl:UseEmoteByName(name) ; ok = true end
            end)
            if ok then return end
        end
        if not localPlayEmote(name) then
            note("emote unavailable: " .. name .. " (in a round? alive?)")
        end
    end
    local function hooksInstall()
        resolveModules()
        if Config.GVBirthHook == false then return false, "birth hook disabled in config" end
        local n = 0
        if hookField(M.ci, "_CreateViewModel", function(orig)
            return function(item, serial)
                local weapon = nil
                pcall(function() weapon = item.Name end)
                local mine = ownedByUs(item)
                _building = mine and weapon or nil
                if mine and weapon ~= nil then pcall(styleSerial, serial, weapon) end
                local ok, res = pcall(orig, item, serial)
                _building = nil
                if not ok then error(res, 0) end
                return res
            end
        end) then n = n + 1 end
        if hookField(M.cvm, "new", function(orig)
            return function(serial, item)
                local weapon = _building
                if weapon == nil and item ~= nil then
                    pcall(function() if ownedByUs(item) then weapon = item.Name end end)
                end
                if weapon ~= nil then pcall(styleSerial, serial, weapon) end
                local vm = orig(serial, item)
                if vm ~= nil and weapon ~= nil and resolveSel(weapon, "Wrap") ~= nil then
                    local upd = nil
                    pcall(function() upd = M.cvm._UpdateWrap end)
                    if type(upd) == "function" then
                        task.spawn(function()
                            pcall(upd, vm)
                            task.wait(0.1)
                            if rawget(vm, "_destroyed") ~= true then pcall(upd, vm) end
                        end)
                    end
                end
                return vm
            end
        end) then n = n + 1 end
        if hookField(M.cvm, "GetWrap", function(orig)
            return function(vm)
                local weapon, mine = nil, false
                pcall(function()
                    local item = vm.ClientItem
                    weapon = item.Name
                    mine = ownedByUs(item)
                end)
                if mine and weapon ~= nil and hasIntent(weapon, "Wrap") then
                    return resolveSel(weapon, "Wrap")
                end
                return orig(vm)
            end
        end) then n = n + 1 end
        if hookField(M.fctrl, "GetWrap", function(orig)
            return function(ctrl, oid)
                local res = orig(ctrl, oid)
                if res ~= nil then return res end
                local weapon = _oidWeapon and _oidWeapon[tostring(oid)] or nil
                if weapon == nil then return nil end
                return resolveSel(weapon, "Wrap")
            end
        end) then n = n + 1 end
        if hookField(M.ilib, "GetViewModelImageFromWeaponData", function(orig)
            return function(lib, wdata, hires)
                if type(wdata) == "table" and type(wdata.Name) == "string" then
                    local skin = resolveSel(wdata.Name, "Skin")
                    if skin ~= nil then
                        local img = nil
                        pcall(function()
                            local info = lib.ViewModels[skin.Name]
                            if info ~= nil then
                                img = hires and info.ImageHighResolution or info.Image
                                if img == nil then img = info.Image end
                            end
                        end)
                        if img ~= nil then return img end
                    end
                end
                return orig(lib, wdata, hires)
            end
        end) then n = n + 1 end
        if hookField(M.emoteCtl, "UseEmoteByName", function(orig)
            return function(self, name)
                if Config.GVEmotes == true and type(name) == "string"
                    and not reallyOwnsEmote(name) and localPlayEmote(name) then
                    return
                end
                return orig(self, name)
            end
        end) then n = n + 1 end
        if hookField(M.emoteCtl, "EquipEmote", function(orig)
            return function(self, slot, name)
                if Config.GVEmotes == true and type(name) == "string"
                    and not reallyOwnsEmote(name) then
                    return
                end
                return orig(self, slot, name)
            end
        end) then n = n + 1 end
        if hookField(M.cent, "ReplicateFromServer", function(orig)
            return function(ent, action, ...)
                if action ~= "FinisherEffect" then return orig(ent, action, ...) end
                local args = { ... }
                local killer = args[3]
                local isUs = false
                pcall(function()
                    if typeof(killer) == "Instance" then isUs = (killer == lp)
                    elseif type(killer) == "number" then isUs = (killer == lp.UserId)
                    elseif type(killer) == "string" then isUs = (killer:lower() == lp.Name:lower()) end
                end)
                if not isUs then return orig(ent, action, ...) end
                local held = nil
                pcall(function()
                    local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
                    local it = lf and lf.EquippedItem
                    if it ~= nil then held = it.Name end
                end)
                local fin, weapon = nil, nil
                local atkW = State.LastAttackWeapon
                if type(atkW) ~= "string" or tick() - (State.LastAttackWeaponAt or 0) > 30 then
                    atkW = nil
                end
                for _, w in pairs({ atkW, held, GameVisuals.lastWeapon }) do
                    if fin == nil and type(w) == "string" then
                        fin = resolveSel(w, "Finisher")
                        if fin ~= nil then weapon = w end
                    end
                end
                if fin == nil then
                    for w in pairs(GameVisuals.Choices) do
                        if fin == nil then
                            fin = resolveSel(w, "Finisher")
                            if fin ~= nil then weapon = w end
                        end
                    end
                end
                if fin == nil then return orig(ent, action, ...) end
                local rendered = false
                pcall(function() rendered = ent:IsRendered() end)
                if not rendered then return orig(ent, action, ...) end
                local mod, model = nil, nil
                pcall(function()
                    local folder = finisherFolder()
                    local node = folder and folder:FindFirstChild(tostring(fin.Name)) or nil
                    if node ~= nil then atIdentity2(function() mod = require(node) end) end
                    model = rawget(ent, "Model")
                end)
                if type(mod) ~= "table" or type(mod.new) ~= "function" or model == nil then
                    return orig(ent, action, ...)
                end
                if Config.GVFinisherClone == false then
                    local played = false
                    pcall(function()
                        ent:_PlayFinisher(fin.Name, args[2], args[3], args[4])
                        played = true
                    end)
                    if played then return end
                    return orig(ent, action, ...)
                end
                if playFinisherOnClone(ent, model, mod, args[2], args[3], args[4]) then
                    note((weapon or "?") .. " finisher -> " .. tostring(fin.Name))
                    return
                end
                note("finisher clone failed for " .. tostring(fin.Name))
                return orig(ent, action, ...)
            end
        end) then n = n + 1 end
        if n == 0 then return false, "no hook target resolved (modules not loaded yet?)" end
        return true, n
    end
    local function rebuildOidMap()
        local now = tick()
        if now < _oidAt then return end
        _oidAt = now + 5
        pcall(function()
            local f = Rivals.Fighter:GetFighter(lp)
            if f == nil or type(f.Items) ~= "table" then return end
            for _, item in pairs(f.Items) do
                local oid = nil
                pcall(function() oid = item:Get("ObjectID") end)
                if oid ~= nil then _oidWeapon[tostring(oid)] = item.Name end
            end
        end)
    end
    local function upvaluesOf(fn)
        local ups = nil
        pcall(function() ups = debug.getupvalues(fn) end)
        if type(ups) == "table" and next(ups) ~= nil then return ups end
        if debug.getupvalue == nil then return nil end
        ups = {}
        for i = 1, 64 do
            local ok, v = pcall(debug.getupvalue, fn, i)
            if not ok then break end
            ups[i] = v
        end
        if next(ups) == nil then return nil end
        return ups
    end
    local _rebuildAt = setmetatable({}, { __mode = "k" })
    local _forceRebuild = false
    local _lastRefusal = {}
    local _rebuildFails = setmetatable({}, { __mode = "k" })
    local _rebuildSeen  = setmetatable({}, { __mode = "k" })
    local function liveTriple(vm)
        local name, charm, wrap = nil, nil, nil
        pcall(function()
            local src = rawget(vm, "Data")
            if type(src) ~= "table" then return end
            name  = src.Name
            charm = src.Charm
            wrap  = src.Wrap
        end)
        return name, charm, wrap
    end
    local function applyWrapLive(vm, wrap)
        local data = nil
        pcall(function() data = rawget(vm, "Data") end)
        if type(data) ~= "table" then return false, "ViewModel.Data unreadable" end
        local upd = nil
        pcall(function() upd = M.cvm._UpdateWrap end)
        if type(upd) ~= "function" then return false, "ClientViewModel._UpdateWrap not found" end
        rawset(data, "Wrap", wrap)
        local ok, err = atIdentity2(function() upd(vm) end)
        if not ok then return false, "wrap update failed: " .. tostring(err) end
        return true, nil
    end
    local function wrapLabel(w)
        if type(w) ~= "table" then return "none" end
        return tostring(w.Name)
    end
    local INTENT_OF = { Name = "Skin", Charm = "Charm", Wrap = "Wrap" }
    local function wants(base, dataKey)
        return hasIntent(base, INTENT_OF[dataKey])
    end
    local function writeData(obj, raw, base)
        if obj == nil then return false end
        local wrote = false
        for _, key in pairs({ "Name", "Charm", "Wrap" }) do
          if wants(base, key) then
            local ok = false
            pcall(function()
                obj:SetReplicate(key, raw[key])
                ok = true
            end)
            if not ok then
                pcall(function()
                    local d = rawget(obj, "Data")
                    if type(d) == "table" then
                        d[key] = raw[key]
                        ok = true
                    end
                end)
            end
            if ok then wrote = true end
          end
        end
        return wrote
    end
    local function armsDataOf(item)
        local packed = nil
        pcall(function()
            local f = item.ClientFighter
            if f == nil then return end
            local get = f.GetArmsData
            if type(get) ~= "function" then return end
            packed = table.pack(get(f))
        end)
        return packed
    end
    local function rebuildPayload(base, vm)
        local liveName, liveCharm, liveWrap = liveTriple(vm)
        local raw = {}
        if hasIntent(base, "Skin") then
            local s = resolveSel(base, "Skin")
            raw[enumKey("Name")] = (s ~= nil) and s.Name or base
        else
            raw[enumKey("Name")] = liveName or base
        end
        if hasIntent(base, "Charm") then
            raw[enumKey("Charm")] = resolveSel(base, "Charm")
        else
            local forced = rankOverrideRecord(liveCharm)
            raw[enumKey("Charm")] = forced or liveCharm
        end
        if hasIntent(base, "Wrap") then
            raw[enumKey("Wrap")] = resolveSel(base, "Wrap")
        else
            raw[enumKey("Wrap")] = liveWrap
        end
        return raw
    end
    local function payloadKeysAreEnums(raw)
        for _, k in pairs({ "Name", "Charm", "Wrap" }) do
            if rawget(raw, k) ~= nil and enumOf(k) ~= k then return false, k end
        end
        return true, nil
    end
    local function adoptViewModel(item, fresh, arms)
        pcall(function() rawset(item, "ViewModel", fresh) end)
        if arms ~= nil then
            bareFirst(function() M.cvm.SetArmsData(fresh, table.unpack(arms, 1, arms.n)) end)
        end
        bareFirst(function() M.cvm.Equip(fresh, true) end)
        pcall(function()
            local sp = rawget(fresh, "_equip_spring")
            if sp ~= nil then sp._position0 = 0 ; sp._velocity0 = 0 end
        end)
    end
    local function usableReplacement(fresh, vm)
        if fresh == nil or fresh == vm then return false end
        local ok = false
        pcall(function()
            ok = (rawget(fresh, "_destroyed") ~= true) and (rawget(fresh, "Model") ~= nil)
        end)
        return ok
    end
    local function tryBuild(create, item, serial, vm)
        local fresh = nil
        bareFirst(function() fresh = create(item, serial) end)
        if fresh == nil then pcall(function() fresh = rawget(item, "ViewModel") end) end
        if usableReplacement(fresh, vm) then return fresh end
        return nil
    end
    local function dropViewModel(drop, vm)
        pcall(function()
            if rawget(vm, "_destroyed") ~= true then bareFirst(function() drop(vm) end) end
        end)
    end
    local function rebuildViewModel(item, base, vm)
        if Config.GVBirthHook == false then return false, "style at construction is off", false end
        if State.RageFiring == true then return false, nil, true end
        local now = tick()
        if not _forceRebuild and now < (_rebuildAt[item] or 0) then return false, nil, true end
        local fails = _rebuildFails[item]
        if not _forceRebuild and fails ~= nil and fails >= 3 and _rebuildSeen[item] == vm then
            return false, "constructor keeps refusing — lands on next spawn", false
        end
        local create = origOf(M.ci, "_CreateViewModel")
        if type(create) ~= "function" then return false, "_CreateViewModel missing — needs a respawn", false end
        local drop = nil
        pcall(function() drop = M.cvm.Destroy end)
        if type(drop) ~= "function" then return false, "Destroy missing — needs a respawn", false end
        local equip = nil
        pcall(function() equip = M.cvm.Equip end)
        if type(equip) ~= "function" then return false, "Equip missing — needs a respawn", false end
        local raw = rebuildPayload(base, vm)
        local keysOk, badKey = payloadKeysAreEnums(raw)
        if not keysOk then
            return false, "no enum for '" .. tostring(badKey) .. "' — lands on next spawn", false
        end
        _rebuildAt[item] = now + REBUILD_COOLDOWN
        local arms = armsDataOf(item)
        local serial = { Data = raw }
        local prevField = nil
        pcall(function() prevField = rawget(item, "ViewModel") end)
        pcall(function() rawset(item, "ViewModel", nil) end)
        local fresh = tryBuild(create, item, serial, vm)
        if fresh ~= nil then
            adoptViewModel(item, fresh, arms)
            dropViewModel(drop, vm)
            _rebuildFails[item] = nil
            _rebuildSeen[item] = nil
            return true, nil, false
        end
        pcall(function() rawset(item, "ViewModel", prevField) end)
        _rebuildFails[item] = (fails or 0) + 1
        _rebuildSeen[item] = vm
        return false, "constructor refused — lands on next spawn", false
    end
    local function sameSub(a, b)
        if a == nil and b == nil then return true end
        if a == nil or b == nil then return false end
        return a.Name == b.Name
    end
    local function applyToItem(item, base)
        local vm = nil
        pcall(function() vm = item.ViewModel end)
        local sel = selectionFor(base)
        if vm == nil then
            if sel ~= nil then note(base .. ": item has no ViewModel yet") end
            return false
        end
        local curName, curCharm, curWrap = liveTriple(vm)
        if curName == nil then
            if sel ~= nil then note(base .. ": ViewModel.Data unreadable") end
            return false
        end
        if sel == nil then return true end
        local raw = buildPayload(base, { Name = base }, identityKey)
        if raw == nil then raw = { Name = base } end
        local wrapOk = true
        if wants(base, "Wrap") and not sameSub(curWrap, raw.Wrap) then
            local wok, wwhy = applyWrapLive(vm, raw.Wrap)
            if wok then
                note(base .. " wrap -> " .. wrapLabel(raw.Wrap))
            else
                note(base .. ": " .. tostring(wwhy))
                wrapOk = false
            end
        end
        local needName  = wants(base, "Name")  and curName ~= raw.Name
        local needCharm = wants(base, "Charm") and not sameSub(curCharm, raw.Charm)
        if not needCharm and wants(base, "Charm") ~= true then
            local forced = rankOverrideRecord(curCharm)
            if forced ~= nil then
                local slotChoices = GameVisuals.Choices[base]
                if slotChoices == nil then slotChoices = {} ; GameVisuals.Choices[base] = slotChoices end
                slotChoices.Charm = forced
                raw[identityKey("Charm")] = forced
                note(base .. ": rank override adopted Season charm " .. tostring(forced.Name))
                needCharm = true
            end
        end
        if not needName and not needCharm then
            if wants(base, "Name") then
                local shown = nil
                pcall(function() shown = rawget(vm, "Name") end)
                if shown == raw.Name then _lastRefusal[base] = nil end
            else
                _lastRefusal[base] = nil
            end
            return wrapOk
        end
        local rok, rwhy, transient = rebuildViewModel(item, base, vm)
        writeData(item, raw, base)
        if transient ~= true then
            local nowVm = nil
            pcall(function() nowVm = item.ViewModel end)
            writeData(nowVm or vm, raw, base)
        end
        if transient ~= true then _lastRefusal[base] = nil end
        if rok then
            note(base .. " -> " .. tostring(raw.Name))
        elseif rwhy ~= nil then
            _lastRefusal[base] = rwhy
            note(base .. " -> " .. tostring(raw.Name) .. " (" .. rwhy .. ")")
        end
        return true
    end
    local function itemsOf(player)
        local items = nil
        pcall(function()
            local f = Rivals.Fighter:GetFighter(player)
            if f ~= nil and type(f.Items) == "table" then items = f.Items end
        end)
        if items == nil then
            pcall(function()
                local map = Rivals.Fighter._player_to_fighter
                local f = map and map[player]
                if f ~= nil and type(f.Items) == "table" then items = f.Items end
            end)
        end
        return items
    end
    local function applyToPlayer(player)
        local items = itemsOf(player)
        if items == nil then
            if next(GameVisuals.Choices) ~= nil then
                note("no fighter items for " .. player.Name .. " (not spawned in a match?)")
            end
            return 0
        end
        local n, matched, carried = 0, false, ""
        for _, item in pairs(items) do
            if type(item) == "table" then
                local base = nil
                pcall(function() base = item.Name end)
                if type(base) == "string" then
                    carried = carried .. base .. " "
                    if selectionFor(base) ~= nil then matched = true end
                    if applyToItem(item, base) then n = n + 1 end
                end
            end
        end
        if player == lp and next(GameVisuals.Choices) ~= nil and not matched then
            note("no carried weapon matches a selection — carrying: " .. carried)
        end
        return n
    end
    function GameVisuals.apply()
        if Config.GameVisuals ~= true then return 0 end
        resolveModules()
        rebuildOidMap()
        local n = applyToPlayer(lp)
        if Config.GVEveryone == true then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp then n = n + applyToPlayer(p) end
            end
        end
        State.GVApplied = n
        return n
    end
    local function noneSlot()
        return {
            Skin     = { Name = NONE_COSMETIC },
            Charm    = { Name = NONE_COSMETIC },
            Wrap     = { Name = NONE_COSMETIC },
            Finisher = { Name = NONE_COSMETIC },
        }
    end
    function GameVisuals.restore()
        for weapon in pairs(GameVisuals.Choices) do
            GameVisuals.Choices[weapon] = noneSlot()
        end
        _forceRebuild = true
        pcall(GameVisuals.apply)
        _forceRebuild = false
        GameVisuals.Choices = {}
        pcall(syncMask)
        note("reset")
        saveSoon()
    end
    local _conn, _last, _loaded = nil, 0, false
    function GameVisuals.enable()
        Config.GameVisuals = true
        resolveModules()
        local hok, hwhy = hooksInstall()
        if hok then
            note("hooks bound (" .. tostring(hwhy) .. ")")
        else
            note("hooks: " .. tostring(hwhy))
        end
        local cok, cwhy = captureInstall()
        if not cok then note("menu capture unavailable (" .. tostring(cwhy) .. ")") end
        local mok, mwhy = syncMask()
        if not mok then note("mask: " .. tostring(mwhy)) end
        note("hooks=" .. #HOOKS .. "  menu doors=" .. _captureBound .. "/2  captured=" .. _captured)
        if Config.GVRemember ~= false and not _loaded then
            _loaded = true
            local lok, lwhy = GameVisuals.loadConfig()
            if not lok and lwhy ~= "no saved cosmetics" then note("load: " .. tostring(lwhy)) end
        end
        if _conn ~= nil then return end
        _conn = RunService.Heartbeat:Connect(function()
            if Config.GameVisuals ~= true then return end
            local now = tick()
            if now - _last < POLL_S then return end
            _last = now
            if #HOOKS == 0 and Config.GVBirthHook ~= false then pcall(hooksInstall) end
            if _captureBound < 2 and Config.GVBirthHook ~= false then pcall(captureInstall) end
            if maskNeeded() and not maskActive() then pcall(syncMask) end
            pcall(GameVisuals.apply)
            saveDrain()
        end)
    end
    function GameVisuals.disable()
        Config.GameVisuals = false
        if _saveAt ~= nil then
            _saveAt = nil
            pcall(GameVisuals.saveConfig)
        end
        _loaded = false
        if _conn ~= nil then
            _conn:Disconnect()
            _conn = nil
        end
        if _maskConn ~= nil then
            pcall(function() _maskConn:Disconnect() end)
            _maskConn = nil
        end
        captureRestore()
        for weapon in pairs(GameVisuals.Choices) do
            GameVisuals.Choices[weapon] = noneSlot()
        end
        _forceRebuild = true
        pcall(applyToPlayer, lp)
        _forceRebuild = false
        GameVisuals.Choices = {}
        hooksRestore()
        _favOverride = {}
        _spoof.CosmeticInventory  = nil
        _spoof.FavoritedCosmetics = nil
        _spoof.WeaponInventory    = nil
        _spoof.EquippedEmotes     = nil
        maskRemove()
        note("off")
    end
    local CAT = nil
    local function sortTail(t)
        local head = table.remove(t, 1)
        table.sort(t)
        table.insert(t, 1, head)
        table.insert(t, 2, "Random")
    end
    local function buildCatalog()
        if CAT ~= nil then return end
        CAT = {
            Skin = { "None" }, Charm = { "None" }, Wrap = { "None" }, Finisher = { "None" },
            weapons = { "None" }, byWeapon = {}, owner = {},
        }
        pcall(function()
            local cos = Rivals.Cosmetics.Cosmetics
            if type(cos) ~= "table" then return end
            for name, entry in pairs(cos) do
                if type(entry) == "table" and entry.Hidden ~= true then
                    local t = entry.Type
                    if t == "Skin" and type(entry.ItemName) == "string" then
                        local item = entry.ItemName
                        CAT.owner[name] = item
                        CAT.owner[item .. " | " .. name] = item
                        table.insert(CAT.Skin, item .. " | " .. name)
                        if CAT.byWeapon[item] == nil then
                            CAT.byWeapon[item] = { "None" }
                            table.insert(CAT.weapons, item)
                        end
                        table.insert(CAT.byWeapon[item], name)
                    elseif CAT[t] ~= nil then
                        table.insert(CAT[t], name)
                    end
                end
            end
        end)
        sortTail(CAT.Skin) ; sortTail(CAT.Charm) ; sortTail(CAT.Wrap)
        sortTail(CAT.Finisher)
        local head = table.remove(CAT.weapons, 1)
        table.sort(CAT.weapons)
        table.insert(CAT.weapons, 1, head)
        for _, list in pairs(CAT.byWeapon) do sortTail(list) end
    end
    function GameVisuals.listOf(kind)
        buildCatalog()
        return CAT[kind] or { "None" }
    end
    function GameVisuals.skinList()  return GameVisuals.listOf("Skin")  end
    function GameVisuals.charmList() return GameVisuals.listOf("Charm") end
    function GameVisuals.wrapList()  return GameVisuals.listOf("Wrap")  end
    function GameVisuals.finisherList() return GameVisuals.listOf("Finisher") end
    function GameVisuals.weaponList()
        buildCatalog()
        return CAT.weapons
    end
    function GameVisuals.skinsFor(item)
        buildCatalog()
        local list = CAT.byWeapon[item]
        if list == nil then return { "None" } end
        return list
    end
    local _weapon = nil
    GameVisuals.lastWeapon = nil
    function GameVisuals.setWeapon(name)
        if name == nil or name == "None" then _weapon = nil else _weapon = name end
        GameVisuals.lastWeapon = _weapon
    end
    local function heldItemName()
        local base = nil
        pcall(function()
            local lf = Rivals.Fighter and Rivals.Fighter.LocalFighter
            local it = lf and lf.EquippedItem
            if it ~= nil then base = it.Name end
        end)
        if type(base) == "string" then return base end
        return _weapon
    end
    function GameVisuals.setFor(weapon, kind, name, inverted)
        if type(weapon) ~= "string" or type(kind) ~= "string" then return end
        buildCatalog()
        local slot = GameVisuals.Choices[weapon]
        if slot == nil then
            slot = {}
            GameVisuals.Choices[weapon] = slot
        end
        if name == nil or name == "None" or name == NONE_COSMETIC then
            slot[kind] = { Name = NONE_COSMETIC }
        elseif name == "Random" or name == RANDOM_COSMETIC then
            slot[kind] = { Name = RANDOM_COSMETIC, Type = kind, Inverted = inverted == true }
        else
            local rec = cloneCosmetic(name, kind, inverted)
            if rec == nil then
                note("unknown " .. kind .. ": " .. tostring(name))
                return
            end
            slot[kind] = rec
        end
        GameVisuals.lastWeapon = weapon
        note(weapon .. " " .. kind .. " = " .. tostring(name))
        pcall(syncMask)
        pcall(GameVisuals.apply)
        if kind == "Charm" then
            task.defer(function() pcall(GameVisuals.restyleSeasonCharms) end)
        end
        saveSoon()
    end
    function GameVisuals.setSkin(label)
        buildCatalog()
        if label == nil or label == "None" then
            if _weapon ~= nil then GameVisuals.setFor(_weapon, "Skin", nil) end
            return
        end
        if label == "Random" then
            local w = _weapon or heldItemName()
            if w == nil then
                note("pick a Weapon above, or hold the one you want to change")
                return
            end
            GameVisuals.setFor(w, "Skin", "Random")
            return
        end
        local item = CAT.owner[label]
        if item == nil then
            note("unknown skin: " .. tostring(label))
            return
        end
        local skin = label
        local bar = string.find(label, " | ", 1, true)
        if bar ~= nil then skin = string.sub(label, bar + 3) end
        GameVisuals.setFor(item, "Skin", skin)
    end
    function GameVisuals.setOn(kind, name)
        local base = _weapon or heldItemName()
        if base == nil then
            note("pick a Weapon above, or hold the one you want to change")
            return
        end
        local inv = nil
        if kind == "Wrap" then inv = Config.GVWrapInverted == true end
        GameVisuals.setFor(base, kind, name, inv)
    end
    function GameVisuals.setCharm(name)    GameVisuals.setOn("Charm", name)    end
    function GameVisuals.setWrap(name)     GameVisuals.setOn("Wrap", name)     end
    function GameVisuals.setFinisher(name) GameVisuals.setOn("Finisher", name) end
    function GameVisuals.setWrapInverted(on)
        Config.GVWrapInverted = (on == true)
        for _, slot in pairs(GameVisuals.Choices) do
            local w = slot.Wrap
            if type(w) == "table" and w.Name ~= NONE_COSMETIC then
                w.Inverted = Config.GVWrapInverted
                if type(w.Resolved) == "table" then w.Resolved.Inverted = Config.GVWrapInverted end
            end
        end
        note("wrap inverted " .. tostring(Config.GVWrapInverted))
        pcall(GameVisuals.apply)
        saveSoon()
    end
    local RANK_FALLBACK = {
        "Bronze 1", "Bronze 2", "Bronze 3", "Silver 1", "Silver 2", "Silver 3",
        "Gold 1", "Gold 2", "Gold 3", "Platinum 1", "Platinum 2", "Platinum 3",
        "Diamond 1", "Diamond 2", "Diamond 3", "Onyx 1", "Onyx 2", "Onyx 3",
        "Nemesis", "Archnemesis",
    }
    local RANK_ELO_FALLBACK = {
        ["Bronze 1"] = 0,    ["Bronze 2"] = 200,  ["Bronze 3"] = 400,
        ["Silver 1"] = 600,  ["Silver 2"] = 800,  ["Silver 3"] = 1000,
        ["Gold 1"] = 1200,   ["Gold 2"] = 1400,   ["Gold 3"] = 1600,
        ["Platinum 1"] = 1800, ["Platinum 2"] = 2000, ["Platinum 3"] = 2200,
        ["Diamond 1"] = 2400, ["Diamond 2"] = 2600, ["Diamond 3"] = 2800,
        ["Onyx 1"] = 3000,   ["Onyx 2"] = 3200,   ["Onyx 3"] = 3400,
        ["Nemesis"] = 3600,  ["Archnemesis"] = 3600,
    }
    function GameVisuals.rankNames()
        local sl = M.seasonLib
        if sl ~= nil and type(sl.RankProfiles) == "table" then
            local prof = sl.RankProfiles.ranks_version1
            if type(prof) == "table" and type(prof.RanksOrder) == "table" then
                local out = {}
                for _, name in ipairs(prof.RanksOrder) do
                    if name ~= "Unranked" then out[#out + 1] = name end
                end
                if #out > 0 then return out end
            end
        end
        local out = {}
        for _, name in ipairs(RANK_FALLBACK) do out[#out + 1] = name end
        return out
    end
    function GameVisuals.rankEloFor(rankName)
        if type(rankName) ~= "string" or rankName == "" then return nil end
        local sl = M.seasonLib
        if sl ~= nil and type(sl.RankProfiles) == "table" then
            local prof = sl.RankProfiles.ranks_version1
            local r = (type(prof) == "table" and type(prof.Ranks) == "table") and prof.Ranks[rankName] or nil
            if type(r) == "table" and type(r.RequiredELO) == "number" then return r.RequiredELO end
        end
        return RANK_ELO_FALLBACK[rankName]
    end
    function GameVisuals.rankNeedsLb(rankName)
        if rankName == "Archnemesis" then return true end
        local sl = M.seasonLib
        if sl ~= nil and type(sl.RankProfiles) == "table" then
            local prof = sl.RankProfiles.ranks_version1
            local r = (type(prof) == "table" and type(prof.Ranks) == "table") and prof.Ranks[rankName] or nil
            if type(r) == "table" and r.RequiredELOLeaderboardRanking ~= nil then return true end
        end
        return false
    end
    function GameVisuals.resolveRankStamp()
        if Config.GVRankCharmOn ~= true then return nil end
        local elo = GameVisuals.rankEloFor(Config.GVRankCharmRank)
        if type(elo) ~= "number" then return nil end
        local lb = tonumber(Config.GVRankCharmLb) or 0
        if lb <= 0 and GameVisuals.rankNeedsLb(Config.GVRankCharmRank) then lb = 1 end
        return { SeasonELO = elo, SeasonLeaderboardRank = (lb > 0 and lb or nil) }
    end
    function GameVisuals.rankedCharmsFor()
        local out = { "Held weapon" }
        for _, w in ipairs(GameVisuals.weaponList()) do
            if w ~= "None" then out[#out + 1] = w end
        end
        return out
    end
    function GameVisuals.applyRankedCharm(rankName, weaponLabel)
        if Config.GVRankCharmOn ~= true then
            note("turn on 'Spoof ranked charm rank' first")
            return
        end
        if type(rankName) ~= "string" or rankName == "" or rankName == "None" then return end
        if type(GameVisuals.rankEloFor(rankName)) ~= "number" then
            note("unknown rank: " .. tostring(rankName))
            return
        end
        local base = nil
        if type(weaponLabel) == "string" and weaponLabel ~= "" and weaponLabel ~= "None"
            and weaponLabel ~= "Held weapon" then
            base = weaponLabel
        else
            base = heldItemName()
        end
        if base == nil then
            note("hold the weapon you want it on (or pick one above)")
            return
        end
        local bestN, bestSeason = -1, nil
        for _, name in ipairs(GameVisuals.charmList()) do
            local n = string.match(name, "^Season (%d+)$")
            n = n and tonumber(n)
            if n ~= nil and n > bestN then bestN, bestSeason = n, name end
        end
        if bestSeason == nil then
            note("no Season charms found in the catalogue")
            return
        end
        Config.GVRankCharmRank = rankName
        local slotChoices = GameVisuals.Choices[base]
        if slotChoices == nil then slotChoices = {} ; GameVisuals.Choices[base] = slotChoices end
        slotChoices.Charm = cloneCosmetic(bestSeason, "Charm")
        pcall(GameVisuals.apply)
        saveSoon()
        note(base .. ": ranked charm -> " .. rankName .. " (" .. bestSeason .. ")")
    end
    function GameVisuals.restyleSeasonCharms()
        if Config.GVRankCharmOn ~= true then return end
        local sl = M.seasonLib
        if sl == nil or type(sl.FormatSeasonRankCharm) ~= "function" then return end
        local md = GameVisuals.resolveRankStamp()
        if type(md) ~= "table" then return end
        pcall(function()
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("Model") and string.match(d.Name, "^Season %d+$") ~= nil
                    and d:FindFirstChild("Extra") ~= nil then
                    pcall(function()
                        sl:FormatSeasonRankCharm(d, d.Name, md.SeasonELO, md.SeasonLeaderboardRank)
                    end)
                end
            end
        end)
    end
    function GameVisuals.refreshRankCharmMeta()
        for _, slot in pairs(GameVisuals.Choices) do
            local c = slot.Charm
            if c ~= nil and c.Name ~= NONE_COSMETIC and string.match(c.Name, "^Season %d+$") ~= nil then
                slot.Charm = cloneCosmetic(c.Name, "Charm", c.Inverted)
            end
        end
        pcall(GameVisuals.apply)
        pcall(GameVisuals.restyleSeasonCharms)
        saveSoon()
    end
    function GameVisuals.clearWeapon()
        local base = _weapon or heldItemName()
        if base == nil then return end
        GameVisuals.Choices[base] = noneSlot()
        _forceRebuild = true
        pcall(GameVisuals.apply)
        _forceRebuild = false
        GameVisuals.Choices[base] = nil
        note("cleared " .. base)
        pcall(syncMask)
        saveSoon()
    end
    function GameVisuals.summary()
        local out = {}
        for weapon, slot in pairs(GameVisuals.Choices) do
            local bits = {}
            for _, kind in pairs({ "Skin", "Wrap", "Charm", "Finisher" }) do
                local v = slot[kind]
                if v ~= nil and v.Name ~= NONE_COSMETIC then
                    local shown = tostring(v.Name)
                    if v.Name == RANDOM_COSMETIC then
                        shown = "Random"
                        if type(v.Resolved) == "table" and v.Resolved.Name ~= nil then
                            shown = "Random (" .. tostring(v.Resolved.Name) .. ")"
                        end
                    end
                    table.insert(bits, string.lower(kind) .. " " .. shown)
                end
            end
            if #bits > 0 then
                local line = weapon .. " — " .. table.concat(bits, " · ")
                local why = _lastRefusal[weapon]
                if why ~= nil then line = line .. "  (" .. tostring(why) .. ")" end
                table.insert(out, line)
            end
        end
        table.sort(out)
        return out
    end
    function GameVisuals.ready()
        return #HOOKS > 0
    end
    local CFG_DIR, CFG_FILE = "LuaHook", "LuaHook/cosmetics.json"
    local function fsReady()
        if type(writefile) ~= "function" or type(readfile) ~= "function"
            or type(isfile) ~= "function" then
            if not _fsWarned then
                _fsWarned = true
                note("no filesystem API — picks last this session only")
            end
            return false
        end
        pcall(function()
            if type(isfolder) ~= "function" or type(makefolder) ~= "function" then return end
            if not isfolder(CFG_DIR) then makefolder(CFG_DIR) end
        end)
        return true
    end
    function GameVisuals.saveConfig()
        if Config.GVRemember == false then return false, "remember picks is off" end
        if not fsReady() then return false, "no filesystem API" end
        local doc = { v = 1, choices = {} }
        for weapon, slot in pairs(GameVisuals.Choices) do
            local entry = nil
            for _, kind in pairs({ "Skin", "Charm", "Wrap", "Finisher" }) do
                local sel = slot[kind]
                if type(sel) == "table" and type(sel.Name) == "string" then
                    if entry == nil then entry = {} end
                    entry[kind] = { Name = sel.Name, Inverted = sel.Inverted == true }
                end
            end
            if entry ~= nil then doc.choices[weapon] = entry end
        end
        local ok, err = pcall(function()
            writefile(CFG_FILE, game:GetService("HttpService"):JSONEncode(doc))
        end)
        if not ok then return false, tostring(err) end
        return true, nil
    end
    saveSoon = function()
        if Config.GVRemember == false then return end
        _saveAt = tick() + 1
    end
    saveDrain = function()
        if _saveAt == nil or tick() < _saveAt then return end
        _saveAt = nil
        local ok, why = GameVisuals.saveConfig()
        if not ok and why ~= "remember picks is off" and why ~= "no filesystem API" then
            note("save failed: " .. tostring(why))
        end
    end
    function GameVisuals.loadConfig()
        if not fsReady() then return false, "no filesystem API" end
        local raw = nil
        pcall(function()
            if isfile(CFG_FILE) then raw = readfile(CFG_FILE) end
        end)
        if type(raw) ~= "string" or #raw == 0 then return false, "no saved cosmetics" end
        local doc = nil
        pcall(function() doc = game:GetService("HttpService"):JSONDecode(raw) end)
        if type(doc) ~= "table" then return false, "cosmetics.json did not decode" end
        buildCatalog()
        local n, skipped = 0, 0
        if type(doc.choices) == "table" then
            for weapon, entry in pairs(doc.choices) do
                if type(weapon) == "string" and type(entry) == "table" then
                    local slot = GameVisuals.Choices[weapon]
                    if slot == nil then
                        slot = {}
                        GameVisuals.Choices[weapon] = slot
                    end
                    for _, kind in pairs({ "Skin", "Charm", "Wrap", "Finisher" }) do
                        local sel = entry[kind]
                        if type(sel) == "table" and type(sel.Name) == "string" then
                            local inverted = sel.Inverted == true
                            if sel.Name == NONE_COSMETIC then
                                slot[kind] = { Name = NONE_COSMETIC }
                                n = n + 1
                            elseif sel.Name == RANDOM_COSMETIC then
                                slot[kind] = { Name = RANDOM_COSMETIC, Type = kind, Inverted = inverted }
                                n = n + 1
                            else
                                local rec = cloneCosmetic(sel.Name, kind, inverted)
                                if rec == nil then
                                    skipped = skipped + 1
                                else
                                    slot[kind] = rec
                                    n = n + 1
                                end
                            end
                        end
                    end
                    if next(slot) == nil then GameVisuals.Choices[weapon] = nil end
                end
            end
        end
        pcall(syncMask)
        pcall(GameVisuals.apply)
        local msg = "loaded " .. n .. " saved picks"
        if skipped > 0 then msg = msg .. " (" .. skipped .. " no longer in the game)" end
        note(msg)
        return true, n
    end
    local function isReplicatedStorage(v)
        local ok = false
        pcall(function() ok = (typeof(v) == "Instance" and v.ClassName == "ReplicatedStorage") end)
        return ok
    end
    local function cosmeticsCaller()
        for lvl = 2, 8 do
            local src, fn = nil, nil
            local ok = pcall(function() src, fn = debug.info(lvl, "sf") end)
            if not ok then return nil end
            if type(src) == "string" and type(fn) == "function"
                and string.match(src, "Cosmetics$") ~= nil then
                return fn
            end
        end
        return nil
    end
    local function onEquipPicked(weapon, ctype, cname, opts)
        _captured = _captured + 1
        if type(weapon) ~= "string" or type(ctype) ~= "string" then return end
        local inverted = nil
        if type(opts) == "table" then inverted = opts.IsInverted == true end
        if ctype == "Wrap" and inverted ~= nil then Config.GVWrapInverted = inverted end
        GameVisuals.setFor(weapon, ctype, cname, inverted)
    end
    local function onFavouritePicked(weapon, cname, state, ctype)
        if type(weapon) ~= "string" or type(cname) ~= "string" then return end
        local key = cname
        if cname == NONE_COSMETIC and type(ctype) == "string" then key = cname .. "_" .. ctype end
        local slot = _favOverride[weapon]
        if slot == nil then
            slot = {}
            _favOverride[weapon] = slot
        end
        slot[key] = (state == true) or nil
        refresh("FavoritedCosmetics")
    end
    local function makeDecoy()
        local equip = {}
        equip.FireServer = function(_, weapon, ctype, cname, opts)
            pcall(onEquipPicked, weapon, ctype, cname, opts)
        end
        local fav = {}
        fav.FireServer = function(_, weapon, cname, state, ctype)
            pcall(onFavouritePicked, weapon, cname, state, ctype)
        end
        return { Remotes = { Data = { EquipCosmetic = equip, FavoriteCosmetic = fav } } }
    end
    local function patchRemoteUpvalue(fn)
        if type(fn) ~= "function" then return false end
        if fn == _lastFn then return true end
        State.CapabilitySeam = "11c cosmetics debug.setupvalue"
        if debug.setupvalue == nil then return false end
        if DECOY == nil then DECOY = makeDecoy() end
        local ups = upvaluesOf(fn)
        if ups == nil then return false end
        for i, v in pairs(ups) do
            if v == DECOY then return true end
            if isReplicatedStorage(v) then
                local ok = false
                pcall(function()
                    debug.setupvalue(fn, i, DECOY)
                    ok = true
                end)
                if ok then
                    _lastFn = fn
                    table.insert(_rsPatch, { fn = fn, idx = i, orig = v })
                    while #_rsPatch > 24 do
                        local oldest = _rsPatch[1]
                        pcall(function() debug.setupvalue(oldest.fn, oldest.idx, oldest.orig) end)
                        table.remove(_rsPatch, 1)
                    end
                    return true
                end
                return false
            end
        end
        return false
    end
    captureRestore = function()
        for i = #_rsPatch, 1, -1 do
            local p = _rsPatch[i]
            pcall(function() debug.setupvalue(p.fn, p.idx, p.orig) end)
            _rsPatch[i] = nil
        end
        _captureBound = 0
        _lastFn = nil
    end
    captureInstall = function()
        resolveModules()
        if Config.GVBirthHook == false then return false, "menu capture disabled with the birth hook" end
        if debug.setupvalue == nil then return false, "executor lacks debug.setupvalue" end
        local bound = 0
        if hookField(M.cslot, "new", function(orig)
            return function(...)
                if debug.info ~= nil then
                    local fn = cosmeticsCaller()
                    if fn ~= nil then pcall(patchRemoteUpvalue, fn) end
                end
                return orig(...)
            end
        end) then bound = bound + 1 end
        if M.copts ~= nil then
            local initFn = nil
            pcall(function() initFn = M.copts._Init end)
            if patchRemoteUpvalue(initFn) then bound = bound + 1 end
        end
        _captureBound = bound
        if bound == 0 then return false, "no capture target resolved yet" end
        return true, bound
    end
end)()
pcall(Visuals.init); pcall(Rage.init); pcall(Aimbot.init); pcall(Trigger.init); pcall(ESP.init); pcall(Weather.init); pcall(UtilESP.init)
pcall(Rage._startTransportWatcher)
if Config.HUD then pcall(Visuals.enableHUD) end
if Config.RageLab then pcall(Lab.enable) end
pcall(HUDPlus.init)
do (function()
    local autoQueueNote = nil
    local function miscReport(feature, why)
        task.spawn(function()
            local lib = _G["\76\72"]
            if lib ~= nil and lib.Notify ~= nil then
                pcall(function() lib:Notify("[LuaHook] " .. tostring(feature) .. ": " .. tostring(why), 8) end)
            end
        end)
    end
    pcall(function()
        local mmc = loadGameModule(lp.PlayerScripts, { "Controllers", "MatchmakingController" })
        if mmc == nil then
            autoQueueNote = "enabled, but MatchmakingController did not resolve"
            return
        end
        local currentQueue = nil
        pcall(function()
            local mmUi = loadGameModule(lp.PlayerScripts,
                { "Modules", "UserInterface", "Lobby", "Matchmaking" })
            if mmUi ~= nil then currentQueue = mmUi._current_queue_name end
        end)
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local mmFolder = remotes and remotes:FindFirstChild("Matchmaking")
            local statusRemote = mmFolder and mmFolder:FindFirstChild("UpdateQueueStatus")
            if statusRemote ~= nil then
                statusRemote.OnClientEvent:Connect(function(name) currentQueue = name end)
            else
                autoQueueNote = "armed, but UpdateQueueStatus is missing - leave/dedup blind"
            end
        end)
        local duelLib = nil
        task.spawn(function()
            pcall(function() duelLib = loadGameModule(ReplicatedStorage, { "Modules", "DuelLibrary" }) end)
        end)
        local pendingUntil = 0
        local function arcadeModeOf(name)
            if duelLib == nil or name == nil or duelLib.ArcadeModes == nil then return nil end
            local ok, mode = pcall(function() return duelLib.ArcadeModes[name] end)
            if ok and type(mode) == "table" then return mode end
            return nil
        end
        local function force(allowInMatch)
            if not Config.AutoQueue then return false end
            if inMatch() and allowInMatch ~= true then return false end
            local modeName = Config.AutoQueueMode or "1v1"
            local now = tick()
            local mode = arcadeModeOf(modeName)
            if mode ~= nil then
                if game.PlaceId == mode.PlaceID then return true end
                if now < pendingUntil then return true end
                pendingUntil = now + 5
                pcall(function()
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    local arcFolder = remotes and remotes:FindFirstChild("Arcade")
                    local tp = arcFolder and arcFolder:FindFirstChild("TeleportToArcadeServer")
                    if tp ~= nil then tp:InvokeServer(modeName) end
                end)
                return true
            end
            if duelLib == nil and string.sub(modeName, 1, 4) == "arc_" then
                return false
            end
            if currentQueue == modeName then return true end
            if now < pendingUntil then return true end
            pendingUntil = now + 3
            if currentQueue ~= nil then
                pcall(function() mmc:TryLeaveQueue() end)
                return true
            end
            task.delay(1, function()
                if not Config.AutoQueue then return end
                if currentQueue ~= nil then return end
                pendingUntil = tick() + 5
                pcall(function() mmc:QueueInto(Config.AutoQueueMode or "1v1") end)
            end)
            return true
        end
        local fastUntil = tick() + 15
        local function armFast()
            local t = tick()
            if t + 15 > fastUntil then fastUntil = t + 15 end
        end
        local function onRoundEnd()
            armFast()
            task.spawn(function() pcall(force, true) end)
        end
        pcall(function()
            workspace:GetAttributeChangedSignal("MatchmadeGameOver"):Connect(function()
                if workspace:GetAttribute("MatchmadeGameOver") == true then
                    onRoundEnd()
                else
                    armFast()
                end
            end)
        end)
        pcall(function()
            if mmc.MatchmadeDuelEnded ~= nil and mmc.MatchmadeDuelEnded.Connect ~= nil then
                mmc.MatchmadeDuelEnded:Connect(onRoundEnd)
            end
        end)
        local assertAcc = 0
        RunService.Heartbeat:Connect(function(dt)
            assertAcc = assertAcc + dt
            local step = 1
            if tick() < fastUntil then step = 0.25 end
            if assertAcc < step then return end
            assertAcc = 0
            pcall(force)
        end)
    end)
    task.delay(15, function()
        if autoQueueNote == nil or Config.AutoQueue ~= true then return end
        local lib = _G["\76\72"]
        if lib == nil or lib.Notify == nil then return end
        pcall(function() lib:Notify("[LuaHook] AutoQueue: " .. autoQueueNote, 8) end)
    end)
    pcall(function()
    local _lastCollect = 0
    RunService.Heartbeat:Connect(function()
        if not Config.AutoCollectDrops then return end
        if State.RageTranslocating or State.RageVoidActive then return end
        local now = tick()
        if now - _lastCollect < 0.10 then return end
        _lastCollect = now
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        local wantHealth = Config.CollectHealth and (hum.Health < hum.MaxHealth)
        local wantAmmo = Config.CollectAmmo
        if not wantHealth and not wantAmmo then return end
        local firetouch = firetouchinterest
        if not firetouch then return end
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name == "_drop" and obj:IsA("BasePart") then
                local isHealth = obj:FindFirstChild("Health") ~= nil
                local isAmmo = (obj:FindFirstChild("Ammo") ~= nil or obj:FindFirstChild("AmmoBalanced") ~= nil)
                if (wantHealth and isHealth) or (wantAmmo and isAmmo) then
                    pcall(function()
                        firetouch(hrp, obj, 0)
                        firetouch(hrp, obj, 1)
                    end)
                end
            end
        end
    end)
    end)
end)() end
;(function()
    if not getgenv then return end
    local ok = pcall(function()
        getgenv().LH = {
            State  = State,
            Config = Config,
            Rage   = Rage,
            diag = function()
                pcall(function() Rage._physDiag() end)
                pcall(function() Rage._gumDiag() end)
                return "ok"
            end,
            why = function()
                local l1 = getgenv and getgenv().__LH_L1
                return "acLayer1Hits=" .. tostring(l1 and l1.hits or "NOT INSTALLED") .. " (want exactly 1)"
                    .. "  fpdh=" .. tostring(State.RageFPDHPath)
                    .. "  status=" .. tostring(State.RageStatus)
                    .. "  firing=" .. tostring(State.RageFiring)
                    .. "  identitySafe=" .. tostring(State.IdentitySafe)
                    .. "  capErrors=" .. tostring(State.CapabilityErrors or 0)
                    .. (State.CapabilityObserver == true and "" or " (OBSERVER NOT ARMED - count is meaningless)")
                    .. "  capFirstAt=" .. tostring(State.CapabilityKilledAt)
                    .. "  noFire=" .. tostring(State.RageFireZeroFrames or 0)
                    .. "  ammoUnreadable=" .. tostring(State.RageAmmoUnreadable or 0)
                    .. "  glue=" .. tostring(State.RageGlueVerified)
                    .. "  ||  FIRED " .. tostring(State.RageFireFrames or 0) .. " frames | not firing:"
                    .. "  protected=" .. tostring(State.RageWhyProtected or 0)
                    .. "  noPark=" .. tostring(State.RageWhyNoPark or 0)
                    .. "  primeWait=" .. tostring(State.RageWhyPrimeWait or 0)
                    .. "  predict=" .. tostring(State.RageWhyPredict or 0)
                    .. "  dip=" .. tostring(State.RageWhyDip or 0)
                    .. "  meleeCd=" .. tostring(State.RageWhyMeleeCd or 0)
                    .. "  sentNothing=" .. tostring(State.RageFireZeroFrames or 0)
                    .. "  immuneStale=" .. tostring(State.RageImmuneStale or 0)
            end,
        }
    end)
    if not ok then pcall(function() getgenv().LH = nil end) end
end)()
local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library, ThemeManager, SaveManager
local ok, err = pcall(function()
    local files, pending = {}, 3
    local urls = { 'Library.lua', 'addons/ThemeManager.lua', 'addons/SaveManager.lua' }
    for i = 1, 3 do
        task.spawn(function()
            local got, body = pcall(function() return game:HttpGet(repo .. urls[i]) end)
            if got and type(body) == 'string' and #body > 0 then files[i] = body end
            pending = pending - 1
        end)
    end
    local deadline = tick() + 20
    while pending > 0 and tick() < deadline do task.wait() end
    for i = 1, 3 do
        if files[i] == nil then error('failed to fetch ' .. urls[i], 0) end
    end
    local src = files[1]
    local patched, n = src:gsub('if not FetchIcons then', 'if not Icons then')
    if n > 0 then src = patched end
    Library      = loadstring(src)()
    ThemeManager = loadstring(files[2])()
    SaveManager  = loadstring(files[3])()
end)
if not ok or not Library then warn("[Engine] Linoria load failed:", err); return end
Library.IsMobile = isMobile
Library.ShowCustomCursor = false
Library.ShowToggleFrameInKeybinds = isMobile
pcall(function()
    Library.MainColor       = Color3.fromRGB(26, 27, 31)
    Library.BackgroundColor = Color3.fromRGB(17, 18, 21)
    Library.AccentColor     = Color3.fromRGB(96, 165, 250)
    Library.OutlineColor    = Color3.fromRGB(43, 45, 52)
    Library.FontColor       = Color3.fromRGB(239, 241, 245)
end)
local windowOptions = {
    Title = 'LuaHook',
    Center = true,
    AutoShow = false,
    TabPadding = 8,
    MenuFadeTime = 0.2,
    NotifySide = 'Right',
    Resizable = true,
    UnlockMouseWhileOpen = true,
}
local okWin, Window = pcall(function() return Library:CreateWindow(windowOptions) end)
if not okWin or not Window then
    warn("[LuaHook] GUI window failed to build:", Window)
    return
end
local Tabs = {
    Combat    = Window:AddTab('Combat'),
    Rage      = Window:AddTab('Rage'),
    ESP       = Window:AddTab('ESP'),
    Visuals   = Window:AddTab('Visuals'),
    HUD       = Window:AddTab('HUD'),
    Misc      = Window:AddTab('Misc'),
    Settings  = Window:AddTab('Settings'),
}
local Options = Library.Options or {}
local Toggles = Library.Toggles or {}
Library.Options = Options
Library.Toggles = Toggles
do
    local function findBlur()
        if Library.Window and Library.Window.Parent then
            for _, child in ipairs(Library.Window.Parent:GetChildren()) do
                if child ~= Library.Window and child:IsA("Frame") and child:FindFirstChildOfClass("BlurEffect") then
                    return child
                end
            end
        end
    end
    local blur = findBlur()
    if blur then
        blur.Visible = Library.Window.Visible
        Library.Window:GetPropertyChangedSignal("Visible"):Connect(function()
            blur.Visible = Library.Window.Visible
        end)
    end
end
do
    local L = Tabs.Combat:AddLeftGroupbox('Silent Aim')
    L:AddToggle('SilentAim', { Text='Silent Aim', Default=Config.SilentAim,
        Callback=function(v) Config.SilentAim = v end })
        :AddKeyPicker('SilentAimKey', { Default='None', Mode='Toggle', SyncToggleState=true, Text='Silent Aim' })
    L:AddToggle('SilentAimVisCheck', { Text='Visibility check', Default=Config.SilentAimVisCheck,
        Callback=function(v) Config.SilentAimVisCheck = v end })
    L:AddToggle('SilentAimJitter', { Text='Hit randomization', Default=Config.SilentAimJitter,
        Callback=function(v) Config.SilentAimJitter = v end })
    L:AddSlider('SilentAimFOV', { Text='FOV radius', Default=Config.SilentAimFOV,
        Min=20, Max=2000, Rounding=0, Callback=function(v) Config.SilentAimFOV = v end })
    L:AddDropdown('SilentAimTargetPart', { Values={'Head','Torso','Closest'},
        Default=Config.SilentAimTargetPart, Text='Target bone',
        Callback=function(v) Config.SilentAimTargetPart = v end })
    L:AddSlider('SilentAimStickiness', { Text='Stickiness', Default=Config.SilentAimStickiness,
        Min=0, Max=0.5, Rounding=2,
        Callback=function(v) Config.SilentAimStickiness = v end })
    L:AddToggle('SilentAimMultipoint', { Text='Multipoint', Default=Config.SilentAimMultipoint,
        Callback=function(v) Config.SilentAimMultipoint = v end })
    local smpDep = L:AddDependencyBox()
    smpDep:AddSlider('SilentAimMultipointCount', { Text='Multipoint samples',
        Default=Config.SilentAimMultipointCount, Min=1, Max=12, Rounding=0,
        Callback=function(v) Config.SilentAimMultipointCount = math.floor(v) end })
    smpDep:SetupDependencies({ { Toggles.SilentAimMultipoint, true } })
    L:AddToggle('SilentAimTorsoFallback', { Text='Torso fallback', Default=Config.SilentAimTorsoFallback,
        Callback=function(v) Config.SilentAimTorsoFallback = v end })
    L:AddDivider('De-blend')
    L:AddSlider('SilentAimHitChance', { Text='Hit chance %', Default=Config.SilentAimHitChance,
        Min=25, Max=100, Rounding=0,
        Callback=function(v) Config.SilentAimHitChance = math.floor(v) end })
    L:AddSlider('SilentAimBodyMix', { Text='Body mix %', Default=Config.SilentAimBodyMix,
        Min=0, Max=100, Rounding=0,
        Callback=function(v) Config.SilentAimBodyMix = math.floor(v) end })
    L:AddSlider('SilentAimJitterDeg', { Text='Jitter cone (deg)', Default=Config.SilentAimJitterDeg,
        Min=0, Max=10, Rounding=1,
        Callback=function(v) Config.SilentAimJitterDeg = v end })
    local TB = Tabs.Combat:AddRightGroupbox('Trigger bot')
    TB:AddToggle('Trigger', { Text='Trigger bot', Default=Config.Trigger,
        Callback=function(v) if v then Trigger.enable() else Trigger.disable() end end })
    TB:AddDropdown('TriggerKey', {
        Values={'Always','MB2','MB1','C','E','F','Q','V','X','LeftShift','LeftAlt','LeftControl'},
        Default=Config.TriggerKey, Text='Activation',
        Callback=function(v) Config.TriggerKey = v end })
    TB:AddToggle('TriggerHeadOnly', { Text='Head only', Default=Config.TriggerHeadOnly,
        Callback=function(v) Config.TriggerHeadOnly = v end })
    TB:AddToggle('TriggerScopeCheck', { Text='Scope check', Default=Config.TriggerScopeCheck,
        Callback=function(v) Config.TriggerScopeCheck = v end })
    TB:AddSlider('TriggerDelayMs', { Text='Reaction delay (ms)', Default=Config.TriggerDelayMs,
        Min=0, Max=300, Rounding=0, Callback=function(v) Config.TriggerDelayMs = v end })
    TB:AddSlider('TriggerRefireMs', { Text='Refire delay (ms)', Default=Config.TriggerRefireMs,
        Min=0, Max=500, Rounding=0, Callback=function(v) Config.TriggerRefireMs = v end })
    TB:AddSlider('TriggerMaxDist', { Text='Max distance', Default=Config.TriggerMaxDist,
        Min=50, Max=400, Rounding=0, Callback=function(v) Config.TriggerMaxDist = v end })
    local R = Tabs.Combat:AddRightGroupbox('Aimbot')
    R:AddToggle('Aimbot', { Text='Aimbot', Default=Config.Aimbot,
        Callback=function(v) if v then Aimbot.enable() else Aimbot.disable() end end })
    R:AddDropdown('AimbotKey', {
        Values={'Always','MB2','MB1','C','E','F','Q','V','X','LeftShift','LeftAlt','LeftControl'},
        Default=Config.AimbotKey, Text='Activation',
        Callback=function(v) Config.AimbotKey = v end })
    R:AddSlider('AimbotSmoothness', { Text='Smoothness (0 = hard lock)',
        Default=Config.AimbotSmoothness, Min=0, Max=100, Rounding=0,
        Callback=function(v) Config.AimbotSmoothness = v end })
    R:AddToggle('AimbotLinkAxes', { Text='Link X / Y smoothing', Default=(Config.AimbotLinkAxes ~= false),
        Callback=function(v) Config.AimbotLinkAxes = v end })
    local axisDep = R:AddDependencyBox()
    axisDep:AddSlider('AimbotSmoothnessX', { Text='Yaw (X) smoothness',
        Default=(Config.AimbotSmoothnessX or 0), Min=0, Max=100, Rounding=0,
        Callback=function(v) Config.AimbotSmoothnessX = v end })
    axisDep:AddSlider('AimbotSmoothnessY', { Text='Pitch (Y) smoothness',
        Default=(Config.AimbotSmoothnessY or 0), Min=0, Max=100, Rounding=0,
        Callback=function(v) Config.AimbotSmoothnessY = v end })
    axisDep:SetupDependencies({ { Toggles.AimbotLinkAxes, false } })
    R:AddSlider('AimbotJumpDamping', { Text='Jump & airborne damping (%)',
        Default=(Config.AimbotJumpDamping or 40), Min=0, Max=100, Rounding=0,
        Callback=function(v) Config.AimbotJumpDamping = v end })
    R:AddToggle('AimbotCancelSprings', { Text='Pre-cancel weapon sway springs',
        Default=(Config.AimbotCancelSprings ~= false),
        Callback=function(v) Config.AimbotCancelSprings = v end })
    R:AddToggle('AimbotCurvedFlick', { Text='Humanized curved flicks (Bezier)',
        Default=(Config.AimbotCurvedFlick or false),
        Callback=function(v) Config.AimbotCurvedFlick = v end })
    local curveDep = R:AddDependencyBox()
    curveDep:AddSlider('AimbotCurvedIntensity', { Text='Curve amplitude',
        Default=(Config.AimbotCurvedIntensity or 0.35), Min=0.05, Max=1.0, Rounding=2,
        Callback=function(v) Config.AimbotCurvedIntensity = v end })
    curveDep:SetupDependencies({ { Toggles.AimbotCurvedFlick, true } })
    R:AddSlider('AimbotTrackAssist', { Text='Track assist (0-lag feedforward)',
        Default=(Config.AimbotTrackAssist or 100), Min=0, Max=100, Rounding=0,
        Callback=function(v) Config.AimbotTrackAssist = v end })
    R:AddSlider('AimbotMaxSpeed', { Text='Max turn speed (deg/s, 0 = off)',
        Default=(Config.AimbotMaxSpeed or 0), Min=0, Max=3600, Rounding=0,
        Callback=function(v) Config.AimbotMaxSpeed = v end })
    R:AddSlider('AimbotDeadzoneDeg', { Text='Deadzone (deg)', Default=(Config.AimbotDeadzoneDeg or 0),
        Min=0, Max=10, Rounding=2, Callback=function(v) Config.AimbotDeadzoneDeg = v end })
    R:AddSlider('AimbotFOVDeg', { Text='FOV (deg)', Default=(Config.AimbotFOVDeg or 20),
        Min=1, Max=180, Rounding=1, Callback=function(v) Config.AimbotFOVDeg = v end })
    R:AddSlider('AimbotSwitchDeg', { Text='Switch threshold (deg)', Default=(Config.AimbotSwitchDeg or 2),
        Min=0, Max=45, Rounding=1, Callback=function(v) Config.AimbotSwitchDeg = v end })
    R:AddSlider('AimbotStickiness', { Text='Stickiness', Default=(Config.AimbotStickiness or 0.15),
        Min=0, Max=0.5, Rounding=2, Callback=function(v) Config.AimbotStickiness = v end })
    R:AddSlider('AimbotForgetTime', { Text='Occlusion forget time (s)', Default=(Config.AimbotForgetTime or 0.2),
        Min=0, Max=1.0, Rounding=2, Callback=function(v) Config.AimbotForgetTime = v end })
    R:AddDropdown('AimbotTargetPart', { Values={'Best','Head','Torso','Closest'},
        Default=(Config.AimbotTargetPart or 'Best'), Text='Target bone',
        Callback=function(v) Config.AimbotTargetPart = v end })
    R:AddDropdown('AimbotPriority', { Values={'Crosshair','Health','Distance'},
        Default=(Config.AimbotPriority or 'Crosshair'), Text='Priority',
        Callback=function(v) Config.AimbotPriority = v end })
    R:AddToggle('AimbotVisCheck', { Text='Visibility check', Default=(Config.AimbotVisCheck ~= false),
        Callback=function(v) Config.AimbotVisCheck = v end })
    R:AddToggle('AimbotSkipImmune', { Text='Skip immune targets', Default=(Config.AimbotSkipImmune ~= false),
        Callback=function(v) Config.AimbotSkipImmune = v end })
    R:AddToggle('AimbotPrediction', { Text='Prediction (lead + gravity)',
        Default=(Config.AimbotPrediction or false),
        Callback=function(v) Config.AimbotPrediction = v end })
    R:AddToggle('AimbotShotOverride', { Text='Shot override',
        Default=(Config.AimbotShotOverride or false),
        Callback=function(v) Config.AimbotShotOverride = v end })
    R:AddSlider('AimbotReactionMs', { Text='Reaction delay (ms)', Default=(Config.AimbotReactionMs or 0),
        Min=0, Max=300, Rounding=0, Callback=function(v) Config.AimbotReactionMs = v end })
    R:AddSlider('AimbotNoiseDeg', { Text='Aim noise (deg/s)', Default=(Config.AimbotNoiseDeg or 0),
        Min=0, Max=20, Rounding=1, Callback=function(v) Config.AimbotNoiseDeg = v end })
    R:AddSlider('AimbotOvershoot', { Text='Overshoot', Default=(Config.AimbotOvershoot or 0),
        Min=0, Max=1, Rounding=2, Callback=function(v) Config.AimbotOvershoot = v end })
    R:AddToggle('AimbotShowLock', { Text='Show lock indicator', Default=(Config.AimbotShowLock or false),
        Callback=function(v) Config.AimbotShowLock = v end })
    R:AddToggle('AimbotShowFOV', { Text='Debug FOV circle', Default=(Config.AimbotShowFOV or false),
        Callback=function(v) Config.AimbotShowFOV = v end })
    R:AddToggle('AimbotDebug', { Text='Debug readout', Default=(Config.AimbotDebug or false),
        Callback=function(v) Config.AimbotDebug = v end })
    R:AddToggle('AimbotDirectCamera', { Text='Direct camera fallback', Default=(Config.AimbotDirectCamera or false),
        Callback=function(v) Config.AimbotDirectCamera = v end })
    local L2 = Tabs.Combat:AddLeftGroupbox('Targeting')
    L2:AddToggle('TeamCheck', { Text='Team check', Default=Config.TeamCheck,
        Callback=function(v) Config.TeamCheck = v end })
    L2:AddToggle('AvoidDeflect', { Text='Avoid deflecting katanas', Default=Config.AvoidDeflect,
        Callback=function(v) Config.AvoidDeflect = v end })
    L2:AddToggle('PredictiveLead', { Text='Predictive lead', Default=Config.PredictiveLead,
        Callback=function(v) Config.PredictiveLead = v end })
    L2:AddSlider('MaxDistance', { Text='Max distance', Default=Config.MaxDistance,
        Min=200, Max=3000, Rounding=0, Callback=function(v) Config.MaxDistance = v end })
    L2:AddSlider('LeadCap', { Text='Lead cap', Default=Config.LeadCap,
        Min=1, Max=50, Rounding=0, Callback=function(v) Config.LeadCap = v end })
    L2:AddToggle('ProjectileLead', { Text='Projectile lead', Default=Config.ProjectileLead,
        Callback=function(v) Config.ProjectileLead = v end })
    local projDep = L2:AddDependencyBox()
    projDep:AddSlider('ProjectileSpeed', { Text='Projectile speed', Default=Config.ProjectileSpeed,
        Min=50, Max=2000, Rounding=0, Callback=function(v) Config.ProjectileSpeed = v end })
    projDep:SetupDependencies({ { Toggles.ProjectileLead, true } })
    L2:AddSlider('ServerProcessingMs', { Text='Server processing (ms)', Default=Config.ServerProcessingMs,
        Min=0, Max=200, Rounding=0,
        Callback=function(v) Config.ServerProcessingMs = v end })
end
do (function()
    local LTB = Tabs.Rage:AddLeftTabbox('Combat')
    local CORE = LTB:AddTab('Core')
    CORE:AddToggle('Rage', { Text='Enable Rage', Default=Config.Rage,
        Callback=function(v) if v then Rage.enable() else Rage.disable() end end })
        :AddKeyPicker('RageToggleKey', { Default='None', Mode='Toggle', SyncToggleState=true, Text='Rage' })
    CORE:AddDropdown('RageMode', { Values={'Polar','Orbit'},
        Default=Config.RageMode, Text='Rage mode',
        Callback=function(v)
            Config.RageMode = v
            if Config.Rage then Rage.enable() end
        end })
    CORE:AddDivider('Engagement')
    CORE:AddToggle('RageSkipImmune', { Text='Hold fire on immune targets', Default=Config.RageSkipImmune,
        Callback=function(v) Config.RageSkipImmune = v end })
    CORE:AddToggle('RagePrioritizeHackers', { Text='Target cheaters first', Default=Config.RagePrioritizeHackers,
        Callback=function(v) Config.RagePrioritizeHackers = v end })
    local orbitDep = CORE:AddDependencyBox()
    orbitDep:AddSlider('RageCombatOrbitRadius', { Text='Orbit radius',
        Default=Config.RageCombatOrbitRadius, Min=20, Max=380, Rounding=0,
        Callback=function(v) Config.RageCombatOrbitRadius = v end })
    orbitDep:AddSlider('RageOrbitDwell', { Text='Vantage time',
        Default=Config.RageOrbitDwell, Min=0.10, Max=0.60, Rounding=2,
        Callback=function(v) Config.RageOrbitDwell = v end })
    orbitDep:AddSlider('RageCombatOrbitHeight', { Text='Orbit height',
        Default=Config.RageCombatOrbitHeight, Min=0, Max=40, Rounding=0,
        Callback=function(v) Config.RageCombatOrbitHeight = v end })
    orbitDep:AddToggle('RageCombatOrbitJitter', { Text='Vertical jitter',
        Default=Config.RageCombatOrbitJitter,
        Callback=function(v) Config.RageCombatOrbitJitter = v end })
    orbitDep:AddSlider('RagePBEyeUp', { Text='Eye height',
        Default=Config.RagePBEyeUp, Min=1, Max=12, Rounding=0,
        Callback=function(v) Config.RagePBEyeUp = v end })
    orbitDep:SetupDependencies({ { Options.RageMode, 'Orbit' } })
    local polarDep = CORE:AddDependencyBox()
    polarDep:AddDivider('Engine')
    polarDep:AddDropdown('RageGumMode', { Values={'off','lite','on'},
        Default=Config.RageGumMode, Text='Gum',
        Callback=function(v) Config.RageGumMode = v end })
    polarDep:AddDropdown('RageVoidDepth', { Values={'shallow','deep'},
        Default=Config.RageVoidDepth, Text='Hide depth',
        Callback=function(v) Config.RageVoidDepth = v end })
    polarDep:AddToggle('RageGatePoison', { Text='Gate poison', Default=Config.RageGatePoison, Risky=true,
        Callback=function(v) Config.RageGatePoison = v end })
    polarDep:AddToggle('RagePredictPrefire', { Text='Prefire resurface', Default=Config.RagePredictPrefire,
        Callback=function(v) Config.RagePredictPrefire = v end })
    polarDep:AddDivider('Bait pulse (auto swap)')
    polarDep:AddToggle('RageAttackTranslocate', { Text='Bait Pulse', Default=Config.RageAttackTranslocate,
        Callback=function(v) Config.RageAttackTranslocate = v end })
    polarDep:AddSlider('RageBaitHeldMs', { Text='Held time', Default=Config.RageBaitHeldMs,
        Min=0, Max=1000, Rounding=0, Suffix='ms',
        Callback=function(v) Config.RageBaitHeldMs = math.floor(v) end })
    polarDep:AddSlider('RageBaitRate', { Text='Dips per burst', Default=Config.RageBaitRate,
        Min=1, Max=6, Rounding=0,
        Callback=function(v) Config.RageBaitRate = math.floor(v) end })
    polarDep:AddDivider('Park transport')
    polarDep:AddDropdown('RageRestoreMode', { Values={'auto','none','render','kerp'},
        Default=Config.RageRestoreMode, Text='Park transport',
        Callback=function(v) Config.RageRestoreMode = v end })
    polarDep:SetupDependencies({ { Options.RageMode, 'Polar' } })
    local WEP = Tabs.Rage:AddRightGroupbox('Weapon')
    WEP:AddDivider('On empty magazine')
    WEP:AddDropdown('RageOnEmpty', { Values={'Swap','Reload'},
        Default=(Config.RageOnEmpty or 'Swap'), Text='Action',
        Callback=function(v) Config.RageOnEmpty = v end })
    WEP:AddDropdown('RagePreferredSlot', { Values={'Primary','Secondary','Melee'},
        Default=(Config.RagePreferredSlot or 'Primary'), Text='Prefer slot',
        Callback=function(v) Config.RagePreferredSlot = v end })
    local B = Tabs.Rage:AddRightGroupbox('Melee')
    B:AddToggle('AvoidDeflect', { Text='Avoid katana deflect', Default=Config.AvoidDeflect,
        Callback=function(v) Config.AvoidDeflect = v end })
    B:AddToggle('RageShieldBackstab', { Text='Riot shield bypass', Default=Config.RageShieldBackstab,
        Callback=function(v) Config.RageShieldBackstab = v end })
    B:AddToggle('RageKnifeBackstab', { Text='Force knife backstabs', Default=Config.RageKnifeBackstab,
        Callback=function(v) Config.RageKnifeBackstab = v end })
    local DR = Tabs.Rage:AddRightGroupbox('Auto Collect Drops')
    DR:AddToggle('AutoCollectDrops', { Text='Auto collect drops', Default=(Config.AutoCollectDrops or false),
        Callback=function(v) Config.AutoCollectDrops = v end })
    local drDep = DR:AddDependencyBox()
    drDep:AddToggle('CollectHealth', { Text='Health packs', Default=(Config.CollectHealth ~= false),
        Callback=function(v) Config.CollectHealth = v end })
    drDep:AddToggle('CollectAmmo', { Text='Ammo packs', Default=(Config.CollectAmmo ~= false),
        Callback=function(v) Config.CollectAmmo = v end })
    local ffaStatusLabel = drDep:AddLabel('Mode: Checking...')
    task.spawn(function()
        while true do
            task.wait(1.5)
            pcall(function()
                if ffaStatusLabel and ffaStatusLabel.SetText then
                    if isFfaMode() then
                        ffaStatusLabel:SetText('Mode: FFA (Active)')
                    else
                        ffaStatusLabel:SetText('Mode: Not FFA (Standby)')
                    end
                end
            end)
        end
    end)
    drDep:SetupDependencies({ { Toggles.AutoCollectDrops, true } })
end)() end
do
    local GRAD_MODES = {'Solid','Gradient'}
    local W = Color3.fromRGB(255, 255, 255)
    local function colourRow(box, label, key, modes, solidDefault, aDefault, bDefault)
        local modeKey = 'ESP' .. key .. 'ColorMode'
        local colKey  = 'ESP' .. key .. 'Color'
        local aKey    = 'ESP' .. key .. 'GradA'
        local bKey    = 'ESP' .. key .. 'GradB'
        box:AddDropdown(modeKey, { Values=modes, Default=(Config[modeKey] or modes[1]),
            Text=label .. ' colour', Callback=function(v) Config[modeKey] = v end })
        local solidDep = box:AddDependencyBox()
        solidDep:AddLabel(label):AddColorPicker(colKey, { Default=(Config[colKey] or solidDefault),
            Callback=function(v) Config[colKey] = v end })
        solidDep:SetupDependencies({ { Options[modeKey], 'Solid' } })
        local gradDep = box:AddDependencyBox()
        gradDep:AddLabel(label .. ' A'):AddColorPicker(aKey, { Default=(Config[aKey] or aDefault),
            Callback=function(v) Config[aKey] = v end })
        gradDep:AddLabel(label .. ' B'):AddColorPicker(bKey, { Default=(Config[bKey] or bDefault),
            Callback=function(v) Config[bKey] = v end })
        gradDep:SetupDependencies({ { Options[modeKey], 'Gradient' } })
    end
    local L = Tabs.ESP:AddLeftGroupbox('ESP & Boxes')
    L:AddToggle('ESP', { Text='Enable ESP', Default=Config.ESP,
        Callback=function(v) if v then ESP.enable() else ESP.disable() end end })
        :AddKeyPicker('ESPToggleKey', { Default='None', Mode='Toggle', SyncToggleState=true, Text='ESP' })
    local espDep = L:AddDependencyBox()
    espDep:AddToggle('ESPTeamCheck', { Text='Team check (hide teammates)', Default=(Config.ESPTeamCheck ~= false),
        Callback=function(v) Config.ESPTeamCheck = v end })
    espDep:AddToggle('ESPBox', { Text='Box', Default=(Config.ESPBox ~= false),
        Callback=function(v) Config.ESPBox = v end })
    local boxDep = espDep:AddDependencyBox()
    boxDep:AddDropdown('ESPBoxStyle', { Values={'Full Box','Corner Brackets'}, Default=(Config.ESPBoxStyle or 'Full Box'),
        Text='Box style', Callback=function(v) Config.ESPBoxStyle = v end })
    boxDep:AddSlider('ESPCornerLength', { Text='Corner length %', Default=(Config.ESPCornerLength or 0.28),
        Min=0.05, Max=0.5, Rounding=2, Callback=function(v) Config.ESPCornerLength = v end })
    boxDep:AddSlider('ESPBoxThickness', { Text='Box thickness', Default=(Config.ESPBoxThickness or 1),
        Min=1, Max=4, Rounding=0, Callback=function(v) Config.ESPBoxThickness = math.floor(v) end })
    boxDep:AddSlider('ESPCasingThickness', { Text='Casing thickness', Default=(Config.ESPCasingThickness or 1),
        Min=1, Max=3, Rounding=0, Callback=function(v) Config.ESPCasingThickness = math.floor(v) end })
    boxDep:AddSlider('ESPBoxScale', { Text='Box size', Default=(Config.ESPBoxScale or 1),
        Min=0.6, Max=1.6, Rounding=2, Callback=function(v) Config.ESPBoxScale = v end })
    boxDep:AddToggle('ESPBoxFill', { Text='Translucent backdrop fill', Default=(Config.ESPBoxFill or false),
        Callback=function(v) Config.ESPBoxFill = v end })
    colourRow(boxDep, 'Box', 'Box', GRAD_MODES, W, Color3.fromRGB(255,59,78), Color3.fromRGB(255,194,75))
    boxDep:SetupDependencies({ { Toggles.ESPBox, true } })
    espDep:SetupDependencies({ { Toggles.ESP, true } })
    local L2 = Tabs.ESP:AddLeftGroupbox('Health & Ammo')
    L2:AddToggle('ESPHealth', { Text='Health bar', Default=(Config.ESPHealth ~= false),
        Callback=function(v) Config.ESPHealth = v end })
    local hpDep = L2:AddDependencyBox()
    hpDep:AddDropdown('ESPHealthNumberMode', { Values={'Off','OnDamage','Always'},
        Default=(Config.ESPHealthNumberMode or 'OnDamage'), Text='Number readout',
        Callback=function(v) Config.ESPHealthNumberMode = v end })
    hpDep:AddToggle('ESPHealthSmooth', { Text='Damage lerp animation', Default=(Config.ESPHealthSmooth ~= false),
        Callback=function(v) Config.ESPHealthSmooth = v end })
    hpDep:AddToggle('ESPHealthGhost', { Text='Damage ghost bar', Default=(Config.ESPHealthGhost ~= false),
        Callback=function(v) Config.ESPHealthGhost = v end })
    colourRow(hpDep, 'Health', 'Health', {'Ramp','Solid','Gradient'},
              Color3.fromRGB(61,224,122), Color3.fromRGB(255,68,54), Color3.fromRGB(61,224,122))
    hpDep:SetupDependencies({ { Toggles.ESPHealth, true } })
    L2:AddToggle('ESPAmmoBar', { Text='Ammo bar (magazine)', Default=(Config.ESPAmmoBar or false),
        Callback=function(v) Config.ESPAmmoBar = v end })
    L2:AddToggle('ESPHealTick', { Text='Heal pulse ring', Default=(Config.ESPHealTick or false),
        Callback=function(v) Config.ESPHealTick = v end })
    local L3 = Tabs.ESP:AddLeftGroupbox('Skeleton, Tracers & Markers')
    L3:AddToggle('ESPSkeleton', { Text='Skeleton', Default=(Config.ESPSkeleton or false),
        Callback=function(v) Config.ESPSkeleton = v end })
    local skelDep = L3:AddDependencyBox()
    skelDep:AddSlider('ESPSkeletonThickness', { Text='Thickness', Default=(Config.ESPSkeletonThickness or 1),
        Min=1, Max=5, Rounding=0, Callback=function(v) Config.ESPSkeletonThickness = math.floor(v) end })
    colourRow(skelDep, 'Skeleton', 'Skeleton', GRAD_MODES, W, W, Color3.fromRGB(120,180,255))
    skelDep:SetupDependencies({ { Toggles.ESPSkeleton, true } })
    L3:AddToggle('ESPTracers', { Text='Tracer snaplines', Default=(Config.ESPTracers or false),
        Callback=function(v) Config.ESPTracers = v end })
    local trDep = L3:AddDependencyBox()
    trDep:AddDropdown('ESPTracerOrigin', { Values={'Bottom','Middle','Top','Mouse'},
        Default=(Config.ESPTracerOrigin or 'Bottom'), Text='Origin',
        Callback=function(v) Config.ESPTracerOrigin = v end })
    trDep:AddSlider('ESPTracerThickness', { Text='Thickness', Default=(Config.ESPTracerThickness or 1),
        Min=1, Max=4, Rounding=0, Callback=function(v) Config.ESPTracerThickness = math.floor(v) end })
    colourRow(trDep, 'Tracer', 'Tracer', GRAD_MODES, W, W, Color3.fromRGB(255,59,78))
    trDep:SetupDependencies({ { Toggles.ESPTracers, true } })
    L3:AddToggle('ESPHeadDot', { Text='Head dot', Default=(Config.ESPHeadDot or false),
        Callback=function(v) Config.ESPHeadDot = v end })
    local hmDep = L3:AddDependencyBox()
    hmDep:AddSlider('ESPHeadDotSize', { Text='Radius', Default=(Config.ESPHeadDotSize or 4),
        Min=2, Max=16, Rounding=0, Callback=function(v) Config.ESPHeadDotSize = math.floor(v) end })
    hmDep:SetupDependencies({ { Toggles.ESPHeadDot, true } })
    L3:AddToggle('ESPLookLine', { Text='Look direction line', Default=(Config.ESPLookLine or false),
        Callback=function(v) Config.ESPLookLine = v end })
    L3:AddToggle('ESPLockChevron', { Text='Lock chevron on primary', Default=(Config.ESPLockChevron or false),
        Callback=function(v) Config.ESPLockChevron = v end })
    colourRow(L3, 'Markers', 'Mark', GRAD_MODES, W, W, Color3.fromRGB(255,194,75))
    local R = Tabs.ESP:AddRightGroupbox('Text & Flags')
    R:AddToggle('ESPName', { Text='Player name', Default=(Config.ESPName ~= false),
        Callback=function(v) Config.ESPName = v end })
    R:AddDropdown('ESPNameMode', { Values={'Display','Username'}, Default=(Config.ESPNameMode or 'Display'),
        Text='Name source', Callback=function(v) Config.ESPNameMode = v end })
    R:AddToggle('ESPNameHealthUnderline', { Text='Health underline', Default=(Config.ESPNameHealthUnderline or false),
        Callback=function(v) Config.ESPNameHealthUnderline = v end })
    colourRow(R, 'Name', 'Name', GRAD_MODES, W, W, Color3.fromRGB(255,194,75))
    R:AddDivider()
    R:AddToggle('ESPDistance', { Text='Distance', Default=(Config.ESPDistance ~= false),
        Callback=function(v) Config.ESPDistance = v end })
    R:AddToggle('ESPWeapon', { Text='Equipped weapon', Default=(Config.ESPWeapon or false),
        Callback=function(v) Config.ESPWeapon = v end })
    colourRow(R, 'Info', 'Info', GRAD_MODES, W, W, Color3.fromRGB(255,158,75))
    R:AddDivider()
    R:AddDropdown('ESPFont', { Values={'Code','RobotoMono','Gotham','GothamBold','Arial','SourceSans'},
        Default=(Config.ESPFont or 'Code'), Text='Font',
        Callback=function(v) Config.ESPFont = v end })
    R:AddSlider('ESPTextSize', { Text='Name size', Default=(Config.ESPTextSize or 14),
        Min=9, Max=24, Rounding=0, Callback=function(v) Config.ESPTextSize = math.floor(v) end })
    R:AddSlider('ESPInfoTextSize', { Text='Info size', Default=(Config.ESPInfoTextSize or 12),
        Min=9, Max=22, Rounding=0, Callback=function(v) Config.ESPInfoTextSize = math.floor(v) end })
    R:AddSlider('ESPTextScale', { Text='Text scale', Default=(Config.ESPTextScale or 1),
        Min=0.6, Max=1.6, Rounding=2, Callback=function(v) Config.ESPTextScale = v end })
    R:AddSlider('ESPTextCasing', { Text='Text casing px', Default=(Config.ESPTextCasing or 1),
        Min=0, Max=4, Rounding=0, Callback=function(v) Config.ESPTextCasing = math.floor(v) end })
    R:AddToggle('ESPDistanceScaling', { Text='Shrink text with distance', Default=(Config.ESPDistanceScaling ~= false),
        Callback=function(v) Config.ESPDistanceScaling = v end })
    local dsDep = R:AddDependencyBox()
    dsDep:AddSlider('ESPDistanceScalingRef', { Text='Full-size range (studs)', Default=(Config.ESPDistanceScalingRef or 50),
        Min=10, Max=300, Rounding=0, Callback=function(v) Config.ESPDistanceScalingRef = math.floor(v) end })
    dsDep:SetupDependencies({ { Toggles.ESPDistanceScaling, true } })
    R:AddToggle('ESPDeclutter', { Text='Declutter overlapping tags', Default=(Config.ESPDeclutter ~= false),
        Callback=function(v) Config.ESPDeclutter = v end })
    R:AddDivider()
    R:AddToggle('ESPFlagStaring', { Text='STARING', Default=(Config.ESPFlagStaring or false),
        Callback=function(v) Config.ESPFlagStaring = v end })
    R:AddToggle('ESPFlagDeflect', { Text='DEFLECT', Default=(Config.ESPFlagDeflect ~= false),
        Callback=function(v) Config.ESPFlagDeflect = v end })
    R:AddToggle('ESPFlagShield', { Text='SHIELD', Default=(Config.ESPFlagShield ~= false),
        Callback=function(v) Config.ESPFlagShield = v end })
    R:AddToggle('ESPFlagInvincible', { Text='INVULN', Default=(Config.ESPFlagInvincible ~= false),
        Callback=function(v) Config.ESPFlagInvincible = v end })
    R:AddToggle('ESPFlagLowHP', { Text='LOW', Default=(Config.ESPFlagLowHP ~= false),
        Callback=function(v) Config.ESPFlagLowHP = v end })
    colourRow(R, 'Flags', 'Flag', {'PerFlag','Solid','Gradient'},
              Color3.fromRGB(255,194,75), Color3.fromRGB(255,194,75), Color3.fromRGB(255,70,85))
    local RG = Tabs.ESP:AddRightGroupbox('Gradient')
    RG:AddSlider('ESPGradientRotBox', { Text='Angle (box & bars)', Default=(Config.ESPGradientRotBox or 0),
        Min=0, Max=360, Rounding=0, Callback=function(v) Config.ESPGradientRotBox = math.floor(v) end })
    RG:AddSlider('ESPGradientRotText', { Text='Angle (text)', Default=(Config.ESPGradientRotText or 90),
        Min=0, Max=360, Rounding=0, Callback=function(v) Config.ESPGradientRotText = math.floor(v) end })
    RG:AddSlider('ESPGradientSpeed', { Text='Flow (0 = static)', Default=(Config.ESPGradientSpeed or 0),
        Min=0, Max=0.5, Rounding=2, Callback=function(v) Config.ESPGradientSpeed = v end })
    RG:AddButton({ Text='Push box gradient to all', Func=function()
        pcall(function()
            local a, b = Config.ESPBoxGradA, Config.ESPBoxGradB
            for _, k in ipairs({ 'Name','Info','Flag','Skeleton','Tracer','Mark','Health' }) do
                Config['ESP' .. k .. 'GradA'] = a
                Config['ESP' .. k .. 'GradB'] = b
                Config['ESP' .. k .. 'ColorMode'] = 'Gradient'
                if Options['ESP' .. k .. 'GradA'] then Options['ESP' .. k .. 'GradA']:SetValueRGB(a) end
                if Options['ESP' .. k .. 'GradB'] then Options['ESP' .. k .. 'GradB']:SetValueRGB(b) end
                if Options['ESP' .. k .. 'ColorMode'] then Options['ESP' .. k .. 'ColorMode']:SetValue('Gradient') end
            end
        end)
    end })
    local R2 = Tabs.ESP:AddRightGroupbox('Chams & Highlights')
    R2:AddToggle('ESPChams', { Text='Player chams', Default=(Config.ESPChams or false),
        Callback=function(v) Config.ESPChams = v end })
    local chDep = R2:AddDependencyBox()
    chDep:AddDropdown('ESPChamsStyle', { Values={'Shade','Neon','Ghost'}, Default=(Config.ESPChamsStyle or 'Shade'),
        Text='Shader style', Callback=function(v) Config.ESPChamsStyle = v end })
    chDep:AddToggle('ESPChamsVisSplit', { Text='Visible vs Occluded two-tone', Default=(Config.ESPChamsVisSplit or true),
        Callback=function(v) Config.ESPChamsVisSplit = v end })
    chDep:AddLabel('Visible'):AddColorPicker('ColorVisible', { Default=(Config.ColorVisible or Color3.fromRGB(41, 224, 255)),
        Callback=function(v) Config.ColorVisible = v end })
    chDep:AddLabel('Occluded'):AddColorPicker('ColorEnemyOcc', { Default=(Config.ColorEnemyOcc or Color3.fromRGB(168, 85, 96)),
        Callback=function(v) Config.ColorEnemyOcc = v end })
    chDep:AddSlider('ESPChamsFillTransparency', { Text='Fill transp.', Default=(Config.ESPChamsFillTransparency or 0.7),
        Min=0, Max=1, Rounding=2, Callback=function(v) Config.ESPChamsFillTransparency = v end })
    chDep:AddSlider('ESPChamsOutlineTransparency', { Text='Outline transp.', Default=(Config.ESPChamsOutlineTransparency or 0.1),
        Min=0, Max=1, Rounding=2, Callback=function(v) Config.ESPChamsOutlineTransparency = v end })
    chDep:SetupDependencies({ { Toggles.ESPChams, true } })
    local R3 = Tabs.ESP:AddRightGroupbox('Radar & Off-Screen')
    R3:AddToggle('ESPArrows', { Text='Off-screen threat chevrons', Default=(Config.ESPArrows or false),
        Callback=function(v) Config.ESPArrows = v end })
    local arrDep = R3:AddDependencyBox()
    arrDep:AddToggle('ESPArrowDistFade', { Text='Distance fade', Default=Config.ESPArrowDistFade,
        Callback=function(v) Config.ESPArrowDistFade = v end })
    arrDep:AddToggle('ESPArrowDistLabel', { Text='Distance label', Default=Config.ESPArrowDistLabel,
        Callback=function(v) Config.ESPArrowDistLabel = v end })
    arrDep:SetupDependencies({ { Toggles.ESPArrows, true } })
    R3:AddToggle('ESPRadar', { Text='Mini radar', Default=Config.ESPRadar,
        Callback=function(v) Config.ESPRadar = v end })
    R3:AddToggle('ESPPeekAlert', { Text='Peek alert ring', Default=(Config.ESPPeekAlert or false),
        Callback=function(v) Config.ESPPeekAlert = v end })
    R3:AddToggle('ESPThreatCount', { Text='Off-screen threat tally', Default=(Config.ESPThreatCount or false),
        Callback=function(v) Config.ESPThreatCount = v end })
    R3:AddDivider()
    R3:AddSlider('ESPMaxDistance', { Text='Max distance', Default=(Config.ESPMaxDistance or 1200),
        Min=50, Max=3000, Rounding=0, Callback=function(v) Config.ESPMaxDistance = math.floor(v) end })
    R3:AddSlider('ESPMaxPlayers', { Text='Max targets (0 = all)', Default=(Config.ESPMaxPlayers or 0),
        Min=0, Max=24, Rounding=0, Callback=function(v) Config.ESPMaxPlayers = math.floor(v) end })
    R3:AddToggle('ESPFadeIn', { Text='Fade in on acquire', Default=(Config.ESPFadeIn ~= false),
        Callback=function(v) Config.ESPFadeIn = v end })
    R3:AddButton({ Text='Rebuild ESP Objects', Func=function() pcall(ESP.rebuildAll) end })
end
do (function()
    local LTB = Tabs.Visuals:AddLeftTabbox('World')
    local WL = LTB:AddTab('Lighting')
    local WX = LTB:AddTab('Weather')
    WL:AddToggle('Visuals', { Text='Enable', Default=(Config.Visuals or false),
        Callback=function(v) if v then Visuals.enable() else Visuals.disable() end end })
        :AddKeyPicker('VisualsToggleKey', { Default='None', Mode='Toggle', SyncToggleState=true, Text='Visuals' })
    local litDep = WL:AddDependencyBox()
    litDep:AddDropdown('VisualsPreset', { Values=Visuals.PresetOrder or {'Neutral','Day','Night','Cyber','Sunset','Winter','Vaporwave'},
        Default=(Config.VisualsPreset or 'Neutral'), Text='Preset',
        Callback=function(v) Visuals.setPreset(v) end })
    litDep:AddDropdown('VisualsGrade', { Values={'None','Crisp','Cold','Warm','Comp'},
        Default=(Config.VisualsGrade or 'Crisp'), Text='Color grade',
        Callback=function(v) if Visuals.setGrade then Visuals.setGrade(v) else Config.VisualsGrade = v end end })
    litDep:AddSlider('VisualsGradeStrength', { Text='Grade strength', Default=(Config.VisualsGradeStrength or 0.6),
        Min=0, Max=1, Rounding=2, Suffix='x',
        Callback=function(v) if Visuals.setGradeStrength then Visuals.setGradeStrength(v) else Config.VisualsGradeStrength = v end end })
    litDep:AddToggle('VisualsBloom', { Text='Bloom', Default=(Config.VisualsBloom or false),
        Callback=function(v) Visuals.setBloom(v) end })
    local blmDep = litDep:AddDependencyBox()
    blmDep:AddSlider('VisualsBloomIntensity', { Text='Bloom intensity', Default=(Config.VisualsBloomIntensity or 1.0),
        Min=0, Max=3, Rounding=2, Suffix='x',
        Callback=function(v) if Visuals.setBloomIntensity then Visuals.setBloomIntensity(v) else Config.VisualsBloomIntensity = v end end })
    blmDep:SetupDependencies({ { Toggles.VisualsBloom, true } })
    litDep:AddDivider('World')
    litDep:AddToggle('VisualsFullbright', { Text='Fullbright', Default=(Config.VisualsFullbright or false),
        Callback=function(v) Visuals.toggleFullbright(v) end })
    litDep:AddToggle('VisualsNoFog', { Text='No fog', Default=(Config.VisualsNoFog or false),
        Callback=function(v) Visuals.toggleNoFog(v) end })
    litDep:AddToggle('VisualsRainbowMap', { Text='Rainbow world', Default=(Config.VisualsRainbowMap or false),
        Callback=function(v) if Visuals.toggleRainbow then Visuals.toggleRainbow(v) else Config.VisualsRainbowMap = v end end })
    litDep:AddToggle('VisualsPerformanceMode', { Text='Performance mode', Default=(Config.VisualsPerformanceMode or false),
        Callback=function(v) Visuals.togglePerf(v) end })
    litDep:SetupDependencies({ { Toggles.Visuals, true } })
    WX:AddToggle('Weather', { Text='Enable', Default=(Config.Weather or false),
        Callback=function(v) if v then Weather.enableWeather() else Weather.disableWeather() end end })
    local wxDep = WX:AddDependencyBox()
    wxDep:AddDropdown('WeatherType', { Values={'Rain','Snow','Petals','Autumn','Mist','Ash','Sandstorm','Embers','Fireflies'},
        Default=(Config.WeatherType or 'Rain'), Text='Precipitation',
        Callback=function(v) Weather.setType(v) end })
    wxDep:AddSlider('WeatherIntensity', { Text='Intensity', Default=(Config.WeatherIntensity or 1.0),
        Min=0.15, Max=2, Rounding=2, Suffix='x',
        Callback=function(v) Weather.setIntensity(v) end })
    wxDep:AddSlider('WeatherSoundVolume', { Text='Volume', Default=(Config.WeatherSoundVolume or 0.35),
        Min=0, Max=1, Rounding=2,
        Callback=function(v) Weather.setSoundVolume(v) end })
    wxDep:AddToggle('WeatherMood', { Text='Mood tint', Default=(Config.WeatherMood or true),
        Callback=function(v) Weather.toggleMood(v) end })
    wxDep:AddDivider('Atmosphere')
    wxDep:AddToggle('WeatherStorm', { Text='Storm & lightning', Default=(Config.WeatherStorm or false),
        Callback=function(v) Weather.toggleStorm(v) end })
    local stormDep = wxDep:AddDependencyBox()
    stormDep:AddToggle('WeatherStormFlash', { Text='Sky flash', Default=(Config.WeatherStormFlash or true),
        Callback=function(v) Weather.toggleSkyFlash(v) end })
    stormDep:SetupDependencies({ { Toggles.WeatherStorm, true } })
    wxDep:AddToggle('WeatherMeteors', { Text='Meteors', Default=(Config.WeatherMeteors or false),
        Callback=function(v) Weather.toggleMeteors(v) end })
    local metDep = wxDep:AddDependencyBox()
    metDep:AddSlider('WeatherMeteorRate', { Text='Rate', Default=(Config.WeatherMeteorRate or 1.0),
        Min=0.25, Max=3, Rounding=2, Suffix='x', Compact=true,
        Callback=function(v) Weather.setMeteorRate(v) end })
    metDep:SetupDependencies({ { Toggles.WeatherMeteors, true } })
    wxDep:AddToggle('WeatherShootingStars', { Text='Shooting stars', Default=(Config.WeatherShootingStars or false),
        Callback=function(v) Weather.toggleShootingStars(v) end })
    local starDep = wxDep:AddDependencyBox()
    starDep:AddSlider('WeatherStarRate', { Text='Rate', Default=(Config.WeatherStarRate or 1.0),
        Min=0.25, Max=3, Rounding=2, Suffix='x', Compact=true,
        Callback=function(v) Weather.setStarRate(v) end })
    starDep:SetupDependencies({ { Toggles.WeatherShootingStars, true } })
    wxDep:AddDropdown('SkyboxPreset', { Values=Weather.SkyboxOrder or {'Off','Space','Sunset','Clouds','Storm','Winter','Vaporwave'},
        Default=(Config.SkyboxPreset or 'Off'), Text='Skybox',
        Callback=function(v) Weather.setSkybox(v) end })
    wxDep:AddToggle('SkyboxHideCelestial', { Text='Hide celestial', Default=(Config.SkyboxHideCelestial or false),
        Callback=function(v) Weather.toggleCelestial(v) end })
    wxDep:AddToggle('WeatherGodRays', { Text='God rays', Default=(Config.WeatherGodRays or false),
        Callback=function(v) Weather.toggleGodRays(v) end })
    wxDep:AddToggle('WeatherRainbow', { Text='Rainbow', Default=(Config.WeatherRainbow or false),
        Callback=function(v) Weather.toggleRainbow(v) end })
    wxDep:AddToggle('WeatherPuddles', { Text='Puddles', Default=(Config.WeatherPuddles or false),
        Callback=function(v) Weather.togglePuddles(v) end })
    wxDep:AddToggle('WeatherClockDial', { Text='Clock dial', Default=(Config.WeatherClockDial or false),
        Callback=function(v) Weather.toggleClock(v) end })
    wxDep:SetupDependencies({ { Toggles.Weather, true } })
    local VM = Tabs.Visuals:AddLeftGroupbox('Viewmodel & Chams')
    VM:AddToggle('VMOffsetEnabled', { Text='6-DOF transform', Default=(Config.VMOffsetEnabled or false),
        Callback=function(v) Config.VMOffsetEnabled = v; pcall(Visuals.refreshViewModel) end })
    local vmDep = VM:AddDependencyBox()
    vmDep:AddDivider('Position')
    vmDep:AddSlider('VMOffsetX', { Text='X', Default=(Config.VMOffsetX or 0), Min=-5, Max=5, Rounding=2, Compact=true,
        Callback=function(v) Config.VMOffsetX = v end })
    vmDep:AddSlider('VMOffsetY', { Text='Y', Default=(Config.VMOffsetY or 0), Min=-5, Max=5, Rounding=2, Compact=true,
        Callback=function(v) Config.VMOffsetY = v end })
    vmDep:AddSlider('VMOffsetZ', { Text='Z', Default=(Config.VMOffsetZ or 0), Min=-5, Max=5, Rounding=2, Compact=true,
        Callback=function(v) Config.VMOffsetZ = v end })
    vmDep:AddDivider('Rotation')
    vmDep:AddSlider('VMOffsetPitch', { Text='Pitch', Default=(Config.VMOffsetPitch or 0), Min=-180, Max=180, Rounding=0, Compact=true, Suffix='°',
        Callback=function(v) Config.VMOffsetPitch = math.floor(v) end })
    vmDep:AddSlider('VMOffsetYaw', { Text='Yaw', Default=(Config.VMOffsetYaw or 0), Min=-180, Max=180, Rounding=0, Compact=true, Suffix='°',
        Callback=function(v) Config.VMOffsetYaw = math.floor(v) end })
    vmDep:AddSlider('VMOffsetRoll', { Text='Roll', Default=(Config.VMOffsetRoll or 0), Min=-180, Max=180, Rounding=0, Compact=true, Suffix='°',
        Callback=function(v) Config.VMOffsetRoll = math.floor(v) end })
    vmDep:SetupDependencies({ { Toggles.VMOffsetEnabled, true } })
    VM:AddDivider('Chams & Textures')
    VM:AddToggle('VMChamsEnabled', { Text='Material chams', Default=(Config.VMChamsEnabled or false),
        Callback=function(v) Config.VMChamsEnabled = v; pcall(Visuals.refreshViewModel) end })
        :AddColorPicker('VMChamsColor', { Default=(Config.VMChamsColor or Color3.fromRGB(53, 215, 199)), Title='Cham Color',
            Callback=function(v) Config.VMChamsColor = v end })
    local vmcDep = VM:AddDependencyBox()
    vmcDep:AddDropdown('VMChamsMaterial', { Values={'ForceField','Neon','Glass','SmoothPlastic'},
        Default=(Config.VMChamsMaterial or 'ForceField'), Text='Material', Callback=function(v) Config.VMChamsMaterial = v end })
    vmcDep:AddSlider('VMChamsTransparency', { Text='Transparency', Default=(Config.VMChamsTransparency or 0.5),
        Min=0, Max=1, Rounding=2, Callback=function(v) Config.VMChamsTransparency = v end })
    vmcDep:SetupDependencies({ { Toggles.VMChamsEnabled, true } })
    VM:AddToggle('VMDisableTextures', { Text='Disable gun textures', Default=(Config.VMDisableTextures or false),
        Callback=function(v) Config.VMDisableTextures = v; pcall(Visuals.refreshViewModel) end })
    local RTB1 = Tabs.Visuals:AddRightTabbox('Effects & Camera')
    local HL = RTB1:AddTab('Holograms')
    local CM = RTB1:AddTab('Camera')
    HL:AddToggle('VisualsHolograms', { Text='On-hit holograms', Default=(Config.VisualsHolograms or false),
        Callback=function(v) Config.VisualsHolograms = v end })
        :AddColorPicker('VisualsHologramColor', { Default=(Config.VisualsHologramColor or Color3.fromRGB(0, 220, 255)), Title='Core Color',
            Callback=function(v) Config.VisualsHologramColor = v end })
        :AddColorPicker('VisualsHologramAccent', { Default=(Config.VisualsHologramAccent or Color3.fromRGB(255, 60, 200)), Title='Halo Accent',
            Callback=function(v) Config.VisualsHologramAccent = v end })
    local holoDep = HL:AddDependencyBox()
    holoDep:AddDropdown('VisualsHologramStyle', { Values={'Orb','Skeleton','Wraith'}, Default=(Config.VisualsHologramStyle or 'Orb'),
        Text='Style', Callback=function(v) Config.VisualsHologramStyle = v end })
    holoDep:AddSlider('VisualsHologramDuration', { Text='Duration', Default=(Config.VisualsHologramDuration or 3.5),
        Min=0.5, Max=5, Rounding=1, Suffix='s', Callback=function(v) Config.VisualsHologramDuration = v end })
    holoDep:AddSlider('VisualsHologramRange', { Text='Max range', Default=(Config.VisualsHologramRange or 300),
        Min=20, Max=300, Rounding=0, Suffix=' studs', Callback=function(v) Config.VisualsHologramRange = math.floor(v) end })
    holoDep:AddSlider('VisualsHologramVisibility', { Text='Visibility', Default=(Config.VisualsHologramVisibility or 1.4),
        Min=0.2, Max=2, Rounding=1, Suffix='x', Callback=function(v) Config.VisualsHologramVisibility = v end })
    holoDep:AddToggle('VisualsHologramLethal', { Text='Gold kill aura', Default=(Config.VisualsHologramLethal or true),
        Callback=function(v) Config.VisualsHologramLethal = v end })
    holoDep:SetupDependencies({ { Toggles.VisualsHolograms, true } })
    CM:AddToggle('CameraFovOverride', { Text='FOV override', Default=(Config.CameraFovOverride or false),
        Callback=function(v) Config.CameraFovOverride = v end })
    local fovDep = CM:AddDependencyBox()
    fovDep:AddSlider('CameraFovAmount', { Text='Field of view', Default=(Config.CameraFovAmount or 90),
        Min=40, Max=130, Rounding=0, Suffix='°', Callback=function(v) Config.CameraFovAmount = math.floor(v) end })
    fovDep:SetupDependencies({ { Toggles.CameraFovOverride, true } })
    CM:AddToggle('CameraAspectRatioEnabled', { Text='Aspect ratio stretch', Default=(Config.CameraAspectRatioEnabled or false),
        Callback=function(v) Config.CameraAspectRatioEnabled = v end })
    local arDep = CM:AddDependencyBox()
    arDep:AddSlider('CameraAspectRatioX', { Text='Width', Default=(Config.CameraAspectRatioX or 4),
        Min=1, Max=21, Rounding=0, Compact=true, Callback=function(v) Config.CameraAspectRatioX = math.floor(v) end })
    arDep:AddSlider('CameraAspectRatioY', { Text='Height', Default=(Config.CameraAspectRatioY or 3),
        Min=1, Max=21, Rounding=0, Compact=true, Callback=function(v) Config.CameraAspectRatioY = math.floor(v) end })
    arDep:SetupDependencies({ { Toggles.CameraAspectRatioEnabled, true } })
    CM:AddToggle('ThirdPersonEnabled', { Text='Third person', Default=(Config.ThirdPersonEnabled or false),
        Callback=function(v) Config.ThirdPersonEnabled = v end })
    local tpDep = CM:AddDependencyBox()
    tpDep:AddSlider('ThirdPersonDistance', { Text='Distance', Default=(Config.ThirdPersonDistance or 12),
        Min=4, Max=30, Rounding=0, Suffix=' studs', Callback=function(v) Config.ThirdPersonDistance = math.floor(v) end })
    tpDep:SetupDependencies({ { Toggles.ThirdPersonEnabled, true } })
    local RTB2 = Tabs.Visuals:AddRightTabbox('Game & Profile')
    local GL = RTB2:AddTab('Cosmetics')
    local SP = RTB2:AddTab('Spoofer')
    GL:AddToggle('GameVisuals', { Text='Enable', Default=(Config.GameVisuals or false),
        Callback=function(v) if v then GameVisuals.enable() else GameVisuals.disable() end end })
    local gvDep = GL:AddDependencyBox()
    gvDep:AddToggle('GVUnlockAll', { Text='Unlock all', Default=(Config.GVUnlockAll or true),
        Callback=function(v) pcall(GameVisuals.setUnlockAll, v) end })
    gvDep:AddToggle('GVRemember', { Text='Remember picks', Default=(Config.GVRemember or true),
        Callback=function(v) Config.GVRemember = v ; if v then pcall(GameVisuals.saveConfig) end end })
    gvDep:AddToggle('GVEmotes', { Text='Unlock emotes', Default=(Config.GVEmotes or false),
        Callback=function(v) pcall(GameVisuals.syncEmotes, v) end })
    gvDep:AddDropdown('GVEmote', { Values = { 'None' }, Default = 'None', Text = 'Play emote',
        Callback = function(v) pcall(GameVisuals.playEmote, v) end })
    gvDep:AddButton({ Text='Reset all', Func=function() pcall(GameVisuals.restore) end })
    gvDep:AddDivider('Ranked charm')
    gvDep:AddToggle('GVRankCharmOn', { Text='Spoof ranked charm rank', Default=(Config.GVRankCharmOn or false),
        Callback=function(v) Config.GVRankCharmOn = v ; if v then pcall(GameVisuals.refreshRankCharmMeta) end end })
    gvDep:SetupDependencies({ { Toggles.GameVisuals, true } })
    local rcDep = GL:AddDependencyBox()
    rcDep:AddDropdown('GVRankWep', { Values = { 'Held weapon' }, Default = 'Held weapon',
        Text = 'Ranked charm on', Callback = function(v) end })
    rcDep:AddDropdown('GVRankLook', { Values = {}, Default = 'None',
        Text = 'make it look like',
        Callback = function(v)
            if v == nil or v == 'None' then return end
            local wv = 'Held weapon'
            pcall(function() wv = Options.GVRankWep.Value or wv end)
            pcall(GameVisuals.applyRankedCharm, v, wv)
        end })
    rcDep:AddInput('GVRankCharmLb', { Default = tostring(Config.GVRankCharmLb or 0), Numeric = true,
        Text = '#N (optional, auto for Archnemesis)', Placeholder = '0', Finished = false,
        Callback = function(v) Config.GVRankCharmLb = tonumber(v) or 0 ; pcall(GameVisuals.refreshRankCharmMeta) end })
    rcDep:SetupDependencies({ { Toggles.GVRankCharmOn, true }, { Toggles.GameVisuals, true } })
    GL:AddDivider('Manual picker')
    local pickDep = GL:AddDependencyBox()
    pickDep:AddDropdown('GVWeapon', { Values = { 'None' }, Default = 'None', Text = 'Weapon',
        Callback = function(v) pcall(GameVisuals.setWeapon, v) end })
    pickDep:AddDropdown('GVSkin', { Values = { 'None' }, Default = 'None', Text = 'Skin',
        Callback = function(v) pcall(GameVisuals.setSkin, v) end })
    pickDep:AddDropdown('GVCharm', { Values = { 'None' }, Default = 'None', Text = 'Charm',
        Callback = function(v) pcall(GameVisuals.setCharm, v) end })
    pickDep:AddDropdown('GVWrap', { Values = { 'None' }, Default = 'None', Text = 'Wrap',
        Callback = function(v) pcall(GameVisuals.setWrap, v) end })
    pickDep:AddDropdown('GVFinisher', { Values = { 'None' }, Default = 'None', Text = 'Finisher',
        Callback = function(v) pcall(GameVisuals.setFinisher, v) end })
    pickDep:AddToggle('GVWrapInverted', { Text='Invert wrap', Default=(Config.GVWrapInverted or false),
        Callback=function(v) pcall(GameVisuals.setWrapInverted, v) end })
    pickDep:SetupDependencies({ { Toggles.GameVisuals, true } })
    task.spawn(function()
        local sig = nil
        while true do
            task.wait(3)
            local ok, lists = pcall(function()
                return { GameVisuals.weaponList(), GameVisuals.skinList(), GameVisuals.charmList(),
                         GameVisuals.wrapList(), GameVisuals.finisherList(), GameVisuals.rankNames(),
                         GameVisuals.emoteList(), GameVisuals.rankedCharmsFor() }
            end)
            if ok and type(lists) == 'table' then
                local lens = {}
                for i = 1, 8 do lens[i] = lists[i] and #lists[i] or 0 end
                local now = table.concat(lens, '/')
                if now ~= sig then
                    sig = now
                    pcall(function() Options.GVWeapon:SetValues(lists[1]) end)
                    pcall(function() Options.GVSkin:SetValues(lists[2]) end)
                    pcall(function() Options.GVCharm:SetValues(lists[3]) end)
                    pcall(function() Options.GVWrap:SetValues(lists[4]) end)
                    pcall(function() Options.GVFinisher:SetValues(lists[5]) end)
                    pcall(function() Options.GVRankLook:SetValues(lists[6]) end)
                    pcall(function() Options.GVEmote:SetValues(lists[7]) end)
                    pcall(function() Options.GVRankWep:SetValues(lists[8]) end)
                end
            end
        end
    end)
    GL:AddDivider('Live Loaded')
    local LOADED_LINES = 6
    local loaded = {}
    for i = 1, LOADED_LINES do loaded[i] = GL:AddLabel(' ', true) end
    if type(loaded[1]) == 'table' and type(loaded[1].SetText) == 'function' then
        task.spawn(function()
            local shown = nil
            while GameVisuals.uiAlive do
                task.wait(0.35)
                local lines = GameVisuals.summary()
                if #lines == 0 then
                    if Config.GameVisuals == true and GameVisuals.ready() ~= true then
                        lines = { 'not active yet' }
                    else
                        lines = {}
                    end
                end
                local joined = table.concat(lines, '\n')
                if joined ~= shown then
                    shown = joined
                    for i = 1, LOADED_LINES do
                        pcall(function() loaded[i]:SetText(lines[i] or ' ') end)
                    end
                end
            end
        end)
    end
    SP:AddDivider('Identity')
    SP:AddToggle('SpooferNameEnabled', { Text='Spoof name', Default=(Config.SpooferNameEnabled or false),
        Callback=function(v) Config.SpooferNameEnabled = v ; if Visuals.applyGuiNameSpoof then Visuals.applyGuiNameSpoof() end end })
    local spNDep = SP:AddDependencyBox()
    spNDep:AddInput('SpooferName', { Default=(Config.SpooferName or 'ProPlayer'), Text='Username',
        Placeholder='Username', Finished=false,
        Callback=function(v) Config.SpooferName = v ; if Visuals.applyGuiNameSpoof then Visuals.applyGuiNameSpoof() end end })
    spNDep:AddInput('SpooferDisplayName', { Default=(Config.SpooferDisplayName or 'ProPlayer'), Text='Display name',
        Placeholder='Display name', Finished=false,
        Callback=function(v) Config.SpooferDisplayName = v ; if Visuals.applyGuiNameSpoof then Visuals.applyGuiNameSpoof() end end })
    spNDep:SetupDependencies({ { Toggles.SpooferNameEnabled, true } })
    SP:AddDivider('Ranked & Stats')
    SP:AddToggle('SpooferLevelEnabled', { Text='Spoof level', Default=(Config.SpooferLevelEnabled or false),
        Callback=function(v) Config.SpooferLevelEnabled = v ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    local spLDep = SP:AddDependencyBox()
    spLDep:AddInput('SpooferLevel', { Default=tostring(Config.SpooferLevel or 100), Text='Level',
        Placeholder='100', Finished=false, Numeric=true,
        Callback=function(v) Config.SpooferLevel = tonumber(v) or 100 ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    spLDep:SetupDependencies({ { Toggles.SpooferLevelEnabled, true } })
    SP:AddToggle('SpooferRankedEloEnabled', { Text='Spoof ELO', Default=(Config.SpooferRankedEloEnabled or false),
        Callback=function(v) Config.SpooferRankedEloEnabled = v ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    local spEDep = SP:AddDependencyBox()
    spEDep:AddInput('SpooferRankedElo', { Default=tostring(Config.SpooferRankedElo or 2400), Text='ELO rating',
        Placeholder='2400', Finished=false, Numeric=true,
        Callback=function(v) Config.SpooferRankedElo = tonumber(v) or 2400 ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    spEDep:SetupDependencies({ { Toggles.SpooferRankedEloEnabled, true } })
    SP:AddToggle('SpooferCasualWinsEnabled', { Text='Spoof casual wins', Default=(Config.SpooferCasualWinsEnabled or false),
        Callback=function(v) Config.SpooferCasualWinsEnabled = v ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    local spWDep = SP:AddDependencyBox()
    spWDep:AddInput('SpooferCasualWins', { Default=tostring(Config.SpooferCasualWins or 500), Text='Casual wins',
        Placeholder='500', Finished=false, Numeric=true,
        Callback=function(v) Config.SpooferCasualWins = tonumber(v) or 500 ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    spWDep:SetupDependencies({ { Toggles.SpooferCasualWinsEnabled, true } })
    SP:AddToggle('SpooferRankedWinsEnabled', { Text='Spoof ranked wins', Default=(Config.SpooferRankedWinsEnabled or false),
        Callback=function(v) Config.SpooferRankedWinsEnabled = v ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    local spRWDep = SP:AddDependencyBox()
    spRWDep:AddInput('SpooferRankedWins', { Default=tostring(Config.SpooferRankedWins or 250), Text='Ranked wins',
        Placeholder='250', Finished=false, Numeric=true,
        Callback=function(v) Config.SpooferRankedWins = tonumber(v) or 250 ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    spRWDep:SetupDependencies({ { Toggles.SpooferRankedWinsEnabled, true } })
    SP:AddToggle('SpooferWinPercentEnabled', { Text='Spoof winrate', Default=(Config.SpooferWinPercentEnabled or false),
        Callback=function(v) Config.SpooferWinPercentEnabled = v ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    local spPDep = SP:AddDependencyBox()
    spPDep:AddInput('SpooferWinPercent', { Default=tostring(Config.SpooferWinPercent or 75), Text='Winrate %',
        Placeholder='75', Finished=false, Numeric=true,
        Callback=function(v) Config.SpooferWinPercent = tonumber(v) or 75 ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    spPDep:SetupDependencies({ { Toggles.SpooferWinPercentEnabled, true } })
    SP:AddToggle('SpooferWinStreakEnabled', { Text='Spoof win streak', Default=(Config.SpooferWinStreakEnabled or false),
        Callback=function(v) Config.SpooferWinStreakEnabled = v ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    local spSDep = SP:AddDependencyBox()
    spSDep:AddInput('SpooferWinStreak', { Default=tostring(Config.SpooferWinStreak or 25), Text='Win streak',
        Placeholder='25', Finished=false, Numeric=true,
        Callback=function(v) Config.SpooferWinStreak = tonumber(v) or 25 ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    spSDep:SetupDependencies({ { Toggles.SpooferWinStreakEnabled, true } })
    SP:AddToggle('SpooferFavoriteMapEnabled', { Text='Spoof favorite map', Default=(Config.SpooferFavoriteMapEnabled or false),
        Callback=function(v) Config.SpooferFavoriteMapEnabled = v ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    local spMDep = SP:AddDependencyBox()
    spMDep:AddInput('SpooferFavoriteMap', { Default=tostring(Config.SpooferFavoriteMap or 'Arena'), Text='Map name',
        Placeholder='Arena', Finished=false,
        Callback=function(v) Config.SpooferFavoriteMap = v ; if Visuals.updatePlayerSpoofer then Visuals.updatePlayerSpoofer() end end })
    spMDep:SetupDependencies({ { Toggles.SpooferFavoriteMapEnabled, true } })
end)() end
do
    local M = Tabs.HUD:AddLeftGroupbox('Master')
    M:AddToggle('HUD', { Text='Enable HUD', Default=Config.HUD,
        Callback=function(v)
            if v then Visuals.enableHUD(); pcall(HUDPlus.start)
            else Visuals.disableHUD(); pcall(HUDPlus.stop) end
        end })
        :AddKeyPicker('HUDToggleKey', { Default='None', Mode='Toggle', Text='HUD' })
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        local kp = Options.HUDToggleKey
        if kp and kp.Value and kp.Value ~= 'None'
           and Enum.KeyCode[kp.Value] and input.KeyCode == Enum.KeyCode[kp.Value] then
            if Toggles.HUD then pcall(function() Toggles.HUD:SetValue(not Toggles.HUD.Value) end) end
        end
    end)
    M:AddToggle('HUDWatermark', { Text='Watermark', Default=Config.HUDWatermark,
        Callback=function(v) Config.HUDWatermark = v end })
    local wmDep = M:AddDependencyBox()
    wmDep:AddToggle('HUDWatermarkStats', { Text='Show fps/ping/kills', Default=Config.HUDWatermarkStats,
        Callback=function(v) Config.HUDWatermarkStats = v end })
    wmDep:SetupDependencies({ { Toggles.HUDWatermark, true } })
    local XH = Tabs.HUD:AddLeftGroupbox('Crosshair')
    XH:AddToggle('FXCrosshair', { Text='Custom crosshair', Default=Config.FXCrosshair,
        Callback=function(v) Config.FXCrosshair = v end })
    local xhDep = XH:AddDependencyBox()
    xhDep:AddDropdown('FXCrosshairStyle', { Values={'Cross','X','T','Dot','Chevron'}, Default=Config.FXCrosshairStyle,
        Text='Style', Callback=function(v) Config.FXCrosshairStyle = v end })
    xhDep:AddLabel('Color'):AddColorPicker('FXCrosshairColor', { Default=Config.FXCrosshairColor,
        Callback=function(v) Config.FXCrosshairColor = v end })
    xhDep:AddSlider('FXCrosshairAngle', { Text='Rotation angle (°)', Default=Config.FXCrosshairAngle,
        Min=0, Max=360, Rounding=0, Callback=function(v) Config.FXCrosshairAngle = math.floor(v) end })
    xhDep:AddToggle('FXCrosshairSpin', { Text='Spin animation', Default=Config.FXCrosshairSpin,
        Callback=function(v) Config.FXCrosshairSpin = v end })
    xhDep:AddToggle('FXCrosshairSniper', { Text='Force on sniper/scope', Default=Config.FXCrosshairSniper,
        Callback=function(v) Config.FXCrosshairSniper = v end })
    xhDep:AddToggle('FXCrosshairBounce', { Text='Dynamic recoil bounce', Default=Config.FXCrosshairBounce,
        Callback=function(v) Config.FXCrosshairBounce = v end })
    xhDep:AddToggle('FXCrosshairDot', { Text='Center dot', Default=Config.FXCrosshairDot,
        Callback=function(v) Config.FXCrosshairDot = v end })
    xhDep:AddToggle('FXCrosshairOutline', { Text='Outline', Default=Config.FXCrosshairOutline,
        Callback=function(v) Config.FXCrosshairOutline = v end })
    xhDep:AddSlider('FXCrosshairGap', { Text='Gap', Default=Config.FXCrosshairGap,
        Min=0, Max=20, Rounding=0, Callback=function(v) Config.FXCrosshairGap = math.floor(v) end })
    xhDep:AddSlider('FXCrosshairLen', { Text='Length', Default=Config.FXCrosshairLen,
        Min=2, Max=24, Rounding=0, Callback=function(v) Config.FXCrosshairLen = math.floor(v) end })
    xhDep:AddSlider('FXCrosshairThickness', { Text='Thickness', Default=Config.FXCrosshairThickness,
        Min=1, Max=4, Rounding=0, Callback=function(v) Config.FXCrosshairThickness = math.floor(v) end })
    xhDep:SetupDependencies({ { Toggles.FXCrosshair, true } })
    local AF = Tabs.HUD:AddRightGroupbox('Aim Field Ring')
    AF:AddToggle('FXFovRotate', { Text='Rotating shimmer', Default=Config.FXFovRotate,
        Callback=function(v) Config.FXFovRotate = v end })
    AF:AddToggle('FXFovCasing', { Text='Ring casing', Default=Config.FXFovCasing,
        Callback=function(v) Config.FXFovCasing = v end })
    AF:AddLabel('Primary color'):AddColorPicker('FXFovColorA', { Default=Config.FXFovColorA,
        Callback=function(v) Config.FXFovColorA = v end })
    AF:AddLabel('Secondary color'):AddColorPicker('FXFovColorB', { Default=Config.FXFovColorB,
        Callback=function(v) Config.FXFovColorB = v end })
    local WF = Tabs.HUD:AddRightGroupbox('Hit Feedback & Tracers')
    WF:AddToggle('FXHitMarker', { Text='Hit marker', Default=Config.FXHitMarker,
        Callback=function(v) Config.FXHitMarker = v end })
    WF:AddToggle('FXBeamTracer', { Text='Bullet tracer', Default=Config.FXBeamTracer,
        Callback=function(v) Config.FXBeamTracer = v end })
    local beamDep = WF:AddDependencyBox()
    beamDep:AddDropdown('FXBeamStyle', { Values={'Line','Glow','Prism','Arc'}, Default=Config.FXBeamStyle,
        Text='Style', Callback=function(v) Config.FXBeamStyle = v end })
    beamDep:AddLabel('Color'):AddColorPicker('FXBeamHitColor', { Default=Config.FXBeamHitColor,
        Callback=function(v) Config.FXBeamHitColor = v end })
    beamDep:SetupDependencies({ { Toggles.FXBeamTracer, true } })
    WF:AddToggle('FXDamageNumbers', { Text='Damage numbers', Default=Config.FXDamageNumbers,
        Callback=function(v) Config.FXDamageNumbers = v end })
    WF:AddToggle('FXKillBanner', { Text='Kill banner', Default=Config.FXKillBanner,
        Callback=function(v) Config.FXKillBanner = v end })
end
do
    local MG = Tabs.Misc:AddLeftGroupbox('Automation')
    MG:AddToggle('AutoQueue', { Text = 'Auto queue', Default = Config.AutoQueue,
        Callback = function(v) Config.AutoQueue = v end })
    local aqDep = MG:AddDependencyBox()
    aqDep:AddDropdown('AutoQueueMode', {
        Values = { '1v1', '2v2', '3v3', '4v4', '5v5', '2v2_beginner', 'arc_freeforall' },
        Default = Config.AutoQueueMode or '1v1',
        Text = 'Mode',
        Callback = function(v) Config.AutoQueueMode = v end })
    aqDep:SetupDependencies({ { Toggles.AutoQueue, true } })
end
do
    local L = Tabs.Settings:AddLeftGroupbox('Menu')
    L:AddDropdown('GUIToggleKey', {
        Values = {'RightShift','LeftShift','RightControl','LeftControl','RightAlt','LeftAlt',
                  'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12',
                  'Insert','Delete','Home','End','PageUp','PageDown','CapsLock','Tab'},
        Default = Config.GUIToggleKey,
        Text = 'GUI toggle key',
        Callback = function(v) Config.GUIToggleKey = v end
    })
    L:AddToggle('ShowWatermark', { Text = 'Show watermark', Default = false,
        Callback = function(v)
            pcall(function() Library:SetWatermarkVisibility(v) end)
        end })
    local OVERLAY_PALETTES = {
        ['Default'] = {
            ESPBoxColor = Color3.fromRGB(235, 235, 245), ColorEnemy = Color3.fromRGB(255, 59, 78),
            ColorTeam = Color3.fromRGB(53, 215, 199), ColorEnemyOcc = Color3.fromRGB(168, 85, 96),
            ColorTeamOcc = Color3.fromRGB(92, 153, 147), ESPTracerColor = Color3.fromRGB(255, 59, 78),
            ESPBoxGradA = Color3.fromRGB(255, 59, 78), ESPBoxGradB = Color3.fromRGB(255, 194, 75),
            FXFovColorA = Color3.fromRGB(53, 215, 199), FXFovColorB = Color3.fromRGB(255, 194, 75),
            FXKillBannerColor = Color3.fromRGB(255, 194, 75),
            VisualsHologramColor = Color3.fromRGB(0, 220, 255), VisualsHologramAccent = Color3.fromRGB(255, 60, 200),
        },
        ['Ice'] = {
            ESPBoxColor = Color3.fromRGB(232, 242, 250), ColorEnemy = Color3.fromRGB(77, 163, 255),
            ColorTeam = Color3.fromRGB(127, 255, 224), ColorEnemyOcc = Color3.fromRGB(90, 122, 153),
            ColorTeamOcc = Color3.fromRGB(110, 158, 150), ESPTracerColor = Color3.fromRGB(77, 163, 255),
            ESPBoxGradA = Color3.fromRGB(77, 163, 255), ESPBoxGradB = Color3.fromRGB(176, 224, 255),
            FXFovColorA = Color3.fromRGB(127, 219, 255), FXFovColorB = Color3.fromRGB(255, 255, 255),
            FXKillBannerColor = Color3.fromRGB(176, 224, 255),
            VisualsHologramColor = Color3.fromRGB(102, 204, 255), VisualsHologramAccent = Color3.fromRGB(255, 255, 255),
        },
        ['Crimson'] = {
            ESPBoxColor = Color3.fromRGB(245, 230, 232), ColorEnemy = Color3.fromRGB(255, 45, 85),
            ColorTeam = Color3.fromRGB(255, 209, 102), ColorEnemyOcc = Color3.fromRGB(138, 74, 85),
            ColorTeamOcc = Color3.fromRGB(153, 128, 77), ESPTracerColor = Color3.fromRGB(255, 45, 85),
            ESPBoxGradA = Color3.fromRGB(255, 45, 85), ESPBoxGradB = Color3.fromRGB(255, 122, 61),
            FXFovColorA = Color3.fromRGB(255, 45, 85), FXFovColorB = Color3.fromRGB(255, 194, 75),
            FXKillBannerColor = Color3.fromRGB(255, 77, 109),
            VisualsHologramColor = Color3.fromRGB(255, 51, 85), VisualsHologramAccent = Color3.fromRGB(255, 194, 75),
        },
        ['Mono'] = {
            ESPBoxColor = Color3.fromRGB(240, 240, 240), ColorEnemy = Color3.fromRGB(255, 255, 255),
            ColorTeam = Color3.fromRGB(138, 138, 138), ColorEnemyOcc = Color3.fromRGB(122, 122, 122),
            ColorTeamOcc = Color3.fromRGB(85, 85, 85), ESPTracerColor = Color3.fromRGB(221, 221, 221),
            ESPBoxGradA = Color3.fromRGB(255, 255, 255), ESPBoxGradB = Color3.fromRGB(102, 102, 102),
            FXFovColorA = Color3.fromRGB(255, 255, 255), FXFovColorB = Color3.fromRGB(153, 153, 153),
            FXKillBannerColor = Color3.fromRGB(255, 255, 255),
            VisualsHologramColor = Color3.fromRGB(221, 221, 221), VisualsHologramAccent = Color3.fromRGB(136, 136, 136),
        },
        ['Vapor'] = {
            ESPBoxColor = Color3.fromRGB(243, 232, 255), ColorEnemy = Color3.fromRGB(255, 113, 206),
            ColorTeam = Color3.fromRGB(1, 205, 254), ColorEnemyOcc = Color3.fromRGB(153, 85, 127),
            ColorTeamOcc = Color3.fromRGB(77, 127, 153), ESPTracerColor = Color3.fromRGB(255, 113, 206),
            ESPBoxGradA = Color3.fromRGB(255, 113, 206), ESPBoxGradB = Color3.fromRGB(1, 205, 254),
            FXFovColorA = Color3.fromRGB(185, 103, 255), FXFovColorB = Color3.fromRGB(5, 255, 161),
            FXKillBannerColor = Color3.fromRGB(255, 113, 206),
            VisualsHologramColor = Color3.fromRGB(1, 205, 254), VisualsHologramAccent = Color3.fromRGB(255, 113, 206),
        },
        ['Prism'] = {
            ESPBoxColor = Color3.fromRGB(155, 232, 255), ColorEnemy = Color3.fromRGB(255, 59, 78),
            ColorTeam = Color3.fromRGB(53, 215, 199), ColorEnemyOcc = Color3.fromRGB(150, 90, 110),
            ColorTeamOcc = Color3.fromRGB(80, 130, 128), ESPTracerColor = Color3.fromRGB(155, 232, 255),
            ESPBoxGradA = Color3.fromRGB(139, 124, 255), ESPBoxGradB = Color3.fromRGB(41, 224, 255),
            FXFovColorA = Color3.fromRGB(139, 124, 255), FXFovColorB = Color3.fromRGB(155, 232, 255),
            FXKillBannerColor = Color3.fromRGB(255, 194, 75),
            VisualsHologramColor = Color3.fromRGB(41, 224, 255), VisualsHologramAccent = Color3.fromRGB(139, 124, 255),
        },
        ['Deuteranopia'] = {
            ESPBoxColor = Color3.fromRGB(240, 240, 245), ColorEnemy = Color3.fromRGB(255, 138, 0),
            ColorTeam = Color3.fromRGB(77, 163, 255), ColorEnemyOcc = Color3.fromRGB(153, 100, 40),
            ColorTeamOcc = Color3.fromRGB(70, 105, 150), ESPTracerColor = Color3.fromRGB(255, 138, 0),
            ESPBoxGradA = Color3.fromRGB(255, 138, 0), ESPBoxGradB = Color3.fromRGB(255, 214, 0),
            FXFovColorA = Color3.fromRGB(77, 163, 255), FXFovColorB = Color3.fromRGB(255, 214, 0),
            FXKillBannerColor = Color3.fromRGB(255, 214, 0),
            VisualsHologramColor = Color3.fromRGB(77, 163, 255), VisualsHologramAccent = Color3.fromRGB(255, 138, 0),
        },
    }
    local _selPalette = 'Default'
    L:AddDropdown('OverlayPalette', { Values={'Default','Ice','Crimson','Mono','Vapor','Prism','Deuteranopia'},
        Default=_selPalette, Text='Overlay palette',
        Callback=function(v) _selPalette = v end })
    L:AddButton({ Text='Apply palette', Func=function()
        local pal = OVERLAY_PALETTES[_selPalette]; if not pal then return end
        for key, col in pairs(pal) do
            pcall(function()
                if Options[key] and Options[key].SetValueRGB then
                    Options[key]:SetValueRGB(col)
                else
                    Config[key] = col
                end
            end)
        end
    end })
    L:AddDivider()
    L:AddButton({ Text = 'Print diagnostics (console)', Func = function()
        pcall(function() Rage._physDiag() end)
        pcall(function() Rage._gumDiag() end)
    end })
    L:AddButton({ Text = 'UNLOAD LuaHook', DoubleClick = true, Func = function()
        pcall(function() ESP.unload() end)
        pcall(function() Aimbot.unload() end)
        pcall(function() Trigger.unload() end)
        pcall(function() Rage.unload() end)
        pcall(function() Visuals.unload() end)
        pcall(function() Weather.unload() end)
        pcall(function() UtilESP.unload() end)
        pcall(function() HUDPlus.unload() end)
        Library:Unload()
        _G["\76\72"] = nil
    end })
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        local key = Config.GUIToggleKey
        if key and Enum.KeyCode[key] and input.KeyCode == Enum.KeyCode[key] then
            pcall(function() Library:Toggle() end)
        end
    end)
end
task.spawn(function()
    pcall(function()
        ThemeManager:SetLibrary(Library)
        SaveManager:SetLibrary(Library)
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetIgnoreIndexes({ 'MenuKeybind', 'LH_ConfigName',
            'GVWeapon', 'GVSkin', 'GVCharm', 'GVWrap', 'GVFinisher', 'GVEmote', 'GVRankWep', 'GVRankLook' })
        ThemeManager:SetFolder('LuaHook')
        SaveManager:SetFolder('LuaHook/configs')
        SaveManager:BuildConfigSection(Tabs.Settings)
        ThemeManager:ApplyToTab(Tabs.Settings)
        local origNotify = Library.Notify
        Library.Notify = function() end
        SaveManager:LoadAutoloadConfig()
        Library.Notify = origNotify
        pcall(function()
            if Library.Toggled ~= true then Library:Toggle() end
        end)
        pcall(function()
            local wmToggle = Toggles.ShowWatermark
            if wmToggle == nil then return end
            if Library.SetWatermarkVisibility ~= nil then
                Library:SetWatermarkVisibility(wmToggle.Value == true)
            end
        end)
    end)
end)
if not Library.SetWatermarkVisibility then
    Library.SetWatermarkVisibility = function(self, bool)
        if self.Watermark then self.Watermark.Visible = bool end
    end
end
local _wmAlive   = true
local _origUnload = Library.Unload
Library.Unload = function(self, ...)
    _wmAlive = false
    pcall(function()
        if shared._LH_GunOrig and Rivals.Gun then
            if setreadonly then pcall(setreadonly, Rivals.Gun, false) end
            Rivals.Gun.StartShooting = shared._LH_GunOrig
        end
        shared._gunHooked  = nil
        shared._LH_GunOrig = nil
        if shared._LH_KatanaMod and shared._LH_KatanaDeflOrig then
            if setreadonly then pcall(setreadonly, shared._LH_KatanaMod, false) end
            shared._LH_KatanaMod._StartDeflecting = shared._LH_KatanaDeflOrig
        end
        shared._LH_KatanaMod      = nil
        shared._LH_KatanaDeflOrig = nil
        if getgenv then getgenv().__LH_SetmtBP = nil end
    end)
    pcall(ViewAngle.restore)
    pcall(ConstPatch.revertAll)
    GameVisuals.uiAlive = false
    pcall(GameVisuals.disable)
    return _origUnload(self, ...)
end
pcall(function() Library:SetWatermark('LuaHook v1 beta') end)
pcall(function() Library:SetWatermarkVisibility(false) end)
task.spawn(function()
    while _wmAlive do
        pcall(function()
            local wmText = Library.WatermarkText
            if wmText == nil then return end
            local hits, shots = State.Hits, State.Shots
            local acc = shots > 0 and math.floor((hits / shots) * 100) or 0
            local text = string.format(
                'LuaHook v1 beta  ·  %s  ·  Shots: %d  ·  Hits: %d  ·  Acc: %d%%',
                lp.DisplayName, shots, hits, acc
            )
            if Config.Rage then
                text = text .. '  ·  Rage: ' .. (State.RageStatus or 'Idle')
            end
            wmText.Text = text
        end)
        task.wait(0.5)
    end
end)
Library:Notify('LuaHook v1 beta loaded', 4)
_G["\76\72"] = Library