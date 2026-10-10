if not game:IsLoaded() then
	game.Loaded:Wait()
end

local SCRIPT_VERSION = "Beta"
local UI_SOURCE_URL = "https://pastefy.app/9vgkDsd2/raw"
local INSTANCE_KEY = "__Slayer2Hub"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local PathfindingService = game:GetService("PathfindingService")

local LocalPlayer = Players.LocalPlayer
local GlobalEnv = getgenv()

if GlobalEnv[INSTANCE_KEY] and type(GlobalEnv[INSTANCE_KEY].Unload) == "function" then
	local ok, err = pcall(GlobalEnv[INSTANCE_KEY].Unload)
	if not ok then
		warn("[Spryzen Hub] previous instance unload failed: " .. tostring(err))
	end
end

local Hub = {
	CLOUD_URL = "http://78.154.103.47:10872",
	CLOUD_KEY = "d96891068ec57aa5a608f0de8eb00d3f57fea273e07c8191",
	WORLD_CONFIG = "Ouroboros/Slayer 2",
	MENU_CONFIG = "Ouroboros/Slayer 2 Menu",
	DUNGEON_CONFIG = "Ouroboros/Slayer 2 Dungeons",
	FINAL_CONFIG = "Ouroboros/Slayer 2 Final Selection",
	PVP_CONFIG = "Ouroboros/Slayer 2 PvP",
	Notify = function() end,
	Started = false,
}

function Hub.awaitStart()
	while not Hub.Started do
		task.wait()
	end
end

function Hub.loadUi()
	local guard = Hub.Guard
	if guard.Tripped or guard.scan() then
		guard.trip()
		return nil, "tamper detected"
	end
	local ok, library = pcall(function()
		return guard.Loadstring(game:HttpGet(UI_SOURCE_URL))()
	end)
	if not ok or type(library) ~= "table" then
		return nil, library
	end
	return library
end

function Hub.blockedExecutor()
	local identify = identifyexecutor or getexecutorname
	local ok, name = pcall(function()
		return type(identify) == "function" and identify() or nil
	end)
	name = ok and type(name) == "string" and name or ""
	local lowered = string.lower(name)
	for _, blocked in ipairs({ "solara", "xeno", "madium" }) do
		if string.find(lowered, blocked, 1, true) then
			return name
		end
	end
	return nil
end

Hub.Guard = {
	KICK_MESSAGE = "no",
	GLOBAL_KEY = "__Slayer2Guard",
	INTERVAL = 3,
	Loadstring = loadstring,
	GenvLoadstring = GlobalEnv.loadstring,
	Kick = LocalPlayer.Kick,
	Info = debug.info,
	IsLua = type(islclosure) == "function" and islclosure or nil,
	IsHooked = type(isfunctionhooked) == "function" and isfunctionhooked or nil,
	Core = { debug.info, pcall, typeof, tostring, rawequal },
	Tripped = false,
}

function Hub.Guard.isLua(fn)
	local guard = Hub.Guard
	local ok, source = pcall(guard.Info, fn, "s")
	if ok and source ~= "[C]" then
		return true
	end
	if guard.IsLua then
		local checked, lua = pcall(guard.IsLua, fn)
		if checked and lua == true then
			return true
		end
	end
	return false
end

function Hub.Guard.isHooked(fn)
	local guard = Hub.Guard
	if type(fn) ~= "function" or not guard.IsHooked then
		return false
	end
	local ok, hooked = pcall(guard.IsHooked, fn)
	return ok and hooked == true
end

function Hub.Guard.httpFunctions()
	local list = {}
	local ok, httpGet = pcall(function()
		return game.HttpGet
	end)
	if ok and type(httpGet) == "function" then
		table.insert(list, httpGet)
	end
	for _, fn in ipairs({ request, http_request, type(syn) == "table" and syn.request or nil }) do
		if type(fn) == "function" then
			table.insert(list, fn)
		end
	end
	return list
end

function Hub.Guard.scan()
	local guard = Hub.Guard
	for _, fn in ipairs(guard.Core) do
		if (guard.Strict and guard.isLua(fn)) or guard.isHooked(fn) then
			return true
		end
	end
	local native = guard.Loadstring
	if type(native) ~= "function" then
		return false
	end
	if GlobalEnv.loadstring ~= guard.GenvLoadstring then
		return true
	end
	if guard.isHooked(native) or guard.isHooked(guard.Kick) then
		return true
	end
	if guard.Strict and guard.isLua(native) then
		return true
	end
	for _, fn in ipairs(guard.httpFunctions()) do
		if guard.isHooked(fn) then
			return true
		end
	end
	local nonce = tostring(math.random(1e6, 9e6)) .. tostring(os.clock())
	local loaded, chunk = pcall(native, "return ...")
	if loaded and type(chunk) == "function" then
		if not guard.isLua(chunk) then
			return true
		end
		local ran, echoed = pcall(chunk, nonce)
		if ran and echoed ~= nonce then
			return true
		end
	end
	return false
end

function Hub.Guard.trip()
	local guard = Hub.Guard
	if guard.Tripped then
		return
	end
	guard.Tripped = true
	pcall(guard.Kick, LocalPlayer, guard.KICK_MESSAGE)
	task.delay(2, function()
		local instance = GlobalEnv[INSTANCE_KEY]
		if type(instance) == "table" and type(instance.Unload) == "function" then
			pcall(instance.Unload)
		end
	end)
end

function Hub.Guard.start()
	local guard = Hub.Guard
	guard.Strict = Hub.blockedExecutor() == nil
	local previous = GlobalEnv[guard.GLOBAL_KEY]
	if type(previous) == "thread" then
		pcall(task.cancel, previous)
	end
	if guard.scan() then
		guard.trip()
		return true
	end
	GlobalEnv[guard.GLOBAL_KEY] = task.spawn(function()
		while not guard.Tripped do
			task.wait(guard.INTERVAL)
			if guard.scan() then
				guard.trip()
			end
		end
	end)
	return false
end

function Hub.gameModule(...)
	local node = game:GetService("ReplicatedStorage")
	for _, name in ipairs({ ... }) do
		node = node and node:FindFirstChild(name)
	end
	if not node then
		return nil
	end
	local ok, result = pcall(require, node)
	return ok and type(result) == "table" and result or nil
end

function Hub.browseServers(browser)
	local result, failure = nil, nil
	local updated = browser.Updated:Connect(function(state)
		if type(state) == "table" and state.Kind == "Browse" and state.PlaceId == game.PlaceId then
			result = state.Servers
		end
	end)
	local failed = browser.Failed:Connect(function(reason)
		failure = tostring(reason)
	end)
	local ok, err = pcall(browser.Browse, game.PlaceId)
	local deadline = os.clock() + 10
	while ok and not result and not failure and os.clock() < deadline do
		task.wait(0.1)
	end
	updated:Disconnect()
	failed:Disconnect()
	if not ok then
		return nil, tostring(err)
	end
	if type(result) ~= "table" then
		return nil, failure or "the server list did not load"
	end
	return result
end

function Hub.patchServerButtons(window)
	local teleporter = Hub.gameModule("CAM", "Client", "Modules", "Teleporter")
	local browser = Hub.gameModule("CAM", "Client", "Controllers", "ServerBrowserController")
	if not teleporter or not browser then
		return
	end

	local function notify(title, text, kind)
		pcall(window.Notify, window, { Title = title, Content = text, Type = kind, Icon = "server", Duration = 4 })
	end

	local function finish(title, ok, success, reason)
		if not ok then
			notify(title .. " failed", tostring(success), "Error")
		elseif not success then
			notify(title .. " failed", reason == "Busy" and "Already teleporting" or tostring(reason or "request denied"), "Warning")
		end
	end

	local function hop(title, pick)
		task.spawn(function()
			local servers, err = Hub.browseServers(browser)
			if not servers then
				notify(title .. " failed", "Could not load the server list: " .. tostring(err), "Error")
				return
			end
			local candidates = {}
			for _, server in ipairs(servers) do
				if type(server) == "table" and server.JobId ~= game.JobId and not browser.IsCurrentServer(server) then
					local players, capacity = tonumber(server.Players), tonumber(server.MaxPlayers)
					if players and capacity and players < capacity then
						table.insert(candidates, server)
					end
				end
			end
			if #candidates == 0 then
				notify(title .. " failed", "No other open server found", "Warning")
				return
			end
			local target = pick(candidates)
			notify(title, string.format("Joining %s (%d/%d)", tostring(target.Name), target.Players, target.MaxPlayers))
			finish(title, pcall(browser.Join, target))
		end)
	end

	function window:Rejoin()
		task.spawn(function()
			notify("Rejoin", "Rejoining this server")
			finish("Rejoin", pcall(teleporter.Request, {
				placeId = game.PlaceId,
				jobId = game.JobId,
				allowFallback = false,
			}, {
				Title = "Rejoining",
				SubTitle = browser.OwnServerName(),
			}))
		end)
	end

	function window:ServerHop()
		hop("Server hop", function(list)
			return list[math.random(1, #list)]
		end)
	end

	function window:JoinLowestServer()
		hop("Join lowest server", function(list)
			table.sort(list, function(a, b)
				return a.Players < b.Players
			end)
			return list[1]
		end)
	end
end

function Hub.createWindow(Airflow, folder, pages)
	local blocked = Hub.blockedExecutor()
	local window = Airflow:CreateWindow({
		Name = "Spryzen Hub",
		Icon = "swords",
		LoadingSubtitle = SCRIPT_VERSION,
		DefaultTheme = "Mono",
		UnsupportedExecutor = blocked and {
			Text = blocked .. " is not supported. Spryzen Hub may not work correctly on it.",
		} or nil,
		Disclaimer = {
			Id = "risk-v1",
			Title = "Use at your own risk",
			Icon = "shield-alert",
			Color = Color3.fromRGB(240, 176, 108),
			Text = "This script is now risky. By using it, you accept the consequences of possibly being kicked or banned for 24 hours.",
			AcceptText = "I accept",
		},
		ToggleUIKeybind = "RightControl",
		ToggleButton = {
			Platform = "Mobile",
		},
		ConfigurationSaving = {
			Enabled = true,
			FolderName = folder,
			FileName = "default",
		},
		Home = {
			Title = "Welcome to Spryzen Hub!",
			Tier = SCRIPT_VERSION,
			TierIcon = "swords",
			SupportedExecutors = blocked and {} or nil,
			Pages = pages,
		},
	})
	local ok, err = pcall(Hub.patchServerButtons, window)
	if not ok then
		warn("[Spryzen Hub] server buttons patch failed: " .. tostring(err))
	end
	return window
end

function Hub.addInterfaceControls(box, Window)
	box:CreateKeybind({
		Name = "Toggle UI",
		CurrentKeybind = "RightControl",
		Flag = "ToggleUIKey",
		Callback = function() end,
		OnChanged = function(key)
			Window:SetKeybind(key)
			if type(Window._autoSave) == "function" then
				Window:_autoSave()
			end
		end,
	})

	box:CreateDropdown({
		Name = "Toggle button",
		Options = { "Mobile only", "Mobile & PC" },
		CurrentOption = "Mobile only",
		MultipleOptions = false,
		AllowNone = false,
		Flag = "ToggleButtonPlatform",
		Callback = function(option)
			if type(Window.SetToggleButtonPlatform) == "function" then
				Window:SetToggleButtonPlatform(option == "Mobile & PC" and "Both" or "Mobile")
			end
		end,
	})
end

function Hub.addLinkButtons(box, Airflow)
	local function copyUrl(label, url)
		local clipboard = setclipboard or toclipboard or set_clipboard or writeclipboard
		if type(clipboard) ~= "function" then
			local notify = Airflow and Airflow.Notify
			if type(notify) == "function" then
				pcall(notify, Airflow, {
					Title = "Spryzen Hub",
					Content = "Clipboard copy is not supported by this executor.",
					Type = "Warning",
					Icon = "copy",
					Duration = 4,
				})
			end
			return
		end

		local ok, err = pcall(clipboard, url)
		local notify = Airflow and Airflow.Notify
		if type(notify) == "function" then
			pcall(notify, Airflow, {
				Title = "Spryzen Hub",
				Content = ok and (label .. " copied to clipboard.") or ("Copy failed: " .. tostring(err)),
				Type = ok and "Success" or "Error",
				Icon = "copy",
				Duration = 4,
			})
		elseif type(Hub.Notify) == "function" then
			pcall(Hub.Notify, {
				Title = "Spryzen Hub",
				Content = ok and (label .. " copied to clipboard.") or ("Copy failed: " .. tostring(err)),
				Type = ok and "Success" or "Error",
				Icon = "copy",
				Duration = 4,
			})
		end
	end

	box:CreateButton({
		Name = "Copy Follow Link",
		Icon = "heart",
		Callback = function()
			copyUrl("Follow link", "https://rscripts.net/@_LSS")
		end,
	})

	box:CreateButton({
		Name = "Copy Join Hub Link",
		Icon = "link",
		Callback = function()
			copyUrl("Join Hub link", "https://rscripts.net/hub/lss")
		end,
	})
end

function Hub.addUnloadButton(box, Airflow, unload)
	box:CreateButton({
		Name = "Unload",
		Icon = "power",
		Callback = function()
			Airflow:Confirm({
				Title = "Unload Spryzen Hub?",
				Content = "Every feature stops and the window closes.",
				Icon = "power",
				ConfirmText = "Unload",
				CancelText = "Keep",
				Callback = unload,
			})
		end,
	})
end

function Hub.isMenuPlace()
	local cam = ReplicatedStorage:FindFirstChild("CAM")
	local module = cam and cam:FindFirstChild("Worlds")
	if not module then
		return false
	end
	local ok, worlds = pcall(require, module)
	if not ok or type(worlds) ~= "table" or type(worlds.IsMenuPlace) ~= "function" then
		return false
	end
	local okMenu, isMenu = pcall(worlds.IsMenuPlace)
	return okMenu and isMenu == true
end

function Hub.isDungeonPlace()
	return Workspace:GetAttribute("Minigame") == "Ouwigahara"
end

function Hub.isFinalSelectionPlace()
	return Workspace:GetAttribute("MinigameKey") == "FinalSelection"
end

function Hub.isMinigamePlace()
	return Workspace:GetAttribute("Minigame") ~= nil or Workspace:GetAttribute("MinigameKey") ~= nil
end

if Hub.Guard.start() then
	return
end

local function runMainMenu()
	local JOIN_RETRY = 10
	local JOIN_TELEPORT_WAIT = 30
	local QUEUE_POLL = 1
	local QUEUE_CONFIRM = 5
	local QUEUE_RETRY = 10
	local QUEUE_REQUEUE_GAP = 3
	local MATCH_WAIT = 60
	local CLAN_ROLL_GAP = 0.5
	local CLAN_RESULT_WAIT = 5
	local CLAN_RETRY = 3

	local function loadBinds(spec)
		local binds, missing = {}, {}
		for name, segments in pairs(spec) do
			local node = ReplicatedStorage
			for _, segment in ipairs(segments) do
				node = node and node:FindFirstChild(segment)
			end
			local ok, result = false, "not found"
			if node then
				ok, result = pcall(require, node)
			end
			if ok then
				binds[name] = result
			else
				table.insert(missing, name .. ": " .. tostring(result))
			end
		end
		return binds, missing
	end

	local Bind, missing = loadBinds({
		Worlds = { "CAM", "Worlds" },
		Teleporter = { "CAM", "Client", "Modules", "Teleporter" },
		HudGrid = { "CAM", "HudGrid" },
		Validators = { "CAM", "Global", "MainMenuRelay", "Validators" },
		QueueSignal = { "Communication", "ServerAndClient", "Signals", "QueueSignal" },
		QueuWatcher = { "MenuComponents", "Misc", "QueuWatcher" },
	})
	if #missing > 0 then
		error("[Spryzen Hub] main menu bindings unavailable:\n" .. table.concat(missing, "\n"), 0)
	end

	local ClanBind, clanMissing = loadBinds({
		Clans = { "CAM", "Clans" },
		Spinners = { "CAM", "Global", "Spinners" },
		SpinBalance = { "CAM", "Global", "SpinBalance" },
		Utility = { "CAM", "Global", "Utility" },
		SignalFunction = { "Communication", "ServerAndClient", "Signals", "SignalFunction" },
		SignalEvent = { "Communication", "ServerAndClient", "Signals", "SignalEvent" },
	})
	if #clanMissing > 0 then
		warn("[Spryzen Hub] clan roll bindings unavailable:\n" .. table.concat(clanMissing, "\n"))
		ClanBind = nil
	end

	local Settings = { AutoJoin = false, World = nil, JoinDelay = 5, JoinPrivate = false, AutoQueue = false, Mode = nil, Fill = true, Ranked = false, AntiAfk = true, AutoRollClan = false, DesiredClans = {}, MinRarity = nil }
	local Join = { Status = "Off", Tone = "Muted", Inputs = {} }
	local Queue = { Status = "Off", Tone = "Muted", SentAt = nil, RetryAt = 0, MatchedAt = nil, Args = nil }
	local Roll = { Status = "Off", Tone = "Muted", Count = 0, RetryAt = 0, ClanRank = {}, RarityRank = {}, RarityName = {}, ClanOptions = {}, RarityOptions = {} }
	local cleanup = {}

	local worldOptions = {}
	for name, world in pairs(Bind.Worlds.Grid) do
		if type(world) == "table" and not world.Ignore then
			local ok, visible = pcall(Bind.Worlds.CanSee, LocalPlayer, world)
			if ok and visible then
				table.insert(worldOptions, name)
			end
		end
	end
	table.sort(worldOptions)
	Settings.World = worldOptions[1]

	local modes, modeOptions = {}, {}
	for name, mode in pairs(Bind.HudGrid.ByName) do
		if type(mode) == "table" and not mode.Ignore then
			local label = type(mode.Title) == "string" and mode.Title or name
			modes[label] = {
				Name = name,
				Order = tonumber(mode.Order) or math.huge,
				Fill = mode.Fill == true,
				Ranked = mode.Ranked == true,
				RankedOnly = mode.RankedOnly == true,
			}
			table.insert(modeOptions, label)
		end
	end
	table.sort(modeOptions, function(a, b)
		if modes[a].Order ~= modes[b].Order then
			return modes[a].Order < modes[b].Order
		end
		return a < b
	end)
	Settings.Mode = modeOptions[1]

	function Join.set(text, tone)
		Join.Status, Join.Tone = text, tone or "Accent"
	end

	function Queue.set(text, tone)
		Queue.Status, Queue.Tone = text, tone or "Accent"
	end

	local function privateOwner()
		local input = Join.Inputs.Owner
		local name = string.match(input and input:Get() or "", "^%s*(.-)%s*$")
		return name ~= "" and name or nil
	end

	function Join.request()
		local world = Settings.World and Bind.Worlds.Grid[Settings.World]
		if type(world) ~= "table" then
			Join.set("Pick a world", "Warning")
			return false
		end
		local request = { placeId = world.Id }
		local label = Settings.World
		if Settings.JoinPrivate then
			local owner = privateOwner()
			if not owner then
				Join.set("Enter the private server owner's username", "Warning")
				return false
			end
			request.privateOwner = owner
			label ..= ", " .. owner .. "'s private server"
		end
		Join.set("Joining " .. label)
		local ok, success, reason = pcall(Bind.Teleporter.Request, request)
		if not ok then
			Join.set("Join error: " .. tostring(success), "Error")
			return false
		end
		if success then
			Join.set("Teleporting to " .. label, "Success")
			return true
		end
		if reason == "Busy" then
			Join.set("Already teleporting")
		else
			Join.set("Join denied: " .. tostring(reason), "Error")
		end
		return false
	end

	function Queue.args()
		local mode = modes[Settings.Mode]
		if not mode then
			return nil
		end
		return mode.Name, mode.Fill and Settings.Fill, mode.RankedOnly or (mode.Ranked and Settings.Ranked)
	end

	function Queue.label()
		local _, fill, ranked = Queue.args()
		local parts = { tostring(Settings.Mode) }
		if ranked then
			table.insert(parts, "Ranked")
		end
		if modes[Settings.Mode] and modes[Settings.Mode].Fill then
			table.insert(parts, fill and "Fill On" or "Fill Off")
		end
		return table.concat(parts, ", ")
	end

	function Queue.configChanged()
		if not Queue.Args or not Bind.QueuWatcher.Get() then
			return
		end
		local name, fill, ranked = Queue.args()
		local sent = Queue.Args
		if name ~= sent[1] or fill ~= sent[2] or ranked ~= sent[3] then
			Queue.Args = nil
			Bind.QueueSignal.ToServer("Cancel")
		end
	end

	function Queue.tick()
		local now = os.clock()
		if Queue.MatchedAt then
			if now - Queue.MatchedAt < MATCH_WAIT then
				return
			end
			Queue.MatchedAt = nil
		end
		local startedAt = Bind.QueuWatcher.Get()
		if startedAt then
			Queue.SentAt = nil
			Queue.set("In queue for " .. Queue.label() .. ", " .. math.floor(math.max(Workspace:GetServerTimeNow() - startedAt, 0)) .. "s", "Success")
			return
		end
		if Queue.SentAt then
			if now - Queue.SentAt < QUEUE_CONFIRM then
				return
			end
			Queue.SentAt = nil
			Queue.set("Queue request was not accepted, retrying", "Warning")
			Queue.RetryAt = now + QUEUE_RETRY
		end
		if now < Queue.RetryAt then
			return
		end
		local name, fill, ranked = Queue.args()
		if not name then
			Queue.set("Pick a game mode", "Warning")
			return
		end
		local okCheck, valid, reason = pcall(Bind.Validators.HudGamemode, name, LocalPlayer, ranked)
		if okCheck and valid ~= true then
			Queue.set("Can't queue: " .. tostring(reason or "requirements not met"), "Warning")
			Queue.RetryAt = now + QUEUE_RETRY
			return
		end
		Bind.QueueSignal.ToServer("Queue", name, fill, ranked)
		Queue.Args = { name, fill, ranked }
		Queue.SentAt = now
		Queue.set("Queueing " .. Queue.label())
	end

	local started = Bind.QueuWatcher.Started:Connect(function()
		Queue.SentAt = nil
	end)
	local ended = Bind.QueuWatcher.Ended:Connect(function(reason)
		Queue.Args = nil
		if reason == "Matched" then
			Queue.MatchedAt = os.clock()
			Queue.set("Match found, teleporting", "Success")
		else
			Queue.RetryAt = os.clock() + QUEUE_REQUEUE_GAP
			Queue.set("Queue ended" .. (reason and (": " .. tostring(reason)) or "") .. ", requeueing", "Warning")
		end
	end)
	table.insert(cleanup, function()
		started:Disconnect()
		ended:Disconnect()
	end)

	local joinThread = task.spawn(function()
		while true do
			if Settings.AutoJoin then
				local waitStart = os.clock()
				while Settings.AutoJoin and os.clock() - waitStart < Settings.JoinDelay do
					Join.set("Joining in " .. math.ceil(Settings.JoinDelay - (os.clock() - waitStart)) .. "s")
					task.wait(0.25)
				end
				if Settings.AutoJoin then
					local sent = Join.request()
					local resumeAt = os.clock() + (sent and JOIN_TELEPORT_WAIT or JOIN_RETRY)
					while Settings.AutoJoin and os.clock() < resumeAt do
						task.wait(0.25)
					end
				end
			else
				task.wait(0.25)
			end
		end
	end)

	local queueThread = task.spawn(function()
		while true do
			if Settings.AutoQueue then
				if Settings.AutoJoin then
					Queue.set("Paused while Auto Join World is on", "Warning")
				else
					local ok, err = pcall(Queue.tick)
					if not ok then
						Queue.set("Queue error, see console", "Error")
						warn("[Spryzen Hub] auto queue error: " .. tostring(err))
					end
				end
			end
			task.wait(QUEUE_POLL)
		end
	end)

	table.insert(cleanup, function()
		task.cancel(joinThread)
		task.cancel(queueThread)
	end)

	local afkConnection = nil
	local function setAntiAfk(enabled)
		if enabled and not afkConnection then
			afkConnection = LocalPlayer.Idled:Connect(function()
				pcall(function()
					VirtualUser:CaptureController()
					VirtualUser:ClickButton2(Vector2.zero)
				end)
			end)
		elseif not enabled and afkConnection then
			afkConnection:Disconnect()
			afkConnection = nil
		end
	end
	table.insert(cleanup, function()
		setAntiAfk(false)
	end)

	if ClanBind then
		for _, tier in ipairs(ClanBind.Clans.Rarities) do
			Roll.RarityRank[tier.name] = tier.rarity
			Roll.RarityName[tier.rarity] = tier.name
			table.insert(Roll.RarityOptions, tier.name)
			for name in pairs(ClanBind.Clans.GetByRarity(tier.rarity) or {}) do
				Roll.ClanRank[name] = tier.rarity
				table.insert(Roll.ClanOptions, name)
			end
		end
		table.sort(Roll.ClanOptions, function(a, b)
			if Roll.ClanRank[a] ~= Roll.ClanRank[b] then
				return Roll.ClanRank[a] > Roll.ClanRank[b]
			end
			return a < b
		end)
	end

	function Roll.set(text, tone)
		Roll.Status, Roll.Tone = text, tone or "Accent"
	end

	function Roll.stop(text, tone)
		Settings.AutoRollClan = false
		local flag = Roll.Flags and Roll.Flags.MenuAutoRollClan
		if flag and flag:Get() then
			flag:Set(false)
		end
		Roll.set(text, tone)
	end

	function Roll.data()
		local ok, data = pcall(ClanBind.Utility.GetData, LocalPlayer, true)
		return ok and typeof(data) == "Instance" and data or nil
	end

	function Roll.current()
		local data = Roll.data()
		local clan = data and data:FindFirstChild("Clan")
		return clan and clan.Value ~= "" and clan.Value or nil
	end

	function Roll.spins()
		local data = Roll.data()
		if not data then
			return 0
		end
		local ok, total = pcall(ClanBind.SpinBalance.Total, data, true)
		return ok and tonumber(total) or 0
	end

	function Roll.describe(name)
		local rarity = Roll.RarityName[Roll.ClanRank[name]]
		return rarity and (name .. " (" .. rarity .. ")") or tostring(name)
	end

	function Roll.hasTargets()
		return #Settings.DesiredClans > 0 or Settings.MinRarity ~= nil
	end

	function Roll.matches(name)
		if not name then
			return false
		end
		if table.find(Settings.DesiredClans, name) then
			return true
		end
		local minimum = Settings.MinRarity and Roll.RarityRank[Settings.MinRarity]
		return minimum ~= nil and (Roll.ClanRank[name] or 0) >= minimum
	end

	function Roll.once()
		local ok, result = pcall(ClanBind.SignalFunction.ToServer, "ClanSpin")
		if not ok then
			return nil, "Roll error: " .. tostring(result)
		end
		if type(result) ~= "string" or result == "" then
			return nil, "Roll was not accepted"
		end
		ClanBind.SignalEvent.ToServer("ClanSpinComplete")
		local deadline = os.clock() + CLAN_RESULT_WAIT
		while os.clock() < deadline and (Roll.current() ~= result or LocalPlayer:GetAttribute("PendingClanSpin") ~= nil) do
			task.wait(0.1)
		end
		return result
	end

	function Roll.tick()
		if not Roll.hasTargets() then
			Roll.set("Pick desired clans or a minimum rarity", "Warning")
			return
		end
		local current = Roll.current()
		if Roll.matches(current) then
			Roll.stop("Got " .. Roll.describe(current) .. (Roll.Count > 0 and (" after " .. Roll.Count .. " rolls") or ""), "Success")
			return
		end
		if os.clock() < Roll.RetryAt then
			return
		end
		if LocalPlayer:GetAttribute("PendingClanSpin") ~= nil or LocalPlayer:GetAttribute("SpinnerOpen") ~= nil then
			Roll.set("Waiting for the open roll to finish", "Warning")
			return
		end
		local cost = tonumber(ClanBind.Spinners.Clan.Cost) or 1
		if Roll.spins() < cost then
			Roll.stop("Out of spins" .. (current and (", kept " .. Roll.describe(current)) or ""), "Warning")
			return
		end
		Roll.set("Rolling")
		local result, err = Roll.once()
		if not result then
			Roll.RetryAt = os.clock() + CLAN_RETRY
			Roll.set(err .. ", retrying", "Warning")
			return
		end
		Roll.Count += 1
		if Roll.matches(result) then
			Roll.stop("Got " .. Roll.describe(result) .. " after " .. Roll.Count .. " rolls", "Success")
		else
			Roll.set("Rolled " .. Roll.describe(result) .. ", " .. Roll.Count .. " rolls, " .. Roll.spins() .. " spins left")
		end
	end

	if ClanBind then
		local rollThread = task.spawn(function()
			while true do
				if Settings.AutoRollClan then
					local ok, err = pcall(Roll.tick)
					if not ok then
						Roll.stop("Roll error, see console", "Error")
						warn("[Spryzen Hub] auto roll clan error: " .. tostring(err))
					end
					task.wait(CLAN_ROLL_GAP)
				else
					task.wait(0.25)
				end
			end
		end)
		table.insert(cleanup, function()
			task.cancel(rollThread)
		end)
	end

	local Airflow, uiError = Hub.loadUi()
	if not Airflow then
		for _, stop in ipairs(cleanup) do
			pcall(stop)
		end
		error("[Spryzen Hub] failed to load UI library: " .. tostring(uiError), 0)
	end

	local MenuPage = nil
	local Window = Hub.createWindow(Airflow, Hub.MENU_CONFIG, {
		{
			Name = "Main Menu",
			Icon = "play",
			Build = function(page)
				MenuPage = page
			end,
		},
	})

	local unloaded = false
	local function unload()
		if unloaded then
			return
		end
		unloaded = true
		Settings.AutoJoin, Settings.AutoQueue, Settings.AutoRollClan = false, false, false
		for _, stop in ipairs(cleanup) do
			local ok, err = pcall(stop)
			if not ok then
				warn("[Spryzen Hub] cleanup error: " .. tostring(err))
			end
		end
		local ok, err = pcall(Window.Destroy, Window)
		if not ok then
			warn("[Spryzen Hub] window cleanup error: " .. tostring(err))
		end
		if GlobalEnv[INSTANCE_KEY] and GlobalEnv[INSTANCE_KEY].Unload == unload then
			GlobalEnv[INSTANCE_KEY] = nil
		end
	end

	GlobalEnv[INSTANCE_KEY] = { Unload = unload, Version = SCRIPT_VERSION, Flags = Airflow.Flags }

	if Window.Gui then
		local destroying = Window.Gui.Destroying:Connect(function()
			task.defer(unload)
		end)
		table.insert(cleanup, function()
			destroying:Disconnect()
		end)
	end

	local JoinBox = MenuPage:AddLeftGroupbox({ Name = "Join World", Icon = "globe" })

	JoinBox:CreateToggle({
		Name = "Auto Join World",
		CurrentValue = false,
		Flag = "MenuAutoJoin",
		Callback = function(value)
			Settings.AutoJoin = value
			if not value then
				Join.set("Off", "Muted")
			end
		end,
	})

	JoinBox:CreateDropdown({
		Name = "World",
		Options = worldOptions,
		CurrentOption = Settings.World,
		MultipleOptions = false,
		AllowNone = false,
		Flag = "MenuWorld",
		Callback = function(option)
			option = type(option) == "table" and option[1] or option
			if type(option) == "string" and Bind.Worlds.Grid[option] then
				Settings.World = option
			end
		end,
	})

	JoinBox:CreateSlider({
		Name = "Join Delay",
		Range = { 0, 60 },
		Increment = 1,
		Suffix = "s",
		CurrentValue = Settings.JoinDelay,
		Flag = "MenuJoinDelay",
		Callback = function(value)
			Settings.JoinDelay = value
		end,
	})

	JoinBox:CreateDivider()

	JoinBox:CreateToggle({
		Name = "Join Private Server",
		CurrentValue = false,
		Flag = "MenuJoinPrivate",
		Callback = function(value)
			Settings.JoinPrivate = value
		end,
	})

	Join.Inputs.Owner = JoinBox:CreateInput({
		Name = "Server Owner",
		PlaceholderText = "Roblox username",
		CurrentValue = "",
		Flag = "MenuPrivateOwner",
		Callback = function() end,
	})

	JoinBox:CreateButton({
		Name = "Join Now",
		Icon = "log-in",
		Callback = function()
			task.spawn(Join.request)
		end,
	})

	JoinBox:CreateStatus({
		Name = "Status",
		Style = "Row",
		UpdateRate = 0.25,
		Update = function()
			return Join.Status, Join.Tone
		end,
	})

	local QueueBox = MenuPage:AddRightGroupbox({ Name = "Auto Queue", Icon = "swords" })

	QueueBox:CreateToggle({
		Name = "Auto Queue",
		CurrentValue = false,
		Flag = "MenuAutoQueue",
		Callback = function(value)
			Settings.AutoQueue = value
			Queue.SentAt, Queue.RetryAt = nil, 0
			if not value then
				Queue.set("Off", "Muted")
			end
		end,
	})

	QueueBox:CreateDropdown({
		Name = "Game Mode",
		Options = modeOptions,
		CurrentOption = Settings.Mode,
		MultipleOptions = false,
		AllowNone = false,
		Flag = "MenuQueueMode",
		Callback = function(option)
			option = type(option) == "table" and option[1] or option
			if type(option) == "string" and modes[option] then
				Settings.Mode = option
				Queue.configChanged()
			end
		end,
	})

	QueueBox:CreateToggle({
		Name = "Fill",
		CurrentValue = Settings.Fill,
		Flag = "MenuQueueFill",
		Callback = function(value)
			Settings.Fill = value
			Queue.configChanged()
		end,
	})

	QueueBox:CreateToggle({
		Name = "Ranked",
		CurrentValue = Settings.Ranked,
		Flag = "MenuQueueRanked",
		Callback = function(value)
			Settings.Ranked = value
			Queue.configChanged()
		end,
	})

	QueueBox:CreateStatus({
		Name = "Mode Options",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local mode = modes[Settings.Mode]
			if not mode then
				return "Pick a game mode", "Warning"
			end
			local notes = {}
			table.insert(notes, mode.Fill and "Fill applies" or "No fill")
			table.insert(notes, mode.RankedOnly and "Always ranked" or (mode.Ranked and "Ranked optional" or "Unranked only"))
			return table.concat(notes, ", "), "Muted"
		end,
	})

	QueueBox:CreateButton({
		Name = "Leave Queue",
		Icon = "x",
		Callback = function()
			Queue.Args = nil
			Bind.QueueSignal.ToServer("Cancel")
		end,
	})

	QueueBox:CreateStatus({
		Name = "Status",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			if not Settings.AutoQueue then
				local startedAt = Bind.QueuWatcher.Get()
				if startedAt then
					return "In queue, " .. math.floor(math.max(Workspace:GetServerTimeNow() - startedAt, 0)) .. "s", "Accent"
				end
				return "Off", "Muted"
			end
			return Queue.Status, Queue.Tone
		end,
	})

	local ClanTab = Window:CreateTab({ Name = "Clan", Desc = "Clan rolling", Icon = "dices" })
	local RollBox = ClanTab:AddLeftGroupbox({ Name = "Roll Clan", Icon = "dices" })
	Roll.Flags = Airflow.Flags

	if not ClanBind then
		RollBox:CreateStatus({
			Name = "Status",
			Style = "Row",
			Update = function()
				return "Clan rolling is unavailable, see console", "Error"
			end,
		})
	else
		RollBox:CreateToggle({
			Name = "Auto Roll Clan",
			CurrentValue = false,
			Flag = "MenuAutoRollClan",
			Callback = function(value)
				Settings.AutoRollClan = value
				if value then
					Roll.Count, Roll.RetryAt = 0, 0
					Roll.set("Starting")
				else
					Roll.set("Off", "Muted")
				end
			end,
		})

		RollBox:CreateDropdown({
			Name = "Stop At Desired",
			Options = Roll.ClanOptions,
			CurrentOption = {},
			MultipleOptions = true,
			Flag = "MenuDesiredClans",
			Callback = function(options)
				Settings.DesiredClans = type(options) == "table" and options or {}
			end,
		})

		RollBox:CreateDropdown({
			Name = "Stop At Minimum Rarity",
			Options = Roll.RarityOptions,
			CurrentOption = nil,
			MultipleOptions = false,
			Flag = "MenuMinClanRarity",
			Callback = function(option)
				option = type(option) == "table" and option[1] or option
				Settings.MinRarity = type(option) == "string" and Roll.RarityRank[option] and option or nil
			end,
		})

		RollBox:CreateStatus({
			Name = "Current Clan",
			Style = "Row",
			UpdateRate = 0.5,
			Update = function()
				local current = Roll.current()
				return current and Roll.describe(current) or "None", "Muted"
			end,
		})

		RollBox:CreateStatus({
			Name = "Spins",
			Style = "Row",
			UpdateRate = 0.5,
			Update = function()
				return tostring(Roll.spins()), "Muted"
			end,
		})

		RollBox:CreateStatus({
			Name = "Status",
			Style = "Row",
			UpdateRate = 0.25,
			Update = function()
				return Roll.Status, Roll.Tone
			end,
		})
	end

	local SettingsTab = Window:CreateTab({ Name = "Settings", Desc = SCRIPT_VERSION, Icon = "settings" })
	local InterfaceBox = SettingsTab:AddLeftGroupbox({ Name = "Menu", Icon = "monitor" })

	Hub.addInterfaceControls(InterfaceBox, Window)
	Hub.addLinkButtons(InterfaceBox, Airflow)
	InterfaceBox:CreateDivider()

	InterfaceBox:CreateToggle({
		Name = "Anti AFK",
		CurrentValue = Settings.AntiAfk,
		Flag = "AntiAfk",
		Callback = function(value)
			Settings.AntiAfk = value
			setAntiAfk(value)
		end,
	})

	InterfaceBox:CreateDivider()
	Hub.addUnloadButton(InterfaceBox, Airflow, unload)

	SettingsTab:CreateConfigManager({ Name = "Configs", Side = "Left" })
	SettingsTab:CreateThemeManager({ Name = "Themes", Side = "Right" })

	Window:LoadAutoload()
	setAntiAfk(Settings.AntiAfk)
end

if Hub.isMenuPlace() then
	runMainMenu()
	return
end

Hub.InDungeon = Hub.isDungeonPlace()
Hub.InFinalSelection = Hub.isFinalSelectionPlace()
Hub.InMinigame = Hub.InDungeon or Hub.InFinalSelection or Hub.isMinigamePlace()

local Const = {
	ARRIVE_DISTANCE = 1,
	NPC_STAND_OFFSET = Vector3.new(0, 2.5, 3),
	GROUND_STAND_OFFSET = Vector3.new(0, 2.5, 0),
	SPAWN_WAIT_HEIGHT = 3,
	TELEPORT_STREAM_DISTANCE = 400,
	TRAVEL_TIMEOUT_PADDING = 20,
	TRAVEL_TIMEOUT_SPEED = 22,
	SNAP_DISTANCE = 1.5,
	DASH_NEW_TARGET = 25,
	CLOSE_DISTANCE = 40,
	TWEEN_ACCEL = 60,
	HORSE_MIN_DISTANCE = 40,
	HORSE_KEEP_DISTANCE = 30,
	HORSE_NOTICE_INTERVAL = 60,
	HORSE_MOUNT_TIMEOUT = 5,
	HORSE_COOLDOWN_PAD = 0.5,
	HORSE_LOST_GRACE = 1,
	JOURNEY_RETRY = 2,
	JOURNEY_RETRY_MAX = 15,
	DASH_KNOCKBACK_SPEED = 45,
	DASH_KNOCKBACK_GAP = 0.6,
	DASH_BUSY = 0.5,
	BODY_STATES = { Enum.HumanoidStateType.Freefall, Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Ragdoll },
	SNAPBACK_DISTANCE = 10,
	SNAPBACK_MATCH = 6,
	SNAPBACK_WINDOW = 3,
	SNAPBACK_SAMPLE = 0.1,
	SNAPBACK_RESET_COOLDOWN = 10,
	SNAPBACK_RESET_COUNT = 3,
	SNAPBACK_RESET_WINDOW = 15,
	SNAPBACK_SHOW = 3,
	QUEST_ACCEPT_TIMEOUT = 4,
	QUEST_ACCEPT_REFIRE = 0.6,
	PROGRESS_TIMEOUT = 4,
	DEPOSIT_INTERVAL = 0.2,
	CLAIM_TIMEOUT = 2.5,
	CLAIM_REFIRE = 0.2,
	CLAIM_RETRY_AFTER = 30,
	STUCK_TARGET_TIMEOUT = 15,
	SKIP_TARGET_FOR = 30,
	DUNGEON_READY_CONFIRM = 3,
	DUNGEON_SEARCH_AFTER = 4,
	DUNGEON_PROMPT_SHOWN = 2,
	DUNGEON_GIVE_UP_CONFIRM = 5,
	DUNGEON_RESET_GAP = 1,
	DUNGEON_CHEST = "Ouwigahara Chest",
	DUNGEON_CHEST_PRICE = 30000,
	DUNGEON_CHEST_CONFIRM = 4,
	DUNGEON_CHEST_WAIT = 15,
	DUNGEON_CHEST_RETRY = 2,
	DUNGEON_CHEST_ATTEMPTS = 3,
	DUNGEON_BUY_CONFIRM = 3,
	DUNGEON_BUY_RETRY = 10,
	DUNGEON_LEAVE_WAIT = 10,
	DUNGEON_PICK_REFIRE = 2,
	DUNGEON_REROLL_MIN_TIME = 2,
	DUNGEON_CARD_POLL = 0.25,
	DUNGEON_BRING_POLL = 0.1,
	DUNGEON_MAX_BUY = 99,
	FINAL_BOSS_SLOT = "Hand Demon",
	FINAL_REGION = "Final Selection",
	FINAL_SHOP_SELLER = "Rika",
	FINAL_TEMPORARY_REGION = "Temporary",
	FINAL_CHAIN = { "Locate Rem", "Help Rem", "Find Vael", "Defeat Demons for Vael", "Find Klien", "Speak with Klien", "Find Rika", "Treat Klien", "Find Mizuto", "Defeat Lost", "The Dungeon", "Find Lavato", "Mountain Survival", "Rescue and Hold the Zone", "Find Steve", "Defeat the Hand Demon" },
	FINAL_KILL_SLOTS = { LesserDemon = "Lesser Demon", Lost = "Lost", HandDemon = "Hand Demon" },
	FINAL_MOUNTAIN_QUEST = "Mountain Survival",
	FINAL_ZONE_QUEST = "Rescue and Hold the Zone",
	FINAL_PARKOUR = "Parkour Dungeon",
	FINAL_PARKOUR_END = Vector3.new(124.17, 1042.32, 2990.32),
	FINAL_CLOSING_STEPS = { "GiveClothing", "GiveOre", "GiveIngot", "GiveCrow", "ClosingDone" },
	FINAL_CLOSING_GAP = 0.5,
	FINAL_ADD_WAIT = 3,
	FINAL_ADD_RETRY = 8,
	FINAL_THREAT_RANGE = 40,
	FINAL_ZONE_MARGIN = 4,
	FINAL_ZONE_FALLBACK = 20,
	FINAL_CHECKPOINT_TOUCH = 1.5,
	FINAL_TRAINING_START = 8,
	FINAL_LEVER_CONFIRM = 1.5,
	FINAL_FINISH_WAIT = 4,
	FINAL_BUY_CONFIRM = 4,
	FINAL_LOOT_SETTLE = 3,
	FINAL_LOOT_LIMIT = 70,
	WEAPON_EQUIP_INTERVAL = 2,
	LOCK_NOTICE_DURATION = 10,
	COLLECT_POLL = 0.25,
	KILL_AURA_POLL = 0.05,
	M1_POLL = 0.05,
	M1_STALL_PAD = 0.25,
	COMBO_SKILL_WINDOW = 1.5,
	BOSS_POLL = 0.1,
	BOSS_CROWD_HOLD = 5,
	BOSS_HOVER_HEIGHT = 3,
	BOSS_ENGAGE_RANGE = 350,
	BOSS_STREAM_RETRY = 15,
	BOSS_STREAM_TIMEOUT = 8,
	BOSS_LOOT_WINDOW = 3,
	WALK_REACH = 5,
	WALK_STEP_TIMEOUT = 3,
	WALK_REPATHS = 3,
	BOSS_POSITION_LIMIT = 1e5,
	PIN_SCAN = 0.25,
	PIN_RANGE = 300,
	PIN_REANCHOR = 20,
	BOSS_LOOT_MAX = 20,
	SLOT_NAMES = { "One", "Two", "Three", "Four", "Five" },
	SKILL_INPUTS = { "Skills_1st", "Skills_2nd", "Skills_3rd", "Skills_4th", "Skills_5th", "Skills_6th", "Skills_7th", "Skills_8th", "Skills_9th", "Skills_10th" },
	SKILL_KEYS = { "F", "Z", "X", "C", "V", "B", "N", "K", "L", "J" },
	SKILL_POLL = 0.1,
	GAME_IDENTITY = 2,
	SKILL_START_TIMEOUT = 0.6,
	SKILL_SETTLE_TIMEOUT = 1.5,
	SKILL_AIM_TAIL = 1.5,
	SKILL_CAST_GAP = 0.15,
	SKILL_RETRY_BASE = 2,
	SKILL_RETRY_MAX = 30,
	SKILL_HOLD_MAX = 8,
	SKILL_HOLD_DEFAULT = 0.1,
	CLAN_EQUIP_TIMEOUT = 2,
	SKILL_READY_PAD = 0.3,
	CLAN_BLOCKED_LIMIT = 3,
	GUARD_POLL = 0.1,
	RAGDOLL_NAMES = { "RagDoll", "ragdoll", "Ragdoll", "ragDoll" },
	HEAL_POLL = 0.2,
	RETREAT_HEIGHT = 120,
	ESCAPE_POLL = 0.1,
	ESCAPE_MAX_AWAY = 20,
	ESCAPE_SEEN_WINDOW = 0.5,
	ESCAPE_CROWD_RADIUS = 20,
	ESCAPE_THREAT_RANGE = 100,
	ESCAPE_BACK_LIFT = 8,
	ULT_EDGE_PAD = 4,
	ULT_HEIGHT_RANGE = 40,
	ULT_MAX_HOLD = 10,
	ULT_RESPOT_GAP = 0.15,
	ULT_RETURN_TIME = 0.5,
	ULT_RETURN_REACH = 2,
	ULT_SEARCH_RINGS = 6,
	ULT_SEARCH_STEP = 15,
	ULT_SEARCH_DIRECTIONS = 16,
	POTION_TOOLBAR_TIMEOUT = 3,
	POTION_EQUIP_TIMEOUT = 3,
	POTION_DRINK_TIMEOUT = 4,
	POTION_PRESS_SETTLE = 0.1,
	POTION_BUFFS = { ["Health Regen Potion"] = "Health Regen Speed", ["Health Regen Elixir"] = "Health Regen Speed" },
	POTION_INTERRUPT_RETRY = 1,
	POTION_LIFT_TIMEOUT = 3,
	POTION_SAFE_DISTANCE = 5,
	POTION_CONFIRM_TIMEOUT = 1.5,
	POTION_READY_TIMEOUT = 3,
	POTION_GAP = 1,
	POTION_RETRY = 8,
	INSTANT_KILL_POLL = 0.05,
	PLAYER_POLL = 0.1,
	WALKSPEED_PRIORITY = 1000,
	JUMP_GAP = 0.2,
	RECONNECT_RETRY = 10,
	PAUSE_POLL = 0.5,
	PRIORITY_POLL = 0.5,
	PRIORITY_LEASE_TOP = 16,
	PRIORITY_NONE = "None",
	PRIORITY_JOBS = {
		{ Key = "Hunt", Label = "Muzan/Crow", Flag = "BossHunt" },
		{ Key = "Bosses", Label = "World Bosses", Flag = "WorldBosses" },
		{ Key = "Yeti", Label = "Yeti", Flag = "AutoYeti" },
		{ Key = "Caches", Label = "Caches", Flag = "AutoCacheFarm" },
		{ Key = "Quests", Label = "Quests" },
		{ Key = "Mobs", Label = "Mobs", Flag = "MobFarm" },
	},
	PAUSE_GUI = "RobloxNetworkPauseNotification",
	GEAR_POLL = 5,
	GEAR_CONFIRM = 2.5,
	GEAR_RETRY = 60,
	GEAR_OTHER_WEIGHT = 0.1,
	GEAR_SUN_BONUS = 10,
	ACCESSORY_SLOTS = { "One", "Two", "Three", "Four", "Five" },
	GEAR_GROUPS = {
		Damage = { "Additional Damage", "Additional Damage Factor", "Attack Speed Factor" },
		Health = { "Max Health", "Health Regen Speed" },
		Defense = { "Damage Reduction", "Damage Reduction Factor", "Block Points", "Block Regen" },
		Speed = { "Movement Speed Factor" },
		Stamina = { "Max Stamina", "Stamina Regen Speed" },
	},
	GEAR_FAVOURS = { "Damage", "Health", "Defense", "Speed", "Stamina" },
	SWIM_BASE_SPEED = 16,
	AIM_SCAN = 0.05,
	AIM_FOV_COLOR = Color3.fromRGB(235, 235, 235),
	AIM_LOCK_COLOR = Color3.fromRGB(120, 230, 140),
	SKILL_TREE_POLL = 1,
	SKILL_TREE_GAP = 0.3,
	SKILL_TREE_RETRY = 30,
	SKILL_TREE_ORDER = { "Innate Skills", "Skills", "Max Health", "Max Stamina", "Health Regen Speed", "Stamina Regen Speed", "Block Points", "Block Regen", "Additional Damage" },
	TRAVEL_HEIGHT = 3,
	VENDOR_STAND = 4,
	MUZAN_HOVER = 30,
	MUZAN_SCAN = 4,
	HORSE_HOVER = 30,
	HORSE_SCAN = 3,
	HORSE_REACH = 12,
	HORSE_CHASES = 4,
	HORSE_ITEM = "Horse",
	TAME_STAND = 4,
	TAME_REACH = 6,
	TAME_APPROACH = 8,
	TAME_START = 6,
	TAME_SHOWN = 4,
	TAME_SOLVE = 2.5,
	TAME_END = 10,
	TAME_BOUGHT = 20,
	TAME_RETRY = 10,
	GOURDS = { "Large Gourd", "Medium Gourd", "Small Gourd" },
	GOURD_SELLER = "Ren",
	GOURD_SELLER_REGION = "Butterfly Estate",
	GOURD_SELLER_LEVEL = 75,
	GOURD_SIDE = "Slayer",
	GOURD_HOLD = 0.6,
	GOURD_HOLD_LAST = 1.4,
	GOURD_EQUIP_SETTLE = 0.3,
	GOURD_CONFIRM = 4,
	GOURD_MAX_BUY = 99,
	GOURD_SCAN = 3,
	GOURD_BUY_CONFIRM = 4,
	GOURD_RETRY = 30,
	DEMON_QUEST = "Muzan Quest",
	DEMON_LILY_TASK = "Spider Lilies",
	DEMON_DOCTOR_TASK = "Deliver Dr. Higoshima",
	DEMON_BELL = "Biwa Bell",
	DEMON_BLOOD = "Muzan's Blood",
	DEMON_LAIR_MODEL = "MuzanLairModel",
	DEMON_DOCTOR = "Higoshima",
	DEMON_DELIVER_ATTRIBUTE = "HigoshimaDeliverTo",
	DEMON_TALK_DISTANCE = 5,
	DEMON_APPROACH_TIMEOUT = 6,
	DEMON_TALK_TIMEOUT = 5,
	DEMON_DIALOGUE_SETTLE = 0.5,
	DEMON_ITEM_TIMEOUT = 3,
	DEMON_PRESS_HOLD = 0.15,
	DEMON_RING_TIMEOUT = 8,
	DEMON_DRINK_TIMEOUT = 20,
	DEMON_LILY_WAIT = 3,
	DEMON_LILY_SKIP = 60,
	DEMON_DOCTOR_RADIUS = 40,
	DEMON_DOCTOR_WAIT = 4,
	DEMON_DELIVER_TIMEOUT = 10,
	DEMON_CALM_POLL = 0.5,
	HUNT_TIERS = { "Mythic", "Legendary", "Epic", "Rare", "UnCommon", "Common" },
	HUNT_CLAIM_TIMEOUT = 4,
	HUNT_RETRY = 30,
	STUN_NAMES = { "Stun", "CombatStun", "Strict_Stun" },
	CLIMB_SCAN_DELAY = 2,
	ESP_COLLECT = 0.3,
	ESP_ITEM_MAX_SIZE = 12,
	YETI_STAND = Vector3.new(-1394.5, -41.75, 503.1),
	YETI_BOSS = "Yeti Demon",
	YETI_MINION = "Small Yeti",
	YETI_HEART = "Frozen Heart",
	YETI_SUMMON_TIMEOUT = 6,
	YETI_REFREEZE = 300,
	YETI_PROMPT_WAIT = 5,
	YETI_BUY_POLL = 2,
	YETI_BUY_CONFIRM = 5,
	YETI_BUY_RETRY = 60,
	CACHE_TIERS = {
		{ Id = "Sealed Cache T1", Record = "Sealed Chest T1", Label = "Tier 1", Guards = { "Grove Raider", "Raid Captain" } },
		{ Id = "Sealed Cache T2", Record = "Sealed Chest T2", Label = "Tier 2", Guards = { "Cache Lancer", "Lancer Captain" } },
		{ Id = "Sealed Cache T3", Record = "Sealed Chest T3", Label = "Tier 3", Guards = { "Cache Prowler", "Prowler Captain" } },
	},
	CACHE_PRIORITIES = { "Nearest", "Highest tier first" },
	CACHE_LIMIT_TEXT = "opened all the caches you can",
	CACHE_DENIED_TEXT = "fight for this",
	CACHE_LIMIT_KEY = "__Slayer2CacheLimit",
	CACHE_GUARD_RADIUS = 120,
	CACHE_GUARD_WAIT = 8,
	CACHE_TIMEOUT = 240,
	CACHE_SKIP_FOR = 120,
	CACHE_OPEN_TIMEOUT = 5,
	CACHE_OPEN_REFIRE = 1,
	CACHE_LOOT_RADIUS = 40,
	CACHE_LOOT_SETTLE = 1.5,
	CACHE_LOOT_MAX = 40,
	CACHE_CLAIM_PAD = 2,
	CACHE_PROMPT_SHOWN = 1,
	BLOCK_INPUT = "Skills_1st",
	PARRY_NPC_WINDOW = 0.25,
	PARRY_PVP_WINDOW = 0.1,
	PARRY_HIT_LOCK = 1,
	PARRY_COOLDOWN_GRACE = 0.3,
	PARRY_COOLDOWN_PAD = 0.05,
	PARRY_DEFAULT_COOLDOWN = 2,
	PARRY_DEFAULT_REACH = 7,
	PARRY_REACH_PAD = 5,
	PARRY_HOLD_AFTER = 0.15,
	PARRY_RESERVE_AHEAD = 0.15,
	PARRY_THREAT_LIFETIME = 3,
	PARRY_SCAN_INTERVAL = 0.2,
	PARRY_CONFIRM_TIMEOUT = 0.4,
	PARRY_PING_INTERVAL = 0.5,
	BLOCK_HIT_WINDOW = 1.5,
	BLOCK_QUIET = 0.8,
	BLOCK_MAX_HOLD = 3,
	BLOCK_REST = 0.5,
	FISH_RODS = { "Legendary Fishing Rod", "Rare Fishing Rod", "Basic Fishing Rod" },
	FISH_BAITS = { "Worm", "Fish Head", "Golden Tentacle", "Drowned Lure" },
	FISH_PERMIT_QUEST = "Ill find the permit stamp(Lv 45)",
	FISH_STARTER_ROD = "Basic Fishing Rod",
	FISH_VENDORS = { ["Basic Fishing Rod"] = "Fisherman Jeso", ["Rare Fishing Rod"] = "Fisherman Jeso", Worm = "Fisherman Jeso", ["Fish Head"] = "Baitmonger Nori" },
	FISH_REACH = 30,
	FISH_DEPTH = 400,
	FISH_BAIT_RESTOCK = 25,
	FISH_BITE_HOLD = 4.7,
	FISH_BITE_WAIT = 60,
	FISH_CAST_TRIES = 3,
	FISH_COLLECT_TIME = 12,
	FISH_INTERVAL = 0.15,
	PORTAL_POSITION = Vector3.new(-1605.633, 1014.179, 1142.769),
	PORTAL_PAD = "OuwigaharaPromptPad",
	PORTAL_PROMPT = "Ouwigahara",
	PORTAL_LOAD_WAIT = 10,
	PORTAL_TELEPORT_WAIT = 20,
	PORTAL_RETRY = 15,
	PORTAL_LOCKED_RETRY = 30,
	PORTAL_TELEPORT_STUCK = 60,
	CRAFT_STATION = "Ouwland",
	CRAFT_NPC = "Blacksmith Togane",
	REFINE_NPC = "Refiner Hagane",
	TRAINING_NAMES = { "Boulder Push", "Boulder Split", "Cup Game", "Meditation", "Pushups", "Squat", "Target Shooting" },
	TRAINING_TIMEOUT = 180,
	TRAINING_ARRIVE = 8,
	TRAINING_HOLD_PAD = 0.25,
	CRAFT_RETRY = 30,
	CRAFT_GAP = 1,
	SELL_NPC = "Ginzo",
	SELL_MAX = 999,
	SELL_RETRY = 60,
	MARKET_RETRY = 30,
	MARKET_LISTING = 5,
	MARKET_CONFIRM = 4,
	MARKET_SCAN = 48,
	SELL_GUARDED = { Materials = true, Schematics = true, ["Quest Items"] = true, Potions = true, Mounts = true },
	REFINE_SYNC = 2,
	REFINE_SETTLE = 0.4,
	SCHEMATIC_PROMPT_WAIT = 8,
	SCHEMATIC_GIVE_TIMEOUT = 6,
	SCHEMATIC_ATTEMPTS = 3,
	SCHEMATIC_WAIT_FOR = 45,
	SCHEMATIC_BLOCKED_FOR = 300,
	SCHEMATIC_TALK_TIMEOUT = 5,
	SCHEMATIC_NPC_WAIT = 6,
	SCHEMATIC_LEVER_CONFIRM = 2,
	SCHEMATIC_SEWER_WAIT = 10,
	SCHEMATIC_STATUE_STALL = 25,
	SCHEMATIC_STATUE_GAP = 3,
	SCHEMATIC_STATUE_HEIGHT = 3,
	SCHEMATIC_TOOLBAR_TIMEOUT = 3,
	SCHEMATIC_FISTS = "Combat",
	SCHEMATIC_DUEL_WAIT = 10,
	SCHEMATIC_DUEL_STALL = 30,
	SCHEMATIC_PLATE_HOVER = 8,
	SCHEMATIC_PLATE_ACK = 2.5,
	SCHEMATIC_PLATE_PRESS = 0.3,
	SCHEMATIC_SHOW_WAIT = 12,
	SCHEMATIC_SHOW_PAD = 0.4,
	SCHEMATIC_FOXFIRE_STAND = 1.2,
	SCHEMATIC_FOXFIRE_PASSES = 3,
	SCHEMATIC_LOOT_RADIUS = 30,
	SCHEMATIC_LOOT_SETTLE = 2,
	SCHEMATIC_LOOT_MAX = 20,
	SCHEMATIC_RETSU_COST = 2500,
	SCHEMATIC_RETSU_KEY = "__Slayer2RetsuPaid",
	SCHEMATIC_PLATE_QUEST = "Ill walk the order",
	SCHEMATIC_LIT_LANTERN = "Mushroom Lit Lantern",
	SCHEMATIC_SERPENT_KEY = "Serpent Key",
	SCHEMATIC_DUELIST = "Duelist Hibiki",
	SCHEMATIC_SOFEN = { Name = "Dock Master Sofen", Position = Vector3.new(-160.806, 796.25, 703.288) },
	SCHEMATIC_SERPENT_BOX = Vector3.new(899.422, 878.509, 738.739),
	SCHEMATIC_FOXFIRE_CAVE = Vector3.new(-1337, 1371, -3160),
	SCHEMATIC_TANTO_MOUND = Vector3.new(-1374.632, 1420.468, -3824.402),
	SCHEMATIC_FANS_MOUND = Vector3.new(-424.566, 1353.615, -3528.637),
	SCHEMATIC_STATUES = { "Weapon", "Fighting", "Power" },
	SCHEMATIC_SERPENT_KEYS = {
		Key = Vector3.new(-345.2, 733.4, 1168),
		Key1 = Vector3.new(-321.1, 733.4, 1129.5),
		Key2 = Vector3.new(-315, 733.4, 1221.5),
		Key3 = Vector3.new(-293, 733.4, 1161.7),
		Key4 = Vector3.new(-285, 733.4, 1243.5),
		Key5 = Vector3.new(32.9, 739.5, 1268.5),
		Key6 = Vector3.new(-141.5, 733.4, 1087.5),
		Key7 = Vector3.new(-58.5, 734.7, 910.5),
		Key8 = Vector3.new(-213.2, 733.4, 844),
		Key9 = Vector3.new(-335, 733.4, 941.5),
		Key11 = Vector3.new(-344.5, 740.5, 770.1),
		Key12 = Vector3.new(-146.9, 734.3, 540.9),
		Key13 = Vector3.new(-217, 733.4, 460.9),
		Key14 = Vector3.new(-282.5, 733.8, 429.5),
		Key15 = Vector3.new(-374.9, 733.4, 540.2),
		Key16 = Vector3.new(-389.1, 733.4, 603),
		Key17 = Vector3.new(-319.5, 733.7, 666),
		Key18 = Vector3.new(-483.2, 733.4, 545.1),
		Key19 = Vector3.new(-595, 733.4, 506.8),
		Key20 = Vector3.new(-698.8, 740.4, 373.5),
		Key21 = Vector3.new(-766.3, 746.4, 278.5),
		Key22 = Vector3.new(-692.1, 733.4, 551.8),
		Key23 = Vector3.new(-573, 733.4, 674.8),
		Key24 = Vector3.new(-263, 733.4, 263.1),
		Key25 = Vector3.new(-169, 733.4, 199.1),
	},
	COIN_POUCH = "Coin Pouch",
	ORES = { "Ore", "Refinement Ore", "Mythic Refinement Ore", "Firstlight Star Ore" },
	STATS_POLL = 1,
	SETTING_SHAKE = "Settings/Performance/ScreenShake",
	BOOST_SETTINGS = {
		{ "Settings/Performance/Shadows", false },
		{ "Settings/Performance/Materials", false },
		{ "Settings/Performance/Particles", 0 },
		{ "Settings/Performance/ParticlesMine", 0 },
		{ "Settings/Performance/ParticlesAllies", 0 },
		{ "Settings/Performance/ParticlesOthers", 0 },
	},
	BOOST_BATCH = 2000,
	CUTSCENE_EFFECTS = { "Camera_Controller_C", "MuzanTransformEffects" },
	CUTSCENE_STAGE = "Cutscene",
	SKILL_VFX_FOLDERS = {
		"Flame Breathing", "Insect Breathing", "Serpent Breathing", "Sound Breathing", "Stone_Breathing", "Thunder Breathing", "Water Breathing", "Wind Breathing",
		"Arrow", "Blood Manipulation", "Cryokinesis", "Dream", "Obi Manipulation", "Pyrokinesis", "Reaper", "Shockwave", "Tamari",
	},
	WEBHOOK_POLL = 1,
	WEBHOOK_COLOR = 0x010101,
	WEBHOOK_BOSS_POLL = 2,
	WEBHOOK_BOSS_FRESH = 120,
	WEBHOOK_BATCH_QUIET = 2,
	WEBHOOK_BATCH_MAX = 8,
	WEBHOOK_GAP = 1.2,
	WEBHOOK_QUEUE_MAX = 25,
	WEBHOOK_ATTEMPTS = 3,
	WEBHOOK_RETRY_MAX = 30,
	WEBHOOK_ITEM_LINES = 15,
	WEBHOOK_NPCS = { "Black Marketer", "Muzan" },
	WEBHOOK_DIGEST_EVENTS = 15,
	FINAL_SELECTION_LEAD = 600,
	SHIFT_LOCK_STEP = "Slayer2NoShiftLock",
	HIT_FLASH_GUI = "Misc",
	HIT_FLASH_IMAGE = "rbxassetid://101053692073571",
	FPS_CAP_MIN = 15,
	FPS_CAP_MAX = 1000,
	FPS_CAP_DEFAULT = 60,
	FPS_CAP_POLL = 1,
	WEBHOOK_HOSTS = { ["discord.com"] = true, ["discordapp.com"] = true, ["canary.discord.com"] = true, ["ptb.discord.com"] = true },
	RARITY_EMOJI = { "⬜", "🟩", "🟦", "🟪", "🟨", "🟥", "⬛", "🟧" },
}

local Settings = {
	AutoDungeon = false,
	AutoFinalSelection = false,
	FinalSkipLoot = false,
	FinalBoss = false,
	FinalMobs = false,
	FinalMobList = {},
	AutoTameHorse = false,
	AutoGourd = false,
	GourdBuy = false,
	GourdBuyType = "Large Gourd",
	GourdKeepWen = 0,
	DungeonRange = 0,
	BringEnemies = false,
	BringRange = 0,
	ExtraLifeAt = 0,
	MostPointsFirst = false,
	PickFirstRarity = 1,
	RerollUntilFloor = 0,
	RerollsPerHand = 0,
	StallGuard = false,
	StallAfter = 180,
	BuyOrder = "Most Expensive First",
	BuyEachMax = 0,
	AutoPickCards = false,
	CardPriority = {},
	HealBelow = 50,
	AvoidCurse = true,
	SkipPointCards = false,
	PickFirst = {},
	NeverPick = {},
	AutoReroll = false,
	RerollFloor = 1,
	RerollKeep = 0,
	RerollForPriority = false,
	AutoSkipBreak = false,
	AutoResetPoints = false,
	ResetPoints = 30000,
	AutoResetFloor = false,
	ResetFloor = 21,
	AutoChest = false,
	ChestTimes = 0,
	AutoCaches = false,
	AutoBuy = false,
	BuyItems = {},
	AutoLeave = false,
	LeaveDelay = 5,
	LevelUp = false,
	AutoQuest = false,
	Quest = nil,
	MobFarm = false,
	Mobs = {},
	AutoPickup = false,
	PickupRarities = {},
	PickupItems = {},
	AutoSouls = false,
	KillAura = false,
	AutoM1 = true,
	AutoSkill = true,
	FullCombo = true,
	SkillSlots = { [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true },
	HoldSkills = false,
	SkillHolds = {},
	AutoClanSkills = false,
	ClanSkillPicks = {},
	AntiAirCombo = false,
	NoAttackSlowdown = false,
	AntiRagdoll = false,
	AntiKnockback = false,
	RetreatHeal = false,
	RetreatBelow = 35,
	BackAt = 90,
	AutoEscape = false,
	EscapeStun = true,
	EscapeRagdoll = false,
	EscapeLowHp = true,
	EscapeHpBelow = 30,
	EscapeHpBack = 60,
	EscapeCrowd = false,
	EscapeCrowdSize = 4,
	EscapeDirection = "Up",
	EscapeDistance = 80,
	EscapeStay = 2,
	EscapeCooldown = 5,
	AutoDodgeUlt = false,
	UltDodgeDistance = 10,
	UltReturnDelay = 0.3,
	AutoPotion = false,
	DrinkBelow = 50,
	Potions = {},
	PotionSlot = 5,
	PotionSafety = true,
	WeaponSlot = "Current",
	Distance = 3.5,
	FarmPosition = "Below",
	DropRange = 100,
	MovementType = "Current",
	HorseSlot = "Auto",
	HorseSpeed = 50,
	DismountDelay = 1.5,
	ResetOnSnapback = true,
	WorldBosses = false,
	Bosses = {},
	BossOrder = {},
	BossNextDelay = 3,
	BossAvoidPlayers = false,
	BossAvoidRadius = 100,
	InstantKill = false,
	BreakPathing = false,
	KillAtHp = 100,
	WalkSpeedEnabled = false,
	WalkSpeed = 32,
	AutoRun = false,
	Fly = false,
	FlySpeed = 80,
	SwimSpeedEnabled = false,
	SwimSpeed = 40,
	AimAssist = false,
	AimTargets = { "Mobs", "Bosses" },
	AimFov = 150,
	AimRange = 150,
	AimShowFov = true,
	InfiniteJump = false,
	Noclip = false,
	AutoSkillTree = false,
	SkillTreeBranches = {},
	BossHunt = false,
	HuntTiers = {},
	HuntNextDelay = 3,
	AutoDemon = false,
	DemonRepMobs = {},
	TravelNpc = nil,
	TravelPlace = nil,
	NoStun = true,
	NoDashCooldown = false,
	InfiniteStamina = true,
	InfiniteClimb = false,
	NoDrown = false,
	NoSunDamage = false,
	AutoAccessories = false,
	AutoTitles = false,
	GearFavour = {},
	EspBox = false,
	EspBoxFill = false,
	Esp3D = false,
	EspName = false,
	EspNameColor = Color3.new(1, 1, 1),
	EspDistance = false,
	EspDistanceColor = Color3.new(1, 1, 1),
	EspHealthBar = false,
	EspHealthColor = Color3.fromRGB(0, 255, 0),
	EspDyingColor = Color3.fromRGB(255, 0, 0),
	EspHealthText = false,
	EspHealthTextColor = Color3.new(1, 1, 1),
	EspTracer = false,
	EspMaxDistance = 5000,
	EspPlayers = false,
	EspPlayerInfo = false,
	EspPlayerInfoColor = Color3.new(1, 1, 1),
	EspEnemyColor = Color3.fromRGB(255, 0, 0),
	EspPartyColor = Color3.fromRGB(0, 255, 0),
	EspMobs = false,
	EspMobColor = Color3.fromRGB(0, 180, 255),
	EspBosses = false,
	EspBossColor = Color3.fromRGB(255, 130, 0),
	EspNpcs = false,
	EspNpcColor = Color3.fromRGB(200, 200, 200),
	EspMuzan = false,
	EspMuzanColor = Color3.fromRGB(190, 0, 0),
	EspLily = false,
	EspLilyColor = Color3.fromRGB(255, 85, 105),
	EspChest = false,
	EspChestColor = Color3.fromRGB(255, 200, 0),
	MapXray = false,
	HideName = false,
	XrayAmount = 0.6,
	EspHorse = false,
	EspHorseColor = Color3.fromRGB(210, 165, 100),
	AutoYeti = false,
	YetiMinionKill = false,
	YetiAutoBuy = false,
	YetiKeepHearts = 5,
	AutoCacheFarm = false,
	CacheGuardKill = false,
	CacheTiers = {},
	CachePriority = "Nearest",
	CacheRetry = 30,
	CacheDelay = 3,
	AutoParry = false,
	ParryPlayers = false,
	ParryRadius = 30,
	AutoBlock = false,
	BlockAfterHits = 2,
	AutoFish = false,
	FishRod = "Best Owned",
	FishBait = "None",
	FishFreeze = false,
	FishBuyBait = false,
	FishReturnAfterBait = true,
	AutoJoinDungeon = false,
	DungeonJoinDelay = 5,
	AutoSchematics = false,
	SchematicList = {},
	SchematicSpend = true,
	SchematicTrades = false,
	GauntletSlot = nil,
	AutoSell = false,
	SellRarities = {},
	SellCategories = {},
	SellItems = {},
	SellNever = {},
	SellKeep = 1,
	SellInterval = 5,
	AutoBuyMarket = false,
	MarketItems = {},
	MarketRarities = {},
	MarketSkipOwned = true,
	MarketForecast = 4,
	AutoCraft = false,
	CraftRecipes = {},
	AutoRefine = false,
	RefineItems = {},
	RefineTarget = 5,
	RefineGuard = true,
	RefineGuardFrom = 3,
	RefineKeepWen = 0,
	AutoPowerStatue = false,
	PowerStatueSlot = "Current",
	AutoTraining = false,
	TrainingList = {},
	TrainingMode = "Instantly",
	NoScreenShake = false,
	DisableAnimations = true,
	DisableSkillVfx = false,
	DisableCutscenes = true,
	SpectateEnemy = false,
	FpsBoost = false,
	FpsCap = false,
	DisableShiftLock = true,
	NoHitFlash = false,
	AntiAfk = true,
	AutoReconnect = false,
	ReconnectDelay = 5,
	Disable3d = false,
	HidePausePopup = true,
	Webhook = false,
	WebhookEveryone = false,
	NotifyDrops = true,
	DropRarity = "Rare",
	AlwaysNotify = {},
	NotifyLevel = true,
	NotifyBosses = true,
	NotifyBossList = {},
	NotifyNpcs = true,
	NotifyNpcList = {},
	NotifyFinalSelection = true,
	NotifyDungeonFloor = true,
	NotifyDungeonRun = true,
	NotifyDisconnect = true,
	WebhookDigest = false,
	WebhookInterval = 10,
	PriorityOrder = {},
	PriorityBegin = false,
}

local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({ _tasks = {} }, Maid)
end

function Maid:Give(item)
	table.insert(self._tasks, item)
	return item
end

function Maid:Clean()
	local tasks = self._tasks
	self._tasks = {}
	for index = #tasks, 1, -1 do
		local item = tasks[index]
		local ok, err = pcall(function()
			local kind = typeof(item)
			if kind == "RBXScriptConnection" then
				item:Disconnect()
			elseif kind == "function" then
				item()
			elseif kind == "thread" then
				if item ~= coroutine.running() and coroutine.status(item) ~= "dead" then
					task.cancel(item)
				end
			elseif kind == "Instance" then
				item:Destroy()
			elseif type(item) == "table" and type(item.Destroy) == "function" then
				item:Destroy()
			end
		end)
		if not ok then
			warn("[Spryzen Hub] cleanup error: " .. tostring(err))
		end
	end
end

local RootMaid = Maid.new()

local Game = {}

do
	local modulePaths = {
		Utility = { "CAM", "Global", "Utility" },
		Quests = { "CAM", "Global", "Subsets", "Gameplay", "Quests" },
		AcceptCost = { "CAM", "Global", "Subsets", "Gameplay", "Quests", "AcceptCost" },
		ItemRequirements = { "CAM", "Global", "Collectibles", "ItemRequirements" },
		Items = { "CAM", "Global", "Collectibles", "Items" },
		Regions = { "Regions" },
		SignalEvent = { "Communication", "ServerAndClient", "Signals", "SignalEvent" },
		InputHandler = { "CAM", "Client", "Components", "Client", "InputHandler" },
		CombatPresets = { "CAM", "Global", "Combat_presets" },
		CharacterInfo = { "CAM", "Global", "Character_info_provider" },
		Checker = { "CAM", "Global", "Checker" },
		PlayerProgression = { "CAM", "Global", "PlayerProgression" },
		GameSettings = { "CAM", "Global", "gameSettings" },
		LiveConfig = { "CAM", "Global", "LiveConfig" },
		Menum = { "CAM", "Global", "Menum" },
		DayNight = { "CAM", "Global", "DayAndNightHandler" },
		SkillsProvider = { "CAM", "Client", "Controllers", "Skills_Provider" },
		PlatformHandler = { "CAM", "Client", "Controllers", "Platform_Handler" },
		SkillInfo = { "CAM", "Global", "PlayerProfile", "Skill_Info" },
		ManageCd = { "CAM", "Global", "Subsets", "Gameplay", "manage_cd" },
		PlayerStatResolver = { "CAM", "Global", "PlayerStatResolver" },
		CombatBalance = { "CAM", "Global", "CombatBalance" },
		ClanSkills = { "CAM", "Clans", "ClanSkills" },
		SignalFunction = { "Communication", "ServerAndClient", "Signals", "SignalFunction" },
		SkillTreeholder = { "CAM", "Global", "SkillService", "SkillTreeholder" },
		SkillTreeConfig = { "CAM", "Global", "SkillService", "SkillTreeholder", "SkillTreeConfig" },
		SkillStats = { "CAM", "Global", "SkillService", "Stats" },
		RunHandler = { "CAM", "Client", "Modules", "GamePlay", "Run_Handler" },
		DashHandler = { "CAM", "Client", "Modules", "GamePlay", "Dash_Handler" },
		BossHunts = { "CAM", "Global", "Subsets", "Gameplay", "Quests", "BossHunts" },
		TimedVendor = { "CAM", "Global", "Subsets", "Gameplay", "TimedVendor" },
		TimedEvents = { "CAM", "Global", "Subsets", "Gameplay", "TimedEvents" },
		BlackMarketer = { "Ouwland", "Content", "Misc", "Npcs", "Black Marketer" },
		MuzanNpc = { "Ouwland", "Content", "Misc", "Npcs", "Muzan" },
		MuzanSettings = { "CAM", "Global", "MuzanSettings" },
		InCombat = { "CAM", "Global", "Subsets", "Gameplay", "InCombat" },
		DialogueUtility = { "CAM", "Client", "Components", "Client", "DialogueComponent", "DialogueUtility" },
		MinigameSettings = { "CAM", "Global", "MinigameSettings" },
		PartyWatcher = { "CAM", "Client", "Modules", "PartyWatcher" },
		Shop = { "CAM", "Global", "Shop" },
		ChestController = { "CAM", "Client", "Controllers", "ChestController" },
		ServerClientPortal = { "CAM", "Global", "ServerClientPortal" },
		Rarities = { "CAM", "Global", "Rarities" },
		Titles = { "CAM", "Global", "Titles" },
		Crafting = { "CAM", "Global", "Crafting" },
		Refinement = { "CAM", "Global", "Refinement" },
	}

	local function find(root, segments)
		local node = root
		for _, name in ipairs(segments) do
			node = node and node:FindFirstChild(name)
		end
		return node
	end

	local worldOnly = { BlackMarketer = true, MuzanNpc = true, Content = true, Crafting = true, Refinement = true }
	local missing = {}
	for name, segments in pairs(modulePaths) do
		local module = find(ReplicatedStorage, segments)
		local ok, result = false, "not found"
		if module then
			ok, result = pcall(require, module)
		end
		if ok then
			Game[name] = result
		elseif not (Hub.InMinigame and worldOnly[name]) then
			table.insert(missing, name .. ": " .. tostring(result))
		end
	end

	Game.Content = find(ReplicatedStorage, { "Ouwland", "Content" })
	Game.Animations = find(ReplicatedStorage, { "Assets", "Animations" })
	Game.Swings = find(ReplicatedStorage, { "Effects", "Swings" })
	Game.CurPower = find(ReplicatedStorage, { "CAM", "Client", "Controllers", "Skills_Provider", "CurPower" })

	for _, name in ipairs({ "Content", "Animations", "Swings", "CurPower" }) do
		if Game[name] == nil and not (Hub.InMinigame and worldOnly[name]) then
			table.insert(missing, name .. ": not found")
		end
	end

	if #missing > 0 then
		error("[Spryzen Hub] game bindings unavailable:\n" .. table.concat(missing, "\n"), 0)
	end
end

function Game.data()
	return Game.Utility.GetData(LocalPlayer)
end

function Game.level()
	local data = Game.data()
	if not data then
		return 0
	end
	return math.floor(data.Exp.Goal.Value / Game.GameSettings.expPerLevel)
end

function Game.fire(...)
	Game.SignalEvent.ToServer(...)
end

do
	local module = ReplicatedStorage:FindFirstChild("CAM")
	for _, name in ipairs({ "Client", "Modules", "Archives" }) do
		module = module and module:FindFirstChild(name)
	end
	if module and module:IsA("ModuleScript") then
		local ok, result = pcall(require, module)
		if ok and type(result) == "table" then
			Game.Archives = result
		end
	end
end

function Game.isolated(fn, ...)
	local args = table.pack(...)
	local results = nil
	task.spawn(function()
		results = table.pack(pcall(fn, table.unpack(args, 1, args.n)))
	end)
	if results and results[1] then
		return table.unpack(results, 2, results.n)
	end
	return nil
end

function Game.call(fn, ...)
	local set = setthreadidentity or set_thread_identity
	local get = getthreadidentity or get_thread_identity
	if type(set) ~= "function" or type(get) ~= "function" then
		return fn(...)
	end
	local previous = get()
	set(Const.GAME_IDENTITY)
	local results = table.pack(pcall(fn, ...))
	set(previous)
	if not results[1] then
		error(results[2], 0)
	end
	return table.unpack(results, 2, results.n)
end

function Game.press(input)
	Game.call(Game.InputHandler.VirtualPress, input)
end

function Game.release(input)
	Game.call(Game.InputHandler.VirtualRelease, input)
end

function Game.itemCount(itemName)
	local data = Game.data()
	local entry = data and data.Inventory.Inventory:FindFirstChild(itemName)
	if not entry then
		return 0
	end
	local amount = entry:FindFirstChild("Amount")
	return amount and amount.Value or 1
end

function Game.oreCount()
	local total = 0
	for _, name in ipairs(Const.ORES) do
		total += Game.itemCount(name)
	end
	return total
end

function Game.npcPosition(npcName)
	local ok, position = pcall(Game.Regions.GetNpcSpawn, npcName)
	if ok and typeof(position) == "Vector3" then
		return position
	end
	return nil
end

function Game.questHolder()
	local data = Game.data()
	return data and data.Quests.Holder
end

function Game.findActiveQuest(questKey)
	local holder = Game.questHolder()
	if not holder then
		return nil
	end
	for _, quest in ipairs(holder:GetChildren()) do
		local questString = quest:FindFirstChild("QuestString")
		if questString and questString.Value == questKey then
			return quest
		end
	end
	return nil
end

function Game.sidesFor()
	local ok, sides = pcall(Game.PlayerProgression.SidesFor, LocalPlayer)
	return ok and type(sides) == "table" and sides or {}
end

local Character = {}

function Character.get()
	return LocalPlayer.Character
end

function Character.root()
	local character = LocalPlayer.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

function Character.humanoid()
	local character = LocalPlayer.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

function Character.alive()
	local humanoid = Character.humanoid()
	return humanoid ~= nil and humanoid.Health > 0 and Character.root() ~= nil
end

local Catalog = {
	Mobs = {},
	MobsBySlot = {},
	MobsByCode = {},
	MobOptions = {},
	MobByOption = {},
	ItemSources = {},
	Quests = {},
	QuestByKey = {},
	QuestOptions = {},
	QuestByOption = {},
	SoulNames = {},
}

do
	local npcData = {}
	local ok, table_ = pcall(Game.LiveConfig.get, "NpcDataTable")
	if ok and type(table_) == "table" then
		npcData = table_
	end

	for code, entry in pairs(npcData) do
		if type(entry) == "table" and type(entry.Rewards) == "table" then
			for item in pairs(entry.Rewards) do
				if type(item) == "string" and item ~= "Exp" and item ~= "Wen" then
					Catalog.ItemSources[item] = Catalog.ItemSources[item] or {}
					table.insert(Catalog.ItemSources[item], code)
				end
			end
		end
	end

	local activeType = Game.Menum.npcType and Game.Menum.npcType.Active
	for _, regionModule in ipairs(Game.Content and Game.Content:GetChildren() or {}) do
		if regionModule:IsA("ModuleScript") then
			local loaded, content = pcall(require, regionModule)
			if loaded and type(content) == "table" and type(content.Npcs) == "table" then
				for _, npc in ipairs(content.Npcs) do
					local sendOver = type(npc.SendOver) == "table" and npc.SendOver or {}
					local spawning = type(sendOver.Spawning) == "table" and sendOver.Spawning or {}
					local settings = type(sendOver.Settings) == "table" and sendOver.Settings or {}
					if npc.Type == activeType and type(settings.NpcCode) == "string" and type(npc.Name) == "string" then
						local spawns = {}
						for _, location in ipairs(type(spawning.Locations) == "table" and spawning.Locations or {}) do
							if typeof(location) == "Vector3" then
								table.insert(spawns, location)
							end
						end
						local center = typeof(spawning.Center) == "Vector3" and spawning.Center or spawns[1]
						local data = npcData[settings.NpcCode]
						local combatant = true
						if type(data) == "table" and type(data.Rewards) == "table" and next(data.Rewards) == nil then
							combatant = false
						end
						local mob = {
							Name = npc.Name,
							SpawnTime = type(spawning.SpawnTime) == "number" and spawning.SpawnTime or 0,
							Code = settings.NpcCode,
							Region = regionModule.Name,
							Spawns = spawns,
							Center = center,
							Boss = sendOver.Boss ~= nil,
							Combatant = combatant,
							Reputation = type(data) == "table" and tonumber(data.ReputationCoefficient) or 0,
						}
						table.insert(Catalog.Mobs, mob)
						Catalog.MobsBySlot[mob.Region .. "\0" .. mob.Name] = mob
						Catalog.MobsByCode[mob.Code] = Catalog.MobsByCode[mob.Code] or {}
						table.insert(Catalog.MobsByCode[mob.Code], mob)
					end
				end
			end
		end
	end

	local nameCounts = {}
	for _, mob in ipairs(Catalog.Mobs) do
		if mob.Combatant then
			nameCounts[mob.Name] = (nameCounts[mob.Name] or 0) + 1
		end
	end
	for _, mob in ipairs(Catalog.Mobs) do
		if mob.Combatant then
			local label = nameCounts[mob.Name] > 1 and (mob.Name .. " (" .. mob.Region .. ")") or mob.Name
			mob.Label = label
			Catalog.MobByOption[label] = mob
			table.insert(Catalog.MobOptions, label)
		end
	end
	table.sort(Catalog.MobOptions)

	local progressers = Game.PlayerProgression.Progressers
	local souls = type(progressers) == "table" and progressers.Demons
	if type(souls) == "table" then
		for soulName in pairs(souls) do
			Catalog.SoulNames[soulName] = true
		end
	end
end

local QuestPlans = {}

function QuestPlans.taskKind(spec, code)
	local specType = type(spec) == "table" and spec.Type or nil
	if specType == "Pickup" or specType == "Deposit" then
		return specType
	elseif specType == "Deliver" then
		if type(spec.TargetNpc) == "string" then
			return "Deliver"
		end
		return nil
	elseif specType == "Collect" then
		local sources = type(spec.RequiredItem) == "string" and Catalog.ItemSources[spec.RequiredItem]
		if sources then
			for _, sourceCode in ipairs(sources) do
				if Catalog.MobsByCode[sourceCode] then
					return "Collect"
				end
			end
		end
		return nil
	elseif specType == nil and Catalog.MobsByCode[code] then
		return "Kill"
	end
	return nil
end

function QuestPlans.analyze(key, info)
	local instance = info.QuestInstance
	local tasksFolder = instance and instance:FindFirstChild("Tasks")
	if not tasksFolder then
		return nil
	end
	local requirements = type(info.Requirements) == "table" and info.Requirements or {}
	local plan = {
		Key = key,
		Info = info,
		Name = instance.Name,
		Category = Game.Quests.GetQuestCategory(key),
		Level = type(requirements.Level) == "number" and requirements.Level or 0,
		Giver = type(info.OfferNpc) == "string" and info.OfferNpc or nil,
		Tasks = {},
		Supported = info.Event == nil,
		Unsupported = {},
	}
	for _, taskConfig in ipairs(tasksFolder:GetChildren()) do
		local codeValue = taskConfig:FindFirstChild("Code")
		local code = codeValue and codeValue.Value or taskConfig.Name
		local spec = type(info.TaskSpecs) == "table" and info.TaskSpecs[taskConfig.Name] or nil
		local kind = QuestPlans.taskKind(spec, code)
		if not kind then
			plan.Supported = false
			table.insert(plan.Unsupported, taskConfig.Name)
		end
		plan.Tasks[taskConfig.Name] = { Name = taskConfig.Name, Kind = kind, Spec = spec, Code = code }
	end
	return plan
end

do
	for key, info in pairs(Game.Quests.Holder) do
		if type(key) == "string" and type(info) == "table" then
			local plan = QuestPlans.analyze(key, info)
			if plan then
				Catalog.QuestByKey[key] = plan
				table.insert(Catalog.Quests, plan)
			end
		end
	end
	table.sort(Catalog.Quests, function(a, b)
		if a.Level ~= b.Level then
			return a.Level < b.Level
		end
		return a.Name < b.Name
	end)
	for _, plan in ipairs(Catalog.Quests) do
		if plan.Supported and plan.Giver then
			local label = plan.Level > 0 and string.format("%s (Lv %d)", plan.Name, plan.Level) or plan.Name
			plan.Label = label
			Catalog.QuestByOption[label] = plan
			table.insert(Catalog.QuestOptions, label)
		end
	end
end

local Mobs = {}

function Mobs.eachDungeonEnemy(callback)
	local pending = { Workspace:FindFirstChild("Humanoids") }
	while #pending > 0 do
		local node = table.remove(pending)
		for _, child in ipairs(node:GetChildren()) do
			if child:IsA("Folder") then
				table.insert(pending, child)
			elseif child:IsA("Model") and child:GetAttribute("PveEnemy") ~= nil then
				local root = child:FindFirstChild("HumanoidRootPart")
				local humanoid = child:FindFirstChildOfClass("Humanoid")
				if root and humanoid and humanoid.Health > 0 and callback(child, root, nil) == false then
					return
				end
			end
		end
	end
end

function Mobs.eachAlive(callback)
	if Hub.InDungeon then
		Mobs.eachDungeonEnemy(callback)
		return
	end
	local humanoids = Workspace:FindFirstChild("Humanoids")
	local regions = humanoids and humanoids:FindFirstChild("Regions")
	if not regions then
		return
	end
	for _, region in ipairs(regions:GetChildren()) do
		local active = region:FindFirstChild("ActiveNpcs")
		if active then
			for _, slot in ipairs(active:GetChildren()) do
				for _, model in ipairs(slot:GetChildren()) do
					if model:IsA("Model") then
						local root = model:FindFirstChild("HumanoidRootPart")
						local humanoid = model:FindFirstChildOfClass("Humanoid")
						if root and humanoid and humanoid.Health > 0 then
							if callback(model, root, Catalog.MobsBySlot[region.Name .. "\0" .. slot.Name]) == false then
								return
							end
						end
					end
				end
			end
		end
	end
end

function Mobs.isCombatTarget(model, entry)
	if Hub.InDungeon then
		return model:GetAttribute("PveEnemy") ~= nil
	end
	if model:GetAttribute("IsMob") ~= true then
		return false
	end
	return entry == nil or entry.Combatant
end

function Mobs.isAlive(model)
	if not model or not model.Parent then
		return false
	end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	return humanoid ~= nil and humanoid.Health > 0 and model:FindFirstChild("HumanoidRootPart") ~= nil
end

function Mobs.nearest(accept, maxDistance)
	local root = Character.root()
	if not root then
		return nil
	end
	local origin = root.Position
	local bestModel, bestDistance = nil, maxDistance or math.huge
	Mobs.eachAlive(function(model, mobRoot, entry)
		if Mobs.isCombatTarget(model, entry) and (accept == nil or accept(model, entry)) then
			local distance = (mobRoot.Position - origin).Magnitude
			if distance <= bestDistance then
				bestModel, bestDistance = model, distance
			end
		end
	end)
	return bestModel, bestDistance
end

local DayCycle = {}

function DayCycle.lengths()
	local config = Game.GameSettings.Day
	local studio = Game.GameSettings.IsStudio
	local day = studio and config.DayTime.Studio or config.DayTime.Game
	local night = studio and config.NighTime.Studio or config.NighTime.Game
	return day, night, config.Inversed == true
end

function DayCycle.nightFrom(at)
	if not Game.DayNight.IsEnabled() then
		return at
	end
	local anchor = Workspace:GetAttribute("DayCycleAnchor")
	if typeof(anchor) ~= "number" then
		if Game.DayNight.IsNight() then
			return at
		end
		return math.max(at, Workspace:GetServerTimeNow() + Game.DayNight.SecondsUntilPhaseChange())
	end
	local day, night, inversed = DayCycle.lengths()
	local cycle = day + night
	local phase = (at - anchor) % cycle
	if inversed then
		return phase < night and at or at + (cycle - phase)
	end
	return phase >= day and at or at + (day - phase)
end

local WorldBoss = { List = {}, ByOption = {}, Options = {} }

do
	for _, mob in ipairs(Catalog.Mobs) do
		if mob.Boss and mob.Center then
			table.insert(WorldBoss.List, mob)
		end
	end
	table.sort(WorldBoss.List, function(a, b)
		return a.Name < b.Name
	end)
	for index, boss in ipairs(WorldBoss.List) do
		boss.BossOrder = index
		local label = boss.Label or boss.Name
		boss.BossLabel = label
		WorldBoss.ByOption[label] = boss
		table.insert(WorldBoss.Options, label)
	end
end

function WorldBoss.slot(boss)
	local humanoids = Workspace:FindFirstChild("Humanoids")
	local regions = humanoids and humanoids:FindFirstChild("Regions")
	local region = regions and regions:FindFirstChild(boss.Region)
	local active = region and region:FindFirstChild("ActiveNpcs")
	return active and active:FindFirstChild(boss.Name)
end

function WorldBoss.model(boss, slot)
	slot = slot or WorldBoss.slot(boss)
	local model = slot and slot:FindFirstChildOfClass("Model")
	if model and Mobs.isAlive(model) then
		return model
	end
	return nil
end

function WorldBoss.center(boss, slot)
	slot = slot or WorldBoss.slot(boss)
	local info = slot and slot:FindFirstChild("BossInfo")
	local center = info and info:GetAttribute("Center")
	return typeof(center) == "Vector3" and center or boss.Center
end

function WorldBoss.spawnAt(boss, slot)
	slot = slot or WorldBoss.slot(boss)
	if not slot then
		return nil
	end
	local now = Workspace:GetServerTimeNow()
	local despawnedAt = slot:GetAttribute("DespawnedAt")
	if typeof(despawnedAt) ~= "number" then
		return now
	end
	local info = slot:FindFirstChild("BossInfo")
	local spawnTime = info and info:GetAttribute("SpawnTime")
	local ready = despawnedAt + (type(spawnTime) == "number" and spawnTime or boss.SpawnTime)
	if info and info:GetAttribute("OnlyAtNight") == true then
		ready = DayCycle.nightFrom(ready)
	end
	return ready
end

function WorldBoss.state(boss)
	local slot = WorldBoss.slot(boss)
	if not slot then
		return "Unknown"
	end
	if WorldBoss.model(boss, slot) then
		return "Alive"
	end
	local spawnAt = WorldBoss.spawnAt(boss, slot)
	local remaining = spawnAt and spawnAt - Workspace:GetServerTimeNow()
	if not remaining then
		return "Unknown"
	end
	if remaining <= 0 then
		return "Up"
	end
	return "Respawning", remaining
end

function WorldBoss.clock(seconds)
	seconds = math.max(math.ceil(seconds), 0)
	return string.format("%d:%02d", seconds // 60, seconds % 60)
end

local BossFarm = { Thread = nil, Context = nil, Current = nil, Mark = nil, LastBoss = nil, OrderList = nil, Crowded = setmetatable({}, { __mode = "k" }), SawKill = false, KillAt = nil, Kills = 0, StreamAt = 0, LootUntil = 0, LootHardUntil = 0, LootAt = nil, Phase = "Off", Focus = nil, RestPending = false, RestUntil = 0, RestHold = nil }

local BossHunt = { Thread = nil, Context = nil, Busy = false, Phase = "Off", Boss = nil, Tier = nil, Quest = nil, Finished = 0, RestUntil = 0, RestHold = nil, Blocked = {}, Options = {}, Rank = {} }

local YetiFarm = { Thread = nil, Context = nil, Busy = false, Phase = "Off", Kills = 0, MinionKills = 0, KilledAt = nil, LootHardUntil = 0, LootUntil = 0, LootAt = nil, BuyThread = nil, BuyStatus = "Off", BuyRetryAt = 0, Bought = 0 }

local CacheFarm = { Thread = nil, Context = nil, Busy = false, Phase = "Off", NextAt = 0, Target = nil, Guard = nil, Opened = 0, OpenedByTier = {}, GuardKills = 0, GuardInstaKills = 0, GuardNames = {}, Fought = {}, Denied = false, LimitAt = nil, LimitText = nil, LimitSignature = nil, CanDetect = false, Tiers = {}, ById = {}, Options = {} }

local BossStats = { StartedAt = nil, StoppedAt = nil, Kills = 0, BossKills = 0, LastBoss = nil, Pouches = 0, PouchSeen = nil, Ores = 0, OreSeen = nil }

local Schematics = { Thread = nil, Context = nil, Busy = false, Phase = "Off", Current = nil, Target = nil, Entries = {}, Options = {}, ByOption = {}, Skip = {}, Notes = {}, Statues = {}, Simon = {}, KeysTried = {}, LastKey = nil, Levers = {}, Removed = {}, GearHeld = false }

function BossFarm.claims()
	return (BossFarm.Context ~= nil and BossFarm.Current ~= nil) or BossHunt.Busy or YetiFarm.Busy or CacheFarm.Busy or Schematics.Busy
end

function BossFarm.pauseText()
	local boss = (BossFarm.Context ~= nil and BossFarm.Current ~= nil) or BossHunt.Busy or YetiFarm.Busy
	if CacheFarm.Busy and not boss then
		return "Paused for cache farm"
	end
	if Schematics.Busy and not boss then
		return "Paused for schematics"
	end
	return "Paused for world boss"
end

local Pose = {}

function Pose.around(targetRoot)
	local targetCFrame = targetRoot.CFrame
	local targetPosition = targetCFrame.Position
	local mode = Settings.FarmPosition
	if mode == "In Front" or mode == "Behind" then
		local look = targetCFrame.LookVector
		local flat = Vector3.new(look.X, 0, look.Z)
		flat = flat.Magnitude > 0.01 and flat.Unit or Vector3.new(0, 0, -1)
		local side = targetPosition + flat * (mode == "In Front" and Settings.Distance or -Settings.Distance)
		if Settings.Distance < 0.05 then
			return CFrame.new(side) * targetCFrame.Rotation
		end
		return CFrame.lookAt(side, Vector3.new(targetPosition.X, side.Y, targetPosition.Z))
	end
	if mode == "Below" then
		local below = targetPosition - Vector3.new(0, math.max(Settings.Distance, 0.05), 0)
		return CFrame.lookAt(below, below + Vector3.yAxis, targetCFrame.LookVector)
	end
	local position = targetPosition + Vector3.new(0, Settings.Distance, 0)
	if Settings.Distance < 0.05 then
		return CFrame.new(position) * targetCFrame.Rotation
	end
	return CFrame.lookAt(position, targetPosition, targetCFrame.LookVector)
end

local Journey = { Thread = nil, Target = nil, Holding = false, Mounted = false, MountedAt = 0, LostSince = nil, Previous = nil, NextTry = 0, Failures = 0, NoticeAt = -math.huge, UnequipAt = -math.huge, IdleSince = nil, Status = "Idle" }

function Journey.values()
	local ok, values = pcall(Game.Utility.getvaluesfolder, LocalPlayer)
	return ok and values or nil
end

function Journey.riding()
	local character = LocalPlayer.Character
	if not character or character:GetAttribute("OnHorse") ~= true then
		return false
	end
	local values = Journey.values()
	return values ~= nil and values:FindFirstChild("RidingHorse") ~= nil
end

function Journey.horseId()
	local data = Game.data()
	local entry = data and data.Inventory.Inventory:FindFirstChild(Const.HORSE_ITEM)
	local id = entry and entry:FindFirstChild("Id")
	return id and id.Value, data
end

function Journey.toolbarSlot(toolbar, id)
	for index, name in ipairs(Const.SLOT_NAMES) do
		local slot = toolbar:FindFirstChild(name)
		if slot and slot.Value == id then
			return index
		end
	end
	return nil
end

function Journey.slotState()
	local id, data = Journey.horseId()
	local toolbar = data and data.Inventory:FindFirstChild("Toolbar")
	if not id or not toolbar then
		return nil, "No horse owned", nil
	end
	local current = Journey.toolbarSlot(toolbar, id)
	local choice = tonumber(string.match(tostring(Settings.HorseSlot), "%d+"))
	if current and (not choice or choice == current) then
		return current
	end
	if not current then
		return nil, "Horse is not on your toolbar", "Put your Horse on a toolbar slot, then set Horse Slot to that slot in Tactics > Movement. Travelling on foot until then."
	end
	return nil, "Horse is on slot " .. current .. ", not slot " .. choice, "Your Horse is on slot " .. current .. " but Horse Slot is set to slot " .. choice .. ". Change Horse Slot in Tactics > Movement. Travelling on foot until then."
end

function Journey.slot()
	local slot, reason, notice = Journey.slotState()
	if not slot and notice and os.clock() - Journey.NoticeAt >= Const.HORSE_NOTICE_INTERVAL then
		Journey.NoticeAt = os.clock()
		Hub.Notify({
			Title = "Set up your Horse",
			Content = notice,
			Type = "Warning",
			Icon = "triangle-alert",
			Duration = 8,
		})
	end
	return slot, reason
end

function Journey.equipped()
	local config = LocalPlayer:FindFirstChild("Items_Config")
	return config and config:FindFirstChild("Equipped")
end

function Journey.canMount()
	if Hub.InMinigame then
		return false, "Horse paused in a minigame"
	end
	if not Character.alive() then
		return false, "Dead"
	end
	local slot, reason = Journey.slot()
	if not slot then
		return false, reason
	end
	local cooldown = tonumber(Game.GameSettings.horseEquipCooldown) or 5
	if os.clock() - Journey.UnequipAt < cooldown + Const.HORSE_COOLDOWN_PAD then
		return false, "Horse on cooldown"
	end
	if Game.InCombat.biasedCheck(LocalPlayer) or Game.Checker.check(LocalPlayer) ~= true then
		return false, "In combat, horse unavailable"
	end
	return true
end

function Journey.mount()
	local slot, reason = Journey.slot()
	local equipped = Journey.equipped()
	if not slot or not equipped then
		Journey.Status = reason or "Could not find the equipped slot"
		return false
	end
	Journey.Status = "Mounting horse"
	Journey.Mounted = true
	Journey.MountedAt = os.clock()
	Journey.LostSince = nil
	if equipped.Value ~= slot then
		Journey.Previous = equipped.Value
		equipped.Value = slot
	end
	local deadline = os.clock() + Const.HORSE_MOUNT_TIMEOUT
	while os.clock() < deadline and Character.alive() and Journey.Target do
		if Journey.riding() then
			Journey.Status = "Riding"
			return true
		end
		task.wait(0.1)
	end
	Journey.dismount(Journey.Target and "Horse did not mount" or "Idle")
	return false
end

function Journey.dismount(status)
	if not Journey.Mounted then
		return
	end
	Journey.Mounted = false
	Journey.IdleSince = nil
	Journey.LostSince = nil
	Journey.UnequipAt = os.clock()
	local equipped = Journey.equipped()
	local id, data = Journey.horseId()
	local toolbar = data and data.Inventory:FindFirstChild("Toolbar")
	local slotName = equipped and Const.SLOT_NAMES[equipped.Value]
	local slot = slotName and toolbar and toolbar:FindFirstChild(slotName)
	if slot and id and slot.Value == id then
		equipped.Value = Journey.Previous or 0
	end
	Journey.Previous = nil
	Journey.Status = status or "Idle"
end

function Journey.arrive(now)
	Journey.Target = nil
	if not Journey.Mounted or Journey.Thread then
		Journey.IdleSince = nil
		return
	end
	Journey.IdleSince = Journey.IdleSince or now
	if now - Journey.IdleSince >= Settings.DismountDelay then
		Journey.dismount()
	end
end

function Journey.update(now)
	if not Journey.Mounted or Journey.Holding then
		Journey.LostSince = nil
		return
	end
	if Journey.riding() then
		Journey.LostSince = nil
		return
	end
	Journey.LostSince = Journey.LostSince or now
	if now - Journey.LostSince >= Const.HORSE_LOST_GRACE then
		Journey.dismount("Knocked off the horse")
	end
end

function Journey.settle(now)
	Journey.arrive(now)
end

function Journey.run()
	local attempted, mounted = false, false
	local ok, err = pcall(function()
		local root = Character.root()
		if not root or not Journey.Target or (Journey.Target - root.Position).Magnitude < Const.HORSE_MIN_DISTANCE or Journey.riding() then
			return
		end
		local can, reason = Journey.canMount()
		if not can then
			Journey.Status = reason
			return
		end
		attempted = true
		Journey.Holding = true
		mounted = Journey.mount()
	end)
	Journey.Holding = false
	if not ok then
		warn("[Spryzen Hub] journey error: " .. tostring(err))
		attempted = true
	end
	if mounted then
		Journey.Failures = 0
	elseif attempted then
		Journey.Failures += 1
	end
	local delay = Const.JOURNEY_RETRY
	if attempted and not mounted then
		delay = math.min(Const.JOURNEY_RETRY * 2 ^ (Journey.Failures - 1), Const.JOURNEY_RETRY_MAX)
	end
	Journey.NextTry = os.clock() + delay
	Journey.Thread = nil
end

function Journey.want(target, distance)
	Journey.Target = target
	Journey.IdleSince = nil
	if Journey.Thread or distance < Const.HORSE_MIN_DISTANCE or os.clock() < Journey.NextTry or Journey.riding() then
		return
	end
	local thread = coroutine.create(Journey.run)
	Journey.Thread = thread
	task.spawn(thread)
end

function Journey.shutdown()
	local thread = Journey.Thread
	Journey.Thread = nil
	Journey.Holding = false
	Journey.Target = nil
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
	Journey.dismount()
end

function Journey.text()
	if Journey.Holding then
		return Journey.Status, "Warning"
	elseif Journey.riding() then
		return "Riding", "Success"
	elseif Journey.Status == "Idle" or (not Journey.Mounted and os.clock() > Journey.NextTry + 3) then
		local slot, reason = Journey.slotState()
		if slot then
			return "Ready on slot " .. slot, "Muted"
		end
		return reason, "Warning"
	end
	return Journey.Status, "Warning"
end

local Mover = { Leases = {}, Active = nil, NoclipSaved = nil, StreamedTo = nil, Travelling = false, Teleporting = false, TeleportAt = -math.huge, Speed = 0, SpeedLease = nil, SnapLog = {}, Placed = nil, Trail = {}, SampleAt = 0, SnapbackAt = -math.huge, ResetAt = -math.huge, Snapbacks = 0, Walking = false, DashFollow = nil, DashBusyUntil = 0 }

local Lease = {}
Lease.__index = Lease

function Mover.acquire(owner, priority)
	local lease = setmetatable({ Owner = owner, Priority = priority, Goal = nil, Released = false }, Lease)
	table.insert(Mover.Leases, lease)
	return lease
end

function Mover.select()
	local best = nil
	for _, lease in ipairs(Mover.Leases) do
		if lease.Goal and (best == nil or lease.Priority > best.Priority) then
			best = lease
		end
	end
	return best
end

function Mover.setNoclip(enabled)
	local character = Character.get()
	if enabled then
		if not Mover.NoclipSaved then
			Mover.NoclipSaved = {}
		end
		if character then
			for _, part in ipairs(character:GetChildren()) do
				if part:IsA("BasePart") then
					if Mover.NoclipSaved[part] == nil then
						Mover.NoclipSaved[part] = part.CanCollide
					end
					part.CanCollide = false
				end
			end
		end
	elseif Mover.NoclipSaved then
		for part, value in pairs(Mover.NoclipSaved) do
			if part.Parent then
				part.CanCollide = value
			end
		end
		Mover.NoclipSaved = nil
	end
end

function Mover.requestStream(position)
	if Mover.StreamedTo and (Mover.StreamedTo - position).Magnitude < Const.TELEPORT_STREAM_DISTANCE then
		return
	end
	Mover.StreamedTo = position
	task.spawn(function()
		local ok, err = pcall(LocalPlayer.RequestStreamAroundAsync, LocalPlayer, position)
		if not ok then
			warn("[Spryzen Hub] stream request failed: " .. tostring(err))
		end
	end)
end

function Mover.remember(position, now, force)
	if not force and now - Mover.SampleAt < Const.SNAPBACK_SAMPLE then
		return
	end
	Mover.SampleAt = now
	table.insert(Mover.Trail, { Position = position, Time = now })
	while Mover.Trail[1] and now - Mover.Trail[1].Time > Const.SNAPBACK_WINDOW do
		table.remove(Mover.Trail, 1)
	end
end

function Mover.snapback(now)
	Mover.SnapbackAt = now
	Mover.Snapbacks += 1
	table.clear(Mover.Trail)
	table.insert(Mover.SnapLog, now)
	while Mover.SnapLog[1] and now - Mover.SnapLog[1] > Const.SNAPBACK_RESET_WINDOW do
		table.remove(Mover.SnapLog, 1)
	end
	if not Settings.ResetOnSnapback or #Mover.SnapLog < Const.SNAPBACK_RESET_COUNT or now - Mover.ResetAt < Const.SNAPBACK_RESET_COOLDOWN then
		return
	end
	table.clear(Mover.SnapLog)
	local humanoid = Character.humanoid()
	if humanoid and humanoid.Health > 0 then
		Mover.ResetAt = now
		humanoid.Health = 0
	end
end

function Mover.checkSnapback(root, now)
	local placed = Mover.Placed
	Mover.Placed = nil
	if not placed or placed.Root ~= root then
		table.clear(Mover.Trail)
		return false
	end
	local position = root.Position
	if (position - placed.Position).Magnitude < Const.SNAPBACK_DISTANCE then
		return false
	end
	for _, mark in ipairs(Mover.Trail) do
		if now - mark.Time <= Const.SNAPBACK_WINDOW and (mark.Position - position).Magnitude <= Const.SNAPBACK_MATCH then
			Mover.snapback(now)
			return true
		end
	end
	return false
end

function Mover.place(root, cframe, now)
	local origin = root.Position
	Mover.remember(origin, now, (cframe.Position - origin).Magnitude >= Const.SNAPBACK_DISTANCE)
	root.CFrame = cframe
	Mover.Placed = { Root = root, Position = cframe.Position }
end

function Mover.hold(root, cframe, now)
	root.AssemblyLinearVelocity = Vector3.zero
	Mover.Speed = 0
	Mover.place(root, cframe, now)
end

function Mover.dash()
	local handler = Game.DashHandler
	if handler then
		pcall(Game.call, handler.Perform, "W")
	end
end

function Mover.glide(root, goal, offset, distance, dt, now, top)
	if distance <= Const.SNAP_DISTANCE then
		Mover.Travelling = false
		Mover.hold(root, goal, now)
		return
	end
	Mover.Travelling = true
	Mover.Speed = math.min(top, Mover.Speed + Const.TWEEN_ACCEL * dt)
	local direction = offset.Unit
	local step = math.min(distance, Mover.Speed * dt)
	local position = root.Position + direction * step
	root.AssemblyLinearVelocity = step < distance and direction * Mover.Speed or Vector3.zero
	local flat = Vector3.new(offset.X, 0, offset.Z)
	if distance <= Const.CLOSE_DISTANCE or flat.Magnitude <= 0.05 then
		Mover.place(root, CFrame.new(position) * goal.Rotation, now)
	else
		Mover.place(root, CFrame.lookAt(position, position + flat), now)
	end
end

function Mover.horseTravel(root, goal, offset, distance, dt, now)
	if Settings.MovementType ~= "Horse" then
		if Journey.Mounted or Journey.Thread then
			Journey.shutdown()
		end
		return false
	end
	local riding = Journey.riding()
	if distance >= Const.HORSE_MIN_DISTANCE or (riding and distance >= Const.HORSE_KEEP_DISTANCE) then
		Journey.want(goal.Position, distance)
	else
		Journey.arrive(now)
	end
	if not (Journey.Holding or Journey.Mounted) then
		return false
	end
	Mover.stabilize(nil, false)
	Mover.DashFollow = nil
	Mover.Teleporting = false
	if Journey.Holding or not Journey.riding() or not Journey.Target then
		Mover.Travelling = true
		Mover.Placed = nil
		Mover.Speed = 0
		root.AssemblyLinearVelocity = Vector3.zero
		return true
	end
	Mover.glide(root, goal, offset, distance, dt, now, Settings.HorseSpeed)
	return true
end

function Mover.dashTrip(lease, root, goal, now)
	Mover.hold(root, goal, now)
	Mover.dash()
	Mover.TeleportAt = now
	Mover.DashBusyUntil = now + Const.DASH_BUSY
	Mover.DashFollow = { Lease = lease, Goal = goal.Position }
end

function Mover.dashBusy()
	if not Mover.Active then
		return false
	end
	local follow = Mover.DashFollow
	return Mover.Teleporting or os.clock() < Mover.DashBusyUntil or follow == nil
end

function Mover.dashTravel(lease, root, goal, offset, distance, dt, now)
	Mover.Teleporting = false
	local follow = Mover.DashFollow
	if follow and follow.Lease == lease and (goal.Position - follow.Goal).Magnitude <= Const.DASH_NEW_TARGET then
		local moved = (goal.Position - follow.Goal).Magnitude
		follow.Goal = goal.Position
		Mover.Travelling = false
		Mover.hold(root, goal, now)
		if moved / math.max(dt, 1 / 240) >= Const.DASH_KNOCKBACK_SPEED and now - Mover.TeleportAt >= Const.DASH_KNOCKBACK_GAP then
			Mover.dash()
			Mover.TeleportAt = now
		end
		return
	end
	Mover.Travelling = true
	Mover.Teleporting = true
	Mover.dashTrip(lease, root, goal, now)
end

Mover.Body = nil

function Mover.stabilize(root, enabled)
	local body = Mover.Body
	if body and (not enabled or body.Root ~= root) then
		Mover.Body = nil
		pcall(function()
			body.Mover:Destroy()
			body.Attachment:Destroy()
			if body.Humanoid.Parent then
				for _, state in ipairs(Const.BODY_STATES) do
					body.Humanoid:SetStateEnabled(state, true)
				end
			end
		end)
		body = nil
	end
	if not enabled or not root then
		return
	end
	local humanoid = Character.humanoid()
	if not humanoid then
		return
	end
	if not body then
		local attachment = Instance.new("Attachment")
		attachment.Name = "BodyHoldAttach"
		attachment.Parent = root
		local hold = Instance.new("LinearVelocity")
		hold.Name = "BodyHold"
		hold.Attachment0 = attachment
		hold.RelativeTo = Enum.ActuatorRelativeTo.World
		hold.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
		hold.MaxForce = math.huge
		hold.VectorVelocity = Vector3.zero
		hold.Parent = root
		for _, state in ipairs(Const.BODY_STATES) do
			humanoid:SetStateEnabled(state, false)
		end
		body = { Root = root, Humanoid = humanoid, Attachment = attachment, Mover = hold }
		Mover.Body = body
	end
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	Mover.setNoclip(true)
	if humanoid:GetState() ~= Enum.HumanoidStateType.GettingUp and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end

function Mover.step(dt)
	local lease = Mover.select()
	Mover.Active = lease
	local root = Character.root()
	local now = os.clock()
	Journey.update(now)
	if Mover.Walking then
		lease = nil
		Mover.Active = nil
	end
	if not lease or not root or not Character.alive() then
		Journey.settle(now)
		Mover.stabilize(nil, false)
		Mover.Travelling = false
		Mover.Teleporting = false
		Mover.Placed = nil
		Mover.DashFollow = nil
		Mover.Speed = 0
		if Mover.NoclipSaved and not (Settings.Noclip and root) then
			Mover.setNoclip(false)
		end
		return
	end
	local ok, goal = pcall(lease.Goal)
	if not ok or typeof(goal) ~= "CFrame" then
		Mover.Travelling = false
		Mover.Placed = nil
		return
	end
	if Mover.SpeedLease ~= lease then
		Mover.SpeedLease = lease
		Mover.Speed = 0
	end
	if Mover.checkSnapback(root, now) then
		Mover.Speed = 0
		Mover.DashFollow = nil
		if Mover.ResetAt == now then
			Mover.Travelling = false
			return
		end
	end
	local offset = goal.Position - root.Position
	local distance = offset.Magnitude
	if distance > Const.TELEPORT_STREAM_DISTANCE then
		Mover.requestStream(goal.Position)
	end
	if Mover.horseTravel(root, goal, offset, distance, dt, now) then
		return
	end
	Mover.dashTravel(lease, root, goal, offset, distance, dt, now)
	Mover.stabilize(root, true)
end

function Mover.traveling()
	return Mover.Travelling
end

function Lease:SetGoal(provider)
	self.Goal = provider
end

function Lease:IsActive()
	return Mover.Active == self
end

function Lease:Release()
	if self.Released then
		return
	end
	self.Released = true
	self.Goal = nil
	local index = table.find(Mover.Leases, self)
	if index then
		table.remove(Mover.Leases, index)
	end
end

function Lease:MoveTo(target, isCancelled)
	if self.Released then
		return false
	end
	self.Goal = function()
		return target
	end
	local root = Character.root()
	local distance = root and (root.Position - target.Position).Magnitude or 0
	local timeout = distance / Const.TRAVEL_TIMEOUT_SPEED + Const.TRAVEL_TIMEOUT_PADDING
	local started = os.clock()
	local last = started
	while not self.Released and not (isCancelled and isCancelled()) do
		root = Character.root()
		local now = os.clock()
		if not self:IsActive() and Mover.Active ~= nil then
			started += now - last
		end
		last = now
		if root and self:IsActive() and (root.Position - target.Position).Magnitude <= Const.ARRIVE_DISTANCE then
			return true
		end
		if now - started > timeout then
			return false
		end
		task.wait()
	end
	return false
end

function Mover.shutdown()
	for _, lease in ipairs(table.clone(Mover.Leases)) do
		lease:Release()
	end
	Mover.Active = nil
	Mover.Travelling = false
	Mover.DashFollow = nil
	Mover.Speed = 0
	Journey.shutdown()
	Mover.stabilize(nil, false)
	Mover.setNoclip(false)
end

RootMaid:Give(RunService.Stepped:Connect(function()
	if Mover.Active or Settings.Noclip then
		Mover.setNoclip(true)
	end
end))

RootMaid:Give(RunService.Heartbeat:Connect(function(dt)
	local ok, err = pcall(Mover.step, dt)
	if not ok then
		warn("[Spryzen Hub] movement error: " .. tostring(err))
	end
end))

RootMaid:Give(LocalPlayer.CharacterAdded:Connect(function()
	Mover.NoclipSaved = nil
	Mover.StreamedTo = nil
	Mover.Placed = nil
	table.clear(Mover.Trail)
	Journey.shutdown()
end))

local Priority = { Job = {}, Label = {}, ByLabel = {}, Options = {}, Rank = {}, Mode = {}, Owner = {}, Bound = setmetatable({}, { __mode = "k" }), Started = {}, Slots = {}, BeginQueued = false }

for index, job in ipairs(Const.PRIORITY_JOBS) do
	Priority.Job[job.Key] = job
	Priority.Label[job.Key] = job.Label
	Priority.ByLabel[job.Label] = job.Key
	Priority.Options[index] = job.Label
end

function Priority.level(key)
	return Const.PRIORITY_LEASE_TOP + 1 - (Priority.Rank[key] or #Const.PRIORITY_JOBS)
end

function Priority.rebuild()
	table.clear(Priority.Rank)
	local rank = 0
	for index = 1, #Const.PRIORITY_JOBS do
		local key = Priority.ByLabel[Settings.PriorityOrder[index]]
		if key and not Priority.Rank[key] then
			rank += 1
			Priority.Rank[key] = rank
		end
	end
	for _, job in ipairs(Const.PRIORITY_JOBS) do
		if not Priority.Rank[job.Key] then
			rank += 1
			Priority.Rank[job.Key] = rank
		end
	end
	for ctx in pairs(Priority.Bound) do
		ctx.Lease.Priority = Priority.level(ctx.Job)
	end
end

function Priority.bind(ctx, key)
	if ctx.Job == key then
		return
	end
	if ctx.Job and Priority.Owner[ctx.Job] == ctx then
		Priority.Mode[ctx.Job] = nil
		Priority.Owner[ctx.Job] = nil
	end
	ctx.Job = key
	ctx.Lease.Priority = Priority.level(key)
	Priority.Bound[ctx] = true
end

function Priority.set(ctx, mode)
	local key = ctx.Job
	if not key or ctx.Cancelled then
		return
	end
	Priority.Mode[key] = mode
	Priority.Owner[key] = mode and ctx or nil
end

function Priority.release(ctx)
	local key = ctx.Job
	Priority.Bound[ctx] = nil
	if key and Priority.Owner[key] == ctx then
		Priority.Mode[key] = nil
		Priority.Owner[key] = nil
	end
end

function Priority.engaged(ctx)
	local key = ctx.Job
	return key ~= nil and Priority.Owner[key] == ctx and Priority.Mode[key] == "Engaged"
end

function Priority.blocked(key)
	if not key or Priority.Mode[key] == "Engaged" then
		return nil
	end
	local best, bestRank = nil, Priority.Rank[key]
	for other, rank in pairs(Priority.Rank) do
		local mode = Priority.Mode[other]
		if mode and other ~= key then
			if mode == "Engaged" then
				return other
			end
			if rank < bestRank then
				best, bestRank = other, rank
			end
		end
	end
	return best
end

function Priority.holder()
	local best, bestRank = nil, math.huge
	for key, rank in pairs(Priority.Rank) do
		local mode = Priority.Mode[key]
		if mode == "Engaged" then
			return key, true
		end
		if mode and rank < bestRank then
			best, bestRank = key, rank
		end
	end
	return best, false
end

function Priority.pausedFor(key)
	return "Paused for " .. Priority.Label[key]
end

function Priority.statusText()
	local running = false
	for ctx in pairs(Priority.Bound) do
		if not ctx.Cancelled then
			running = true
			break
		end
	end
	if not running then
		return "The farm is off", "Muted"
	end
	local key, engaged = Priority.holder()
	if not key then
		return "No job has work right now", "Warning"
	end
	local waiting = 0
	for other in pairs(Priority.Rank) do
		if other ~= key and Priority.Mode[other] then
			waiting += 1
		end
	end
	local text = (engaged and "Finishing " or "Running ") .. Priority.Label[key]
	if waiting > 0 then
		text ..= " (" .. waiting .. " waiting)"
	end
	return text, "Success"
end

Priority.rebuild()

local AimAssist = { Target = nil, CheckedAt = 0, Circle = nil }

local Skills = {
	Casting = nil,
	Pressed = nil,
	AimTarget = nil,
	AimUntil = 0,
	NextCast = 0,
	ReservedUntil = 0,
	Cursor = 0,
	WindowClosedAt = 0,
	Failures = {},
	Backoff = {},
	OriginalMousepos = nil,
	Swapping = false,
	Status = "Idle",
	Bound = nil,
	BoundAt = 0,
}

local Potion = { Busy = false, Pressed = false, RetryAt = 0, Status = "Off", Lease = nil }

local Defense = { Watched = {}, Threats = {}, Catalog = nil, Holding = nil, PressedAt = -math.huge, PressStamp = nil, ReservedUntil = 0, Rtt = 0.1, RttAt = 0, ScanAt = 0, Hits = {}, HitStamp = nil, LastHitAt = 0, LastPoints = nil, RestUntil = 0, Parries = 0, PerfectWindows = 0, Blocks = 0, ParryStatus = "Off", BlockStatus = "Off", StatsService = game:GetService("Stats") }

local Heal = { Retreating = false, Lease = nil, Status = "Off" }

local Escape = { Active = false, Lease = nil, Status = "Off", Reason = nil, LowHp = false, Origin = nil, MinUntil = 0, MaxUntil = 0, ReadyAt = 0, Count = 0, Seen = {} }

local Dodge = { Telegraphs = {}, Active = false, Returning = false, Lease = nil, Origin = nil, Spot = nil, Goal = nil, Caster = nil, ClearAt = nil, RespotAt = 0, ReturnUntil = 0, Unavailable = false, Status = "Off", Count = 0 }

local Combat = {
	FarmTarget = nil,
	BossTarget = nil,
	Pressing = false,
	PressedAt = 0,
	LastEquip = 0,
	LastWeaponSlot = nil,
	LockedOut = false,
	AuraCombo = 1,
	AuraLastCombo = 0,
	AuraLastHit = 0,
	AuraFinishedAt = 0,
	Override = nil,
	Status = "Idle",
}

function Combat.toolLock()
	local values = Game.Utility.getvaluesfolder(LocalPlayer)
	local lock = values and values:FindFirstChild("tooldisabled")
	return lock and tostring(lock.Value) or nil
end

function Combat.itemAllowed(name)
	local lock = Combat.toolLock()
	if not lock or not name then
		return true
	end
	if string.find(lock, "all", 1, true) then
		return string.find(lock, "except" .. name, 1, true) ~= nil
	end
	return string.find(lock, name, 1, true) == nil
end

function Combat.slotItem(slot)
	local data = Game.data()
	local toolbar = data and data.Inventory:FindFirstChild("Toolbar")
	local entry = toolbar and Const.SLOT_NAMES[slot] and toolbar:FindFirstChild(Const.SLOT_NAMES[slot])
	if not entry or entry.Value == 0 then
		return nil
	end
	local item = Game.CharacterInfo.GetItemFromId(LocalPlayer, entry.Value)
	return item and item.Name
end

function Combat.slotAllowed(slot)
	return slot == 0 or Combat.itemAllowed(Combat.slotItem(slot))
end

function Combat.ensureWeapon()
	if Potion.Busy or Skills.Swapping or Journey.Mounted then
		return
	end
	local config = LocalPlayer:FindFirstChild("Items_Config")
	local equipped = config and config:FindFirstChild("Equipped")
	if not equipped then
		return
	end
	local override = Combat.Override and Combat.Override.Slot
	local slot = override or tonumber(Settings.WeaponSlot)
	if Combat.toolLock() then
		if not Combat.LockedOut then
			Combat.LockedOut = true
			Hub.Notify({
				Title = "Weapons locked",
				Content = "Your weapons are locked for this floor, so the script is fighting with your fists until they come back.",
				Type = "Warning",
				Icon = "hand",
				Duration = Const.LOCK_NOTICE_DURATION,
			})
		end
		if equipped.Value ~= 0 and not Combat.slotAllowed(equipped.Value) then
			slot = 0
		elseif not slot or not Combat.slotAllowed(slot) then
			return
		end
	else
		if equipped.Value ~= 0 then
			local name = Combat.slotItem(equipped.Value)
			local info = name and Game.Items[name]
			if type(info) == "table" and info.HasCombat == true then
				Combat.LastWeaponSlot = equipped.Value
			end
		end
		if Combat.LockedOut and not slot and equipped.Value == 0 then
			slot = Combat.LastWeaponSlot
		end
		if not slot or equipped.Value == slot or equipped.Value ~= 0 then
			Combat.LockedOut = false
		end
	end
	if not slot or equipped.Value == slot then
		return
	end
	if os.clock() - Combat.LastEquip < Const.WEAPON_EQUIP_INTERVAL then
		return
	end
	if slot ~= 0 and not Combat.slotItem(slot) then
		return
	end
	Combat.LastEquip = os.clock()
	equipped.Value = slot
end

function Combat.farmTarget()
	if Combat.BossTarget and Mobs.isAlive(Combat.BossTarget) then
		return Combat.BossTarget
	end
	if Combat.FarmTarget and Mobs.isAlive(Combat.FarmTarget) then
		return Combat.FarmTarget
	end
	return nil
end

function Combat.setPressing(pressing)
	if pressing == Combat.Pressing then
		return
	end
	Combat.Pressing = pressing
	if pressing then
		Combat.PressedAt = os.clock()
		Game.press("Combat")
	else
		Game.release("Combat")
	end
end

function Combat.stalled()
	local presets = Game.CombatPresets
	local last = math.max(tonumber(presets.Last_Punched) or 0, tonumber(presets.lastRunHit) or 0, Combat.PressedAt)
	local idle = os.clock() - last
	if idle < Const.M1_STALL_PAD then
		return false
	end
	local _, preset = Combat.resolvePreset()
	local final = preset and presets.Last_Combo == (preset.Max or 5)
	local gap = preset and (final and preset.final or preset.default) or presets.combo_duration or 1
	if idle < (gap or 0.25) + Const.M1_STALL_PAD then
		return false
	end
	return Game.Checker.check(LocalPlayer, "combat") == true
end

function Combat.finisherAt()
	local presets = Game.CombatPresets
	local at = Combat.AuraFinishedAt
	local _, preset = Combat.resolvePreset()
	if preset and presets.Last_Combo == (preset.Max or 5) then
		at = math.max(at, tonumber(presets.Last_Punched) or 0)
	end
	return at
end

function Combat.stepM1()
	local wanted = Settings.AutoM1
	if Combat.Override and Combat.Override.M1 ~= nil then
		wanted = Combat.Override.M1
	end
	if not wanted or Skills.Casting or Skills.Swapping or Skills.reserved() or Skills.comboWindow() or Potion.Busy or Defense.busy() or Heal.Retreating or Escape.Active or Dodge.Active or Journey.Mounted or Mover.dashBusy() or not Character.alive() then
		Combat.setPressing(false)
		return
	end
	if not Combat.farmTarget() then
		Combat.setPressing(false)
		return
	end
	Combat.ensureWeapon()
	if Game.Checker.check(LocalPlayer, "combat") ~= true then
		Combat.setPressing(false)
		return
	end
	if Combat.Pressing and Combat.stalled() then
		Combat.setPressing(false)
	end
	Combat.setPressing(true)
end

function Combat.resolvePreset()
	local items = Game.Items
	local presets = Game.CombatPresets.Presets
	local tool = Game.CharacterInfo.Get_equipped_tool(LocalPlayer)
	local toolInfo = tool and items[tool.Name]
	local combatName = nil
	if toolInfo and toolInfo.CombatPreset ~= nil and toolInfo.CombatPreset ~= "Combat" then
		combatName = tool.Name
	end
	if not combatName then
		for _, power in ipairs(string.split(Game.CurPower.Value, ",")) do
			if power ~= "" and Game.Animations:FindFirstChild(power .. "_Combat_Anims") then
				combatName = power
				break
			end
		end
	end
	if not combatName and tool and ((toolInfo and toolInfo.HasCombat) or Game.Animations:FindFirstChild(tool.Name .. "_Combat_Anims")) then
		combatName = tool.Name
	end
	if not combatName then
		return nil
	end
	local preset = presets[combatName]
	local presetName, style = combatName, nil
	if preset == nil then
		local info = items[combatName]
		if info ~= nil and (info.Breathing ~= nil or info.HasCombat or info.CombatPreset ~= nil) then
			presetName = info.CombatPreset or "Regular Katana"
			style = combatName
		end
		preset = presets[presetName]
	end
	if preset == nil then
		return nil
	end
	if style ~= nil and not Game.Swings:FindFirstChild(style .. "_Swings") then
		style = nil
	end
	return presetName, preset, style
end

function Combat.requiredGap(preset, combo)
	local presets = Game.CombatPresets
	local last = Combat.AuraLastCombo
	local gap
	if combo - 1 == last or (combo == 6 and combo - 2 == last) then
		gap = (preset.customDelay and preset.customDelay[combo]) or preset.default
	elseif combo == 1 then
		gap = (last == 5 or last == 7) and preset.final or presets.combo_duration
	else
		gap = presets.combo_duration
	end
	return (gap or presets.combo_duration) / presets.attackSpeedMult(LocalPlayer)
end

function Combat.faceTarget(model)
	if Mover.Active then
		return
	end
	local root = Character.root()
	local targetRoot = model:FindFirstChild("HumanoidRootPart")
	if not root or not targetRoot then
		return
	end
	local flat = Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z)
	if (flat - root.Position).Magnitude > 0.05 then
		root.CFrame = CFrame.lookAt(root.Position, flat)
	end
end

function Combat.stepAura()
	if not Settings.KillAura or Combat.Pressing or Skills.Casting or Skills.Swapping or Skills.reserved() or Skills.comboWindow() or Potion.Busy or Defense.busy() or Heal.Retreating or Escape.Active or Dodge.Active or Journey.Mounted or Mover.dashBusy() or not Character.alive() then
		return
	end
	local target = Combat.farmTarget()
	if not target then
		return
	end
	if Game.Checker.check(LocalPlayer, "combat") ~= true then
		return
	end
	Combat.ensureWeapon()
	local presetName, preset, style = Combat.resolvePreset()
	if not presetName then
		Combat.Status = "No combat weapon equipped"
		return
	end
	local presets = Game.CombatPresets
	local maxCombo = preset.Max or 5
	local combo = Combat.AuraCombo
	if os.clock() - Combat.AuraLastHit > presets.combo_duration then
		combo = 1
	end
	if os.clock() - Combat.AuraLastHit < Combat.requiredGap(preset, combo) then
		return
	end
	local speed = presets.attackSpeedMult(LocalPlayer)
	local swingWait = (preset.delay_before_swing and preset.delay_before_swing[combo]) or preset.default_before_swing or presets.Default_Swing_Wait or 0
	local hitWait = (preset.delay_before_hit and preset.delay_before_hit[combo]) or preset.default_before_hit or swingWait
	Combat.faceTarget(target)
	Game.fire("Combat_Service", presetName, combo, false, (hitWait - swingWait) / speed, false, style)
	Combat.AuraLastHit = os.clock()
	Combat.AuraLastCombo = combo
	if combo >= maxCombo then
		Combat.AuraFinishedAt = os.clock()
	end
	Combat.AuraCombo = combo >= maxCombo and 1 or combo + 1
	Combat.Status = "Hitting " .. target.Name
end

function Combat.stop()
	Combat.FarmTarget = nil
	Combat.BossTarget = nil
	Combat.setPressing(false)
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		task.wait(Const.M1_POLL)
		local ok, err = pcall(Combat.stepM1)
		if not ok then
			warn("[Spryzen Hub] auto m1 error: " .. tostring(err))
		end
	end
end))

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(Combat.stepAura)
		if not ok then
			warn("[Spryzen Hub] kill aura error: " .. tostring(err))
		end
		task.wait(Const.KILL_AURA_POLL)
	end
end))

RootMaid:Give(Combat.stop)

function Skills.tracker(character)
	return character and (character:FindFirstChild("SHC") or character:FindFirstChild("SHCS"))
end

function Skills.currentKeys()
	local ok, list = pcall(Game.SkillsProvider.get_current_keys)
	if ok and type(list) == "table" then
		return list
	end
	return {}
end

function Skills.hotbar()
	return Skills.Bound or Skills.currentKeys()
end

function Skills.trackBar()
	local signal = Game.SkillsProvider.Keys_Changed
	if type(signal) ~= "table" or type(signal.Connect) ~= "function" then
		return
	end
	local ok, connection = pcall(signal.Connect, signal, function(list)
		if type(list) == "table" then
			Skills.Bound = list
			Skills.BoundAt = os.clock()
		end
	end)
	if not ok or type(connection) ~= "table" then
		warn("[Spryzen Hub] could not follow the skill bar: " .. tostring(connection))
		return
	end
	Skills.Bound = Skills.currentKeys()
	Skills.BoundAt = os.clock()
	RootMaid:Give(LocalPlayer.CharacterAdded:Connect(function()
		Skills.Bound = nil
	end))
	RootMaid:Give(function()
		Skills.Bound = nil
		connection:Disconnect()
	end)
end

function Skills.bound(slot, name)
	local entry = Skills.hotbar()[slot]
	return type(entry) == "table" and entry.Name == name
end

function Skills.waitBar(since, character)
	local deadline = os.clock() + Const.CLAN_EQUIP_TIMEOUT
	while Skills.BoundAt < since and os.clock() < deadline and Skills.live(character) do
		task.wait()
	end
	return Skills.BoundAt >= since
end

function Skills.usable(entry)
	return type(entry) == "table" and type(entry.Name) == "string" and entry.Name ~= "" and entry.Name ~= "Blocking"
end

function Skills.maxHold(entry)
	return math.max(tonumber(entry.Max_Hold) or 0, 0)
end

function Skills.holdTime(slot, entry)
	if not Settings.HoldSkills then
		return 0
	end
	return math.min(Settings.SkillHolds[slot] or Const.SKILL_HOLD_DEFAULT, Skills.maxHold(entry))
end

function Skills.staminaCost(name, info)
	local resolver = Game.PlayerStatResolver
	local factor = tonumber(resolver.GetStat(LocalPlayer, "Stamina Cost Factor")) or 0
	if info.Category ~= nil then
		factor += tonumber(resolver.GetStat(LocalPlayer, info.Category .. " Stamina Cost Factor")) or 0
	end
	local knob = tonumber(Game.CombatBalance.CastKnob(LocalPlayer, name, "Stamina")) or 1
	return math.max(0, info.Stamina * (1 + factor) * knob)
end

function Skills.state(entry)
	local name = entry.Name
	local character = LocalPlayer.Character
	local shc = Skills.tracker(character)
	local values = Game.Utility.getvaluesfolder(LocalPlayer)
	if not character or not values then
		return false, "loading"
	end
	local disabled = values:FindFirstChild("skillsdisabled")
	if disabled then
		local text = tostring(disabled.Value)
		if string.find(text, "all") == nil then
			if string.find(text, name) ~= nil then
				return false, "disabled"
			end
		elseif string.find(text, "except" .. name) == nil then
			return false, "disabled"
		end
	end
	local cooldown = shc and shc:FindFirstChild(Game.ManageCd.filter_cd_name(LocalPlayer, name))
	if cooldown then
		local started = cooldown:GetAttribute("Started")
		local duration = cooldown.Value
		if type(started) ~= "number" or typeof(duration) ~= "number" then
			return false, "cooldown"
		end
		local left = duration - (os.clock() - started)
		if left > 0 then
			return false, "cooldown", left
		end
	end
	local info = Game.SkillInfo[name]
	local aura = entry.RequiresAura or (info and info.RequiresAura)
	if aura ~= nil and values:FindFirstChild(aura) == nil then
		return false, "needs " .. tostring(aura)
	end
	if entry.RequiresModeBar == true or (info and info.RequiresModeBar == true) then
		local bar = values:FindFirstChild("ModeBar")
		if not bar or bar.Value < bar.MaxValue then
			return false, "mode bar"
		end
	end
	if info ~= nil then
		if info.Stamina ~= nil then
			local stamina = values:FindFirstChild("Stamina")
			if not stamina or stamina.Value < Skills.staminaCost(name, info) then
				return false, "stamina"
			end
		end
	end
	local retryAt = Skills.Backoff[name]
	if retryAt and os.clock() < retryAt then
		return false, "retrying"
	end
	local _, unlocked = Game.call(Game.SkillStats.GetRequirements, LocalPlayer, name)
	if not unlocked then
		return false, "requirements"
	end
	if not Game.call(Game.SkillStats.SourceCheck, LocalPlayer, name) then
		return false, "loadout"
	end
	return true, "ready"
end

function Skills.aimPoint(range)
	local target = Skills.AimTarget
	if os.clock() > Skills.AimUntil or not Mobs.isAlive(target) then
		return nil
	end
	local point = target.HumanoidRootPart.Position
	local root = Character.root()
	if range ~= nil and root then
		local offset = point - root.Position
		if offset.Magnitude > range then
			point = root.Position + offset.Unit * range
		end
	end
	return point
end

function Skills.installAim()
	local handler = Game.PlatformHandler
	local original = handler.mousepos
	if Skills.OriginalMousepos or type(original) ~= "function" then
		return
	end
	Skills.OriginalMousepos = original
	handler.mousepos = function(range, params, skill)
		local ok, point = pcall(Skills.aimPoint, range)
		if ok and point then
			return point
		end
		ok, point = pcall(AimAssist.point, range)
		if ok and point then
			return point
		end
		return original(range, params, skill)
	end
end

function Skills.restoreAim()
	if Skills.OriginalMousepos then
		Game.PlatformHandler.mousepos = Skills.OriginalMousepos
		Skills.OriginalMousepos = nil
	end
end

function Skills.release()
	local input = Skills.Pressed
	if input then
		Skills.Pressed = nil
		Game.release(input)
	end
end

function Skills.live(character)
	local forced = Combat.Override and Combat.Override.Skills
	return forced ~= false and (forced == true or Settings.AutoSkill or Settings.AutoClanSkills)
		and LocalPlayer.Character == character and Character.alive()
		and not (Heal.Retreating or Escape.Active or Dodge.Active or Potion.Busy or Defense.busy())
end

function Skills.actionLive(character, slot, entry, target, clan)
	if not Skills.live(character) or not Mobs.isAlive(target) or Combat.farmTarget() ~= target then
		return false
	end
	if clan then
		return Settings.AutoClanSkills and Skills.clanPicked(entry)
	end
	local forced = Combat.Override and Combat.Override.Skills == true
	return forced or (Settings.AutoSkill and Settings.SkillSlots[slot] == true)
end

function Skills.reserved()
	return os.clock() < Skills.ReservedUntil and Skills.live(LocalPlayer.Character) and Combat.farmTarget() ~= nil
end

function Skills.reserveNext()
	Skills.ReservedUntil = 0
	if not Skills.live(LocalPlayer.Character) or not Combat.farmTarget() or Skills.comboPending() then
		return
	end
	local slot = Skills.nextRegular()
	local clanSlot = Settings.AutoClanSkills and Skills.clanSlot()
	if slot or (clanSlot and Combat.slotAllowed(clanSlot) and Skills.readyClanSkill()) then
		Skills.ReservedUntil = math.max(os.clock(), Skills.NextCast) + Const.SKILL_POLL * 2
	end
end

function Skills.comboWindow()
	if Combat.Override and (Combat.Override.Skills == false or Combat.Override.M1 == false) then
		return false
	end
	if not Settings.FullCombo or not (Settings.AutoSkill or Settings.AutoClanSkills) then
		return false
	end
	local finished = Combat.finisherAt()
	return finished > Skills.WindowClosedAt and os.clock() - finished < Const.COMBO_SKILL_WINDOW
end

function Skills.comboPending()
	if Combat.Override and Combat.Override.M1 == false then
		return false
	end
	if not Settings.FullCombo or not (Settings.AutoM1 or Settings.KillAura) or not Combat.farmTarget() then
		return false
	end
	return not Skills.comboWindow()
end

function Skills.closeWindow()
	if Settings.FullCombo then
		Skills.WindowClosedAt = os.clock()
	end
end

function Skills.fail(name)
	local failures = (Skills.Failures[name] or 0) + 1
	Skills.Failures[name] = failures
	Skills.Backoff[name] = os.clock() + math.min(Const.SKILL_RETRY_MAX, Const.SKILL_RETRY_BASE * 2 ^ (failures - 1))
end

function Skills.allowed(name)
	local ok, allowed = pcall(Game.Checker.check, LocalPlayer, name)
	return ok and allowed == true
end

function Skills.waitReady(name, valid)
	local deadline = os.clock() + (tonumber(Game.CombatPresets.slow_walk_duration) or 0.5) + Const.SKILL_READY_PAD
	while valid() do
		if Skills.allowed(name) and os.clock() >= Skills.NextCast then
			return true
		end
		if os.clock() > deadline then
			return false
		end
		task.wait()
	end
	return false
end

function Skills.cast(slot, entry, hold, target, clan)
	local name = entry.Name
	local input = Const.SKILL_INPUTS[slot]
	local info = Game.SkillInfo[name]
	local before = info and info.lastUsed
	local character = LocalPlayer.Character
	if not character then
		return
	end
	local function valid()
		return Skills.actionLive(character, slot, entry, target, clan) and Skills.bound(slot, name)
	end
	if not input or not valid() or not Skills.state(entry) then
		return false
	end
	local cdName = Game.ManageCd.filter_cd_name(LocalPlayer, name)
	local tracker = Skills.tracker(character)
	local oldCd = tracker and tracker:FindFirstChild(cdName)
	local oldStamp = oldCd and oldCd:GetAttribute("Started")
	local function confirmed()
		local shc = Skills.tracker(character)
		local cd = shc and shc:FindFirstChild(cdName)
		return cd ~= nil and (cd ~= oldCd or cd:GetAttribute("Started") ~= oldStamp)
	end
	local function running()
		local shc = Skills.tracker(character)
		return shc ~= nil and shc.Value == name
	end
	local function started()
		return (info ~= nil and info.lastUsed ~= before) or running() or confirmed()
	end
	Skills.Casting = name
	Skills.AimTarget = target
	Skills.AimUntil = math.huge
	Combat.setPressing(false)
	if not Skills.waitReady(name, valid) then
		Skills.Status = "Waiting to cast " .. name
		if valid() then
			Skills.fail(name)
		end
		Skills.AimUntil = 0
		Skills.Casting = nil
		Skills.NextCast = os.clock() + Const.SKILL_CAST_GAP
		return false
	end
	if not valid() or not Skills.state(entry) then
		Skills.Status = "Cast conditions changed for " .. name
		Skills.AimUntil = 0
		Skills.Casting = nil
		Skills.NextCast = os.clock() + Const.SKILL_CAST_GAP
		return false
	end
	Skills.Status = "Casting " .. name
	Combat.faceTarget(target)
	Skills.Pressed = input
	Game.press(input)
	local deadline = os.clock() + Const.SKILL_START_TIMEOUT
	while not started() and os.clock() < deadline and valid() do
		task.wait()
	end
	local ok = started()
	if ok and hold > 0 then
		local releaseAt = os.clock() + hold
		while os.clock() < releaseAt and (running() or not Skills.tracker(character)) and valid() do
			task.wait()
		end
	end
	Skills.release()
	if ok then
		local settle = os.clock() + Const.SKILL_SETTLE_TIMEOUT
		while running() and os.clock() < settle and Skills.live(character) do
			task.wait()
		end
	end
	if confirmed() then
		Skills.Failures[name] = nil
		Skills.Backoff[name] = nil
	elseif ok then
		Skills.Backoff[name] = os.clock() + Const.SKILL_RETRY_BASE
		Skills.Status = "Started " .. name .. ", cooldown unconfirmed"
	elseif valid() then
		Skills.fail(name)
	end
	Skills.AimUntil = os.clock() + Const.SKILL_AIM_TAIL
	Skills.Casting = nil
	Skills.NextCast = os.clock() + Const.SKILL_CAST_GAP
	return ok
end

function Skills.clanSlot()
	local data = Game.data()
	local toolbar = data and data.Inventory:FindFirstChild("Toolbar")
	if not toolbar then
		return nil
	end
	for slot, slotName in ipairs(Const.SLOT_NAMES) do
		local entry = toolbar:FindFirstChild(slotName)
		if entry and entry.Value ~= 0 then
			local item = Game.CharacterInfo.GetItemFromId(LocalPlayer, entry.Value)
			if item and item.Name == Game.ClanSkills.TOOL_NAME then
				return slot
			end
		end
	end
	return nil
end

function Skills.clanList()
	local data = Game.data()
	local clan = data and data:FindFirstChild("Clan")
	local ok, list = pcall(Game.ClanSkills.SkillsFor, clan and clan.Value or nil, LocalPlayer)
	if not ok or type(list) ~= "table" then
		return {}
	end
	return list
end

function Skills.clanNames()
	local names = {}
	for _, entry in ipairs(Skills.clanList()) do
		if type(entry) == "table" and type(entry.Name) == "string" and not table.find(names, entry.Name) then
			table.insert(names, entry.Name)
		end
	end
	return names
end

function Skills.onClanBar()
	local config = LocalPlayer:FindFirstChild("Items_Config")
	local equipped = config and config:FindFirstChild("Equipped")
	local slot = equipped and Skills.clanSlot()
	return slot ~= nil and equipped.Value == slot
end

function Skills.clanPicked(entry)
	local picks = Settings.ClanSkillPicks
	return #picks == 0 or table.find(picks, entry.Name) ~= nil
end

function Skills.readyClanSkill()
	for _, entry in ipairs(Skills.clanList()) do
		if Skills.usable(entry) and Skills.clanPicked(entry) and Skills.state(entry) then
			return entry
		end
	end
	return nil
end

function Skills.clanIndex(name)
	local list = Skills.hotbar()
	for index = 1, #Const.SKILL_INPUTS do
		local entry = list[index]
		if type(entry) == "table" and entry.Name == name then
			return index, entry
		end
	end
	return nil
end

function Skills.clanHold(entry)
	if not Settings.HoldSkills then
		return 0
	end
	return math.min(Const.SKILL_HOLD_DEFAULT, Skills.maxHold(entry))
end

function Skills.castClan(target)
	local slot = Skills.clanSlot()
	if not slot then
		Skills.Status = "Put Clan Skills on your toolbar"
		return false
	end
	if not Combat.slotAllowed(slot) then
		Skills.Status = "Clan skills are locked this floor"
		return false
	end
	local entry = Skills.readyClanSkill()
	if not entry then
		return false
	end
	local config = LocalPlayer:FindFirstChild("Items_Config")
	local equipped = config and config:FindFirstChild("Equipped")
	if not equipped then
		return false
	end
	local character = LocalPlayer.Character
	local previous = equipped.Value
	Skills.Swapping = true
	Skills.Status = "Switching to clan skills"
	Combat.setPressing(false)
	if previous ~= slot then
		equipped.Value = slot
	end
	local casted, blocked = 0, 0
	local ok, err = pcall(function()
		while entry and Settings.AutoClanSkills and Skills.live(character) and casted < #Const.SKILL_INPUTS and not Skills.comboPending() do
			local index, hotbarEntry = nil, nil
			local deadline = os.clock() + Const.CLAN_EQUIP_TIMEOUT
			repeat
				index, hotbarEntry = Skills.clanIndex(entry.Name)
				if index then
					break
				end
				task.wait()
			until os.clock() > deadline or not Skills.live(character)
			if not index then
				Skills.Status = "Skill bar did not switch to clan skills"
				break
			end
			if not Mobs.isAlive(target) then
				target = Combat.farmTarget()
				if not target then
					break
				end
			end
			if Skills.cast(index, hotbarEntry, Skills.clanHold(hotbarEntry), target, true) then
				casted += 1
			else
				blocked += 1
				if blocked >= Const.CLAN_BLOCKED_LIMIT then
					break
				end
			end
			entry = Skills.readyClanSkill()
		end
	end)
	if previous ~= slot and equipped.Parent and equipped.Value == slot then
		local restoredAt = os.clock()
		equipped.Value = previous
		Skills.waitBar(restoredAt, character)
	end
	Skills.Swapping = false
	if not ok then
		error(err, 0)
	end
	return casted > 0
end

function Skills.nextRegular()
	local forced = Combat.Override and Combat.Override.Skills
	if forced == false or not (Settings.AutoSkill or forced == true) or Skills.onClanBar() then
		return nil, nil, 0
	end
	local list = Skills.hotbar()
	local picked = 0
	for offset = 1, #Const.SKILL_INPUTS do
		local slot = (Skills.Cursor + offset - 1) % #Const.SKILL_INPUTS + 1
		local entry = list[slot]
		if Skills.usable(entry) and (Settings.SkillSlots[slot] or forced == true) then
			picked += 1
			if Skills.state(entry) then
				return slot, entry, picked
			end
		end
	end
	return nil, nil, picked
end

function Skills.step()
	local forced = Combat.Override and Combat.Override.Skills
	if forced == false then
		Skills.ReservedUntil = 0
		Skills.Status = "Paused for schematics"
		return
	end
	if Journey.Mounted then
		Skills.ReservedUntil = 0
		Skills.Status = "Riding"
		return
	end
	if Mover.dashBusy() then
		Skills.ReservedUntil = 0
		Skills.Status = "Waiting for dash travel"
		return
	end
	local auto = Settings.AutoSkill or forced == true
	if not (auto or Settings.AutoClanSkills) then
		Skills.ReservedUntil = 0
		Skills.Status = "Idle"
		return
	end
	if Heal.Retreating or Escape.Active or Dodge.Active or Potion.Busy or Defense.busy() then
		Skills.ReservedUntil = 0
		Skills.Status = "Paused"
		return
	end
	if not Character.alive() then
		Skills.Status = "Waiting for your character"
		return
	end
	local shc = Skills.tracker(LocalPlayer.Character)
	if shc and shc:GetAttribute("en") == true then
		Skills.Status = "Busy with " .. (shc.Value ~= "" and shc.Value or "a skill")
		return
	end
	if os.clock() < Skills.NextCast then
		return
	end
	if Skills.comboPending() then
		Skills.Status = "Finishing M1 combo"
		return
	end
	local target = Combat.farmTarget()
	local clanBar = auto and Skills.onClanBar()
	local slot, entry, picked = Skills.nextRegular()
	if target and slot then
		Skills.Cursor = slot
		Skills.cast(slot, entry, Skills.holdTime(slot, entry), target)
		Skills.reserveNext()
		return
	end
	if Settings.AutoClanSkills then
		if target and Skills.castClan(target) then
			Skills.reserveNext()
			return
		end
		Skills.closeWindow()
		if Skills.Status == "Put Clan Skills on your toolbar" then
			return
		end
		if not auto then
			Skills.Status = target and "Waiting for clan cooldowns" or "Waiting for an auto farm target"
			return
		end
	end
	Skills.ReservedUntil = 0
	Skills.closeWindow()
	if clanBar then
		Skills.Status = "Clan skills bar is equipped"
	elseif picked == 0 then
		Skills.Status = "No picked skills on the hotbar"
	elseif not target then
		Skills.Status = "Waiting for an auto farm target"
	else
		Skills.Status = "Waiting for cooldowns"
	end
end

function Skills.reset()
	Skills.release()
	Skills.ReservedUntil = 0
	Skills.Swapping = false
	Skills.Casting = nil
	Skills.AimTarget = nil
	Skills.AimUntil = 0
end

function Skills.stop()
	Skills.reset()
	Skills.restoreAim()
end

Skills.installAim()
Skills.trackBar()

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(Skills.step)
		if not ok then
			Skills.reset()
			warn("[Spryzen Hub] auto skill error: " .. tostring(err))
		end
		task.wait(Const.SKILL_POLL)
	end
end))

RootMaid:Give(Skills.stop)

local Guard = {
	SlowWalkDuration = Game.CombatPresets.slow_walk_duration,
	Stamina = nil,
	StaminaConnection = nil,
	ClimbTables = setmetatable({}, { __mode = "k" }),
	ClimbCharacter = nil,
	ClimbScanAt = 0,
	MinigameGet = nil,
}

function Guard.valuesFolder()
	local service = ReplicatedStorage:FindFirstChild("Player_Service")
	local values = service and service:FindFirstChild("Values")
	return values and values:FindFirstChild(LocalPlayer.Name)
end

function Guard.clear(names)
	local values = Guard.valuesFolder()
	if not values then
		return
	end
	for _, name in ipairs(names) do
		local value = values:FindFirstChild(name)
		while value do
			value:Destroy()
			value = values:FindFirstChild(name)
		end
	end
end

function Guard.clearRagdoll()
	Guard.clear(Const.RAGDOLL_NAMES)
end

function Guard.clearDashCooldown()
	local character = LocalPlayer.Character
	local shc = Skills.tracker(character)
	local cooldown = shc and shc:FindFirstChild(Game.ManageCd.filter_cd_name(LocalPlayer, "Dash"))
	if cooldown then
		cooldown:Destroy()
	end
end

function Guard.fillStamina()
	local stamina = Guard.Stamina
	if stamina and stamina.Parent and stamina.Value < stamina.MaxValue then
		stamina.Value = stamina.MaxValue
	end
end

function Guard.watchStamina()
	local values = Guard.valuesFolder()
	local stamina = Settings.InfiniteStamina and values and values:FindFirstChild("Stamina") or nil
	if stamina == Guard.Stamina then
		return
	end
	if Guard.StaminaConnection then
		Guard.StaminaConnection:Disconnect()
		Guard.StaminaConnection = nil
	end
	Guard.Stamina = stamina
	if stamina then
		Guard.StaminaConnection = stamina.Changed:Connect(function()
			if Settings.InfiniteStamina then
				Guard.fillStamina()
			end
		end)
	end
end

function Guard.scanClimb()
	if type(getgc) ~= "function" then
		return
	end
	for _, item in ipairs(getgc(true)) do
		if type(item) == "table" and type(rawget(item, "CurrentStamina")) == "number" and type(rawget(item, "MaxClimbTime")) == "number" then
			Guard.ClimbTables[item] = true
		end
	end
end

function Guard.fillClimb()
	local character = LocalPlayer.Character
	if character ~= Guard.ClimbCharacter then
		Guard.ClimbCharacter = character
		Guard.ClimbScanAt = os.clock() + Const.CLIMB_SCAN_DELAY
		table.clear(Guard.ClimbTables)
	end
	if Guard.ClimbScanAt > 0 and os.clock() >= Guard.ClimbScanAt then
		Guard.scanClimb()
		Guard.ClimbScanAt = next(Guard.ClimbTables) == nil and os.clock() + 10 or 0
	end
	for climb in pairs(Guard.ClimbTables) do
		if climb.CurrentStamina < climb.MaxClimbTime then
			climb.CurrentStamina = climb.MaxClimbTime
		end
	end
end

function Guard.applyMinigame()
	local settings = Game.MinigameSettings
	local wanted = Settings.NoDrown or Settings.NoSunDamage
	if wanted and not Guard.MinigameGet then
		local original = settings.Get
		Guard.MinigameGet = original
		settings.Get = function(key, ...)
			if (key == "NoDrowning" and Settings.NoDrown) or (key == "NoSunDamage" and Settings.NoSunDamage) then
				return true
			end
			return original(key, ...)
		end
	elseif not wanted and Guard.MinigameGet then
		settings.Get = Guard.MinigameGet
		Guard.MinigameGet = nil
	end
end

function Guard.applySlowdown()
	Game.CombatPresets.slow_walk_duration = Settings.NoAttackSlowdown and 0 or Guard.SlowWalkDuration
end

function Guard.step()
	if Settings.AntiRagdoll then
		Guard.clearRagdoll()
	end
	if Settings.NoAttackSlowdown and Game.CombatPresets.slow_walk_duration ~= 0 then
		Guard.applySlowdown()
	end
	if Settings.NoStun then
		Guard.clear(Const.STUN_NAMES)
	end
	if Settings.NoDashCooldown then
		Guard.clearDashCooldown()
	end
	Guard.watchStamina()
	if Settings.InfiniteStamina then
		Guard.fillStamina()
	end
	if Settings.InfiniteClimb then
		Guard.fillClimb()
	end
	Guard.applyMinigame()
end

do
	local watched = nil
	RootMaid:Give(task.spawn(function()
		Hub.awaitStart()
		while true do
			local values = Guard.valuesFolder()
			if values and values ~= watched then
				watched = values
				RootMaid:Give(values.ChildAdded:Connect(function(child)
					for _, names in ipairs({ Const.STUN_NAMES, Const.RAGDOLL_NAMES }) do
						if table.find(names, child.Name) then
							Escape.Seen[names] = os.clock()
						end
					end
					if Settings.AntiRagdoll and table.find(Const.RAGDOLL_NAMES, child.Name) then
						task.defer(Guard.clearRagdoll)
					end
					if Settings.NoStun and table.find(Const.STUN_NAMES, child.Name) then
						task.defer(Guard.clear, Const.STUN_NAMES)
					end
				end))
			end
			local ok, err = pcall(Guard.step)
			if not ok then
				warn("[Spryzen Hub] guard error: " .. tostring(err))
			end
			task.wait(Const.GUARD_POLL)
		end
	end))
end

RootMaid:Give(function()
	Game.CombatPresets.slow_walk_duration = Guard.SlowWalkDuration
	if Guard.StaminaConnection then
		Guard.StaminaConnection:Disconnect()
		Guard.StaminaConnection = nil
	end
	if Guard.MinigameGet then
		Game.MinigameSettings.Get = Guard.MinigameGet
		Guard.MinigameGet = nil
	end
end)

function Potion.options()
	local list = {}
	for name, info in pairs(Game.Items) do
		if type(name) == "string" and type(info) == "table" and info.Category == "Potions" and string.find(name, "Health", 1, true) then
			table.insert(list, name)
		end
	end
	table.sort(list)
	return list
end

Potion.Options = Potion.options()

function Potion.pick()
	local data = Game.data()
	local inventory = data and data.Inventory:FindFirstChild("Inventory")
	if not inventory then
		return nil
	end
	for _, name in ipairs(Potion.Options) do
		if table.find(Settings.Potions, name) then
			local entry = inventory:FindFirstChild(name)
			local id = entry and entry:FindFirstChild("Id")
			if id and id.Value ~= 0 and Game.itemCount(name) > 0 and not Potion.buffActive(name) then
				return name, id.Value
			end
		end
	end
	return nil
end

function Potion.buffActive(name)
	local buff = Const.POTION_BUFFS[name]
	local values = buff and Game.Utility.getvaluesfolder(LocalPlayer)
	return values ~= nil and values:FindFirstChild(buff) ~= nil
end

function Potion.accessories(character)
	return character and character:FindFirstChild("Tool_Accessories")
end

function Potion.inHand(character, marker)
	local accessories = Potion.accessories(character)
	if not accessories or accessories:FindFirstChild("CapWeld", true) == nil then
		return false
	end
	return marker == nil or accessories:GetAttribute("Value") ~= marker
end

function Potion.release()
	if Potion.Pressed then
		Potion.Pressed = false
		Game.release("Screen")
	end
end

function Potion.waitUntil(predicate, timeout, character)
	local deadline = os.clock() + timeout
	while os.clock() < deadline do
		if predicate() then
			return true
		end
		if not Settings.AutoPotion or LocalPlayer.Character ~= character or not Character.alive() then
			return false
		end
		task.wait(0.05)
	end
	return predicate()
end

function Potion.drink(name, id)
	if not Combat.itemAllowed(name) then
		return false, "Items are locked this floor"
	end
	local slot = math.clamp(tonumber(Settings.PotionSlot) or 5, 1, #Const.SLOT_NAMES)
	local slotName = Const.SLOT_NAMES[slot]
	local data = Game.data()
	local entry = data and data.Inventory.Toolbar:FindFirstChild(slotName)
	local config = LocalPlayer:FindFirstChild("Items_Config")
	local equipped = config and config:FindFirstChild("Equipped")
	if not entry or not equipped then
		return false, "Toolbar not ready"
	end
	local character = LocalPlayer.Character
	if entry.Value ~= id then
		Potion.Status = "Putting " .. name .. " on slot " .. slot
		Game.fire("Toolbar_Equip", slotName, id)
		if not Potion.waitUntil(function()
			return entry.Value == id
		end, Const.POTION_TOOLBAR_TIMEOUT, character) then
			return false, "Could not put " .. name .. " on slot " .. slot
		end
	end
	local previous = equipped.Value
	local marker = nil
	if previous ~= slot then
		local accessories = Potion.accessories(character)
		marker = accessories and accessories:GetAttribute("Value") or ""
		equipped.Value = slot
	end
	local drank, quick = false, false
	local failure = "Could not drink " .. name
	if not Potion.waitUntil(function()
		return Potion.inHand(character, marker)
	end, Const.POTION_EQUIP_TIMEOUT, character) then
		failure = "Could not equip " .. name
	elseif not Potion.waitUntil(function()
		return Game.Checker.check(LocalPlayer) == true
	end, Const.POTION_READY_TIMEOUT, character) then
		failure = "Can't drink yet, stunned or mid-attack"
		quick = true
	else
		local before = Game.itemCount(name)
		local interrupted = false
		local values = Game.Utility.getvaluesfolder(LocalPlayer)
		local watch = values and values.ChildAdded:Connect(function(child)
			if Game.Utility.Cancel_Values[child.Name] then
				interrupted = true
			end
		end)
		task.wait(Const.POTION_PRESS_SETTLE)
		Potion.Status = "Drinking " .. name
		Potion.Pressed = true
		Game.press("Screen")
		Potion.waitUntil(function()
			return interrupted or Game.itemCount(name) < before
		end, Const.POTION_DRINK_TIMEOUT, character)
		Potion.release()
		if watch then
			watch:Disconnect()
		end
		drank = Potion.waitUntil(function()
			return Game.itemCount(name) < before
		end, interrupted and 0 or Const.POTION_CONFIRM_TIMEOUT, character)
		if not drank and interrupted then
			failure = "Drink interrupted by a hit, retrying"
			quick = true
		end
	end
	if previous ~= slot and equipped.Parent and equipped.Value == slot then
		equipped.Value = previous
	end
	return drank, drank and ("Drank " .. name) or failure, quick
end

function Potion.lift()
	local root = Character.root()
	if not root then
		return
	end
	local spot = CFrame.new(root.Position + Vector3.new(0, Const.RETREAT_HEIGHT, 0))
	Potion.Lease = Potion.Lease or Mover.acquire("potion", 31)
	Potion.Lease:SetGoal(function()
		return spot
	end)
	Potion.Status = "Moving to safety"
	Potion.waitUntil(function()
		local current = Character.root()
		return current ~= nil and (current.Position - spot.Position).Magnitude <= Const.POTION_SAFE_DISTANCE
	end, Const.POTION_LIFT_TIMEOUT, LocalPlayer.Character)
end

function Potion.lower()
	if Potion.Lease then
		Potion.Lease:SetGoal(nil)
	end
end

function Potion.tick()
	if not Settings.AutoPotion then
		Potion.Status = "Off"
		return
	end
	local humanoid = Character.humanoid()
	if not Character.alive() or humanoid.MaxHealth <= 0 then
		Potion.Status = "Waiting for your character"
		return
	end
	local percent = humanoid.Health / humanoid.MaxHealth * 100
	if percent >= Settings.DrinkBelow then
		Potion.Status = "Watching health"
		return
	end
	if os.clock() < Potion.RetryAt then
		return
	end
	if Skills.Casting or Skills.Swapping or Potion.Busy then
		return
	end
	local name, id = Potion.pick()
	if not name then
		Potion.Status = "No picked potions left"
		return
	end
	Potion.Busy = true
	Combat.setPressing(false)
	if Settings.PotionSafety and not Heal.Retreating then
		Potion.lift()
	end
	local ok, drank, text, quick = pcall(Potion.drink, name, id)
	Potion.release()
	Potion.lower()
	Potion.Busy = false
	if not ok then
		Potion.Status = "Error, retrying"
		Potion.RetryAt = os.clock() + Const.POTION_RETRY
		error(drank, 0)
	end
	Potion.Status = text
	Potion.RetryAt = os.clock() + (drank and Const.POTION_GAP or quick and Const.POTION_INTERRUPT_RETRY or Const.POTION_RETRY)
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(Potion.tick)
		if not ok then
			warn("[Spryzen Hub] auto potion error: " .. tostring(err))
		end
		task.wait(Const.HEAL_POLL)
	end
end))

RootMaid:Give(function()
	Potion.release()
	Potion.Busy = false
	if Potion.Lease then
		Potion.Lease:Release()
		Potion.Lease = nil
	end
end)

function Heal.finish()
	Heal.Retreating = false
	if Heal.Lease then
		Heal.Lease:SetGoal(nil)
	end
end

function Heal.tick()
	if not Settings.RetreatHeal then
		Heal.finish()
		Heal.Status = "Off"
		return
	end
	local humanoid = Character.humanoid()
	local root = Character.root()
	if not Character.alive() or humanoid.MaxHealth <= 0 then
		Heal.finish()
		Heal.Status = "Waiting for your character"
		return
	end
	local percent = humanoid.Health / humanoid.MaxHealth * 100
	if Heal.Retreating then
		if percent >= Settings.BackAt then
			Heal.finish()
			Heal.Status = "Watching health"
		else
			Heal.Status = string.format("Healing, %d%% HP", math.floor(percent))
		end
		return
	end
	if percent >= Settings.RetreatBelow then
		Heal.Status = "Watching health"
		return
	end
	local spot = CFrame.new(root.Position + Vector3.new(0, Const.RETREAT_HEIGHT, 0))
	Heal.Lease = Heal.Lease or Mover.acquire("retreat", 30)
	Heal.Lease:SetGoal(function()
		return spot
	end)
	Heal.Retreating = true
	Heal.Status = string.format("Healing, %d%% HP", math.floor(percent))
	Combat.setPressing(false)
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(Heal.tick)
		if not ok then
			Heal.finish()
			warn("[Spryzen Hub] retreat error: " .. tostring(err))
		end
		task.wait(Const.HEAL_POLL)
	end
end))

RootMaid:Give(function()
	Heal.finish()
	if Heal.Lease then
		Heal.Lease:Release()
		Heal.Lease = nil
	end
end)

function Escape.flagged(names)
	if os.clock() - (Escape.Seen[names] or -math.huge) < Const.ESCAPE_SEEN_WINDOW then
		return true
	end
	local values = Guard.valuesFolder()
	if not values then
		return false
	end
	for _, name in ipairs(names) do
		if values:FindFirstChild(name) then
			return true
		end
	end
	return false
end

function Escape.crowd(position)
	local count = 0
	Mobs.eachAlive(function(model, mobRoot, entry)
		if Mobs.isCombatTarget(model, entry) and (mobRoot.Position - position).Magnitude <= Const.ESCAPE_CROWD_RADIUS then
			count += 1
		end
	end)
	return count
end

function Escape.health(humanoid)
	return humanoid.Health / humanoid.MaxHealth * 100
end

function Escape.threat(origin)
	for _, model in ipairs({ Combat.BossTarget, Combat.FarmTarget }) do
		local targetRoot = Mobs.isAlive(model) and model:FindFirstChild("HumanoidRootPart")
		if targetRoot and targetRoot.Position.Magnitude < Const.BOSS_POSITION_LIMIT and (targetRoot.Position - origin).Magnitude <= Const.ESCAPE_THREAT_RANGE then
			return targetRoot.Position
		end
	end
	local nearest = Mobs.nearest(nil, Const.ESCAPE_THREAT_RANGE)
	local nearestRoot = nearest and nearest:FindFirstChild("HumanoidRootPart")
	return nearestRoot and nearestRoot.Position or nil
end

function Escape.spot(root)
	local origin = root.Position
	if Settings.EscapeDirection == "Back" then
		local threat = Escape.threat(origin)
		local away = threat and (origin - threat) * Vector3.new(1, 0, 1)
		if not away or away.Magnitude < 0.1 then
			away = -root.CFrame.LookVector * Vector3.new(1, 0, 1)
		end
		if away.Magnitude >= 0.1 then
			return CFrame.new(origin + away.Unit * Settings.EscapeDistance + Vector3.new(0, Const.ESCAPE_BACK_LIFT, 0))
		end
	end
	return CFrame.new(origin + Vector3.new(0, Settings.EscapeDistance, 0))
end

function Escape.trigger(humanoid, root)
	if Settings.EscapeLowHp and Escape.health(humanoid) < Settings.EscapeHpBelow then
		return "Low HP"
	end
	if os.clock() < Escape.ReadyAt then
		return nil
	end
	if Settings.EscapeStun and Escape.flagged(Const.STUN_NAMES) then
		return "Stunned"
	end
	if Settings.EscapeRagdoll and Escape.flagged(Const.RAGDOLL_NAMES) then
		return "Knocked down"
	end
	if Settings.EscapeCrowd and Escape.crowd(root.Position) >= Settings.EscapeCrowdSize then
		return "Surrounded"
	end
	return nil
end

function Escape.holding(humanoid)
	local percent = Escape.health(humanoid)
	if Settings.EscapeLowHp and percent < Settings.EscapeHpBelow then
		Escape.LowHp = true
	end
	if Escape.LowHp and Settings.EscapeLowHp and percent < math.max(Settings.EscapeHpBack, Settings.EscapeHpBelow) then
		return "Low HP"
	end
	local now = os.clock()
	if now < Escape.MinUntil then
		return Escape.Reason
	end
	if now >= Escape.MaxUntil then
		return nil
	end
	if Settings.EscapeStun and Escape.flagged(Const.STUN_NAMES) then
		return "Stunned"
	end
	if Settings.EscapeRagdoll and Escape.flagged(Const.RAGDOLL_NAMES) then
		return "Knocked down"
	end
	if Escape.Reason == "Surrounded" and Settings.EscapeCrowd and Escape.crowd(Escape.Origin) >= Settings.EscapeCrowdSize then
		return "Surrounded"
	end
	return nil
end

function Escape.finish(status)
	Escape.Active = false
	Escape.Reason = nil
	Escape.LowHp = false
	if Escape.Lease then
		Escape.Lease:SetGoal(nil)
	end
	Escape.Status = status
end

function Escape.start(reason, root)
	local spot = Escape.spot(root)
	local now = os.clock()
	Escape.Lease = Escape.Lease or Mover.acquire("escape", 32)
	Escape.Lease:SetGoal(function()
		return spot
	end)
	Escape.Active = true
	Escape.Reason = reason
	Escape.LowHp = reason == "Low HP"
	Escape.Origin = root.Position
	Escape.MinUntil = now + Settings.EscapeStay
	Escape.MaxUntil = now + Const.ESCAPE_MAX_AWAY
	Escape.Count += 1
	Escape.Status = "Away: " .. reason
	Combat.setPressing(false)
end

function Escape.tick()
	if not Settings.AutoEscape then
		if Escape.Active or Escape.Status ~= "Off" then
			Escape.finish("Off")
		end
		return
	end
	local humanoid = Character.humanoid()
	local root = Character.root()
	if not Character.alive() or humanoid.MaxHealth <= 0 then
		Escape.finish("Waiting for your character")
		return
	end
	if Escape.Active then
		local reason = Escape.holding(humanoid)
		if reason then
			Escape.Reason = reason
			Escape.Status = "Away: " .. reason
			return
		end
		Escape.ReadyAt = os.clock() + Settings.EscapeCooldown
		Escape.finish("Watching")
		return
	end
	local reason = Escape.trigger(humanoid, root)
	if reason then
		Escape.start(reason, root)
		return
	end
	Escape.Status = os.clock() < Escape.ReadyAt and "Cooling down" or "Watching"
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(Escape.tick)
		if not ok then
			Escape.finish("Error, retrying")
			warn("[Spryzen Hub] retreat error: " .. tostring(err))
		end
		task.wait(Const.ESCAPE_POLL)
	end
end))

RootMaid:Give(function()
	Escape.finish("Off")
	if Escape.Lease then
		Escape.Lease:Release()
		Escape.Lease = nil
	end
end)

function Dodge.frameOf(anchor, face)
	local frame = nil
	if typeof(anchor) == "CFrame" then
		frame = anchor
	elseif typeof(anchor) == "Instance" and anchor.Parent then
		if anchor:IsA("BasePart") then
			frame = anchor.CFrame
		elseif anchor:IsA("Model") then
			local part = anchor:FindFirstChild("HumanoidRootPart") or anchor.PrimaryPart or anchor:FindFirstChild("Head")
			if part and part:IsA("BasePart") then
				frame = part.CFrame
			end
		end
	end
	if not frame or not face then
		return frame
	end
	local flat = (face.Position - frame.Position) * Vector3.new(1, 0, 1)
	if flat.Magnitude < 0.01 then
		return frame
	end
	return CFrame.lookAt(frame.Position, frame.Position + flat.Unit)
end

function Dodge.place(zone)
	local face = Dodge.frameOf(zone.Face)
	local base = Dodge.frameOf(zone.Anchor, face)
	if not base then
		return
	end
	zone.Base = base
	zone.Reach = face and ((face.Position - base.Position) * Vector3.new(1, 0, 1)).Magnitude or nil
end

function Dodge.zone(telegraph, kind, data)
	local shape = data.Shape
	if type(shape) ~= "table" then
		return nil
	end
	local character = LocalPlayer.Character
	local zone = {
		Kind = kind,
		Telegraph = telegraph,
		Anchor = data.Anchor == nil and telegraph.Caster or data.Anchor,
		Face = data.Face,
		Offset = typeof(shape.Offset) == "CFrame" and shape.Offset or CFrame.identity,
		FreezeAt = type(shape.FreezeAt) == "number" and shape.FreezeAt or nil,
		StartedAt = type(data.StartedAt) == "number" and data.StartedAt or Workspace:GetServerTimeNow(),
	}
	if kind == "Circle" and type(shape.Radius) == "number" then
		zone.Radius = shape.Radius
	elseif kind == "Box" and type(shape.Width) == "number" and type(shape.Length) == "number" then
		zone.Width = shape.Width
		zone.Length = shape.Length
		zone.Live = shape.Live == true
	else
		return nil
	end
	zone.FaceSelf = character ~= nil and zone.Face == character
	zone.AnchorSelf = character ~= nil and zone.Anchor == character
	zone.Tracking = typeof(zone.Anchor) ~= "CFrame"
	Dodge.place(zone)
	return zone.Base and zone or nil
end

function Dodge.update(zone, serverNow)
	if typeof(zone.Anchor) == "Instance" and zone.Anchor.Parent == nil then
		return false
	end
	if zone.Tracking then
		Dodge.place(zone)
		if zone.FreezeAt and serverNow - zone.StartedAt >= zone.FreezeAt then
			zone.Tracking = false
		end
	end
	return true
end

function Dodge.frameFor(zone, point)
	local base, reach = zone.Base, zone.Reach
	if zone.AnchorSelf and zone.Tracking then
		base = CFrame.new(point) * base.Rotation
	end
	if zone.FaceSelf and zone.Tracking then
		local flat = (point - base.Position) * Vector3.new(1, 0, 1)
		if flat.Magnitude >= 0.01 then
			base = CFrame.lookAt(base.Position, base.Position + flat.Unit)
			reach = flat.Magnitude
		end
	end
	local world = base * zone.Offset
	local look = world.LookVector * Vector3.new(1, 0, 1)
	look = look.Magnitude > 0.01 and look.Unit or Vector3.new(0, 0, 1)
	return CFrame.lookAt(world.Position, world.Position + look), reach
end

function Dodge.boxSpan(zone, reach)
	if not zone.Live then
		return zone.Length, 0
	end
	local length = math.max(math.min(reach or zone.Length, zone.Length), 0.1)
	return length, -length / 2
end

function Dodge.inside(zone, point)
	local frame, reach = Dodge.frameFor(zone, point)
	local offset = frame:PointToObjectSpace(point)
	if math.abs(offset.Y) > Const.ULT_HEIGHT_RANGE then
		return false
	end
	local pad = Const.ULT_EDGE_PAD
	if zone.Kind == "Circle" then
		return Vector2.new(offset.X, offset.Z).Magnitude <= zone.Radius + pad
	end
	local length, center = Dodge.boxSpan(zone, reach)
	return math.abs(offset.X) <= zone.Width / 2 + pad and math.abs(offset.Z - center) <= length / 2 + pad
end

function Dodge.safe(zones, point)
	if not point then
		return false
	end
	for _, zone in ipairs(zones) do
		if Dodge.inside(zone, point) then
			return false
		end
	end
	return true
end

function Dodge.casterAlive(caster)
	if not caster.Parent then
		return false
	end
	local humanoid = caster:FindFirstChildOfClass("Humanoid")
	return humanoid == nil or humanoid.Health > 0
end

function Dodge.zones()
	local list = {}
	local now, serverNow = os.clock(), Workspace:GetServerTimeNow()
	for id, telegraph in pairs(Dodge.Telegraphs) do
		local alive = now < telegraph.Until and Dodge.casterAlive(telegraph.Caster)
		if alive then
			for _, zone in ipairs(telegraph.Zones) do
				if not Dodge.update(zone, serverNow) then
					alive = false
					break
				end
			end
		end
		if alive then
			for _, zone in ipairs(telegraph.Zones) do
				table.insert(list, zone)
			end
		else
			Dodge.Telegraphs[id] = nil
		end
	end
	return list
end

function Dodge.threats(zones, point)
	local first = nil
	for _, zone in ipairs(zones) do
		if Dodge.inside(zone, point) then
			zone.Telegraph.Threat = true
			first = first or zone
		end
	end
	return first
end

function Dodge.findSpot(origin, zones)
	local clear = Const.ULT_EDGE_PAD + Settings.UltDodgeDistance
	local best, bestDistance = nil, math.huge
	local function consider(point)
		point = Vector3.new(point.X, origin.Y, point.Z)
		local distance = (point - origin).Magnitude
		if distance < bestDistance and Dodge.safe(zones, point) then
			best, bestDistance = point, distance
		end
	end
	for _, zone in ipairs(zones) do
		if Dodge.inside(zone, origin) then
			local frame, reach = Dodge.frameFor(zone, origin)
			if zone.Kind == "Circle" then
				local away = (origin - frame.Position) * Vector3.new(1, 0, 1)
				if away.Magnitude < 0.1 then
					away = -frame.LookVector
				end
				consider(frame.Position + away.Unit * (zone.Radius + clear))
			else
				local length, center = Dodge.boxSpan(zone, reach)
				local offset = frame:PointToObjectSpace(origin)
				local side = zone.Width / 2 + clear
				local ends = length / 2 + clear
				consider(frame:PointToWorldSpace(Vector3.new(side, 0, offset.Z)))
				consider(frame:PointToWorldSpace(Vector3.new(-side, 0, offset.Z)))
				consider(frame:PointToWorldSpace(Vector3.new(offset.X, 0, center + ends)))
				consider(frame:PointToWorldSpace(Vector3.new(offset.X, 0, center - ends)))
			end
		end
	end
	for ring = 1, Const.ULT_SEARCH_RINGS do
		if best then
			break
		end
		local radius = clear + ring * Const.ULT_SEARCH_STEP
		for step = 0, Const.ULT_SEARCH_DIRECTIONS - 1 do
			local angle = step / Const.ULT_SEARCH_DIRECTIONS * math.pi * 2
			consider(origin + Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius)
		end
	end
	return best
end

function Dodge.finish(status)
	Dodge.Active = false
	Dodge.Returning = false
	Dodge.Origin = nil
	Dodge.Spot = nil
	Dodge.Goal = nil
	Dodge.Caster = nil
	Dodge.ClearAt = nil
	if Dodge.Lease then
		Dodge.Lease:SetGoal(nil)
	end
	Dodge.Status = status
end

function Dodge.move(root, zones)
	Dodge.RespotAt = os.clock() + Const.ULT_RESPOT_GAP
	local spot = Dodge.findSpot(root.Position, zones)
	if not spot then
		Dodge.Spot = nil
		Dodge.Goal = root.CFrame
		Dodge.Lease:SetGoal(function()
			return Dodge.Goal
		end)
		Dodge.Status = "No safe spot found"
		return
	end
	local casterRoot = Dodge.Caster and Dodge.frameOf(Dodge.Caster)
	local facing = casterRoot and Vector3.new(casterRoot.Position.X, spot.Y, casterRoot.Position.Z)
	if facing and (facing - spot).Magnitude > 0.1 then
		Dodge.Goal = CFrame.lookAt(spot, facing)
	else
		Dodge.Goal = CFrame.new(spot) * root.CFrame.Rotation
	end
	Dodge.Spot = spot
	Dodge.Lease:SetGoal(function()
		return Dodge.Goal
	end)
	Dodge.Status = "Dodging " .. Dodge.Caster.Name
end

function Dodge.begin(root, zones, zone)
	if not Dodge.Returning then
		Dodge.Origin = root.CFrame
	end
	Dodge.Active = true
	Dodge.Returning = false
	Dodge.ClearAt = nil
	Dodge.Caster = zone.Telegraph.Caster
	Dodge.Count += 1
	Dodge.Lease = Dodge.Lease or Mover.acquire("dodge", 33)
	Combat.setPressing(false)
	Dodge.move(root, zones)
end

function Dodge.goBack()
	local origin = Dodge.Origin
	Dodge.Active = false
	Dodge.Spot = nil
	Dodge.Goal = nil
	Dodge.ClearAt = nil
	Dodge.Lease:SetGoal(nil)
	if not origin or Mover.select() ~= nil then
		Dodge.finish("Watching")
		return
	end
	Dodge.Returning = true
	Dodge.ReturnUntil = os.clock() + Const.ULT_RETURN_TIME
	Dodge.Lease:SetGoal(function()
		if Settings.AutoDodgeUlt and Dodge.Returning and Dodge.safe(Dodge.zones(), origin.Position) then
			return origin
		end
	end)
	Dodge.Status = "Going back"
end

function Dodge.step()
	if not Settings.AutoDodgeUlt then
		if Dodge.Active or Dodge.Returning or next(Dodge.Telegraphs) ~= nil then
			table.clear(Dodge.Telegraphs)
			Dodge.finish("Off")
		end
		Dodge.Status = "Off"
		return
	end
	if Dodge.Unavailable then
		Dodge.Status = "Not available in this place"
		return
	end
	local root = Character.root()
	if not root or not Character.alive() then
		table.clear(Dodge.Telegraphs)
		Dodge.finish("Waiting for your character")
		return
	end
	local zones = Dodge.zones()
	if not Dodge.Active then
		local zone = Dodge.threats(zones, root.Position)
		if zone then
			Dodge.begin(root, zones, zone)
		elseif Dodge.Returning then
			local originThreat = Dodge.threats(zones, Dodge.Origin.Position)
			if originThreat then
				Dodge.begin(root, zones, originThreat)
			elseif os.clock() >= Dodge.ReturnUntil or (root.Position - Dodge.Origin.Position).Magnitude <= Const.ULT_RETURN_REACH then
				Dodge.finish("Watching")
			end
		else
			Dodge.Status = "Watching"
		end
		return
	end
	Dodge.threats(zones, Dodge.Origin.Position)
	Dodge.threats(zones, root.Position)
	if Dodge.Spot then
		Dodge.threats(zones, Dodge.Spot)
	end
	local threatened = false
	for _, zone in ipairs(zones) do
		if zone.Telegraph.Threat then
			threatened = true
			break
		end
	end
	if threatened then
		Dodge.ClearAt = nil
		if os.clock() >= Dodge.RespotAt and (not Dodge.safe(zones, Dodge.Spot) or not Dodge.safe(zones, root.Position)) then
			Dodge.move(root, zones)
		end
		return
	end
	Dodge.ClearAt = Dodge.ClearAt or os.clock()
	if os.clock() - Dodge.ClearAt < Settings.UltReturnDelay then
		Dodge.Status = "Ult over, waiting"
		return
	end
	Dodge.goBack()
end

function Dodge.onTelegraph(caster, action, id, data)
	if not Settings.AutoDodgeUlt or type(action) ~= "string" or type(id) ~= "string" then
		return
	end
	if action == "Cancel" then
		Dodge.Telegraphs[id] = nil
		return
	end
	if action == "Flash" or type(data) ~= "table" or typeof(caster) ~= "Instance" or caster == LocalPlayer.Character then
		return
	end
	if action == "Start" then
		Dodge.Telegraphs[id] = { Caster = caster, Zones = {}, Until = os.clock() + Const.ULT_MAX_HOLD, Threat = false }
		return
	end
	local telegraph = Dodge.Telegraphs[id]
	local zone = telegraph and Dodge.zone(telegraph, action, data)
	if zone then
		table.insert(telegraph.Zones, zone)
		Dodge.step()
	end
end

do
	local node = ReplicatedStorage:FindFirstChild("Communication")
	for _, name in ipairs({ "ServerAndClient", "Effects", "EffectsEvent" }) do
		node = node and node:FindFirstChild(name)
	end
	local ok, effects = pcall(require, node)
	local connection = nil
	if ok and type(effects) == "table" and type(effects.Connect) == "function" then
		local connected, result = pcall(effects.Connect, effects, function(name, ...)
			if name ~= "Telegraph" then
				return
			end
			local handled, err = pcall(Dodge.onTelegraph, ...)
			if not handled then
				warn("[Spryzen Hub] ult dodge error: " .. tostring(err))
			end
		end)
		connection = connected and typeof(result) == "RBXScriptConnection" and result or nil
	end
	if connection then
		RootMaid:Give(connection)
	else
		Dodge.Unavailable = true
	end
end

RootMaid:Give(RunService.Heartbeat:Connect(function()
	local ok, err = pcall(Dodge.step)
	if not ok then
		table.clear(Dodge.Telegraphs)
		Dodge.finish("Error, retrying")
		if os.clock() >= (Dodge.ErrorAt or 0) then
			Dodge.ErrorAt = os.clock() + 5
			warn("[Spryzen Hub] ult dodge error: " .. tostring(err))
		end
	end
end))

RootMaid:Give(function()
	table.clear(Dodge.Telegraphs)
	Dodge.finish("Off")
	if Dodge.Lease then
		Dodge.Lease:Release()
		Dodge.Lease = nil
	end
end)

function Defense.busy()
	return Defense.Holding ~= nil or os.clock() < Defense.ReservedUntil
end

function Defense.values()
	return Game.Utility.getvaluesfolder(LocalPlayer)
end

function Defense.blockValue(values)
	local block = (values and values:FindFirstChild("Blocking")) or LocalPlayer:FindFirstChild("Blocking")
	if block and block:IsA("IntConstrainedValue") then
		return block
	end
	return nil
end

function Defense.points(values)
	local block = Defense.blockValue(values)
	if not block then
		return nil
	end
	return block.Value - (tonumber(block:GetAttribute("D")) or 0)
end

function Defense.ping()
	local now = os.clock()
	if now >= Defense.RttAt then
		Defense.RttAt = now + Const.PARRY_PING_INTERVAL
		local ok, value = pcall(function()
			return Defense.StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
		end)
		if ok and type(value) == "number" and value > 0 and value < 2 then
			Defense.Rtt = Defense.Rtt * 0.7 + value * 0.3
		end
	end
	return Defense.Rtt
end

function Defense.presetFor(name)
	local presets = Game.CombatPresets.Presets
	if presets[name] then
		return presets[name]
	end
	local info = Game.Items[name]
	if type(info) == "table" and info.CombatPreset ~= nil then
		return presets[info.CombatPreset]
	end
	return nil
end

function Defense.catalog()
	if Defense.Catalog then
		return Defense.Catalog
	end
	local map = {}
	for _, folder in ipairs(Game.Animations:GetChildren()) do
		local name = string.match(folder.Name, "^(.+)_Combat_Anims$")
		local preset = name and Defense.presetFor(name)
		if preset then
			for _, animation in ipairs(folder:GetChildren()) do
				if animation:IsA("Animation") then
					local combo = tonumber(string.match(animation.Name, "^Swing_(%d+)$")) or (animation.Name == "Run_Hit" and 1 or nil)
					local id = combo and string.match(animation.AnimationId, "%d+")
					if id then
						map[id] = map[id] or {}
						table.insert(map[id], { Name = name, Preset = preset, Combo = combo })
					end
				end
			end
		end
	end
	Defense.Catalog = map
	return map
end

function Defense.resolve(track, model, player)
	local animation = track.Animation
	local list = animation and Defense.catalog()[string.match(animation.AnimationId, "%d+") or ""]
	if not list then
		return nil
	end
	if #list == 1 then
		return list[1]
	end
	local tool = model:GetAttribute("Equipped_Tool")
	if tool == nil and player then
		local ok, item = pcall(Game.CharacterInfo.Get_equipped_tool, player)
		tool = ok and typeof(item) == "Instance" and item.Name or nil
	end
	local preset = type(tool) == "string" and Defense.presetFor(tool) or nil
	for _, info in ipairs(list) do
		if info.Name == tool or (preset ~= nil and info.Preset == preset) then
			return info
		end
	end
	local first = list[1]
	for _, info in ipairs(list) do
		if info.Preset ~= first.Preset or info.Combo ~= first.Combo then
			return nil
		end
	end
	return first
end

function Defense.hitDelay(info, player)
	local presets = Game.CombatPresets
	local preset, combo = info.Preset, info.Combo
	local swing = (preset.delay_before_swing and preset.delay_before_swing[combo]) or preset.default_before_swing or presets.Default_Swing_Wait or 0
	local hit = (preset.delay_before_hit and preset.delay_before_hit[combo]) or preset.default_before_hit or swing
	if not player then
		return hit
	end
	local ok, speed = pcall(presets.attackSpeedMult, player)
	speed = ok and type(speed) == "number" and speed > 0 and speed or 1
	return swing + math.max(hit - swing, 0) / speed
end

function Defense.reach(info)
	local reaches = info.Preset.Reaches
	local value = type(reaches) == "table" and (reaches[info.Combo] or reaches.Default) or nil
	return (tonumber(value) or Const.PARRY_DEFAULT_REACH) + Const.PARRY_REACH_PAD
end

function Defense.onTrack(model, player, track)
	if not Settings.AutoParry or Defense.Threats[track] or (player and not Settings.ParryPlayers) then
		return
	end
	local info = Defense.resolve(track, model, player)
	if not info then
		return
	end
	local now = os.clock()
	local elapsed = track.Speed > 0 and track.TimePosition / track.Speed or 0
	Defense.Threats[track] = {
		Model = model,
		Impact = now + Defense.hitDelay(info, player) - elapsed,
		Window = player and Const.PARRY_PVP_WINDOW or Const.PARRY_NPC_WINDOW,
		Reach = Defense.reach(info),
		Created = now,
	}
end

function Defense.watch(model, player)
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
	local record = Defense.Watched[model]
	if record and record.Animator == animator then
		record.Seen = true
		return
	end
	if record then
		record.Connection:Disconnect()
		Defense.Watched[model] = nil
	end
	if not animator then
		return
	end
	Defense.Watched[model] = {
		Animator = animator,
		Seen = true,
		Connection = animator.AnimationPlayed:Connect(function(track)
			local ok, err = pcall(Defense.onTrack, model, player, track)
			if not ok then
				warn("[Spryzen Hub] parry error: " .. tostring(err))
			end
		end),
	}
end

function Defense.scan(root)
	for _, record in pairs(Defense.Watched) do
		record.Seen = false
	end
	local origin = root.Position
	local radius = Settings.ParryRadius
	Mobs.eachAlive(function(model, mobRoot, entry)
		if Mobs.isCombatTarget(model, entry) and (mobRoot.Position - origin).Magnitude <= radius then
			Defense.watch(model, nil)
		end
	end)
	if Settings.ParryPlayers then
		for _, other in ipairs(Players:GetPlayers()) do
			local model = other ~= LocalPlayer and other.Character
			local otherRoot = model and model:FindFirstChild("HumanoidRootPart")
			if otherRoot and Mobs.isAlive(model) and (otherRoot.Position - origin).Magnitude <= radius then
				Defense.watch(model, other)
			end
		end
	end
	for model, record in pairs(Defense.Watched) do
		if not record.Seen then
			record.Connection:Disconnect()
			Defense.Watched[model] = nil
		end
	end
end

function Defense.unwatchAll()
	for _, record in pairs(Defense.Watched) do
		record.Connection:Disconnect()
	end
	table.clear(Defense.Watched)
	table.clear(Defense.Threats)
	Defense.ReservedUntil = 0
end

function Defense.press(kind, releaseAt)
	Combat.setPressing(false)
	Game.press(Const.BLOCK_INPUT)
	local now = os.clock()
	Defense.Holding = { Kind = kind, Since = now, ReleaseAt = releaseAt, Confirmed = false, Counted = false }
	Defense.PressedAt = now
end

function Defense.release()
	if not Defense.Holding then
		return
	end
	Defense.Holding = nil
	Defense.RestUntil = os.clock() + Const.BLOCK_REST
	Game.release(Const.BLOCK_INPUT)
end

function Defense.note(field, text)
	Defense[field] = text
	Defense[field .. "At"] = os.clock()
end

function Defense.trackPresses(values, now)
	local block = Defense.blockValue(values)
	local stamp = block and block:GetAttribute("PressedAt")
	if type(stamp) ~= "number" then
		return
	end
	if Defense.PressStamp ~= nil and stamp ~= Defense.PressStamp and now - Defense.PressedAt > Defense.Rtt + 0.5 then
		Defense.PressedAt = now - Defense.Rtt * 0.5
	end
	Defense.PressStamp = stamp
end

function Defense.trackHits(values, now)
	local dmg = values:FindFirstChild("DMG")
	local stamp = dmg and tonumber(dmg:GetAttribute("LastAttacked"))
	if stamp and stamp ~= Defense.HitStamp then
		local fresh = Defense.HitStamp ~= nil and Game.Utility.Tick() - stamp < 0.5
		Defense.HitStamp = stamp
		if fresh then
			Defense.LastHitAt = now
			table.insert(Defense.Hits, now)
		end
	end
	local points = Defense.points(values)
	if Defense.Holding and points and Defense.LastPoints and points < Defense.LastPoints then
		Defense.LastHitAt = now
	end
	Defense.LastPoints = points
	for index = #Defense.Hits, 1, -1 do
		if now - Defense.Hits[index] > Const.BLOCK_HIT_WINDOW then
			table.remove(Defense.Hits, index)
		end
	end
end

function Defense.stepHolding(values, now)
	local holding = Defense.Holding
	local block = values:FindFirstChild("Blocking")
	if block and not holding.Confirmed then
		holding.Confirmed = true
	end
	if holding.Confirmed and not block then
		Defense.release()
		return
	end
	if not holding.Confirmed then
		if now - holding.Since > Defense.Rtt + Const.PARRY_CONFIRM_TIMEOUT then
			Defense.release()
			Defense.note(holding.Kind == "Parry" and "ParryStatus" or "BlockStatus", "The game refused the block")
		end
		return
	end
	if not holding.Counted and (block:FindFirstChild("Perfect") or block:FindFirstChild("PerfectNpc")) then
		holding.Counted = true
		Defense.PerfectWindows += 1
	end
	if holding.Kind == "Parry" then
		if now >= holding.ReleaseAt then
			Defense.release()
		end
		return
	end
	local points = Defense.points(values)
	if points and points <= 0 then
		Defense.release()
		Defense.note("BlockStatus", "Out of block points")
	elseif now - Defense.LastHitAt >= Const.BLOCK_QUIET then
		Defense.release()
		Defense.note("BlockStatus", "Combo over")
	elseif now - holding.Since >= Const.BLOCK_MAX_HOLD then
		Defense.release()
		Defense.note("BlockStatus", "Released after " .. Const.BLOCK_MAX_HOLD .. "s")
	end
end

function Defense.perfectReady(values)
	if values:FindFirstChild("Stun") or values:FindFirstChild("CombatStun") then
		return false, "Stunned, can't parry"
	end
	local dmg = values:FindFirstChild("DMG")
	local last = dmg and tonumber(dmg:GetAttribute("LastAttacked"))
	if last and Game.Utility.Tick() - last < Const.PARRY_HIT_LOCK then
		return false, "Hit too recently to parry"
	end
	local ok, cooldown = pcall(Game.ManageCd.fetch, LocalPlayer, "Blocking")
	cooldown = ok and tonumber(cooldown) or Const.PARRY_DEFAULT_COOLDOWN
	if os.clock() - Defense.PressedAt < cooldown - Const.PARRY_COOLDOWN_GRACE + Const.PARRY_COOLDOWN_PAD then
		return false, "Block on cooldown"
	end
	return true
end

function Defense.stepParry(values, root, now)
	local rtt = Defense.ping()
	local ready, reason = Defense.perfectReady(values)
	local soonest, chosen = math.huge, nil
	for track, threat in pairs(Defense.Threats) do
		threat.Latest = threat.Impact - rtt
		if now > threat.Latest or now - threat.Created > Const.PARRY_THREAT_LIFETIME or not Mobs.isAlive(threat.Model) then
			Defense.Threats[track] = nil
		else
			local targetRoot = threat.Model:FindFirstChild("HumanoidRootPart")
			if targetRoot and (targetRoot.Position - root.Position).Magnitude <= threat.Reach then
				local pressAt = threat.Latest - threat.Window * 0.5
				soonest = math.min(soonest, pressAt)
				if now >= pressAt and (chosen == nil or threat.Latest < chosen.Latest) then
					chosen = threat
				end
			end
		end
	end
	Defense.ReservedUntil = (ready and soonest - now <= Const.PARRY_RESERVE_AHEAD) and soonest + Const.PARRY_HOLD_AFTER or 0
	if not chosen or Defense.Holding then
		return
	end
	if not ready then
		Defense.note("ParryStatus", reason)
		return
	end
	local releaseAt = chosen.Impact + Const.PARRY_HOLD_AFTER
	for track, threat in pairs(Defense.Threats) do
		if threat.Latest <= releaseAt then
			Defense.Threats[track] = nil
		end
	end
	Defense.press("Parry", releaseAt)
	Defense.Parries += 1
	Defense.note("ParryStatus", "Parried " .. chosen.Model.Name)
end

function Defense.stepBlock(values, now)
	if Defense.Holding or now < Defense.RestUntil or now < Defense.ReservedUntil then
		return
	end
	if #Defense.Hits < Settings.BlockAfterHits then
		return
	end
	local points = Defense.points(values)
	if points and points <= 0 then
		Defense.note("BlockStatus", "Comboed, but out of block points")
		return
	end
	table.clear(Defense.Hits)
	Defense.LastHitAt = now
	Defense.press("Block", math.huge)
	Defense.Blocks += 1
	Defense.note("BlockStatus", "Blocking a combo")
end

function Defense.step()
	if not (Settings.AutoParry or Settings.AutoBlock) then
		Defense.release()
		Defense.ReservedUntil = 0
		return
	end
	local values = Defense.values()
	local root = Character.root()
	if not values or not root or not Character.alive() then
		Defense.release()
		Defense.ReservedUntil = 0
		return
	end
	local now = os.clock()
	Defense.trackPresses(values, now)
	Defense.trackHits(values, now)
	if Defense.Holding then
		Defense.stepHolding(values, now)
	end
	if Settings.AutoParry then
		if now >= Defense.ScanAt then
			Defense.ScanAt = now + Const.PARRY_SCAN_INTERVAL
			Defense.scan(root)
		end
		Defense.stepParry(values, root, now)
	else
		Defense.ReservedUntil = 0
	end
	if Settings.AutoBlock then
		Defense.stepBlock(values, now)
	end
end

function Defense.refresh()
	if not Settings.AutoParry then
		Defense.unwatchAll()
	end
	if not (Settings.AutoParry or Settings.AutoBlock) then
		Defense.release()
	end
end

function Defense.text(field, fallback)
	local at = Defense[field .. "At"]
	if at and os.clock() - at < 2 then
		return Defense[field]
	end
	return fallback
end

function Defense.stop()
	Defense.release()
	Defense.unwatchAll()
end

RootMaid:Give(RunService.Heartbeat:Connect(function()
	local ok, err = pcall(Defense.step)
	if not ok then
		Defense.release()
		if os.clock() >= (Defense.ErrorAt or 0) then
			Defense.ErrorAt = os.clock() + 5
			warn("[Spryzen Hub] parry/block error: " .. tostring(err))
		end
	end
end))

RootMaid:Give(Defense.stop)

local Prompts = { Shown = setmetatable({}, { __mode = "k" }) }

do
	local promptService = game:GetService("ProximityPromptService")
	RootMaid:Give(promptService.PromptShown:Connect(function(prompt)
		Prompts.Shown[prompt] = true
	end))
	RootMaid:Give(promptService.PromptHidden:Connect(function(prompt)
		Prompts.Shown[prompt] = nil
	end))
end

function Prompts.waitShown(prompt, timeout, isCancelled)
	local deadline = os.clock() + timeout
	while not Prompts.Shown[prompt] do
		if os.clock() > deadline or (isCancelled and isCancelled()) or not prompt.Parent then
			return false
		end
		task.wait()
	end
	return true
end

function Prompts.trigger(prompt, isCancelled)
	if prompt.HoldDuration <= 0 then
		fireproximityprompt(prompt)
		return true
	end
	prompt:InputHoldBegin()
	local deadline = os.clock() + prompt.HoldDuration + 0.15
	while os.clock() < deadline do
		if (isCancelled and isCancelled()) or not prompt.Parent then
			prompt:InputHoldEnd()
			return false
		end
		task.wait()
	end
	prompt:InputHoldEnd()
	return true
end

local Collector = { Ignored = {}, Wanted = {}, Status = "Idle", Busy = false, Focus = nil, Watched = nil, WatchedAt = nil, RarityFilter = {}, ItemFilter = {}, RarityOptions = table.clone(Game.Rarities.Order), ItemOptions = {} }

for name, info in pairs(Game.Items) do
	if type(name) == "string" and type(info) == "table" then
		table.insert(Collector.ItemOptions, name)
	end
end
table.sort(Collector.ItemOptions)

function Collector.setFilter(filter, options)
	table.clear(filter)
	for _, option in ipairs(type(options) == "table" and options or {}) do
		filter[option] = true
	end
end

function Collector.dropRarity(itemId)
	local info = Game.Items[itemId]
	local rank = type(info) == "table" and tonumber(info.Rarity) or 1
	return Game.Rarities.Order[rank]
end

function Collector.dropWanted(part)
	local rarities, items = Collector.RarityFilter, Collector.ItemFilter
	if next(rarities) == nil and next(items) == nil then
		return true
	end
	local itemId = tostring(part:GetAttribute("DropItemId") or "Loot")
	return items[itemId] == true or rarities[Collector.dropRarity(itemId)] == true
end

function Collector.bossPosition(model)
	local root = model and model:FindFirstChild("HumanoidRootPart")
	if root and root.Position.Magnitude < Const.BOSS_POSITION_LIMIT then
		return root.Position
	end
	return nil
end

function Collector.focus(position)
	if position then
		Collector.Focus = { Position = position, Until = os.clock() + Const.BOSS_LOOT_MAX }
	end
end

function Collector.focusAt()
	local focus = Collector.Focus
	if focus and os.clock() < focus.Until then
		return focus.Position
	end
	Collector.Focus = nil
	return nil
end

function Collector.dropEligible(part)
	local owner = part:GetAttribute("DropOwnerUserId")
	if typeof(owner) == "number" and owner ~= LocalPlayer.UserId then
		return false
	end
	local reserved = part:GetAttribute("DropReservedFor")
	if typeof(reserved) == "string" and not string.find(reserved, "," .. LocalPlayer.UserId .. ",", 1, true) then
		return false
	end
	return part:GetAttribute("DropClaimedBy") == nil
end

function Collector.dropPosition(part)
	local target = part:GetAttribute("DropTarget")
	return typeof(target) == "Vector3" and target or part.Position
end

function Collector.chestStates()
	if type(debug.getupvalue) ~= "function" then
		return nil
	end
	local ok, states = pcall(debug.getupvalue, Game.ChestController.handleState, 1)
	return ok and type(states) == "table" and states or nil
end

function Collector.chestModels()
	local models = {}
	for _, model in ipairs(CollectionService:GetTagged(Game.GameSettings.Tags.Chest or "Chest")) do
		if model:IsA("Model") and model:IsDescendantOf(Workspace) then
			local guid = model:GetAttribute("ChestGuid")
			if guid ~= nil then
				models[tostring(guid)] = model
			end
		end
	end
	return models
end

function Collector.modelOpen(model)
	return model:GetAttribute("IsOpen") == true or model:GetAttribute("ChestState") ~= "Spawned"
end

function Collector.candidates()
	local root = Character.root()
	if not root then
		return {}
	end
	local origin = root.Position
	local now = os.clock()
	local seen = {}
	local list = {}
	local function consider(kind, key, position, always, data)
		local ignoredAt = Collector.Ignored[key]
		if ignoredAt and now - ignoredAt < Const.CLAIM_RETRY_AFTER then
			return
		end
		local distance = (position - origin).Magnitude
		if distance > Settings.DropRange then
			return
		end
		seen[key] = true
		Collector.Wanted[key] = true
		data.Kind, data.Key, data.Position, data.Distance = kind, key, position, distance
		table.insert(list, data)
	end
	if Settings.AutoPickup then
		for _, part in ipairs(CollectionService:GetTagged(Game.GameSettings.Tags.LootDrop or "LootDrop")) do
			if part:IsA("BasePart") and part:IsDescendantOf(Workspace) and Collector.dropEligible(part) and Collector.dropWanted(part) then
				local prompt = part:FindFirstChildWhichIsA("ProximityPrompt", true)
				if prompt and prompt.Enabled then
					consider("Drop", part, Collector.dropPosition(part), part:GetAttribute("DropOwnerUserId") == LocalPlayer.UserId, { Instance = part, Prompt = prompt })
				end
			end
		end
		local states = not Hub.InDungeon and Collector.chestStates() or nil
		local models = not Hub.InDungeon and Collector.chestModels() or {}
		if states then
			for guid, state in pairs(states) do
				if type(state) == "table" and state.state == "Spawned" and typeof(state.position) == "Vector3" then
					local model = models[tostring(guid)]
					if not (model and Collector.modelOpen(model)) then
						consider("Chest", tostring(guid), model and model:GetPivot().Position or state.position, false, { Instance = model, States = states })
					end
				end
			end
		else
			for guid, model in pairs(models) do
				if not Collector.modelOpen(model) then
					consider("Chest", guid, model:GetPivot().Position, false, { Instance = model })
				end
			end
		end
	end
	if Settings.AutoSouls then
		local debree = Workspace:FindFirstChild("Debree")
		if debree then
			for _, model in ipairs(debree:GetChildren()) do
				if model:IsA("Model") and Catalog.SoulNames[model.Name] then
					local prompt = model:FindFirstChild("SoulPrompt", true)
					if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
						consider("Soul", model, model:GetPivot().Position, false, { Instance = model, Prompt = prompt })
					end
				end
			end
		end
	end
	for key in pairs(Collector.Wanted) do
		if not seen[key] then
			Collector.Wanted[key] = nil
		end
	end
	table.sort(list, function(a, b)
		return a.Distance < b.Distance
	end)
	return list
end

function Collector.pendingNear(position, radius)
	local states = Collector.chestStates()
	if states then
		for guid, state in pairs(states) do
			if type(state) == "table" and state.state == "Spawned" and typeof(state.position) == "Vector3" and (state.position - position).Magnitude <= radius and not Collector.Ignored[tostring(guid)] then
				return true
			end
		end
		return false
	end
	for guid, model in pairs(Collector.chestModels()) do
		if not Collector.modelOpen(model) and (model:GetPivot().Position - position).Magnitude <= radius and not Collector.Ignored[guid] then
			return true
		end
	end
	return false
end

function Collector.chestModel(candidate)
	local model = candidate.Instance
	if model and model.Parent and model:IsDescendantOf(Workspace) then
		return model
	end
	model = Collector.chestModels()[candidate.Key]
	candidate.Instance = model
	return model
end

function Collector.claimed(candidate)
	if candidate.Kind == "Chest" then
		local states = candidate.States
		if states then
			local state = states[candidate.Key] or states[tonumber(candidate.Key)]
			if not state or state.state ~= "Spawned" then
				return true
			end
		end
		local model = Collector.chestModel(candidate)
		if model then
			return Collector.modelOpen(model)
		end
		return states == nil
	end
	local instance = candidate.Instance
	if not instance.Parent or not instance:IsDescendantOf(Workspace) then
		return true
	end
	if candidate.Kind == "Drop" then
		return instance:GetAttribute("DropClaimedBy") ~= nil
	end
	return not candidate.Prompt.Parent or not candidate.Prompt.Enabled
end

function Collector.prompt(candidate)
	if candidate.Kind ~= "Chest" then
		return candidate.Prompt
	end
	local model = Collector.chestModel(candidate)
	local prompt = model and model:FindFirstChild("ChestPrompt", true)
	return prompt and prompt:IsA("ProximityPrompt") and prompt or nil
end

function Collector.walkTo(position, isCancelled)
	local flat = Vector3.new(1, 0, 1)
	local function reached()
		local root = Character.root()
		return root ~= nil and (root.Position - position).Magnitude <= Const.WALK_REACH
	end
	for _ = 1, Const.WALK_REPATHS do
		local root, humanoid = Character.root(), Character.humanoid()
		if not root or not humanoid or isCancelled() then
			return false
		end
		if reached() then
			return true
		end
		local path = PathfindingService:CreatePath({ AgentRadius = 2, AgentHeight = 5, AgentCanJump = true })
		local ok = pcall(path.ComputeAsync, path, root.Position, position)
		if not ok or path.Status ~= Enum.PathStatus.Success then
			return false
		end
		local blocked = false
		for index, waypoint in ipairs(path:GetWaypoints()) do
			if index > 1 then
				if isCancelled() or not Character.alive() then
					return false
				end
				if waypoint.Action == Enum.PathWaypointAction.Jump then
					humanoid.Jump = true
				end
				humanoid:MoveTo(waypoint.Position)
				local deadline = os.clock() + Const.WALK_STEP_TIMEOUT
				while ((root.Position - waypoint.Position) * flat).Magnitude > 2 do
					if os.clock() > deadline then
						blocked = true
						break
					end
					if isCancelled() or not Character.alive() then
						return false
					end
					task.wait()
				end
				if blocked then
					break
				end
			end
		end
		if reached() or not blocked then
			return reached()
		end
	end
	return reached()
end

function Collector.collect(candidate)
	local isClaimed = function()
		return Collector.claimed(candidate)
	end
	local name
	if candidate.Kind == "Drop" then
		name = tostring(candidate.Instance:GetAttribute("DropItemId") or "drop")
	elseif candidate.Kind == "Chest" then
		local model = candidate.Instance
		local state = candidate.States and candidate.States[candidate.Key]
		name = tostring((model and model:GetAttribute("ChestId")) or (state and state.configId) or "chest")
	else
		name = candidate.Instance.Name
	end
	Collector.Status = (candidate.Kind == "Chest" and "Opening " or "Fetching ") .. name
	if not Collector.walkTo(candidate.Position, isClaimed) then
		if not isClaimed() then
			Collector.Ignored[candidate.Key] = os.clock()
		end
		return
	end
	local deadline = os.clock() + Const.CLAIM_TIMEOUT
	while not isClaimed() and os.clock() < deadline do
		local prompt = Collector.prompt(candidate)
		if prompt and prompt.Enabled then
			Prompts.trigger(prompt, isClaimed)
			local refire = os.clock() + Const.CLAIM_REFIRE
			while not isClaimed() and os.clock() < refire do
				task.wait()
			end
		else
			task.wait()
		end
	end
	if not isClaimed() then
		Collector.Ignored[candidate.Key] = os.clock()
	end
end

function Collector.tick()
	if not (Settings.AutoPickup or Settings.AutoSouls) or not Character.alive() then
		Collector.Busy = false
		Collector.Status = "Idle"
		return
	end
	if Settings.AutoSouls and not table.find(Game.sidesFor(), "Demon") and not Settings.AutoPickup then
		Collector.Busy = false
		Collector.Status = "Souls only drop for the Demon race"
		return
	end
	while (Settings.AutoPickup or Settings.AutoSouls) and Character.alive() do
		local nextCandidate = nil
		for _, candidate in ipairs(Collector.candidates()) do
			if not Collector.claimed(candidate) then
				nextCandidate = candidate
				break
			end
		end
		if not nextCandidate then
			break
		end
		Collector.Busy = true
		Mover.Walking = true
		local ok, err = pcall(Collector.collect, nextCandidate)
		Mover.Walking = false
		if not ok then
			error(err, 0)
		end
	end
	Collector.Busy = false
	Collector.Status = "Waiting for drops"
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(Collector.tick)
		if not ok then
			warn("[Spryzen Hub] collector error: " .. tostring(err))
			Collector.Busy = false
			Mover.Walking = false
		end
		for key, at in pairs(Collector.Ignored) do
			if os.clock() - at > Const.CLAIM_RETRY_AFTER or (typeof(key) == "Instance" and not key.Parent) then
				Collector.Ignored[key] = nil
			end
		end
		task.wait(Const.COLLECT_POLL)
	end
end))

RootMaid:Give(function()
	Collector.Busy = false
	Mover.Walking = false
end)

function Collector.watchBoss()
	local watched = Collector.Watched
	if watched then
		if not Mobs.isAlive(watched) then
			Collector.Watched = nil
			Collector.focus(Collector.WatchedAt)
			return
		end
		Collector.WatchedAt = Collector.bossPosition(watched) or Collector.WatchedAt
	end
	local target = Combat.BossTarget
	if target ~= watched and Mobs.isAlive(target) then
		Collector.Watched = target
		Collector.WatchedAt = Collector.bossPosition(target)
	end
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(Collector.watchBoss)
		if not ok then
			warn("[Spryzen Hub] boss loot watch error: " .. tostring(err))
		end
		task.wait(Const.BOSS_POLL)
	end
end))

local Context = {}
Context.__index = Context

function Context.new(lease)
	return setmetatable({ Lease = lease, Cancelled = false, Skip = {}, Status = "Starting" }, Context)
end

function Context:isCancelled()
	return self.Cancelled
end

function Context:sleep(seconds)
	local deadline = os.clock() + seconds
	while os.clock() < deadline and not self.Cancelled do
		task.wait(0.1)
	end
	return not self.Cancelled
end

function Context:waitFor(predicate, timeout)
	local deadline = os.clock() + timeout
	while os.clock() < deadline do
		if self.Cancelled then
			return false
		end
		if predicate() then
			return true
		end
		task.wait(0.1)
	end
	return predicate()
end

function Context:moveTo(position)
	local cancelled = function()
		return self.Cancelled
	end
	return self.Lease:MoveTo(CFrame.new(position), cancelled)
end

function Context:setStatus(text)
	self.Status = text
end

local Hunt = {}

function Hunt.nearestSpawn(accept)
	local root = Character.root()
	if not root then
		return nil
	end
	local best, bestDistance = nil, math.huge
	for _, mob in ipairs(Catalog.Mobs) do
		if mob.Center and accept(mob) then
			local distance = (mob.Center - root.Position).Magnitude
			if distance < bestDistance then
				best, bestDistance = mob, distance
			end
		end
	end
	return best
end

function Hunt.pauseReason(ctx)
	if not ctx.Job then
		return BossFarm.claims() and BossFarm.pauseText() or nil
	end
	local other = Priority.blocked(ctx.Job)
	if other then
		return Priority.pausedFor(other)
	end
	return Schematics.Busy and "Paused for schematics" or nil
end

function Hunt.hold(ctx)
	local reason = Hunt.pauseReason(ctx)
	if not reason then
		return false
	end
	ctx.Lease:SetGoal(nil)
	ctx:setStatus(reason)
	ctx:sleep(Const.PRIORITY_POLL)
	return true
end

function Hunt.engage(ctx, model, keep)
	if Hunt.pauseReason(ctx) then
		return
	end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local lastHealth = humanoid.Health
	local lastProgress = os.clock()
	Combat.FarmTarget = model
	ctx.Lease:SetGoal(function()
		local targetRoot = model.Parent and model:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			return Pose.around(targetRoot)
		end
		return nil
	end)
	local wasEngaged = Priority.engaged(ctx)
	Priority.set(ctx, "Engaged")
	while not ctx.Cancelled and Mobs.isAlive(model) and Character.alive() and not Hunt.pauseReason(ctx) and (keep == nil or keep()) do
		if Heal.Retreating or Escape.Active or Potion.Busy or Mover.traveling() then
			lastProgress = os.clock()
		elseif humanoid.Health < lastHealth then
			lastHealth = humanoid.Health
			lastProgress = os.clock()
		elseif os.clock() - lastProgress > Const.STUCK_TARGET_TIMEOUT then
			ctx.Skip[model] = os.clock()
			break
		end
		task.wait(0.1)
	end
	if not wasEngaged then
		Priority.set(ctx, "Want")
	end
	Combat.FarmTarget = nil
	ctx.Lease:SetGoal(nil)
end

function Hunt.once(ctx, accept, label)
	if Heal.Retreating or Escape.Active then
		ctx:setStatus(Escape.Active and "Paused, retreating" or "Paused to heal")
		ctx:sleep(0.5)
		return
	end
	if Hunt.hold(ctx) then
		return
	end
	for model, at in pairs(ctx.Skip) do
		if os.clock() - at > Const.SKIP_TARGET_FOR or not model.Parent then
			ctx.Skip[model] = nil
		end
	end
	if not Character.alive() then
		ctx:setStatus("Waiting for respawn")
		ctx:sleep(1)
		return
	end
	local model = Mobs.nearest(function(candidate, entry)
		return entry ~= nil and accept(entry) and ctx.Skip[candidate] == nil
	end)
	if model then
		ctx:setStatus("Fighting " .. model.Name .. (label and (" for " .. label) or ""))
		Hunt.engage(ctx, model)
		return
	end
	local spawn = Hunt.nearestSpawn(accept)
	if not spawn then
		ctx:setStatus("No spawn known for " .. (label or "the selected mobs"))
		ctx:sleep(2)
		return
	end
	ctx:setStatus("Waiting at " .. spawn.Name .. " spawn")
	ctx:moveTo(spawn.Center + Vector3.new(0, Const.SPAWN_WAIT_HEIGHT, 0))
	ctx:sleep(0.5)
end

local QuestRunner = {}

function QuestRunner.taskValues(activeQuest, taskName)
	local tasks = activeQuest:FindFirstChild("Tasks")
	local config = tasks and tasks:FindFirstChild(taskName)
	local value = config and config:FindFirstChild("Value")
	local maximum = config and config:FindFirstChild("Max")
	return config, value and value.Value or 0, maximum and maximum.Value or 0
end

function QuestRunner.nextTask(plan, activeQuest)
	local tasks = activeQuest:FindFirstChild("Tasks")
	if not tasks then
		return nil
	end
	local markers = type(plan.Info.Markers) == "table" and plan.Info.Markers or {}
	local fallback = nil
	for _, config in ipairs(tasks:GetChildren()) do
		local value, maximum = config:FindFirstChild("Value"), config:FindFirstChild("Max")
		local planTask = plan.Tasks[config.Name]
		if planTask and value and maximum and value.Value < maximum.Value and Game.Quests.TaskNeedMet(config) then
			local marker = markers[config.Name]
			local waitsOn = type(marker) == "table" and type(marker.After) == "table" and marker.After or nil
			local blocked = false
			if waitsOn then
				for _, otherName in ipairs(waitsOn) do
					local _, otherValue, otherMax = QuestRunner.taskValues(activeQuest, otherName)
					if otherValue < otherMax then
						blocked = true
						break
					end
				end
			end
			if not blocked then
				return planTask, config
			end
			fallback = fallback or planTask
		end
	end
	return nil, nil, fallback
end

function QuestRunner.acceptBlocker(plan)
	local quests = Game.Quests
	local data = Game.data()
	if not data then
		return "Waiting for player data", true
	end
	local info = plan.Info
	if info.LogCompletion == true and quests.GetPlayerQuestState(LocalPlayer, plan.Key) == "Done" then
		return "Already completed (one-time quest)", false
	end
	if type(info.Requirements) == "table" and not Game.ItemRequirements.Passes(data, info.Requirements) then
		local ok, text = pcall(Game.ItemRequirements.Describe, info.Requirements, data)
		return "Requirements not met: " .. (ok and tostring(text) or "?"), false
	end
	if type(info.WenCostOnAccept) == "number" and data.Wen.Value < info.WenCostOnAccept then
		return "Not enough Wen to accept", false
	end
	if info.ItemCostOnAccept ~= nil then
		local ok, itemName, count = Game.AcceptCost.Check(data, info.ItemCostOnAccept)
		if not ok then
			return string.format("Needs %s x%s to accept", tostring(itemName), tostring(count)), false
		end
	end
	local canAdd, onCooldown, blocking = quests.CanAddQuest(LocalPlayer, plan.Key)
	if canAdd == true then
		return nil
	end
	if canAdd == nil then
		return "Requirements not met", false
	end
	if onCooldown == 2 then
		return "Already completed (one-time quest)", false
	end
	if onCooldown == 1 then
		return nil
	end
	if onCooldown == true then
		local cooldown = math.max(quests.QuestCD, info.AcceptCooldown or 0)
		local remaining = cooldown - (Game.Utility.Tick() - data.Quests.LastTime.Value)
		return string.format("Quest cooldown %ds", math.max(math.ceil(remaining), 0)), true
	end
	return "Abandon '" .. tostring(blocking) .. "' first (one " .. plan.Category .. " quest at a time)", false, blocking
end

function QuestRunner.abandon(ctx, name)
	local holder = Game.questHolder()
	local quest = holder and holder:FindFirstChild(name)
	if not quest then
		return true
	end
	ctx:setStatus("Abandoning " .. name)
	Game.fire("RemoveQuest", name)
	return ctx:waitFor(function()
		return quest.Parent == nil
	end, Const.QUEST_ACCEPT_TIMEOUT)
end

function QuestRunner.conflict(key)
	if Game.findActiveQuest(key) then
		return nil
	end
	local ok, canAdd, _, blocking = pcall(Game.Quests.CanAddQuest, LocalPlayer, key, true)
	if ok and canAdd == false and type(blocking) == "string" then
		return blocking
	end
	return nil
end

function QuestRunner.protected(name)
	local holder = Game.questHolder()
	local quest = holder and holder:FindFirstChild(name)
	local questString = quest and quest:FindFirstChild("QuestString")
	local ok, info = pcall(Game.Quests.GetQuestInfo, questString and questString.Value or name)
	local rewards = ok and type(info) == "table" and info.Rewards or nil
	return type(rewards) == "table" and rewards.Power ~= nil
end

function QuestRunner.makeRoom(ctx, key, keep)
	local conflict = QuestRunner.conflict(key)
	if not conflict then
		return true
	end
	if QuestRunner.protected(conflict) or (keep and keep(conflict)) then
		return false, "Finish '" .. conflict .. "' first"
	end
	if not QuestRunner.abandon(ctx, conflict) then
		return false, "Could not abandon '" .. conflict .. "'"
	end
	return true
end

function QuestRunner.clearBlocker(ctx, plan)
	local ok, why = QuestRunner.makeRoom(ctx, plan.Key)
	if not ok then
		return why, false
	end
	return QuestRunner.acceptBlocker(plan)
end

function QuestRunner.accept(ctx, plan)
	local blocker, transient = QuestRunner.clearBlocker(ctx, plan)
	if blocker and not transient then
		return false, blocker
	end
	local giverPosition = Game.npcPosition(plan.Giver)
	if not giverPosition then
		return false, "Quest giver location unknown: " .. tostring(plan.Giver)
	end
	ctx:setStatus("Going to " .. plan.Giver)
	if not ctx:moveTo(giverPosition + Const.NPC_STAND_OFFSET) then
		return false, "Could not reach " .. plan.Giver, true
	end
	while not ctx.Cancelled do
		blocker, transient = QuestRunner.clearBlocker(ctx, plan)
		if not blocker then
			break
		end
		if not transient then
			return false, blocker
		end
		ctx:setStatus(blocker)
		ctx:sleep(1)
	end
	if ctx.Cancelled then
		return false, "Cancelled", true
	end
	if Game.findActiveQuest(plan.Key) then
		return true
	end
	ctx:setStatus("Accepting " .. plan.Name)
	local function accepted()
		return Game.findActiveQuest(plan.Key) ~= nil
	end
	local deadline = os.clock() + Const.QUEST_ACCEPT_TIMEOUT
	repeat
		Game.fire("AddQuest", plan.Key)
		if ctx:waitFor(accepted, Const.QUEST_ACCEPT_REFIRE) then
			return true
		end
	until ctx.Cancelled or os.clock() >= deadline
	if ctx.Cancelled then
		return false, "Cancelled", true
	end
	return false, "Server did not accept " .. plan.Name, true
end

local Steps = {}

function Steps.Kill(ctx, plan, _, planTask)
	Hunt.once(ctx, function(entry)
		return entry.Code == planTask.Code
	end, planTask.Name)
	return true
end

function Steps.Collect(ctx, plan, _, planTask)
	local sources = {}
	for _, code in ipairs(Catalog.ItemSources[planTask.Spec.RequiredItem] or {}) do
		sources[code] = true
	end
	Hunt.once(ctx, function(entry)
		return sources[entry.Code] == true
	end, planTask.Spec.RequiredItem)
	return true
end

function Steps.findPickupPrompt(spec, taskConfig)
	local root = Character.root()
	local best, bestDistance = nil, math.huge
	for _, child in ipairs(Workspace:GetChildren()) do
		if child:IsA("BasePart") or child:IsA("Model") then
			local prompt = child:FindFirstChildWhichIsA("ProximityPrompt", true)
			if prompt and prompt.ActionText == "Pick Up" and prompt.Enabled then
				local position = child:GetPivot().Position
				local matches = false
				if type(spec.Positions) == "table" then
					for index, spot in ipairs(spec.Positions) do
						if taskConfig:GetAttribute("Picked" .. index) ~= true and (spot - position).Magnitude < 4 then
							matches = true
							break
						end
					end
				elseif typeof(spec.Anchor) == "Vector3" then
					matches = (spec.Anchor - position).Magnitude <= (spec.Radius or 25) + 10
				end
				if matches then
					local distance = root and (position - root.Position).Magnitude or 0
					if distance < bestDistance then
						best, bestDistance = { Prompt = prompt, Position = position }, distance
					end
				end
			end
		end
	end
	return best
end

function Steps.Pickup(ctx, plan, activeQuest, planTask, taskConfig)
	local spec = planTask.Spec
	local _, before = QuestRunner.taskValues(activeQuest, planTask.Name)
	local found = Steps.findPickupPrompt(spec, taskConfig)
	if found then
		ctx:setStatus("Picking up " .. planTask.Name)
		if ctx:moveTo(found.Position + Const.GROUND_STAND_OFFSET) then
			Prompts.trigger(found.Prompt, function()
				return ctx.Cancelled
			end)
			ctx:waitFor(function()
				local _, now = QuestRunner.taskValues(activeQuest, planTask.Name)
				return now > before or not activeQuest.Parent
			end, Const.PROGRESS_TIMEOUT)
		end
		return true
	end
	if type(spec.Positions) == "table" then
		for index, spot in ipairs(spec.Positions) do
			if taskConfig:GetAttribute("Picked" .. index) ~= true then
				ctx:setStatus("Picking up " .. planTask.Name .. " #" .. index)
				if ctx:moveTo(spot + Const.GROUND_STAND_OFFSET) then
					Game.fire("QuestProgress", plan.Key, planTask.Name, index)
					ctx:waitFor(function()
						local _, now = QuestRunner.taskValues(activeQuest, planTask.Name)
						return now > before or not activeQuest.Parent
					end, Const.PROGRESS_TIMEOUT)
				end
				return true
			end
		end
	elseif typeof(spec.Anchor) == "Vector3" then
		ctx:setStatus("Waiting for " .. planTask.Name .. " to spawn")
		ctx:moveTo(spec.Anchor + Const.GROUND_STAND_OFFSET)
		ctx:sleep(1)
		return true
	end
	ctx:setStatus("No pickup location for " .. planTask.Name)
	return false
end

function Steps.Deposit(ctx, plan, activeQuest, planTask)
	local spot = planTask.Spec.Position
	local rows = {}
	for name, other in pairs(plan.Tasks) do
		if other.Kind == "Deposit" and other.Spec.Position == spot then
			table.insert(rows, other)
		end
	end
	local function nextRow()
		for _, row in ipairs(rows) do
			local _, value, maximum = QuestRunner.taskValues(activeQuest, row.Name)
			if value < maximum and Game.itemCount(row.Spec.RequiredItem) > 0 then
				return row
			end
		end
		return nil
	end
	if not nextRow() then
		local missing = {}
		for _, row in ipairs(rows) do
			local _, value, maximum = QuestRunner.taskValues(activeQuest, row.Name)
			if value < maximum then
				table.insert(missing, string.format("%s x%d", row.Spec.RequiredItem, maximum - value))
			end
		end
		ctx:setStatus("Needs " .. table.concat(missing, ", "))
		return false
	end
	ctx:setStatus("Stocking for " .. plan.Name)
	if not ctx:moveTo(spot + Const.GROUND_STAND_OFFSET) then
		return true
	end
	while not ctx.Cancelled and activeQuest.Parent do
		local row = nextRow()
		if not row then
			break
		end
		Game.fire("QuestProgress", plan.Key, row.Name)
		ctx:sleep(Const.DEPOSIT_INTERVAL)
	end
	return true
end

function Steps.Deliver(ctx, plan, activeQuest, planTask)
	local spec = planTask.Spec
	if type(spec.RequiredItem) == "string" then
		local _, _, maximum = QuestRunner.taskValues(activeQuest, planTask.Name)
		local needed = spec.Count or math.max(maximum, 1)
		local held = Game.itemCount(spec.RequiredItem)
		if held < needed then
			ctx:setStatus(string.format("Needs %s x%d for %s", spec.RequiredItem, needed - held, planTask.Name))
			return false
		end
	end
	local npcPosition = Game.npcPosition(spec.TargetNpc)
	if not npcPosition then
		ctx:setStatus("NPC location unknown: " .. spec.TargetNpc)
		return false
	end
	ctx:setStatus("Talking to " .. spec.TargetNpc)
	local _, before = QuestRunner.taskValues(activeQuest, planTask.Name)
	if ctx:moveTo(npcPosition + Const.NPC_STAND_OFFSET) then
		Game.fire("QuestProgress", plan.Key, planTask.Name)
		ctx:waitFor(function()
			local _, now = QuestRunner.taskValues(activeQuest, planTask.Name)
			return now > before or not activeQuest.Parent
		end, Const.PROGRESS_TIMEOUT)
	end
	return true
end

function QuestRunner.progress(ctx, plan, activeQuest)
	while not ctx.Cancelled and activeQuest.Parent do
		if Hunt.hold(ctx) then
			continue
		end
		local planTask, taskConfig, waiting = QuestRunner.nextTask(plan, activeQuest)
		if not planTask then
			if waiting then
				ctx:setStatus("Waiting on " .. waiting.Name)
			else
				ctx:setStatus("Completing " .. plan.Name)
			end
			if ctx:waitFor(function()
				return activeQuest.Parent == nil
			end, 3) then
				return true
			end
			return false
		end
		local step = Steps[planTask.Kind]
		if not step or not step(ctx, plan, activeQuest, planTask, taskConfig) then
			return false
		end
	end
	return activeQuest.Parent == nil
end

function QuestRunner.cycle(ctx, plan)
	local active = Game.findActiveQuest(plan.Key)
	if not active then
		local ok, reason, transient = QuestRunner.accept(ctx, plan)
		if not ok then
			return false, reason, transient
		end
		active = Game.findActiveQuest(plan.Key)
		if not active then
			return false, "Quest not found after accepting", true
		end
	end
	if QuestRunner.progress(ctx, plan, active) then
		ctx:setStatus("Completed " .. plan.Name)
		return true
	end
	return false, ctx.Status, true
end

local LevelUp = {}

function LevelUp.active()
	local holder = Game.questHolder()
	if not holder then
		return nil
	end
	for _, quest in ipairs(holder:GetChildren()) do
		local questString = quest:FindFirstChild("QuestString")
		local plan = questString and Catalog.QuestByKey[questString.Value]
		if plan and plan.Category == "Combat" then
			return plan
		end
	end
	return nil
end

function LevelUp.eligible(plan)
	if Game.findActiveQuest(plan.Key) then
		return true
	end
	local ok, canAdd, onCooldown, blocking = pcall(Game.Quests.CanAddQuest, LocalPlayer, plan.Key, true)
	return ok and (canAdd == true or (canAdd == false and onCooldown == false and type(blocking) == "string"))
end

function LevelUp.pick()
	local active = LevelUp.active()
	local root = Character.root()
	local best, bestDistance = nil, math.huge
	for _, plan in ipairs(Catalog.Quests) do
		local info = plan.Info
		local rewards = type(info.Rewards) == "table" and info.Rewards or nil
		if plan.Supported and plan.Giver and info.NoSave ~= true and (rewards == nil or rewards.Power == nil) and plan.Category == "Combat" then
			if LevelUp.eligible(plan) then
				local npc = Game.npcPosition(plan.Giver)
				local distance = (root and npc) and (npc - root.Position).Magnitude or math.huge
				local better
				if best == nil or best.Level < plan.Level then
					better = true
				elseif plan.Level == best.Level then
					better = distance < bestDistance
				else
					better = false
				end
				if better then
					best, bestDistance = plan, distance
				end
			end
		end
	end
	if active and active.Supported and (not best or active.Level >= best.Level) then
		return active
	end
	if not best then
		return nil, "No eligible combat quest for level " .. Game.level()
	end
	return best
end

local Farm = { Thread = nil, Context = nil, Signature = nil, Status = "Idle" }

function Farm.selectedMobs()
	local selected = {}
	for _, label in ipairs(Settings.Mobs) do
		local mob = Catalog.MobByOption[label]
		if mob then
			selected[mob] = true
		end
	end
	return selected
end

function Farm.mobTick(ctx)
	Priority.bind(ctx, "Mobs")
	local selected = Farm.selectedMobs()
	if next(selected) == nil then
		Priority.set(ctx, nil)
		ctx:setStatus("No mobs selected")
		ctx:sleep(1)
		return
	end
	Priority.set(ctx, "Want")
	Hunt.once(ctx, function(entry)
		return selected[entry] == true
	end)
end

function Farm.fallback(ctx, seconds)
	if Settings.MobFarm then
		Farm.mobTick(ctx)
		return
	end
	Priority.set(ctx, nil)
	ctx:sleep(seconds)
end

function Farm.questLoop(ctx, choosePlan)
	while not ctx.Cancelled do
		local plan, reason = choosePlan()
		if Heal.Retreating or Escape.Active then
			ctx:setStatus(Escape.Active and "Paused, retreating" or "Paused to heal")
			ctx:sleep(0.5)
		elseif not plan then
			ctx:setStatus(reason or "No quest selected")
			Farm.fallback(ctx, 2)
		else
			Priority.bind(ctx, "Quests")
			Priority.set(ctx, "Want")
			if not Hunt.hold(ctx) then
				local ok, why, transient = QuestRunner.cycle(ctx, plan)
				if not ok then
					ctx:setStatus(why or "Waiting")
					if transient then
						ctx:sleep(1)
					else
						Farm.fallback(ctx, 3)
					end
				end
			end
		end
	end
end

function Farm.mode()
	if Settings.LevelUp then
		return "LevelUp"
	elseif Settings.AutoQuest and Settings.Quest then
		return "Quest"
	elseif Settings.MobFarm then
		return "Mobs"
	end
	return nil
end

function Farm.run(ctx, mode)
	if mode == "LevelUp" then
		Farm.questLoop(ctx, LevelUp.pick)
	elseif mode == "Quest" then
		Farm.questLoop(ctx, function()
			local plan = Catalog.QuestByOption[Settings.Quest]
			if not plan then
				return nil, "Pick a quest"
			end
			return plan
		end)
	else
		while not ctx.Cancelled do
			Farm.mobTick(ctx)
		end
	end
end

function Farm.stop()
	local ctx = Farm.Context
	local thread = Farm.Thread
	Farm.Context = nil
	Farm.Thread = nil
	Farm.Signature = nil
	if ctx then
		ctx.Cancelled = true
		Priority.release(ctx)
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
	Combat.FarmTarget = nil
	Farm.Status = "Idle"
end

function Farm.refresh()
	local mode = Farm.mode()
	local signature = mode and (mode == "Quest" and (mode .. "\0" .. tostring(Settings.Quest)) or mode) or nil
	if signature == Farm.Signature then
		return
	end
	Farm.stop()
	if not mode then
		return
	end
	local ctx = Context.new(Mover.acquire("farm", 10))
	Priority.bind(ctx, mode == "Mobs" and "Mobs" or "Quests")
	Farm.Context = ctx
	Farm.Signature = signature
	Farm.Thread = task.spawn(function()
		local ok, err = pcall(Farm.run, ctx, mode)
		if not ok and not ctx.Cancelled then
			warn("[Spryzen Hub] farm error: " .. tostring(err))
			ctx:setStatus("Error: " .. tostring(err))
		end
		Combat.FarmTarget = nil
		ctx.Lease:SetGoal(nil)
	end)
end

function Farm.statusText()
	local ctx = Farm.Context
	if not ctx then
		return "Idle"
	end
	return ctx.Status
end

local Dungeon = { Thread = nil, Context = nil, IdleSince = nil, Resetting = false, ChestOpens = 0, ChestFails = 0, ChestWaitSince = nil, ShopsSince = nil, BuyRetryAt = {}, ChestRetryAt = 0, SkipVotedFor = nil, RerollHand = nil, RerollSentAt = 0, RerollFailed = nil, Rerolls = 0, CardHand = nil, CardSignature = nil, CardSentAt = 0, CardStatus = "Off", BoughtRun = {}, BringStatus = "Off", Progress = nil, RerollStreak = 0 }

Dungeon.STAT_LABELS = {
	["Additional Damage"] = "Damage",
	["Additional Damage Factor"] = "Damage",
	["Max Health"] = "Health",
	["Attack Speed Factor"] = "Attack Speed",
	["Damage Reduction Factor"] = "Damage Reduction",
	["Cooldown Reduction Factor"] = "Cooldown Reduction",
	["Movement Speed Factor"] = "Move Speed",
	["Max Stamina"] = "Max Stamina",
	["Stamina Regen Speed"] = "Stamina Regen",
	["Block Points"] = "Block Points",
}
Dungeon.StatOptions = { "Damage", "Health", "Attack Speed", "Damage Reduction", "Cooldown Reduction", "Move Speed", "Max Stamina", "Stamina Regen", "Block Points" }
Dungeon.CardOptions = {}
Dungeon.CARD_TYPES = {
	Stat = "Stat",
	Skill = "Skill",
	SkillSwap = "Skill Swap",
	Weapon = "Weapon",
	Trade = "Trade",
	Forge = "Forge",
	Clan = "Clan",
	AscendClan = "Ascend Clan",
	Potion = "Potion",
	Points = "Points",
	Event = "Event",
	Fortune = "Fortune",
	Heal = "Full Heal",
	ExtraLife = "Extra Life",
	Revive = "Revive",
	Reroll = "Reroll",
	SwapMap = "Swap Map",
	SkipFloor = "Skip Floor",
	Skip = "No Event",
}
Dungeon.WEAPONS = { "Axe and Mace", "Bladed Wagasa", "Claws", "Cutlass", "Gauntlet", "Scythe", "Shotgun", "Sickles", "Spear", "Tanto", "War Fans" }
Dungeon.POTIONS = { "Health Potion", "Health Elixir" }
Dungeon.TROPHIES = { "Trophy", "Fine Trophy", "Greater Trophy", "Grand Trophy", "Supreme Trophy" }
Dungeon.ShopOptions = {}
Dungeon.ShopPrices = {}

if Hub.InDungeon then
	local tower = ReplicatedStorage:FindFirstChild("Minigames Place")
	tower = tower and tower:FindFirstChild("Minigames")
	tower = tower and tower:FindFirstChild("Ouwigahara")
	local events = tower and tower:FindFirstChild("Events")
	local ok, result = pcall(require, events)
	Dungeon.Events = ok and type(result) == "table" and result or nil
	local seen = {}
	local function addCard(kind, detail)
		local name = Dungeon.CARD_TYPES[kind] .. (detail and (": " .. detail) or "")
		if not seen[name] then
			seen[name] = true
			table.insert(Dungeon.CardOptions, name)
		end
	end
	local function addNamed(kind, names)
		for _, name in ipairs(names) do
			addCard(kind, name)
		end
	end
	for _, kind in ipairs({ "Fortune", "Heal", "ExtraLife", "Revive", "Reroll", "SwapMap", "SkipFloor", "Skip" }) do
		addCard(kind)
	end
	addNamed("Stat", Dungeon.StatOptions)
	addNamed("Weapon", Dungeon.WEAPONS)
	addNamed("Trade", Dungeon.WEAPONS)
	addNamed("Potion", Dungeon.POTIONS)
	addNamed("Points", Dungeon.TROPHIES)
	for _, name in ipairs(Dungeon.Events and Dungeon.Events.Names or {}) do
		local info = Dungeon.Events.Types[name]
		addCard("Event", type(info) == "table" and info.Title or name)
	end
	local skills = {}
	local okPower, customPower = pcall(require, ReplicatedStorage.CAM.Global.CustomPower)
	if okPower and type(customPower) == "table" and type(customPower.SOURCES) == "table" then
		for _, source in pairs(customPower.SOURCES) do
			for _, power in pairs(source) do
				if type(power) == "table" and power[customPower.MARKER] ~= true and type(power.Skills) == "table" then
					for _, skill in pairs(power.Skills) do
						if type(skill) == "table" and type(skill.Name) == "string" and skill.Name ~= "Blocking" then
							table.insert(skills, skill.Name)
						end
					end
				end
			end
		end
	end
	local function walkSkills(node, depth)
		if depth > 4 then
			return
		end
		for _, value in pairs(node) do
			if type(value) == "table" then
				if type(value.Name) == "string" and value.Name ~= "Blocking" then
					table.insert(skills, value.Name)
				end
				walkSkills(value, depth + 1)
			end
		end
	end
	if type(Game.ClanSkills.SkillSets) == "table" then
		walkSkills(Game.ClanSkills.SkillSets, 0)
	end
	table.sort(skills)
	addNamed("Skill", skills)
	addNamed("SkillSwap", skills)
	local clans = {}
	local okClans, clanModule = pcall(require, ReplicatedStorage.CAM.Clans)
	if okClans and type(clanModule) == "table" and type(clanModule.Rarities) == "table" then
		for _, rarity in pairs(clanModule.Rarities) do
			for clan in pairs(clanModule.GetByRarity(rarity.rarity) or {}) do
				table.insert(clans, clan)
			end
		end
	end
	table.sort(clans)
	addNamed("Clan", clans)
	addNamed("AscendClan", clans)
	local forge = {}
	local okRefine, refinement = pcall(require, ReplicatedStorage.CAM.Global.Refinement)
	for name, info in pairs(Game.Items) do
		if okRefine and type(info) == "table" and info.HasCombat == true then
			local okCheck, refinable = pcall(refinement.IsRefinable, name)
			if okCheck and refinable then
				table.insert(forge, name)
			end
		end
	end
	table.sort(forge)
	addNamed("Forge", forge)
	table.sort(Dungeon.CardOptions)
	for name, listing in pairs(Game.Shop.itemsforsale or {}) do
		if type(name) == "string" and type(listing) == "table" and type(listing.Price) == "table" and tonumber(listing.Price.RunPoints) then
			Dungeon.ShopPrices[name] = tonumber(listing.Price.RunPoints)
			table.insert(Dungeon.ShopOptions, name)
		end
	end
	table.sort(Dungeon.ShopOptions, function(a, b)
		if Dungeon.ShopPrices[a] ~= Dungeon.ShopPrices[b] then
			return Dungeon.ShopPrices[a] > Dungeon.ShopPrices[b]
		end
		return a < b
	end)
end

function Dungeon.intermission()
	return ReplicatedStorage:FindFirstChild("Intermission")
end

function Dungeon.phase()
	local intermission = Dungeon.intermission()
	return intermission and intermission:GetAttribute("Phase") or Workspace:GetAttribute("MinigameState")
end

function Dungeon.countdown()
	local intermission = Dungeon.intermission()
	local started = intermission and tonumber(intermission:GetAttribute("Countdown"))
	local target = intermission and tonumber(intermission:GetAttribute("Target"))
	if not started or not target then
		return nil
	end
	return math.max(math.ceil(target - (Workspace:GetServerTimeNow() - started)), 0)
end

function Dungeon.hearts()
	return tonumber(LocalPlayer:GetAttribute("Hearts")) or 0
end

function Dungeon.points()
	return tonumber(LocalPlayer:GetAttribute("RunPoints")) or 0
end

function Dungeon.canSpend()
	return LocalPlayer:GetAttribute("SaveDisabled") ~= true and LocalPlayer:GetAttribute("SaveDisabledSlot") ~= true
end

function Dungeon.padPrompt(container, padName, promptName)
	local map = Workspace:FindFirstChild("Map")
	local area = map and map:FindFirstChild(container)
	local pad = area and area:FindFirstChild(padName, true)
	if not (pad and pad:IsA("BasePart")) then
		return nil
	end
	local prompt = promptName and pad:FindFirstChild(promptName) or pad:FindFirstChildWhichIsA("ProximityPrompt")
	if prompt and prompt:IsA("ProximityPrompt") then
		return prompt, pad
	end
	return nil
end

function Dungeon.usePad(ctx, prompt, pad)
	if not ctx:moveTo(pad.Position + Vector3.new(0, pad.Size.Y / 2 + Const.SPAWN_WAIT_HEIGHT, 0)) then
		return false
	end
	local cancelled = function()
		return ctx.Cancelled
	end
	Prompts.waitShown(prompt, Const.DUNGEON_PROMPT_SHOWN, cancelled)
	return not ctx.Cancelled and Prompts.trigger(prompt, cancelled)
end

function Dungeon.readyUp(ctx)
	local prompt, pad = Dungeon.padPrompt("Minigame Map", "StartPad", "ReadyUp")
	if not prompt then
		ctx:setStatus("Waiting for the ready pad to load")
		ctx:sleep(1)
		return
	end
	if not prompt.Enabled then
		ctx:setStatus("Ready pad is disabled")
		ctx:sleep(1)
		return
	end
	ctx:setStatus("Readying up")
	if Dungeon.usePad(ctx, prompt, pad) then
		ctx:waitFor(function()
			return LocalPlayer:GetAttribute("Readied") == true
		end, Const.DUNGEON_READY_CONFIRM)
	end
	ctx.Lease:SetGoal(nil)
end

function Dungeon.enemyPad()
	local spawns = Workspace:FindFirstChild("Debree") and Workspace.Debree:FindFirstChild("Spawns")
	local pads = spawns and spawns:FindFirstChild("DungeonEnemies")
	local root = Character.root()
	if not pads or not root then
		return nil
	end
	local best, bestDistance = nil, math.huge
	for _, pad in ipairs(pads:GetChildren()) do
		if pad:IsA("BasePart") then
			local distance = (pad.Position - root.Position).Magnitude
			if distance < bestDistance then
				best, bestDistance = pad, distance
			end
		end
	end
	return best
end

function Dungeon.fight(ctx)
	for model, at in pairs(ctx.Skip) do
		if os.clock() - at > Const.SKIP_TARGET_FOR or not model.Parent then
			ctx.Skip[model] = nil
		end
	end
	if Heal.Retreating or Escape.Active then
		ctx:setStatus(Escape.Active and "Paused, retreating" or "Paused to heal")
		ctx:sleep(0.5)
		return
	end
	local model = Mobs.nearest(function(candidate)
		return ctx.Skip[candidate] == nil
	end, Settings.DungeonRange > 0 and Settings.DungeonRange or nil)
	local floor = Workspace:GetAttribute("MinigameFloor")
	local floorText = floor and ("Floor " .. floor) or "Climbing"
	if model then
		Dungeon.IdleSince = nil
		ctx:setStatus(floorText .. ", fighting " .. model.Name)
		Hunt.engage(ctx, model)
		return
	end
	local breakUntil = tonumber(Workspace:GetAttribute("MinigameWaveBreak"))
	if breakUntil then
		Dungeon.IdleSince = nil
		ctx:setStatus(floorText .. " cleared, next floor in " .. math.max(math.ceil(breakUntil - Workspace:GetServerTimeNow()), 0) .. "s")
		ctx:sleep(0.5)
		return
	end
	local left = Workspace:GetAttribute("MinigameEnemiesLeft")
	ctx:setStatus(floorText .. ", waiting for enemies" .. (left and (", " .. left .. " left") or ""))
	Dungeon.IdleSince = Dungeon.IdleSince or os.clock()
	if left and left > 0 and os.clock() - Dungeon.IdleSince > Const.DUNGEON_SEARCH_AFTER then
		local pad = Dungeon.enemyPad()
		if pad then
			Dungeon.IdleSince = os.clock()
			ctx:moveTo(pad.Position + Vector3.new(0, pad.Size.Y / 2 + Const.SPAWN_WAIT_HEIGHT, 0))
		end
	end
	ctx:sleep(0.25)
end

function Dungeon.resetDue()
	if Dungeon.phase() ~= "Climbing" then
		return false
	end
	if Settings.AutoResetPoints and Dungeon.points() >= Settings.ResetPoints then
		return true
	end
	local floor = tonumber(Workspace:GetAttribute("MinigameFloor"))
	return Settings.AutoResetFloor and floor ~= nil and floor >= Settings.ResetFloor
end

function Dungeon.stalled()
	if not Settings.StallGuard or Dungeon.phase() ~= "Climbing" or Dungeon.hearts() <= 0 then
		Dungeon.Progress = nil
		return false
	end
	local mark = table.concat({
		tostring(Workspace:GetAttribute("MinigameFloor")),
		tostring(Workspace:GetAttribute("MinigameEnemiesLeft")),
		tostring(Workspace:GetAttribute("MinigameWaveBreak") ~= nil),
		tostring(Dungeon.points()),
	}, "\0")
	local progress = Dungeon.Progress
	if not progress or progress.Mark ~= mark then
		Dungeon.Progress = { Mark = mark, At = os.clock() }
		return false
	end
	return os.clock() - progress.At >= Settings.StallAfter
end

function Dungeon.bringStep()
	if not Settings.BringEnemies or Dungeon.phase() ~= "Climbing" then
		Dungeon.BringStatus = Settings.BringEnemies and "Waiting for the climb" or "Off"
		return
	end
	if type(isnetworkowner) ~= "function" then
		Dungeon.BringStatus = "Executor has no isnetworkowner"
		return
	end
	local root = Character.root()
	if not root or not Character.alive() or Escape.Active or Heal.Retreating then
		Dungeon.BringStatus = "Paused"
		return
	end
	local spot = root.CFrame * CFrame.new(0, 0, -Settings.Distance - 1)
	local moved = 0
	Mobs.eachDungeonEnemy(function(_, mobRoot)
		if Settings.BringRange <= 0 or (mobRoot.Position - root.Position).Magnitude <= Settings.BringRange then
			local ok, owned = pcall(isnetworkowner, mobRoot)
			if ok and owned then
				mobRoot.CFrame = spot
				mobRoot.AssemblyLinearVelocity = Vector3.zero
				mobRoot.AssemblyAngularVelocity = Vector3.zero
				moved += 1
			end
		end
	end)
	Dungeon.BringStatus = moved > 0 and ("Holding " .. moved .. (moved == 1 and " enemy" or " enemies")) or "No owned enemies in range"
end

function Dungeon.reset(ctx)
	Combat.FarmTarget = nil
	ctx.Lease:SetGoal(nil)
	if LocalPlayer:GetAttribute("Spectating") == true then
		ctx:setStatus("Resetting, giving up")
		Game.fire("OuwigaharaRequest", { action = "GiveUp" })
		ctx:waitFor(function()
			return LocalPlayer:GetAttribute("InShops") == true
		end, Const.DUNGEON_GIVE_UP_CONFIRM)
		return
	end
	local humanoid = Character.humanoid()
	if humanoid and humanoid.Health > 0 then
		ctx:setStatus("Resetting, " .. Dungeon.hearts() .. " lives left")
		humanoid.Health = 0
	else
		ctx:setStatus("Resetting, waiting for respawn")
	end
	ctx:sleep(Const.DUNGEON_RESET_GAP)
end

function Dungeon.chests(wanted)
	local list = {}
	for guid, model in pairs(Collector.chestModels()) do
		local id = model:GetAttribute("ChestId")
		if wanted(id) and not Collector.modelOpen(model) then
			table.insert(list, { Model = model, Guid = guid, Id = id })
		end
	end
	return list
end

function Dungeon.openChest(ctx, chest)
	local candidate = { Kind = "Chest", Key = chest.Guid, Instance = chest.Model }
	local claimed = function()
		return ctx.Cancelled or Collector.claimed(candidate)
	end
	if not ctx:moveTo(chest.Model:GetPivot().Position + Const.GROUND_STAND_OFFSET) then
		return false
	end
	local prompt = Collector.prompt(candidate)
	if not (prompt and prompt.Enabled) then
		return false
	end
	Prompts.waitShown(prompt, Const.DUNGEON_PROMPT_SHOWN, claimed)
	Prompts.trigger(prompt, claimed)
	return ctx:waitFor(claimed, Const.DUNGEON_CHEST_CONFIRM) and not ctx.Cancelled
end

function Dungeon.cacheStep(ctx)
	if not Settings.AutoCaches then
		return false
	end
	local caches = Dungeon.chests(function(id)
		return id == "Ouwigahara Cache" or id == "Ouwigahara Deep Cache"
	end)
	local chest = caches[1]
	if not chest then
		return false
	end
	ctx:setStatus("Opening " .. tostring(chest.Id))
	Dungeon.openChest(ctx, chest)
	return true
end

function Dungeon.chestWanted()
	if not Settings.AutoChest or not Dungeon.canSpend() or Dungeon.ChestFails >= Const.DUNGEON_CHEST_ATTEMPTS then
		return false
	end
	if Settings.ChestTimes > 0 and Dungeon.ChestOpens >= Settings.ChestTimes then
		return false
	end
	return Dungeon.points() >= Const.DUNGEON_CHEST_PRICE
end

function Dungeon.chestStep(ctx)
	if not Dungeon.chestWanted() then
		Dungeon.ChestWaitSince = nil
		return false
	end
	Dungeon.ChestWaitSince = Dungeon.ChestWaitSince or os.clock()
	local chest = Dungeon.chests(function(id)
		return id == Const.DUNGEON_CHEST
	end)[1]
	if not chest or os.clock() < Dungeon.ChestRetryAt then
		if os.clock() - Dungeon.ChestWaitSince > Const.DUNGEON_CHEST_WAIT then
			return false
		end
		ctx:setStatus(chest and ("Retrying " .. Const.DUNGEON_CHEST) or ("Waiting for the " .. Const.DUNGEON_CHEST))
		ctx:sleep(0.5)
		return true
	end
	local before = Dungeon.points()
	ctx:setStatus("Opening " .. Const.DUNGEON_CHEST)
	Dungeon.openChest(ctx, chest)
	local spent = ctx:waitFor(function()
		return Dungeon.points() < before
	end, Const.DUNGEON_BUY_CONFIRM)
	if spent then
		Dungeon.ChestOpens += 1
		Dungeon.ChestFails = 0
	else
		Dungeon.ChestFails += 1
		Dungeon.ChestRetryAt = os.clock() + Const.DUNGEON_CHEST_RETRY
	end
	Dungeon.ChestWaitSince = nil
	return true
end

function Dungeon.buyStep(ctx)
	if not Settings.AutoBuy or not Dungeon.canSpend() then
		return false
	end
	local points = Dungeon.points()
	for _, name in ipairs(Dungeon.buyList()) do
		local price = Dungeon.ShopPrices[name]
		local bought = Dungeon.BoughtRun[name] or 0
		local left = Settings.BuyEachMax > 0 and Settings.BuyEachMax - bought or Const.DUNGEON_MAX_BUY
		local count = price and math.min(math.floor(points / price), left, Const.DUNGEON_MAX_BUY) or 0
		if count > 0 and os.clock() >= (Dungeon.BuyRetryAt[name] or 0) then
			local okCheck, canBuy = pcall(Game.call, Game.Shop.CanBuy, LocalPlayer, name, nil, count)
			if not (okCheck and canBuy == true) and count > 1 then
				count = 1
				okCheck, canBuy = pcall(Game.call, Game.Shop.CanBuy, LocalPlayer, name, nil, 1)
			end
			if okCheck and canBuy == true then
				ctx:setStatus("Buying " .. count .. "x " .. name)
				pcall(Game.SignalFunction.ToServer, "PurchaseFromShop", name, count)
				if ctx:waitFor(function()
					return Dungeon.points() < points
				end, Const.DUNGEON_BUY_CONFIRM) then
					Dungeon.BoughtRun[name] = bought + math.max(math.floor((points - Dungeon.points()) / price + 0.5), 1)
				else
					Dungeon.BuyRetryAt[name] = os.clock() + Const.DUNGEON_BUY_RETRY
				end
				return true
			end
			Dungeon.BuyRetryAt[name] = os.clock() + Const.DUNGEON_BUY_RETRY
		end
	end
	return false
end

function Dungeon.buyList()
	local list = #Settings.BuyItems > 0 and table.clone(Settings.BuyItems) or table.clone(Dungeon.ShopOptions)
	if Settings.BuyOrder == "Selection Order" and #Settings.BuyItems > 0 then
		return list
	end
	local cheapest = Settings.BuyOrder == "Cheapest First"
	table.sort(list, function(a, b)
		local priceA, priceB = Dungeon.ShopPrices[a] or 0, Dungeon.ShopPrices[b] or 0
		if priceA ~= priceB then
			if cheapest then
				return priceA < priceB
			end
			return priceA > priceB
		end
		return a < b
	end)
	return list
end

function Dungeon.leaveStep(ctx)
	if not Settings.AutoLeave then
		return false
	end
	Dungeon.ShopsSince = Dungeon.ShopsSince or os.clock()
	local left = Settings.LeaveDelay - (os.clock() - Dungeon.ShopsSince)
	if left > 0 then
		ctx:setStatus("Leaving in " .. math.ceil(left) .. "s")
		ctx:sleep(0.25)
		return true
	end
	local prompt, pad = Dungeon.padPrompt("Shops", "LeavePad")
	if not prompt then
		ctx:setStatus("Waiting for the leave pad to load")
		ctx:sleep(1)
		return true
	end
	ctx:setStatus("Leaving the tower")
	Dungeon.usePad(ctx, prompt, pad)
	ctx:sleep(Const.DUNGEON_LEAVE_WAIT)
	return true
end

function Dungeon.shops(ctx)
	Dungeon.Resetting = false
	if Dungeon.cacheStep(ctx) or Dungeon.chestStep(ctx) or Dungeon.buyStep(ctx) then
		Dungeon.ShopsSince = nil
		return
	end
	ctx.Lease:SetGoal(nil)
	if Dungeon.leaveStep(ctx) then
		return
	end
	ctx:setStatus("Run over, in the shops")
	ctx:sleep(1)
end

function Dungeon.step(ctx)
	local phase = Dungeon.phase()
	if LocalPlayer:GetAttribute("InShops") == true then
		if Character.alive() then
			Dungeon.shops(ctx)
		else
			ctx:setStatus("Waiting for respawn")
			ctx:sleep(1)
		end
		return
	end
	Dungeon.ShopsSince = nil
	Dungeon.ChestWaitSince = nil
	Dungeon.ChestFails = 0
	Dungeon.ChestRetryAt = 0
	table.clear(Dungeon.BoughtRun)
	if phase ~= "Climbing" then
		Dungeon.Resetting = false
		Dungeon.Progress = nil
	elseif Dungeon.Resetting or Dungeon.resetDue() or Dungeon.stalled() then
		Dungeon.Resetting = true
		Dungeon.reset(ctx)
		return
	end
	if not Settings.AutoDungeon then
		ctx:setStatus("Idle")
		ctx:sleep(0.5)
		return
	end
	if not Character.alive() then
		ctx:setStatus("Waiting for respawn")
		ctx:sleep(1)
	elseif LocalPlayer:GetAttribute("Spectating") == true then
		ctx:setStatus("Out of lives, spectating")
		ctx:sleep(1)
	elseif phase == "Lobby" or phase == "Starting" then
		Dungeon.IdleSince = nil
		if LocalPlayer:GetAttribute("Readied") == true then
			local left = Dungeon.countdown()
			ctx:setStatus("Ready, climb starts" .. (left and (" in " .. left .. "s") or " soon"))
			ctx:sleep(0.5)
		else
			Dungeon.readyUp(ctx)
		end
	elseif phase == "Climbing" then
		if Dungeon.hearts() <= 0 then
			ctx:setStatus("Waiting to join the climb")
			ctx:sleep(1)
		else
			Dungeon.fight(ctx)
		end
	else
		ctx:setStatus("Waiting, phase " .. tostring(phase))
		ctx:sleep(1)
	end
end

function Dungeon.wanted()
	return Settings.AutoDungeon or Settings.AutoResetPoints or Settings.AutoResetFloor or Settings.StallGuard or Settings.AutoCaches or Settings.AutoChest or Settings.AutoBuy or Settings.AutoLeave
end

function Dungeon.stop()
	local ctx = Dungeon.Context
	local thread = Dungeon.Thread
	Dungeon.Context = nil
	Dungeon.Thread = nil
	Dungeon.IdleSince = nil
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
	Combat.FarmTarget = nil
end

function Dungeon.refresh()
	if not Hub.InDungeon or not Dungeon.wanted() then
		Dungeon.stop()
		return
	end
	if Dungeon.Context then
		return
	end
	local ctx = Context.new(Mover.acquire("dungeon", 10))
	Dungeon.Context = ctx
	Dungeon.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(Dungeon.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] auto dungeon error: " .. tostring(err))
				ctx:setStatus("Error, see console")
				Combat.FarmTarget = nil
				ctx.Lease:SetGoal(nil)
				ctx:sleep(2)
			end
		end
	end)
end

function Dungeon.statusText()
	local ctx = Dungeon.Context
	if not ctx then
		return "Off", "Muted"
	end
	return ctx.Status, "Success"
end

function Dungeon.cardName(card)
	local kind = card:GetAttribute("Type")
	local title = tostring(card:GetAttribute("Title") or "")
	local detail = nil
	if kind == "Event" then
		local info = Dungeon.Events and Dungeon.Events.Types[tostring(card:GetAttribute("Event"))]
		detail = type(info) == "table" and info.Title or title
	elseif kind == "Stat" then
		detail = Dungeon.STAT_LABELS[tostring(card:GetAttribute("Stat"))]
	elseif kind == "Skill" or kind == "SkillSwap" then
		detail = card:GetAttribute("Skill")
	elseif kind == "Weapon" or kind == "Trade" then
		detail = card:GetAttribute("Weapon")
	elseif kind == "Forge" or kind == "Potion" then
		detail = card:GetAttribute("Item")
	elseif kind == "Clan" or kind == "AscendClan" then
		detail = card:GetAttribute("Clan")
	elseif kind == "Points" then
		detail = string.match(title, "^(.-) %+")
	end
	local label = Dungeon.CARD_TYPES[kind] or tostring(kind)
	return detail and (label .. ": " .. tostring(detail)) or label
end

function Dungeon.isCurse(card)
	if card:GetAttribute("Type") ~= "Event" or not Dungeon.Events then
		return false
	end
	local info = Dungeon.Events.Types[tostring(card:GetAttribute("Event"))]
	return type(info) == "table" and info.Score ~= nil
end

function Dungeon.statRank(card)
	if card:GetAttribute("Type") ~= "Stat" then
		return math.huge
	end
	local label = Dungeon.STAT_LABELS[tostring(card:GetAttribute("Stat"))]
	return label and table.find(Settings.CardPriority, label) or math.huge
end

function Dungeon.cardPoints(card)
	if card:GetAttribute("Type") ~= "Points" then
		return nil
	end
	local digits = string.match(tostring(card:GetAttribute("Title") or ""), "%+%s*([%d,]+)%s*$")
	if not digits then
		return nil
	end
	local plain = string.gsub(digits, ",", "")
	return tonumber(plain)
end

function Dungeon.neverPick(card)
	return table.find(Settings.NeverPick, Dungeon.cardName(card)) ~= nil
end

function Dungeon.softBlocked(card)
	local kind = card:GetAttribute("Type")
	return (Settings.AvoidCurse and Dungeon.isCurse(card)) or (Settings.SkipPointCards and (kind == "Points" or kind == "Fortune"))
end

function Dungeon.bestCard(cards)
	local best = nil
	local function better(a, b)
		local skipA, skipB = a:GetAttribute("Type") == "Skip", b:GetAttribute("Type") == "Skip"
		if skipA ~= skipB then
			return skipB
		end
		local rarityA, rarityB = tonumber(a:GetAttribute("Rarity")) or 1, tonumber(b:GetAttribute("Rarity")) or 1
		if rarityA ~= rarityB then
			return rarityA > rarityB
		end
		local rankA, rankB = Dungeon.statRank(a), Dungeon.statRank(b)
		if rankA ~= rankB then
			return rankA < rankB
		end
		return a.Name < b.Name
	end
	for _, card in ipairs(cards) do
		if best == nil or better(card, best) then
			best = card
		end
	end
	return best
end

function Dungeon.handCards(hand)
	local cards = {}
	for _, card in ipairs(hand:GetChildren()) do
		if card:GetAttribute("Type") ~= nil then
			table.insert(cards, card)
		end
	end
	return cards
end

function Dungeon.chooseCard(hand)
	local cards = Dungeon.handCards(hand)
	if #cards == 0 then
		return nil
	end
	local pickable, allowed = {}, {}
	for _, card in ipairs(cards) do
		if not Dungeon.neverPick(card) then
			table.insert(pickable, card)
			if not Dungeon.softBlocked(card) then
				table.insert(allowed, card)
			end
		end
	end
	local humanoid = Character.humanoid()
	if humanoid and humanoid.MaxHealth > 0 and humanoid.Health / humanoid.MaxHealth * 100 < Settings.HealBelow then
		for _, card in ipairs(pickable) do
			if card:GetAttribute("Type") == "Heal" then
				return card, "heal"
			end
		end
	end
	if Settings.ExtraLifeAt > 0 and Dungeon.hearts() <= Settings.ExtraLifeAt then
		for _, card in ipairs(pickable) do
			if card:GetAttribute("Type") == "ExtraLife" then
				return card, "life"
			end
		end
	end
	for _, name in ipairs(Settings.PickFirst) do
		for _, card in ipairs(pickable) do
			if Dungeon.cardName(card) == name and (tonumber(card:GetAttribute("Rarity")) or 1) >= Settings.PickFirstRarity then
				return card, "priority"
			end
		end
	end
	if Settings.MostPointsFirst then
		local best, most = nil, nil
		for _, card in ipairs(allowed) do
			local value = Dungeon.cardPoints(card)
			if value and (not most or value > most) then
				best, most = card, value
			end
		end
		if best then
			return best, "points"
		end
	end
	if #allowed > 0 then
		return Dungeon.bestCard(allowed), "allowed"
	end
	for _, card in ipairs(pickable) do
		if card:GetAttribute("Type") == "Skip" then
			return card, "fallback"
		end
	end
	if #pickable > 0 then
		return Dungeon.bestCard(pickable), "fallback"
	end
	local safe = {}
	for _, card in ipairs(cards) do
		if not Dungeon.isCurse(card) then
			table.insert(safe, card)
		end
	end
	return Dungeon.bestCard(#safe > 0 and safe or cards), "forced"
end

function Dungeon.handRerolls(hand)
	return tonumber(hand:GetAttribute("Rerolls")) or 0
end

function Dungeon.handTimeLeft(hand)
	local started = tonumber(hand:GetAttribute("Countdown")) or 0
	local window = tonumber(hand:GetAttribute("Target")) or 0
	return started + window - Workspace:GetServerTimeNow()
end

function Dungeon.rerollReason(hand, tier)
	if not Settings.AutoReroll or tier == "heal" or tier == "life" or tier == "priority" or Dungeon.RerollFailed == hand then
		return nil
	end
	local floor = tonumber(Workspace:GetAttribute("MinigameFloor")) or 0
	if floor < Settings.RerollFloor or Dungeon.handRerolls(hand) <= Settings.RerollKeep then
		return nil
	end
	if Settings.RerollUntilFloor > 0 and floor > Settings.RerollUntilFloor then
		return nil
	end
	if Settings.RerollsPerHand > 0 and Dungeon.RerollStreak >= Settings.RerollsPerHand then
		return nil
	end
	if Dungeon.handTimeLeft(hand) < Const.DUNGEON_REROLL_MIN_TIME then
		return nil
	end
	if tier == "fallback" or tier == "forced" then
		return "no allowed cards"
	end
	if Settings.RerollForPriority and #Settings.PickFirst > 0 then
		return "no Pick First card"
	end
	return nil
end

function Dungeon.cardStep()
	if not Settings.AutoPickCards then
		Dungeon.CardStatus = "Off"
		return
	end
	local hand = LocalPlayer:FindFirstChild("OuwigaharaOffers")
	if not hand or hand:GetAttribute("Picked") ~= nil then
		Dungeon.CardStatus = "Waiting for cards"
		return
	end
	if Dungeon.RerollHand == hand then
		if os.clock() - Dungeon.RerollSentAt < Const.DUNGEON_PICK_REFIRE then
			return
		end
		Dungeon.RerollFailed = hand
		Dungeon.RerollHand = nil
	end
	local signature = tostring(hand:GetAttribute("Countdown")) .. "\0" .. #hand:GetChildren()
	if Dungeon.CardHand == hand and Dungeon.CardSignature == signature and os.clock() - Dungeon.CardSentAt < Const.DUNGEON_PICK_REFIRE then
		return
	end
	local card, tier = Dungeon.chooseCard(hand)
	if not card then
		return
	end
	local reason = Dungeon.rerollReason(hand, tier)
	if reason then
		Dungeon.RerollHand, Dungeon.RerollSentAt = hand, os.clock()
		Dungeon.Rerolls += 1
		Dungeon.RerollStreak += 1
		Dungeon.CardStatus = "Rerolling, " .. reason .. " (" .. (Dungeon.handRerolls(hand) - 1) .. " left)"
		Game.fire("OuwigaharaRequest", { action = "Reroll" })
		return
	end
	Dungeon.CardHand, Dungeon.CardSignature, Dungeon.CardSentAt = hand, signature, os.clock()
	Dungeon.RerollStreak = 0
	local title = tostring(card:GetAttribute("Title") or card:GetAttribute("Type"))
	if tier == "life" then
		Dungeon.CardStatus = "Picked " .. title .. ", " .. Dungeon.hearts() .. " lives left"
	elseif tier == "points" then
		Dungeon.CardStatus = "Picked " .. title .. ", most points"
	elseif tier == "forced" then
		Dungeon.CardStatus = "Forced " .. title .. ", every card was Never Pick"
	elseif tier == "fallback" then
		Dungeon.CardStatus = "Picked " .. title .. ", no card passed the filters"
	else
		Dungeon.CardStatus = "Picked " .. title
	end
	Game.fire("OuwigaharaRequest", { action = "Pick", id = card.Name })
end

function Dungeon.skipStep()
	local breakUntil = Workspace:GetAttribute("MinigameWaveBreak")
	if not Settings.AutoSkipBreak or breakUntil == nil or Dungeon.hearts() <= 0 then
		return
	end
	if Dungeon.SkipVotedFor ~= breakUntil then
		Dungeon.SkipVotedFor = breakUntil
		Game.fire("OuwigaharaRequest", { action = "Skip" })
	end
end

if Hub.InDungeon then
	RootMaid:Give(task.spawn(function()
		Hub.awaitStart()
		while true do
			local ok, err = pcall(Dungeon.cardStep)
			if not ok then
				warn("[Spryzen Hub] card pick error: " .. tostring(err))
			end
			ok, err = pcall(Dungeon.skipStep)
			if not ok then
				warn("[Spryzen Hub] wave skip error: " .. tostring(err))
			end
			task.wait(Const.DUNGEON_CARD_POLL)
		end
	end))
	RootMaid:Give(task.spawn(function()
		Hub.awaitStart()
		while true do
			local ok, err = pcall(Dungeon.bringStep)
			if not ok then
				warn("[Spryzen Hub] bring enemies error: " .. tostring(err))
			end
			task.wait(Const.DUNGEON_BRING_POLL)
		end
	end))
end

local FinalSelection = { Thread = nil, Context = nil, Plans = {}, Spawning = {}, Pulled = {}, ZoneRadius = nil, MissingSince = nil, AddRetryAt = 0, EndingAt = nil, SawClock = false, LootIdleSince = nil, SkipSent = false, ClosingSent = false }

function FinalSelection.active(name)
	local holder = Game.questHolder()
	return holder and holder:FindFirstChild(name)
end

function FinalSelection.current()
	for index = #Const.FINAL_CHAIN, 1, -1 do
		local name = Const.FINAL_CHAIN[index]
		local active = FinalSelection.active(name)
		if active then
			return name, active, index
		end
	end
	return nil
end

function FinalSelection.done(name)
	local ok, state = pcall(Game.Quests.GetPlayerQuestState, LocalPlayer, name)
	return ok and state == "Done"
end

function FinalSelection.nextQuest()
	local chain = Const.FINAL_CHAIN
	for index = #chain, 1, -1 do
		if FinalSelection.done(chain[index]) then
			return chain[index + 1]
		end
	end
	return chain[1]
end

function FinalSelection.hearts()
	return tonumber(LocalPlayer:GetAttribute("Hearts")), tonumber(LocalPlayer:GetAttribute("MaxHearts"))
end

function FinalSelection.taskKind(questName, planTask)
	local spec = planTask.Spec
	local specType = type(spec) == "table" and spec.Type or nil
	if specType == "Pickup" then
		return "Pickup"
	elseif specType == "Deliver" and type(spec.TargetNpc) == "string" then
		return "Deliver"
	elseif specType == "Dungeon" and spec.Dungeon == Const.FINAL_PARKOUR then
		return "Parkour"
	elseif Const.FINAL_KILL_SLOTS[planTask.Code] then
		return "Kill"
	elseif questName == Const.FINAL_MOUNTAIN_QUEST and specType == nil then
		return "Mountain"
	elseif questName == Const.FINAL_ZONE_QUEST then
		return "Zone"
	end
	return nil
end

function FinalSelection.plan(questName)
	local cached = FinalSelection.Plans[questName]
	if cached then
		return cached
	end
	local info = Game.Quests.Holder[questName]
	local plan = type(info) == "table" and QuestPlans.analyze(questName, info) or nil
	if not plan then
		return nil
	end
	for _, planTask in pairs(plan.Tasks) do
		planTask.Kind = FinalSelection.taskKind(questName, planTask)
	end
	FinalSelection.Plans[questName] = plan
	return plan
end

function FinalSelection.regionOf(model)
	local slot = model.Parent
	local active = slot and slot.Parent
	local region = active and active.Parent
	return region and region.Name, slot and slot.Name
end

function FinalSelection.flatDistance(a, b)
	return ((a - b) * Vector3.new(1, 0, 1)).Magnitude
end

function FinalSelection.closeDialogue()
	local ok, err = pcall(Game.DialogueUtility.Close)
	if not ok then
		warn("[Spryzen Hub] dialogue close error: " .. tostring(err))
	end
end

function FinalSelection.spawning(slot)
	local cached = FinalSelection.Spawning[slot]
	if cached ~= nil then
		return cached or nil
	end
	local config = Hub.gameModule("Minigames Place", "Content", Const.FINAL_REGION, "Npcs", slot)
	local spawning = config and type(config.SendOver) == "table" and config.SendOver.Spawning
	FinalSelection.Spawning[slot] = type(spawning) == "table" and spawning or false
	return FinalSelection.Spawning[slot] or nil
end

function FinalSelection.respawnLeft(slot, spawning)
	local humanoids = Workspace:FindFirstChild("Humanoids")
	local regions = humanoids and humanoids:FindFirstChild("Regions")
	local region = regions and regions:FindFirstChild(Const.FINAL_REGION)
	local active = region and region:FindFirstChild("ActiveNpcs")
	local folder = active and active:FindFirstChild(slot)
	local despawned = folder and tonumber(folder:GetAttribute("DespawnedAt"))
	local delay = tonumber(spawning.SpawnTime)
	if not despawned or not delay then
		return nil
	end
	local left = math.ceil(despawned + delay - Workspace:GetServerTimeNow())
	return left > 0 and left or nil
end

function FinalSelection.kill(ctx, _, _, planTask)
	local slot = Const.FINAL_KILL_SLOTS[planTask.Code]
	local model = Mobs.nearest(function(candidate)
		local region, slotName = FinalSelection.regionOf(candidate)
		return region == Const.FINAL_REGION and slotName == slot and ctx.Skip[candidate] == nil
	end)
	if model then
		ctx:setStatus("Fighting " .. model.Name)
		Hunt.engage(ctx, model)
		return true
	end
	local spawning = FinalSelection.spawning(slot)
	local center = spawning and spawning.Center
	if typeof(center) ~= "Vector3" and spawning and type(spawning.Locations) == "table" then
		center = spawning.Locations[1]
	end
	if typeof(center) ~= "Vector3" then
		ctx:setStatus("No spawn known for " .. slot)
		return false
	end
	local left = FinalSelection.respawnLeft(slot, spawning)
	ctx:setStatus("Waiting for " .. slot .. (left and (", spawns in " .. left .. "s") or ""))
	ctx:moveTo(center + Vector3.new(0, Const.SPAWN_WAIT_HEIGHT, 0))
	ctx:sleep(0.5)
	return true
end

function FinalSelection.threatStep(ctx, questName)
	if questName == Const.FINAL_ZONE_QUEST or LocalPlayer:GetAttribute("MountainTrialEndsAt") ~= nil or FinalSelection.training() then
		return false
	end
	local model = Mobs.nearest(function(candidate)
		return FinalSelection.regionOf(candidate) == Const.FINAL_TEMPORARY_REGION and ctx.Skip[candidate] == nil
	end, Const.FINAL_THREAT_RANGE)
	if not model then
		return false
	end
	ctx:setStatus("Fighting " .. model.Name .. " before " .. questName)
	Hunt.engage(ctx, model)
	return true
end

function FinalSelection.shopPrompt(item)
	local debree = Workspace:FindFirstChild("Debree")
	local regions = debree and debree:FindFirstChild("Regions")
	local region = regions and regions:FindFirstChild(Const.FINAL_REGION)
	for _, prompt in ipairs(region and region:GetDescendants() or {}) do
		if prompt:IsA("ProximityPrompt") and prompt.Name == item and prompt.ActionText == "Purchase" and prompt.Parent:IsA("BasePart") then
			return prompt
		end
	end
	return nil
end

function FinalSelection.buy(ctx, item)
	local prompt = FinalSelection.shopPrompt(item)
	if not prompt then
		ctx:setStatus("Going to the " .. item .. " stand")
		local seller = Game.npcPosition(Const.FINAL_SHOP_SELLER)
		if seller then
			ctx:moveTo(seller + Const.NPC_STAND_OFFSET)
		end
		ctx:sleep(1)
		return FinalSelection.shopPrompt(item) ~= nil
	end
	ctx:setStatus("Buying " .. item)
	if not ctx:moveTo(prompt.Parent.Position + Const.GROUND_STAND_OFFSET) then
		return true
	end
	local before = Game.itemCount(item)
	local function bought()
		return Game.itemCount(item) > before
	end
	local cancelled = function()
		return ctx.Cancelled
	end
	Prompts.waitShown(prompt, Const.DUNGEON_PROMPT_SHOWN, cancelled)
	if prompt.Parent and prompt.Enabled then
		Prompts.trigger(prompt, cancelled)
		ctx:sleep(Const.FINAL_CLOSING_GAP)
	end
	Game.fire("PurchaseFromShop", item, 1)
	local ok = ctx:waitFor(bought, Const.FINAL_BUY_CONFIRM)
	FinalSelection.closeDialogue()
	if not ok then
		local checked, _, reason = pcall(Game.Shop.CanBuy, LocalPlayer, item, nil, 1)
		ctx:setStatus("Could not buy " .. item .. (checked and type(reason) == "string" and (": " .. Schematics.plain(reason)) or ""))
		return false
	end
	return true
end

function FinalSelection.deliver(ctx, plan, active, planTask, taskConfig)
	local spec = planTask.Spec
	if type(spec.RequiredItem) == "string" then
		local _, _, maximum = QuestRunner.taskValues(active, planTask.Name)
		if Game.itemCount(spec.RequiredItem) < (spec.Count or math.max(maximum, 1)) then
			return FinalSelection.buy(ctx, spec.RequiredItem)
		end
	end
	return Steps.Deliver(ctx, plan, active, planTask, taskConfig)
end

function FinalSelection.checkpoint(index)
	local debree = Workspace:FindFirstChild("Debree")
	local folder = debree and debree:FindFirstChild("MountainCheckpoints")
	local model = folder and folder:FindFirstChild("Checkpoint" .. index)
	if not model then
		return nil
	end
	local pad = model:FindFirstChild("TouchPart")
	return pad and pad:IsA("BasePart") and pad.Position or model:GetPivot().Position
end

function FinalSelection.mountain(ctx, _, active, planTask)
	local _, value, maximum = QuestRunner.taskValues(active, planTask.Name)
	local endsAt = tonumber(LocalPlayer:GetAttribute("MountainTrialEndsAt"))
	if endsAt == nil then
		local lavato = Game.npcPosition("Lavato")
		if not lavato then
			ctx:setStatus("Lavato location unknown")
			return false
		end
		ctx:setStatus("Starting the mountain trial")
		if ctx:moveTo(lavato + Const.NPC_STAND_OFFSET) then
			Game.fire("StartMountainTrial")
			ctx:waitFor(function()
				return LocalPlayer:GetAttribute("MountainTrialEndsAt") ~= nil or not active.Parent
			end, Const.PROGRESS_TIMEOUT)
		end
		return true
	end
	local index = value + 1
	local left = math.max(math.floor(endsAt - Workspace:GetServerTimeNow()), 0)
	ctx:setStatus(string.format("Mountain checkpoint %d of %d, %ds left", index, maximum, left))
	local position = FinalSelection.checkpoint(index)
	if not position then
		ctx:sleep(0.5)
		return true
	end
	Mover.requestStream(position)
	if not ctx:moveTo(position + Vector3.new(0, Const.SPAWN_WAIT_HEIGHT, 0)) then
		return true
	end
	local function progressed()
		local _, now = QuestRunner.taskValues(active, planTask.Name)
		return now > value or not active.Parent
	end
	if not ctx:waitFor(progressed, Const.FINAL_CHECKPOINT_TOUCH) then
		Game.fire("MountainCheckpoint", index)
		ctx:waitFor(progressed, Const.PROGRESS_TIMEOUT)
	end
	return true
end

function FinalSelection.zoneRadius()
	if FinalSelection.ZoneRadius then
		return FinalSelection.ZoneRadius
	end
	local states = ReplicatedStorage:FindFirstChild("QuestStates")
	local quest = states and states:FindFirstChild(Const.FINAL_ZONE_QUEST)
	local checkpoint = quest and quest:FindFirstChild("Checkpoint")
	local part = checkpoint and checkpoint:FindFirstChild("TouchPart", true)
	if not (part and part:IsA("BasePart")) then
		return Const.FINAL_ZONE_FALLBACK
	end
	if part:IsA("Part") and part.Shape == Enum.PartType.Cylinder then
		FinalSelection.ZoneRadius = math.max(part.Size.Y, part.Size.Z) / 2
	else
		FinalSelection.ZoneRadius = math.max(part.Size.X, part.Size.Z) / 2
	end
	return FinalSelection.ZoneRadius
end

function FinalSelection.civilian(ctx, center)
	local debree = Workspace:FindFirstChild("Debree")
	local best, bestDistance = nil, math.huge
	for _, child in ipairs(debree and debree:GetChildren() or {}) do
		if child.Name == "RescueCivilian" and ctx.Skip[child] == nil then
			local prompt = child:FindFirstChildWhichIsA("ProximityPrompt", true)
			if prompt and prompt.Enabled and prompt.Parent:IsA("BasePart") then
				local distance = (prompt.Parent.Position - center).Magnitude
				if distance < bestDistance then
					best, bestDistance = prompt, distance
				end
			end
		end
	end
	return best
end

function FinalSelection.zone(ctx)
	local center = LocalPlayer:GetAttribute("RescueZonePos")
	local state = LocalPlayer:GetAttribute("RescueZoneState")
	local cancelled = function()
		return ctx.Cancelled
	end
	if typeof(center) ~= "Vector3" then
		ctx:setStatus("Waiting for the rescue zone")
		ctx.Lease:SetGoal(nil)
		ctx:sleep(1)
		return true
	end
	if state == "Carrying" then
		local levi = Game.npcPosition("Levi")
		if not levi then
			ctx:setStatus("Levi location unknown")
			return false
		end
		ctx:setStatus("Carrying the civilian to Levi")
		if ctx:moveTo(levi + Const.NPC_STAND_OFFSET) then
			ctx:waitFor(function()
				return LocalPlayer:GetAttribute("RescueZoneState") ~= "Carrying"
			end, Const.PROGRESS_TIMEOUT)
		end
		return true
	end
	if state == "Captured" then
		local prompt = FinalSelection.civilian(ctx, center)
		if not prompt then
			ctx:setStatus("Waiting for the civilian")
			ctx:moveTo(center + Const.GROUND_STAND_OFFSET)
			ctx:sleep(0.5)
			return true
		end
		ctx:setStatus("Rescuing the civilian")
		if not ctx:moveTo(prompt.Parent.Position + Const.GROUND_STAND_OFFSET) then
			return true
		end
		Prompts.waitShown(prompt, Const.DUNGEON_PROMPT_SHOWN, cancelled)
		if prompt.Parent and prompt.Enabled then
			Prompts.trigger(prompt, cancelled)
		end
		if not ctx:waitFor(function()
			return LocalPlayer:GetAttribute("RescueZoneState") == "Carrying"
		end, Const.PROGRESS_TIMEOUT) then
			local civilian = prompt:FindFirstAncestor("RescueCivilian")
			if civilian then
				ctx.Skip[civilian] = os.clock()
			end
		end
		return true
	end
	local reach = FinalSelection.zoneRadius() - Settings.Distance - Const.FINAL_ZONE_MARGIN
	local function inside(model)
		local root = model.Parent and model:FindFirstChild("HumanoidRootPart")
		return root ~= nil and FinalSelection.flatDistance(root.Position, center) <= reach
	end
	local demon = Mobs.nearest(function(candidate)
		return FinalSelection.regionOf(candidate) == Const.FINAL_TEMPORARY_REGION and ctx.Skip[candidate] == nil and inside(candidate)
	end)
	if demon then
		ctx:setStatus("Holding the zone, fighting " .. demon.Name)
		Hunt.engage(ctx, demon, function()
			return inside(demon)
		end)
		return true
	end
	local progress = tonumber(LocalPlayer:GetAttribute("RescueZoneProgress")) or 0
	ctx:setStatus(string.format("Holding the zone, %d%%", math.floor(progress * 100)))
	ctx:moveTo(center + Const.GROUND_STAND_OFFSET)
	ctx:sleep(0.25)
	return true
end

function FinalSelection.training()
	local ok, values = pcall(Game.Utility.getvaluesfolder, LocalPlayer)
	local training = ok and typeof(values) == "Instance" and values:FindFirstChild("Training") or nil
	return training ~= nil and training:GetAttribute("Type") == Const.FINAL_PARKOUR
end

function FinalSelection.parkourMap()
	local map = Workspace:FindFirstChild("Map")
	local detached = map and map:FindFirstChild("DetachedMaps")
	return detached and detached:FindFirstChild("ParkourTraining")
end

function FinalSelection.switches()
	local map = FinalSelection.parkourMap()
	local folder = map and map:FindFirstChild("Switchs")
	local list = {}
	for _, switch in ipairs(folder and folder:GetChildren() or {}) do
		if switch:IsA("Model") then
			table.insert(list, switch)
		end
	end
	table.sort(list, function(a, b)
		return (tonumber(string.match(a.Name, "%d+")) or 0) < (tonumber(string.match(b.Name, "%d+")) or 0)
	end)
	return list
end

function FinalSelection.enterParkour(ctx)
	table.clear(FinalSelection.Pulled)
	local debree = Workspace:FindFirstChild("Debree")
	local entrance = debree and debree:FindFirstChild(Const.FINAL_PARKOUR)
	local ref = entrance and entrance:FindFirstChild("Ref")
	local prompt = ref and ref:FindFirstChildWhichIsA("ProximityPrompt")
	if not prompt then
		ctx:setStatus("Waiting for the Parkour Dungeon entrance")
		ctx:sleep(1)
		return true
	end
	ctx:setStatus("Entering the Parkour Dungeon")
	if not ctx:moveTo(ref.Position + Const.GROUND_STAND_OFFSET) then
		return true
	end
	local cancelled = function()
		return ctx.Cancelled
	end
	Prompts.waitShown(prompt, Const.DUNGEON_PROMPT_SHOWN, cancelled)
	if not prompt.Enabled then
		ctx:setStatus("Parkour Dungeon entrance is disabled")
		ctx:sleep(1)
		return true
	end
	Prompts.trigger(prompt, cancelled)
	ctx.Lease:SetGoal(nil)
	ctx:waitFor(FinalSelection.training, Const.FINAL_TRAINING_START)
	return true
end

function FinalSelection.pullSwitch(ctx, switch, index, total)
	ctx:setStatus(string.format("Parkour Dungeon, lever %d of %d", index, total))
	if not ctx:moveTo(switch:GetPivot().Position + Const.GROUND_STAND_OFFSET) then
		return
	end
	local handle = switch:FindFirstChild("A_")
	local prompt = handle and handle:FindFirstChildWhichIsA("ProximityPrompt", true)
	if prompt and prompt.Enabled then
		local cancelled = function()
			return ctx.Cancelled
		end
		Prompts.waitShown(prompt, Const.DUNGEON_PROMPT_SHOWN, cancelled)
		Prompts.trigger(prompt, cancelled)
		if ctx:waitFor(function()
			return handle:GetAttribute("On") == true
		end, Const.FINAL_LEVER_CONFIRM) then
			FinalSelection.Pulled[switch] = true
			return
		end
	end
	if ctx.Cancelled then
		return
	end
	Game.fire("training_signaler", "StateChanged", switch)
	FinalSelection.Pulled[switch] = true
end

function FinalSelection.parkour(ctx)
	if not FinalSelection.training() then
		return FinalSelection.enterParkour(ctx)
	end
	local switches = FinalSelection.switches()
	if #switches == 0 then
		ctx:setStatus("Waiting for the Parkour Dungeon to load")
		ctx:sleep(1)
		return true
	end
	for index, switch in ipairs(switches) do
		local handle = switch:FindFirstChild("A_")
		if not FinalSelection.Pulled[switch] and not (handle and handle:GetAttribute("On") == true) then
			FinalSelection.pullSwitch(ctx, switch, index, #switches)
			return true
		end
	end
	local map = FinalSelection.parkourMap()
	local final = map and map:FindFirstChild("Final")
	if not (final and final:IsA("BasePart")) then
		ctx:setStatus("Parkour Dungeon, loading the finish")
		Mover.requestStream(Const.FINAL_PARKOUR_END)
		ctx:moveTo(Const.FINAL_PARKOUR_END)
		return true
	end
	ctx:setStatus("Parkour Dungeon, finishing")
	ctx:moveTo(final.Position)
	local function left()
		return not FinalSelection.training()
	end
	if not ctx:waitFor(left, Const.FINAL_FINISH_WAIT) then
		Game.fire("training_signaler", "Stop")
		ctx:waitFor(left, Const.PROGRESS_TIMEOUT)
	end
	ctx.Lease:SetGoal(nil)
	return true
end

FinalSelection.Steps = {
	Pickup = Steps.Pickup,
	Deliver = FinalSelection.deliver,
	Kill = FinalSelection.kill,
	Mountain = FinalSelection.mountain,
	Zone = FinalSelection.zone,
	Parkour = FinalSelection.parkour,
}

function FinalSelection.addBlocker(onCooldown, blocking)
	if onCooldown == 2 then
		return ", already completed"
	elseif onCooldown == 1 then
		return ", already active"
	elseif onCooldown == true then
		return ", quest cooldown"
	elseif blocking then
		return ", finish '" .. tostring(blocking) .. "' first"
	end
	return ", requirements not met"
end

function FinalSelection.advance(ctx)
	Combat.FarmTarget = nil
	ctx.Lease:SetGoal(nil)
	local nextQuest = FinalSelection.nextQuest()
	if not nextQuest then
		ctx:setStatus("Final Selection complete")
		ctx:sleep(1)
		return
	end
	FinalSelection.MissingSince = FinalSelection.MissingSince or os.clock()
	if os.clock() - FinalSelection.MissingSince < Const.FINAL_ADD_WAIT or os.clock() < FinalSelection.AddRetryAt then
		ctx:setStatus("Waiting for " .. nextQuest)
		ctx:sleep(0.5)
		return
	end
	FinalSelection.AddRetryAt = os.clock() + Const.FINAL_ADD_RETRY
	local roomOk, roomWhy = QuestRunner.makeRoom(ctx, nextQuest, function(name)
		return table.find(Const.FINAL_CHAIN, name) ~= nil
	end)
	if not roomOk then
		ctx:setStatus("Cannot start " .. nextQuest .. ": " .. roomWhy)
		return
	end
	local ok, canAdd, onCooldown, blocking = pcall(Game.Quests.CanAddQuest, LocalPlayer, nextQuest)
	if ok and canAdd ~= true then
		ctx:setStatus("Cannot start " .. nextQuest .. FinalSelection.addBlocker(onCooldown, blocking))
		return
	end
	ctx:setStatus("Starting " .. nextQuest)
	Game.fire("AddQuest", nextQuest)
	if ctx:waitFor(function()
		return FinalSelection.active(nextQuest) ~= nil
	end, Const.QUEST_ACCEPT_TIMEOUT) then
		FinalSelection.closeDialogue()
	end
end

function FinalSelection.finish(ctx)
	Combat.FarmTarget = nil
	ctx.Lease:SetGoal(nil)
	FinalSelection.EndingAt = FinalSelection.EndingAt or os.clock()
	local clock = LocalPlayer:FindFirstChild("FinalSelectionLootClock")
	if clock then
		FinalSelection.SawClock = true
		local started = tonumber(clock:GetAttribute("Countdown")) or Workspace:GetServerTimeNow()
		local total = tonumber(clock:GetAttribute("Target")) or 0
		local left = math.max(math.ceil(started + total - Workspace:GetServerTimeNow()), 0)
		if Settings.FinalSkipLoot and not FinalSelection.SkipSent then
			if Collector.Busy then
				FinalSelection.LootIdleSince = nil
			else
				FinalSelection.LootIdleSince = FinalSelection.LootIdleSince or os.clock()
				if not Settings.AutoPickup or os.clock() - FinalSelection.LootIdleSince >= Const.FINAL_LOOT_SETTLE then
					FinalSelection.SkipSent = true
					Game.fire("FinalSelection_Completion_Helper", "SkipLoot")
				end
			end
		end
		ctx:setStatus("Passed, loot window " .. left .. "s")
		ctx:sleep(0.5)
		return
	end
	if not FinalSelection.SawClock and os.clock() - FinalSelection.EndingAt < Const.FINAL_LOOT_LIMIT then
		ctx:setStatus("Passed, waiting for the loot window")
		ctx:sleep(0.5)
		return
	end
	if not FinalSelection.ClosingSent then
		ctx:setStatus("Collecting the Corps rewards")
		for _, step in ipairs(Const.FINAL_CLOSING_STEPS) do
			if not ctx:sleep(Const.FINAL_CLOSING_GAP) then
				return
			end
			Game.fire("FinalSelection_Completion_Helper", step)
		end
		FinalSelection.ClosingSent = true
		FinalSelection.closeDialogue()
	end
	ctx:setStatus("Passed, heading home")
	ctx:sleep(1)
end

function FinalSelection.step(ctx)
	for model, at in pairs(ctx.Skip) do
		if os.clock() - at > Const.SKIP_TARGET_FOR or not model.Parent then
			ctx.Skip[model] = nil
		end
	end
	if not Character.alive() then
		Combat.FarmTarget = nil
		ctx:setStatus("Waiting for respawn")
		ctx:sleep(1)
		return
	end
	if LocalPlayer:GetAttribute("TrialEnding") == true then
		FinalSelection.finish(ctx)
		return
	end
	local hearts = FinalSelection.hearts()
	if hearts and hearts <= 0 then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus("Out of lives, the trial is over")
		ctx:sleep(1)
		return
	end
	if Heal.Retreating or Escape.Active then
		ctx:setStatus(Escape.Active and "Paused, retreating" or "Paused to heal")
		ctx:sleep(0.5)
		return
	end
	local name, active = FinalSelection.current()
	if not active then
		FinalSelection.advance(ctx)
		return
	end
	FinalSelection.MissingSince = nil
	if FinalSelection.threatStep(ctx, name) then
		return
	end
	local plan = FinalSelection.plan(name)
	if not plan then
		ctx:setStatus("No quest data for " .. name)
		ctx:sleep(2)
		return
	end
	local planTask, taskConfig, waiting = QuestRunner.nextTask(plan, active)
	if not planTask then
		ctx:setStatus(waiting and ("Waiting on " .. waiting.Name) or ("Completing " .. name))
		ctx:waitFor(function()
			return active.Parent == nil
		end, 3)
		return
	end
	local run = planTask.Kind and FinalSelection.Steps[planTask.Kind]
	if not run then
		ctx:setStatus("Unsupported task: " .. planTask.Name)
		ctx:sleep(2)
		return
	end
	if not run(ctx, plan, active, planTask, taskConfig) then
		ctx:sleep(1)
	end
end

function FinalSelection.stop()
	local ctx = FinalSelection.Context
	local thread = FinalSelection.Thread
	FinalSelection.Context = nil
	FinalSelection.Thread = nil
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
	Combat.FarmTarget = nil
end

function FinalSelection.refresh()
	if not Hub.InFinalSelection or not Settings.AutoFinalSelection then
		FinalSelection.stop()
		return
	end
	if FinalSelection.Context then
		return
	end
	local ctx = Context.new(Mover.acquire("final selection", 10))
	FinalSelection.Context = ctx
	FinalSelection.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(FinalSelection.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] auto final selection error: " .. tostring(err))
				ctx:setStatus("Error, see console")
				Combat.FarmTarget = nil
				ctx.Lease:SetGoal(nil)
				ctx:sleep(2)
			end
		end
	end)
end

function FinalSelection.statusText()
	local ctx = FinalSelection.Context
	if not ctx then
		return "Off", "Muted"
	end
	return ctx.Status, "Success"
end

function FinalSelection.progressText()
	local hearts, maxHearts = FinalSelection.hearts()
	local lives = string.format("%d/%d lives", hearts or 0, maxHearts or 0)
	if LocalPlayer:GetAttribute("TrialEnding") == true then
		return "Passed, " .. lives, "Success"
	end
	local name, _, index = FinalSelection.current()
	if not name then
		return "No trial quest, " .. lives, "Muted"
	end
	return string.format("%d/%d %s, %s", index, #Const.FINAL_CHAIN, name, lives), "Accent"
end

local FinalFarm = { Thread = nil, Context = nil, Options = {}, Kills = 0 }

if Hub.InFinalSelection then
	local folder = ReplicatedStorage:FindFirstChild("Minigames Place")
	for _, name in ipairs({ "Content", Const.FINAL_REGION, "Npcs" }) do
		folder = folder and folder:FindFirstChild(name)
	end
	local seen = {}
	for _, module in ipairs(folder and folder:GetChildren() or {}) do
		if module:IsA("ModuleScript") and module.Name ~= Const.FINAL_BOSS_SLOT then
			local config = Hub.gameModule("Minigames Place", "Content", Const.FINAL_REGION, "Npcs", module.Name)
			local sendOver = config and type(config.SendOver) == "table" and config.SendOver or nil
			if sendOver and type(sendOver.Spawning) == "table" and sendOver.Profile ~= "Civilian" and not seen[module.Name] then
				seen[module.Name] = true
				table.insert(FinalFarm.Options, module.Name)
			end
		end
	end
	for _, slot in pairs(Const.FINAL_KILL_SLOTS) do
		if slot ~= Const.FINAL_BOSS_SLOT and not seen[slot] then
			seen[slot] = true
			table.insert(FinalFarm.Options, slot)
		end
	end
	table.sort(FinalFarm.Options)
end

function FinalFarm.wanted()
	local wanted = {}
	if Settings.FinalMobs then
		for _, slot in ipairs(#Settings.FinalMobList > 0 and Settings.FinalMobList or FinalFarm.Options) do
			wanted[slot] = true
		end
	end
	if Settings.FinalBoss then
		wanted[Const.FINAL_BOSS_SLOT] = true
	end
	return wanted
end

function FinalFarm.target(ctx, slots)
	return Mobs.nearest(function(candidate)
		local region, slot = FinalSelection.regionOf(candidate)
		return region == Const.FINAL_REGION and slots[slot] == true and ctx.Skip[candidate] == nil
	end)
end

function FinalFarm.spawnPoint(slot)
	local spawning = FinalSelection.spawning(slot)
	if not spawning then
		return nil
	end
	local center = spawning.Center
	if typeof(center) ~= "Vector3" and type(spawning.Locations) == "table" then
		center = spawning.Locations[1]
	end
	return typeof(center) == "Vector3" and center or nil, spawning
end

function FinalFarm.waitSlot(slots)
	if Settings.FinalBoss and FinalFarm.spawnPoint(Const.FINAL_BOSS_SLOT) then
		return Const.FINAL_BOSS_SLOT
	end
	local root = Character.root()
	local best, bestDistance = nil, math.huge
	for slot in pairs(slots) do
		local center = FinalFarm.spawnPoint(slot)
		local distance = center and root and (center - root.Position).Magnitude or math.huge
		if center and (best == nil or distance < bestDistance) then
			best, bestDistance = slot, distance
		end
	end
	return best
end

function FinalFarm.step(ctx)
	for model, at in pairs(ctx.Skip) do
		if os.clock() - at > Const.SKIP_TARGET_FOR or not model.Parent then
			ctx.Skip[model] = nil
		end
	end
	if Settings.AutoFinalSelection then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus("Paused while Auto Final Selection runs")
		ctx:sleep(1)
		return
	end
	if not Character.alive() then
		Combat.FarmTarget = nil
		ctx:setStatus("Waiting for respawn")
		ctx:sleep(1)
		return
	end
	local hearts = FinalSelection.hearts()
	if hearts and hearts <= 0 then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus("Out of lives, the trial is over")
		ctx:sleep(1)
		return
	end
	if Heal.Retreating or Escape.Active then
		ctx:setStatus(Escape.Active and "Paused, retreating" or "Paused to heal")
		ctx:sleep(0.5)
		return
	end
	local slots = FinalFarm.wanted()
	if next(slots) == nil then
		ctx:setStatus("No mobs selected")
		ctx:sleep(1)
		return
	end
	local model = Settings.FinalBoss and FinalFarm.target(ctx, { [Const.FINAL_BOSS_SLOT] = true }) or FinalFarm.target(ctx, slots)
	if model then
		ctx:setStatus("Fighting " .. model.Name)
		Hunt.engage(ctx, model)
		if not Mobs.isAlive(model) and ctx.Skip[model] == nil then
			FinalFarm.Kills += 1
		end
		return
	end
	local slot = FinalFarm.waitSlot(slots)
	local center, spawning = nil, nil
	if slot then
		center, spawning = FinalFarm.spawnPoint(slot)
	end
	if not center then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus("No spawn known for the selected mobs")
		ctx:sleep(2)
		return
	end
	local left = FinalSelection.respawnLeft(slot, spawning)
	ctx:setStatus("Waiting for " .. slot .. (left and (", spawns in " .. left .. "s") or ""))
	ctx:moveTo(center + Vector3.new(0, Const.SPAWN_WAIT_HEIGHT, 0))
	ctx:sleep(0.5)
end

function FinalFarm.stop()
	local ctx = FinalFarm.Context
	local thread = FinalFarm.Thread
	FinalFarm.Context = nil
	FinalFarm.Thread = nil
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
	Combat.FarmTarget = nil
end

function FinalFarm.refresh()
	if not Hub.InFinalSelection or not (Settings.FinalBoss or Settings.FinalMobs) then
		FinalFarm.stop()
		return
	end
	if FinalFarm.Context then
		return
	end
	local ctx = Context.new(Mover.acquire("final farm", 9))
	FinalFarm.Context = ctx
	FinalFarm.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(FinalFarm.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] final selection farm error: " .. tostring(err))
				ctx:setStatus("Error, see console")
				Combat.FarmTarget = nil
				ctx.Lease:SetGoal(nil)
				ctx:sleep(2)
			end
		end
	end)
end

function FinalFarm.statusText()
	local ctx = FinalFarm.Context
	if not ctx then
		return "Off", "Muted"
	end
	return ctx.Status, string.find(ctx.Status, "^Paused") and "Warning" or "Success"
end

function BossFarm.order()
	local handle = BossFarm.OrderList
	if handle then
		local ok, order = pcall(handle.Get, handle)
		if ok and type(order) == "table" then
			return order
		end
	end
	return Settings.BossOrder
end

function BossFarm.selected()
	local rank = {}
	for index, label in ipairs(BossFarm.order()) do
		if rank[label] == nil then
			rank[label] = index
		end
	end
	local list = {}
	for _, label in ipairs(Settings.Bosses) do
		local boss = WorldBoss.ByOption[label]
		if boss and not table.find(list, boss) then
			table.insert(list, boss)
		end
	end
	table.sort(list, function(a, b)
		local rankA, rankB = rank[a.BossLabel] or math.huge, rank[b.BossLabel] or math.huge
		if rankA ~= rankB then
			return rankA < rankB
		end
		return a.BossOrder < b.BossOrder
	end)
	return list
end

function BossFarm.after(list, anchor)
	local start = anchor and table.find(list, anchor) or 0
	local ordered = table.create(#list)
	for offset = 1, #list do
		table.insert(ordered, list[(start + offset - 1) % #list + 1])
	end
	return ordered
end

function BossFarm.rotation(list)
	return BossFarm.after(list, BossFarm.LastBoss)
end

function BossFarm.partySet()
	local set = {}
	local ok, members = pcall(Game.PartyWatcher.GetMembers)
	if ok and type(members) == "table" then
		for _, member in ipairs(members) do
			if type(member) == "table" and member.UserId then
				set[member.UserId] = true
			end
		end
	end
	return set
end

function BossFarm.playerNear(position)
	local party = BossFarm.partySet()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and not party[player.UserId] then
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if root and humanoid and humanoid.Health > 0 and (root.Position - position).Magnitude <= Settings.BossAvoidRadius then
				return true
			end
		end
	end
	return false
end

function BossFarm.avoided(boss)
	if not Settings.BossAvoidPlayers then
		return false
	end
	local model = WorldBoss.model(boss)
	local root = model and model:FindFirstChild("HumanoidRootPart")
	local now = os.clock()
	if BossFarm.playerNear(root and root.Position or WorldBoss.center(boss)) then
		BossFarm.Crowded[boss] = now
		return true
	end
	local seen = BossFarm.Crowded[boss]
	return seen ~= nil and now - seen < Const.BOSS_CROWD_HOLD
end

function BossFarm.pick(list)
	local now = Workspace:GetServerTimeNow()
	local soonest, soonestAt = nil, math.huge
	local crowded = false
	for _, boss in ipairs(BossFarm.rotation(list)) do
		if BossFarm.avoided(boss) then
			crowded = true
			continue
		end
		local slot = WorldBoss.slot(boss)
		if WorldBoss.model(boss, slot) then
			return boss
		end
		local spawnAt = WorldBoss.spawnAt(boss, slot)
		if spawnAt and spawnAt <= now then
			return boss
		end
		if spawnAt and spawnAt < soonestAt then
			soonest, soonestAt = boss, spawnAt
		end
	end
	return nil, soonest, soonestAt, crowded
end

function BossFarm.commit(boss)
	local slot = WorldBoss.slot(boss)
	BossFarm.Current = boss
	BossFarm.Mark = slot and slot:GetAttribute("DespawnedAt")
	BossFarm.SawKill = false
	BossFarm.KillAt = nil
	BossFarm.StreamAt = 0
end

function BossFarm.finished()
	local slot = WorldBoss.slot(BossFarm.Current)
	return slot ~= nil and slot:GetAttribute("DespawnedAt") ~= BossFarm.Mark
end

function BossFarm.complete()
	local boss = BossFarm.Current
	if BossFarm.SawKill then
		BossFarm.Kills += 1
		BossStats.record(boss.Name, true)
	end
	local root = Character.root()
	local lootAt = BossFarm.KillAt or Collector.focusAt() or (root and root.Position)
	BossFarm.KillAt = nil
	if lootAt and (Settings.AutoPickup or Settings.AutoSouls) then
		Collector.focus(lootAt)
		BossFarm.LootAt = lootAt
		BossFarm.LootUntil = os.clock() + Const.BOSS_LOOT_WINDOW
		BossFarm.LootHardUntil = os.clock() + Const.BOSS_LOOT_MAX
	end
	BossFarm.LastBoss = boss
	BossFarm.Current = nil
	BossFarm.Mark = nil
	BossFarm.SawKill = false
	BossFarm.RestPending = true
end

function BossFarm.resting(ctx)
	if BossFarm.RestPending then
		BossFarm.RestPending = false
		BossFarm.RestUntil = os.clock() + (tonumber(Settings.BossNextDelay) or 0)
		local root = Character.root()
		BossFarm.RestHold = root and root.CFrame or nil
	end
	local left = BossFarm.RestUntil - os.clock()
	if left <= 0 or not Character.alive() then
		BossFarm.RestHold = nil
		return false
	end
	local hold = BossFarm.RestHold
	ctx.Lease:SetGoal(hold and function()
		return hold
	end or nil)
	BossFarm.set(ctx, string.format("Next boss in %ds", math.ceil(left)))
	ctx:sleep(math.min(left, 0.5))
	return true
end

function BossFarm.hover(center)
	return CFrame.new(center + Vector3.new(0, Const.BOSS_HOVER_HEIGHT, 0))
end

function BossFarm.requestStream(center)
	if os.clock() - BossFarm.StreamAt < Const.BOSS_STREAM_RETRY then
		return
	end
	BossFarm.StreamAt = os.clock()
	task.spawn(function()
		local ok, err = pcall(LocalPlayer.RequestStreamAroundAsync, LocalPlayer, center, Const.BOSS_STREAM_TIMEOUT)
		if not ok then
			warn("[Spryzen Hub] boss stream request failed: " .. tostring(err))
		end
	end)
end

function BossFarm.set(ctx, phase, boss)
	BossFarm.Phase = phase
	BossFarm.Focus = boss
	ctx:setStatus(boss and (phase .. " " .. boss.Name) or phase)
end

function BossFarm.lootPending()
	local now = os.clock()
	return BossFarm.LootAt ~= nil and (now < BossFarm.LootUntil or (now < BossFarm.LootHardUntil and Settings.AutoPickup and Collector.pendingNear(BossFarm.LootAt, Settings.DropRange)))
end

function BossFarm.looting(ctx)
	if Collector.Busy then
		ctx.Lease:SetGoal(nil)
		BossFarm.set(ctx, "Looting")
		ctx:sleep(Const.COLLECT_POLL)
		return true
	end
	if BossFarm.lootPending() and Character.alive() then
		local hold = CFrame.new(BossFarm.LootAt)
		ctx.Lease:SetGoal(function()
			return hold
		end)
		BossFarm.set(ctx, "Looting")
		ctx:waitFor(function()
			return Collector.Busy
		end, Const.COLLECT_POLL)
		return true
	end
	BossFarm.LootAt = nil
	return false
end

function BossFarm.engage(ctx, boss)
	local center = WorldBoss.center(boss)
	local lastHumanoid = nil
	ctx.Lease:SetGoal(function()
		local model = WorldBoss.model(boss)
		local targetRoot = model and model:FindFirstChild("HumanoidRootPart")
		if targetRoot and (targetRoot.Position - center).Magnitude <= Const.BOSS_ENGAGE_RANGE then
			return Pose.around(targetRoot)
		end
		return BossFarm.hover(center)
	end)
	BossFarm.set(ctx, "Fighting", boss)
	Priority.set(ctx, "Engaged")
	while not ctx.Cancelled and BossFarm.Current == boss and Character.alive() and not BossFarm.finished() and not Collector.Busy and not BossFarm.avoided(boss) do
		local model = WorldBoss.model(boss)
		if not model then
			break
		end
		Combat.BossTarget = model
		lastHumanoid = model:FindFirstChildOfClass("Humanoid")
		BossFarm.KillAt = Collector.bossPosition(model) or BossFarm.KillAt
		task.wait(Const.BOSS_POLL)
	end
	if lastHumanoid and lastHumanoid.Health <= 0 then
		BossFarm.SawKill = true
	end
	Combat.BossTarget = nil
end

function BossFarm.approach(ctx, boss)
	local center = WorldBoss.center(boss)
	local goal = BossFarm.hover(center)
	local root = Character.root()
	if root and (root.Position - goal.Position).Magnitude > Const.ARRIVE_DISTANCE * 4 then
		BossFarm.set(ctx, "Travelling", boss)
		ctx.Lease:MoveTo(goal, function()
			return ctx.Cancelled or Collector.Busy or BossFarm.Current ~= boss or not Character.alive() or WorldBoss.model(boss) ~= nil or BossFarm.finished() or BossFarm.avoided(boss)
		end)
		return
	end
	ctx.Lease:SetGoal(function()
		return goal
	end)
	BossFarm.requestStream(center)
	BossFarm.set(ctx, "Waiting", boss)
	ctx:waitFor(function()
		return Collector.Busy or BossFarm.Current ~= boss or not Character.alive() or WorldBoss.model(boss) ~= nil or BossFarm.finished() or BossFarm.avoided(boss)
	end, 1)
end

function BossFarm.idle(ctx, soonest, soonestAt, crowded)
	if not soonest then
		ctx.Lease:SetGoal(nil)
		BossFarm.set(ctx, crowded and "Players at every boss" or "No known spawn")
		ctx:sleep(1)
		return
	end
	if Priority.holder() ~= nil then
		ctx.Lease:SetGoal(nil)
		BossFarm.set(ctx, "Running other farms", soonest)
		ctx:sleep(1)
		return
	end
	local goal = BossFarm.hover(WorldBoss.center(soonest))
	local root = Character.root()
	if root and Character.alive() and (root.Position - goal.Position).Magnitude > Const.ARRIVE_DISTANCE * 4 then
		BossFarm.set(ctx, "Travelling", soonest)
		ctx.Lease:MoveTo(goal, function()
			return ctx.Cancelled or Collector.Busy or not Character.alive() or (BossFarm.pick(BossFarm.selected())) ~= nil
		end)
		return
	end
	ctx.Lease:SetGoal(Character.alive() and function()
		return goal
	end or nil)
	BossFarm.set(ctx, "Waiting", soonest)
	ctx:sleep(1)
end

function BossFarm.demand(ctx, list)
	local fighting = BossFarm.Current ~= nil and WorldBoss.model(BossFarm.Current) ~= nil
	if Priority.engaged(ctx) and (fighting or BossFarm.lootPending()) then
		return "Engaged"
	end
	if BossFarm.Current or BossFarm.lootPending() or BossFarm.RestPending or os.clock() < BossFarm.RestUntil then
		return "Want"
	end
	return (BossFarm.pick(list)) and "Want" or nil
end

function BossFarm.step(ctx)
	local list = BossFarm.selected()
	if BossFarm.Current and not table.find(list, BossFarm.Current) then
		BossFarm.Current = nil
		BossFarm.Mark = nil
	end
	if #list == 0 then
		Priority.set(ctx, nil)
		ctx.Lease:SetGoal(nil)
		BossFarm.set(ctx, "No bosses selected")
		ctx:sleep(1)
		return
	end
	if BossFarm.Current and (BossFarm.SawKill or BossFarm.finished()) then
		BossFarm.complete()
	end
	if BossFarm.Current and BossFarm.avoided(BossFarm.Current) then
		BossFarm.Current = nil
		BossFarm.Mark = nil
		BossFarm.KillAt = nil
		Combat.BossTarget = nil
	end
	Priority.set(ctx, BossFarm.demand(ctx, list))
	local other = Priority.blocked(ctx.Job)
	if other then
		ctx.Lease:SetGoal(nil)
		BossFarm.set(ctx, Priority.pausedFor(other))
		ctx:sleep(Const.PRIORITY_POLL)
		return
	end
	if BossFarm.looting(ctx) then
		return
	end
	if not BossFarm.Current and BossFarm.resting(ctx) then
		return
	end
	if not BossFarm.Current then
		local boss, soonest, soonestAt, crowded = BossFarm.pick(list)
		if not boss then
			BossFarm.idle(ctx, soonest, soonestAt, crowded)
			return
		end
		BossFarm.commit(boss)
	end
	local boss = BossFarm.Current
	if not Character.alive() then
		Combat.BossTarget = nil
		ctx.Lease:SetGoal(nil)
		BossFarm.set(ctx, "Respawning", boss)
		ctx:sleep(0.5)
		return
	end
	if WorldBoss.model(boss) then
		BossFarm.engage(ctx, boss)
	else
		BossFarm.approach(ctx, boss)
	end
end

function BossFarm.stop()
	local ctx = BossFarm.Context
	local thread = BossFarm.Thread
	if ctx and BossStats.StartedAt then
		BossStats.StoppedAt = os.clock()
	end
	BossFarm.Context = nil
	BossFarm.Thread = nil
	BossFarm.LootUntil = 0
	BossFarm.LootAt = nil
	BossFarm.KillAt = nil
	BossFarm.Current = nil
	BossFarm.Mark = nil
	BossFarm.Phase = "Off"
	BossFarm.Focus = nil
	BossFarm.RestPending = false
	BossFarm.RestUntil = 0
	BossFarm.RestHold = nil
	if ctx then
		ctx.Cancelled = true
		Priority.release(ctx)
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
	Combat.BossTarget = nil
end

function BossFarm.refresh()
	if not Settings.WorldBosses then
		BossFarm.stop()
		return
	end
	if BossFarm.Context then
		return
	end
	local ctx = Context.new(Mover.acquire("bosses", 15))
	Priority.bind(ctx, "Bosses")
	BossFarm.Context = ctx
	BossStats.reset()
	BossFarm.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(BossFarm.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] world boss error: " .. tostring(err))
				BossFarm.set(ctx, "Error, retrying")
				Combat.BossTarget = nil
				ctx.Lease:SetGoal(nil)
				ctx:sleep(1)
			end
		end
	end)
end

function BossFarm.stateText(boss)
	local state, remaining = WorldBoss.state(boss)
	if state == "Respawning" then
		return WorldBoss.clock(remaining)
	elseif state == "Alive" then
		local model = WorldBoss.model(boss)
		local humanoid = model and model:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.MaxHealth > 0 then
			return math.floor(humanoid.Health / humanoid.MaxHealth * 100) .. "% HP"
		end
	end
	return state
end

local BossTones = {
	Fighting = "Success",
	Looting = "Accent",
	Travelling = "Warning",
	Waiting = "Warning",
	["Running other farms"] = "Warning",
	["Players at every boss"] = "Warning",
	Summoning = "Accent",
	["Out of Frozen Hearts"] = "Error",
	["Waiting for the berg"] = "Warning",
	["Berg refreezing"] = "Warning",
	Respawning = "Error",
	["Error, retrying"] = "Error",
}

function BossFarm.tone(phase)
	return BossTones[phase] or (string.find(phase, "^Paused for ") and "Warning") or nil
end

function BossFarm.upcoming()
	for _, boss in ipairs(BossFarm.after(BossFarm.selected(), BossFarm.Current or BossFarm.LastBoss)) do
		if boss ~= BossFarm.Current and boss ~= BossFarm.Focus then
			return boss
		end
	end
	return nil
end

function BossFarm.timerRows()
	local list = BossFarm.selected()
	if #list == 0 then
		list = WorldBoss.List
	end
	local rows = {}
	for _, boss in ipairs(list) do
		local value = BossFarm.stateText(boss)
		local tone = "Muted"
		if boss == BossFarm.Current then
			value, tone = value .. " (farming)", "Accent"
		elseif BossFarm.avoided(boss) then
			value, tone = value .. " (players nearby)", "Warning"
		else
			local state = WorldBoss.state(boss)
			tone = (state == "Alive" or state == "Up") and "Success" or state == "Respawning" and "Warning" or "Muted"
		end
		table.insert(rows, { Text = boss.Name, Value = value, Tone = tone })
	end
	return rows
end

do
	local seen = {}
	for rank, tier in ipairs(Const.HUNT_TIERS) do
		BossHunt.Rank[tier] = rank
	end
	for _, hunt in ipairs(Game.BossHunts.Hunts) do
		if type(hunt.Tier) == "string" and not seen[hunt.Tier] then
			seen[hunt.Tier] = true
			table.insert(BossHunt.Options, hunt.Tier)
		end
	end
	table.sort(BossHunt.Options, function(a, b)
		return (BossHunt.Rank[a] or math.huge) < (BossHunt.Rank[b] or math.huge)
	end)
end

function BossHunt.bossFor(code)
	for _, boss in ipairs(WorldBoss.List) do
		if boss.Code == code then
			return boss
		end
	end
	return nil
end

function BossHunt.sides()
	local data = Game.data()
	local race = data and data.Race.Value
	local sides = {}
	for name, side in pairs(Game.BossHunts.Sides) do
		if type(side.Race) == "table" and table.find(side.Race, race) then
			sides[name] = true
		end
	end
	return sides
end

function BossHunt.active()
	local holder = Game.questHolder()
	if not holder then
		return nil
	end
	for _, quest in ipairs(holder:GetChildren()) do
		local questString = quest:FindFirstChild("QuestString")
		local ok, category = pcall(Game.Quests.GetQuestCategory, questString and questString.Value)
		if ok and category == "BossHunt" then
			local tasks = quest:FindFirstChild("Tasks")
			local config = tasks and tasks:GetChildren()[1]
			local code = config and config:FindFirstChild("Code")
			return quest, code and code.Value
		end
	end
	return nil
end

function BossHunt.timeLeft(quest)
	local timer = quest:FindFirstChild("Timer")
	local started = timer and timer:FindFirstChild("Started")
	local target = timer and timer:FindFirstChild("Target")
	if not started or not target then
		return nil
	end
	return started.Value + target.Value - Workspace:GetServerTimeNow()
end

function BossHunt.board()
	local folder = ReplicatedStorage:FindFirstChild("BossHunts")
	local list = {}
	if not folder then
		return list
	end
	local sides = BossHunt.sides()
	local now = Workspace:GetServerTimeNow()
	for _, item in ipairs(folder:GetChildren()) do
		local side, quest, expires = item:GetAttribute("Side"), item:GetAttribute("Quest"), item:GetAttribute("ExpiresAt")
		if sides[side] and type(quest) == "string" and type(expires) == "number" and expires > now then
			local entry = Game.BossHunts.Entry(item:GetAttribute("Boss"))
			local ok, eligible = pcall(Game.BossHunts.Eligible, entry, LocalPlayer)
			table.insert(list, {
				Id = item.Name,
				Quest = quest,
				Boss = item:GetAttribute("Boss"),
				Tier = item:GetAttribute("Tier"),
				ExpiresAt = expires,
				Entry = entry,
				Eligible = entry ~= nil and ok and eligible == true,
			})
		end
	end
	table.sort(list, function(a, b)
		local left, right = BossHunt.Rank[a.Tier] or math.huge, BossHunt.Rank[b.Tier] or math.huge
		if left ~= right then
			return left < right
		end
		return a.ExpiresAt < b.ExpiresAt
	end)
	return list
end

function BossHunt.pick()
	local picked = {}
	for _, tier in ipairs(Settings.HuntTiers) do
		picked[tier] = true
	end
	local everything = next(picked) == nil
	local now = Workspace:GetServerTimeNow()
	local best, bestRank, bestReady = nil, math.huge, math.huge
	for _, hunt in ipairs(BossHunt.board()) do
		local blocked = BossHunt.Blocked[hunt.Id]
		if hunt.Eligible and (everything or picked[hunt.Tier]) and not (blocked and os.clock() < blocked) then
			local boss = BossHunt.bossFor(hunt.Entry.Code)
			if boss then
				local rank = BossHunt.Rank[hunt.Tier] or math.huge
				local ready = WorldBoss.model(boss) and now or WorldBoss.spawnAt(boss) or math.huge
				if rank < bestRank or (rank == bestRank and ready < bestReady) then
					best, bestRank, bestReady = hunt, rank, ready
				end
			end
		end
	end
	return best
end

function BossHunt.set(ctx, phase, boss, tier)
	BossHunt.Phase = phase
	BossHunt.Boss = boss
	BossHunt.Tier = tier or BossHunt.Tier
	ctx:setStatus(boss and (phase .. " " .. boss) or phase)
end

function BossHunt.claim(ctx, hunt)
	local ok, canAdd = pcall(Game.Quests.CanAddQuest, LocalPlayer, hunt.Quest)
	if not ok or canAdd ~= true then
		BossHunt.Blocked[hunt.Id] = os.clock() + Const.HUNT_RETRY
		return false
	end
	BossHunt.set(ctx, "Claiming", hunt.Boss, hunt.Tier)
	Game.fire("BossHuntsRequest", { action = "Claim", id = hunt.Id })
	if ctx:waitFor(function()
		return BossHunt.active() ~= nil
	end, Const.HUNT_CLAIM_TIMEOUT) then
		return true
	end
	BossHunt.Blocked[hunt.Id] = os.clock() + Const.HUNT_RETRY
	return false
end

function BossHunt.fight(ctx, boss)
	if not Character.alive() then
		Combat.BossTarget = nil
		ctx.Lease:SetGoal(nil)
		BossHunt.set(ctx, "Respawning", boss.Name)
		ctx:sleep(0.5)
		return
	end
	local center = WorldBoss.center(boss)
	local model = WorldBoss.model(boss)
	if model then
		Priority.set(ctx, "Engaged")
		ctx.Lease:SetGoal(function()
			local current = WorldBoss.model(boss)
			local targetRoot = current and current:FindFirstChild("HumanoidRootPart")
			if targetRoot and (targetRoot.Position - center).Magnitude <= Const.BOSS_ENGAGE_RANGE then
				return Pose.around(targetRoot)
			end
			return BossFarm.hover(center)
		end)
		Combat.BossTarget = model
		BossHunt.set(ctx, "Fighting", boss.Name)
		ctx:sleep(Const.BOSS_POLL)
		return
	end
	Combat.BossTarget = nil
	local goal = BossFarm.hover(center)
	local root = Character.root()
	if root and (root.Position - goal.Position).Magnitude > Const.ARRIVE_DISTANCE * 4 then
		BossHunt.set(ctx, "Travelling", boss.Name)
		ctx.Lease:MoveTo(goal, function()
			return ctx.Cancelled or not Character.alive() or WorldBoss.model(boss) ~= nil or BossHunt.active() == nil or Priority.blocked(ctx.Job) ~= nil
		end)
		return
	end
	ctx.Lease:SetGoal(function()
		return goal
	end)
	BossFarm.requestStream(center)
	BossHunt.set(ctx, "Waiting", boss.Name)
	ctx:waitFor(function()
		return WorldBoss.model(boss) ~= nil or BossHunt.active() == nil or not Character.alive() or Priority.blocked(ctx.Job) ~= nil
	end, 1)
end

function BossHunt.idle(ctx, phase, seconds)
	if BossHunt.Busy then
		BossHunt.Busy = false
		Combat.BossTarget = nil
	end
	ctx.Lease:SetGoal(nil)
	BossHunt.set(ctx, phase)
	ctx:sleep(seconds)
end

function BossHunt.step(ctx)
	local quest, code = BossHunt.active()
	local boss = quest and code and BossHunt.bossFor(code)
	if not quest and BossHunt.Quest then
		BossHunt.Quest = nil
		BossHunt.Finished += 1
		BossHunt.RestUntil = os.clock() + (tonumber(Settings.HuntNextDelay) or 0)
		local root = Character.root()
		BossHunt.RestHold = root and root.CFrame or nil
	end
	local hunt = not quest and BossHunt.pick() or nil
	if boss and Priority.engaged(ctx) and WorldBoss.model(boss) then
		Priority.set(ctx, "Engaged")
	else
		Priority.set(ctx, (boss or hunt) and "Want" or nil)
	end
	if quest then
		BossHunt.Quest = quest
		if not boss then
			BossHunt.idle(ctx, "No spawn known for " .. tostring(code), 2)
			return
		end
	end
	local other = Priority.blocked(ctx.Job)
	if other then
		BossHunt.idle(ctx, Priority.pausedFor(other), Const.PRIORITY_POLL)
		return
	end
	if boss then
		BossHunt.Busy = true
		local entry = Game.BossHunts.Entry(boss.Name)
		BossHunt.Tier = entry and entry.Tier or BossHunt.Tier
		BossHunt.fight(ctx, boss)
		return
	end
	if not hunt then
		BossHunt.Tier = nil
		BossHunt.idle(ctx, "Waiting for a hunt", 1)
		return
	end
	local left = BossHunt.RestUntil - os.clock()
	if left > 0 then
		BossHunt.idle(ctx, string.format("Next hunt in %ds", math.ceil(left)), 0)
		local hold = Character.alive() and BossHunt.RestHold
		ctx.Lease:SetGoal(hold and function()
			return hold
		end or nil)
		ctx:sleep(math.min(left, 0.5))
		return
	end
	BossHunt.RestHold = nil
	BossHunt.claim(ctx, hunt)
end

function BossHunt.stop()
	local ctx = BossHunt.Context
	local thread = BossHunt.Thread
	BossHunt.Context = nil
	BossHunt.Thread = nil
	BossHunt.Phase = "Off"
	BossHunt.Boss = nil
	BossHunt.Quest = nil
	BossHunt.RestUntil = 0
	BossHunt.RestHold = nil
	if BossHunt.Busy then
		BossHunt.Busy = false
		Combat.BossTarget = nil
	end
	if ctx then
		ctx.Cancelled = true
		Priority.release(ctx)
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function BossHunt.refresh()
	if not Settings.BossHunt then
		BossHunt.stop()
		return
	end
	if BossHunt.Context then
		return
	end
	local ctx = Context.new(Mover.acquire("hunt", 16))
	Priority.bind(ctx, "Hunt")
	BossHunt.Context = ctx
	BossHunt.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(BossHunt.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] Muzan/Crow error: " .. tostring(err))
				Combat.BossTarget = nil
				ctx.Lease:SetGoal(nil)
				BossHunt.set(ctx, "Error, retrying")
				ctx:sleep(1)
			end
		end
	end)
end

function BossHunt.huntText()
	local quest, code = BossHunt.active()
	if not quest then
		return nil
	end
	local boss = code and BossHunt.bossFor(code)
	local left = BossHunt.timeLeft(quest)
	local text = (boss and boss.Name or tostring(code)) .. (BossHunt.Tier and (" (" .. BossHunt.Tier .. ")") or "")
	if boss then
		text ..= "  " .. BossFarm.stateText(boss)
	end
	if left then
		text ..= ", " .. WorldBoss.clock(math.max(left, 0)) .. " left"
	end
	return text
end

function BossHunt.boardRows()
	local picked = {}
	for _, tier in ipairs(Settings.HuntTiers) do
		picked[tier] = true
	end
	local everything = next(picked) == nil
	local now = Workspace:GetServerTimeNow()
	local rows = {}
	for _, hunt in ipairs(BossHunt.board()) do
		local tone = "Muted"
		if hunt.Eligible and (everything or picked[hunt.Tier]) then
			tone = "Success"
		end
		local value = tostring(hunt.Tier) .. "  " .. WorldBoss.clock(hunt.ExpiresAt - now)
		if not hunt.Eligible then
			value ..= "  (level)"
		end
		table.insert(rows, { Text = tostring(hunt.Boss), Value = value, Tone = tone })
	end
	return rows
end

RootMaid:Give(BossHunt.stop)

local Travel = { Context = nil, Thread = nil, Status = "Idle", Npcs = {}, NpcOptions = {}, Places = {}, PlaceOptions = {}, MuzanPaths = {}, HorseSpawns = {} }

function Travel.safezoneCenter(region)
	for _, situation in ipairs(type(region.Situations) == "table" and region.Situations or {}) do
		if type(situation) == "table" and situation.Name == "Safezone" and typeof(situation.Center) == "Vector2" then
			local center = situation.Center
			local height, bestDistance = nil, math.huge
			for key, npc in pairs(type(region.Npcs) == "table" and region.Npcs or {}) do
				local spawn = Travel.Npcs[type(npc) == "table" and npc.Name or key]
				if spawn then
					local distance = (Vector2.new(spawn.X, spawn.Z) - center).Magnitude
					if distance < bestDistance then
						height, bestDistance = spawn.Y, distance
					end
				end
			end
			if height then
				return Vector3.new(center.X, height, center.Y)
			end
		end
	end
	return nil
end

do
	local labels = {}
	for _, region in pairs(Game.Regions.Regions) do
		for _, npc in pairs(type(region) == "table" and type(region.Npcs) == "table" and region.Npcs or {}) do
			local sendOver = type(npc) == "table" and type(npc.SendOver) == "table" and npc.SendOver or nil
			if sendOver and type(npc.Name) == "string" then
				if sendOver.Code == "Spy" then
					labels[npc.Name] = "Spy " .. string.gsub(npc.Name, "%*", "")
				elseif sendOver.Profile == "Civilian" and not labels[npc.Name] then
					labels[npc.Name] = npc.Name .. " (Non-hostile)"
				end
			end
		end
	end
	for name, position in pairs(Game.Regions.NpcSpawns) do
		if type(name) == "string" and typeof(position) == "Vector3" then
			Travel.Npcs[name] = position
			local label = labels[name] or name
			Travel.Npcs[label] = position
			table.insert(Travel.NpcOptions, label)
		end
	end
	table.sort(Travel.NpcOptions)

	local function addPlace(name, position)
		if type(name) == "string" and typeof(position) == "Vector3" and not Travel.Places[name] then
			Travel.Places[name] = position
			table.insert(Travel.PlaceOptions, name)
		end
	end
	for regionName, region in pairs(Game.Regions.Regions) do
		if type(region) == "table" and regionName ~= "Misc" then
			local position = type(region.Spawns) == "table" and region.Spawns[1] or nil
			if typeof(position) ~= "Vector3" and typeof(region.CrystalAt) == "CFrame" then
				position = region.CrystalAt.Position
			end
			if typeof(position) ~= "Vector3" then
				position = Travel.safezoneCenter(region)
			end
			if typeof(position) ~= "Vector3" and type(region.Npcs) == "table" then
				local names = {}
				for key, npc in pairs(region.Npcs) do
					local npcName = type(npc) == "table" and npc.Name or key
					if Travel.Npcs[npcName] then
						table.insert(names, npcName)
					end
				end
				table.sort(names)
				position = names[1] and Travel.Npcs[names[1]]
			end
			if typeof(position) ~= "Vector3" then
				for _, mob in ipairs(Catalog.Mobs) do
					if mob.Region == regionName and mob.Center then
						position = mob.Center
						break
					end
				end
			end
			addPlace(regionName, position)
			for _, shrine in ipairs(type(region.Shrines) == "table" and region.Shrines or {}) do
				if type(shrine) == "table" and typeof(shrine.At) == "CFrame" then
					addPlace(shrine.Name, shrine.At.Position)
				end
			end
		end
	end
	table.sort(Travel.PlaceOptions)

	for _, path in ipairs(Game.MuzanNpc and Game.MuzanNpc.Spawns or {}) do
		if type(path) == "table" and #path > 0 then
			local sum = Vector3.zero
			for _, point in ipairs(path) do
				sum += point
			end
			table.insert(Travel.MuzanPaths, sum / #path)
		end
	end

	local misc = Game.Content and Game.Content:FindFirstChild("Misc")
	local npcs = misc and misc:FindFirstChild("Npcs")
	local horseModule = npcs and npcs:FindFirstChild("Horse")
	local ok, horseConfig = false, nil
	if horseModule and horseModule:IsA("ModuleScript") then
		ok, horseConfig = pcall(require, horseModule)
	end
	local sendOver = ok and type(horseConfig) == "table" and horseConfig.SendOver
	local spawning = type(sendOver) == "table" and sendOver.Spawning
	local locations = type(spawning) == "table" and spawning.Locations
	for _, location in ipairs(type(locations) == "table" and locations or {}) do
		if typeof(location) == "Vector3" then
			table.insert(Travel.HorseSpawns, location)
		end
	end
end

function Travel.minutes(seconds)
	seconds = math.max(seconds, 0)
	if seconds >= 60 then
		return math.ceil(seconds / 60) .. "m"
	end
	return math.ceil(seconds) .. "s"
end

function Travel.stop()
	local ctx = Travel.Context
	local thread = Travel.Thread
	Travel.Context = nil
	Travel.Thread = nil
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function Travel.start(label, job)
	Travel.stop()
	local ctx = Context.new(Mover.acquire("travel", 25))
	Travel.Context = ctx
	Travel.Status = "Going to " .. label
	Travel.Thread = task.spawn(function()
		local ok, err = pcall(job, ctx)
		if not ok and not ctx.Cancelled then
			warn("[Spryzen Hub] travel error: " .. tostring(err))
			Travel.Status = "Error: " .. tostring(err)
		end
		ctx.Lease:Release()
		if Travel.Context == ctx then
			Travel.Context = nil
			Travel.Thread = nil
		end
	end)
end

function Travel.toPosition(ctx, label, position)
	if ctx:moveTo(position + Vector3.new(0, Const.TRAVEL_HEIGHT, 0)) then
		Travel.Status = "Arrived at " .. label
	elseif not ctx.Cancelled then
		Travel.Status = "Could not reach " .. label
	end
end

function Travel.goTo(label, position)
	if typeof(position) ~= "Vector3" then
		Travel.Status = "Pick a destination"
		return
	end
	Travel.start(label, function(ctx)
		Travel.toPosition(ctx, label, position)
	end)
end

function Travel.muzanModel()
	local debree = Workspace:FindFirstChild("Debree")
	local regions = debree and debree:FindFirstChild("Regions")
	local misc = regions and regions:FindFirstChild("Misc")
	local folder = misc and misc:FindFirstChild("StationaryNpcs")
	local model = folder and folder:FindFirstChild("Muzan")
	if model and model:IsA("Model") then
		return model
	end
	return nil
end

function Travel.searchMuzan(ctx, report)
	for index, center in ipairs(Travel.MuzanPaths) do
		if Travel.muzanModel() or ctx.Cancelled then
			break
		end
		report(string.format("Searching Muzan's path %d of %d", index, #Travel.MuzanPaths))
		local hover = center + Vector3.new(0, Const.MUZAN_HOVER, 0)
		if ctx:moveTo(hover) then
			Mover.requestStream(center)
			ctx:waitFor(function()
				return Travel.muzanModel() ~= nil
			end, Const.MUZAN_SCAN)
		end
	end
	return Travel.muzanModel()
end

function Travel.findMuzan(ctx)
	local model = Travel.searchMuzan(ctx, function(text)
		Travel.Status = text
	end)
	if ctx.Cancelled then
		return
	end
	if not model then
		Travel.Status = "Muzan not found on his paths"
		return
	end
	Travel.toPosition(ctx, "Muzan", model:GetPivot().Position)
end

function Travel.muzanText()
	local left = Game.DayNight.SecondsUntilPhaseChange()
	if Game.DayNight.IsNight() then
		return "On patrol, dawn in " .. Travel.minutes(left), "Success"
	end
	return "Hidden, back at night in " .. Travel.minutes(left), "Muted"
end

function Travel.marketer()
	local config = Game.BlackMarketer
	local state = Game.TimedVendor.GetState(config.TimedVendor)
	local index = Game.TimedVendor.GetSpotIndex(config.TimedVendor, state.Cycle, #config.Spawns)
	return state, config.Spawns[index]
end

function Travel.marketerText()
	local state = Travel.marketer()
	if state.Active then
		return "In town, leaves in " .. Travel.minutes(state.NextEdgeIn), "Success"
	end
	return "Away, back in " .. Travel.minutes(state.NextEdgeIn), "Muted"
end

function Travel.spiderLilies()
	local debree = Workspace:FindFirstChild("Debree")
	local list = {}
	if not debree then
		return list
	end
	for _, child in ipairs(debree:GetChildren()) do
		if child.Name == "Spider Lily" and child:IsA("Model") then
			table.insert(list, child)
		end
	end
	return list
end

function Travel.findLily()
	local root = Character.root()
	local best, bestDistance = nil, math.huge
	for _, lily in ipairs(Travel.spiderLilies()) do
		local distance = root and (lily:GetPivot().Position - root.Position).Magnitude or 0
		if distance < bestDistance then
			best, bestDistance = lily, distance
		end
	end
	if not best then
		Travel.Status = "No Spider Lily in the world right now"
		return
	end
	local position = best:GetPivot().Position
	Travel.start("Spider Lily", function(ctx)
		Travel.toPosition(ctx, "Spider Lily", position)
	end)
end

function Travel.horses()
	local list = {}
	local debree = Workspace:FindFirstChild("Debree")
	local regions = debree and debree:FindFirstChild("Regions")
	if not regions then
		return list
	end
	for _, region in ipairs(regions:GetChildren()) do
		local active = region:FindFirstChild("ActiveNpcs")
		local folder = active and active:FindFirstChild("Horse")
		if folder then
			for _, horse in ipairs(folder:GetChildren()) do
				if horse:IsA("Model") and horse:FindFirstChildWhichIsA("BasePart") then
					table.insert(list, horse)
				end
			end
		end
	end
	return list
end

function Travel.nearestHorse()
	local root = Character.root()
	local best, bestDistance = nil, math.huge
	for _, horse in ipairs(Travel.horses()) do
		local distance = root and (horse:GetPivot().Position - root.Position).Magnitude or 0
		if distance < bestDistance then
			best, bestDistance = horse, distance
		end
	end
	return best
end

function Travel.searchHorse(ctx)
	local root = Character.root()
	local spawns = table.clone(Travel.HorseSpawns)
	if root then
		local origin = root.Position
		table.sort(spawns, function(a, b)
			return (a - origin).Magnitude < (b - origin).Magnitude
		end)
	end
	for index, spawn in ipairs(spawns) do
		if ctx.Cancelled or Travel.nearestHorse() then
			break
		end
		Travel.Status = string.format("Searching horse spawn %d of %d", index, #spawns)
		if ctx:moveTo(spawn + Vector3.new(0, Const.HORSE_HOVER, 0)) then
			Mover.requestStream(spawn)
			ctx:waitFor(function()
				return Travel.nearestHorse() ~= nil
			end, Const.HORSE_SCAN)
		end
	end
	return Travel.nearestHorse()
end

function Travel.findHorse(ctx)
	local horse = Travel.nearestHorse() or Travel.searchHorse(ctx)
	if ctx.Cancelled then
		return
	end
	if not horse then
		Travel.Status = "No wild horse found"
		return
	end
	for _ = 1, Const.HORSE_CHASES do
		if ctx.Cancelled or not horse.Parent then
			break
		end
		local position = horse:GetPivot().Position
		if not ctx:moveTo(position + Vector3.new(0, Const.TRAVEL_HEIGHT, 0)) then
			break
		end
		local root = Character.root()
		if horse.Parent and root and (horse:GetPivot().Position - root.Position).Magnitude <= Const.HORSE_REACH then
			Travel.Status = "Arrived at Wild Horse"
			return
		end
	end
	if not ctx.Cancelled then
		Travel.Status = horse.Parent and "Could not reach Wild Horse" or "Wild horse despawned"
	end
end

function Travel.horseText()
	local count = #Travel.horses()
	if count == 0 then
		return "None nearby", "Muted"
	end
	return count .. " nearby", "Success"
end

function Travel.lilyText()
	local count = #Travel.spiderLilies()
	if count == 0 then
		return "None in the world", "Muted"
	end
	return count .. " in the world", "Success"
end

RootMaid:Give(Travel.stop)

local Demon = { Thread = nil, Context = nil, UsingItem = false, Pressed = false, LilySkip = {}, RepOptions = {}, RepByOption = {} }

do
	local candidates = {}
	local nameCounts = {}
	for _, mob in ipairs(Catalog.Mobs) do
		if mob.Reputation > 0 and not mob.Boss and mob.Center then
			table.insert(candidates, mob)
			nameCounts[mob.Name] = (nameCounts[mob.Name] or 0) + 1
		end
	end
	for _, mob in ipairs(candidates) do
		local label = nameCounts[mob.Name] > 1 and (mob.Name .. " (" .. mob.Region .. ")") or mob.Name
		if not Demon.RepByOption[label] then
			Demon.RepByOption[label] = mob
			table.insert(Demon.RepOptions, label)
		end
	end
	table.sort(Demon.RepOptions)
end

Demon.StageText = {
	Reputation = "1/6 Lower your reputation",
	Bell = "2/6 Get the Biwa Bell from Muzan",
	Lair = "3/6 Take Muzan's task in his lair",
	Lilies = "4/6 Collect Spider Lilies",
	Doctor = "5/6 Deliver Dr. Higoshima",
	Completing = "5/6 Waiting for Muzan's Blood",
	Drink = "6/6 Drink Muzan's Blood",
}

function Demon.item(name)
	local data = Game.data()
	local inventory = data and data.Inventory:FindFirstChild("Inventory")
	return inventory and inventory:FindFirstChild(name)
end

function Demon.reputation()
	local data = Game.data()
	local value = data and data:FindFirstChild("Reputation")
	return value and value.Value or 0
end

function Demon.inLair()
	return LocalPlayer:GetAttribute(Game.MuzanSettings.LairAttribute) == true
end

function Demon.inCombat()
	return Game.InCombat.biasedCheck(LocalPlayer) == true
end

function Demon.stage()
	local data = Game.data()
	if not data then
		return "Loading", "Waiting for player data"
	end
	local race = data.Race.Value
	if race == "Demon" or race == "Hybrid" then
		return "Done", "Done, you are a " .. race
	end
	if race ~= "Human" then
		return "Blocked", "Only Humans can become Demons (you are " .. tostring(race) .. ")"
	end
	if Demon.item(Const.DEMON_BLOOD) then
		return "Drink", Demon.StageText.Drink
	end
	local quest = Game.findActiveQuest(Const.DEMON_QUEST)
	if quest then
		local _, lilies, lilyMax = QuestRunner.taskValues(quest, Const.DEMON_LILY_TASK)
		if lilies < lilyMax then
			return "Lilies", string.format("%s (%d/%d)", Demon.StageText.Lilies, lilies, lilyMax), quest
		end
		local _, delivered, deliverMax = QuestRunner.taskValues(quest, Const.DEMON_DOCTOR_TASK)
		if delivered < deliverMax then
			return "Doctor", Demon.StageText.Doctor, quest
		end
		return "Completing", Demon.StageText.Completing, quest
	end
	if Demon.inLair() then
		return "Lair", Demon.StageText.Lair
	end
	local muzan = Game.MuzanSettings
	local reputation = Demon.reputation()
	if Demon.item(Const.DEMON_BELL) then
		if reputation >= muzan.LairEntryReputation then
			return "Reputation", string.format("%s (%d, below %d to enter the lair)", Demon.StageText.Reputation, math.floor(reputation), muzan.LairEntryReputation)
		end
		return "Lair", Demon.StageText.Lair
	end
	if reputation > muzan.EligibleReputation then
		return "Reputation", string.format("%s (%d / %d)", Demon.StageText.Reputation, math.floor(reputation), muzan.EligibleReputation)
	end
	return "Bell", Demon.StageText.Bell
end

function Demon.stageTone(key)
	if key == "Done" then
		return "Success"
	elseif key == "Blocked" then
		return "Warning"
	elseif key == "Loading" then
		return "Muted"
	end
	return "Accent"
end

function Demon.calm(ctx)
	if not Demon.inCombat() then
		if ctx.CalmFrom then
			local origin = ctx.CalmFrom
			ctx.CalmFrom = nil
			ctx:setStatus("Out of combat, heading back")
			ctx:moveTo(origin)
			return false
		end
		return true
	end
	local root = Character.root()
	if root and not ctx.CalmFrom then
		ctx.CalmFrom = root.Position
		local spot = CFrame.new(root.Position + Vector3.new(0, Const.RETREAT_HEIGHT, 0))
		ctx.Lease:SetGoal(function()
			return spot
		end)
	end
	ctx:setStatus(string.format("Leaving combat (%ds)", math.ceil(Game.InCombat.biasedTimeLeft(LocalPlayer) or 0)))
	ctx:sleep(Const.DEMON_CALM_POLL)
	return false
end

function Demon.holding(character, marker)
	local accessories = character and character:FindFirstChild("Tool_Accessories")
	return accessories ~= nil and (marker == nil or accessories:GetAttribute("Value") ~= marker)
end

function Demon.release()
	if Demon.Pressed then
		Demon.Pressed = false
		Game.release("Screen")
	end
end

function Demon.finishItem()
	Demon.release()
	if Demon.UsingItem then
		Demon.UsingItem = false
		Potion.Busy = false
	end
end

function Demon.slotFor(toolbar, id)
	for slot, slotName in ipairs(Const.SLOT_NAMES) do
		local entry = toolbar:FindFirstChild(slotName)
		if entry and entry.Value == id then
			return slot
		end
	end
	return nil
end

function Demon.pressItem(ctx, name, action, confirm, timeout, hold)
	local entry = Demon.item(name)
	local id = entry and entry:FindFirstChild("Id")
	local data = Game.data()
	local toolbar = data and data.Inventory:FindFirstChild("Toolbar")
	local config = LocalPlayer:FindFirstChild("Items_Config")
	local equipped = config and config:FindFirstChild("Equipped")
	if not id or id.Value == 0 then
		return false, "No " .. name .. " in your inventory"
	end
	if not toolbar or not equipped then
		return false, "Toolbar not ready"
	end
	local character = LocalPlayer.Character
	local slot = Demon.slotFor(toolbar, id.Value)
	if not slot then
		slot = math.clamp(tonumber(Settings.PotionSlot) or #Const.SLOT_NAMES, 1, #Const.SLOT_NAMES)
		ctx:setStatus("Putting " .. name .. " on slot " .. slot)
		Game.fire("Toolbar_Equip", Const.SLOT_NAMES[slot], id.Value)
		if not ctx:waitFor(function()
			return Demon.slotFor(toolbar, id.Value) == slot
		end, Const.DEMON_ITEM_TIMEOUT) then
			return false, "Could not put " .. name .. " on slot " .. slot
		end
	end
	local previous = equipped.Value
	if previous ~= slot then
		local accessories = character and character:FindFirstChild("Tool_Accessories")
		local marker = accessories and accessories:GetAttribute("Value") or ""
		equipped.Value = slot
		if not ctx:waitFor(function()
			return Demon.holding(LocalPlayer.Character, marker)
		end, Const.DEMON_ITEM_TIMEOUT) then
			return false, "Could not equip " .. name, previous, slot
		end
	end
	if not ctx:waitFor(function()
		return Game.Checker.check(LocalPlayer, nil, action) == true
	end, Const.DEMON_ITEM_TIMEOUT) then
		return false, "Can't use " .. name .. " yet, stunned or busy", previous, slot
	end
	ctx:setStatus("Using " .. name)
	Demon.Pressed = true
	Game.press("Screen")
	task.wait(hold or Const.DEMON_PRESS_HOLD)
	Demon.release()
	if ctx:waitFor(confirm, timeout) then
		return true, "Used " .. name, previous, slot
	end
	return false, name .. " had no effect, retrying", previous, slot
end

function Demon.useItem(ctx, name, action, confirm, timeout, hold)
	if Potion.Busy then
		return false, "Waiting for the potion drink to finish"
	end
	Potion.Busy = true
	Demon.UsingItem = true
	Combat.setPressing(false)
	ctx.Lease:SetGoal(nil)
	local ok, used, text, previous, slot = pcall(Demon.pressItem, ctx, name, action, confirm, timeout, hold)
	local config = LocalPlayer:FindFirstChild("Items_Config")
	local equipped = config and config:FindFirstChild("Equipped")
	if ok and previous and equipped and previous ~= slot and equipped.Value == slot then
		equipped.Value = previous
	end
	Demon.finishItem()
	if not ok then
		error(used, 0)
	end
	return used, text
end

function Demon.standBy(model)
	local pivot = model:GetPivot()
	local position = pivot.Position + pivot.LookVector * Const.DEMON_TALK_DISTANCE
	return CFrame.lookAt(position, pivot.Position)
end

function Demon.near(model)
	local root = Character.root()
	return root ~= nil and model.Parent ~= nil and (root.Position - model:GetPivot().Position).Magnitude <= Const.DEMON_TALK_DISTANCE + 2
end

function Demon.approach(ctx, model, label)
	ctx:setStatus("Going to " .. label)
	if not Demon.near(model) and not ctx:moveTo(Demon.standBy(model).Position) then
		return false
	end
	ctx.Lease:SetGoal(function()
		if model.Parent then
			return Demon.standBy(model)
		end
		return nil
	end)
	return ctx:waitFor(function()
		return ctx.Lease:IsActive() and Demon.near(model)
	end, Const.DEMON_APPROACH_TIMEOUT)
end

function Demon.closeDialogue()
	local ok, err = pcall(Game.DialogueUtility.Close)
	if not ok then
		warn("[Spryzen Hub] dialogue close error: " .. tostring(err))
	end
end

function Demon.talk(ctx, model, signal, done)
	Game.fire(signal)
	if ctx:waitFor(done, Const.DEMON_TALK_TIMEOUT) then
		return true
	end
	local prompt = model.Parent and model:FindFirstChildWhichIsA("ProximityPrompt", true)
	if not prompt or not prompt.Enabled then
		return false
	end
	Prompts.trigger(prompt, function()
		return ctx.Cancelled
	end)
	ctx:sleep(Const.DEMON_DIALOGUE_SETTLE)
	Game.fire(signal)
	local ok = ctx:waitFor(done, Const.DEMON_TALK_TIMEOUT)
	Demon.closeDialogue()
	return ok
end

function Demon.selectedRepMobs()
	local selected = {}
	for _, label in ipairs(Settings.DemonRepMobs) do
		local mob = Demon.RepByOption[label]
		if mob then
			selected[mob] = true
		end
	end
	return selected
end

function Demon.reputationStep(ctx)
	local selected = Demon.selectedRepMobs()
	local everything = next(selected) == nil
	local function accept(entry)
		return entry.Reputation > 0 and not entry.Boss and (everything or selected[entry] == true)
	end
	for model, at in pairs(ctx.Skip) do
		if os.clock() - at > Const.SKIP_TARGET_FOR or not model.Parent then
			ctx.Skip[model] = nil
		end
	end
	local root = Character.root()
	local best, bestDistance = nil, math.huge
	if root then
		Mobs.eachAlive(function(model, mobRoot, entry)
			if entry and accept(entry) and ctx.Skip[model] == nil then
				local distance = (mobRoot.Position - root.Position).Magnitude
				if distance < bestDistance then
					best, bestDistance = model, distance
				end
			end
		end)
	end
	if best then
		ctx:setStatus("Killing " .. best.Name .. " for reputation")
		Hunt.engage(ctx, best)
		return
	end
	local spawn = Hunt.nearestSpawn(accept)
	if not spawn then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus("No spawn known for the picked reputation mobs")
		ctx:sleep(2)
		return
	end
	ctx:setStatus("Waiting at " .. spawn.Name .. " spawn")
	ctx:moveTo(spawn.Center + Vector3.new(0, Const.SPAWN_WAIT_HEIGHT, 0))
	ctx:sleep(0.5)
end

function Demon.bellStep(ctx)
	if not Game.DayNight.IsNight() then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus("Muzan walks at night, night in " .. Travel.minutes(Game.DayNight.SecondsUntilPhaseChange()))
		ctx:sleep(1)
		return
	end
	local model = Travel.muzanModel() or Travel.searchMuzan(ctx, function(text)
		ctx:setStatus(text)
	end)
	if ctx.Cancelled then
		return
	end
	if not model then
		ctx:setStatus("Muzan not found on his paths, searching again")
		ctx:sleep(1)
		return
	end
	if not Demon.approach(ctx, model, "Muzan") then
		return
	end
	ctx:setStatus("Asking Muzan for the Biwa Bell")
	if not Demon.talk(ctx, model, "MuzanGiveBell", function()
		return Demon.item(Const.DEMON_BELL) ~= nil
	end) then
		ctx:setStatus("Muzan did not hand over the bell, retrying")
		ctx:sleep(1)
	end
end

function Demon.lairMuzan()
	local debree = Workspace:FindFirstChild("Debree")
	local model = debree and debree:FindFirstChild(Const.DEMON_LAIR_MODEL)
	if model and model:IsA("Model") then
		return model
	end
	return nil
end

function Demon.ringBell(ctx, entering)
	if entering and not Demon.calm(ctx) then
		return
	end
	ctx:setStatus(entering and "Ringing the Biwa Bell to enter the lair" or "Ringing the Biwa Bell to leave the lair")
	local ok, text = Demon.useItem(ctx, Const.DEMON_BELL, "BiwaBell", function()
		return Demon.inLair() == entering
	end, Const.DEMON_RING_TIMEOUT)
	if ok then
		ctx:setStatus(entering and "Entered Muzan's lair" or "Left Muzan's lair")
		ctx:sleep(1)
	else
		ctx:setStatus(text)
		ctx:sleep(2)
	end
end

function Demon.lairStep(ctx)
	if not Demon.inLair() then
		Demon.ringBell(ctx, true)
		return
	end
	local model = Demon.lairMuzan()
	if not model then
		ctx:setStatus("Waiting for Muzan to appear in the lair")
		ctx:moveTo(Game.MuzanSettings.LairArrival.Position + Const.GROUND_STAND_OFFSET)
		ctx:sleep(1)
		return
	end
	if not Demon.approach(ctx, model, "Muzan in his lair") then
		return
	end
	ctx:setStatus("Taking Muzan's task")
	if not Demon.talk(ctx, model, "MuzanLairAssign", function()
		return Game.findActiveQuest(Const.DEMON_QUEST) ~= nil or Demon.item(Const.DEMON_BLOOD) ~= nil
	end) then
		ctx:setStatus("Muzan did not give his task, retrying")
		ctx:sleep(1)
	end
end

function Demon.lilyStep(ctx, quest)
	if Demon.inLair() then
		Demon.ringBell(ctx, false)
		return
	end
	local now = os.clock()
	for lily, at in pairs(Demon.LilySkip) do
		if now - at > Const.DEMON_LILY_SKIP or not lily.Parent then
			Demon.LilySkip[lily] = nil
		end
	end
	local root = Character.root()
	local best, bestDistance = nil, math.huge
	for _, lily in ipairs(Travel.spiderLilies()) do
		if not Demon.LilySkip[lily] then
			local distance = root and (lily:GetPivot().Position - root.Position).Magnitude or 0
			if distance < bestDistance then
				best, bestDistance = lily, distance
			end
		end
	end
	if not best then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus(Game.DayNight.IsNight() and "Waiting for Spider Lilies to spawn" or "Waiting for Spider Lilies, they bloom at night")
		ctx:sleep(2)
		return
	end
	local _, before = QuestRunner.taskValues(quest, Const.DEMON_LILY_TASK)
	local function picked()
		local _, count = QuestRunner.taskValues(quest, Const.DEMON_LILY_TASK)
		return count > before or not best.Parent or not quest.Parent
	end
	ctx:setStatus("Going to a Spider Lily")
	if not ctx:moveTo(best:GetPivot().Position + Const.GROUND_STAND_OFFSET) then
		if not ctx.Cancelled then
			Demon.LilySkip[best] = os.clock()
		end
		return
	end
	local prompt = nil
	ctx:waitFor(function()
		local found = best.Parent and best:FindFirstChildWhichIsA("ProximityPrompt", true)
		prompt = found and found.Enabled and found or nil
		return prompt ~= nil or picked()
	end, Const.DEMON_LILY_WAIT)
	if prompt and not picked() then
		ctx:setStatus("Picking a Spider Lily")
		Prompts.trigger(prompt, function()
			return ctx.Cancelled or picked()
		end)
		ctx:waitFor(picked, Const.PROGRESS_TIMEOUT)
	end
	if not picked() and not ctx.Cancelled then
		Demon.LilySkip[best] = os.clock()
	end
end

function Demon.deliverTarget()
	local target = LocalPlayer:GetAttribute(Const.DEMON_DELIVER_ATTRIBUTE)
	return typeof(target) == "CFrame" and target or nil
end

function Demon.doctorPrompt(center)
	local checked = {}
	for _, part in ipairs(Workspace:GetPartBoundsInRadius(center, Const.DEMON_DOCTOR_RADIUS)) do
		local node = part.Parent
		while node and node ~= Workspace and not checked[node] do
			checked[node] = true
			if node:IsA("Model") and string.find(node.Name, Const.DEMON_DOCTOR, 1, true) then
				local prompt = node:FindFirstChildWhichIsA("ProximityPrompt", true)
				if prompt and prompt.Enabled then
					return prompt
				end
			end
			node = node.Parent
		end
	end
	return nil
end

function Demon.promptPosition(prompt)
	local parent = prompt.Parent
	if parent and parent:IsA("Attachment") then
		return parent.WorldPosition
	elseif parent and parent:IsA("BasePart") then
		return parent.Position
	end
	local model = prompt:FindFirstAncestorWhichIsA("Model")
	return model and model:GetPivot().Position
end

function Demon.doctorStep(ctx, quest)
	if Demon.inLair() then
		Demon.ringBell(ctx, false)
		return
	end
	local _, before = QuestRunner.taskValues(quest, Const.DEMON_DOCTOR_TASK)
	local function delivered()
		local _, count = QuestRunner.taskValues(quest, Const.DEMON_DOCTOR_TASK)
		return count > before or not quest.Parent
	end
	local target = Demon.deliverTarget()
	if target then
		ctx:setStatus("Carrying Dr. Higoshima to the safe zone")
		if ctx:moveTo(target.Position + Const.GROUND_STAND_OFFSET) then
			ctx:setStatus("Handing over Dr. Higoshima")
			if not ctx:waitFor(function()
				return delivered() or Demon.deliverTarget() == nil
			end, Const.DEMON_DELIVER_TIMEOUT) then
				ctx:setStatus("Safe zone has not taken the doctor yet, retrying")
			end
		end
		return
	end
	local spawn = Game.MuzanSettings.HigoshimaSpawn.Position
	local root = Character.root()
	local prompt = Demon.doctorPrompt(spawn) or (root and Demon.doctorPrompt(root.Position))
	if not prompt then
		ctx:setStatus("Going to Dr. Higoshima")
		if not ctx:moveTo(spawn + Const.NPC_STAND_OFFSET) then
			return
		end
		Mover.requestStream(spawn)
		ctx:waitFor(function()
			prompt = Demon.doctorPrompt(spawn)
			return prompt ~= nil or Demon.deliverTarget() ~= nil
		end, Const.DEMON_DOCTOR_WAIT)
		if Demon.deliverTarget() then
			return
		end
		if not prompt then
			ctx:setStatus("Dr. Higoshima is not at his spot, waiting")
			ctx:sleep(1)
			return
		end
	end
	local position = Demon.promptPosition(prompt)
	ctx:setStatus("Picking up Dr. Higoshima")
	if position and ctx:moveTo(position + Const.NPC_STAND_OFFSET) and prompt.Parent and prompt.Enabled then
		Prompts.trigger(prompt, function()
			return ctx.Cancelled
		end)
		ctx:waitFor(function()
			return Demon.deliverTarget() ~= nil or delivered()
		end, Const.PROGRESS_TIMEOUT)
	end
end

function Demon.drinkStep(ctx)
	if not Demon.calm(ctx) then
		return
	end
	ctx:setStatus("Drinking Muzan's Blood")
	local ok, text = Demon.useItem(ctx, Const.DEMON_BLOOD, "MuzansBlood", function()
		local data = Game.data()
		return data ~= nil and data.Race.Value ~= "Human"
	end, Const.DEMON_DRINK_TIMEOUT)
	ctx:setStatus(ok and "Transformed into a Demon" or text)
	if not ok then
		ctx:sleep(2)
	end
end

function Demon.doneStep(ctx)
	if Demon.inLair() and Demon.item(Const.DEMON_BELL) then
		Demon.ringBell(ctx, false)
		return
	end
	ctx.Lease:SetGoal(nil)
	ctx:setStatus("Finished, nothing left to do")
	ctx:sleep(1)
end

Demon.Steps = {
	Done = Demon.doneStep,
	Reputation = Demon.reputationStep,
	Bell = Demon.bellStep,
	Lair = Demon.lairStep,
	Lilies = Demon.lilyStep,
	Doctor = Demon.doctorStep,
	Drink = Demon.drinkStep,
}

function Demon.step(ctx)
	local key, text, quest = Demon.stage()
	local step = Demon.Steps[key]
	if not step then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus(text)
		ctx:sleep(1)
		return
	end
	if Heal.Retreating or Escape.Active then
		ctx:setStatus(Escape.Active and "Paused, retreating" or "Paused to heal")
		ctx:sleep(0.5)
		return
	end
	if BossFarm.claims() then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus(BossFarm.pauseText())
		ctx:sleep(1)
		return
	end
	if not Character.alive() then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus("Waiting for respawn")
		ctx:sleep(1)
		return
	end
	step(ctx, quest)
end

function Demon.stop()
	local ctx = Demon.Context
	local thread = Demon.Thread
	Demon.Context = nil
	Demon.Thread = nil
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
	Demon.finishItem()
	Combat.FarmTarget = nil
end

function Demon.refresh()
	if not Settings.AutoDemon then
		Demon.stop()
		return
	end
	if Demon.Context then
		return
	end
	local ctx = Context.new(Mover.acquire("demon", 12))
	Demon.Context = ctx
	Demon.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(Demon.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] auto demon error: " .. tostring(err))
				Demon.finishItem()
				Combat.FarmTarget = nil
				ctx.Lease:SetGoal(nil)
				ctx:setStatus("Error, retrying")
				ctx:sleep(1)
			end
		end
	end)
end

function Demon.statusText()
	local ctx = Demon.Context
	if not ctx then
		return "Off", "Muted"
	end
	return ctx.Status, "Success"
end

RootMaid:Give(Demon.stop)

function YetiFarm.active()
	local humanoids = Workspace:FindFirstChild("Humanoids")
	local regions = humanoids and humanoids:FindFirstChild("Regions")
	local temporary = regions and regions:FindFirstChild("Temporary")
	return temporary and temporary:FindFirstChild("ActiveNpcs")
end

function YetiFarm.boss()
	local active = YetiFarm.active()
	if not active then
		return nil
	end
	for _, slot in ipairs(active:GetChildren()) do
		if slot.Name == Const.YETI_BOSS then
			local model = slot:FindFirstChild(Const.YETI_BOSS)
			if model and Mobs.isAlive(model) then
				return model
			end
		end
	end
	return nil
end

function YetiFarm.isMinion(model)
	local slot = model.Parent
	return slot ~= nil and slot.Name == Const.YETI_MINION and slot.Parent ~= nil and slot.Parent == YetiFarm.active()
end

function YetiFarm.nearestMinion()
	local active = YetiFarm.active()
	local root = Character.root()
	if not active or not root then
		return nil, 0
	end
	local best, bestDistance, count = nil, math.huge, 0
	for _, slot in ipairs(active:GetChildren()) do
		if slot.Name == Const.YETI_MINION then
			for _, model in ipairs(slot:GetChildren()) do
				if model:IsA("Model") and Mobs.isAlive(model) then
					count += 1
					local distance = (model.HumanoidRootPart.Position - root.Position).Magnitude
					if distance < bestDistance then
						best, bestDistance = model, distance
					end
				end
			end
		end
	end
	return best, count
end

function YetiFarm.hearts()
	return Game.itemCount(Const.YETI_HEART)
end

function YetiFarm.prompt()
	local map = Workspace:FindFirstChild("Map")
	local inner = map and map:FindFirstChild("Map")
	local berg = inner and inner:FindFirstChild("FrozenYeti")
	local prompt = berg and berg:FindFirstChild("Frozen Yeti", true)
	if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
		return prompt
	end
	return nil
end

function YetiFarm.refreezeIn()
	if not YetiFarm.KilledAt then
		return nil
	end
	local left = YetiFarm.KilledAt + Const.YETI_REFREEZE - Workspace:GetServerTimeNow()
	return left > 0 and left or nil
end

function YetiFarm.set(ctx, phase)
	YetiFarm.Phase = phase
	ctx:setStatus(phase)
end

function YetiFarm.fight(ctx)
	YetiFarm.Busy = true
	local target = nil
	ctx.Lease:SetGoal(function()
		local targetRoot = target and target:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			return Pose.around(targetRoot)
		end
		return CFrame.new(Const.YETI_STAND)
	end)
	local lastBoss, lastAt = nil, nil
	while not ctx.Cancelled and Character.alive() do
		local boss = YetiFarm.boss()
		local minion = YetiFarm.nearestMinion()
		if not boss and not minion then
			break
		end
		lastBoss = boss or lastBoss
		lastAt = Collector.bossPosition(boss) or lastAt
		target = minion or boss
		Combat.BossTarget = target
		YetiFarm.set(ctx, minion and "Killing minions" or "Fighting")
		task.wait(Const.BOSS_POLL)
	end
	Combat.BossTarget = nil
	if ctx.Cancelled then
		return
	end
	local humanoid = lastBoss and lastBoss:FindFirstChildOfClass("Humanoid")
	if lastBoss and (not lastBoss.Parent or (humanoid and humanoid.Health <= 0)) and not YetiFarm.boss() then
		YetiFarm.Kills += 1
		BossStats.record(Const.YETI_BOSS, false)
		YetiFarm.KilledAt = Workspace:GetServerTimeNow()
		local root = Character.root()
		YetiFarm.LootAt = lastAt or (root and root.Position)
		Collector.focus(YetiFarm.LootAt)
		YetiFarm.LootUntil = os.clock() + Const.BOSS_LOOT_WINDOW
		YetiFarm.LootHardUntil = os.clock() + Const.BOSS_LOOT_MAX
	end
end

function YetiFarm.summon(ctx)
	YetiFarm.Busy = true
	local stand = CFrame.new(Const.YETI_STAND)
	local root = Character.root()
	if root and (root.Position - stand.Position).Magnitude > Const.ARRIVE_DISTANCE * 4 then
		YetiFarm.set(ctx, "Travelling")
		ctx.Lease:MoveTo(stand, function()
			return ctx.Cancelled or not Character.alive() or YetiFarm.boss() ~= nil or Priority.blocked(ctx.Job) ~= nil
		end)
		return
	end
	ctx.Lease:SetGoal(function()
		return stand
	end)
	local function spawned()
		return YetiFarm.boss() ~= nil or YetiFarm.nearestMinion() ~= nil
	end
	local prompt = YetiFarm.prompt()
	if not prompt then
		YetiFarm.set(ctx, "Waiting for the berg")
		ctx:waitFor(function()
			prompt = YetiFarm.prompt()
			return prompt ~= nil or spawned() or Priority.blocked(ctx.Job) ~= nil
		end, Const.YETI_PROMPT_WAIT)
		if not prompt or ctx.Cancelled then
			return
		end
	end
	if Priority.blocked(ctx.Job) then
		return
	end
	YetiFarm.set(ctx, "Summoning")
	Prompts.trigger(prompt, function()
		return ctx.Cancelled or spawned()
	end)
	ctx:waitFor(spawned, Const.YETI_SUMMON_TIMEOUT)
end

function YetiFarm.idle(ctx, phase, seconds)
	if YetiFarm.Busy then
		YetiFarm.Busy = false
		Combat.BossTarget = nil
	end
	ctx.Lease:SetGoal(nil)
	YetiFarm.set(ctx, phase)
	ctx:sleep(seconds)
end

function YetiFarm.step(ctx)
	if not Character.alive() then
		YetiFarm.idle(ctx, "Respawning", 0.5)
		return
	end
	local present = YetiFarm.boss() ~= nil or YetiFarm.nearestMinion() ~= nil
	local lootPending = YetiFarm.LootAt ~= nil and (os.clock() < YetiFarm.LootUntil or (os.clock() < YetiFarm.LootHardUntil and Settings.AutoPickup and Collector.pendingNear(YetiFarm.LootAt, Settings.DropRange)))
	local summonable = YetiFarm.hearts() > 0 and not (YetiFarm.refreezeIn() and not YetiFarm.prompt())
	if Priority.engaged(ctx) and (present or lootPending) then
		Priority.set(ctx, "Engaged")
	else
		Priority.set(ctx, (present or lootPending or summonable) and "Want" or nil)
	end
	local other = Priority.blocked(ctx.Job)
	if other then
		YetiFarm.idle(ctx, Priority.pausedFor(other), Const.PRIORITY_POLL)
		return
	end
	if present then
		Priority.set(ctx, "Engaged")
		YetiFarm.fight(ctx)
		return
	end
	if lootPending then
		YetiFarm.Busy = true
		local hold = CFrame.new(YetiFarm.LootAt)
		ctx.Lease:SetGoal(function()
			return hold
		end)
		YetiFarm.set(ctx, "Looting")
		ctx:sleep(Const.COLLECT_POLL)
		return
	end
	YetiFarm.LootAt = nil
	if Collector.Busy then
		YetiFarm.idle(ctx, "Looting", Const.COLLECT_POLL)
		return
	end
	if YetiFarm.hearts() <= 0 then
		YetiFarm.idle(ctx, "Out of Frozen Hearts", 1)
		return
	end
	if YetiFarm.refreezeIn() and not YetiFarm.prompt() then
		YetiFarm.idle(ctx, "Berg refreezing", 1)
		return
	end
	YetiFarm.summon(ctx)
end

function YetiFarm.stop()
	local ctx = YetiFarm.Context
	local thread = YetiFarm.Thread
	YetiFarm.Context = nil
	YetiFarm.Thread = nil
	YetiFarm.Phase = "Off"
	YetiFarm.LootUntil = 0
	YetiFarm.LootAt = nil
	if YetiFarm.Busy then
		YetiFarm.Busy = false
		Combat.BossTarget = nil
	end
	if ctx then
		ctx.Cancelled = true
		Priority.release(ctx)
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function YetiFarm.refresh()
	if not Settings.AutoYeti then
		YetiFarm.stop()
		return
	end
	if YetiFarm.Context then
		return
	end
	local ctx = Context.new(Mover.acquire("yeti", 15))
	Priority.bind(ctx, "Yeti")
	YetiFarm.Context = ctx
	YetiFarm.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(YetiFarm.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] yeti error: " .. tostring(err))
				YetiFarm.idle(ctx, "Error, retrying", 1)
			end
		end
	end)
end

function YetiFarm.buyStep()
	if not Settings.YetiAutoBuy then
		YetiFarm.BuyStatus = "Off"
		return
	end
	local have = YetiFarm.hearts()
	local want = Settings.YetiKeepHearts - have
	if want <= 0 then
		YetiFarm.BuyStatus = "Stocked"
		return
	end
	local state = Travel.marketer()
	if not state.Active then
		YetiFarm.BuyStatus = "Marketer away, back in " .. Travel.minutes(state.NextEdgeIn)
		return
	end
	if os.clock() < YetiFarm.BuyRetryAt then
		return
	end
	local amount = want
	if Game.Shop.CanBuy(LocalPlayer, Const.YETI_HEART, nil, amount) ~= true then
		amount = 1
		if Game.Shop.CanBuy(LocalPlayer, Const.YETI_HEART, nil, amount) ~= true then
			YetiFarm.BuyStatus = "Can't buy yet, retrying"
			YetiFarm.BuyRetryAt = os.clock() + Const.YETI_BUY_RETRY
			return
		end
	end
	YetiFarm.BuyStatus = "Buying " .. amount
	Game.fire("PurchaseFromShop", Const.YETI_HEART, amount)
	local deadline = os.clock() + Const.YETI_BUY_CONFIRM
	while os.clock() < deadline and YetiFarm.hearts() <= have do
		task.wait(0.2)
	end
	local gained = YetiFarm.hearts() - have
	if gained > 0 then
		YetiFarm.Bought += gained
		YetiFarm.BuyStatus = "Bought " .. gained
	else
		YetiFarm.BuyStatus = "Purchase not confirmed, retrying"
		YetiFarm.BuyRetryAt = os.clock() + Const.YETI_BUY_RETRY
	end
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(YetiFarm.buyStep)
		if not ok then
			warn("[Spryzen Hub] frozen heart buy error: " .. tostring(err))
			YetiFarm.BuyStatus = "Error, retrying"
		end
		task.wait(Const.YETI_BUY_POLL)
	end
end))

RootMaid:Give(YetiFarm.stop)

local YetiHop = {
	SETTLE = 15,
	GRACE = 8,
	TELEPORT_WAIT = 20,
	ATTEMPTS = 6,
	PHASES = { ["Berg refreezing"] = true, ["Out of Frozen Hearts"] = true, ["Waiting for the berg"] = true },
	Enabled = false,
	Hopping = false,
	Status = "Off",
	Since = nil,
	StartedAt = os.clock(),
	Tried = {},
	TeleportFailed = nil,
}

function YetiHop.wantsHop()
	if not YetiFarm.Context or YetiFarm.Busy then
		return false
	end
	if YetiFarm.boss() or YetiFarm.nearestMinion() then
		return false
	end
	return YetiHop.PHASES[YetiFarm.Phase] == true
end

function YetiHop.pick(servers)
	local own = nil
	for _, server in ipairs(servers) do
		if type(server) == "table" and server.JobId == game.JobId then
			own = server.Version
		end
	end
	local open, sameVersion = {}, {}
	for _, server in ipairs(servers) do
		if type(server) == "table" and type(server.JobId) == "string" and server.JobId ~= game.JobId and not YetiHop.Tried[server.JobId] then
			local players, capacity = tonumber(server.Players), tonumber(server.MaxPlayers)
			if players and capacity and players < capacity then
				table.insert(open, server)
				if own ~= nil and server.Version == own then
					table.insert(sameVersion, server)
				end
			end
		end
	end
	local pool = #sameVersion > 0 and sameVersion or open
	return #pool > 0 and pool[math.random(1, #pool)] or nil
end

function YetiHop.hop()
	local browser = Hub.gameModule("CAM", "Client", "Controllers", "ServerBrowserController")
	if not browser then
		YetiHop.Status = "Game server browser not found"
		return
	end
	for attempt = 1, YetiHop.ATTEMPTS do
		if not YetiHop.Enabled or not YetiHop.wantsHop() then
			return
		end
		YetiHop.Status = "Loading servers, attempt " .. attempt
		local servers, err = Hub.browseServers(browser)
		local target = servers and YetiHop.pick(servers)
		if not servers then
			YetiHop.Status = "Server list failed: " .. tostring(err)
			task.wait(3)
		elseif not target then
			YetiHop.Tried = {}
			YetiHop.Status = "No open server, retrying"
			task.wait(3)
		else
			YetiHop.Tried[target.JobId] = true
			YetiHop.Status = string.format("Joining %s (%d/%d)", tostring(target.Name), target.Players, target.MaxPlayers)
			YetiHop.TeleportFailed = nil
			local ok, success, reason = pcall(browser.Join, target)
			if ok and success then
				local deadline = os.clock() + YetiHop.TELEPORT_WAIT
				while os.clock() < deadline and not YetiHop.TeleportFailed and YetiHop.Enabled do
					task.wait(0.25)
				end
				YetiHop.Status = "Teleport failed" .. (YetiHop.TeleportFailed and (": " .. YetiHop.TeleportFailed) or "") .. ", trying another server"
			else
				YetiHop.Status = "Join refused: " .. tostring(ok and reason or success) .. ", trying another server"
				task.wait(2)
			end
		end
	end
	YetiHop.Status = "Hop failed, retrying soon"
end

RootMaid:Give(TeleportService.TeleportInitFailed:Connect(function(player, result, message)
	if player == LocalPlayer then
		YetiHop.TeleportFailed = tostring(message ~= "" and message or result)
	end
end))

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(function()
			if not YetiHop.Enabled then
				YetiHop.Since = nil
				YetiHop.Status = "Off"
				return
			end
			if not YetiHop.wantsHop() then
				YetiHop.Since = nil
				if not YetiFarm.Context then
					YetiHop.Status = "Waiting for Auto Yeti"
				elseif YetiFarm.Busy or YetiFarm.boss() or YetiFarm.nearestMinion() then
					YetiHop.Status = "Yeti here, killing it"
				else
					YetiHop.Status = "Checking for a Yeti"
				end
				return
			end
			local now = os.clock()
			YetiHop.Since = YetiHop.Since or now
			local ready = math.max(YetiHop.Since + YetiHop.GRACE, YetiHop.StartedAt + YetiHop.SETTLE)
			if now < ready then
				YetiHop.Status = "No Yeti (" .. YetiFarm.Phase .. "), hopping in " .. math.ceil(ready - now) .. "s"
				return
			end
			YetiHop.Hopping = true
			YetiHop.hop()
			YetiHop.Hopping = false
			YetiHop.Since = nil
		end)
		if not ok then
			YetiHop.Hopping = false
			warn("[Spryzen Hub] yeti hop error: " .. tostring(err))
			YetiHop.Status = "Error, retrying"
		end
		task.wait(0.5)
	end
end))

do
	for rank, tier in ipairs(Const.CACHE_TIERS) do
		local entry = { Id = tier.Id, Record = tier.Record, Label = tier.Label, Rank = rank, Guards = {} }
		for _, name in ipairs(tier.Guards) do
			entry.Guards[name] = true
			CacheFarm.GuardNames[name] = true
		end
		entry.Option = tier.Label .. " (" .. tier.Guards[1] .. "s)"
		table.insert(CacheFarm.Tiers, entry)
		CacheFarm.ById[tier.Id] = entry
		table.insert(CacheFarm.Options, entry.Option)
	end
end

function CacheFarm.enabled(tier)
	return #Settings.CacheTiers == 0 or table.find(Settings.CacheTiers, tier.Option) ~= nil
end

function CacheFarm.records()
	local data = Game.data()
	local events = data and data:FindFirstChild("WorldEvents")
	local stamps = {}
	if not events then
		return stamps
	end
	for _, tier in ipairs(CacheFarm.Tiers) do
		local folder = events:FindFirstChild(tier.Record)
		if folder then
			for _, value in ipairs(folder:GetChildren()) do
				if value:IsA("NumberValue") or value:IsA("IntValue") then
					table.insert(stamps, value.Value)
				end
			end
		end
	end
	table.sort(stamps)
	return stamps
end

function CacheFarm.signature()
	local parts = {}
	for _, stamp in ipairs(CacheFarm.records()) do
		table.insert(parts, string.format("%.0f", stamp))
	end
	return table.concat(parts, ",")
end

function CacheFarm.clearLimit()
	CacheFarm.LimitAt = nil
	CacheFarm.LimitText = nil
	CacheFarm.LimitSignature = nil
	GlobalEnv[Const.CACHE_LIMIT_KEY] = nil
end

function CacheFarm.setLimit(text)
	local fresh = CacheFarm.LimitAt == nil
	CacheFarm.LimitAt = Workspace:GetServerTimeNow()
	CacheFarm.LimitText = text
	CacheFarm.LimitSignature = CacheFarm.signature()
	GlobalEnv[Const.CACHE_LIMIT_KEY] = { At = CacheFarm.LimitAt, Text = text, Signature = CacheFarm.LimitSignature }
	if fresh and CacheFarm.Context then
		Hub.Notify({
			Title = "Cache limit reached",
			Content = "The game refused the cache. Cache Farm waits " .. Settings.CacheRetry .. " min, then tries again.",
			Type = "Warning",
			Icon = "package",
			Duration = 8,
		})
	end
end

function CacheFarm.limitLeft()
	local at = CacheFarm.LimitAt
	if not at then
		return nil
	end
	local left = at + Settings.CacheRetry * 60 - Workspace:GetServerTimeNow()
	if left <= 0 or CacheFarm.signature() ~= CacheFarm.LimitSignature then
		CacheFarm.clearLimit()
		return nil
	end
	return left
end

function CacheFarm.onNotice(_, payload)
	local raw = type(payload) == "table" and payload.Text or payload
	if type(raw) ~= "string" then
		return
	end
	local text = string.gsub(raw, "<[^>]*>", "")
	local lower = string.lower(text)
	if string.find(lower, Const.CACHE_LIMIT_TEXT, 1, true) then
		CacheFarm.setLimit(text)
	elseif string.find(lower, Const.CACHE_DENIED_TEXT, 1, true) and CacheFarm.Target then
		CacheFarm.Denied = true
	end
end

do
	local saved = GlobalEnv[Const.CACHE_LIMIT_KEY]
	if type(saved) == "table" and type(saved.At) == "number" and type(saved.Signature) == "string" then
		CacheFarm.LimitAt = saved.At
		CacheFarm.LimitText = saved.Text
		CacheFarm.LimitSignature = saved.Signature
	end
	local communication = ReplicatedStorage:FindFirstChild("Communication")
	local cnc = communication and communication:FindFirstChild("CnC")
	local folder = cnc and cnc:FindFirstChild("Notifications")
	local event = folder and folder:FindFirstChild("Notification")
	if event and event:IsA("BindableEvent") then
		CacheFarm.CanDetect = true
		RootMaid:Give(event.Event:Connect(function(kind, payload)
			local ok, err = pcall(CacheFarm.onNotice, kind, payload)
			if not ok then
				warn("[Spryzen Hub] cache notice error: " .. tostring(err))
			end
		end))
	end
end

function CacheFarm.caches()
	local list = {}
	local models = Collector.chestModels()
	local states = Collector.chestStates()
	if states then
		for guid, state in pairs(states) do
			local tier = type(state) == "table" and CacheFarm.ById[state.configId]
			if tier and typeof(state.position) == "Vector3" then
				local key = tostring(guid)
				table.insert(list, { Guid = key, RawGuid = guid, Tier = tier, State = state.state, OpenedBy = state.openedByUserId, Position = state.position, Model = models[key] })
			end
		end
		return list
	end
	for guid, model in pairs(models) do
		local tier = CacheFarm.ById[model:GetAttribute("ChestId")]
		if tier then
			local cache = { Guid = guid, Tier = tier, Position = model:GetPivot().Position, Model = model }
			CacheFarm.update(cache)
			table.insert(list, cache)
		end
	end
	return list
end

function CacheFarm.update(cache)
	local model = cache.Model
	if not (model and model.Parent and model:IsDescendantOf(Workspace)) then
		model = Collector.chestModels()[cache.Guid]
		cache.Model = model
	end
	if cache.RawGuid ~= nil then
		local states = Collector.chestStates()
		local state = states and states[cache.RawGuid]
		if type(state) == "table" then
			cache.State, cache.OpenedBy = state.state, state.openedByUserId
		else
			cache.State = "Gone"
		end
	elseif model then
		cache.State = model:GetAttribute("IsOpen") == true and "Opened" or model:GetAttribute("ChestState")
	else
		cache.State = "Unknown"
	end
	return cache.State
end

function CacheFarm.pending(state)
	return state == "Locked" or state == "Spawned" or state == "Unknown"
end

function CacheFarm.position(cache)
	local model = cache.Model
	if model and model.Parent then
		return model:GetPivot().Position
	end
	return cache.Position
end

function CacheFarm.stand(cache)
	return CFrame.new(CacheFarm.position(cache) + Const.GROUND_STAND_OFFSET)
end

function CacheFarm.skip(ctx, key)
	ctx.Skip[key] = os.clock()
end

function CacheFarm.skipped(ctx, key, window)
	local at = ctx.Skip[key]
	return at ~= nil and os.clock() - at < window
end

function CacheFarm.claimable(cache)
	return cache.State == "Locked" or (cache.State == "Spawned" and CacheFarm.Fought[cache.Guid] == true)
end

function CacheFarm.pick(ctx)
	local root = Character.root()
	if not root then
		return nil
	end
	local byTier = Settings.CachePriority == "Highest tier first"
	local best, bestDistance = nil, math.huge
	local live = {}
	for _, cache in ipairs(CacheFarm.caches()) do
		if cache.State == "Locked" or cache.State == "Spawned" then
			live[cache.Guid] = true
		end
		if CacheFarm.enabled(cache.Tier) and CacheFarm.claimable(cache) and not CacheFarm.skipped(ctx, cache.Guid, Const.CACHE_SKIP_FOR) then
			local distance = (cache.Position - root.Position).Magnitude
			local better
			if not best then
				better = true
			elseif (cache.State == "Spawned") ~= (best.State == "Spawned") then
				better = cache.State == "Spawned"
			elseif byTier and cache.Tier.Rank ~= best.Tier.Rank then
				better = cache.Tier.Rank > best.Tier.Rank
			else
				better = distance < bestDistance
			end
			if better then
				best, bestDistance = cache, distance
			end
		end
	end
	for guid in pairs(CacheFarm.Fought) do
		if not live[guid] then
			CacheFarm.Fought[guid] = nil
		end
	end
	return best
end

function CacheFarm.guards(ctx, cache)
	local active = YetiFarm.active()
	local root = Character.root()
	local list, nearest, nearestDistance = {}, nil, math.huge
	if not active then
		return list, nil
	end
	local center = CacheFarm.position(cache)
	for _, slot in ipairs(active:GetChildren()) do
		if cache.Tier.Guards[slot.Name] then
			for _, model in ipairs(slot:GetChildren()) do
				if model:IsA("Model") and Mobs.isAlive(model) then
					local position = model.HumanoidRootPart.Position
					if (position - center).Magnitude <= Const.CACHE_GUARD_RADIUS then
						table.insert(list, model)
						if not CacheFarm.skipped(ctx, model, Const.SKIP_TARGET_FOR) then
							local distance = root and (position - root.Position).Magnitude or 0
							if distance < nearestDistance then
								nearest, nearestDistance = model, distance
							end
						end
					end
				end
			end
		end
	end
	return list, nearest
end

function CacheFarm.isGuard(model)
	local slot = model.Parent
	return slot ~= nil and CacheFarm.GuardNames[slot.Name] == true and slot.Parent ~= nil and slot.Parent == YetiFarm.active()
end

function CacheFarm.prompt(cache)
	local model = cache.Model
	local prompt = model and model.Parent and model:FindFirstChild("ChestPrompt", true)
	return prompt and prompt:IsA("ProximityPrompt") and prompt or nil
end

function CacheFarm.blocker(ctx)
	local other = Priority.blocked(ctx.Job)
	if other then
		return Priority.pausedFor(other)
	elseif Schematics.Busy then
		return "Paused for schematics"
	end
	return nil
end

function CacheFarm.set(ctx, phase)
	CacheFarm.Phase = phase
	ctx:setStatus(phase)
end

function CacheFarm.release()
	if Combat.FarmTarget ~= nil and Combat.FarmTarget == CacheFarm.Guard then
		Combat.FarmTarget = nil
	end
	CacheFarm.Guard = nil
end

function CacheFarm.idle(ctx, phase, seconds)
	CacheFarm.Busy = false
	CacheFarm.Target = nil
	CacheFarm.release()
	ctx.Lease:SetGoal(nil)
	CacheFarm.set(ctx, phase)
	ctx:sleep(seconds)
end

function CacheFarm.fight(ctx, cache, guard, left, interrupted)
	local humanoid = guard:FindFirstChildOfClass("Humanoid")
	local lastHealth = humanoid.Health
	local lastProgress = os.clock()
	CacheFarm.Guard = guard
	Combat.FarmTarget = guard
	ctx.Lease:SetGoal(function()
		local targetRoot = guard.Parent and guard:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			return Pose.around(targetRoot)
		end
		return nil
	end)
	CacheFarm.set(ctx, "Fighting " .. guard.Name .. " (" .. left .. " left)")
	while not interrupted() and Mobs.isAlive(guard) do
		Combat.FarmTarget = guard
		if Heal.Retreating or Escape.Active or Potion.Busy or Mover.traveling() then
			lastProgress = os.clock()
		elseif humanoid.Health < lastHealth then
			lastHealth = humanoid.Health
			lastProgress = os.clock()
			CacheFarm.Fought[cache.Guid] = true
		elseif os.clock() - lastProgress > Const.STUCK_TARGET_TIMEOUT then
			CacheFarm.skip(ctx, guard)
			break
		end
		task.wait(0.1)
	end
	if not Mobs.isAlive(guard) then
		CacheFarm.GuardKills += 1
		CacheFarm.Fought[cache.Guid] = true
	end
	CacheFarm.release()
end

function CacheFarm.drops(center)
	local root = Character.root()
	local list = {}
	for _, part in ipairs(CollectionService:GetTagged(Game.GameSettings.Tags.LootDrop or "LootDrop")) do
		if part:IsA("BasePart") and part:IsDescendantOf(Workspace) and Collector.dropEligible(part) then
			local prompt = part:FindFirstChildWhichIsA("ProximityPrompt", true)
			local position = Collector.dropPosition(part)
			if prompt and prompt.Enabled and (position - center).Magnitude <= Const.CACHE_LOOT_RADIUS then
				table.insert(list, { Part = part, Prompt = prompt, Position = position, Distance = root and (position - root.Position).Magnitude or 0 })
			end
		end
	end
	table.sort(list, function(a, b)
		return a.Distance < b.Distance
	end)
	return list
end

function CacheFarm.loot(ctx, center)
	CacheFarm.set(ctx, "Collecting loot")
	local failed = {}
	local settleUntil = os.clock() + Const.CACHE_LOOT_SETTLE
	local deadline = os.clock() + Const.CACHE_LOOT_MAX
	while not ctx.Cancelled and Character.alive() and os.clock() < deadline do
		local target = nil
		for _, drop in ipairs(CacheFarm.drops(center)) do
			if not failed[drop.Part] then
				target = drop
				break
			end
		end
		if not target then
			if os.clock() >= settleUntil then
				return
			end
			task.wait(0.2)
		else
			local part, prompt = target.Part, target.Prompt
			local function claimed()
				return not part.Parent or part:GetAttribute("DropClaimedBy") ~= nil
			end
			local function stop()
				return ctx.Cancelled or claimed()
			end
			CacheFarm.set(ctx, "Collecting " .. tostring(part:GetAttribute("DropItemId") or "loot"))
			if ctx.Lease:MoveTo(CFrame.new(target.Position + Const.GROUND_STAND_OFFSET), stop) then
				local giveUp = os.clock() + prompt.HoldDuration + Const.CACHE_CLAIM_PAD
				while not stop() and os.clock() < giveUp do
					Prompts.waitShown(prompt, Const.CACHE_PROMPT_SHOWN, stop)
					if not stop() and prompt.Parent and prompt.Enabled then
						Prompts.trigger(prompt, stop)
					end
					ctx:waitFor(claimed, 0.3)
				end
			end
			if not claimed() then
				failed[part] = true
			end
		end
	end
end

function CacheFarm.open(ctx, cache, interrupted)
	CacheFarm.set(ctx, "Opening " .. cache.Tier.Label .. " cache")
	CacheFarm.release()
	CacheFarm.Denied = false
	local stand = CacheFarm.stand(cache)
	local settled = function()
		return interrupted() or CacheFarm.Denied or CacheFarm.update(cache) ~= "Spawned"
	end
	if not ctx.Lease:MoveTo(stand, settled) then
		if not settled() then
			CacheFarm.skip(ctx, cache.Guid)
		end
		return
	end
	ctx.Lease:SetGoal(function()
		return stand
	end)
	local before = #CacheFarm.records()
	local deadline = os.clock() + Const.CACHE_OPEN_TIMEOUT
	local fireAt = 0
	while os.clock() < deadline and not settled() do
		local prompt = CacheFarm.prompt(cache)
		if prompt and prompt.Enabled and os.clock() >= fireAt then
			fireAt = os.clock() + Const.CACHE_OPEN_REFIRE
			Prompts.trigger(prompt, settled)
		end
		task.wait(0.1)
	end
	if CacheFarm.Denied then
		CacheFarm.Denied = false
		CacheFarm.Fought[cache.Guid] = nil
		CacheFarm.skip(ctx, cache.Guid)
		return
	end
	local opened = CacheFarm.update(cache) ~= "Spawned"
	if opened then
		CacheFarm.loot(ctx, CacheFarm.position(cache))
		CacheFarm.NextAt = os.clock() + Settings.CacheDelay
	end
	local mine = #CacheFarm.records() > before or (cache.OpenedBy ~= nil and cache.OpenedBy == LocalPlayer.UserId)
	if mine then
		CacheFarm.Opened += 1
		CacheFarm.OpenedByTier[cache.Tier.Label] = (CacheFarm.OpenedByTier[cache.Tier.Label] or 0) + 1
	elseif not opened and CacheFarm.limitLeft() == nil and CacheFarm.update(cache) == "Spawned" then
		CacheFarm.skip(ctx, cache.Guid)
	end
end

function CacheFarm.run(ctx, cache)
	CacheFarm.Busy = true
	CacheFarm.Target = cache
	local started = os.clock()
	local function interrupted()
		return ctx.Cancelled or not Character.alive() or CacheFarm.blocker(ctx) ~= nil or CacheFarm.limitLeft() ~= nil
	end
	CacheFarm.set(ctx, "Travelling to " .. cache.Tier.Label .. " cache")
	local arrived = ctx.Lease:MoveTo(CacheFarm.stand(cache), function()
		return interrupted() or not CacheFarm.pending(CacheFarm.update(cache))
	end)
	if not arrived then
		if not interrupted() and CacheFarm.pending(cache.State) then
			CacheFarm.skip(ctx, cache.Guid)
		end
		return
	end
	Priority.set(ctx, "Engaged")
	local waitingSince = nil
	while not interrupted() do
		local state = CacheFarm.update(cache)
		if state == "Spawned" then
			if CacheFarm.Fought[cache.Guid] then
				CacheFarm.open(ctx, cache, interrupted)
			else
				CacheFarm.skip(ctx, cache.Guid)
			end
			return
		elseif not CacheFarm.pending(state) then
			return
		elseif os.clock() - started > Const.CACHE_TIMEOUT then
			CacheFarm.skip(ctx, cache.Guid)
			return
		end
		local guards, guard = CacheFarm.guards(ctx, cache)
		if guard then
			waitingSince = nil
			CacheFarm.fight(ctx, cache, guard, #guards, interrupted)
		else
			waitingSince = waitingSince or os.clock()
			if os.clock() - waitingSince > Const.CACHE_GUARD_WAIT then
				CacheFarm.skip(ctx, cache.Guid)
				return
			end
			local stand = CacheFarm.stand(cache)
			ctx.Lease:SetGoal(function()
				return stand
			end)
			CacheFarm.set(ctx, #guards > 0 and "Guards stuck, waiting" or "Waiting for the seal to break")
			task.wait(0.1)
		end
	end
end

function CacheFarm.step(ctx)
	for key, at in pairs(ctx.Skip) do
		if os.clock() - at > Const.CACHE_SKIP_FOR or (typeof(key) == "Instance" and not key.Parent) then
			ctx.Skip[key] = nil
		end
	end
	local left = CacheFarm.limitLeft()
	local cooldown = CacheFarm.NextAt - os.clock()
	local cache = not left and cooldown <= 0 and CacheFarm.pick(ctx) or nil
	Priority.set(ctx, cache and "Want" or nil)
	local blocker = CacheFarm.blocker(ctx)
	if blocker then
		CacheFarm.idle(ctx, blocker, Const.PRIORITY_POLL)
		return
	end
	if Heal.Retreating or Escape.Active then
		CacheFarm.idle(ctx, Escape.Active and "Paused, retreating" or "Paused to heal", 0.5)
		return
	end
	if not Character.alive() then
		CacheFarm.idle(ctx, "Respawning", 0.5)
		return
	end
	if left then
		CacheFarm.idle(ctx, "Cache limit reached, retry in " .. WorldBoss.clock(left), 1)
		return
	end
	if cooldown > 0 then
		CacheFarm.idle(ctx, string.format("Next cache in %.1fs", cooldown), math.min(cooldown, 0.5))
		return
	end
	if not cache then
		CacheFarm.idle(ctx, "Waiting for sealed caches", 2)
		return
	end
	CacheFarm.run(ctx, cache)
	CacheFarm.release()
end

function CacheFarm.stop()
	local ctx = CacheFarm.Context
	local thread = CacheFarm.Thread
	CacheFarm.Context = nil
	CacheFarm.Thread = nil
	CacheFarm.Phase = "Off"
	CacheFarm.Busy = false
	CacheFarm.Target = nil
	CacheFarm.release()
	if ctx then
		ctx.Cancelled = true
		Priority.release(ctx)
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function CacheFarm.refresh()
	if not Settings.AutoCacheFarm then
		CacheFarm.stop()
		return
	end
	if CacheFarm.Context then
		return
	end
	local ctx = Context.new(Mover.acquire("cache", 13))
	Priority.bind(ctx, "Caches")
	CacheFarm.Context = ctx
	CacheFarm.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(CacheFarm.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] cache farm error: " .. tostring(err))
				CacheFarm.idle(ctx, "Error, retrying", 1)
			end
		end
	end)
end

function CacheFarm.counts()
	local counts = {}
	for _, cache in ipairs(CacheFarm.caches()) do
		if cache.State == "Locked" or cache.State == "Spawned" then
			counts[cache.Tier.Label] = (counts[cache.Tier.Label] or 0) + 1
		end
	end
	local parts = {}
	for _, tier in ipairs(CacheFarm.Tiers) do
		if CacheFarm.enabled(tier) then
			table.insert(parts, "T" .. tier.Rank .. ": " .. (counts[tier.Label] or 0))
		end
	end
	return table.concat(parts, "  ")
end

RootMaid:Give(CacheFarm.stop)

local Fishing = { Thread = nil, Context = nil, Status = "Off", Caught = 0, Bought = 0, Spot = nil, Stand = nil, Session = nil, Answered = {}, Catches = setmetatable({}, { __mode = "k" }), Listener = nil, Patched = nil, Watcher = nil, Watching = nil, Pinned = nil, Override = nil, PreviousSlot = nil }

Fishing.RodOptions = { "Best Owned" }
for _, name in ipairs(Const.FISH_RODS) do
	table.insert(Fishing.RodOptions, name)
end
Fishing.BaitOptions = { "None" }
for _, name in ipairs(Const.FISH_BAITS) do
	table.insert(Fishing.BaitOptions, name)
end

function Fishing.set(text)
	Fishing.Status = text
end

function Fishing.waitUntil(predicate, timeout, cancelled, interval)
	local deadline = os.clock() + timeout
	while true do
		if cancelled and cancelled() then
			return false
		end
		if predicate() then
			return true
		end
		if os.clock() >= deadline then
			return false
		end
		task.wait(interval)
	end
end

function Fishing.fire(name, ...)
	return (pcall(Game.fire, name, ...))
end

function Fishing.inventoryId(name)
	local data = Game.data()
	local inventory = data and data.Inventory:FindFirstChild("Inventory")
	local entry = inventory and inventory:FindFirstChild(name)
	local id = entry and entry:FindFirstChild("Id")
	return id and tonumber(id.Value) or nil
end

function Fishing.held()
	local ok, tool = pcall(Game.CharacterInfo.Get_equipped_tool, LocalPlayer)
	if ok and typeof(tool) == "Instance" then
		return tool.Name
	end
	return nil
end

function Fishing.equipConfig()
	local holder = LocalPlayer:FindFirstChild("Items_Config")
	return holder and holder:FindFirstChild("Equipped") or nil
end

function Fishing.toolbarSlot(name)
	local id = Fishing.inventoryId(name)
	local data = Game.data()
	local toolbar = id and data and data.Inventory:FindFirstChild("Toolbar")
	if not toolbar then
		return nil
	end
	for index, slotName in ipairs(Const.SLOT_NAMES) do
		local slot = toolbar:FindFirstChild(slotName)
		if slot and tonumber(slot.Value) == id then
			return index
		end
	end
	return nil
end

function Fishing.equipSlot(slot, force)
	local config = Fishing.equipConfig()
	slot = tonumber(slot)
	if not config or not slot or slot < 0 or slot > #Const.SLOT_NAMES then
		return false
	end
	if Fishing.PreviousSlot == nil then
		Fishing.PreviousSlot = config.Value
	end
	if config.Value == slot then
		if force then
			Fishing.fire("Item_Equip", slot)
		end
		return true
	end
	return (pcall(function()
		config.Value = slot
	end))
end

function Fishing.holdItem(name)
	if Fishing.equipSlot(Fishing.toolbarSlot(name), true) then
		return true
	end
	local id = Fishing.inventoryId(name)
	local data = Game.data()
	local toolbar = data and data.Inventory:FindFirstChild("Toolbar")
	if not id or not toolbar then
		return false
	end
	local target
	for _, slotName in ipairs(Const.SLOT_NAMES) do
		local slot = toolbar:FindFirstChild(slotName)
		if slot and tonumber(slot.Value) == 0 then
			target = slotName
			break
		end
	end
	Fishing.fire("Toolbar_Equip", target or Const.SLOT_NAMES[#Const.SLOT_NAMES], id)
	Fishing.waitUntil(function()
		return Fishing.toolbarSlot(name) ~= nil
	end, 4)
	return Fishing.equipSlot(Fishing.toolbarSlot(name), true)
end

function Fishing.claimOverride()
	if Combat.Override == nil then
		Fishing.Override = { M1 = false, Skills = false }
		Combat.Override = Fishing.Override
	end
	return Combat.Override == Fishing.Override
end

function Fishing.dropOverride()
	if Fishing.Override and Combat.Override == Fishing.Override then
		Combat.Override = nil
	end
	Fishing.Override = nil
end

function Fishing.blocker(ctx)
	if Mover.Active ~= nil and Mover.Active ~= ctx.Lease then
		return "Paused, another feature is moving you"
	end
	if Heal.Retreating or Escape.Active or Potion.Busy then
		return "Paused for survival"
	end
	return nil
end

function Fishing.travel(ctx, position, settle, cancelled)
	local arrived = ctx:moveTo(position)
	ctx.Lease:SetGoal(nil)
	if not arrived or cancelled() then
		return false
	end
	if settle then
		task.wait(settle)
	end
	return not cancelled()
end

function Fishing.stationaryNpc(name)
	local debree = Workspace:FindFirstChild("Debree")
	local regions = debree and debree:FindFirstChild("Regions")
	if not regions then
		return nil
	end
	for _, region in ipairs(regions:GetChildren()) do
		local holder = region:FindFirstChild("StationaryNpcs")
		local npc = holder and holder:FindFirstChild(name)
		if npc then
			return npc
		end
	end
	return nil
end

function Fishing.npcPrompt(name)
	local npc = Fishing.stationaryNpc(name)
	if not npc then
		return nil
	end
	for _, descendant in ipairs(npc:GetDescendants()) do
		if descendant:IsA("ProximityPrompt") then
			return descendant
		end
	end
	return nil
end

function Fishing.shopPrompt(item)
	local debree = Workspace:FindFirstChild("Debree")
	local regions = debree and debree:FindFirstChild("Regions")
	if not regions then
		return nil
	end
	for _, region in ipairs(regions:GetChildren()) do
		local holder = region:FindFirstChild("StationaryNpcs")
		if holder then
			for _, descendant in ipairs(holder:GetDescendants()) do
				if descendant:IsA("ProximityPrompt") and descendant.ActionText == "Purchase" and descendant.ObjectText == item then
					return descendant
				end
			end
		end
	end
	return nil
end

function Fishing.firePrompt(prompt)
	local sight = prompt.RequiresLineOfSight
	pcall(function()
		prompt.RequiresLineOfSight = false
	end)
	local ok = pcall(Prompts.trigger, prompt)
	pcall(function()
		prompt.RequiresLineOfSight = sight
	end)
	return ok
end

function Fishing.buyItem(ctx, item, keep, cancelled)
	local held = Game.itemCount(item)
	if held >= keep then
		return false
	end
	local vendor = Const.FISH_VENDORS[item]
	if not vendor then
		Fishing.set("Cannot find " .. item)
		return false
	end
	local prompt = Fishing.shopPrompt(item) or Fishing.npcPrompt(vendor)
	if not prompt then
		local point = Game.npcPosition(vendor)
		if not point then
			Fishing.set("Cannot find " .. vendor)
			return false
		end
		Fishing.set("Travelling to " .. vendor)
		if not Fishing.travel(ctx, point + Vector3.new(0, 3, 0), 0.5, cancelled) then
			return false
		end
		Fishing.waitUntil(function()
			return Fishing.shopPrompt(item) ~= nil or Fishing.npcPrompt(vendor) ~= nil
		end, 10, cancelled)
		if cancelled() then
			return false
		end
		prompt = Fishing.shopPrompt(item) or Fishing.npcPrompt(vendor)
	end
	if not prompt then
		Fishing.set("Cannot reach " .. item)
		return false
	end
	local part = prompt.Parent
	if part and part:IsA("BasePart") then
		if not Fishing.travel(ctx, part.Position + Vector3.new(0, 2, 3), 0.3, cancelled) then
			return false
		end
	end
	if cancelled() or not Fishing.firePrompt(prompt) then
		return false
	end
	task.wait(1)
	if cancelled() then
		return false
	end
	Fishing.set("Buying " .. item)
	Fishing.fire("PurchaseFromShop", item, math.max(1, keep - held))
	task.wait(1.5)
	if cancelled() then
		return false
	end
	Fishing.fire("NpcTalking", "Ended")
	if Game.itemCount(item) > held then
		Fishing.Bought += 1
		Fishing.set("Bought " .. item)
		return true
	end
	Fishing.set("Cannot afford " .. item)
	return false
end

function Fishing.rod()
	for _, name in ipairs(Const.FISH_RODS) do
		if Game.itemCount(name) > 0 then
			return name
		end
	end
	return nil
end

function Fishing.questCompleted(questString)
	local data = Game.data()
	local quests = data and data:FindFirstChild("Quests")
	local completed = quests and quests:FindFirstChild("Completed")
	return completed ~= nil and completed:FindFirstChild(questString) ~= nil
end

function Fishing.footing()
	local character = LocalPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return false
	end
	if (character:GetAttribute("SwimState") or 0) > 0 then
		return false
	end
	return humanoid.FloorMaterial ~= Enum.Material.Air
end

function Fishing.waterAt(point, from)
	local include = {}
	for _, part in ipairs(CollectionService:GetTagged("SwimParts")) do
		include[#include + 1] = part.Parent or part
	end
	if #include == 0 then
		return nil
	end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = include
	params.BruteForceAllSlow = true
	local top = math.max(point.Y, from.Y) + 50
	local origin = Vector3.new(point.X, top, point.Z)
	local hit = Workspace:Raycast(origin, Vector3.new(0, -(top - math.min(point.Y, from.Y) + Const.FISH_DEPTH), 0), params)
	local surface = hit and hit.Instance or nil
	if surface ~= nil and surface.Name == "Texture" and surface.Parent then
		surface = surface.Parent:FindFirstChild("TouchPart")
	end
	if surface == nil or surface.Name ~= "TouchPart" or not CollectionService:HasTag(surface, "SwimParts") then
		return nil
	end
	local blockers = RaycastParams.new()
	blockers.FilterType = Enum.RaycastFilterType.Exclude
	blockers.FilterDescendantsInstances = { Workspace:FindFirstChild("Debree"), LocalPlayer.Character }
	local above = Workspace:Raycast(origin, Vector3.new(0, -(top - hit.Position.Y + 25), 0), blockers)
	if above and above.Position.Y > hit.Position.Y then
		return nil
	end
	return hit.Position
end

function Fishing.castRadius(rod)
	local info = rod and Game.Items[rod]
	local stats = type(info) == "table" and info.FishingStats or nil
	local radius = type(stats) == "table" and tonumber(stats.CastRadius) or nil
	return math.max(8, math.min(radius or Const.FISH_REACH, 60) - 2)
end

function Fishing.castPoint(rod)
	local root = Character.root()
	if not root then
		return nil
	end
	local from = root.Position
	local reach = Fishing.castRadius(rod or Fishing.held())
	for radius = 6, reach, 4 do
		for step = 0, 15 do
			local angle = math.rad(step * 22.5)
			local point = from + Vector3.new(math.sin(angle) * radius, 0, math.cos(angle) * radius)
			local water = Fishing.waterAt(point, from)
			if water then
				return water
			end
		end
	end
	return nil
end

function Fishing.aimPoint()
	local root = Character.root()
	local camera = Workspace.CurrentCamera
	if not root or not camera then
		return nil
	end
	local reach = Fishing.castRadius(Fishing.held())
	local origin = camera.CFrame.Position
	local look = camera.CFrame.LookVector
	for distance = 6, 150, 4 do
		local point = origin + look * distance
		local flat = Vector3.new(point.X - root.Position.X, 0, point.Z - root.Position.Z)
		if flat.Magnitude <= reach then
			local water = Fishing.waterAt(point, root.Position)
			if water then
				return water
			end
		end
	end
	return nil
end

function Fishing.face(point)
	local root = Character.root()
	if not root then
		return
	end
	local aim = Vector3.new(point.X, root.Position.Y, point.Z)
	if (aim - root.Position).Magnitude > 0.1 then
		pcall(function()
			root.CFrame = CFrame.lookAt(root.Position, aim)
		end)
	end
end

function Fishing.engaged()
	return Character.alive() and Fishing.Context ~= nil
end

function Fishing.remote()
	local cam = ReplicatedStorage:FindFirstChild("CAM")
	local global = cam and cam:FindFirstChild("Global")
	local portal = global and global:FindFirstChild("ServerClientPortal")
	local remote = portal and portal:FindFirstChild("Event")
	if remote and remote:IsA("RemoteEvent") then
		return remote
	end
	return nil
end

function Fishing.hold(token)
	local answered = Fishing.Answered
	if token == nil or answered[token] then
		return
	end
	local now = os.clock()
	for old, at in pairs(answered) do
		if now - at > 60 then
			answered[old] = nil
		end
	end
	answered[token] = now
	local session = Fishing.Session
	if session then
		session.bitAt = now
		Fishing.set("Hooked, holding the line")
	end
	task.delay(Const.FISH_BITE_HOLD, function()
		local remote = Fishing.remote()
		if remote then
			pcall(remote.FireServer, remote, "FishingRod", token, true)
		end
	end)
end

function Fishing.listen()
	if Fishing.Listener then
		return true
	end
	local remote = Fishing.remote()
	if not remote then
		return false
	end
	Fishing.Listener = remote.OnClientEvent:Connect(function(name, kind, token)
		if name ~= "FishingRod" then
			return
		end
		if kind == "Bite" and Fishing.engaged() then
			Fishing.hold(token)
		elseif kind == "BiteMissed" and Fishing.Session then
			Fishing.Session.missed = true
		end
	end)
	return true
end

function Fishing.silence()
	if Fishing.Patched then
		return true
	end
	local portal = Game.ServerClientPortal
	local listeners = type(portal) == "table" and rawget(portal, "CurrentListeners") or nil
	local link = type(listeners) == "table" and listeners.FishingRod or nil
	if type(link) ~= "table" then
		return true
	end
	local class = getmetatable(link)
	local call = type(class) == "table" and rawget(class, "Call") or nil
	if type(call) ~= "function" then
		return false
	end
	local function quiet(self, kind, ...)
		if kind == "Bite" and type(self) == "table" and rawget(self, "ConnectionName") == "FishingRod" and Fishing.engaged() then
			return
		end
		return call(self, kind, ...)
	end
	rawset(class, "Call", quiet)
	Fishing.Patched = { Class = class, Call = call, Quiet = quiet }
	return true
end

function Fishing.arm()
	local listening = Fishing.listen()
	return Fishing.silence() and listening
end

function Fishing.pin(stand, force)
	Fishing.unpin()
	if not (force or Settings.FishFreeze) or typeof(stand) ~= "CFrame" then
		return
	end
	Fishing.Pinned = RunService.Heartbeat:Connect(function()
		local root = Character.alive() and Character.root()
		if not root then
			return
		end
		if (root.Position - stand.Position).Magnitude > 0.75 then
			root.CFrame = stand
			root.AssemblyLinearVelocity = Vector3.zero
		else
			root.AssemblyLinearVelocity = Vector3.new(0, math.min(root.AssemblyLinearVelocity.Y, 0), 0)
		end
		root.AssemblyAngularVelocity = Vector3.zero
	end)
end

function Fishing.unpin()
	if Fishing.Pinned then
		Fishing.Pinned:Disconnect()
		Fishing.Pinned = nil
	end
end

function Fishing.mine(model)
	local character = LocalPlayer.Character
	if not character then
		return false
	end
	for _, item in ipairs(model:GetDescendants()) do
		if item:IsA("RopeConstraint") and item.Name == "FishingLine" then
			if item.Attachment0 and item.Attachment0:IsDescendantOf(character) then
				return true
			end
		elseif item:IsA("AlignPosition") and item.Name == "CatchPull" then
			if item.Attachment1 and item.Attachment1:IsDescendantOf(character) then
				return true
			end
		end
	end
	return false
end

function Fishing.kindOf(model)
	local kind = model.Name:match("^(Fishing%a+)_%d+$")
	if kind == "FishingLine" or kind == "FishingCatch" then
		return kind
	end
	return nil
end

function Fishing.claim(kind, model)
	local session = Fishing.Session
	if kind == "FishingCatch" then
		Fishing.Catches[model] = true
		if session and session.catch == nil then
			session.catch = model
		end
	elseif session and session.bobber == nil then
		session.bobber = model
	end
end

function Fishing.watch()
	local debree = Workspace:FindFirstChild("Debree")
	if not debree or Fishing.Watching == debree then
		return
	end
	if Fishing.Watcher then
		Fishing.Watcher:Disconnect()
	end
	Fishing.Watching = debree
	Fishing.Watcher = debree.ChildAdded:Connect(function(model)
		local kind = Fishing.kindOf(model)
		if not kind then
			return
		end
		for _ = 1, 10 do
			if not Character.alive() or model.Parent == nil then
				return
			end
			if Fishing.mine(model) then
				Fishing.claim(kind, model)
				return
			end
			task.wait(0.1)
		end
	end)
end

function Fishing.release()
	if Fishing.Watcher then
		Fishing.Watcher:Disconnect()
		Fishing.Watcher = nil
	end
	Fishing.Watching = nil
	if Fishing.Listener then
		Fishing.Listener:Disconnect()
		Fishing.Listener = nil
	end
	local patched = Fishing.Patched
	if patched and rawget(patched.Class, "Call") == patched.Quiet then
		rawset(patched.Class, "Call", patched.Call)
	end
	Fishing.Patched = nil
	Fishing.unpin()
end

function Fishing.scan(kind)
	local debree = Workspace:FindFirstChild("Debree")
	if not debree then
		return nil
	end
	for _, model in ipairs(debree:GetChildren()) do
		if Fishing.kindOf(model) == kind and Fishing.mine(model) then
			if kind == "FishingCatch" then
				Fishing.Catches[model] = true
			end
			return model
		end
	end
	return nil
end

function Fishing.live(model)
	return model ~= nil and model.Parent ~= nil
end

function Fishing.useBait(name, cancelled)
	local id = 0
	if name then
		if Game.itemCount(name) <= 0 then
			return false
		end
		id = Fishing.inventoryId(name)
		if not id then
			return false
		end
	end
	local function equipped()
		local data = Game.data()
		local misc = data and data:FindFirstChild("Misc")
		local value = misc and misc:FindFirstChild("EquippedBaitId")
		return value and tonumber(value.Value) or 0
	end
	if equipped() == id then
		return true
	end
	Fishing.fire("EquipBait", id)
	return Fishing.waitUntil(function()
		return equipped() == id
	end, 4, cancelled) == true
end

function Fishing.press(prompt, cancelled)
	local held = math.max(prompt.HoldDuration, 0)
	local sight = prompt.RequiresLineOfSight
	pcall(function()
		prompt.RequiresLineOfSight = false
	end)
	local began = pcall(prompt.InputHoldBegin, prompt)
	if began then
		Fishing.waitUntil(function()
			return prompt.Parent == nil
		end, held + 0.25, cancelled)
		pcall(prompt.InputHoldEnd, prompt)
	end
	pcall(function()
		prompt.RequiresLineOfSight = sight
	end)
	return began
end

function Fishing.settled(model)
	local line = model:FindFirstChild("FishingLine", true)
	return line ~= nil and line:IsA("RopeConstraint") and line.Length <= 0.4
end

function Fishing.collect(ctx, model, cancelled)
	if not Fishing.live(model) then
		return false
	end
	local item
	Fishing.waitUntil(function()
		item = model:GetAttribute("CatchItem")
		return type(item) == "string" and item ~= "" or model.Parent == nil
	end, 2, cancelled)
	local named = type(item) == "string" and item ~= "" and item or nil
	local label = named or "the catch"
	local before = named and Game.itemCount(named) or 0
	local pressed = false
	local function landed()
		return (named ~= nil and Game.itemCount(named) > before) or (pressed and model.Parent == nil)
	end
	Fishing.set("Reeling in " .. label)
	local started = os.clock()
	local deadline = started + Const.FISH_COLLECT_TIME
	while os.clock() < deadline and not cancelled() and model.Parent ~= nil and not landed() do
		local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
		local part = prompt and prompt.Parent
		local root = Character.root()
		if prompt and part and part:IsA("BasePart") and root then
			local reach = prompt.MaxActivationDistance > 0 and prompt.MaxActivationDistance or 10
			local gap = (part.Position - root.Position).Magnitude
			local hanging = Fishing.mine(model)
			local ready = not hanging or Fishing.settled(model) or os.clock() - started > 6
			if ready and gap <= (hanging and reach or reach - 0.5) then
				pressed = Fishing.press(prompt, cancelled) or pressed
				Fishing.waitUntil(landed, 1, cancelled)
			elseif hanging then
				task.wait(0.1)
			else
				local flat = Vector3.new(part.Position.X - root.Position.X, 0, part.Position.Z - root.Position.Z)
				local stop = flat.Magnitude > 1 and part.Position - flat.Unit * math.min(reach * 0.5, 4) or part.Position
				Fishing.unpin()
				Fishing.travel(ctx, stop + Vector3.new(0, 3, 0), 0.3, cancelled)
			end
		else
			task.wait(0.1)
		end
	end
	Fishing.Catches[model] = nil
	if landed() then
		Fishing.Caught += 1
		Fishing.set("Caught " .. label)
		return true
	end
	if not cancelled() then
		Fishing.set("Lost " .. label)
	end
	return false
end

function Fishing.collectLeftovers(ctx, cancelled)
	local root = Character.root()
	local home = root and root.CFrame
	local moved = false
	for _ = 1, 6 do
		if cancelled() then
			break
		end
		local model
		for candidate in pairs(Fishing.Catches) do
			if candidate.Parent ~= nil and candidate:IsDescendantOf(Workspace) then
				model = candidate
				break
			end
			Fishing.Catches[candidate] = nil
		end
		if not model then
			break
		end
		local part = model:FindFirstChildWhichIsA("BasePart", true)
		root = Character.root()
		if part and root and (part.Position - root.Position).Magnitude > 10 then
			moved = true
		end
		Fishing.collect(ctx, model, cancelled)
	end
	if moved and home and not cancelled() then
		Fishing.set("Returning to the fishing spot")
		Fishing.travel(ctx, home.Position + Vector3.new(0, 3, 0), 0.4, cancelled)
		root = Character.root()
		if root then
			pcall(function()
				root.CFrame = home
			end)
		end
	end
end

function Fishing.clearLine(ctx, cancelled)
	Fishing.scan("FishingCatch")
	Fishing.collectLeftovers(ctx, cancelled)
	local stale = Fishing.scan("FishingLine")
	if stale and not cancelled() then
		Fishing.set("Reeling in the old line")
		local part = stale:IsA("BasePart") and stale or stale:FindFirstChildWhichIsA("BasePart", true)
		Fishing.fire("Tool_Mouse", "Up", part and part.Position or Vector3.zero)
		Fishing.waitUntil(function()
			return stale.Parent == nil
		end, 3, cancelled)
		Fishing.scan("FishingCatch")
		Fishing.collectLeftovers(ctx, cancelled)
	end
	return not cancelled()
end

function Fishing.cast(point, session, cancelled)
	for _ = 1, Const.FISH_CAST_TRIES do
		if cancelled() then
			return false
		end
		Fishing.fire("Tool_Mouse", "Up", point)
		if Fishing.waitUntil(function()
			return Fishing.live(session.bobber)
		end, 2.5, cancelled) then
			return true
		end
		task.wait(0.35)
	end
	return false
end

function Fishing.fishOnce(ctx, session, point, cancelled)
	Fishing.set("Casting")
	if not Fishing.cast(point, session, cancelled) then
		if cancelled() then
			return nil, "cancelled"
		end
		Fishing.set("Cannot cast from here")
		return nil, "nocast"
	end
	Fishing.set("Waiting for a bite")
	local giveUp = os.clock() + Const.FISH_BITE_WAIT
	Fishing.waitUntil(function()
		Fishing.arm()
		if session.catch or not Fishing.live(session.bobber) then
			return true
		end
		if session.bitAt then
			giveUp = math.max(giveUp, session.bitAt + Const.FISH_BITE_HOLD + 6)
		end
		return os.clock() > giveUp
	end, Const.FISH_BITE_WAIT + 20, cancelled)
	if not session.catch and Fishing.live(session.bobber) then
		if not session.bitAt then
			Fishing.fire("Tool_Mouse", "Up", point)
		end
		if cancelled() then
			return nil, "cancelled"
		end
		Fishing.set("No bite, casting again")
		return nil, "empty"
	end
	if not session.missed then
		Fishing.waitUntil(function()
			return session.catch ~= nil
		end, 2.5, cancelled)
	end
	if cancelled() then
		return nil, "cancelled"
	end
	if not session.catch then
		Fishing.set(session.missed and "The fish slipped the hook" or "The line came back empty")
		return nil, "empty"
	end
	Fishing.collect(ctx, session.catch, cancelled)
	return session.catch, "caught"
end

function Fishing.runCast(ctx, point, cancelled)
	Fishing.watch()
	if not Fishing.waitUntil(Fishing.arm, 3, cancelled) then
		if not cancelled() then
			Fishing.set("Waiting for the rod to connect")
		end
		return nil, cancelled() and "cancelled" or "nocast"
	end
	if not Fishing.clearLine(ctx, cancelled) then
		return nil, "cancelled"
	end
	local session = {}
	Fishing.Session = session
	local ok, model, outcome = pcall(Fishing.fishOnce, ctx, session, point, cancelled)
	if Fishing.Session == session then
		Fishing.Session = nil
	end
	if not ok then
		error(model, 0)
	end
	return model, outcome
end

function Fishing.earnPermit(ctx)
	if Fishing.questCompleted(Const.FISH_PERMIT_QUEST) then
		return true
	end
	local plan = Catalog.QuestByKey[Const.FISH_PERMIT_QUEST]
	if not plan then
		Fishing.set("No permit quest in this place")
		return false
	end
	if Game.level() < plan.Level then
		Fishing.set(string.format("The permit needs level %d", plan.Level))
		return false
	end
	Fishing.set("Working on the permit quest")
	local ok, reason = QuestRunner.cycle(ctx, plan)
	ctx.Lease:SetGoal(nil)
	if not ok then
		Fishing.set(reason or "Cannot finish the permit quest")
	end
	return Fishing.questCompleted(Const.FISH_PERMIT_QUEST)
end

function Fishing.goTo(ctx, spot, cancelled)
	local root = Character.root()
	if root and (root.Position - spot.Position).Magnitude < 6 then
		return true
	end
	Fishing.travel(ctx, spot.Position + Vector3.new(0, 3, 0), 0.4, cancelled)
	if cancelled and cancelled() then
		return false
	end
	root = Character.root()
	if not root then
		return false
	end
	pcall(function()
		root.CFrame = spot
		root.AssemblyLinearVelocity = Vector3.zero
	end)
	return (root.Position - spot.Position).Magnitude < 6
end

function Fishing.recall(ctx, origin, cancelled)
	if not origin or not Settings.FishReturnAfterBait then
		return
	end
	local root = Character.root()
	if root and (root.Position - origin.Position).Magnitude < 6 then
		return
	end
	Fishing.set("Returning to the fishing spot")
	Fishing.travel(ctx, origin.Position + Vector3.new(0, 3, 0), 0.4, cancelled)
	root = Character.root()
	if root then
		pcall(function()
			root.CFrame = origin
		end)
	end
end

function Fishing.prepare(ctx, cancelled)
	local root = Character.root()
	local origin = Fishing.Spot or Fishing.Stand or (root and root.CFrame)
	local choice = Settings.FishRod
	local rod
	if choice == "Best Owned" then
		rod = Fishing.rod()
	elseif Game.itemCount(choice) > 0 then
		rod = choice
	elseif choice ~= Const.FISH_STARTER_ROD then
		Fishing.set("You do not own the " .. choice)
		task.wait(1)
		return nil
	end
	if not rod then
		if not Fishing.earnPermit(ctx) then
			return nil
		end
		Fishing.set("Buying a " .. Const.FISH_STARTER_ROD)
		Fishing.buyItem(ctx, Const.FISH_STARTER_ROD, 1, cancelled)
		Fishing.recall(ctx, origin, cancelled)
		rod = Game.itemCount(Const.FISH_STARTER_ROD) > 0 and Const.FISH_STARTER_ROD or nil
		if not rod then
			return nil
		end
	end
	local function hold()
		local slot = Fishing.toolbarSlot(rod)
		local config = Fishing.equipConfig()
		if slot and config and tonumber(config.Value) == slot then
			return true
		end
		if Fishing.holdItem(rod) then
			return true
		end
		Fishing.set("Cannot equip the " .. rod)
		return false
	end
	if not hold() then
		return nil
	end
	local bait = Settings.FishBait
	if bait == "" or bait == "None" then
		return rod
	end
	if Game.itemCount(bait) <= 0 and Settings.FishBuyBait and Const.FISH_VENDORS[bait] then
		Fishing.set("Buying " .. bait)
		Fishing.buyItem(ctx, bait, Const.FISH_BAIT_RESTOCK, cancelled)
		Fishing.recall(ctx, origin, cancelled)
		if not hold() then
			return nil
		end
	end
	if Game.itemCount(bait) <= 0 then
		Fishing.set("Out of " .. bait)
	elseif not Fishing.useBait(bait, cancelled) and not cancelled() then
		Fishing.set("Cannot put the " .. bait .. " on the hook")
	end
	return rod
end

function Fishing.fishStep(ctx)
	local function cancelled()
		return ctx.Cancelled or not Character.alive() or Fishing.blocker(ctx) ~= nil
	end
	Fishing.watch()
	Fishing.arm()
	if not Fishing.prepare(ctx, cancelled) or cancelled() then
		return
	end
	local spot = Fishing.Spot
	if spot then
		local here = Character.root()
		if here and (here.Position - spot.Position).Magnitude >= 6 then
			Fishing.set("Going to your saved spot")
		end
		if not Fishing.goTo(ctx, spot, cancelled) then
			if not cancelled() then
				Fishing.set("Cannot reach your saved spot")
			end
			return
		end
	end
	if not Fishing.waitUntil(Fishing.footing, 3, cancelled) then
		if not cancelled() then
			Fishing.set("Stand on solid ground to fish")
		end
		return
	end
	local point = Fishing.castPoint() or Fishing.aimPoint()
	if not point then
		Fishing.set("No fishable water in cast reach")
		task.wait(1)
		return
	end
	Fishing.face(point)
	local root = Character.root()
	if root then
		Fishing.Stand = root.CFrame
		Fishing.pin(root.CFrame)
	end
	Fishing.runCast(ctx, point, cancelled)
end

function Fishing.step(ctx)
	if not Character.alive() then
		Fishing.set("Waiting for your character")
		ctx:sleep(1)
		return
	end
	local blocker = Fishing.blocker(ctx)
	if blocker then
		Fishing.dropOverride()
		Fishing.set(blocker)
		ctx:sleep(1)
		return
	end
	if not Fishing.claimOverride() then
		Fishing.set("Paused, another feature controls your weapon")
		ctx:sleep(1)
		return
	end
	local ok, err = pcall(Fishing.fishStep, ctx)
	Fishing.unpin()
	ctx.Lease:SetGoal(nil)
	if not ok then
		warn("[Spryzen Hub] fishing step: " .. tostring(err))
	end
	task.wait(Const.FISH_INTERVAL)
end

function Fishing.stop()
	local ctx = Fishing.Context
	local thread = Fishing.Thread
	Fishing.Context = nil
	Fishing.Thread = nil
	Fishing.Session = nil
	Fishing.release()
	Fishing.dropOverride()
	Fishing.set("Off")
	local previous = Fishing.PreviousSlot
	Fishing.PreviousSlot = nil
	local config = Fishing.equipConfig()
	if previous and config and config.Value ~= previous then
		pcall(function()
			config.Value = previous
		end)
	end
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function Fishing.refresh()
	if not Settings.AutoFish then
		Fishing.stop()
		return
	end
	if Fishing.Context then
		return
	end
	Fishing.Stand = nil
	Fishing.set("Starting")
	local ctx = Context.new(Mover.acquire("fishing", 3))
	Fishing.Context = ctx
	Fishing.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(Fishing.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] fishing error: " .. tostring(err))
				Fishing.set("Error, retrying")
				ctx:sleep(2)
			end
		end
	end)
end

function Fishing.saveSpot()
	local root = Character.root()
	if not root then
		return nil
	end
	Fishing.Spot = root.CFrame
	return root.Position
end

function Fishing.goToSpot()
	local spot = Fishing.Spot
	if not spot then
		return false
	end
	task.spawn(function()
		local lease = Mover.acquire("fishing spot", 26)
		local arrived = lease:MoveTo(CFrame.new(spot.Position + Vector3.new(0, 3, 0)))
		lease:Release()
		local root = Character.root()
		if arrived and root then
			root.CFrame = spot
			root.AssemblyLinearVelocity = Vector3.zero
		end
	end)
	return true
end

RootMaid:Give(Fishing.stop)

local PortalJoin = { Thread = nil, Context = nil, Teleporting = false, TeleportAt = 0, StartedAt = 0 }

RootMaid:Give(LocalPlayer.OnTeleport:Connect(function(state)
	if state == Enum.TeleportState.Started or state == Enum.TeleportState.InProgress then
		PortalJoin.Teleporting = true
		PortalJoin.TeleportAt = os.clock()
	elseif state == Enum.TeleportState.Failed then
		PortalJoin.Teleporting = false
	end
end))

function PortalJoin.prompt()
	local map = Workspace:FindFirstChild("Map")
	local pad = map and map:FindFirstChild(Const.PORTAL_PAD)
	if not pad then
		return nil
	end
	local fallback = nil
	for _, item in ipairs(pad:GetDescendants()) do
		if item:IsA("ProximityPrompt") then
			if item.Name == Const.PORTAL_PROMPT or item.ObjectText == Const.PORTAL_PROMPT then
				return item
			end
			fallback = fallback or item
		end
	end
	return fallback
end

function PortalJoin.step(ctx)
	if PortalJoin.Teleporting and os.clock() - PortalJoin.TeleportAt > Const.PORTAL_TELEPORT_STUCK then
		PortalJoin.Teleporting = false
	end
	if PortalJoin.Teleporting then
		ctx:setStatus("Teleporting to Ouwigahara")
		ctx:sleep(1)
		return
	end
	if not Character.alive() then
		ctx:setStatus("Waiting for your character")
		ctx:sleep(1)
		return
	end
	local left = Settings.DungeonJoinDelay - (os.clock() - PortalJoin.StartedAt)
	if left > 0 then
		ctx:setStatus("Joining in " .. math.ceil(left) .. "s")
		ctx:sleep(math.min(left, 0.25))
		return
	end
	local stand = Const.PORTAL_POSITION + Const.GROUND_STAND_OFFSET
	ctx:setStatus("Travelling to the Ouwigahara portal")
	if not ctx:moveTo(stand) then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus("Could not reach the portal, retrying")
		ctx:sleep(2)
		return
	end
	ctx.Lease:SetGoal(function()
		return CFrame.new(stand)
	end)
	local prompt = nil
	ctx:waitFor(function()
		prompt = PortalJoin.prompt()
		return prompt ~= nil
	end, Const.PORTAL_LOAD_WAIT)
	if ctx.Cancelled then
		return
	end
	if not prompt then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus("The portal did not load in, retrying")
		ctx:sleep(Const.PORTAL_RETRY)
		return
	end
	if not prompt.Enabled then
		ctx.Lease:SetGoal(nil)
		ctx:setStatus("The portal is locked for you")
		ctx:sleep(Const.PORTAL_LOCKED_RETRY)
		return
	end
	local function cancelled()
		return ctx.Cancelled
	end
	ctx:setStatus("Entering Ouwigahara")
	Prompts.waitShown(prompt, 2, cancelled)
	Prompts.trigger(prompt, cancelled)
	if ctx:waitFor(function()
		return PortalJoin.Teleporting
	end, Const.PORTAL_TELEPORT_WAIT) then
		return
	end
	ctx.Lease:SetGoal(nil)
	if not ctx.Cancelled then
		ctx:setStatus("The portal did not teleport you, retrying")
		ctx:sleep(Const.PORTAL_RETRY)
	end
end

function PortalJoin.stop()
	local ctx = PortalJoin.Context
	local thread = PortalJoin.Thread
	PortalJoin.Context = nil
	PortalJoin.Thread = nil
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function PortalJoin.refresh()
	if not Settings.AutoJoinDungeon then
		PortalJoin.stop()
		return
	end
	if PortalJoin.Context then
		return
	end
	local ctx = Context.new(Mover.acquire("portal", 20))
	PortalJoin.Context = ctx
	PortalJoin.StartedAt = os.clock()
	PortalJoin.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(PortalJoin.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] dungeon join error: " .. tostring(err))
				ctx.Lease:SetGoal(nil)
				ctx:setStatus("Error, retrying")
				ctx:sleep(2)
			end
			task.wait()
		end
	end)
end

RootMaid:Give(PortalJoin.stop)

function Schematics.set(ctx, text)
	Schematics.Phase = text
	ctx:setStatus(text)
end

function Schematics.plain(text)
	text = string.gsub(tostring(text or ""), "<[^>]*>", "")
	return (string.gsub(text, "[%[%]]", ""))
end

function Schematics.cancelled(ctx)
	return function()
		return ctx.Cancelled
	end
end

function Schematics.has(name)
	local data = Game.data()
	return data ~= nil and data.Inventory.Inventory:FindFirstChild(name) ~= nil
end

function Schematics.record(name)
	local data = Game.data()
	local events = data and data:FindFirstChild("WorldEvents")
	return events ~= nil and events:FindFirstChild(name) ~= nil
end

function Schematics.owned(entry)
	if entry.Record and Schematics.record(entry.Record) then
		return true
	end
	for _, item in ipairs(entry.Items) do
		if not Schematics.has(item) then
			return false
		end
	end
	return true
end

function Schematics.ownedCheck(entry)
	return function()
		return Schematics.owned(entry)
	end
end

function Schematics.stream(position)
	task.spawn(function()
		pcall(LocalPlayer.RequestStreamAroundAsync, LocalPlayer, position, 5)
	end)
end

function Schematics.hold(ctx, target)
	local goal = typeof(target) == "CFrame" and target or CFrame.new(target)
	ctx.Lease:SetGoal(function()
		return goal
	end)
end

function Schematics.goTo(ctx, position, label)
	if label then
		Schematics.set(ctx, "Going to " .. label)
	end
	Schematics.stream(position)
	if not ctx:moveTo(position) then
		return false
	end
	Schematics.hold(ctx, position)
	return true
end

function Schematics.footOffset()
	local character = Character.get()
	local root = Character.root()
	if not character or not root then
		return 3
	end
	local lowest = root.Position.Y
	for _, part in ipairs(character:GetChildren()) do
		if part:IsA("BasePart") then
			lowest = math.min(lowest, part.Position.Y - part.Size.Y / 2)
		end
	end
	return math.clamp(root.Position.Y - lowest, 1.5, 6)
end

function Schematics.usePrompt(ctx, prompt, done, attempts)
	local cancelled = Schematics.cancelled(ctx)
	for _ = 1, attempts or Const.SCHEMATIC_ATTEMPTS do
		if done() then
			return true
		end
		if ctx.Cancelled or not prompt.Parent then
			return false
		end
		if prompt.Enabled then
			Prompts.waitShown(prompt, 1, cancelled)
			Prompts.trigger(prompt, cancelled)
		end
		if ctx:waitFor(done, Const.SCHEMATIC_GIVE_TIMEOUT) then
			return true
		end
	end
	return done()
end

function Schematics.promptNear(part)
	local prompt = part and part.Parent and part:FindFirstChildWhichIsA("ProximityPrompt", true)
	return prompt
end

function Schematics.npcModel(name)
	local debree = Workspace:FindFirstChild("Debree")
	local regions = debree and debree:FindFirstChild("Regions")
	if not regions then
		return nil
	end
	for _, region in ipairs(regions:GetChildren()) do
		local folder = region:FindFirstChild("StationaryNpcs")
		local model = folder and folder:FindFirstChild(name)
		if model and model:IsA("Model") then
			return model
		end
	end
	return nil
end

function Schematics.npcPosition(name)
	if name == Const.SCHEMATIC_SOFEN.Name then
		return Game.npcPosition(name) or Const.SCHEMATIC_SOFEN.Position
	end
	return Game.npcPosition(name)
end

function Schematics.talk(ctx, npc, args, done)
	if done() then
		return true
	end
	local position = Schematics.npcPosition(npc)
	if not position then
		return false, npc .. "'s location is unknown"
	end
	if not Schematics.goTo(ctx, position + Const.NPC_STAND_OFFSET, npc) then
		return false, "Could not reach " .. npc
	end
	Schematics.set(ctx, "Talking to " .. npc)
	Game.fire(table.unpack(args))
	if ctx:waitFor(done, Const.SCHEMATIC_TALK_TIMEOUT) then
		return true
	end
	ctx:waitFor(function()
		return Schematics.npcModel(npc) ~= nil
	end, Const.SCHEMATIC_NPC_WAIT)
	local model = Schematics.npcModel(npc)
	local prompt = model and model:FindFirstChildWhichIsA("ProximityPrompt", true)
	if prompt and prompt.Enabled then
		Prompts.trigger(prompt, Schematics.cancelled(ctx))
		ctx:sleep(Const.DEMON_DIALOGUE_SETTLE)
		Game.fire(table.unpack(args))
		local ok = ctx:waitFor(done, Const.SCHEMATIC_TALK_TIMEOUT)
		Demon.closeDialogue()
		if ok then
			return true
		end
	end
	return done(), npc .. " did not respond"
end

function Schematics.claimDrops(ctx, center)
	local failed = {}
	local settleUntil = os.clock() + Const.SCHEMATIC_LOOT_SETTLE
	local deadline = os.clock() + Const.SCHEMATIC_LOOT_MAX
	while not ctx.Cancelled and Character.alive() and os.clock() < deadline do
		local target, bestDistance = nil, math.huge
		local root = Character.root()
		for _, part in ipairs(CollectionService:GetTagged(Game.GameSettings.Tags.LootDrop or "LootDrop")) do
			if part:IsA("BasePart") and part:IsDescendantOf(Workspace) and not failed[part] and Collector.dropEligible(part) then
				local prompt = part:FindFirstChildWhichIsA("ProximityPrompt", true)
				local position = Collector.dropPosition(part)
				local distance = root and (position - root.Position).Magnitude or 0
				if prompt and prompt.Enabled and (position - center).Magnitude <= Const.SCHEMATIC_LOOT_RADIUS and distance < bestDistance then
					target, bestDistance = { Part = part, Prompt = prompt, Position = position }, distance
				end
			end
		end
		if not target then
			if os.clock() >= settleUntil then
				return
			end
			task.wait(0.2)
		else
			local part = target.Part
			local function claimed()
				return not part.Parent or part:GetAttribute("DropClaimedBy") ~= nil
			end
			Schematics.set(ctx, "Collecting " .. tostring(part:GetAttribute("DropItemId") or "loot"))
			if ctx.Lease:MoveTo(CFrame.new(target.Position + Const.GROUND_STAND_OFFSET), function()
				return ctx.Cancelled or claimed()
			end) then
				Schematics.usePrompt(ctx, target.Prompt, claimed, 2)
			end
			if not claimed() then
				failed[part] = true
			end
		end
	end
end

function Schematics.onSignal(name, payload)
	if type(payload) ~= "table" then
		return
	end
	if name == "GauntletStatue" and type(payload.Type) == "string" and type(payload.Ratio) == "number" then
		Schematics.Statues[payload.Type] = payload.Ratio
	elseif name == "SimonSays" and type(payload.Action) == "string" then
		local event = table.clone(payload)
		event.At = os.clock()
		Schematics.Simon[payload.Action] = event
	end
end

do
	local ok, connection = pcall(Game.SignalEvent.Connect, Game.SignalEvent, function(name, ...)
		local handled, err = pcall(Schematics.onSignal, name, ...)
		if not handled then
			warn("[Spryzen Hub] schematic signal error: " .. tostring(err))
		end
	end)
	if ok and connection then
		RootMaid:Give(connection)
	else
		warn("[Spryzen Hub] schematic signals unavailable: " .. tostring(connection))
	end
end

function Schematics.studyProp(item)
	for _, prop in ipairs(CollectionService:GetTagged("StudyProp")) do
		if prop:GetAttribute("Item") == item and prop:IsDescendantOf(Workspace) then
			return prop
		end
	end
	return nil
end

function Schematics.runStudy(ctx, entry)
	local prop = Schematics.studyProp(entry.Base)
	if not prop then
		return "wait", "The " .. entry.Base .. " drawings are not in the map"
	end
	local pivot = prop:GetPivot().Position
	if not Schematics.goTo(ctx, pivot + Const.GROUND_STAND_OFFSET, "the " .. entry.Base .. " drawings") then
		return "wait", "Could not reach the drawings"
	end
	if not ctx:waitFor(function()
		return Schematics.promptNear(prop) ~= nil
	end, Const.SCHEMATIC_PROMPT_WAIT) then
		return "wait", "The drawings did not load in"
	end
	local prompt = Schematics.promptNear(prop)
	local part = prompt.Parent
	if part:IsA("BasePart") then
		Schematics.hold(ctx, part.Position + Const.GROUND_STAND_OFFSET)
		ctx:waitFor(function()
			local root = Character.root()
			return root ~= nil and (root.Position - part.Position).Magnitude <= prompt.MaxActivationDistance - 1
		end, 3)
	end
	Schematics.set(ctx, "Studying the " .. entry.Base .. " drawings")
	local owned = Schematics.ownedCheck(entry)
	if Schematics.usePrompt(ctx, prompt, owned) then
		return "done"
	end
	Schematics.claimDrops(ctx, pivot)
	if owned() then
		return "done"
	end
	return "wait", "The game did not hand over the drawings"
end

function Schematics.leverKey(lever)
	local position = lever:GetPivot().Position
	return string.format("%d,%d,%d", math.round(position.X), math.round(position.Y), math.round(position.Z))
end

function Schematics.pullLever(ctx, lever, index, total)
	local pivot = lever:GetPivot().Position
	Schematics.set(ctx, string.format("Pulling lever %d of %d", index, total))
	if not Schematics.goTo(ctx, pivot + Const.GROUND_STAND_OFFSET) then
		return false
	end
	local function parts()
		local a = lever:FindFirstChild("A_")
		local main = a and a:FindFirstChild("LeverMain")
		return a, main, main and main:FindFirstChildWhichIsA("ProximityPrompt")
	end
	ctx:waitFor(function()
		return select(3, parts()) ~= nil
	end, Const.SCHEMATIC_PROMPT_WAIT)
	local a, main, prompt = parts()
	if not a then
		return false
	end
	local function on()
		return a:GetAttribute("On") == true
	end
	if on() then
		return true
	end
	if main and prompt then
		Schematics.hold(ctx, main.Position + Vector3.new(0, 1, 0))
		ctx:sleep(0.3)
		if prompt.Enabled then
			Prompts.trigger(prompt, Schematics.cancelled(ctx))
		end
		if ctx:waitFor(on, Const.SCHEMATIC_LEVER_CONFIRM) then
			return true
		end
	end
	Game.fire("training_signaler", "StateChanged", lever)
	return true
end

function Schematics.runSickles(ctx, entry)
	if not LocalPlayer:GetAttribute("SicklesSewerOpen") then
		local levers = {}
		for _, lever in ipairs(CollectionService:GetTagged("SicklesLever")) do
			if lever:IsDescendantOf(Workspace) and not Schematics.Levers[Schematics.leverKey(lever)] then
				table.insert(levers, lever)
			end
		end
		local total = #CollectionService:GetTagged("SicklesLever")
		if total == 0 then
			return "wait", "The sewer levers are not in the map"
		end
		while #levers > 0 and not ctx.Cancelled do
			local root = Character.root()
			local best, bestDistance = 1, math.huge
			for index, lever in ipairs(levers) do
				local distance = root and (lever:GetPivot().Position - root.Position).Magnitude or 0
				if distance < bestDistance then
					best, bestDistance = index, distance
				end
			end
			local lever = table.remove(levers, best)
			local done = total - #levers
			if Schematics.pullLever(ctx, lever, done, total) then
				Schematics.Levers[Schematics.leverKey(lever)] = true
			elseif not ctx.Cancelled then
				return "wait", "Could not reach a lever, retrying"
			end
			if LocalPlayer:GetAttribute("SicklesSewerOpen") then
				break
			end
		end
		if ctx.Cancelled then
			return "wait", "Stopped"
		end
		Schematics.set(ctx, "Waiting for the sewer to open")
		if not ctx:waitFor(function()
			return LocalPlayer:GetAttribute("SicklesSewerOpen") == true
		end, Const.SCHEMATIC_SEWER_WAIT) then
			table.clear(Schematics.Levers)
			return "wait", "All levers pulled but the sewer stayed shut, rejoin to reset the levers"
		end
	end
	return Schematics.runStudy(ctx, entry)
end

function Schematics.serpentKeys()
	local list = {}
	local pick = nil
	local data = Game.data()
	local events = data and data:FindFirstChild("WorldEvents")
	local record = events and events:FindFirstChild("SerpentKeyPick")
	if record and record:IsA("ValueBase") then
		pick = "Key" .. tostring(record.Value)
	end
	local seen = {}
	for name, position in pairs(Const.SCHEMATIC_SERPENT_KEYS) do
		seen[name] = true
		table.insert(list, { Name = name, Position = position })
	end
	for _, key in ipairs(CollectionService:GetTagged("SerpentKey")) do
		if key:IsA("BasePart") and not seen[key.Name] then
			seen[key.Name] = true
			table.insert(list, { Name = key.Name, Position = key.Position })
		end
	end
	local root = Character.root()
	local origin = root and root.Position or Vector3.zero
	table.sort(list, function(a, b)
		if (a.Name == pick) ~= (b.Name == pick) then
			return a.Name == pick
		end
		return (a.Position - origin).Magnitude < (b.Position - origin).Magnitude
	end)
	return list
end

function Schematics.keyPart(name)
	local puzzles = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Puzzles")
	local folder = puzzles and puzzles:FindFirstChild("Serpent Keys")
	local part = folder and folder:FindFirstChild(name)
	return part and part:IsA("BasePart") and part or nil
end

function Schematics.openSerpentBox(ctx, entry)
	local puzzles = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Puzzles")
	local box = puzzles and puzzles:FindFirstChild("Serpent Box")
	local center = box and box:GetPivot().Position or Const.SCHEMATIC_SERPENT_BOX
	if not Schematics.goTo(ctx, center + Const.GROUND_STAND_OFFSET, "the Serpent Box") then
		return "wait", "Could not reach the Serpent Box"
	end
	if not ctx:waitFor(function()
		return Schematics.promptNear(box) ~= nil
	end, Const.SCHEMATIC_PROMPT_WAIT) then
		return "wait", "The Serpent Box did not load in"
	end
	local prompt = Schematics.promptNear(box)
	if prompt.Parent:IsA("BasePart") then
		Schematics.hold(ctx, prompt.Parent.Position + Const.GROUND_STAND_OFFSET)
		ctx:sleep(0.3)
	end
	Schematics.set(ctx, "Unlocking the Serpent Box")
	local owned = Schematics.ownedCheck(entry)
	if Schematics.usePrompt(ctx, prompt, function()
		return owned() or not Schematics.has(Const.SCHEMATIC_SERPENT_KEY)
	end) and owned() then
		return "done"
	end
	Schematics.claimDrops(ctx, center)
	if owned() then
		return "done"
	end
	if not Schematics.has(Const.SCHEMATIC_SERPENT_KEY) then
		if Schematics.LastKey then
			Schematics.KeysTried[Schematics.LastKey] = true
		end
		return "wait", "That key did not fit, trying another"
	end
	return "blocked", "The Serpent Box refused the key you hold"
end

function Schematics.runSerpent(ctx, entry)
	if Schematics.has(Const.SCHEMATIC_SERPENT_KEY) then
		return Schematics.openSerpentBox(ctx, entry)
	end
	for _, key in ipairs(Schematics.serpentKeys()) do
		if ctx.Cancelled then
			return "wait", "Stopped"
		end
		if not Schematics.KeysTried[key.Name] then
			if not Schematics.goTo(ctx, key.Position + Const.GROUND_STAND_OFFSET, "Serpent " .. key.Name) then
				return "wait", "Could not reach " .. key.Name
			end
			ctx:waitFor(function()
				return Schematics.promptNear(Schematics.keyPart(key.Name)) ~= nil
			end, Const.SCHEMATIC_PROMPT_WAIT)
			local prompt = Schematics.promptNear(Schematics.keyPart(key.Name))
			Schematics.set(ctx, "Taking " .. key.Name)
			if prompt and Schematics.usePrompt(ctx, prompt, function()
				return Schematics.has(Const.SCHEMATIC_SERPENT_KEY)
			end, 2) then
				Schematics.LastKey = key.Name
				return Schematics.openSerpentBox(ctx, entry)
			end
			Schematics.KeysTried[key.Name] = true
		end
	end
	table.clear(Schematics.KeysTried)
	return "wait", "No Serpent Key could be taken, starting the search over"
end

function Schematics.statue(kind)
	for _, statue in ipairs(CollectionService:GetTagged("GauntletStatue")) do
		if statue:GetAttribute("type") == kind and statue:IsDescendantOf(Workspace) then
			return statue
		end
	end
	return nil
end

function Schematics.equipSlot(slot)
	local config = LocalPlayer:FindFirstChild("Items_Config")
	local equipped = config and config:FindFirstChild("Equipped")
	if equipped and equipped.Value ~= slot then
		Combat.LastEquip = os.clock()
		equipped.Value = slot
	end
end

function Schematics.toolbarEntry(slot)
	local data = Game.data()
	local toolbar = data and data.Inventory:FindFirstChild("Toolbar")
	return toolbar and Const.SLOT_NAMES[slot] and toolbar:FindFirstChild(Const.SLOT_NAMES[slot])
end

function Schematics.itemId(name)
	local data = Game.data()
	local entry = data and data.Inventory.Inventory:FindFirstChild(name)
	local id = entry and entry:FindFirstChild("Id")
	return id and id.Value ~= 0 and id.Value or nil
end

function Schematics.loadSlot(ctx, slot, id)
	local entry = Schematics.toolbarEntry(slot)
	if not entry then
		return false
	end
	if entry.Value ~= id then
		Schematics.equipSlot(0)
		Game.fire("Toolbar_Equip", entry.Name, id)
		ctx:waitFor(function()
			return entry.Value == id
		end, Const.SCHEMATIC_TOOLBAR_TIMEOUT)
	end
	Schematics.equipSlot(slot)
	return entry.Value == id
end

function Schematics.restoreGauntlet()
	local held = Schematics.GauntletHeld
	Schematics.GauntletHeld = nil
	local entry = held and Schematics.toolbarEntry(held.Slot)
	if entry and entry.Value ~= held.Weapon then
		Game.fire("Toolbar_Equip", entry.Name, held.Weapon)
	end
end

function Schematics.statuePose(statue, targetRoot)
	local stand = statue:FindFirstChild("stand")
	local height = stand and stand:IsA("BasePart") and stand.Position.Y + stand.Size.Y / 2 + Const.SCHEMATIC_STATUE_HEIGHT or targetRoot.Position.Y
	local front = (targetRoot.CFrame * CFrame.new(0, 0, -Const.SCHEMATIC_STATUE_GAP)).Position
	local position = Vector3.new(front.X, height, front.Z)
	return CFrame.lookAt(position, Vector3.new(targetRoot.Position.X, height, targetRoot.Position.Z))
end

function Schematics.hitStatue(ctx, statue, kind, slot)
	local override = { M1 = kind ~= "Power", Slot = slot, Skills = kind == "Power" }
	local last, lastAt = Schematics.Statues[kind], os.clock()
	Schematics.equipSlot(slot)
	Combat.Override = override
	Combat.FarmTarget = statue
	Schematics.Target = statue
	ctx.Lease:SetGoal(function()
		local targetRoot = statue.Parent and statue:FindFirstChild("HumanoidRootPart")
		return targetRoot and Schematics.statuePose(statue, targetRoot) or nil
	end)
	while not ctx.Cancelled and Character.alive() and not Schematics.blocker() do
		local ratio = Schematics.Statues[kind]
		if ratio and ratio >= 1 then
			break
		end
		if ratio ~= last or Heal.Retreating or Escape.Active or Potion.Busy then
			last, lastAt = ratio, os.clock()
		elseif os.clock() - lastAt > Const.SCHEMATIC_STATUE_STALL then
			break
		end
		if not Potion.Busy and not Skills.Swapping then
			Schematics.equipSlot(slot)
		end
		Combat.FarmTarget = statue
		local progress = ratio and string.format(" %d%%", math.floor(ratio * 100)) or ""
		Schematics.set(ctx, "Hitting the " .. kind .. " statue" .. progress)
		task.wait(0.1)
	end
	Combat.Override = nil
	Combat.FarmTarget = nil
	ctx.Lease:SetGoal(nil)
	local ratio = Schematics.Statues[kind]
	return ratio ~= nil and ratio >= 1
end

function Schematics.runGauntlet(ctx, entry)
	local state, text = Schematics.gauntlet(ctx, entry)
	Schematics.restoreGauntlet()
	return state, text
end

function Schematics.gauntlet(ctx, entry)
	local slot = tonumber(Settings.GauntletSlot)
	if not slot then
		Hub.Notify({
			Title = "Gauntlet needs a slot",
			Content = "Pick the Gauntlet Weapon Slot in the Schematics tab. The script swaps between that weapon and your fists for the statues.",
			Type = "Warning",
			Icon = "sword",
			Duration = 8,
		})
		return "blocked", "Pick a Gauntlet Weapon Slot in the Schematics tab"
	end
	local fists = Schematics.itemId(Const.SCHEMATIC_FISTS)
	local toolbarEntry = Schematics.toolbarEntry(slot)
	local weapon = toolbarEntry and toolbarEntry.Value
	if not fists then
		return "blocked", "No Combat item in your inventory"
	elseif not weapon or weapon == 0 then
		return "blocked", "Gauntlet Weapon Slot " .. slot .. " is empty"
	elseif weapon == fists then
		return "blocked", "Gauntlet Weapon Slot " .. slot .. " holds Combat, put your weapon back on it"
	end
	Schematics.GauntletHeld = { Slot = slot, Weapon = weapon }
	local owned = Schematics.ownedCheck(entry)
	if not Schematics.record("GauntletStatues_Heard") then
		local ok, text = Schematics.talk(ctx, "Stonemason Tobei", { "GauntletStatuesBegin" }, function()
			return Schematics.record("GauntletStatues_Heard")
		end)
		if not ok then
			return "wait", text or "Tobei did not tell his story"
		end
	end
	local missing = {}
	for _, kind in ipairs(Const.SCHEMATIC_STATUES) do
		if ctx.Cancelled then
			return "wait", "Stopped"
		end
		if (Schematics.Statues[kind] or 0) < 1 then
			local statue = Schematics.statue(kind)
			if not statue then
				table.insert(missing, kind)
			else
				local item = kind == "Fighting" and fists or weapon
				if not Schematics.loadSlot(ctx, slot, item) then
					return "wait", "Could not put " .. (kind == "Fighting" and "Combat" or "your weapon") .. " on slot " .. slot
				end
				if not Schematics.goTo(ctx, statue:GetPivot().Position + Vector3.new(0, 4, 0), "the " .. kind .. " statue") then
					return "wait", "Could not reach the " .. kind .. " statue"
				end
				ctx:waitFor(function()
					return Mobs.isAlive(statue)
				end, Const.SCHEMATIC_PROMPT_WAIT)
				if not Mobs.isAlive(statue) or not Schematics.hitStatue(ctx, statue, kind, slot) then
					table.insert(missing, kind)
				end
			end
		end
	end
	if ctx.Cancelled then
		return "wait", "Stopped"
	end
	local ok = Schematics.talk(ctx, "Stonemason Tobei", { "GauntletGiveSchematic" }, owned)
	if ok or owned() then
		return "done"
	end
	if #missing > 0 then
		return "wait", "Statues still asleep: " .. table.concat(missing, ", ")
	end
	table.clear(Schematics.Statues)
	return "wait", "Tobei did not hand over the drawings"
end

function Schematics.duelist()
	local humanoids = Workspace:FindFirstChild("Humanoids")
	local pending = { humanoids }
	while #pending > 0 do
		local node = table.remove(pending)
		for _, child in ipairs(node and node:GetChildren() or {}) do
			if child:IsA("Folder") then
				table.insert(pending, child)
			elseif child:IsA("Model") and child.Name == Const.SCHEMATIC_DUELIST and Mobs.isAlive(child) then
				return child
			end
		end
	end
	return nil
end

function Schematics.runDuel(ctx, entry)
	local owned = Schematics.ownedCheck(entry)
	local mob = Schematics.duelist()
	if not mob then
		Schematics.talk(ctx, Const.SCHEMATIC_DUELIST, { "CleaverDuel" }, function()
			return Schematics.duelist() ~= nil
		end)
		ctx:waitFor(function()
			return Schematics.duelist() ~= nil
		end, Const.SCHEMATIC_DUEL_WAIT)
		mob = Schematics.duelist()
		if not mob then
			return "wait", "Hibiki did not accept the duel"
		end
	end
	local humanoid = mob:FindFirstChildOfClass("Humanoid")
	local lastHealth, lastAt = humanoid.Health, os.clock()
	Combat.Override = { M1 = true }
	Combat.FarmTarget = mob
	Schematics.Target = mob
	ctx.Lease:SetGoal(function()
		local targetRoot = mob.Parent and mob:FindFirstChild("HumanoidRootPart")
		return targetRoot and Pose.around(targetRoot) or nil
	end)
	while not ctx.Cancelled and Mobs.isAlive(mob) and Character.alive() do
		Combat.FarmTarget = mob
		if humanoid.Health < lastHealth or Heal.Retreating or Escape.Active or Potion.Busy then
			lastHealth, lastAt = humanoid.Health, os.clock()
		elseif os.clock() - lastAt > Const.SCHEMATIC_DUEL_STALL then
			break
		end
		Schematics.set(ctx, string.format("Dueling Hibiki (%d%%)", math.floor(humanoid.Health / math.max(humanoid.MaxHealth, 1) * 100)))
		task.wait(0.1)
	end
	Combat.Override = nil
	Combat.FarmTarget = nil
	ctx.Lease:SetGoal(nil)
	if Mobs.isAlive(mob) then
		return "wait", Character.alive() and "The duel stalled, retrying" or "Lost the duel, retrying"
	end
	Schematics.set(ctx, "Hibiki is down, waiting for the drawings")
	if ctx:waitFor(owned, Const.SCHEMATIC_GIVE_TIMEOUT) then
		return "done"
	end
	local root = Character.root()
	if root then
		Schematics.claimDrops(ctx, root.Position)
	end
	return owned() and "done" or "wait", "Hibiki fell but no drawings arrived"
end

function Schematics.plates()
	local plates = {}
	for _, plate in ipairs(CollectionService:GetTagged("SimonPlate")) do
		local index = plate:GetAttribute("SimonIndex")
		if type(index) == "number" and plate:IsA("Model") and plate:IsDescendantOf(Workspace) then
			plates[index] = plate
		end
	end
	return plates
end

function Schematics.plateTop(plate)
	local top = nil
	for _, part in ipairs(plate:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "Glow" then
			local y = part.Position.Y + part.Size.Y / 2
			top = top and math.max(top, y) or y
		end
	end
	return top
end

function Schematics.plateQuest()
	local ok, state = pcall(Game.Quests.GetPlayerQuestState, LocalPlayer, Const.SCHEMATIC_PLATE_QUEST)
	return ok and state or nil
end

function Schematics.newer(action, since)
	local event = Schematics.Simon[action]
	return event ~= nil and event.At > since and event or nil
end

function Schematics.stepPlate(ctx, plate, index)
	local top = Schematics.plateTop(plate)
	if not top then
		return false
	end
	local pivot = plate:GetPivot().Position
	local above = CFrame.new(pivot.X, top + Const.SCHEMATIC_PLATE_HOVER, pivot.Z)
	local cancelled = Schematics.cancelled(ctx)
	if not ctx.Lease:MoveTo(above, cancelled) then
		return false
	end
	local stand = CFrame.new(pivot.X, top + Schematics.footOffset() - Const.SCHEMATIC_PLATE_PRESS, pivot.Z)
	local sentAt = os.clock()
	ctx.Lease:MoveTo(stand, cancelled)
	Schematics.hold(ctx, stand)
	local acked = ctx:waitFor(function()
		local step = Schematics.newer("Step", sentAt)
		return (step ~= nil and step.Plate == index) or Schematics.newer("Fail", sentAt) ~= nil or Schematics.newer("Win", sentAt) ~= nil
	end, Const.SCHEMATIC_PLATE_ACK)
	ctx.Lease:MoveTo(above, cancelled)
	return acked
end

function Schematics.playShow(ctx, show, plates)
	local plays = type(show.Plates) == "table" and show.Plates or {}
	local lead = tonumber(show.Lead) or 0
	local step = tonumber(show.Step) or 0
	local ready = show.At + lead + #plays * step + Const.SCHEMATIC_SHOW_PAD
	Schematics.set(ctx, string.format("Watching the plates (%d in this round)", #plays))
	while os.clock() < ready and not ctx.Cancelled do
		task.wait(0.05)
	end
	for position, index in ipairs(plays) do
		if ctx.Cancelled or Schematics.newer("Fail", show.At) then
			return false
		end
		local plate = plates[index]
		if not plate then
			return false
		end
		Schematics.set(ctx, string.format("Walking plate %d (%d of %d)", index, position, #plays))
		Schematics.stepPlate(ctx, plate, index)
	end
	return Schematics.newer("Fail", show.At) == nil
end

function Schematics.runPlates(ctx, entry)
	local owned = Schematics.ownedCheck(entry)
	local state = Schematics.plateQuest()
	if state == "Done" then
		return "blocked", "The Plate Trial is done but the drawings are not in your inventory"
	end
	if state ~= "Doing" then
		local roomOk, roomWhy = QuestRunner.makeRoom(ctx, Const.SCHEMATIC_PLATE_QUEST)
		if not roomOk then
			return "wait", roomWhy
		end
		local ok, text = Schematics.talk(ctx, "Lamplighter Isamu", { "AddQuest", Const.SCHEMATIC_PLATE_QUEST }, function()
			return Schematics.plateQuest() == "Doing"
		end)
		if not ok then
			return "wait", text or "Isamu did not start the Plate Trial"
		end
	end
	local plates = Schematics.plates()
	local center = plates[5]
	if not center then
		return "wait", "The lantern plates are not in the map"
	end
	local hover = center:GetPivot().Position + Vector3.new(0, Const.SCHEMATIC_PLATE_HOVER, 0)
	if not Schematics.goTo(ctx, hover, "the lantern plates") then
		return "wait", "Could not reach the lantern plates"
	end
	ctx:waitFor(function()
		for index = 1, 9 do
			if not plates[index] or not Schematics.plateTop(plates[index]) then
				return false
			end
		end
		return true
	end, Const.SCHEMATIC_PROMPT_WAIT)
	local handled = os.clock() - Const.SCHEMATIC_SHOW_WAIT
	local poked = false
	while not ctx.Cancelled and Schematics.plateQuest() == "Doing" and not owned() do
		local show = Schematics.newer("Show", handled)
		if not show then
			Schematics.hold(ctx, hover)
			Schematics.set(ctx, "Waiting for the plates to light")
			local since = os.clock()
			if not ctx:waitFor(function()
				return Schematics.newer("Show", handled) ~= nil
			end, Const.SCHEMATIC_SHOW_WAIT) then
				if poked then
					return "wait", "The Plate Trial did not start"
				end
				poked = true
				Schematics.stepPlate(ctx, plates[1], 1)
				handled = since
			end
		else
			handled = show.At
			poked = true
			Schematics.playShow(ctx, show, plates)
			Schematics.hold(ctx, hover)
		end
	end
	if ctx:waitFor(owned, Const.SCHEMATIC_GIVE_TIMEOUT) then
		return "done"
	end
	return "wait", "The Plate Trial ended without the drawings"
end

function Schematics.illumination()
	local ok, value = pcall(Game.PlayerStatResolver.GetStatExcept, LocalPlayer, "Illumination", "Progression")
	return ok and tonumber(value) or 0
end

function Schematics.accessorySlots()
	local data = Game.data()
	local accessories = data and data.Inventory:FindFirstChild("Accessories")
	return accessories and accessories:FindFirstChild("Stats")
end

function Schematics.equipAccessory(ctx, slot, id)
	local slots = Schematics.accessorySlots()
	local value = slots and slots:FindFirstChild(slot)
	if not value then
		return false
	end
	if value.Value == id then
		return true
	end
	Game.fire("AccessoryEquip", slot, id, "Stats")
	return ctx:waitFor(function()
		return value.Parent ~= nil and value.Value == id
	end, Const.SCHEMATIC_TALK_TIMEOUT)
end

function Schematics.dimLights(ctx)
	local slots = Schematics.accessorySlots()
	if not slots then
		return false
	end
	Schematics.GearHeld = true
	for _, slot in ipairs(Const.ACCESSORY_SLOTS) do
		local value = slots:FindFirstChild(slot)
		local item = value and value.Value ~= 0 and Game.CharacterInfo.GetItemFromId(LocalPlayer, value.Value)
		local info = item and Game.Items[item.Name]
		local stats = type(info) == "table" and type(info.Stats) == "table" and info.Stats or {}
		if item and item.Name ~= Const.SCHEMATIC_LIT_LANTERN and (tonumber(stats.Illumination) or 0) > 0 then
			if Schematics.Removed[slot] == nil then
				Schematics.Removed[slot] = value.Value
			end
			Schematics.set(ctx, "Taking off " .. item.Name)
			Schematics.equipAccessory(ctx, slot, 0)
		end
	end
	return ctx:waitFor(function()
		return Schematics.illumination() <= 0 or Schematics.wearingLantern()
	end, 2)
end

function Schematics.wearingLantern()
	local ok, list = pcall(Game.CharacterInfo.getEquippedAccessoryStats, LocalPlayer)
	return ok and type(list) == "table" and table.find(list, Const.SCHEMATIC_LIT_LANTERN) ~= nil
end

function Schematics.restoreGear()
	if not Schematics.GearHeld then
		return
	end
	for slot, id in pairs(Schematics.Removed) do
		pcall(Game.fire, "AccessoryEquip", slot, id, "Stats")
	end
	table.clear(Schematics.Removed)
	Schematics.GearHeld = false
end

function Schematics.equipLantern(ctx)
	if Schematics.wearingLantern() then
		return true
	end
	local data = Game.data()
	local entry = data and data.Inventory.Inventory:FindFirstChild(Const.SCHEMATIC_LIT_LANTERN)
	local id = entry and entry:FindFirstChild("Id")
	local slots = Schematics.accessorySlots()
	if not id or not slots then
		return false
	end
	Schematics.GearHeld = true
	local chosen = nil
	for _, slot in ipairs(Const.ACCESSORY_SLOTS) do
		local value = slots:FindFirstChild(slot)
		if value and value.Value == 0 then
			chosen = slot
			break
		end
	end
	chosen = chosen or Const.ACCESSORY_SLOTS[#Const.ACCESSORY_SLOTS]
	local value = slots:FindFirstChild(chosen)
	if value and value.Value ~= 0 and Schematics.Removed[chosen] == nil then
		Schematics.Removed[chosen] = value.Value
	end
	Schematics.set(ctx, "Putting on the Mushroom Lit Lantern")
	return Schematics.equipAccessory(ctx, chosen, id.Value)
end

function Schematics.buyShovel(ctx)
	if Schematics.has("Shovel") then
		return true
	end
	local ok, canBuy, reason = pcall(Game.Shop.CanBuy, LocalPlayer, "Shovel", nil, 1)
	if not ok or canBuy ~= true then
		return false, "blocked", "Needs a Shovel from Winter Store Rep Lynx (" .. Schematics.plain(ok and reason or canBuy) .. ")"
	end
	if not Settings.SchematicSpend then
		return false, "blocked", "Needs a Shovel, turn on Spend Wen to buy one"
	end
	local position = Game.npcPosition("Winter Store Rep Lynx")
	if position and not Schematics.goTo(ctx, position + Const.NPC_STAND_OFFSET, "Winter Store Rep Lynx") then
		return false, "wait", "Could not reach Winter Store Rep Lynx"
	end
	Schematics.set(ctx, "Buying a Shovel")
	Game.fire("PurchaseFromShop", "Shovel", 1)
	if ctx:waitFor(function()
		return Schematics.has("Shovel")
	end, Const.SCHEMATIC_TALK_TIMEOUT) then
		return true
	end
	return false, "wait", "The Shovel purchase did not go through"
end

function Schematics.mound(position)
	for _, mound in ipairs(CollectionService:GetTagged("ChestMound")) do
		if mound:IsA("BasePart") and mound:IsDescendantOf(Workspace) and (mound.Position - position).Magnitude < 10 then
			return mound
		end
	end
	return nil
end

function Schematics.dig(ctx, entry, position, label)
	if not Schematics.goTo(ctx, position + Const.GROUND_STAND_OFFSET, label) then
		return "wait", "Could not reach " .. label
	end
	if not ctx:waitFor(function()
		return Schematics.promptNear(Schematics.mound(position)) ~= nil
	end, Const.SCHEMATIC_PROMPT_WAIT) then
		return "wait", label .. " did not load in"
	end
	local prompt = Schematics.promptNear(Schematics.mound(position))
	if not ctx:waitFor(function()
		return prompt.Parent ~= nil and prompt.Enabled
	end, 3) then
		return "wait", "The game will not let you dig " .. label .. " yet"
	end
	Schematics.set(ctx, "Digging " .. label)
	local owned = Schematics.ownedCheck(entry)
	if Schematics.usePrompt(ctx, prompt, owned) then
		return "done"
	end
	Schematics.claimDrops(ctx, position)
	return owned() and "done" or "wait", "Dug " .. label .. " but no drawings arrived"
end

function Schematics.retsuPaid()
	return GlobalEnv[Const.SCHEMATIC_RETSU_KEY] == game.JobId
end

function Schematics.foxfire()
	local list = {}
	for _, tag in ipairs({ "Foxfire", "FoxfireField" }) do
		for _, item in ipairs(CollectionService:GetTagged(tag)) do
			if item:IsDescendantOf(Workspace) and (item:IsA("BasePart") or item:IsA("Model")) then
				table.insert(list, { Item = item, Field = tag == "FoxfireField" })
			end
		end
	end
	return list
end

function Schematics.walkFoxfire(ctx)
	local lit = function()
		return LocalPlayer:GetAttribute("FoxfireLit") == true
	end
	if not Schematics.goTo(ctx, Const.SCHEMATIC_FOXFIRE_CAVE, "the Foxfire cave") then
		return false
	end
	ctx:waitFor(function()
		return #Schematics.foxfire() > 0
	end, Const.SCHEMATIC_PROMPT_WAIT)
	local night = Game.DayNight.IsNight()
	for _ = 1, Const.SCHEMATIC_FOXFIRE_PASSES do
		local pending = {}
		for _, mushroom in ipairs(Schematics.foxfire()) do
			if mushroom.Field or night then
				table.insert(pending, mushroom.Item)
			end
		end
		if #pending == 0 then
			return lit()
		end
		local total = #pending
		while #pending > 0 and not ctx.Cancelled and not lit() do
			local root = Character.root()
			local best, bestDistance = 1, math.huge
			for index, item in ipairs(pending) do
				local distance = root and (item:GetPivot().Position - root.Position).Magnitude or 0
				if distance < bestDistance then
					best, bestDistance = index, distance
				end
			end
			local item = table.remove(pending, best)
			if item.Parent then
				local position = item:GetPivot().Position
				local stand = CFrame.new(position + Vector3.new(0, Schematics.footOffset(), 0))
				Schematics.set(ctx, string.format("Waking mushrooms (%d of %d)", total - #pending, total))
				if ctx.Lease:MoveTo(stand, Schematics.cancelled(ctx)) then
					Schematics.hold(ctx, stand)
					ctx:sleep(Const.SCHEMATIC_FOXFIRE_STAND)
				end
			end
		end
		if lit() or ctx.Cancelled then
			break
		end
	end
	return lit()
end

function Schematics.foxfireLantern()
	for _, lantern in ipairs(CollectionService:GetTagged("FoxfireLantern")) do
		if lantern:IsDescendantOf(Workspace) then
			return lantern
		end
	end
	return nil
end

function Schematics.lightLantern(ctx)
	if LocalPlayer:GetAttribute("FoxfireLit") ~= true then
		local night = Game.DayNight.IsNight()
		if not Schematics.retsuPaid() then
			if not Settings.SchematicSpend then
				return "blocked", "Retsu wants 2,500 Wen, turn on Spend Wen"
			end
			if not night then
				return "wait", "Retsu only talks after dark, night in " .. Travel.minutes(Game.DayNight.SecondsUntilPhaseChange())
			end
			local data = Game.data()
			local wen = data and data.Wen.Value or 0
			if wen < Const.SCHEMATIC_RETSU_COST then
				return "blocked", "Retsu wants 2,500 Wen"
			end
			if not Schematics.dimLights(ctx) then
				return "wait", "Could not take off your lanterns"
			end
			local ok, text = Schematics.talk(ctx, "Old Trapper Retsu", { "RetsuTellFoxfire" }, function()
				local current = Game.data()
				return current ~= nil and current.Wen.Value <= wen - Const.SCHEMATIC_RETSU_COST
			end)
			if not ok then
				return "wait", text or "Retsu did not take the coin"
			end
			GlobalEnv[Const.SCHEMATIC_RETSU_KEY] = game.JobId
		end
		if not night then
			local field = false
			for _, mushroom in ipairs(Schematics.foxfire()) do
				field = field or mushroom.Field
			end
			if not field then
				return "wait", "The mushrooms only wake at night, night in " .. Travel.minutes(Game.DayNight.SecondsUntilPhaseChange())
			end
		end
		if not Schematics.dimLights(ctx) then
			return "wait", "Could not take off your lanterns"
		end
		if not Schematics.walkFoxfire(ctx) then
			return "wait", "The mushrooms did not light the lantern, retrying"
		end
	end
	Schematics.set(ctx, "Looking for Retsu's lantern")
	if not Schematics.foxfireLantern() then
		Schematics.goTo(ctx, Const.SCHEMATIC_FOXFIRE_CAVE)
		ctx:waitFor(function()
			return Schematics.foxfireLantern() ~= nil
		end, Const.SCHEMATIC_PROMPT_WAIT)
	end
	local lantern = Schematics.foxfireLantern()
	if not lantern then
		return "wait", "Retsu's lantern is not in the cave"
	end
	local position = lantern:GetPivot().Position
	if not Schematics.goTo(ctx, position + Const.GROUND_STAND_OFFSET, "Retsu's lantern") then
		return "wait", "Could not reach Retsu's lantern"
	end
	local got = function()
		return Schematics.has(Const.SCHEMATIC_LIT_LANTERN)
	end
	local prompt = Schematics.promptNear(lantern)
	if prompt then
		Schematics.usePrompt(ctx, prompt, got, 2)
	end
	if not got() then
		Game.fire("FoxfireTake")
		ctx:waitFor(got, Const.SCHEMATIC_GIVE_TIMEOUT)
	end
	if not got() then
		return "wait", "Could not take Retsu's lantern"
	end
	return nil
end

function Schematics.runTanto(ctx, entry)
	local ok, state, text = Schematics.buyShovel(ctx)
	if not ok then
		return state, text
	end
	if not Schematics.has(Const.SCHEMATIC_LIT_LANTERN) then
		state, text = Schematics.lightLantern(ctx)
		if state then
			return state, text
		end
	end
	if not Schematics.equipLantern(ctx) then
		return "wait", "Could not put on the Mushroom Lit Lantern"
	end
	return Schematics.dig(ctx, entry, Const.SCHEMATIC_TANTO_MOUND, "the Tanto mound")
end

function Schematics.runWarFans(ctx, entry)
	local clues = {
		{ 1, "Shiori" },
		{ 2, Const.SCHEMATIC_SOFEN.Name },
		{ 3, "Old Trapper Retsu" },
		{ 4, "Winter Store Rep Lynx" },
	}
	for _, clue in ipairs(clues) do
		local record = "WarFansClue_" .. clue[1]
		if not Schematics.record(record) then
			local ok = Schematics.talk(ctx, clue[2], { "WarFansClue", clue[1] }, function()
				return Schematics.record(record)
			end)
			if not ok then
				return "wait", clue[2] .. " did not share clue " .. clue[1]
			end
		end
	end
	local ok, state, text = Schematics.buyShovel(ctx)
	if not ok then
		return state, text
	end
	return Schematics.dig(ctx, entry, Const.SCHEMATIC_FANS_MOUND, "the War Fans mound")
end

function Schematics.runNpcGift(npc, signal, needs, needsText)
	return function(ctx, entry)
		if needs and not Schematics.has(needs) then
			return "blocked", needsText
		end
		local owned = Schematics.ownedCheck(entry)
		local ok, text = Schematics.talk(ctx, npc, signal, owned)
		if ok or owned() then
			return "done"
		end
		return "wait", text or (npc .. " did not hand over the drawings")
	end
end

function Schematics.runCapstone(series)
	return function(ctx, entry)
		local missing = {}
		for _, other in ipairs(Schematics.Entries) do
			if other.Series == series and not other.Capstone and not Schematics.owned(other) then
				table.insert(missing, other.Label)
			end
		end
		if #missing > 0 then
			return "blocked", "Needs every other " .. series .. " schematic first (" .. #missing .. " missing)"
		end
		local owned = Schematics.ownedCheck(entry)
		local ok, text = Schematics.talk(ctx, "Blacksmith Togane", { "SeriesCapstone", series }, owned)
		if ok or owned() then
			return "done"
		end
		return "wait", text or "Togane did not hand over the set drawings"
	end
end

function Schematics.add(entry)
	entry.Items = entry.Items or { entry.Base .. " Schematic" }
	entry.Option = entry.Series .. ": " .. entry.Label
	table.insert(Schematics.Entries, entry)
	table.insert(Schematics.Options, entry.Option)
	Schematics.ByOption[entry.Option] = entry
end

do
	local function study(series, base)
		Schematics.add({ Series = series, Base = base, Label = string.gsub(base, "^%a+ ", ""), How = "Study the drawings", Run = Schematics.runStudy })
	end
	study("Nightfall", "Nightfall Katana")
	study("Nightfall", "Nightfall Axe and Mace")
	study("Nightfall", "Nightfall Scythe")
	study("Nightfall", "Nightfall Claws")
	study("Nightfall", "Nightfall Mask")
	Schematics.add({ Series = "Nightfall", Base = "Nightfall Sickles", Label = "Sickles", How = "10 levers, then the sewer", Run = Schematics.runSickles })
	Schematics.add({ Series = "Nightfall", Base = "Nightfall Serpent Katana", Label = "Serpent Katana", How = "Serpent Key and box", Run = Schematics.runSerpent })
	Schematics.add({ Series = "Nightfall", Base = "Nightfall Gauntlet", Label = "Gauntlet", How = "Wake the three statues", Run = Schematics.runGauntlet })
	Schematics.add({ Series = "Nightfall", Base = "Nightfall Cape", Label = "Cape", How = "Trade a Lost Cape", Trade = true, Run = Schematics.runNpcGift("Weaver Hatsu", { "SeriesTrade", "Cape" }, "Lost Cape", "Needs a Lost Cape (Lost Chest or fishing)") })
	Schematics.add({ Series = "Nightfall", Label = "Top and Bottom", Items = { "Nightfall Top Schematic", "Nightfall Bottom Schematic" }, How = "Blacksmith set drawings", Capstone = true, Run = Schematics.runCapstone("Nightfall") })
	study("Firstlight", "Firstlight Katana")
	study("Firstlight", "Firstlight Spear")
	study("Firstlight", "Firstlight Insect Katana")
	study("Firstlight", "Firstlight Mask")
	Schematics.add({ Series = "Firstlight", Base = "Firstlight Lantern", Label = "Lantern", How = "Plate Trial", Run = Schematics.runPlates })
	Schematics.add({ Series = "Firstlight", Base = "Firstlight Sound Cleavers", Label = "Sound Cleavers", How = "Duel Hibiki", Run = Schematics.runDuel })
	Schematics.add({ Series = "Firstlight", Base = "Firstlight Tanto", Label = "Tanto", How = "Foxfire lantern and dig", Run = Schematics.runTanto })
	Schematics.add({ Series = "Firstlight", Base = "Firstlight War Fans", Label = "War Fans", How = "Four clues and dig", Run = Schematics.runWarFans })
	Schematics.add({ Series = "Firstlight", Base = "Firstlight Bladed Wagasa", Label = "Bladed Wagasa", Record = "FirstlightWagasa_Schematic", How = "Show Genzo a Damascus Wagasa", Run = Schematics.runNpcGift("Wagasa Maker Genzo", { "WagasaGiveSchematic" }, "Damascus Bladed Wagasa", "Needs a Damascus Bladed Wagasa (crafted in Ouwigahara)") })
	Schematics.add({ Series = "Firstlight", Base = "Firstlight Haori", Label = "Haori", How = "Trade a Lost Outfit", Trade = true, Run = Schematics.runNpcGift("Tailor Omi", { "SeriesTrade", "Haori" }, "Lost Outfit", "Needs a Lost Outfit (Lost Chest or fishing)") })
	Schematics.add({ Series = "Firstlight", Label = "Top and Bottom", Items = { "Firstlight Top Schematic", "Firstlight Bottom Schematic" }, How = "Blacksmith set drawings", Capstone = true, Run = Schematics.runCapstone("Firstlight") })
end

function Schematics.selected(entry)
	local list = Settings.SchematicList
	if #list > 0 then
		return table.find(list, entry.Option) ~= nil
	end
	return not entry.Trade or Settings.SchematicTrades
end

function Schematics.allowed(entry)
	if entry.Trade and not Settings.SchematicTrades then
		return false
	end
	return Schematics.selected(entry)
end

function Schematics.blocker()
	if BossFarm.Context and BossFarm.Current then
		return "Paused for world boss"
	elseif BossHunt.Busy then
		return "Paused for Muzan/Crow"
	elseif YetiFarm.Busy then
		return "Paused for Yeti"
	elseif CacheFarm.Busy then
		return "Paused for cache farm"
	end
	return nil
end

function Schematics.pick()
	for _, entry in ipairs(Schematics.Entries) do
		if Schematics.allowed(entry) and not Schematics.owned(entry) then
			local until_ = Schematics.Skip[entry]
			if not until_ or os.clock() >= until_ then
				return entry
			end
		end
	end
	return nil
end

function Schematics.cleanup(ctx)
	Combat.Override = nil
	if Schematics.Target and Combat.FarmTarget == Schematics.Target then
		Combat.FarmTarget = nil
	end
	Schematics.Target = nil
	Schematics.restoreGear()
	Schematics.restoreGauntlet()
	Schematics.Busy = false
	Schematics.Current = nil
	if ctx then
		ctx.Lease:SetGoal(nil)
	end
end

function Schematics.idle(ctx, phase, seconds)
	Schematics.cleanup(ctx)
	Schematics.set(ctx, phase)
	ctx:sleep(seconds)
end

function Schematics.step(ctx)
	local blocker = Schematics.blocker()
	if blocker then
		Schematics.idle(ctx, blocker, 1)
		return
	end
	if Heal.Retreating or Escape.Active then
		Schematics.idle(ctx, Escape.Active and "Paused, retreating" or "Paused to heal", 0.5)
		return
	end
	if not Character.alive() then
		Schematics.idle(ctx, "Respawning", 0.5)
		return
	end
	local entry = Schematics.pick()
	if not entry then
		local waiting = 0
		for _, other in ipairs(Schematics.Entries) do
			if Schematics.allowed(other) and not Schematics.owned(other) then
				waiting += 1
			end
		end
		Schematics.idle(ctx, waiting > 0 and (waiting .. " waiting, see the list") or "All picked schematics owned", 2)
		return
	end
	Schematics.Busy = true
	Schematics.Current = entry
	local ok, state, text = pcall(entry.Run, ctx, entry)
	Schematics.cleanup(ctx)
	if ctx.Cancelled then
		return
	end
	if not ok then
		warn("[Spryzen Hub] schematic error (" .. entry.Option .. "): " .. tostring(state))
		state, text = "wait", "Error, retrying soon"
	end
	if state == "done" or Schematics.owned(entry) then
		Schematics.Notes[entry] = nil
		Schematics.Skip[entry] = nil
		Hub.Notify({ Title = "Schematic", Content = "Got the " .. entry.Series .. " " .. entry.Label .. " drawings.", Type = "Success", Icon = "scroll", Duration = 5 })
		return
	end
	Schematics.Notes[entry] = { State = state, Text = text or "Retrying" }
	Schematics.Skip[entry] = os.clock() + (state == "blocked" and Const.SCHEMATIC_BLOCKED_FOR or Const.SCHEMATIC_WAIT_FOR)
end

function Schematics.stop()
	local ctx = Schematics.Context
	local thread = Schematics.Thread
	Schematics.Context = nil
	Schematics.Thread = nil
	Schematics.Phase = "Off"
	Schematics.cleanup(nil)
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function Schematics.refresh()
	if not Settings.AutoSchematics then
		Schematics.stop()
		return
	end
	if Schematics.Context then
		return
	end
	table.clear(Schematics.Skip)
	local ctx = Context.new(Mover.acquire("schematics", 14))
	Schematics.Context = ctx
	Schematics.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(Schematics.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] schematics error: " .. tostring(err))
				Schematics.idle(ctx, "Error, retrying", 1)
			end
		end
	end)
end

function Schematics.retry()
	table.clear(Schematics.Skip)
	table.clear(Schematics.Notes)
	table.clear(Schematics.KeysTried)
end

function Schematics.rows()
	local rows = {}
	for _, entry in ipairs(Schematics.Entries) do
		if Schematics.selected(entry) or Schematics.owned(entry) then
			local value, tone
			if Schematics.owned(entry) then
				value, tone = "Owned", "Success"
			elseif entry == Schematics.Current then
				value, tone = "Working", "Accent"
			elseif entry.Trade and not Settings.SchematicTrades then
				value, tone = "Trades off", "Muted"
			elseif Schematics.Notes[entry] then
				local note = Schematics.Notes[entry]
				value, tone = note.Text, note.State == "blocked" and "Error" or "Warning"
			else
				value, tone = entry.How, "Muted"
			end
			table.insert(rows, { Text = entry.Series .. " " .. entry.Label, Value = value, Tone = tone })
		end
	end
	return rows
end

function Schematics.count()
	local owned = 0
	for _, entry in ipairs(Schematics.Entries) do
		if Schematics.owned(entry) then
			owned += 1
		end
	end
	return owned, #Schematics.Entries
end

RootMaid:Give(Schematics.stop)

function BossStats.reset()
	BossStats.StartedAt = os.clock()
	BossStats.StoppedAt = nil
	BossStats.Kills = 0
	BossStats.BossKills = 0
	BossStats.LastBoss = nil
	BossStats.Pouches = 0
	BossStats.PouchSeen = Game.itemCount(Const.COIN_POUCH)
	BossStats.Ores = 0
	BossStats.OreSeen = Game.oreCount()
end

function BossStats.running()
	return BossStats.StartedAt ~= nil and BossStats.StoppedAt == nil
end

function BossStats.record(name, worldBoss)
	if not BossStats.running() then
		return
	end
	BossStats.Kills += 1
	if worldBoss then
		BossStats.BossKills += 1
	end
	BossStats.LastBoss = name
end

function BossStats.elapsed()
	if not BossStats.StartedAt then
		return 0
	end
	return (BossStats.StoppedAt or os.clock()) - BossStats.StartedAt
end

function BossStats.perHour(count)
	return math.floor(count * 3600 / math.max(BossStats.elapsed(), 60))
end

function BossStats.duration(seconds)
	seconds = math.max(math.ceil(seconds), 0)
	if seconds < 60 then
		return seconds .. "s"
	elseif seconds < 3600 then
		return string.format("%dm %ds", seconds // 60, seconds % 60)
	end
	return string.format("%dh %dm", seconds // 3600, seconds % 3600 // 60)
end

function BossStats.worldBossDoing()
	local phase = BossFarm.Phase
	local boss = BossFarm.Focus
	if not boss then
		return phase
	end
	if phase == "Waiting" or phase == "Travelling" or phase == "Running other farms" then
		local state, remaining = WorldBoss.state(boss)
		if state == "Respawning" then
			return "Next: " .. boss.Name .. " in " .. BossStats.duration(remaining)
		end
	end
	return phase .. " " .. boss.Name
end

function BossStats.activity()
	local owner = Mover.Active and Mover.Active.Owner
	if owner == "bosses" then
		return "Auto World Bosses", BossStats.worldBossDoing()
	elseif owner == "yeti" then
		return "Auto Yeti", YetiFarm.Phase
	elseif owner == "hunt" then
		return "Auto Muzan/Crow", BossHunt.Phase
	elseif owner == "cache" then
		return "Cache Farm", CacheFarm.Phase
	elseif owner == "farm" then
		return Farm.mode() or "Farm", Farm.Context and Farm.Context.Status or "Idle"
	elseif owner == "collector" then
		return "Pickups", Collector.Status
	elseif owner == "retreat" then
		return "Healing", Heal.Status
	elseif owner == "escape" then
		return "Retreat", Escape.Status
	elseif owner == "travel" then
		return "Travel", Travel.Status
	end
	if BossFarm.Context then
		return "Auto World Bosses", BossStats.worldBossDoing()
	end
	return "None", "Idle"
end

function BossStats.poll()
	if not BossStats.running() then
		return
	end
	local count = Game.itemCount(Const.COIN_POUCH)
	local seen = BossStats.PouchSeen
	if seen and count > seen then
		BossStats.Pouches += count - seen
	end
	BossStats.PouchSeen = count
	local ores = Game.oreCount()
	local oreSeen = BossStats.OreSeen
	if oreSeen and ores > oreSeen then
		BossStats.Ores += ores - oreSeen
	end
	BossStats.OreSeen = ores
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(BossStats.poll)
		if not ok then
			warn("[Spryzen Hub] boss stats error: " .. tostring(err))
		end
		task.wait(Const.STATS_POLL)
	end
end))

local Visuals = { Overrides = {}, AnimConns = {}, AnimWatch = nil, VfxCache = nil, Blocked = {}, VfxStatus = "Off", CutsceneStatus = "Off", StageWraps = {}, StageHooked = false, Boost = nil, BoostStatus = "Off" }

function Visuals.accountFolder()
	local service = ReplicatedStorage:FindFirstChild("Player_Service")
	local data = service and service:FindFirstChild("Data")
	return data and data:FindFirstChild(LocalPlayer.Name)
end

function Visuals.override(path, value)
	local entry = Visuals.Overrides[path]
	if value == nil then
		if entry then
			Visuals.Overrides[path] = nil
			if entry.Created then
				entry.Instance:Destroy()
			elseif entry.Instance.Parent then
				entry.Instance.Value = entry.Old
			end
		end
		return true
	end
	if entry and entry.Instance.Parent then
		entry.Instance.Value = value
		return true
	end
	local node = Visuals.accountFolder()
	if not node then
		return false
	end
	local segments = string.split(path, "/")
	for index = 1, #segments - 1 do
		local child = node:FindFirstChild(segments[index])
		if not child then
			child = Instance.new("Folder")
			child.Name = segments[index]
			child.Parent = node
		end
		node = child
	end
	local name = segments[#segments]
	local existing = node:FindFirstChild(name)
	if existing and existing:IsA("ValueBase") then
		Visuals.Overrides[path] = { Instance = existing, Old = existing.Value, Created = false }
		existing.Value = value
		return true
	end
	local created = Instance.new(type(value) == "boolean" and "BoolValue" or "NumberValue")
	created.Name = name
	created.Value = value
	created.Parent = node
	Visuals.Overrides[path] = { Instance = created, Created = true }
	return true
end

function Visuals.applyShake()
	Visuals.override(Const.SETTING_SHAKE, Settings.NoScreenShake and 0 or nil)
end

function Visuals.stopAnimator(animator)
	if Visuals.AnimConns[animator] then
		return
	end
	for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
		track:Stop(0)
	end
	Visuals.AnimConns[animator] = animator.AnimationPlayed:Connect(function(track)
		track:Stop(0)
	end)
end

function Visuals.applyAnimations()
	if not Settings.DisableAnimations then
		if Visuals.AnimWatch then
			Visuals.AnimWatch:Disconnect()
			Visuals.AnimWatch = nil
		end
		for animator, connection in pairs(Visuals.AnimConns) do
			connection:Disconnect()
			Visuals.AnimConns[animator] = nil
		end
		return
	end
	if Visuals.AnimWatch then
		return
	end
	Visuals.AnimWatch = Workspace.DescendantAdded:Connect(function(instance)
		if instance:IsA("Animator") then
			task.defer(function()
				if Settings.DisableAnimations and instance.Parent then
					Visuals.stopAnimator(instance)
				end
			end)
		end
	end)
	for _, instance in ipairs(Workspace:GetDescendants()) do
		if instance:IsA("Animator") then
			Visuals.stopAnimator(instance)
		end
	end
end

function Visuals.pruneAnimators()
	for animator, connection in pairs(Visuals.AnimConns) do
		if not animator.Parent then
			connection:Disconnect()
			Visuals.AnimConns[animator] = nil
		end
	end
end

function Visuals.effectCache()
	if Visuals.VfxCache then
		return Visuals.VfxCache
	end
	if type(getsenv) ~= "function" or type(debug.getupvalue) ~= "function" then
		return nil, "Executor has no getsenv"
	end
	local scripts = LocalPlayer:FindFirstChild("PlayerScripts")
	local folder = scripts and scripts:FindFirstChild("CU")
	local receiver = folder and folder:FindFirstChild("ClientEffectSignalReceiver")
	if not receiver then
		return nil, "Effect receiver not found"
	end
	local ok, env = pcall(getsenv, receiver)
	local handler = ok and type(env) == "table" and env.do_tang
	if type(handler) ~= "function" then
		return nil, "Effect handler not found"
	end
	local cache = debug.getupvalue(handler, 1)
	if type(cache) ~= "table" then
		return nil, "Effect cache not found"
	end
	Visuals.VfxCache = cache
	return cache
end

function Visuals.setBlocked(group, names)
	local cache = Visuals.VfxCache
	local saved = Visuals.Blocked[group]
	if not names then
		if cache and saved then
			for name, entry in pairs(saved) do
				cache[name] = entry.Value
			end
		end
		Visuals.Blocked[group] = nil
		return true
	end
	if saved then
		return true
	end
	local reason
	cache, reason = Visuals.effectCache()
	if not cache then
		return false, reason
	end
	local noop = function() end
	saved = {}
	local count = 0
	for _, name in ipairs(names) do
		if not saved[name] then
			saved[name] = { Value = cache[name] }
			cache[name] = noop
			count += 1
		end
	end
	Visuals.Blocked[group] = saved
	return true, count
end

function Visuals.applyVfx()
	if not Settings.DisableSkillVfx then
		Visuals.setBlocked("vfx", nil)
		Visuals.VfxStatus = "Off"
		return
	end
	if Visuals.Blocked.vfx then
		return
	end
	local effects = ReplicatedStorage:FindFirstChild("Effects")
	local names = {}
	for _, folderName in ipairs(Const.SKILL_VFX_FOLDERS) do
		local folder = effects and effects:FindFirstChild(folderName)
		if folder then
			for _, module in ipairs(folder:GetDescendants()) do
				if module:IsA("ModuleScript") then
					table.insert(names, module.Name)
				end
			end
		end
	end
	local ok, result = Visuals.setBlocked("vfx", names)
	Visuals.VfxStatus = ok and (tostring(result) .. " effects hidden") or result
end

function Visuals.wrapStage(name, handler)
	if type(handler) ~= "function" or Visuals.StageWraps[handler] then
		return handler
	end
	local wrapped = function(...)
		if Settings.DisableCutscenes then
			local first, second, third = ...
			if first == Const.CUTSCENE_STAGE or second == Const.CUTSCENE_STAGE or third == Const.CUTSCENE_STAGE then
				return
			end
		end
		return handler(...)
	end
	Visuals.StageWraps[wrapped] = { Name = name, Original = handler }
	return wrapped
end

function Visuals.hookStages(enabled)
	local cache = Visuals.VfxCache
	if not cache then
		return
	end
	if enabled then
		if Visuals.StageHooked then
			return
		end
		if getmetatable(cache) ~= nil then
			return
		end
		for name, handler in pairs(cache) do
			cache[name] = Visuals.wrapStage(name, handler)
		end
		setmetatable(cache, {
			__newindex = function(target, name, handler)
				rawset(target, name, Visuals.wrapStage(name, handler))
			end,
		})
		Visuals.StageHooked = true
		return
	end
	if not Visuals.StageHooked then
		return
	end
	setmetatable(cache, nil)
	Visuals.StageHooked = false
	for name, handler in pairs(cache) do
		local wrap = Visuals.StageWraps[handler]
		if wrap then
			cache[name] = wrap.Original
		end
	end
	table.clear(Visuals.StageWraps)
end

function Visuals.applyCutscenes()
	if not Settings.DisableCutscenes then
		Visuals.setBlocked("cutscene", nil)
		Visuals.hookStages(false)
		Visuals.CutsceneStatus = "Off"
		return
	end
	local ok, reason = Visuals.setBlocked("cutscene", Const.CUTSCENE_EFFECTS)
	if ok then
		Visuals.hookStages(true)
	end
	Visuals.CutsceneStatus = ok and "Blocked" or reason
end

function Visuals.boostInstance(instance, boost)
	if instance:IsA("ParticleEmitter") or instance:IsA("Trail") or instance:IsA("Beam") or instance:IsA("Smoke") or instance:IsA("Fire") or instance:IsA("Sparkles") then
		if instance.Enabled then
			boost.Changed[instance] = "Enabled"
			instance.Enabled = false
		end
	elseif instance:IsA("Decal") or instance:IsA("Texture") then
		if instance.Transparency < 1 then
			boost.Changed[instance] = instance.Transparency
			instance.Transparency = 1
		end
	end
end

function Visuals.applyBoost()
	local boost = Visuals.Boost
	if not Settings.FpsBoost then
		if not boost then
			return
		end
		Visuals.Boost = nil
		boost.Cancelled = true
		if boost.Watch then
			boost.Watch:Disconnect()
		end
		for _, path in ipairs(Const.BOOST_SETTINGS) do
			Visuals.override(path[1], nil)
		end
		for target, properties in pairs(boost.Saved) do
			for property, value in pairs(properties) do
				pcall(function()
					target[property] = value
				end)
			end
		end
		for instance, value in pairs(boost.Changed) do
			if instance.Parent then
				if value == "Enabled" then
					instance.Enabled = true
				else
					instance.Transparency = value
				end
			end
		end
		Visuals.BoostStatus = "Off"
		return
	end
	if boost then
		return
	end
	boost = { Saved = {}, Changed = setmetatable({}, { __mode = "k" }), Cancelled = false, Watch = nil }
	Visuals.Boost = boost
	for _, path in ipairs(Const.BOOST_SETTINGS) do
		Visuals.override(path[1], path[2])
	end
	local function set(target, property, value)
		local ok, old = pcall(function()
			return target[property]
		end)
		if ok and pcall(function()
			target[property] = value
		end) then
			boost.Saved[target] = boost.Saved[target] or {}
			if boost.Saved[target][property] == nil then
				boost.Saved[target][property] = old
			end
		end
	end
	local Lighting = game:GetService("Lighting")
	set(Lighting, "GlobalShadows", false)
	set(Lighting, "FogEnd", 1e6)
	for _, effect in ipairs(Lighting:GetChildren()) do
		if effect:IsA("PostEffect") then
			set(effect, "Enabled", false)
		end
	end
	local terrain = Workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		set(terrain, "Decoration", false)
		set(terrain, "WaterWaveSize", 0)
		set(terrain, "WaterReflectance", 0)
	end
	pcall(function()
		set(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01)
	end)
	boost.Watch = Workspace.DescendantAdded:Connect(function(instance)
		Visuals.boostInstance(instance, boost)
	end)
	Visuals.BoostStatus = "Sweeping map"
	task.spawn(function()
		local list = Workspace:GetDescendants()
		for index, instance in ipairs(list) do
			if boost.Cancelled then
				return
			end
			Visuals.boostInstance(instance, boost)
			if index % Const.BOOST_BATCH == 0 then
				task.wait()
			end
		end
		if not boost.Cancelled then
			Visuals.BoostStatus = "On"
		end
	end)
end

function Visuals.stop()
	Settings.NoScreenShake = false
	Settings.DisableAnimations = false
	Settings.DisableSkillVfx = false
	Settings.DisableCutscenes = false
	Settings.FpsBoost = false
	Visuals.applyBoost()
	Visuals.applyVfx()
	Visuals.applyCutscenes()
	Visuals.applyAnimations()
	Visuals.applyShake()
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	pcall(Visuals.applyAnimations)
	pcall(Visuals.applyCutscenes)
	while true do
		task.wait(5)
		pcall(Visuals.pruneAnimators)
	end
end))

RootMaid:Give(Visuals.stop)

local Spectate = { Subject = nil }

function Spectate.step()
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end
	local target = Settings.SpectateEnemy and Combat.farmTarget() or nil
	local humanoid = target and target:FindFirstChildOfClass("Humanoid")
	if humanoid then
		if camera.CameraSubject ~= humanoid then
			camera.CameraSubject = humanoid
		end
		Spectate.Subject = humanoid
	elseif Spectate.Subject then
		Spectate.Subject = nil
		local own = Character.humanoid()
		if own then
			camera.CameraSubject = own
		end
	end
end

RootMaid:Give(RunService.RenderStepped:Connect(function()
	local ok, err = pcall(Spectate.step)
	if not ok then
		warn("[Spryzen Hub] spectate error: " .. tostring(err))
	end
end))

RootMaid:Give(function()
	Settings.SpectateEnemy = false
	pcall(Spectate.step)
end)

local Xray = { Parts = setmetatable({}, { __mode = "k" }), Connection = nil, Generation = 0 }

function Xray.eligible(part)
	if not part:IsA("BasePart") or part:IsA("Terrain") then
		return false
	end
	local parent = part.Parent
	while parent and parent ~= Workspace do
		if parent:IsA("Model") and parent:FindFirstChildOfClass("Humanoid") then
			return false
		end
		parent = parent.Parent
	end
	return true
end

function Xray.apply(part)
	if Xray.eligible(part) then
		Xray.Parts[part] = true
		part.LocalTransparencyModifier = Settings.XrayAmount
	end
end

function Xray.restore()
	for part in pairs(Xray.Parts) do
		pcall(function()
			part.LocalTransparencyModifier = 0
		end)
	end
	table.clear(Xray.Parts)
end

function Xray.set(enabled)
	Xray.Generation += 1
	if Xray.Connection then
		Xray.Connection:Disconnect()
		Xray.Connection = nil
	end
	Xray.restore()
	if not enabled then
		return
	end
	local generation = Xray.Generation
	Xray.Connection = Workspace.DescendantAdded:Connect(function(part)
		if Settings.MapXray then
			pcall(Xray.apply, part)
		end
	end)
	task.spawn(function()
		for index, part in ipairs(Workspace:GetDescendants()) do
			if generation ~= Xray.Generation then
				return
			end
			pcall(Xray.apply, part)
			if index % 2000 == 0 then
				task.wait()
			end
		end
	end)
end

function Xray.refresh()
	for part in pairs(Xray.Parts) do
		pcall(function()
			part.LocalTransparencyModifier = Settings.XrayAmount
		end)
	end
end

RootMaid:Give(function()
	Xray.set(false)
end)

local ShiftLock = { Bound = false, Restore = nil }

function ShiftLock.enforce()
	local handler = Game.RunHandler
	if handler.Shift_lock == 1 then
		handler.SetShiftLock(0)
	end
end

function ShiftLock.set(disabled)
	if disabled == ShiftLock.Bound then
		return
	end
	local handler = Game.RunHandler
	if disabled then
		ShiftLock.Restore = handler.Shift_lock
		RunService:BindToRenderStep(Const.SHIFT_LOCK_STEP, Enum.RenderPriority.Camera.Value - 1, ShiftLock.enforce)
		ShiftLock.Bound = true
		ShiftLock.enforce()
		return
	end
	RunService:UnbindFromRenderStep(Const.SHIFT_LOCK_STEP)
	ShiftLock.Bound = false
	if ShiftLock.Restore == 1 then
		handler.SetShiftLock(1)
	end
	ShiftLock.Restore = nil
end

RootMaid:Give(function()
	ShiftLock.set(false)
end)

local HitFlash = { GuiConnection = nil, MiscConnection = nil }

function HitFlash.hide(child)
	if child:IsA("ImageLabel") and child.Image == Const.HIT_FLASH_IMAGE then
		child.Visible = false
	end
end

function HitFlash.watch(misc)
	if HitFlash.MiscConnection then
		HitFlash.MiscConnection:Disconnect()
	end
	HitFlash.MiscConnection = misc.ChildAdded:Connect(HitFlash.hide)
	for _, child in ipairs(misc:GetChildren()) do
		HitFlash.hide(child)
	end
end

function HitFlash.set(enabled)
	for _, key in ipairs({ "GuiConnection", "MiscConnection" }) do
		if HitFlash[key] then
			HitFlash[key]:Disconnect()
			HitFlash[key] = nil
		end
	end
	local playerGui = enabled and LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not playerGui then
		return
	end
	HitFlash.GuiConnection = playerGui.ChildAdded:Connect(function(child)
		if child.Name == Const.HIT_FLASH_GUI and child:IsA("ScreenGui") then
			HitFlash.watch(child)
		end
	end)
	local misc = playerGui:FindFirstChild(Const.HIT_FLASH_GUI)
	if misc then
		HitFlash.watch(misc)
	end
end

RootMaid:Give(function()
	HitFlash.set(false)
end)

local FpsCap = {
	Supported = type(setfpscap) == "function",
	Input = nil,
	Original = nil,
	Applied = nil,
	Counter = nil,
	Frames = 0,
	CountedAt = 0,
	Measured = nil,
}

function FpsCap.target()
	local value = tonumber(FpsCap.Input and FpsCap.Input:Get() or "")
	if not value or value ~= value then
		return nil
	end
	return math.clamp(math.floor(value + 0.5), Const.FPS_CAP_MIN, Const.FPS_CAP_MAX)
end

function FpsCap.current()
	if type(getfpscap) ~= "function" then
		return nil
	end
	local ok, value = pcall(getfpscap)
	return ok and tonumber(value) or nil
end

function FpsCap.setCounting(enabled)
	if enabled and not FpsCap.Counter then
		FpsCap.Frames, FpsCap.CountedAt, FpsCap.Measured = 0, os.clock(), nil
		FpsCap.Counter = RunService.RenderStepped:Connect(function()
			FpsCap.Frames += 1
		end)
	elseif not enabled and FpsCap.Counter then
		FpsCap.Counter:Disconnect()
		FpsCap.Counter = nil
		FpsCap.Measured = nil
	end
end

function FpsCap.release()
	FpsCap.setCounting(false)
	if FpsCap.Applied then
		pcall(setfpscap, FpsCap.Original or Const.FPS_CAP_DEFAULT)
		FpsCap.Applied = nil
	end
end

function FpsCap.apply()
	if not FpsCap.Supported then
		return
	end
	if not Settings.FpsCap then
		FpsCap.release()
		return
	end
	FpsCap.setCounting(true)
	local target = FpsCap.target()
	if target then
		if FpsCap.Original == nil then
			FpsCap.Original = FpsCap.current() or Const.FPS_CAP_DEFAULT
		end
		if target ~= FpsCap.Applied or FpsCap.current() ~= target then
			local ok, err = pcall(setfpscap, target)
			if not ok then
				warn("[Spryzen Hub] fps cap failed: " .. tostring(err))
				return
			end
			FpsCap.Applied = target
		end
	end
end

function FpsCap.statusText()
	if not FpsCap.Supported then
		return "Executor has no setfpscap", "Error"
	end
	if not Settings.FpsCap then
		return "Off", "Muted"
	end
	if not FpsCap.target() then
		local text = "Enter a number from " .. Const.FPS_CAP_MIN .. " to " .. Const.FPS_CAP_MAX
		if FpsCap.Applied then
			text ..= ", keeping " .. FpsCap.Applied
		end
		return text, "Warning"
	end
	local text = "Capped at " .. tostring(FpsCap.Applied or FpsCap.target())
	if FpsCap.Measured then
		text ..= ", running " .. FpsCap.Measured .. " FPS"
	end
	return text, "Success"
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		task.wait(Const.FPS_CAP_POLL)
		if FpsCap.Counter then
			local now = os.clock()
			FpsCap.Measured = math.floor(FpsCap.Frames / math.max(now - FpsCap.CountedAt, 1e-3) + 0.5)
			FpsCap.Frames, FpsCap.CountedAt = 0, now
		end
		if Settings.FpsCap then
			FpsCap.apply()
		end
	end
end))

RootMaid:Give(FpsCap.release)

local NameHide = { Replacement = "gg/synapsex", Labels = {}, Humanoids = {}, Connections = {}, Generation = 0 }

function NameHide.swap(text)
	local names = { LocalPlayer.Name, LocalPlayer.DisplayName }
	if #names[2] > #names[1] then
		names[1], names[2] = names[2], names[1]
	end
	for _, name in ipairs(names) do
		if name ~= "" then
			text = string.gsub(text, string.gsub(name, "%p", "%%%0"), NameHide.Replacement)
		end
	end
	return text
end

function NameHide.update(label)
	local entry = NameHide.Labels[label]
	local text = label.Text
	local swapped = NameHide.swap(text)
	if swapped ~= text then
		entry.Original = text
		entry.Swapped = swapped
		label.Text = swapped
	end
end

function NameHide.track(object)
	if NameHide.Labels[object] or not (object:IsA("TextLabel") or object:IsA("TextButton")) then
		return
	end
	if object:IsDescendantOf(Workspace) and not object:FindFirstAncestorWhichIsA("LayerCollector") then
		return
	end
	local entry = {}
	NameHide.Labels[object] = entry
	entry.Connection = object:GetPropertyChangedSignal("Text"):Connect(function()
		if Settings.HideName then
			pcall(NameHide.update, object)
		end
	end)
	entry.Destroying = object.Destroying:Connect(function()
		entry.Connection:Disconnect()
		entry.Destroying:Disconnect()
		NameHide.Labels[object] = nil
	end)
	NameHide.update(object)
end

function NameHide.humanoid(character)
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid and not NameHide.Humanoids[humanoid] then
		NameHide.Humanoids[humanoid] = humanoid.DisplayName
		humanoid.DisplayName = NameHide.Replacement
	end
end

function NameHide.watch(root)
	table.insert(NameHide.Connections, root.DescendantAdded:Connect(function(object)
		if Settings.HideName then
			pcall(NameHide.track, object)
		end
	end))
	local generation = NameHide.Generation
	task.spawn(function()
		for index, object in ipairs(root:GetDescendants()) do
			if generation ~= NameHide.Generation then
				return
			end
			pcall(NameHide.track, object)
			if index % 2000 == 0 then
				task.wait()
			end
		end
	end)
end

function NameHide.set(enabled)
	NameHide.Generation += 1
	for _, connection in ipairs(NameHide.Connections) do
		connection:Disconnect()
	end
	table.clear(NameHide.Connections)
	for label, entry in pairs(NameHide.Labels) do
		entry.Connection:Disconnect()
		entry.Destroying:Disconnect()
		if entry.Original and label.Parent then
			pcall(function()
				if label.Text == entry.Swapped then
					label.Text = entry.Original
				end
			end)
		end
	end
	table.clear(NameHide.Labels)
	for humanoid, original in pairs(NameHide.Humanoids) do
		pcall(function()
			humanoid.DisplayName = original
		end)
	end
	table.clear(NameHide.Humanoids)
	if not enabled then
		return
	end
	table.insert(NameHide.Connections, LocalPlayer.CharacterAdded:Connect(function(character)
		if Settings.HideName then
			local humanoid = character:WaitForChild("Humanoid", 10)
			if humanoid and Settings.HideName then
				pcall(NameHide.humanoid, character)
			end
		end
	end))
	pcall(NameHide.humanoid, LocalPlayer.Character)
	for _, root in ipairs({ LocalPlayer:FindFirstChildOfClass("PlayerGui"), Workspace }) do
		if root then
			NameHide.watch(root)
		end
	end
	local ok, err = pcall(function()
		NameHide.watch(game:GetService("CoreGui"))
	end)
	if not ok then
		warn("[Spryzen Hub] hide name CoreGui error: " .. tostring(err))
	end
end

RootMaid:Give(function()
	NameHide.set(false)
end)

local Esp = { Targets = {}, Pool = {}, CollectAt = 0, Party = {} }

Esp.Supported = type(Drawing) == "table" and type(Drawing.new) == "function"
Esp.Font = Esp.Supported and type(Drawing.Fonts) == "table" and Drawing.Fonts.Plex or 2

Esp.Edges = { { 1, 2 }, { 2, 4 }, { 4, 3 }, { 3, 1 }, { 5, 6 }, { 6, 8 }, { 8, 7 }, { 7, 5 }, { 1, 5 }, { 2, 6 }, { 3, 7 }, { 4, 8 } }

function Esp.anyEnabled()
	return Settings.EspPlayers or Settings.EspMobs or Settings.EspBosses or Settings.EspNpcs or Settings.EspMuzan or Settings.EspLily or Settings.EspChest or Settings.EspHorse
end

function Esp.playerInfo(player)
	local data = Game.Utility.GetData(player)
	if not data then
		return nil
	end
	local exp = data:FindFirstChild("Exp")
	local goal = exp and exp:FindFirstChild("Goal")
	local race = data:FindFirstChild("Race")
	local clan = data:FindFirstChild("Clan")
	local parts = {}
	if goal then
		table.insert(parts, "Lv " .. math.floor(goal.Value / Game.GameSettings.expPerLevel))
	end
	if race and race.Value ~= "" then
		table.insert(parts, race.Value)
	end
	if clan and clan.Value ~= "" then
		table.insert(parts, clan.Value)
	end
	return table.concat(parts, " | ")
end

function Esp.partySet()
	local set = {}
	local ok, members = pcall(Game.PartyWatcher.GetMembers)
	if ok and type(members) == "table" then
		for _, member in ipairs(members) do
			if type(member) == "table" and member.UserId then
				set[member.UserId] = true
			end
		end
	end
	return set
end

function Esp.collect()
	local list = {}
	local function add(model, color, label, info)
		if not model or not model.Parent then
			return
		end
		local humanoid = model:FindFirstChildOfClass("Humanoid")
		local anchor = model:FindFirstChild("HumanoidRootPart")
		local size = nil
		if not (humanoid and anchor) then
			humanoid, anchor = nil, nil
			local ok, extents = pcall(model.GetExtentsSize, model)
			size = ok and extents or Vector3.new(4, 4, 4)
			size = Vector3.new(math.min(size.X, Const.ESP_ITEM_MAX_SIZE), math.min(size.Y, Const.ESP_ITEM_MAX_SIZE), math.min(size.Z, Const.ESP_ITEM_MAX_SIZE))
		end
		table.insert(list, { Model = model, Humanoid = humanoid, Anchor = anchor, Size = size, Color = color, Label = label or model.Name, Info = info })
	end
	if Settings.EspPlayers then
		local party = Esp.partySet()
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				local info = Settings.EspPlayerInfo and Esp.playerInfo(player) or nil
				add(player.Character, party[player.UserId] and Settings.EspPartyColor or Settings.EspEnemyColor, player.DisplayName, info)
			end
		end
	end
	if Settings.EspMobs or Settings.EspBosses then
		Mobs.eachAlive(function(model, _, entry)
			if model:GetAttribute("IsMob") == true then
				local boss = entry ~= nil and entry.Boss
				if boss and Settings.EspBosses then
					add(model, Settings.EspBossColor)
				elseif not boss and Settings.EspMobs then
					add(model, Settings.EspMobColor)
				end
			end
		end)
	end
	local debree = Workspace:FindFirstChild("Debree")
	local regions = debree and debree:FindFirstChild("Regions")
	if regions and (Settings.EspNpcs or Settings.EspHorse) then
		for _, region in ipairs(regions:GetChildren()) do
			local stationary = Settings.EspNpcs and region:FindFirstChild("StationaryNpcs")
			if stationary then
				for _, npc in ipairs(stationary:GetChildren()) do
					if npc:IsA("Model") and npc.Name ~= "Muzan" then
						add(npc, Settings.EspNpcColor)
					end
				end
			end
			local active = Settings.EspHorse and region:FindFirstChild("ActiveNpcs")
			local horses = active and active:FindFirstChild("Horse")
			if horses then
				for _, horse in ipairs(horses:GetChildren()) do
					if horse:IsA("Model") then
						add(horse, Settings.EspHorseColor, "Wild Horse")
					end
				end
			end
		end
	end
	if Settings.EspMuzan then
		add(Travel.muzanModel(), Settings.EspMuzanColor)
	end
	if Settings.EspLily then
		for _, lily in ipairs(Travel.spiderLilies()) do
			add(lily, Settings.EspLilyColor)
		end
	end
	if Settings.EspChest then
		for _, model in ipairs(CollectionService:GetTagged(Game.GameSettings.Tags.Chest or "Chest")) do
			if model:IsA("Model") and model:IsDescendantOf(Workspace) and not Collector.modelOpen(model) then
				add(model, Settings.EspChestColor, "Chest")
			end
		end
	end
	return list
end

function Esp.drawing(kind, props)
	local object = Drawing.new(kind)
	for key, value in pairs(props) do
		object[key] = value
	end
	return object
end

function Esp.text(size, center)
	local object = Esp.drawing("Text", { Size = size, Center = center, Outline = true, OutlineColor = Color3.new(0, 0, 0), Visible = false })
	pcall(function()
		object.Font = Esp.Font
	end)
	return object
end

function Esp.pixel(x, y)
	return Vector2.new(math.floor(x + 0.5), math.floor(y + 0.5))
end

function Esp.entry(model)
	local entry = Esp.Pool[model]
	if entry then
		return entry
	end
	entry = { Lines = {} }
	entry.Box = Esp.drawing("Square", { Thickness = 1, Filled = false, Visible = false })
	entry.Fill = Esp.drawing("Square", { Thickness = 1, Filled = true, Transparency = 0.2, Visible = false })
	entry.Name = Esp.text(15, true)
	entry.Info = Esp.text(13, true)
	entry.Distance = Esp.text(13, true)
	entry.HealthText = Esp.text(13, false)
	entry.BarBack = Esp.drawing("Line", { Thickness = 4, Color = Color3.new(0, 0, 0), Visible = false })
	entry.Bar = Esp.drawing("Line", { Thickness = 2, Visible = false })
	entry.Tracer = Esp.drawing("Line", { Thickness = 1, Visible = false })
	for index = 1, #Esp.Edges do
		entry.Lines[index] = Esp.drawing("Line", { Thickness = 1, Visible = false })
	end
	Esp.Pool[model] = entry
	return entry
end

function Esp.hide(entry)
	for key, object in pairs(entry) do
		if key == "Lines" then
			for _, line in ipairs(object) do
				line.Visible = false
			end
		else
			object.Visible = false
		end
	end
end

function Esp.remove(model)
	local entry = Esp.Pool[model]
	if not entry then
		return
	end
	Esp.Pool[model] = nil
	for key, object in pairs(entry) do
		if key == "Lines" then
			for _, line in ipairs(object) do
				line:Remove()
			end
		else
			object:Remove()
		end
	end
end

function Esp.frame(target)
	if target.Anchor then
		if not target.Anchor.Parent then
			return nil
		end
		local scale = target.Anchor.Size.Y / 2
		return target.Anchor.CFrame * CFrame.new(0, -0.25 * scale, 0), Vector3.new(4, 5.5, 1.5) * scale
	end
	if not target.Model.Parent then
		return nil
	end
	return CFrame.new(target.Model:GetPivot().Position), target.Size
end

function Esp.render(target, camera, origin, viewport)
	local cframe, size = Esp.frame(target)
	local entry = Esp.entry(target.Model)
	if not cframe then
		Esp.hide(entry)
		return
	end
	local distance = (cframe.Position - origin).Magnitude
	if distance > Settings.EspMaxDistance then
		Esp.hide(entry)
		return
	end
	local half = size / 2
	local points, visible = {}, true
	local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
	for index = 1, 8 do
		local offset = Vector3.new(index % 2 == 1 and -half.X or half.X, index <= 4 and -half.Y or half.Y, (index - 1) % 4 < 2 and -half.Z or half.Z)
		local screen = camera:WorldToViewportPoint((cframe * CFrame.new(offset)).Position)
		if screen.Z <= 0 then
			visible = false
			break
		end
		points[index] = Vector2.new(screen.X, screen.Y)
		minX, minY = math.min(minX, screen.X), math.min(minY, screen.Y)
		maxX, maxY = math.max(maxX, screen.X), math.max(maxY, screen.Y)
	end
	if not visible or maxX < 0 or maxY < 0 or minX > viewport.X or minY > viewport.Y then
		Esp.hide(entry)
		return
	end
	local color = target.Color
	local topLeft = Vector2.new(minX, minY)
	local boxSize = Vector2.new(maxX - minX, maxY - minY)
	local centerX = (minX + maxX) / 2

	entry.Box.Visible = Settings.EspBox
	if Settings.EspBox then
		entry.Box.Position, entry.Box.Size, entry.Box.Color = topLeft, boxSize, color
	end
	entry.Fill.Visible = Settings.EspBoxFill
	if Settings.EspBoxFill then
		entry.Fill.Position, entry.Fill.Size, entry.Fill.Color = topLeft, boxSize, color
	end
	for index, edge in ipairs(Esp.Edges) do
		local line = entry.Lines[index]
		line.Visible = Settings.Esp3D
		if Settings.Esp3D then
			line.From, line.To, line.Color = points[edge[1]], points[edge[2]], color
		end
	end

	local textTop = minY - 17
	entry.Name.Visible = Settings.EspName
	if Settings.EspName then
		entry.Name.Text, entry.Name.Color, entry.Name.Position = target.Label, Settings.EspNameColor, Esp.pixel(centerX, textTop)
		textTop -= 15
	end
	entry.Info.Visible = target.Info ~= nil
	if target.Info then
		entry.Info.Text, entry.Info.Color, entry.Info.Position = target.Info, Settings.EspPlayerInfoColor, Esp.pixel(centerX, textTop)
	end
	entry.Distance.Visible = Settings.EspDistance
	if Settings.EspDistance then
		entry.Distance.Text, entry.Distance.Color, entry.Distance.Position = math.floor(distance) .. " studs", Settings.EspDistanceColor, Esp.pixel(centerX, maxY + 2)
	end

	local humanoid = target.Humanoid
	local hasHealth = humanoid ~= nil and humanoid.Parent ~= nil and humanoid.MaxHealth > 0
	local fraction = hasHealth and math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1) or 0
	local barX = minX - 5
	entry.BarBack.Visible = Settings.EspHealthBar and hasHealth
	entry.Bar.Visible = Settings.EspHealthBar and hasHealth
	if Settings.EspHealthBar and hasHealth then
		entry.BarBack.From, entry.BarBack.To = Vector2.new(barX, maxY + 1), Vector2.new(barX, minY - 1)
		entry.Bar.From, entry.Bar.To = Vector2.new(barX, maxY), Vector2.new(barX, maxY - (maxY - minY) * fraction)
		entry.Bar.Color = Settings.EspDyingColor:Lerp(Settings.EspHealthColor, fraction)
	end
	entry.HealthText.Visible = Settings.EspHealthText and hasHealth
	if Settings.EspHealthText and hasHealth then
		entry.HealthText.Text = tostring(math.floor(humanoid.Health))
		entry.HealthText.Color = Settings.EspHealthTextColor
		entry.HealthText.Position = Esp.pixel(barX - 4 - entry.HealthText.TextBounds.X, maxY - (maxY - minY) * fraction - 7)
	end

	entry.Tracer.Visible = Settings.EspTracer
	if Settings.EspTracer then
		entry.Tracer.From, entry.Tracer.To, entry.Tracer.Color = Vector2.new(viewport.X / 2, viewport.Y), Vector2.new(centerX, maxY), color
	end
end

function Esp.step()
	if not Esp.Supported then
		return
	end
	if not Esp.anyEnabled() then
		if next(Esp.Pool) then
			for model in pairs(Esp.Pool) do
				Esp.remove(model)
			end
		end
		Esp.Targets = {}
		return
	end
	if os.clock() >= Esp.CollectAt then
		Esp.CollectAt = os.clock() + Const.ESP_COLLECT
		Esp.Targets = Esp.collect()
		local live = {}
		for _, target in ipairs(Esp.Targets) do
			live[target.Model] = true
		end
		for model in pairs(Esp.Pool) do
			if not live[model] then
				Esp.remove(model)
			end
		end
	end
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end
	local origin = camera.CFrame.Position
	local viewport = camera.ViewportSize
	for _, target in ipairs(Esp.Targets) do
		Esp.render(target, camera, origin, viewport)
	end
end

RootMaid:Give(RunService.RenderStepped:Connect(function()
	local ok, err = pcall(Esp.step)
	if not ok then
		warn("[Spryzen Hub] esp error: " .. tostring(err))
		Esp.Targets = {}
		Esp.CollectAt = os.clock() + 1
	end
end))

RootMaid:Give(function()
	for model in pairs(Esp.Pool) do
		Esp.remove(model)
	end
end)

local InstantKill = { Kills = 0, Last = nil }

function InstantKill.supported()
	return type(isnetworkowner) == "function"
end

function InstantKill.step()
	if not (Settings.InstantKill or Settings.YetiMinionKill or Settings.CacheGuardKill) or not InstantKill.supported() then
		return
	end
	local threshold = Settings.KillAtHp
	Mobs.eachAlive(function(model, root, entry)
		if Mobs.isCombatTarget(model, entry) and isnetworkowner(root) then
			local humanoid = model:FindFirstChildOfClass("Humanoid")
			if Settings.YetiMinionKill and YetiFarm.isMinion(model) then
				humanoid.Health = 0
				YetiFarm.MinionKills += 1
			elseif Settings.CacheGuardKill and CacheFarm.isGuard(model) then
				humanoid.Health = 0
				CacheFarm.GuardInstaKills += 1
			elseif Settings.InstantKill and humanoid.MaxHealth > 0 and humanoid.Health / humanoid.MaxHealth * 100 <= threshold then
				humanoid.Health = 0
				InstantKill.Kills += 1
				InstantKill.Last = model.Name
			end
		end
	end)
end

function InstantKill.statusText()
	if not Settings.InstantKill then
		return "Off", "Muted"
	end
	if not InstantKill.supported() then
		return "Executor has no isnetworkowner", "Error"
	end
	if not InstantKill.Last then
		return "Hit a mob to take ownership", "Warning"
	end
	return string.format("%d kills, last %s", InstantKill.Kills, InstantKill.Last), "Success"
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(InstantKill.step)
		if not ok then
			warn("[Spryzen Hub] instant kill error: " .. tostring(err))
		end
		task.wait(Const.INSTANT_KILL_POLL)
	end
end))

local MobPin = { Anchors = setmetatable({}, { __mode = "k" }), Owned = {}, ScanAt = 0 }

function MobPin.scan()
	local root = Character.root()
	local owned = {}
	if root then
		Mobs.eachAlive(function(model, mobRoot, entry)
			if Mobs.isCombatTarget(model, entry) and (mobRoot.Position - root.Position).Magnitude <= Const.PIN_RANGE and isnetworkowner(mobRoot) then
				table.insert(owned, mobRoot)
				if not MobPin.Anchors[mobRoot] then
					MobPin.Anchors[mobRoot] = mobRoot.CFrame
				end
			end
		end)
	end
	MobPin.Owned = owned
end

function MobPin.step()
	if not Settings.BreakPathing or not InstantKill.supported() then
		if next(MobPin.Owned) then
			MobPin.Owned = {}
			table.clear(MobPin.Anchors)
		end
		return
	end
	if os.clock() >= MobPin.ScanAt then
		MobPin.ScanAt = os.clock() + Const.PIN_SCAN
		MobPin.scan()
	end
	for _, mobRoot in ipairs(MobPin.Owned) do
		local anchor = MobPin.Anchors[mobRoot]
		if anchor and mobRoot.Parent and isnetworkowner(mobRoot) then
			if (mobRoot.Position - anchor.Position).Magnitude > Const.PIN_REANCHOR then
				MobPin.Anchors[mobRoot] = mobRoot.CFrame
			else
				mobRoot.CFrame = anchor
			end
			mobRoot.AssemblyLinearVelocity = Vector3.zero
			mobRoot.AssemblyAngularVelocity = Vector3.zero
		end
	end
end

function MobPin.statusText()
	if not Settings.BreakPathing then
		return "Off", "Muted"
	end
	if not InstantKill.supported() then
		return "Executor has no isnetworkowner", "Error"
	end
	local count = #MobPin.Owned
	if count == 0 then
		return "Hit a mob to take ownership", "Warning"
	end
	return count .. " mobs pinned", "Success"
end

RootMaid:Give(RunService.Heartbeat:Connect(function()
	local ok, err = pcall(MobPin.step)
	if not ok then
		warn("[Spryzen Hub] mob pathing error: " .. tostring(err))
		MobPin.Owned = {}
	end
end))

local PlayerMods = { SpeedValue = nil, RunForced = false, LastJump = 0, FlyForce = nil, MultiplierOriginal = nil }

function PlayerMods.applyWalkSpeed()
	local folder = Settings.WalkSpeedEnabled and Guard.valuesFolder() or nil
	local value = PlayerMods.SpeedValue
	if value and (not folder or value.Parent ~= folder) then
		value:Destroy()
		PlayerMods.SpeedValue = nil
		value = nil
	end
	if not folder then
		return
	end
	if not value then
		value = Instance.new("NumberValue")
		value.Name = "WalkSpeed"
		value:SetAttribute("Priority", Const.WALKSPEED_PRIORITY)
		value.Parent = folder
		PlayerMods.SpeedValue = value
	end
	if value.Value ~= Settings.WalkSpeed then
		value.Value = Settings.WalkSpeed
	end
end

function PlayerMods.applyAutoRun()
	local handler = Game.RunHandler
	if Settings.AutoRun then
		PlayerMods.RunForced = true
		if handler.Toggled ~= true then
			handler.Toggled = true
		end
	elseif PlayerMods.RunForced then
		PlayerMods.RunForced = false
		handler.Toggled = false
	end
end

function PlayerMods.step()
	PlayerMods.applyWalkSpeed()
	PlayerMods.applyAutoRun()
end

function PlayerMods.dropFly()
	if PlayerMods.FlyForce then
		PlayerMods.FlyForce:Destroy()
		PlayerMods.FlyForce = nil
	end
end

function PlayerMods.stepFly()
	local camera = Workspace.CurrentCamera
	if not Settings.Fly or Mover.Active or not Character.alive() or not camera then
		PlayerMods.dropFly()
		return
	end
	local root = Character.root()
	local force = PlayerMods.FlyForce
	if not force or force.Parent ~= root then
		PlayerMods.dropFly()
		force = Instance.new("BodyVelocity")
		force.MaxForce = Vector3.one * math.huge
		force.P = 1e4
		force.Velocity = Vector3.zero
		force.Parent = root
		PlayerMods.FlyForce = force
	end
	local view = camera.CFrame
	local _, yaw = view:ToOrientation()
	local relative = CFrame.Angles(0, yaw, 0):VectorToObjectSpace(Character.humanoid().MoveDirection)
	local direction = view.LookVector * -relative.Z + view.RightVector * relative.X
	if not UserInputService:GetFocusedTextBox() then
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			direction += Vector3.yAxis
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			direction -= Vector3.yAxis
		end
	end
	if direction.Magnitude > 1 then
		direction = direction.Unit
	end
	force.Velocity = direction * Settings.FlySpeed
end

function PlayerMods.jump()
	if not Settings.InfiniteJump or os.clock() - PlayerMods.LastJump < Const.JUMP_GAP then
		return
	end
	local humanoid = Character.humanoid()
	if humanoid and humanoid.Health > 0 and humanoid.FloorMaterial == Enum.Material.Air then
		PlayerMods.LastJump = os.clock()
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(PlayerMods.step)
		if not ok then
			warn("[Spryzen Hub] player mods error: " .. tostring(err))
		end
		task.wait(Const.PLAYER_POLL)
	end
end))

RootMaid:Give(RunService.Heartbeat:Connect(function()
	local ok, err = pcall(PlayerMods.stepFly)
	if not ok then
		warn("[Spryzen Hub] fly error: " .. tostring(err))
	end
end))

RootMaid:Give(UserInputService.JumpRequest:Connect(function()
	local ok, err = pcall(PlayerMods.jump)
	if not ok then
		warn("[Spryzen Hub] infinite jump error: " .. tostring(err))
	end
end))

RootMaid:Give(function()
	PlayerMods.dropFly()
	if PlayerMods.SpeedValue then
		PlayerMods.SpeedValue:Destroy()
		PlayerMods.SpeedValue = nil
	end
	if PlayerMods.RunForced then
		PlayerMods.RunForced = false
		Game.RunHandler.Toggled = false
	end
end)

function PlayerMods.hookSwim()
	local resolver = Game.PlayerStatResolver
	local original = resolver.GetMovementMultiplier
	if PlayerMods.MultiplierOriginal or type(original) ~= "function" then
		return
	end
	PlayerMods.MultiplierOriginal = original
	resolver.GetMovementMultiplier = function(player, ...)
		if Settings.SwimSpeedEnabled and player == LocalPlayer then
			local character = LocalPlayer.Character
			local state = character and character:GetAttribute("SwimState")
			if state == 1 or state == 3 then
				return Settings.SwimSpeed / Const.SWIM_BASE_SPEED
			end
		end
		return original(player, ...)
	end
end

RootMaid:Give(function()
	if PlayerMods.MultiplierOriginal then
		Game.PlayerStatResolver.GetMovementMultiplier = PlayerMods.MultiplierOriginal
		PlayerMods.MultiplierOriginal = nil
	end
end)

function AimAssist.active()
	return Settings.AimAssist and Game.PlatformHandler.Platform.Value == "PC" and Character.alive()
end

function AimAssist.find()
	local camera = Workspace.CurrentCamera
	local root = Character.root()
	if not camera or not root then
		return nil
	end
	local mouse = UserInputService:GetMouseLocation()
	local origin = root.Position
	local best, bestPixels = nil, Settings.AimFov
	local function consider(model, targetRoot)
		if (targetRoot.Position - origin).Magnitude > Settings.AimRange then
			return
		end
		local screen, visible = camera:WorldToViewportPoint(targetRoot.Position)
		if not visible then
			return
		end
		local pixels = (Vector2.new(screen.X, screen.Y) - mouse).Magnitude
		if pixels <= bestPixels then
			best, bestPixels = model, pixels
		end
	end
	local targets = Settings.AimTargets
	local mobs, bosses = table.find(targets, "Mobs") ~= nil, table.find(targets, "Bosses") ~= nil
	if mobs or bosses then
		Mobs.eachAlive(function(model, mobRoot, entry)
			if Mobs.isCombatTarget(model, entry) then
				local boss = entry ~= nil and entry.Boss
				if (boss and bosses) or (not boss and mobs) then
					consider(model, mobRoot)
				end
			end
		end)
	end
	if table.find(targets, "Players") then
		local party = Esp.partySet()
		for _, player in ipairs(Players:GetPlayers()) do
			local character = player.Character
			if player ~= LocalPlayer and character and not party[player.UserId] then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				local targetRoot = character:FindFirstChild("HumanoidRootPart")
				if humanoid and humanoid.Health > 0 and targetRoot then
					consider(character, targetRoot)
				end
			end
		end
	end
	return best
end

function AimAssist.point(range)
	if not AimAssist.active() then
		return nil
	end
	local target = AimAssist.Target
	local humanoid = target and target.Parent and target:FindFirstChildOfClass("Humanoid")
	local targetRoot = humanoid and humanoid.Health > 0 and target:FindFirstChild("HumanoidRootPart")
	if not targetRoot then
		return nil
	end
	local point = targetRoot.Position
	local root = Character.root()
	if range ~= nil and root then
		local offset = point - root.Position
		if offset.Magnitude > range then
			point = root.Position + offset.Unit * range
		end
	end
	return point
end

function AimAssist.drawFov(show)
	local circle = AimAssist.Circle
	if not show or not Esp.Supported then
		if circle then
			circle.Visible = false
		end
		return
	end
	if not circle then
		circle = Esp.drawing("Circle", { Thickness = 1.5, NumSides = 64, Filled = false, Transparency = 1 })
		AimAssist.Circle = circle
	end
	circle.Position = UserInputService:GetMouseLocation()
	circle.Radius = Settings.AimFov
	circle.Color = AimAssist.Target and Const.AIM_LOCK_COLOR or Const.AIM_FOV_COLOR
	circle.Visible = true
end

function AimAssist.step()
	local active = AimAssist.active()
	if not active then
		AimAssist.Target = nil
	elseif os.clock() >= AimAssist.CheckedAt then
		AimAssist.CheckedAt = os.clock() + Const.AIM_SCAN
		AimAssist.Target = AimAssist.find()
	end
	AimAssist.drawFov(active and Settings.AimShowFov)
end

function AimAssist.statusText()
	if not Settings.AimAssist then
		return "Off", "Muted"
	end
	if Game.PlatformHandler.Platform.Value ~= "PC" then
		return "PC only, you are on " .. tostring(Game.PlatformHandler.Platform.Value), "Warning"
	end
	local target = AimAssist.Target
	if target then
		return "Locked: " .. target.Name, "Success"
	end
	return "No target in range", "Muted"
end

RootMaid:Give(RunService.RenderStepped:Connect(function()
	local ok, err = pcall(AimAssist.step)
	if not ok then
		AimAssist.Target = nil
		warn("[Spryzen Hub] aim assist error: " .. tostring(err))
	end
end))

RootMaid:Give(function()
	AimAssist.Target = nil
	if AimAssist.Circle then
		pcall(AimAssist.Circle.Remove, AimAssist.Circle)
		AimAssist.Circle = nil
	end
end)

local SkillTree = { Status = "Off", Blocked = {}, Unlocked = 0, Options = { "Innate Skills", "Skills" } }

do
	local stats = {}
	for name in pairs(Game.SkillTreeConfig) do
		if type(name) == "string" then
			table.insert(stats, name)
		end
	end
	table.sort(stats, function(a, b)
		local left = table.find(Const.SKILL_TREE_ORDER, a) or math.huge
		local right = table.find(Const.SKILL_TREE_ORDER, b) or math.huge
		if left ~= right then
			return left < right
		end
		return a < b
	end)
	for _, name in ipairs(stats) do
		table.insert(SkillTree.Options, name)
	end
end

function SkillTree.missing(name, requirements)
	for kind, amount in pairs(requirements) do
		local solver = Game.SkillTreeholder.RequirementsSolver[kind]
		if not solver or solver.CanBuy(LocalPlayer, name, amount) ~= true then
			return kind
		end
	end
	return nil
end

function SkillTree.nextInBranch(branch)
	for _, node in ipairs(branch) do
		if type(node) == "table" and type(node.Name) == "string" then
			local requirements, unlocked = Game.call(Game.SkillStats.GetRequirements, LocalPlayer, node.Name)
			if not unlocked then
				return node.Name, requirements
			end
		end
	end
	return nil
end

function SkillTree.candidates()
	local data = Game.data()
	local unlocked = data and data:FindFirstChild("SkillTreeUnlockedList")
	if not unlocked then
		return nil
	end
	local picked = {}
	for _, option in ipairs(Settings.SkillTreeBranches) do
		picked[option] = true
	end
	local everything = next(picked) == nil
	local list = {}
	local function add(group, name, label, requirements)
		if not everything and not picked[group] then
			return
		end
		if type(requirements) ~= "table" then
			return
		end
		table.insert(list, {
			Name = name,
			Label = label,
			Cost = tonumber(requirements.SkillPoints) or 0,
			Missing = SkillTree.missing(name, requirements),
		})
	end
	for name, config in pairs(Game.SkillTreeConfig) do
		if type(name) == "string" and type(config) == "table" and type(config.Ratio) == "number" then
			local node = unlocked:FindFirstChild(name)
			local current = node and node.Value or 0
			if current < math.floor(Game.GameSettings.maxLevel / config.Ratio) then
				add(name, name, string.format("%s %d", name, current + 1), (Game.call(Game.SkillStats.GetRequirements, LocalPlayer, name, current + 1)))
			end
		end
	end
	for index, branch in ipairs(Game.SkillTreeholder.GetBranches()) do
		if index == 1 then
			for _, sub in ipairs(branch) do
				if type(sub) == "table" and sub.Name == "Innate Skills" then
					local name, requirements = SkillTree.nextInBranch(sub)
					if name then
						add("Innate Skills", name, name, requirements)
					end
				end
			end
		else
			local name, requirements = SkillTree.nextInBranch(branch)
			if name then
				add("Skills", name, name, requirements)
			end
		end
	end
	return list
end

function SkillTree.clean(text)
	text = tostring(text or "refused")
	text = text:gsub("<[^>]*>", ""):gsub("\\%[%['", ""):gsub("'%]", ""):gsub("[%[%]\\]", "")
	return text
end

function SkillTree.step()
	if not Settings.AutoSkillTree then
		SkillTree.Status = "Off"
		return false
	end
	local data = Game.data()
	local points = data and data:FindFirstChild("SkillPoints")
	local list = points and SkillTree.candidates()
	if not list then
		SkillTree.Status = "Waiting for player data"
		return false
	end
	local now = os.clock()
	local best, short = nil, nil
	for _, candidate in ipairs(list) do
		local blocked = SkillTree.Blocked[candidate.Name]
		if not blocked or now >= blocked then
			if candidate.Missing == nil then
				if not best or candidate.Cost < best.Cost or (candidate.Cost == best.Cost and candidate.Label < best.Label) then
					best = candidate
				end
			elseif candidate.Missing == "SkillPoints" and (not short or candidate.Cost < short.Cost) then
				short = candidate
			end
		end
	end
	if not best then
		if short then
			SkillTree.Status = string.format("Next: %s for %d SP (have %d)", short.Label, short.Cost, points.Value)
		elseif #list == 0 then
			SkillTree.Status = "Picked branches are complete"
		else
			SkillTree.Status = "Remaining nodes need bosses or mastery"
		end
		return false
	end
	SkillTree.Status = "Unlocking " .. best.Label
	local ok, accepted, message = pcall(Game.SignalFunction.ToServer, "UnlockSkillTreeNode", best.Name)
	if not ok then
		SkillTree.Blocked[best.Name] = os.clock() + Const.SKILL_TREE_RETRY
		error(accepted, 0)
	end
	if accepted == false then
		SkillTree.Blocked[best.Name] = os.clock() + Const.SKILL_TREE_RETRY
		SkillTree.Status = best.Label .. ": " .. SkillTree.clean(message)
		return false
	end
	SkillTree.Unlocked += 1
	SkillTree.Status = "Unlocked " .. best.Label
	return true
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, result = pcall(SkillTree.step)
		if not ok then
			SkillTree.Status = "Error, retrying"
			warn("[Spryzen Hub] auto skill tree error: " .. tostring(result))
		end
		task.wait(ok and result and Const.SKILL_TREE_GAP or Const.SKILL_TREE_POLL)
	end
end))

local Gear = { Blocked = {}, Wake = false, ForceAccessories = false, AccessoryStatus = "Off", TitleStatus = "Off", StatMax = { Accessory = {}, Title = {} } }

do
	local function track(maxima, stat, amount)
		if type(stat) == "string" and type(amount) == "number" and amount > (maxima[stat] or 0) then
			maxima[stat] = amount
		end
	end
	for _, info in pairs(Game.Items) do
		if type(info) == "table" and info.EquipType == 3 and type(info.Stats) == "table" then
			for stat, amount in pairs(info.Stats) do
				track(Gear.StatMax.Accessory, stat, amount)
			end
		end
	end
	for _, def in pairs(Game.Titles.GetAll()) do
		for _, buff in ipairs(type(def.buffs) == "table" and def.buffs or {}) do
			track(Gear.StatMax.Title, buff.stat, buff.amount)
		end
	end
end

function Gear.isDemon()
	local data = Game.data()
	local race = data and data:FindFirstChild("Race")
	return race ~= nil and race.Value == "Demon"
end

function Gear.weights()
	local demon = Gear.isDemon()
	local favour = Settings.GearFavour
	local weights = {}
	for group, stats in pairs(Const.GEAR_GROUPS) do
		local weight = (#favour == 0 or table.find(favour, group)) and 1 or Const.GEAR_OTHER_WEIGHT
		for _, stat in ipairs(stats) do
			weights[stat] = weight
		end
		if group == "Damage" then
			weights[demon and "Evil Art Damage Factor" or "Breathing Damage Factor"] = weight
		end
	end
	return weights, demon
end

function Gear.score(stats, maxima, weights)
	local total = 0
	for stat, amount in pairs(stats) do
		local weight, max = weights[stat], maxima[stat]
		if weight and type(amount) == "number" and max and max > 0 then
			total += weight * amount / max
		end
	end
	return total
end

function Gear.blocked(key)
	local at = Gear.Blocked[key]
	return at ~= nil and os.clock() - at < Const.GEAR_RETRY
end

function Gear.pick(candidates, count, wantSun)
	local chosen, used, haveSun = {}, {}, false
	for _ = 1, count do
		local best, bestScore = nil, 0
		for _, candidate in ipairs(candidates) do
			if not used[candidate] then
				local score = candidate.Score
				if wantSun and not haveSun and candidate.Sun then
					score += Const.GEAR_SUN_BONUS
				end
				if score > bestScore then
					best, bestScore = candidate, score
				end
			end
		end
		if not best then
			break
		end
		used[best] = true
		haveSun = haveSun or best.Sun == true
		table.insert(chosen, best)
	end
	return chosen
end

function Gear.place(slots, current, desired, equip, prefix)
	local wanted, equipped = {}, {}
	for _, candidate in ipairs(desired) do
		wanted[candidate.Id] = true
	end
	for _, slot in ipairs(slots) do
		if current[slot] ~= nil then
			equipped[current[slot]] = true
		end
	end
	local changed = 0
	for _, candidate in ipairs(desired) do
		if not equipped[candidate.Id] then
			local free = nil
			for _, slot in ipairs(slots) do
				if current[slot] == nil or not wanted[current[slot]] then
					free = slot
					break
				end
			end
			if not free then
				break
			end
			if not equip(free, candidate) then
				Gear.Blocked[prefix .. tostring(candidate.Id)] = os.clock()
				return "Server refused " .. candidate.Name .. ", skipping it"
			end
			current[free] = candidate.Id
			equipped[candidate.Id] = true
			changed += 1
		end
	end
	if #desired == 0 then
		return "Nothing with stats to equip"
	end
	return changed > 0 and ("Equipped " .. changed .. " new") or ("Best equipped (" .. #desired .. ")")
end

function Gear.confirm(value, expected)
	local deadline = os.clock() + Const.GEAR_CONFIRM
	while os.clock() < deadline do
		if value.Parent and value.Value == expected then
			return true
		end
		task.wait(0.1)
	end
	return false
end

function Gear.accessories()
	local data = Game.data()
	local accessories = data and data.Inventory:FindFirstChild("Accessories")
	local slotsFolder = accessories and accessories:FindFirstChild("Stats")
	if not slotsFolder then
		return "Waiting for your data"
	end
	local weights, demon = Gear.weights()
	local candidates = {}
	for _, entry in ipairs(data.Inventory.Inventory:GetChildren()) do
		local info = Game.Items[entry.Name]
		local id = entry:FindFirstChild("Id")
		if type(info) == "table" and info.EquipType == 3 and id and not Gear.blocked("A" .. tostring(id.Value)) then
			local stats = type(info.Stats) == "table" and info.Stats or {}
			table.insert(candidates, {
				Id = id.Value,
				Name = entry.Name,
				Score = Gear.score(stats, Gear.StatMax.Accessory, weights),
				Sun = stats["Sun Immunity"] == true,
			})
		end
	end
	local desired = Gear.pick(candidates, #Const.ACCESSORY_SLOTS, demon and not Settings.NoSunDamage)
	local current = {}
	for _, slot in ipairs(Const.ACCESSORY_SLOTS) do
		local value = slotsFolder:FindFirstChild(slot)
		if value and value.Value ~= 0 then
			current[slot] = value.Value
		end
	end
	return Gear.place(Const.ACCESSORY_SLOTS, current, desired, function(slot, candidate)
		local value = slotsFolder:FindFirstChild(slot)
		if not value then
			return false
		end
		Game.fire("AccessoryEquip", slot, candidate.Id, "Stats")
		return Gear.confirm(value, candidate.Id)
	end, "A")
end

function Gear.titles()
	local data, root = Game.Utility.GetData(LocalPlayer)
	local equippedTitles = data and data:FindFirstChild("EquippedTitles")
	local boost = equippedTitles and equippedTitles:FindFirstChild("Boost")
	local playerTitles = root and root:FindFirstChild("PlayerTitles")
	local unlocked = playerTitles and playerTitles:FindFirstChild("Unlocked")
	if not boost or not unlocked then
		return "Waiting for your data"
	end
	local weights = Gear.weights()
	local candidates = {}
	for _, child in ipairs(unlocked:GetChildren()) do
		local def = Game.Titles.Get(child.Name)
		if def and not Gear.blocked("T" .. child.Name) then
			local buffs = {}
			for _, buff in ipairs(type(def.buffs) == "table" and def.buffs or {}) do
				if type(buff.stat) == "string" and type(buff.amount) == "number" then
					buffs[buff.stat] = (buffs[buff.stat] or 0) + buff.amount
				end
			end
			table.insert(candidates, {
				Id = child.Name,
				Name = type(def.displayName) == "string" and def.displayName or child.Name,
				Score = Gear.score(buffs, Gear.StatMax.Title, weights),
			})
		end
	end
	local slots, current = {}, {}
	for index = 1, Game.Titles.BoostSlots do
		local value = boost:FindFirstChild("Slot" .. index)
		if value then
			table.insert(slots, index)
			if value.Value ~= "" then
				current[index] = value.Value
			end
		end
	end
	local desired = Gear.pick(candidates, #slots, false)
	return Gear.place(slots, current, desired, function(slot, candidate)
		Game.fire("TitleRequest", { action = "equipBoost", titleId = candidate.Id, slot = slot })
		return Gear.confirm(boost["Slot" .. slot], candidate.Id)
	end, "T")
end

function Gear.step()
	if Schematics.GearHeld then
		Gear.AccessoryStatus = "Paused for schematics"
	elseif Settings.AutoAccessories or Gear.ForceAccessories then
		Gear.ForceAccessories = false
		Gear.AccessoryStatus = Gear.accessories()
	elseif Gear.AccessoryStatus ~= "Off" then
		Gear.AccessoryStatus = "Off"
	end
	if Settings.AutoTitles then
		Gear.TitleStatus = Gear.titles()
	elseif Gear.TitleStatus ~= "Off" then
		Gear.TitleStatus = "Off"
	end
end

function Gear.poke()
	Gear.Wake = true
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		if Character.alive() then
			local ok, err = pcall(Gear.step)
			if not ok then
				Gear.AccessoryStatus = "Error, retrying"
				warn("[Spryzen Hub] auto equip error: " .. tostring(err))
			end
		end
		local deadline = os.clock() + Const.GEAR_POLL
		while os.clock() < deadline and not Gear.Wake do
			task.wait(0.2)
		end
		Gear.Wake = false
	end
end))

local Webhook = {
	Request = nil,
	Queue = {},
	Sending = false,
	Last = nil,
	Thumbs = {},
	Inputs = {},
	StartedAt = os.clock(),
	DataFolder = nil,
	Inventory = nil,
	Counts = {},
	Pending = {},
	PendingAt = nil,
	PendingLast = nil,
	Level = nil,
	LevelStart = nil,
	Bosses = {},
	NpcPresent = {},
	Digest = nil,
	DigestClock = 0,
	DigestTime = 0,
	FinalSelectionCycle = nil,
	DisconnectSent = {},
	RarityOptions = {},
	ItemOptions = {},
}

do
	local function pick(...)
		for index = 1, select("#", ...) do
			local candidate = select(index, ...)
			if type(candidate) == "function" then
				return candidate
			end
		end
		return nil
	end
	Webhook.Request = pick(request, http_request, type(syn) == "table" and syn.request or nil, type(fluxus) == "table" and fluxus.request or nil)

	for _, name in ipairs(Game.Rarities.Order) do
		table.insert(Webhook.RarityOptions, name)
	end
	for name, info in pairs(Game.Items) do
		if type(name) == "string" and type(info) == "table" then
			table.insert(Webhook.ItemOptions, name)
		end
	end
	table.sort(Webhook.ItemOptions)
end

function Webhook.escape(text)
	return (string.gsub(tostring(text), "([%*_~|`>\\%[%]])", "\\%1"))
end

function Webhook.truncate(text, limit)
	local length = utf8.len(text) or #text
	if length <= limit then
		return text
	end
	local cut = utf8.offset(text, limit - 2) or (limit - 2)
	return string.sub(text, 1, cut - 1) .. "..."
end

function Webhook.code(value)
	if value == nil or value == "" then
		value = "Unknown"
	end
	return "`" .. string.gsub(tostring(value), "`", "'") .. "`"
end

function Webhook.number(value)
	value = tonumber(value)
	if not value then
		return nil
	end
	value = math.floor(value)
	local grouped = string.reverse((string.gsub(string.reverse(string.format("%d", math.abs(value))), "(%d%d%d)", "%1,")))
	if string.sub(grouped, 1, 1) == "," then
		grouped = string.sub(grouped, 2)
	end
	return (value < 0 and "-" or "") .. grouped
end

function Webhook.field(name, value, inline)
	return { name = name, value = Webhook.truncate(value, 1024), inline = inline ~= false }
end

function Webhook.rarity(rank)
	local name = type(rank) == "number" and Game.Rarities.Order[rank] or nil
	return name or "Unknown", Const.RARITY_EMOJI[rank] or "▫️"
end

function Webhook.url()
	local input = Webhook.Inputs.Url
	local text = string.match(input and input:Get() or "", "^%s*(.-)%s*$")
	text = string.match(text, "^[^%?#]*")
	text = (string.gsub(text, "/+$", ""))
	local host, path = string.match(text, "^https://([%w%.%-]+)(/.*)$")
	if not host or not Const.WEBHOOK_HOSTS[string.lower(host)] then
		return nil
	end
	if string.match(path, "^/api/webhooks/%d+/[%w_%-]+$") or string.match(path, "^/api/v%d+/webhooks/%d+/[%w_%-]+$") then
		return text
	end
	return nil
end

function Webhook.userId()
	local input = Webhook.Inputs.UserId
	local id = string.match(input and input:Get() or "", "^%s*<?@?!?(%d+)>?%s*$")
	if id and #id >= 15 and #id <= 21 then
		return id
	end
	return nil
end

function Webhook.assetId(icon)
	return type(icon) == "string" and string.match(icon, "(%d+)") or nil
end

function Webhook.thumbnail(kind, id)
	if id == nil or not Webhook.Request then
		return nil
	end
	local key = kind .. ":" .. tostring(id)
	if Webhook.Thumbs[key] then
		return Webhook.Thumbs[key]
	end
	local url
	if kind == "user" then
		url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. tostring(id) .. "&size=150x150&format=Png&isCircular=false"
	else
		url = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. tostring(id) .. "&returnPolicy=PlaceHolder&size=420x420&format=Png&isCircular=false"
	end
	local ok, response = pcall(Webhook.Request, { Url = url, Method = "GET" })
	if not ok or type(response) ~= "table" or response.StatusCode ~= 200 then
		return nil
	end
	local decoded, body = pcall(HttpService.JSONDecode, HttpService, response.Body)
	local entry = decoded and type(body) == "table" and type(body.data) == "table" and body.data[1]
	if type(entry) == "table" and entry.state == "Completed" and type(entry.imageUrl) == "string" then
		Webhook.Thumbs[key] = entry.imageUrl
		return entry.imageUrl
	end
	return nil
end

function Webhook.profile()
	local data = Game.data()
	local function read(name)
		local value = data and data:FindFirstChild(name)
		return value and value:IsA("ValueBase") and value.Value or nil
	end
	return {
		Level = data and Game.level() or nil,
		Wen = read("Wen"),
		Race = read("Race"),
		Clan = read("Clan"),
	}
end

function Webhook.session()
	return BossStats.duration(os.clock() - Webhook.StartedAt)
end

function Webhook.server()
	return #Players:GetPlayers() .. "/" .. Players.MaxPlayers
end

function Webhook.embed(spec, thumbnail)
	local name = LocalPlayer.DisplayName == LocalPlayer.Name and LocalPlayer.Name or (LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")")
	spec.author = { name = name, icon_url = Webhook.thumbnail("user", LocalPlayer.UserId) }
	if thumbnail then
		spec.thumbnail = { url = thumbnail }
	end
	spec.color = Const.WEBHOOK_COLOR
	spec.footer = { text = "Spryzen Hub  •  " .. SCRIPT_VERSION }
	spec.timestamp = DateTime.now():ToIsoDate()
	return spec
end

function Webhook.payload(embed)
	local mentions, parse, users = {}, {}, {}
	local id = Webhook.userId()
	if id then
		table.insert(mentions, "<@" .. id .. ">")
		table.insert(users, id)
	end
	if Settings.WebhookEveryone then
		table.insert(mentions, "@everyone")
		table.insert(parse, "everyone")
	end
	return {
		content = #mentions > 0 and table.concat(mentions, " ") or nil,
		embeds = { embed },
		allowed_mentions = { parse = parse, users = users },
	}
end

function Webhook.reason(code)
	if code == 401 or code == 403 then
		return "Webhook token rejected (" .. code .. ")"
	elseif code == 404 then
		return "Webhook not found, it may be deleted (404)"
	end
	return "Discord rejected the post (" .. code .. ")"
end

function Webhook.post(url, body)
	local failure = "Discord kept rate limiting, post dropped"
	for _ = 1, Const.WEBHOOK_ATTEMPTS do
		local ok, response = pcall(Webhook.Request, {
			Url = url,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = body,
		})
		local code = ok and type(response) == "table" and tonumber(response.StatusCode) or nil
		if code and code >= 200 and code < 300 then
			return true
		elseif code == 429 then
			local decoded, data = pcall(HttpService.JSONDecode, HttpService, response.Body or "")
			local delay = decoded and type(data) == "table" and tonumber(data.retry_after) or 2
			task.wait(math.clamp(delay, 0.5, Const.WEBHOOK_RETRY_MAX))
		elseif code and code < 500 then
			return false, Webhook.reason(code)
		else
			failure = code and ("Discord is unavailable (" .. code .. ")") or ("Request failed: " .. tostring(response))
			task.wait(2)
		end
	end
	return false, failure
end

function Webhook.enqueue(label, build, test)
	if #Webhook.Queue >= Const.WEBHOOK_QUEUE_MAX then
		table.remove(Webhook.Queue, 1)
	end
	table.insert(Webhook.Queue, { Label = label, Build = build, Test = test == true })
end

function Webhook.resetDigest()
	Webhook.Digest = { Count = 0, Drops = {}, LevelFrom = nil, LevelTo = nil, Events = {} }
	Webhook.DigestClock = os.clock()
	Webhook.DigestTime = os.time()
end

function Webhook.collect(kind, data)
	local digest = Webhook.Digest
	if kind == "drops" then
		for _, drop in ipairs(data) do
			local entry = digest.Drops[drop.Name]
			if entry then
				entry.Amount += drop.Amount
			else
				digest.Drops[drop.Name] = { Name = drop.Name, Amount = drop.Amount, Rank = drop.Rank, Info = drop.Info }
			end
		end
	elseif kind == "level" then
		digest.LevelFrom = digest.LevelFrom or data.From
		digest.LevelTo = data.To
	else
		table.insert(digest.Events, "<t:" .. os.time() .. ":t>  " .. data)
	end
	digest.Count += 1
end

function Webhook.notify(label, build, kind, data)
	if Settings.WebhookDigest then
		Webhook.collect(kind, data)
	else
		Webhook.enqueue(label, build)
	end
end

function Webhook.flushDigest(force)
	if not force and os.clock() - Webhook.DigestClock < Settings.WebhookInterval * 60 then
		return
	end
	local digest, startedAt = Webhook.Digest, Webhook.DigestTime
	Webhook.resetDigest()
	if digest.Count == 0 or not Settings.Webhook then
		return
	end
	local endedAt = os.time()
	Webhook.enqueue("digest", function()
		return Webhook.digestEmbed(digest, startedAt, endedAt)
	end)
end

function Webhook.digestText()
	if not Settings.WebhookDigest then
		return "Off, every notification posts on its own", "Muted"
	end
	local left = Settings.WebhookInterval * 60 - (os.clock() - Webhook.DigestClock)
	local held = Webhook.Digest.Count
	return "Next digest in " .. BossStats.duration(math.max(left, 0)) .. ", " .. held .. (held == 1 and " update" or " updates") .. " held", held > 0 and "Accent" or "Success"
end

Webhook.resetDigest()

Webhook.DisconnectKinds = {
	{ Label = "Kicked", Emoji = "🥾", Color = 0xE74C3C, Match = { "LuaKick", "CloudEditKick", "PrivateServerKickout", "PlayerRemoved" } },
	{ Label = "Idle Timeout", Emoji = "💤", Color = 0xF39C12, Match = { "Idle" } },
	{ Label = "Logged In Elsewhere", Emoji = "👥", Color = 0x9B59B6, Match = { "DuplicatePlayer", "DuplicateTicket" } },
	{ Label = "Server Closed", Emoji = "🛑", Color = 0x95A5A6, Match = { "ServerShutdown", "Evicted", "Maintenance", "Playerless", "ServerEmpty", "ReplacementReady", "GameEnded", "Rejoin" } },
	{ Label = "Blocked or Moderated", Emoji = "🚫", Color = 0x8B0000, Match = { "Security", "Blocked", "Moderated", "Anticheat", "Banned", "IllegalTeleport", "Rooted", "Emulator", "Attestation" } },
	{ Label = "Teleport Failed", Emoji = "🌀", Color = 0x3498DB, Match = { "Teleport", "Placelaunch" } },
	{ Label = "Connection Lost", Emoji = "📡", Color = 0xF1C40F, Match = { "ConnectionLost", "Timeout", "Network", "Raknet", "Packet", "Hash", "PhantomFreeze", "ClientFailure", "OutOfMemory", "DisconnectErrors", "ConnectErrors" } },
}

function Webhook.disconnectKind(codeName, message)
	for _, kind in ipairs(Webhook.DisconnectKinds) do
		for _, pattern in ipairs(kind.Match) do
			if string.find(codeName, pattern, 1, true) then
				return kind
			end
		end
	end
	local lower = string.lower(message)
	if string.find(lower, "kick", 1, true) then
		return Webhook.DisconnectKinds[1]
	elseif string.find(lower, "lost connection", 1, true) or string.find(lower, "internet", 1, true) then
		return Webhook.DisconnectKinds[7]
	end
	return { Label = "Disconnected", Emoji = "🔌", Color = 0x7F8C8D }
end

function Webhook.disconnectEmbed(kind, codeName, codeValue, message)
	local profile = Webhook.profile()
	local fields = {
		Webhook.field("Reason", kind.Label),
		Webhook.field("Error Code", Webhook.code(codeName .. (codeValue and (" (" .. codeValue .. ")") or ""))),
		Webhook.field("Session", Webhook.session()),
	}
	if profile.Level then
		table.insert(fields, Webhook.field("Level", Webhook.number(profile.Level) or tostring(profile.Level)))
	end
	if profile.Wen then
		table.insert(fields, Webhook.field("Wen", Webhook.number(profile.Wen) or tostring(profile.Wen)))
	end
	table.insert(fields, Webhook.field("Server", Webhook.server() .. " players"))
	local root = Character.root()
	local place = root and Webhook.nearestPlace(root.Position)
	if place then
		table.insert(fields, Webhook.field("Location", place))
	end
	local active = Mover.Active
	table.insert(fields, Webhook.field("Doing", active and tostring(active.Owner) or "Nothing"))
	table.insert(fields, Webhook.field("Auto Reconnect", Settings.AutoReconnect and ("On, rejoining in " .. Settings.ReconnectDelay .. "s") or "Off"))
	table.insert(fields, Webhook.field("Job ID", Webhook.code(game.JobId), false))
	local body = message ~= "" and message or "No message from Roblox"
	local embed = Webhook.embed({
		title = kind.Emoji .. "  " .. kind.Label,
		description = "```\n" .. Webhook.truncate((string.gsub(body, "`", "'")), 1500) .. "\n```",
		fields = fields,
	})
	embed.color = kind.Color
	return embed
end

function Webhook.disconnect(message)
	if not Webhook.notifying("NotifyDisconnect") then
		return
	end
	message = type(message) == "string" and message or ""
	task.spawn(function()
		task.wait(0.1)
		local ok, code = pcall(GuiService.GetErrorCode, GuiService)
		local codeName = ok and typeof(code) == "EnumItem" and code.Name or "Unknown"
		local codeValue = ok and typeof(code) == "EnumItem" and code.Value or nil
		if codeName == "OK" and message == "" then
			return
		end
		local key = codeName .. "|" .. message
		if Webhook.DisconnectSent[key] then
			return
		end
		Webhook.DisconnectSent[key] = true
		local url = Webhook.url()
		if not url then
			Webhook.Last = { Text = "Enter a valid Discord webhook URL", Tone = "Error" }
			return
		end
		local kind = Webhook.disconnectKind(codeName, message)
		local built, embed = pcall(Webhook.disconnectEmbed, kind, codeName, codeValue, message)
		if not built then
			warn("[Spryzen Hub] disconnect webhook build error: " .. tostring(embed))
			return
		end
		local sent, err = Webhook.post(url, HttpService:JSONEncode(Webhook.payload(embed)))
		if sent then
			Webhook.Last = { Text = "Sent disconnect (" .. kind.Label .. ") at " .. os.date("%H:%M:%S"), Tone = "Success" }
		else
			Webhook.Last = { Text = err, Tone = "Error" }
		end
	end)
end

function Webhook.deliver(job)
	if not (job.Test or Settings.Webhook) then
		return
	end
	local url = Webhook.url()
	if not url then
		Webhook.Last = { Text = "Enter a valid Discord webhook URL", Tone = "Error" }
		return
	end
	local ok, err = Webhook.post(url, HttpService:JSONEncode(Webhook.payload(job.Build())))
	if ok then
		Webhook.Last = { Text = "Sent " .. job.Label .. " at " .. os.date("%H:%M:%S"), Tone = "Success" }
	else
		Webhook.Last = { Text = err, Tone = "Error" }
	end
end

function Webhook.notifying(key)
	return Settings.Webhook and Settings[key] and Webhook.Request ~= nil
end

function Webhook.statusText()
	if not Webhook.Request then
		return "Executor has no HTTP request function", "Error"
	end
	if Webhook.Sending or #Webhook.Queue > 0 then
		return "Sending, " .. #Webhook.Queue .. " queued", "Accent"
	end
	if Webhook.Last then
		return Webhook.Last.Text, Webhook.Last.Tone
	end
	if not Settings.Webhook then
		return "Off", "Muted"
	end
	if not Webhook.url() then
		return "Enter a valid Discord webhook URL", "Warning"
	end
	return "Ready", "Success"
end

function Webhook.sortDrops(drops)
	table.sort(drops, function(a, b)
		if a.Rank ~= b.Rank then
			return a.Rank > b.Rank
		end
		return a.Name < b.Name
	end)
end

function Webhook.dropLines(drops)
	local lines = {}
	local total = 0
	for index, drop in ipairs(drops) do
		total += drop.Amount
		if index <= Const.WEBHOOK_ITEM_LINES then
			local name, mark = Webhook.rarity(drop.Rank)
			table.insert(lines, mark .. " **" .. Webhook.escape(drop.Name) .. "** ×" .. Webhook.number(drop.Amount) .. "  ·  " .. name)
		end
	end
	if #drops > Const.WEBHOOK_ITEM_LINES then
		table.insert(lines, "*+" .. (#drops - Const.WEBHOOK_ITEM_LINES) .. " more*")
	end
	return table.concat(lines, "\n"), total
end

function Webhook.dropEmbed(drops)
	local top = drops[1]
	local rarity, emoji = Webhook.rarity(top.Rank)
	local profile = Webhook.profile()
	local icon = Webhook.assetId(top.Info.Icon)
	local embed = {}
	if #drops == 1 then
		embed.title = emoji .. " " .. rarity .. " Drop"
		local lines = { "Obtained **" .. Webhook.number(top.Amount) .. "× " .. Webhook.escape(top.Name) .. "**" }
		local kind = {}
		for _, key in ipairs({ "Category", "Class" }) do
			if type(top.Info[key]) == "string" and top.Info[key] ~= "" then
				table.insert(kind, Webhook.escape(top.Info[key]))
			end
		end
		if #kind > 0 then
			table.insert(lines, "*" .. table.concat(kind, " · ") .. "*")
		end
		if type(top.Info.Description) == "string" and top.Info.Description ~= "" then
			table.insert(lines, "> " .. Webhook.escape(Webhook.truncate(top.Info.Description, 200)))
		end
		embed.description = table.concat(lines, "\n")
		embed.fields = {
			Webhook.field("✨ Rarity", Webhook.code(rarity)),
			Webhook.field("📦 Amount", Webhook.code("×" .. Webhook.number(top.Amount))),
			Webhook.field("🎒 Owned", Webhook.code(Webhook.number(Webhook.Counts[top.Name] or top.Amount))),
		}
	else
		embed.title = "🎁 " .. #drops .. " New Drops"
		local lines, total = Webhook.dropLines(drops)
		embed.description = lines
		embed.fields = {
			Webhook.field("✨ Best", Webhook.code(rarity)),
			Webhook.field("📦 Total", Webhook.code("×" .. Webhook.number(total))),
			Webhook.field("🧾 Items", Webhook.code(#drops)),
		}
	end
	table.insert(embed.fields, Webhook.field("⭐ Level", Webhook.code(Webhook.number(profile.Level))))
	table.insert(embed.fields, Webhook.field("💰 Wen", Webhook.code(Webhook.number(profile.Wen))))
	table.insert(embed.fields, Webhook.field("⏱️ Session", Webhook.code(Webhook.session())))
	return Webhook.embed(embed, icon and Webhook.thumbnail("asset", icon))
end

function Webhook.levelEmbed(from, to)
	local profile = Webhook.profile()
	return Webhook.embed({
		title = "🆙 Level Up!",
		description = "Reached **Level " .. Webhook.number(to) .. "**",
		fields = {
			Webhook.field("📈 Level", Webhook.code(Webhook.number(from) .. " → " .. Webhook.number(to))),
			Webhook.field("📊 This Session", Webhook.code("+" .. Webhook.number(to - (Webhook.LevelStart or from)))),
			Webhook.field("💰 Wen", Webhook.code(Webhook.number(profile.Wen))),
			Webhook.field("🧬 Race", Webhook.code(profile.Race)),
			Webhook.field("🏯 Clan", Webhook.code(profile.Clan)),
			Webhook.field("⏱️ Session", Webhook.code(Webhook.session())),
		},
	}, Webhook.thumbnail("user", LocalPlayer.UserId))
end

function Webhook.bossEmbed(boss)
	local slot = WorldBoss.slot(boss)
	local info = slot and slot:FindFirstChild("BossInfo")
	local model = slot and WorldBoss.model(boss, slot)
	local humanoid = model and model:FindFirstChildOfClass("Humanoid")
	local title = info and info:GetAttribute("Title")
	local chest = info and info:GetAttribute("Chest")
	local spawnTime = info and info:GetAttribute("SpawnTime")
	spawnTime = type(spawnTime) == "number" and spawnTime or boss.SpawnTime
	local night = info ~= nil and info:GetAttribute("OnlyAtNight") == true
	local lines = { "**" .. Webhook.escape(boss.Name) .. "** has spawned" }
	if type(title) == "string" and title ~= "" then
		table.insert(lines, "*" .. Webhook.escape(title) .. "*")
	end
	local icon = Webhook.assetId(slot and slot:GetAttribute("Icon"))
	return Webhook.embed({
		title = "👹 World Boss Spawned",
		description = table.concat(lines, "\n"),
		fields = {
			Webhook.field("📍 Region", Webhook.code(boss.Region)),
			Webhook.field("❤️ Health", Webhook.code(humanoid and Webhook.number(humanoid.MaxHealth))),
			Webhook.field("🎁 Chest", Webhook.code(type(chest) == "string" and chest or "None")),
			Webhook.field("🔁 Respawn", Webhook.code(BossStats.duration(spawnTime))),
			Webhook.field("👥 Server", Webhook.code(Webhook.server())),
			Webhook.field(night and "🌙 Spawns" or "☀️ Spawns", Webhook.code(night and "Night only" or "Any time")),
		},
	}, icon and Webhook.thumbnail("asset", icon))
end

function Webhook.nearestPlace(position)
	local best, bestDistance = nil, math.huge
	for name, place in pairs(Travel.Places) do
		local distance = (place - position).Magnitude
		if distance < bestDistance then
			best, bestDistance = name, distance
		end
	end
	return best
end

function Webhook.marketerEmbed()
	local config = Game.BlackMarketer
	local state, spot = Travel.marketer()
	local ok, stock = pcall(Game.TimedVendor.GetStock, config.TimedVendor, state.Cycle)
	local lines = {}
	if ok and type(stock) == "table" then
		for _, entry in ipairs(stock) do
			local name = type(entry) == "table" and entry.Name
			if type(name) == "string" then
				local info = Game.Items[name]
				local rarity, mark = Webhook.rarity(type(info) == "table" and tonumber(info.Rarity) or nil)
				table.insert(lines, mark .. " **" .. Webhook.escape(name) .. "**  ·  " .. rarity)
			end
		end
	end
	local icon = Webhook.assetId(config.Icon)
	return Webhook.embed({
		title = "🛒 Black Marketer Arrived",
		description = "The **Black Marketer** has slipped into town",
		fields = {
			Webhook.field("📍 Near", Webhook.code(typeof(spot) == "CFrame" and Webhook.nearestPlace(spot.Position))),
			Webhook.field("⏳ Leaves In", Webhook.code(Travel.minutes(state.NextEdgeIn))),
			Webhook.field("👥 Server", Webhook.code(Webhook.server())),
			Webhook.field("🧾 Stock", #lines > 0 and table.concat(lines, "\n") or Webhook.code("Unknown"), false),
		},
	}, icon and Webhook.thumbnail("asset", icon))
end

function Webhook.muzanEmbed()
	local icon = Webhook.assetId(Game.MuzanNpc.Icon)
	return Webhook.embed({
		title = "🌙 Muzan Is Walking",
		description = "Night has fallen and **Muzan** is on patrol",
		fields = {
			Webhook.field("🌅 Dawn In", Webhook.code(Travel.minutes(Game.DayNight.SecondsUntilPhaseChange()))),
			Webhook.field("🛣️ Paths", Webhook.code(#Travel.MuzanPaths)),
			Webhook.field("👥 Server", Webhook.code(Webhook.server())),
		},
	}, icon and Webhook.thumbnail("asset", icon))
end

Webhook.NpcWatch = {
	["Black Marketer"] = {
		Present = function()
			return Travel.marketer().Active == true
		end,
		Build = Webhook.marketerEmbed,
		Line = "🛒 **Black Marketer** arrived in town",
	},
	Muzan = {
		Present = function()
			return Game.DayNight.IsEnabled() == true and Game.DayNight.IsNight() == true
		end,
		Build = Webhook.muzanEmbed,
		Line = "🌙 **Muzan** started his night patrol",
	},
}

function Webhook.npcWanted(name)
	local list = Settings.NotifyNpcList
	return Webhook.notifying("NotifyNpcs") and (#list == 0 or table.find(list, name) ~= nil)
end

function Webhook.trackNpcs()
	for _, name in ipairs(Const.WEBHOOK_NPCS) do
		local watch = Webhook.NpcWatch[name]
		local ok, present = pcall(watch.Present)
		if ok then
			local previous = Webhook.NpcPresent[name]
			Webhook.NpcPresent[name] = present
			if present and previous == false and Webhook.npcWanted(name) then
				Webhook.notify(name .. " arrival", watch.Build, "npc", watch.Line)
			end
		end
	end
end

function Webhook.digestEmbed(digest, startedAt, endedAt)
	local profile = Webhook.profile()
	local drops = {}
	for _, drop in pairs(digest.Drops) do
		table.insert(drops, drop)
	end
	Webhook.sortDrops(drops)
	local top = drops[1]
	local fields = {}
	if top then
		local lines, total = Webhook.dropLines(drops)
		table.insert(fields, Webhook.field("🎁 Drops  ·  ×" .. Webhook.number(total), lines, false))
	end
	if digest.LevelTo then
		local gained = digest.LevelTo - digest.LevelFrom
		table.insert(fields, Webhook.field("🆙 Level Ups", Webhook.code(Webhook.number(digest.LevelFrom) .. " → " .. Webhook.number(digest.LevelTo) .. "  (+" .. Webhook.number(gained) .. ")"), false))
	end
	local events = digest.Events
	if #events > 0 then
		local lines = table.move(events, 1, math.min(#events, Const.WEBHOOK_DIGEST_EVENTS), 1, {})
		if #events > Const.WEBHOOK_DIGEST_EVENTS then
			table.insert(lines, "*+" .. (#events - Const.WEBHOOK_DIGEST_EVENTS) .. " more*")
		end
		table.insert(fields, Webhook.field("📣 Spawns & Arrivals", table.concat(lines, "\n"), false))
	end
	table.insert(fields, Webhook.field("⭐ Level", Webhook.code(Webhook.number(profile.Level))))
	table.insert(fields, Webhook.field("💰 Wen", Webhook.code(Webhook.number(profile.Wen))))
	table.insert(fields, Webhook.field("⏱️ Session", Webhook.code(Webhook.session())))
	local icon = top and Webhook.assetId(top.Info.Icon)
	return Webhook.embed({
		title = "📋 Spryzen Hub Digest",
		description = "Everything from <t:" .. startedAt .. ":t> to <t:" .. endedAt .. ":t>",
		fields = fields,
	}, icon and Webhook.thumbnail("asset", icon) or Webhook.thumbnail("user", LocalPlayer.UserId))
end

function Webhook.finalSelectionEmbed(event, startsAt)
	local profile = Webhook.profile()
	local requirements = type(event.Requirements) == "table" and event.Requirements or {}
	local keys = {}
	for key in pairs(requirements) do
		table.insert(keys, tostring(key))
	end
	table.sort(keys)
	local lines, eligible = {}, true
	for _, key in ipairs(keys) do
		local want = requirements[key]
		local met
		if key == "Level" then
			met = profile.Level ~= nil and tonumber(want) ~= nil and profile.Level >= tonumber(want)
		elseif key == "Race" then
			met = profile.Race == want
		end
		eligible = eligible and met ~= false
		local mark = met == true and "✅" or met == false and "❌" or "▫️"
		table.insert(lines, mark .. " " .. Webhook.escape(key) .. " " .. Webhook.escape(tostring(want)))
	end
	return Webhook.embed({
		title = "⚔️ " .. tostring(event.Title or "Final Selection") .. " Soon",
		description = "**" .. Webhook.escape(tostring(event.Title or "Final Selection")) .. "** starts <t:" .. startsAt .. ":R> at <t:" .. startsAt .. ":t>",
		fields = {
			Webhook.field("📋 Requirements", #lines > 0 and table.concat(lines, "\n") or Webhook.code("None")),
			Webhook.field("🎫 Eligible", Webhook.code(eligible and "Yes" or "No")),
			Webhook.field("⭐ Level", Webhook.code(Webhook.number(profile.Level))),
			Webhook.field("🧬 Race", Webhook.code(profile.Race)),
			Webhook.field("👥 Server", Webhook.code(Webhook.server())),
		},
	}, Webhook.thumbnail("user", LocalPlayer.UserId))
end

function Webhook.trackFinalSelection()
	if not Webhook.notifying("NotifyFinalSelection") then
		return
	end
	local event = Game.TimedEvents.FinalSelection
	local every = type(event) == "table" and tonumber(event.Every)
	if not every or every <= 0 then
		return
	end
	local now = Workspace:GetServerTimeNow()
	local cycle = math.floor(now / every) + 1
	if every - now % every > Const.FINAL_SELECTION_LEAD or Webhook.FinalSelectionCycle == cycle then
		return
	end
	Webhook.FinalSelectionCycle = cycle
	local startsAt = math.floor(cycle * every)
	Webhook.enqueue("Final Selection warning", function()
		return Webhook.finalSelectionEmbed(event, startsAt)
	end)
end

function Webhook.testEmbed()
	local profile = Webhook.profile()
	local function line(enabled, text)
		return (enabled and "🟢 " or "🔴 ") .. text
	end
	local drops = "Drops  ·  " .. tostring(Settings.DropRarity) .. " and above"
	if #Settings.AlwaysNotify > 0 then
		drops ..= " + " .. #Settings.AlwaysNotify .. " always"
	end
	local bosses = "Boss Spawns  ·  " .. (#Settings.NotifyBossList == 0 and "all world bosses" or (#Settings.NotifyBossList .. " selected"))
	local npcs = "NPC Arrivals  ·  " .. (#Settings.NotifyNpcList == 0 and table.concat(Const.WEBHOOK_NPCS, ", ") or table.concat(Settings.NotifyNpcList, ", "))
	local description = "Spryzen Hub notifications will post in this channel."
	if Settings.WebhookDigest then
		description ..= "\nDrops, levels, spawns and arrivals are combined into one digest every **" .. Settings.WebhookInterval .. " min**."
	end
	if not Settings.Webhook then
		description ..= "\n*Turn on Enable Webhook in the hub to start receiving them.*"
	end
	return Webhook.embed({
		title = "✅ Webhook Connected",
		description = description,
		fields = {
			Webhook.field("⭐ Level", Webhook.code(Webhook.number(profile.Level))),
			Webhook.field("💰 Wen", Webhook.code(Webhook.number(profile.Wen))),
			Webhook.field("🧬 Race", Webhook.code(profile.Race)),
			Webhook.field("🏯 Clan", Webhook.code(profile.Clan)),
			Webhook.field("👥 Server", Webhook.code(Webhook.server())),
			Webhook.field("⏱️ Session", Webhook.code(Webhook.session())),
			Webhook.field("🔔 Notifications", table.concat({
				line(Settings.NotifyDrops, drops),
				line(Settings.NotifyLevel, "Level Up"),
				line(Settings.NotifyBosses, bosses),
				line(Settings.NotifyNpcs, npcs),
				line(Settings.NotifyFinalSelection, "Final Selection  ·  " .. Const.FINAL_SELECTION_LEAD // 60 .. " min warning, always instant"),
			}, "\n"), false),
		},
	}, Webhook.thumbnail("user", LocalPlayer.UserId))
end

function Webhook.test()
	if not Webhook.Request then
		return
	end
	if not Webhook.url() then
		Webhook.Last = { Text = "Enter a valid Discord webhook URL", Tone = "Error" }
		return
	end
	Webhook.Last = nil
	Webhook.enqueue("test post", Webhook.testEmbed, true)
end

function Webhook.trackDrops(data)
	local inventory = data:FindFirstChild("Inventory")
	local folder = inventory and inventory:FindFirstChild("Inventory")
	if not folder then
		return
	end
	local counts = {}
	for _, entry in ipairs(folder:GetChildren()) do
		local amount = entry:FindFirstChild("Amount")
		local value = amount and amount:IsA("ValueBase") and tonumber(amount.Value) or 1
		counts[entry.Name] = (counts[entry.Name] or 0) + value
	end
	local previous = Webhook.Counts
	Webhook.Counts = counts
	if folder ~= Webhook.Inventory then
		Webhook.Inventory = folder
		return
	end
	if not Webhook.notifying("NotifyDrops") then
		return
	end
	local now = os.clock()
	for name, count in pairs(counts) do
		local gained = count - (previous[name] or 0)
		if gained > 0 then
			Webhook.Pending[name] = (Webhook.Pending[name] or 0) + gained
			Webhook.PendingAt = Webhook.PendingAt or now
			Webhook.PendingLast = now
		end
	end
end

function Webhook.flushDrops()
	local startedAt, lastAt = Webhook.PendingAt, Webhook.PendingLast
	if not startedAt then
		return
	end
	local now = os.clock()
	if now - lastAt < Const.WEBHOOK_BATCH_QUIET and now - startedAt < Const.WEBHOOK_BATCH_MAX then
		return
	end
	local gains = Webhook.Pending
	Webhook.Pending, Webhook.PendingAt, Webhook.PendingLast = {}, nil, nil
	if not Webhook.notifying("NotifyDrops") then
		return
	end
	local minimum = table.find(Game.Rarities.Order, Settings.DropRarity) or 1
	local drops = {}
	for name, amount in pairs(gains) do
		local info = type(Game.Items[name]) == "table" and Game.Items[name] or {}
		local rank = tonumber(info.Rarity)
		if table.find(Settings.AlwaysNotify, name) or (rank and rank >= minimum) then
			table.insert(drops, { Name = name, Amount = amount, Rank = rank or 0, Info = info })
		end
	end
	if #drops == 0 then
		return
	end
	Webhook.sortDrops(drops)
	Webhook.notify(#drops == 1 and "drop" or "drops", function()
		return Webhook.dropEmbed(drops)
	end, "drops", drops)
end

function Webhook.trackLevel()
	local level = Game.level()
	local previous = Webhook.Level
	Webhook.Level = level
	if previous == nil then
		Webhook.LevelStart = level
		return
	end
	if level > previous and Webhook.notifying("NotifyLevel") then
		Webhook.notify("level up", function()
			return Webhook.levelEmbed(previous, level)
		end, "level", { From = previous, To = level })
	end
end

function Webhook.trackPlayer()
	local data = Game.data()
	if not data then
		return
	end
	if data ~= Webhook.DataFolder then
		Webhook.DataFolder = data
		Webhook.Inventory, Webhook.Level, Webhook.LevelStart = nil, nil, nil
		Webhook.Pending, Webhook.PendingAt, Webhook.PendingLast = {}, nil, nil
	end
	Webhook.trackDrops(data)
	Webhook.trackLevel()
end

function Webhook.bossWanted(boss)
	local list = Settings.NotifyBossList
	return Webhook.notifying("NotifyBosses") and (#list == 0 or table.find(list, boss.BossLabel) ~= nil)
end

function Webhook.trackBosses()
	local now = Workspace:GetServerTimeNow()
	for _, boss in ipairs(WorldBoss.List) do
		local slot = WorldBoss.slot(boss)
		local model = slot and WorldBoss.model(boss, slot)
		local key = model and (model:GetAttribute("UniqueName") or model) or nil
		local record = Webhook.Bosses[boss]
		if not record then
			record = {}
			Webhook.Bosses[boss] = record
		elseif key and key ~= record.Key and record.Down and Webhook.bossWanted(boss) then
			local spawnAt = WorldBoss.spawnAt(boss, slot)
			if spawnAt and now - spawnAt <= Const.WEBHOOK_BOSS_FRESH then
				Webhook.notify(boss.Name .. " spawn", function()
					return Webhook.bossEmbed(boss)
				end, "boss", "👹 **" .. Webhook.escape(boss.Name) .. "** spawned in " .. Webhook.escape(tostring(boss.Region)))
			end
		end
		record.Key = key
		record.Down = slot ~= nil and model == nil
	end
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local job = table.remove(Webhook.Queue, 1)
		if job then
			Webhook.Sending = true
			local ok, err = pcall(Webhook.deliver, job)
			Webhook.Sending = false
			if not ok then
				Webhook.Last = { Text = "Post failed, see console", Tone = "Error" }
				warn("[Spryzen Hub] webhook error: " .. tostring(err))
			end
			task.wait(Const.WEBHOOK_GAP)
		else
			task.wait(0.25)
		end
	end
end))

Webhook.Dungeon = { RunKey = nil, Reached = 0, Points = 0, FloorAt = 0, Done = nil, Reset = false }

function Webhook.dungeonRun()
	local mode = Workspace:GetAttribute("MinigameRunMode")
	local ranked = Workspace:GetAttribute("MinigameRunRanked") == true
	local settings = Game.MinigameSettings.Settings.Ouwigahara
	local modeInfo = type(settings) == "table" and type(settings.Modes) == "table" and settings.Modes[mode] or nil
	local maxLives = ranked and settings.Ranked and settings.Ranked.Lives or (modeInfo and modeInfo.Lives)
	local started = tonumber(Workspace:GetAttribute("MinigameRunStarted"))
	local ended = tonumber(Workspace:GetAttribute("MinigameRunEnded"))
	return {
		Mode = (ranked and "Ranked " or "") .. tostring(modeInfo and modeInfo.Title or mode or "Unknown"),
		Party = tonumber(Workspace:GetAttribute("MinigameRunSize")) or 1,
		Lives = Dungeon.hearts(),
		MaxLives = tonumber(maxLives),
		Points = Dungeon.points(),
		Reached = tonumber(LocalPlayer:GetAttribute("OuwigaharaReached")) or 0,
		Best = tonumber(LocalPlayer:GetAttribute("OuwigaharaBest")) or 0,
		Caches = tonumber(Workspace:GetAttribute("MinigameCaches")) or 0,
		Duration = started and ((ended or Workspace:GetServerTimeNow()) - started) or nil,
	}
end

function Webhook.dungeonCards()
	local folder = LocalPlayer:FindFirstChild("MinigameObtained")
	local cards = {}
	for _, card in ipairs(folder and folder:GetChildren() or {}) do
		if card:GetAttribute("Type") ~= nil then
			table.insert(cards, { Title = tostring(card:GetAttribute("Title") or card:GetAttribute("Type")), Rank = tonumber(card:GetAttribute("Rarity")) or 1, Order = tonumber(card.Name) or 0 })
		end
	end
	return cards
end

function Webhook.cardLines(cards, limit)
	local lines = {}
	for index = 1, math.min(#cards, limit) do
		local card = cards[index]
		local _, mark = Webhook.rarity(card.Rank)
		table.insert(lines, mark .. " " .. Webhook.escape(card.Title))
	end
	if #cards > limit then
		table.insert(lines, "*+" .. (#cards - limit) .. " more*")
	end
	return #lines > 0 and table.concat(lines, "\n") or Webhook.code("None yet")
end

function Webhook.dungeonFields(run)
	local lives = run.MaxLives and (run.Lives .. " / " .. run.MaxLives) or tostring(run.Lives)
	return {
		Webhook.field("🗼 Mode", Webhook.code(run.Mode)),
		Webhook.field("❤️ Lives", Webhook.code(lives)),
		Webhook.field("💎 Points", Webhook.code(Webhook.number(run.Points))),
		Webhook.field("🏆 Best Floor", Webhook.code(Webhook.number(math.max(run.Best, run.Reached)))),
		Webhook.field("📦 Caches", Webhook.code(run.Caches)),
		Webhook.field("👥 Party", Webhook.code(run.Party)),
		Webhook.field("⏱️ Run Time", Webhook.code(run.Duration and BossStats.duration(run.Duration))),
	}
end

function Webhook.floorEmbed(floor, gained, floorTime)
	local run = Webhook.dungeonRun()
	local cards = Webhook.dungeonCards()
	table.sort(cards, function(a, b)
		return a.Order > b.Order
	end)
	local milestone = floor % 10 == 0
	local fields = Webhook.dungeonFields(run)
	table.insert(fields, 1, Webhook.field("📈 Points Gained", Webhook.code("+" .. Webhook.number(math.max(gained, 0)))))
	table.insert(fields, 2, Webhook.field("⌛ Floor Time", Webhook.code(BossStats.duration(floorTime))))
	table.insert(fields, Webhook.field("🃏 Recent Cards (" .. #cards .. " taken)", Webhook.cardLines(cards, 5), false))
	return Webhook.embed({
		title = (milestone and "🏅 Milestone! Floor " or "🗼 Floor ") .. Webhook.number(floor) .. " Cleared",
		description = milestone and ("Cache secured on **floor " .. floor .. "**, the climb goes on") or ("Floor **" .. floor .. "** is down, heading up"),
		fields = fields,
	}, Webhook.thumbnail("user", LocalPlayer.UserId))
end

function Webhook.runEmbed(outcome)
	local run = Webhook.dungeonRun()
	local cards = Webhook.dungeonCards()
	table.sort(cards, function(a, b)
		if a.Rank ~= b.Rank then
			return a.Rank > b.Rank
		end
		return a.Order < b.Order
	end)
	local styles = {
		Summit = { "🏔️ Summit Reached!", "Climbed Ouwigahara to **floor %s**" },
		Reset = { "🔁 Run Reset", "Reset on **floor %s** to bank the points" },
		Fallen = { "💀 Run Over", "Fell on **floor %s**" },
	}
	local style = styles[outcome] or styles.Fallen
	local newBest = run.Reached > run.Best
	local fields = Webhook.dungeonFields(run)
	table.insert(fields, 1, Webhook.field("🧗 Floor Reached", Webhook.code(Webhook.number(run.Reached) .. (newBest and "  (new best!)" or ""))))
	table.insert(fields, Webhook.field("💎 Points / Floor", Webhook.code(run.Reached > 0 and Webhook.number(run.Points / run.Reached) or "0")))
	table.insert(fields, Webhook.field("🃏 Cards Taken (" .. #cards .. ")", Webhook.cardLines(cards, 12), false))
	return Webhook.embed({
		title = style[1],
		description = string.format(style[2], Webhook.number(run.Reached)),
		fields = fields,
	}, Webhook.thumbnail("user", LocalPlayer.UserId))
end

function Webhook.trackDungeon()
	local hook = Webhook.Dungeon
	local key = Workspace:GetAttribute("MinigameRunStarted")
	if key == nil then
		return
	end
	local reached = tonumber(LocalPlayer:GetAttribute("OuwigaharaReached")) or 0
	local ended = Workspace:GetAttribute("MinigameRunEnded") ~= nil
	if hook.RunKey ~= key then
		hook.RunKey, hook.Reached, hook.Points, hook.FloorAt, hook.Reset = key, reached, Dungeon.points(), os.clock(), false
		hook.Done = ended and key or nil
		return
	end
	if Dungeon.Resetting then
		hook.Reset = true
	end
	if reached > hook.Reached and not ended then
		local points = Dungeon.points()
		local gained, floorTime = points - hook.Points, os.clock() - hook.FloorAt
		hook.Reached, hook.Points, hook.FloorAt = reached, points, os.clock()
		if Webhook.notifying("NotifyDungeonFloor") then
			Webhook.notify("floor " .. reached, function()
				return Webhook.floorEmbed(reached, gained, floorTime)
			end, "event", "Cleared floor " .. reached .. " (" .. Webhook.number(points) .. " points)")
		end
	end
	if ended and hook.Done ~= key and LocalPlayer:GetAttribute("RunPoints") ~= nil then
		hook.Done = key
		local outcome = hook.Reset and "Reset" or (Dungeon.hearts() > 0 and "Summit" or "Fallen")
		if Webhook.notifying("NotifyDungeonRun") then
			local run = Webhook.dungeonRun()
			Webhook.notify("run over", function()
				return Webhook.runEmbed(outcome)
			end, "event", "Run over on floor " .. run.Reached .. " (" .. Webhook.number(run.Points) .. " points)")
		end
	end
end

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	local bossAt = 0
	while true do
		local ok, err = pcall(Webhook.trackPlayer)
		if not ok then
			warn("[Spryzen Hub] webhook tracker error: " .. tostring(err))
		end
		ok, err = pcall(Webhook.flushDrops)
		if not ok then
			warn("[Spryzen Hub] webhook drop batch error: " .. tostring(err))
		end
		if Settings.WebhookDigest then
			ok, err = pcall(Webhook.flushDigest)
			if not ok then
				warn("[Spryzen Hub] webhook digest error: " .. tostring(err))
			end
		end
		if Hub.InDungeon then
			ok, err = pcall(Webhook.trackDungeon)
			if not ok then
				warn("[Spryzen Hub] dungeon webhook error: " .. tostring(err))
			end
		elseif not Hub.InMinigame and os.clock() >= bossAt then
			bossAt = os.clock() + Const.WEBHOOK_BOSS_POLL
			ok, err = pcall(Webhook.trackBosses)
			if not ok then
				warn("[Spryzen Hub] webhook boss tracker error: " .. tostring(err))
			end
			ok, err = pcall(Webhook.trackNpcs)
			if not ok then
				warn("[Spryzen Hub] webhook npc tracker error: " .. tostring(err))
			end
			ok, err = pcall(Webhook.trackFinalSelection)
			if not ok then
				warn("[Spryzen Hub] webhook final selection error: " .. tostring(err))
			end
		end
		task.wait(Const.WEBHOOK_POLL)
	end
end))

RootMaid:Give(function()
	table.clear(Webhook.Queue)
end)

local Craft = { Thread = nil, Context = nil, Busy = false, Phase = "Off", Current = nil, Crafted = 0, Retry = {}, Options = {}, ByOption = {}, Refined = {}, RefineRetry = {}, RefineOptions = {} }

local Training = { Thread = nil, Context = nil, Busy = false, Status = "Off", Finished = 0, Cursor = 0, Dead = {}, Noted = {}, Clear = nil, Pointer = { Held = false, Point = nil }, Play = {} }

do
	for name in pairs(Game.Refinement and Game.Items or {}) do
		local ok, refinable = pcall(Game.Refinement.IsRefinable, name)
		if ok and refinable then
			table.insert(Craft.RefineOptions, name)
		end
	end
	table.sort(Craft.RefineOptions)
end

do
	local entries, counts = {}, {}
	for id, recipe in pairs(Game.Crafting and Game.Crafting.Definitions or {}) do
		if type(recipe) == "table" and recipe.station == Const.CRAFT_STATION and type(recipe.result) == "string" then
			local label = recipe.result .. (recipe.tier and (" T" .. recipe.tier) or "")
			local first = type(recipe.required) == "table" and recipe.required[1]
			table.insert(entries, { Id = id, Label = label, From = first and first.name })
			counts[label] = (counts[label] or 0) + 1
		end
	end
	for _, entry in ipairs(entries) do
		local label = counts[entry.Label] > 1 and entry.From and (entry.Label .. " from " .. entry.From) or entry.Label
		Craft.ByOption[label] = entry.Id
		table.insert(Craft.Options, label)
	end
	table.sort(Craft.Options)
end

function Craft.set(ctx, text)
	Craft.Phase = text
	ctx:setStatus(text)
end

function Craft.lines(recipe)
	local crafting = Game.Crafting
	local data = Game.data()
	local holder = data and data:FindFirstChild("Inventory")
	local inventory = holder and holder:FindFirstChild("Inventory")
	local function held(name)
		return inventory and crafting.Held(inventory, name, crafting.RequiredTier(recipe, name)) or 0
	end
	local function display(name)
		local tier = crafting.RequiredTier(recipe, name)
		return tier and (name .. " T" .. tier) or name
	end
	local needs, order = {}, {}
	for _, list in ipairs({ recipe.required or {}, recipe.additionalMaterials or {} }) do
		for _, item in ipairs(list) do
			if not needs[item.name] then
				table.insert(order, item.name)
			end
			needs[item.name] = (needs[item.name] or 0) + item.amount
		end
	end
	local lines = {}
	for _, name in ipairs(order) do
		local have = held(name)
		table.insert(lines, { Name = display(name), Have = have, Need = needs[name], Ok = have >= needs[name] })
	end
	for _, name in ipairs(recipe.keep or {}) do
		local have = held(name)
		table.insert(lines, { Name = display(name), Owned = have >= 1, Ok = have >= 1 })
	end
	local currencies = {}
	for currency in pairs(recipe.price or {}) do
		table.insert(currencies, currency)
	end
	table.sort(currencies)
	for _, currency in ipairs(currencies) do
		local price = crafting.PricedLine(nil, recipe, currency, recipe.price[currency])
		local cashier = Game.Shop.cashiers[currency]
		local ok = false
		local have = nil
		if cashier and data and cashier.Deferred ~= true then
			if Game.Items[currency] == nil then
				ok = cashier.CanBuy(data, price) == true
				local value = data:FindFirstChild(currency)
				have = value and value:IsA("ValueBase") and tonumber(value.Value) or nil
			else
				have = held(currency)
				ok = have >= price + (needs[currency] or 0)
			end
		end
		table.insert(lines, { Name = currency, Have = have, Need = price, Ok = ok })
	end
	return lines
end

function Craft.ready(id)
	local recipe = Game.Crafting.Get(id)
	if not recipe then
		return false
	end
	for _, line in ipairs(Craft.lines(recipe)) do
		if not line.Ok then
			return false
		end
	end
	return true
end

function Craft.levelNeeded(npc)
	local requirements = Game.Regions.NpcRequirements
	local entry = type(requirements) == "table" and requirements[npc]
	return type(entry) == "table" and tonumber(entry.Level) or 0
end

function Craft.visit(ctx, npc)
	local level = Craft.levelNeeded(npc)
	if Game.level() < level then
		return false, npc .. " needs level " .. level
	end
	local position = Game.npcPosition(npc)
	if not position then
		return false, npc .. "'s location is unknown"
	end
	local stand = position + Const.NPC_STAND_OFFSET
	Craft.set(ctx, "Going to " .. npc)
	if not ctx:moveTo(stand) then
		return false, "Could not reach " .. npc
	end
	ctx.Lease:SetGoal(function()
		return CFrame.new(stand)
	end)
	return not ctx.Cancelled
end

function Craft.data()
	local data = Game.data()
	local holder = data and data:FindFirstChild("Inventory")
	return data, holder and holder:FindFirstChild("Inventory"), holder and holder:FindFirstChild("Toolbar")
end

function Craft.refineCost(level, data)
	local rung = Game.Refinement.GetRung(level)
	if not rung or not data then
		return nil
	end
	local ores = Game.Refinement.ResolveOreCost(data, rung)
	return rung, Game.Shop.PricedFor(nil, "Wen", rung.Wen, 1), ores
end

function Craft.canRefine(level, data)
	local rung, wen, ores = Craft.refineCost(level, data)
	if not rung then
		return false
	end
	local wallet = data:FindFirstChild("Wen")
	if not Game.Shop.cashiers.Wen.CanBuy(data, wen) or (wallet and wallet.Value - wen < Settings.RefineKeepWen) then
		return false
	end
	for ore, amount in pairs(ores) do
		local cashier = Game.Shop.cashiers[ore]
		if not cashier or not cashier.CanBuy(data, amount) then
			return false
		end
	end
	return true
end

function Craft.refineItems()
	local data, inventory, toolbar = Craft.data()
	if not inventory then
		return {}, data
	end
	local equipped = {}
	for _, slot in ipairs(toolbar and toolbar:GetChildren() or {}) do
		if slot:IsA("ValueBase") and slot.Value ~= 0 then
			equipped[slot.Value] = true
		end
	end
	local picked = {}
	for _, name in ipairs(Settings.RefineItems) do
		picked[name] = true
	end
	local usePicked = next(picked) ~= nil
	local best = {}
	for _, item in ipairs(inventory:GetChildren()) do
		local id = item:FindFirstChild("Id")
		if id and item:FindFirstChild("NoSave") == nil and item:FindFirstChild("QuestGrant") == nil and Game.Refinement.IsRefinable(item.Name) then
			local isEquipped = equipped[id.Value] == true
			if (usePicked and picked[item.Name]) or (not usePicked and isEquipped) then
				local level = item:FindFirstChild("RefineLevel")
				local entry = { Item = item, Id = id.Value, Name = item.Name, Level = level and level.Value or 0, Equipped = isEquipped }
				local key = usePicked and item.Name or entry.Id
				local current = best[key]
				if not current or (entry.Equipped and not current.Equipped) or (entry.Equipped == current.Equipped and entry.Level > current.Level) then
					best[key] = entry
				end
			end
		end
	end
	local list = {}
	for _, entry in pairs(best) do
		table.insert(list, entry)
	end
	table.sort(list, function(a, b)
		if a.Equipped ~= b.Equipped then
			return a.Equipped
		end
		if a.Level ~= b.Level then
			return a.Level > b.Level
		end
		return a.Name < b.Name
	end)
	return list, data
end

function Craft.pickRefine()
	local list, data = Craft.refineItems()
	for _, entry in ipairs(list) do
		if entry.Level < Settings.RefineTarget and os.clock() >= (Craft.RefineRetry[entry.Id] or 0) and Craft.canRefine(entry.Level, data) then
			return entry
		end
	end
	return nil
end

function Craft.levelOf(item)
	local level = item:FindFirstChild("RefineLevel")
	return level and level.Value or 0
end

function Craft.useGuard(level, data)
	local rung = Game.Refinement.GetRung(level)
	return Settings.RefineGuard and rung ~= nil and rung.FailBp > 0 and level >= Settings.RefineGuardFrom and Game.Refinement.GetHeldCount(data, Game.Refinement.GuardItem) >= 1
end

function Craft.refine(ctx, target)
	local visited, reason = Craft.visit(ctx, Const.REFINE_NPC)
	if not visited then
		return false, reason
	end
	local level = Craft.levelOf(target.Item)
	local data = Game.data()
	if not target.Item.Parent or level ~= target.Level or not Craft.canRefine(level, data) then
		return false, "Item changed"
	end
	local guard = Craft.useGuard(level, data)
	Craft.set(ctx, string.format("Refining %s +%d%s", target.Name, level, guard and ", guarded" or ""))
	local ok, result = pcall(Game.SignalFunction.ToServer, "RefinementRequest", { action = "Attempt", Id = target.Id, UseGuard = guard })
	if ok and type(result) == "table" and result.Ok == true then
		local outcome = result.GuardSaved == true and "Guarded" or tostring(result.Outcome)
		Craft.Refined[outcome] = (Craft.Refined[outcome] or 0) + 1
		local raised = outcome == "Success" or outcome == "Great"
		ctx:waitFor(function()
			return not target.Item.Parent or Craft.levelOf(target.Item) ~= level
		end, raised and Const.REFINE_SYNC or Const.REFINE_SETTLE)
		return true
	end
	if not ok then
		warn("[Spryzen Hub] refine error (" .. target.Name .. "): " .. tostring(result))
	end
	local text = ok and type(result) == "table" and type(result.Reason) == "string" and result.Reason or nil
	return false, text and ("Refine refused: " .. text) or ("Refine refused for " .. target.Name)
end

function Craft.pick()
	for _, label in ipairs(Settings.CraftRecipes) do
		local id = Craft.ByOption[label]
		if id and os.clock() >= (Craft.Retry[id] or 0) and Craft.ready(id) then
			return id, label
		end
	end
	return nil
end

function Craft.cleanup(ctx)
	Craft.Busy = false
	Craft.Current = nil
	if ctx then
		ctx.Lease:SetGoal(nil)
	end
end

function Craft.idle(ctx, phase, seconds)
	Craft.cleanup(ctx)
	Craft.set(ctx, phase)
	ctx:sleep(seconds)
end

function Craft.run(ctx, id, label)
	local visited, reason = Craft.visit(ctx, Const.CRAFT_NPC)
	if not visited then
		return false, reason
	end
	if not Craft.ready(id) then
		return false, "Materials changed"
	end
	Craft.set(ctx, "Crafting " .. label)
	local ok, result = pcall(Game.SignalFunction.ToServer, "CraftRecipe", id)
	if ok and type(result) == "table" and result.Ok == true then
		return true
	end
	if not ok then
		warn("[Spryzen Hub] craft error (" .. label .. "): " .. tostring(result))
	end
	return false, "The forge refused " .. label
end

function Craft.waitText()
	local parts = {}
	if Settings.AutoCraft then
		table.insert(parts, #Settings.CraftRecipes == 0 and "pick recipes to craft" or "waiting for craft materials")
	end
	if Settings.AutoRefine then
		local list, data = Craft.refineItems()
		local pending = nil
		for _, entry in ipairs(list) do
			if entry.Level < Settings.RefineTarget then
				pending = entry
				break
			end
		end
		if #list == 0 then
			table.insert(parts, "no items to refine")
		elseif not pending then
			table.insert(parts, "items at +" .. Settings.RefineTarget)
		elseif not Craft.canRefine(pending.Level, data) then
			table.insert(parts, "waiting for refine materials")
		else
			table.insert(parts, "refine retrying soon")
		end
	end
	local text = table.concat(parts, ", ")
	return (string.gsub(text, "^%l", string.upper))
end

function Craft.step(ctx)
	local blocker = Schematics.blocker() or (Schematics.Busy and "Paused for schematics") or (Training.Busy and "Paused for training")
	if blocker then
		Craft.idle(ctx, blocker, 1)
		return
	end
	if Heal.Retreating or Escape.Active then
		Craft.idle(ctx, Escape.Active and "Paused, retreating" or "Paused to heal", 0.5)
		return
	end
	if not Character.alive() then
		Craft.idle(ctx, "Respawning", 0.5)
		return
	end
	local id, label = nil, nil
	if Settings.AutoCraft then
		id, label = Craft.pick()
	end
	if not id then
		local target = Settings.AutoRefine and Craft.pickRefine()
		if not target then
			Craft.idle(ctx, Craft.waitText(), 2)
			return
		end
		Craft.Busy = true
		Craft.Current = target.Id
		local ok, refined, reason = pcall(Craft.refine, ctx, target)
		if ctx.Cancelled then
			Craft.cleanup(ctx)
			return
		end
		if not ok then
			warn("[Spryzen Hub] auto refine error (" .. target.Name .. "): " .. tostring(refined))
			refined, reason = false, "Error, retrying soon"
		end
		if refined then
			return
		end
		Craft.cleanup(ctx)
		Craft.RefineRetry[target.Id] = os.clock() + Const.CRAFT_RETRY
		Craft.idle(ctx, reason or "Refine failed, retrying soon", 1)
		return
	end
	Craft.Busy = true
	Craft.Current = label
	local ok, crafted, reason = pcall(Craft.run, ctx, id, label)
	Craft.cleanup(ctx)
	if ctx.Cancelled then
		return
	end
	if not ok then
		warn("[Spryzen Hub] auto craft error (" .. label .. "): " .. tostring(crafted))
		crafted, reason = false, "Error, retrying soon"
	end
	if crafted then
		Craft.Crafted += 1
		Hub.Notify({ Title = "Auto Craft", Content = "Crafted " .. label .. ".", Type = "Success", Icon = "hammer", Duration = 5 })
		ctx:sleep(Const.CRAFT_GAP)
		return
	end
	Craft.Retry[id] = os.clock() + Const.CRAFT_RETRY
	Craft.idle(ctx, reason or "Craft failed, retrying soon", 1)
end

function Craft.stop()
	local ctx = Craft.Context
	local thread = Craft.Thread
	Craft.Context = nil
	Craft.Thread = nil
	Craft.Phase = "Off"
	Craft.cleanup(nil)
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function Craft.refresh()
	if not (Settings.AutoCraft or Settings.AutoRefine) or not Game.Crafting or not Game.Refinement then
		Craft.stop()
		return
	end
	if Craft.Context then
		return
	end
	table.clear(Craft.Retry)
	table.clear(Craft.RefineRetry)
	local ctx = Context.new(Mover.acquire("craft", 17))
	Craft.Context = ctx
	Craft.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(Craft.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] auto craft error: " .. tostring(err))
				Craft.idle(ctx, "Error, retrying", 1)
			end
		end
	end)
end

function Craft.rows()
	local rows = {}
	for _, label in ipairs(Settings.CraftRecipes) do
		local recipe = Craft.ByOption[label] and Game.Crafting.Get(Craft.ByOption[label])
		if recipe then
			local lines = Craft.lines(recipe)
			local missing = 0
			for _, line in ipairs(lines) do
				if not line.Ok then
					missing += 1
				end
			end
			if #rows > 0 then
				table.insert(rows, " ")
			end
			local state, tone
			if label == Craft.Current then
				state, tone = "Crafting", "Accent"
			elseif missing == 0 then
				state, tone = "Ready", "Success"
			else
				state, tone = missing .. " missing", "Warning"
			end
			table.insert(rows, { Text = label, Value = state, Tone = tone })
			for _, line in ipairs(lines) do
				local value
				if line.Owned ~= nil then
					value = line.Owned and "Owned" or "Needed"
				elseif line.Have then
					value = Webhook.number(line.Have) .. " / " .. Webhook.number(line.Need)
				else
					value = Webhook.number(line.Need)
				end
				table.insert(rows, { Text = "    " .. line.Name, Value = value, Tone = line.Ok and "Success" or "Error" })
			end
		end
	end
	return rows
end

function Craft.refineRows()
	local list, data = Craft.refineItems()
	local rows = {}
	local nextUp = nil
	for _, entry in ipairs(list) do
		local value, tone
		if entry.Level >= Settings.RefineTarget then
			value, tone = "+" .. entry.Level .. "  done", "Success"
		else
			nextUp = nextUp or entry
			value = "+" .. entry.Level .. " / +" .. Settings.RefineTarget
			if entry.Id == Craft.Current then
				tone = "Accent"
			elseif not Craft.canRefine(entry.Level, data) then
				tone = "Warning"
			end
		end
		table.insert(rows, { Text = entry.Name .. (entry.Equipped and "  (equipped)" or ""), Value = value, Tone = tone })
	end
	if nextUp and data then
		local rung, wen, ores = Craft.refineCost(nextUp.Level, data)
		if rung then
			local guarded = Craft.useGuard(nextUp.Level, data)
			local odds = guarded and Game.Refinement.GetRung(nextUp.Level, true) or rung
			table.insert(rows, " ")
			table.insert(rows, { Text = "Next", Value = nextUp.Name .. " +" .. nextUp.Level .. " to +" .. (nextUp.Level + 1) })
			local wallet = data:FindFirstChild("Wen")
			local wenOk = Game.Shop.cashiers.Wen.CanBuy(data, wen) and not (wallet and wallet.Value - wen < Settings.RefineKeepWen)
			table.insert(rows, { Text = "    Wen", Value = (wallet and (Webhook.number(wallet.Value) .. " / ") or "") .. Webhook.number(wen), Tone = wenOk and "Success" or "Error" })
			local names = {}
			for ore in pairs(ores) do
				table.insert(names, ore)
			end
			table.sort(names)
			for _, ore in ipairs(names) do
				local cashier = Game.Shop.cashiers[ore]
				local have = Game.Refinement.GetHeldCount(data, ore)
				table.insert(rows, { Text = "    " .. ore, Value = Webhook.number(have) .. " / " .. Webhook.number(ores[ore]), Tone = cashier and cashier.CanBuy(data, ores[ore]) and "Success" or "Error" })
			end
			table.insert(rows, { Text = "    Success chance", Value = string.format("%g%%", (odds.SuccessBp + odds.GreatBp) / 100), Tone = odds.FailBp >= 5000 and "Warning" or nil })
			local guards = Game.Refinement.GetHeldCount(data, Game.Refinement.GuardItem)
			table.insert(rows, { Text = "    Guard", Value = guarded and ("used, " .. guards .. " held") or (rung.FailBp > 0 and ("off, " .. guards .. " held") or "not needed"), Tone = guarded and "Accent" or nil })
		end
	end
	return rows
end

function Craft.resultsText()
	local results = Craft.Refined
	return string.format("%d ok, %d great, %d fail, %d guarded", results.Success or 0, results.Great or 0, results.Fail or 0, results.Guarded or 0)
end

RootMaid:Give(Craft.stop)

local Seller = { Thread = nil, Context = nil, Busy = false, Phase = "Off", NextAt = 0, Sold = 0, Last = nil, Force = false, Sellable = {}, ItemOptions = {}, CategoryOptions = {}, Rarities = {}, Categories = {}, Items = {}, Never = {} }

do
	local categories = {}
	for name, info in pairs(Game.Items) do
		if type(name) == "string" and type(info) == "table" and info.NoDelete ~= true and info.NoSell ~= true and info.Requirements == nil and info.NoSaveRequirements == nil and (info.Price ~= nil or Game.Shop.itemsforsale[name] ~= nil) then
			Seller.Sellable[name] = info
			table.insert(Seller.ItemOptions, name)
			if type(info.Category) == "string" and not categories[info.Category] then
				categories[info.Category] = true
				table.insert(Seller.CategoryOptions, info.Category)
			end
		end
	end
	table.sort(Seller.ItemOptions)
	table.sort(Seller.CategoryOptions)
end

function Seller.protectedIds(data)
	local ids = {}
	local function collect(folder)
		for _, value in ipairs(folder and folder:GetDescendants() or {}) do
			if (value:IsA("NumberValue") or value:IsA("IntValue")) and value.Value ~= 0 then
				ids[value.Value] = true
			end
		end
	end
	local holder = data:FindFirstChild("Inventory")
	collect(holder and holder:FindFirstChild("Toolbar"))
	collect(holder and holder:FindFirstChild("Accessories"))
	collect(data:FindFirstChild("ItemLoadouts"))
	local misc = data:FindFirstChild("Misc")
	local bait = misc and misc:FindFirstChild("EquippedBaitId")
	if bait and bait.Value ~= 0 then
		ids[bait.Value] = true
	end
	return ids
end

function Seller.reserved()
	local names = {}
	for _, list in ipairs({ Const.FISH_RODS, Const.ORES, Settings.RefineItems }) do
		for _, name in ipairs(list) do
			names[name] = true
		end
	end
	if type(Settings.FishBait) == "string" then
		names[Settings.FishBait] = true
	end
	return names
end

function Seller.wanted(name, info)
	if Seller.Items[name] then
		return true
	end
	local rarity = Game.Rarities.Order[tonumber(info.Rarity) or 1]
	if not Seller.Rarities[rarity] then
		return false
	end
	if next(Seller.Categories) ~= nil then
		return Seller.Categories[info.Category] == true
	end
	return not Const.SELL_GUARDED[info.Category]
end

function Seller.selection()
	local data = Game.data()
	local holder = data and data:FindFirstChild("Inventory")
	local inventory = holder and holder:FindFirstChild("Inventory")
	if not inventory then
		return {}, 0
	end
	local protected = Seller.protectedIds(data)
	local reserved = Seller.reserved()
	local owned, blocked = {}, {}
	for _, entry in ipairs(inventory:GetChildren()) do
		local name = entry.Name
		local id = entry:FindFirstChild("Id")
		local refine = entry:FindFirstChild("RefineLevel")
		if entry:FindFirstChild("NoSave") or entry:FindFirstChild("QuestGrant") or (id and protected[id.Value]) or (refine and refine.Value > 0) then
			blocked[name] = true
		else
			local amount = entry:FindFirstChild("Amount")
			owned[name] = (owned[name] or 0) + (amount and amount.Value or 1)
		end
	end
	local selection, total = {}, 0
	for name, count in pairs(owned) do
		local info = Seller.Sellable[name]
		if info and not blocked[name] and not Seller.Never[name] and (Seller.Items[name] or not reserved[name]) and Seller.wanted(name, info) then
			local amount = math.min(count - Settings.SellKeep, Const.SELL_MAX)
			if amount > 0 then
				selection[name] = amount
				total += amount
			end
		end
	end
	return selection, total
end

function Seller.set(ctx, text)
	Seller.Phase = text
	ctx:setStatus(text)
end

function Seller.idle(ctx, text, seconds)
	Seller.Busy = false
	ctx.Lease:SetGoal(nil)
	Seller.set(ctx, text)
	ctx:sleep(seconds)
end

function Seller.fishing()
	return Fishing.Context ~= nil and ((Fishing.Session ~= nil and Fishing.Session.bitAt ~= nil) or next(Fishing.Catches) ~= nil)
end

function Seller.sell(ctx)
	local _, total = Seller.selection()
	if total == 0 then
		return true, "Nothing to sell"
	end
	local level = Craft.levelNeeded(Const.SELL_NPC)
	if Game.level() < level then
		return false, Const.SELL_NPC .. " needs level " .. level
	end
	local position = Game.npcPosition(Const.SELL_NPC)
	if not position then
		return false, "Can't find " .. Const.SELL_NPC
	end
	Seller.Busy = true
	Seller.set(ctx, "Going to " .. Const.SELL_NPC)
	local stand = position + Const.NPC_STAND_OFFSET
	if not ctx:moveTo(stand) then
		return false, ctx.Cancelled and "Stopped" or ("Could not reach " .. Const.SELL_NPC)
	end
	ctx.Lease:SetGoal(function()
		return CFrame.new(stand)
	end)
	local selection
	selection, total = Seller.selection()
	if total == 0 then
		return true, "Nothing to sell"
	end
	Seller.set(ctx, "Selling " .. total .. " items")
	local ok, result = pcall(Game.SignalFunction.ToServer, "SellItems", selection)
	if not ok then
		warn("[Spryzen Hub] sell error: " .. tostring(result))
		return false, "Sell request failed"
	end
	if type(result) ~= "table" or next(result) == nil then
		return false, Const.SELL_NPC .. " refused the sale"
	end
	local parts = {}
	for currency, amount in pairs(result) do
		if type(amount) == "number" then
			table.insert(parts, Webhook.number(amount) .. " " .. tostring(currency))
		end
	end
	table.sort(parts)
	Seller.Sold += total
	Seller.Last = "Sold " .. total .. " items" .. (#parts > 0 and (" for " .. table.concat(parts, ", ")) or "")
	return true, Seller.Last
end

function Seller.step(ctx)
	local blocker = Schematics.blocker() or (Schematics.Busy and "Paused for schematics") or (Training.Busy and "Paused for training") or (Craft.Busy and "Paused for crafting")
	if not blocker and (Heal.Retreating or Escape.Active) then
		blocker = "Paused for survival"
	elseif not blocker and Seller.fishing() then
		blocker = "Waiting for the catch"
	end
	if blocker then
		Seller.idle(ctx, blocker, 1)
		return
	end
	if not Character.alive() then
		Seller.idle(ctx, "Respawning", 0.5)
		return
	end
	if not Seller.Force and os.clock() < Seller.NextAt then
		local _, total = Seller.selection()
		Seller.idle(ctx, string.format("%d to sell, next check in %ds", total, math.ceil(Seller.NextAt - os.clock())), 1)
		return
	end
	Seller.Force = false
	local root = Character.root()
	local origin = Fishing.Context and root and root.CFrame
	local ok, sold, text = pcall(Seller.sell, ctx)
	if origin and not ctx.Cancelled and Character.alive() then
		root = Character.root()
		if root and (root.Position - origin.Position).Magnitude > 6 then
			Seller.set(ctx, "Returning to the fishing spot")
			if ctx:moveTo(origin.Position + Vector3.new(0, 3, 0)) then
				root = Character.root()
				if root then
					root.CFrame = origin
					root.AssemblyLinearVelocity = Vector3.zero
				end
			end
		end
	end
	Seller.Busy = false
	ctx.Lease:SetGoal(nil)
	if ctx.Cancelled then
		return
	end
	if not ok then
		warn("[Spryzen Hub] auto sell error: " .. tostring(sold))
		sold, text = false, "Error"
	end
	Seller.NextAt = os.clock() + (sold and Settings.SellInterval * 60 or Const.SELL_RETRY)
	Seller.idle(ctx, sold and text or (text .. ", retrying in " .. Const.SELL_RETRY .. "s"), 1)
end

function Seller.stop()
	local ctx = Seller.Context
	local thread = Seller.Thread
	Seller.Context = nil
	Seller.Thread = nil
	Seller.Busy = false
	Seller.Phase = "Off"
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function Seller.refresh()
	if not Settings.AutoSell then
		Seller.stop()
		return
	end
	if Seller.Context then
		return
	end
	Seller.NextAt = 0
	local ctx = Context.new(Mover.acquire("sell", 18))
	Seller.Context = ctx
	Seller.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(Seller.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] auto sell error: " .. tostring(err))
				Seller.idle(ctx, "Error, retrying", 2)
			end
		end
	end)
end

function Seller.rows()
	local selection = Seller.selection()
	local names = {}
	for name in pairs(selection) do
		table.insert(names, name)
	end
	table.sort(names)
	local rows = {}
	for _, name in ipairs(names) do
		table.insert(rows, { Text = name, Value = "x" .. selection[name] })
	end
	return rows
end

RootMaid:Give(Seller.stop)

local Market = { Thread = nil, Context = nil, Busy = false, Phase = "Off", Bought = 0, Last = nil, Done = {}, RetryAt = {}, NeedTravel = {}, Items = {}, Rarities = {}, Options = {}, Listings = {}, Always = {}, Forecast = nil }

do
	local vendor = Game.BlackMarketer and Game.BlackMarketer.TimedVendor
	if type(vendor) == "table" then
		local function add(entry, always)
			local listing = type(entry) == "string" and { Name = entry } or entry
			local info = type(listing) == "table" and Game.Items[listing.Name]
			local price = type(listing) == "table" and (listing.Price or (type(info) == "table" and info.Price))
			if type(info) ~= "table" or type(price) ~= "table" or type(price.Wen) ~= "number" or next(price, next(price)) ~= nil then
				return
			end
			if not Market.Listings[listing.Name] then
				Market.Listings[listing.Name] = { Wen = price.Wen, Rarity = tonumber(info.Rarity) or 1 }
				table.insert(Market.Options, listing.Name)
			end
			if always then
				Market.Always[listing.Name] = true
			end
		end
		for _, entry in ipairs(vendor.Always or {}) do
			add(entry, true)
		end
		for _, entry in ipairs(vendor.Stock or {}) do
			add(entry, false)
		end
		table.sort(Market.Options)
	end
end

function Market.vendor()
	return Game.BlackMarketer.TimedVendor
end

function Market.duration(seconds)
	seconds = math.max(math.floor(seconds), 0)
	local days = seconds // 86400
	local hours = seconds % 86400 // 3600
	local minutes = seconds % 3600 // 60
	if days > 0 then
		return string.format("%dd %dh", days, hours)
	elseif hours > 0 then
		return string.format("%dh %dm", hours, minutes)
	elseif minutes > 0 then
		return string.format("%dm", minutes)
	end
	return string.format("%ds", seconds % 60)
end

function Market.stock(cycle)
	local ok, stock = pcall(Game.TimedVendor.GetStock, Market.vendor(), cycle)
	local names = {}
	if ok and type(stock) == "table" then
		for _, entry in ipairs(stock) do
			local name = type(entry) == "table" and entry.Name or entry
			if type(name) == "string" then
				table.insert(names, name)
			end
		end
	end
	return names
end

function Market.spot(cycle)
	local config = Game.BlackMarketer
	local index = Game.TimedVendor.GetSpotIndex(config.TimedVendor, cycle, #config.Spawns)
	return config.Spawns[index]
end

function Market.count(name)
	local data = Game.data()
	local inventory = data and data.Inventory:FindFirstChild("Inventory")
	local total = 0
	for _, entry in ipairs(inventory and inventory:GetChildren() or {}) do
		if entry.Name == name then
			local amount = entry:FindFirstChild("Amount")
			total += amount and amount.Value or 1
		end
	end
	return total
end

function Market.wanted(name)
	local listing = Market.Listings[name]
	if not listing then
		return false
	end
	if Market.Items[name] then
		return true
	end
	return not Market.Always[name] and Market.Rarities[Game.Rarities.Order[listing.Rarity]] == true
end

function Market.skipped(name)
	return Settings.MarketSkipOwned and not Market.Always[name] and Market.count(name) > 0
end

function Market.price(name)
	local listing = Market.Listings[name]
	if not listing then
		return nil
	end
	local ok, price = pcall(Game.Shop.PricedFor, LocalPlayer, "Wen", listing.Wen, 1)
	return ok and tonumber(price) or listing.Wen
end

function Market.pending(cycle)
	local list = {}
	for _, name in ipairs(Market.stock(cycle)) do
		if Market.wanted(name) and Market.Done[name] ~= cycle and not Market.skipped(name) then
			table.insert(list, name)
		end
	end
	return list
end

function Market.visits(count)
	local vendor = Market.vendor()
	local state = Game.TimedVendor.GetState(vendor)
	local every = Game.TimedVendor.GetEvery(vendor)
	local first = state.Active and state.Cycle or state.Cycle + 1
	local now = Workspace:GetServerTimeNow()
	local visits = {}
	for offset = 0, count - 1 do
		local cycle = first + offset
		local active = state.Active and cycle == state.Cycle
		table.insert(visits, { Cycle = cycle, Active = active, In = active and state.NextEdgeIn or cycle * every - now })
	end
	return visits
end

function Market.nextWanted()
	for _, visit in ipairs(Market.visits(Const.MARKET_SCAN)) do
		for _, name in ipairs(Market.stock(visit.Cycle)) do
			if Market.wanted(name) and not Market.Always[name] and Market.Done[name] ~= visit.Cycle and not Market.skipped(name) then
				if visit.Active then
					return name .. " now, leaves in " .. Market.duration(visit.In), "Success"
				end
				return name .. " in " .. Market.duration(visit.In), "Accent"
			end
		end
	end
	if next(Market.Items) == nil and next(Market.Rarities) == nil then
		return "Pick items or rarities", "Muted"
	end
	return "None in the next " .. Market.duration(Const.MARKET_SCAN * Game.TimedVendor.GetEvery(Market.vendor())), "Muted"
end

function Market.forecastRows()
	local rows = {}
	for _, visit in ipairs(Market.visits(Settings.MarketForecast)) do
		local spot = Market.spot(visit.Cycle)
		local place = typeof(spot) == "CFrame" and Webhook.nearestPlace(spot.Position) or "Unknown"
		if visit.Active then
			table.insert(rows, { Text = "Here now, leaves in " .. Market.duration(visit.In), Value = place, Tone = "Success" })
		else
			table.insert(rows, { Text = "Arrives in " .. Market.duration(visit.In), Value = place, Tone = "Accent" })
		end
		for _, name in ipairs(Market.stock(visit.Cycle)) do
			if not Market.Always[name] then
				local listing = Market.Listings[name]
				local rarity = listing and Game.Rarities.Order[listing.Rarity] or "Unknown"
				local price = listing and Webhook.number(Market.price(name))
				local tone = nil
				if Market.Done[name] == visit.Cycle then
					tone = "Muted"
				elseif Market.wanted(name) then
					tone = Market.skipped(name) and "Muted" or "Success"
				end
				table.insert(rows, { Text = "    " .. name, Value = rarity .. (price and (" · " .. price .. " Wen") or ""), Tone = tone })
			end
		end
	end
	return rows
end

function Market.set(ctx, text)
	Market.Phase = text
	ctx:setStatus(text)
end

function Market.idle(ctx, text, seconds)
	Market.Busy = false
	ctx.Lease:SetGoal(nil)
	Market.set(ctx, text)
	ctx:sleep(seconds)
end

function Market.blocker()
	local schematics = Schematics.blocker()
	if schematics then
		return schematics
	elseif Schematics.Busy then
		return "Paused for schematics"
	elseif Training.Busy then
		return "Paused for training"
	elseif Craft.Busy then
		return "Paused for crafting"
	elseif Seller.Busy then
		return "Paused for selling"
	elseif Heal.Retreating or Escape.Active then
		return "Paused for survival"
	elseif Seller.fishing() then
		return "Waiting for the catch"
	end
	return nil
end

function Market.purchase(ctx, name, cycle)
	if Game.Shop.itemsforsale[name] == nil then
		return false, "not listed yet"
	end
	local ok, allowed, reason = pcall(Game.Shop.CanBuy, LocalPlayer, name, nil, 1)
	if not ok or allowed ~= true then
		return false, type(reason) == "string" and reason or "can't buy"
	end
	local before = Market.count(name)
	Market.set(ctx, "Buying " .. name)
	Game.fire("PurchaseFromShop", name, 1)
	local bought = ctx:waitFor(function()
		return Market.count(name) > before
	end, Const.MARKET_CONFIRM)
	if bought then
		Market.Done[name] = cycle
		Market.Bought += 1
		Market.Last = "Bought " .. name .. " for " .. Webhook.number(Market.price(name)) .. " Wen"
	end
	return bought
end

function Market.step(ctx)
	local state, spot = Travel.marketer()
	if not state.Active then
		Market.idle(ctx, "Away, back in " .. Market.duration(state.NextEdgeIn), 2)
		return
	end
	local now = os.clock()
	local queue = {}
	for _, name in ipairs(Market.pending(state.Cycle)) do
		if (Market.RetryAt[name] or 0) <= now then
			table.insert(queue, name)
		end
	end
	if #queue == 0 then
		Market.idle(ctx, "Nothing left to buy, leaves in " .. Market.duration(state.NextEdgeIn), 2)
		return
	end
	local failed, reasons = {}, {}
	for _, name in ipairs(queue) do
		if ctx.Cancelled then
			return
		end
		if Market.NeedTravel[name] == state.Cycle then
			table.insert(failed, name)
		else
			local bought, reason = Market.purchase(ctx, name, state.Cycle)
			if bought then
				continue
			elseif reason then
				Market.RetryAt[name] = os.clock() + (reason == "not listed yet" and Const.MARKET_LISTING or Const.MARKET_RETRY)
				table.insert(reasons, name .. ": " .. reason)
			else
				Market.NeedTravel[name] = state.Cycle
				table.insert(failed, name)
			end
		end
	end
	local blocker = #failed > 0 and (Market.blocker() or (not Character.alive() and "Respawning"))
	if blocker then
		Market.idle(ctx, blocker, 1)
		return
	end
	if #failed > 0 and typeof(spot) == "CFrame" and not ctx.Cancelled then
		Market.Busy = true
		Market.set(ctx, "Going to the Black Marketer")
		local stand = (spot * CFrame.new(0, 0, -Const.VENDOR_STAND)).Position
		if ctx:moveTo(stand) then
			ctx.Lease:SetGoal(function()
				return CFrame.new(stand)
			end)
			for _, name in ipairs(failed) do
				if ctx.Cancelled then
					break
				end
				local bought, reason = Market.purchase(ctx, name, state.Cycle)
				if not bought then
					Market.RetryAt[name] = os.clock() + Const.MARKET_RETRY
					table.insert(reasons, name .. ": " .. (reason or "not confirmed"))
				end
			end
		elseif not ctx.Cancelled then
			for _, name in ipairs(failed) do
				Market.RetryAt[name] = os.clock() + Const.MARKET_RETRY
			end
			table.insert(reasons, "Could not reach the Black Marketer")
		end
	end
	if ctx.Cancelled then
		return
	end
	if #reasons > 0 then
		Market.idle(ctx, reasons[1] .. ", retrying in " .. Const.MARKET_RETRY .. "s", 1)
	else
		Market.idle(ctx, Market.Last or "Done", 1)
	end
end

function Market.stop()
	local ctx = Market.Context
	local thread = Market.Thread
	Market.Context = nil
	Market.Thread = nil
	Market.Busy = false
	Market.Phase = "Off"
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function Market.refresh()
	if not Settings.AutoBuyMarket then
		Market.stop()
		return
	end
	if Market.Context then
		return
	end
	local ctx = Context.new(Mover.acquire("black market", 19))
	Market.Context = ctx
	Market.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(Market.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] auto buy black market error: " .. tostring(err))
				Market.idle(ctx, "Error, retrying", 2)
			end
		end
	end)
end

RootMaid:Give(Market.stop)

function Training.service(name)
	local service = game:GetService(name)
	if typeof(cloneref) == "function" then
		return cloneref(service)
	end
	return service
end

function Training.note(label)
	if Training.Noted[label] then
		return
	end
	Training.Noted[label] = true
	warn("[Spryzen Hub] auto training needs " .. label)
end

function Training.waitUntil(condition, timeout, abort, poll)
	local deadline = os.clock() + timeout
	while os.clock() < deadline do
		if abort and abort() then
			return false
		end
		if condition() then
			return true
		end
		task.wait(poll or 0.1)
	end
	return false
end

function Training.travel(ctx, position, settle)
	local root = Character.root()
	if root and (root.Position - position).Magnitude <= Const.TRAINING_ARRIVE then
		if settle then
			task.wait(settle)
		end
		return not ctx.Cancelled
	end
	local arrived = ctx:moveTo(position)
	ctx.Lease:SetGoal(nil)
	if arrived and settle then
		task.wait(settle)
	end
	return arrived and not ctx.Cancelled
end

function Training.firePrompt(prompt)
	if typeof(prompt) ~= "Instance" or not prompt:IsA("ProximityPrompt") then
		return false
	end
	local held = math.max(prompt.HoldDuration, 0)
	local sight = prompt.RequiresLineOfSight
	pcall(function()
		prompt.RequiresLineOfSight = false
	end)
	local ok
	if held <= 0 and type(fireproximityprompt) == "function" then
		ok = pcall(fireproximityprompt, prompt)
	else
		ok = pcall(prompt.InputHoldBegin, prompt)
		if ok then
			local deadline = os.clock() + held + Const.TRAINING_HOLD_PAD
			while os.clock() < deadline and prompt.Parent and prompt.Enabled do
				task.wait()
			end
			pcall(prompt.InputHoldEnd, prompt)
		end
	end
	pcall(function()
		prompt.RequiresLineOfSight = sight
	end)
	return ok
end

function Training.folder(code)
	local root = Workspace:FindFirstChild("Training")
	if not root then
		return nil
	end
	local direct = root:FindFirstChild(code)
	if direct then
		return direct
	end
	local flat = code:gsub("%s", ""):lower()
	for _, folder in ipairs(root:GetChildren()) do
		local name = folder.Name:gsub("%s", ""):lower()
		if name == flat or name:find(flat, 1, true) or flat:find(name, 1, true) then
			return folder
		end
	end
	for _, folder in ipairs(root:GetChildren()) do
		for _, child in ipairs(folder:GetChildren()) do
			if child.Name:gsub("%s", ""):lower() == flat then
				return folder
			end
		end
	end
	return nil
end

function Training.stations(code)
	local list = {}
	local folder = Training.folder(code)
	if not folder then
		return list
	end
	local root = Character.root()
	local from = root and root.Position or Vector3.zero
	for _, child in ipairs(folder:GetChildren()) do
		if child.Name ~= "Sign" and (child:IsA("Model") or child:IsA("BasePart")) and not Training.Dead[child] then
			local ok, pivot = pcall(function()
				return child:GetPivot().Position
			end)
			if ok then
				list[#list + 1] = { model = child, point = pivot, gap = (pivot - from).Magnitude }
			end
		end
	end
	table.sort(list, function(a, b)
		return a.gap < b.gap
	end)
	return list
end

function Training.anchor(prompt)
	local part = prompt and prompt.Parent
	while part and not part:IsA("BasePart") do
		part = part.Parent
	end
	return part
end

function Training.prompt(code, near)
	local folder = Training.folder(code)
	if not folder then
		return nil
	end
	local best, bestGap
	for _, descendant in ipairs(folder:GetDescendants()) do
		if descendant:IsA("ProximityPrompt") and descendant.Enabled then
			local gap = 0
			if near then
				local part = Training.anchor(descendant)
				gap = part and (part.Position - near).Magnitude or math.huge
			end
			if not best or gap < bestGap then
				best, bestGap = descendant, gap
			end
		end
	end
	return best
end

function Training.approach(ctx, prompt)
	local part = Training.anchor(prompt)
	if not part then
		return
	end
	local reach = math.max((tonumber(prompt.MaxActivationDistance) or 10) - 3, 4)
	local root = Character.root()
	if root and (root.Position - part.Position).Magnitude <= reach then
		return
	end
	Training.travel(ctx, part.Position + Vector3.new(0, 3, 0), 0.4)
end

function Training.value()
	local ok, folder = pcall(Game.Utility.getvaluesfolder, LocalPlayer)
	return ok and folder and folder:FindFirstChild("Training") or nil
end

function Training.overlay()
	local gui = LocalPlayer:FindFirstChild("PlayerGui")
	return gui and gui:FindFirstChild("Misc") or nil
end

function Training.part(name)
	local misc = Training.overlay()
	if not misc then
		return nil
	end
	for _, descendant in ipairs(misc:GetDescendants()) do
		if descendant.Name == name and descendant:IsA("GuiObject") then
			return descendant
		end
	end
	return nil
end

function Training.Pointer.screen(point)
	local ok, inset = pcall(function()
		return GuiService:GetGuiInset()
	end)
	local shift = ok and inset or Vector2.zero
	return point.X + shift.X, point.Y + shift.Y
end

function Training.Pointer.move(point)
	local pointer = Training.Pointer
	local x, y = pointer.screen(point)
	local sent = pcall(function()
		Training.service("VirtualInputManager"):SendMouseMoveEvent(x, y, game)
	end)
	if not sent and type(mousemoveabs) == "function" then
		sent = pcall(mousemoveabs, x, y)
	end
	if sent then
		pointer.Point = point
	end
	return sent
end

function Training.Pointer.hold(down, point)
	local pointer = Training.Pointer
	down = down == true
	if pointer.Held == down then
		return true
	end
	point = point or pointer.Point
	if not point then
		return false
	end
	local x, y = pointer.screen(point)
	local sent = pcall(function()
		Training.service("VirtualInputManager"):SendMouseButtonEvent(x, y, 0, down, game, 0)
	end)
	if not sent then
		if down and type(mouse1press) == "function" then
			sent = pcall(mouse1press)
		elseif not down and type(mouse1release) == "function" then
			sent = pcall(mouse1release)
		end
	end
	if sent then
		pointer.Held = down
		pointer.Point = point
	else
		Training.note("VirtualInputManager")
	end
	return sent
end

function Training.Pointer.tap(point)
	local pointer = Training.Pointer
	if not pointer.hold(true, point) then
		return false
	end
	task.wait(0.03)
	pointer.hold(false, point)
	return true
end

function Training.clearPoint()
	local cached = Training.Clear
	if cached and os.clock() < cached.expires then
		return cached.point
	end
	local camera = Workspace.CurrentCamera
	local size = camera and camera.ViewportSize or Vector2.new(1280, 720)
	local misc = Training.overlay()
	local points = {
		Vector2.new(size.X * 0.5, size.Y * 0.4),
		Vector2.new(size.X * 0.25, size.Y * 0.55),
		Vector2.new(size.X * 0.8, size.Y * 0.25),
		Vector2.new(size.X * 0.2, size.Y * 0.2),
	}
	for _, point in ipairs(points) do
		local blocked = false
		for _, holder in ipairs({ LocalPlayer:FindFirstChild("PlayerGui"), Training.service("CoreGui") }) do
			if holder then
				local ok, hits = pcall(function()
					return holder:GetGuiObjectsAtPosition(point.X, point.Y)
				end)
				local top = ok and type(hits) == "table" and hits[1] or nil
				if top and (not misc or not top:IsDescendantOf(misc)) then
					blocked = true
				end
			end
		end
		if not blocked then
			Training.Clear = { point = point, expires = os.clock() + 1 }
			return point
		end
	end
	Training.Clear = { point = points[1], expires = os.clock() + 1 }
	return points[1]
end

Training.Play["Pushups"] = function()
	local misc = Training.overlay()
	if not misc then
		return
	end
	for _, pod in ipairs(misc:GetDescendants()) do
		if pod.Name == "Pod" then
			local holder = pod:FindFirstChild("Holder")
			local shrink = pod:FindFirstChild("Shrink")
			local button = pod:FindFirstChildWhichIsA("TextButton", true)
			if holder and shrink and button and math.abs(shrink.Size.X.Scale - holder.Size.X.Scale) < 0.07 then
				if type(firesignal) == "function" then
					pcall(firesignal, button.MouseButton1Up)
				else
					Training.Pointer.tap(button.AbsolutePosition + button.AbsoluteSize / 2)
				end
			end
		end
	end
end

Training.Play["Meditation"] = function()
	local holder = Training.part("BarHolder")
	local marker = holder and holder:FindFirstChild("Slider")
	if not marker then
		return
	end
	for _, bubble in ipairs(holder:GetChildren()) do
		if bubble ~= marker and bubble:IsA("GuiObject") then
			local reach = bubble.Size.X.Scale / 2 + 0.02
			if math.abs(marker.Position.X.Scale - bubble.Position.X.Scale) <= reach then
				Training.Pointer.tap(Training.clearPoint())
				return
			end
		end
	end
end

Training.Play["Squat"] = function()
	local tracker = Training.part("tracker")
	local bar = tracker and tracker.Parent and tracker.Parent:FindFirstChild("Bar")
	if not tracker or not bar or tracker.AbsoluteSize.Y <= 0 then
		return
	end
	local trackerMid = tracker.AbsolutePosition.Y + tracker.AbsoluteSize.Y / 2
	local barMid = bar.AbsolutePosition.Y + bar.AbsoluteSize.Y / 2
	Training.Pointer.hold(barMid > trackerMid, Training.clearPoint())
end

Training.Play["Boulder Split"] = function()
	local wrapper = Training.part("Wrapper")
	local main = wrapper and wrapper:FindFirstChild("MainHolder")
	local actual = main and main:FindFirstChild("Actual")
	if not actual or not actual:FindFirstChild("Dragger") or main.AbsoluteSize.X <= 0 then
		return
	end
	local centre = main.AbsolutePosition + main.AbsoluteSize / 2
	local radians = math.rad(main.AbsoluteRotation)
	local axis = Vector2.new(math.cos(radians), math.sin(radians))
	local reach = wrapper.AbsoluteSize.X / 2 - 6
	local pointer = Training.Pointer
	pointer.move(centre - axis * reach)
	RunService.RenderStepped:Wait()
	if not wrapper.Parent then
		return
	end
	pointer.hold(true)
	for step = 1, 10 do
		pointer.move(centre - axis * reach + axis * (reach * 2 * step / 10))
		RunService.RenderStepped:Wait()
	end
	pointer.hold(false)
end

Training.Play["Target Shooting"] = function()
	if type(fireclickdetector) ~= "function" then
		Training.note("fireclickdetector")
		return
	end
	local debree = Workspace:FindFirstChild("Debree")
	local folder = debree and debree:FindFirstChild("TargetShootingDarts")
	if not folder then
		return
	end
	for _, board in ipairs(folder:GetChildren()) do
		local detector = board:FindFirstChildWhichIsA("ClickDetector", true)
		if detector then
			pcall(fireclickdetector, detector)
		end
	end
end

Training.Play["Cup Game"] = function(memo)
	if type(fireclickdetector) ~= "function" then
		Training.note("fireclickdetector")
		return
	end
	local station = memo.station
	local cups = station and station:FindFirstChild("Cups", true)
	local ball = cups and cups:FindFirstChild("Ball")
	if not cups or not ball then
		return
	end
	local ok, ballAt = pcall(function()
		return ball:GetPivot().Position
	end)
	if not ok then
		return
	end
	local ready, choice, best = 0, nil, nil
	for _, cup in ipairs(cups:GetChildren()) do
		if cup ~= ball then
			local detector = cup:FindFirstChildWhichIsA("ClickDetector", true)
			if detector then
				ready += 1
				local got, at = pcall(function()
					return cup:GetPivot().Position
				end)
				local gap = got and (at - ballAt).Magnitude or math.huge
				if not best or gap < best then
					choice, best = detector, gap
				end
			end
		end
	end
	if ready >= 3 and choice then
		task.wait(0.2)
		if choice.Parent then
			pcall(fireclickdetector, choice)
			task.wait(1.2)
		end
	end
end

Training.Play["Boulder Push"] = function(memo, cancelled)
	local goal = memo.goal
	local root = Character.root()
	local human = Character.humanoid()
	if typeof(goal) ~= "Vector3" or not root or not human then
		return
	end
	if cancelled and cancelled() then
		pcall(function()
			human:Move(Vector3.zero, false)
		end)
		return
	end
	local flat = Vector3.new(goal.X - root.Position.X, 0, goal.Z - root.Position.Z)
	if flat.Magnitude <= 6 then
		pcall(function()
			human:Move(Vector3.zero, false)
		end)
		Training.touchGoal(memo)
		task.wait(0.5)
		return
	end
	pcall(function()
		human:Move(flat.Unit, false)
	end)
end

function Training.touchGoal(memo)
	if not memo.boulder or not memo.boulder.Parent then
		memo.boulder = Training.boulder()
	end
	local boulder = memo.boulder
	local target = memo.goalPart
	if not boulder or not target or type(firetouchinterest) ~= "function" then
		return false
	end
	pcall(firetouchinterest, boulder, target, 0)
	task.wait(0.1)
	pcall(firetouchinterest, boulder, target, 1)
	return true
end

function Training.pushPlan(code, value)
	local memo = { goal = value:GetAttribute("GoalPosition") }
	local folder = Training.folder(code)
	local name = value:GetAttribute("GoalName")
	local model = folder and type(name) == "string" and folder:FindFirstChild(name) or nil
	if model then
		memo.goalPart = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
	end
	memo.boulder = Training.boulder()
	return memo
end

function Training.boulder()
	local root = Character.root()
	local debree = Workspace:FindFirstChild("Debree")
	if not root or not debree then
		return nil
	end
	for _, child in ipairs(debree:GetChildren()) do
		local weld = child:FindFirstChild("Weld")
		if weld and weld:IsA("Weld") and weld.Part0 == root then
			return child:IsA("BasePart") and child or child:FindFirstChildWhichIsA("BasePart", true)
		end
	end
	return nil
end

function Training.watch(code, value, mode, memo, cancelled, cap)
	local solver = (mode == "Play It Out" or code == "Boulder Push") and Training.Play[code] or nil
	local deadline = os.clock() + (cap or Const.TRAINING_TIMEOUT)
	while value.Parent and not cancelled() and os.clock() < deadline do
		if solver then
			pcall(solver, memo, cancelled)
		end
		RunService.RenderStepped:Wait()
	end
	Training.Pointer.hold(false)
	local human = Character.humanoid()
	if human then
		pcall(function()
			human:Move(Vector3.zero, false)
		end)
	end
	if not value.Parent then
		return true
	end
	Game.fire("training_signaler", "Stop", false)
	Training.waitUntil(function()
		return not value.Parent
	end, 5)
	return false
end

function Training.finish(ctx, code, station, value, mode, cancelled)
	if code == "Boulder Push" then
		local memo = Training.pushPlan(code, value)
		if typeof(memo.goal) ~= "Vector3" then
			Training.Status = "No goal for " .. code
			Game.fire("training_signaler", "Stop", false)
			return false
		end
		if mode ~= "Play It Out" then
			Training.travel(ctx, memo.goal + Vector3.new(0, 3, 0), 0.4)
			Training.touchGoal(memo)
		end
		return Training.watch(code, value, mode, memo, cancelled)
	end
	if mode ~= "Play It Out" then
		task.wait(1)
		Game.fire("training_signaler", "Stop", true)
		return Training.watch(code, value, mode, {}, cancelled, 20)
	end
	return Training.watch(code, value, mode, { station = station }, cancelled)
end

function Training.visit(ctx, code, mode)
	local function cancelled()
		return ctx.Cancelled
	end
	local stations = Training.stations(code)
	if #stations == 0 then
		local folder = Training.folder(code)
		local sign = folder and folder:FindFirstChild("Sign")
		local ok, pivot = false, nil
		if sign then
			ok, pivot = pcall(function()
				return sign:GetPivot().Position
			end)
		end
		if ok and pivot then
			Training.Status = "Heading for " .. code
			Training.travel(ctx, pivot + Vector3.new(0, 4, 0), 0.5)
			Training.waitUntil(function()
				return #Training.stations(code) > 0
			end, 8, cancelled)
			stations = Training.stations(code)
		end
	end
	if #stations == 0 then
		Training.Status = "Cannot reach " .. code
		return false
	end
	for index = 1, math.min(#stations, 3) do
		if cancelled() then
			return false
		end
		local station = stations[index]
		Training.Status = "Heading for " .. code
		Training.travel(ctx, station.point + Vector3.new(0, 3, 0), 0.5)
		if cancelled() then
			return false
		end
		Training.waitUntil(function()
			return Training.prompt(code, station.point) ~= nil
		end, 10, cancelled)
		local prompt = Training.prompt(code, station.point)
		if not prompt then
			Training.Dead[station.model] = true
		else
			Training.approach(ctx, prompt)
			if cancelled() then
				return false
			end
			prompt = Training.prompt(code, station.point) or prompt
			Training.Status = (mode == "Play It Out" and "Playing " or "Training ") .. code
			Training.firePrompt(prompt)
			local started = Training.waitUntil(function()
				return Training.value() ~= nil
			end, 6, cancelled)
			local value = Training.value()
			if started and value then
				local won = Training.finish(ctx, code, station.model, value, mode, cancelled)
				if won then
					Training.Finished += 1
					Training.Status = "Finished " .. code
				end
				return won
			end
			if cancelled() then
				return false
			end
		end
	end
	Training.Status = "Cannot use " .. code
	return false
end

function Training.blocker()
	local blocker = Schematics.blocker() or (Schematics.Busy and "Paused for schematics") or (Craft.Busy and "Paused for crafting")
	if blocker then
		return blocker
	end
	if Heal.Retreating or Escape.Active then
		return Escape.Active and "Paused, retreating" or "Paused to heal"
	end
	return nil
end

function Training.step(ctx)
	if not Character.alive() then
		return
	end
	local codes = {}
	for _, name in ipairs(Const.TRAINING_NAMES) do
		if table.find(Settings.TrainingList, name) then
			codes[#codes + 1] = name
		end
	end
	if #codes == 0 then
		Training.Status = "Pick a training"
		return
	end
	local blocker = Training.blocker()
	if blocker then
		Training.Status = blocker
		return
	end
	Training.Busy = true
	local ok, err = pcall(function()
		local cursor = (Training.Cursor % #codes) + 1
		Training.Cursor = cursor
		Training.visit(ctx, codes[cursor], Settings.TrainingMode)
	end)
	Training.Busy = false
	ctx.Lease:SetGoal(nil)
	Training.Pointer.hold(false)
	if not ok then
		warn("[Spryzen Hub] training step: " .. tostring(err))
	end
end

function Training.stop()
	local ctx = Training.Context
	local thread = Training.Thread
	Training.Context = nil
	Training.Thread = nil
	Training.Busy = false
	Training.Status = "Off"
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
	Training.Pointer.hold(false)
	local human = Character.humanoid()
	if human then
		pcall(function()
			human:Move(Vector3.zero, false)
		end)
	end
end

function Training.refresh()
	if not Settings.AutoTraining then
		Training.stop()
		return
	end
	if Training.Context then
		return
	end
	Training.Status = "Starting"
	local ctx = Context.new(Mover.acquire("training", 17))
	Training.Context = ctx
	Training.Thread = task.spawn(function()
		while not ctx.Cancelled do
			Training.step(ctx)
			ctx:sleep(1)
		end
	end)
end

local PowerStatue = { Context = nil, Thread = nil, Override = nil, Target = nil, Position = nil, Status = "Off" }

function PowerStatue.model()
	local humanoids = Workspace:FindFirstChild("Humanoids")
	local model = humanoids and humanoids:FindFirstChild("Power statue")
	return model and model:IsA("Model") and model or nil
end

function PowerStatue.goal()
	local model = PowerStatue.model()
	local root = model and model:FindFirstChild("HumanoidRootPart")
	if root then
		PowerStatue.Position = root.Position
		return Schematics.statuePose(model, root)
	end
	return PowerStatue.Position and CFrame.new(PowerStatue.Position + Vector3.new(0, Const.SCHEMATIC_STATUE_HEIGHT * 2, 0)) or nil
end

function PowerStatue.clear()
	if PowerStatue.Override and Combat.Override == PowerStatue.Override then
		Combat.Override = nil
	end
	if PowerStatue.Target and Combat.FarmTarget == PowerStatue.Target then
		Combat.FarmTarget = nil
	end
	PowerStatue.Override = nil
	PowerStatue.Target = nil
end

function PowerStatue.step(ctx)
	if not Character.alive() then
		PowerStatue.clear()
		PowerStatue.Status = "Waiting to respawn"
		return
	end
	local blocker = Training.blocker() or (Training.Busy and "Paused for training")
	if blocker then
		PowerStatue.clear()
		PowerStatue.Status = blocker
		return
	end
	local model = PowerStatue.model()
	if not model or not Mobs.isAlive(model) then
		PowerStatue.clear()
		PowerStatue.Status = PowerStatue.Position and "Flying to the statue" or "Power statue not found"
		return
	end
	local slot = tonumber(Settings.PowerStatueSlot)
	if slot and not Combat.slotItem(slot) then
		PowerStatue.clear()
		PowerStatue.Status = "Weapon slot " .. slot .. " is empty"
		return
	end
	if not PowerStatue.Override or PowerStatue.Override.Slot ~= slot then
		PowerStatue.Override = { M1 = true, Skills = true, Slot = slot }
	end
	PowerStatue.Target = model
	Combat.Override = PowerStatue.Override
	Combat.FarmTarget = model
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local ratio = humanoid and humanoid.Health / math.max(humanoid.MaxHealth, 1)
	PowerStatue.Status = ratio and string.format("Hitting the Power statue (%d%%)", math.floor(ratio * 100)) or "Hitting the Power statue"
end

function PowerStatue.stop()
	local ctx = PowerStatue.Context
	local thread = PowerStatue.Thread
	PowerStatue.Context = nil
	PowerStatue.Thread = nil
	PowerStatue.Status = "Off"
	PowerStatue.clear()
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function PowerStatue.refresh()
	if not Settings.AutoPowerStatue then
		PowerStatue.stop()
		return
	end
	if PowerStatue.Context then
		return
	end
	PowerStatue.Status = "Starting"
	local ctx = Context.new(Mover.acquire("power statue", 14))
	ctx.Lease:SetGoal(PowerStatue.goal)
	PowerStatue.Context = ctx
	PowerStatue.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(PowerStatue.step, ctx)
			if not ok then
				warn("[Spryzen Hub] power statue step: " .. tostring(err))
			end
			ctx:sleep(0.25)
		end
	end)
end

local Tame = { Thread = nil, Context = nil, Status = "Off", Hook = nil, Popups = nil, Armed = 0, RetryAt = 0, Tamed = 0 }

function Tame.set(ctx, text)
	Tame.Status = text
	ctx:setStatus(text)
end

function Tame.idle(ctx, text, seconds)
	ctx.Lease:SetGoal(nil)
	Tame.set(ctx, text)
	ctx:sleep(seconds)
end

function Tame.price()
	local info = Game.Items[Const.HORSE_ITEM]
	return type(info) == "table" and type(info.Price) == "table" and tonumber(info.Price.Wen) or nil
end

function Tame.wen()
	local data = Game.data()
	local wen = data and data:FindFirstChild("Wen")
	return wen and tonumber(wen.Value) or 0
end

function Tame.onPopup(id, data, result)
	if os.clock() > Tame.Armed or type(data) ~= "table" or data.Type ~= "Question" or result == nil then
		return
	end
	local content = tostring(data.Content)
	if not (string.find(content, "purchase", 1, true) and string.find(content, Const.HORSE_ITEM, 1, true)) then
		return
	end
	Tame.Armed = 0
	task.delay(0.3, function()
		pcall(function()
			result:Fire("Yes")
		end)
		pcall(function()
			Tame.Popups.signal:Fire(id)
		end)
	end)
end

function Tame.listen()
	if Tame.Hook then
		return true
	end
	local popups = Hub.gameModule("CAM", "Global", "Subsets", "Classes", "PopUpCreator")
	local signal = popups and popups.signal
	if type(signal) ~= "table" or type(signal.Connect) ~= "function" then
		return false
	end
	Tame.Popups = popups
	Tame.Hook = signal:Connect(Tame.onPopup)
	return Tame.Hook ~= nil
end

function Tame.unlisten()
	local hook = Tame.Hook
	Tame.Hook = nil
	Tame.Armed = 0
	if hook then
		pcall(function()
			hook:Disconnect()
		end)
	end
end

function Tame.prompt(horse)
	for _, descendant in ipairs(horse:GetDescendants()) do
		if descendant:IsA("ProximityPrompt") and descendant.Enabled then
			return descendant
		end
	end
	return nil
end

function Tame.stand(horse)
	local root = horse:FindFirstChild("HumanoidRootPart")
	local pivot = root and root:IsA("BasePart") and root.CFrame or horse:GetPivot()
	local position = (pivot * CFrame.new(Const.TAME_STAND, 0, 0)).Position
	return CFrame.lookAt(position, pivot.Position)
end

function Tame.near(horse)
	local root = Character.root()
	return root ~= nil and horse.Parent ~= nil and (root.Position - horse:GetPivot().Position).Magnitude <= Const.TAME_STAND + Const.TAME_REACH
end

function Tame.step(ctx)
	if Game.itemCount(Const.HORSE_ITEM) > 0 then
		Tame.idle(ctx, "You already own a Horse", 5)
		return
	end
	local price = Tame.price()
	if price and Tame.wen() < price then
		Tame.idle(ctx, "Need " .. Webhook.number(price) .. " Wen to buy the Horse", 5)
		return
	end
	if not Character.alive() then
		Tame.idle(ctx, "Waiting for respawn", 1)
		return
	end
	if Heal.Retreating or Escape.Active then
		Tame.idle(ctx, "Paused for survival", 1)
		return
	end
	if os.clock() < Tame.RetryAt then
		ctx.Lease:SetGoal(nil)
		ctx:sleep(1)
		return
	end
	if not Tame.listen() then
		Tame.idle(ctx, "Purchase popup hook unavailable", 10)
		return
	end
	local horse = Travel.nearestHorse()
	if not horse then
		Tame.set(ctx, "Searching the wild horse spawns")
		horse = Travel.searchHorse(ctx)
		if ctx.Cancelled then
			return
		end
		if not horse then
			Tame.idle(ctx, "No wild horse in this server right now", 5)
			return
		end
	end
	Tame.set(ctx, "Going to the wild horse")
	ctx.Lease:SetGoal(function()
		if horse.Parent then
			return Tame.stand(horse)
		end
		return nil
	end)
	if not ctx:waitFor(function()
		return ctx.Lease:IsActive() and Tame.near(horse)
	end, Const.TAME_APPROACH) then
		Tame.RetryAt = os.clock() + Const.TAME_RETRY
		Tame.idle(ctx, horse.Parent and "Could not reach the horse, retrying" or "The horse despawned", 1)
		return
	end
	local prompt = nil
	ctx:waitFor(function()
		prompt = Tame.prompt(horse)
		return prompt ~= nil
	end, 3)
	if not prompt then
		Tame.RetryAt = os.clock() + Const.TAME_RETRY
		Tame.idle(ctx, "The horse has no tame prompt right now", 1)
		return
	end
	local cancelled = function()
		return ctx.Cancelled or not horse.Parent
	end
	Tame.set(ctx, "Waiting for the Tame prompt")
	if not Prompts.waitShown(prompt, Const.TAME_SHOWN, cancelled) then
		Tame.RetryAt = os.clock() + Const.TAME_RETRY
		Tame.idle(ctx, "Tame prompt never showed, retrying", 1)
		return
	end
	Tame.Armed = os.clock() + Const.TAME_START + Const.TAME_SOLVE + Const.TAME_END + Const.TAME_BOUGHT
	Tame.set(ctx, "Taming the horse")
	Prompts.trigger(prompt, cancelled)
	if not ctx:waitFor(function()
		return Training.value() ~= nil
	end, Const.TAME_START) then
		Tame.Armed = 0
		Tame.RetryAt = os.clock() + Const.TAME_RETRY
		Tame.idle(ctx, "Taming did not start, retrying", 1)
		return
	end
	ctx.Lease:SetGoal(function()
		local root = Character.root()
		return root and root.CFrame or nil
	end)
	ctx:sleep(Const.TAME_SOLVE)
	Game.fire("training_signaler", "Stop", true)
	ctx:waitFor(function()
		return Training.value() == nil
	end, Const.TAME_END)
	Tame.set(ctx, "Tamed, buying the Horse")
	local bought = ctx:waitFor(function()
		return Game.itemCount(Const.HORSE_ITEM) > 0
	end, Const.TAME_BOUGHT)
	Tame.Armed = 0
	ctx.Lease:SetGoal(nil)
	if bought then
		Tame.Tamed += 1
		Tame.set(ctx, "Tamed and bought a Horse")
	else
		Tame.RetryAt = os.clock() + Const.TAME_RETRY
		Tame.set(ctx, "Horse purchase not confirmed, retrying")
	end
end

function Tame.stop()
	local ctx = Tame.Context
	local thread = Tame.Thread
	Tame.Context = nil
	Tame.Thread = nil
	Tame.Status = "Off"
	Tame.unlisten()
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
end

function Tame.refresh()
	if Hub.InMinigame or not Settings.AutoTameHorse then
		Tame.stop()
		return
	end
	if Tame.Context then
		return
	end
	local ctx = Context.new(Mover.acquire("tame", 21))
	Tame.Context = ctx
	Tame.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(Tame.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] auto tame horse error: " .. tostring(err))
				Tame.Armed = 0
				Tame.idle(ctx, "Error, retrying", 2)
			end
		end
	end)
end

local Gourd = { Thread = nil, Context = nil, Status = "Off", Busy = false, Using = false, Pressed = false, Used = 0, Bought = 0, RetryAt = 0, Spawns = {} }

if not Hub.InMinigame then
	local region = Game.Content and Game.Content:FindFirstChild(Const.GOURD_SELLER_REGION)
	local npcs = region and region:FindFirstChild("Npcs")
	local module = npcs and npcs:FindFirstChild(Const.GOURD_SELLER)
	local ok, config = false, nil
	if module and module:IsA("ModuleScript") then
		ok, config = pcall(require, module)
	end
	for _, spot in ipairs(ok and type(config) == "table" and type(config.Spawns) == "table" and config.Spawns or {}) do
		if typeof(spot) == "Vector3" then
			table.insert(Gourd.Spawns, spot)
		end
	end
end

function Gourd.set(ctx, text)
	Gourd.Status = text
	ctx:setStatus(text)
end

function Gourd.idle(ctx, text, seconds)
	Gourd.Busy = false
	ctx.Lease:SetGoal(nil)
	Gourd.set(ctx, text)
	ctx:sleep(seconds)
end

function Gourd.points(name)
	local ok, value = pcall(Game.PlayerProgression.ProgressValue, Const.GOURD_SIDE, name)
	return ok and tonumber(value) or 0
end

function Gourd.price(name)
	local info = Game.Items[name]
	return type(info) == "table" and type(info.Price) == "table" and tonumber(info.Price.Wen) or nil
end

function Gourd.slayer()
	return table.find(Game.sidesFor(), Const.GOURD_SIDE) ~= nil
end

function Gourd.remaining()
	local progression = Game.PlayerProgression
	local ok, info = pcall(progression.Get, LocalPlayer, Const.GOURD_SIDE)
	if not ok or type(info) ~= "table" then
		return nil
	end
	local okLevel, level = pcall(progression.LevelOfMax, info.Max)
	local left = math.max(info.Max - info.Current, 0)
	for index = (okLevel and level or 1) + 1, #progression.Levels do
		left += progression.Levels[index].Max
	end
	return left
end

function Gourd.pick(remaining)
	local smallest, largest = nil, nil
	for _, name in ipairs(Const.GOURDS) do
		if Game.itemCount(name) > 0 then
			local value = Gourd.points(name)
			largest = largest or name
			if value >= remaining then
				smallest = name
			end
		end
	end
	return smallest or largest
end

function Gourd.unpress()
	if Gourd.Pressed then
		Gourd.Pressed = false
		Game.release("Screen")
	end
end

function Gourd.release()
	Gourd.unpress()
	if Gourd.Using then
		Gourd.Using = false
		Potion.Busy = false
	end
end

function Gourd.select(ctx, name)
	local entry = Demon.item(name)
	local id = entry and entry:FindFirstChild("Id")
	local data = Game.data()
	local toolbar = data and data.Inventory:FindFirstChild("Toolbar")
	local config = LocalPlayer:FindFirstChild("Items_Config")
	local equipped = config and config:FindFirstChild("Equipped")
	if not id or not toolbar or not equipped then
		return false
	end
	local slot = Demon.slotFor(toolbar, id.Value)
	if not slot then
		slot = math.clamp(tonumber(Settings.PotionSlot) or #Const.SLOT_NAMES, 1, #Const.SLOT_NAMES)
		Game.fire("Toolbar_Equip", Const.SLOT_NAMES[slot], id.Value)
		if not ctx:waitFor(function()
			return Demon.slotFor(toolbar, id.Value) == slot
		end, Const.GOURD_CONFIRM) then
			return false
		end
	end
	if equipped.Value ~= slot then
		equipped.Value = slot
		ctx:sleep(Const.GOURD_EQUIP_SETTLE)
	end
	return equipped.Value == slot
end

function Gourd.ready()
	local ok, values = pcall(Game.Utility.getvaluesfolder, LocalPlayer)
	if not ok or not values or values:FindFirstChild("pause_gameplay") then
		return false
	end
	return Game.Checker.check(LocalPlayer) == true
end

function Gourd.use(ctx, name)
	if Potion.Busy then
		return false, "Waiting for the potion drink to finish"
	end
	local before = Game.itemCount(name)
	Gourd.Using = true
	Potion.Busy = true
	Combat.setPressing(false)
	ctx.Lease:SetGoal(nil)
	local ok, used, text = pcall(function()
		if not Gourd.select(ctx, name) then
			return false, "Could not hold " .. name
		end
		if not ctx:waitFor(Gourd.ready, Const.GOURD_CONFIRM) then
			return false, "Can't blow yet, stunned or busy"
		end
		Gourd.Pressed = true
		Game.press("Screen")
		ctx:sleep(before <= 1 and Const.GOURD_HOLD_LAST or Const.GOURD_HOLD)
		Gourd.unpress()
		if ctx:waitFor(function()
			return Game.itemCount(name) < before
		end, Const.GOURD_CONFIRM) then
			return true, "Used " .. name
		end
		return false, name .. " was not used, retrying"
	end)
	Gourd.release()
	if not ok then
		error(used, 0)
	end
	return used, text
end

function Gourd.seller()
	local debree = Workspace:FindFirstChild("Debree")
	local regions = debree and debree:FindFirstChild("Regions")
	for _, region in ipairs(regions and regions:GetChildren() or {}) do
		for _, holderName in ipairs({ "StationaryNpcs", "ActiveNpcs" }) do
			local holder = region:FindFirstChild(holderName)
			local npc = holder and holder:FindFirstChild(Const.GOURD_SELLER)
			if npc and npc:IsA("Model") and npc:FindFirstChildWhichIsA("BasePart", true) then
				return npc
			end
		end
	end
	return nil
end

function Gourd.findSeller(ctx)
	local seller = Gourd.seller()
	if seller then
		return seller
	end
	local root = Character.root()
	local spots = table.clone(Gourd.Spawns)
	if root then
		local origin = root.Position
		table.sort(spots, function(a, b)
			return (a - origin).Magnitude < (b - origin).Magnitude
		end)
	end
	for index, spot in ipairs(spots) do
		if ctx.Cancelled then
			return nil
		end
		Gourd.set(ctx, string.format("Looking for %s (%d/%d)", Const.GOURD_SELLER, index, #spots))
		if ctx:moveTo(spot + Vector3.new(0, Const.TRAVEL_HEIGHT, 0)) then
			Mover.requestStream(spot)
			if ctx:waitFor(function()
				return Gourd.seller() ~= nil
			end, Const.GOURD_SCAN) then
				return Gourd.seller()
			end
		end
	end
	return Gourd.seller()
end

function Gourd.buy(ctx, name, count)
	local seller = Gourd.findSeller(ctx)
	if not seller then
		return false, "Could not find " .. Const.GOURD_SELLER
	end
	if not Demon.approach(ctx, seller, Const.GOURD_SELLER) then
		return false, "Could not reach " .. Const.GOURD_SELLER
	end
	local prompt = Fishing.shopPrompt(name)
	local part = prompt and prompt.Parent
	if prompt and part and part:IsA("BasePart") and (part.Position - seller:GetPivot().Position).Magnitude < 60 then
		ctx.Lease:SetGoal(nil)
		if not ctx:moveTo(part.Position + Vector3.new(0, 2, 3)) then
			return false, "Could not reach the " .. name .. " stand"
		end
	else
		prompt = seller:FindFirstChildWhichIsA("ProximityPrompt", true)
	end
	if not prompt then
		return false, Const.GOURD_SELLER .. " has no prompt"
	end
	Fishing.firePrompt(prompt)
	ctx:sleep(1)
	local before = Game.itemCount(name)
	Gourd.set(ctx, "Buying " .. count .. "x " .. name)
	Game.fire("PurchaseFromShop", name, count)
	local bought = ctx:waitFor(function()
		return Game.itemCount(name) > before
	end, Const.GOURD_BUY_CONFIRM)
	Game.fire("NpcTalking", "Ended")
	Demon.closeDialogue()
	ctx.Lease:SetGoal(nil)
	if not bought then
		return false, "Purchase of " .. name .. " not confirmed"
	end
	Gourd.Bought += Game.itemCount(name) - before
	return true, "Bought " .. (Game.itemCount(name) - before) .. "x " .. name
end

function Gourd.buyCount(name, remaining)
	local price, value = Gourd.price(name), Gourd.points(name)
	if not price or price <= 0 or value <= 0 then
		return 0, price
	end
	local afford = math.floor((Tame.wen() - Settings.GourdKeepWen) / price)
	return math.max(math.min(math.ceil(remaining / value), afford, Const.GOURD_MAX_BUY), 0), price
end

function Gourd.step(ctx)
	if not Gourd.slayer() then
		Gourd.idle(ctx, "Gourds need the Slayer side", 10)
		return
	end
	local remaining = Gourd.remaining()
	if remaining == nil then
		Gourd.idle(ctx, "Waiting for Slayer progression", 3)
		return
	end
	if remaining <= 0 then
		Gourd.idle(ctx, "Slayer progression is maxed", 10)
		return
	end
	if not Character.alive() then
		Gourd.idle(ctx, "Waiting for respawn", 1)
		return
	end
	if Heal.Retreating or Escape.Active then
		Gourd.idle(ctx, "Paused for survival", 1)
		return
	end
	local owned = Gourd.pick(remaining)
	if owned then
		local ok, text = Gourd.use(ctx, owned)
		if ok then
			Gourd.Used += 1
		end
		Gourd.set(ctx, text)
		ctx:sleep(ok and 0.3 or 1)
		return
	end
	if not Settings.GourdBuy then
		Gourd.idle(ctx, "No gourds left, " .. remaining .. " points to max", 3)
		return
	end
	if os.clock() < Gourd.RetryAt then
		ctx.Lease:SetGoal(nil)
		ctx:sleep(1)
		return
	end
	if Game.level() < Const.GOURD_SELLER_LEVEL then
		Gourd.idle(ctx, Const.GOURD_SELLER .. " sells gourds from level " .. Const.GOURD_SELLER_LEVEL, 10)
		return
	end
	local name = Settings.GourdBuyType
	local count, price = Gourd.buyCount(name, remaining)
	if count <= 0 then
		Gourd.idle(ctx, "Not enough Wen for a " .. name .. (price and (" (" .. Webhook.number(price) .. ")") or ""), 5)
		return
	end
	local blocker = Market.blocker()
	if blocker then
		Gourd.idle(ctx, blocker, 1)
		return
	end
	Gourd.Busy = true
	local ok, text = Gourd.buy(ctx, name, count)
	Gourd.Busy = false
	if not ok then
		Gourd.RetryAt = os.clock() + Const.GOURD_RETRY
		text ..= ", retrying in " .. Const.GOURD_RETRY .. "s"
	end
	Gourd.idle(ctx, text, 0.5)
end

function Gourd.stop()
	local ctx = Gourd.Context
	local thread = Gourd.Thread
	Gourd.Context = nil
	Gourd.Thread = nil
	Gourd.Busy = false
	Gourd.Status = "Off"
	if ctx then
		ctx.Cancelled = true
		ctx.Lease:Release()
	end
	if thread and thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
	end
	Gourd.release()
end

function Gourd.refresh()
	if Hub.InMinigame or not Settings.AutoGourd then
		Gourd.stop()
		return
	end
	if Gourd.Context then
		return
	end
	local ctx = Context.new(Mover.acquire("gourd", 18))
	Gourd.Context = ctx
	Gourd.Thread = task.spawn(function()
		while not ctx.Cancelled do
			local ok, err = pcall(Gourd.step, ctx)
			if not ok and not ctx.Cancelled then
				warn("[Spryzen Hub] auto gourd error: " .. tostring(err))
				Gourd.idle(ctx, "Error, retrying", 2)
			end
		end
	end)
end

RootMaid:Give(Tame.stop)
RootMaid:Give(Gourd.stop)
RootMaid:Give(FinalFarm.stop)
RootMaid:Give(PowerStatue.stop)
RootMaid:Give(Training.stop)
RootMaid:Give(BossFarm.stop)
RootMaid:Give(Farm.stop)
RootMaid:Give(Dungeon.stop)
RootMaid:Give(FinalSelection.stop)
RootMaid:Give(Mover.shutdown)

local Airflow, uiError = Hub.loadUi()

if not Airflow then
	RootMaid:Clean()
	error("[Spryzen Hub] failed to load UI library: " .. tostring(uiError), 0)
end

local Window = Hub.createWindow(Airflow, Hub.InDungeon and Hub.DUNGEON_CONFIG or Hub.InFinalSelection and Hub.FINAL_CONFIG or Hub.InMinigame and Hub.PVP_CONFIG or Hub.WORLD_CONFIG)

if Window.Home then
	local AccountBox = Window.Home:AddLeftGroupbox({ Name = "Account", Icon = "shield" })

	AccountBox:CreateStatus({
		Name = "Flagged",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			local restricted = LocalPlayer:GetAttribute("Restricted")
			if typeof(restricted) ~= "string" then
				return "Unknown", "Muted"
			end
			local list = {}
			for _, entry in ipairs(string.split(restricted, ",")) do
				entry = string.match(entry, "^%s*(.-)%s*$")
				if entry ~= "" then
					table.insert(list, entry)
				end
			end
			if #list == 0 then
				return "No", "Success"
			end
			return "Yes (" .. table.concat(list, ", ") .. ")", "Error"
		end,
	})
end

local unloaded = false

local function unload()
	if unloaded then
		return
	end
	unloaded = true
	RootMaid:Clean()
	local ok, err = pcall(Window.Destroy, Window)
	if not ok then
		warn("[Spryzen Hub] window cleanup error: " .. tostring(err))
	end
	if GlobalEnv[INSTANCE_KEY] and GlobalEnv[INSTANCE_KEY].Unload == unload then
		GlobalEnv[INSTANCE_KEY] = nil
	end
end

GlobalEnv[INSTANCE_KEY] = { Unload = unload, Version = SCRIPT_VERSION, Flags = Airflow.Flags }

Hub.Notify = function(options)
	local ok, err = pcall(Airflow.Notify, Airflow, options)
	if not ok then
		warn("[Spryzen Hub] notification failed: " .. tostring(err))
	end
end
RootMaid:Give(function()
	Hub.Notify = function() end
end)

if Window.Gui then
	RootMaid:Give(Window.Gui.Destroying:Connect(function()
		task.defer(unload)
	end))
end

local Cloud = {
	OWNER_FILE = "Ouroboros/Slayer 2 Cloud Owner.txt",
	PRIVATE_FLAGS = { WebhookUrl = true, WebhookUserId = true, PanicWhitelistNames = true, MenuPrivateOwner = true },
	TAGS = { "Farming", "Bosses", "Quests", "Dungeon", "Combat", "Safe", "AFK" },
}

function Cloud.ownerKey()
	if Cloud.Owner then
		return Cloud.Owner
	end
	local key
	pcall(function()
		if isfile(Cloud.OWNER_FILE) then
			local text = string.lower(tostring(readfile(Cloud.OWNER_FILE)))
			if #text >= 32 and #text <= 64 and not string.find(text, "[^%x]") then
				key = text
			end
		end
	end)
	if not key then
		key = string.lower((string.gsub(HttpService:GenerateGUID(false) .. HttpService:GenerateGUID(false), "-", "")))
		pcall(writefile, Cloud.OWNER_FILE, key)
	end
	Cloud.Owner = key
	return key
end

function Cloud.call(method, path, body)
	if not Webhook.Request then
		return nil, "Your executor can't make web requests"
	end
	local ok, response = pcall(Webhook.Request, {
		Url = Hub.CLOUD_URL .. path,
		Method = method,
		Headers = {
			["Content-Type"] = "application/json",
			["X-Key"] = Hub.CLOUD_KEY,
			["X-User"] = tostring(LocalPlayer.UserId),
			["X-Owner"] = Cloud.ownerKey(),
		},
		Body = body and HttpService:JSONEncode(body) or nil,
	})
	if not ok or type(response) ~= "table" then
		return nil, "Cloud server is offline"
	end
	local status = tonumber(response.StatusCode) or 0
	local decoded, data = pcall(HttpService.JSONDecode, HttpService, tostring(response.Body or ""))
	data = decoded and type(data) == "table" and data or nil
	if status < 200 or status >= 300 or not data then
		if data and type(data.error) == "string" then
			return nil, data.error
		end
		return nil, status == 0 and "Cloud server is offline" or "Cloud server error (" .. status .. ")"
	end
	return data
end

function Cloud.private(entry)
	if type(entry) ~= "table" then
		return false
	end
	for _, value in pairs(entry) do
		if type(value) == "string" and string.find(string.lower(value), "discord%a*%.com/api/webhooks") then
			return true
		end
	end
	return false
end

function Cloud.shareable(code)
	local flags, info = Window:DecodeConfig(code)
	if not flags then
		return nil, "The config code is invalid"
	end
	local kept, count = {}, 0
	for flag, entry in pairs(flags) do
		if not Cloud.PRIVATE_FLAGS[flag] and not Cloud.private(entry) then
			kept[flag] = entry
			count += 1
		end
	end
	if count == 0 then
		return nil, "There are no settings to share"
	end
	return HttpService:JSONEncode({
		Folder = info.Folder or Window.ConfigFolder,
		Name = info.Name,
		Version = info.Version,
		Config = HttpService:JSONEncode(kept),
	})
end

function Cloud.encode(text)
	return HttpService:UrlEncode(tostring(text or ""))
end

function Cloud.body(config, code)
	return {
		name = config.Name,
		description = config.Description,
		tags = config.Tags,
		code = code,
		folder = config.Folder,
	}
end

function Cloud.post(record, action, body)
	local data, reason = Cloud.call("POST", "/configs/" .. Cloud.encode(record.Id) .. "/" .. action, body or {})
	if not data then
		return false, reason
	end
	return data
end

function Cloud.names(entry)
	local names = {}
	if type(entry) == "table" and type(entry.Value) == "table" then
		for key, value in pairs(entry.Value) do
			if type(value) == "string" then
				table.insert(names, value)
			elseif value == true and type(key) == "string" then
				table.insert(names, key)
			end
		end
	end
	table.sort(names)
	return names
end

function Cloud.sellWarning(code)
	local flags = Window:DecodeConfig(code)
	local entry = type(flags) == "table" and flags.AutoSell
	if type(entry) ~= "table" or entry.Value ~= true then
		return nil
	end
	local text = "This config turns on Auto Sell, so it can sell items from your inventory without asking."
	local rarities = Cloud.names(flags.SellRarities)
	if #rarities > 0 then
		text ..= " Rarities it sells: " .. table.concat(rarities, ", ") .. "."
	end
	local items = Cloud.names(flags.SellItems)
	if #items > 0 then
		text ..= " It also sells " .. #items .. " specific item" .. (#items == 1 and "" or "s") .. "."
	end
	return text .. " Check the Market tab afterwards if you want to change it."
end

do
	local importConfig = Window.ImportConfig
	Window.ImportConfig = function(self, code, saveAs, force)
		local warning = Cloud.sellWarning(code)
		if not warning then
			return importConfig(self, code, saveAs, force)
		end
		local choice
		self:Dialog({
			Title = "Heads up: Auto Sell",
			Content = warning,
			Icon = "triangle-alert",
			CloseOnBackdrop = false,
			Buttons = {
				{ Title = "Cancel", Callback = function()
					choice = false
				end },
				{ Title = "Install anyway", Variant = "Primary", Callback = function()
					choice = true
				end },
			},
		})
		local deadline = os.clock() + 120
		while choice == nil and not unloaded and os.clock() < deadline do
			task.wait(0.1)
		end
		if choice ~= true then
			return false, "cancelled, Auto Sell was left as it was"
		end
		return importConfig(self, code, saveAs, force)
	end
end

if Hub.CLOUD_URL ~= "" then
	local ok, err = pcall(Window.CreateCloudConfigs, Window, {
		Name = "Cloud",
		Desc = "Configs shared by other players",
		Tags = Cloud.TAGS,
		PageSize = 20,
		ReportReasons = { "Broken", "Spam", "Inappropriate" },
		OnFetch = function(query)
			local path = "/configs?folder=" .. Cloud.encode(query.Folder)
				.. "&sort=" .. Cloud.encode(query.Sort)
				.. "&page=" .. tostring(query.Page)
				.. "&size=" .. tostring(query.PageSize)
			if type(query.Search) == "string" and query.Search ~= "" then
				path ..= "&search=" .. Cloud.encode(query.Search)
			end
			if query.Tag then
				path ..= "&tag=" .. Cloud.encode(query.Tag)
			end
			if query.Filter == "Mine" then
				path ..= "&mine=1"
			end
			local data, reason = Cloud.call("GET", path)
			if not data then
				return nil, reason
			end
			return data.configs, data.hasMore == true
		end,
		OnFetchCode = function(config)
			local data, reason = Cloud.call("GET", "/configs/" .. Cloud.encode(config.Id) .. "/code")
			if not data then
				return nil, reason
			end
			return data.code
		end,
		OnPublish = function(config)
			local code, reason = Cloud.shareable(config.Code)
			if not code then
				return false, reason
			end
			local data
			data, reason = Cloud.call("POST", "/configs", Cloud.body(config, code))
			if not data then
				return false, reason
			end
			return data
		end,
		OnUpdate = function(record, changes)
			local code, reason
			if changes.Code then
				code, reason = Cloud.shareable(changes.Code)
				if not code then
					return false, reason
				end
			end
			return Cloud.post(record, "update", Cloud.body(changes, code))
		end,
		OnDelete = function(record)
			local data, reason = Cloud.post(record, "delete")
			return data and true or false, reason
		end,
		OnLike = function(record, liked)
			local data, reason = Cloud.post(record, "like", { liked = liked })
			return data and true or false, reason
		end,
		OnInstall = function(record)
			Cloud.post(record, "install")
		end,
		OnReport = function(record, reason)
			local data, err = Cloud.post(record, "report", { reason = reason })
			return data and true or false, err
		end,
	})
	if not ok then
		warn("[Spryzen Hub] cloud configs failed: " .. tostring(err))
	end
end

local function statusTone(text)
	if text == "Idle" then
		return "Muted"
	end
	return "Success"
end

if Hub.InDungeon then
	local DungeonTab = Window:CreateTab({ Name = "Dungeon", Desc = "Ouwigahara climb automation", Icon = "castle" })
	local DungeonBox = DungeonTab:AddLeftGroupbox({ Name = "Auto Dungeon", Icon = "castle" })
	local CardBox = DungeonTab:AddLeftGroupbox({ Name = "Cards", Icon = "layers" })
	local PointsBox = DungeonTab:AddRightGroupbox({ Name = "Points Shop", Icon = "coins" })

	local function dungeonToggle(box, name, key, refresh)
		box:CreateToggle({
			Name = name,
			CurrentValue = Settings[key],
			Flag = key,
			Callback = function(value)
				Settings[key] = value
				if refresh then
					Dungeon.refresh()
				end
			end,
		})
	end

	local function dungeonSlider(box, name, key, range, suffix, scale)
		box:CreateSlider({
			Name = name,
			Range = range,
			Increment = 1,
			Suffix = suffix,
			CurrentValue = Settings[key] / (scale or 1),
			Flag = key,
			Callback = function(value)
				Settings[key] = value * (scale or 1)
			end,
		})
	end

	local function dungeonList(box, name, key, options)
		box:CreateDropdown({
			Name = name,
			Options = options,
			CurrentOption = {},
			MultipleOptions = true,
			Flag = key,
			Callback = function(selected)
				Settings[key] = type(selected) == "table" and selected or {}
			end,
		})
	end

	dungeonToggle(DungeonBox, "Auto Dungeon", "AutoDungeon", true)
	dungeonToggle(DungeonBox, "Auto Pickup Drops", "AutoPickup")
	dungeonSlider(DungeonBox, "Search Range (0 = whole floor)", "DungeonRange", { 0, 2000 }, " studs")
	dungeonToggle(DungeonBox, "Bring Enemies (owned rigs only)", "BringEnemies")
	dungeonSlider(DungeonBox, "Bring Range (0 = whole floor)", "BringRange", { 0, 2000 }, " studs")

	DungeonBox:CreateStatus({
		Name = "Status",
		Style = "Row",
		UpdateRate = 0.25,
		Update = Dungeon.statusText,
	})

	DungeonBox:CreateStatus({
		Name = "Run",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local floor = Workspace:GetAttribute("MinigameFloor")
			if Dungeon.phase() ~= "Climbing" or not floor then
				return "Not climbing", "Muted"
			end
			return "Floor " .. floor .. ", " .. Dungeon.hearts() .. " lives, " .. Dungeon.points() .. " points", "Accent"
		end,
	})

	DungeonBox:CreateStatus({
		Name = "Bring",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local text = Dungeon.BringStatus
			return text, text == "Off" and "Muted" or string.find(text, "^Holding") and "Success" or "Warning"
		end,
	})

	dungeonToggle(CardBox, "Auto Pick Cards", "AutoPickCards")
	dungeonList(CardBox, "Card Priority (after rarity)", "CardPriority", Dungeon.StatOptions)
	dungeonSlider(CardBox, "Full Heal Card Below HP", "HealBelow", { 0, 100 }, "%")
	dungeonSlider(CardBox, "Extra Life At Lives (0 = off)", "ExtraLifeAt", { 0, 5 })
	dungeonToggle(CardBox, "Most Points Card First", "MostPointsFirst")
	dungeonToggle(CardBox, "Avoid Curse Cards (x points)", "AvoidCurse")
	dungeonToggle(CardBox, "Skip Point Cards", "SkipPointCards")
	dungeonList(CardBox, "Pick First", "PickFirst", Dungeon.CardOptions)
	dungeonSlider(CardBox, "Pick First Min Rarity", "PickFirstRarity", { 1, 7 })
	dungeonList(CardBox, "Never Pick", "NeverPick", Dungeon.CardOptions)
	dungeonToggle(CardBox, "Auto Reroll", "AutoReroll")
	dungeonSlider(CardBox, "Reroll From Floor", "RerollFloor", { 1, 100 })
	dungeonSlider(CardBox, "Reroll Until Floor (0 = no limit)", "RerollUntilFloor", { 0, 100 })
	dungeonSlider(CardBox, "Keep Rerolls", "RerollKeep", { 0, 10 })
	dungeonSlider(CardBox, "Rerolls Per Hand (0 = no limit)", "RerollsPerHand", { 0, 10 })
	dungeonToggle(CardBox, "Reroll Until Pick First Card", "RerollForPriority")
	dungeonToggle(CardBox, "Auto Skip Wave Break", "AutoSkipBreak")

	CardBox:CreateStatus({
		Name = "Cards",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local text = Dungeon.CardStatus
			local tone = not Settings.AutoPickCards and "Muted" or string.find(text, "^Forced") and "Error" or string.find(text, "no card passed") and "Warning" or "Success"
			return text, tone
		end,
	})

	CardBox:CreateStatus({
		Name = "Hand",
		Style = "Row",
		UpdateRate = 0.25,
		Update = function()
			local hand = LocalPlayer:FindFirstChild("OuwigaharaOffers")
			local rerolled = Dungeon.Rerolls > 0 and (", rerolled " .. Dungeon.Rerolls .. "x this run") or ""
			if not hand then
				return "No cards offered" .. rerolled, "Muted"
			end
			local parts = { #Dungeon.handCards(hand) .. " cards" }
			local total = tonumber(hand:GetAttribute("TotalPicks")) or 1
			if total > 1 then
				local left = tonumber(hand:GetAttribute("Picks")) or 1
				table.insert(parts, "pick " .. (total - left + 1) .. " of " .. total)
			end
			table.insert(parts, Dungeon.handRerolls(hand) .. " rerolls")
			table.insert(parts, math.max(math.ceil(Dungeon.handTimeLeft(hand)), 0) .. "s left")
			return table.concat(parts, ", ") .. rerolled, "Accent"
		end,
	})

	dungeonToggle(PointsBox, "Auto Reset At Points", "AutoResetPoints", true)
	dungeonSlider(PointsBox, "Reset At", "ResetPoints", { 1, 500 }, "k points", 1000)
	dungeonToggle(PointsBox, "Auto Reset At Floor", "AutoResetFloor", true)
	dungeonSlider(PointsBox, "Reset At Floor", "ResetFloor", { 1, 100 })
	dungeonToggle(PointsBox, "End Run If Stuck", "StallGuard", true)
	dungeonSlider(PointsBox, "Stuck After", "StallAfter", { 30, 900 }, " s")
	dungeonToggle(PointsBox, "Auto Open Ouwigahara Chest (30,000)", "AutoChest", true)
	dungeonSlider(PointsBox, "Open Chest Times (0 = no limit)", "ChestTimes", { 0, 50 })
	dungeonToggle(PointsBox, "Auto Open Caches", "AutoCaches", true)
	dungeonToggle(PointsBox, "Auto Buy With Points", "AutoBuy", true)
	dungeonList(PointsBox, "Points Items (none = all)", "BuyItems", Dungeon.ShopOptions)

	PointsBox:CreateDropdown({
		Name = "Buy Order",
		Options = { "Most Expensive First", "Cheapest First", "Selection Order" },
		CurrentOption = Settings.BuyOrder,
		MultipleOptions = false,
		AllowNone = false,
		Flag = "BuyOrder",
		Callback = function(option)
			local value = type(option) == "table" and option[1] or option
			Settings.BuyOrder = type(value) == "string" and value or "Most Expensive First"
		end,
	})

	dungeonSlider(PointsBox, "Max Each Per Run (0 = no limit)", "BuyEachMax", { 0, 99 })
	dungeonToggle(PointsBox, "Auto Leave After Run", "AutoLeave", true)
	dungeonSlider(PointsBox, "Leave Delay", "LeaveDelay", { 0, 60 }, " s")

	PointsBox:CreateStatus({
		Name = "Points",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local opened = Dungeon.ChestOpens > 0 and (", chest opened " .. Dungeon.ChestOpens .. "x") or ""
			return Dungeon.points() .. " points" .. opened, "Accent"
		end,
	})

	local HookBox = DungeonTab:AddRightGroupbox({ Name = "Webhook", Icon = "bell" })

	dungeonToggle(HookBox, "Enable Webhook", "Webhook")

	Webhook.Inputs.Url = HookBox:CreateInput({
		Name = "Webhook URL",
		PlaceholderText = "https://discord.com/api/webhooks/...",
		CurrentValue = "",
		Flag = "WebhookUrl",
		Callback = function()
			Webhook.Last = nil
		end,
	})

	Webhook.Inputs.UserId = HookBox:CreateInput({
		Name = "Discord User ID (ping)",
		PlaceholderText = "123456789012345678",
		CurrentValue = "",
		Flag = "WebhookUserId",
		Callback = function() end,
	})

	dungeonToggle(HookBox, "Mention @everyone", "WebhookEveryone")
	dungeonToggle(HookBox, "Floor Cleared", "NotifyDungeonFloor")
	dungeonToggle(HookBox, "Run Finished", "NotifyDungeonRun")
	dungeonToggle(HookBox, "Item Drops", "NotifyDrops")

	HookBox:CreateButton({
		Name = "Send Test Post",
		Icon = "send",
		Callback = Webhook.test,
	})

	HookBox:CreateStatus({
		Name = "Status",
		Style = "Row",
		UpdateRate = 0.5,
		Update = Webhook.statusText,
	})
end

if Hub.InFinalSelection then
	local FinalTab = Window:CreateTab({ Name = "Final Selection", Desc = "Final Selection trial automation", Icon = "crown" })
	local FinalBox = FinalTab:AddLeftGroupbox({ Name = "Auto Final Selection", Icon = "list-checks" })

	FinalBox:CreateToggle({
		Name = "Auto Final Selection",
		CurrentValue = Settings.AutoFinalSelection,
		Flag = "AutoFinalSelection",
		Callback = function(value)
			Settings.AutoFinalSelection = value
			FinalSelection.refresh()
		end,
	})

	FinalBox:CreateToggle({
		Name = "Auto Pickup Drops",
		CurrentValue = Settings.AutoPickup,
		Flag = "AutoPickup",
		Callback = function(value)
			Settings.AutoPickup = value
		end,
	})

	FinalBox:CreateToggle({
		Name = "Skip Loot Wait After Passing",
		CurrentValue = Settings.FinalSkipLoot,
		Flag = "FinalSkipLoot",
		Callback = function(value)
			Settings.FinalSkipLoot = value
		end,
	})

	FinalBox:CreateStatus({
		Name = "Status",
		Style = "Row",
		UpdateRate = 0.25,
		Update = FinalSelection.statusText,
	})

	FinalBox:CreateStatus({
		Name = "Trial",
		Style = "Row",
		UpdateRate = 0.5,
		Update = FinalSelection.progressText,
	})

	local FinalFarmBox = FinalTab:AddRightGroupbox({ Name = "Auto Farm", Icon = "swords" })

	FinalFarmBox:CreateToggle({
		Name = "Auto Boss (" .. Const.FINAL_BOSS_SLOT .. ")",
		CurrentValue = Settings.FinalBoss,
		Flag = "FinalBoss",
		Callback = function(value)
			Settings.FinalBoss = value
			FinalFarm.refresh()
		end,
	})

	FinalFarmBox:CreateDropdown({
		Name = "Mobs (none = all)",
		Options = FinalFarm.Options,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "FinalMobList",
		Callback = function(options)
			Settings.FinalMobList = type(options) == "table" and options or {}
		end,
	})

	FinalFarmBox:CreateToggle({
		Name = "Auto Mobs",
		CurrentValue = Settings.FinalMobs,
		Flag = "FinalMobs",
		Callback = function(value)
			Settings.FinalMobs = value
			FinalFarm.refresh()
		end,
	})

	FinalFarmBox:CreateStatus({
		Name = "Status",
		Style = "Row",
		UpdateRate = 0.25,
		Update = FinalFarm.statusText,
	})

	FinalFarmBox:CreateStatus({
		Name = "Kills",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return tostring(FinalFarm.Kills), FinalFarm.Kills > 0 and "Accent" or "Muted"
		end,
	})
end

if not Hub.InMinigame then
	local FarmTab = Window:CreateTab({ Name = "Farm", Desc = "Quests, mobs, bosses and pickups", Icon = "swords" })
	local SellTab = Window:CreateTab({ Name = "Market", Desc = "Selling at Ginzo and Black Marketer buying", Icon = "store" })

	local MainFarm = FarmTab:CreateSubTab({ Name = "Quests & Mobs", Icon = "crosshair" })
	local BossPage = FarmTab:CreateSubTab({ Name = "Bosses", Icon = "crown" })
	local CachePage = FarmTab:CreateSubTab({ Name = "Caches", Icon = "package" })
	local SchematicPage = FarmTab:CreateSubTab({ Name = "Schematics", Icon = "scroll" })
	local CraftPage = FarmTab:CreateSubTab({ Name = "Craft & Refine", Icon = "hammer" })
	local FishingPage = FarmTab:CreateSubTab({ Name = "Fishing", Icon = "fish" })

	local LevelBox = MainFarm:AddLeftGroupbox({ Name = "Leveling", Icon = "trending-up" })

	LevelBox:CreateToggle({
		Name = "One Click Level Up",
		CurrentValue = false,
		Flag = "LevelUp",
		Callback = function(value)
			Settings.LevelUp = value
			Farm.refresh()
		end,
	})

	local QuestBox = MainFarm:AddLeftGroupbox({ Name = "Quests", Icon = "scroll-text" })

	QuestBox:CreateDropdown({
		Name = "Quest",
		Options = Catalog.QuestOptions,
		MultipleOptions = false,
		Flag = "Quest",
		Callback = function(option)
			Settings.Quest = option
			Farm.refresh()
		end,
	})

	QuestBox:CreateToggle({
		Name = "Auto Quest",
		CurrentValue = false,
		Flag = "AutoQuest",
		Callback = function(value)
			Settings.AutoQuest = value
			Farm.refresh()
		end,
	})

	local DemonBox = MainFarm:AddLeftGroupbox({ Name = "Become Demon", Icon = "moon" })

	DemonBox:CreateToggle({
		Name = "Auto Become Demon",
		CurrentValue = false,
		Flag = "AutoDemon",
		Callback = function(value)
			Settings.AutoDemon = value
			Demon.refresh()
		end,
	})

	DemonBox:CreateDropdown({
		Name = "Reputation Mobs (none = all)",
		Options = Demon.RepOptions,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "DemonRepMobs",
		Callback = function(options)
			Settings.DemonRepMobs = type(options) == "table" and options or {}
		end,
	})

	DemonBox:CreateStatus({
		Name = "Quest Step",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			local key, text = Game.isolated(Demon.stage)
			if not key then
				return "Unknown", "Muted"
			end
			return text, Demon.stageTone(key)
		end,
	})

	DemonBox:CreateStatus({
		Name = "Doing",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			return Demon.statusText()
		end,
	})

	local GearBox = MainFarm:AddLeftGroupbox({ Name = "Accessories", Icon = "list" })

	GearBox:CreateToggle({
		Name = "Auto Equip Best",
		CurrentValue = false,
		Flag = "AutoAccessories",
		Callback = function(value)
			Settings.AutoAccessories = value
			Gear.poke()
		end,
	})

	GearBox:CreateDropdown({
		Name = "Favour (none = all evenly)",
		Options = Const.GEAR_FAVOURS,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "GearFavour",
		Callback = function(options)
			Settings.GearFavour = type(options) == "table" and options or {}
			Gear.poke()
		end,
	})

	GearBox:CreateButton({
		Name = "Equip Best Now",
		Callback = function()
			Gear.ForceAccessories = true
			Gear.poke()
		end,
	})

	GearBox:CreateStatus({
		Name = "Accessories",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local text = Gear.AccessoryStatus
			if text == "Off" then
				return nil
			end
			return text, string.find(text, "^Server") and "Warning" or "Success"
		end,
	})

	GearBox:CreateDivider()

	GearBox:CreateToggle({
		Name = "Auto Equip Best Title",
		CurrentValue = false,
		Flag = "AutoTitles",
		Callback = function(value)
			Settings.AutoTitles = value
			Gear.poke()
		end,
	})

	GearBox:CreateStatus({
		Name = "Titles",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local text = Gear.TitleStatus
			if text == "Off" then
				return nil
			end
			return text, string.find(text, "^Server") and "Warning" or "Success"
		end,
	})

	local SkillTreeBox = MainFarm:AddLeftGroupbox({ Name = "Skill Tree", Icon = "list-tree" })

	SkillTreeBox:CreateToggle({
		Name = "Auto Skill Tree",
		CurrentValue = false,
		Flag = "AutoSkillTree",
		Callback = function(value)
			Settings.AutoSkillTree = value
		end,
	})

	SkillTreeBox:CreateDropdown({
		Name = "Branches (none = all, cheapest first)",
		Options = SkillTree.Options,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "SkillTreeBranches",
		Callback = function(options)
			Settings.SkillTreeBranches = type(options) == "table" and options or {}
		end,
	})

	SkillTreeBox:CreateStatus({
		Name = "Skill Tree",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			local text = SkillTree.Status
			if text == "Off" then
				return text, "Muted"
			end
			return text, string.find(text, "^Unlock") and "Success" or "Warning"
		end,
	})

	local MobBox = MainFarm:AddRightGroupbox({ Name = "Mobs", Icon = "crosshair" })

	MobBox:CreateDropdown({
		Name = "Mobs",
		Options = Catalog.MobOptions,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "Mobs",
		Callback = function(options)
			Settings.Mobs = type(options) == "table" and options or {}
		end,
	})

	MobBox:CreateToggle({
		Name = "Auto Farm Mobs",
		CurrentValue = false,
		Flag = "MobFarm",
		Callback = function(value)
			Settings.MobFarm = value
			Farm.refresh()
		end,
	})

	MobBox:CreateStatus({
		Name = "Farm",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			local text = Farm.statusText()
			return text, statusTone(text)
		end,
	})

	local GourdBox = MainFarm:AddRightGroupbox({ Name = "Slayer Gourds", Icon = "wind" })

	GourdBox:CreateToggle({
		Name = "Auto Gourd",
		CurrentValue = Settings.AutoGourd,
		Flag = "AutoGourd",
		Callback = function(value)
			Settings.AutoGourd = value
			Gourd.refresh()
		end,
	})

	GourdBox:CreateToggle({
		Name = "Buy Gourds From " .. Const.GOURD_SELLER,
		CurrentValue = Settings.GourdBuy,
		Flag = "GourdBuy",
		Callback = function(value)
			Settings.GourdBuy = value
		end,
	})

	GourdBox:CreateDropdown({
		Name = "Gourd To Buy",
		Options = Const.GOURDS,
		CurrentOption = Settings.GourdBuyType,
		MultipleOptions = false,
		AllowNone = false,
		Flag = "GourdBuyType",
		Callback = function(option)
			local value = type(option) == "table" and option[1] or option
			Settings.GourdBuyType = table.find(Const.GOURDS, value) and value or "Large Gourd"
		end,
	})

	GourdBox:CreateSlider({
		Name = "Keep Wen",
		Range = { 0, 500 },
		Increment = 1,
		Suffix = "k",
		CurrentValue = Settings.GourdKeepWen / 1000,
		Flag = "GourdKeepWen",
		Callback = function(value)
			Settings.GourdKeepWen = value * 1000
		end,
	})

	GourdBox:CreateStatus({
		Name = "Status",
		Style = "Row",
		UpdateRate = 0.25,
		Update = function()
			local ctx = Gourd.Context
			if not ctx then
				return "Off", "Muted"
			end
			local text = ctx.Status
			return text, string.find(text, "retrying") and "Warning" or string.find(text, "maxed") and "Success" or "Accent"
		end,
	})

	GourdBox:CreateStatus({
		Name = "Slayer Progress",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			local ok, info = pcall(Game.PlayerProgression.Get, LocalPlayer, Const.GOURD_SIDE)
			if not ok or type(info) ~= "table" then
				return "Unknown", "Muted"
			end
			local okLevel, level = pcall(Game.PlayerProgression.LevelOfMax, info.Max)
			return string.format("Level %s, %d/%d, used %d, bought %d", okLevel and tostring(level) or "?", info.Current, info.Max, Gourd.Used, Gourd.Bought), "Accent"
		end,
	})

	local PickupBox = MainFarm:AddRightGroupbox({ Name = "Pickups", Icon = "package" })

	PickupBox:CreateToggle({
		Name = "Auto Pick Up Drops",
		CurrentValue = false,
		Flag = "AutoPickup",
		Callback = function(value)
			Settings.AutoPickup = value
		end,
	})

	PickupBox:CreateSlider({
		Name = "Loot Range",
		Range = { 10, 300 },
		Increment = 5,
		Suffix = " studs",
		CurrentValue = Settings.DropRange,
		Flag = "LootRange",
		Callback = function(value)
			Settings.DropRange = value
		end,
	})

	PickupBox:CreateDropdown({
		Name = "Rarities (none = all)",
		Options = Collector.RarityOptions,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "PickupRarities",
		Callback = function(options)
			Settings.PickupRarities = type(options) == "table" and options or {}
			Collector.setFilter(Collector.RarityFilter, Settings.PickupRarities)
		end,
	})

	PickupBox:CreateDropdown({
		Name = "Items (none = all)",
		Options = Collector.ItemOptions,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "PickupItems",
		Callback = function(options)
			Settings.PickupItems = type(options) == "table" and options or {}
			Collector.setFilter(Collector.ItemFilter, Settings.PickupItems)
		end,
	})

	PickupBox:CreateToggle({
		Name = "Auto Collect Souls",
		CurrentValue = false,
		Flag = "AutoSouls",
		Callback = function(value)
			Settings.AutoSouls = value
		end,
	})

	PickupBox:CreateStatus({
		Name = "Pickups",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			local text = Collector.Status
			return text, statusTone(text)
		end,
	})

	local WorldBossBox = BossPage:AddLeftGroupbox({ Name = "World Bosses", Icon = "crown" })

	WorldBossBox:CreateDropdown({
		Name = "Bosses",
		Options = WorldBoss.Options,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "Bosses",
		Callback = function(options)
			Settings.Bosses = type(options) == "table" and options or {}
			if BossFarm.OrderList then
				BossFarm.OrderList:Refresh(Settings.Bosses)
			end
		end,
	})

	BossFarm.OrderList = WorldBossBox:CreateOrderList({
		Name = "Boss Order",
		Desc = "Farmed top to bottom, then back to the top",
		Items = Settings.Bosses,
		MaxRows = 6,
		EmptyText = "Pick bosses above",
		Flag = "BossOrder",
		Callback = function(order)
			Settings.BossOrder = type(order) == "table" and order or {}
		end,
	})

	WorldBossBox:CreateToggle({
		Name = "Auto World Bosses",
		CurrentValue = false,
		Flag = "WorldBosses",
		Callback = function(value)
			Settings.WorldBosses = value
			BossFarm.refresh()
		end,
	})

	WorldBossBox:CreateSlider({
		Name = "Wait Before Next Boss",
		Range = { 0, 120 },
		Increment = 1,
		Suffix = "s",
		CurrentValue = Settings.BossNextDelay,
		Flag = "BossNextDelay",
		Callback = function(value)
			Settings.BossNextDelay = value
		end,
	})

	WorldBossBox:CreateToggle({
		Name = "Switch Boss When Player Nearby",
		CurrentValue = false,
		Flag = "BossAvoidPlayers",
		Callback = function(value)
			Settings.BossAvoidPlayers = value
		end,
	})

	WorldBossBox:CreateSlider({
		Name = "Player Nearby Radius",
		Range = { 20, 300 },
		Increment = 5,
		Suffix = " studs",
		CurrentValue = Settings.BossAvoidRadius,
		Flag = "BossAvoidRadius",
		Callback = function(value)
			Settings.BossAvoidRadius = value
		end,
	})

	WorldBossBox:CreateDivider()

	WorldBossBox:CreateStatus({
		Name = "State",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			if not BossFarm.Context then
				return "Off", "Muted"
			end
			return BossFarm.Phase, BossFarm.tone(BossFarm.Phase) or "Muted"
		end,
	})

	WorldBossBox:CreateStatus({
		Name = "Boss",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local boss = BossFarm.Context and BossFarm.Focus
			if not boss then
				return nil
			end
			return boss.Name .. "  " .. BossFarm.stateText(boss)
		end,
	})

	WorldBossBox:CreateStatus({
		Name = "Next",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			local boss = BossFarm.Context and BossFarm.upcoming()
			if not boss then
				return nil
			end
			return boss.Name .. "  " .. BossFarm.stateText(boss)
		end,
	})

	WorldBossBox:CreateStatus({
		Name = "Kills",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return BossFarm.Kills
		end,
	})

	local YetiBox = BossPage:AddLeftGroupbox({ Name = "Yeti", Icon = "snowflake" })

	YetiBox:CreateToggle({
		Name = "Auto Yeti",
		CurrentValue = false,
		Flag = "AutoYeti",
		Callback = function(value)
			Settings.AutoYeti = value
			YetiFarm.refresh()
		end,
	})

	YetiBox:CreateToggle({
		Name = "Instant Kill Minions",
		CurrentValue = false,
		Flag = "YetiMinionKill",
		Callback = function(value)
			Settings.YetiMinionKill = value
		end,
	})

	YetiBox:CreateToggle({
		Name = "Auto Buy Frozen Hearts",
		CurrentValue = false,
		Flag = "YetiAutoBuy",
		Callback = function(value)
			Settings.YetiAutoBuy = value
			YetiFarm.BuyRetryAt = 0
		end,
	})

	YetiBox:CreateSlider({
		Name = "Keep Hearts",
		Range = { 1, 50 },
		Increment = 1,
		CurrentValue = Settings.YetiKeepHearts,
		Flag = "YetiKeepHearts",
		Callback = function(value)
			Settings.YetiKeepHearts = value
		end,
	})

	YetiBox:CreateDivider()

	YetiBox:CreateToggle({
		Name = "Server Hop for Yeti",
		CurrentValue = false,
		Flag = "YetiServerHop",
		Callback = function(value)
			YetiHop.Enabled = value
			YetiHop.Since = nil
			local autoYeti = Airflow.Flags.AutoYeti
			if value and autoYeti and not autoYeti:Get() then
				autoYeti:Set(true)
			end
		end,
	})

	YetiBox:CreateStatus({
		Name = "Hop",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			if not YetiHop.Enabled then
				return nil
			end
			local text = YetiHop.Status
			if YetiHop.Hopping then
				return text, "Warning"
			end
			return text, string.find(text, "^Yeti here") and "Success" or "Muted"
		end,
	})

	YetiBox:CreateDivider()

	YetiBox:CreateStatus({
		Name = "State",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			if not YetiFarm.Context then
				return "Off", "Muted"
			end
			local phase = YetiFarm.Phase
			local tone = BossFarm.tone(phase) or (phase == "Killing minions" and "Accent") or "Muted"
			return phase, tone
		end,
	})

	YetiBox:CreateStatus({
		Name = "Yeti",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local boss = YetiFarm.boss()
			if not boss then
				if YetiFarm.prompt() then
					return "Frozen, ready to summon", "Success"
				end
				local left = YetiFarm.refreezeIn()
				if left then
					return "Thawed, refreezes in ~" .. WorldBoss.clock(left), "Warning"
				end
				return "Berg not in view", "Muted"
			end
			local humanoid = boss:FindFirstChildOfClass("Humanoid")
			local text = math.floor(humanoid.Health / math.max(humanoid.MaxHealth, 1) * 100) .. "% HP"
			if boss:FindFirstChild("iframe") then
				return text .. ", immune", "Warning"
			end
			return text, "Success"
		end,
	})

	YetiBox:CreateStatus({
		Name = "Minions",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local _, count = YetiFarm.nearestMinion()
			local text = count .. " alive"
			if Settings.YetiMinionKill then
				text ..= ", " .. YetiFarm.MinionKills .. " insta-killed"
				if not InstantKill.supported() then
					return "Executor has no isnetworkowner", "Error"
				end
			end
			return text, count > 0 and "Warning" or "Muted"
		end,
	})

	YetiBox:CreateStatus({
		Name = "Frozen Hearts",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			local hearts = YetiFarm.hearts()
			return tostring(hearts), hearts > 0 and "Success" or "Error"
		end,
	})

	YetiBox:CreateStatus({
		Name = "Heart Shop",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			local status = YetiFarm.BuyStatus
			if status == "Off" then
				return "Off", "Muted"
			end
			if YetiFarm.Bought > 0 then
				status ..= " (" .. YetiFarm.Bought .. " total)"
			end
			return status, (status:find("Bought") or status == "Stocked") and "Success" or "Warning"
		end,
	})

	YetiBox:CreateStatus({
		Name = "Kills",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return YetiFarm.Kills
		end,
	})

	local FishingBox = FishingPage:AddLeftGroupbox({ Name = "Fishing", Icon = "fish" })

	FishingBox:CreateToggle({
		Name = "Auto Fish",
		CurrentValue = false,
		Flag = "AutoFish",
		Callback = function(value)
			Settings.AutoFish = value
			Fishing.refresh()
		end,
	})

	FishingBox:CreateButton({
		Name = "Save Position",
		Callback = function()
			local point = Fishing.saveSpot()
			if point then
				Hub.Notify({ Title = "Fishing", Content = string.format("Fishing spot saved (%d, %d, %d)", math.floor(point.X), math.floor(point.Y), math.floor(point.Z)), Type = "Success", Icon = "fish", Duration = 4 })
			else
				Hub.Notify({ Title = "Fishing", Content = "No character to save a spot from", Type = "Warning", Icon = "fish", Duration = 4 })
			end
		end,
	})

	FishingBox:CreateButton({
		Name = "Teleport to Saved Position",
		Callback = function()
			if not Fishing.goToSpot() then
				Hub.Notify({ Title = "Fishing", Content = "Save a position first", Type = "Warning", Icon = "fish", Duration = 4 })
			end
		end,
	})

	FishingBox:CreateDropdown({
		Name = "Rod",
		Options = Fishing.RodOptions,
		CurrentOption = Settings.FishRod,
		MultipleOptions = false,
		AllowNone = false,
		Flag = "FishRod",
		Callback = function(option)
			local value = type(option) == "table" and option[1] or option
			Settings.FishRod = (value == "Best Owned" or table.find(Const.FISH_RODS, value)) and value or "Best Owned"
		end,
	})

	FishingBox:CreateDropdown({
		Name = "Bait",
		Options = Fishing.BaitOptions,
		CurrentOption = Settings.FishBait,
		MultipleOptions = false,
		AllowNone = false,
		Flag = "FishBait",
		Callback = function(option)
			local value = type(option) == "table" and option[1] or option
			Settings.FishBait = type(value) == "string" and value or "None"
		end,
	})

	FishingBox:CreateToggle({
		Name = "Freeze Position",
		CurrentValue = false,
		Flag = "FishFreeze",
		Callback = function(value)
			Settings.FishFreeze = value == true
			if not Settings.FishFreeze then
				Fishing.unpin()
			end
		end,
	})

	FishingBox:CreateToggle({
		Name = "Auto Buy Bait",
		CurrentValue = false,
		Flag = "AutoBuyBait",
		Callback = function(value)
			Settings.FishBuyBait = value == true
		end,
	})

	FishingBox:CreateToggle({
		Name = "Return to Position after buying Bait",
		CurrentValue = true,
		Flag = "ReturnAfterBait",
		Callback = function(value)
			Settings.FishReturnAfterBait = value ~= false
		end,
	})

	FishingBox:CreateDivider()

	FishingBox:CreateStatus({
		Name = "State",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			if not Fishing.Context then
				return "Off", "Muted"
			end
			local status = Fishing.Status
			if string.find(status, "^Error") or string.find(status, "^Cannot") or string.find(status, "^Lost") then
				return status, "Error"
			end
			return status, "Success"
		end,
	})

	FishingBox:CreateStatus({
		Name = "Caught",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return tostring(Fishing.Caught)
		end,
	})

	local PortalBox = MainFarm:AddRightGroupbox({ Name = "Ouwigahara", Icon = "castle" })

	PortalBox:CreateToggle({
		Name = "Auto Join Dungeon",
		CurrentValue = false,
		Flag = "AutoJoinDungeon",
		Callback = function(value)
			Settings.AutoJoinDungeon = value
			PortalJoin.refresh()
		end,
	})

	PortalBox:CreateSlider({
		Name = "Join Delay",
		Range = { 0, 60 },
		Increment = 1,
		Suffix = "s",
		CurrentValue = Settings.DungeonJoinDelay,
		Flag = "DungeonJoinDelay",
		Callback = function(value)
			Settings.DungeonJoinDelay = value
		end,
	})

	PortalBox:CreateStatus({
		Name = "State",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			local ctx = PortalJoin.Context
			if not ctx then
				return "Off", "Muted"
			end
			local status = ctx.Status
			if string.find(status, "^Error") or string.find(status, "locked") then
				return status, "Error"
			end
			return status, string.find(status, "retrying") and "Warning" or "Accent"
		end,
	})

	local CacheBox = CachePage:AddLeftGroupbox({ Name = "Cache Farm", Icon = "package" })

	CacheBox:CreateToggle({
		Name = "Auto Cache Farm",
		CurrentValue = false,
		Flag = "AutoCacheFarm",
		Callback = function(value)
			Settings.AutoCacheFarm = value
			CacheFarm.refresh()
		end,
	})

	CacheBox:CreateToggle({
		Name = "Instant Kill Cache Guards",
		CurrentValue = false,
		Flag = "CacheGuardKill",
		Callback = function(value)
			Settings.CacheGuardKill = value
		end,
	})

	CacheBox:CreateDropdown({
		Name = "Tiers (none = all)",
		Options = CacheFarm.Options,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "CacheTiers",
		Callback = function(options)
			Settings.CacheTiers = type(options) == "table" and options or {}
		end,
	})

	CacheBox:CreateDropdown({
		Name = "Priority",
		Options = Const.CACHE_PRIORITIES,
		CurrentOption = Settings.CachePriority,
		MultipleOptions = false,
		AllowNone = false,
		Flag = "CachePriority",
		Callback = function(option)
			Settings.CachePriority = type(option) == "table" and option[1] or option or "Nearest"
		end,
	})

	CacheBox:CreateSlider({
		Name = "Retry After Limit",
		Range = { 5, 180 },
		Increment = 5,
		Suffix = " min",
		CurrentValue = Settings.CacheRetry,
		Flag = "CacheRetry",
		Callback = function(value)
			Settings.CacheRetry = value
		end,
	})

	CacheBox:CreateSlider({
		Name = "Wait Before Next Chest",
		Range = { 0, 30 },
		Increment = 0.5,
		Suffix = " s",
		CurrentValue = Settings.CacheDelay,
		Flag = "CacheDelay",
		Callback = function(value)
			Settings.CacheDelay = value
		end,
	})

	CacheBox:CreateButton({
		Name = "Clear Limit Now",
		Callback = function()
			CacheFarm.clearLimit()
		end,
	})

	CacheBox:CreateDivider()

	CacheBox:CreateStatus({
		Name = "State",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			if not CacheFarm.Context then
				return "Off", "Muted"
			end
			local phase = CacheFarm.Phase
			if CacheFarm.Busy then
				return phase, "Success"
			end
			return phase, string.find(phase, "^Error") and "Error" or "Warning"
		end,
	})

	CacheBox:CreateStatus({
		Name = "Target",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local cache = CacheFarm.Target
			local root = Character.root()
			if not cache or not root then
				return nil
			end
			local distance = math.floor((CacheFarm.position(cache) - root.Position).Magnitude)
			local state = cache.State == "Spawned" and "unsealed" or cache.State == "Locked" and "sealed" or string.lower(tostring(cache.State))
			return string.format("%s, %s, %d studs", cache.Tier.Label, state, distance)
		end,
	})

	CacheBox:CreateStatus({
		Name = "Cache Limit",
		Style = "Row",
		Pin = true,
		UpdateRate = 1,
		Update = function()
			if not CacheFarm.CanDetect then
				return "Can't read game notices", "Error"
			end
			local left = CacheFarm.limitLeft()
			if left then
				return "Reached, retry in " .. WorldBoss.clock(left), "Warning"
			end
			return "Not reached", "Success"
		end,
	})

	CacheBox:CreateStatus({
		Name = "Sealed Caches Up",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return CacheFarm.counts()
		end,
	})

	CacheBox:CreateStatus({
		Name = "Opened",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			local parts = {}
			for _, tier in ipairs(CacheFarm.Tiers) do
				local count = CacheFarm.OpenedByTier[tier.Label]
				if count then
					table.insert(parts, "T" .. tier.Rank .. " " .. count)
				end
			end
			if #parts == 0 then
				return tostring(CacheFarm.Opened)
			end
			return CacheFarm.Opened .. " (" .. table.concat(parts, ", ") .. ")"
		end,
	})

	CacheBox:CreateStatus({
		Name = "Guards Killed",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return CacheFarm.GuardKills
		end,
	})

	CacheBox:CreateStatus({
		Name = "Guard Insta-Kills",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			if not Settings.CacheGuardKill then
				return "Off", "Muted"
			end
			if not InstantKill.supported() then
				return "Executor has no isnetworkowner", "Error"
			end
			if CacheFarm.GuardInstaKills == 0 then
				return "Hit a guard to take ownership", "Warning"
			end
			return tostring(CacheFarm.GuardInstaKills), "Success"
		end,
	})

	local SchematicBox = SchematicPage:AddLeftGroupbox({ Name = "Auto Schematics", Icon = "scroll" })

	SchematicBox:CreateToggle({
		Name = "Auto Schematics",
		CurrentValue = false,
		Flag = "AutoSchematics",
		Callback = function(value)
			Settings.AutoSchematics = value
			Schematics.refresh()
		end,
	})

	SchematicBox:CreateDropdown({
		Name = "Schematics (none = all)",
		Options = Schematics.Options,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "SchematicList",
		Callback = function(options)
			Settings.SchematicList = type(options) == "table" and options or {}
		end,
	})

	SchematicBox:CreateDropdown({
		Name = "Gauntlet Weapon Slot",
		Options = { "1", "2", "3", "4", "5" },
		CurrentOption = {},
		MultipleOptions = false,
		Flag = "GauntletSlot",
		Callback = function(option)
			Settings.GauntletSlot = type(option) == "table" and option[1] or option
			for _, entry in ipairs(Schematics.Entries) do
				if entry.Run == Schematics.runGauntlet then
					Schematics.Skip[entry] = nil
					Schematics.Notes[entry] = nil
				end
			end
		end,
	})

	SchematicBox:CreateToggle({
		Name = "Spend Wen (Shovel, Retsu 2,500)",
		CurrentValue = Settings.SchematicSpend,
		Flag = "SchematicSpend",
		Callback = function(value)
			Settings.SchematicSpend = value
		end,
	})

	SchematicBox:CreateToggle({
		Name = "Trade Lost Cape / Lost Outfit",
		CurrentValue = false,
		Flag = "SchematicTrades",
		Callback = function(value)
			Settings.SchematicTrades = value
		end,
	})

	SchematicBox:CreateButton({
		Name = "Retry Everything Now",
		Callback = Schematics.retry,
	})

	SchematicBox:CreateDivider()

	SchematicBox:CreateStatus({
		Name = "State",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			if not Schematics.Context then
				return "Off", "Muted"
			end
			local phase = Schematics.Phase
			if Schematics.Busy then
				return phase, "Success"
			end
			return phase, string.find(phase, "^Error") and "Error" or "Warning"
		end,
	})

	SchematicBox:CreateStatus({
		Name = "Working On",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local entry = Schematics.Current
			return entry and (entry.Series .. " " .. entry.Label) or nil
		end,
	})

	SchematicBox:CreateStatus({
		Name = "Owned",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			local owned, total = Schematics.count()
			return owned .. " / " .. total, owned == total and "Success" or nil
		end,
	})

	local SchematicListBox = SchematicPage:AddRightGroupbox({ Name = "Progress", Icon = "list-checks" })

	SchematicListBox:CreateStatusList({
		Name = "Picked schematics",
		MaxRows = 12,
		EmptyText = "nothing picked",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(Schematics.rows)
		end,
	})

	local CraftBox = CraftPage:AddLeftGroupbox({ Name = "Crafting", Icon = "hammer" })

	CraftBox:CreateToggle({
		Name = "Auto Craft",
		CurrentValue = false,
		Flag = "AutoCraft",
		Callback = function(value)
			Settings.AutoCraft = value
			Craft.refresh()
		end,
	})

	CraftBox:CreateDropdown({
		Name = "Select Recipes",
		Options = Craft.Options,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "CraftRecipes",
		Callback = function(options)
			Settings.CraftRecipes = type(options) == "table" and options or {}
			table.clear(Craft.Retry)
		end,
	})

	CraftBox:CreateDivider()

	CraftBox:CreateStatus({
		Name = "State",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			if not Craft.Context then
				return "Off", "Muted"
			end
			local phase = Craft.Phase
			if Craft.Busy then
				return phase, "Success"
			end
			return phase, (string.find(phase, "^Error") or string.find(phase, "refused")) and "Error" or "Warning"
		end,
	})

	CraftBox:CreateStatus({
		Name = "Crafted",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return tostring(Craft.Crafted)
		end,
	})

	local RefineBox = CraftPage:AddLeftGroupbox({ Name = "Refining", Icon = "sparkles" })

	RefineBox:CreateToggle({
		Name = "Auto Refine",
		CurrentValue = false,
		Flag = "AutoRefine",
		Callback = function(value)
			Settings.AutoRefine = value
			Craft.refresh()
		end,
	})

	RefineBox:CreateDropdown({
		Name = "Items (none = equipped)",
		Options = Craft.RefineOptions,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "RefineItems",
		Callback = function(options)
			Settings.RefineItems = type(options) == "table" and options or {}
			table.clear(Craft.RefineRetry)
		end,
	})

	RefineBox:CreateSlider({
		Name = "Target Level",
		Desc = "Stops refining an item once it reaches this level",
		Range = { 1, 10 },
		Increment = 1,
		CurrentValue = Settings.RefineTarget,
		Flag = "RefineTarget",
		Callback = function(value)
			Settings.RefineTarget = value
		end,
	})

	RefineBox:CreateToggle({
		Name = "Use Refinement Guards",
		CurrentValue = Settings.RefineGuard,
		Flag = "RefineGuard",
		Callback = function(value)
			Settings.RefineGuard = value
		end,
	})

	RefineBox:CreateSlider({
		Name = "Guard From Level",
		Desc = "Spends a guard at this level and up, so a fail keeps the level",
		Range = { 1, 9 },
		Increment = 1,
		CurrentValue = Settings.RefineGuardFrom,
		Flag = "RefineGuardFrom",
		Callback = function(value)
			Settings.RefineGuardFrom = value
		end,
	})

	RefineBox:CreateSlider({
		Name = "Keep Wen",
		Desc = "Never refine below this much Wen",
		Range = { 0, 5000000 },
		Increment = 50000,
		CurrentValue = Settings.RefineKeepWen,
		Flag = "RefineKeepWen",
		Callback = function(value)
			Settings.RefineKeepWen = value
		end,
	})

	RefineBox:CreateDivider()

	RefineBox:CreateStatus({
		Name = "Results",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return Craft.resultsText()
		end,
	})

	local MaterialBox = CraftPage:AddRightGroupbox({ Name = "Materials", Icon = "package" })

	MaterialBox:CreateStatusList({
		MaxRows = 14,
		EmptyText = "select a recipe to see its materials",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(Craft.rows)
		end,
	})

	local SellBox = SellTab:AddLeftGroupbox({ Name = "Auto Sell", Icon = "coins" })

	SellBox:CreateToggle({
		Name = "Auto Sell",
		CurrentValue = false,
		Flag = "AutoSell",
		Callback = function(value)
			Settings.AutoSell = value
			Seller.refresh()
		end,
	})

	SellBox:CreateDropdown({
		Name = "Sell Rarities",
		Options = Collector.RarityOptions,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "SellRarities",
		Callback = function(options)
			Settings.SellRarities = type(options) == "table" and options or {}
			Collector.setFilter(Seller.Rarities, Settings.SellRarities)
		end,
	})

	SellBox:CreateDropdown({
		Name = "Categories (none = gear only)",
		Options = Seller.CategoryOptions,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "SellCategories",
		Callback = function(options)
			Settings.SellCategories = type(options) == "table" and options or {}
			Collector.setFilter(Seller.Categories, Settings.SellCategories)
		end,
	})

	SellBox:CreateDropdown({
		Name = "Always Sell Items",
		Options = Seller.ItemOptions,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "SellItems",
		Callback = function(options)
			Settings.SellItems = type(options) == "table" and options or {}
			Collector.setFilter(Seller.Items, Settings.SellItems)
		end,
	})

	SellBox:CreateDropdown({
		Name = "Never Sell Items",
		Options = Seller.ItemOptions,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "SellNever",
		Callback = function(options)
			Settings.SellNever = type(options) == "table" and options or {}
			Collector.setFilter(Seller.Never, Settings.SellNever)
		end,
	})

	SellBox:CreateSlider({
		Name = "Keep At Least",
		Range = { 0, 10 },
		Increment = 1,
		CurrentValue = Settings.SellKeep,
		Flag = "SellKeep",
		Callback = function(value)
			Settings.SellKeep = value
		end,
	})

	SellBox:CreateSlider({
		Name = "Sell Every",
		Range = { 1, 60 },
		Increment = 1,
		Suffix = " min",
		CurrentValue = Settings.SellInterval,
		Flag = "SellInterval",
		Callback = function(value)
			Settings.SellInterval = value
			Seller.NextAt = math.min(Seller.NextAt, os.clock() + value * 60)
		end,
	})

	SellBox:CreateButton({
		Name = "Sell Now",
		Callback = function()
			if not Settings.AutoSell then
				Hub.Notify({ Title = "Auto Sell", Content = "Turn on Auto Sell first.", Type = "Warning", Icon = "coins", Duration = 4 })
				return
			end
			Seller.Force = true
		end,
	})

	SellBox:CreateDivider()

	SellBox:CreateStatus({
		Name = "State",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			if not Seller.Context then
				return "Off", "Muted"
			end
			local phase = Seller.Phase
			if Seller.Busy then
				return phase, "Success"
			end
			return phase, (string.find(phase, "^Error") or string.find(phase, "retrying")) and "Error" or "Warning"
		end,
	})

	SellBox:CreateStatus({
		Name = "Last Sale",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return Seller.Last or "None yet", Seller.Last and "Success" or "Muted"
		end,
	})

	SellBox:CreateStatus({
		Name = "Items Sold",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return tostring(Seller.Sold)
		end,
	})

	local SellListBox = SellTab:AddRightGroupbox({ Name = "Will Sell", Icon = "list-checks" })

	SellListBox:CreateStatusList({
		MaxRows = 14,
		EmptyText = "nothing matches your sell settings",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(Seller.rows)
		end,
	})

	local MarketBox = SellTab:AddLeftGroupbox({ Name = "Auto Buy Black Market", Icon = "shopping-cart" })

	MarketBox:CreateToggle({
		Name = "Auto Buy Black Market",
		CurrentValue = false,
		Flag = "AutoBuyMarket",
		Callback = function(value)
			Settings.AutoBuyMarket = value
			Market.refresh()
		end,
	})

	MarketBox:CreateDropdown({
		Name = "Buy Items",
		Options = Market.Options,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "MarketItems",
		Callback = function(options)
			Settings.MarketItems = type(options) == "table" and options or {}
			Collector.setFilter(Market.Items, Settings.MarketItems)
		end,
	})

	MarketBox:CreateDropdown({
		Name = "Buy Rarities",
		Options = Collector.RarityOptions,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "MarketRarities",
		Callback = function(options)
			Settings.MarketRarities = type(options) == "table" and options or {}
			Collector.setFilter(Market.Rarities, Settings.MarketRarities)
		end,
	})

	MarketBox:CreateToggle({
		Name = "Skip Owned Gear",
		CurrentValue = Settings.MarketSkipOwned,
		Flag = "MarketSkipOwned",
		Callback = function(value)
			Settings.MarketSkipOwned = value
		end,
	})

	MarketBox:CreateDivider()

	MarketBox:CreateStatus({
		Name = "State",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			if not Market.Context then
				return "Off", "Muted"
			end
			local phase = Market.Phase
			if Market.Busy then
				return phase, "Success"
			end
			return phase, string.find(phase, "retrying") and "Error" or "Warning"
		end,
	})

	MarketBox:CreateStatus({
		Name = "Next Wanted",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(Market.nextWanted)
		end,
	})

	MarketBox:CreateStatus({
		Name = "Last Buy",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return Market.Last or "None yet", Market.Last and "Success" or "Muted"
		end,
	})

	MarketBox:CreateStatus({
		Name = "Items Bought",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return tostring(Market.Bought)
		end,
	})

	local ForecastBox = SellTab:AddRightGroupbox({ Name = "Black Market Stock Forecast", Icon = "calendar-clock" })

	ForecastBox:CreateSlider({
		Name = "Visits Shown",
		Range = { 1, 12 },
		Increment = 1,
		CurrentValue = Settings.MarketForecast,
		Flag = "MarketForecast",
		Callback = function(value)
			Settings.MarketForecast = value
		end,
	})

	ForecastBox:CreateStatusList({
		MaxRows = 30,
		EmptyText = "forecast unavailable",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(Market.forecastRows)
		end,
	})

	local RefineListBox = CraftPage:AddRightGroupbox({ Name = "Refine Progress", Icon = "list-checks" })

	RefineListBox:CreateStatusList({
		MaxRows = 12,
		EmptyText = "no refinable items picked or equipped",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(Craft.refineRows)
		end,
	})

	local PowerStatueBox = MainFarm:AddRightGroupbox({ Name = "Power Statue", Icon = "swords" })

	PowerStatueBox:CreateToggle({
		Name = "Auto Attack Power Statue",
		CurrentValue = false,
		Flag = "AutoPowerStatue",
		Callback = function(value)
			Settings.AutoPowerStatue = value
			PowerStatue.refresh()
		end,
	})

	PowerStatueBox:CreateDropdown({
		Name = "Weapon Slot",
		Options = { "Current", "1", "2", "3", "4", "5" },
		CurrentOption = Settings.PowerStatueSlot,
		MultipleOptions = false,
		AllowNone = false,
		Flag = "PowerStatueSlot",
		Callback = function(option)
			local value = type(option) == "table" and option[1] or option
			Settings.PowerStatueSlot = value or "Current"
		end,
	})

	PowerStatueBox:CreateStatus({
		Name = "State",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			if not PowerStatue.Context then
				return "Off", "Muted"
			end
			return PowerStatue.Status, PowerStatue.Target and "Success" or "Warning"
		end,
	})

	local TrainingBox = MainFarm:AddRightGroupbox({ Name = "Auto Training", Icon = "dumbbell" })

	TrainingBox:CreateToggle({
		Name = "Auto Training",
		CurrentValue = false,
		Flag = "AutoTraining",
		Callback = function(value)
			Settings.AutoTraining = value
			Training.refresh()
		end,
	})

	TrainingBox:CreateDropdown({
		Name = "Trainings",
		Options = Const.TRAINING_NAMES,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "TrainingList",
		Callback = function(options)
			Settings.TrainingList = type(options) == "table" and options or {}
		end,
	})

	TrainingBox:CreateDropdown({
		Name = "How To Play Them",
		Options = { "Instantly", "Play It Out" },
		CurrentOption = Settings.TrainingMode,
		MultipleOptions = false,
		AllowNone = false,
		Flag = "TrainingMode",
		Callback = function(option)
			local value = type(option) == "table" and option[1] or option
			Settings.TrainingMode = value == "Play It Out" and "Play It Out" or "Instantly"
		end,
	})

	TrainingBox:CreateDivider()

	TrainingBox:CreateStatus({
		Name = "State",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			if not Training.Context then
				return "Off", "Muted"
			end
			return Training.Status, Training.Busy and "Success" or "Warning"
		end,
	})

	TrainingBox:CreateStatus({
		Name = "Finished",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return tostring(Training.Finished)
		end,
	})

	local SessionBox = BossPage:AddRightGroupbox({ Name = "Session", Icon = "chart-bar" })

	SessionBox:CreateStatus({
		Name = "Kills",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return BossStats.Kills
		end,
	})

	SessionBox:CreateStatus({
		Name = "Kills / Hour",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return BossStats.perHour(BossStats.Kills)
		end,
	})

	SessionBox:CreateStatus({
		Name = "Boss Kills",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return BossStats.BossKills
		end,
	})

	SessionBox:CreateStatus({
		Name = "Last Boss Kill",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return BossStats.LastBoss or "None"
		end,
	})

	SessionBox:CreateStatus({
		Name = "Coin Pouch Gained",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return BossStats.Pouches
		end,
	})

	SessionBox:CreateStatus({
		Name = "Coin Pouch / Hour",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return BossStats.perHour(BossStats.Pouches)
		end,
	})

	SessionBox:CreateStatus({
		Name = "Coin Pouch Owned",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return Game.itemCount(Const.COIN_POUCH)
		end,
	})

	SessionBox:CreateStatus({
		Name = "Ore Gained",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return BossStats.Ores
		end,
	})

	SessionBox:CreateStatus({
		Name = "Ore / Hour",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return BossStats.perHour(BossStats.Ores)
		end,
	})

	SessionBox:CreateStatus({
		Name = "Ore Owned",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return Game.oreCount()
		end,
	})

	SessionBox:CreateStatus({
		Name = "Currently Farming",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			return (BossStats.activity())
		end,
	})

	SessionBox:CreateStatus({
		Name = "Currently Doing",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local _, doing = BossStats.activity()
			return doing
		end,
	})

	SessionBox:CreateStatus({
		Name = "Target",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			local target = Combat.BossTarget or Combat.FarmTarget
			if Mobs.isAlive(target) then
				return target.Name
			end
			return "None"
		end,
	})

	local TimerBox = BossPage:AddRightGroupbox({ Name = "Timers", Icon = "timer" })

	TimerBox:CreateStatusList({
		Name = "Selected bosses (all when none)",
		MaxRows = 6,
		EmptyText = "no world bosses found",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(BossFarm.timerRows)
		end,
	})

	TimerBox:CreateStatus({
		Name = "Time",
		UpdateRate = 1,
		Update = function()
			local phase = Game.DayNight.IsNight() and "Night, day in " or "Day, night in "
			return phase .. WorldBoss.clock(Game.DayNight.SecondsUntilPhaseChange())
		end,
	})

	local HuntBox = MainFarm:AddRightGroupbox({ Name = "Muzan/Crow", Icon = "target" })

	HuntBox:CreateToggle({
		Name = "Auto Muzan/Crow",
		CurrentValue = false,
		Flag = "BossHunt",
		Callback = function(value)
			Settings.BossHunt = value
			BossHunt.refresh()
		end,
	})

	HuntBox:CreateDropdown({
		Name = "Tiers (none = all, highest first)",
		Options = BossHunt.Options,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "HuntTiers",
		Callback = function(options)
			Settings.HuntTiers = type(options) == "table" and options or {}
		end,
	})

	HuntBox:CreateSlider({
		Name = "Wait Before Next Boss",
		Range = { 0, 120 },
		Increment = 1,
		Suffix = "s",
		CurrentValue = Settings.HuntNextDelay,
		Flag = "HuntNextDelay",
		Callback = function(value)
			Settings.HuntNextDelay = value
		end,
	})

	HuntBox:CreateDivider()

	HuntBox:CreateStatus({
		Name = "State",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = function()
			if not BossHunt.Context then
				return "Off", "Muted"
			end
			return BossHunt.Phase, BossFarm.tone(BossHunt.Phase) or (BossHunt.Phase == "Claiming" and "Accent") or "Muted"
		end,
	})

	HuntBox:CreateStatus({
		Name = "Hunt",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(BossHunt.huntText)
		end,
	})

	HuntBox:CreateStatus({
		Name = "Finished",
		Style = "Row",
		UpdateRate = 1,
		Update = function()
			return BossHunt.Finished
		end,
	})

	HuntBox:CreateStatusList({
		Name = "Open hunts for you",
		MaxRows = 6,
		EmptyText = "no open hunts",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(BossHunt.boardRows)
		end,
	})

	function Priority.flagFor(job)
		if job.Flag then
			return job.Flag
		end
		if Settings.LevelUp then
			return "LevelUp"
		end
		return (Settings.AutoQuest or Settings.Quest) and "AutoQuest" or "LevelUp"
	end

	function Priority.applyBegin()
		Priority.BeginQueued = false
		local slotted = {}
		for index = 1, #Const.PRIORITY_JOBS do
			local key = Priority.ByLabel[Settings.PriorityOrder[index]]
			if key then
				slotted[key] = true
			end
		end
		for key, flag in pairs(Priority.Started) do
			if not Settings.PriorityBegin or not slotted[key] then
				Priority.Started[key] = nil
				if flag:Get() then
					flag:Set(false)
				end
			end
		end
		if not Settings.PriorityBegin then
			return
		end
		for index = 1, #Const.PRIORITY_JOBS do
			local key = Priority.ByLabel[Settings.PriorityOrder[index]]
			if key and not Priority.Started[key] then
				local flag = Airflow.Flags[Priority.flagFor(Priority.Job[key])]
				if flag and not flag:Get() then
					flag:Set(true)
					Priority.Started[key] = flag
				end
			end
		end
	end

	function Priority.queueBegin()
		if not Priority.BeginQueued then
			Priority.BeginQueued = true
			task.defer(Priority.applyBegin)
		end
	end

	function Priority.assign(index, label)
		local previous = Settings.PriorityOrder[index]
		if label == previous then
			return
		end
		if label then
			for other = 1, #Const.PRIORITY_JOBS do
				if other ~= index and Settings.PriorityOrder[other] == label then
					Settings.PriorityOrder[other] = previous
					local slot = Priority.Slots[other]
					if slot then
						slot:Set(previous or Const.PRIORITY_NONE, true)
					end
					break
				end
			end
		end
		Settings.PriorityOrder[index] = label
		Priority.rebuild()
		if Settings.PriorityBegin then
			Priority.queueBegin()
		end
	end
end

local CombatTab = Window:CreateTab({ Name = "Combat", Desc = "Attacking, skills, positioning and survival", Icon = "sword" })

local OffensePage = CombatTab:CreateSubTab({ Name = "Offense", Icon = "sword" })
local TacticsPage = CombatTab:CreateSubTab({ Name = "Tactics", Icon = "compass" })

local AttackBox = OffensePage:AddLeftGroupbox({ Name = "Attack", Icon = "sword" })

AttackBox:CreateToggle({
	Name = "Kill Aura",
	CurrentValue = false,
	Flag = "KillAura",
	Callback = function(value)
		Settings.KillAura = value
	end,
})

AttackBox:CreateToggle({
	Name = "Auto M1",
	CurrentValue = Settings.AutoM1,
	Flag = "AutoM1",
	Callback = function(value)
		Settings.AutoM1 = value
	end,
})

AttackBox:CreateDropdown({
	Name = "M1 Weapon Slot",
	Options = { "Current", "1", "2", "3", "4", "5" },
	CurrentOption = "Current",
	MultipleOptions = false,
	AllowNone = false,
	Flag = "WeaponSlot",
	Callback = function(option)
		Settings.WeaponSlot = option or "Current"
	end,
})

AttackBox:CreateDivider()

AttackBox:CreateToggle({
	Name = "Instant Kill",
	CurrentValue = false,
	Flag = "InstantKill",
	Callback = function(value)
		Settings.InstantKill = value
	end,
})

AttackBox:CreateSlider({
	Name = "Kill At HP",
	Range = { 0, 100 },
	Increment = 1,
	Suffix = "%",
	CurrentValue = Settings.KillAtHp,
	Flag = "KillAtHp",
	Callback = function(value)
		Settings.KillAtHp = value
	end,
})

AttackBox:CreateStatus({
	Name = "Instant Kill",
	Style = "Row",
	UpdateRate = 0.5,
	Update = InstantKill.statusText,
})

AttackBox:CreateDivider()

AttackBox:CreateToggle({
	Name = "Break Mob Pathing",
	CurrentValue = false,
	Flag = "BreakPathing",
	Callback = function(value)
		Settings.BreakPathing = value
	end,
})

AttackBox:CreateStatus({
	Name = "Pathing",
	Style = "Row",
	UpdateRate = 0.5,
	Update = MobPin.statusText,
})

local AimBox = OffensePage:AddLeftGroupbox({ Name = "Aim Assist", Icon = "crosshair" })

AimBox:CreateToggle({
	Name = "Aim Assist (PC)",
	CurrentValue = false,
	Flag = "AimAssist",
	Callback = function(value)
		Settings.AimAssist = value
	end,
})

AimBox:CreateDropdown({
	Name = "Aim At",
	Options = { "Mobs", "Bosses", "Players" },
	CurrentOption = Settings.AimTargets,
	MultipleOptions = true,
	Flag = "AimTargets",
	Callback = function(options)
		Settings.AimTargets = type(options) == "table" and options or {}
	end,
})

AimBox:CreateSlider({
	Name = "Aim Circle Size",
	Range = { 30, 600 },
	Increment = 10,
	Suffix = " px",
	CurrentValue = Settings.AimFov,
	Flag = "AimFov",
	Callback = function(value)
		Settings.AimFov = value
	end,
})

AimBox:CreateSlider({
	Name = "Max Range",
	Range = { 20, 500 },
	Increment = 10,
	Suffix = " studs",
	CurrentValue = Settings.AimRange,
	Flag = "AimRange",
	Callback = function(value)
		Settings.AimRange = value
	end,
})

AimBox:CreateToggle({
	Name = "Show Aim Circle",
	CurrentValue = Settings.AimShowFov,
	Flag = "AimShowFov",
	Callback = function(value)
		Settings.AimShowFov = value
	end,
})

AimBox:CreateStatus({
	Name = "Aim",
	Style = "Row",
	UpdateRate = 0.25,
	Update = AimAssist.statusText,
})

local SkillBox = OffensePage:AddRightGroupbox({ Name = "Skills", Icon = "zap" })

local SkillUi = { Holds = {}, Clan = nil, ClanKey = nil }

local function chargedSlots()
	local shown = {}
	if Settings.HoldSkills then
		local list = Skills.hotbar()
		for slot = 1, #Const.SKILL_INPUTS do
			local entry = list[slot]
			shown[slot] = Settings.SkillSlots[slot] == true and Skills.usable(entry) and Skills.maxHold(entry) > 0
		end
	end
	return shown
end

local function skillHoldText(slot, entry)
	local maxHold = Skills.maxHold(entry)
	if maxHold <= 0 then
		return nil
	end
	if not Settings.HoldSkills then
		return string.format("tap, holds up to %.1fs", maxHold)
	end
	local wanted = Settings.SkillHolds[slot] or Const.SKILL_HOLD_DEFAULT
	local hold = Skills.holdTime(slot, entry)
	if hold <= 0 then
		return string.format("tap, holds up to %.1fs", maxHold)
	end
	return string.format("hold %.1f / %.1fs%s", hold, maxHold, wanted > maxHold and " (capped)" or "")
end

local function skillStateText(entry)
	if Skills.Casting == entry.Name then
		return "Casting", "Accent"
	end
	local ready, reason, left = Skills.state(entry)
	if ready then
		return "Ready", "Success"
	end
	if reason == "cooldown" then
		return left and string.format("%ds cooldown", math.ceil(left)) or "On cooldown", "Muted"
	end
	if reason == "stamina" then
		local info = Game.SkillInfo[entry.Name]
		local ok, cost = pcall(Skills.staminaCost, entry.Name, info)
		return ok and string.format("Needs %d stamina", math.ceil(cost)) or "Low stamina", "Warning"
	end
	if reason == "retrying" then
		return "Retrying soon", "Warning"
	end
	if reason == "requirements" then
		return "Locked", "Error"
	end
	if reason == "loadout" then
		return "Not in loadout", "Error"
	end
	return reason and (string.upper(string.sub(reason, 1, 1)) .. string.sub(reason, 2)) or "Unavailable", "Warning"
end

local function skillRows()
	local rows = {}
	local list = Skills.hotbar()
	for slot, key in ipairs(Const.SKILL_KEYS) do
		local entry = list[slot]
		if Skills.usable(entry) then
			local value, tone
			if Settings.SkillSlots[slot] == true then
				value, tone = skillStateText(entry)
				local hold = skillHoldText(slot, entry)
				if hold then
					value ..= " · " .. hold
				end
			else
				value, tone = "Not picked", "Muted"
			end
			table.insert(rows, { Text = key .. "  " .. entry.Name, Value = value, Tone = tone })
		end
	end
	return rows
end

local function refreshClanSkills()
	if not SkillUi.Clan then
		return
	end
	local names = Game.isolated(Skills.clanNames)
	if type(names) ~= "table" then
		return
	end
	if #names == 0 then
		return
	end
	local key = table.concat(names, "|")
	if key ~= SkillUi.ClanKey then
		SkillUi.ClanKey = key
		SkillUi.Clan:Refresh(names, true, true)
		Settings.ClanSkillPicks = SkillUi.Clan:Get()
	end
end

local function refreshSkillControls()
	refreshClanSkills()
	local shown = Game.isolated(chargedSlots)
	if not shown then
		return
	end
	for slot, slider in pairs(SkillUi.Holds) do
		slider:SetVisible(shown[slot] == true)
	end
end

SkillBox:CreateToggle({
	Name = "Smart Auto Skill",
	CurrentValue = Settings.AutoSkill,
	Flag = "AutoSkill",
	Callback = function(value)
		Settings.AutoSkill = value
	end,
})

SkillBox:CreateToggle({
	Name = "Full M1 Combo Before Skills",
	CurrentValue = Settings.FullCombo,
	Flag = "FullComboFirst",
	Callback = function(value)
		Settings.FullCombo = value
		Skills.WindowClosedAt = os.clock()
	end,
})

SkillBox:CreateToggle({
	Name = "Auto Clan Skills",
	CurrentValue = false,
	Flag = "AutoClanSkills",
	Callback = function(value)
		Settings.AutoClanSkills = value
	end,
})

SkillUi.Clan = SkillBox:CreateDropdown({
	Name = "Clan Skills (none = all)",
	Options = {},
	CurrentOption = {},
	MultipleOptions = true,
	EmptyText = "No clan skills",
	Flag = "ClanSkillPicks",
	Callback = function(options)
		if SkillUi.ClanKey then
			Settings.ClanSkillPicks = type(options) == "table" and options or {}
		end
	end,
})

SkillBox:CreateDropdown({
	Name = "Skills",
	Options = Const.SKILL_KEYS,
	CurrentOption = { "Z", "X", "C", "V", "B", "N", "K", "L", "J" },
	MultipleOptions = true,
	Flag = "SkillKeys",
	Callback = function(options)
		local slots = {}
		for _, key in ipairs(type(options) == "table" and options or {}) do
			local slot = table.find(Const.SKILL_KEYS, key)
			if slot then
				slots[slot] = true
			end
		end
		Settings.SkillSlots = slots
		refreshSkillControls()
	end,
})

SkillBox:CreateToggle({
	Name = "Hold Skills",
	CurrentValue = false,
	Flag = "HoldSkills",
	Callback = function(value)
		Settings.HoldSkills = value
		refreshSkillControls()
	end,
})

for slot, key in ipairs(Const.SKILL_KEYS) do
	SkillUi.Holds[slot] = SkillBox:CreateSlider({
		Name = key .. " Hold",
		Range = { 0, Const.SKILL_HOLD_MAX },
		Increment = 0.1,
		Suffix = "s",
		CurrentValue = Const.SKILL_HOLD_DEFAULT,
		Visible = false,
		Flag = "SkillHold" .. key,
		Callback = function(value)
			Settings.SkillHolds[slot] = value
		end,
	})
end

SkillBox:CreateStatusList({
	Name = "Skill Bar",
	MaxRows = #Const.SKILL_KEYS,
	EmptyText = "no skills on the hotbar",
	UpdateRate = 0.5,
	Update = function()
		return Game.isolated(skillRows)
	end,
})

SkillBox:CreateStatus({
	Name = "Auto Skill",
	Style = "Row",
	Pin = true,
	UpdateRate = 0.25,
	Update = function()
		local text = Skills.Status
		return text, statusTone(text)
	end,
})

refreshSkillControls()

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		task.wait(0.5)
		local ok, err = pcall(refreshSkillControls)
		if not ok then
			warn("[Spryzen Hub] skill controls refresh error: " .. tostring(err))
		end
	end
end))

local MovementBox = TacticsPage:AddLeftGroupbox({ Name = "Movement", Icon = "move" })

local HorseUi = {}

local function refreshHorseUi()
	for _, element in ipairs(HorseUi) do
		element:SetVisible(Settings.MovementType == "Horse")
	end
end

local TravelTypeUi = MovementBox:CreateDropdown({
	Name = "Movement Type",
	Options = { "Current", "Horse" },
	CurrentOption = Settings.MovementType,
	MultipleOptions = false,
	AllowNone = false,
	Flag = "TravelType",
	Callback = function(option)
		Settings.MovementType = option == "Horse" and "Horse" or "Current"
		refreshHorseUi()
	end,
})

table.insert(HorseUi, MovementBox:CreateDropdown({
	Name = "Horse Slot",
	Options = { "Auto", "Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5" },
	CurrentOption = Settings.HorseSlot,
	MultipleOptions = false,
	AllowNone = false,
	Flag = "HorseSlot",
	Callback = function(option)
		Settings.HorseSlot = option or "Auto"
	end,
}))

table.insert(HorseUi, MovementBox:CreateSlider({
	Name = "Dismount Delay",
	Range = { 0, 5 },
	Increment = 0.5,
	Suffix = "s",
	CurrentValue = Settings.DismountDelay,
	Flag = "DismountDelay",
	Callback = function(value)
		Settings.DismountDelay = value
	end,
}))

table.insert(HorseUi, MovementBox:CreateSlider({
	Name = "Horse Speed",
	Range = { 20, 65 },
	Increment = 1,
	Suffix = " studs/s",
	CurrentValue = Settings.HorseSpeed,
	Flag = "HorseSpeed",
	Callback = function(value)
		Settings.HorseSpeed = value
	end,
}))

table.insert(HorseUi, MovementBox:CreateStatus({
	Name = "Horse",
	Style = "Row",
	UpdateRate = 0.25,
	Update = function()
		local text, tone = Game.isolated(Journey.text)
		return text or "Unknown", tone or "Muted"
	end,
}))

refreshHorseUi()

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, value = pcall(TravelTypeUi.Get, TravelTypeUi)
		if ok then
			value = type(value) == "table" and value[1] or value
			Settings.MovementType = value == "Horse" and "Horse" or "Current"
		end
		refreshHorseUi()
		task.wait(1)
	end
end))

MovementBox:CreateToggle({
	Name = "Reset on Snapback",
	CurrentValue = Settings.ResetOnSnapback,
	Flag = "ResetOnSnapback",
	Callback = function(value)
		Settings.ResetOnSnapback = value
	end,
})

MovementBox:CreateDropdown({
	Name = "Farm Position",
	Options = { "Below", "Above", "In Front", "Behind" },
	CurrentOption = Settings.FarmPosition,
	MultipleOptions = false,
	AllowNone = false,
	Flag = "FarmSpot",
	Callback = function(option)
		Settings.FarmPosition = (option == "In Front" or option == "Behind" or option == "Above") and option or "Below"
	end,
})

MovementBox:CreateSlider({
	Name = "Distance",
	Range = { 0, 15 },
	Increment = 0.5,
	Suffix = " studs",
	CurrentValue = Settings.Distance,
	Flag = "Distance",
	Callback = function(value)
		Settings.Distance = value
	end,
})

MovementBox:CreateStatus({
	Name = "Travel",
	Style = "Row",
	UpdateRate = 0.25,
	Update = function()
		if os.clock() - Mover.SnapbackAt < Const.SNAPBACK_SHOW then
			return string.format("Snapback (%d)%s", Mover.Snapbacks, Mover.ResetAt == Mover.SnapbackAt and ", resetting" or ""), "Error"
		elseif Mover.traveling() then
			return "Travelling", "Warning"
		end
		return "Idle", "Muted"
	end,
})

local EscapeBox = TacticsPage:AddLeftGroupbox({ Name = "Retreat", Icon = "shield-alert" })

local function escapeToggle(name, key)
	EscapeBox:CreateToggle({
		Name = name,
		CurrentValue = Settings[key],
		Flag = key,
		Callback = function(value)
			Settings[key] = value
		end,
	})
end

local function escapeSlider(name, key, range, increment, suffix)
	EscapeBox:CreateSlider({
		Name = name,
		Range = range,
		Increment = increment,
		Suffix = suffix,
		CurrentValue = Settings[key],
		Flag = key,
		Callback = function(value)
			Settings[key] = value
		end,
	})
end

escapeToggle("Auto Retreat", "AutoEscape")
EscapeBox:CreateDivider()
escapeToggle("When Stunned", "EscapeStun")
escapeToggle("When Knocked Down", "EscapeRagdoll")
escapeToggle("When Low HP", "EscapeLowHp")
escapeSlider("Low HP", "EscapeHpBelow", { 5, 90 }, 1, "%")
escapeSlider("Come Back At HP", "EscapeHpBack", { 10, 100 }, 1, "%")
escapeToggle("When Surrounded", "EscapeCrowd")
escapeSlider("Enemies Around Me", "EscapeCrowdSize", { 2, 10 }, 1, " mobs")
EscapeBox:CreateDivider()

EscapeBox:CreateDropdown({
	Name = "Retreat Direction",
	Options = { "Up", "Back" },
	CurrentOption = Settings.EscapeDirection,
	MultipleOptions = false,
	AllowNone = false,
	Flag = "EscapeDirection",
	Callback = function(option)
		option = type(option) == "table" and option[1] or option
		Settings.EscapeDirection = option == "Back" and "Back" or "Up"
	end,
})

escapeSlider("Retreat Distance", "EscapeDistance", { 20, 300 }, 5, " studs")
escapeSlider("Stay Away At Least", "EscapeStay", { 0.5, 15 }, 0.5, "s")
escapeSlider("Cooldown", "EscapeCooldown", { 0, 30 }, 1, "s")

EscapeBox:CreateStatus({
	Name = "Retreat",
	Style = "Row",
	UpdateRate = 0.25,
	Update = function()
		local text = Escape.Status
		if text == "Off" then
			return text, "Muted"
		elseif Escape.Active then
			return text, "Warning"
		elseif text == "Watching" then
			return text, "Success"
		end
		return text, "Muted"
	end,
})

EscapeBox:CreateStatus({
	Name = "Retreats",
	Style = "Row",
	UpdateRate = 1,
	Update = function()
		if not Settings.AutoEscape and Escape.Count == 0 then
			return nil
		end
		return tostring(Escape.Count)
	end,
})

local DodgeBox = TacticsPage:AddLeftGroupbox({ Name = "Dodge Ults", Icon = "wind" })

DodgeBox:CreateToggle({
	Name = "Auto Dodge Ults (Beta)",
	CurrentValue = Settings.AutoDodgeUlt,
	Flag = "AutoDodgeUlt",
	Callback = function(value)
		Settings.AutoDodgeUlt = value
	end,
})

DodgeBox:CreateSlider({
	Name = "Extra Distance",
	Range = { 2, 40 },
	Increment = 1,
	Suffix = " studs",
	CurrentValue = Settings.UltDodgeDistance,
	Flag = "UltDodgeDistance",
	Callback = function(value)
		Settings.UltDodgeDistance = value
	end,
})

DodgeBox:CreateSlider({
	Name = "Go Back After",
	Range = { 0, 3 },
	Increment = 0.1,
	Suffix = "s",
	CurrentValue = Settings.UltReturnDelay,
	Flag = "UltReturnDelay",
	Callback = function(value)
		Settings.UltReturnDelay = value
	end,
})

DodgeBox:CreateStatus({
	Name = "Dodge",
	Style = "Row",
	UpdateRate = 0.25,
	Update = function()
		local text = Dodge.Status
		if Dodge.Active or Dodge.Returning then
			return text, "Warning"
		elseif text == "Watching" then
			return text, "Success"
		end
		return text, "Muted"
	end,
})

DodgeBox:CreateStatus({
	Name = "Ults Dodged",
	Style = "Row",
	UpdateRate = 1,
	Update = function()
		if not Settings.AutoDodgeUlt and Dodge.Count == 0 then
			return nil
		end
		return tostring(Dodge.Count)
	end,
})

local ProtectionBox = OffensePage:AddRightGroupbox({ Name = "Protection", Icon = "shield" })

ProtectionBox:CreateToggle({
	Name = "Anti Air Combo",
	CurrentValue = false,
	Flag = "AntiAirCombo",
	Callback = function(value)
		Settings.AntiAirCombo = value
	end,
})

ProtectionBox:CreateToggle({
	Name = "No Attack Slowdown",
	CurrentValue = false,
	Flag = "NoAttackSlowdown",
	Callback = function(value)
		Settings.NoAttackSlowdown = value
		Guard.applySlowdown()
	end,
})

ProtectionBox:CreateToggle({
	Name = "Anti Ragdoll",
	CurrentValue = false,
	Flag = "AntiRagdoll",
	Callback = function(value)
		Settings.AntiRagdoll = value
	end,
})

ProtectionBox:CreateToggle({
	Name = "Anti Knockback",
	CurrentValue = false,
	Flag = "AntiKnockback",
	Callback = function(value)
		Settings.AntiKnockback = value
	end,
})

ProtectionBox:CreateToggle({
	Name = "No Sun Damage",
	CurrentValue = false,
	Flag = "NoSunDamage",
	Callback = function(value)
		Settings.NoSunDamage = value
		Gear.poke()
	end,
})

local DefenseBox = TacticsPage:AddRightGroupbox({ Name = "Parry & Block", Icon = "shield-half" })

DefenseBox:CreateToggle({
	Name = "Auto Parry",
	CurrentValue = false,
	Flag = "AutoParry",
	Callback = function(value)
		Settings.AutoParry = value
		Defense.refresh()
	end,
})

DefenseBox:CreateToggle({
	Name = "Parry Players",
	CurrentValue = false,
	Flag = "ParryPlayers",
	Callback = function(value)
		Settings.ParryPlayers = value
		Defense.unwatchAll()
	end,
})

DefenseBox:CreateSlider({
	Name = "Watch Radius",
	Range = { 10, 80 },
	Increment = 5,
	Suffix = " studs",
	CurrentValue = Settings.ParryRadius,
	Flag = "ParryRadius",
	Callback = function(value)
		Settings.ParryRadius = value
	end,
})

DefenseBox:CreateToggle({
	Name = "Auto Block Combos",
	CurrentValue = false,
	Flag = "AutoBlock",
	Callback = function(value)
		Settings.AutoBlock = value
		Defense.refresh()
	end,
})

DefenseBox:CreateSlider({
	Name = "Block After Hits",
	Range = { 1, 5 },
	Increment = 1,
	CurrentValue = Settings.BlockAfterHits,
	Flag = "BlockAfterHits",
	Callback = function(value)
		Settings.BlockAfterHits = value
	end,
})

DefenseBox:CreateDivider()

DefenseBox:CreateStatus({
	Name = "Parry",
	Style = "Row",
	Pin = true,
	UpdateRate = 0.25,
	Update = function()
		if not Settings.AutoParry then
			return "Off", "Muted"
		end
		local watching = 0
		for _ in pairs(Defense.Watched) do
			watching += 1
		end
		local text = Defense.text("ParryStatus", nil)
		if text then
			return text, string.find(text, "^Parried") and "Success" or "Warning"
		end
		return string.format("Watching %d %s", watching, watching == 1 and "enemy" or "enemies"), "Accent"
	end,
})

DefenseBox:CreateStatus({
	Name = "Block",
	Style = "Row",
	UpdateRate = 0.25,
	Update = function()
		if not Settings.AutoBlock then
			return "Off", "Muted"
		end
		local holding = Defense.Holding
		if holding and holding.Kind == "Block" then
			return "Blocking a combo", "Success"
		end
		local text = Defense.text("BlockStatus", nil)
		if text then
			return text, "Warning"
		end
		local points = Defense.points(Defense.values())
		return points and string.format("Watching, %d block points", points) or "Watching", "Accent"
	end,
})

DefenseBox:CreateStatus({
	Name = "Session",
	Style = "Row",
	UpdateRate = 1,
	Update = function()
		return string.format("%d parries, %d perfect windows, %d combo blocks", Defense.Parries, Defense.PerfectWindows, Defense.Blocks)
	end,
})

local SurvivalBox = TacticsPage:AddRightGroupbox({ Name = "Survival", Icon = "heart" })

SurvivalBox:CreateToggle({
	Name = "Retreat To Heal",
	CurrentValue = false,
	Flag = "RetreatHeal",
	Callback = function(value)
		Settings.RetreatHeal = value
	end,
})

SurvivalBox:CreateSlider({
	Name = "Retreat Below HP",
	Range = { 5, 95 },
	Increment = 1,
	Suffix = "%",
	CurrentValue = Settings.RetreatBelow,
	Flag = "RetreatBelow",
	Callback = function(value)
		Settings.RetreatBelow = value
	end,
})

SurvivalBox:CreateSlider({
	Name = "Back To Fight At HP",
	Range = { 10, 100 },
	Increment = 1,
	Suffix = "%",
	CurrentValue = Settings.BackAt,
	Flag = "BackAt",
	Callback = function(value)
		Settings.BackAt = value
	end,
})

SurvivalBox:CreateToggle({
	Name = "Auto HP Potion",
	CurrentValue = false,
	Flag = "AutoPotion",
	Callback = function(value)
		Settings.AutoPotion = value
	end,
})

SurvivalBox:CreateSlider({
	Name = "Drink Below HP",
	Range = { 5, 95 },
	Increment = 1,
	Suffix = "%",
	CurrentValue = Settings.DrinkBelow,
	Flag = "DrinkBelow",
	Callback = function(value)
		Settings.DrinkBelow = value
	end,
})

do
	local defaults = {}
	for _, name in ipairs({ "Health Elixir", "Health Potion" }) do
		if table.find(Potion.Options, name) then
			table.insert(defaults, name)
		end
	end
	Settings.Potions = table.clone(defaults)
	SurvivalBox:CreateDropdown({
		Name = "Potions",
		Options = Potion.Options,
		CurrentOption = defaults,
		MultipleOptions = true,
		Flag = "Potions",
		Callback = function(options)
			Settings.Potions = type(options) == "table" and options or {}
		end,
	})
end

SurvivalBox:CreateDropdown({
	Name = "Potion Slot",
	Options = { "1", "2", "3", "4", "5" },
	CurrentOption = tostring(Settings.PotionSlot),
	MultipleOptions = false,
	AllowNone = false,
	Flag = "PotionSlot",
	Callback = function(option)
		Settings.PotionSlot = tonumber(option) or 5
	end,
})

SurvivalBox:CreateToggle({
	Name = "Drink in Safety",
	CurrentValue = Settings.PotionSafety,
	Flag = "PotionSafety",
	Callback = function(value)
		Settings.PotionSafety = value
	end,
})

SurvivalBox:CreateStatus({
	Name = "Survival",
	Style = "Row",
	UpdateRate = 0.25,
	Update = function()
		if Potion.Busy then
			return Potion.Status, "Accent"
		end
		if Heal.Retreating then
			return Heal.Status, "Warning"
		end
		if not Settings.RetreatHeal and not Settings.AutoPotion then
			return "Off", "Muted"
		end
		local text = Settings.AutoPotion and Potion.Status or Heal.Status
		return text, text == "Watching health" and "Success" or "Warning"
	end,
})

if not Hub.InMinigame then
	local PriorityTab = Window:CreateTab({ Name = "Priority", Desc = "Order the farm jobs run in", Icon = "layers" })

	local PriorityBox = PriorityTab:AddLeftGroupbox({ Name = "Priority", Icon = "layers" })

	PriorityBox:CreateToggle({
		Name = "Begin Priority",
		CurrentValue = false,
		Flag = "PriorityBegin",
		Callback = function(value)
			Settings.PriorityBegin = value
			Priority.queueBegin()
		end,
	})

	PriorityBox:CreateDivider()

	local slotOptions = { Const.PRIORITY_NONE }
	for _, label in ipairs(Priority.Options) do
		table.insert(slotOptions, label)
	end

	for index = 1, #Const.PRIORITY_JOBS do
		Priority.Slots[index] = PriorityBox:CreateDropdown({
			Name = tostring(index),
			Options = slotOptions,
			CurrentOption = Settings.PriorityOrder[index] or Const.PRIORITY_NONE,
			MultipleOptions = false,
			AllowNone = false,
			Stacked = true,
			Flag = "PrioritySlot" .. index,
			Callback = function(option)
				local label = type(option) == "table" and option[1] or option
				Priority.assign(index, Priority.ByLabel[label] and label or nil)
			end,
		})
	end

	PriorityBox:CreateLabel({ Text = "The highest job with work goes first. A fight in progress is always finished." })

	PriorityBox:CreateStatus({
		Name = "Status",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.5,
		Update = Priority.statusText,
	})
end

local PlayerTab = Window:CreateTab({ Name = "Player", Desc = "Movement, character, travel and ESP", Icon = "user" })

local CharacterPage = PlayerTab:CreateSubTab({ Name = "Character", Icon = "user" })
local TravelTab = not Hub.InMinigame and PlayerTab:CreateSubTab({ Name = "Travel", Icon = "map" }) or nil

local SpeedBox = CharacterPage:AddLeftGroupbox({ Name = "Speed", Icon = "gauge" })

local WalkSpeedToggle = SpeedBox:CreateToggle({
	Name = "WalkSpeed",
	CurrentValue = false,
	Flag = "WalkSpeedEnabled",
	Callback = function(value)
		Settings.WalkSpeedEnabled = value
		PlayerMods.applyWalkSpeed()
	end,
})

SpeedBox:CreateSlider({
	Name = "Speed",
	Range = { 16, 200 },
	Increment = 1,
	Suffix = " studs/s",
	CurrentValue = Settings.WalkSpeed,
	Flag = "WalkSpeed",
	Callback = function(value)
		Settings.WalkSpeed = value
	end,
})

SpeedBox:CreateToggle({
	Name = "Swim Speed",
	CurrentValue = false,
	Flag = "SwimSpeedEnabled",
	Callback = function(value)
		Settings.SwimSpeedEnabled = value
		if value then
			PlayerMods.hookSwim()
		end
	end,
})

SpeedBox:CreateSlider({
	Name = "Swim Speed",
	Range = { 8, 150 },
	Increment = 1,
	Suffix = " studs/s",
	CurrentValue = Settings.SwimSpeed,
	Flag = "SwimSpeed",
	Callback = function(value)
		Settings.SwimSpeed = value
	end,
})

SpeedBox:CreateToggle({
	Name = "Auto Run",
	CurrentValue = false,
	Flag = "AutoRun",
	Callback = function(value)
		Settings.AutoRun = value
		PlayerMods.applyAutoRun()
	end,
})

local CharacterBox = CharacterPage:AddLeftGroupbox({ Name = "Character", Icon = "shield" })

for _, item in ipairs({
	{ "No Stun", "NoStun" },
	{ "No Dash Cooldown", "NoDashCooldown" },
	{ "Infinite Stamina", "InfiniteStamina" },
	{ "Infinite Climb", "InfiniteClimb" },
	{ "No Drown", "NoDrown" },
}) do
	local key = item[2]
	CharacterBox:CreateToggle({
		Name = item[1],
		CurrentValue = Settings[key],
		Flag = key == "InfiniteStamina" and "InfStamina" or key,
		Callback = function(value)
			Settings[key] = value
		end,
	})
end

CharacterBox:CreateToggle({
	Name = "Hide Name",
	CurrentValue = false,
	Flag = "HideName",
	Callback = function(value)
		Settings.HideName = value
		NameHide.set(value)
	end,
})

CharacterBox:CreateToggle({
	Name = "Disable Shift Lock",
	CurrentValue = Settings.DisableShiftLock,
	Flag = "DisableShiftLock",
	Callback = function(value)
		Settings.DisableShiftLock = value
		ShiftLock.set(value)
	end,
})

local MobilityBox = CharacterPage:AddRightGroupbox({ Name = "Mobility", Icon = "plane" })

local FlyToggle = MobilityBox:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Flag = "Fly",
	Callback = function(value)
		Settings.Fly = value
	end,
})

MobilityBox:CreateSlider({
	Name = "Fly Speed",
	Range = { 10, 300 },
	Increment = 5,
	Suffix = " studs/s",
	CurrentValue = Settings.FlySpeed,
	Flag = "FlySpeed",
	Callback = function(value)
		Settings.FlySpeed = value
	end,
})

MobilityBox:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Flag = "InfiniteJump",
	Callback = function(value)
		Settings.InfiniteJump = value
	end,
})

local NoclipToggle = MobilityBox:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Flag = "Noclip",
	Callback = function(value)
		Settings.Noclip = value
	end,
})

local KeybindBox = CharacterPage:AddRightGroupbox({ Name = "Keybinds", Icon = "keyboard" })

for _, item in ipairs({
	{ "WalkSpeed Key", "WalkSpeedKey", WalkSpeedToggle },
	{ "Fly Key", "FlyKey", FlyToggle },
	{ "Noclip Key", "NoclipKey", NoclipToggle },
}) do
	local toggle = item[3]
	KeybindBox:CreateKeybind({
		Name = item[1],
		Flag = item[2],
		Callback = function()
			toggle:Set(not toggle:Get())
		end,
	})
end


local VisualsBox = CharacterPage:AddRightGroupbox({ Name = "Performance", Icon = "cpu" })

VisualsBox:CreateToggle({
	Name = "No Screen Shake",
	CurrentValue = false,
	Flag = "NoScreenShake",
	Callback = function(value)
		Settings.NoScreenShake = value
		Visuals.applyShake()
	end,
})

VisualsBox:CreateToggle({
	Name = "No Red Hit Screen",
	CurrentValue = false,
	Flag = "NoHitFlash",
	Callback = function(value)
		Settings.NoHitFlash = value
		HitFlash.set(value)
	end,
})

VisualsBox:CreateToggle({
	Name = "Disable Animations",
	CurrentValue = Settings.DisableAnimations,
	Flag = "NoAnimations",
	Callback = function(value)
		Settings.DisableAnimations = value
		Visuals.applyAnimations()
	end,
})

VisualsBox:CreateToggle({
	Name = "Disable Breathing / Demon VFX",
	CurrentValue = false,
	Flag = "DisableSkillVfx",
	Callback = function(value)
		Settings.DisableSkillVfx = value
		Visuals.applyVfx()
	end,
})

VisualsBox:CreateToggle({
	Name = "Disable Cutscenes",
	CurrentValue = Settings.DisableCutscenes,
	Flag = "NoCutscenes",
	Callback = function(value)
		Settings.DisableCutscenes = value
		Visuals.applyCutscenes()
	end,
})

VisualsBox:CreateToggle({
	Name = "Spectate Enemy",
	CurrentValue = false,
	Flag = "SpectateEnemy",
	Callback = function(value)
		Settings.SpectateEnemy = value
	end,
})

VisualsBox:CreateToggle({
	Name = "Ultra FPS Boost",
	CurrentValue = false,
	Flag = "FpsBoost",
	Callback = function(value)
		Settings.FpsBoost = value
		Visuals.applyBoost()
	end,
})

VisualsBox:CreateDivider()

VisualsBox:CreateToggle({
	Name = "FPS Cap",
	CurrentValue = false,
	Flag = "FpsCap",
	Callback = function(value)
		Settings.FpsCap = value
		FpsCap.apply()
	end,
})

FpsCap.Input = VisualsBox:CreateInput({
	Name = "Max FPS",
	PlaceholderText = tostring(Const.FPS_CAP_DEFAULT),
	CurrentValue = tostring(Const.FPS_CAP_DEFAULT),
	Numeric = true,
	Flag = "FpsCapValue",
	Callback = function()
		local target = FpsCap.target()
		if target and tostring(target) ~= FpsCap.Input:Get() then
			FpsCap.Input:Set(target)
		end
		FpsCap.apply()
	end,
})

VisualsBox:CreateStatus({
	Name = "FPS",
	Style = "Row",
	UpdateRate = 0.5,
	Update = FpsCap.statusText,
})

if not Hub.InMinigame then
	local NpcBox = TravelTab:AddLeftGroupbox({ Name = "NPCs", Icon = "users" })

	NpcBox:CreateDropdown({
		Name = "NPC",
		Options = Travel.NpcOptions,
		MultipleOptions = false,
		Flag = "TravelNpc",
		Callback = function(option)
			Settings.TravelNpc = option
		end,
	})

	NpcBox:CreateButton({
		Name = "Teleport",
		Callback = function()
			local name = Settings.TravelNpc
			Travel.goTo(tostring(name), name and Travel.Npcs[name])
		end,
	})

	NpcBox:CreateStatus({
		Name = "Travel",
		Style = "Row",
		Pin = true,
		UpdateRate = 0.25,
		Update = function()
			local text = Travel.Status
			return text, text == "Idle" and "Muted" or string.find(text, "^Arrived") and "Success" or "Warning"
		end,
	})

	local PlaceBox = TravelTab:AddRightGroupbox({ Name = "Places", Icon = "map" })

	PlaceBox:CreateDropdown({
		Name = "Place",
		Options = Travel.PlaceOptions,
		MultipleOptions = false,
		Flag = "TravelPlace",
		Callback = function(option)
			Settings.TravelPlace = option
		end,
	})

	PlaceBox:CreateButton({
		Name = "Teleport",
		Callback = function()
			local name = Settings.TravelPlace
			Travel.goTo(tostring(name), name and Travel.Places[name])
		end,
	})

	local MarketBox = TravelTab:AddLeftGroupbox({ Name = "Black Marketer", Icon = "store" })

	MarketBox:CreateButton({
		Name = "Teleport to Black Marketer",
		Callback = function()
			local state, spot = Travel.marketer()
			if not state.Active or typeof(spot) ~= "CFrame" then
				Travel.Status = "Black Marketer is away"
				return
			end
			Travel.goTo("Black Marketer", (spot * CFrame.new(0, 0, -Const.VENDOR_STAND)).Position)
		end,
	})

	MarketBox:CreateStatus({
		Name = "Black Marketer",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(Travel.marketerText)
		end,
	})

	local MuzanBox = TravelTab:AddRightGroupbox({ Name = "Muzan", Icon = "moon" })

	MuzanBox:CreateButton({
		Name = "Find Muzan",
		Callback = function()
			if not Game.DayNight.IsNight() then
				Travel.Status = "Muzan only walks at night"
				return
			end
			Travel.start("Muzan", Travel.findMuzan)
		end,
	})

	MuzanBox:CreateStatus({
		Name = "Muzan",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(Travel.muzanText)
		end,
	})

	local LilyBox = TravelTab:AddRightGroupbox({ Name = "Spider Lily", Icon = "flower" })

	LilyBox:CreateButton({
		Name = "Find Spider Lily",
		Callback = Travel.findLily,
	})

	LilyBox:CreateStatus({
		Name = "Spider Lily",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(Travel.lilyText)
		end,
	})

	local HorseBox = TravelTab:AddRightGroupbox({ Name = "Wild Horse", Icon = "compass" })

	HorseBox:CreateButton({
		Name = "Find Horse",
		Callback = function()
			Travel.start("Wild Horse", Travel.findHorse)
		end,
	})

	HorseBox:CreateStatus({
		Name = "Wild Horse",
		UpdateRate = 1,
		Update = function()
			return Game.isolated(Travel.horseText)
		end,
	})

	HorseBox:CreateToggle({
		Name = "Auto Tame Horse",
		CurrentValue = Settings.AutoTameHorse,
		Flag = "AutoTameHorse",
		Callback = function(value)
			Settings.AutoTameHorse = value
			Tame.refresh()
		end,
	})

	HorseBox:CreateStatus({
		Name = "Taming",
		Style = "Row",
		UpdateRate = 0.25,
		Update = function()
			local ctx = Tame.Context
			if not ctx then
				return "Off", "Muted"
			end
			local text = ctx.Status
			return text, (string.find(text, "^Tamed") or string.find(text, "own a Horse")) and "Success" or string.find(text, "retrying") and "Warning" or "Accent"
		end,
	})
end

if not Hub.InMinigame then
	local Waypoint = { Enabled = false, Handler = nil, Seen = nil }

	function Waypoint.marker()
		if not Waypoint.Handler then
			local module = ReplicatedStorage:FindFirstChild("CAM")
			for _, name in ipairs({ "Client", "Modules", "MarkerHandler" }) do
				module = module and module:FindFirstChild(name)
			end
			local ok, handler = false, nil
			if module then
				ok, handler = pcall(require, module)
			end
			if not ok or type(handler) ~= "table" or type(handler.currentMarkers) ~= "table" then
				return nil
			end
			Waypoint.Handler = handler
		end
		local marker = Waypoint.Handler.currentMarkers.PlacedMarker
		if type(marker) == "table" and typeof(marker.position) == "Vector3" then
			return marker
		end
		return nil
	end

	function Waypoint.go(marker)
		local first = marker.position
		Travel.start("Waypoint", function(ctx)
			Travel.toPosition(ctx, "Waypoint", first)
			if ctx.Cancelled then
				return
			end
			ctx:waitFor(function()
				return Waypoint.marker() ~= marker or (marker.position - first).Magnitude > 1
			end, 4)
			if not ctx.Cancelled and Waypoint.marker() == marker and (marker.position - first).Magnitude > 1 then
				Travel.toPosition(ctx, "Waypoint", marker.position)
			end
		end)
	end

	RootMaid:Give(task.spawn(function()
		Hub.awaitStart()
		while true do
			local ok, err = pcall(function()
				local marker = Waypoint.marker()
				if marker ~= Waypoint.Seen then
					Waypoint.Seen = marker
					if marker and Waypoint.Enabled then
						Waypoint.go(marker)
					end
				end
			end)
			if not ok then
				warn("[Spryzen Hub] waypoint teleport error: " .. tostring(err))
			end
			task.wait(0.2)
		end
	end))

	local WaypointBox = TravelTab:AddLeftGroupbox({ Name = "Waypoint", Icon = "map" })

	WaypointBox:CreateToggle({
		Name = "Waypoint Teleport",
		CurrentValue = false,
		Flag = "WaypointTeleport",
		Callback = function(value)
			Waypoint.Enabled = value
			if value then
				Waypoint.Seen = Waypoint.marker()
			end
		end,
	})

	WaypointBox:CreateStatus({
		Name = "Waypoint",
		Style = "Row",
		UpdateRate = 0.5,
		Update = function()
			if not Waypoint.Enabled then
				return nil
			end
			Waypoint.marker()
			if not Waypoint.Handler then
				return "Map markers unavailable", "Warning"
			end
			return "Place a pin on the map to teleport there", "Muted"
		end,
	})
end

local EspTab = PlayerTab:CreateSubTab({ Name = "ESP", Icon = "eye" })

local function espToggle(box, name, key)
	box:CreateToggle({
		Name = name,
		CurrentValue = false,
		Flag = key,
		Callback = function(value)
			Settings[key] = value
		end,
	})
end

local function espColor(box, name, key)
	box:CreateColorPicker({
		Name = name,
		Default = Settings[key],
		Flag = key,
		Callback = function(color)
			if typeof(color) == "Color3" then
				Settings[key] = color
			end
		end,
	})
end

local EspStyleBox = EspTab:AddLeftGroupbox({ Name = "ESP", Icon = "scan" })

EspStyleBox:CreateStatus({
	Name = "Drawing",
	Style = "Row",
	UpdateRate = 5,
	Update = function()
		if Esp.Supported then
			return nil
		end
		return "Executor has no Drawing library", "Error"
	end,
})

espToggle(EspStyleBox, "Box", "EspBox")
espToggle(EspStyleBox, "Box Fill", "EspBoxFill")
espToggle(EspStyleBox, "3D Box", "Esp3D")
EspStyleBox:CreateDivider()
espToggle(EspStyleBox, "Name", "EspName")
espColor(EspStyleBox, "Name Colour", "EspNameColor")
espToggle(EspStyleBox, "Distance", "EspDistance")
espColor(EspStyleBox, "Distance Colour", "EspDistanceColor")
EspStyleBox:CreateDivider()
espToggle(EspStyleBox, "Health Bar", "EspHealthBar")
espColor(EspStyleBox, "Health Colour", "EspHealthColor")
espColor(EspStyleBox, "Dying Colour", "EspDyingColor")
espToggle(EspStyleBox, "Health Text", "EspHealthText")
espColor(EspStyleBox, "Health Text Colour", "EspHealthTextColor")
espToggle(EspStyleBox, "Tracer", "EspTracer")
EspStyleBox:CreateDivider()

EspStyleBox:CreateSlider({
	Name = "Max Distance",
	Range = { 100, 20000 },
	Increment = 100,
	Suffix = " studs",
	CurrentValue = Settings.EspMaxDistance,
	Flag = "EspMaxDistance",
	Callback = function(value)
		Settings.EspMaxDistance = value
	end,
})

local EspWorldBox = EspTab:AddLeftGroupbox({ Name = "World", Icon = "globe" })

espToggle(EspWorldBox, "Muzan ESP", "EspMuzan")
espColor(EspWorldBox, "Muzan Colour", "EspMuzanColor")
espToggle(EspWorldBox, "Spider Lily ESP", "EspLily")
espColor(EspWorldBox, "Spider Lily Colour", "EspLilyColor")
espToggle(EspWorldBox, "Chest ESP", "EspChest")
espColor(EspWorldBox, "Chest Colour", "EspChestColor")
espToggle(EspWorldBox, "Wild Horse ESP", "EspHorse")
espColor(EspWorldBox, "Wild Horse Colour", "EspHorseColor")
EspWorldBox:CreateDivider()

EspWorldBox:CreateToggle({
	Name = "Map Xray",
	CurrentValue = false,
	Flag = "MapXray",
	Callback = function(value)
		Settings.MapXray = value
		Xray.set(value)
	end,
})

EspWorldBox:CreateSlider({
	Name = "Xray Transparency",
	Range = { 10, 95 },
	Increment = 5,
	Suffix = "%",
	CurrentValue = Settings.XrayAmount * 100,
	Flag = "XrayAmount",
	Callback = function(value)
		Settings.XrayAmount = value / 100
		if Settings.MapXray then
			Xray.refresh()
		end
	end,
})

local EspPlayerBox = EspTab:AddRightGroupbox({ Name = "Player ESP", Icon = "users" })

espToggle(EspPlayerBox, "Player ESP", "EspPlayers")
espToggle(EspPlayerBox, "Level / Race / Clan", "EspPlayerInfo")
espColor(EspPlayerBox, "Info Colour", "EspPlayerInfoColor")
EspPlayerBox:CreateDivider()
espColor(EspPlayerBox, "Enemy Colour", "EspEnemyColor")
espColor(EspPlayerBox, "Party Colour", "EspPartyColor")

local EspNpcBox = EspTab:AddRightGroupbox({ Name = "Mobs & NPCs", Icon = "skull" })

espToggle(EspNpcBox, "Mob ESP", "EspMobs")
espColor(EspNpcBox, "Mob Colour", "EspMobColor")
espToggle(EspNpcBox, "Boss ESP", "EspBosses")
espColor(EspNpcBox, "Boss Colour", "EspBossColor")
espToggle(EspNpcBox, "NPC ESP", "EspNpcs")
espColor(EspNpcBox, "NPC Colour", "EspNpcColor")

if not Hub.InMinigame then
	local WebhookTab = Window:CreateTab({ Name = "Webhook", Desc = "Discord notifications for drops, levels, bosses and NPCs", Icon = "bell" })

	local WebhookBox = WebhookTab:AddLeftGroupbox({ Name = "Webhook", Icon = "bell" })

	WebhookBox:CreateToggle({
		Name = "Enable Webhook",
		CurrentValue = false,
		Flag = "Webhook",
		Callback = function(value)
			Settings.Webhook = value
			Webhook.Last = nil
		end,
	})

	Webhook.Inputs.Url = WebhookBox:CreateInput({
		Name = "Webhook URL",
		PlaceholderText = "https://discord.com/api/webhooks/...",
		CurrentValue = "",
		Flag = "WebhookUrl",
		Callback = function()
			Webhook.Last = nil
		end,
	})

	Webhook.Inputs.UserId = WebhookBox:CreateInput({
		Name = "Discord User ID (ping)",
		PlaceholderText = "123456789012345678",
		CurrentValue = "",
		Flag = "WebhookUserId",
		Callback = function() end,
	})

	WebhookBox:CreateToggle({
		Name = "Mention @everyone",
		CurrentValue = false,
		Flag = "WebhookEveryone",
		Callback = function(value)
			Settings.WebhookEveryone = value
		end,
	})

	WebhookBox:CreateButton({
		Name = "Send Test Post",
		Icon = "send",
		Callback = Webhook.test,
	})

	WebhookBox:CreateStatus({
		Name = "Status",
		Style = "Row",
		UpdateRate = 0.5,
		Update = Webhook.statusText,
	})

	local DigestBox = WebhookTab:AddLeftGroupbox({ Name = "Digest", Icon = "timer" })

	DigestBox:CreateToggle({
		Name = "Combine Into Digest",
		CurrentValue = Settings.WebhookDigest,
		Flag = "WebhookDigest",
		Callback = function(value)
			if value == Settings.WebhookDigest then
				return
			end
			if value then
				Settings.WebhookDigest = true
				Webhook.resetDigest()
			else
				Webhook.flushDigest(true)
				Settings.WebhookDigest = false
			end
		end,
	})

	DigestBox:CreateSlider({
		Name = "Digest Interval",
		Range = { 1, 60 },
		Increment = 1,
		Suffix = " min",
		CurrentValue = Settings.WebhookInterval,
		Flag = "WebhookInterval",
		Callback = function(value)
			Settings.WebhookInterval = value
		end,
	})

	DigestBox:CreateStatus({
		Name = "Digest",
		Style = "Row",
		UpdateRate = 1,
		Update = Webhook.digestText,
	})

	local NotifyBox = WebhookTab:AddRightGroupbox({ Name = "Notify", Icon = "send" })

	NotifyBox:CreateToggle({
		Name = "Drops",
		CurrentValue = Settings.NotifyDrops,
		Flag = "NotifyDrops",
		Callback = function(value)
			Settings.NotifyDrops = value
		end,
	})

	NotifyBox:CreateDropdown({
		Name = "Min drop rarity",
		Options = Webhook.RarityOptions,
		CurrentOption = Settings.DropRarity,
		MultipleOptions = false,
		AllowNone = false,
		Flag = "DropRarity",
		Callback = function(option)
			option = type(option) == "table" and option[1] or option
			if type(option) == "string" then
				Settings.DropRarity = option
			end
		end,
	})

	NotifyBox:CreateDropdown({
		Name = "Always Notify Items",
		Options = Webhook.ItemOptions,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "AlwaysNotify",
		Callback = function(options)
			Settings.AlwaysNotify = type(options) == "table" and options or {}
		end,
	})

	NotifyBox:CreateDivider()

	NotifyBox:CreateToggle({
		Name = "Level Up",
		CurrentValue = Settings.NotifyLevel,
		Flag = "NotifyLevel",
		Callback = function(value)
			Settings.NotifyLevel = value
		end,
	})

	NotifyBox:CreateDivider()

	NotifyBox:CreateToggle({
		Name = "Boss Spawns",
		CurrentValue = Settings.NotifyBosses,
		Flag = "NotifyBosses",
		Callback = function(value)
			Settings.NotifyBosses = value
		end,
	})

	NotifyBox:CreateDropdown({
		Name = "Bosses (none = all world bosses)",
		Options = WorldBoss.Options,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "NotifyBossList",
		Callback = function(options)
			Settings.NotifyBossList = type(options) == "table" and options or {}
		end,
	})

	NotifyBox:CreateDivider()

	NotifyBox:CreateToggle({
		Name = "NPC Arrivals",
		CurrentValue = Settings.NotifyNpcs,
		Flag = "NotifyNpcs",
		Callback = function(value)
			Settings.NotifyNpcs = value
		end,
	})

	NotifyBox:CreateDropdown({
		Name = "NPCs (none = all)",
		Options = Const.WEBHOOK_NPCS,
		CurrentOption = {},
		MultipleOptions = true,
		Flag = "NotifyNpcList",
		Callback = function(options)
			Settings.NotifyNpcList = type(options) == "table" and options or {}
		end,
	})

	NotifyBox:CreateDivider()

	NotifyBox:CreateToggle({
		Name = "Final Selection (" .. Const.FINAL_SELECTION_LEAD // 60 .. " min warning)",
		CurrentValue = Settings.NotifyFinalSelection,
		Flag = "NotifyFinalSelection",
		Callback = function(value)
			Settings.NotifyFinalSelection = value
		end,
	})

	NotifyBox:CreateDivider()

	NotifyBox:CreateToggle({
		Name = "Disconnects (kick, idle, shutdown, lost connection...)",
		CurrentValue = Settings.NotifyDisconnect,
		Flag = "NotifyDisconnect",
		Callback = function(value)
			Settings.NotifyDisconnect = value
		end,
	})
end

local Session = { AfkConnection = nil, AfkPings = 0, AfkLast = nil, Blackout = nil, PauseGui = nil, PauseWatch = nil, PauseTouched = false, Reconnecting = false, ReconnectThread = nil, ReconnectStatus = "Off" }

function Session.setAntiAfk(enabled)
	if enabled and not Session.AfkConnection then
		Session.AfkConnection = LocalPlayer.Idled:Connect(function()
			local ok, err = pcall(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.zero)
			end)
			if ok then
				Session.AfkPings += 1
				Session.AfkLast = os.clock()
			else
				warn("[Spryzen Hub] anti afk error: " .. tostring(err))
			end
		end)
	elseif not enabled and Session.AfkConnection then
		Session.AfkConnection:Disconnect()
		Session.AfkConnection = nil
	end
end

function Session.setRendering(disabled)
	local ok, err = pcall(RunService.Set3dRenderingEnabled, RunService, not disabled)
	if not ok then
		warn("[Spryzen Hub] 3d rendering toggle failed: " .. tostring(err))
	end
	if not disabled then
		if Session.Blackout then
			Session.Blackout:Destroy()
			Session.Blackout = nil
		end
		return
	end
	if Session.Blackout and Session.Blackout.Parent then
		return
	end
	local host = Window.Gui
	local frame = Instance.new("Frame")
	frame.Name = "Blackout"
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.ZIndex = -10
	local label = Instance.new("TextLabel")
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.fromScale(0.5, 0.5)
	label.Size = UDim2.fromOffset(400, 24)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamMedium
	label.Text = "3D rendering disabled"
	label.TextSize = 16
	label.TextColor3 = Color3.fromRGB(120, 120, 120)
	label.ZIndex = -10
	label.Parent = frame
	if host then
		frame.Parent = host
	else
		local gui = Instance.new("ScreenGui")
		gui.Name = "Slayer2Blackout"
		gui.IgnoreGuiInset = true
		gui.ResetOnSpawn = false
		gui.DisplayOrder = 998
		frame.Parent = gui
		gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		frame = gui
	end
	Session.Blackout = frame
end

function Session.hidePauseGui()
	local ok, gui = pcall(function()
		return game:GetService("CoreGui"):FindFirstChild(Const.PAUSE_GUI)
	end)
	gui = ok and gui or nil
	if gui ~= Session.PauseGui then
		if Session.PauseWatch then
			Session.PauseWatch:Disconnect()
			Session.PauseWatch = nil
		end
		Session.PauseGui = gui
		if gui then
			Session.PauseWatch = gui:GetPropertyChangedSignal("Enabled"):Connect(function()
				if Settings.HidePausePopup and gui.Enabled then
					gui.Enabled = false
				end
			end)
		end
	end
	if gui and gui.Enabled then
		gui.Enabled = false
		Session.PauseTouched = true
	end
end

function Session.setPausePopup(hidden)
	local ok, err = pcall(GuiService.SetGameplayPausedNotificationEnabled, GuiService, not hidden)
	if not ok then
		warn("[Spryzen Hub] gameplay paused toggle failed: " .. tostring(err))
	end
	if hidden then
		pcall(Session.hidePauseGui)
		return
	end
	if Session.PauseWatch then
		Session.PauseWatch:Disconnect()
		Session.PauseWatch = nil
	end
	if Session.PauseTouched and Session.PauseGui and Session.PauseGui.Parent then
		pcall(function()
			Session.PauseGui.Enabled = true
		end)
	end
	Session.PauseGui = nil
	Session.PauseTouched = false
end

function Session.reconnect()
	if Session.Reconnecting or not Settings.AutoReconnect then
		return
	end
	Session.Reconnecting = true
	Session.ReconnectThread = task.spawn(function()
		local waitUntil = os.clock() + Settings.ReconnectDelay
		while os.clock() < waitUntil and Settings.AutoReconnect do
			Session.ReconnectStatus = "Disconnected, rejoining in " .. math.ceil(waitUntil - os.clock()) .. "s"
			task.wait(0.25)
		end
		local attempt = 0
		while Settings.AutoReconnect do
			attempt += 1
			local sameServer = attempt == 1 and game.PrivateServerId == ""
			Session.ReconnectStatus = (sameServer and "Rejoining this server" or "Joining a server") .. ", attempt " .. attempt
			local ok, err
			if sameServer then
				ok, err = pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, game.JobId, LocalPlayer)
			else
				ok, err = pcall(TeleportService.Teleport, TeleportService, game.PlaceId, LocalPlayer)
			end
			if not ok then
				warn("[Spryzen Hub] reconnect failed: " .. tostring(err))
			end
			task.wait(Const.RECONNECT_RETRY)
		end
		Session.ReconnectStatus = "Off"
		Session.Reconnecting = false
		Session.ReconnectThread = nil
	end)
end

function Session.checkError()
	local ok, message = pcall(GuiService.GetErrorMessage, GuiService)
	if ok and type(message) == "string" and message ~= "" then
		Webhook.disconnect(message)
		Session.reconnect()
	end
end

RootMaid:Give(GuiService.ErrorMessageChanged:Connect(function(message)
	if type(message) == "string" and message ~= "" then
		Webhook.disconnect(message)
		Session.reconnect()
	end
end))

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		if Settings.HidePausePopup then
			local ok, err = pcall(Session.hidePauseGui)
			if not ok then
				warn("[Spryzen Hub] gameplay paused hide error: " .. tostring(err))
			end
		end
		task.wait(Const.PAUSE_POLL)
	end
end))

RootMaid:Give(function()
	Session.setAntiAfk(false)
	if Settings.Disable3d then
		Session.setRendering(false)
	end
	if Settings.HidePausePopup then
		Session.setPausePopup(false)
	end
	if Session.ReconnectThread and coroutine.status(Session.ReconnectThread) ~= "dead" then
		task.cancel(Session.ReconnectThread)
	end
	Session.ReconnectThread = nil
	Session.Reconnecting = false
end)

local Panic = {
	GROUP_ID = 12851171,
	STAFF_RANK = 3,
	ROLES = { [3] = "Tester", [4] = "Balancer", [5] = "Admin", [6] = "Studio Developer", [254] = "Partner", [255] = "Owner" },
	ACTIONS = { "Off", "Kick Instantly", "Stop All Features and Reset", "Stop All and Farm Power Statue" },
	KEEP = { PanicEnabled = true, AntiAfk = true, AutoReconnect = true, Disable3d = true, HidePausePopup = true },
	Enabled = false,
	ModAction = "Off",
	PlayerAction = "Off",
	Ranks = {},
	Checking = {},
	Handled = {},
	AloneHandled = false,
	Status = nil,
	WhitelistDropdown = nil,
	WhitelistInput = nil,
	PlayersKey = nil,
}

function Panic.whitelisted(player)
	local name = string.lower(player.Name)
	local id = tostring(player.UserId)
	local dropdown = Panic.WhitelistDropdown
	local ok, picked = pcall(function()
		return dropdown and dropdown:Get()
	end)
	if ok and type(picked) == "table" then
		for _, entry in ipairs(picked) do
			if type(entry) == "string" and string.lower(entry) == name then
				return true
			end
		end
	end
	local input = Panic.WhitelistInput
	local textOk, text = pcall(function()
		return input and input:Get()
	end)
	if textOk and type(text) == "string" then
		for entry in string.gmatch(text, "[^,%s]+") do
			entry = string.lower(entry)
			if entry == name or entry == id then
				return true
			end
		end
	end
	return false
end

function Panic.refreshPlayers()
	local dropdown = Panic.WhitelistDropdown
	if not dropdown then
		return
	end
	local names = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			table.insert(names, player.Name)
		end
	end
	table.sort(names, function(a, b)
		return string.lower(a) < string.lower(b)
	end)
	local key = table.concat(names, "|")
	if key == Panic.PlayersKey then
		return
	end
	Panic.PlayersKey = key
	local ok, err = pcall(dropdown.Refresh, dropdown, names, true)
	if not ok then
		warn("[Spryzen Hub] panic whitelist refresh failed: " .. tostring(err))
	end
end

function Panic.rank(player)
	local id = player.UserId
	if Panic.Ranks[id] ~= nil or Panic.Checking[id] then
		return Panic.Ranks[id]
	end
	Panic.Checking[id] = true
	task.spawn(function()
		for _ = 1, 3 do
			local ok, rank = pcall(player.GetRankInGroup, player, Panic.GROUP_ID)
			if ok and type(rank) == "number" then
				Panic.Ranks[id] = rank
				break
			end
			task.wait(1)
		end
		Panic.Checking[id] = nil
		if Panic.Ranks[id] and Panic.Enabled then
			Panic.check()
		end
	end)
	return nil
end

function Panic.stopAll(keepAlive)
	for flag, control in pairs(Airflow.Flags) do
		if type(control) == "table" and control._type == "Toggle" and not Panic.KEEP[flag] then
			local ok, value = pcall(control.Get, control)
			if ok and value then
				local setOk, err = pcall(control.Set, control, false)
				if not setOk then
					warn("[Spryzen Hub] panic could not stop " .. tostring(flag) .. ": " .. tostring(err))
				end
			end
		end
	end
	local humanoid = not keepAlive and Character.humanoid()
	if humanoid then
		local ok, err = pcall(function()
			humanoid.Health = 0
		end)
		if not ok then
			warn("[Spryzen Hub] panic reset failed: " .. tostring(err))
		end
	end
end

function Panic.fire(reason, action)
	Panic.Status = reason
	if action == "Kick Instantly" then
		Settings.AutoReconnect = false
		local reconnect = Airflow.Flags.AutoReconnect
		if reconnect then
			pcall(reconnect.Set, reconnect, false)
		end
		LocalPlayer:Kick("Panic: " .. reason)
		return
	end
	if action == "Stop All and Farm Power Statue" then
		Panic.stopAll(true)
		local control = Airflow.Flags.AutoPowerStatue
		local ok, err = pcall(control.Set, control, true)
		if not ok then
			warn("[Spryzen Hub] panic could not start the Power statue farm: " .. tostring(err))
		end
		Hub.Notify({
			Title = "Panic",
			Content = "Stopped all features and started farming the Power statue: " .. reason .. ".",
			Type = "Warning",
			Icon = "shield-alert",
			Duration = 8,
		})
		return
	end
	Panic.stopAll()
	Hub.Notify({
		Title = "Panic",
		Content = "Stopped all features and reset: " .. reason .. ".",
		Type = "Warning",
		Icon = "shield-alert",
		Duration = 8,
	})
end

function Panic.check()
	if not Panic.Enabled then
		return
	end
	local watchStaff = Panic.ModAction ~= "Off"
	local watchPlayers = Panic.PlayerAction ~= "Off"
	local others = 0
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and not Panic.whitelisted(player) then
			others += 1
			if watchStaff then
				local rank = Panic.rank(player)
				if rank and rank >= Panic.STAFF_RANK and not Panic.Handled[player.UserId] then
					Panic.Handled[player.UserId] = true
					Panic.fire(player.Name .. " (" .. (Panic.ROLES[rank] or "staff") .. ") is in the server", Panic.ModAction)
					return
				end
			end
		end
	end
	if watchPlayers then
		if others > 0 then
			if not Panic.AloneHandled then
				Panic.AloneHandled = true
				Panic.fire(others .. (others == 1 and " other player" or " other players") .. " in the server", Panic.PlayerAction)
			end
		else
			Panic.AloneHandled = false
		end
	end
end

function Panic.arm()
	Panic.Handled = {}
	Panic.AloneHandled = false
	Panic.Status = nil
	Panic.check()
end

RootMaid:Give(Players.PlayerAdded:Connect(function()
	Panic.refreshPlayers()
	Panic.check()
end))

RootMaid:Give(Players.PlayerRemoving:Connect(function()
	task.defer(Panic.refreshPlayers)
end))

RootMaid:Give(task.spawn(function()
	Hub.awaitStart()
	while true do
		local ok, err = pcall(Panic.check)
		if not ok then
			warn("[Spryzen Hub] panic check error: " .. tostring(err))
		end
		task.wait(0.25)
	end
end))

local SettingsTab = Window:CreateTab({ Name = "Settings", Desc = SCRIPT_VERSION, Icon = "settings" })

local InterfaceBox = SettingsTab:AddLeftGroupbox({ Name = "Menu", Icon = "monitor" })

Hub.addInterfaceControls(InterfaceBox, Window)
Hub.addLinkButtons(InterfaceBox, Airflow)

InterfaceBox:CreateDivider()

InterfaceBox:CreateToggle({
	Name = "Anti AFK",
	CurrentValue = Settings.AntiAfk,
	Flag = "AntiAfk",
	Callback = function(value)
		Settings.AntiAfk = value
		Session.setAntiAfk(value)
	end,
})

InterfaceBox:CreateToggle({
	Name = "Auto Reconnect",
	CurrentValue = false,
	Flag = "AutoReconnect",
	Callback = function(value)
		Settings.AutoReconnect = value
		if value then
			Session.checkError()
		end
	end,
})

InterfaceBox:CreateSlider({
	Name = "Reconnect Delay",
	Range = { 0, 60 },
	Increment = 1,
	Suffix = "s",
	CurrentValue = Settings.ReconnectDelay,
	Flag = "ReconnectDelay",
	Callback = function(value)
		Settings.ReconnectDelay = value
	end,
})

InterfaceBox:CreateToggle({
	Name = "Disable 3D Rendering",
	CurrentValue = false,
	Flag = "Disable3d",
	Callback = function(value)
		Settings.Disable3d = value
		Session.setRendering(value)
	end,
})

InterfaceBox:CreateToggle({
	Name = "Hide Gameplay Paused",
	CurrentValue = Settings.HidePausePopup,
	Flag = "HidePausePopup",
	Callback = function(value)
		Settings.HidePausePopup = value
		Session.setPausePopup(value)
	end,
})

InterfaceBox:CreateStatus({
	Name = "Session",
	Style = "Row",
	UpdateRate = 1,
	Update = function()
		if Session.Reconnecting then
			return Session.ReconnectStatus, "Warning"
		end
		if not Settings.AntiAfk then
			return nil
		end
		if Session.AfkLast then
			return "Anti AFK kept you in " .. Session.AfkPings .. "x, last " .. BossStats.duration(os.clock() - Session.AfkLast) .. " ago", "Success"
		end
		return "Anti AFK watching", "Success"
	end,
})

InterfaceBox:CreateDivider()

Hub.addUnloadButton(InterfaceBox, Airflow, unload)

local PanicBox = SettingsTab:AddRightGroupbox({ Name = "Panic", Icon = "shield-alert" })

PanicBox:CreateToggle({
	Name = "Panic",
	CurrentValue = false,
	Flag = "PanicEnabled",
	Callback = function(value)
		Panic.Enabled = value
		if value then
			Panic.arm()
		end
	end,
})

PanicBox:CreateDropdown({
	Name = "Mods Join",
	Options = Panic.ACTIONS,
	CurrentOption = Panic.ModAction,
	MultipleOptions = false,
	AllowNone = false,
	Flag = "PanicModAction",
	Callback = function(option)
		option = type(option) == "table" and option[1] or option
		if type(option) == "string" then
			Panic.ModAction = option
			if Panic.Enabled then
				Panic.arm()
			end
		end
	end,
})

PanicBox:CreateDropdown({
	Name = "Players Join",
	Options = Panic.ACTIONS,
	CurrentOption = Panic.PlayerAction,
	MultipleOptions = false,
	AllowNone = false,
	Flag = "PanicPlayerAction",
	Callback = function(option)
		option = type(option) == "table" and option[1] or option
		if type(option) == "string" then
			Panic.PlayerAction = option
			if Panic.Enabled then
				Panic.arm()
			end
		end
	end,
})

PanicBox:CreateDivider()

Panic.WhitelistDropdown = PanicBox:CreateDropdown({
	Name = "Whitelist (players in server)",
	Options = {},
	CurrentOption = {},
	MultipleOptions = true,
	Flag = "PanicWhitelist",
	Callback = function() end,
})

Panic.WhitelistInput = PanicBox:CreateInput({
	Name = "Whitelist (usernames or IDs)",
	PlaceholderText = "name1, name2, 12345678",
	CurrentValue = "",
	Flag = "PanicWhitelistNames",
	Callback = function() end,
})

Panic.refreshPlayers()

PanicBox:CreateStatus({
	Name = "Panic",
	Style = "Row",
	UpdateRate = 1,
	Update = function()
		if not Panic.Enabled then
			return nil
		end
		if Panic.Status then
			return "Triggered: " .. Panic.Status, "Warning"
		end
		if Panic.ModAction == "Off" and Panic.PlayerAction == "Off" then
			return "Pick an action for mods or players", "Warning"
		end
		local watching = {}
		if Panic.ModAction ~= "Off" then
			table.insert(watching, "Mods")
		end
		if Panic.PlayerAction ~= "Off" then
			table.insert(watching, "Players")
		end
		return "Watching: " .. table.concat(watching, ", "), "Success"
	end,
})

SettingsTab:CreateConfigManager({ Name = "Configs", Side = "Left" })
SettingsTab:CreateThemeManager({ Name = "Themes", Side = "Right" })

Window:LoadAutoload()

ShiftLock.set(Settings.DisableShiftLock)
FpsCap.apply()
Session.setAntiAfk(Settings.AntiAfk)
if Settings.HidePausePopup then
	Session.setPausePopup(true)
end

Hub.Started = true
