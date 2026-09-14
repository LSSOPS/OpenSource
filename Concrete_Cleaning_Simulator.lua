if game.PlaceId ~= 99397872893294 and game.GameId ~= 99397872893294 then return end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
Name = "Concrete Cleaning Simulator - v1.3.3",
LoadingTitle = "Concrete Cleaning Simulator",
LoadingSubtitle = "made by LSS",
ConfigurationSaving = { Enabled = false },
Discord = { Enabled = false },
KeySystem = false
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Unloaded = false
local UIRefs = {}
local ScriptConnections = {}

local RemotesPath = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Remotes")
local JobRemotes = RemotesPath:WaitForChild("JobSystemRemotes")
local CleaningIndex = RemotesPath:WaitForChild("CleaningIndexRemotes")
local CleanReward = RemotesPath:WaitForChild("CleanVoxelReward")
local CleaningShopRemotes = RemotesPath:WaitForChild("CleaningShopRemotes")
local CompanyRemotes = RemotesPath:WaitForChild("CompanyRemotes")
local PetsRemotes = RemotesPath:WaitForChild("PetsRemotes")

local Unlock = CleaningIndex:WaitForChild("Unlock")
local PlayTogether = JobRemotes:WaitForChild("PlayTogether")
local CleaningSync = JobRemotes:WaitForChild("CleaningSync")
local CompleteJob = JobRemotes:WaitForChild("CompleteJob")
local StartJob = JobRemotes:WaitForChild("StartJob")
local PurchaseTool = CleaningShopRemotes:WaitForChild("PurchaseTool")
local UpgradeTool = CleaningShopRemotes:WaitForChild("UpgradeTool")
local HireWorker = CompanyRemotes:WaitForChild("HireWorker")
local UpgradeCompanyRemote = CompanyRemotes:WaitForChild("UpgradeCompany")
local UpgradeWorkerRemote = CompanyRemotes:WaitForChild("UpgradeWorker")
local UpgradeSkillRequest = RemotesPath:WaitForChild("SkillsSystem"):WaitForChild("UpgradeSkillRequest")
local BuyEgg = PetsRemotes:WaitForChild("BuyEgg")

local SelectedJobID = 1
local SelectedEvent = "TimeLimit"
local SelectedTools = {}
local SelectedWorkers = {}
local SelectedSkills = {}
local SelectedUpgradeTools = {}
local SelectedUpgradeCompany = {}
local SelectedUpgradeWorkers = {}
local SelectedEgg = "Common Egg"
local SelectedEggAmount = 1

_G.AutoCleanActive = false
_G.AutoRebirthActive = false
_G.AutoClaimBonusChest = false
_G.AutoClaimRewards = false
_G.AutoInviteActive = false
_G.AutoOpenEggs = false
_G.AutoBuyToolsActive = false
_G.AutoBuyWorkersActive = false

_G.JobDelay = 8
_G.UpgradeDelay = 1.5
_G.EggDelay = 1.5
_G.BuyToolsDelay = 1.5
_G.BuyWorkersDelay = 1.5

local ToastConnection = nil

local JobsInfo = {
["Driveway"] = {ID = 1, Event = "TimeLimit"},
["Garage"] = {ID = 2, Event = "TimeLimit"},
["Fire Station (1.5x BOOST)"] = {ID = 3, Event = "PerfectClean"},
["Bus Station (2x BOOST)"] = {ID = 4, Event = "MoodMeter"},
["Hangar (2.5x BOOST)"] = {ID = 5, Event = "BonusCash"},
["Parking Lot (3x BOOST)"] = {ID = 6, Event = "HighScore"}
}

local WorkersInfo = {
["Lazy Guy"] = 1, ["Rookie Washer"] = 2, ["Soap Specialist"] = 3,
["Stain Hunter"] = 4, ["Boss Cleaner"] = 5, ["Elite Crew Lead"] = 6, ["Prismatic Pro"] = 7
}

local WalkSpeedEnabled = false
local WalkSpeedValue = 16
local InfJumpEnabled = false
local NoclipEnabled = false
local AntiStaffEnabled = true
local TargetPlayerCount = 3
local AntiStaffConnection = nil
local STAFF_USER_IDS = {1717315, 86711237, 1213033388, 10821577736, 3174908799, 3682736730}

local function isStaff(userId)
for index, id in ipairs(STAFF_USER_IDS) do
if id == userId then return true end
end
return false
end

