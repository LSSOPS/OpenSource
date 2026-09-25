local STATE = STATE or {
	onCleanup = function() end,
	connect = function(signal, fn)
		return signal:Connect(fn)
	end,
	namecallHook = function() end,
	alive = function()
		return true
	end,
}

local Alive = true
local Generation = (getgenv().LSSGeneration or 0) + 1
getgenv().LSSGeneration = Generation
local function alive()
	return Alive and STATE.alive() and (getgenv().LSSGeneration or 0) == Generation
end
STATE.onCleanup(function()
	Alive = false
end)

local Repo = "https://raw.githubusercontent.com/joustingmatch/ObsidianUltra/main/"
local LoadOk, Library = pcall(function()
	return loadstring(game:HttpGet(Repo .. "Library.lua"))()
end)
if not LoadOk or type(Library) ~= "table" then
	warn("[LSS] ObsidianUltra failed to load: " .. tostring(Library))
	return
end

local SaveManager
pcall(function()
	SaveManager = loadstring(game:HttpGet(Repo .. "addons/SaveManager.lua"))()
end)

local PreviousLibrary = getgenv().LSSLibrary
if PreviousLibrary and PreviousLibrary ~= Library and PreviousLibrary.Unload then
	pcall(function()
		PreviousLibrary:Unload()
	end)
end
getgenv().LSSLibrary = Library

STATE.onCleanup(function()
	pcall(function()
		Library:Unload()
	end)
	if getgenv().LSSLibrary == Library then
		getgenv().LSSLibrary = nil
	end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 15)
if not Remotes then
	Library:Notify({ Title = "LSS", Description = "Remotes folder not found. Join the game first.", Time = 6, Type = "Error" })
	return
end

local function waitRemote(name, parent)
	local success, instance = pcall(function()
		return (parent or Remotes):WaitForChild(name, 10)
	end)
	if success then
		return instance
	end
	return nil
end

local PlaceEggRequest = waitRemote("PlaceEggRequest")
local DropEggRequest = waitRemote("DropEggRequest")
local SellRemote = waitRemote("Sell")
local CoilsRemote = waitRemote("Coils")
local TrailsRemote = waitRemote("Trails")
local SquatTrainingRequest = waitRemote("SquatTrainingRequest")
local StopSquattingRequest = waitRemote("StopSquattingRequest")
local SquatBonusRequest = waitRemote("SquatBonusRequest")
local OfflineRewardsRemote = waitRemote("OfflineRewards")
local IndexRewardRemote = waitRemote("ClaimAnimalIndexReward")

local Settings = ReplicatedStorage:FindFirstChild("Settings")
local function requireSetting(name)
	local module = Settings and Settings:FindFirstChild(name)
	if not module then
		return nil
	end
	local success, result = pcall(require, module)
	if success then
		return result
	end
	return nil
end

local Rarities = requireSetting("Rarities")
local SpeedUpgrades = requireSetting("SpeedUpgrades")
local TrailSettings = requireSetting("Trails")
local BarbellUpgrades = requireSetting("BarbellUpgrades")
local RecommendedJumps = requireSetting("RecommendedJumps")

local ZoneJumpRequirements = { Meadow = 25 }
if RecommendedJumps and type(RecommendedJumps.List) == "table" then
	for key, value in pairs(RecommendedJumps.List) do
		local zone = string.gsub(tostring(key), "%d+$", "")
		local jump = tonumber(value)
		if jump and (ZoneJumpRequirements[zone] == nil or jump < ZoneJumpRequirements[zone]) then
			ZoneJumpRequirements[zone] = jump
		end
	end
end

local GameName = "Jump for Animals"
local StartedAt = os.clock()

local function getCharacter()
	return LocalPlayer.Character
end

local function getHumanoid()
	local character = getCharacter()
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
	local character = getCharacter()
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function teleportTo(position)
	local root = getRoot()
	if root and position then
		root.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
		return true
	end
	return false
end

local function holderPosition(holder)
	if not holder then
		return nil
	end
	if holder:IsA("BasePart") then
		return holder.Position
	end
	if holder:IsA("Attachment") then
		return holder.WorldPosition
	end
	return nil
end

local function getPlot()
	local plot = LocalPlayer:FindFirstChild("Plot")
	return plot and plot.Value or nil
end

local function getSquatDetector()
	local plot = getPlot()
	local zone = plot and plot:FindFirstChild("SquatZone")
	local floor = zone and zone:FindFirstChild("Floor")
	return floor and floor:FindFirstChild("Detector") or nil
end

local function getPlacementDetector()
	local plot = getPlot()
	return plot and plot:FindFirstChild("Detector", true) or nil
end

local function getCash()
	local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
	local cash = leaderstats and leaderstats:FindFirstChild("Cash")
	local value = cash and cash:FindFirstChild("V")
	return value and tonumber(value.Value) or 0
