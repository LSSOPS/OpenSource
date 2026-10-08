local wz
local wg
local vY
local wm
local vm
local vL
local vs
local v9
local State
local wy
local vy
local wf
local vE
local v2
local vK
local wr
local vr
local v8
local vQ
local wx
local LocalPlayer
local we
local vW
local wD
local vD
local v1
local vJ
local vq
local vP
local ww
local vw
local vV
local wC
local vC
local wj
local v0
local wp
local vp
local v6
local vv
local wc
local CoreGui
local wB
local wi
local vH
local wo
local vo
local v5
local vu
local wb
local vT
local vG
local vn
local vM
local wt
local vt
local wa
local function fn17(gk)
    if gk then
        vG(vm, wb)
    else
        vE(vm)
    end
end
local function fn49()
    local AR_1
    local AQ_1
    local AP = LocalPlayer:GetAttribute("EquippedTreadmill")
    if type(AP) ~= "string" then
        AQ_1, AR_1 = vV("GetEquippedTreadmill")
        local AS = AQ_1 and type(AR_1) == "string"
        AP = AS and AR_1 or nil
    end
    local AQ_3 = wr()
    local AR_3 = AP == nil
    for i, v in ipairs(AQ_3) do
        if AR_3 then
            return v
        end
        if v.Name == AP then
            AR_3 = true
        end
    end
    return nil
end
local function fn65(i7)
    local DK = i7 == "Equipped" and "Equipped" or "Inventory"
    v0.mode = DK
end
local function fn68(i0)
    if i0 then
        vG(v0, vq)
    else
        vE(v0)
    end
end
local function fn92()
    local Dl_2
    local Dg = ww()
    if not Dg then
        return
    end
    local Dh = wp()
    local targets = v8.targets
    local Dj = next(targets) ~= nil
    for i, v in ipairs(vu()) do
        local Dk = not vy() or v8.stopped
        local Dk_2
        if Dk then
            break
        end
        local Dk_1 = Dg[v.Name] ~= true and v.Price > 0
        if Dk_1 then
            Dk_1 = not Dj or targets[v.Name]
        end
        if Dk_1 then
            if Dh >= v.Price then
                Dk_2, Dl_2 = vV("SuitShopAction", "Buy", v.Name)
                if Dk_2 and Dl_2 then
                    vK("Bought " .. v.Name)
                    wy("Bought " .. v.Name)
                    Dh = wp()
                    task.wait(0.4)
                end
            end
        end
    end
end
local function fn101(aF, aG)
    local Events = vp:FindFirstChild("Events")
    local xq = Events and Events:FindFirstChild(aF)
    local xp_1 = xq
    if xq then
        xq = xp_1:IsA(aG)
    end
    if xq then
        return xp_1
    end
    return nil
end
local function fn106()
    local Ba = {}
    for i, v in ipairs(vu()) do
        table.insert(Ba, v.Name)
    end
    return Ba
end
local function fn117()
    local C0_1
    local CX_1, CX_2
    local CY_1, CY_4
    CX_1, CY_1 = vV("GetIndexData")
    local CZ = not CX_1
    local CZ_1
    local C5 = if CZ then 1 else 0
    local C3 = 367 * C5 + 1700 * (1 - C5)
    local C4 = 3916 * C5 + 430 * (1 - C5)
    if not ((C3 * 2970 + C4 * 827 + C3 * C4) % 16777213 == 5765694) then
        CZ = type(CY_1) ~= "table"
    end
    if CZ then
        return
    end
    CX_2, CZ_1 = vV("IndexRewardAction", "GetClaims")
    local C_ = not CX_2 or type(CZ_1) ~= "table"
    if C_ then
        CZ_1 = {}
    end
    local CX_3 = v6("AnimalConfigurations")
    local C__1 = CX_3 and type(CX_3.Animals) == "table" and CX_3.Animals
    local CX_4 = C__1 or nil
    if not CX_4 then
        return
    end
    local CX_5 = 0
    for k, v in pairs(CY_1) do
        local CY_2 = not vy() or wj.stopped
        if CY_2 then
            break
        end
        if v == true and CZ_1[k] ~= true and CX_4[k] then
            CY_4, C0_1 = vV("IndexRewardAction", "Claim", k)
            local C1 = CY_4 and type(C0_1) == "table" and C0_1.Success
            if C1 then
                CX_5 += 1
                task.wait(0.2)
            end
        end
    end
    if CX_5 > 0 then
        local CZ_2 = CX_5 == 1 and "" or "s"
        vK("Claimed " .. CX_5 .. " index reward" .. CZ_2)
        local CZ_3 = CX_5 == 1 and "" or "s"
        wy("Claimed " .. CX_5 .. " index reward" .. CZ_3)
    end
end
local function fn127(hu)
    if hu then
        vG(wt, vo)
    else
        vE(wt)
    end
end
local function fn128()
    return not we.Unloaded
end
local function fn133()
    return wB:FindFirstChild("Plot_" .. LocalPlayer.Name)
end
local function fn175(eE)
    local Shell = eE:FindFirstChild("Shell")
    local Az = Shell and Shell:FindFirstChildWhichIsA("ProximityPrompt")
    local Ay_1 = Az or nil
    local Az_1 = Ay_1
    if Ay_1 then
        Ay_1 = Az_1.Enabled
    end
    if Ay_1 then
        Ay_1 = Az_1.ActionText == "Hatch"
    end
    if Ay_1 then
        return true
    end
    local Ay_2 = vP(eE)
    if not Ay_2 then
        return false
    end
    local Az_2 = tonumber(eE:GetAttribute("HatchStartTime")) or 0
    return wB:GetServerTimeNow() - Az_2 >= Ay_2
end
local function fn181()
    vE(vm)
    if vm.EndFloat then
        pcall(vm.EndFloat)
    end
    vE(wz)
    vE(wt)
    vE(wm)
    vE(wj)
    vE(v8)
    vE(v0)
    vE(vW)
    vE(vQ)
end
local function fn189()
    local A_ = v6("SuitConfigurations")
    local A0 = not A_
    local A1 = {}
    if not A0 then
        A0 = type(A_.Suits) ~= "table"
    end
    if A0 then
        return A1
    end
    for i, v in ipairs(A_.Suits) do
        local A__1 = type(v) == "table" and type(v.Name) == "string"
        if A__1 then
            local A__2 = table.insert
            local Name = v.Name
            local A2 = tonumber(v.Price) or 0
            A__2(A1, { Name = Name, Price = A2 })
        end
    end
    table.sort(A1, function(fd, fe)
        return fd.Price < fe.Price
    end)
    return A1
end
local function fn204(hf)
    local Ct = tonumber(hf) or 2
    wz.interval = math.max(Ct, 0.5)
end
local function fn235(i5)
    local DH = tonumber(i5) or 30
    v0.interval = math.max(DH, 1)
end
local function fn246()
    local Aa = v6("PlotConfigurations")
    local Ab = Aa and Aa.MaxEggsOnPlot
    local Aa_1 = tonumber(Ab) or 30
    return Aa_1
end
local function fn252(cX, cY)
    local Eggs = wB:FindFirstChild("Eggs")
    local zl = {}
    if not Eggs then
        return zl
    end
    local zm = cX and next(cX) ~= nil
    local zn = cY
    if zn then
        zn = next(cY) ~= nil
    end
    local zm_1 = zn
    for i, child in ipairs(Eggs:GetChildren()) do
        local zk_1 = (child:IsA("Folder"))
        if zk_1 then
            zk_1 = not zm or cX[child.Name]
        end
        if zk_1 then
            for i, child in ipairs(child:GetChildren()) do
                local SpawnedEgg = child:FindFirstChild("SpawnedEgg")
                local zn_2 = SpawnedEgg and wD(SpawnedEgg)
                local zp = zn_2 or nil
                local zn_3 = zp
                if zp then
                    zp = zn_3.Enabled
                end
                if zp then
                    local attr = SpawnedEgg:GetAttribute("EggName")
                    local zq = wx(attr)
                    local zr = not zm_1
                    if not zr then
                        zr = zq and cY[zq]
                    end
                    if zr then
                        local zr_1 = wg(SpawnedEgg)
                        if zr_1 then
                            local insert = table.insert
                            local zt = attr or "Egg"
                            insert(zl, { Model = SpawnedEgg, Prompt = zn_3, Position = zr_1, Name = tostring(zt), Rarity = zq })
                        end
                    end
                end
            end
        end
    end
    return zl
end
local function fn265(h6)
    if h6 then
        vG(wj, wc)
    else
        vE(wj)
    end
end
local function fn359(dq)
    local zK_1
    local zJ_1
    local zH = v9()
    local zH_1 = zH and zH.Position or Vector3.zero
    zK_1, zJ_1 = nil, nil
    for i, v in ipairs(dq) do
        local Magnitude = (v.Position - zH_1).Magnitude
        if not zJ_1 or Magnitude < zJ_1 then
            zK_1, zJ_1 = v, Magnitude
        end
    end
    return zK_1, zJ_1 or 0
end
local function worker()
    while vy() do
        pcall(v5, true)
        task.wait(15)
    end
end
local function fn383()
    local Bj_1
    local Bi_1
    Bi_1, Bj_1 = vV("SuitShopAction", "GetData")
    local Bk = Bi_1 and type(Bj_1) == "table" and type(Bj_1.Owned) == "table"
    if Bk then
        return Bj_1.Owned
    end
    return nil
end
local function fn387(ba)
    local xI = ba or vL()
    ba = xI
    if xI then
        xI = ba:FindFirstChild("EggHatch")
    end
    local xJ = xI
    if xI then
        xI = xJ:IsA("BasePart")
    end
    if xI then
        return xJ
    end
    return nil
end
local function fn465(gr, gs)
    local BZ = {}
    for k in pairs(vw(gr)) do
        local B__1 = gs and gs[k] or k
        BZ[B__1] = true
    end
    vm.zones = BZ
end
local function fn473(hJ)
    local CV = tonumber(hJ) or 12
    wm.interval = math.max(CV, 10)
end
local function fn500(g7)
    if g7 then
        vG(wz, v1)
    else
        vE(wz)
    end
