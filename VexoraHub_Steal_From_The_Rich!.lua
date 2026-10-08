local fns = {}
local FO_16
local uJ
local tJ
local t7
local tP
local ud
local re_TREADMILL_UPGRADE
local State
local tI
local up
local connection
local uO
local uc
local uU
local tU
local uB
local tB
local ui
local u_
local t_
local uH
local tH
local u5
local uN
local uT
local tT
local uA
local uh
local uZ
local tZ
local uG
local tG
local un
local t4
local uM
local ua
local uS
local Network
local uY
local tY
local uF
local um
local re_PLOT_UPGRADE
local uL
local uR
local ClientBalanceService
local Notify
local rf_ITEM_LOADOUT
local u2
local t2
local uK
local ur
local ux
local InfiniteMath
local uD
local tD
local u1
local t1
function fns.fn1()
    gethui = u_
end
fns.PromptCache = setmetatable({}, { __mode = "k" })
function fns.FastPrompt(prompt)
    pcall(function()
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false
        if prompt.MaxActivationDistance < 40 then
            prompt.MaxActivationDistance = 40
        end
    end)
end
function fns.FindStealPrompt(model)
    local cache = fns.PromptCache
    local cached = cache[model]
    if not (cached and cached.Parent and cached:IsDescendantOf(model)) then
        cached = nil
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("ProximityPrompt") and d.ActionText == "Steal" then
                cached = d
                break
            end
        end
        cache[model] = cached
        if cached then
            fns.FastPrompt(cached)
        end
    end
    if cached and cached.Enabled then
        return cached
    end
    return nil
end
fns.Heartbeat = game:GetService("RunService").Heartbeat
local function fn68()
    local Character = u2.Character
    if not Character then
        return nil
    end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local wA_1 = HumanoidRootPart and HumanoidRootPart:IsA("BasePart")
    if wA_1 then
        return HumanoidRootPart
    end
    return nil
end
local function fn70()
    local Ar = not up() or not State.Enabled.EquipBest
    if Ar then
        return
    end
    if os.clock() - State.LastEquipBestAt < 2 then
        return
    end
    local Ar_1 = pcall(function()
        rf_ITEM_LOADOUT:InvokeServer("placebest")
    end)
    if Ar_1 then
        State.LastEquipBestAt = os.clock()
    end
end
local function fn73(hY)
    t4("Open", hY, 0.3, t1)
end
local function fn88()
    if not State.Enabled.UpgradeTreadmill then
        return
    end
    uH(re_TREADMILL_UPGRADE, "TreadmillSignBoard", "LastUpgradeTreadmillAt", 1.5)
end
local function fn98()
    local Ae_1
    local Ad_1
    local Ac_1
    local Aa = not up() or not State.Enabled.Open
    if Aa then
        return
    end
    local Ak = if os.clock() - State.LastOpenAt < 0.35 then 1 else 0
    if Ak == 1 then
        return
    end
    local Aa_1 = select(1, tI())
    if not Aa_1 then
        return
    end
    local Ab = uA()
    if not Ab then
        return
    end
    Ae_1, Ad_1, Ac_1 = nil, nil, nil
    for i, descendant in ipairs(Aa_1:GetDescendants()) do
        local Aa_2 = descendant:IsA("ProximityPrompt") and descendant.Enabled and descendant.ActionText == "Open Crate"
        if Aa_2 then
            local Parent = descendant.Parent
            local Af
            local Ag = Parent and Parent:IsA("BasePart")
            if Ag then
                Af = Parent.Position
            else
                local Model = descendant:FindFirstAncestorWhichIsA("Model")
                if Model then
                    Af = Model:GetPivot().Position
                end
            end
            if Af then
                local Magnitude = (Af - Ab.Position).Magnitude
                if not Ac_1 or Magnitude < Ac_1 then
                    Ac_1 = Magnitude
                    Ae_1 = descendant
                    Ad_1 = Af
                end
            end
        end
    end
    if not (Ae_1 and Ad_1) then
        return
    end
    tU(Ad_1)
    ud(CFrame.new(Ad_1 + Vector3.new(0, 3, 0)))
    task.wait(0.1)
    local Aa_7 = not up() or not State.Enabled.Open
    if Aa_7 then
        return
    end
    if uG(Ae_1) then
        State.LastOpenAt = os.clock()
    end
end
local function fn114(bm)
    if type(bm) ~= "string" or bm == "" then
        return false
    elseif not ur(State.RarityFilter) then
        return true
    else
        return State.RarityFilter[bm] == true
    end
end
local function fn160(ig)
    t4("ClaimIndex", ig, 2, uL)
end
local function fn174(dP)
    local zp = dP and dP:GetAttribute("CrateAreaId") == "Angelic"
    if zp then
        local zp_1 = uA()
        if zp_1 then
            local LookVector = zp_1.CFrame.LookVector
            return math.atan2(-LookVector.X, -LookVector.Z)
        end
        return 0
    end
    return 0
end
local function fn193(im)
    t4("Sell", im, 1, uN)
end
local function fn196(iq)
    State.ZoneFilter = uh(iq)
    if not ur(State.ZoneFilter) then
        for i, v in ipairs(uU) do
            State.ZoneFilter[v] = true
        end
    end
end
local function fn212()
    return not uM.Unloaded
end
local function fn222(h0)
    t4("EquipBest", h0, 1.5, ua)
end
local function fn340()
    local Crates = ui:FindFirstChild("Crates")
    if not Crates then
        return {}
    end
    local zt = {}
    for i, child in ipairs(Crates:GetChildren()) do
        local zs_1 = child:IsA("Model") and child:GetAttribute("IsCrate") == true
        if zs_1 then
            local attr2 = child:GetAttribute("AreaId")
            local attr = child:GetAttribute("CrateTier")
            local zv = u1(attr2) and tP(attr)
            if zv then
                local zw = fns.FindStealPrompt(child)
                if zw then
                    local Position = child:GetPivot().Position
                    table.insert(zt, { model = child, areaId = attr2, tier = attr, prompt = zw, position = Position })
                end
            end
        end
    end
    return zt
end
local function fn342(ij)
    t4("BuyTrails", ij, 1, un)
end
local function fn352(aT)
    local wF = uA()
    if not wF then
        return false
    end
    wF.AssemblyLinearVelocity = Vector3.zero
    wF.AssemblyAngularVelocity = Vector3.zero
    wF.CFrame = aT
    return true
end
local function fn353()
    local Map = ui:FindFirstChild("Map")
    local Ba = Map and Map:FindFirstChild("Vendors")
    local A9_1 = Ba
    if Ba then
        Ba = A9_1:FindFirstChild("SellPlaces")
    end
    local A9_2 = Ba
    if Ba then
        Ba = A9_2:FindFirstChild("Sell1")
    end
    local A9_3 = Ba
    if Ba then
        Ba = A9_3:FindFirstChild("sellnpc NEW")
    end
    local Bb = Ba
    if Ba then
        Ba = Bb:IsA("Model")
    end
    if Ba then
        local pivot = Bb:GetPivot()
        return pivot * CFrame.new(0, 2, 5)
    elseif A9_3 then
        local ProximityPrompt = A9_3:FindFirstChildWhichIsA("ProximityPrompt", true)
        local A9_4 = ProximityPrompt and ProximityPrompt.Parent
        local Ba_3 = A9_4
        if A9_4 then
            A9_4 = Ba_3:IsA("BasePart")
        end
        if A9_4 then
            return CFrame.new(Ba_3.Position + Vector3.new(0, 3, 4))
        end
        return CFrame.new(tD)
    else
        return CFrame.new(tD)
    end
end
local function fn387()
    local Balance = ClientBalanceService.Balance
    if Balance == nil then
        return InfiniteMath.new(0)
    end
    return Balance
end
local function fn398()
    for i, child in ipairs(ui:GetChildren()) do
        if child.Name:match("^Plot Building %d+$") then
            local floor = child:FindFirstChild("floor")
            local xx = floor and floor:GetAttribute("OwnerUserId") == u2.UserId
            if xx then
                return child, floor
            end
        end
    end
    return nil, nil
end
local function fn429(h6)
    t4("Treadmill", h6, 0.5, tZ)
end
local function fn444(cr, cs)
    local yd = cr and cr:IsA("BasePart")
    if not yd then
        return nil
    end
    local yd_1 = cs and tonumber(cs:GetAttribute("MountYaw"))
    local yd_2 = yd_1 or 0
    return cr.CFrame * CFrame.new(0, cr.Size.Y / 2 + 3, 0) * CFrame.Angles(0, math.rad(yd_2), 0)
end
local function fn470(h3)
    t4("BuyEquipSlot", h3, 1.2, u5)
end
local function fn506()
    if uK() then
        return nil
    end
    local Character = u2.Character
    if not Character then
        return nil
    end
    local Tool = Character:FindFirstChildOfClass("Tool")
    if uD(Tool) then
        return Tool
    end
    return nil
end
local function fn543(iE)
    if iE == "Held" or iE == "All" then
        State.SellMode = iE
    end
end
local function fn565()
    if not State.Enabled.UpgradePlot then
        return
    end
    uH(re_PLOT_UPGRADE, "UpgradeSignBoard", "LastUpgradePlotAt", 1.5)
end
local function fn582(iG)
    State.TeleportToSellerWhileSelling = iG and true or false
end
local function fn583()
    local Treadmills = ui:FindFirstChild("Treadmills")
    if not Treadmills then
        return nil, nil
    end
    local yh = Treadmills:FindFirstChild("PersonalTreadmill_" .. tostring(u2.UserId))
    if yh then
        local Belt2 = yh:FindFirstChild("Belt", true)
        local yj = Belt2 and Belt2:IsA("BasePart")
        if yj then
            return Belt2, yh
        end
        for i, child in ipairs(Treadmills:GetChildren()) do
            local yg_1 = child:GetAttribute("RiderUserId") == u2.UserId or child:GetAttribute("OwnerUserId") == u2.UserId
            if yg_1 then
                local Belt = child:FindFirstChild("Belt", true)
                local yh_1 = Belt and Belt:IsA("BasePart")
                if yh_1 then
                    return Belt, child
                end
            end
        end
        return nil, nil
    end
    for i, child in ipairs(Treadmills:GetChildren()) do
        local yg_3 = child:GetAttribute("RiderUserId") == u2.UserId or child:GetAttribute("OwnerUserId") == u2.UserId
        if yg_3 then
            local Belt = child:FindFirstChild("Belt", true)
            local yh_2 = Belt and Belt:IsA("BasePart")
            if yh_2 then
                return Belt, child
            end
        end
    end
    return nil, nil