end

local function getLevel()
	local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
	local level = leaderstats and leaderstats:FindFirstChild("Level")
	local value = level and level:FindFirstChild("V")
	return value and tonumber(value.Value) or 0
end

local function isPetTool(tool)
	return tool:IsA("Tool") and tool:GetAttribute("IsPetInventoryTool") == true
end

local function isEggTool(tool)
	return tool:IsA("Tool") and tool:GetAttribute("IsEggTool") == true
end

local function forEachContainer(fn)
	local character = getCharacter()
	if LocalPlayer.Backpack then
		fn(LocalPlayer.Backpack)
	end
	if character then
		fn(character)
	end
end

local function findTool(predicate)
	local found
	forEachContainer(function(container)
		if found then
			return
		end
		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("Tool") and predicate(child) then
				found = child
				return
			end
		end
	end)
	return found
end

local function countEggTools()
	local count = 0
	forEachContainer(function(container)
		for _, child in ipairs(container:GetChildren()) do
			if isEggTool(child) then
				count += 1
			end
		end
	end)
	return count
end

local function countPlacedEggs()
	local plot = getPlot()
	local placed = plot and plot:FindFirstChild("PlacedEggs")
	return placed and #placed:GetChildren() or 0
end

local function countReadyEggs()
	local plot = getPlot()
	local placed = plot and plot:FindFirstChild("PlacedEggs")
	if not placed then
		return 0
	end
	local ready = 0
	for _, egg in ipairs(placed:GetChildren()) do
		if egg:GetAttribute("HatchReady") == true then
			ready += 1
		end
	end
	return ready
end

local function uniqueAnimalNames()
	local names = {}
	local seen = {}
	forEachContainer(function(container)
		for _, child in ipairs(container:GetChildren()) do
			if isPetTool(child) then
				local name = child:GetAttribute("AnimalName") or child.Name
				if not seen[name] then
					seen[name] = true
					table.insert(names, name)
				end
			end
		end
	end)
	table.sort(names)
	return names
end

local function abbreviate(value)
	value = tonumber(value) or 0
	local units = { "", "K", "M", "B", "T", "Qa", "Qi" }
	local index = 1
	while value >= 1000 and index < #units do
		value /= 1000
		index += 1
	end
	if index == 1 then
		return tostring(math.floor(value))
	end
	return string.format("%.2f%s", value, units[index])
end

local function formatClock(seconds)
	seconds = math.max(math.floor(seconds), 0)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local Window = Library:CreateWindow({
	Title = "@hidevin",
	DisableSearch = true,
	Footer = {
		{ Text = "https://rscripts.net/@_LSS", Copyable = true },
		" | ",
		GameName,
	},
})

Window:SetCornerRadius(10)

if Library.Scheme then
	Library.Scheme.BackgroundColor = Color3.fromHex("0d0d0d")
	Library.Scheme.MainColor = Color3.fromHex("282828")
	Library.Scheme.OutlineColor = Color3.fromHex("3a3a3a")
	Library.Scheme.AccentColor = Color3.fromHex("5865F2")
	Library.Scheme.FontColor = Color3.fromHex("ffffff")
end
pcall(function()
	if Library.SetFont then
		Library:SetFont(Enum.Font.Gotham)
	end
	if Library.UpdateColorsUsingRegistry then
		Library:UpdateColorsUsingRegistry()
	end
end)

local Tabs = {
	Main = Window:AddTab({ Name = "Main", Icon = "home", Description = "Session overview" }),
	Farming = Window:AddTab({ Name = "Farming", Icon = "sprout", Description = "Training, eggs, selling and rewards" }),
	Inventory = Window:AddTab({ Name = "Inventory", Icon = "package", Description = "Shops and upgrades" }),
	Settings = Window:AddTab({ Name = "Settings", Icon = "settings", Description = "Configs and anti-afk" }),
}

local Options = Library.Options
local Toggles = Library.Toggles

local AnimalNames = uniqueAnimalNames()
if #AnimalNames == 0 then
	AnimalNames = { "None" }
end

local RarityNames = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Celestial", "Eternal" }
local ZoneNames = {}
do
	local map = workspace:FindFirstChild("Map")
	local stages = map and map:FindFirstChild("Stages")
	if stages then
		for _, stage in ipairs(stages:GetChildren()) do
			if stage:FindFirstChild("SpawnedEggs") then
				table.insert(ZoneNames, stage.Name)
			end
		end
	end
end
if #ZoneNames == 0 then
	ZoneNames = { "Meadow", "Coral Reef", "Winter", "Desert", "Crystal Mines", "Jungle", "Mystic Isles", "Prehistoric", "Celestial Heights", "Savannah" }
end

