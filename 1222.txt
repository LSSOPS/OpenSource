repeat
	task.wait()
until game:IsLoaded()

local tbl

tbl = {
	IsDetected = false,
	_unpack = function(arg, arg2, arg3)
		arg2 = arg2 or 1
		local n = arg3 or #arg
		if n < arg2 then
			return
		end
		return arg[arg2], tbl._unpack(arg, arg2 + 1, n)
	end,
	_pcall = function(arg, ...)
		local tbl2 = { ... }

		local ok, result = pcall(function()
			return arg(tbl._unpack(tbl2))
		end)

		if not ok then
			return false, result
		end
		return true, result
	end,
}

local function fn()
	return true
end

local v, v2 = tbl._pcall(debug.info, fn, "f")

if not v or v2 ~= fn then
	tbl.IsDetected = true
	LPH_CRASH()
end

local v3, v4 = tbl._pcall(debug.info, 2, "f")

if not v3 or v4 ~= pcall then
	tbl.IsDetected = true
	LPH_CRASH()
end

local v5 = (cloneref or function(arg)
	return arg
end)(game:GetService("RunService"))

if v5:IsStudio() then
	tbl.IsDetected = true
	LPH_CRASH()
end

if v5:IsServer() then
	tbl.IsDetected = true
	LPH_CRASH()
end

if tbl.IsDetected then
	return
end

loadstring([[ 
  function LPH_NO_VIRTUALIZE(f) return f end;
  function LPH_JIT_MAX(f) return f end;
  function LPH_JIT(f) return f end;

  function LPH_ENCNUM(n, ...) return n end;
  function LPH_ENCSTR(s, ...) return s end;
  function LPH_ENCFUNC(f, ...) return f end;
  function LPH_ENCBUF(b, ...) return b end;

  function LPH_ATTRIBUTES(...) end;
  function LPH_REWRITE(expr, ...) return expr end;
  function LPH_STACKALLOC(size, zeroOrOne) return {} end;
  function LPH_PRECHECK(...) end;

  function VM(...) end;
  function PRESET(...) end;
  function ENCRYPT(...) end;
  function OPTIMIZE(...) end;
  function ERROR_HANDLING(...) end;
  function TRANSFORM(...) end;
  NONE, OPAL, ONYX = 0, 1, 2;
  FAST, SECURE = 0, 1;
  CONTROL_FLOW, EXTRACT, INLINE, UNROLL, NO_UPVALUES, level = 0, 0, 0, 0, 0, 0;
]])()