end
local function fn528(cN)
    if not cN then
        return nil
    end
    local PromptAnchor = cN:FindFirstChild("PromptAnchor", true)
    local zb = PromptAnchor and PromptAnchor:FindFirstChildWhichIsA("ProximityPrompt")
    return zb or nil
end
local function fn557()
    local Cv = v2()
    local Cw = 0
    for i, v in ipairs(Cv) do
        local Cv_1 = not vy() or wt.stopped
        if Cv_1 then
            break
        end
        local Cv_2 = v.Parent and wa(v)
        if Cv_2 then
            if vn("RequestHatch", v) then
                Cw += 1
                task.wait(0.35)
            end
        end
    end
    if Cw > 0 then
        local Cx = Cw == 1 and "" or "s"
        wy("Hatched " .. Cw .. " egg" .. Cx)
    end
end
local function fn559(jK)
    if jK then
        vG(vQ, vr)
    else
        vE(vQ)
    end
end
local function fn569(fT)
    fT.stopped = true
    local By = fT.generation or 0
    fT.generation = By + 1
end
local function fn603()
    return CoreGui
end
local function fn609()
    if coroutine.status(vD) ~= "dead" then
        pcall(task.cancel, vD)
    end
end
local function fn627()
    local Character = LocalPlayer.Character
    local yU = Character ~= nil and Character:GetAttribute("CarryingEgg") == true
    return yU
end
local function fn634(bI)
    local yb = v6("EggConfigurations")
    local yc = type(bI) ~= "string" or not yb
    local yg = if yc then 1 else 0
    local ye = 2139 * yg + 2878 * (1 - yg)
    local yf = 1196 * yg + 2018 * (1 - yg)
    if not ((ye * 3841 + yf * 3519 + ye * yf) % 16777213 == 14982867) then
        yc = type(yb.EggDrops) ~= "table"
    end
    if yc then
        return false
    end
    return yb.EggDrops[bI] ~= nil
end
local function fn635()
    local Character = LocalPlayer.Character
    local yM = Character and Character:FindFirstChild("HumanoidRootPart")
    return yM or nil
end
local function fn637()
    local DS_1
    local DR_1
    local DQ = vs()
    if not DQ then
        wy("Treadmill is fully upgraded")
        return
    end
    if wp() < DQ.Price then
        return
    end
    DR_1, DS_1 = vV("RequestTreadmillUpgrade")
    local DT = DR_1 and type(DS_1) == "table" and DS_1.Success
    if DT then
        vK("Upgraded to " .. DQ.Name)
        wy("Upgraded to " .. DQ.Name)
    end
end
local function fn652()
    gethui = wC
end
local function fn669()
    local AC = v6("TreadmillConfigurations")
    local AD = not AC
    local AE = {}
    if not AD then
        AD = type(AC.Treadmills) ~= "table"
    end
    if AD then
        return AE
    end
    for k, v in pairs(AC.Treadmills) do
        local AC_1 = type(v) == "table" and tonumber(v.Price)
        if AC_1 then
            table.insert(AE, { Name = k, Price = tonumber(v.Price) })
        end
    end
    table.sort(AE, function(eS, eT)
        return eS.Price < eT.Price
    end)
    return AE
end
local function fn682(ei)
    local At_1
    local Ao = tonumber(ei:GetAttribute("HatchTimeOverride"))
    local Ao_6
    if Ao then
        return Ao
    end
    local Ao_1 = v6("EggConfigurations")
    local Ap = v6("EggSizeSystem")
    local Aq = v6("GlobalEvents")
    local Ar = not Ao_1
    local Ar_5, Ar_6
    local Ax = if Ar then 1 else 0
    local Av = 449 * Ax + 3804 * (1 - Ax)
    local Aw = 2814 * Ax + 1686 * (1 - Ax)
    if not ((Av * 3637 + Aw * 1204 + Av * Aw) % 16777213 == 6284555) then
        Ar = not Ap
    end
    local Ax_1 = if Ar then 1 else 0
    local Av_1 = 846 * Ax_1 + 4025 * (1 - Ax_1)
    local Aw_1 = 1051 * Ax_1 + 2652 * (1 - Ax_1)
    if not ((Av_1 * 1836 + Aw_1 * 1121 + Av_1 * Aw_1) % 16777213 == 3620573) then
        Ar = not vM(Ap.GetHatchTime)
    end
    if Ar then
        return nil
    end
    local Ar_1 = type(Ao_1.EggSettings) == "table" and Ao_1.EggSettings[ei:GetAttribute("OriginalName")]
    local Ao_2 = Ar_1 or nil
    local Ar_2 = Ao_2
    if Ao_2 then
        Ao_2 = Ar_2.HatchTime
    end
    local Ar_3 = tonumber(Ao_2) or 5
    local Ar_4 = ei:GetAttribute("EggSize") or "Normal"
    Ar_5, At_1 = pcall(Ap.GetHatchTime, Ar_3, Ar_4)
    local Ao_4 = not Ar_5 or not tonumber(At_1)
    if Ao_4 then
        return nil
    end
    local Ao_5 = Aq
    local Ap_1 = 1
    if Ao_5 then
        Ao_5 = vM(Aq.GetHatchMultiplier)
    end
    if Ao_5 then
        Ao_6, Ar_6 = pcall(Aq.GetHatchMultiplier)
        local Aq_1 = Ao_6 and tonumber(Ar_6) and tonumber(Ar_6) > 0
        if Aq_1 then
            Ap_1 = tonumber(Ar_6)
        end
    end
    return tonumber(At_1) / Ap_1
end
local function fn687()
    local DW = v6("PlotConfigurations")
    local DW_2
    local DX = v5(true)
    if DX <= 0 then
        return
    end
    local DY = DW and DW.MaxSlots
    local DY_3
    local DZ = tonumber(DY) or 0
    if DZ > 0 and DX >= DZ then
        wy("Pet slots are maxed out")
        return
    end
    local DY_2 = nil
    local DZ_2 = DW and type(DW.Upgrades) == "table"
    if DZ_2 then
        DY_2 = tonumber(DW.Upgrades[DX + 1])
    end
    local DW_1 = DY_2 and wp() < DY_2
    if DW_1 then
        return
    end
    DW_2, DY_3 = vV("RequestPlotUpgrade")
    local DZ_3 = DW_2 and type(DY_3) == "table" and DY_3.Success
    if DZ_3 then
        v5(true)
        vK("Unlocked pet slot " .. tostring(DX + 1))
        wy("Unlocked pet slot " .. tostring(DX + 1))
    end
end
local function fn691(at)
    local xn_1
    local xl = wi[at]
    if xl ~= nil then
        if xl == false then
            return nil
        end
        return xl
    end
    local Modules = vp:FindFirstChild("Modules")
    local xm = Modules and Modules:FindFirstChild(at)
    local xm_2
    local xm_1 = not xm or not xm:IsA("ModuleScript")
    if xm_1 then
        wi[at] = false
        return nil
    end
    xm_2, xn_1 = pcall(require, xm)
    local xl_3 = not xm_2 or type(xn_1) ~= "table"
    if xl_3 then
        wi[at] = false
        return nil
    end
    wi[at] = xn_1
    return xn_1
end
local function fn702(gp)
    local BU = (tonumber(gp))
    local BY = if BU then 1 else 0
    local BW = 2316 * BY + 644 * (1 - BY)
    local BX = 3283 * BY + 706 * (1 - BY)
    if not ((BW * 1944 + BX * 344 + BW * BX) % 16777213 == 13235084) then
        BU = 0.6
    end
    vm.interval = math.max(BU, 0.1)
end
local function fn708(fV)
    local BA = {}
    if type(fV) == "table" then
        for k, v in pairs(fV) do
            local BB = v == true and type(k) == "string"
            if BB then
                BA[k] = true
            elseif type(v) == "string" then
                BA[v] = true
            end
        end
    end
    return BA
end
local function fn743(hc)
    wz.rarities = vw(hc)
end
local function fn749(cc)
    local yJ = not cc or not cc:IsA("ProximityPrompt") or not cc.Enabled
    if yJ then
        return false
    elseif not vM(fireproximityprompt) then
        return false
    else
        return (pcall(fireproximityprompt, cc))
    end
end
local function fn789()
    if not wf() then
        return false
    end
    wy("Delivering the egg")
    local y3 = if not vH(vY, 0) then 1 else 0
    if y3 == 1 then
        return false
    end
    local yZ = os.clock() + 4
    while true do
        local y_ = vy() and wf() and os.clock() < yZ
        if y_ then
            vH(vY, 0)
            task.wait(0.2)
            continue
        end
        break
    end
    return not wf()
end
local function fn792(X)
    return type(X) == "function"
end
local function fn825(U)
    local xe = typeof(cloneref) == "function" and typeof(U) == "Instance"
    if xe then
        return cloneref(U)
    end
    return U
end
local function fn832(hE)
    if hE then
        vG(wm, vT)
    else
        vE(wm)
    end
end
local function fn853(dR)
    local z0 = tonumber(State.CapacityStamp)
    local z0_1
    local z1 = not dR
    local z1_1
    if z1 ~= false then
        local z2_1 = State.PlotCapacity
        local z6 = if z2_1 then 1 else 0
        local z4 = 2430 * z6 + 156 * (1 - z6)
        local z5 = 3069 * z6 + 2526 * (1 - z6)
        if not ((z4 * 2441 + z5 * 2942 + z4 * z5) % 16777213 == 5641085) then
            z2_1 = 0
        end
        z1 = z2_1 > 0
    end
    if z1 then
        z1 = z0
    end
    if z1 then
        z1 = os.clock() - z0 < 20
    end
    if z1 then
        return State.PlotCapacity
    end
    z0_1, z1_1 = vV("GetPlotCapacity")
    local z2_2 = z0_1 and tonumber(z1_1)
    if z2_2 then
        State.PlotCapacity = tonumber(z1_1)
        State.CapacityStamp = os.clock()
    end
    return State.PlotCapacity or 0
end
local function fn854(ix)
    if ix then
        vG(v8, vJ)
    else
        vE(v8)
    end