local ToggleInfo = function(text, tooltip)
	return { Text = text, Tooltip = tooltip, Default = false }
end

local function notify(title, description, kind)
	Library:Notify({ Title = title, Description = description, Time = 5, Type = kind or "Info" })
end

local MainBox = Tabs.Main:AddLeftGroupbox("Session", "activity")
Tabs.Main:AddPlayerInfo("HomeBanner", {
	Title = "Welcome to the <b>@hidevin</b>",
	Description = {
		GameName .. " | press <b>RightShift</b> to toggle the menu",
		"Farming and Inventory tabs hold every automation toggle.",
	},
	ThumbnailType = "HeadShot",
	Height = 84,
})
MainBox:AddLabel({ Text = "Game: " .. GameName, DoesWrap = true })
local StatusSession = MainBox:AddLabel({ Text = "Session: 00:00:00", DoesWrap = true })
local StatusCash = MainBox:AddLabel({ Text = "Cash: 0", DoesWrap = true })
local StatusLevel = MainBox:AddLabel({ Text = "Level: 0", DoesWrap = true })
local StatusEggs = MainBox:AddLabel({ Text = "Carried eggs: 0 | Placed: 0", DoesWrap = true })
local StatusSquat = MainBox:AddLabel({ Text = "Squatting: false", DoesWrap = true })
local TrainingTab = Tabs.Farming:AddSubTab("Training", "dumbbell")
local EggTab = Tabs.Farming:AddSubTab("Eggs", "egg")
local SellingTab = Tabs.Farming:AddSubTab("Selling", "coins")
local RewardsTab = Tabs.Farming:AddSubTab("Rewards", "gift")
local ShopsTab = Tabs.Inventory:AddSubTab("Shops", "shopping-cart")
local UpgradesTab = Tabs.Inventory:AddSubTab("Upgrades", "trending-up")

local TrainingBox = TrainingTab:AddLeftGroupbox("Squats", "dumbbell")
TrainingBox:AddToggle("AutoTrain", ToggleInfo("Auto Train Squats", "Teleports to your squat pad and trains jump XP forever"))
TrainingBox:AddToggle("AutoSquatBonus", ToggleInfo("Auto Claim Squat Bonus", "Instantly claims the pink squat bonus popup"))
TrainingTab:AddRightGroupbox("Info", "info"):AddLabel("Squatting is server controlled; training pauses while you carry an egg.", true)

local EggBox = EggTab:AddLeftGroupbox("Stealing", "egg")
EggBox:AddToggle("AutoSteal", ToggleInfo("Auto Steal Eggs", "Grabs an egg, returns to base to bank it, then places it"))
EggBox:AddDropdown("StealMode", {
	Text = "Target",
	Values = { "Best Egg", "Nearest Egg", "Highest Rarity" },
	Default = 1,
	Tooltip = "Best Egg = rarest egg your Jump Power can actually reach",
})
EggBox:AddDropdown("StealZones", {
	Text = "Zones",
	Values = ZoneNames,
	Default = 1,
	Multi = true,
	Searchable = true,
	Tooltip = "Only steal eggs from these zones",
})
EggBox:AddDropdown("StealRarities", {
	Text = "Rarities",
	Values = RarityNames,
	Default = 1,
	Multi = true,
	Searchable = true,
	Tooltip = "Only steal eggs of these rarities",
})
local StealDelaySlider = EggBox:AddSlider("StealDelay", {
	Text = "Train Between Steals",
	Default = 5,
	Min = 0,
	Max = 60,
	Rounding = 0,
	Suffix = "s",
	Tooltip = "After each egg is placed, train squats for this long before stealing again",
})

do
	local zoneDefaults = {}
	for _, zone in ipairs(ZoneNames) do
		zoneDefaults[zone] = true
	end
	local rarityDefaults = {}
	for _, rarity in ipairs(RarityNames) do
		rarityDefaults[rarity] = true
	end
	if Options.StealZones then
		Options.StealZones:SetValue(zoneDefaults)
	end
	if Options.StealRarities then
		Options.StealRarities:SetValue(rarityDefaults)
	end
end
local HatchBox = EggTab:AddRightGroupbox("Hatching", "bird")
HatchBox:AddToggle("AutoPlace", ToggleInfo("Auto Place Stolen Eggs", "Places carried eggs on your plot"))
HatchBox:AddToggle("AutoHatch", ToggleInfo("Auto Hatch Ready Eggs", "Opens every egg whose hatch timer finished, never uses Robux skip"))
EggTab:AddRightGroupbox("Info", "info"):AddLabel("Carrying an egg disables jumping. Auto Place moves it to your plot so the loop continues.", true)