local function HopToRandomServer()
local endpoints = {
"https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100",
"https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
}
local decodedData = nil
for index, url in ipairs(endpoints) do
local success, response = pcall(function() return game:HttpGet(url) end)
if success and response then
local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response) end)
if decodeSuccess and data and data.data then
decodedData = data
break
end
end
end
if decodedData and decodedData.data then
local validServers = {}
for index, v in ipairs(decodedData.data) do
if type(v) == "table" and v.id ~= game.JobId then table.insert(validServers, v.id) end
end
if #validServers > 0 then
TeleportService:TeleportToPlaceInstance(game.PlaceId, validServers[math.random(1, #validServers)])
end
end
end

local function HopToServer(targetAmount)
local endpoints = {
"https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100",
"https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
}
local decodedData = nil
for index, url in ipairs(endpoints) do
local success, response = pcall(function() return game:HttpGet(url) end)
if success and response then
local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response) end)
if decodeSuccess and data and data.data then
decodedData = data
break
end
end
end
if decodedData and decodedData.data then
local validServers = {}
for index, v in ipairs(decodedData.data) do
if type(v) == "table" and v.playing == targetAmount and v.id ~= game.JobId then table.insert(validServers, v.id) end
end
if #validServers > 0 then
Rayfield:Notify({ Title = "Server Hop", Content = "Teleporting...", Duration = 3, Image = 4483362458 })
TeleportService:TeleportToPlaceInstance(game.PlaceId, validServers[math.random(1, #validServers)])
else
Rayfield:Notify({ Title = "Server Hop", Content = "No server found with " .. targetAmount .. " players.", Duration = 4, Image = 4483362458 })
end
else
Rayfield:Notify({ Title = "Server Hop", Content = "Failed to fetch servers.", Duration = 4, Image = 4483362458 })
end
end

local function CheckAndHopFromStaff()
for index, p in ipairs(Players:GetPlayers()) do
if isStaff(p.UserId) then
Rayfield:Notify({ Title = "Anti Staff", Content = "Staff detected! Hopping to random server...", Duration = 3, Image = 4483362458 })
task.wait(0.3)
HopToRandomServer()
return true
end
end
return false
end

local function UnloadScript()
Unloaded = true
_G.AutoCleanActive = false
_G.AutoRebirthActive = false
_G.AutoClaimBonusChest = false
_G.AutoClaimRewards = false
_G.AutoInviteActive = false
_G.AutoOpenEggs = false
_G.AutoBuyToolsActive = false
_G.AutoBuyWorkersActive = false

WalkSpeedEnabled = false
InfJumpEnabled = false
NoclipEnabled = false
AntiStaffEnabled = false

if _G.AntiAfkConn then _G.AntiAfkConn:Disconnect(); _G.AntiAfkConn = nil end
if AntiStaffConnection then AntiStaffConnection:Disconnect(); AntiStaffConnection = nil end
if ToastConnection then ToastConnection:Disconnect(); ToastConnection = nil end
for index, conn in ipairs(ScriptConnections) do
if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
end
table.clear(ScriptConnections)
pcall(function()
if LocalPlayer.Character then
local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
if hum then hum.WalkSpeed = 16 end
for index, partName in ipairs({"Torso", "UpperTorso", "LowerTorso", "Head", "HumanoidRootPart"}) do
local part = LocalPlayer.Character:FindFirstChild(partName)
if part and part:IsA("BasePart") then part.CanCollide = true end
end
end
end)
Rayfield:Destroy()
end

local MainTab = Window:CreateTab("Main", "home")
local UpgradesTab = Window:CreateTab("Upgrades", "chevrons-up")
local PetsTab = Window:CreateTab("Pets", "paw-print")
local SettingTab = Window:CreateTab("Setting", "sliders")
local StatsTab = Window:CreateTab("Stats", "bar-chart-2")
local CharacterTab = Window:CreateTab("Character", "user")
local ConfigTab = Window:CreateTab("Config", "settings")

MainTab:CreateSection("Jobs Manager")

UIRefs.JobDropdown = MainTab:CreateDropdown({
Name = "Select Job To Wash", Options = {"Driveway", "Garage", "Fire Station (1.5x BOOST)", "Bus Station (2x BOOST)", "Hangar (2.5x BOOST)", "Parking Lot (3x BOOST)"},
CurrentOption = {"Driveway"}, MultipleOptions = false, Flag = "JobDropdown",
Callback = function(Options)
local selected = Options[1]
if JobsInfo[selected] then
SelectedJobID = JobsInfo[selected].ID
SelectedEvent = JobsInfo[selected].Event
if _G.AutoCleanActive then pcall(function() StartJob:FireServer(SelectedJobID) end) end
end
end,
})

MainTab:CreateLabel("Note: Make sure to buy all tools in the shop to unlock other areas.")

UIRefs.AutoJobToggle = MainTab:CreateToggle({
Name = "Auto Complete Jobs", CurrentValue = false, Flag = "AutoJobToggle",
Callback = function(Value)
_G.AutoCleanActive = Value
if Value then
task.spawn(function()
while _G.AutoCleanActive and not Unloaded do
pcall(function()
Unlock:FireServer("Events", SelectedEvent)
StartJob:FireServer(SelectedJobID)
PlayTogether:FireServer(SelectedJobID)
CleaningSync:FireServer(SelectedJobID)
CompleteJob:FireServer(SelectedJobID)
CleanReward:FireServer(SelectedJobID)
end)
task.wait(_G.JobDelay)
end
end)
end
end,
})

MainTab:CreateSection("Auto Buy Manager")

UIRefs.ShopDropdown = MainTab:CreateDropdown({
Name = "Select Tools To Buy", Options = {"All", "SoapRinser", "WaterVacuum", "Brush", "MagicBroom"},
CurrentOption = {}, MultipleOptions = true, Flag = "ShopDropdown",
Callback = function(Options)
if table.find(Options, "All") and #Options > 1 then
UIRefs.ShopDropdown:Set({"All"})
SelectedTools = {"All"}
else
SelectedTools = Options
end
end,
})

UIRefs.EnableAutoBuyToolsToggle = MainTab:CreateToggle({
Name = "Enable Auto Buy Tools", CurrentValue = false, Flag = "EnableAutoBuyToolsToggle",
Callback = function(Value) _G.AutoBuyToolsActive = Value end,
})

UIRefs.WorkerDropdown = MainTab:CreateDropdown({
Name = "Select Workers To Buy", Options = {"All", "Lazy Guy", "Rookie Washer", "Soap Specialist", "Stain Hunter", "Boss Cleaner", "Elite Crew Lead", "Prismatic Pro"},
CurrentOption = {}, MultipleOptions = true, Flag = "WorkerDropdown",
Callback = function(Options)
if table.find(Options, "All") and #Options > 1 then
UIRefs.WorkerDropdown:Set({"All"})
SelectedWorkers = {"All"}
else
SelectedWorkers = Options
end
end
})

UIRefs.EnableAutoBuyWorkersToggle = MainTab:CreateToggle({
Name = "Enable Auto Buy Workers", CurrentValue = false, Flag = "EnableAutoBuyWorkersToggle",
Callback = function(Value) _G.AutoBuyWorkersActive = Value end,
})

MainTab:CreateSection("Other Automation")

UIRefs.AutoRebirthToggle = MainTab:CreateToggle({
Name = "Auto Rebirth", CurrentValue = false, Flag = "AutoRebirthToggle",
Callback = function(Value)
_G.AutoRebirthActive = Value
if Value then
task.spawn(function()
while _G.AutoRebirthActive and not Unloaded do
pcall(function() RemotesPath:WaitForChild("RebirthSystem"):WaitForChild("RebirthRequest"):InvokeServer() end)
task.wait(5)
end
end)
end
end,
})

UIRefs.AutoClaimBonusChestToggle = MainTab:CreateToggle({
Name = "Auto Claim Bonus Chest", CurrentValue = false, Flag = "AutoClaimBonusChestToggle",
Callback = function(Value)
_G.AutoClaimBonusChest = Value
if Value then
task.spawn(function()
while _G.AutoClaimBonusChest and not Unloaded do
pcall(function()
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
if PlayerGui then
local chestHUD = PlayerGui:FindFirstChild("ChestGoalHUD")
if chestHUD then
local root = chestHUD:FindFirstChild("Root")
local main = root and root:FindFirstChild("Main")
if main then
local barBack = main:FindFirstChild("BarBack")
local percentLabel = barBack and barBack:FindFirstChild("Percent")
if percentLabel and percentLabel.Text == "100%" then
local chestImage = main:FindFirstChild("ChestImage")
if chestImage then
if firesignal then
pcall(function() firesignal(chestImage.MouseButton1Click) end)
pcall(function() firesignal(chestImage.Activated) end)
end
pcall(function() if chestImage:IsA("GuiButton") then chestImage:Activate() end end)
local openText = chestImage:FindFirstChild("OpenText")
if openText then
if firesignal then
pcall(function() firesignal(openText.MouseButton1Click) end)
pcall(function() firesignal(openText.Activated) end)
end
pcall(function() if openText:IsA("GuiButton") then openText:Activate() end end)
end
end
end
end
end
end
end)
task.wait(2)
end
end)
end
end,
})

UIRefs.AutoClaimRewardsToggle = MainTab:CreateToggle({
Name = "Auto Claim Daily & Timer Rewards", CurrentValue = false, Flag = "AutoClaimRewardsToggle",
Callback = function(Value)
_G.AutoClaimRewards = Value
if Value then
pcall(function()
local function RemoveToast()
pcall(function()
local gui = LocalPlayer.PlayerGui:WaitForChild("CleaningMenus"):FindFirstChild("TimerRewardsToast")
if gui then gui:Destroy() end
end)
end
RemoveToast()
if not ToastConnection then
ToastConnection = LocalPlayer.PlayerGui:WaitForChild("CleaningMenus").ChildAdded:Connect(function(child)
if _G.AutoClaimRewards and child.Name == "TimerRewardsToast" then child:Destroy() end
end)
end
end)

task.spawn(function()
while _G.AutoClaimRewards and not Unloaded do
pcall(function()
local dailyRemote = RemotesPath:WaitForChild("DailyRewardsRemote", 2)
if dailyRemote then dailyRemote:InvokeServer("Claim") end
end)
task.wait(2)
pcall(function()
local timerRemote = RemotesPath:WaitForChild("TimerRewardsRemotes", 2):WaitForChild("TimerRewards", 2)
if timerRemote then
timerRemote:FireServer("RequestState")
task.wait(0.5)
timerRemote:FireServer("ClaimNext")
end
end)
task.wait(20)
end
end)
else
if ToastConnection then ToastConnection:Disconnect(); ToastConnection = nil end
end
end,
})

UIRefs.AutoInviteToggle = MainTab:CreateToggle({
Name = "Auto Invite Play Together", CurrentValue = false, Flag = "AutoInviteToggle",
Callback = function(Value)
_G.AutoInviteActive = Value
if Value then
task.spawn(function()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
while _G.AutoInviteActive and not Unloaded do
pcall(function()
local CleaningMenus = PlayerGui:FindFirstChild("CleaningMenus")
local PlayTogetherFrame = CleaningMenus and CleaningMenus:FindFirstChild("PlayTogetherFrame")
local PlayerList = PlayTogetherFrame and PlayTogetherFrame:FindFirstChild("PlayerList")
if PlayerList then
for index, child in ipairs(PlayerList:GetChildren()) do
if child.Name:sub(1, 7) == "Player" then
local inviteBtn = child:FindFirstChild("Invite")
if inviteBtn then
if firesignal then
firesignal(inviteBtn.MouseButton1Click)
firesignal(inviteBtn.Activated)
elseif inviteBtn:IsA("TextButton") or inviteBtn:IsA("ImageButton") then
inviteBtn:Activate()
end
end
end
end
end
end)
task.wait(5)
end
end)
end
end,
})

UpgradesTab:CreateSection("Upgrades Manager")

UIRefs.SkillsDropdown = UpgradesTab:CreateDropdown({
Name = "Auto Upgrade Skills", Options = {"All", "Radius Master", "Double Clean", "Speed", "Cash Boost", "EXP Hoard", "Seal Coating Expert", "Hard Stain"},
CurrentOption = {}, MultipleOptions = true, Flag = "SkillsDropdown",
Callback = function(Options)
if table.find(Options, "All") and #Options > 1 then
UIRefs.SkillsDropdown:Set({"All"})
SelectedSkills = {"All"}
else SelectedSkills = Options end
end
})

UIRefs.UpgradeToolsDropdown = UpgradesTab:CreateDropdown({
Name = "Auto Upgrade Tools", Options = {"All", "PressureWasher", "SoapRinser", "WaterVacuum", "Brush", "MagicBroom"},
CurrentOption = {}, MultipleOptions = true, Flag = "UpgradeToolsDropdown",
Callback = function(Options)
if table.find(Options, "All") and #Options > 1 then
UIRefs.UpgradeToolsDropdown:Set({"All"})
SelectedUpgradeTools = {"All"}
else SelectedUpgradeTools = Options end
end
})

UIRefs.UpgradeCompanyDropdown = UpgradesTab:CreateDropdown({
Name = "Auto Upgrade Company", Options = {"Company"},
CurrentOption = {}, MultipleOptions = true, Flag = "UpgradeCompanyDropdown",
Callback = function(Options) SelectedUpgradeCompany = Options end
})

UIRefs.UpgradeWorkersDropdown = UpgradesTab:CreateDropdown({
Name = "Auto Upgrade Workers", Options = {"All", "Lazy Guy", "Rookie Washer", "Soap Specialist", "Stain Hunter", "Boss Cleaner", "Elite Crew Lead", "Prismatic Pro"},
CurrentOption = {}, MultipleOptions = true, Flag = "UpgradeWorkersDropdown",
Callback = function(Options)
if table.find(Options, "All") and #Options > 1 then
UIRefs.UpgradeWorkersDropdown:Set({"All"})
SelectedUpgradeWorkers = {"All"}
else SelectedUpgradeWorkers = Options end
end
})

PetsTab:CreateSection("Eggs Manager")

UIRefs.SelectEggDropdown = PetsTab:CreateDropdown({
Name = "Select Eggs To Open", Options = {"Common Egg", "Uncommon Egg", "Rare Egg", "Epic Egg", "Legendary Egg", "Mythical Egg", "Celestial Egg", "Prismatic Egg"},
CurrentOption = {"Common Egg"}, MultipleOptions = false, Flag = "SelectEggDropdown",
Callback = function(Options) SelectedEgg = Options[1] end,
})

UIRefs.SelectEggAmountDropdown = PetsTab:CreateDropdown({
Name = "Select Open Amount", Options = {"x1", "x3", "x10"},
CurrentOption = {"x1"}, MultipleOptions = false, Flag = "SelectEggAmountDropdown",
Callback = function(Options)
if Options[1] == "x1" then SelectedEggAmount = 1
elseif Options[1] == "x3" then SelectedEggAmount = 3
elseif Options[1] == "x10" then SelectedEggAmount = 10 end
end,
})

UIRefs.AutoOpenEggsToggle = PetsTab:CreateToggle({
Name = "Auto Open Eggs", CurrentValue = false, Flag = "AutoOpenEggsToggle",
Callback = function(Value)
_G.AutoOpenEggs = Value
if Value then
task.spawn(function()
while _G.AutoOpenEggs and not Unloaded do
pcall(function() BuyEgg:InvokeServer(SelectedEgg, SelectedEggAmount) end)
task.wait(_G.EggDelay)
end
end)
end
end,
})

SettingTab:CreateSection("Reset")

SettingTab:CreateButton({
Name = "Reset All Delays to Default",
Callback = function()
if UIRefs.JobDelaySlider then UIRefs.JobDelaySlider:Set(8) end
if UIRefs.UpgradeDelaySlider then UIRefs.UpgradeDelaySlider:Set(1.5) end
if UIRefs.EggDelaySlider then UIRefs.EggDelaySlider:Set(1.5) end
if UIRefs.BuyToolsDelaySlider then UIRefs.BuyToolsDelaySlider:Set(1.5) end
if UIRefs.BuyWorkersDelaySlider then UIRefs.BuyWorkersDelaySlider:Set(1.5) end
end,
})

SettingTab:CreateSection("Delay Adjustments (Default)")

UIRefs.JobDelaySlider = SettingTab:CreateSlider({
Name = "Job Farming Delay", Range = {5, 15}, Increment = 1, Suffix = "s", CurrentValue = 8, Flag = "JobDelaySlider",
Callback = function(Value) _G.JobDelay = Value end,
})

SettingTab:CreateLabel("Warning: Setting this too low can easily cause errors affecting farming.")

UIRefs.UpgradeDelaySlider = SettingTab:CreateSlider({
Name = "Upgrades Delay", Range = {0.2, 5}, Increment = 0.1, Suffix = "s", CurrentValue = 1.5, Flag = "UpgradeDelaySlider",
Callback = function(Value) _G.UpgradeDelay = Value end,
})

UIRefs.EggDelaySlider = SettingTab:CreateSlider({
Name = "Eggs Open Delay", Range = {0.2, 5}, Increment = 0.1, Suffix = "s", CurrentValue = 1.5, Flag = "EggDelaySlider",
Callback = function(Value) _G.EggDelay = Value end,
})

UIRefs.BuyToolsDelaySlider = SettingTab:CreateSlider({
Name = "Buy Tools Delay", Range = {0.2, 5}, Increment = 0.1, Suffix = "s", CurrentValue = 1.5, Flag = "BuyToolsDelaySlider",
Callback = function(Value) _G.BuyToolsDelay = Value end,
})

UIRefs.BuyWorkersDelaySlider = SettingTab:CreateSlider({
Name = "Buy Workers Delay", Range = {0.2, 5}, Increment = 0.1, Suffix = "s", CurrentValue = 1.5, Flag = "BuyWorkersDelaySlider",
Callback = function(Value) _G.BuyWorkersDelay = Value end,
})

StatsTab:CreateSection("Live Player Statistics")

local trackedStats = {}
local trackedInstances = {}
local StatsParagraph = StatsTab:CreateParagraph({Title = LocalPlayer.DisplayName .. " Data", Content = "Loading..."})

local blacklist = {
["AvatarPartScaleType"] = true, ["BoundKeys"] = true, ["HumanoidRootPart"] = true,
["Head"] = true, ["Humanoid"] = true, ["Camera"] = true, ["Animator"] = true,
["Animate"] = true, ["Part.c082"] = true, ["Classic"] = true
}
local targetTypes = {IntValue = true, NumberValue = true, BoolValue = true, StringValue = true}

local function updateStatsDisplay()
local sortedNames = {}
for name, val in pairs(trackedStats) do table.insert(sortedNames, name) end
table.sort(sortedNames)
local lines = {}
for index, name in ipairs(sortedNames) do
table.insert(lines, "- " .. tostring(name) .. " : " .. tostring(trackedStats[name]))
end
local content = table.concat(lines, "\n")
if content == "" then content = "No stats found yet..." end
StatsParagraph:Set({Title = LocalPlayer.DisplayName .. " Data", Content = content})
end

local function setupStatTracking(obj)
if targetTypes[obj.ClassName] and not blacklist[obj.Name] and not trackedInstances[obj] then
if string.find(obj.Name, "Part%.c") then return end
trackedInstances[obj] = true
trackedStats[obj.Name] = obj.Value
table.insert(ScriptConnections, obj.Changed:Connect(function(newValue)
trackedStats[obj.Name] = newValue
end))
end
end

for index, obj in ipairs(LocalPlayer:GetDescendants()) do setupStatTracking(obj) end
table.insert(ScriptConnections, LocalPlayer.DescendantAdded:Connect(function(obj) setupStatTracking(obj) end))

task.spawn(function()
while not Unloaded do
pcall(updateStatsDisplay)
task.wait(3)
end
end)

CharacterTab:CreateSection("Movement")

UIRefs.EnableWalkSpeed = CharacterTab:CreateToggle({
Name = "Enable WalkSpeed", CurrentValue = false, Flag = "EnableWalkSpeed",
Callback = function(Value)
WalkSpeedEnabled = Value
if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.WalkSpeed = 16
end
end,
})

UIRefs.WalkSpeedSlider = CharacterTab:CreateSlider({
Name = "WalkSpeed Amount", Range = {16, 100}, Increment = 1, CurrentValue = 16, Flag = "WalkSpeedSlider",
Callback = function(Value) WalkSpeedValue = Value end,
})

local function EnableDefaultJump(char)
if not char then return end
local hum = char:WaitForChild("Humanoid", 3)
if hum then
hum.UseJumpPower = true
hum.JumpPower = 50
hum.JumpHeight = 7.2
hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
end
end

UIRefs.InfJumpToggle = CharacterTab:CreateToggle({
Name = "Enable Jump + INF Jump", CurrentValue = false, Flag = "InfJumpToggle",
Callback = function(Value)
InfJumpEnabled = Value
if Value and LocalPlayer.Character then
EnableDefaultJump(LocalPlayer.Character)
end
end
})

table.insert(ScriptConnections, LocalPlayer.CharacterAdded:Connect(function(char)
if InfJumpEnabled then
EnableDefaultJump(char)
end
end))

table.insert(ScriptConnections, UserInputService.JumpRequest:Connect(function()
if InfJumpEnabled and LocalPlayer.Character then
local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end
end))

UIRefs.NoclipToggle = CharacterTab:CreateToggle({
Name = "Noclip", CurrentValue = false, Flag = "NoclipToggle",
Callback = function(Value)
NoclipEnabled = Value
if not Value and LocalPlayer.Character then
for index, partName in ipairs({"Torso", "UpperTorso", "LowerTorso", "Head", "HumanoidRootPart"}) do
local part = LocalPlayer.Character:FindFirstChild(partName)
if part then part.CanCollide = true end
end
end
end,
})

CharacterTab:CreateSection("Protect yourself")

local function SetupAntiStaff()
task.spawn(CheckAndHopFromStaff)
if not AntiStaffConnection then
AntiStaffConnection = Players.PlayerAdded:Connect(function(p)
if AntiStaffEnabled and isStaff(p.UserId) then
Rayfield:Notify({ Title = "Anti Staff", Content = "Staff detected! Hopping to random server...", Duration = 3, Image = 4483362458 })
task.wait(0.3)
HopToRandomServer()
end
end)
end
end

UIRefs.AntiStaffToggle = CharacterTab:CreateToggle({
Name = "Anti-Staff", CurrentValue = true, Flag = "AntiStaffToggle",
Callback = function(Value)
AntiStaffEnabled = Value
if Value then
SetupAntiStaff()
else
if AntiStaffConnection then AntiStaffConnection:Disconnect(); AntiStaffConnection = nil end
end
end,
})

CharacterTab:CreateSection("Server")

local function SetupAntiAfk()
if not _G.AntiAfkConn then
_G.AntiAfkConn = LocalPlayer.Idled:Connect(function()
VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end)
end
end

UIRefs.AntiAfk = CharacterTab:CreateToggle({
Name = "Anti-AFK", CurrentValue = true, Flag = "AntiAfk",
Callback = function(Value)
if Value then
SetupAntiAfk()
else
if _G.AntiAfkConn then _G.AntiAfkConn:Disconnect(); _G.AntiAfkConn = nil end
end
end,
})

CharacterTab:CreateButton({ Name = "Rejoin Server", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end })
CharacterTab:CreateButton({ Name = "Server Hop", Callback = function() HopToServer(TargetPlayerCount) end })
UIRefs.HopTargetSlider = CharacterTab:CreateSlider({ Name = "Limit Configuration", Range = {1, 4}, Increment = 1, CurrentValue = 3, Flag = "HopTargetSlider", Callback = function(Value) TargetPlayerCount = Value end })
CharacterTab:CreateInput({ Name = "Join Jobid", PlaceholderText = "Paste Jobid Here...", RemoveTextAfterFocusLost = false, Callback = function(Text) if Text and Text ~= "" then pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, Text, LocalPlayer) end) end end })

SetupAntiAfk()
SetupAntiStaff()

table.insert(ScriptConnections, RunService.Stepped:Connect(function()
if Unloaded then return end
if NoclipEnabled and LocalPlayer.Character then
for index, part in ipairs(LocalPlayer.Character:GetChildren()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
part.Handle.CanCollide = false
end
end
end
end))

task.spawn(function()
while not Unloaded do
pcall(function()
if WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
end
end)
task.wait(0.2)
end
end)

task.spawn(function()
while not Unloaded do
if _G.AutoBuyToolsActive and #SelectedTools > 0 then
local toolsToBuy = SelectedTools[1] == "All" and {"SoapRinser", "WaterVacuum", "Brush", "MagicBroom"} or SelectedTools
for index, tool in ipairs(toolsToBuy) do
if not _G.AutoBuyToolsActive or Unloaded then break end
pcall(function() PurchaseTool:FireServer(tool) end)
task.wait(_G.BuyToolsDelay)
end
task.wait(4)
else task.wait(1) end
end
end)

task.spawn(function()
while not Unloaded do
if _G.AutoBuyWorkersActive and #SelectedWorkers > 0 then
if SelectedWorkers[1] == "All" then
for i = 1, 7 do
if not _G.AutoBuyWorkersActive or Unloaded then break end
pcall(function() HireWorker:FireServer(i) end)
task.wait(_G.BuyWorkersDelay)
end
else
for index, workerName in ipairs(SelectedWorkers) do
if not _G.AutoBuyWorkersActive or Unloaded then break end
local workerID = WorkersInfo[workerName]
if workerID then pcall(function() HireWorker:FireServer(workerID) end) task.wait(_G.BuyWorkersDelay) end
end
end
task.wait(4)
else task.wait(1) end
end
end)

task.spawn(function()
while not Unloaded do
if #SelectedSkills > 0 then
local skillsList = SelectedSkills[1] == "All" and {"Radius Master", "Double Clean", "Speed", "Cash Boost", "EXP Hoard", "Seal Coating Expert", "Hard Stain"} or SelectedSkills
for index, skill in ipairs(skillsList) do
if Unloaded then break end
pcall(function() UpgradeSkillRequest:InvokeServer(skill) end)
task.wait(_G.UpgradeDelay)
end
task.wait(5)
else task.wait(1) end
end
end)

task.spawn(function()
while not Unloaded do
if #SelectedUpgradeTools > 0 then
local toolsUpgradeList = SelectedUpgradeTools[1] == "All" and {"PressureWasher", "SoapRinser", "WaterVacuum", "Brush", "MagicBroom"} or SelectedUpgradeTools
for index, tool in ipairs(toolsUpgradeList) do
if Unloaded then break end
pcall(function() UpgradeTool:FireServer(tool) end)
task.wait(_G.UpgradeDelay)
end
task.wait(4)
else task.wait(1) end
end
end)

task.spawn(function()
while not Unloaded do
if #SelectedUpgradeCompany > 0 then
pcall(function() UpgradeCompanyRemote:FireServer() end)
task.wait(_G.UpgradeDelay + 5)
else task.wait(1) end
end
end)

task.spawn(function()
while not Unloaded do
if #SelectedUpgradeWorkers > 0 then
if SelectedUpgradeWorkers[1] == "All" then
for i = 1, 7 do
if Unloaded then break end
pcall(function() UpgradeWorkerRemote:FireServer(i) end)
task.wait(_G.UpgradeDelay)
end
else
for index, workerName in ipairs(SelectedUpgradeWorkers) do
if Unloaded then break end
local workerID = WorkersInfo[workerName]
if workerID then pcall(function() UpgradeWorkerRemote:FireServer(workerID) end) task.wait(_G.UpgradeDelay) end
end
end
task.wait(5)
else task.wait(1) end
end
end)

local CONFIG_FOLDER = "ConcreteCleaning"
local CONFIGS_FOLDER = "ConcreteCleaning/Configs"
local AUTOLOAD_FILE = "ConcreteCleaning/autoload.txt"

pcall(function() if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end end)
pcall(function() if not isfolder(CONFIGS_FOLDER) then makefolder(CONFIGS_FOLDER) end end)

local FlagDefs = {
{ key = "JobDropdown", setUI = function(v) pcall(function() UIRefs.JobDropdown:Set(type(v)=="table" and v or {tostring(v)}) end) end, applyVar = function(v) local s = type(v) == "table" and v[1] or v; if JobsInfo[s] then SelectedJobID = JobsInfo[s].ID; SelectedEvent = JobsInfo[s].Event end end },
{ key = "AutoJobToggle", setUI = function(v) pcall(function() UIRefs.AutoJobToggle:Set(v == true or v == "true") end) end, applyVar = function(v) _G.AutoCleanActive = (v == true or v == "true") end },
{ key = "ShopDropdown", setUI = function(v) pcall(function() UIRefs.ShopDropdown:Set(type(v)=="table" and v or {tostring(v)}) end) end, applyVar = function(v) SelectedTools = type(v)=="table" and v or {tostring(v)} end },
{ key = "EnableAutoBuyToolsToggle", setUI = function(v) pcall(function() UIRefs.EnableAutoBuyToolsToggle:Set(v == true or v == "true") end) end, applyVar = function(v) _G.AutoBuyToolsActive = (v == true or v == "true") end },
{ key = "WorkerDropdown", setUI = function(v) pcall(function() UIRefs.WorkerDropdown:Set(type(v)=="table" and v or {tostring(v)}) end) end, applyVar = function(v) SelectedWorkers = type(v)=="table" and v or {tostring(v)} end },
{ key = "EnableAutoBuyWorkersToggle", setUI = function(v) pcall(function() UIRefs.EnableAutoBuyWorkersToggle:Set(v == true or v == "true") end) end, applyVar = function(v) _G.AutoBuyWorkersActive = (v == true or v == "true") end },
{ key = "AutoRebirthToggle", setUI = function(v) pcall(function() UIRefs.AutoRebirthToggle:Set(v == true or v == "true") end) end, applyVar = function(v) _G.AutoRebirthActive = (v == true or v == "true") end },
{ key = "AutoClaimBonusChestToggle", setUI = function(v) pcall(function() UIRefs.AutoClaimBonusChestToggle:Set(v == true or v == "true") end) end, applyVar = function(v) _G.AutoClaimBonusChest = (v == true or v == "true") end },
{ key = "AutoClaimRewardsToggle", setUI = function(v) pcall(function() UIRefs.AutoClaimRewardsToggle:Set(v == true or v == "true") end) end, applyVar = function(v) _G.AutoClaimRewards = (v == true or v == "true") end },
{ key = "AutoInviteToggle", setUI = function(v) pcall(function() UIRefs.AutoInviteToggle:Set(v == true or v == "true") end) end, applyVar = function(v) _G.AutoInviteActive = (v == true or v == "true") end },
{ key = "SkillsDropdown", setUI = function(v) pcall(function() UIRefs.SkillsDropdown:Set(type(v)=="table" and v or {tostring(v)}) end) end, applyVar = function(v) SelectedSkills = type(v)=="table" and v or {tostring(v)} end },
{ key = "UpgradeToolsDropdown", setUI = function(v) pcall(function() UIRefs.UpgradeToolsDropdown:Set(type(v)=="table" and v or {tostring(v)}) end) end, applyVar = function(v) SelectedUpgradeTools = type(v)=="table" and v or {tostring(v)} end },
{ key = "UpgradeCompanyDropdown", setUI = function(v) pcall(function() UIRefs.UpgradeCompanyDropdown:Set(type(v)=="table" and v or {tostring(v)}) end) end, applyVar = function(v) SelectedUpgradeCompany = type(v)=="table" and v or {tostring(v)} end },
{ key = "UpgradeWorkersDropdown", setUI = function(v) pcall(function() UIRefs.UpgradeWorkersDropdown:Set(type(v)=="table" and v or {tostring(v)}) end) end, applyVar = function(v) SelectedUpgradeWorkers = type(v)=="table" and v or {tostring(v)} end },
{ key = "SelectEggDropdown", setUI = function(v) pcall(function() UIRefs.SelectEggDropdown:Set(type(v)=="table" and v or {tostring(v)}) end) end, applyVar = function(v) SelectedEgg = type(v)=="table" and tostring(v[1]) or tostring(v) end },
{ key = "SelectEggAmountDropdown", setUI = function(v) pcall(function() UIRefs.SelectEggAmountDropdown:Set(type(v)=="table" and v or {tostring(v)}) end) end, applyVar = function(v) local s = type(v)=="table" and v[1] or v; if s == "x1" then SelectedEggAmount = 1 elseif s == "x3" then SelectedEggAmount = 3 elseif s == "x10" then SelectedEggAmount = 10 end end },
{ key = "AutoOpenEggsToggle", setUI = function(v) pcall(function() UIRefs.AutoOpenEggsToggle:Set(v == true or v == "true") end) end, applyVar = function(v) _G.AutoOpenEggs = (v == true or v == "true") end },
{ key = "JobDelaySlider", setUI = function(v) pcall(function() UIRefs.JobDelaySlider:Set(tonumber(v) or v) end) end, applyVar = function(v) _G.JobDelay = tonumber(v) or v end },
{ key = "UpgradeDelaySlider", setUI = function(v) pcall(function() UIRefs.UpgradeDelaySlider:Set(tonumber(v) or v) end) end, applyVar = function(v) _G.UpgradeDelay = tonumber(v) or v end },
{ key = "EggDelaySlider", setUI = function(v) pcall(function() UIRefs.EggDelaySlider:Set(tonumber(v) or v) end) end, applyVar = function(v) _G.EggDelay = tonumber(v) or v end },
{ key = "BuyToolsDelaySlider", setUI = function(v) pcall(function() UIRefs.BuyToolsDelaySlider:Set(tonumber(v) or v) end) end, applyVar = function(v) _G.BuyToolsDelay = tonumber(v) or v end },
{ key = "BuyWorkersDelaySlider", setUI = function(v) pcall(function() UIRefs.BuyWorkersDelaySlider:Set(tonumber(v) or v) end) end, applyVar = function(v) _G.BuyWorkersDelay = tonumber(v) or v end },
{ key = "EnableWalkSpeed", setUI = function(v) pcall(function() UIRefs.EnableWalkSpeed:Set(v == true or v == "true") end) end, applyVar = function(v) WalkSpeedEnabled = (v == true or v == "true") end },
{ key = "WalkSpeedSlider", setUI = function(v) pcall(function() UIRefs.WalkSpeedSlider:Set(tonumber(v) or v) end) end, applyVar = function(v) WalkSpeedValue = tonumber(v) or v end },
{ key = "InfJumpToggle", setUI = function(v) pcall(function() UIRefs.InfJumpToggle:Set(v == true or v == "true") end) end, applyVar = function(v) InfJumpEnabled = (v == true or v == "true") end },
{ key = "NoclipToggle", setUI = function(v) pcall(function() UIRefs.NoclipToggle:Set(v == true or v == "true") end) end, applyVar = function(v) NoclipEnabled = (v == true or v == "true") end },
{ key = "AntiStaffToggle", setUI = function(v) pcall(function() UIRefs.AntiStaffToggle:Set(v == true or v == "true") end) end, applyVar = function(v) AntiStaffEnabled = (v == true or v == "true") end },
{ key = "AntiAfk", setUI = function(v) pcall(function() UIRefs.AntiAfk:Set(v == true or v == "true") end) end, applyVar = function(v) end },
{ key = "HopTargetSlider", setUI = function(v) pcall(function() UIRefs.HopTargetSlider:Set(tonumber(v) or v) end) end, applyVar = function(v) TargetPlayerCount = tonumber(v) or v end }
}

local function GetConfigList()
local list = {}
pcall(function()
for index, f in ipairs(listfiles(CONFIGS_FOLDER)) do
local name = f:match("([^/]+)%.json$")
if name then table.insert(list, name) end
end
end)
if #list == 0 then table.insert(list, "None") end
return list
end

local function SaveConfig(name)
local data = {}
for index, def in ipairs(FlagDefs) do
pcall(function()
local ref = UIRefs[def.key]
if ref then
if ref.CurrentValue ~= nil then
data[def.key] = ref.CurrentValue
elseif ref.CurrentOption ~= nil then
if type(ref.CurrentOption) == "table" and ref.MultipleOptions then
data[def.key] = ref.CurrentOption
else
data[def.key] = ref.CurrentOption[1] or ref.CurrentOption
end
end
end
end)
end
pcall(function() writefile(CONFIGS_FOLDER .. "/" .. name .. ".json", HttpService:JSONEncode(data)) end)
end

local function LoadConfig(name)
local ok, content = pcall(function() return readfile(CONFIGS_FOLDER .. "/" .. name .. ".json") end)
if not ok or not content or content == "" then
Rayfield:Notify({ Title = "Config", Content = "Config not found: " .. tostring(name), Duration = 3 })
return false
end
local decodeOk, data = pcall(function() return HttpService:JSONDecode(content) end)
if not decodeOk or type(data) ~= "table" then
Rayfield:Notify({ Title = "Config", Content = "Failed to parse config.", Duration = 3 })
return false
end
for index, def in ipairs(FlagDefs) do
local v = data[def.key]
if v ~= nil then
pcall(def.applyVar, v)
task.defer(function() def.setUI(v) end)
end
end
Rayfield:Notify({ Title = "Config", Content = "Loaded: " .. name, Duration = 3 })
return true
end

local SelectedConfigName = ""
local ConfigNameInputValue = ""

ConfigTab:CreateSection("Config List")

local ConfigListDropdown = ConfigTab:CreateDropdown({
Name = "Config List", Options = GetConfigList(), CurrentOption = {"None"}, MultipleOptions = false, Flag = "ConfigListDropdown",
Callback = function(Option)
local picked = Option[1]
SelectedConfigName = (picked ~= "None" and picked ~= "") and picked or ""
end,
})

ConfigTab:CreateInput({
Name = "Config Name", PlaceholderText = "Enter name...", RemoveTextAfterFocusLost = false, Flag = "ConfigNameInput",
Callback = function(Text) ConfigNameInputValue = Text or "" end,
})

ConfigTab:CreateButton({
Name = "Create / Overwrite Config",
Callback = function()
local name = ConfigNameInputValue
if name == "" then name = SelectedConfigName end
if name == "" then
Rayfield:Notify({ Title = "Config", Content = "Enter a config name or select one from the list.", Duration = 3 })
return
end
SaveConfig(name)
task.wait(0.1)
ConfigListDropdown:Refresh(GetConfigList())
Rayfield:Notify({ Title = "Config", Content = "Saved: " .. name, Duration = 3 })
end,
})

ConfigTab:CreateButton({
Name = "Load Config",
Callback = function()
if SelectedConfigName == "" then
Rayfield:Notify({ Title = "Config", Content = "Select a config from the list first.", Duration = 3 })
return
end
LoadConfig(SelectedConfigName)
end,
})

ConfigTab:CreateButton({
Name = "Delete Config",
Callback = function()
if SelectedConfigName == "" then
Rayfield:Notify({ Title = "Config", Content = "Select a config from the list first.", Duration = 3 })
return
end
local deleted = SelectedConfigName
pcall(function() delfile(CONFIGS_FOLDER .. "/" .. deleted .. ".json") end)
SelectedConfigName = ""
task.wait(0.1)
ConfigListDropdown:Refresh(GetConfigList())
Rayfield:Notify({ Title = "Config", Content = "Deleted: " .. deleted, Duration = 3 })
end,
})

ConfigTab:CreateButton({
Name = "Refresh List",
Callback = function()
ConfigListDropdown:Refresh(GetConfigList())
Rayfield:Notify({ Title = "Config", Content = "List refreshed.", Duration = 2 })
end,
})

ConfigTab:CreateSection("Autoload")

ConfigTab:CreateButton({
Name = "Set Current as Autoload",
Callback = function()
if SelectedConfigName == "" then
Rayfield:Notify({ Title = "Config", Content = "Select a config from the list first.", Duration = 3 })
return
end
pcall(function() writefile(AUTOLOAD_FILE, SelectedConfigName) end)
Rayfield:Notify({ Title = "Config", Content = "Autoload set: " .. SelectedConfigName, Duration = 4 })
end,
})

ConfigTab:CreateButton({
Name = "Reset Autoload",
Callback = function()
pcall(function() if isfile(AUTOLOAD_FILE) then delfile(AUTOLOAD_FILE) end end)
Rayfield:Notify({ Title = "Config", Content = "Autoload cleared.", Duration = 3 })
end,
})

ConfigTab:CreateSection("System")

ConfigTab:CreateButton({
Name = "Unload Script",
Callback = function() UnloadScript() end,
})

task.spawn(function()
task.wait(1)
pcall(function()
if not isfile(AUTOLOAD_FILE) then return end
local autoName = readfile(AUTOLOAD_FILE)
if not autoName or autoName == "" then return end
autoName = autoName:gsub("[%s\n\r]+", "")
if autoName == "" then return end
if not isfile(CONFIGS_FOLDER .. "/" .. autoName .. ".json") then
Rayfield:Notify({ Title = "Autoload", Content = "Config not found: " .. autoName, Duration = 4 })
return
end
LoadConfig(autoName)
end)
end)