end
local function fn881(bh)
    local xQ_1
    local xP_1
    local xO = vv(bh)
    xP_1, xQ_1 = {}, {}
    if not xO then
        return xP_1, xQ_1
    end
    for i, child in ipairs(xO:GetChildren()) do
        if child:IsA("Model") then
            if child:GetAttribute("IsEgg") == true then
                table.insert(xP_1, child)
            elseif child:GetAttribute("ItemUUID") then
                table.insert(xQ_1, child)
            end
        end
    end
    return xP_1, xQ_1
end
local function fn898(i9)
    local DO = tonumber(i9) or 1
    v0.minimum = math.max(math.floor(DO), 1)
end
local function fn921(gz)
    vm.rarities = vw(gz)
end
local function fn929(bp)
    local xY = bp == ""
    local xZ = type(bp) ~= "string"
    local x6 = if xZ then 1 else 0
    local x4 = 199 * x6 + 1646 * (1 - x6)
    local x5 = 1890 * x6 + 331 * (1 - x6)
    if not ((x4 * 3336 + x5 * 3485 + x4 * x5) % 16777213 == 7626624) then
        xZ = xY
    end
    if xZ then
        return nil
    end
    local xY_1 = v6("AnimalConfigurations")
    local xZ_1 = xY_1 and type(xY_1.Animals) == "table" and xY_1.Animals
    local xY_2 = xZ_1 or nil
    local xZ_2 = xY_2
    if xY_2 then
        xY_2 = xZ_2[bp]
    end
    local x_ = xY_2
    local xY_3 = type(x_) == "table" and type(x_.Rarity) == "string"
    if xY_3 then
        return x_.Rarity
    end
    local xY_4 = v6("EggConfigurations")
    local x__1 = xY_4 and type(xY_4.EggDrops) == "table" and xY_4.EggDrops[bp]
    local xY_5 = x__1
    local x6_1 = if xY_5 then 1 else 0
    local x4_1 = 874 * x6_1 + 1120 * (1 - x6_1)
    local x5_1 = 2420 * x6_1 + 4013 * (1 - x6_1)
    if not ((x4_1 * 4062 + x5_1 * 184 + x4_1 * x5_1) % 16777213 == 6110548) then
        xY_5 = nil
    end
    local x__2 = xY_5
    local xY_6 = not xZ_2
    local x0 = type(x__2) ~= "table" or xY_6
    if x0 then
        return nil
    end
    local xY_7 = nil
    for k in pairs(x__2) do
        local x__3 = xZ_2[k]
        local x0_1 = type(x__3) == "table" and x__3.Rarity
        local x__4 = x0_1 or nil
        if type(x__4) == "string" then
            if not xY_7 or (wo[x__4] or 0) > (wo[xY_7] or 0) then
                xY_7 = x__4
            end
        end
    end
    return xY_7
end
local function fn1004()
    local SellNPC = wB:FindFirstChild("SellNPC")
    local Bn = SellNPC and SellNPC:FindFirstChild("ProxPart")
    local Bm_1 = Bn
    if Bn then
        Bn = Bm_1:IsA("BasePart")
    end
    if Bn then
        return Bm_1
    end
    return nil
end
local function fn1017(ak, al)
    if not vy() then
        return
    end
    local Notifications = State.Notifications
    local xi = tostring(ak)
    local xj = al or 5
    table.insert(Notifications, { text = xi, time = xj })
    if #State.Notifications > 12 then
        table.remove(State.Notifications, 1)
    end
end
local function fn1020()
    local Ad = vv()
    if not Ad then
        return nil
    end
    local Ae = Ad.Size * 0.5
    local Af = math.max(Ae.X - 6, 1)
    local Ag = math.max(Ae.Z - 6, 1)
    local Ah = Vector3.new((math.random() * 2 - 1) * Af, Ae.Y, (math.random() * 2 - 1) * Ag)
    return Ad.Position + Ah
end
local function fn1021(cE)
    local y5_2
    local y4 = os.clock() + 8
    local y4_2
    while true do
        local y5_1 = State.MoveBusy and vy() and os.clock() < y4
        if y5_1 then
            task.wait(0.1)
            continue
        end
        break
    end
    local y4_1 = State.MoveBusy or not vy()
    if y4_1 then
        return false
    end
    State.MoveBusy = true
    y4_2, y5_2 = pcall(cE)
    State.MoveBusy = false
    if not y4_2 then
        warn("[Astra Hub] movement error: " .. tostring(y5_2))
        return false
    end
    return y5_2
end
local function fn1075(ap)
    State.Status = tostring(ap)
end
local function fn1161(jb)
    v0.teleport = jb == true
end
local function fn1215(bN)
    local yh = v6("ZoneConfigurations")
    local yi = yh and yh[bN]
    local yi_1 = type(yi) == "table" and type(yi.DisplayName) == "string"
    if yi_1 then
        return yi.DisplayName
    end
    return bN
end
local function fn1217(iC)
    v8.targets = vw(iC)
end
local function fn1256(hz)
    local CK = tonumber(hz) or 3
    wt.interval = math.max(CK, 0.5)
end
local function fn1259(jn)
    if jn then
        vG(vW, vC)
    else
        vE(vW)
    end
end
local function fn1283()
    local stats = LocalPlayer:FindFirstChild("stats")
    local xG = stats and stats:FindFirstChild("Money")
    local xF_1 = xG
    if xG then
        xG = tonumber(xF_1.Value)
    end
    return xG or 0
end
local function fn1284()
    local CP = if vn("EquipBestPets") then 1 else 0
    if CP == 1 then
        wy("Equipped your best pets")
    end
end
local function fn1285()
    local yo_1
    local yn_1
    yo_1, yn_1 = {}, {}
    local Eggs = wB:FindFirstChild("Eggs")
    local yq = {}
    if Eggs then
        for i, child in ipairs(Eggs:GetChildren()) do
            local yp_1 = child:IsA("Folder") and child.Name:match("^Zone%d+$")
            if yp_1 then
                table.insert(yq, child.Name)
            end
        end
    end
    if #yq == 0 then
        local yp_2 = v6("ZoneConfigurations")
        if type(yp_2) == "table" then
            for k in pairs(yp_2) do
                local yp_3 = type(k) == "string" and k:match("^Zone%d+$")
                if yp_3 then
                    table.insert(yq, k)
                end
            end
        end
    end
    table.sort(yq, function(b5, b6)
        local yk = tonumber(b5:match("%d+")) or 0
        local yl = tonumber(b6:match("%d+")) or 0
        return yk < yl
    end)
    for i, v in ipairs(yq) do
        local yp_4 = v:gsub("Zone", "Zone ") .. " - " .. vt(v)
        table.insert(yo_1, yp_4)
        yn_1[yp_4] = v
    end
    return yo_1, yn_1
end
vm = nil
vn = nil
vo = nil
vp = nil
vq = nil
vr = nil
vs = nil
vt = nil
vu = nil
vv = nil
vw = nil
LocalPlayer = nil
vy = nil
vC = nil
vD = nil
vE = nil
vG = nil
vH = nil
vJ = nil
vK = nil
vL = nil
vM = nil
vP = nil
vQ = nil
State = nil
vT = nil
CoreGui = nil
vV = nil
vW = nil
vY = nil
v0 = nil
v1 = nil
v2 = nil
v5 = nil
v6 = nil
local Players, vl, vz, Workspace, vB, Lighting, vI, vN, TeleportService, vS, vX, vZ, GuiService, v3, v4
v8 = nil
v9 = nil
wa = nil
wb = nil
wc = nil
we = nil
wf = nil
wg = nil
wi = nil
wj = nil
wm = nil
wo = nil
wp = nil
wr = nil
wt = nil
ww = nil
wx = nil
wy = nil
wz = nil
wB = nil
wC = nil
wD = nil
local HttpService, wd, VirtualUser, wk, UserInputService, wn, wq, RunService, wu, wv, wA
if not game:IsLoaded() then
    game.Loaded:Wait()
end
Players, RunService, UserInputService, VirtualUser, HttpService, GuiService, CoreGui, TeleportService, Lighting, Workspace, LocalPlayer, wC = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
VirtualUser = game:GetService("VirtualUser")
HttpService = game:GetService("HttpService")
GuiService = game:GetService("GuiService")
CoreGui = game:GetService("CoreGui")
TeleportService = game:GetService("TeleportService")
Lighting = game:GetService("Lighting")
Workspace = game:GetService("Workspace")
LocalPlayer = Players.LocalPlayer
local wF = "AstraHubSwingForEggs"
wC = fn603
if getgenv then
    getgenv().gethui = wC
end
we, vp, wB, wu, wo, vB, vM, vy = nil, nil, nil, nil, nil, nil, nil, nil
pcall(fn652)
local function wH(t)
    local w7
    local w5
    local w6
    w5 = nil
    w6 = nil
    w7 = nil
    local w8 = t ~= ""
    local w9 = type(t) == "string" and w8
    assert(w9, "A namespace is required")
    assert(type(getgenv) == "function", "getgenv is unavailable")
    w5 = getgenv()
    assert(type(w5) == "table", "getgenv did not return a table")
    local w8_1 = w5[t]
    if w8_1 ~= nil then
        local w9_1 = type(w8_1) == "table" and type(w8_1.Unload) == "function"
        assert(w9_1, "Namespace is occupied")
        w8_1.Unload()
        assert(w5[t] == nil, "Previous instance did not release its namespace")
    end
    w6 = {}
    w7 = { State = {}, Unloaded = false }
    w7.Track = function(z)
        assert(type(z) == "function", "Cleanup must be callable")
        if w7.Unloaded then
            z()
        else
            table.insert(w6, z)
        end
        return z
    end
    w7.Unload = function()
        local wZ_1
        local wY_1
        if w7.Unloaded then
            return
        end
        w7.Unloaded = true
        local wW = {}
        local w2 = #w6
        local w1 = -1
        while false and w2 <= 1 or true and w2 >= 1 do
            local w3 = w2
            local wX_1 = table.remove(w6, w3)
            wY_1, wZ_1 = pcall(wX_1)
            if not wY_1 then
                table.insert(wW, tostring(wZ_1))
            end
            w2 += w1
        end
        table.clear(w7.State)
        if #wW > 0 then
            error("Cleanup incomplete: " .. table.concat(wW, "; "), 0)
        end
        if w5[t] == w7 then
            w5[t] = nil
        end
    end
    w5[t] = w7
    return w7