local SellBox = SellingTab:AddLeftGroupbox("Selling", "coins")
SellBox:AddToggle("AutoSell", ToggleInfo("Auto Sell Junk Pets", "Equips a pet, walks to the animal seller and sells it"))
SellBox:AddDropdown("SellMode", {
	Text = "Mode",
	Values = { "Lowest CPS First", "Chosen Pet" },
	Default = 1,
})
SellBox:AddDropdown("AutoSellPet", {
	Text = "Chosen Pet",
	Values = AnimalNames,
	Default = 1,
	Searchable = true,
	Tooltip = "Only used when Mode is Chosen Pet",
})
SellBox:AddInput("SellMaxCps", {
	Text = "Max CPS To Sell",
	Default = "1000",
	Placeholder = "1000",
	Numeric = true,
	Tooltip = "Lowest CPS First mode never sells pets above this value",
})
SellingTab:AddRightGroupbox("Info", "info"):AddLabel("Sell value scales with pet CPS. Raise Max CPS only when you really want to sell better pets.", true)

local RewardBox = RewardsTab:AddLeftGroupbox("Claims", "gift")
RewardBox:AddToggle("AutoOffline", ToggleInfo("Auto Claim Offline Cash", "Claims pending offline earnings whenever ready"))
RewardBox:AddToggle("AutoIndex", ToggleInfo("Auto Claim Animal Index Rewards", "Claims every finished Animal Index reward"))
RewardsTab:AddRightGroupbox("Info", "info"):AddLabel("Index rewards are claimed with a single claim-all request. Offline cash is claimed whenever a balance is waiting.", true)

local CoilBox = ShopsTab:AddLeftGroupbox("Coils", "gauge")
CoilBox:AddToggle("AutoBuyCoils", ToggleInfo("Auto Buy Coils", "Buys selected speed coils when affordable"))
CoilBox:AddDropdown("BuyCoilList", {
	Text = "Coils",
	Values = { "Red Coil", "Candy Coil", "Yellow Coil", "Chocolate Coil" },
	Default = 1,
	Multi = true,
	Searchable = true,
})
CoilBox:AddToggle("AutoEquipCoil", ToggleInfo("Auto Equip Best Coil", "Equips the highest tier coil you own"))
local TrailBox = ShopsTab:AddRightGroupbox("Trails", "wind")
TrailBox:AddToggle("AutoBuyTrails", ToggleInfo("Auto Buy Trails", "Buys selected jump trails when affordable"))
TrailBox:AddDropdown("BuyTrailList", {
	Text = "Trails",
	Values = { "Blue Trail", "Red Trail", "Green Trail", "Yellow Trail", "Purple Trail", "White Trail", "Black Trail", "Galaxy Trail", "Crimson Star Trail", "Rainbow Trail" },
	Default = 1,
	Multi = true,
	Searchable = true,
})
TrailBox:AddToggle("AutoEquipTrail", ToggleInfo("Auto Equip Best Trail", "Equips the highest jump multiplier trail you own"))

local UpgradeBox = UpgradesTab:AddLeftGroupbox("Barbell", "dumbbell")
UpgradeBox:AddToggle("AutoBarbell", ToggleInfo("Auto Upgrade Barbell", "Buys the next barbell level whenever you can afford it"))
local MutationBox = UpgradesTab:AddRightGroupbox("Mutation Machine", "flask-conical")
MutationBox:AddToggle("AutoAddMutation", ToggleInfo("Auto Add Pets To Mutation Machine", "Feeds five matching pets into the machine"))
MutationBox:AddDropdown("MutationMode", {
	Text = "Pet Choice",
	Values = { "Auto Select", "Chosen Animal" },
	Default = 1,
})
MutationBox:AddDropdown("MutationAnimal", {
	Text = "Chosen Animal",
	Values = AnimalNames,
	Default = 1,
	Searchable = true,
})
MutationBox:AddToggle("AutoClaimMutation", ToggleInfo("Auto Claim Gold Mutation", "Claims the finished gold pet"))
MutationBox:AddToggle("AutoReturnMutation", ToggleInfo("Auto Return Mutation Pets", "Returns stored pets when the machine allows it"))

local SettingsLeft = Tabs.Settings:AddLeftGroupbox("General", "wrench")
SettingsLeft:AddToggle("AntiAFK", {
	Text = "Anti-AFK",
	Tooltip = "Jumps every 5 minutes so Roblox never kicks you",
	Default = true,
})
SettingsLeft:AddDivider()
SettingsLeft:AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind", {
	Default = "RightShift",
	NoUI = true,
	Text = "Menu keybind",
})
Library.ToggleKeybind = Options.MenuKeybind

if SaveManager then
	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
	SaveManager:SetFolder("LSSHub/JumpForAnimals")
	SaveManager:BuildConfigSection(Tabs.Settings)
	SaveManager:LoadAutoloadConfig()
else
	Tabs.Settings:AddRightGroupbox("Configs", "save")
		:AddLabel("SaveManager addon failed to load. Re-execute the script to retry.", true)
