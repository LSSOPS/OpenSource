local v1 = unpack or table.unpack
if game:GetService("CoreGui"):FindFirstChild("ToraScript") then
    game:GetService("CoreGui").ToraScript:Destroy()
end
local v2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local v3 = v2:CreateWindow("Steal Hatch Anime")

task.spawn(function()
    local timestamp = tick()

    while task.wait() do
        if tick() - timestamp >= 1 then
            timestamp = tick()
            os.date(table.concat({
				"%H",
				"%M",
				"%S"
			}, ":"))
        end
    end
end)

local t1 = {
	Legendary = 1,
	Mythic = 2,
	Cosmic = 3,
	Secret = 4,
	Eternal = 5,
	Divine = 6
}
v3:AddList({
	text = "Minimum Rarity",
	flag = "list",
	value = "==Select Rarity==",
	values = {
		"Legendary",
		"Mythic",
		"Cosmic",
		"Secret",
		"Eternal",
		"Divine"
	},
	callback = function(p1)
    setrarity = p1
end
})
v3:AddToggle({
	text = "Auto Steal",
	flag = "toggle",
	state = false,
	callback = function(p2)
    _G.Steal = p2
    print("Steal: ", p2)

    if p2 then
        Steal()
    end
end
})
function Steal()
    spawn(function()
        _G.Steal = true

        while _G.Steal do
            pcall(function()
                local v14 = t1[setrarity] or 1
                local v15
                local n1 = 0
                for v19, v20 in pairs(workspace.LiveAreaEggs:GetDescendants()) do

                    local v21 = t1[v20:GetAttribute("Rarity")]

                    if v21 and v14 <= v21 and n1 < v21 then
                        n1 = v21
                        v15 = v20
                    end
                end
                if v15 then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v15:GetPivot() * CFrame.new(0, 15, 0)
                    wait(1)

                    local t2 = {
						[1] = v15
					}
                    local StealEgg = game:GetService("ReplicatedStorage").GameRemotes.StealEgg
                    local t3 = { unpack(t2) }

                    StealEgg:FireServer(v1(t3))
                    wait(0.2)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Plots[game:GetService("Players").LocalPlayer:GetAttribute("PlotSlot")]:GetPivot("WorldPivot") * CFrame.new(0, 15, 0)
                end
                wait(1)
            end)
        end
    end)
end
v3:AddToggle({
	text = "Auto Place",
	flag = "toggle",
	state = false,
	callback = function(p3)
    _G.Place = p3
    print("Place: ", p3)

    if p3 then
        Place()
    end
end
})
function Place()
    spawn(function()
        _G.Place = true

        while _G.Place do
            wait()
            pcall(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local LocalPlayer = Players.LocalPlayer
                local v28 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local PetArea = workspace.Plots[LocalPlayer:GetAttribute("PlotSlot")].ToUpdate.PetArea
                local g43
                local g45
                local v44
                for _, child in pairs(LocalPlayer.StolenEggs:GetChildren()) do
                    if not child:IsA("Model") then
                        continue
                    end

                    local EggUid = child:GetAttribute("EggUid")

                    if EggUid then
                        local t4 = {
							[1] = EggUid
						}
                        local EquipEgg = ReplicatedStorage.GameRemotes.EquipEgg
                        local _unpack = unpack
                        local FireServer = EquipEgg.FireServer
                        local t5 = { _unpack(t4) }
                        local GetChildren = v28.GetChildren
                        FireServer(EquipEgg, v1(t5))
                        wait(0.2)
                        local v39
                        local v40, v41, v42 = pairs(GetChildren(v28))
                        repeat
                            repeat
                                if not g43 then
                                    v42, v44 = v40(v41, v42)
                                end

                                if g43 or not v42 then
                                    g43 = false

                                    if not v39 then
                                        g45 = true
                                    end

                                    if not g45 then
                                        local t6 = {
											[1] = (function(p4)
                                            local p4Size = p4.Size
                                            local v69 = math.random() - 0.5
                                            local p4SizeX = p4Size.X
                                            local _math = math
                                            local v72 = v69 * p4SizeX
                                            local v73 = (_math.random() - 0.5) * p4Size.Y
                                            local v74 = (math.random() - 0.5) * p4Size.Z

                                            return (p4.CFrame * CFrame.new(v72, v73, v74)).Position
                                        end)(PetArea)
										}
                                        local PlaceEgg = ReplicatedStorage.GameRemotes.PlaceEgg
                                        local t7 = { unpack(t6) }

                                        PlaceEgg:FireServer(v1(t7))
                                        g45 = true
                                    end
                                end

                                if g45 then
                                    break
                                end

                                if g45 then
                                    break
                                end
                            until v44:IsA("Model") and EggUid == v44:GetAttribute("EggUid")

                            if g45 then
                                break
                            end

                            if g45 then
                                break
                            end

                            v39 = v44
                            g43 = true
                        until not g43
                    end

                    if g45 then
                        break
                    end

                    if g45 then
                        break
                    end
                end
                wait(0.2)
            end)
        end
    end)