end
vB = function(M, N)
    local xc = type(M) == "table" and type(M.Track) == "function"
    assert(xc, "FeatureAPI required")
    local xc_1 = type(N) == "table" and type(N.OnUnload) == "function"
    assert(xc_1, "UI library required")
    assert(type(N.Unload) == "function", "UI unload required")
    M.Track(function()
        if not N.Unloaded then
            N:Unload()
        end
    end)
    N:OnUnload(function()
        M.Unload()
    end)
end
we = wH(wF)
vM = fn792
vy = fn128
vp = fn825(ReplicatedStorage)
wB = fn825(Workspace)
wu = {
    "Common",
    "Uncommon",
    "Rare",
    "Epic",
    "Legendary",
    "Mythical",
    "Secret",
    "Divine",
    "Eternal",
    "Cosmic",
    "Hacker"
}
if (false and (not vy and false) and ((not wo or not vy) and (false or wH)) or (not vy or false or (vB or vy)) and (vy or wH or false and not wo)) and not (false and (not vy and false) and ((not wo or not vy) and (false or wH)) or (not vy or false or (vB or vy)) and (vy or wH or false and not wo)) then
    we = {}
else
    wo = {}
end
for i, v in ipairs(wu) do
    wo[v] = i
end
v3, vY, State, wi, vm, wz, wt, wm, wj, v8, v0, vW, vQ, vK, wy, v6, wd, vn, vV, wp, vL, vv, v2, wx, vS, vt, vX, wA, v9, vH, wf, vN, wk, wD, wg, vz, wq, wn, v5, wv, v4, vl, vP, wa, wr, vs, vu, vI, ww, vZ, vG, vE, vw, wb, v1, vo, vT, wc, vJ, vq, vC, vr = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
v3 = { "Inventory", "Equipped" }
vY = Vector3.new(31, 3, 134)
State = we.State
State.Notifications = {}
State.Status = "Idle"
State.PlotCapacity = 0
State.MoveBusy = false
vK = fn1017
wy = fn1075
wi = {}
v6 = fn691
wd = fn101
vn = function(aN, ...)
    local xt
    local xs
    xs = nil
    xt = nil
    xs = wd(aN, "RemoteEvent")
    if not xs then
        return false
    end
    xt = table.pack(...)
    return (pcall(function()
        xs:FireServer(table.unpack(xt, 1, xt.n))
    end))
end
vV = function(aU, ...)
    local xz
    local xy
    xy = nil
    xz = nil
    xz = wd(aU, "RemoteFunction")
    if not xz then
        return false, "remote unavailable"
    end
    xy = table.pack(...)
    local xA = table.pack(pcall(function()
        return xz:InvokeServer(table.unpack(xy, 1, xy.n))
    end))
    if not xA[1] then
        return false, "remote rejected"
    end
    return true, table.unpack(xA, 2, xA.n)
end
wp = fn1283
vL = fn133
vv = fn387
v2 = fn881
wx = fn929
vS = fn634
vt = fn1215
vX = fn1285
wA = fn749
v9 = fn635
vH = function(ck, cl)
    local yP
    local yO
    yO = nil
    yP = nil
    if typeof(ck) ~= "Vector3" then
        return false
    end
    yO = v9()
    if not yO then
        return false
    end
    local yR = cl or 4
    yP = ck + Vector3.new(0, yR, 0)
    return (pcall(function()
        yO.CFrame = CFrame.new(yP)
        yO.AssemblyLinearVelocity = Vector3.zero
    end))
end
wf = fn627
vN = fn789
wk = fn1021
wD = fn528
wg = function(cR)
    local ze_1
    local zd_1
    if not cR then
        return nil
    elseif cR:IsA("BasePart") then
        return cR.Position
    else
        zd_1, ze_1 = pcall(function()
            return cR:GetPivot()
        end)
        local zf = zd_1 and typeof(ze_1) == "CFrame"
        if zf then
            return ze_1.Position
        end
        return nil
    end
end
vz = fn252
wq = fn359
wn = function()
    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local Character = LocalPlayer.Character
    local dF = {}
    local function dG(dH)
        if not dH then
            return
        end
        for i, child in ipairs(dH:GetChildren()) do
            if child:IsA("Tool") then
                local attr = child:GetAttribute("OriginalName")
                if type(attr) == "string" then
                    table.insert(dF, { Tool = child, Name = attr, IsEgg = vS(attr), Rarity = wx(attr) })
                end
            end
        end
    end
    dG(Backpack)
    dG(Character)
    return dF
end
v5 = fn853
wv = fn246
v4 = fn1020
vl = function(ea)
    local Character = LocalPlayer.Character
    local Al = Character and Character:FindFirstChildOfClass("Humanoid")
    local Aj = Al
    if not Aj or not ea then
        return false
    elseif ea.Parent == Character then
        return true
    else
        return (pcall(function()
            Aj:EquipTool(ea)
        end))
    end
end
vP = fn682
wa = fn175
wr = fn669
vs = fn49
vu = fn189
vI = fn106
ww = fn383
vZ = fn1004
vm = { interval = 0.6, zones = {}, rarities = {} }
wz = { interval = 2, rarities = {} }
wt = { interval = 3 }
wm = { interval = 12 }
wj = { interval = 15 }
v8 = { interval = 10, targets = {} }
v0 = { interval = 30, mode = "Inventory", minimum = 1, teleport = true }
vW = { interval = 10 }
vQ = { interval = 10 }
vG = function(fG, fH)
    local generation
    local Bw = fG.generation or 0
    fG.generation = Bw + 1
    fG.stopped = false
    generation = fG.generation
    task.spawn(function()
        local Bt_1
        while true do
            local Bs = vy() and not fG.stopped and fG.generation == generation
            local Bs_1
            if Bs then
                Bs_1, Bt_1 = pcall(fH)
                if not Bs_1 then
                    warn("[Astra Hub] loop error: " .. tostring(Bt_1))
                end
                local Bs_2 = not vy() or fG.stopped or fG.generation ~= generation
                if Bs_2 then
                    break
                end
                task.wait(fG.interval)
                continue
            end
            break
        end
    end)
end
vE = fn569
vw = fn708
vm.mode = "Instant"
vm.tweenSpeed = 500
vm.float = { active = false }

-- Starts "float" mode (Tween only): the character is held by us every physics step.
-- PlatformStand (like Fly) + zero velocity + no collision,
-- so gravity / physics / walls can never drop or drag the character.
vm.BeginFloat = function()
    local f = vm.float
    if f.active then
        return true
    end
    local Character = LocalPlayer.Character
    local root = v9()
    local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if not Character or not root or not humanoid or humanoid.Health <= 0 then
        return false
    end
    local _, yaw = root.CFrame:ToOrientation()
    f.active = true
    f.root = root
    f.humanoid = humanoid
    f.character = Character
    f.yaw = yaw
    f.rot = CFrame.Angles(0, yaw, 0)
    f.pos = root.Position
    f.goal = root.Position
    f.arrived = true
    f.speedNow = 0
    f.prevPlatformStand = humanoid.PlatformStand
    f.collide = {}
    humanoid.PlatformStand = true
    f.conn = RunService.Stepped:Connect(function(_, dt)
        if not f.active then
            return
        end
        if we.Unloaded or not root.Parent or humanoid.Health <= 0 or LocalPlayer.Character ~= Character then
            vm.EndFloat()
            return
        end
        -- keep every part non-colliding (the Humanoid re-enables some of them)
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                if f.collide[part] == nil then
                    f.collide[part] = part.CanCollide
                end
                part.CanCollide = false
            end
        end
        humanoid.PlatformStand = true

        -- smooth movement towards the goal (ease in / ease out).
        -- The speed is read live every frame, so changing Tween Speed while stealing applies instantly.
        local speed = math.max(vm.tweenSpeed, 5)
        local delta = f.goal - f.pos
        local dist = delta.Magnitude
        if dist > 0.05 then
            f.speedNow = math.min(speed, f.speedNow + speed * dt * 4)
            local cap = math.max(dist * 6, 10)
            local step = math.min(f.speedNow, cap) * dt
            if step >= dist then
                f.pos = f.goal
                f.arrived = true
            else
                f.pos = f.pos + delta.Unit * step
                f.arrived = false
            end
            -- face the direction of travel
            if math.sqrt(delta.X * delta.X + delta.Z * delta.Z) > 1 then
                f.yaw = math.atan2(-delta.X, -delta.Z)
            end
        else
            f.pos = f.goal
            f.arrived = true
            f.speedNow = 0
        end
        f.rot = CFrame.Angles(0, f.yaw, 0)

        root.CFrame = CFrame.new(f.pos) * f.rot
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
    return true
end

vm.EndFloat = function()
    local f = vm.float
    if not f.active then
        return
    end
    f.active = false
    if f.conn then
        f.conn:Disconnect()
        f.conn = nil
    end
    for part, value in pairs(f.collide or {}) do
        if part.Parent then
            part.CanCollide = value
        end
    end
    local root, humanoid = f.root, f.humanoid
    if root and root.Parent then
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, f.yaw or 0, 0)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    if humanoid and humanoid.Parent then
        humanoid.PlatformStand = f.prevPlatformStand == true
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end
end

-- Moves the character.
-- Instant: classic teleport (no float).
-- Tween: smooth glide at vm.tweenSpeed while floating (needs BeginFloat).
-- Returns true when it arrived.
vm.MoveTo = function(target, tween, cancel)
    if not tween then
        vH(target, 0)
        RunService.Heartbeat:Wait()
        return true
    end
    local f = vm.float
    if not f.active then
        return false
    end
    f.goal = target
    f.arrived = false
    local timeout = os.clock() + 120 -- safety only; speed can change live
    while vy() and not vm.stopped and f.active and not f.arrived and os.clock() < timeout do
        if cancel and cancel() then
            f.goal = f.pos -- stop where we are
            return false
        end
        RunService.Heartbeat:Wait()
    end
    return f.arrived
end

