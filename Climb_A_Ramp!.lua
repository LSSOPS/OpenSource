if game.PlaceId ~= 124868078719468 and game.GameId ~= 124868078719468 then return end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
Name = "Climb a Ramp!",
LoadingTitle = "Climb a Ramp!",
LoadingSubtitle = "made by LSS",
ConfigurationSaving = {
Enabled = true,
FolderName = "ClimbARampSaveData",
FileName = "CarterConfig"
},
KeySystem = false
})

local MainTab = Window:CreateTab("Main", "home")
local CharacterTab = Window:CreateTab("Character", "user")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local WalkSpeedEnabled, WalkSpeedValue = false, 16
local InfJumpEnabled = false
local NoclipEnabled = false
local AntiFlingEnabled, lastSafePos = true, nil
local AntiStaffEnabled = true
local STAFF_USER_ID = 878711784
local TargetPlayerCount = 5
local AntiStaffConnection = nil

local function HopToRandomServer()
local endpoints = {
"https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100",
"https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
}
local decodedData
for _, url in ipairs(endpoints) do
local success, response = pcall(function() return game:HttpGet(url) end)
if success and response then
local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response) end)
if decodeSuccess and data and data.data then decodedData = data; break end
end
end
if decodedData and decodedData.data then
local validServers = {}
for _, v in ipairs(decodedData.data) do
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
local decodedData
for _, url in ipairs(endpoints) do
local success, response = pcall(function() return game:HttpGet(url) end)
if success and response then
local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response) end)
if decodeSuccess and data and data.data then decodedData = data; break end
end
end
if decodedData and decodedData.data then
local validServers = {}
for _, v in ipairs(decodedData.data) do
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
for _, p in ipairs(Players:GetPlayers()) do
if p.UserId == STAFF_USER_ID then
Rayfield:Notify({ Title = "Anti Staff", Content = "Staff detected! Hopping to random server...", Duration = 3, Image = 4483362458 })
task.wait(0.3)
HopToRandomServer()
return true
end
end
return false
end

MainTab:CreateButton({
Name = "INF Cash",
Callback = function()
local event = ReplicatedStorage:WaitForChild("CashOutEvent")
local inf = math.huge
local args = {inf, inf}
event:FireServer(unpack(args))
end
})

local isRebirthing = false

MainTab:CreateButton({
Name = "Instant Max Rebirths",
Callback = function()
if isRebirthing then return end
isRebirthing = true
local RebirthEvent = ReplicatedStorage:WaitForChild("RebirthEvent")
local args = {"Single"}
for i = 1, 1300 do
RebirthEvent:FireServer(unpack(args))
if i % 100 == 0 then
task.wait()
end
end
task.wait(2)
isRebirthing = false
end
})