end
local function fn586(dv, dw)
    if not dv then
        return false
    end
    local y3 = dv.CFrame:PointToObjectSpace(dw)
    local y4 = math.abs(y3.X) > dv.Size.X / 2 - 2 or math.abs(y3.Z) > dv.Size.Z / 2 - 2
    if y4 then
        return false
    end
    local y3_1 = dv.Position.Y + dv.Size.Y / 2
    if math.abs(dw.Y - y3_1) > 2.5 then
        return false
    elseif tY(dv, dw) then
        return false
    else
        return true
    end
end
local function fn596(hV)
    t4("Place", hV, 0.35, t7)
end
local function fn605(iN)
    if not up() then
        return false
    end
    local B3 = iN
    if type(iN) == "table" then
        B3 = nil
        for k, v in pairs(iN) do
            local B4_1 = v == true and type(k) == "string"
            if B4_1 then
                B3 = k
                break
            elseif type(v) == "string" then
                B3 = v
                break
            end
        end
    end
    local B4_2 = B3 == ""
    local B5 = type(B3) ~= "string" or B4_2
    if B5 then
        return false
    end
    local B3_1 = uR[B3] or B3
    local B4_4 = tJ(B3_1)
    if not B4_4 then
        return false
    end
    tU(B4_4)
    return ud(CFrame.new(B4_4))
end
local function fn633()
    local AF_1
    local AE = not up() or not State.Enabled.Treadmill
    local AE_1
    if AE then
        return
    end
    if u2:GetAttribute("OnTreadmill") == true then
        return
    end
    if os.clock() - State.LastTreadmillAt < 0.8 then
        return
    end
    AF_1, AE_1 = t2()
    if not AF_1 then
        return
    end
    local AG = um(AF_1, AE_1)
    if not AG then
        return
    end
    tU(AG.Position)
    ud(AG)
    State.LastTreadmillAt = os.clock()
end
local function fn654(dl, dm)
    for i, child in ipairs(dl:GetChildren()) do
        if child.Name == "AppraisingCrate" or child.Name == "ItemStand" then
            local Position = child:GetPivot().Position
            local yV = Position.X - dm.X
            local yW = Position.Z - dm.Z
            if yV * yV + yW * yW < 9 then
                return true
            end
        end
    end
    return false
end
local function fn674()
    if not up() then
        return false
    end
    local B1 = uF()
    if not B1 then
        return false
    end
    tU(B1.Position)
    return ud(B1)
end
local function fn675(ic)
    t4("UpgradePlot", ic, 1.2, uZ)
end
local function fn752()
    if not uK() then
        return true
    end
    tU(tG)
    if not ud(CFrame.new(tG + Vector3.new(0, 3, 0))) then
        return false
    end
    local yO = os.clock() + 4
    while true do
        local yP = up() and uK() and os.clock() < yO
        if yP then
            ud(CFrame.new(tG + Vector3.new(0, 3, 0)))
            fns.Heartbeat:Wait()
            if not up() then
                return false
            end
            continue
        end
        break
    end
    return not uK()
end
local function fn794()
    local AV = not up() or not State.Enabled.ClaimIndex
    if AV then
        return
    end
    if os.clock() - State.LastClaimIndexAt < 2 then
        return
    end
    local AV_1 = pcall(function()
        Network.FireServer("INDEX_CLAIM_ALL")
    end)
    if AV_1 then
        State.LastClaimIndexAt = os.clock()
    end
end
local function fn802(dE)
    local y9, za, zb, zc, zf, zg, zh, zi, zk, zl, zm, zn
    local ze = 13
    while true do
        local ze_1 = 518 - ze
        do
            if ze_1 < 510 then
                if ze_1 < 508 then
                    if ze_1 < 507 then
                        if ze_1 < 505 then
                            if ze_1 < 503 then
                                if ze_1 < 502 then
                                    if ze_1 == 501 then
                                        return za
                                    end
                                    break
                                elseif ze_1 == 502 then
                                    za = Vector3.new(dE.Position.X, y9, dE.Position.Z)
                                    ze = if uS(dE, za) then 17 else 15
                                else
                                    ze = 515
                                    continue
                                end
                            elseif ze_1 < 504 then
                                if ze_1 == 503 then
                                    return nil
                                end
                                ze = 514
                                continue
                            else
                                ze = if zl > 0 and zm <= zk or zl <= 0 and zm >= zk then 5 else 12
                            end
                        elseif ze_1 < 506 then
                            ze = if not dE then 0 else 4
                        elseif ze_1 == 506 then
                            ze = 1
                        else
                            ze = 509
                            continue
                        end
                    else
                        return za
                    end
                elseif ze_1 < 509 then
                    if ze_1 == 508 then
                        local Position = (dE.CFrame * CFrame.new(zi, dE.Size.Y / 2, zn)).Position
                        za = Vector3.new(Position.X, y9, Position.Z)
                        ze = if uS(dE, za) then 11 else 8
                    else
                        ze = 11714
                        continue
                    end
                elseif ze_1 == 509 then
                    zm += zl
                    ze = 14
                else
                    ze = 515
                    continue
                end
            elseif ze_1 < 513 then
                if ze_1 < 511 then
                    if ze_1 == 510 then
                        ze = 9
                    else
                        ze = 6608
                        continue
                    end
                elseif ze_1 < 512 then
                    break
                elseif ze_1 == 512 then
                    za = -zb
                    zm = za
                    zk = zb
                    zl = zc
                    ze = 14
                else
                    ze = 14028
                    continue
                end
            elseif ze_1 < 514 then
                zn = zm
                ze = 10
            elseif ze_1 < 517 then
                if ze_1 < 516 then
                    if ze_1 < 515 then
                        y9 = dE.Position.Y + dE.Size.Y / 2
                        za = math.max(1, dE.Size.X / 2 - 2.5)
                        zb = math.max(1, dE.Size.Z / 2 - 2.5)
                        zc = 3.2
                        zh = -za
                        zf = za
                        zg = zc
                        ze = 3
                    elseif ze_1 == 515 then
                        ze = if zg > 0 and zh <= zf or zg <= 0 and zh >= zf then 2 else 16
                    else
                        ze = 15394
                        continue
                    end
                else
                    zi = zh
                    ze = 6
                end
            elseif ze_1 < 518 then
                if ze_1 == 517 then
                    zh += zg
                    ze = 3
                else
                    ze = 2676
                    continue
                end
            elseif ze_1 < 6608 then
                if ze_1 < 4132 then
                    if ze_1 < 2676 then
                        if ze_1 == 518 then
                            return nil
                        end
                        ze = 6608
                        continue
                    end
                    break
                end
                break
            else
                break
            end
        end
    end
end
local function fn869(M)
    local ws = typeof(cloneref) == "function" and typeof(M) == "Instance"
    if ws then
        return cloneref(M)
    end
    return M
end
local function fn881(h9)
    t4("UpgradeTreadmill", h9, 1.2, tH)
end
local function fn883(P)
    return type(P) == "function"
end
local function fn884(bc)
    if type(bc) ~= "table" then
        return false
    end
    for k, v in pairs(bc) do
        if v then
            return true
        end
    end
    return false
end
local function fn895()
    local yw = {}
    local yB = if uK() then 1 else 0
    if yB == 1 then
        return yw
    end
    local Character = u2.Character
    if Character then
        for i, child in ipairs(Character:GetChildren()) do
            if uD(child) then
                table.insert(yw, child)
            end
        end
    end
    for i, child in ipairs(u2.Backpack:GetChildren()) do
        if uD(child) then
            table.insert(yw, child)
        end
    end
    return yw
end
local function fn936()
    local Character = u2.Character
    if not Character then
        return nil
    end
    return Character:FindFirstChildOfClass("Humanoid")
end
local function fn949(ix)
    State.RarityFilter = uh(ix)
    local BP = if not ur(State.RarityFilter) then 1 else 0
    if BP == 1 then
        for i, v in ipairs(uc) do
            State.RarityFilter[v] = true
        end
    end
end
local function fn999(jt, ju)
    local Cn = false
    if ux(setclipboard) then
        Cn = pcall(setclipboard, jt)
    else
        local Cs = if ux(toclipboard) then 1 else 0
        if Cs == 1 then
            Cn = pcall(toclipboard, jt)
        end
    end
    if Cn and ju then
        Notify(ju, 3)
    elseif not Cn then
        Notify("Clipboard unavailable", 3)
    end
    return Cn
end
local function fn1038()
    return tB.CoreGui
end
local function fn1042(cL)
    local yr = cL and cL:IsA("Tool")
    if not yr then
        return false
    end
    local yr_1 = cL:GetAttribute("IsBatTool") or cL:GetAttribute("IsBearTrapTool") or cL:GetAttribute("IsTreadmill")
    if yr_1 then
        return false
    end
    return cL:GetAttribute("CrateUid") ~= nil
end
local function fn1076(a7)
    local wM = not a7 or not a7:IsA("ProximityPrompt") or not a7.Enabled
    if wM then
        return false
    elseif not ux(fireproximityprompt) then
        return false
    else
        local wM_1 = pcall(fireproximityprompt, a7)
        return wM_1
    end
end
local function fn1104(hS)
    t4("Steal", hS, 0, t_)
end
local function fn1137()
    if not State.TeleportToSellerWhileSelling then
        return true
    end
    local Bg = uT()
    local Bh = uA()
    if Bh and (Bh.Position - Bg.Position).Magnitude <= 12 then
        return true
    end
    tU(Bg.Position)
    return ud(Bg)
end
local function fn1143()
    return u2:GetAttribute("CarryingStolen") == true
end
local function fn1179(ao, ap)
    return (ao.Order or 0) < (ap.Order or 0)
end
local function fn1187(ca)
    local xY = uB(ca)
    if xY then
        local xZ = xY.Position.Y + xY.Size.Y / 2 + 3
        return Vector3.new(xY.Position.X, xZ, xY.Position.Z)
    end
    local Crates = ui:FindFirstChild("Crates")
    if Crates then
        for i, child in ipairs(Crates:GetChildren()) do
            if child:GetAttribute("AreaId") == ca then
                local Position = child:GetPivot().Position
                return Vector3.new(Position.X, Position.Y + 3, Position.Z)
            end
        end
    end
    return nil
