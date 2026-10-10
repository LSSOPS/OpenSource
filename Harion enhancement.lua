local function waitForLoadingScreen()
	local players = game:GetService("Players")
	local coreGui = game:GetService("CoreGui")

	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	local player = players.LocalPlayer
	while not player do
		players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		player = players.LocalPlayer
	end

	local playerGui = player:WaitForChild("PlayerGui")
	local function isActiveLoadingGui(object)
		local normalizedName = object.Name:lower():gsub("[%s_%-]", "")
		if normalizedName ~= "loadingscreen" and not normalizedName:find("loadingscreen", 1, true) then
			return false
		end

		local current = object
		while current and current ~= playerGui and current ~= coreGui do
			if current:IsA("LayerCollector") and not current.Enabled then
				return false
			end
			if current:IsA("GuiObject") and not current.Visible then
				return false
			end
			current = current.Parent
		end
		return object:IsDescendantOf(playerGui) or object:IsDescendantOf(coreGui)
	end

	local clearSince
	repeat
		local loading = false
		for _, root in ipairs({playerGui, coreGui}) do
			for _, object in ipairs(root:GetDescendants()) do
				if isActiveLoadingGui(object) then
					loading = true
					break
				end
			end
			if loading then break end
		end

		clearSince = loading and nil or (clearSince or os.clock())
		task.wait(0.1)
	until clearSince and os.clock() - clearSince >= 0.5
end

waitForLoadingScreen()

do
    local function safeNewcclosure(fn)
        return newcclosure and newcclosure(fn) or fn
    end

    if not getgenv().__LionStartupHooks then
        getgenv().__LionStartupHooks = true
        if setthreadidentity then
            pcall(setthreadidentity, 8)
        end

        local okEnv, renv = pcall(getrenv)
        local setmetatableTarget = okEnv and renv and renv.setmetatable
        if hookfunction and setmetatableTarget then
            local oldSetmetatable = setmetatableTarget
            local okHook, hooked = pcall(hookfunction, setmetatableTarget, safeNewcclosure(function(Table, Metatable)
                if Metatable and type(Metatable) == "table" and rawget(Metatable, "__mode") then
                    local mode = rawget(Metatable, "__mode")
                    if mode == "kv" or mode == "v" or mode == "k" then
                        local okTrace, trace = pcall(debug.traceback)
                        trace = okTrace and trace or ""
                        if trace:find("MiscellaneousController", 1, true)
                            or trace:find("CameraSecurity", 1, true)
                            or trace:find("AnalyticsPipelineController", 1, true) then
                            return oldSetmetatable({1, 2, 3}, {})
                        end
                    end
                end
                return oldSetmetatable(Table, Metatable)
            end))
            if okHook and hooked then
                oldSetmetatable = hooked
            end
        end

        local okPlayer, localPlayer = pcall(function()
            return cloneref(game:GetService("Players")).LocalPlayer
        end)
        if okPlayer and localPlayer and hookfunction then
            pcall(function()
                local oldKick
                oldKick = hookfunction(localPlayer.Kick, safeNewcclosure(function(self, ...)
                    if self == localPlayer then return nil end
                    return oldKick(self, ...)
                end))
            end)

            pcall(function()
                local oldGetMouse
                oldGetMouse = hookfunction(localPlayer.GetMouse, safeNewcclosure(function(self, ...)
                    if self == localPlayer then
                        local okTrace, trace = pcall(debug.traceback)
                        if okTrace and trace:find("MiscellaneousController", 1, true) then
                            local realMouse = oldGetMouse(self, ...)
                            local fakeMouse = {}
                            setmetatable(fakeMouse, {
                                __index = function(_, key)
                                    if key == "X" or key == "Y" then
                                        local loc = game:GetService("UserInputService"):GetMouseLocation()
                                        return key == "X" and loc.X or loc.Y
                                    end
                                    local val = realMouse[key]
                                    if type(val) == "function" then
                                        return function(_, ...) return val(realMouse, ...) end
                                    end
                                    return val
                                end,
                                __newindex = function(_, key, value)
                                    realMouse[key] = value
                                end
                            })
                            return fakeMouse
                        end
                    end
                    return oldGetMouse(self, ...)
                end))
            end)
        end
    end
end

print'[~]'

local function vec2floor(v)
	return Vector2.new(math.floor(v.X), math.floor(v.Y))
end
local function vec2fdiv(v, d)
	return Vector2.new(math.floor(v.X / d), math.floor(v.Y / d))
end

local eattheF = getfenv()
local eattheG = getgenv()


local C = (cloneref(game:GetService("Players"))).LocalPlayer;
local g = C.PlayerScripts;


local cameraSecurity = require(g.Modules.CameraSecurity);
local mt = getrawmetatable(cameraSecurity)
local b = {};


local originalIndex = rawget(getmetatable(cameraSecurity) or {}, "__index");
local originalTostring = rawget(getmetatable(cameraSecurity) or {}, "__tostring");
local originalNewindex = rawget(getmetatable(cameraSecurity) or {}, "__newindex");

mt.__index = function(...)
    return nil;
end;

mt.__tostring = function(...)
    return "LocalPlayer = nil";
end;

mt.__newindex = function(E, G, f, ...)
    return rawset(E, G, f);
end;



print(cameraSecurity, b)

local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local Players = cloneref(game:GetService("Players"))
local ReplicatedFirst = cloneref(game:GetService('ReplicatedFirst'))

local mainapi = setmetatable({
	Tabs = {};
	Keybind = {};
	Font = Enum.Font.BuilderSans;
	Loaded = false;
	Modules = {};
	Catalogs = {};
	Libraries = {};
	Binds = {};
	Place = game.PlaceId;
	ThreadFix = false;
	Scale = {Value = 1};
	GradientKeypoints = 5;
	TargetHudFrame = Instance.new("Frame");
	MainScreenGui = Instance.new("ScreenGui");
	ClickGuiStatus = false;
	SecurityDisabled = false;
	SearchText = "";

})

for _, service in pairs({Players, workspace, ReplicatedStorage, ReplicatedFirst}) do
	service.Name = service.Name .. " "
end

coroutine.wrap(function()
	while wait(1) do
		local status, err = pcall(function()
			return game:Kick()
		end)

		if status then
			print("[ANTI-CHEAT] Hook detected: game:Kick() returned successfully")
			--require(game:GetService("ReplicatedFirst"):WaitForChild("AnalyticsPipelineController"):WaitForChild("AnalyticsPipeline"))({}, {11, -11, 111})
		end
	end
end)()

task.spawn(function()
	local ServerPing = workspace:WaitForChild("ServerPing")
	local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local PingRemote = Remotes and Remotes:FindFirstChild("Ping")

	while wait(12 * math.random()) do
		local rnd = math.random(1, 9999)
		local value = rnd == 6961 and 2137 or rnd == ServerPing.Value and 2138 or rnd

		if PingRemote then
			PingRemote:FireServer(value)
		end
	end
end)

task.spawn(function()
	while task.wait(1) do
		local ok, count = pcall(function()
			return #getmetatable(mainapi)
		end)

		if ok and count ~= 4 then
			print("[ANTI-CHEAT] Metatable tampering detected")
			--require(game:GetService("ReplicatedFirst"):WaitForChild("AnalyticsPipelineController"):WaitForChild("AnalyticsPipeline"))({-10}, {15, -150})
		end
	end
end)

mainapi.BindingBusy = false
mainapi.ActiveBindCancel = nil
mainapi.SuppressModuleClickUntil = 0
mainapi.SuppressBindToggleUntil = 0
local Modern = shared.Modern

local cloneref = cloneref or function(obj)
	return obj
end


local UserInputService = cloneref(game:GetService('UserInputService'))
local TextChatService = cloneref(game:GetService("TextChatService"))
local TweenService = cloneref(game:GetService('TweenService'))
local TextService = cloneref(game:GetService('TextService'))
local GuiService = cloneref(game:GetService('GuiService'))
local RunService = cloneref(game:GetService('RunService'))
local HttpService = cloneref(game:GetService('HttpService'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local Lighting = cloneref(game:GetService("Lighting"))
local Players = cloneref(game:GetService('Players'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local VirtualInputManager = cloneref(game:GetService('VirtualInputManager'))
local GroupService = cloneref(game:GetService('GroupService'))
local MarketplaceService = cloneref(game:GetService('MarketplaceService'))
local ContextService = cloneref(game:GetService("ContextActionService"))
local LocalPlayer = Players.LocalPlayer
local fontsize = Instance.new('GetTextBoundsParams')
fontsize.Width = math.huge

local shootingRangeCache, shootingRangeChecked = false, 0
local function isShootingRange()
    local now = os.clock()
    if now - shootingRangeChecked < 0.5 then return shootingRangeCache end
    shootingRangeChecked = now

    local function matches(value)
        if value == nil then return false end
        local text = tostring(value):lower():gsub("[%s_%-]", "")
        return text:find("shootingrange", 1, true) ~= nil
            or text:find("firingrange", 1, true) ~= nil
            or text:find("사격장", 1, true) ~= nil
    end

    for _, object in ipairs({workspace, LocalPlayer}) do
        for _, attribute in ipairs({"Map", "MapName", "Mode", "GameMode", "Arena", "Environment", "EnvironmentName", "ShootingRange"}) do
            local value = object:GetAttribute(attribute)
            if (value == true and attribute == "ShootingRange") or matches(value) then
                shootingRangeCache = true
                return true
            end
        end
    end

    local character = LocalPlayer.Character
    local current = character
    while current and current ~= workspace do
        if matches(current.Name) then
            shootingRangeCache = true
            return true
        end
        current = current.Parent
    end

    local root = character and character:FindFirstChild("HumanoidRootPart")
    local function matchingAreaIsNear(object)
        if not matches(object.Name) or not root then return false end
        local part = object:IsA("BasePart") and object or object:FindFirstChildWhichIsA("BasePart", true)
        return part and (part.Position - root.Position).Magnitude < 2000
    end
    for _, child in ipairs(workspace:GetChildren()) do
        if matchingAreaIsNear(child) then
            shootingRangeCache = true
            return true
        end
        for _, grandchild in ipairs(child:GetChildren()) do
            if matchingAreaIsNear(grandchild) then
                shootingRangeCache = true
                return true
            end
        end
    end

    shootingRangeCache = false
    return false
end

local MenuBlur = Lighting:FindFirstChild("LionMenuBlur")
if not MenuBlur or not MenuBlur:IsA("BlurEffect") then
    MenuBlur = Instance.new("BlurEffect")
    MenuBlur.Name = "LionMenuBlur"
    MenuBlur.Parent = Lighting
end
MenuBlur.Size = 0

local function setMenuBlur(open)
    local blur = Lighting:FindFirstChild("LionMenuBlur")
    if not blur or not blur:IsA("BlurEffect") then
        blur = Instance.new("BlurEffect")
        blur.Name = "LionMenuBlur"
        blur.Parent = Lighting
    end
    blur.Parent = Lighting
    blur.Size = open and 20 or 0

    if not open then
        for _, effect in next, Lighting:GetChildren() do
            if effect:IsA("BlurEffect") then
                effect.Size = 0
            end
        end
    end
end

local function getRootPart()
    local char = LocalPlayer.Character
    if not char then
        return nil
    end

    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("RootPart")
        or char.PrimaryPart
end

local rootPart = getRootPart()

local entitylib = {
	isAlive = false,
	character = {},
	List = {},
	Connections = {},
	PlayerConnections = {},
	EntityThreads = {},
	Running = false,
	Events = {}
}

mainapi.Libraries.entitylib = entitylib

local function createEvent()
	local event = {
		Connections = {}
	}

	function event:Connect(func)
		table.insert(self.Connections, func)

		return {
			Disconnect = function()
				local index = table.find(self.Connections, func)
				if index then
					table.remove(self.Connections, index)
				end
			end
		}
	end

	function event:Fire(...)
		for _, func in self.Connections do
			task.spawn(func, ...)
		end
	end

	function event:Destroy()
		table.clear(self.Connections)
		table.clear(self)
	end

	return event
end

function entitylib:GetEvent(name)
	if not self.Events[name] then
		self.Events[name] = createEvent()
	end

	return self.Events[name]
end

mainapi.Libraries.auraanims = {
	Normal = {
		{CFrame = CFrame.new(-0.17, -0.14, -0.12) * CFrame.Angles(math.rad(-53), math.rad(50), math.rad(-64)), Time = 0.1},
		{CFrame = CFrame.new(-0.55, -0.59, -0.1) * CFrame.Angles(math.rad(-161), math.rad(54), math.rad(-6)), Time = 0.08},
		{CFrame = CFrame.new(-0.62, -0.68, -0.07) * CFrame.Angles(math.rad(-167), math.rad(47), math.rad(-1)), Time = 0.03},
		{CFrame = CFrame.new(-0.56, -0.86, 0.23) * CFrame.Angles(math.rad(-167), math.rad(49), math.rad(-1)), Time = 0.03}
	},
	Random = {},
	['Horizontal Spin'] = {
		{CFrame = CFrame.Angles(math.rad(-10), math.rad(-90), math.rad(-80)), Time = 0.12},
		{CFrame = CFrame.Angles(math.rad(-10), math.rad(180), math.rad(-80)), Time = 0.12},
		{CFrame = CFrame.Angles(math.rad(-10), math.rad(90), math.rad(-80)), Time = 0.12},
		{CFrame = CFrame.Angles(math.rad(-10), 0, math.rad(-80)), Time = 0.12}
	},
	['Vertical Spin'] = {
		{CFrame = CFrame.Angles(math.rad(-90), 0, math.rad(15)), Time = 0.12},
		{CFrame = CFrame.Angles(math.rad(180), 0, math.rad(15)), Time = 0.12},
		{CFrame = CFrame.Angles(math.rad(90), 0, math.rad(15)), Time = 0.12},
		{CFrame = CFrame.Angles(0, 0, math.rad(15)), Time = 0.12}
	},
	Exhibition = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.1},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.2}
	},
	['Exhibition Old'] = {
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.15},
		{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(-30), math.rad(50), math.rad(-90)), Time = 0.05},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.1},
		{CFrame = CFrame.new(0.7, -0.71, 0.59) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.05},
		{CFrame = CFrame.new(0.63, -0.1, 1.37) * CFrame.Angles(math.rad(-84), math.rad(50), math.rad(-38)), Time = 0.15}
	}
}


-- Alive check
function entitylib:IsAlive()
	local char = lplr.Character
	if not char then return false end

	local root = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChildOfClass("Humanoid")

	if root and humanoid and humanoid.Health > 0 then
		return true
	end
	return false
end

function IsAlive()
	local char = LocalPlayer.Character
	if not char then return false end

	local root = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChildOfClass("Humanoid")

	-- ?????? ???? 멤 ?????????? 뱼?? ??????轅붽??????? 깢???? ?饔낅????????? 뇡??????? 쀫 ????????濡ろ?????饔낅????????0????? 뮛???????????? 곣 ????
	if root and humanoid and humanoid.Health > 0 then
		return true
	end
	return false
end


local cloneref = cloneref or function(obj)
	return obj
end
local CONFIG_FOLDER = "Overlay"
local CONFIG_FILE = CONFIG_FOLDER .. "/config.json"

local function EnsureConfigFolder()
    if not makefolder then return end
    if isfolder and isfolder(CONFIG_FOLDER) then return end

    pcall(function()
        makefolder(CONFIG_FOLDER)
    end)
end

EnsureConfigFolder()

local Config = {
    Modules = {},
    Gui = {}
}

local TargetHudMain, RagebotStatusMain, Theme
local _lastConfigJson = nil
local _savingConfig = true
local _configSaveQueued = false

local function SaveConfig(force)
    if _savingConfig and not force then return end
    if not writefile then return end

    if not force then
        if _configSaveQueued then return end
        _configSaveQueued = true
        task.delay(0.15, function()
            _configSaveQueued = false
            SaveConfig(true)
        end)
        return
    end

    local wasSaving = _savingConfig
    _savingConfig = true

    local ok, err = pcall(function()
        EnsureConfigFolder()

        local data = {
            Modules = {},
            Gui = {}
        }

        for name, module in pairs(mainapi.Modules) do
            local settings = {}

            if module.Settings then
                for sname, setting in pairs(module.Settings) do
                    if type(setting) == "table" and setting.Save then
                        pcall(function()
                            setting:Save(settings)
                        end)
                    end
                end
            end

            local moduleColors
            if module.Colors then
                moduleColors = {}
                for i, color in ipairs(module.Colors) do
                    moduleColors[i] = {
                        R = color.R,
                        G = color.G,
                        B = color.B,
                        Transparency = module.ColorTransparency and module.ColorTransparency[i] or 0,
                    }
                end
            elseif module.Value then
                moduleColors = {
                    {
                        R = module.Value.R,
                        G = module.Value.G,
                        B = module.Value.B,
                        Transparency = 0,
                    }
                }
            end

            data.Modules[name] = {
                Enabled = module.Enabled,
                Expanded = module.Expanded,
                Bind = typeof(module.Bind) == "EnumItem" and {
                    EnumType = module.Bind.EnumType == Enum.KeyCode and "Enum.KeyCode" or "Enum.UserInputType",
                    Name = module.Bind.Name
                } or nil,
                Colors = moduleColors,
                Settings = settings
            }
        end

        if TargetHudMain then
            data.Gui.TargetHud = {
                X = TargetHudMain.AbsolutePosition.X,
                Y = TargetHudMain.AbsolutePosition.Y
            }
        end

        if RagebotStatusMain then
            data.Gui.RagebotStatus = {
                X = RagebotStatusMain.AbsolutePosition.X,
                Y = RagebotStatusMain.AbsolutePosition.Y
            }
        end

        local json = HttpService:JSONEncode(data)

        -- ?? 룇?? ??? 몃 ?????????????곕뻣 ????
        if json ~= _lastConfigJson then
            _lastConfigJson = json
            writefile(CONFIG_FILE, json)
        end
    end)

    _savingConfig = wasSaving and not force

    if not ok then
        warn("[ModernClient] SaveConfig failed:", err)
    end
end

local FlushConfig = SaveConfig
function mainapi:Save()
    return SaveConfig(true)
end

local function LoadConfig()
    if not readfile or not isfile or not isfile(CONFIG_FILE) then
        return
    end

    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)

    if ok and type(data) == "table" then
        Config = data
        _lastConfigJson = HttpService:JSONEncode(data)
    end
end

-- Auto config loading is disabled to keep startup light and avoid applying heavy saved UI/module state.
-- LoadConfig()

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local lplr = playersService.LocalPlayer
local gameCamera = workspace.CurrentCamera

local function getGameCamera()
	local cam = workspace.CurrentCamera
	if cam and cam ~= gameCamera then
		gameCamera = cam
	end
	return gameCamera
end

local function getMousePosition()
	local camera = getGameCamera()
	if inputService.TouchEnabled then
		return camera.ViewportSize / 2
	end
	return inputService.GetMouseLocation(inputService)
end

local function loopClean(tbl)
	for i, v in tbl do
		if type(v) == 'table' then
			loopClean(v)
		end
		tbl[i] = nil
	end
end

local function waitForChildOfType(obj, name, timeout, prop)
	local checktick = tick() + timeout
	local returned
	repeat
		returned = prop and obj[name] or obj:FindFirstChildOfClass(name)
		if returned or checktick < tick() then break end
		task.wait()
	until false
	return returned
end

entitylib.targetCheck = function(ent)
	if ent.TeamCheck then
		return ent:TeamCheck()
	end
	if ent.NPC then return true end
	if not lplr.Team then return true end
	if not ent.Player.Team then return true end
	if ent.Player.Team ~= lplr.Team then return true end
	return #ent.Player.Team:GetPlayers() == #playersService:GetPlayers()
end

entitylib.getUpdateConnections = function(ent)
	local hum = ent.Humanoid
	return {
		hum:GetPropertyChangedSignal('Health'),
		hum:GetPropertyChangedSignal('MaxHealth')
	}
end

entitylib.isVulnerable = function(ent)
	return ent.Health > 0 and not ent.Character.FindFirstChildWhichIsA(ent.Character, 'ForceField')
end

entitylib.getEntityColor = function(ent)
	if not ent then return nil end
	ent = ent.Player
	return ent and tostring(ent.TeamColor) ~= 'White' and ent.TeamColor.Color or nil
end

entitylib.IgnoreObject = RaycastParams.new()
entitylib.IgnoreObject.RespectCanCollide = true
entitylib.Wallcheck = function(origin, position, ignoreobject)
	local camera = getGameCamera()
	if typeof(ignoreobject) ~= 'Instance' then
		local ignorelist = {camera, lplr.Character}
		for _, v in entitylib.List do
			if v.Targetable then
				table.insert(ignorelist, v.Character)
			end
		end

		if typeof(ignoreobject) == 'table' then
			for _, v in ignoreobject do
				table.insert(ignorelist, v)
			end
		end

		ignoreobject = entitylib.IgnoreObject
		ignoreobject.FilterDescendantsInstances = ignorelist
	end
	return workspace.Raycast(workspace, origin, (position - origin), ignoreobject)
end

entitylib.EntityMouse = function(entitysettings)
	if not entitylib:IsAlive() then return end

	local camera = getGameCamera()
	local mouseLocation = entitysettings.MouseOrigin or getMousePosition()
	local sortingTable = {}

	for _, v in entitylib.List do
		if not v.Targetable then continue end

		local pos, vis = camera:WorldToViewportPoint(v[entitysettings.Part].Position)
		if not vis then continue end

		local mag = (mouseLocation - Vector2.new(pos.X, pos.Y)).Magnitude
		if mag > entitysettings.Range then continue end

		if entitylib.isVulnerable(v) then
			table.insert(sortingTable,{
				Entity = v,
				Magnitude = mag
			})
		end
	end

	table.sort(sortingTable,function(a,b)
		return a.Magnitude < b.Magnitude
	end)

	if sortingTable[1] then
		return sortingTable[1].Entity
	end
end

entitylib.EntityPosition = function(entitysettings)
	if entitylib.isAlive then
		local localPosition, sortingTable = entitysettings.Origin or Players.LocalPlayer.Character.HumanoidRootPart.Position, {}
		for _, v in entitylib.List do
			if not entitysettings.Players and v.Player then continue end
			if not entitysettings.NPCs and v.NPC then continue end
			if not v.Targetable then continue end
			local mag = (v[entitysettings.Part].Position - localPosition).Magnitude
			if mag > entitysettings.Range then continue end
			if entitylib.isVulnerable(v) then
				table.insert(sortingTable, {
					Entity = v,
					Magnitude = v.Target and -1 or mag
				})
			end
		end

		table.sort(sortingTable, entitysettings.Sort or function(a, b)
			return a.Magnitude < b.Magnitude
		end)

		for _, v in sortingTable do
			if entitysettings.Wallcheck then
				if entitylib.Wallcheck(localPosition, v.Entity[entitysettings.Part].Position, entitysettings.Wallcheck) then continue end
			end
			table.clear(entitysettings)
			table.clear(sortingTable)
			return v.Entity
		end
		table.clear(sortingTable)
	end
	table.clear(entitysettings)
end

entitylib.AllPosition = function(entitysettings)
	local returned = {}
	if entitylib.isAlive then
		local localPosition, sortingTable = entitysettings.Origin or entitylib.character.HumanoidRootPart.Position, {}
		for _, v in entitylib.List do
			if not entitysettings.Players and v.Player then continue end
			if not entitysettings.NPCs and v.NPC then continue end
			if not v.Targetable then continue end
			local mag = (v[entitysettings.Part].Position - localPosition).Magnitude
			if mag > entitysettings.Range then continue end
			if entitylib.isVulnerable(v) then
				table.insert(sortingTable, {Entity = v, Magnitude = v.Target and -1 or mag})
			end
		end

		table.sort(sortingTable, entitysettings.Sort or function(a, b)
			return a.Magnitude < b.Magnitude
		end)

		for _, v in sortingTable do
			if entitysettings.Wallcheck then
				if entitylib.Wallcheck(localPosition, v.Entity[entitysettings.Part].Position, entitysettings.Wallcheck) then continue end
			end
			table.insert(returned, v.Entity)
			if #returned >= (entitysettings.Limit or math.huge) then break end
		end
		table.clear(sortingTable)
	end
	table.clear(entitysettings)
	return returned
end

entitylib.getEntity = function(char)
	for i, v in entitylib.List do
		if v.Player == char or v.Character == char then
			return v, i
		end
	end
end

entitylib.addEntity = function(char, plr, teamfunc)
	if not char then return end
	entitylib.EntityThreads[char] = task.spawn(function()
		local hum = waitForChildOfType(char, 'Humanoid', 10)
		local humrootpart = hum and waitForChildOfType(hum, 'RootPart', workspace.StreamingEnabled and 9e9 or 10, true)
		local head = char:WaitForChild('Head', 10) or humrootpart

		if hum and humrootpart then
			local entity = {
				Connections = {},
				Character = char,
				Health = hum.Health,
				Head = head,
				Humanoid = hum,
				HumanoidRootPart = humrootpart,
				HipHeight = hum.HipHeight + (humrootpart.Size.Y / 2) + (hum.RigType == Enum.HumanoidRigType.R6 and 2 or 0),
				MaxHealth = hum.MaxHealth,
				NPC = plr == nil,
				Player = plr,
				RootPart = humrootpart,
				TeamCheck = teamfunc
			}

			if plr == lplr then
				entitylib.character = entity
				entitylib.isAlive = true
				entitylib:GetEvent("LocalAdded"):Fire(entity)
			else
				entity.Targetable = entitylib.targetCheck(entity)

				for _, v in entitylib.getUpdateConnections(entity) do
					table.insert(entity.Connections, v:Connect(function()
						entity.Health = hum.Health
						entity.MaxHealth = hum.MaxHealth
						entitylib:GetEvent("EntityUpdated"):Fire(entity)
					end))
				end

				table.insert(entitylib.List, entity)
				entitylib:GetEvent("EntityAdded"):Fire(entity)
			end
			--[[table.insert(entity.Connections, char.ChildRemoved:Connect(function(part)
				if (part == humrootpart or part == hum or part == head) then
					local found = char:FindFirstChild(part.Name)
					if found then
						if part == humrootpart then
							entity.HumanoidRootPart = found
							entity.RootPart = found
							humrootpart = found
							return
						elseif part == head then
							entity.Head = found
							head = found
							return
						end
					end
					entitylib.removeEntity(char, plr == lplr)
				end
			end))]]
		end
		entitylib.EntityThreads[char] = nil
	end)
end

entitylib.removeEntity = function(char, localcheck)
	if localcheck then
		if entitylib.isAlive then
			entitylib.isAlive = false

			if entitylib.character and entitylib.character.Connections then
				for _, v in pairs(entitylib.character.Connections) do
					v:Disconnect()
				end
				table.clear(entitylib.character.Connections)
			end

			entitylib:GetEvent("LocalRemoved"):Fire(entitylib.character)
		end
		return
	end

	if char then
		if entitylib.EntityThreads[char] then
			task.cancel(entitylib.EntityThreads[char])
			entitylib.EntityThreads[char] = nil
		end

		local entity, ind = entitylib.getEntity(char)

		if ind and entity then
			if entity.Connections then
				for _, v in pairs(entity.Connections) do
					v:Disconnect()
				end
				table.clear(entity.Connections)
			end

			table.remove(entitylib.List, ind)
			entitylib:GetEvent("EntityRemoved"):Fire(entity)
		end
	end
end
entitylib.refreshEntity = function(char, plr)
	entitylib.removeEntity(char)
	entitylib.addEntity(char, plr)
end

entitylib.addPlayer = function(plr)
	if plr.Character then
		entitylib.refreshEntity(plr.Character, plr)
	end
	entitylib.PlayerConnections[plr] = {
		plr.CharacterAdded:Connect(function(char)
			entitylib.refreshEntity(char, plr)
		end),
		plr.CharacterRemoving:Connect(function(char)
			entitylib.removeEntity(char, plr == lplr)
		end),
		plr:GetPropertyChangedSignal('Team'):Connect(function()
			for _, v in entitylib.List do
				if v.Targetable ~= entitylib.targetCheck(v) then
					entitylib.refreshEntity(v.Character, v.Player)
				end
			end

			if plr == lplr then
				entitylib.start()
			else
				entitylib.refreshEntity(plr.Character, plr)
			end
		end)
	}
end

entitylib.removePlayer = function(plr)
	if entitylib.PlayerConnections[plr] then
		for _, v in entitylib.PlayerConnections[plr] do
			v:Disconnect()
		end
		table.clear(entitylib.PlayerConnections[plr])
		entitylib.PlayerConnections[plr] = nil
	end

	if plr == LocalPlayer then
		entitylib.removeEntity(nil, true)
	elseif plr.Character then
		entitylib.removeEntity(plr.Character)
	end
end
entitylib.start = function()
	if entitylib.Running then
		entitylib.stop()
	end
	table.insert(entitylib.Connections, playersService.PlayerAdded:Connect(function(v)
		entitylib.addPlayer(v)
	end))
	table.insert(entitylib.Connections, playersService.PlayerRemoving:Connect(function(v)
		entitylib.removePlayer(v)
	end))
	for _, v in playersService:GetPlayers() do
		entitylib.addPlayer(v)
	end
	table.insert(entitylib.Connections, workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
		gameCamera = workspace.CurrentCamera or workspace:FindFirstChildWhichIsA('Camera')
	end))
	entitylib.Running = true
end

entitylib.stop = function()
	for _, v in entitylib.Connections do
		v:Disconnect()
	end
	for _, v in entitylib.PlayerConnections do
		for _, v2 in v do
			v2:Disconnect()
		end
		table.clear(v)
	end
	entitylib.removeEntity(nil, true)
	local cloned = table.clone(entitylib.List)
	for _, v in cloned do
		entitylib.removeEntity(v.Character)
	end
	for _, v in entitylib.EntityThreads do
		task.cancel(v)
	end
	table.clear(entitylib.PlayerConnections)
	table.clear(entitylib.EntityThreads)
	table.clear(entitylib.Connections)
	table.clear(cloned)
	entitylib.Running = false
end

entitylib.kill = function()
	if entitylib.Running then
		entitylib.stop()
	end
	for _, v in entitylib.Events do
		v:Destroy()
	end
	entitylib.IgnoreObject:Destroy()
	loopClean(entitylib)
end

entitylib.refresh = function()
	local cloned = table.clone(entitylib.List)
	for _, v in cloned do
		entitylib.refreshEntity(v.Character, v.Player)
	end
	table.clear(cloned)
end

entitylib.start()

mainapi.Connections = mainapi.Connections or {}

local nextEntityStateUpdate = 0
table.insert(mainapi.Connections, RunService.Heartbeat:Connect(function()
	local now = os.clock()
	if now < nextEntityStateUpdate then return end
	nextEntityStateUpdate = now + 0.05
	local char = lplr.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("RootPart") or char.PrimaryPart)

	if root and humanoid and humanoid.Health > 0 then
		entitylib.character = entitylib.character or {}
		entitylib.character.RootPart = root
		entitylib.character.HumanoidRootPart = root
		entitylib.character.Humanoid = humanoid
		entitylib.isAlive = true
	else
		entitylib.character = nil
		entitylib.isAlive = false
	end
end))
mainapi.DeferredLoad = true
mainapi.FeatureQueue = {}
mainapi.FeatureLoadIndex = 0
mainapi.FeatureLoadComplete = false
shared.ModernLoading = true

local LionWindow, LionTabs = nil, {}
local LionLibrary, LionThemeManager, LionSaveManager

local function showLionWindow()
    if LionWindow and LionWindow.Holder then
        LionWindow.Holder.Visible = true
    end
    if LionLibrary and LionLibrary.Toggle then
        pcall(function()
            if LionWindow and LionWindow.Holder and not LionWindow.Holder.Visible then
                LionLibrary:Toggle()
            end
        end)
    end
end

local run = function(func)
    if mainapi.DeferredLoad then
        table.insert(mainapi.FeatureQueue, func)
    else
        func()
    end
end

function mainapi:StartBackgroundLoad()
    if self.FeatureLoadStarted then return end
    self.FeatureLoadStarted = true
    task.spawn(function()
        local queue = self.FeatureQueue
        local budget = 1
        while self.FeatureLoadIndex < #queue do
            local start = os.clock()
            for _ = 1, budget do
                self.FeatureLoadIndex += 1
                local fn = queue[self.FeatureLoadIndex]
                if not fn then break end
                local ok, err = pcall(fn)
                if not ok then
                    warn("[LionUI] feature load failed:", err)
                end
                if os.clock() - start > 0.012 then
                    break
                end
            end
            RunService.Heartbeat:Wait()
        end

        self.DeferredLoad = false
        self.FeatureLoadComplete = true
        table.clear(queue)
        showLionWindow()
        shared.ModernLoading = false
    end)
end

local textBoundsCache = {}

local getfontsize = function(text, size, font)

    local key = text .. "_" .. tostring(size) .. "_" .. tostring(font)

    if textBoundsCache[key] then
        return textBoundsCache[key]
    end

	fontsize.Text = text
	fontsize.Size = size

	if typeof(font) == "Font" then
		fontsize.Font = font
	end

	local bounds = TextService:GetTextBoundsAsync(fontsize)

	textBoundsCache[key] = bounds

	return bounds
end

local function getTableSize(tab)
	local ind = 0
	for _ in tab do ind += 1 end
	return ind
end

local function getTool()
	return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA('Tool', true) or nil
end

local store = {
	attackReach = 0,
	attackReachUpdate = tick(),
	damageBlockFail = tick(),
	hand = {},
	inventory = {
		inventory = {
			items = {},
			armor = {}
		},
		hotbar = {}
	},
	inventories = {},
	matchState = 0,
	queueType = 'bedwars_test',
	tools = {}
}
local Reach = {}
local HitBoxes = {}
local InfiniteFly = {}
local TrapDisabler
local AntiFallPart
local bedwars, remotes, sides, oldinvrender, oldSwing = {}, {}, {}


local function removeTags(str)
	str = str:gsub('<br%s*/>', '\n')
	return (str:gsub('<[^<>]->', ''))
end

local function isValidBind(bind)
	return typeof(bind) == "EnumItem"
end

local function inputMatchesBind(inputObj, bind)
	if not isValidBind(bind) then
		return false
	end

	if bind.EnumType == Enum.KeyCode then
		return inputObj.UserInputType == Enum.UserInputType.Keyboard and inputObj.KeyCode == bind
	end

	if bind.EnumType == Enum.UserInputType then
		return inputObj.UserInputType == bind
	end

	return false
end

local function addMaid(object)
	object.Connections = object.Connections or {}

	function object:Clean(callback)
		if typeof(callback) == 'Instance' then
			table.insert(self.Connections, {
				Disconnect = function()
					callback:ClearAllChildren()
					callback:Destroy()
				end
			})
		elseif type(callback) == 'function' then
			table.insert(self.Connections, {
				Disconnect = callback
			})
		else
			table.insert(self.Connections, callback)
		end
	end
end

addMaid(mainapi)

local function makeDraggable(obj, window)
	obj.InputBegan:Connect(function(inputObj)
		if not mainapi.ClickGuiStatus then return end
		if
			(inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
			and (inputObj.Position.Y - obj.AbsolutePosition.Y < 40 or window)
		then
			local dragPosition = Vector2.new(obj.AbsolutePosition.X - inputObj.Position.X, obj.AbsolutePosition.Y - inputObj.Position.Y + GuiService:GetGuiInset().Y) / mainapi.Scale.Value
			local changed = UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
					local position = input.Position
					if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
						dragPosition = Vector2.new(math.floor(dragPosition.X / 3) * 3, math.floor(dragPosition.Y / 3) * 3)
						position = Vector3.new(math.floor(position.X / 3) * 3, math.floor(position.Y / 3) * 3, position.Z)
					end
					obj.Position = UDim2.fromOffset((position.X / mainapi.Scale.Value) + dragPosition.X, (position.Y / mainapi.Scale.Value) + dragPosition.Y)
				end
			end)

			local ended
			ended = inputObj.Changed:Connect(function()
				if inputObj.UserInputState == Enum.UserInputState.End then
					if changed then
						changed:Disconnect()
					end
					if ended then
						ended:Disconnect()
					end
                    pcall(SaveConfig, true)
				end
			end)
		end
	end)
end

local function addCorner(parent, radius)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = radius or UDim.new(0, 5)
	corner.Parent = parent

	return corner
end

local function addBlur(parent)
	local blur = Instance.new('ImageLabel')
	blur.Name = 'Blur'
	blur.Size = UDim2.new(1, 89, 1, 52)
	blur.Position = UDim2.fromOffset(-48, -31)
	blur.BackgroundTransparency = 1
	blur.Image = "rbxassetid://74663567791967"
	blur.ScaleType = Enum.ScaleType.Slice
	blur.SliceCenter = Rect.new(52, 31, 261, 502)
    blur.ZIndex = -100
	blur.Parent = parent

	return blur
end

local function loopClean(tab)
	for i, v in tab do
		if type(v) == 'table' then
			loopClean(v)
		end
		tab[i] = nil
	end
end

local function loadJson(path)
	local suc, res = pcall(function()
		return HttpService:JSONDecode(readfile(path))
	end)
	return suc and type(res) == 'table' and res or nil
end

local uipallet = {
    MainColor = Color3.fromRGB(0, 0, 0);
    SecondaryColor = Color3.fromRGB(255, 255, 255);
}

local function getBlendFactor(vec)
    return math.sin(DateTime.now().UnixTimestampMillis / 600 + vec.X * 0.005 + vec.Y * 0.06) * 0.5 + 0.5
end

function mainapi:GetColor(vec)
    local blend = getBlendFactor(vector.create(vec.x,0))
    if uipallet.ThirdColor then
        if blend <= 0.5 then
            return uipallet.MainColor:Lerp(uipallet.SecondaryColor, blend * 2)
        end
        return uipallet.SecondaryColor:Lerp(uipallet.ThirdColor, (blend - 0.5) * 2)
    end
    return uipallet.SecondaryColor:Lerp(uipallet.MainColor, blend)
end

local InterfaceMode = {}
local Gradients = {}
local gradientUpdateInterval = 1 / 15
local nextGradientUpdate = 0

local function buildGradientKeypoints(parent)
    local keypoints = {}
    if InterfaceMode.Value ~= "Static" then
        for i = 0, mainapi.GradientKeypoints do
            local position = i / mainapi.GradientKeypoints
            local offset = parent.AbsoluteSize * position
            table.insert(keypoints, ColorSequenceKeypoint.new(position, mainapi:GetColor(InterfaceMode.Value ~= "Breathe" and parent.AbsolutePosition + offset or vector.zero)))
        end
    else
        table.insert(keypoints, ColorSequenceKeypoint.new(0, uipallet.MainColor))
        if uipallet.ThirdColor then
            table.insert(keypoints, ColorSequenceKeypoint.new(0.5, uipallet.SecondaryColor))
            table.insert(keypoints, ColorSequenceKeypoint.new(1, uipallet.ThirdColor))
        else
            table.insert(keypoints, ColorSequenceKeypoint.new(1, uipallet.SecondaryColor))
        end
    end
    return keypoints
end

local function addGradient(parent)
    local UIGradient = Instance.new('UIGradient')
    UIGradient.Color = ColorSequence.new(buildGradientKeypoints(parent))
    table.insert(Gradients,UIGradient)
    UIGradient.Parent = parent
    return UIGradient
end

mainapi:Clean(RunService.PreSimulation:Connect(function()
    local now = os.clock()
    if now < nextGradientUpdate then return end
    nextGradientUpdate = now + gradientUpdateInterval

	for i = #Gradients, 1, -1 do
        local v = Gradients[i]
		if v.Parent then
			v.Color = ColorSequence.new(buildGradientKeypoints(v.Parent))
        else
            table.remove(Gradients, i)
		end
	end
    uipallet.FinalColor = mainapi:GetColor(vector.zero)
end))

local lplr = Players.LocalPlayer


local function updateChar()
    local char = lplr.Character
    if not char then
        entitylib.isAlive = false
        entitylib.character = nil
        return
    end

    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if root and hum and hum.Health > 0 then
        entitylib.isAlive = true
        entitylib.character = {
            Character = char,
            RootPart = root,
            Humanoid = hum,
            HipHeight = hum.HipHeight or 2
        }
    else
        entitylib.isAlive = false
        entitylib.character = nil
    end
end

-- ?饔낅?????? ??????????
updateChar()

table.insert(mainapi.Connections, lplr.CharacterAdded:Connect(function()
    task.wait(1)
    updateChar()
end))

local nextCharUpdate = 0

table.insert(mainapi.Connections, RunService.Heartbeat:Connect(function()
    local now = os.clock()
    if now < nextCharUpdate then return end

    nextCharUpdate = now + 0.25
    updateChar()
end))

if shared.Modern then
    shared.Modern:Uninject()
end

mainapi.Libraries = {
	entitylib = entitylib;
	getfontsize = getfontsize;
	uipallet = uipallet;
    addGradient = addGradient;
}

local SoundEffect = Instance.new("Sound")
SoundEffect.SoundId = "rbxassetid://137273815815490"
SoundEffect.TimePosition = 0.21
SoundEffect.PlayOnRemove = true

local Main, ClickGui, Gradient, Gradient2, NotifyList, ArrayList
local UICornors = {}
local LionGroupState = { left = {}, right = {} }
local LionKeybindModules = {
    ["Silent Aim"] = true,
    ["Triggerbot"] = true,
    ["Animation Player"] = true,
    ["Phase"] = true,
    ["Fly"] = true,
    ["Speed"] = true,
}

local function lionId(...)
    local out = {}
    for _, item in ipairs({...}) do
        local text = tostring(item or ""):gsub("[^%w_]", "_")
        table.insert(out, text)
    end
    return table.concat(out, "_")
end

local function lionDefault(list, value)
    if value == nil then return 1 end
    if typeof(value) == "string" then
        for i, v in ipairs(list or {}) do
            if v == value then return i end
        end
    end
    return value
end

local function lionCreateBaseGui()
    Main = Instance.new("Frame")
    Main.Name = "LionRuntime"
    Main.Size = UDim2.fromScale(1, 1)
    Main.BackgroundTransparency = 1
    Main.Parent = mainapi.MainScreenGui

    ClickGui = Instance.new("Frame")
    ClickGui.Name = "ClickGui"
    ClickGui.Size = UDim2.fromScale(1, 1)
    ClickGui.BackgroundTransparency = 1
    ClickGui.Parent = mainapi.MainScreenGui
    local scale = Instance.new("UIScale")
    scale.Scale = 1
    scale.Parent = ClickGui

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.fromScale(1, 1)
    modal.BackgroundTransparency = 1
    modal.Visible = false
    modal.Parent = mainapi.MainScreenGui

    Gradient = Instance.new("ImageLabel")
    Gradient.Name = "Gradient"
    Gradient.BackgroundTransparency = 1
    Gradient.ImageTransparency = 1
    Gradient.Transparency = 1
    Gradient.Size = UDim2.fromScale(1, 1)
    Gradient.Parent = Main

    Gradient2 = Gradient:Clone()
    Gradient2.Name = "Gradient2"
    Gradient2.Parent = Main

    NotifyList = Instance.new("Frame")
    NotifyList.Name = "NotifyList"
    NotifyList.Size = UDim2.fromScale(0.25, 1)
    NotifyList.Position = UDim2.fromScale(1, 0)
    NotifyList.AnchorPoint = Vector2.new(1, 0)
    NotifyList.BackgroundTransparency = 1
    NotifyList.Parent = Main
    local notifyLayout = Instance.new("UIListLayout")
    notifyLayout.FillDirection = Enum.FillDirection.Vertical
    notifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    notifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    notifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifyLayout.Padding = UDim.new(0, 6)
    notifyLayout.Parent = NotifyList

    ArrayList = Instance.new("Frame")
    ArrayList.Name = "ArrayList"
    ArrayList.Size = UDim2.fromScale(1, 1)
    ArrayList.BackgroundTransparency = 1
    ArrayList.Visible = false
    ArrayList.Parent = Main
    local arrayLayout = Instance.new("UIListLayout")
    arrayLayout.FillDirection = Enum.FillDirection.Vertical
    arrayLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    arrayLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    arrayLayout.SortOrder = Enum.SortOrder.LayoutOrder
    arrayLayout.Parent = ArrayList
end

local function lionRouteModule(catalogName, moduleName)
    if moduleName == "Interface" then
        return "settings", "menu", "left"
    elseif moduleName == "Silent Aim" then
        return "main", "main_aim::silent aim", "lefttab"
    elseif moduleName == "Aim Assist" then
        return "main", "main_aim::aimbot", "lefttab"
    elseif moduleName == "Auto Clicker" then
        return "main", "triggerbot", "right"
    elseif moduleName == "Triggerbot" then
        return "main", "triggerbot", "right"
    elseif moduleName == "Rage Silent" then
        return "main", "weapons", "right"
    elseif moduleName == "Weapons" then
        return "main", "weapons", "right"
    elseif moduleName == "Ragebot" then
        return "main", "ragebot_tabs::ragebot", "righttab"
    elseif moduleName == "ESP" then
        return "esp", "esp::options", "lefttab"
    elseif moduleName == "Color Correction" then
        return "world", "left_top::color correction", "lefttab"
    elseif moduleName == "Atmosphere" then
        return "world", "left_top::atmosphere", "lefttab"
    elseif moduleName == "Lighting" then
        return "world", "lighting", "left"
    elseif moduleName == "Skybox" then
        return "world", "right_top::skybox", "righttab"
    elseif moduleName == "Weather" then
        return "world", "right_top::weather", "righttab"
    elseif moduleName == "Ambience" then
        return "world", "right_top::ambience", "righttab"
    elseif moduleName == "Bloom" then
        return "world", "right_mid::bloom", "righttab"
    elseif moduleName == "Sun Rays" then
        return "world", "right_mid::sun rays", "righttab"
    elseif moduleName == "Camera" then
        return "world", "camera", "right"
    elseif moduleName == "Movement" then
        return "character", "movement", "left"
    elseif moduleName == "noclip" then
        return "character", "character", "right"
    elseif moduleName == "Fly" then
        return "character", "character", "right"
    elseif moduleName == "Third Person" then
        return "character", "third person", "right"
    elseif moduleName == "Anti Aim" then
        return "character", "anti aim", "right"
    elseif moduleName == "Animation Player" then
        return "character", "animation player", "left"
    elseif moduleName == "ESP Override Appearance" then
        return "esp", "override appearance", "right"
    elseif moduleName == "ESP Highlight" then
        return "esp", "esp_right::highlight", "righttab"
    elseif moduleName == "ESP Customization" then
        return "esp", "customization", "right"
    elseif moduleName == "viewmodel" then
        return "visuals", "left_top::viewmodel", "lefttab"
    elseif moduleName == "override" then
        return "visuals", "left_top::override", "lefttab"
    elseif moduleName == "item" then
        return "visuals", "left_top::item", "lefttab"
    elseif moduleName == "custom tracers" then
        return "visuals", "left_mid::custom tracers", "lefttab"
    elseif moduleName == "shoot sound" then
        return "visuals", "left_mid::shoot sound", "lefttab"
    elseif moduleName == "crosshair" then
        return "visuals", "crosshair", "left"
    elseif moduleName == "hit effects" then
        return "visuals", "right_top::hit effects", "righttab"
    elseif moduleName == "hit sounds" then
        return "visuals", "right_top::hit sounds", "righttab"
    elseif moduleName == "target hud" then
        return "visuals", "target hud", "right"
    elseif moduleName == "indicators" then
        return "visuals", "indicators", "right"
    elseif moduleName == "target" then
        return "visuals", "target", "right"
    elseif moduleName == "auto load" then
        return "misc", "auto load", "left"
    elseif moduleName == "loadout" then
        return "misc", "loadout", "left"
    elseif moduleName == "chat spam" then
        return "misc", "chat spam", "left"
    elseif moduleName == "auto queue" then
        return "misc", "right_top::auto queue", "righttab"
    elseif moduleName == "auto ban" then
        return "misc", "right_top::auto ban", "righttab"
    elseif moduleName == "Name Spoofer" then
        return "misc", "spoofers::name spoofer", "righttab"
    elseif moduleName == "Device Spoofer" then
        return "misc", "spoofers::spoof device", "righttab"
    elseif moduleName == "Arcade" then
        return "misc", "arcade", "right"
    elseif moduleName == "Hit Notifier" then
        return "misc", "notify hit", "right"
    elseif moduleName == "Uninject" then
        return "misc", "uninject", "right"
    end

    if catalogName == "Render" then
        return "visuals", moduleName:lower(), "left"
    elseif catalogName == "Movement" then
        return "world", moduleName:lower(), "left"
    elseif catalogName == "Player" then
        return "character", moduleName:lower(), "left"
    elseif catalogName == "Other" then
        return "misc", moduleName:lower(), "left"
    elseif catalogName == "Combat" then
        return "main", moduleName:lower(), "right"
    end

    return "misc", moduleName:lower(), "left"
end

local function lionGetGroup(tabName, groupName, side)
    local tab = LionTabs[tabName] or LionTabs.misc or LionTabs.main
    local key = tabName .. "::" .. groupName .. "::" .. side
    local store = side == "right" and LionGroupState.right or LionGroupState.left
    if store[key] then return store[key] end

    local group
    if side == "lefttab" or side == "righttab" then
        local boxName, tabTitle = groupName:match("^([^:]+)::(.+)")
        boxName = boxName or groupName
        tabTitle = tabTitle or groupName
        local boxKey = tabName .. "::" .. boxName .. "::" .. side .. "::tabbox"
        local tabbox = store[boxKey]

        if not tabbox then
            local addTabbox = side == "righttab" and tab.AddRightTabbox or tab.AddLeftTabbox
            if addTabbox then
                tabbox = addTabbox(tab)
            else
                tabbox = side == "righttab" and tab:AddRightGroupbox(tabTitle) or tab:AddLeftGroupbox(tabTitle)
            end
            store[boxKey] = tabbox
        end

        if tabbox.AddTab then
            group = tabbox:AddTab(tabTitle)
        else
            group = tabbox
        end
    else
        group = side == "right" and tab:AddRightGroupbox(groupName) or tab:AddLeftGroupbox(groupName)
    end

    store[key] = group
    return group
end

local function lionCreateFallbackLibrary(reason)
    warn("[Overlay] Linoria load failed, using fallback UI:", reason)

    Toggles = Toggles or {}
    Options = Options or {}

    local function makeOption(store, id, default)
        local option = store[id] or { Value = default }
        option.Value = option.Value == nil and default or option.Value
        option.Properties = option.Properties or {}

        function option:SetValue(value)
            self.Value = value
        end

        function option:SetValueRGB(value)
            self.Value = value
        end

        function option:OnClick(callback)
            self.Callback = callback
        end

        function option:AddKeyPicker(keyId, config)
            return makeOption(Options, keyId, config and config.Default or "None")
        end

        function option:AddColorPicker(keyId, config)
            return makeOption(Options, keyId, config and config.Default or Color3.fromRGB(255, 255, 255))
        end

        store[id] = option
        return option
    end

    local group = {}

    function group:AddToggle(id, config)
        local toggle = makeOption(Toggles, id, config and config.Default or false)
        function toggle:SetValue(value)
            self.Value = value == true
            if config and config.Callback then
                task.spawn(config.Callback, self.Value)
            end
        end
        return toggle
    end

    function group:AddSlider(id, config)
        return makeOption(Options, id, config and config.Default or 0)
    end

    function group:AddDropdown(id, config)
        return makeOption(Options, id, config and config.Default or nil)
    end

    function group:AddInput(id, config)
        return makeOption(Options, id, config and config.Default or "")
    end

    function group:AddLabel(text)
        return makeOption(Options, "Label_" .. lionId(text), text)
    end

    function group:AddButton(config)
        return {
            Text = config and config.Text or "button",
            Func = config and config.Func or function() end,
        }
    end

    local tab = {
        AddLeftGroupbox = function()
            return group
        end,
        AddRightGroupbox = function()
            return group
        end,
        AddLeftTabbox = function()
            return {
                AddTab = function()
                    return group
                end,
            }
        end,
        AddRightTabbox = function()
            return {
                AddTab = function()
                    return group
                end,
            }
        end,
    }

    local library = {
        KeybindFrame = { Visible = false },
        CreateWindow = function()
            return {
                AddTab = function()
                    return tab
                end,
            }
        end,
        Unload = function() end,
    }

    local manager = setmetatable({}, {
        __index = function()
            return function() end
        end,
    })

    return library, manager, manager
end

local function lionLoadRemoteModule(url)
    local ok, result = pcall(function()
        local source = game:HttpGet(url)
        local loader = loadstring(source)
        if type(loader) ~= "function" then
            error("loadstring did not return a function")
        end
        return loader()
    end)

    if ok then
        return result
    end

    error(tostring(result), 2)
end

local function lionFixSaveManager(saveManager)
    if type(saveManager) ~= "table" then return saveManager end

    local folder = "Overlay"
    local settingsFolder = folder .. "/settings"

    function saveManager:BuildFolderTree()
        if not makefolder or not isfolder then return end
        for _, path in ipairs({folder, folder .. "/themes", settingsFolder}) do
            if not isfolder(path) then
                makefolder(path)
            end
        end
    end

    function saveManager:SetFolder()
        self.Folder = folder
        self:BuildFolderTree()
    end

    function saveManager:RefreshConfigList()
        self.Folder = folder
        self:BuildFolderTree()

        local ok, files = pcall(listfiles, settingsFolder)
        if not ok or type(files) ~= "table" then return {} end

        local seen, names = {}, {}
        for _, file in ipairs(files) do
            local normalized = tostring(file):gsub("\\", "/")
            local name = normalized:match("([^/]+)%.json")
            if name and not seen[name] then
                seen[name] = true
                table.insert(names, name)
            end
        end
        table.sort(names, function(a, b)
            return a:lower() < b:lower()
        end)
        return names
    end

    saveManager.Folder = folder
    saveManager:BuildFolderTree()
    return saveManager
end

function mainapi:CreateGUI()
    if mainapi.ThreadFix and setthreadidentity then
        pcall(setthreadidentity, 8)
    end

    mainapi.MainScreenGui.Name = "Overlay"
    mainapi.MainScreenGui.ResetOnSpawn = false
    mainapi.MainScreenGui.IgnoreGuiInset = true
    local guiParent = CoreGui
    if type(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and hui then
            guiParent = hui
        end
    end
    mainapi.MainScreenGui.Parent = guiParent
    lionCreateBaseGui()

    local repo = "https://raw.githubusercontent.com/jmk-arch/RivalsUI/main/"
    local ok, library, themeManager, saveManager = pcall(function()
        return lionLoadRemoteModule(repo .. "test-branch.lua"),
            lionLoadRemoteModule(repo .. "addons/ThemeManager.lua"),
            lionLoadRemoteModule(repo .. "addons/SaveManager.lua")
    end)

    if ok and type(library) == "table" then
        LionLibrary = library
        LionThemeManager = type(themeManager) == "table" and themeManager or select(2, lionCreateFallbackLibrary("ThemeManager unavailable"))
        LionSaveManager = type(saveManager) == "table" and saveManager or select(3, lionCreateFallbackLibrary("SaveManager unavailable"))
    else
        LionLibrary, LionThemeManager, LionSaveManager = lionCreateFallbackLibrary(library)
    end
    LionSaveManager = lionFixSaveManager(LionSaveManager)

    pcall(function()
        if LionLibrary.NotificationStyle then
            LionLibrary.NotificationStyle.Transparency = 0.3
        end

        local holder = LionLibrary.NotificationAreaHolder
        local area = LionLibrary.NotificationArea

        if holder then
            holder.AnchorPoint = Vector2.new(0.5, 1)
            holder.Position = UDim2.new(0.5, 0, 1, -120)
            holder.Size = UDim2.new(0, 520, 0, 220)
        end

        if area then
            local layout = area:FindFirstChildOfClass("UIListLayout")
            if layout then
                layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            end
        end

        if type(LionLibrary.Notify) == "function" and not LionLibrary.__LionTransparentNotify then
            local oldNotify = LionLibrary.Notify
            LionLibrary.__LionTransparentNotify = true
            LionLibrary.Notify = function(self, text, time, ...)
                local result = {oldNotify(self, text, time, ...)}

                task.spawn(function()
                    task.wait()
                    local notifyArea = self.NotificationArea
                    if notifyArea then
                        for _, object in ipairs(notifyArea:GetDescendants()) do
                            if object:IsA("Frame") and object.Name ~= "bar" then
                                object.BackgroundTransparency = 0.3
                            end
                        end
                    end
                end)

                return unpack(result)
            end
        end
    end)

    LionWindow = LionLibrary:CreateWindow({
        Title = "Harion Enchantments - https://discord.gg/KXqBHaNXxX",
        Center = true,
        AutoShow = false,
        TabPadding = 6,
        MenuFadeTime = 0.12,
    })
    if LionWindow and LionWindow.Holder then
        LionWindow.Holder.Visible = false
        -- 아주 살짝 크게 + 모서리 느낌
        local uiScale = Instance.new("UIScale")
        uiScale.Name = "RuelScale"
        uiScale.Scale = 1.07
        uiScale.Parent = LionWindow.Holder

        pcall(function()
            for _, obj in ipairs(LionWindow.Holder:GetDescendants()) do
                if obj:IsA("UICorner") then
                    local r = obj.CornerRadius
                    if r and r.Offset < 10 then
                        obj.CornerRadius = UDim.new(0, math.min(r.Offset + 2, 10))
                    end
                end
            end
        end)
    end
    pcall(function()
        mainapi:Clean(LionLibrary:OnEvent("VisibilityChanged"):Connect(function(open)
            mainapi.ClickGuiStatus = open == true
            setMenuBlur(mainapi.ClickGuiStatus)
        end))
    end)

    LionTabs = {
        main = LionWindow:AddTab("main"),
        world = LionWindow:AddTab("world"),
        esp = LionWindow:AddTab("esp"),
        visuals = LionWindow:AddTab("visuals"),
        character = LionWindow:AddTab("character"),
        misc = LionWindow:AddTab("misc"),
        settings = LionWindow:AddTab("settings"),
    }
    
lionGetGroup("main", "triggerbot", "right")
lionGetGroup("main", "weapons", "right")

    if LionLibrary.KeybindFrame then
        LionLibrary.KeybindFrame.Visible = true
    end

    self.AddCatalog = function(self, arg)
        local Catalog = {
            Name = arg["Name"] or "",
            Modules = {},
            Frame = Instance.new("Frame"),
            AddModule = function() end,
        }

        Catalog.AddModule = function(self, arg)
            local moduleName = arg["Name"] or ""
            local tabName, groupName, side = lionRouteModule(Catalog.Name, moduleName)
            local group = lionGetGroup(tabName, groupName, side)
            local function getOptionGroup(option)
                if not option["Tab"] then return group end
                if option["SeparateGroup"] then
                    return lionGetGroup(tabName, option["Tab"], option["Side"] or "left")
                end
                local boxName = groupName:match("^([^:]+)::") or groupName
                return lionGetGroup(tabName, boxName .. "::" .. option["Tab"], side)
            end
            local toggleId = lionId("Module", Catalog.Name, moduleName, "Enabled")
            local Module = {
                Name = moduleName,
                Frame = Instance.new("Frame"),
                Children = Instance.new("Frame"),
                Expanded = arg["Expanded"] or false,
                Enabled = arg["Enabled"] or arg["Default"] or false,
                HideEnabled = arg["HideEnabled"] or arg["NoEnabled"] or false,
                ExtraText = arg["ExtraText"] or function() return "" end,
                Bind = nil,
                SearchVisible = true,
                Value = arg["Color"] or arg["ColorDefault"],
                Colors = arg["Colors"],
                ColorTransparency = arg["ColorTransparency"] or (arg["Colors"] and {0, 0, 0}),
                Settings = {},
                Connections = {},
                Function = arg["Function"] or function() end,
                Groupbox = group,
                ToggleId = toggleId,
            }
            addMaid(Module)

            local function setModule(value)
                value = value == true
                if Module.Enabled == value then return end
                Module.Enabled = value
                if not Module.Enabled then
                    for _, v in Module.Connections do pcall(function() v:Disconnect() end) end
                    table.clear(Module.Connections)
                end
                mainapi:UpdateArrayList()
                task.spawn(Module.Function, Module.Enabled)
                pcall(SaveConfig)
            end

            if not Module.HideEnabled then
                group:AddToggle(toggleId, {
                    Text = "enabled",
                    Default = Module.Enabled,
                    Callback = setModule,
                })
                if Toggles and Toggles[toggleId] then
                    Toggles[toggleId].Properties = Toggles[toggleId].Properties or {}
                    local moduleColorReady = false
                    if Toggles[toggleId].AddColorPicker and Module.Colors then
                        for i, color in ipairs(Module.Colors) do
                            Toggles[toggleId]:AddColorPicker(lionId("Color", Module.Name, "enabled", tostring(i)), {
                                Default = color,
                                Title = Module.Name .. " enabled " .. tostring(i),
                                Transparency = Module.ColorTransparency and Module.ColorTransparency[i] or 0,
                                Callback = function(value, transparency)
                                    Module.Colors[i] = value
                                    if Module.ColorTransparency then
                                        Module.ColorTransparency[i] = transparency ~= nil and transparency or 0
                                    end
                                    Module.Value = Module.Colors[1]
                                    if moduleColorReady then
                                        task.spawn(function()
                                            pcall(Module.Function, Module.Enabled)
                                        end)
                                        pcall(SaveConfig)
                                    end
                                end,
                            })
                        end
                        Module.Value = Module.Colors[1]
                    elseif Toggles[toggleId].AddColorPicker and Module.Value then
                        Toggles[toggleId]:AddColorPicker(lionId("Color", Module.Name, "enabled"), {
                            Default = Module.Value,
                            Title = Module.Name .. " enabled",
                            Callback = function(value)
                                Module.Value = value
                                if moduleColorReady then
                                    task.spawn(function()
                                        pcall(Module.Function, Module.Enabled)
                                    end)
                                    pcall(SaveConfig)
                                end
                            end,
                        })
                    end
                    moduleColorReady = true
                end
            else
                Module.Enabled = true
            end

            local keyPickerId
            local updatingBind = false
            if not Module.HideEnabled and LionKeybindModules[moduleName] and Toggles and Toggles[toggleId] and Toggles[toggleId].AddKeyPicker then
                keyPickerId = lionId("Key", Catalog.Name, moduleName)
                local keyConfig = {
                    Default = "None",
                    SyncToggleState = true,
                    Mode = "Toggle",
                    Text = moduleName,
                    NoUI = true,
                    Callback = function(key)
                        if updatingBind then return end
                        Module:SetBind(key)
                    end,
                }
                Toggles[toggleId]:AddKeyPicker(keyPickerId, keyConfig)
            end

            function Module:Toggle(val)
                local target = val
                if target == nil then target = not Module.Enabled end
                if Toggles and Toggles[toggleId] then
                    Toggles[toggleId]:SetValue(target == true)
                else
                    setModule(target)
                end
            end

            function Module:SetBind(key)
                if type(key) == "string" then
                    local parsed
                    pcall(function()
                        parsed = Enum.KeyCode[key]
                    end)
                    if not parsed then
                        pcall(function()
                            parsed = Enum.UserInputType[key]
                        end)
                    end
                    key = parsed
                end

                Module.Bind = isValidBind(key) and key or nil
                if keyPickerId and Options and Options[keyPickerId] and Options[keyPickerId].SetValue then
                    pcall(function()
                        updatingBind = true
                        Options[keyPickerId]:SetValue(Module.Bind and Module.Bind.Name or "None")
                        updatingBind = false
                    end)
                end
                updatingBind = false
                pcall(SaveConfig)
            end

            function Module:Expand()
                Module.Expanded = not Module.Expanded
            end

            function Module:Delete()
                if Module.Enabled then Module:Toggle(false) end
                for _, v in Module.Connections do pcall(function() v:Disconnect() end) end
                table.clear(Module.Connections)
                mainapi.Modules[Module.Name] = nil
                Catalog.Modules[Module.Name] = nil
            end

            function Module.AddToggle(self, arg)
                local optionGroup = getOptionGroup(arg)
                local id = lionId("Toggle", Module.Name, arg["Name"] or arg["Text"] or "Option")
                local initialized = false
                local Toggle = {
                    Name = arg["Name"] or arg["Text"] or "",
                    Frame = Instance.new("Frame"),
                    Enabled = arg["Enabled"] or arg["Default"] or false,
                    Value = arg["Color"] or arg["ColorDefault"],
                    Colors = arg["Colors"],
                    ColorTransparency = arg["ColorTransparency"] or (arg["Colors"] and {0, 0, 0}),
                    Function = arg["Function"] or arg["function"] or function() end,
                }
                local toggleObj = optionGroup:AddToggle(id, {
                    Text = arg["Text"] or Toggle.Name,
                    Default = Toggle.Enabled,
                    Callback = function(value)
                        Toggle.Enabled = value == true
                        if initialized then
                            task.spawn(function()
                                pcall(Toggle.Function, Toggle.Enabled)
                            end)
                        end
                        pcall(SaveConfig)
                    end,
                })
                toggleObj = toggleObj or (Toggles and Toggles[id])
                if toggleObj and toggleObj.AddColorPicker and Toggle.Colors then
                    for i, color in ipairs(Toggle.Colors) do
                        toggleObj:AddColorPicker(lionId("Color", Module.Name, Toggle.Name, tostring(i)), {
                            Default = color,
                            Title = Toggle.Name .. " " .. tostring(i),
                            Transparency = Toggle.ColorTransparency and Toggle.ColorTransparency[i] or 0,
                            Callback = function(value, transparency)
                                Toggle.Colors[i] = value
                                if Toggle.ColorTransparency then
                                    Toggle.ColorTransparency[i] = transparency ~= nil and transparency or 0
                                end
                                Toggle.Value = Toggle.Colors[1]
                                if initialized and Module.Name ~= "ESP" then
                                    task.spawn(function()
                                        pcall(Toggle.Function, Toggle.Enabled)
                                    end)
                                end
                                pcall(SaveConfig)
                            end,
                        })
                    end
                    Toggle.Value = Toggle.Colors[1]
                elseif toggleObj and toggleObj.AddColorPicker and Toggle.Value then
                    toggleObj:AddColorPicker(lionId("Color", Module.Name, Toggle.Name), {
                        Default = Toggle.Value,
                        Title = Toggle.Name,
                        Callback = function(value)
                            Toggle.Value = value
                            if initialized then
                                task.spawn(function()
                                    pcall(Toggle.Function, Toggle.Enabled)
                                end)
                            end
                            pcall(SaveConfig)
                        end,
                    })
                end
                initialized = true
                function Toggle:Toggle(val)
                    local target = val
                    if target == nil then target = not Toggle.Enabled end
                    if Toggles and Toggles[id] then
                        Toggles[id]:SetValue(target == true)
                else
                    Toggle.Enabled = target == true
                    task.spawn(function()
                        pcall(Toggle.Function, Toggle.Enabled)
                    end)
                end
                end
                function Toggle:Save(tab)
                    tab[Toggle.Name] = { Enabled = Toggle.Enabled }
                    if Toggle.Value then
                        tab[Toggle.Name].Value = { R = Toggle.Value.R, G = Toggle.Value.G, B = Toggle.Value.B }
                    end
                    if Toggle.Colors then
                        tab[Toggle.Name].Colors = {}
                        for i, color in ipairs(Toggle.Colors) do
                            tab[Toggle.Name].Colors[i] = {
                                R = color.R,
                                G = color.G,
                                B = color.B,
                                Transparency = Toggle.ColorTransparency and Toggle.ColorTransparency[i] or 0,
                            }
                        end
                    end
                end
                function Toggle:Load(tab)
                    if tab and tab.Colors and Toggle.Colors then
                        for i, color in ipairs(tab.Colors) do
                            if color and color.R and color.G and color.B then
                                Toggle.Colors[i] = Color3.new(color.R, color.G, color.B)
                                if Toggle.ColorTransparency then
                                    Toggle.ColorTransparency[i] = color.Transparency ~= nil and color.Transparency or Toggle.ColorTransparency[i]
                                end
                                local colorId = lionId("Color", Module.Name, Toggle.Name, tostring(i))
                                if Options and Options[colorId] then
                                    Options[colorId]:SetValueRGB(Toggle.Colors[i])
                                end
                            end
                        end
                        Toggle.Value = Toggle.Colors[1]
                    end
                    if tab and tab.Value then
                        Toggle.Value = Color3.new(tab.Value.R or 1, tab.Value.G or 1, tab.Value.B or 1)
                    end
                    if tab and tab.Enabled ~= nil then Toggle:Toggle(tab.Enabled) end
                end
                Module.Settings[Toggle.Name] = Toggle
                return Toggle
            end

            function Module.AddSlider(self, arg)
                local optionGroup = getOptionGroup(arg)
                local id = lionId("Slider", Module.Name, arg["Name"] or "Value")
                local initialized = false
                local min = arg["Min"] or arg["min"] or 1
                local max = arg["Max"] or arg["max"] or 100
                local default = arg["default"] or arg["Default"] or arg["Value"] or min
                local decimal = arg["Decimal"] or arg["decimal"] or 1
                local rounding = decimal > 1 and math.max(0, math.ceil(math.log10(decimal))) or 0
                local Slider = {
                    Name = arg["Name"] or "",
                    Frame = Instance.new("Frame"),
                    Min = min,
                    Max = max,
                    Value = default,
                    Decimal = decimal,
                    Suffix = arg["Suffix"],
                    Function = arg["Function"] or arg["function"] or function() end,
                }
                local sliderConfig = {
                    Text = arg["Text"] or Slider.Name,
                    Default = default,
                    Min = min,
                    Max = max,
                    Rounding = rounding,
                    Suffix = type(Slider.Suffix) == "string" and Slider.Suffix or nil,
                    Compact = arg["Compact"] == true,
                    Callback = function(value)
                        Slider.Value = value
                        if initialized then
                            task.spawn(function()
                                pcall(Slider.Function, value)
                            end)
                        end
                        pcall(SaveConfig)
                    end,
                }
                local parentOption = arg["Parent"] and arg["Parent"]._LionOption
                local lionOption
                if parentOption and parentOption.AddSlider then
                    lionOption = parentOption:AddSlider(id, sliderConfig)
                else
                    lionOption = optionGroup:AddSlider(id, sliderConfig)
                end
                Slider._LionOption = lionOption
                initialized = true
                function Slider:Save(tab) tab[Slider.Name] = { Min = Slider.Min, Max = Slider.Max, Value = Slider.Value } end
                function Slider:Load(tab)
                    if tab and tab.Value ~= nil then
                        Slider.Value = tab.Value
                        if Options and Options[id] then Options[id]:SetValue(tab.Value) end
                    end
                end
                Module.Settings[Slider.Name] = Slider
                return Slider
            end

            local function addDropdown(arg)
                local optionGroup = getOptionGroup(arg)
                local id = lionId("Dropdown", Module.Name, arg["Name"] or "Value")
                local initialized = false
                local list = arg["List"] or arg["Values"] or {}
                local default = arg["Default"] or arg["Value"] or list[1]
                local Dropdown = {
                    Name = arg["Name"] or "",
                    Frame = Instance.new("Frame"),
                    List = list,
                    Value = arg["Multi"] and (type(default) == "table" and default or {}) or (typeof(default) == "number" and list[default] or default),
                    Multi = arg["Multi"] == true,
                    Function = arg["Function"] or arg["function"] or function() end,
                }
                local dropdownObj = optionGroup:AddDropdown(id, {
                    Text = arg["Text"] or Dropdown.Name,
                    Values = list,
                    Default = lionDefault(list, default),
                    Multi = Dropdown.Multi,
                    AllowNull = Dropdown.Multi or arg["AllowNull"] == true,
                    Callback = function(value)
                        Dropdown.Value = value
                        if initialized then
                            task.spawn(function()
                                pcall(Dropdown.Function, value)
                            end)
                        end
                        pcall(SaveConfig)
                    end,
                })
                initialized = true
                dropdownObj = dropdownObj or (Options and Options[id])
                if Dropdown.Multi and type(default) == "table" and dropdownObj and dropdownObj.SetValue then
                    dropdownObj:SetValue(default)
                end
                function Dropdown:SetList(values)
                    Dropdown.List = values or {}
                    if Options and Options[id] and Options[id].SetValues then
                        Options[id]:SetValues(Dropdown.List)
                    end
                end
                function Dropdown:Save(tab) tab[Dropdown.Name] = { Value = Dropdown.Value } end
                function Dropdown:Load(tab)
                    if tab and tab.Value ~= nil then
                        Dropdown.Value = tab.Value
                        if Options and Options[id] then Options[id]:SetValue(tab.Value) end
                    end
                end
                Module.Settings[Dropdown.Name] = Dropdown
                return Dropdown
            end

            function Module.AddDropdown(self, arg)
                return addDropdown(arg)
            end

            function Module.AddDropdown2(self, arg)
                return addDropdown(arg)
            end

            function Module.AddInputBox(self, arg)
                local optionGroup = getOptionGroup(arg)
                local id = lionId("Input", Module.Name, arg["Name"] or arg["Text"] or "Input")
                local initialized = false
                local Input = {
                    Name = arg["Name"] or arg["Text"] or "",
                    Frame = Instance.new("Frame"),
                    Value = arg["Default"] or arg["Value"] or "",
                    Function = arg["Function"] or arg["function"] or function() end,
                }
                optionGroup:AddInput(id, {
                    Text = arg["Text"] or Input.Name,
                    Default = tostring(Input.Value),
                    Numeric = arg["Numeric"] or false,
                    Finished = false,
                    Placeholder = arg["Placeholder"] or arg["PlaceholderText"] or "",
                    Callback = function(value)
                        Input.Value = value
                        if initialized then
                            task.spawn(function()
                                pcall(Input.Function, value)
                            end)
                        end
                        pcall(SaveConfig)
                    end,
                })
                initialized = true
                function Input:Save(tab) tab[Input.Name] = { Value = Input.Value } end
                function Input:Load(tab)
                    if tab and tab.Value ~= nil then
                        Input.Value = tab.Value
                        if Options and Options[id] then Options[id]:SetValue(tostring(tab.Value)) end
                    end
                end
                Module.Settings[Input.Name] = Input
                return Input
            end

            function Module.AddLabel(self, arg)
                local optionGroup = getOptionGroup(arg)
                local text = type(arg) == "table" and (arg["Text"] or "") or tostring(arg or "")
                return optionGroup:AddLabel(text)
            end

            function Module.AddColorPicker(self, arg)
                local id = lionId("Color", Module.Name, arg["Name"] or arg["Text"] or "Color")
                local initialized = false
                local Color = {
                    Name = arg["Name"] or arg["Text"] or "Color",
                    Frame = Instance.new("Frame"),
                    Value = arg["Default"] or arg["Value"] or Color3.fromRGB(255, 255, 255),
                    Transparency = arg["Transparency"],
                    Function = arg["Function"] or arg["function"] or function() end,
                }

                local label = group:AddLabel(arg["Text"] or Color.Name)
                if label and label.AddColorPicker then
                    label:AddColorPicker(id, {
                        Default = Color.Value,
                        Title = arg["Title"] or Color.Name,
                        Transparency = Color.Transparency,
                        Callback = function(value, transparency)
                            Color.Value = value
                            Color.Transparency = transparency ~= nil and transparency or Color.Transparency
                            if initialized then
                                task.spawn(function()
                                    pcall(Color.Function, value)
                                end)
                            end
                            pcall(SaveConfig)
                        end,
                    })
                end
                initialized = true

                function Color:Save(tab)
                    tab[Color.Name] = {
                        R = Color.Value.R,
                        G = Color.Value.G,
                        B = Color.Value.B,
                        Transparency = Color.Transparency,
                    }
                end

                function Color:Load(tab)
                    if tab and tab.R and tab.G and tab.B then
                        Color.Value = Color3.new(tab.R, tab.G, tab.B)
                        Color.Transparency = tab.Transparency
                        if Options and Options[id] then
                            Options[id]:SetValueRGB(Color.Value)
                        end
                    end
                end

                Module.Settings[Color.Name] = Color
                return Color
            end

            function Module.AddButton(self, arg)
                local text = typeof(arg) == "table" and (arg["Text"] or arg["Name"] or "button") or tostring(arg)
                local func = typeof(arg) == "table" and (arg["Func"] or arg["Function"] or arg["function"] or function() end) or function() end
                return group:AddButton({ Text = text, Func = func })
            end

            mainapi.Modules[moduleName] = Module
            Catalog.Modules[moduleName] = Module
            return Module
        end

        mainapi.Catalogs[Catalog.Name] = Catalog
        return Catalog
    end

    local MenuGroup = LionTabs.settings:AddLeftGroupbox("settings")
    MenuGroup:AddButton({ Text = "Unload", Func = function()
        if LionLibrary then LionLibrary:Unload() end
        mainapi:Uninject()
    end })
    MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
        Default = "End",
        NoUI = true,
        Text = "Menu keybind",
    })
    LionLibrary.ToggleKeybind = Options.MenuKeybind
    mainapi.ClickGuiStatus = true
    setMenuBlur(true)
    local lastMenuBlurOpen = true
    local nextMenuBlurCheck = 0
    if Options.MenuKeybind and Options.MenuKeybind.OnClick then
        Options.MenuKeybind:OnClick(function()
            mainapi.ClickGuiStatus = not mainapi.ClickGuiStatus
            setMenuBlur(mainapi.ClickGuiStatus)
            lastMenuBlurOpen = mainapi.ClickGuiStatus
        end)
    end
    mainapi:Clean(RunService.Heartbeat:Connect(function()
        local now = os.clock()
        if now < nextMenuBlurCheck then return end
        nextMenuBlurCheck = now + 0.15
        local open = mainapi.ClickGuiStatus == true
        pcall(function()
            if LionWindow and LionWindow.Holder then
                open = LionWindow.Holder.Visible == true
                mainapi.ClickGuiStatus = open
            end
        end)

        if open ~= lastMenuBlurOpen then
            lastMenuBlurOpen = open
            setMenuBlur(open)
        end
    end))

    local managerOk, managerErr = pcall(function()
        LionThemeManager:SetLibrary(LionLibrary)
        LionSaveManager:SetLibrary(LionLibrary)
        LionSaveManager:IgnoreThemeSettings()
        LionSaveManager:SetIgnoreIndexes({ "MenuKeybind" })
        LionThemeManager:SetFolder("Overlay")
        LionSaveManager:SetFolder("Overlay")

        LionSaveManager.CustomSave = function()
            if shared.LionCosmeticChanger and shared.LionCosmeticChanger.GetEquipData then
                return shared.LionCosmeticChanger.GetEquipData()
            end
            return nil
        end
        LionSaveManager.CustomLoad = function(data)
            if shared.LionCosmeticChanger and shared.LionCosmeticChanger.LoadEquipData then
                shared.LionCosmeticChanger.LoadEquipData(data)
            end
        end
        
        local function installCommunityConfig()
            local commConfigJson = [[{"objects":[{"idx":"animation_player_enabled","type":"Toggle","value":true},{"idx":"target_highlight","type":"Toggle","value":false},{"idx":"indicator_manipulated","type":"Toggle","value":true},{"idx":"viewmodel_override_appearance","type":"Toggle","value":false},{"idx":"lighting_toggle_ClockTime","type":"Toggle","value":true},{"idx":"ragebot_enabled","type":"Toggle","value":true},{"idx":"movement_noclip","type":"Toggle","value":true},{"idx":"silent_closest_part","type":"Toggle","value":false},{"idx":"KeybindMenu","type":"Toggle","value":true},{"idx":"camera_fov_changer","type":"Toggle","value":true},{"idx":"arm_override_appearance","type":"Toggle","value":false},{"idx":"esp_skeleton_outline","type":"Toggle","value":false},{"idx":"auto_load_enabled","type":"Toggle","value":false},{"idx":"silent_fov_fill","type":"Toggle","value":true},{"idx":"esp_chams","type":"Toggle","value":true},{"idx":"viewmodel_body_color","type":"Toggle","value":false},{"idx":"lighting_toggle_ColorShift_Top","type":"Toggle","value":false},{"idx":"lighting_toggle_FogEnd","type":"Toggle","value":false},{"idx":"silent_fov_outline","type":"Toggle","value":true},{"idx":"lighting_toggle_ColorShift_Bottom","type":"Toggle","value":true},{"idx":"NotificationColors","type":"Toggle","value":false},{"idx":"movement_infinite_double_jump","type":"Toggle","value":true},{"idx":"exploits_full_auto","type":"Toggle","value":true},{"idx":"spoof_device_enabled","type":"Toggle","value":false},{"idx":"hit_sounds_enabled","type":"Toggle","value":true},{"idx":"lighting_toggle_Ambient","type":"Toggle","value":true},{"idx":"atmosphere_enabled","type":"Toggle","value":true},{"idx":"auto_queue_enabled","type":"Toggle","value":false},{"idx":"ragebot_priority","type":"Toggle","value":true},{"idx":"viewmodel_offset","type":"Toggle","value":true},{"idx":"shoot_sound_change","type":"Toggle","value":true},{"idx":"viewmodel_disable_textures","type":"Toggle","value":false},{"idx":"indicator_ammo","type":"Toggle","value":true},{"idx":"target_ui_enabled","type":"Toggle","value":false},{"idx":"hit_effects_weld","type":"Toggle","value":false},{"idx":"anti_aim_floor_hide","type":"Toggle","value":true},{"idx":"viewmodel_wireframe","type":"Toggle","value":false},{"idx":"aimbot_fov_outline","type":"Toggle","value":true},{"idx":"esp_healthbar","type":"Toggle","value":true},{"idx":"movement_velocity","type":"Toggle","value":true},{"idx":"arm_disable_textures","type":"Toggle","value":false},{"idx":"aimbot_fov_fill","type":"Toggle","value":true},{"idx":"autoban_maps","type":"Toggle","value":true},{"idx":"hit_sounds_disable","type":"Toggle","value":true},{"idx":"custom_tracer_outline","type":"Toggle","value":false},{"idx":"camera_aspect_ratio","type":"Toggle","value":false},{"idx":"aimbot_fov_moving","type":"Toggle","value":false},{"idx":"chat_spam_enabled","type":"Toggle","value":false},{"idx":"crosshair_disable_game","type":"Toggle","value":true},{"idx":"triggerbot_enabled","type":"Toggle","value":false},{"idx":"lighting_toggle_Brightness","type":"Toggle","value":true},{"idx":"auto_select_enabled","type":"Toggle","value":true},{"idx":"esp_show_team","type":"Toggle","value":false},{"idx":"aimbot_toggle","type":"Toggle","value":false},{"idx":"viewmodel_frames_override","type":"Toggle","value":false},{"idx":"aimbot_match_axis","type":"Toggle","value":false},{"idx":"arm_body_color","type":"Toggle","value":false},{"idx":"esp_skeleton","type":"Toggle","value":true},{"idx":"third_person_enabled","type":"Toggle","value":true},{"idx":"target_hit_notify","type":"Toggle","value":true},{"idx":"silent_manipulation","type":"Toggle","value":true},{"idx":"esp_override_appearance","type":"Toggle","value":false},{"idx":"lighting_bool_GlobalShadows","type":"Toggle","value":true},{"idx":"silent_toggle","type":"Toggle","value":true},{"idx":"skybox_enabled","type":"Toggle","value":true},{"idx":"auto_load_silent","type":"Toggle","value":false},{"idx":"esp_world_distance","type":"Toggle","value":true},{"idx":"esp_world_name","type":"Toggle","value":true},{"idx":"targeting_visibleonly","type":"Toggle","value":true},{"idx":"color_correction_enabled","type":"Toggle","value":true},{"idx":"movement_slideboost","type":"Toggle","value":true},{"idx":"autoban_weapons","type":"Toggle","value":true},{"idx":"esp_effects_particle","type":"Toggle","value":true},{"idx":"crosshair_outline","type":"Toggle","value":true},{"idx":"arcade_auto_respawn","type":"Toggle","value":true},{"idx":"ragebot_priority_notification","type":"Toggle","value":true},{"idx":"esp_effects_aura","type":"Toggle","value":false},{"idx":"esp_name","type":"Toggle","value":true},{"idx":"sunrays_enabled","type":"Toggle","value":false},{"idx":"esp_world_image","type":"Toggle","value":true},{"idx":"hit_effects_enabled","type":"Toggle","value":true},{"idx":"viewmodel_material","type":"Toggle","value":false},{"idx":"NotificationClips","type":"Toggle","value":false},{"idx":"esp_fill_moving","type":"Toggle","value":true},{"idx":"esp_body_color","type":"Toggle","value":false},{"idx":"esp_healthbar_moving","type":"Toggle","value":false},{"idx":"chat_spam_order","type":"Toggle","value":false},{"idx":"silent_showfov","type":"Toggle","value":true},{"idx":"esp_flag_health_text","type":"Toggle","value":false},{"idx":"esp_weapon","type":"Toggle","value":true},{"idx":"esp_healthbar_resize","type":"Toggle","value":false},{"idx":"hit_effects_disable_marker","type":"Toggle","value":true},{"idx":"movement_maul_slam","type":"Toggle","value":false},{"idx":"item_remove_vignette","type":"Toggle","value":true},{"idx":"hit_effects_disable_numbers","type":"Toggle","value":true},{"idx":"name_spoofer","type":"Toggle","value":false},{"idx":"arcade_auto_ammo","type":"Toggle","value":true},{"idx":"esp_flag_staring_text","type":"Toggle","value":false},{"idx":"anti_aim_enabled","type":"Toggle","value":true},{"idx":"aimbot_showfov","type":"Toggle","value":false},{"idx":"targeting_ignore_protected","type":"Toggle","value":true},{"idx":"lighting_toggle_FogColor","type":"Toggle","value":false},{"idx":"targeting_limitdistance","type":"Toggle","value":false},{"idx":"exploits_always_backstab","type":"Toggle","value":true},{"idx":"targeting_disableflash","type":"Toggle","value":false},{"idx":"silent_fov_moving","type":"Toggle","value":true},{"idx":"movement_fly","type":"Toggle","value":true},{"idx":"weather_enabled","type":"Toggle","value":true},{"idx":"esp_box","type":"Toggle","value":false},{"idx":"esp_material","type":"Toggle","value":false},{"idx":"movement_double_jump_height","type":"Toggle","value":true},{"idx":"custom_tracer_enabled","type":"Toggle","value":true},{"idx":"aimbot_delay_position","type":"Toggle","value":false},{"idx":"arm_material","type":"Toggle","value":false},{"idx":"esp_distance","type":"Toggle","value":true},{"idx":"ragebot_void_spam","type":"Toggle","value":true},{"idx":"lighting_toggle_ExposureCompensation","type":"Toggle","value":true},{"idx":"target_tracer","type":"Toggle","value":false},{"idx":"crosshair_enabled","type":"Toggle","value":true},{"idx":"esp_box_moving","type":"Toggle","value":false},{"idx":"ambience_enabled","type":"Toggle","value":true},{"idx":"item_status_enabled","type":"Toggle","value":true},{"idx":"viewmodel_chams","type":"Toggle","value":true},{"idx":"silent_visualize","type":"Toggle","value":true},{"idx":"indicator_ragebot","type":"Toggle","value":true},{"idx":"aimbot_closest_part","type":"Toggle","value":false},{"idx":"esp_fill","type":"Toggle","value":false},{"idx":"camera_anti_flashbang","type":"Toggle","value":true},{"idx":"exploits_no_spread","type":"Toggle","value":true},{"idx":"lighting_toggle_FogStart","type":"Toggle","value":false},{"idx":"bloom_enabled","type":"Toggle","value":true},{"idx":"esp_healthbar_type","type":"Dropdown","mutli":false,"value":"gradient"},{"idx":"ragebot_keybind","type":"KeyPicker","key":"...","mode":"Always"},{"idx":"triggerbot_keybind","type":"KeyPicker","key":"MB2","mode":"Hold"},{"idx":"crosshair_offset","type":"Slider","value":"5"},{"idx":"bloom_threshold","type":"Slider","value":"0.85"},{"idx":"indicator_ragebot_text_color","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"movement_velocityvalue","type":"Slider","value":"50"},{"idx":"silent_outline_color1","type":"ColorPicker","transparency":0.7863636363636364,"value":"c576bd"},{"idx":"silent_fov_rotation","type":"Slider","value":"0"},{"idx":"esp_effects_aura_color1","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"silent_color2","type":"ColorPicker","transparency":0,"value":"e4c4ca"},{"idx":"esp_flag_bridge","type":"Input","text":": "},{"idx":"esp_fill_rotation_speed","type":"Slider","value":"0.5"},{"idx":"esp_effects_particle_color3","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"indicator_ammo_style","type":"Dropdown","mutli":true,"value":{"ammo":true,"max ammo":true,"reserve":true}},{"idx":"triggerbot_scoped","type":"Dropdown","mutli":true,"value":{"Sniper":true,"Crossbow":true}},{"idx":"shoot_sound_speed","type":"Slider","value":"1"},{"idx":"aimbot_fov_rotation_speed","type":"Slider","value":"1"},{"idx":"esp_weapon_rotation","type":"Slider","value":"0"},{"idx":"NotificationStyleSortOrder","type":"Dropdown","mutli":false,"value":"Default"},{"idx":"crosshair_bounce","type":"Slider","value":"5"},{"idx":"aimbot_fov_rotation","type":"Slider","value":"0"},{"idx":"bloom_size","type":"Slider","value":"50"},{"idx":"ragebot_weapon","type":"Dropdown","value":"primary"},{"idx":"indicator_lerp","type":"Slider","value":"0.25"},{"idx":"aimbot_color3","type":"ColorPicker","transparency":0,"value":"d7a6c3"},{"idx":"viewmodel_offset_z","type":"Slider","value":"-0.7"},{"idx":"aimbot_outline_color2","type":"ColorPicker","transparency":0.7,"value":"e38bde"},{"idx":"auto_select_Secondary","type":"Dropdown","value":"Bow"},{"idx":"silent_outline_color2","type":"ColorPicker","transparency":0.7,"value":"e38cde"},{"idx":"skybox_disable","type":"Dropdown","mutli":true,"value":[]},{"idx":"esp_name_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_flag_health_text_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"auto_select_Primary","type":"Dropdown","value":"Daggers"},{"idx":"aimbot_delay_smooth_x","type":"Slider","value":"4"},{"idx":"viewmodel_chams_settings","type":"Dropdown","mutli":true,"value":{"through walls":true}},{"idx":"esp_world_distance_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"aimbot_fill_color2","type":"ColorPicker","transparency":1,"value":"000000"},{"idx":"esp_world_object_scale","type":"Slider","value":"75"},{"idx":"esp_chams_color2","type":"ColorPicker","transparency":0,"value":"ff4ded"},{"idx":"NotificationBarStyle","type":"Dropdown","mutli":false,"value":"Top"},{"idx":"movement_flyvalue","type":"Slider","value":"100"},{"idx":"silent_keybind","type":"KeyPicker","key":"LeftAlt","mode":"Always"},{"idx":"spoof_device_type","type":"Dropdown","value":"controller"},{"idx":"esp_chams_color","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_fill_color3","type":"ColorPicker","transparency":1,"value":"000000"},{"idx":"chat_spam_text","type":"Dropdown","mutli":true,"value":[]},{"idx":"arm_material_value","type":"Dropdown","value":"ForceField"},{"idx":"triggerbot_settings","type":"Dropdown","mutli":true,"value":{"no delay between targets":true,"anti katana":true}},{"idx":"custom_tracer_selected","type":"Dropdown","mutli":false,"value":"lightning"},{"idx":"esp_name_rotation","type":"Slider","value":"0"},{"idx":"anti_aim_yaw","type":"Dropdown","value":"random"},{"idx":"animation_player_keybind","type":"KeyPicker","key":"...","mode":"Toggle"},{"idx":"NotificationColorsFont","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"silent_color1","type":"ColorPicker","transparency":1,"value":"ffffff"},{"idx":"viewmodel_offset_y","type":"Slider","value":"0"},{"idx":"ragebot_void_spam_attack","type":"Slider","value":"0.01"},{"idx":"target_ui_position_x","type":"Slider","value":"50"},{"idx":"aimbot_delay_smooth_y","type":"Slider","value":"4"},{"idx":"shoot_sound_volume","type":"Slider","value":"1"},{"idx":"weather_rate_multiplier","type":"Slider","value":"1"},{"idx":"esp_weapon_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_world_whitelist","type":"Dropdown","mutli":true,"value":{"Flashbang":true,"Smoke Grenade":true,"Satchel":true,"Subspace Tripmine":true,"Molotov":true,"Grenade":true}},{"idx":"weather_color_2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"silent_outline_color3","type":"ColorPicker","transparency":0.2681818181818182,"value":"f296ee"},{"idx":"esp_body_color_value","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_healthbar_color_end","type":"ColorPicker","transparency":0,"value":"9d539b"},{"idx":"indicator_text_style","type":"Dropdown","mutli":false,"value":"lower"},{"idx":"esp_chams_alpha_outline","type":"Slider","value":"1"},{"idx":"item_status_override","type":"Dropdown","value":"Prime"},{"idx":"custom_tracer_fade","type":"Slider","value":"1"},{"idx":"target_ui_show_targets","type":"Dropdown","mutli":true,"value":[]},{"idx":"viewmodel_chams_color2","type":"ColorPicker","transparency":0,"value":"d8e9ff"},{"idx":"custom_tracer_position_lerp","type":"Slider","value":"0.5"},{"idx":"indicator_manipulated_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"NotificationClipsDistance","type":"Slider","value":"200"},{"idx":"arm_body_color_value","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"indicator_reserve_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"custom_tracer_color","type":"ColorPicker","transparency":0,"value":"c47cc1"},{"idx":"esp_weapon_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_outline_color_1","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"indicator_empty_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_skeleton_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_name_font","type":"Dropdown","mutli":false,"value":"default"},{"idx":"animation_player_start_position","type":"Slider","value":"0"},{"idx":"esp_box_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_world_lerp_speed","type":"Slider","value":"0.1"},{"idx":"esp_chams_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"lighting_number_ClockTime","type":"Slider","value":"0"},{"idx":"targeting_forgettime","type":"Slider","value":"0"},{"idx":"ragebot_priority_settings","type":"Dropdown","mutli":true,"value":{"voided players":true,"attackers":true}},{"idx":"esp_flag_style","type":"Dropdown","mutli":false,"value":"upper"},{"idx":"esp_healthbar_speed","type":"Slider","value":"1"},{"idx":"esp_effects_aura_color3","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"esp_distance_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"exploits_grenade_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"esp_bounds_width_scale","type":"Slider","value":"100"},{"idx":"NotificationAnchorStyle","type":"Dropdown","mutli":false,"value":"Center"},{"idx":"arm_body_transparency","type":"Slider","value":"100"},{"idx":"autoban_first","type":"Dropdown","value":"Riot Shield"},{"idx":"color_correction_contrast","type":"Slider","value":"0"},{"idx":"hit_effects_material","type":"Dropdown","mutli":false,"value":"ForceField"},{"idx":"atmosphere_haze","type":"Slider","value":"10"},{"idx":"triggerbot_part_blacklist","type":"Dropdown","mutli":true,"value":[]},{"idx":"hit_sounds_volume","type":"Slider","value":"0.9"},{"idx":"indicator_offset_y","type":"Slider","value":"25"},{"idx":"NotificationColorsMain","type":"ColorPicker","transparency":0,"value":"1c1c1c"},{"idx":"viewmodel_offset_x","type":"Slider","value":"0"},{"idx":"viewmodel_chams_alpha_outline","type":"Slider","value":"1"},{"idx":"indicator_ammo_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_outline_color_2","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_flag_staring_text_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"aimbot_outline_color3","type":"ColorPicker","transparency":0.2681818181818182,"value":"f296ee"},{"idx":"triggerbot_max_distance","type":"Slider","value":"250"},{"idx":"silent_fov_settings","type":"Dropdown","mutli":true,"value":{"position on target":true}},{"idx":"sunrays_intensity","type":"Slider","value":"0.25"},{"idx":"custom_tracer_lifetime","type":"Slider","value":"1"},{"idx":"esp_healthbar_color_start","type":"ColorPicker","transparency":0,"value":"fbb8f8"},{"idx":"triggerbot_reaction_time_offset","type":"Slider","value":"5"},{"idx":"bloom_intensity","type":"Slider","value":"1.38"},{"idx":"cosmetics_changer_save_data","type":"Input","text":"{\"Crossbow\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Crossbow\"}},\"Grenade Launcher\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Uranium Launcher\"}},\"Medkit\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Milk & Cookies\"}},\"Burst Rifle\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Burst Rifle\"}},\"Spear\":{\"charm\":{\"enabled\":true,\"random\":false},\"wrap\":{\"enabled\":true,\"random\":false},\"finisher\":{\"enabled\":true,\"random\":false},\"skin\":{\"enabled\":true,\"random\":false}},\"Flashbang\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Shining Star\"}},\"Subspace Tripmine\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Subspace Tripmine\"}},\"Flamethrower\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glitterthrower\"}},\"Grenade\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Dynamite\",\"enabled\":true}},\"Fists\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Festive Fists\",\"enabled\":true}},\"RPG\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Squid Launcher\"}},\"Grappler\":{\"charm\":{\"enabled\":true,\"random\":false},\"wrap\":{\"enabled\":true,\"random\":false},\"finisher\":{\"enabled\":true,\"random\":false},\"skin\":{\"enabled\":true,\"random\":false}},\"Scythe\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Crystal Scythe\"}},\"Slingshot\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Harp\"}},\"Battle Axe\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Keyttle Axe\"}},\"Flare Gun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Firework Gun\"}},\"Molotov\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Torch\"}},\"Shotgun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Shotgun\"}},\"Permafrost\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Snowman Permafrost\"}},\"Trowel\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Paintbrush\"}},\"Riot Shield\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Masterpiece\"}},\"Assault Rifle\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Tommy Gun\",\"enabled\":true}},\"Sniper\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Hyper Sniper\"}},\"Maul\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Maul\"}},\"Warpstone\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Warpeye\"}},\"Shorty\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Not So Shorty\"}},\"Jump Pad\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Jolly Man\"}},\"Distortion\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Sleighstortion\"}},\"Knife\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Keyrambit\"}},\"Chainsaw\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Festive Buzzsaw\"}},\"Warper\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Frost Warper\"}},\"Bow\":{\"charm\":{\"enabled\":true},\"wrap\":{\"name\":\"Ice Queen\",\"enabled\":true},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Key Bow\",\"enabled\":true}},\"Spray\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Nail Gun\"}},\"Daggers\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Crystal Daggers\",\"enabled\":true}},\"Energy Pistols\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Hacker Pistols\"}},\"Handgun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Warp Handgun\"}},\"Energy Rifle\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Hacker Rifle\"}},\"Katana\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Arch Katana\"}},\"Satchel\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Potion Satchel\"}},\"War Horn\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Air Horn\"}},\"Uzi\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Money Gun\"}},\"Smoke Grenade\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Hourglass\"}},\"Exogun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Midnight Festive Exogun\"}},\"Freeze Ray\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Spider Ray\"}},\"Gunblade\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Boneblade\"}},\"Paintball Gun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Snowball Gun\"}},\"Minigun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Fighter Jet\"}},\"Revolver\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Peppermint Sheriff\"}}}"},{"idx":"aimbot_color1","type":"ColorPicker","transparency":1,"value":"ffffff"},{"idx":"auto_select_Utility","type":"Dropdown","value":"Riot Shield"},{"idx":"KeybindMenuValue","type":"Dropdown","mutli":false,"value":"Active"},{"idx":"esp_healthbar_slices","type":"Slider","value":"1"},{"idx":"crosshair_bounce_speed","type":"Slider","value":"2.9"},{"idx":"anti_aim_pitch","type":"Dropdown","value":"random"},{"idx":"lighting_colorFogColor","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"weather_timescale_multiplier","type":"Slider","value":"1"},{"idx":"esp_body_disables","type":"Dropdown","mutli":true,"value":[]},{"idx":"viewmodel_material_value","type":"Dropdown","value":"ForceField"},{"idx":"esp_fill_rotation","type":"Slider","value":"45"},{"idx":"viewmodel_chams_alpha_fill","type":"Slider","value":"-1.6"},{"idx":"aimbot_radius","type":"Slider","value":"1000"},{"idx":"target_ui_item_scale","type":"Slider","value":"170"},{"idx":"esp_world_name_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"triggerbot_forget_time","type":"Slider","value":"1.5"},{"idx":"weather_lifetime_multiplier","type":"Slider","value":"100"},{"idx":"hit_effects_col_3","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"target_highlight_outline","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_distance_rotation","type":"Slider","value":"0"},{"idx":"target_ui_scale","type":"Slider","value":"170"},{"idx":"crosshair_rotation_speed","type":"Slider","value":"0.2"},{"idx":"color_correction_saturation","type":"Slider","value":"1"},{"idx":"movement_flykeybind","type":"KeyPicker","key":"X","mode":"Toggle"},{"idx":"NotificationTransparency","type":"Slider","value":"35"},{"idx":"esp_skeleton_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"shoot_sound_start","type":"Slider","value":"0"},{"idx":"esp_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"autoban_first_delay","type":"Slider","value":"0"},{"idx":"hit_effects_selected","type":"Dropdown","mutli":true,"value":{"Electricity":true,"phantom forces":true}},{"idx":"esp_name_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"chat_spam_mode","type":"Dropdown","value":"custom"},{"idx":"sunrays_spread","type":"Slider","value":"1"},{"idx":"aimbot_delay_smooth_jump","type":"Slider","value":"10"},{"idx":"esp_flag_health_text_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_skeleton_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_body_transparency","type":"Slider","value":"100"},{"idx":"atmosphere_density","type":"Slider","value":"0.4"},{"idx":"esp_box_rotation_speed","type":"Slider","value":"0.1"},{"idx":"skybox_value","type":"Dropdown","value":"Heaven"},{"idx":"weapon_filter","type":"Input","text":""},{"idx":"custom_tracer_emission","type":"Slider","value":"1"},{"idx":"animation_player_end_position","type":"Slider","value":"100"},{"idx":"aimbot_fov_lerp","type":"Slider","value":"0.25"},{"idx":"weather_value","type":"Dropdown","value":"Rain"},{"idx":"auto_queue_mode","type":"Dropdown","value":"1v1"},{"idx":"color_correction_tint","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"aimbot_outline_color1","type":"ColorPicker","transparency":0.7863636363636364,"value":"c576bd"},{"idx":"esp_effects_particle_value","type":"Dropdown","mutli":true,"value":{"glowing":true}},{"idx":"atmosphere_decay","type":"ColorPicker","transparency":0,"value":"fecaff"},{"idx":"viewmodel_body_transparency","type":"Slider","value":"100"},{"idx":"target_ui_position_y","type":"Slider","value":"70"},{"idx":"silent_fill_color1","type":"ColorPicker","transparency":0.85,"value":"823b75"},{"idx":"movement_maul_slam_multiplier","type":"Slider","value":"1"},{"idx":"crosshair_thickness","type":"Slider","value":"2"},{"idx":"target_hit_notify_duration","type":"Slider","value":"1"},{"idx":"esp_distance_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_name_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"NotificationPositionX","type":"Slider","value":"50"},{"idx":"NotificationColorsOutline","type":"ColorPicker","transparency":0,"value":"323232"},{"idx":"NotificationColorsAccent","type":"ColorPicker","transparency":0,"value":"0055ff"},{"idx":"KeybindMenuTransparency","type":"Slider","value":"50"},{"idx":"MenuKeybind","type":"KeyPicker","key":"RightShift","mode":"Toggle"},{"idx":"targeting_closest_part_blacklist","type":"Dropdown","mutli":true,"value":{"LeftFoot":true,"RightLowerArm":true,"LeftHand":true,"LeftLowerArm":true,"RightLowerLeg":true,"RightHand":true,"RightFoot":true,"LeftLowerLeg":true}},{"idx":"indicator_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"atmosphere_color","type":"ColorPicker","transparency":0,"value":"ffc8fd"},{"idx":"shoot_sound_change_value","type":"Dropdown","mutli":false,"value":"crossbow"},{"idx":"movement_velocitykeybind","type":"KeyPicker","key":"G","mode":"Always"},{"idx":"aimbot_smoothing","type":"Slider","value":"100"},{"idx":"auto_select_Melee","type":"Dropdown","value":"Riot Shield"},{"idx":"name_spoofer_name","type":"Input","text":""},{"idx":"autoban_second","type":"Dropdown","value":"Katana"},{"idx":"movement_noclipkeybind","type":"KeyPicker","key":"X","mode":"Toggle"},{"idx":"target_tracer_customization","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"lighting_colorColorShift_Top","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"movement_slideboostvalue","type":"Slider","value":"2.5"},{"idx":"ambience_volume","type":"Slider","value":"0.5"},{"idx":"autoban_second_delay","type":"Slider","value":"0"},{"idx":"esp_box_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"autoban_map_delay","type":"Slider","value":"0"},{"idx":"custom_tracer_speed","type":"Slider","value":"2"},{"idx":"ragebot_settings","type":"Dropdown","mutli":true,"value":{"swap weapons when empty":true,"prefer projectile weapon":true}},{"idx":"animation_player_speed","type":"Slider","value":"1"},{"idx":"viewmodel_recoil","type":"Slider","value":"0"},{"idx":"camera_aspect_ratio_y","type":"Slider","value":"1"},{"idx":"animation_player_value","type":"Dropdown","mutli":false,"value":"solar system"},{"idx":"indicator_ragebot_status_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"anti_aim_floor_hide_keybind","type":"KeyPicker","key":"...","mode":"Always"},{"idx":"anti_aim_custom_yaw","type":"Slider","value":"0"},{"idx":"aimbot_fill_color3","type":"ColorPicker","transparency":0.8181818181818181,"value":"000000"},{"idx":"anti_aim_custom_pitch","type":"Slider","value":"-180"},{"idx":"ragebot_void_spam_hide","type":"Slider","value":"0.25"},{"idx":"third_person_keybind","type":"KeyPicker","key":"H","mode":"Toggle"},{"idx":"esp_healthbar_color_middle","type":"ColorPicker","transparency":0,"value":"bc75ba"},{"idx":"movement_double_jump_height_multiplier","type":"Slider","value":"2"},{"idx":"esp_weapon_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"targeting_ignore_protected_settings","type":"Dropdown","mutli":true,"value":{"katana deflecting":true,"blocked by riot shield":true}},{"idx":"lighting_colorAmbient","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"camera_blur","type":"Slider","value":"0"},{"idx":"aimbot_fov_settings","type":"Dropdown","mutli":true,"value":{"position on target":true,"position on barrel":true}},{"idx":"esp_flag_prefix","type":"Dropdown","mutli":false,"value":"full"},{"idx":"target_hit_notify_text","type":"Dropdown","mutli":true,"value":{"Hit {NAME} for {DMG} in the {PART}":true}},{"idx":"lighting_number_ExposureCompensation","type":"Slider","value":"-1.1"},{"idx":"ragebot_mode","type":"Dropdown","value":"gun"},{"idx":"target_highlight_fill","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_healthbar_health_lerp","type":"Slider","value":"0.05"},{"idx":"exploits_firerate","type":"Slider","value":"15"},{"idx":"esp_box_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"indicator_ammo_divider_color","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"crosshair_settings","type":"Dropdown","mutli":true,"value":{"position on target":true}},{"idx":"NotificationPositionY","type":"Slider","value":"60"},{"idx":"animation_player_custom_input","type":"Input","text":""},{"idx":"crosshair_length","type":"Slider","value":"13"},{"idx":"targeting_maxdistance","type":"Slider","value":"250"},{"idx":"lighting_colorColorShift_Bottom","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_rotation","type":"Slider","value":"0"},{"idx":"esp_bounds_type","type":"Dropdown","mutli":false,"value":"dynamic"},{"idx":"crosshair_outline_color_3","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_fill_color2","type":"ColorPicker","transparency":0.9409090909090909,"value":"320055"},{"idx":"ragebot_shoot_attempts","type":"Slider","value":"2"},{"idx":"silent_fov_rotation_speed","type":"Slider","value":"0.1"},{"idx":"esp_effects_aura_color2","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"crosshair_color_4","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"esp_fill_color1","type":"ColorPicker","transparency":0.5727272727272728,"value":"f296ee"},{"idx":"crosshair_color_2","type":"ColorPicker","transparency":0,"value":"f7b1f4"},{"idx":"crosshair_color_1","type":"ColorPicker","transparency":0,"value":"fccbfa"},{"idx":"esp_effects_particle_color1","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"shoot_sound_custom_value","type":"Input","text":""},{"idx":"camera_aspect_ratio_x","type":"Slider","value":"1"},{"idx":"esp_name_type","type":"Dropdown","mutli":false,"value":"Name"},{"idx":"indicator_ragebot_style","type":"Dropdown","mutli":true,"value":{"status":true,"text":true}},{"idx":"custom_tracer_glow","type":"Slider","value":"4"},{"idx":"custom_tracer_length","type":"Slider","value":"4"},{"idx":"custom_tracer_width","type":"Slider","value":"0.2"},{"idx":"ragebot_priority_targets","type":"Dropdown","mutli":true,"value":{"opop910720":true}},{"idx":"silent_fill_color3","type":"ColorPicker","transparency":0.6,"value":"9f83a0"},{"idx":"lighting_number_Brightness","type":"Slider","value":"1.7"},{"idx":"esp_fill_image","type":"Dropdown","mutli":false,"value":"default"},{"idx":"atmosphere_offset","type":"Slider","value":"0.4"},{"idx":"triggerbot_shoot_delay","type":"Slider","value":"0"},{"idx":"ambience_value","type":"Dropdown","value":"Rain"},{"idx":"aimbot_keybind","type":"KeyPicker","key":"MB2","mode":"Hold"},{"idx":"viewmodel_options","type":"Dropdown","mutli":true,"value":{"tilt":true,"muzzle flash":true,"sway":true,"equip animation":true,"bobbing":true,"jump animation":true,"aiming animation":true,"shoot animation":true,"idle animation":true,"sprint animation":true,"slide animation":true}},{"idx":"esp_skeleton_thickness","type":"Slider","value":"1"},{"idx":"lighting_number_FogEnd","type":"Slider","value":"2500"},{"idx":"silent_fov_lerp","type":"Slider","value":"0.25"},{"idx":"weather_color_3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"silent_hitchance","type":"Slider","value":"100"},{"idx":"aimbot_color2","type":"ColorPicker","transparency":0,"value":"e4c4ca"},{"idx":"custom_tracer_color2","type":"ColorPicker","transparency":0,"value":"c47cc1"},{"idx":"color_correction_brightness","type":"Slider","value":"-0.09"},{"idx":"silent_color3","type":"ColorPicker","transparency":0,"value":"d7a6c3"},{"idx":"esp_box_rotation","type":"Slider","value":"0"},{"idx":"targeting_reactiontime","type":"Slider","value":"30"},{"idx":"atmosphere_glare","type":"Slider","value":"4.1"},{"idx":"indicator_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"crosshair_lerp","type":"Slider","value":"0.25"},{"idx":"viewmodel_body_color_value","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"silent_fill_color2","type":"ColorPicker","transparency":0.7,"value":"d7a6d5"},{"idx":"viewmodel_chams_color","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"triggerbot_reaction_time","type":"Slider","value":"25"},{"idx":"hit_effects_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"viewmodel_frames_value","type":"Slider","value":"1"},{"idx":"aimbot_fill_color1","type":"ColorPicker","transparency":0.8181818181818181,"value":"000000"},{"idx":"esp_material_value","type":"Dropdown","value":"Neon"},{"idx":"lighting_number_FogStart","type":"Slider","value":"0"},{"idx":"weather_color_1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_color_3","type":"ColorPicker","transparency":0,"value":"f5a3f1"},{"idx":"esp_effects_particle_color2","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"target_highlight_type","type":"Dropdown","mutli":false,"value":"AlwaysOnTop"},{"idx":"targeting_part","type":"Dropdown","mutli":false,"value":"Head"},{"idx":"indicator_offset_x","type":"Slider","value":"0"},{"idx":"indicator_ammo_max_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_effects_aura_value","type":"Dropdown","mutli":true,"value":[]},{"idx":"hit_effects_col_1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"hit_sounds_selected","type":"Dropdown","mutli":false,"value":"sparkle"},{"idx":"silent_radius","type":"Slider","value":"300"},{"idx":"crosshair_outline_color_4","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_chams_alpha_fill","type":"Slider","value":"-1"},{"idx":"esp_distance_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_world_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"esp_flag_font","type":"Dropdown","mutli":false,"value":"smallest pixel"},{"idx":"hit_effects_col_2","type":"ColorPicker","transparency":0,"value":"f6b9f4"},{"idx":"camera_fov_changer_amount","type":"Slider","value":"100"}]}]]
            local success, decoded = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), commConfigJson)
            if success and decoded and decoded.objects then
                local cleanObjects = {}
                for _, obj in ipairs(decoded.objects) do
                    if (obj.type == "Toggle" and Toggles and Toggles[obj.idx]) or 
                       (obj.type ~= "Toggle" and Options and Options[obj.idx]) then
                        table.insert(cleanObjects, obj)
                    end
                end
                decoded.objects = cleanObjects
                local encodeSuccess, cleanJson = pcall(game:GetService("HttpService").JSONEncode, game:GetService("HttpService"), decoded)
                
                if encodeSuccess and isfolder and writefile then
                    if not isfolder(LionSaveManager.Folder) then makefolder(LionSaveManager.Folder) end
                    if not isfolder(LionSaveManager.Folder .. '/settings') then makefolder(LionSaveManager.Folder .. '/settings') end
                    
                    local path = LionSaveManager.Folder .. "/settings/[Rage] Rem's Config.json"
                    writefile(path, cleanJson)
                end
            end
        end
        installCommunityConfig()

        LionSaveManager:BuildConfigSection(LionTabs.settings)
        
        if Options and Options.SaveManager_ConfigList then
            Options.SaveManager_ConfigList:SetValues(LionSaveManager:RefreshConfigList())
        end
        
        LionThemeManager:ApplyToTab(LionTabs.settings)
    end)
    if not managerOk then
        warn("[Overlay] config UI setup failed:", managerErr)
    end
    -- Keep Linoria configs manual; autoload can fire callbacks before all modules are ready.
end
mainapi:CreateGUI()

local function ApplyConfig()
    _savingConfig = true

    for name, module in pairs(mainapi.Modules) do
        local saved = Config.Modules and Config.Modules[name]
        if saved then
            if saved.Colors then
                if module.Colors then
                    for i, color in ipairs(saved.Colors) do
                        if color and color.R and color.G and color.B then
                            module.Colors[i] = Color3.new(color.R, color.G, color.B)
                            if module.ColorTransparency then
                                module.ColorTransparency[i] = color.Transparency ~= nil and color.Transparency or module.ColorTransparency[i]
                            end
                            local colorId = lionId("Color", module.Name, "enabled", tostring(i))
                            if Options and Options[colorId] then
                                Options[colorId]:SetValueRGB(module.Colors[i])
                            end
                        end
                    end
                    module.Value = module.Colors[1]
                elseif module.Value and saved.Colors[1] then
                    local color = saved.Colors[1]
                    if color.R and color.G and color.B then
                        module.Value = Color3.new(color.R, color.G, color.B)
                        local colorId = lionId("Color", module.Name, "enabled")
                        if Options and Options[colorId] then
                            Options[colorId]:SetValueRGB(module.Value)
                        end
                    end
                end
            end

            if saved.Settings then
                for sname, setting in pairs(module.Settings) do
                    if type(setting) == "table" and setting.Load and saved.Settings[sname] then
                        pcall(function()
                            setting:Load(saved.Settings[sname])
                        end)
                    end
                end
            end

            if saved.Bind and saved.Bind.Name and saved.Bind.EnumType then
                if saved.Bind.EnumType == "Enum.KeyCode" or saved.Bind.EnumType == "KeyCode" then
                    pcall(function()
                        module:SetBind(Enum.KeyCode[saved.Bind.Name])
                    end)
                elseif saved.Bind.EnumType == "Enum.UserInputType" or saved.Bind.EnumType == "UserInputType" then
                    pcall(function()
                        module:SetBind(Enum.UserInputType[saved.Bind.Name])
                    end)
                end
            end

            if saved.Expanded ~= nil and saved.Expanded ~= module.Expanded then
                module:Expand()
            end

            -- Keep saved Enabled state in config, but do not auto-enable modules on startup.
        end
    end

    if Config.Gui then
        if Config.Gui.TargetHud and TargetHudMain then
            TargetHudMain.Position = UDim2.fromOffset(
                Config.Gui.TargetHud.X or 100,
                Config.Gui.TargetHud.Y or 100
            )
        end

        if Config.Gui.RagebotStatus and RagebotStatusMain then
            RagebotStatusMain.Position = UDim2.fromOffset(
                Config.Gui.RagebotStatus.X or 100,
                Config.Gui.RagebotStatus.Y or 100
            )
        end

    end

    task.defer(function()
        _savingConfig = false
        SaveConfig(true)
    end)
end

local Array = {Enabled = false}
local ArrayListTransparency, ArrayListGlowLine = {Value = 0.3}, {Enabled = false}
do
    function mainapi:GetArrayListColor(vec)
        local blend = getBlendFactor(vec)
        if uipallet.ThirdColor then
            if blend <= 0.5 then
                return uipallet.MainColor:Lerp(uipallet.SecondaryColor, blend * 2)
            end
            return uipallet.SecondaryColor:Lerp(uipallet.ThirdColor, (blend - 0.5) * 2)
        end
        return uipallet.SecondaryColor:Lerp(uipallet.MainColor, blend)
    end

    local ArrayListMain = Instance.new("Frame")
    ArrayListMain.Size = UDim2.new(0, 0, 0, mainapi.MainScreenGui.AbsoluteSize.Y/45)
    ArrayListMain.BackgroundTransparency = 1
    ArrayListMain.AnchorPoint = Vector2.new(1, 0)
    ArrayListMain.Position = UDim2.fromScale(0, 0)

    local ArrayListFrame = Instance.new("TextLabel")
    ArrayListFrame.Name = "TextLabel"
    ArrayListFrame.Size = UDim2.fromScale(1, 1)
    ArrayListFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    ArrayListFrame.BorderSizePixel = 0
    ArrayListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ArrayListFrame.BackgroundTransparency = 0.3
    ArrayListFrame.RichText = true
    ArrayListFrame.Font = Enum.Font.BuilderSansMedium
    ArrayListFrame.TextSize = ArrayListMain.AbsoluteSize.Y
    ArrayListFrame.Parent = ArrayListMain

    local ArrayListExtraMain = Instance.new("Frame")
    ArrayListExtraMain.BackgroundTransparency = 1
    ArrayListExtraMain.AnchorPoint = Vector2.new(1, 0.5)
    ArrayListExtraMain.ClipsDescendants = true
    ArrayListExtraMain.Position = UDim2.fromScale(1, 0)
    ArrayListExtraMain.Parent = ArrayListFrame

    local ArrayListExtra = Instance.new("Frame")
    ArrayListExtra.Size = UDim2.fromScale(0.6, 0.3)
    ArrayListExtra.BackgroundTransparency = 0
    ArrayListExtra.AnchorPoint = Vector2.new(0, 0.5)
    ArrayListExtra.Position = UDim2.fromScale(-0.3, 0.5)
    ArrayListExtra.Parent = ArrayListExtraMain

    local GlowEffect = Instance.new('ImageLabel')
    GlowEffect.BackgroundTransparency = 1
    GlowEffect.AnchorPoint = Vector2.new(0, 0.5)
    GlowEffect.Position = UDim2.fromScale(-8, 0.5)
    GlowEffect.ZIndex = -10
    GlowEffect.Size = UDim2.fromScale(10, 1.3)
    GlowEffect.ImageTransparency = 0.6
    GlowEffect.Image = 'rbxassetid://93106615966363'
    GlowEffect.Parent = ArrayListExtra

    addCorner(GlowEffect, UDim.new(999, 0))
    addCorner(ArrayListExtra, UDim.new(999, 0))
    addBlur(ArrayListFrame)
    addCorner(ArrayListFrame)

    local old = {}
    function mainapi:UpdateArrayList()
        if not (Array and Array.Enabled) then
            table.clear(old)
            for _, v in ArrayList:GetChildren() do
                if v:IsA("Frame") then
                    v:Destroy()
                end
            end
            return
        end

        local new, remove = {}, {}

        for i,v in next, self.Modules do
            if v.Enabled and not v.HideEnabled and not old[i] then
                old[i] = i
                table.insert(new, i)
            elseif (not v.Enabled or v.HideEnabled) and old[i] then
                table.insert(remove, i)
                old[i] = nil
            end
        end

        for i,v in ArrayList:GetChildren() do
            if v:IsA("Frame") then
                if table.find(remove, v.Name) then
                    TweenService:Create(v.UIScale, TweenInfo.new(0.3,Enum.EasingStyle.Exponential),
                        {Scale = 0}
                    ):Play()
                    task.delay(0.3,function()
                        v:Destroy()
                    end)
                end
            end
        end

        for i,v in next, new do
            local Clone = ArrayListMain:Clone()
            Clone.Parent = ArrayList
            Clone.Name = v
            local Color = mainapi:GetArrayListColor(Clone.AbsolutePosition)
            Clone.TextLabel.Text = '<font color="rgb('..tostring(math.floor(Color.R * 255))..','..tostring(math.floor(Color.G * 255))..','..tostring(math.floor(Color.B * 255))..')">'..v..'</font>'
            local selfModule = self.Modules[v]
            if selfModule and selfModule.ExtraText then
                local Extra = selfModule.ExtraText()
                Clone.TextLabel.Text ..= Extra ~= '' and ' '..Extra or Extra
            end
            local Size = UDim2.new(0, getfontsize(
                removeTags(Clone.TextLabel.Text),
                Clone.TextLabel.TextSize,
                Clone.TextLabel.FontFace,
                Vector2.new(100000, 100000)
            ).X + mainapi.MainScreenGui.AbsoluteSize.Y/90, 0, mainapi.MainScreenGui.AbsoluteSize.Y/45)
            Clone.Size = Size
            Clone.LayoutOrder = -getfontsize(
                removeTags(Clone.TextLabel.Text),
                Clone.TextLabel.TextSize,
                Clone.TextLabel.FontFace,
                Vector2.new(100000, 100000)
            ).X

            if ArrayListTransparency.Value then
                Clone.TextLabel.BackgroundTransparency = 1 - ArrayListTransparency.Value
            end
 
            Clone.TextLabel.Frame.Visible = ArrayListGlowLine.Enabled or false

            local UIScale = Instance.new("UIScale")
            UIScale.Parent = Clone

            UIScale.Scale = 0
            UIScale.Parent = Clone
            TweenService:Create(UIScale,TweenInfo.new(0.3,Enum.EasingStyle.Exponential),
                {Scale = 1}
            ):Play()

        end
    end
    local arrayListUpdateInterval = 1 / 10
    local nextArrayListUpdate = 0
    mainapi:Clean(RunService.PreSimulation:Connect(function()
        if Array.Enabled then
            local now = os.clock()
            if now < nextArrayListUpdate then return end
            nextArrayListUpdate = now + arrayListUpdateInterval
            local screenY = mainapi.MainScreenGui.AbsoluteSize.Y
            local textSize = screenY / 45
            local lineWidth = screenY / 60
            local lineOffset = screenY / 70
            local sizePadding = screenY / 90
            for i,v in next, ArrayList:GetChildren() do
                if v:IsA("Frame") then
                    local Color = mainapi:GetArrayListColor(v.AbsolutePosition)
                    local richText = '<font color="rgb('..tostring(math.floor(Color.R * 255))..','..tostring(math.floor(Color.G * 255))..','..tostring(math.floor(Color.B * 255))..')">'..v.Name..'</font>'
                    local selfModule = mainapi.Modules[v.Name]
                    if selfModule and selfModule.ExtraText then
                        local Extra = selfModule.ExtraText()
                        richText ..= Extra ~= '' and ' '..Extra or Extra
                    end
                    v.TextLabel.Text = richText
                    v.TextLabel.Frame.Frame.BackgroundColor3 = Color
                    v.TextLabel.BackgroundTransparency = 1 - ArrayListTransparency.Value
                    v.TextLabel.Frame.Frame.ImageLabel.ImageColor3 = Color
                    local Size = UDim2.new(0, getfontsize(
                        removeTags(v.TextLabel.Text),
                        textSize,
                        v.TextLabel.FontFace,
                        Vector2.new(100000, 100000)
                    ).X + sizePadding, 0, textSize)
                    v.Size = Size
                    v.TextLabel.TextSize = textSize
                    v.TextLabel.Frame.Size = UDim2.new(0, lineWidth, 3, 0)
                    v.TextLabel.Frame.Position = UDim2.new(1, lineOffset, 0.5, 0)
                end
            end
        end
    end))
end

local TargetHud
TargetHudMain = mainapi.TargetHudFrame
TargetHudMain.Size = UDim2.new(0, mainapi.MainScreenGui.AbsoluteSize.Y/6, 0, mainapi.MainScreenGui.AbsoluteSize.Y/14)
TargetHudMain.BackgroundTransparency = 1
TargetHudMain.Parent = mainapi.MainScreenGui
TargetHudMain.Visible = false

local TargetHudFrame = Instance.new("Frame")
TargetHudFrame.AnchorPoint = Vector2.new(0.5, 0.5)
TargetHudFrame.Position = UDim2.fromScale(0.5, 0.5)
TargetHudFrame.Size = UDim2.fromScale(1, 1)
TargetHudFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TargetHudFrame.BackgroundTransparency = 0.1
TargetHudFrame.BorderSizePixel = 0
TargetHudFrame.Parent = TargetHudMain

local TargetHudText = Instance.new("TextLabel")
TargetHudText.TextScaled = true
TargetHudText.BackgroundTransparency = 1
TargetHudText.Text = "None"
TargetHudText.TextColor3 = Color3.fromRGB(240, 240, 240)
TargetHudText.Size = UDim2.fromScale(1, 0.5)
TargetHudText.TextXAlignment = Enum.TextXAlignment.Left
TargetHudText.Parent = TargetHudFrame

local UIPadding = Instance.new('UIPadding')
UIPadding.PaddingBottom = UDim.new(0.15, 0)
UIPadding.PaddingTop = UDim.new(0.4, 0)
UIPadding.PaddingLeft = UDim.new(0.42, 0)
UIPadding.PaddingRight = UDim.new(0.1, 0)
UIPadding.Parent = TargetHudText

addCorner(TargetHudFrame)
addBlur(TargetHudFrame)

local TargetHudHealth = Instance.new("CanvasGroup")
TargetHudHealth.AnchorPoint = Vector2.new(0, 0.5)
TargetHudHealth.Position = UDim2.fromScale(0.42, 0.7)
TargetHudHealth.Size = UDim2.fromScale(0.46, 0.12)
TargetHudHealth.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
TargetHudHealth.BackgroundTransparency = 0.7
TargetHudHealth.BorderSizePixel = 0
TargetHudHealth.Parent = TargetHudFrame
addBlur(TargetHudHealth)
addCorner(TargetHudHealth, UDim.new(1, 0))

local TargetHudHealthText = Instance.new("TextLabel")
TargetHudHealthText.Text = "0"
TargetHudHealthText.TextXAlignment = Enum.TextXAlignment.Left
TargetHudHealthText.AnchorPoint = Vector2.new(0, 0.5)
TargetHudHealthText.Position = UDim2.fromScale(0.42, 0.5)
TargetHudHealthText.Size = UDim2.fromScale(0.5, 0.2)
TargetHudHealthText.TextScaled = true
TargetHudHealthText.TextColor3 = Color3.fromRGB(240, 240, 240)
TargetHudHealthText.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TargetHudHealthText.BackgroundTransparency = 1
TargetHudHealthText.BorderSizePixel = 0
TargetHudHealthText.Parent = TargetHudFrame
-- mainapi:AddNumberLabel(TargetHudHealthText)
local TargetHudHealthFill = Instance.new("Frame")
TargetHudHealthFill.AnchorPoint = Vector2.new(0, 0.5)
TargetHudHealthFill.Position = UDim2.fromScale(0, 0.5)
TargetHudHealthFill.Size = UDim2.fromScale(0, 1)
TargetHudHealthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TargetHudHealthFill.BackgroundTransparency = 0.1
TargetHudHealthFill.BorderSizePixel = 0
TargetHudHealthFill.Parent = TargetHudHealth


local TargetImage = Instance.new("ImageLabel")
TargetImage.AnchorPoint = Vector2.new(0.5, 0.5)
TargetImage.Position = UDim2.fromScale(0.2, 0.5)
TargetImage.BackgroundTransparency = 1
TargetImage.Image = "http://www.roblox.com/asset/?id=106901765836307"
TargetImage.SizeConstraint = Enum.SizeConstraint.RelativeYY
TargetImage.Size = UDim2.fromScale(0.7, 0.7)
TargetImage.Parent = TargetHudFrame
TargetImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
addCorner(TargetImage)
addBlur(TargetImage)


makeDraggable(TargetHudMain, mainapi.MainScreenGui.ClickGui)

local UIScale = Instance.new('UIScale', TargetHudFrame)
UIScale.Scale = mainapi.ClickGuiStatus and mainapi.Scale.Value or 0

local UIScale2 = Instance.new('UIScale', TargetImage)
UIScale2.Scale = 1

RagebotStatusMain = Instance.new("Frame")
RagebotStatusMain.Name = "RagebotStatus"
RagebotStatusMain.AnchorPoint = Vector2.new(0, 0)
RagebotStatusMain.Position = UDim2.new(0.5, -(mainapi.MainScreenGui.AbsoluteSize.Y / 8.4), 0.08, 0)
RagebotStatusMain.Size = UDim2.new(0, mainapi.MainScreenGui.AbsoluteSize.Y / 4.2, 0, mainapi.MainScreenGui.AbsoluteSize.Y / 28)
RagebotStatusMain.BackgroundTransparency = 1
RagebotStatusMain.Visible = false
RagebotStatusMain.Parent = mainapi.MainScreenGui
getgenv().RagebotStatusMain = RagebotStatusMain

local RagebotStatusFrame = Instance.new("Frame")
RagebotStatusFrame.Size = UDim2.fromScale(1, 1)
RagebotStatusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
RagebotStatusFrame.BackgroundTransparency = 0.12
RagebotStatusFrame.BorderSizePixel = 0
RagebotStatusFrame.Parent = RagebotStatusMain

local RagebotStatusAccent = Instance.new("Frame")
RagebotStatusAccent.AnchorPoint = Vector2.new(0, 0.5)
RagebotStatusAccent.Position = UDim2.fromScale(0.035, 0.5)
RagebotStatusAccent.Size = UDim2.fromScale(0.022, 0.56)
RagebotStatusAccent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RagebotStatusAccent.BorderSizePixel = 0
RagebotStatusAccent.Parent = RagebotStatusFrame
addGradient(RagebotStatusAccent)

local RagebotStatusText = Instance.new("TextLabel")
RagebotStatusText.BackgroundTransparency = 1
RagebotStatusText.Position = UDim2.fromScale(0.085, 0)
RagebotStatusText.Size = UDim2.fromScale(0.89, 1)
RagebotStatusText.Font = mainapi.Font
RagebotStatusText.Text = "Ragebot : void"
RagebotStatusText.TextColor3 = Color3.fromRGB(240, 240, 240)
RagebotStatusText.TextScaled = true
RagebotStatusText.TextXAlignment = Enum.TextXAlignment.Left
RagebotStatusText.TextYAlignment = Enum.TextYAlignment.Center
RagebotStatusText.Parent = RagebotStatusFrame

local RagebotStatusTextConstraint = Instance.new("UITextSizeConstraint")
RagebotStatusTextConstraint.MinTextSize = 8
RagebotStatusTextConstraint.MaxTextSize = 18
RagebotStatusTextConstraint.Parent = RagebotStatusText

addCorner(RagebotStatusFrame)
addCorner(RagebotStatusAccent, UDim.new(1, 0))
addBlur(RagebotStatusFrame)
makeDraggable(RagebotStatusMain, mainapi.MainScreenGui.ClickGui)

local RagebotStatusScale = Instance.new("UIScale")
RagebotStatusScale.Scale = 0
RagebotStatusScale.Parent = RagebotStatusFrame

local RagebotStatusLastText = ""
local RagebotStatusVisible = false
local function setRagebotStatus(enabled, target, voiding)
    shared.RagebotActive = enabled
    if not RagebotStatusMain then return end

    local text = "Harion Rage : void"
    if enabled and target and not voiding then
        text = "Harion Rage : " .. (target.Name or "target")
    end

    if RagebotStatusLastText ~= text then
        RagebotStatusLastText = text
        RagebotStatusText.Text = text
    end

    if enabled ~= RagebotStatusVisible then
        RagebotStatusVisible = enabled
        RagebotStatusMain.Visible = true
        TweenService:Create(RagebotStatusScale, TweenInfo.new(0.18, Enum.EasingStyle.Exponential), {
            Scale = enabled and 1 or 0
        }):Play()
        if not enabled then
            task.delay(0.2, function()
                if not RagebotStatusVisible then
                    RagebotStatusMain.Visible = false
                end
            end)
        end
    end
end

mainapi:Clean(mainapi.MainScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    RagebotStatusMain.Size = UDim2.new(0, mainapi.MainScreenGui.AbsoluteSize.Y / 4.2, 0, mainapi.MainScreenGui.AbsoluteSize.Y / 28)
end))

if Config.Gui and Config.Gui.RagebotStatus then
    RagebotStatusMain.Position = UDim2.fromOffset(
        Config.Gui.RagebotStatus.X or RagebotStatusMain.AbsolutePosition.X,
        Config.Gui.RagebotStatus.Y or RagebotStatusMain.AbsolutePosition.Y
    )
end

local TargetHudSoundEffect
local lasthealth = 0
local lastmaxhealth = 0
local TargetHudScale
local Targetinfo = {
	Targets = {},
	Object = TargetHudFrame,
	UpdateInfo = function(self)
		local entitylib = mainapi.Libraries.entitylib
		if not entitylib then return end

		for i, v in self.Targets do
			if v < tick() then
				self.Targets[i] = nil
			end
		end

		local v, highest = nil, tick()
		for i, check in self.Targets do
			if check > highest then
				v = i
				highest = check
			end
		end
        local Tween
		if v ~= nil or mainapi.ClickGuiStatus and UIScale.Scale == 0 and not Tween then
            Tween = TweenService:Create(UIScale,TweenInfo.new(0.1,Enum.EasingStyle.Bounce),
                {Scale = (TargetHudScale and TargetHudScale.Value) or 1}
            ):Play()
        elseif not mainapi.ClickGuiStatus and not Tween then
            Tween = TweenService:Create(UIScale,TweenInfo.new(0.1,Enum.EasingStyle.Bounce),
                {Scale = 0}
            ):Play()
        end
		if v then
			TargetHudText.Text = v.Player and (v.Player.Name) or v.Character and v.Character.Name or TargetHudText.Text
			if not v.Character then
				v.Health = v.Health or 0
				v.MaxHealth = v.MaxHealth or 100
			end

            TargetHudHealthText.Text = ("%2d HP"):format(v.Health)
            local localHumanoid = entitylib.character and entitylib.character.Humanoid
            local localHealth = localHumanoid and localHumanoid.Health
            if localHealth and localHealth == v.Health then
                TargetHudHealthText.Text = TargetHudHealthText.Text.." Drawing"
            elseif localHealth and localHealth < v.Health then
                TargetHudHealthText.Text = TargetHudHealthText.Text.." Losing"
            elseif localHealth and localHealth > v.Health then
                TargetHudHealthText.Text = TargetHudHealthText.Text.." Winning"
            end

			if v.Health ~= lasthealth then
				local percent = math.max(v.Health / v.MaxHealth, 0)
                TweenService:Create(TargetHudHealthFill, TweenInfo.new(0.3), {
					Size = UDim2.fromScale(math.min(percent, 1), 1), BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
				}):Play()
				if lasthealth > v.Health and self.LastTarget == v then
					TargetImage.ImageColor3 = Color3.fromRGB(255, 0, 0)
                    UIScale2.Scale = 0.8
                    TweenService:Create(TargetImage, TweenInfo.new(0.3), {
                        ImageColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                    TargetImage.Rotation = 20
                    TweenService:Create(TargetImage, TweenInfo.new(0.3), {
                        Rotation = 0
                    }):Play()
                    TweenService:Create(UIScale2, TweenInfo.new(0.3,Enum.EasingStyle.Bounce), {
                        Scale = 1
                    }):Play()
                    if TargetHudSoundEffect and TargetHudSoundEffect.Enabled then
                        local Clone = SoundEffect:Clone()
                        Clone.Volume = 0.7
                        Clone.Parent = mainapi.MainScreenGui
                        Clone:Play()
                    end
				end
				lasthealth = v.Health
				lastmaxhealth = v.MaxHealth
			end

			if not v.Character then table.clear(v) end
			self.LastTarget = v
		end
		return v
	end
}
mainapi.Libraries.Targetinfo = Targetinfo

function mainapi:Notify(arg)
    if mainapi.ThreadFix and setthreadidentity then
        pcall(setthreadidentity, 8)
    end

    local Notify = {
        Text = arg["Text"] or "None";
        Duration = arg["Duration"] or arg["Durn"] or 2;
        Frame = Instance.new('Frame');
        Sound = arg["Sound"];
        Status = false;
    }
    local NotifyFrame = Notify.Frame
    NotifyFrame.Size = UDim2.fromScale(0.8, 0.05)
    NotifyFrame.BackgroundTransparency = 1
    NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotifyFrame.Parent = NotifyList
    
    local UIScale = Instance.new('UIScale',NotifyFrame)
    UIScale.Scale = 0

    local NotifyMain = Instance.new('Frame');
    NotifyMain.Name = "NotifyMain"
    NotifyMain.Size = UDim2.fromScale(1, 1)
    NotifyMain.Position = UDim2.fromScale(2, 0.2)
    NotifyMain.BackgroundTransparency = 0.3
    NotifyMain.BorderSizePixel = 0
    NotifyMain.ZIndex = -1
    NotifyMain.ClipsDescendants = false
    NotifyMain.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotifyMain.Parent = NotifyFrame
    addBlur(NotifyMain)
    addCorner(NotifyMain)

    local NotifyText = Instance.new('TextButton')
    NotifyText.Size = UDim2.fromScale(1, 1)
    NotifyText.Text = Notify.Text
    NotifyText.Font = mainapi.Font
    NotifyText.BorderSizePixel = 0
    NotifyText.BackgroundTransparency = 1
    NotifyText.ZIndex = 10
    NotifyText.TextScaled = true
    NotifyText.TextXAlignment = Enum.TextXAlignment.Left
    NotifyText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifyText.Parent = NotifyMain

    local UIPadding = Instance.new('UIPadding')
    UIPadding.PaddingBottom = UDim.new(0.25, 0)
    UIPadding.PaddingLeft = UDim.new(0.1, 0)
    UIPadding.PaddingRight = UDim.new(0.1, 0)
    UIPadding.PaddingTop = UDim.new(0.25, 0)
    UIPadding.Parent = NotifyText

    local NotifyFill = Instance.new('Frame')
    NotifyFill.Size = UDim2.fromScale(0, 1)
    NotifyFill.BorderSizePixel = 0
    NotifyFill.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
    NotifyFill.BackgroundTransparency = 0
    NotifyFill.Parent = NotifyMain
    addGradient(NotifyFill)
    addCorner(NotifyFill)
    addBlur(NotifyFill)


    TweenService:Create(NotifyMain,TweenInfo.new(1,Enum.EasingStyle.Exponential),
        {Position = UDim2.fromScale(0, 0)}
    ):Play()
    TweenService:Create(UIScale,TweenInfo.new(0.3,Enum.EasingStyle.Exponential),
        {Scale = 1}
    ):Play()
    TweenService:Create(NotifyFill,TweenInfo.new(Notify.Duration,Enum.EasingStyle.Linear),
        {Size =  UDim2.fromScale(1, 1)}
    ):Play()

    function Notify:Delete()
        if Notify.Status then return end
        if mainapi.ThreadFix and setthreadidentity then
            pcall(setthreadidentity, 8)
        end

        Notify.Status = true
        TweenService:Create(NotifyMain,TweenInfo.new(1,Enum.EasingStyle.Exponential),
            {Position = UDim2.fromScale(2, 0.2)}
        ):Play()
        task.wait(1)
        NotifyFrame:ClearAllChildren()
        NotifyFrame:Destroy()
    end
    NotifyText.MouseButton1Click:Connect(Notify.Delete)
    task.delay(Notify.Duration, Notify.Delete)
end

function mainapi:SafeNotify(arg)
    task.spawn(function()
        if mainapi.ThreadFix and setthreadidentity then
            pcall(setthreadidentity, 8)
        end

        pcall(function()
            mainapi:Notify(arg)
        end)
    end)
end

mainapi:Clean(UserInputService.InputBegan:Connect(function(inputObj)
	if mainapi.BindingBusy then
		if not UserInputService:GetFocusedTextBox()
			and inputObj.KeyCode ~= Enum.KeyCode.Unknown
			and table.find(mainapi.Keybind, inputObj.KeyCode.Name)
			and mainapi.ActiveBindCancel then
			mainapi.ActiveBindCancel()
		end

		return
	end

	if not UserInputService:GetFocusedTextBox() and inputObj.KeyCode ~= Enum.KeyCode.Unknown then
		if table.find(mainapi.Keybind, inputObj.KeyCode.Name) then
			if mainapi.ThreadFix then
				pcall(setthreadidentity, 8)
			end
			mainapi.ClickGuiStatus = not mainapi.ClickGuiStatus
			setMenuBlur(mainapi.ClickGuiStatus)
			mainapi.MainScreenGui.Modal.Visible = mainapi.ClickGuiStatus
			TweenService:Create(ClickGui.UIScale,TweenInfo.new(0.3,Enum.EasingStyle.Exponential), {
				Scale = mainapi.ClickGuiStatus and mainapi.Scale.Value or 0
			}):Play()
			if mainapi.SearchBar and mainapi.SearchBar:FindFirstChild("UIScale") then
				TweenService:Create(mainapi.SearchBar.UIScale,TweenInfo.new(0.3,Enum.EasingStyle.Exponential), {
					Scale = mainapi.ClickGuiStatus and mainapi.Scale.Value or 0
				}):Play()
			end
			TweenService:Create(Gradient,TweenInfo.new(1,Enum.EasingStyle.Exponential), {
				Transparency = mainapi.ClickGuiStatus and 0.6 or 1
			}):Play()
			TweenService:Create(Gradient2,TweenInfo.new(1,Enum.EasingStyle.Exponential), {
				Transparency = mainapi.ClickGuiStatus and 0.6 or 1
			}):Play()
			TweenService:Create(Gradient,TweenInfo.new(2,Enum.EasingStyle.Exponential), {
				ImageTransparency = mainapi.ClickGuiStatus and 0.76 or 1
			}):Play()
			TweenService:Create(Gradient2,TweenInfo.new(2,Enum.EasingStyle.Exponential), {
				ImageTransparency = mainapi.ClickGuiStatus and 0.9 or 1
			}):Play()
			TweenService:Create(mainapi.TargetHudFrame.Frame.UIScale,TweenInfo.new(0.3,Enum.EasingStyle.Bounce), {
				Scale = mainapi.ClickGuiStatus and ((TargetHudScale and TargetHudScale.Value) or 1) or 0
			}):Play()
			return
		end
	end

	if mainapi.ClickGuiStatus then
		return
	end

	if os.clock() < (mainapi.SuppressBindToggleUntil or 0) then
		return
	end

	for _, v in mainapi.Modules do
		if isValidBind(v.Bind) and inputMatchesBind(inputObj, v.Bind) then
			v:Toggle()

			local Clone = SoundEffect:Clone()
			Clone.Volume = 0.6
			Clone.Parent = mainapi.MainScreenGui
			Clone:Play()

			mainapi:Notify({
				Text = v.Name .. " has been " .. (v.Enabled and "Enabled" or "Disabled");
				Duration = 1.5;
			})
		end
	end
end))

local nextBindingCancelCheck = 0
mainapi:Clean(RunService.Heartbeat:Connect(function()
	local now = os.clock()
	if now < nextBindingCancelCheck then return end
	nextBindingCancelCheck = now + 0.1
	if mainapi.BindingBusy and not mainapi.ClickGuiStatus and mainapi.ActiveBindCancel then
		mainapi.ActiveBindCancel()
	end
end))
Theme = {Value = "Shadow"}
function mainapi:SaveOptions(object, savedoptions)
	if not savedoptions then return end
	savedoptions = {}
	for _, v in object.Settings do
		if not v.Save then continue end
		v:Save(savedoptions)
	end
	return savedoptions
end



function mainapi:LoadOptions(object, savedoptions)
	for i, v in savedoptions do
		local option = object.Settings[i]
		if not option then continue end
		option:Load(v)
	end
end
function mainapi:Load()
    local savecheck = true

    if isfile('Overlay/Config/shared.txt') then
		local savedata = loadJson('Overlay/Config/shared.txt')
		if not savedata then
			savedata = {Modules = {}}
			savecheck = false
		end

		for i, v in savedata.Modules do
			local object = self.Modules[i]
			if not object then continue end

			if object.Settings and v.Settings then
				self:LoadOptions(object, v.Settings)
			end

			-- Never auto-enable saved modules on script start.

            if v.Expanded ~= object.Expanded then
				object:Expand()
			end

			if v.Bind and v.Bind.Name and v.Bind.EnumType then
				local bindObj = nil

				if v.Bind.EnumType == "Enum.KeyCode" or v.Bind.EnumType == "KeyCode" then
					pcall(function()
						bindObj = Enum.KeyCode[v.Bind.Name]
					end)
				elseif v.Bind.EnumType == "Enum.UserInputType" or v.Bind.EnumType == "UserInputType" then
					pcall(function()
						bindObj = Enum.UserInputType[v.Bind.Name]
					end)
				end

				object:SetBind(bindObj)
			else
				object:SetBind(nil)
			end
		end
    end

    if isfile('Overlay/Config/Gui.txt') then
        local savedata = loadJson('Overlay/Config/Gui.txt')
        if not savedata then
			savedata = {}
		end

        if savedata.TargetHud and savedata.TargetHud.X and savedata.TargetHud.Y then
            if TargetHudMain then
                TargetHudMain.Position = UDim2.fromOffset(savedata.TargetHud.X, savedata.TargetHud.Y)
            end
        end

        if savedata.RagebotStatus and savedata.RagebotStatus.X and savedata.RagebotStatus.Y then
            if RagebotStatusMain then
                RagebotStatusMain.Position = UDim2.fromOffset(savedata.RagebotStatus.X, savedata.RagebotStatus.Y)
            end
        end

    end

    self.Loaded = savecheck
end

function mainapi:Uninject()
    mainapi:Save()
    pcall(setMenuBlur, false)
    pcall(function()
        local blur = Lighting:FindFirstChild("LionMenuBlur")
        if blur and blur:IsA("BlurEffect") then
            blur:Destroy()
        end
    end)
    mainapi.Loaded = nil
    for _, v in self.Modules do
		if v.Enabled then
			v:Toggle()
		end
	end
    for _, v in mainapi.Connections do
		pcall(function()
			v:Disconnect()
		end)
	end
    if mainapi.ThreadFix then
		pcall(setthreadidentity, 8)
	end
    mainapi.MainScreenGui:ClearAllChildren()
    mainapi.MainScreenGui:Destroy()
    table.clear(mainapi.Libraries)
    loopClean(mainapi)
    shared.Modern = nil
end

function mainapi:SendChat(Text)
    game:GetService("TextChatService").TextChannels.RBXSystem:DisplaySystemMessage("<b><font color = \"rgb(150, 150, 150)\">[</font><font color = \"rgb(84, 140, 209)\">Modern Client</font><font color = \"rgb(150, 150, 150)\">]</font></b>: "..Text)
end
local function Bind(message)
    if message.TextSource and message.Status == Enum.TextChatMessageStatus.Sending then
        if message.Text:find('^.bind') then
            local Text = message.Text:split(' ')
            local keycode
            pcall(function()
                keycode = Enum.KeyCode[Text[3]]
            end)
            if Text[2] then
                Text[2] = Text[2]:gsub("_", " ")
            end
			if #Text == 3 and keycode and mainapi.Modules[Text[2]] then
                mainapi.Modules[Text[2]]:SetBind(keycode)
                mainapi:SendChat(Text[2].." has been bound to "..Text[3])
            else
                mainapi:SendChat("Error")
            end
			message.Text = ""
		elseif message.Text:find('^.clearbind') or message.Text:find('^.unbind') then
            local Text = message.Text:split(' ')

            if Text[2] then
                Text[2] = Text[2]:gsub("_", " ")
            end
            if #Text == 2 and mainapi.Modules[Text[2]] then
                mainapi.Modules[Text[2]]:SetBind(nil)
                mainapi:SendChat("Unbound "..Text[2])
            else
                mainapi:SendChat("Error")
            end
            message.Text = ""
        end
	end
end
task.spawn(function()
    repeat
        TextChatService.OnIncomingMessage = Bind
        task.wait(1)
    until not (mainapi.Loaded or shared.ModernLoading)
end)


local Combat = mainapi:AddCatalog({
    Name = 'Combat';
});
local Render = mainapi:AddCatalog({
    Name = 'Render';
});
local Movement = mainapi:AddCatalog({
    Name = 'Movement';
});
local Player = mainapi:AddCatalog({
    Name = 'Player';
});
local Other = mainapi:AddCatalog({
    Name = 'Other';
});



--// Interface
run(function()
    local ThemeList = {
        ["Shadow"] = {Color3.fromRGB(71, 119, 182), Color3.fromRGB(71, 119, 182)};
        ["Aqua"] = {Color3.fromRGB(185, 250, 255), Color3.fromRGB(79, 199, 200)};
        ["Hyper"] = {Color3.fromRGB(236, 110, 173), Color3.fromRGB(52, 148, 230)};
        ["Candy Cane"] = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255)};
        ["Blend"] = {Color3.fromRGB(71, 148, 253), Color3.fromRGB(71, 253, 160)};
        ["Cherry"] = {Color3.fromRGB(187, 55, 125), Color3.fromRGB(251, 211, 233)};
        ["Christmas"] = {Color3.fromRGB(255, 64, 64), Color3.fromRGB(255, 255, 255), Color3.fromRGB(64, 255, 64)};
        ["Coral"] = {Color3.fromRGB(244, 168, 150), Color3.fromRGB(52, 133, 151)};
        ["Pastel"] = {Color3.fromRGB(243, 155, 178), Color3.fromRGB(207, 196, 243)};
        ["Legacy"] = {Color3.fromRGB(112, 206, 255), Color3.fromRGB(112, 206, 255)};
        ["Lush"] = {Color3.fromRGB(168, 224, 99), Color3.fromRGB(86, 171, 47)};
        ["Bubble Gum"] = {Color3.fromRGB(243, 145, 216), Color3.fromRGB(152, 165, 243)};
        ["Creida"] = {Color3.fromRGB(156, 164, 224), Color3.fromRGB(54, 57, 78)};
        ["Digital Horizon"] = {Color3.fromRGB(95, 195, 228), Color3.fromRGB(229, 93, 135)};
        ["Gothic"] = {Color3.fromRGB(31, 30, 30), Color3.fromRGB(196, 190, 190)};
        ["Halogen"] = {Color3.fromRGB(255, 65, 108), Color3.fromRGB(255, 75, 43)};
        ["Lime Water"] = {Color3.fromRGB(18, 255, 247), Color3.fromRGB(179, 255, 171)};
        ["Creida Two"] = {Color3.fromRGB(154, 202, 235), Color3.fromRGB(88, 130, 161)};
        ["Orange Juice"] = {Color3.fromRGB(252, 74, 26), Color3.fromRGB(247, 183, 51)};
        ["Purple"] = {Color3.fromRGB(82, 67, 145), Color3.fromRGB(117, 95, 207)};
        ["Rue"] = {Color3.fromRGB(234, 118, 176), Color3.fromRGB(31, 30, 30)};
        ["Steel Fade"] = {Color3.fromRGB(66, 134, 244), Color3.fromRGB(55, 59, 68)};
        ["Water"] = {Color3.fromRGB(12, 232, 199), Color3.fromRGB(12, 163, 232)};
        ["Winter"] = {Color3.new(1, 1, 1), Color3.new(1, 1, 1)};
        ["Wood"] = {Color3.fromRGB(79, 109, 81), Color3.fromRGB(170, 139, 87), Color3.fromRGB(240, 235, 206)};
        ["Express"] = {Color3.fromRGB(173, 83, 137), Color3.fromRGB(60, 16, 83)};
        ["Satin"] = {Color3.fromRGB(215, 60, 67), Color3.fromRGB(140, 23, 39)};
        ["Sundae"] = {Color3.fromRGB(206, 74, 126), Color3.fromRGB(122, 44, 77)};
        ["Sunkist"] = {Color3.fromRGB(242, 201, 76), Color3.fromRGB(242, 153, 74)};
        ["Rainbow"] = {Color3.fromRGB(1, 1, 1), Color3.fromRGB(1, 1, 1)};
        ["Onyx"] = {Color3.fromRGB(40, 40, 40), Color3.fromRGB(70, 70, 70), Color3.fromRGB(30, 30, 30)};
    }
    local Interface
    Interface = Other:AddModule({
        Name = "Interface",
        Function = function(callback)
            if not callback then
                Interface:Toggle()
            else
                if ThemeList[Theme.Value] then
                    uipallet.MainColor = ThemeList[Theme.Value][1]
                    uipallet.SecondaryColor = ThemeList[Theme.Value][2]
                    uipallet.ThirdColor = ThemeList[Theme.Value][3]
                end
            end
        end
    })

    InterfaceMode = Interface:AddDropdown({
        Name = 'Mode',
        List = {"Fade","Breathe","Static"}
    })
    UICorner = Interface:AddToggle({
        Name = 'UICorner',
        Default = true,
        Function = function(callback)
            if callback then
                for i,v in next, UICornors do
                    if v.Name == "CatalogName" or v.Name == "NotifyMain" then
                        addCorner(v, UDim.new(0.2, 0))
                    else
                        addCorner(v, UDim.new(0.1, 0))
                    end
                end
            else
                for i,v in next, UICornors do
                    for i,v in next, v:GetChildren() do
                        if v:IsA("UICorner") then
                            v:Destroy()
                        end
                    end
                end
            end
        end
    })
    Interface:Toggle()
    task.spawn(function()
        repeat
            if ThemeList[Theme.Value] then
                uipallet.MainColor = ThemeList[Theme.Value][1]
                uipallet.SecondaryColor = ThemeList[Theme.Value][2]
                uipallet.ThirdColor = ThemeList[Theme.Value][3]
            end
            local hue = tick() * (0.2) % 1
    
            if Theme.Value == 'Rainbow' then
                uipallet.MainColor = Color3.fromHSV(hue, 0.59, 1)
                uipallet.SecondaryColor = Color3.fromHSV((hue + 0.1) % 1, 0.59, 1)
                uipallet.ThirdColor = nil
            end
            task.wait()
        until mainapi.Loaded == nil
    end)
end)

run(function()
    local SilentAim
    local Mode
    local Range
    local HitChance
    local HeadshotChance
    local AutoFire
    local AutoReload
    local Manipulation
    local ClosestPart
    local Visualize
    local RageCircle
    local Outline
    local CircleFilled
    local FOVColor1
    local FOVColor2
    local FOVColor3
    local OutlineColor1
    local OutlineColor2
    local OutlineColor3
    local FillColor1
    local FillColor2
    local FillColor3
    local Lerp
    local MovingRotation
    local RotationValue
    local RotationSpeed
    local FOVPosition
    local ShowTarget
    local CircleObject
    local FillCircleObject
    local FillGradientObject
    local FillScreenGui
    local FillGradientLines = {}
    local OutlineGradientLines = {}
    local FOVVisualPosition
    local SilentTargetPart
    local VisibleOnly
    local IgnoreProtected
    local IgnoreIf
    local DisableOnFlash
    local LimitDistance
    local MaxDistance
    local ReactionTime
    local ForgetTime
    local TargetPart
    local ClosestPartBlacklist
    local LockedTarget
    local LockedTargetPart
    local CandidateTarget
    local CandidateSince = 0
    local LastTargetSeen = 0

    local R15Parts = {
        "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
        "RightUpperLeg", "RightLowerLeg", "RightFoot",
    }
    local R15LimbParts = {
        LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
        RightUpperArm = true, RightLowerArm = true, RightHand = true,
        LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
        RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
    }
    
    local rs = cloneref(game:GetService("ReplicatedStorage"))
    local ps = cloneref(game:GetService("Players"))
    local workspace = cloneref(game:GetService("Workspace"))
    local RunService = cloneref(game:GetService("RunService"))
    local UserInputService = cloneref(game:GetService("UserInputService"))
    
    local cam = workspace.CurrentCamera
    local util = require(rs.Modules.Utility)
    local enums = require(rs.Modules.EnumLibrary)
    local lplr = ps.LocalPlayer
    
    local oldFireServer
    local silentHookInstalled = false
    local rand = Random.new()

    local function removeCircle()
        if CircleObject then
            pcall(function()
                CircleObject.Visible = false
                CircleObject:Remove()
            end)
            CircleObject = nil
        end
        if FillCircleObject then
            pcall(function()
                FillCircleObject.Visible = false
                FillCircleObject:Destroy()
            end)
            FillCircleObject = nil
            FillGradientObject = nil
        end
        if FillScreenGui then
            pcall(function()
                FillScreenGui:Destroy()
            end)
            FillScreenGui = nil
        end
        for _, line in FillGradientLines do
            line.Visible = false
            line:Remove()
        end
        table.clear(FillGradientLines)
        for _, line in OutlineGradientLines do
            line.Visible = false
            line:Remove()
        end
        table.clear(OutlineGradientLines)
    end

    local function ensureCircle()
        if not FillCircleObject then
            FillScreenGui = Instance.new("ScreenGui")
            FillScreenGui.Name = "__LionSilentFOVFill"
            FillScreenGui.IgnoreGuiInset = true
            FillScreenGui.ResetOnSpawn = false
            FillScreenGui.DisplayOrder = 1000000
            FillScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
            FillScreenGui.Parent = lplr:WaitForChild("PlayerGui")

            FillCircleObject = Instance.new("Frame")
            FillCircleObject.AnchorPoint = Vector2.new(0.5, 0.5)
            FillCircleObject.BackgroundColor3 = Color3.new(1, 1, 1)
            FillCircleObject.BorderSizePixel = 0
            FillCircleObject.Visible = false
            FillCircleObject.ZIndex = 1
            FillCircleObject.Parent = FillScreenGui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = FillCircleObject

            FillGradientObject = Instance.new("UIGradient")
            FillGradientObject.Rotation = 0
            FillGradientObject.Parent = FillCircleObject
        end

        if not CircleObject and Drawing then
            CircleObject = Drawing.new("Circle")
            CircleObject.Filled = false
            CircleObject.Color = (RageCircle and RageCircle.Value) or Color3.fromRGB(255, 255, 255)
            CircleObject.Radius = Range and Range.Value or 100
            CircleObject.Transparency = 1
            CircleObject.Thickness = 2
            CircleObject.Visible = false
        end

    end

    local function getThreeColors(option)
        if option and option.Colors then
            return option.Colors[1] or Color3.new(), option.Colors[2] or Color3.new(), option.Colors[3] or Color3.new()
        end
        return Color3.new(), Color3.new(), Color3.new()
    end

    local function getThreeTransparency(option)
        if option and option.ColorTransparency then
            return option.ColorTransparency[1] or 0, option.ColorTransparency[2] or 0, option.ColorTransparency[3] or 0
        end
        return 0, 0, 0
    end

    local function updateGradientGui(center, radius, option, visible)
        if not FillCircleObject or not FillGradientObject then return end
        FillCircleObject.Visible = visible
        if not visible then return end
        local a, b, c = getThreeColors(option)
        local ta, tb, tc = getThreeTransparency(option)
        local opacity = 0.46
        FillCircleObject.Position = UDim2.fromOffset(center.X, center.Y)
        FillCircleObject.Size = UDim2.fromOffset(radius * 2, radius * 2)
        FillGradientObject.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, a),
            ColorSequenceKeypoint.new(0.5, b),
            ColorSequenceKeypoint.new(1, c),
        })
        FillGradientObject.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1 - (opacity * (1 - ta))),
            NumberSequenceKeypoint.new(0.5, 1 - (opacity * (1 - tb))),
            NumberSequenceKeypoint.new(1, 1 - (opacity * (1 - tc))),
        })
        local rotation = RotationValue and RotationValue.Value or 0
        if MovingRotation and MovingRotation.Enabled then
            rotation += os.clock() * 360 * (RotationSpeed and RotationSpeed.Value or 1)
        end
        FillGradientObject.Rotation = rotation % 360
    end

    local function tweenFOVPosition(target, dt)
        if not FOVVisualPosition then
            FOVVisualPosition = target
            return target
        end
        local progress = math.clamp((dt or 0) / 0.18, 0, 1)
        local alpha = TweenService:GetValue(progress, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        FOVVisualPosition = FOVVisualPosition:Lerp(target, alpha)
        if (FOVVisualPosition - target).Magnitude < 0.1 then FOVVisualPosition = target end
        return FOVVisualPosition
    end

    local function gradientColor(a, b, c)
        if a and a.Colors then
            a, b, c = a.Colors[1], a.Colors[2], a.Colors[3]
        end
        local function asColor(value, fallback)
            if typeof(value) == "Color3" then
                return value
            end
            if type(value) == "table" and typeof(value.Value) == "Color3" then
                return value.Value
            end
            return fallback or Color3.fromRGB(255, 255, 255)
        end
        a = asColor(a)
        b = asColor(b, a)
        c = asColor(c, b)
        local t = (tick() * 0.25) % 1
        if t < 0.5 then
            return a:Lerp(b, t * 2)
        end
        return b:Lerp(c, (t - 0.5) * 2)
    end

    local function gradientColorAt(option, alpha)
        local a, b, c = getThreeColors(option)
        alpha = math.clamp(alpha or 0, 0, 1)
        if alpha < 0.5 then
            return a:Lerp(b, alpha * 2)
        end
        return b:Lerp(c, (alpha - 0.5) * 2)
    end

    local function hideDrawingLines(lines, startIndex)
        for i = startIndex or 1, #lines do
            if lines[i] then
                lines[i].Visible = false
            end
        end
    end

    local function getDrawingLine(lines, index)
        local line = lines[index]
        if not line and Drawing then
            line = Drawing.new("Line")
            line.Visible = false
            lines[index] = line
        end
        return line
    end

    local function updateGradientFill(lines, center, radius, option, visible, transparency)
        local count = math.clamp(math.floor(radius * 3), 240, 520)
        if not visible then
            hideDrawingLines(lines)
            return
        end
        local drawRadius = math.max(radius - 1.25, 1)
        local step = (drawRadius * 2) / count
        for i = 1, count do
            local alpha = (i - 1) / math.max(count - 1, 1)
            local x = -drawRadius + (step * (i - 0.5))
            local h = math.sqrt(math.max((drawRadius * drawRadius) - (x * x), 0)) * 2
            local line = getDrawingLine(lines, i)
            if line then
                line.From = Vector2.new(center.X + x, center.Y - (h / 2))
                line.To = Vector2.new(center.X + x, center.Y + (h / 2))
                line.Color = gradientColorAt(option, alpha)
                line.Transparency = transparency
                line.Thickness = math.max(1, step + 0.15)
                line.Visible = true
            end
        end
        hideDrawingLines(lines, count + 1)
    end

    local function updateGradientOutline(lines, center, radius, option, visible, thickness, transparency)
        local count = math.clamp(math.floor(radius * 2), 160, 320)
        if not visible then
            hideDrawingLines(lines)
            return
        end
        for i = 1, count do
            local a1 = ((i - 1) / count) * math.pi * 2
            local a2 = (i / count) * math.pi * 2
            local drawRadius = radius
            local x1, y1 = math.cos(a1) * drawRadius, math.sin(a1) * drawRadius
            local x2, y2 = math.cos(a2) * drawRadius, math.sin(a2) * drawRadius
            local alpha = ((x1 / drawRadius) + 1) * 0.5
            local line = getDrawingLine(lines, i)
            if line then
                line.From = Vector2.new(center.X + x1, center.Y + y1)
                line.To = Vector2.new(center.X + x2, center.Y + y2)
                line.Color = gradientColorAt(option, alpha)
                line.Transparency = transparency
                line.Thickness = thickness
                line.Visible = true
            end
        end
        hideDrawingLines(lines, count + 1)
    end

    mainapi:Clean(removeCircle)
    mainapi:Clean(lplr.OnTeleport:Connect(removeCircle))

    _G.LionSilentDeflecting = _G.LionSilentDeflecting or {}

    local function installSilentKatanaTracker()
        local items = lplr:FindFirstChild("PlayerScripts")
        items = items and items:FindFirstChild("Modules")
        items = items and items:FindFirstChild("Items")
        local katanaScript = items and items:FindFirstChild("Katana")
        if not katanaScript then return false end

        local ok, katana = pcall(require, katanaScript)
        if not ok or type(katana) ~= "table" then return false end
        local class = type(rawget(katana, "ReplicateFromServer")) == "function" and katana or getmetatable(katana)
        if type(class) ~= "table" or type(rawget(class, "ReplicateFromServer")) ~= "function" then return false end
        if rawget(class, "__LionSilentKatanaHook") then return true end

        class.__LionSilentKatanaHook = true
        local oldReplicate = class.ReplicateFromServer
        class.ReplicateFromServer = function(self, action, ...)
            local actionName = tostring(action):lower()
            if actionName:find("deflect", 1, true)
                or actionName == "startaiming"
                or actionName == "startblocking" then
                local fighter = self and (rawget(self, "ClientFighter") or self.ClientFighter)
                local player = fighter and fighter.Player
                if player and player ~= lplr then
                    local duration = 1
                    pcall(function()
                        duration = self.Info and self.Info.DeflectDuration or duration
                    end)
                    _G.LionSilentDeflecting[player.UserId] = tick() + duration + 0.12
                end
            end
            return oldReplicate(self, action, ...)
        end
        return true
    end

    local function shouldBlockShotForKatana(target)
        local blocker = rawget(_G, "ShouldBlockShotForKatana")
        if type(blocker) == "function" then
            local ok, blocked = pcall(blocker, target)
            if ok and blocked == true then return true end
        end
        local player = typeof(target) == "Instance" and ps:GetPlayerFromCharacter(target)
        local expires = player and _G.LionSilentDeflecting[player.UserId]
        if expires and expires > tick() then return true end
        if player and expires then _G.LionSilentDeflecting[player.UserId] = nil end
        return false
    end

    task.defer(installSilentKatanaTracker)

    local function getFighter()
        local ok, fighter = pcall(function()
            return require(lplr.PlayerScripts.Controllers.FighterController)
        end)
        if not ok or not fighter then return nil end
        return fighter.LocalFighter
    end

    local function getMuzzleScreenPosition(camera)
        local muzzle
        local fighter = getFighter()
        local item = fighter and fighter.EquippedItem
        pcall(function()
            if item and item.ViewModel and item.ViewModel.GetMuzzlePosition then
                muzzle = item.ViewModel:GetMuzzlePosition()
            end
        end)
        if not muzzle then
            pcall(function()
                local viewModels = workspace:FindFirstChild("ViewModels")
                if viewModels then
                    for _, model in viewModels:GetChildren() do
                        if model:IsA("Model") and model.Name:find(lplr.Name, 1, true) then
                            local part = model:FindFirstChild("Muzzle", true)
                                or model:FindFirstChild("Barrel", true)
                                or model:FindFirstChild("Handle", true)
                            if part and part:IsA("BasePart") then
                                muzzle = part.Position
                                break
                            elseif part and part:IsA("Attachment") then
                                muzzle = part.WorldPosition
                                break
                            end
                        end
                    end
                end
            end)
        end
        if muzzle and camera then
            local pos, visible = camera:WorldToViewportPoint(muzzle)
            if visible then
                return Vector2.new(pos.X, pos.Y)
            end
        end
    end

    local function tryAutoReload(item, fighter)
        if not AutoReload or not AutoReload.Enabled then return false end
        if not item then return false end
        if fighter and fighter.Get and fighter:Get("Reloading") then return true end

        local ammo = item.Get and item:Get("Ammo")
        if type(ammo) ~= "number" or ammo > 0 then return false end

        local reserve = item.Get and item:Get("AmmoReserve")
        if reserve ~= nil and reserve <= 0 and not (fighter and fighter.Get and fighter:Get("InfiniteAmmoReserve")) then
            return false
        end

        local reloaded = false
        if type(item.SimulateInputFromGameplayMechanic) == "function" then
            local ok, started = pcall(item.SimulateInputFromGameplayMechanic, item, "StartReloading")
            reloaded = ok and started ~= false
        end
        if not reloaded and fighter and type(fighter.Input) == "function" then
            local ok, started = pcall(fighter.Input, fighter, "StartReloading")
            reloaded = ok and started ~= false
        end
        if not reloaded and type(item.StartReloading) == "function" then
            local ok, started = pcall(item.StartReloading, item)
            reloaded = ok and started == true
        end
        return reloaded
    end

    local function getUseItemRemote()
    local remotes = rs:FindFirstChild("Remotes")
    if not remotes then return nil end

    local replication = remotes:FindFirstChild("Replication")
    if not replication then return nil end

    local fighter = replication:FindFirstChild("Fighter")
    if not fighter then return nil end

    local useItem = fighter:FindFirstChild("UseItem")
    if not useItem or not useItem:IsA("RemoteEvent") then
        return nil
    end

    return useItem
end
    -- Raycast Parameters
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.IgnoreWater = true
    
    -- AutoFire??raycast params
    local ray_params = RaycastParams.new()
    
    -- AutoFire??offset ?袁⑸ ?節? 덩?
    local vec = Vector3.new
    local offsets = {
        vec(0, 12, 0), vec(0, 16, 0), vec(0, 20, 0), vec(0, 24, 0),
        vec(0, 28, 0), vec(0, 32, 0), vec(0, 36, 0), vec(0, 40, 0)
    }
    
    -------------------------------------------------
    -- MANIPULATION (AutoFire??
    -------------------------------------------------
    
    local manipulation = {}
    
    manipulation.get_closest = function()
        if not lplr.Character or not lplr.Character:FindFirstChild("HumanoidRootPart") then
            return nil, nil
        end
        
        local target, char, dist = nil, nil, math.huge
        
        for i, v in next, ps:GetPlayers() do
            if v ~= lplr and v.Character and v.Character:FindFirstChild("Head") then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.Head.Position).Magnitude
                if mag < dist then
                    dist = mag
                    target = v.Character.Head
                    char = v.Character
                end
            end
        end
        
        return target, char
    end
    
    manipulation.calculate_point = function(origin, target_pos, target_char)
        ray_params.FilterDescendantsInstances = {lplr.Character, target_char}
        ray_params.FilterType = Enum.RaycastFilterType.Exclude
        
        if not workspace:Raycast(origin, target_pos - origin, ray_params) then
            return origin, nil
        end
        
        for i, offset in next, offsets do
            local scan_pos = origin + offset
            if not workspace:Raycast(scan_pos, target_pos - scan_pos, ray_params) then
                return scan_pos, offset.Y
            end
        end
        
        return nil, nil
    end

    local getPredictedPosition

    local function buildManipulationCameraData(fromPos, part)
        if not util or not part then return nil end
        local aimPosition = (getPredictedPosition and getPredictedPosition(part)) or part.Position
        local look = CFrame.new(fromPos, aimPosition)
        local data = {}
        data[utf8.char(1)] = {
            [utf8.char(0)] = util:EncodeCFrame(look),
            [utf8.char(1)] = util:EncodeCFrame(look),
            [utf8.char(2)] = part,
            [utf8.char(3)] = util:EncodeCFrame(part.CFrame:ToObjectSpace(CFrame.new(aimPosition)))
        }
        return data
    end

    local function getManipulationShootPosition(targetPart, targetChar)
        local camera = workspace.CurrentCamera or cam
        local fromPos = camera and camera.CFrame.Position or targetPart.Position

        if not Manipulation or not Manipulation.Enabled then
            return fromPos
        end

        local manip = manipulation.calculate_point(fromPos, targetPart.Position, targetChar)
        return manip or fromPos
    end
    
    -------------------------------------------------
    -- PREDICTION
    -------------------------------------------------
    
    getPredictedPosition = function(targetPart)
        local velocity = targetPart.AssemblyLinearVelocity or targetPart.Velocity or Vector3.zero
        local lead = math.clamp(velocity.Magnitude / 350, 0, 0.12)
        local pred = targetPart.Position + velocity * lead

        if math.abs(velocity.Y) > 2 then
            pred = pred + Vector3.new(0, velocity.Y * math.min(lead, 0.05), 0)
        end
        
        return pred
    end

    local function canSeeTarget(target)
        if not entitylib.isAlive then return false end
        if not target or not target:FindFirstChild("Head") then return false end
        
        local myPos = cam.CFrame.Position
        local targetPos = target.Head.Position
        
        rayParams.FilterDescendantsInstances = {
            lplr.Character,
            target,
            cam
        }
        
        local ray = workspace:Raycast(myPos, targetPos - myPos, rayParams)
        
        return not ray or ray.Instance:IsDescendantOf(target)
    end

    local function isProtectedTarget(target)
        if not target then return true end
        if target:FindFirstChild("InvincibilityParticles", true) then return true end
        local root = target:FindFirstChild("HumanoidRootPart")
        if not root then return true end
        for _, obj in root:GetChildren() do
            if obj:IsA("Attachment") and obj.Name == "Attachment" then
                return true
            end
        end
        return false
    end

    local function getTargetWeapon(target)
        local player = ps:GetPlayerFromCharacter(target)
        if not player then return "" end
        for _, object in target:GetDescendants() do
            local lower = object.Name:lower()
            if lower:find("riot", 1, true) or lower:find("shield", 1, true) then
                return "riot shield"
            elseif lower:find("katana", 1, true) then
                return "katana"
            end
        end
        local viewModels = workspace:FindFirstChild("ViewModels")
        if not viewModels then return "" end
        for _, model in viewModels:GetDescendants() do
            if model:IsA("Model") then
                local name = model.Name
                local lower = name:lower()
                if lower:find(player.Name:lower(), 1, true) then
                    if lower:find("riot", 1, true) or lower:find("shield", 1, true) then
                        return "riot shield"
                    elseif lower:find("katana", 1, true) then
                        return "katana"
                    end
                end
            end
        end
        return ""
    end

    local function isBlockedByRiotShield(target)
        if getTargetWeapon(target) ~= "riot shield" then return false end
        local targetRoot = target and target:FindFirstChild("HumanoidRootPart")
        local localRoot = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot or not localRoot then return false end
        local offset = localRoot.Position - targetRoot.Position
        return offset.Magnitude > 0 and targetRoot.CFrame.LookVector:Dot(offset.Unit) > 0
    end

    local function isFlashed()
        if game:GetService("Lighting"):FindFirstChild("Flashbang") then return true end
        local playerGui = lplr:FindFirstChild("PlayerGui")
        return playerGui and playerGui:FindFirstChild("FlashbangGui") ~= nil or false
    end

    local function shouldIgnoreTarget(target)
        local root = target and target:FindFirstChild("HumanoidRootPart")
        local hum = target and target:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return true end
        if VisibleOnly and VisibleOnly.Enabled and not canSeeTarget(target) then return true end
        if IgnoreProtected and IgnoreProtected.Enabled and isProtectedTarget(target) then return true end
        if LimitDistance and LimitDistance.Enabled then
            local myRoot = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot or (root.Position - myRoot.Position).Magnitude > MaxDistance.Value then return true end
        end
        local ignored = IgnoreIf and IgnoreIf.Value or {}
        if ignored["katana deflecting"] and shouldBlockShotForKatana(target) then return true end
        if ignored["blocked by riot shield"] and isBlockedByRiotShield(target) then return true end
        return false
    end
    
    -------------------------------------------------
    -- TARGET FUNCTIONS
    -------------------------------------------------
    
    local function getTargetPosition()
        local root = entitylib.isAlive and entitylib.character and entitylib.character.RootPart
        return root and root.Position or nil
    end

    local function getAimParts(char)
        local parts = {}
        if not char then return parts end
        local blacklist = ClosestPartBlacklist and ClosestPartBlacklist.Value or {}
        for _, name in ipairs(R15Parts) do
            if blacklist[name] then continue end
            local part = char:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                table.insert(parts, part)
            end
        end
        return parts
    end

    local function getFOVOrigin(targetPart)
        local camera = workspace.CurrentCamera or cam
        local mode = FOVPosition and FOVPosition.Value or ""
        local origin
        if mode == "position on target" and targetPart then
            local pos, visible = camera:WorldToViewportPoint(targetPart.Position)
            if visible then
                origin = Vector2.new(pos.X, pos.Y)
            end
        end

        if not origin and mode == "position on barrel" and camera then
            origin = getMuzzleScreenPosition(camera)
        end

        if not origin and camera then
            local viewport = camera.ViewportSize
            origin = Vector2.new(viewport.X / 2, viewport.Y / 2)
        end
        origin = origin or UserInputService:GetMouseLocation()
        return origin
    end

    local function getClosestPart(char, origin)
        local best, dist = nil, math.huge
        for _, part in ipairs(getAimParts(char)) do
            local pos, visible = cam:WorldToViewportPoint(part.Position)
            if visible then
                local d = (Vector2.new(pos.X, pos.Y) - origin).Magnitude
                if d < dist then
                    best, dist = part, d
                end
            end
        end
        return best, dist
    end
    
    -- Position ? ル??꾤땟??? 360?????? 維????????좊읈?????좊읈?? 싲 ?  ???????
    local function getTargetByPosition()
        local myPos = getTargetPosition()
        if not myPos then return nil end
        
        local maxRange = RageCircle.Enabled and Range.Value or math.huge
        local best, dist = nil, maxRange
        
        for _, v in pairs(ps:GetPlayers()) do
            if v ~= lplr and v.Character then
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                local hum = v.Character:FindFirstChildOfClass("Humanoid")
                
                if hrp and hum and hum.Health > 0 and not shouldIgnoreTarget(v.Character) then
                    local origin = getFOVOrigin()
                    local fixedPart = v.Character:FindFirstChild(TargetPart and TargetPart.Value or "Head")
                    local targetPart, screenDist = fixedPart, 0
                    if ClosestPart and ClosestPart.Enabled then
                        targetPart, screenDist = getClosestPart(v.Character, origin)
                    end
                    local d = targetPart and (RageCircle.Enabled and screenDist or (hrp.Position - myPos).Magnitude) or math.huge
                    if d < dist then
                        best = v.Character
                        SilentTargetPart = targetPart
                        dist = d
                    end
                end
            end
        end
        
        return best, SilentTargetPart
    end
    
    -- Mouse ? ル??꾤땟??? ? ル?????????  ??? (Circle ??? ? 땾????源끹걬癲?? 꾧???????????   ???? 챶??
    local function getTargetByMouse()
        local mouse = getFOVOrigin()
        local maxRange = RageCircle.Enabled and Range.Value or math.huge
        local best, dist = nil, maxRange
        
        for _, v in pairs(ps:GetPlayers()) do
            if v ~= lplr and v.Character then
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                local hum = v.Character:FindFirstChildOfClass("Humanoid")
                
                if hrp and hum and hum.Health > 0 and not shouldIgnoreTarget(v.Character) then
                    local fixedPart = v.Character:FindFirstChild(TargetPart and TargetPart.Value or "Head")
                    local part = (ClosestPart and ClosestPart.Enabled) and getClosestPart(v.Character, mouse) or fixedPart
                    local pos, vis
                    if part then
                        pos, vis = cam:WorldToViewportPoint(part.Position)
                    end
                    if part and vis then
                        local d = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                        if d < dist then
                            best = v.Character
                            SilentTargetPart = part
                            dist = d
                        end
                    end
                end
            end
        end
        
        return best, SilentTargetPart
    end
    
    -- Rage ? ル??꾤땟??? ???뺤깓?? ?????좊읈?????좊읈?? 싲 ?  ???????
    local function getTargetRage()
        local myPos = getTargetPosition()
        if not myPos then return nil end
        
        local best, dist = nil, 1000
        
        for _, v in pairs(ps:GetPlayers()) do
            if v ~= lplr and v.Character then
                local head = v.Character:FindFirstChild("Head")
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                local hum = v.Character:FindFirstChildOfClass("Humanoid")
                
                if head and hrp and hum and hum.Health > 0 then
                    local d = (hrp.Position - myPos).Magnitude
                    if d < dist then
                        best = v.Character
                        dist = d
                    end
                end
            end
        end
        
        return best
    end

    local function isLobby()
        local pg = lplr:FindFirstChild("PlayerGui")
        if not pg then return false end
        
        local main = pg:FindFirstChild("MainGui")
        if not main then return false end
        
        local frame = main:FindFirstChild("MainFrame")
        if not frame then return false end
        
        local lobby = frame:FindFirstChild("Lobby")
        if not lobby then return false end
        
        local currency = lobby:FindFirstChild("Currency")
        if not currency then return false end
        
        return currency.Visible == true
    end
    
    local function getTarget()
        SilentTargetPart = nil
        if isShootingRange() then
            LockedTarget = nil
            LockedTargetPart = nil
            CandidateTarget = nil
            return nil
        end
        if DisableOnFlash and DisableOnFlash.Enabled and isFlashed() then
            LockedTarget = nil
            LockedTargetPart = nil
            CandidateTarget = nil
            return nil
        end

        local target, part
        if FOVPosition and FOVPosition.Value == "position on target" then
            target, part = getTargetByPosition()
        else
            target, part = getTargetByMouse()
        end

        local now = tick()
        if target then
            if target ~= CandidateTarget then
                CandidateTarget = target
                CandidateSince = now
            end

            local reaction = (ReactionTime and ReactionTime.Value or 0) / 1000
            if target == LockedTarget or now - CandidateSince >= reaction then
                LockedTarget = target
                LockedTargetPart = part
                LastTargetSeen = now
            end
        else
            CandidateTarget = nil
        end

        local forget = ForgetTime and ForgetTime.Value or 0
        if LockedTarget and now - LastTargetSeen <= forget then
            local hum = LockedTarget:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and LockedTargetPart and LockedTargetPart.Parent == LockedTarget then
                SilentTargetPart = LockedTargetPart
                return LockedTarget
            end
        end

        if not target or target ~= LockedTarget then
            SilentTargetPart = nil
            return nil
        end
        SilentTargetPart = LockedTargetPart or part
        return LockedTarget
    end
    
    -------------------------------------------------
    -- RANGE CIRCLE CHECK
    -------------------------------------------------
    
    local function isInCircleRange(target)
        -- Circle????? ? 땾????源끹걬癲?????true (? 꾧???????????   ???? 챶??
        if not RageCircle.Enabled then return true end
        if not target or not target:FindFirstChild("Head") then return false end

        local part = SilentTargetPart or target:FindFirstChild("Head")
        local pos, vis = cam:WorldToViewportPoint(part.Position)
        if not vis then return false end

        local mouse = getFOVOrigin()
        return (Vector2.new(pos.X, pos.Y) - mouse).Magnitude <= Range.Value
    end
    
    -------------------------------------------------
    -- SILENT AIM
    -------------------------------------------------
    
    SilentAim = Combat:AddModule({
        Name = 'Silent Aim',
        Function = function(callback)
            if callback then
                if RageCircle and RageCircle.Enabled then
                    ensureCircle()
                end

                if CircleObject then
                    CircleObject.Visible = RageCircle and RageCircle.Enabled or false
                end
                
                if not silentHookInstalled then
                    local useItemRemote = getUseItemRemote()
                    if not useItemRemote then
                        return
                    end

                    local hookOk, hookErr = pcall(function()
                        oldFireServer = hookfunction(
                            useItemRemote.FireServer,
                            newcclosure(function(self, obj, action, cameradata, ...)
                        
                        if SilentAim.Enabled and action == enums:ToEnum("StartShooting") then
                    
                            if isLobby() then
                                return oldFireServer(self, obj, action, cameradata, ...)
                            end

                            local fighter = getFighter()
                            local item = fighter and fighter.EquippedItem
                            if tryAutoReload(item, fighter) then
                                return nil
                            end
                            
                            -- HitChance ? ル????? 물?
                            if rand:NextNumber(0, 100) > HitChance.Value then
                                return oldFireServer(self, obj, action, cameradata, ...)
                            end
                            
                            local target = getTarget()
                            
                            if target and isInCircleRange(target) and target:FindFirstChild("Head") and target:FindFirstChild("HumanoidRootPart") then
                                
                                -- HeadshotChance ? ル????? 물?
                                local targetPart = SilentTargetPart
                                if not targetPart and ClosestPart and ClosestPart.Enabled then
                                    targetPart = select(1, getClosestPart(target, getFOVOrigin()))
                                end
                                if not targetPart then
                                    targetPart = (HeadshotChance and rand:NextNumber(0, 100) <= HeadshotChance.Value)
                                        and target.Head
                                        or target.HumanoidRootPart
                                end
                                targetPart = targetPart or target.Head or target.HumanoidRootPart
                                
                                -- Prediction ???? 굣??
                                local fromPos = getManipulationShootPosition(targetPart, target)
                                cameradata = buildManipulationCameraData(fromPos, targetPart) or cameradata
                                
                                -- Target HUD
                                if ShowTarget.Enabled and mainapi.Libraries.Targetinfo then
                                    local ent = select(1, entitylib.getEntity(target))
                                    if ent then
                                        mainapi.Libraries.Targetinfo.Targets[ent] = tick() + 2
                                    end
                                end
                                
                                return oldFireServer(self, obj, action, cameradata, ...)
                            end
                        end
                        
                        return oldFireServer(self, obj, action, cameradata, ...)
                            end)
                        )
                    end)
                    if not hookOk then
                        warn("[Silent Aim] hook failed:", hookErr)
                        return
                    end
                    silentHookInstalled = true
                end
                
                -- AutoFire Loop (???? ??manipulation ? ?? ?먰맪?
                if AutoFire and AutoFire.Enabled then
                    local fighter = require(lplr.PlayerScripts.Controllers.FighterController)
                    
                    SilentAim:Clean(RunService.Heartbeat:Connect(function()
                        if not lplr.Character then return end
                        if mainapi.ClickGuiStatus then return end
                        if isLobby() then return end
                        
                        local root = lplr.Character:FindFirstChild("HumanoidRootPart")
                        if not root then return end
                        
                        if not fighter or not fighter.LocalFighter then return end

                        local localFighter = fighter.LocalFighter
                        local item = localFighter.EquippedItem
                        if not item then return end
                        if tryAutoReload(item, localFighter) then return end

                        local target_char = getTarget()
                        local target_part = SilentTargetPart
                        if not target_part or not target_char then return end
                        
                        -- Range Circle ? ル????? 물?(Circle????諛몄?????源낃???????
                        if RageCircle.Enabled and not isInCircleRange(target_char) then
                            return
                        end
                        
                        local shoot_pos = getManipulationShootPosition(target_part, target_char)
                        local cameradata = buildManipulationCameraData(shoot_pos, target_part)
                        if not cameradata then return end
                        
                        local useItemRemote = getUseItemRemote()
if not useItemRemote then
    return
end

useItemRemote:FireServer(item:Get("ObjectID"), enums:ToEnum("StartShooting"), cameradata, nil)
                    end))
                end
                
                -- TargetHud Update Loop
                local nextTargetHudUpdate = 0
                SilentAim:Clean(RunService.Heartbeat:Connect(function()
                    local now = os.clock()
                    if now < nextTargetHudUpdate then return end
                    nextTargetHudUpdate = now + 0.1
                    if mainapi.Libraries.Targetinfo then
                        mainapi.Libraries.Targetinfo:UpdateInfo()
                    end
                end))

                -- Circle Update Loop
                SilentAim:Clean(RunService.RenderStepped:Connect(function(dt)
                    local fovPos = tweenFOVPosition(getFOVOrigin(SilentTargetPart), dt)
                    local radius = Range.Value
                    local visible = SilentAim.Enabled and RageCircle.Enabled
                    updateGradientGui(fovPos, radius, CircleFilled, visible and CircleFilled and CircleFilled.Enabled)
                    if CircleObject then
                        CircleObject.Position = fovPos
                        CircleObject.Visible = visible
                        CircleObject.Radius = radius
                        CircleObject.Color = select(2, getThreeColors(Outline and Outline.Enabled and Outline or RageCircle))
                        CircleObject.Transparency = 1
                        CircleObject.Filled = false
                        CircleObject.Thickness = Outline and Outline.Enabled and 2 or 1
                    end
                    hideDrawingLines(OutlineGradientLines)
                end))
                
                -- ???????? 밸Ŧ? 얕 ????hook ?????
                SilentAim:Clean(lplr.CharacterAdded:Connect(function()
                    task.wait(1)
                    if SilentAim.Enabled then
                        SilentAim:Toggle()
                        task.wait()
                        SilentAim:Toggle()
                    end
                end))

                SilentAim:Clean(lplr.OnTeleport:Connect(removeCircle))
                
            else
                removeCircle()
            end
        end,
        ExtraText = function()
            return FOVPosition and FOVPosition.Value or ""
        end
    })
    
    -------------------------------------------------
    -- SETTINGS
    -------------------------------------------------

    VisibleOnly = SilentAim:AddToggle({
        Name = 'visible only',
        Tab = 'targeting',
        SeparateGroup = true
    })

    IgnoreProtected = SilentAim:AddToggle({
        Name = 'ignore protected',
        Tab = 'targeting',
        SeparateGroup = true
    })

    IgnoreIf = SilentAim:AddDropdown({
        Name = 'ignore if',
        Tab = 'targeting',
        SeparateGroup = true,
        List = {'katana deflecting', 'blocked by riot shield'},
        Default = {['katana deflecting'] = true, ['blocked by riot shield'] = true},
        Multi = true
    })

    DisableOnFlash = SilentAim:AddToggle({
        Name = 'disable on flash',
        Tab = 'targeting',
        SeparateGroup = true
    })

    LimitDistance = SilentAim:AddToggle({
        Name = 'limit distance',
        Tab = 'targeting',
        SeparateGroup = true
    })

    MaxDistance = SilentAim:AddSlider({
        Name = 'max distance',
        Tab = 'targeting',
        SeparateGroup = true,
        Min = 10,
        Max = 1000,
        Default = 250,
        Suffix = 's'
    })

    ReactionTime = SilentAim:AddSlider({
        Name = 'reaction time',
        Tab = 'targeting',
        SeparateGroup = true,
        Min = 0,
        Max = 1000,
        Default = 0,
        Suffix = 'ms'
    })

    ForgetTime = SilentAim:AddSlider({
        Name = 'forget time',
        Tab = 'targeting',
        SeparateGroup = true,
        Min = 0,
        Max = 10,
        Default = 1,
        Decimal = 10,
        Suffix = 's'
    })

    TargetPart = SilentAim:AddDropdown({
        Name = 'target part',
        Tab = 'targeting',
        SeparateGroup = true,
        List = R15Parts,
        Default = 'Head',
        Function = function()
            LockedTarget = nil
            LockedTargetPart = nil
        end
    })

    ClosestPartBlacklist = SilentAim:AddDropdown({
        Name = 'closest part blacklist',
        Tab = 'targeting',
        SeparateGroup = true,
        List = R15Parts,
        Default = R15LimbParts,
        Multi = true
    })

    Manipulation = SilentAim:AddToggle({
        Name = 'manipulation',
        Default = false
    })

    ClosestPart = SilentAim:AddToggle({
        Name = 'closest part',
        Default = false
    })

    Visualize = SilentAim:AddToggle({
        Name = 'visualize',
        Default = true,
        Function = function(val)
            ShowTarget.Enabled = val
        end
    })
    
    if false then
    Mode = SilentAim:AddDropdown({
        Name = 'Mode',
        List = {'Position', 'Mouse', 'Rage'},
        Function = function(val)
            Range.Frame.Visible = (val ~= "Rage")
        end
    })
    end
    
    HeadshotChance = SilentAim:AddSlider({
        Name = 'headshot chance',
        Min = 0,
        Max = 100,
        Default = 65,
        Suffix = '%'
    })
    
    AutoFire = SilentAim:AddToggle({
        Name = 'auto shoot',
        Function = function(callback)
            if SilentAim.Enabled then
                SilentAim:Toggle()
                SilentAim:Toggle()
            end
        end
    })

    AutoReload = SilentAim:AddToggle({
        Name = 'auto reload',
        Default = true
    })

    RageCircle = SilentAim:AddToggle({
        Name = 'show fov',
        Default = true,
        Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
        ColorTransparency = {0, 0, 0},
        Function = function(state)
            if state then
                ensureCircle()
                if FillCircleObject then
                    FillCircleObject.Visible = false
                end
                if CircleObject then
                    CircleObject.Visible = false
                end
            else
                hideDrawingLines(FillGradientLines)
                hideDrawingLines(OutlineGradientLines)
                removeCircle()
            end
            
            CircleFilled.Frame.Visible = state
        end
    })

    Outline = SilentAim:AddToggle({
        Name = 'outline',
        Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
        ColorTransparency = {0, 0, 0},
        Function = function()
            if CircleObject then
                CircleObject.Thickness = Outline.Enabled and 2 or 1
            end
        end
    })

    CircleFilled = SilentAim:AddToggle({
        Name = 'fill',
        Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
        ColorTransparency = {0, 0, 0},
        Function = function(val)
            hideDrawingLines(FillGradientLines)
            if FillCircleObject then
                FillCircleObject.Visible = false
            end
            if CircleObject then
                CircleObject.Filled = false
            end
        end
    })
    task.defer(function()
        if RageCircle and RageCircle.Enabled then
            ensureCircle()
        end
    end)

    Lerp = SilentAim:AddSlider({
        Name = 'lerp',
        Min = 1,
        Max = 10,
        Default = 1,
        Decimal = 10,
        Suffix = 'x'
    })

    MovingRotation = SilentAim:AddToggle({
        Name = 'moving rotation'
    })

    RotationValue = SilentAim:AddSlider({
        Name = 'rotation',
        Min = 0,
        Max = 360,
        Default = 0,
        Suffix = '°',
        Compact = true
    })

    RotationSpeed = SilentAim:AddSlider({
        Name = 'speed',
        Min = 1,
        Max = 10,
        Default = 1,
        Decimal = 10,
        Suffix = 'rps',
        Compact = true,
        Parent = RotationValue
    })

    FOVPosition = SilentAim:AddDropdown({
        Name = 'fov settings',
        List = {'', 'position on target', 'position on barrel'},
        Default = '',
        Function = function()
            SilentTargetPart = nil
        end
    })
    
    Range = SilentAim:AddSlider({
        Name = 'radius',
        Min = 10,
        Max = 1000,
        Default = 100,
        Function = function(val)
            if FillCircleObject then
                FillCircleObject.Size = UDim2.fromOffset(val * 2, val * 2)
            end
            if CircleObject then
                CircleObject.Radius = val
            end
        end,
        Suffix = 'px'
    })

    HitChance = SilentAim:AddSlider({
        Name = 'hit chance',
        Min = 0,
        Max = 100,
        Default = 100,
        Suffix = '%'
    })
    
    if false then
    ShowTarget = SilentAim:AddToggle({
        Name = 'Target Hud',
        Darker = true,
        Visible = false,
        Function = function(val)
            
        end
    })
    end
    ShowTarget = {Enabled = Visualize and Visualize.Enabled or false}
end)

run(function()
	local ESP
	local Targets
	local Color
	local ESPColor
	local Method
	local BoundingBox
	local Filled
	local HealthBar
	local Name
	local Weapon
	local DistanceText
	local Skeleton
	local ResizeOutline
	local MovingHealthbar
	local HealthbarType
	local HealthSlices
	local HealthSpeed
	local HealthLerp
	local DisplayName
	local Background
	local Teammates
	local Distance
	local DistanceLimit
	local StaringText
	local HealthText
	local FlagFont
	local FlagStyle
	local FlagPrefix
	local FlagBridge
	local WorldName
	local WorldImage
	local WorldDistance
	local WorldScale
	local WorldLerp
	local WorldWhitelist
	local WorldFont
	local Reference = {}
	local WorldReference = {}
	local WorldRootReference = {}
	local worldESPVisible = false
	local methodused
	
	local function ESPWorldToViewport(pos)
		if not gameCamera then return nil end
		local newpos, visible = gameCamera:WorldToViewportPoint(pos)
		if not visible or newpos.Z <= 0 then return nil end
		return Vector2.new(newpos.X, newpos.Y)
	end

	local function getESPColor(ent)
		if ESPColor and typeof(ESPColor.Value) == "Color3" then
			return ESPColor.Value
		end
		local ok, color = pcall(function()
			return ent and entitylib.getEntityColor(ent) or nil
		end)
		return (ok and color) or uipallet.FinalColor or Color3.fromRGB(255, 255, 255)
	end

	local function espToggleColor(toggle, index, fallback)
		if toggle and toggle.Colors and typeof(toggle.Colors[index or 1]) == "Color3" then
			return toggle.Colors[index or 1]
		end
		if toggle and typeof(toggle.Value) == "Color3" then
			return toggle.Value
		end
		return fallback or getESPColor()
	end

	local function espHealthColor(percent)
		percent = math.clamp(percent or 0, 0, 1)
		local c1 = espToggleColor(HealthBar, 1, Color3.fromRGB(0, 255, 0))
		local c2 = espToggleColor(HealthBar, 2, Color3.fromRGB(255, 255, 0))
		local c3 = espToggleColor(HealthBar, 3, Color3.fromRGB(255, 0, 0))
		if percent >= 0.5 then
			return c2:Lerp(c1, (percent - 0.5) * 2)
		end
		return c3:Lerp(c2, percent * 2)
	end

	local function espGradientColor(toggle, phase, fallback)
		local c1 = espToggleColor(toggle, 1, fallback)
		local c2 = espToggleColor(toggle, 2, c1)
		local c3 = espToggleColor(toggle, 3, c2)
		phase = math.clamp(phase or 0, 0, 1)
		if phase <= 0.5 then
			return c1:Lerp(c2, phase * 2)
		end
		return c2:Lerp(c3, (phase - 0.5) * 2)
	end

	local function espStaticPhase(ent, offset)
		local seed = 0
		local player = ent and ent.Player
		if player then
			seed = tonumber(player.UserId) or 0
		elseif ent and ent.Character then
			for i = 1, #ent.Character.Name do
				seed += string.byte(ent.Character.Name, i)
			end
		end
		return ((seed % 997) / 997 + (offset or 0)) % 1
	end

	local function getPlayerWeaponName(player)
		if not player then return "unknown" end

		local viewModels = workspace:FindFirstChild("ViewModels")
		if viewModels then
			for _, model in viewModels:GetChildren() do
				if model:IsA("Model") then
					local split = model.Name:find(" - ", 1, true)
					if split and model.Name:sub(1, split - 1) == player.Name then
						local weaponName = model.Name:sub(split + 3)
						if weaponName ~= "" then
							return weaponName
						end
					end
				end
			end
		end

		for _, key in {"Weapon", "CurrentWeapon", "EquippedWeapon", "Loadout", "LoadoutWeapon"} do
			local value = player:GetAttribute(key)
			if value ~= nil then
				return tostring(value)
			end
		end

		local char = player.Character
		if char then
			for _, child in char:GetChildren() do
				if child:IsA("Tool") then
					return child.Name
				end
			end
		end

		return "unknown"
	end

	local function charPart(char, ...)
		if not char then return nil end
		for _, name in {...} do
			local part = char:FindFirstChild(name)
			if part and part:IsA("BasePart") then
				return part
			end
		end
	end

	local function isPreviewHiddenPart(obj)
		if not obj:IsA("BasePart") then return false end
		local name = obj.Name:lower()
		local allowed = {
			head = true,
			torso = true,
			uppertorso = true,
			lowertorso = true,
			["left arm"] = true,
			["right arm"] = true,
			["left leg"] = true,
			["right leg"] = true,
			leftupperarm = true,
			leftlowerarm = true,
			lefthand = true,
			rightupperarm = true,
			rightlowerarm = true,
			righthand = true,
			leftupperleg = true,
			leftlowerleg = true,
			leftfoot = true,
			rightupperleg = true,
			rightlowerleg = true,
			rightfoot = true,
			handle = true,
		}
		if not allowed[name] then
			return true
		end
		return name == "humanoidrootpart"
			or name:find("hitbox", 1, true) ~= nil
			or name:find("collision", 1, true) ~= nil
			or name:find("collider", 1, true) ~= nil
			or name:find("hurtbox", 1, true) ~= nil
			or name:find("root", 1, true) ~= nil
			or name:find("bbox", 1, true) ~= nil
			or name:find("bounding", 1, true) ~= nil
			or name:find("server", 1, true) ~= nil
	end

	local function setESPVisible(container, visible)
		for _, obj in container do
			if type(obj) == "table" and obj.Remove == nil and obj.Visible == nil then
				setESPVisible(obj, visible)
			elseif obj then
				pcall(function()
					obj.Visible = visible
				end)
			end
		end
	end

	local function removeESPObjects(container)
		for _, obj in container do
			if type(obj) == "table" and obj.Remove == nil and obj.Visible == nil then
				removeESPObjects(obj)
			elseif obj then
				pcall(function()
					obj.Visible = false
					obj:Remove()
				end)
			end
		end
	end

	local function updateSkeletonDrawing(lines, ent, visible)
		if not lines then return end
		if not visible then
			setESPVisible(lines, false)
			return
		end

		local char = ent.Character
		local ok, entColor = pcall(function()
			return entitylib.getEntityColor(ent)
		end)
		local fallback = (ok and entColor) or getESPColor(ent)
		local headPart = charPart(char, "Head")
		local upperTorso = charPart(char, "UpperTorso", "Torso", "HumanoidRootPart")
		local lowerTorso = charPart(char, "LowerTorso", "Torso", "HumanoidRootPart")
		local leftArm = charPart(char, "LeftHand", "LeftLowerArm", "LeftUpperArm", "Left Arm")
		local rightArm = charPart(char, "RightHand", "RightLowerArm", "RightUpperArm", "Right Arm")
		local leftLeg = charPart(char, "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "Left Leg")
		local rightLeg = charPart(char, "RightFoot", "RightLowerLeg", "RightUpperLeg", "Right Leg")
		if not (headPart and upperTorso and lowerTorso) then
			setESPVisible(lines, false)
			return
		end
		setESPVisible(lines, false)

		local function point(part)
			return part and ESPWorldToViewport(part.Position) or nil
		end

		local upper = point(upperTorso)
		local lower = point(lowerTorso)
		local head = point(headPart)
		if not upper or not lower or not head then
			setESPVisible(lines, false)
			return
		end
		local leftUpperArm = charPart(char, "LeftUpperArm", "Left Arm")
		local leftLowerArm = charPart(char, "LeftLowerArm", "LeftHand", "Left Arm")
		local rightUpperArm = charPart(char, "RightUpperArm", "Right Arm")
		local rightLowerArm = charPart(char, "RightLowerArm", "RightHand", "Right Arm")
		local leftUpperLeg = charPart(char, "LeftUpperLeg", "Left Leg")
		local leftLowerLeg = charPart(char, "LeftLowerLeg", "LeftFoot", "Left Leg")
		local rightUpperLeg = charPart(char, "RightUpperLeg", "Right Leg")
		local rightLowerLeg = charPart(char, "RightLowerLeg", "RightFoot", "Right Leg")
		local lineMap = {
			{"Head", upper, head},
			{"Torso", upper, lower},
			{"LeftArm", upper, point(leftUpperArm or leftArm)},
			{"LeftLowerArm", point(leftUpperArm), point(leftLowerArm or leftArm)},
			{"RightArm", upper, point(rightUpperArm or rightArm)},
			{"RightLowerArm", point(rightUpperArm), point(rightLowerArm or rightArm)},
			{"LeftLeg", lower, point(leftUpperLeg or leftLeg)},
			{"LeftLowerLeg", point(leftUpperLeg), point(leftLowerLeg or leftLeg)},
			{"RightLeg", lower, point(rightUpperLeg or rightLeg)},
			{"RightLowerLeg", point(rightUpperLeg), point(rightLowerLeg or rightLeg)},
		}
		for index, info in ipairs(lineMap) do
			local line = lines[info[1]]
			if line then
				if info[2] and info[3] then
					line.Visible = true
					line.Thickness = 2
					line.Color = espGradientColor(Skeleton, (index - 1) / math.max(#lineMap - 1, 1), fallback)
					line.From = info[2]
					line.To = info[3]
				else
					line.Visible = false
				end
			end
		end
	end

	local ESPPreview

	local function viewportPoint(camera, viewport, pos)
		if not camera or not viewport then return nil end
		local size = viewport.AbsoluteSize
		if size.X <= 0 or size.Y <= 0 then return nil end
		local relative = camera.CFrame:PointToObjectSpace(pos)
		if relative.Z >= -0.05 then return nil end
		local scale = (size.Y * 0.5) / math.tan(math.rad(camera.FieldOfView) * 0.5)
		return Vector2.new((relative.X / -relative.Z) * scale + (size.X * 0.5), (-relative.Y / -relative.Z) * scale + (size.Y * 0.5))
	end

	local function setViewportLine(line, from, to, color)
		if not line or not from or not to then
			if line then line.Visible = false end
			return
		end
		local delta = to - from
		local length = delta.Magnitude
		if length < 2 then
			line.Visible = false
			return
		end
		line.Visible = true
		line.BackgroundColor3 = color
		line.Position = UDim2.fromOffset((from.X + to.X) * 0.5, (from.Y + to.Y) * 0.5)
		line.Size = UDim2.fromOffset(length, 2)
		line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
	end

	local function updateViewportSkeleton()
		local parts = ESPPreview.Parts
		local lines = parts and parts.ViewportSkeleton
		local model = ESPPreview.VisualModel
		local camera = parts and parts.ViewCamera
		local viewport = parts and parts.Viewport
		if not lines then return end
		for _, line in lines do
			line.Visible = false
		end
		if not (model and camera and viewport and Skeleton and Skeleton.Enabled) then return end

		local headPart = charPart(model, "Head")
		local upperTorso = charPart(model, "UpperTorso", "Torso")
		local lowerTorso = charPart(model, "LowerTorso", "Torso")
		if not (headPart and upperTorso and lowerTorso) then return end

		local function p(part)
			return part and viewportPoint(camera, viewport, part.Position)
		end
		local upper = p(upperTorso)
		local lower = p(lowerTorso)
		local head = p(headPart)
		local leftUpperArm = p(charPart(model, "LeftUpperArm", "Left Arm"))
		local leftLowerArm = p(charPart(model, "LeftLowerArm", "LeftHand", "Left Arm"))
		local rightUpperArm = p(charPart(model, "RightUpperArm", "Right Arm"))
		local rightLowerArm = p(charPart(model, "RightLowerArm", "RightHand", "Right Arm"))
		local leftUpperLeg = p(charPart(model, "LeftUpperLeg", "Left Leg"))
		local leftLowerLeg = p(charPart(model, "LeftLowerLeg", "LeftFoot", "Left Leg"))
		local rightUpperLeg = p(charPart(model, "RightUpperLeg", "Right Leg"))
		local rightLowerLeg = p(charPart(model, "RightLowerLeg", "RightFoot", "Right Leg"))
		local color = getESPColor()
		local lineMap = {
			{"Head", upper, head},
			{"Torso", upper, lower},
			{"LeftArm", upper, leftUpperArm},
			{"LeftLowerArm", leftUpperArm, leftLowerArm},
			{"RightArm", upper, rightUpperArm},
			{"RightLowerArm", rightUpperArm, rightLowerArm},
			{"LeftLeg", lower, leftUpperLeg},
			{"LeftLowerLeg", leftUpperLeg, leftLowerLeg},
			{"RightLeg", lower, rightUpperLeg},
			{"RightLowerLeg", rightUpperLeg, rightLowerLeg},
		}
		for index, info in ipairs(lineMap) do
			setViewportLine(lines[info[1]], info[2], info[3], espGradientColor(Skeleton, (index - 1) / math.max(#lineMap - 1, 1), color))
		end
	end

	local function ensureTextBackground(entityEsp)
		if not entityEsp or entityEsp.TextBKG then return end
		local textBkg = Drawing.new('Square')
		textBkg.Transparency = 0.35
		textBkg.ZIndex = 1
		textBkg.Thickness = 1
		textBkg.Filled = true
		textBkg.Color = Color3.new()
		textBkg.Visible = false
		entityEsp.TextBKG = textBkg
	end

	local function ensureFillBox(entityEsp)
		if not entityEsp or entityEsp.Border2 then return end
		local fillBox = Drawing.new('Square')
		fillBox.Transparency = 0.35
		fillBox.ZIndex = 1
		fillBox.Thickness = 1
		fillBox.Filled = true
		fillBox.Color = Color3.new()
		fillBox.Visible = false
		entityEsp.Border2 = fillBox
	end

	local function ensureNameText(entityEsp, ent)
		if not entityEsp or entityEsp.Text then return end
		entityEsp.Drop = Drawing.new('Text')
		entityEsp.Drop.Color = Color3.new()
		entityEsp.Drop.Text = ent.Player and (DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
		entityEsp.Drop.ZIndex = 2
		entityEsp.Drop.Center = true
		entityEsp.Drop.Size = 20
		entityEsp.Text = Drawing.new('Text')
		entityEsp.Text.Text = entityEsp.Drop.Text
		entityEsp.Text.ZIndex = 3
		entityEsp.Text.Color = espGradientColor(Name, 0.5, entityEsp.Main and entityEsp.Main.Color or getESPColor(ent))
		entityEsp.Text.Center = true
		entityEsp.Text.Size = 20
	end

	ESPPreview = {
		Gui = nil,
		Model = nil,
		VisualModel = nil,
		Angle = 0,
		Offset = Vector3.new(),
		Wanted = false,
		Parts = {},
		Drawings = nil,
		Frame = nil,
		Distance = 45,
	}

	local function isLionMenuOpen()
		if typeof(LionLibrary) ~= "table" then
			return nil
		end

		for _, key in ipairs({"Opened", "Open", "Toggled", "IsOpen", "MenuOpen"}) do
			local value = rawget(LionLibrary, key)
			if type(value) == "boolean" then
				return value
			end
		end

		for _, key in ipairs({"MainFrame", "Main", "Holder", "Window", "ScreenGui", "Gui"}) do
			local value = rawget(LionLibrary, key)
			if typeof(value) == "Instance" then
				if value:IsA("ScreenGui") then
					return value.Enabled
				elseif value:IsA("GuiObject") then
					return value.Visible
				end
			end
		end

		return mainapi.ClickGuiStatus
	end

	local function cleanupESPPreviewDrawings()
		if ESPPreview.Drawings then
			removeESPObjects(ESPPreview.Drawings)
			ESPPreview.Drawings = nil
		end
	end

	local function ensureESPPreviewDrawings()
		if ESPPreview.Drawings then
			return ESPPreview.Drawings
		end

		local drawings = {}
		drawings.Main = Drawing.new('Square')
		drawings.Main.Filled = false
		drawings.Main.Thickness = 1
		drawings.Main.ZIndex = 2
		drawings.Border = Drawing.new('Square')
		drawings.Border.Transparency = 0.35
		drawings.Border.Filled = false
		drawings.Border.Thickness = 1
		drawings.Border.Color = Color3.new()
		drawings.Border.ZIndex = 1
		drawings.Fill = Drawing.new('Square')
		drawings.Fill.Filled = true
		drawings.Fill.Transparency = 0.35
		drawings.Fill.Thickness = 1
		drawings.Fill.ZIndex = 1
		drawings.HealthLine = Drawing.new('Line')
		drawings.HealthLine.Thickness = 1
		drawings.HealthLine.ZIndex = 2
		drawings.HealthBorder = Drawing.new('Line')
		drawings.HealthBorder.Thickness = 3
		drawings.HealthBorder.Transparency = 0.35
		drawings.HealthBorder.Color = Color3.new()
		drawings.HealthBorder.ZIndex = 1
		drawings.Text = Drawing.new('Text')
		drawings.Text.Center = true
		drawings.Text.Size = 20
		drawings.Text.ZIndex = 2
		drawings.TextBKG = Drawing.new('Square')
		drawings.TextBKG.Filled = true
		drawings.TextBKG.Transparency = 0.35
		drawings.TextBKG.Thickness = 1
		drawings.TextBKG.Color = Color3.new()
		drawings.TextBKG.ZIndex = 1
		drawings.WeaponText = Drawing.new('Text')
		drawings.WeaponText.Center = true
		drawings.WeaponText.Size = 18
		drawings.WeaponText.ZIndex = 2
		drawings.DistanceText = Drawing.new('Text')
		drawings.DistanceText.Center = true
		drawings.DistanceText.Size = 18
		drawings.DistanceText.ZIndex = 2
		drawings.Box3D = {}
		for i = 1, 12 do
			local line = Drawing.new('Line')
			line.Thickness = 2
			line.ZIndex = 2
			drawings.Box3D[i] = line
		end
		drawings.SkeletonLines = {}
		for _, lineName in {"Head", "Torso", "LeftArm", "LeftLowerArm", "RightArm", "RightLowerArm", "LeftLeg", "LeftLowerLeg", "RightLeg", "RightLowerLeg"} do
			local line = Drawing.new('Line')
			line.Thickness = 2
			line.ZIndex = 2
			drawings.SkeletonLines[lineName] = line
		end
		ESPPreview.Drawings = drawings
		return drawings
	end

	local function getESPPreviewEntity()
		local model = ESPPreview.Model
		if not model then return nil end
		local root = charPart(model, "HumanoidRootPart", "Torso", "UpperTorso")
		local hum = model:FindFirstChildOfClass("Humanoid")
		if not root then return nil end
		return {
			Player = LocalPlayer,
			Character = model,
			RootPart = root,
			Head = charPart(model, "Head"),
			Humanoid = hum,
			HipHeight = hum and hum.HipHeight or 2,
			Health = hum and math.max(hum.Health, 1) or 100,
			MaxHealth = hum and math.max(hum.MaxHealth, 1) or 100,
			Targetable = true,
			Friend = false,
		}
	end

	local function pivotESPPreviewModel()
		if not ESPPreview.Model then return end
		gameCamera = workspace.CurrentCamera or gameCamera
		if not gameCamera then return end
		local basePos
		if ESPPreview.Frame then
			local absPos = ESPPreview.Frame.AbsolutePosition
			local absSize = ESPPreview.Frame.AbsoluteSize
			local ray = gameCamera:ScreenPointToRay(absPos.X + (absSize.X / 2), absPos.Y + (absSize.Y / 2))
			basePos = ray.Origin + (ray.Direction * ESPPreview.Distance)
		else
			basePos = (gameCamera.CFrame * CFrame.new(0, 0, -ESPPreview.Distance)).Position
		end
		local worldOffset = (gameCamera.CFrame.RightVector * ESPPreview.Offset.X) + (gameCamera.CFrame.UpVector * ESPPreview.Offset.Y)
		local cf = CFrame.lookAt(basePos + worldOffset, gameCamera.CFrame.Position) * CFrame.Angles(0, ESPPreview.Angle, 0)
		ESPPreview.Model:PivotTo(cf)
		if ESPPreview.VisualModel then
			ESPPreview.VisualModel:PivotTo(CFrame.new(ESPPreview.Offset) * CFrame.Angles(0, ESPPreview.Angle, 0))
		end
	end

	local function updateWorldESPPreview()
		local drawings = ensureESPPreviewDrawings()
		local menuOpen = isLionMenuOpen()
		if not ESPPreview.Wanted or menuOpen == false or not ESPPreview.Model then
			setESPVisible(drawings, false)
			return
		end

		gameCamera = workspace.CurrentCamera or gameCamera
		if not gameCamera then
			setESPVisible(drawings, false)
			return
		end

		pivotESPPreviewModel()
		local ent = getESPPreviewEntity()
		if not ent then
			setESPVisible(drawings, false)
			return
		end

		setESPVisible(drawings, false)
		local mode = Method and Method.Value or "2D"
		local rootPos, rootVis = gameCamera:WorldToViewportPoint(ent.RootPart.Position)
		if not rootVis then return end
		local phase = espStaticPhase(ent)
		local color = getESPColor(ent)

		if mode == "2D" then
			local topPos = gameCamera:WorldToViewportPoint((CFrame.lookAlong(ent.RootPart.Position, gameCamera.CFrame.LookVector) * CFrame.new(2, ent.HipHeight, 0)).Position)
			local bottomPos = gameCamera:WorldToViewportPoint((CFrame.lookAlong(ent.RootPart.Position, gameCamera.CFrame.LookVector) * CFrame.new(-2, -ent.HipHeight - 1, 0)).Position)
			local sizex, sizey = math.abs(topPos.X - bottomPos.X), math.abs(topPos.Y - bottomPos.Y)
			if sizex < 2 or sizey < 2 then
				sizex, sizey = 72, 150
			end
			local posx, posy = (rootPos.X - sizex / 2), math.min(topPos.Y, bottomPos.Y)

			if BoundingBox and BoundingBox.Enabled then
				drawings.Main.Visible = true
				drawings.Main.Color = espGradientColor(BoundingBox, phase, color)
				drawings.Main.Position = vec2floor(Vector2.new(posx, posy))
				drawings.Main.Size = vec2floor(Vector2.new(sizex, sizey))
				drawings.Border.Visible = true
				drawings.Border.Position = vec2floor(Vector2.new(posx - 1, posy + 1))
				drawings.Border.Size = vec2floor(Vector2.new(sizex + 2, sizey - 2))
			end
			drawings.Fill.Visible = Filled and Filled.Enabled or false
			drawings.Fill.Filled = true
			drawings.Fill.Transparency = 0.35
			drawings.Fill.Color = espGradientColor(Filled, phase, Color3.new())
			drawings.Fill.Position = vec2floor(Vector2.new(posx + 1, posy - 1))
			drawings.Fill.Size = vec2floor(Vector2.new(sizex - 2, sizey + 2))

			if HealthBar and HealthBar.Enabled then
				local percent = math.clamp(ent.Health / ent.MaxHealth, 0, 1)
				local healthposy = sizey * percent
				drawings.HealthLine.Visible = true
				drawings.HealthLine.Color = espHealthColor(percent)
				drawings.HealthLine.From = vec2floor(Vector2.new(posx - 6, posy + (sizey - (sizey - healthposy))))
				drawings.HealthLine.To = vec2floor(Vector2.new(posx - 6, posy))
				drawings.HealthBorder.Visible = true
				drawings.HealthBorder.From = vec2floor(Vector2.new(posx - 6, posy + 1))
				drawings.HealthBorder.To = vec2floor(Vector2.new(posx - 6, (posy + sizey) - 1))
			end

			if Name and Name.Enabled then
				drawings.Text.Visible = true
				drawings.Text.Text = DisplayName and DisplayName.Enabled and LocalPlayer.DisplayName or LocalPlayer.Name
				drawings.Text.Color = espGradientColor(Name, phase, color)
				drawings.Text.Position = vec2floor(Vector2.new(posx + (sizex / 2), posy + (sizey - 28)))
			end
			if drawings.TextBKG then
				drawings.TextBKG.Visible = Background and Background.Enabled and drawings.Text.Visible or false
				if drawings.TextBKG.Visible then
					drawings.TextBKG.Size = drawings.Text.TextBounds + Vector2.new(8, 4)
					drawings.TextBKG.Position = drawings.Text.Position - Vector2.new(4 + (drawings.Text.TextBounds.X / 2), 0)
				end
			end
			if Weapon and Weapon.Enabled then
				drawings.WeaponText.Visible = true
				drawings.WeaponText.Text = getPlayerWeaponName(LocalPlayer)
				drawings.WeaponText.Color = espGradientColor(Weapon, phase, color)
				drawings.WeaponText.Position = vec2floor(Vector2.new(posx + (sizex / 2), posy + sizey + 2))
			end
			if DistanceText and DistanceText.Enabled then
				drawings.DistanceText.Visible = true
				drawings.DistanceText.Text = tostring(math.floor(ESPPreview.Distance)) .. "m"
				drawings.DistanceText.Color = espGradientColor(DistanceText, phase, color)
				drawings.DistanceText.Position = vec2floor(Vector2.new(posx + (sizex / 2), posy + sizey + (Weapon and Weapon.Enabled and 20 or 2)))
			end
			setESPVisible(drawings.SkeletonLines, false)
			updateViewportSkeleton()
		elseif mode == "3D" then
			local points = {
				ESPWorldToViewport(ent.RootPart.Position + Vector3.new(1.5, ent.HipHeight, 1.5)),
				ESPWorldToViewport(ent.RootPart.Position + Vector3.new(1.5, -ent.HipHeight, 1.5)),
				ESPWorldToViewport(ent.RootPart.Position + Vector3.new(-1.5, ent.HipHeight, 1.5)),
				ESPWorldToViewport(ent.RootPart.Position + Vector3.new(-1.5, -ent.HipHeight, 1.5)),
				ESPWorldToViewport(ent.RootPart.Position + Vector3.new(1.5, ent.HipHeight, -1.5)),
				ESPWorldToViewport(ent.RootPart.Position + Vector3.new(1.5, -ent.HipHeight, -1.5)),
				ESPWorldToViewport(ent.RootPart.Position + Vector3.new(-1.5, ent.HipHeight, -1.5)),
				ESPWorldToViewport(ent.RootPart.Position + Vector3.new(-1.5, -ent.HipHeight, -1.5)),
			}
			local pairs3D = {{1,2},{3,4},{5,6},{7,8},{1,3},{1,5},{5,7},{7,3},{2,4},{2,6},{6,8},{8,4}}
			for index, pair in ipairs(pairs3D) do
				local line = drawings.Box3D[index]
				local fromPoint, toPoint = points[pair[1]], points[pair[2]]
				if line and fromPoint and toPoint then
					line.Visible = true
					line.Color = espGradientColor(BoundingBox, (index - 1) / math.max(#pairs3D - 1, 1), color)
					line.From = fromPoint
					line.To = toPoint
				elseif line then
					line.Visible = false
				end
			end
		elseif mode == "Skeleton" then
			setESPVisible(drawings.SkeletonLines, false)
			updateViewportSkeleton()
		end
	end

	local function updateESPPreview()
		if not ESPPreview.Gui then return end
		updateWorldESPPreview()
		local color = getESPColor()
		local phase = 0
		local mode = Method and Method.Value or "2D"
		local parts = ESPPreview.Parts
		local inDistance = not Distance or not Distance.Enabled or not DistanceLimit or (DistanceLimit.Value or 0) >= 32
		local show2D = false
		local show3D = false
		local showSkeleton = false

		if parts.Box then
			parts.Box.Visible = show2D and BoundingBox and BoundingBox.Enabled
			parts.Box.BorderColor3 = espGradientColor(BoundingBox, phase, color)
		end
		if parts.Fill then
			parts.Fill.Visible = show2D and BoundingBox and BoundingBox.Enabled and Filled and Filled.Enabled
			parts.Fill.BackgroundColor3 = espGradientColor(Filled, phase, color)
		end
		if parts.Name then
			parts.Name.Visible = show2D and Name and Name.Enabled
			parts.Name.TextColor3 = espGradientColor(Name, phase, color)
			parts.Name.Text = DisplayName and DisplayName.Enabled and "DisplayName" or LocalPlayer.Name
		end
		if parts.NameBackground then
			parts.NameBackground.Visible = show2D and Name and Name.Enabled and Background and Background.Enabled
		end
		if parts.Health then
			parts.Health.Visible = show2D and HealthBar and HealthBar.Enabled
			parts.Health.BackgroundColor3 = espToggleColor(HealthBar, 1, Color3.fromRGB(0, 255, 0))
		end
		if parts.Mode then
			parts.Mode.Text = "ESP Preview - " .. tostring(mode) .. (inDistance and "" or " (out of range)")
			parts.Mode.TextColor3 = color
		end
		for _, line in ipairs(parts.Box3D or {}) do
			line.Visible = show3D
			line.BackgroundColor3 = espGradientColor(BoundingBox, (#parts.Box3D > 1 and (_ - 1) / (#parts.Box3D - 1) or 0), color)
		end
		for _, line in ipairs(parts.Skeleton or {}) do
			line.Visible = showSkeleton and (not Skeleton or Skeleton.Enabled)
			line.BackgroundColor3 = espGradientColor(Skeleton, (#parts.Skeleton > 1 and (_ - 1) / (#parts.Skeleton - 1) or 0), color)
		end
		updateViewportSkeleton()
	end

	local function moveESPPreview(delta)
		if not ESPPreview.Model then return end
		ESPPreview.Offset += delta
		pivotESPPreviewModel()
	end

	local function makePreviewDummy(parent)
		local model = Instance.new("Model")
		model.Name = "PreviewDummy"
		model.Parent = parent

		local function part(name, size, cf, color)
			local p = Instance.new("Part")
			p.Name = name
			p.Size = size
			p.CFrame = cf
			p.Anchored = true
			p.CanCollide = false
			p.Color = color or Color3.fromRGB(170, 170, 170)
			p.Parent = model
			return p
		end

		part("HumanoidRootPart", Vector3.new(1.8, 2, 0.8), CFrame.new(0, 2, 0), Color3.fromRGB(90, 90, 90))
		part("Head", Vector3.new(1.1, 1.1, 1.1), CFrame.new(0, 3.65, 0), Color3.fromRGB(210, 180, 140))
		part("LeftArm", Vector3.new(0.55, 1.9, 0.55), CFrame.new(-1.25, 2.1, 0), Color3.fromRGB(120, 150, 220))
		part("RightArm", Vector3.new(0.55, 1.9, 0.55), CFrame.new(1.25, 2.1, 0), Color3.fromRGB(120, 150, 220))
		part("LeftLeg", Vector3.new(0.65, 1.8, 0.65), CFrame.new(-0.45, 0.55, 0), Color3.fromRGB(80, 100, 170))
		part("RightLeg", Vector3.new(0.65, 1.8, 0.65), CFrame.new(0.45, 0.55, 0), Color3.fromRGB(80, 100, 170))

		return model
	end

	local function fitPreviewCamera(model, camera)
		if not model or not camera then return end
		local cf, size = model:GetBoundingBox()
		local center = cf.Position
		local radius = math.max(size.X, size.Y, size.Z, 4)
		camera.CFrame = CFrame.lookAt(center + Vector3.new(0, radius * 0.18, radius * 1.85), center + Vector3.new(0, radius * 0.08, 0))
	end

	local function createESPPreview()
		if ESPPreview.Gui then
			ESPPreview.Wanted = not ESPPreview.Wanted
			ESPPreview.Gui.Visible = ESPPreview.Wanted
			if ESPPreview.Wanted then
				updateESPPreview()
			elseif ESPPreview.Drawings then
				setESPVisible(ESPPreview.Drawings, false)
			end
			return
		end

		ESPPreview.Wanted = true
		local gui = Instance.new("Frame")
		gui.Name = "ESPPreview"
		gui.Size = UDim2.fromScale(1, 1)
		gui.BackgroundTransparency = 1
		gui.Visible = true
		gui.ZIndex = 50
		gui.Parent = mainapi.MainScreenGui
		ESPPreview.Gui = gui

		local frame = Instance.new("Frame")
		frame.Size = UDim2.fromOffset(260, 320)
		frame.Position = UDim2.fromOffset(80, 90)
		frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		frame.BorderColor3 = Color3.fromRGB(65, 65, 65)
		frame.ZIndex = 51
		frame.Parent = gui
		ESPPreview.Frame = frame

		local title = Instance.new("TextLabel")
		title.Name = "Mode"
		title.Size = UDim2.new(1, -28, 0, 24)
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.Code
		title.TextSize = 14
		title.Text = "ESP Preview"
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.ZIndex = 52
		title.Parent = frame

		local close = Instance.new("TextButton")
		close.Size = UDim2.fromOffset(24, 24)
		close.Position = UDim2.new(1, -24, 0, 0)
		close.Text = "x"
		close.Font = Enum.Font.Code
		close.TextSize = 14
		close.TextColor3 = Color3.fromRGB(255, 255, 255)
		close.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		close.BorderColor3 = Color3.fromRGB(65, 65, 65)
		close.ZIndex = 52
		close.Parent = frame
		close.MouseButton1Click:Connect(function()
			ESPPreview.Wanted = false
			gui.Visible = false
			if ESPPreview.Drawings then
				setESPVisible(ESPPreview.Drawings, false)
			end
		end)

		local viewport = Instance.new("ViewportFrame")
		viewport.Size = UDim2.new(1, -20, 1, -74)
		viewport.Position = UDim2.fromOffset(10, 34)
		viewport.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
		viewport.BorderColor3 = Color3.fromRGB(55, 55, 55)
		viewport.ZIndex = 51
		viewport.Parent = frame

		local world = Instance.new("WorldModel")
		world.Parent = viewport
		local cam = Instance.new("Camera")
		cam.CFrame = CFrame.lookAt(Vector3.new(0, 2.6, 8), Vector3.new(0, 2, 0))
		cam.Parent = viewport
		viewport.CurrentCamera = cam

		local clone
		pcall(function()
			local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
			local oldArchivable = char.Archivable
			char.Archivable = true
			clone = char:Clone()
			char.Archivable = oldArchivable
			if clone then
				clone.Parent = workspace
				for _, obj in clone:GetDescendants() do
					if obj:IsA("BasePart") then
						obj.Anchored = true
						obj.CanCollide = false
						obj.LocalTransparencyModifier = 1
						obj.Transparency = 1
					elseif obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Highlight") or obj:IsA("SelectionBox") or obj:IsA("BoxHandleAdornment") or obj:IsA("Handles") then
						obj:Destroy()
					elseif obj:IsA("Humanoid") then
						obj.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
					end
				end
				clone.Name = "LionESPPreviewModel"
				clone:PivotTo(CFrame.new(0, -10000, 0))
			end
		end)
		if not clone then
			clone = makePreviewDummy(workspace)
			clone.Name = "LionESPPreviewModel"
			for _, obj in clone:GetDescendants() do
				if obj:IsA("BasePart") then
					obj.LocalTransparencyModifier = 1
					obj.Transparency = 1
				elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Highlight") or obj:IsA("SelectionBox") or obj:IsA("BoxHandleAdornment") or obj:IsA("Handles") then
					obj:Destroy()
				end
			end
		end
		ESPPreview.Model = clone

		local visualClone
		pcall(function()
			local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
			local oldArchivable = char.Archivable
			char.Archivable = true
			visualClone = char:Clone()
			char.Archivable = oldArchivable
			if visualClone then
				visualClone.Name = "PreviewCharacter"
				visualClone.Parent = world
				for _, obj in visualClone:GetDescendants() do
					if obj:IsA("BasePart") then
						obj.Anchored = true
						obj.CanCollide = false
						if isPreviewHiddenPart(obj) then
							obj.LocalTransparencyModifier = 1
							obj.Transparency = 1
						else
							obj.LocalTransparencyModifier = 0
							if obj.Transparency >= 1 then
								obj.Transparency = 0
							end
						end
					elseif obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Highlight") or obj:IsA("SelectionBox") or obj:IsA("BoxHandleAdornment") or obj:IsA("Handles") then
						obj:Destroy()
					elseif obj:IsA("Humanoid") then
						obj.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
					end
				end
				visualClone:PivotTo(CFrame.new())
			end
		end)
		if not visualClone then
			visualClone = makePreviewDummy(world)
			for _, obj in visualClone:GetDescendants() do
				if obj:IsA("BasePart") and isPreviewHiddenPart(obj) then
					obj.LocalTransparencyModifier = 1
					obj.Transparency = 1
				end
			end
		end
		ESPPreview.VisualModel = visualClone
		fitPreviewCamera(visualClone, cam)
		pivotESPPreviewModel()

		local overlay = Instance.new("Frame")
		overlay.Size = viewport.Size
		overlay.Position = viewport.Position
		overlay.BackgroundTransparency = 1
		overlay.ZIndex = 52
		overlay.Parent = frame

		local fill = Instance.new("Frame")
		fill.Name = "Fill"
		fill.Size = UDim2.fromOffset(86, 170)
		fill.Position = UDim2.fromScale(0.5, 0.52)
		fill.AnchorPoint = Vector2.new(0.5, 0.5)
		fill.BackgroundTransparency = 0.78
		fill.BorderSizePixel = 0
		fill.ZIndex = 53
		fill.Parent = overlay

		local box = Instance.new("Frame")
		box.Name = "Box"
		box.Size = fill.Size
		box.Position = fill.Position
		box.AnchorPoint = fill.AnchorPoint
		box.BackgroundTransparency = 1
		box.BorderSizePixel = 1
		box.ZIndex = 54
		box.Parent = overlay

		local health = Instance.new("Frame")
		health.Name = "Health"
		health.Size = UDim2.fromOffset(4, 150)
		health.Position = UDim2.new(0.5, -52, 0.52, -75)
		health.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
		health.BorderColor3 = Color3.fromRGB(0, 0, 0)
		health.ZIndex = 54
		health.Parent = overlay

		local box3D = {}
		local function add3DLine(size, pos, rot)
			local line = Instance.new("Frame")
			line.Size = size
			line.Position = pos
			line.AnchorPoint = Vector2.new(0.5, 0.5)
			line.BorderSizePixel = 0
			line.Rotation = rot or 0
			line.ZIndex = 54
			line.Parent = overlay
			table.insert(box3D, line)
			return line
		end
		add3DLine(UDim2.fromOffset(84, 2), UDim2.fromScale(0.5, 0.22), 0)
		add3DLine(UDim2.fromOffset(84, 2), UDim2.fromScale(0.5, 0.82), 0)
		add3DLine(UDim2.fromOffset(2, 154), UDim2.fromScale(0.33, 0.52), 0)
		add3DLine(UDim2.fromOffset(2, 154), UDim2.fromScale(0.67, 0.52), 0)
		add3DLine(UDim2.fromOffset(66, 2), UDim2.fromScale(0.58, 0.28), -18)
		add3DLine(UDim2.fromOffset(66, 2), UDim2.fromScale(0.58, 0.88), -18)
		add3DLine(UDim2.fromOffset(2, 154), UDim2.fromScale(0.74, 0.58), 0)
		add3DLine(UDim2.fromOffset(2, 154), UDim2.fromScale(0.42, 0.58), 0)
		add3DLine(UDim2.fromOffset(66, 2), UDim2.fromScale(0.25, 0.28), -18)
		add3DLine(UDim2.fromOffset(66, 2), UDim2.fromScale(0.25, 0.88), -18)
		add3DLine(UDim2.fromOffset(84, 2), UDim2.fromScale(0.58, 0.34), 0)
		add3DLine(UDim2.fromOffset(84, 2), UDim2.fromScale(0.58, 0.94), 0)

		local nameBg = Instance.new("Frame")
		nameBg.Name = "NameBackground"
		nameBg.Size = UDim2.fromOffset(120, 22)
		nameBg.Position = UDim2.new(0.5, -60, 0.52, 88)
		nameBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		nameBg.BackgroundTransparency = 0.35
		nameBg.BorderSizePixel = 0
		nameBg.ZIndex = 53
		nameBg.Parent = overlay

		local nameText = Instance.new("TextLabel")
		nameText.Name = "Name"
		nameText.Size = nameBg.Size
		nameText.Position = nameBg.Position
		nameText.BackgroundTransparency = 1
		nameText.Font = Enum.Font.Code
		nameText.TextSize = 14
		nameText.Text = LocalPlayer.Name
		nameText.ZIndex = 54
		nameText.Parent = overlay

		local skeleton = {}
		local function addLine(size, pos, rot)
			local line = Instance.new("Frame")
			line.Size = size
			line.Position = pos
			line.AnchorPoint = Vector2.new(0.5, 0.5)
			line.BorderSizePixel = 0
			line.Rotation = rot or 0
			line.ZIndex = 54
			line.Parent = overlay
			table.insert(skeleton, line)
		end
		addLine(UDim2.fromOffset(3, 42), UDim2.fromScale(0.5, 0.39), 0)
		addLine(UDim2.fromOffset(70, 3), UDim2.fromScale(0.5, 0.47), 0)
		addLine(UDim2.fromOffset(3, 55), UDim2.fromScale(0.42, 0.58), 20)
		addLine(UDim2.fromOffset(3, 55), UDim2.fromScale(0.58, 0.58), -20)
		addLine(UDim2.fromOffset(3, 60), UDim2.fromScale(0.46, 0.75), 10)
		addLine(UDim2.fromOffset(3, 60), UDim2.fromScale(0.54, 0.75), -10)

		local viewportSkeleton = {}
		for _, lineName in {"Head", "Torso", "LeftArm", "LeftLowerArm", "RightArm", "RightLowerArm", "LeftLeg", "LeftLowerLeg", "RightLeg", "RightLowerLeg"} do
			local line = Instance.new("Frame")
			line.Name = lineName
			line.AnchorPoint = Vector2.new(0.5, 0.5)
			line.BorderSizePixel = 0
			line.Visible = false
			line.ZIndex = 60
			line.Parent = overlay
			viewportSkeleton[lineName] = line
		end

		local buttons = {
			{"<", UDim2.new(0, 10, 1, -30), Vector3.new(-1.5, 0, 0)},
			{">", UDim2.new(0, 42, 1, -30), Vector3.new(1.5, 0, 0)},
			{"^", UDim2.new(0, 74, 1, -30), Vector3.new(0, 1.5, 0)},
			{"v", UDim2.new(0, 106, 1, -30), Vector3.new(0, -1.5, 0)},
		}
		for _, info in ipairs(buttons) do
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.fromOffset(26, 22)
			btn.Position = info[2]
			btn.Text = info[1]
			btn.Font = Enum.Font.Code
			btn.TextSize = 14
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			btn.BorderColor3 = Color3.fromRGB(65, 65, 65)
			btn.ZIndex = 52
			btn.Parent = frame
			btn.MouseButton1Click:Connect(function()
				moveESPPreview(info[3])
			end)
		end

		local reset = Instance.new("TextButton")
		reset.Size = UDim2.fromOffset(64, 22)
		reset.Position = UDim2.new(1, -74, 1, -30)
		reset.Text = "reset"
		reset.Font = Enum.Font.Code
		reset.TextSize = 14
		reset.TextColor3 = Color3.fromRGB(255, 255, 255)
		reset.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		reset.BorderColor3 = Color3.fromRGB(65, 65, 65)
		reset.ZIndex = 52
		reset.Parent = frame
		reset.MouseButton1Click:Connect(function()
			ESPPreview.Angle = 0
			ESPPreview.Offset = Vector3.new()
			if ESPPreview.Model then
				pivotESPPreviewModel()
			end
		end)

		local dragging, lastX, lastY = false, 0, 0
		viewport.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				lastX = input.Position.X
				lastY = input.Position.Y
			end
		end)
		viewport.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement and ESPPreview.Model then
				local delta = input.Position.X - lastX
				local deltaY = input.Position.Y - lastY
				lastX = input.Position.X
				lastY = input.Position.Y
				ESPPreview.Angle += math.rad(delta)
				ESPPreview.Offset += Vector3.new(0, -deltaY * 0.02, 0)
				pivotESPPreviewModel()
			end
		end)

		ESPPreview.Parts = {
			Box = box,
			Box3D = box3D,
			Fill = fill,
			Health = health,
			Name = nameText,
			NameBackground = nameBg,
			Mode = title,
			Skeleton = skeleton,
			ViewportSkeleton = viewportSkeleton,
			Viewport = viewport,
			ViewCamera = cam,
		}
		local nextPreviewUpdate = 0
		mainapi:Clean(RunService.Heartbeat:Connect(function()
			local now = os.clock()
			if now < nextPreviewUpdate then return end
			nextPreviewUpdate = now + 0.05
			local menuOpen = isLionMenuOpen()
			gui.Visible = ESPPreview.Wanted and menuOpen ~= false
			if gui.Visible then
				local ok, err = pcall(updateESPPreview)
				if not ok then
					warn("[ESP Preview] update failed:", err)
					gui.Visible = false
					ESPPreview.Wanted = false
				end
			end
		end))
		pcall(updateESPPreview)
	end
	
	local ESPAdded = {
		Drawing2D = function(ent)
			if not ent.Player then return end
			if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
			if mainapi.ThreadFix then
				pcall(setthreadidentity, 8)
			end
			local EntityESP = {}
			EntityESP.Main = Drawing.new('Square')
			EntityESP.Main.Transparency = BoundingBox.Enabled and 1 or 0
			EntityESP.Main.ZIndex = 2
			EntityESP.Main.Filled = false
			EntityESP.Main.Thickness = 1
			local baseColor = entitylib.getEntityColor(ent) or (uipallet and uipallet.FinalColor) or Color3.new(1, 1, 1)
			EntityESP.Main.Color = espGradientColor(BoundingBox, 0.5, baseColor)
	
			if BoundingBox.Enabled then
				EntityESP.Border = Drawing.new('Square')
				EntityESP.Border.Transparency = 0.35
				EntityESP.Border.ZIndex = 1
				EntityESP.Border.Thickness = 1
				EntityESP.Border.Filled = false
				EntityESP.Border.Color = Color3.new()
			end
			if BoundingBox.Enabled or (Filled and Filled.Enabled) then
				EntityESP.Border2 = Drawing.new('Square')
				EntityESP.Border2.Transparency = 0.35
				EntityESP.Border2.ZIndex = 1
				EntityESP.Border2.Thickness = 1
				EntityESP.Border2.Filled = Filled and Filled.Enabled or false
				EntityESP.Border2.Color = Color3.new()
			end
	
			if HealthBar.Enabled then
				EntityESP.HealthLine = Drawing.new('Line')
				EntityESP.HealthLine.Thickness = 1
				EntityESP.HealthLine.ZIndex = 2
				EntityESP.HealthLine.Color = espHealthColor(math.clamp(ent.Health / ent.MaxHealth, 0, 1))
				EntityESP.HealthBorder = Drawing.new('Line')
				EntityESP.HealthBorder.Thickness = 3
				EntityESP.HealthBorder.Transparency = 0.35
				EntityESP.HealthBorder.ZIndex = 1
				EntityESP.HealthBorder.Color = Color3.new()
			end
			
			if Name.Enabled then
				if Background.Enabled then
					EntityESP.TextBKG = Drawing.new('Square')
					EntityESP.TextBKG.Transparency = 0.35
					EntityESP.TextBKG.ZIndex = 1
					EntityESP.TextBKG.Thickness = 1
					EntityESP.TextBKG.Filled = true
					EntityESP.TextBKG.Color = Color3.new()
					EntityESP.TextBKG.Visible = false
				end
				EntityESP.Drop = Drawing.new('Text')
				EntityESP.Drop.Color = Color3.new()
				EntityESP.Drop.Text = ent.Player and (DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
				EntityESP.Drop.ZIndex = 2
				EntityESP.Drop.Center = true
				EntityESP.Drop.Size = 20
				EntityESP.Text = Drawing.new('Text')
				EntityESP.Text.Text = EntityESP.Drop.Text
				EntityESP.Text.ZIndex = 3
				EntityESP.Text.Color = espGradientColor(Name, 0.5, EntityESP.Main.Color)
				EntityESP.Text.Center = true
				EntityESP.Text.Size = 20
			end
			if Weapon and Weapon.Enabled then
				EntityESP.WeaponText = Drawing.new('Text')
				EntityESP.WeaponText.Text = getPlayerWeaponName(ent.Player)
				EntityESP.WeaponText.ZIndex = 2
				EntityESP.WeaponText.Color = espGradientColor(Weapon, 0.5, EntityESP.Main.Color)
				EntityESP.WeaponText.Center = true
				EntityESP.WeaponText.Size = 18
			end
			if DistanceText and DistanceText.Enabled then
				EntityESP.DistanceText = Drawing.new('Text')
				EntityESP.DistanceText.Text = '0m'
				EntityESP.DistanceText.ZIndex = 2
				EntityESP.DistanceText.Color = espGradientColor(DistanceText, 0.5, EntityESP.Main.Color)
				EntityESP.DistanceText.Center = true
				EntityESP.DistanceText.Size = 18
			end
			EntityESP.FlagText = Drawing.new('Text')
			EntityESP.FlagText.ZIndex = 2
			EntityESP.FlagText.Color = Color3.fromRGB(255, 255, 255)
			EntityESP.FlagText.Outline = true
			EntityESP.FlagText.Size = 16
			if Skeleton and Skeleton.Enabled then
				EntityESP.SkeletonLines = {}
				for _, lineName in {"Head", "Torso", "LeftArm", "LeftLowerArm", "RightArm", "RightLowerArm", "LeftLeg", "LeftLowerLeg", "RightLeg", "RightLowerLeg"} do
					local line = Drawing.new('Line')
					line.Thickness = 2
					line.ZIndex = 2
					line.Color = espGradientColor(Skeleton, 0.5, EntityESP.Main.Color)
					EntityESP.SkeletonLines[lineName] = line
				end
			end
			Reference[ent] = EntityESP
		end,
		Drawing3D = function(ent)
			if not ent.Player then return end
			if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
			if mainapi.ThreadFix then
				pcall(setthreadidentity, 8)
			end
			local EntityESP = {}
			EntityESP.Line1 = Drawing.new('Line')
			EntityESP.Line2 = Drawing.new('Line')
			EntityESP.Line3 = Drawing.new('Line')
			EntityESP.Line4 = Drawing.new('Line')
			EntityESP.Line5 = Drawing.new('Line')
			EntityESP.Line6 = Drawing.new('Line')
			EntityESP.Line7 = Drawing.new('Line')
			EntityESP.Line8 = Drawing.new('Line')
			EntityESP.Line9 = Drawing.new('Line')
			EntityESP.Line10 = Drawing.new('Line')
			EntityESP.Line11 = Drawing.new('Line')
			EntityESP.Line12 = Drawing.new('Line')
	
			local color = entitylib.getEntityColor(ent) or uipallet.FinalColor
			for _, v in pairs(EntityESP) do
				if v and v.Color then
					local safeColor = color or Color3.fromRGB(255, 255, 255)
					v.Thickness = 1
					v.Color = espGradientColor(BoundingBox, 0.5, safeColor)
				end
			end
	
			Reference[ent] = EntityESP
		end,
		DrawingSkeleton = function(ent)
			if not ent.Player then return end
			if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
			if mainapi.ThreadFix then
				pcall(setthreadidentity, 8)
			end
			local EntityESP = {}
			EntityESP.Head = Drawing.new('Line')
			EntityESP.Torso = Drawing.new('Line')
			EntityESP.LeftArm = Drawing.new('Line')
			EntityESP.LeftLowerArm = Drawing.new('Line')
			EntityESP.RightArm = Drawing.new('Line')
			EntityESP.RightLowerArm = Drawing.new('Line')
			EntityESP.LeftLeg = Drawing.new('Line')
			EntityESP.LeftLowerLeg = Drawing.new('Line')
			EntityESP.RightLeg = Drawing.new('Line')
			EntityESP.RightLowerLeg = Drawing.new('Line')
	
			local color = entitylib.getEntityColor(ent) or uipallet.FinalColor
			for index, v in EntityESP do
				v.Thickness = 2
				v.Color = espGradientColor(Skeleton, 0.5, color)
			end
	
			Reference[ent] = EntityESP
		end
	}
	
	local ESPRemoved = {
		Drawing2D = function(ent)
			local EntityESP = Reference[ent]
			if EntityESP then
				if mainapi.ThreadFix then
					pcall(setthreadidentity, 8)
				end
				Reference[ent] = nil
				removeESPObjects(EntityESP)
			end
		end
	}
	ESPRemoved.Drawing3D = ESPRemoved.Drawing2D
	ESPRemoved.DrawingSkeleton = ESPRemoved.Drawing2D
	
	local ESPUpdated = {
		Drawing2D = function(ent)
			local EntityESP = Reference[ent]
			if EntityESP then
				if mainapi.ThreadFix then
					pcall(setthreadidentity, 8)
				end
				
				if EntityESP.HealthLine then
					EntityESP.HealthLine.Color = espHealthColor(math.clamp(ent.Health / ent.MaxHealth, 0, 1))
				end
	
				if EntityESP.Text then
					EntityESP.Text.Text = ent.Player and (DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
					EntityESP.Drop.Text = EntityESP.Text.Text
					EntityESP.Text.Color = espGradientColor(Name, espStaticPhase(ent), EntityESP.Text.Color)
				end
				if EntityESP.WeaponText then
					EntityESP.WeaponText.Text = getPlayerWeaponName(ent.Player)
					EntityESP.WeaponText.Color = espGradientColor(Weapon, espStaticPhase(ent), EntityESP.WeaponText.Color)
				end
				if EntityESP.DistanceText then
					EntityESP.DistanceText.Color = espGradientColor(DistanceText, espStaticPhase(ent), EntityESP.DistanceText.Color)
				end
			end
		end
	}
	
	local ColorFunc = {
		Drawing2D = function(hue, sat, val)
			local color = Color3.fromHSV(hue, sat, val)
			for i, v in Reference do
				local playerColor = entitylib.getEntityColor(i) or color
				if v.Main then
					v.Main.Color = playerColor
				end
				if v.Text then
					v.Text.Color = playerColor
				end
			end
		end,
		Drawing3D = function(hue, sat, val)
			local color = Color3.fromHSV(hue, sat, val)
			for i, v in Reference do
				local playercolor = entitylib.getEntityColor(i) or color
				for _, v2 in v do
					if v2 and v2.Color ~= nil then
						v2.Color = playercolor
					end
				end
			end
		end
	}
	ColorFunc.DrawingSkeleton = ColorFunc.Drawing3D

	local worldNames = {
		["grenade"] = "Grenade",
		["molotov"] = "Molotov",
		["satchel"] = "Satchel",
		["flashbang"] = "Flashbang",
		["smoke grenade"] = "Smoke Grenade",
		["smokegrenade"] = "Smoke Grenade",
		["subspace tripmine"] = "Subspace Tripmine",
		["subspacetripmine"] = "Subspace Tripmine",
	}

	local worldKindCache = {}
	local function worldKind(inst)
		if not inst then return nil end
		local character = LocalPlayer.Character
		if character and inst:IsDescendantOf(character) then return nil end
		
		local name = inst.Name
		local cached = worldKindCache[name]
		if cached ~= nil then
			return cached == false and nil or cached
		end

		local lower = name:lower()
		-- Ignore Molotov fire/hitboxes and other residual effects
		if lower:find("molotov") then
			if lower:find("hitbox") or lower:find("fire") or lower:find("flame") or lower:find("pool") or lower:find("effect") or lower:find("area") or lower:find("floor") then
				return nil
			end
			if inst:FindFirstChildWhichIsA("ParticleEmitter", true) then
				return nil
			end
		end
		
		local result = nil
		for key, display in pairs(worldNames) do
			if lower == key or lower:find(key, 1, true) then 
				result = display
				break
			end
		end
		
		if not lower:find("molotov") then
			worldKindCache[name] = result or false
		end
		return result
	end

	local function worldRoot(inst)
		if inst:IsA("BasePart") then return inst end
		if inst:IsA("Model") then
			return inst.PrimaryPart or inst:FindFirstChild("HumanoidRootPart") or inst:FindFirstChildWhichIsA("BasePart", true)
		end
		if inst:IsA("Folder") then
			return inst:FindFirstChildWhichIsA("BasePart", true)
		end
	end

	local function worldAllowed(name)
		if not WorldWhitelist or type(WorldWhitelist.Value) ~= "table" then return true end
		return WorldWhitelist.Value[name] == true
	end

	local function removeWorldESP(inst)
		local data = WorldReference[inst]
		if not data then return end
		WorldReference[inst] = nil
		if WorldRootReference[data.Root] == inst then
			WorldRootReference[data.Root] = nil
		end
		removeESPObjects(data.Drawings)
	end

	local function addWorldESP(inst)
		if inst.Parent and inst.Parent.Name == "SubspaceTripmineHitbox" then
			inst = inst.Parent
		end
		if WorldReference[inst] then return end
		local kind = worldKind(inst)
		local root = kind and worldRoot(inst)
		if not root then return end
		if root.Anchored and kind ~= "Subspace Tripmine" then return end
		local lobby = workspace:FindFirstChild("Lobby")
		local viewmodels = workspace:FindFirstChild("ViewModels")
		if lobby and inst:IsDescendantOf(lobby) then return end
		if viewmodels and inst:IsDescendantOf(viewmodels) then return end
		local static = workspace:FindFirstChild("classic_bundle")
		if static and inst:IsDescendantOf(static) then return end
		static = workspace:FindFirstChild("ShootingRangeEntities")
		if static and inst:IsDescendantOf(static) then return end
		if inst:FindFirstAncestorOfClass("Accessory") then return end
		if inst:FindFirstAncestorOfClass("Tool") then return end
		if WorldRootReference[root] then return end

		local text = Drawing.new("Text")
		text.Center = true
		text.Outline = true
		text.Size = 16
		text.ZIndex = 4
		local image = Drawing.new("Square")
		image.Filled = true
		image.Thickness = 1
		image.Transparency = 0.6
		image.ZIndex = 3
		WorldReference[inst] = {
			Kind = kind,
			Root = root,
			Position = nil,
			Drawings = {Text = text, Image = image},
		}
		WorldRootReference[root] = inst
	end

	local function scanWorldESP()
		for _, inst in ipairs(workspace:GetDescendants()) do
			if inst:IsA("Model") or inst:IsA("BasePart") or inst:IsA("Folder") then addWorldESP(inst) end
		end
	end

	local function updateWorldESP()
		gameCamera = workspace.CurrentCamera or gameCamera
		local enabled = ESP.Enabled and ((WorldName and WorldName.Enabled) or (WorldImage and WorldImage.Enabled) or (WorldDistance and WorldDistance.Enabled))
		if not enabled then
			if worldESPVisible then
				for _, data in pairs(WorldReference) do
					setESPVisible(data.Drawings, false)
				end
				worldESPVisible = false
			end
			return
		end
		worldESPVisible = true
		for inst, data in pairs(WorldReference) do
			if not inst.Parent or not data.Root or not data.Root.Parent then
				removeWorldESP(inst)
				continue
			end
			local drawings = data.Drawings
			if not worldAllowed(data.Kind) then
				setESPVisible(drawings, false)
				continue
			end
			local point, visible = gameCamera:WorldToViewportPoint(data.Root.Position)
			if not visible then
				setESPVisible(drawings, false)
				continue
			end
			local target = Vector2.new(point.X, point.Y)
			data.Position = target
			local scale = (WorldScale and WorldScale.Value or 100) / 100
			local color = espToggleColor(WorldName, 1, Color3.fromRGB(255, 255, 255))
			local textValue = ""
			local hasText = false
			if WorldName and WorldName.Enabled then
				textValue = data.Kind
				hasText = true
			end
			local localRoot = entitylib.isAlive and entitylib.character and entitylib.character.RootPart
			if WorldDistance and WorldDistance.Enabled and localRoot then
				local distanceText = tostring(math.floor((localRoot.Position - data.Root.Position).Magnitude)) .. "m"
				textValue = hasText and (textValue .. "\n" .. distanceText) or distanceText
				hasText = true
			end
			drawings.Text.Text = textValue
			drawings.Text.Position = data.Position + Vector2.new(0, 12 * scale)
			drawings.Text.Size = math.floor(16 * scale)
			drawings.Text.Font = (WorldFont and WorldFont.Value == "arial") and 2 or 3
			drawings.Text.Color = color
			drawings.Text.Visible = hasText
			local imageSize = math.max(28, 36 * scale)
			drawings.Image.Size = Vector2.new(imageSize, imageSize)
			drawings.Image.Position = data.Position - drawings.Image.Size / 2
			drawings.Image.Color = espToggleColor(WorldImage, 1, color)
			drawings.Image.Visible = WorldImage and WorldImage.Enabled or false
		end
	end

	local function getLocalESPRoot()
		return entitylib.isAlive and entitylib.character and entitylib.character.RootPart
	end

	local function getESPDistance(rootPosition)
		local localRoot = getLocalESPRoot()
		return localRoot and (localRoot.Position - rootPosition).Magnitude or math.huge
	end

	local function getValidESPRoot(ent, EntityESP)
		local rootPart = ent and ent.RootPart
		if not rootPart or not rootPart.Parent or not ent.Character or not ent.Character.Parent then
			if EntityESP then
				setESPVisible(EntityESP, false)
			end
			return nil
		end
		return rootPart
	end

	local ESPLoop = {
		Drawing2D = function()
			gameCamera = workspace.CurrentCamera or gameCamera
			if not gameCamera then return end
			if shared.LionForceFOVEnabled and shared.LionForceFOVValue then
				gameCamera.FieldOfView = shared.LionForceFOVValue
			end
			for ent, EntityESP in Reference do
				local rootPart = getValidESPRoot(ent, EntityESP)
				if not rootPart then continue end
				local rootPosition = rootPart.Position
				if Distance and Distance.Enabled then
					local distance = getESPDistance(rootPosition)
					if distance > ((DistanceLimit and DistanceLimit.Value) or math.huge) then
						setESPVisible(EntityESP, false)
						continue
					end
				end
	
				local rootPos, rootVis = gameCamera:WorldToViewportPoint(rootPosition)
				local color = entitylib.getEntityColor(ent) or uipallet.FinalColor
				setESPVisible(EntityESP, rootVis)
				local espPhase = espStaticPhase(ent)
				if Filled and Filled.Enabled then
					ensureFillBox(EntityESP)
				end
				if (Name and Name.Enabled) or (Background and Background.Enabled) then
					ensureNameText(EntityESP, ent)
				end
				if EntityESP.Main then EntityESP.Main.Color = espGradientColor(BoundingBox, espPhase, color) end
				if EntityESP.Border2 then
					EntityESP.Border2.Filled = Filled and Filled.Enabled or false
					EntityESP.Border2.Visible = rootVis and Filled and Filled.Enabled or false
					EntityESP.Border2.Transparency = Filled and Filled.Enabled and 0.35 or 0
					EntityESP.Border2.Color = Filled and Filled.Enabled and espGradientColor(Filled, espPhase, Color3.new()) or Color3.new()
				end
				if EntityESP.Text then
					EntityESP.Text.Visible = rootVis and ((Name and Name.Enabled) or (Background and Background.Enabled)) or false
					if EntityESP.Drop then EntityESP.Drop.Visible = EntityESP.Text.Visible end
					EntityESP.Text.Color = espGradientColor(Name, espPhase, color)
					EntityESP.Text.Font = shared.LionESPFont == "arial" and 2 or 3
					if EntityESP.Drop then EntityESP.Drop.Font = EntityESP.Text.Font end
				end
				if EntityESP.WeaponText then EntityESP.WeaponText.Color = espGradientColor(Weapon, espPhase, color) end
				if EntityESP.DistanceText then EntityESP.DistanceText.Color = espGradientColor(DistanceText, espPhase, color) end
				if not rootVis then continue end
	
				local topPos = gameCamera:WorldToViewportPoint((CFrame.lookAlong(rootPosition, gameCamera.CFrame.LookVector) * CFrame.new(2, ent.HipHeight, 0)).p)
				local bottomPos = gameCamera:WorldToViewportPoint((CFrame.lookAlong(rootPosition, gameCamera.CFrame.LookVector) * CFrame.new(-2, -ent.HipHeight - 1, 0)).p)
				local sizex, sizey = math.abs(topPos.X - bottomPos.X), math.abs(topPos.Y - bottomPos.Y)
				if sizex < 2 or sizey < 2 then
					setESPVisible(EntityESP, false)
					continue
				end
				local posx, posy = (rootPos.X - sizex / 2), math.min(topPos.Y, bottomPos.Y)
				EntityESP.Main.Position = vec2floor(Vector2.new(posx, posy))
				EntityESP.Main.Size = vec2floor(Vector2.new(sizex, sizey))
				if EntityESP.Border then
					EntityESP.Border.Position = vec2floor(Vector2.new(posx - 1, posy + 1))
					EntityESP.Border.Size = vec2floor(Vector2.new(sizex + 2, sizey - 2))
				end
				if EntityESP.Border2 then
					EntityESP.Border2.Position = vec2floor(Vector2.new(posx + 1, posy - 1))
					EntityESP.Border2.Size = vec2floor(Vector2.new(sizex - 2, sizey + 2))
				end
	
				if EntityESP.HealthLine then
					local healthRatio = math.clamp(ent.Health / ent.MaxHealth, 0, 1)
					local healthposy = sizey * healthRatio
					EntityESP.HealthLine.Visible = ent.Health > 0
					EntityESP.HealthLine.Color = espHealthColor(healthRatio)
					EntityESP.HealthLine.From = vec2floor(Vector2.new(posx - 6, posy + (sizey - (sizey - healthposy))))
					EntityESP.HealthLine.To = vec2floor(Vector2.new(posx - 6, posy))
					EntityESP.HealthBorder.From = vec2floor(Vector2.new(posx - 6, posy + 1))
					EntityESP.HealthBorder.To = vec2floor(Vector2.new(posx - 6, (posy + sizey) - 1))
				end
	
				if EntityESP.Text then
					EntityESP.Text.Text = ent.Player and (DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
					if EntityESP.Drop then EntityESP.Drop.Text = EntityESP.Text.Text end
					EntityESP.Text.Position = vec2floor(Vector2.new(posx + (sizex / 2), posy + (sizey - 28)))
					if EntityESP.Drop then EntityESP.Drop.Position = EntityESP.Text.Position + Vector2.new(1, 1) end
					if Background and Background.Enabled then
						ensureTextBackground(EntityESP)
					end
					if EntityESP.TextBKG then
						EntityESP.TextBKG.Visible = rootVis and Background and Background.Enabled or false
						EntityESP.TextBKG.Size = EntityESP.Text.TextBounds + Vector2.new(8, 4)
						EntityESP.TextBKG.Position = EntityESP.Text.Position - Vector2.new(4 + (EntityESP.Text.TextBounds.X / 2), 0)
					end
				end
				if EntityESP.WeaponText then
					EntityESP.WeaponText.Position = vec2floor(Vector2.new(posx + (sizex / 2), posy + sizey + 2))
					EntityESP.WeaponText.Text = getPlayerWeaponName(ent.Player)
				end
				if EntityESP.DistanceText then
					local distance = getESPDistance(rootPosition)
					EntityESP.DistanceText.Position = vec2floor(Vector2.new(posx + (sizex / 2), posy + sizey + (EntityESP.WeaponText and 20 or 2)))
					EntityESP.DistanceText.Text = distance < math.huge and (tostring(math.floor(distance)) .. "m") or ""
				end
				if EntityESP.FlagText then
					local flagText = ""
					local hasFlag = false
					local flagBridge = FlagBridge and FlagBridge.Value or " : "
					if StaringText and StaringText.Enabled and ent.RootPart then
						local look = ent.RootPart.CFrame.LookVector
						local direction = (gameCamera.CFrame.Position - rootPosition).Unit
						if look:Dot(direction) > 0.78 then
							flagText = "STARING"
							hasFlag = true
						end
					end
					if HealthText and HealthText.Enabled then
						local healthText = tostring(math.floor(ent.Health)) .. " HP"
						flagText = hasFlag and (flagText .. flagBridge .. healthText) or healthText
						hasFlag = true
					end
					EntityESP.FlagText.Text = flagText
					EntityESP.FlagText.Visible = rootVis and hasFlag
					EntityESP.FlagText.Position = Vector2.new(posx + sizex + 5, posy)
					EntityESP.FlagText.Font = (FlagFont and FlagFont.Value == "arial") and 2 or 3
				end
				updateSkeletonDrawing(EntityESP.SkeletonLines, ent, rootVis and Skeleton and Skeleton.Enabled)
			end
		end,
		Drawing3D = function()
			gameCamera = workspace.CurrentCamera or gameCamera
			if not gameCamera then return end
			if shared.LionForceFOVEnabled and shared.LionForceFOVValue then
				gameCamera.FieldOfView = shared.LionForceFOVValue
			end
			for ent, EntityESP in Reference do
				local rootPart = getValidESPRoot(ent, EntityESP)
				if not rootPart then continue end
				local rootPosition = rootPart.Position
				if Distance and Distance.Enabled then
					local distance = getESPDistance(rootPosition)
					if distance > ((DistanceLimit and DistanceLimit.Value) or math.huge) then
						setESPVisible(EntityESP, false)
						continue
					end
				end
	
				local _, rootVis = gameCamera:WorldToViewportPoint(rootPosition)
				local color = entitylib.getEntityColor(ent) or uipallet.FinalColor
				local lineIndex = 0
				local drawColor = typeof(color) == "Color3" and color or Color3.fromRGB(255, 255, 255)
				for _, obj in EntityESP do
					lineIndex += 1
					obj.Visible = rootVis
					obj.Thickness = 2
					obj.Color = espGradientColor(BoundingBox, (lineIndex - 1) / 11, drawColor)
				end
				if not rootVis then continue end
	
				local point1 = ESPWorldToViewport(rootPosition + Vector3.new(1.5, ent.HipHeight, 1.5))
				local point2 = ESPWorldToViewport(rootPosition + Vector3.new(1.5, -ent.HipHeight, 1.5))
				local point3 = ESPWorldToViewport(rootPosition + Vector3.new(-1.5, ent.HipHeight, 1.5))
				local point4 = ESPWorldToViewport(rootPosition + Vector3.new(-1.5, -ent.HipHeight, 1.5))
				local point5 = ESPWorldToViewport(rootPosition + Vector3.new(1.5, ent.HipHeight, -1.5))
				local point6 = ESPWorldToViewport(rootPosition + Vector3.new(1.5, -ent.HipHeight, -1.5))
				local point7 = ESPWorldToViewport(rootPosition + Vector3.new(-1.5, ent.HipHeight, -1.5))
				local point8 = ESPWorldToViewport(rootPosition + Vector3.new(-1.5, -ent.HipHeight, -1.5))
				local function setBoxLine(line, fromPoint, toPoint)
					if not line then return end
					if fromPoint and toPoint then
						line.Visible = true
						line.From = fromPoint
						line.To = toPoint
					else
						line.Visible = false
					end
				end
				setBoxLine(EntityESP.Line1, point1, point2)
				setBoxLine(EntityESP.Line2, point3, point4)
				setBoxLine(EntityESP.Line3, point5, point6)
				setBoxLine(EntityESP.Line4, point7, point8)
				setBoxLine(EntityESP.Line5, point1, point3)
				setBoxLine(EntityESP.Line6, point1, point5)
				setBoxLine(EntityESP.Line7, point5, point7)
				setBoxLine(EntityESP.Line8, point7, point3)
				setBoxLine(EntityESP.Line9, point2, point4)
				setBoxLine(EntityESP.Line10, point2, point6)
				setBoxLine(EntityESP.Line11, point6, point8)
				setBoxLine(EntityESP.Line12, point8, point4)
			end
		end,
		DrawingSkeleton = function()
			gameCamera = workspace.CurrentCamera or gameCamera
			if not gameCamera then return end
			if shared.LionForceFOVEnabled and shared.LionForceFOVValue then
				gameCamera.FieldOfView = shared.LionForceFOVValue
			end
			for ent, EntityESP in Reference do
				local rootPart = getValidESPRoot(ent, EntityESP)
				if not rootPart then continue end
				local rootPosition = rootPart.Position
				if Distance and Distance.Enabled then
					local distance = getESPDistance(rootPosition)
					if distance > ((DistanceLimit and DistanceLimit.Value) or math.huge) then
						setESPVisible(EntityESP, false)
						continue
					end
				end
	
				local _, rootVis = gameCamera:WorldToViewportPoint(rootPosition)
				setESPVisible(EntityESP, rootVis)
				if not rootVis then continue end
				
				updateSkeletonDrawing(EntityESP, ent, rootVis)
			end
		end
	}
	
	local refreshESP = function() end

	ESP = Render:AddModule({
		Name = 'ESP',
		Function = function(callback)
			if callback then
				methodused = 'Drawing'..Method.Value
				scanWorldESP()
				ESP:Clean(workspace.DescendantAdded:Connect(function(inst)
					if inst:IsA("Model") or inst:IsA("BasePart") or inst:IsA("Folder") then addWorldESP(inst) end
				end))
				local nextWorldESPUpdate = 0
				RunService:BindToRenderStep("LionWorldESP", 2000, function()
					local now = os.clock()
					if now < nextWorldESPUpdate then return end
					nextWorldESPUpdate = now + (1 / 60)
					updateWorldESP()
				end)
				ESP:Clean({ Disconnect = function() RunService:UnbindFromRenderStep("LionWorldESP") end })
				if ESPRemoved[methodused] then
					ESP:Clean(entitylib:GetEvent("EntityRemoved"):Connect(ESPRemoved[methodused]))
				end
				if ESPAdded[methodused] then
					for _, v in entitylib.List do
						if Reference[v] then
							ESPRemoved[methodused](v)
						end
						ESPAdded[methodused](v)
					end
					ESP:Clean(entitylib:GetEvent("EntityAdded"):Connect(function(ent)
						if Reference[ent] then
							ESPRemoved[methodused](ent)
						end
						ESPAdded[methodused](ent)
					end))
				end
				if ESPUpdated[methodused] then
					ESP:Clean(entitylib:GetEvent("EntityUpdated"):Connect(ESPUpdated[methodused]))
					for _, v in entitylib.List do
						ESPUpdated[methodused](v)
					end
				end
				if ESPLoop[methodused] then
					RunService:BindToRenderStep("LionPlayerESP", 2000, function()
						ESPLoop[methodused]()
					end)
					ESP:Clean({ Disconnect = function() RunService:UnbindFromRenderStep("LionPlayerESP") end })
				end
			else
				for inst in pairs(WorldReference) do removeWorldESP(inst) end
				if ESPRemoved[methodused] then
					for i in Reference do
						ESPRemoved[methodused](i)
					end
				end
			end
		end
	})

	local refreshingESP = false
	local queuedESPRefresh = false
	refreshESP = function(immediate)
		if not ESP.Enabled or refreshingESP then return end
		if not immediate then
			if queuedESPRefresh then return end
			queuedESPRefresh = true
			task.delay(0.15, function()
				queuedESPRefresh = false
				refreshESP(true)
			end)
			return
		end
		refreshingESP = true

		for _, connection in ipairs(ESP.Connections) do
			pcall(function() connection:Disconnect() end)
		end
		table.clear(ESP.Connections)
		ESP.Function(false)

		if ESP.Enabled then
			ESP.Function(true)
		end
		refreshingESP = false
	end

	Method = ESP:AddDropdown({
		Name = 'Mode',
		List = {'2D', '3D', 'Skeleton'},
		Function = function(val)
			refreshESP(true)
			if BoundingBox then BoundingBox.Frame.Visible = (val == '2D') end
			if Filled then Filled.Frame.Visible = (val == '2D') end
			if HealthBar then HealthBar.Frame.Visible = (val == '2D') end
			if Name then Name.Frame.Visible = (val == '2D') end
			if DisplayName and Name then DisplayName.Frame.Visible = Name.Frame.Visible and Name.Enabled end
			if Background then Background.Frame.Visible = (val == '2D') end
			updateESPPreview()
		end,
	})

	if false then
	ESPColor = ESP:AddColorPicker({
		Name = 'ESP Color',
		Default = Color3.fromRGB(97, 131, 255),
		Function = function()
			updateESPPreview()
		end
	})
	end

	BoundingBox = ESP:AddToggle({
		Name = 'box',
		Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
		ColorTransparency = {0, 0, 0},
		Function = function()
			refreshESP()
			updateESPPreview()
		end,
		Default = true,
		Darker = true
	})
	Filled = ESP:AddToggle({
		Name = 'fill',
		Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
		ColorTransparency = {0, 0, 0},
		Function = function()
			refreshESP()
			updateESPPreview()
		end,
		Darker = true
	})
	Skeleton = ESP:AddToggle({
		Name = 'skeleton',
		Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
		ColorTransparency = {0, 0, 0},
		Default = true,
		Function = function()
			refreshESP()
			updateESPPreview()
		end,
		Darker = true
	})
	Name = ESP:AddToggle({
		Name = 'name',
		Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
		ColorTransparency = {0, 0, 0},
		Function = function(callback)
			refreshESP()
			if DisplayName then DisplayName.Frame.Visible = callback end
			if Background and Method then Background.Frame.Visible = Method.Value == '2D' end
			updateESPPreview()
		end,
		Darker = true
	})
	Weapon = ESP:AddToggle({
		Name = 'weapon',
		Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
		ColorTransparency = {0, 0, 0},
		Function = function()
			refreshESP()
			updateESPPreview()
		end,
		Darker = true
	})
	DistanceText = ESP:AddToggle({
		Name = 'distance',
		Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
		ColorTransparency = {0, 0, 0},
		Function = function()
			refreshESP()
			updateESPPreview()
		end,
		Darker = true
	})
	HealthBar = ESP:AddToggle({
		Name = 'healthbar',
		Colors = {Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 0)},
		ColorTransparency = {0, 0, 0},
		Function = function()
			refreshESP()
			updateESPPreview()
		end,
		Darker = true
	})
	DisplayName = ESP:AddToggle({
		Name = 'Use Displayname',
		Function = function()
			refreshESP()
			updateESPPreview()
		end,
		Default = true,
		Darker = true
	})
	Background = ESP:AddToggle({
		Name = 'Show Background',
		Function = function()
			refreshESP()
			updateESPPreview()
		end,
		Darker = true
	})
	Teammates = ESP:AddToggle({
		Name = 'Priority Only',
		Function = function()
			refreshESP()
			updateESPPreview()
		end,
		Default = true
	})
	Distance = ESP:AddToggle({
		Name = 'Distance Check',
		Function = function(callback)
			if DistanceLimit then DistanceLimit.Frame.Visible = callback end
			updateESPPreview()
		end
	})
	DistanceLimit = ESP:AddSlider({
		Name = 'Player Distance',
		Min = 0,
		Max = 256,
		Default = 64,
		Function = function()
			updateESPPreview()
		end,
		Darker = true,
		Visible = false
	})
	ResizeOutline = ESP:AddToggle({Name = 'resize outline'})
	MovingHealthbar = ESP:AddToggle({Name = 'moving healthbar'})
	HealthbarType = ESP:AddDropdown({Name = 'healthbar type', List = {'gradient', 'solid'}, Default = 'gradient'})
	HealthSlices = ESP:AddSlider({Name = 'slices', Min = 1, Max = 10, Default = 1})
	HealthSpeed = ESP:AddSlider({Name = 'speed', Min = 1, Max = 10, Default = 1})
	HealthLerp = ESP:AddSlider({Name = 'health lerp', Min = 0, Max = 1, Default = 0.05, Decimal = 100})

	StaringText = ESP:AddToggle({
		Name = 'staring text',
		Tab = 'flags',
		Colors = {Color3.fromRGB(255, 255, 255)}
	})
	HealthText = ESP:AddToggle({
		Name = 'health text',
		Tab = 'flags',
		Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)}
	})
	FlagFont = ESP:AddDropdown({
		Name = 'flags font',
		Text = 'font',
		Tab = 'flags',
		List = {'smallest pixel', 'monocraft', 'monocraft bold', 'proggy clean', 'proggy tiny', 'pixel', 'arial', 'ubuntu', 'tahoma'},
		Default = 'smallest pixel'
	})
	FlagStyle = ESP:AddDropdown({Name = 'style', Tab = 'flags', List = {'upper', 'lower', 'normal'}, Default = 'upper'})
	FlagPrefix = ESP:AddDropdown({Name = 'prefix', Tab = 'flags', List = {'full', 'short', 'none'}, Default = 'full'})
	FlagBridge = ESP:AddInputBox({Name = 'bridge', Tab = 'flags', Default = ':'})

	WorldName = ESP:AddToggle({
		Name = 'world name',
		Text = 'name',
		Tab = 'world',
		Colors = {Color3.fromRGB(255, 255, 255)}
	})
	WorldImage = ESP:AddToggle({
		Name = 'world image',
		Text = 'image',
		Tab = 'world',
		Colors = {Color3.fromRGB(255, 255, 255)}
	})
	WorldDistance = ESP:AddToggle({
		Name = 'world distance',
		Text = 'distance',
		Tab = 'world',
		Colors = {Color3.fromRGB(255, 255, 255)}
	})
	WorldScale = ESP:AddSlider({Name = 'object scale', Tab = 'world', Min = 25, Max = 250, Default = 100, Suffix = '%'})
	WorldLerp = ESP:AddSlider({Name = 'lerp speed', Tab = 'world', Min = 0.01, Max = 1, Default = 0.1, Decimal = 100, Suffix = 'x'})
	WorldWhitelist = ESP:AddDropdown({
		Name = 'whitelist',
		Tab = 'world',
		List = {'Grenade', 'Molotov', 'Satchel', 'Flashbang', 'Smoke Grenade', 'Subspace Tripmine'},
		Default = {Grenade = true, Molotov = true, Satchel = true, Flashbang = true, ['Smoke Grenade'] = true, ['Subspace Tripmine'] = true},
		Multi = true
	})
	WorldFont = ESP:AddDropdown({
		Name = 'world font',
		Text = 'font',
		Tab = 'world',
		List = {'smallest pixel', 'monocraft', 'monocraft bold', 'proggy clean', 'proggy tiny', 'pixel', 'arial', 'ubuntu', 'tahoma'},
		Default = 'monocraft bold'
	})
	ESP:AddButton({
		Text = 'ESP Preview',
		Func = function()
			local ok, err = pcall(createESPPreview)
			if not ok then
				warn("[ESP Preview] create failed:", err)
				if ESPPreview.Gui then
					ESPPreview.Gui:Destroy()
				end
				if ESPPreview.Model then
					ESPPreview.Model:Destroy()
				end
				if ESPPreview.VisualModel then
					ESPPreview.VisualModel:Destroy()
				end
				cleanupESPPreviewDrawings()
				ESPPreview.Gui = nil
				ESPPreview.Model = nil
				ESPPreview.VisualModel = nil
				ESPPreview.Parts = {}
				ESPPreview.Frame = nil
				ESPPreview.Wanted = false
			end
		end
	})
end)

run(function()
	local OverrideAppearance
	local OverrideColor
	local OverrideMaterial
	local Material
	local DisableAppearance
	local OverrideTransparency
	local HighlightESP
	local ThroughWalls
	local HighlightPulse
	local Particle
	local ParticleType
	local Aura
	local AuraType
	local IncludeTeammates
	local BoundingMode
	local FixedWidth
	local ESPFont
	local NameType
	local originalAppearance = setmetatable({}, {__mode = "k"})
	local highlights = {}
	local effects = {}

	local materialNames = {}
	for _, material in ipairs(Enum.Material:GetEnumItems()) do
		table.insert(materialNames, material.Name)
	end
	table.sort(materialNames)

	local function selectedMulti(option, name)
		return option and type(option.Value) == "table" and option.Value[name] == true
	end

	local function remember(inst, property)
		originalAppearance[inst] = originalAppearance[inst] or {}
		if originalAppearance[inst][property] == nil then
			originalAppearance[inst][property] = inst[property]
		end
	end

	local function restoreAppearance()
		for inst, values in pairs(originalAppearance) do
			for property, value in pairs(values) do
				pcall(function() inst[property] = value end)
			end
		end
		table.clear(originalAppearance)
	end

	local function applyAppearance(character)
		if not OverrideAppearance.Enabled or not character or character == LocalPlayer.Character then return end
		for _, inst in ipairs(character:GetDescendants()) do
			if inst:IsA("BasePart") then
				if OverrideColor and OverrideColor.Enabled then
					remember(inst, "Color")
					inst.Color = OverrideColor.Value or Color3.fromRGB(255, 255, 255)
				end
				if OverrideMaterial and OverrideMaterial.Enabled then
					remember(inst, "Material")
					inst.Material = Enum.Material[Material.Value] or Enum.Material.ForceField
				end
				remember(inst, "Transparency")
				inst.Transparency = math.clamp((OverrideTransparency and OverrideTransparency.Value or 0) / 100, 0, 1)
			elseif inst:IsA("Decal") and selectedMulti(DisableAppearance, "decals") then
				remember(inst, "Transparency")
				inst.Transparency = 1
			elseif (inst:IsA("Shirt") or inst:IsA("Pants") or inst:IsA("ShirtGraphic")) and selectedMulti(DisableAppearance, "clothing") then
				local property = inst:IsA("Shirt") and "ShirtTemplate" or inst:IsA("Pants") and "PantsTemplate" or "Graphic"
				remember(inst, property)
				inst[property] = ""
			elseif inst:IsA("Highlight") and selectedMulti(DisableAppearance, "highlight") then
				remember(inst, "Enabled")
				inst.Enabled = false
			end
		end
	end

	local function validTarget(player)
		return player ~= LocalPlayer and player.Character and (IncludeTeammates.Enabled or player.Team ~= LocalPlayer.Team)
	end

	local function removeVisual(player)
		if highlights[player] then highlights[player]:Destroy(); highlights[player] = nil end
		if effects[player] then
			effects[player]:Destroy()
			effects[player] = nil
		end
	end

	local function particleShape(emitter, style)
		emitter.Texture = "rbxassetid://243660364"
		emitter.Rate = 18
		emitter.Lifetime = NumberRange.new(0.7, 1.25)
		emitter.Speed = NumberRange.new(0.5, 2)
		emitter.SpreadAngle = Vector2.new(180, 180)
		emitter.Rotation = NumberRange.new(0, 360)
		emitter.RotSpeed = NumberRange.new(-90, 90)
		emitter.LightEmission = (style == "glowing" or style == "heavenly") and 1 or 0.35
		if style == "hearts" then emitter.Texture = "rbxassetid://241837157" end
		if style == "triangles" then emitter.Texture = "rbxassetid://121580522" end
	end

	local function auraShape(emitter, style)
		particleShape(emitter, "glowing")
		emitter.Rate = 28
		emitter.Lifetime = NumberRange.new(0.9, 1.8)
		emitter.Speed = NumberRange.new(style == "tornado" and 5 or 1, style == "wind" and 7 or 3)
		emitter.Acceleration = Vector3.new(0, style == "moon" and 1 or 3, 0)
		emitter.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
	end

	local function ensureVisual(player)
		if not validTarget(player) then removeVisual(player); return end
		local character = player.Character
		if HighlightESP.Enabled then
			local high = highlights[player]
			if not high or high.Parent ~= character then
				if high then high:Destroy() end
				high = Instance.new("Highlight")
				high.Name = "__LionESPHighlight"
				high.Adornee = character
				high.Parent = character
				highlights[player] = high
			end
			high.DepthMode = ThroughWalls.Enabled and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
			high.FillColor = HighlightESP.Colors and HighlightESP.Colors[1] or Color3.fromRGB(255, 255, 255)
			high.OutlineColor = HighlightESP.Colors and HighlightESP.Colors[2] or Color3.fromRGB(255, 255, 255)
		else
			if highlights[player] then highlights[player]:Destroy(); highlights[player] = nil end
		end

		local root = character:FindFirstChild("HumanoidRootPart")
		if root and ((Particle and Particle.Enabled) or (Aura and Aura.Enabled)) then
			local attachment = effects[player]
			if not attachment or attachment.Parent ~= root then
				if attachment then attachment:Destroy() end
				attachment = Instance.new("Attachment")
				attachment.Name = "__LionESPEffects"
				attachment.Parent = root
				effects[player] = attachment
			end
			local particle = attachment:FindFirstChild("Particle")
			if Particle.Enabled then
				particle = particle or Instance.new("ParticleEmitter")
				particle.Name = "Particle"
				particle.Parent = attachment
				particleShape(particle, ParticleType.Value)
				particle.Color = ColorSequence.new(Particle.Colors[1], Particle.Colors[3] or Particle.Colors[1])
			elseif particle then particle:Destroy() end
			local aura = attachment:FindFirstChild("Aura")
			if Aura.Enabled then
				aura = aura or Instance.new("ParticleEmitter")
				aura.Name = "Aura"
				aura.Parent = attachment
				auraShape(aura, AuraType.Value)
				aura.Color = ColorSequence.new(Aura.Colors[1], Aura.Colors[3] or Aura.Colors[1])
			elseif aura then aura:Destroy() end
		elseif effects[player] then
			effects[player]:Destroy()
			effects[player] = nil
		end
	end

	local function refreshVisuals()
		for _, player in ipairs(Players:GetPlayers()) do ensureVisual(player) end
	end

	OverrideAppearance = Render:AddModule({
		Name = "ESP Override Appearance",
		Colors = {Color3.fromRGB(255, 255, 255)},
		Function = function(enabled)
			if enabled then
				for _, player in ipairs(Players:GetPlayers()) do applyAppearance(player.Character) end
			else
				restoreAppearance()
			end
		end
	})
	OverrideColor = OverrideAppearance:AddToggle({Name = "color", Colors = {Color3.fromRGB(255, 255, 255)}, Function = function() restoreAppearance(); for _, p in ipairs(Players:GetPlayers()) do applyAppearance(p.Character) end end})
	OverrideMaterial = OverrideAppearance:AddToggle({Name = "material", Default = true, Function = function() restoreAppearance(); for _, p in ipairs(Players:GetPlayers()) do applyAppearance(p.Character) end end})
	Material = OverrideAppearance:AddDropdown({Name = "material type", List = materialNames, Default = "ForceField", Function = function() restoreAppearance(); for _, p in ipairs(Players:GetPlayers()) do applyAppearance(p.Character) end end})
	DisableAppearance = OverrideAppearance:AddDropdown({Name = "disable", List = {"decals", "clothing", "highlight"}, Default = {}, Multi = true, Function = function() restoreAppearance(); for _, p in ipairs(Players:GetPlayers()) do applyAppearance(p.Character) end end})
	OverrideTransparency = OverrideAppearance:AddSlider({Name = "transparency", Min = 0, Max = 100, Default = 0, Suffix = "%", Function = function() restoreAppearance(); for _, p in ipairs(Players:GetPlayers()) do applyAppearance(p.Character) end end})

	HighlightESP = Render:AddModule({
		Name = "ESP Highlight",
		Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
		Function = refreshVisuals
	})
	ThroughWalls = HighlightESP:AddToggle({Name = "through walls", Default = true, Function = refreshVisuals})
	HighlightPulse = HighlightESP:AddToggle({Name = "pulse"})
	Particle = HighlightESP:AddToggle({Name = "particle", Tab = "effects", Colors = {Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)}, Function = refreshVisuals})
	ParticleType = HighlightESP:AddDropdown({Name = "particle type", Tab = "effects", List = {"orbs", "hearts", "glowing", "heavenly", "triangles"}, Default = "orbs", Function = refreshVisuals})
	Aura = HighlightESP:AddToggle({Name = "aura", Tab = "effects", Colors = {Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)}, Function = refreshVisuals})
	AuraType = HighlightESP:AddDropdown({Name = "aura type", Tab = "effects", List = {"zen", "wire", "mist", "moon", "void", "wind", "whirl", "quake", "angel", "flame", "sphere", "aurora", "bubble", "spiral", "ribbon", "genesis", "tornado", "twilight", "blackhole", "celestial", "starlight"}, Default = "spiral", Function = refreshVisuals})

	local Customization = Render:AddModule({Name = "ESP Customization", HideEnabled = true})
	IncludeTeammates = Customization:AddToggle({Name = "include teammates", Function = refreshVisuals})
	shared.LionESPBoundingMode = shared.LionESPBoundingMode or "fixed"
	shared.LionESPFixedWidth = shared.LionESPFixedWidth or 100
	shared.LionESPFont = shared.LionESPFont or "monocraft"
	BoundingMode = Customization:AddDropdown({Name = "bounding mode", List = {"fixed", "dynamic"}, Default = "fixed", Function = function(value) shared.LionESPBoundingMode = value end})
	FixedWidth = Customization:AddSlider({Name = "fixed width scale", Min = 25, Max = 250, Default = 100, Suffix = "%", Function = function(value) shared.LionESPFixedWidth = value end})
	ESPFont = Customization:AddDropdown({Name = "font", List = {"monocraft", "smallest pixel", "monocraft bold", "proggy clean", "proggy tiny", "pixel", "arial", "ubuntu", "tahoma"}, Default = "monocraft", Function = function(value) shared.LionESPFont = value end})
	NameType = Customization:AddDropdown({Name = "name type", List = {"Name", "DisplayName"}, Default = "Name", Function = function(value)
		local esp = mainapi.Modules.ESP
		local display = esp and esp.Settings["Use Displayname"]
		if display then display:Toggle(value == "DisplayName") end
	end})

	mainapi:Clean(Players.PlayerRemoving:Connect(removeVisual))
	local nextHighlightPulseUpdate = 0
	mainapi:Clean(RunService.Heartbeat:Connect(function()
		local now = os.clock()
		if now < nextHighlightPulseUpdate then return end
		nextHighlightPulseUpdate = now + 0.033
		for player, high in pairs(highlights) do
			if high.Parent then
				local pulse = HighlightPulse.Enabled and ((math.sin(now * 4) + 1) * 0.5) or 0
				high.FillTransparency = HighlightPulse.Enabled and (0.2 + pulse * 0.55) or 0.35
				high.OutlineTransparency = HighlightPulse.Enabled and (0.05 + pulse * 0.3) or 0
			else
				highlights[player] = nil
			end
		end
	end))
	local running = true
	mainapi:Clean(function() running = false end)
	task.spawn(function()
		while running and task.wait(1) do
			if OverrideAppearance.Enabled then
				for _, player in ipairs(Players:GetPlayers()) do applyAppearance(player.Character) end
			end
			if HighlightESP.Enabled or OverrideAppearance.Enabled or next(highlights) or next(effects) then
				refreshVisuals()
			end
		end
	end)
end)

run(function()
	local AimAssist
	local Part
	local ClosestPart
	local ClosestPosition
	local DelayPosition
	local FOV
	local XSmooth
	local YSmooth
	local JumpSmoothing
	local Speed
	local Lerp
	local MovingRotation
	local RotationValue
	local RotationSpeed
	local FOVPosition
	local Outline
	local CircleFilled
	local FOVColor1
	local FOVColor2
	local FOVColor3
	local OutlineColor1
	local OutlineColor2
	local OutlineColor3
	local FillColor1
	local FillColor2
	local FillColor3
	local CircleObject
	local FillCircleObject
	local FillGradientObject
	local FillScreenGui
	local FillGradientLines = {}
	local OutlineGradientLines = {}
	local RangeCircle
	local RightClick
	local ShowTarget
	local LastTargetPosition
	local FOVVisualPosition

	local Camera = workspace.CurrentCamera

	local moveConst = Vector2.new(1, 0.77) * math.rad(0.5)

	local function removeCircle()
		if CircleObject then
			pcall(function()
				CircleObject.Visible = false
				CircleObject:Remove()
			end)
			CircleObject = nil
		end
		if FillCircleObject then
			pcall(function()
				FillCircleObject.Visible = false
				FillCircleObject:Destroy()
			end)
			FillCircleObject = nil
			FillGradientObject = nil
		end
		if FillScreenGui then
			pcall(function()
				FillScreenGui:Destroy()
			end)
			FillScreenGui = nil
		end
		for _, line in FillGradientLines do
			line.Visible = false
			line:Remove()
		end
		table.clear(FillGradientLines)
		for _, line in OutlineGradientLines do
			line.Visible = false
			line:Remove()
		end
		table.clear(OutlineGradientLines)
	end

	local function ensureCircle()
		if not FillCircleObject then
			FillScreenGui = Instance.new("ScreenGui")
			FillScreenGui.Name = "__LionAimAssistFOVFill"
			FillScreenGui.IgnoreGuiInset = true
			FillScreenGui.ResetOnSpawn = false
			FillScreenGui.DisplayOrder = 1000000
			FillScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
			FillScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

			FillCircleObject = Instance.new("Frame")
			FillCircleObject.AnchorPoint = Vector2.new(0.5, 0.5)
			FillCircleObject.BackgroundColor3 = Color3.new(1, 1, 1)
			FillCircleObject.BorderSizePixel = 0
			FillCircleObject.Visible = false
			FillCircleObject.ZIndex = 1
			FillCircleObject.Parent = FillScreenGui

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(1, 0)
			corner.Parent = FillCircleObject

			FillGradientObject = Instance.new("UIGradient")
			FillGradientObject.Rotation = 0
			FillGradientObject.Parent = FillCircleObject
		end

		if not CircleObject and Drawing then
			CircleObject = Drawing.new("Circle")
			CircleObject.Filled = false
			CircleObject.Color = (RangeCircle and RangeCircle.Value) or Color3.fromRGB(255,255,255)
			CircleObject.Radius = FOV and FOV.Value or 100
			CircleObject.Transparency = 1
			CircleObject.Thickness = 2
			CircleObject.Visible = false
		end
	end

	local function getThreeColors(option)
		if option and option.Colors then
			return option.Colors[1] or Color3.new(), option.Colors[2] or Color3.new(), option.Colors[3] or Color3.new()
		end
		return Color3.new(), Color3.new(), Color3.new()
	end

	local function getThreeTransparency(option)
		if option and option.ColorTransparency then
			return option.ColorTransparency[1] or 0, option.ColorTransparency[2] or 0, option.ColorTransparency[3] or 0
		end
		return 0, 0, 0
	end

	local function updateGradientGui(center, radius, option, visible)
		if not FillCircleObject or not FillGradientObject then return end
		FillCircleObject.Visible = visible
		if not visible then return end
		local a, b, c = getThreeColors(option)
		local ta, tb, tc = getThreeTransparency(option)
		local opacity = 0.46
		FillCircleObject.Position = UDim2.fromOffset(center.X, center.Y)
		FillCircleObject.Size = UDim2.fromOffset(radius * 2, radius * 2)
		FillGradientObject.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, a),
			ColorSequenceKeypoint.new(0.5, b),
			ColorSequenceKeypoint.new(1, c),
		})
		FillGradientObject.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1 - (opacity * (1 - ta))),
			NumberSequenceKeypoint.new(0.5, 1 - (opacity * (1 - tb))),
			NumberSequenceKeypoint.new(1, 1 - (opacity * (1 - tc))),
		})
		local rotation = RotationValue and RotationValue.Value or 0
		if MovingRotation and MovingRotation.Enabled then
			rotation += os.clock() * 360 * (RotationSpeed and RotationSpeed.Value or 1)
		end
		FillGradientObject.Rotation = rotation % 360
	end

	local function tweenFOVPosition(target, dt)
		if not FOVVisualPosition then
			FOVVisualPosition = target
			return target
		end
		local progress = math.clamp((dt or 0) / 0.18, 0, 1)
		local alpha = TweenService:GetValue(progress, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		FOVVisualPosition = FOVVisualPosition:Lerp(target, alpha)
		if (FOVVisualPosition - target).Magnitude < 0.1 then FOVVisualPosition = target end
		return FOVVisualPosition
	end

	local function gradientColor(a, b, c)
		if a and a.Colors then
			a, b, c = a.Colors[1], a.Colors[2], a.Colors[3]
		end
		local function asColor(value, fallback)
			if typeof(value) == "Color3" then
				return value
			end
			if type(value) == "table" and typeof(value.Value) == "Color3" then
				return value.Value
			end
			return fallback or Color3.fromRGB(255, 255, 255)
		end
		a = asColor(a)
		b = asColor(b, a)
		c = asColor(c, b)
		local t = (tick() * 0.25) % 1
		if t < 0.5 then
			return a:Lerp(b, t * 2)
		end
		return b:Lerp(c, (t - 0.5) * 2)
	end

	local function gradientColorAt(option, alpha)
		local a, b, c = getThreeColors(option)
		alpha = math.clamp(alpha or 0, 0, 1)
		if alpha < 0.5 then
			return a:Lerp(b, alpha * 2)
		end
		return b:Lerp(c, (alpha - 0.5) * 2)
	end

	local function hideDrawingLines(lines, startIndex)
		for i = startIndex or 1, #lines do
			if lines[i] then
				lines[i].Visible = false
			end
		end
	end

	local function getDrawingLine(lines, index)
		local line = lines[index]
		if not line and Drawing then
			line = Drawing.new("Line")
			line.Visible = false
			lines[index] = line
		end
		return line
	end

	local function updateGradientFill(lines, center, radius, option, visible, transparency)
		local count = math.clamp(math.floor(radius * 3), 240, 520)
		if not visible then
			hideDrawingLines(lines)
			return
		end
        local drawRadius = math.max(radius - 1.25, 1)
        local step = (drawRadius * 2) / count
		for i = 1, count do
			local alpha = (i - 1) / math.max(count - 1, 1)
			local x = -drawRadius + (step * (i - 0.5))
			local h = math.sqrt(math.max((drawRadius * drawRadius) - (x * x), 0)) * 2
			local line = getDrawingLine(lines, i)
			if line then
				line.From = Vector2.new(center.X + x, center.Y - (h / 2))
				line.To = Vector2.new(center.X + x, center.Y + (h / 2))
				line.Color = gradientColorAt(option, alpha)
				line.Transparency = transparency
				line.Thickness = math.max(1, step + 0.15)
				line.Visible = true
			end
		end
		hideDrawingLines(lines, count + 1)
	end

	local function updateGradientOutline(lines, center, radius, option, visible, thickness, transparency)
		local count = math.clamp(math.floor(radius * 2), 160, 320)
		if not visible then
			hideDrawingLines(lines)
			return
		end
		for i = 1, count do
			local a1 = ((i - 1) / count) * math.pi * 2
			local a2 = (i / count) * math.pi * 2
			local drawRadius = radius
			local x1, y1 = math.cos(a1) * drawRadius, math.sin(a1) * drawRadius
			local x2, y2 = math.cos(a2) * drawRadius, math.sin(a2) * drawRadius
			local alpha = ((x1 / drawRadius) + 1) * 0.5
			local line = getDrawingLine(lines, i)
			if line then
				line.From = Vector2.new(center.X + x1, center.Y + y1)
				line.To = Vector2.new(center.X + x2, center.Y + y2)
				line.Color = gradientColorAt(option, alpha)
				line.Transparency = transparency
				line.Thickness = thickness
				line.Visible = true
			end
		end
		hideDrawingLines(lines, count + 1)
	end

	mainapi:Clean(removeCircle)
	mainapi:Clean(LocalPlayer.OnTeleport:Connect(removeCircle))

	local function wrapAngle(num)
		num = num % math.pi
		num -= num >= (math.pi / 2) and math.pi or 0
		num += num < -(math.pi / 2) and math.pi or 0
		return num
	end

	local function getAimParts(char)
		local parts = {}
		if not char then return parts end
		for _, name in ipairs({"Head", "UpperTorso", "Torso", "HumanoidRootPart", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}) do
			local part = char:FindFirstChild(name)
			if part and part:IsA("BasePart") then
				table.insert(parts, part)
			end
		end
		return parts
	end

	local function getLocalFighter()
		local ok, fighter = pcall(function()
			return require(LocalPlayer.PlayerScripts.Controllers.FighterController)
		end)
		return ok and fighter and fighter.LocalFighter or nil
	end

	local function getMuzzleScreenPosition(camera)
		local muzzle
		local fighter = getLocalFighter()
		local item = fighter and fighter.EquippedItem
		pcall(function()
			if item and item.ViewModel and item.ViewModel.GetMuzzlePosition then
				muzzle = item.ViewModel:GetMuzzlePosition()
			end
		end)
		if not muzzle then
			pcall(function()
				local viewModels = workspace:FindFirstChild("ViewModels")
				if viewModels then
					for _, model in viewModels:GetChildren() do
						if model:IsA("Model") and model.Name:find(LocalPlayer.Name, 1, true) then
							local part = model:FindFirstChild("Muzzle", true)
								or model:FindFirstChild("Barrel", true)
								or model:FindFirstChild("Handle", true)
							if part and part:IsA("BasePart") then
								muzzle = part.Position
								break
							elseif part and part:IsA("Attachment") then
								muzzle = part.WorldPosition
								break
							end
						end
					end
				end
			end)
		end
		if muzzle and camera then
			local pos, visible = camera:WorldToViewportPoint(muzzle)
			if visible then
				return Vector2.new(pos.X, pos.Y)
			end
		end
	end

	local function getFOVOrigin(part)
		local mode = FOVPosition and FOVPosition.Value or ""
		local origin
		if mode == "position on target" and part then
			local pos, visible = Camera:WorldToViewportPoint(part.Position)
			if visible then origin = Vector2.new(pos.X, pos.Y) end
		end
		if not origin and mode == "position on barrel" and Camera then
			origin = getMuzzleScreenPosition(Camera)
		end
		if not origin and Camera then
			local viewport = Camera.ViewportSize
			origin = Vector2.new(viewport.X / 2, viewport.Y / 2)
		end
		origin = origin or UserInputService:GetMouseLocation()
		return origin
	end


	-- ???ENTITYLIB ?????????
	local function getClosestTarget()
		local closest
		local closestDist = FOV.Value

		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local char = plr.Character
				local humanoid = char and char:FindFirstChildOfClass("Humanoid")

				if char and humanoid and humanoid.Health > 0 then
					local origin = getFOVOrigin()
					local part = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
					local bestPartDist = math.huge
					if ClosestPart and ClosestPart.Enabled then
						for _, aimPart in ipairs(getAimParts(char)) do
							local screenPos, screenVisible = Camera:WorldToViewportPoint(aimPart.Position)
							if screenVisible then
								local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - origin).Magnitude
								if screenDist < bestPartDist then
									bestPartDist = screenDist
									part = aimPart
								end
							end
						end
					end

					if part then
						local pos, visible = Camera:WorldToViewportPoint(part.Position)

						if visible then
							local mouse = getFOVOrigin(part)
							local dist = (Vector2.new(pos.X,pos.Y) - mouse).Magnitude
							if ClosestPosition and ClosestPosition.Enabled then
								local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
								local targetRoot = char:FindFirstChild("HumanoidRootPart")
								if root and targetRoot then
									dist = (targetRoot.Position - root.Position).Magnitude
								end
							end

							if dist < closestDist then
								closestDist = dist
								closest = {
									Player = plr,
									Character = char,
									Part = part,
									ScreenDistance = dist
								}
							end
						end
					end
				end
			end
		end

		return closest
	end


	AimAssist = Combat:AddModule({
		Name = "Aim Assist",
		Function = function(enabled)
			if enabled and RangeCircle and RangeCircle.Enabled then
				ensureCircle()
			end

			if CircleObject then
				CircleObject.Visible = enabled and RangeCircle and RangeCircle.Enabled or false
			end

			if enabled then

				local rightClicked = not RightClick.Enabled

				AimAssist:Clean(RunService.RenderStepped:Connect(function(dt)
					local fovTarget = FOVPosition and FOVPosition.Value == "position on target" and LastTargetPosition and {Position = LastTargetPosition} or nil
					local fovPos = tweenFOVPosition(getFOVOrigin(fovTarget), dt)
					local radius = FOV.Value
					local visible = AimAssist.Enabled and RangeCircle.Enabled

					updateGradientGui(fovPos, radius, CircleFilled, visible and CircleFilled and CircleFilled.Enabled)
					if CircleObject then
						CircleObject.Position = fovPos
						CircleObject.Visible = visible
						CircleObject.Radius = radius
						CircleObject.Color = select(2, getThreeColors(Outline and Outline.Enabled and Outline or RangeCircle))
						CircleObject.Transparency = 1
						CircleObject.Filled = false
						CircleObject.Thickness = Outline and Outline.Enabled and 2 or 1
					end
					hideDrawingLines(OutlineGradientLines)

					if not rightClicked then
						LastTargetPosition = nil
						return
					end
					if mainapi.ClickGuiStatus then
						LastTargetPosition = nil
						return
					end

					local ent = getClosestTarget()

					if ent then

						if ShowTarget.Enabled then
							Targetinfo.Targets[ent] = tick() + 1
						end

						local targetPosition = ent.Part.Position
						if DelayPosition and DelayPosition.Enabled then
							targetPosition += ent.Part.AssemblyLinearVelocity * math.clamp((Speed and Speed.Value or 100) / 1000, 0, 0.2)
						end
						if JumpSmoothing and JumpSmoothing.Value then
							local velY = ent.Part.AssemblyLinearVelocity.Y
							targetPosition += Vector3.new(0, velY * ((JumpSmoothing.Value or 100) / 100) * dt, 0)
						end
						LastTargetPosition = targetPosition

						local facing = Camera.CFrame.LookVector
						local new = (targetPosition - Camera.CFrame.Position).Unit

						if new ~= Vector3.zero then

							local diffYaw =
								wrapAngle(
									math.atan2(facing.X,facing.Z)
									-
									math.atan2(new.X,new.Z)
								)

							local diffPitch =
								math.asin(facing.Y)
								-
								math.asin(new.Y)

							local angle =
								Vector2.new(diffYaw,diffPitch)
								/ (moveConst *
								UserSettings():GetService("UserGameSettings").MouseSensitivity)

							angle = Vector2.new(angle.X * ((XSmooth and XSmooth.Value or 100) / 100), angle.Y * ((YSmooth and YSmooth.Value or 100) / 100))
							angle *= math.min(((Speed and Speed.Value or 100) / 100) * ((Lerp and Lerp.Value or 1)) * dt * 10, 1)

							mousemoverel(angle.X,angle.Y)

						end
					else
						LastTargetPosition = nil
					end

				end))


				if RightClick.Enabled then

					AimAssist:Clean(
						UserInputService.InputBegan:Connect(function(input)

							if input.UserInputType == Enum.UserInputType.MouseButton2 then
								rightClicked = true
							end

						end)
					)

					AimAssist:Clean(
						UserInputService.InputEnded:Connect(function(input)

							if input.UserInputType == Enum.UserInputType.MouseButton2 then
								rightClicked = false
							end

						end)
					)

				end
			end

			if enabled then
				AimAssist:Clean(LocalPlayer.OnTeleport:Connect(removeCircle))
			else
				removeCircle()
			end
		end
	})

	if false then
	Part = AimAssist:AddDropdown({
		Name = "Part",
		List = {"RootPart","Head"}
	})
	end

	ClosestPart = AimAssist:AddToggle({
		Name = "closest part"
	})

	ClosestPosition = AimAssist:AddToggle({
		Name = "closest position"
	})

	DelayPosition = AimAssist:AddToggle({
		Name = "delay position",
		Default = true
	})

	XSmooth = AimAssist:AddSlider({
		Name = "x smooth",
		Min = 1,
		Max = 100,
		Default = 100,
		Suffix = "%"
	})

	YSmooth = AimAssist:AddSlider({
		Name = "y smooth",
		Min = 1,
		Max = 100,
		Default = 100,
		Suffix = "%"
	})

	JumpSmoothing = AimAssist:AddSlider({
		Name = "jump smoothing",
		Min = 0,
		Max = 100,
		Default = 100,
		Suffix = "%"
	})

	RangeCircle = AimAssist:AddToggle({
		Name = "show fov",
		Default = true,
		Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
		ColorTransparency = {0, 0, 0},
		Function = function(state)

			if state then
				ensureCircle()
				if FillCircleObject then
					FillCircleObject.Visible = false
				end
				if CircleObject then
					CircleObject.Visible = false
				end

			else
				hideDrawingLines(FillGradientLines)
				hideDrawingLines(OutlineGradientLines)
				removeCircle()
			end

			CircleFilled.Frame.Visible = state

		end
	})

	Outline = AimAssist:AddToggle({
		Name = "outline",
		Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
		ColorTransparency = {0, 0, 0},
		Function = function()
			if CircleObject then
				CircleObject.Thickness = Outline.Enabled and 2 or 1
			end
		end
	})

	CircleFilled = AimAssist:AddToggle({
		Name = "fill",
		Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
		ColorTransparency = {0, 0, 0},
		Function = function(val)

			hideDrawingLines(FillGradientLines)
			if FillCircleObject then
				FillCircleObject.Visible = false
			end
			if CircleObject then
				CircleObject.Filled = false
			end

		end
	})
	task.defer(function()
		if RangeCircle and RangeCircle.Enabled then
			ensureCircle()
		end
	end)

	Lerp = AimAssist:AddSlider({
		Name = "lerp",
		Min = 1,
		Max = 10,
		Default = 1,
		Decimal = 10,
		Suffix = "x"
	})

	MovingRotation = AimAssist:AddToggle({
		Name = "moving rotation"
	})

	RotationValue = AimAssist:AddSlider({
		Name = "rotation",
		Min = 0,
		Max = 360,
		Default = 0,
		Suffix = "°",
		Compact = true
	})

	RotationSpeed = AimAssist:AddSlider({
		Name = "speed",
		Min = 1,
		Max = 10,
		Default = 1,
		Decimal = 10,
		Suffix = "rps",
		Compact = true,
		Parent = RotationValue
	})

	FOVPosition = AimAssist:AddDropdown({
		Name = "fov settings",
		List = {"", "position on target", "position on barrel"},
		Default = "",
		Function = function()
			LastTargetPosition = nil
		end
	})

	FOV = AimAssist:AddSlider({
		Name = "radius",
		Min = 0,
		Max = 1000,
		Default = 100,
		Function = function(val)
			if FillCircleObject then
				FillCircleObject.Size = UDim2.fromOffset(val * 2, val * 2)
			end
			if CircleObject then
				CircleObject.Radius = val
			end
		end,
		Suffix = "px"
	})

	Speed = AimAssist:AddSlider({
		Name = "smoothing",
		Min = 1,
		Max = 100,
		Default = 100,
		Suffix = "%"
	})


	if false then
	RightClick = AimAssist:AddToggle({
		Name = "Require right click"
	})
	end
	RightClick = {Enabled = false}


	if false then
	ShowTarget = AimAssist:AddToggle({
		Name = "Show Target",
		Visible = false
	})
	end
	ShowTarget = {Enabled = false}

end)

run(function()

    local RageSilent
    RageSilent = Combat:AddModule({
        Name = 'Rage Silent',
        HideEnabled = true,
        Function = function(callback)
            if callback then

                local rs = cloneref(game:GetService("ReplicatedStorage"))
                local players = cloneref(game:GetService("Players"))
                local workspace = cloneref(game:GetService("Workspace"))
                local runservice = cloneref(game:GetService("RunService"))

                local lplr = players.LocalPlayer

                local util = require(rs.Modules.Utility)
                local enums = require(rs.Modules.EnumLibrary)
                local gameplay = require(rs.Modules.GameplayUtility)
                local fighter = require(lplr.PlayerScripts.Controllers.FighterController)

                local ray_params = RaycastParams.new()
                ray_params.FilterType = Enum.RaycastFilterType.Blacklist

                -------------------------------------------------
                -- TOGGLE
                -------------------------------------------------

                _G.ManipulationEnabled = true
                local manipulationConnection

                -------------------------------------------------
                -- SETTINGS
                -------------------------------------------------

                local PREDICTION = 0.12
                local HEAD_OFFSET = Vector3.new(0, 0.1, 0)

                -------------------------------------------------
                -- CHECKS
                -------------------------------------------------

                local function isEnemy(player)
                    local char = player.Character
                    if not char then return false end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if not hrp then return false end
                    return hrp:FindFirstChild("TeammateLabel") == nil
                end

                local function isAlive(char)
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    return hum and hum.Health > 0
                end

                local function isInvincible(character)
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if not root then return false end

                    for _,v in pairs(root:GetChildren()) do
                        if v:IsA("Attachment") and v.Name == "Attachment" then
                            return true
                        end
                    end

                    if character:FindFirstChild("InvincibilityParticles", true) then
                        return true
                    end

                    return false
                end

                -------------------------------------------------
                -- PREDICTION
                -------------------------------------------------

                local function getPrediction(part)
                    local vel = part.Velocity or Vector3.zero
                    return part.Position + (vel * PREDICTION)
                end

                -------------------------------------------------
                -- VISIBILITY
                -------------------------------------------------

                local function isVisible(origin, targetPart)
                    ray_params.FilterDescendantsInstances = {lplr.Character}

                    local result = workspace:Raycast(origin, targetPart.Position - origin, ray_params)
                    return not result or result.Instance:IsDescendantOf(targetPart.Parent)
                end

                -------------------------------------------------
                -- TARGET
                -------------------------------------------------

                local function getClosest()
                    local closest, char
                    local dist = math.huge

                    local myChar = lplr.Character
                    if not myChar then return end

                    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then return end

                    for _,v in pairs(players:GetPlayers()) do
                        if v ~= lplr
                        and v.Character
                        and v.Character:FindFirstChild("Head")
                        and isEnemy(v)
                        and isAlive(v.Character)
                        and not isInvincible(v.Character)
                        then
                            local head = v.Character.Head
                            local d = (head.Position - myRoot.Position).Magnitude

                            if d < dist then
                                dist = d
                                closest = head
                                char = v.Character
                            end
                        end
                    end

                    return closest, char
                end

                -------------------------------------------------
                -- MAIN
                -------------------------------------------------

                manipulationConnection = runservice.Heartbeat:Connect(function()

                    if not _G.ManipulationEnabled then return end
                    if not lplr.Character then return end
                    if not fighter or not fighter.LocalFighter then return end

                    local item = fighter.LocalFighter.EquippedItem
                    if not item then return end

                    local target_part, target_char = getClosest()
                    if not target_part or isInvincible(target_char) then return end

                    local cam = workspace.CurrentCamera.CFrame
                    local shoot_pos = cam.Position

                    -- ???? + head ????? 뮛????
                    local predicted = getPrediction(target_part) + HEAD_OFFSET

                    if not isVisible(shoot_pos, target_part) then return end

                    local direction = (predicted - shoot_pos).Unit

local finalLook = CFrame.new(shoot_pos, shoot_pos + direction)

                    -------------------------------------------------
                    -- FIRE
                    -------------------------------------------------

                    local cameradata = {}

                    cameradata[utf8.char(1)] = {
                        [utf8.char(0)] = util:EncodeCFrame(finalLook),
                        [utf8.char(1)] = util:EncodeCFrame(finalLook),
                        [utf8.char(2)] = target_part,
                        [utf8.char(3)] =
                            util:EncodeCFrame(
                                target_part.CFrame:ToObjectSpace(
                                    CFrame.new(predicted)
                                )
                            )
                    }

                    rs.Remotes.Replication.Fighter.UseItem:FireServer(
                        item:Get("ObjectID"),
                        enums:ToEnum("StartShooting"),
                        cameradata,
                        nil
                    )

                end)

                -------------------------------------------------
                -- STOP
                -------------------------------------------------

                _G.StopManipulation = function()
                    _G.ManipulationEnabled = false
                    if manipulationConnection then
                        manipulationConnection:Disconnect()
                        manipulationConnection = nil
                    end
                end

            else
                _G.ManipulationEnabled = false
            end
        end
    })
end)

run(function()
    local ProjectileTP

    ProjectileTP = Movement:AddModule({
        Name = 'Projectile TP',
        Function = function(callback)
            if callback then
                local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local ENABLED = true -- ????????곌떽?깅㎧??ON/OFF

local TARGET_FOLDERS = {
    ["Daggers"] = true,
    ["Bow"] = true,
    ["Slingshot"] = true
}

local ORIENTATION_OFFSET = CFrame.new()

local connections = {}
local attached = setmetatable({}, { __mode = "k" })

local function GetClosestPlayerHead()
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end

    local closestHead, shortest = nil, math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            local head = char and char:FindFirstChild("Head")
            if head then
                local dist = (myHRP.Position - head.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closestHead = head
                end
            end
        end
    end

    return closestHead
end

local function AttachPartToClosestHead(part)
    if not part or not part:IsA("BasePart") then return end
    if attached[part] then return end
    attached[part] = true

    part.CanCollide = false
    part.Massless = true

    task.spawn(function()
        while part and part.Parent and ENABLED do
            local head = GetClosestPlayerHead()
            if head and head.Parent then
                local targetPos = head.Position + Vector3.new(0, 0.25, 0)

                part.AssemblyAngularVelocity = Vector3.zero
                part.CFrame = CFrame.new(targetPos) * ORIENTATION_OFFSET
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

local function HandleInstance(inst)
    if not ENABLED then return end
    if not inst or not inst.Parent then return end

    if inst:IsA("BasePart") then
        AttachPartToClosestHead(inst)
    elseif inst:IsA("Model") or inst:IsA("Folder") then
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("BasePart") then
                AttachPartToClosestHead(d)
            end
        end
    end
end

local function HookFolder(folder)
    for _, d in ipairs(folder:GetDescendants()) do
        HandleInstance(d)
    end

    local conn = folder.DescendantAdded:Connect(function(desc)
        HandleInstance(desc)
    end)
    table.insert(connections, conn)
end

local function TryStart()
    for _, child in ipairs(workspace:GetChildren()) do
        if TARGET_FOLDERS[child.Name] then
            HookFolder(child)
        end
    end

    local conn = workspace.ChildAdded:Connect(function(child)
        if TARGET_FOLDERS[child.Name] then
            HookFolder(child)
        end
    end)
    table.insert(connections, conn)
end

-- ???꿔꺂???影??  ?
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

TryStart()

-------------------------------------------------
-- ????????諛몃 ????????
-------------------------------------------------
function DisableProjectileTP()
    ENABLED = false

    for _, conn in ipairs(connections) do
        pcall(function()
            conn:Disconnect()
        end)
    end

    table.clear(connections)
    table.clear(attached)

end
            else
                DisableProjectileTP()
            end
        end
    })

end)



run(function()
	local TargetStrafe
	local Targets
	local SearchRange
	local StrafeRange
	local YFactor
	local rayCheck = RaycastParams.new()
	rayCheck.RespectCanCollide = true
	local module, old
	
	TargetStrafe = Movement:AddModule({
		Name = 'Target Strafe',
		Function = function(callback)
			if callback then
				if not module then
					local suc = pcall(function() module = require(LocalPlayer.PlayerScripts.PlayerModule).controls end)
					if not suc then
						module = {}
					end
				end
				
				old = module.moveFunction
				local flymod, ang, oldent = mainapi.Modules.Fly or {Enabled = false}
				module.moveFunction = function(self, vec, face)
					local ent = not UserInputService:IsKeyDown(Enum.KeyCode.S) and entitylib.EntityPosition({
						Range = SearchRange.Value,
						Wallcheck = false,
						Part = 'RootPart',
						Players = true,
						NPCs = false
					})
	
					if ent then
						local root, targetPos = entitylib.character.RootPart, ent.RootPart.Position
						rayCheck.FilterDescendantsInstances = {LocalPlayer.Character, gameCamera, ent.Character}
						rayCheck.CollisionGroup = root.CollisionGroup
	
						if flymod.Enabled or workspace:Raycast(targetPos, Vector3.new(0, -70, 0), rayCheck) then
							local factor, localPosition = 0, root.Position
							if ent ~= oldent then
								ang = math.deg(select(2, CFrame.lookAt(targetPos, localPosition):ToEulerAnglesYXZ()))
							end
							local yFactor = math.abs(localPosition.Y - targetPos.Y) * (YFactor.Value / 100)
							local entityPos = Vector3.new(targetPos.X, localPosition.Y, targetPos.Z)
							local newPos = entityPos + (CFrame.Angles(0, math.rad(ang), 0).LookVector * (StrafeRange.Value - yFactor))
							local startRay, endRay = entityPos, newPos
	
							if not wallcheck and workspace:Raycast(targetPos, (localPosition - targetPos), rayCheck) then
								startRay, endRay = entityPos + (CFrame.Angles(0, math.rad(ang), 0).LookVector * (entityPos - localPosition).Magnitude), entityPos
							end
	
							local ray = workspace:Blockcast(CFrame.new(startRay), Vector3.new(1, entitylib.character.HipHeight + (root.Size.Y / 2), 1), (endRay - startRay), rayCheck)
							if (localPosition - newPos).Magnitude < 3 or ray then
								factor = (8 - math.min((localPosition - newPos).Magnitude, 3))
								if ray then
									newPos = ray.Position + (ray.Normal * 1.5)
									factor = (localPosition - newPos).Magnitude > 3 and 0 or factor
								end
							end
	
							if not flymod.Enabled and not workspace:Raycast(newPos, Vector3.new(0, -70, 0), rayCheck) then
								newPos = entityPos
								factor = 40
							end
	
							ang += factor % 360
							vec = ((newPos - localPosition) * Vector3.new(1, 0, 1)).Unit
							vec = vec == vec and vec or Vector3.zero
							TargetStrafeVector = vec
						else
							ent = nil
						end
					end
	
					TargetStrafeVector = ent and vec or nil
					oldent = ent
					return old(self, vec, face)
				end
			else
				if module and old then
					module.moveFunction = old
				end
				TargetStrafeVector = nil
			end
		end
	})

	SearchRange = TargetStrafe:AddSlider({
		Name = 'Search Range',
		Min = 1,
		Max = 30,
		Default = 24,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	StrafeRange = TargetStrafe:AddSlider({
		Name = 'Strafe Range',
		Min = 1,
		Max = 30,
		Default = 18,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	YFactor = TargetStrafe:AddSlider({
		Name = 'Y Factor',
		Min = 0,
		Max = 100,
		Default = 100,
		Suffix = '%'
	})
end)

run(function()

            -- Unlock All module removed
local plrs = game:GetService("Players")
local reps = game:GetService("ReplicatedStorage")
local http = game:GetService("HttpService")
local collectionService = game:GetService("CollectionService")

local lp = plrs.LocalPlayer
if not lp then return end

local lps = lp:FindFirstChild("PlayerScripts") or lp:WaitForChild("PlayerScripts", 10)
if not lps then return end

local ctrls = lps:FindFirstChild("Controllers") or lps:WaitForChild("Controllers", 10)
local rmods = reps:FindFirstChild("Modules") or reps:WaitForChild("Modules", 10)
if not ctrls or not rmods then return end

local function safeRequireModule(module)
	if not module then return nil end
	local ok, result = pcall(require, module)
	return ok and result or nil
end

local elib = safeRequireModule(rmods:WaitForChild("EnumLibrary", 10))
if elib and elib.WaitForEnumBuilder then
	pcall(function()
		elib:WaitForEnumBuilder()
	end)
end
local clib = safeRequireModule(rmods:WaitForChild("CosmeticLibrary", 10))
local ilib = safeRequireModule(rmods:WaitForChild("ItemLibrary", 10))
local consts = safeRequireModule(rmods:WaitForChild("CONSTANTS", 10))
local dctrl = safeRequireModule(ctrls:WaitForChild("PlayerDataController", 10))
if not (elib and clib and ilib and consts and dctrl and clib.Cosmetics) then return end
local coss = clib.Cosmetics

local function findDescendantByName(parent, name)
	if not parent then return nil end
	local direct = parent:FindFirstChild(name)
	if direct then return direct end
	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant.Name == name then
			return descendant
		end
	end
	return nil
end

local KNIFE_CUSTOM_SKIN = "Knife (Custom Skin)"
local REAVER_KNIFE_CUSTOM_SKIN = "reaver"
local DAGGERS_CUSTOM_SKIN = "Jett"
local SATCHEL_CUSTOM_SKIN = "Raze"
local SNIPER_CUSTOM_SKIN = "Chamber"
local RPG_CUSTOM_SKIN = "RPG Raze"
local FISTS_CUSTOM_SKIN = "Agent"
local BOW_CUSTOM_SKIN = "Sova"
local ASSAULT_RIFLE_CUSTOM_SKIN = "Vandal"
local DICE_TRIPMINE_SKIN = "Subspace Tripmine (Custom Skin)"
local DICE_TRIPMINE_OUTER_MESH_ID = "rbxassetid://5555691474"
local DICE_TRIPMINE_INNER_MESH_ID = "rbxassetid://5555691356"
local DICE_TRIPMINE_IMAGE_ID = "rbxassetid://98372867049331"
local DICE_TRIPMINE_IMAGE_HIGH_RES_ID = "rbxassetid://75601061529918"
local DICE_TRIPMINE_MESH_SCALE = 3.35
local DICE_TRIPMINE_WORLD_MESH_SCALE = 3.25
local SPIKE_TRIPMINE_SKIN = "Spike"
local SPIKE_TRIPMINE_MESH_ID = "rbxassetid://97754746098028"
local TRIPMINE_STAR_REMOVE_MESH_ID = "rbxassetid://13792525075"
local SPIKE_TRIPMINE_MESH_SCALE = 85
local SPIKE_TRIPMINE_WORLD_MESH_SCALE = 50
local SNIPER_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://98786413608787"
local SNIPER_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://131686603013672"
local SNIPER_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.025, 0.025, 0.025)
local SNIPER_CUSTOM_REPLACEMENT_OFFSET = Vector3.new(0, -0.25, 0)
local DAGGERS_CUSTOM_SOURCE_MESH_ID = "rbxassetid://94772705561955"
local DAGGERS_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://128075492497238"
local DAGGERS_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://79246900644201"
local DAGGERS_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.03, 0.03, 0.03)
local DAGGERS_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, 90, -90)
local SATCHEL_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://129982008330139"
local SATCHEL_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://121713947189258"
local SATCHEL_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.5, 0.5, 0.5)
local SATCHEL_CUSTOM_WORLD_REPLACEMENT_SIZE = Vector3.new(0.6, 0.6, 0.6)
local SATCHEL_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, -90, 0)
local RPG_CUSTOM_BODY_REPLACEMENT_MESH_ID = "rbxassetid://81554047161707"
local RPG_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID = "rbxassetid://133257377819985"
local RPG_CUSTOM_REPLACEMENT_SCALE = 0.5
local RPG_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, 90, 0)
local RPG_CUSTOM_REPLACEMENT_OFFSET = Vector3.new(0.04, 0, 0)
local FISTS_CUSTOM_LEFT_MESH_ID = "rbxassetid://120273083766829"
local FISTS_CUSTOM_LEFT_TEXTURE_ID = "rbxassetid://124608382264962"
local FISTS_CUSTOM_RIGHT_MESH_ID = "rbxassetid://129220833982000"
local FISTS_CUSTOM_RIGHT_TEXTURE_ID = "rbxassetid://118482605175566"
local FISTS_CUSTOM_MESH_SCALE = Vector3.new(0.1, 0.1, 0.1)
local FISTS_CUSTOM_LEFT_ROTATION = Vector3.new(45, 0, 0)
local FISTS_CUSTOM_RIGHT_ROTATION = Vector3.new(-45, 0, 0)
local BOW_CUSTOM_BODY_REPLACEMENT_MESH_ID = "rbxassetid://80147707463344"
local BOW_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID = "rbxassetid://87690225474067"
local BOW_CUSTOM_ARROW_REPLACEMENT_MESH_ID = "rbxassetid://97839236861642"
local BOW_CUSTOM_ARROW_REPLACEMENT_TEXTURE_ID = "rbxassetid://82458179247269"
local BOW_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.25, 0.25, 0.25)

local CUSTOM_SKIN_IMAGE_OVERRIDES = {
	[REAVER_KNIFE_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	["sky"] = { Image = "", ImageHighResolution = "" },
	["Camera"] = { Image = "", ImageHighResolution = "" },
	["Grenade Raze"] = { Image = "", ImageHighResolution = "" },
	[DAGGERS_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[SATCHEL_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[SNIPER_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	["Operator"] = { Image = "", ImageHighResolution = "" },
	[RPG_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[FISTS_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[BOW_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[ASSAULT_RIFLE_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
	[DICE_TRIPMINE_SKIN] = { Image = DICE_TRIPMINE_IMAGE_ID, ImageHighResolution = DICE_TRIPMINE_IMAGE_HIGH_RES_ID },
	[SPIKE_TRIPMINE_SKIN] = { Image = "", ImageHighResolution = "" }
}

local SNIPER_MESH_SKIN_OVERRIDES = {
	[SNIPER_CUSTOM_SKIN] = {
		Skin = SNIPER_CUSTOM_SKIN,
		BodyMeshIds = {
			"rbxassetid://95497877882755",
			"rbxassetid://118920880889483",
			"rbxassetid://80662423119419"
		},
		RemoveMeshIds = {
			"rbxassetid://100168191352015",
			"rbxassetid://82935541182957",
			"rbxassetid://95388370230390",
			"rbxassetid://84918196407550"
		},
		ReplacementMeshId = SNIPER_CUSTOM_REPLACEMENT_MESH_ID,
		ReplacementTextureId = SNIPER_CUSTOM_REPLACEMENT_TEXTURE_ID,
		ReplacementSize = SNIPER_CUSTOM_REPLACEMENT_SIZE,
		ReplacementOffset = SNIPER_CUSTOM_REPLACEMENT_OFFSET
	},
	["Operator"] = {
		Skin = "Operator",
		BodyMeshIds = {
			"rbxassetid://13188893115",
			"rbxassetid://13188892761",
			"rbxassetid://14778413014",
			"rbxassetid://13188893017",
			"rbxassetid://14774727092"
		},
		RemoveMeshIds = {
			"rbxassetid://13188893310",
			"rbxassetid://13188892855"
		},
		BulletMeshIds = {
			"rbxassetid://14002915797"
		},
		MagazineMeshIds = {
			"rbxassetid://13188892532",
			"rbxassetid://13188892651"
		},
		BodyReplacementMeshId = "rbxassetid://132995629661821",
		BodyReplacementTextureId = "rbxassetid://80634410259243",
		ScopeReplacementMeshId = "rbxassetid://103988563532751",
		ScopeReplacementTextureId = "rbxassetid://136789986141252",
		MagazineReplacementMeshId = "rbxassetid://80074307887476",
		MagazineReplacementTextureId = "rbxassetid://80634410259243",
		ReplacementSize = Vector3.new(0.3, 0.3, 0.3),
		ReplacementOffset = Vector3.new(0, -0.25, 0),
		ScopeOffset = Vector3.new(0.175, 0.5, 0.005),
		MagazineOffset = Vector3.new(0.7, 0, 0.05),
		BulletOffset = Vector3.new(-1.25, 0, 0),
		ReplacementVersion = 9
	}
}

local DAGGERS_MESH_SKIN_OVERRIDES = {
	[DAGGERS_CUSTOM_SKIN] = {
		Skin = DAGGERS_CUSTOM_SKIN,
		SourceMeshIds = { DAGGERS_CUSTOM_SOURCE_MESH_ID },
		ReplacementMeshId = DAGGERS_CUSTOM_REPLACEMENT_MESH_ID,
		ReplacementTextureId = DAGGERS_CUSTOM_REPLACEMENT_TEXTURE_ID,
		ReplacementSize = DAGGERS_CUSTOM_REPLACEMENT_SIZE,
		ReplacementRotation = DAGGERS_CUSTOM_REPLACEMENT_ROTATION,
		ReplacementVersion = 6,
		FallbackBodyNames = { "LeftBody", "RightBody" }
	}
}

local SATCHEL_MESH_SKIN_OVERRIDES = {
	[SATCHEL_CUSTOM_SKIN] = {
		Skin = SATCHEL_CUSTOM_SKIN,
		SourceMeshIds = {
			"rbxassetid://138805549853994",
			"rbxassetid://125258747465100",
			"rbxassetid://111319295872696",
			"rbxassetid://129504437671598",
			"rbxassetid://104440368867933"
		},
		ReplacementMeshId = SATCHEL_CUSTOM_REPLACEMENT_MESH_ID,
		ReplacementTextureId = SATCHEL_CUSTOM_REPLACEMENT_TEXTURE_ID,
		ReplacementSize = SATCHEL_CUSTOM_REPLACEMENT_SIZE,
		WorldReplacementSize = SATCHEL_CUSTOM_WORLD_REPLACEMENT_SIZE,
		ReplacementRotation = SATCHEL_CUSTOM_REPLACEMENT_ROTATION,
		ReplacementVersion = 5
	},
	[REAVER_KNIFE_CUSTOM_SKIN] = {
		Skin = REAVER_KNIFE_CUSTOM_SKIN,
		SourceMeshIds = {
			"rbxassetid://85166039303292",
			"rbxassetid://125674590013235",
			"rbxassetid://97042702941502",
			"rbxassetid://116723276788898",
			"rbxassetid://99266754879173"
		},
		ReplacementMeshId = "rbxassetid://76054449109492",
		ReplacementTextureId = "rbxassetid://117578984602503",
		ReplacementSize = Vector3.new(0.3, 0.3, 0.3),
		ReplacementRotation = Vector3.new(0, 90, 0),
		ReplacementOffset = Vector3.new(0, 0.5, 0),
		ReplacementVersion = 3
	},
	["sky"] = {
		Skin = "sky",
		SourceMeshIds = { "rbxassetid://140203670599306" },
		ReplacementMeshId = "rbxassetid://78577370691269",
		ReplacementTextureId = "rbxassetid://130284287910497",
		ReplacementSize = Vector3.new(0.6, 0.6, 0.6),
		ReplacementRotation = Vector3.new(0, 90, 0),
		WorldSourceMeshIds = { "rbxassetid://140203670599306" },
		WorldReplacementMeshId = "rbxassetid://111122607123480",
		WorldReplacementTextureId = "rbxassetid://86629139856581",
		WorldReplacementSize = Vector3.new(0.3, 0.3, 0.3),
		WorldReplacementRotation = Vector3.zero,
		ReplacementVersion = 2
	},
	["Grenade Raze"] = {
		Skin = "Grenade Raze",
		SourceMeshIds = {
			"rbxassetid://87132852844264",
			"rbxassetid://96681677373844",
			"rbxassetid://121396126155803",
			"rbxassetid://121842208464560"
		},
		ReplacementMeshId = "rbxassetid://80612596590820",
		ReplacementTextureId = "rbxassetid://123233413518598",
		ReplacementSize = Vector3.new(0.8, 0.8, 0.8),
		ReplacementVersion = 2
	},
	["Camera"] = {
		Skin = "Camera",
		SourceMeshIds = {
			"rbxassetid://17835823024",
			"rbxassetid://17835823121",
			"rbxassetid://17835823211"
		},
		ReplacementMeshId = "rbxassetid://112849634500139",
		ReplacementTextureId = "rbxassetid://126465878813440",
		ReplacementSize = Vector3.new(0.5, 0.5, 0.5),
		ReplacementRotation = Vector3.new(0, 0, -90),
		WorldSourceMeshIds = {
			"rbxassetid://17835823024",
			"rbxassetid://17835823121",
			"rbxassetid://17835823211"
		},
		WorldReplacementSize = Vector3.new(2, 2, 2),
		WorldReplacementRotation = Vector3.new(0, 90, -90),
		ReplacementVersion = 2
	}
}

local RPG_MESH_SKIN_OVERRIDES = {
	[RPG_CUSTOM_SKIN] = {
		Skin = RPG_CUSTOM_SKIN,
		BodyMeshIds = {
			"rbxassetid://17638908187",
			"rbxassetid://17638908626"
		},
		JuggleMeshIds = {
			"rbxassetid://17638908803",
			"rbxassetid://17638907818"
		},
		RocketMeshIds = {
			"rbxassetid://17638908803",
			"rbxassetid://17638907818"
		},
		BodyReplacementMeshId = RPG_CUSTOM_BODY_REPLACEMENT_MESH_ID,
		BodyReplacementTextureId = RPG_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID,
		ReplacementScale = RPG_CUSTOM_REPLACEMENT_SCALE,
		ReplacementRotation = RPG_CUSTOM_REPLACEMENT_ROTATION,
		ReplacementOffset = RPG_CUSTOM_REPLACEMENT_OFFSET,
		ReplacementVersion = 3
	}
}

local FISTS_MESH_SKIN_OVERRIDES = {
	[FISTS_CUSTOM_SKIN] = {
		Skin = FISTS_CUSTOM_SKIN,
		LeftPartName = "LeftItem",
		RightPartName = "RightItem",
		LeftMeshId = FISTS_CUSTOM_LEFT_MESH_ID,
		LeftTextureId = FISTS_CUSTOM_LEFT_TEXTURE_ID,
		RightMeshId = FISTS_CUSTOM_RIGHT_MESH_ID,
		RightTextureId = FISTS_CUSTOM_RIGHT_TEXTURE_ID,
		MeshScale = FISTS_CUSTOM_MESH_SCALE,
		LeftRotation = FISTS_CUSTOM_LEFT_ROTATION,
		RightRotation = FISTS_CUSTOM_RIGHT_ROTATION,
		ReplacementVersion = 1
	}
}

local BOW_MESH_SKIN_OVERRIDES = {
	[BOW_CUSTOM_SKIN] = {
		Skin = BOW_CUSTOM_SKIN,
		BodyMeshIds = {
			"rbxassetid://116947825701555",
			"rbxassetid://80510746199823"
		},
		ArrowMeshIds = {
			"rbxassetid://108027163190911",
			"rbxassetid://114261802270550"
		},
		BodyReplacementMeshId = BOW_CUSTOM_BODY_REPLACEMENT_MESH_ID,
		BodyReplacementTextureId = BOW_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID,
		ArrowReplacementMeshId = BOW_CUSTOM_ARROW_REPLACEMENT_MESH_ID,
		ArrowReplacementTextureId = BOW_CUSTOM_ARROW_REPLACEMENT_TEXTURE_ID,
		ReplacementSize = BOW_CUSTOM_REPLACEMENT_SIZE,
		ReplacementVersion = 2
	}
}

local ASSAULT_RIFLE_MESH_SKIN_OVERRIDES = {
	[ASSAULT_RIFLE_CUSTOM_SKIN] = {
		Skin = ASSAULT_RIFLE_CUSTOM_SKIN,
		BodyMeshIds = {
			"rbxassetid://17661950733",
			"rbxassetid://17661950585",
			"rbxassetid://17662005180",
			"rbxassetid://17662016762"
		},
		BoltMeshIds = {
			"rbxassetid://17661950452"
		},
		MagazineMeshIds = {
			"rbxassetid://17662005301",
			"rbxassetid://17662005453"
		},
		ReloadMagazineMeshIds = {
			"rbxassetid://17662005453",
			"rbxassetid://17662005301"
		},
		BodyReplacementMeshId = "rbxassetid://138100951261312",
		BodyReplacementTextureId = "rbxassetid://84167100219585",
		MagazineReplacementMeshId = "rbxassetid://92935167277909",
		MagazineReplacementTextureId = "rbxassetid://84167100219585",
		ReloadMagazineReplacementMeshId = "rbxassetid://92935167277909",
		ReloadMagazineReplacementTextureId = "rbxassetid://84167100219585",
		ReplacementSize = Vector3.new(0.35, 0.35, 0.35),
		ReplacementOffset = Vector3.new(0.1, -0.25, 0.04),
		MagazineOffset = Vector3.new(-0.135, -0.2, -0.03),
		ReplacementVersion = 6
	}
}

local TRIPMINE_MESH_SKIN_OVERRIDES = {
	[DICE_TRIPMINE_SKIN] = {
		Skin = DICE_TRIPMINE_SKIN,
		MeshIds = { DICE_TRIPMINE_OUTER_MESH_ID, DICE_TRIPMINE_INNER_MESH_ID },
		RemoveMeshId = TRIPMINE_STAR_REMOVE_MESH_ID,
		Scale = DICE_TRIPMINE_MESH_SCALE,
		WorldScale = DICE_TRIPMINE_WORLD_MESH_SCALE,
		WorldGroundOffset = 0.5,
		ExtraMeshScale = 1.15,
		WorldExtraMeshScale = 1,
		Color = Color3.fromRGB(255, 255, 255),
		Material = Enum.Material.SmoothPlastic,
		Reflectance = 0,
		ClearTexture = true
	},
	[SPIKE_TRIPMINE_SKIN] = {
		Skin = SPIKE_TRIPMINE_SKIN,
		MeshId = SPIKE_TRIPMINE_MESH_ID,
		RemoveMeshId = TRIPMINE_STAR_REMOVE_MESH_ID,
		Scale = SPIKE_TRIPMINE_MESH_SCALE,
		WorldScale = SPIKE_TRIPMINE_WORLD_MESH_SCALE,
		WorldGroundOffset = 0.5,
		Color = Color3.fromRGB(163, 162, 165),
		ClearTexture = true
	}
}

local function normalizeAssetId(assetId)
	return tostring(assetId or ""):match("%d+") or ""
end

local function getTripmineMeshIds(profile)
	local ids = {}
	if type(profile and profile.MeshIds) == "table" then
		for _, meshId in ipairs(profile.MeshIds) do
			if normalizeAssetId(meshId) ~= "" then
				table.insert(ids, meshId)
			end
		end
	elseif profile and normalizeAssetId(profile.MeshId) ~= "" then
		table.insert(ids, profile.MeshId)
	end
	return ids
end

local function getTripmineExtraMeshScale(profile, worldVisual)
	if worldVisual then
		return profile and profile.WorldExtraMeshScale or 1
	end
	return profile and profile.ExtraMeshScale or 1
end

local function getTripmineMeshSignature(profile, worldVisual)
	local normalized = {}
	for _, meshId in ipairs(getTripmineMeshIds(profile)) do
		table.insert(normalized, normalizeAssetId(meshId))
	end
	return table.concat(normalized, ",") .. "|" .. tostring(getTripmineExtraMeshScale(profile, worldVisual))
end

local function scaleTripmineMeshVector(scale, multiplier)
	multiplier = multiplier or 1
	if typeof(scale) == "Vector3" then
		return scale * multiplier
	end
	return Vector3.new(scale, scale, scale) * multiplier
end

local function meshMatchesAssetId(inst, assetId)
	local id = normalizeAssetId(assetId)
	if id == "" or typeof(inst) ~= "Instance" then return false end
	if inst:IsA("SpecialMesh") then
		return normalizeAssetId(inst.MeshId) == id or normalizeAssetId(inst.TextureId) == id
	elseif inst:IsA("MeshPart") then
		return normalizeAssetId(inst.MeshId) == id or normalizeAssetId(inst.TextureID) == id
	end
	return false
end

local function isCustomTripmineMeshIgnored(inst)
	local current = inst
	while current do
		if current:GetAttribute("__LionHiddenTripmineMesh") then
			return true
		end
		local compactName = tostring(current.Name or ""):lower():gsub("[%s_%-%p]", "")
		if compactName:find("arm", 1, true)
			or compactName:find("hand", 1, true)
			or compactName:find("fake", 1, true)
			or compactName:find("charm", 1, true)
			or compactName:find("hitbox", 1, true) then
			return true
		end
		current = current.Parent
	end
	return false
end

local function scoreCustomTripmineMeshTarget(root, meshLike, removedMeshId)
	if removedMeshId and meshMatchesAssetId(meshLike, removedMeshId) then return nil end
	local part = meshLike:IsA("SpecialMesh") and meshLike.Parent or meshLike
	if not (part and part:IsA("BasePart")) or isCustomTripmineMeshIgnored(part) then return nil end
	local score = part.Size.Magnitude
	local name = tostring(part.Name or ""):lower()
	if root:IsA("Model") and part == root.PrimaryPart then score += 1000 end
	if name:find("mesh", 1, true) then score += 500 end
	if name:find("body", 1, true) then score += 250 end
	if name:find("mine", 1, true) or name:find("trip", 1, true) then score += 250 end
	return score
end

local function findCustomTripmineMeshTarget(root, profile)
	if typeof(root) ~= "Instance" then return nil end
	local best, bestScore = nil, -math.huge
	local removedMeshId = profile and (profile.RemoveMeshId or profile.HideMeshId)
	local function consider(obj)
		if obj:IsA("SpecialMesh") or obj:IsA("MeshPart") then
			local score = scoreCustomTripmineMeshTarget(root, obj, removedMeshId)
			if score and score > bestScore then
				best = obj
				bestScore = score
			end
		end
	end
	consider(root)
	for _, descendant in ipairs(root:GetDescendants()) do
		consider(descendant)
	end
	return best
end

local function removeTripmineMeshAsset(root, assetId)
	if typeof(root) ~= "Instance" or not assetId then return end
	local remove = {}
	local function queueIfMatch(obj)
		if meshMatchesAssetId(obj, assetId) then
			local part = obj:IsA("SpecialMesh") and obj.Parent or obj
			if part and part:IsA("BasePart") then
				table.insert(remove, part)
			elseif obj:IsA("SpecialMesh") then
				table.insert(remove, obj)
			end
		end
	end
	queueIfMatch(root)
	for _, obj in ipairs(root:GetDescendants()) do
		queueIfMatch(obj)
	end
	for _, obj in ipairs(remove) do
		if obj and obj.Parent then
			obj:SetAttribute("__LionRemovedTripmineMesh", true)
			obj:Destroy()
		end
	end
end

local function removeCustomTripmineExtraMeshes(root)
	if typeof(root) ~= "Instance" then return end
	for _, obj in ipairs(root:GetDescendants()) do
		if obj:GetAttribute("__LionCustomTripmineExtraMesh") then
			obj:Destroy()
		end
	end
end

local function getMeshLikePart(obj)
	if typeof(obj) ~= "Instance" then return nil end
	if obj:IsA("SpecialMesh") then
		return obj.Parent and obj.Parent:IsA("BasePart") and obj.Parent or nil
	end
	return obj:IsA("BasePart") and obj or nil
end

local function meshMatchesAnyAssetId(inst, assetIds)
	for _, assetId in ipairs(assetIds or {}) do
		if meshMatchesAssetId(inst, assetId) then
			return true
		end
	end
	return false
end

local function rotationCFrameFromDegrees(rotation)
	if typeof(rotation) ~= "Vector3" then return CFrame.identity end
	return CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
end

local function namePathContains(inst, needle)
	needle = tostring(needle or ""):lower()
	if needle == "" then return false end
	local current = inst
	while current and current ~= game do
		if tostring(current.Name or ""):lower():find(needle, 1, true) then
			return true
		end
		current = current.Parent
	end
	return false
end

local function hideDaggerMeshAnchor(part)
	if not (part and part:IsA("BasePart")) then return end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionDaggerHiddenAnchor", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.TextureId = "" end)
		end
	end
end

local function addReplacementSpecialMesh(part, profile, defaultScale)
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = profile.ReplacementMeshId
	pcall(function() mesh.TextureId = profile.ReplacementTextureId or "" end)
	mesh.Scale = profile.ReplacementMeshScale or profile.ReplacementSize or defaultScale or Vector3.new(1, 1, 1)
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = part
	return mesh
end

local function createDaggerReplacementMeshPart(anchor, profile)
	if not (anchor and anchor:IsA("BasePart")) then return false end
	if anchor:GetAttribute("__LionDaggerReplacementMeshPart") then return true end

	local parent = anchor.Parent
	if not parent then return false end
	local originalName = anchor.Name
	anchor.Name = "__LionDaggerAnchor_" .. originalName

	local replacement = Instance.new("Part")
	replacement.Name = originalName
	replacement.Size = Vector3.new(1, 1, 1)
	replacement.CFrame = anchor.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__LionCustomDaggerMesh", true)
	replacement:SetAttribute("__LionDaggerReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)
	addReplacementSpecialMesh(replacement, profile)
	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__LionDaggerReplacementWeld"
	weld.Part0 = anchor
	weld.Part1 = replacement
	weld.Parent = replacement

	hideDaggerMeshAnchor(anchor)
	return true
end

local function applyMeshReplacementToObject(obj, profile)
	if typeof(obj) ~= "Instance" then return false end
	if obj:GetAttribute("__LionDaggerReplacementMeshPart") or obj:GetAttribute("__LionDaggerHiddenAnchor") then
		return false
	end
	local part = getMeshLikePart(obj)
	if obj:IsA("MeshPart") then
		return createDaggerReplacementMeshPart(obj, profile)
	elseif obj:IsA("SpecialMesh") then
		if part then
			part.Transparency = 0
			part.LocalTransparencyModifier = 0
			part.Color = Color3.fromRGB(255, 255, 255)
			pcall(function() part.CastShadow = false end)
			if profile.ReplacementRotation then
				part.CFrame = part.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
			end
		end
		pcall(function() obj.MeshId = profile.ReplacementMeshId end)
		pcall(function() obj.TextureId = profile.ReplacementTextureId or "" end)
		if profile.ReplacementSize then
			pcall(function() obj.Scale = profile.ReplacementSize end)
		end
		obj:SetAttribute("__LionCustomDaggerMesh", true)
		return true
	end
	return false
end

local function getDaggerMeshSignature(profile)
	local size = profile.ReplacementSize or Vector3.zero
	local rotation = profile.ReplacementRotation or Vector3.zero
	return table.concat({
		table.concat(profile.SourceMeshIds or {}, ","),
		tostring(profile.ReplacementMeshId or ""),
		tostring(profile.ReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(rotation.X),
		tostring(rotation.Y),
		tostring(rotation.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyDaggerMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getDaggerMeshSignature(profile)
	if root:GetAttribute("__LionDaggerMeshSkin") == profile.Skin
		and root:GetAttribute("__LionDaggerMeshSignature") == signature then
		return true
	end

	local replaced, seen = 0, {}
	local function replaceIfTarget(obj)
		if seen[obj] or not meshMatchesAnyAssetId(obj, profile.SourceMeshIds) then return end
		seen[obj] = true
		if applyMeshReplacementToObject(obj, profile) then
			replaced += 1
		end
	end

	replaceIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		replaceIfTarget(obj)
	end

	for _, bodyName in ipairs(profile.FallbackBodyNames or {}) do
		for _, obj in ipairs(root:GetDescendants()) do
			if obj.Name == bodyName then
				local target = obj:FindFirstChild("MeshPart")
				if target and not seen[target] and target:IsA("MeshPart") then
					seen[target] = true
					if applyMeshReplacementToObject(target, profile) then
						replaced += 1
					end
				end
			end
		end
	end

	root:SetAttribute("__LionDaggerMeshSkin", profile.Skin)
	root:SetAttribute("__LionDaggerMeshSignature", signature)
	root:SetAttribute("__LionDaggerMeshCount", replaced)
	return replaced > 0
end

local function hideSatchelMeshAnchor(part)
	if not (part and part:IsA("BasePart")) then return end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionSatchelHiddenAnchor", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		end
	end
end

local function getReplacementAverageCFrame(parts)
	local first = parts and parts[1]
	if not first then return CFrame.identity end
	local position = Vector3.zero
	for _, part in ipairs(parts) do
		position += part.Position
	end
	position /= #parts
	return CFrame.new(position) * (first.CFrame - first.CFrame.Position)
end

local function createSatchelReplacementMeshPart(root, profile, anchors)
	local anchor = anchors and anchors[1]
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent
	if not parent then return false end

	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionSatchelReplacementMeshPart") then
			descendant:Destroy()
		end
	end

	local replacement = Instance.new("Part")
	replacement.Name = "__LionCustomSatchelReplacement"
	replacement.Size = Vector3.new(1, 1, 1)
	replacement.CFrame = getReplacementAverageCFrame(anchors)
		* CFrame.new(profile.ReplacementOffset or Vector3.zero)
		* rotationCFrameFromDegrees(profile.ReplacementRotation)
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__LionCustomSatchelMesh", true)
	replacement:SetAttribute("__LionSatchelReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)
	addReplacementSpecialMesh(replacement, profile, Vector3.new(1, 1, 1))
	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__LionSatchelReplacementWeld"
	weld.Part0 = anchor
	weld.Part1 = replacement
	weld.Parent = replacement

	for _, part in ipairs(anchors) do
		if part and part.Parent then
			if not part.Name:find("__LionSatchelAnchor_", 1, true) then
				part.Name = "__LionSatchelAnchor_" .. part.Name
			end
			hideSatchelMeshAnchor(part)
		end
	end
	return true
end

local function applySatchelReplacementToObject(obj, profile)
	if typeof(obj) ~= "Instance" then return false end
	if obj:GetAttribute("__LionSatchelReplacementMeshPart") then return false end
	local part = getMeshLikePart(obj)
	if part and part:GetAttribute("__LionSatchelHiddenAnchor") then return false end
	return part and createSatchelReplacementMeshPart(part.Parent or part, profile, { part }) or false
end

local function getSatchelMeshSignature(profile)
	local rotation = profile.ReplacementRotation or Vector3.zero
	local offset = profile.ReplacementOffset or Vector3.zero
	local size = profile.ReplacementSize or Vector3.zero
	return table.concat({
		table.concat(profile.SourceMeshIds or {}, ","),
		tostring(profile.ReplacementMeshId or ""),
		tostring(profile.ReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(offset.X),
		tostring(offset.Y),
		tostring(offset.Z),
		tostring(rotation.X),
		tostring(rotation.Y),
		tostring(rotation.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applySatchelMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getSatchelMeshSignature(profile)
	if root:GetAttribute("__LionSatchelMeshSkin") == profile.Skin
		and root:GetAttribute("__LionSatchelMeshSignature") == signature then
		return true
	end

	local bodyParts, seenObjects, seenParts = {}, {}, {}
	local function replaceIfTarget(obj)
		if seenObjects[obj] or not meshMatchesAnyAssetId(obj, profile.SourceMeshIds) then return end
		seenObjects[obj] = true
		local part = getMeshLikePart(obj)
		if part and not seenParts[part] then
			seenParts[part] = true
			table.insert(bodyParts, part)
		end
	end

	replaceIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		replaceIfTarget(obj)
	end

	local replaced = createSatchelReplacementMeshPart(root, profile, bodyParts) and 1 or 0

	root:SetAttribute("__LionSatchelMeshSkin", profile.Skin)
	root:SetAttribute("__LionSatchelMeshSignature", signature)
	root:SetAttribute("__LionSatchelMeshCount", replaced)
	return replaced > 0
end

local function getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
	local profile = SATCHEL_MESH_SKIN_OVERRIDES[cosmeticName]
	if profile and worldAsset and (
		profile.WorldSourceMeshIds
		or profile.WorldReplacementMeshId
		or profile.WorldReplacementTextureId
		or profile.WorldReplacementSize
		or profile.WorldReplacementRotation
		or profile.WorldReplacementOffset
	) then
		local worldProfile = table.clone(profile)
		worldProfile.SourceMeshIds = profile.WorldSourceMeshIds or profile.SourceMeshIds
		worldProfile.ReplacementMeshId = profile.WorldReplacementMeshId or profile.ReplacementMeshId
		worldProfile.ReplacementTextureId = profile.WorldReplacementTextureId or profile.ReplacementTextureId
		worldProfile.ReplacementSize = profile.WorldReplacementSize or profile.ReplacementSize
		worldProfile.ReplacementRotation = profile.WorldReplacementRotation or profile.ReplacementRotation
		worldProfile.ReplacementOffset = profile.WorldReplacementOffset or profile.ReplacementOffset
		return worldProfile
	end
	return profile
end

local function hideRpgMeshPart(part)
	if not (part and part:IsA("BasePart")) then return false end
	if part:GetAttribute("__LionRpgHiddenPart") then return true end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionRpgHiddenPart", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	part:SetAttribute("WrapGroup", 0)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

local function applyRpgMeshReplacement(obj, meshId, textureId, profile)
	local part = getMeshLikePart(obj)
	if not part or part:GetAttribute("__LionRpgHiddenPart") then return false end
	part.Transparency = 0
	part.LocalTransparencyModifier = 0
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part:SetAttribute("__LionCustomRpgMesh", true)
	part:SetAttribute("IgnoreTransparency", true)
	if not part:GetAttribute("__LionRpgReplacementAdjusted") then
		local scale = tonumber(profile and profile.ReplacementScale) or 1
		if scale ~= 1 then
			pcall(function()
				part.Size = part.Size * scale
			end)
		end
		if profile and profile.ReplacementOffset then
			pcall(function()
				part.CFrame = part.CFrame * CFrame.new(profile.ReplacementOffset)
			end)
		end
		if profile and profile.ReplacementRotation then
			pcall(function()
				part.CFrame = part.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
			end)
		end
		part:SetAttribute("__LionRpgReplacementAdjusted", true)
	end
	if obj:IsA("MeshPart") then
		pcall(function() obj.MeshId = meshId end)
		pcall(function() obj.TextureID = textureId or "" end)
		return true
	elseif obj:IsA("SpecialMesh") then
		pcall(function() obj.MeshType = Enum.MeshType.FileMesh end)
		pcall(function() obj.MeshId = meshId end)
		pcall(function() obj.TextureId = textureId or "" end)
		pcall(function() obj.VertexColor = Vector3.new(1, 1, 1) end)
		return true
	end
	return false
end

local function getRpgMeshSignature(profile)
	local rotation = profile.ReplacementRotation or Vector3.zero
	local offset = profile.ReplacementOffset or Vector3.zero
	return table.concat({
		table.concat(profile.BodyMeshIds or {}, ","),
		table.concat(profile.JuggleMeshIds or {}, ","),
		table.concat(profile.RocketMeshIds or {}, ","),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.ReplacementScale or 1),
		tostring(rotation.X),
		tostring(rotation.Y),
		tostring(rotation.Z),
		tostring(offset.X),
		tostring(offset.Y),
		tostring(offset.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyRpgMeshProfile(root, profile, options)
	if typeof(root) ~= "Instance" or not profile then return false end
	options = options or {}
	local signature = getRpgMeshSignature(profile)
	if root:GetAttribute("__LionRpgMeshSkin") == profile.Skin
		and root:GetAttribute("__LionRpgMeshSignature") == signature
		and root:GetAttribute("__LionRpgRocketVisible") == false then
		return true
	end

	local changed, removed, seen = 0, 0, {}
	local function applyIfTarget(obj)
		if seen[obj] then return end
		if not (meshMatchesAnyAssetId(obj, profile.BodyMeshIds)
			or meshMatchesAnyAssetId(obj, profile.JuggleMeshIds)
			or meshMatchesAnyAssetId(obj, profile.RocketMeshIds)) then
			return
		end
		seen[obj] = true
		local part = getMeshLikePart(obj)
		if not part then return end
		if (namePathContains(obj, "rocket") and meshMatchesAnyAssetId(obj, profile.RocketMeshIds))
			or (namePathContains(obj, "juggle") and meshMatchesAnyAssetId(obj, profile.JuggleMeshIds)) then
			if hideRpgMeshPart(part) then removed += 1 end
		elseif meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			if applyRpgMeshReplacement(obj, profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, profile) then
				changed += 1
			end
		end
	end

	applyIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		applyIfTarget(obj)
	end

	root:SetAttribute("__LionRpgMeshSkin", profile.Skin)
	root:SetAttribute("__LionRpgMeshSignature", signature)
	root:SetAttribute("__LionRpgRocketVisible", false)
	root:SetAttribute("__LionRpgMeshCount", changed)
	root:SetAttribute("__LionRpgHiddenCount", removed)
	return changed > 0 or removed > 0
end

local function createFistsReplacementPart(part, meshId, textureId, meshScale, rotation)
	if not (part and part:IsA("BasePart")) then return false end
	for _, child in ipairs(part:GetChildren()) do
		child:Destroy()
	end

	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part:SetAttribute("__LionFistsHiddenAnchor", true)
	part:SetAttribute("IgnoreTransparency", true)

	local replacement = Instance.new("Part")
	replacement.Name = "__LionCustomFistsMesh"
	replacement.Size = part.Size
	replacement.CFrame = part.CFrame * rotationCFrameFromDegrees(rotation)
	replacement.Anchored = false
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement:SetAttribute("__LionCustomFistsMesh", true)
	replacement:SetAttribute("IgnoreTransparency", true)
	replacement.Parent = part

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = meshId
	pcall(function() mesh.TextureId = textureId or "" end)
	mesh.Scale = meshScale or Vector3.new(0.1, 0.1, 0.1)
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = replacement

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__LionCustomFistsMeshWeld"
	weld.Part0 = part
	weld.Part1 = replacement
	weld.Parent = replacement
	return true
end

local function getFistsMeshSignature(profile)
	local scale = profile.MeshScale or Vector3.zero
	local leftRotation = profile.LeftRotation or Vector3.zero
	local rightRotation = profile.RightRotation or Vector3.zero
	return table.concat({
		tostring(profile.LeftMeshId or ""),
		tostring(profile.LeftTextureId or ""),
		tostring(profile.RightMeshId or ""),
		tostring(profile.RightTextureId or ""),
		tostring(scale.X),
		tostring(scale.Y),
		tostring(scale.Z),
		tostring(leftRotation.X),
		tostring(leftRotation.Y),
		tostring(leftRotation.Z),
		tostring(rightRotation.X),
		tostring(rightRotation.Y),
		tostring(rightRotation.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyFistsMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getFistsMeshSignature(profile)
	if root:GetAttribute("__LionFistsMeshSkin") == profile.Skin
		and root:GetAttribute("__LionFistsMeshSignature") == signature
		and (root:GetAttribute("__LionFistsMeshCount") or 0) > 0 then
		return true
	end

	local left = findDescendantByName(root, profile.LeftPartName or "LeftItem")
	local right = findDescendantByName(root, profile.RightPartName or "RightItem")
	local applied = 0
	if createFistsReplacementPart(left, profile.LeftMeshId, profile.LeftTextureId, profile.MeshScale, profile.LeftRotation) then
		applied += 1
	end
	if createFistsReplacementPart(right, profile.RightMeshId, profile.RightTextureId, profile.MeshScale, profile.RightRotation) then
		applied += 1
	end

	root:SetAttribute("__LionFistsMeshSkin", profile.Skin)
	root:SetAttribute("__LionFistsMeshSignature", signature)
	root:SetAttribute("__LionFistsMeshCount", applied)
	return applied > 0
end

local function hideBowMeshAnchor(part)
	if not (part and part:IsA("BasePart")) then return false end
	if part:GetAttribute("__LionBowHiddenAnchor") then return true end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionBowHiddenAnchor", true)
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

local function createBowReplacementMeshPart(root, anchors, replacementName, meshId, textureId, profile)
	local anchor = anchors and anchors[1]
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent or root
	if not parent then return false end

	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionBowReplacementMeshPart") and descendant.Name == replacementName then
			descendant:Destroy()
		end
	end

	local replacement = Instance.new("Part")
	replacement.Name = replacementName
	replacement.Size = Vector3.new(1, 1, 1)
	replacement.CFrame = getReplacementAverageCFrame(anchors)
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement:SetAttribute("__LionCustomBowMesh", true)
	replacement:SetAttribute("__LionBowReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = meshId
	pcall(function() mesh.TextureId = textureId or "" end)
	mesh.Scale = profile.ReplacementSize or Vector3.new(0.5, 0.5, 0.5)
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = replacement

	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	if not replacement.Anchored then
		local weld = Instance.new("WeldConstraint")
		weld.Name = "__LionBowReplacementWeld"
		weld.Part0 = anchor
		weld.Part1 = replacement
		weld.Parent = replacement
	end

	for _, part in ipairs(anchors) do
		hideBowMeshAnchor(part)
	end
	return true
end

local function getBowMeshSignature(profile)
	local size = profile.ReplacementSize or Vector3.zero
	return table.concat({
		table.concat(profile.BodyMeshIds or {}, ","),
		table.concat(profile.ArrowMeshIds or {}, ","),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.ArrowReplacementMeshId or ""),
		tostring(profile.ArrowReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyBowMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getBowMeshSignature(profile)
	if root:GetAttribute("__LionBowMeshSkin") == profile.Skin
		and root:GetAttribute("__LionBowMeshSignature") == signature
		and (root:GetAttribute("__LionBowMeshCount") or 0) > 0 then
		return true
	end

	local bodyParts, arrowParts, seenParts = {}, {}, {}
	local function collectIfTarget(obj)
		local part = getMeshLikePart(obj)
		if not part or seenParts[part] then return end
		if meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			seenParts[part] = true
			table.insert(bodyParts, part)
		elseif meshMatchesAnyAssetId(obj, profile.ArrowMeshIds) then
			seenParts[part] = true
			table.insert(arrowParts, part)
		end
	end

	collectIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		collectIfTarget(obj)
	end

	local applied = 0
	if createBowReplacementMeshPart(root, bodyParts, "__LionCustomBowBody", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, profile) then
		applied += 1
	end
	if createBowReplacementMeshPart(root, arrowParts, "__LionCustomBowArrow", profile.ArrowReplacementMeshId, profile.ArrowReplacementTextureId, profile) then
		applied += 1
	end

	root:SetAttribute("__LionBowMeshSkin", profile.Skin)
	root:SetAttribute("__LionBowMeshSignature", signature)
	root:SetAttribute("__LionBowMeshCount", applied)
	return applied > 0
end

local function hideAssaultRifleMeshAnchor(part, anchorType)
	if not (part and part:IsA("BasePart")) then return false end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionAssaultRifleHiddenAnchor", true)
	part:SetAttribute("__LionAssaultRifleAnchorType", anchorType or "Part")
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

local function createAssaultRifleReplacementMeshPart(root, anchor, replacementName, meshId, textureId, cframe, profile)
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent or root
	if not parent then return false end

	local replacement = Instance.new("MeshPart")
	replacement.Name = replacementName
	replacement.Size = profile.ReplacementSize or Vector3.new(0.35, 0.35, 0.35)
	replacement.CFrame = cframe or anchor.CFrame
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.MeshId = meshId end)
	pcall(function() replacement.TextureID = textureId or "" end)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__LionCustomAssaultRifleMesh", true)
	replacement:SetAttribute("__LionAssaultRifleReplacementMeshPart", true)
	replacement:SetAttribute("IgnoreTransparency", true)

	local wrapGroup = anchor:GetAttribute("WrapGroup")
	if wrapGroup ~= nil then
		replacement:SetAttribute("WrapGroup", wrapGroup)
	end
	pcall(function()
		if collectionService:HasTag(anchor, "Wrappable") then
			collectionService:AddTag(replacement, "Wrappable")
		end
	end)
	replacement.Parent = parent

	if not replacement.Anchored then
		local weld = Instance.new("WeldConstraint")
		weld.Name = "__LionAssaultRifleReplacementWeld"
		weld.Part0 = anchor
		weld.Part1 = replacement
		weld.Parent = replacement
	end

	return true
end

local function getAssaultRifleMeshSignature(profile)
	local size = profile.ReplacementSize or Vector3.zero
	local replacementOffset = profile.ReplacementOffset or Vector3.zero
	local magazineOffset = profile.MagazineOffset or Vector3.zero
	return table.concat({
		table.concat(profile.BodyMeshIds or {}, ","),
		table.concat(profile.BoltMeshIds or {}, ","),
		table.concat(profile.MagazineMeshIds or {}, ","),
		table.concat(profile.ReloadMagazineMeshIds or {}, ","),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.MagazineReplacementMeshId or ""),
		tostring(profile.MagazineReplacementTextureId or ""),
		tostring(profile.ReloadMagazineReplacementMeshId or ""),
		tostring(profile.ReloadMagazineReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(replacementOffset.X),
		tostring(replacementOffset.Y),
		tostring(replacementOffset.Z),
		tostring(magazineOffset.X),
		tostring(magazineOffset.Y),
		tostring(magazineOffset.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

local function applyAssaultRifleMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getAssaultRifleMeshSignature(profile)
	if root:GetAttribute("__LionAssaultRifleMeshSkin") == profile.Skin
		and root:GetAttribute("__LionAssaultRifleMeshSignature") == signature
		and (root:GetAttribute("__LionAssaultRifleMeshCount") or 0) > 0 then
		return true
	end

	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionAssaultRifleReplacementMeshPart") then
			descendant:Destroy()
		end
	end

	local bodyParts, magazineParts, reloadMagazineParts, boltParts, seenParts = {}, {}, {}, {}, {}
	local function collectIfTarget(obj)
		local part = getMeshLikePart(obj)
		if not part or seenParts[part] then return end
		local previousType = part:GetAttribute("__LionAssaultRifleAnchorType")
		local isReloadMagazine = previousType == "ReloadMagazine"
			or (meshMatchesAnyAssetId(obj, profile.ReloadMagazineMeshIds) and namePathContains(obj, "reload"))
		if previousType == "Body" or meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			seenParts[part] = true
			table.insert(bodyParts, part)
		elseif isReloadMagazine then
			seenParts[part] = true
			table.insert(reloadMagazineParts, part)
		elseif previousType == "Magazine" or meshMatchesAnyAssetId(obj, profile.MagazineMeshIds) or meshMatchesAnyAssetId(obj, profile.ReloadMagazineMeshIds) then
			seenParts[part] = true
			table.insert(magazineParts, part)
		elseif previousType == "Bolt" or meshMatchesAnyAssetId(obj, profile.BoltMeshIds) then
			seenParts[part] = true
			table.insert(boltParts, part)
		end
	end

	collectIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		collectIfTarget(obj)
	end

	local bodyAnchor = bodyParts[1] or magazineParts[1] or boltParts[1]
	local magazineAnchor = magazineParts[1] or bodyAnchor
	local reloadMagazineAnchor = reloadMagazineParts[1] or magazineAnchor
	local bodyCFrame = bodyParts[1] and getReplacementAverageCFrame(bodyParts) or (bodyAnchor and bodyAnchor.CFrame) or CFrame.identity
	local reloadMagazineCFrame = reloadMagazineParts[1] and getReplacementAverageCFrame(reloadMagazineParts) or bodyCFrame
	local replacementOffset = profile.ReplacementOffset or Vector3.zero
	local magazineOffset = profile.MagazineOffset or Vector3.zero
	bodyCFrame = bodyCFrame * CFrame.new(replacementOffset)
	reloadMagazineCFrame = reloadMagazineCFrame * CFrame.new(replacementOffset)
	local applied = 0
	if createAssaultRifleReplacementMeshPart(root, bodyAnchor, "__LionCustomAssaultRifleBody", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, bodyCFrame, profile) then
		applied += 1
	end
	if createAssaultRifleReplacementMeshPart(root, magazineAnchor, "__LionCustomAssaultRifleMagazine", profile.MagazineReplacementMeshId, profile.MagazineReplacementTextureId, bodyCFrame * CFrame.new(magazineOffset), profile) then
		applied += 1
	end
	if reloadMagazineParts[1] and createAssaultRifleReplacementMeshPart(root, reloadMagazineAnchor, "__LionCustomAssaultRifleReloadMagazine", profile.ReloadMagazineReplacementMeshId or profile.MagazineReplacementMeshId, profile.ReloadMagazineReplacementTextureId or profile.MagazineReplacementTextureId, reloadMagazineCFrame, profile) then
		applied += 1
	end

	for _, part in ipairs(bodyParts) do
		hideAssaultRifleMeshAnchor(part, "Body")
	end
	for _, part in ipairs(magazineParts) do
		hideAssaultRifleMeshAnchor(part, "Magazine")
	end
	for _, part in ipairs(reloadMagazineParts) do
		hideAssaultRifleMeshAnchor(part, "ReloadMagazine")
	end
	for _, part in ipairs(boltParts) do
		hideAssaultRifleMeshAnchor(part, "Bolt")
	end

	root:SetAttribute("__LionAssaultRifleMeshSkin", profile.Skin)
	root:SetAttribute("__LionAssaultRifleMeshSignature", signature)
	root:SetAttribute("__LionAssaultRifleMeshCount", applied)
	return applied > 0
end

function __LionHideSniperMeshAnchor(part, anchorType)
	if not (part and part:IsA("BasePart")) then return false end
	part.Transparency = 1
	part.LocalTransparencyModifier = 1
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	pcall(function() part.CastShadow = false end)
	pcall(function() part.Material = Enum.Material.SmoothPlastic end)
	pcall(function() part.Reflectance = 0 end)
	pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
	part:SetAttribute("__LionHiddenSniperMesh", true)
	part:SetAttribute("__LionCustomSniperHiddenPart", true)
	part:SetAttribute("__LionSniperAnchorType", anchorType or "Part")
	part:SetAttribute("IgnoreObject", true)
	part:SetAttribute("IgnoreTransparency", true)
	part:SetAttribute("WrapGroup", 0)
	pcall(function() part:RemoveTag("Wrappable") end)
	pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.MeshId = "" end)
	end
	for _, child in ipairs(part:GetDescendants()) do
		if child:IsA("Decal") or child:IsA("Texture") then
			child.Transparency = 1
		elseif child:IsA("SurfaceAppearance") then
			child:Destroy()
		elseif child:IsA("SpecialMesh") then
			child.Scale = Vector3.zero
			pcall(function() child.MeshId = "" end)
			pcall(function() child.TextureId = "" end)
		elseif child:IsA("Highlight") then
			child.Enabled = false
		end
	end
	return true
end

function __LionOffsetSniperVisibleAnchor(part, anchorType, offset)
	if not (part and part:IsA("BasePart")) then return false end
	local originalCFrame = part:GetAttribute("__LionSniperOriginalCFrame")
	if typeof(originalCFrame) ~= "CFrame" then
		originalCFrame = part.CFrame
		part:SetAttribute("__LionSniperOriginalCFrame", originalCFrame)
	end
	part.CFrame = originalCFrame * CFrame.new(offset or Vector3.zero)
	part:SetAttribute("__LionSniperAnchorType", anchorType or "Part")
	part:SetAttribute("__LionSniperVisibleOffset", true)
	return true
end

local function hideSniperMeshId(root, assetId)
	local parts = {}
	if typeof(root) ~= "Instance" or not assetId then return parts end
	local seen = {}

	local function hideIfMatch(obj)
		if not meshMatchesAssetId(obj, assetId) then return end
		local part = getMeshLikePart(obj)
		if part and not seen[part] then
			seen[part] = true
			if __LionHideSniperMeshAnchor(part) then
				table.insert(parts, part)
			end
		elseif obj:IsA("SpecialMesh") then
			obj.Scale = Vector3.zero
		end
	end

	hideIfMatch(root)
	for _, obj in ipairs(root:GetDescendants()) do
		hideIfMatch(obj)
	end
	return parts
end

local function getAverageCFrame(parts)
	local first = parts[1]
	if not first then return CFrame.identity end
	local position = Vector3.zero
	for _, part in ipairs(parts) do
		position += part.Position
	end
	position /= #parts
	return CFrame.new(position) * (first.CFrame - first.CFrame.Position)
end

function __LionCreateSniperReplacementMeshPart(root, anchor, replacementName, meshId, textureId, cframe, profile)
	if not (anchor and anchor:IsA("BasePart")) then return false end
	local parent = anchor.Parent or root
	if not parent then return false end

	local replacement = Instance.new("MeshPart")
	replacement.Name = replacementName
	pcall(function() replacement.MeshId = meshId end)
	pcall(function() replacement.TextureID = textureId or "" end)
	replacement.Size = profile.ReplacementSize or Vector3.new(0.05, 0.05, 0.05)
	replacement.CFrame = cframe or anchor.CFrame
	replacement.Anchored = anchor.Anchored
	replacement.CanCollide = false
	replacement.CanTouch = false
	replacement.CanQuery = false
	replacement.Massless = true
	replacement.Transparency = 0
	replacement.LocalTransparencyModifier = 0
	replacement.Color = Color3.fromRGB(255, 255, 255)
	pcall(function() replacement.Material = anchor.Material end)
	pcall(function() replacement.CastShadow = false end)
	replacement:SetAttribute("__LionCustomSniperReplacement", true)
	replacement:SetAttribute("WrapGroup", 1)
	replacement:SetAttribute("IgnoreTransparency", true)
	pcall(function() replacement:AddTag("Wrappable") end)
	pcall(function() collectionService:AddTag(replacement, "Wrappable") end)
	replacement.Parent = parent

	if not replacement.Anchored then
		local weld = Instance.new("WeldConstraint")
		weld.Name = "__LionCustomSniperReplacementWeld"
		weld.Part0 = anchor
		weld.Part1 = replacement
		weld.Parent = replacement
	end
	return true
end

local function setupSniperReplacementPart(root, profile, bodyParts)
	local anchor = bodyParts[1]
	if not anchor then return false end
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionCustomSniperReplacement") then
			descendant:Destroy()
		end
	end

	return __LionCreateSniperReplacementMeshPart(
		root,
		anchor,
		"__LionCustomSniperReplacement",
		profile.ReplacementMeshId,
		profile.ReplacementTextureId,
		getAverageCFrame(bodyParts) * CFrame.new(profile.ReplacementOffset or Vector3.zero),
		profile
	)
end

local function getSniperMeshSignature(profile)
	local body = table.concat(profile.BodyMeshIds or {}, ",")
	local remove = table.concat(profile.RemoveMeshIds or {}, ",")
	local magazine = table.concat(profile.MagazineMeshIds or {}, ",")
	local bullet = table.concat(profile.BulletMeshIds or {}, ",")
	local size = profile.ReplacementSize or Vector3.zero
	local offset = profile.ReplacementOffset or Vector3.zero
	local bulletOffset = profile.BulletOffset or Vector3.zero
	return table.concat({
		body,
		remove,
		magazine,
		bullet,
		tostring(profile.ReplacementMeshId or ""),
		tostring(profile.ReplacementTextureId or ""),
		tostring(profile.BodyReplacementMeshId or ""),
		tostring(profile.BodyReplacementTextureId or ""),
		tostring(profile.ScopeReplacementMeshId or ""),
		tostring(profile.ScopeReplacementTextureId or ""),
		tostring(profile.MagazineReplacementMeshId or ""),
		tostring(profile.MagazineReplacementTextureId or ""),
		tostring(size.X),
		tostring(size.Y),
		tostring(size.Z),
		tostring(offset.X),
		tostring(offset.Y),
		tostring(offset.Z),
		tostring((profile.ScopeOffset or Vector3.zero).X),
		tostring((profile.ScopeOffset or Vector3.zero).Y),
		tostring((profile.ScopeOffset or Vector3.zero).Z),
		tostring((profile.MagazineOffset or Vector3.zero).X),
		tostring((profile.MagazineOffset or Vector3.zero).Y),
		tostring((profile.MagazineOffset or Vector3.zero).Z),
		tostring(bulletOffset.X),
		tostring(bulletOffset.Y),
		tostring(bulletOffset.Z),
		tostring(profile.ReplacementVersion or 1)
	}, "|")
end

function __LionApplySniperMultiMeshProfile(root, profile)
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:GetAttribute("__LionCustomSniperReplacement") then
			descendant:Destroy()
		end
	end

	local bodyParts, magazineParts, bulletParts, removeParts, seenParts = {}, {}, {}, {}, {}
	local function collectIfTarget(obj)
		local part = getMeshLikePart(obj)
		if not part or seenParts[part] then return end
		local previousType = part:GetAttribute("__LionSniperAnchorType")
		if previousType == "Body" or meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
			seenParts[part] = true
			table.insert(bodyParts, part)
		elseif previousType == "Magazine" or meshMatchesAnyAssetId(obj, profile.MagazineMeshIds) then
			seenParts[part] = true
			table.insert(magazineParts, part)
		elseif previousType == "Bullet" or meshMatchesAnyAssetId(obj, profile.BulletMeshIds) then
			seenParts[part] = true
			table.insert(bulletParts, part)
		elseif previousType == "Remove" or meshMatchesAnyAssetId(obj, profile.RemoveMeshIds) then
			seenParts[part] = true
			table.insert(removeParts, part)
		end
	end

	collectIfTarget(root)
	for _, obj in ipairs(root:GetDescendants()) do
		collectIfTarget(obj)
	end

	local bodyAnchor = bodyParts[1] or magazineParts[1]
	local magazineAnchor = magazineParts[1] or bodyAnchor
	if not bodyAnchor then return false end

	local offset = profile.ReplacementOffset or Vector3.zero
	local bodyCFrame = (bodyParts[1] and getReplacementAverageCFrame(bodyParts) or bodyAnchor.CFrame) * CFrame.new(offset)
	local scopeCFrame = bodyCFrame * CFrame.new(profile.ScopeOffset or Vector3.zero)
	local magazineCFrame = bodyCFrame * CFrame.new(profile.MagazineOffset or Vector3.zero)
	local applied = 0
	if __LionCreateSniperReplacementMeshPart(root, bodyAnchor, "__LionCustomSniperReplacement", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, bodyCFrame, profile) then
		applied += 1
	end
	if __LionCreateSniperReplacementMeshPart(root, bodyAnchor, "__LionCustomSniperScope", profile.ScopeReplacementMeshId, profile.ScopeReplacementTextureId, scopeCFrame, profile) then
		applied += 1
	end
	if __LionCreateSniperReplacementMeshPart(root, magazineAnchor, "__LionCustomSniperMagazine", profile.MagazineReplacementMeshId, profile.MagazineReplacementTextureId, magazineCFrame, profile) then
		applied += 1
	end

	for _, part in ipairs(bodyParts) do
		__LionHideSniperMeshAnchor(part, "Body")
	end
	for _, part in ipairs(magazineParts) do
		__LionHideSniperMeshAnchor(part, "Magazine")
	end
	for _, part in ipairs(bulletParts) do
		__LionOffsetSniperVisibleAnchor(part, "Bullet", profile.BulletOffset or Vector3.zero)
	end
	for _, part in ipairs(removeParts) do
		__LionHideSniperMeshAnchor(part, "Remove")
	end
	return applied > 0
end

local function applySniperMeshProfile(root, profile)
	if typeof(root) ~= "Instance" or not profile then return false end
	local signature = getSniperMeshSignature(profile)
	if root:GetAttribute("__LionSniperMeshSkin") == profile.Skin
		and root:GetAttribute("__LionSniperMeshSignature") == signature then
		return true
	end

	local applied
	if profile.BodyReplacementMeshId or profile.ScopeReplacementMeshId or profile.MagazineReplacementMeshId then
		applied = __LionApplySniperMultiMeshProfile(root, profile)
		if not applied then return false end
		root:SetAttribute("__LionSniperMeshSkin", profile.Skin)
		root:SetAttribute("__LionSniperMeshSignature", signature)
		return true
	end

	local bodyParts = {}
	for _, meshId in ipairs(profile.BodyMeshIds or {}) do
		for _, part in ipairs(hideSniperMeshId(root, meshId)) do
			table.insert(bodyParts, part)
		end
	end
	for _, meshId in ipairs(profile.RemoveMeshIds or {}) do
		hideSniperMeshId(root, meshId)
	end

	if not setupSniperReplacementPart(root, profile, bodyParts) then
		return false
	end
	root:SetAttribute("__LionSniperMeshSkin", profile.Skin)
	root:SetAttribute("__LionSniperMeshSignature", signature)
	return true
end

local function applyTripminePartVisual(part, profile)
	if not (part and part:IsA("BasePart")) then return end
	local color = profile.Color
	if color then
		part.Color = color
		part.BrickColor = BrickColor.new(color)
	end
	part.Material = profile.Material or Enum.Material.SmoothPlastic
	if profile.Reflectance then
		part.Reflectance = profile.Reflectance
	end
	part.Transparency = 0
	part.LocalTransparencyModifier = 0
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	if part:GetAttribute("WrapGroup") == nil then
		part:SetAttribute("WrapGroup", 1)
	end
	part:SetAttribute("IgnoreTransparency", true)
	pcall(function() part:AddTag("Wrappable") end)
	pcall(function() collectionService:AddTag(part, "Wrappable") end)
end

local function addTripmineExtraMeshPart(basePart, meshId, meshScale, profile, index)
	if not (basePart and basePart:IsA("BasePart") and basePart.Parent) then return nil end
	local overlay = Instance.new("Part")
	overlay.Name = "__LionCustomTripmineMeshExtra" .. tostring(index or "")
	overlay.Anchored = basePart.Anchored
	overlay.CFrame = basePart.CFrame
	overlay.Size = basePart.Size
	overlay:SetAttribute("__LionCustomTripmineMeshPart", true)
	overlay:SetAttribute("__LionCustomTripmineExtraMesh", true)
	applyTripminePartVisual(overlay, profile)

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = meshId
	if profile.ClearTexture then
		pcall(function() mesh.TextureId = "" end)
	elseif profile.TextureId then
		pcall(function() mesh.TextureId = profile.TextureId end)
	end
	mesh.Scale = meshScale
	pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
	mesh.Parent = overlay
	overlay.Parent = basePart.Parent

	local weld = Instance.new("WeldConstraint")
	weld.Name = "__LionCustomTripmineMeshExtraWeld"
	weld.Part0 = basePart
	weld.Part1 = overlay
	weld.Parent = overlay
	return overlay
end

local function applyTripmineMeshProfile(root, profile, worldVisual)
	if typeof(root) ~= "Instance" then return false end
	if not profile then return false end
	local meshIds = getTripmineMeshIds(profile)
	if #meshIds == 0 then return false end
	local extraMeshScale = getTripmineExtraMeshScale(profile, worldVisual)
	local meshSignature = getTripmineMeshSignature(profile, worldVisual)
	local meshScale = (worldVisual and profile.WorldScale) or profile.Scale or 1
	if root:GetAttribute("__LionTripmineMeshSkin") == profile.Skin
		and root:GetAttribute("__LionCustomTripmineMeshIds") == meshSignature
		and root:GetAttribute("__LionCustomTripmineMeshScale") == meshScale then
		return true
	end
	removeCustomTripmineExtraMeshes(root)
	removeTripmineMeshAsset(root, profile.RemoveMeshId or profile.HideMeshId)
	local target = findCustomTripmineMeshTarget(root, profile)
	if not target then return false end
	local customPart

	if target:IsA("SpecialMesh") then
		pcall(function() target.MeshType = Enum.MeshType.FileMesh end)
		target.MeshId = meshIds[1]
		if profile.TextureId then
			pcall(function() target.TextureId = profile.TextureId end)
		elseif profile.ClearTexture then
			pcall(function() target.TextureId = "" end)
		end
		target.Scale = target.Scale * meshScale
		pcall(function() target.VertexColor = Vector3.new(1, 1, 1) end)
		customPart = target.Parent
		applyTripminePartVisual(customPart, profile)
		for index = 2, #meshIds do
			addTripmineExtraMeshPart(customPart, meshIds[index], scaleTripmineMeshVector(target.Scale, extraMeshScale), profile, index)
		end
	elseif target:IsA("MeshPart") then
		local originalSize = target.Size
		local okMesh = pcall(function()
			target.MeshId = meshIds[1]
		end)
		if profile.TextureId then
			pcall(function() target.TextureID = profile.TextureId end)
		elseif profile.ClearTexture then
			pcall(function() target.TextureID = "" end)
		end
		applyTripminePartVisual(target, profile)
		if okMesh then
			pcall(function()
				target.Size = originalSize * meshScale
			end)
			customPart = target
			for index = 2, #meshIds do
				addTripmineExtraMeshPart(target, meshIds[index], scaleTripmineMeshVector(Vector3.new(1, 1, 1), extraMeshScale), profile, index)
			end
		elseif target.Parent then
			pcall(function()
				target.Transparency = 1
				target.LocalTransparencyModifier = 1
			end)
			local overlay = target.Parent:FindFirstChild("__LionCustomTripmineMesh")
			if not (overlay and overlay:IsA("BasePart")) then
				overlay = Instance.new("Part")
				overlay.Name = "__LionCustomTripmineMesh"
				overlay.Anchored = target.Anchored
				overlay.CanCollide = false
				overlay.CanTouch = false
				overlay.CanQuery = false
				overlay.Massless = true
				overlay.Parent = target.Parent
			end
			overlay.Size = originalSize
			overlay.CFrame = target.CFrame
			applyTripminePartVisual(overlay, profile)
			local mesh = overlay:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh")
			mesh.MeshType = Enum.MeshType.FileMesh
			mesh.MeshId = meshIds[1]
			if profile.TextureId then
				pcall(function() mesh.TextureId = profile.TextureId end)
			elseif profile.ClearTexture then
				pcall(function() mesh.TextureId = "" end)
			end
			mesh.Scale = Vector3.new(meshScale, meshScale, meshScale)
			pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
			mesh.Parent = overlay
			overlay:SetAttribute("__LionCustomTripmineMeshPart", true)
			customPart = overlay
			for index = 2, #meshIds do
				addTripmineExtraMeshPart(overlay, meshIds[index], scaleTripmineMeshVector(meshScale, extraMeshScale), profile, index)
			end
			if not overlay:FindFirstChild("__LionCustomTripmineMeshWeld") then
				local weld = Instance.new("WeldConstraint")
				weld.Name = "__LionCustomTripmineMeshWeld"
				weld.Part0 = target
				weld.Part1 = overlay
				weld.Parent = overlay
			end
		end
	end

	if customPart and customPart:IsA("BasePart") then
		customPart:SetAttribute("__LionCustomTripmineMeshPart", true)
	end
	root:SetAttribute("__LionTripmineMeshSkin", profile.Skin)
	root:SetAttribute("__LionCustomTripmineMeshId", meshIds[1])
	root:SetAttribute("__LionCustomTripmineMeshIds", meshSignature)
	root:SetAttribute("__LionCustomTripmineMeshScale", meshScale)
	return true
end

local function applyVirtualViewModelAssetOverrides(cosmeticName, asset, worldAsset)
	local profile = TRIPMINE_MESH_SKIN_OVERRIDES[cosmeticName]
	if profile then
		applyTripmineMeshProfile(asset, profile)
	end
	local daggerProfile = DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName]
	if daggerProfile then
		applyDaggerMeshProfile(asset, daggerProfile)
	end
	local satchelProfile = getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
	if satchelProfile then
		applySatchelMeshProfile(asset, satchelProfile)
	end
	local rpgProfile = RPG_MESH_SKIN_OVERRIDES[cosmeticName]
	if rpgProfile then
		applyRpgMeshProfile(asset, rpgProfile)
	end
	local fistsProfile = FISTS_MESH_SKIN_OVERRIDES[cosmeticName]
	if fistsProfile then
		applyFistsMeshProfile(asset, fistsProfile)
	end
	local bowProfile = BOW_MESH_SKIN_OVERRIDES[cosmeticName]
	if bowProfile then
		applyBowMeshProfile(asset, bowProfile)
	end
	local assaultRifleProfile = ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName]
	if assaultRifleProfile then
		applyAssaultRifleMeshProfile(asset, assaultRifleProfile)
	end
	local sniperProfile = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName]
	if sniperProfile then
		applySniperMeshProfile(asset, sniperProfile)
	end
end

local function shouldRebuildVirtualViewModelAsset(cosmeticName, asset, worldAsset)
	local profile = TRIPMINE_MESH_SKIN_OVERRIDES[cosmeticName]
	if profile then
		local meshIds = getTripmineMeshIds(profile)
		return not asset
			or asset:GetAttribute("__LionTripmineMeshSkin") ~= profile.Skin
			or asset:GetAttribute("__LionCustomTripmineMeshIds") ~= getTripmineMeshSignature(profile)
			or asset:GetAttribute("__LionCustomTripmineMeshScale") ~= (profile.Scale or 1)
			or asset:GetAttribute("__LionCustomTripmineMeshId") ~= meshIds[1]
	end
	local sniperProfile = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName]
	if sniperProfile then
		return not asset
			or asset:GetAttribute("__LionSniperMeshSkin") ~= sniperProfile.Skin
			or asset:GetAttribute("__LionSniperMeshSignature") ~= getSniperMeshSignature(sniperProfile)
			or not asset:FindFirstChild("__LionCustomSniperReplacement", true)
	end
	local daggerProfile = DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName]
	if daggerProfile then
		return not asset
			or asset:GetAttribute("__LionDaggerMeshSkin") ~= daggerProfile.Skin
			or asset:GetAttribute("__LionDaggerMeshSignature") ~= getDaggerMeshSignature(daggerProfile)
			or (asset:GetAttribute("__LionDaggerMeshCount") or 0) <= 0
	end
	local satchelProfile = getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
	if satchelProfile then
		return not asset
			or asset:GetAttribute("__LionSatchelMeshSkin") ~= satchelProfile.Skin
			or asset:GetAttribute("__LionSatchelMeshSignature") ~= getSatchelMeshSignature(satchelProfile)
			or (asset:GetAttribute("__LionSatchelMeshCount") or 0) <= 0
	end
	local rpgProfile = RPG_MESH_SKIN_OVERRIDES[cosmeticName]
	if rpgProfile then
		return not asset
			or asset:GetAttribute("__LionRpgMeshSkin") ~= rpgProfile.Skin
			or asset:GetAttribute("__LionRpgMeshSignature") ~= getRpgMeshSignature(rpgProfile)
			or asset:GetAttribute("__LionRpgRocketVisible") ~= false
			or ((asset:GetAttribute("__LionRpgMeshCount") or 0) + (asset:GetAttribute("__LionRpgHiddenCount") or 0)) <= 0
	end
	local fistsProfile = FISTS_MESH_SKIN_OVERRIDES[cosmeticName]
	if fistsProfile then
		return not asset
			or asset:GetAttribute("__LionFistsMeshSkin") ~= fistsProfile.Skin
			or asset:GetAttribute("__LionFistsMeshSignature") ~= getFistsMeshSignature(fistsProfile)
			or (asset:GetAttribute("__LionFistsMeshCount") or 0) <= 0
	end
	local bowProfile = BOW_MESH_SKIN_OVERRIDES[cosmeticName]
	if bowProfile then
		return not asset
			or asset:GetAttribute("__LionBowMeshSkin") ~= bowProfile.Skin
			or asset:GetAttribute("__LionBowMeshSignature") ~= getBowMeshSignature(bowProfile)
			or (asset:GetAttribute("__LionBowMeshCount") or 0) <= 0
	end
	local assaultRifleProfile = ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName]
	if assaultRifleProfile then
		return not asset
			or asset:GetAttribute("__LionAssaultRifleMeshSkin") ~= assaultRifleProfile.Skin
			or asset:GetAttribute("__LionAssaultRifleMeshSignature") ~= getAssaultRifleMeshSignature(assaultRifleProfile)
			or (asset:GetAttribute("__LionAssaultRifleMeshCount") or 0) <= 0
	end
	return cosmeticName == DICE_TRIPMINE_SKIN
		and asset
		and asset:GetAttribute("__LionRightArmRetargeted")
end

local function ensureVirtualViewModel(cosmeticName, itemName, viewModelName)
	local sourceInfo = ilib.ViewModels and ilib.ViewModels[viewModelName]
	if not sourceInfo then return nil end

	if cosmeticName ~= viewModelName then
		local usesSourceAnimations = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName] or DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName] or SATCHEL_MESH_SKIN_OVERRIDES[cosmeticName] or RPG_MESH_SKIN_OVERRIDES[cosmeticName] or FISTS_MESH_SKIN_OVERRIDES[cosmeticName] or BOW_MESH_SKIN_OVERRIDES[cosmeticName] or ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName] or cosmeticName == KNIFE_CUSTOM_SKIN or cosmeticName == "Grenade (Custom Skin)" or cosmeticName == "Molotov (Custom Skin)" or cosmeticName == "Satchel (Custom Skin)" or cosmeticName == "Smoke Grenade (Custom Skin)" or cosmeticName == "Warpstone (Custom Skin)" or cosmeticName == "sky"
		local animationInfo = usesSourceAnimations and sourceInfo or ilib.ViewModels[itemName]
		local baseInfo = animationInfo or sourceInfo
		local virtualInfo = table.clone(sourceInfo)
		if type(baseInfo.Animations) == "table" then
			virtualInfo.Animations = table.clone(baseInfo.Animations)
		end
		ilib.ViewModels[cosmeticName] = virtualInfo

		pcall(function()
			local viewModelAssets = lps.Assets and lps.Assets:FindFirstChild("ViewModels")
			if not viewModelAssets then return end
			local existingAsset = findDescendantByName(viewModelAssets, cosmeticName)
			if existingAsset then
				if shouldRebuildVirtualViewModelAsset(cosmeticName, existingAsset, false) then
					existingAsset:Destroy()
				else
					applyVirtualViewModelAssetOverrides(cosmeticName, existingAsset, false)
					return
				end
			end

			local sourceAsset = findDescendantByName(viewModelAssets, viewModelName)
			if sourceAsset then
				local clonedAsset = sourceAsset:Clone()
				clonedAsset.Name = cosmeticName
				applyVirtualViewModelAssetOverrides(cosmeticName, clonedAsset, false)
				clonedAsset.Parent = viewModelAssets
			end
		end)

		pcall(function()
			local throwables = lps.Assets and lps.Assets:FindFirstChild("Throwables")
			if not throwables then return end
			local existingThrowable = throwables:FindFirstChild(cosmeticName)
			if existingThrowable then
				if shouldRebuildVirtualViewModelAsset(cosmeticName, existingThrowable, true) then
					existingThrowable:Destroy()
				else
					applyVirtualViewModelAssetOverrides(cosmeticName, existingThrowable, true)
					return
				end
			end
			local sourceThrowable = findDescendantByName(throwables, viewModelName)
			if sourceThrowable then
				local clonedThrowable = sourceThrowable:Clone()
				clonedThrowable.Name = cosmeticName
				applyVirtualViewModelAssetOverrides(cosmeticName, clonedThrowable, true)
				clonedThrowable.Parent = throwables
			end
		end)

		pcall(function()
			if itemName ~= "Jump Pad" then return end
			local misc = lps.Assets and lps.Assets:FindFirstChild("Misc")
			local jumpPads = misc and misc:FindFirstChild("JumpPads")
			if not jumpPads then return end
			local existingJumpPad = jumpPads:FindFirstChild(cosmeticName)
			if existingJumpPad then
				if shouldRebuildVirtualViewModelAsset(cosmeticName, existingJumpPad, true) then
					existingJumpPad:Destroy()
				else
					applyVirtualViewModelAssetOverrides(cosmeticName, existingJumpPad, true)
					return
				end
			end
			local sourceJumpPad = jumpPads:FindFirstChild(viewModelName) or jumpPads:FindFirstChild("Default")
			if sourceJumpPad then
				local clonedJumpPad = sourceJumpPad:Clone()
				clonedJumpPad.Name = cosmeticName
				applyVirtualViewModelAssetOverrides(cosmeticName, clonedJumpPad, true)
				clonedJumpPad.Parent = jumpPads
			end
		end)
	end

	return sourceInfo
end

local function registerVirtualWeaponSkin(cosmeticName, itemName, viewModelName, rarity, displayName, worldViewModelName)
	local viewModelInfo = ensureVirtualViewModel(cosmeticName, itemName, viewModelName)
	if not viewModelInfo then return end
	local imageInfo = cosmeticName == DICE_TRIPMINE_SKIN and ilib.ViewModels and ilib.ViewModels["RNG Dice"] or viewModelInfo
	local image = imageInfo.Image or ""
	local imageHighResolution = imageInfo.ImageHighResolution or imageInfo.Image or ""
	local imageOverride = CUSTOM_SKIN_IMAGE_OVERRIDES[cosmeticName]
	if imageOverride then
		image = imageOverride.Image or ""
		imageHighResolution = imageOverride.ImageHighResolution or imageOverride.Image or ""
	end

	if ilib.ViewModels and ilib.ViewModels[cosmeticName] then
		ilib.ViewModels[cosmeticName].Image = image
		ilib.ViewModels[cosmeticName].ImageHighResolution = imageHighResolution
	end

	coss[cosmeticName] = {
		Rarity = rarity or "Contraband",
		Type = "Skin",
		DisplayName = displayName or cosmeticName,
		ViewModelName = cosmeticName,
		SourceViewModelName = viewModelName,
		WorldViewModelName = worldViewModelName or viewModelName,
		Image = image,
		ImageHighResolution = imageHighResolution,
		ImageScale = 3,
		ItemName = itemName,
		Owned = true,
		Unlocked = true,
		Locked = false
	}
end

local function registerVirtualWeaponSkins()
	coss["Flashbang (Custom Skin)"] = nil
	if ilib.ViewModels then
		ilib.ViewModels["Flashbang (Custom Skin)"] = nil
	end
	registerVirtualWeaponSkin(KNIFE_CUSTOM_SKIN, "Knife", "Glast Shard", "Contraband")
	registerVirtualWeaponSkin(REAVER_KNIFE_CUSTOM_SKIN, "Knife", "Pencil", "Contraband", "reaver")
	registerVirtualWeaponSkin(DAGGERS_CUSTOM_SKIN, "Daggers", "Keynais", "Contraband")
	registerVirtualWeaponSkin("Grenade (Custom Skin)", "Grenade", "Elixir", "Contraband")
	registerVirtualWeaponSkin("Grenade Raze", "Grenade", "Glorious Grenade", "Contraband", "Raze")
	registerVirtualWeaponSkin("sky", "Flashbang", "Shining Star", "Contraband")
	registerVirtualWeaponSkin("Molotov (Custom Skin)", "Molotov", "Elixir", "Contraband", "Elixir")
	registerVirtualWeaponSkin("Satchel (Custom Skin)", "Satchel", "Elixir", "Contraband")
	registerVirtualWeaponSkin(SATCHEL_CUSTOM_SKIN, "Satchel", "Satchel", "Contraband", "Raze", SATCHEL_CUSTOM_SKIN)
	registerVirtualWeaponSkin("Smoke Grenade (Custom Skin)", "Smoke Grenade", "Elixir", "Contraband")
	registerVirtualWeaponSkin("Warpstone (Custom Skin)", "Warpstone", "Elixir", "Contraband")
	registerVirtualWeaponSkin("Scythe (Custom Skin)", "Scythe", "Scepter", "Contraband")
	registerVirtualWeaponSkin("Katana (Custom Skin)", "Katana", "Scepter", "Contraband")
	registerVirtualWeaponSkin("Spear (Custom Skin)", "Spear", "Scepter", "Contraband")
	registerVirtualWeaponSkin("Handgun (Custom Skin)", "Handgun", "Glass Cannon", "Contraband")
	registerVirtualWeaponSkin(SNIPER_CUSTOM_SKIN, "Sniper", "Keyper", "Contraband")
	registerVirtualWeaponSkin("Operator", "Sniper", "Sniper", "Contraband")
	registerVirtualWeaponSkin("Medkit (Custom Skin)", "Medkit", "RNG Dice", "Contraband")
	registerVirtualWeaponSkin(RPG_CUSTOM_SKIN, "RPG", "Nuke Launcher", "Contraband", "Raze", RPG_CUSTOM_SKIN)
	registerVirtualWeaponSkin(FISTS_CUSTOM_SKIN, "Fists", "Fists", "Contraband", "Agent")
	registerVirtualWeaponSkin(BOW_CUSTOM_SKIN, "Bow", "Frostbite Bow", "Contraband")
	registerVirtualWeaponSkin(ASSAULT_RIFLE_CUSTOM_SKIN, "Assault Rifle", "AK-47", "Contraband")
	registerVirtualWeaponSkin("Camera", "Jump Pad", "Jump Pad", "Contraband", "Camera", "Camera")
	registerVirtualWeaponSkin(DICE_TRIPMINE_SKIN, "Subspace Tripmine", "Subspace Tripmine", "Contraband", nil, DICE_TRIPMINE_SKIN)
	registerVirtualWeaponSkin(SPIKE_TRIPMINE_SKIN, "Subspace Tripmine", "Subspace Tripmine", "Contraband", "Spike", SPIKE_TRIPMINE_SKIN)
end

registerVirtualWeaponSkins()

local cdata = dctrl.CurrentData
if not cdata then
	task.spawn(function()
		repeat task.wait() until dctrl.CurrentData
		cdata = dctrl.CurrentData
	end)
end

local equip, favs = {}, {}
local cwep, vprof, lwep
local lpname = lp.Name
local fcache = {}

local function banned(n)
	if type(n) ~= "string" then return true end
	return n:find("MISSING_") or n:find("Bubblegum") or n:find("Ragdoll") or n:find("Fall Apart") or n:find("Every Finisher Ever")
end

local function toenum(n)
	if not elib then return nil end
	local ok, id = pcall(elib.ToEnum, elib, n)
	return ok and id or nil
end

local function clonecos(name, ctype, inv, favonly)
	if banned(name) then return nil end
	local base = coss[name]
	if not base then return nil end
	local d = table.clone(base)
	d.Name = name
	d.Type = d.Type or ctype
	d.Seed = d.Seed or math.random(1, 1000000)
	d.Owned = true
	d.Unlocked = true
	d.Locked = false
	d.Amount = math.max(1, tonumber(d.Amount) or 1)
	d.Count = math.max(1, tonumber(d.Count) or 1)
	local eid = toenum(name)
	if eid then d.Enum = eid d.ObjectID = d.ObjectID or eid end
	if inv ~= nil then d.Inverted = inv end
	if favonly ~= nil then d.OnlyUseFavorites = favonly end
	return d
end

-- savecfg and loadcfg removed

local finv = {}
local function rebuildinv()
	table.clear(finv)
	for _, cos in equip do
		for _, cd in cos do
			if cd and cd.Name and not banned(cd.Name) then
				finv[cd.Name] = cd
			end
		end
	end
end

rebuildinv()

local oget = dctrl.Get
dctrl.Get = function(self, key)
	local data = oget(self, key)
	if key == "CosmeticInventory" then
		local proxy = {}
		if data then for k, v in data do if not banned(k) then proxy[k] = v end end end
		for name, cosmetic in finv do
			if proxy[name] == nil or type(proxy[name]) == "boolean" then
				proxy[name] = cosmetic
			end
		end
		return proxy
	end
	if key == "FavoritedCosmetics" then
		local res = data and table.clone(data) or {}
		for wep, fv in favs do
			local slot = res[wep] or {}
			res[wep] = slot
			for name, isfav in fv do
				if not banned(name) then slot[name] = isfav end
			end
		end
		return res
	end
	return data
end

local ogetwep = dctrl.GetWeaponData
dctrl.GetWeaponData = function(self, wname)
	local data = ogetwep(self, wname)
	if not data then return nil end
	local merged = table.clone(data)
	merged.Name = wname
	local weq = equip[wname]
	if weq then for ct, cd in weq do merged[ct] = cd end end
	return merged
end

local function saferep(key)
	pcall(function()
		if not cdata and dctrl.CurrentData then cdata = dctrl.CurrentData end
		if cdata then cdata:Replicate(key) end
	end)
end

local fctrl, wrapController
pcall(function() fctrl = require(ctrls:WaitForChild("FighterController", 10)) end)
pcall(function() wrapController = require(ctrls:WaitForChild("WrapController", 10)) end)
local replicatedClass
pcall(function()
	local identity = getthreadidentity and getthreadidentity()
	if setthreadidentity then pcall(setthreadidentity, 2) end
	local ok, result = pcall(require, reps.Modules.ReplicatedClass)
	if identity and setthreadidentity then pcall(setthreadidentity, identity) end
	if ok then replicatedClass = result end
end)
local charmAssets, wrapPreviewAsset, wrapTextureAssets
pcall(function()
	charmAssets = lps.Assets:WaitForChild("Charms", 10)
	wrapPreviewAsset = lps.Assets:WaitForChild("Misc", 10):WaitForChild("Wrap", 10)
	wrapTextureAssets = lps.Assets:WaitForChild("WrapTextures", 10)
end)

local function resolveViewModelName(weapon, cosmetics)
	local skin = cosmetics and cosmetics.Skin
	local skinName = skin and (skin.ViewModelName or skin.Name)
	return skinName or weapon
end

local function resolveViewModelSourceName(weapon, cosmetics)
	local skin = cosmetics and cosmetics.Skin
	return skin and (skin.SourceViewModelName or skin.ViewModelName or skin.Name) or weapon
end

local virtualViewModelClassOverrides = {
	[KNIFE_CUSTOM_SKIN] = "Knife",
	[REAVER_KNIFE_CUSTOM_SKIN] = "Knife",
	[DAGGERS_CUSTOM_SKIN] = "Keynais",
	[SNIPER_CUSTOM_SKIN] = "Keyper",
	["Operator"] = "Sniper",
	[RPG_CUSTOM_SKIN] = "Nuke Launcher",
	[FISTS_CUSTOM_SKIN] = "Fists",
		[BOW_CUSTOM_SKIN] = "Frostbite Bow",
		[ASSAULT_RIFLE_CUSTOM_SKIN] = "AK-47",
		["Grenade (Custom Skin)"] = "Elixir",
		["Grenade Raze"] = "Glorious Grenade",
		["sky"] = "Shining Star",
	["Molotov (Custom Skin)"] = "Elixir",
	["Satchel (Custom Skin)"] = "Elixir",
	["Smoke Grenade (Custom Skin)"] = "Elixir",
	["Warpstone (Custom Skin)"] = "Elixir",
	[SATCHEL_CUSTOM_SKIN] = "BaseSatchel",
	[DICE_TRIPMINE_SKIN] = "SubspaceTripmine",
	[SPIKE_TRIPMINE_SKIN] = "SubspaceTripmine"
}

local function resolveViewModelClassName(_, cosmetics, resolvedName)
	return (resolvedName and virtualViewModelClassOverrides[resolvedName]) or resolvedName
end

local resolveViewModelClass
local clientViewModelClass
local clientViewModelBaseNew
local constructingVirtualViewModelClass = false

local function getewep()
	if not fctrl then return nil end
	local fighter = fctrl:GetFighter(lp)
	if not fighter or not fighter.Items then return nil end
	for _, item in fighter.Items do
		if item.IsEquipped then return item.Name end
	end
	return nil
end

if hookfunction then
	local rems = reps:FindFirstChild("Remotes")
	local drems = rems and rems:FindFirstChild("Data")
	local eqrem = drems and drems:FindFirstChild("EquipCosmetic")
	local favrem = drems and drems:FindFirstChild("FavoriteCosmetic")
	local rrems = rems and rems:FindFirstChild("Replication")
	local frems = rrems and rrems:FindFirstChild("Fighter")
	local uirem = frems and frems:FindFirstChild("UseItem")

	if eqrem then
		local oldFireServer
		oldFireServer = hookfunction(eqrem.FireServer, newcclosure(function(self, ...)
			local args = { ... }

			if uirem and self == uirem and fctrl then
				pcall(function()
					local fighter = fctrl:GetFighter(lp)
					if fighter and fighter.Items then
						local oid = args[1]
						for _, item in fighter.Items do
							if item:Get("ObjectID") == oid then
								lwep = item.Name
								break
							end
						end
					end
				end)
			end

			if self == eqrem then
				local wname, ctype, cname, opts = args[1], args[2], args[3], args[4] or {}
				if not cname or cname == "None" or cname == "" then
					equip[wname] = equip[wname] or {}
					equip[wname][ctype] = nil
					if not next(equip[wname]) then equip[wname] = nil end
					rebuildinv()
					task.defer(function()
						saferep("WeaponInventory")
					end)
					return oldFireServer(self, ...)
				end
				if banned(cname) then return oldFireServer(self, ...) end
				local rdata = oget(dctrl, "CosmeticInventory")
				if rdata and type(rdata[cname]) ~= "boolean" and rdata[cname] ~= nil then
					return oldFireServer(self, ...)
				end
				equip[wname] = equip[wname] or {}
				local cloned = clonecos(cname, ctype, opts.IsInverted, opts.OnlyUseFavorites)
				if cloned then equip[wname][ctype] = cloned end
				if ctype == "Finisher" then fcache[wname] = cname end
				rebuildinv()
				task.defer(function()
					saferep("WeaponInventory")
				end)
				return
			end

			if self == favrem then
				local fwep, fname, fstate = args[1], args[2], args[3]
				if not fname or fname == "None" or fname == "" then return oldFireServer(self, ...) end
				if banned(fname) then return oldFireServer(self, ...) end
				favs[fwep] = favs[fwep] or {}
				favs[fwep][fname] = fstate or nil
				task.spawn(saferep, "FavoritedCosmetics")
				return
			end

			return oldFireServer(self, ...)
		end))
	end
end

local citem
pcall(function() citem = require(lps.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)

local function applyLiveFistsMeshProfile(wname, viewModel)
	if wname ~= "Fists" then return end
	local skin = equip[wname] and equip[wname].Skin
	local skinName = skin and (skin.ViewModelName or skin.Name)
	local profile = skinName and FISTS_MESH_SKIN_OVERRIDES[skinName]
	if not profile then return end

	task.spawn(function()
		for _ = 1, 30 do
			local model
			if typeof(viewModel) == "Instance" then
				model = viewModel
			elseif type(viewModel) == "table" then
				model = viewModel.Model or viewModel.ItemModel
			end
			if typeof(model) == "Instance" then
				if applyFistsMeshProfile(model, profile) then
					return
				end
			end
			task.wait()
		end
	end)
end

if citem and citem._CreateViewModel then
	local ocvm = citem._CreateViewModel
	citem._CreateViewModel = function(self, vmref)
		local wname = self.Name
		local wplr = self.ClientFighter and self.ClientFighter.Player
		cwep = (wplr == lp) and wname or nil
		local directClass
		if wplr == lp and equip[wname] and vmref then
			local cos = equip[wname]
			local dk = self:ToEnum("Data")
			local data = vmref[dk] or vmref.Data or {}
			if data then
				if vmref[dk] ~= nil or vmref.Data == nil then
					vmref[dk] = data
					vmref.Data = nil
				else
					vmref.Data = data
				end
				local resolvedName = resolveViewModelName(wname, cos)
				local className = resolveViewModelClassName(wname, cos, resolvedName)
				if cos.Skin then
					data[self:ToEnum("Skin")] = cos.Skin
				end
				data[self:ToEnum("Name")] = resolvedName
				if cos.Wrap then
					data[self:ToEnum("Wrap")] = cos.Wrap
				end
				if cos.Charm then
					data[self:ToEnum("Charm")] = cos.Charm
				end
				data.Skin = nil
				data.Name = nil
				data.Wrap = nil
				data.Charm = nil
				if className ~= resolvedName and resolveViewModelClass then
					directClass = resolveViewModelClass(className)
				end
			end
		end
		if directClass and directClass ~= clientViewModelClass and directClass.new then
			local identity = getthreadidentity and getthreadidentity() or 8
			constructingVirtualViewModelClass = true
			local ok, res = pcall(function()
				if setthreadidentity then pcall(setthreadidentity, 2) end
				return directClass.new(vmref, self)
			end)
			constructingVirtualViewModelClass = false
			if setthreadidentity then pcall(setthreadidentity, identity) end
			cwep = nil
			if ok then
				applyLiveFistsMeshProfile(wname, res)
				return res
			end
		end
		local res = ocvm(self, vmref)
		cwep = nil
		applyLiveFistsMeshProfile(wname, res)
		return res
	end
end

local vmmod = lps.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if vmmod then
	local cvm = require(vmmod)
	clientViewModelClass = cvm
	if cvm.GetWrap then
		local ogw = cvm.GetWrap
		cvm.GetWrap = function(self)
			local ci = self.ClientItem
			local wname = ci and ci.Name
			local wplr = ci and ci.ClientFighter and ci.ClientFighter.Player
			local weq = wname and wplr == lp and equip[wname]
			return (weq and weq.Wrap) or ogw(self)
		end
	end
	if cvm._UpdateWrap and wrapController then
		local oldUpdateWrap = cvm._UpdateWrap
		local function isCustomTripmineViewModel(self)
			if not self then return false end
			if TRIPMINE_MESH_SKIN_OVERRIDES[self.Name] then
				return true
			end
			local ci = self.ClientItem
			local weapon = ci and ci.Name
			local skin = weapon and equip[weapon] and equip[weapon].Skin
			local skinName = skin and (skin.ViewModelName or skin.Name)
			return weapon == "Subspace Tripmine" and TRIPMINE_MESH_SKIN_OVERRIDES[skinName] ~= nil
		end
		local function collectCustomTripmineWrapTargets(model)
			local targets = {}
			for _, descendant in ipairs(model:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant:GetAttribute("__LionCustomTripmineMeshPart") then
					if descendant:GetAttribute("WrapGroup") == nil then
						descendant:SetAttribute("WrapGroup", 1)
					end
					descendant:SetAttribute("IgnoreTransparency", true)
					pcall(function() descendant:AddTag("Wrappable") end)
					pcall(function() collectionService:AddTag(descendant, "Wrappable") end)
					table.insert(targets, descendant)
				end
			end
			return targets
		end
		cvm._UpdateWrap = function(self, ...)
			if isCustomTripmineViewModel(self) and self.Model then
				local targets = collectCustomTripmineWrapTargets(self.Model)
				if #targets > 0 then
					local wrap = self.GetWrap and self:GetWrap() or nil
					if self._original_wrap_properties then
						pcall(wrapController.ResetWrap, wrapController, self._original_wrap_properties)
						self._original_wrap_properties = nil
					end
					if self.__LionCustomTripmineWrapProperties then
						pcall(wrapController.ResetWrap, wrapController, self.__LionCustomTripmineWrapProperties)
						self.__LionCustomTripmineWrapProperties = nil
					end
					if wrap then
						self.__LionCustomTripmineWrapProperties = wrapController:RecordOriginalWrapProperties(targets)
						wrapController:ApplyWrap(self.__LionCustomTripmineWrapProperties, wrap, true)
					end
					if self._UpdateLocalTransparencyModifiers then
						pcall(self._UpdateLocalTransparencyModifiers, self)
					end
					return
				end
			end
			return oldUpdateWrap(self, ...)
		end
	end
	local onew = cvm.new
	clientViewModelBaseNew = onew
	cvm.new = function(rdata, cliitm)
		if constructingVirtualViewModelClass then
			return onew(rdata, cliitm)
		end
		local wplr = cliitm.ClientFighter and cliitm.ClientFighter.Player
		local wname = cwep or cliitm.Name
		local className = wname
		if wplr == lp and equip[wname] then
			local rcls = require(reps.Modules.ReplicatedClass)
			local dk = rcls:ToEnum("Data")
			local slot = rdata[dk] or rdata.Data or {}
			if rdata[dk] ~= nil or rdata.Data == nil then
				rdata[dk] = slot
				rdata.Data = nil
			else
				rdata.Data = slot
			end
			local cos = equip[wname]
			local resolvedName = resolveViewModelName(wname, cos)
			className = resolveViewModelClassName(wname, cos, resolvedName)
			if cos.Skin then
				slot[rcls:ToEnum("Skin")] = cos.Skin
			end
			slot[rcls:ToEnum("Name")] = resolvedName
			if cos.Wrap then
				slot[rcls:ToEnum("Wrap")] = cos.Wrap
			end
			if cos.Charm then
				slot[rcls:ToEnum("Charm")] = cos.Charm
			end
			slot.Skin = nil
			slot.Name = nil
			slot.Wrap = nil
			slot.Charm = nil
		end
		local targetNew = onew
		local targetClass = className ~= wname and resolveViewModelClass and resolveViewModelClass(className)
		if targetClass and targetClass ~= clientViewModelClass and targetClass.new then
			targetNew = targetClass.new
		end
		constructingVirtualViewModelClass = targetNew ~= onew
		local ok, res = pcall(targetNew, rdata, cliitm)
		constructingVirtualViewModelClass = false
		if not ok and wplr == lp and equip[wname] and equip[wname].Skin then
			local rcls = require(reps.Modules.ReplicatedClass)
			local dk = rcls:ToEnum("Data")
			local slot = rdata[dk] or rdata.Data or {}
			rdata[dk] = slot
			rdata.Data = nil
			slot[rcls:ToEnum("Name")] = wname
			slot.Name = nil
			ok, res = pcall(onew, rdata, cliitm)
		end
		if not ok then error(res) end
		if wplr == lp and equip[wname] and res then
			for _, method in ipairs({"_UpdateWrap", "UpdateWrap", "_UpdateCharm", "UpdateCharm", "_UpdateCosmetics", "UpdateCosmetics"}) do
				if res[method] then
					pcall(res[method], res)
				end
			end
			applyLiveFistsMeshProfile(wname, res)
		end
		return res
	end
end

local viewModelClassCache = {}
local function normalizeViewModelName(name)
	return tostring(name or ""):gsub("[%W_]+", ""):lower()
end

resolveViewModelClass = function(name)
	if not clientViewModelClass then return nil end
	local key = normalizeViewModelName(name)
	if viewModelClassCache[key] ~= nil then
		return viewModelClassCache[key] or clientViewModelClass
	end
	local targetClass = clientViewModelClass
	local vmFolder = lps.Modules:FindFirstChild("ViewModels")
	if vmFolder then
		for _, module in pairs(vmFolder:GetDescendants()) do
			if module:IsA("ModuleScript") and normalizeViewModelName(module.Name) == key then
				local ok, customClass = pcall(require, module)
				if ok and type(customClass) == "table" and type(customClass.new) == "function" then
					targetClass = customClass
				end
				break
			end
		end
	end
	viewModelClassCache[key] = targetClass
	return targetClass
end

local function getLocalItem(weapon)
	local fighter = fctrl and fctrl:GetFighter(lp)
	for _, item in pairs(fighter and fighter.Items or {}) do
		if item.Name == weapon then
			return item
		end
	end
end

local function getWorldSkinName(weapon)
	local skin = equip[weapon] and equip[weapon].Skin
	return skin and (skin.WorldViewModelName or skin.SourceViewModelName or skin.ViewModelName or skin.Name)
end

local function getEquippedWeaponWrap(weapon)
	local item = getLocalItem(weapon)
	if item and item.GetWrap then
		local ok, wrap = pcall(item.GetWrap, item)
		if ok then
			return wrap
		end
	end
	return equip[weapon] and equip[weapon].Wrap
end

local function isInsideWorkspaceViewModels(inst)
	local viewModels = workspace:FindFirstChild("ViewModels")
	return viewModels and inst:IsDescendantOf(viewModels)
end

local function isRpgRazeEquipped()
	return getWorldSkinName("RPG") == RPG_CUSTOM_SKIN
end

local function tryApplyRpgProjectileSkin(inst)
	local profile = RPG_MESH_SKIN_OVERRIDES[RPG_CUSTOM_SKIN]
	if not (profile and isRpgRazeEquipped() and typeof(inst) == "Instance") then return end
	if isInsideWorkspaceViewModels(inst) then return end
	if inst:GetAttribute("__LionRpgProjectileSkinChecked") then return end

	local shouldApply = false
	if inst:IsA("MeshPart") or inst:IsA("SpecialMesh") then
		shouldApply = meshMatchesAnyAssetId(inst, profile.RocketMeshIds) or meshMatchesAnyAssetId(inst, profile.JuggleMeshIds)
	elseif inst:IsA("Model") then
		shouldApply = namePathContains(inst, "rocket") or namePathContains(inst, "projectile")
	end
	if not shouldApply then return end

	inst:SetAttribute("__LionRpgProjectileSkinChecked", true)
	applyRpgMeshProfile(inst, profile, {
		ShowRocket = true,
		ForceRocket = true
	})
end

local function installRpgProjectileSkinHook()
	local env = getgenv and getgenv() or _G
	local state = env.__LionRpgProjectileSkinHookState or {}
	env.__LionRpgProjectileSkinHookState = state
	local version = 2
	if state.Version == version and state.Connection then return end
	if state.Connection then
		pcall(function() state.Connection:Disconnect() end)
	end
	state.Version = version
	state.Connection = workspace.DescendantAdded:Connect(function(inst)
		task.defer(tryApplyRpgProjectileSkin, inst)
	end)
	task.defer(function()
		for _, inst in ipairs(workspace:GetDescendants()) do
			tryApplyRpgProjectileSkin(inst)
		end
	end)
end

local function disableRpgProjectileSkinHook()
	local env = getgenv and getgenv() or _G
	local state = env.__LionRpgProjectileSkinHookState
	if state and state.Connection then
		pcall(function() state.Connection:Disconnect() end)
	end
	env.__LionRpgProjectileSkinHookState = {
		Version = 3,
		Connection = nil
	}
end

local function ensurePlacedTripmineWrapTargets(visual)
	if typeof(visual) ~= "Instance" then return end
	for _, descendant in ipairs(visual:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant:GetAttribute("__LionCustomTripmineMeshPart") then
			if descendant:GetAttribute("WrapGroup") == nil then
				descendant:SetAttribute("WrapGroup", 1)
			end
			descendant:SetAttribute("IgnoreTransparency", true)
			pcall(function() descendant:AddTag("Wrappable") end)
			pcall(function() collectionService:AddTag(descendant, "Wrappable") end)
		end
	end
end

local function applyPlacedTripmineWrap(visual)
	if not wrapController or typeof(visual) ~= "Instance" then return end
	ensurePlacedTripmineWrapTargets(visual)
	local wrap = getEquippedWeaponWrap("Subspace Tripmine")
	pcall(function()
		local originalWrapProperties = wrapController:RecordOriginalWrapProperties(visual)
		wrapController:ApplyWrap(originalWrapProperties, wrap, true)
	end)
end

local function isLocalPlacedObject(object, weapon)
	local userId = object:GetAttribute("PlacedByUserID")
		or object:GetAttribute("ThrownByUserID")
		or object:GetAttribute("OwnerUserID")
	if userId ~= nil then
		return tonumber(userId) == lp.UserId
	end

	local objectId = object:GetAttribute("ObjectID")
	local item = getLocalItem(weapon)
	return objectId ~= nil and item and item.Get and item:Get("ObjectID") == objectId
end

local function isInsidePlacedSkinVisual(inst)
	local current = inst
	while current do
		if current.Name == "__LionPlacedSkin" or current:GetAttribute("__LionPlacedSkin") then
			return true
		end
		current = current.Parent
	end
	return false
end

local function hideOriginalTripmineVisual(object)
	if typeof(object) ~= "Instance" then return end

	local function hide(inst)
		if isInsidePlacedSkinVisual(inst) then return end
		if inst:IsA("BasePart") then
			inst.Transparency = 1
			inst.LocalTransparencyModifier = 1
		elseif inst:IsA("Decal") or inst:IsA("Texture") then
			inst.Transparency = 1
		elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") then
			inst.Enabled = false
		end
	end

	for _, descendant in ipairs(object:GetDescendants()) do
		hide(descendant)
	end

	if not object:GetAttribute("__LionHideOriginalTripmineHook") then
		object:SetAttribute("__LionHideOriginalTripmineHook", true)
		local connection
		connection = object.DescendantAdded:Connect(function(descendant)
			task.defer(hide, descendant)
		end)
		task.delay(8, function()
			if connection then
				connection:Disconnect()
			end
		end)
	end

	if not object:GetAttribute("__LionHideOriginalTripmineLoop") then
		object:SetAttribute("__LionHideOriginalTripmineLoop", true)
		task.spawn(function()
			for _ = 1, 80 do
				if not object.Parent then break end
				for _, descendant in ipairs(object:GetDescendants()) do
					hide(descendant)
				end
				task.wait(0.1)
			end
			if object.Parent then
				object:SetAttribute("__LionHideOriginalTripmineLoop", nil)
			end
		end)
	end
end

local function prunePlacedTripmineVisualToCustomMesh(visual)
	if typeof(visual) ~= "Instance" then return end
	local primaryPart
	for _, descendant in ipairs(visual:GetDescendants()) do
		if descendant:IsA("BasePart") then
			if descendant:GetAttribute("__LionCustomTripmineMeshPart") then
				primaryPart = primaryPart or descendant
			else
				descendant:Destroy()
			end
		end
	end
	if visual:IsA("Model") and primaryPart then
		visual.PrimaryPart = primaryPart
	end
end

local function isInsideCustomTripmineMeshPart(inst)
	local current = inst
	while current do
		if current:IsA("BasePart") and current:GetAttribute("__LionCustomTripmineMeshPart") then
			return true
		end
		current = current.Parent
	end
	return false
end

local function forcePlacedSkinVisualVisible(visual)
	if typeof(visual) ~= "Instance" then return end

	local function show(inst)
		if inst:IsA("BasePart") and inst:GetAttribute("__LionCustomTripmineMeshPart") then
			inst.Transparency = 0
			inst.LocalTransparencyModifier = 0
		elseif (inst:IsA("Decal") or inst:IsA("Texture")) and isInsideCustomTripmineMeshPart(inst) then
			inst.Transparency = 0
		end
	end

	for _, descendant in ipairs(visual:GetDescendants()) do
		show(descendant)
	end

	if not visual:GetAttribute("__LionShowPlacedSkinLoop") then
		visual:SetAttribute("__LionShowPlacedSkinLoop", true)
		local connection
		connection = visual.DescendantAdded:Connect(function(descendant)
			task.defer(show, descendant)
		end)
		task.spawn(function()
			for _ = 1, 100 do
				if not visual.Parent then break end
				for _, descendant in ipairs(visual:GetDescendants()) do
					show(descendant)
				end
				task.wait(0.1)
			end
			if connection then
				connection:Disconnect()
			end
			if visual.Parent then
				visual:SetAttribute("__LionShowPlacedSkinLoop", nil)
			end
		end)
	end
end

local function pivotPlacedTripmineVisual(visual, hitbox, profile)
	if not (visual and visual:IsA("Model") and hitbox and hitbox:IsA("BasePart")) then return end
	local boundsCFrame, boundsSize = visual:GetBoundingBox()
	local centerOffset = visual:GetPivot():ToObjectSpace(boundsCFrame)
	local groundOffset = profile and profile.WorldGroundOffset or 0
	local targetCenterOffsetY = (-hitbox.Size.Y * 0.5) + (boundsSize.Y * 0.5) + groundOffset
	local targetBoundsCFrame = hitbox.CFrame * CFrame.new(0, targetCenterOffsetY, 0)
	visual:PivotTo(targetBoundsCFrame * centerOffset:Inverse())
end

local function installPlacedCosmeticHooks()
	local components = lps.Modules:FindFirstChild("GameComponents")
	if not components then return end

	pcall(function()
		local jumpPads = require(components:WaitForChild("JumpPads", 10))
		if jumpPads.__LionSkinHook then return end
		jumpPads.__LionSkinHook = true
		local oldObjectAdded = jumpPads._ObjectAdded
		jumpPads._ObjectAdded = function(self, object)
			local skinName = getWorldSkinName("Jump Pad")
			if skinName and isLocalPlacedObject(object, "Jump Pad") then
				object:SetAttribute("ViewModelName", skinName)
			end
			return oldObjectAdded(self, object)
		end
	end)

	pcall(function()
		local tripmines = require(components:WaitForChild("SubspaceTripmines", 10))
		if tripmines.__LionSkinHook then return end
		tripmines.__LionSkinHook = true
		local oldObjectAdded = tripmines._ObjectAdded
		tripmines._ObjectAdded = function(self, object)
			local skinName = getWorldSkinName("Subspace Tripmine")
			local placedSkinName = skinName == "RNG Dice" and DICE_TRIPMINE_SKIN or skinName
			local meshProfile = TRIPMINE_MESH_SKIN_OVERRIDES[placedSkinName]
			if meshProfile and isLocalPlacedObject(object, "Subspace Tripmine") then
				task.defer(function()
					if not object.Parent or object:FindFirstChild("__LionPlacedSkin") then return end
					hideOriginalTripmineVisual(object)

					local throwables = lps.Assets:FindFirstChild("Throwables")
					local viewModels = lps.Assets:FindFirstChild("ViewModels")
					local sourceName = meshProfile.BaseAssetName or "Subspace Tripmine"
					local source = (throwables and findDescendantByName(throwables, sourceName)) or (viewModels and findDescendantByName(viewModels, sourceName))
					local hitbox = object:FindFirstChild("Hitbox", true)
					if not source or not hitbox or not hitbox:IsA("BasePart") then return end

					local visual = source:Clone()
					if not applyTripmineMeshProfile(visual, meshProfile, true) then
						visual:Destroy()
						return
					end
					prunePlacedTripmineVisualToCustomMesh(visual)
					if visual:IsA("BasePart") then
						local model = Instance.new("Model")
						model.Name = visual.Name
						visual.Parent = model
						model.PrimaryPart = visual
						visual = model
					end
					if not visual:IsA("Model") then return end
					for _, descendant in pairs(visual:GetDescendants()) do
						if descendant.Name == "_right_arm" or descendant.Name == "_left_arm" or descendant.Name == "_fake" then
							descendant:Destroy()
						end
					end
					visual.Name = "__LionPlacedSkin"
					visual:SetAttribute("__LionPlacedSkin", true)
					visual.Parent = object
					hideOriginalTripmineVisual(object)
					pivotPlacedTripmineVisual(visual, hitbox, meshProfile)
					forcePlacedSkinVisualVisible(visual)
					for _, part in pairs(visual:GetDescendants()) do
						if part:IsA("BasePart") then
							part.Anchored = false
							part.CanCollide = false
							part.CanTouch = false
							part.CanQuery = false
							part.Massless = true
							local weld = Instance.new("WeldConstraint")
							weld.Part0 = hitbox
							weld.Part1 = part
							weld.Parent = part
						end
					end
					applyPlacedTripmineWrap(visual)
					forcePlacedSkinVisualVisible(visual)
				end)
			end
			return oldObjectAdded(self, object)
		end
	end)

	pcall(function()
		local fireHitboxes = require(components:WaitForChild("FireHitboxes", 10))
		local fireAssets = lps.Assets:WaitForChild("Misc", 10):WaitForChild("FireHitboxes", 10)
		if not fireAssets:FindFirstChild("Elixir") then
			local elixirEffect = lps.Assets.Misc:FindFirstChild("ElixirExplosionEffect")
			local defaultFire = fireAssets:FindFirstChild("Default")
			if elixirEffect and defaultFire then
				local elixirFire = defaultFire:Clone()
				elixirFire.Name = "Elixir"
				for _, effect in pairs(elixirFire:GetDescendants()) do
					if effect:IsA("ParticleEmitter") or effect:IsA("Trail") or effect:IsA("Beam") then
						effect:Destroy()
					end
				end
				local primary = elixirFire:FindFirstChild("Primary")
				local attachment = elixirEffect:FindFirstChild("Attachment")
				if primary and attachment then
					attachment:Clone().Parent = primary
				end
				elixirFire.Parent = fireAssets
			end
		end

		local collectionService = game:GetService("CollectionService")
		local function replaceFireVisual(object)
			local skinName = getWorldSkinName("Molotov")
			if not skinName or not isLocalPlacedObject(object, "Molotov") then return end
			object:SetAttribute("ViewModelName", skinName)
			task.spawn(function()
				local entry
				for _ = 1, 20 do
					entry = fireHitboxes._fire_hitboxes and fireHitboxes._fire_hitboxes[object]
					if entry and entry.Visual then break end
					task.wait()
				end
				if not entry or not entry.Visual or not object.Parent then return end
				local source = fireAssets:FindFirstChild(skinName) or fireAssets:FindFirstChild("Default")
				if not source then return end

				local visual = source:Clone()
				visual.Name = skinName
				visual.PrimaryPart = visual:FindFirstChild("Primary")
				if not visual.PrimaryPart then return end
				visual.PrimaryPart.Size = object.Size
				visual:PivotTo(object.CFrame)
				visual.Parent = workspace
				for _, sound in ipairs({entry.Sound1, entry.Sound2}) do
					if sound then sound.Parent = visual.PrimaryPart end
				end
				local oldVisual = entry.Visual
				entry.Visual = visual
				oldVisual:Destroy()
			end)
		end

		collectionService:GetInstanceAddedSignal("FireHitbox"):Connect(replaceFireVisual)
		for _, object in pairs(collectionService:GetTagged("FireHitbox")) do
			task.defer(replaceFireVisual, object)
		end
	end)

	pcall(function()
		local smokeModule = lps.Modules:FindFirstChild("SmokeCloud")
		if not smokeModule then return end
		local smokeCloud = require(smokeModule)
		if smokeCloud.__LionSkinHook or type(smokeCloud.new) ~= "function" then return end
		smokeCloud.__LionSkinHook = true

		local oldNew = smokeCloud.new
		smokeCloud.new = function(...)
			local args = { ... }
			local cloud = oldNew(...)
			task.defer(function()
				local skinName = getWorldSkinName("Smoke Grenade")
				if skinName ~= "Elixir" or type(cloud) ~= "table" then return end

				local ownerObject
				for _, value in ipairs(args) do
					if typeof(value) == "Instance" and isLocalPlacedObject(value, "Smoke Grenade") then
						ownerObject = value
						break
					end
				end

				local model = cloud.Model
				if not ownerObject then
					for _, value in pairs(cloud) do
						if typeof(value) == "Instance" and isLocalPlacedObject(value, "Smoke Grenade") then
							ownerObject = value
							break
						end
					end
				end
				if not ownerObject and typeof(model) == "Instance" and isLocalPlacedObject(model, "Smoke Grenade") then
					ownerObject = model
				end
				if not ownerObject then
					local item = getLocalItem("Smoke Grenade")
					local localObjectId = item and item.Get and item:Get("ObjectID")
					local cloudObjectId = rawget(cloud, "ObjectID") or rawget(cloud, "_object_id")
					if localObjectId ~= nil and cloudObjectId == localObjectId then
						ownerObject = model
					end
				end
				if not ownerObject or typeof(model) ~= "Instance" or not model.Parent then return end
				if model:FindFirstChild("__LionSmokeSkin") then return end

				for _, descendant in pairs(model:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.LocalTransparencyModifier = 1
					end
				end

				local throwables = lps.Assets:FindFirstChild("Throwables")
				local source = throwables and throwables:FindFirstChild(skinName)
				if not source then return end

				local visual = source:Clone()
				visual.Name = "__LionSmokeSkin"
				local anchor = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
				if not anchor then
					anchor = Instance.new("Part")
					anchor.Name = "__LionSmokeAnchor"
					anchor.Size = Vector3.new(0.1, 0.1, 0.1)
					anchor.Transparency = 1
					anchor.Anchored = true
					anchor.CanCollide = false
					anchor.CanTouch = false
					anchor.CanQuery = false
					anchor.CFrame = model:IsA("Model") and model:GetPivot() or CFrame.new()
					anchor.Parent = model
				end

				visual.Parent = model
				visual:PivotTo(anchor.CFrame)
				for _, part in pairs(visual:GetDescendants()) do
					if part:IsA("BasePart") then
						part.Anchored = false
						part.CanCollide = false
						part.CanTouch = false
						part.CanQuery = false
						part.Massless = true
						local weld = Instance.new("WeldConstraint")
						weld.Part0 = anchor
						weld.Part1 = part
						weld.Parent = part
					end
				end
			end)
			return cloud
		end
	end)
end

disableRpgProjectileSkinHook()
installPlacedCosmeticHooks()

local function isValidViewModel(viewModel)
	return type(viewModel) == "table"
		and viewModel._destroyed ~= true
		and typeof(viewModel.Model) == "Instance"
		and typeof(viewModel.ItemModel) == "Instance"
end

local ogvi = ilib.GetViewModelImageFromWeaponData
ilib.GetViewModelImageFromWeaponData = function(self, wdata, hires)
	if not wdata then return ogvi(self, wdata, hires) end
	local wname = wdata.Name
	local weq = equip[wname]
	if weq and weq.Skin then
		local skinViewModelName = weq.Skin.ViewModelName or weq.Skin.Name
		local skinSourceName = weq.Skin.SourceViewModelName or skinViewModelName
		local sinfo = self.ViewModels[skinViewModelName] or self.ViewModels[skinSourceName]
		if sinfo then return sinfo[hires and "ImageHighResolution" or "Image"] or sinfo.Image end
		return weq.Skin[hires and "ImageHighResolution" or "Image"] or weq.Skin.Image or ""
	end
	return ogvi(self, wdata, hires)
end

pcall(function()
	local vpmod = require(lps.Modules.Pages.ViewProfile)
	if vpmod and vpmod.Fetch then
		local ofetch = vpmod.Fetch
		vpmod.Fetch = function(self, tplr)
			vprof = tplr
			return ofetch(self, tplr)
		end
	end
end)

local cent
pcall(function() cent = require(lps.Modules.ClientReplicatedClasses.ClientEntity) end)

if cent and cent._PlayFinisher then
	local ofin = cent._PlayFinisher
	cent._PlayFinisher = function(self, fname, ...)
		local ewep = getewep()
		local tfin = ewep and (fcache[ewep] or (equip[ewep] and equip[ewep].Finisher and equip[ewep].Finisher.Name))
		return ofin(self, tfin or fname, ...)
	end
end

rebuildinv()

for wname, wdata in equip do
	if wdata.Finisher and wdata.Finisher.Name then
		fcache[wname] = wdata.Finisher.Name
	end
end

local cosmeticGuiState = {
	Wanted = false,
	Gui = nil,
	WeaponSearch = "",
	CosmeticSearch = "",
	Mode = "Skin",
	SelectedWeapon = nil,
	SelectedCosmetic = nil,
	Weapons = {},
	Cosmetics = {},
	Columns = 6,
	TileW = 130,
	TileH = 124
}

local function displayName(name, data)
	return tostring((data and (data.DisplayName or data.Name)) or name or "")
end

local function iconFrom(data, fallback, name)
	if not data then return fallback or "" end
	local cosmeticImage = name and consts and consts.COSMETIC_IMAGES and consts.COSMETIC_IMAGES[name]
	local typeInfo = data.Type and clib.Types and clib.Types[data.Type]
	return cosmeticImage
		or data.ImageHighResolution
		or data.Image
		or data.Icon
		or data.Texture
		or fallback
		or (typeInfo and typeInfo.Image)
		or ""
end

local function sortByName(list)
	table.sort(list, function(a, b)
		return tostring(a.Name):lower() < tostring(b.Name):lower()
	end)
	return list
end

local function cosmeticMatchesWeapon(data, weapon)
	if not data then return false end
	local itemName = data.ItemName or data.WeaponName or data.Weapon or data.Item
	if itemName then
		return tostring(itemName):lower() == tostring(weapon or ""):lower()
	end
	return data.Type ~= "Skin"
end

local function rebuildCosmeticLists()
	table.clear(cosmeticGuiState.Weapons)
	table.clear(cosmeticGuiState.Cosmetics)

	for name, data in pairs(coss) do
		if not banned(name) and data.Type == "Weapon" then
			local dispName = displayName(name, data)
			local dispImg = iconFrom(data, ilib.Items and ilib.Items[name] and ilib.Items[name].Image, name)
			if equip[name] and equip[name].Skin then
				local skinData = equip[name].Skin
				dispName = displayName(skinData.Name, skinData)
				dispImg = iconFrom(skinData, nil, skinData.Name)
			end
			table.insert(cosmeticGuiState.Weapons, {
				Name = name,
				Display = dispName,
				Image = dispImg,
				Data = data
			})
		end
	end

	if #cosmeticGuiState.Weapons == 0 and ilib.ItemsAlphabetized then
		for _, name in ipairs(ilib.ItemsAlphabetized) do
			local data = ilib.Items and ilib.Items[name]
			if data and not banned(name) then
				local dispName = displayName(name, data)
				local dispImg = iconFrom(data, nil, name)
				if equip[name] and equip[name].Skin then
					local skinData = equip[name].Skin
					dispName = displayName(skinData.Name, skinData)
					dispImg = iconFrom(skinData, nil, skinData.Name)
				end
				table.insert(cosmeticGuiState.Weapons, {
					Name = name,
					Display = dispName,
					Image = dispImg,
					Data = data
				})
			end
		end
	end

	sortByName(cosmeticGuiState.Weapons)
	if not cosmeticGuiState.SelectedWeapon and cosmeticGuiState.Weapons[1] then
		cosmeticGuiState.SelectedWeapon = cosmeticGuiState.Weapons[1].Name
	end

	local mode = cosmeticGuiState.Mode
	for name, data in pairs(coss) do
		if not banned(name) and data.Type == mode and cosmeticMatchesWeapon(data, cosmeticGuiState.SelectedWeapon) then
			table.insert(cosmeticGuiState.Cosmetics, {
				Name = name,
				Display = displayName(name, data),
				Image = iconFrom(data, nil, name),
				Data = data
			})
		end
	end

	sortByName(cosmeticGuiState.Cosmetics)
end

local function forceCosmeticUpdate(weapon, ctype)
	task.spawn(function()
		saferep("CosmeticInventory")
		saferep("WeaponInventory")

		local selected = equip[weapon] and equip[weapon][ctype]
		local fighter = fctrl and fctrl:GetFighter(lp)
		if not fighter then return end
		local item
		for _, fighterItem in fighter.Items or {} do
			if fighterItem.Name == weapon then
				item = fighterItem
				break
			end
		end
		if not item then return end
		local wasEquipped = fighter.EquippedItem == item or item.IsEquipped == true

		local function refreshHotbar()
			local hotbar = fighter.FighterInterface and fighter.FighterInterface.Hotbar
			for _, hotbarSlot in pairs(hotbar and hotbar._hotbar_slots or {}) do
				if hotbarSlot.ClientItem == item then
					if hotbarSlot._Setup then
						pcall(hotbarSlot._Setup, hotbarSlot)
					end
					if hotbarSlot.UpdateVisuals then
						pcall(hotbarSlot.UpdateVisuals, hotbarSlot)
					end
					break
				end
			end
		end

		pcall(function()
			if item.Set then item:Set(ctype, selected) end
		end)
		pcall(function()
			if item.Data then item.Data[ctype] = selected end
		end)

		local rebuilt = false
		local oldViewModel = item.ViewModel
		if oldViewModel and oldViewModel._serial and replicatedClass and clientViewModelClass then
			local serial = table.clone(oldViewModel._serial)
			local dataKey = replicatedClass:ToEnum("Data")
			local data = table.clone(serial.Data or serial[dataKey] or {})
			serial[dataKey] = data
			serial.Data = nil

			local cosmetics = equip[weapon] or {}
			for _, cosmeticType in ipairs({"Skin", "Wrap", "Charm"}) do
				local cosmetic = cosmetics[cosmeticType]
				data[replicatedClass:ToEnum(cosmeticType)] = cosmetic
				data[cosmeticType] = nil
				if oldViewModel.Data then
					oldViewModel.Data[cosmeticType] = cosmetic
				end
			end
			local resolvedName = resolveViewModelName(weapon, cosmetics)
			data[replicatedClass:ToEnum("Name")] = resolvedName
			data.Name = nil

			local className = resolveViewModelClassName(weapon, cosmetics, resolvedName)
			local targetClass = resolveViewModelClass(className) or clientViewModelClass
			local identity = getthreadidentity and getthreadidentity() or 8
			constructingVirtualViewModelClass = targetClass ~= clientViewModelClass
			local ok, newViewModel = pcall(function()
				if setthreadidentity then pcall(setthreadidentity, 2) end
				return targetClass.new(serial, item)
			end)
			constructingVirtualViewModelClass = false
			if setthreadidentity then pcall(setthreadidentity, identity) end

			if (not ok or not isValidViewModel(newViewModel)) and resolvedName ~= weapon then
				if newViewModel and type(newViewModel) == "table" and newViewModel.Destroy then
					pcall(newViewModel.Destroy, newViewModel)
				end
				data[replicatedClass:ToEnum("Name")] = weapon
				data.Name = nil
				ok, newViewModel = pcall(function()
					if setthreadidentity then pcall(setthreadidentity, 2) end
					return (clientViewModelBaseNew or clientViewModelClass.new)(serial, item)
				end)
				if setthreadidentity then pcall(setthreadidentity, identity) end
			end

			if ok and isValidViewModel(newViewModel) then
				if wasEquipped and oldViewModel.Unequip then
					pcall(oldViewModel.Unequip, oldViewModel)
				end
				item.ViewModel = newViewModel
				if wasEquipped and newViewModel.Equip then
					pcall(newViewModel.Equip, newViewModel, true)
				end
				if oldViewModel ~= newViewModel and oldViewModel.Destroy then
					pcall(oldViewModel.Destroy, oldViewModel)
				end
				refreshHotbar()
				rebuilt = true
			elseif newViewModel and type(newViewModel) == "table" and newViewModel.Destroy then
				pcall(newViewModel.Destroy, newViewModel)
			end
		end

		local vm = item.ViewModel
		for _, obj in ipairs({item, vm}) do
			if obj then
				for _, method in ipairs({
					"_UpdateWrap",
					"UpdateWrap",
					"_UpdateCharm",
					"UpdateCharm",
					"_UpdateCosmetics",
					"UpdateCosmetics",
					"_RefreshViewModel",
					"RefreshViewModel",
					"UpdateViewModel"
				}) do
					if obj[method] then
						pcall(obj[method], obj)
					end
				end
			end
		end

		task.wait(0.1)
		saferep("WeaponInventory")
		refreshHotbar()
	end)
end

local function applyCosmeticToWeapon(weapon, cosmeticName, ctype, skipRebuild)
	if not weapon or weapon == "" then return end
	ctype = ctype or cosmeticGuiState.Mode
	equip[weapon] = equip[weapon] or {}

	if not cosmeticName or cosmeticName == "" or cosmeticName == "None" then
		equip[weapon][ctype] = nil
	else
		if cosmeticName == "__random" then
			local pool = cosmeticGuiState.Cosmetics
			local pick = pool[math.random(1, math.max(1, #pool))]
			cosmeticName = pick and pick.Name or nil
		end
		local cloned = cosmeticName and clonecos(cosmeticName, ctype)
		if cloned then
			equip[weapon][ctype] = cloned
			if ctype == "Finisher" then
				fcache[weapon] = cloned.Name
			end
		end
	end

	if equip[weapon] and not next(equip[weapon]) then
		equip[weapon] = nil
	end
	if not skipRebuild then
		rebuildinv()
		task.defer(function()
			saferep("CosmeticInventory")
			saferep("WeaponInventory")
			forceCosmeticUpdate(weapon, ctype)
		end)
	end
end

local function makeCosmeticChanger()
	if cosmeticGuiState.Gui then return cosmeticGuiState.Gui end
	rebuildCosmeticLists()

	local gui = Instance.new("Frame")
	gui.Name = "LionCosmeticChanger"
	gui.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	gui.BorderColor3 = Color3.fromRGB(45, 45, 45)
	gui.BorderSizePixel = 1
	gui.Position = UDim2.new(0.5, -410, 0.5, -420)
	gui.Size = UDim2.fromOffset(820, 840)
	gui.Visible = false
	gui.ZIndex = 900
	gui.Parent = mainapi.MainScreenGui
	cosmeticGuiState.Gui = gui

	makeDraggable(gui, mainapi.MainScreenGui.ClickGui)

	local title = Instance.new("TextLabel")
	title.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	title.BorderSizePixel = 0
	title.Font = Enum.Font.Code
	title.Text = "Cosmetic Changer"
	title.TextColor3 = Color3.fromRGB(235, 235, 235)
	title.TextSize = 16
	title.Size = UDim2.new(1, 0, 0, 32)
	title.ZIndex = 901
	title.Parent = gui

	local body = Instance.new("Frame")
	body.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	body.BorderColor3 = Color3.fromRGB(38, 38, 38)
	body.Position = UDim2.fromOffset(12, 42)
	body.Size = UDim2.new(1, -24, 1, -54)
	body.ZIndex = 901
	body.Parent = gui

	local function mkText(parent, text, pos, size, fontSize)
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.Code
		label.Text = text
		label.TextColor3 = Color3.fromRGB(235, 235, 235)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextSize = fontSize or 14
		label.Position = pos
		label.Size = size
		label.ZIndex = 902
		label.Parent = parent
		return label
	end

	local function mkBox(parent, placeholder, pos, size)
		local box = Instance.new("TextBox")
		box.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
		box.BorderColor3 = Color3.fromRGB(42, 42, 42)
		box.ClearTextOnFocus = false
		box.Font = Enum.Font.Code
		box.PlaceholderText = placeholder
		box.PlaceholderColor3 = Color3.fromRGB(155, 155, 155)
		box.Text = ""
		box.TextColor3 = Color3.fromRGB(220, 220, 220)
		box.TextSize = 14
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.Position = pos
		box.Size = size
		box.ZIndex = 902
		box.Parent = parent
		return box
	end

	local function mkButton(parent, text, pos, size)
		local btn = Instance.new("TextButton")
		btn.AutoButtonColor = false
		btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		btn.BorderColor3 = Color3.fromRGB(45, 45, 45)
		btn.Font = Enum.Font.Code
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(235, 235, 235)
		btn.TextSize = 14
		btn.Position = pos
		btn.Size = size
		btn.ZIndex = 902
		btn.Parent = parent
		return btn
	end

	local weaponGrid = Instance.new("ScrollingFrame")
	weaponGrid.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
	weaponGrid.BorderColor3 = Color3.fromRGB(35, 35, 35)
	weaponGrid.CanvasSize = UDim2.new()
	weaponGrid.ScrollBarThickness = 6
	weaponGrid.Position = UDim2.fromOffset(10, 54)
	weaponGrid.Size = UDim2.new(1, -20, 0, 264)
	weaponGrid.ZIndex = 902
	weaponGrid.Parent = body

	local cosmeticGrid = Instance.new("ScrollingFrame")
	cosmeticGrid.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
	cosmeticGrid.BorderColor3 = Color3.fromRGB(35, 35, 35)
	cosmeticGrid.CanvasSize = UDim2.new()
	cosmeticGrid.ScrollBarThickness = 6
	cosmeticGrid.Position = UDim2.fromOffset(10, 374)
	cosmeticGrid.Size = UDim2.new(1, -20, 0, 276)
	cosmeticGrid.ZIndex = 902
	cosmeticGrid.Parent = body

	mkText(body, "weapon filter", UDim2.fromOffset(10, 6), UDim2.new(1, -20, 0, 18))
	local weaponSearch = mkBox(body, "grenade launcher...", UDim2.fromOffset(10, 28), UDim2.new(1, -20, 0, 24))
	mkText(body, "cosmetic filter", UDim2.fromOffset(10, 326), UDim2.new(1, -20, 0, 18))
	local cosmeticSearch = mkBox(body, "red...", UDim2.fromOffset(10, 348), UDim2.new(1, -20, 0, 24))

	local modeButton = mkButton(body, "skin                                                                                  >", UDim2.fromOffset(10, 658), UDim2.new(1, -20, 0, 26))
	local modeMenu = Instance.new("Frame")
	modeMenu.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
	modeMenu.BorderColor3 = Color3.fromRGB(45, 45, 45)
	modeMenu.Position = UDim2.fromOffset(10, 684)
	modeMenu.Size = UDim2.new(1, -20, 0, 104)
	modeMenu.Visible = false
	modeMenu.ZIndex = 910
	modeMenu.Parent = body

	local modes = {"Skin", "Wrap", "Charm", "Finisher"}
	for i, mode in ipairs(modes) do
		local row = mkButton(modeMenu, mode:lower(), UDim2.fromOffset(0, (i - 1) * 26), UDim2.new(1, 0, 0, 26))
		row.ZIndex = 911
		row.TextXAlignment = Enum.TextXAlignment.Left
		row.MouseButton1Click:Connect(function()
			cosmeticGuiState.Mode = mode
			if cosmeticGuiState.SelectedWeapon then
				local currentEquip = equip[cosmeticGuiState.SelectedWeapon]
				if currentEquip and currentEquip[mode] then
					cosmeticGuiState.SelectedCosmetic = currentEquip[mode].Name
				else
					cosmeticGuiState.SelectedCosmetic = nil
				end
			else
				cosmeticGuiState.SelectedCosmetic = nil
			end
			modeButton.Text = mode:lower() .. "                                                                                  >"
			modeMenu.Visible = false
			rebuildCosmeticLists()
			task.defer(function()
				if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
			end)
		end)
	end

	local applyAll = mkButton(body, "apply selected to all", UDim2.fromOffset(10, 690), UDim2.new(1, -20, 0, 26))
	local reset = mkButton(body, "reset to defaults", UDim2.fromOffset(10, 720), UDim2.new(0.5, -12, 0, 26))
	local close = mkButton(body, "close", UDim2.new(0.5, 2, 0, 720), UDim2.new(0.5, -12, 0, 26))
	mkText(body, "right click a weapon to toggle the skin changer for it.", UDim2.fromOffset(10, 750), UDim2.new(1, -20, 0, 18), 12).TextColor3 = Color3.fromRGB(125, 125, 125)

	local function passes(entry, query)
		query = tostring(query or ""):lower()
		return query == "" or entry.Name:lower():find(query, 1, true) or entry.Display:lower():find(query, 1, true)
	end

	local function clearChildren(frame)
		for _, child in ipairs(frame:GetChildren()) do
			if child:IsA("GuiObject") then child:Destroy() end
		end
	end

	local function makeWrapPreview(parent, entry)
		local data = entry and entry.Data
		local groups = data and data.WrapGroups
		if not groups then return false end

		local viewport = Instance.new("ViewportFrame")
		viewport.BackgroundTransparency = 1
		viewport.Position = UDim2.fromOffset(2, 1)
		viewport.Size = UDim2.fromOffset(126, 90)
		viewport.LightColor = Color3.fromRGB(255, 255, 255)
		viewport.Ambient = Color3.fromRGB(180, 180, 180)
		viewport.ZIndex = 904
		viewport.Parent = parent

		local camera = Instance.new("Camera")
		camera.CFrame = CFrame.new(0, 0.15, 0.75) * CFrame.Angles(math.rad(-8), 0, 0)
		camera.Parent = viewport
		viewport.CurrentCamera = camera

		local model
		if wrapPreviewAsset then
			local ok, cloned = pcall(function()
				return wrapPreviewAsset:Clone()
			end)
			if ok and cloned then
				model = cloned
				model.Parent = viewport
			end
		end

		if model then
			for _, obj in ipairs(model:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.Anchored = true
					obj.CanCollide = false
				end
			end
			for _, obj in ipairs(model:GetDescendants()) do
				if obj:IsA("BasePart") then
					local wrapGroup = obj:GetAttribute("WrapGroup")
					local group = groups[wrapGroup] or groups[1] or {}
					if typeof(group.Color) == "Color3" then obj.Color = group.Color end
					if group.Transparency ~= nil then obj.Transparency = group.Transparency end
					if group.Reflectance ~= nil then obj.Reflectance = group.Reflectance end
					if group.Material then obj.Material = group.Material end
					pcall(function()
						obj.MaterialVariant = group.MaterialVariant or ""
					end)
					if obj:IsA("MeshPart") then
						pcall(function()
							obj.TextureID = ""
						end)
					end
					if group.Textures and wrapTextureAssets then
						local folder = wrapTextureAssets:FindFirstChild(group.Textures)
						if folder then
							for _, texture in ipairs(folder:GetChildren()) do
								pcall(function()
									local clonedTexture = texture:Clone()
									if clonedTexture.LocalTransparencyModifier ~= nil then
										clonedTexture.LocalTransparencyModifier = obj.LocalTransparencyModifier
									end
									clonedTexture.Parent = obj
								end)
							end
						end
					end
				end
			end
			pcall(function()
				model:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-10), math.rad(24), math.rad(-8)))
				local _, size = model:GetBoundingBox()
				local scale = math.max(size.X, size.Y, size.Z)
				camera.CFrame = CFrame.new(0, 0.05, math.clamp(scale * 0.41, 0.43, 1.15)) * CFrame.Angles(math.rad(-7), 0, 0)
			end)
			return true
		end

		model = Instance.new("Model")
		model.Name = "WrapPreview"
		model.Parent = viewport

		local sliceCount = math.max(1, math.min(3, #groups))
		for i = 1, sliceCount do
			local group = groups[i]
			local color = group and group.Color or Color3.fromRGB(150, 150, 150)
			if typeof(color) ~= "Color3" then color = Color3.fromRGB(150, 150, 150) end
			local slice = Instance.new("Part")
			slice.Anchored = true
			slice.CanCollide = false
			slice.Material = (group and group.Material) or Enum.Material.SmoothPlastic
			slice.Color = color
			slice.Transparency = group and group.Transparency or 0
			slice.Reflectance = group and group.Reflectance or 0
			slice.Size = Vector3.new(1.8 / sliceCount, 1.55, 0.22)
			slice.CFrame = CFrame.new((i - (sliceCount + 1) / 2) * (1.8 / sliceCount), 0, 0) * CFrame.Angles(0, math.rad(-18), math.rad(-8))
			slice.Parent = model
		end

		return true
	end

	local function makeCharmPreview(parent, entry)
		if not entry or not entry.Data or entry.Data.Type ~= "Charm" then return false end
		if charmAssets then
			local source = charmAssets:FindFirstChild(entry.Name)
			if source then
				local ok = pcall(function()
					local viewport = Instance.new("ViewportFrame")
					viewport.BackgroundTransparency = 1
					viewport.Position = UDim2.fromOffset(2, 1)
					viewport.Size = UDim2.fromOffset(126, 90)
					viewport.LightColor = Color3.fromRGB(255, 255, 255)
					viewport.Ambient = Color3.fromRGB(190, 190, 190)
					viewport.ZIndex = 904
					viewport.Parent = parent

					local camera = Instance.new("Camera")
					camera.CFrame = CFrame.new(0, 0, 0.2)
					camera.Parent = viewport
					viewport.CurrentCamera = camera

					local clone = source:Clone()
					clone.Parent = viewport
					local hook = clone:FindFirstChild("Hook", true)
					if hook then hook:Destroy() end

					if clone:IsA("Model") then
						local primary = clone.PrimaryPart or clone:FindFirstChild("Primary") or clone:FindFirstChildWhichIsA("BasePart", true)
						if primary then clone.PrimaryPart = primary end
						clone:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-12), math.rad(35), 0))
						local _, size = clone:GetBoundingBox()
						local scale = math.max(size.X, size.Y, size.Z)
						if scale > 0 then
							camera.CFrame = CFrame.new(0, 0, math.clamp(scale * 0.107, 0.113, 0.333))
						end
					elseif clone:IsA("BasePart") then
						clone.Anchored = true
						clone.CFrame = CFrame.new()
					end
				end)
				if ok then return true end
			end
		end

		local hash = 0
		for i = 1, #entry.Name do
			hash = (hash + string.byte(entry.Name, i) * i) % 255
		end
		local color = Color3.fromHSV(hash / 255, 0.65, 1)

		local badge = Instance.new("Frame")
		badge.BackgroundColor3 = color
		badge.BorderColor3 = Color3.fromRGB(235, 235, 235)
		badge.Position = UDim2.fromOffset(30, 8)
		badge.Size = UDim2.fromOffset(70, 70)
		badge.Rotation = 45
		badge.ZIndex = 904
		badge.Parent = parent

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = badge

		local text = Instance.new("TextLabel")
		text.BackgroundTransparency = 1
		text.Font = Enum.Font.SourceSansBold
		text.Text = string.sub(entry.Display or entry.Name or "C", 1, 1):upper()
		text.TextColor3 = Color3.fromRGB(255, 255, 255)
		text.TextScaled = true
		text.Rotation = -45
		text.Position = UDim2.fromOffset(10, 10)
		text.Size = UDim2.fromOffset(50, 50)
		text.ZIndex = 905
		text.Parent = badge
		return true
	end

	local function makeTile(parent, entry, index, selected, callback, rightCallback, largeWeaponPreview)
		local col = (index - 1) % cosmeticGuiState.Columns
		local row = math.floor((index - 1) / cosmeticGuiState.Columns)
		local tile = Instance.new("TextButton")
		tile.AutoButtonColor = false
		tile.BackgroundColor3 = selected and Color3.fromRGB(28, 44, 35) or Color3.fromRGB(20, 20, 20)
		tile.BorderColor3 = selected and Color3.fromRGB(70, 140, 95) or Color3.fromRGB(28, 28, 28)
		tile.Position = UDim2.fromOffset(col * cosmeticGuiState.TileW, row * cosmeticGuiState.TileH)
		tile.Size = UDim2.fromOffset(cosmeticGuiState.TileW, cosmeticGuiState.TileH)
		tile.ClipsDescendants = true
		tile.Text = ""
		tile.ZIndex = 903
		tile.Parent = parent

		local hasCustomPreview = false
		if not hasCustomPreview and (entry.Image == nil or entry.Image == "") and entry.Data and entry.Data.Type == "Wrap" then
			hasCustomPreview = makeWrapPreview(tile, entry)
		end
		if not hasCustomPreview and (entry.Image == nil or entry.Image == "") and entry.Data and entry.Data.Type == "Charm" then
			hasCustomPreview = makeCharmPreview(tile, entry)
		end
		if not hasCustomPreview then
			local img = Instance.new("ImageLabel")
			img.BackgroundTransparency = 1
			img.Image = entry.Image or ""
			img.ScaleType = Enum.ScaleType.Fit
			img.Position = largeWeaponPreview and UDim2.fromOffset(-61, -43) or UDim2.fromOffset(14, 9)
			img.Size = largeWeaponPreview and UDim2.fromOffset(252, 176) or UDim2.fromOffset(102, 76)
			img.ZIndex = 904
			img.Parent = tile
		end

		local name = Instance.new("TextLabel")
		name.BackgroundTransparency = 1
		name.Font = Enum.Font.SourceSansBold
		name.Text = entry.Display
		name.TextColor3 = Color3.fromRGB(245, 245, 245)
		name.TextScaled = true
		name.TextWrapped = true
		name.Position = UDim2.fromOffset(6, 86)
		name.Size = UDim2.fromOffset(118, 32)
		name.ZIndex = 904
		name.Parent = tile

		tile.MouseButton1Click:Connect(function()
			callback(entry)
		end)
		tile.MouseButton2Click:Connect(function()
			if rightCallback then rightCallback(entry) end
		end)
	end

	local function refresh()
		clearChildren(weaponGrid)
		clearChildren(cosmeticGrid)
		local wcount = 0
		for _, entry in ipairs(cosmeticGuiState.Weapons) do
			if passes(entry, cosmeticGuiState.WeaponSearch) then
				wcount += 1
				makeTile(weaponGrid, entry, wcount, cosmeticGuiState.SelectedWeapon == entry.Name, function(chosen)
					cosmeticGuiState.SelectedWeapon = chosen.Name
					local currentEquip = equip[chosen.Name]
					if currentEquip and currentEquip[cosmeticGuiState.Mode] then
						cosmeticGuiState.SelectedCosmetic = currentEquip[cosmeticGuiState.Mode].Name
					else
						cosmeticGuiState.SelectedCosmetic = nil
					end
					rebuildCosmeticLists()
					refresh()
				end, function(chosen)
					cosmeticGuiState.SelectedWeapon = chosen.Name
					applyCosmeticToWeapon(chosen.Name, cosmeticGuiState.SelectedCosmetic, cosmeticGuiState.Mode)
					rebuildCosmeticLists()
					refresh()
				end, true)
			end
		end
		weaponGrid.CanvasSize = UDim2.fromOffset(0, math.max(264, math.ceil(wcount / cosmeticGuiState.Columns) * cosmeticGuiState.TileH))

		local randomEntry = {Name = "__random", Display = "Random", Image = "rbxassetid://132973552546079"}
		makeTile(cosmeticGrid, randomEntry, 1, cosmeticGuiState.SelectedCosmetic == "__random", function()
			cosmeticGuiState.SelectedCosmetic = "__random"
			if cosmeticGuiState.SelectedWeapon then applyCosmeticToWeapon(cosmeticGuiState.SelectedWeapon, "__random", cosmeticGuiState.Mode) end
			rebuildCosmeticLists()
			refresh()
		end)

		local ccount = 1
		for _, entry in ipairs(cosmeticGuiState.Cosmetics) do
			if passes(entry, cosmeticGuiState.CosmeticSearch) then
				ccount += 1
				makeTile(cosmeticGrid, entry, ccount, cosmeticGuiState.SelectedCosmetic == entry.Name, function(chosen)
					cosmeticGuiState.SelectedCosmetic = chosen.Name
					if cosmeticGuiState.SelectedWeapon then applyCosmeticToWeapon(cosmeticGuiState.SelectedWeapon, chosen.Name, cosmeticGuiState.Mode) end
					rebuildCosmeticLists()
					refresh()
				end, nil, cosmeticGuiState.Mode == "Skin")
			end
		end
		cosmeticGrid.CanvasSize = UDim2.fromOffset(0, math.max(276, math.ceil(ccount / cosmeticGuiState.Columns) * cosmeticGuiState.TileH))
	end

	cosmeticGuiState.Refresh = refresh

	local wSearchThread, cSearchThread
	weaponSearch:GetPropertyChangedSignal("Text"):Connect(function()
		cosmeticGuiState.WeaponSearch = weaponSearch.Text
		if wSearchThread then task.cancel(wSearchThread) end
		wSearchThread = task.delay(0.1, refresh)
	end)
	cosmeticSearch:GetPropertyChangedSignal("Text"):Connect(function()
		cosmeticGuiState.CosmeticSearch = cosmeticSearch.Text
		if cSearchThread then task.cancel(cSearchThread) end
		cSearchThread = task.delay(0.1, refresh)
	end)
	modeButton.MouseButton1Click:Connect(function()
		modeMenu.Visible = not modeMenu.Visible
	end)
	applyAll.MouseButton1Click:Connect(function()
		local selected = cosmeticGuiState.SelectedCosmetic
		if not selected then return end
		for _, weapon in ipairs(cosmeticGuiState.Weapons) do
			applyCosmeticToWeapon(weapon.Name, selected, cosmeticGuiState.Mode, true)
			task.defer(forceCosmeticUpdate, weapon.Name, cosmeticGuiState.Mode)
		end
		rebuildinv()
		saferep("CosmeticInventory")
		saferep("WeaponInventory")
		rebuildCosmeticLists()
		refresh()
	end)
	reset.MouseButton1Click:Connect(function()
		table.clear(equip)
		table.clear(fcache)
		rebuildinv()
		saferep("WeaponInventory")
		rebuildCosmeticLists()
		refresh()
	end)
	close.MouseButton1Click:Connect(function()
		cosmeticGuiState.Wanted = false
		if shared.LionCosmeticChangerToggle and shared.LionCosmeticChangerToggle.Toggle then
			shared.LionCosmeticChangerToggle:Toggle(false)
		else
			gui.Visible = false
		end
	end)

	local nextCosmeticGuiUpdate = 0
	mainapi:Clean(RunService.Heartbeat:Connect(function()
		local now = os.clock()
		if now < nextCosmeticGuiUpdate then return end
		nextCosmeticGuiUpdate = now + 0.1
		local menuOpen = mainapi.ClickGuiStatus == true
		pcall(function()
			if LionWindow and LionWindow.Holder then
				menuOpen = LionWindow.Holder.Visible == true
			end
		end)
		gui.Visible = cosmeticGuiState.Wanted and menuOpen
	end))

	refresh()
	return gui
end

shared.LionCosmeticChanger = {
	SetVisible = function(visible)
		cosmeticGuiState.Wanted = visible == true
		makeCosmeticChanger()
		if visible then
			rebuildCosmeticLists()
			if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
		end
	end,
	Toggle = function()
		cosmeticGuiState.Wanted = not cosmeticGuiState.Wanted
		makeCosmeticChanger()
		rebuildCosmeticLists()
		if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
	end,
	Refresh = function()
		rebuildCosmeticLists()
		if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
	end,
	GetEquipData = function()
		local export = {}
		for w, cats in pairs(equip) do
			export[w] = {}
			for cat, data in pairs(cats) do
				export[w][cat] = data and data.Name or nil
			end
		end
		return export
	end,
	LoadEquipData = function(data)
		if type(data) ~= "table" then return end
		for w, cats in pairs(data) do
			if type(cats) == "table" then
				for cat, name in pairs(cats) do
					applyCosmeticToWeapon(w, name, cat, true)
					task.defer(function()
						pcall(forceCosmeticUpdate, w, cat)
					end)
				end
			end
		end
		rebuildinv()
		saferep("CosmeticInventory")
		saferep("WeaponInventory")
		if cosmeticGuiState.SelectedWeapon then
			local currentEquip = equip[cosmeticGuiState.SelectedWeapon]
			if currentEquip and currentEquip[cosmeticGuiState.Mode] then
				cosmeticGuiState.SelectedCosmetic = currentEquip[cosmeticGuiState.Mode].Name
			else
				cosmeticGuiState.SelectedCosmetic = nil
			end
		end
		rebuildCosmeticLists()
		if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
	end,
	Apply = applyCosmeticToWeapon,
	State = cosmeticGuiState
}

end)


run(function()
	local ThirdPerson
	local ThirdPersonMode
	local UnlockMouse

	ThirdPerson = Player:AddModule({
		Name = 'Third Person',
		Function = function(callback)
			local p = cloneref(game:GetService('Players'))
			local cam = require(LocalPlayer.PlayerScripts.Controllers.CameraController)
            local gun = require(LocalPlayer.PlayerScripts.Controllers.CameraController)
            local camstate = require(game:GetService("Players").LocalPlayer.PlayerScripts.Controllers.CameraController.CameraState)
			local UIS = game:GetService("UserInputService")

			if callback then
				-- ???????? 땟戮녹???????? 멤 ????
				ThirdPerson.Connection = task.spawn(function()
					while ThirdPerson.Enabled do
						local mode = ThirdPersonMode.Value

						if mode == "ThirdPerson" then
							gun.CameraState:_SetPOVState(gun.CameraState.States.ThirdPerson)

						elseif mode == "ThirdPerson Mirrored" then
							gun.CameraState:_SetPOVState(gun.CameraState.States.ThirdPersonMirrored)
						end

						if UnlockMouse.Enabled then
							UIS.MouseBehavior = Enum.MouseBehavior.Default
						end

						task.wait(0.1)
					end
				end)

			else
				-- ??????????? 멤 ??????????? 틢??+ ????? 뮛?筌 ? ??  ?袁⑦????
				if ThirdPerson.Connection then
					task.cancel(ThirdPerson.Connection)
					ThirdPerson.Connection = nil
				end

				gun.CameraState:_SetPOVState(gun.CameraState.States.FirstPerson)
				UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
			end
		end
	})

	-- ???Dropdown
	ThirdPersonMode = ThirdPerson:AddDropdown({
		Name = 'Mode',
		List = {"ThirdPerson", "ThirdPerson Mirrored"},
		Default = "ThirdPerson"
	})

	-- ???Toggle
	UnlockMouse = ThirdPerson:AddToggle({
		Name = 'Unlock Mouse',
		Default = false
	})
end)

run(function()
    local Triggerbot
    local ReactionTime
    local ReactionOffset
    local ForgetTime
    local ShootDelay
    local MaxDistance
    local PartBlacklist
    local Settings
    local ScopedWeapons

    local players = cloneref(game:GetService("Players"))
    local rs = cloneref(game:GetService("ReplicatedStorage"))
    local runService = cloneref(game:GetService("RunService"))
    local workspace = cloneref(game:GetService("Workspace"))
    local lplr = players.LocalPlayer
    local camera = workspace.CurrentCamera
    local enums
    local fighterController
    pcall(function() enums = require(rs.Modules.EnumLibrary) end)
    pcall(function() fighterController = require(lplr.PlayerScripts.Controllers.FighterController) end)

    local R15Parts = {
        "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
        "RightUpperLeg", "RightLowerLeg", "RightFoot",
        "HitboxHead", "HitboxHeadSmall", "PhysicalHitboxHead",
        "HitboxBody", "HitboxBodySmall", "FakeMass",
    }

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true

    local lockedTarget
    local lockedPart
    local candidateTarget
    local candidateSince = 0
    local lastSeen = 0
    local lastShot = 0
    local shooting = false

    local function getFighter()
        if not fighterController then
            pcall(function()
                fighterController = require(lplr.PlayerScripts.Controllers.FighterController)
            end)
        end
        if not fighterController then return nil end
        return fighterController.LocalFighter or (fighterController.GetFighter and fighterController:GetFighter(lplr))
    end

    local function getItemName(item)
        if not item then return "" end
        local name = item.Name or ""
        pcall(function()
            name = item:Get("Name") or name
        end)
        pcall(function()
            name = item.Info and item.Info.Name or name
        end)
        return tostring(name)
    end

    local function isScopedEnough(item)
        local selected = ScopedWeapons and ScopedWeapons.Value or {}
        local itemName = getItemName(item)
        if not selected[itemName] then return true end
        local aiming = false
        pcall(function()
            aiming = item:Get("IsAiming") == true
        end)
        pcall(function()
            aiming = aiming or (type(item.IsFullyAiming) == "function" and item:IsFullyAiming() == true)
        end)
        pcall(function()
            aiming = aiming or (item.ItemInterface and item.ItemInterface.IsScopeActive and item.ItemInterface:IsScopeActive() == true)
        end)
        pcall(function()
            aiming = aiming or (item.ViewModel and item.Info and item.Info.AimScopePercent and item.ViewModel.CurrentAimValue >= item.Info.AimScopePercent)
        end)
        return aiming
    end

    local function isEnemyCharacter(char)
        if not char or char == lplr.Character then return false end
        local player = players:GetPlayerFromCharacter(char)
        if not player or player == lplr then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        return hum and hum.Health > 0
    end

    local function partAllowed(part)
        if not part or not part:IsA("BasePart") then return false end
        local blacklist = PartBlacklist and PartBlacklist.Value or {}
        return not blacklist[part.Name]
    end

    local function getCharacterFromPart(part)
        local node = part
        while node and node ~= workspace do
            if node:IsA("Model") and node:FindFirstChildOfClass("Humanoid") then
                return node
            end
            node = node.Parent
        end
    end

    local function isKatanaBlocked(char)
        local settings = Settings and Settings.Value or {}
        if not settings["anti katana"] then return false end
        local blocker = rawget(_G, "ShouldBlockShotForKatana")
        if type(blocker) == "function" then
            local ok, blocked = pcall(blocker, char)
            if ok and blocked then return true end
        end
        return false
    end

    local function getTarget()
        camera = workspace.CurrentCamera or camera
        if not camera or not lplr.Character then return nil, nil end

        local viewport = camera.ViewportSize
        local origin2d = Vector2.new(viewport.X / 2, viewport.Y / 2)
        local ray = camera:ViewportPointToRay(origin2d.X, origin2d.Y)
        local filter = {lplr.Character, camera}
        local viewModels = workspace:FindFirstChild("ViewModels")
        if viewModels then
            table.insert(filter, viewModels)
        end
        rayParams.FilterDescendantsInstances = filter

        local result = workspace:Raycast(ray.Origin, ray.Direction * (MaxDistance and MaxDistance.Value or 100), rayParams)
        if not result or not result.Instance or not partAllowed(result.Instance) then return nil, nil end

        local char = getCharacterFromPart(result.Instance)
        if not isEnemyCharacter(char) then return nil, nil end
        if isKatanaBlocked(char) then return nil, nil end

        return char, result.Instance
    end

    local function getStableTarget()
        local target, part = getTarget()
        local now = tick()
        if target then
            if target ~= candidateTarget then
                candidateTarget = target
                candidateSince = now
            end

            local offset = ReactionOffset and ReactionOffset.Value or 0
            local reaction = math.max(0, (ReactionTime and ReactionTime.Value or 0) + offset) / 1000
            local settings = Settings and Settings.Value or {}
            if settings["no delay between targets"] or target == lockedTarget or now - candidateSince >= reaction then
                lockedTarget = target
                lockedPart = part
                lastSeen = now
            end
        else
            candidateTarget = nil
        end

        local forget = ForgetTime and ForgetTime.Value or 0
        if lockedTarget and now - lastSeen <= forget then
            local hum = lockedTarget:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and lockedPart and lockedPart.Parent then
                return lockedTarget, lockedPart
            end
        end

        lockedTarget = nil
        lockedPart = nil
        return nil, nil
    end


    local function tryShoot()
        if shooting then return end
        local fighter = getFighter()
        local item = fighter and fighter.EquippedItem
        if not item or not isScopedEnough(item) then return end

        shooting = true
        if mouse1click and (isrbxactive or iswindowactive)() then
            mouse1click()
        end
        task.delay(0.05, function()
            shooting = false
        end)
    end

    Triggerbot = Combat:AddModule({
        Name = "Triggerbot",
        Function = function(callback)
            lockedTarget = nil
            lockedPart = nil
            candidateTarget = nil
            if callback then
                Triggerbot:Clean(runService.Heartbeat:Connect(function()
                    if mainapi.ClickGuiStatus then return end
                    local target = getStableTarget()
                    if not target then return end
                    local delay = (ShootDelay and ShootDelay.Value or 0) / 1000
                    if tick() - lastShot < delay then return end
                    lastShot = tick()
                    tryShoot()
                end))
            end
        end
    })

    ReactionTime = Triggerbot:AddSlider({
        Name = "reaction time",
        Min = 0,
        Max = 300,
        Default = 100,
        Suffix = "ms"
    })

    ReactionOffset = Triggerbot:AddSlider({
        Name = "reaction time offset",
        Min = 0,
        Max = 100,
        Default = 0,
        Suffix = "ms"
    })

    ForgetTime = Triggerbot:AddSlider({
        Name = "forget time",
        Min = 0,
        Max = 10,
        Default = 0.5,
        Decimal = 10,
        Suffix = "s"
    })

    ShootDelay = Triggerbot:AddSlider({
        Name = "shoot delay",
        Min = 0,
        Max = 300,
        Default = 0,
        Suffix = "ms"
    })

    MaxDistance = Triggerbot:AddSlider({
        Name = "max distance",
        Min = 25,
        Max = 500,
        Default = 100,
        Suffix = "s"
    })

    PartBlacklist = Triggerbot:AddDropdown({
        Name = "part blacklist",
        List = R15Parts,
        Default = {},
        Multi = true
    })

    Settings = Triggerbot:AddDropdown({
        Name = "settings",
        List = {"no delay between targets", "anti katana"},
        Default = {["no delay between targets"] = true, ["anti katana"] = true},
        Multi = true
    })

    ScopedWeapons = Triggerbot:AddDropdown({
        Name = "check scoped if",
        List = {"Sniper", "Crossbow"},
        Default = {Sniper = true, Crossbow = true},
        Multi = true
    })
end)

run(function()

    local Weapons
    local NoSpread
    local FastShootToggle
    local FastProjectile
    local FullAuto
    local AlwaysBackstab
    local GrenadeOptions
    local FireRate
    local Players = cloneref(game:GetService("Players"))
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
    local UserInputService = cloneref(game:GetService("UserInputService"))

    local weaponState = getgenv().__LionWeaponOptionsState
    if weaponState and weaponState.Restore then
        pcall(weaponState.Restore)
    end
    if weaponState and weaponState.UseItemRemote and weaponState.OriginalFireServer and hookfunction then
        pcall(function()
            hookfunction(weaponState.UseItemRemote.FireServer, weaponState.OriginalFireServer)
        end)
    end

    weaponState = {
        Enabled = false,
        Installed = false,
        NoSpread = false,
        FastShoot = false,
        FastProjectile = false,
        FullAuto = false,
        AlwaysBackstab = false,
        GrenadeOptions = {},
        FireRate = 100,
        InfoCache = setmetatable({}, {__mode = "k"}),
        ProjectileReloadCache = setmetatable({}, {__mode = "k"}),
        FullAutoItems = setmetatable({}, {__mode = "k"}),
        Connections = {},
    }
    getgenv().__LionWeaponOptionsState = weaponState

    local function stopBackstabCameraLoop(loopId)
        if _G.CurrentCameraLoopID == loopId then
            _G.CurrentCameraLoopID = (_G.CurrentCameraLoopID or 0) + 1
        end
    end

    local function startBackstabCameraLoop(duration)
        if not weaponState.Utility or not weaponState.CameraController or not weaponState.UpdateCameraRotation then return end

        _G.CurrentCameraLoopID = (_G.CurrentCameraLoopID or 0) + 1
        local myLoopID = _G.CurrentCameraLoopID
        local targetPitch = math.rad(0)
        local sideAngle = math.rad(180)

        task.spawn(function()
            while _G.CurrentCameraLoopID == myLoopID
                and weaponState.Enabled
                and weaponState.AlwaysBackstab do
                local yaw = weaponState.CameraController.Rotation and weaponState.CameraController.Rotation.Y or 0
                local cameraRotation = Vector2.new(targetPitch, yaw + sideAngle)
                local encodedRotation = weaponState.Utility:EncodeCameraRotation(cameraRotation)
                weaponState.UpdateCameraRotation:FireServer(encodedRotation, nil)
                task.wait()
            end
        end)

        task.delay(duration or 0.35, function()
            stopBackstabCameraLoop(myLoopID)
        end)
    end

    local function optionEnabled(name)
        if not weaponState.Enabled or not weaponState.GrenadeOptions then return false end
        if weaponState.GrenadeOptions[name] == true then return true end
        for _, value in pairs(weaponState.GrenadeOptions) do
            if value == name then
                return true
            end
        end
        return false
    end

    local function hasInfoOptions()
        return weaponState.FastShoot
            or weaponState.FireRate ~= 100
    end

    local function rememberInfo(info, key)
        if type(info) ~= "table" or info[key] == nil then return nil end
        local cache = weaponState.InfoCache[info]
        if not cache then
            cache = {}
            weaponState.InfoCache[info] = cache
        end
        if cache[key] == nil then
            cache[key] = info[key]
        end
        return cache[key]
    end

    local function applyInfoOptions(item)
        local info = item and item.Info
        if type(info) ~= "table" then return end

        local fireRate = math.max((weaponState.FireRate or 100) / 100, 0.01)
        local fastShoot = weaponState.Enabled and weaponState.FastShoot

        local recoil = rememberInfo(info, "ShootRecoil")
        if recoil ~= nil then info.ShootRecoil = fastShoot and 0 or recoil end

        local spread = rememberInfo(info, "ShootSpread")
        if spread ~= nil then info.ShootSpread = fastShoot and 0 or spread end

        local projectileSpeed = rememberInfo(info, "ProjectileSpeed")
        if projectileSpeed ~= nil and fastShoot then
            info.ProjectileSpeed = 99999999
        elseif projectileSpeed ~= nil then
            info.ProjectileSpeed = projectileSpeed
        end

        for _, key in ipairs({
            "ShootCooldown",
            "QuickShotCooldown",
            "SpinCooldown",
            "DashCooldown",
            "Cooldown",
            "BuildCooldown",
            "AttackCooldown",
            "HeavyAttackCooldown",
            "BurstCooldown",
        }) do
            local original = rememberInfo(info, key)
            if original ~= nil then
                if fastShoot then
                    info[key] = 0
                elseif fireRate ~= 1 and (key == "ShootCooldown" or key == "QuickShotCooldown" or key == "BurstCooldown" or key == "AttackCooldown") then
                    info[key] = original / fireRate
                else
                    info[key] = original
                end
            end
        end

    end

    local function refreshCachedInfo()
        for info in pairs(weaponState.InfoCache) do
            applyInfoOptions({Info = info})
        end
    end

    local function restoreInfo()
        for info, values in pairs(weaponState.InfoCache) do
            if type(info) == "table" then
                for key, value in pairs(values) do
                    pcall(function()
                        info[key] = value
                    end)
                end
            end
        end
    end

    local function restoreFastProjectile()
        for item, reloadLength in pairs(weaponState.ProjectileReloadCache) do
            if type(item) == "table" then
                pcall(rawset, item, "ReloadLength", reloadLength)
            end
        end
    end

    local function applyFastProjectile()
        if not (weaponState.Enabled and weaponState.FastProjectile) then
            restoreFastProjectile()
            return
        end

        pcall(function()
            local ItemLibrary = require(ReplicatedStorage.Modules.ItemLibrary)
            local Items = rawget(ItemLibrary, "Items")
            if not Items then return end

            local whitelistedItems = {"Bow", "Daggers", "Slingshot"}
            for _, item in Items do
                local name = item.Name
                if table.find(whitelistedItems, name) and rawget(item, "ReloadLength") ~= nil then
                    if weaponState.ProjectileReloadCache[item] == nil then
                        weaponState.ProjectileReloadCache[item] = rawget(item, "ReloadLength")
                    end
                    rawset(item, "ReloadLength", name == "Daggers" and 0.09 or 0)
                end
            end
        end)
    end

    local function isLocalItem(item)
        local fighter = item and item.ClientFighter
        if not fighter then return false end
        if fighter.IsLocalPlayer == true then return true end
        return fighter.Player == LocalPlayer
    end

    local function actionName(item, action)
        local name = tostring(action)
        pcall(function()
            if item and type(item.FromEnum) == "function" then
                name = tostring(item:FromEnum(action))
            elseif weaponState.Enums and type(weaponState.Enums.FromEnum) == "function" then
                name = tostring(weaponState.Enums:FromEnum(action))
            end
        end)
        return name
    end

    local function getEquippedItemByObjectId(objectId)
        local fighter = nil
        pcall(function()
            fighter = weaponState.FighterController.LocalFighter or weaponState.FighterController:GetFighter(LocalPlayer)
        end)
        if not fighter then return nil end
        if fighter.EquippedItem and fighter.EquippedItem.Get and fighter.EquippedItem:Get("ObjectID") == objectId then
            return fighter.EquippedItem
        end
        for _, item in pairs(fighter.Items or {}) do
            if item.Get and item:Get("ObjectID") == objectId then
                return item
            end
        end
        return nil
    end

    local function isThrowableItem(item)
        local info = item and item.Info
        if type(info) ~= "table" then return false end
        return info.DetonateDelay ~= nil
            or info.ThrowForceMin ~= nil
            or info.LobForceMin ~= nil
    end

    local function estimateImpactFuse(item, action, cameraCFrame, charge)
        if typeof(cameraCFrame) ~= "CFrame" or type(item) ~= "table" or type(item.Info) ~= "table" then
            return nil
        end

        local info = item.Info
        local name = actionName(item, action)
        local isLob = name == "FinishAiming"
        local minForce = isLob and info.LobForceMin or info.ThrowForceMin
        local maxForce = isLob and info.LobForceMax or info.ThrowForceMax
        local gravity = isLob and info.LobGravity or info.ThrowGravity
        if type(minForce) ~= "number" or type(maxForce) ~= "number" then
            return nil
        end

        local power = math.clamp(tonumber(charge) or 1, 0, 1)
        local speed = minForce + (maxForce - minForce) * power
        local velocity = cameraCFrame.LookVector * speed
        local position = cameraCFrame.Position
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, workspace:FindFirstChild("ViewModels")}
        local last = position
        local grav = Vector3.new(0, -(gravity or workspace.Gravity), 0)

        for t = 0.03, 5, 0.03 do
            local nextPos = position + velocity * t + grav * (0.5 * t * t)
            local result = workspace:Raycast(last, nextPos - last, rayParams)
            if result then
                return math.max(t - 0.015, 0)
            end
            last = nextPos
        end

        return nil
    end

    local function getFullAutoDelay(item)
        local remaining = type(item._shoot_cooldown) == "number"
            and math.max(item._shoot_cooldown - tick(), 0)
            or 0
        if remaining > 0 then
            return math.clamp(remaining, 0.01, 1)
        end

        local info = item.Info
        local cooldown = info and tonumber(info.ShootCooldown) or 0
        if info and tonumber(info.BurstCount) and info.BurstCount > 1 then
            cooldown = tonumber(info.BurstCooldown) or cooldown
        end
        return math.clamp(cooldown > 0 and cooldown or (1 / 60), 1 / 60, 1)
    end

    local function startFullAuto(item, input)
        if weaponState.FullAutoItems[item] then return end
        weaponState.FullAutoItems[item] = true
        task.spawn(function()
            while weaponState.Enabled
                and weaponState.FullAuto
                and item
                and isLocalItem(item)
                and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                task.wait(getFullAutoDelay(item))
                if not (weaponState.Enabled
                    and weaponState.FullAuto
                    and isLocalItem(item)
                    and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
                    break
                end
                pcall(function()
                    weaponState.OriginalInput(item, input)
                end)
            end
            weaponState.FullAutoItems[item] = nil
        end)
    end

    local function installWeaponHooks()
        if weaponState.Installed then return end

        local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
        local modules = PlayerScripts:WaitForChild("Modules")
        local itemTypes = modules:WaitForChild("ItemTypes")

        weaponState.ClientItem = require(modules.ClientReplicatedClasses.ClientFighter.ClientItem)
        weaponState.GunItem = require(itemTypes:WaitForChild("Gun"))
        weaponState.GrenadeItem = require(itemTypes:FindFirstChild("Throwable") or itemTypes:FindFirstChild("Grenade"))
        weaponState.MeleeItem = require(itemTypes:FindFirstChild("Melee") or itemTypes:FindFirstChild("Knife"))
        weaponState.KnifeItem = require(modules.Items:WaitForChild("Knife"))
        weaponState.Utility = require(ReplicatedStorage.Modules.Utility)
        weaponState.CameraController = require(PlayerScripts.Controllers.CameraController)
        weaponState.Enums = require(ReplicatedStorage.Modules.EnumLibrary)
        weaponState.FighterController = require(PlayerScripts.Controllers.FighterController)
        weaponState.UseItemRemote = ReplicatedStorage.Remotes.Replication.Fighter.UseItem
        weaponState.UpdateCameraRotation = ReplicatedStorage.Remotes.Replication.Fighter.UpdateCameraRotation

        weaponState.OriginalInput = weaponState.ClientItem.Input
        weaponState.ClientItem.Input = function(self, input, ...)
            if hasInfoOptions() and isLocalItem(self) then
                applyInfoOptions(self)
            end
            local result = {weaponState.OriginalInput(self, input, ...)}
            if weaponState.Enabled and weaponState.FullAuto and input == "StartShooting" and isLocalItem(self) then
                startFullAuto(self, input)
            end
            return unpack(result)
        end

        weaponState.OriginalGunStartShooting = weaponState.GunItem.StartShooting
        weaponState.GunItem.StartShooting = function(self, ...)
            if hasInfoOptions() and isLocalItem(self) then
                applyInfoOptions(self)
            end
            local result = {weaponState.OriginalGunStartShooting(self, ...)}
            if weaponState.Enabled and weaponState.NoSpread and isLocalItem(self) and typeof(result[3]) == "table" then
                result[4] = true
            end
            return unpack(result)
        end

        weaponState.OriginalMeleeStartShooting = weaponState.MeleeItem.StartShooting
        weaponState.MeleeItem.StartShooting = function(self, ...)
            if hasInfoOptions() and isLocalItem(self) then
                applyInfoOptions(self)
            end
            return weaponState.OriginalMeleeStartShooting(self, ...)
        end

        local function applyGrenadeResultOptions(self, result)
            if not (weaponState.Enabled and isLocalItem(self) and isThrowableItem(self) and result[1]) then
                return result
            end

            local action = result[2]
            if action ~= "FinishShooting" and action ~= "FinishAiming" then
                return result
            end

            if optionEnabled("Explode On Throw") then
                result[5] = 0.15
            elseif optionEnabled("Explode On Impact") then
                result[5] = estimateImpactFuse(self, action, result[3], result[4]) or result[5]
            elseif optionEnabled("Remove Fuse") then
                result[5] = 999999
            end

            return result
        end

        weaponState.OriginalGrenadeFinishShooting = weaponState.GrenadeItem.FinishShooting
        weaponState.GrenadeItem.FinishShooting = function(self, ...)
            local result = {weaponState.OriginalGrenadeFinishShooting(self, ...)}
            result = applyGrenadeResultOptions(self, result)
            return unpack(result)
        end

        weaponState.OriginalGrenadeFinishAiming = weaponState.GrenadeItem.FinishAiming
        weaponState.GrenadeItem.FinishAiming = function(self, ...)
            local result = {weaponState.OriginalGrenadeFinishAiming(self, ...)}
            result = applyGrenadeResultOptions(self, result)
            return unpack(result)
        end

        weaponState.OriginalKnifeStartAiming = weaponState.KnifeItem.StartAiming
        weaponState.KnifeItem.StartAiming = function(self, ...)
            if hasInfoOptions() and isLocalItem(self) then
                applyInfoOptions(self)
            end
            if weaponState.Enabled and weaponState.AlwaysBackstab and isLocalItem(self) then
                startBackstabCameraLoop(math.max((self.Info and self.Info.AttackDelay) or 0.35, 0.35))
            end
            return weaponState.OriginalKnifeStartAiming(self, ...)
        end

        weaponState.Restore = function()
            weaponState.Enabled = false
            _G.CurrentCameraLoopID = (_G.CurrentCameraLoopID or 0) + 1
            restoreInfo()
            restoreFastProjectile()
            for _, conn in pairs(weaponState.Connections) do
                pcall(function() conn:Disconnect() end)
            end
            if weaponState.ClientItem and weaponState.OriginalInput then
                weaponState.ClientItem.Input = weaponState.OriginalInput
            end
            if weaponState.GunItem and weaponState.OriginalGunStartShooting then
                weaponState.GunItem.StartShooting = weaponState.OriginalGunStartShooting
            end
            if weaponState.MeleeItem and weaponState.OriginalMeleeStartShooting then
                weaponState.MeleeItem.StartShooting = weaponState.OriginalMeleeStartShooting
            end
            if weaponState.GrenadeItem and weaponState.OriginalGrenadeFinishShooting then
                weaponState.GrenadeItem.FinishShooting = weaponState.OriginalGrenadeFinishShooting
            end
            if weaponState.GrenadeItem and weaponState.OriginalGrenadeFinishAiming then
                weaponState.GrenadeItem.FinishAiming = weaponState.OriginalGrenadeFinishAiming
            end
            if weaponState.KnifeItem and weaponState.OriginalKnifeStartAiming then
                weaponState.KnifeItem.StartAiming = weaponState.OriginalKnifeStartAiming
            end
            if weaponState.UseItemRemote and weaponState.OriginalFireServer and hookfunction then
                pcall(function()
                    hookfunction(weaponState.UseItemRemote.FireServer, weaponState.OriginalFireServer)
                end)
            end
        end

        weaponState.Installed = true
    end

    local function updateWeaponState()
        weaponState.NoSpread = NoSpread and NoSpread.Enabled or false
        weaponState.FastShoot = FastShootToggle and FastShootToggle.Enabled or false
        weaponState.FastProjectile = FastProjectile and FastProjectile.Enabled or false
        weaponState.FullAuto = FullAuto and FullAuto.Enabled or false
        weaponState.AlwaysBackstab = AlwaysBackstab and AlwaysBackstab.Enabled or false
        weaponState.GrenadeOptions = GrenadeOptions and GrenadeOptions.Value or {}
        weaponState.FireRate = FireRate and FireRate.Value or 100

        local enabled = weaponState.NoSpread
            or weaponState.FastShoot
            or weaponState.FastProjectile
            or weaponState.FullAuto
            or weaponState.AlwaysBackstab
            or next(weaponState.GrenadeOptions) ~= nil
            or weaponState.FireRate ~= 100

        if Weapons and Weapons.Enabled ~= enabled then
            Weapons:Toggle(enabled)
        elseif enabled then
            installWeaponHooks()
            weaponState.Enabled = true
            refreshCachedInfo()
            applyFastProjectile()
        else
            weaponState.Enabled = false
            _G.CurrentCameraLoopID = (_G.CurrentCameraLoopID or 0) + 1
            restoreInfo()
            restoreFastProjectile()
        end
    end

    Weapons = Combat:AddModule({
        Name = "Weapons",
        HideEnabled = true,
        Function = function(callback)
            weaponState.Enabled = callback == true
            if callback then
                installWeaponHooks()
                applyFastProjectile()
            else
                _G.CurrentCameraLoopID = (_G.CurrentCameraLoopID or 0) + 1
                restoreInfo()
                restoreFastProjectile()
            end
        end
    })

    NoSpread = Weapons:AddToggle({Name = "no spread", Function = updateWeaponState})
    FastShootToggle = Weapons:AddToggle({Name = "fastshoot", Function = updateWeaponState})
    FastProjectile = Weapons:AddToggle({Name = "fast projectile", Function = updateWeaponState})
    FullAuto = Weapons:AddToggle({Name = "full auto", Function = updateWeaponState})
    AlwaysBackstab = Weapons:AddToggle({Name = "always backstab", Function = updateWeaponState})
    GrenadeOptions = Weapons:AddDropdown({
        Name = "grenade options",
        List = {"Explode On Impact", "Explode On Throw", "Remove Fuse"},
        Default = {},
        Multi = true,
        Function = updateWeaponState
    })
    FireRate = Weapons:AddSlider({
        Name = "firerate",
        Min = 1,
        Max = 100,
        Default = 100,
        Suffix = "%",
        Function = updateWeaponState
    })
end)

run(function()

	local ViewmodelResizer
	local Size
	local trackedParts = {}
	local hookedFolders = {}
	local originalSizes = {}
	local originalCFrames = {}
	local originalPivots = {}
	local pendingScaleModels = {}
	local Players = cloneref(game:GetService("Players"))
	local player = Players.LocalPlayer

	local function isLocalViewmodel(model)
		if not model or not model:IsA("Model") then return false end
		local prefix = player.Name .. " - "
		return model.Name:sub(1, #prefix) == prefix
	end

	local function findLocalViewmodel(inst)
		local current = inst
		while current and current ~= workspace do
			if isLocalViewmodel(current) then
				return current
			end
			current = current.Parent
		end
		return nil
	end

	local function scaleModelProper(model)
		if not ViewmodelResizer.Enabled or not isLocalViewmodel(model) then return end

		local multiplier = Size and Size.Value or 1
		local pivot = originalPivots[model]
		if not pivot then
			pivot = model:GetPivot()
			originalPivots[model] = pivot
		end

		for _, part in ipairs(model:GetDescendants()) do
			if part:IsA("BasePart") then
				local origSize = originalSizes[part]
				local origCF = originalCFrames[part]

				if not origSize then
					origSize = part.Size
					originalSizes[part] = origSize
				end

				if not origCF then
					origCF = part.CFrame
					originalCFrames[part] = origCF
				end

				local relative = pivot:ToObjectSpace(origCF)
				part.Size = origSize * multiplier
				part.CFrame = pivot * CFrame.new(relative.Position * multiplier) * (relative - relative.Position)
				trackedParts[part] = true
			end
		end
	end

	local function queueScaleModel(model)
		if pendingScaleModels[model] then return end
		pendingScaleModels[model] = true
		task.defer(function()
			pendingScaleModels[model] = nil
			if model and model.Parent then
				scaleModelProper(model)
			end
		end)
	end

	local function restoreAll()
		for part in pairs(trackedParts) do
			if part and part.Parent then
				local origSize = originalSizes[part]
				local origCF = originalCFrames[part]
				if origSize then
					part.Size = origSize
				end
				if origCF then
					part.CFrame = origCF
				end
			end
		end
		table.clear(trackedParts)
		table.clear(originalSizes)
		table.clear(originalCFrames)
		table.clear(originalPivots)
		table.clear(pendingScaleModels)
	end

	local function scaleAll(folder)
		for _, v in ipairs(folder:GetDescendants()) do
			if isLocalViewmodel(v) then
				scaleModelProper(v)
			end
		end
	end

	local function hook(folder)
		if hookedFolders[folder] then return end
		hookedFolders[folder] = true
		scaleAll(folder)

		ViewmodelResizer:Clean(folder.DescendantAdded:Connect(function(inst)
			local model = isLocalViewmodel(inst) and inst or findLocalViewmodel(inst)
			if model then
				queueScaleModel(model)
			end
		end))
	end

	ViewmodelResizer = Player:AddModule({
		Name = 'Viewmodel Resizer',
		Function = function(callback)
			if callback then
				table.clear(hookedFolders)

				local vm = workspace:FindFirstChild("ViewModels")
				if vm then
					hook(vm)
				end

				ViewmodelResizer:Clean(workspace.ChildAdded:Connect(function(c)
					if c.Name == "ViewModels" then
						hook(c)
					end
				end))
			else
				restoreAll()
				table.clear(hookedFolders)
			end
		end
	})

	Size = ViewmodelResizer:AddSlider({
		Name = 'Size',
		Min = 0.1,
		Max = 10,
		Default = 1,
		Decimal = 10,
		Function = function()
			if ViewmodelResizer.Enabled then
				local vm = workspace:FindFirstChild("ViewModels")
				if vm then
					scaleAll(vm)
				end
			end
		end
	})
end)

run(function()
    local VisualState = getgenv().__LionVisualsExtendedState or {
        Hooked = false,
        ShootHooked = false,
        TracerHooked = false,
        HitSoundHooked = false,
        DamageIndicatorHooked = false,
        DamageNumberHooked = false,
        ViewmodelHooked = false,
        AimingHooked = false,
        OriginalDamageEffect = nil,
        OriginalDamageNumberEffect = nil,
        OriginalShootEffect = nil,
        OriginalStartShooting = nil,
        OriginalTracers = nil,
        OriginalPlayHitmarkerSound = nil,
        OriginalDamageIndicatorCreate = nil,
        OriginalViewmodelUpdate = nil,
        OriginalViewmodelMuzzleFlash = nil,
        OriginalViewmodelPlayAnimation = nil,
        OriginalViewmodelSetAiming = nil,
        OriginalAnimatorPlayAnimation = nil,
        OriginalGunStartAiming = nil,
        OriginalGunGetAimSpeed = nil,
        CrosshairDrawings = {},
        TargetDrawings = {},
        IndicatorDrawings = {},
        OriginalStatuses = {},
        OriginalCrosshairEnabled = nil,
        LastHitTime = 0,
        Version = 8,
    }
    if VisualState.Version ~= 9 then
        VisualState.Hooked = false
        VisualState.DamageIndicatorHooked = false
        VisualState.DamageNumberHooked = false
        VisualState.ShootHooked = false
        VisualState.ViewmodelHooked = false
        VisualState.AimingHooked = false
        VisualState.Version = 9
    end
    getgenv().__LionVisualsExtendedState = VisualState

    local Players = cloneref(game:GetService("Players"))
    local RunService = cloneref(game:GetService("RunService"))
    local SoundService = cloneref(game:GetService("SoundService"))
    local UserInputService = cloneref(game:GetService("UserInputService"))
    local Debris = cloneref(game:GetService("Debris"))
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local VMDisabled, VMOverrideFps, VMFps, VMRecoil
    local VMChams, VMChamFill, VMChamOutline, VMChamSettings
    local VMOffset, VMOffsetX, VMOffsetY, VMOffsetZ
    local CustomTracers, CustomTracerColor
    local ShootSound, ShootSoundMode, ShootCustomId, ShootSoundSpeed, ShootSoundVolume, ShootSoundStart
    local OverrideGroup, ViewmodelAppearance, VMColor, VMMaterial, VMWireframe, VMDisableTextures, VMTransparency
    local ArmAppearance, ArmColor, ArmMaterial, ArmDisableClothes, ArmTransparency
    local ItemGroup, RemoveVignette, OverrideWeaponStatus, WeaponStatus
    local CrosshairGroup, CrosshairEnabled, CrosshairOutline, CrosshairRotation, CrosshairSpeed, CrosshairBounce, CrosshairSpeedMult
    local CrosshairOffset, CrosshairLength, CrosshairThickness, CrosshairLerp, CrosshairPosition, DisableGameCrosshair
    local TargetGroup, TargetTracer, TargetHighlight, TargetCulling
    local IndicatorsGroup, IndicatorManipulated, IndicatorRagebot, IndicatorStyle, IndicatorAmmo, IndicatorAmmoStyle
    local IndicatorLerp, IndicatorOffsetX, IndicatorOffsetY, IndicatorFont, IndicatorTextStyle, IndicatorPosition
    local HitSoundsGroup, HitSoundEnabled, HitSoundVolume, HitSoundName, RemoveHitSound
    local HitEffectsGroup, HitEffectEnabled, HitEffectColors, HitEffectWeld, HitEffectsSelected, HitEffectSettings, HitEffectMaterial
    local DisableHitMarker, DisableDamageNumbers

    local viewmodelDisableList = {
        "sway", "tilt", "bobbing", "muzzle flash", "idle animation", "jump animation",
        "slide animation", "equip animation", "shoot animation", "aiming animation", "sprint animation",
        "reload animation"
    }
    local function buildMaterialList()
        local list = {}
        for _, mat in ipairs(Enum.Material:GetEnumItems()) do
            local name = mat.Name
            if name ~= "Air" then
                table.insert(list, name)
            end
        end
        table.sort(list)
        return list
    end

    local materialList = buildMaterialList()
    local statusList = {"Prime", "Contraband"}
    local fontList = {"smallest", "pixel", "monocraft", "bold", "proggy clean", "proggy tiny", "arial", "mooncrafat", "ubuntu", "tahoma"}
    local positionList = {"-", "position on target", "position on barrel"}
    local cullingList = {"AlwaysOnTop", "Ocluded"}
    local ammoStyleList = {"ammo", "max ammo", "reserve"}
    local textStyleList = {"lower", "upper"}
    local effectList = {
        "Aura", "Blades", "Confetti", "Cyclone", "Dots", "Emission", "Electricity", "Filled Circle",
        "Lighting", "Portal", "Petals", "Plasma", "Ring", "Ripple", "Spiral", "Stars", "Sun Rays",
        "Tornado", "Thunder", "Wind", "Zap", "bubble", "clone", "explosion", "fortnite damage",
        "phantom forces", "slashes"
    }
    local effectSettingList = {
        "remove accessories from clone", "stack damage together", "cycle colors for text",
        "original colors", "phantom forces"
    }
    local soundIds = {
        disable = "",
        neverlose = "rbxassetid://6607204501",
        gamesense = "rbxassetid://4817809188",
        skeet = "rbxassetid://5447626464",
        rust = "rbxassetid://5043539486",
        bell = "rbxassetid://6534947240",
        bubble = "rbxassetid://6534947588",
        minecraft = "rbxassetid://4018616850",
        osu = "rbxassetid://7149255551",
        tf2 = "rbxassetid://2868331684",
        custom = "",
    }

    local function multiHas(value, key)
        if type(value) ~= "table" then return false end
        if value[key] == true then return true end
        for _, item in pairs(value) do
            if item == key then return true end
        end
        return false
    end

    local function getMaterial(name)
        local ok, mat = pcall(function()
            return Enum.Material[name or "ForceField"]
        end)
        return ok and mat or Enum.Material.ForceField
    end

    local armNames = {
        ["left arm"] = true,
        ["right arm"] = true,
        leftarm = true,
        rightarm = true,
        leftupperarm = true,
        leftlowerarm = true,
        lefthand = true,
        rightupperarm = true,
        rightlowerarm = true,
        righthand = true,
        arm = true,
        arms = true,
    }

    local function isArmInstance(obj)
        local current = obj
        while current do
            local name = current.Name:lower():gsub("[%s_%-]", "")
            if armNames[current.Name:lower()] or armNames[name] or name:find("arm", 1, true) then
                return true
            end
            current = current.Parent
        end
        return false
    end

    local function isWeaponViewmodelInstance(obj)
        local current = obj
        while current do
            if current.Name == "ItemVisual" then
                return true
            end
            current = current.Parent
        end
        return false
    end

    local function getWireframeColor(obj)
        local part = obj
        if obj and obj:IsA("SpecialMesh") then
            part = obj.Parent
        end
        if part and part:IsA("BasePart") then
            return part.Color
        end
        return Color3.fromRGB(0, 0, 0)
    end

    local function getOriginalVisual(obj)
        VisualState.OriginalViewmodelVisuals = VisualState.OriginalViewmodelVisuals or setmetatable({}, {__mode = "k"})
        local original = VisualState.OriginalViewmodelVisuals[obj]
        if not original then
            original = {}
            pcall(function()
                if obj:IsA("BasePart") then
                    original.Color = obj.Color
                    original.Material = obj.Material
                    original.Transparency = obj.Transparency
                    original.TextureID = obj:IsA("MeshPart") and obj.TextureID or nil
                    original.MaterialVariant = obj.MaterialVariant
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    original.Transparency = obj.Transparency
                elseif obj:IsA("SpecialMesh") then
                    original.TextureId = obj.TextureId
                    original.VertexColor = obj.VertexColor
                elseif obj:IsA("SurfaceAppearance") then
                    original.Parent = obj.Parent
                elseif obj:IsA("Shirt") then
                    original.ShirtTemplate = obj.ShirtTemplate
                elseif obj:IsA("Pants") then
                    original.PantsTemplate = obj.PantsTemplate
                elseif obj:IsA("ShirtGraphic") then
                    original.Graphic = obj.Graphic
                end
            end)
            VisualState.OriginalViewmodelVisuals[obj] = original
        end
        return original
    end

    local function restoreVisual(obj)
        local originals = VisualState.OriginalViewmodelVisuals
        local original = originals and originals[obj]
        if not original then return end
        pcall(function()
            if obj:IsA("BasePart") then
                if original.Color then obj.Color = original.Color end
                if original.Material then obj.Material = original.Material end
                if original.Transparency ~= nil then obj.Transparency = original.Transparency end
                if obj:IsA("MeshPart") and original.TextureID ~= nil then obj.TextureID = original.TextureID end
                if original.MaterialVariant ~= nil then obj.MaterialVariant = original.MaterialVariant end
            elseif obj:IsA("Texture") or obj:IsA("Decal") then
                if original.Transparency ~= nil then obj.Transparency = original.Transparency end
            elseif obj:IsA("SpecialMesh") then
                if original.TextureId ~= nil then obj.TextureId = original.TextureId end
                if original.VertexColor ~= nil then obj.VertexColor = original.VertexColor end
            elseif obj:IsA("Shirt") then
                if original.ShirtTemplate ~= nil then obj.ShirtTemplate = original.ShirtTemplate end
            elseif obj:IsA("Pants") then
                if original.PantsTemplate ~= nil then obj.PantsTemplate = original.PantsTemplate end
            elseif obj:IsA("ShirtGraphic") then
                if original.Graphic ~= nil then obj.Graphic = original.Graphic end
            end
        end)
    end

    local function hideSurfaceAppearance(obj)
        local original = getOriginalVisual(obj)
        if not original.Parent then return end
        VisualState.HiddenSurfaceAppearances = VisualState.HiddenSurfaceAppearances or {}
        VisualState.HiddenSurfaceAppearances[obj] = original.Parent
        obj.Parent = nil
    end

    local function restoreHiddenSurfaceAppearances()
        local hidden = VisualState.HiddenSurfaceAppearances
        if not hidden then return end
        for obj, parent in pairs(hidden) do
            if obj and parent and obj.Parent == nil then
                pcall(function()
                    obj.Parent = parent
                end)
            end
            hidden[obj] = nil
        end
    end

    local MAX_WIREFRAME_POOL = 96

    local function getWireframeParent()
        return LocalPlayer:FindFirstChildOfClass("PlayerGui") or Camera or workspace
    end

    local function acquireWireframe(name, buildKey, adornee)
        VisualState.WireframePool = VisualState.WireframePool or {}
        VisualState.WireframePoolCount = VisualState.WireframePoolCount or {}

        local poolKey = name .. "|" .. tostring(buildKey or "")
        local bucket = VisualState.WireframePool[poolKey]
        local wire
        if bucket and #bucket > 0 then
            wire = table.remove(bucket)
            VisualState.WireframePoolCount[poolKey] = math.max((VisualState.WireframePoolCount[poolKey] or 1) - 1, 0)
        else
            local ok, created = pcall(function()
                return Instance.new("WireframeHandleAdornment")
            end)
            if not ok or not created then return nil end
            wire = created
        end

        wire.Name = name
        pcall(function() wire.Adornee = adornee end)
        pcall(function() wire.AlwaysOnTop = true end)
        pcall(function() wire.ZIndex = 10 end)
        pcall(function() wire.Thickness = 1 end)
        pcall(function() wire.Transparency = 0 end)
        pcall(function() wire.Visible = true end)
        pcall(function() wire.Parent = getWireframeParent() end)
        return wire
    end

    local function releaseWireframe(wire)
        if not wire then return end
        local buildKey
        pcall(function()
            buildKey = wire:GetAttribute("LionWireBuildKey")
        end)
        if not buildKey then
            pcall(function() wire:Destroy() end)
            return
        end

        VisualState.WireframePool = VisualState.WireframePool or {}
        VisualState.WireframePoolCount = VisualState.WireframePoolCount or {}
        local poolKey = wire.Name .. "|" .. tostring(buildKey)
        local count = VisualState.WireframePoolCount[poolKey] or 0
        if count >= MAX_WIREFRAME_POOL then
            pcall(function() wire:Destroy() end)
            return
        end

        pcall(function() wire.Visible = false end)
        pcall(function() wire.Adornee = nil end)
        pcall(function() wire.Parent = nil end)
        VisualState.WireframePool[poolKey] = VisualState.WireframePool[poolKey] or {}
        table.insert(VisualState.WireframePool[poolKey], wire)
        VisualState.WireframePoolCount[poolKey] = count + 1
    end

    local function updateWireframe(part, enabled, color)
        VisualState.PrimitiveWireframes = VisualState.PrimitiveWireframes or setmetatable({}, {__mode = "k"})
        local buildKey = "box|" .. tostring(part.Size)
        local wire = VisualState.PrimitiveWireframes[part]
        if not enabled and not wire then return end
        local oldWire = part:FindFirstChild("__LionVMWireframe")
        local oldBox = part:FindFirstChild("__LionVMWireframeBox")
        if (oldWire or oldBox) and not wire then
            if oldWire then oldWire:Destroy() end
            if oldBox then oldBox:Destroy() end
        end
        if enabled then
            if wire and not wire:IsA("WireframeHandleAdornment") then
                releaseWireframe(wire)
                wire = nil
            end
            if not wire then
                wire = acquireWireframe("__LionVMWireframe", buildKey, part)
                if wire then
                    VisualState.PrimitiveWireframes[part] = wire
                else
                    return
                end
            end
            if wire then
                local c = color or Color3.fromRGB(255, 255, 255)
                if wire.Color3 ~= c then
                    pcall(function() wire.Color3 = c end)
                end
                if wire:GetAttribute("LionWireBuildKey") ~= buildKey then
                    pcall(function() wire:Clear() end)
                    local half = part.Size * 0.5
                    local corners = {
                        Vector3.new(-half.X, -half.Y, -half.Z), Vector3.new( half.X, -half.Y, -half.Z),
                        Vector3.new(-half.X,  half.Y, -half.Z), Vector3.new( half.X,  half.Y, -half.Z),
                        Vector3.new(-half.X, -half.Y,  half.Z), Vector3.new( half.X, -half.Y,  half.Z),
                        Vector3.new(-half.X,  half.Y,  half.Z), Vector3.new( half.X,  half.Y,  half.Z),
                    }
                    local edges = {{1,2},{2,4},{4,3},{3,1},{5,6},{6,8},{8,7},{7,5},{1,5},{2,6},{3,7},{4,8}}
                    for _, edge in ipairs(edges) do
                        pcall(function()
                            wire:AddLine(corners[edge[1]], corners[edge[2]])
                        end)
                    end
                    pcall(function()
                        wire:SetAttribute("LionWireBuildKey", buildKey)
                    end)
                end
            end
        else
            releaseWireframe(wire)
            VisualState.PrimitiveWireframes[part] = nil
        end
    end

    local function contentFromMeshId(meshId)
        meshId = tostring(meshId or "")
        if meshId == "" then return nil end
        local id = meshId:match("rbxassetid://(%d+)") or meshId:match("[?&]id=(%d+)") or meshId:match("(%d+)")
        if Content and Content.fromAssetId and id then
            local ok, content = pcall(Content.fromAssetId, tonumber(id))
            if ok and content then return content, "asset:" .. id end
        end
        if Content and Content.fromUri then
            local ok, content = pcall(Content.fromUri, meshId)
            if ok and content then return content, meshId end
        end
        return nil, nil
    end

    local function contentFromMeshObject(obj)
        if obj:IsA("SpecialMesh") then
            return contentFromMeshId(obj.MeshId)
        end
        if obj:IsA("MeshPart") then
            local okContent, meshContent = pcall(function()
                return obj.MeshContent
            end)
            if okContent and meshContent then
                return meshContent, tostring(meshContent)
            end
            local okMeshId, meshId = pcall(function()
                return obj.MeshId
            end)
            if okMeshId then
                return contentFromMeshId(meshId)
            end
        end
        return nil, nil
    end

    local function getMeshWireData(obj)
        VisualState.WireframeMeshLines = VisualState.WireframeMeshLines or {}
        local content, key = contentFromMeshObject(obj)
        if not content or not key then return nil end
        if VisualState.WireframeMeshLines[key] ~= nil then
            return VisualState.WireframeMeshLines[key] ~= false and VisualState.WireframeMeshLines[key] or nil
        end

        local ok, editable = pcall(function()
            return game:GetService("AssetService"):CreateEditableMeshAsync(content)
        end)
        if not ok or not editable then
            VisualState.WireframeMeshLines[key] = false
            return nil
        end

        local lines, seen = {}, {}
        local okSize, meshSize = pcall(function()
            return editable:GetSize()
        end)
        if not okSize or not meshSize then
            meshSize = Vector3.new(1, 1, 1)
        end
        local okFaces, faces = pcall(function()
            return editable:GetFaces()
        end)
        if okFaces and type(faces) == "table" then
            for _, faceId in ipairs(faces) do
                local okVerts, verts = pcall(function()
                    return editable:GetFaceVertices(faceId)
                end)
                if okVerts and type(verts) == "table" and #verts >= 2 then
                    for i = 1, #verts do
                        local aId, bId = verts[i], verts[(i % #verts) + 1]
                        local edgeKey = tostring(math.min(aId, bId)) .. ":" .. tostring(math.max(aId, bId))
                        if not seen[edgeKey] then
                            seen[edgeKey] = true
                            local okA, a = pcall(function() return editable:GetPosition(aId) end)
                            local okB, b = pcall(function() return editable:GetPosition(bId) end)
                            if okA and okB and a and b then
                                table.insert(lines, {a, b})
                            end
                        end
                    end
                end
                if #lines > 1800 then break end
            end
        end
        pcall(function() editable:Destroy() end)

        local data = #lines > 0 and {Lines = lines, Size = meshSize, Key = key} or false
        VisualState.WireframeMeshLines[key] = data
        return data ~= false and data or nil
    end

    local function transformMeshWirePoint(mesh, point, data)
        if mesh and mesh:IsA("SpecialMesh") then
            local scale = mesh.Scale
            local offset = mesh.Offset
            return Vector3.new(point.X * scale.X, point.Y * scale.Y, point.Z * scale.Z) + offset
        end
        if mesh and mesh:IsA("MeshPart") and data and data.Size then
            local size = data.Size
            local sx = math.abs(size.X) > 1e-4 and mesh.Size.X / size.X or 1
            local sy = math.abs(size.Y) > 1e-4 and mesh.Size.Y / size.Y or 1
            local sz = math.abs(size.Z) > 1e-4 and mesh.Size.Z / size.Z or 1
            return Vector3.new(point.X * sx, point.Y * sy, point.Z * sz)
        end
        return point
    end

    local function updateMeshWireframe(obj, enabled, color)
        local adornee = obj:IsA("SpecialMesh") and obj.Parent or obj
        if not (adornee and adornee:IsA("BasePart")) then return end
        VisualState.MeshWireframes = VisualState.MeshWireframes or setmetatable({}, {__mode = "k"})
        local wire = VisualState.MeshWireframes[adornee]
        if not enabled and not wire then return end
        local old = adornee:FindFirstChild("__LionVMMeshWireframe")
        if old and not wire then old:Destroy() end
        if not enabled then
            releaseWireframe(wire)
            VisualState.MeshWireframes[adornee] = nil
            return
        end

        local data = getMeshWireData(obj)
        if not data then
            updateWireframe(adornee, false)
            return
        end
        updateWireframe(adornee, false)

        local buildKey = data.Key
        if obj:IsA("SpecialMesh") then
            buildKey ..= "|" .. tostring(obj.Scale) .. "|" .. tostring(obj.Offset)
        elseif obj:IsA("MeshPart") then
            buildKey ..= "|" .. tostring(obj.Size)
        end

        if not wire then
            wire = acquireWireframe("__LionVMMeshWireframe", buildKey, adornee)
            if not wire then return end
            VisualState.MeshWireframes[adornee] = wire
        end

        local c = color or Color3.fromRGB(0, 0, 0)
        if wire.Color3 ~= c then
            pcall(function() wire.Color3 = c end)
        end
        if wire:GetAttribute("LionWireBuildKey") ~= buildKey then
            pcall(function() wire:Clear() end)
            for _, line in ipairs(data.Lines) do
                pcall(function()
                    wire:AddLine(transformMeshWirePoint(obj, line[1], data), transformMeshWirePoint(obj, line[2], data))
                end)
            end
            pcall(function()
                wire:SetAttribute("LionWireBuildKey", buildKey)
            end)
        end
    end

    local function getLocalFighter()
        local now = os.clock()
        if VisualState.CachedFighterAt and now - VisualState.CachedFighterAt < 0.25 then
            return VisualState.CachedFighter
        end
        local ok, controller = pcall(function()
            return require(LocalPlayer.PlayerScripts.Controllers.FighterController)
        end)
        local fighter = ok and controller and (controller.LocalFighter or controller:GetFighter(LocalPlayer)) or nil
        VisualState.CachedFighter = fighter
        VisualState.CachedFighterAt = now
        return fighter
    end

    local function getLocalViewmodels()
        local now = tick()
        if VisualState.CachedViewmodels and VisualState.CachedViewmodelsAt and now - VisualState.CachedViewmodelsAt < 0.75 then
            return VisualState.CachedViewmodels
        end
        local out = {}
        local folder = workspace:FindFirstChild("ViewModels")
        if not folder then return out end
        local prefix = LocalPlayer.Name .. " - "
        for _, model in ipairs(folder:GetDescendants()) do
            if model:IsA("Model") and model.Name:sub(1, #prefix) == prefix then
                table.insert(out, model)
            end
        end
        VisualState.CachedViewmodels = out
        VisualState.CachedViewmodelsAt = now
        return out
    end

    local function markViewmodelDirty()
        VisualState.ViewmodelDirty = true
        VisualState.ViewmodelAppliedAt = nil
    end

    local function getViewmodelDescendants(model)
        VisualState.ViewmodelDescendantCache = VisualState.ViewmodelDescendantCache or setmetatable({}, {__mode = "k"})
        local cache = VisualState.ViewmodelDescendantCache[model]
        if not cache then
            cache = {Dirty = true, Objects = {}}
            VisualState.ViewmodelDescendantCache[model] = cache
            cache.Added = model.DescendantAdded:Connect(function()
                cache.Dirty = true
                markViewmodelDirty()
            end)
            cache.Removing = model.DescendantRemoving:Connect(function()
                cache.Dirty = true
                markViewmodelDirty()
            end)
            mainapi:Clean(cache.Added)
            mainapi:Clean(cache.Removing)
        end
        if cache.Dirty then
            cache.Objects = model:GetDescendants()
            cache.Dirty = false
        end
        return cache.Objects
    end

    local function getActiveWireframeRoots()
        local roots, keyParts = {}, {}
        local function rootKey(root)
            local ok, id = pcall(function()
                return root:GetDebugId(0)
            end)
            return ok and id or root:GetFullName()
        end
        pcall(function()
            local fighter = getLocalFighter()
            local item = fighter and fighter.EquippedItem
            local viewmodel = item and item.ViewModel
            local model = viewmodel and viewmodel.Model
            local itemModel = viewmodel and viewmodel.ItemModel
            local itemVisual = model and model:FindFirstChild("ItemVisual")
            for _, root in ipairs({itemModel, itemVisual}) do
                if typeof(root) == "Instance" and root:IsDescendantOf(workspace) then
                    roots[root] = true
                    table.insert(keyParts, rootKey(root))
                end
            end
        end)
        if next(roots) == nil then
            local models = getLocalViewmodels()
            local model = models[#models]
            local itemVisual = model and model:FindFirstChild("ItemVisual")
            if itemVisual then
                roots[itemVisual] = true
                table.insert(keyParts, rootKey(itemVisual))
            end
        end
        table.sort(keyParts)
        return roots, table.concat(keyParts, "|")
    end

    local function isInRootSet(obj, roots)
        if not obj or not roots then return false end
        for root in pairs(roots) do
            if obj == root or obj:IsDescendantOf(root) then
                return true
            end
        end
        return false
    end

    local function getMuzzleWorld()
        local muzzle
        local fighter = getLocalFighter()
        local item = fighter and fighter.EquippedItem
        pcall(function()
            if item and item.ViewModel and item.ViewModel.GetMuzzlePosition then
                muzzle = item.ViewModel:GetMuzzlePosition()
            end
        end)
        if muzzle then return muzzle end
        for _, model in ipairs(getLocalViewmodels()) do
            local part = model:FindFirstChild("Muzzle", true) or model:FindFirstChild("Barrel", true) or model:FindFirstChild("Handle", true)
            if part and part:IsA("Attachment") then return part.WorldPosition end
            if part and part:IsA("BasePart") then return part.Position end
        end
        return Camera and Camera.CFrame.Position or nil
    end

    local function worldToScreen(pos)
        Camera = workspace.CurrentCamera
        if not (Camera and pos) then return nil, false end
        local screen, visible = Camera:WorldToViewportPoint(pos)
        return Vector2.new(screen.X, screen.Y), visible and screen.Z > 0
    end

    local function getClosestTarget()
        local now = tick()
        if VisualState.CachedTargetAt and now - VisualState.CachedTargetAt < 0.05 then
            return VisualState.CachedTarget, VisualState.CachedTargetPart
        end
        Camera = workspace.CurrentCamera
        if not Camera then return nil end
        local center = Camera.ViewportSize / 2
        local best, bestPart, bestDist = nil, nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local part = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and part then
                    local screen, visible = worldToScreen(part.Position)
                    if visible then
                        local dist = (screen - center).Magnitude
                        if dist < bestDist then
                            best, bestPart, bestDist = plr, part, dist
                        end
                    end
                end
            end
        end
        VisualState.CachedTarget = best
        VisualState.CachedTargetPart = bestPart
        VisualState.CachedTargetAt = now
        return best, bestPart
    end

    local function playSound(name, volume, speed, startAt)
        name = tostring(name or "disable"):lower()
        local id = soundIds[name] or ""
        if name == "custom" then
            id = tostring(ShootCustomId and ShootCustomId.Value or "")
        end
        if id == "" or name == "disable" then return end
        if not id:find("rbxassetid://", 1, true) then
            id = "rbxassetid://" .. id:gsub("%D", "")
        end
        local sound = Instance.new("Sound")
        sound.Name = "__LionCustomSound"
        pcall(function()
            sound:SetAttribute("__LionCustomSound", true)
        end)
        sound.SoundId = id
        sound.Volume = math.clamp(tonumber(volume) or 0.5, 0, 10)
        sound.PlaybackSpeed = math.clamp(tonumber(speed) or 1, 0.1, 5)
        sound.TimePosition = math.max(tonumber(startAt) or 0, 0)
        sound.Parent = SoundService
        sound:Play()
        Debris:AddItem(sound, 5)
    end

    local function getShootSoundRoots()
        local roots = {SoundService}
        local viewmodels = workspace:FindFirstChild("ViewModels")
        if viewmodels then table.insert(roots, viewmodels) end
        local camera = workspace.CurrentCamera
        if camera then table.insert(roots, camera) end
        return roots
    end

    local function collectShootSounds()
        local sounds = {}
        for _, root in ipairs(getShootSoundRoots()) do
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("Sound") then
                    sounds[obj] = {
                        Playing = obj.Playing,
                        TimePosition = obj.TimePosition,
                    }
                end
            end
        end
        return sounds
    end

    local function suppressDefaultShootSounds(snapshot)
        for _, root in ipairs(getShootSoundRoots()) do
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("Sound") and not obj:GetAttribute("__LionCustomSound") then
                    local previous = snapshot[obj]
                    local fresh = previous == nil
                    pcall(function()
                        local restarted = previous
                            and obj.Playing
                            and (not previous.Playing or obj.TimePosition + 0.02 < previous.TimePosition or obj.TimePosition <= 0.08)
                        fresh = fresh or restarted or (obj.Playing and obj.TimePosition <= 0.25 and obj:IsDescendantOf(workspace:FindFirstChild("ViewModels") or workspace))
                    end)
                    if fresh then
                        pcall(function()
                            obj.Volume = 0
                            obj:Stop()
                        end)
                    end
                end
            end
        end
    end

    local function stopDefaultShootSound(obj)
        if obj and obj:IsA("Sound") and not obj:GetAttribute("__LionCustomSound") then
            pcall(function()
                obj.Volume = 0
                obj:Stop()
            end)
        end
    end

    local function clearShootSoundWatch()
        if os.clock() < (VisualState.SuppressShootSoundUntil or 0) then
            task.delay(0.1, clearShootSoundWatch)
            return
        end
        for _, connection in ipairs(VisualState.ShootSoundConnections or {}) do
            pcall(function()
                connection:Disconnect()
            end)
        end
        VisualState.ShootSoundConnections = nil
    end

    local function beginShootSoundSuppression(snapshot, duration)
        duration = duration or 0.35
        VisualState.SuppressShootSoundUntil = math.max(VisualState.SuppressShootSoundUntil or 0, os.clock() + duration)
        suppressDefaultShootSounds(snapshot or {})
        if VisualState.ShootSoundConnections then return end
        VisualState.ShootSoundConnections = {}
        local function watch(root)
            if not root then return end
            table.insert(VisualState.ShootSoundConnections, root.DescendantAdded:Connect(function(obj)
                if os.clock() <= (VisualState.SuppressShootSoundUntil or 0) then
                    task.defer(stopDefaultShootSound, obj)
                end
            end))
        end
        watch(workspace)
        watch(SoundService)
        task.delay(duration + 0.1, clearShootSoundWatch)
    end

    local function makeLine(key)
        if not Drawing then return nil end
        local line = VisualState.CrosshairDrawings[key]
        if not line then
            line = Drawing.new("Line")
            VisualState.CrosshairDrawings[key] = line
        end
        return line
    end

    local function hideDrawingSet(set)
        for _, obj in pairs(set) do
            pcall(function()
                obj.Visible = false
            end)
        end
    end

    local function hideWireframeDrawings(fromIndex)
        local drawings = VisualState.WireframeDrawings
        if not drawings then return end
        for i = fromIndex or 1, #drawings do
            pcall(function()
                drawings[i].Visible = false
            end)
        end
    end

    local function destroyWireframeAdornments()
        for _, set in ipairs({VisualState.PrimitiveWireframes, VisualState.MeshWireframes}) do
            if set then
                for key, obj in pairs(set) do
                    releaseWireframe(obj)
                    set[key] = nil
                end
            end
        end
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if playerGui then
            for _, obj in ipairs(playerGui:GetDescendants()) do
                if obj.Name == "__LionVMWireframe"
                    or obj.Name == "__LionVMMeshWireframe"
                    or obj.Name == "__LionVMWireframeBox" then
                    releaseWireframe(obj)
                end
            end
        end
    end

    local function destroyStaleWireframeAdornments(activeParts)
        for _, set in ipairs({VisualState.PrimitiveWireframes, VisualState.MeshWireframes}) do
            if set then
                for part, wire in pairs(set) do
                    if not activeParts[part] or not part.Parent or not part:IsDescendantOf(workspace) then
                        releaseWireframe(wire)
                        set[part] = nil
                    end
                end
            end
        end
    end

    local function getWireframeDrawing(index)
        if not Drawing then return nil end
        VisualState.WireframeDrawings = VisualState.WireframeDrawings or {}
        local line = VisualState.WireframeDrawings[index]
        if not line then
            line = Drawing.new("Line")
            line.Thickness = 1
            line.Transparency = 1
            VisualState.WireframeDrawings[index] = line
        end
        return line
    end

    local function updateDrawingWireframe(parts, color)
        if not Drawing then
            hideWireframeDrawings(1)
            return
        end
        Camera = workspace.CurrentCamera
        if not Camera then
            hideWireframeDrawings(1)
            return
        end

        local edges = {
            {1, 2}, {2, 4}, {4, 3}, {3, 1},
            {5, 6}, {6, 8}, {8, 7}, {7, 5},
            {1, 5}, {2, 6}, {3, 7}, {4, 8},
        }
        local index = 1
        for _, part in ipairs(parts) do
            local cf, half = part.CFrame, part.Size * 0.5
            local corners = {
                cf * Vector3.new(-half.X, -half.Y, -half.Z),
                cf * Vector3.new( half.X, -half.Y, -half.Z),
                cf * Vector3.new(-half.X,  half.Y, -half.Z),
                cf * Vector3.new( half.X,  half.Y, -half.Z),
                cf * Vector3.new(-half.X, -half.Y,  half.Z),
                cf * Vector3.new( half.X, -half.Y,  half.Z),
                cf * Vector3.new(-half.X,  half.Y,  half.Z),
                cf * Vector3.new( half.X,  half.Y,  half.Z),
            }
            local points = {}
            for i, point in ipairs(corners) do
                local screen = Camera:WorldToViewportPoint(point)
                points[i] = {Vector2.new(screen.X, screen.Y), screen.Z > 0}
            end
            for _, edge in ipairs(edges) do
                local a, b = points[edge[1]], points[edge[2]]
                local line = getWireframeDrawing(index)
                if line then
                    line.From = a[1]
                    line.To = b[1]
                    line.Color = color or Color3.fromRGB(255, 255, 255)
                    line.Visible = a[2] and b[2]
                end
                index += 1
            end
        end
        hideWireframeDrawings(index)
    end

    local function updateCrosshair()
        if not (CrosshairEnabled and CrosshairEnabled.Enabled and Drawing) then
            hideDrawingSet(VisualState.CrosshairDrawings)
            return
        end
        Camera = workspace.CurrentCamera
        if not Camera then return end

        local center = Camera.ViewportSize / 2
        if CrosshairPosition and CrosshairPosition.Value == "position on target" then
            local _, targetPart = getClosestTarget()
            if targetPart then
                local screen, visible = worldToScreen(targetPart.Position)
                if visible then center = screen end
            end
        elseif CrosshairPosition and CrosshairPosition.Value == "position on barrel" then
            local screen, visible = worldToScreen(getMuzzleWorld())
            if visible then center = screen end
        end

        local length = CrosshairLength and CrosshairLength.Value or 20
        local gap = CrosshairOffset and CrosshairOffset.Value or 5
        local thickness = CrosshairThickness and CrosshairThickness.Value or 2
        local rot = math.rad((CrosshairRotation and CrosshairRotation.Value or 0) + tick() * 360 * (CrosshairSpeed and CrosshairSpeed.Value or 0))
        local bounce = CrosshairBounce and CrosshairBounce.Value or 0
        if bounce > 0 then
            gap += math.sin(tick() * 8 * (CrosshairSpeedMult and CrosshairSpeedMult.Value or 1)) * bounce
        end
        local color = CrosshairEnabled.Value or Color3.fromRGB(255, 255, 255)
        local outlineColor = CrosshairOutline and CrosshairOutline.Value or Color3.fromRGB(0, 0, 0)

        local dirs = {Vector2.new(0, -1), Vector2.new(1, 0), Vector2.new(0, 1), Vector2.new(-1, 0)}
        for i, dir in ipairs(dirs) do
            local rdir = Vector2.new(dir.X * math.cos(rot) - dir.Y * math.sin(rot), dir.X * math.sin(rot) + dir.Y * math.cos(rot))
            local from = center + rdir * gap
            local to = center + rdir * (gap + length)
            local outline = makeLine("outline" .. i)
            if outline then
                outline.From = from
                outline.To = to
                outline.Color = outlineColor
                outline.Thickness = thickness + 2
                outline.Transparency = 1
                outline.Visible = CrosshairOutline and CrosshairOutline.Enabled or false
            end
            local line = makeLine("line" .. i)
            if line then
                line.From = from
                line.To = to
                line.Color = color
                line.Thickness = thickness
                line.Transparency = 1
                line.Visible = true
            end
        end
    end

    local function applyViewmodelOptions()
        local disable = VMDisabled and VMDisabled.Value or {}
        local now = tick()
        local vmAppearanceEnabled = ViewmodelAppearance and ViewmodelAppearance.Enabled
        local vmChamsEnabled = VMChams and VMChams.Enabled
        local vmWireframeEnabled = VMWireframe and VMWireframe.Enabled
        local vmDisableTexturesEnabled = VMDisableTextures and VMDisableTextures.Enabled
        local armAppearanceEnabled = ArmAppearance and ArmAppearance.Enabled
        local armDisableClothesEnabled = ArmDisableClothes and ArmDisableClothes.Enabled
        local offsetEnabled = VMOffset and VMOffset.Enabled
        local fpsEnabled = VMOverrideFps and VMOverrideFps.Enabled

        if fpsEnabled and setfpscap then
            local fps = VMFps and VMFps.Value or 60
            if VisualState.LastFpsCap ~= fps then
                VisualState.LastFpsCap = fps
                pcall(setfpscap, fps)
            end
        end

        local disableSig = ""
        if type(disable) == "table" then
            for _, name in ipairs(viewmodelDisableList) do
                if multiHas(disable, name) then
                    disableSig ..= name .. ";"
                end
            end
        end
        local viewmodelSig = table.concat({
            tostring(disableSig),
            tostring(fpsEnabled and (VMFps and VMFps.Value or 60) or ""),
            tostring(offsetEnabled and (VMOffsetX and VMOffsetX.Value or 0) or ""),
            tostring(offsetEnabled and (VMOffsetY and VMOffsetY.Value or 0) or ""),
            tostring(offsetEnabled and (VMOffsetZ and VMOffsetZ.Value or 0) or ""),
            tostring(vmAppearanceEnabled),
            tostring(VMColor and VMColor.Value or ""),
            tostring(VMMaterial and VMMaterial.Value or ""),
            tostring(VMTransparency and VMTransparency.Value or ""),
            tostring(vmChamsEnabled),
            tostring(VMChams and VMChams.Value or ""),
            tostring(VMChamFill and VMChamFill.Value or ""),
            tostring(vmWireframeEnabled),
            tostring(vmDisableTexturesEnabled),
            tostring(armAppearanceEnabled),
            tostring(ArmColor and ArmColor.Value or ""),
            tostring(ArmMaterial and ArmMaterial.Value or ""),
            tostring(ArmTransparency and ArmTransparency.Value or ""),
            tostring(armDisableClothesEnabled),
        }, "|")
        local viewmodelActive = disableSig ~= ""
            or offsetEnabled
            or vmAppearanceEnabled
            or vmChamsEnabled
            or vmWireframeEnabled
            or vmDisableTexturesEnabled
            or armAppearanceEnabled
            or armDisableClothesEnabled

        local activeWireframeRoots, activeWireframeKey
        if vmWireframeEnabled then
            activeWireframeRoots, activeWireframeKey = getActiveWireframeRoots()
            if VisualState.ActiveWireframeKey ~= activeWireframeKey then
                destroyWireframeAdornments()
                VisualState.ActiveWireframeKey = activeWireframeKey
            end
        elseif VisualState.ActiveWireframeKey then
            VisualState.ActiveWireframeKey = nil
        end

        local viewmodelNeedsRealtimeApply = offsetEnabled
        if not viewmodelNeedsRealtimeApply
            and not VisualState.ViewmodelDirty
            and VisualState.ViewmodelSig == viewmodelSig
            and VisualState.ViewmodelAppliedAt
            and ((not viewmodelActive) or now - VisualState.ViewmodelAppliedAt < 0.2) then
            return
        end
        VisualState.ViewmodelSig = viewmodelSig
        VisualState.ViewmodelAppliedAt = now
        VisualState.ViewmodelDirty = false

        pcall(function()
            local cam = require(LocalPlayer.PlayerScripts.Controllers.CameraController)
            if multiHas(disable, "sway") and cam._sway_spring then cam._sway_spring.Value = Vector2.zero cam._sway_spring.Target = Vector2.zero end
            if multiHas(disable, "bobbing") then
                if cam._bobbing_speed_spring then cam._bobbing_speed_spring.Value = 0 cam._bobbing_speed_spring.Target = 0 end
                if cam._bobbing_value_spring then cam._bobbing_value_spring.Value = 0 cam._bobbing_value_spring.Target = 0 end
            end
            if multiHas(disable, "tilt") and cam._tilt_spring then cam._tilt_spring.Value = 0 cam._tilt_spring.Target = 0 end
        end)

        restoreHiddenSurfaceAppearances()

        hideWireframeDrawings(1)
        local wireframeWasEnabled = VisualState.WireframeWasEnabled == true
        if not vmWireframeEnabled and wireframeWasEnabled then
            destroyWireframeAdornments()
        end
        VisualState.WireframeWasEnabled = vmWireframeEnabled == true

        local activeWireframeParts = {}
        for _, model in ipairs(getLocalViewmodels()) do
            local offset = CFrame.new(
                (VMOffset and VMOffset.Enabled and VMOffsetX and VMOffsetX.Value or 0),
                (VMOffset and VMOffset.Enabled and VMOffsetY and VMOffsetY.Value or 0),
                (VMOffset and VMOffset.Enabled and VMOffsetZ and VMOffsetZ.Value or 0)
            )
            if VMOffset and VMOffset.Enabled then
                pcall(function()
                    if not VisualState.OriginalPivots then VisualState.OriginalPivots = setmetatable({}, {__mode = "k"}) end
                    VisualState.OriginalPivots[model] = VisualState.OriginalPivots[model] or model:GetPivot()
                    model:PivotTo(VisualState.OriginalPivots[model] * offset)
                end)
            end
            for _, obj in ipairs(getViewmodelDescendants(model)) do
                if obj:IsA("BasePart") then
                    local isArm = isArmInstance(obj)
                    local isWeapon = isWeaponViewmodelInstance(obj)
                    local isWireWeapon = activeWireframeRoots ~= nil and isInRootSet(obj, activeWireframeRoots)
                    restoreVisual(obj)
                    if (isWeapon and (vmAppearanceEnabled or vmChamsEnabled or vmDisableTexturesEnabled))
                        or (isArm and (armAppearanceEnabled or armDisableClothesEnabled)) then
                        getOriginalVisual(obj)
                    end
                    if vmAppearanceEnabled and isWeapon then
                        obj.Color = (VMColor and VMColor.Value) or obj.Color
                        obj.Material = getMaterial(VMMaterial and VMMaterial.Value)
                        obj.Transparency = math.clamp(1 - ((VMTransparency and VMTransparency.Value or 100) / 100), 0, 1)
                        pcall(function()
                            obj.MaterialVariant = ""
                        end)
                    end
                    if vmChamsEnabled and isWeapon then
                        obj.Material = Enum.Material.ForceField
                        obj.Color = (VMChams.Value or Color3.fromRGB(255, 255, 255))
                        obj.Transparency = math.clamp(1 - ((VMChamFill and VMChamFill.Value or 2) / 100), 0, 1)
                    end
                    if armAppearanceEnabled and isArm then
                        obj.Color = (ArmColor and ArmColor.Value) or obj.Color
                        obj.Material = getMaterial(ArmMaterial and ArmMaterial.Value)
                        obj.Transparency = math.clamp(1 - ((ArmTransparency and ArmTransparency.Value or 100) / 100), 0, 1)
                        pcall(function()
                            obj.MaterialVariant = ""
                        end)
                    end
                    if vmWireframeEnabled and isWireWeapon then
                        activeWireframeParts[obj] = true
                        getOriginalVisual(obj)
                        obj.Transparency = 1
                    end
                    if obj:IsA("MeshPart") and ((isWeapon and (vmDisableTexturesEnabled or vmAppearanceEnabled)) or ((armDisableClothesEnabled or armAppearanceEnabled) and isArm)) then
                        obj.TextureID = ""
                    end
                    if vmWireframeEnabled and isWireWeapon and obj:IsA("MeshPart") then
                        updateMeshWireframe(obj, true, getWireframeColor(obj))
                    elseif vmWireframeEnabled and isWireWeapon and not obj:FindFirstChildOfClass("SpecialMesh") then
                        updateWireframe(obj, true, getWireframeColor(obj))
                    elseif vmWireframeEnabled then
                        if obj:IsA("MeshPart") then
                            updateMeshWireframe(obj, false)
                        end
                        updateWireframe(obj, false)
                    end
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    restoreVisual(obj)
                    if (isWeaponViewmodelInstance(obj) and (vmDisableTexturesEnabled or vmAppearanceEnabled)) or ((armDisableClothesEnabled or armAppearanceEnabled) and isArmInstance(obj)) then
                        getOriginalVisual(obj)
                        obj.Transparency = 1
                    end
                elseif obj:IsA("SpecialMesh") then
                    local isArm = isArmInstance(obj)
                    local isWeapon = isWeaponViewmodelInstance(obj)
                    local isWireWeapon = activeWireframeRoots ~= nil and isInRootSet(obj, activeWireframeRoots)
                    restoreVisual(obj)
                    if (isWeapon and (vmDisableTexturesEnabled or vmAppearanceEnabled)) or (isArm and (armAppearanceEnabled or armDisableClothesEnabled)) then
                        getOriginalVisual(obj)
                    end
                    if isWeapon and (vmDisableTexturesEnabled or vmAppearanceEnabled) then
                        obj.TextureId = ""
                    end
                    if isArm and (armDisableClothesEnabled or armAppearanceEnabled) then
                        obj.TextureId = ""
                    end
                    if isArm and armAppearanceEnabled and ArmColor then
                        local c = ArmColor.Value or Color3.fromRGB(255, 255, 255)
                        obj.VertexColor = Vector3.new(c.R, c.G, c.B)
                    elseif isWeapon and vmAppearanceEnabled and VMColor then
                        local c = VMColor.Value or Color3.fromRGB(255, 255, 255)
                        obj.VertexColor = Vector3.new(c.R, c.G, c.B)
                    end
                    if vmWireframeEnabled then
                        if isWireWeapon and obj.Parent and obj.Parent:IsA("BasePart") then
                            activeWireframeParts[obj.Parent] = true
                        end
                        updateMeshWireframe(obj, isWireWeapon, getWireframeColor(obj))
                    end
                elseif obj:IsA("SurfaceAppearance") then
                    if (isWeaponViewmodelInstance(obj) and (vmDisableTexturesEnabled or vmAppearanceEnabled)) or ((armDisableClothesEnabled or armAppearanceEnabled) and isArmInstance(obj)) then
                        hideSurfaceAppearance(obj)
                    end
                elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
                    restoreVisual(obj)
                    if armDisableClothesEnabled then
                        getOriginalVisual(obj)
                        pcall(function()
                            if obj:IsA("Shirt") then
                                obj.ShirtTemplate = ""
                            elseif obj:IsA("Pants") then
                                obj.PantsTemplate = ""
                            elseif obj:IsA("ShirtGraphic") then
                                obj.Graphic = ""
                            end
                        end)
                    end
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                    if multiHas(disable, "muzzle flash") then obj.Enabled = false end
                end
            end
        end
        if vmWireframeEnabled then
            destroyStaleWireframeAdornments(activeWireframeParts)
        end
    end

    local function disableSelected(name)
        return multiHas(VMDisabled and VMDisabled.Value or {}, name)
    end

    local function shouldBlockAnimationKey(key)
        local lower = tostring(key or ""):lower()
        if lower == "" then return false end
        if disableSelected("idle animation") and lower:find("idle", 1, true) then return true end
        if disableSelected("jump animation") and lower:find("jump", 1, true) then return true end
        if disableSelected("slide animation") and lower:find("slide", 1, true) then return true end
        if disableSelected("equip animation") and lower:find("equip", 1, true) then return true end
        if disableSelected("reload animation") and lower:find("reload", 1, true) then return true end
        if disableSelected("shoot animation") and (lower:find("shoot", 1, true) or lower:find("fire", 1, true) or lower:find("attack", 1, true)) then return true end
        if disableSelected("sprint animation") and (lower:find("sprint", 1, true) or lower:find("run", 1, true)) then return true end
        return false
    end

    local function zeroSpring(spring, value)
        if not spring then return end
        pcall(function()
            spring.Value = value
            spring.Target = value
        end)
    end

    local function forceViewmodelAimValue(vm, enabled)
        if not vm then return end
        local value = enabled and 1 or 0
        vm.IsAiming = enabled == true
        vm.Aiming = enabled == true
        vm._is_aiming = enabled == true
        if vm.CurrentAimValue ~= nil then
            vm.CurrentAimValue = value
        end
    end

    local function applyViewmodelDisableToObject(vm)
        if not vm then return end
        if disableSelected("sway") then zeroSpring(vm._sway_spring, Vector2.zero) end
        if disableSelected("tilt") then
            zeroSpring(vm._tilt_spring, Vector2.zero)
            zeroSpring(vm._raycast_tilt_spring, 0)
        end
        if disableSelected("bobbing") then
            zeroSpring(vm._bobbing_speed_spring, 0)
            zeroSpring(vm._bobbing_value_spring, Vector2.zero)
            vm._bobbing_tick = 0
        end
        if disableSelected("jump animation") then
            zeroSpring(vm._jump_spring, 0)
            vm.CurrentJumpValue = 0
        end
        if disableSelected("sprint animation") then
            zeroSpring(vm._sprinting_spring, 0)
        end
        if disableSelected("aiming animation") then
            local item = vm.ClientItem
            local isAiming = vm.IsAiming == true or vm.Aiming == true or vm._is_aiming == true
            pcall(function()
                if item and item.Get then
                    isAiming = isAiming or item:Get("IsAiming") == true
                end
            end)
            if isAiming and vm.CurrentAimValue ~= nil then
                forceViewmodelAimValue(vm, true)
            end
        end
        if VMRecoil then
            local scale = math.clamp((VMRecoil.Value or 100) / 100, 0, 1)
            if typeof(vm.CurrentRecoilValue) == "Vector3" then
                vm.CurrentRecoilValue *= scale
            end
        end
    end

    local function installAimingHooks()
        if VisualState.AimingHooked then return end
        local success, gunModule = pcall(function()
            return require(LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
        end)
        if not success or not gunModule then return end

        if gunModule.StartAiming then
            VisualState.OriginalGunStartAiming = VisualState.OriginalGunStartAiming or gunModule.StartAiming
            gunModule.StartAiming = function(self, ...)
                if not disableSelected("aiming animation") then
                    return VisualState.OriginalGunStartAiming(self, ...)
                end

                self:SetReplicate("IsAiming", true)
                self.StopSprinting:Fire()
                self.ViewModel:SetAiming(true)
                self:SetReplicate("FOVOffset", self.Info.AimFOVOffset)

                if self.ViewModel and self.ViewModel.CurrentAimValue ~= nil then
                    self.ViewModel.CurrentAimValue = 1
                end

                return true, "StartAiming"
            end
        end

        if gunModule.GetAimSpeed then
            VisualState.OriginalGunGetAimSpeed = VisualState.OriginalGunGetAimSpeed or gunModule.GetAimSpeed
            gunModule.GetAimSpeed = function(self)
                if disableSelected("aiming animation") then
                    return 999
                end
                return VisualState.OriginalGunGetAimSpeed(self)
            end
        end

        VisualState.AimingHooked = true
    end

    local function installViewmodelHooks()
        if VisualState.ViewmodelHooked then return end
        local ok, viewmodelModule = pcall(function()
            return require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel)
        end)
        if ok and type(viewmodelModule) == "table" then
            if type(viewmodelModule.Update) == "function" then
                VisualState.OriginalViewmodelUpdate = VisualState.OriginalViewmodelUpdate or viewmodelModule.Update
                viewmodelModule.Update = function(self, ...)
                    applyViewmodelDisableToObject(self)
                    local result = {VisualState.OriginalViewmodelUpdate(self, ...)}
                    applyViewmodelDisableToObject(self)
                    return unpack(result)
                end
            end
            if type(viewmodelModule.MuzzleFlash) == "function" then
                VisualState.OriginalViewmodelMuzzleFlash = VisualState.OriginalViewmodelMuzzleFlash or viewmodelModule.MuzzleFlash
                viewmodelModule.MuzzleFlash = function(self, ...)
                    if disableSelected("muzzle flash") then return end
                    return VisualState.OriginalViewmodelMuzzleFlash(self, ...)
                end
            end
            if type(viewmodelModule.SetAiming) == "function" then
                VisualState.OriginalViewmodelSetAiming = VisualState.OriginalViewmodelSetAiming or viewmodelModule.SetAiming
                viewmodelModule.SetAiming = function(self, enabled, ...)
                    local result = {VisualState.OriginalViewmodelSetAiming(self, enabled, ...)}
                    if disableSelected("aiming animation") then
                        forceViewmodelAimValue(self, enabled == true)
                    end
                    return unpack(result)
                end
            end
            if type(viewmodelModule.PlayAnimation) == "function" then
                VisualState.OriginalViewmodelPlayAnimation = VisualState.OriginalViewmodelPlayAnimation or viewmodelModule.PlayAnimation
                viewmodelModule.PlayAnimation = function(self, key, ...)
                    if shouldBlockAnimationKey(key) then return nil end
                    return VisualState.OriginalViewmodelPlayAnimation(self, key, ...)
                end
            end
        end

        pcall(function()
            local animatorModule = require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel.ViewModelAnimator)
            if type(animatorModule) == "table" and type(animatorModule.PlayAnimation) == "function" then
                VisualState.OriginalAnimatorPlayAnimation = VisualState.OriginalAnimatorPlayAnimation or animatorModule.PlayAnimation
                animatorModule.PlayAnimation = function(self, key, ...)
                    if shouldBlockAnimationKey(key) then return nil end
                    return VisualState.OriginalAnimatorPlayAnimation(self, key, ...)
                end
            end
        end)

        VisualState.ViewmodelHooked = true
    end

    local function applyItemStatus()
        if not (OverrideWeaponStatus and OverrideWeaponStatus.Enabled) then return end
        local selected = WeaponStatus and WeaponStatus.Value or "Prime"
        local now = tick()
        if VisualState.ItemStatusValue == selected
            and VisualState.ItemStatusAppliedAt
            and now - VisualState.ItemStatusAppliedAt < 1 then
            return
        end
        VisualState.ItemStatusValue = selected
        VisualState.ItemStatusAppliedAt = now
        pcall(function()
            local itemLibrary = require(ReplicatedStorage.Modules.ItemLibrary)
            for name, info in pairs(itemLibrary.Items or {}) do
                if type(info) == "table" then
                    VisualState.OriginalStatuses[name] = VisualState.OriginalStatuses[name] or info.Status
                    info.Status = selected
                end
            end
        end)
    end

    local function safeTableGet(tab, key)
        if typeof(tab) ~= "table" then return nil end

        local okRaw, rawValue = pcall(rawget, tab, key)
        if okRaw then
            return rawValue
        end
        return nil
    end

    local function findInTableValues(tab, callback)
        local found
        pcall(function()
            for _, value in pairs(tab) do
                found = callback(value)
                if found ~= nil then
                    return
                end
            end
        end)
        return found
    end

    local function getDamageValue(data, depth)
        if depth > 6 or typeof(data) ~= "table" then return nil end
        local direct = safeTableGet(data, utf8.char(0))
            or safeTableGet(data, "Damage")
            or safeTableGet(data, "damage")
            or safeTableGet(data, "Amount")
            or safeTableGet(data, "amount")
        if type(direct) == "number" and direct > 0 then return direct end
        return findInTableValues(data, function(value)
            if typeof(value) == "table" then
                local found = getDamageValue(value, depth + 1)
                if found then return found end
            end
        end)
    end

    local function createDamageText(position, damage)
        if not position then return end
        local part = Instance.new("Part")
        part.Name = "LionHitDamageText"
        part.Anchored = true
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.Transparency = 1
        part.Size = Vector3.new(0.1, 0.1, 0.1)
        part.Position = position + Vector3.new(0, 1.5, 0)
        part.Parent = workspace

        local gui = Instance.new("BillboardGui")
        gui.AlwaysOnTop = true
        gui.Size = UDim2.fromOffset(100, 32)
        gui.StudsOffset = Vector3.new(0, 0.5, 0)
        gui.Parent = part

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.fromScale(1, 1)
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 24
        label.TextStrokeTransparency = 0
        label.TextColor3 = (HitEffectEnabled and HitEffectEnabled.Value) or Color3.fromRGB(255, 255, 255)
        label.Text = tostring(damage or "")
        label.Parent = gui

        task.spawn(function()
            local start = tick()
            while part.Parent and tick() - start < 0.7 do
                part.Position += Vector3.new(0, 0.035, 0)
                label.TextTransparency = math.clamp((tick() - start) / 0.7, 0, 1)
                label.TextStrokeTransparency = label.TextTransparency
                task.wait()
            end
        end)
        Debris:AddItem(part, 1)
    end

    local function createHitEffect(position, damage, hitPart)
        if not (HitEffectEnabled and HitEffectEnabled.Enabled and position) then return end
        local part = Instance.new("Part")
        part.Name = "LionHitEffect"
        part.Anchored = not (HitEffectWeld and HitEffectWeld.Enabled and hitPart and hitPart:IsA("BasePart"))
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.Size = Vector3.new(0.25, 0.25, 0.25)
        part.Transparency = 1
        part.CFrame = CFrame.new(position)
        part.Parent = workspace
        if not part.Anchored then
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = part
            weld.Part1 = hitPart
            weld.Parent = part
        end

        local color = (HitEffectEnabled and HitEffectEnabled.Value) or Color3.fromRGB(255, 255, 255)
        local emitter = Instance.new("ParticleEmitter")
        emitter.Color = ColorSequence.new(color)
        emitter.LightEmission = 1
        emitter.Rate = 0
        emitter.Lifetime = NumberRange.new(0.35, 0.7)
        emitter.Speed = NumberRange.new(6, 16)
        emitter.SpreadAngle = Vector2.new(360, 360)
        emitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.25),
            NumberSequenceKeypoint.new(1, 0)
        })
        emitter.Texture = "rbxassetid://243660364"
        emitter.Parent = part
        emitter:Emit(18)

        local selected = HitEffectsSelected and HitEffectsSelected.Value or {}
        if type(selected) ~= "table" then selected = {} end
        if next(selected) == nil or multiHas(selected, "Ring") or multiHas(selected, "Filled Circle") or multiHas(selected, "Ripple") then
            local orb = Instance.new("Part")
            orb.Name = "LionHitRing"
            orb.Shape = Enum.PartType.Ball
            orb.Anchored = true
            orb.CanCollide = false
            orb.CanQuery = false
            orb.CanTouch = false
            orb.Material = getMaterial(HitEffectMaterial and HitEffectMaterial.Value)
            orb.Color = color
            orb.Transparency = multiHas(selected, "Filled Circle") and 0.35 or 0.65
            orb.Size = Vector3.new(0.25, 0.25, 0.25)
            orb.Position = position
            orb.Parent = workspace
            task.spawn(function()
                local start = tick()
                while orb.Parent and tick() - start < 0.45 do
                    local alpha = (tick() - start) / 0.45
                    local size = 0.25 + alpha * 4
                    orb.Size = Vector3.new(size, size, size)
                    orb.Transparency = math.clamp(0.35 + alpha * 0.65, 0, 1)
                    task.wait()
                end
            end)
            Debris:AddItem(orb, 0.55)
        end

        if multiHas(selected, "Blades") or multiHas(selected, "slashes") or multiHas(selected, "Zap") then
            for i = 1, 4 do
                local slash = Instance.new("Part")
                slash.Name = "LionHitSlash"
                slash.Anchored = true
                slash.CanCollide = false
                slash.CanQuery = false
                slash.CanTouch = false
                slash.Material = Enum.Material.Neon
                slash.Color = color
                slash.Size = Vector3.new(0.06, 0.06, 2.5)
                slash.CFrame = CFrame.new(position) * CFrame.Angles(math.random() * math.pi, math.random() * math.pi, math.random() * math.pi)
                slash.Parent = workspace
                Debris:AddItem(slash, 0.25)
            end
        end

        if damage and (multiHas(selected, "fortnite damage") or multiHas(selected, "phantom forces")) then
            createDamageText(position, damage)
        end

        Debris:AddItem(part, 2)
    end

    local function getTracerColor()
        if CustomTracerColor and typeof(CustomTracerColor.Value) == "Color3" then
            return CustomTracerColor.Value
        end
        if CustomTracers and CustomTracers.Value then
            return CustomTracers.Value
        end
        return Color3.fromRGB(97, 131, 255)
    end

    local function createTracerBeam(startPos, endPos)
        if not (CustomTracers and CustomTracers.Enabled) then return end
        if typeof(startPos) ~= "Vector3" or typeof(endPos) ~= "Vector3" then return end
        if (endPos - startPos).Magnitude < 0.5 then return end

        local p0 = Instance.new("Part")
        p0.Name = "LionCustomTracerStart"
        p0.Anchored = true
        p0.CanCollide = false
        p0.CanQuery = false
        p0.CanTouch = false
        p0.Transparency = 1
        p0.Size = Vector3.new(0.1, 0.1, 0.1)
        p0.Position = startPos
        p0.Parent = workspace

        local p1 = p0:Clone()
        p1.Name = "LionCustomTracerEnd"
        p1.Position = endPos
        p1.Parent = workspace

        local a0 = Instance.new("Attachment")
        a0.Parent = p0
        local a1 = Instance.new("Attachment")
        a1.Parent = p1

        local color = getTracerColor()
        local beam = Instance.new("Beam")
        beam.Attachment0 = a0
        beam.Attachment1 = a1
        beam.Width0 = 0.35
        beam.Width1 = 0.08
        beam.LightEmission = 1
        beam.Brightness = 8
        beam.FaceCamera = true
        beam.Color = ColorSequence.new(color)
        beam.Parent = p0

        Debris:AddItem(p0, 1)
        Debris:AddItem(p1, 1)
    end

    local function isLocalItem(self)
        local clientItem = self and (self.ClientItem or self)
        local fighter = clientItem and clientItem.ClientFighter or (self and self.ClientFighter)
        if not fighter then return false end
        return fighter.IsLocalPlayer == true or fighter.Player == LocalPlayer
    end

    local function drawTracerFromShootData(self, data)
        if typeof(data) ~= "table" then return end
        local muzzle = getMuzzleWorld()
        if not muzzle then return end
        local rays = data.RaycastResults or data.Rays or data.Raycasts
        if typeof(rays) == "table" then
            for _, ray in ipairs(rays) do
                local startPos = ray.StartPosition or muzzle
                local endPos = ray.Position or ray.EndPosition
                createTracerBeam(startPos, endPos)
            end
        else
            local endPos = data.Position or data.EndPosition or data.HitPosition
            createTracerBeam(muzzle, endPos)
        end
    end

    local function isLocalTracerShot(self, data)
        if typeof(data) ~= "table" or data.IsLocal ~= true then
            return false
        end
        local fighter = self and self.ClientFighter
        if not fighter then return false end
        return fighter.IsLocalPlayer == true or fighter.Player == LocalPlayer
    end

    local function installTracerHook()
        if VisualState.TracerHooked then return end
        local ok, gunModule = pcall(function()
            return require(LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
        end)
        if not ok or type(gunModule) ~= "table" or type(gunModule._Tracers) ~= "function" then return end
        local currentTracers = gunModule._Tracers
        VisualState.OriginalTracers = VisualState.OriginalTracers or currentTracers
        gunModule._Tracers = function(self, data, ...)
            local result = {}
            if typeof(currentTracers) == "function" then
                local okResult, a, b, c, d, e = pcall(currentTracers, self, data, ...)
                if okResult then
                    result = {a, b, c, d, e}
                else
                    warn("[Custom Tracers] Tracers error:", a)
                end
            end
            if CustomTracers and CustomTracers.Enabled and isLocalTracerShot(self, data) then
                task.spawn(function()
                    pcall(drawTracerFromShootData, self, data)
                end)
            end
            return unpack(result)
        end
        VisualState.TracerHooked = true
    end

    local function installShootHook()
        if VisualState.ShootHooked then return end
        local ok, gunModule = pcall(function()
            return require(LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
        end)
        if not ok or not gunModule or type(gunModule._ShootEffect) ~= "function" then return end
        VisualState.OriginalShootEffect = VisualState.OriginalShootEffect or gunModule._ShootEffect
        gunModule._ShootEffect = function(self, data, ...)
            local suppressDefault = isLocalItem(self) and ShootSound and ShootSound.Enabled
            local snapshot = suppressDefault and collectShootSounds() or nil
            if suppressDefault then
                beginShootSoundSuppression(snapshot, 0.4)
            end
            local result = {VisualState.OriginalShootEffect(self, data, ...)}
            if isLocalItem(self) then
                if ShootSound and ShootSound.Enabled then
                    if snapshot then
                        suppressDefaultShootSounds(snapshot)
                        task.delay(0.03, beginShootSoundSuppression, snapshot, 0.25)
                        task.delay(0.08, beginShootSoundSuppression, snapshot, 0.25)
                    end
                    local now = os.clock()
                    if now - (VisualState.LastCustomShootSoundAt or 0) > 0.05 then
                        VisualState.LastCustomShootSoundAt = now
                        playSound(ShootSoundMode and ShootSoundMode.Value or "disable", ShootSoundVolume and ShootSoundVolume.Value or 0.3, ShootSoundSpeed and ShootSoundSpeed.Value or 1, ShootSoundStart and ShootSoundStart.Value or 0)
                    end
                end
            end
            return unpack(result)
        end
        if type(gunModule.StartShooting) == "function" then
            VisualState.OriginalStartShooting = VisualState.OriginalStartShooting or gunModule.StartShooting
            gunModule.StartShooting = function(self, ...)
                local suppressDefault = isLocalItem(self) and ShootSound and ShootSound.Enabled
                local snapshot = suppressDefault and collectShootSounds() or nil
                if suppressDefault then
                    beginShootSoundSuppression(snapshot, 0.4)
                end
                local result = {VisualState.OriginalStartShooting(self, ...)}
                if suppressDefault then
                    suppressDefaultShootSounds(snapshot)
                    task.delay(0.03, beginShootSoundSuppression, snapshot, 0.25)
                    local now = os.clock()
                    if result[1] and now - (VisualState.LastCustomShootSoundAt or 0) > 0.05 then
                        VisualState.LastCustomShootSoundAt = now
                        playSound(ShootSoundMode and ShootSoundMode.Value or "disable", ShootSoundVolume and ShootSoundVolume.Value or 0.3, ShootSoundSpeed and ShootSoundSpeed.Value or 1, ShootSoundStart and ShootSoundStart.Value or 0)
                    end
                end
                return unpack(result)
            end
        end
        VisualState.ShootHooked = true
    end

    local function installHitSoundHook()
        if VisualState.HitSoundHooked then return end
        local ok, viewmodelModule = pcall(function()
            return require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel)
        end)
        if not ok or type(viewmodelModule) ~= "table" or type(viewmodelModule.PlayHitmarkerSound) ~= "function" then return end
        VisualState.OriginalPlayHitmarkerSound = VisualState.OriginalPlayHitmarkerSound or viewmodelModule.PlayHitmarkerSound
        viewmodelModule.PlayHitmarkerSound = function(self, crit, divisor, ...)
            if HitSoundEnabled and HitSoundEnabled.Enabled then
                playSound(HitSoundName and HitSoundName.Value or "neverlose", HitSoundVolume and HitSoundVolume.Value or 0.5, 1, 0)
            end
            if RemoveHitSound and RemoveHitSound.Enabled then
                return
            end
            return VisualState.OriginalPlayHitmarkerSound(self, crit, divisor, ...)
        end
        VisualState.HitSoundHooked = true
    end

    local findHitPosition
    local findHitPart

    local function installDamageIndicatorHook()
        if VisualState.DamageIndicatorHooked then return end
        local ok, damageIndicators = pcall(function()
            return require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.FighterInterface.DamageIndicators)
        end)
        if not ok or type(damageIndicators) ~= "table" or type(damageIndicators.Create) ~= "function" then return end
        VisualState.OriginalDamageIndicatorCreate = VisualState.OriginalDamageIndicatorCreate or damageIndicators.Create
        damageIndicators.Create = function(self, ...)
            local args = table.pack(...)
            if HitEffectEnabled and HitEffectEnabled.Enabled and args.n > 0 then
                local data = args[1]
                local source = typeof(data) == "table"
                    and (safeTableGet(data, utf8.char(2))
                        or safeTableGet(data, "Source")
                        or safeTableGet(data, "Position")
                        or safeTableGet(data, "HitPart"))
                    or nil
                local hitPart = typeof(source) == "Instance" and (source:IsA("BasePart") and source or source:FindFirstChildWhichIsA("BasePart", true)) or nil
                local hitPos = hitPart and hitPart.Position or (typeof(source) == "Vector3" and source or findHitPosition(data, 0))
                local now = tick()
                if hitPos and now - (VisualState.LastIndicatorHitTime or 0) > 0.03 then
                    VisualState.LastIndicatorHitTime = now
                    createHitEffect(hitPos, getDamageValue(data, 0), hitPart)
                end
            end
            if DisableDamageNumbers and DisableDamageNumbers.Enabled then
                return
            end
            return VisualState.OriginalDamageIndicatorCreate(self, ...)
        end
        VisualState.DamageIndicatorHooked = true
    end

    findHitPosition = function(data, depth)
        if depth > 5 then return nil end
        if typeof(data) == "Instance" and data:IsA("BasePart") then return data.Position end
        if typeof(data) ~= "table" then return nil end
        local direct = safeTableGet(data, "Position")
            or safeTableGet(data, "HitPosition")
            or safeTableGet(data, "EndPosition")
        if typeof(direct) == "Vector3" then return direct end
        return findInTableValues(data, function(value)
            local pos = findHitPosition(value, depth + 1)
            if pos then return pos end
        end)
    end

    findHitPart = function(data, depth)
        if depth > 6 then return nil end
        if typeof(data) == "Instance" then
            if data:IsA("BasePart") then return data end
            return data:FindFirstChildWhichIsA("BasePart", true)
        end
        if typeof(data) ~= "table" then return nil end
        local direct = safeTableGet(data, "HitPart")
            or safeTableGet(data, "Hitbox")
            or safeTableGet(data, "Instance")
            or safeTableGet(data, "Part")
            or safeTableGet(data, "TargetPart")
            or safeTableGet(data, "Target")
        if typeof(direct) == "Instance" then
            if direct:IsA("BasePart") then return direct end
            local found = direct:FindFirstChildWhichIsA("BasePart", true)
            if found then return found end
        end
        return findInTableValues(data, function(value)
            local part = findHitPart(value, depth + 1)
            if part then return part end
        end)
    end

    local function installHitHook()
        if HitEffectEnabled and HitEffectEnabled.Enabled and not VisualState.DamageIndicatorHooked then
            installDamageIndicatorHook()
        end
        if VisualState.Hooked and VisualState.DamageNumberHooked then return end
        local ok, itemInterface = pcall(function()
            return require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ItemInterface)
        end)
        if ok and itemInterface and type(itemInterface.DamageEffect) == "function" and not VisualState.Hooked then
            VisualState.OriginalDamageEffect = VisualState.OriginalDamageEffect or itemInterface.DamageEffect
            itemInterface.DamageEffect = function(self, data, ...)
                local blockDefault = DisableHitMarker and DisableHitMarker.Enabled
                local result = {}
                if not blockDefault then
                    result = {VisualState.OriginalDamageEffect(self, data, ...)}
                end
                local now = tick()
                if now - (VisualState.LastHitTime or 0) > 0.03 then
                    VisualState.LastHitTime = now
                    if HitSoundEnabled and HitSoundEnabled.Enabled and ((RemoveHitSound and RemoveHitSound.Enabled) or not VisualState.HitSoundHooked) then
                        playSound(HitSoundName and HitSoundName.Value or "neverlose", HitSoundVolume and HitSoundVolume.Value or 0.5, 1, 0)
                    end
                    local hitPart = findHitPart(data, 0)
                    local hitPos = (hitPart and hitPart.Position) or findHitPosition(data, 0)
                    if not hitPos then
                        local _, part = getClosestTarget()
                        hitPart = part
                        hitPos = part and part.Position or getMuzzleWorld()
                    end
                    createHitEffect(hitPos, getDamageValue(data, 0), hitPart)
                end
                return unpack(result)
            end
            VisualState.Hooked = true
        end

        if not VisualState.DamageNumberHooked then
            pcall(function()
                local fighterController = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
                local fighter = fighterController.LocalFighter or fighterController:GetFighter(LocalPlayer)
                local fighterClass = fighter and getmetatable(fighter)
                fighterClass = fighterClass and fighterClass.__index
                if type(fighterClass) ~= "table" or type(fighterClass._DamageNumberEffect) ~= "function" then return end
                VisualState.OriginalDamageNumberEffect = VisualState.OriginalDamageNumberEffect or fighterClass._DamageNumberEffect
                fighterClass._DamageNumberEffect = function(...)
                    local args = table.pack(...)
                    local now = tick()
                    if now - (VisualState.LastHitTime or 0) > 0.03 then
                        local hitPart
                        local damage
                        for i = 1, args.n do
                            hitPart = hitPart or findHitPart(args[i], 0)
                            damage = damage or getDamageValue(args[i], 0)
                        end
                        if hitPart then
                            VisualState.LastHitTime = now
                            createHitEffect(hitPart.Position, damage, hitPart)
                        end
                    end
                    local result = table.pack(VisualState.OriginalDamageNumberEffect(...))
                    return unpack(result, 1, result.n)
                end
                VisualState.DamageNumberHooked = true
            end)
        end
    end

    local function updateTargetVisuals()
        hideDrawingSet(VisualState.TargetDrawings)
        if not Drawing then return end
        if not ((TargetTracer and TargetTracer.Enabled) or (TargetHighlight and TargetHighlight.Enabled)) then return end
        local _, part = getClosestTarget()
        if not part then return end
        local screen, visible = worldToScreen(part.Position)
        if not visible and (TargetCulling and TargetCulling.Value) ~= "AlwaysOnTop" then return end
        if TargetTracer and TargetTracer.Enabled then
            local line = VisualState.TargetDrawings.tracer or Drawing.new("Line")
            VisualState.TargetDrawings.tracer = line
            local muzzle, muzzleVisible = worldToScreen(getMuzzleWorld())
            line.From = muzzleVisible and muzzle or (workspace.CurrentCamera.ViewportSize / 2)
            line.To = screen
            line.Color = TargetTracer.Value or Color3.fromRGB(255, 255, 255)
            line.Thickness = 2
            line.Visible = true
        end
        if TargetHighlight and TargetHighlight.Enabled then
            local box = VisualState.TargetDrawings.highlight or Drawing.new("Square")
            VisualState.TargetDrawings.highlight = box
            box.Size = Vector2.new(22, 22)
            box.Position = screen - Vector2.new(11, 11)
            box.Color = TargetHighlight.Value or Color3.fromRGB(255, 255, 255)
            box.Thickness = 2
            box.Filled = false
            box.Visible = true
        end
    end

    local function updateIndicators()
        local texts = {}
        if IndicatorManipulated and IndicatorManipulated.Enabled then table.insert(texts, "manipulated") end
        if IndicatorRagebot and IndicatorRagebot.Enabled then table.insert(texts, "ragebot") end
        if IndicatorAmmo and IndicatorAmmo.Enabled then
            local fighter = getLocalFighter()
            local item = fighter and fighter.EquippedItem
            local ammo = item and item.Get and item:Get("Ammo") or "?"
            local reserve = item and item.Get and item:Get("AmmoReserve") or "?"
            table.insert(texts, tostring(ammo) .. ", " .. tostring(reserve))
        end
        if #texts == 0 then
            hideDrawingSet(VisualState.IndicatorDrawings)
            return
        end
        if not Drawing then return end
        hideDrawingSet(VisualState.IndicatorDrawings)
        local origin = UserInputService and UserInputService:GetMouseLocation() or (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize / 2) or Vector2.new(500, 500)
        if IndicatorPosition and IndicatorPosition.Value == "position on target" then
            local _, part = getClosestTarget()
            if part then
                local screen, visible = worldToScreen(part.Position)
                if visible then origin = screen end
            end
        elseif IndicatorPosition and IndicatorPosition.Value == "position on barrel" then
            local screen, visible = worldToScreen(getMuzzleWorld())
            if visible then origin = screen end
        end
        origin += Vector2.new(IndicatorOffsetX and IndicatorOffsetX.Value or 0, IndicatorOffsetY and IndicatorOffsetY.Value or 25)
        local previous = VisualState.IndicatorOrigin
        local lerp = math.clamp(IndicatorLerp and IndicatorLerp.Value or 1, 0, 1)
        if previous and lerp < 1 then
            origin = previous:Lerp(origin, lerp)
        end
        VisualState.IndicatorOrigin = origin
        for i, text in ipairs(texts) do
            local obj = VisualState.IndicatorDrawings[i] or Drawing.new("Text")
            VisualState.IndicatorDrawings[i] = obj
            obj.Text = (IndicatorTextStyle and IndicatorTextStyle.Value == "upper") and text:upper() or text:lower()
            obj.Position = origin + Vector2.new(0, (i - 1) * 14)
            obj.Color = Color3.fromRGB(255, 255, 255)
            obj.Size = 13
            obj.Center = true
            obj.Outline = true
            obj.Visible = true
        end
    end

    local function setGameCrosshairDisabled(disabled)
        local gui = LocalPlayer:FindFirstChild("PlayerGui")
        if not gui then return end
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj.Name:lower():find("crosshair", 1, true) then
                if obj:IsA("ScreenGui") or obj:IsA("GuiObject") then
                    if VisualState.OriginalCrosshairEnabled == nil and obj:IsA("ScreenGui") then
                        VisualState.OriginalCrosshairEnabled = obj.Enabled
                    end
                    pcall(function()
                        if obj:IsA("ScreenGui") then obj.Enabled = not disabled else obj.Visible = not disabled end
                    end)
                end
            end
        end
    end

    local function reapplyGameCrosshairDisabled()
        if DisableGameCrosshair and DisableGameCrosshair.Enabled then
            VisualState.GameCrosshairDisabled = true
            setGameCrosshairDisabled(true)
        end
    end

    local nextHookCheck = 0
    local nextViewmodelUpdate = 0
    local nextItemStatusUpdate = 0
    local nextTargetUpdate = 0
    local nextIndicatorUpdate = 0
    local nextIdleVisualUpdate = 0
    local nextCrosshairDisableApply = 0

    local function dropdownHasAny(option)
        local value = option and option.Value
        if type(value) ~= "table" then return false end
        for _, enabled in pairs(value) do
            if enabled then return true end
        end
        return false
    end

    local function updateAll()
        local now = os.clock()
        local realtimeVisualsActive = (CrosshairEnabled and CrosshairEnabled.Enabled)
            or (TargetTracer and TargetTracer.Enabled)
            or (TargetHighlight and TargetHighlight.Enabled)
            or (IndicatorManipulated and IndicatorManipulated.Enabled)
            or (IndicatorRagebot and IndicatorRagebot.Enabled)
            or (IndicatorAmmo and IndicatorAmmo.Enabled)
        if not realtimeVisualsActive and not VisualState.ViewmodelDirty and now < nextIdleVisualUpdate then
            return
        end
        nextIdleVisualUpdate = now + (realtimeVisualsActive and 0 or 0.1)

        if now >= nextHookCheck then
            nextHookCheck = now + 0.25
            installViewmodelHooks()
            if disableSelected("aiming animation") then installAimingHooks() end
            if ShootSound and ShootSound.Enabled then
                installShootHook()
            end
            if CustomTracers and CustomTracers.Enabled then installTracerHook() end
            if (HitSoundEnabled and HitSoundEnabled.Enabled) or (RemoveHitSound and RemoveHitSound.Enabled) then installHitSoundHook() end
            if DisableDamageNumbers and DisableDamageNumbers.Enabled then installDamageIndicatorHook() end
            if (HitEffectEnabled and HitEffectEnabled.Enabled)
                or (DisableHitMarker and DisableHitMarker.Enabled)
                or (DisableDamageNumbers and DisableDamageNumbers.Enabled)
                or (RemoveHitSound and RemoveHitSound.Enabled) then
                installHitHook()
            end
        end

        local viewmodelLoopActive = VisualState.ViewmodelDirty
            or VisualState.WireframeWasEnabled
            or dropdownHasAny(VMDisabled)
            or (VMOffset and VMOffset.Enabled)
            or (VMOverrideFps and VMOverrideFps.Enabled)
            or (ViewmodelAppearance and ViewmodelAppearance.Enabled)
            or (VMChams and VMChams.Enabled)
            or (VMWireframe and VMWireframe.Enabled)
            or (VMDisableTextures and VMDisableTextures.Enabled)
            or (ArmAppearance and ArmAppearance.Enabled)
            or (ArmDisableClothes and ArmDisableClothes.Enabled)
        local viewmodelRealtimeActive = VMOffset and VMOffset.Enabled
        if VisualState.ViewmodelDirty or viewmodelRealtimeActive or now >= nextViewmodelUpdate then
            nextViewmodelUpdate = now + (viewmodelRealtimeActive and 0 or (viewmodelLoopActive and 0.16 or 0.75))
            applyViewmodelOptions()
        end

        if OverrideWeaponStatus and OverrideWeaponStatus.Enabled and now >= nextItemStatusUpdate then
            nextItemStatusUpdate = now + 0.75
            applyItemStatus()
        end

        if CrosshairEnabled and CrosshairEnabled.Enabled then
            VisualState.CrosshairWasVisible = true
            updateCrosshair()
        elseif VisualState.CrosshairWasVisible then
            VisualState.CrosshairWasVisible = false
            hideDrawingSet(VisualState.CrosshairDrawings)
        end

        local targetActive = (TargetTracer and TargetTracer.Enabled) or (TargetHighlight and TargetHighlight.Enabled)
        if targetActive then
            nextTargetUpdate = now
            VisualState.TargetWasVisible = true
            updateTargetVisuals()
        elseif not targetActive and VisualState.TargetWasVisible then
            VisualState.TargetWasVisible = false
            hideDrawingSet(VisualState.TargetDrawings)
        end

        local indicatorsActive = (IndicatorManipulated and IndicatorManipulated.Enabled)
            or (IndicatorRagebot and IndicatorRagebot.Enabled)
            or (IndicatorAmmo and IndicatorAmmo.Enabled)
        if indicatorsActive then
            nextIndicatorUpdate = now
            VisualState.IndicatorsWereVisible = true
            updateIndicators()
        elseif not indicatorsActive and VisualState.IndicatorsWereVisible then
            VisualState.IndicatorsWereVisible = false
            hideDrawingSet(VisualState.IndicatorDrawings)
        end

        local crosshairDisabled = DisableGameCrosshair and DisableGameCrosshair.Enabled or false
        if VisualState.GameCrosshairDisabled ~= crosshairDisabled or (crosshairDisabled and now >= nextCrosshairDisableApply) then
            VisualState.GameCrosshairDisabled = crosshairDisabled
            nextCrosshairDisableApply = now + 1
            setGameCrosshairDisabled(crosshairDisabled)
        end
    end

    local function noOpUpdate()
        markViewmodelDirty()
        task.defer(updateAll)
    end

    local ViewmodelGroup = Render:AddModule({Name = "viewmodel", HideEnabled = true})
    local CosmeticChangerToggle
    CosmeticChangerToggle = ViewmodelGroup:AddToggle({Name = "show cosmetics changer", Function = function(callback)
        shared.LionCosmeticChangerToggle = CosmeticChangerToggle
        if callback then
            task.spawn(function()
                for _ = 1, 80 do
                    if shared.LionCosmeticChanger and shared.LionCosmeticChanger.SetVisible then
                        shared.LionCosmeticChanger.SetVisible(true)
                        return
                    end
                    task.wait(0.05)
                end
            end)
        elseif shared.LionCosmeticChanger and shared.LionCosmeticChanger.SetVisible then
            shared.LionCosmeticChanger.SetVisible(false)
        end
    end})
    shared.LionCosmeticChangerToggle = CosmeticChangerToggle
    VMDisabled = ViewmodelGroup:AddDropdown({Name = "disable", List = viewmodelDisableList, Default = {}, Multi = true, Function = function()
        installViewmodelHooks()
        if disableSelected("aiming animation") then installAimingHooks() end
        noOpUpdate()
    end})
    VMOverrideFps = ViewmodelGroup:AddToggle({Name = "override fps", Function = noOpUpdate})
    VMFps = ViewmodelGroup:AddSlider({Name = "fps", Min = 1, Max = 240, Default = 60, Function = noOpUpdate})
    VMRecoil = ViewmodelGroup:AddSlider({Name = "recoil percent", Min = 0, Max = 100, Default = 100, Suffix = "%"})
    VMChams = ViewmodelGroup:AddToggle({Name = "chams", Color = Color3.fromRGB(255, 255, 255), Colors = {Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)}, Function = noOpUpdate})
    VMChamFill = ViewmodelGroup:AddSlider({Name = "fill transparency", Min = 0, Max = 100, Default = 2, Function = noOpUpdate})
    VMChamOutline = ViewmodelGroup:AddSlider({Name = "outline transparency", Min = 0, Max = 100, Default = 1, Function = noOpUpdate})
    VMChamSettings = ViewmodelGroup:AddDropdown({Name = "cham settings", List = {"through walls"}, Default = "through walls"})
    VMOffset = ViewmodelGroup:AddToggle({Name = "offset", Function = noOpUpdate})
    VMOffsetX = ViewmodelGroup:AddSlider({Name = "x", Min = -10, Max = 10, Default = 0, Decimal = 10, Function = noOpUpdate})
    VMOffsetY = ViewmodelGroup:AddSlider({Name = "y", Min = -10, Max = 10, Default = 0, Decimal = 10, Function = noOpUpdate})
    VMOffsetZ = ViewmodelGroup:AddSlider({Name = "z", Min = -10, Max = 10, Default = 0, Decimal = 10, Function = noOpUpdate})
    ViewmodelGroup:AddButton({Text = "reset offset to default", Func = function()
        if VMOffsetX then VMOffsetX.Value = 0 end
        if VMOffsetY then VMOffsetY.Value = 0 end
        if VMOffsetZ then VMOffsetZ.Value = 0 end
    end})

    local CustomTracerGroup = Render:AddModule({Name = "custom tracers", HideEnabled = true})
    CustomTracers = CustomTracerGroup:AddToggle({Name = "enabled", Colors = {Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)}, Function = installTracerHook})
    CustomTracerColor = CustomTracerGroup:AddColorPicker({Name = "tracer color", Default = Color3.fromRGB(97, 131, 255)})

    local ShootSoundGroup = Render:AddModule({Name = "shoot sound", HideEnabled = true})
    ShootSound = ShootSoundGroup:AddToggle({Name = "change sound", Function = installShootHook})
    ShootSoundMode = ShootSoundGroup:AddDropdown({Name = "sound", List = {"disable", "neverlose", "gamesense", "skeet", "rust", "bell", "bubble", "minecraft", "osu", "tf2", "custom"}, Default = "disable"})
    ShootCustomId = ShootSoundGroup:AddInputBox({Name = "id", Default = "4049646104", Numeric = true})
    ShootSoundSpeed = ShootSoundGroup:AddSlider({Name = "speed", Min = 0.1, Max = 5, Default = 1, Decimal = 10})
    ShootSoundVolume = ShootSoundGroup:AddSlider({Name = "volume", Min = 0, Max = 5, Default = 0.3, Decimal = 10})
    ShootSoundStart = ShootSoundGroup:AddSlider({Name = "start position", Min = 0, Max = 10, Default = 0, Decimal = 10})
    ShootSoundGroup:AddButton({Text = "preview sound", Func = function()
        playSound(ShootSoundMode and ShootSoundMode.Value or "disable", ShootSoundVolume and ShootSoundVolume.Value or 0.3, ShootSoundSpeed and ShootSoundSpeed.Value or 1, ShootSoundStart and ShootSoundStart.Value or 0)
    end})

    OverrideGroup = Render:AddModule({Name = "override", HideEnabled = true})
    ViewmodelAppearance = OverrideGroup:AddToggle({Name = "viewmodel appearance", Function = noOpUpdate})
    VMColor = OverrideGroup:AddColorPicker({Name = "color", Default = Color3.fromRGB(255, 255, 255), Function = noOpUpdate})
    VMMaterial = OverrideGroup:AddDropdown({Name = "material", List = materialList, Default = "ForceField", Function = noOpUpdate})
    VMWireframe = OverrideGroup:AddToggle({Name = "wireframe", Function = noOpUpdate})
    VMDisableTextures = OverrideGroup:AddToggle({Name = "disable textures", Function = noOpUpdate})
    VMTransparency = OverrideGroup:AddSlider({Name = "transparency", Min = 0, Max = 100, Default = 100, Suffix = "%", Function = noOpUpdate})
    ArmAppearance = OverrideGroup:AddToggle({Name = "arm appearance", Function = noOpUpdate})
    ArmColor = OverrideGroup:AddColorPicker({Name = "arm color", Default = Color3.fromRGB(255, 255, 255), Function = noOpUpdate})
    ArmMaterial = OverrideGroup:AddDropdown({Name = "arm material", List = materialList, Default = "ForceField", Function = noOpUpdate})
    ArmDisableClothes = OverrideGroup:AddToggle({Name = "disable clothes", Function = noOpUpdate})
    ArmTransparency = OverrideGroup:AddSlider({Name = "arm transparency", Min = 0, Max = 100, Default = 100, Suffix = "%", Function = noOpUpdate})

    ItemGroup = Render:AddModule({Name = "item", HideEnabled = true})
    RemoveVignette = ItemGroup:AddToggle({Name = "remove vignette"})
    OverrideWeaponStatus = ItemGroup:AddToggle({Name = "override weapon status", Function = noOpUpdate})
    WeaponStatus = ItemGroup:AddDropdown({Name = "status", List = statusList, Default = "Prime", Function = noOpUpdate})

    CrosshairGroup = Render:AddModule({Name = "crosshair", HideEnabled = true})
    CrosshairEnabled = CrosshairGroup:AddToggle({Name = "enabled", Color = Color3.fromRGB(255, 255, 255), Colors = {Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)}})
    CrosshairOutline = CrosshairGroup:AddToggle({Name = "outline", Color = Color3.fromRGB(0, 0, 0), Colors = {Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0)}})
    CrosshairRotation = CrosshairGroup:AddSlider({Name = "rotation", Min = 0, Max = 360, Default = 0, Suffix = "deg"})
    CrosshairSpeed = CrosshairGroup:AddSlider({Name = "speed", Min = 0, Max = 5, Default = 0.2, Decimal = 10, Suffix = "rps"})
    CrosshairBounce = CrosshairGroup:AddSlider({Name = "bounce", Min = 0, Max = 50, Default = 0, Suffix = "px"})
    CrosshairSpeedMult = CrosshairGroup:AddSlider({Name = "speed", Min = 0.1, Max = 5, Default = 1, Decimal = 10, Suffix = "x"})
    CrosshairOffset = CrosshairGroup:AddSlider({Name = "offset", Min = 0, Max = 50, Default = 5, Suffix = "px"})
    CrosshairLength = CrosshairGroup:AddSlider({Name = "length", Min = 1, Max = 80, Default = 20, Suffix = "px"})
    CrosshairThickness = CrosshairGroup:AddSlider({Name = "thickness", Min = 1, Max = 10, Default = 2, Suffix = "px"})
    CrosshairLerp = CrosshairGroup:AddSlider({Name = "lerp", Min = 0, Max = 10, Default = 1, Decimal = 10, Suffix = "x"})
    CrosshairPosition = CrosshairGroup:AddDropdown({Name = "position", List = positionList, Default = "-"})
    DisableGameCrosshair = CrosshairGroup:AddToggle({Name = "disable game crosshair", Function = noOpUpdate})
    table.insert(mainapi.Connections, LocalPlayer.CharacterAdded:Connect(function()
        task.defer(reapplyGameCrosshairDisabled)
        task.delay(0.5, reapplyGameCrosshairDisabled)
        task.delay(1.5, reapplyGameCrosshairDisabled)
    end))
    local function hookPlayerGui(gui)
        table.insert(mainapi.Connections, gui.ChildAdded:Connect(function()
            task.defer(reapplyGameCrosshairDisabled)
        end))
    end
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        hookPlayerGui(playerGui)
    end
    table.insert(mainapi.Connections, LocalPlayer.ChildAdded:Connect(function(child)
        if child.Name == "PlayerGui" then
            hookPlayerGui(child)
            task.defer(reapplyGameCrosshairDisabled)
            task.delay(0.5, reapplyGameCrosshairDisabled)
        end
    end))

    HitEffectsGroup = Render:AddModule({Name = "hit effects", HideEnabled = true})
    HitEffectEnabled = HitEffectsGroup:AddToggle({Name = "enabled", Colors = {Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)}, Function = installHitHook})
    HitEffectWeld = HitEffectsGroup:AddToggle({Name = "weld to player"})
    HitEffectsSelected = HitEffectsGroup:AddDropdown({Name = "effects selected", List = effectList, Default = {}, Multi = true})
    HitEffectSettings = HitEffectsGroup:AddDropdown({Name = "effect settings", List = effectSettingList, Default = {}, Multi = true})
    HitEffectMaterial = HitEffectsGroup:AddDropdown({Name = "preferred material", List = materialList, Default = "ForceField"})
    DisableHitMarker = HitEffectsGroup:AddToggle({Name = "disable hit marker"})
    DisableDamageNumbers = HitEffectsGroup:AddToggle({Name = "disable damage numbers", Function = installDamageIndicatorHook})

    HitSoundsGroup = Render:AddModule({Name = "hit sounds", HideEnabled = true})
    HitSoundEnabled = HitSoundsGroup:AddToggle({Name = "enabled", Function = function()
        installHitSoundHook()
        installHitHook()
    end})
    HitSoundVolume = HitSoundsGroup:AddSlider({Name = "volume", Min = 0, Max = 5, Default = 0.5, Decimal = 10})
    HitSoundName = HitSoundsGroup:AddDropdown({Name = "sound", List = {"neverlose", "gamesense", "skeet", "rust", "bell", "bubble", "minecraft", "osu", "tf2", "custom"}, Default = "neverlose"})
    HitSoundsGroup:AddButton({Text = "preview sound", Func = function()
        playSound(HitSoundName and HitSoundName.Value or "neverlose", HitSoundVolume and HitSoundVolume.Value or 0.5, 1, 0)
    end})
    RemoveHitSound = HitSoundsGroup:AddToggle({Name = "remove hit sound", Function = installHitSoundHook})

    local TargetHudVisual = Render:AddModule({Name = "target hud", Function = function(callback)
        if TargetHudMain then
            TargetHudMain.Visible = callback == true
        end
    end})

    IndicatorsGroup = Render:AddModule({Name = "indicators", HideEnabled = true})
    IndicatorManipulated = IndicatorsGroup:AddToggle({Name = "manipulated"})
    IndicatorRagebot = IndicatorsGroup:AddToggle({Name = "ragebot", Colors = {Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)}})
    IndicatorStyle = IndicatorsGroup:AddDropdown({Name = "ragebot style", List = {"text, status"}, Default = "text, status"})
    IndicatorAmmo = IndicatorsGroup:AddToggle({Name = "ammo", Colors = {Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)}})
    IndicatorAmmoStyle = IndicatorsGroup:AddDropdown({Name = "ammo style", List = ammoStyleList, Default = "ammo"})
    IndicatorLerp = IndicatorsGroup:AddSlider({Name = "lerp", Min = 0, Max = 10, Default = 1, Decimal = 10, Suffix = "x"})
    IndicatorOffsetX = IndicatorsGroup:AddSlider({Name = "offset x", Min = -200, Max = 200, Default = 0, Suffix = "px"})
    IndicatorOffsetY = IndicatorsGroup:AddSlider({Name = "offset y", Min = -200, Max = 200, Default = 25, Suffix = "px"})
    IndicatorFont = IndicatorsGroup:AddDropdown({Name = "font", List = fontList, Default = "monocraft"})
    IndicatorTextStyle = IndicatorsGroup:AddDropdown({Name = "text style", List = textStyleList, Default = "lower"})
    IndicatorPosition = IndicatorsGroup:AddDropdown({Name = "position", List = positionList, Default = "-"})

    TargetGroup = Render:AddModule({Name = "target", HideEnabled = true})
    TargetTracer = TargetGroup:AddToggle({Name = "tracer", Color = Color3.fromRGB(255,255,255), Function = noOpUpdate})
    TargetHighlight = TargetGroup:AddToggle({Name = "highlight", Colors = {Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)}, Function = noOpUpdate})
    TargetCulling = TargetGroup:AddDropdown({Name = "culling mode", List = cullingList, Default = "AlwaysOnTop"})

    mainapi:Clean(RunService.RenderStepped:Connect(updateAll))
    mainapi:Clean(function()
        hideDrawingSet(VisualState.CrosshairDrawings)
        hideDrawingSet(VisualState.TargetDrawings)
        hideDrawingSet(VisualState.IndicatorDrawings)
        hideWireframeDrawings(1)
        destroyWireframeAdornments()
    end)
end)

run(function()
    local AutoQueue, GameMode
    local queueLookup = {}
    local queueLoopRunning = false
    local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

    local function getQueueData()
        local list = {}
        local ok, duelLibrary = pcall(function()
            return require(ReplicatedStorage.Modules.DuelLibrary)
        end)
        if ok and duelLibrary then
            for _, queueName in pairs(duelLibrary.MatchmakingQueueOrder or {}) do
                local info = duelLibrary.MatchmakingQueues and duelLibrary.MatchmakingQueues[queueName]
                local display = info and info.DisplayName or queueName
                table.insert(list, display)
                queueLookup[display] = queueName
            end
        end
        if #list == 0 then
            list = {"1v1", "2v2_beginner"}
            queueLookup["1v1"] = "1v1"
            queueLookup["2v2_beginner"] = "2v2_beginner"
        end
        return list
    end

    local function queueIntoSelected()
        local queueName = queueLookup[GameMode and GameMode.Value or "1v1"] or (GameMode and GameMode.Value) or "1v1"
        local ok, controller = pcall(function()
            return require(LocalPlayer.PlayerScripts.Controllers.MatchmakingController)
        end)
        if ok and controller and controller.QueueInto then
            return controller:QueueInto(queueName)
        end

        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local matchmaking = remotes and remotes:FindFirstChild("Matchmaking")
        local joinQueue = matchmaking and matchmaking:FindFirstChild("JoinQueue")
        if joinQueue and joinQueue.InvokeServer then
            return joinQueue:InvokeServer(queueName)
        end
    end

    AutoQueue = Other:AddModule({
        Name = "auto queue",
        Function = function(callback)
            if callback and not queueLoopRunning then
                queueLoopRunning = true
                task.spawn(function()
                    while AutoQueue.Enabled do
                        pcall(queueIntoSelected)
                        task.wait(5)
                    end
                    queueLoopRunning = false
                end)
            else
                pcall(function()
                    ReplicatedStorage.Remotes.Matchmaking.LeaveQueue:FireServer()
                end)
            end
        end
    })

    GameMode = AutoQueue:AddDropdown({
        Name = "Game Mode",
        List = getQueueData(),
        Default = "1v1",
        Function = function()
            if AutoQueue.Enabled then
                pcall(queueIntoSelected)
            end
        end
    })
end)

run(function()
	local NameSpoofer
	local SpoofedName
	local spoofEnabled = false
	local spoofName = ""
	local originalUserName = LocalPlayer.Name
	local originalDisplayName = LocalPlayer.DisplayName
	local textCache = setmetatable({}, {__mode = "k"})
	local textConnections = setmetatable({}, {__mode = "k"})
	local humanoidCache = setmetatable({}, {__mode = "k"})
	local rootConnections = {}

	local function replacePlain(text, search, replacement)
		if search == "" or text == "" then return text end
		local result = {}
		local cursor = 1
		while true do
			local first, last = string.find(text, search, cursor, true)
			if not first then
				table.insert(result, string.sub(text, cursor))
				break
			end
			table.insert(result, string.sub(text, cursor, first - 1))
			table.insert(result, replacement)
			cursor = last + 1
		end
		return table.concat(result)
	end

	local function spoofText(text)
		if spoofName == "" then return tostring(text) end
		local result = tostring(text)
		local displayName = originalDisplayName
		local userName = originalUserName
		if displayName ~= userName then
			result = replacePlain(result, displayName, spoofName)
		end
		result = replacePlain(result, "@" .. userName, "@" .. spoofName)
		result = replacePlain(result, userName, spoofName)
		return result
	end

	local function applyTextObject(object)
		if not (object:IsA("TextLabel") or object:IsA("TextButton")) then return end
		pcall(function()
			local current = object.Text
			local cached = textCache[object]
			if cached == nil then
				cached = {Original = current, Spoofed = nil}
				textCache[object] = cached
			elseif current ~= cached.Spoofed then
				cached.Original = current
			end
			local spoofed = spoofText(cached.Original)
			cached.Spoofed = spoofed
			if current ~= spoofed then
				object.Text = spoofed
			end

			if not textConnections[object] then
				textConnections[object] = object:GetPropertyChangedSignal("Text"):Connect(function()
					if not spoofEnabled or spoofName == "" then return end
					applyTextObject(object)
				end)
			end
		end)
	end

	local function applyNameSpoof()
		if spoofName == "" then return end
		local character = LocalPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			pcall(function()
				if humanoidCache[humanoid] == nil then
					humanoidCache[humanoid] = humanoid.DisplayName
				end
				humanoid.DisplayName = spoofName
			end)
		end

		for _, root in ipairs({LocalPlayer:FindFirstChildOfClass("PlayerGui"), game:GetService("CoreGui")}) do
			if root then
				pcall(function()
					for _, object in ipairs(root:GetDescendants()) do
						applyTextObject(object)
					end
				end)
			end
		end
	end

	local function restoreNameSpoof()
		for object, cached in pairs(textCache) do
			if object and object.Parent then
				pcall(function()
					object.Text = cached.Original
				end)
			end
		end
		table.clear(textCache)

		for humanoid, original in pairs(humanoidCache) do
			if humanoid and humanoid.Parent then
				pcall(function()
					humanoid.DisplayName = original
				end)
			end
		end
		table.clear(humanoidCache)
	end

	local function hookRoot(root)
		if not root or rootConnections[root] then return end
		rootConnections[root] = root.DescendantAdded:Connect(function(object)
			if not spoofEnabled then return end
			if object:IsA("TextLabel") or object:IsA("TextButton") then
				applyTextObject(object)
			end
		end)
	end

	hookRoot(LocalPlayer:FindFirstChildOfClass("PlayerGui"))
	hookRoot(CoreGui)
	mainapi:Clean(LocalPlayer.ChildAdded:Connect(function(child)
		if child.Name == "PlayerGui" then
			hookRoot(child)
			if spoofEnabled then
				task.defer(applyNameSpoof)
			end
		end
	end))
	mainapi:Clean(function()
		for _, connection in pairs(rootConnections) do
			pcall(function() connection:Disconnect() end)
		end
		for _, connection in pairs(textConnections) do
			pcall(function() connection:Disconnect() end)
		end
	end)

	local nameSpoofState = getgenv().__LionNameSpoofState
	if not nameSpoofState then
		nameSpoofState = {
			Enabled = false,
			Name = "",
			Player = LocalPlayer,
		}
		getgenv().__LionNameSpoofState = nameSpoofState

		if hookmetamethod then
			local oldIndex
			oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
				if nameSpoofState.Enabled
					and nameSpoofState.Name ~= ""
					and self == nameSpoofState.Player
					and (not checkcaller or not checkcaller())
					and (key == "Name" or key == "DisplayName") then
					return nameSpoofState.Name
				end
				return oldIndex(self, key)
			end))
		end
	end

	nameSpoofState.Player = LocalPlayer
	nameSpoofState.Enabled = false
	nameSpoofState.Name = ""

	NameSpoofer = Other:AddModule({
		Name = "Name Spoofer",
		Function = function(callback)
			spoofEnabled = callback == true
			nameSpoofState.Enabled = spoofEnabled
			nameSpoofState.Name = spoofName
			if spoofEnabled then
				applyNameSpoof()
			else
				restoreNameSpoof()
			end
		end
	})

	SpoofedName = NameSpoofer:AddInputBox({
		Name = "name",
		Default = "",
		Placeholder = "nosniy...",
		Function = function(value)
			spoofName = tostring(value or "")
			nameSpoofState.Name = spoofName
			if spoofEnabled then
				applyNameSpoof()
			end
		end
	})

	mainapi:Clean(LocalPlayer.CharacterAdded:Connect(function()
		if spoofEnabled then
			task.defer(applyNameSpoof)
		end
	end))

	mainapi:Clean(function()
		spoofEnabled = false
		restoreNameSpoof()
		nameSpoofState.Enabled = false
		nameSpoofState.Name = ""
	end)
end)

run(function()
	local DeviceSpoofer
	local Mode
	local function getCurrentDevice()
		if game:GetService("VRService").VREnabled then return "VR" end
		if UserInputService.TouchEnabled then return "Touch" end
		if UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled then return "Gamepad" end
		return "MouseKeyboard"
	end

	local function setDevice(mode)
		pcall(function()
			ReplicatedStorage.Remotes.Replication.Fighter.SetControls:FireServer(mode)
		end)
	end

	DeviceSpoofer = Other:AddModule({
		Name = 'Device Spoofer',
		Function = function(callback)
			if callback then
				setDevice(Mode.Value)
			else
				setDevice(getCurrentDevice())
			end
		end
	})

	Mode = DeviceSpoofer:AddDropdown({
		Name = 'Mode',
		List = {'Touch', 'Gamepad', 'MouseKeyboard', 'VR'},
		Default = 'MouseKeyboard',
		Function = function(val)
			if DeviceSpoofer.Enabled then
				setDevice(val)
			end
		end
	})

	DeviceSpoofer:Clean(LocalPlayer.CharacterAdded:Connect(function()
		if DeviceSpoofer.Enabled then
			task.wait(0.5)
			setDevice(Mode.Value)
		end
	end))
end)


run(function()
    local AntiKatana = Player:AddModule({
        Name = "Anti Katana",
        Tooltip = "Blocks shots when enemies use katana deflect",
        Function = function(callback)
            _G.AntiKatanaState = _G.AntiKatanaState or {
                Enabled = false,
                DeflectingEnemies = {},
                HookedKatana = false,
                HookedFireServer = false,
                CurrentDeflectSound = nil,
                IsDeflectSoundPlaying = false,
                KatanaModule = nil,
                KatanaClass = nil,
                OriginalReplicateFromServer = nil,
                StartShootingEnum = nil,
                UseItemRemote = nil
            }

            local state = _G.AntiKatanaState
            state.Enabled = callback

            local function stopDeflectSound()
                if state.CurrentDeflectSound then
                    pcall(function()
                        state.CurrentDeflectSound:Stop()
                        state.CurrentDeflectSound:Destroy()
                    end)
                    state.CurrentDeflectSound = nil
                end
                state.IsDeflectSoundPlaying = false
            end

            if not callback then
                state.DeflectingEnemies = {}
                stopDeflectSound()
                return
            end

            local function safeRequire(module)
                local ok, result = pcall(require, module)
                if ok then
                    return result
                end
                warn("Anti-Katana: require failed ->", module, result)
                return nil
            end

            local function getUseItemRemote()
                if state.UseItemRemote and state.UseItemRemote.Parent then
                    return state.UseItemRemote
                end

                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local replication = remotes and remotes:FindFirstChild("Replication")
                local fighter = replication and replication:FindFirstChild("Fighter")
                local useItem = fighter and fighter:FindFirstChild("UseItem")

                state.UseItemRemote = useItem
                return useItem
            end

            local function getStartShootingEnum()
                if state.StartShootingEnum then
                    return state.StartShootingEnum
                end

                local modules = ReplicatedStorage:FindFirstChild("Modules")
                local enumModule = modules and modules:FindFirstChild("EnumLibrary")
                local enums = enumModule and safeRequire(enumModule)
                if not enums then
                    return nil
                end

                local ok, result = pcall(function()
                    return enums:ToEnum("StartShooting")
                end)

                if ok then
                    state.StartShootingEnum = result
                    return result
                end

                return nil
            end

            local function markEnemyDeflect(self)
                local fighter = rawget(self, "ClientFighter") or self.ClientFighter
                if not fighter then return end

                local isLocal = false
                pcall(function()
                    isLocal = fighter.IsLocalPlayer
                end)
                if isLocal then return end

                local player = nil
                pcall(function()
                    player = fighter.Player
                end)

                local userId = nil
                if player and player.UserId then
                    userId = player.UserId
                else
                    pcall(function()
                        userId = fighter:Get("ObjectID")
                    end)
                end

                if not userId then return end

                local duration = 1
                pcall(function()
                    if self.Info and self.Info.DeflectDuration then
                        duration = self.Info.DeflectDuration
                    end
                end)

                local endTime = tick() + duration + 0.12
                state.DeflectingEnemies[userId] = endTime

                task.delay(duration + 0.2, function()
                    if state.DeflectingEnemies[userId] == endTime then
                        state.DeflectingEnemies[userId] = nil
                    end
                end)
            end

            local function getPlayerFromTarget(target)
                if typeof(target) == "Instance" then
                    if target:IsA("Player") then
                        return target
                    end
                    return Players:GetPlayerFromCharacter(target)
                end
                return nil
            end

            local function getDeflectKeyFromItem(self)
                local fighter = rawget(self, "ClientFighter") or self.ClientFighter
                if not fighter then return nil end

                local player = nil
                pcall(function()
                    player = fighter.Player
                end)
                if player and player.UserId then
                    return player.UserId
                end

                local objectId = nil
                pcall(function()
                    objectId = fighter:Get("ObjectID")
                end)
                return objectId
            end

            local function isDeflectAction(self, action)
                local actionStr = tostring(action)
                pcall(function()
                    if type(self.FromEnum) == "function" then
                        actionStr = tostring(self:FromEnum(action))
                    end
                end)
                actionStr = actionStr:lower()
                return actionStr == "startaiming"
                    or actionStr == "startblocking"
                    or actionStr == "deflect"
                    or actionStr == "startdeflect"
                    or actionStr:find("deflect", 1, true) ~= nil
            end

            _G.ShouldBlockShotForKatana = function(target)
                if not state.Enabled then
                    return false
                end

                local now = tick()
                local targetPlayer = getPlayerFromTarget(target)
                local targetUserId = targetPlayer and targetPlayer.UserId

                for key, expireTime in pairs(state.DeflectingEnemies) do
                    if now >= expireTime then
                        state.DeflectingEnemies[key] = nil
                    elseif not targetUserId or key == targetUserId then
                        return true
                    end
                end

                return false
            end

            local function getKatanaClass()
        	if state.KatanaClass then
        		return state.KatanaClass
        	end
        
        	if not state.KatanaModule then
        		local ps = LocalPlayer:FindFirstChild("PlayerScripts")
        		local modules = ps and ps:FindFirstChild("Modules")
        		local items = modules and modules:FindFirstChild("Items")
        		local katanaModuleScript = items and items:FindFirstChild("Katana")
            
        		if katanaModuleScript then
        			state.KatanaModule = safeRequire(katanaModuleScript)
        		end
        	end
        
        	local mod = state.KatanaModule
        	if type(mod) ~= "table" then
        		return nil
        	end
        
        	if type(rawget(mod, "ReplicateFromServer")) == "function" then
        		state.KatanaClass = mod
        		return mod
        	end
        
        	local mt = getmetatable(mod)
        	if type(mt) == "table" and type(rawget(mt, "ReplicateFromServer")) == "function" then
        		state.KatanaClass = mt
        		return mt
        	end
        
        	return nil
        end

            local function setupKatanaHook()
                if state.HookedKatana then
                    return true
                end

                local katanaClass = getKatanaClass()
                if not katanaClass then
                    return false
                end

                if type(katanaClass.ReplicateFromServer) ~= "function" then
                    return false
                end

                state.OriginalReplicateFromServer = katanaClass.ReplicateFromServer

                katanaClass.ReplicateFromServer = function(self, action, ...)
                    if state.Enabled and self and self.Name == "Katana" then
                        if isDeflectAction(self, action) then
                            markEnemyDeflect(self)
                        end
                    end

                    return state.OriginalReplicateFromServer(self, action, ...)
                end

                state.HookedKatana = true
                return true
            end

            local function setupFireServerHook()
                if state.HookedFireServer then
                    return true
                end

                local useItem = getUseItemRemote()
                if not useItem or not hookfunction then
                    return false
                end

                local oldFireServer
                local hooked = pcall(function()
                    oldFireServer = hookfunction(useItem.FireServer, newcclosure(function(self, ...)
                    local args = { ... }

                    if state.Enabled then
                        if self == useItem then
                            local shootingEnum = getStartShootingEnum()
                            local actionEnum = args[2]

                            local isStartShooting = false
                            if shootingEnum then
                                isStartShooting = (actionEnum == shootingEnum)
                            else
                                isStartShooting = (tostring(actionEnum) == "StartShooting")
                            end

                            if isStartShooting then
                                local now = tick()
                                local blocked = false

                                for userId, expireTime in pairs(state.DeflectingEnemies) do
                                    if now < expireTime then
                                        blocked = true
                                        break
                                    else
                                        state.DeflectingEnemies[userId] = nil
                                    end
                                end

                                if blocked then
                                    if AntiKatanaSoundEffect
                                    and AntiKatanaSoundEffect.Enabled
                                    and not state.IsDeflectSoundPlaying then
                                        local sound = Instance.new("Sound")
                                        sound.SoundId = "rbxassetid://1848354536"
                                        sound.Volume = 0.6
                                        sound.Looped = true
                                        sound.Parent = workspace
                                        sound:Play()
                                        state.CurrentDeflectSound = sound
                                        state.IsDeflectSoundPlaying = true
                                    end

                                    return nil
                                else
                                    stopDeflectSound()
                                end
                            end
                        end
                    end

                    return oldFireServer(self, ...)
                    end))
                end)
                if not hooked then
                    return false
                end
                state.HookedFireServer = true
                return true
            end

            mainapi:Clean(RunService.Stepped:Connect(function()
                if not state.Enabled then
                    return
                end

                if not state.HookedKatana then
                    pcall(setupKatanaHook)
                end

                if not state.HookedFireServer then
                    pcall(setupFireServerHook)
                end
            end))
        end
    })

    AntiKatanaSoundEffect = AntiKatana:AddToggle({
        Name = "Deflect Sound",
        Default = true,
        Tooltip = "Plays sound when shots are blocked"
    })
end)

run(function()
    local AutoLoad, Loadout
    local AutoSelect, SilentMode
    local Mode, Mode2, Mode3, Mode4
    local loadoutLoopRunning = false

    local StarterPlayer = cloneref(game:GetService('StarterPlayer'))

    local weaponsFolder = StarterPlayer.StarterPlayerScripts.Assets.ViewModels.Weapons
    local unobtainableFolder = weaponsFolder.Unobtainable

    local weaponList = {}

    for _,v in pairs(weaponsFolder:GetChildren()) do
        if v:IsA("Model") then
            table.insert(weaponList, v.Name)
        end
    end

    for _,v in pairs(unobtainableFolder:GetChildren()) do
        if v:IsA("Model") then
            table.insert(weaponList, v.Name)
        end
    end

    local function pickLoadout()
        local args = {{
            Mode.Value,
            Mode2.Value,
            Mode3.Value,
            Mode4.Value
        }}

        ReplicatedStorage.Remotes.Replication.Fighter.PickWeapons:FireServer(unpack(args))
    end

    local function runLoadoutLoop(active)
        if active then
            if loadoutLoopRunning then return end
            loadoutLoopRunning = true
            task.spawn(function()
                while (AutoLoad and AutoLoad.Enabled) or (AutoSelect and AutoSelect.Enabled) do
                    pcall(pickLoadout)
                    task.wait(0.5)
                end
                loadoutLoopRunning = false
            end)
        end
    end

    AutoLoad = Other:AddModule({
        Name = "auto load",
        Function = function(callback)
            runLoadoutLoop(callback)
        end
    })

    SilentMode = AutoLoad:AddToggle({
        Name = "silent mode",
        Default = false
    })

    Loadout = Other:AddModule({
        Name = "loadout",
        HideEnabled = true
    })

    AutoSelect = Loadout:AddToggle({
        Name = "auto select",
        Function = function(callback)
            runLoadoutLoop(callback)
        end
    })

    Mode = Loadout:AddDropdown2({
        Name = "primary",
        List = weaponList,
        Default = "Assault Rifle",
        Function = function()
            if not (AutoLoad and AutoLoad.Enabled) and not (AutoSelect and AutoSelect.Enabled) then
                pcall(pickLoadout)
            end
        end
    })

    Mode2 = Loadout:AddDropdown2({
        Name = "secondary",
        List = weaponList,
        Default = "Handgun",
        Function = function()
            if not (AutoLoad and AutoLoad.Enabled) and not (AutoSelect and AutoSelect.Enabled) then
                pcall(pickLoadout)
            end
        end
    })

    Mode3 = Loadout:AddDropdown2({
        Name = "melee",
        List = weaponList,
        Default = "Fists",
        Function = function()
            if not (AutoLoad and AutoLoad.Enabled) and not (AutoSelect and AutoSelect.Enabled) then
                pcall(pickLoadout)
            end
        end
    })

    Mode4 = Loadout:AddDropdown2({
        Name = "utility",
        List = weaponList,
        Default = "Grenade",
        Function = function()
            if not (AutoLoad and AutoLoad.Enabled) and not (AutoSelect and AutoSelect.Enabled) then
                pcall(pickLoadout)
            end
        end
    })
end)

run(function()
    local ChatSpam, InOrder, ChatMode, RandomCustomText, CustomText
    local spamLoopRunning = false
    local modeIndex = {}
    local TextChatService = cloneref(game:GetService("TextChatService"))

    local modeMessages = {
        custom = {},
        smol = {
            "tiny wins still count",
            "small text big result",
            "smol but locked in"
        },
        corny = {
            "that round was nacho average duel",
            "you just got served with extra cheese",
            "corny line, clean win"
        },
        wholesome = {
            "good fight",
            "nice shot",
            "well played"
        },
        ["auto ban"] = {
            "ban phase handled",
            "voting the loadout",
            "random ban locked"
        }
    }

    local customPresets = {
        "...",
        "message...",
        "good fight",
        "nice shot",
        "well played"
    }

    local function sendChat(text)
        text = tostring(text or "")
        if text == "" then return end

        local ok = pcall(function()
            local channels = TextChatService:FindFirstChild("TextChannels")
            local channel = channels and (channels:FindFirstChild("RBXGeneral") or channels:FindFirstChild("RBXSystem"))
            if channel and channel.SendAsync then
                channel:SendAsync(text)
            else
                error("TextChannel unavailable")
            end
        end)
        if ok then return end

        pcall(function()
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All")
        end)
    end

    local function getNextMessage()
        local mode = ChatMode and ChatMode.Value or "custom"
        if mode == "custom" then
            local text = CustomText and CustomText.Value or ""
            if text == "" or text == "message..." then
                text = RandomCustomText and RandomCustomText.Value or "..."
            end
            return text
        end

        local messages = modeMessages[mode] or modeMessages.custom
        if #messages == 0 then
            return CustomText and CustomText.Value or "..."
        end

        if InOrder and InOrder.Enabled then
            local nextIndex = (modeIndex[mode] or 0) + 1
            if nextIndex > #messages then nextIndex = 1 end
            modeIndex[mode] = nextIndex
            return messages[nextIndex]
        end

        return messages[math.random(1, #messages)]
    end

    ChatSpam = Other:AddModule({
        Name = "chat spam",
        Function = function(callback)
            if callback and not spamLoopRunning then
                spamLoopRunning = true
                task.spawn(function()
                    while ChatSpam.Enabled do
                        pcall(sendChat, getNextMessage())
                        task.wait(1.5)
                    end
                    spamLoopRunning = false
                end)
            end
        end
    })

    InOrder = ChatSpam:AddToggle({
        Name = "in order"
    })

    ChatMode = ChatSpam:AddDropdown({
        Name = "chat mode",
        List = {"custom", "smol", "corny", "wholesome", "auto ban"},
        Default = "custom"
    })

    RandomCustomText = ChatSpam:AddDropdown({
        Name = "random custom text",
        List = customPresets,
        Default = "..."
    })

    CustomText = ChatSpam:AddInputBox({
        Name = "add custom text",
        Default = "message...",
        Placeholder = "message..."
    })

    ChatSpam:AddButton({
        Name = "refresh modes",
        Function = function()
            table.clear(modeIndex)
        end
    })
end)

run(function()
    local AnimationPlayer
    local Anim
    local CustomAnimation
    local AnimationSpeed
    local AnimationStart
    local AnimationEnd
    local CurrentTrack
    local CurrentAnimation
    local CurrentHumanoid
    local CurrentAnimator
    local ReplayToken = 0
    local LastReplay = 0
    local animations = {
        ["Bodybuilder"] = "3994130516",
        ["Crawling in a Circle"] = "116935126100338",
        ["Dolphin Dance"] = "5938365243",
        ["Dance"] = "507771019",
        ["Dance Break"] = "94258912028011",
        ["French Confidence"] = "116968182519797",
        ["Floss"] = "72174079036035",
        ["Frosty Flair"] = "10214406616",
        ["Full Wiggle"] = "86520127496722",
        ["Ghost Floating"] = "75911227509248",
        ["Gun"] = "81100102810594",
        ["Gangnam Style"] = "78801539668900",
        ["Hip Bounce"] = "123602332785269",
        ["Hype Dance"] = "93079641847306",
        ["Kicking Feet"] = "109814083870185",
        ["Line Dance"] = "4049646104",
        ["Lay Floating"] = "126579240140537",
        ["Let's Drive"] = "17360720445",
        ["Long Legs"] = "82416741608012",
        ["Rock Out"] = "18225077553",
        ["Samba"] = "6869813008",
        ["Still Standing"] = "11435177473",
        ["Spiral"] = "81926730031709",
        ["Solar System"] = "118314972618293",
        ["Twirl"] = "3716633898",
        ["Take Me Under"] = "6797938823",
        ["The Worm"] = "99563207397301",
        ["Take the L"] = "110664723286332",
        ["Zesty"] = "102901317133934",
    }

    local animationList = {
        "Bodybuilder", "Custom", "Crawling in a Circle", "Dolphin Dance", "Dance",
        "Dance Break", "French Confidence", "Floss", "Frosty Flair", "Full Wiggle",
        "Ghost Floating", "Gun", "Gangnam Style", "Hip Bounce", "Hype Dance",
        "Kicking Feet", "Line Dance", "Lay Floating", "Let's Drive", "Long Legs",
        "Rock Out", "Samba", "Still Standing", "Spiral", "Solar System", "Twirl",
        "Take Me Under", "The Worm", "Take the L", "Zesty",
    }

    local function stopAnimation()
        ReplayToken += 1
        if CurrentTrack then
            pcall(CurrentTrack.Stop, CurrentTrack, 0.1)
            pcall(CurrentTrack.Destroy, CurrentTrack)
            CurrentTrack = nil
        end
        if CurrentAnimation then
            CurrentAnimation:Destroy()
            CurrentAnimation = nil
        end
        CurrentHumanoid = nil
        CurrentAnimator = nil
    end

    local function selectedId()
        if not Anim then return nil end
        if Anim.Value == "Custom" then
            return CustomAnimation and tostring(CustomAnimation.Value):match("%d+")
        end
        return animations[Anim.Value]
    end

    local function loadCatalogEmote(humanoid, animator, id)
        local description = humanoid:FindFirstChildOfClass("HumanoidDescription")
        if not description then return nil end

        local emoteName = "LionAnimationPlayer"
        local captured
        local connection = animator.AnimationPlayed:Connect(function(track)
            captured = track
        end)

        local ok = pcall(function()
            pcall(description.RemoveEmote, description, emoteName)
            description:AddEmote(emoteName, tonumber(id))
            humanoid:PlayEmote(emoteName)
        end)

        local timeout = os.clock() + 2
        while ok and not captured and os.clock() < timeout do
            RunService.Heartbeat:Wait()
        end
        connection:Disconnect()
        return captured
    end

    local function playSelected()
        if not (AnimationPlayer and AnimationPlayer.Enabled) then return end
        local id = selectedId()
        if not id or id == "" then
            stopAnimation()
            return
        end

        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then return end

        stopAnimation()
        ReplayToken += 1
        local token = ReplayToken
        local track
        local animation

        if Anim.Value ~= "Custom" then
            track = loadCatalogEmote(humanoid, animator, id)
        else
            animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://" .. id
            local ok
            ok, track = pcall(animator.LoadAnimation, animator, animation)
            if not ok then track = nil end
        end

        if not track then
            if animation then animation:Destroy() end
            return
        end
        CurrentAnimation = animation
        CurrentTrack = track
        CurrentHumanoid = humanoid
        CurrentAnimator = animator
        LastReplay = os.clock()
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = true
        track:Play(0.1, 1, AnimationSpeed and AnimationSpeed.Value or 1)

        task.spawn(function()
            while token == ReplayToken and CurrentTrack == track and AnimationPlayer.Enabled do
                local length = track.Length
                local startPercent = AnimationStart and AnimationStart.Value or 0
                local endPercent = AnimationEnd and AnimationEnd.Value or 100
                if endPercent <= startPercent then endPercent = math.min(100, startPercent + 1) end
                if length > 0 then
                    local startTime = length * startPercent / 100
                    local endTime = length * endPercent / 100
                    if track.TimePosition < startTime or track.TimePosition >= endTime then
                        track.TimePosition = startTime
                    end
                end
                if not track.IsPlaying then
                    track:Play(0.05, 1, AnimationSpeed and AnimationSpeed.Value or 1)
                end
                track:AdjustSpeed(AnimationSpeed and AnimationSpeed.Value or 1)
                track:AdjustWeight(1, 0)
                RunService.Heartbeat:Wait()
            end
        end)
    end

    AnimationPlayer = Player:AddModule({
        Name = "Animation Player",
        Function = function(callback)
            if callback then
                playSelected()
            else
                stopAnimation()
            end
        end
    })

    Anim = AnimationPlayer:AddDropdown2({
        Name = "animation",
        List = animationList,
        Default = "Floss",
        Function = playSelected
    })

    CustomAnimation = AnimationPlayer:AddInputBox({
        Name = "custom animation",
        Default = "",
        Placeholder = "id... (ex: 4049646104)",
        Function = function()
            if Anim.Value == "Custom" then playSelected() end
        end
    })

    AnimationSpeed = AnimationPlayer:AddSlider({
        Name = "speed",
        Min = 0.1,
        Max = 5,
        Default = 1,
        Decimal = 10,
        Function = function(value)
            if CurrentTrack then CurrentTrack:AdjustSpeed(value) end
        end
    })

    AnimationStart = AnimationPlayer:AddSlider({
        Name = "start",
        Min = 0,
        Max = 99,
        Default = 0,
        Suffix = "%",
        Compact = true
    })

    AnimationEnd = AnimationPlayer:AddSlider({
        Name = "end",
        Min = 1,
        Max = 100,
        Default = 100,
        Suffix = "%",
        Compact = true,
        Parent = AnimationStart
    })

    mainapi:Clean(LocalPlayer.CharacterAdded:Connect(function(character)
        task.spawn(function()
            local humanoid = character:WaitForChild("Humanoid", 10)
            if not humanoid then return end
            humanoid:WaitForChild("Animator", 10)
            if LocalPlayer.Character ~= character then return end
            task.wait(0.5)
            if AnimationPlayer.Enabled then
                playSelected()
            end
        end)
    end))

    mainapi:Clean(LocalPlayer.CharacterRemoving:Connect(function(character)
        if LocalPlayer.Character == character then
            stopAnimation()
        end
    end))

    mainapi:Clean(RunService.Heartbeat:Connect(function()
        if not AnimationPlayer.Enabled or os.clock() - LastReplay < 1 then return end

        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        local trackValid = false
        if CurrentTrack then
            trackValid = pcall(function()
                return CurrentTrack.IsPlaying
            end)
        end

        if humanoid and animator and (
            humanoid ~= CurrentHumanoid
            or animator ~= CurrentAnimator
            or not CurrentTrack
            or not trackValid
        ) then
            LastReplay = os.clock()
            task.spawn(playSelected)
        end
    end))
end)

run(function()
    local autoban
    local BanRandomMap, BanWeapons, MapBanDelay
    local FirstBanDelay, SecondBanDelay, FirstBan, SecondBan
    local autoBanLoopRunning = false
    local randomMapLoopRunning = false

    local StarterPlayer = cloneref(game:GetService("StarterPlayer"))
    local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
    local DuelLibrary
    pcall(function()
        DuelLibrary = require(ReplicatedStorage.Modules.DuelLibrary)
    end)

    local weaponsFolder = StarterPlayer.StarterPlayerScripts.Assets.ViewModels.Weapons
    local unobtainableFolder = weaponsFolder.Unobtainable

    -- Duel Vote Remote
    local VoteRemote = ReplicatedStorage:WaitForChild("Remotes")
        :WaitForChild("Duels")
        :WaitForChild("Vote")

    local weaponList = {"None"}

    for _,v in pairs(weaponsFolder:GetChildren()) do
        if v:IsA("Model") then
            table.insert(weaponList, v.Name)
        end
    end

    for _,v in pairs(unobtainableFolder:GetChildren()) do
        if v:IsA("Model") then
            table.insert(weaponList, v.Name)
        end
    end

    table.sort(weaponList, function(a, b)
        if a == "None" then return true end
        if b == "None" then return false end
        return a < b
    end)

    local function buildMapList()
        local maps = {}
        if DuelLibrary then
            for _, name in pairs(DuelLibrary.MapOrder or {}) do
                if DuelLibrary.Maps and DuelLibrary.Maps[name] and not DuelLibrary.Maps[name].IsHidden then
                    table.insert(maps, name)
                end
            end
            if #maps == 0 then
                for name, data in pairs(DuelLibrary.Maps or {}) do
                    if not data.IsHidden then
                        table.insert(maps, name)
                    end
                end
            end
        end
        table.sort(maps)
        return maps
    end

    local function runWeaponBanLoop()
        if autoBanLoopRunning then return end
        autoBanLoopRunning = true
        task.spawn(function()
            local index = 1
            while autoban.Enabled and BanWeapons and BanWeapons.Enabled do
                local votes = {}
                if FirstBan and FirstBan.Value ~= "None" then
                    table.insert(votes, {Name = FirstBan.Value, Delay = tonumber(FirstBanDelay and FirstBanDelay.Value) or 0})
                end
                if SecondBan and SecondBan.Value ~= "None" then
                    table.insert(votes, {Name = SecondBan.Value, Delay = tonumber(SecondBanDelay and SecondBanDelay.Value) or 0})
                end

                if #votes > 0 then
                    local vote = votes[index]
                    task.wait(math.max(vote.Delay, 0))
                    VoteRemote:FireServer(vote.Name)
                    index = index % #votes + 1
                end

                task.wait(1)
            end
            autoBanLoopRunning = false
        end)
    end

    local function runRandomMapBanLoop()
        if randomMapLoopRunning then return end
        randomMapLoopRunning = true
        task.spawn(function()
            local rng = Random.new()
            while autoban.Enabled and BanRandomMap and BanRandomMap.Enabled do
                local maps = buildMapList()
                if #maps > 0 then
                    task.wait(math.max(tonumber(MapBanDelay and MapBanDelay.Value) or 0, 0))
                    VoteRemote:FireServer(maps[rng:NextInteger(1, #maps)])
                    task.wait(1)
                else
                    task.wait(1)
                end
            end
            randomMapLoopRunning = false
        end)
    end

    local function startAutoBanLoops()
        if not autoban.Enabled then return end
        if BanWeapons and BanWeapons.Enabled then
            runWeaponBanLoop()
        end
        if BanRandomMap and BanRandomMap.Enabled then
            runRandomMapBanLoop()
        end
    end

    autoban = Other:AddModule({
        Name = "auto ban",
        Function = function(callback)
            if callback then
                startAutoBanLoops()
            end
        end
    })

    BanRandomMap = autoban:AddToggle({
        Name = "ban random map",
        Function = startAutoBanLoops
    })

    MapBanDelay = autoban:AddSlider({
        Name = "map ban delay",
        Min = 0,
        Max = 10,
        Default = 0,
        Decimal = 10,
        Suffix = "s"
    })

    BanWeapons = autoban:AddToggle({
        Name = "ban weapons",
        Default = true,
        Function = startAutoBanLoops
    })

    FirstBanDelay = autoban:AddSlider({
        Name = "first ban",
        Min = 0,
        Max = 10,
        Default = 0,
        Decimal = 10,
        Suffix = "s"
    })

    SecondBanDelay = autoban:AddSlider({
        Name = "second ban",
        Min = 0,
        Max = 10,
        Default = 0,
        Decimal = 10,
        Suffix = "s"
    })

    FirstBan = autoban:AddDropdown2({
        Name = "first ban",
        List = weaponList,
        Default = table.find(weaponList, "Riot Shield") and "Riot Shield" or weaponList[2] or "None",
        Function = startAutoBanLoops
    })

    SecondBan = autoban:AddDropdown2({
        Name = "second ban",
        List = weaponList,
        Default = table.find(weaponList, "Katana") and "Katana" or weaponList[3] or weaponList[2] or "None",
        Function = startAutoBanLoops
    })
end)

run(function()
	local mobile
	
	mobile = Combat:AddModule({
		Name = 'Mobile Settings',
		Function = function(callback)
			if callback then
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DebugController = require(Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DebugController"))
DebugController:SetHandicapsEnabled(true)
            else
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DebugController = require(Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DebugController"))
DebugController:SetHandicapsEnabled(false)
			end
		end
	})

end)


run(function()
	local Xray
	local List
	local modified = {}
	
	local function modifyPart(v)
		if v:IsA('BasePart') then
			modified[v] = true
			v.LocalTransparencyModifier = 0.5
		end
	end
	
	Xray = Render:AddModule({
		Name = 'XRay',
		Function = function(callback)
			if callback then
				Xray:Clean(workspace.DescendantAdded:Connect(modifyPart))
				for _, v in workspace:GetDescendants() do
					modifyPart(v)
				end
			else
				for i in modified do
					i.LocalTransparencyModifier = 0
				end
				table.clear(modified)
			end
		end
	})
	Transparency = Xray:AddSlider({
		Name = 'Transparency',
		Min = 0,
		Max = 1,
		Function = function(val)
			for i in modified do
				i.LocalTransparencyModifier = 1 - val
			end
		end,
		Decimal = 10
	})
end)

run(function()
    local AirJump
    local Velocity
    AirJump = Player:AddModule({
        Name = "AirJump",
        Function = function(callback)
            if callback then
				AirJump:Clean(UserInputService.InputBegan:Connect(function(input, gameProcessed)
					if gameProcessed then return end
					if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
						while UserInputService:IsKeyDown(Enum.KeyCode.Space) do
							if entitylib.isAlive and LocalPlayer.Character.PrimaryPart then
								local PrimaryPart = LocalPlayer.Character.PrimaryPart
								PrimaryPart.Velocity = vector.create(PrimaryPart.Velocity.X, Velocity.Value, PrimaryPart.Velocity.Z)
							end
							task.wait()
						end
					end
				end))
				if UserInputService.TouchEnabled then
					local Jumping = false
					local JumpButton = LocalPlayer.PlayerGui:WaitForChild("TouchGui"):WaitForChild("TouchControlFrame"):WaitForChild("JumpButton")
					
					AirJump:Clean(JumpButton.MouseButton1Down:Connect(function()
						Jumping = true
					end))

					AirJump:Clean(JumpButton.MouseButton1Up:Connect(function()
						Jumping = false
					end))

					AirJump:Clean(RunService.RenderStepped:Connect(function()
						if Jumping and entitylib.isAlive and LocalPlayer.Character then
							local PrimaryPart = LocalPlayer.Character.PrimaryPart
							PrimaryPart.Velocity = vector.create(PrimaryPart.Velocity.X, Velocity.Value, PrimaryPart.Velocity.Z)
						end
					end))
				end
			end
        end
    })
    Velocity = AirJump:AddSlider({
        Name = 'Velocity',
        Min = 50,
        Max = 300,
        Default = 50
    })
end)

run(function()
    local CharacterMovement
    local VelocityEnabled, VelocitySpeed
    local SlideBoostEnabled, SlideBoostValue
    local DoubleJumpHeightEnabled, DoubleJumpHeightValue
    local MaulSlamEnabled, MaulSlamValue
    local InfiniteDoubleJump
    local state = {
        Mechanics = nil,
        OldSlide = nil,
        OldDoubleJump = nil,
        OldHighJump = nil,
        Hooked = false,
        HookedMechanics = nil,
        SlideOriginals = {},
        ItemOriginals = {},
        LastSlidingAt = 0,
    }

    local function getMechanics()
        if state.Mechanics then return state.Mechanics end
        local ok, mech = pcall(function()
            return require(LocalPlayer.PlayerScripts.Controllers.MechanicsController)
        end)
        if ok and mech then
            state.Mechanics = mech
            return mech
        end
    end

    local function getRootHumanoid()
        local char = LocalPlayer.Character
        if not char then return end
        return char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid")
    end

    local function getLocalFighter()
        local mech = getMechanics()
        return mech and mech.LocalFighter
    end

    local function isAirborne(hum, root)
        if not hum then return false end
        local stateType = hum:GetState()
        if stateType == Enum.HumanoidStateType.Jumping
            or stateType == Enum.HumanoidStateType.Freefall
            or stateType == Enum.HumanoidStateType.FallingDown
            or stateType == Enum.HumanoidStateType.Physics
            or stateType == Enum.HumanoidStateType.PlatformStanding then
            return true
        end
        if hum.FloorMaterial == Enum.Material.Air then
            return true
        end
        return root and math.abs(root.AssemblyLinearVelocity.Y) > 3 or false
    end

    local function isSliding(hum)
        local mech = getMechanics()
        if mech and mech.IsSliding then
            state.LastSlidingAt = os.clock()
            return true
        end

        local fighter = mech and mech.LocalFighter or getLocalFighter()
        if fighter and fighter.IsSlidingLocally then
            state.LastSlidingAt = os.clock()
            return true
        end

        if fighter and type(fighter.Get) == "function" then
            for _, key in ipairs({"IsSliding", "SlidingActive"}) do
                local ok, value = pcall(function()
                    return fighter:Get(key)
                end)
                if ok and value then
                    state.LastSlidingAt = os.clock()
                    return true
                end
            end
        end

        return false
    end

    local function applyMovementVelocity()
        if not CharacterMovement or not CharacterMovement.Enabled then return false end
        if not VelocityEnabled or not VelocityEnabled.Enabled then return false end

        local root, hum = getRootHumanoid()
        if not root or not hum or hum.Health <= 0 then return false end
        local sliding = isSliding(hum)
        local airborne = isAirborne(hum, root)
        local slideGrace = os.clock() - (state.LastSlidingAt or 0) < 0.35
        if sliding then return false end

        local move = hum.MoveDirection
        if move.Magnitude > 0.1 then
            local dir = Vector3.new(move.X, 0, move.Z).Unit
            local speed = (VelocitySpeed and VelocitySpeed.Value) or 50
            root.AssemblyLinearVelocity = Vector3.new(dir.X * speed, root.AssemblyLinearVelocity.Y, dir.Z * speed)
        else
            if airborne or slideGrace then
                return false
            end
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
        end

        return true
    end

    getgenv().__LionApplyMovementVelocity = applyMovementVelocity

    local function restoreSlideBoost()
        for fighter, value in pairs(state.SlideOriginals) do
            pcall(function()
                if fighter and type(fighter.Set) == "function" then
                    fighter:Set("SlidingSpeedMax", value)
                end
            end)
            state.SlideOriginals[fighter] = nil
        end
    end

    local function applySlideBoost(fighter)
        if not fighter or not SlideBoostEnabled or not SlideBoostEnabled.Enabled then return end
        local ok, current = pcall(function()
            return fighter:Get("SlidingSpeedMax")
        end)
        local base = (state.SlideOriginals[fighter] ~= nil and state.SlideOriginals[fighter]) or (ok and current) or 3
        state.SlideOriginals[fighter] = base
        pcall(function()
            fighter:Set("SlidingSpeedMax", base * SlideBoostValue.Value)
        end)
    end

    local function restoreItemInfo()
        for info, values in pairs(state.ItemOriginals) do
            if info then
                for key, value in pairs(values) do
                    pcall(function()
                        info[key] = value
                    end)
                end
            end
            state.ItemOriginals[info] = nil
        end
    end

    local function saveInfoValue(info, key)
        state.ItemOriginals[info] = state.ItemOriginals[info] or {}
        if state.ItemOriginals[info][key] == nil then
            state.ItemOriginals[info][key] = info[key]
        end
    end

    local function patchEquippedItem()
        local mech = getMechanics()
        local fighter = mech and mech.LocalFighter
        local item = fighter and fighter.EquippedItem
        local info = item and item.Info
        if not info then return end

        if InfiniteDoubleJump and InfiniteDoubleJump.Enabled then
            saveInfoValue(info, "MaxDoubleJumps")
            info.MaxDoubleJumps = math.huge
            local objectId
            pcall(function()
                objectId = item:Get("ObjectID")
            end)
            if objectId and mech._double_jumps_used then
                mech._double_jumps_used[objectId] = 0
            end
        end

        if MaulSlamEnabled and MaulSlamEnabled.Enabled then
            for _, key in ipairs({"SlamDamage", "SlamRadius"}) do
                if type(info[key]) == "number" then
                    saveInfoValue(info, key)
                    info[key] = state.ItemOriginals[info][key] * MaulSlamValue.Value
                end
            end
        end
    end

    local function installHooks()
        local mech = getMechanics()
        if not mech then return end
        if state.Hooked and state.HookedMechanics == mech then return end
        state.Hooked = true
        state.HookedMechanics = mech

        if type(mech.Slide) == "function" then
            state.OldSlide = mech.Slide
            mech.Slide = function(self, ...)
                applySlideBoost(self and self.LocalFighter)
                return state.OldSlide(self, ...)
            end
        end

        if type(mech.HighJump) == "function" then
            state.OldHighJump = mech.HighJump
            mech.HighJump = function(self, ...)
                state.LastSlidingAt = os.clock()
                return state.OldHighJump(self, ...)
            end
        end

        if type(mech.DoubleJump) == "function" then
            state.OldDoubleJump = mech.DoubleJump
            mech.DoubleJump = function(self, ...)
                local result = state.OldDoubleJump(self, ...)
                if CharacterMovement.Enabled and DoubleJumpHeightEnabled.Enabled then
                    local fighter = self and self.LocalFighter
                    local root = fighter and fighter.Entity and fighter.Entity.RootPart
                    if root then
                        local vel = root.Velocity
                        root.Velocity = Vector3.new(vel.X, vel.Y * DoubleJumpHeightValue.Value, vel.Z)
                    end
                end
                return result
            end
        end
    end

    CharacterMovement = Player:AddModule({
        Name = "Movement",
        Function = function(callback)
            if callback then
                installHooks()
                CharacterMovement:Clean(RunService.Heartbeat:Connect(function()
                    applyMovementVelocity()

                    local mech = getMechanics()
                    if mech and SlideBoostEnabled.Enabled then
                        applySlideBoost(mech.LocalFighter)
                    end

                    patchEquippedItem()
                end))
                CharacterMovement:Clean(LocalPlayer.CharacterAdded:Connect(function()
                    state.Mechanics = nil
                    task.delay(0.35, function()
                        if not CharacterMovement.Enabled then return end
                        installHooks()
                        local mech = getMechanics()
                        if mech and SlideBoostEnabled.Enabled then
                            applySlideBoost(mech.LocalFighter)
                        end
                        patchEquippedItem()
                        applyMovementVelocity()
                    end)
                end))
            else
                restoreSlideBoost()
                restoreItemInfo()
                local root = getRootHumanoid()
                if root then
                    root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
                end
            end
        end
    })

    VelocityEnabled = CharacterMovement:AddToggle({Name = "velocity"})
    VelocitySpeed = CharacterMovement:AddSlider({Name = "velocity speed", Min = 0, Max = 250, Default = 50, Suffix = "s"})
    SlideBoostEnabled = CharacterMovement:AddToggle({Name = "slide boost", Function = function(v) if not v then restoreSlideBoost() end end})
    SlideBoostValue = CharacterMovement:AddSlider({Name = "slide boost", Min = 1, Max = 5, Default = 1, Decimal = 10, Suffix = "x", Function = function() restoreSlideBoost() end})
    DoubleJumpHeightEnabled = CharacterMovement:AddToggle({Name = "double jump height"})
    DoubleJumpHeightValue = CharacterMovement:AddSlider({Name = "double jump height", Min = 1, Max = 10, Default = 1, Decimal = 10, Suffix = "x"})
    MaulSlamEnabled = CharacterMovement:AddToggle({Name = "maul slam multiplier", Function = function(v) if not v then restoreItemInfo() end end})
    MaulSlamValue = CharacterMovement:AddSlider({Name = "maul slam multiplier", Min = 1, Max = 10, Default = 1, Decimal = 10, Suffix = "x", Function = function() restoreItemInfo() end})
    InfiniteDoubleJump = CharacterMovement:AddToggle({Name = "infinite double jump", Function = function(v) if not v then restoreItemInfo() end end})
end)

local Spider = {Enabled = false}
local Phase = {Enabled = false}

run(function()
	local Mode
	local StudLimit = {Object = {}}
	local rayCheck = RaycastParams.new()
	rayCheck.RespectCanCollide = true
	local overlapCheck = OverlapParams.new()
	overlapCheck.MaxParts = 9e9
	local modified, fflag = {}
	local teleported
	
	local function grabClosestNormal(ray)
		local partCF, mag, closest = ray.Instance.CFrame, 0, Enum.NormalId.Top
		for _, normal in Enum.NormalId:GetEnumItems() do
			local dot = partCF:VectorToWorldSpace(Vector3.fromNormalId(normal)):Dot(ray.Normal)
			if dot > mag then
				mag, closest = dot, normal
			end
		end
		return Vector3.fromNormalId(closest).X ~= 0 and 'X' or 'Z'
	end
	
	local Functions = {
		Part = function()
			local chars = {gameCamera, LocalPlayer.Character}
			for _, v in LocalPlayer.List do
				table.insert(chars, v.Character)
			end
			overlapCheck.FilterDescendantsInstances = chars
	
			local parts = workspace:GetPartBoundsInBox(LocalPlayer.character.HumanoidRootPart.CFrame + Vector3.new(0, 1, 0), LocalPlayer.character.HumanoidRootPart.Size + Vector3.new(1, LocalPlayer.character.HipHeight, 1), overlapCheck)
			for _, part in parts do
				if part.CanCollide and (not Spider.Enabled or SpiderShift) then
					modified[part] = true
					part.CanCollide = false
				end
			end
	
			for part in modified do
				if not table.find(parts, part) then
					modified[part] = nil
					part.CanCollide = true
				end
			end
		end,
Character = function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    for _, part in char:GetDescendants() do
        if part:IsA("BasePart") and part.CanCollide and (not Spider.Enabled or SpiderShift) then
            modified[part] = true
            part.CanCollide = Spider.Enabled and not SpiderShift
        end
    end
end,
		CFrame = function()
			local chars = {gameCamera, LocalPlayer.Character}
			for _, v in LocalPlayer.List do
				table.insert(chars, v.Character)
			end
			rayCheck.FilterDescendantsInstances = chars
			overlapCheck.FilterDescendantsInstances = chars
	
			local ray = workspace:Raycast(LocalPlayer.character.Head.CFrame.Position, LocalPlayer.character.Humanoid.MoveDirection * 1.1, rayCheck)
			if ray and (not Spider.Enabled or SpiderShift) then
				local phaseDirection = grabClosestNormal(ray)
				if ray.Instance.Size[phaseDirection] <= StudLimit.Value then
					local root = LocalPlayer.character.HumanoidRootPart
					local dest = root.CFrame + (ray.Normal * (-(ray.Instance.Size[phaseDirection]) - (root.Size.X / 1.5)))
	
					if #workspace:GetPartBoundsInBox(dest, Vector3.one, overlapCheck) <= 0 then
						if Mode.Value == 'Motor' then
							motorMove(root, dest)
						else
							root.CFrame = dest
						end
					end
				end
			end
		end,
		FFlag = function()
			if teleported then return end
			setfflag('AssemblyExtentsExpansionStudHundredth', '-10000')
			fflag = true
		end
	}
	Functions.Motor = Functions.CFrame
	
	Phase = Player:AddModule({
		Name = 'Phase',
		Function = function(callback)
			if callback then
				Phase:Clean(RunService.Stepped:Connect(function()
					if IsAlive then
						Functions[Mode.Value]()
					end
				end))
	
				if Mode.Value == 'FFlag' then
					Phase:Clean(LocalPlayer.OnTeleport:Connect(function()
						teleported = true
						setfflag('AssemblyExtentsExpansionStudHundredth', '30')
					end))
				end
			else
				if fflag then
					setfflag('AssemblyExtentsExpansionStudHundredth', '30')
				end
				for part in modified do
					part.CanCollide = true
				end
				table.clear(modified)
				fflag = nil
			end
		end
	})
	Mode = Phase:AddDropdown({
		Name = 'Mode',
		List = {'Character', 'CFrame', 'Motor', 'FFlag'},
		Function = function(val)
			StudLimit.Object.Visible = val == 'CFrame' or val == 'Motor'
			if fflag then
				setfflag('AssemblyExtentsExpansionStudHundredth', '30')
			end
			for part in modified do
				part.CanCollide = true
			end
			table.clear(modified)
			fflag = nil
		end
	})
	StudLimit = Phase:AddSlider({
		Name = 'Wall Size',
		Min = 1,
		Max = 20,
		Default = 5,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end,
		Darker = true,
		Visible = false
	})
end)

run(function()
    -- Services & locals
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = workspace
    local LocalPlayer = Players.LocalPlayer
    local gameCamera = Workspace.CurrentCamera
    -- ???? 싲 ?  ?源???????? entitylib.isAlive ????? 늉?? ?????????? ? 럯?????饔낅????????? 뇡???????
    -- ??????  ?  ??
    local Fly
    local Options = { TPTiming = tick() }
    local Mode, FloatMode, State, MoveMethod, Keys
    local VerticalValue, BounceLength, BounceDelay
    local FloatTPGround, FloatTPAir, CustomProperties
    local WallCheck, PlatformStanding
    local Platform, YLevel, OldYLevel
    local w, s, a, d, up, down = 0, 0, 0, 0, 0, 0
    local FlyGyro, FlyVelocity

    -- Raycast
    local rayCheck = RaycastParams.new()
    rayCheck.RespectCanCollide = true
    Options.rayCheck = rayCheck

    -- ???????????? 싲 ?  ?????????????????棺堉? ???? 뚰??? 슆??(??????깅즿??????? 싲 ?  ?源??
    local frictionTable = rawget(_G, "frictionTable") or {}
    local function updateVelocity() end -- ??????????????? 싲 ?  ? 껁? 爾???????????饔낅??????轅붽????????? ∥?????????

    -- ???????? ??????? ?  ???????????? 듋???????????? WASD)
    local function calculateMoveVector(dir)
        local cam = gameCamera or Workspace.CurrentCamera
        if not cam then return Vector3.zero end
        local look = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector
        local wish = (right * dir.X) + (look * dir.Z)
        return wish.Magnitude > 0 and wish.Unit or Vector3.zero
    end

    -- ?????????????饔낅????????? 뇡???
    local SpeedMethods = {}
    SpeedMethods.Velocity = function(opts, moveDir, dt)
        if not IsAlive() then return end
        local root = LocalPlayer.character.HumanoidRootPart
        local spd = (opts.Value and opts.Value.Value) or 50
        local vel = moveDir * spd
        -- ??????????? ????????(Y??FloatMode?????
        local y = root.AssemblyLinearVelocity.Y
        root.AssemblyLinearVelocity = Vector3.new(vel.X, y, vel.Z)
    end
    SpeedMethods.CFrame = function(opts, moveDir, dt)
        if not IsAlive() then return end
        local root = LocalPlayer.character.HumanoidRootPart
        local spd = (opts.Value and opts.Value.Value) or 50
        root.CFrame += moveDir * spd * (dt or 0)
    end
    SpeedMethods.TP = function(opts, moveDir, dt)
        if not IsAlive() then return end
        local root = LocalPlayer.character.HumanoidRootPart
        local spd = (opts.Value and opts.Value.Value) or 50
        local freq = math.max((opts.TPFrequency and opts.TPFrequency.Value) or 0.2, 0.001)
        if tick() - (opts.TPTiming or 0) >= freq then
            opts.TPTiming = tick()
            root.CFrame = root.CFrame + moveDir * spd * (dt or 0.016)
        end
    end

    -- ????? 궽블 ???????뼿????饔낅????????? 뇡???
    local Functions = {
        Velocity = function()
            if not IsAlive() then return end
            local root = LocalPlayer.character.HumanoidRootPart
            local v = root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = Vector3.new(v.X, 2.25 + ((up + down) * VerticalValue.Value), v.Z)
        end,
        CFrame = function(dt)
            if not IsAlive() then return end
            local root = LocalPlayer.character.HumanoidRootPart
            YLevel = (YLevel or root.Position.Y) + ((up + down) * VerticalValue.Value * (dt or 0))
            -- ??????????? ??????, ????? 궽블 ??? ?????諛몃 ??????? 뮛????
            root.AssemblyLinearVelocity *= Vector3.new(1, 0, 1)
            root.CFrame += Vector3.new(0, YLevel - root.Position.Y, 0)
        end,
        Bounce = function()
            if not IsAlive() then return end
            local root = LocalPlayer.character.HumanoidRootPart
            Functions.Velocity()
            local bd = math.max(BounceDelay.Value, 0.001)
            root.AssemblyLinearVelocity += Vector3.new(0, ((tick() % bd) / bd > 0.5 and 1 or -1) * BounceLength.Value, 0)
        end,
        TP = function(dt)
            if not IsAlive() then return end
            local root = LocalPlayer.character.HumanoidRootPart
            Functions.CFrame(dt)
            local total = FloatTPAir.Value + FloatTPGround.Value
            if total > 0 and (tick() % total) > FloatTPAir.Value then
                OldYLevel = OldYLevel or YLevel
                rayCheck.FilterDescendantsInstances = {LocalPlayer.Character, gameCamera}
                rayCheck.CollisionGroup = root.CollisionGroup
                local ray = Workspace:Raycast(root.Position, Vector3.new(0, -1000, 0), rayCheck)
                if ray then
                    local hip = LocalPlayer.character.HipHeight or 2
                    YLevel = ray.Position.Y + hip
                end
            elseif OldYLevel then
                YLevel = OldYLevel
                OldYLevel = nil
            end
        end,
    }

    -- ?饔낅????????? 뇡???????? 첎? ??? 몃 ??(??txt?????Movement????? 늉?? ????? 땟戮녹?????????????????? ???? ??????좊틣?????????
    Fly = Movement:AddModule({
        Name = "Fly",
        Function = function(callback)
            local function cleanupSimpleFly()
                if FlyGyro then FlyGyro:Destroy() FlyGyro = nil end
                if FlyVelocity then FlyVelocity:Destroy() FlyVelocity = nil end
                if IsAlive() then
                    LocalPlayer.character.Humanoid.PlatformStand = false
                end
                w, s, a, d, up, down = 0, 0, 0, 0, 0, 0
                pcall(function()
                    Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                end)
            end

            local function startSimpleFly()
                cleanupSimpleFly()
                if not IsAlive() then return end

                local character = LocalPlayer.character
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local root = character:FindFirstChild("HumanoidRootPart")
                if not humanoid or not root then return end

                FlyGyro = Instance.new("BodyGyro")
                FlyGyro.P = 9e4
                FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                FlyGyro.CFrame = root.CFrame
                FlyGyro.Parent = root

                FlyVelocity = Instance.new("BodyVelocity")
                FlyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                FlyVelocity.Velocity = Vector3.zero
                FlyVelocity.Parent = root

                humanoid.PlatformStand = true
            end

            local function setSimpleFlyInput(input, state)
                if UserInputService:GetFocusedTextBox() then return end
                if input.KeyCode == Enum.KeyCode.W then
                    w = state and 1 or 0
                elseif input.KeyCode == Enum.KeyCode.S then
                    s = state and 1 or 0
                elseif input.KeyCode == Enum.KeyCode.A then
                    a = state and 1 or 0
                elseif input.KeyCode == Enum.KeyCode.D then
                    d = state and 1 or 0
                elseif input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.E then
                    up = state and 1 or 0
                elseif input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.Q then
                    down = state and 1 or 0
                end
            end

            if callback then
                startSimpleFly()
                Fly:Clean(UserInputService.InputBegan:Connect(function(input, processed)
                    if not processed then setSimpleFlyInput(input, true) end
                end))
                Fly:Clean(UserInputService.InputEnded:Connect(function(input)
                    setSimpleFlyInput(input, false)
                end))
                Fly:Clean(LocalPlayer.CharacterAdded:Connect(function()
                    task.wait(0.25)
                    if Fly.Enabled then startSimpleFly() end
                end))
                Fly:Clean(RunService.RenderStepped:Connect(function()
                    if not IsAlive() then return end
                    if not FlyGyro or not FlyVelocity or not FlyGyro.Parent or not FlyVelocity.Parent then
                        startSimpleFly()
                        return
                    end

                    local camera = Workspace.CurrentCamera
                    local humanoid = LocalPlayer.character:FindFirstChildOfClass("Humanoid")
                    if humanoid then humanoid.PlatformStand = true end
                    if camera then
                        pcall(function()
                            camera.CameraType = Enum.CameraType.Track
                        end)
                        FlyGyro.CFrame = camera.CFrame

                        local move =
                            (camera.CFrame.LookVector * (w - s)) +
                            (camera.CFrame.RightVector * (d - a)) +
                            (camera.CFrame.UpVector * (up - down))
                        FlyVelocity.Velocity = move.Magnitude > 0 and (move.Unit * Options.Value.Value) or Vector3.zero
                    end
                end))
            else
                cleanupSimpleFly()
            end
            if false then
            if callback then
                -- ??????? 굣 ???????멸괜???
                w = UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0
                s = UserInputService:IsKeyDown(Enum.KeyCode.S) and  1 or 0
                a = UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
                d = UserInputService:IsKeyDown(Enum.KeyCode.D) and  1 or 0
                up, down = 0, 0

                -- ??????? 굣 ??????? ??????? 쑄????????? 씭??????嶺뚮????Keys ???꿔꺂????????? 싲 ?  ?? ??????
                for _, ev in {"InputBegan","InputEnded"} do
                    Fly:Clean(UserInputService[ev]:Connect(function(input)
                        if UserInputService:GetFocusedTextBox() then return end
                        local divided = (Keys.Value or "Space/LeftControl"):split("/")
                        if input.KeyCode == Enum.KeyCode.W then
                            w = (ev == "InputBegan") and -1 or 0
                        elseif input.KeyCode == Enum.KeyCode.S then
                            s = (ev == "InputBegan") and 1 or 0
                        elseif input.KeyCode == Enum.KeyCode.A then
                            a = (ev == "InputBegan") and -1 or 0
                        elseif input.KeyCode == Enum.KeyCode.D then
                            d = (ev == "InputBegan") and 1 or 0
                        elseif input.KeyCode == Enum.KeyCode[divided[1]] then
                            up = (ev == "InputBegan") and 1 or 0   -- ?? Space
                        elseif input.KeyCode == Enum.KeyCode[divided[2]] then
                            down = (ev == "InputBegan") and -1 or 0 -- ?? LeftControl
                        end
                    end))
                end

                -- ?饔낅??????????? 멤 ????
                Fly:Clean(RunService.PreSimulation:Connect(function(dt)
                    if not IsAlive() then
                        YLevel, OldYLevel = nil, nil
                        return
                    end

                    -- Optional: PlatformStand
                    if PlatformStanding.Enabled then
                        LocalPlayer.character.Humanoid.PlatformStand = true
                        LocalPlayer.character.HumanoidRootPart.RotVelocity = Vector3.zero
                        if gameCamera then
                            LocalPlayer.character.HumanoidRootPart.CFrame =
                                CFrame.lookAlong(LocalPlayer.character.HumanoidRootPart.CFrame.Position, gameCamera.CFrame.LookVector)
                        end
                    end

                    -- Optional: Humanoid State ????? 늉????
                    if State.Value ~= "None" then
                        LocalPlayer.character.Humanoid:ChangeState(Enum.HumanoidStateType[State.Value])
                    end

                    -- ????????????Mode)
                    local moveVec =
                        (MoveMethod and MoveMethod.Value == "Direct")
                        and calculateMoveVector(Vector3.new(a + d, 0, w + s))
                        or (LocalPlayer.character.Humanoid.MoveDirection or Vector3.zero)

                    if SpeedMethods[Mode.Value] then
                        SpeedMethods[Mode.Value](Options, moveVec, dt)
                    end

                    -- ????? 궽블 ???????뼿???FloatMode)
                    if Functions[FloatMode.Value] then
                        Functions[FloatMode.Value](dt)
                    end
                end))

                -- ?饔낅????????? 뇡????????? 瑗????????????????????? 쑄??
                if UserInputService.TouchEnabled then
                    pcall(function()
                        local jumpButton = LocalPlayer.PlayerGui.TouchGui.TouchControlFrame.JumpButton
                        Fly:Clean(jumpButton:GetPropertyChangedSignal("ImageRectOffset"):Connect(function()
                            up = (jumpButton.ImageRectOffset.X == 146) and 1 or 0
                        end))
                    end)
                end
            else
                -- ????????? 첎? ?????
                YLevel, OldYLevel = nil, nil
                if IsAlive() and PlatformStanding.Enabled then
                    LocalPlayer.character.Humanoid.PlatformStand = false
                end
            end
            end
        end,
        ExtraText = function()
            return Options.Value and tostring(Options.Value.Value) or "50"
        end,
    })

    -- === UI ===
    if false then
    Mode = Fly:AddDropdown({
        Name = "Speed Mode",
        List = { "Velocity", "CFrame", "TP" },
        Function = function()
            if Fly.Enabled then Fly:Toggle(); Fly:Toggle() end
        end,
    })

    FloatMode = Fly:AddDropdown({
        Name = "Float Mode",
        List = { "Velocity", "CFrame", "Bounce", "TP" },
        Function = function(val)
            BounceLength.Frame.Visible = (val == "Bounce")
            BounceDelay.Frame.Visible = (val == "Bounce")
            FloatTPGround.Frame.Visible = (val == "TP")
            FloatTPAir.Frame.Visible = (val == "TP")
            if Fly.Enabled then Fly:Toggle(); Fly:Toggle() end
        end,
    })

    State = Fly:AddDropdown({
        Name = "Humanoid State",
        List = { "None", "Running", "Jumping", "Climbing", "Swimming" },
    })

    MoveMethod = Fly:AddDropdown({
        Name = "Move Mode",
        List = { "MoveDirection", "Direct" }, -- Direct??????? 듋???????????? WASD
    })

    Keys = Fly:AddDropdown({
        Name = "Keys",
        List = { "Space/LeftControl", "Space/LeftShift", "E/Q", "Space/Q", "ButtonA/ButtonL2" },
    })

    end

    Options.Value = Fly:AddSlider({
        Name = "fly speed",
        Min = 50, Max = 200, Default = 50,
        Suffix = "s",
    })

    if false then
    VerticalValue = Fly:AddSlider({
        Name = "Vertical Speed",
        Min = 1, Max = 150, Default = 50,
        Suffix = function(v) return v == 1 and "stud" or "studs" end,
    })

    Options.TPFrequency = Fly:AddSlider({
        Name = "TP Frequency",
        Min = 0, Max = 1, Decimal = 100, Default = 0.2,
        Darker = true, Visible = false,
        Suffix = function(v) return v == 1 and "second" or "seconds" end,
    })

    BounceLength = Fly:AddSlider({
        Name = "Bounce Length",
        Min = 0, Max = 30, Default = 10,
        Darker = true, Visible = false,
        Suffix = function(v) return v == 1 and "stud" or "studs" end,
    })

    BounceDelay = Fly:AddSlider({
        Name = "Bounce Delay",
        Min = 0, Max = 1, Decimal = 100, Default = 0.5,
        Darker = true, Visible = false,
        Suffix = function(v) return v == 1 and "second" or "seconds" end,
    })

    FloatTPGround = Fly:AddSlider({
        Name = "Ground",
        Min = 0, Max = 1, Decimal = 10, Default = 0.1,
        Darker = true, Visible = false,
        Suffix = function(v) return v == 1 and "second" or "seconds" end,
    })

    FloatTPAir = Fly:AddSlider({
        Name = "Air",
        Min = 0, Max = 5, Decimal = 10, Default = 2,
        Darker = true, Visible = false,
        Suffix = function(v) return v == 1 and "second" or "seconds" end,
    })

    WallCheck = Fly:AddToggle({
        Name = "Wall Check",
        Default = true, Darker = true, Visible = false,
    })

    PlatformStanding = Fly:AddToggle({
        Name = "PlatformStand",
        Function = function(on)
            if IsAlive() then
                LocalPlayer.character.Humanoid.PlatformStand = on
            end
        end,
    })

    CustomProperties = Fly:AddToggle({
        Name = "Custom Properties",
        Default = true,
        Function = function()
            if Fly.Enabled then Fly:Toggle(); Fly:Toggle() end
        end,
    })

    end

    for _, option in ipairs({
        Mode,
        FloatMode,
        State,
        MoveMethod,
        Keys,
        VerticalValue,
        Options.TPFrequency,
        BounceLength,
        BounceDelay,
        FloatTPGround,
        FloatTPAir,
        WallCheck,
        PlatformStanding,
        CustomProperties,
    }) do
        if option and option.Frame then
            option.Frame.Visible = false
        end
    end
end)



run(function()
	local SpinBot
	local Mode
	local XToggle
	local YToggle
	local ZToggle
	local Value
	local AngularVelocity
	
	SpinBot = Movement:AddModule({
		Name = 'Spin',
		Function = function(callback)
			if callback then
				SpinBot:Clean(RunService.PreSimulation:Connect(function()
					local root = entitylib.isAlive and entitylib.character and entitylib.character.RootPart
					if root then
						if Mode.Value == 'RotVelocity' then
							local originalRotVelocity = root.RotVelocity
							Players.LocalPlayer.Character.Humanoid.AutoRotate = false
							root.RotVelocity = Vector3.new(XToggle.Enabled and Value.Value or originalRotVelocity.X, YToggle.Enabled and Value.Value or originalRotVelocity.Y, ZToggle.Enabled and Value.Value or originalRotVelocity.Z)
						elseif Mode.Value == 'CFrame' then
							local val = math.rad((tick() * (20 * Value.Value)) % 360)
							local x, y, z = root.CFrame:ToOrientation()
							root.CFrame = CFrame.new(root.Position) * CFrame.Angles(XToggle.Enabled and val or x, YToggle.Enabled and val or y, ZToggle.Enabled and val or z)
						elseif AngularVelocity then
							if not AngularVelocity.Parent then
								pcall(function()
									AngularVelocity:Destroy()
								end)

								AngularVelocity = Instance.new("BodyAngularVelocity")
								AngularVelocity.Name = "SpinBotVelocity"
								AngularVelocity.Parent = root
							end

							AngularVelocity.MaxTorque = Vector3.new(
								XToggle.Enabled and math.huge or 0,
								YToggle.Enabled and math.huge or 0,
								ZToggle.Enabled and math.huge or 0
							)

							AngularVelocity.AngularVelocity = Vector3.new(
								Value.Value,
								Value.Value,
								Value.Value
							)
						end
					end
				end))
			else
				local humanoid = entitylib.character and entitylib.character.Humanoid
				if humanoid and Mode.Value == 'RotVelocity' then
					humanoid.AutoRotate = true
				end
				if AngularVelocity then
					AngularVelocity.Parent = nil
				end
			end
		end
	})
	Mode = SpinBot:AddDropdown({
		Name = 'Mode',
		List = {'CFrame', 'RotVelocity', 'BodyMover'},
		Function = function(val)
			if AngularVelocity then
				AngularVelocity:Destroy()
				AngularVelocity = nil
			end
			AngularVelocity = val == 'BodyMover' and Instance.new('BodyAngularVelocity') or nil
		end
	})
	Value = SpinBot:AddSlider({
		Name = 'Speed',
		Min = 1,
		Max = 100,
		Default = 40
	})
	XToggle = SpinBot:AddToggle({Name = 'Spin X'})
	YToggle = SpinBot:AddToggle({
		Name = 'Spin Y',
		Default = true
	})
	ZToggle = SpinBot:AddToggle({Name = 'Spin Z'})
end)

run(function()
	local Orbit

	Orbit = Combat:AddModule({
		Name = 'Orbit',
		Function = function(callback)
			if callback then

				local findFirstChild = game.FindFirstChild
				local bindToRenderStep = RunService.BindToRenderStep

				-- ???????諛몃 ?????? ??????諛몃 ??λ????????
				_G.OrbitConfig = {
					enabled = true,
					speed = 500,
					distance = 5,
					height = -4,
					lastAngle = 0,
					maxDistance = 800,
					useDesync = true
				}

				_G.OrbitCframes = {}
				_G.OrbitRenderRunning = false
				_G.OrbitTeleportCooldown = 0  -- ???????諛몃 ??????????????
				
				local lastPos
				local TargetReady = false
				local LobbyLeftTime = 0

				-------------------------------------------------
				-- LOBBY CHECK
				-------------------------------------------------

				local function InLobby()
					local gui = LocalPlayer:FindFirstChild("PlayerGui")
					if not gui then return false end

					local main = gui:FindFirstChild("MainGui")
					if not main then return false end

					local frame = main:FindFirstChild("MainFrame")
					if not frame then return false end

					local lobby = frame:FindFirstChild("Lobby")
					if not lobby then return false end

					local currency = lobby:FindFirstChild("Currency")
					if not currency then return false end

					return currency.Visible
				end

				-------------------------------------------------
				-- UTIL
				-------------------------------------------------

				local function GetRoot(char)
					if char then
						return char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
					end
				end

				_G.LocalAlive = function()
					local char = LocalPlayer.Character
					return char
						and findFirstChild(char,"Humanoid")
						and char.Humanoid.Health > 0
						and GetRoot(char)
				end

				-------------------------------------------------
				-- PLAYER ALIVE CHECK
				-------------------------------------------------

				local function PlayerAlive(char)
					local hum = char and char:FindFirstChildOfClass("Humanoid")
					return hum and hum.Health > 0
				end

				-------------------------------------------------
				-- TELEPORT CHECK
				-------------------------------------------------

				local function TeleportCheck(root)
					if not lastPos then
						lastPos = root.Position
						return false
					end

					local dist = (root.Position - lastPos).Magnitude
					lastPos = root.Position

					if dist > 80 then
						_G.OrbitTeleportCooldown = tick() + 1.2
						return true
					end

					return false
				end

				-------------------------------------------------
				-- RENDER FIX (DESYNC)
				-------------------------------------------------

				_G.StartOrbitRenderFix = function()
					if _G.OrbitRenderRunning then
						RunService:UnbindFromRenderStep("DesyncFix")
					end

					_G.OrbitRenderRunning = true

					bindToRenderStep(
						RunService,
						"DesyncFix",
						Enum.RenderPriority.First.Value,
						function()
							if not _G.OrbitConfig.useDesync then return end

							if _G.OrbitTeleportCooldown > tick() then
								return
							end

							if not _G.LocalAlive() then return end

							if _G.OrbitCframes.client then
								local char = LocalPlayer.Character
								local root = char and GetRoot(char)

								if root then
									root.CFrame = _G.OrbitCframes.client
								end
							end
						end
					)
				end

				_G.StopOrbitRenderFix = function()
					if _G.OrbitRenderRunning then
						RunService:UnbindFromRenderStep("DesyncFix")
						_G.OrbitRenderRunning = false
					end
				end

				-------------------------------------------------
				-- CHARACTER FIX
				-------------------------------------------------

				local function OnCharacter(char)
					lastPos = nil

					local hum = char:WaitForChild("Humanoid")

					-- ??Desync????? 늉?? ???袁⑸즴筌?????? 싲 ?  ? 껁? 爾???RenderFix ???꿔꺂???影??  ?
					if _G.OrbitConfig.useDesync then
						_G.StartOrbitRenderFix()
					end

					Orbit:Clean(hum.Died:Connect(function()
						_G.OrbitConfig.enabled = false
						_G.OrbitCframes.client = nil
						_G.OrbitCframes.desync = nil
						TargetReady = false
						LobbyLeftTime = 0
						_G.StopOrbitRenderFix()
					end))
				end

				if LocalPlayer.Character then
					OnCharacter(LocalPlayer.Character)
				end

				Orbit:Clean(LocalPlayer.CharacterAdded:Connect(OnCharacter))

				-------------------------------------------------
				-- TARGET
				-------------------------------------------------

				local function GetNearestPlayer()
					local myRoot = GetRoot(LocalPlayer.Character)
					if not myRoot then return end

					local closest
					local closestDist = _G.OrbitConfig.maxDistance

					for _,plr in pairs(Players:GetPlayers()) do
						if plr ~= LocalPlayer then
							local char = plr.Character
							local root = GetRoot(char)

							if root and PlayerAlive(char) then
								local dist = (root.Position - myRoot.Position).Magnitude

								if dist < closestDist then
									closestDist = dist
									closest = plr
								end
							end
						end
					end

					return closest
				end

				-------------------------------------------------
				-- HEARTBEAT
				-------------------------------------------------

				Orbit:Clean(RunService.Heartbeat:Connect(function(dt)
					local char = LocalPlayer.Character
					local root = GetRoot(char)

					if not root then return end

					-------------------------------------------------
					-- TELEPORT FIX
					-------------------------------------------------

					if TeleportCheck(root) then
						_G.OrbitConfig.enabled = false
						_G.OrbitCframes.client = nil
						_G.OrbitCframes.desync = nil
						TargetReady = false
						LobbyLeftTime = 0
						return
					end

					-------------------------------------------------
					-- TELEPORT COOLDOWN
					-------------------------------------------------

					if _G.OrbitTeleportCooldown > tick() then
						return
					end

					-------------------------------------------------
					-- LOBBY CHECK
					-------------------------------------------------

					if InLobby() then
						_G.OrbitConfig.enabled = false
						TargetReady = false
						LobbyLeftTime = 0
						_G.OrbitCframes.client = nil
						_G.OrbitCframes.desync = nil
						return
					end

					-------------------------------------------------
					-- LOBBY EXIT DELAY
					-------------------------------------------------

					if not TargetReady then
						if LobbyLeftTime == 0 then
							LobbyLeftTime = tick()
							return
						end

						if tick() - LobbyLeftTime >= 1 then
							TargetReady = true
							_G.OrbitConfig.enabled = true
						else
							return
						end
					end

					-------------------------------------------------
					-- ORBIT LOGIC
					-------------------------------------------------

					if not _G.OrbitConfig.enabled then return end
					if not _G.LocalAlive() then return end

					if _G.OrbitConfig.useDesync then
						_G.OrbitCframes.client = root.CFrame
					end

					local target = GetNearestPlayer()

					if target and target.Character and PlayerAlive(target.Character) then
						local targetRoot = GetRoot(target.Character)

						if targetRoot then
							_G.OrbitConfig.lastAngle += dt * _G.OrbitConfig.speed * math.rad(360)

							local radius = _G.OrbitConfig.distance + math.random(-3,3)
							local height = _G.OrbitConfig.height + math.random(-6,6)

							local noise = math.rad(math.random(-20,20))
							local angle = _G.OrbitConfig.lastAngle + noise

							local center = targetRoot.Position

							local pos = center + Vector3.new(
								math.cos(angle) * radius,
								height,
								math.sin(angle) * radius
							)

							local orbitCF = CFrame.new(pos, center)

							root.CFrame = orbitCF
							
							if _G.OrbitConfig.useDesync then
								_G.OrbitCframes.desync = orbitCF
							end
						end
					end
				end))

			else
				-- ?饔낅????????? 뇡????????????? 쵂??????轅붽?????????
				if _G.OrbitConfig then
					_G.OrbitConfig.enabled = false
				end
				if _G.OrbitCframes then
					_G.OrbitCframes.client = nil
					_G.OrbitCframes.desync = nil
				end
				if _G.StopOrbitRenderFix then
					_G.StopOrbitRenderFix()
				end
			end
		end
	})

	-- ??Desync Toggle
	Orbit:AddToggle({
		Name = 'Desync',
		Default = false,
		Function = function(callback)
			if not _G.OrbitConfig then return end
			
			_G.OrbitConfig.useDesync = callback
			
			if not callback then
				-- Desync OFF
				_G.OrbitCframes.client = nil
				_G.OrbitCframes.desync = nil
				_G.StopOrbitRenderFix()
			else
				-- Desync ON
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					_G.StartOrbitRenderFix()
				end
			end
		end
	})

	-- ??Speed Slider
	Orbit:AddSlider({
		Name = 'Speed',
		Min = 100,
		Max = 1000,
		Default = 500,
		Decimal = 1,
		Function = function(val, final)
			if _G.OrbitConfig then
				_G.OrbitConfig.speed = val
			end
		end
	})

	-- ??Distance Slider
	Orbit:AddSlider({
		Name = 'Distance',
		Min = 3,
		Max = 15,
		Default = 5,
		Decimal = 1,
		Function = function(val, final)
			if _G.OrbitConfig then
				_G.OrbitConfig.distance = val
			end
		end
	})

	-- ??Height Slider
	Orbit:AddSlider({
		Name = 'Height',
		Min = -10,
		Max = 20,
		Default = -4,
		Decimal = 1,
		Function = function(val, final)
			if _G.OrbitConfig then
				_G.OrbitConfig.height = val
			end
		end
	})

	-- ??Max Distance Slider
	Orbit:AddSlider({
		Name = 'Max Distance',
		Min = 100,
		Max = 1500,
		Default = 800,
		Decimal = 1,
		Function = function(val, final)
			if _G.OrbitConfig then
				_G.OrbitConfig.maxDistance = val
			end
		end
	})
end)

run(function()
    local Ragebot
    local RagebotSettings = {
        on = false,
        targetMode = "Closest",
        autoSwitch = true,
        autoSwapSecondary = true,
        autoReloadPrimary = true,
        attackMode = "gun",
        preferredWeapon = "primary",
        meleeSlot = 3,
        weaponSpecialize = true,
        autoEquipPreferred = true,
        preferProjectile = false,
        autoPriority = false,
        priorityAttackers = true,
        priorityVoided = true,
        sendNotification = false,
        prioritizedPlayer = nil,
        primarySlot = 1,
        secondarySlot = 2,
        acSpd = 0.05,
        shootDelay = 0,
        teleportDelay = 0.04,
        orbitDist = 3,
        orbitHeight = 2,
        randomMovement = false,
        randomRefresh = 0.08,
        mode = "Orbit",
        strafeSpeed = 5,
        undergroundDepth = 6,
        behindDist = 4,
        antiAim = false,
        hyper = false,
        useManipulation = true,
        voidSpam = true,
        voidHideTime = 0.25,
        voidShootTime = 0.03,
        shootAttempts = 1,
        otherMatchAvoidDistance = 1000,
        settleUntil = 0,
        dirBack = true,
        dirFront = false,
        dirLeft = true,
        dirRight = true,
        dirUp = true,
        dirDown = false,
    }

    local function markRagebotSettingsDirty()
        RagebotSettings.settleUntil = 0
    end

    local rbGen = 0
    local rbDuelMod, rbInMatchT, rbInMatch = nil, 0, false
    local rbTgtT = 0
    local slotKey = {[1] = Enum.KeyCode.One, [2] = Enum.KeyCode.Two, [3] = Enum.KeyCode.Three, [4] = Enum.KeyCode.Four}

    Ragebot = Movement:AddModule({
        Name = 'Ragebot',
        Function = function(callback)
            local cfg = RagebotSettings

            if callback then
                if getgenv().__IDKRagebotStop then
                    pcall(getgenv().__IDKRagebotStop)
                    getgenv().__IDKRagebotStop = nil
                end

                cfg.on = true
                cfg.settleUntil = 0

                local players = cloneref(game:GetService("Players"))
                local runservice = cloneref(game:GetService("RunService"))
                local vim = cloneref(game:GetService("VirtualInputManager"))
                local ws = cloneref(game:GetService("Workspace"))
                local rs = cloneref(game:GetService("ReplicatedStorage"))
                local lplr = players.LocalPlayer

                local util, enums, useItemRemote, fighterCtrl
                pcall(function()
                    util = require(rs.Modules.Utility)
                    enums = require(rs.Modules.EnumLibrary)
                    useItemRemote = rs.Remotes.Replication.Fighter.UseItem
                    fighterCtrl = require(lplr.PlayerScripts.Controllers.FighterController)
                end)

                local state = {
                    active = true,
                    target = nil,
                    conn = nil,
                    ammoThread = nil,
                    voidThread = nil,
                    voidHbConn = nil,
                    csyncHbConn = nil,
                    voidExposed = false,
                    voidTargetCF = nil,
                    nextTeleportAt = 0,
                    ammoActionAt = 0,
                    hideOrbitUntil = 0,
                    randPos = nil,
                    randT = 0,
                    lastFakePos = nil,
                    csyncCF = nil,
                    csyncLV = nil,
                    csyncAV = nil,
                    csyncLocalCF = nil,
                    csyncLocalLV = nil,
                    csyncLocalAV = nil,
                    csyncWroteFake = false,
                    noclipConn = nil,
                    suspended = isShootingRange(),
                }

                local function getRoot(char)
                    return char and char:FindFirstChild("HumanoidRootPart")
                end

                local function getFighter()
                    if fighterCtrl and fighterCtrl.LocalFighter then return fighterCtrl.LocalFighter end
                    if fighterCtrl and fighterCtrl.GetFighter then
                        local ok, fighter = pcall(fighterCtrl.GetFighter, fighterCtrl, lplr)
                        if ok then return fighter end
                    end
                    return nil
                end

                local function pressKey(kc)
                    vim:SendKeyEvent(true, kc, false, game)
                    task.wait(0.03)
                    vim:SendKeyEvent(false, kc, false, game)
                end

                local function scanWeapon(plr)
                    local vms = ws:FindFirstChild("ViewModels")
                    if not vms then return "" end
                    for _, model in vms:GetChildren() do
                        if model:IsA("Model") then
                            local sp = model.Name:find(" - ", 1, true)
                            if sp and model.Name:sub(1, sp - 1) == plr.Name then
                                return model.Name:sub(sp + 3):lower()
                            end
                        end
                    end
                    return ""
                end

                local function playerIsDead(plr)
                    local char = plr and plr.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    return not char or not hum or hum.Health <= 0 or not getRoot(char)
                end

                local function isInvincible(plr)
                    local char = plr and plr.Character
                    if not char then return true end

                    local root = getRoot(char)
                    if not root then return true end

                    for _, obj in root:GetChildren() do
                        if obj:IsA("Attachment") and obj.Name == "Attachment" then
                            return true
                        end
                    end

                    return char:FindFirstChild("InvincibilityParticles", true) ~= nil
                end

                local function isKatana(plr)
                    return scanWeapon(plr):find("katana", 1, true) ~= nil
                end

                local function isRiotShield(plr)
                    local weapon = scanWeapon(plr)
                    return weapon:find("riot", 1, true) ~= nil or weapon:find("shield", 1, true) ~= nil
                end

                local function IsValidMatch(player)
                    return player:GetAttribute("EnvironmentID") == lplr:GetAttribute("EnvironmentID")
                end

                local function isNearOtherMatch(pos, ignorePlayer)
                    local avoidDistance = cfg.otherMatchAvoidDistance or 1000
                    if typeof(pos) ~= "Vector3" or avoidDistance <= 0 then return false end

                    for _, plr in players:GetPlayers() do
                        if plr ~= lplr and plr ~= ignorePlayer and not IsValidMatch(plr) then
                            local otherRoot = getRoot(plr.Character)
                            if otherRoot and (otherRoot.Position - pos).Magnitude <= avoidDistance then
                                return true
                            end
                        end
                    end

                    return false
                end

                local function isSafeRagebotPos(pos, targetPlayer)
                    return not isNearOtherMatch(pos, targetPlayer)
                end

                local function shouldSkip(plr)
                    if plr == lplr or playerIsDead(plr) then return true end
                    if not IsValidMatch(plr) then return true end
                    if isInvincible(plr) then return true end
                    local root = getRoot(plr.Character)
                    if root and isNearOtherMatch(root.Position, plr) then return true end
                    return root and root:FindFirstChild("TeammateLabel") ~= nil
                end

                local function getBestTarget()
                    local root = getRoot(lplr.Character)
                    if not root then return nil end
                    if cfg.prioritizedPlayer then
                        local priorityPlayer = players:FindFirstChild(cfg.prioritizedPlayer)
                        if priorityPlayer and not shouldSkip(priorityPlayer) then
                            return priorityPlayer
                        end
                    end
                    local best, bestV = nil, math.huge
                    local useHP = cfg.targetMode == "Lowest Health"
                    for _, plr in players:GetPlayers() do
                        if not shouldSkip(plr) then
                            local char = plr.Character
                            local tr = getRoot(char)
                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                            local value = useHP and hum.Health or (tr.Position - root.Position).Magnitude
                            if cfg.autoPriority then
                                if cfg.priorityVoided and tr.Position.Magnitude > 1000000 then
                                    value -= 2000000000
                                end
                                if cfg.priorityAttackers and scanWeapon(plr) ~= "" then
                                    value -= 1000000000
                                end
                            end
                            if value < bestV then
                                bestV = value
                                best = plr
                            end
                        end
                    end
                    return best
                end

                local function hasValidTarget()
                    return state.target and not playerIsDead(state.target) and not isInvincible(state.target)
                end

                local function updateRagebotStatus()
                    local target = hasValidTarget() and state.target or nil
                    local voiding = not target or ((cfg.mode == "Void" or cfg.mode == "Orbit") and not state.voidExposed)
                    setRagebotStatus(state.active and cfg.on, target, voiding)
                end

                local function shouldShoot()
                    if not hasValidTarget() then return false end
                    if isKatana(state.target) then return false end
                    if cfg.mode == "Void" and not state.voidExposed then return false end
                    return true
                end

                local function getEquippedSlot()
                    local fighter = getFighter()
                    local item = fighter and fighter.EquippedItem
                    if not item then return nil end
                    local slot = item:Get("Slot")
                    return tonumber(slot)
                end

                local function equipSlot(slot)
                    slot = tonumber(slot) or 1
                    local key = slotKey[slot] or Enum.KeyCode.One
                    pcall(function()
                        pressKey(key)
                    end)
                end

                -- 무기별 특화 레이지 프로파일
                local function applyWeaponRageProfile()
                    if cfg.weaponSpecialize == false then return "default" end
                    local slot = getEquippedSlot()
                    local pref = cfg.preferredWeapon or "primary"

                    -- preferred 자동 장착
                    if cfg.autoEquipPreferred ~= false then
                        local want = (pref == "secondary" and (cfg.secondarySlot or 2))
                            or (pref == "melee" and (cfg.meleeSlot or 3))
                            or (cfg.primarySlot or 1)
                        if slot ~= want then
                            equipSlot(want)
                            slot = want
                        end
                    end

                    local kind
                    if slot == (cfg.meleeSlot or 3) or pref == "melee" then
                        kind = "melee"
                    elseif slot == (cfg.secondarySlot or 2) or pref == "secondary" then
                        kind = "secondary"
                    else
                        kind = "primary"
                    end

                    if kind == "primary" then
                        -- 주무기: 공격적 Orbit + 예측 강함
                        cfg.mode = "Orbit"
                        cfg.hyper = true
                        cfg.orbitDist = 3.2
                        cfg.orbitHeight = 2.2
                        cfg.strafeSpeed = 6
                        cfg.teleportDelay = 0.035
                        cfg.predictLead = 0.14
                        cfg.behindDist = 3.5
                        cfg.randomMovement = false
                        cfg.dirBack = true
                        cfg.dirFront = false
                        cfg.dirLeft = true
                        cfg.dirRight = true
                    elseif kind == "secondary" then
                        -- 보조무기: Teleport 예측 특화 (빠른 재배치)
                        cfg.mode = "Teleport"
                        cfg.hyper = false
                        cfg.orbitDist = 2.6
                        cfg.orbitHeight = 1.6
                        cfg.strafeSpeed = 4
                        cfg.teleportDelay = 0.028
                        cfg.predictLead = 0.11
                        cfg.behindDist = 3.0
                        cfg.randomMovement = true
                        cfg.randomRefresh = 0.07
                        cfg.dirBack = true
                        cfg.dirFront = true
                        cfg.dirLeft = true
                        cfg.dirRight = true
                    else
                        -- 근접: 바짝 붙는 Underground/Behind 특화
                        cfg.mode = "Underground"
                        cfg.hyper = true
                        cfg.orbitDist = 1.6
                        cfg.orbitHeight = 0.6
                        cfg.strafeSpeed = 8
                        cfg.teleportDelay = 0.02
                        cfg.predictLead = 0.08
                        cfg.behindDist = 2.2
                        cfg.undergroundDepth = 4
                        cfg.randomMovement = false
                        cfg.dirBack = true
                        cfg.dirFront = false
                        cfg.dirLeft = true
                        cfg.dirRight = true
                        cfg.dirDown = true
                    end

                    state.weaponKind = kind
                    return kind
                end

                local function handleAmmo()
                    local fighter = getFighter()
                    local item = fighter and fighter.EquippedItem
                    if not fighter or not item then return false end
                    local ammo = item:Get("Ammo") or 0
                    local slot = item:Get("Slot") or 1
                    local now = tick()
                    if fighter:Get("Reloading") then
                        state.hideOrbitUntil = math.max(state.hideOrbitUntil or 0, now + 0.25)
                        state.ammoActionAt = math.max(state.ammoActionAt or 0, now + 0.1)
                        return true
                    end
                    if ammo > 0 then return false end
                    if now < (state.ammoActionAt or 0) then return true end

                    local primary = cfg.primarySlot or 1
                    local secondary = cfg.secondarySlot or 2
                    if slot == primary and cfg.autoSwapSecondary then
                        state.ammoActionAt = now + 0.45
                        state.hideOrbitUntil = math.max(state.hideOrbitUntil or 0, now + 0.45)
                        pressKey(slotKey[secondary] or Enum.KeyCode.Two)
                        return true
                    end
                    if slot == secondary and cfg.autoReloadPrimary then
                        state.ammoActionAt = now + 0.6
                        state.hideOrbitUntil = math.max(state.hideOrbitUntil or 0, now + 0.75)
                        pressKey(slotKey[primary] or Enum.KeyCode.One)
                        task.delay(0.18, function()
                            if not state.active then return end
                            local f2 = getFighter()
                            local i2 = f2 and f2.EquippedItem
                            if f2 and i2 and (i2:Get("Slot") or 1) == primary and (i2:Get("Ammo") or 0) <= 0 and not f2:Get("Reloading") then
                                pressKey(Enum.KeyCode.R)
                            end
                        end)
                        return true
                    end
                    if slot == primary and cfg.autoReloadPrimary then
                        state.ammoActionAt = now + 0.5
                        state.hideOrbitUntil = math.max(state.hideOrbitUntil or 0, now + 0.75)
                        pressKey(Enum.KeyCode.R)
                        return true
                    end
                    return true
                end

                local function buildCameraData(fromPos, part)
                    if not util or not part then return nil end
                    local look = CFrame.new(fromPos, part.Position)
                    local data = {}
                    data[utf8.char(1)] = {
                        [utf8.char(0)] = util:EncodeCFrame(look),
                        [utf8.char(1)] = util:EncodeCFrame(look),
                        [utf8.char(2)] = part,
                        [utf8.char(3)] = util:EncodeCFrame(part.CFrame:ToObjectSpace(CFrame.new(part.Position)))
                    }
                    return data
                end

                local function doFire(part)
                    local fighter = getFighter()
                    local item = fighter and fighter.EquippedItem
                    if not item or not part then return false end

                    local cam = ws.CurrentCamera
                    local fromPos = (state.csyncCF and state.csyncCF.Position) or (cam and cam.CFrame.Position) or part.Position
                    local anyFired = false
                    local attempts = math.max(1, math.floor(cfg.shootAttempts or 1))

                    for _ = 1, attempts do
                        local fired = false
                        if cfg.useManipulation and useItemRemote and enums and util then
                            local ammo = item.Get and (item:Get("Ammo") or 0) or 0
                            if ammo > 0 then
                                local oid = item:Get("ObjectID")
                                local shootEnum = enums:ToEnum("StartShooting")
                                local data = buildCameraData(fromPos, part)
                                if oid and shootEnum and data then
                                    fired = pcall(function()
                                        useItemRemote:FireServer(oid, shootEnum, data, nil)
                                    end)
                                end
                            end
                        end

                        if not fired and item.UseItem then
                            fired = pcall(function() item:UseItem() end)
                        end
                        if not fired and fighter and fighter.UseItem then
                            fired = pcall(function() fighter:UseItem() end)
                        end
                        anyFired = anyFired or fired
                    end
                    return anyFired
                end

                local function isLobby()
                    local playerGui = lplr:FindFirstChild("PlayerGui")
                    local mainGui = playerGui and playerGui:FindFirstChild("MainGui")
                    local mainFrame = mainGui and mainGui:FindFirstChild("MainFrame")
                    local lobby = mainFrame and mainFrame:FindFirstChild("Lobby")
                    local currency = lobby and lobby:FindFirstChild("Currency")
                    return currency and currency.Visible == true
                end

                local function getDuel()
                    if not rbDuelMod then
                        local ps = lplr:FindFirstChild("PlayerScripts")
                        local ct = ps and ps:FindFirstChild("Controllers")
                        local dc = ct and ct:FindFirstChild("DuelController")
                        if dc then
                            local ok, mod = pcall(require, dc)
                            if ok and mod then rbDuelMod = mod end
                        end
                    end

                    if rbDuelMod and rbDuelMod.GetDuel then
                        local ok, duel = pcall(rbDuelMod.GetDuel, rbDuelMod, lplr)
                        if ok then return duel end
                    end
                end

                local function isValidMatch()
                    if isLobby() or isShootingRange() then return false end

                    local char = lplr.Character
                    local root = getRoot(char)
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if not char or not root or not hum or hum.Health <= 0 then
                        return false
                    end

                    local duel = getDuel()
                    if duel ~= nil then
                        return true
                    end

                    local fighter = getFighter()
                    return fighter ~= nil
                end

                local function inMatch()
                    local now = tick()
                    if now - rbInMatchT < 0.25 then return rbInMatch end
                    rbInMatchT = now
                    rbInMatch = isValidMatch()
                    return rbInMatch
                end

                local function undergroundPos(head, targetRoot)
                    local depth = math.clamp(cfg.undergroundDepth or 6, 3, 8)
                    local radius = math.clamp(cfg.orbitDist or 3, 1.25, 4)
                    return head.Position - targetRoot.CFrame.LookVector * radius + Vector3.new(0, -depth, 0)
                end

                local oldFireServerRagebot
                local rbHookInstalled = false
                local enterVoidState
                local setVoidCsync
                local function installRagebotHook()
                    if rbHookInstalled then return end
                    if not useItemRemote then return end
                    rbHookInstalled = true
                    oldFireServerRagebot = hookfunction(useItemRemote.FireServer, newcclosure(function(self, oid, action, cameradata, ...)
                        if state.active and cfg.on and cfg.mode == "Void" and cfg.useManipulation and action == enums:ToEnum("StartShooting") then
                            if isLobby() or not inMatch() then
                                return oldFireServerRagebot(self, oid, action, cameradata, ...)
                            end
                            
                            local target = state.target
                            if hasValidTarget() and not isKatana(target) then
                                local tc = target.Character
                                local tr = getRoot(tc)
                                local head = tc and (tc:FindFirstChild("Head") or tr)
                                if tr and head then
                                    local shootPos = isRiotShield(target)
                                        and (tr.Position - tr.CFrame.LookVector * (cfg.behindDist or 4))
                                        or (tr.Position - tr.CFrame.LookVector * 2.5 + Vector3.new(0, 1.5, 0))
                                    if not isSafeRagebotPos(shootPos, target) then
                                        enterVoidState()
                                        return oldFireServerRagebot(self, oid, action, cameradata, ...)
                                    end
                                    local shootCF = CFrame.new(shootPos, head.Position)
                                    
                                    state.voidExposed = true
                                    state.voidTargetCF = shootCF
                                    setVoidCsync(shootCF, Vector3.zero, Vector3.zero)
                                    updateRagebotStatus()
                                    
                                    task.wait(0.02)
                                    
                                    local newData = buildCameraData(shootPos, head) or cameradata
                                    
                                    task.spawn(function()
                                        task.wait(0.05)
                                        enterVoidState()
                                    end)
                                    
                                    return oldFireServerRagebot(self, oid, action, newData, ...)
                                end
                            end
                        end
                        return oldFireServerRagebot(self, oid, action, cameradata, ...)
                    end))
                end

                local function rnd()
                    return math.random() * 2 - 1
                end

                local function rndDir()
                    local angle = math.random() * math.pi * 2
                    return Vector3.new(math.cos(angle), 0, math.sin(angle))
                end

                local function getDirs(targetRoot)
                    local dirs = {}
                    local look = targetRoot.CFrame.LookVector
                    local right = targetRoot.CFrame.RightVector
                    if cfg.dirBack then table.insert(dirs, -look) end
                    if cfg.dirFront then table.insert(dirs, look) end
                    if cfg.dirLeft then table.insert(dirs, -right) end
                    if cfg.dirRight then table.insert(dirs, right) end
                    if #dirs == 0 then
                        dirs[1] = -look
                        dirs[2] = right
                        dirs[3] = -right
                    end
                    return dirs
                end

                local function pickOffset(targetRoot, head)
                    local dirs = getDirs(targetRoot)
                    local dir = dirs[math.random(1, #dirs)]
                    local radius = math.clamp(cfg.orbitDist or 3, 1.25, 5)
                    local height = math.clamp(cfg.orbitHeight or 2, -2, 6)
                    local pos = head.Position + dir * radius + Vector3.new(0, height, 0)
                    if cfg.dirUp and math.random() < 0.2 then
                        pos += Vector3.new(0, math.max(1, height), 0)
                    elseif cfg.dirDown and math.random() < 0.15 then
                        pos += Vector3.new(0, -math.max(1, math.min(3, cfg.undergroundDepth or 2)), 0)
                    end
                    return pos
                end

                local function setCsync(cf, pos, dt)
                    local old = state.lastFakePos
                    state.csyncCF = cf
                    state.csyncLV = old and dt and dt > 0 and (pos - old) / dt or Vector3.zero
                    state.csyncAV = Vector3.zero
                    state.lastFakePos = pos
                end

                local function applyExternalMovementVelocity()
                    local fn = getgenv and getgenv().__LionApplyMovementVelocity
                    if type(fn) == "function" then
                        pcall(fn)
                    end
                end

                local function clearCsyncTarget()
                    state.csyncCF = nil
                    state.csyncLV = nil
                    state.csyncAV = nil
                    state.lastFakePos = nil
                end

                local function isRagebotSettling()
                    return os.clock() < (cfg.settleUntil or 0)
                end

                local function restoreLocalRoot(root)
                    if not root or not state.csyncLocalCF then return false end
                    local liveVelocity = root.AssemblyLinearVelocity
                    root.CFrame = state.csyncLocalCF
                    if state.csyncLocalLV then
                        root.AssemblyLinearVelocity = Vector3.new(state.csyncLocalLV.X, liveVelocity.Y, state.csyncLocalLV.Z)
                    end
                    if state.csyncLocalAV then
                        root.AssemblyAngularVelocity = state.csyncLocalAV
                    end
                    return true
                end

                local function startCsync()
                    if state.csyncHbConn then return end
                    state.csyncHbConn = runservice.Heartbeat:Connect(function()
                        local root = getRoot(lplr.Character)
                        if not root then return end
                        if state.csyncWroteFake and state.csyncLocalCF then
                            restoreLocalRoot(root)
                        end
                        if isRagebotSettling() then
                            state.csyncLocalCF = root.CFrame
                            state.csyncLocalLV = root.AssemblyLinearVelocity
                            state.csyncLocalAV = root.AssemblyAngularVelocity
                            state.csyncWroteFake = false
                            return
                        end
                        state.csyncLocalCF = root.CFrame
                        state.csyncLocalLV = root.AssemblyLinearVelocity
                        state.csyncLocalAV = root.AssemblyAngularVelocity
                        if state.csyncCF then
                            root.CFrame = state.csyncCF
                            local fakeVelocity = state.csyncLV or state.csyncLocalLV or root.AssemblyLinearVelocity
                            local localVelocity = state.csyncLocalLV or root.AssemblyLinearVelocity
                            root.AssemblyLinearVelocity = Vector3.new(fakeVelocity.X, localVelocity.Y, fakeVelocity.Z)
                            root.AssemblyAngularVelocity = state.csyncAV or state.csyncLocalAV or root.AssemblyAngularVelocity
                            state.csyncWroteFake = true
                        else
                            state.csyncWroteFake = false
                        end
                    end)
                    runservice:BindToRenderStep("IDK_RagebotCsync", Enum.RenderPriority.Camera.Value - 1, function()
                        local root = getRoot(lplr.Character)
                        if not root or not state.csyncLocalCF then return end
                        local restored = false
                        if state.csyncWroteFake and restoreLocalRoot(root) then
                            state.csyncWroteFake = false
                            restored = true
                        end
                        if restored then
                            applyExternalMovementVelocity()
                        end
                    end)
                end

                local function stopCsync()
                    if state.csyncHbConn then state.csyncHbConn:Disconnect(); state.csyncHbConn = nil end
                    runservice:UnbindFromRenderStep("IDK_RagebotCsync")
                    restoreLocalRoot(getRoot(lplr.Character))
                    clearCsyncTarget()
                    state.csyncLocalCF = nil
                    state.csyncLocalLV = nil
                    state.csyncLocalAV = nil
                    state.csyncWroteFake = false
                end

                local function voidRand()
                    local n = math.random(-2147483646, 2147483646)
                    repeat
                        n = math.random(-2147483646, 2147483646)
                    until n < -1147483646 or n > 1147483646
                    return n
                end

                local function voidRandCF()
                    return CFrame.new(voidRand(), voidRand(), voidRand()) * CFrame.Angles(math.pi, math.pi, math.pi)
                end

                setVoidCsync = function(cf, lv, av)
                    state.csyncCF = cf
                    state.csyncLV = lv or Vector3.zero
                    state.csyncAV = av or Vector3.zero
                    state.lastFakePos = cf and cf.Position or nil
                end

                enterVoidState = function()
                    state.voidTargetCF = nil
                    state.voidExposed = false
                    state.orbitClientCF = nil

                    if not state.active or not cfg.on then
                        clearCsyncTarget()
                        updateRagebotStatus()
                        return
                    end

                    if cfg.voidSpam then
                        setVoidCsync(voidRandCF())
                    else
                        clearCsyncTarget()
                    end
                    updateRagebotStatus()
                end

                local function enableVoidCsync()
                    if state.voidHbConn then return end
                    startCsync()
                    state.voidHbConn = runservice.Heartbeat:Connect(function()
                        if isRagebotSettling() then
                            state.voidTargetCF = nil
                            state.voidExposed = false
                            clearCsyncTarget()
                            return
                        end
                        local targetCF = state.voidTargetCF
                        if targetCF then
                            setVoidCsync(targetCF, Vector3.zero, Vector3.zero)
                        elseif cfg.voidSpam then
                            setVoidCsync(voidRandCF())
                        else
                            clearCsyncTarget()
                        end
                    end)
                end

                local function disableVoidCsync()
                    if state.voidHbConn then state.voidHbConn:Disconnect(); state.voidHbConn = nil end
                    runservice:UnbindFromRenderStep("IDK_RagebotVoid")
                    state.voidTargetCF = nil
                    state.voidThread = nil
                    state.voidExposed = false
                end

                -- Orbit render-fix for Ragebot Orbit mode (client-side visual orbit while server is voided)
                local function StartOrbitRenderFix()
                    if state.orbitRenderRunning then return end
                    state.orbitRenderRunning = true
                    runservice:BindToRenderStep("IDK_RagebotOrbit", Enum.RenderPriority.First.Value, function()
                        if not state.orbitClientCF then return end
                        local root = getRoot(lplr.Character)
                        if not root then return end
                        root.CFrame = state.orbitClientCF
                        applyExternalMovementVelocity()
                    end)
                end

                local function StopOrbitRenderFix()
                    if not state.orbitRenderRunning then return end
                    runservice:UnbindFromRenderStep("IDK_RagebotOrbit")
                    state.orbitRenderRunning = false
                    state.orbitClientCF = nil
                end

                local function startVoidLoop(myGen)
                    if state.voidThread then return end
                    enableVoidCsync()
                    local voidThread
                    voidThread = task.spawn(function()
                        while state.active and cfg.on and rbGen == myGen and not state.suspended do
                            if isRagebotSettling() then
                                state.voidTargetCF = nil
                                state.voidExposed = false
                                clearCsyncTarget()
                                task.wait(0.03)
                                continue
                            end
                            if not inMatch() or not hasValidTarget() or isKatana(state.target) then
                                enterVoidState()
                                task.wait(0.1)
                                continue
                            end

                            enterVoidState()
                            if cfg.voidHideTime > 0 then task.wait(cfg.voidHideTime) end
                            if not state.active or not cfg.on or rbGen ~= myGen or state.suspended or not inMatch() then break end

                            local target = state.target
                            if hasValidTarget() and not isKatana(target) then
                                local tc = target.Character
                                local tr = getRoot(tc)
                                local head = tc and (tc:FindFirstChild("Head") or tr)
                                if tr and head then
                                    local shootPos = isRiotShield(target)
                                        and (tr.Position - tr.CFrame.LookVector * (cfg.behindDist or 4))
                                        or (tr.Position - tr.CFrame.LookVector * 2.5 + Vector3.new(0, 1.5, 0))
                                    if not isSafeRagebotPos(shootPos, target) then
                                        enterVoidState()
                                        task.wait(0.1)
                                        continue
                                    end
                                    local shootCF = CFrame.new(shootPos, head.Position)
                                    state.voidExposed = true
                                    state.voidTargetCF = shootCF
                                    setVoidCsync(shootCF, Vector3.zero, Vector3.zero)
                                    updateRagebotStatus()
                                    if cfg.voidShootTime > 0 then task.wait(cfg.voidShootTime) end
                                    if hasValidTarget() and not isKatana(target) then
                                        doFire(head)
                                    end
                                    task.wait(0.05)
                                    enterVoidState()
                                end
                            end
                        end

                        if state.voidThread == voidThread then
                            state.voidThread = nil
                        end
                        if rbGen == myGen and not state.suspended and state.voidThread == nil then
                            disableVoidCsync()
                        end
                    end)
                    state.voidThread = voidThread
                end

                local function enableNoclip()
                    if state.noclipConn then return end
                    state.noclipConn = runservice.Stepped:Connect(function()
                        local char = lplr.Character
                        if not char then return end
                        for _, part in char:GetDescendants() do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end)
                end

                local function startAmmoLoop()
                    if state.ammoThread then return end
                    state.ammoThread = task.spawn(function()
                        while state.active do
                            if isShootingRange() then
                                task.wait(0.1)
                                continue
                            end
                            if not handleAmmo() and shouldShoot() and not cfg.hyper then
                                local tc = state.target and state.target.Character
                                local head = tc and (tc:FindFirstChild("Head") or getRoot(tc))
                                if head then
                                    if cfg.shootDelay > 0 then task.wait(cfg.shootDelay) end
                                    doFire(head)
                                end
                            end
                            task.wait(math.max(0.01, cfg.acSpd))
                        end
                        state.ammoThread = nil
                    end)
                end

                local function stopRagebot()
                    rbGen += 1
                    state.active = false
                    cfg.on = false
                    setRagebotStatus(false)
                    if state.conn then state.conn:Disconnect(); state.conn = nil end
                    if state.noclipConn then state.noclipConn:Disconnect(); state.noclipConn = nil end
                    state.target = nil
                    state.voidExposed = false
                    state.nextTeleportAt = 0
                    state.ammoActionAt = 0
                    state.hideOrbitUntil = 0
                    state.randPos = nil
                    state.randT = 0
                    state.lastFakePos = nil
                    rbInMatchT = 0
                    rbInMatch = false
                    stopCsync()
                    disableVoidCsync()
                    StopOrbitRenderFix()
                    local char = lplr.Character
                    if char then
                        for _, part in char:GetDescendants() do
                            if part:IsA("BasePart") then
                                part.CanCollide = true
                            end
                        end
                    end
                end

                rbGen += 1
                local myGen = rbGen
                setRagebotStatus(true, nil, true)
                startAmmoLoop()
                installRagebotHook()
                if not state.suspended then
                    enableNoclip()
                    if cfg.mode == "Void" then
                        startVoidLoop(myGen)
                    elseif cfg.mode == "Orbit" then
                        -- Use Void csync as idle state; we'll expose an orbit CFrame while attacking
                        enableVoidCsync()
                    else
                        startCsync()
                    end
                end

                local aaPhase = 0
                local orbitAngle = math.random() * math.pi * 2

                state.conn = runservice.Stepped:Connect(function(_, dt)
                    if not state.active or not cfg.on then
                        if state.conn then state.conn:Disconnect(); state.conn = nil end
                        return
                    end

                    if isShootingRange() then
                        if not state.suspended then
                            state.suspended = true
                            state.target = nil
                            state.randPos = nil
                            state.voidTargetCF = nil
                            state.voidExposed = false
                            if state.noclipConn then
                                state.noclipConn:Disconnect()
                                state.noclipConn = nil
                            end
                            stopCsync()
                            disableVoidCsync()
                            StopOrbitRenderFix()
                            updateRagebotStatus()
                        end
                        return
                    end

                    if state.suspended then
                        state.suspended = false
                        enableNoclip()
                        if cfg.mode == "Void" then
                            startVoidLoop(myGen)
                        elseif cfg.mode == "Orbit" then
                            enableVoidCsync()
                            StartOrbitRenderFix()
                        else
                            startCsync()
                        end
                    end

                    local root = getRoot(lplr.Character)
                    if not root then return end

                    if isRagebotSettling() then
                        state.voidTargetCF = nil
                        state.voidExposed = false
                        state.orbitClientCF = nil
                        clearCsyncTarget()
                        updateRagebotStatus()
                        return
                    end

                    if not inMatch() then
                        clearCsyncTarget()
                        state.target = nil
                        if cfg.mode == "Orbit" then
                            enterVoidState()
                        else
                            updateRagebotStatus()
                        end
                        return
                    end

                    local now = tick()
                    if state.target and playerIsDead(state.target) then
                        state.target = nil
                    end

                    if state.target and isInvincible(state.target) then
                        clearCsyncTarget()
                        if cfg.mode == "Orbit" then
                            enterVoidState()
                        else
                            updateRagebotStatus()
                        end
                        return
                    end

                    if now - rbTgtT >= 0.05 and (cfg.autoSwitch or not state.target) then
                        rbTgtT = now
                        if cfg.autoSwitch then
                            local target = getBestTarget()
                            if target then
                                if cfg.sendNotification and state.target ~= target then
                                    mainapi:SafeNotify({
                                        Title = "ragebot",
                                        Text = "prioritized " .. target.Name,
                                        Duration = 2,
                                    })
                                end
                                state.target = target
                            end
                        elseif not state.target then
                            state.target = getBestTarget()
                        end
                    end

                    if not state.target then
                        clearCsyncTarget()
                        if cfg.mode == "Orbit" then
                            enterVoidState()
                        else
                            updateRagebotStatus()
                        end
                        return
                    end

                    local tc = state.target.Character
                    local tr = getRoot(tc)
                    local head = tc and (tc:FindFirstChild("Head") or tr)
                    if not tc or not tr or not head then
                        state.target = nil
                        updateRagebotStatus()
                        return
                    end

                    if isNearOtherMatch(tr.Position, state.target) then
                        state.target = nil
                        state.randPos = nil
                        if cfg.mode == "Orbit" or cfg.mode == "Void" then
                            enterVoidState()
                        else
                            clearCsyncTarget()
                            updateRagebotStatus()
                        end
                        return
                    end

                    updateRagebotStatus()

                    applyWeaponRageProfile()

                    if cfg.mode == "Void" then return end

                    if cfg.mode == "Orbit" and (now < (state.hideOrbitUntil or 0) or handleAmmo()) then
                        state.voidTargetCF = nil
                        state.voidExposed = false
                        state.orbitClientCF = nil
                        enterVoidState()
                        return
                    end

                    local isUnderground = cfg.mode == "Underground"
                    local isShield = isRiotShield(state.target)
                    local height = math.clamp(cfg.orbitHeight or 2, -2, 6)
                    local radius = math.clamp(cfg.orbitDist or 3, 1.25, 5)
                    local targetPos

                    if isShield then
                        targetPos = tr.Position - tr.CFrame.LookVector * (cfg.behindDist or 3)
                    elseif isUnderground then
                        targetPos = undergroundPos(head, tr)
                    elseif cfg.mode == "Teleport" then
                        if cfg.randomMovement then
                            if not state.randPos or (now - (state.randT or 0)) >= (cfg.randomRefresh or 0.08) then
                                state.randT = now
                                state.randPos = pickOffset(tr, head) + rndDir() * (math.random() * 1.05) + Vector3.new(0, rnd() * 0.7, 0)
                            end
                            targetPos = state.randPos
                        else
                            targetPos = pickOffset(tr, head)
                        end
                    elseif cfg.mode == "Orbit" then
                        orbitAngle += dt * math.max(1, (cfg.strafeSpeed or 5) * 1.5)
                        targetPos = head.Position + Vector3.new(math.cos(orbitAngle) * radius, height, math.sin(orbitAngle) * radius)
                    else
                        targetPos = undergroundPos(head, tr)
                    end

                    if not isSafeRagebotPos(targetPos, state.target) then
                        state.randPos = nil
                        if cfg.mode == "Orbit" then
                            state.voidTargetCF = nil
                            state.voidExposed = false
                            state.orbitClientCF = nil
                            enterVoidState()
                        else
                            clearCsyncTarget()
                            updateRagebotStatus()
                        end
                        return
                    end

                    local faceCF = CFrame.new(targetPos, head.Position)
                    if cfg.antiAim then
                        aaPhase += dt * 20
                        faceCF = CFrame.new(targetPos, head.Position) * CFrame.Angles(0, math.rad(math.sin(aaPhase) * 70), 0)
                    end

                    if cfg.mode == "Orbit" then
                        if cfg.hyper or not isUnderground then
                            -- expose orbit position to server each frame while combatting
                            state.voidExposed = true
                            state.voidTargetCF = faceCF
                            setCsync(faceCF, targetPos, dt)
                            updateRagebotStatus()

                            if shouldShoot() then
                                doFire(head)
                            end
                        end
                    else
                        setCsync(faceCF, targetPos, dt)

                        if cfg.hyper or (cfg.mode == "Orbit" and not isUnderground) then
                            if shouldShoot() then doFire(head) end
                        elseif cfg.mode == "Teleport" and not isUnderground then
                            if now >= (state.nextTeleportAt or 0) then
                                state.nextTeleportAt = now + math.max(0.01, cfg.teleportDelay or 0.04)
                                if shouldShoot() then doFire(head) end
                            end
                        end
                    end
                end)

                Ragebot:Clean(lplr.CharacterAdded:Connect(function()
                    stopCsync()
                    disableVoidCsync()
                    StopOrbitRenderFix()
                    state.target = nil
                    clearCsyncTarget()
                    state.csyncLocalCF = nil
                    state.csyncLocalLV = nil
                    state.csyncLocalAV = nil
                    state.csyncWroteFake = false
                    state.voidExposed = false
                    state.hideOrbitUntil = 0
                    if state.active then
                        task.wait(0.5)
                        if state.active then
                            if cfg.mode == "Void" then
                                startVoidLoop(myGen)
                            elseif cfg.mode == "Orbit" then
                                enableVoidCsync()
                                StartOrbitRenderFix()
                            else
                                startCsync()
                            end
                        end
                    end
                end))

                getgenv().__IDKRagebotStop = stopRagebot
                Ragebot:Clean(stopRagebot)
            else
                cfg.on = false
                if getgenv().__IDKRagebotStop then
                    pcall(getgenv().__IDKRagebotStop)
                    getgenv().__IDKRagebotStop = nil
                end
            end
        end
    })

    Ragebot:AddToggle({
        Name = 'void spam',
        Default = true,
        Function = function(callback)
            RagebotSettings.voidSpam = callback
            markRagebotSettingsDirty()
        end
    })

    local RagebotHide = Ragebot:AddSlider({
        Name = 'hide',
        Min = 0,
        Max = 1,
        Default = 0.25,
        Decimal = 100,
        Suffix = 's',
        Compact = true,
        Function = function(value)
            RagebotSettings.voidHideTime = value
            markRagebotSettingsDirty()
        end
    })

    Ragebot:AddSlider({
        Name = 'attack',
        Min = 0,
        Max = 1,
        Default = 0.03,
        Decimal = 100,
        Suffix = 's',
        Compact = true,
        Parent = RagebotHide,
        Function = function(value)
            RagebotSettings.voidShootTime = value
            markRagebotSettingsDirty()
        end
    })

    Ragebot:AddSlider({
        Name = 'shoot attempts',
        Min = 1,
        Max = 10,
        Default = 1,
        Suffix = 'x',
        Function = function(value)
            RagebotSettings.shootAttempts = math.floor(value)
            markRagebotSettingsDirty()
        end
    })

    Ragebot:AddDropdown({
        Name = 'attack mode',
        List = {'gun', 'knife', 'melee'},
        Default = 'gun',
        Function = function(value)
            RagebotSettings.attackMode = value
            markRagebotSettingsDirty()
        end
    })

    Ragebot:AddDropdown({
        Name = 'preferred weapon',
        List = {'primary', 'secondary', 'melee'},
        Default = 'primary',
        Function = function(value)
            RagebotSettings.preferredWeapon = value
            if value == 'primary' then
                RagebotSettings.primarySlot = 1
                RagebotSettings.secondarySlot = 2
            elseif value == 'secondary' then
                RagebotSettings.primarySlot = 2
                RagebotSettings.secondarySlot = 1
            else
                RagebotSettings.primarySlot = 1
                RagebotSettings.secondarySlot = 2
            end
            markRagebotSettingsDirty()
            -- 선택 즉시 해당 무기 자동 장착
            pcall(function()
                local keys = {[1]=Enum.KeyCode.One,[2]=Enum.KeyCode.Two,[3]=Enum.KeyCode.Three}
                local slot = (value == 'primary' and 1) or (value == 'secondary' and 2) or 3
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, keys[slot], false, game)
                task.wait()
                vim:SendKeyEvent(false, keys[slot], false, game)
            end)
        end
    })

    Ragebot:AddToggle({
        Name = 'weapon specialize',
        Default = true,
        Function = function(callback)
            RagebotSettings.weaponSpecialize = callback
            markRagebotSettingsDirty()
        end
    })

    Ragebot:AddDropdown({
        Name = 'settings',
        List = {'swap weapons when empty', 'prefer projectile weapon'},
        Default = {['swap weapons when empty'] = true},
        Multi = true,
        Function = function(value)
            RagebotSettings.autoSwapSecondary = value['swap weapons when empty'] == true
            RagebotSettings.autoReloadPrimary = value['swap weapons when empty'] == true
            RagebotSettings.preferProjectile = value['prefer projectile weapon'] == true
            markRagebotSettingsDirty()
        end
    })

    Ragebot:AddToggle({
        Name = 'auto prioritize',
        Tab = 'priority',
        Default = true,
        Function = function(callback)
            RagebotSettings.autoPriority = callback
            RagebotSettings.autoSwitch = callback
            markRagebotSettingsDirty()
        end
    })

    Ragebot:AddToggle({
        Name = 'send notification',
        Tab = 'priority',
        Function = function(callback)
            RagebotSettings.sendNotification = callback
            markRagebotSettingsDirty()
        end
    })

    Ragebot:AddDropdown({
        Name = 'auto priority settings',
        Tab = 'priority',
        List = {'attackers', 'voided players'},
        Default = {attackers = true, ['voided players'] = true},
        Multi = true,
        Function = function(value)
            RagebotSettings.priorityAttackers = value.attackers == true
            RagebotSettings.priorityVoided = value['voided players'] == true
            markRagebotSettingsDirty()
        end
    })

    local function getPlayerNames()
        local names = {}
        for _, player in game:GetService('Players'):GetPlayers() do
            if player ~= game:GetService('Players').LocalPlayer then
                table.insert(names, player.Name)
            end
        end
        table.sort(names)
        return names
    end

    local Prioritized = Ragebot:AddDropdown({
        Name = 'prioritized',
        Tab = 'priority',
        List = getPlayerNames(),
        AllowNull = true,
        Function = function(value)
            RagebotSettings.prioritizedPlayer = value
            markRagebotSettingsDirty()
        end
    })

    local function refreshPriorityPlayers()
        Prioritized:SetList(getPlayerNames())
    end
    Ragebot:Clean(game:GetService('Players').PlayerAdded:Connect(refreshPriorityPlayers))
    Ragebot:Clean(game:GetService('Players').PlayerRemoving:Connect(refreshPriorityPlayers))
end)
run(function()
    local Desync
    local PitchMode
    local YawMode
    local Underground
    local AntiAimCameraTask

    local function getAntiAimCameraRotation(cameraController)
        local currentRotation = cameraController.Rotation or Vector2.zero
        local pitch = currentRotation.X or 0
        local yaw = currentRotation.Y or 0
        local cfg = _G.AntiAimPoseConfig or {}
        local pitchMode = cfg.pitch or (PitchMode and PitchMode.Value) or "disabled"
        local yawMode = cfg.yaw or (YawMode and YawMode.Value) or "disabled"

        if pitchMode == "up" then
            pitch = math.rad(-89)
        elseif pitchMode == "down" then
            pitch = math.rad(179)
        elseif pitchMode == "zero" then
            pitch = 0
        elseif pitchMode == "random" then
            pitch = math.rad(math.random(-89, 179))
        end

        if yawMode == "backwards" then
            yaw += math.rad(180)
        elseif yawMode == "spin" then
            yaw = math.rad((tick() * 720) % 360)
        elseif yawMode == "random" then
            yaw = math.rad(math.random(0, 359))
        end

        return Vector2.new(pitch, yaw)
    end

    local function stopAntiAimCamera()
        if AntiAimCameraTask then
            pcall(task.cancel, AntiAimCameraTask)
            AntiAimCameraTask = nil
        end
    end

    local function startAntiAimCamera()
        stopAntiAimCamera()

        local okUtility, utility = pcall(function()
            return require(ReplicatedStorage.Modules.Utility)
        end)
        if not okUtility or not utility then return end

        local okCamera, cameraController = pcall(function()
            return require(LocalPlayer.PlayerScripts.Controllers.CameraController)
        end)
        if not okCamera or not cameraController then return end

        local updateCameraRotation = ReplicatedStorage:FindFirstChild("Remotes")
            and ReplicatedStorage.Remotes:FindFirstChild("Replication")
            and ReplicatedStorage.Remotes.Replication:FindFirstChild("Fighter")
            and ReplicatedStorage.Remotes.Replication.Fighter:FindFirstChild("UpdateCameraRotation")
        if not updateCameraRotation then return end

        AntiAimCameraTask = task.spawn(function()
            while _G.AntiAimPoseConfig and _G.AntiAimPoseConfig.enabled do
                local cfg = _G.AntiAimPoseConfig or {}
                local randomBurst = cfg.yaw == "random" and 3 or 1

                for _ = 1, randomBurst do
                    local cameraRotation = getAntiAimCameraRotation(cameraController)
                    updateCameraRotation:FireServer(utility:EncodeCameraRotation(cameraRotation), nil)
                end

                RunService.Heartbeat:Wait()
            end
        end)
    end

    local function stopAntiAim()
        stopAntiAimCamera()
    end

    local function startAntiAim()
        startAntiAimCamera()
    end

    Desync = Movement:AddModule({
        Name = 'Anti Aim',
        Function = function(callback)
            if callback then
                _G.AntiAimPoseConfig = {
                    enabled = true,
                    pitch = PitchMode and PitchMode.Value or "disabled",
                    yaw = YawMode and YawMode.Value or "disabled",
                    underground = Underground and Underground.Enabled or false
                }

                startAntiAim()
                Desync:Clean(LocalPlayer.CharacterAdded:Connect(function()
                    task.wait(0.4)
                    if _G.AntiAimPoseConfig then
                        startAntiAim()
                    end
                end))

                if false then

                _G.DesyncConfig = {
                    enabled = true,
                    range = 15,
                    up = 100,
                    useDesync = true,
                    pitch = PitchMode and PitchMode.Value or "disabled",
                    yaw = YawMode and YawMode.Value or "disabled",
                    underground = Underground and Underground.Enabled or false
                }

                _G.DesyncCframes = {}
                _G.DesyncRenderRunning = false

                -------------------------------------------------
                -- UTIL
                -------------------------------------------------

                local function GetRoot(char)
                    if char then
                        return char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
                    end
                end

                local function WaitForRoot(char)
                    local root
                    repeat
                        root = GetRoot(char)
                        task.wait()
                    until root
                    return root
                end

                -------------------------------------------------
                -- RENDER FIX (????????? 늉?????????
                -------------------------------------------------

                _G.StartDesyncRenderFix = function()
                    RunService:UnbindFromRenderStep("DesyncFix")

                    _G.DesyncRenderRunning = true

                    RunService:BindToRenderStep(
                        "DesyncFix",
                        Enum.RenderPriority.First.Value,
                        function()
                            if not _G.DesyncConfig.enabled then return end

                            local char = LocalPlayer.Character
                            local root = char and GetRoot(char)

                            if root and _G.DesyncCframes.client then
                                root.CFrame = _G.DesyncCframes.client
                            end
                        end
                    )
                end

                _G.StopDesyncRenderFix = function()
                    RunService:UnbindFromRenderStep("DesyncFix")
                    _G.DesyncRenderRunning = false
                end

                -------------------------------------------------
                -- MAIN LOOP (?????????? 뮛?筌 ? ??  ?袁⑦????????
                -------------------------------------------------

                Desync:Clean(RunService.Heartbeat:Connect(function()
                    if not _G.DesyncConfig.enabled then return end

                    local char = LocalPlayer.Character
                    local root = char and GetRoot(char)

                    if not root then return end

                    -- ???????client ????(??? ????? 땟??貫沅?)
                    _G.DesyncCframes.client = root.CFrame

                    local x = math.random(-_G.DesyncConfig.range, _G.DesyncConfig.range)
                    local z = math.random(-_G.DesyncConfig.range, _G.DesyncConfig.range)
                    local up = _G.DesyncConfig.underground and -math.abs(_G.DesyncConfig.up or 100) or math.abs(_G.DesyncConfig.up or 100)
                    local y = _G.DesyncConfig.underground and math.random(up, 0) or math.random(0, up)

                    local pos = root.Position + Vector3.new(x, y, z)

                    local pitch = _G.DesyncConfig.pitch or "disabled"
                    local yaw = _G.DesyncConfig.yaw or "disabled"
                    local rx = 0
                    local ry = 0
                    local rz = 0

                    if pitch == "up" then
                        rx = math.rad(-89)
                    elseif pitch == "down" then
                        rx = math.rad(89)
                    elseif pitch == "zero" then
                        rx = 0
                    elseif pitch == "random" then
                        rx = math.rad(math.random(-89, 89))
                    end

                    if yaw == "backwards" then
                        ry = math.rad(180)
                    elseif yaw == "spin" then
                        ry = math.rad((tick() * 720) % 360)
                    elseif yaw == "random" then
                        ry = math.rad(math.random(-180, 180))
                    end

                    local fakeCF = CFrame.new(pos) * CFrame.Angles(rx, ry, rz)

                    root.CFrame = fakeCF
                end))

                -------------------------------------------------
                -- CHARACTER (????????諛몃 ?????? 싲 ?  ????
                -------------------------------------------------

                local function OnCharacter(char)
                    -- ???HRP ?????諛몃 ???????????? ??????源녾?? ????????汝뷴?????
                    local root = WaitForRoot(char)

                    -- ???render ???嶺뚮Ĳ??????????????? 퓢?????꿔꺂???影??  ?
                    task.wait(0.2)
                    _G.StartDesyncRenderFix()

                    -- ????????? 름????? 챷????????????? 뮛?筌 ? ??  ?袁⑦????
                    Desync:Clean(char:WaitForChild("Humanoid").Died:Connect(function()
                        task.wait(1)
                        if _G.DesyncConfig.enabled then
                            _G.StartDesyncRenderFix()
                        end
                    end))
                end

                if LocalPlayer.Character then
                    task.spawn(function()
                        OnCharacter(LocalPlayer.Character)
                    end)
                end

                Desync:Clean(LocalPlayer.CharacterAdded:Connect(function(char)
                    task.spawn(function()
                        OnCharacter(char)
                    end)
                end))

                end
            else
                stopAntiAim()
                _G.AntiAimPoseConfig = nil
                if false then
                
                if _G.DesyncConfig then
                    _G.DesyncConfig.enabled = false
                end
                if _G.StopDesyncRenderFix then
                    _G.StopDesyncRenderFix()
                end
                end
            end
        end
    })

    PitchMode = Desync:AddDropdown({
        Name = "pitch",
        List = {"disabled", "up", "down", "zero", "random"},
        Default = "disabled",
        Function = function(val)
            if _G.AntiAimPoseConfig then
                _G.AntiAimPoseConfig.pitch = val
            end
        end
    })
    YawMode = Desync:AddDropdown({
        Name = "yaw",
        List = {"disabled", "backwards", "spin", "random"},
        Default = "disabled",
        Function = function(val)
            if _G.AntiAimPoseConfig then
                _G.AntiAimPoseConfig.yaw = val
            end
        end
    })
    Underground = Desync:AddToggle({
        Name = "underground",
        Function = function(val)
            if _G.AntiAimPoseConfig then
                _G.AntiAimPoseConfig.underground = val
            end
        end
    })

end)

run(function()

    local Freecam
    local Speed
    local module
    local old
    local randomkey = HttpService:GenerateGUID(false)

    local gameCamera = workspace.CurrentCamera
    local ContextService = game:GetService("ContextActionService")
    local UserInputService = game:GetService("UserInputService")
    local freecamPosition

    local function getCameraController()
        local ok, controller = pcall(function()
            return require(LocalPlayer.PlayerScripts.Controllers.CameraController)
        end)
        return ok and controller or nil
    end

    local function applyFreecamSpeed()
        local controller = getCameraController()
        if not controller then return end
        local cameraState = controller.CameraState
        local value = Speed and Speed.Value or 50
        for _, target in ipairs({
            controller,
            cameraState,
            cameraState and cameraState.CustomFreecam,
            cameraState and cameraState._custom_freecam,
            cameraState and cameraState._customFreecam,
        }) do
            if type(target) == "table" then
                for _, key in ipairs({
                    "Speed", "MoveSpeed", "MovementSpeed", "FreecamSpeed",
                    "CustomFreecamSpeed", "_speed", "_moveSpeed",
                    "_freecamSpeed", "_freecam_speed", "_customFreecamSpeed"
                }) do
                    pcall(function()
                        target[key] = value
                    end)
                end
                for _, method in ipairs({"SetSpeed", "SetMoveSpeed", "SetFreecamSpeed", "SetCustomFreecamSpeed"}) do
                    if type(target[method]) == "function" then
                        pcall(target[method], target, value)
                    end
                end
            end
        end
    end

    local function isFreecamKeyDown(...)
        for _, key in ipairs({...}) do
            if UserInputService:IsKeyDown(key) then
                return true
            end
        end
        return false
    end

    local function getFreecamMoveVector()
        local x, y, z = 0, 0, 0
        if isFreecamKeyDown(Enum.KeyCode.D, Enum.KeyCode.K) then x += 1 end
        if isFreecamKeyDown(Enum.KeyCode.A, Enum.KeyCode.H) then x -= 1 end
        if isFreecamKeyDown(Enum.KeyCode.E, Enum.KeyCode.I) then y += 1 end
        if isFreecamKeyDown(Enum.KeyCode.Q, Enum.KeyCode.Y) then y -= 1 end
        if isFreecamKeyDown(Enum.KeyCode.S, Enum.KeyCode.J) then z += 1 end
        if isFreecamKeyDown(Enum.KeyCode.W, Enum.KeyCode.U) then z -= 1 end
        local move = Vector3.new(x, y, z)
        return move.Magnitude > 1 and move.Unit or move
    end

    local function updateFreecamPosition(dt)
        local camera = workspace.CurrentCamera
        if not camera then return end
        local cf = camera.CFrame
        freecamPosition = freecamPosition or cf.Position
        local rotation = cf - cf.Position
        local move = getFreecamMoveVector()
        if move.Magnitude > 0 then
            local speed = Speed and Speed.Value or 50
            if isFreecamKeyDown(Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift) then
                speed *= 0.25
            end
            freecamPosition += rotation:VectorToWorldSpace(move) * speed * math.clamp(dt or 0, 0, 1 / 15)
        end
        camera.CFrame = CFrame.new(freecamPosition) * rotation
        camera.Focus = camera.CFrame * CFrame.new(0, 0, -100)
    end

    Freecam = Render:AddModule({
        Name = "Freecam",

        Function = function(callback)
            local controller = getCameraController()
            local cameraState = controller and controller.CameraState
            if callback then
                if cameraState and cameraState.SetCustomFreecamEnabled then
                    cameraState:SetCustomFreecamEnabled(true)
                end
                freecamPosition = workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position or nil
                applyFreecamSpeed()
                RunService:BindToRenderStep(randomkey, Enum.RenderPriority.Camera.Value + 1, updateFreecamPosition)
                Freecam:Clean({ Disconnect = function()
                    RunService:UnbindFromRenderStep(randomkey)
                end })
                local nextApply = 0
                Freecam:Clean(RunService.Heartbeat:Connect(function()
                    local now = os.clock()
                    if now >= nextApply then
                        nextApply = now + 0.25
                        applyFreecamSpeed()
                    end
                end))
            else
                if cameraState and cameraState.SetCustomFreecamEnabled then
                    cameraState:SetCustomFreecamEnabled(false)
                end
                freecamPosition = nil
            end
        end
    })


    -------------------------------------------------
    -- SPEED
    -------------------------------------------------

    Speed = Freecam:AddSlider({
        Name = "Speed",
        Min = 1,
        Max = 150,
        Default = 50,
        Function = function()
            if Freecam.Enabled then
                applyFreecamSpeed()
            end
        end,

        Suffix = function(val)
            return val == 1 and "stud" or "studs"
        end
    })

end)

run(function()
	local Timer
	local Value
	
	Timer = Player:AddModule({
		Name = 'Timer',
		Function = function(callback)
			if callback then
				setfflag('SimEnableStepPhysics', 'True')
				setfflag('SimEnableStepPhysicsSelective', 'True')
				Timer:Clean(RunService.RenderStepped:Connect(function(dt)
					if Value.Value > 1 then
						RunService:Pause()
						workspace:StepPhysics(dt * (Value.Value - 1), { rootPart })
						RunService:Run()
					end
				end))
			end
		end
	})
	Value = Timer:AddSlider({
		Name = 'Value',
		Min = 1,
		Max = 3,
		Decimal = 10
	})
end)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local GroupService = game:GetService("GroupService")
local MarketplaceService = game:GetService("MarketplaceService")

local visited, attempted, tpSwitch = {}, {}, false
local cacheExpire, cache = 0, nil

-- ??類ㅼ ??筌뤿굝由??? ??
local function serverHop(pointer, filter)
    visited = shared.Modernserverhoplist and shared.Modernserverhoplist:split('/') or {}
    
    if not table.find(visited, game.JobId) then
        table.insert(visited, game.JobId)
    end
    
    if not pointer then
        warn('??類ㅼ ??嶺뚢??  ?? ?..')
    end

    local success, httpdata = pcall(function()
        if cacheExpire > tick() and cache then
            return cache
        end
        
        local sortOrder = (filter == 'Ascending' and 1 or 2)
        local url = string.format(
            'https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%d&excludeFullGames=true&limit=100%s',
            game.PlaceId,
            sortOrder,
            pointer and ('&cursor=' .. pointer) or ''
        )
        return game:HttpGet(url)
    end)
    
    if not success then
        warn('??類ㅼ ?嶺뚮? 維뽨빳???? 럾??筌뤾? 沅??븐뼔?????? 넮??? ????? 펲.')
        return
    end
    
    local data = HttpService:JSONDecode(httpdata)
    
    if data and data.data then
        for _, server in ipairs(data.data) do
            local isNotFull = tonumber(server.playing) < tonumber(server.maxPlayers or Players.MaxPlayers)
            local notVisited = not table.find(visited, server.id)
            local notAttempted = not table.find(attempted, server.id)
            
            if isNotFull and notVisited and notAttempted then
                cacheExpire = tick() + 60
                cache = httpdata
                table.insert(attempted, server.id)
                
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                return
            end
        end

        if data.nextPageCursor then
            serverHop(data.nextPageCursor, filter)
        else
            warn('?????? 럾??繞③????類ㅼ ??嶺뚢??  ??????? 룸????? 펲.')
        end
    else
        warn('?? ? ????類ㅼ ???? ????? ?????? 펲.')
    end
end

-- 嶺뚮???????? 뺄
run(function()
    local Module
    local Mode

    local function startStaffDetector()
        xpcall(function()
            if (game.GameId ~= 6035872082) then return end
            if shared.StaffDetectorLoading then return end
            shared.StaffDetectorLoading = true
            repeat task.wait() until game:IsLoaded()

            local cloneref = cloneref or function(obj)
                return obj
            end

            local players = cloneref(game:GetService("Players"))
            local http = game:GetService("HttpService")
            local groupId = game.CreatorId
            local cacheFile = "AntiLua/staffcache_" .. groupId .. ".json"

            if game.CreatorType ~= Enum.CreatorType.Group then
                return
            end

            local function notify(text, duration)
                mainapi:Notify({
                    Title = "StaffDetector",
                    Text = text,
                    Duration = duration
                })
            end

            local function fetchURL(url)
                local ok, res = pcall(game.HttpGet, game, url)
                if ok then
                    local decoded, data = pcall(function()
                        return http:JSONDecode(res)
                    end)
                    if decoded then
                        return data
                    end
                end
                return nil
            end

            local function loadCachedStaffIds()
                local cached = {}
                pcall(function()
                    if isfile(cacheFile) then
                        local data = http:JSONDecode(readfile(cacheFile))
                        if type(data) == "table" then
                            for _, uid in ipairs(data) do
                                cached[uid] = true
                            end
                        end
                    end
                end)
                return cached
            end

            local function saveCachedStaffIds(ids)
                pcall(function()
                    local list = {}
                    for uid in pairs(ids) do
                        table.insert(list, uid)
                    end
                    writefile(cacheFile, http:JSONEncode(list))
                end)
            end

            local function extractStaffRoleIds(groupId)
                local url = ("https://groups.roblox.com/v1/groups/%d/roles"):format(groupId)
                local data = fetchURL(url)
                local roleIds = {}

                if data and data.roles then
                    for _, r in ipairs(data.roles) do
                        local name = string.lower(r.name)
                        if string.find(name, "mod") or string.find(name, "staff") or string.find(name, "contributor")
                            or string.find(name, "script") or string.find(name, "build") then
                            table.insert(roleIds, r.id)
                        end
                    end
                end

                return roleIds
            end

            local function fetchUsersInRole(groupId, roleId)
                local cursor = ""
                local collected = {}

                while true do
                    local url = string.format("https://groups.roproxy.com/v1/groups/%d/roles/%d/users?limit=100&cursor=%s", groupId, roleId, cursor)
                    local success, response = pcall(function()
                        return game:HttpGet(url)
                    end)

                    if not success or not response then break end

                    local decoded, json = pcall(function()
                        return http:JSONDecode(response)
                    end)
                    if not decoded or not json then break end

                    if json.data and type(json.data) == "table" then
                        for _, user in ipairs(json.data) do
                            if user.userId then
                                collected[user.userId] = true
                            end
                        end
                    end

                    if not json.nextPageCursor or json.nextPageCursor == "" then break end
                    cursor = json.nextPageCursor
                end

                return collected
            end

            local staffRoleIds = extractStaffRoleIds(groupId)
            local staffUserIds = loadCachedStaffIds()

            local function getRole(plr, groupId)
                if plr and typeof(plr) == "Instance" then
                    local method = plr.GetRoleInGroup
                    if typeof(method) == "function" then
                        return method(plr, groupId)
                    end
                end
                return nil
            end

            local function isStaffRoleName(role)
                if role and typeof(role) == "string" then
                    local r = string.lower(role)
                    if string.find(r, "mod") or string.find(r, "staff") or string.find(r, "contributor") or string.find(r, "script") or string.find(r, "build") then
                        return true
                    end
                end
                return false
            end

            local function getStaffInfo()
                local staffNames = {}
                for _, plr in ipairs(players:GetPlayers()) do
                    local role = getRole(plr, game.CreatorId)
                    if isStaffRoleName(role) then
                        table.insert(staffNames, plr.Name)
                    end
                end
                return staffNames
            end

            local function getFriendStaffInfo()
                local list = {}
                for _, plr in ipairs(players:GetPlayers()) do
                    local ok, pages = pcall(function()
                        return players:GetFriendsAsync(plr.UserId)
                    end)
                    if ok and pages then
                        while true do
                            local page = pages:GetCurrentPage()
                            for _, friend in ipairs(page) do
                                if staffUserIds[friend.Id] then
                                    table.insert(list, friend.Username)
                                end
                            end
                            if pages.IsFinished then break end
                            pages:AdvanceToNextPageAsync()
                        end
                    end
                end
                return list
            end

            local function runDetection()
                local staffNames = getStaffInfo()
                local friendStaffNames = getFriendStaffInfo()
                local hasDetected = (#staffNames > 0 or #friendStaffNames > 0)

                if not hasDetected then
                    return false
                end

                if Mode.Value == "ServerHop" then
                    notify("Staff is Detected in this server Server hopping", 10)
                    serverHop(nil, "Descending")
                elseif Mode.Value == "Uninject" then
                    notify("Staff Detected in this game uninjecting", 5)
                    mainapi:Uninject()
                else
                    notify("Staff Detected in this game", 10)
                end

                return true
            end

            runDetection()

            task.spawn(function()
                for _, roleId in ipairs(staffRoleIds) do
                    local users = fetchUsersInRole(groupId, roleId)
                    for uid in pairs(users) do
                        staffUserIds[uid] = true
                    end
                end
                saveCachedStaffIds(staffUserIds)
                runDetection()
            end)

            Module:Clean(players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Wait()
                local role = getRole(plr, game.CreatorId)
                if isStaffRoleName(role) then
                    runDetection()
                end
            end))
        end, function() end)
    end

    Module = Player:AddModule({
        Name = "StaffDetector",
        Function = function(callback)
            if callback then
                startStaffDetector()
            end
        end
    })

    Mode = Module:AddDropdown({
        Name = "Mode",
        List = {"Uninject", "ServerHop", "Notify"},
        Value = "Notify"
    })
end)

run(function()
    local hooksInstalled = false
    local oldPart
    local oldTagged

    local function installAntiOOBHooks()
        if hooksInstalled then return end
        
        task.spawn(function()
            local Modules = ReplicatedStorage:WaitForChild("Modules", 5)
            if not Modules then return end
            
            local UtilityMod = Modules:WaitForChild("Utility", 5)
            if not UtilityMod then return end
            
            local Utility = require(UtilityMod)

            oldPart = hookfunction(Utility.IsWithinPart, newcclosure(function(...)
                local isEnabled = shared.RagebotActive
                if not isEnabled then
                    return oldPart(...)
                end

                local args = {...}
                for _, v in ipairs(args) do
                    if typeof(v) == "Instance" and v:IsA("BasePart") then
                        local name = string.lower(v.Name)
                        if string.find(name, "map") or string.find(name, "bound") or string.find(name, "safe") then
                            return true
                        end
                    end
                end

                return false
            end))

            oldTagged = hookfunction(Utility.IsWithinTaggedParts, newcclosure(function(self, tag, pos, size, returnAll)
                local isEnabled = shared.RagebotActive
                if not isEnabled then
                    return oldTagged(self, tag, pos, size, returnAll)
                end

                if type(tag) == "string" then
                    local lowerTag = string.lower(tag)
                    if string.find(lowerTag, "map") or string.find(lowerTag, "bound") or string.find(lowerTag, "safe") then
                        if returnAll then
                            return { workspace.Terrain }
                        else
                            return workspace.Terrain
                        end
                    end
                end

                if returnAll then
                    return {}
                else
                    return nil
                end
            end))
            
            hooksInstalled = true
        end)
    end

    installAntiOOBHooks()
end)

run(function()
    local SoundService = cloneref(game:GetService("SoundService"))
    local WorldVisualState = {
        Effects = {},
        Originals = {},
        WeatherPart = nil,
        WeatherEmitter = nil,
        WeatherEmitters = {},
        WeatherLightning = nil,
        AmbienceSound = nil,
        CameraConn = nil,
        OriginalFOV = nil,
        OriginalViewport = nil,
        AspectFrame = nil,
        OriginalSkyboxes = {},
        AntiFlashInstalled = false,
        OriginalFlashFunction = nil,
        AntiSmokeInstalled = false,
        OriginalSmokeScreenUpdate = nil,
        OriginalSmokeCloudUpdate = nil,
    }

    local function getEffect(className, name)
        local effect = WorldVisualState.Effects[name]
        if effect then return effect end

        effect = Lighting:FindFirstChild(name)
        if not effect or not effect:IsA(className) then
            effect = Instance.new(className)
            effect.Name = name
        end
        WorldVisualState.Effects[name] = effect
        return effect
    end

    local function saveProperty(obj, prop)
        if not obj then return end
        WorldVisualState.Originals[obj] = WorldVisualState.Originals[obj] or {}
        if WorldVisualState.Originals[obj][prop] == nil then
            local ok, value = pcall(function()
                return obj[prop]
            end)
            if ok then
                WorldVisualState.Originals[obj][prop] = value
            end
        end
    end

    local function setProperty(obj, prop, value)
        saveProperty(obj, prop)
        pcall(function()
            obj[prop] = value
        end)
    end

    local function restoreProperty(obj, prop)
        if not obj then return end
        local saved = WorldVisualState.Originals[obj] and WorldVisualState.Originals[obj][prop]
        if saved ~= nil then
            pcall(function()
                obj[prop] = saved
            end)
            WorldVisualState.Originals[obj][prop] = nil
        end
    end

    local Skyboxes = {
        ["Afternoon"] = {600830446, 600831635, 600832720, 600886090, 600833862, 600835177},
        ["Blue Space"] = {149397692, 149397686, 149397697, 149397684, 149397688, 149397702},
        ["Classic Roblox"] = {1012890, 1012891, 1012887, 1012889, 1012888, 1014449},
        ["Cloudy"] = {591058823, 591059876, 591058104, 591057861, 591057625, 591059642},
        ["Dusk"] = {264908339, 264907909, 264909420, 264909758, 264908886, 264907379},
        ["Dawn"] = {1417494030, 1417494146, 1417494253, 1417494402, 1417494499, 1417494643},
        ["Dark Skies"] = {570557514, 570557775, 570557559, 570557620, 570557672, 570557727},
        ["Earth"] = {6444884337, 6444884785, 6444884337, 6444884785, 6444884337, 6444884785},
        ["Horizontal Milky Way"] = {159454299, 159454296, 159454293, 159454286, 159454300, 159454288},
        ["Heaven"] = {591058823, 591059642, 591059876, 591057625, 591057861, 591058104},
        ["Jungle"] = {214253616, 214253616, 214253616, 214253616, 214253616, 214253616},
        ["Mountains"] = {452457785, 452457806, 452457839, 452457866, 452457896, 452457928},
        ["Nebula"] = {149397697, 149397702, 149397692, 149397688, 149397684, 149397686},
        ["Night Light"] = {12064107, 12064152, 12064121, 12063984, 12064115, 12064131},
        ["Night"] = {12064121, 12064152, 12064107, 12064115, 12063984, 12064131},
        ["Ocean Sky"] = {150335574, 150335585, 150335628, 150335620, 150335610, 150335642},
        ["Redshift"] = {401664839, 401664862, 401664960, 401664881, 401664901, 401664936},
        ["Space"] = {149397684, 149397686, 149397688, 149397692, 149397697, 149397702},
        ["Sunset"] = {264909420, 264907909, 264908339, 264908886, 264909758, 264907379},
        ["Storm"] = {570557514, 570557775, 570557559, 570557620, 570557672, 570557727},
        ["SFOTH"] = {1012887, 1012891, 1012890, 1012888, 1012889, 1014449},
        ["Solid Black"] = {0, 0, 0, 0, 0, 0},
        ["Saturn"] = {149397688, 149397686, 149397684, 149397692, 149397702, 149397697},
        ["Smoke"] = {570557672, 570557514, 570557727, 570557559, 570557775, 570557620},
        ["Vertical Milky Way"] = {159454286, 159454288, 159454299, 159454300, 159454296, 159454293},
        ["White"] = {0, 0, 0, 0, 0, 0},
    }

    local SkyboxSettings = {
        ["Afternoon"] = {StarCount = 1200, SunAngularSize = 18, MoonAngularSize = 11, ClockTime = 14, Ambient = Color3.fromRGB(150, 150, 150), FogColor = Color3.fromRGB(210, 220, 235)},
        ["Blue Space"] = {StarCount = 4500, SunAngularSize = 4, MoonAngularSize = 6, ClockTime = 0, Ambient = Color3.fromRGB(65, 80, 125), FogColor = Color3.fromRGB(25, 30, 60)},
        ["Classic Roblox"] = {StarCount = 1200, SunAngularSize = 21, MoonAngularSize = 11, ClockTime = 12, Ambient = Color3.fromRGB(128, 128, 128), FogColor = Color3.fromRGB(192, 192, 192)},
        ["Cloudy"] = {StarCount = 0, SunAngularSize = 12, MoonAngularSize = 0, ClockTime = 13, Ambient = Color3.fromRGB(135, 140, 145), FogColor = Color3.fromRGB(180, 185, 190)},
        ["Dusk"] = {StarCount = 900, SunAngularSize = 14, MoonAngularSize = 8, ClockTime = 18.4, Ambient = Color3.fromRGB(145, 95, 120), FogColor = Color3.fromRGB(185, 120, 130)},
        ["Dawn"] = {StarCount = 600, SunAngularSize = 16, MoonAngularSize = 7, ClockTime = 6.2, Ambient = Color3.fromRGB(170, 135, 115), FogColor = Color3.fromRGB(230, 170, 145)},
        ["Dark Skies"] = {StarCount = 2600, SunAngularSize = 0, MoonAngularSize = 12, ClockTime = 0, Ambient = Color3.fromRGB(45, 50, 65), FogColor = Color3.fromRGB(45, 50, 60)},
        ["Earth"] = {StarCount = 3000, SunAngularSize = 8, MoonAngularSize = 5, ClockTime = 1, Ambient = Color3.fromRGB(55, 80, 110), FogColor = Color3.fromRGB(35, 50, 80)},
        ["Horizontal Milky Way"] = {StarCount = 6000, SunAngularSize = 0, MoonAngularSize = 8, ClockTime = 0, Ambient = Color3.fromRGB(65, 55, 95), FogColor = Color3.fromRGB(35, 25, 60)},
        ["Heaven"] = {StarCount = 0, SunAngularSize = 24, MoonAngularSize = 0, ClockTime = 12, Ambient = Color3.fromRGB(205, 205, 230), FogColor = Color3.fromRGB(245, 245, 255)},
        ["Jungle"] = {StarCount = 200, SunAngularSize = 18, MoonAngularSize = 0, ClockTime = 15, Ambient = Color3.fromRGB(75, 115, 70), FogColor = Color3.fromRGB(90, 130, 95)},
        ["Mountains"] = {StarCount = 600, SunAngularSize = 16, MoonAngularSize = 9, ClockTime = 10, Ambient = Color3.fromRGB(125, 145, 160), FogColor = Color3.fromRGB(180, 200, 215)},
        ["Nebula"] = {StarCount = 7000, SunAngularSize = 0, MoonAngularSize = 5, ClockTime = 0, Ambient = Color3.fromRGB(85, 45, 125), FogColor = Color3.fromRGB(40, 20, 70)},
        ["Night Light"] = {StarCount = 5000, SunAngularSize = 0, MoonAngularSize = 14, ClockTime = 0, Ambient = Color3.fromRGB(80, 85, 120), FogColor = Color3.fromRGB(35, 40, 70)},
        ["Night"] = {StarCount = 3500, SunAngularSize = 0, MoonAngularSize = 11, ClockTime = 0, Ambient = Color3.fromRGB(55, 60, 80), FogColor = Color3.fromRGB(25, 30, 45)},
        ["Ocean Sky"] = {StarCount = 400, SunAngularSize = 20, MoonAngularSize = 8, ClockTime = 13, Ambient = Color3.fromRGB(120, 155, 180), FogColor = Color3.fromRGB(135, 180, 210)},
        ["Redshift"] = {StarCount = 1800, SunAngularSize = 18, MoonAngularSize = 6, ClockTime = 18, Ambient = Color3.fromRGB(160, 70, 65), FogColor = Color3.fromRGB(150, 55, 50)},
        ["Space"] = {StarCount = 6500, SunAngularSize = 0, MoonAngularSize = 6, ClockTime = 0, Ambient = Color3.fromRGB(50, 55, 95), FogColor = Color3.fromRGB(15, 20, 45)},
        ["Sunset"] = {StarCount = 700, SunAngularSize = 20, MoonAngularSize = 7, ClockTime = 17.8, Ambient = Color3.fromRGB(170, 105, 95), FogColor = Color3.fromRGB(235, 135, 95)},
        ["Storm"] = {StarCount = 0, SunAngularSize = 0, MoonAngularSize = 7, ClockTime = 16, Ambient = Color3.fromRGB(65, 70, 80), FogColor = Color3.fromRGB(70, 75, 85)},
        ["SFOTH"] = {StarCount = 1000, SunAngularSize = 21, MoonAngularSize = 11, ClockTime = 14, Ambient = Color3.fromRGB(135, 135, 135), FogColor = Color3.fromRGB(190, 190, 190)},
        ["Solid Black"] = {StarCount = 0, SunAngularSize = 0, MoonAngularSize = 0, ClockTime = 0, Ambient = Color3.new(), FogColor = Color3.new()},
        ["Saturn"] = {StarCount = 5500, SunAngularSize = 0, MoonAngularSize = 18, ClockTime = 0, Ambient = Color3.fromRGB(105, 85, 65), FogColor = Color3.fromRGB(60, 45, 35)},
        ["Smoke"] = {StarCount = 0, SunAngularSize = 0, MoonAngularSize = 5, ClockTime = 3, Ambient = Color3.fromRGB(85, 85, 85), FogColor = Color3.fromRGB(95, 95, 95)},
        ["Vertical Milky Way"] = {StarCount = 6200, SunAngularSize = 0, MoonAngularSize = 8, ClockTime = 0, Ambient = Color3.fromRGB(70, 50, 90), FogColor = Color3.fromRGB(30, 20, 55)},
        ["White"] = {StarCount = 0, SunAngularSize = 0, MoonAngularSize = 0, ClockTime = 12, Ambient = Color3.new(1, 1, 1), FogColor = Color3.new(1, 1, 1)},
    }

    local function skyId(id)
        if id == 0 then return "" end
        return "rbxassetid://" .. tostring(id)
    end

    local function setSkyboxIds(sky, name)
        local ids = Skyboxes[name] or Skyboxes.Afternoon
        sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt = skyId(ids[1]), skyId(ids[2]), skyId(ids[3])
        sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = skyId(ids[4]), skyId(ids[5]), skyId(ids[6])
        local settings = SkyboxSettings[name] or SkyboxSettings.Afternoon
        setProperty(sky, "StarCount", settings.StarCount or 0)
        setProperty(sky, "SunAngularSize", settings.SunAngularSize or 0)
        setProperty(sky, "MoonAngularSize", settings.MoonAngularSize or 0)
        setProperty(sky, "CelestialBodiesShown", (settings.SunAngularSize or 0) > 0 or (settings.MoonAngularSize or 0) > 0)
        setProperty(Lighting, "ClockTime", settings.ClockTime or Lighting.ClockTime)
        setProperty(Lighting, "Ambient", settings.Ambient or Lighting.Ambient)
        setProperty(Lighting, "OutdoorAmbient", settings.Ambient or Lighting.OutdoorAmbient)
        setProperty(Lighting, "FogColor", settings.FogColor or Lighting.FogColor)
    end

    local function restoreSkyboxes()
        for sky, parent in pairs(WorldVisualState.OriginalSkyboxes) do
            if sky and sky.Parent == nil and parent then
                pcall(function()
                    sky.Parent = parent
                end)
            end
            WorldVisualState.OriginalSkyboxes[sky] = nil
        end
    end

    local function applySkybox(name, enabled)
        local sky = getEffect("Sky", "LionSkybox")
        setSkyboxIds(sky, name)

        if not enabled then
            sky.Parent = nil
            restoreProperty(Lighting, "ClockTime")
            restoreProperty(Lighting, "Ambient")
            restoreProperty(Lighting, "OutdoorAmbient")
            restoreProperty(Lighting, "FogColor")
            restoreSkyboxes()
            return
        end

        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Sky") and obj ~= sky then
                WorldVisualState.OriginalSkyboxes[obj] = obj.Parent
                obj.Parent = nil
            end
        end
        sky.Parent = Lighting
    end

    local WeatherTextures = {
        Rain = "rbxassetid://241876422",
        Mist = "rbxassetid://130207970",
        Snow = "rbxassetid://92367298778210",
        Leaf = "rbxassetid://297774371",
    }

    local WeatherPresets = {
        ["Heavy Rain"] = {
            Light = {ClockTime = 14, Brightness = 1.4, FogEnd = 450, FogColor = Color3.fromRGB(120, 135, 155)},
            Layers = {
                {Texture = WeatherTextures.Rain, Rate = 850, Speed = 125, Lifetime = 0.75, Spread = 3, Size = 0.075, Color = Color3.fromRGB(185, 205, 255), Acceleration = Vector3.new(0, -360, 0), Transparency = 0.05},
                {Texture = WeatherTextures.Mist, Rate = 35, Speed = 7, Lifetime = 3.5, Spread = 35, Size = 0.45, Color = Color3.fromRGB(150, 160, 170), Acceleration = Vector3.new(8, -4, 0), Transparency = 0.82},
            }
        },
        ["Rain"] = {
            Light = {ClockTime = 14, Brightness = 1.7, FogEnd = 650, FogColor = Color3.fromRGB(150, 165, 185)},
            Layers = {
                {Texture = WeatherTextures.Rain, Rate = 420, Speed = 105, Lifetime = 0.85, Spread = 4, Size = 0.065, Color = Color3.fromRGB(195, 215, 255), Acceleration = Vector3.new(0, -300, 0), Transparency = 0.08},
                {Texture = WeatherTextures.Mist, Rate = 18, Speed = 6, Lifetime = 3.3, Spread = 35, Size = 0.38, Color = Color3.fromRGB(175, 185, 195), Acceleration = Vector3.new(4, -3, 0), Transparency = 0.86},
            }
        },
        ["Snow"] = {
            Light = {ClockTime = 13, Brightness = 2.2, FogEnd = 520, FogColor = Color3.fromRGB(220, 225, 235)},
            Layers = {
                {Texture = WeatherTextures.Snow, Rate = 180, Speed = 16, Lifetime = 5, Spread = 60, Size = 0.35, Color = Color3.fromRGB(255, 255, 255), Acceleration = Vector3.new(12, -28, 0), Transparency = 0.05},
                {Texture = WeatherTextures.Mist, Rate = 35, Speed = 8, Lifetime = 5, Spread = 90, Size = 1.1, Color = Color3.fromRGB(235, 240, 255), Acceleration = Vector3.new(4, -4, 0), Transparency = 0.8},
            }
        },
        ["City"] = {
            Light = {ClockTime = 16, Brightness = 1.5, FogEnd = 500, FogColor = Color3.fromRGB(115, 120, 130)},
            Layers = {
                {Texture = WeatherTextures.Rain, Rate = 260, Speed = 95, Lifetime = 0.95, Spread = 6, Size = 0.055, Color = Color3.fromRGB(180, 190, 210), Acceleration = Vector3.new(-20, -260, 0), Transparency = 0.12},
                {Texture = WeatherTextures.Mist, Rate = 45, Speed = 10, Lifetime = 3, Spread = 45, Size = 0.42, Color = Color3.fromRGB(125, 130, 135), Acceleration = Vector3.new(-35, -3, 0), Transparency = 0.84},
            }
        },
        ["Windy Day"] = {
            Light = {ClockTime = 13, Brightness = 2.4, FogEnd = 900, FogColor = Color3.fromRGB(190, 200, 205)},
            Layers = {
                {Texture = WeatherTextures.Mist, Rate = 70, Speed = 24, Lifetime = 2.2, Spread = 28, Size = 0.28, Color = Color3.fromRGB(220, 220, 220), Acceleration = Vector3.new(95, -2, 0), Transparency = 0.9},
                {Texture = WeatherTextures.Leaf, Rate = 22, Speed = 28, Lifetime = 3, Spread = 38, Size = 0.18, Color = Color3.fromRGB(165, 150, 95), Acceleration = Vector3.new(105, -12, 0), Transparency = 0.18, RotSpeed = 120},
            }
        },
        ["Heavy Rain Night"] = {
            Light = {ClockTime = 0, Brightness = 0.65, FogEnd = 360, FogColor = Color3.fromRGB(45, 55, 75)},
            Layers = {
                {Texture = WeatherTextures.Rain, Rate = 760, Speed = 125, Lifetime = 0.8, Spread = 4, Size = 0.075, Color = Color3.fromRGB(120, 150, 200), Acceleration = Vector3.new(4, -360, 0), Transparency = 0.08},
                {Texture = WeatherTextures.Mist, Rate = 42, Speed = 7, Lifetime = 3.8, Spread = 40, Size = 0.5, Color = Color3.fromRGB(55, 65, 85), Acceleration = Vector3.new(10, -4, 0), Transparency = 0.84},
            }
        },
        ["Forest Rain Night"] = {
            Light = {ClockTime = 0, Brightness = 0.75, FogEnd = 420, FogColor = Color3.fromRGB(30, 55, 50)},
            Layers = {
                {Texture = WeatherTextures.Rain, Rate = 470, Speed = 105, Lifetime = 0.9, Spread = 8, Size = 0.06, Color = Color3.fromRGB(130, 170, 170), Acceleration = Vector3.new(8, -300, 0), Transparency = 0.12},
                {Texture = WeatherTextures.Mist, Rate = 50, Speed = 8, Lifetime = 3.8, Spread = 42, Size = 0.45, Color = Color3.fromRGB(45, 85, 70), Acceleration = Vector3.new(16, -4, 0), Transparency = 0.84},
                {Texture = WeatherTextures.Leaf, Rate = 12, Speed = 16, Lifetime = 3.5, Spread = 40, Size = 0.16, Color = Color3.fromRGB(55, 115, 65), Acceleration = Vector3.new(35, -12, 0), Transparency = 0.25, RotSpeed = 90},
            }
        },
        ["Light Rain And Thunder"] = {
            Light = {ClockTime = 17, Brightness = 1.25, FogEnd = 560, FogColor = Color3.fromRGB(95, 105, 125)},
            Thunder = true,
            Layers = {
                {Texture = WeatherTextures.Rain, Rate = 240, Speed = 95, Lifetime = 0.95, Spread = 6, Size = 0.055, Color = Color3.fromRGB(195, 210, 255), Acceleration = Vector3.new(0, -275, 0), Transparency = 0.12},
                {Texture = WeatherTextures.Mist, Rate = 24, Speed = 7, Lifetime = 3.4, Spread = 35, Size = 0.4, Color = Color3.fromRGB(130, 140, 155), Acceleration = Vector3.new(5, -3, 0), Transparency = 0.86},
            }
        },
    }

    local AmbiencePresets = {
        ["Heavy Rain"] = "rbxassetid://9112854440",
        ["Rain"] = "rbxassetid://9112854440",
        ["City"] = "rbxassetid://9112854440",
        ["Windy Day"] = "rbxassetid://9112854440",
        ["Heavy Rain Night"] = "rbxassetid://9112854440",
        ["Forest Rain Night"] = "rbxassetid://9112854440",
        ["Light Rain And Thunder"] = "rbxassetid://9112854440",
    }

    local function ensureWeather()
        if WorldVisualState.WeatherPart then return WorldVisualState.WeatherPart, WorldVisualState.WeatherEmitter end
        local part = Instance.new("Part")
        part.Name = "LionWorldWeather"
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 1
        part.Size = Vector3.new(220, 1, 220)
        local emitter = Instance.new("ParticleEmitter")
        emitter.Name = "Weather"
        emitter.Enabled = false
        emitter.Parent = part
        WorldVisualState.WeatherPart = part
        WorldVisualState.WeatherEmitter = emitter
        return part, emitter
    end

    local function clearWeatherEmitters()
        for _, emitter in ipairs(WorldVisualState.WeatherEmitters) do
            if emitter then
                emitter:Destroy()
            end
        end
        table.clear(WorldVisualState.WeatherEmitters)
        if WorldVisualState.WeatherLightning then
            WorldVisualState.WeatherLightning:Destroy()
            WorldVisualState.WeatherLightning = nil
        end
    end

    local function makeWeatherEmitter(parent, layer, rateScale, lifetimeScale, timescale)
        local emitter = Instance.new("ParticleEmitter")
        emitter.Name = "WeatherLayer"
        emitter.Texture = layer.Texture
        emitter.Rate = (layer.Rate or 100) * rateScale
        emitter.Speed = NumberRange.new((layer.Speed or 20) * timescale)
        emitter.Lifetime = NumberRange.new((layer.Lifetime or 2) * lifetimeScale)
        emitter.SpreadAngle = Vector2.new(layer.Spread or 0, layer.Spread or 0)
        emitter.Size = NumberSequence.new(layer.Size or 0.2)
        emitter.Color = ColorSequence.new(layer.Color or Color3.new(1, 1, 1))
        emitter.Transparency = NumberSequence.new(layer.Transparency or 0)
        emitter.Acceleration = layer.Acceleration or Vector3.new(0, -100, 0)
        emitter.Drag = layer.Drag or 1
        emitter.LightEmission = layer.LightEmission or 0
        emitter.LightInfluence = layer.LightInfluence or 0
        emitter.RotSpeed = NumberRange.new(layer.RotSpeed or 0)
        emitter.Rotation = NumberRange.new(0, 360)
        emitter.EmissionDirection = Enum.NormalId.Bottom
        pcall(function()
            emitter.Shape = Enum.ParticleEmitterShape.Box
            emitter.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
            emitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
        end)
        emitter.Parent = parent
        table.insert(WorldVisualState.WeatherEmitters, emitter)
        return emitter
    end

    local function applyWeather(name, rateScale, lifetimeScale, timescale)
        local part = ensureWeather()
        local preset = WeatherPresets[name] or WeatherPresets["Heavy Rain"]
        clearWeatherEmitters()

        for _, layer in ipairs(preset.Layers or {}) do
            makeWeatherEmitter(part, layer, rateScale, lifetimeScale, timescale)
        end

        if preset.Light then
            setProperty(Lighting, "ClockTime", preset.Light.ClockTime or Lighting.ClockTime)
            setProperty(Lighting, "Brightness", preset.Light.Brightness or Lighting.Brightness)
            setProperty(Lighting, "FogEnd", preset.Light.FogEnd or Lighting.FogEnd)
            setProperty(Lighting, "FogColor", preset.Light.FogColor or Lighting.FogColor)
        end

        if preset.Thunder then
            local light = Instance.new("PointLight")
            light.Name = "Lightning"
            light.Color = Color3.fromRGB(210, 225, 255)
            light.Brightness = 0
            light.Range = 120
            light.Parent = part
            WorldVisualState.WeatherLightning = light
            task.spawn(function()
                while WorldVisualState.WeatherEnabled and WorldVisualState.WeatherLightning == light do
                    task.wait(math.random(35, 90) / 10)
                    if WorldVisualState.WeatherLightning ~= light then break end
                    light.Brightness = 8
                    task.wait(0.06)
                    light.Brightness = 0
                    task.wait(0.08)
                    light.Brightness = 5
                    task.wait(0.05)
                    light.Brightness = 0
                end
            end)
        end

        part.Parent = workspace
    end

    local function followWeather()
        local part = WorldVisualState.WeatherPart
        if part and entitylib.isAlive and entitylib.character and entitylib.character.RootPart then
            part.Position = entitylib.character.RootPart.Position + Vector3.new(0, 85, 0)
        end
    end

    local function ensureAmbience()
        if WorldVisualState.AmbienceSound then return WorldVisualState.AmbienceSound end
        local sound = Instance.new("Sound")
        sound.Name = "LionWorldAmbience"
        sound.Looped = true
        sound.Parent = SoundService
        WorldVisualState.AmbienceSound = sound
        return sound
    end

    local function clearAspectFrame()
        if WorldVisualState.AspectFrame then
            WorldVisualState.AspectFrame:Destroy()
            WorldVisualState.AspectFrame = nil
        end
    end

    local function setAspectRatio(enabled, ratioX, ratioY, camera, baseFov)
        clearAspectFrame()
        camera = camera or workspace.CurrentCamera
        baseFov = math.clamp(tonumber(baseFov) or (camera and camera.FieldOfView) or 70, 1, 120)
        if not (enabled and camera) then
            return baseFov
        end

        local x = math.clamp(tonumber(ratioX) or 1, 0.1, 5)
        local y = math.clamp(tonumber(ratioY) or 1, 0.1, 5)
        camera.CFrame = camera.CFrame * CFrame.new(
            0, 0, 0,
            x, 0, 0,
            0, y, 0,
            0, 0, 1
        )
        return baseFov
    end

    local function connectThrottled(module, interval, callback)
        local nextUpdate = 0
        module:Clean(RunService.Heartbeat:Connect(function()
            local now = os.clock()
            if now < nextUpdate then return end
            nextUpdate = now + interval
            callback()
        end))
    end

    local ColorCorrectionModule, Saturation, Contrast, BrightnessCC
    ColorCorrectionModule = Movement:AddModule({
        Name = "Color Correction",
        Color = Color3.fromRGB(255, 255, 255),
        Function = function(callback)
            local effect = getEffect("ColorCorrectionEffect", "LionColorCorrection")
            effect.Parent = Lighting
            effect.Enabled = callback
            setProperty(effect, "TintColor", ColorCorrectionModule.Value or Color3.fromRGB(255, 255, 255))
            setProperty(effect, "Saturation", Saturation.Value)
            setProperty(effect, "Contrast", Contrast.Value)
            setProperty(effect, "Brightness", BrightnessCC.Value)
            if callback then
                connectThrottled(ColorCorrectionModule, 0.2, function()
                    if not (Saturation and Contrast and BrightnessCC) then return end
                    local e = getEffect("ColorCorrectionEffect", "LionColorCorrection")
                    e.Parent = Lighting
                    e.Enabled = true
                    setProperty(e, "TintColor", ColorCorrectionModule.Value or Color3.fromRGB(255, 255, 255))
                    setProperty(e, "Saturation", Saturation.Value)
                    setProperty(e, "Contrast", Contrast.Value)
                    setProperty(e, "Brightness", BrightnessCC.Value)
                end)
            end
        end
    })
    Saturation = ColorCorrectionModule:AddSlider({Name = "Saturation", Min = -2, Max = 2, Default = 0, Decimal = 10, Function = function(v)
        local effect = getEffect("ColorCorrectionEffect", "LionColorCorrection")
        effect.Parent = Lighting
        setProperty(effect, "Saturation", v)
        effect.Enabled = ColorCorrectionModule.Enabled
    end})
    Contrast = ColorCorrectionModule:AddSlider({Name = "Contrast", Min = -2, Max = 2, Default = 0, Decimal = 10, Function = function(v)
        local effect = getEffect("ColorCorrectionEffect", "LionColorCorrection")
        effect.Parent = Lighting
        setProperty(effect, "Contrast", v)
        effect.Enabled = ColorCorrectionModule.Enabled
    end})
    BrightnessCC = ColorCorrectionModule:AddSlider({Name = "Brightness", Min = -2, Max = 2, Default = 0, Decimal = 10, Function = function(v)
        local effect = getEffect("ColorCorrectionEffect", "LionColorCorrection")
        effect.Parent = Lighting
        setProperty(effect, "Brightness", v)
        effect.Enabled = ColorCorrectionModule.Enabled
    end})

    local AtmosphereModule, Glare, Haze, Offset, Density
    AtmosphereModule = Movement:AddModule({
        Name = "Atmosphere",
        Colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)},
        Function = function(callback)
            local atmosphere = getEffect("Atmosphere", "LionAtmosphere")
            atmosphere.Parent = callback and Lighting or nil
            setProperty(atmosphere, "Color", AtmosphereModule.Colors and AtmosphereModule.Colors[1] or Color3.fromRGB(255, 255, 255))
            setProperty(atmosphere, "Decay", AtmosphereModule.Colors and AtmosphereModule.Colors[2] or Color3.fromRGB(255, 255, 255))
            setProperty(atmosphere, "Glare", Glare.Value)
            setProperty(atmosphere, "Haze", Haze.Value)
            setProperty(atmosphere, "Offset", Offset.Value)
            setProperty(atmosphere, "Density", Density.Value)
            if callback then
                connectThrottled(AtmosphereModule, 0.2, function()
                    if not (Glare and Haze and Offset and Density) then return end
                    local a = getEffect("Atmosphere", "LionAtmosphere")
                    a.Parent = Lighting
                    setProperty(a, "Color", AtmosphereModule.Colors and AtmosphereModule.Colors[1] or Color3.fromRGB(255, 255, 255))
                    setProperty(a, "Decay", AtmosphereModule.Colors and AtmosphereModule.Colors[2] or Color3.fromRGB(255, 255, 255))
                    setProperty(a, "Glare", Glare.Value)
                    setProperty(a, "Haze", Haze.Value)
                    setProperty(a, "Offset", Offset.Value)
                    setProperty(a, "Density", Density.Value)
                end)
            end
        end
    })
    Glare = AtmosphereModule:AddSlider({Name = "Glare", Min = 0, Max = 10, Default = 1.5, Decimal = 10, Function = function(v) local a = getEffect("Atmosphere", "LionAtmosphere"); setProperty(a, "Glare", v); a.Parent = AtmosphereModule.Enabled and Lighting or nil end})
    Haze = AtmosphereModule:AddSlider({Name = "Haze", Min = 0, Max = 10, Default = 10, Decimal = 10, Function = function(v) local a = getEffect("Atmosphere", "LionAtmosphere"); setProperty(a, "Haze", v); a.Parent = AtmosphereModule.Enabled and Lighting or nil end})
    Offset = AtmosphereModule:AddSlider({Name = "Offset", Min = 0, Max = 1, Default = 0.4, Decimal = 100, Function = function(v) local a = getEffect("Atmosphere", "LionAtmosphere"); setProperty(a, "Offset", v); a.Parent = AtmosphereModule.Enabled and Lighting or nil end})
    Density = AtmosphereModule:AddSlider({Name = "Density", Min = 0, Max = 1, Default = 0.5, Decimal = 100, Function = function(v) local a = getEffect("Atmosphere", "LionAtmosphere"); setProperty(a, "Density", v); a.Parent = AtmosphereModule.Enabled and Lighting or nil end})

    local LightingModule, Ambient, OutdoorAmbient, ColorShiftBottom, ColorShiftTop, FogColor, FogEnd, FogEndValue, FogStart, FogStartValue, Exposure, ExposureValue, LightingBrightness, LightingBrightnessValue, ClockTime, ClockTimeValue, GlobalShadows
    local lightingProps = {Ambient = true, OutdoorAmbient = true, ColorShift_Bottom = true, ColorShift_Top = true, FogColor = true, FogEnd = true, FogStart = true, ExposureCompensation = true, Brightness = true, ClockTime = true, GlobalShadows = true}
    local function applyLightingProp(prop, enabled, value)
        if LightingModule.Enabled and enabled and enabled.Enabled then
            setProperty(Lighting, prop, value)
        else
            restoreProperty(Lighting, prop)
        end
    end
    local function applyLightingAll()
        if not (LightingModule and Ambient and ColorShiftBottom and ColorShiftTop and FogColor and FogEnd and FogEndValue and FogStart and FogStartValue and Exposure and ExposureValue and LightingBrightness and LightingBrightnessValue and ClockTime and ClockTimeValue and GlobalShadows) then return end
        applyLightingProp("Ambient", Ambient, Ambient.Value)
        if LightingModule.Enabled and Ambient.Enabled then
            setProperty(Lighting, "OutdoorAmbient", Ambient.Value)
        else
            restoreProperty(Lighting, "OutdoorAmbient")
        end
        if OutdoorAmbient and OutdoorAmbient.Enabled then
            applyLightingProp("OutdoorAmbient", OutdoorAmbient, OutdoorAmbient.Value)
        end
        applyLightingProp("ColorShift_Bottom", ColorShiftBottom, ColorShiftBottom.Value)
        applyLightingProp("ColorShift_Top", ColorShiftTop, ColorShiftTop.Value)
        applyLightingProp("FogColor", FogColor, FogColor.Value)
        local fogStartValue = FogStartValue.Value
        local fogEndValue = FogEndValue.Value
        if FogStart.Enabled and FogEnd.Enabled and fogStartValue > fogEndValue then
            fogStartValue, fogEndValue = fogEndValue, fogStartValue
        end
        applyLightingProp("FogEnd", FogEnd, fogEndValue)
        applyLightingProp("FogStart", FogStart, fogStartValue)
        applyLightingProp("ExposureCompensation", Exposure, ExposureValue.Value)
        applyLightingProp("Brightness", LightingBrightness, LightingBrightnessValue.Value)
        applyLightingProp("ClockTime", ClockTime, ClockTimeValue.Value)
        if LightingModule.Enabled then
            setProperty(Lighting, "GlobalShadows", GlobalShadows.Enabled)
        else
            restoreProperty(Lighting, "GlobalShadows")
        end
    end
    LightingModule = Movement:AddModule({Name = "Lighting", Function = function(callback)
        if callback then
            applyLightingAll()
            connectThrottled(LightingModule, 0.2, applyLightingAll)
        else
            for prop in pairs(lightingProps) do restoreProperty(Lighting, prop) end
        end
    end})
    Ambient = LightingModule:AddToggle({Name = "Ambient", Color = Lighting.Ambient, Function = function() applyLightingAll() end})
    OutdoorAmbient = LightingModule:AddToggle({Name = "OutdoorAmbient", Color = Lighting.OutdoorAmbient, Function = function() applyLightingAll() end})
    ColorShiftBottom = LightingModule:AddToggle({Name = "ColorShift_Bottom", Color = Lighting.ColorShift_Bottom, Function = function() applyLightingAll() end})
    ColorShiftTop = LightingModule:AddToggle({Name = "ColorShift_Top", Color = Lighting.ColorShift_Top, Function = function() applyLightingAll() end})
    FogColor = LightingModule:AddToggle({Name = "FogColor", Color = Lighting.FogColor, Function = function() applyLightingAll() end})
    FogEnd = LightingModule:AddToggle({Name = "FogEnd", Function = function() applyLightingAll() end})
    FogEndValue = LightingModule:AddSlider({Name = "FogEnd Value", Min = 0, Max = 100000, Default = Lighting.FogEnd, Function = function() applyLightingAll() end})
    FogStart = LightingModule:AddToggle({Name = "FogStart", Function = function() applyLightingAll() end})
    FogStartValue = LightingModule:AddSlider({Name = "FogStart Value", Min = 0, Max = 10000, Default = Lighting.FogStart, Function = function() applyLightingAll() end})
    Exposure = LightingModule:AddToggle({Name = "ExposureCompensation", Function = function() applyLightingAll() end})
    ExposureValue = LightingModule:AddSlider({Name = "ExposureCompensation Value", Min = -5, Max = 5, Default = Lighting.ExposureCompensation, Decimal = 10, Function = function() applyLightingAll() end})
    LightingBrightness = LightingModule:AddToggle({Name = "Brightness", Function = function() applyLightingAll() end})
    LightingBrightnessValue = LightingModule:AddSlider({Name = "Brightness Value", Min = 0, Max = 10, Default = Lighting.Brightness, Decimal = 10, Function = function() applyLightingAll() end})
    ClockTime = LightingModule:AddToggle({Name = "ClockTime", Function = function() applyLightingAll() end})
    ClockTimeValue = LightingModule:AddSlider({Name = "ClockTime Value", Min = 0, Max = 24, Default = Lighting.ClockTime, Decimal = 10, Function = function() applyLightingAll() end})
    GlobalShadows = LightingModule:AddToggle({Name = "GlobalShadows", Default = Lighting.GlobalShadows, Function = function() applyLightingAll() end})

    local SkyboxModule, SelectedSkybox
    SkyboxModule = Movement:AddModule({Name = "Skybox", Function = function(callback)
        applySkybox(SelectedSkybox.Value, callback)
        if callback then
            SkyboxModule:Clean(Lighting.ChildAdded:Connect(function(child)
                local sky = getEffect("Sky", "LionSkybox")
                if SkyboxModule.Enabled and child:IsA("Sky") and child ~= sky then
                    task.defer(function()
                        applySkybox(SelectedSkybox.Value, true)
                    end)
                end
            end))
            connectThrottled(SkyboxModule, 0.5, function()
                local sky = getEffect("Sky", "LionSkybox")
                if SkyboxModule.Enabled and sky.Parent ~= Lighting then
                    applySkybox(SelectedSkybox.Value, true)
                end
            end)
        end
    end})
    SelectedSkybox = SkyboxModule:AddDropdown({Name = "Selected", List = {"Afternoon", "Blue Space", "Classic Roblox", "Cloudy", "Dusk", "Dawn", "Dark Skies", "Earth", "Horizontal Milky Way", "Heaven", "Jungle", "Mountains", "Nebula", "Night Light", "Night", "Ocean Sky", "Redshift", "Space", "Sunset", "Storm", "SFOTH", "Solid Black", "Saturn", "Smoke", "Vertical Milky Way", "White"}, Default = "Afternoon", Function = function(v)
        applySkybox(v, SkyboxModule.Enabled)
    end})

    local WeatherModule, SelectedWeather, WeatherRate, WeatherLifetime, WeatherTimescale
    WeatherModule = Movement:AddModule({Name = "Weather", Function = function(callback)
        if callback then
            WorldVisualState.WeatherEnabled = true
            applyWeather(SelectedWeather.Value, WeatherRate.Value, WeatherLifetime.Value, WeatherTimescale.Value)
            connectThrottled(WeatherModule, 0.1, followWeather)
        elseif WorldVisualState.WeatherPart then
            WorldVisualState.WeatherEnabled = false
            clearWeatherEmitters()
            WorldVisualState.WeatherPart.Parent = nil
            restoreProperty(Lighting, "ClockTime")
            restoreProperty(Lighting, "Brightness")
            restoreProperty(Lighting, "FogEnd")
            restoreProperty(Lighting, "FogColor")
        end
    end})
    SelectedWeather = WeatherModule:AddDropdown({Name = "Selected", List = {"Heavy Rain", "Rain", "Snow", "City", "Windy Day", "Heavy Rain Night", "Forest Rain Night", "Light Rain And Thunder"}, Default = "Heavy Rain", Function = function(v)
        if WeatherModule.Enabled then applyWeather(v, WeatherRate.Value, WeatherLifetime.Value, WeatherTimescale.Value) end
    end})
    WeatherRate = WeatherModule:AddSlider({Name = "Rate", Min = 0, Max = 5, Default = 1, Decimal = 10, Function = function() if WeatherModule.Enabled then applyWeather(SelectedWeather.Value, WeatherRate.Value, WeatherLifetime.Value, WeatherTimescale.Value) end end})
    WeatherLifetime = WeatherModule:AddSlider({Name = "Lifetime", Min = 0, Max = 2, Default = 1, Decimal = 100, Function = function() if WeatherModule.Enabled then applyWeather(SelectedWeather.Value, WeatherRate.Value, WeatherLifetime.Value, WeatherTimescale.Value) end end})
    WeatherTimescale = WeatherModule:AddSlider({Name = "Timescale", Min = 0.1, Max = 3, Default = 1, Decimal = 10, Function = function() if WeatherModule.Enabled then applyWeather(SelectedWeather.Value, WeatherRate.Value, WeatherLifetime.Value, WeatherTimescale.Value) end end})

    local AmbienceModule, SelectedAmbience, Volume
    AmbienceModule = Movement:AddModule({Name = "Ambience", Function = function(callback)
        if callback then
            local sound = ensureAmbience()
            sound.SoundId = AmbiencePresets[SelectedAmbience.Value] or AmbiencePresets.Rain
            sound.Volume = Volume.Value
            sound:Play()
            connectThrottled(AmbienceModule, 0.5, function()
                if not (SelectedAmbience and Volume) then return end
                local current = ensureAmbience()
                current.SoundId = AmbiencePresets[SelectedAmbience.Value] or AmbiencePresets.Rain
                current.Volume = Volume.Value
                current.Looped = true
                current.Parent = SoundService
                if not current.Playing then current:Play() end
            end)
        elseif WorldVisualState.AmbienceSound then
            local sound = WorldVisualState.AmbienceSound
            sound:Stop()
        end
    end})
    SelectedAmbience = AmbienceModule:AddDropdown({Name = "Selected", List = {"Heavy Rain", "Rain", "City", "Windy Day", "Heavy Rain Night", "Forest Rain Night", "Light Rain And Thunder"}, Default = "Heavy Rain", Function = function(v)
        if AmbienceModule.Enabled then
            local sound = ensureAmbience()
            sound.SoundId = AmbiencePresets[v] or AmbiencePresets.Rain
            sound.Volume = Volume.Value
            sound:Play()
        end
    end})
    Volume = AmbienceModule:AddSlider({Name = "Volume", Min = 0, Max = 2, Default = 0.5, Decimal = 10, Function = function(v) if AmbienceModule.Enabled then ensureAmbience().Volume = v end end})

    local BloomModule, BloomIntensity, BloomSize, BloomThreshold
    BloomModule = Movement:AddModule({Name = "Bloom", Function = function(callback)
        local e = getEffect("BloomEffect", "LionBloom")
        e.Parent = Lighting
        e.Enabled = callback
        if callback then
            connectThrottled(BloomModule, 0.2, function()
                if not (BloomIntensity and BloomSize and BloomThreshold) then return end
                local effect = getEffect("BloomEffect", "LionBloom")
                effect.Parent = Lighting
                effect.Enabled = true
                setProperty(effect, "Intensity", BloomIntensity.Value)
                setProperty(effect, "Size", BloomSize.Value)
                setProperty(effect, "Threshold", BloomThreshold.Value)
            end)
        end
    end})
    BloomIntensity = BloomModule:AddSlider({Name = "Intensity", Min = 0, Max = 5, Default = 0.6, Decimal = 10, Function = function(v) local e = getEffect("BloomEffect", "LionBloom"); e.Parent = Lighting; setProperty(e, "Intensity", v); e.Enabled = BloomModule.Enabled end})
    BloomSize = BloomModule:AddSlider({Name = "Size", Min = 0, Max = 100, Default = 26, Function = function(v) local e = getEffect("BloomEffect", "LionBloom"); e.Parent = Lighting; setProperty(e, "Size", v); e.Enabled = BloomModule.Enabled end})
    BloomThreshold = BloomModule:AddSlider({Name = "Threshold", Min = 0, Max = 5, Default = 0.4, Decimal = 10, Function = function(v) local e = getEffect("BloomEffect", "LionBloom"); e.Parent = Lighting; setProperty(e, "Threshold", v); e.Enabled = BloomModule.Enabled end})

    local SunRaysModule, SunRaysEnabled, SunIntensity, SunSpread
    SunRaysModule = Movement:AddModule({Name = "Sun Rays", Function = function(callback)
        local e = getEffect("SunRaysEffect", "LionSunRays")
        e.Parent = Lighting
        e.Enabled = callback and SunRaysEnabled.Enabled
        if callback then
            connectThrottled(SunRaysModule, 0.2, function()
                if not (SunRaysEnabled and SunIntensity and SunSpread) then return end
                local effect = getEffect("SunRaysEffect", "LionSunRays")
                effect.Parent = Lighting
                effect.Enabled = SunRaysEnabled.Enabled
                setProperty(effect, "Intensity", SunIntensity.Value)
                setProperty(effect, "Spread", SunSpread.Value)
            end)
        end
    end})
    SunRaysEnabled = SunRaysModule:AddToggle({Name = "override", Function = function(v) local e = getEffect("SunRaysEffect", "LionSunRays"); e.Parent = Lighting; e.Enabled = SunRaysModule.Enabled and v end})
    SunIntensity = SunRaysModule:AddSlider({Name = "Intensity", Min = 0, Max = 1, Default = 0.25, Decimal = 100, Function = function(v) local e = getEffect("SunRaysEffect", "LionSunRays"); e.Parent = Lighting; setProperty(e, "Intensity", v); e.Enabled = SunRaysModule.Enabled and SunRaysEnabled.Enabled end})
    SunSpread = SunRaysModule:AddSlider({Name = "Spread", Min = 0, Max = 1, Default = 1, Decimal = 100, Function = function(v) local e = getEffect("SunRaysEffect", "LionSunRays"); e.Parent = Lighting; setProperty(e, "Spread", v); e.Enabled = SunRaysModule.Enabled and SunRaysEnabled.Enabled end})

    local CameraModule, AntiFlashbang, AntiSmoke, FOVChanger, FOVValue, AspectRatio, RatioX, RatioY, Blur
    local function installAntiFlashbang()
        if WorldVisualState.AntiFlashInstalled then return end
        local ok = pcall(function()
            local Flashed = require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.FighterInterface.Flashed)
            if Flashed and Flashed.Flash then
                WorldVisualState.OriginalFlashFunction = Flashed.Flash
                Flashed.Flash = function(...)
                    if CameraModule and CameraModule.Enabled and AntiFlashbang and AntiFlashbang.Enabled then
                        return
                    end
                    return WorldVisualState.OriginalFlashFunction(...)
                end
            end
        end)
        WorldVisualState.AntiFlashInstalled = ok and WorldVisualState.OriginalFlashFunction ~= nil
    end

    local function setAntiSmoke(enabled)
        local ok = pcall(function()
            local SmokeScreen = require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.FighterInterface.SmokeScreen)
            local SmokeCloud = require(LocalPlayer.PlayerScripts.Modules.SmokeCloud)

            if not WorldVisualState.OriginalSmokeScreenUpdate and type(SmokeScreen.Update) == "function" then
                WorldVisualState.OriginalSmokeScreenUpdate = SmokeScreen.Update
            end
            if not WorldVisualState.OriginalSmokeCloudUpdate and type(SmokeCloud.Update) == "function" then
                WorldVisualState.OriginalSmokeCloudUpdate = SmokeCloud.Update
            end

            if enabled then
                SmokeScreen.Update = function(self)
                    if self._smoke_cloud_spring then self._smoke_cloud_spring.Target = 0 end
                    if self._smoke_cloud_cover then self._smoke_cloud_cover.Transparency = 1 end
                    if self._smoke_cloud_dof then self._smoke_cloud_dof.Parent = nil end
                end
                SmokeCloud.Update = function(self)
                    if self.Model then self.Model:Destroy() end
                    return true
                end
            else
                if WorldVisualState.OriginalSmokeScreenUpdate then
                    SmokeScreen.Update = WorldVisualState.OriginalSmokeScreenUpdate
                end
                if WorldVisualState.OriginalSmokeCloudUpdate then
                    SmokeCloud.Update = WorldVisualState.OriginalSmokeCloudUpdate
                end
            end
        end)
        WorldVisualState.AntiSmokeInstalled = enabled and ok
    end

    CameraModule = Movement:AddModule({Name = "Camera", Function = function(callback)
        local camera = workspace.CurrentCamera
        if callback then
            if camera and not WorldVisualState.OriginalFOV then WorldVisualState.OriginalFOV = camera.FieldOfView end
            shared.LionForceFOVEnabled = FOVChanger and FOVChanger.Enabled or false
            shared.LionForceFOVValue = FOVValue and FOVValue.Value or (camera and camera.FieldOfView or 70)
            if AntiFlashbang and AntiFlashbang.Enabled then installAntiFlashbang() end
            setAntiSmoke(AntiSmoke and AntiSmoke.Enabled or false)
            pcall(function()
                RunService:UnbindFromRenderStep("LionForceFOV")
            end)
			pcall(function()
				RunService:BindToRenderStep("LionForceFOV", Enum.RenderPriority.Camera.Value + 1, function()
					local camObj = workspace.CurrentCamera
					if not (camObj and CameraModule.Enabled) then
						shared.LionForceFOVEnabled = false
						return
					end
					local aspectEnabled = AspectRatio and AspectRatio.Enabled
					local fovEnabled = FOVChanger and FOVChanger.Enabled
					local baseFov = fovEnabled and FOVValue.Value or (WorldVisualState.OriginalFOV or camObj.FieldOfView)
					if fovEnabled or aspectEnabled then
						local finalFov = aspectEnabled and setAspectRatio(true, RatioX.Value, RatioY.Value, camObj, baseFov) or baseFov
						camObj.FieldOfView = finalFov
						shared.LionForceFOVEnabled = true
						shared.LionForceFOVValue = finalFov
					elseif WorldVisualState.OriginalFOV then
						shared.LionForceFOVEnabled = false
						camObj.FieldOfView = WorldVisualState.OriginalFOV
						setAspectRatio(false, 1, 1, camObj, WorldVisualState.OriginalFOV)
					else
						shared.LionForceFOVEnabled = false
					end
				end)
			end)
			CameraModule:Clean(function()
				pcall(function()
					RunService:UnbindFromRenderStep("LionForceFOV")
				end)
				shared.LionForceFOVEnabled = false
			end)
			connectThrottled(CameraModule, 0.2, function()
				local blur = getEffect("BlurEffect", "LionCameraBlur")
				blur.Parent = Lighting
				blur.Size = Blur and Blur.Value or 0
				if AntiFlashbang and AntiFlashbang.Enabled then installAntiFlashbang() end
			end)
        else
            pcall(function()
                RunService:UnbindFromRenderStep("LionForceFOV")
            end)
            shared.LionForceFOVEnabled = false
            if camera and WorldVisualState.OriginalFOV then camera.FieldOfView = WorldVisualState.OriginalFOV end
            WorldVisualState.OriginalFOV = nil
            setAspectRatio(false, 1, 1)
            local blur = getEffect("BlurEffect", "LionCameraBlur")
            blur.Size = 0
            blur.Parent = nil
            setAntiSmoke(false)
        end
    end})
    AntiFlashbang = CameraModule:AddToggle({Name = "anti flashbang", Function = function(v) if v then installAntiFlashbang() end end})
    AntiSmoke = CameraModule:AddToggle({Name = "anti smoke", Function = function(v) setAntiSmoke(CameraModule.Enabled and v) end})
    FOVChanger = CameraModule:AddToggle({Name = "fov changer", Default = true, Function = function(v)
        if CameraModule.Enabled and workspace.CurrentCamera then
            if v then
                shared.LionForceFOVEnabled = true
                shared.LionForceFOVValue = FOVValue.Value
                workspace.CurrentCamera.FieldOfView = FOVValue.Value
            elseif not v then
                local baseFov = WorldVisualState.OriginalFOV or workspace.CurrentCamera.FieldOfView
                shared.LionForceFOVEnabled = AspectRatio and AspectRatio.Enabled or false
                shared.LionForceFOVValue = baseFov
                workspace.CurrentCamera.FieldOfView = baseFov
            end
        end
    end})
    FOVValue = CameraModule:AddSlider({Name = "fov", Min = 1, Max = 120, Default = 120, Function = function(v)
        if CameraModule.Enabled and FOVChanger.Enabled and workspace.CurrentCamera then
            shared.LionForceFOVEnabled = true
            shared.LionForceFOVValue = v
            workspace.CurrentCamera.FieldOfView = v
        else
            shared.LionForceFOVValue = v
        end
    end})
    AspectRatio = CameraModule:AddToggle({Name = "aspect ratio", Function = function()
        if CameraModule.Enabled and workspace.CurrentCamera then
            local baseFov = FOVChanger.Enabled and FOVValue.Value or (WorldVisualState.OriginalFOV or workspace.CurrentCamera.FieldOfView)
            shared.LionForceFOVEnabled = FOVChanger.Enabled or AspectRatio.Enabled
            shared.LionForceFOVValue = baseFov
            workspace.CurrentCamera.FieldOfView = baseFov
        end
    end})
    RatioX = CameraModule:AddSlider({Name = "ratio x", Min = 0.1, Max = 5, Default = 1, Decimal = 10, Function = function()
        if CameraModule.Enabled and workspace.CurrentCamera then
            local baseFov = FOVChanger.Enabled and FOVValue.Value or (WorldVisualState.OriginalFOV or workspace.CurrentCamera.FieldOfView)
            shared.LionForceFOVValue = baseFov
        end
    end})
    RatioY = CameraModule:AddSlider({Name = "ratio y", Min = 0.1, Max = 5, Default = 0.65, Decimal = 10000, Function = function()
        if CameraModule.Enabled and workspace.CurrentCamera then
            local baseFov = FOVChanger.Enabled and FOVValue.Value or (WorldVisualState.OriginalFOV or workspace.CurrentCamera.FieldOfView)
            shared.LionForceFOVValue = baseFov
        end
    end})
    Blur = CameraModule:AddSlider({Name = "blur", Min = 0, Max = 56, Default = 0, Function = function(v)
        local blur = getEffect("BlurEffect", "LionCameraBlur")
        blur.Parent = CameraModule.Enabled and Lighting or nil
        setProperty(blur, "Size", CameraModule.Enabled and v or 0)
    end})
end)

run(function()
	local Shader
	local cacheLighting = {}
	local Sky = Instance.new('Sky')
	Sky.SkyboxBk = 'http://www.roblox.com/asset/?id=245972325'
	Sky.SkyboxDn = 'http://www.roblox.com/asset/?id=245972441'
	Sky.SkyboxFt = 'http://www.roblox.com/asset/?id=245972389'
	Sky.SkyboxLf = 'http://www.roblox.com/asset/?id=245972361'
	Sky.SkyboxRt = 'http://www.roblox.com/asset/?id=245972302'
	Sky.SkyboxUp = 'http://www.roblox.com/asset/?id=245972410'
	Sky.MoonTextureId = "rbxasset://sky/moon.jpg"
	Sky.SunTextureId = "rbxasset://sky/sun.jpg"
	Sky.StarCount = 3000

	local BlurEffect = Instance.new('BlurEffect')
	BlurEffect.Size = 6

	local ColorCorrectionEffect = Instance.new('ColorCorrectionEffect')
	ColorCorrectionEffect.Saturation = -0.4

	local SnowEffect = Instance.new("Part")
	SnowEffect.Size = vector.create(200, 1, 200)
	SnowEffect.Transparency = 1
	SnowEffect.Anchored = true


	local SnowParticle = Instance.new("ParticleEmitter")
	SnowParticle.EmissionDirection = "Bottom"
	SnowParticle.Rate = 20000
	SnowParticle.Lifetime = NumberRange.new(3.5, 3.5)
	SnowParticle.Speed = NumberRange.new(50, 50)
	SnowParticle.Texture = "rbxassetid://92367298778210"
	SnowParticle.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3),
		NumberSequenceKeypoint.new(1, 0.4)
	})
	SnowParticle.SpreadAngle = Vector2.new(70, 70)
	SnowParticle.Parent = SnowEffect
	SnowParticle:Clone().Parent = SnowEffect
	SnowParticle:Clone().Parent = SnowEffect
	local Time = {}
	local Skys = {}
	Shader = Other:AddModule({
		Name = 'Shader',
		Function = function(callback)
			if callback then
				cacheLighting = {
					Lighting.Ambient;
					Lighting.Brightness;
					Lighting.ColorShift_Bottom;
					Lighting.ColorShift_Top;
					Lighting.EnvironmentDiffuseScale;
					Lighting.EnvironmentSpecularScale;
					Lighting.GlobalShadows;
					Lighting.OutdoorAmbient;
					Lighting.ShadowSoftness;
					Lighting.TimeOfDay;
				};
				Lighting.Ambient = Color3.fromRGB(94, 99, 188)
				Lighting.Brightness = 4
				Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
				Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
				Lighting.EnvironmentDiffuseScale = 1
				Lighting.EnvironmentSpecularScale = 1
				Lighting.GlobalShadows = true
				Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
				Lighting.ShadowSoftness = 3
				Lighting.TimeOfDay = (Time.Value or '00')..':40:00'
				SnowEffect.Parent = workspace
				local nextSnowUpdate = 0
				Shader:Clean(RunService.Heartbeat:Connect(function()
					local now = os.clock()
					if now < nextSnowUpdate then return end
					nextSnowUpdate = now + 0.1
					local root = entitylib.isAlive and entitylib.character and entitylib.character.RootPart
					if root then
						SnowEffect.Position = root.Position + vector.create(0, 90, 0)
					end
				end))
				for i,v in next, Skys do
					if v.Object then
						v.Object.Parent = v.Parent
					end
				end
				Sky.Parent = Lighting
				BlurEffect.Parent = Lighting
				ColorCorrectionEffect.Parent = Lighting
			else
				Lighting.Ambient = cacheLighting[1]
				Lighting.Brightness = cacheLighting[2]
				Lighting.ColorShift_Bottom = cacheLighting[3]
				Lighting.ColorShift_Top = cacheLighting[4]
				Lighting.EnvironmentDiffuseScale = cacheLighting[5]
				Lighting.EnvironmentSpecularScale = cacheLighting[6]
				Lighting.GlobalShadows = cacheLighting[7]
				Lighting.OutdoorAmbient = cacheLighting[8]
				Lighting.ShadowSoftness = cacheLighting[9]
				Lighting.TimeOfDay = cacheLighting[10]
				SnowEffect.Parent = nil
				for i,v in next, Skys do
					if v.Object and v.Parent then
						v.Object.Parent = v.Parent
					end
				end
				Sky.Parent = nil
				BlurEffect.Parent = nil
				ColorCorrectionEffect.Parent = nil
			end
		end,
        Default = false
	})
	Time = Shader:AddSlider({
		Name = 'Time',
		Min = 0,
		Max = 24,
		Default = 12,
		Function = function(val)
			if Shader.Enabled then 
				Lighting.TimeOfDay = val..':00:00'
			end
		end
	})
end)

run(function()
	local Blink
	local Type
	local AutoSend
	local AutoSendLength
	local oldphys, oldsend
	
	Blink = Other:AddModule({
		Name = 'Blink',
		Function = function(callback)
			if callback then
				local teleported
				Blink:Clean(lplr.OnTeleport:Connect(function()
					setfflag('S2PhysicsSenderRate', '15')
					setfflag('DataSenderRate', '60')
					teleported = true
				end))
	
				repeat
					local physicsrate, senderrate = '0', Type.Value == 'All' and '-1' or '60'
					if AutoSend.Enabled and tick() % (AutoSendLength.Value + 0.1) > AutoSendLength.Value then
						physicsrate, senderrate = '15', '60'
					end
	
					if physicsrate ~= oldphys or senderrate ~= oldsend then
						setfflag('S2PhysicsSenderRate', physicsrate)
						setfflag('DataSenderRate', senderrate)
						oldphys, oldsend = physicsrate, senderrate
					end
					
					task.wait(0.03)
				until (not Blink.Enabled and not teleported)
			else
				if setfflag then
					setfflag('S2PhysicsSenderRate', '15')
					setfflag('DataSenderRate', '60')
				end
				oldphys, oldsend = nil, nil
			end
		end
	})
	Type = Blink:AddDropdown({
		Name = 'Type',
		List = {'Movement Only', 'All'}
	})
	AutoSend = Blink:AddToggle({
		Name = 'Auto send',
		Function = function(callback)
			AutoSendLength.Frame.Visible = callback
		end
	})
	AutoSendLength = Blink:AddSlider({
		Name = 'Send threshold',
		Min = 0,
		Max = 1,
		Decimal = 100,
		Darker = true,
		Visible = false,
		Suffix = function(val)
			return val == 1 and 'second' or 'seconds'
		end
	})
end)

run(function()
    local state = getgenv().__SafeBulletTracerState
    if not state then return end

    state.Enabled = false
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local gunModule = require(player.PlayerScripts.Modules.ItemTypes.Gun)
        if state.Hooked and type(state.OriginalTracers) == "function" then
            gunModule._Tracers = state.OriginalTracers
        end
    end)
    getgenv().__SafeBulletTracerState = nil
end)

run(function()
    local Arcade
    local CollectDrops
    local AutoRespawn
    local trackedDrops = {}
    local collectUpdateInterval = 0.2
    local nextCollectUpdate = 0
    local deathConnection

    local function trackDrop(obj)
        if obj.Name == "_drop" and obj:IsA("BasePart") then
            trackedDrops[obj] = true
        end
    end

    local function untrackDrop(obj)
        trackedDrops[obj] = nil
    end

    local function disconnectDeath()
        if deathConnection then
            deathConnection:Disconnect()
            deathConnection = nil
        end
    end

    local function getRespawnRemote()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local duels = remotes and remotes:FindFirstChild("Duels")
        return duels and duels:FindFirstChild("RespawnNow")
    end

    local function setupRespawn(character)
        disconnectDeath()
        if not (Arcade and Arcade.Enabled and AutoRespawn and AutoRespawn.Enabled) then return end
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        deathConnection = humanoid.Died:Connect(function()
            task.wait()
            if Arcade.Enabled and AutoRespawn.Enabled then
                pcall(function()
                    local respawnRemote = getRespawnRemote()
                    if respawnRemote then
                        respawnRemote:FireServer()
                    end
                end)
            end
        end)
    end

    Arcade = Other:AddModule({
        Name = "Arcade",
        Function = function(callback)
            if callback then
                setupRespawn(LocalPlayer.Character)
            else
                disconnectDeath()
            end
        end
    })

    CollectDrops = Arcade:AddToggle({
        Name = "collect Drops",
        Default = true,
        Function = function() end
    })

    AutoRespawn = Arcade:AddToggle({
        Name = "Auto Respawn",
        Default = true,
        Function = function(callback)
            if callback and Arcade.Enabled then
                setupRespawn(LocalPlayer.Character)
            else
                disconnectDeath()
            end
        end
    })

    for _, obj in ipairs(workspace:GetChildren()) do
        trackDrop(obj)
    end

    mainapi:Clean(workspace.ChildAdded:Connect(trackDrop))
    mainapi:Clean(workspace.ChildRemoved:Connect(untrackDrop))
    mainapi:Clean(LocalPlayer.CharacterAdded:Connect(function(character)
        task.defer(setupRespawn, character)
    end))

    mainapi:Clean(RunService.Heartbeat:Connect(function()
        local now = os.clock()
        if now < nextCollectUpdate then return end
        nextCollectUpdate = now + collectUpdateInterval
        if not Arcade.Enabled or not CollectDrops.Enabled then return end

        local character = Players.LocalPlayer.Character
        if not character then return end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local humanoid = character:FindFirstChild("Humanoid")
        local needsHealth = humanoid and humanoid.Health < humanoid.MaxHealth

        for obj in next, trackedDrops do
            if not obj.Parent then
                trackedDrops[obj] = nil
            elseif (obj:FindFirstChild("Health") and needsHealth)
                or obj:FindFirstChild("Ammo") then
                firetouchinterest(hrp, obj, 0)
                firetouchinterest(hrp, obj, 1)
            end
        end
    end))

    mainapi:Clean(disconnectDeath)
end)

run(function()
    local HitNotifier
    local NotifySeconds
    local RandomNotifyText
    local MessageFormat
    local state = getgenv().__LionUIHitNotifierState or {
        Hooked = false,
        Enabled = false,
        OriginalDamageNumberEffect = nil,
        WrappedDamageNumberEffect = nil,
        LastNotifyKey = nil,
        LastNotifyTime = 0,
        Version = 6
    }

    if state.Version ~= 6 then
        pcall(function()
            local itemInterface = require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ItemInterface)
            local gunModule = require(LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
            local fighterController = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
            local fighter = fighterController.LocalFighter
                or fighterController:GetFighter(LocalPlayer)
            local fighterClass = fighter and getmetatable(fighter)
            fighterClass = fighterClass and fighterClass.__index
            if fighterClass
                and fighterClass._DamageNumberEffect == state.WrappedDamageNumberEffect
                and state.OriginalDamageNumberEffect then
                fighterClass._DamageNumberEffect = state.OriginalDamageNumberEffect
            end
            if state.WrappedDamageEffect and itemInterface.DamageEffect == state.WrappedDamageEffect and state.OriginalDamageEffect then
                itemInterface.DamageEffect = state.OriginalDamageEffect
            end
            if state.WrappedShootEffect and gunModule._ShootEffect == state.WrappedShootEffect and state.OriginalShootEffect then
                gunModule._ShootEffect = state.OriginalShootEffect
            end
            local damageIndicators = require(
                LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.FighterInterface.DamageIndicators
            )
            if state.WrappedDamageIndicatorCreate
                and damageIndicators.Create == state.WrappedDamageIndicatorCreate
                and state.OriginalDamageIndicatorCreate then
                damageIndicators.Create = state.OriginalDamageIndicatorCreate
            end
        end)
        state.Hooked = false
        state.OriginalDamageNumberEffect = nil
        state.WrappedDamageNumberEffect = nil
        state.LastNotifyKey = nil
        state.LastNotifyTime = 0
        state.Version = 6
    end
    getgenv().__LionUIHitNotifierState = state

    local function getCharacterFromInstance(inst)
        local current = inst
        while current and current ~= workspace do
            if current:IsA("Model") then
                local hum = current:FindFirstChildOfClass("Humanoid")
                    or current:FindFirstChild("EnemyHumanoid")
                if hum or Players:GetPlayerFromCharacter(current) then
                    return current
                end
            end
            current = current.Parent
        end
        return nil
    end

    local function getPartName(inst)
        if not inst then
            return "Unknown"
        end

        local name = inst.Name
        if name == "HitboxHead" or name == "HitboxHeadSmall" or name == "Head" then
            return "Head"
        end

        if name == "HitboxBody" or name == "HitboxBodySmall" then
            return "Body"
        end

        return name
    end

    local function safeTableGet(tab, key)
        if typeof(tab) ~= "table" then return nil end

        local okRaw, rawValue = pcall(rawget, tab, key)
        if okRaw then
            return rawValue
        end
        return nil
    end

    local function findInTableValues(tab, callback)
        local found
        pcall(function()
            for _, value in pairs(tab) do
                found = callback(value)
                if found ~= nil then
                    return
                end
            end
        end)
        return found
    end

    local function recordHitFromInstance(inst)
        local char = getCharacterFromInstance(inst)
        local plr = char and Players:GetPlayerFromCharacter(char)

        if plr == LocalPlayer then
            return
        end

        state.LastHit = {
            Player = plr,
            Character = char,
            Part = getPartName(inst),
            Time = tick()
        }
    end

    local function findHitInstance(value, depth)
        if depth > 5 then return nil end

        if typeof(value) == "Instance" then
            return getCharacterFromInstance(value) and value or nil
        end

        if typeof(value) ~= "table" then
            return nil
        end

        local direct = safeTableGet(value, utf8.char(2))
            or safeTableGet(value, utf8.char(1))
            or safeTableGet(value, "HitPart")
            or safeTableGet(value, "Hitbox")
            or safeTableGet(value, "Instance")
            or safeTableGet(value, "Part")
            or safeTableGet(value, "Target")
            or safeTableGet(value, "TargetPart")
            or safeTableGet(value, "Humanoid")
        if typeof(direct) == "Instance" and getCharacterFromInstance(direct) then
            return direct
        end

        return findInTableValues(value, function(child)
            local found = findHitInstance(child, depth + 1)
            if found then
                return found
            end
        end)
    end

    local function recordHitFromShootData(shootData)
        if typeof(shootData) ~= "table" then return end

        local inst = findHitInstance(shootData, 0)
        if inst then
            recordHitFromInstance(inst)
        end
    end

    local function getDamageValue(data, depth)
        if type(data) == "number" and data > 0 and data <= 1000 then
            return data
        end
        if depth > 6 or typeof(data) ~= "table" then
            return nil
        end

        local direct = safeTableGet(data, utf8.char(0))
            or safeTableGet(data, "Damage")
            or safeTableGet(data, "damage")
            or safeTableGet(data, "Amount")
            or safeTableGet(data, "amount")
            or safeTableGet(data, "DamageAmount")
            or safeTableGet(data, "damageAmount")
            or safeTableGet(data, "HealthRemoved")
            or safeTableGet(data, "healthRemoved")

        if type(direct) == "number" and direct > 0 then
            return direct
        end

        local nested = findInTableValues(data, function(child)
            if typeof(child) == "table" then
                local found = getDamageValue(child, depth + 1)
                if found then
                    return found
                end
            end
        end)
        if nested then return nested end

        return findInTableValues(data, function(child)
            if type(child) == "number" and child > 0 and child <= 500 then
                return child
            end
        end)
    end

    local function getDamageText(data)
        local damage = getDamageValue(data, 0)
        if type(damage) ~= "number" then
            return "?"
        end

        if damage % 1 == 0 then
            return tostring(damage)
        end

        return string.format("%.1f", damage)
    end

    local function getNotifyDuration()
        local duration = tonumber(NotifySeconds and NotifySeconds.Value) or 2
        return math.clamp(duration, 0.5, 10)
    end

    local function getWeaponName()
        local ok, name = pcall(function()
            local fighterController = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
            local fighter = fighterController.LocalFighter
                or fighterController:GetFighter(LocalPlayer)
            local item = fighter and fighter.EquippedItem
            if not item then return "Unknown" end
            if type(item.Get) == "function" then
                return item:Get("Name")
                    or item:Get("ItemName")
                    or item:Get("WeaponName")
            end
            return item.Name or (item.Info and item.Info.Name)
        end)
        return ok and tostring(name or "Unknown") or "Unknown"
    end

    local function buildMessage(playerName, damage, part)
        local custom = MessageFormat and tostring(MessageFormat.Value or "") or ""
        local format = custom ~= ""
            and custom
            or (RandomNotifyText and RandomNotifyText.Value)
            or "Hit {NAME} for {DMG} in the {PART}"
        local weapon = getWeaponName()
        return format
            :gsub("{NAME}", playerName)
            :gsub("{DMG}", damage)
            :gsub("{PART}", part)
            :gsub("{WEAPON}", weapon)
            :gsub("{player}", playerName)
            :gsub("{damage}", damage)
            :gsub("{part}", part)
            :gsub("{weapon}", weapon)
    end

    local notifyQueue = state.NotifyQueue or {}
    state.NotifyQueue = notifyQueue

    local function flushHitNotify(text, duration)
        if type(LionLibrary) == "table" and type(LionLibrary.Notify) == "function" then
            local ok, err = pcall(function()
                LionLibrary:Notify(text, duration)
            end)

            if ok then
                return
            end

            
        end

        
        mainapi:SafeNotify({
            Text = text,
            Duration = duration
        })
    end

    task.spawn(function()
        while true do
            local item = table.remove(notifyQueue, 1)
            if item then
                flushHitNotify(item.Text, item.Duration)
                task.wait(0.02)
            else
                task.wait(0.25)
            end
        end
    end)

    local function sendHitNotify(text, duration)
        table.insert(notifyQueue, {
            Text = text,
            Duration = duration
        })
    end

    local function findDamageTarget(value, depth)
        if depth > 6 then return nil end
        if typeof(value) == "Instance" then
            local character = getCharacterFromInstance(value)
            if character and character ~= LocalPlayer.Character then
                return value, character
            end
            return nil
        end
        if typeof(value) ~= "table" then return nil end

        local found = findInTableValues(value, function(child)
            local part, character = findDamageTarget(child, depth + 1)
            if part then return {part, character} end
        end)
        if found then return found[1], found[2] end
        return nil
    end

    local function notifyDamageIndicator(...)
        local args = table.pack(...)
        local damage
        local hitPart
        local character

        for index = 2, args.n do
            local value = args[index]
            damage = damage or getDamageValue(value, 0)
            if not hitPart then
                hitPart, character = findDamageTarget(value, 0)
            end
        end

        if not damage or not hitPart or not character then return end
        local player = Players:GetPlayerFromCharacter(character)
        if player == LocalPlayer then return end

        local playerName = player and player.Name or character.Name
        local part = getPartName(hitPart)
        local damageText = damage % 1 == 0 and tostring(damage) or string.format("%.1f", damage)
        local text = buildMessage(playerName, damageText, part)
        local key = playerName .. "|" .. part .. "|" .. tostring(damage)
        local now = tick()

        if state.LastNotifyKey == key and now - (state.LastNotifyTime or 0) < 0.08 then
            return
        end

        state.LastNotifyKey = key
        state.LastNotifyTime = now

        sendHitNotify(text, getNotifyDuration())
    end

    local function isLocalItem(self)
        local clientItem = self and (self.ClientItem or self)
        local fighter = clientItem and clientItem.ClientFighter or (self and self.ClientFighter)
        if not fighter then
            return false
        end

        if fighter.IsLocalPlayer == true or fighter.Player == LocalPlayer then
            return true
        end

        local ok, controller = pcall(function()
            return require(LocalPlayer.PlayerScripts.Controllers.FighterController)
        end)

        if ok and controller then
            if controller.LocalFighter == fighter then
                return true
            end

            if type(controller.GetFighter) == "function" then
                local success, localFighter = pcall(controller.GetFighter, controller, LocalPlayer)
                if success and localFighter == fighter then
                    return true
                end
            end
        end

        return false
    end

    local function installHooks()
        local ok, err = pcall(function()
            local fighterController = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
            local fighter = fighterController.LocalFighter
                or fighterController:GetFighter(LocalPlayer)
            local fighterClass = fighter and getmetatable(fighter)
            fighterClass = fighterClass and fighterClass.__index
            if type(fighterClass) ~= "table" or type(fighterClass._DamageNumberEffect) ~= "function" then
                error("_DamageNumberEffect unavailable")
            end

            if state.WrappedDamageNumberEffect
                and fighterClass._DamageNumberEffect == state.WrappedDamageNumberEffect then
                state.Hooked = true
                return
            end

            state.OriginalDamageNumberEffect = fighterClass._DamageNumberEffect
            state.WrappedDamageNumberEffect = function(...)
                if state.Enabled then
                    pcall(notifyDamageIndicator, ...)
                end
                local result = table.pack(state.OriginalDamageNumberEffect(...))
                return unpack(result, 1, result.n)
            end

            fighterClass._DamageNumberEffect = state.WrappedDamageNumberEffect
        end)

        if not ok then
            warn("[Hit Notifier] Hook failed:", err)
            return false
        end

        state.Hooked = true
        
        return true
    end

    HitNotifier = Other:AddModule({
        Name = "Hit Notifier",
        Function = function(callback)
            state.Enabled = callback == true
            
            if state.Enabled then
                installHooks()
            end
        end
    })

    mainapi:Clean(function()
        state.Enabled = false
        pcall(function()
            local fighterController = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
            local fighter = fighterController.LocalFighter
                or fighterController:GetFighter(LocalPlayer)
            local fighterClass = fighter and getmetatable(fighter)
            fighterClass = fighterClass and fighterClass.__index
            if fighterClass
                and fighterClass._DamageNumberEffect == state.WrappedDamageNumberEffect
                and state.OriginalDamageNumberEffect then
                fighterClass._DamageNumberEffect = state.OriginalDamageNumberEffect
            end
        end)
        state.Hooked = false
    end)

    NotifySeconds = HitNotifier:AddSlider({
        Name = "notify duration",
        Min = 1,
        Max = 10,
        Default = 1,
        Suffix = "s"
    })

    RandomNotifyText = HitNotifier:AddDropdown({
        Name = "random notify text",
        List = {
            "Hit {NAME} for {DMG} in the {PART}",
            "Hit {NAME} for {DMG} with {WEAPON}",
            "{NAME} took {DMG} damage in the {PART}",
            "{WEAPON} hit {NAME} for {DMG}",
        },
        Default = "Hit {NAME} for {DMG} in the {PART}"
    })

    MessageFormat = HitNotifier:AddInputBox({
        Name = "add custom text",
        Default = "",
        Placeholder = "ex: {NAME}, {DMG}, {PART}"
    })

    HitNotifier:AddLabel({Text = "ALL FORMATTING:"})
    HitNotifier:AddLabel({Text = "{NAME}, {DMG}, {PART}, {WEAPON}"})
end)

run(function()
    local uninject

    uninject = Other:AddModule({
        Name = "Uninject",
        Function = function(callback)
            if callback then
                mainapi:Uninject()
            end
        end
    })
end)

shared.Modern = mainapi
mainapi:StartBackgroundLoad()

-- Auto config application is disabled; settings should not be loaded or enabled at startup.
-- ApplyConfig()
task.defer(function()
    _savingConfig = false
end)

mainapi:Clean(LocalPlayer.AncestryChanged:Connect(function()
	if not LocalPlayer:IsDescendantOf(game) then
		setfflag('SimEnableStepPhysics', 'False')
		setfflag('SimEnableStepPhysicsSelective', 'False')
	end
end))

mainapi:Clean(LocalPlayer.AncestryChanged:Connect(function()

	if setfflag then
		setfflag("S2PhysicsSenderRate","15")
		setfflag("DataSenderRate","60")
	end

	if Blink then
		Blink.Enabled = false
	end

end))

task.defer(function()
	local f

	for i, v in next, getgc(true) do
		if typeof(v) == "table" then
			if rawget(v, "O") and rawget(v, "em") and typeof(rawget(v, "O")) == "function" then
				f = rawget(v, "O")
			end
		end
	end

	if not f or not hookfunction or not newcclosure or not checkcaller then
		return
	end

	local old

	local success, hookResult = pcall(function()
		return hookfunction(f, newcclosure(function(...)
			if checkcaller() and old then
				return old(...)
			end

			return function(...) end
		end))
	end)

	if success then
		old = hookResult
	end
end)

return mainapi