MainTab:CreateButton({
Name = "Buy All Shoe & Equip Best Shoe",
Callback = function()
local buyEvent = ReplicatedStorage:WaitForChild("BuyShoeEvent")
local equipEvent = ReplicatedStorage:WaitForChild("EquipShoeEvent")
local shoes = {"Classic", "Blue", "Green", "Wooden", "Rock", "Brick", "Sand", "Rust", "Iron", "Camo", "Flowery", "Cheese", "Candy", "Brainrot", "Birthday", "Christmas", "Halloween", "Easter", "Firework", "Winter", "Summer", "Autumn", "Spring", "Water", "Cloudy", "Rainy", "Thunder", "Ice", "Lava", "Toxic", "Electric", "Gold", "Chrome", "Diamond", "Obsidian", "Rainbow", "Glitch", "Earth", "Moon", "Mars", "Sun", "Starry", "Galaxy", "Devil", "Angel", "Heavenly", "Slime", "Graffitti", "Emoji", "Comic", "Translucent", "Phantom", "Soulfire", "Void", "Dark Matter", "Nebula", "Supernova", "Black Hole", "Cosmic", "Quantum", "Cyber", "Holographic", "Mythic", "Legendary", "Divine", "Celestial"}
for _, shoe in ipairs(shoes) do
buyEvent:FireServer(shoe)
end
equipEvent:FireServer(shoes[#shoes])
end
})

MainTab:CreateButton({
Name = "Buy All Trails & Equip Best Trails",
Callback = function()
local buyEvent = ReplicatedStorage:WaitForChild("BuyTrailEvent")
local equipEvent = ReplicatedStorage:WaitForChild("EquipTrailEvent")
local freeTrails = {
"Starter",
"Blue",
"Green",
"Red",
"Purple",
"Black",
"Midnight",
"Lava",
"Diamond"
}
local targetTrail = "Diamond"
local ownedTrails = LocalPlayer:WaitForChild("OwnedTrails", 5)

if ownedTrails then
for _, trail in ipairs(freeTrails) do
if not ownedTrails:FindFirstChild(trail) then
buyEvent:FireServer(trail)
end
end

task.wait(0.5)

if LocalPlayer:GetAttribute("EquippedTrail") ~= targetTrail then
equipEvent:FireServer(targetTrail)
end
end
end
})

local autoBuyModifiersEnabled = false

MainTab:CreateToggle({
Name = "Auto Buy Modifiers",
CurrentValue = false,
Flag = "AutoBuyModifiersToggle",
Callback = function(Value)
autoBuyModifiersEnabled = Value
if autoBuyModifiersEnabled then
task.spawn(function()
local buyModifierEvent = ReplicatedStorage:WaitForChild("BuyModifierEvent")
local b = {
"SlipAndSlideModifierFrame",
"LowGravityModifierFrame",
"LightsOutModifierFrame",
"GiantModifierFrame",
"x2CashModifierFrame",
"x2WinsModifierFrame"
}
while autoBuyModifiersEnabled do
for g, h in ipairs(b) do
local i = Workspace:GetAttribute(h .. "_EndTime")
if not i or os.time() >= i then
pcall(function()
buyModifierEvent:FireServer(h)
end)
end
end
task.wait(0.1)
end
end)
end
end
})

local autoFarmEnabled = false
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local FOLDER_NAME = "WinParts"
local PART_NAME = "WinPart6Starter"
local TARGET_POSITION = Vector3.new(17, 1386, -1533)

PlayerGui.ChildAdded:Connect(function(child)
if child.Name == "ConfettiGui" then
task.defer(function() child:Destroy() end)
end
end)

MainTab:CreateToggle({
Name = "Auto Farm Win",
CurrentValue = false,
Flag = "AutoFarmWinToggle",
Callback = function(Value)
autoFarmEnabled = Value
if autoFarmEnabled then
task.spawn(function()
while autoFarmEnabled do
pcall(function()
local gui = PlayerGui:FindFirstChild("ConfettiGui")
if gui then gui:Destroy() end

local character = LocalPlayer.Character
if character and character:FindFirstChild("HumanoidRootPart") then
local root = character.HumanoidRootPart
local folder = Workspace:FindFirstChild(FOLDER_NAME)
local targetPart = folder and folder:FindFirstChild(PART_NAME, true)

if targetPart then
if firetouchinterest then
firetouchinterest(root, targetPart, 0)
task.wait()
firetouchinterest(root, targetPart, 1)
else
root.CFrame = targetPart.CFrame
end
else
root.CFrame = CFrame.new(TARGET_POSITION)
end
end
end)
task.wait(0.1)
end
end)
end
end
})

CharacterTab:CreateSection("Movement")

CharacterTab:CreateToggle({
Name = "Enable WalkSpeed", CurrentValue = false, Flag = "EnableWalkSpeed",
Callback = function(Value)
WalkSpeedEnabled = Value
if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.WalkSpeed = 16
end
end,
})

CharacterTab:CreateSlider({
Name = "WalkSpeed Amount", Range = {16, 2000}, Increment = 1, CurrentValue = 16, Flag = "WalkSpeedSlider",
Callback = function(Value) WalkSpeedValue = Value end,
})

CharacterTab:CreateToggle({
Name = "Infinite Jump", CurrentValue = false, Flag = "InfJumpToggle",
Callback = function(Value) InfJumpEnabled = Value end,
})

CharacterTab:CreateToggle({
Name = "Noclip", CurrentValue = false, Flag = "NoclipToggle",
Callback = function(Value)
NoclipEnabled = Value
if not Value and LocalPlayer.Character then
for _, partName in ipairs({"Torso", "UpperTorso", "LowerTorso", "Head"}) do
local part = LocalPlayer.Character:FindFirstChild(partName)
if part then part.CanCollide = true end
end
end
end,
})

CharacterTab:CreateSection("Protect yourself")

CharacterTab:CreateToggle({
Name = "Anti-Fling", CurrentValue = true, Flag = "AntiFlingToggle",
Callback = function(Value) AntiFlingEnabled = Value end,
})

CharacterTab:CreateToggle({
Name = "Anti-Staff", CurrentValue = true, Flag = "AntiStaffToggle",
Callback = function(Value)
AntiStaffEnabled = Value
if Value then
task.spawn(CheckAndHopFromStaff)
if not AntiStaffConnection then
AntiStaffConnection = Players.PlayerAdded:Connect(function(p)
if AntiStaffEnabled and p.UserId == STAFF_USER_ID then
Rayfield:Notify({ Title = "Anti Staff", Content = "Staff detected! Hopping to random server...", Duration = 3, Image = 4483362458 })
task.wait(0.3)
HopToRandomServer()
end
end)
end
else
if AntiStaffConnection then
AntiStaffConnection:Disconnect()
AntiStaffConnection = nil
end
end
end,
})

CharacterTab:CreateSection("Server")

CharacterTab:CreateToggle({
Name = "Anti-AFK", CurrentValue = true, Flag = "AntiAfk",
Callback = function(Value)
if Value then
if not _G.AntiAfkConn then
_G.AntiAfkConn = LocalPlayer.Idled:Connect(function()
VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end)
end
else
if _G.AntiAfkConn then
_G.AntiAfkConn:Disconnect()
_G.AntiAfkConn = nil
end
end
end,
})

CharacterTab:CreateButton({ Name = "Rejoin Server", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end })
CharacterTab:CreateButton({ Name = "Server Hop", Callback = function() HopToServer(TargetPlayerCount) end })
CharacterTab:CreateSlider({ Name = "Limit Configuration", Range = {1, 7}, Increment = 1, CurrentValue = 5, Flag = "HopTargetSlider", Callback = function(Value) TargetPlayerCount = Value end })
CharacterTab:CreateInput({ Name = "Join Jobid", PlaceholderText = "Paste Jobid Here...", RemoveTextAfterFocusLost = false, Flag = "JoinJobIdInput", Callback = function(Text) if Text and Text ~= "" then pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, Text, LocalPlayer) end) end end })