end
local function fn1204(bq)
    local xc = bq == ""
    local xd = type(bq) ~= "string" or xc
    if xd then
        return false
    elseif not ur(State.ZoneFilter) then
        return true
    else
        local xc_1 = uO[bq]
        if xc_1 and State.ZoneFilter[xc_1] == true then
            return true
        end
        return State.ZoneFilter[bq] == true
    end
end
local function fn1232(hM, hN, hO, hP)
    local Enabled = State.Enabled
    local Bx = hN and true or false
    Enabled[hM] = Bx
    if State.Enabled[hM] then
        uY(hM, hO, hP)
    else
        State.Gens[hM] += 1
    end
end
local function fn1264()
    local x7_1
    local x6_1
    x6_1, x7_1 = tI()
    if x7_1 then
        local PlayerSpawn = x7_1:FindFirstChild("PlayerSpawn")
        local x8 = PlayerSpawn and PlayerSpawn:IsA("BasePart")
        if x8 then
            return PlayerSpawn.CFrame * CFrame.new(0, 3, 0)
        end
        return CFrame.new(x7_1.Position + Vector3.new(0, x7_1.Size.Y / 2 + 3, 0))
    end
    return nil
end
local function fn1282()
    local bU, bV = tI()
    return bV
end
local function fn1286(bg)
    local wY = {}
    if type(bg) == "table" then
        for k, v in pairs(bg) do
            local wZ = v == true and type(k) == "string"
            if wZ then
                wY[k] = true
            elseif type(v) == "string" then
                wY[v] = true
            end
        end
    end
    return wY
end
local function fn1319(bX)
    local xF = uJ[bX]
    local xG = xF == ""
    local xH = type(xF) ~= "string" or xG
    if xH then
        return nil
    end
    local Map = ui:FindFirstChild("Map")
    local xH_1 = { Map, ui }
    for i, v in ipairs(xH_1) do
        if v then
            local xG_2 = v:FindFirstChild(xF, true)
            local xH_2 = xG_2 and xG_2:IsA("BasePart")
            if xH_2 then
                return xG_2
            end
            for i, descendant in ipairs(v:GetDescendants()) do
                local xG_3 = descendant.Name == xF and descendant:IsA("BasePart")
                if xG_3 then
                    return descendant
                end
            end
        end
    end
    return nil
end
tB = nil
tD = nil
tG = nil
tH = nil
tI = nil
tJ = nil
tP = nil
ClientBalanceService = nil
tT = nil
tU = nil
InfiniteMath = nil
tY = nil
tZ = nil
t_ = nil
t1 = nil
t2 = nil
t4 = nil
connection = nil
t7 = nil
ua = nil
uc = nil
ud = nil
Network = nil
uh = nil
ui = nil
um = nil
un = nil
local rf_SELL_QUOTE, re_SELL_DO, re_PLACE_AT, tN, tO, tQ, t5, t9, ue, ul
up = nil
ur = nil
ux = nil
uA = nil
uB = nil
uD = nil
uF = nil
uG = nil
uH = nil
State = nil
uJ = nil
uK = nil
uL = nil
uM = nil
uN = nil
uO = nil
uR = nil
uS = nil
uT = nil
uU = nil
rf_ITEM_LOADOUT = nil
uY = nil
uZ = nil
u_ = nil
re_TREADMILL_UPGRADE = nil
u1 = nil
u2 = nil
re_PLOT_UPGRADE = nil
u5 = nil
local uo, uq, us, ut, uu, uv, uz, uE, uP, uV, uW, u4
uo = nil
uq = nil
us = nil
ut = nil
uu = nil
uv = nil
uz = nil
uE = nil
uP = nil
uV = nil
uW = nil
u4 = nil
if not game:IsLoaded() then
    game.Loaded:Wait()
end
tB, u2, u_ = nil, nil, nil
local FO_18 = 3
repeat
    if u2 and not FO_18 and (u2 and FO_18) and ((not tB or not FO_18) and (not FO_18 or tB)) and ((tB or not tB) and (FO_18 and u2) or (not tB or tB) and (FO_18 or not tB)) or ((not u2 or tB or (u2 or not tB)) and (not tB and u2 and (not u2 or u2)) or ((u2 or not u2) and (tB and u2) or (u2 or FO_18) and (tB and tB))) or not (u2 and not FO_18 and (u2 and FO_18) and ((not tB or not FO_18) and (not FO_18 or tB)) and ((tB or not tB) and (FO_18 and u2) or (not tB or tB) and (FO_18 or not tB)) or ((not u2 or tB or (u2 or not tB)) and (not tB and u2 and (not u2 or u2)) or ((u2 or not u2) and (tB and u2) or (u2 or FO_18) and (tB and tB)))) then
        tB = {}
        tB.Players = game:GetService("Players")
        tB.ReplicatedStorage = game:GetService("ReplicatedStorage")
        tB.RunService = game:GetService("RunService")
        tB.UserInputService = game:GetService("UserInputService")
        tB.VirtualUser = game:GetService("VirtualUser")
        tB.HttpService = game:GetService("HttpService")
        tB.TeleportService = game:GetService("TeleportService")
        tB.Workspace = game:GetService("Workspace")
        tB.Lighting = game:GetService("Lighting")
        tB.Stats = game:GetService("Stats")
        tB.CoreGui = game:GetService("CoreGui")
        tB.ProximityPromptService = game:GetService("ProximityPromptService")
        u2 = tB.Players.LocalPlayer
        u_ = fn1038
    else
        u_ = {}
        u_.Players = game:GetService("Players")
        u_.ReplicatedStorage = game:GetService("ReplicatedStorage")
        u_.RunService = game:GetService("RunService")
        u_.UserInputService = game:GetService("UserInputService")
        u_.VirtualUser = game:GetService("VirtualUser")
        u_.HttpService = game:GetService("HttpService")
        u_.TeleportService = game:GetService("TeleportService")
        u_.Workspace = game:GetService("Workspace")
        u_.Lighting = game:GetService("Lighting")
        u_.Stats = game:GetService("Stats")
        u_.CoreGui = game:GetService("CoreGui")
        u_.ProximityPromptService = game:GetService("ProximityPromptService")
        tB = u_.Players.LocalPlayer
        u2 = fn1038
    end
    FO_18 = (FO_18 + 7) % 8
until (FO_18 * 5 + 2) % 8 == 4
if getgenv then
    getgenv().gethui = u_
end
uM, State, ui, Network, InfiniteMath, ClientBalanceService, re_PLACE_AT, re_SELL_DO, rf_SELL_QUOTE, re_PLOT_UPGRADE, re_TREADMILL_UPGRADE, rf_ITEM_LOADOUT, ux, up = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
pcall(fns.fn1)
local function FO_19(i)
    local wf
    local wd
    local we
    wd = nil
    we = nil
    wf = nil
    local wg = i ~= ""
    local wh = type(i) == "string" and wg
    assert(wh, "Namespace is required")
    assert(type(getgenv) == "function", "getgenv is unavailable")
    wd = getgenv()
    assert(type(wd) == "table", "getgenv did not return a table")
    local wg_1 = wd[i]
    if wg_1 ~= nil then
        local wh_1 = type(wg_1) == "table" and type(wg_1.Unload) == "function"
        assert(wh_1, "Namespace is occupied")
        wg_1.Unload()
        assert(wd[i] == nil, "Previous instance did not release its namespace")
    end
    we = {}
    wf = { State = {}, Unloaded = false }
    wf.Track = function(o)
        assert(type(o) == "function", "Cleanup must be callable")
        if wf.Unloaded then
            o()
        else
            table.insert(we, o)
        end
        return o
    end
    wf.Unload = function()
        local v3_1
        local v2_1
        if wf.Unloaded then
            return
        end
        wf.Unloaded = true
        local v0 = {}
        local v7 = #we
        local v6 = -1
        while false and v7 <= 1 or true and v7 >= 1 do
            local v8 = v7
            local v1_1 = table.remove(we, v8)
            v2_1, v3_1 = pcall(v1_1)
            if not v2_1 then
                table.insert(v0, tostring(v3_1))
            end
            v7 += v6
        end
        table.clear(wf.State)
        if #v0 > 0 then
            error("Cleanup incomplete: " .. table.concat(v0, "; "), 0)
        end
        if wd[i] == wf then
            wd[i] = nil
        end
    end
    wd[i] = wf
    return wf