end

local function isSelected(selection, value)
	if type(selection) ~= "table" then
		return true
	end
	local count = 0
	for _ in pairs(selection) do
		count += 1
	end
	if count == 0 then
		return true
	end
	return selection[value] == true
end

local function zoneReachable(zone)
	local required = ZoneJumpRequirements[zone]
	if required == nil then
		return true
	end
	local jumpPower = LocalPlayer:FindFirstChild("JumpPower")
	jumpPower = jumpPower and tonumber(jumpPower.Value) or 0
	return jumpPower >= required
end

local function findEggPrompt(mode)
	local map = workspace:FindFirstChild("Map")
	local stages = map and map:FindFirstChild("Stages")
	if not stages then
		return nil, nil
	end
	local root = getRoot()
	local origin = root and root.Position or Vector3.zero
	local zoneFilter = Options.StealZones and Options.StealZones.Value or nil
	local rarityFilter = Options.StealRarities and Options.StealRarities.Value or nil
	local bestPrompt, bestScore, bestPosition
	for _, stage in ipairs(stages:GetChildren()) do
		local spawned = stage:FindFirstChild("SpawnedEggs")
		if spawned and isSelected(zoneFilter, stage.Name) then
			for _, egg in ipairs(spawned:GetChildren()) do
				local rarity = egg:GetAttribute("Rarity")
				if isSelected(rarityFilter, rarity) then
					local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
					if prompt and prompt.Enabled then
						local worldPosition = holderPosition(prompt.Parent)
						if worldPosition then
							local distance = (worldPosition - origin).Magnitude
							local rarityIndex = 0
							if Rarities and Rarities.GetIndex then
								rarityIndex = Rarities.GetIndex(rarity) or 0
							end
							local score
							if mode == "Nearest Egg" then
								score = -distance
							elseif mode == "Best Egg" then
								if not zoneReachable(stage.Name) then
									continue
								end
								score = rarityIndex * 1000000 - distance * 0.001
							else
								score = rarityIndex * 1000000 - distance * 0.001
							end
							if not bestScore or score > bestScore then
								bestPrompt, bestScore, bestPosition = prompt, score, worldPosition
							end
						end
					end
				end
			end
		end
	end
	return bestPrompt, bestPosition
end

local LastIndexClaim = 0
local LastBarbellAction = 0
local CarryWatchSince = nil
local NextStealAt = 0
local NextPlaceAttempt = 0
local PlaceRotation = 0

local function doCarryRecovery()
	if not Toggles.AutoSteal.Value and not Toggles.AutoPlace.Value then
		CarryWatchSince = nil
		return
	end
	local carried = (tonumber(LocalPlayer:GetAttribute("CarriedEggCount")) or 0) > 0
	local tool = findTool(isEggTool)
	if carried and not tool then
		local base = getPlacementDetector()
		local root = getRoot()
		if base and root and (root.Position - base.Position).Magnitude > 40 then
			teleportTo(base.Position)
			task.wait(0.4)
		end
		if not CarryWatchSince then
			CarryWatchSince = os.clock()
		elseif os.clock() - CarryWatchSince > 30 and DropEggRequest then
			DropEggRequest:FireServer()
			CarryWatchSince = os.clock()
			task.wait(0.5)
		end
	else
		CarryWatchSince = nil
	end
end

local function doAutoTrain()
	if not Toggles.AutoTrain.Value then
		return
	end
	if Toggles.AutoHatch.Value and countReadyEggs() > 0 then
		if LocalPlayer:GetAttribute("IsSquatting") == true and StopSquattingRequest then
			StopSquattingRequest:FireServer()
		end
		return
	end
	if Toggles.AutoSteal.Value and (tonumber(LocalPlayer:GetAttribute("CarriedEggCount")) or 0) > 0 then
		return
	end
	local detector = getSquatDetector()
	local root = getRoot()
	if not detector or not root then
		return
	end
	if (root.Position - detector.Position).Magnitude > 10 then
		teleportTo(detector.Position)
		task.wait(0.3)
	end
	if LocalPlayer:GetAttribute("IsSquatting") ~= true and SquatTrainingRequest then
		SquatTrainingRequest:FireServer(detector)
		task.wait(0.25)
	end
end

local LastBonusClaim = 0
local function doAutoSquatBonus()
	if not Toggles.AutoSquatBonus.Value or not SquatBonusRequest then
		return
	end
	if LocalPlayer:GetAttribute("SquatBonusAvailable") ~= true then
		return
	end
	if os.clock() - LastBonusClaim < 0.4 then
		return
	end
	LastBonusClaim = os.clock()
	local version = math.floor(tonumber(LocalPlayer:GetAttribute("SquatBonusVersion")) or 0)
	SquatBonusRequest:FireServer(version)