if not _G.AntiAfkConn then
_G.AntiAfkConn = LocalPlayer.Idled:Connect(function()
VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end)
end

AntiStaffConnection = Players.PlayerAdded:Connect(function(p)
if AntiStaffEnabled and p.UserId == STAFF_USER_ID then
Rayfield:Notify({ Title = "Anti Staff", Content = "Staff detected! Hopping to random server...", Duration = 3, Image = 4483362458 })
task.wait(0.3)
HopToRandomServer()
end
end)

task.spawn(function()
task.wait(1.5)
if AntiStaffEnabled then
CheckAndHopFromStaff()
end
end)

RunService.Stepped:Connect(function()
if NoclipEnabled and LocalPlayer.Character then
for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
end
end
if AntiFlingEnabled then
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer and player.Character then
local root = player.Character:FindFirstChild("HumanoidRootPart")
if root and (root.AssemblyAngularVelocity.Magnitude > 50 or root.AssemblyLinearVelocity.Magnitude > 100) then
for _, part in ipairs(player.Character:GetDescendants()) do
if part:IsA("BasePart") then part.CanCollide = false end
end
end
end
end
end
end)

RunService.Heartbeat:Connect(function()
pcall(function()
if WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
end
end)
if AntiFlingEnabled then
pcall(function()
local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if root then
if root.AssemblyLinearVelocity.Magnitude > 250 or root.AssemblyAngularVelocity.Magnitude > 250 then
root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
if lastSafePos then root.CFrame = lastSafePos end
else lastSafePos = root.CFrame end
end
end)
end
end)

UserInputService.JumpRequest:Connect(function()
pcall(function() if InfJumpEnabled and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)
end)

Rayfield:LoadConfiguration()