end
uM = FO_19("VexoraStealFromTheRich")
State = uM.State
local FO_11 = fn869
ux = fn883
up = fn212
local FO_2 = FO_11(tB.ReplicatedStorage)
ui = FO_11(tB.Workspace)
Network = require(FO_2:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network"))
local FO_5 = require(FO_2.Shared.Data.AreaData)
local FO_21 = require(FO_2.Shared.Data.TrailData)
local FO_12 = require(FO_2.Shared.Data.ItemData)
InfiniteMath = require(FO_2.Shared.Utility.InfiniteMath)
do
    local function findBalanceModule()
        local roots = { FO_2 }
        pcall(function()
            local lp = game:GetService("Players").LocalPlayer
            local ps = lp and lp:FindFirstChild("PlayerScripts")
            if ps then table.insert(roots, ps) end
        end)
        for _, root in ipairs(roots) do
            local ok, found = pcall(function()
                return root:FindFirstChild("ClientBalanceService", true)
            end)
            if ok and found and found:IsA("ModuleScript") then
                return found
            end
        end
        return nil
    end

    local mod
    for _ = 1, 20 do
        mod = findBalanceModule()
        if mod then break end
        task.wait(0.5)
    end

    local okReq, svc = false, nil
    if mod then
        okReq, svc = pcall(require, mod)
    end
    if okReq and svc then
        ClientBalanceService = svc
    else
        warn("[Fix] Không tìm thấy ClientBalanceService, dùng bản dự phòng (Balance = 0).")
        ClientBalanceService = { Balance = nil }
    end
end
re_PLACE_AT = FO_2:WaitForChild("re_PLACE_AT", 30)
re_SELL_DO = FO_2:WaitForChild("re_SELL_DO", 30)
rf_SELL_QUOTE = FO_2:WaitForChild("rf_SELL_QUOTE", 30)
re_PLOT_UPGRADE = FO_2:WaitForChild("re_PLOT_UPGRADE", 30)
re_TREADMILL_UPGRADE = FO_2:WaitForChild("re_TREADMILL_UPGRADE", 30)
rf_ITEM_LOADOUT = FO_2:WaitForChild("rf_ITEM_LOADOUT", 30)
FO_18 = re_PLACE_AT and re_SELL_DO
FO_2 = FO_18 and rf_SELL_QUOTE
FO_18 = FO_2 and re_PLOT_UPGRADE
FO_2 = FO_18 and re_TREADMILL_UPGRADE
FO_18 = FO_2 and rf_ITEM_LOADOUT
uU, uR, uO, uJ = nil, nil, nil, nil
FO_2 = 0
repeat
    FO_11 = (FO_2 * 1 + 1) % 2 + 1
    if FO_11 <= 1 then
        if not uO and not uO and (uO or uO) and (uO and not uO and (uO and uO)) or (not uR and uO and (not uO and not uO) or (not uO or not uO) and (not uR and not uO)) or (not uO and uR and (not uR or not uO) or (not uR and uR or uR and not uO)) and ((not uO or not uO or uO and uR) and (not uR and not uO or not uO and uO)) or not (not uO and not uO and (uO or uO) and (uO and not uO and (uO and uO)) or (not uR and uO and (not uO and not uO) or (not uO or not uO) and (not uR and not uO)) or (not uO and uR and (not uR or not uO) or (not uR and uR or uR and not uO)) and ((not uO or not uO or uO and uR) and (not uR and not uO or not uO and uO))) then
            uR = {}
            uO = {}
            uJ = {}
        else
            uJ = {}
            uR = {}
            uO = {}
        end
        FO_2 = (FO_2 + 13) % 16
    else
        if (FO_2 * 2 + 1) * 16 % 3 == ((FO_2 * 2 + 1) * 16 + 8) % 3 then
            assert(uU, "Core remotes missing")
            FO_18 = {}
        else
            assert(FO_18, "Core remotes missing")
            uU = {}
        end
        FO_2 = (FO_2 + 5) % 16
    end
until (FO_2 * 9 + 1) % 16 == 3
FO_11 = {}
for i, v in ipairs(FO_5.Areas) do
    FO_18 = type(v) == "table" and type(v.Id) == "string"
    if FO_18 then
        table.insert(FO_11, v)
    end
end
FO_18 = 2
repeat
    FO_2 = (vector.create((FO_18 * 2 + 4) % 11 + 1, (FO_18 * 9 + 7) % 13 + 1, (FO_18 * 7 + 9) % 17 + 1))
    local Ib = vector.floor(FO_2) + vector.ceil(FO_2 * -1)
    if vector.dot(Ib, Ib) == 4 then
        table.sort(FO_11, fn1179)
    else
        table.sort(FO_11, fn1179)
    end
    FO_18 = (FO_18 + 7) % 8
until (FO_18 * 7 + 0) % 8 == 7
for i, v in ipairs(FO_11) do
    FO_18 = v.Id
    FO_2 = v.DisplayName or v.Id
    FO_11 = FO_18 .. " - " .. tostring(FO_2)
    table.insert(uU, FO_11)
    uR[FO_11] = v.Id
    uO[v.Id] = FO_11
    if type(v.AreaPart) == "string" then
        uJ[v.Id] = v.AreaPart
    end
end
uc = {}
local vF = 1
while true do
    if vF <= 20 then
        local vG = vF
        FO_18 = FO_12:GetTierByIndex(vG)
        FO_2 = type(FO_18) == "table" and type(FO_18.Name) == "string"
        if FO_2 then
            table.insert(uc, FO_18.Name)
            vF += 1
            continue
        end
        break
    end
    break
end
if #uc == 0 then
    FO_18 = 6
    repeat
        FO_2 = {
            "kkgnipmex",
            "cxcsqoow",
            "yeyljewpsy",
            "fmxzbqnl",
            "kscxfc",
            "jygric",
            "dxjco",
            "dpvsfozxmmr",
            "qaigffoifr",
            "fwi",
            "kyhdmylffta"
        }
        if FO_2[(FO_18 * 69 + 98) % 11 + 1] <= FO_2[(FO_18 * 69 + 98) % 11 + 1] then
            uc = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Divine" }
        else
            uc = { "Epic", "Uncommon", "Legendary", "Mythic", "Common", "Rare", "Divine", "Secret" }
        end
        FO_18 = (FO_18 + 0) % 8
    until (FO_18 * 3 + 6) % 8 == 0
end
tT, tN, tG, tD, u4 = nil, nil, nil, nil, nil
tT = { "Held", "All" }
tN = { Held = "held", All = "all" }
tG = Vector3.new(2437, 4, -928)
tD = Vector3.new(2437.8, 5, -860)
u4 = {}
FO_18 = FO_21.Trails
if type(FO_18) == "table" then
    for i, v in ipairs(FO_18) do
        FO_18 = type(v) == "table" and type(v.Id) == "string"
        if FO_18 then
            table.insert(u4, v)
        end
    end
end
State.Enabled = {
    Steal = false,
    Place = false,
    Open = false,
    EquipBest = false,
    BuyEquipSlot = false,
    Treadmill = false,
    UpgradeTreadmill = false,
    UpgradePlot = false,
    ClaimIndex = false,
    BuyTrails = false,
    Sell = false
}
State.RarityFilter = {}
State.ZoneFilter = {}
for i, v in ipairs(uc) do
    State.RarityFilter[v] = true
end
for i, v in ipairs(uU) do
    State.ZoneFilter[v] = true
end
uA, ul, ud, tU, uG, ur, uh, tP, u1, uE, us, tI, uP, uB, tJ, uF, um, t2, uK, uD, uq, t9, uV, uu, tY, uS, uv, tO, uW, t_, t7, t1, ua, u5, tZ, uH, tH, uZ, uL, un, uT, tQ, uN, uY, t4 = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
State.SellMode = "All"
State.TeleportToSellerWhileSelling = false
State.Gens = {
    Steal = 0,
    Place = 0,
    Open = 0,
    EquipBest = 0,
    BuyEquipSlot = 0,
    Treadmill = 0,
    UpgradeTreadmill = 0,
    UpgradePlot = 0,
    ClaimIndex = 0,
    BuyTrails = 0,
    Sell = 0
}
State.TrailOwned = {}
State.LastStealAt = 0
State.LastPlaceAt = 0
State.LastOpenAt = 0
State.LastEquipBestAt = 0
State.LastBuySlotAt = 0
State.LastTreadmillAt = 0
State.LastUpgradeTreadmillAt = 0
State.LastUpgradePlotAt = 0
State.LastClaimIndexAt = 0
State.LastBuyTrailsAt = 0
State.LastSellAt = 0
uA = fn68
ul = fn936
ud = fn352
tU = function(aX)
    if typeof(aX) ~= "Vector3" then
        return
    end
    pcall(function()
        local wK = if ux(u2.RequestStreamAroundAsync) then 1 else 0
        if wK == 1 then
            task.defer(function()
                pcall(function()
                    u2:RequestStreamAroundAsync(aX)
                end)
            end)
        end
    end)
end
uG = fn1076
ur = fn884
uh = fn1286
tP = fn114
u1 = fn1204
uE = fn387
us = function(bB)
    local xn
    local xp_1
    xn = tonumber(bB)
    local xo = not xn or xn <= 0
    local xo_1
    if xo then
        return true
    end
    xo_1, xp_1 = pcall(function()
        return uE() >= InfiniteMath.new(xn)
    end)
    return xo_1 and xp_1 == true
end
tI = fn398
uP = fn1282
uB = fn1319
tJ = fn1187
uF = fn1264
um = fn444
t2 = fn583
uK = fn1143
uD = fn1042
uq = fn506
if (not uq or false or false) and ((us or not uq) and (not uq or not uq)) or (us and uq or not uD and uq or (uD and us or not uq and not uq)) or not ((not uq or false or false) and ((us or not uq) and (not uq or not uq)) or (us and uq or not uD and uq or (uD and us or not uq and not uq))) then
    t9 = fn895
    uV = fn752
else
    uV = fn895
    t9 = fn752
end
uu = function(dc)
    if not (dc and dc.Parent) then
        return false
    end
    local yR = ul()
    if not yR then
        return false
    elseif dc.Parent == u2.Character then
        return true
    else
        local yS_1 = pcall(function()
            yR:EquipTool(dc)
        end)
        return yS_1
    end
end
tY = fn654
uS = fn586
uv = fn802
tO = fn174
uW = fn340
local function StealAnchor(crate)
    local prompt = crate.prompt
    local holder = prompt and prompt.Parent
    if holder then
        if holder:IsA("BasePart") then
            return holder.Position
        elseif holder:IsA("Attachment") then
            return holder.WorldPosition
        end
    end
    local ok, pivot = pcall(function()
        return crate.model:GetPivot().Position
    end)
    return ok and pivot or crate.position
end
t_ = function()
    if not up() or not State.Enabled.Steal then
        return
    end
    if uK() then
        State.StealStatus = "Depositing"
        uV()
        return
    end
    local root = uA()
    if not root then
        State.StealStatus = "Waiting for character"
        return
    end
    local crates = uW()
    if #crates == 0 then
        State.StealStatus = "Searching for crates"
        return
    end
    local blocked = State.StealBlocked
    if not blocked then
        blocked = {}
        State.StealBlocked = blocked
    end
    local now = os.clock()
    local target, bestDist
    for _, crate in ipairs(crates) do
        local untilAt = blocked[crate.model]
        if not (untilAt and untilAt > now) then
            blocked[crate.model] = nil
            local dist = (crate.position - root.Position).Magnitude
            if not bestDist or dist < bestDist then
                target, bestDist = crate, dist
            end
        end
    end
    if not target then
        State.StealStatus = "Searching for crates"
        return
    end

    State.StealStatus = "Grabbing"
    local prompt = target.prompt
    fns.FastPrompt(prompt)
    local spot = StealAnchor(target)
    tU(spot)
    ud(CFrame.new(spot + Vector3.new(0, 3, 0)))
    if not up() or not State.Enabled.Steal then
        return
    end

    local burst = math.clamp(State.StealBurst or 3, 1, 10)
    local deadline = os.clock() + 1.0
    local fired = false
    while up() and State.Enabled.Steal and os.clock() < deadline do
        if uK() or not (prompt.Parent and prompt.Enabled) then
            break
        end
        for _ = 1, burst do
            if uG(prompt) then
                fired = true
            end
        end
        fns.Heartbeat:Wait()
        if uK() then
            break
        end
        local me = uA()
        local nowSpot = StealAnchor(target)
        if me and (me.Position - nowSpot).Magnitude > 8 then
            ud(CFrame.new(nowSpot + Vector3.new(0, 3, 0)))
        end
    end
    if not up() or not State.Enabled.Steal then
        return
    end
    if uK() then
        State.StealCount = (State.StealCount or 0) + 1
        State.LastStealAt = os.clock()
        State.StealStatus = "Depositing"
        uV()
    else
        blocked[target.model] = os.clock() + (fired and 0.6 or 0.3)
    end
    if up() and State.Enabled.Steal then
        return t_()
    end
end
t7 = function()
    local zZ, z_
    if not up() or not State.Enabled.Place then
        return
    end
    if uK() then
        uV()
        return
    end
    if os.clock() - State.LastPlaceAt < 0.55 then
        return
    end
    local z0_1 = uP()
    if not z0_1 then
        return
    end
    local z1 = uq()
    if not z1 then
        local z2_1 = t9()
        if #z2_1 == 0 then
            return
        end
        uu(z2_1[1])
        task.wait(0.15)
        local z9 = if uK() then 1 else 0
        if z9 == 1 then
            return
        end
        z1 = uq()
        if not z1 then
            return
        end
    end
    zZ = uv(z0_1)
    if not zZ then
        return
    end
    tU(zZ)
    ud(CFrame.new(zZ + Vector3.new(0, 4, 0)))
    task.wait(0.1)
    local z2_2 = not up() or not State.Enabled.Place
    if z2_2 then
        return
    end
    if not uS(z0_1, zZ) then
        return
    end
    z_ = tO(z1)
    local z0_2 = pcall(function()
        re_PLACE_AT:FireServer(zZ, z_)
    end)
    if z0_2 then
        State.LastPlaceAt = os.clock()
    end
end
t1 = fn98
ua = fn70
u5 = function()
    local Aw
    local Ay_1
    local Ax = not up() or not State.Enabled.BuyEquipSlot
    local Ax_1, Ax_2
    if Ax then
        return
    end
    if os.clock() - State.LastBuySlotAt < 1.5 then
        return
    end
    Ax_1, Aw = tI()
    if not Aw then
        return
    end
    Ax_2, Ay_1 = pcall(function()
        return rf_ITEM_LOADOUT:InvokeServer("list")
    end)
    local Az = Ax_2 and type(Ay_1) == "table"
    if Az then
        local Ax_3 = tonumber(Ay_1.NextPrice)
        local Az_1 = Ax_3 and Ax_3 > 0 and not us(Ax_3)
        if Az_1 then
            return
        end
        local Ax_4 = type(Ay_1.Slots) == "number" and type(Ay_1.NextSlots) == "number" and Ay_1.NextSlots <= Ay_1.Slots
        if Ax_4 then
            return
        end
    end
    local Ax_5 = pcall(function()
        re_PLOT_UPGRADE:FireServer(Aw, true)
    end)
    if Ax_5 then
        State.LastBuySlotAt = os.clock()
    end
end
tZ = fn633
uH = function(fZ, f_, f0, f1)
    local AL
    AL = nil
    if not up() then
        return
    end
    local AM = os.clock()
    if AM - (State[f0] or 0) < (f1 or 1.5) then
        return
    end
    AL = select(1, tI())
    if not AL then
        return
    end
    local AM_2 = AL:FindFirstChild(f_, true)
    if AM_2 then
        if AM_2:GetAttribute("CanAfford") == false then
            return
        end
        local AN_1 = tonumber(AM_2:GetAttribute("UpgradePrice"))
        local AM_3 = AN_1 and AN_1 > 0 and not us(AN_1)
        if AM_3 then
            return
        end
    end
    local AM_4 = pcall(function()
        fZ:FireServer(AL)
    end)
    if AM_4 then
        State[f0] = os.clock()
    end
end
tH = fn88
uZ = fn565
uL = fn794
un = function()
    local A_ = not up() or not State.Enabled.BuyTrails
    if A_ then
        return
    end
    if os.clock() - State.LastBuyTrailsAt < 1.2 then
        return
    end
    local A__1 = false
    for i, v in ipairs(u4) do
        local A8 = v
        local A0 = not up() or not State.Enabled.BuyTrails
        if A0 then
            break
        elseif State.TrailOwned[A8.Id] ~= true then
            local A0_1 = tonumber(A8.Price) or 0
            if us(A0_1) then
                local A0_2 = pcall(function()
                    Network.FireServer("TRAIL_BUY", A8.Id)
                end)
                if A0_2 then
                    A__1 = true
                    task.wait(0.2)
                end
            end
        end
    end
    if A__1 then
        State.LastBuyTrailsAt = os.clock()
        pcall(function()
            Network.FireServer("TRAIL_STATE")
        end)
    end
end
uT = fn353
tQ = fn1137
uN = function()
    local Bk
    local Bm_1, Bm_2
    local Bl = not up() or not State.Enabled.Sell
    local Bl_2, Bl_3
    if Bl then
        return
    end
    if os.clock() - State.LastSellAt < 1.2 then
        return
    end
    Bk = tN[State.SellMode] or "all"
    if Bk == "held" then
        Bl_2, Bm_1 = pcall(function()
            return rf_SELL_QUOTE:InvokeServer()
        end)
        local Bn_1 = Bl_2 and type(Bm_1) == "table" and Bm_1.HeldLabel and Bm_1.HeldPrice
        if not Bn_1 then
            return
        end
    elseif Bk == "all" then
        Bl_3, Bm_2 = pcall(function()
            return rf_SELL_QUOTE:InvokeServer()
        end)
        local Bn_2 = Bl_3 and type(Bm_2) == "table"
        if Bn_2 then
            local Bl_4 = tonumber(Bm_2.AllCount) or 0
            if Bl_4 <= 0 then
                return
            end
        end
    end
    if not tQ() then
        return
    end
    if State.TeleportToSellerWhileSelling then
        task.wait(0.08)
        local Bl_5 = not up() or not State.Enabled.Sell
        if Bl_5 then
            return
        end
    end
    local Bl_6 = pcall(function()
        re_SELL_DO:FireServer(Bk)
    end)
    if Bl_6 then
        State.LastSellAt = os.clock()
    end
end
uY = function(hv, hw, hx)
    State.Gens[hv] += 1
    local hz = State.Gens[hv]
    task.spawn(function()
        local Bt_1
        while true do
            local Bs = up() and State.Enabled[hv] and State.Gens[hv] == hz
            local Bs_1
            if Bs then
                Bs_1, Bt_1 = pcall(hx)
                if not Bs_1 then
                    warn("[VexoraHub][StealFromTheRich]", hv, Bt_1)
                end
                task.wait(type(hw) == "function" and hw() or hw)
                local Bs_2 = not up() or not State.Enabled[hv] or State.Gens[hv] ~= hz
                if Bs_2 then
                    break
                end
                continue
            end
            break
        end
    end)
end
t4 = fn1232
uM.SetSteal = fn1104
uM.SetStealBurst = function(n)
    State.StealBurst = math.clamp(math.floor(tonumber(n) or 3), 1, 10)
end
uM.SetPlace = fn596
uM.SetOpen = fn73
uM.SetEquipBest = fn222
uM.SetBuyEquipSlot = fn470
uM.SetTreadmill = fn429
uM.SetUpgradeTreadmill = fn881
uM.SetUpgradePlot = fn675
uM.SetClaimIndex = fn160
uM.SetBuyTrails = fn342
uM.SetSell = fn193
uM.SetZoneFilter = fn196
uM.SetRarityFilter = fn949
uM.SetSellMode = fn543
uM.SetTeleportToSellerWhileSelling = fn582
uM.TeleportToBase = fn674
uM.TeleportToZone = fn605
connection = nil
FO_18 = pcall(function()
    connection = Network.OnClientEvent("TRAIL_STATE"):Connect(function(i1)
        local Cg = type(i1) == "table" and type(i1.Owned) == "table"
        if Cg then
            State.TrailOwned = i1.Owned
        end
    end)
    Network.FireServer("TRAIL_STATE")
end)
FO_2 = FO_18 and connection
if FO_2 then
    uM.Track(function()
        pcall(function()
            connection:Disconnect()
        end)
    end)
end
uM.Track(function()
    for k in pairs(State.Gens) do
        State.Gens[k] += 1
        State.Enabled[k] = false
    end
end)
FO_18 = ux(fireproximityprompt)
FO_2 = ux(setclipboard) or ux(toclipboard)
FO_19, FO_5 = nil, nil
FO_11 = 15
repeat
    FO_12 = (FO_11 * 1 + 0) % 2 + 1
    if FO_12 <= 1 then
        FO_12 = (vector.create((FO_11 * 4 + 8) % 11 + 1, (FO_11 * 11 + 13) % 13 + 1, (FO_11 * 13 + 7) % 17 + 1))
        FO_21 = (vector.create((FO_11 * 6 + 6) % 11 + 1, (FO_11 * 2 + 10) % 13 + 1, (FO_11 * 11 + 8) % 17 + 1))
        FO_16 = (vector.create((FO_11 * 7 + 4) % 11 + 1, (FO_11 * 6 + 7) % 13 + 1, (FO_11 * 12 + 13) % 17 + 1))
        if vector.dot(vector.cross(FO_12, FO_21), FO_16) == vector.dot(vector.cross(FO_21, FO_16), FO_12) + 4 then
            FO_19 = {}
        else
            FO_5 = {}
        end
        FO_11 = (FO_11 + 15) % 16
    else
        FO_12 = (vector.create((FO_11 * 2 + 1) % 11 + 1, (FO_11 * 8 + 9) % 13 + 1, (FO_11 * 7 + 11) % 17 + 1))
        FO_21 = (vector.create((FO_11 * 4 + 6) % 11 + 1, (FO_11 * 9 + 12) % 13 + 1, (FO_11 * 9 + 15) % 17 + 1))
        FO_16 = (vector.create((FO_11 * 2 + 6) % 11 + 1, (FO_11 * 11 + 12) % 13 + 1, (FO_11 * 7 + 17) % 17 + 1))
        if vector.dot(vector.cross(FO_12, FO_21), FO_16) == vector.dot(vector.cross(FO_21, FO_16), FO_12) + 1 then
            ux = { identifyexecutor = FO_2(identifyexecutor), fireproximityprompt = FO_18, setclipboard = FO_19 }
        else
            FO_19 = { fireproximityprompt = FO_18, setclipboard = FO_2, identifyexecutor = ux(identifyexecutor) }
        end
        FO_11 = (FO_11 + 7) % 16
    end
until (FO_11 * 5 + 10) % 16 == 3
if not FO_19.fireproximityprompt then
    table.insert(FO_5, "fireproximityprompt")
end
if #FO_5 == 0 then
    FO_2 = "(ready)"
else
    FO_2 = "(missing " .. table.concat(FO_5, ", ") .. ")"
end
uz = FO_2
t5 = {
    WalkSpeedEnabled = false,
    WalkSpeed = 32,
    InfJump = false,
    NoClip = false,
    Fly = false,
    FlySpeed = 60,
    InstantPP = false,
    WalkSnapshots = {},
    NoClipSnapshots = {},
    FlyPlatformStand = nil,
    InfJumpConn = nil,
    NoClipConn = nil,
    FlyConn = nil,
    InstantConn = nil,
    InstantSnapshots = {}
}
FO_21 = function()
    local connection
    connection = nil
    local D4
    D4 = function(k2)
        if not k2 then
            return
        end
        if t5.WalkSnapshots[k2] == nil then
            t5.WalkSnapshots[k2] = k2.WalkSpeed
        end
        if t5.WalkSpeedEnabled then
            k2.WalkSpeed = t5.WalkSpeed
        end
    end
    uM.SetWalkSpeedEnabled = function(k5)
        local CS = k5 and true or false
        t5.WalkSpeedEnabled = CS
        local CR_1 = ul()
        if not CR_1 then
            return
        end
        if t5.WalkSpeedEnabled then
            D4(CR_1)
        elseif t5.WalkSnapshots[CR_1] ~= nil then
            CR_1.WalkSpeed = t5.WalkSnapshots[CR_1]
        end
    end
    uM.SetWalkSpeedValue = function(lc)
        t5.WalkSpeed = lc
        if t5.WalkSpeedEnabled then
            local CX = ul()
            if CX then
                CX.WalkSpeed = lc
            end
        end
    end
    uM.SetInfJump = function(lg)
        local C1 = lg and true or false
        t5.InfJump = C1
        if t5.InfJumpConn then
            t5.InfJumpConn:Disconnect()
            t5.InfJumpConn = nil
        end
        if not t5.InfJump then
            return
        end
        t5.InfJumpConn = tB.UserInputService.JumpRequest:Connect(function()
            local CZ = not up() or not t5.InfJump
            if CZ then
                return
            end
            local CZ_1 = ul()
            if CZ_1 then
                CZ_1:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
    uM.SetNoClip = function(ls)
        local C8 = ls and true or false
        t5.NoClip = C8
        if t5.NoClipConn then
            t5.NoClipConn:Disconnect()
            t5.NoClipConn = nil
        end
        local Character = u2.Character
        if not t5.NoClip then
            for k, v in pairs(t5.NoClipSnapshots) do
                if k and k.Parent then
                    k.CanCollide = v
                end
            end
            table.clear(t5.NoClipSnapshots)
            return
        end
        local function C6(lB)
            local C3 = lB:IsA("BasePart") and t5.NoClipSnapshots[lB] == nil
            if C3 then
                t5.NoClipSnapshots[lB] = lB.CanCollide
                lB.CanCollide = false
            end
        end
        if Character then
            for i, descendant in ipairs(Character:GetDescendants()) do
                C6(descendant)
            end
            t5.NoClipConn = Character.DescendantAdded:Connect(function(lG)
                if t5.NoClip then
                    C6(lG)
                end
            end)
        end
    end
    uM.SetFly = function(lJ)
        local Dx = lJ and true or false
        t5.Fly = Dx
        if t5.FlyConn then
            t5.FlyConn:Disconnect()
            t5.FlyConn = nil
        end
        local Dw_1 = ul()
        if not t5.Fly then
            if Dw_1 and t5.FlyPlatformStand ~= nil then
                Dw_1.PlatformStand = t5.FlyPlatformStand
            end
            t5.FlyPlatformStand = nil
            return
        end
        if Dw_1 then
            t5.FlyPlatformStand = Dw_1.PlatformStand
            Dw_1.PlatformStand = true
        end
        t5.FlyConn = tB.RunService.RenderStepped:Connect(function()
            local Dp = not up() or not t5.Fly
            if Dp then
                return
            end
            if tB.UserInputService:GetFocusedTextBox() then
                return
            end
            local Dp_1 = uA()
            local CurrentCamera = ui.CurrentCamera
            if not (Dp_1 and CurrentCamera) then
                return
            end
            local Dr_1 = Vector3.zero
            local Dv = if tB.UserInputService:IsKeyDown(Enum.KeyCode.W) then 1 else 0
            if Dv == 1 then
                Dr_1 += CurrentCamera.CFrame.LookVector
            end
            local Dv_1 = if tB.UserInputService:IsKeyDown(Enum.KeyCode.S) then 1 else 0
            if Dv_1 == 1 then
                Dr_1 -= CurrentCamera.CFrame.LookVector
            end
            if tB.UserInputService:IsKeyDown(Enum.KeyCode.A) then
                Dr_1 -= CurrentCamera.CFrame.RightVector
            end
            if tB.UserInputService:IsKeyDown(Enum.KeyCode.D) then
                Dr_1 += CurrentCamera.CFrame.RightVector
            end
            local Dv_2 = if tB.UserInputService:IsKeyDown(Enum.KeyCode.Space) then 1 else 0
            if Dv_2 == 1 then
                Dr_1 += Vector3.yAxis
            end
            if tB.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                Dr_1 -= Vector3.yAxis
            end
            if Dr_1.Magnitude > 0 then
                Dp_1.AssemblyLinearVelocity = Dr_1.Unit * t5.FlySpeed
            else
                Dp_1.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    end
    uM.SetFlySpeed = function(l2)
        t5.FlySpeed = l2
    end
    uM.SetInstantProximityPrompt = function(l4)
        local DP
        local DR = l4 and true or false
        t5.InstantPP = DR
        if t5.InstantConn then
            t5.InstantConn:Disconnect()
            t5.InstantConn = nil
        end
        local function DQ_1()
            for k, v in pairs(t5.InstantSnapshots) do
                if k and k.Parent then
                    k.HoldDuration = v.HoldDuration
                    k.MaxActivationDistance = v.MaxActivationDistance
                    k.RequiresLineOfSight = v.RequiresLineOfSight
                end
            end
            table.clear(t5.InstantSnapshots)
        end
        if not t5.InstantPP then
            DQ_1()
            return
        end
        DP = function(mc)
            if not mc:IsA("ProximityPrompt") then
                return
            end
            if t5.InstantSnapshots[mc] == nil then
                t5.InstantSnapshots[mc] = {
                    HoldDuration = mc.HoldDuration,
                    MaxActivationDistance = mc.MaxActivationDistance,
                    RequiresLineOfSight = mc.RequiresLineOfSight
                }
            end
            mc.HoldDuration = 0
            mc.MaxActivationDistance = 50
            mc.RequiresLineOfSight = false
        end
        for i, descendant in ipairs(ui:GetDescendants()) do
            DP(descendant)
        end
        t5.InstantConn = ui.DescendantAdded:Connect(function(mh)
            if t5.InstantPP then
                DP(mh)
            end
        end)
    end
    local function onCharacterAdded(ml)
        task.defer(function()
            if not up() then
                return
            end
            local Humanoid = ml:WaitForChild("Humanoid", 10)
            if not Humanoid then
                return
            end
            if t5.WalkSpeedEnabled then
                D4(Humanoid)
            end
            if t5.NoClip then
                uM.SetNoClip(true)
            end
            if t5.Fly then
                uM.SetFly(true)
            end
        end)
    end
    if u2.Character then
        onCharacterAdded(u2.Character)
    end
    connection = u2.CharacterAdded:Connect(onCharacterAdded)
    uM.Track(function()
        connection:Disconnect()
    end)
    uM.Track(function()
        uM.SetWalkSpeedEnabled(false)
        uM.SetInfJump(false)
        uM.SetNoClip(false)
        uM.SetFly(false)
        uM.SetInstantProximityPrompt(false)
    end)
end
ue = {
    AntiAfk = true,
    NoGameplayPaused = true,
    AutoReconnect = false,
    Disable3D = false,
    FpsBoost = false,
    AfkConn = nil,
    AfkTask = nil,
    AfkCount = 0,
    ReconnectConns = {},
    FpsSnapshots = {},
    FpsConn = nil
}
FO_16 = function()
    local function nN()
        if not ui.CurrentCamera then
            return false
        end
        local Eh_1 = not ux(tB.VirtualUser.CaptureController) or not ux(tB.VirtualUser.ClickButton2)
        if Eh_1 then
            return false
        end
        local Eh_2 = pcall(function()
            tB.VirtualUser:CaptureController()
            tB.VirtualUser:ClickButton2(Vector2.new())
        end)
        if Eh_2 then
            ue.AfkCount = ue.AfkCount + 1
        end
        return Eh_2
    end
    uM.SetAntiAfk = function(n_)
        local Ev = n_ and true or false
        ue.AntiAfk = Ev
        if ue.AfkConn then
            ue.AfkConn:Disconnect()
            ue.AfkConn = nil
        end
        if ue.AfkTask then
            pcall(task.cancel, ue.AfkTask)
            ue.AfkTask = nil
        end
        if not ue.AntiAfk then
            return
        end
        ue.AfkConn = u2.Idled:Connect(function()
            local Em = up() and ue.AntiAfk
            if Em then
                nN()
            end
        end)
        ue.AfkTask = task.spawn(function()
            local Eo = os.clock()
            while true do
                local Ep = up() and ue.AntiAfk
                if Ep then
                    task.wait(1)
                    if not up() or not ue.AntiAfk then
                        break
                    end
                    if os.clock() - Eo >= 60 then
                        Eo = os.clock()
                        nN()
                    end
                    continue
                end
                break
            end
        end)
    end
    uM.SetNoGameplayPaused = function(oh)
        local EB = oh and true or false
        ue.NoGameplayPaused = EB
    end
    uM.SetAutoReconnect = function(oj)
        local EG = oj and true or false
        ue.AutoReconnect = EG
        for i, v in ipairs(ue.ReconnectConns) do
            v:Disconnect()
        end
        table.clear(ue.ReconnectConns)
        if not ue.AutoReconnect then
            return
        end
        table.insert(ue.ReconnectConns, tB.TeleportService.TeleportInitFailed:Connect(function()
            local ED = not up() or not ue.AutoReconnect
            if ED then
                return
            end
            task.wait(1)
            local ED_1 = up() and ue.AutoReconnect
            if ED_1 then
                pcall(function()
                    tB.TeleportService:Teleport(game.PlaceId, u2)
                end)
            end
        end))
    end
    uM.SetDisable3D = function(oB)
        local ES = oB and true or false
        ue.Disable3D = ES
        pcall(function()
            tB.RunService:Set3dRenderingEnabled(not ue.Disable3D)
        end)
    end
    uM.SetFpsBoost = function(oG)
        local Fg
        local Fi = oG and true or false
        ue.FpsBoost = Fi
        if ue.FpsConn then
            ue.FpsConn:Disconnect()
            ue.FpsConn = nil
        end
        local function Fh_1()
            for k, v in pairs(ue.FpsSnapshots) do
                local EZ = k
                if EZ and EZ.Parent then
                    for k, v in pairs(v) do
                        local E4 = k
                        local E6 = v
                        pcall(function()
                            EZ[E4] = E6
                        end)
                    end
                end
            end
            table.clear(ue.FpsSnapshots)
        end
        if not ue.FpsBoost then
            Fh_1()
            return
        end
        Fg = function(oT)
            if ue.FpsSnapshots[oT] then
                return
            end
            local E7 = oT:IsA("ParticleEmitter") or oT:IsA("Trail") or oT:IsA("Beam")
            if not E7 then
                E7 = oT:IsA("Fire")
            end
            if not E7 then
                E7 = oT:IsA("Smoke")
            end
            if not E7 then
                E7 = oT:IsA("Sparkles")
            end
            if E7 then
                ue.FpsSnapshots[oT] = { Enabled = oT.Enabled }
                oT.Enabled = false
            end
        end
        for i, descendant in ipairs(ui:GetDescendants()) do
            Fg(descendant)
        end
        if ue.FpsSnapshots[tB.Lighting] == nil then
            ue.FpsSnapshots[tB.Lighting] = { GlobalShadows = tB.Lighting.GlobalShadows, FogEnd = tB.Lighting.FogEnd }
            tB.Lighting.GlobalShadows = false
        end
        ue.FpsConn = ui.DescendantAdded:Connect(function(o_)
            if ue.FpsBoost then
                Fg(o_)
            end
        end)
    end
    uM.Track(function()
        uM.SetAntiAfk(false)
        uM.SetAutoReconnect(false)
        uM.SetDisable3D(false)
        uM.SetFpsBoost(false)
    end)
end
local HUB_NAME    = "Vexora Hub"
local SCRIPT_NAME = "Steal From The Rich!"
local SCRIPT_VER  = "v0.5"
local MAIN_ICON   = "coins"
local GOLD        = Color3.fromHex("#F5C542")
local EMERALD     = Color3.fromHex("#2ECC71")

local function LoadWindUI()
    local sources = {
        "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
        "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
    }
    for _, url in ipairs(sources) do
        local ok, lib = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)
        if ok and type(lib) == "table" then
            return lib
        end
    end
    return nil
end

local WindUI = LoadWindUI()
if not WindUI then
    pcall(uM.Unload)
    error("[" .. SCRIPT_NAME .. "] Could not load WindUI - check your connection / executor HttpGet.", 0)
end

Notify = function(text, duration, icon)
    pcall(function()
        WindUI:Notify({
            Title    = SCRIPT_NAME,
            Content  = tostring(text),
            Icon     = icon or "bell",
            Duration = duration or 3,
        })
    end)
end

WindUI:AddTheme({
    Name        = "RichGreen",
    Accent      = Color3.fromHex("#12301F"),
    Dialog      = Color3.fromHex("#0D2216"),
    Outline     = GOLD,
    Text        = Color3.fromHex("#EAFFF1"),
    Placeholder = Color3.fromHex("#6F9A80"),
    Background  = Color3.fromHex("#08150D"),
    Button      = Color3.fromHex("#1E5A37"),
    Icon        = GOLD,
    Toggle      = EMERALD,
    Slider      = EMERALD,
    Checkbox    = EMERALD,
    Primary     = GOLD,
    PanelBackground             = Color3.fromHex("#FFFFFF"),
    PanelBackgroundTransparency = 0.95,
})

local function BuildInterface()
    local Window = WindUI:CreateWindow({
        Title         = SCRIPT_NAME,
        Author        = "by " .. HUB_NAME,
        Folder        = "VexoraHub_StealFromTheRich",
        Icon          = MAIN_ICON,
        Theme         = "RichGreen",
        Size          = UDim2.fromOffset(620, 470),
        ToggleKey     = Enum.KeyCode.RightShift,
        Resizable     = true,
        NewElements   = true,
        HideSearchBar = true,
        SideBarWidth  = 190,
        User          = { Enabled = true, Anonymous = false },
        OpenButton    = {
            Title           = SCRIPT_NAME,
            CornerRadius    = UDim.new(1, 0),
            StrokeThickness = 3,
            Enabled         = true,
            Draggable       = true,
            OnlyMobile      = false,
            Color           = ColorSequence.new(GOLD, EMERALD),
        },
    })
    assert(Window, "WindUI window could not be created")

    uM.Track(function()
        pcall(function() Window:Destroy() end)
    end)
    pcall(function()
        Window:OnDestroy(function()
            pcall(uM.Unload)
        end)
    end)

    pcall(function()
        Window:EditOpenButton({
            Title           = SCRIPT_NAME,
            Icon            = MAIN_ICON,
            CornerRadius    = UDim.new(1, 0),
            StrokeThickness = 3,
            Enabled         = true,
            Draggable       = true,
            OnlyMobile      = false,
            Color           = ColorSequence.new(GOLD, EMERALD),
        })
    end)

    pcall(function()
        Window:Tag({ Title = SCRIPT_VER, Color = Color3.fromHex("#1E5A37"), Border = true })
    end)

    local TabInfo = Window:Tab({ Title = "Info", Icon = "info", Desc = "Account, server and script info" })
    local Automation = Window:Section({ Title = "Automation", Icon = "bot", Opened = true })
    local TabFarm = Automation:Tab({ Title = "Auto Farm", Icon = "coins", Desc = "Steal and sell" })
    local TabBase = Automation:Tab({ Title = "Base", Icon = "house", Desc = "Plot, treadmill and collection" })
    local TabTeleport = Automation:Tab({ Title = "Teleport", Icon = "map-pin", Desc = "Base and zone teleports" })
    local TabPlayer = Window:Tab({ Title = "Player", Icon = "person-standing", Desc = "Movement and fly" })
    local TabSettings = Window:Tab({ Title = "Settings", Icon = "settings", Desc = "Utilities, interface and config" })

    local function Box(tab, title, icon)
        return tab:Section({ Title = title, Icon = icon, Box = true, BoxBorder = true, Opened = true })
    end

    local function Switch(parent, flag, title, desc, default, apply)
        return parent:Toggle({
            Flag     = flag,
            Title    = title,
            Desc     = desc,
            Value    = default,
            Default  = default,
            Callback = function(state)
                apply(state and true or false)
            end,
        })
    end

    local function Slide(parent, flag, title, desc, min, max, default, apply)
        return parent:Slider({
            Flag     = flag,
            Title    = title,
            Desc     = desc,
            Step     = 1,
            Value    = { Min = min, Max = max, Default = default },
            Callback = function(v)
                apply(tonumber(v) or default)
            end,
        })
    end

    local function MultiPick(parent, flag, title, desc, values, apply)
        return parent:Dropdown({
            Flag      = flag,
            Title     = title,
            Desc      = desc,
            Values    = values,
            Value     = table.clone(values),
            Multi     = true,
            AllowNone = true,
            Callback  = function(selected)
                apply(selected)
            end,
        })
    end

    local executorName = "Unknown"
    pcall(function()
        if type(identifyexecutor) == "function" then
            local name, version = identifyexecutor()
            if type(name) == "string" and name ~= "" then
                executorName = (type(version) == "string" and version ~= "") and (name .. " " .. version) or name
            end
        end
    end)

    local startedAt = os.clock()
    local function SessionText()
        local s = math.floor(os.clock() - startedAt)
        if s < 60 then
            return s .. "s"
        elseif s < 3600 then
            return string.format("%dm %ds", s // 60, s % 60)
        end
        return string.format("%dh %dm", s // 3600, s % 3600 // 60)
    end

    local jobId = tostring(game.JobId)
    local jobShort = (#jobId > 18) and (string.sub(jobId, 1, 18) .. "...") or jobId
    local function PlayerCount()
        return #tB.Players:GetPlayers() .. "/" .. tostring(tB.Players.MaxPlayers)
    end

    TabInfo:Section({ Title = "About" })
    TabInfo:Paragraph({
        Title = SCRIPT_NAME,
        Desc  = "Version " .. SCRIPT_VER .. "\nPress RightShift to show or hide the menu.",
    })

    TabInfo:Section({ Title = "User" })
    TabInfo:Paragraph({
        Title     = u2.DisplayName .. " (@" .. u2.Name .. ")",
        Desc      = "UserId: " .. tostring(u2.UserId),
        Image     = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(u2.UserId) .. "&w=150&h=150",
        ImageSize = 42,
    })
    TabInfo:Paragraph({ Title = "Executor", Desc = executorName .. "  -  " .. tostring(uz) })
    TabInfo:Button({
        Title = "Copy Username",
        Callback = function() fn999(u2.Name, "Copied username") end,
    })
    TabInfo:Button({
        Title = "Copy Profile Link",
        Callback = function()
            fn999("https://www.roblox.com/users/" .. tostring(u2.UserId) .. "/profile", "Copied profile link")
        end,
    })

    TabInfo:Section({ Title = "Session" })
    local sessionParagraph = TabInfo:Paragraph({ Title = "Live", Desc = "Loading..." })
    TabInfo:Paragraph({ Title = "Game", Desc = SCRIPT_NAME .. "\nJob: " .. jobShort })
    TabInfo:Button({
        Title = "Rejoin Place",
        Callback = function()
            pcall(function() tB.TeleportService:Teleport(game.PlaceId, u2) end)
        end,
    })
    TabInfo:Button({
        Title = "Copy Job ID",
        Callback = function() fn999(jobId, "Copied Job ID") end,
    })

    local worker = task.spawn(function()
        while up() do
            task.wait(1)
            if not up() then
                break
            end
            local okPing, ping = pcall(function()
                return math.floor(tB.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            local pingText = okPing and (ping .. " ms") or "n/a"
            pcall(function()
                sessionParagraph:SetDesc(string.format("Uptime: %s\nPlayers: %s\nPing: %s",
                    SessionText(), PlayerCount(), pingText))
            end)
        end
    end)
    uM.Track(function()
        pcall(task.cancel, worker)
    end)

    local StealBox = Box(TabFarm, "Steal", "crosshair")
    Switch(StealBox, "AutoSteal", "Auto Steal", "Instant steal: teleport + fire same frame, chains crates with zero idle time", false, uM.SetSteal)
    Slide(StealBox, "StealBurst", "Fire Burst", "Prompt fires per frame while grabbing (default 3)", 1, 5, 3, uM.SetStealBurst)
    MultiPick(StealBox, "StealZoneFilter", "Zone Filter", "Zones to steal from", uU, uM.SetZoneFilter)
    MultiPick(StealBox, "StealRarityFilter", "Rarity Filter", "Rarities to steal", uc, uM.SetRarityFilter)

    local SellBox = Box(TabFarm, "Sell", "banknote")
    Switch(SellBox, "AutoSell", "Auto Sell", "Sell items automatically", false, uM.SetSell)
    Switch(SellBox, "TeleportToSellerWhileSelling", "Teleport to Seller while Selling",
        "Go to the seller NPC for each sale", false, uM.SetTeleportToSellerWhileSelling)
    SellBox:Dropdown({
        Flag     = "SellMode",
        Title    = "Sell Mode",
        Desc     = "Held = current item, All = whole inventory",
        Values   = tT,
        Value    = "All",
        Callback = function(mode)
            uM.SetSellMode(type(mode) == "table" and (mode.Title or mode[1]) or mode)
        end,
    })

    local PlotBox = Box(TabBase, "Plot", "house")
    Switch(PlotBox, "AutoPlace", "Auto Place", "Place items on your plot", false, uM.SetPlace)
    Switch(PlotBox, "AutoOpen", "Auto Open", "Open crates automatically", false, uM.SetOpen)
    Switch(PlotBox, "AutoEquipBest", "Auto Equip Best", "Keep your best items equipped", false, uM.SetEquipBest)
    Switch(PlotBox, "AutoBuyEquipSlot", "Auto Buy +1 Equip", "Buy extra equip slots", false, uM.SetBuyEquipSlot)
    Switch(PlotBox, "AutoUpgradePlot", "Auto Upgrade Plot", "Upgrade your plot", false, uM.SetUpgradePlot)

    local TreadmillBox = Box(TabBase, "Treadmill", "gauge")
    Switch(TreadmillBox, "AutoTreadmill", "Auto Go On Treadmill", "Hop on your treadmill", false, uM.SetTreadmill)
    Switch(TreadmillBox, "AutoUpgradeTreadmill", "Auto Upgrade Treadmill", "Upgrade the treadmill", false, uM.SetUpgradeTreadmill)

    local CollectBox = Box(TabBase, "Collection", "sparkles")
    Switch(CollectBox, "AutoClaimIndex", "Auto Claim Index", "Claim index rewards", false, uM.SetClaimIndex)
    Switch(CollectBox, "AutoBuyTrails", "Auto Buy Trails", "Buy new trails", false, uM.SetBuyTrails)

    local BaseTpBox = Box(TabTeleport, "Base", "house")
    BaseTpBox:Button({
        Title = "Teleport to Base", Icon = "map-pin", Justify = "Center",
        Callback = function()
            if not uM.TeleportToBase() then
                Notify("Base not found", 3, "triangle-alert")
            end
        end,
    })

    local selectedZone = uU[1]
    local ZoneBox = Box(TabTeleport, "Zones", "map")
    ZoneBox:Dropdown({
        Flag     = "TeleportZone",
        Title    = "Zone",
        Desc     = "Pick a destination",
        Values   = uU,
        Value    = selectedZone,
        Callback = function(zone)
            selectedZone = type(zone) == "table" and (zone.Title or zone[1]) or zone
        end,
    })
    ZoneBox:Button({
        Title = "Teleport to Zone", Icon = "navigation", Justify = "Center",
        Callback = function()
            if not uM.TeleportToZone(selectedZone) then
                Notify("Zone not found", 3, "triangle-alert")
            end
        end,
    })

    local MoveBox = Box(TabPlayer, "Movement", "person-standing")
    Switch(MoveBox, "WalkSpeedEnabled", "WalkSpeed", "Override your walk speed", false, uM.SetWalkSpeedEnabled)
    Slide(MoveBox, "WalkSpeed", "WalkSpeed Amount", nil, 16, 250, 32, uM.SetWalkSpeedValue)
    Switch(MoveBox, "InfJump", "Infinite Jump", "Jump again in mid-air", false, uM.SetInfJump)
    Switch(MoveBox, "NoClip", "Noclip", "Walk through walls", false, uM.SetNoClip)
    Switch(MoveBox, "InstantProximityPrompt", "Instant ProximityPrompt", "No hold time, longer reach", false, uM.SetInstantProximityPrompt)

    local FlyBox = Box(TabPlayer, "Fly", "plane")
    Switch(FlyBox, "Fly", "Fly", "WASD + Space / Left Ctrl", false, uM.SetFly)
    Slide(FlyBox, "FlySpeed", "Fly Speed", nil, 10, 400, 60, uM.SetFlySpeed)

    local hideOnStart = false

    local UtilBox = Box(TabSettings, "Utilities", "wrench")
    Switch(UtilBox, "AntiAfk", "Anti-AFK", "Prevents the idle kick", true, uM.SetAntiAfk)
    Switch(UtilBox, "NoGameplayPaused", "No Gameplay Paused", nil, true, uM.SetNoGameplayPaused)
    Switch(UtilBox, "AutoReconnect", "Auto Reconnect on Kick", "Rejoin when a teleport fails", false, uM.SetAutoReconnect)
    Switch(UtilBox, "Disable3DRendering", "Disable 3D Rendering", "Saves GPU while AFK farming", false, uM.SetDisable3D)
    Switch(UtilBox, "FPSBoost", "FPS Boost", "Turns off particles, trails and shadows", false, uM.SetFpsBoost)

    local UiBox = Box(TabSettings, "Interface", "layout-dashboard")
    UiBox:Keybind({
        Flag     = "MenuKeybind",
        Title    = "Menu Keybind",
        Desc     = "Show / hide the window",
        Value    = "RightShift",
        Callback = function(key)
            pcall(function()
                Window:SetToggleKey(Enum.KeyCode[key])
            end)
        end,
    })
    local themeNames = {}
    for name in pairs(WindUI:GetThemes()) do
        table.insert(themeNames, name)
    end
    table.sort(themeNames)
    UiBox:Dropdown({
        Title    = "Theme",
        Desc     = "Change the look of the menu",
        Values   = themeNames,
        Value    = "RichGreen",
        Callback = function(name)
            pcall(function()
                WindUI:SetTheme(type(name) == "table" and (name.Title or name[1]) or name)
            end)
        end,
    })
    Switch(UiBox, "HideUIOnStart", "Hide UI On Start", "Start minimized to the pill button", false, function(v)
        hideOnStart = v
    end)

    local ConfigManager = Window.ConfigManager
    if ConfigManager then
        local ConfigBox = Box(TabSettings, "Config", "save")
        local configName = "default"
        local nameInput = ConfigBox:Input({
            Title    = "Config Name",
            Icon     = "file-cog",
            Value    = configName,
            Callback = function(text)
                if type(text) == "string" and text ~= "" then
                    configName = text
                end
            end,
        })
        local configList
        configList = ConfigBox:Dropdown({
            Title    = "All Configs",
            Desc     = "Select an existing config",
            Values   = ConfigManager:AllConfigs(),
            Callback = function(name)
                name = type(name) == "table" and (name.Title or name[1]) or name
                if type(name) == "string" and name ~= "" then
                    configName = name
                    pcall(function() nameInput:Set(name) end)
                end
            end,
        })
        local function RefreshConfigs()
            pcall(function() configList:Refresh(ConfigManager:AllConfigs()) end)
        end
        ConfigBox:Button({
            Title = "Save Config", Icon = "save", Justify = "Center",
            Callback = function()
                local ok, saved = pcall(function()
                    return ConfigManager:Config(configName):Save()
                end)
                if ok and saved then
                    Notify("Config '" .. configName .. "' saved", 3, "check")
                else
                    Notify("Could not save config", 3, "x")
                end
                RefreshConfigs()
            end,
        })
        ConfigBox:Button({
            Title = "Load Config", Icon = "folder-open", Justify = "Center",
            Callback = function()
                local ok, loaded = pcall(function()
                    return ConfigManager:Config(configName):Load()
                end)
                if ok and loaded then
                    Notify("Config '" .. configName .. "' loaded", 3, "refresh-cw")
                else
                    Notify("Config not found", 3, "x")
                end
            end,
        })
        ConfigBox:Button({
            Title = "Delete Config", Icon = "trash-2", Justify = "Center",
            Callback = function()
                local ok = pcall(function()
                    ConfigManager:DeleteConfig(configName)
                end)
                Notify(ok and ("Config '" .. configName .. "' deleted") or "Could not delete config", 3, ok and "check" or "x")
                RefreshConfigs()
            end,
        })
    end

    local ScriptBox = Box(TabSettings, "Script", "scroll-text")
    ScriptBox:Button({
        Title = "Unload Script", Desc = "Turn everything off and remove the menu",
        Icon = "power", Justify = "Center", Color = Color3.fromHex("#C0392B"),
        Callback = function()
            pcall(uM.Unload)
        end,
    })

    uM.SetAntiAfk(true)
    uM.SetNoGameplayPaused(true)
    uM.SetZoneFilter(table.clone(uU))
    uM.SetRarityFilter(table.clone(uc))
    uM.SetSellMode("All")
    uM.SetStealBurst(3)
    uM.SetTeleportToSellerWhileSelling(false)

    if ConfigManager then
        pcall(function()
            ConfigManager:CreateConfig("default", true)
        end)
    end

    task.delay(1, function()
        if up() and hideOnStart then
            pcall(function() Window:Close() end)
        end
    end)

    local selected = pcall(function() TabFarm:Select() end)
    if not selected then
        pcall(function() Window:SelectTab(2) end)
    end

    Notify(SCRIPT_NAME .. " " .. SCRIPT_VER .. " loaded  ·  by " .. HUB_NAME, 4, "circle-check")
end

FO_21()
FO_16()

local uiOk, uiErr = xpcall(BuildInterface, debug.traceback)
if not uiOk then
    warn("[" .. SCRIPT_NAME .. "] UI failed to build:\n" .. tostring(uiErr))
    pcall(uM.Unload)
end