end
v3:AddToggle({
	text = "Auto Hatch",
	flag = "toggle",
	state = false,
	callback = function(p5)
    _G.Hatch = p5
    print("Hatch: ", p5)

    if p5 then
        Hatch()
    end
end
})
function Hatch()
    spawn(function()
        _G.Hatch = true

        while _G.Hatch do
            wait()
            pcall(function()
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local str = tostring(Players.LocalPlayer.UserId)

                for _, child in pairs(workspace.PlacedEggRenders:GetChildren()) do
                    local childName = child.Name

                    if childName:sub(1, #str + 1) == str .. "_" then
                        local v55 = childName:sub(#str + 2)

                        print("Found ItemId:", v55)

                        local t8 = {
							[1] = v55
						}
                        local v57 = ReplicatedStorage.Network:FindFirstChild("Eggs: RequestHatchEgg")
                        local t9 = { unpack(t8) }

                        v57:InvokeServer(v1(t9))

                        local t10 = {
							[1] = v55
						}
                        local v60 = game:GetService("ReplicatedStorage").Network:FindFirstChild("Eggs: RequestCompleteHatchEgg")
                        local t11 = { unpack(t10) }

                        v60:InvokeServer(v1(t11))
                    end
                end

                wait(4)
            end)
        end
    end)
end
v3:AddToggle({
	text = "Equip Best",
	flag = "toggle",
	state = false,
	callback = function(p6)
    _G.Equip = p6
    print("Equip: ", p6)

    if p6 then
        Equip()
    end
end
})
function Equip()
    spawn(function()
        _G.Equip = true

        while _G.Equip do
            wait()
            pcall(function()
                game:GetService("ReplicatedStorage").GameRemotes.EquipBestPets:InvokeServer()
                wait(4)
            end)
        end
    end)
end
v3:AddToggle({
	text = "Auto Train",
	flag = "toggle",
	state = false,
	callback = function(p7)
    _G.Train = p7
    print("Train: ", p7)

    if p7 then
        Train()
    end
end
})
function Train()
    spawn(function()
        _G.Train = true

        while _G.Train do
            wait()
            pcall(function()
                if game:GetService("Players").LocalPlayer:GetAttribute("OnTreadmill") == false then
                    local _game = game
                    local t12 = {
						[1] = true
					}

                    _game:GetService("ReplicatedStorage").GameRemotes.PortableTreadmillToggle:FireServer(unpack(t12))
                end

                if workspace.Plots[game:GetService("Players").LocalPlayer:GetAttribute("PlotSlot")].TreadmillUpgrade.Sign.CanUpgrade.Enabled == true then
                    local t13 = {
						[1] = "Treadmill",
						[2] = "1"
					}

                    game:GetService("ReplicatedStorage").Network:FindFirstChild("Plots: RequestBaseUpgrade"):FireServer(unpack(t13))
                end

                if game:GetService("Players").LocalPlayer.PlayerGui.ScreenStepBoost.BoostButton.Visible == true then
                    game:GetService("Players")

                    for _, v in ipairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.ScreenStepBoost.BoostButton.Activated)) do
                        v:Fire()
                    end
                end

                wait(1)
            end)
        end
    end)
end
v3:AddToggle({
	text = "Auto Rebirth",
	flag = "toggle",
	state = false,
	callback = function(p8)
    _G.Rebirth = p8
    print("Rebirth: ", p8)

    if p8 then
        Rebirth()
    end
end
})
function Rebirth()
    spawn(function()
        _G.Rebirth = true

        while _G.Rebirth do
            wait()
            pcall(function()
                game:GetService("ReplicatedStorage").RebirthRemotes.Request:FireServer("Rebirth")
                wait(2)
            end)
        end
    end)
end
v3:AddLabel({
	text = "https://rscripts.net/@_LSS"
})
v2:Init()