end

local function doAutoPlace()
	if not Toggles.AutoPlace.Value or not PlaceEggRequest then
		return
	end
	if os.clock() < NextPlaceAttempt then
		return
	end
	local list = {}
	forEachContainer(function(container)
		for _, child in ipairs(container:GetChildren()) do
			if isEggTool(child) then
				table.insert(list, child)
			end
		end
	end)
	if #list == 0 then
		return
	end
	PlaceRotation += 1
	local carrying = list[(PlaceRotation % #list) + 1]
	local humanoid = getHumanoid()
	local detector = getPlacementDetector()
	if not humanoid or not detector then
		return
	end
	NextPlaceAttempt = os.clock() + 2
	pcall(function()
		humanoid:EquipTool(carrying)
	end)
	task.wait(0.2)
	PlaceEggRequest:FireServer(carrying:GetAttribute("EggId"), detector.Position + Vector3.new(0, 2, 0))
	task.wait(0.35)
	if not carrying.Parent then
		local delay = StealDelaySlider and tonumber(StealDelaySlider.Value) or 5
		NextStealAt = os.clock() + math.max(delay, 0)
	end
end

local function doAutoSteal()
	if not Toggles.AutoSteal.Value then
		return
	end
	if os.clock() < NextStealAt then
		return
	end
	if countEggTools() >= 3 then
		return
	end
	if (tonumber(LocalPlayer:GetAttribute("CarriedEggCount")) or 0) > 0 then
		return
	end
	local prompt, position = findEggPrompt(Options.StealMode.Value)
	if not prompt or not position then
		return
	end
	if LocalPlayer:GetAttribute("IsSquatting") == true and StopSquattingRequest then
		StopSquattingRequest:FireServer()
		local deadline = os.clock() + 1.5
		while LocalPlayer:GetAttribute("IsSquatting") == true and os.clock() < deadline do
			task.wait(0.15)
		end
	end
	teleportTo(position)
	task.wait(0.35)
	if prompt.Enabled then
		fireproximityprompt(prompt)
	end
	task.wait(0.4)
	local base = getPlacementDetector()
	if base then
		teleportTo(base.Position)
		task.wait(0.6)
	end
end

local function doAutoHatch()
	if not Toggles.AutoHatch.Value then
		return
	end
	local plot = getPlot()
	local placed = plot and plot:FindFirstChild("PlacedEggs")
	if not placed then
		return
	end
	for _, egg in ipairs(placed:GetChildren()) do
		if egg:GetAttribute("HatchReady") == true then
			local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
			if prompt and prompt.Enabled then
				local position = holderPosition(prompt.Parent)
				if position then
					teleportTo(position)
					task.wait(0.25)
				end
				fireproximityprompt(prompt)
				task.wait(0.35)
				return
			end
		end
	end
end

local function findSellTarget()
	local mode = Options.SellMode.Value
	local chosen = Options.AutoSellPet.Value
	local maxCps = tonumber(Options.SellMaxCps.Value) or 1000
	local bestTool, bestCps
	forEachContainer(function(container)
		for _, child in ipairs(container:GetChildren()) do
			if isPetTool(child) then
				local name = child:GetAttribute("AnimalName") or child.Name
				local cps = tonumber(child:GetAttribute("CashPerSecond")) or math.huge
				if mode == "Chosen Pet" then
					if name == chosen and (not bestCps or cps < bestCps) then
						bestTool, bestCps = child, cps
					end
				elseif cps <= maxCps and (not bestCps or cps < bestCps) then
					bestTool, bestCps = child, cps
				end
			end
		end
	end)
	return bestTool
end

local function doAutoSell()
	if not Toggles.AutoSell.Value then
		return
	end
	if findTool(isEggTool) then
		return
	end
	local tool = findSellTarget()
	if not tool then
		return
	end
	local humanoid = getHumanoid()
	if not humanoid then
		return
	end
	pcall(function()
		humanoid:EquipTool(tool)
	end)
	local sellRoot = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Sell")
	local detector = sellRoot and sellRoot:FindFirstChild("Detector", true)
	if detector and detector:IsA("BasePart") then
		teleportTo(detector.Position)
		task.wait(0.3)
	end
	local prompt = detector and detector:FindFirstChild("SellAnimalPrompt", true)
	if prompt and prompt.Enabled then
		fireproximityprompt(prompt)
	elseif SellRemote then
		SellRemote:FireServer()
	end
	task.wait(0.4)
end

local function doAutoOffline()
	if not Toggles.AutoOffline.Value or not OfflineRewardsRemote then
		return
	end
	local pending = tonumber(LocalPlayer:GetAttribute("OfflineCashPending")) or 0
	if pending > 0 then
		OfflineRewardsRemote:FireServer("Claim")
		task.wait(0.25)
	end
end

local function doAutoIndex()
	if not Toggles.AutoIndex.Value or not IndexRewardRemote then
		return
	end
	if os.clock() - LastIndexClaim < 15 then
		return
	end
	LastIndexClaim = os.clock()
	IndexRewardRemote:FireServer("__ALL__")
end

local function ownedValue(folder, name)
	local entry = folder and folder:FindFirstChild(name)
	return entry and entry.Value == true
end

local function doAutoCoils()
	local coilData = LocalPlayer:FindFirstChild("CoilData")
	if not coilData or not CoilsRemote then
		return
	end
	local owned = coilData:FindFirstChild("Owned")
	local equipped = coilData:FindFirstChild("Equipped")
	if Toggles.AutoBuyCoils.Value and SpeedUpgrades then
		local selected = Options.BuyCoilList.Value
		if type(selected) == "table" then
			for name in pairs(selected) do
				local config = SpeedUpgrades.Get(name)
				if config and not ownedValue(owned, name) and getCash() >= config.Cost then
					CoilsRemote:FireServer("Select", name)
					task.wait(0.25)
				end
			end
		end
	end
	if Toggles.AutoEquipCoil.Value and SpeedUpgrades and equipped then
		local bestName, bestOrder = nil, -1
		if owned then
			for _, entry in ipairs(owned:GetChildren()) do
				if entry.Value == true then
					local config = SpeedUpgrades.Get(entry.Name)
					local order = config and config.Order or 0
					if order > bestOrder then
						bestName, bestOrder = entry.Name, order
					end
				end
			end
		end
		if bestName and equipped.Value ~= bestName then
			CoilsRemote:FireServer("Select", bestName)
			task.wait(0.2)
		end
	end
end

local function doAutoTrails()
	local trailData = LocalPlayer:FindFirstChild("TrailData")
	if not trailData or not TrailsRemote then
		return
	end
	local owned = trailData:FindFirstChild("Owned")
	local equipped = trailData:FindFirstChild("Equipped")
	if Toggles.AutoBuyTrails.Value and TrailSettings then
		local selected = Options.BuyTrailList.Value
		if type(selected) == "table" then
			for name in pairs(selected) do
				local config = TrailSettings.Get(name)
				if config and not ownedValue(owned, name) and getCash() >= config.Cost then
					TrailsRemote:FireServer("Select", name)
					task.wait(0.25)
				end
			end
		end
	end
	if Toggles.AutoEquipTrail.Value and TrailSettings and equipped then
		local bestName, bestOrder = nil, -1
		if owned then
			for _, entry in ipairs(owned:GetChildren()) do
				if entry.Value == true then
					local config = TrailSettings.Get(entry.Name)
					local order = config and config.Order or 0
					if order > bestOrder then
						bestName, bestOrder = entry.Name, order
					end
				end
			end
		end
		if bestName and equipped.Value ~= bestName then
			TrailsRemote:FireServer("Select", bestName)
			task.wait(0.2)
		end
	end
end

local function doAutoBarbell()
	if not Toggles.AutoBarbell.Value or not BarbellUpgrades or not BarbellUpgrades.GetNext then
		return
	end
	if os.clock() - LastBarbellAction < 3 then
		return
	end
	LastBarbellAction = os.clock()
	local level = LocalPlayer:FindFirstChild("BarbellLevel")
	if not level then
		return
	end
	local nextUpgrade = BarbellUpgrades.GetNext(math.max(math.floor(tonumber(level.Value) or 1), 1))
	if not nextUpgrade then
		return
	end
	local price = tonumber(nextUpgrade.CashPrice) or 0
	if getCash() < price then
		return
	end
	local plot = getPlot()
	local zone = plot and plot:FindFirstChild("SquatZone")
	local upgradeB = zone and zone:FindFirstChild("UpgradeB")
	local prompt = upgradeB and upgradeB:FindFirstChild("BarbellUpgradePrompt", true)
	if not prompt or not prompt.Enabled then
		return
	end
	local position = holderPosition(prompt.Parent)
	if position then
		teleportTo(position)
		task.wait(0.25)
	end
	fireproximityprompt(prompt)
	task.wait(0.4)
end

local function findMutationPet(targetName)
	local candidate, candidateCps
	forEachContainer(function(container)
		for _, child in ipairs(container:GetChildren()) do
			if isPetTool(child) then
				local name = child:GetAttribute("AnimalName") or child.Name
				local cps = tonumber(child:GetAttribute("CashPerSecond")) or math.huge
				if name == targetName and (not candidateCps or cps < candidateCps) then
					candidate, candidateCps = child, cps
				end
			end
		end
	end)
	return candidate
end

local function findDuplicateAnimal()
	local counts, lowest = {}, {}
	forEachContainer(function(container)
		for _, child in ipairs(container:GetChildren()) do
			if isPetTool(child) then
				local name = child:GetAttribute("AnimalName") or child.Name
				local cps = tonumber(child:GetAttribute("CashPerSecond")) or math.huge
				counts[name] = (counts[name] or 0) + 1
				if not lowest[name] or cps < lowest[name] then
					lowest[name] = cps
				end
			end
		end
	end)
	local bestName, bestCps
	for name, count in pairs(counts) do
		if count >= 2 and (not bestCps or lowest[name] < bestCps) then
			bestName, bestCps = name, lowest[name]
		end
	end
	return bestName
end

local function mutationPromptByName(name)
	local map = workspace:FindFirstChild("Map")
	local mutations = map and map:FindFirstChild("Mutations")
	local detector = mutations and mutations:FindFirstChild("Detector")
	local prompt = detector and detector:FindFirstChild(name, true)
	return prompt, detector
end

local function fireMutation(name, detector)
	local prompt = detector and detector:FindFirstChild(name, true)
	if not prompt or not prompt.Enabled then
		return false
	end
	local position = holderPosition(prompt.Parent)
	if position then
		teleportTo(position)
		task.wait(0.2)
	end
	fireproximityprompt(prompt)
	task.wait(0.35)
	return true
end

local function doAutoMutation()
	local active = LocalPlayer:GetAttribute("MutationCraftActive") == true
	local ready = LocalPlayer:GetAttribute("MutationCraftReady") == true
	local canRemove = LocalPlayer:GetAttribute("MutationCanRemove") == true
	local _, detector = mutationPromptByName("MutationPrompt")
	if Toggles.AutoClaimMutation.Value and active and ready then
		fireMutation("MutationPrompt", detector)
		return
	end
	if Toggles.AutoReturnMutation.Value and active and canRemove then
		fireMutation("MutationRemovePrompt", detector)
		return
	end
	if not Toggles.AutoAddMutation.Value or active then
		return
	end
	local target = LocalPlayer:GetAttribute("MutationCraftAnimalName")
	if type(target) ~= "string" or target == "" then
		if Options.MutationMode.Value == "Chosen Animal" then
			target = Options.MutationAnimal.Value
		else
			target = findDuplicateAnimal()
		end
	end
	if not target or target == "None" then
		return
	end
	local tool = findMutationPet(target)
	if not tool then
		return
	end
	local humanoid = getHumanoid()
	if not humanoid then
		return
	end
	pcall(function()
		humanoid:EquipTool(tool)
	end)
	task.wait(0.2)
	fireMutation("MutationPrompt", detector)
end

if Toggles.AutoTrain and Toggles.AutoTrain.OnChanged then
	Toggles.AutoTrain:OnChanged(function(value)
		if value == false and LocalPlayer:GetAttribute("IsSquatting") == true and StopSquattingRequest then
			StopSquattingRequest:FireServer()
		end
	end)
end

local function featureLoop(fn)
	task.spawn(function()
		while alive() do
			local success, err = pcall(fn)
			if not success and alive() then
				warn("[LSS] " .. tostring(err))
			end
			task.wait(0.5)
		end
	end)
end

featureLoop(function()
	doCarryRecovery()
	doAutoPlace()
	doAutoSteal()
	doAutoSell()
	doAutoTrain()
	doAutoSquatBonus()
	doAutoHatch()
	doAutoBarbell()
end)

featureLoop(function()
	doAutoOffline()
	doAutoIndex()
	doAutoCoils()
	doAutoTrails()
end)

task.spawn(function()
	while alive() do
		local success, err = pcall(doAutoMutation)
		if not success and alive() then
			warn("[LSS] " .. tostring(err))
		end
		task.wait(6)
	end
end)

task.spawn(function()
	while alive() do
		task.wait(300)
		if alive() and Toggles.AntiAFK.Value then
			pcall(function()
				local humanoid = getHumanoid()
				if humanoid then
					humanoid.Jump = true
				end
				local virtualUser = game:GetService("VirtualUser")
				virtualUser:CaptureController()
				virtualUser:ClickButton2(Vector2.new())
			end)
		end
	end
end)

task.spawn(function()
	while alive() do
		pcall(function()
			StatusSession:SetText("Session: " .. formatClock(os.clock() - StartedAt))
			StatusCash:SetText("Cash: " .. abbreviate(getCash()))
			StatusLevel:SetText("Level: " .. tostring(getLevel()))
			StatusEggs:SetText(string.format("Carried eggs: %d | Placed: %d", countEggTools(), countPlacedEggs()))
			StatusSquat:SetText("Squatting: " .. tostring(LocalPlayer:GetAttribute("IsSquatting") == true))
		end)
		task.wait(1)
	end
end)

notify("LSS", "Loaded for " .. GameName .. ". RightShift toggles the menu.")