-- Fires the prompt in every way we can.
vm.Fire = function(prompt, attempt)
    local fired = wA(prompt)
    if not fired or attempt % 2 == 0 then
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(0.06)
            prompt:InputHoldEnd()
        end)
    end
end

-- Keeps trying until the egg is really in our hands (or it is gone / timeout).
-- Returns carrying, gone
vm.Grab = function(egg, tween)
    local prompt = egg.Prompt
    local saved
    pcall(function()
        saved = {
            HoldDuration = prompt.HoldDuration,
            MaxActivationDistance = prompt.MaxActivationDistance,
            RequiresLineOfSight = prompt.RequiresLineOfSight
        }
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = math.max(prompt.MaxActivationDistance, 20)
        prompt.RequiresLineOfSight = false
    end)

    local offsets = { 3, 1.5, 0, 4.5, 2.5 }
    local deadline = os.clock() + 10
    local attempt = 0
    local gone = false
    while vy() and not vm.stopped and os.clock() < deadline do
        if wf() then
            break
        end
        if not egg.Model.Parent or not prompt.Parent or not prompt.Enabled then
            gone = true
            break
        end
        attempt += 1
        local pos = wg(egg.Model) or egg.Position
        local offset = offsets[(attempt - 1) % #offsets + 1]
        -- (re)position right on the egg with the latest position
        vm.MoveTo(pos + Vector3.new(0, offset, 0), tween, function()
            return wf() or not egg.Model.Parent
        end)
        -- let the server see our new position before triggering the prompt
        local target = pos + Vector3.new(0, offset, 0)
        local settle = os.clock() + (attempt == 1 and 0.3 or 0.2)
        while vy() and not vm.stopped and os.clock() < settle and not wf() do
            if not tween then
                vH(target, 0) -- Instant: keep snapping onto the egg so gravity cannot drift us away
            end
            task.wait(0.05)
        end
        if wf() then
            break
        end
        if egg.Model.Parent and prompt.Parent and prompt.Enabled then
            vm.Fire(prompt, attempt)
        end
        local untilTime = os.clock() + 0.7
        local nextSnap = os.clock() + 0.15
        while vy() and not vm.stopped and os.clock() < untilTime and not wf() do
            if not tween and os.clock() >= nextSnap and egg.Model.Parent then
                nextSnap = os.clock() + 0.15
                vH(target, 0)
            end
            task.wait(0.03)
        end
    end

    if saved then
        pcall(function()
            if prompt.Parent then
                prompt.HoldDuration = saved.HoldDuration
                prompt.MaxActivationDistance = saved.MaxActivationDistance
                prompt.RequiresLineOfSight = saved.RequiresLineOfSight
            end
        end)
    end
    return wf(), gone
end

-- Runs the egg to the delivery point. Only called when we really carry an egg.
-- Instant: the classic teleport (vN).
-- Tween: glide there while floating, and the moment we arrive the float is
-- switched OFF so the character is back to normal and the game registers the egg.
vm.Deliver = function(tween)
    if not wf() then
        return false
    end
    if not tween then
        return vN()
    end
    if not vm.BeginFloat() then
        return false
    end
    wy("Delivering the egg")
    vm.MoveTo(vY, true, function()
        return not wf()
    end)
    -- arrived (or already delivered on the way): back to a normal character
    vm.EndFloat()
    local untilTime = os.clock() + 5
    local round = 0
    while vy() and not vm.stopped and wf() and os.clock() < untilTime do
        round += 1
        -- normal character standing in the delivery zone; tiny nudges re-trigger it if needed
        local nudge = (round % 3 == 0) and Vector3.new(1.5, 0, 0) or (round % 3 == 2) and Vector3.new(-1.5, 0, 0) or Vector3.zero
        vH(vY + nudge, 0)
        task.wait(0.25)
    end
    return not wf()
end

-- One full steal: go to egg -> grab (guaranteed) -> deliver.
vm.Steal = function(egg, tween)
    if not egg.Model.Parent then
        return false
    end
    if tween and not vm.BeginFloat() then
        return false
    end
    wy("Collecting " .. egg.Name)
    local pos = wg(egg.Model) or egg.Position
    vm.MoveTo(pos + Vector3.new(0, 3, 0), tween, function()
        return wf() or not egg.Model.Parent or not egg.Prompt.Enabled
    end)
    local carrying, gone = vm.Grab(egg, tween)
    if not carrying then
        -- never teleport back without an egg
        wy(gone and "Egg was taken, looking for another" or "Could not grab the egg, retrying")
        return false
    end
    return vm.Deliver(tween)
end

wb = function()
    local tween = vm.mode == "Tween"
    if wf() then
        -- already holding an egg (e.g. a previous delivery failed): finish it first
        wk(function()
            local ok, result = pcall(vm.Deliver, tween)
            vm.EndFloat()
            if not ok then
                warn("[Astra Hub] steal error: " .. tostring(result))
                return false
            end
            return result
        end)
        return
    end
    local BQ = vz(vm.zones, vm.rarities)
    if #BQ == 0 then
        wy("No egg matches the filters right now")
        return
    end
    local BP = wq(BQ)
    if not BP then
        return
    end
    wk(function()
        local ok, result = pcall(vm.Steal, BP, tween)
        vm.EndFloat()
        if not ok then
            warn("[Astra Hub] steal error: " .. tostring(result))
            return false
        end
        return result
    end)
end
vm.SetMode = function(mode)
    if type(mode) == "table" then
        mode = mode.Title or mode[1]
    end
    vm.mode = (mode == "Tween") and "Tween" or "Instant"
end
vm.SetTweenSpeed = function(value)
    vm.tweenSpeed = math.clamp(tonumber(value) or 500, 5, 2000)
end
vm.SetEnabled = fn17
vm.SetDelay = fn702
vm.SetZones = fn465
vm.SetRarities = fn921
v1 = function()
    local Cf, Cg, Ch, Ci, Cj, Ck
    Cj = vv()
    if not Cj then
        wy("Your plot is not loaded")
        return
    end
    Cf = wn()
    if #Cf == 0 then
        return
    end
    Ci = next(wz.rarities) ~= nil
    local Cl = v2()
    Ch = wv() - #Cl
    Ck = false
    Cg = 0
    wk(function()
        local B6 = wg(Cj)
        local B7 = B6 and not vH(B6, 8)
        if B7 then
            return false
        end
        task.wait(0.3)
        for i, v in ipairs(Cf) do
            local B6_1 = not vy() or wz.stopped
            if B6_1 or Ck then
                break
            elseif not not v.Tool.Parent then
                local B6_2 = Ci
                if B6_2 then
                    B6_2 = not (v.Rarity and wz.rarities[v.Rarity])
                end
                if not B6_2 then
                    if not (v.IsEgg and Ch <= 0) then
                        local B6_4 = v4()
                        local B7_3 = B6_4 and vl(v.Tool)
                        if B7_3 then
                            task.wait(0.15)
                            if vn("PlaceItemAtCursor", B6_4) then
                                task.wait(0.45)
                                if v.Tool.Parent then
                                    Ck = true
                                else
                                    Cg += 1
                                    if v.IsEgg then
                                        Ch -= 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return true
    end)
    if Cg > 0 then
        v5(true)
        local Cm = Cg == 1 and "" or "s"
        wy("Placed " .. Cg .. " item" .. Cm .. " on your plot")
    else
        local Cl_2 = Ck
        local Cq = if Cl_2 then 1 else 0
        local Co = 1626 * Cq + 2081 * (1 - Cq)
        local Cp = 2111 * Cq + 2714 * (1 - Cq)
        if not ((Co * 1498 + Cp * 3306 + Co * Cp) % 16777213 == 12847200) then
            Cl_2 = Ch <= 0
        end
        if Cl_2 then
            wy("Your plot will not take any more")
        end
    end
end
wz.SetEnabled = fn500
wz.SetRarities = fn743
wz.SetDelay = fn204
vo = fn557
wt.SetEnabled = fn127
wt.SetDelay = fn1256
vT = fn1284
wm.SetEnabled = fn832
wm.SetDelay = fn473
wc = fn117
wj.SetEnabled = fn265
vJ = fn92
v8.SetEnabled = fn854
v8.SetTargets = fn1217
vq = function()
    local DB
    local DC = v0.mode == "Equipped" and "Equipped"
    local DC_1
    local DD = DC or "Inventory"
    local DD_1
    DB = DD
    if DB == "Inventory" then
        if #wn() < v0.minimum then
            return
        end
    else
        DC_1, DD_1 = v2()
        if #DD_1 < v0.minimum then
            return
        end
    end
    local DC_2 = wk(function()
        if v0.teleport then
            local Dv = vZ()
            local Dv_1 = Dv and Dv.Position or nil
            local Dw_1 = Dv_1
            if Dv_1 then
                Dv_1 = not vH(Dw_1, 4)
            end
            if Dv_1 then
                return false
            end
            task.wait(0.3)
            return vn("RequestSell", DB)
        end
        return vn("RequestSell", DB)
    end)
    if DC_2 then
        wy("Sold your " .. string.lower(DB))
    end
end
v0.SetEnabled = fn68
v0.SetDelay = fn235
v0.SetMode = fn65
v0.SetMinimum = fn898
v0.SetTeleport = fn1161
vC = fn637
vW.SetEnabled = fn1259
vr = fn687
vQ.SetEnabled = fn559
we.Track(fn181)
vD = nil
vD = task.spawn(worker)
we.Track(fn609)
local function wE_1()
    local HUB_NAME = "Astra Hub"
    local GAME_NAME = "Swing For Eggs"
    local SCRIPT_TITLE = GAME_NAME
    local VERSION = "v1.4"

    local okLib, WindUI = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)
    if not okLib or type(WindUI) ~= "table" then
        warn("[" .. HUB_NAME .. "] Failed to load WindUI: " .. tostring(WindUI))
        pcall(we.Unload)
        return
    end

    local ThemeSync = {
        default = "Plant"
    }

    function ThemeSync.toColor(value)
        if typeof(value) == "Color3" then
            return value
        end
        if type(value) == "string" then
            local ok, color = pcall(Color3.fromHex, value)
            if ok and typeof(color) == "Color3" then
                return color
            end
        end
        return nil
    end

    function ThemeSync.getTheme(name)
        local ok, themes = pcall(function()
            return WindUI:GetThemes()
        end)
        if ok and type(themes) == "table" then
            return themes[name]
        end
        return nil
    end

    -- Takes the most colourful colour of the theme and builds a 2-colour gradient from it
    function ThemeSync.colors(name)
        local theme = ThemeSync.getTheme(name)
        local best, bestScore = nil, 0
        if type(theme) == "table" then
            for _, key in ipairs({ "Accent", "Button", "Icon", "Outline", "Text" }) do
                local color = ThemeSync.toColor(theme[key])
                if color then
                    local _, s, v = color:ToHSV()
                    if v >= 0.35 and s * v > bestScore then
                        best, bestScore = color, s * v
                    end
                end
            end
        end
        best = best or Color3.fromHex("#30ff6a")
        local h, s, v = best:ToHSV()
        local second = Color3.fromHSV((h + 0.07) % 1, math.clamp(s * 0.85, 0, 1), math.clamp(v + 0.15, 0, 1))
        return best, second
    end

    local startTheme = ThemeSync.getTheme(ThemeSync.default) and ThemeSync.default or "Dark"
    local startColor = ThemeSync.colors(startTheme)

    local Window = WindUI:CreateWindow({
        Title = SCRIPT_TITLE,
        Icon = "egg",
        Author = "by " .. HUB_NAME,
        Folder = "AstraHub",
        Size = UDim2.fromOffset(620, 470),
        Theme = startTheme,
        Transparent = true,
        Resizable = true,
        SideBarWidth = 190,
        ToggleKey = Enum.KeyCode.RightShift
    })

    pcall(function()
        Window:Tag({ Title = VERSION, Color = startColor })
    end)

    -- The bar that appears when the window is minimized with "-": drag handle | icon + name.
    -- Name, icon and outline colour follow the current theme.
    function ThemeSync.apply(name)
        name = tostring(name or startTheme)
        local c1, c2 = ThemeSync.colors(name)
        pcall(function()
            Window:EditOpenButton({
                Title = GAME_NAME,
                Icon = "egg",
                CornerRadius = UDim.new(0, 16),
                StrokeThickness = 2,
                Color = ColorSequence.new(c1, c2),
                Enabled = true,
                OnlyMobile = false,
                Draggable = true
            })
        end)
    end
    ThemeSync.apply(startTheme)

    -- Unload wiring: closing the window unloads the script and vice versa
    local windowDestroyed = false
    pcall(function()
        Window:OnDestroy(function()
            windowDestroyed = true
            pcall(we.Unload)
        end)
    end)
    we.Track(function()
        if not windowDestroyed then
            windowDestroyed = true
            pcall(function()
                Window:Destroy()
            end)
        end
    end)

    local Flags = {}
    local Config = nil
    pcall(function()
        Config = Window.ConfigManager:CreateConfig("SwingForEggs")
    end)

    local function notify(text, duration, icon)
        pcall(function()
            WindUI:Notify({
                Title = HUB_NAME,
                Content = tostring(text),
                Duration = duration or 5,
                Icon = icon or "bell"
            })
        end)
    end

    local function copyText(text, okMessage)
        local copier = setclipboard or toclipboard
        if type(copier) ~= "function" then
            notify("Clipboard is unavailable", 4, "x")
            return
        end
        if pcall(copier, text) then
            notify(okMessage, 3, "check")
        else
            notify("Failed to copy", 4, "x")
        end
    end

    local function register(flag, element)
        if Config and element then
            pcall(function()
                Config:Register(flag, element)
            end)
        end
        return element
    end

    local function addToggle(tab, flag, title, desc, default, onChange)
        Flags[flag] = default
        return register(flag, tab:Toggle({
            Title = title,
            Desc = desc,
            Value = default,
            Callback = function(state)
                state = state == true
                Flags[flag] = state
                if onChange then
                    onChange(state)
                end
            end
        }))
    end

    local function addSlider(tab, flag, title, desc, min, max, default, step, onChange)
        Flags[flag] = default
        return register(flag, tab:Slider({
            Title = title,
            Desc = desc,
            Step = step,
            Value = { Min = min, Max = max, Default = default },
            Callback = function(value)
                value = tonumber(value) or default
                value = math.floor(value * 100 + 0.5) / 100
                Flags[flag] = value
                if onChange then
                    onChange(value)
                end
            end
        }))
    end

    local function addDropdown(tab, flag, title, desc, values, default, multi, onChange)
        Flags[flag] = default
        return register(flag, tab:Dropdown({
            Title = title,
            Desc = desc,
            Values = values,
            Value = default,
            Multi = multi,
            AllowNone = multi,
            Callback = function(selected)
                if not multi and type(selected) == "table" then
                    selected = selected.Title or selected[1]
                end
                Flags[flag] = selected
                if onChange then
                    onChange(selected)
                end
            end
        }))
    end

    local function setText(paragraph, text)
        pcall(function()
            paragraph:SetDesc(text)
        end)
    end

    local zoneLabels, zoneMap = vX()
    local suitNames = vI()

    local InfoTab = Window:Tab({ Title = "Info", Icon = "info" })
    local EggsTab = Window:Tab({ Title = "Eggs", Icon = "egg" })
    local MoneyTab = Window:Tab({ Title = "Money", Icon = "dollar-sign" })
    local UpgradesTab = Window:Tab({ Title = "Upgrades", Icon = "trending-up" })
    local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
    local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

    local function buildEggsTab(tab)
        local statusParagraph = tab:Paragraph({ Title = "Status", Desc = tostring(State.Status) })

        tab:Section({ Title = "Auto Steal" })
        addToggle(tab, "AutoSteal", "Auto Steal",
            "Goes to the nearest matching wild egg, makes sure it is really grabbed, then delivers it to the delivery point.",
            false, function(on)
                vm.SetEnabled(on)
            end)
        if #zoneLabels > 0 then
            addDropdown(tab, "StealZones", "Zones",
                "Wild eggs only. Leave everything unticked to use every zone.",
                zoneLabels, {}, true, function(selected)
                    vm.SetZones(selected, zoneMap)
                end)
        else
            tab:Paragraph({ Title = "Zones", Desc = "No zones detected yet. Every zone will be used." })
        end
        addDropdown(tab, "StealRarities", "Rarities",
            "Leave everything unticked to accept any rarity.",
            wu, {}, true, function(selected)
                vm.SetRarities(selected)
            end)
        addDropdown(tab, "StealMode", "Steal Mode",
            "Instant: classic teleport to the egg and back. Tween: smoothly flies to the egg, grabs it, flies to the delivery point and returns to a normal character there.",
            { "Instant", "Tween" }, "Instant", false, function(selected)
                vm.SetMode(selected)
            end)
        addSlider(tab, "TweenSpeed", "Tween Speed (studs/s)",
            "Only used when Steal Mode is Tween. Can be changed live while stealing.", 10, 2000, 500, 10,
            function(value)
                vm.SetTweenSpeed(value)
            end)
        addSlider(tab, "StealDelay", "Steal Delay (s)", nil, 0.1, 10, 0.6, 0.1, function(value)
            vm.SetDelay(value)
        end)

        tab:Section({ Title = "Plot" })
        addToggle(tab, "AutoPlace", "Auto Place Eggs",
            "Carries what you are holding back to your plot and plants it until the plot is full.",
            false, function(on)
                wz.SetEnabled(on)
            end)
        addDropdown(tab, "PlaceRarities", "Place Rarities",
            "Only plants items of these rarities. Leave everything unticked to plant whatever you are carrying.",
            wu, {}, true, function(selected)
                wz.SetRarities(selected)
            end)
        addSlider(tab, "PlaceDelay", "Place Delay (s)", nil, 0.5, 30, 2, 0.1, function(value)
            wz.SetDelay(value)
        end)

        tab:Section({ Title = "Hatch" })
        addToggle(tab, "AutoHatch", "Auto Hatch Eggs",
            "Hatches every egg on your plot as soon as its timer is finished.",
            false, function(on)
                wt.SetEnabled(on)
            end)
        addSlider(tab, "HatchDelay", "Hatch Check Delay (s)", nil, 0.5, 30, 3, 0.1, function(value)
            wt.SetDelay(value)
        end)

        tab:Section({ Title = "Pets" })
        addToggle(tab, "AutoEquipBest", "Auto Equip Best",
            "Uses the game's Equip Best button to put your strongest pets on the plot. The game holds it on a 10 second cooldown.",
            false, function(on)
                wm.SetEnabled(on)
            end)
        addSlider(tab, "EquipBestDelay", "Equip Best Delay (s)", nil, 10, 120, 12, 1, function(value)
            wm.SetDelay(value)
        end)

        -- Status + notification pump
        local statusThread = task.spawn(function()
            while not we.Unloaded do
                pcall(function()
                    local eggs, pets = v2()
                    local capacity = State.PlotCapacity or 0
                    setText(statusParagraph, string.format("Eggs %d/%d  |  Pets %d/%d  |  %s",
                        #eggs, wv(), #pets, capacity, tostring(State.Status)))
                end)
                local drained = false
                repeat
                    if State.Notifications and #State.Notifications > 0 then
                        local item = table.remove(State.Notifications, 1)
                        notify(item.text, item.time)
                    else
                        drained = true
                    end
                until drained
                task.wait(0.3)
            end
        end)
        we.Track(function()
            if coroutine.status(statusThread) ~= "dead" then
                pcall(task.cancel, statusThread)
            end
        end)
    end

    local function buildMoneyTab(tab)
        tab:Section({ Title = "Auto Sell" })
        addToggle(tab, "AutoSell", "Auto Sell", "Sells through the sell NPC on a timer.", false, function(on)
            v0.SetEnabled(on)
        end)
        addDropdown(tab, "SellMode", "Sell Mode",
            "Inventory sells everything you are carrying, including eggs you have not planted. Equipped sells the pets standing on your plot.",
            v3, "Inventory", false, function(selected)
                v0.SetMode(selected)
            end)
        addSlider(tab, "SellMinimum", "Minimum Items",
            "Waits until you have at least this many items before selling.", 1, 30, 1, 1, function(value)
                v0.SetMinimum(value)
            end)
        addSlider(tab, "SellDelay", "Sell Delay (s)", nil, 1, 300, 30, 1, function(value)
            v0.SetDelay(value)
        end)
        addToggle(tab, "SellTeleport", "Travel To Seller", "Walks you to the sell NPC before selling.", true,
            function(on)
                v0.SetTeleport(on)
            end)
    end

    local function buildUpgradesTab(tab)
        tab:Section({ Title = "Progression" })
        addToggle(tab, "AutoIndex", "Auto Claim Index",
            "Claims the index reward of every animal you have discovered.", false, function(on)
                wj.SetEnabled(on)
            end)
        addToggle(tab, "AutoTreadmill", "Auto Upgrade Treadmill",
            "Buys the next treadmill as soon as you can afford it.", false, function(on)
                vW.SetEnabled(on)
            end)
        addToggle(tab, "AutoSlots", "Auto Upgrade Pet Slots",
            "Buys the next pet slot on your plot as soon as you can afford it.", false, function(on)
                vQ.SetEnabled(on)
            end)

        tab:Section({ Title = "Suits" })
        addToggle(tab, "AutoSuits", "Auto Buy Suits", "Buys unowned suits with cash, cheapest first.", false,
            function(on)
                v8.SetEnabled(on)
            end)
        if #suitNames > 0 then
            addDropdown(tab, "SuitTargets", "Suits",
                "Leave everything unticked to buy every suit you can afford.",
                suitNames, {}, true, function(selected)
                    v8.SetTargets(selected)
                end)
        else
            tab:Paragraph({ Title = "Suits", Desc = "No suits detected yet. Every suit you can afford will be bought." })
        end
    end

    local function buildInfoTab(tab)
        tab:Section({ Title = "About" })
        tab:Paragraph({
            Title = SCRIPT_TITLE,
            Desc = "Version " .. VERSION .. "\nPress RightShift to show or hide the menu."
        })

        tab:Section({ Title = "User" })
        tab:Paragraph({
            Title = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
            Desc = "UserId: " .. tostring(LocalPlayer.UserId),
            Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150",
            ImageSize = 42
        })

        local missing = {}
        if type(fireproximityprompt) ~= "function" then
            table.insert(missing, "stealing")
        end
        if not wd("PlaceItemAtCursor", "RemoteEvent") then
            table.insert(missing, "placing")
        end
        if not wd("RequestHatch", "RemoteEvent") then
            table.insert(missing, "hatching")
        end
        if not wd("IndexRewardAction", "RemoteFunction") then
            table.insert(missing, "index rewards")
        end
        if not wd("SuitShopAction", "RemoteFunction") then
            table.insert(missing, "suits")
        end
        if not wd("RequestTreadmillUpgrade", "RemoteFunction") or not wd("RequestPlotUpgrade", "RemoteFunction") then
            table.insert(missing, "upgrades")
        end
        if not wd("RequestSell", "RemoteEvent") then
            table.insert(missing, "selling")
        end
        local readiness = #missing == 0 and "ready" or ("limited: " .. table.concat(missing, ", "))

        local executorName = "Unknown"
        pcall(function()
            if type(identifyexecutor) == "function" then
                local name, version = identifyexecutor()
                if type(name) == "string" and name ~= "" then
                    executorName = (type(version) == "string" and version ~= "") and (name .. " " .. version) or name
                end
            end
        end)
        tab:Paragraph({ Title = "Executor", Desc = executorName .. "  -  " .. readiness })

        tab:Button({
            Title = "Copy Username",
            Callback = function()
                copyText(LocalPlayer.Name, "Copied username")
            end
        })
        tab:Button({
            Title = "Copy Profile Link",
            Callback = function()
                copyText("https://www.roblox.com/users/" .. tostring(LocalPlayer.UserId) .. "/profile", "Copied profile link")
            end
        })

        tab:Section({ Title = "Session" })
        local jobId = tostring(game.JobId)
        local shortJob = #jobId > 18 and (string.sub(jobId, 1, 18) .. "...") or jobId
        local sessionStart = os.clock()
        local sessionParagraph = tab:Paragraph({ Title = "Live", Desc = "Loading..." })
        tab:Paragraph({ Title = "Game", Desc = GAME_NAME .. "\nJob: " .. shortJob })

        tab:Button({
            Title = "Rejoin Place",
            Callback = function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        })
        tab:Button({
            Title = "Copy Job ID",
            Callback = function()
                copyText(jobId, "Copied Job ID")
            end
        })

        local function uptime()
            local seconds = math.floor(os.clock() - sessionStart)
            if seconds < 60 then
                return seconds .. "s"
            elseif seconds < 3600 then
                return string.format("%dm %ds", seconds // 60, seconds % 60)
            end
            return string.format("%dh %dm", seconds // 3600, seconds % 3600 // 60)
        end

        local liveThread = task.spawn(function()
            while true do
                task.wait(1)
                if we.Unloaded then
                    break
                end
                local okPing, ping = pcall(function()
                    return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                end)
                local pingText = okPing and (ping .. " ms") or "n/a"
                setText(sessionParagraph, string.format("Uptime: %s\nPlayers: %d/%s\nPing: %s",
                    uptime(), #Players:GetPlayers(), tostring(Players.MaxPlayers), pingText))
            end
        end)
        we.Track(function()
            if coroutine.status(liveThread) ~= "dead" then
                pcall(task.cancel, liveThread)
            end
        end)
    end

    local function buildPlayerTab(tab)
        local savedCollide, savedSpeed, savedPlatform, savedPrompts = {}, {}, {}, {}
        local connections = {}

        local function restoreCollide()
            for part, value in savedCollide do
                if part.Parent then
                    part.CanCollide = value
                end
            end
            table.clear(savedCollide)
        end
        local function restoreSpeed()
            for humanoid, value in savedSpeed do
                if humanoid.Parent then
                    humanoid.WalkSpeed = value
                end
            end
            table.clear(savedSpeed)
        end
        local function restorePlatform()
            for humanoid, value in savedPlatform do
                if humanoid.Parent then
                    humanoid.PlatformStand = value
                end
            end
            table.clear(savedPlatform)
        end
        local function patchPrompt(prompt)
            if not prompt:IsA("ProximityPrompt") then
                return
            end
            if savedPrompts[prompt] == nil then
                savedPrompts[prompt] = {
                    HoldDuration = prompt.HoldDuration,
                    MaxActivationDistance = prompt.MaxActivationDistance,
                    RequiresLineOfSight = prompt.RequiresLineOfSight
                }
            end
            prompt.HoldDuration = 0
            prompt.MaxActivationDistance = 50
            prompt.RequiresLineOfSight = false
        end
        local function restorePrompts()
            for prompt, value in savedPrompts do
                if prompt.Parent then
                    prompt.HoldDuration = value.HoldDuration
                    prompt.MaxActivationDistance = value.MaxActivationDistance
                    prompt.RequiresLineOfSight = value.RequiresLineOfSight
                end
            end
            table.clear(savedPrompts)
        end

        tab:Section({ Title = "Movement" })
        addToggle(tab, "WalkSpeedEnabled", "WalkSpeed", nil, false, function(on)
            if not on then
                restoreSpeed()
            end
        end)
        addSlider(tab, "WalkSpeed", "WalkSpeed Amount", nil, 16, 250, 32, 1)
        addToggle(tab, "InfJump", "Infinite Jump", nil, false)
        addToggle(tab, "NoClip", "NoClip", nil, false, function(on)
            if not on then
                restoreCollide()
            end
        end)
        addToggle(tab, "InstantProximityPrompt", "Instant ProximityPrompt", nil, false, function(on)
            if on then
                for _, prompt in Workspace:QueryDescendants("ProximityPrompt") do
                    pcall(patchPrompt, prompt)
                end
            else
                restorePrompts()
            end
        end)

        tab:Section({ Title = "Fly" })
        addToggle(tab, "Fly", "Fly", "W/A/S/D to move, Space to go up, Left Ctrl to go down.", false, function(on)
            if not on then
                restorePlatform()
            end
        end)
        addSlider(tab, "FlySpeed", "Fly Speed", nil, 10, 400, 60, 1)

        table.insert(connections, Workspace.DescendantAdded:Connect(function(instance)
            if Flags.InstantProximityPrompt then
                pcall(patchPrompt, instance)
            end
        end))
        table.insert(connections, RunService.Stepped:Connect(function()
            if we.Unloaded then
                return
            end
            local character = LocalPlayer.Character
            if Flags.NoClip and character then
                for _, part in character:QueryDescendants("BasePart") do
                    if savedCollide[part] == nil then
                        savedCollide[part] = part.CanCollide
                    end
                    part.CanCollide = false
                end
            end
        end))
        table.insert(connections, UserInputService.JumpRequest:Connect(function()
            if we.Unloaded then
                return
            end
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if Flags.InfJump and humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end))
        table.insert(connections, RunService.RenderStepped:Connect(function(dt)
            if we.Unloaded then
                return
            end
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local camera = Workspace.CurrentCamera

            if Flags.WalkSpeedEnabled and humanoid then
                if savedSpeed[humanoid] == nil then
                    savedSpeed[humanoid] = humanoid.WalkSpeed
                end
                humanoid.WalkSpeed = Flags.WalkSpeed
            end

            if Flags.Fly and root and humanoid and camera then
                if savedPlatform[humanoid] == nil then
                    savedPlatform[humanoid] = humanoid.PlatformStand
                end
                humanoid.PlatformStand = true
                local direction = Vector3.zero
                if not UserInputService:GetFocusedTextBox() then
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        direction += camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        direction -= camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        direction -= camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        direction += camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        direction += Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        direction -= Vector3.new(0, 1, 0)
                    end
                end
                root.AssemblyLinearVelocity = Vector3.zero
                if direction.Magnitude > 0 then
                    root.CFrame = root.CFrame + direction.Unit * Flags.FlySpeed * dt
                end
            end
        end))

        we.Track(function()
            for _, connection in connections do
                connection:Disconnect()
            end
            restoreCollide()
            restoreSpeed()
            restorePlatform()
            restorePrompts()
        end)
    end

    local function buildSettingsTab(tab)
        local connections = {}
        local savedEffects = {}
        local savedRender = nil
        local afkTriggers = 0
        local lastAfkPulse = os.clock()
        local reconnecting = false
        local reconnectSession = 0
        local afkParagraph

        local function afkPulse()
            local camera = Workspace.CurrentCamera
            if not camera then
                return false
            end
            local ok = pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0), camera.CFrame)
            end)
            if not ok then
                return false
            end
            afkTriggers += 1
            lastAfkPulse = os.clock()
            if afkParagraph then
                setText(afkParagraph, "AFK triggers: " .. afkTriggers)
            end
            return true
        end

        local function setGameplayPause(blocked)
            pcall(function()
                GuiService:SetGameplayPausedNotificationEnabled(not blocked)
            end)
            pcall(function()
                local gui = CoreGui:FindFirstChild("RobloxNetworkPauseNotification")
                if gui then
                    gui.Enabled = not blocked
                end
            end)
            if not blocked then
                return
            end
            pcall(function()
                if sethiddenproperty then
                    sethiddenproperty(LocalPlayer, "GameplayPaused", false)
                else
                    LocalPlayer.GameplayPaused = false
                end
            end)
        end

        local effectClasses = {
            ParticleEmitter = true, Trail = true, Smoke = true, Fire = true, Sparkles = true, Explosion = true, Beam = true
        }
        local function disableEffect(instance)
            if effectClasses[instance.ClassName] then
                if savedEffects[instance] == nil then
                    savedEffects[instance] = instance.Enabled
                end
                pcall(function()
                    instance.Enabled = false
                end)
            end
        end
        local function restoreVisuals()
            for instance, value in savedEffects do
                if instance.Parent then
                    pcall(function()
                        instance.Enabled = value
                    end)
                end
            end
            table.clear(savedEffects)
            if savedRender then
                pcall(function()
                    settings().Rendering.QualityLevel = savedRender.Quality
                end)
                Lighting.GlobalShadows = savedRender.Shadows
                Lighting.FogEnd = savedRender.Fog
                savedRender = nil
            end
        end

        local tryReconnect
        tryReconnect = function(forceNewServer)
            if reconnecting or we.Unloaded or not Flags.AutoReconnect then
                return
            end
            reconnecting = true
            local snapshot = reconnectSession
            local ok = pcall(function()
                if forceNewServer then
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                else
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                end
            end)
            if not ok then
                reconnecting = false
                if not forceNewServer and snapshot == reconnectSession then
                    task.delay(1.5, function()
                        if snapshot == reconnectSession then
                            tryReconnect(true)
                        end
                    end)
                end
            end
        end

        -- Safety
        tab:Section({ Title = "Safety" })
        addToggle(tab, "AntiAfk", "Anti-AFK", "Sends a harmless click when Roblox thinks you are idle.", true)
        afkParagraph = tab:Paragraph({ Title = "Anti-AFK", Desc = "AFK triggers: 0" })
        addToggle(tab, "AntiGameplayPause", "No Gameplay Paused", nil, true, function(on)
            setGameplayPause(on)
        end)
        addToggle(tab, "AutoReconnect", "Auto Reconnect on Kick", "Rejoins automatically when you get disconnected.", false)

        -- Performance
        tab:Section({ Title = "Performance" })
        addToggle(tab, "Disable3D", "Disable 3D Rendering", "Turns off 3D rendering to save GPU while farming.", false,
            function(on)
                pcall(function()
                    RunService:Set3dRenderingEnabled(not on)
                end)
            end)
        addToggle(tab, "FpsBoost", "FPS Boost", "Lowers graphics quality and removes visual effects.", false, function(on)
            if on then
                if not savedRender then
                    savedRender = {
                        Quality = settings().Rendering.QualityLevel,
                        Shadows = Lighting.GlobalShadows,
                        Fog = Lighting.FogEnd
                    }
                end
                pcall(function()
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                end)
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9000000000
                for _, instance in Workspace:QueryDescendants("ParticleEmitter,Trail,Smoke,Fire,Sparkles,Beam") do
                    pcall(disableEffect, instance)
                end
            else
                restoreVisuals()
            end
        end)

        -- Interface
        tab:Section({ Title = "Interface" })
        local menuKeys = { "RightShift", "LeftAlt", "RightControl", "Insert", "Home", "End", "Delete", "K", "M", "F4" }
        register("MenuKey", tab:Dropdown({
            Title = "Menu Key",
            Desc = "Key used to show or hide the menu.",
            Values = menuKeys,
            Value = "RightShift",
            Callback = function(selected)
                if type(selected) == "table" then
                    selected = selected.Title or selected[1]
                end
                local keyCode = Enum.KeyCode[tostring(selected)]
                if keyCode then
                    pcall(function()
                        Window:SetToggleKey(keyCode)
                    end)
                end
            end
        }))
        pcall(function()
            local themes = {}
            for themeName in pairs(WindUI:GetThemes()) do
                table.insert(themes, themeName)
            end
            table.sort(themes)
            register("Theme", tab:Dropdown({
                Title = "Theme",
                Desc = "Also changes the colour, icon and name of the minimized bar.",
                Values = themes,
                Value = startTheme,
                Callback = function(selected)
                    if type(selected) == "table" then
                        selected = selected.Title or selected[1]
                    end
                    pcall(function()
                        WindUI:SetTheme(selected)
                    end)
                    ThemeSync.apply(selected)
                end
            }))
        end)

        -- Config
        tab:Section({ Title = "Config" })
        tab:Button({
            Title = "Save Config",
            Desc = "Saves every toggle, slider and dropdown. It loads automatically next time.",
            Callback = function()
                if not Config then
                    notify("Config system is unavailable on this executor", 5, "x")
                    return
                end
                if pcall(function()
                    Config:Save()
                end) then
                    notify("Config saved", 4, "check")
                else
                    notify("Failed to save config", 4, "x")
                end
            end
        })
        tab:Button({
            Title = "Load Config",
            Callback = function()
                if not Config then
                    notify("Config system is unavailable on this executor", 5, "x")
                    return
                end
                if pcall(function()
                    Config:Load()
                end) then
                    notify("Config loaded", 4, "check")
                else
                    notify("No saved config found", 4, "x")
                end
            end
        })

        -- Script
        tab:Section({ Title = "Script" })
        tab:Button({
            Title = "Unload Script",
            Desc = "Stops every feature and removes the menu.",
            Callback = function()
                pcall(we.Unload)
            end
        })

        -- Runtime wiring
        table.insert(connections, LocalPlayer.Idled:Connect(function()
            if Flags.AntiAfk and not we.Unloaded then
                afkPulse()
            end
        end))
        table.insert(connections, Workspace.DescendantAdded:Connect(function(instance)
            if Flags.FpsBoost then
                disableEffect(instance)
            end
        end))
        table.insert(connections, TeleportService.TeleportInitFailed:Connect(function(player)
            if player == LocalPlayer and reconnecting then
                reconnecting = false
                local snapshot = reconnectSession
                task.delay(3, function()
                    if snapshot == reconnectSession then
                        tryReconnect(true)
                    end
                end)
            end
        end))
        task.spawn(function()
            local promptGui = CoreGui:WaitForChild("RobloxPromptGui", 30)
            local overlay = promptGui and promptGui:WaitForChild("promptOverlay", 30)
            if we.Unloaded or not overlay then
                return
            end
            table.insert(connections, overlay.ChildAdded:Connect(function(child)
                if child.Name == "ErrorPrompt" then
                    tryReconnect(false)
                end
            end))
        end)

        local loopThread = task.spawn(function()
            while not we.Unloaded do
                if Flags.AntiGameplayPause then
                    setGameplayPause(true)
                end
                if Flags.AntiAfk and os.clock() - lastAfkPulse >= 60 then
                    afkPulse()
                end
                task.wait(1)
            end
        end)

        setGameplayPause(true)

        we.Track(function()
            reconnectSession += 1
            for _, connection in connections do
                connection:Disconnect()
            end
            pcall(task.cancel, loopThread)
            setGameplayPause(false)
            restoreVisuals()
            pcall(function()
                RunService:Set3dRenderingEnabled(true)
            end)
        end)

        return setGameplayPause
    end

    buildInfoTab(InfoTab)
    buildEggsTab(EggsTab)
    buildMoneyTab(MoneyTab)
    buildUpgradesTab(UpgradesTab)
    buildPlayerTab(PlayerTab)
    local setGameplayPause = buildSettingsTab(SettingsTab)

    if Config then
        pcall(function()
            Config:Load()
        end)
    end

    vm.SetMode(Flags.StealMode)
    vm.SetTweenSpeed(Flags.TweenSpeed)
    vm.SetDelay(Flags.StealDelay)
    vm.SetZones(Flags.StealZones, zoneMap)
    vm.SetRarities(Flags.StealRarities)
    wz.SetRarities(Flags.PlaceRarities)
    wz.SetDelay(Flags.PlaceDelay)
    wt.SetDelay(Flags.HatchDelay)
    v0.SetMode(Flags.SellMode)
    v0.SetMinimum(Flags.SellMinimum)
    v0.SetDelay(Flags.SellDelay)
    v0.SetTeleport(Flags.SellTeleport)
    v8.SetTargets(Flags.SuitTargets)
    wm.SetDelay(Flags.EquipBestDelay)

    vm.SetEnabled(Flags.AutoSteal)
    wz.SetEnabled(Flags.AutoPlace)
    wt.SetEnabled(Flags.AutoHatch)
    wm.SetEnabled(Flags.AutoEquipBest)
    v0.SetEnabled(Flags.AutoSell)
    wj.SetEnabled(Flags.AutoIndex)
    v8.SetEnabled(Flags.AutoSuits)
    vW.SetEnabled(Flags.AutoTreadmill)
    vQ.SetEnabled(Flags.AutoSlots)
    setGameplayPause(Flags.AntiGameplayPause)

    pcall(function()
        Window:SelectTab(1)
    end)
    notify(SCRIPT_TITLE .. " loaded successfully", 5, "check")
end
wE_1()