local function fn2()
	local now = tick()

	local function fn3()
		if not getfenv() then
			getfenv()
		end

		local function fn4(arg)
			local ok, result = pcall(function()
				return game:HttpGet(arg, true)
			end)

			if not ok then
				return nil, "Failed to load resource"
			end
			return result
		end

		return { load = function(arg)
			local v6, v7 = fn4(arg)
			if not v6 then
				return nil, v7
			end
			local chunk, v8 = loadstring(v6)
			if not chunk then
				return nil, v8
			end
			return chunk
		end }
	end

	local v6 = fn3()

	local tbl2 = {
		print = function()
		end,
		warn = function()
		end,
		error = function()
		end,
		pcall = pcall,
		xpcall = xpcall,
		tick = tick,
		time = time,
		os = { time = os.time, date = os.date, clock = os.clock },
		math = math,
		table = table,
		string = string,
		type = type,
		typeof = typeof,
		tonumber = tonumber,
		tostring = tostring,
		require = require,
		pairs = pairs,
		ipairs = ipairs,
		next = next,
		select = select,
		unpack = unpack,
		_G = _G,
	}

	local lua, v7 = v6.load("https://raw.githubusercontent.com/AhmadV99/Main/refs/heads/main/Library/Lib_5.5.0.lua")

	if not lua then
		error("Failed to load library: " .. tostring(v7))
	end

	local FuncsV3, v8 = v6.load("https://raw.githubusercontent.com/AhmadV99/Main/main/Library/Example/FuncsV3")

	if not FuncsV3 then
		error("Failed to load functions: " .. tostring(v8))
	end

	local ok, result = pcall(lua)

	if not ok then
		error("Library execution failed: " .. tostring(result))
	end

	local ok2, result2 = pcall(FuncsV3)

	if not ok2 then
		error("Functions execution failed: " .. tostring(result2))
	end

	local v9 = result

	local v10 = v9:CreateWindow({
		Title = "Speed Hub X | Version 5.5.0 | discord.gg/speedhubx",
		Description = "",
		["Tab Width"] = 150,
		SaveSystem = { Enable = true, File = "Blox Fruits" },
		Key = "KZgN0t5pK6hBaqVLAMLg27aqXNDb8v",
		Key1 = "c9RkyXAjNpJc9u1fexvw1cbxYTWvMy",
		Key2 = "Xp8712WzbaRn8EtrLnXk8gDdzQB8jF",
		Key3 = "wixUQtibEtmkTQ7WpSFGq4YfBuqJQy",
		Key4 = "KbSf6UWZ6vndbgp8Vh9EHdM0dU8DFf",
		Key5 = "mP3tTRKYwhNKLkpFCdVuj922xqTgJp",
		Key6 = "heMGEmHXFUaiTaStAihwTfwgSJguUwQQxdE",
		Key7 = "khEXYXSHSJpDabFqudKJWEWbEyzXYgLmgTF",
		Key8 = "MLGkWCxxHaqhumMpSmpvJMuiUEpeqUAYvxN",
	})

	local tbl3 = { __tabs = {}, __lock = false }

	local function fn4(...)
		local tbl4 = {}

		for i, v11 in ipairs({ ... }) do
			if type(v11) == "table" and #v11 >= 2 then
				local v12 = v10:CreateTab({ Name = v11[1], Icon = "rbxassetid://" .. tostring(v11[2]) })
				tbl4[i] = v12
				tbl3.__tabs[v11[1]] = v12
			end
		end

		return table.unpack(tbl4)
	end

	local v11, v12, v13, v14, v15, v16, v17, v18 = fn4({ "Home", "10734942198" }, { "Main", "10723407389" }, { "Automatically", "10734923549" }, { "Sea Event", "16175025368" }, { "Teleport", "10734910680" }, { "Shop", "10734952273" }, { "Misc", "11447063791" }, { "Settings", "10734950309" })

	local tbl4 = {
		__spawn = task.spawn,
		__isLoaded = false,
		__unloadRequested = false,
		__locks = {},
		__timers = {},
		__hooks = {},
	}

	local function fn5(arg)
		return ({ [arg] = game:GetService(arg) })[arg]
	end

	local tbl5 = {
		Players = fn5("Players"),
		ReplicatedStorage = fn5("ReplicatedStorage"),
		HttpService = fn5("HttpService"),
		UserInputService = fn5("UserInputService"),
		Workspace = fn5("Workspace"),
		VirtualInputManager = fn5("VirtualInputManager"),
		TweenService = fn5("TweenService"),
		RunService = fn5("RunService"),
		Lighting = fn5("Lighting"),
		CollectionService = fn5("CollectionService"),
		TeleportService = fn5("TeleportService"),
	}

	local localPlayer = tbl5.Players.LocalPlayer
	local playerGui = localPlayer.PlayerGui

	local tbl6 = {
		Enemies = tbl5.Workspace:FindFirstChild("Enemies"),
		Characters = tbl5.Workspace:FindFirstChild("Characters"),
		Map = tbl5.Workspace:FindFirstChild("Map"),
		WorldOrigin = tbl5.Workspace:FindFirstChild("_WorldOrigin"),
		Remotes = tbl5.ReplicatedStorage:FindFirstChild("Remotes"),
		CommF_ = nil,
		Modules = tbl5.ReplicatedStorage:FindFirstChild("Modules"),
		Net = nil,
	}

	tbl6.CommF_ = tbl6.Remotes:WaitForChild("CommF_")
	tbl6.Net = tbl6.Modules:WaitForChild("Net")

	local tbl7 = {
		RegisterAttack = tbl6.Net:WaitForChild("RE/RegisterAttack"),
		RegisterHit = tbl6.Net:WaitForChild("RE/RegisterHit"),
		ReceivedHit = tbl6.Net:WaitForChild("RE/ReceivedHit"),
		ShootGunEvent = tbl6.Net:WaitForChild("RE/ShootGunEvent"),
	}

	local placeId = game.PlaceId

	local tbl8 = {
		placeId == 2753915549 or placeId == 85211729168715,
		placeId == 4442272183 or placeId == 79091703265657,
		placeId == 7449423635 or placeId == 100117331123089,
	}

	local tbl9 = {
		BoatShop = {
			[2] = CFrame.new(-13.488054275512695, 10.311711311340332, 2927.69287109375),
			[3] = CFrame.new(-16927.17578125, 9.0563430786132812, 435.248779296875),
		},
		BoatShopPos = {
			[2] = Vector3.new(-13.488054, 10.311711, 2927.6929),
			[3] = Vector3.new(-16927.176, 9.056343, 435.24878),
		},
		LevelSea = {
			["1"] = CFrame.new(-21332.876953125, 0, 1356.6005859375),
			["2"] = CFrame.new(-25077.7109375, 0, 2876.619140625),
			["3"] = CFrame.new(-29325.326171875, 0, 4763.1796875),
			["4"] = CFrame.new(-31615.3671875, 0, 5669.40478515625),
			["5"] = CFrame.new(-36453.9921875, 0, 6484.83056640625),
			["6"] = CFrame.new(-42170.15234375, 0, 4071.352294921875),
			Infinite = CFrame.new(0, 5, -1e14),
		},
		Islands = {
			["Sky 2"] = Vector3.new(-4607.8228, 872.5425, -1667.5569),
			["Sky 3"] = Vector3.new(-7894.6177, 5547.1416, -380.2912),
		},
	}

	local tbl10 = {
		"Rocket Fruit",
		"Spin Fruit",
		"Chop Fruit",
		"Spring Fruit",
		"Bomb Fruit",
		"Smoke Fruit",
		"Spike Fruit",
		"Flame Fruit",
		"Falcon Fruit",
		"Ice Fruit",
		"Sand Fruit",
		"Dark Fruit",
		"Ghost Fruit",
		"Diamond Fruit",
		"Light Fruit",
		"Rubber Fruit",
		"Barrier Fruit",
		"Magma Fruit",
		"Quake Fruit",
		"Buddha Fruit",
		"Love Fruit",
		"Spider Fruit",
		"Sound Fruit",
		"Phoenix Fruit",
		"Portal Fruit",
		"Rumble Fruit",
		"Pain Fruit",
		"Blizzard Fruit",
		"Gravity Fruit",
		"Mammoth Fruit",
		"T-Rex Fruit",
		"Dough Fruit",
		"Shadow Fruit",
		"Venom Fruit",
		"Control Fruit",
		"Spirit Fruit",
		"Dragon Fruit",
		"Leopard Fruit",
		"Yeti Fruit",
		"Kitsune Fruit",
		"Gas Fruit",
		"Blade Fruit",
	}

	local tbl11 = {
		Frags = {
			{ "Race Rerol", { "BlackbeardReward", "Reroll", "2" } },
			{ "Reset Stats", { "BlackbeardReward", "Refund", "2" } },
		},
		["Fighting Style"] = {
			{ "Buy Black Leg", { "BuyBlackLeg" } },
			{ "Buy Electro", { "BuyElectro" } },
			{ "Buy Fishman Karate", { "BuyFishmanKarate" } },
			{ "Buy Dragon Claw", { "BlackbeardReward", "DragonClaw", "2" } },
			{ "Buy Superhuman", { "BuySuperhuman" } },
			{ "Buy Death Step", { "BuyDeathStep" } },
			{ "Buy Sharkman Karate", { "BuySharkmanKarate" } },
			{ "Buy Electric Claw", { "BuyElectricClaw" } },
			{ "Buy Dragon Talon", { "BuyDragonTalon" } },
			{ "Buy GodHuman", { "BuyGodhuman" } },
			{ "Buy Sanguine Art", { "BuySanguineArt" } },
		},
		["Ability Teacher"] = {
			{ "Buy Geppo", { "BuyHaki", "Geppo" } },
			{ "Buy Buso", { "BuyHaki", "Buso" } },
			{ "Buy Soru", { "BuyHaki", "Soru" } },
			{ "Buy Ken", { "KenTalk", "Buy" } },
		},
		Sword = {
			{ "Buy Katana", { "BuyItem", "Katana" } },
			{ "Buy Cutlass", { "BuyItem", "Cutlass" } },
			{ "Buy Dual Katana", { "BuyItem", "Dual Katana" } },
			{ "Buy Iron Mace", { "BuyItem", "Iron Mace" } },
			{ "Buy Triple Katana", { "BuyItem", "Triple Katana" } },
			{ "Buy Pipe", { "BuyItem", "Pipe" } },
			{ "Buy Dual-Headed Blade", { "BuyItem", "Dual-Headed Blade" } },
			{ "Buy Soul Cane", { "BuyItem", "Soul Cane" } },
			{ "Buy Bisento", { "BuyItem", "Bisento" } },
		},
		Gun = {
			{ "Buy Musket", { "BuyItem", "Musket" } },
			{ "Buy Slingshot", { "BuyItem", "Slingshot" } },
			{ "Buy Flintlock", { "BuyItem", "Flintlock" } },
			{ "Buy Refined Slingshot", { "BuyItem", "Refined Slingshot" } },
			{ "Buy Refined Flintlock", { "BuyItem", "Refined Flintlock" } },
			{ "Buy Cannon", { "BuyItem", "Cannon" } },
			{ "Buy Kabucha", { "BlackbeardReward", "Slingshot", "2" } },
		},
		Accessories = {
			{ "Buy Black Cape", { "BuyItem", "Black Cape" } },
			{ "Buy Swordsman Hat", { "BuyItem", "Swordsman Hat" } },
			{ "Buy Tomoe Ring", { "BuyItem", "Tomoe Ring" } },
		},
		Race = {
			{ "Ghoul Race", { "Ectoplasm", "Change", 4 } },
			{ "Cyborg Race", { "CyborgTrainer", "Buy" } },
		},
	}

	local tbl12 = {
		"Flame",
		"Ice",
		"Quake",
		"Light",
		"Dark",
		"Spider",
		"Rumble",
		"Magma",
		"Buddha",
		"Sand",
		"Phoenix",
		"Dough",
	}

	local ItemReplicationService = require(tbl5.ReplicatedStorage.ItemReplicationService)
	local KEYS = require(tbl5.ReplicatedStorage.ItemReplicationService.KEYS)
	local ItemId = require(tbl5.ReplicatedStorage.Economy.ItemId)
	local ItemConfig = require(tbl5.ReplicatedStorage.ItemConfig)
	local RarityUtil = require(tbl5.ReplicatedStorage.Modules.Asset.RarityUtil)
	local PriceService = require(tbl5.ReplicatedStorage.PriceService)

	local tbl13 = {
		Moveset = "Melee",
		PhysicalMoveset = "Blox Fruit",
		Material = "Material",
		Accessory = "Accessory",
	}

	local function fn6()
		local tbl14 = {}

		local ok3, result3 = pcall(function()
			return tbl5.ReplicatedStorage.Remotes.CommF_:InvokeServer("GetFruits")
		end)

		if ok3 and typeof(result3) == "table" then
			for _, v19 in ipairs(result3) do
				if v19.Name and v19.Price then
					tbl14[v19.Name] = v19.Price
				end
			end
		end

		return tbl14
	end

	local function fn7(arg, arg2)
		local v19 = ItemConfig.match(arg, arg2)
		local v20 = nil

		if v19 then
			if v19.asNullable then
				v20 = v19:asNullable()
			else
				v20 = nil

				if v19.unwrap then
					v20 = v19:unwrap()
				end
			end
		end

		if not v20 then
			return nil
		end
		local rarity = v20.Quality and v20.Quality.Rarity
		if not rarity then
			return nil
		end
		return RarityUtil.tryGetRarity(rarity)
	end

	local function fn8()
		local tbl14 = {}
		local items = ItemReplicationService:GetItems(KEYS.QUANTITY)
		if not items then
			return tbl14
		end
		local v19 = fn6()

		for _, item in pairs(items) do
			local n = item.Value or 0

			if n > 0 then
				local itemId = item.ItemId
				local v20 = ItemConfig.match(itemId)
				local str = "Other"

				if v20:isOk() then
					local v21 = v20:unwrap()
					local index = v21.Index or v21.Data or v21
					str = index.IdType or index.Type or "Other"
				end

				local v21 = tbl13[str]

				if v21 then
					local v22 = ItemId.getDataFromId(itemId)
					local storageKey = nil

					if v22:isOk() then
						storageKey = v22:unwrap().StorageKey
					end

					local name = fn7(itemId)
					name = name and name.Name or "Unknown"

					local tbl15 = {
						Name = storageKey or "Item_" .. tostring(itemId),
						Count = n,
						Type = v21,
						Rarity = name,
						ItemId = itemId,
					}

					if v21 == "Blox Fruit" and storageKey then
						local price = v19[storageKey] or 0
						local robuxPrice = 0

						if PriceService:GetIfInitialized() then
							local v23 = ItemId.getId("Permanent " .. storageKey, "Redeemable"):asNullable()

							if v23 then
								robuxPrice = PriceService.getPrice(v23) or 0
							end
						end

						tbl15.Price = price
						tbl15.RobuxPrice = robuxPrice
					end

					table.insert(tbl14, tbl15)
				end
			end
		end

		return tbl14
	end

	local tbl14 = {}
	local str = "SpeedHubX/BloxFruit_V5.json"
	local tbl15 = {}
	local n = 0
	local n2 = 0.5

	local tbl16 = {
		SetSave = function(arg, arg2, arg3, arg4)
			if not (arg4 or false) and type(arg3) == "table" then
				for _, v19 in pairs(arg3) do
					tbl14[arg2] = v19
					tbl15[arg2] = true
				end
			else
				tbl14[arg2] = arg3
				tbl15[arg2] = true
			end

			if n2 <= tick() - n then
				n = tick()

				pcall(function()
					local json = tbl5.HttpService:JSONEncode(tbl14)

					if writefile and isfolder and makefolder then
						if not isfolder("SpeedHubX") then
							makefolder("SpeedHubX")
						end

						writefile(str, json)
						table.clear(tbl15)
					end
				end)
			end
		end,
		SetLoad = function()
			if not isfile then
				return
			end

			pcall(function()
				if isfile(str) then
					local data = tbl5.HttpService:JSONDecode(readfile(str))

					if data and type(data) == "table" then
						for k, v19 in pairs(data) do
							tbl14[k] = v19
						end
					end
				end
			end)
		end,
	}

	tbl16:SetLoad()
	result2:SetTable(tbl14)
	tbl14["Fast Attack Delay"] = 0
	local tbl17 = { __spawn = task.spawn, __loops = {}, __connections = {}, __metadata = {}, __running = true }

	tbl4.__spawn(function()
		if not _G.ExecutedRemove then
			_G.ExecutedRemove = true
			local container = tbl5.ReplicatedStorage.Effect.Container
			local CameraShaker = require(tbl5.ReplicatedStorage.Util.CameraShaker)

			hookfunction(require(container:FindFirstChild("Death")), function()
			end)

			CameraShaker:Stop()
		end
	end)

	tbl4.__spawn(function()
		local enemySpawns = tbl5.Workspace:FindFirstChild("EnemySpawns") or Instance.new("Folder", tbl5.Workspace)
		enemySpawns.Name = "EnemySpawns"
		local enemyCDKSpawns = tbl5.Workspace:FindFirstChild("EnemyCDKSpawns") or Instance.new("Folder", tbl5.Workspace)
		enemyCDKSpawns.Name = "EnemyCDKSpawns"

		local function fn9(arg)
			if arg:IsA("Model") and arg:FindFirstChild("HumanoidRootPart") or arg:IsA("Part") then
				local clone = arg:IsA("Model") and arg.HumanoidRootPart:Clone() or arg:Clone()
				clone.Name = arg.Name:gsub("Lv. ", ""):gsub("[%[%] %d]", "")
				clone.Parent = enemySpawns
				clone.Anchored = true
			end
		end

		local tbl18 = {}

		for _, v19 in pairs({ tbl6.WorldOrigin.EnemySpawns, tbl6.Enemies, tbl5.ReplicatedStorage }) do
			for _, child in pairs(v19:GetChildren()) do
				table.insert(tbl18, child)
			end
		end

		for _, v19 in ipairs(tbl18) do
			fn9(v19)
		end

		local tbl19 = {}

		for _, child in ipairs(enemySpawns:GetChildren()) do
			local name = child.Name

			if not tbl19[name] then
				tbl19[name] = true

				if not enemyCDKSpawns:FindFirstChild(name) then
					local clone = child:Clone()
					clone.Parent = enemyCDKSpawns
					clone.Anchored = true
				end
			end
		end
	end)

	local tbl18

	tbl18 = {
		ValidateState = function(arg, arg2, arg3)
			if not arg2 then
				tbl18:HandleError(arg3 or "State validation failed")
				return false
			end
			return true
		end,
		HandleError = function(arg, arg2)
			if localPlayer.Name == "KXbMrzy" or localPlayer.Name == "fanoffgteev999" or localPlayer.Name == "blacjacqv" or localPlayer.Name == "Eljisoo951" then
				tbl5.Players.LocalPlayer.PlayerGui:SetCore("SendNotification", { Title = "System Error", Text = tostring(arg2), Icon = "rbxassetid://0", Duration = 5 })
			end
		end,
		CreateLoop = function(arg, arg2, arg3, arg4)
			local n3 = math.max(arg4 or 0, 0)
			if tbl17.__loops[arg2] then
				return
			end
			tbl17.__loops[arg2] = true
			tbl17.__metadata[arg2] = { start = tick(), errors = 0, runs = 0, lastRun = 0 }

			local function fn9()
				local ok3, result3 = pcall(arg3)
				local v19 = tbl17.__metadata[arg2]

				if v19 then
					if ok3 then
						v19.runs = v19.runs + 1
						v19.lastRun = tick()
					else
						v19.errors = v19.errors + 1
						tbl18:HandleError(result3)
					end
				end

				return ok3
			end

			tbl4.__spawn(function()
				while true do
					if tbl17.__loops[arg2] and tbl17.__running then
						if not v9.Unloaded then
							if tbl14[arg2] then
								fn9()
							end

							if n3 > 0 then
								task.wait(n3)
							else
								task.wait()
							end

							continue
						end
					end

					break
				end

				tbl17.__loops[arg2] = nil
				tbl17.__metadata[arg2] = nil
			end)
		end,
	}

	local tbl19 = {
		__features = {
			"Auto Farm Level",
			"Auto Farm Nearest",
			"Auto Farm Mastery",
			"Auto Collect Chest",
			"Auto Collect Berry",
			"Auto Factory",
			"Auto Attack Boss",
			"Auto Attack All Boss",
			"Auto Pirates Sea",
			"Auto Farm Material",
			"Auto Get Sword",
			"Auto Get Serpent Bow",
			"Auto Farm Bones",
			"Auto Cake Prince",
			"Auto Dough King",
			"Auto Elite Hunter",
			"Auto Soul Reaper",
			"Auto Citizen Quest",
			"Auto Summon Kitsune Island",
			"Tween to Kitsune Island",
			"Auto Collect Azure Ember",
			"Auto Farm Sea",
			"Tween to Frozen Dimension",
			"Auto Find Leviathan",
			"Auto Attack Leviathan",
			"Auto Attack Leviathan Segment",
			"Auto Attack Leviathan Tail",
			"Auto Wood Planks",
			"Tween To Island",
			"Auto Find Fruit",
			"Auto Gets Fruit Spawner",
			"Auto Summon Mirage Island",
			"Tween To Mirage Island",
			"Auto Raid",
			"Auto Collect Gift",
			"Auto Summon Prehistoric Island",
			"Tween To Prehistoric Island",
			"Auto Dragon Hunter Quests",
			"Auto Kill Player After Trial",
			"Auto Trial",
			"Auto V2",
			"Auto V3",
		},
	}

	tbl18.IsAnyFeatureActive = function()
		for i = 1, #tbl19.__features do
			if tbl14[tbl19.__features[i]] then
				return true
			end
		end

		return false
	end

	tbl18.FindNearestTeleporter = function(arg, arg2)
		local position = arg2.Position
		local placeId2 = game.PlaceId
		local tbl20 = {}

		if placeId2 == 7449423635 then
			tbl20 = {
				["Castle On The Sea"] = Vector3.new(-5058.775, 314.5155, -3155.8833),
				Hydra = Vector3.new(5756.8374, 610.424, -253.9254),
				Mansion = Vector3.new(-12463.874, 374.9145, -7523.774),
				["Great Tree"] = Vector3.new(28282.57, 14896.851, 105.1043),
				["Temple Clock"] = Vector3.new(28282.57, 14896.851, 105.10427),
			}
		elseif placeId2 == 4442272183 then
			tbl20 = {
				Mansion = Vector3.new(-288.4625, 306.1306, 597.9988),
				Flamingo = Vector3.new(2284.912, 15.152, 905.4829),
				["122"] = Vector3.new(923.2125, 126.976, 32852.832),
				["3032"] = Vector3.new(-6508.558, 89.035, -132.8395),
			}
		elseif placeId2 == 2753915549 then
			tbl20 = {
				["1"] = Vector3.new(-7894.62, 5545.4917, -380.2467),
				["2"] = Vector3.new(-4607.8228, 872.5423, -1667.5569),
				["3"] = Vector3.new(61163.85, 11.7595, 1819.7842),
				["4"] = Vector3.new(3876.2805, 35.1061, -1939.3202),
			}
		end

		if not next(tbl20) then
			return nil
		end
		local huge = math.huge
		local v19 = nil

		for _, v20 in pairs(tbl20) do
			local magnitude = (v20 - position).Magnitude

			if magnitude < huge then
				huge = magnitude
				v19 = v20
			end
		end

		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return nil
		end

		if huge <= (position - humanoidRootPart.Position).Magnitude then
			return v19
		end
		return nil
	end

	local tbl20 = { __activeController = nil }

	tbl18.CreateTweenController = function(arg, arg2)
		local tbl21 = {}
		if not arg2 or not arg2.Parent then
			return nil
		end
		local v19 = arg2
		local assemblyLinearVelocity = v19.AssemblyLinearVelocity
		local tbl22 = {}
		local tbl23 = {}
		local tween = nil
		local bodyVelocity = nil
		local flag = false
		local connection = nil

		local function fn9()
			if connection then
				connection:Disconnect()
				connection = nil
			end

			if tween then
				tween:Cancel()
				tween = nil
			end

			if bodyVelocity then
				bodyVelocity:Destroy()
				bodyVelocity = nil
			end

			for _, descendant in pairs(v19.Parent:GetDescendants()) do
				if descendant:IsA("BasePart") then
					if tbl22[descendant] ~= nil then
						descendant.CanCollide = tbl22[descendant]
					else
						descendant.CanCollide = true
					end

					tbl22[descendant] = nil

					if tbl23[descendant] ~= nil then
						descendant.Anchored = tbl23[descendant]
						tbl23[descendant] = nil
					end
				end
			end

			v19.AssemblyLinearVelocity = assemblyLinearVelocity
			v19.AssemblyAngularVelocity = Vector3.zero
			flag = false
		end

		tbl21.ExecuteTween = function(arg3, arg4, arg5)
			if flag then
				fn9()
			end

			assemblyLinearVelocity = v19.AssemblyLinearVelocity

			for _, descendant in pairs(v19.Parent:GetDescendants()) do
				if descendant:IsA("BasePart") then
					tbl22[descendant] = descendant.CanCollide
					tbl23[descendant] = descendant.Anchored
					descendant.CanCollide = false
				end
			end

			v19.AssemblyLinearVelocity = Vector3.zero
			v19.AssemblyAngularVelocity = Vector3.zero
			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
			bodyVelocity.Velocity = Vector3.zero
			bodyVelocity.Parent = v19
			local n3 = math.max(0.05, (v19.CFrame.Position - arg4.Position).Magnitude / math.max(arg5 or 100, 0.01))
			flag = true
			tween = tbl5.TweenService:Create(v19, TweenInfo.new(n3, Enum.EasingStyle.Linear), { CFrame = arg4 })

			connection = tween.Completed:Connect(function()
				fn9()
			end)

			tween:Play()
		end

		tbl21.Destroy = function()
			fn9()
		end

		return tbl21
	end

	tbl18.ExecuteTween = function(arg, arg2, arg3)
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return
		end

		if tbl20.__activeController then
			pcall(function()
				tbl20.__activeController:Destroy()
			end)
		end

		tbl20.__activeController = tbl18:CreateTweenController(character)
		local n3 = tonumber(arg3) or tonumber(tbl14["Tween Speed"]) or 100

		if n3 <= 0 then
			n3 = 100
		end

		local position = arg2.Position

		if (Vector3.new(10213.701, -1733.5026, 9940.189) - position).Magnitude <= 3500 and localPlayer:DistanceFromCharacter(Vector3.new(10213.701, -1733.5026, 9940.189)) > 3500 then
			if localPlayer:DistanceFromCharacter(Vector3.new(-16267, 25, 1371)) > 5 then
				tbl20.__activeController:ExecuteTween(CFrame.new(-16267, 25, 1371), n3)
			else
				tbl5.ReplicatedStorage.Modules.Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
			end

			return
		end

		if localPlayer:GetAttribute("CurrentLocation") == "Submerged Island" and (Vector3.new(10213.701, -1733.5026, 9940.189) - position).Magnitude > 3500 then
			if localPlayer:DistanceFromCharacter(Vector3.new(11426, -2155, 9730)) > 5 then
				tbl20.__activeController:ExecuteTween(CFrame.new(11426, -2155, 9730), n3)
			else
				tbl5.ReplicatedStorage.Modules.Net:FindFirstChild("RF/SubmarineTransportation"):InvokeServer("InitiateTeleport", "Tiki Outpost")
			end

			return
		end

		if not _G.Teleporting then
			local v19 = tbl18:FindNearestTeleporter(arg2)

			if v19 then
				_G.Teleporting = true
				character.AssemblyLinearVelocity = Vector3.zero
				character.AssemblyAngularVelocity = Vector3.zero
				tbl5.ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", v19)

				task.delay(1, function()
					_G.Teleporting = false
				end)

				return
			end
		end

		if tbl20.__activeController then
			tbl20.__activeController:ExecuteTween(arg2, n3)
		end
	end

	tbl18.StopTween = function(arg, arg2)
		tbl4.__spawn(function()
			if not arg2 then
				if tbl20.__activeController then
					tbl20.__activeController:Destroy()
					tbl20.__activeController = nil
				end
			end
		end)
	end

	local tbl21 = {
		__connection = nil,
		__characterConnection = nil,
		__currentCharacter = nil,
		__lastUpdate = 0,
		__updateInterval = 0.2,
		__disabledParts = {},
	}

	local function fn9(arg)
		if not arg or not arg.Parent then
			return
		end

		for _, descendant in pairs(arg:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant.CanCollide then
				if not tbl21.__disabledParts[descendant] then
					tbl21.__disabledParts[descendant] = true
					descendant.CanCollide = false
				end
			end
		end

		if tbl21.__characterConnection then
			tbl21.__characterConnection:Disconnect()
			tbl21.__characterConnection = nil
		end

		tbl21.__characterConnection = arg.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("BasePart") and descendant.CanCollide then
				if not tbl21.__disabledParts[descendant] then
					tbl21.__disabledParts[descendant] = true

					task.defer(function()
						descendant.CanCollide = false
					end)
				end
			end
		end)
	end

	local function fn10(arg)
		if not arg then
			return
		end

		for k in pairs(tbl21.__disabledParts) do
			if k and k.Parent and k:IsA("BasePart") then
				k.CanCollide = true
			end

			tbl21.__disabledParts[k] = nil
		end

		if tbl21.__characterConnection then
			tbl21.__characterConnection:Disconnect()
			tbl21.__characterConnection = nil
		end
	end

	tbl21.__connection = tbl5.RunService.Stepped:Connect(function()
		local now2 = tick()
		if now2 - tbl21.__lastUpdate < tbl21.__updateInterval then
			return
		end
		tbl21.__lastUpdate = now2
		local character = localPlayer.Character

		if v9.Unloaded then
			tbl21.__connection:Disconnect()

			if tbl21.__characterConnection then
				tbl21.__characterConnection:Disconnect()
				tbl21.__characterConnection = nil
			end

			fn10(tbl21.__currentCharacter)
			return
		end

		if tbl18:IsAnyFeatureActive() and character and character ~= tbl21.__currentCharacter then
			if tbl21.__currentCharacter then
				fn10(tbl21.__currentCharacter)
			end

			tbl21.__currentCharacter = character
			fn9(character)
		elseif not tbl18:IsAnyFeatureActive() and tbl21.__currentCharacter then
			fn10(tbl21.__currentCharacter)
			tbl21.__currentCharacter = nil
		end
	end)

	tbl18.TweenToTargetIfFar = function(arg, arg2, arg3)
		if tbl18:GetDistance(arg2) > arg3 then
			tbl18:ExecuteTween(arg2)
			return true
		end
		return false
	end

	tbl18.ExecuteBoatTween = function(arg, arg2, arg3)
		if not (arg2 and arg2.PrimaryPart and arg3) then
			return
		end
		local primaryPart = arg2.PrimaryPart

		if not primaryPart:FindFirstChild("Speed_Hub_X_Boat_BodyVelocity") then
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Name = "Speed_Hub_X_Boat_BodyVelocity"
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Velocity = Vector3.zero
			bodyVelocity.Parent = primaryPart
		end

		local linear = Enum.EasingStyle.Linear
		local out = Enum.EasingDirection.Out
		local tween = tbl5.TweenService:Create(primaryPart, TweenInfo.new(math.max(0.1, (primaryPart.Position - arg3.p).Magnitude / 250), linear, out), { CFrame = arg3 })

		pcall(function()
			tween:Play()
		end)
	end

	tbl18.ServerHop = function(arg, text, arg2)
		local n3 = arg2 or tonumber(tbl14["Count Player"]) or 5
		text = text or "Singapore"

		for i = 1, 100 do
			pcall(function()
				playerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox.Text = text
			end)

			local response = tbl5.ReplicatedStorage.__ServerBrowser:InvokeServer(i)

			for k, v19 in pairs(response) do
				if k ~= game.JobId and v19.Count <= n3 and not string.find(tostring(v19.Private), "true") then
					tbl4.__spawn(function()
						tbl5.ReplicatedStorage.__ServerBrowser:InvokeServer("teleport", k)
					end)
				end
			end
		end
	end

	tbl18.FireRemote = function(...)
		return tbl6.CommF_:InvokeServer(select(2, ...))
	end

	tbl18.IsEntityAlive = function(arg, arg2)
		local humanoid = arg2:FindFirstChild("Humanoid")
		return humanoid and humanoid.Health > 0
	end

	tbl18.GetDistance = function(arg, arg2)
		local character = localPlayer.Character
		if not character or not character.PrimaryPart then
			return math.huge
		end
		local position

		if typeof(arg2) == "CFrame" then
			position = arg2.Position
		else
			if typeof(arg2) ~= "Vector3" then
				return math.huge
			end
			position = arg2
		end

		return (character.PrimaryPart.Position - position).Magnitude
	end

	tbl18.ActivateHaki = function()
		local character = localPlayer.Character

		if not character or not character:FindFirstChild("HasBuso") then
			tbl18:FireRemote("Buso")
		end
	end

	tbl18.EquipToolByName = function(arg, arg2)
		local backpack = localPlayer.Backpack
		local character = localPlayer.Character
		if not (backpack and character) then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local v19 = backpack:FindFirstChild(arg2)

		if humanoid and v19 and v19:IsA("Tool") then
			humanoid:EquipTool(v19)
		end
	end

	tbl18.EquipToolByTip = function(arg, arg2)
		local backpack = localPlayer.Backpack
		if not backpack then
			return
		end
		local children = backpack:GetChildren()

		for i = 1, #children do
			local v19 = children[i]
			if v19:IsA("Tool") and v19.ToolTip == arg2 then
				tbl18:EquipToolByName(v19.Name)
				return
			end
		end
	end

	tbl18.EquipSelectedTool = function()
		local backpack = localPlayer.Backpack
		if not backpack then
			return
		end
		local weaponTool = tbl14["Weapon Tool"]
		local children = backpack:GetChildren()

		for i = 1, #children do
			local v19 = children[i]
			if v19:IsA("Tool") and v19.ToolTip == weaponTool then
				tbl18:EquipToolByName(v19.Name)
				return
			end
		end
	end

	tbl18.UnequipTool = function(arg, arg2)
		local character = localPlayer.Character
		if not character then
			return
		end
		local v19 = character:FindFirstChild(arg2)

		if v19 and v19:IsA("Tool") then
			v19.Parent = localPlayer.Backpack
		end
	end

	tbl18.HasTool = function(arg, arg2)
		local character = localPlayer.Character
		if not character then
			return false
		end
		return character:FindFirstChild(arg2) ~= nil or localPlayer.Backpack:FindFirstChild(arg2) ~= nil
	end

	tbl18.FindToolByTip = function(arg, arg2)
		local function fn11(arg3)
			if not arg3 then
				return nil
			end
			local children = arg3:GetChildren()

			for i = 1, #children do
				local v19 = children[i]
				if v19:IsA("Tool") and v19.ToolTip == arg2 then
					return v19
				end
			end

			return nil
		end

		return fn11(localPlayer.Backpack) or fn11(localPlayer.Character)
	end

	tbl18.SendKeyPress = function(arg, arg2, arg3)
		local n3 = arg3 or 0
		tbl5.VirtualInputManager:SendKeyEvent(true, arg2, false, game)

		if n3 > 0 then
			task.wait(n3)
		end

		tbl5.VirtualInputManager:SendKeyEvent(false, arg2, false, game)
	end

	local tbl22 = {
		["rbxassetid://9802959564"] = true,
		["rbxassetid://507766388"] = true,
		["http://www.roblox.com/asset/?id=9884584522"] = true,
	}

	tbl18.MonitorSkillUsage = function(arg, arg2)
		if not arg2 or not arg2.Parent then
			return
		end
		local humanoid = arg2:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end
		local animator = humanoid:FindFirstChildOfClass("Animator")
		if not animator then
			return
		end

		animator.AnimationPlayed:Connect(function(arg3)
			if not arg3 or not arg3.Animation then
				return
			end

			if tbl22[arg3.Animation.AnimationId] then
				return
			end
			local n3 = math.max(arg3.TimePosition or 1.5, 1.5)

			if tbl14["Auto Dodge Skill"] then
				local dodgeTime = _G.DodgeTime or 0

				if tick() < dodgeTime then
					_G.DodgeTime = dodgeTime + math.floor(n3)
				else
					_G.DodgeTime = tick() + math.floor(n3)
				end
			end
		end)
	end

	tbl18.isInTable = function(arg, arg2, arg3)
		for _, v19 in pairs(arg2) do
			if v19 == arg3 then
				return true
			end
		end

		return false
	end

	tbl18.converttoTable = function(arg, arg2)
		local tbl23 = {}

		for match in arg2:gmatch("[^%[%],%s]+") do
			local str2 = match:gsub("^'", ""):gsub("'$", "")

			if tonumber(str2) then
				table.insert(tbl23, tonumber(str2))
			else
				table.insert(tbl23, str2)
			end
		end

		return tbl23
	end

	tbl18.smartBossTeleport = function(arg, arg2, arg3, arg4, arg5)
		for _, v19 in pairs(arg2) do
			if arg:isInTable(v19, arg3) then
				if arg4 and arg4 ~= "" then
					local v20 = v9
					local setNotification = v20.SetNotification
					local tbl23 = {}
					local str2 = "JobId: " .. tostring(arg4) .. " | Boss: " .. tostring(arg3)
					tbl23[1] = "Speed Hub X"
					tbl23[2] = "Hop Boss"
					tbl23[3] = str2
					tbl23[4] = 5
					tbl23[5] = 0.5
					setNotification(v20, tbl23)
					task.wait(1)
					game:GetService("TeleportService"):TeleportToPlaceInstance(arg5, arg4, localPlayer)
					return
				end
			end
		end
	end

	tbl18.bossData = function(arg, arg2)
		local tbl23 = {}
		local request_ = syn and syn.request
		local request_2

		if request_ then
			request_2 = request_
		else
			request_2 = http and http.request
		end

		local v19 = (request_2 or http_request or request)({ Url = "https://prvf.onrender.com/data", Method = "GET" })
		if not v19 or not v19.Body then
			return {}
		end
		local data = game:GetService("HttpService"):JSONDecode(v19.Body)

		for k, v20 in pairs(data) do
			for _, v21 in v20, nil, nil do
				if v21 == arg2 then
					tbl23[#tbl23 + 1] = { id = k, name = v20 }
				end
			end
		end

		local n3 = math.random(1, #tbl23)
		return #tbl23 > 0 and tbl23[n3]
	end

	local str2 = tostring(localPlayer.UserId):sub(2, 4) .. "078da"

	local function fn11()
		local ok3, result3 = pcall(function()
			local global = tbl5.ReplicatedStorage and tbl5.ReplicatedStorage:FindFirstChild("Global")

			if global then
				for _, v19 in pairs(getupvalues(require(global).SendHitsToServer)) do
					if type(v19) == "thread" and coroutine.status(v19) ~= "dead" then
						return v19
					end
				end
			end
		end)

		return ok3 and result3 or nil
	end

	local tbl23

	tbl23 = {
		__cache = {
			enemy = { t = 0, list = {} },
			enemySnapshot = { t = 0, list = nil },
			attack = { t = 0, isAttacking = false, lastGunTime = 0, hit = { [2] = {} } },
		},
		__m1State = { last = 0, delay = 0 },
		__animCache = {},
		__snapshotExpiry = 0,
		__cachedSnapshot = nil,
		__range = 4225,
		__cacheInterval = 0.5,
		ExecuteFruitM1 = function(arg, arg2)
			local ok3, result3 = pcall(function()
				local now2 = tick()
				local last = tbl23.__m1State.last or 0
				local delay_ = tbl23.__m1State.delay or 0
				local delay_2

				if now2 - last <= 0.4 then
					delay_2 = math.min(delay_ + 1, 4)
				else
					delay_2 = 1
				end

				tbl23.__m1State.last = now2
				tbl23.__m1State.delay = delay_2
				local character = localPlayer.Character
				if not character then
					return
				end
				local primaryPart = character.PrimaryPart
				if not primaryPart then
					return
				end
				local position = primaryPart.Position
				local children = tbl6.Enemies and tbl6.Enemies:GetChildren() or {}

				for i = 1, #children do
					local v19 = children[i]

					if v19 and v19.Parent then
						local primaryPart2 = v19.PrimaryPart

						if primaryPart2 and tbl18 and tbl18:IsEntityAlive(v19) then
							local n3 = primaryPart2.Position.X - position.X
							local n4 = primaryPart2.Position.Y - position.Y
							local n5 = primaryPart2.Position.Z - position.Z

							if n3 * n3 + n4 * n4 + n5 * n5 <= 2500 then
								arg2.LeftClickRemote:FireServer((primaryPart2.Position - position).Unit, delay_2)
							end
						end
					end
				end
			end)

			if not ok3 then
				warn("[FruitM1 Error]: " .. tostring(result3))
			end
		end,
	}

	local thread = coroutine.create(function()
		pcall(function()
			if not tbl7.RegisterHit then
				return
			end
			tbl7.RegisterHit:FireServer(str2)

			while true do
				local v19, v20 = coroutine.yield()
				tbl7.RegisterHit:FireServer(v19, v20, nil, str2)
			end
		end)
	end)

	coroutine.resume(thread)

	tbl23.GetHits = function(arg, arg2)
		local tbl24 = {}
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return tbl24
		end

		for _, v19 in ipairs({ workspace.Enemies, workspace.Characters }) do
			for _, child in ipairs(v19:GetChildren()) do
				local humanoid = child:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")

				if child ~= character and humanoid and humanoidRootPart2 and humanoid.Health > 0 and (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude <= arg2 then
					local insert = table.insert
					local tbl25 = {}
					local head = child:FindFirstChild("Head") or humanoidRootPart2
					tbl25[1] = child
					tbl25[2] = head
					insert(tbl24, tbl25)
				end
			end
		end

		return tbl24
	end

	tbl23.ExecuteAttack = function(arg)
		local character = localPlayer.Character
		local tool = character and character:FindFirstChildOfClass("Tool")
		if not (tool and table.find({ "Melee", "Sword", "Blox Fruit", "Gun" }, tool.ToolTip)) then
			return
		end
		local hits = arg:GetHits(60)

		if #hits > 0 then
			tbl7.RegisterAttack:FireServer(0)
			local v19 = table.remove(hits, 1)[2]
			local v20 = fn11() or thread

			if v20 then
				coroutine.resume(v20, v19, hits)
			else
				tbl7.RegisterHit:FireServer(v19, hits, nil, str2)
			end
		end
	end

	tbl18.ExecuteBladeHits = function()
		xpcall(function()
			local character = localPlayer.Character
			if not character then
				return
			end
			local tool = character:FindFirstChildWhichIsA("Tool")
			if not tool then
				return
			end
			local toolTip = tool.ToolTip

			if toolTip == "Blox Fruit" and tool:FindFirstChild("LeftClickRemote") then
				tbl23:ExecuteFruitM1(tool)
			elseif toolTip ~= "Gun" then
				tbl23:ExecuteAttack()
			else
				task.wait(0.5)
			end
		end, function(arg)
			warn("[ExecuteBladeHits Error]: " .. tostring(arg))
			tbl23.__cache.attack.isAttacking = false
		end)
	end

	tbl18.InteractWithMirror = function()
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return
		end
		local main = tbl5.Workspace.Map.CakeLoaf.BigMirror.Main
		firetouchinterest(character, main, 0)
		task.wait()
		firetouchinterest(character, main, 1)
	end

	tbl18.CheckStackPriority = function(arg, arg2)
		if not tbl14["Stack Farming Enabled"] then
			return true
		end
		local tbl24 = {}

		local tbl25 = {
			name = "Auto Farm Level",
			priority = tonumber(tbl14["Priority: Auto Farm Level"]) or 1,
			check = function()
				if not tbl14["Auto Farm Level"] then
					return false
				end

				local ok3, result3 = pcall(function()
					return tbl18:GetQuestInfo(tbl14["Auto Farm Level"])
				end)

				if not ok3 or not result3 or not result3[3] then
					return false
				end
				return tbl18:FindEnemy({ result3[3] }) ~= nil
			end,
		}

		local tbl26 = {
			name = "Auto Farm Nearest",
			priority = tonumber(tbl14["Priority: Auto Farm Nearest"]) or 2,
			check = function()
				if not tbl14["Auto Farm Nearest"] then
					return false
				end

				for _, child in pairs(tbl6.Enemies:GetChildren()) do
					if child and tbl18:IsEntityAlive(child) and child:FindFirstChild("HumanoidRootPart") then
						return true
					end
				end

				return false
			end,
		}

		local tbl27 = {
			name = "Auto Farm Mastery",
			priority = tonumber(tbl14["Priority: Auto Farm Mastery"]) or 3,
			check = function()
				if not tbl14["Auto Farm Mastery"] then
					return false
				end

				if not tbl14["Choose Mastery Mode"] then
					return false
				end
				local chooseMasteryMode = tbl14["Choose Mastery Mode"]

				if chooseMasteryMode == "Level" then
					local ok3, result3 = pcall(function()
						return tbl18:GetQuestInfo(tbl14["Auto Farm Mastery"])
					end)

					if ok3 and result3 and result3[3] then
						return tbl18:FindEnemy({ result3[3] }) ~= nil
					end
				else
					if chooseMasteryMode == "Bone" then
						return tbl18:FindEnemy({ "Reborn Skeleton", "Demonic Soul", "Living Zombie", "Possessed Mummy" }) ~= nil
					end

					if chooseMasteryMode == "Cake Prince" then
						return tbl18:FindEnemy({ "Baking Staff", "Head Baker", "Cake Guard", "Cookie Crafter" }) ~= nil
					end

					if chooseMasteryMode == "Neareast" then
						for _, child in pairs(tbl6.Enemies:GetChildren()) do
							if child and tbl18:IsEntityAlive(child) and child:FindFirstChild("HumanoidRootPart") then
								return true
							end
						end
					end
				end

				return false
			end,
		}

		local tbl28 = {
			name = "Auto Collect Chest",
			priority = tonumber(tbl14["Priority: Auto Collect Chest"]) or 4,
			check = function()
				if not tbl14["Auto Collect Chest"] then
					return false
				end
				local tagged = tbl5.CollectionService:GetTagged("_ChestTagged")
				local flag = false

				for _, v19 in ipairs(tagged) do
					v19 = v19 and not v19:GetAttribute("IsDisabled")
					if v19 then
						flag = true
						break
					end
				end

				return flag
			end,
		}

		local tbl29 = {
			name = "Auto Collect Berry",
			priority = tonumber(tbl14["Priority: Auto Collect Berry"]) or 5,
			check = function()
				if not tbl14["Auto Collect Berry"] then
					return false
				end

				for _, descendant in pairs(tbl5.Workspace.Map:GetDescendants()) do
					if descendant.Name ~= "Berries" then
						continue
					end

					for i = 1, 8 do
						if descendant:GetAttribute("_BerryCFrame" .. i) then
							return true
						end
					end
				end

				return false
			end,
		}

		local tbl30 = {
			name = "Auto Farm Material",
			priority = tonumber(tbl14["Priority: Auto Farm Material"]) or 6,
			check = function()
				if not tbl14["Auto Farm Material"] then
					return false
				end
				local chooseMaterial = tbl14["Choose Material"]
				if not chooseMaterial or chooseMaterial == "" then
					return false
				end
				local materialData = tbl18:GetMaterialData(chooseMaterial)
				if not materialData or not materialData.NPCs then
					return false
				end
				return tbl18:FindEnemy(materialData.NPCs) ~= nil
			end,
		}

		local tbl31 = {
			name = "Auto Farm Bones",
			priority = tonumber(tbl14["Priority: Auto Farm Bones"]) or 7,
			check = function()
				if not tbl14["Auto Farm Bones"] then
					return false
				end
				return tbl18:FindEnemy({ "Soul Reaper" }) ~= nil or tbl18:FindEnemy({ "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Possessed Mummy" }) ~= nil
			end,
		}

		local tbl32 = {
			name = "Auto Attack Boss",
			priority = tonumber(tbl14["Priority: Auto Attack Boss"]) or 8,
			check = function()
				if not tbl14["Auto Attack Boss"] then
					return false
				end
				local chooseBoss = tbl14["Choose Boss"]
				if not chooseBoss or chooseBoss == "" then
					return false
				end
				return tbl18:FindEnemy({ chooseBoss }) ~= nil
			end,
		}

		local tbl33 = {
			name = "Auto Attack All Boss",
			priority = tonumber(tbl14["Priority: Auto Attack All Boss"]) or 9,
			check = function()
				if not tbl14["Auto Attack All Boss"] then
					return false
				end

				for _, child in pairs(tbl5.ReplicatedStorage:GetChildren()) do
					if child and child:GetAttribute("IsBoss") and child:FindFirstChild("HumanoidRootPart") then
						return true
					end
				end

				for _, child in pairs(tbl6.Enemies:GetChildren()) do
					if child and child:GetAttribute("IsBoss") and tbl18:IsEntityAlive(child) and child:FindFirstChild("HumanoidRootPart") then
						return true
					end
				end

				return false
			end,
		}

		local tbl34 = {
			name = "Auto Soul Reaper",
			priority = tonumber(tbl14["Priority: Auto Soul Reaper"]) or 10,
			check = function()
				if not tbl14["Auto Soul Reaper"] then
					return false
				end
				return tbl18:FindEnemy({ "Soul Reaper" }) ~= nil or tbl18:HasTool("Hallow Essence")
			end,
		}

		local tbl35 = {
			name = "Auto Elite Hunter",
			priority = tonumber(tbl14["Priority: Auto Elite Hunter"]) or 11,
			check = function()
				if not tbl14["Auto Elite Hunter"] then
					return false
				end
				return tbl18:FindEnemy({ "Diablo", "Deandre", "Urban" }) ~= nil or tbl18:isQuestOn()
			end,
		}

		local tbl36 = {
			name = "Auto Kill Tyrant of the Skies",
			priority = tonumber(tbl14["Priority: Auto Kill Tyrant of the Skies"]) or 12,
			check = function()
				if not tbl14["Auto Kill Tyrant of the Skies"] then
					return false
				end
				return tbl18:FindEnemy({ "Auto Kill Tyrant of the Skies" }) ~= nil
			end,
		}

		local tbl37 = {
			name = "Auto Citizen Quest",
			priority = tonumber(tbl14["Priority: Auto Citizen Quest"]) or 13,
			check = function()
				if not tbl14["Auto Citizen Quest"] then
					return false
				end
				return tbl18:FindEnemy({ "Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate" }) ~= nil
			end,
		}

		local tbl38 = {
			name = "Auto Dough King",
			priority = tonumber(tbl14["Priority: Auto Dough King"]) or 14,
			check = function()
				if not tbl14["Auto Dough King"] then
					return false
				end
				return tbl18:HasTool("God's Chalice") or tbl18:HasTool("Sweet Chalice") or tbl18:FindEnemy({ "Dough King" }) ~= nil
			end,
		}

		local tbl39 = {
			name = "Auto Cake Prince",
			priority = tonumber(tbl14["Priority: Auto Cake Prince"]) or 15,
			check = function()
				if not tbl14["Auto Cake Prince"] then
					return false
				end
				return tbl18:FindEnemy({ "Cake Prince", "Dough King" }) ~= nil or tbl18:FindEnemy({ "Baking Staff", "Head Baker", "Cake Guard", "Cookie Crafter" }) ~= nil
			end,
		}

		tbl24[1] = tbl25
		tbl24[2] = tbl26
		tbl24[3] = tbl27
		tbl24[4] = tbl28
		tbl24[5] = tbl29
		tbl24[6] = tbl30
		tbl24[7] = tbl31
		tbl24[8] = tbl32
		tbl24[9] = tbl33
		tbl24[10] = tbl34
		tbl24[11] = tbl35
		tbl24[12] = tbl36
		tbl24[13] = tbl37
		tbl24[14] = tbl38
		tbl24[15] = tbl39
		local v19, v20, v21 = ipairs(tbl24)
		local v22 = nil

		for _, v23 in v19, v20, v21 do
			if v23.name == arg2 then
				v22 = v23
				break
			else
				v22 = nil
			end
		end

		if not v22 or not tbl14[arg2] then
			return false
		end
		local priority = v22.priority

		for _, v23 in ipairs(tbl24) do
			if tbl14[v23.name] and v23.priority < priority then
				local ok3, result3 = pcall(v23.check)
				if ok3 and result3 then
					return false
				end
			end
		end

		return true
	end

	tbl18.BringEnemyToPosition = function(arg, arg2, cFrame)
		if not tbl14["Bring Mob"] then
			return
		end

		if not arg2 or not arg2.Parent or not cFrame then
			return
		end
		local n3 = tonumber(tbl14["Bring Mob Radius"]) or 300
		local n4 = n3 * n3
		local position = cFrame.Position

		pcall(function()
			sethiddenproperty(localPlayer, "SimulationRadius", math.huge)
			sethiddenproperty(localPlayer, "MaxSimulationRadius", math.huge)
		end)

		local children = tbl6.Enemies:GetChildren()

		for i = 1, #children do
			local v19 = children[i]

			if v19 and v19.Name == arg2.Name and not table.find({ "Shark", "Piranha", "Terrorshark" }, v19.Name) then
				local humanoid = v19:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart = v19:FindFirstChild("HumanoidRootPart")
				local characterReady = v19:FindFirstChild("CharacterReady")

				if humanoid and humanoidRootPart and characterReady and humanoid.Health > 0 and humanoidRootPart:IsDescendantOf(tbl5.Workspace) then
					local n5 = humanoidRootPart.Position.X - position.X
					local n6 = humanoidRootPart.Position.Y - position.Y
					local n7 = humanoidRootPart.Position.Z - position.Z

					if n5 * n5 + n6 * n6 + n7 * n7 <= n4 then
						if not humanoidRootPart:GetAttribute("BeingBrought") then
							humanoidRootPart:SetAttribute("BeingBrought", true)
							humanoidRootPart.CanCollide = false
							humanoidRootPart.Massless = true
							local descendants = v19:GetDescendants()

							for i2 = 1, #descendants do
								local v20 = descendants[i2]

								if v20:IsA("BasePart") then
									v20.CanCollide = false
									v20.CanTouch = false
									v20.Massless = true
									v20.AssemblyLinearVelocity = Vector3.zero
									v20.AssemblyAngularVelocity = Vector3.zero
								end
							end

							local lock = humanoidRootPart:FindFirstChild("Lock")

							if not lock or not lock.Parent then
								lock = Instance.new("BodyVelocity")
								lock.Name = "Lock"
								lock.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
								lock.P = 9000
								lock.Velocity = Vector3.zero
								lock.Parent = humanoidRootPart
							end

							local bringGyro = humanoidRootPart:FindFirstChild("BringGyro")

							if not bringGyro or not bringGyro.Parent then
								bringGyro = Instance.new("BodyGyro")
								bringGyro.Name = "BringGyro"
								bringGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
								bringGyro.P = 30000
								bringGyro.D = 1000
								bringGyro.Parent = humanoidRootPart
							end

							lock.P = 9000
							bringGyro.CFrame = cFrame
							humanoid.AutoRotate = false
							humanoid.PlatformStand = false
							humanoid.BreakJointsOnDeath = false

							pcall(function()
								humanoid:ChangeState(Enum.HumanoidStateType.Physics)
							end)

							humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
							humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

							tbl4.__spawn(function()
								local n8 = position + Vector3.new(math.random(-20, 20) / 100, math.random(-20, 20) / 100, math.random(-20, 20) / 100)
								local n9 = n8 - humanoidRootPart.Position
								local magnitude = n9.Magnitude

								if magnitude > 0.5 then
									lock.Velocity = n9.Unit * math.clamp(magnitude * 10, 20, 1200)
								else
									lock.Velocity = Vector3.zero

									pcall(function()
										humanoidRootPart.CFrame = CFrame.new(n8)
									end)
								end

								bringGyro.CFrame = cFrame
								humanoid.AutoRotate = false
								humanoid.PlatformStand = false
								humanoid.BreakJointsOnDeath = false

								pcall(function()
									humanoid:ChangeState(Enum.HumanoidStateType.Physics)
								end)

								humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
								humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
								task.wait(0.12)

								pcall(function()
									if lock and lock.Parent then
										lock:Destroy()
									end

									if bringGyro and bringGyro.Parent then
										bringGyro:Destroy()
									end

									if humanoidRootPart and humanoidRootPart.Parent then
										humanoidRootPart:SetAttribute("BeingBrought", false)
									end
								end)
							end)
						end
					end
				end
			end
		end
	end

	local tbl24 = {}

	updateES = function()
		for _, child in pairs(tbl5.ReplicatedStorage.FortBuilderReplicatedSpawnPositionsFolder:GetChildren()) do
			if child:IsA("Part") and child:GetAttribute("Active") then
				tbl24[child.Name] = child:GetPivot()
			end
		end
	end

	updateES()

	getEnemySpawn = function(arg)
		for k, v19 in tbl24, nil, nil do
			if k == arg then
				return v19
			end
		end
	end

	local tbl25 = {}

	tbl18.FindEnemy = function(arg, arg2, arg3, arg4)
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return nil
		end
		local position = character.Position
		local huge = arg3 and arg3 * arg3 or math.huge
		local tbl26 = {}

		for _, v19 in ipairs(arg2) do
			tbl26[v19] = true
		end

		local children = tbl6.Enemies:GetChildren()
		local v19 = nil

		for i = 1, #children do
			local v20 = children[i]
			local humanoid = v20:FindFirstChild("Humanoid")

			if humanoid and humanoid.Health > 0 then
				local match = tbl25[v20.Name] or v20.Name:match("^(.-)%s*%[") or v20.Name
				tbl25[v20.Name] = match

				if tbl26[match] then
					local vehicleSeat = arg4 == "Boat" and v20:FindFirstChild("VehicleSeat") or v20:FindFirstChild("HumanoidRootPart")

					if vehicleSeat then
						local n3 = vehicleSeat.Position.X - position.X
						local n4 = vehicleSeat.Position.Y - position.Y
						local n5 = vehicleSeat.Position.Z - position.Z
						local n6 = n3 * n3 + n4 * n4 + n5 * n5

						if n6 < huge then
							huge = n6
							v19 = v20
						end
					end
				end
			end
		end

		return v19
	end

	local tbl26 = { angle = 0, radius = 35 }

	local function fn12(arg)
		tbl26.angle = (tbl26.angle + 5) % 360
		local v19 = math.rad(tbl26.angle)
		local n3 = tonumber(tbl14["Farm Distance"]) or 20
		local radius = tbl26.radius
		local radius2 = tbl26.radius
		return arg + Vector3.new(math.sin(v19) * radius, n3, math.cos(v19) * radius2)
	end

	local function fn13(arg)
		return fn12(arg)
	end

	tbl18.EngageEnemy = function(arg, arg2)
		for _, child in pairs(tbl6.Enemies:GetChildren()) do
			if child and table.find(arg2, child.Name) then
				local primaryPart = child.PrimaryPart
				local cFrame = primaryPart and primaryPart.CFrame

				if primaryPart and tbl18:IsEntityAlive(child) then
					tbl18:MonitorSkillUsage(child)

					while true do
						tbl5.RunService.Heartbeat:Wait()

						if not _G.DodgeTime or _G.DodgeTime < tick() then
							tbl18:EquipSelectedTool()
							tbl18:ActivateHaki()
							tbl18:BringEnemyToPosition(child, cFrame)
							tbl18:ExecuteTween(fn13(cFrame))
						else
							localPlayer.Character.PrimaryPart.CFrame = child.PrimaryPart.CFrame * CFrame.new(0, 500, 0)
						end

						if not (not tbl18:IsAnyFeatureActive() or v9.Unloaded or not child or not child.Parent or not tbl18:IsEntityAlive(child)) then
							continue
						end
						break
					end
				end
			end
		end

		for _, child in pairs(tbl5.ReplicatedStorage:GetChildren()) do
			if table.find(arg2, child.Name) and child and child.PrimaryPart then
				tbl18:ExecuteTween(CFrame.new(child.PrimaryPart.CFrame.Position + Vector3.new(0, tbl14["Farm Distance"], 10)))
			end
		end
	end

	tbl18.GetQuestInfo = function()
		local value = localPlayer.Data.Level.Value
		local str3 = tostring(localPlayer.Team)
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		local n3 = nil
		local cframe = nil
		local str4 = nil
		local str5 = nil
		local n4 = nil
		local str6 = nil

		local function fn14()
			return { n3, cframe, str4, str5, n4, str6 }
		end

		if value >= 1 and value <= 9 then
			if str3 == "Marines" then
				n3 = 1
				str5 = "MarineQuest"
				str4 = "Trainee"
				str6 = "Trainee"
				cframe = CFrame.new
				cframe = cframe(-2709.67944, 24.5206585, 2104.24585)
			else
				n3 = 1
				str5 = "BanditQuest1"
				str4 = "Bandit"
				str6 = "Bandit"
				cframe = CFrame.new
				cframe = cframe(1059.99731, 16.9222069, 1549.28162)
			end

			n4 = 1
			return (fn14())
		end

		if value >= 210 and value <= 249 then
			n3 = 2
			str5 = "PrisonerQuest"
			str4 = "Dangerous Prisoner"
			str6 = "Dangerous Prisoner"
			n4 = 210
			cframe = CFrame.new
			cframe = cframe(5308.93115, 1.65517521, 475.120514)
			return (fn14())
		end

		n4 = 0

		for k, v19 in pairs(require(tbl5.ReplicatedStorage.GuideModule).Data.NPCList) do
			local levels = v19.Levels

			for i = 1, #levels do
				local v20 = levels[i]

				if value >= v20 and v20 > n4 then
					n4 = v20
					n3 = #levels == 3 and i == 3 and 2 or i
					cframe = k.CFrame
				end
			end
		end

		if character and cframe then
			local magnitude = (cframe.Position - character.Position).Magnitude

			if value >= 375 and value <= 449 and magnitude > 3000 then
				tbl18:FireRemote("requestEntrance", Vector3.new(61163.85, 11.6797, 1819.7842))
			elseif value >= 450 and value <= 474 and magnitude > 3000 then
				tbl18:FireRemote("requestEntrance", Vector3.new(-4607.8228, 872.5425, -1667.5569))
			elseif value >= 475 and value <= 624 and magnitude > 5000 then
				tbl18:FireRemote("requestEntrance", Vector3.new(-7894.6177, 5547.1416, -380.2912))
			end
		end

		local Quests = require(tbl5.ReplicatedStorage.Quests)

		for k, Quest in pairs(Quests) do
			if k ~= "CitizenQuest" then
				for k2, v19 in pairs(Quest) do
					if v19.LevelReq == n4 then
						str5 = k
						n3 = k2

						for k3 in pairs(v19.Task) do
							str4 = k3
							str6 = string.split(k3, " [Lv. " .. v19.LevelReq .. "]")[1]
						end
					end
				end
			end
		end

		if str5 == "ImpelQuest" then
			str5 = "PrisonerQuest"
			n3 = 2
			str4 = "Dangerous Prisoner"
			str6 = "Dangerous Prisoner"
			n4 = 210
			cframe = CFrame.new
			cframe = cframe(5310.60547, 0.350014925, 474.946594)
		elseif str5 == "Area2Quest" and n3 == 2 then
			n3 = 1
			str4 = "Swan Pirate"
			str6 = "Swan Pirate"
			n4 = 775
		end

		if value >= 2500 and value <= 2524 then
			str4 = "Sun-kissed Warrior"
			str6 = "Sun-kissed Warriors"
		end

		return (fn14())
	end

	local n3 = 1

	tbl18.NavigateToSpawn = function(arg, arg2)
		n3 = n3 or 1
		local tbl27 = {}

		for i = 1, #arg2 do
			tbl27[arg2[i]:gsub("Lv%.", ""):gsub("[%[%] %d]", ""):gsub("%s+", "")] = true
		end

		local tbl28 = {}
		local fortBuilderReplicatedSpawnPositi = game:GetService("ReplicatedStorage"):FindFirstChild("FortBuilderReplicatedSpawnPositionsFolder")

		if fortBuilderReplicatedSpawnPositi then
			for _, child in ipairs(fortBuilderReplicatedSpawnPositi:GetChildren()) do
				if child:IsA("Part") and child:GetAttribute("Active") then
					if tbl27[child.Name:gsub("Lv%.", ""):gsub("[%[%] %d]", ""):gsub("%s+", "")] then
						table.insert(tbl28, child:GetPivot())
					end
				end
			end
		end

		if #tbl28 == 0 then
			return false
		end

		if #tbl28 < n3 then
			n3 = 1
		end

		local v19 = tbl28[n3]
		if not v19 then
			return false
		end
		local distance = tbl18:GetDistance(v19.Position)

		if distance > 20 then
			if distance > 150 then
				tbl18:ExecuteTween(v19 * CFrame.new(0, 65, 5))
			else
				tbl18:ExecuteTween(v19 * CFrame.new(0, 30, 5))
			end
		end

		n3 = n3 % #tbl28 + 1
		return true
	end

	tbl18.IsSkillAvailable = function(arg, arg2)
		local tool = localPlayer.Character:FindFirstChildOfClass("Tool")
		if not tool then
			return false
		end
		local v19 = playerGui.Main.Skills[tool.Name]
		if not v19 then
			return false
		end
		local v20 = next
		local children, v21 = v19:GetChildren()

		for _, v22 in v20, children, v21 do
			if v22 and v22:IsA("Frame") and v22.Name == arg2 then
				local title = v22:FindFirstChild("Title")
				if title and title.TextColor3 == Color3.fromRGB(255, 255, 255) then
					return true
				end
			end
		end

		return false
	end

	tbl18.InteractWithPrompt = function(arg, arg2, maxActivationDistance)
		if not (arg2 and arg2:IsA("ProximityPrompt")) then
			return
		end
		arg2.MaxActivationDistance = maxActivationDistance or 10

		pcall(function()
			arg2:InputHoldBegin()
			task.wait(arg2.HoldDuration + 1)
			arg2:InputHoldEnd()
		end)
	end

	tbl18.FindNearestPrompt = function(arg, arg2)
		local v19 = next
		local descendants, v20 = tbl5.Workspace:GetDescendants()

		for _, v21 in v19, descendants, v20 do
			if v21:IsA("ProximityPrompt") then
				if ((v21.Parent:IsA("BasePart") and v21.Parent.Position or v21.Parent:IsA("Model") and v21.Parent:GetPivot().Position) - localPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude <= arg2 then
					tbl18:InteractWithPrompt(v21)
				end
			end
		end
	end

	tbl18.GetBossList = function()
		local tbl27 = {}

		local function fn14(arg)
			for _, v19 in ipairs(arg) do
				local humanoid = v19:FindFirstChildOfClass("Humanoid")

				if humanoid and humanoid.DisplayName:find("Boss") then
					table.insert(tbl27, v19.Name)
				end
			end
		end

		fn14(tbl5.ReplicatedStorage:GetDescendants())
		fn14(tbl6.Enemies:GetDescendants())
		return tbl27
	end

	tbl18.GetBossID = function()
		return nil
	end

	tbl18.GetMaterialList = function()
		if tbl8[1] then
			return { "Angel Wings", "Leather + Scrap Metal", "Magma Ore", "Fish Tail" }
		end

		if tbl8[2] then
			return {
				"Leather + Scrap Metal",
				"Magma Ore",
				"Mystic Droplet",
				"Radioactive Material",
				"Vampire Fang",
			}
		end

		if tbl8[3] then
			return {
				"Leather + Scrap Metal",
				"Fish Tail",
				"Gunpowder",
				"Mini Tusk",
				"Conjured Cocoa",
				"Dragon Scale",
			}
		end
	end

	tbl18.GetMaterialData = function(arg, arg2)
		local tbl27 = {
			Sea1 = {
				["Angel Wings"] = { { "Royal Soldier", "Royal Squad" }, CFrame.new(-7742, 5634, -1564) },
				["Leather + Scrap Metal"] = { { "Pirate", "Brute" }, CFrame.new(-1257, 54, 4091) },
				["Magma Ore"] = { { "Military Soldier" }, CFrame.new(-5408, 11, 8456) },
				["Fish Tail"] = { { "Fishman Warrior" }, CFrame.new(60931, 19, 1574) },
			},
			Sea2 = {
				["Leather + Scrap Metal"] = { { "Scrap Metal" }, CFrame.new(-1026, 73, 1375) },
				["Magma Ore"] = { { "Lava Pirate" }, CFrame.new(-5241, 50, -4713) },
				["Mystic Droplet"] = { { "Water Fighter" }, CFrame.new(-3350, 282, -10527) },
				["Radioactive Material"] = { { "Factory Staff" }, CFrame.new(-73, 149, -112) },
				["Vampire Fang"] = { { "Vampire" }, CFrame.new(-6030, 6, -1281) },
			},
			Sea3 = {
				["Leather + Scrap Metal"] = { { "Pirate Millionaire" }, CFrame.new(-364, 116, 5692) },
				["Fish Tail"] = { { "Fishman Captain", "Fishman Raider" }, CFrame.new(-10679, 398, -8975) },
				Gunpowder = { { "Pistol Billionaire" }, CFrame.new(-394, 135, 5981) },
				["Mini Tusk"] = { { "Mythological Pirate" }, CFrame.new(-13510, 584, -6986) },
				["Conjured Cocoa"] = { { "Cocoa Warrior", "Chocolate Bar Battler" }, CFrame.new(400, 81, -12257) },
				["Dragon Scale"] = { { "Dragon Crew Archer" }, CFrame.new(6689, 378, 331) },
			},
		}

		local v19 = tbl8[1] or tbl8[2] or tbl8[3]
		local value = nil
		local v20 = nil

		if v19 then
			local v21 = tbl27[tbl8[1] and "Sea1" or tbl8[2] and "Sea2" or "Sea3"][arg2]
			value = nil
			v20 = nil

			if v21 then
				value, v20 = unpack(v21)
			end
		end

		return { NPCs = value, Position = v20 }
	end

	tbl18.GetMaterialCount = function(arg, arg2)
		for _, v19 in pairs(fn8()) do
			if type(v19) == "table" and v19.Type == "Material" then
				if v19.Name == arg2 then
					return v19.Count
				end
			end
		end

		return 0
	end

	tbl18.GetRaceInfo = function()
		local value = localPlayer.Data.Race.Value
		local commF = tbl5.ReplicatedStorage.Remotes.CommF_
		if localPlayer.Character:FindFirstChild("RaceTransformed") then
			return value .. " V4"
		end

		if commF:InvokeServer("Wenlocktoad", "1") == -2 then
			return value .. " V3"
		end

		if commF:InvokeServer("Alchemist", "1") == -2 then
			return value .. " V2"
		end
		return value .. " V1"
	end

	tbl18.GetPlayerBoat = function()
		for _, child in pairs(tbl5.Workspace.Boats:GetChildren()) do
			if child:IsA("Model") then
				local owner = child:FindFirstChild("Owner")
				local humanoid = child:FindFirstChild("Humanoid")
				local v19 = owner and humanoid
				local flag

				if v19 then
					local name = localPlayer.Name
					flag = tostring(owner.Value) == name
				else
					flag = v19
				end

				flag = flag and humanoid.Value > 0
				if flag then
					return child
				end
			end
		end

		return nil
	end

	tbl18.FindTree = function()
		for _, child in pairs(tbl5.Workspace.Map["Boat Castle"].IslandModel:GetChildren()) do
			if child and child:FindFirstChild("Tree") then
				local v19 = nil

				for _, child2 in pairs(child:GetChildren()) do
					if child2 and child2.PrimaryPart then
						if not v19 or tbl18:GetDistance(child2.PrimaryPart.Position) < tbl18:GetDistance(v19.PrimaryPart.Position) then
							v19 = child2
						end
					end
				end

				return v19
			end
		end
	end

	tbl18.GetIslandList = function()
		local tbl27 = {}
		local tbl28 = {}
		local tbl29 = { "Sky 2", "Sky 3" }
		local v19 = next
		local children, v20 = tbl6.WorldOrigin.Locations:GetChildren()

		for _, v21 in v19, children, v20 do
			if v21 and not tbl28[v21.name] then
				table.insert(tbl27, v21.name)
				tbl28[v21.name] = true
			end
		end

		if tbl8[1] then
			for _, v21 in next, tbl29, nil do
				table.insert(tbl27, v21)
			end
		end

		return tbl27
	end

	tbl18.TeleportToTemple = function()
		local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

		if localPlayer.Character then
			humanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.301757812, 102.62469482422)
		end

		local mapStash = tbl5.ReplicatedStorage:FindFirstChild("MapStash")
		local templeOfTime = mapStash and mapStash:FindFirstChild("Temple of Time")

		if templeOfTime then
			templeOfTime.Parent = tbl5.Workspace.Map
		end
	end

	tbl18.NavigateToIsland = function(arg, arg2)
		if tbl9.Islands[arg2] then
			tbl18:FireRemote("requestEntrance", tbl9.Islands[arg2])
		else
			for _, child in pairs(tbl6.WorldOrigin.Locations:GetChildren()) do
				if child.Name == arg2 then
					tbl18:ExecuteTween(child.CFrame * CFrame.new(0, 180, 0))
				end
			end
		end
	end

	local tbl27 = {}

	tbl18.ProcessHumanV3 = function()
		local v19 = tbl18:FindEnemy({ "Jeremy", "Fajita", "Diamond" })
		if not v19 then
			return
		end

		while true do
			task.wait()
			tbl18:EngageEnemy({ v19.Name })
			if not (not v19 or not v19.Parent or v19.Humanoid.Health <= 0 or not tbl14["Auto V3"]) then
				continue
			end
			break
		end

		if v19 and not table.find(tbl27, v19.Name) then
			v9:SetNotification({ "Speed Hub X", "Auto V3", "Killed: " .. v19.Name, 5, 0.5 })
			table.insert(tbl27, v19.Name)
		end
	end

	tbl18.HandleFishmanV2 = function()
		local seaBeast1 = tbl5.Workspace.SeaBeasts:FindFirstChild("SeaBeast1")
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

		if not seaBeast1 then
			local playerBoat = tbl18:GetPlayerBoat()

			if not playerBoat then
				local cframe = CFrame.new(-13.5, 10, 2928)

				if localPlayer:DistanceFromCharacter(cframe.Position) > 8 then
					tbl18:ExecuteTween(cframe)
				else
					tbl5.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBoat", "PirateBasic")
				end

				return
			end

			local vehicleSeat = playerBoat:FindFirstChild("VehicleSeat")
			local cframe = CFrame.new(48.41, 11.23, 3690)
			if vehicleSeat and (vehicleSeat.Position - cframe.Position).Magnitude > 50 then
				vehicleSeat.CFrame = cframe
				return
			end

			if not character or not character:FindFirstChildOfClass("Humanoid") then
				return
			end
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Sit then
				return
			end

			if vehicleSeat and humanoidRootPart then
				if (vehicleSeat.Position - humanoidRootPart.Position).Magnitude > 50 then
					tbl18:ExecuteTween(vehicleSeat.CFrame)
				else
					humanoidRootPart.CFrame = vehicleSeat.CFrame
				end
			end

			return
		end

		local humanoidRootPart2 = seaBeast1:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart2 then
			return
		end
		local distance = tbl18:GetDistance(humanoidRootPart2.Position)

		if distance <= 5000 then
			TeleportToSeaBeast(seaBeast1)

			if distance <= 800 then
				SetAim(humanoidRootPart2.CFrame)
				tbl18:EquipToolByTip(tbl14["Choose Equip "] == "Random" and ({ "Melee", "Blox Fruit", "Sword", "Gun" })[math.random(1, 4)] or tbl14["Choose Equip "])
				local v19 = next
				local skill = tbl14["Skill  "] or {}

				for _, v20 in v19, skill, nil do
					if tbl18:IsSkillAvailable(v20) then
						tbl18:SendKeyPress(v20)
					end
				end
			end
		end
	end

	tbl18.IsInSafeZone = function(arg, arg2)
		if not arg2 then
			return false
		end
		local humanoidRootPart = arg2:FindFirstChild("HumanoidRootPart")
		local humanoid = arg2:FindFirstChildOfClass("Humanoid")
		if not humanoidRootPart or not humanoid then
			return false
		end

		for _, child in pairs(tbl6.WorldOrigin.SafeZones:GetChildren()) do
			if child:IsA("BasePart") then
				if (child.Position - humanoidRootPart.Position).Magnitude <= 400 and humanoid.Health / humanoid.MaxHealth >= 0.9 then
					return true
				end
			end
		end

		return false
	end

	tbl18.CheckRecentDeath = function()
		for _, child in pairs(playerGui.Notifications:GetChildren()) do
			if child:IsA("TextLabel") and (string.find(string.lower(child.Text), "player") or string.find(string.lower(child.Text), "người chơi")) then
				return true
			end
		end

		return false
	end

	tbl18.CountSkypieaPlayers = function()
		local n4 = 0

		for _, player in pairs(tbl5.Players:GetPlayers()) do
			if player ~= localPlayer then
				local data = player:FindFirstChild("Data")
				data = data and data:FindFirstChild("Race")

				if data and data.Value == "Skypiea" then
					n4 += 1
				end
			end
		end

		return n4
	end

	local tbl28 = {}
	local tbl29 = {}

	tbl18.HandleSkypieaV3 = function()
		local players = tbl5.Players:GetPlayers()

		for _, player in pairs(players) do
			if player.Name ~= localPlayer.Name then
				local data = player:FindFirstChild("Data")
				data = data and data:FindFirstChild("Race")

				if tostring(data and data.Value) ~= "Skypiea" then
					if not table.find(tbl29, player.Name) then
						table.insert(tbl29, player.Name)
						v9:SetNotification({ "Speed Hub X", "Auto V3", "Blacklisted: " .. player.Name, 5, 0.5 })
					end

					if #players - 2 <= #tbl29 then
						v9:SetNotification({ "Speed Hub X", "Auto V3", "No Skypiea Players Found | Server Hopping", 5, 0.5 })
						tbl18:ServerHop("Singapore", 10)
					end
				elseif not table.find(tbl28, player.Name) then
					v9:SetNotification({ "Speed Hub X", "Auto V3", "Target: " .. player.Name, 5, 0.5 })
					local character = player.Character
					character = character and character:FindFirstChild("HumanoidRootPart")
					local humanoid = player:FindFirstChildOfClass("Humanoid")

					if character and humanoid then
						while true do
							task.wait()

							if tbl18:CheckRecentDeath() then
								table.insert(tbl28, player.Name)
							end

							tbl18:ExecuteTween(character.CFrame * CFrame.new(0, 8, 0) * CFrame.Angles(-0.78539816339744828, 0, 0))
							if not (not humanoid or humanoid.Health <= 0 or not tbl14["Auto V3"] or table.find(tbl28, player.Name)) then
								continue
							end
							break
						end
					end
				else
					v9:SetNotification({
						"Speed Hub X",
						"Auto V3",
						"Skipped: " .. player.Name .. " | Reason: " .. (tbl18:CheckRecentDeath() and "Dead Recent" or "Unknown"),
						5,
						0.5,
					})

					if not table.find(tbl28, player.Name) then
						table.insert(tbl28, player.Name)
					end

					local n4 = #tbl28

					if tbl18:CountSkypieaPlayers() <= n4 then
						tbl18:ServerHop("Singapore", 10)
					end
				end
			end
		end
	end

	tbl18.FindNearestChest = function()
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return nil
		end
		local huge = math.huge
		local v19 = nil

		for _, child in pairs(tbl5.Workspace.ChestModels:GetChildren()) do
			if string.match(child.Name, "Chest") then
				local magnitude = (child.Position - humanoidRootPart.Position).Magnitude

				if magnitude < huge then
					huge = magnitude
					v19 = child
				end
			end
		end

		if not v19 then
			for _, descendant in pairs(tbl5.Workspace.Map:GetDescendants()) do
				if descendant:IsA("Part") and string.match(descendant.Name, "Chest") then
					local magnitude = (descendant.Position - humanoidRootPart.Position).Magnitude

					if magnitude < huge then
						huge = magnitude
						v19 = descendant
					end
				end
			end
		end

		return v19
	end

	tbl18.HandleMinkV2 = function()
		local v19 = tbl18:FindNearestChest()
		if not v19 then
			return
		end
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return
		end

		while true do
			task.wait()
			local magnitude = (character.Position - v19.Position).Magnitude

			if magnitude <= 2 then
				firetouchinterest(v19, character, 0)
				firetouchinterest(v19, character, 1)
			elseif magnitude <= 5 then
				tbl5.VirtualInputManager:SendKeyEvent(true, "W", false, game)
				task.wait()
				tbl5.VirtualInputManager:SendKeyEvent(false, "W", false, game)
			end

			tbl18:ExecuteTween(v19.CFrame * CFrame.new(0, 1, 0))
			if not (not v19 or not v19.Parent or not tbl14["Auto V3"]) then
				continue
			end
			break
		end
	end

	tbl18.GetEquippedFruit = function()
		local character = localPlayer.Character
		local name = nil

		for _, child in pairs(localPlayer.Backpack:GetChildren()) do
			if string.find(child.Name, "Fruit") then
				name = child.Name
				break
			else
				name = nil
			end
		end

		if not name and character then
			for _, child in pairs(character:GetChildren()) do
				if string.find(child.Name, "Fruit") then
					name = child.Name
					break
				end
			end
		end

		return name
	end

	local tbl30 = {}
	local v19 = next
	local response, v20 = tbl5.ReplicatedStorage:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits")

	for _, v21 in v19, response, v20 do
		if v21.Price >= 1000000 then
			tbl30[v21.Name] = v21.Price
		end
	end

	tbl18.GetFruitInventory = function(arg, arg2)
		local flag = arg2 or true
		local huge = math.huge
		local name = nil

		for _, v21 in next, fn8(), nil do
			if v21.Type ~= "Blox Fruit" then
				continue
			end

			if not flag then
				local v22 = tbl30[v21.Name]

				if v22 and v22 < huge then
					name = v21.Name
					huge = v22
				end

				continue
			end

			if not tbl30[v21.Name] then
				return v21.Name
			end
		end

		return name
	end

	tbl18.GetCurrentFruit = function()
		local tbl31 = {}

		local function fn14(arg)
			local parts = arg:split(":")
			return (parts[1] .. "-" .. parts[1] .. (parts[2] and ":" .. parts[2] or "")):gsub(" Fruit", "")
		end

		local v21 = next
		local children, v22 = localPlayer.Character:GetChildren()

		for _, v23 in v21, children, v22 do
			if string.find(v23.Name, "Fruit") and not tbl31[v23.Name] then
				tbl31[v23.Name] = true
				return v23.Name, fn14(v23.Name), v23
			end
		end

		local v23 = next
		local children2, v24 = localPlayer.Backpack:GetChildren()

		for _, v25 in v23, children2, v24 do
			if string.find(v25.Name, "Fruit") and not tbl31[v25.Name] then
				tbl31[v25.Name] = true
				return v25.Name, fn14(v25.Name), v25
			end
		end

		return nil, nil, nil
	end

	tbl18.FindGroundFruit = function()
		local character = localPlayer.Character
		character = character and character.PrimaryPart
		if not character then
			return nil
		end
		local huge = math.huge
		local v21 = nil

		for _, child in pairs(tbl5.Workspace:GetChildren()) do
			if child then
				local handle = child:FindFirstChild("Handle")

				if handle and child:IsA("Tool") then
					local magnitude = (character.Position - handle.Position).Magnitude

					if magnitude <= huge then
						huge = magnitude
						v21 = child
					end
				elseif handle and string.find(child.Name, "Fruit") then
					local magnitude = (character.Position - handle.Position).Magnitude

					if magnitude <= huge then
						huge = magnitude
						v21 = child
					end
				end
			end
		end

		return v21 and v21:FindFirstChild("Handle")
	end

	tbl18.AttackMob = function(arg, arg2)
		for _, child in pairs(tbl6.Enemies:GetChildren()) do
			if child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0 then
				tbl4.__spawn(function()
					while tbl14[arg2] and child.Parent and child.Humanoid.Health > 0 and not v9.Unloaded do
						tbl18:EquipSelectedTool()
						tbl18:ActivateHaki()
						child.HumanoidRootPart.CFrame = localPlayer.Character.CFrame * CFrame.new(0, -30, 0)
						tbl5.RunService.Heartbeat:Wait()
					end
				end)
			end
		end
	end

	tbl18.CreateESP = function(arg, arg2, textColor3)
		if not arg2 or arg2:FindFirstChild("SpeedHubX_ESP") then
			return
		end
		local primaryPart = arg2
		local str3 = nil

		if arg2:IsA("Model") then
			primaryPart = arg2:FindFirstChild("PrimaryPart") or arg2:FindFirstChildWhichIsA("BasePart")
			str3 = "Model"
			if not primaryPart then
				return
			end
		end

		local folder = Instance.new("Folder")
		folder.Name = "SpeedHubX_ESP"
		folder.Parent = primaryPart
		local boxHandleAdornment = Instance.new("BoxHandleAdornment")
		boxHandleAdornment.Size = Vector3.new(1, 0, 1)
		boxHandleAdornment.Name = "SpeedHubX_ESP"
		boxHandleAdornment.AlwaysOnTop = true
		boxHandleAdornment.ZIndex = 10
		boxHandleAdornment.Transparency = 0
		boxHandleAdornment.Adornee = primaryPart
		boxHandleAdornment.Parent = folder
		local billboardGui = Instance.new("BillboardGui")
		billboardGui.Adornee = primaryPart
		billboardGui.Size = UDim2.new(0, 100, 0, 150)
		billboardGui.StudsOffset = Vector3.new(0, 1, 0)
		billboardGui.AlwaysOnTop = true
		billboardGui.Parent = boxHandleAdornment
		local textLabel = Instance.new("TextLabel")
		textLabel.BackgroundTransparency = 1
		textLabel.Position = UDim2.new(0, 0, 0, -50)
		textLabel.Size = UDim2.new(0, 100, 0, 100)
		textLabel.TextSize = 10
		textLabel.TextColor3 = textColor3 or Color3.fromRGB(255, 255, 255)
		textLabel.TextStrokeTransparency = 0
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextYAlignment = Enum.TextYAlignment.Bottom
		textLabel.Text = ""
		textLabel.ZIndex = 15
		textLabel.Parent = billboardGui
		local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

		tbl5.RunService.Heartbeat:Connect(function()
			if not humanoidRootPart then
				return
			end

			pcall(function()
				local n4 = math.floor((humanoidRootPart.Position - primaryPart.Position).Magnitude / 3)

				if primaryPart.Name == "HumanoidRootPart" and primaryPart.Parent:FindFirstChild("Humanoid") then
					textLabel.Text = string.format(" [ Name : %s ] \n [ HP : %d ] \n [ Location : %d ] ", primaryPart.Parent.Name, math.floor(primaryPart.Parent.Humanoid.Health), n4)
				elseif primaryPart.Name == "HumanoidRootPart" then
					textLabel.Text = string.format(" [ Name : %s ] \n [ Location : %d ] ", primaryPart.Parent.Name, n4)
				elseif primaryPart.Name == "Handle" then
					textLabel.Text = string.format(" [ Name : %s ] \n [ Location : %d ] ", primaryPart.Parent.Name, n4)
				elseif str3 == "Model" then
					textLabel.Text = string.format(" [ Name : %s ] \n [ Location : %d ] ", primaryPart.Parent.Name, n4)
				else
					textLabel.Text = string.format(" [ Name : %s ] \n [ Location : %d ] ", primaryPart.Name, n4)
				end
			end)
		end)
	end

	tbl18.RemoveESP = function(arg, arg2)
		if arg2 and arg2:FindFirstChild("SpeedHubX_ESP") then
			arg2.SpeedHubX_ESP:Destroy()
		end
	end

	local tbl31 = nil
	local vector = Vector3.zero
	local n4 = 0
	local n5 = 0.1

	local function fn14()
		local tbl32 = {
			"Auto Farm Mastery",
			"Auto Farm Sea",
			"Auto Attack Leviathan",
			"Auto Attack Leviathan Segment",
			"Auto Attack Leviathan Tail",
		}

		for i = 1, #tbl32 do
			if tbl14[tbl32[i]] then
				return true
			end
		end

		return false
	end

	local function fn15()
		if not tbl31 then
			return Vector3.zero
		end
		local now2 = tick()

		if n5 < now2 - n4 then
			vector = tbl31[1] and tbl31[1].Position or tbl31[2] or Vector3.zero
			n4 = now2
		end

		return vector
	end

	tbl18.isQuestOn = function()
		return game.Players.LocalPlayer.PlayerGui:FindFirstChild("TrackedQuestFrame") and game.Players.LocalPlayer.PlayerGui:WaitForChild("TrackedQuestFrame").Frame.Visible or false
	end

	SetAim = function(target)
		if not target then
			tbl31 = nil
			vector = Vector3.zero
			return
		end

		local Mouse = require(tbl5.ReplicatedStorage:WaitForChild("Mouse"))

		if Mouse then
			Mouse.Hit = CFrame.new(target.Position)
			Mouse.Target = target
		end

		tbl31 = { target, target.Position }
		vector = target.Position
		n4 = tick()
	end

	TeleportToSeaBeast = function(arg)
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end
		local waterBasePlane = tbl5.Workspace.Map:FindFirstChild("WaterBase-Plane")
		if not waterBasePlane then
			return
		end

		if (Vector3.new(0, humanoidRootPart.Position.Y, 0) - Vector3.new(0, waterBasePlane.Position.Y, 0)).Magnitude <= 175 then
			if tbl14["Auto Dodge Sea Beasts Skill"] and IsPlayingSeaBeast() then
				tbl18:ExecuteTween(humanoidRootPart.CFrame * _G.DodgeSeaPos, 500)
			else
				tbl18:ExecuteTween(humanoidRootPart.CFrame * CFrame.new(0, 300, 50))
			end
		else
			tbl18:ExecuteTween(CFrame.new(humanoidRootPart.Position.X, waterBasePlane.Position.Y + 200, humanoidRootPart.Position.Z))
		end
	end

	IsPlayingSeaBeast = function()
		for _, descendant in pairs(tbl5.Workspace.SeaBeasts:GetDescendants()) do
			if descendant:IsA("Animator") then
				for _, v21 in pairs(descendant:GetPlayingAnimationTracks()) do
					local animationId = v21.Animation.AnimationId

					if animationId == "rbxassetid://8708221792" or animationId == "rbxassetid://8708222556" then
						local random = math.random
						_G.DodgeSeaPos = CFrame.new(math.random(0, 700), 300, random(0, 700))
						return true
					end
				end
			end
		end

		return false
	end

	tbl4.__spawn(function()
		if _G.EnabledAimBot then
			return
		end
		_G.EnabledAimBot = true
		local main = playerGui:FindFirstChild("Main")

		if main then
			local whatsNew = main:FindFirstChild("WhatsNew")

			if whatsNew then
				whatsNew:Destroy()
			end
		end

		local v21 = getrawmetatable(game)
		local namecall = v21.__namecall
		local index = v21.__index
		local newindex = v21.__newindex
		setreadonly(v21, false)

		local function fn16()
			return tbl31 ~= nil and fn14()
		end

		v21.__namecall = function(arg, arg2, arg3, ...)
			local v22 = table.pack(...)
			local str3 = getnamecallmethod():lower()

			if tostring(arg) == "RemoteEvent" then
				if str3 == "fireserver" and typeof(arg2) == "Vector3" then
					if fn16() then
						local v23 = fn15()
						if v23 ~= Vector3.zero then
							return namecall(arg, v23, arg3, ...)
						end
					end
				end

				if str3 == "invokeserver" then
					local tbl32 = { "Z", "X", "C", "V", "F" }
					local flag = false

					for i = 1, #tbl32 do
						if tbl32[i] == arg2 then
							flag = true
							break
						end
					end

					if flag and typeof(arg3) == "Vector3" then
						if not select(1, ...) then
							if fn16() then
								local v23 = fn15()
								if v23 ~= Vector3.zero then
									return namecall(arg, v23, arg3, table.unpack(v22, 1, v22.n))
								end
							end
						end

						return namecall(arg, arg2, arg3, table.unpack(v22, 1, v22.n))
					end
				end
			end

			return namecall(arg, arg2, arg3, ...)
		end

		v21.__index = function(arg, arg2)
			if arg2 == "Part_Aim" and fn16() then
				return tbl31 and tbl31[1]
			end
			return index(arg, arg2)
		end

		v21.__newindex = function(arg, arg2, arg3)
			if arg2 == "Part_Aim" and arg3 == nil then
				tbl31 = nil
				vector = Vector3.zero
				return
			end

			return newindex(arg, arg2, arg3)
		end

		setreadonly(v21, true)
	end)

	result2:Button(v11:AddSection("Discord", true), "Copy Invite Link", "Copy Discord invite to clipboard", function()
		if Discord then
			setclipboard(Discord)
		end
	end)

	local Configuration = v11:AddSection("Configuration")

	result2:Dropdown(Configuration, "Weapon Tool", "Select weapon type", false, { "Melee", "Sword", "Blox Fruit", "Gun" }, { "Melee" }, function(arg)
		tbl16:SetSave("Weapon Tool", arg)
	end)

	Configuration:AddSeperator({ "Tween & Movement" })

	result2:Dropdown(Configuration, "Farm Distance", "Distance from enemies", false, { "10", "20", "30", "40", "50", "60" }, { "20" }, function(arg)
		tbl16:SetSave("Farm Distance", arg)
	end)

	result2:Dropdown(Configuration, "Tween Speed", "Movement speed", false, { "100", "200", "300", "400", "500" }, { "300" }, function(arg)
		tbl16:SetSave("Tween Speed", arg)
	end)

	Configuration:AddSeperator({ "Mob Control" })

	result2:Toggle(Configuration, "Bring Mob", "Pull enemies closer", true, function(arg)
		tbl16:SetSave("Bring Mob", arg)
	end)

	result2:Dropdown(Configuration, "Bring Mob Radius", "Pull radius", false, { "100", "200", "300", "400", "500" }, { "300" }, function(arg)
		tbl16:SetSave("Bring Mob Radius", arg)
	end)

	Configuration:AddSeperator({ "Combat Settings" })

	result2:Toggle(Configuration, "Fast Attack", "Faster attack speed", true, function(arg)
		tbl16:SetSave("Fast Attack", arg)
	end)

	tbl4.__spawn(function()
		local v21 = nil
		local n6 = 0

		while task.wait() do
			if tbl14["Fast Attack"] and not v9.Unloaded then
				local n7 = (tbl14["Fast Attack Delay"] or 1) / 100

				if n7 ~= v21 then
					n6 = 0
					v21 = n7
				end

				if tick() - n6 >= n7 then
					n6 = tick()
					tbl18:ExecuteBladeHits()
				end
			end
		end
	end)

	Configuration:AddSeperator({ "Auto Abilities" })

	result2:Toggle(Configuration, "Auto Dodge Skill", "Dodge enemy skills", false, function(arg)
		tbl16:SetSave("Auto Dodge Skill", arg)
	end)

	result2:Toggle(Configuration, "Auto Use Race V3", "Auto activate V3", false, function(arg)
		tbl16:SetSave("Auto Use Race V3", arg)
	end)

	result2:Toggle(Configuration, "Auto Use Race V4", "Auto activate V4", false, function(arg)
		tbl16:SetSave("Auto Use Race V4", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Use Race V3", function()
			tbl5.ReplicatedStorage.Remotes.CommE:FireServer("ActivateAbility")
		end)

		tbl18:CreateLoop("Auto Use Race V4", function()
			if not localPlayer.Character.RaceTransformed.Value then
				tbl18:SendKeyPress("Y", 0.1)
			end
		end)
	end)

	local v21 = v11:AddSection("Local Player")

	result2:Textbox(v21, "Dash Length", "Custom dash distance", "Save", function(arg)
		tbl16:SetSave("Set Length", arg)
	end)

	result2:Button(v21, "Apply Dash Length", "Apply dash length", function()
		localPlayer.Character:SetAttribute("DashLength", tbl14["Set Length"] and tonumber(tbl14["Set Length"]) or 70)
	end)

	result2:Textbox(v21, "Speed Multiplier", "Movement speed (1-10)", "Save", function(arg)
		tbl16:SetSave("Set Speed", arg)
	end)

	result2:Button(v21, "Apply Speed", "Apply speed multiplier", function()
		localPlayer.Character:SetAttribute("SpeedMultiplier", tbl14["Set Speed"] and tonumber(tbl14["Set Speed"]) or 3)
	end)

	local v22 = v11:AddSection("Server Manager")

	result2:Dropdown(v22, "Max Player Count", "Max players before hop", false, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" }, { "5" }, function(arg)
		tbl16:SetSave("Count Player", arg)
	end)

	result2:Button(v22, "Hop Server", "Teleport to another server", function()
		tbl18:ServerHop("Singapore", tonumber(tbl14["Count Player"]))
	end)

	result2:Button(v22, "Rejoin Server", "Reconnect to current server", function()
		tbl5.TeleportService:Teleport(game.PlaceId, localPlayer)
	end)

	local v23 = v11:AddSection("Stat Manager")

	result2:Dropdown(v23, "Points Per Stat", "Points per click", false, { "1", "5", "10", "15", "20", "25", "30", "35", "40", "50" }, { "1" }, function(arg)
		tbl16:SetSave("Point Stats", arg)
	end)

	for _, v24 in next, { "Melee", "Defense", "Sword", "Gun", "Demon Fruit" }, nil do
		result2:Toggle(v23, "Auto " .. v24, "Auto allocate points", "Save", function(arg)
			tbl16:SetSave("Auto " .. v24, arg)
		end)
	end

	tbl4.__spawn(function()
		for _, v24 in pairs({ "Melee", "Defense", "Sword", "Gun", "Demon Fruit" }) do
			tbl18:CreateLoop("Auto " .. v24, function()
				tbl18:FireRemote("AddPoint", v24, tonumber(tbl14["Point Stats"]))
			end)
		end
	end)

	local lighting = tbl5.Lighting
	local sky = lighting:FindFirstChildOfClass("Sky") or lighting:WaitForChild("Sky")
	local data = localPlayer:WaitForChild("Data")
	local leaderstats = localPlayer:WaitForChild("leaderstats")
	local c = data:WaitForChild("Race"):WaitForChild("C")
	local visionRadius = localPlayer:WaitForChild("VisionRadius")
	local level = data:WaitForChild("Level")
	local exp = data:WaitForChild("Exp")
	local bountyHonor = leaderstats:WaitForChild("Bounty/Honor")
	local beli = data:WaitForChild("Beli")
	local fragments = data:WaitForChild("Fragments")

	local tbl32 = {
		["http://www.roblox.com/asset/?id=9709149431"] = "Full Moon (5/5)",
		["http://www.roblox.com/asset/?id=9709149052"] = "Gibbous (4/5)",
		["http://www.roblox.com/asset/?id=9709143733"] = "Quarter (3/5)",
		["http://www.roblox.com/asset/?id=9709150401"] = "Crescent (2/5)",
		["http://www.roblox.com/asset/?id=9709149680"] = "New Moon (1/5)",
	}

	local v24 = v12:AddSection("Server & Player Status", true):AddParagraph({ Title = "Status", Content = "" })

	local function fn16()
		local str3 = sky and tbl32[sky.MoonTextureId] or "Unknown"
		local str4 = tostring(c.Value)
		local str5 = (({ ["1"] = "", ["2"] = "", ["3"] = "", ["4"] = "" })[str4] or "") .. " Tier " .. str4 .. "/4"
		local str6 = visionRadius.Value .. " / 5000 XP"
		local str7 = "Lv. " .. level.Value .. " | XP: " .. exp.Value .. " (" .. math.floor(exp.Value / (level.Value * 100 + 50) * 100) .. "%)"
		local value = bountyHonor.Value

		v24:Set({
			Title = "Status",
			Content = string.format("🌙 %s\n👤 %s\n👁️ %s\n📊 %s\n💰 %s\n💎 %s", str3, str5, str6, str7, (value >= 1000000 and string.format("%.1fM", value / 1000000) or tostring(value)) .. " (" .. value .. ")", (beli.Value >= 1000000 and string.format("%.1fM", beli.Value / 1000000) or tostring(beli.Value)) .. " Beli | " .. fragments.Value .. " Frags"),
		})
	end

	fn16()

	local function fn17()
		if sky then
			sky:GetPropertyChangedSignal("MoonTextureId"):Connect(fn16)
		end

		c.Changed:Connect(fn16)
		visionRadius.Changed:Connect(fn16)
		level.Changed:Connect(fn16)
		exp.Changed:Connect(fn16)
		bountyHonor.Changed:Connect(fn16)
		beli.Changed:Connect(fn16)
		fragments.Changed:Connect(fn16)
	end

	fn17()
	local v25 = v12:AddSection("Stack Farming System")

	v25:AddParagraph({
		"Priority-Based Farming",
		"Only the highest priority enabled feature with available targets will run.",
	})

	result2:Toggle(v25, "Enable Stack Farming", "Activate priority system", "Save", function(arg)
		tbl16:SetSave("Stack Farming Enabled", arg)
	end)

	v25:AddLine()

	for _, v26 in ipairs({
		{ "Auto Farm Level", "1", "Farm quest enemies" },
		{ "Auto Farm Nearest", "2", "Farm nearest enemies" },
		{ "Auto Farm Mastery", "3", "Farm for mastery" },
		{ "Auto Collect Chest", "4", "Collect chests" },
		{ "Auto Collect Berry", "5", "Collect berries" },
		{ "Auto Farm Material", "6", "Farm materials" },
		{ "Auto Farm Bones", "7", "Farm bones" },
		{ "Auto Attack Boss", "8", "Attack selected boss" },
		{ "Auto Attack All Boss", "9", "Attack all bosses" },
		{ "Auto Soul Reaper", "10", "Farm Soul Reaper" },
		{ "Auto Elite Hunter", "11", "Hunt elites" },
		{ "Auto Kill Tyrant of the Skies", "12", "Kill Tyrant" },
		{ "Auto Citizen Quest", "13", "Complete citizen quests" },
		{ "Auto Dough King", "14", "Fight Dough King" },
		{ "Auto Cake Prince", "15", "Fight Cake Prince" },
	}) do
		local priority, v27, v28 = unpack(v26)

		result2:Dropdown(v25, "Priority: " .. priority, v28, false, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15" }, { v27 }, function(arg)
			tbl16:SetSave("Priority: " .. priority, arg)
		end)
	end

	local v26 = v12:AddSection("Hop Boss")

	local tbl33 = {
		"Greybeard",
		"The Saw",
		"Saber Expert",
		"The Gorilla King",
		"Bobby",
		"Yeti",
		"Vice Admiral",
		"Warden",
		"Chief Warden",
		"Swan",
		"Magma Admiral",
		"Fishman Lord",
		"Wysper",
		"Thunder God",
		"Cyborg",
	}

	local tbl34 = {
		"Darkbeard",
		"Cursed Captain",
		"Order",
		"Don Swan",
		"Diamond",
		"Jeremy",
		"Fajita",
		"Smoke Admiral",
		"Awakened Ice Admiral",
		"Tide Keeper",
	}

	local tbl35 = {
		"Dough King",
		"Cake Prince",
		"rip_indra True Form",
		"Soul Reaper",
		"Stone",
		"Island Empress",
		"Kilo Admiral",
		"Captain Elephant",
		"Beautiful Pirate",
		"Cake Queen",
		"Longma",
	}

	result2:Dropdown(v26, "Select World", "Choose world to hop", false, { "First", "Second", "Third" }, { "Third" }, function(arg)
		tbl16:SetSave("Choose World", arg)
	end)

	result2:Dropdown(v26, "Select Boss [1st World]", "Choose boss in first world", false, tbl33, { "Greybeard" }, function(arg)
		tbl16:SetSave("Choose Boss 1", arg)
	end)

	result2:Dropdown(v26, "Select Boss [2nd World]", "Choose boss in second world", false, tbl34, { "Darkbread" }, function(arg)
		tbl16:SetSave("Choose Boss 2", arg)
	end)

	result2:Dropdown(v26, "Select Boss [3rd World]", "Choose boss in third world", false, tbl35, { "rip_indra True Form" }, function(arg)
		tbl16:SetSave("Choose Boss 3", arg)
	end)

	result2:Button(v26, "Hop", "Find server with boss", function()
		local chooseBoss1 = tbl14["Choose World"] == "First" and tbl14["Choose Boss 1"]
		local chooseBoss2

		if chooseBoss1 then
			chooseBoss2 = chooseBoss1
		else
			chooseBoss2 = tbl14["Choose World"] == "Second" and tbl14["Choose Boss 2"]
		end

		chooseBoss2 = chooseBoss2 or tbl14["Choose World"] == "Third" and tbl14["Choose Boss 3"]
		local v27 = tbl18:bossData(chooseBoss2)

		if v27 and v27.id then
			local v28 = tbl18:converttoTable(v27.id)
			tbl18:smartBossTeleport({ tbl33, tbl34, tbl35 }, chooseBoss2, v28[2], v28[1])
		else
			v9:SetNotification({ "Speed Hub X", "Hop Boss", "No server with boss found", 5, 0.5 })
		end
	end)

	local v27 = v12:AddSection("Level Farming")

	if identifyexecutor():find("Solara") or identifyexecutor():find("Xeno") then
		v27:AddParagraph({
			"Incompatible Executor",
			"Solara and Xeno are not supported.\nUse 'Auto Farm Nearest' instead.",
		})
	else
		result2:Toggle(v27, "No Quest Mode", "Skip quests and farm directly", "Save", function(arg)
			tbl16:SetSave("No Quest", arg)
		end)

		result2:Toggle(v27, "Auto Take Quest", "Auto-accept quests", "Save", function(arg)
			tbl16:SetSave("Take Quest", arg)
		end)

		v27:AddLine()

		result2:Toggle(v27, "Auto Farm Level", "Farm based on level", "Save", function(arg)
			tbl16:SetSave("Auto Farm Level", arg)
			tbl18:StopTween(arg)
		end)

		tbl4.__spawn(function()
			tbl18:CreateLoop("Auto Farm Level", function()
				if not tbl18:CheckStackPriority("Auto Farm Level") then
					return
				end
				local questInfo = tbl18:GetQuestInfo(tbl14["Auto Farm Level"])

				if tbl14["No Quest"] and not tbl14["Take Quest"] then
					if tbl18:FindEnemy({ questInfo[3] }) then
						tbl18:EngageEnemy({ questInfo[3] })
					else
						tbl18:NavigateToSpawn({ questInfo[3] })
						task.wait(1)
					end
				elseif tbl14["Take Quest"] and not tbl14["No Quest"] then
					if tbl18:isQuestOn() then
						if tbl18:FindEnemy({ questInfo[3] }) then
							tbl18:EngageEnemy({ questInfo[3] })
						else
							tbl18:NavigateToSpawn({ questInfo[3] })
							task.wait(1)
						end
					else
						tbl18:FireRemote("StartQuest", questInfo[4], questInfo[1])
					end
				elseif tbl18:isQuestOn() then
					if tbl18:FindEnemy({ questInfo[3] }) then
						tbl18:EngageEnemy({ questInfo[3] })
					else
						tbl18:NavigateToSpawn({ questInfo[3] })
						task.wait(1)
					end
				else
					local distance = tbl18:GetDistance(questInfo[2])

					if distance and distance <= 5 then
						tbl18:FireRemote("StartQuest", questInfo[4], questInfo[1])
					else
						tbl18:ExecuteTween(questInfo[2])
					end
				end
			end)
		end)
	end

	local v28 = v12:AddSection("Nearest Enemy Farming")

	result2:Dropdown(v28, "Search Range", "Maximum search distance", false, { "1000", "2000", "3000", "Infinite" }, { "Infinite" }, function(arg)
		tbl16:SetSave("Neareast Range", arg)
	end)

	v28:AddLine()

	result2:Toggle(v28, "Auto Farm Nearest", "Farm closest enemy", "Save", function(arg)
		tbl16:SetSave("Auto Farm Nearest", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Farm Nearest", function()
			if not tbl18:CheckStackPriority("Auto Farm Nearest") then
				return
			end
			local huge = tbl14["Neareast Range"] == "Infinite" and math.huge or tonumber(tbl14["Neareast Range"])
			local huge2 = math.huge
			local v29 = nil

			for _, child in pairs(tbl6.Enemies:GetChildren()) do
				if child and child.PrimaryPart and tbl18:IsEntityAlive(child) then
					local magnitude = (child.PrimaryPart.Position - localPlayer.Character.PrimaryPart.Position).Magnitude

					if magnitude < huge2 and magnitude <= huge then
						huge2 = magnitude
						v29 = child
					end
				end
			end

			if v29 then
				tbl18:EngageEnemy({ v29.Name })
			end
		end)
	end)

	local v29 = v12:AddSection("Mastery Farming")

	result2:Dropdown(v29, "Farm Mode", "Enemy selection mode", false, { "Level", "Bone", "Cake Prince", "Neareast" }, { "Level" }, function(arg)
		tbl16:SetSave("Choose Mastery Mode", arg)
	end)

	result2:Dropdown(v29, "Weapon Type", "Weapon to gain mastery for", false, { "Blox Fruit", "Sword", "Gun", "Melee" }, { "Blox Fruit" }, function(arg)
		tbl16:SetSave("Choose Mastery Tool", arg)
	end)

	result2:Dropdown(v29, "Health Threshold", "HP % to use skills", false, { "10", "20", "25", "30", "45", "50", "60", "70", "75", "85", "95" }, { "45" }, function(arg)
		tbl16:SetSave("Mastery Health", arg)
	end)

	result2:Dropdown(v29, "Combat Skills", "Skills to use", true, { "Z", "X", "C", "V", "F" }, { "Z", "X", "C", "V" }, function(arg)
		tbl16:SetSave("Skill", arg, true)
	end)

	v29:AddLine()

	result2:Toggle(v29, "Auto Farm Mastery", "Farm for mastery", "Save", function(arg)
		tbl16:SetSave("Auto Farm Mastery", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Farm Mastery", function()
			if not tbl18:CheckStackPriority("Auto Farm Mastery") then
				return
			end

			local function fn18(arg, arg2)
				local v30 = tbl18:FindEnemy(arg)
				if not v30 then
					return
				end
				local primaryPart = v30.PrimaryPart
				local cFrame = primaryPart.CFrame
				local n6 = tonumber(tbl14["Mastery Health"]) or 45

				while true do
					task.wait()

					if not (not v30 or not v30.Parent or not tbl18:IsEntityAlive(v30)) then
						if not (not tbl14["Auto Farm Mastery"] or tbl14["Choose Mastery Mode"] ~= arg2) then
							if v30.Humanoid.Health / v30.Humanoid.MaxHealth * 100 <= n6 then
								tbl18:EquipToolByTip(tbl14["Choose Mastery Tool"])
								tbl18:ExecuteTween(cFrame + Vector3.new(0, tonumber(tbl14["Farm Distance"]) or 20, 1))
								tbl18:ActivateHaki()
								tbl18:BringEnemyToPosition(v30, cFrame)
								SetAim(primaryPart)
								local v31 = next
								local skill = tbl14.Skill or {}

								for _, v32 in v31, skill, nil do
									if tbl18:IsSkillAvailable(v32) then
										tbl18:SendKeyPress(v32)
									end
								end
							else
								tbl18:EquipSelectedTool()
								tbl18:BringEnemyToPosition(v30, cFrame)
								tbl18:ExecuteTween(cFrame + Vector3.new(0, tonumber(tbl14["Farm Distance"]) or 20, 1))
								tbl18:ActivateHaki()
							end

							if not (not v30 or not v30.Parent or not tbl18:IsEntityAlive(v30) or not tbl14["Auto Farm Mastery"]) then
								continue
							end
						end
					end

					break
				end
			end

			local chooseMasteryMode = tbl14["Choose Mastery Mode"]

			if chooseMasteryMode == "Level" then
				local questInfo = tbl18:GetQuestInfo(tbl14["Auto Farm Mastery"])

				if tbl18:isQuestOn() then
					fn18({ questInfo[3] }, "Level")
				else
					local distance = tbl18:GetDistance(questInfo[2])

					if distance and distance <= 5 then
						tbl18:FireRemote("StartQuest", questInfo[4], questInfo[1])
					else
						tbl18:ExecuteTween(questInfo[2])
					end
				end
			elseif chooseMasteryMode == "Bone" then
				fn18({ "Reborn Skeleton", "Demonic Soul", "Living Zombie", "Possessed Mummy" }, "Bone")
			elseif chooseMasteryMode == "Cake Prince" then
				fn18({ "Baking Staff", "Head Baker", "Cake Guard", "Cookie Crafter" }, "Cake Prince")
			elseif chooseMasteryMode == "Neareast" then
				local huge = math.huge
				local v30 = nil

				for _, child in pairs(tbl6.Enemies:GetChildren()) do
					if child and child.PrimaryPart and tbl18:IsEntityAlive(child) then
						local magnitude = (child.PrimaryPart.Position - localPlayer.Character.PrimaryPart.Position).Magnitude

						if magnitude < huge and magnitude <= 3500 then
							huge = magnitude
							v30 = child
						end
					end
				end

				if v30 then
					fn18({ v30.Name }, "Neareast")
				end
			end
		end)
	end)

	local v30 = v12:AddSection("Collection Farming")
	v30:AddSeperator({ "Chest Collection" })

	result2:Toggle(v30, "Auto Hop If No Chest", "Hop if no chests found", "Save", function(arg)
		tbl16:SetSave("Auto Hop If Chest Is Not Found", arg)
	end)

	result2:Toggle(v30, "Stop on Rare Items", "Stop if rare items owned", "Save", function(arg)
		tbl16:SetSave("Disable Auto Collect Chest If Have Item", arg)
	end)

	local v31 = result2:Toggle(v30, "Auto Collect Chest", "Collect chests", "Save", function(arg)
		tbl16:SetSave("Auto Collect Chest", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Collect Chest", function()
			if not tbl18:CheckStackPriority("Auto Collect Chest") then
				return
			end
			local disableAutoCollectChestIfHaveIte = tbl14["Disable Auto Collect Chest If Have Item"]
			local v32

			if disableAutoCollectChestIfHaveIte then
				v32 = tbl18:HasTool("God's Chalice") or tbl18:HasTool("Fist of Darkness")
			else
				v32 = disableAutoCollectChestIfHaveIte
			end

			if v32 then
				v31:SetValue(false)
				return
			end

			if not tbl18:IsEntityAlive(localPlayer.Character) then
				return
			end
			local position = localPlayer.Character.PrimaryPart.Position
			local huge = math.huge
			local v33 = nil

			for _, v34 in ipairs(tbl5.CollectionService:GetTagged("_ChestTagged")) do
				if not v34:GetAttribute("IsDisabled") then
					local magnitude = (v34:GetPivot().Position - position).Magnitude

					if magnitude < huge then
						huge = magnitude
						v33 = v34
					end
				end
			end

			if v33 then
				tbl18:ExecuteTween(v33.CFrame)
			elseif tbl14["Auto Hop If Chest Is Not Found"] then
				tbl18:ServerHop("Singapore", 8)
			end
		end)
	end)

	v30:AddSeperator({ "Berry Collection" })

	result2:Toggle(v30, "Auto Collect Berry", "Collect berries", "Save", function(arg)
		tbl16:SetSave("Auto Collect Berry", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Collect Berry", function()
			if not tbl18:CheckStackPriority("Auto Collect Berry") then
				return
			end

			for _, descendant in pairs(tbl5.Workspace.Map:GetDescendants()) do
				if descendant.Name == "Berries" then
					for i = 1, 8 do
						if descendant:GetAttribute("_BerryCFrame" .. i) then
							tbl18:ExecuteTween(descendant.Parent.WorldPivot)

							for _, child in pairs(descendant:GetChildren()) do
								if tbl18:GetDistance(child.WorldPivot) > 5 then
									tbl18:ExecuteTween(child.WorldPivot)
								else
									tbl18:FindNearestPrompt(10)
								end
							end
						end
					end
				end
			end
		end)
	end)

	if not tbl8[1] then
		local v32 = v12:AddSection("Farming " .. (tbl8[2] and "Factory" or tbl8[3] and "Pirates Sea" or "Other"))

		if tbl8[2] then
			result2:Toggle(v32, "Auto Factory", "Destroy factory core", "Save", function(arg)
				tbl16:SetSave("Auto Factory", arg)
				tbl18:StopTween(arg)
			end)

			tbl4.__spawn(function()
				tbl18:CreateLoop("Auto Factory", function()
					if tbl18:FindEnemy({ "Core" }) then
						tbl18:EngageEnemy({ "Core" })
					else
						tbl18:ExecuteTween(CFrame.new(502.7349853515625, 143.07490539550781, -379.078125))
					end
				end)
			end)
		elseif tbl8[3] then
			result2:Toggle(v32, "Auto Pirates Sea", "Farm in Pirates Sea", "Save", function(arg)
				tbl16:SetSave("Auto Pirates Sea", arg)
				tbl18:StopTween(arg)
			end)

			tbl4.__spawn(function()
				tbl18:CreateLoop("Auto Pirates Sea", function()
					local v33 = nil

					for _, child in pairs(tbl6.Enemies:GetChildren()) do
						if child.Name ~= "rip_indra True Form" and child.Name ~= "Blank Buddy" then
							local humanoid = child:FindFirstChild("Humanoid")

							if humanoid and humanoid.Health > 0 and child.PrimaryPart then
								if (child.PrimaryPart.Position - Vector3.new(-5556, 314, -2988)).Magnitude < 700 then
									v33 = child
									break
								else
									v33 = nil
								end
							else
								v33 = nil
							end
						else
							v33 = nil
						end
					end

					if v33 then
						tbl18:EngageEnemy({ v33.Name })
					else
						tbl18:ExecuteTween(CFrame.new(Vector3.new(-5556, 314, -2988)))
					end
				end)
			end)
		end
	end

	local v32 = v12:AddSection("Boss Farming")

	local v33 = result2:Dropdown(v32, "Select Boss", "Choose boss to farm", false, tbl18:GetBossList(), "Save", function(arg)
		tbl16:SetSave("Choose Boss", arg)
	end)

	result2:Button(v32, "Refresh Boss List", "Update boss list", function()
		v33:Clear()
		v33:Refresh(tbl18:GetBossList(), { "" })
	end)

	result2:Toggle(v32, "Auto Attack Boss", "Attack selected boss", "Save", function(arg)
		tbl16:SetSave("Auto Attack Boss", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Attack Boss", function()
			if not tbl18:CheckStackPriority("Auto Attack Boss") then
				return
			end
			tbl18:EngageEnemy({ tbl14["Choose Boss"] })
		end)
	end)

	result2:Toggle(v32, "Auto Attack All Bosses", "Attack all bosses", "Save", function(arg)
		tbl16:SetSave("Auto Attack All Boss", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Attack All Boss", function()
			if not tbl18:CheckStackPriority("Auto Attack All Boss") then
				return
			end

			tbl18:EngageEnemy({
				"Greybeard",
				"The Saw",
				"Saber Expert",
				"The Gorilla King",
				"Bobby",
				"Yeti",
				"Vice Admiral",
				"Warden",
				"Chief Warden",
				"Swan",
				"Magma Admiral",
				"Fishman Lord",
				"Wysper",
				"Thunder God",
				"Cyborg",
				"Darkbeard",
				"Cursed Captain",
				"Order",
				"Don Swan",
				"Diamond",
				"Jeremy",
				"Fajita",
				"Smoke Admiral",
				"Awakened Ice Admiral",
				"Tide Keeper",
				"Dough King",
				"Cake Prince",
				"rip_indra True Form",
				"Soul Reaper",
				"Stone",
				"Island Empress",
				"Kilo Admiral",
				"Captain Elephant",
				"Beautiful Pirate",
				"Cake Queen",
				"Longma",
			})
		end)
	end)

	local v34 = v12:AddSection("Material Farming")

	result2:Dropdown(v34, "Select Material", "Choose material to farm", false, tbl18:GetMaterialList(), "Save", function(arg)
		tbl16:SetSave("Choose Material", arg)
	end)

	result2:Toggle(v34, "Auto Farm Material", "Farm selected material", "Save", function(arg)
		tbl16:SetSave("Auto Farm Material", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Farm Material", function()
			if not tbl18:CheckStackPriority("Auto Farm Material") then
				return
			end
			local materialData = tbl18:GetMaterialData(tbl14["Choose Material"])

			if materialData then
				if tbl18:FindEnemy(materialData.NPCs) then
					tbl18:EngageEnemy(materialData.NPCs)
				else
					tbl18:ExecuteTween(materialData.Position)
				end
			end
		end)
	end)

	local v35 = v13:AddSection("Third World")
	v35:AddSeperator({ "Sword Collection" })

	result2:Dropdown(v35, "Select Sword", "Sword to obtain", false, {
		"Twin Hooks",
		"Buddy Sword",
		"Canvander",
		"Dark Dagger",
		"Fox Lamp",
		"Spikey Trident",
		"Yama",
		"Hallow Scythe",
	}, "Save", function(arg)
		tbl16:SetSave("Choose Sword", arg)
	end)

	result2:Toggle(v35, "Auto Get Sword", "Obtain selected sword", "Save", function(arg)
		tbl16:SetSave("Auto Get Sword", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Get Sword", function()
			local chooseSword = tbl14["Choose Sword"]

			if chooseSword == "Twin Hooks" then
				tbl18:EngageEnemy({ "Captain Elephant" })
			elseif chooseSword == "Buddy Sword" then
				tbl18:EngageEnemy({ "Cake Queen" })
			elseif chooseSword == "Canvander" then
				tbl18:EngageEnemy({ "Beautiful Pirate" })
			elseif chooseSword == "Dark Dagger" then
				tbl18:EngageEnemy({ "rip_indra True Form" })
			elseif chooseSword == "Fox Lamp" then
				if tbl5.Workspace:FindFirstChild("KitsuneIsland") then
					if tbl18:GetMaterialCount("Azure Ember") >= 20 then
						tbl6.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()
					elseif tbl5.Workspace:FindFirstChild("AttachedAzureEmber") then
						tbl18:ExecuteTween(tbl5.Workspace:WaitForChild("EmberTemplate"):FindFirstChild("Part").CFrame, 500)
					end
				end
			elseif chooseSword == "Spikey Trident" then
				tbl18:EngageEnemy({ "Dough King" })
			elseif chooseSword == "Yama" then
				if tbl18:FireRemote("EliteHunter", "Progress") >= 30 then
					fireclickdetector(tbl5.Workspace.Map.Waterfall.SealedKatana.Handle.ClickDetecter)
				end
			elseif chooseSword == "Hallow Scythe" then
				if tbl18:FindEnemy({ "Soul Reaper" }) then
					tbl18:EngageEnemy({ "Soul Reaper" })
				elseif tbl18:HasTool("Hallow Essence") then
					tbl18:EquipToolByName("Hallow Essence")

					pcall(function()
						tbl18:ExecuteTween(tbl5.Workspace.Map["Haunted Castle"].Summoner.Detection.CFrame)
					end)
				else
					tbl18:ExecuteTween(CFrame.new(-9529, 316, 6712))
				end
			end
		end)
	end)

	v35:AddSeperator({ "Gun Collection" })

	result2:Toggle(v35, "Auto Get Serpent Bow", "Farm Island Empress for bow", "Save", function(arg)
		tbl16:SetSave("Auto Get Serpent Bow", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Get Serpent Bow", function()
			if tbl18:FindEnemy({ "Island Empress" }) then
				tbl18:EngageEnemy({ "Island Empress" })
			else
				tbl18:ExecuteTween(CFrame.new(5659, 602, 244))
			end
		end)
	end)

	v35:AddSeperator({ "Bone Farming" })
	local v36 = v35:AddParagraph({ Title = "Bones Collected", Content = "0" })

	tbl4.__spawn(function()
		while task.wait(2) do
			v36:Set({ Title = "Bones Collected", Content = tostring(tbl18:GetMaterialCount("Bones")) })
		end
	end)

	result2:Toggle(v35, "Auto Soul Reaper", "Farm Soul Reaper", "Save", function(arg)
		tbl16:SetSave("Auto Soul Reaper", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Soul Reaper", function()
			if not tbl18:CheckStackPriority("Auto Soul Reaper") then
				return
			end

			if tbl18:FindEnemy({ "Soul Reaper" }) then
				tbl18:EngageEnemy({ "Soul Reaper" })
			elseif tbl18:HasTool("Hallow Essence") then
				tbl18:EquipToolByName("Hallow Essence")

				pcall(function()
					tbl18:ExecuteTween(tbl5.Workspace.Map["Haunted Castle"].Summoner.Detection.CFrame)
				end)
			else
				tbl18:ExecuteTween(CFrame.new(-9529, 316, 6712))
			end
		end)
	end)

	result2:Toggle(v35, "Auto Farm Bones", "Farm skeletons", "Save", function(arg)
		tbl16:SetSave("Auto Farm Bones", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Farm Bones", function()
			if not tbl18:CheckStackPriority("Auto Farm Bones") then
				return
			end
			local tbl36 = { "Reborn Skeleton", "Demonic Soul", "Living Zombie", "Possessed Mummy" }

			if tbl18:FindEnemy({ "Soul Reaper" }) then
				tbl18:EngageEnemy({ "Soul Reaper" })
			elseif tbl18:FindEnemy(tbl36) then
				tbl18:EngageEnemy(tbl36)
			else
				tbl18:ExecuteTween(CFrame.new(-9516.9853515625, 142.47166442871094, 5536.74755859375))
			end
		end)
	end)

	result2:Toggle(v35, "Auto Trade Bones", "Trade bones for rewards", "Save", function(arg)
		tbl16:SetSave("Auto Trade Bones", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Trade Bones", function()
			tbl18:FireRemote("Bones", "Buy", 1, 1)
		end)
	end)

	v35:AddSeperator({ "Cake Prince & Dough King" })
	local v37 = v35:AddParagraph({ Title = "Boss Status", Content = "Checking..." })

	tbl4.__spawn(function()
		while task.wait(2) do
			if tbl18:FindEnemy({ "Dough King" }) then
				v37:Set({ Title = "Boss Status", Content = "Dough King is Spawned!" })
			elseif tbl18:FindEnemy({ "Cake Prince" }) then
				v37:Set({ Title = "Boss Status", Content = "Cake Prince is Spawned!" })
			else
				v37:Set({
					Title = "Boss Status",
					Content = "Progress: " .. (tbl8[3] and string.gsub(tostring(tbl6.CommF_:InvokeServer("CakePrinceSpawner", true)), "%D", "") or "N/A") .. "%",
				})
			end
		end
	end)

	result2:Toggle(v35, "Auto Cake Prince", "Farm Cake Prince", "Save", function(arg)
		tbl16:SetSave("Auto Cake Prince", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Cake Prince", function()
			if not tbl18:CheckStackPriority("Auto Cake Prince") then
				return
			end
			local cframe = CFrame.new(-2090.6201171875, 70.349876403808594, -12125.5556640625)

			if tbl18:FindEnemy({ "Cake Prince", "Dough King" }) then
				if localPlayer:DistanceFromCharacter(Vector3.new(-1990.6726, 4532.9995, -14973.675)) > 5294.99853515625 then
					tbl18:ExecuteTween(cframe)
				elseif localPlayer:DistanceFromCharacter(Vector3.new(-1990.6726, 4532.9995, -14973.675)) <= 5294.99853515625 then
					tbl18:InteractWithMirror()
				else
					tbl18:EngageEnemy({ "Cake Prince", "Dough King" })
				end
			elseif tbl18:FindEnemy({ "Baking Staff", "Head Baker", "Cake Guard", "Cookie Crafter" }) then
				tbl18:EngageEnemy({ "Baking Staff", "Head Baker", "Cake Guard", "Cookie Crafter" })
				local response2 = tbl6.CommF_:InvokeServer("CakePrinceSpawner", true)

				if response2 and response2:find("open the portal now") then
					tbl6.CommF_:InvokeServer("CakePrinceSpawner")
				end
			else
				tbl18:ExecuteTween(CFrame.new(-2072.1494140625, 70.133811950683594, -12097.0849609375))
			end
		end)
	end)

	result2:Toggle(v35, "Auto Dough King", "Summon and fight Dough King", "Save", function(arg)
		tbl16:SetSave("Auto Dough King", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Dough King", function()
			if not tbl18:CheckStackPriority("Auto Dough King") then
				return
			end

			if tbl18:HasTool("God's Chalice") then
				local response2 = tbl6.CommF_:InvokeServer("SweetChaliceNpc")

				if response2 and string.find(response2, "Where") then
					tbl18:EngageEnemy({ "Chocolate Bar Battler", "Cocoa Warrior" })
				else
					tbl6.CommF_:InvokeServer("SweetChaliceNpc")
				end
			elseif tbl18:HasTool("Sweet Chalice") then
				local response2 = tbl6.CommF_:InvokeServer("CakePrinceSpawner")

				if response2 and string.find(response2, "Do you want to open the portal now?") then
					tbl6.CommF_:InvokeServer("CakePrinceSpawner")
				else
					tbl18:EngageEnemy({ "Baking Staff", "Head Baker", "Cake Guard", "Cookie Crafter" })
				end
			elseif tbl18:FindEnemy({ "Dough King" }) then
				tbl18:EngageEnemy({ "Dough King" })
			end
		end)
	end)

	v35:AddSeperator({ "Elite Hunter" })
	local v38 = v35:AddParagraph({ Title = "Elite Status", Content = "Checking..." })
	local v39 = v35:AddParagraph({ Title = "Elite Progress", Content = "0/30" })

	tbl4.__spawn(function()
		while task.wait(2) do
			v38:Set({
				Title = "Elite Status",
				Content = tbl18:FindEnemy({ "Diablo", "Deandre", "Urban" }) and "Elite is Spawned!" or "Elite is not Spawned",
			})
		end
	end)

	tbl4.__spawn(function()
		while task.wait(2) do
			v39:Set({
				Title = "Elite Progress",
				Content = (tbl8[3] and tostring(tbl6.CommF_:InvokeServer("EliteHunter", "Progress")) or "N/A") .. "/30",
			})
		end
	end)

	result2:Toggle(v35, "Auto Elite Hunter", "Complete elite quests", "Save", function(arg)
		tbl16:SetSave("Auto Elite Hunter", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Elite Hunter", function()
			if not tbl18:CheckStackPriority("Auto Elite Hunter") then
				return
			end
			local tbl36 = { "Diablo", "Deandre", "Urban" }

			if tbl18:FindEnemy(tbl36) and tbl18:isQuestOn() then
				tbl18:EngageEnemy(tbl36)
			else
				if tbl18:HasTool("God's Chalice") then
					tbl18:FireRemote("requestEntrance", Vector3.new(-12471.17, 374.94025, -7551.6777))
					return
				end

				if not tbl18:isQuestOn() then
					tbl18:FireRemote("EliteHunter")
				end
			end
		end)
	end)

	v35:AddSeperator({ "Haki Color" })

	result2:Toggle(v35, "Auto Buy Haki Colors", "Purchase all Haki colors", "Save", function(arg)
		tbl16:SetSave("Auto Buy Haki Color", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Buy Haki Color", function()
			tbl18:FireRemote("ColorsDealer", "1")
			tbl18:FireRemote("ColorsDealer", "2")
		end)
	end)

	result2:Toggle(v35, "Auto Rainbow Haki", "Complete quests for Rainbow Haki", "Save", function(arg)
		tbl16:SetSave("Auto Rainbow Haki", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Rainbow Haki", function()
			local tbl36 = {}
			local tbl37 = { name = "Stone", pos = CFrame.new(-1049, 40, 6791) }
			local tbl38 = { name = "Island Empress", pos = CFrame.new(5730, 602, 199) }
			local tbl39 = { name = "Kilo Admiral", pos = CFrame.new(2889, 424, -7233) }
			local tbl40 = { name = "Captain Elephant", pos = CFrame.new(-13393, 319, -8423) }
			local tbl41 = { name = "Beautiful Pirate", pos = CFrame.new(5241, 23, 129) }
			tbl36[1] = tbl37
			tbl36[2] = tbl38
			tbl36[3] = tbl39
			tbl36[4] = tbl40
			tbl36[5] = tbl41
			local v40, v41, v42 = ipairs(tbl36)
			local flag = false

			for _, v43 in v40, v41, v42 do
				if tbl18:FindEnemy({ v43.name }) then
					tbl18:EngageEnemy({ v43.name })
					flag = true
					break
				end
			end

			if not flag then
				for _, v43 in ipairs(tbl36) do
					if not tbl18:FindEnemy({ v43.name }) then
						tbl18:ExecuteTween(v43.pos)
						break
					end
				end

				tbl18:FireRemote("HornedMan", "Bet")
			end
		end)
	end)

	result2:Toggle(v13:AddSection("Dragon Hunter"), "Auto Dragon Hunter Quests", "Complete Dragon Hunter quests", "Save", function(arg)
		tbl16:SetSave("Auto Dragon Hunter Quests", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		local flag = true
		local v40 = nil
		local cframe = CFrame.new(5863.67725, 1209.87292, 809.94458)

		local function fn18()
			local response2 = tbl6.Net["RF/DragonHunter"]:InvokeServer({ Context = "Check" })
			if response2 and response2.Text then
				return response2.Text
			end
			return tbl6.Net["RF/DragonHunter"]:InvokeServer({ Context = "RequestQuest" }).Text
		end

		local function fn19()
			if not tbl5.Workspace:FindFirstChild("EmberTemplate") then
				return false
			end

			for _, child in pairs(tbl5.Workspace:GetChildren()) do
				if child.Name == "EmberTemplate" and child:FindFirstChild("Part") then
					while true do
						tbl5.RunService.Heartbeat:Wait()
						tbl18:ExecuteTween(child.Part.CFrame)
						if not (not child or not child:FindFirstChild("Part") or not child.Parent or not tbl14["Auto Dragon Hunter Quests"]) then
							continue
						end
						break
					end

					return true
				end
			end

			return false
		end

		local function fn20(arg)
			local tbl36 = {}

			for _, child in pairs(tbl5.Workspace.Map.Waterfall.IslandModel:GetChildren()) do
				if child.Name == "Tree" and child:FindFirstChild("Group") then
					if child.Group:FindFirstChild("Meshes/bambootree") then
						table.insert(tbl36, child)
					end
				end
			end

			local n6 = 0

			for _, v41 in ipairs(tbl36) do
				if not (arg <= n6) then
					while true do
						tbl5.RunService.Heartbeat:Wait()

						if not tbl14["Auto Dragon Hunter Quests"] then
							break
						else
							tbl18:ExecuteTween(v41.WorldPivot)
							tbl18:EquipToolByTip("Melee")

							for _, v42 in ipairs({ "Z", "X", "C", "V", "F" }) do
								if tbl18:IsSkillAvailable(v42) then
									tbl18:SendKeyPress(v42)
								end
							end

							if not (not v41 or not v41.Parent or tbl5.Workspace:FindFirstChild("EmberTemplate") or flag or n6 >= arg or not tbl14["Auto Dragon Hunter Quests"]) then
								continue
							end
							break
						end
					end

					n6 += 1
					continue
				end

				break
			end

			if n6 < arg then
				flag = true
			end

			return n6
		end

		tbl18:CreateLoop("Auto Dragon Hunter Quests", function()
			if flag then
				if not tbl18:TweenToTargetIfFar(cframe, 10) then
					v40 = fn18()

					while true do
						tbl5.RunService.Heartbeat:Wait()
						if not (type(v40) == "string" or not tbl14["Auto Dragon Hunter Quests"] or not flag) then
							continue
						end
						break
					end

					flag = false
				end
			end

			if v40 and not flag then
				local str3 = string.find(v40, "Hydra Enforcers")
				local v41 = string.find(v40, "Venomous Assailants")

				if str3 or v41 then
					if not flag then
						str3 = str3 and "Hydra Enforcer" or "Venomous Assailant"
						local cframe2 = CFrame.new(5257.92285, 1005.51074, 383.1138, -0.277849764, -0.000232859355, 0.960624516, -2.70488472e-05, 1, 0.000234580555, -0.960624516, 3.91943649e-05, -0.277849764)

						if tbl18:FindEnemy({ str3 }) then
							tbl18:EngageEnemy({ str3 })
						else
							tbl18:ExecuteTween(cframe2)
						end

						if tbl5.Workspace:FindFirstChild("EmberTemplate") then
							flag = fn19()
						end
					end
				else
					local n6 = 10

					if string.find(v40, "/") then
						local v42 = string.split(v40, " ")

						if #v42 >= 2 then
							n6 = tonumber(string.split(v42[2], "/")[2]) or 10
						end
					end

					if fn20(n6) < n6 then
						if not flag then
							flag = fn19()
						end
					end
				end
			end
		end)
	end)

	result2:Toggle(v13:AddSection("Tyrant of the Skies"), "Auto Kill Tyrant of the Skies", "Defeat Tyrant of the Skies", "Save", function(arg)
		tbl16:SetSave("Auto Kill Tyrant of the Skies", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Kill Tyrant of the Skies", function()
			if not tbl18:CheckStackPriority("Auto Kill Tyrant of the Skies") then
				return
			end

			if tbl18:FindEnemy({ "Auto Kill Tyrant of the Skies" }) then
				tbl18:EngageEnemy({ "Auto Kill Tyrant of the Skies" })
			else
				tbl18:ExecuteTween(CFrame.new(-16557, 202, 508))
			end
		end)
	end)

	result2:Toggle(v13:AddSection("Citizen Quest"), "Auto Citizen Quest", "Complete citizen quests", "Save", function(arg)
		tbl16:SetSave("Auto Citizen Quest", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Citizen Quest", function()
			if not tbl18:CheckStackPriority("Auto Citizen Quest") then
				return
			end
			local tbl36 = { "Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate" }

			if tbl18:isQuestOn() then
				if tbl18:FindEnemy(tbl36) then
					tbl18:EngageEnemy(tbl36)
				end
			elseif tbl18:GetDistance(Vector3.new(-11893.7, 929.661, -8760.59)) < 8 then
				tbl18:FireRemote("HornedMan", "Bet")
			else
				tbl18:ExecuteTween(CFrame.new(Vector3.new(-11893.7, 929.661, -8760.59)))
			end
		end)
	end)

	local v40 = v14:AddSection("Kitsune Island")
	local v41 = v40:AddParagraph({ Title = "Island Status", Content = "Checking..." })
	local v42 = v40:AddParagraph({ Title = "Azure Ember", Content = "0" })

	tbl4.__spawn(function()
		while task.wait(2) do
			v41:Set({
				Title = "Island Status",
				Content = tbl5.Workspace.Map:FindFirstChild("KitsuneIsland") and "Kitsune Island is Spawned!" or "Kitsune Island is not Spawned",
			})
		end
	end)

	tbl4.__spawn(function()
		while task.wait(2) do
			v42:Set({ Title = "Azure Ember", Content = tostring(tbl18:GetMaterialCount("Azure Ember")) })
		end
	end)

	result2:Toggle(v40, "Auto Summon Kitsune Island", "Sail to summon Kitsune Island", "Save", function(arg)
		tbl16:SetSave("Auto Summon Kitsune Island", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Summon Kitsune Island", function()
			if not tbl5.Workspace.Map:FindFirstChild("KitsuneIsland") then
				local playerBoat = tbl18:GetPlayerBoat()

				if not playerBoat then
					if localPlayer:DistanceFromCharacter(tbl9.BoatShopPos[2]) < 10 and localPlayer.Character and localPlayer.Character.Humanoid.Health > 0 then
						tbl18:FireRemote("BuyBoat", "PirateBrigade")
					else
						tbl18:ExecuteTween(tbl9.BoatShop[2])
					end
				elseif playerBoat then
					local vehicleSeat = playerBoat:FindFirstChild("VehicleSeat")
					local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

					if not humanoid or not humanoid.Sit then
						if vehicleSeat then
							tbl18:ExecuteTween(vehicleSeat.CFrame)
						end
					else
						tbl18:ExecuteBoatTween(playerBoat, playerBoat.PrimaryPart.CFrame * CFrame.new(0, 5, -50000))
					end
				end
			elseif tbl5.Workspace.Map:FindFirstChild("KitsuneIsland") then
				local shrineActive = tbl5.Workspace.Map.KitsuneIsland:FindFirstChild("ShrineActive")

				if shrineActive and shrineActive:FindFirstChild("NeonShrinePart") then
					tbl18:ExecuteTween(shrineActive.NeonShrinePart.CFrame * CFrame.new(0, 40, 10))
				end
			end
		end)
	end)

	result2:Toggle(v40, "Tween to Kitsune Island", "Teleport to Kitsune Island", "Save", function(arg)
		tbl16:SetSave("Tween to Kitsune Island", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Tween to Kitsune Island", function()
			if tbl5.Workspace.Map and tbl5.Workspace.Map:FindFirstChild("KitsuneIsland") then
				local shrineActive = tbl5.Workspace.Map.KitsuneIsland:FindFirstChild("ShrineActive")

				if shrineActive and shrineActive:FindFirstChild("NeonShrinePart") then
					tbl18:ExecuteTween(shrineActive.NeonShrinePart.CFrame + Vector3.new(0, 0, 5))
				end
			end
		end)
	end)

	result2:Toggle(v40, "Auto Collect Azure Ember", "Collect Azure Ember", "Save", function(arg)
		tbl16:SetSave("Auto Collect Azure Ember", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Collect Azure Ember", function()
			if tbl5.Workspace:FindFirstChild("AttachedAzureEmber") then
				local emberTemplate = tbl5.Workspace:FindFirstChild("EmberTemplate")

				if emberTemplate and emberTemplate:FindFirstChild("Part") then
					tbl18:ExecuteTween(emberTemplate.Part.CFrame, 500)
				end
			end
		end)
	end)

	result2:Toggle(v40, "Auto Trade Azure Ember", "Trade Azure Ember", "Save", function(arg)
		tbl16:SetSave("Auto Trade Azure Ember", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Trade Azure Ember", function()
			local rfKitsuneStatuePray = tbl6.Net:FindFirstChild("RF/KitsuneStatuePray")

			if rfKitsuneStatuePray then
				rfKitsuneStatuePray:InvokeServer()
			end

			tbl18:FireRemote("KitsuneStatuePray")
		end)
	end)

	local v43 = v14:AddSection("Sea Event")

	result2:Dropdown(v43, "Danger Level", "Sea danger level", false, { "1", "2", "3", "4", "5", "6", "infinite" }, { "6" }, function(arg)
		tbl16:SetSave("Select Level Danger", arg)
	end)

	result2:Dropdown(v43, "Boat Type", "Boat to purchase", false, { "PirateBrigade", "PirateGrandBrigade", "Beast Hunter", "MarineBrigade", "MarineGrandBrigade" }, { "PirateBrigade" }, function(arg)
		tbl16:SetSave("Select Buy Boat", arg)
	end)

	result2:Dropdown(v43, "Combat Weapon", "Weapon for sea combat", false, { "Melee", "Blox Fruit", "Gun", "Sword", "Random" }, { "Random" }, function(arg)
		tbl16:SetSave("Choose Equip ", arg)
	end)

	result2:Dropdown(v43, "Combat Skills", "Skills to use", true, { "Z", "X", "C", "V", "F" }, { "Z", "X", "C", "V" }, function(arg)
		tbl16:SetSave("Skill  ", arg, true)
	end)

	result2:Toggle(v43, "Protect Boat", "Auto-repair boat", true, function(arg)
		tbl16:SetSave("Protect Boat", arg)
	end)

	tbl4.__spawn(function()
		local cFrame = nil

		tbl18:CreateLoop("Protect Boat", function()
			if tbl14["Auto Summon Prehistoric Island"] or tbl14["Auto Summon Mirage Island"] or tbl14["Auto Summon Kitsune Island"] then
				return
			end
			local playerBoat = tbl18:GetPlayerBoat()
			local character = localPlayer.Character
			if not (tbl18:IsEntityAlive(character) and playerBoat and playerBoat:FindFirstChild("VehicleSeat")) then
				return
			end
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid and not humanoid.Sit then
				local flag = tbl18:FindEnemy({ "PirateGrandBrigade", "PirateBrigade", "FishBoat" }, 9e9, "Boat") or tbl18:FindEnemy({ "Terrorshark", "Piranha", "Fish Crew Member", "Shark" }, 9e9)

				if not flag then
					local seaBeast1 = tbl5.Workspace.SeaBeasts:FindFirstChild("SeaBeast1")
					seaBeast1 = seaBeast1 and seaBeast1:FindFirstChild("HumanoidRootPart")

					if seaBeast1 and tbl18:GetDistance(seaBeast1.Position) <= 9e9 then
						flag = true
					end
				end

				if flag then
					if not cFrame then
						cFrame = playerBoat.VehicleSeat.CFrame
					end

					local random = math.random
					playerBoat.VehicleSeat.CFrame = cFrame + Vector3.new(math.random(75, 100), math.random(75, 100), random(75, 100))
				elseif cFrame then
					playerBoat.VehicleSeat.CFrame = cFrame
					cFrame = nil
				end
			else
				cFrame = nil
			end
		end)
	end)

	result2:Toggle(v43, "No Fog", "Remove fog", "Save", function(arg)
		tbl16:SetSave("No Fog", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("No Fog", function()
			tbl5.Lighting.FogEnd = 1e10
			tbl5.Lighting.Brightness = 2
			tbl5.Lighting.GlobalShadows = false
			tbl5.Lighting.ClockTime = 14
			tbl5.Lighting.ExposureCompensation = 0
		end)
	end)

	result2:Toggle(v43, "Auto Dodge Rough Sea", "Avoid rough sea", true, function(arg)
		tbl16:SetSave("Auto Dodge Rough Sea", arg)
	end)

	result2:Toggle(v43, "No Clip Rock", "Pass through rocks", true, function(arg)
		tbl16:SetSave("No Clip Rock", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("No Clip Rock", function()
			local flag = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") and localPlayer.Character.Humanoid.Sit == true

			for _, descendant in pairs(tbl5.Workspace.Boats:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanCollide == flag then
					descendant.CanCollide = not flag
				end
			end

			for _, descendant in pairs(localPlayer.Character:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanCollide == flag then
					descendant.CanCollide = not flag
				end
			end
		end)
	end)

	v43:AddLine()

	result2:Toggle(v43, "Auto Farm Sea", "Farm sea enemies", "Save", function(arg)
		tbl16:SetSave("Auto Farm Sea", arg)
		tbl18:StopTween(arg)
	end)

	v43:AddLine()

	result2:Toggle(v43, "Farm Terrorshark", "Attack Terrorshark", true, function(arg)
		tbl16:SetSave("Terrorshark", arg)
	end)

	result2:Toggle(v43, "Dodge Terrorshark Skill", "Avoid Terrorshark attacks", true, function(arg)
		tbl16:SetSave("Auto Dodge Terrorshark Skill", arg)
	end)

	v43:AddLine()

	result2:Toggle(v43, "Attack Sea Beasts", "Attack Sea Beasts", true, function(arg)
		tbl16:SetSave("Attack Sea Beasts", arg)
	end)

	result2:Toggle(v43, "Dodge Sea Beasts Skill", "Avoid Sea Beast attacks", true, function(arg)
		tbl16:SetSave("Auto Dodge Sea Beasts Skill", arg)
	end)

	v43:AddLine()

	result2:Toggle(v43, "Attack Ghost Ship", "Attack Ghost Ships", true, function(arg)
		tbl16:SetSave("Attack Ghost Ship", arg)
	end)

	v43:AddLine()

	result2:Toggle(v43, "Attack Piranha", "Attack Piranha", true, function(arg)
		tbl16:SetSave("Attack Piranha", arg)
	end)

	result2:Toggle(v43, "Attack Shark", "Attack Shark", true, function(arg)
		tbl16:SetSave("Attack Shark", arg)
	end)

	result2:Toggle(v43, "Attack Fish Crew", "Attack Fish Crew", true, function(arg)
		tbl16:SetSave("Attack Fish Crew Member", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Farm Sea", function()
			if not tbl18:IsEntityAlive(localPlayer.Character) then
				return
			end
			local playerBoat = tbl18:GetPlayerBoat()
			local v44 = tbl18:FindEnemy({ "Terrorshark" }, 1000)
			local v45 = tbl18:FindEnemy({ "Piranha" }, 1000)
			local v46 = tbl18:FindEnemy({ "Shark" }, 1000)
			local v47 = tbl18:FindEnemy({ "Fish Crew Member" }, 1000)
			local v48 = tbl18:FindEnemy({ "PirateGrandBrigade", "PirateBrigade", "FishBoat" }, 1000, "Boat")
			local seaBeast1 = tbl5.Workspace.SeaBeasts:FindFirstChild("SeaBeast1")
			local v49 = tbl9.LevelSea[tbl14["Select Level Danger"]]

			if tbl14.Terrorshark and v44 and playerBoat then
				if v44.PrimaryPart then
					if tbl14["Auto Dodge Terrorshark Skill"] and v44.PrimaryPart.CFrame.Y > -3 then
						tbl18:ExecuteTween(v44.PrimaryPart.CFrame * CFrame.new(0, 600, 0))
					else
						tbl18:EngageEnemy({ "Terrorshark" })
					end
				end
			elseif tbl14["Attack Piranha"] and v45 and playerBoat then
				tbl18:EngageEnemy({ "Piranha" })
			elseif tbl14["Attack Shark"] and v46 and playerBoat then
				tbl18:EngageEnemy({ "Shark" })
			elseif tbl14["Attack Fish Crew Member"] and v47 and playerBoat then
				tbl18:EngageEnemy({ "Fish Crew Member" })
			elseif tbl14["Attack Ghost Ship"] and v48 and playerBoat then
				if v48.VehicleSeat then
					while true do
						task.wait()
						local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
						tbl18:ExecuteTween(humanoid and humanoid.Health <= 5000 and v48.VehicleSeat.CFrame * CFrame.new(0, 400, 0) or v48.VehicleSeat.CFrame)

						if tbl18:GetDistance(v48.VehicleSeat.CFrame) <= 50 then
							SetAim(v48.VehicleSeat.CFrame)
							tbl18:EquipToolByTip(tbl14["Choose Equip "] == "Random" and ({ "Melee", "Blox Fruit", "Sword", "Gun" })[math.random(1, 4)] or tbl14["Choose Equip "])

							for _, v50 in next, tbl14["Skill  "], nil do
								if tbl18:IsSkillAvailable(v50) then
									tbl18:SendKeyPress(v50)
								end
							end
						end

						if not (not v48 or not v48.Parent or not v48.VehicleSeat or not tbl14["Attack Ghost Ship"] or not tbl14["Auto Farm Sea"] or v9.Unloaded) then
							continue
						end
						break
					end
				end
			elseif tbl14["Attack Sea Beasts"] and seaBeast1 and playerBoat then
				local humanoidRootPart = seaBeast1:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart and tbl18:GetDistance(humanoidRootPart.Position) <= 5000 then
					TeleportToSeaBeast(seaBeast1)

					if tbl18:GetDistance(humanoidRootPart.Position) <= 800 then
						SetAim(humanoidRootPart.CFrame)
						tbl18:EquipToolByTip(tbl14["Choose Equip "] == "Random" and ({ "Melee", "Blox Fruit", "Sword", "Gun" })[math.random(1, 4)] or tbl14["Choose Equip "])

						for _, v50 in next, tbl14["Skill  "], nil do
							if tbl18:IsSkillAvailable(v50) then
								tbl18:SendKeyPress(v50)
							end
						end
					end
				end
			elseif playerBoat then
				local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")

				if not humanoid or not humanoid.Sit then
					local vehicleSeat = playerBoat:FindFirstChild("VehicleSeat")

					if vehicleSeat then
						tbl18:ExecuteTween(vehicleSeat.CFrame)
					end
				elseif tbl18:GetDistance(v49) > 15500 then
					tbl18:ExecuteBoatTween(playerBoat, v49 * CFrame.new(0, 20, 0))
				elseif tbl5.Lighting.RainCorrection and tbl5.Lighting.RainCorrection.Enabled and tbl14["Auto Dodge Rough Sea"] then
					tbl18:ExecuteBoatTween(playerBoat, localPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(-150, 20, 15))
				elseif tbl5.Workspace.SeaBeasts:FindFirstChild("SeaBeast1") and not tbl14["Attack Sea Beasts"] then
					tbl18:ExecuteBoatTween(playerBoat, localPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(-150, 20, 15))
				end
			elseif localPlayer:DistanceFromCharacter(tbl9.BoatShopPos[2]) < 10 and localPlayer.Character and localPlayer.Character.Humanoid.Health > 0 then
				tbl18:FireRemote("BuyBoat", tbl14["Select Buy Boat"])
				task.wait(1)
			else
				tbl18:ExecuteTween(tbl9.BoatShop[2])
			end
		end)
	end)

	local v44 = v14:AddSection("Leviathan Farming")
	v44:AddParagraph({ "Frozen Dimension" })
	local v45 = v44:AddParagraph({ Title = "Dimension Status", Content = "Checking..." })

	tbl4.__spawn(function()
		while task.wait(2) do
			v45:Set({
				Title = "Dimension Status",
				Content = tbl6.WorldOrigin.Locations:FindFirstChild("Frozen Dimension") and "Frozen Dimension is Spawned!" or "Frozen Dimension is not Spawned",
			})
		end
	end)

	result2:Toggle(v44, "Tween to Frozen Dimension", "Teleport to Frozen Dimension", "Save", function(arg)
		tbl16:SetSave("Tween to Frozen Dimension", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Tween to Frozen Dimension", function()
			local frozenDimension = tbl6.WorldOrigin.Locations:FindFirstChild("Frozen Dimension")

			if frozenDimension then
				tbl18:ExecuteTween(frozenDimension * CFrame.new(2, 20, 2))
			end
		end)
	end)

	v44:AddLine()

	result2:Toggle(v44, "Auto Find Leviathan", "Sail to find Leviathan", "Save", function(arg)
		tbl16:SetSave("Auto Find Leviathan", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Find Leviathan", function()
			if not tbl6.WorldOrigin.Locations:FindFirstChild("Frozen Dimension") then
				local playerBoat = tbl18:GetPlayerBoat()

				if not playerBoat then
					if localPlayer:DistanceFromCharacter(tbl9.BoatShopPos[2]) < 10 and localPlayer.Character and localPlayer.Character.Humanoid.Health > 0 then
						tbl18:FireRemote("BuyBoat", "Beast Hunter")
					else
						tbl18:ExecuteTween(tbl9.BoatShop[2])
					end
				elseif playerBoat then
					local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

					if not humanoid or not humanoid.Sit then
						local vehicleSeat = playerBoat:FindFirstChild("VehicleSeat")

						if vehicleSeat then
							tbl18:ExecuteTween(vehicleSeat.CFrame)
						end
					else
						tbl18:ExecuteBoatTween(playerBoat, CFrame.new(-118140.65625, 31.783639907836914, 172404.875))
					end
				end
			else
				local frozenDimension = tbl6.WorldOrigin.Locations:FindFirstChild("Frozen Dimension")

				if frozenDimension then
					tbl18:ExecuteTween(frozenDimension * CFrame.new(2, 20, 2))
				end
			end
		end)
	end)

	result2:Toggle(v44, "Auto Attack Leviathan", "Attack Leviathan", "Save", function(arg)
		tbl16:SetSave("Auto Attack Leviathan", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Attack Leviathan", function()
			for _, child in pairs(tbl5.Workspace.SeaBeasts:GetChildren()) do
				if child and child.Name == "Leviathan" and child.Health and child.Health.Value > 0 then
					local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart then
						while true do
							task.wait()
							tbl18:ExecuteTween(humanoidRootPart.CFrame * CFrame.new(0, 900, 100))

							if tbl18:GetDistance(humanoidRootPart.CFrame) <= 500000 then
								SetAim(humanoidRootPart.CFrame)
								tbl18:EquipToolByTip(({ "Melee", "Blox Fruit", "Sword", "Gun" })[math.random(1, 4)])

								for _, v46 in next, { "Z", "X", "C", "V", "F" }, nil do
									if tbl18:IsSkillAvailable(v46) then
										tbl18:SendKeyPress(v46)
									end
								end
							end

							if not (not child.Parent or child.Health.Value <= 0 or not tbl14["Auto Attack Leviathan"] or v9.Unloaded) then
								continue
							end
							break
						end
					end
				end
			end
		end)
	end)

	result2:Toggle(v44, "Auto Attack Leviathan Segment", "Attack Leviathan segments", "Save", function(arg)
		tbl16:SetSave("Auto Attack Leviathan Segment", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Attack Leviathan Segment", function()
			for _, child in pairs(tbl5.Workspace.SeaBeasts:GetChildren()) do
				if child and child.Name == "Leviathan Segment" and child.Health and child.Health.Value > 0 then
					local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart then
						while true do
							task.wait()
							tbl18:ExecuteTween(humanoidRootPart.CFrame * CFrame.new(0, 900, math.random(0, 350)))

							if tbl18:GetDistance(humanoidRootPart.CFrame) <= 500000 then
								SetAim(humanoidRootPart.CFrame)
								tbl18:EquipToolByTip(({ "Melee", "Blox Fruit", "Sword", "Gun" })[math.random(1, 4)])

								for _, v46 in next, { "Z", "X", "C", "V", "F" }, nil do
									if tbl18:IsSkillAvailable(v46) then
										tbl18:SendKeyPress(v46)
									end
								end
							end

							if not (not child.Parent or child.Health.Value <= 0 or not tbl14["Auto Attack Leviathan Segment"] or v9.Unloaded) then
								continue
							end
							break
						end
					end
				end
			end
		end)
	end)

	result2:Toggle(v44, "Auto Attack Leviathan Tail", "Attack Leviathan tail", "Save", function(arg)
		tbl16:SetSave("Auto Attack Leviathan Tail", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Attack Leviathan Tail", function()
			for _, child in pairs(tbl5.Workspace.SeaBeasts:GetChildren()) do
				if child and child.Name == "Leviathan Tail" and child.Health and child.Health.Value > 0 then
					local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart then
						while true do
							task.wait()
							tbl18:ExecuteTween(humanoidRootPart.CFrame * CFrame.new(0, 900, math.random(0, 350)))

							if tbl18:GetDistance(humanoidRootPart.CFrame) <= 500000 then
								SetAim(humanoidRootPart.CFrame)
								tbl18:EquipToolByTip(({ "Melee", "Blox Fruit", "Sword", "Gun" })[math.random(1, 4)])

								for _, v46 in next, { "Z", "X", "C", "V", "F" }, nil do
									if tbl18:IsSkillAvailable(v46) then
										tbl18:SendKeyPress(v46)
									end
								end
							end

							if not (not child.Parent or child.Health.Value <= 0 or not tbl14["Auto Attack Leviathan Tail"] or v9.Unloaded) then
								continue
							end
							break
						end
					end
				end
			end
		end)
	end)

	result2:Toggle(v14:AddSection("Wood Planks"), "Auto Wood Planks", "Farm wood planks from trees", "Save", function(arg)
		tbl16:SetSave("Auto Wood Planks", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Wood Planks", function()
			local v46 = tbl18:FindTree()

			if v46 and v46.PrimaryPart then
				while true do
					task.wait()
					tbl18:ExecuteTween(v46.PrimaryPart.CFrame)

					if tbl18:GetDistance(v46.PrimaryPart.Position) < 10 then
						tbl18:EquipToolByTip(({ "Melee", "Blox Fruit", "Sword", "Gun" })[math.random(1, 4)])

						for _, v47 in next, { "Z", "X", "C", "V", "F" }, nil do
							if tbl18:IsSkillAvailable(v47) then
								tbl18:SendKeyPress(v47)
							end
						end
					end

					if not (not v46 or not v46.Parent or not tbl14["Auto Wood Planks"] or v9.Unloaded) then
						continue
					end
					break
				end
			end
		end)
	end)

	local v46 = v14:AddSection("Prehistoric Island")
	local v47 = v46:AddParagraph({ Title = "Island Status", Content = "Checking..." })

	tbl4.__spawn(function()
		while task.wait(2) do
			v47:Set({
				Title = "Island Status",
				Content = tbl5.Workspace.Map:FindFirstChild("PrehistoricIsland") and "Prehistoric Island is Spawned!" or "Prehistoric Island is not Spawned",
			})
		end
	end)

	result2:Toggle(v46, "Auto Summon Prehistoric Island", "Sail to summon island", "Save", function(arg)
		tbl16:SetSave("Auto Summon Prehistoric Island", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Summon Prehistoric Island", function()
			if not tbl5.Workspace.Map:FindFirstChild("PrehistoricIsland") then
				local playerBoat = tbl18:GetPlayerBoat()

				if not playerBoat then
					if localPlayer:DistanceFromCharacter(tbl9.BoatShopPos[2]) < 10 and localPlayer.Character and localPlayer.Character.Humanoid.Health > 0 then
						tbl18:FireRemote("BuyBoat", "PirateBrigade")
					else
						tbl18:ExecuteTween(tbl9.BoatShop[2])
					end
				elseif playerBoat then
					local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

					if not humanoid or not humanoid.Sit then
						local vehicleSeat = playerBoat:FindFirstChild("VehicleSeat")

						if vehicleSeat then
							tbl18:ExecuteTween(vehicleSeat.CFrame)
						end
					else
						tbl18:ExecuteBoatTween(playerBoat, CFrame.new(-118140.65625, 31.783639907836914, 172404.875))
					end
				end
			else
				local prehistoricIsland = tbl5.Workspace.Map:FindFirstChild("PrehistoricIsland")

				if prehistoricIsland then
					tbl18:ExecuteTween(prehistoricIsland:GetPivot() * CFrame.new(2, 20, 2))
				end
			end
		end)
	end)

	result2:Toggle(v46, "Tween To Prehistoric Island", "Teleport to island", "Save", function(arg)
		tbl16:SetSave("Tween To Prehistoric Island", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Tween To Prehistoric Island", function()
			local prehistoricIsland = tbl5.Workspace.Map:FindFirstChild("PrehistoricIsland")

			if prehistoricIsland then
				tbl18:ExecuteTween(prehistoricIsland:GetPivot() * CFrame.new(2, 20, 2))
			end
		end)
	end)

	local v48 = v14:AddSection("Sea Items")

	result2:Toggle(v48, "Auto Shark Tooth Necklace", "Craft Shark Tooth Necklace", "Save", function(arg)
		tbl16:SetSave("Auto Shark Tooth Necklace", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Shark Tooth Necklace", function()
			if not tbl18:HasTool("Shark Tooth Necklace") then
				if tbl18:GetMaterialCount("Mutant Tooth") >= 1 and tbl18:GetMaterialCount("Shark Teeth") >= 5 then
					tbl18:FireRemote("CraftItem", "PossibleHardcode", "SharkAnchor")
					tbl18:FireRemote("CraftItem", "Check", "ToothNecklace")
					tbl18:FireRemote("CraftItem", "Craft", "ToothNecklace")
				elseif not tbl14["Auto Farm Sea"] then
					tbl14["Auto Farm Sea"] = true

					while true do
						task.wait()
						if not (tbl18:GetMaterialCount("Mutant Tooth") >= 1 and tbl18:GetMaterialCount("Shark Teeth") >= 5 or not tbl14["Auto Shark Tooth Necklace"] or v9.Unloaded) then
							continue
						end
						break
					end

					tbl14["Auto Farm Sea"] = false
				end
			end
		end)
	end)

	result2:Toggle(v48, "Auto Terror Jaw", "Craft Terror Jaw", "Save", function(arg)
		tbl16:SetSave("Auto Terror Jaw", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Terror Jaw", function()
			if not tbl18:HasTool("Terror Jaw") then
				if tbl18:GetMaterialCount("Terror Jaw") >= 1 and tbl18:GetMaterialCount("Mutant Teeth") >= 2 and tbl18:GetMaterialCount("Fool's Gold") >= 10 and tbl18:GetMaterialCount("Shark Teeth") >= 5 then
					tbl18:FireRemote("CraftItem", "PossibleHardcode", "SharkAnchor")
					tbl18:FireRemote("CraftItem", "Check", "TerrorJaw")
					tbl18:FireRemote("CraftItem", "Craft", "TerrorJaw")
				elseif not tbl14["Auto Farm Sea"] then
					tbl14["Auto Farm Sea"] = true

					while true do
						task.wait()
						if not (tbl18:GetMaterialCount("Terror Jaw") >= 1 and tbl18:GetMaterialCount("Mutant Teeth") >= 2 and tbl18:GetMaterialCount("Fool's Gold") >= 10 and tbl18:GetMaterialCount("Shark Teeth") >= 5 or not tbl14["Auto Terror Jaw"] or v9.Unloaded) then
							continue
						end
						break
					end

					tbl14["Auto Farm Sea"] = false
				end
			end
		end)
	end)

	result2:Toggle(v48, "Auto Monster Magnet", "Craft Monster Magnet", "Save", function(arg)
		tbl16:SetSave("Auto Monster Magnet", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Monster Magnet", function()
			if tbl18:GetMaterialCount("Monster Magnet") < 1 then
				if tbl18:GetMaterialCount("Terror Eyes") >= 2 and tbl18:GetMaterialCount("Electric Wings") >= 8 and tbl18:GetMaterialCount("Fool's Gold") >= 20 and tbl18:GetMaterialCount("Shark Teeth") >= 10 then
					tbl18:FireRemote("CraftItem", "Check", "SharkAnchor")
					tbl18:FireRemote("CraftItem", "Craft", "SharkAnchor")
				elseif not tbl14["Auto Farm Sea"] then
					tbl14["Auto Farm Sea"] = true

					while true do
						task.wait()
						if not (tbl18:GetMaterialCount("Terror Eyes") >= 2 and tbl18:GetMaterialCount("Electric Wings") >= 8 and tbl18:GetMaterialCount("Fool's Gold") >= 20 and tbl18:GetMaterialCount("Shark Teeth") >= 10 or not tbl14["Auto Monster Magnet"] or v9.Unloaded) then
							continue
						end
						break
					end

					tbl14["Auto Farm Sea"] = false
				end
			end
		end)
	end)

	result2:Toggle(v48, "Auto Shark Anchor", "Craft Shark Anchor", "Save", function(arg)
		tbl16:SetSave("Auto Shark Anchor", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Shark Anchor", function()
			if not tbl18:HasTool("Shark Anchor") then
				if tbl18:GetMaterialCount("Monster Magnet") >= 1 then
					if not tbl14["Auto Farm Sea"] then
						tbl14["Auto Farm Sea"] = true

						while true do
							task.wait()
							if not (tbl18:HasTool("Shark Anchor") or not tbl14["Auto Shark Anchor"] or v9.Unloaded) then
								continue
							end
							break
						end

						tbl14["Auto Farm Sea"] = false
					end
				elseif not tbl14["Auto Monster Magnet"] then
					tbl14["Auto Monster Magnet"] = true

					while true do
						task.wait()
						if not (tbl18:GetMaterialCount("Monster Magnet") >= 1 or not tbl14["Auto Shark Anchor"] or v9.Unloaded) then
							continue
						end
						break
					end

					tbl14["Auto Monster Magnet"] = false
				end
			end
		end)
	end)

	local Maps = v15:AddSection("Maps", true)

	result2:Dropdown(Maps, "Select Island", "Island to teleport to", false, tbl18:GetIslandList(), "Save", function(arg)
		tbl16:SetSave("Select Island", arg)
	end)

	result2:Toggle(Maps, "Tween To Island", "Auto teleport to island", "Save", function(arg)
		tbl16:SetSave("Tween To Island", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Tween To Island", function()
			tbl18:NavigateToIsland(tbl14["Select Island"])
		end)
	end)

	Maps:AddLine()

	result2:Button(Maps, "First World", "Teleport to First World", function()
		tbl18:FireRemote("TravelMain")
	end)

	result2:Button(Maps, "Second World", "Teleport to Second World", function()
		tbl18:FireRemote("TravelDressrosa")
	end)

	result2:Button(Maps, "Third World", "Teleport to Third World", function()
		tbl18:FireRemote("TravelZou")
	end)

	local Fruits = v16:AddSection("Fruits")
	Fruits:AddSeperator({ "Fruit Sniper" })
	local tbl36 = {}
	tbl6.CommF_:InvokeServer("GetFruits")
	local response2

	while true do
		task.wait()
		response2 = tbl6.CommF_:InvokeServer("GetFruits")
		if not (response2 and #response2 > 0) then
			continue
		end
		break
	end

	for _, v49 in response2, nil, nil do
		table.insert(tbl36, v49.Name)
	end

	result2:Dropdown(Fruits, "Sniper Fruits", "Fruits to buy", true, tbl36, "Save", function(arg)
		tbl16:SetSave("Sniper Fruits", arg, true)
	end)

	result2:Toggle(Fruits, "Auto Buy Fruits Sniper", "Buy fruits from Sniper", "Save", function(arg)
		tbl16:SetSave("Auto Buy Fruits Sniper", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Buy Fruits Sniper", function()
			for _, v49 in next, tbl14["Sniper Fruits"], nil do
				tbl18:FireRemote("PurchaseRawFruit", v49, false)
			end
		end)
	end)

	Fruits:AddLine()

	result2:Dropdown(Fruits, "Sniper Fruits (Mirage)", "Fruits from Mirage Sniper", true, tbl36, "Save", function(arg)
		tbl16:SetSave("Sniper Fruits (Mirage Island)", arg, true)
	end)

	result2:Toggle(Fruits, "Auto Buy Fruits Sniper (Mirage)", "Buy fruits from Mirage Sniper", "Save", function(arg)
		tbl16:SetSave("Auto Buy Fruits Sniper (Mirage Island)", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Buy Fruits Sniper (Mirage Island)", function()
			for _, v49 in next, tbl14["Sniper Fruits (Mirage Island)"], nil do
				tbl18:FireRemote("PurchaseRawFruit", v49, true)
			end
		end)
	end)

	Fruits:AddSeperator({ "Fruit Management" })

	result2:Toggle(Fruits, "Auto Random Fruit", "Buy random fruit from Cousin", "Save", function(arg)
		tbl16:SetSave("Auto Random Fruit", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Random Fruit", function()
			tbl18:FireRemote("Cousin", "Buy")
		end)
	end)

	result2:Toggle(Fruits, "Auto Store Fruit", "Store fruits in inventory", "Save", function(arg)
		tbl16:SetSave("Auto Store Fruit", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Store Fruit", function()
			local currentFruit, v49, v50 = tbl18:GetCurrentFruit()

			if v49 and v50 then
				tbl18:FireRemote("StoreFruit", v49, v50)
			end
		end)
	end)

	result2:Toggle(Fruits, "Auto Drop Fruit", "Drop fruits from inventory", "Save", function(arg)
		tbl16:SetSave("Auto Drop Fruit", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Drop Fruit", function()
			local currentFruit, v49, v50 = tbl18:GetCurrentFruit()

			if v49 and v50 then
				tbl18:FireRemote("Drop", v49, v50)
			end
		end)
	end)

	result2:Toggle(Fruits, "Auto Eat Fruit", "Eat fruits automatically", "Save", function(arg)
		tbl16:SetSave("Auto Eat Fruit", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Eat Fruit", function()
			local eatRemote = localPlayer.Character and localPlayer.Character:FindFirstChild("EatRemote", true)

			if eatRemote then
				eatRemote:InvokeServer()
			end
		end)
	end)

	result2:Toggle(Fruits, "Auto Find Fruit", "Find and collect fruits on ground", "Save", function(arg)
		tbl16:SetSave("Auto Find Fruit", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Find Fruit", function()
			local v49 = tbl18:FindGroundFruit()

			if v49 then
				tbl18:ExecuteTween(v49.CFrame)
			end
		end)
	end)

	Fruits:AddSeperator({ "Fruit Spawner" })

	result2:Dropdown(Fruits, "Spawner Fruits", "Fruits to collect from spawner", true, tbl10, "Save", function(arg)
		tbl16:SetSave("Choose Spawner Fruit", arg, true)
	end)

	result2:Toggle(Fruits, "Auto Get Spawner Fruit", "Collect fruits from spawner", "Save", function(arg)
		tbl16:SetSave("Auto Gets Fruit Spawner", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl5.Workspace.ChildAdded:Connect(function(child)
			local tbl37 = {}

			if tbl14["Auto Gets Fruit Spawner"] and not v9.Unloaded then
				if table.find(tbl14["Choose Spawner Fruit"], child.Name) and child:FindFirstChild("Handle") then
					for k, v49 in pairs(tbl14) do
						if k ~= "Auto Gets Fruit Spawner" and k ~= "Auto Random Fruit" and k ~= "Auto Store Fruit" and v49 == true then
							tbl37[k] = v49
							tbl14[k] = false
						end
					end

					tbl18:ExecuteTween(child.Handle.CFrame)

					while true do
						task.wait()
						if not (not tbl14["Auto Gets Fruit Spawner"] or not child:FindFirstChild("Handle") or tbl18:GetDistance(child.Handle.CFrame) <= 4 or v9.Unloaded) then
							continue
						end
						break
					end

					task.wait(2)

					for k, v49 in pairs(tbl37) do
						tbl14[k] = v49
					end
				end
			end
		end)
	end)

	local Shop = v16:AddSection("Shop")

	result2:Toggle(Shop, "Auto Buy Legendary Sword", "Buy all legendary swords", "Save", function(arg)
		tbl16:SetSave("Auto Buy Legendary Sword", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Buy Legendary Sword", function()
			tbl18:FireRemote("LegendarySwordDealer", "1")
			tbl18:FireRemote("LegendarySwordDealer", "2")
			tbl18:FireRemote("LegendarySwordDealer", "3")
		end)
	end)

	result2:Toggle(Shop, "Auto Buy True Triple Katana", "Buy True Triple Katana", "Save", function(arg)
		tbl16:SetSave("Auto Buy True Triple Katana", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Buy True Triple Katana", function()
			tbl18:FireRemote("MysteriousMan", "1")
			tbl18:FireRemote("MysteriousMan", "2")
		end)
	end)

	for _, v49 in ipairs(tbl11) do
		local v50 = v49[2]
		Shop:AddSeperator({ v49[1] })

		for _, v51 in ipairs(v50) do
			local v52 = v51[1]
			local v53 = v51[2]

			result2:Button(Shop, v52, "Purchase " .. v52, type(v53) == "table" and function()
				tbl6.CommF_:InvokeServer(unpack(v53))
			end or v53)
		end
	end

	local v49 = v13:AddSection("Automation Fishing")

	result2:Toggle(v49, "Auto Equip Rod", "Auto-equip fishing rod", "Save", function(arg)
		tbl16:SetSave("Auto Equip Rod", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Equip Rod", function()
			local tool = localPlayer.Character:FindFirstChildWhichIsA("Tool")

			if not tool or tool:GetAttribute("InventoryCategory") ~= "Rod" then
				for _, child in pairs(localPlayer.Backpack:GetChildren()) do
					if child:IsA("Tool") and child:GetAttribute("InventoryCategory") == "Rod" then
						localPlayer.Character.Humanoid:EquipTool(child)
						break
					end
				end
			end
		end)
	end)

	result2:Toggle(v49, "Auto Fishing", "Auto-fish in current location", "Save", function(arg)
		tbl16:SetSave("Auto Fishing", arg)
	end)

	tbl4.__spawn(function()
		local function fn18(arg)
			if not arg then
				return
			end
			local humanoid = (localPlayer.Character or localPlayer.CharacterAdded:Wait()):WaitForChild("Humanoid")

			if typeof(arg) == "Instance" and arg:IsA("Animation") then
				local v50 = humanoid:LoadAnimation(arg)
				v50:Play()
				return v50
			end
		end

		tbl18:CreateLoop("Auto Fishing", function()
			local character = localPlayer.Character
			local tool = character and character:FindFirstChildWhichIsA("Tool")
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			if not tool or tool:GetAttribute("InventoryCategory") ~= "Rod" then
				return
			end

			if tool:GetAttribute("SkillChargeAlpha") >= 1 then
				tbl6.Net:FindFirstChild("RF/JobToolAbilities"):InvokeServer("Z", true)
			end

			local attribute = tool:GetAttribute("State")
			local position = humanoidRootPart.Position
			local v50 = require(tbl5.ReplicatedStorage.Util.GetWaterHeightAtLocation)(position)
			local tbl37 = { character, tbl5.Workspace.Characters, tbl5.Workspace.Enemies }
			local v51, v52 = tbl5.Workspace:FindPartOnRayWithIgnoreList(Ray.new(character.Head.Position, humanoidRootPart.CFrame.LookVector * require(tbl5.ReplicatedStorage.FishReplicated.FishingClient.Config).Rod.MaxLaunchDistance * 0.99751243781094523), tbl37)
			local tbl38 = { character, tbl5.Workspace.Characters, tbl5.Workspace.Enemies }
			local v53, v54 = tbl5.Workspace:FindPartOnRayWithIgnoreList(Ray.new(v52 + Vector3.new(0, 3, 0), Vector3.new(0, -500, 0)), tbl38)
			local vector2 = v54 and v54.Y < v50 and Vector3.new(v52.X, math.max(v54.Y, v50), v52.Z) or nil

			if attribute == "ReeledIn" then
				pcall(function()
					fn18(tbl5.ReplicatedStorage.Util.Anims.Storage["2"].Fishing.Fishing_Cast)
				end)

				tbl5.ReplicatedStorage.FishReplicated.FishingRequest:InvokeServer("StartCasting")
				task.wait(0.7)

				if vector2 then
					tbl5.ReplicatedStorage.FishReplicated.FishingRequest:InvokeServer("CastLineAtLocation", vector2, 100, true)
				end
			elseif attribute == "Biting" then
				pcall(function()
					fn18(tbl5.ReplicatedStorage.Util.Anims.Storage["2"].Fishing.Fishing_PullFishOut)
				end)

				tbl5.ReplicatedStorage.FishReplicated.FishingRequest:InvokeServer("Catching", true)
				task.wait(0.25)
				tbl5.ReplicatedStorage.FishReplicated.FishingRequest:InvokeServer("Catch", 1)
			else
				pcall(function()
					fn18(tbl5.ReplicatedStorage.Util.Anims.Storage["2"].Fishing.Fishing_Idle)
				end)
			end
		end)
	end)

	result2:Toggle(v49, "Auto Sell Fish", "Sell caught fish", "Save", function(arg)
		tbl16:SetSave("Auto Sell Fish", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Sell Fish", function()
			tbl6.Net:FindFirstChild("RF/JobsRemoteFunction"):InvokeServer("FishingNPC", "SellFish")
			task.wait(0.5)
		end)
	end)

	result2:Toggle(v49, "Auto Sell Corrupted Fish", "Sell corrupted fish", "Save", function(arg)
		tbl16:SetSave("Auto Sell Corrupted Fish", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Sell Corrupted Fish", function()
			tbl6.Net:FindFirstChild("RF/JobsRemoteFunction"):InvokeServer("FishingNPC", "SellCorruptedFish")
			task.wait(0.5)
		end)
	end)

	local v50 = v14:AddSection("Mirage Island")
	local v51 = v50:AddParagraph({ Title = "Island Status", Content = "Checking..." })

	tbl4.__spawn(function()
		while task.wait(2) do
			v51:Set({
				Title = "Island Status",
				Content = tbl6.WorldOrigin.Locations:FindFirstChild("Mirage Island") and "Mirage Island is Spawned!" or "Mirage Island is not Spawned",
			})
		end
	end)

	result2:Toggle(v50, "Auto Summon Mirage Island", "Sail to summon Mirage Island", "Save", function(arg)
		tbl16:SetSave("Auto Summon Mirage Island", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Summon Mirage Island", function()
			if not tbl6.WorldOrigin.Locations:FindFirstChild("Mirage Island") then
				local playerBoat = tbl18:GetPlayerBoat()

				if not playerBoat then
					if localPlayer:DistanceFromCharacter(tbl9.BoatShopPos[2]) < 10 and localPlayer.Character and localPlayer.Character.Humanoid.Health > 0 then
						tbl18:FireRemote("BuyBoat", "PirateBrigade")
					else
						tbl18:ExecuteTween(tbl9.BoatShop[2])
					end
				elseif playerBoat then
					local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

					if not humanoid or not humanoid.Sit then
						local vehicleSeat = playerBoat:FindFirstChild("VehicleSeat")

						if vehicleSeat then
							tbl18:ExecuteTween(vehicleSeat.CFrame)
						end
					else
						tbl18:ExecuteBoatTween(playerBoat, playerBoat.PrimaryPart.CFrame * CFrame.new(0, 5, -500000))
					end
				end
			else
				local mirageIsland = tbl6.WorldOrigin.Locations:FindFirstChild("Mirage Island")

				if mirageIsland and mirageIsland.PrimaryPart then
					tbl18:ExecuteTween(mirageIsland.PrimaryPart.CFrame * CFrame.new(0, 500, 0))
				end
			end
		end)
	end)

	result2:Toggle(v50, "Tween To Mirage Island", "Teleport to Mirage Island", "Save", function(arg)
		tbl16:SetSave("Tween To Mirage Island", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Tween To Mirage Island", function()
			local mirageIsland = tbl6.WorldOrigin.Locations:FindFirstChild("Mirage Island")

			if mirageIsland and mirageIsland.PrimaryPart then
				tbl18:ExecuteTween(mirageIsland.PrimaryPart.CFrame * CFrame.new(0, 500, 0))
			end
		end)
	end)

	local v52 = v13:AddSection("Upgrade Race")

	result2:Toggle(v52, "Auto V2", "Upgrade race to V2", "Save", function(arg)
		tbl16:SetSave("Auto V2", arg)
	end)

	result2:Toggle(v52, "Auto V3", "Upgrade race to V3", "Save", function(arg)
		tbl16:SetSave("Auto V3", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto V2", function()
			if string.find(tbl18:GetRaceInfo(), "V1") then
				if not localPlayer.Data.Race:FindFirstChild("Evolved") then
					local response3 = tbl5.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")

					if response3 == 0 then
						local cframe = CFrame.new(-2779.83521, 72.9661407, -3574.02002)
						tbl18:ExecuteTween(cframe)

						if localPlayer:DistanceFromCharacter(cframe.Position) <= 4 then
							task.wait(1.3)
							tbl5.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "2")
						end
					elseif response3 == 1 then
						pcall(function()
							local flag = false

							for _, v53 in ipairs({ "Flower 1", "Flower 2", "Flower 3" }) do
								if not localPlayer.Backpack:FindFirstChild(v53) and not localPlayer.Character:FindFirstChild(v53) then
									local v54 = tbl5.Workspace:FindFirstChild(v53)

									if v54 then
										tbl18:ExecuteTween(v54.CFrame)
										flag = true
										break
									end
								end
							end

							if not flag then
								local zombie = tbl6.Enemies:FindFirstChild("Zombie")

								if zombie then
									tbl18:EngageEnemy({ zombie.Name })
								else
									tbl18:ExecuteTween(CFrame.new(-5685.9233398438, 48.480125427246, -853.23724365234))
								end
							end
						end)
					elseif response3 == 2 then
						tbl5.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "3")
					end
				end
			else
				v9:SetNotification({ "Speed Hub X", "Auto V2", "Your race is already V2 or higher", 5, 0.5 })
			end
		end)

		tbl18:CreateLoop("Auto V3", function()
			local raceInfo = tbl18:GetRaceInfo()
			local response3 = tbl5.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")

			if response3 == 0 then
				tbl5.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
			elseif response3 == 2 then
				tbl5.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
			elseif response3 == 1 then
				if raceInfo == "Human V2" then
					tbl18:ProcessHumanV3()
				elseif raceInfo == "Mink V2" then
					tbl18:HandleMinkV2()
				elseif raceInfo == "Skypiea V2" then
					tbl18:HandleSkypieaV3()
				elseif raceInfo == "Cyborg V2" then
					if not tbl18:GetEquippedFruit() and tbl18:GetFruitInventory() then
						tbl5.ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", tbl18:GetFruitInventory())
					end
				elseif raceInfo == "Fishman V2" then
					tbl18:HandleFishmanV2()
				end
			elseif response3 == -1 then
				v9:SetNotification({ "Speed Hub X", "Auto V3", "You need more than 2M Beli", 5, 0.5 })
			end
		end)
	end)

	v52:AddParagraph({ Title = "V4 Race", Content = "Upgrade to V4" })

	result2:Button(v52, "Teleport To Temple", "Teleport to Temple of Time", function()
		tbl18:TeleportToTemple()
	end)

	result2:Button(v52, "Teleport To Ancient One", "Teleport to Ancient One", function()
		tbl18:TeleportToTemple()
		tbl18:ExecuteTween(CFrame.new(28981, 14888, -120))
	end)

	result2:Button(v52, "Teleport To Ancient Clock", "Teleport to Ancient Clock", function()
		tbl18:TeleportToTemple()
		tbl18:ExecuteTween(CFrame.new(29549, 15069, -88))
	end)

	result2:Button(v52, "Teleport To Race Door", "Teleport to your race's door", function()
		local tbl37 = {
			Mink = CFrame.new(29020.66015625, 14889.426757812, -379.2682800293),
			Fishman = CFrame.new(28224.056640625, 14889.426757812, -210.58720397949),
			Cyborg = CFrame.new(28492.4140625, 14894.426757812, -422.11001586914),
			Skypiea = CFrame.new(28967.408203125, 14918.075195312, 234.31198120117),
			Ghoul = CFrame.new(28672.720703125, 14889.127929688, 454.59616088867),
			Human = CFrame.new(29237.294921875, 14889.426757812, -206.94955444336),
		}

		tbl18:TeleportToTemple()
		local v53 = tbl37[localPlayer.Data.Race.Value]

		if v53 then
			tbl18:ExecuteTween(v53)
		end
	end)

	result2:Button(v52, "Pull Lever", "Pull the lever in Temple of Time", function()
		for _, descendant in pairs(tbl5.Workspace.Map["Temple of Time"]:GetDescendants()) do
			if descendant.Name == "ProximityPrompt" then
				fireproximityprompt(descendant, math.huge)
			end
		end
	end)

	result2:Toggle(v52, "Auto Trial", "Complete race trial automatically", "Save", function(arg)
		tbl16:SetSave("Auto Trial", arg)
	end)

	local function fn18()
		if not tbl5.Workspace.Map:FindFirstChild("FishmanTrial") then
			return
		end
		local trialOfWater = tbl6.WorldOrigin.Locations:FindFirstChild("Trial of Water")
		if not trialOfWater then
			return
		end

		for _, child in pairs(tbl5.Workspace.SeaBeasts:GetChildren()) do
			local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")
			local health = child:FindFirstChild("Health")
			if humanoidRootPart and health and health.Value > 0 and (humanoidRootPart.Position - trialOfWater.Position).Magnitude <= 1500 then
				return child
			end
		end
	end

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Trial", function()
			pcall(function()
				if not tbl14["Auto Trial"] then
					return
				end
				local str3 = tostring(localPlayer.Data.Race.Value)
				local character = localPlayer.Character
				character = character and character:FindFirstChild("HumanoidRootPart")

				if str3 == "Mink" and character then
					character.CFrame = tbl5.Workspace.Map.MinkTrial.Ceiling.CFrame * CFrame.new(0, -20, 0)
				elseif str3 == "Fishman" then
					local v53 = fn18()
					if not v53 then
						return
					end

					while true do
						task.wait()
						local humanoidRootPart = v53:FindFirstChild("HumanoidRootPart")

						if not humanoidRootPart then
							break
						else
							tbl18:ExecuteTween(CFrame.new(humanoidRootPart.Position.X, tbl5.Workspace.Map["WaterBase-Plane"].Position.Y + 300, humanoidRootPart.Position.Z))
							SetAim(humanoidRootPart.CFrame)
							tbl18:EquipToolByTip(tbl14["Choose Equip "] == "Random" and ({ "Melee", "Blox Fruit", "Sword", "Gun" })[math.random(1, 4)] or tbl14["Choose Equip "])

							for _, v54 in next, tbl14["Skill  "], nil do
								if tbl18:IsSkillAvailable(v54) then
									tbl18:SendKeyPress(v54)
								end
							end

							if not (not tbl14["Auto Trial"] or not v53.Parent or v53.Health.Value <= 0) then
								continue
							end
							break
						end
					end
				elseif str3 == "Cyborg" then
					tbl18:ExecuteTween(tbl5.Workspace.Map.CyborgTrial.Floor.CFrame * CFrame.new(0, 500, 0))
				elseif str3 == "Skypiea" and character then
					character.CFrame = tbl5.Workspace.Map.SkyTrial.Model.FinishPart.CFrame
				elseif str3 == "Human" or str3 == "Ghoul" then
					local v53 = tbl18:FindEnemy({ "Ancient Vampire", "Ancient Zombie" })

					if v53 then
						while true do
							task.wait()
							tbl18:EngageEnemy({ v53.Name })
							if not (not tbl14["Auto Trial"] or not v53.Parent or v53.Humanoid.Health <= 0) then
								continue
							end
							break
						end
					end
				end
			end)
		end)
	end)

	result2:Toggle(v52, "Auto Kill Players After Trial", "Kill players after trial", "Save", function(arg)
		tbl16:SetSave("Auto Kill Player After Trial", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Kill Player After Trial", function()
			pcall(function()
				if not tbl14["Auto Kill Player After Trial"] then
					return
				end
				local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					return
				end

				for _, child in pairs(tbl5.Workspace.Characters:GetChildren()) do
					if child.Name ~= localPlayer.Name then
						local humanoid = child:FindFirstChild("Humanoid")
						local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")

						if humanoid and humanoidRootPart2 and humanoid.Health > 0 then
							if (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude <= 250 and playerGui.Main.Timer.Visible then
								while true do
									task.wait()
									tbl18:ExecuteTween(humanoidRootPart2.CFrame * CFrame.new(0, 0, 15))
									SetAim(humanoidRootPart2.CFrame)
									tbl18:EquipToolByTip(tbl14["Choose Equip "] == "Random" and ({ "Melee", "Blox Fruit", "Sword", "Gun" })[math.random(1, 4)] or tbl14["Choose Equip "])

									for _, v53 in next, tbl14["Skill  "], nil do
										if tbl18:IsSkillAvailable(v53) then
											tbl18:SendKeyPress(v53)
										end
									end

									sethiddenproperty(localPlayer, "SimulationRadius", math.huge)
									if not (not tbl14["Auto Kill Player After Trial"] or humanoid.Health <= 0 or not child.Parent) then
										continue
									end
									break
								end
							end
						end
					end
				end
			end)
		end)
	end)

	local Raid = v13:AddSection("Raid")

	result2:Dropdown(Raid, "Select Raid", "Choose raid", false, tbl12, "Save", function(arg)
		tbl16:SetSave("Choose Chips", arg)
	end)

	result2:Toggle(Raid, "Auto Buy Chips", "Buy raid chips", "Save", function(arg)
		tbl16:SetSave("Auto Buy Chips", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Buy Chips", function()
			if not tbl18:HasTool("Special Microchip") then
				if tbl14["Choose Chips"] == "Rumble" then
					tbl18:FireRemote("ThunderGodTalk", true)
					tbl18:FireRemote("ThunderGodTalk")
				else
					tbl18:FireRemote("RaidsNpc", "Select", tbl14["Choose Chips"])
				end
			end
		end)
	end)

	result2:Toggle(Raid, "Auto Raid", "Complete raids automatically", "Save", function(arg)
		tbl16:SetSave("Auto Raid", arg)
		tbl18:StopTween(arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Raid", function()
			local flag

			if not playerGui.Main.TopHUDList.RaidTimer.Visible then
				flag = false

				if tbl8[2] then
					if not tbl6.WorldOrigin:FindFirstChild("Island 1") then
						if tbl18:HasTool("Special Microchip") then
							local main = tbl5.Workspace.Map.CircleIsland.RaidSummon2.Button:FindFirstChild("Main")

							if main then
								fireclickdetector(main.ClickDetector)
							else
								tbl18:ExecuteTween(tbl5.Workspace.Map.CircleIsland.RaidSummon2:GetPivot())
							end
						end

						while true do
							task.wait()
							if not (tbl6.WorldOrigin:FindFirstChild("Island 1") or not tbl14["Auto Raid"] or v9.Unloaded) then
								continue
							end
							break
						end
					end
				elseif tbl8[3] then
					if not tbl6.WorldOrigin:FindFirstChild("Island 1") then
						if tbl18:HasTool("Special Microchip") then
							local main = tbl5.Workspace.Map["Boat Castle"].RaidSummon2.Button:FindFirstChild("Main")

							if main then
								fireclickdetector(main.ClickDetector)
							else
								tbl18:ExecuteTween(tbl5.Workspace.Map["Boat Castle"].RaidSummon2:GetPivot())
							end
						end

						while true do
							task.wait()
							if not (tbl6.WorldOrigin:FindFirstChild("Island 1") or not tbl14["Auto Raid"] or v9.Unloaded) then
								continue
							end
							break
						end
					end
				end
			else
				flag = true

				tbl6.WorldOrigin.Locations.ChildAdded:Connect(function(child)
					if not child:IsA("Part") then
						return
					end

					if not child.Name:match("^Island %d+$") then
						return
					end
					local v53 = tbl6.WorldOrigin.Locations:FindFirstChild(child.Name)

					if v53 then
						tbl18:ExecuteTween(v53.CFrame * CFrame.new(4, 40, 10))
					end
				end)
			end

			local n6 = 3000

			tbl4.__spawn(function()
				while flag do
					for _, child in pairs(tbl6.Enemies:GetChildren()) do
						if child and child.PrimaryPart then
							local magnitude = (child.PrimaryPart.Position - localPlayer.Character.PrimaryPart.Position).Magnitude

							if magnitude < n6 then
								n6 = magnitude
								tbl18:EngageEnemy({ child.Name })
							end
						end
					end

					task.wait()
				end
			end)

			pcall(function()
				tbl18:FireRemote("Awakener", "Check")
				tbl18:FireRemote("Awakener", "Awaken")
			end)
		end)
	end)

	local esp = v17:AddSection("ESP")

	result2:Toggle(esp, "ESP Player", "Show player locations", "Save", function(arg)
		tbl16:SetSave("ESP Player", arg)

		tbl4.__spawn(function()
			while tbl14["ESP Player"] do
				task.wait(1)

				for _, player in pairs(tbl5.Players:GetPlayers()) do
					if player.Name ~= localPlayer.Name and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						tbl18:CreateESP(player.Character.HumanoidRootPart, Color3.fromRGB(0, 230, 0))
					end
				end
			end

			for _, player in pairs(tbl5.Players:GetPlayers()) do
				if player.Name ~= localPlayer.Name and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					tbl18:RemoveESP(player.Character.HumanoidRootPart)
				end
			end
		end)
	end)

	result2:Toggle(esp, "ESP Chest", "Show chest locations", "Save", function(arg)
		tbl16:SetSave("ESP Chest", arg)

		tbl4.__spawn(function()
			while tbl14["ESP Chest"] do
				task.wait(1)

				for _, v53 in ipairs(tbl5.CollectionService:GetTagged("_ChestTagged")) do
					if not v53:GetAttribute("IsDisabled") then
						tbl18:CreateESP(v53, Color3.fromRGB(237, 233, 9))
					end
				end
			end

			for _, v53 in ipairs(tbl5.CollectionService:GetTagged("_ChestTagged")) do
				if not v53:GetAttribute("IsDisabled") then
					tbl18:RemoveESP(v53)
				end
			end
		end)
	end)

	result2:Toggle(esp, "ESP Berry", "Show berry locations", "Save", function(arg)
		tbl16:SetSave("ESP Berry", arg)

		tbl4.__spawn(function()
			while tbl14["ESP Berry"] do
				task.wait(1)

				for _, descendant in ipairs(tbl5.Workspace.Map:GetDescendants()) do
					if descendant.Name == "Berries" then
						for i = 1, 8 do
							if descendant:GetAttribute("_BerryCFrame" .. i) then
								tbl18:CreateESP(descendant.Parent, Color3.fromRGB(237, 233, 9))
							end
						end
					end
				end
			end

			for _, descendant in ipairs(tbl5.Workspace.Map:GetDescendants()) do
				if descendant.Name == "Berries" then
					for i = 1, 8 do
						if descendant:GetAttribute("_BerryCFrame" .. i) then
							tbl18:RemoveESP(descendant.Parent)
						end
					end
				end
			end
		end)
	end)

	result2:Toggle(esp, "ESP Flower", "Show flower locations", "Save", function(arg)
		tbl16:SetSave("ESP Flower", arg)

		tbl4.__spawn(function()
			while tbl14["ESP Flower"] do
				task.wait(1)

				for _, child in pairs(tbl5.Workspace:GetChildren()) do
					if child and child:IsA("BasePart") and string.find(child.Name, "Flower") then
						tbl18:CreateESP(child, child.Color)
					end
				end
			end

			for _, child in pairs(tbl5.Workspace:GetChildren()) do
				if child and child:IsA("BasePart") and string.find(child.Name, "Flower") then
					tbl18:RemoveESP(child)
				end
			end
		end)
	end)

	result2:Toggle(esp, "ESP Devil Fruit", "Show fruit locations", "Save", function(arg)
		tbl16:SetSave("ESP Devil Fruit", arg)

		tbl4.__spawn(function()
			while tbl14["ESP Devil Fruit"] do
				task.wait(1)

				for _, child in pairs(tbl5.Workspace:GetChildren()) do
					if child and child:IsA("Tool") and child:FindFirstChild("Handle") or child and string.find(child.Name, "Fruit") and child:FindFirstChild("Handle") then
						tbl18:CreateESP(child.Handle, Color3.fromRGB(247, 47, 7))
					end
				end
			end

			for _, child in pairs(tbl5.Workspace:GetChildren()) do
				if child and child:IsA("Tool") and child:FindFirstChild("Handle") or child and string.find(child.Name, "Fruit") and child:FindFirstChild("Handle") then
					tbl18:RemoveESP(child.Handle)
				end
			end
		end)
	end)

	result2:Toggle(esp, "ESP Island", "Show island locations", "Save", function(arg)
		tbl16:SetSave("ESP Island", arg)

		tbl4.__spawn(function()
			while tbl14["ESP Island"] do
				task.wait(1)
				local v53 = pairs
				local locations = tbl6.WorldOrigin:WaitForChild("Locations", 9e9)

				for _, child in v53(locations:GetChildren()) do
					if child then
						tbl18:CreateESP(child, Color3.fromRGB(0, 255, 255))
					end
				end
			end

			local v53 = pairs
			local locations = tbl6.WorldOrigin:WaitForChild("Locations", 9e9)

			for _, child in v53(locations:GetChildren()) do
				if child then
					tbl18:RemoveESP(child)
				end
			end
		end)
	end)

	result2:Toggle(esp, "ESP Mirage Island", "Show Mirage Island location", "Save", function(arg)
		tbl16:SetSave("ESP Mirage Island", arg)

		tbl4.__spawn(function()
			while tbl14["ESP Mirage Island"] do
				task.wait(1)

				for _, child in pairs(tbl6.WorldOrigin.Locations:GetChildren()) do
					if child and child.Name == "Mirage Island" then
						tbl18:CreateESP(child, child.Color)
					end
				end
			end

			for _, child in pairs(tbl6.WorldOrigin.Locations:GetChildren()) do
				if child and child.Name == "Mirage Island" then
					tbl18:RemoveESP(child)
				end
			end
		end)
	end)

	result2:Toggle(esp, "ESP Kitsune Island", "Show Kitsune Island location", "Save", function(arg)
		tbl16:SetSave("ESP Kitsune Island", arg)

		tbl4.__spawn(function()
			while tbl14["ESP Kitsune Island"] do
				task.wait(1)

				for _, child in pairs(tbl6.WorldOrigin.Locations:GetChildren()) do
					if child and child.Name == "Kitsune Island" then
						tbl18:CreateESP(child, child.Color)
					end
				end
			end

			for _, child in pairs(tbl6.WorldOrigin.Locations:GetChildren()) do
				if child and child.Name == "Kitsune Island" then
					tbl18:RemoveESP(child)
				end
			end
		end)
	end)

	result2:Toggle(v17:AddSection("Anti-Cheat Bypass"), "Anti-Flag", "Auto-rejoin every 30 minutes", false, function(arg)
		tbl16:SetSave("Anti-Flag", arg)

		tbl4.__spawn(function()
			while tbl14["Anti-Flag"] do
				task.wait(1800)
				tbl5.TeleportService:Teleport(game.PlaceId, localPlayer)
			end
		end)
	end)

	local Team = v17:AddSection("Team")

	result2:Button(Team, "Join Pirates", "Join Pirates team", function()
		tbl6.CommF_:InvokeServer("SetTeam", "Pirates")
	end)

	result2:Button(Team, "Join Marines", "Join Marines team", function()
		tbl6.CommF_:InvokeServer("SetTeam", "Marines")
	end)

	local v53 = v17:AddSection("Menu UI")

	result2:Button(v53, "Fruit Shop", "Open fruit shop", function()
		require(tbl5.ReplicatedStorage.Controllers.UI.FruitShop):Open()
	end)

	result2:Button(v53, "Titles", "Open titles menu", function()
		tbl6.CommF_:InvokeServer("getTitles")
		playerGui.Main.Titles.Visible = true
	end)

	result2:Button(v53, "Haki Color", "Open haki color menu", function()
		playerGui.Main.Colors.Visible = true
	end)

	result2:Button(v17:AddSection("Redeem"), "Redeem All Codes", "Redeem all available codes", function()
		for _, v54 in loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Main/main/Codes_BloxFruit"))(), nil, nil do
			tbl5.ReplicatedStorage.Remotes.Redeem:InvokeServer(v54)
		end
	end)

	result2:Toggle(v17:AddSection("Water"), "Walk On Water", "Enable walking on water", true, function(arg)
		tbl16:SetSave("Walk On Water", arg)

		tbl4.__spawn(function()
			local connection = nil

			connection = tbl5.RunService.Heartbeat:Connect(function()
				if v9.Unloaded then
					connection:Disconnect()
					return
				end
				local waterBasePlane = tbl5.Workspace.Map:WaitForChild("WaterBase-Plane")

				if waterBasePlane then
					waterBasePlane.Size = tbl14["Walk On Water"] and Vector3.new(1000, 113, 1000) or Vector3.new(1000, 80, 1000)
				end
			end)
		end)
	end)

	local v54 = v17:AddSection("Remove Effects")

	result2:Toggle(v54, "Remove Damage Numbers", "Hide damage numbers", "Save", function(arg)
		tbl16:SetSave("Remove Damage", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Remove Damage", function()
			while true do
				task.wait()
				tbl5.ReplicatedStorage.Assets.GUI.DamageCounter.Enabled = false
				if not (not tbl14["Remove Damage"] or v9.Unloaded) then
					continue
				end
				break
			end

			tbl5.ReplicatedStorage.Assets.GUI.DamageCounter.Enabled = true
		end)
	end)

	result2:Toggle(v54, "Remove Notifications", "Hide notifications", "Save", function(arg)
		tbl16:SetSave("Remove Notifications", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Remove Notifications", function()
			while true do
				task.wait()
				localPlayer.PlayerGui.Notifications.Enabled = false
				if not (not tbl14["Remove Notifications"] or v9.Unloaded) then
					continue
				end
				break
			end

			localPlayer.PlayerGui.Notifications.Enabled = true
		end)
	end)

	local Automations = v17:AddSection("Automations")

	result2:Toggle(Automations, "Auto Haki", "Auto-activate Haki", true, function(arg)
		tbl16:SetSave("Auto Haki", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Haki", function()
			tbl18:ActivateHaki()
		end)
	end)

	result2:Toggle(Automations, "Auto Ken", "Auto-activate Ken", "Save", function(arg)
		tbl16:SetSave("Auto Ken", arg)
	end)

	tbl4.__spawn(function()
		tbl18:CreateLoop("Auto Ken", function()
			tbl18:FireRemote("Ken", true)
		end)
	end)

	result2:Button(v18:AddSection("Reset Config"), "Reset Script Config", "Delete all saved configuration", function()
		for _, v55 in next, { "Speed_Hub", "SpeedHubX", "Speed Hub X", "Speed Hub", "Speed_Hub_X" }, nil do
			if isfolder(v55) then
				delfolder(v55)
			end
		end
	end)

	local v55 = v9
	local setNotification = v55.SetNotification
	local tbl37 = {}
	local str3 = "Loaded in: " .. tostring(tick() - now) .. "s"
	tbl37[1] = "Speed Hub X"
	tbl37[2] = ""
	tbl37[3] = str3
	tbl37[4] = 5
	tbl37[5] = 0.5
	setNotification(v55, tbl37)
end
task.spawn(fn2)