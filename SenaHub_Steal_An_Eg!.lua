local function geniter(f, s, c)
	if type(f) ~= "function" then
		local mt = getmetatable(f)

		if type(mt) == "table" and mt.__iter then
			f, s, c = mt.__iter(f)
		elseif type(f) == "table" then
			f, s, c = next, f, nil
		end
	end

	return function()
		local r = table.pack(f(s, c))

		if r[1] == nil then
			return false
		end

		c = r[1]

		return true, table.unpack(r, 1, r.n)
	end
end

local CFrame_ = CFrame
local cFrameNew = CFrame_ and CFrame_.new
local lookAt = CFrame_ and CFrame_.lookAt
local Angles = CFrame_ and CFrame_.Angles
local fromMatrix = CFrame_ and CFrame_.fromMatrix
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

game:GetService("TweenService")

local TeleportService = game:GetService("TeleportService")
local v14, genv, v16, __SenaV4TweenRuntimeGeneration, t1, v19, v20, v21, v22, v23
local v24, v25, v26, v27, v28, v29, v30, v31, v32, v33

do
	local Workspace = game:GetService("Workspace")

	v14 = function()
		return Workspace:FindFirstChild("World") or Workspace:FindFirstChild("__OBJECTS")
	end
	genv = getgenv and getgenv() or _G

	if type(genv.__SenaV4HubShutdown) == "function" then
		pcall(genv.__SenaV4HubShutdown)
	end

	local t2 = {}

	genv.__SenaV4HubSession = t2
	v16 = function()
		return genv.__SenaV4HubSession == t2
	end
	genv.__SenaV4IdentityGetter = genv.getthreadidentity or genv.get_thread_identity or genv.getidentity or genv.getthreadcontext or genv.get_thread_context
	genv.__SenaV4IdentitySetter = genv.setthreadidentity or genv.set_thread_identity or genv.setidentity or genv.setthreadcontext or genv.set_thread_context

	local __SenaV4IdentitySetter = genv.__SenaV4IdentitySetter

	if type(__SenaV4IdentitySetter) == "function" then
		pcall(__SenaV4IdentitySetter, 8)
		genv.__SenaV4UICapabilityIdentity = 8
	end

	if not (rawget(_G, "setfpscap") or rawget(_G, "set_fps_cap")) and type(setfpscap) == "function" then
	end

	genv.__SenaV4SetCapFps = function(p1)
		local v37 = math.clamp(math.floor(tonumber(p1) or 240), 1, 999)
		local setfpscap_ = rawget(_G, "setfpscap") or rawget(_G, "set_fps_cap") or type(setfpscap) == "function" and setfpscap

		if type(setfpscap_) == "function" then
			return pcall(setfpscap_, v37)
		end

		return false
	end

	if type(genv.__SenaV4TweenRuntimeCleanup) == "function" then
		pcall(genv.__SenaV4TweenRuntimeCleanup)
	end

	if type(genv.__SenaV4EggRuntimeCleanup) == "function" then
		pcall(genv.__SenaV4EggRuntimeCleanup)
	end

	if type(genv.__SenaV4AntiGuardCleanup) == "function" then
		pcall(genv.__SenaV4AntiGuardCleanup)
	end

	genv.__SenaV4TweenRuntimeGeneration = (genv.__SenaV4TweenRuntimeGeneration or 0) + 1
	__SenaV4TweenRuntimeGeneration = genv.__SenaV4TweenRuntimeGeneration
	t1 = {
		KEY = "__SenaV4StealAnEggMovementSpoof",
		VERSION = 436,
		INTEGRITY_KEY = "__SenaV4StealAnEggIntegritySpoof",
		SIGNAL = "ClientCharacter: GetDebugSnapshot",
		HEADROOM = 1.35,
		CLAMP = 0.15,
		PADDING = 24,
		MULTIPLIER = 10,
		MIN_INPUT = 20,
		MAX_INPUT = 100,
		DEF_INPUT = 60,
		MIN_SPEED = 200,
		MAX_SPEED = 1000,
		DEF_SPEED = 600,
		FIELDS = {
			"LastObservedSample",
			"LastSample",
			"LastGoodSample",
			"LastGameplayTrustedSample",
			"LastValidatedSample",
			"LastValidatedGroundedSample",
			"LastConfirmedGroundSample",
			"CandidateGroundedSample"
		}
	}

	local KEY = t1.KEY
	local VERSION = t1.VERSION
	local INTEGRITY_KEY = t1.INTEGRITY_KEY
	local SIGNAL = t1.SIGNAL
	local HEADROOM = t1.HEADROOM
	local CLAMP = t1.CLAMP
	local PADDING = t1.PADDING
	local MIN_SPEED = t1.MIN_SPEED
	local MAX_SPEED = t1.MAX_SPEED
	local DEF_SPEED = t1.DEF_SPEED
	local FIELDS = t1.FIELDS
	local n1 = 60

	game:GetService("RunService").Heartbeat:Connect(function(dt)
		if dt and dt > 0 then
			n1 = n1 * 0.9 + 1 / dt * 0.1
		end
	end)
	v19 = function()
		return n1
	end

	local u51
	local v52 = tostring(math.random(100000, 999999))
	local connection
	local connection2
	local t3 = {}
	local u56

	v20 = nil

	local function v57()
		for _, child in ipairs(Workspace:GetChildren()) do
			if child:IsA("BasePart") and child.Name == "__SenaV4HoverPad" and child ~= u51 then
				pcall(child.Destroy, child)
			end
		end
	end

	v21 = function(p2)
		if not u51 or not u51.Parent then
			return false
		end

		local Character = LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or not Humanoid then
			return false
		end

		local v63 = typeof(p2) == "Vector3" and p2

		v63 = v63 or HumanoidRootPart.Position
		u51.CFrame = cFrameNew(v63.X, v63.Y - (Humanoid.RigType == Enum.HumanoidRigType.R15 and HumanoidRootPart.Size.Y * 0.5 + math.max(Humanoid.HipHeight, 0.5) or HumanoidRootPart.Size.Y * 0.5 + 2) - 0.5 - 0.05, v63.Z)

		return true
	end
	v22 = function()
		if not u51 or not u51.Parent or u51:GetAttribute("SenaV4RuntimeOwner") ~= v52 then
			v57()

			if u51 and u51.Parent then
				pcall(u51.Destroy, u51)
			end

			local Part = Instance.new("Part")

			Part.Name = "__SenaV4HoverPad"
			Part:SetAttribute("SenaV4RuntimeOwner", v52)
			Part.Anchored = true
			Part.CanCollide = true
			Part.CanQuery = true
			Part.CanTouch = false
			Part.CastShadow = false
			Part.Transparency = 1
			Part.Material = Enum.Material.SmoothPlastic
			Part.Size = Vector3.new(8, 1, 8)
			u51 = Part
			Part.Parent = Workspace
		end

		v21()

		if not connection then
			local function v65()
				if not v21() then
					v22()
				end
			end

			connection = RunService.PreSimulation:Connect(v65)
		end

		if not connection2 then
			connection2 = RunService.PostSimulation:Connect(function()
				v21()
			end)
		end
	end
	v23 = function()
		if connection then
			pcall(connection.Disconnect, connection)
			connection = nil
		end

		if connection2 then
			pcall(connection2.Disconnect, connection2)
			connection2 = nil
		end

		if u51 then
			pcall(u51.Destroy, u51)
			u51 = nil
		end

		v57()
	end
	v23()
	v24 = function()
		u56 = nil
	end
	v25 = function(p3, p4)
		if p3 and typeof(p4) == "CFrame" then
			u56 = {
				Character = LocalPlayer.Character,
				RootPart = p3,
				CFrame = p4
			}
		end
	end

	local function v66()
		local v67 = u56

		if type(v67) == "table" then
			if typeof(v67.CFrame) == "CFrame" then
				if LocalPlayer.Character == v67.Character then
					if v67.RootPart and v67.RootPart.Parent then
						v22()
						v67.RootPart.AssemblyLinearVelocity = Vector3.zero
						v67.RootPart.AssemblyAngularVelocity = Vector3.zero
						v21(v67.CFrame.Position)
						v67.RootPart.CFrame = v67.CFrame
						v21(v67.CFrame.Position)

						return true
					end
				end

				u56 = nil

				return false
			end
		end

		return false
	end
	local function v68()
		local Character = LocalPlayer.Character
		local HumanoidRootPart = Character

		HumanoidRootPart = HumanoidRootPart and Character:FindFirstChild("HumanoidRootPart")

		for _, v in pairs(t3) do
			if type(v) == "table" then
				v.cancelled = true
			end
		end

		table.clear(t3)

		if HumanoidRootPart then
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		end

		v24()
		v23()
	end

	genv.__SenaV4TweenRuntimeCleanup = function()
		for _, v in pairs(t3) do
			if type(v) == "table" then
				v.cancelled = true
			end
		end

		table.clear(t3)
		v24()
		v23()
	end
	v26 = function()
		return getgenv and getgenv() or _G
	end

	local function v75()
		local v76 = v26()
		local v77 = v76[KEY]

		if type(v77) ~= "table" or v77.Version ~= VERSION then
			if type(v77) == "table" then
				v77.Enabled = false
			end

			v77 = {
				Version = VERSION,
				Installed = false,
				Enabled = false,
				Mode = "StateBaseline",
				Humanoid = nil,
				RootPart = nil,
				WalkSpeed = DEF_SPEED
			}
			v76[KEY] = v77
		end

		return v77
	end

	v27 = function(p5, p6)
		local v78 = v75()

		if not v78 then
			return false
		end

		local Humanoid = p5 and p5:FindFirstChildOfClass("Humanoid")
		local HumanoidRootPart = p5 and p5:FindFirstChild("HumanoidRootPart")

		v78.Humanoid = Humanoid
		v78.RootPart = HumanoidRootPart
		v78.WalkSpeed = math.clamp(tonumber(p6) or DEF_SPEED, MIN_SPEED, MAX_SPEED * HEADROOM)
		v78.Enabled = false

		return Humanoid ~= nil and HumanoidRootPart ~= nil
	end

	local function v81()
		local v82 = v26()[KEY]

		if type(v82) == "table" then
			v82.Enabled = false
			v82.Humanoid = nil
			v82.RootPart = nil
		end
	end
	local function v83(p7, p8, p9)
		local u84

		if type(getcallbackvalue) == "function" and type(debug) == "table" and type(debug.getupvalue) == "function" then
			local Signal = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Signal")

			if Signal then
				local ok, result = pcall(require, Signal)

				if ok and type(result) == "table" and type(result.Invoked) == "function" then
					local ok2, result2 = pcall(result.Invoked, SIGNAL)

					if ok2 and result2 then
						local ok3, result3 = pcall(getcallbackvalue, result2, "OnInvoke")

						if ok3 and type(result3) == "function" then
							local ok4, result4 = pcall(debug.getinfo, result3)

							if ok4 then
								local function v94(p10, p11, p12)
									if u84 or type(p10) ~= "table" or p11 > 3 or p12[p10] then
										return
									end

									p12[p10] = true

									if rawget(p10, "Player") == p7 and rawget(p10, "Character") == p7.Character then
										if rawget(p10, "Humanoid") == p8 and rawget(p10, "RootPart") == p9 and type(rawget(p10, "SampleHistory")) == "table" and type(rawget(p10, "Evidence")) == "table" then
											u84 = p10

											return
										end
									end

									local n2 = 0

									for _, v in pairs(p10) do
										n2 += 1

										if n2 > 128 then
											break
										end

										if type(v) == "table" then
											v94(v, p11 + 1, p12)
										end
									end
								end

								local n3 = 1
								local nups = result4.nups or 0

								for i = n3, nups do
									local ok5, result5 = pcall(debug.getupvalue, result3, i)

									if not ok5 or type(result5) ~= "table" then
										continue
									end

									v94(result5, 0, {})

									if u84 then
										break
									end
								end
							end
						end
					end
				end
			end
		end

		if not u84 and type(getgc) == "function" then
			local ok, result = pcall(getgc, true)

			if ok and type(result) == "table" then
				for _, v in ipairs(result) do
					if type(v) == "table" and rawget(v, "Player") == p7 and rawget(v, "Character") == p7.Character and rawget(v, "Humanoid") == p8 and rawget(v, "RootPart") == p9 and type(rawget(v, "SampleHistory")) == "table" and type(rawget(v, "Evidence")) == "table" then
						u84 = v

						break
					end
				end
			end
		end

		return u84
	end

	local t4 = {
		busy = false,
		nextAt = 0,
		misses = 0,
		found = nil
	}

	local function v108(p13, p14, p15)
		local found = t4.found

		if type(found) == "table" and rawget(found, "Player") == p13 then
			if rawget(found, "Character") == p13.Character and rawget(found, "Humanoid") == p14 and rawget(found, "RootPart") == p15 then
				return found
			end
		end

		if t4.busy or os.clock() < t4.nextAt then
			return nil
		end

		t4.busy = true
		task.spawn(function()
			task.wait()

			local ok, result = pcall(v83, p13, p14, p15)
			local v112 = ok and result or nil

			t4.found = v112
			t4.misses = v112 and 0 or t4.misses + 1
			t4.nextAt = os.clock() + (v112 and 0.2 or t4.misses >= 5 and 10 or 1)
			t4.busy = false
		end)

		return nil
	end

	v28 = function(p16, p17, p18)
		if type(p16) ~= "table" then
			return false
		end

		local value = rawget(p16, "RootPart")
		local CFrame_2 = value and value.Parent and value.CFrame or nil
		local Position = CFrame_2 and CFrame_2.Position or nil
		local vector3 = typeof(p18) == "Vector3" and p18 or Vector3.zero

		local function v117(p19)
			if type(p19) == "table" then
				rawset(p19, "WalkSpeed", p17)

				if CFrame_2 then
					rawset(p19, "CFrame", CFrame_2)
					rawset(p19, "Position", Position)
					rawset(p19, "LinearVelocity", vector3)
					rawset(p19, "AngularVelocity", Vector3.zero)
				end
			end
		end

		for _, v in ipairs(FIELDS) do
			v117(rawget(p16, v))
		end

		local pairs_ = pairs
		local v121 = rawget(p16, "SampleHistory") or {}

		for _, v in pairs_(v121) do
			v117(v)
		end

		local pairs_2 = pairs
		local v125 = rawget(p16, "SafeGroundCheckpoints") or {}

		for _, v in pairs_2(v125) do
			v117(v)
		end

		local value2 = rawget(p16, "Evidence")

		if type(value2) == "table" then
			value2.Speed = 0
			value2.Teleport = 0
			value2.Flight = 0
		end

		local value3 = rawget(p16, "ImpulseContext")

		if type(value3) == "table" then
			local maxHorizontalSpeed = math.max(tonumber(value3.MaxHorizontalSpeed) or 0, p17)
			local v131 = math.max((tonumber(value3.ExpiresAt) or 0) - (tonumber(value3.StartedAt) or 0), CLAMP)

			value3.MaxHorizontalSpeed = maxHorizontalSpeed

			if Position then
				value3.OriginPosition = Position
			end

			value3.MaxHorizontalDistance = math.max(tonumber(value3.MaxHorizontalDistance) or 0, maxHorizontalSpeed * v131 + PADDING * 2)
			v117(value3.PreMovementSafeSample)
		end

		if rawget(p16, "CorrectionContext") == nil then
			rawset(p16, "FirstSuspiciousAt", nil)

			if rawget(p16, "ThreatLevel") == "Observing" then
				rawset(p16, "ThreatLevel", "Trusted")
			end
		end

		return true
	end

	local function v132()
		local v133 = v26()
		local v134 = v133[INTEGRITY_KEY]

		if type(v134) ~= "table" then
			v134 = {}
			v133[INTEGRITY_KEY] = v134
		end

		return v134
	end

	v29 = function(p20, p21, p22)
		return type(p20) == "table" and rawget(p20, "Player") == LocalPlayer and rawget(p20, "Character") == LocalPlayer.Character and rawget(p20, "Humanoid") == p21 and rawget(p20, "RootPart") == p22
	end
	v30 = function(p23, p24, p25)
		return v29(p23, p24, p25)
	end
	v31 = function(p26, p27, p28)
		local v135 = v132()
		local State = v135.State

		if not v29(State, p26, p27) then
			local now = os.clock()

			if now < (v135.NextSearchAt or 0) then
				return false
			end

			v135.NextSearchAt = now + 0.2
			State = v108(LocalPlayer, p26, p27)
		end

		if not State then
			return false
		end

		if not v30(State, p26, p27) then
			v135.Enabled = false
			v135.Humanoid = p26
			v135.RootPart = p27
			v135.State = State

			return false
		end

		v135.NextSearchAt = 0
		v135.Enabled = true
		v135.Humanoid = p26
		v135.RootPart = p27
		v135.State = State
		v135.WalkSpeed = math.clamp(p28 * HEADROOM, MIN_SPEED, MAX_SPEED * HEADROOM)
		v135.TravelVelocity = Vector3.zero
		v28(State, v135.WalkSpeed, v135.TravelVelocity)

		return true
	end
	v32 = function(p29, p30, p31, p32)
		local v138 = v26()[INTEGRITY_KEY]

		if type(v138) == "table" and v138.Enabled and v138.Humanoid == p29 and v138.RootPart == p30 then
			if v30(v138.State, p29, p30) then
				v138.WalkSpeed = math.clamp(p31 * HEADROOM, MIN_SPEED, MAX_SPEED * HEADROOM)

				if typeof(p32) == "Vector3" then
					v138.TravelVelocity = p32
				elseif typeof(v138.TravelVelocity) ~= "Vector3" then
					v138.TravelVelocity = Vector3.zero
				end

				return v28(v138.State, v138.WalkSpeed, v138.TravelVelocity)
			end
		end

		return false
	end

	local function v139(p33)
		local v140 = v26()[INTEGRITY_KEY]

		if type(v140) ~= "table" then
			return
		end

		if p33 == nil or v140.Humanoid == p33 then
			v140.Enabled = false
			v140.Humanoid = nil
			v140.RootPart = nil
			v140.State = nil
			v140.TravelVelocity = nil
			v140.NextSearchAt = 0
		end
	end

	local connection3

	v33 = function()
		if connection3 then
			return
		end

		connection3 = RunService.PreSimulation:Connect(function()
			if genv.__SenaV4TweenRuntimeGeneration ~= __SenaV4TweenRuntimeGeneration then
				local v142 = connection3

				connection3 = nil

				if v142 then
					pcall(v142.Disconnect, v142)
				end

				return
			end

			local Character = LocalPlayer.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if not Character or not HumanoidRootPart or not Humanoid then
				return
			end

			local v146 = v20()

			v27(Character, v146 * HEADROOM)

			if not v32(Humanoid, HumanoidRootPart, v146) then
				v31(Humanoid, HumanoidRootPart, v146)
			end

			v66()
		end)
	end

	local function v147()
		if connection3 then
			pcall(connection3.Disconnect, connection3)
			connection3 = nil
		end

		v81()
		v139()
	end

	genv.__SenaV4TweenRuntimeCleanup = function()
		v68()
		v147()
	end
end

RunService.Heartbeat:Connect(function()
	local Character = LocalPlayer.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

	if Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude > 400 or math.abs(AssemblyLinearVelocity.Y) > 400 then
		HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(math.clamp(AssemblyLinearVelocity.X, -100, 100), math.clamp(AssemblyLinearVelocity.Y, -100, 100), math.clamp(AssemblyLinearVelocity.Z, -100, 100))
	end
end)
pcall(function()
	local queue_on_teleport_ = queue_on_teleport or queueonteleport

	queue_on_teleport_ = queue_on_teleport_ or syn and syn.queue_on_teleport

	if queue_on_teleport_ then
		pcall(queue_on_teleport_, "")
	end
end)

do
	pcall(function()
		game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
	end)
end

do
	local connection
	local connection2

	local function v154(p34)
		if not p34 then
			return
		end

		local Humanoid = p34:WaitForChild("Humanoid", 5) or p34:FindFirstChildOfClass("Humanoid")

		if not p34:WaitForChild("HumanoidRootPart", 5) then
			p34:FindFirstChild("HumanoidRootPart")
		end

		if not Humanoid then
			return
		end

		local health = math.max(Humanoid.MaxHealth, 100)
		local u157 = false
		local n4 = 0

		local function v159()
			if u157 or not Humanoid.Parent then
				return
			end

			local now = os.clock()

			if now - n4 < 0.1 then
				if Humanoid.Health > 0 then
					if Humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
						return
					end
				end
			end

			n4 = now
			u157 = true
			pcall(function()
				Humanoid.BreakJointsOnDeath = false
				Humanoid.RequiresNeck = false
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

				if Humanoid.Health <= 0 then
					Humanoid.Health = health
				end

				if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
					Humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end
			end)
			u157 = false
		end

		v159()

		if connection then
			pcall(connection.Disconnect, connection)
		end

		if connection2 then
			pcall(connection2.Disconnect, connection2)
		end

		connection = Humanoid.HealthChanged:Connect(function(health2)
			if health2 <= 0 or health2 < health then
				v159()
			end
		end)
		connection2 = RunService.Heartbeat:Connect(v159)
	end

	task.spawn(function()
		v154(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
	end)
	LocalPlayer.CharacterAdded:Connect(function(character)
		v154(character)
	end)
end

local senaV4Config = {
	AutoSteal = false,
	HelpFriend = false,
	ScrambleTradeInTrade = false,
	ScrambleTradeInReroll = false,
	ScrambleTradeInBanners = {},
	ScrambleBossAuto = false,
	StealMode = "Fly",
	FlyAerial = false,
	StealHoldSeconds = 5,
	StealAreas = { "None" },
	StealRarities = { "None" },
	StealNamesFilter = { "None" },
	StealMinValue = 0,
	StealMutations = { "None" },
	StealMinWeight = 0,
	StealPriority = "Rarity",
	AutoFavorite = false,
	FavMode = "Rarity",
	FavRarities = { "None" },
	FavSpecies = { "None" },
	AutoEquipBest = false,
	AutoClaimOffline = false,
	AutoBaseUpgrade = false,
	AutoClaimAlmanac = false,
	AutoFusePets = false,
	ScrambleFarmDrones = false,
	ScrambleLostParts = false,
	ScrambleCollectSamples = false,
	ScrambleAutoVault = false,
	ScrambleAutoBuy = false,
	ScrambleAreas = {},
	ScrambleDroneTypes = {},
	ScrambleBuyList = {},
	ButterflyAutoNet = false,
	ButterflyAutoCatch = false,
	ButterflyEsp = false,
	ButterflyTiers = {},
	ButterflyAutoTrade = false,
	ButterflyTradeRecipe = "All",
	ButterflyCatchMode = "Tween",
	ButterflyAutoCraft = false,
	Noclip = false,
	BottingMode = false,
	AntiCutscene = false,
	FuseSelectedOnly = false,
	FuseRarities = { "None" },
	FuseSpecies = { "None" },
	EspDetails = {
		"Name",
		"Rarity",
		"Value"
	},
	BackpackRateEsp = false,
	AntiAFK = true,
	AutoReconnect = true,
	AutoExecute = false,
	AutoPlace = false,
	PlaceRarities = { "None" },
	AutoHatch = false,
	SellAll = false,
	AutoSell = false,
	SellNames = { "None" },
	SellRarities = { "None" },
	AutoSellEgg = false,
	SellEggRarities = { "None" },
	WebhookEnabled = false,
	WebhookURL = "",
	TweenSpeedMultiplier = 60,
	AutoTreadmillIdle = false,
	AutoTreadmillUpgrade = false,
	AntiTreadmill = false,
	HopNoMatch = false,
	PrivateServerMax = "2",
	PrivateServerAuto = false,
	HopCooldown = 5,
	AutoIndex = false,
	AntiHitGuard = false,
	FlyForCapture = false,
	AutoStealCapture = false,
	InstantGrab = false,
	InfiniteJump = false,
	WalkSpeedMultiplier = 1,
	AntiGuardKnockback = true,
	GodMode = true,
	EggPredictUI = false,
	EggESP = false,
	StealPlayers = false,
	StealPlayerRarities = { "None" },
	StealPlayerMinValue = 0,
	StealPlayerTarget = "Any Player",
	WebhookRarities = { "None" },
	WebhookMinValue = 0
}
local EggState = require(game:GetService("ReplicatedStorage").Client.EggState)

EggState.GetAreaEggSnapshot = EggState.ReadFieldEggs
EggState.GetAreaEggRecord = EggState.ReadFieldEgg
EggState.RequestAreaEggSnapshot = EggState.SyncFieldEggs
EggState.RequestCarryAreaEgg = EggState.CarryFieldEgg
EggState.RequestDropHeldAreaEgg = EggState.DropFieldEgg
EggState.AreaEggCarryStateChanged = EggState.CarryChanged
EggState.AreaEggClaimed = EggState.FieldClaimed
EggState.AreaEggUpdated = EggState.FieldShifted
EggState.AreaEggRemoved = EggState.FieldGone
EggState.GetOwnerRuntimeRecords = EggState.ReadOwnerEggs
EggState.RequestEquipTool = EggState.WearEggTool
EggState.RequestPlaceEgg = EggState.PlantEgg
EggState.RequestHatchEgg = EggState.BeginHatch
EggState.RequestCompleteHatchEgg = EggState.FinishHatch
EggState.RequestRuntimeSnapshot = EggState.SyncOwnedEggs
EggState.RuntimeOwnerUpdated = EggState.OwnerRefreshed
EggState.RuntimeOwnerCleared = EggState.OwnerCleared

local PlotState = require(game:GetService("ReplicatedStorage").Client.PlotState)

PlotState.GetMySlot = PlotState.ResolveLocalSlot
PlotState.GetPlotsFolder = PlotState.ResolveFolder
PlotState.IsWorldPositionWithinLocalPlotBounds = PlotState.ContainsLocalPoint
PlotState.GetPlotData = PlotState.ResolvePlot

local AreaEggResetWall = require(game:GetService("ReplicatedStorage").Client.AreaEggResetWall)

AreaEggResetWall.IsClosed = AreaEggResetWall.IsSealed
v20 = function()
	if genv.__SenaV4AdminBoost == true then
		return 4000
	end

	return math.clamp(math.floor((tonumber(senaV4Config.TweenSpeedMultiplier) or t1.DEF_INPUT) + 0.5), t1.MIN_INPUT, t1.MAX_INPUT) * t1.MULTIPLIER
end
senaV4Config.applyStealValueInput = function(p35, p36)
	local lower = string.lower
	local tostring_ = tostring
	local v167 = lower(tostring_(p36 or "")):gsub("[%s,]", "")

	if v167 == "" then
		p35.StealMinValue = 0

		return true
	end

	local v168, v169 = string.match(v167, "^([%d]+%.?[%d]*)([kmb]?)$")
	local v170 = tonumber(v168)

	if not v170 then
		return false
	end

	local n5 = 1

	if v169 == "k" then
		n5 = 1000
	elseif v169 == "m" then
		n5 = 1000000
	elseif v169 == "b" then
		n5 = 1e9
	end

	p35.StealMinValue = v170 * n5

	return true
end
senaV4Config.getAreaEggValue = function(p37, p38)
	if not p37._assetGenerationUtil then
		p37._assetGenerationUtil = require(game:GetService("ReplicatedStorage").Shared.Util.AssetEarnings)
	end

	return p37._assetGenerationUtil.MutationOnlyRatePerSecond({
		Category = p38.AssetCategory,
		Scale = p38.AssetScale or 1,
		Mutations = p38.Mutations or {},
		BaseMutation = p38.BaseMutation,
		EyeColor = p38.AssetEyeColor,
		ColorSeed = p38.AssetColorSeed,
		ColorIndex = p38.AssetColorIndex,
		Gender = p38.Gender,
		Personality = p38.Personality or "Normal",
		HasBeenFirstPlaced = p38.HasBeenFirstPlaced == true
	})
end

local function v172(p39)
	local max = math.max
	local StealPriorityUntil = senaV4Config.StealPriorityUntil or 0

	senaV4Config.StealPriorityUntil = max(StealPriorityUntil, os.clock() + (p39 or 5))
end

local AreaEggCycle
local AreaEggResetWall2

pcall(function()
	AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
	AreaEggResetWall2 = require(ReplicatedStorage.Client.AreaEggResetWall)
end)

local function v177()
	if AreaEggCycle then
		if type(AreaEggCycle.IsNightPhase) == "function" then
			local ok, result = pcall(AreaEggCycle.IsNightPhase, workspace:GetServerTimeNow())

			if ok then
				if result == true then
					return true
				end
			end
		end
	end

	if AreaEggResetWall2 then
		if type(AreaEggResetWall2.IsSealed) == "function" then
			local ok, result = pcall(AreaEggResetWall2.IsSealed)

			if ok and result == true then
				return true
			end
		end

		if type(AreaEggResetWall2.IsClosed) == "function" then
			local ok, result = pcall(AreaEggResetWall2.IsClosed)

			if ok and result == true then
				return true
			end
		end
	end

	return false
end

do
	local n6 = 0
	local u185 = false

	local function v186()
		if v177() then
			return false
		end

		local now = os.clock()

		if now - n6 < 0.35 then
			return u185
		end

		n6 = now

		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local v189 = require(ReplicatedStorage2.Client.EggState).GetAreaEggSnapshot()
		local Directory = require(ReplicatedStorage2.Data.Assets).Directory
		local pairs_ = pairs
		local Records = v189 and v189.Records or {}

		for _, Record in pairs_(Records) do
			if Record.State ~= "Slot" and Record.State ~= "Dropped" or not Record.BottomCFrame then
				continue
			end

			local v195 = Directory[Record.AssetCategory]
			local Rarity = v195 and v195.Rarity
			local DisplayName = Rarity and (Rarity.DisplayName or Rarity._id)

			if DisplayName ~= "Eternal" and DisplayName ~= "Divine" then
				continue
			end

			u185 = true

			return true
		end

		u185 = false

		return false
	end
end

local function v198()
	if senaV4Config.IsStealing then
		return false
	end

	local __SenaV4DronesWantCharacter = genv.__SenaV4DronesWantCharacter

	if __SenaV4DronesWantCharacter and __SenaV4DronesWantCharacter() then
		return false
	end

	if senaV4Config.IsPlacing == true then
		return false
	end

	if senaV4Config.AutoSteal then
		return os.clock() >= (senaV4Config.StealPriorityUntil or 0)
	end

	return true
end

do
	local function v200(p40)
		pcall(function()
			if typeof(writefile) ~= "function" then
				return
			end

			local s1 = ""

			if typeof(readfile) == "function" and typeof(isfile) == "function" and isfile("Sena_Disconnect_Log.txt") then
				s1 = readfile("Sena_Disconnect_Log.txt") or ""
			end

			local t5 = {}

			for match in s1:gmatch("[^\r\n]+") do
				table.insert(t5, match)
			end

			local v204 = "] " .. p40

			table.insert(t5, "[" .. os.date("%Y-%m-%d %H:%M:%S") .. v204)

			while #t5 > 50 do
				table.remove(t5, 1)
			end

			writefile("Sena_Disconnect_Log.txt", table.concat(t5, "\n"))
		end)
	end
end

local function v205(p41)
	if not p41 or type(p41.GetValue) ~= "function" then
		return nil
	end

	local ok, result = pcall(function()
		return p41:GetValue()
	end)

	if not ok then
		return nil
	end

	if type(result) ~= "table" then
		if type(result) == "string" then
			return { result }
		end

		return nil
	end

	local t6 = {}

	for k, v in pairs(result) do
		if type(k) == "number" then
			table.insert(t6, v)
		elseif type(k) == "string" and v == true then
			table.insert(t6, k)
		end
	end

	return t6
end
local function v211(p42, p43, p44, p45)
	if senaV4Config.SellAll then
		return true
	end

	if type(p44) ~= "table" or type(p45) ~= "table" then
		return false
	end

	local v212 = false

	if not (#p44 == 0 or table.find(p44, "None")) then
		if table.find(p44, "All") then
			v212 = true
		else
			v212 = table.find(p44, p42) ~= nil
		end
	end

	local v213 = false

	if #p45 ~= 0 and not table.find(p45, "None") then
		if table.find(p45, "All") then
			v213 = true
		else
			v213 = table.find(p45, p43) ~= nil
		end
	end

	return v212 or v213
end
local function v214(p46, p47)
	if type(p47) ~= "table" then
		return false
	end

	if #p47 ~= 0 then
		if not table.find(p47, "None") then
			if table.find(p47, "All") then
				return true
			end

			return table.find(p47, p46) ~= nil
		end
	end

	return false
end
local function v215(p48)
	local HumanoidRootPart = p48 and p48:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		HumanoidRootPart:SetAttribute("KillPartIgnore", true)
	end
end

local vector3 = Vector3.new(544.76, 71.5, -416.48)
local t7 = {
	CarryRetry = 0.25,
	CarryTimeout = 2,
	EarlyCarryDistance = 8,
	SafeStable = 0.35,
	ReturnValidation = 0.08,
	NextTarget = 0.05,
	SafeHandoff = 0.15
}
local t8 = {
	GUARD_MARGIN = 1.25,
	GUARD_FALLBACK = 222,
	maxGuardWalkSpeed = nil,
	floorNotifiedFor = -1,
	capNotifiedFor = -1
}

local function v220()
	if not t8.maxGuardWalkSpeed then
		local ok, result = pcall(function()
			return require(game:GetService("ReplicatedStorage").Data.Guards).GetHighestWalkSpeed()
		end)

		t8.maxGuardWalkSpeed = ok and type(result) == "number" and result > 0 and result or t8.GUARD_FALLBACK
		warn(string.format("[GuardEscape] Guard tercepat %d stud/detik -> lantai kabur %d stud/detik", t8.maxGuardWalkSpeed, t8.maxGuardWalkSpeed * t8.GUARD_MARGIN))
	end

	return t8.maxGuardWalkSpeed * t8.GUARD_MARGIN
end
local function v223(p49)
	local tweenSpeedMultiplier = math.clamp(math.floor((tonumber(p49) or t1.DEF_INPUT) + 0.5), t1.MIN_INPUT, t1.MAX_INPUT)

	if math.abs((senaV4Config.TweenSpeedMultiplier or 0) - tweenSpeedMultiplier) <= 0.001 then
		return
	end

	senaV4Config.TweenSpeedMultiplier = tweenSpeedMultiplier
end
local function v225(p50, p51, p52, p53)
	local v226 = os.clock() + p52
	local now
	local n7 = 0
	local n8 = 0.1

	pcall(function()
		n8 = LocalPlayer:GetNetworkPing()
	end)

	local v230 = math.clamp(n8 * 2 + 0.2, 0.4, 1)

	while true do
		if not (os.clock() < v226) then
			return false
		end

		if p53 and p53() then
			break
		end

		p50.AssemblyLinearVelocity = Vector3.zero
		p50.AssemblyAngularVelocity = Vector3.zero
		RunService.Heartbeat:Wait()

		if not ((p50.Parent and (p50.Position - p51.Position).Magnitude or math.huge) <= 1.5) then
			now = nil
			n7 = 0

			continue
		end

		p50.CFrame = p51
		now = now or os.clock()
		n7 += 1

		if not (n7 >= 3) or not (v230 <= os.clock() - now) then
			continue
		end

		return true
	end

	return false
end

local t9 = {}

local function v232(p54, p55, p56, p57, p58, p59, p60)
	if not p54 or not p55 or typeof(p56) ~= "CFrame" then
		return false
	end

	if p57 and p57() then
		return false
	end

	local v233 = t9[p54]

	if v233 then
		v233.cancelled = true
		t9[p54] = nil
	end

	local Parent = p54.Parent

	if not Parent then
		return false
	end

	v24()
	v215(Parent)
	v33()

	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera and CurrentCamera.CameraSubject ~= p55 then
		pcall(function()
			CurrentCamera.CameraSubject = p55
		end)
	end

	local AutoRotate = p55.AutoRotate

	p55.AutoRotate = false

	local v237 = p60 and math.max(p54.Position.Y, p56.Position.Y + 5, vector3.Y + 5) or nil
	local v238 = v237 and cFrameNew(p56.Position.X, v237, p56.Position.Z) * p56.Rotation or p56
	local v239 = math.clamp(v20(), t1.MIN_SPEED, genv.__SenaV4AdminBoost == true and 3000 or t1.MAX_SPEED)

	v27(Parent, v239 * t1.HEADROOM)

	local t10 = {
		cancelled = false
	}

	t9[p54] = t10
	v22()

	local now
	local v242
	local n9 = 0
	local v244 = v237 and (math.abs(p54.Position.Y - v237) > 0.35 and "takeoff" or "cruise") or nil
	local Magnitude = (v238.Position - p54.Position).Magnitude
	local v246 = os.clock() + math.max(Magnitude / v239, 0.08) * 3 + 8
	local v247 = false
	local v248 = false

	while not t10.cancelled and (not p57 or not p57()) and p54.Parent and not (v246 <= os.clock()) do
		local v249 = math.max(math.min(RunService.Heartbeat:Wait(), 0.15), 0.0041666666666666666)
		local v250 = math.clamp(v20(), t1.MIN_SPEED, genv.__SenaV4AdminBoost == true and 3000 or t1.MAX_SPEED)

		v27(Parent, v250 * t1.HEADROOM)

		local v251 = v26()[t1.INTEGRITY_KEY]
		local State = type(v251) == "table" and v251.State or nil

		if v30(State, p55, p54) then
			local Position = p54.Position
			local v254 = v238.Position - Position
			local Magnitude2 = v254.Magnitude
			local vector32 = Vector3.new(v254.X, 0, v254.Z)

			if v237 and v244 == "takeoff" and math.abs(Position.Y - v237) <= 0.35 then
				v244 = "cruise"
			end

			local v257 = (v237 and v244 == "takeoff" and Vector3.new(Position.X, v237, Position.Z) or v238.Position) - Position
			local Magnitude3 = v257.Magnitude
			local Magnitude4 = v237 and vector32.Magnitude or Magnitude2

			if v242 and v242 + 2 < Magnitude4 then
				n9 = os.clock() + 0.5
			end

			v242 = Magnitude4

			local v260 = (os.clock() < n9 and math.max(t1.MIN_SPEED, v250 * 0.45) or v250) * v249

			if p59 and not v248 and Magnitude2 <= t7.EarlyCarryDistance then
				v248 = true
				task.spawn(p59)
			end

			local vector33 = Vector3.new(p54.CFrame.LookVector.X, 0, p54.CFrame.LookVector.Z)
			local Unit = vector32.Magnitude > 0.001 and vector32.Unit or vector33.Magnitude > 0.001 and vector33.Unit or Vector3.new(0, 0, -1)

			if (not v237 or v244 == "cruise") and Magnitude2 <= math.max(v260, 0.05) then
				if Magnitude2 > 0.5 then
					now = nil
				end

				v21(v238.Position)
				p54.CFrame = lookAt(v238.Position, v238.Position + Unit)
				p54.AssemblyLinearVelocity = Vector3.zero
				p54.AssemblyAngularVelocity = Vector3.zero
				v21(v238.Position)
				v32(p55, p54, v250, Vector3.zero)
				now = now or os.clock()

				if os.clock() - now >= 0.4 then
					v247 = true

					break
				end
			else
				now = nil

				if Magnitude3 <= 0.001 then
					p54.AssemblyLinearVelocity = Vector3.zero
					p54.AssemblyAngularVelocity = Vector3.zero
					v21(Position)
				else
					local v263 = Position + v257.Unit * math.min(v260, Magnitude3)
					local v264 = (v263 - Position) / v249

					v21(v263)
					p54.CFrame = lookAt(v263, v263 + Unit)
					p54.AssemblyLinearVelocity = Vector3.zero
					v21(v263)

					if not v32(p55, p54, v250, v264) then
						v31(p55, p54, v250)
						v32(p55, p54, v250, v264)
					end
				end
			end
		else
			v242 = nil
			now = nil
			p54.AssemblyLinearVelocity = Vector3.zero
			p54.AssemblyAngularVelocity = Vector3.zero
			v21(p54.Position)

			if v29(State, p55, p54) then
				v28(State, v250 * t1.HEADROOM, Vector3.zero)
			else
				v31(p55, p54, v250)
			end
		end
	end

	if p55.Parent and AutoRotate ~= nil then
		p55.AutoRotate = AutoRotate
	end

	p54.AssemblyLinearVelocity = Vector3.zero
	p54.AssemblyAngularVelocity = Vector3.zero

	if v247 and p58 then
		v25(p54, v238)
	else
		v23()
	end

	local v265 = v247 and not t10.cancelled

	return v265
end
local function v266(p61, p62, p63, p64)
	return v232(p61, p62, p63, p64, false, nil, true)
end
local function v267(p65, p66)
	if p65 then
		if typeof(p66) == "CFrame" then
			if not pcall(function()
				p65.AssemblyLinearVelocity = Vector3.zero
				p65.AssemblyAngularVelocity = Vector3.zero
				p65.CFrame = p66
				p65.AssemblyLinearVelocity = Vector3.zero
				p65.AssemblyAngularVelocity = Vector3.zero
			end) then
				return false
			end

			v21(p66.Position)

			local Parent = p65.Parent
			local Humanoid = Parent and Parent:FindFirstChildOfClass("Humanoid")

			if Humanoid then
				local v270 = math.clamp(v20(), t1.MIN_SPEED, genv.__SenaV4AdminBoost == true and 3000 or t1.MAX_SPEED)

				v27(Parent, v270 * t1.HEADROOM)

				if not v32(Humanoid, p65, v270, Vector3.zero) then
					v31(Humanoid, p65, v270)
					v32(Humanoid, p65, v270, Vector3.zero)
				end
			end

			return true
		end
	end

	return false
end

getgenv().SenaV4Config = senaV4Config

local function v271(p67)
	if p67 and p67.Name == "PlayerTrap" then
		pcall(function()
			p67:Destroy()
		end)
	end
end

task.spawn(function()
	local function v272(p68)
		if not p68 then
			return
		end

		local v273, v274, v275 = ipairs(p68:GetChildren())
		local v276 = geniter(v273, v274, v275)
		local v277 = table.pack(v276())

		if v277[1] then
			local v278 = v277[3]

			while true do
				v271(v278)

				local v279 = table.pack(v276())

				if v279[1] then
					v278 = v279[3]
				else
					break
				end
			end
		end

		p68.ChildAdded:Connect(function(child)
			v271(child)
		end)
	end

	local Transient = workspace:FindFirstChild("Transient")

	if Transient then
		v272(Transient)
	end

	local __DEBRIS = workspace:FindFirstChild("__DEBRIS")

	if __DEBRIS then
		v272(__DEBRIS)
	end

	workspace.ChildAdded:Connect(function(child)
		if child.Name == "Transient" or child.Name == "__DEBRIS" then
			v272(child)
		elseif child.Name == "PlayerTrap" then
			v271(child)

			return
		elseif child.Name:lower():find("trap") then
			v271(child)
		end
	end)
	task.spawn(function()
		while v16() do
			for _, v in ipairs({
				workspace:FindFirstChild("Transient"),
				workspace:FindFirstChild("__DEBRIS")
			}) do
				if v then
					for _, child in ipairs(v:GetChildren()) do
						v271(child)
					end
				end
			end

			task.wait(1.5)
		end
	end)
end)

local u286

local function v287()
	local ok, result = pcall(function()
		return require(game:GetService("ReplicatedStorage").Shared.Remotes).Treadmill.AskRenderSnapshot:InvokeServer()
	end)

	if ok then
		if type(result) == "table" then
			return table.find(result, LocalPlayer.UserId) ~= nil
		end
	end

	return nil
end
local function v290()
	local ok, result, result2 = pcall(function()
		return require(game:GetService("ReplicatedStorage").Shared.Remotes).Treadmill.AskDoff:InvokeServer()
	end)

	if not ok then
		return false, tostring(result)
	end

	if result ~= true then
		return false, tostring(result2)
	end

	return true
end
local function v294()
	local ok, result = pcall(function()
		local PlotState2 = require(ReplicatedStorage.Client.PlotState)
		local v298 = type(PlotState2.ResolveLocalSlot) == "function" and PlotState2.ResolveLocalSlot() or PlotState2.GetMySlot()
		local v299 = type(PlotState2.ResolveFolder) == "function" and PlotState2.ResolveFolder() or PlotState2.GetPlotsFolder()
		local v300 = v299 and v298

		v300 = v300 and v299:FindFirstChild(tostring(v298))

		local TreadmillBottom = v300 and v300:FindFirstChild("TreadmillBottom")

		if not TreadmillBottom or not TreadmillBottom:IsA("BasePart") then
			return nil
		end

		local Character = LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

		if HumanoidRootPart and Humanoid then
			return TreadmillBottom.CFrame * cFrameNew(0, TreadmillBottom.Size.Y * 0.5 + (Humanoid.RigType == Enum.HumanoidRigType.R15 and HumanoidRootPart.Size.Y * 0.5 + math.max(Humanoid.HipHeight, 0.5) or HumanoidRootPart.Size.Y * 0.5 + 2) + 0.05, 0)
		end

		return nil
	end)
	local v305 = ok and result or nil

	return v305
end

local t11 = {
	HoldSeconds = 0.3,
	ConfirmStableSeconds = 0.3,
	ConfirmTimeout = 2.5,
	PollSeconds = 0.05,
	ArrivalSettle = 0.5,
	DecoyName = "__SenaV4TweenTreadmillDecoy",
	destroyTrail = function(p69)
		if typeof(p69) == "Instance" then
			if p69:IsA("Trail") then
				pcall(p69.Destroy, p69)
			end
		end
	end,
	destroyStealPopup = function(p70)
		if senaV4Config.IsStealing then
			if typeof(p70) == "Instance" and (p70.Name == "SpeedGainPopup" or p70.Name == "PlusOne") then
				pcall(p70.Destroy, p70)
			end
		end
	end
}

t11.purgeStealPopups = function()
	local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if not PlayerGui then
		return
	end

	for _, descendant in ipairs(PlayerGui:GetDescendants()) do
		t11.destroyStealPopup(descendant)
	end
end
t11.guiConnection = LocalPlayer:WaitForChild("PlayerGui").DescendantAdded:Connect(function(descendant)
	t11.destroyStealPopup(descendant)
end)
t11.removeDecoy = function()
	if t11.cameraConnection then
		pcall(t11.cameraConnection.Disconnect, t11.cameraConnection)
		t11.cameraConnection = nil
	end

	if t11.characterConnection then
		pcall(t11.characterConnection.Disconnect, t11.characterConnection)
		t11.characterConnection = nil
	end

	local pairs_ = pairs
	local transparency = t11.transparency or {}

	for k, v in pairs_(transparency) do
		if typeof(k) == "Instance" and k.Parent then
			pcall(function()
				k.LocalTransparencyModifier = v
			end)
		end
	end

	t11.transparency = nil

	local Character = LocalPlayer.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera then
		pcall(function()
			CurrentCamera.CameraSubject = Humanoid or t11.cameraSubject
		end)
	end

	t11.cameraSubject = nil

	if t11.decoy then
		pcall(t11.decoy.Destroy, t11.decoy)
	end

	t11.decoy = nil
end
t11.spawnDecoy = function(p71)
	t11.removeDecoy()

	local Character = LocalPlayer.Character

	if not Character then
		return false
	end

	local Archivable = Character.Archivable

	Character.Archivable = true

	local ok, decoy = pcall(Character.Clone, Character)

	Character.Archivable = Archivable

	if not ok or not decoy or typeof(decoy) ~= "Instance" then
		return false
	end

	decoy.Name = t11.DecoyName

	for _, descendant in ipairs(decoy:GetDescendants()) do
		if not descendant:IsA("Script") then
			if not descendant:IsA("LocalScript") and not descendant:IsA("BillboardGui") and not descendant:IsA("Sound") and not descendant:IsA("Trail") then
				if not descendant:IsA("BasePart") then
					continue
				end

				descendant.LocalTransparencyModifier = 0
				descendant.Anchored = true
				descendant.CanCollide = false
				descendant.CanQuery = false
				descendant.CanTouch = false

				continue
			end
		end

		pcall(descendant.Destroy, descendant)
	end

	local Humanoid = decoy:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		decoy:Destroy()

		return false
	end

	pcall(function()
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	end)
	decoy.Parent = workspace
	decoy:PivotTo(p71)
	t11.decoy = decoy

	local transparency = setmetatable({}, {
		__mode = "k"
	})

	local function v325(p72)
		if not p72 or not p72:IsA("BasePart") or not p72:IsDescendantOf(Character) then
			return
		end

		if transparency[p72] == nil then
			transparency[p72] = p72.LocalTransparencyModifier
		end

		p72.LocalTransparencyModifier = 1
	end

	for _, descendant in ipairs(Character:GetDescendants()) do
		v325(descendant)
		t11.destroyTrail(descendant)
	end

	t11.transparency = transparency
	t11.characterConnection = Character.DescendantAdded:Connect(function(descendant)
		if t11.decoy == decoy then
			pcall(v325, descendant)
			t11.destroyTrail(descendant)
		end
	end)

	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera then
		t11.cameraSubject = CurrentCamera.CameraSubject
		CurrentCamera.CameraSubject = Humanoid
	end

	t11.cameraConnection = RunService.RenderStepped:Connect(function()
		if t11.decoy == decoy then
			if decoy.Parent and Humanoid.Parent then
				for k in pairs(transparency) do
					if k.Parent and k.LocalTransparencyModifier ~= 1 then
						k.LocalTransparencyModifier = 1
					end
				end

				local CurrentCamera2 = workspace.CurrentCamera

				if CurrentCamera2 and CurrentCamera2.CameraSubject ~= Humanoid then
					CurrentCamera2.CameraSubject = Humanoid
				end

				return
			end
		end
	end)

	return true
end
t11.requestEquip = function()
	local ok, result, result2 = pcall(function()
		return require(ReplicatedStorage.Shared.Remotes).Treadmill.AskWearStill:InvokeServer()
	end)

	if ok then
		if result ~= false then
			return true
		end
	end

	local v334 = false
	local tostring_ = tostring
	local v336 = result2 or result

	return v334, tostring_(v336)
end
t11.prepare = function(p73, p74)
	local Character = LocalPlayer.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if HumanoidRootPart then
		if Humanoid and typeof(p73) == "CFrame" then
			local function v340()
				return p74 ~= nil and p74()
			end
			local function v341()
				local Character2 = LocalPlayer.Character
				local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart2 then
					v267(HumanoidRootPart2, p73)
					task.wait(0.1)
				end

				t11.removeDecoy()
			end

			t11.purgeStealPopups()
			v24()
			v23()

			if not t11.spawnDecoy(p73) then
				return false
			end

			local v344 = v294()

			if not v344 or v340() or not v267(HumanoidRootPart, v344) then
				v290()
				v341()

				return false
			end

			task.wait(t11.ArrivalSettle)

			if v340() then
				v290()
				v341()

				return false
			end

			if not t11.requestEquip() then
				v290()
				v341()

				return false
			end

			local v345 = os.clock() + t11.ConfirmTimeout
			local v346 = false
			local now

			while not v340() do
				if not (os.clock() < v345) then
					break
				end

				if v287() == true then
					now = now or os.clock()

					if not (t11.ConfirmStableSeconds <= os.clock() - now) then
						task.wait(t11.PollSeconds)

						continue
					end

					v346 = true

					break
				end

				now = nil
				task.wait(t11.PollSeconds)
			end

			if not v346 or v340() then
				v290()
				v341()

				return false
			end

			local v348 = os.clock() + t11.HoldSeconds

			while not v340() and os.clock() < v348 do
				task.wait(t11.PollSeconds)
			end

			local v349 = os.clock() + t11.ConfirmTimeout
			local v350 = false

			while not v340() and os.clock() < v349 do
				v290()
				task.wait(t11.PollSeconds)

				if v287() == false then
					u286 = nil
					v350 = true

					break
				end
			end

			v341()

			local v351 = v350 and not v340()

			return v351
		end
	end

	return false
end
t11.previousCleanup = genv.__SenaV4TweenRuntimeCleanup
genv.__SenaV4TweenRuntimeCleanup = function()
	v290()
	t11.removeDecoy()

	if t11.guiConnection then
		pcall(t11.guiConnection.Disconnect, t11.guiConnection)
		t11.guiConnection = nil
	end

	if type(t11.previousCleanup) == "function" then
		t11.previousCleanup()
	end
end
LocalPlayer.CharacterRemoving:Connect(function()
	t11.removeDecoy()
end)

do
	if type(genv.__SenaV4CosmeticSuppressCleanup) == "function" then
		pcall(genv.__SenaV4CosmeticSuppressCleanup)
	end

	local t12 = {}

	local function v353(child)
		if child then
			if child.Name == "DropHeldEgg" then
				if not child:IsA("ScreenGui") then
					if not child:IsA("LayerCollector") then
						return
					end
				end

				pcall(function()
					child.Enabled = false
				end)
				table.insert(t12, child:GetPropertyChangedSignal("Enabled"):Connect(function()
					if child.Enabled then
						pcall(function()
							child.Enabled = false
						end)
					end
				end))

				return
			end
		end
	end
	local function v354()
		local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

		if PlayerGui then
			for _, child in ipairs(PlayerGui:GetChildren()) do
				v353(child)
			end

			table.insert(t12, PlayerGui.ChildAdded:Connect(v353))

			return
		end
	end

	v354()
	table.insert(t12, LocalPlayer.CharacterAdded:Connect(function()
		task.defer(v354)
	end))
	pcall(function()
		local GuardPresentationComponent = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardPresentationComponent)

		if type(GuardPresentationComponent) == "table" then
			genv.__SenaV4GuardPresentOrig = genv.__SenaV4GuardPresentOrig or {
				PlayWake = GuardPresentationComponent.PlayWake,
				PlayHit = GuardPresentationComponent.PlayHit,
				PlayAfterWake = GuardPresentationComponent.PlayAfterWake,
				ScheduleAfterWake = GuardPresentationComponent.ScheduleAfterWake
			}

			local function playWake()
			end

			GuardPresentationComponent.PlayWake = playWake
			GuardPresentationComponent.PlayHit = function()
				return 0
			end
			GuardPresentationComponent.PlayAfterWake = playWake
			GuardPresentationComponent.ScheduleAfterWake = playWake
		end
	end)
	genv.__SenaV4CosmeticSuppressCleanup = function()
		for _, v in ipairs(t12) do
			pcall(function()
				v:Disconnect()
			end)
		end

		table.clear(t12)

		local __SenaV4GuardPresentOrig = genv.__SenaV4GuardPresentOrig

		if type(__SenaV4GuardPresentOrig) == "table" then
			pcall(function()
				local GuardPresentationComponent = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardPresentationComponent)

				for k, v in pairs(__SenaV4GuardPresentOrig) do
					GuardPresentationComponent[k] = v
				end
			end)
		end
	end
end

do
	if type(genv.__SenaV4StealDeclutterCleanup) == "function" then
		pcall(genv.__SenaV4StealDeclutterCleanup)
	end

	local t13 = {
		{
			name = "ProximityPrompts",
			restore = true
		},
		{
			name = "AreaGui",
			restore = false
		}
	}
	local u367 = false
	local t14 = {}

	local function v369(p75)
		return p75 and (p75:IsA("ScreenGui") or p75:IsA("LayerCollector"))
	end
	local function v370(p76)
		if not v369(p76) then
			return
		end

		pcall(function()
			p76.Enabled = false
		end)
		table.insert(t14, p76:GetPropertyChangedSignal("Enabled"):Connect(function()
			if u367 then
				if p76.Enabled then
					pcall(function()
						p76.Enabled = false
					end)
				end
			end
		end))
	end
	local function v371(p77)
		local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

		if not PlayerGui then
			return
		end

		for _, v in ipairs(t13) do
			local VName = PlayerGui:FindFirstChild(v.name)

			if VName then
				p77(VName, v)
			end
		end
	end
	local function v376()
		local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

		if not PlayerGui then
			return
		end

		v371(function(p78)
			v370(p78)
		end)
		table.insert(t14, PlayerGui.ChildAdded:Connect(function(child)
			if not u367 then
				return
			end

			for _, v in ipairs(t13) do
				if child.Name == v.name then
					v370(child)

					break
				end
			end
		end))
	end
	local function v380()
		for _, v in ipairs(t14) do
			pcall(function()
				v:Disconnect()
			end)
		end

		table.clear(t14)
		v371(function(p79, p80)
			pcall(function()
				p79.Enabled = p80.restore
			end)
		end)
	end

	genv.__SenaV4SetStealDeclutter = function(p81)
		local v383 = p81 == true

		if v383 == u367 then
			return
		end

		u367 = v383

		if v383 then
			v376()
		else
			v380()
		end
	end
	genv.__SenaV4StealDeclutterCleanup = function()
		u367 = false
		v380()
	end
end

do
	local function v384()
		local v385 = v287()

		if v385 == false then
			u286 = nil

			return true
		end

		if v385 == nil and u286 == nil then
			return true
		end

		u286 = u286 or "server"

		local v386, v387 = v290()

		if not v386 then
			warn("[Treadmill] Gagal minta lepas dari treadmill sebelum steal:", v387)

			return false
		end

		local v388 = os.clock() + 1.5

		while u286 ~= nil and os.clock() < v388 do
			task.wait(0.05)

			if not senaV4Config.AutoSteal then
				return false
			end

			if v287() == false then
				u286 = nil

				break
			end
		end

		if u286 ~= nil then
			warn("[Treadmill] Lepas treadmill gak kekonfirmasi dalam 1.5s, steal dilanjut apa adanya.")

			return false
		end

		task.wait(0.12)

		return true
	end
end

if type(genv.__SenaV4DecomBoostCleanup) == "function" then
	pcall(genv.__SenaV4DecomBoostCleanup)
end

local t15, v390, v391

do
	local t16 = {}
	local u393 = false

	genv.__SenaV4DecomBoostCleanup = function()
		for _, v in ipairs(t16) do
			pcall(function()
				v:Disconnect()
			end)
		end

		table.clear(t16)
		u393 = false
	end

	local function v396()
		local ClientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets")

		if not ClientRenderedAssets then
			return
		end

		for _, child in ipairs(ClientRenderedAssets:GetChildren()) do
			pcall(function()
				child.Parent = nil
			end)
		end
	end
	local function v400(p82)
		return string.sub(p82.Name, 1, #tostring(LocalPlayer.UserId) + 1) == tostring(LocalPlayer.UserId) .. "_"
	end
	local function v401()
		for _, child in ipairs(workspace:GetChildren()) do
			if child.Name == "PlacedEggRenders" then
				for _, child2 in ipairs(child:GetChildren()) do
					pcall(function()
						if not child2:FindFirstChildOfClass("ProximityPrompt") then
							if not v400(child2) then
								child2.Parent = nil
							end
						end
					end)
				end
			end
		end
	end
	local function v406()
		for _, v in ipairs({
			"Transient",
			"__DEBRIS"
		}) do
			local v409 = workspace:FindFirstChild(v)

			if v409 then
				for _, child in ipairs(v409:GetChildren()) do
					if child.Name ~= "PlayerTrap" then
						if not child.Name:lower():find("trap") then
							continue
						end
					end

					pcall(function()
						child:Destroy()
					end)
				end
			end
		end
	end
	local function v412(p83)
		if not p83:FindFirstAncestor("SenaVisualBack") then
			if not p83:FindFirstAncestor("SenaVisualRemote") then
				local Tool = p83:FindFirstAncestorWhichIsA("Tool")

				return Tool ~= nil and Tool:GetAttribute("SenaVisual") ~= nil
			end
		end

		return true
	end

	t15 = {
		effects = {},
		parts = {},
		decals = {},
		snapshot = nil
	}

	local t17 = {
		PlusOne = true,
		SpeedGainPopup = true,
		SellPayout = true,
		SyncedIncomeCash = true
	}
	local t18 = {
		PlayerPlotSign = true,
		CanUpgrade = true,
		AlertGui = true,
		OfflineMoneyClaimBillboard = true
	}

	local function v416(descendant)
		pcall(function()
			if v412(descendant) then
				return
			end

			if t17[descendant.Name] then
				descendant:Destroy()

				return
			end

			if descendant:IsA("BillboardGui") and t18[descendant.Name] then
				if descendant.Enabled then
					t15.effects[descendant] = true
				end

				descendant.Enabled = false

				return
			end

			if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Sparkles") or descendant:IsA("Fire") or descendant:IsA("Smoke") or descendant:IsA("PostEffect") then
				if descendant.Enabled then
					t15.effects[descendant] = true
				end

				descendant.Enabled = false
			end
		end)
	end
	local function v417()
		if u393 then
			return
		end

		u393 = true
		table.insert(t16, game.DescendantAdded:Connect(v416))
		table.insert(t16, workspace.ChildAdded:Connect(function(child)
			if child.Name == "ClientRenderedAssets" then
				v396()
				table.insert(t16, child.ChildAdded:Connect(function(child2)
					pcall(function()
						child2.Parent = nil
					end)
				end))
			elseif child.Name == "PlacedEggRenders" then
				v401()
				table.insert(t16, child.ChildAdded:Connect(function(child2)
					pcall(function()
						if not child2:FindFirstChildOfClass("ProximityPrompt") and not v400(child2) then
							child2.Parent = nil
						end
					end)
				end))
			elseif child.Name == "__DEBRIS" or child.Name == "Transient" then
				table.insert(t16, child.ChildAdded:Connect(function(child2)
					if child2.Name == "PlayerTrap" then
						pcall(function()
							child2:Destroy()
						end)

						return
					elseif child2.Name:lower():find("trap") then
						pcall(function()
							child2:Destroy()
						end)
					end
				end))
			end
		end))

		local ClientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets")

		if ClientRenderedAssets then
			table.insert(t16, ClientRenderedAssets.ChildAdded:Connect(function(child)
				pcall(function()
					child.Parent = nil
				end)
			end))
		end

		for _, child in ipairs(workspace:GetChildren()) do
			if child.Name == "PlacedEggRenders" then
				table.insert(t16, child.ChildAdded:Connect(function(child2)
					pcall(function()
						if not child2:FindFirstChildOfClass("ProximityPrompt") then
							if not v400(child2) then
								child2.Parent = nil
							end
						end
					end)
				end))
			end
		end
	end

	local u421 = false

	v390 = function()
		if u421 then
			return
		end

		u421 = true

		local Lighting = game:GetService("Lighting")

		if not t15.snapshot then
			local t19 = {}

			pcall(function()
				t19.quality = settings().Rendering.QualityLevel
				t19.throttle = settings().Physics.PhysicsEnvironmentalThrottle
				t19.technology = Lighting.Technology
				t19.shadows = Lighting.GlobalShadows
				t19.fogEnd = Lighting.FogEnd
				t19.brightness = Lighting.Brightness
				t19.ambient = Lighting.Ambient
				t19.outdoorAmbient = Lighting.OutdoorAmbient
			end)

			local Terrain = workspace:FindFirstChildOfClass("Terrain")

			if Terrain then
				pcall(function()
					t19.terrain = {
						WaterWaveSize = Terrain.WaterWaveSize,
						WaterWaveSpeed = Terrain.WaterWaveSpeed,
						WaterReflectance = Terrain.WaterReflectance,
						WaterTransparency = Terrain.WaterTransparency,
						Decoration = Terrain.Decoration
					}
				end)
				pcall(function()
					local Clouds = Terrain:FindFirstChildOfClass("Clouds")

					if Clouds then
						t19.cloudsEnabled = Clouds.Enabled
					end
				end)
			end

			pcall(function()
				local Preferences = ReplicatedStorage.Shared:FindFirstChild("Preferences")

				if Preferences then
					local module = require(Preferences)

					t19.prefs = {
						HideOtherPets = module.IsOn("HideOtherPets"),
						DisableVideos = module.IsOn("DisableVideos")
					}
				end
			end)

			if t19.quality == Enum.QualityLevel.Level01 then
				t19.quality = Enum.QualityLevel.Automatic
			end

			t15.snapshot = genv.__SenaV4DecomSnapshot or t19
			genv.__SenaV4DecomSnapshot = t15.snapshot
		end

		pcall(function()
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
			settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Always
			Lighting.Technology = Enum.Technology.Compatibility
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 9e9
			Lighting.Brightness = 2
			Lighting.Ambient = Color3.new(1, 1, 1)
			Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
		end)

		local now = os.clock()

		for _, v in ipairs({
			workspace,
			Lighting
		}) do
			for _, descendant in ipairs(v:GetDescendants()) do
				if not v412(descendant) then
					if descendant:IsA("BasePart") then
						pcall(function()
							if not t15.parts[descendant] then
								t15.parts[descendant] = {
									descendant.Material,
									descendant.CastShadow,
									descendant:IsA("MeshPart") and descendant.RenderFidelity or nil
								}
							end

							descendant.Material = Enum.Material.SmoothPlastic
							descendant.CastShadow = false

							if descendant:IsA("MeshPart") then
								descendant.RenderFidelity = Enum.RenderFidelity.Performance
							end
						end)
					else
						if descendant:IsA("Decal") then
							pcall(function()
								if descendant.Texture ~= "" and not t15.decals[descendant] then
									t15.decals[descendant] = descendant.Texture
								end

								descendant.Texture = ""
							end)

							if os.clock() - now > 0.004 then
								task.wait()
								now = os.clock()
							end

							continue
						end

						if descendant:IsA("Texture") then
							pcall(function()
								if descendant.Texture ~= "" and not t15.decals[descendant] then
									t15.decals[descendant] = descendant.Texture
								end

								descendant.Texture = ""
							end)
						else
							v416(descendant)
						end
					end

					if os.clock() - now > 0.004 then
						task.wait()
						now = os.clock()
					end
				end
			end
		end

		local Terrain = workspace:FindFirstChildOfClass("Terrain")

		if Terrain then
			pcall(function()
				Terrain.WaterWaveSize = 0
				Terrain.WaterWaveSpeed = 0
				Terrain.WaterReflectance = 0
				Terrain.WaterTransparency = 1
				Terrain.Decoration = false

				local Clouds = Terrain:FindFirstChildOfClass("Clouds")

				if Clouds then
					Clouds.Enabled = false
				end
			end)
		end

		pcall(function()
			local Shared = ReplicatedStorage.Shared
			local Preferences = Shared:FindFirstChild("Preferences")

			if Preferences then
				local module = require(Preferences)

				module.Set("HideOtherPets", true)
				module.Set("DisableVideos", true)
			else
				local SettingsCmds = require(Shared.SettingsCmds)

				SettingsCmds.Write("HideOtherPets", true)
				SettingsCmds.Write("DisableVideos", true)
			end
		end)
		v396()
		v401()
		v406()
		v417()
		u421 = false
	end
	t15.revert = function()
		for _, v in ipairs(t16) do
			pcall(function()
				v:Disconnect()
			end)
		end

		table.clear(t16)
		u393 = false

		local snapshot = t15.snapshot
		local Lighting = game:GetService("Lighting")

		if snapshot then
			pcall(function()
				settings().Rendering.QualityLevel = snapshot.quality or Enum.QualityLevel.Automatic
			end)
			pcall(function()
				settings().Physics.PhysicsEnvironmentalThrottle = snapshot.throttle
			end)
			pcall(function()
				Lighting.Technology = snapshot.technology
				Lighting.GlobalShadows = snapshot.shadows
				Lighting.FogEnd = snapshot.fogEnd
				Lighting.Brightness = snapshot.brightness
				Lighting.Ambient = snapshot.ambient
				Lighting.OutdoorAmbient = snapshot.outdoorAmbient
			end)

			local Terrain = workspace:FindFirstChildOfClass("Terrain")

			if Terrain and snapshot.terrain then
				for k, v in pairs(snapshot.terrain) do
					pcall(function()
						Terrain[k] = v
					end)
				end

				if snapshot.cloudsEnabled ~= nil then
					pcall(function()
						local Clouds = Terrain:FindFirstChildOfClass("Clouds")

						if Clouds then
							Clouds.Enabled = snapshot.cloudsEnabled
						end
					end)
				end
			end

			if snapshot.prefs then
				pcall(function()
					local Preferences = require(ReplicatedStorage.Shared.Preferences)

					for k, pref in pairs(snapshot.prefs) do
						Preferences.Set(k, pref)
					end
				end)
			end
		end

		local n10 = 0

		for k, part in pairs(t15.parts) do
			if k.Parent then
				pcall(function()
					k.Material = part[1]
					k.CastShadow = part[2]

					if part[3] ~= nil and k:IsA("MeshPart") then
						k.RenderFidelity = part[3]
					end
				end)
			end

			n10 += 1

			if n10 % 400 == 0 then
				task.wait()
			end
		end

		for k, decal in pairs(t15.decals) do
			if k.Parent then
				pcall(function()
					k.Texture = decal
				end)
			end
		end

		for k in pairs(t15.effects) do
			if k.Parent then
				pcall(function()
					k.Enabled = true
				end)
			end
		end

		t15.parts = {}
		t15.decals = {}
		t15.effects = {}
		t15.snapshot = nil
	end
	genv.__SenaV4DecomBoostUndo = t15

	local u456 = false

	local function v457(p84)
		if not p84 or not p84:IsA("Model") then
			return
		end

		local match = p84.Name:match("^(%d+)_")
		local v459 = match and tonumber(match)

		if not v459 or v459 == LocalPlayer.UserId then
			return
		end

		for _, descendant in ipairs(p84:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Transparency = 1
				descendant.CanCollide = false
			elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
				descendant.Transparency = 1
			elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
				descendant.Enabled = false
			elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
				descendant.Enabled = false
			end
		end
	end
	local function v462()
		if senaV4Config._fpsEggsReady then
			return true
		end

		local u463 = false
		local ok, result = pcall(function()
			local v466 = require(game:GetService("ReplicatedStorage").Shared.Eggs.PlacedEggRenderer).GetRenderFolder()

			if not v466 then
				return
			end

			local children = v466:GetChildren()

			for _, child in ipairs(children) do
				v457(child)
			end

			v466.ChildAdded:Connect(function(child)
				task.defer(v457, child)
			end)
			u463 = true
		end)

		if not ok then
			warn("[FPSBoost] Gagal hide egg pemain lain:", result)

			return false
		end

		return u463
	end
	local function v470(p85)
		if not p85 then
			return
		end

		pcall(function()
			p85.Parent = nil
		end)
	end
	local function v471()
		if senaV4Config._fpsPetsReady then
			return true
		end

		local IsOn
		local ok, result = pcall(function()
			local Shared = game:GetService("ReplicatedStorage").Shared
			local Preferences = Shared:FindFirstChild("Preferences")

			if Preferences then
				local module = require(Preferences)

				module.Set("HideOtherPets", true)
				IsOn = module.IsOn
			else
				local SettingsCmds = require(Shared.SettingsCmds)

				SettingsCmds.Write("HideOtherPets", true)
				IsOn = SettingsCmds.Allows
			end
		end)
		local v479 = false

		if ok and IsOn then
			local ok2, result2 = pcall(IsOn, "HideOtherPets")

			v479 = ok2 and result2 == true
		end

		if ok then
			if v479 then
				local u482 = false
				local ok2, result2 = pcall(function()
					local ClientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets") or workspace:WaitForChild("ClientRenderedAssets", 10)

					if not ClientRenderedAssets then
						return
					end

					local children = ClientRenderedAssets:GetChildren()

					for _, child in ipairs(children) do
						v470(child)
					end

					ClientRenderedAssets.ChildAdded:Connect(function(child)
						task.defer(v470, child)
					end)
					u482 = true
				end)

				if not ok2 then
					warn("[FPSBoost] Gagal hide pet (manual):", result2)

					return false
				end

				return u482
			end
		end

		warn("[FPSBoost] Gagal set HideOtherPets bawaan game:", result or "setting belum aktif")

		return false
	end
	local function v489()
		if type(genv.__SenaV4SetCapFps) == "function" then
			pcall(genv.__SenaV4SetCapFps, 240)
		end

		pcall(function()
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		end)

		local function v490()
			UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
		end

		pcall(v490)
		pcall(function()
			require(game:GetService("ReplicatedStorage").Client.LightingsController):SetModifier("FPSBoost", function(p86)
				local v491 = table.clone(p86)

				v491.Bloom = nil
				v491.ColorCorrection = nil
				v491.SunRays = nil
				v491.DepthOfField = nil
				v491.Blur = nil
				v491.Clouds = nil
				v491.Atmosphere = nil
				v491.ShadowSoftness = 1

				return v491
			end, 100, 0)
		end)
		pcall(function()
			local Lighting = game:GetService("Lighting")

			Lighting.GlobalShadows = false
			Lighting.Technology = Enum.Technology.Compatibility
			Lighting.FogEnd = 9e9
			Lighting.Brightness = 2
		end)
		pcall(function()
			local Terrain = workspace:FindFirstChildOfClass("Terrain")

			if Terrain then
				Terrain.WaterWaveSize = 0
				Terrain.WaterWaveSpeed = 0
				Terrain.WaterReflectance = 0
				Terrain.WaterTransparency = 1
				Terrain.Decoration = false
			end
		end)
		pcall(function()
			local __DEBRIS = workspace:FindFirstChild("__DEBRIS")

			if __DEBRIS then
				for _, child in ipairs(__DEBRIS:GetChildren()) do
					if child.Name == "PlayerTrap" then
						pcall(function()
							child:Destroy()
						end)
					end
				end
			end
		end)
	end

	local color3 = Color3.fromRGB(120, 120, 120)

	local function v498(p87)
		if not p87 or not p87:IsA("BasePart") then
			return
		end

		p87.Material = Enum.Material.SmoothPlastic
		p87.Color = color3
		p87.CastShadow = false
	end
	local function v499(p88)
		if p88:IsA("ParticleEmitter") then
			p88.Enabled = false
			p88.Rate = 0
			pcall(function()
				p88:Clear()
			end)
		elseif p88:IsA("Trail") or p88:IsA("Beam") or p88:IsA("Smoke") or p88:IsA("Fire") or p88:IsA("Sparkles") or p88:IsA("PostEffect") or p88:IsA("Light") or p88:IsA("Highlight") or p88:IsA("Clouds") then
			p88.Enabled = false
		elseif p88:IsA("Atmosphere") then
			p88.Density = 0
			p88.Haze = 0
			p88.Glare = 0
		elseif p88:IsA("Explosion") then
			pcall(function()
				p88.Visible = false
			end)
		end
	end
	local function v500()
		if senaV4Config._fpsWorldReady then
			return true
		end

		local u501 = false
		local t20 = {}
		local ok, result = pcall(function()
			local function v505(p89)
				if v412(p89) then
					return
				end

				v498(p89)
				v499(p89)
			end

			local t21 = {
				workspace,
				game:GetService("Lighting")
			}

			for _, v in ipairs(t21) do
				table.insert(t20, v.DescendantAdded:Connect(function(descendant)
					task.defer(v505, descendant)
				end))
			end

			local t22 = {}

			for _, v in ipairs(t21) do
				for _, child in ipairs(v:GetChildren()) do
					table.insert(t22, child)
				end
			end

			local n11 = 0

			while #t22 > 0 do
				local v515 = table.remove(t22)

				v505(v515)

				for _, child in ipairs(v515:GetChildren()) do
					table.insert(t22, child)
				end

				n11 += 1

				if n11 >= 250 and #t22 > 0 then
					n11 = 0
					RunService.Heartbeat:Wait()
				end
			end

			u501 = true
		end)

		if ok then
			return u501
		end

		for _, v in ipairs(t20) do
			v:Disconnect()
		end

		warn("[FPSBoost] Gagal flatten material workspace:", result)

		return false
	end
	local function v520()
		if senaV4Config._fpsAreasReady then
			return true
		end

		local v521 = v14()
		local Areas = v521 and v521:FindFirstChild("Areas")
		local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
		local Build = v521 and v521:FindFirstChild("Build")

		if not GuardAreas or not Build then
			return false
		end

		for _, child in ipairs(GuardAreas:GetChildren()) do
			local RequiredSpeedSign = child:FindFirstChild("RequiredSpeedSign")

			if RequiredSpeedSign then
				pcall(function()
					RequiredSpeedSign:Destroy()
				end)
			end
		end

		local MainMap = Build:FindFirstChild("MainMap")
		local Bases = MainMap and MainMap:FindFirstChild("Bases")

		local function v530(p90)
			if Bases and p90:IsDescendantOf(Bases) then
				return p90.Size.Y <= 5 and not string.find(string.upper(p90.Name), "WALL", 1, true)
			end

			local Parent = p90

			while true do
				if not Parent or Parent == Build then
					return false
				end

				if not string.find(string.upper(Parent.Name), "BOTTOM", 1, true) then
					Parent = Parent.Parent

					continue
				end

				break
			end

			return true
		end

		local t23 = {
			"ENCHANTED",
			"FUSEBIOME",
			"WISP",
			"BUTTERFLY",
			"MARKERS",
			"PORTAL",
			"TRIGGER"
		}

		local function v533(p91)
			if p91:FindFirstChildOfClass("TouchTransmitter") or p91:FindFirstChildWhichIsA("ProximityPrompt", true) then
				return true
			end

			local Parent = p91

			while true do
				if not Parent then
					return false
				end

				if Parent == Build then
					return false
				end

				local v535 = string.upper(Parent.Name)

				for _, v in ipairs(t23) do
					if string.find(v535, v, 1, true) then
						return true
					end
				end

				Parent = Parent.Parent
			end
		end
		local function v538(p92)
			if not p92:IsA("BasePart") then
				return
			end

			if v533(p92) then
				return
			end

			if v530(p92) then
				v498(p92)
			else
				pcall(function()
					p92:Destroy()
				end)
			end
		end

		local connection = Build.DescendantAdded:Connect(function(descendant)
			task.defer(v538, descendant)
		end)
		local n12 = 0
		local fpsAreaDeleted = 0

		for _, descendant in ipairs(Build:GetDescendants()) do
			local v544 = descendant.Parent ~= nil

			v538(descendant)

			if v544 and descendant.Parent == nil then
				fpsAreaDeleted += 1
			end

			n12 += 1

			if n12 >= 250 then
				n12 = 0
				RunService.Heartbeat:Wait()
			end
		end

		senaV4Config._fpsAreaListener = connection
		senaV4Config._fpsAreaDeleted = fpsAreaDeleted
		senaV4Config._fpsAreasReady = true

		return true
	end
	local function v545()
		if senaV4Config._fpsPlotsReady then
			return true
		end

		local u546 = false
		local ok, result = pcall(function()
			local PlotState2 = require(game:GetService("ReplicatedStorage").Client.PlotState)

			if PlotState2.GetMySlot() == nil then
				warn("[FPSBoost] Slot plot kita belum ke-resolve, skip delete plot dulu (biar aman).")

				return
			end

			local function v550(p93)
				local v551 = PlotState2.GetMySlot()

				return v551 ~= nil and p93.Name == tostring(v551)
			end

			local Plots = PlotState2.GetPlotsFolder() or workspace:WaitForChild("Plots", 10)

			if not Plots then
				warn("[FPSBoost] workspace.Plots gak ketemu sama sekali.")

				return
			end

			local children = Plots:GetChildren()
			local n13 = 0

			for _, child in ipairs(children) do
				if not v550(child) and pcall(function()
					child:Destroy()
				end) then
					n13 += 1
				end
			end

			Plots.ChildAdded:Connect(function(child)
				task.defer(function()
					if child.Parent then
						if not v550(child) then
							pcall(function()
								child:Destroy()
							end)
						end
					end
				end)
			end)
			u546 = true
		end)

		if ok then
			return u546
		end

		warn("[FPSBoost] Gagal delete plot pemain lain:", result)

		return false
	end
	local function v557()
		if senaV4Config._fpsTreadmillsReady then
			return true
		end

		local u558 = false
		local ok, result = pcall(function()
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local PlotState2 = require(ReplicatedStorage2.Client.PlotState)
			local v563
			local Modules = ReplicatedStorage2.Client:FindFirstChild("Modules") or ReplicatedStorage2.Client:WaitForChild("Modules", 10)
			local RuntimeInstanceRegistry = Modules and (Modules:FindFirstChild("RuntimeInstanceRegistry") or Modules:WaitForChild("RuntimeInstanceRegistry", 10))

			if RuntimeInstanceRegistry then
				local ok, result = pcall(require, RuntimeInstanceRegistry)

				if ok then
					v563 = result
				end
			end

			local __ClientTreadmillRenders = workspace:FindFirstChild("__ClientTreadmillRenders") or workspace:WaitForChild("__ClientTreadmillRenders", 10)

			if not __ClientTreadmillRenders then
				return
			end

			local function v569()
				local v570 = PlotState2.GetMySlot()

				if v570 == nil then
					return nil
				end

				local v571 = __ClientTreadmillRenders:FindFirstChild("TreadmillRender_" .. tostring(v570))

				if v571 then
					return v571
				end

				local Peek = v563 and (v563.Peek or v563.Get)

				if not Peek then
					return nil
				end

				local ok, result = pcall(Peek, "TreadmillPlotRender", tostring(v570))

				if ok then
					return result
				end

				return nil
			end
			local function v575(p94)
				local v576 = v569()

				if v576 and p94 == v576 then
					return true
				end

				local ok, result = pcall(function()
					return p94:GetPivot().Position
				end)

				if not ok then
					return true
				end

				local ok2, result2 = pcall(PlotState2.IsWorldPositionWithinLocalPlotBounds, result)
				local v581 = ok2 and result2

				return v581
			end

			local children = __ClientTreadmillRenders:GetChildren()
			local n14 = 0

			for _, child in ipairs(children) do
				if child:IsA("Model") and not v575(child) and pcall(function()
					child:Destroy()
				end) then
					n14 += 1
				end
			end

			__ClientTreadmillRenders.ChildAdded:Connect(function(child)
				task.defer(function()
					if child.Parent and child:IsA("Model") and not v575(child) then
						pcall(function()
							child:Destroy()
						end)
					end
				end)
			end)
			u558 = true
		end)

		if ok then
			return u558
		end

		warn("[FPSBoost] Gagal delete treadmill pemain lain:", result)

		return false
	end

	v391 = function()
		if u456 or senaV4Config._fpsBoostApplying then
			return
		end

		senaV4Config._fpsBoostApplying = true

		local ok, result = pcall(function()
			v489()
			senaV4Config._fpsPlotsReady = v545() == true
			senaV4Config._fpsTreadmillsReady = v557() == true
			senaV4Config._fpsAreasReady = v520() == true
			senaV4Config._fpsWorldReady = v500() == true
			senaV4Config._fpsPetsReady = v471() == true
			senaV4Config._fpsEggsReady = v462() == true
			u456 = senaV4Config._fpsEggsReady and senaV4Config._fpsPetsReady and senaV4Config._fpsWorldReady and senaV4Config._fpsPlotsReady and senaV4Config._fpsTreadmillsReady and senaV4Config._fpsAreasReady
		end)

		senaV4Config._fpsBoostApplying = nil

		if not ok then
			warn("[FPSBoost] Gagal menerapkan FPS Boost:", result)
		end
	end
end

local function v588(p95, p96, p97)
	local u589 = true

	pcall(function()
		local filterDescendantsInstances = { p97 }
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		local v592 = p95

		for i = 1, 8 do
			raycastParams.FilterDescendantsInstances = filterDescendantsInstances

			local v594 = p96 - v592

			if v594.Magnitude < 1 then
				break
			end

			local hit = workspace:Raycast(v592, v594, raycastParams)

			if not hit then
				break
			end

			if not hit.Instance.CanCollide then
				table.insert(filterDescendantsInstances, hit.Instance)
				v592 = hit.Position + v594.Unit * 0.1

				continue
			end

			u589 = false

			break
		end
	end)

	return u589
end

local t24 = {}
local ProximityPromptService = game:GetService("ProximityPromptService")
local t25 = {
	TITLES = {
		auto_steal = "Auto Steal",
		mech_boss = "Mech Boss",
		butterfly = "Butterfly Bloom",
		auto_place = "Auto Place",
		treadmill = "Treadmill"
	},
	ORDER = {
		"auto_steal",
		"mech_boss",
		"butterfly",
		"auto_place",
		"treadmill"
	}
}

do
	local function v599(p98)
		if p98 == "auto_steal" then
			local __SenaV4StealWantsCharacter = genv.__SenaV4StealWantsCharacter

			return __SenaV4StealWantsCharacter ~= nil and __SenaV4StealWantsCharacter() == true
		end

		if p98 ~= "mech_boss" then
			if p98 == "butterfly" then
				local __SenaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime

				return __SenaV4ButterflyRuntime ~= nil and __SenaV4ButterflyRuntime.wantsCharacter == true
			end

			if p98 == "auto_place" then
				return senaV4Config.IsPlacing == true
			end

			return false
		end

		if LocalPlayer:GetAttribute("InScrambleArena") == true then
			return true
		end

		if senaV4Config.ScrambleBossAuto ~= true then
			return false
		end

		local ScrambleArena = workspace:FindFirstChild("ScrambleArena")
		local v603 = workspace:FindFirstChild("ScrambleArenaPortal") ~= nil

		if not v603 then
			v603 = ScrambleArena ~= nil

			if v603 then
				v603 = tostring(ScrambleArena:GetAttribute("Phase") or "") ~= ""
			end

			v603 = v603 and ScrambleArena:GetAttribute("Phase") ~= "Defeated"
		end

		return v603
	end
	local function v604(p99)
		if p99 == "auto_steal" then
			local __SenaV4EggRuntime = genv.__SenaV4EggRuntime

			return __SenaV4EggRuntime ~= nil and __SenaV4EggRuntime.enabled == true and (__SenaV4EggRuntime.running == true or __SenaV4EggRuntime.carry ~= nil and __SenaV4EggRuntime.carry.active == true)
		end

		if p99 == "mech_boss" then
			return LocalPlayer:GetAttribute("InScrambleArena") == true
		end

		if p99 ~= "butterfly" then
			if p99 == "auto_place" then
				return senaV4Config.IsPlacing == true
			end

			return false
		end

		local __SenaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime

		return __SenaV4ButterflyRuntime ~= nil and __SenaV4ButterflyRuntime.active == true
	end

	t25.blocker = function(p100)
		if p100 ~= "mech_boss" and LocalPlayer:GetAttribute("InScrambleArena") == true then
			return "mech_boss"
		end

		for _, v in ipairs(t25.ORDER) do
			if v == p100 then
				return nil
			end

			if v599(v) then
				return v
			end
		end

		return nil
	end
	t25.holder = function(p101)
		for _, v in ipairs(t25.ORDER) do
			if v ~= p101 and v ~= "treadmill" then
				if v604(v) then
					return v
				end
			end
		end

		return nil
	end
end

local v611, v612, v613, v614, v615

do
	local function v616()
		local t26 = {}

		t26.__index = t26

		local t27 = {
			auto_place = true,
			auto_fuse = true,
			equip_best = true
		}
		local t28 = {
			auto_steal = 100,
			auto_hatch = 80,
			auto_place = 70,
			auto_fuse = 50,
			equip_best = 40,
			rewards = 20
		}

		local function v620(p102)
			local t29 = {}

			for k, v in pairs(p102) do
				t29[k] = v
			end

			return t29
		end

		t26.new = function()
			local obj = setmetatable({}, t26)

			obj.destroyed = false
			obj.active = nil
			obj.background = nil
			obj.reservations = {}
			obj.listeners = {}
			obj.backgroundListeners = {}
			obj.serial = 0

			return obj
		end
		t26._snapshot = function(p103)
			local active = p103.active

			return {
				busy = active ~= nil,
				operation = active and active.owner or nil,
				priority = active and active.priority or 0,
				reservedCount = active and #active.uids or 0,
				reservations = v620(p103.reservations)
			}
		end
		t26._emit = function(p104)
			local v626 = p104:_snapshot()

			for k in pairs(p104.listeners) do
				local ok, result = pcall(k, v626)

				if not ok then
					warn("[StealAnEgg] Coordinator listener failed:", result)
				end
			end
		end
		t26._emitBackground = function(p105)
			local background = p105.background
			local t30 = {
				busy = background ~= nil
			}
			local owner = background and background.owner

			t30.operation = owner or nil

			for k in pairs(p105.backgroundListeners) do
				local ok, result = pcall(k, t30)

				if not ok then
					warn("[StealAnEgg] Background coordinator listener failed:", result)
				end
			end
		end
		t26.subscribe = function(p106, p107)
			p106.listeners[p107] = true
			pcall(p107, p106:_snapshot())

			local function v636()
				p106.listeners[p107] = nil
			end

			return v636
		end
		t26.subscribeBackground = function(p108, p109)
			p108.backgroundListeners[p109] = true
			pcall(p109, {
				busy = p108.background ~= nil,
				operation = p108.background and p108.background.owner or nil
			})

			local function v637()
				p108.backgroundListeners[p109] = nil
			end

			return v637
		end
		t26.getSnapshot = function(p110)
			return p110:_snapshot()
		end
		t26.isBackgroundBusy = function(p111)
			return p111.background ~= nil
		end
		t26.isReserved = function(p112, p113, p114)
			local v638 = p112.reservations[p113]

			return v638 ~= nil and v638 ~= p114
		end
		t26.tryAcquire = function(p115, p116, p117, p118)
			if p115.destroyed then
				return nil, "Coordinator destroyed"
			end

			if type(p116) ~= "string" or p116 == "" then
				return nil, "Invalid operation owner"
			end

			if p115.active then
				return nil, "Busy: " .. p115.active.owner
			end

			if p115.background and t27[p116] then
				return nil, "Busy: background " .. p115.background.owner
			end

			local t31 = {}
			local t32 = {}
			local ipairs_ = ipairs
			local v642 = type(p117) == "table" and p117 or {}

			for _, v in ipairs_(v642) do
				if type(v) == "string" and v ~= "" and not t32[v] then
					if p115:isReserved(v, p116) then
						return nil, "UID reserved by " .. tostring(p115.reservations[v])
					end

					t32[v] = true
					table.insert(t31, v)
				end
			end

			p115.serial += 1

			local active = {
				id = p115.serial,
				lane = "foreground",
				owner = p116,
				priority = tonumber(p118) or t28[p116] or 0,
				uids = t31,
				released = false
			}

			p115.active = active

			for _, v in ipairs(t31) do
				p115.reservations[v] = p116
			end

			p115:_emit()

			return active
		end
		t26.tryAcquireBackground = function(p119, p120, p121)
			if p119.destroyed then
				return nil, "Coordinator destroyed"
			end

			if type(p120) ~= "string" or p120 == "" then
				return nil, "Invalid operation owner"
			end

			if p119.background then
				return nil, "Background busy: " .. p119.background.owner
			end

			if p119.active and t27[p119.active.owner] then
				return nil, "Foreground tool busy: " .. p119.active.owner
			end

			local t33 = {}
			local t34 = {}
			local ipairs_ = ipairs
			local v651 = type(p121) == "table" and p121 or {}

			for _, v in ipairs_(v651) do
				if type(v) == "string" and v ~= "" and not t34[v] then
					if p119:isReserved(v, p120) then
						return nil, "UID reserved by " .. tostring(p119.reservations[v])
					end

					t34[v] = true
					table.insert(t33, v)
				end
			end

			p119.serial += 1

			local background = {
				id = p119.serial,
				lane = "background",
				owner = p120,
				priority = 0,
				uids = t33,
				released = false
			}

			p119.background = background

			for _, v in ipairs(t33) do
				p119.reservations[v] = p120
			end

			p119:_emitBackground()

			return background
		end
		t26.release = function(p122, p123)
			if type(p123) ~= "table" or p123.released then
				return false
			end

			p123.released = true

			local ipairs_ = ipairs
			local uids = p123.uids or {}

			for _, uid in ipairs_(uids) do
				if p122.reservations[uid] == p123.owner then
					p122.reservations[uid] = nil
				end
			end

			local v661 = p122.active == p123

			if v661 then
				p122.active = nil
			elseif p122.background == p123 then
				p122.background = nil
				p122:_emitBackground()
			end

			if v661 then
				p122:_emit()
			end

			return true
		end
		t26.destroy = function(p124)
			if p124.destroyed then
				return
			end

			p124.destroyed = true

			if p124.active then
				p124:release(p124.active)
			end

			if p124.background then
				p124:release(p124.background)
			end

			table.clear(p124.reservations)
			table.clear(p124.listeners)
			table.clear(p124.backgroundListeners)
		end

		return t26
	end

	local v662 = v616()

	local function v663()
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local Areas = require(ReplicatedStorage2.Data.Areas)
		local Assets = require(ReplicatedStorage2.Data.Assets)
		local Guards = require(ReplicatedStorage2.Data.Guards)
		local Mutations = require(ReplicatedStorage2.Shared.Modules.Mutations)
		local t35 = {
			Common = 1,
			Uncommon = 2,
			Rare = 3,
			Epic = 4,
			Legendary = 5,
			Mythic = 6,
			Cosmic = 7,
			Secret = 8,
			Eternal = 9,
			Divine = 10
		}

		local function v670(p125)
			local t36 = {}
			local t37 = {}

			for _, v in ipairs(p125) do
				if type(v) == "string" and v ~= "" and not t36[v] then
					t36[v] = true
					table.insert(t37, v)
				end
			end

			table.sort(t37)

			return t37
		end

		return {
			rarityRank = function(p126)
				return t35[p126] or 0
			end,
			getRarities = function()
				local t38 = {}

				for k in pairs(Assets.ByRarity) do
					table.insert(t38, k)
				end

				table.sort(t38, function(p127, p128)
					local v677 = t35[p127] or 99
					local v678 = t35[p128] or 99

					if v677 == v678 then
						return tostring(p127) < tostring(p128)
					end

					return v677 < v678
				end)

				return t38
			end,
			getNames = function()
				local t39 = {}

				for _, v in pairs(Assets.Directory) do
					table.insert(t39, v.DisplayName or v._id)
				end

				return v670(t39)
			end,
			getAreas = function()
				local t40 = {}

				for k, v in pairs(Areas.Directory) do
					if type(k) == "string" and type(v) == "table" and type(v.DropTable) == "table" then
						table.insert(t40, k)
					end
				end

				table.sort(t40, function(p129, p130)
					local v685 = Guards.Directory[p129]
					local v686 = Guards.Directory[p130]
					local WalkSpeed = v685 and v685.WalkSpeed or math.huge
					local WalkSpeed2 = v686 and v686.WalkSpeed

					WalkSpeed2 = WalkSpeed2 or math.huge

					if WalkSpeed == WalkSpeed2 then
						return p129 < p130
					end

					return WalkSpeed < WalkSpeed2
				end)

				return t40
			end,
			getMutations = function()
				local t41 = {}
				local v690 = Mutations.Ids()
				local pairs_ = pairs
				local v692 = type(v690) == "table" and v690 or {}

				for k in pairs_(v692) do
					if type(k) == "string" and k ~= Mutations.NO_MUTATION then
						local ok, result = pcall(Mutations.LabelOf, k)

						table.insert(t41, ok and type(result) == "string" and result ~= "" and result or k)
					end
				end

				return v670(t41)
			end,
			resolveMutationId = function(p131)
				if type(p131) ~= "string" then
					return nil
				end

				if Mutations.IdSet[p131] then
					return p131
				end

				for k in pairs(Mutations.Ids()) do
					if k ~= Mutations.NO_MUTATION and Mutations.LabelOf(k) == p131 then
						return k
					end
				end

				return nil
			end,
			resolve = function(p132)
				local v697 = p132 and Assets.Directory[p132.AssetCategory]
				local Rarity = v697 and v697.Rarity
				local DisplayName = Rarity and (Rarity.DisplayName or Rarity._id) or "Unknown"

				return {
					name = v697 and (v697.DisplayName or v697._id) or p132 and p132.AssetCategory or "Unknown",
					category = p132 and p132.AssetCategory or "Unknown",
					rarity = DisplayName,
					rarityRank = t35[DisplayName] or 0,
					rarityColor = Rarity and Rarity.Color or nil,
					icon = v697 and type(v697.Icon) == "string" and v697.Icon or nil
				}
			end
		}
	end

	v611 = v663()

	local function v700(p133)
		if not p133 then
			return nil
		end

		for _, descendant in ipairs(p133:GetDescendants()) do
			if not descendant:IsA("ModuleScript") or not (descendant.Name == "Limits" and descendant.Parent) then
				continue
			end

			if not descendant.Parent:FindFirstChild("Surface") then
				continue
			end

			if descendant.Parent:FindFirstChild("Runtime") then
				return descendant
			end
		end

		return nil
	end

	local v703 = v700(LocalPlayer:FindFirstChildOfClass("PlayerScripts")) or v700(game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts"))

	local function v704()
		local Players2 = game:GetService("Players")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local RunService2 = game:GetService("RunService")
		local LocalPlayer2 = Players2.LocalPlayer
		local EggState2 = require(ReplicatedStorage2.Client.EggState)
		local Remotes = require(ReplicatedStorage2.Shared.Remotes)
		local EggWorld = Remotes.EggWorld
		local AreaEggs = require(ReplicatedStorage2.Shared.Types.AreaEggs)
		local AreaEggSlotIdentity = require(ReplicatedStorage2.Shared.Util.AreaEggSlotIdentity)
		local AreaEggResetWall3 = require(ReplicatedStorage2.Client.AreaEggResetWall)
		local SpeedPowerProjection = require(ReplicatedStorage2.Client.SpeedPowerProjection)
		local TreadmillUtil = require(ReplicatedStorage2.Shared.Util.TreadmillUtil)
		local EggRecords = require(ReplicatedStorage2.Shared.Util.EggRecords)
		local AssetEarnings = require(ReplicatedStorage2.Shared.Util.AssetEarnings)
		local Save = require(ReplicatedStorage2.Shared.Save)
		local PlotState2 = require(ReplicatedStorage2.Client.PlotState)

		local function v721()
			return genv.__SenaV4AdminBoost == true and 3000 or 1000
		end

		local t42 = {
			Divine = true,
			Eternal = true
		}
		local t43 = {
			"LastObservedSample",
			"LastSample",
			"LastGoodSample",
			"LastGameplayTrustedSample",
			"LastValidatedSample",
			"LastValidatedGroundedSample",
			"LastConfirmedGroundSample",
			"CandidateGroundedSample"
		}
		local vector32 = Vector3.new(544.76, 71.5, -416.48)
		local t44 = {
			-364.3,
			-367.21,
			-371.12,
			-375.65
		}

		cFrameNew(599.8, 113.5, -325)
		Vector3.new(599.8, 70, -325)

		local cFrame = cFrameNew(616.749, 71.667, -395.585)
		local t45 = {
			Script = true,
			LocalScript = true,
			BillboardGui = true,
			Sound = true
		}
		local t46 = {}

		t46.__index = t46

		local Stats = game:GetService("Stats")

		local function v730(p134, p135)
			local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart then
				pcall(function()
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				end)
			end

			local n15 = 0

			pcall(function()
				n15 = Stats.Network.ServerStats.Ping:GetValue()
			end)
			task.wait(math.max(0.3, n15 * 2.5 / 1000))

			local t47 = {
				Uid = p134
			}

			if p135 ~= nil then
				t47.FirstAreaSlotKey = p135
			end

			local response, v735 = EggWorld.AskFieldEggCarry:InvokeServer(t47)
			local v736 = response == true
			local v737 = typeof(v735) == "string" and v735 or nil

			return v736, v737
		end
		local function v738(p136, p137, p138)
			local connection = p136:Connect(p137)

			table.insert(p138, connection)

			return connection
		end
		local function v740(p139)
			for _, v in ipairs(p139) do
				pcall(v.Disconnect, v)
			end

			table.clear(p139)
		end
		local function v743(p140, p141)
			local ipairs_ = ipairs
			local v745 = p140 or {}

			for _, v in ipairs_(v745) do
				if v == p141 then
					return true
				end
			end

			return false
		end

		local v748

		local function v749(p142, p143)
			if type(p142) ~= "function" or type(debug) ~= "table" or type(debug.getconstants) ~= "function" then
				return false
			end

			local ok, result = pcall(debug.getconstants, p142)

			if not ok or type(result) ~= "table" then
				return false
			end

			local t48 = {}

			for _, v in ipairs(result) do
				if type(v) == "string" then
					t48[v] = true
				end
			end

			for _, v in ipairs(p143) do
				if not t48[v] then
					return false
				end
			end

			return true
		end
		local function v757(p144)
			if type(p144) ~= "function" or type(debug) ~= "table" or type(debug.info) ~= "function" then
				return ""
			end

			local ok, result = pcall(debug.info, p144, "s")

			return ok and tostring(result) or ""
		end
		local function v760(p145)
			local HumanoidRootPart = p145 and p145:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart then
				HumanoidRootPart:SetAttribute("KillPartIgnore", true)
			end
		end
		local function v762(p146)
			local Humanoid = p146 and p146:FindFirstChildOfClass("Humanoid")

			if not Humanoid or not Humanoid.Parent then
				return false
			end

			pcall(function()
				Humanoid.BreakJointsOnDeath = false
			end)

			local clone = Humanoid:Clone()

			Humanoid:Destroy()
			clone.Parent = p146

			local CurrentCamera = workspace.CurrentCamera

			if CurrentCamera then
				CurrentCamera.CameraSubject = clone
			end

			local Animate = p146:FindFirstChild("Animate")

			if Animate then
				local clone2 = Animate:Clone()

				Animate:Destroy()
				clone2.Parent = p146
			end

			pcall(function()
				clone:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				clone:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				clone:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				clone:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
				clone:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
				clone:ChangeState(Enum.HumanoidStateType.Running)
			end)

			return true
		end
		local function v768(p147)
			if p147._healthPinner then
				pcall(p147._healthPinner.Disconnect, p147._healthPinner)
				p147._healthPinner = nil
			end

			if p147._healthChangedConnection then
				pcall(p147._healthChangedConnection.Disconnect, p147._healthChangedConnection)
				p147._healthChangedConnection = nil
			end
		end
		local function v769(p148, p149)
			v768(p148)

			local Humanoid = p149 and p149:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = p149 and p149:FindFirstChild("HumanoidRootPart")

			if not Humanoid then
				return false
			end

			local health = math.max(Humanoid.MaxHealth, 100)
			local u773 = false
			local n16 = 0

			local function v775()
				if u773 or p148.destroyed or LocalPlayer2.Character ~= p149 or not Humanoid.Parent then
					return
				end

				local now = os.clock()

				if now - n16 < 0.1 and Humanoid.Health > 0 and Humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
					return
				end

				n16 = now
				u773 = true
				pcall(function()
					Humanoid.BreakJointsOnDeath = false
					Humanoid.RequiresNeck = false
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

					if Humanoid.Health <= 0 then
						Humanoid.Health = health
					end

					if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
						Humanoid:ChangeState(Enum.HumanoidStateType.Running)
					end

					if HumanoidRootPart and HumanoidRootPart.Parent == p149 and HumanoidRootPart.Anchored then
						HumanoidRootPart.Anchored = false
					end
				end)
				u773 = false
			end

			v775()
			p148._healthChangedConnection = Humanoid.HealthChanged:Connect(function(health2)
				if health2 <= 0 or health2 < health then
					v775()
				end
			end)
			p148._healthPinner = RunService2.Heartbeat:Connect(v775)

			return true
		end
		local function v777(p150)
			local Humanoid = p150 and p150:FindFirstChildOfClass("Humanoid")

			if not Humanoid then
				return
			end

			pcall(function()
				Humanoid.BreakJointsOnDeath = false
				Humanoid.RequiresNeck = false
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			end)
		end
		local function v779(p151)
			local Humanoid = p151 and p151:FindFirstChildOfClass("Humanoid")

			if not Humanoid then
				return
			end

			pcall(function()
				if Humanoid.Health <= 0 then
					Humanoid.Health = math.max(Humanoid.MaxHealth, 1)
				end

				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
				Humanoid.BreakJointsOnDeath = true
				Humanoid.RequiresNeck = true
			end)
		end
		local function v781()
			return getgenv and getgenv() or _G
		end
		local function v782()
			if type(getconnections) ~= "function" or type(debug) ~= "table" or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
				return false
			end

			local ok, result = pcall(getconnections, LocalPlayer2.Idled)

			if not (ok and type(result) == "table") then
				return false
			end

			for _, v in ipairs(result) do
				local Function = v.Function

				if type(Function) == "function" and type(v.Disable) == "function" then
					local ok2, result2 = pcall(debug.info, Function, "s")
					local ok3, result3 = pcall(debug.getupvalue, Function, 1)

					if not ok2 or not (type(result2) == "string" and result2:sub(-27) == ".PlayerScripts.Game.AntiAFK" and ok3) then
						continue
					end

					if type(result3) == "number" then
						return (pcall(v.Disable, v))
					end
				end
			end

			return false
		end
		local function v792()
			local v793 = v781()
			local __SenaV4StealAnEggMovementSpoof = v793.__SenaV4StealAnEggMovementSpoof

			if type(__SenaV4StealAnEggMovementSpoof) ~= "table" or __SenaV4StealAnEggMovementSpoof.Version ~= 436 then
				if type(__SenaV4StealAnEggMovementSpoof) == "table" then
					__SenaV4StealAnEggMovementSpoof.Enabled = false
				end

				__SenaV4StealAnEggMovementSpoof = {
					Version = 436,
					Installed = false,
					Enabled = false,
					Mode = "StateBaseline",
					Humanoid = nil,
					RootPart = nil,
					WalkSpeed = 600
				}
				v793.__SenaV4StealAnEggMovementSpoof = __SenaV4StealAnEggMovementSpoof
			end

			return __SenaV4StealAnEggMovementSpoof
		end
		local function v795(p152, p153)
			local v796 = v792()

			if not v796 then
				return false
			end

			local Humanoid = p152 and p152:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = p152 and p152:FindFirstChild("HumanoidRootPart")

			v796.Humanoid = Humanoid
			v796.RootPart = HumanoidRootPart
			v796.WalkSpeed = math.clamp(tonumber(p153) or 600, 200, 1350)
			v796.Enabled = false

			return Humanoid ~= nil and HumanoidRootPart ~= nil
		end
		local function v799()
			local __SenaV4StealAnEggMovementSpoof = v781().__SenaV4StealAnEggMovementSpoof

			if type(__SenaV4StealAnEggMovementSpoof) == "table" then
				__SenaV4StealAnEggMovementSpoof.Enabled = false
				__SenaV4StealAnEggMovementSpoof.Humanoid = nil
				__SenaV4StealAnEggMovementSpoof.RootPart = nil
			end
		end
		local function v801(p154, p155, p156)
			local u802

			if type(getcallbackvalue) == "function" then
				if type(debug) == "table" and type(debug.getupvalue) == "function" then
					local Signal = ReplicatedStorage2:FindFirstChild("Packages") and ReplicatedStorage2.Packages:FindFirstChild("Signal")

					if Signal then
						local ok, result = pcall(require, Signal)

						if ok and type(result) == "table" and type(result.Invoked) == "function" then
							local ok2, result2 = pcall(result.Invoked, "ClientCharacter: GetDebugSnapshot")

							if ok2 and result2 then
								local ok3, result3 = pcall(getcallbackvalue, result2, "OnInvoke")

								if ok3 and type(result3) == "function" then
									local ok4, result4 = pcall(debug.getinfo, result3)

									if ok4 then
										local function v812(p157, p158, p159)
											if u802 or type(p157) ~= "table" or p158 > 3 or p159[p157] then
												return
											end

											p159[p157] = true

											if rawget(p157, "Player") == p154 and rawget(p157, "Character") == p154.Character and rawget(p157, "Humanoid") == p155 and rawget(p157, "RootPart") == p156 and type(rawget(p157, "SampleHistory")) == "table" and type(rawget(p157, "Evidence")) == "table" then
												u802 = p157

												return
											end

											local n17 = 0

											for _, v in pairs(p157) do
												n17 += 1

												if n17 > 128 then
													break
												end

												if type(v) == "table" then
													v812(v, p158 + 1, p159)
												end
											end
										end

										local n18 = 1
										local nups = result4.nups or 0

										for i = n18, nups do
											local ok5, result5 = pcall(debug.getupvalue, result3, i)

											if not ok5 or type(result5) ~= "table" then
												continue
											end

											v812(result5, 0, {})

											if u802 then
												break
											end
										end
									end
								end
							end
						end
					end
				end
			end

			if not u802 and type(getgc) == "function" then
				local ok, result = pcall(getgc, true)

				if ok and type(result) == "table" then
					for _, v in ipairs(result) do
						if type(v) == "table" and rawget(v, "Player") == p154 and rawget(v, "Character") == p154.Character and rawget(v, "Humanoid") == p155 and rawget(v, "RootPart") == p156 and type(rawget(v, "SampleHistory")) == "table" and type(rawget(v, "Evidence")) == "table" then
							u802 = v

							break
						end
					end
				end
			end

			return u802
		end

		local t49 = {
			busy = false,
			nextAt = 0,
			misses = 0,
			found = nil
		}

		local function v826(p160, p161, p162)
			local found = t49.found

			if type(found) == "table" and rawget(found, "Player") == p160 and rawget(found, "Character") == p160.Character and rawget(found, "Humanoid") == p161 and rawget(found, "RootPart") == p162 then
				return found
			end

			if t49.busy or os.clock() < t49.nextAt then
				return nil
			end

			t49.busy = true
			task.spawn(function()
				task.wait()

				local ok, result = pcall(v801, p160, p161, p162)
				local v830 = ok and result or nil

				t49.found = v830
				t49.misses = v830 and 0 or t49.misses + 1
				t49.nextAt = os.clock() + (v830 and 0.2 or t49.misses >= 5 and 10 or 1)
				t49.busy = false
			end)

			return nil
		end
		local function v831(p163, p164, p165)
			if type(p163) ~= "table" then
				return false
			end

			local value = rawget(p163, "RootPart")
			local CFrame_2 = value and value.Parent and value.CFrame

			CFrame_2 = CFrame_2 or nil

			local Position = CFrame_2 and CFrame_2.Position or nil
			local vector33 = typeof(p165) == "Vector3" and p165 or Vector3.zero

			local function v836(p166)
				if type(p166) == "table" then
					rawset(p166, "WalkSpeed", p164)

					if CFrame_2 then
						rawset(p166, "CFrame", CFrame_2)
						rawset(p166, "Position", Position)
						rawset(p166, "LinearVelocity", vector33)
						rawset(p166, "AngularVelocity", Vector3.zero)
					end
				end
			end

			for _, v in ipairs(t43) do
				v836(rawget(p163, v))
			end

			local pairs_ = pairs
			local v840 = rawget(p163, "SampleHistory") or {}

			for _, v in pairs_(v840) do
				v836(v)
			end

			local pairs_2 = pairs
			local v844 = rawget(p163, "SafeGroundCheckpoints") or {}

			for _, v in pairs_2(v844) do
				v836(v)
			end

			local value2 = rawget(p163, "Evidence")

			if type(value2) == "table" then
				value2.Speed = 0
				value2.Teleport = 0
				value2.Flight = 0
			end

			local value3 = rawget(p163, "ImpulseContext")

			if type(value3) == "table" then
				local maxHorizontalSpeed = math.max(tonumber(value3.MaxHorizontalSpeed) or 0, p164)
				local v850 = math.max((tonumber(value3.ExpiresAt) or 0) - (tonumber(value3.StartedAt) or 0), 0.15)

				value3.MaxHorizontalSpeed = maxHorizontalSpeed

				if Position then
					value3.OriginPosition = Position
				end

				value3.MaxHorizontalDistance = math.max(tonumber(value3.MaxHorizontalDistance) or 0, maxHorizontalSpeed * v850 + 48)
				v836(value3.PreMovementSafeSample)
			end

			if rawget(p163, "CorrectionContext") == nil then
				rawset(p163, "FirstSuspiciousAt", nil)

				if rawget(p163, "ThreatLevel") == "Observing" then
					rawset(p163, "ThreatLevel", "Trusted")
				end
			end

			return true
		end
		local function v851()
			local v852 = v781()
			local __SenaV4StealAnEggIntegritySpoof = v852.__SenaV4StealAnEggIntegritySpoof

			if type(__SenaV4StealAnEggIntegritySpoof) ~= "table" then
				__SenaV4StealAnEggIntegritySpoof = {}
				v852.__SenaV4StealAnEggIntegritySpoof = __SenaV4StealAnEggIntegritySpoof
			end

			return __SenaV4StealAnEggIntegritySpoof
		end
		local function v854(p167, p168, p169)
			return type(p167) == "table" and rawget(p167, "Player") == LocalPlayer2 and rawget(p167, "Character") == LocalPlayer2.Character and rawget(p167, "Humanoid") == p168 and rawget(p167, "RootPart") == p169
		end
		local function v855(p170, p171, p172)
			return v854(p170, p171, p172)
		end
		local function v856(p173, p174, p175)
			local v857 = v851()
			local State = v857.State

			if not v854(State, p173, p174) then
				local now = os.clock()

				if now < (v857.NextSearchAt or 0) then
					return false
				end

				v857.NextSearchAt = now + 0.2
				State = v826(LocalPlayer2, p173, p174)
			end

			if not State then
				return false
			end

			if not v855(State, p173, p174) then
				v857.Enabled = false
				v857.Humanoid = p173
				v857.RootPart = p174
				v857.State = State

				return false
			end

			v857.NextSearchAt = 0
			v857.Enabled = true
			v857.Humanoid = p173
			v857.RootPart = p174
			v857.State = State
			v857.WalkSpeed = math.clamp(p175 * 1.35, 200, 1350)
			v857.TravelVelocity = Vector3.zero
			v831(State, v857.WalkSpeed, v857.TravelVelocity)

			return true
		end
		local function v860(p176, p177, p178, p179)
			local __SenaV4StealAnEggIntegritySpoof = v781().__SenaV4StealAnEggIntegritySpoof

			if type(__SenaV4StealAnEggIntegritySpoof) ~= "table" or not __SenaV4StealAnEggIntegritySpoof.Enabled or __SenaV4StealAnEggIntegritySpoof.Humanoid ~= p176 or __SenaV4StealAnEggIntegritySpoof.RootPart ~= p177 or not v855(__SenaV4StealAnEggIntegritySpoof.State, p176, p177) then
				return false
			end

			__SenaV4StealAnEggIntegritySpoof.WalkSpeed = math.clamp(p178 * 1.35, 200, 1350)

			if typeof(p179) == "Vector3" then
				__SenaV4StealAnEggIntegritySpoof.TravelVelocity = p179
			elseif typeof(__SenaV4StealAnEggIntegritySpoof.TravelVelocity) ~= "Vector3" then
				__SenaV4StealAnEggIntegritySpoof.TravelVelocity = Vector3.zero
			end

			return v831(__SenaV4StealAnEggIntegritySpoof.State, __SenaV4StealAnEggIntegritySpoof.WalkSpeed, __SenaV4StealAnEggIntegritySpoof.TravelVelocity)
		end
		local function v862(p180)
			local __SenaV4StealAnEggIntegritySpoof = v781().__SenaV4StealAnEggIntegritySpoof

			if type(__SenaV4StealAnEggIntegritySpoof) ~= "table" then
				return
			end

			if p180 == nil or __SenaV4StealAnEggIntegritySpoof.Humanoid == p180 then
				__SenaV4StealAnEggIntegritySpoof.Enabled = false
				__SenaV4StealAnEggIntegritySpoof.Humanoid = nil
				__SenaV4StealAnEggIntegritySpoof.RootPart = nil
				__SenaV4StealAnEggIntegritySpoof.State = nil
				__SenaV4StealAnEggIntegritySpoof.TravelVelocity = nil
				__SenaV4StealAnEggIntegritySpoof.NextSearchAt = 0
			end
		end
		local function v864(p181, p182)
			if #p182 == 0 then
				return true
			end

			local ipairs_ = ipairs
			local Mutations = p181.Mutations or {}

			for _, Mutation in ipairs_(Mutations) do
				if v743(p182, Mutation) then
					return true
				end
			end

			return p181.BaseMutation ~= nil and v743(p182, p181.BaseMutation)
		end
		local function v869()
			local v870 = TreadmillUtil.SpeedPowerToWalkSpeed(SpeedPowerProjection.ReadProjected())
			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			return math.clamp(math.min(v870, Humanoid and Humanoid.WalkSpeed or v870), 200, 1000)
		end

		t46.new = function(p183, p184, p185)
			local obj = setmetatable({}, t46)

			obj.catalog = p183
			obj.limitsModule = p184
			obj.coordinator = p185
			obj.operationToken = nil
			obj.connections = {}
			obj.listeners = {}
			obj.records = {}
			obj.enabled = false
			obj.userStealEnabled = false
			obj.skippedEggs = {}
			obj.riftWants = {}
			obj.riftOnly = false
			obj.indexObjectiveEnabled = false
			obj.wispObjective = nil
			obj.manualObjectiveEnabled = false
			obj.manualQueue = {}
			obj.manualOrder = {}
			obj.indexCache = {
				at = 0,
				set = {}
			}
			obj.running = false
			obj.safeStarting = false
			obj.movementRetryPending = false
			obj.destroyed = false
			obj.resetBlocked = AreaEggResetWall3.IsSealed()
			obj.gateOpenAt = obj.resetBlocked and math.huge or os.clock()
			obj.activeTween = nil
			obj.activeTarget = nil
			obj.claimPresentationNode = nil
			obj.claimPresentationOriginal = nil
			obj.claimPresentationSuppression = nil
			obj.carry = {
				active = false,
				uid = nil,
				generation = 0
			}
			obj.carryWorker = nil
			obj.tweenRecoveryUid = nil
			obj.planGeneration = 0
			obj.treadmillDecoy = nil
			obj.treadmillDecoyCamera = nil
			obj.treadmillDecoyCameraConnection = nil
			obj.treadmillDecoyCharacterConnection = nil
			obj.treadmillPopupConnection = nil
			obj.treadmillDecoyRealTransparency = nil
			obj.hoverPadOwnerId = string.format("%s:%0.6f", tostring(obj), os.clock())
			obj.instantPhase = nil
			obj.primerUid = nil
			obj.primerUids = {}
			obj.targetUid = nil
			obj.hitTimer = nil
			obj.guardHitBoostInstalled = false
			obj.stats = {
				status = obj.resetBlocked and "Reset wall closed" or "Ready",
				available = 0,
				matching = 0,
				lastTarget = "None",
				lastResult = "Idle"
			}
			obj.config = {
				stealMode = "Fly",
				flyAerial = false,
				flyZigzag = false,
				speed = 600,
				antiTrap = true,
				heaviestFirst = false,
				highestValueFirst = false,
				minWeightKg = 0,
				espEnabled = false,
				espRarity = true,
				espName = true,
				espKg = true,
				espMutation = true,
				espValue = true,
				espPlaced = false,
				espIcon = true,
				espMinRank = 0,
				espMinValue = 0,
				minValuePerSec = 0,
				rarityEnabled = false,
				rarities = {},
				nameEnabled = false,
				names = {},
				areaEnabled = false,
				areas = {},
				mutationEnabled = false,
				mutations = {}
			}
			obj.gameAntiAfkDisabled = v782()

			if LocalPlayer2.Character then
				v760(LocalPlayer2.Character)

				local Humanoid = LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					pcall(function()
						Humanoid.BreakJointsOnDeath = false
						Humanoid.RequiresNeck = false
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
					end)
				end

				v769(obj, LocalPlayer2.Character)
			end

			local ok, result = pcall(function()
				return require(ReplicatedStorage2.Shared.Util.EggRecords)
			end)

			obj.weightUtil = ok and type(result.WeightKgForScale) == "function" and result or nil

			local function v877(p186)
				if not p186 then
					return
				end

				v738(p186.DescendantAdded, function(p187)
					if obj.config.antiTrap then
						obj:_purgeTrap(p187)
					end
				end, obj.connections)
			end

			v877(workspace:FindFirstChild("Transient"))
			v877(workspace:FindFirstChild("__DEBRIS"))

			if obj.config.antiTrap then
				obj:_purgeTraps()
			end

			v738(workspace.ChildAdded, function(p188)
				if p188.Name == "Transient" or p188.Name == "__DEBRIS" then
					v877(p188)

					if obj.config.antiTrap then
						obj:_purgeTraps()
					end
				end
			end, obj.connections)
			obj:_replaceSnapshot(EggState2.ReadFieldEggs())
			v738(EggState2.FieldRefreshed, function(p189)
				obj:_replaceSnapshot(p189)
			end, obj.connections)
			v738(EggState2.FieldShifted, function(p190)
				obj.records[p190.Uid] = p190
				obj:_refreshCounts()

				if obj.enabled and not obj.destroyed and not obj.running and not obj.carry.active and (p190.State == AreaEggs.States.Slot or p190.State == AreaEggs.States.Dropped) and not obj._shiftWakePending then
					obj._shiftWakePending = true
					task.delay(0.25, function()
						obj._shiftWakePending = nil

						if not obj.destroyed and obj.enabled then
							if not obj.running then
								obj:_schedule()
							end
						end
					end)
				end
			end, obj.connections)
			v738(EggState2.FieldGone, function(p191)
				obj.records[p191] = nil

				if obj.activeTarget and obj.activeTarget.Uid == p191 then
					if obj.carry.active and obj.carry.uid == p191 then
						obj:_refreshCounts()

						return
					end

					obj.carryAttemptToken = nil
					obj:_clearArrivalHold(p191)

					if obj.activeTween and obj.activeTween.Cancel then
						pcall(obj.activeTween.Cancel, obj.activeTween)
					end

					local activeTarget = obj.activeTarget

					task.delay(0.65, function()
						if obj.destroyed or not obj.enabled then
							return
						end

						if obj.carry.active and obj.carry.uid == p191 then
							return
						end

						if obj.activeTarget == activeTarget and activeTarget.Uid == p191 then
							obj:_finish("Target removed — continuing")
						end
					end)
				end

				obj:_refreshCounts()
			end, obj.connections)
			v738(EggState2.ResetCountdown, function()
				obj:_closeGate("Egg reset countdown")
			end, obj.connections)
			v738(EggState2.ResetFade, function()
				obj:_closeGate("Egg reset teleport")
			end, obj.connections)
			v738(AreaEggResetWall3.Changed, function(p192)
				if p192 then
					obj:_closeGate("Reset wall closed")
				else
					obj.resetBlocked = false
					obj.gateOpenAt = os.clock()
					obj.safeStarting = false
					obj.running = false
					obj:_setStatus(obj.enabled and "Searching" or "Ready")
					obj:_schedule()
				end
			end, obj.connections)
			v738(LocalPlayer2.CharacterRemoving, function()
				obj._recalling = nil
				obj:_cleanupInstantSteal()
				obj:_hideTreadmillDecoy()
				obj._forestDropInProgress = nil
				obj._instantReturnToken = nil

				local carry = obj.carry

				carry.generation += 1
				obj:_invalidateCarryWorker()
				obj.carry.active = false
				obj.carry.uid = nil
				obj.safeStarting = false
				obj.planGeneration += 1
				obj:_cancelTween("Character resetting")
				obj:_stopMovementProtection()
			end, obj.connections)
			v738(RunService2.Heartbeat, function()
				if obj.destroyed then
					return
				end

				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

				if not HumanoidRootPart then
					return
				end

				local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				local WalkSpeed = Humanoid and Humanoid.WalkSpeed or 0
				local vector33 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
				local Magnitude = vector33.Magnitude

				if math.max(400, WalkSpeed * 1.5) < Magnitude or math.abs(AssemblyLinearVelocity.Y) > 400 then
					local v887 = math.max(100, WalkSpeed)

					if v887 < vector33.Magnitude then
						vector33 = vector33.Unit * v887
					end

					HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(vector33.X, math.clamp(AssemblyLinearVelocity.Y, -100, 100), vector33.Z)
				end
			end, obj.connections)
			v738(LocalPlayer2.CharacterAdded, function(p193)
				obj:_hideTreadmillDecoy()
				v760(p193)

				local Humanoid = p193:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					pcall(function()
						Humanoid.BreakJointsOnDeath = false
						Humanoid.RequiresNeck = false
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
					end)
				end

				v769(obj, p193)
				task.delay(0.25, function()
					if not obj.destroyed and obj.enabled then
						obj:_startMovementProtection()
					end
				end)
				task.delay(1, function()
					if not obj.destroyed and obj.enabled and obj:_wallOpen() then
						obj:_schedule()
					end
				end)
			end, obj.connections)
			obj:_installClaimPresentationFilter()
			v738(EggState2.CarryChanged, function(p194)
				if p194.IsCarrying then
					if obj.running then
						if obj.activeTarget and p194.Uid == obj.activeTarget.Uid then
							if obj.carry.active and obj.carry.uid == p194.Uid then
								return
							end

							if obj.instantPhase == "priming" and p194.Uid == obj.primerUid then
								obj.carry.active = true
								obj.carry.uid = p194.Uid
								obj:_clearArrivalHold(p194.Uid)
								obj:_enterBaitWait()

								return
							end

							local carry = obj.carry

							carry.generation += 1
							obj:_invalidateCarryWorker()
							obj:_clearArrivalHold(p194.Uid)
							obj.claimPresentationSuppression = {
								assetCategory = obj.activeTarget.AssetCategory,
								expiresAt = os.clock() + 8
							}
							obj.carry.active = true
							obj.carry.uid = p194.Uid
							obj.carryStartTime = os.clock()
							obj.carryStartPos = obj.activeTarget and obj.activeTarget.BottomCFrame and obj.activeTarget.BottomCFrame.Position or LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer2.Character.HumanoidRootPart.Position

							if obj.tweenRecoveryUid == p194.Uid then
								obj.tweenRecoveryUid = nil
							end

							if obj.carryTimeouts then
								obj.carryTimeouts[p194.Uid] = nil
							end

							obj.stats.lastResult = "Carry confirmed"
							obj:_notify()
							obj.carryAttemptToken = nil

							if obj.activeTween and obj.activeTween.Cancel then
								pcall(obj.activeTween.Cancel, obj.activeTween)
							end

							task.defer(function()
								if not obj.destroyed and obj.enabled and obj.carry.uid == p194.Uid and obj:_hasConfirmedCarry(p194.Uid) then
									if genv.__SenaV4GodMode then
										genv.__SenaV4GodMode:stopDefend()
									end

									obj:_returnToSafe()
								end
							end)
						end
					end

					return
				end

				if obj.carry.uid ~= nil and p194.Uid ~= nil and p194.Uid ~= obj.carry.uid then
					return
				end

				local Uid = p194.Uid or obj.carry.uid

				Uid = Uid or obj.activeTarget and obj.activeTarget.Uid

				local active = obj.carry.active
				local carry = obj.carry

				carry.generation += 1

				local generation = obj.carry.generation

				obj:_invalidateCarryWorker()

				if obj.activeTween and obj.activeTween.Cancel then
					pcall(obj.activeTween.Cancel, obj.activeTween)
				end

				obj.carry.active = false
				obj.carry.uid = nil

				if genv.__SenaV4GodMode then
					genv.__SenaV4GodMode:startDefend(Uid)
				end

				if obj._captureHoldUid ~= nil and Uid == obj._captureHoldUid or obj._adminBusyUid ~= nil and Uid == obj._adminBusyUid then
					return
				end

				if obj.instantPhase == "priming" and (p194.Uid == obj.primerUid or Uid == obj.primerUid) then
					obj:_startPrimerTargetHunt()

					return
				end

				if obj._forestDropInProgress ~= nil and Uid == obj._forestDropInProgress then
					return
				end

				if not active then
					return
				end

				if not obj.running or not obj.activeTarget then
					return
				end

				local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

				if not HumanoidRootPart or not obj:_isInSafeArea(HumanoidRootPart) then
					task.delay(0.03, function()
						if not obj.destroyed then
							if obj.enabled and not obj.carry.active and obj.carry.generation == generation then
								if LocalPlayer2.Character then
									local HumanoidRootPart2 = LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

									if HumanoidRootPart2 and obj:_isInSafeArea(HumanoidRootPart2) then
										obj:_reportStolen()
										obj:_finish("Safe return complete")

										return
									end
								end

								obj:_reStealDroppedEgg(Uid)

								return
							end
						end
					end)

					return
				end

				obj:_reportStolen()
				obj:_finish("Safe return complete")
			end, obj.connections)
			v738(LocalPlayer2:GetAttributeChangedSignal("RagdollEndTime"), function()
				local attribute = LocalPlayer2:GetAttribute("RagdollEndTime") or 0

				if obj.instantPhase == "priming" and workspace:GetServerTimeNow() < attribute then
					obj:_startPrimerTargetHunt()
				end
			end, obj.connections)
			v738(RunService2.Heartbeat, function()
				if obj.destroyed then
					return
				end

				local now = os.clock()

				if now - (obj._espLastTick or 0) < 0.4 then
					return
				end

				obj._espLastTick = now

				local ok2, result2 = pcall(function()
					obj:_updateEsp()
				end)

				if not ok2 then
					if now - (obj._espErrLast or 0) > 5 then
						obj._espErrLast = now
						warn("[SAE][esp] update error: " .. tostring(result2))
					end
				end
			end, obj.connections)
			obj.stats.status = obj.stats.status

			return obj
		end
		t46._installClaimPresentationFilter = function()
			return false
		end
		t46._restoreClaimPresentationFilter = function(p195)
			local claimPresentationNode = p195.claimPresentationNode
			local claimPresentationOriginal = p195.claimPresentationOriginal

			if type(claimPresentationNode) == "table" and type(claimPresentationOriginal) == "function" and rawget(claimPresentationNode, "_fn") == p195.claimPresentationWrapper then
				claimPresentationNode._fn = claimPresentationOriginal
			end

			p195.claimPresentationNode = nil
			p195.claimPresentationOriginal = nil
			p195.claimPresentationWrapper = nil
			p195.claimPresentationSuppression = nil
		end
		t46._setStatus = function(p196, p197)
			if p196.stats.status == p197 then
				return
			end

			if type(p197) == "string" and string.find(p197, "not currently trusted", 1, true) then
				p196._untrustedSeen = true
			end

			p196.stats.status = p197
			p196:_notify()
		end
		t46._notify = function(p198)
			local v902 = p198:getSnapshot()

			for k in pairs(p198.listeners) do
				local ok, result = pcall(k, v902)

				if not ok then
					warn("[StealAnEgg] UI listener failed:", result)
				end
			end
		end
		t46.onChanged = function(p199, p200)
			p199.listeners[p200] = true

			local ok, result = pcall(p200, p199:getSnapshot())

			if not ok then
				warn("[StealAnEgg] UI listener failed:", result)
			end

			local function v908()
				p199.listeners[p200] = nil
			end

			return v908
		end
		t46.getSnapshot = function(p201)
			return {
				status = p201.stats.status,
				available = p201.stats.available,
				matching = p201.stats.matching,
				lastTarget = p201.stats.lastTarget,
				lastResult = p201.stats.lastResult,
				wallClosed = p201.resetBlocked or AreaEggResetWall3.IsSealed() or os.clock() < p201.gateOpenAt,
				enabled = p201.enabled,
				running = p201.running
			}
		end
		t46._replaceSnapshot = function(p202, p203)
			table.clear(p202.records)

			local Records = p203 and (p203.Records or p203) or {}

			for k, Record in pairs(Records) do
				if type(Record) == "table" and type(Record.Uid) == "string" then
					p202.records[Record.Uid] = Record
				elseif type(k) == "string" and type(Record) == "table" then
					p202.records[k] = Record
				end
			end

			p202:_refreshCounts()
			p202:_schedule()
		end
		t46._indexWants = function(p204)
			local now = os.clock()
			local indexCache = p204.indexCache

			if indexCache then
				if now - (indexCache.at or 0) < 2 then
					return indexCache.set
				end
			end

			local t50 = {}

			pcall(function()
				local areasDirectory = p204.areasDirectory

				if not areasDirectory then
					areasDirectory = require(ReplicatedStorage2.Data.Areas).Directory
					p204.areasDirectory = areasDirectory
				end

				local v916 = (Save.Peek or Save.Get)()

				if not areasDirectory or not v916 then
					return
				end

				local Index = v916.Index or {}
				local t51 = {}
				local pairs_ = pairs
				local EggInventory = v916.EggInventory or {}

				for _, v in pairs_(EggInventory) do
					local AssetCategory = type(v) == "table" and (v.AssetCategory or v.Category) or nil

					if AssetCategory then
						t51[tostring(AssetCategory)] = true
					end
				end

				local uid = p204.carry and p204.carry.uid

				if uid then
					local v925 = p204.records[uid]

					if v925 and v925.AssetCategory then
						t51[tostring(v925.AssetCategory)] = true
					end
				end

				for _, v in pairs(areasDirectory) do
					if type(v) == "table" and type(v.DropTable) == "table" then
						for _, v2 in ipairs(v.DropTable) do
							local v930 = v2[1]

							if v930 then
								local v931 = tostring(v930)

								if not Index[v931] and not t51[v931] then
									t50[v931] = true
								end
							end
						end
					end
				end
			end)
			p204.indexCache = {
				at = now,
				set = t50
			}

			return t50
		end
		t46._isIndexObjective = function(p205, p206)
			if not p205.indexObjectiveEnabled then
				return false
			end

			if type(p206) ~= "table" then
				return false
			end

			local AssetCategory = p206.AssetCategory

			if not AssetCategory or AssetCategory == "" then
				return false
			end

			return p205:_indexWants()[tostring(AssetCategory)] == true
		end
		t46.setIndexObjective = function(p207, p208)
			local indexObjectiveEnabled = p208 == true

			if p207.indexObjectiveEnabled == indexObjectiveEnabled then
				return
			end

			p207.indexObjectiveEnabled = indexObjectiveEnabled
			p207.indexCache = {
				at = 0,
				set = {}
			}
			p207:_reconcileRunningState()
		end
		t46._isWispObjective = function(p209, p210)
			local wispObjective = p209.wispObjective

			if type(wispObjective) ~= "table" or type(p210) ~= "table" then
				return false
			end

			if wispObjective.area and p210.AreaId ~= wispObjective.area then
				return false
			end

			if wispObjective.rarity then
				local v935 = p209.catalog.resolve(p210)

				if not v935 or v935.rarity ~= wispObjective.rarity then
					return false
				end
			end

			return true
		end
		t46.setWispObjective = function(p211, p212)
			local wispObjectiveKey = type(p212) == "table"

			if wispObjectiveKey then
				wispObjectiveKey = (p212.area or "") .. "|" .. (p212.rarity or "")
			end

			wispObjectiveKey = wispObjectiveKey or nil

			if p211.wispObjectiveKey == wispObjectiveKey then
				return
			end

			p211.wispObjectiveKey = wispObjectiveKey
			p211.wispObjective = wispObjectiveKey and p212 or nil
			p211:_reconcileRunningState()
		end
		t46.indexMissingCount = function(p213)
			local n19 = 0

			for _ in pairs(p213:_indexWants()) do
				n19 += 1
			end

			return n19
		end
		t46._matchesNormalFilter = function(p214, p215)
			local v939 = p214.catalog.resolve(p215)
			local config = p214.config
			local v941, v942, minValuePerSec, minWeightKg

			if config.rarityEnabled then
				if not (#config.rarities ~= 0 and v743(config.rarities, v939.rarity)) then
					return false
				end

				if config.nameEnabled then
					if #config.names == 0 or not v743(config.names, v939.name) and not v743(config.names, v939.category) then
						return false
					end

					if config.areaEnabled then
						if not (#config.areas ~= 0 and v743(config.areas, p215.AreaId)) then
							return false
						end

						if config.mutationEnabled then
							if not v864(p215, config.mutations) then
								return false
							end

							if (config.minWeightKg or 0) > 0 then
								v942 = p214:_resolveWeightKg(p215)

								if not v942 or v942 < config.minWeightKg then
									return false
								end

								if (config.minValuePerSec or 0) > 0 then
									v941 = v748(p215)

									if not v941 or v941 < config.minValuePerSec then
										return false
									end
								end
							else
								minValuePerSec = config.minValuePerSec or 0

								if minValuePerSec > 0 then
									v941 = v748(p215)

									if not v941 or v941 < config.minValuePerSec then
										return false
									end
								end
							end
						else
							minWeightKg = config.minWeightKg or 0

							if minWeightKg > 0 then
								v942 = p214:_resolveWeightKg(p215)

								if not v942 or v942 < config.minWeightKg then
									return false
								end

								minValuePerSec = config.minValuePerSec or 0

								if minValuePerSec > 0 then
									v941 = v748(p215)

									if not v941 or v941 < config.minValuePerSec then
										return false
									end
								end
							else
								minValuePerSec = config.minValuePerSec or 0

								if minValuePerSec > 0 then
									v941 = v748(p215)

									if not v941 or v941 < config.minValuePerSec then
										return false
									end
								end
							end
						end
					elseif config.mutationEnabled then
						if not v864(p215, config.mutations) then
							return false
						end

						minWeightKg = config.minWeightKg or 0

						if minWeightKg > 0 then
							v942 = p214:_resolveWeightKg(p215)

							if not v942 or v942 < config.minWeightKg then
								return false
							end

							minValuePerSec = config.minValuePerSec or 0

							if minValuePerSec > 0 then
								v941 = v748(p215)

								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						else
							minValuePerSec = config.minValuePerSec or 0

							if minValuePerSec > 0 then
								v941 = v748(p215)

								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						end
					else
						minWeightKg = config.minWeightKg or 0

						if minWeightKg > 0 then
							v942 = p214:_resolveWeightKg(p215)

							if not v942 or v942 < config.minWeightKg then
								return false
							end

							minValuePerSec = config.minValuePerSec or 0

							if minValuePerSec > 0 then
								v941 = v748(p215)

								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						else
							minValuePerSec = config.minValuePerSec or 0

							if minValuePerSec > 0 then
								v941 = v748(p215)

								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						end
					end
				elseif config.areaEnabled then
					if not (#config.areas ~= 0 and v743(config.areas, p215.AreaId)) then
						return false
					end

					if config.mutationEnabled then
						if not v864(p215, config.mutations) then
							return false
						end

						minWeightKg = config.minWeightKg or 0

						if minWeightKg > 0 then
							v942 = p214:_resolveWeightKg(p215)

							if not v942 or v942 < config.minWeightKg then
								return false
							end

							minValuePerSec = config.minValuePerSec or 0

							if minValuePerSec > 0 then
								v941 = v748(p215)

								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						else
							minValuePerSec = config.minValuePerSec or 0

							if minValuePerSec > 0 then
								v941 = v748(p215)

								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						end
					else
						minWeightKg = config.minWeightKg or 0

						if minWeightKg > 0 then
							v942 = p214:_resolveWeightKg(p215)

							if not v942 or v942 < config.minWeightKg then
								return false
							end

							minValuePerSec = config.minValuePerSec or 0

							if minValuePerSec > 0 then
								v941 = v748(p215)

								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						else
							minValuePerSec = config.minValuePerSec or 0

							if minValuePerSec > 0 then
								v941 = v748(p215)

								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						end
					end
				elseif config.mutationEnabled then
					if not v864(p215, config.mutations) then
						return false
					end

					minWeightKg = config.minWeightKg or 0

					if minWeightKg > 0 then
						v942 = p214:_resolveWeightKg(p215)

						if not v942 or v942 < config.minWeightKg then
							return false
						end

						minValuePerSec = config.minValuePerSec or 0

						if minValuePerSec > 0 then
							v941 = v748(p215)

							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					else
						minValuePerSec = config.minValuePerSec or 0

						if minValuePerSec > 0 then
							v941 = v748(p215)

							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					end
				else
					minWeightKg = config.minWeightKg or 0

					if minWeightKg > 0 then
						v942 = p214:_resolveWeightKg(p215)

						if not v942 or v942 < config.minWeightKg then
							return false
						end

						minValuePerSec = config.minValuePerSec or 0

						if minValuePerSec > 0 then
							v941 = v748(p215)

							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					else
						minValuePerSec = config.minValuePerSec or 0

						if minValuePerSec > 0 then
							v941 = v748(p215)

							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					end
				end
			elseif config.nameEnabled then
				if #config.names == 0 or not v743(config.names, v939.name) and not v743(config.names, v939.category) then
					return false
				end

				if config.areaEnabled then
					if not (#config.areas ~= 0 and v743(config.areas, p215.AreaId)) then
						return false
					end

					if config.mutationEnabled then
						if not v864(p215, config.mutations) then
							return false
						end

						minWeightKg = config.minWeightKg or 0

						if minWeightKg > 0 then
							v942 = p214:_resolveWeightKg(p215)

							if not v942 or v942 < config.minWeightKg then
								return false
							end

							minValuePerSec = config.minValuePerSec or 0

							if minValuePerSec > 0 then
								v941 = v748(p215)

								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						else
							minValuePerSec = config.minValuePerSec or 0

							if minValuePerSec > 0 then
								v941 = v748(p215)

								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						end
					else
						minWeightKg = config.minWeightKg or 0

						if minWeightKg > 0 then
							v942 = p214:_resolveWeightKg(p215)

							if not v942 or v942 < config.minWeightKg then
								return false
							end

							minValuePerSec = config.minValuePerSec or 0

							if minValuePerSec > 0 then
								v941 = v748(p215)

								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						else
							minValuePerSec = config.minValuePerSec or 0

							if minValuePerSec > 0 then
								v941 = v748(p215)

								if not v941 or v941 < config.minValuePerSec then
									return false
								end
							end
						end
					end
				elseif config.mutationEnabled then
					if not v864(p215, config.mutations) then
						return false
					end

					minWeightKg = config.minWeightKg or 0

					if minWeightKg > 0 then
						v942 = p214:_resolveWeightKg(p215)

						if not v942 or v942 < config.minWeightKg then
							return false
						end

						minValuePerSec = config.minValuePerSec or 0

						if minValuePerSec > 0 then
							v941 = v748(p215)

							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					else
						minValuePerSec = config.minValuePerSec or 0

						if minValuePerSec > 0 then
							v941 = v748(p215)

							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					end
				else
					minWeightKg = config.minWeightKg or 0

					if minWeightKg > 0 then
						v942 = p214:_resolveWeightKg(p215)

						if not v942 or v942 < config.minWeightKg then
							return false
						end

						minValuePerSec = config.minValuePerSec or 0

						if minValuePerSec > 0 then
							v941 = v748(p215)

							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					else
						minValuePerSec = config.minValuePerSec or 0

						if minValuePerSec > 0 then
							v941 = v748(p215)

							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					end
				end
			elseif config.areaEnabled then
				if not (#config.areas ~= 0 and v743(config.areas, p215.AreaId)) then
					return false
				end

				if config.mutationEnabled then
					if not v864(p215, config.mutations) then
						return false
					end

					minWeightKg = config.minWeightKg or 0

					if minWeightKg > 0 then
						v942 = p214:_resolveWeightKg(p215)

						if not v942 or v942 < config.minWeightKg then
							return false
						end

						minValuePerSec = config.minValuePerSec or 0

						if minValuePerSec > 0 then
							v941 = v748(p215)

							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					else
						minValuePerSec = config.minValuePerSec or 0

						if minValuePerSec > 0 then
							v941 = v748(p215)

							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					end
				else
					minWeightKg = config.minWeightKg or 0

					if minWeightKg > 0 then
						v942 = p214:_resolveWeightKg(p215)

						if not v942 or v942 < config.minWeightKg then
							return false
						end

						minValuePerSec = config.minValuePerSec or 0

						if minValuePerSec > 0 then
							v941 = v748(p215)

							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					else
						minValuePerSec = config.minValuePerSec or 0

						if minValuePerSec > 0 then
							v941 = v748(p215)

							if not v941 or v941 < config.minValuePerSec then
								return false
							end
						end
					end
				end
			elseif config.mutationEnabled then
				if not v864(p215, config.mutations) then
					return false
				end

				minWeightKg = config.minWeightKg or 0

				if minWeightKg > 0 then
					v942 = p214:_resolveWeightKg(p215)

					if not v942 or v942 < config.minWeightKg then
						return false
					end

					minValuePerSec = config.minValuePerSec or 0

					if minValuePerSec > 0 then
						v941 = v748(p215)

						if not v941 or v941 < config.minValuePerSec then
							return false
						end
					end
				else
					minValuePerSec = config.minValuePerSec or 0

					if minValuePerSec > 0 then
						v941 = v748(p215)

						if not v941 or v941 < config.minValuePerSec then
							return false
						end
					end
				end
			else
				if (config.minWeightKg or 0) > 0 then
					v942 = p214:_resolveWeightKg(p215)

					if not v942 or v942 < config.minWeightKg then
						return false
					end

					minValuePerSec = config.minValuePerSec or 0

					if minValuePerSec > 0 then
						v941 = v748(p215)

						if not v941 or v941 < config.minValuePerSec then
							return false
						end
					end
				else
					if (config.minValuePerSec or 0) > 0 then
						v941 = v748(p215)

						if not v941 or v941 < config.minValuePerSec then
							return false
						end
					end
				end
			end

			return true
		end
		t46._matches = function(p216, p217)
			if p217.State ~= AreaEggs.States.Slot and p217.State ~= AreaEggs.States.Dropped then
				return false
			end

			if p216.riftWants[p217.AssetCategory] then
				return true
			end

			if p216.indexObjectiveEnabled and p216:_isIndexObjective(p217) then
				return true
			end

			if p216.wispObjective and p216:_isWispObjective(p217) then
				return true
			end

			if p216.userStealEnabled and not p216.riftOnly and p216:_matchesNormalFilter(p217) then
				return true
			end

			return false
		end
		t46.setScrambleWants = function(p218, p219, p220)
			local riftWants = {}
			local ipairs_ = ipairs
			local v947 = type(p219) == "table" and p219 or {}

			for _, v in ipairs_(v947) do
				if type(v) == "string" and v ~= "" then
					riftWants[v] = true
				end
			end

			local riftOnly = p220 == true
			local v951 = riftOnly ~= p218.riftOnly

			for k in pairs(riftWants) do
				if not p218.riftWants[k] then
					v951 = true
				end
			end

			for k in pairs(p218.riftWants) do
				if not riftWants[k] then
					v951 = true
				end
			end

			if not v951 then
				return
			end

			p218.riftWants = riftWants
			p218.riftOnly = riftOnly
			p218:_reconcileRunningState()
		end
		t46._refreshCounts = function(p221)
			local available = 0
			local matching = 0

			for _, record in pairs(p221.records) do
				if record.State == AreaEggs.States.Slot then
					available += 1

					if p221:_matches(record) then
						matching += 1
					end
				end
			end

			p221.stats.available = available
			p221.stats.matching = matching
			p221:_notify()
		end
		t46.hasPriorityRareEgg = function(p222)
			local Character = LocalPlayer2.Character

			Character = Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

			local v959
			local v960
			local v961
			local pairs_ = pairs
			local records = p222.records or {}

			for _, record in pairs_(records) do
				if (record.State == AreaEggs.States.Slot or record.State == AreaEggs.States.Dropped) and record.BottomCFrame and not p222:isSkippedEgg(record.Uid) and p222:_matchesNormalFilter(record) then
					local v966 = p222.catalog.resolve(record)

					if t42[v966.rarity] then
						local Magnitude = Character and (record.BottomCFrame.Position - Character.Position).Magnitude or 0
						local rarityRank = v966.rarityRank or 0

						if not v959 or v960 < rarityRank or rarityRank == v960 and Magnitude < v961 then
							v959 = record
							v960 = rarityRank
							v961 = Magnitude
						end
					end
				end
			end

			return v959 ~= nil, v959
		end
		t46.isSkippedEgg = function(p223, p224)
			if p224 ~= nil then
				if p224 == workspace:GetAttribute("Event_CaptureTheEggUid") then
					if not p223.captureObjectiveEnabled then
						return true
					end
				end
			end

			local v969 = p224 and p223.skippedEggs[p224]

			if not v969 then
				return false
			end

			if os.clock() < v969 then
				return true
			end

			p223.skippedEggs[p224] = nil

			return false
		end

		do
			t46._isCaptureEgg = function(p225, p226)
				return p226 ~= nil and p226 == workspace:GetAttribute("Event_CaptureTheEggUid")
			end
		end

		t46.setCaptureObjective = function(p227, p228)
			local v970 = p228 == true

			if p227.captureObjectiveEnabled == v970 then
				return
			end

			if v970 then
				p227._modeBeforeCapture = {
					p227.config.stealMode,
					p227.config.flyAerial,
					p227.config.flyZigzag
				}
				p227:setStealMode("Instant", false, false)
				p227.captureObjectiveEnabled = true
			else
				p227.captureObjectiveEnabled = false

				local _modeBeforeCapture = p227._modeBeforeCapture

				p227._modeBeforeCapture = nil

				if _modeBeforeCapture then
					p227:setStealMode(_modeBeforeCapture[1], _modeBeforeCapture[2], _modeBeforeCapture[3])
				end
			end

			p227:_reconcileRunningState()
		end
		t46._captureHold = function(p229, p230)
			if p229._captureHoldUid == p230 then
				return
			end

			p229._captureHoldUid = p230

			local function v972()
				local v973 = EggState2.ReadFieldEgg(p230)

				return v973 ~= nil and v973.State == AreaEggs.States.Carried and v973.CarrierUserId == LocalPlayer2.UserId
			end
			local function v974()
				return not p229.destroyed and p229.enabled and p229.captureObjectiveEnabled and v972()
			end

			task.spawn(function()
				p229:_clearArrivalHold(p230)
				p229:_hideTreadmillDecoy()
				pcall(function()
					p229:_stopHoverPad()
				end)
				p229.stats.lastResult = "Holding capture egg"
				p229:_setStatus("Holding capture egg")

				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local cFrame2 = HumanoidRootPart and cFrameNew(HumanoidRootPart.Position.X, 110, HumanoidRootPart.Position.Z) * HumanoidRootPart.CFrame.Rotation

				if cFrame2 then
					p229:_glideRoot(cFrame2, function()
						return not v974()
					end)
				end

				while v974() do
					local Character2 = LocalPlayer2.Character
					local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")

					if HumanoidRootPart2 and Humanoid and cFrame2 then
						pcall(function()
							HumanoidRootPart2.CFrame = cFrame2
							HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
							HumanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
						end)
						p229:_syncHoverPad(cFrame2.Position)

						local v981 = math.clamp(p229.config.speed or 600, 200, v721())

						pcall(function()
							v795(Character2, v981 * 1.35)
							v860(Humanoid, HumanoidRootPart2, v981, Vector3.zero)
						end)
					end

					task.wait(0.1)
				end

				pcall(function()
					p229:_stopHoverPad()
				end)

				if p229._captureHoldUid == p230 then
					p229._captureHoldUid = nil
				end

				if p229.destroyed or not p229.enabled then
					return
				end

				p229:_finish(p229.captureObjectiveEnabled and "Capture egg lost — re-grabbing" or "Capture stopped")
			end)
		end
		t46._chooseTarget = function(p231)
			local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				return nil
			end

			if p231.captureObjectiveEnabled then
				local attribute = workspace:GetAttribute("Event_CaptureTheEggUid")
				local v984 = attribute and (EggState2.ReadFieldEgg(attribute) or p231.records[attribute])

				if type(v984) == "table" and v984.BottomCFrame and (v984.State == AreaEggs.States.Slot or v984.State == AreaEggs.States.Dropped) then
					return v984
				end
			end

			if p231.manualObjectiveEnabled then
				local v985 = p231:_takeManualTarget()

				if v985 then
					return v985
				end
			end

			if p231.userStealEnabled and not p231.riftOnly then
				local v986, v987 = p231:hasPriorityRareEgg()

				if v986 and v987 then
					return v987
				end
			end

			local v988
			local v989
			local v990
			local v991
			local v992
			local v993

			for _, record in pairs(p231.records) do
				if (record.State == AreaEggs.States.Slot or record.State == AreaEggs.States.Dropped) and record.BottomCFrame and not p231:isSkippedEgg(record.Uid) then
					local Magnitude = (record.BottomCFrame.Position - HumanoidRootPart.Position).Magnitude

					if not p231.riftWants[record.AssetCategory] then
						if not p231.wispObjective or not p231:_isWispObjective(record) then
							if p231.indexObjectiveEnabled and p231:_isIndexObjective(record) and (not v990 or Magnitude < v991) then
								v990 = record
								v991 = Magnitude
							end
						elseif not v992 or Magnitude < v993 then
							v992 = record
							v993 = Magnitude
						end
					elseif not v988 or Magnitude < v989 then
						v988 = record
						v989 = Magnitude
					end
				end
			end

			if v988 or v992 or v990 then
				return v988 or v992 or v990
			end

			if p231.userStealEnabled and not p231.riftOnly then
				local v997
				local v998
				local v999

				for _, record in pairs(p231.records) do
					if record.State == AreaEggs.States.Slot or record.State == AreaEggs.States.Dropped then
						if not p231:isSkippedEgg(record.Uid) and p231:_matchesNormalFilter(record) then
							local Magnitude = (record.BottomCFrame.Position - HumanoidRootPart.Position).Magnitude
							local v1003 = p231.catalog.resolve(record)
							local v1004

							if p231.config.highestValueFirst then
								v1004 = v748(record) or -math.huge
							elseif p231.config.heaviestFirst then
								v1004 = p231:_resolveWeightKg(record) or -math.huge
							else
								v1004 = v1003.rarityRank or 0
							end

							if not v997 or v998 < v1004 or v1004 == v998 and Magnitude < v999 then
								v997 = record
								v998 = v1004
								v999 = Magnitude
							end
						end
					end
				end

				if v997 then
					return v997
				end
			end

			return nil
		end
		t46._takeManualTarget = function(p232)
			local t52 = {}
			local manualOrder = {}

			for _, v in ipairs(p232.manualOrder) do
				local v1009 = p232.records[v]

				if v1009 and (v1009.State == AreaEggs.States.Slot or v1009.State == AreaEggs.States.Dropped) then
					manualOrder[#manualOrder + 1] = v
					t52[v] = true
				end
			end

			p232.manualOrder = manualOrder

			for k in pairs(p232.manualQueue) do
				if not t52[k] then
					p232.manualQueue[k] = nil
				end
			end

			if #manualOrder ~= 0 then
				return p232.records[manualOrder[1]]
			end

			if p232.manualObjectiveEnabled then
				p232.manualObjectiveEnabled = false
				task.defer(function()
					if not p232.destroyed then
						p232:_reconcileRunningState()
					end
				end)
			end

			return nil
		end
		t46.queueManual = function(p233, p234)
			if type(p234) ~= "table" then
				return 0
			end

			for _, v in ipairs(p234) do
				local v1013 = v

				if v1013 ~= nil and not p233.manualQueue[v1013] then
					p233.manualQueue[v1013] = true
					p233.manualOrder[#p233.manualOrder + 1] = v1013
				end
			end

			local v1014 = #p233.manualOrder

			if v1014 > 0 then
				p233.manualObjectiveEnabled = true
			end

			p233:_reconcileRunningState()

			return v1014
		end

		do
			t46.clearManual = function(p235)
				p235.manualQueue = {}
				p235.manualOrder = {}
				p235.manualObjectiveEnabled = false
				p235:_reconcileRunningState()
			end
		end

		t46.manualPending = function(p236)
			return #p236.manualOrder
		end
		t46.setTreadmillManager = function(p237, p238)
			p237.treadmillManager = p238
		end
		t46.getStealMode = function(p239)
			return p239.config.stealMode == "Fly" and "Fly" or "Instant"
		end

		do
			t46.setStealMode = function(p240, p241, p242, p243)
				local stealMode = p241 == "Fly" and "Fly" or "Instant"
				local flyAerial = stealMode == "Fly" and p242 == true
				local flyZigzag = stealMode == "Fly" and p243 == true and not flyAerial

				if p240.config.stealMode ~= stealMode or p240.config.flyAerial ~= flyAerial or p240.config.flyZigzag ~= flyZigzag then
					p240.config.stealMode = stealMode
					p240.config.flyAerial = flyAerial
					p240.config.flyZigzag = flyZigzag

					if p240.enabled then
						p240:_installGuardHitDistanceBoost()
						p240:_finish("Mode changed")
					end
				end

				return stealMode
			end
		end

		do
			local ResolveHitDistance

			t46._installGuardHitDistanceBoost = function(p244)
				if not p244.guardHitBoostInstalled then
					pcall(function()
						local GuardChasePolicy = require(ReplicatedStorage2.Shared.Modules.GuardAreas.GuardChasePolicy)

						if GuardChasePolicy and type(GuardChasePolicy.ResolveHitDistance) == "function" then
							ResolveHitDistance = ResolveHitDistance or GuardChasePolicy.ResolveHitDistance

							local v1020 = p244

							GuardChasePolicy.ResolveHitDistance = function(p245)
								if v1020.enabled and v1020.instantPhase == "priming" then
									return 25
								end

								if v1020.enabled or v1020._recalling then
									return -math.huge
								end

								local ok = not ResolveHitDistance
								local v1022

								if not ok then
									v1022 = ResolveHitDistance(p245)
									ok = not v1022
								end

								if ok then
									v1022 = p245 or 10
								end

								return v1022
							end
							p244.guardHitBoostInstalled = true
						end
					end)

					return
				end
			end
			t46._removeGuardHitDistanceBoost = function(p246)
				if not p246.guardHitBoostInstalled then
					return
				end

				pcall(function()
					local GuardChasePolicy = require(ReplicatedStorage2.Shared.Modules.GuardAreas.GuardChasePolicy)

					if GuardChasePolicy and ResolveHitDistance then
						GuardChasePolicy.ResolveHitDistance = ResolveHitDistance
						p246.guardHitBoostInstalled = false
					end
				end)
			end
		end

		t46._setInstantAnchored = function(p247, p248)
			pcall(function()
				local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart then
					if HumanoidRootPart.Anchored ~= p248 then
						HumanoidRootPart.Anchored = p248
					end
				end
			end)
		end

		do
			t46._kbCancelTimer = function(p249)
				if p249.hitTimer then
					pcall(task.cancel, p249.hitTimer)
					p249.hitTimer = nil
				end
			end
		end

		t46._isPrimerEgg = function(p250, p251)
			if p251 == nil then
				return false
			end

			if p251 == p250.primerUid then
				return true
			end

			local primerUids = p250.primerUids and p250.primerUids[p251]

			if primerUids then
				if os.clock() < primerUids then
					return true
				end
			end

			if primerUids then
				p250.primerUids[p251] = nil
			end

			return false
		end
		t46._cleanupInstantSteal = function(p252)
			p252.instantPhase = nil
			p252.primerUid = nil
			p252.targetUid = nil
			p252._flyDeparting = false
			p252:_stopGuardStick()
			p252:_kbCancelTimer()
			p252:_setInstantAnchored(false)
			p252:_hideTreadmillDecoy()
		end
		t46._choosePrimerEgg = function(p253, p254)
			local v1026 = v14()
			local Areas = v1026 and v1026:FindFirstChild("Areas")
			local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
			local Forest = GuardAreas and GuardAreas:FindFirstChild("Forest")
			local Guard = Forest and Forest:FindFirstChild("Guard")
			local HumanoidRootPart = Guard and Guard:FindFirstChild("HumanoidRootPart")
			local Position = HumanoidRootPart and HumanoidRootPart.Position
			local v1033
			local v1034

			for _, record in pairs(p253.records) do
				if record.State == AreaEggs.States.Slot and record.AreaId == "Forest" and record.Uid ~= p254 and not p253:_isCaptureEgg(record.Uid) then
					local v1037 = -(Position and (record.BottomCFrame.Position - Position).Magnitude or LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart") and (record.BottomCFrame.Position - LocalPlayer2.Character.HumanoidRootPart.Position).Magnitude or math.huge) - (p253.catalog.resolve(record).rarityRank or 0) * 100

					if not v1033 or v1034 < v1037 then
						v1033 = record
						v1034 = v1037
					end
				end
			end

			return v1033
		end
		t46._stopGuardStick = function(p255)
			if p255.guardStickConnection then
				pcall(p255.guardStickConnection.Disconnect, p255.guardStickConnection)
				p255.guardStickConnection = nil
			end
		end
		t46._startGuardStick = function(p256)
			p256:_stopGuardStick()

			local function v1038()
				local v1039 = v14()
				local Areas = v1039 and v1039:FindFirstChild("Areas")
				local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
				local Forest = GuardAreas and GuardAreas:FindFirstChild("Forest")
				local Guard = Forest and Forest:FindFirstChild("Guard")

				return Guard and Guard:FindFirstChild("HumanoidRootPart")
			end

			p256.guardStickConnection = RunService2.PreSimulation:Connect(function()
				if p256.destroyed or not p256.enabled or p256.instantPhase ~= "priming" then
					p256:_stopGuardStick()

					return
				end

				local v1044 = v1038()
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

				if not v1044 or not HumanoidRootPart then
					return
				end

				local Position = v1044.Position
				local v1048 = v1044.CFrame.LookVector * 2.5
				local v1049 = Vector3.new(Position.X + v1048.X, HumanoidRootPart.Position.Y, Position.Z + v1048.Z) - HumanoidRootPart.Position

				if v1049.Magnitude > 40 then
					v1049 = v1049.Unit * 40
				end

				local v1050 = HumanoidRootPart.Position + v1049

				HumanoidRootPart.CFrame = lookAt(v1050, Vector3.new(Position.X, v1050.Y, Position.Z))
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				p256:_syncHoverPad(v1050)
			end)
		end
		t46._forestGuardModel = function()
			local v1051 = v14()
			local Areas = v1051 and v1051:FindFirstChild("Areas")
			local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
			local Forest = GuardAreas and GuardAreas:FindFirstChild("Forest")

			return Forest and Forest:FindFirstChild("Guard")
		end
		t46._triggerGuardHit = function(p257)
			local v1055 = p257:_forestGuardModel()
			local HumanoidRootPart = v1055 and v1055:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				return
			end

			local Character = LocalPlayer2.Character
			local HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart2 then
				return
			end

			local Position = HumanoidRootPart.Position
			local v1060 = HumanoidRootPart.CFrame.LookVector * 2.5
			local vector33 = Vector3.new(Position.X + v1060.X, HumanoidRootPart2.Position.Y, Position.Z + v1060.Z)

			p257.guardStrikeAnchor = vector33
			HumanoidRootPart2.CFrame = lookAt(vector33, Vector3.new(Position.X, vector33.Y, Position.Z))
			HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero

			local Collider = v1055:FindFirstChild("Collider") or HumanoidRootPart

			if firetouchinterest then
				pcall(function()
					firetouchinterest(HumanoidRootPart2, Collider, 0)
					firetouchinterest(HumanoidRootPart2, Collider, 1)
				end)
			end

			pcall(function()
				local ForestStrike = Remotes.GuardPatrol and Remotes.GuardPatrol.ForestStrike

				if ForestStrike then
					ForestStrike:FireServer({
						EggUid = p257.primerUid,
						GuardCFrame = HumanoidRootPart.CFrame
					})
				end
			end)
		end
		t46._stopGuardStrike = function(p258)
			p258.guardStrikeGeneration = (p258.guardStrikeGeneration or 0) + 1
		end
		t46._knockbackLanded = function()
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if not HumanoidRootPart or not Humanoid then
				return false
			end

			if Humanoid.PlatformStand or Humanoid.Sit then
				return true
			end

			local state = Humanoid:GetState()

			if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
				return true
			end

			return HumanoidRootPart.AssemblyLinearVelocity.Magnitude > 18
		end
		t46._settleAfterKnockback = function(p259)
			local guardStrikeAnchor = p259.guardStrikeAnchor
			local v1069 = os.clock() + 0.35

			while true do
				if not (os.clock() < v1069) or p259.destroyed then
					return
				end

				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

				if not HumanoidRootPart then
					break
				end

				local Humanoid = Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					pcall(function()
						Humanoid.PlatformStand = false
						Humanoid.Sit = false
						Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
					end)
				end

				if guardStrikeAnchor then
					HumanoidRootPart.CFrame = cFrameNew(guardStrikeAnchor)
				end

				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				p259:_syncHoverPad(guardStrikeAnchor or HumanoidRootPart.Position)
				RunService2.Heartbeat:Wait()
			end
		end
		t46._startGuardStrike = function(p260)
			p260:_stopGuardStrike()

			local guardStrikeGeneration = p260.guardStrikeGeneration

			task.spawn(function()
				local v1074 = os.clock() + 1.5

				while not p260.destroyed and p260.enabled and p260.instantPhase == "priming" and p260.guardStrikeGeneration == guardStrikeGeneration and os.clock() < v1074 do
					p260:_triggerGuardHit()

					local v1075 = os.clock() + 0.05
					local v1076 = false

					while os.clock() < v1075 do
						if p260:_knockbackLanded() then
							v1076 = true

							break
						else
							RunService2.Heartbeat:Wait()
						end
					end

					if v1076 then
						break
					end
				end

				if p260.guardStrikeGeneration == guardStrikeGeneration then
					p260:_stopGuardStick()
					p260:_settleAfterKnockback()
				end
			end)
		end
		t46._enterBaitWait = function(p261)
			p261:_setInstantAnchored(false)
			p261:_setStatus("Preparing steal")
			p261:_startGuardStick()
			p261:_startGuardStrike()

			if p261.hitTimer then
				return
			end

			p261.hitTimer = task.delay(1.8, function()
				p261.hitTimer = nil

				if p261.destroyed or not p261.enabled then
					return
				end

				if p261.instantPhase ~= "priming" then
					return
				end

				p261:_stopGuardStick()
				p261:_stopGuardStrike()

				if p261.carry.active and p261:_isPrimerEgg(p261.carry.uid) then
					pcall(EggState2.DropFieldEgg, "PlayerRequest")
				end

				p261:_finish("Steal timed out — retrying")
			end)
		end

		local function v1077(p262, p263)
			local v1078 = tostring(p262 or ""):lower()
			local n20 = 8
			local n21 = 3.5

			if v1078:find("enchanted") then
				n20 = 18
				n21 = 12
			elseif v1078:find("light") or v1078:find("dark") then
				n20 = 16
				n21 = 10
			elseif v1078:find("titan") then
				n20 = 10
				n21 = 8
			end

			return math.max(n21, n20 * ((11 - math.clamp(p263, 1, 10)) / 6))
		end

		do
			t46._resolveSettleSeconds = function(p264, p265)
				local v1081 = math.clamp(tonumber(senaV4Config.StealHoldSeconds) or 5, 1, 10)
				local v1082 = p264.settleBonus and type(p265) == "table" and p264.settleBonus[p265.Uid]
				local seconds = v1082 and v1082.untilAt > os.clock() and v1082.seconds or 0

				return v1077(type(p265) == "table" and p265.AreaId, v1081) + seconds
			end
		end

		t46._startPrimerTargetHunt = function(p266)
			if p266.instantPhase ~= "priming" then
				return
			end

			p266:_stopGuardStick()
			p266:_stopGuardStrike()
			pcall(function()
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					Humanoid.PlatformStand = false
					Humanoid.Sit = false
				end

				if HumanoidRootPart then
					if p266.guardStrikeAnchor then
						HumanoidRootPart.CFrame = cFrameNew(p266.guardStrikeAnchor)
					end

					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				end
			end)
			p266:_kbCancelTimer()
			p266:_setInstantAnchored(false)
			p266.instantPhase = "hunting"
			p266:_clearArrivalHold()

			local carry = p266.carry

			carry.generation += 1
			p266:_invalidateCarryWorker()
			p266.carry.active = false
			p266.carry.uid = nil

			local targetUid = p266.targetUid

			p266.targetUid = nil

			if not targetUid then
				p266:_finish("No target egg")

				return
			end

			local v1089 = EggState2.ReadFieldEgg(targetUid) or p266.records[targetUid]

			if not v1089 or v1089.State ~= AreaEggs.States.Slot and v1089.State ~= AreaEggs.States.Dropped then
				p266:_finish("Target egg no longer available")

				return
			end

			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if not HumanoidRootPart or not Humanoid then
				p266:_finish("Character unavailable")

				return
			end

			p266.activeTarget = v1089

			local v1093 = p266:_resolveEggDestination(v1089, HumanoidRootPart, Humanoid)

			if not v1093 then
				p266:_finish("Target destination unavailable")

				return
			end

			if p266.config.stealMode ~= "Fly" then
				if p266.config.stealMode == "Instant" and not p266.lowFpsPrime then
					local Uid = v1089.Uid

					local function v1095()
						return p266.destroyed or not p266.enabled or p266.instantPhase ~= "hunting" or not p266.activeTarget or p266.activeTarget.Uid ~= Uid
					end

					local cFrame2 = v1093 + Vector3.new(0, 14, 0)

					p266:_setStatus("Heading to target egg")

					if not p266:_glideRoot(cFrame2, v1095) then
						if not v1095() then
							p266:_finish("Could not reach the egg — retrying")
						end

						return
					end

					task.spawn(function()
						local v1097 = p266:_resolveSettleSeconds(v1089)
						local v1098 = os.clock() + v1097

						if os.clock() < v1098 then
							local exitTo

							while not v1095() do
								p266:_setStatus(string.format("Securing target egg (%.1fs)", math.max(0, v1098 - os.clock())))

								local Character2 = LocalPlayer2.Character
								local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
								local Humanoid2 = Character2 and Character2:FindFirstChildOfClass("Humanoid")

								if HumanoidRootPart2 and Humanoid2 then
									pcall(function()
										HumanoidRootPart2.CFrame = cFrame2
										HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
										HumanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
									end)
									p266:_syncHoverPad(cFrame2.Position)

									local v1103 = math.clamp(p266.config.speed or 600, 200, v721())

									pcall(function()
										v795(Character2, v1103 * 1.35)
										v860(Humanoid2, HumanoidRootPart2, v1103, Vector3.zero)
									end)
								end

								task.wait(0.1)

								if not (os.clock() < v1098) then
									exitTo = 1

									break
								end
							end

							if exitTo ~= 1 then
								return
							end

							if not v1095() then
								p266:_glideRoot(v1093, v1095)

								if v1095() then
									return
								end

								p266:_setArrivalHold(v1093, Uid)
								p266:_setStatus("Securing target egg")
								p266:_requestCarry(v1089, true)

								return
							end
						elseif not v1095() then
							p266:_glideRoot(v1093, v1095)

							if v1095() then
								return
							end

							p266:_setArrivalHold(v1093, Uid)
							p266:_setStatus("Securing target egg")
							p266:_requestCarry(v1089, true)

							return
						end
					end)

					return
				end

				p266:_setStatus("Heading to target egg")
				p266:_tweenRoot(v1093, function()
					if p266.instantPhase == "hunting" and p266.activeTarget and p266.activeTarget.Uid == v1089.Uid then
						p266:_requestCarry(v1089, false)
					end
				end, nil, {
					holdAfterArrival = true,
					holdUid = v1089.Uid,
					flightProfile = true,
					carryTarget = v1089
				})

				return
			end

			local Uid = v1089.Uid

			local function v1105()
				return p266.destroyed or not p266.enabled or p266.instantPhase ~= "hunting" or not p266.activeTarget or p266.activeTarget.Uid ~= Uid
			end

			if p266.config.flyAerial then
				p266:_setStatus("Heading to target egg")
				p266:_startFlyGrounding()

				local v1106 = p266:_flyWalkTo(v1093, v1105, 8, 110)

				p266:_stopFlyGrounding()

				if not v1106 then
					if not v1105() then
						p266:_finish("Could not reach the egg — retrying")
					end

					return
				end
			elseif p266.config.flyZigzag then
				p266:_setStatus("Heading to target egg")

				if not p266:_walkToZigzag(v1093, v1105) then
					if not v1105() then
						p266:_finish("Zig-zag walk to target failed")
					end

					return
				end
			else
				p266:_setStatus("Heading to target egg")

				if not p266:_walkTo(v1093, v1105) then
					if not v1105() then
						p266:_finish("Walk to target failed")
					end

					return
				end
			end

			if v1105() then
				return
			end

			p266:_glideRoot(v1093, v1105, p266:_legitWalkSpeed())

			if v1105() then
				return
			end

			p266:_setArrivalHold(v1093, Uid)
			p266:_setStatus("Securing target egg")
			p266:_requestCarry(v1089, true)
		end

		do
			t46._wallOpen = function(p267)
				if p267.resetBlocked or AreaEggResetWall3.IsSealed() or os.clock() < p267.gateOpenAt then
					return false
				end

				local v1107 = v14()
				local Areas = v1107 and v1107:FindFirstChild("Areas")
				local WallStartCollision = Areas and Areas:FindFirstChild("WallStartCollision")

				if WallStartCollision and WallStartCollision:IsA("BasePart") and WallStartCollision.CanCollide then
					return false
				end

				return true
			end
		end

		t46._closeGate = function(p268, p269)
			p268.resetBlocked = true
			p268.gateOpenAt = math.huge
			p268.safeStarting = false

			if not p268.activeTween then
				p268:_cancelTween(p269)
			elseif not p268.activeTween.sharedTravel then
				p268:_cancelTween(p269)
				p268:_setStatus(p269)

				return
			end

			p268:_setStatus(p269)
		end
		t46._releaseOperation = function(p270)
			local operationToken = p270.operationToken

			p270.operationToken = nil

			if operationToken and p270.coordinator then
				p270.coordinator:release(operationToken)
			end
		end

		do
			t46._acquireOperation = function(p271)
				if p271.operationToken or not p271.coordinator then
					return true
				end

				local autoSteal, v1112 = p271.coordinator:tryAcquire("auto_steal", {})

				if not autoSteal then
					return false, v1112
				end

				p271.operationToken = autoSteal

				return true
			end
		end

		t46._cancelTween = function(p272, p273, p274)
			p272:_cleanupInstantSteal()
			p272.carryAttemptToken = nil
			p272:_clearArrivalHold()
			p272.safeStarting = false

			if p272.activeTween then
				pcall(p272.activeTween.Cancel, p272.activeTween)
				p272.activeTween = nil
			end

			if not p272.activeTween and not p272.arrivalHold then
				p272:_stopHoverPad()
			end

			if p272.running then
				p272.running = false
				p272.activeTarget = nil
				p272.stats.lastResult = p273
				p272:_notify()
			end

			if not p274 then
				p272:_releaseOperation()
			end
		end
		t46._groundYAt = function(p275, p276, p277, p278)
			local Character = p278 or LocalPlayer2.Character
			local vector33 = Vector3.new(p276, (Character and Character:FindFirstChild("HumanoidRootPart") and Character.HumanoidRootPart.Position.Y or vector32.Y) + 60, p277)
			local filterDescendantsInstances = {}

			if Character then
				table.insert(filterDescendantsInstances, Character)
			end

			if p275.hoverPad then
				table.insert(filterDescendantsInstances, p275.hoverPad)
			end

			if p275.treadmillDecoy then
				table.insert(filterDescendantsInstances, p275.treadmillDecoy)
			end

			for _, child in ipairs(workspace:GetChildren()) do
				if child.Name == "__SenaV4HoverPad" or child.Name == "__SenaV4TreadmillDecoy" then
					table.insert(filterDescendantsInstances, child)
				end
			end

			for i = 1, 10 do
				local raycastParams = RaycastParams.new()

				raycastParams.FilterType = Enum.RaycastFilterType.Exclude
				raycastParams.FilterDescendantsInstances = filterDescendantsInstances
				raycastParams.IgnoreWater = true

				local hit = workspace:Raycast(vector33, Vector3.new(0, -300, 0), raycastParams)

				if not hit then
					return nil
				end

				if hit.Instance.CanCollide then
					return hit.Position.Y
				end

				table.insert(filterDescendantsInstances, hit.Instance)
			end

			return nil
		end

		do
			t46._resolveSafeCFrame = function(p279, p280)
				if not p280 then
					return nil
				end

				local X = vector32.X
				local Z = vector32.Z
				local Y = vector32.Y
				local v1124 = p279:_groundYAt(X, Z, p280.Parent)

				if v1124 then
					Y = v1124 + 3.2
				end

				return cFrameNew(X, Y, Z) * p280.CFrame.Rotation
			end
		end

		t46._groundSnap = function(p281)
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if not HumanoidRootPart or not Humanoid then
				return false
			end

			local Position = HumanoidRootPart.Position
			local v1129 = p281:_groundYAt(Position.X, Position.Z, Character)

			if not v1129 then
				return false
			end

			local v1130 = v1129 + p281:_feetOffset(HumanoidRootPart, Humanoid)

			if not (Position.Y < v1130 - 0.25) and not (v1130 + 8 < Position.Y) then
				return false
			end

			pcall(function()
				p281:_syncHoverPad(Vector3.new(Position.X, v1130, Position.Z))
				HumanoidRootPart.CFrame = cFrameNew(Position.X, v1130, Position.Z) * HumanoidRootPart.CFrame.Rotation
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			end)

			return true
		end

		do
			local function v1131(p282)
				if typeof(p282) == "Instance" and p282:IsA("Trail") then
					pcall(p282.Destroy, p282)
				end
			end
			local function v1132(p283)
				if typeof(p283) == "Instance" then
					if p283.Name == "SpeedGainPopup" or p283.Name == "PlusOne" then
						pcall(p283.Destroy, p283)
					end
				end
			end

			t46._showTreadmillDecoy = function(p284)
				if p284.treadmillDecoy and p284.treadmillDecoy.Parent then
					return true
				end

				p284:_hideTreadmillDecoy()

				local Character = LocalPlayer2.Character

				if not Character then
					return false
				end

				local Archivable = Character.Archivable

				Character.Archivable = true

				local ok, treadmillDecoy = pcall(Character.Clone, Character)

				Character.Archivable = Archivable

				if not ok or not treadmillDecoy or typeof(treadmillDecoy) ~= "Instance" then
					return false
				end

				treadmillDecoy.Name = "__SenaV4TreadmillDecoy"

				for _, descendant in ipairs(treadmillDecoy:GetDescendants()) do
					if t45[descendant.ClassName] or descendant:IsA("Trail") then
						pcall(descendant.Destroy, descendant)
					elseif descendant:IsA("BasePart") then
						descendant.LocalTransparencyModifier = 0
						descendant.Anchored = true
						descendant.CanCollide = false
						descendant.CanQuery = false
						descendant.CanTouch = false
					end
				end

				local HumanoidRootPart = treadmillDecoy:FindFirstChild("HumanoidRootPart")
				local Humanoid = treadmillDecoy:FindFirstChildOfClass("Humanoid")

				if not HumanoidRootPart or not Humanoid then
					treadmillDecoy:Destroy()

					return false
				end

				pcall(function()
					Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
					Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
				end)
				treadmillDecoy.Parent = workspace
				treadmillDecoy:PivotTo(cFrameNew(vector32))
				p284.treadmillDecoy = treadmillDecoy

				local PlayerGui = LocalPlayer2:FindFirstChildOfClass("PlayerGui")

				if PlayerGui then
					for _, descendant in ipairs(PlayerGui:GetDescendants()) do
						if descendant.Name == "SpeedGainPopup" or descendant.Name == "PlusOne" then
							v1132(descendant)
						end
					end

					p284.treadmillPopupConnection = PlayerGui.DescendantAdded:Connect(function(descendant)
						if p284.treadmillDecoy == treadmillDecoy then
							v1132(descendant)
						end
					end)
				end

				local treadmillDecoyRealTransparency = setmetatable({}, {
					__mode = "k"
				})

				local function v1145(p285)
					if not p285 or not p285:IsA("BasePart") or not p285:IsDescendantOf(Character) then
						return
					end

					if treadmillDecoyRealTransparency[p285] == nil then
						treadmillDecoyRealTransparency[p285] = p285.LocalTransparencyModifier
					end

					p285.LocalTransparencyModifier = 1
				end

				for _, descendant in ipairs(Character:GetDescendants()) do
					v1145(descendant)
					v1131(descendant)
				end

				p284.treadmillDecoyRealTransparency = treadmillDecoyRealTransparency
				p284.treadmillDecoyCharacterConnection = Character.DescendantAdded:Connect(function(descendant)
					if p284.treadmillDecoy == treadmillDecoy then
						pcall(v1145, descendant)
						v1131(descendant)
					end
				end)

				local CurrentCamera = workspace.CurrentCamera

				if CurrentCamera then
					p284.treadmillDecoyCamera = CurrentCamera.CameraSubject
					CurrentCamera.CameraSubject = Humanoid
				end

				p284.treadmillDecoyCameraConnection = RunService2.RenderStepped:Connect(function()
					if p284.treadmillDecoy ~= treadmillDecoy or not treadmillDecoy.Parent or not Humanoid.Parent then
						return
					end

					for k in pairs(treadmillDecoyRealTransparency) do
						if k.Parent and k.LocalTransparencyModifier ~= 1 then
							k.LocalTransparencyModifier = 1
						end
					end

					local CurrentCamera2 = workspace.CurrentCamera

					if CurrentCamera2 and CurrentCamera2.CameraSubject ~= Humanoid then
						CurrentCamera2.CameraSubject = Humanoid
					end
				end)

				return true
			end
		end

		t46._hideTreadmillDecoy = function(p286, p287)
			if p286._recalling and not p287 then
				return
			end

			if p286.treadmillDecoyCameraConnection then
				pcall(p286.treadmillDecoyCameraConnection.Disconnect, p286.treadmillDecoyCameraConnection)
				p286.treadmillDecoyCameraConnection = nil
			end

			if p286.treadmillDecoyCharacterConnection then
				pcall(p286.treadmillDecoyCharacterConnection.Disconnect, p286.treadmillDecoyCharacterConnection)
				p286.treadmillDecoyCharacterConnection = nil
			end

			if p286.treadmillPopupConnection then
				pcall(p286.treadmillPopupConnection.Disconnect, p286.treadmillPopupConnection)
				p286.treadmillPopupConnection = nil
			end

			local pairs_ = pairs
			local treadmillDecoyRealTransparency = p286.treadmillDecoyRealTransparency or {}

			for k, v in pairs_(treadmillDecoyRealTransparency) do
				if typeof(k) == "Instance" and k.Parent then
					pcall(function()
						k.LocalTransparencyModifier = v
					end)
				end
			end

			p286.treadmillDecoyRealTransparency = nil

			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			local CurrentCamera = workspace.CurrentCamera

			if CurrentCamera then
				pcall(function()
					CurrentCamera.CameraSubject = Humanoid or p286.treadmillDecoyCamera
				end)
			end

			p286.treadmillDecoyCamera = nil

			if p286.treadmillDecoy then
				pcall(p286.treadmillDecoy.Destroy, p286.treadmillDecoy)
			end

			p286.treadmillDecoy = nil
		end

		do
			t46._restoreTreadmillVisualAtSafe = function(p288)
				if not p288.treadmillDecoy then
					p288:_hideTreadmillDecoy()

					return true
				end

				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
				local v1161 = p288:_resolveSafeCFrame(HumanoidRootPart)

				if not HumanoidRootPart or not Humanoid or not v1161 then
					p288:_hideTreadmillDecoy()

					return false
				end

				local v1162 = os.clock() + 2
				local v1163
				local n22 = 0

				while not p288.destroyed and os.clock() < v1162 do
					local now = os.clock()

					if p288:_isInSafeArea(HumanoidRootPart) then
						v1163 = v1163 or now

						if now - v1163 >= 0.35 then
							p288:_hideTreadmillDecoy()

							return true
						end
					else
						v1163 = nil

						if n22 <= now then
							n22 = now + 0.1
							p288:_teleportRoot(HumanoidRootPart, Humanoid, v1161)
						end
					end

					task.wait(0.03)
				end

				p288:_hideTreadmillDecoy()

				return false
			end
		end

		t46._prepareTreadmillLaunch = function(p289, p290, p291)
			local treadmillManager = p289.treadmillManager

			if not treadmillManager or type(treadmillManager.pulseForCarry) ~= "function" then
				return false, "Preparation unavailable"
			end

			local Uid = p290 and p290.Uid

			local function v1168()
				return Uid and (EggState2.ReadFieldEgg(Uid) or p289.records[Uid]) or nil
			end
			local function v1169()
				local v1170 = v1168()

				return p289.destroyed or not p289.enabled or p289.planGeneration ~= p291 or not p289:_wallOpen() or type(v1170) ~= "table" or not p289:_matches(v1170)
			end
			local function v1171(p292)
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

				return p289:_teleportRoot(HumanoidRootPart, Character and Character:FindFirstChildOfClass("Humanoid"), p292)
			end

			p289:_setStatus("Preparing carry")

			if not p289:_showTreadmillDecoy() then
				return false, "Safe-zone visual unavailable"
			end

			local v1174, v1175 = treadmillManager:pulseForCarry(v1171, v1169)

			if not v1174 then
				p289:_restoreTreadmillVisualAtSafe()

				return false, v1175
			end

			p289:_setStatus("Positioning at safe area")

			if not p289:_restoreTreadmillVisualAtSafe() then
				return false, "Safe teleport failed"
			end

			if not v1169() then
				return true, v1168()
			end

			return false, "Target changed before travel"
		end
		t46._resolveEggDestination = function(p293, p294, p295, p296)
			if type(p294) ~= "table" or typeof(p294.BottomCFrame) ~= "CFrame" then
				return nil
			end

			local Character = LocalPlayer2.Character
			local HumanoidRootPart = p295 or Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = p296 or Character and Character:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart and Humanoid then
				return cFrameNew(p294.BottomCFrame.Position + Vector3.new(0, p293:_feetOffset(HumanoidRootPart, Humanoid) + 0.15, 0))
			end

			return nil
		end

		local function v1179()
			local ok, result = pcall(function()
				local v1182 = v14()

				return v1182 and v1182:FindFirstChild("Areas") and v1182.Areas:FindFirstChild("EggCarryBounds")
			end)

			if ok and result then
				local Gameplay1 = result:FindFirstChild("Gameplay1")

				if Gameplay1 and Gameplay1:IsA("BasePart") then
					local v1184 = Gameplay1.Size.Z * 0.5 - 18

					if v1184 > 5 then
						return Gameplay1.Position.Z - v1184, Gameplay1.Position.Z + v1184
					end
				end
			end

			return -426, -308
		end

		t46._resolveRouteCruiseY = function(p297, p298, p299)
			if p297.config.stealMode ~= "Fly" then
				return nil
			end

			if not p298 or typeof(p299) ~= "CFrame" then
				return nil
			end

			if p299.Position.Y >= 104 then
				return nil
			end

			return 110
		end
		t46._resolveElevatedDestination = function(p300, p301, p302)
			if p301 then
				if typeof(p302) == "CFrame" then
					return p302
				end
			end

			return nil
		end
		t46._teleportRoot = function(p303, p304, p305, p306)
			if not p304 or not p305 or typeof(p306) ~= "CFrame" then
				return false
			end

			if not pcall(function()
				p304.AssemblyLinearVelocity = Vector3.zero
				p304.AssemblyAngularVelocity = Vector3.zero
				p304.CFrame = p306
				p304.AssemblyLinearVelocity = Vector3.zero
				p304.AssemblyAngularVelocity = Vector3.zero
			end) then
				return false
			end

			local v1185 = math.clamp(p303.config.speed or 600, 200, v721())

			v795(LocalPlayer2.Character, v1185 * 1.35)

			if not v860(p305, p304, v1185, Vector3.zero) then
				v856(p305, p304, v1185)
				v860(p305, p304, v1185, Vector3.zero)
			end

			return true
		end
		t46._legitWalkSpeed = function(p307)
			local u1186

			pcall(function()
				local Character = LocalPlayer2.Character
				local WalkSpeed

				if Character then
					local Humanoid = LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")

					WalkSpeed = Humanoid and Humanoid.WalkSpeed
				else
					WalkSpeed = Character
				end

				u1186 = WalkSpeed
			end)

			if type(u1186) == "number" and u1186 >= 1 and u1186 <= 400 then
				p307._legitWsCache = u1186
			end

			local _legitWsCache = p307._legitWsCache or type(u1186) == "number" and math.clamp(u1186, 1, 400) or 16

			return _legitWsCache
		end

		do
			t46._activeGlideSpeed = function(p308)
				if p308.config.stealMode == "Fly" and p308._flyDeparting then
					return p308:_legitWalkSpeed()
				end

				return 5000
			end
		end

		t46._glideRoot = function(p309, p310, p311, p312)
			if typeof(p310) ~= "CFrame" then
				return false
			end

			local v1191 = p312 or p309:_activeGlideSpeed()
			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart or not Humanoid then
				return false
			end

			pcall(v760, Character)
			pcall(function()
				Humanoid.AutoRotate = false
			end)
			p309:_startHoverPad()

			local Position = p310.Position

			local function v1196(p313, p314, p315)
				local v1197 = math.clamp(p309.config.speed or 600, 200, v721())

				pcall(function()
					v795(p313, v1197 * 1.35)
					v860(p314, p315, v1197, Vector3.zero)
				end)
			end

			local v1198 = os.clock() + math.clamp((Position - HumanoidRootPart.Position).Magnitude / math.max(v1191, 1) * 1.6 + 6, 15, 120)

			while true do
				if not (os.clock() < v1198) then
					return false
				end

				if p311 and p311() then
					break
				end

				if p309.destroyed or not p309.enabled and not p309._externalDeliver then
					return false
				end

				local Character2 = LocalPlayer2.Character
				local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")

				Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")

				if not HumanoidRootPart2 then
					return false
				end

				if not Humanoid then
					return false
				end

				local Position2 = HumanoidRootPart2.Position
				local v1202 = Position - Position2
				local Magnitude = v1202.Magnitude

				if Magnitude <= 1 then
					pcall(function()
						HumanoidRootPart2.CFrame = p310
						HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
						HumanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
					end)
					p309:_syncHoverPad(Position)
					v1196(Character2, Humanoid, HumanoidRootPart2)

					return true
				end

				local v1204 = math.max(math.min(RunService2.Heartbeat:Wait(), 0.15), 0.0041666666666666666)
				local v1205 = Position2 + v1202.Unit * math.min(v1191 * v1204, Magnitude)

				if v1204 >= 0.033333333333333333 then
					local v1206 = p309:_groundYAt(v1205.X, v1205.Z, Character2)

					if v1206 then
						local v1207 = v1206 + p309:_feetOffset(HumanoidRootPart2, Humanoid)

						if v1205.Y < v1207 then
							v1205 = Vector3.new(v1205.X, v1207, v1205.Z)
						end
					end
				end

				pcall(function()
					HumanoidRootPart2.CFrame = cFrameNew(v1205, v1205 + v1202.Unit)
					HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
				end)
				p309:_syncHoverPad(v1205)
				v1196(Character2, Humanoid, HumanoidRootPart2)
			end

			return false
		end
		t46._walkBrakeDecel = function(p316)
			if p316._brakeDecel then
				return p316._brakeDecel
			end

			local __SenaV4BrakeDecel = genv.__SenaV4BrakeDecel

			if LocalPlayer2.Character then
				local Humanoid = LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")

				if type(__SenaV4BrakeDecel) == "table" and Humanoid then
					if math.abs((__SenaV4BrakeDecel.ws or 0) - Humanoid.WalkSpeed) < 15 then
						p316._brakeDecel = __SenaV4BrakeDecel.decel

						return __SenaV4BrakeDecel.decel
					end
				end
			else
				type(__SenaV4BrakeDecel)
			end

			return 420
		end

		do
			t46._walkLeg = function(p317, p318, p319, p320, p321, p322, p323)
				local state = 1
				local v1211, v1212, v1213, v1214, v1215, v1216, v1217, n23, v1219, n24, v1221, v1222, v1223, u1224, u1225, u1226, u1227, Character, HumanoidRootPart, Humanoid, Position, vector33, Magnitude, AssemblyLinearVelocity, Magnitude2, v1236, v1237, vector34, now, v1240, v1241, Character2, v1243, Humanoid2, HumanoidRootPart2

				while true do
					if state == 1 then
						v1211 = p317
						v1212 = p318
						v1213 = p319
						v1214 = p320
						v1215 = p321
						v1216 = p322
						v1217 = p323
						n23 = 684529208
						v1219 = nil
						n24 = 602089359
						v1221 = nil
						v1222 = nil
						v1223 = function(p324, p325)
							if p324 then
								if p325 then
									pcall(function()
										p324:MoveTo(p325.Position)
									end)
								end
							end

							return false
						end
						u1224 = nil
						u1225 = nil
						u1226 = nil
						u1227 = nil

						if os.clock() < v1216 then
							state = 2
						else
							state = 40
						end
					elseif state == 2 then
						Character = LocalPlayer2.Character
						HumanoidRootPart = Character

						if HumanoidRootPart then
							state = 35
						else
							state = 3
						end
					elseif state == 3 then
						if Character then
							state = 4
						else
							state = 39
						end
					elseif state == 4 then
						Humanoid = Character:FindFirstChildOfClass("Humanoid")
						state = 5
					elseif state == 5 then
						if HumanoidRootPart and Humanoid then
							state = 6
						else
							state = 38
						end
					elseif state == 6 then
						if v1213 and v1213() then
							state = 7
						else
							state = 8
						end
					else
						if state == 7 then
							return v1223(Humanoid, HumanoidRootPart)
						end

						if state == 8 then
							if not v1211.destroyed and (v1211.enabled or v1211._externalDeliver) then
								state = 10
							else
								state = 9
							end
						else
							if state == 9 then
								return v1223(Humanoid, HumanoidRootPart)
							end

							if state == 10 then
								Position = HumanoidRootPart.Position
								vector33 = Vector3.new(v1212.X - Position.X, 0, v1212.Z - Position.Z)
								Magnitude = vector33.Magnitude
								AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
								Magnitude2 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude

								if v1215 then
									state = 11
								else
									state = 13
								end
							elseif state == 11 then
								if Magnitude <= v1214 and Magnitude2 <= 20 then
									state = 12
								else
									state = 19
								end
							else
								if state == 12 then
									pcall(function()
										u1224 = 26636988
										u1225 = 319405266
										Humanoid:MoveTo(Position)
									end)

									return true
								end

								if state == 13 then
									v1236 = v1219

									if v1236 then
										state = 18
									else
										state = 14
									end
								elseif state == 14 then
									v1236 = Magnitude > 0.001

									if v1236 then
										state = 15
									else
										state = 16
									end
								elseif state == 15 then
									v1236 = vector33.Unit
									state = 16
								elseif state == 16 then
									if v1236 then
										state = 18
									else
										state = 17
									end
								elseif state == 17 then
									v1236 = Vector3.zero
									state = 18
								elseif state == 18 then
									v1219 = v1236

									if Magnitude <= v1214 or vector33:Dot(v1219) <= 0 then
										state = 37
									else
										state = 19
									end
								elseif state == 19 then
									v1237 = Magnitude > 0.001

									if v1237 then
										state = 20
									else
										state = 21
									end
								elseif state == 20 then
									v1237 = math.max(AssemblyLinearVelocity.X * vector33.X + AssemblyLinearVelocity.Z * vector33.Z, 0) / Magnitude
									state = 21
								elseif state == 21 then
									if v1237 then
										state = 23
									else
										state = 22
									end
								elseif state == 22 then
									v1237 = Magnitude2
									state = 23
								elseif state == 23 then
									if v1215 and Magnitude <= v1237 * v1237 / (2 * v1211:_walkBrakeDecel()) + v1237 * 0.06 then
										state = 24
									else
										state = 28
									end
								elseif state == 24 then
									vector34 = Position
									now = os.clock()

									if v1221 and v1222 < now and Magnitude2 > 20 then
										state = 25
									else
										state = 27
									end
								elseif state == 25 then
									v1240 = (v1221 - Magnitude2) / (now - v1222)

									if v1240 > 20 and v1240 < 5000 then
										state = 26
									else
										state = 27
									end
								elseif state == 26 then
									v1211._brakeDecel = v1211:_walkBrakeDecel() * 0.8 + v1240 * 0.93 * 0.2
									genv.__SenaV4BrakeDecel = {
										ws = Humanoid.WalkSpeed,
										decel = v1211._brakeDecel
									}
									state = 27
								elseif state == 27 then
									v1221 = Magnitude2
									v1222 = now
									state = 31
								elseif state == 28 then
									v1221 = nil
									v1241 = math.max(Humanoid.WalkSpeed * 0.5, 12)

									if v1215 and Magnitude <= v1241 then
										state = 29
									else
										state = 30
									end
								elseif state == 29 then
									vector34 = Vector3.new(v1212.X, Position.Y, v1212.Z)
									state = 31
								elseif state == 30 then
									vector34 = Position + vector33.Unit * v1241
									state = 31
								elseif state == 31 then
									pcall(function()
										u1226 = 843258489
										u1227 = 553919544
										Humanoid:MoveTo(vector34)
									end)

									if v1217 then
										state = 32
									else
										state = 33
									end
								elseif state == 32 then
									v1217()
									state = 33
								elseif state == 33 then
									RunService2.Heartbeat:Wait()

									if os.clock() < v1216 then
										state = 34
									else
										state = 40
									end
								elseif state == 34 then
									Character = LocalPlayer2.Character
									HumanoidRootPart = Character

									if HumanoidRootPart then
										state = 35
									else
										state = 36
									end
								elseif state == 35 then
									HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
									state = 36
								elseif state == 36 then
									Humanoid = Character

									if Humanoid then
										state = 4
									else
										state = 5
									end
								else
									if state == 37 then
										return true
									end

									if state == 38 then
										return false
									end

									if state == 39 then
										return false
									end

									if state == 40 then
										Character2 = LocalPlayer2.Character
										v1243 = v1223
										Humanoid2 = Character2

										if Humanoid2 then
											state = 41
										else
											state = 42
										end
									elseif state == 41 then
										Humanoid2 = Character2:FindFirstChildOfClass("Humanoid")
										state = 42
									elseif state == 42 then
										HumanoidRootPart2 = Character2

										if HumanoidRootPart2 then
											state = 43
										else
											state = 45
										end
									elseif state == 43 then
										HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")
										state = 44
									elseif state == 44 then
										return v1243(Humanoid2, HumanoidRootPart2)
									elseif state == 45 then
										return v1243(Humanoid2, HumanoidRootPart2)
									end
								end
							end
						end
					end
				end
			end
		end

		do
			t46._walkTo = function(p326, p327, p328, p329)
				if typeof(p327) ~= "CFrame" then
					return false
				end

				local v1246 = p329 or 8
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				if not HumanoidRootPart or not Humanoid then
					return false
				end

				pcall(function()
					Humanoid.AutoRotate = true
				end)

				local Position = p327.Position
				local WalkSpeed = Humanoid.WalkSpeed

				if not WalkSpeed or WalkSpeed < 1 then
					WalkSpeed = 16
				end

				local Magnitude = Vector3.new(Position.X - HumanoidRootPart.Position.X, 0, Position.Z - HumanoidRootPart.Position.Z).Magnitude

				return p326:_walkLeg(Position, p328, v1246, true, os.clock() + math.clamp(Magnitude / WalkSpeed * 2 + 8, 12, 90))
			end
		end

		t46._walkToZigzag = function(p330, p331, p332, p333)
			if typeof(p331) ~= "CFrame" then
				return false
			end

			local v1253 = p333 or 8
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if not HumanoidRootPart or not Humanoid then
				return false
			end

			pcall(function()
				Humanoid.AutoRotate = true
			end)

			local Position = p331.Position
			local WalkSpeed = Humanoid.WalkSpeed

			if not WalkSpeed or WalkSpeed < 1 then
				WalkSpeed = 16
			end

			local Magnitude = Vector3.new(Position.X - HumanoidRootPart.Position.X, 0, Position.Z - HumanoidRootPart.Position.Z).Magnitude
			local v1260 = math.max(45, WalkSpeed * WalkSpeed / (2 * p330:_walkBrakeDecel()) * 2.5)
			local v1261 = os.clock() + math.clamp(Magnitude / WalkSpeed * 3 + 10, 14, 120)
			local v1262
			local v1263
			local ok, result, result2 = pcall(function()
				return v1179()
			end)

			if ok and type(result) == "number" and type(result2) == "number" then
				v1262 = math.min(result, result2)
				v1263 = math.max(result, result2)
			end

			while true do
				if not (os.clock() < v1261) then
					return false
				end

				if p332 and p332() then
					break
				end

				if p330.destroyed or not p330.enabled then
					return false
				end

				local Character2 = LocalPlayer2.Character
				local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")

				Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")

				if not HumanoidRootPart2 or not Humanoid then
					return false
				end

				local Position2 = HumanoidRootPart2.Position
				local vector33 = Vector3.new(Position.X - Position2.X, 0, Position.Z - Position2.Z)
				local Magnitude2 = vector33.Magnitude

				if Magnitude2 <= v1260 then
					return p330:_walkLeg(Position, p332, v1253, true, v1261)
				end

				local Unit = vector33.Unit
				local vector34 = Vector3.new(-Unit.Z, 0, Unit.X)
				local v1274 = math.max(Magnitude2 - v1260 * 0.5, 4)
				local v1275 = math.min(60 + math.random() * 40, v1274)
				local v1276 = math.min(38, v1275 * 0.4)
				local v1277 = Position2 + Unit * v1275 + vector34 * ((math.random() * 2 - 1) * v1276)
				local Z = v1277.Z

				if v1262 and v1263 then
					Z = math.clamp(Z, v1262 + 2, v1263 - 2)
				end

				if p330:_walkLeg(Vector3.new(v1277.X, Position2.Y, Z), p332, 10, false, v1261) then
					continue
				end

				return false
			end

			return false
		end
		t46._flyWalkTo = function(p334, p335, p336, p337, p338)
			if typeof(p335) ~= "CFrame" then
				return false
			end

			local v1279 = p337 or 8
			local hoverPadHeightOverride = tonumber(p338) or 110
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if not HumanoidRootPart or not Humanoid then
				return false
			end

			pcall(function()
				Humanoid.AutoRotate = true
			end)

			local function v1284()
				pcall(function()
					local Humanoid2 = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
					local Animator = Humanoid2 and Humanoid2:FindFirstChildWhichIsA("Animator")

					if Animator then
						for _, v in ipairs(Animator:GetPlayingAnimationTracks()) do
							v:Stop(0)
						end
					end
				end)
			end
			local function v1289(p339)
				local Character2 = LocalPlayer2.Character
				local Animate = Character2 and Character2:FindFirstChild("Animate")

				if Animate then
					pcall(function()
						Animate.Disabled = p339
					end)
				end
			end

			v1289(true)
			v1284()

			local Position = p335.Position

			p334.hoverPadHeightOverride = hoverPadHeightOverride
			p334:_startHoverPad()
			pcall(function()
				HumanoidRootPart.CFrame = cFrameNew(HumanoidRootPart.Position.X, hoverPadHeightOverride, HumanoidRootPart.Position.Z) * HumanoidRootPart.CFrame.Rotation
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			end)
			p334:_syncHoverPad()

			local WalkSpeed = Humanoid.WalkSpeed

			if not WalkSpeed or WalkSpeed < 1 then
				WalkSpeed = 16
			end

			local Magnitude = Vector3.new(Position.X - HumanoidRootPart.Position.X, 0, Position.Z - HumanoidRootPart.Position.Z).Magnitude
			local v1295 = p334:_walkLeg(Position, p336, v1279, true, os.clock() + math.clamp(Magnitude / WalkSpeed * 2 + 10, 12, 120), v1284)

			v1289(false)
			p334.hoverPadHeightOverride = nil

			if not v1295 then
				return false
			end

			if p336 and p336() then
				return false
			end

			p334:_glideRoot(p335, p336, p334:_legitWalkSpeed())

			local v1296 = p336 and p336()

			return not v1296
		end
		t46._isInSafeArea = function(p340, p341)
			if not p341 then
				return false
			end

			local v1297 = p341.Position - vector32

			return Vector2.new(v1297.X, v1297.Z).Magnitude <= 30 and math.abs(v1297.Y) <= 18
		end
		t46._isInField = function(p342, p343)
			local v1298 = v14()
			local Areas = v1298 and v1298:FindFirstChild("Areas")
			local WallStartCollision = Areas and Areas:FindFirstChild("WallStartCollision")

			if WallStartCollision and WallStartCollision:IsA("BasePart") then
				return p343.Position.X >= WallStartCollision.Position.X + 3
			end

			return true
		end
		t46._needsSafeZoneHop = function(p344, p345)
			if p344:_isInField(p345) or p344:_isInSafeArea(p345) then
				return false, nil
			end

			return true, p344:_resolveSafeCFrame(p345)
		end
		t46._invalidateCarryWorker = function(p346)
			p346.carryWorker = nil
		end
		t46._claimCarryWorker = function(p347, p348, p349)
			local generation = p347.carry.generation
			local carryWorker = p347.carryWorker

			if carryWorker then
				if carryWorker.generation == generation then
					return nil
				end
			end

			local carryWorker2 = {
				kind = p348,
				uid = p349,
				generation = generation,
				token = {}
			}

			p347.carryWorker = carryWorker2

			return carryWorker2
		end

		do
			t46._isCarryWorkerCurrent = function(p350, p351)
				return type(p351) == "table" and p350.carryWorker == p351 and p350.carry.generation == p351.generation and not p350.destroyed and (p350.enabled or p350._externalDeliver)
			end
		end

		t46._releaseCarryWorker = function(p352, p353)
			if p352.carryWorker == p353 then
				p352.carryWorker = nil
			end
		end
		t46.ownsCarryRecovery = function(p354, p355)
			if p354.destroyed or not p354.enabled then
				return false
			end

			if p354.carry.uid == p355 then
				return true
			end

			return p354.running and p354.activeTarget ~= nil and (p355 == nil or p354.activeTarget.Uid == p355)
		end
		t46.requestCarryRecovery = function(p356, p357)
			if p356.destroyed or not p356.enabled or type(p357) ~= "string" or p357 == "" then
				return false
			end

			if p356:isSkippedEgg(p357) then
				return true
			end

			if p356.tweenRecoveryUid == p357 then
				p356:_scheduleMovementRetry()

				return true
			end

			if p356.carry.active and p356.carry.uid == p357 then
				return true
			end

			local v1304 = EggState2.ReadFieldEgg(p357) or p356.records[p357]

			if type(v1304) ~= "table" or v1304.State ~= AreaEggs.States.Dropped and v1304.State ~= AreaEggs.States.Slot then
				return false
			end

			local carryWorker = p356.carryWorker

			if (not carryWorker or carryWorker.kind ~= "re-steal" or carryWorker.uid ~= p357) and (not p356.activeTween or not p356.activeTarget or p356.activeTarget.Uid ~= p357) then
				if not p356.carryAttemptToken or not p356.activeTarget or p356.activeTarget.Uid ~= p357 then
					local carry = p356.carry

					carry.generation += 1
					p356:_invalidateCarryWorker()
					p356.carryAttemptToken = nil
					p356.running = true
					p356.activeTarget = v1304
					task.defer(function()
						if not p356.destroyed and p356.enabled and not p356.carry.active then
							p356:_reStealDroppedEgg(p357)
						end
					end)

					return true
				end
			end

			return true
		end
		t46._hasConfirmedCarry = function(p358, p359)
			if not p358.carry.active then
				return false
			end

			if p359 == nil or p358.carry.uid == nil then
				return true
			end

			return p358.carry.uid == p359
		end
		t46._adoptCarryFromRecord = function(p360, p361)
			if p360.carry.active and p360.carry.uid == p361 then
				return
			end

			if p360.carryTimeouts then
				p360.carryTimeouts[p361] = nil
			end

			if p360.instantPhase == "priming" and p361 == p360.primerUid then
				p360.carry.active = true
				p360.carry.uid = p361

				return
			end

			local carry = p360.carry

			carry.generation += 1
			p360:_invalidateCarryWorker()
			p360:_clearArrivalHold(p361)

			local activeTarget = p360.activeTarget

			p360.claimPresentationSuppression = {
				assetCategory = activeTarget and activeTarget.AssetCategory,
				expiresAt = os.clock() + 8
			}
			p360.carry.active = true
			p360.carry.uid = p361
			p360.carryStartTime = os.clock()

			local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

			p360.carryStartPos = activeTarget and activeTarget.BottomCFrame and activeTarget.BottomCFrame.Position or HumanoidRootPart and HumanoidRootPart.Position

			if p360.tweenRecoveryUid == p361 then
				p360.tweenRecoveryUid = nil
			end

			p360.stats.lastResult = "Carry confirmed"
			p360:_notify()
		end
		t46._recordShowsCarried = function(p362, p363)
			if type(p363) ~= "string" or p363 == "" then
				return false
			end

			local v1310 = EggState2.ReadFieldEgg(p363) or p362.records[p363]

			return type(v1310) == "table" and v1310.State == AreaEggs.States.Carried and v1310.CarrierUserId == LocalPlayer2.UserId
		end
		t46._recordShowsForeignCarry = function(p364, p365)
			if type(p365) ~= "string" or p365 == "" then
				return false
			end

			local v1311 = EggState2.ReadFieldEgg(p365) or p364.records[p365]

			return type(v1311) == "table" and v1311.State == AreaEggs.States.Carried and v1311.CarrierUserId ~= nil and v1311.CarrierUserId ~= LocalPlayer2.UserId
		end
		t46._resolveMovementSpeed = function(p366, p367)
			if not p367.Parent or p367.Health <= 0 then
				return nil
			end

			return math.clamp(p366.config.speed, 200, v721())
		end
		t46._isAreaSafe = function()
			return true
		end
		t46._feetOffset = function(p368, p369, p370)
			if p370.RigType == Enum.HumanoidRigType.R15 then
				return p369.Size.Y * 0.5 + math.max(p370.HipHeight, 0.5)
			end

			return p369.Size.Y * 0.5 + 2
		end
		t46.setAntiTrap = function(p371, p372)
			p371.config.antiTrap = p372 == true

			if p371.config.antiTrap then
				p371:_purgeTraps()
			end
		end
		t46._isForeignTrap = function(p373, p374)
			if p374.Name == "PlayerTrap" and p374:IsA("BasePart") then
				local attribute = p374:GetAttribute("Owner")

				return type(attribute) ~= "string" or attribute ~= LocalPlayer2.Name
			end

			return p374:IsA("Model") and p374.Name == "Trap" and p374:FindFirstChild("Hitbox") ~= nil
		end
		t46._purgeTrap = function(p375, p376)
			if p375.config.antiTrap and p376 then
				if p376.Parent then
					if p375:_isForeignTrap(p376) then
						pcall(p376.Destroy, p376)
					end

					return
				end
			end
		end
		t46._purgeTraps = function(p377)
			for _, v in ipairs({
				"Transient",
				"__DEBRIS"
			}) do
				local v1315 = workspace:FindFirstChild(v)

				if v1315 then
					for _, descendant in ipairs(v1315:GetDescendants()) do
						p377:_purgeTrap(descendant)
					end
				end
			end
		end

		do
			t46._syncHoverPad = function(p378, p379)
				local hoverPad = p378.hoverPad

				if not hoverPad or not hoverPad.Parent or hoverPad:GetAttribute("SenaV4RuntimeOwner") ~= p378.hoverPadOwnerId then
					return false
				end

				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				if not HumanoidRootPart or not Humanoid then
					return false
				end

				local Position = typeof(p379) == "Vector3" and p379 or HumanoidRootPart.Position
				local Y = Position.Y

				if p378.hoverPadHeightOverride ~= nil and typeof(p379) ~= "Vector3" then
					Y = p378.hoverPadHeightOverride
				end

				local n25 = 8

				if p378.hoverPadHeightOverride ~= nil then
					n25 = math.max(8, Humanoid.WalkSpeed * 2 / 15)
				end

				if math.abs(hoverPad.Size.X - n25) > 0.5 then
					hoverPad.Size = Vector3.new(n25, 1, n25)
				end

				hoverPad.CFrame = cFrameNew(Position.X, Y - p378:_feetOffset(HumanoidRootPart, Humanoid) - 0.5 - 0.05, Position.Z)

				return true
			end
		end

		do
			t46._setArrivalHold = function(p380, p381, p382)
				if typeof(p381) ~= "CFrame" then
					return
				end

				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

				if not Character or not HumanoidRootPart then
					return
				end

				p380.arrivalHold = {
					Character = Character,
					RootPart = HumanoidRootPart,
					CFrame = p381,
					Uid = p382
				}
			end
		end

		t46._clearArrivalHold = function(p383, p384)
			local arrivalHold = p383.arrivalHold

			if not arrivalHold or p384 == nil or arrivalHold.Uid == nil or arrivalHold.Uid == p384 then
				p383.arrivalHold = nil
			end
		end
		t46._enforceArrivalHold = function(p385)
			local arrivalHold = p385.arrivalHold

			if type(arrivalHold) ~= "table" or typeof(arrivalHold.CFrame) ~= "CFrame" then
				return false
			end

			if LocalPlayer2.Character ~= arrivalHold.Character or not arrivalHold.RootPart or not arrivalHold.RootPart.Parent then
				p385.arrivalHold = nil

				return false
			end

			p385:_startHoverPad()
			pcall(function()
				arrivalHold.RootPart.AssemblyLinearVelocity = Vector3.zero
				arrivalHold.RootPart.AssemblyAngularVelocity = Vector3.zero
				p385:_syncHoverPad(arrivalHold.CFrame.Position)
				arrivalHold.RootPart.CFrame = arrivalHold.CFrame
			end)
			p385:_syncHoverPad(arrivalHold.CFrame.Position)

			return true
		end
		t46._purgeOrphanHoverPads = function(p386)
			for _, child in ipairs(workspace:GetChildren()) do
				if child.Name == "__SenaV4HoverPad" and child ~= p386.hoverPad then
					pcall(child.Destroy, child)
				end
			end
		end
		t46._startHoverPad = function(p387)
			local hoverPad = p387.hoverPad

			if not hoverPad or not hoverPad.Parent or hoverPad:GetAttribute("SenaV4RuntimeOwner") ~= p387.hoverPadOwnerId then
				p387:_purgeOrphanHoverPads()

				if hoverPad and hoverPad.Parent then
					pcall(hoverPad.Destroy, hoverPad)
				end

				local Part = Instance.new("Part")

				Part.Name = "__SenaV4HoverPad"
				Part:SetAttribute("SenaV4RuntimeOwner", p387.hoverPadOwnerId)
				Part.Anchored = true
				Part.CanCollide = true
				Part.CanQuery = true
				Part.CanTouch = false
				Part.CastShadow = false
				Part.Transparency = 1
				Part.Material = Enum.Material.SmoothPlastic
				Part.Size = Vector3.new(8, 1, 8)
				p387.hoverPad = Part
				Part.Parent = workspace
			end

			p387:_syncHoverPad()

			if not p387.hoverPadConnection then
				p387.hoverPadConnection = RunService2.PreSimulation:Connect(function()
					if not p387:_syncHoverPad() then
						p387:_startHoverPad()
					end
				end)
			end

			if not p387.hoverPadPostConnection then
				p387.hoverPadPostConnection = RunService2.PostSimulation:Connect(function()
					if p387.activeTween or p387.arrivalHold then
						p387:_syncHoverPad()
					end
				end)
			end
		end

		do
			t46._stopHoverPad = function(p388)
				p388.hoverPadHeightOverride = nil

				if p388.hoverPadConnection then
					pcall(p388.hoverPadConnection.Disconnect, p388.hoverPadConnection)
					p388.hoverPadConnection = nil
				end

				if p388.hoverPadPostConnection then
					pcall(p388.hoverPadPostConnection.Disconnect, p388.hoverPadPostConnection)
					p388.hoverPadPostConnection = nil
				end

				if p388.hoverPad then
					pcall(p388.hoverPad.Destroy, p388.hoverPad)
					p388.hoverPad = nil
				end

				p388:_purgeOrphanHoverPads()
			end
		end

		do
			t46._startMovementProtection = function(p389)
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				if not Character or not HumanoidRootPart or not Humanoid then
					return false
				end

				local v1336 = math.clamp(p389.config.speed or 600, 200, v721())

				p389.protectionCharacter = Character
				p389.protectionHumanoid = Humanoid
				p389.protectionRoot = HumanoidRootPart
				v795(Character, v1336 * 1.35)
				v856(Humanoid, HumanoidRootPart, v1336)

				if not p389.integritySpoofConnection then
					p389.integritySpoofConnection = RunService2.PreSimulation:Connect(function()
						local Character2 = LocalPlayer2.Character
						local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")
						local Humanoid2 = Character2 and Character2:FindFirstChildOfClass("Humanoid")

						if not Character2 or not HumanoidRootPart2 or not Humanoid2 then
							return
						end

						local v1340 = math.clamp(p389.config.speed or 600, 200, v721())

						p389.protectionCharacter = Character2
						p389.protectionHumanoid = Humanoid2
						p389.protectionRoot = HumanoidRootPart2
						v795(Character2, v1340 * 1.35)

						if not v860(Humanoid2, HumanoidRootPart2, v1340) then
							v856(Humanoid2, HumanoidRootPart2, v1340)
						end

						p389:_enforceArrivalHold()
					end)
				end

				if not p389.arrivalHoldConnection then
					p389.arrivalHoldConnection = RunService2.Heartbeat:Connect(function()
						p389:_enforceArrivalHold()
					end)
				end

				return true
			end
		end

		t46._startFlyGrounding = function(p390)
			p390:_stopFlyGrounding()

			local v1341 = v851()

			p390._flyGroundConn = RunService2.PreSimulation:Connect(function()
				if p390.destroyed then
					return
				end

				local State = v1341 and v1341.State

				if type(State) ~= "table" or rawget(State, "CorrectionContext") ~= nil then
					return
				end

				rawset(State, "IsSupportedNow", true)
				rawset(State, "UnsupportedStartedAt", nil)

				if rawget(State, "MovementMode") ~= "Correcting" then
					rawset(State, "MovementMode", "Grounded")
				end

				local value = rawget(State, "Evidence")

				if type(value) == "table" then
					value.Flight = 0
					value.Teleport = 0
					value.Speed = 0
				end
			end)
		end
		t46._stopFlyGrounding = function(p391)
			if p391._flyGroundConn then
				pcall(p391._flyGroundConn.Disconnect, p391._flyGroundConn)
				p391._flyGroundConn = nil
			end
		end
		t46._stopMovementProtection = function(p392)
			p392:_stopFlyGrounding()

			if p392.integritySpoofConnection then
				pcall(p392.integritySpoofConnection.Disconnect, p392.integritySpoofConnection)
				p392.integritySpoofConnection = nil
			end

			if p392.arrivalHoldConnection then
				pcall(p392.arrivalHoldConnection.Disconnect, p392.arrivalHoldConnection)
				p392.arrivalHoldConnection = nil
			end

			p392:_clearArrivalHold()
			p392:_stopHoverPad()
			v799()
			v862(p392.protectionHumanoid)
			p392.protectionCharacter = nil
			p392.protectionHumanoid = nil
			p392.protectionRoot = nil
		end
		t46.travelAndWait = function(p393, p394, p395)
			local v1344 = p395 or {}

			if p393.destroyed then
				return false
			end

			if p393.travelBusy then
				if os.clock() < (p393.travelBusyUntil or 0) then
					return false
				end
			end

			if p393.activeTween and not p393.running and (not p393.activeTween.sharedTravel or v1344.preempt == true) then
				pcall(p393.activeTween.Cancel, p393.activeTween)

				local v1345 = os.clock() + 0.5

				while p393.activeTween and os.clock() < v1345 do
					task.wait(0.05)
				end
			end

			if p393.activeTween then
				return false
			end

			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				return false
			end

			p393.travelBusy = true
			p393.travelBusyUntil = os.clock() + 45

			local ok, result = pcall(function()
				local u1350
				local now = os.clock()
				local v1352 = now
				local Magnitude = (p394.Position - HumanoidRootPart.Position).Magnitude
				local v1354 = now + Magnitude / math.max(tonumber(v1344.speed) or p393.config.speed or 600, 200) + 6

				p393.travelBusyUntil = v1354 + 2
				p393:_tweenRoot(p394, nil, v1344.speed, {
					silent = true,
					sharedTravel = true,
					abort = function()
						return p393.destroyed or v1344.abort ~= nil and v1344.abort()
					end,
					onDone = function(p396)
						u1350 = p396 == true
					end
				})

				while u1350 == nil do
					local now2 = os.clock()
					local HumanoidRootPart2 = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
					local Magnitude2 = HumanoidRootPart2 and (p394.Position - HumanoidRootPart2.Position).Magnitude or math.huge

					if Magnitude2 < Magnitude - 0.5 then
						Magnitude = Magnitude2
						v1352 = now2
					end

					if p393.destroyed or v1344.abort ~= nil and v1344.abort() or now2 - v1352 >= 1.5 or v1354 <= now2 then
						if p393.activeTween and p393.activeTween.Cancel then
							pcall(p393.activeTween.Cancel)
						end

						u1350 = false

						break
					else
						task.wait(0.05)
					end
				end

				return u1350
			end)

			p393.travelBusy = false

			if ok then
				return result == true
			end

			if p393.activeTween and p393.activeTween.sharedTravel and p393.activeTween.Cancel then
				pcall(p393.activeTween.Cancel)
			end

			return false
		end

		do
			t46._tweenRoot = function(p397, p398, p399, p400, p401)
				p397:_clearArrivalHold()

				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
				local v1361 = p401 or {}

				if not HumanoidRootPart or not Humanoid then
					p397.safeStarting = false

					if not v1361.silent then
						p397:_finish("Character unavailable")

						return
					end

					if v1361.onDone then
						pcall(v1361.onDone, false)
					end

					return
				end

				local v1362 = p400 or p397:_resolveMovementSpeed(Humanoid)

				if not v1362 then
					p397.safeStarting = false

					if not v1361.silent then
						p397:_finish("Movement unavailable")

						return
					end

					if v1361.onDone then
						pcall(v1361.onDone, false)
					end

					return
				end

				local v1363 = math.clamp(v1362, 200, v721())

				p397:_startMovementProtection()
				pcall(v760, Character)

				local CurrentCamera = workspace.CurrentCamera

				if CurrentCamera and CurrentCamera.CameraSubject ~= Humanoid then
					pcall(function()
						CurrentCamera.CameraSubject = Humanoid
					end)
				end

				local AutoRotate = Humanoid.AutoRotate

				Humanoid.AutoRotate = false

				local v1366 = v1361.flightProfile == true and p397:_resolveRouteCruiseY(HumanoidRootPart, p398) or nil
				local activeTween = {
					sharedTravel = v1361.sharedTravel == true,
					routeCruiseY = v1366,
					travelPhase = v1366 and "takeoff" or nil,
					zigzag = p397.config.stealMode == "Zig-Zag",
					zigT = 0,
					zigLast = 0
				}

				p397.activeTween = activeTween
				p397:_startHoverPad()

				local u1368 = false
				local connection
				local now
				local u1371
				local n26 = 0

				local function v1373(p402)
					if u1368 then
						return
					end

					u1368 = true
					now = nil

					if Humanoid.Parent ~= nil then
						Humanoid.AutoRotate = AutoRotate
					end

					if p402 and v1361.holdAfterArrival then
						p397:_setArrivalHold(p398, v1361.holdUid)
					end

					if v1361.onDone then
						pcall(v1361.onDone, p402 == true)
					end

					if connection then
						connection:Disconnect()
						connection = nil
					end

					if p397.activeTween == activeTween then
						p397.activeTween = nil
					end

					if not p397.arrivalHold then
						p397:_stopHoverPad()
					end

					if not p397.enabled then
						p397:_stopMovementProtection()
					end

					pcall(function()
						if LocalPlayer2.Character == Character and HumanoidRootPart.Parent then
							HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						end
					end)

					if p402 and LocalPlayer2.Character == Character and Humanoid.Parent ~= nil and p399 then
						p399()
					end
				end

				activeTween.Cancel = function()
					v1373(false)
				end
				connection = RunService2.Heartbeat:Connect(function(dt)
					if v1361.abort and v1361.abort() then
						v1373(false)

						return
					end

					if p397.destroyed or p397.activeTween ~= activeTween then
						v1373(false)

						return
					end

					if v1361.carryTarget then
						if (activeTween.nextTargetCheck or 0) <= os.clock() then
							activeTween.nextTargetCheck = os.clock() + 0.1

							local Uid = v1361.carryTarget.Uid
							local v1375 = EggState2.ReadFieldEgg(Uid)
							local State = v1375 and v1375.State

							if State ~= AreaEggs.States.Slot and State ~= AreaEggs.States.Dropped and State ~= "GuardCarried" and (not v1375 or v1375.CarrierUserId ~= LocalPlayer2.UserId) and not p397:_hasConfirmedCarry(Uid) then
								v1373(false)

								local __SenaV4PlayerSteal = genv.__SenaV4PlayerSteal

								p397:_finish(State == "Carried" and __SenaV4PlayerSteal ~= nil and __SenaV4PlayerSteal:intercept(Uid) and "Target taken - chasing the carrier" or "Target taken by someone else")

								return
							end
						end
					end

					pcall(function()
						local v1378 = math.clamp(p400 or p397.config.speed or v1363, 200, v721())

						v795(Character, v1378 * 1.35)

						local __SenaV4StealAnEggIntegritySpoof = v781().__SenaV4StealAnEggIntegritySpoof
						local State = type(__SenaV4StealAnEggIntegritySpoof) == "table" and __SenaV4StealAnEggIntegritySpoof.State or nil

						if not v855(State, Humanoid, HumanoidRootPart) then
							u1371 = nil
							now = nil
							HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
							HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
							p397:_syncHoverPad(HumanoidRootPart.Position)

							if v854(State, Humanoid, HumanoidRootPart) then
								v831(State, v1378 * 1.35, Vector3.zero)
							else
								v856(Humanoid, HumanoidRootPart, v1378)
							end

							return
						end

						local Position = HumanoidRootPart.Position
						local v1382 = p398.Position - Position
						local Magnitude = v1382.Magnitude
						local vector33 = Vector3.new(v1382.X, 0, v1382.Z)
						local Magnitude2 = vector33.Magnitude
						local Position2 = p398.Position

						if activeTween.routeCruiseY then
							if activeTween.travelPhase == "takeoff" then
								if activeTween.routeCruiseY - 0.5 <= Position.Y then
									activeTween.travelPhase = "cruise"
								else
									Position2 = Vector3.new(Position.X, activeTween.routeCruiseY, Position.Z)
								end
							end

							if activeTween.travelPhase == "cruise" then
								if Magnitude2 <= 4 then
									activeTween.travelPhase = "descend"
								else
									Position2 = Vector3.new(p398.Position.X, activeTween.routeCruiseY, p398.Position.Z)
								end
							end

							if activeTween.travelPhase == "descend" then
								Position2 = p398.Position
							end
						end

						local v1387 = Position2 - Position
						local Magnitude3 = v1387.Magnitude
						local routeCruiseY = activeTween.routeCruiseY and Magnitude2 or Magnitude

						if u1371 and u1371 + 2 < routeCruiseY then
							n26 = os.clock() + 0.5
						end

						u1371 = routeCruiseY

						local v1390 = os.clock() < n26 and math.max(200, v1378 * 0.45) or v1378

						if v1361.carryTarget and not activeTween.__earlyCarrySpam and Magnitude <= 30 then
							activeTween.__earlyCarrySpam = true

							local carryTarget = v1361.carryTarget
							local Uid = carryTarget.Uid
							local v1393 = AreaEggSlotIdentity.LooksLikeFirstAreaUid(Uid) and AreaEggSlotIdentity.SlotKey(carryTarget.AreaId, carryTarget.NestId) or nil

							task.spawn(function()
								while not p397.destroyed and p397.enabled and p397.activeTween == activeTween and not p397:_hasConfirmedCarry(Uid) do
									pcall(v730, Uid, v1393)
									task.wait(0.08)
								end
							end)
						end

						local v1394 = math.max(math.min(dt, 0.15), 0.0041666666666666666)
						local v1395 = v1390 * v1394
						local v1396 = vector33
						local vector34 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z)
						local Unit = v1396.Magnitude > 0.001 and v1396.Unit or vector34.Magnitude > 0.001 and vector34.Unit or Vector3.new(0, 0, -1)

						if (not activeTween.routeCruiseY or activeTween.travelPhase == "descend") and Magnitude <= math.max(v1395, 0.05) then
							if Magnitude > 0.5 then
								now = nil
							end

							p397:_syncHoverPad(p398.Position)
							HumanoidRootPart.CFrame = lookAt(p398.Position, p398.Position + Unit)
							HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
							p397:_syncHoverPad(p398.Position)
							v860(Humanoid, HumanoidRootPart, v1378, Vector3.zero)
							now = now or os.clock()

							if os.clock() - now >= 0.4 then
								v1373(true)
							end

							return
						end

						now = nil

						if Magnitude3 <= 0.001 then
							HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
							HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
							p397:_syncHoverPad(Position)

							return
						end

						if not p397.hoverPad or not p397.hoverPad.Parent then
							p397:_startHoverPad()
						end

						local v1399 = math.min(v1395, Magnitude3)
						local v1400 = Position + v1387.Unit * v1399

						if v1394 >= 0.033333333333333333 and (not activeTween.routeCruiseY or activeTween.travelPhase ~= "cruise") then
							local v1401 = p397:_groundYAt(v1400.X, v1400.Z, Character)

							if v1401 then
								local v1402 = v1401 + p397:_feetOffset(HumanoidRootPart, Humanoid)

								if v1400.Y < v1402 then
									v1400 = Vector3.new(v1400.X, v1402, v1400.Z)
								end
							end
						end

						if activeTween.zigzag and (not activeTween.routeCruiseY or activeTween.travelPhase == "cruise") then
							local vector35 = Vector3.new(v1387.X, 0, v1387.Z)

							if vector35.Magnitude > 1 and Magnitude2 > 12 then
								local Unit2 = vector35.Unit
								local vector36 = Vector3.new(-Unit2.Z, 0, Unit2.X)
								local v1406 = math.min(30, Magnitude2 * 0.3)

								if Magnitude2 < 120 then
									v1406 *= Magnitude2 / 120
								end

								activeTween.zigT = (activeTween.zigT or 0) + v1399

								local zigLast = v1406 * math.sin(activeTween.zigT / 900 * 3.1415926535897931 * 2)
								local zigLast2 = activeTween.zigLast or 0

								activeTween.zigLast = zigLast
								v1400 += vector36 * (zigLast - zigLast2)

								if not activeTween.zigLaneMin then
									local v1409, v1410 = v1179()

									activeTween.zigLaneMin = v1409
									activeTween.zigLaneMax = v1410
								end

								local v1411 = math.clamp(v1400.Z, activeTween.zigLaneMin, activeTween.zigLaneMax)

								if v1411 ~= v1400.Z then
									v1400 = Vector3.new(v1400.X, v1400.Y, v1411)
								end
							else
								activeTween.zigLast = 0
							end
						end

						local v1412 = (v1400 - Position) / v1394

						p397:_syncHoverPad(v1400)
						HumanoidRootPart.CFrame = lookAt(v1400, v1400 + Unit)
						HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						p397:_syncHoverPad(v1400)

						if not v860(Humanoid, HumanoidRootPart, v1378, v1412) then
							v856(Humanoid, HumanoidRootPart, v1378)
							v860(Humanoid, HumanoidRootPart, v1378, v1412)
						end
					end)
				end)
			end
		end

		t46._reStealDroppedEgg = function(p403, p404)
			if type(p404) ~= "string" or p404 == "" then
				p403:_finish("Egg lost — retrying")

				return
			end

			if p403:isSkippedEgg(p404) then
				return
			end

			if p403.tweenRecoveryUid == p404 then
				p403.running = false
				p403.activeTarget = nil
				p403:_releaseOperation()
				p403:_scheduleMovementRetry()

				return
			end

			local v1413 = p403:_claimCarryWorker("re-steal", p404)

			if not v1413 then
				return
			end

			if genv.__SenaV4GodMode then
				genv.__SenaV4GodMode:startDefend(p404)
			end

			local v1414
			local v1415 = os.clock() + 5

			p403:_setStatus("Re-stealing dropped egg")

			while p403:_isCarryWorkerCurrent(v1413) and os.clock() < v1415 do
				local v1416 = EggState2.ReadFieldEgg(p404) or p403.records[p404]

				if v1416 and (v1416.State == AreaEggs.States.Dropped or v1416.State == AreaEggs.States.Slot) then
					v1414 = v1416

					break
				else
					task.wait(0.03)
				end
			end

			if not p403:_isCarryWorkerCurrent(v1413) then
				return
			end

			if not v1414 or not p403:_wallOpen() then
				p403:_releaseCarryWorker(v1413)
				p403:_finish("Egg lost — retrying")

				return
			end

			p403:_cancelTween("Re-stealing dropped egg", true)

			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			local v1420 = p403:_resolveEggDestination(v1414, HumanoidRootPart, Humanoid)
			local v1421 = v1420 and p403:_resolveElevatedDestination(HumanoidRootPart, v1420) or nil

			if not v1421 then
				p403:_releaseCarryWorker(v1413)
				p403:_finish("Character unavailable")

				return
			end

			p403.running = true
			p403.activeTarget = v1414
			p403:_setStatus("Bringing egg home")

			if p403:_regrabBurst(v1413, v1414.Uid, 3.5) or not p403:_isCarryWorkerCurrent(v1413) then
				return
			end

			p403:_setStatus("Re-stealing egg")

			if not p403:_teleportRoot(HumanoidRootPart, Humanoid, v1421) then
				p403:_releaseCarryWorker(v1413)
				p403:_finish("Re-steal failed — retrying")

				return
			end

			p403:_setArrivalHold(v1421, v1414.Uid)
			p403:_setStatus("Re-stealing egg")

			if p403:_isCarryWorkerCurrent(v1413) then
				p403:_requestCarry(v1414, true)
			end
		end

		do
			t46._regrabBurst = function(p405, p406, p407, p408)
				local function v1422()
					local v1423 = EggState2.ReadFieldEgg(p407)

					return v1423 ~= nil and v1423.State == AreaEggs.States.Carried and v1423.CarrierUserId == LocalPlayer2.UserId
				end

				local RagdollJoints

				pcall(function()
					RagdollJoints = require(ReplicatedStorage2.Shared.Modules.RagdollJoints)
				end)

				local u1425 = false
				local u1426 = false
				local v1427 = os.clock() + p408

				while true do
					if not (os.clock() < v1427) or p405.destroyed or not p405.enabled and not p405._externalDeliver then
						return v1422()
					end

					if v1422() then
						break
					end

					if not p405:_isCarryWorkerCurrent(p406) then
						return v1422()
					end

					local v1428 = EggState2.ReadFieldEgg(p407)

					if not v1428 or v1428.State ~= AreaEggs.States.Dropped and v1428.State ~= AreaEggs.States.Slot then
						return false
					end

					local Character = LocalPlayer2.Character
					local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

					if not HumanoidRootPart or not Humanoid then
						return false
					end

					pcall(function()
						if RagdollJoints and RagdollJoints.Release then
							RagdollJoints.Release(Character)
						end

						Humanoid.PlatformStand = false
						Humanoid.Sit = false

						if Humanoid:GetState() ~= Enum.HumanoidStateType.Running then
							Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
						end
					end)

					local v1432 = p405:_resolveEggDestination(v1428, HumanoidRootPart, Humanoid)

					if v1432 then
						HumanoidRootPart.CFrame = v1432
						HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
						p405:_syncHoverPad(v1432.Position)
					end

					if not u1425 then
						u1425 = true
						task.spawn(function()
							pcall(function()
								EggWorld.AskFieldEggCarry:InvokeServer({
									Uid = p407
								})
							end)
							u1425 = false
						end)
					end

					if not u1426 then
						u1426 = true
						task.spawn(function()
							pcall(EggState2.CarryFieldEgg, p407)
							u1426 = false
						end)
					end

					pcall(function()
						local AreaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
						local v1434 = AreaEggSlotsClient and AreaEggSlotsClient:FindFirstChild(tostring(p407))
						local CarryAreaEgg = v1434 and (v1434:FindFirstChild("CarryAreaEgg", true) or v1434:FindFirstChildWhichIsA("ProximityPrompt", true))

						if CarryAreaEgg and CarryAreaEgg.Enabled and type(fireproximityprompt) == "function" then
							CarryAreaEgg.HoldDuration = 0
							CarryAreaEgg.RequiresLineOfSight = false
							fireproximityprompt(CarryAreaEgg, 0)
						end
					end)
					task.wait(0.06)
				end

				return true
			end
		end

		t46._recoverCarryConfirmationTimeout = function(p409, p410, p411)
			if p409.destroyed or not p409.enabled or p409.carryAttemptToken ~= p410 or p409:_hasConfirmedCarry(p411) then
				return false
			end

			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local v1438 = HumanoidRootPart and p409:_resolveSafeCFrame(HumanoidRootPart)
			local v1439 = v1438 and p409:_resolveElevatedDestination(HumanoidRootPart, v1438) or nil

			p409.carryTimeouts = p409.carryTimeouts or {}

			local v1440 = (p409.carryTimeouts[p411] or 0) + 1
			local v1441 = v1440 >= 2

			if v1441 then
				p409.carryTimeouts[p411] = nil
				p409.skippedEggs[p411] = os.clock() + 45
				p409.tweenRecoveryUid = nil
			else
				p409.carryTimeouts[p411] = v1440
				p409.tweenRecoveryUid = not p409:_isPrimerEgg(p411) and p411 or nil
			end

			local lastCarryReject = p409.stats.lastCarryReject
			local v1443 = p409.records[p411] or EggState2.ReadFieldEgg(p411)
			local v1444 = p409.config.stealMode == "Instant" and (p411 == p409.primerUid or type(v1443) == "table" and v1443.AreaId == "Forest")
			local carry = p409.carry

			carry.generation += 1
			p409:_invalidateCarryWorker()
			p409.carryAttemptToken = nil
			p409:_clearArrivalHold(p411)

			if p409.activeTween and p409.activeTween.Cancel then
				pcall(p409.activeTween.Cancel, p409.activeTween)
			end

			p409.activeTween = nil
			p409.running = true
			p409.activeTarget = nil
			p409.stats.lastResult = "Carry confirmation timeout"

			if HumanoidRootPart and v1439 then
				pcall(function()
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				end)
				p409:_setStatus("Carry timeout - returning to safe area")
				pcall(p409._glideRoot, p409, v1439, function()
					return p409.destroyed or not p409.enabled
				end)

				if v1441 then
					p409:_setStatus(lastCarryReject and "Carry refused (" .. lastCarryReject .. ") — skipping egg" or "Carry timed out twice — skipping egg")
				else
					p409:_setStatus("Carry timeout — retrying")
				end
			else
				p409:_setStatus("Carry timeout — safe area unavailable")
			end

			p409.running = false
			p409:_releaseOperation()

			if v1444 then
				p409.running = true
			end

			task.delay(0.35, function()
				if v1444 then
					if not p409.destroyed and p409.enabled then
						p409:_setStatus("Retrying steal")
						pcall(p409._treadmillReset, p409, function()
							return p409.destroyed or not p409.enabled
						end)
					end

					p409.running = false
				end

				if not p409.destroyed and p409.enabled and p409.carryAttemptToken == nil then
					p409:_schedule()
				end
			end)

			return true
		end
		t46._requestCarry = function(p412, p413, p414)
			if not p412:_wallOpen() then
				p412:_finish("Wall closed before carry")

				return
			end

			local Uid = p413.Uid
			local carryAttemptToken = {}
			local u1448

			p412.stats.lastCarryReject = nil

			local v1449 = p412.instantPhase == "priming" and Uid == p412.primerUid and 5 or math.max(5, p412:_resolveSettleSeconds(p413) + 3)

			p412.carryAttemptToken = carryAttemptToken
			p412.stats.lastResult = "Carry requested"
			p412:_setStatus("Securing egg")

			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if Humanoid then
				pcall(Humanoid.UnequipTools, Humanoid)
			end

			if p412.coordinator then
				local v1452 = os.clock() + 0.35

				while p412.coordinator:isBackgroundBusy() and not p412.destroyed and p412.enabled and p412.carryAttemptToken == carryAttemptToken and os.clock() < v1452 do
					task.wait(0.02)
				end

				if Humanoid and Humanoid.Parent then
					pcall(Humanoid.UnequipTools, Humanoid)
				end
			end

			task.spawn(function()
				while not p412.destroyed and p412.enabled and p412.running and p412.carryAttemptToken == carryAttemptToken and p412.activeTarget and p412.activeTarget.Uid == Uid do
					if not p412:_hasConfirmedCarry(Uid) and p412:_recordShowsCarried(Uid) then
						p412:_adoptCarryFromRecord(Uid)
					end

					if p412:_hasConfirmedCarry(Uid) then
						if not p412:_recordShowsCarried(Uid) then
							p412:_setStatus("Confirming carry record")
							task.wait(0.25)

							continue
						end

						p412:_clearArrivalHold(Uid)
						p412.carryAttemptToken = nil

						if p412.activeTween then
							pcall(p412.activeTween.Cancel, p412.activeTween)
							p412.activeTween = nil
						end

						if p412.instantPhase == "priming" and Uid == p412.primerUid then
							p412.carry.active = true
							p412.carry.uid = Uid
							p412.stats.lastResult = "Preparing steal"
							p412:_enterBaitWait()

							return
						end

						p412.carry.active = true
						p412.carry.uid = Uid
						p412.stats.lastResult = "Carry confirmed"
						p412:_setStatus("Carry confirmed")
						task.defer(function()
							if not p412.destroyed and p412.enabled and p412:_hasConfirmedCarry(Uid) then
								p412:_returnToSafe()
							end
						end)

						return
					end

					if u1448 and u1448 <= os.clock() then
						p412:_recoverCarryConfirmationTimeout(carryAttemptToken, Uid)

						return
					end

					if not p412:_wallOpen() then
						p412:_finish("Wall closed before carry")

						return
					end

					local v1453 = EggState2.ReadFieldEgg(Uid) or p412.records[Uid]

					if not v1453 then
						p412:_finish("Target unavailable")

						return
					end

					if v1453.State == AreaEggs.States.Carried then
						if v1453.CarrierUserId == LocalPlayer2.UserId then
							p412:_setStatus("Confirming carry state")
							task.wait(0.25)

							continue
						end

						p412:_finish("Egg carried by another player")

						return
					end

					if v1453.State ~= AreaEggs.States.Slot and v1453.State ~= AreaEggs.States.Dropped then
						p412:_finish("Target changed")

						return
					end

					local Character2 = LocalPlayer2.Character
					local HumanoidRootPart = Character2 and Character2:FindFirstChild("HumanoidRootPart")

					if not HumanoidRootPart then
						p412:_finish("Character unavailable")

						return
					end

					local Humanoid2 = Character2 and Character2:FindFirstChildOfClass("Humanoid")

					if not Humanoid2 then
						p412:_finish("Character unavailable")

						return
					end

					local v1457 = p412:_resolveEggDestination(v1453, HumanoidRootPart, Humanoid2)
					local v1458 = v1457 and p412:_resolveElevatedDestination(HumanoidRootPart, v1457) or nil

					if not v1458 then
						p412:_finish("Character unavailable")

						return
					end

					if (HumanoidRootPart.Position - v1458.Position).Magnitude > 10 then
						if not p414 then
							p412:_setStatus("Re-approaching egg")

							local u1459 = false

							p412:_tweenRoot(v1457, function()
								u1459 = true

								if p412.carryAttemptToken == carryAttemptToken and not p412:_hasConfirmedCarry(Uid) then
									p412:_setStatus("Securing egg")
								end
							end, nil, {
								holdAfterArrival = true,
								holdUid = Uid,
								flightProfile = true
							})

							while not p412.destroyed and p412.enabled and p412.carryAttemptToken == carryAttemptToken and not p412:_hasConfirmedCarry(Uid) and not u1459 do
								task.wait(0.25)
							end

							continue
						end

						p412:_setStatus("Re-stealing egg")

						if not p412:_teleportRoot(HumanoidRootPart, Humanoid2, v1458) then
							p412:_finish("Re-steal failed — retrying")

							return
						end

						p412:_setArrivalHold(v1458, Uid)
						p412:_setStatus("Re-stealing egg")
					end

					local ok, result, lastCarryReject = pcall(v730, v1453.Uid, AreaEggSlotIdentity.LooksLikeFirstAreaUid(v1453.Uid) and AreaEggSlotIdentity.SlotKey(v1453.AreaId, v1453.NestId) or nil)

					if not ok then
						lastCarryReject = tostring(result)
					elseif result == true then
						lastCarryReject = nil
					end

					if lastCarryReject then
						p412.stats.lastCarryReject = lastCarryReject

						if lastCarryReject ~= p412._lastCarryRejectLogged then
							p412._lastCarryRejectLogged = lastCarryReject
							warn("[Sena Steal] carry refused: " .. lastCarryReject)
						end
					end

					u1448 = u1448 or os.clock() + v1449
					p412.stats.lastResult = "Carry requested"
					p412:_setStatus(lastCarryReject and "Waiting for carry · " .. lastCarryReject or "Waiting for carry confirmation")
					task.wait(0.25)
				end
			end)
		end
		t46._burstHold = function(p415, p416, p417)
			if typeof(p416) ~= "CFrame" then
				return false
			end

			local Position = p416.Position

			local function v1464()
				local Character = LocalPlayer2.Character

				return Character and Character:FindFirstChild("HumanoidRootPart")
			end
			local function v1466(p418)
				p418.CFrame = p416
				p418.AssemblyLinearVelocity = Vector3.zero
				p418.AssemblyAngularVelocity = Vector3.zero
			end

			local v1467 = os.clock() + 0.7

			while true do
				if os.clock() < v1467 then
					if p417 and p417() then
						break
					end

					local v1468 = v1464()

					if not v1468 or not v1468.Parent then
						return false
					end

					pcall(v1466, v1468)
					RunService2.Heartbeat:Wait()

					continue
				end

				local v1469 = os.clock() + 3
				local now

				while true do
					if not (os.clock() < v1469) then
						local v1471 = v1464()
						local v1472 = v1471 ~= nil and (v1471.Position - Position).Magnitude <= 6

						return v1472
					end

					if p417 and p417() then
						break
					end

					local v1473 = v1464()

					if not v1473 or not v1473.Parent then
						return false
					end

					if (v1473.Position - Position).Magnitude > 6 then
						now = nil
					elseif not now then
						now = os.clock()
					elseif os.clock() - now >= 0.45 then
						return true
					end

					pcall(v1466, v1473)
					RunService2.Heartbeat:Wait()
				end

				return false
			end

			return false
		end
		t46._isStealPrompt = function(p419, p420)
			if typeof(p420) ~= "Instance" then
				return false
			end

			if p420.Name == "EnchantedTreePrompt" then
				return true
			end

			local AreaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")

			if AreaEggSlotsClient and p420:IsDescendantOf(AreaEggSlotsClient) then
				return true
			end

			if p420:FindFirstAncestor("FuseBiomeLanePortals") or p420:FindFirstAncestor("FuseBiomeZone") then
				return true
			end

			return false
		end
		t46._installPromptFilter = function(p421)
			if p421._promptFilter or type(getconnections) ~= "function" then
				return
			end

			local promptFilter = {
				muted = {},
				forwarders = {}
			}

			p421._promptFilter = promptFilter

			local function v1476()
				return not p421.destroyed and (p421.enabled or p421._externalDeliver or p421._recalling or p421._treeFxMuted ~= nil)
			end

			for _, v in ipairs({
				ProximityPromptService.PromptShown,
				ProximityPromptService.PromptHidden
			}) do
				local ok, result = pcall(getconnections, v)
				local ipairs_ = ipairs
				local v1482 = ok and type(result) == "table" and result or {}

				for _, v2 in ipairs_(v1482) do
					local Function = v2.Function
					local v1486 = false
					local result2

					if type(Function) == "function" then
						v1486, result2 = pcall(debug.info, Function, "s")
					end

					if v1486 then
						if tostring(result2):find("ProximityPromptScriptController", 1, true) and type(v2.Disable) == "function" and pcall(v2.Disable, v2) then
							table.insert(promptFilter.muted, v2)
							table.insert(promptFilter.forwarders, v:Connect(function(p422, ...)
								if v1476() then
									if p421:_isStealPrompt(p422) then
										return
									end
								end

								Function(p422, ...)
							end))
						end
					end
				end
			end
		end
		t46._removePromptFilter = function(p423)
			local _promptFilter = p423._promptFilter

			if not _promptFilter then
				return
			end

			p423._promptFilter = nil

			for _, forwarder in ipairs(_promptFilter.forwarders) do
				pcall(forwarder.Disconnect, forwarder)
			end

			for _, v in ipairs(_promptFilter.muted) do
				pcall(v.Enable, v)
			end
		end
		t46._treadmillReset = function(p424, p425)
			p424._treadmillResetting = true

			local ok, result = pcall(p424._treadmillResetInner, p424, p425)

			p424._treadmillResetting = false

			return ok and result
		end
		t46._treadmillResetInner = function(p426, p427)
			local function v1495()
				return p427 ~= nil and p427()
			end

			local Treadmill = Remotes and Remotes.Treadmill

			if not Treadmill or v1495() then
				return false
			end

			local function v1497()
				local ok, result = pcall(function()
					return Treadmill.AskRenderSnapshot:InvokeServer()
				end)

				if ok and type(result) == "table" then
					return table.find(result, LocalPlayer2.UserId) ~= nil
				end

				return nil
			end
			local function v1500()
				local ok, result = pcall(function()
					local v1503 = type(PlotState2.ResolveLocalSlot) == "function" and PlotState2.ResolveLocalSlot() or PlotState2.GetMySlot()
					local v1504 = type(PlotState2.ResolveFolder) == "function" and PlotState2.ResolveFolder() or PlotState2.GetPlotsFolder()
					local v1505 = v1504 and v1503 and v1504:FindFirstChild(tostring(v1503))
					local TreadmillBottom = v1505 and v1505:FindFirstChild("TreadmillBottom")

					if not TreadmillBottom or not TreadmillBottom:IsA("BasePart") then
						return nil
					end

					local Character = LocalPlayer2.Character
					local HumanoidRootPart = Character
					local Humanoid, v1510

					if HumanoidRootPart then
						HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

						if Character then
							Humanoid = Character:FindFirstChildOfClass("Humanoid")

							if HumanoidRootPart and Humanoid then
								if Humanoid.RigType == Enum.HumanoidRigType.R15 then
									v1510 = HumanoidRootPart.Size.Y * 0.5 + math.max(Humanoid.HipHeight, 0.5)

									if not v1510 then
										v1510 = HumanoidRootPart.Size.Y * 0.5 + 2

										return TreadmillBottom.CFrame * cFrameNew(0, TreadmillBottom.Size.Y * 0.5 + v1510 + 0.05, 0)
									end
								else
									v1510 = HumanoidRootPart.Size.Y * 0.5 + 2
								end

								return TreadmillBottom.CFrame * cFrameNew(0, TreadmillBottom.Size.Y * 0.5 + v1510 + 0.05, 0)
							end
						end
					elseif Character then
						Humanoid = Character:FindFirstChildOfClass("Humanoid")

						if HumanoidRootPart and Humanoid then
							if Humanoid.RigType == Enum.HumanoidRigType.R15 then
								v1510 = HumanoidRootPart.Size.Y * 0.5 + math.max(Humanoid.HipHeight, 0.5)

								if not v1510 then
									v1510 = HumanoidRootPart.Size.Y * 0.5 + 2

									return TreadmillBottom.CFrame * cFrameNew(0, TreadmillBottom.Size.Y * 0.5 + v1510 + 0.05, 0)
								end
							else
								v1510 = HumanoidRootPart.Size.Y * 0.5 + 2
							end

							return TreadmillBottom.CFrame * cFrameNew(0, TreadmillBottom.Size.Y * 0.5 + v1510 + 0.05, 0)
						end
					end

					return nil
				end)
				local v1511 = ok and result or nil

				return v1511
			end

			local v1512 = v1500()

			if not v1512 or v1495() then
				return false
			end

			p426:_glideRoot(v1512, function()
				return v1495()
			end)

			if v1495() then
				return false
			end

			local v1513 = false
			local v1514 = os.clock() + 0.7

			if not v1495() and os.clock() < v1514 then
				while true do
					pcall(function()
						Treadmill.AskWearStill:InvokeServer()
					end)
					task.wait(0.08)

					if v1497() == true then
						v1513 = true

						break
					elseif v1495() or not (os.clock() < v1514) then
						break
					end
				end

				if v1513 then
					local v1515 = os.clock() + 0.25

					while not v1495() do
						if not (os.clock() < v1515) then
							break
						end

						task.wait(0.05)
					end
				end
			end

			local v1516 = false
			local v1517 = os.clock() + 0.7

			while not v1495() and os.clock() < v1517 do
				pcall(function()
					Treadmill.AskDoff:InvokeServer()
				end)
				task.wait(0.08)

				if v1497() == false then
					v1516 = true

					break
				end
			end

			local v1518 = v1513 and v1516

			return v1518
		end
		t46._instantReturn = function(p428, p429)
			if p428._instantReturnToken ~= nil then
				return
			end

			local instantReturnToken = {}

			p428._instantReturnToken = instantReturnToken
			p428._flyDeparting = false

			if p428.config.stealMode == "Fly" then
				p428:_showTreadmillDecoy()
			end

			task.spawn(function()
				local function v1520()
					return not p428.destroyed and (p428.enabled or p428._externalDeliver) and p428._instantReturnToken == instantReturnToken
				end
				local function v1521()
					local Character = LocalPlayer2.Character

					return Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
				end
				local function v1523()
					return EggState2.ReadFieldEgg(p429)
				end
				local function v1524()
					local v1525 = v1523()

					return v1525 ~= nil and v1525.State == AreaEggs.States.Carried and v1525.CarrierUserId == LocalPlayer2.UserId
				end
				local function v1526()
					local v1527 = v1523()

					if v1527 then
						return v1527.State == AreaEggs.States.Claimed
					end

					return true
				end
				local function v1528(p430, p431)
					local v1529, v1530 = v1521()

					if v1529 and v1530 and typeof(p430) == "CFrame" then
						if p431 then
							p428:_setStatus(p431)
						end

						p428:_teleportRoot(v1529, v1530, p430)
					end
				end
				local function v1531()
					local v1532 = v1521()

					return v1532 and p428:_resolveSafeCFrame(v1532) or nil
				end
				local function v1533(p432)
					p428.settleBonus = p428.settleBonus or {}

					if p432 then
						p428.settleBonus[p429] = nil
					elseif p428.config.stealMode == "Instant" and p428.boostedUid ~= p429 then
						p428.settleBonus[p429] = {
							seconds = 2,
							untilAt = os.clock() + 300
						}
					end
				end
				local function v1534(p433)
					if p428._instantReturnToken ~= instantReturnToken then
						return
					end

					v1533(p433 == nil or p433 == "Safe return complete")
					p428._instantReturnToken = nil
					p428._forestDropInProgress = nil

					local _externalDeliver = p428._externalDeliver

					p428._externalDeliver = nil

					if p428.destroyed then
						return
					end

					if p428.enabled then
						p428:_reportStolen()
						p428:_finish(p433 or "Safe return complete")
					elseif _externalDeliver then
						p428:_reportStolen()
						p428.carry.active = false
						p428.carry.uid = nil
						p428.activeTarget = nil
						p428:_hideTreadmillDecoy()
					end
				end

				p428:_clearArrivalHold(p429)

				local treeRegrabMode = p428.treeBoostedUid == p429 and (p428.treeRegrabMode or "walk") or "glide"

				local function v1537()
					local v1538 = v1521()

					return v1538 ~= nil and p428:_isInSafeArea(v1538)
				end
				local function v1539(p434, p435, p436)
					return p428:_walkTo(p434, p435, p436 or 4)
				end
				local function v1540(p437, p438, p439, p440)
					local v1541 = treeRegrabMode == "walk" or p440 == "egg" and (treeRegrabMode == "glideSafe" or treeRegrabMode == "skipSafe") or p440 == "safe" and treeRegrabMode == "glideEgg"

					if v1541 and p440 == "safe" then
						local v1542 = p428
						local _walkTo = p428._walkTo
						local v1544 = p437

						local function v1545()
							return p438() or v1537()
						end

						local v1546 = p439 or 4

						return _walkTo(v1542, v1544, v1545, v1546)
					end

					if not v1541 then
						return p428:_glideRoot(p437, p438)
					end

					local v1547 = p428
					local _walkTo = p428._walkTo
					local v1549 = p437
					local v1550 = p438
					local v1551 = p439 or 4

					return _walkTo(v1547, v1549, v1550, v1551)
				end

				local v1552 = p428.config.stealMode == "Fly" or p428.boostedUid == p429 and not senaV4Config.HelpFriend
				local v1553 = v1552 and 0.15 or 0.4
				local v1554 = v1552 and 0.45 or 0.85
				local v1555 = v1524()

				if not v1555 then
					p428:_setStatus("Confirming carry record")

					local v1556 = os.clock() + 2.5

					while v1520() and os.clock() < v1556 do
						v1555 = v1524()

						if not v1555 then
							local v1557 = v1523()

							if not v1557 or v1557.State ~= AreaEggs.States.Claimed then
								RunService2.Heartbeat:Wait()

								continue
							end
						end

						break
					end

					if not v1520() then
						return
					end
				end

				if v1555 then
					p428._forestDropInProgress = p429
					p428:_setStatus("Bringing egg home")
					p428:_glideRoot(cFrame, function()
						return not v1520() or not v1524()
					end)

					if not v1520() then
						return
					end

					local v1558 = false

					for i = 1, 3 do
						if not v1520() or not v1524() then
							break
						end

						p428:_setStatus("Bringing egg home")
						p428:_glideRoot(cFrame, function()
							return not v1520() or not v1524()
						end)

						if not v1520() then
							return
						end

						if v1524() then
							task.wait(v1553)

							if not v1520() then
								return
							end

							if v1524() then
								pcall(EggState2.DropFieldEgg, "PlayerRequest")
							end

							local v1560 = os.clock() + v1554

							while v1520() and v1524() and os.clock() < v1560 do
								RunService2.Heartbeat:Wait()
							end
						end

						local v1561 = v1523()

						if not v1561 or v1561.State ~= AreaEggs.States.Dropped then
							if not v1524() then
								break
							end

							continue
						end

						v1558 = true

						break
					end

					if not v1520() then
						return
					end

					if not v1558 then
						if p428._instantReturnToken == instantReturnToken then
							p428._instantReturnToken = nil
						end

						p428._forestDropInProgress = nil
						v1533(false)
						p428:_finish("Drop failed — retrying")

						return
					end

					if senaV4Config.HelpFriend then
						p428.skippedEggs[p429] = os.clock() + 1800
						p428._forestDropInProgress = nil
						p428.carry.active = false
						p428.carry.uid = nil
						p428.stats.lastResult = "Dropped for a friend"
						p428:_setStatus("Egg dropped for a friend, heading back")

						local v1562 = v1531()

						if v1562 then
							p428:_glideRoot(v1562, function()
								return not v1520()
							end)
						end

						if not v1520() then
							return
						end

						local _externalDeliver = p428._externalDeliver

						p428._instantReturnToken = nil
						p428._externalDeliver = nil

						if p428.enabled then
							p428:_finish("Dropped for a friend")
						elseif _externalDeliver then
							p428.activeTarget = nil
							p428:_hideTreadmillDecoy()
						end

						return
					end

					local Position
					local v1565 = os.clock() + 3

					while v1520() and os.clock() < v1565 do
						local v1566 = v1523()

						if v1566 and v1566.State == AreaEggs.States.Dropped then
							local BottomCFrame = v1566.BottomCFrame or v1566.BoundsCFrame

							Position = BottomCFrame and BottomCFrame.Position

							if not Position then
								task.wait(0.1)

								continue
							end
						elseif not v1566 or v1566.State == AreaEggs.States.Carried then
							task.wait(0.1)

							continue
						end

						break
					end

					if not v1520() then
						return
					end

					p428._forestDropInProgress = nil
					p428:_setStatus("Bringing egg home")

					local v1568 = treeRegrabMode ~= "skipSafe" and v1531() or nil

					if v1568 then
						v1540(v1568, function()
							return not v1520()
						end, nil, "safe")
					end

					if not v1520() then
						return
					end

					local v1569 = p428:_claimCarryWorker("instant-regrab", p429)
					local cFrame2 = Position and cFrameNew(Position + Vector3.new(0, 3.2, 0)) or cFrame

					local function v1571()
						v1540(cFrame2, function()
							return not v1520() or v1524()
						end, 3, "egg")
					end

					local v1572 = false

					if v1569 then
						p428:_setStatus("Bringing egg home")
						v1571()

						if not v1520() then
							return
						end

						v1572 = p428:_regrabBurst(v1569, p429, 0.5)

						if not v1520() then
							return
						end

						if v1524() then
							v1572 = true
						end

						if not v1572 and not v1524() and p428:_isCarryWorkerCurrent(v1569) then
							p428:_setStatus("Bringing egg home")

							local v1573 = v1531()

							if v1573 then
								p428:_glideRoot(v1573, function()
									return not v1520()
								end)
							end

							if not v1520() then
								return
							end

							p428:_setStatus("Bringing egg home")
							p428:_treadmillReset(function()
								return not v1520()
							end)

							if not v1520() then
								return
							end

							p428:_setStatus("Bringing egg home")

							local v1574 = v1531()

							if v1574 then
								p428:_glideRoot(v1574, function()
									return not v1520()
								end)
							end

							if not v1520() then
								return
							end

							if p428:_isCarryWorkerCurrent(v1569) then
								p428:_setStatus("Bringing egg home")
								v1571()

								if not v1520() then
									return
								end

								v1572 = p428:_regrabBurst(v1569, p429, 0.6)

								if not v1520() then
									return
								end
							end
						end
					end

					if not v1572 and not v1524() then
						v1534(v1526() and "Safe return complete" or "Re-grab failed — retrying")

						return
					end
				end

				if v1524() then
					p428:_setStatus("Bringing egg home")

					local v1575 = v1531()

					if v1575 then
						v1539(v1575, function()
							return not v1520() or not v1524()
						end)
					end
				end

				p428:_setStatus("Waiting for deposit")

				local v1576 = os.clock() + 8

				while v1520() and not v1526() and os.clock() < v1576 do
					local v1577, v1578 = v1521()

					if v1577 and v1578 and not p428:_isInSafeArea(v1577) then
						local v1579 = p428:_resolveSafeCFrame(v1577)

						if v1579 then
							v1539(v1579, function()
								return not v1520() or v1526()
							end)
						end
					end

					task.wait(0.1)
				end

				v1534(v1526() and "Safe return complete" or "Bank not confirmed — retrying")
			end)
		end
		t46.deliverCarriedEgg = function(p441, p442, p443)
			if type(p442) ~= "string" or p442 == "" or p441.destroyed then
				return false
			end

			if p441._instantReturnToken ~= nil then
				return false
			end

			p441._externalDeliver = true

			if type(p443) == "table" then
				p441.activeTarget = p443
			end

			p441.carry.active = true
			p441.carry.uid = p442
			p441.reportedUid = nil
			p441:_instantReturn(p442)

			if p441._instantReturnToken ~= nil then
				task.spawn(function()
					local v1580 = os.clock() + 30

					while p441._instantReturnToken ~= nil and os.clock() < v1580 do
						task.wait(0.25)
					end

					if p441._externalDeliver then
						p441._externalDeliver = nil
						p441._instantReturnToken = nil
						p441.carry.active = false
						p441.carry.uid = nil
					end
				end)

				return true
			end

			p441._externalDeliver = nil
			p441.carry.active = false
			p441.carry.uid = nil

			return false
		end
		t46._adminSteal = function(p444, p445)
			local Uid = p445.Uid

			p444._adminBusyUid = Uid

			local function v1582()
				local v1583 = EggState2.ReadFieldEgg(Uid)

				return v1583 ~= nil and v1583.State == AreaEggs.States.Carried and v1583.CarrierUserId == LocalPlayer2.UserId
			end
			local function v1584()
				return not p444.destroyed and p444.enabled and genv.__SenaV4AdminBoost == true and p444._adminBusyUid == Uid
			end

			local ok, result = pcall(function()
				p444.instantPhase = nil
				p444.primerUid = nil
				p444.targetUid = nil
				p444.activeTarget = p445
				p444.stats.lastResult = "Admin Abuse"
				p444:_setStatus("Heading to target egg")

				local v1587 = os.clock() + 3
				local n27 = 0

				while true do
					if not v1584() or v1582() then
						if not v1584() then
							return
						end

						p444.carry.active = true
						p444.carry.uid = Uid
						p444:_adminDeliver(Uid)

						return
					end

					if v1587 <= os.clock() then
						break
					end

					local v1589 = EggState2.ReadFieldEgg(Uid)

					if not v1589 or v1589.State ~= AreaEggs.States.Slot and v1589.State ~= AreaEggs.States.Dropped then
						return p444:_finish("Target egg no longer available")
					end

					local Character = LocalPlayer2.Character
					local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

					if not HumanoidRootPart or not Humanoid then
						return p444:_finish("Character unavailable")
					end

					local v1593 = p444:_resolveEggDestination(v1589, HumanoidRootPart, Humanoid)

					if v1593 and (HumanoidRootPart.Position - v1593.Position).Magnitude > 4 then
						p444:_teleportRoot(HumanoidRootPart, Humanoid, v1593)
					end

					if n27 <= os.clock() then
						n27 = os.clock() + 0.1
						p444:_setStatus("Securing egg")
						task.spawn(function()
							pcall(function()
								EggWorld.AskFieldEggCarry:InvokeServer({
									Uid = Uid
								})
							end)
						end)
					end

					RunService2.Heartbeat:Wait()
				end

				p444.skippedEggs[Uid] = os.clock() + 10

				return p444:_finish("Carry refused — next egg")
			end)

			if p444._adminBusyUid == Uid then
				p444._adminBusyUid = nil
			end

			if not ok then
				warn("[Sena Steal] admin steal error: " .. tostring(result))

				if not p444.destroyed and p444.enabled then
					p444:_finish("Steal error — retrying")
				end
			end
		end

		do
			t46._adminDeliver = function(p446, p447)
				if p446._adminDeliverUid == p447 then
					return
				end

				p446._adminDeliverUid = p447
				p446._adminBusyUid = p447

				local function v1594()
					return EggState2.ReadFieldEgg(p447)
				end
				local function v1595()
					local v1596 = v1594()

					return v1596 ~= nil and v1596.State == AreaEggs.States.Carried and v1596.CarrierUserId == LocalPlayer2.UserId
				end
				local function v1597()
					local v1598 = v1594()

					return v1598 == nil or v1598.State == AreaEggs.States.Claimed
				end

				p446:_clearArrivalHold(p447)
				p446:_setStatus("Bringing egg home")

				local v1599 = os.clock() + 4

				while not p446.destroyed and p446.enabled and not v1597() and v1595() and os.clock() < v1599 do
					local Character = LocalPlayer2.Character
					local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
					local v1603 = HumanoidRootPart and p446:_resolveSafeCFrame(HumanoidRootPart)

					if v1603 and Humanoid and (HumanoidRootPart.Position - v1603.Position).Magnitude > 4 then
						p446:_teleportRoot(HumanoidRootPart, Humanoid, v1603)
						p446:_setStatus("Waiting for deposit")
					end

					RunService2.Heartbeat:Wait()
				end

				p446._adminDeliverUid = nil

				if p446._adminBusyUid == p447 then
					p446._adminBusyUid = nil
				end

				if p446.destroyed or not p446.enabled then
					return
				end

				if v1597() then
					p446:_reportStolen()
					p446:_finish("Safe return complete")
				else
					p446:_finish(v1595() and "Bank not confirmed — retrying" or "Egg lost — retrying")
				end
			end
		end

		do
			t46._returnToSafe = function(p448)
				if p448:_isPrimerEgg(p448.carry.uid) then
					local uid = p448.carry.uid

					p448.stats.lastResult = "Steal not banked — retrying"
					p448.carry.active = false
					p448.carry.uid = nil

					local carry = p448.carry

					carry.generation += 1
					p448:_invalidateCarryWorker()
					p448.skippedEggs[uid] = os.clock() + 30
					pcall(EggState2.DropFieldEgg, "PlayerRequest")

					if p448.instantPhase == "priming" then
						p448:_startPrimerTargetHunt()
					else
						task.delay(0.5, function()
							if not p448.destroyed and p448.enabled and not p448.running then
								p448:_schedule()
							end
						end)
					end

					p448:_notify()

					return
				end

				if p448.captureObjectiveEnabled and p448:_isCaptureEgg(p448.carry.uid) then
					p448:_captureHold(p448.carry.uid)

					return
				end

				if genv.__SenaV4AdminBoost == true then
					local uid = p448.carry.uid or p448.activeTarget and p448.activeTarget.Uid

					if uid and p448._adminBusyUid ~= uid then
						task.spawn(p448._adminDeliver, p448, uid)
					end

					return
				end

				if p448.config.stealMode == "Instant" or p448.config.stealMode == "Fly" then
					local uid = p448.carry.uid or p448.activeTarget and p448.activeTarget.Uid

					if not uid then
						p448:_finish("Carry lost — retrying")

						return
					end

					p448:_instantReturn(uid)

					return
				end

				local uid = p448.carry.uid
				local v1609 = p448:_claimCarryWorker("return", uid)

				if not v1609 then
					return
				end

				p448:_clearArrivalHold(uid)

				if not p448:_wallOpen() then
					p448:_releaseCarryWorker(v1609)
					p448:_finish("Reset interrupted carry")

					return
				end

				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

				if not HumanoidRootPart then
					p448:_releaseCarryWorker(v1609)
					p448:_finish("Character unavailable")

					return
				end

				if not p448:_hasConfirmedCarry(uid) or p448:_recordShowsForeignCarry(uid) then
					p448:_releaseCarryWorker(v1609)
					p448:_finish("Carry not confirmed — retrying")

					return
				end

				if p448:_isInSafeArea(HumanoidRootPart) then
					p448:_finalizeReturn(v1609)

					return
				end

				if not senaV4Config.HelpFriend then
					local v1612 = p448:_resolveSafeCFrame(HumanoidRootPart)

					if not v1612 then
						p448:_releaseCarryWorker(v1609)
						p448:_finish("Safe destination unavailable")

						return
					end

					p448:_setStatus("Returning to safe area")
					p448:_tweenRoot(v1612, function()
						if p448:_isCarryWorkerCurrent(v1609) then
							p448:_finalizeReturn(v1609)
						end
					end, nil, {
						flightProfile = true
					})

					return
				end

				p448.handoffLane = (p448.handoffLane or 0) % #t44 + 1

				local v1613 = cFrameNew(612, vector32.Y, t44[p448.handoffLane]) * HumanoidRootPart.CFrame.Rotation

				p448:_setStatus("Taking the egg to the friend drop")
				p448:_tweenRoot(v1613, function()
					if p448:_isCarryWorkerCurrent(v1609) then
						task.spawn(p448._handOffEgg, p448, v1609, uid, v1613)
					end
				end, nil, {
					flightProfile = true
				})
			end
		end

		do
			t46._handOffEgg = function(p449, p450, p451, p452)
				local function v1614()
					local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

					if not HumanoidRootPart then
						return false
					end

					HumanoidRootPart.CFrame = p452
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero

					return true
				end
				local function v1616()
					local v1617 = EggState2.ReadFieldEgg(p451)

					return v1617 ~= nil and v1617.State == AreaEggs.States.Carried and v1617.CarrierUserId == LocalPlayer2.UserId
				end

				p449:_setStatus("Dropping the egg for a friend")

				local n28 = 0.1

				pcall(function()
					n28 = LocalPlayer2:GetNetworkPing() or 0.1
				end)

				local v1619 = os.clock() + math.max(0.3, 0.2 + 2 * n28)

				while os.clock() < v1619 and v1614() do
					RunService2.Heartbeat:Wait()
				end

				p449.skippedEggs[p451] = os.clock() + 1800
				p449:_reportStolen()

				local v1620 = false

				for i = 1, 4 do
					v1614()

					if not v1616() then
						v1620 = true

						break
					end

					pcall(EggState2.DropFieldEgg, "PlayerRequest")

					local v1622 = os.clock() + 0.6

					while true do
						RunService2.Heartbeat:Wait()
						v1620 = not v1616()

						if v1620 then
							break
						elseif v1622 <= os.clock() then
							break
						end
					end

					if v1620 then
						break
					end
				end

				if not v1620 then
					p449.skippedEggs[p451] = nil

					if p449:_isCarryWorkerCurrent(p450) then
						p449:_releaseCarryWorker(p450)
						p449:_finish("Friend drop failed — retrying")
					end

					return
				end

				local v1623 = os.clock() + 1

				while p449.carry.active and os.clock() < v1623 do
					RunService2.Heartbeat:Wait()
				end

				p449.carry.active = false
				p449.carry.uid = nil
				p449.stats.lastResult = "Dropped for a friend"

				local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
				local v1625 = HumanoidRootPart and p449:_resolveSafeCFrame(HumanoidRootPart)

				if not v1625 then
					p449:_finish("Dropped for a friend")

					return
				end

				p449:_setStatus("Egg dropped for a friend, heading back")
				p449:_tweenRoot(v1625, nil, nil, {
					flightProfile = true,
					onDone = function()
						p449:_finish("Dropped for a friend")
					end
				})
			end
		end

		do
			t46._reportStolen = function(p453)
				local activeTarget = p453.activeTarget

				if not (type(activeTarget) == "table" and activeTarget.Uid) then
					return
				end

				if p453.reportedUid == activeTarget.Uid then
					return
				end

				p453.reportedUid = activeTarget.Uid
				task.delay(1.5, function()
					if p453.destroyed then
						return
					end

					local u1627

					pcall(function()
						u1627 = EggState2.ReadFieldEgg(activeTarget.Uid)
					end)

					if type(u1627) == "table" and (u1627.State == AreaEggs.States.Slot or u1627.State == AreaEggs.States.Dropped or u1627.State == AreaEggs.States.Carried and u1627.CarrierUserId ~= LocalPlayer2.UserId) then
						p453.reportedUid = nil
						p453.stats.deliveryFailed = (p453.stats.deliveryFailed or 0) + 1
						p453.stats.lastResult = "Delivery failed — retrying"
						p453:_notify()

						if p453.enabled and not p453.running then
							p453:_schedule()
						end

						return
					end

					p453.stats.delivered = (p453.stats.delivered or 0) + 1

					local __SenaV4Webhook = genv.__SenaV4Webhook

					if not __SenaV4Webhook then
						return
					end

					local ok, result = pcall(p453.catalog.resolve, activeTarget)

					pcall(__SenaV4Webhook.stolen, activeTarget, ok and result or nil, nil)
				end)
			end
		end

		do
			t46._startWatchdog = function(p454)
				if p454.watchdogRunning then
					return
				end

				p454.watchdogRunning = true
				task.spawn(function()
					local v1631
					local now = os.clock()
					local now2
					local v1634
					local Position
					local now3

					while v16() and not p454.destroyed do
						if not p454.userStealEnabled then
							break
						end

						task.wait(2)

						local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
						local v1638 = tostring(p454.stats.status)

						if not p454.enabled or not p454.running or p454.carry.active or p454.carryAttemptToken ~= nil or p454._instantReturnToken ~= nil or p454._captureHoldUid or not HumanoidRootPart or v1638 ~= v1634 or not Position or not ((HumanoidRootPart.Position - Position).Magnitude < 3) then
							Position = HumanoidRootPart and HumanoidRootPart.Position
							v1634 = v1638
							now3 = os.clock()
						elseif os.clock() - now3 > 12 then
							v1634 = nil
							Position = nil
							now3 = nil
							v1631 = nil
							p454.stats.watchdogResets = (p454.stats.watchdogResets or 0) + 1
							pcall(function()
								p454:_invalidateCarryWorker()
							end)
							p454:_finish("Stuck - retrying")
							p454:_releaseOperation()
						end

						if not p454.enabled or p454._captureHoldUid then
							v1631 = nil
							now2 = nil
						elseif p454.running then
							now2 = nil

							local v1639 = tostring(p454.activeTarget and p454.activeTarget.Uid) .. "|" .. tostring(p454.carry.active)

							if v1639 ~= v1631 then
								v1631 = v1639
								now = os.clock()
							elseif os.clock() - now > 60 then
								v1631 = nil
								p454.stats.watchdogResets = (p454.stats.watchdogResets or 0) + 1

								local Uid = p454.activeTarget and p454.activeTarget.Uid

								if Uid and not p454.carry.active then
									p454.skippedEggs[Uid] = os.clock() + 45

									if p454.tweenRecoveryUid == Uid then
										p454.tweenRecoveryUid = nil
									end
								end

								pcall(function()
									p454:_invalidateCarryWorker()
								end)
								p454:_finish("Stuck — retrying")
							end
						else
							v1631 = nil

							local ok, result = pcall(p454._chooseTarget, p454)

							if p454:_wallOpen() and ok and result ~= nil then
								now2 = now2 or os.clock()

								if os.clock() - now2 > 6 then
									now2 = nil
									p454.stats.watchdogResets = (p454.stats.watchdogResets or 0) + 1
									p454:_releaseOperation()
									p454:_schedule()
								end
							else
								now2 = nil
							end
						end
					end

					p454.watchdogRunning = false
				end)
			end
		end

		t46._finalizeReturn = function(p455, p456)
			if not p455:_isCarryWorkerCurrent(p456) then
				return
			end

			if not p455.carry.active then
				p455:_releaseCarryWorker(p456)
				p455:_reportStolen()
				p455:_finish("Safe return complete")

				return
			end

			p455:_setStatus("Validating safe arrival")

			local now = os.clock()
			local v1644 = os.clock() + 6

			while true do
				if not p455:_isCarryWorkerCurrent(p456) or not p455.carry.active or not (os.clock() < v1644) then
					if not p455:_isCarryWorkerCurrent(p456) then
						return
					end

					if not p455.carry.active then
						p455:_releaseCarryWorker(p456)
						p455:_reportStolen()
						p455:_finish("Safe return complete")

						return
					end

					p455:_setStatus("Deposit pending — validating again")
					task.defer(function()
						if p455:_isCarryWorkerCurrent(p456) and p455.carry.active then
							p455:_finalizeReturn(p456)
						end
					end)

					return
				end

				local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

				if not HumanoidRootPart then
					p455:_releaseCarryWorker(p456)
					p455:_finish("Character unavailable")

					return
				end

				if not p455:_isInSafeArea(HumanoidRootPart) then
					break
				end

				if os.clock() - now >= 0.35 then
					p455:_setStatus("Waiting for deposit")
				end

				task.wait(0.08)
			end

			p455:_setStatus("Rollback detected — returning again")
			p455:_releaseCarryWorker(p456)
			task.defer(function()
				if not p455.destroyed and p455.enabled and p455.carry.active then
					p455:_returnToSafe()
				end
			end)
		end
		t46._finish = function(p457, p458)
			p457:_noteLowSpeedOutcome(p458)
			p457:_hideTreadmillDecoy()
			p457._forestDropInProgress = nil
			p457._instantReturnToken = nil
			p457.boostedUid = nil
			p457:_invalidateCarryWorker()
			p457.planGeneration += 1
			p457:_cancelTween(p458, p457.enabled)
			p457:_setStatus(p457.enabled and "Searching" or "Idle")

			if p457.enabled then
				task.delay(0.05, function()
					if p457.destroyed or not p457.enabled then
						p457:_releaseOperation()

						return
					end

					p457:_schedule()
				end)
			end
		end
		t46._scheduleMovementRetry = function(p459)
			if p459.movementRetryPending or p459.destroyed or not p459.enabled then
				return
			end

			p459.movementRetryPending = true
			task.delay(0.2, function()
				p459.movementRetryPending = false

				if not p459.destroyed and p459.enabled then
					p459:_schedule()
				end
			end)
		end
		t46._schedule = function(p460)
			if not p460.running then
				p460.safeStarting = false
			end

			if p460.destroyed or not p460.enabled or p460.running then
				return
			end

			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if not HumanoidRootPart or not Humanoid then
				p460:_releaseOperation()
				p460:_setStatus("Character unavailable")

				return
			end

			p460:_startMovementProtection()

			if p460.carry.active and p460.carry.uid ~= nil then
				if p460.instantPhase == "priming" and p460.carry.uid == p460.primerUid then
					return
				end

				if p460:_isPrimerEgg(p460.carry.uid) then
					p460:_setStatus("Dropping primer egg")
					p460.skippedEggs[p460.carry.uid] = os.clock() + 30
					pcall(EggState2.DropFieldEgg, "PlayerRequest")
					task.delay(0.5, function()
						if not p460.destroyed and p460.enabled then
							p460:_schedule()
						end
					end)

					return
				end

				local v1649 = p460.records[p460.carry.uid] or EggState2.ReadFieldEgg(p460.carry.uid)
				local captureObjectiveEnabled = type(v1649) == "table" and (p460.riftWants[v1649.AssetCategory] or p460.captureObjectiveEnabled and p460:_isCaptureEgg(v1649.Uid) or p460.indexObjectiveEnabled and p460:_isIndexObjective(v1649) or p460.wispObjective and p460:_isWispObjective(v1649) or p460.userStealEnabled and not p460.riftOnly and p460:_matchesNormalFilter(v1649))

				if type(v1649) ~= "table" or captureObjectiveEnabled then
					p460:_returnToSafe()

					return
				end

				p460:_setStatus("Dropping unwanted egg")
				p460.skippedEggs[p460.carry.uid] = os.clock() + 30
				pcall(EggState2.DropFieldEgg, "PlayerRequest")
				task.delay(0.5, function()
					if not p460.destroyed and p460.enabled then
						p460:_schedule()
					end
				end)

				return
			end

			if not p460:_wallOpen() then
				p460:_releaseOperation()
				p460:_setStatus("Waiting for reset wall")

				return
			end

			local __SenaV4PlayerSteal = genv.__SenaV4PlayerSteal
			local autoSteal = t25.blocker("auto_steal")
			local autoSteal2 = not autoSteal and t25.holder("auto_steal") or nil

			if autoSteal or autoSteal2 or __SenaV4PlayerSteal and __SenaV4PlayerSteal.running then
				p460:_releaseOperation()
				p460:_setStatus(autoSteal and "Yielding to " .. t25.TITLES[autoSteal] or autoSteal2 and "Waiting for " .. t25.TITLES[autoSteal2] .. " to hand over" or "Yielding to Steal Players")

				if p460._yieldRetryPending then
					return
				end

				p460._yieldRetryPending = true
				task.delay((autoSteal or autoSteal2) and 1 or 0.5, function()
					p460._yieldRetryPending = nil

					if not p460.destroyed and p460.enabled then
						p460:_schedule()
					end
				end)

				return
			end

			local tweenRecoveryUid = p460.tweenRecoveryUid
			local v1655 = tweenRecoveryUid and (EggState2.ReadFieldEgg(tweenRecoveryUid) or p460.records[tweenRecoveryUid]) or nil

			if tweenRecoveryUid then
				if type(v1655) ~= "table" or v1655.State ~= AreaEggs.States.Slot and v1655.State ~= AreaEggs.States.Dropped then
					p460.tweenRecoveryUid = nil
					tweenRecoveryUid = nil
					v1655 = nil
				end
			end

			v1655 = v1655 or p460:_chooseTarget()

			if not v1655 then
				if p460.stats.matching == 0 and p460.stats.available > 0 then
					if (p460.config.minWeightKg or 0) > 0 then
						p460:_setStatus(string.format("No eggs ≥ %dKg", p460.config.minWeightKg))
					else
						p460:_setStatus("No matching eggs")
					end
				else
					p460:_setStatus("No matching eggs")
				end

				p460:_releaseOperation()

				if not p460.activeTween and p460:_isInField(HumanoidRootPart) and not p460:_isInSafeArea(HumanoidRootPart) then
					local v1656 = p460:_resolveSafeCFrame(HumanoidRootPart)

					if v1656 then
						p460:_tweenRoot(v1656, nil, nil, {
							silent = true,
							flightProfile = true,
							abort = function()
								return not p460.enabled or p460.running
							end
						})
					end
				end

				return
			end

			if p460.treadmillManager then
				if p460.treadmillManager:isEngaged() then
					p460.treadmillManager:_cancelIdle(true)
				end
			end

			local planGeneration = p460.planGeneration
			local v1658, v1659 = p460:_acquireOperation()

			if not v1658 then
				p460:_setStatus("Waiting · " .. tostring(v1659 or "another operation"))
				task.delay(0.5, function()
					if not p460.destroyed and p460.enabled and p460.planGeneration == planGeneration then
						p460:_schedule()
					end
				end)

				return
			end

			p460.safeStarting = true
			p460.running = true
			p460.activeTarget = v1655

			local v1660 = p460.catalog.resolve(v1655)

			p460.stats.lastTarget = string.format("%s · %s · %s", v1660.rarity, v1660.name, v1655.AreaId)

			if tweenRecoveryUid then
				p460.safeStarting = false
				p460.stats.lastResult = "Recovering with tween"

				local v1661 = p460:_resolveEggDestination(v1655, HumanoidRootPart, Humanoid)

				if not v1661 then
					p460.tweenRecoveryUid = nil
					p460:_finish("Recovery destination unavailable")

					return
				end

				p460:_setStatus("Returning to egg")
				p460:_tweenRoot(v1661, function()
					if p460.tweenRecoveryUid == v1655.Uid then
						p460:_requestCarry(v1655, false)
					end
				end, nil, {
					holdAfterArrival = true,
					holdUid = v1655.Uid,
					flightProfile = true,
					carryTarget = v1655
				})

				return
			end

			if not p460:_leftTreadmill(HumanoidRootPart) then
				p460.running = false
				p460.safeStarting = false
				p460.activeTarget = nil
				p460:_releaseOperation()
				p460:_setStatus("Preparing steal")
				task.delay(0.3, function()
					if not p460.destroyed and p460.enabled and p460.planGeneration == planGeneration then
						p460:_schedule()
					end
				end)

				return
			end

			if genv.__SenaV4AdminBoost == true and (not p460.captureObjectiveEnabled or not p460:_isCaptureEgg(v1655.Uid)) then
				p460.safeStarting = false
				task.spawn(p460._adminSteal, p460, v1655)

				return
			end

			local v1662 = HumanoidRootPart.Position - vector32
			local Magnitude = Vector2.new(v1662.X, v1662.Z).Magnitude
			local v1664 = false

			if p460.config.stealMode == "Fly" then
				local BottomCFrame = v1655.BottomCFrame or v1655.BoundsCFrame

				if BottomCFrame then
					local v1666 = BottomCFrame.Position - HumanoidRootPart.Position

					if Vector2.new(v1666.X, v1666.Z).Magnitude < Magnitude then
						v1664 = true
					end
				end
			end

			if not v1664 and Magnitude > 3 then
				if os.clock() - (p460.lastSafeRepositionAt or 0) > 5 then
					local v1667 = p460:_resolveSafeCFrame(HumanoidRootPart)

					if v1667 then
						p460.safeStarting = true
						p460.running = true
						p460.lastSafeRepositionAt = os.clock()
						p460:_setStatus("Repositioning to safe area")
						p460:_tweenRoot(v1667, function()
							p460:_groundSnap()
							p460.safeStarting = false
							p460.running = false
							task.delay(0.15, function()
								if not p460.destroyed and p460.enabled and p460.planGeneration == planGeneration then
									p460:_schedule()
								end
							end)
						end, nil, {
							flightProfile = true
						})

						return
					end
				end
			end

			p460.safeStarting = false

			if p460.config.stealMode == "Fly" then
				p460.instantPhase = "priming"
				p460.primerUid = nil
				p460.targetUid = v1655.Uid
				p460.activeTarget = v1655
				p460._flyDeparting = false
				p460.lowFpsPrime = false
				p460:_installGuardHitDistanceBoost()
				p460:_startMovementProtection()
				p460.stats.lastResult = "High Speed departing"
				p460:_startPrimerTargetHunt()

				return
			end

			local v1668 = p460:_choosePrimerEgg(v1655.Uid)

			if not v1668 then
				p460.running = false
				p460.activeTarget = nil
				p460:_releaseOperation()
				p460:_setStatus("Preparing steal")
				task.delay(0.25, function()
					if not p460.destroyed and p460.enabled and p460.planGeneration == planGeneration then
						p460:_schedule()
					end
				end)

				return
			end

			p460.instantPhase = "priming"
			p460.primerUid = v1668.Uid
			p460.primerUids[v1668.Uid] = os.clock() + 120
			p460.skippedEggs[v1668.Uid] = os.clock() + 30
			p460.targetUid = v1655.Uid
			p460.activeTarget = v1668
			p460._flyDeparting = p460.config.stealMode == "Fly"

			if p460.config.stealMode == "Instant" then
				p460:_showTreadmillDecoy()
			end

			p460:_installGuardHitDistanceBoost()
			p460.stats.lastResult = p460.config.stealMode .. " priming"
			p460.lowFpsPrime = v19() < 30

			local v1669 = p460:_resolveEggDestination(v1668, HumanoidRootPart, Humanoid)

			if not v1669 then
				p460:_finish("Steal unavailable — retrying")

				return
			end

			if p460.lowFpsPrime then
				p460:_setStatus("Preparing steal")
				p460:_tweenRoot(v1669, function()
					if p460.instantPhase == "priming" and p460.primerUid == v1668.Uid then
						p460:_requestCarry(v1668, false)
					end
				end, nil, {
					holdAfterArrival = true,
					holdUid = v1668.Uid,
					flightProfile = true,
					carryTarget = v1668
				})

				return
			end

			if p460.config.stealMode == "Fly" then
				p460:_setStatus("Preparing steal")

				if not p460:_glideRoot(v1669, function()
					return p460.destroyed or not p460.enabled or p460.instantPhase ~= "priming" or p460.primerUid ~= v1668.Uid
				end) then
					if p460.instantPhase == "priming" and p460.primerUid == v1668.Uid then
						p460:_finish("Steal unavailable — retrying")
					end

					return
				end

				p460:_setArrivalHold(v1669, v1668.Uid)
				p460:_requestCarry(v1668, true)

				return
			end

			p460:_setStatus("Preparing steal")

			if not p460:_teleportRoot(HumanoidRootPart, Humanoid, v1669) then
				p460:_finish("Steal unavailable — retrying")

				return
			end

			p460:_setArrivalHold(v1669, v1668.Uid)
			p460:_requestCarry(v1668, true)
		end
		t46._leftTreadmill = function(p461, p462)
			local treadmillManager = p461.treadmillManager

			if not treadmillManager or treadmillManager.destroyed then
				return true
			end

			if not (treadmillManager.activeTreadmill ~= nil or treadmillManager.treadmillEquipPending == true or treadmillManager.travelingToTreadmill == true or p462 ~= nil and p462.Anchored) then
				p461.treadmillLeaveAt = nil

				return true
			end

			local now = os.clock()

			p461.treadmillLeaveAt = p461.treadmillLeaveAt or now
			treadmillManager.idleGeneration += 1

			if not p461.treadmillDoffBusy then
				if now - (p461.treadmillDoffAt or 0) > 0.6 then
					p461.treadmillDoffBusy = true
					p461.treadmillDoffAt = now
					task.spawn(function()
						pcall(treadmillManager._requestUnequip, treadmillManager)
						pcall(treadmillManager._syncActiveTreadmillSnapshot, treadmillManager)
						p461.treadmillDoffBusy = false
					end)
				end
			end

			if p462 and p462.Anchored and now - p461.treadmillLeaveAt > 1 then
				pcall(function()
					p462.Anchored = false
				end)
			end

			if not (now - p461.treadmillLeaveAt > 8) then
				return false
			end

			p461.treadmillLeaveAt = nil

			return true
		end

		do
			t46._reconcileRunningState = function(p463)
				local enabled = p463.userStealEnabled == true or next(p463.riftWants) ~= nil or p463.indexObjectiveEnabled == true or p463.wispObjective ~= nil or p463.manualObjectiveEnabled == true or p463.captureObjectiveEnabled == true

				if p463.enabled == enabled then
					if p463.enabled then
						p463:_refreshCounts()
						p463:_schedule()
					end

					return
				end

				p463.enabled = enabled

				if p463.enabled then
					if LocalPlayer2.Character then
						v760(LocalPlayer2.Character)
						v769(p463, LocalPlayer2.Character)
					end

					p463:_installGuardHitDistanceBoost()
					p463:_startMovementProtection()
					pcall(p463._installPromptFilter, p463)
					p463:_setStatus("Searching")
					p463:_schedule()
				else
					if p463._instantReturnToken ~= nil and p463.carry.uid ~= nil and not p463._externalDeliver then
						p463._externalDeliver = true
						p463.planGeneration += 1
						p463.running = false
						p463:_setStatus("Finishing target egg")
						task.spawn(function()
							local v1673 = os.clock() + 45

							while p463._instantReturnToken ~= nil and os.clock() < v1673 and not p463.destroyed do
								task.wait(0.2)
							end

							if p463.destroyed or p463.enabled then
								return
							end

							p463._externalDeliver = nil
							p463._instantReturnToken = nil
							p463.carry.active = false
							p463.carry.uid = nil
							p463.activeTarget = nil
							p463:_cleanupInstantSteal()
							p463:_removeGuardHitDistanceBoost()
							p463:_restoreTreadmillVisualAtSafe()
							p463:_stopMovementProtection()
							v768(p463)
							p463:_setStatus("Idle")
						end)
						p463:_refreshCounts()

						return
					end

					p463.planGeneration += 1

					local carry = p463.carry

					carry.generation += 1
					p463:_cleanupInstantSteal()
					p463:_removeGuardHitDistanceBoost()
					p463:_invalidateCarryWorker()
					p463._forestDropInProgress = nil
					p463._instantReturnToken = nil
					p463.carry.active = false
					p463.carry.uid = nil
					p463.tweenRecoveryUid = nil
					p463.claimPresentationSuppression = nil
					p463.safeStarting = false
					p463.movementRetryPending = false
					p463:_cancelTween("Disabled")
					p463:_releaseOperation()
					p463:_restoreTreadmillVisualAtSafe()
					p463:_stopMovementProtection()
					v768(p463)
					p463.activeTarget = nil
					p463.running = false
					p463:_setStatus("Idle")
				end

				p463:_refreshCounts()
			end
		end

		t46.setEnabled = function(p464, p465)
			p464.userStealEnabled = p465 == true
			p464:_reconcileRunningState()

			if p464.userStealEnabled then
				p464:_startWatchdog()
			end

			p464:_reconcileScramblePortal()
		end

		do
			t46._neutralizeScramblePortal = function(p466, p467)
				if typeof(p467) ~= "Instance" or p467.Name ~= "ScrambleArenaPortal" then
					return
				end

				p466.scramblePortalOriginals = p466.scramblePortalOriginals or {}

				for _, descendant in ipairs(p467:GetDescendants()) do
					if descendant:IsA("BasePart") then
						if p466.scramblePortalOriginals[descendant] == nil then
							local attribute = descendant:GetAttribute("SenaV4PortalOrig")

							if type(attribute) == "string" then
								p466.scramblePortalOriginals[descendant] = {
									CanCollide = attribute:sub(1, 1) == "1",
									CanTouch = attribute:sub(2, 2) == "1"
								}
							else
								p466.scramblePortalOriginals[descendant] = {
									CanCollide = descendant.CanCollide,
									CanTouch = descendant.CanTouch
								}
								pcall(descendant.SetAttribute, descendant, "SenaV4PortalOrig", (descendant.CanCollide and "1" or "0") .. (descendant.CanTouch and "1" or "0"))
							end
						end

						pcall(function()
							descendant.CanCollide = false
							descendant.CanTouch = false
						end)
					end
				end
			end
		end

		t46._startScramblePortalBypass = function(p468)
			local ScrambleArenaPortal = workspace:FindFirstChild("ScrambleArenaPortal")

			if ScrambleArenaPortal then
				p468:_neutralizeScramblePortal(ScrambleArenaPortal)
			end

			if not p468.scramblePortalConn then
				p468.scramblePortalConn = workspace.ChildAdded:Connect(function(child)
					if p468.destroyed or not p468.userStealEnabled or p468._scramblePortalHold or senaV4Config.ScrambleBossAuto == true then
						return
					end

					if child.Name ~= "ScrambleArenaPortal" then
						return
					end

					for _, v in ipairs({
						0,
						0.15,
						0.4,
						0.8
					}) do
						task.delay(v, function()
							if not p468.destroyed and p468.userStealEnabled and not p468._scramblePortalHold then
								if senaV4Config.ScrambleBossAuto ~= true and child.Parent then
									p468:_neutralizeScramblePortal(child)
								end
							end
						end)
					end
				end)
			end
		end
		t46._stopScramblePortalBypass = function(p469)
			if p469.scramblePortalConn then
				pcall(p469.scramblePortalConn.Disconnect, p469.scramblePortalConn)
				p469.scramblePortalConn = nil
			end

			if p469.scramblePortalOriginals then
				for k, scramblePortalOriginal in pairs(p469.scramblePortalOriginals) do
					if typeof(k) == "Instance" and k.Parent then
						pcall(function()
							k.CanCollide = scramblePortalOriginal.CanCollide
							k.CanTouch = scramblePortalOriginal.CanTouch
							k:SetAttribute("SenaV4PortalOrig", nil)
						end)
					end
				end

				p469.scramblePortalOriginals = nil
			end
		end

		do
			t46._setScramblePortalHold = function(p470, p471)
				local scramblePortalHold = p471 == true

				if p470._scramblePortalHold == scramblePortalHold then
					return
				end

				p470._scramblePortalHold = scramblePortalHold
				p470:_reconcileScramblePortal()
			end
		end

		t46._reconcileScramblePortal = function(p472)
			if not p472.userStealEnabled or p472._scramblePortalHold or senaV4Config.ScrambleBossAuto == true then
				p472:_stopScramblePortalBypass()
			else
				p472:_startScramblePortalBypass()
			end
		end
		t46._resolveWeightKg = function(p473, p474)
			local weightUtil = p473.weightUtil

			if not weightUtil or not p474 or not p474.AssetScale or not p474.AssetCategory then
				return nil
			end

			local ok, result = pcall(weightUtil.WeightKgForScale, p474.AssetCategory, p474.AssetScale)

			if ok and type(result) == "number" then
				return result
			end

			return nil
		end
		t46.setHeaviestFirst = function(p475, p476)
			p475.config.heaviestFirst = p476 == true

			if p475.config.heaviestFirst then
				p475.config.highestValueFirst = false
			end

			p475:_schedule()
		end
		t46.setHighestValueFirst = function(p477, p478)
			p477.config.highestValueFirst = p478 == true

			if p477.config.highestValueFirst then
				p477.config.heaviestFirst = false
			end

			p477:_schedule()
		end

		do
			local t53 = {
				rarity = true,
				name = true,
				kg = true,
				mutation = true,
				value = true,
				placed = true,
				icon = true
			}

			v748 = function(p479)
				if type(p479) ~= "table" then
					return nil
				end

				local Category = p479.Category or p479.AssetCategory
				local v1689 = tonumber(p479.Scale or p479.AssetScale)

				if type(Category) ~= "string" or not v1689 or v1689 <= 0 then
					return nil
				end

				local ok, result = pcall(AssetEarnings.MutationOnlyRatePerSecond, {
					Category = Category,
					Scale = v1689,
					Mutations = type(p479.Mutations) == "table" and table.clone(p479.Mutations) or {},
					BaseMutation = type(p479.BaseMutation) == "string" and p479.BaseMutation or nil
				})

				return ok and type(result) == "number" and result or nil
			end

			local u1692

			local function v1693(p480)
				if type(u1692) ~= "table" then
					local ok, result = pcall(require, ReplicatedStorage2.Packages.FormatNumber.Simple)

					if ok and type(result.FormatCompact) == "function" then
						u1692 = result
					end
				end

				if u1692 then
					local ok, result = pcall(u1692.FormatCompact, p480, ".#")

					if ok and type(result) == "string" then
						return result
					end
				end

				local v1698 = math.abs(p480)

				if v1698 >= 1e12 then
					return string.format("%.2fT", p480 / 1e12)
				end

				if v1698 >= 1e9 then
					return string.format("%.2fB", p480 / 1e9)
				end

				if v1698 >= 1000000 then
					return string.format("%.1fM", p480 / 1000000)
				end

				if v1698 >= 1000 then
					return string.format("%.1fK", p480 / 1000)
				end

				return string.format("%d", math.floor(p480 + 0.5))
			end

			local t54 = {
				["Carry not confirmed — retrying"] = true,
				["Carry refused — next egg"] = true,
				["Carry lost — retrying"] = true,
				["Drop failed — retrying"] = true,
				["Egg lost — retrying"] = true,
				["Re-steal failed — retrying"] = true,
				["Steal timed out — retrying"] = true
			}
			local t55 = {}

			local function v1701()
				if next(t55) then
					return t55
				end

				local v1702 = v14()
				local Areas = v1702 and v1702:FindFirstChild("Areas")
				local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
				local ipairs_ = ipairs
				local children = GuardAreas and GuardAreas:GetChildren() or {}

				for _, child in ipairs_(children) do
					local ClosestExitPoint = child:FindFirstChild("ClosestExitPoint")

					if ClosestExitPoint and ClosestExitPoint:IsA("BasePart") then
						t55[child.Name] = ClosestExitPoint.Position.X
					end
				end

				return t55
			end

			t46.settleNeed = function(p481, p482, p483)
				return 2 + math.max(0, (v1701()[p482] or 597) - 597) / (3.2 * math.max(p483, 16))
			end
			t46.recommendLowSpeedLevel = function(p484, p485)
				local v1710 = p485 or v869()
				local t56 = {}

				if p484.config.areaEnabled and #p484.config.areas > 0 then
					t56 = p484.config.areas
				else
					for k in pairs(v1701()) do
						t56[#t56 + 1] = k
					end
				end

				local n29 = 10
				local n30 = 10
				local v1715

				for _, v in ipairs(t56) do
					local v1718 = p484:settleNeed(v, v1710)
					local n31 = 1
					local n32 = 1

					for i = 10, 1, -1 do
						if v1718 <= v1077(v, i) then
							n31 = i

							break
						end
					end

					for i = 10, 1, -1 do
						if v1718 * 1.25 <= v1077(v, i) then
							n32 = i

							break
						end
					end

					if n31 < n30 then
						n30 = n31
						v1715 = v
					end

					n29 = math.min(n29, n32)
				end

				local lowSpeedFailCap = p484.lowSpeedFailCap

				if lowSpeedFailCap then
					n30 = math.min(n30, lowSpeedFailCap)
					n29 = math.min(n29, lowSpeedFailCap)
				end

				return math.min(n29, n30), n30, v1710, v1715
			end
			t46._noteLowSpeedOutcome = function(p486, p487)
				local v1724 = p486._untrustedSeen == true

				p486._untrustedSeen = nil

				if p486.config.stealMode ~= "Instant" then
					return
				end

				if p486.boostedUid ~= nil or p486._boostHopUid ~= nil then
					return
				end

				local v1725 = t54[tostring(p487)] == true or v1724

				if not v1725 and p487 ~= "Safe return complete" then
					return
				end

				local v1726 = math.clamp(tonumber(senaV4Config.StealHoldSeconds) or 5, 1, 10)

				p486.lowSpeedOutcomes = p486.lowSpeedOutcomes or {}

				local v1727 = p486.lowSpeedOutcomes[v1726] or {}

				p486.lowSpeedOutcomes[v1726] = v1727
				v1727[#v1727 + 1] = {
					at = os.clock(),
					failed = v1725
				}

				while #v1727 > 8 do
					table.remove(v1727, 1)
				end

				local n33 = 0
				local n34 = 0

				for _, v in ipairs(v1727) do
					if os.clock() - v.at <= 600 then
						n34 += 1

						if v.failed then
							n33 += 1
						end
					end
				end

				if v1726 > 1 then
					if n33 >= 3 and n33 / n34 >= 0.4 then
						local lowSpeedFailCap = v1726 - 1

						if not p486.lowSpeedFailCap or lowSpeedFailCap < p486.lowSpeedFailCap then
							p486.lowSpeedFailCap = lowSpeedFailCap
							p486.lowSpeedAdvice = {
								from = v1726,
								to = lowSpeedFailCap,
								fails = n33,
								total = n34,
								fresh = true
							}
						end
					end
				end
			end
			t46.lowSpeedStatus = function(p488)
				local u1733

				pcall(function()
					u1733 = SpeedPowerProjection.ReadProjected()
				end)

				local v1734, v1735, v1736 = p488:recommendLowSpeedLevel()
				local v1737 = math.clamp(tonumber(senaV4Config.StealHoldSeconds) or 5, 1, 10)
				local lowSpeedAdvice = p488.lowSpeedAdvice

				if lowSpeedAdvice and v1737 <= lowSpeedAdvice.to then
					lowSpeedAdvice = nil
				end

				local t57 = {
					speedText = type(u1733) == "number" and v1693(u1733) or "?",
					walkSpeed = math.floor((v1736 or 0) + 0.5),
					safe = v1734,
					fast = v1735,
					level = v1737,
					advice = lowSpeedAdvice
				}

				return t57
			end
			t46.setEggEsp = function(p489, p490)
				p489.config.espEnabled = p490 == true

				if not p489.config.espEnabled then
					pcall(function()
						p489:_clearEsp()
					end)
				end
			end
			t46.setEspMinRank = function(p491, p492)
				p491.config.espMinRank = math.max(tonumber(p492) or 0, 0)
			end
			t46.setEspMinValue = function(p493, p494)
				p493.config.espMinValue = math.max(tonumber(p494) or 0, 0)
			end
			t46._espPasses = function(p495, p496, p497)
				local config = p495.config
				local espMinRank = config.espMinRank

				if (espMinRank or 0) > 0 then
					if (tonumber(p496 and p496.rarityRank) or 0) < config.espMinRank then
						return false
					end
				end

				if (config.espMinValue or 0) > 0 then
					if (tonumber(p497) or 0) < config.espMinValue then
						return false
					end
				end

				return true
			end
			t46.setEspOption = function(p498, p499, p500)
				if t53[p499] then
					p498.config["esp" .. p499:sub(1, 1):upper() .. p499:sub(2)] = p500 == true
				end
			end
			t46._clearEsp = function()
				local AreaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")

				if not AreaEggSlotsClient then
					return
				end

				for _, child in ipairs(AreaEggSlotsClient:GetChildren()) do
					local __SenaV4EggEsp = child:FindFirstChild("__SenaV4EggEsp")

					if __SenaV4EggEsp then
						__SenaV4EggEsp:Destroy()
					end

					local __SenaV4EggHighlight = child:FindFirstChild("__SenaV4EggHighlight")

					if __SenaV4EggHighlight then
						__SenaV4EggHighlight:Destroy()
					end
				end
			end
			t46._updateEsp = function(p501)
				local AreaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")

				if not AreaEggSlotsClient then
					return
				end

				local config = p501.config

				for _, child in ipairs(AreaEggSlotsClient:GetChildren()) do
					local v1751 = p501.records[child.Name]
					local v1752 = config.espEnabled and v1751 ~= nil and (v1751.State == AreaEggs.States.Slot or v1751.State == AreaEggs.States.Dropped)

					if v1752 and not p501:_espPasses(p501.catalog.resolve(v1751), v748(v1751)) then
						v1752 = false
					end

					local Hitbox = v1752 and (child:FindFirstChild("Hitbox") or child:FindFirstChildWhichIsA("BasePart", true))
					local __SenaV4EggEsp = child:FindFirstChild("__SenaV4EggEsp")
					local __SenaV4EggHighlight = child:FindFirstChild("__SenaV4EggHighlight")

					if v1752 and Hitbox then
						if __SenaV4EggEsp and not __SenaV4EggEsp:FindFirstChild("Icon") then
							__SenaV4EggEsp:Destroy()
							__SenaV4EggEsp = nil
						end

						if not __SenaV4EggEsp then
							__SenaV4EggEsp = Instance.new("BillboardGui")
							__SenaV4EggEsp.Name = "__SenaV4EggEsp"
							__SenaV4EggEsp.AlwaysOnTop = true
							__SenaV4EggEsp.Size = UDim2.fromOffset(220, 72)
							__SenaV4EggEsp.StudsOffset = Vector3.new(0, 4.4, 0)
							__SenaV4EggEsp.MaxDistance = 1000
							__SenaV4EggEsp.Adornee = Hitbox

							local ImageLabel = Instance.new("ImageLabel")

							ImageLabel.Name = "Icon"
							ImageLabel.AnchorPoint = Vector2.new(0.5, 1)
							ImageLabel.Position = UDim2.fromScale(0.5, 0.42)
							ImageLabel.Size = UDim2.fromOffset(30, 30)
							ImageLabel.BackgroundTransparency = 1
							ImageLabel.ScaleType = Enum.ScaleType.Fit
							ImageLabel.Visible = false
							ImageLabel.Parent = __SenaV4EggEsp

							local TextLabel = Instance.new("TextLabel")

							TextLabel.Name = "Text"
							TextLabel.AnchorPoint = Vector2.new(0.5, 0)
							TextLabel.Position = UDim2.fromScale(0.5, 0.45)
							TextLabel.Size = UDim2.new(1, 0, 0.55, 0)
							TextLabel.BackgroundTransparency = 1
							TextLabel.Font = Enum.Font.GothamBold
							TextLabel.TextSize = 13
							TextLabel.TextStrokeTransparency = 0.35
							TextLabel.TextXAlignment = Enum.TextXAlignment.Center
							TextLabel.TextYAlignment = Enum.TextYAlignment.Top
							TextLabel.Parent = __SenaV4EggEsp
							__SenaV4EggEsp.Parent = child
						end

						__SenaV4EggEsp.Adornee = Hitbox

						local v1758 = p501.catalog.resolve(v1751)
						local Icon = __SenaV4EggEsp:FindFirstChild("Icon")
						local icon = config.espIcon and type(v1758.icon) == "string" and v1758.icon ~= "" and v1758.icon or nil

						Icon.Image = icon or ""
						Icon.Visible = icon ~= nil

						local rarityColor = typeof(v1758.rarityColor) == "Color3" and v1758.rarityColor or Color3.fromRGB(255, 255, 255)
						local t58 = {}

						if config.espRarity then
							t58[#t58 + 1] = string.upper(v1758.rarity or "?")
						end

						if config.espName then
							t58[#t58 + 1] = tostring(v1758.name)
						end

						if config.espKg then
							local v1763 = p501:_resolveWeightKg(v1751)

							if v1763 then
								t58[#t58 + 1] = string.format("%d Kg", math.floor(v1763))
							end
						end

						if config.espMutation and type(v1751.Mutations) == "table" and next(v1751.Mutations) then
							local t59 = {}

							for _, mutation in pairs(v1751.Mutations) do
								t59[#t59 + 1] = tostring(mutation)
							end

							if #t59 > 0 then
								table.sort(t59)
								t58[#t58 + 1] = table.concat(t59, ", ")
							end
						end

						if config.espValue then
							local v1767 = v748(v1751)

							if v1767 then
								t58[#t58 + 1] = "$" .. v1693(v1767) .. "/s"
							end
						end

						local Text = __SenaV4EggEsp:FindFirstChild("Text")

						Text.Text = table.concat(t58, " | ")
						Text.TextColor3 = rarityColor

						if __SenaV4EggHighlight and not __SenaV4EggHighlight:IsA("Highlight") then
							__SenaV4EggHighlight:Destroy()
							__SenaV4EggHighlight = nil
						end

						if not __SenaV4EggHighlight then
							__SenaV4EggHighlight = Instance.new("Highlight")
							__SenaV4EggHighlight.Name = "__SenaV4EggHighlight"
							__SenaV4EggHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							__SenaV4EggHighlight.Parent = child
						end

						__SenaV4EggHighlight.Adornee = child
						__SenaV4EggHighlight.FillColor = rarityColor
						__SenaV4EggHighlight.FillTransparency = 0.72
						__SenaV4EggHighlight.OutlineColor = rarityColor
						__SenaV4EggHighlight.OutlineTransparency = 0
					else
						if __SenaV4EggEsp then
							__SenaV4EggEsp:Destroy()
						end

						if __SenaV4EggHighlight then
							__SenaV4EggHighlight:Destroy()
						end
					end
				end

				p501._placedEspAnchors = p501._placedEspAnchors or {}
				os.clock()

				if config.espPlaced then
					local v1769 = (Save.Peek or Save.Get)()
					local EggInventory = type(v1769) == "table" and v1769.EggInventory

					EggInventory = EggInventory or nil

					local v1771 = PlotState2.ResolveLocalSlot()
					local v1772 = PlotState2.ResolveFolder()
					local v1773 = v1772 and v1771 and v1772:FindFirstChild(tostring(v1771))
					local CenterPoint = v1773 and v1773:FindFirstChild("CenterPoint")

					if CenterPoint and not CenterPoint:IsA("BasePart") then
						CenterPoint = nil
					end

					local t60 = {}

					if type(EggInventory) == "table" and CenterPoint then
						local SenaV4PlacedEggAnchors = workspace:FindFirstChild("SenaV4PlacedEggAnchors")

						if not SenaV4PlacedEggAnchors then
							SenaV4PlacedEggAnchors = Instance.new("Folder")
							SenaV4PlacedEggAnchors.Name = "SenaV4PlacedEggAnchors"
							SenaV4PlacedEggAnchors.Parent = workspace
						end

						for _, child in ipairs(SenaV4PlacedEggAnchors:GetChildren()) do
							if child:IsA("Highlight") or child:IsA("BillboardGui") then
								child:Destroy()
							end
						end

						for k, v in pairs(EggInventory) do
							if type(k) == "string" and type(v) == "table" and type(v.Placement) == "table" then
								t60[k] = true

								local LocalCFrame = v.Placement.LocalCFrame

								if typeof(LocalCFrame) ~= "CFrame" then
									local ok, result = pcall(EggRecords.Decode, v)
									local Placement = ok and type(result) == "table" and result.Placement or nil

									LocalCFrame = type(Placement) == "table" and Placement.LocalCFrame or nil
								end

								if typeof(LocalCFrame) == "CFrame" then
									local ok, result = pcall(EggRecords.Decode, v)
									local v1787 = ok and type(result) == "table" and result or v
									local v1788 = tonumber(v1787.AssetScale) or 1
									local cFrame2 = CenterPoint.CFrame * LocalCFrame + Vector3.new(0, 3 + v1788 * 2, 0)

									p501._placedEspAnchors[k] = p501._placedEspAnchors[k] or {}

									local v1790 = p501._placedEspAnchors[k]

									if typeof(v1790.anchor) ~= "Instance" then
										local Part = Instance.new("Part")

										Part.Name = "SenaV4PE_" .. k
										Part.Size = Vector3.new(1.5, 1.5, 1.5)
										Part.Transparency = 1
										Part.Anchored = true
										Part.CanCollide = false
										Part.CanQuery = false
										Part.CanTouch = false
										Part.Parent = SenaV4PlacedEggAnchors
										v1790.anchor = Part
									end

									v1790.anchor.CFrame = cFrame2

									local v1792 = p501.catalog.resolve({
										AssetCategory = v1787.AssetCategory
									})
									local rarityColor = typeof(v1792.rarityColor) == "Color3" and v1792.rarityColor or Color3.fromRGB(255, 255, 255)
									local v1794 = v748({
										Category = v1787.AssetCategory,
										Mutations = type(v1787.Mutations) == "table" and v1787.Mutations or {},
										Scale = v1788,
										BaseMutation = type(v1787.BaseMutation) == "string" and v1787.BaseMutation or nil
									})

									if p501:_espPasses(v1792, v1794) then
										local t61 = {}

										if config.espRarity then
											t61[#t61 + 1] = string.upper(v1792.rarity or "?")
										end

										if config.espName then
											t61[#t61 + 1] = tostring(v1792.name)
										end

										if config.espKg then
											local ok2, result2 = pcall(EggRecords.WeightKgForScale, v1787.AssetCategory, v1788)

											if ok2 and type(result2) == "number" then
												t61[#t61 + 1] = string.format("%d Kg", math.floor(result2))
											end
										end

										if config.espValue and v1794 then
											t61[#t61 + 1] = "$" .. v1693(v1794) .. "/s"
										end

										if type(v.Placement.ReadyAt) == "number" or type(v1787.Placement) == "table" and v1787.Placement.ReadyAt ~= nil then
											t61[#t61 + 1] = "READY"
										end

										local __SenaV4EggEsp = v1790.anchor:FindFirstChild("__SenaV4EggEsp")

										if not __SenaV4EggEsp then
											__SenaV4EggEsp = Instance.new("BillboardGui")
											__SenaV4EggEsp.Name = "__SenaV4EggEsp"
											__SenaV4EggEsp.AlwaysOnTop = true
											__SenaV4EggEsp.Size = UDim2.fromOffset(220, 72)
											__SenaV4EggEsp.StudsOffset = Vector3.new(0, 1.4, 0)
											__SenaV4EggEsp.MaxDistance = 1000

											local ImageLabel = Instance.new("ImageLabel")

											ImageLabel.Name = "Icon"
											ImageLabel.AnchorPoint = Vector2.new(0.5, 1)
											ImageLabel.Position = UDim2.fromScale(0.5, 0.42)
											ImageLabel.Size = UDim2.fromOffset(34, 34)
											ImageLabel.BackgroundTransparency = 1
											ImageLabel.ScaleType = Enum.ScaleType.Fit
											ImageLabel.Visible = false
											ImageLabel.Parent = __SenaV4EggEsp

											local TextLabel = Instance.new("TextLabel")

											TextLabel.Name = "Text"
											TextLabel.AnchorPoint = Vector2.new(0.5, 0)
											TextLabel.Position = UDim2.fromScale(0.5, 0.45)
											TextLabel.Size = UDim2.new(1, 0, 0.55, 0)
											TextLabel.BackgroundTransparency = 1
											TextLabel.Font = Enum.Font.GothamBold
											TextLabel.TextSize = 13
											TextLabel.TextStrokeTransparency = 0.35
											TextLabel.TextXAlignment = Enum.TextXAlignment.Center
											TextLabel.TextYAlignment = Enum.TextYAlignment.Top
											TextLabel.Parent = __SenaV4EggEsp
											__SenaV4EggEsp.Parent = v1790.anchor
										end

										local Icon = __SenaV4EggEsp:FindFirstChild("Icon")

										if Icon then
											local icon = config.espIcon and type(v1792.icon) == "string" and v1792.icon ~= "" and v1792.icon or nil

											Icon.Image = icon or ""
											Icon.Visible = icon ~= nil
										end

										local Text = __SenaV4EggEsp:FindFirstChild("Text")

										Text.Text = table.concat(t61, " | ")
										Text.TextColor3 = rarityColor

										local __SenaV4EggHighlight = v1790.anchor:FindFirstChild("__SenaV4EggHighlight")

										if __SenaV4EggHighlight then
											__SenaV4EggHighlight:Destroy()
										end
									else
										t60[k] = nil
									end
								end
							end
						end
					end

					for k, placedEspAnchor in pairs(p501._placedEspAnchors) do
						if not t60[k] then
							if typeof(placedEspAnchor.anchor) == "Instance" then
								placedEspAnchor.anchor:Destroy()
							end

							if typeof(placedEspAnchor.highlight) == "Instance" then
								placedEspAnchor.highlight:Destroy()
							end

							p501._placedEspAnchors[k] = nil
						end
					end
				else
					local pairs_ = pairs
					local _placedEspAnchors = p501._placedEspAnchors or {}

					for k, _placedEspAnchor in pairs_(_placedEspAnchors) do
						if typeof(_placedEspAnchor.anchor) == "Instance" then
							_placedEspAnchor.anchor:Destroy()
						end

						if typeof(_placedEspAnchor.highlight) == "Instance" then
							_placedEspAnchor.highlight:Destroy()
						end

						p501._placedEspAnchors[k] = nil
					end
				end
			end
		end

		t46.setMinWeightKg = function(p502, p503)
			p502.config.minWeightKg = math.max(tonumber(p503) or 0, 0)
		end
		t46.setMinValuePerSec = function(p504, p505)
			p504.config.minValuePerSec = math.max(tonumber(p505) or 0, 0)
			p504:_refreshCounts()
			p504:_schedule()
		end
		t46.setSpeed = function(p506, p507)
			local v1811 = math.clamp(math.floor((tonumber(p507) or 60) + 0.5), 20, 100)

			p506.config.speed = v1811 * 10

			if genv.__SenaV4AdminBoost == true then
				p506.config.speed = 3000
			end

			if p506.enabled or p506.activeTween then
				p506:_startMovementProtection()
			end

			return v1811
		end

		do
			t46.getDefaultSpeed = function()
				return 60
			end
		end

		do
			t46.setFilterEnabled = function(p508, p509, p510)
				p508.config[p509 .. "Enabled"] = p510 == true
				p508:_refreshCounts()
				p508:_schedule()
			end
		end

		t46.setFilter = function(p511, p512, p513)
			local v1812 = type(p513) == "table" and table.clone(p513) or {}

			if p512 == "mutations" and type(p511.catalog.resolveMutationId) == "function" then
				local t62 = {}

				for _, v in ipairs(v1812) do
					local v1816 = p511.catalog.resolveMutationId(v)

					if v1816 then
						table.insert(t62, v1816)
					end
				end

				v1812 = t62
			end

			p511.config[p512] = v1812
			p511:_refreshCounts()
			p511:_schedule()
		end
		t46.destroy = function(p514)
			if p514.destroyed then
				return
			end

			p514.destroyed = true
			p514.enabled = false
			pcall(p514._stopScramblePortalBypass, p514)
			pcall(p514._removePromptFilter, p514)

			if p514._relocateConn then
				pcall(p514._relocateConn.Disconnect, p514._relocateConn)
				p514._relocateConn = nil
			end

			p514._recalling = nil
			p514:_hideTreadmillDecoy()
			p514.planGeneration += 1

			local carry = p514.carry

			carry.generation += 1
			p514:_invalidateCarryWorker()
			p514.carry.active = false
			p514.carry.uid = nil
			p514.tweenRecoveryUid = nil
			p514.safeStarting = false
			p514:_cancelTween("Destroyed")
			p514:_cleanupInstantSteal()
			p514:_removeGuardHitDistanceBoost()
			p514:_releaseOperation()
			p514:_stopMovementProtection()

			if p514._healthPinner then
				pcall(p514._healthPinner.Disconnect, p514._healthPinner)
				p514._healthPinner = nil
			end

			if p514._healthChangedConnection then
				pcall(p514._healthChangedConnection.Disconnect, p514._healthChangedConnection)
				p514._healthChangedConnection = nil
			end

			p514:_restoreClaimPresentationFilter()
			v779(LocalPlayer2.Character)
			pcall(function()
				p514:_clearEsp()
			end)
			pcall(function()
				local pairs_ = pairs
				local _placedEspAnchors = p514._placedEspAnchors or {}

				for _, _placedEspAnchor in pairs_(_placedEspAnchors) do
					if typeof(_placedEspAnchor.anchor) == "Instance" then
						_placedEspAnchor.anchor:Destroy()
					end
				end

				local SenaV4PlacedEggAnchors = workspace:FindFirstChild("SenaV4PlacedEggAnchors")

				if SenaV4PlacedEggAnchors then
					SenaV4PlacedEggAnchors:Destroy()
				end
			end)
			v740(p514.connections)
			table.clear(p514.listeners)
			table.clear(p514.records)
		end

		return t46
	end

	local v1823 = v704()
	local t63 = {
		k = 1000,
		m = 1000000,
		b = 1e9,
		t = 1e12,
		q = 1e15
	}

	local function v1825(p515)
		local match, v1827 = tostring(p515 or ""):lower():gsub("%s+", ""):gsub("%$", ""):gsub("/s$", ""):match("^([%d%.]+)([kmbtq]?)$")
		local v1828 = tonumber(match)

		if v1828 then
			return math.max(0, math.floor(v1828 * (t63[v1827] or 1) + 0.5))
		end

		return nil
	end
	local function v1829()
		local Players2 = game:GetService("Players")
		local RunService2 = game:GetService("RunService")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer2 = Players2.LocalPlayer
		local Remotes = require(ReplicatedStorage2.Shared.Remotes)
		local EggState2 = require(ReplicatedStorage2.Client.EggState)
		local Ragdoll = require(ReplicatedStorage2.Shared.Modules.Ragdoll)
		local RagdollJoints = require(ReplicatedStorage2.Shared.Modules.RagdollJoints)
		local EggWorld = Remotes.EggWorld
		local t64 = {}

		t64.__index = t64

		local function v1840(p516)
			if p516 then
				pcall(p516.Disconnect, p516)
			end
		end

		t64.new = function(p517)
			local obj = setmetatable({}, t64)

			obj.eggRuntime = p517
			obj.enabled = true
			obj.destroyed = false
			obj.connections = {}
			obj.originalRagdoll = {}
			obj.originalHumanoidStates = setmetatable({}, {
				__mode = "k"
			})
			obj.stats = {
				blockedHits = 0,
				blockedDrops = 0,
				recarriedEggs = 0
			}
			obj.lastHeldEggUid = nil
			obj.lastHeldSlotKey = nil
			obj._installed = false
			obj._stickyToken = 0
			obj._nextBodyRecoveryAt = 0
			obj._nextJointSweepAt = 0
			obj._forestStrikeOldFire = nil

			return obj
		end
		t64._liveBody = function()
			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			return Character, Humanoid, Character and Character:FindFirstChild("HumanoidRootPart")
		end
		t64._recoverBody = function(p518, p519)
			if not p518.enabled or p518.destroyed then
				return
			end

			local v1844, v1845, v1846 = p518:_liveBody()

			if not v1844 or not v1845 or not v1846 then
				return
			end

			local now = os.clock()

			if not p519 and now < p518._nextBodyRecoveryAt then
				return
			end

			p518._nextBodyRecoveryAt = now + 0.03

			if not p518.originalHumanoidStates[v1845] then
				p518.originalHumanoidStates[v1845] = {
					Physics = v1845:GetStateEnabled(Enum.HumanoidStateType.Physics),
					FallingDown = v1845:GetStateEnabled(Enum.HumanoidStateType.FallingDown),
					Ragdoll = v1845:GetStateEnabled(Enum.HumanoidStateType.Ragdoll)
				}
			end

			local state = v1845:GetState()
			local v1849 = state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.FallingDown

			v1849 = v1849 or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.PlatformStanding or state == Enum.HumanoidStateType.Seated
			pcall(function()
				v1845.BreakJointsOnDeath = false
				v1845.RequiresNeck = false
				v1845:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				v1845:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
				v1845:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				v1845:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				v1845.PlatformStand = false
				v1845.Sit = false

				local state2 = v1845:GetState()

				if state2 == Enum.HumanoidStateType.Physics or state2 == Enum.HumanoidStateType.FallingDown or state2 == Enum.HumanoidStateType.Ragdoll or state2 == Enum.HumanoidStateType.PlatformStanding or state2 == Enum.HumanoidStateType.Seated then
					v1845:ChangeState(Enum.HumanoidStateType.GettingUp)
					v1845:ChangeState(Enum.HumanoidStateType.Running)
				end
			end)

			for _, descendant in ipairs(v1844:GetDescendants()) do
				if not descendant:IsA("Motor6D") then
					if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") then
						if descendant.Name:find("Ragdoll", 1, true) or descendant:GetAttribute("RagdollConstraint") then
							pcall(descendant.Destroy, descendant)
						end
					end
				elseif not descendant.Enabled then
					descendant.Enabled = true
				end
			end

			local AssemblyLinearVelocity = v1846.AssemblyLinearVelocity
			local Magnitude = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude
			local v1855 = math.max(340, (tonumber(v1845.WalkSpeed) or 0) * 1.5)

			if v1849 or v1855 < Magnitude or math.abs(AssemblyLinearVelocity.Y) > 240 then
				v1846.AssemblyLinearVelocity = Vector3.zero
				v1846.AssemblyAngularVelocity = Vector3.zero
				p518.stats.blockedHits += 1
			end
		end
		t64._watchCharacter = function(p520, p521)
			if not p521 then
				return
			end

			local connection = p521.DescendantAdded:Connect(function(descendant)
				if not p520.enabled or p520.destroyed then
					return
				end

				if not descendant:IsA("BallSocketConstraint") and not descendant:IsA("HingeConstraint") then
					if descendant:IsA("Motor6D") and not descendant.Enabled then
						descendant.Enabled = true
					end
				elseif descendant.Name:find("Ragdoll", 1, true) or descendant:GetAttribute("RagdollConstraint") then
					pcall(descendant.Destroy, descendant)
					p520:_recoverBody(true)
				end
			end)

			table.insert(p520.connections, connection)
		end
		t64._installRagdollHooks = function(p522)
			if p522._installed then
				return
			end

			p522._installed = true
			task.spawn(function()
				task.wait()

				local __SenaV4ForestGate = genv.__SenaV4ForestGate

				if type(__SenaV4ForestGate) == "table" and __SenaV4ForestGate.comp and __SenaV4ForestGate.orig then
					pcall(rawset, __SenaV4ForestGate.comp, "_attackHandler", __SenaV4ForestGate.orig)
					genv.__SenaV4ForestGate = nil
				end

				if type(getgc) ~= "function" then
					return
				end

				local ok, result = pcall(getgc, true)

				if not ok or type(result) ~= "table" then
					return
				end

				for i, v in ipairs(result) do
					if i % 20000 == 0 then
						RunService2.Heartbeat:Wait()
					end

					if p522.destroyed then
						return
					end

					if type(v) ~= "table" or rawget(v, "_areaId") ~= "Forest" or type(rawget(v, "_attackHandler")) ~= "function" then
						continue
					end

					local value = rawget(v, "_attackHandler")

					p522._forestGate = {
						comp = v,
						orig = value
					}
					genv.__SenaV4ForestGate = p522._forestGate
					rawset(v, "_attackHandler", function(...)
						if not p522.enabled or p522.destroyed or p522.eggRuntime and p522.eggRuntime.instantPhase == "priming" or genv.__SenaV4PlayerSteal and genv.__SenaV4PlayerSteal.running then
							return value(...)
						end

						p522.stats.blockedHits += 1
						p522:_recoverBody(true)

						if genv.__SenaV4GodMode then
							genv.__SenaV4GodMode:startDefend()
						end
					end)

					break
				end
			end)

			for _, v in ipairs({
				"ApplyClientRagdoll",
				"Ragdoll",
				"TimedRagdoll",
				"TimedRagdollAsync"
			}) do
				if type(Ragdoll[v]) == "function" then
					p522.originalRagdoll[v] = Ragdoll[v]
					Ragdoll[v] = function(...)
						if p522.enabled then
							if not p522.destroyed then
								p522.stats.blockedHits += 1
								p522:_recoverBody(true)

								return
							end
						end

						return p522.originalRagdoll[v](...)
					end
				end
			end

			if type(Ragdoll.IsRagdolled) == "function" then
				p522.originalRagdoll.IsRagdolled = Ragdoll.IsRagdolled
				Ragdoll.IsRagdolled = function(p523)
					if p522.enabled then
						if p523 == LocalPlayer2.Character then
							return false
						end
					end

					return p522.originalRagdoll.IsRagdolled(p523)
				end
			end
		end
		t64._restoreLocalState = function(p524)
			for k, originalHumanoidState in pairs(p524.originalHumanoidStates) do
				if k.Parent then
					pcall(function()
						k:SetStateEnabled(Enum.HumanoidStateType.Physics, originalHumanoidState.Physics)
						k:SetStateEnabled(Enum.HumanoidStateType.FallingDown, originalHumanoidState.FallingDown)
						k:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, originalHumanoidState.Ragdoll)
					end)
				end
			end

			p524.originalHumanoidStates = setmetatable({}, {
				__mode = "k"
			})
			pcall(RagdollJoints.Release, LocalPlayer2.Character)
		end
		t64._slotKey = function(p525, p526)
			if type(p526) == "table" and type(p526.AreaId) == "string" and type(p526.NestId) == "string" then
				return string.format("%s:%s", p526.AreaId, p526.NestId)
			end

			return nil
		end
		t64._requestCarry = function(p527, p528, p529)
			local t65 = {
				Uid = p528
			}

			if p529 ~= nil then
				t65.FirstAreaSlotKey = p529
			end

			return EggWorld.AskFieldEggCarry:InvokeServer(t65)
		end
		t64._startSticky = function(p530, p531, p532)
			if type(p531) ~= "string" or p531 == "" then
				return
			end

			p530._stickyToken += 1

			local _stickyToken = p530._stickyToken

			p530.stats.recarriedEggs += 1
			task.spawn(function()
				local v1869 = os.clock() + 5

				while not p530.destroyed and p530.enabled and _stickyToken == p530._stickyToken and os.clock() < v1869 do
					local v1870 = EggState2.ReadFieldEgg(p531)

					if v1870 and v1870.State == "Carried" and v1870.CarrierUserId == LocalPlayer2.UserId then
						p530.lastHeldEggUid = p531
						p530.lastHeldSlotKey = p532 or p530:_slotKey(v1870)

						return
					end

					if v1870 and (v1870.State == "Dropped" or v1870.State == "Slot") then
						if p530.eggRuntime then
							if p530.eggRuntime:requestCarryRecovery(p531) then
								return
							end
						end

						local _, _, v1873 = p530:_liveBody()

						if v1873 and v1870.BottomCFrame and (v1873.Position - v1870.BottomCFrame.Position).Magnitude <= 10 then
							pcall(p530._requestCarry, p530, p531, p532 or p530:_slotKey(v1870))
						end
					end

					task.wait(0.05)
				end
			end)
		end
		t64._bindSignals = function(p533)
			table.insert(p533.connections, EggState2.CarryChanged:Connect(function(p534)
				if not p533.enabled then
					return
				end

				if p534.IsCarrying and type(p534.Uid) == "string" then
					p533._stickyToken += 1
					p533.lastHeldEggUid = p534.Uid

					local v1874 = EggState2.ReadFieldEgg(p534.Uid)

					p533.lastHeldSlotKey = p533:_slotKey(v1874)

					return
				end

				local __SenaV4PlayerSteal = genv.__SenaV4PlayerSteal

				if __SenaV4PlayerSteal and __SenaV4PlayerSteal.running then
					return
				end

				local Uid = p534.Uid or p533.lastHeldEggUid
				local lastHeldSlotKey = p533.lastHeldSlotKey

				if p533.eggRuntime then
					if p533.eggRuntime:isSkippedEgg(Uid) then
						return
					end
				end

				if Uid then
					p533.stats.blockedDrops += 1
					p533:_startSticky(Uid, lastHeldSlotKey)

					if genv.__SenaV4GodMode then
						genv.__SenaV4GodMode:startDefend(Uid)
					end
				end
			end))
			table.insert(p533.connections, LocalPlayer2.CharacterAdded:Connect(function(character)
				p533:_watchCharacter(character)
				task.defer(function()
					p533:_recoverBody(true)
				end)
			end))

			if LocalPlayer2.Character then
				p533:_watchCharacter(LocalPlayer2.Character)
			end

			table.insert(p533.connections, RunService2.Stepped:Connect(function()
				p533:_recoverBody()
			end))
		end
		t64.setEnabled = function(p535, p536)
			local enabled = p536 == true

			if p535.enabled == enabled then
				return
			end

			p535.enabled = enabled

			if p535.enabled then
				p535:_recoverBody()
			else
				p535._stickyToken += 1
				p535:_restoreLocalState()
			end
		end
		t64.install = function(p537)
			if p537.destroyed then
				return false
			end

			getgenv().__SenaV4AntiGuard = p537
			p537:_installRagdollHooks()
			p537:_bindSignals()
			p537:_recoverBody()

			return true
		end

		local s2 = "destroy"

		local function v1880(p538)
			if p538.destroyed then
				return
			end

			p538.enabled = false
			p538:_restoreLocalState()
			p538.destroyed = true
			p538._stickyToken += 1

			for _, connection in ipairs(p538.connections) do
				v1840(connection)
			end

			table.clear(p538.connections)

			for k, v in pairs(p538.originalRagdoll) do
				if type(v) == "function" then
					Ragdoll[k] = v
				end
			end

			if p538._forestGate then
				pcall(rawset, p538._forestGate.comp, "_attackHandler", p538._forestGate.orig)

				if genv.__SenaV4ForestGate == p538._forestGate then
					genv.__SenaV4ForestGate = nil
				end

				p538._forestGate = nil
			end

			p538.eggRuntime = nil

			if getgenv().__SenaV4AntiGuard == p538 then
				getgenv().__SenaV4AntiGuard = nil
			end
		end

		t64[s2] = v1880
		t64.getStats = function(p539)
			return p539.stats
		end

		return t64
	end

	local v1885 = v1829()

	local function v1886()
		local Players2 = game:GetService("Players")

		game:GetService("RunService")

		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer2 = Players2.LocalPlayer
		local t66 = {}

		t66.__index = t66
		t66.new = function(p540)
			local obj = setmetatable({}, t66)

			obj.eggRuntime = p540
			obj.enabled = senaV4Config.GodMode == nil and true or senaV4Config.GodMode == true
			obj.active = false
			obj.activeDroppedUid = nil
			obj.swingSequence = 0
			obj.lastSwingAt = 0
			obj.defendThread = nil
			obj.connections = {}
			obj.targetRange = 35
			obj:_bindSignals()

			return obj
		end
		t66._isBat = function(p541, p542)
			if not p542 or not p542:IsA("Tool") then
				return false
			end

			local __SenaV4IsBatTool = genv.__SenaV4IsBatTool

			if __SenaV4IsBatTool and __SenaV4IsBatTool(p542) then
				return true
			end

			if not __SenaV4IsBatTool and (p542:GetAttribute("IsBat") == true or p542:GetAttribute("GearName") == "Bat") then
				return true
			end

			local attribute = p542:GetAttribute("ItemType")

			if attribute == nil or attribute == "Gear" then
				return string.find(string.lower(p542.Name), "slap", 1, true) ~= nil
			end

			return false
		end
		t66._findBat = function(p543)
			local Character = LocalPlayer2.Character
			local Backpack = LocalPlayer2:FindFirstChildOfClass("Backpack")

			if Character then
				for _, child in ipairs(Character:GetChildren()) do
					if not p543:_isBat(child) then
						continue
					end

					return child, true
				end
			end

			if Backpack then
				for _, child in ipairs(Backpack:GetChildren()) do
					if not p543:_isBat(child) then
						continue
					end

					return child, false
				end
			end

			pcall(function()
				local Networking = ReplicatedStorage2:FindFirstChild("Packages") and ReplicatedStorage2.Packages:FindFirstChild("Networking")
				local RFCodexAskWearFieldBat = Networking and Networking:FindFirstChild("RF/Codex/AskWearFieldBat")

				if RFCodexAskWearFieldBat then
					RFCodexAskWearFieldBat:InvokeServer()
				end
			end)

			return nil, false
		end
		t66._equipBat = function(p544)
			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if not Humanoid or Humanoid.Health <= 0 then
				return nil
			end

			local v1904, v1905 = p544:_findBat()

			if not v1904 then
				return nil
			end

			if v1905 and v1904.Parent == Character then
				return v1904
			end

			pcall(Humanoid.EquipTool, Humanoid, v1904)

			local v1906 = os.clock() + 0.35

			while true do
				if not (os.clock() < v1906) then
					return v1904.Parent == Character and v1904 or nil
				end

				if v1904.Parent == Character then
					break
				end

				task.wait(0.05)
			end

			return v1904
		end
		t66._getNearbyEnemies = function(p545)
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				return {}
			end

			local t67 = {}

			for _, player in ipairs(Players2:GetPlayers()) do
				if player ~= LocalPlayer2 and player.Character then
					local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

					if HumanoidRootPart2 and Humanoid and Humanoid.Health > 0 then
						local Magnitude = (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude

						if Magnitude <= p545.targetRange then
							table.insert(t67, {
								player = player,
								root = HumanoidRootPart2,
								humanoid = Humanoid,
								distance = Magnitude
							})
						end
					end
				end
			end

			table.sort(t67, function(p546, p547)
				return p546.distance < p547.distance
			end)

			return t67
		end
		t66._swing = function(p548, p549, p550)
			if not p549 or p549.Parent ~= LocalPlayer2.Character then
				return false
			end

			local serverTimeNow = workspace:GetServerTimeNow()

			if serverTimeNow - p548.lastSwingAt < 0.22 then
				return false
			end

			p548.lastSwingAt = serverTimeNow
			pcall(p549.Activate, p549)

			local Handle = p549:FindFirstChild("Handle") or p549:FindFirstChildWhichIsA("BasePart", true)

			if Handle and p550 and type(firetouchinterest) == "function" then
				pcall(function()
					firetouchinterest(Handle, p550, 0)
					task.wait(0.01)
					firetouchinterest(Handle, p550, 1)
				end)
			end

			pcall(function()
				local BatSwing = require(ReplicatedStorage2.Shared.Remotes).BatSwing

				if BatSwing and BatSwing.Trigger then
					p548.swingSequence += 1

					local v1918 = string.format("%d:%d:%d", LocalPlayer2.UserId, p548.swingSequence, math.floor(serverTimeNow * 1000))

					BatSwing.Trigger:FireServer(nil, v1918)
				end
			end)

			return true
		end
		t66.startDefend = function(p551, p552)
			if not p551.enabled then
				return
			end

			if p551.eggRuntime and p551.eggRuntime.instantPhase == "priming" then
				return
			end

			if p552 and p551.eggRuntime then
				if p551.eggRuntime:isSkippedEgg(p552) then
					return
				end
			end

			local __SenaV4PlayerSteal = genv.__SenaV4PlayerSteal

			if __SenaV4PlayerSteal and __SenaV4PlayerSteal.running then
				return
			end

			p551.active = true
			p551.activeDroppedUid = p552 or p551.activeDroppedUid

			if not p551.defendThread then
				p551.defendThread = task.spawn(function()
					local v1920 = false

					while p551.active and p551.enabled and (not p551.eggRuntime or not p551.eggRuntime.carry or not p551.eggRuntime.carry.active) do
						local __SenaV4PlayerSteal2 = genv.__SenaV4PlayerSteal

						if __SenaV4PlayerSteal2 and __SenaV4PlayerSteal2.running then
							v1920 = true

							break
						end

						local v1922 = p551:_getNearbyEnemies()

						if #v1922 > 0 then
							local v1923 = p551:_equipBat()

							if v1923 then
								for _, v in ipairs(v1922) do
									if v.root and v.root.Parent then
										p551:_swing(v1923, v.root)
									end
								end
							end
						end

						task.wait(0.1)
					end

					p551.active = false
					p551.defendThread = nil

					if v1920 then
						return
					end

					pcall(function()
						local Character = LocalPlayer2.Character
						local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

						if Humanoid then
							Humanoid:UnequipTools()
						end
					end)
				end)

				return
			end
		end
		t66.stopDefend = function(p553)
			p553.active = false
			p553.activeDroppedUid = nil
		end
		t66.setEnabled = function(p554, p555)
			p554.enabled = p555 == true

			if not p554.enabled then
				p554:stopDefend()
			end
		end
		t66._bindSignals = function(p556)
			pcall(function()
				table.insert(p556.connections, require(ReplicatedStorage2.Client.EggState).CarryChanged:Connect(function(p557)
					if p557.IsCarrying then
						p556:stopDefend()
					elseif p556.enabled then
						p556:startDefend(p557.Uid)
					end
				end))
			end)
			pcall(function()
				local Remotes = require(ReplicatedStorage2.Shared.Remotes)
				local ForestStrike = Remotes.GuardPatrol and Remotes.GuardPatrol.ForestStrike

				if ForestStrike then
					table.insert(p556.connections, ForestStrike.OnClientEvent:Connect(function()
						if p556.enabled then
							p556:startDefend()
						end
					end))
				end
			end)
		end
		t66.destroy = function(p558)
			p558:stopDefend()

			for _, connection in ipairs(p558.connections) do
				pcall(connection.Disconnect, connection)
			end

			table.clear(p558.connections)
		end

		return t66
	end

	local v1932 = v1886()

	local function v1933()
		local Players2 = game:GetService("Players")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer2 = Players2.LocalPlayer
		local Remotes = require(ReplicatedStorage2.Shared.Remotes)
		local PlotState2 = require(ReplicatedStorage2.Client.PlotState)
		local Hud = require(ReplicatedStorage2.Client.Hud)
		local Save = require(ReplicatedStorage2.Shared.Save)
		local Treadmills = require(ReplicatedStorage2.Data.Treadmills)

		local function v1942()
			local treadmill = t25.blocker("treadmill")

			if treadmill then
				return "Yielding to " .. t25.TITLES[treadmill]
			end

			local treadmill2 = t25.holder("treadmill")

			if treadmill2 then
				return "Waiting for " .. t25.TITLES[treadmill2]
			end

			return nil
		end
		local function v1945()
			return v1942() ~= nil
		end
		local function v1946()
			return t25.blocker("treadmill") == "auto_steal"
		end
		local function v1947()
			return v1942() or "Yielding"
		end

		local t68 = {}

		t68.__index = t68
		t68.new = function(p559, p560)
			local obj = setmetatable({}, t68)

			obj.coordinator = p559
			obj.travel = p560
			obj.destroyed = false
			obj.listeners = {}
			obj.resources = {}
			obj.config = {
				disableDuringAutomation = true,
				idleFarm = false,
				autoUpgrade = false
			}
			obj.stats = {
				mode = "Idle",
				boost = "Waiting"
			}
			obj.busy = p559 and p559:getSnapshot().busy == true or false
			obj.idleGeneration = 0
			obj.lastEquipAt = 0
			obj.activeTreadmill = nil
			obj.travelingToTreadmill = false
			obj.treadmillEquipPending = false
			obj.unequipGuardRunning = false
			obj.backgroundYieldRunning = false
			obj.lastBackgroundYieldAt = 0
			obj.carryPulseRunning = false
			obj.treadmillStateRevision = 0
			obj:_listenActiveTreadmill()
			task.spawn(function()
				pcall(function()
					obj:_syncActiveTreadmillSnapshot()
				end)
			end)
			obj:_listenCoordinator()
			obj:_listenSpeedGain()

			return obj
		end
		t68._snapshot = function(p561)
			return {
				mode = p561.stats.mode,
				boost = p561.stats.boost,
				disableDuringAutomation = p561.config.disableDuringAutomation,
				idleFarm = p561.config.idleFarm
			}
		end
		t68._emit = function(p562)
			local v1950 = p562:_snapshot()

			for _, listener in ipairs(p562.listeners) do
				pcall(listener, v1950)
			end
		end
		t68._setStatus = function(p563, p564, p565)
			if p564 ~= nil then
				p563.stats.mode = p564
			end

			if p565 ~= nil then
				p563.stats.boost = p565
			end

			p563:_emit()
		end
		t68.subscribe = function(p566, p567)
			table.insert(p566.listeners, p567)
			pcall(p567, p566:_snapshot())

			local function v1953()
				local v1954 = table.find(p566.listeners, p567)

				if v1954 then
					table.remove(p566.listeners, v1954)
				end
			end

			return v1953
		end
		t68._requestUnequip = function()
			local ok, result, result2 = pcall(function()
				return Remotes.Treadmill.AskDoff:InvokeServer()
			end)

			if not ok then
				return false, tostring(result)
			end

			if result ~= false then
				return true
			end

			local v1958 = false
			local tostring_ = tostring
			local v1960 = result2 or "Server rejected"

			return v1958, tostring_(v1960)
		end
		t68._shouldBlockTreadmill = function(p568)
			if p568.destroyed or p568.carryPulseRunning then
				return false
			end

			if p568.busy and p568.config.disableDuringAutomation then
				return true
			end

			local __SenaV4EggRuntime = genv.__SenaV4EggRuntime

			if __SenaV4EggRuntime and __SenaV4EggRuntime._treadmillResetting then
				return false
			end

			local ok, result = pcall(t25.holder, "treadmill")

			return ok and result ~= nil
		end
		t68._startUnequipGuard = function(p569)
			if p569.unequipGuardRunning or not p569:_shouldBlockTreadmill() or p569.activeTreadmill == nil then
				return
			end

			p569.unequipGuardRunning = true
			task.spawn(function()
				local n35 = 0.15

				while p569:_shouldBlockTreadmill() and p569.activeTreadmill ~= nil do
					local v1965, v1966 = p569:_requestUnequip()

					p569:_setStatus("Automation active", v1965 and "Blocked" or "Release retry: " .. tostring(v1966))
					task.wait(n35)
					n35 = math.min(n35 * 2, 0.75)
				end

				p569.unequipGuardRunning = false

				if p569:_shouldBlockTreadmill() and p569.activeTreadmill ~= nil then
					p569:_startUnequipGuard()
				end
			end)
		end
		t68._cancelIdle = function(p570, p571)
			p570.idleGeneration += 1

			if p571 then
				p570:_requestUnequip()
			end
		end
		t68.setDisableDuringAutomation = function(p572)
			p572.config.disableDuringAutomation = true

			if p572.busy and p572.config.disableDuringAutomation then
				p572:_cancelIdle(true)
				p572:_startUnequipGuard()
				p572:_setStatus("Automation active", "Blocked")
			elseif not p572.busy and p572.config.idleFarm then
				p572:_startIdle()
			end
		end
		t68.setIdleFarm = function(p573, p574)
			p573.config.idleFarm = p574 == true

			if not p573.config.idleFarm then
				p573:_cancelIdle(true)
				p573:_setStatus(p573.busy and "Automation active" or "Idle", "Disabled")

				return
			end

			if not p573.busy then
				p573:_startIdle()
			end

			if p573.idleWatchdog then
				return
			end

			p573.idleWatchdog = task.spawn(function()
				while not p573.destroyed and p573.config.idleFarm do
					task.wait(2)

					if p573.idleRunning == nil and not p573.busy and p573.config.idleFarm and not p573.destroyed then
						p573:_startIdle()
					end
				end

				p573.idleWatchdog = nil
			end)
		end
		t68._readUpgradeState = function()
			local ok, result, result2, result3 = pcall(function()
				local v1971 = (Save.Peek or Save.Get)()

				if not v1971 then
					return nil
				end

				local v1972 = tonumber(v1971.TreadmillUpgradeLevel) or 0

				return v1972, v1971.Money, Treadmills.GetByUpgradeLevel(v1972 + 1)
			end)

			if not ok or result == nil then
				return nil
			end

			return result, result2, result3
		end
		t68._raiseTier = function(p575)
			local _, v1974, v1975 = p575:_readUpgradeState()

			if not v1975 then
				return false, "Max tier"
			end

			if (tonumber(v1974) or 0) < (tonumber(v1975.Price) or 0) then
				return false, "Not enough money"
			end

			local ok, result, result2 = pcall(function()
				return Remotes.Treadmill.AskTierRaise:InvokeServer(v1975._id)
			end)

			if not ok then
				return false, tostring(result)
			end

			if result ~= true then
				local v1979 = false
				local tostring_ = tostring
				local v1981 = result2 or "Server rejected"

				return v1979, tostring_(v1981)
			end

			local v1982 = true
			local DisplayName = v1975.DisplayName or v1975._id

			return v1982, DisplayName
		end
		t68.setAutoUpgrade = function(p576, p577)
			p576.config.autoUpgrade = p577 == true

			if not p576.config.autoUpgrade or p576.autoUpgradeRunning then
				return
			end

			p576.autoUpgradeRunning = true
			task.spawn(function()
				while not p576.destroyed and p576.config.autoUpgrade do
					while true do
						local v1984, v1985 = p576:_raiseTier()

						if v1984 then
							p576:_setStatus(p576.busy and "Automation active" or "Idle", "Upgraded to " .. tostring(v1985))
							task.wait(1)
						else
							if v1985 ~= "Max tier" then
								break
							end

							p576:_setStatus(p576.busy and "Automation active" or "Idle", "Treadmill maxed")
							task.wait(30)
						end

						if not p576.destroyed and p576.config.autoUpgrade then
							continue
						end

						p576.autoUpgradeRunning = false

						return
					end

					task.wait(5)
				end

				p576.autoUpgradeRunning = false
			end)
		end
		t68._resolveStandCFrame = function()
			local v1986 = PlotState2.ResolveLocalSlot()
			local v1987 = PlotState2.ResolveFolder()
			local v1988 = v1987 and v1986 and v1987:FindFirstChild(tostring(v1986))
			local TreadmillBottom = v1988 and v1988:FindFirstChild("TreadmillBottom")

			if not TreadmillBottom or not TreadmillBottom:IsA("BasePart") then
				return nil
			end

			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if not HumanoidRootPart or not Humanoid then
				return nil
			end

			local v1993

			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				v1993 = HumanoidRootPart.Size.Y * 0.5 + math.max(Humanoid.HipHeight, 0.5)
			else
				v1993 = HumanoidRootPart.Size.Y * 0.5 + 2
			end

			return TreadmillBottom.CFrame * cFrameNew(0, TreadmillBottom.Size.Y * 0.5 + v1993 + 0.05, 0)
		end
		t68.isEngaged = function(p578)
			return p578.activeTreadmill ~= nil or p578.travelingToTreadmill or p578.treadmillEquipPending or p578.carryPulseRunning
		end
		t68._isTreadmillHudActive = function()
			local ok, result = pcall(function()
				local Game = Hud.Frame("Game")
				local Treadmill = Hud.Frame("Treadmill")

				return Game.Visible == false and Treadmill.Visible == true
			end)
			local v1998 = ok and result == true

			return v1998
		end
		t68._isGameHudRestored = function()
			local ok, result = pcall(function()
				local Game = Hud.Frame("Game")
				local Treadmill = Hud.Frame("Treadmill")

				return Game.Visible == true and Treadmill.Visible == false
			end)
			local v2003 = ok and result == true

			return v2003
		end
		t68.pulseForCarry = function(p579, p580, p581)
			if p579.destroyed or p579.carryPulseRunning or type(p580) ~= "function" then
				return false, "Preparation unavailable"
			end

			p579:_cancelIdle(false)
			p579.carryPulseRunning = true

			local function v2004()
				return p579.destroyed or p581 ~= nil and p581()
			end
			local function v2005(p582)
				local v2006 = os.clock() + p582
				local n36 = 0
				local v2008
				local treadmillStateRevision = p579.treadmillStateRevision

				while not p579.destroyed and os.clock() < v2006 do
					local now = os.clock()

					if n36 <= now then
						p579:_requestUnequip()
						n36 = now + 0.15
					end

					local v2011 = p579:_syncActiveTreadmillSnapshot()
					local v2012 = p579:_isGameHudRestored()

					if p579.treadmillStateRevision ~= treadmillStateRevision then
						treadmillStateRevision = p579.treadmillStateRevision
						v2008 = nil
					end

					if not v2011 and p579.activeTreadmill == nil and v2012 then
						v2008 = v2008 or now

						if now - v2008 >= 0.35 then
							return true
						end
					else
						v2008 = nil
					end

					task.wait(0.03)
				end

				return false
			end
			local function v2013(p583, p584)
				if not p583 then
					v2005(1.85)
				end

				p579.treadmillEquipPending = false
				p579.carryPulseRunning = false

				if p583 then
					p579:_setStatus("Automation active", "Preparation complete")
				elseif not p579.destroyed then
					p579:_setStatus("Automation active", tostring(p584 or "Preparation failed"))
				end

				if p579:_shouldBlockTreadmill() and p579.activeTreadmill ~= nil then
					p579:_startUnequipGuard()
				end

				return p583, p584
			end

			p579:_syncActiveTreadmillSnapshot()

			local v2014 = false
			local v2015

			for i = 1, 3 do
				if v2004() then
					return v2013(false, "Cancelled")
				end

				local v2017 = p579:_resolveStandCFrame()

				if v2017 then
					p579:_setStatus("Preparing carry", i == 1 and "Positioning" or "Repositioning")

					local ok, result = pcall(p580, v2017)

					if ok and result == true then
						task.wait(0.35)
						p579.treadmillEquipPending = true
						p579:_setStatus("Preparing carry", "Activating")

						local v2020 = os.clock() + 2.5
						local n37 = 0
						local n38 = 0

						while not v2004() and os.clock() < v2020 do
							local now = os.clock()

							if n38 <= now then
								n38 = now + 0.25
								p579:_syncActiveTreadmillSnapshot()
							end

							if p579.activeTreadmill ~= nil and p579:_isTreadmillHudActive() then
								v2014 = true

								break
							end

							if p579.activeTreadmill == nil and n37 <= now then
								n37 = now + 0.2

								local ok2, result2, result3 = pcall(function()
									return Remotes.Treadmill.AskWearStill:InvokeServer()
								end)

								if not ok2 or result2 == false then
									v2015 = tostring(result3 or result2)
									p579:_setStatus("Preparing carry", "Activation retry")
								end
							end

							task.wait(0.03)
						end
					else
						v2015 = "Positioning failed"
					end
				else
					v2015 = "Position unavailable"
				end

				if v2014 then
					break
				end

				if not v2004() then
					p579:_setStatus("Preparing carry", "Resetting position")
					v2005(1.85)

					continue
				end

				return v2013(false, "Cancelled")
			end

			if not v2014 then
				local v2027 = v2013
				local v2028 = false
				local tostring_ = tostring
				local v2030 = v2015 or "Unknown"

				return v2027(v2028, "Activation not confirmed: " .. tostring_(v2030))
			end

			p579.treadmillEquipPending = false
			p579:_setStatus("Preparing carry", "Active")

			local v2031 = os.clock() + 0.1

			while not v2004() and os.clock() < v2031 do
				task.wait(0.03)
			end

			if v2004() then
				return v2013(false, "Cancelled")
			end

			p579:_setStatus("Preparing carry", "Releasing")

			if v2005(1.85) then
				return v2013(true)
			end

			local v2032 = v2013
			local v2033 = false
			local v2034 = v2004() and "Cancelled" or "Release not confirmed"

			return v2032(v2033, v2034)
		end
		t68.yieldForBackground = function(p585)
			if p585.destroyed then
				return
			end

			p585:_cancelIdle(false)

			if p585.backgroundYieldRunning then
				return
			end

			p585.backgroundYieldRunning = true
			task.spawn(function()
				local n39 = 0.15

				while not p585.destroyed do
					if p585.coordinator and p585.coordinator:isBackgroundBusy() then
						p585.lastBackgroundYieldAt = os.clock()
						p585:_setStatus("Idle", "Yielding to background inventory")
						p585:_requestUnequip()
						task.wait(n39)

						if p585:_syncActiveTreadmillSnapshot() then
							n39 = math.min(n39 * 2, 0.75)

							continue
						end
					end

					break
				end

				p585.backgroundYieldRunning = false

				if not p585.destroyed and not p585:isEngaged() then
					p585:_setStatus("Idle", "Background inventory ready")
				end
			end)
		end
		t68._startIdle = function(p586)
			if p586.destroyed or p586.busy or not p586.config.idleFarm then
				return
			end

			p586:_cancelIdle(false)

			local idleGeneration = p586.idleGeneration
			local now = os.clock()

			p586.idleRunning = idleGeneration
			task.spawn(function()
				local ok, result = xpcall(function()
					while not p586.destroyed and not p586.busy and p586.config.idleFarm and idleGeneration == p586.idleGeneration do
						if p586.coordinator then
							if p586.coordinator:isBackgroundBusy() then
								now = os.clock()
								p586:_setStatus("Idle", "Waiting for background inventory")
								task.wait(0.25)

								continue
							end
						end

						if v1946() then
							now = os.clock()
							p586:_setStatus("Idle", "Yielding to Auto Steal")
							task.wait(0.25)
						elseif genv.__SenaV4IsAutoSellEggBusy and genv.__SenaV4IsAutoSellEggBusy() then
							now = os.clock()
							p586:_setStatus("Idle", "Waiting for Auto Sell Egg")
							task.wait(0.25)
						elseif v1945() then
							now = os.clock()
							p586:_setStatus("Idle", v1947())
							task.wait(0.25)
						else
							local v2040 = 1 - (os.clock() - now)

							if v2040 > 0 then
								p586:_setStatus("Idle", string.format("Starting in %.0fs", math.ceil(v2040)))
								task.wait(math.min(v2040, 0.25))
							else
								local v2041 = p586:_resolveStandCFrame()

								if v2041 then
									p586.travelingToTreadmill = true
									p586:_setStatus("Moving", "Waiting")

									local travel = p586.travel and p586.travel:travelAndWait(v2041, {
										abort = function()
											return p586.destroyed or p586.busy or not p586.config.idleFarm or idleGeneration ~= p586.idleGeneration or p586.coordinator and p586.coordinator:isBackgroundBusy() or genv.__SenaV4IsAutoSellEggBusy and genv.__SenaV4IsAutoSellEggBusy() or v1945()
										end
									})

									p586.travelingToTreadmill = false

									if not travel then
										if not p586.busy and p586.config.idleFarm then
											p586:_setStatus("Idle", "Travel failed")
											task.wait(1)
										end
									elseif not p586.busy and p586.config.idleFarm and idleGeneration == p586.idleGeneration then
										if p586.coordinator then
											if p586.coordinator:isBackgroundBusy() then
												continue
											end
										end

										if (not genv.__SenaV4IsAutoSellEggBusy or not genv.__SenaV4IsAutoSellEggBusy()) and not v1945() then
											task.wait(0.35)

											if not p586.busy and p586.config.idleFarm and idleGeneration == p586.idleGeneration then
												if p586.coordinator then
													if p586.coordinator:isBackgroundBusy() then
														continue
													end
												end

												if (not genv.__SenaV4IsAutoSellEggBusy or not genv.__SenaV4IsAutoSellEggBusy()) and not v1945() then
													p586.treadmillEquipPending = true

													local ok, result, result2 = pcall(function()
														return Remotes.Treadmill.AskWearStill:InvokeServer()
													end)

													if ok and result ~= false then
														p586.lastEquipAt = os.clock()
														p586:_setStatus("Active", "Waiting for gain")
														task.delay(2, function()
															if not p586.destroyed and p586.activeTreadmill == nil then
																p586.treadmillEquipPending = false
															end
														end)

														local v2046 = os.clock() + 8

														while (p586.activeTreadmill ~= nil or os.clock() < v2046) and not p586.destroyed and not p586.busy and p586.config.idleFarm and idleGeneration == p586.idleGeneration do
															local ok33 = not p586.coordinator

															if not ok33 then
																ok33 = not p586.coordinator:isBackgroundBusy()
															end

															if not ok33 then
																break
															end

															if v1946() then
																p586:_cancelIdle(true)
																p586:_setStatus("Idle", "Yielding to Auto Steal")

																break
															end

															if not genv.__SenaV4IsAutoSellEggBusy or not genv.__SenaV4IsAutoSellEggBusy() then
																if not v1945() then
																	task.wait(0.25)

																	continue
																end

																p586:_requestUnequip()
																p586:_setStatus("Idle", v1947())

																break
															end

															p586:_cancelIdle(true)
															p586:_setStatus("Idle", "Yielding to Auto Sell Egg")

															break
														end

														continue
													end

													p586.treadmillEquipPending = false
													p586:_setStatus("Preparing carry", "Activation failed: " .. tostring(result2 or result))

													local v2048 = os.clock() + 8

													while true do
														local coordinator

														if p586.activeTreadmill == nil then
															if os.clock() < v2048 and not p586.destroyed and not p586.busy and p586.config.idleFarm and idleGeneration == p586.idleGeneration then
																if not p586.coordinator then
																	if v1946() then
																		p586:_cancelIdle(true)
																		p586:_setStatus("Idle", "Yielding to Auto Steal")

																		break
																	end

																	if not genv.__SenaV4IsAutoSellEggBusy or not genv.__SenaV4IsAutoSellEggBusy() then
																		if not v1945() then
																			task.wait(0.25)

																			continue
																		end

																		p586:_requestUnequip()
																		p586:_setStatus("Idle", v1947())

																		break
																	end

																	p586:_cancelIdle(true)
																	p586:_setStatus("Idle", "Yielding to Auto Sell Egg")

																	break
																end

																coordinator = p586.coordinator

																if not coordinator:isBackgroundBusy() then
																	if v1946() then
																		p586:_cancelIdle(true)
																		p586:_setStatus("Idle", "Yielding to Auto Steal")

																		break
																	end

																	if not genv.__SenaV4IsAutoSellEggBusy or not genv.__SenaV4IsAutoSellEggBusy() then
																		if not v1945() then
																			task.wait(0.25)

																			continue
																		end

																		p586:_requestUnequip()
																		p586:_setStatus("Idle", v1947())

																		break
																	end

																	p586:_cancelIdle(true)
																	p586:_setStatus("Idle", "Yielding to Auto Sell Egg")

																	break
																end
															end

															break
														end

														if not p586.destroyed and not p586.busy and p586.config.idleFarm and idleGeneration == p586.idleGeneration then
															if not p586.coordinator then
																if v1946() then
																	p586:_cancelIdle(true)
																	p586:_setStatus("Idle", "Yielding to Auto Steal")

																	break
																end

																if not genv.__SenaV4IsAutoSellEggBusy or not genv.__SenaV4IsAutoSellEggBusy() then
																	if not v1945() then
																		task.wait(0.25)

																		continue
																	end

																	p586:_requestUnequip()
																	p586:_setStatus("Idle", v1947())

																	break
																end

																p586:_cancelIdle(true)
																p586:_setStatus("Idle", "Yielding to Auto Sell Egg")

																break
															end

															coordinator = p586.coordinator

															if not coordinator:isBackgroundBusy() then
																if v1946() then
																	p586:_cancelIdle(true)
																	p586:_setStatus("Idle", "Yielding to Auto Steal")

																	break
																end

																if not genv.__SenaV4IsAutoSellEggBusy or not genv.__SenaV4IsAutoSellEggBusy() then
																	if not v1945() then
																		task.wait(0.25)

																		continue
																	end

																	p586:_requestUnequip()
																	p586:_setStatus("Idle", v1947())

																	break
																end

																p586:_cancelIdle(true)
																p586:_setStatus("Idle", "Yielding to Auto Sell Egg")

																break
															end
														end

														break
													end
												end
											end
										end
									end
								else
									p586:_setStatus("Idle", "Position unavailable")
									task.wait(2)
								end
							end
						end
					end
				end, debug.traceback)

				if not ok then
					warn("[SAE][treadmill] idle error:\n" .. tostring(result))
				end

				if p586.idleRunning == idleGeneration then
					p586.idleRunning = nil
				end
			end)
		end
		t68._onCoordinator = function(p587, p588)
			local busy = p587.busy

			p587.busy = p588.busy == true

			if p587.busy then
				p587:_cancelIdle(p587.config.disableDuringAutomation)
				p587:_startUnequipGuard()
				p587:_setStatus("Automation active", p587.config.disableDuringAutomation and "Blocked" or "Unchanged")
			elseif busy or p587.config.idleFarm then
				if p587.config.idleFarm then
					p587:_startIdle()
				else
					p587:_setStatus("Idle", "Disabled")
				end
			end
		end
		t68._listenCoordinator = function(p589)
			if not p589.coordinator then
				return
			end

			table.insert(p589.resources, p589.coordinator:subscribe(function(p590)
				p589:_onCoordinator(p590)
			end))
			table.insert(p589.resources, p589.coordinator:subscribeBackground(function(p591)
				if p591.busy then
					p589:_cancelIdle(false)
					p589:_setStatus("Idle", "Waiting for background inventory")
				elseif not p589.destroyed and not p589.busy and p589.config.idleFarm then
					p589:_startIdle()
				end
			end))
		end
		t68._syncActiveTreadmillSnapshot = function(p592)
			local ok, result = pcall(function()
				return Remotes.Treadmill.AskRenderSnapshot:InvokeServer()
			end)

			if not ok or type(result) ~= "table" then
				return p592.activeTreadmill ~= nil
			end

			local v2053 = table.find(result, LocalPlayer2.UserId) ~= nil

			p592.activeTreadmill = v2053 and "snapshot" or nil

			if not v2053 then
				p592.treadmillEquipPending = false
			end

			return v2053
		end
		t68._listenActiveTreadmill = function(p593)
			local function v2054(p594)
				p593.treadmillStateRevision += 1
				p593.activeTreadmill = p594
				p593.treadmillEquipPending = false

				if p594 ~= nil and p593:_shouldBlockTreadmill() then
					p593:_startUnequipGuard()
				elseif p594 == nil and p593:_shouldBlockTreadmill() then
					p593:_setStatus("Automation active", "Blocked")
				elseif p594 == nil then
					p593:_setStatus("Idle", p593.config.idleFarm and "Released" or "Disabled")
				elseif not p593.busy then
					p593:_setStatus("Active", "Waiting for gain")
				end
			end

			local AssignedBeltShifted
			local RenderStateShifted

			pcall(function()
				AssignedBeltShifted = Remotes.Treadmill.AssignedBeltShifted
			end)
			pcall(function()
				RenderStateShifted = Remotes.Treadmill.RenderStateShifted
			end)

			if AssignedBeltShifted then
				table.insert(p593.resources, AssignedBeltShifted.OnClientEvent:Connect(function(p595)
					v2054(p595)
				end))

				return
			end

			if RenderStateShifted then
				table.insert(p593.resources, RenderStateShifted.OnClientEvent:Connect(function(p596, p597)
					if p596 ~= LocalPlayer2.Name then
						return
					end

					local v2057 = v2054
					local v2058 = p597 and p596

					v2057(v2058 or nil)
				end))
			end
		end
		t68._listenSpeedGain = function(p598)
			local SpeedGained = Remotes.Treadmill.SpeedGained

			if SpeedGained then
				table.insert(p598.resources, SpeedGained.OnClientEvent:Connect(function()
					p598.activeTreadmill = p598.activeTreadmill or true
					p598.treadmillEquipPending = false

					if not p598:_shouldBlockTreadmill() then
						p598:_setStatus("Active", "Gain ticking")

						return
					end

					p598:_startUnequipGuard()
				end))
			end
		end
		t68.destroy = function(p599)
			if p599.destroyed then
				return
			end

			p599.destroyed = true
			p599:_cancelIdle(true)

			for _, resource in ipairs(p599.resources) do
				pcall(function()
					if typeof(resource) == "RBXScriptConnection" then
						resource:Disconnect()
					elseif type(resource) == "function" then
						resource()
					elseif type(resource) == "table" and type(resource.Disconnect) == "function" then
						resource:Disconnect()
					end
				end)
			end

			table.clear(p599.resources)
			table.clear(p599.listeners)
		end
		t68.Destroy = t68.destroy

		return t68
	end

	local v2062 = v1933()
	local v2063 = v662.new()

	v612 = v1823.new(v611, v703, v2063)
	genv.__SenaV4EggRuntime = v612
	v613 = v2062.new(v2063, v612)
	genv.__SenaV4TreadmillManager = v613
	v612:setTreadmillManager(v613)
	v613:setDisableDuringAutomation(true)

	if senaV4Config.AutoTreadmillIdle then
		v613:setIdleFarm(true)
	end

	if senaV4Config.AutoIndex then
		v612:setIndexObjective(true)
	end

	if senaV4Config.AutoTreadmillUpgrade then
		v613:setAutoUpgrade(true)
	end

	local function v2064()
		local HttpService = game:GetService("HttpService")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer2 = game:GetService("Players").LocalPlayer
		local http_request_ = http_request or request or http and http.request or syn and syn.request or fluxus and fluxus.request
		local t70 = {}
		local u2071 = false
		local t71 = {}
		local u2073
		local AssetEarnings
		local EggRecords

		pcall(function()
			AssetEarnings = require(ReplicatedStorage2.Shared.Util.AssetEarnings)
		end)
		pcall(function()
			EggRecords = require(ReplicatedStorage2.Shared.Util.EggRecords)
		end)

		local function v2076(p600)
			local match = tostring(p600 or ""):match("%d+")

			if not match then
				return nil
			end

			local v2078 = t71[match]

			if v2078 ~= nil then
				if v2078 == "" then
					return nil
				end

				return v2078
			end

			local v2079

			for _, v in ipairs({
				"512x512",
				"150x150"
			}) do
				local imageUrl

				pcall(function()
					local v2083 = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. match .. "&size=" .. v .. "&format=Png&isCircular=false"
					local Body

					if http_request_ then
						local v2085 = http_request_({
							Url = v2083,
							Method = "GET"
						})

						Body = type(v2085) == "table" and (v2085.Body or v2085.body) or nil
					else
						Body = HttpService:GetAsync(v2083)
					end

					if type(Body) == "string" and Body ~= "" then
						local data = HttpService:JSONDecode(Body)
						local data2 = data and data.data and data.data[1]

						if data2 and data2.state == "Completed" and type(data2.imageUrl) == "string" and data2.imageUrl ~= "" then
							imageUrl = data2.imageUrl
						end
					end
				end)

				if imageUrl then
					v2079 = v2079 or imageUrl

					if imageUrl:find("/Png/", 1, true) then
						v2079 = imageUrl

						break
					else
					end
				else
				end
			end

			t71[match] = v2079 or ""

			return v2079
		end
		local function v2088()
			if u2073 == nil then
				u2073 = v2076("96240498384290") or false
			end

			return u2073 or nil
		end
		local function v2089()
			if u2071 then
				return
			end

			u2071 = true
			task.spawn(function()
				while #t70 > 0 do
					local v2090 = table.remove(t70, 1)

					pcall(function()
						if v2090.thumbAsset then
							local v2091 = v2090.payload.embeds[1]
							local v2092 = v2076(v2090.thumbAsset)

							if v2092 then
								v2091.thumbnail = {
									url = v2092
								}
							end
						end

						local json = HttpService:JSONEncode(v2090.payload)

						if http_request_ then
							http_request_({
								Url = v2090.url,
								Method = "POST",
								Headers = {
									["Content-Type"] = "application/json"
								},
								Body = json
							})
						else
							HttpService:PostAsync(v2090.url, json, Enum.HttpContentType.ApplicationJson)
						end
					end)
					task.wait(0.6)
				end

				u2071 = false
			end)
		end
		local function v2094(p601)
			if typeof(p601) == "Color3" then
				return math.floor(p601.R * 255 + 0.5) * 65536 + math.floor(p601.G * 255 + 0.5) * 256 + math.floor(p601.B * 255 + 0.5)
			end

			return 5814783
		end
		local function compact(p602)
			local Simple

			pcall(function()
				Simple = require(ReplicatedStorage2.Packages.FormatNumber.Simple)
			end)

			if Simple and Simple.FormatCompact then
				local ok, result = pcall(Simple.FormatCompact, p602, ".#")

				if ok and result then
					return tostring(result)
				end
			end

			local format = string.format
			local s3 = "%.1f"
			local v2101 = p602 or 0

			return format(s3, v2101)
		end

		local t69 = {
			compact = compact,
			rateOf = function(p603)
				if not AssetEarnings or type(p603) ~= "table" then
					return 0
				end

				local v2102 = tonumber(p603.AssetScale) or 1
				local t72 = {
					Category = p603.AssetCategory,
					Scale = v2102,
					AssetScale = v2102,
					BaseMutation = p603.BaseMutation,
					Mutations = p603.Mutations or {}
				}

				for _, v in ipairs({
					"LiveRatePerSecond",
					"RatePerSecond",
					"CatalogRatePerSecond"
				}) do
					if type(AssetEarnings[v]) == "function" then
						local ok, result = pcall(AssetEarnings[v], t72)

						if ok and type(result) == "number" and result > 0 then
							return result
						end
					end
				end

				return 0
			end,
			weightOf = function(p604)
				if not EggRecords or type(p604) ~= "table" then
					return 0
				end

				local ok, result = pcall(EggRecords.WeightKgForScale, p604.AssetCategory, tonumber(p604.AssetScale) or 1)

				if ok and type(result) == "number" then
					return result
				end

				return 0
			end,
			sizeText = function(p605)
				local v2110 = tonumber(p605 and (p605.AssetScale or p605.Scale)) or 1

				if v2110 >= 100 then
					return string.format("%.0fx", v2110)
				end

				return string.format("%.2fx", v2110)
			end,
			weightText = function(p606)
				local v2111 = tonumber(p606) or 0

				if v2111 >= 1000 then
					return compact(v2111) .. " kg"
				end

				return string.format("%.1fkg", v2111)
			end,
			rateText = function(p607)
				local v2112 = tonumber(p607) or 0

				if v2112 >= 1000 then
					return "$" .. compact(v2112) .. "/s"
				end

				return string.format("$%d/s", math.floor(v2112))
			end,
			passes = function(p608, p609, p610)
				local t73 = {}
				local v2114 = false
				local ipairs_ = ipairs
				local WebhookRarities = senaV4Config.WebhookRarities or {}

				for _, WebhookRarity in ipairs_(WebhookRarities) do
					if WebhookRarity ~= "None" and WebhookRarity ~= "" then
						t73[WebhookRarity] = true
						v2114 = true
					end
				end

				if v2114 and not t73[p609.rarity] then
					return false
				end

				local v2119 = tonumber(senaV4Config.WebhookMinValue) or 0

				if v2119 > 0 and p610 < v2119 then
					return false
				end

				return true
			end
		}
		local t74 = {
			"Image",
			"Icon",
			"Thumbnail",
			"ImageId",
			"IconId",
			"Texture",
			"Asset",
			"DisplayImage"
		}

		t69.eggAsset = function(p611)
			local Directory

			pcall(function()
				Directory = require(ReplicatedStorage2.Data.Assets).Directory
			end)

			local v2122 = Directory and Directory[p611]

			if type(v2122) ~= "table" then
				return nil
			end

			for _, v in ipairs({
				v2122,
				v2122.Egg,
				v2122.Pet
			}) do
				if type(v) == "table" then
					for _, v2 in ipairs(t74) do
						local v2127 = v[v2]
						local match = (type(v2127) == "string" or type(v2127) == "number") and tostring(v2127):match("%d+")

						if not match or not (tonumber(match) > 0) then
							continue
						end

						return match
					end
				end
			end

			return nil
		end
		t69.stolen = function(p612, p613, p614)
			if senaV4Config.WebhookEnabled ~= true then
				return
			end

			local WebhookURL = senaV4Config.WebhookURL

			if type(WebhookURL) ~= "string" or WebhookURL == "" then
				return
			end

			if not (type(p612) == "table" and p612.AssetCategory) then
				return
			end

			local v2130 = p613 or {
				name = p612.AssetCategory,
				rarity = "Unknown",
				rarityColor = nil
			}
			local v2131 = t69.rateOf(p612)

			if not t69.passes(p612, v2130, v2131) then
				return
			end

			local t75 = {
				{
					name = "User",
					value = LocalPlayer2.Name,
					inline = true
				},
				{
					name = "Rarity",
					value = tostring(v2130.rarity),
					inline = true
				},
				{
					name = "Size",
					value = t69.sizeText(p612),
					inline = true
				},
				{
					name = "Weight",
					value = t69.weightText(t69.weightOf(p612)),
					inline = true
				},
				{
					name = "Cash/s",
					value = t69.rateText(v2131),
					inline = true
				},
				{
					name = "Area",
					value = tostring(p612.AreaId or "?"),
					inline = true
				}
			}
			local Mutations = p612.Mutations or {}

			if #Mutations > 0 then
				local t82 = {}

				for _, Mutation in ipairs(Mutations) do
					t82[#t82 + 1] = tostring(Mutation)
				end

				t75[#t75 + 1] = {
					name = "Mutations",
					value = table.concat(t82, ", "),
					inline = false
				}
			end

			if p614 and p614 ~= "" then
				t75[#t75 + 1] = {
					name = "Taken From",
					value = tostring(p614),
					inline = false
				}
			end

			local v2143 = v2088()
			local t83 = {
				title = "Egg Stolen",
				description = string.format("You've stolen a **%s** %s", tostring(v2130.rarity), tostring(v2130.name)),
				color = v2094(v2130.rarityColor),
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
				author = {
					name = "Sena Hub",
					icon_url = v2143
				},
				footer = {
					text = "discord.gg/senahub",
					icon_url = v2143
				},
				fields = t75
			}

			if #t70 > 40 then
				table.remove(t70, 1)
			end

			table.insert(t70, {
				url = WebhookURL,
				payload = {
					embeds = { t83 }
				}
			})
			v2089()
		end
		t69.test = function()
			local WebhookURL = senaV4Config.WebhookURL

			if type(WebhookURL) ~= "string" or WebhookURL == "" then
				return false
			end

			local v2146 = v2088()
			local t84 = {
				title = "Webhook Test",
				description = string.format("Connection test for **%s**", LocalPlayer2.Name),
				color = 5814783,
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
				author = {
					name = "Sena Hub",
					icon_url = v2146
				},
				footer = {
					text = "discord.gg/senahub",
					icon_url = v2146
				},
				fields = {
					{
						name = "User",
						value = LocalPlayer2.Name,
						inline = true
					},
					{
						name = "User ID",
						value = tostring(LocalPlayer2.UserId),
						inline = true
					},
					{
						name = "Place ID",
						value = tostring(game.PlaceId),
						inline = true
					},
					{
						name = "Status",
						value = "Connected",
						inline = true
					}
				}
			}
			local v2148 = v2076("96240498384290")

			if v2148 then
				t84.thumbnail = {
					url = v2148
				}
			end

			table.insert(t70, {
				url = WebhookURL,
				payload = {
					embeds = { t84 }
				}
			})
			v2089()

			return true
		end

		return t69
	end

	genv.__SenaV4Webhook = v2064()

	local function v2149()
		local Players2 = game:GetService("Players")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer2 = Players2.LocalPlayer
		local EggState2 = require(ReplicatedStorage2.Client.EggState)
		local AreaEggs = require(ReplicatedStorage2.Shared.Types.AreaEggs)
		local t85 = {}

		t85.__index = t85

		local t86 = {
			1.1,
			0.2,
			0.7,
			1.4,
			0.45
		}

		t85.new = function(p615, p616, p617)
			local obj = setmetatable({}, t85)

			obj.eggRuntime = p615
			obj.godMode = p616
			obj.catalog = p617
			obj.enabled = false
			obj.running = false
			obj.status = "idle"
			obj.taken = 0
			obj.attempts = 0
			obj.history = {}
			obj.blacklist = {}
			obj.forced = false
			obj.listeners = {}
			obj.swingSeq = 0
			obj.leadIdx = 1
			obj.hitIdx = nil
			obj.missStreak = 0

			return obj
		end
		t85.onChanged = function(p618, p619)
			table.insert(p618.listeners, p619)
		end
		t85._notify = function(p620)
			for _, listener in ipairs(p620.listeners) do
				pcall(listener, p620)
			end
		end
		t85._setStatus = function(p621, p622)
			if p621.status == p622 then
				return
			end

			p621.status = p622
			p621:_notify()
		end
		t85._log = function(p623, p624, p625, p626)
			table.insert(p623.history, 1, {
				at = os.time(),
				player = p624 or "?",
				egg = p625 or "?",
				outcome = p626 or "?"
			})

			while #p623.history > 20 do
				table.remove(p623.history)
			end

			p623:_notify()
		end
		t85.setEnabled = function(p627, p628)
			p627.enabled = p628 == true

			if p627.enabled then
				p627:_setStatus("looking for a carrier")
				p627:_start()
			else
				p627:_setStatus("idle")
			end
		end
		t85._passes = function(p629, p630)
			if not (type(p630) == "table" and p630.AssetCategory) then
				return false
			end

			local v2160 = p629.catalog.resolve(p630)
			local t87 = {}
			local v2162 = false
			local ipairs_ = ipairs
			local StealPlayerRarities = senaV4Config.StealPlayerRarities or {}

			for _, StealPlayerRarity in ipairs_(StealPlayerRarities) do
				if StealPlayerRarity ~= "None" and StealPlayerRarity ~= "" then
					t87[StealPlayerRarity] = true
					v2162 = true
				end
			end

			if not v2162 then
				local ipairs_2 = ipairs
				local StealRarities = senaV4Config.StealRarities or {}

				for _, StealRarity in ipairs_2(StealRarities) do
					if StealRarity ~= "None" and StealRarity ~= "" then
						t87[StealRarity] = true
						v2162 = true
					end
				end
			end

			if v2162 and not t87[v2160.rarity] then
				return false
			end

			local v2171 = tonumber(senaV4Config.StealPlayerMinValue) or 0

			if v2171 > 0 then
				if (genv.__SenaV4Webhook and genv.__SenaV4Webhook.rateOf(p630) or 0) < v2171 then
					return false
				end
			end

			return true
		end
		t85.carriers = function(p631)
			local t88 = {}
			local ok, result = pcall(function()
				return EggState2.ReadFieldEggs()
			end)

			if not ok or not result then
				return t88
			end

			local ipairs_ = ipairs
			local Records = result.Records or {}

			for _, Record in ipairs_(Records) do
				if (Record.State == "Carried" or AreaEggs and AreaEggs.States and Record.State == AreaEggs.States.Carried) and not p631.blacklist[Record.Uid] then
					local u2179

					pcall(function()
						u2179 = EggState2.ReadFieldEgg(Record.Uid)
					end)
					u2179 = u2179 or Record

					local CarrierUserId = u2179.CarrierUserId

					if CarrierUserId and CarrierUserId ~= LocalPlayer2.UserId then
						local playerByUserId = Players2:GetPlayerByUserId(CarrierUserId)
						local HumanoidRootPart = playerByUserId and playerByUserId.Character and playerByUserId.Character:FindFirstChild("HumanoidRootPart")

						if playerByUserId and HumanoidRootPart then
							table.insert(t88, {
								record = u2179,
								player = playerByUserId,
								root = HumanoidRootPart
							})
						end
					end
				end
			end

			return t88
		end
		t85.clearHistory = function(p632)
			table.clear(p632.history)
			p632:_notify()
		end

		local function v2183(p633)
			if typeof(p633) == "Color3" then
				return string.format("%02x%02x%02x", math.floor(p633.R * 255 + 0.5), math.floor(p633.G * 255 + 0.5), math.floor(p633.B * 255 + 0.5))
			end

			return "ffffff"
		end

		t85.listEntries = function(p634)
			local t89 = {}

			for _, v in ipairs(p634:carriers()) do
				t89[v.player] = v.record
			end

			local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")
			local t90 = {}
			local v2189

			for _, player in ipairs(Players2:GetPlayers()) do
				if player ~= LocalPlayer2 then
					local v2192, s4

					if player.Character then
						local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

						v2192 = t89[player]

						local ok = not (HumanoidRootPart2 and HumanoidRootPart)

						if not ok then
							v2189 = math.floor((HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude + 0.5)
							ok = not v2189
						end

						if ok then
							v2189 = nil
						end

						s4 = "Offline"

						if v2192 and v2192.AreaId then
							s4 = tostring(v2192.AreaId)
						elseif HumanoidRootPart2 then
							s4 = HumanoidRootPart2.Position.X <= 552.2 and "Safe Zone" or "Field"
						end
					else
						v2192 = t89[player]
						v2189 = nil
						s4 = "Offline"

						if v2192 and v2192.AreaId then
							s4 = tostring(v2192.AreaId)
						end
					end

					local rarityRank
					local v2197, v2198

					if v2192 then
						local ok, result = pcall(function()
							return p634.catalog.resolve(v2192)
						end)
						local v2201 = ok and result

						if not v2201 then
							v2201 = {
								rarityRank = 0,
								name = tostring(v2192.AssetCategory or "Egg"),
								rarity = "Unknown",
								rarityColor = Color3.fromRGB(245, 196, 81)
							}
						end

						local v2202 = v2201

						rarityRank = v2202.rarityRank or 0
						v2197 = string.format("<font color=\"#%s\">%s</font>  <font color=\"#A2A2AE\">[%s]</font>", v2183(v2202.rarityColor), tostring(v2202.name or "Egg"), tostring(v2202.rarity or "Common"))
						v2198 = string.format("Running in %s%s", s4, v2189 and "  -  " .. v2189 .. " studs" or "")
					else
						v2197 = "No Egg Carried"
						v2198 = string.format("Idle in %s%s", s4, v2189 and "  -  " .. v2189 .. " studs" or "")
					end

					t90[#t90 + 1] = {
						id = tostring(player.UserId),
						name = tostring(player.DisplayName or player.Name),
						sub = string.format("<font color=\"#4ADE80\">@%s</font>  <font color=\"#A2A2AE\">[%s]</font>", tostring(player.Name), s4),
						status = v2197,
						statusSub = v2198,
						button = "Steal",
						buttonColor = v2192 and "accent" or "dim",
						player = player,
						carrying = v2192 ~= nil,
						rank = rarityRank or -1,
						distance = v2189 or 1e9,
						onClick = function(p635, p636)
							local v2203 = p634:strike(p635.player)

							p636(v2203 and "Chasing" or "No Egg", v2203 and "green" or "red")
							task.delay(1.6, function()
								pcall(p636, "Steal", p635.carrying and "accent" or "dim")
							end)
						end
					}
				end
			end

			table.sort(t90, function(p637, p638)
				if p637.carrying ~= p638.carrying then
					return p637.carrying
				end

				if not p637.carrying or p637.rank == p638.rank then
					return p637.distance < p638.distance
				end

				return p637.rank > p638.rank
			end)

			return t90
		end
		t85._pick = function(p639)
			local StealPlayerTarget = senaV4Config.StealPlayerTarget
			local v2205
			local v2206
			local v2207, v2208, v2209 = ipairs(p639:carriers())
			local v2210 = geniter(v2207, v2208, v2209)

			while true do
				local v2211 = table.pack(v2210())

				if not v2211[1] then
					break
				end

				local v2212 = v2211[3]
				local v2213 = StealPlayerTarget == nil or StealPlayerTarget == "" or StealPlayerTarget == "Any Player" or v2212.player.Name == StealPlayerTarget

				if not (v2212.root.Position.X > 672.2) then
					continue
				end

				local exitTo2

				while true do
					local v2215 = v2212.player:GetAttribute("InBossArena") ~= true
					local exitTo

					while true do
						if not v2213 or not v2215 then
							local v2217 = table.pack(v2210())

							if not v2217[1] then
								break
							end

							v2212 = v2217[3]
							v2213 = StealPlayerTarget == nil or StealPlayerTarget == "" or StealPlayerTarget == "Any Player" or v2212.player.Name == StealPlayerTarget
							v2215 = v2212.root.Position.X > 672.2

							if not v2215 then
								continue
							end

							exitTo = 2

							break
						end

						exitTo = 1

						break
					end

					if exitTo == 1 then
						exitTo2 = 1

						break
					elseif exitTo == 2 then
						continue
					end

					break
				end

				if exitTo2 == 1 then
					if p639:_passes(v2212.record) then
						local rarityRank = p639.catalog.resolve(v2212.record).rarityRank or 0

						if not v2206 or v2206 < rarityRank then
							v2205 = v2212
							v2206 = rarityRank
						end
					end

					continue
				end

				break
			end

			return v2205
		end
		t85.strike = function(p640, p641)
			if not p641 or p641 == LocalPlayer2 then
				return false
			end

			for _, v in ipairs(p640:carriers()) do
				if v.player == p641 then
					p640.forced = true
					task.spawn(function()
						p640:_chase(v)
					end)

					return true
				end
			end

			p640:_setStatus(p641.Name .. " is not carrying an egg")

			return false
		end

		local function v2221()
			local Character = LocalPlayer2.Character

			if not Character then
				return
			end

			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

			for _, descendant in ipairs(Character:GetDescendants()) do
				if not descendant:IsA("Motor6D") then
					if not descendant:IsA("BallSocketConstraint") then
						if not descendant:IsA("HingeConstraint") then
							if not descendant:IsA("Attachment") then
								continue
							end

							if not descendant.Name:find("Ragdoll") and not descendant:GetAttribute("RagdollAttachment") then
								continue
							end

							pcall(function()
								descendant:Destroy()
							end)

							continue
						end
					end

					if descendant.Name:find("Ragdoll") or descendant:GetAttribute("RagdollConstraint") then
						pcall(function()
							descendant:Destroy()
						end)
					end
				elseif not descendant.Enabled then
					descendant.Enabled = true
				end
			end

			if Humanoid then
				Humanoid.PlatformStand = false
				Humanoid.Sit = false
				pcall(function()
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
					Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
					Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
					task.wait(0.02)
					Humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end)
			end

			if HumanoidRootPart then
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			end
		end
		local function v2227()
			local v2228 = v14()
			local Areas = v2228 and v2228:FindFirstChild("Areas")
			local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
			local Forest = GuardAreas and GuardAreas:FindFirstChild("Forest")

			if Forest then
				local Guard = Forest:FindFirstChild("Guard")
				local HumanoidRootPart = Guard and (Guard:FindFirstChild("HumanoidRootPart") or Guard:FindFirstChild("Collider") or Guard:IsA("Model") and Guard.PrimaryPart)

				if Guard and HumanoidRootPart then
					return Guard, HumanoidRootPart
				end

				local ForestGuardAuthored = Forest:FindFirstChild("ForestGuardAuthored")
				local HumanoidRootPart2 = ForestGuardAuthored and (ForestGuardAuthored:FindFirstChild("HumanoidRootPart") or ForestGuardAuthored:IsA("Model") and ForestGuardAuthored.PrimaryPart)

				if ForestGuardAuthored and HumanoidRootPart2 then
					return ForestGuardAuthored, HumanoidRootPart2
				end
			end

			local AreaGuards = workspace:FindFirstChild("AreaGuards")

			if AreaGuards then
				for _, child in ipairs(AreaGuards:GetChildren()) do
					local HumanoidRootPart = child:FindFirstChild("HumanoidRootPart")

					if HumanoidRootPart and HumanoidRootPart.Position.X < 850 then
						return child, HumanoidRootPart
					end
				end
			end

			return nil, nil
		end
		local function v2240(p642)
			local u2241

			pcall(function()
				u2241 = EggState2.ReadFieldEggs()
			end)

			local Records = u2241 and u2241.Records or {}
			local v2243

			for _, Record in ipairs(Records) do
				if (Record.State == "Slot" or Record.State == "Dropped") and Record.Uid ~= p642 and (not Record.CarrierUserId or Record.CarrierUserId == LocalPlayer2.UserId) then
					local Position = Record.BottomCFrame and Record.BottomCFrame.Position or Record.BoundsCFrame and Record.BoundsCFrame.Position

					if Record.AreaId == "Forest" or tostring(Record.Uid):find("Forest", 1, true) or tostring(Record.Uid):find("^FirstArea") or Position and Position.X < 680 then
						if Record.State == "Slot" then
							v2243 = Record

							break
						end

						v2243 = v2243 or Record
					end
				end
			end

			return v2243
		end

		t85._primeForest = function(p643, p644)
			local eggRuntime = p643.eggRuntime
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if not HumanoidRootPart or not Humanoid or not (Humanoid.Health > 0) then
				return false
			end

			if eggRuntime and eggRuntime.carry and eggRuntime.carry.active and eggRuntime.carry.uid then
				pcall(function()
					eggRuntime:_returnToSafe()
				end)
				task.wait(0.08)
			end

			p643:_setStatus("Finding Forest bait egg")

			local v2251 = v2240(p644)

			if not v2251 then
				p643:_setStatus("No Forest bait egg available")

				return false
			end

			local Position = v2251.BottomCFrame and v2251.BottomCFrame.Position or v2251.BoundsCFrame and v2251.BoundsCFrame.Position or Vector3.new(596.6, 67.7, -325)
			local vector32 = Vector3.new(Position.X, Position.Y + 2.5, Position.Z)
			local u2254 = "Forest:" .. tostring(v2251.NestId or "Slot_001")

			pcall(function()
				local AreaEggSlotIdentity = require(ReplicatedStorage2.Shared.Util.AreaEggSlotIdentity)

				if AreaEggSlotIdentity and v2251.AreaId and v2251.NestId then
					u2254 = AreaEggSlotIdentity.SlotKey(v2251.AreaId, v2251.NestId)
				end
			end)
			p643:_setStatus("Grabbing Forest bait egg")
			HumanoidRootPart.CFrame = cFrameNew(vector32)
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			RunService.Heartbeat:Wait()

			local v2256 = false
			local now = os.clock()
			local n40 = 0

			while os.clock() - now < 0.8 do
				HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or HumanoidRootPart

				if HumanoidRootPart.Position.Y < 65 then
					HumanoidRootPart.CFrame = cFrameNew(vector32)
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				end

				if n40 <= os.clock() then
					n40 = os.clock() + 0.1
					task.spawn(function()
						pcall(function()
							EggState2.CarryFieldEgg(v2251.Uid, u2254)
						end)
					end)
					task.spawn(function()
						pcall(function()
							local Remotes = require(ReplicatedStorage2.Shared.Remotes)

							if Remotes and Remotes.EggWorld and Remotes.EggWorld.AskFieldEggCarry then
								Remotes.EggWorld.AskFieldEggCarry:InvokeServer({
									Uid = v2251.Uid,
									FirstAreaSlotKey = u2254
								})
							end
						end)
					end)
				end

				local u2260

				pcall(function()
					u2260 = EggState2.ReadFieldEgg(v2251.Uid)
				end)

				if u2260 and u2260.State == "Carried" and u2260.CarrierUserId == LocalPlayer2.UserId then
					v2256 = true

					break
				else
					RunService.Heartbeat:Wait()
				end
			end

			if not v2256 then
				p643:_setStatus("Failed to carry Forest bait egg")
				v2221()

				return false
			end

			p643:_setStatus("Moving to Forest Guard")

			local u2261, u2262 = v2227()
			local Position2, u2264, t91

			if u2261 then
				if not u2261:FindFirstChild("Collider") then
				end

				Position2 = u2262 and u2262.Position or Vector3.new(596.6, 69.4, -317.1)
				HumanoidRootPart.CFrame = cFrameNew(Position2.X, Position2.Y + 0.8, Position2.Z)
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				u2264 = false
				t91 = {}
			else
				Position2 = u2262 and u2262.Position or Vector3.new(596.6, 69.4, -317.1)
				HumanoidRootPart.CFrame = cFrameNew(Position2.X, Position2.Y + 0.8, Position2.Z)
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				u2264 = false
				t91 = {}
			end

			pcall(function()
				local RERigSyncRefresh = ReplicatedStorage2:FindFirstChild("Packages") and ReplicatedStorage2.Packages:FindFirstChild("Networking") and ReplicatedStorage2.Packages.Networking:FindFirstChild("RE/RigSync/Refresh")

				if RERigSyncRefresh then
					table.insert(t91, RERigSyncRefresh.OnClientEvent:Connect(function()
						u2264 = true
					end))
				end
			end)
			pcall(function()
				local Remotes = require(ReplicatedStorage2.Shared.Remotes)

				if Remotes and Remotes.EggWorld and Remotes.EggWorld.OwnerDropped then
					table.insert(t91, Remotes.EggWorld.OwnerDropped.OnClientEvent:Connect(function()
						u2264 = true
					end))
				end
			end)
			table.insert(t91, Humanoid.StateChanged:Connect(function(old, new)
				if new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.PlatformStanding then
					u2264 = true
				end
			end))
			table.insert(t91, Humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
				if Humanoid.PlatformStand then
					u2264 = true
				end
			end))

			local function v2268()
				local v2269, v2270 = v2227()

				u2261 = v2269
				u2262 = v2270

				local Position3 = u2262 and u2262.Position or Position2
				local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart2 then
					HumanoidRootPart2.CFrame = cFrameNew(Position3.X, Position3.Y + 0.8, Position3.Z)
					HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
				end

				local Collider = u2261 and u2261:FindFirstChild("Collider") or u2262

				if Collider and type(firetouchinterest) == "function" and HumanoidRootPart2 then
					pcall(function()
						firetouchinterest(HumanoidRootPart2, Collider, 0)
						firetouchinterest(HumanoidRootPart2, Collider, 1)
					end)
				end

				pcall(function()
					local Remotes = require(ReplicatedStorage2.Shared.Remotes)

					if Remotes then
						if Remotes.GuardPatrol and Remotes.GuardPatrol.ForestStrike then
							Remotes.GuardPatrol.ForestStrike:FireServer({
								EggUid = v2251.Uid,
								GuardCFrame = u2262 and u2262.CFrame or cFrameNew(Position3)
							})
						end
					end
				end)
			end

			p643:_setStatus("Triggering Forest Guard hit")
			v2268()

			local v2275 = os.clock() + 0.75
			local v2276 = os.clock() + 0.05

			while os.clock() < v2275 and not u2264 do
				local Humanoid2 = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")

				if Humanoid2 and (Humanoid2.PlatformStand or Humanoid2.Sit) then
					u2264 = true

					break
				end

				local HumanoidRootPart2 = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart2 and HumanoidRootPart2.AssemblyLinearVelocity.Magnitude > 18 then
					u2264 = true

					break
				else
					if HumanoidRootPart2 and HumanoidRootPart2.Position.Y < 65 then
						HumanoidRootPart2.CFrame = cFrameNew(Position2.X, 70, Position2.Z)
						HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
					end

					if v2276 <= os.clock() then
						v2276 = os.clock() + 0.05
						v2268()
					end

					RunService.Heartbeat:Wait()
				end
			end

			for _, v in ipairs(t91) do
				pcall(v.Disconnect, v)
			end

			if not u2264 then
				p643:_setStatus("Forest Guard hit timed out")
				v2221()

				return false, v2251.Uid
			end

			p643:_setStatus("Recovering posture")
			v2221()

			local v2281 = os.clock() + 0.35

			while os.clock() < v2281 do
				local Humanoid2 = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
				local HumanoidRootPart2 = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

				if not Humanoid2 or not HumanoidRootPart2 or Humanoid2.PlatformStand or Humanoid2.Sit then
					v2221()
					RunService.Heartbeat:Wait()
				else
					local state = Humanoid2:GetState()

					if state ~= Enum.HumanoidStateType.Ragdoll and state ~= Enum.HumanoidStateType.FallingDown and state ~= Enum.HumanoidStateType.PlatformStanding then
						HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
						HumanoidRootPart2.AssemblyAngularVelocity = Vector3.zero

						break
					end

					v2221()
					RunService.Heartbeat:Wait()
				end
			end

			return true, v2251.Uid
		end
		t85._swingBatAt = function(p645, p646, p647)
			if not p647 or p647.Parent ~= LocalPlayer2.Character then
				return false
			end

			p645.swingSeq += 1

			local v2285 = string.format("%d:%d:%d", LocalPlayer2.UserId, p645.swingSeq, math.floor(workspace:GetServerTimeNow() * 1000))

			local function v2286()
				require(ReplicatedStorage2.Shared.Remotes).BatSwing.Trigger:FireServer(p646, v2285)
			end

			return pcall(v2286)
		end
		t85._returnSafe = function(p648)
			local eggRuntime = p648.eggRuntime
			local Character = LocalPlayer2.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if not eggRuntime or not HumanoidRootPart or not Humanoid or eggRuntime:_isInSafeArea(HumanoidRootPart) then
				return
			end

			local v2291 = eggRuntime:_resolveSafeCFrame(HumanoidRootPart)

			if not v2291 then
				return
			end

			p648:_setStatus("Returning to safe zone")
			v232(HumanoidRootPart, Humanoid, v2291, function()
				return Humanoid.Health <= 0 or not HumanoidRootPart.Parent
			end, false, nil, true)
		end
		t85.intercept = function(p649, p650)
			if p649.running then
				return false
			end

			local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				return false
			end

			for _, v in ipairs(p649:carriers()) do
				if v.record.Uid == p650 then
					if v.root.Position.X <= 552.2 or (v.root.Position - HumanoidRootPart.Position).Magnitude > 80 then
						return false
					end

					p649.forced = true
					task.spawn(p649._chase, p649, v, true)

					return p649.running
				end
			end

			return false
		end

		local s5 = "_chase"

		local function v2296(p651, p652, p653)
			if p651.running then
				return
			end

			p651.running = true
			p651.attempts += 1

			local record = p652.record
			local Uid = record.Uid
			local v2299 = p651.catalog.resolve(record)
			local player = p652.player
			local DisplayName = player.DisplayName or player.Name

			if p651.godMode then
				p651.godMode:stopDefend()
			end

			if not p653 then
				p651:_returnSafe()
				p651:_setStatus(string.format("Priming at Forest Guard for %s", DisplayName))

				local ok, result, result2 = pcall(p651._primeForest, p651, Uid)
				local u2305

				if ok and not result and result2 then
					pcall(function()
						u2305 = EggState2.ReadFieldEgg(result2)
					end)
				end

				if u2305 and u2305.State == "Carried" and u2305.CarrierUserId == LocalPlayer2.UserId then
					p651:_returnSafe()
					p651:_log(DisplayName, v2299.name, "Forest priming failed")
					p651:_setStatus(p651.enabled and "looking for a carrier" or "idle")
					p651.running = false
					p651.forced = false

					return
				end
			end

			local godMode = p651.godMode and p651.godMode:_equipBat()
			local v2307 = os.clock() + (p653 and 8 or 16)
			local s6 = "could not catch them"
			local n41 = 0
			local n42 = 0
			local now
			local v2312
			local now2
			local t92 = {}
			local vector32 = Vector3.zero
			local attribute = player:GetAttribute("RagdollEndTime") or false
			local n43 = 0.1

			pcall(function()
				n43 = math.clamp(LocalPlayer2:GetNetworkPing() or 0.1, 0.03, 0.6)
			end)

			local v2318 = math.clamp(0.14 + n43, 0.14, 0.35)
			local hitIdx = p651.hitIdx or p651.leadIdx

			p651.leadIdx = hitIdx or 1
			p651.missStreak = 0

			local connection

			pcall(function()
				connection = RunService.Stepped:Connect(function()
					local Character = LocalPlayer2.Character

					if Character then
						for _, descendant in ipairs(Character:GetDescendants()) do
							if descendant:IsA("BasePart") then
								descendant.CanCollide = false
							end
						end
					end
				end)
			end)
			p651:_setStatus(string.format("Chasing %s", DisplayName))

			while os.clock() < v2307 do
				local result = RunService.PreSimulation:Wait()

				if not p651.enabled and not p651.forced then
					s6 = "stopped"

					break
				end

				local u2325

				pcall(function()
					u2325 = EggState2.ReadFieldEgg(Uid)
				end)

				local State = u2325 and u2325.State

				if not u2325 or State == "Slot" or State == "GuardCarried" then
					s6 = "egg reset"

					break
				end

				if State == "Claimed" then
					s6 = "they banked it"

					break
				end

				if State == "Carried" and u2325.CarrierUserId == LocalPlayer2.UserId then
					s6 = "taken"

					break
				end

				if State == "Dropped" then
					if now and os.clock() - now <= 1 then
						p651.hitIdx = p651.leadIdx
					end

					p651:_setStatus(string.format("Grabbing dropped egg from %s", DisplayName))
					s6 = p651:_grab(u2325) and "taken" or "someone else grabbed it"

					break
				end

				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then
					s6 = "character died"

					break
				end

				local HumanoidRootPart2, now3, v2332, AssemblyLinearVelocity, vector33, Magnitude, LookVector, vector34, Unit, Unit2, clamp, v2341, v2342, vector35, cFrame, v2345, Magnitude2, v2347, v2348, v2349, v2350, attribute2, v2352

				if u2325.CarrierUserId == player.UserId then
					HumanoidRootPart2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

					if not HumanoidRootPart2 then
						s6 = "lost sight of them"

						break
					end

					if HumanoidRootPart2.Position.X <= 552.2 then
						s6 = "banked"

						break
					end

					now3 = os.clock()
					v2332 = #t92 + 1
					t92[v2332] = {
						t = now3,
						p = HumanoidRootPart2.Position
					}

					while #t92 > 2 and now3 - t92[1].t > 0.4 do
						table.remove(t92, 1)
					end

					AssemblyLinearVelocity = HumanoidRootPart2.AssemblyLinearVelocity

					if Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude > 8 then
						vector32 = AssemblyLinearVelocity
					elseif #t92 >= 2 and now3 - t92[1].t > 0.15 then
						vector32 = (HumanoidRootPart2.Position - t92[1].p) / (now3 - t92[1].t)
					end

					vector33 = Vector3.new(vector32.X, 0, vector32.Z)
					Magnitude = vector33.Magnitude

					if Magnitude > 6 then
						Unit2 = vector33.Unit
					else
						LookVector = HumanoidRootPart2.CFrame.LookVector
						vector34 = Vector3.new(LookVector.X, 0, LookVector.Z)
						Unit = vector34.Magnitude > 0.05 and vector34.Unit or Vector3.new(-1, 0, 0)
						Unit2 = Unit
					end

					clamp = math.clamp
					v2341 = t86[p651.leadIdx] or 1
					v2342 = HumanoidRootPart2.Position + Unit2 * clamp(v2341 * Magnitude * v2318, 3, 110)

					if v2342.X < 557.2 then
						v2342 = Vector3.new(557.2, v2342.Y, v2342.Z)
					end

					vector35 = Vector3.new(HumanoidRootPart2.Position.X, v2342.Y, HumanoidRootPart2.Position.Z)

					if (vector35 - v2342).Magnitude < 0.5 then
						vector35 = v2342 - Unit2
					end

					cFrame = lookAt(v2342, vector35)
					v2345 = v2342 - HumanoidRootPart.Position
					Magnitude2 = v2345.Magnitude
					v2347 = v20()
					v2348 = v2347 * math.min(result, 0.05)
					v27(Character, v2347 * t1.HEADROOM)

					if v2348 < Magnitude2 then
						HumanoidRootPart.CFrame = cFrameNew(HumanoidRootPart.Position + v2345.Unit * v2348) * cFrame.Rotation
						HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						v2349 = v2345.Unit * v2347
					else
						HumanoidRootPart.CFrame = cFrame
						HumanoidRootPart.AssemblyLinearVelocity = HumanoidRootPart2.AssemblyLinearVelocity
						v2349 = HumanoidRootPart2.AssemblyLinearVelocity
					end

					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero

					if not v32(Humanoid, HumanoidRootPart, v2347, v2349) then
						v31(Humanoid, HumanoidRootPart, v2347)
						v32(Humanoid, HumanoidRootPart, v2347, v2349)
					end

					v2350 = Magnitude * result * 1.5

					if not (Magnitude2 <= 5 + v2350) then
						if 12 + v2350 < Magnitude2 and now2 then
							now2 = nil
							p651:_setStatus(string.format("Chasing %s", DisplayName))
						end
					elseif not now2 then
						now2 = os.clock()
						p651:_setStatus(string.format("Attacking %s", DisplayName))
					end

					attribute2 = player:GetAttribute("RagdollEndTime") or false

					if attribute2 ~= attribute then
						attribute = attribute2
						p651.hitIdx = p651.leadIdx
						p651.missStreak = 0
						now = nil
					end

					if (not godMode or godMode.Parent ~= Character) and n42 <= os.clock() then
						n42 = os.clock() + 0.5
						task.spawn(function()
							godMode = p651.godMode and p651.godMode:_equipBat() or godMode
						end)
					end

					v2352 = godMode and tonumber(godMode:GetAttribute("CooldownEndTime")) or 0

					if now and os.clock() - now > 0.9 then
						if v2352 ~= v2312 then
							p651.missStreak += 1

							if p651.missStreak >= 2 then
								p651.missStreak = 0
								p651.leadIdx = p651.leadIdx % #t86 + 1
								now2 = nil
							end
						end

						now = nil
					end

					if godMode and godMode.Parent == Character and now2 and v2318 + 0.05 <= os.clock() - now2 and godMode:GetAttribute("CooldownActive") ~= true and v2352 <= workspace:GetServerTimeNow() and os.clock() - n41 >= 0.35 then
						n41 = os.clock()

						if not now then
							now = os.clock()
							v2312 = v2352
						end

						task.spawn(p651._swingBatAt, p651, player, godMode)
					end
				else
					local playerByUserId = Players2:GetPlayerByUserId(u2325.CarrierUserId or 0)

					if not playerByUserId then
						s6 = "taken by another player"

						break
					end

					player = playerByUserId
					DisplayName = player.DisplayName or player.Name
					attribute = player:GetAttribute("RagdollEndTime") or false
					now2 = nil
					now = nil
					table.clear(t92)
					p651:_setStatus(string.format("Chasing %s", DisplayName))
					HumanoidRootPart2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

					if not HumanoidRootPart2 then
						s6 = "lost sight of them"

						break
					end

					if HumanoidRootPart2.Position.X <= 552.2 then
						s6 = "banked"

						break
					end

					now3 = os.clock()
					v2332 = #t92 + 1
					t92[v2332] = {
						t = now3,
						p = HumanoidRootPart2.Position
					}

					while #t92 > 2 and now3 - t92[1].t > 0.4 do
						table.remove(t92, 1)
					end

					AssemblyLinearVelocity = HumanoidRootPart2.AssemblyLinearVelocity

					if Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude > 8 then
						vector32 = AssemblyLinearVelocity
					elseif #t92 >= 2 and now3 - t92[1].t > 0.15 then
						vector32 = (HumanoidRootPart2.Position - t92[1].p) / (now3 - t92[1].t)
					end

					vector33 = Vector3.new(vector32.X, 0, vector32.Z)
					Magnitude = vector33.Magnitude

					if Magnitude > 6 then
						Unit2 = vector33.Unit
					else
						LookVector = HumanoidRootPart2.CFrame.LookVector
						vector34 = Vector3.new(LookVector.X, 0, LookVector.Z)
						Unit = vector34.Magnitude > 0.05 and vector34.Unit or Vector3.new(-1, 0, 0)
						Unit2 = Unit
					end

					clamp = math.clamp
					v2341 = t86[p651.leadIdx] or 1
					v2342 = HumanoidRootPart2.Position + Unit2 * clamp(v2341 * Magnitude * v2318, 3, 110)

					if v2342.X < 557.2 then
						v2342 = Vector3.new(557.2, v2342.Y, v2342.Z)
					end

					vector35 = Vector3.new(HumanoidRootPart2.Position.X, v2342.Y, HumanoidRootPart2.Position.Z)

					if (vector35 - v2342).Magnitude < 0.5 then
						vector35 = v2342 - Unit2
					end

					cFrame = lookAt(v2342, vector35)
					v2345 = v2342 - HumanoidRootPart.Position
					Magnitude2 = v2345.Magnitude
					v2347 = v20()
					v2348 = v2347 * math.min(result, 0.05)
					v27(Character, v2347 * t1.HEADROOM)

					if v2348 < Magnitude2 then
						HumanoidRootPart.CFrame = cFrameNew(HumanoidRootPart.Position + v2345.Unit * v2348) * cFrame.Rotation
						HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						v2349 = v2345.Unit * v2347
					else
						HumanoidRootPart.CFrame = cFrame
						HumanoidRootPart.AssemblyLinearVelocity = HumanoidRootPart2.AssemblyLinearVelocity
						v2349 = HumanoidRootPart2.AssemblyLinearVelocity
					end

					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero

					if not v32(Humanoid, HumanoidRootPart, v2347, v2349) then
						v31(Humanoid, HumanoidRootPart, v2347)
						v32(Humanoid, HumanoidRootPart, v2347, v2349)
					end

					v2350 = Magnitude * result * 1.5

					if not (Magnitude2 <= 5 + v2350) then
						if 12 + v2350 < Magnitude2 and now2 then
							now2 = nil
							p651:_setStatus(string.format("Chasing %s", DisplayName))
						end
					elseif not now2 then
						now2 = os.clock()
						p651:_setStatus(string.format("Attacking %s", DisplayName))
					end

					attribute2 = player:GetAttribute("RagdollEndTime") or false

					if attribute2 ~= attribute then
						attribute = attribute2
						p651.hitIdx = p651.leadIdx
						p651.missStreak = 0
						now = nil
					end

					if (not godMode or godMode.Parent ~= Character) and n42 <= os.clock() then
						n42 = os.clock() + 0.5
						task.spawn(function()
							godMode = p651.godMode and p651.godMode:_equipBat() or godMode
						end)
					end

					v2352 = godMode and tonumber(godMode:GetAttribute("CooldownEndTime")) or 0

					if now and os.clock() - now > 0.9 then
						if v2352 ~= v2312 then
							p651.missStreak += 1

							if p651.missStreak >= 2 then
								p651.missStreak = 0
								p651.leadIdx = p651.leadIdx % #t86 + 1
								now2 = nil
							end
						end

						now = nil
					end

					if godMode and godMode.Parent == Character and now2 and v2318 + 0.05 <= os.clock() - now2 and godMode:GetAttribute("CooldownActive") ~= true and v2352 <= workspace:GetServerTimeNow() and os.clock() - n41 >= 0.35 then
						n41 = os.clock()

						if not now then
							now = os.clock()
							v2312 = v2352
						end

						task.spawn(p651._swingBatAt, p651, player, godMode)
					end
				end
			end

			if connection then
				pcall(function()
					connection:Disconnect()
				end)
			end

			if s6 == "taken" then
				p651.taken += 1
				pcall(function()
					local Humanoid = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")

					if Humanoid then
						Humanoid:UnequipTools()
					end
				end)
			else
				p651.blacklist[Uid] = os.clock() + 20
			end

			p651:_returnSafe()
			p651:_log(DisplayName, v2299.name, s6)
			p651:_setStatus(p651.enabled and "looking for a carrier" or "idle")
			p651.running = false
			p651.forced = false
		end

		t85[s5] = v2296
		t85._grab = function(p654, p655)
			local eggRuntime = p654.eggRuntime
			local Uid = p655.Uid
			local v2357 = os.clock() + 3
			local n44 = 0

			while true do
				if not (os.clock() < v2357) then
					return false
				end

				local u2359

				pcall(function()
					u2359 = EggState2.ReadFieldEgg(Uid)
				end)

				local State = u2359 and u2359.State

				if State == "Carried" then
					if u2359.CarrierUserId ~= LocalPlayer2.UserId then
						return false
					end

					if genv.__SenaV4Webhook then
						local ok, result = pcall(p654.catalog.resolve, u2359)

						pcall(genv.__SenaV4Webhook.stolen, u2359, ok and result or nil, "player carry")
					end

					return true
				end

				if State ~= "Dropped" then
					return false
				end

				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then
					break
				end

				local cFrame = eggRuntime and eggRuntime:_resolveEggDestination(u2359, HumanoidRootPart, Humanoid)

				if not cFrame then
					local Position = u2359.BottomCFrame and u2359.BottomCFrame.Position or u2359.BoundsCFrame and u2359.BoundsCFrame.Position

					cFrame = Position and cFrameNew(Position.X, Position.Y + 2.5, Position.Z)
				end

				if cFrame then
					HumanoidRootPart.CFrame = cFrame
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				end

				if n44 <= os.clock() then
					n44 = os.clock() + 0.1
					task.spawn(function()
						pcall(function()
							EggState2.CarryFieldEgg(Uid)
						end)
					end)
					task.spawn(function()
						pcall(function()
							require(ReplicatedStorage2.Shared.Remotes).EggWorld.AskFieldEggCarry:InvokeServer({
								Uid = Uid
							})
						end)
					end)
				end

				RunService.Heartbeat:Wait()
			end

			return false
		end
		t85._start = function(p656)
			if p656.loop then
				return
			end

			p656.loop = task.spawn(function()
				while true do
					task.wait(0.4)

					if genv.ChloeX_Running == nil and genv.__SenaV4PlayerSteal ~= p656 then
						break
					end

					for k, v in pairs(p656.blacklist) do
						if v < os.clock() then
							p656.blacklist[k] = nil
						end
					end

					local eggRuntime = p656.eggRuntime
					local __SenaV4ScrambleRuntime = genv.__SenaV4ScrambleRuntime

					if p656.enabled and not p656.running and (not eggRuntime or not eggRuntime.running and (not eggRuntime.carry or not eggRuntime.carry.active)) and (__SenaV4ScrambleRuntime == nil or __SenaV4ScrambleRuntime.active ~= true) then
						local v2372 = p656:_pick()

						if v2372 then
							p656:_chase(v2372)
						end
					end
				end

				p656.loop = nil
			end)
		end

		return t85
	end

	local v2373 = v2149()

	v614 = v1885.new(v612)
	v614:install()
	v614:setEnabled(senaV4Config.AntiGuardKnockback == true)
	genv.__SenaV4AntiGuard = v614
	v615 = v1932.new(v612)
	v615:setEnabled(senaV4Config.GodMode == nil and true or senaV4Config.GodMode == true)
	genv.__SenaV4GodMode = v615

	local v2374 = v2373.new(v612, v615, v611)

	local function v2375()
		local Players2 = game:GetService("Players")
		local RunService2 = game:GetService("RunService")
		local UserInputService = game:GetService("UserInputService")
		local LocalPlayer2 = Players2.LocalPlayer
		local t93 = {}

		t93.__index = t93
		t93.new = function()
			local obj = setmetatable({}, t93)

			obj.flyEnabled = false
			obj.flyConnection = nil
			obj.flyMover = nil
			obj.grabEnabled = false
			obj.grabConnection = nil
			obj.grabOriginals = setmetatable({}, {
				__mode = "k"
			})
			obj.jumpEnabled = false
			obj.jumpConnections = {}
			obj.lastJumpAt = 0
			obj.speedMultiplier = 1
			obj.speedModules = nil
			obj.speedConnection = nil

			return obj
		end
		t93._root = function()
			local Character = LocalPlayer2.Character

			return Character and Character:FindFirstChild("HumanoidRootPart")
		end
		t93._humanoid = function()
			local Character = LocalPlayer2.Character

			return Character and Character:FindFirstChildOfClass("Humanoid")
		end
		t93._ensureMover = function(p657, p658)
			if p657.flyMover and p657.flyMover.Parent == p658 then
				return
			end

			if p657.flyMover then
				pcall(function()
					p657.flyMover:Destroy()
				end)
			end

			local BodyVelocity = Instance.new("BodyVelocity")

			BodyVelocity.Name = "SenaFlyCaptureHover"
			BodyVelocity.MaxForce = Vector3.new(0, 9e9, 0)
			BodyVelocity.Velocity = Vector3.zero
			BodyVelocity.Parent = p658
			p657.flyMover = BodyVelocity
		end

		local function v2385()
			local __SenaV4TreadmillManager = genv.__SenaV4TreadmillManager

			return __SenaV4TreadmillManager ~= nil and not __SenaV4TreadmillManager.destroyed and __SenaV4TreadmillManager.config ~= nil and __SenaV4TreadmillManager.config.idleFarm == true
		end

		local t94 = {
			at = 0,
			value = false
		}

		local function v2388()
			local now = os.clock()

			if now - t94.at < 0.25 then
				return t94.value
			end

			t94.at = now

			local value = false

			pcall(function()
				local EggState2 = require(game:GetService("ReplicatedStorage").Client.EggState)
				local GetAreaEggSnapshot = EggState2.GetAreaEggSnapshot and EggState2.GetAreaEggSnapshot()

				if (not GetAreaEggSnapshot or not GetAreaEggSnapshot.Records) and EggState2.ReadFieldEggs then
					GetAreaEggSnapshot = EggState2.ReadFieldEggs()
				end

				local ipairs_ = ipairs
				local Records = GetAreaEggSnapshot and GetAreaEggSnapshot.Records or {}

				for _, Record in ipairs_(Records) do
					if Record.State == "Carried" and Record.CarrierUserId == LocalPlayer2.UserId then
						value = true

						break
					end
				end
			end)
			t94.value = value

			return value
		end

		t93._dropMover = function(p659, p660)
			if p659.flyMover then
				pcall(function()
					p659.flyMover:Destroy()
				end)
				p659.flyMover = nil
			end

			local SenaFlyCaptureHover = p660 and p660:FindFirstChild("SenaFlyCaptureHover")

			if SenaFlyCaptureHover then
				pcall(function()
					SenaFlyCaptureHover:Destroy()
				end)
			end
		end
		t93.setFlyForCapture = function(p661, p662)
			p661.flyEnabled = p662 == true

			if p661.flyEnabled then
				if not p661.flyConnection then
					p661.flyAnchored = false
					p661.flyConnection = RunService2.PreSimulation:Connect(function()
						if not p661.flyEnabled then
							return
						end

						local v2398 = p661:_root()

						if not v2398 then
							return
						end

						local running = not v2388() or v2385() or next(t9) ~= nil or v612 and (v612.running or v612.activeTween)

						if not running then
							local __SenaV4PlayerSteal = genv.__SenaV4PlayerSteal

							if __SenaV4PlayerSteal and __SenaV4PlayerSteal.running then
								running = true
							end
						end

						if running then
							if p661.flyAnchored then
								pcall(function()
									v2398.Anchored = false
								end)
								p661.flyAnchored = false
							end

							return
						end

						if v2398.Position.Y < 109 then
							if p661.flyAnchored then
								pcall(function()
									v2398.Anchored = false
								end)
								p661.flyAnchored = false
							end

							v2398.CFrame = cFrameNew(v2398.Position.X, v2398.Position.Y + math.min(110 - v2398.Position.Y, 4), v2398.Position.Z) * v2398.CFrame.Rotation
							v2398.AssemblyLinearVelocity = Vector3.zero
							v2398.AssemblyAngularVelocity = Vector3.zero
						elseif v2398.Anchored then
							p661.flyAnchored = true
						else
							pcall(function()
								v2398.Anchored = true
							end)
							p661.flyAnchored = true
						end
					end)

					return
				end

				return
			end

			if p661.flyConnection then
				pcall(function()
					p661.flyConnection:Disconnect()
				end)
				p661.flyConnection = nil
			end

			if p661.flyMover then
				pcall(function()
					p661.flyMover:Destroy()
				end)
				p661.flyMover = nil
			end

			local v2401 = p661:_root()

			if v2401 then
				local SenaFlyCaptureHover = v2401:FindFirstChild("SenaFlyCaptureHover")

				if SenaFlyCaptureHover then
					pcall(function()
						SenaFlyCaptureHover:Destroy()
					end)
				end

				if p661.flyAnchored then
					pcall(function()
						v2401.Anchored = false
					end)
				end
			end

			p661.flyAnchored = false
		end
		t93._isGrabPrompt = function(p663, p664)
			return p664:IsA("ProximityPrompt") and p664.Name == "CarryAreaEgg"
		end
		t93._applyGrab = function(p665, p666)
			if not p665:_isGrabPrompt(p666) then
				return
			end

			if p665.grabOriginals[p666] == nil then
				p665.grabOriginals[p666] = p666.HoldDuration
			end

			if p666.HoldDuration > 0.1 then
				p666.HoldDuration = 0.1
			end
		end
		t93._restoreGrab = function(p667)
			local v2403 = workspace:GetAttribute("FastEggPickupTime") and 0.25 or 1.2

			for k, grabOriginal in pairs(p667.grabOriginals) do
				pcall(function()
					if k.Parent then
						k.HoldDuration = tonumber(grabOriginal) and grabOriginal > 0.1 and grabOriginal or v2403
					end
				end)
			end

			p667.grabOriginals = setmetatable({}, {
				__mode = "k"
			})
		end
		t93._fireGrab = function(p668, p669)
			if not p668:_isGrabPrompt(p669) or not p669.Enabled then
				return
			end

			p668.grabFiring = p668.grabFiring or setmetatable({}, {
				__mode = "k"
			})

			if p668.grabFiring[p669] then
				return
			end

			local Parent = p669.Parent
			local v2407 = p668:_root()

			if not v2407 or not Parent or not Parent:IsA("BasePart") then
				return
			end

			if (tonumber(p669.MaxActivationDistance) or 10) + 1 < (Parent.Position - v2407.Position).Magnitude then
				return
			end

			p668.grabFiring[p669] = true
			task.spawn(function()
				pcall(function()
					local v2408 = math.max(0.1, tonumber(p669.HoldDuration) or 0.1)

					p669:InputHoldBegin()
					task.wait(v2408 + 0.05)
					p669:InputHoldEnd()
				end)
				task.wait(0.4)

				if p668.grabFiring then
					p668.grabFiring[p669] = nil
				end
			end)
		end
		t93.setInstantGrab = function(p670, p671)
			p670.grabEnabled = p671 == true

			if p670.grabEnabled then
				for _, descendant in ipairs(workspace:GetDescendants()) do
					p670:_applyGrab(descendant)
				end

				if not p670.grabConnection then
					p670.grabConnection = workspace.DescendantAdded:Connect(function(descendant)
						if p670.grabEnabled then
							if p670:_isGrabPrompt(descendant) then
								task.defer(function()
									p670:_applyGrab(descendant)
								end)
							end
						end
					end)
				end
			else
				if p670.grabConnection then
					pcall(function()
						p670.grabConnection:Disconnect()
					end)
					p670.grabConnection = nil
				end

				p670.grabFireLoop = nil
				p670:_restoreGrab()
			end
		end
		t93.triggerJump = function(p672)
			if not p672.jumpEnabled then
				return
			end

			local now = os.clock()

			if now - p672.lastJumpAt < 0.08 then
				return
			end

			local v2412 = p672:_humanoid()
			local v2413 = p672:_root()

			if not v2412 or not v2413 or v2412.Health <= 0 then
				return
			end

			p672.lastJumpAt = now
			pcall(function()
				v2412:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
				v2412:ChangeState(Enum.HumanoidStateType.Jumping)
				v2412.Jump = true
			end)

			local n45 = 55

			if v2412.UseJumpPower and v2412.JumpPower > 0 then
				n45 = v2412.JumpPower
			elseif v2412.JumpHeight and v2412.JumpHeight > 0 then
				n45 = math.sqrt(2 * workspace.Gravity * v2412.JumpHeight)
			end

			if n45 < 55 then
				n45 = 55
			end

			pcall(function()
				local AssemblyLinearVelocity = v2413.AssemblyLinearVelocity

				v2413.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, n45, AssemblyLinearVelocity.Z)
			end)
		end
		t93.setInfiniteJump = function(p673, p674)
			p673.jumpEnabled = p674 == true

			if #p673.jumpConnections > 0 then
				return
			end

			pcall(function()
				table.insert(p673.jumpConnections, UserInputService.InputBegan:Connect(function(input)
					if not p673.jumpEnabled then
						return
					end

					if UserInputService:GetFocusedTextBox() then
						return
					end

					if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
						p673:triggerJump()
					end
				end))
				table.insert(p673.jumpConnections, UserInputService.JumpRequest:Connect(function()
					if not p673.jumpEnabled then
						return
					end

					if UserInputService:GetFocusedTextBox() then
						return
					end

					p673:triggerJump()
				end))
			end)
			task.spawn(function()
				while true do
					RunService2.Heartbeat:Wait()

					if p673.jumpEnabled and not UserInputService:GetFocusedTextBox() then
						local u2416 = false

						pcall(function()
							if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA) then
								u2416 = true
							end
						end)

						if u2416 and os.clock() - p673.lastJumpAt >= 0.28 then
							p673:triggerJump()
						end
					end
				end
			end)
		end
		t93._gameWalkSpeed = function(p675)
			local speedModules = p675.speedModules

			if not speedModules then
				speedModules = {}
				pcall(function()
					speedModules.TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
				end)
				pcall(function()
					speedModules.Projection = require(ReplicatedStorage.Client.SpeedPowerProjection)
				end)
				pcall(function()
					speedModules.Save = require(ReplicatedStorage.Shared.Save)
				end)
				p675.speedModules = speedModules
			end

			if not speedModules.TreadmillUtil or not speedModules.TreadmillUtil.SpeedPowerToWalkSpeed then
				return nil
			end

			local SpeedPower

			if speedModules.Projection then
				pcall(function()
					SpeedPower = speedModules.Projection.ReadProjected()
				end)
			end

			if type(SpeedPower) ~= "number" and speedModules.Save then
				pcall(function()
					SpeedPower = (speedModules.Save.Peek or speedModules.Save.Get)().SpeedPower
				end)
			end

			if type(SpeedPower) ~= "number" then
				return nil
			end

			local ok, result = pcall(speedModules.TreadmillUtil.SpeedPowerToWalkSpeed, SpeedPower)
			local v2421 = ok and tonumber(result) or nil

			return v2421
		end
		t93.setSpeedMultiplier = function(p676, p677)
			p676.speedMultiplier = math.clamp(tonumber(p677) or 1, 1, 2.1)
			p676:_applySpeedMultiplier()

			if not p676.speedConnection then
				p676.speedConnection = RunService2.Heartbeat:Connect(function()
					if p676.speedMultiplier <= 1.001 then
						return
					end

					p676:_applySpeedMultiplier()
				end)

				return
			end
		end
		t93._applySpeedMultiplier = function(p678)
			local __SenaV4TreadmillManager = genv.__SenaV4TreadmillManager

			if __SenaV4TreadmillManager and __SenaV4TreadmillManager.activeTreadmill ~= nil then
				return
			end

			local v2423 = p678:_humanoid()

			if not v2423 then
				return
			end

			local v2424 = p678:_gameWalkSpeed()

			if not v2424 or v2424 <= 0 then
				return
			end

			local walkSpeed = v2424 * p678.speedMultiplier

			if math.abs(v2423.WalkSpeed - walkSpeed) > 0.05 then
				pcall(function()
					v2423.WalkSpeed = walkSpeed
				end)
			end
		end
		t93.destroy = function(p679)
			p679:setFlyForCapture(false)
			p679:setInstantGrab(false)
			p679.jumpEnabled = false

			for _, jumpConnection in ipairs(p679.jumpConnections) do
				pcall(function()
					jumpConnection:Disconnect()
				end)
			end

			p679.jumpConnections = {}

			if p679.speedConnection then
				pcall(function()
					p679.speedConnection:Disconnect()
				end)
				p679.speedConnection = nil
			end
		end

		return t93
	end

	local v2428 = v2375().new()

	genv.__SenaV4MovementExtras = v2428

	if senaV4Config.FlyForCapture then
		v2428:setFlyForCapture(true)
	end

	if senaV4Config.InstantGrab then
		v2428:setInstantGrab(true)
	end

	if senaV4Config.InfiniteJump then
		v2428:setInfiniteJump(true)
	end

	if (senaV4Config.WalkSpeedMultiplier or 1) > 1 then
		v2428:setSpeedMultiplier(senaV4Config.WalkSpeedMultiplier)
	end

	local function v2429()
		local Players2 = game:GetService("Players")
		local RunService2 = game:GetService("RunService")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local LocalPlayer2 = Players2.LocalPlayer
		local cFrame = cFrameNew(544.76, 71.5, -416.48)
		local t95 = {}

		t95.__index = t95
		t95.new = function()
			local obj = setmetatable({}, t95)

			obj.enabled = false
			obj.running = false
			obj.destroyed = false
			obj.connection = nil
			obj.wasHolding = false
			obj.lastResult = "Idle"

			return obj
		end
		t95._character = function()
			return LocalPlayer2.Character
		end
		t95._root = function(p680)
			local v2437 = p680:_character()

			return v2437 and v2437:FindFirstChild("HumanoidRootPart")
		end
		t95._carriedUid = function()
			local Uid

			pcall(function()
				local EggState2 = require(ReplicatedStorage2.Client.EggState)
				local v2440

				if EggState2.GetAreaEggSnapshot then
					v2440 = EggState2.GetAreaEggSnapshot()
				end

				if (not v2440 or not v2440.Records) and EggState2.ReadFieldEggs then
					v2440 = EggState2.ReadFieldEggs()
				end

				if not v2440 or not v2440.Records then
					return
				end

				local UserId = LocalPlayer2.UserId

				for _, record in ipairs(v2440.Records) do
					if record.State == "Carried" and record.CarrierUserId == UserId then
						Uid = record.Uid

						return
					end
				end
			end)

			return Uid
		end
		t95._record = function(p681, p682)
			local ReadFieldEgg

			pcall(function()
				local EggState2 = require(ReplicatedStorage2.Client.EggState)

				ReadFieldEgg = EggState2.ReadFieldEgg and EggState2.ReadFieldEgg(p682)
			end)

			return ReadFieldEgg
		end
		t95._guardFor = function(p683, p684)
			local Guard

			pcall(function()
				local v2447 = p683:_record(p684)
				local v2448 = v14()
				local Areas = v2448 and v2448:FindFirstChild("Areas")
				local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
				local AreaId = GuardAreas and v2447 and v2447.AreaId and GuardAreas:FindFirstChild(v2447.AreaId)

				Guard = AreaId and AreaId:FindFirstChild("Guard")
			end)

			return Guard
		end
		t95._skips = function(p685, p686)
			local __SenaV4EggRuntime = genv.__SenaV4EggRuntime

			if __SenaV4EggRuntime then
				if __SenaV4EggRuntime.instantPhase == "priming" then
					return true
				end

				if __SenaV4EggRuntime.enabled or __SenaV4EggRuntime.running then
					return true
				end
			end

			local __SenaV4PlayerSteal = genv.__SenaV4PlayerSteal

			if __SenaV4PlayerSteal and __SenaV4PlayerSteal.running then
				return true
			end

			if not p686 then
				return false
			end

			local v2454 = p685:_record(p686)

			return v2454 ~= nil and tostring(v2454.AreaId) == "Forest"
		end
		t95._freeze = function(p687, p688)
			local v2455 = p687:_character()
			local Humanoid = v2455 and v2455:FindFirstChildOfClass("Humanoid")
			local CurrentCamera = workspace.CurrentCamera
			local CFrame_2 = CurrentCamera and CurrentCamera.CFrame
			local CameraType = CurrentCamera and CurrentCamera.CameraType
			local clone

			pcall(function()
				v2455.Archivable = true
				clone = v2455:Clone()

				if p688 then
					pcall(function()
						clone:PivotTo(p688)
					end)
				end

				clone.Name = "SenaAntiHitGhost"

				for _, descendant in ipairs(clone:GetDescendants()) do
					if descendant:IsA("LuaSourceContainer") or descendant:IsA("Sound") then
						descendant:Destroy()
					elseif descendant:IsA("BasePart") then
						descendant.CanCollide = false
						descendant.Anchored = true
					end
				end

				clone.Parent = workspace

				for _, descendant in ipairs(v2455:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
						descendant.LocalTransparencyModifier = 1
					end

					if descendant:IsA("Trail") then
						descendant.Enabled = false
					end
				end

				if CurrentCamera then
					CurrentCamera.CameraType = Enum.CameraType.Scriptable
					CurrentCamera.CFrame = CFrame_2
				end
			end)

			local t96 = {}

			pcall(function()
				for _, descendant in ipairs(v2455:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
						t96[#t96 + 1] = descendant
					end
				end
			end)

			local function v2468()
				if CurrentCamera then
					CurrentCamera.CameraType = Enum.CameraType.Scriptable
					CurrentCamera.CFrame = CFrame_2
				end

				for _, v in ipairs(t96) do
					if v.Parent then
						v.LocalTransparencyModifier = 1
					end
				end
			end
			local function v2471(p689)
				pcall(function()
					if clone then
						clone:Destroy()
					end

					for _, descendant in ipairs(v2455:GetDescendants()) do
						if descendant:IsA("BasePart") then
							descendant.LocalTransparencyModifier = 0
						end

						if descendant:IsA("Trail") then
							descendant.Enabled = true
						end
					end

					if CurrentCamera then
						CurrentCamera.CameraType = CameraType ~= Enum.CameraType.Scriptable and CameraType or Enum.CameraType.Custom

						if Humanoid then
							CurrentCamera.CameraSubject = Humanoid
						end

						if p689 then
							CurrentCamera.CFrame = CFrame_2
						end
					end
				end)
			end

			return v2471, v2468
		end
		t95.shield = function(p690, p691)
			if not p690.enabled or p690.running then
				return false
			end

			if p690:_skips(p691) then
				return false
			end

			local v2474 = p690:_root()

			if not v2474 then
				return false
			end

			p690.running = true

			local CFrame_2 = v2474.CFrame
			local v2476 = p690:_guardFor(p691)

			local function v2477()
				local v2478 = p690:_root()

				if not v2478 then
					return false
				end

				v2478.CFrame = cFrame
				v2478.AssemblyLinearVelocity = Vector3.zero
				v2478.AssemblyAngularVelocity = Vector3.zero

				return true
			end

			v2477()

			local v2479, v2480 = p690:_freeze(CFrame_2)
			local n46 = 1
			local u2482 = false

			pcall(function()
				local now = os.clock()
				local v2484 = false

				while (os.clock() - now < 0.9 or v2484 and os.clock() - now < 1.6 and v2476 and (v2476:GetAttribute("GuardState") == "Waking" or v2476:GetAttribute("GuardState") == "Chasing")) and v2477() do
					v2480()
					n46 += 1

					local attribute = v2476 and v2476:GetAttribute("GuardState")

					if attribute == "Waking" or attribute == "Chasing" then
						v2484 = true
						RunService2.Heartbeat:Wait()
					elseif v2484 and attribute == "Sleeping" and os.clock() - now > 0.2 then
						u2482 = true

						break
					else
						RunService2.Heartbeat:Wait()
					end
				end
			end)
			v2479(true)
			p690.lastResult = (u2482 and "Guard slept" or "Held") .. " (" .. n46 .. " writes)"
			p690.running = false

			return true
		end
		t95._check = function(p692, p693)
			if not p692.enabled then
				p692.wasHolding = false

				return
			end

			local Uid

			if type(p693) == "table" and p693.IsCarrying and p693.Uid then
				Uid = p693.Uid
			else
				Uid = p692:_carriedUid()
			end

			local wasHolding = Uid ~= nil

			if wasHolding and not p692.wasHolding and not p692.running and not p692:_skips(Uid) then
				task.spawn(function()
					pcall(function()
						p692:shield(Uid)
					end)
				end)
			end

			p692.wasHolding = wasHolding
		end
		t95.setEnabled = function(p694, p695)
			p694.enabled = p695 == true

			if p694.enabled then
				p694.wasHolding = p694:_carriedUid() ~= nil
			end

			if not p694.watcher then
				p694.watcher = true
				task.spawn(function()
					while not p694.destroyed do
						if not p694.enabled or p694.running then
							task.wait(0.5)
						else
							pcall(function()
								p694:_check()
							end)
							task.wait(0.15)
						end
					end
				end)
			end

			if p694.connection then
				return
			end

			pcall(function()
				local EggState2 = require(ReplicatedStorage2.Client.EggState)

				if EggState2 and EggState2.CarryChanged then
					p694.connection = EggState2.CarryChanged:Connect(function(p696)
						task.defer(function()
							p694:_check(p696)
						end)
					end)
				end
			end)
		end
		t95.destroy = function(p697)
			p697.destroyed = true
			p697.enabled = false

			if p697.connection then
				pcall(function()
					p697.connection:Disconnect()
				end)
				p697.connection = nil
			end
		end

		return t95
	end

	local v2489 = v2429().new()

	genv.__SenaV4AntiHitGuard = v2489

	if senaV4Config.AntiHitGuard then
		v2489:setEnabled(true)
	end

	genv.__SenaV4PlayerSteal = v2374
end

do
	local t97 = {
		at = 0,
		value = false
	}

	genv.__SenaV4StealWantsCharacter = function()
		local __SenaV4PlayerSteal = genv.__SenaV4PlayerSteal

		if __SenaV4PlayerSteal and __SenaV4PlayerSteal.running then
			return true
		end

		local __SenaV4EggRuntime = genv.__SenaV4EggRuntime

		if not __SenaV4EggRuntime or not __SenaV4EggRuntime.enabled or __SenaV4EggRuntime.destroyed then
			return false
		end

		if __SenaV4EggRuntime.running or __SenaV4EggRuntime.activeTween and not __SenaV4EggRuntime.activeTween.sharedTravel or __SenaV4EggRuntime.carry and __SenaV4EggRuntime.carry.active then
			return true
		end

		local now = os.clock()

		if now - t97.at < 0.5 then
			return t97.value
		end

		t97.at = now

		local ok, result = pcall(function()
			return __SenaV4EggRuntime:_wallOpen() and __SenaV4EggRuntime:_chooseTarget() or nil
		end)

		t97.value = ok and result ~= nil

		return t97.value
	end
	genv.__SenaV4DronesWantCharacter = function()
		local __SenaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime

		return __SenaV4ButterflyRuntime ~= nil and (__SenaV4ButterflyRuntime.active == true or __SenaV4ButterflyRuntime.wantsCharacter == true)
	end
end

v612:setStealMode(senaV4Config.StealMode == "Semi Teleport" and "Instant" or senaV4Config.StealMode)
v612:setSpeed(senaV4Config.TweenSpeedMultiplier or 60)

if senaV4Config.StealMinValue and senaV4Config.StealMinValue > 0 then
	v612:setMinValuePerSec(senaV4Config.StealMinValue)
end

if senaV4Config.StealAreas and not table.find(senaV4Config.StealAreas, "None") and #senaV4Config.StealAreas > 0 then
	local t98 = {}

	for _, stealArea in ipairs(senaV4Config.StealAreas) do
		if stealArea ~= "None" then
			table.insert(t98, stealArea)
		end
	end

	v612:setFilter("areas", t98)
	v612:setFilterEnabled("area", #t98 > 0)
end

if senaV4Config.StealRarities and not table.find(senaV4Config.StealRarities, "None") and #senaV4Config.StealRarities > 0 then
	local t99 = {}

	for _, stealRarity in ipairs(senaV4Config.StealRarities) do
		if stealRarity ~= "None" then
			table.insert(t99, stealRarity)
		end
	end

	v612:setFilter("rarities", t99)
	v612:setFilterEnabled("rarity", #t99 > 0)
end

if senaV4Config.StealNamesFilter and not table.find(senaV4Config.StealNamesFilter, "None") and #senaV4Config.StealNamesFilter > 0 then
	local t100 = {}

	for _, v in ipairs(senaV4Config.StealNamesFilter) do
		if v ~= "None" then
			table.insert(t100, v)
		end
	end

	v612:setFilter("names", t100)
	v612:setFilterEnabled("name", #t100 > 0)
end

do
	genv.__SenaV4EggRuntimeCleanup = function()
		if v612 then
			pcall(v612.destroy, v612)
		end

		if v613 then
			pcall(v613.destroy, v613)
		end

		if genv.__SenaV4EggRuntime == v612 then
			genv.__SenaV4EggRuntime = nil
		end

		if genv.__SenaV4TreadmillManager == v613 then
			genv.__SenaV4TreadmillManager = nil
		end
	end
	genv.__SenaV4AntiGuardCleanup = function()
		if v614 then
			pcall(v614.destroy, v614)
		end

		if v615 then
			pcall(v615.destroy, v615)
		end

		if genv.__SenaV4AntiGuard == v614 then
			genv.__SenaV4AntiGuard = nil
		end

		if genv.__SenaV4GodMode == v615 then
			genv.__SenaV4GodMode = nil
		end
	end
end

do
	local function v2506()
		return getgenv and getgenv() or _G
	end
	local function v2507()
		if type(getconnections) == "function" then
			return getconnections
		end

		if type(get_signal_cons) == "function" then
			return get_signal_cons
		end

		return nil
	end
	local function v2508(p698)
		local LocalPlayer2 = Players.LocalPlayer

		if not LocalPlayer2 then
			p698.antiAfkStatus = "LocalPlayer unavailable"

			return false
		end

		local v2510 = v2507()

		if not v2510 then
			p698.antiAfkStatus = "Native Idled connection API unavailable"

			return false
		end

		local ok, result = pcall(v2510, LocalPlayer2.Idled)

		if not ok or type(result) ~= "table" then
			p698.antiAfkStatus = "Idled scan unavailable"

			return false
		end

		local lastDisabledIdleConnections = 0

		for _, v in ipairs(result) do
			local v2516 = false

			if type(v) == "table" or type(v) == "userdata" then
				if type(v.Disable) == "function" then
					v2516 = pcall(v.Disable, v)
				elseif type(v.Disconnect) == "function" then
					v2516 = pcall(v.Disconnect, v)
				end
			end

			if v2516 then
				lastDisabledIdleConnections += 1
			end
		end

		p698.scanRuns += 1
		p698.lastScanAt = os.clock()
		p698.lastDisabledIdleConnections = lastDisabledIdleConnections
		p698.disabledIdleConnections += lastDisabledIdleConnections
		p698.antiAfkStatus = lastDisabledIdleConnections > 0 and "Anti-AFK disabled " .. tostring(lastDisabledIdleConnections) .. " Idled connection(s)" or "Anti-AFK active; Idled connections clear"

		return true
	end

	local t101 = {
		install = function()
			local v2518 = v2506()
			local value = rawget(v2518, "__FyyStealAnEggStartupProtectionLiteV2")

			if type(value) == "table" and value.installed then
				value.installRuns += 1
				v2508(value)
				value.status = value.antiAfkStatus

				return value
			end

			local t102 = {
				installRuns = 1,
				scanRuns = 0,
				disabledIdleConnections = 0,
				lastDisabledIdleConnections = 0,
				lastScanAt = 0,
				installed = false,
				mode = "native-idled-disabler",
				integrityPatcherInstalled = false,
				networkFilterInstalled = false,
				namecallHookInstalled = false
			}

			v2518.__FyyStealAnEggStartupProtectionLiteV2 = t102

			local LocalPlayer2 = Players.LocalPlayer

			if not LocalPlayer2 then
				t102.antiAfkInstalled = false
				t102.antiAfkStatus = "LocalPlayer unavailable"
				t102.status = t102.antiAfkStatus
				t102.installed = true

				return t102
			end

			t102.antiAfkInstalled = v2508(t102)
			t102.idledConnection = LocalPlayer2.Idled:Connect(function()
				v2508(t102)
			end)
			t102.characterConnection = LocalPlayer2.CharacterAdded:Connect(function()
				task.delay(1, function()
					if t102.installed then
						v2508(t102)
					end
				end)
			end)
			t102.installed = true
			t102.status = t102.antiAfkStatus

			local function v2522()
				while t102.installed and v2518.__FyyStealAnEggStartupProtectionLiteV2 == t102 do
					task.wait(60)

					if t102.installed and v2518.__FyyStealAnEggStartupProtectionLiteV2 == t102 then
						v2508(t102)
						t102.status = t102.antiAfkStatus
					end
				end
			end

			task.spawn(v2522)

			return t102
		end,
		uninstall = function()
			local value = rawget(v2506(), "__FyyStealAnEggStartupProtectionLiteV2")

			if type(value) == "table" then
				value.installed = false

				if value.idledConnection and typeof(value.idledConnection.Disconnect) == "function" then
					pcall(value.idledConnection.Disconnect, value.idledConnection)
					value.idledConnection = nil
				end

				if value.characterConnection and typeof(value.characterConnection.Disconnect) == "function" then
					pcall(value.characterConnection.Disconnect, value.characterConnection)
					value.characterConnection = nil
				end
			end
		end
	}

	local function v2524()
		local genv2 = getgenv and getgenv() or _G

		genv2.__SenaV4AntiAfkGeneration = (genv2.__SenaV4AntiAfkGeneration or 0) + 1
		genv2.__SenaV4AntiAfkEnabled = senaV4Config.AntiAFK
		genv2.__SenaV4StartupProtection = t101
		genv2.__SenaV4SetAntiAfkEnabled = function(p699)
			genv2.__SenaV4AntiAfkEnabled = p699 == true

			if p699 then
				t101.install()
			else
				t101.uninstall()
			end
		end

		if senaV4Config.AntiAFK then
			genv2.__SenaV4SetAntiAfkEnabled(true)
		end
	end

	v2524()
end

local v2526 = senaV4Config
local t103 = {
	TeleportService = TeleportService or game:GetService("TeleportService"),
	LP = LocalPlayer or Players.LocalPlayer,
	Players = Players
}

local function v2528()
	pcall(function()
		if writefile then
			pcall(function()
				writefile("autoexec/Sena_StealAnEgg.lua", [[repeat task.wait(0.5) until game:IsLoaded()
task.wait(1.5)
if getgenv then getgenv().SNE_AutoExecute = true end
loadstring(game:HttpGet("https://senahub.xyz/raw/saev2"))()
]])
			end)
			pcall(function()
				writefile("autoexecute/Sena_StealAnEgg.lua", [[repeat task.wait(0.5) until game:IsLoaded()
task.wait(1.5)
if getgenv then getgenv().SNE_AutoExecute = true end
loadstring(game:HttpGet("https://senahub.xyz/raw/saev2"))()
]])
			end)
		end
	end)

	local queue_on_teleport_ = queue_on_teleport or syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport

	if queue_on_teleport_ then
		pcall(function()
			queue_on_teleport_([[repeat task.wait(0.5) until game:IsLoaded()
task.wait(1.5)
if getgenv then getgenv().SNE_AutoExecute = true end
loadstring(game:HttpGet("https://senahub.xyz/raw/saev2"))()
]])
		end)
	end
end
local function v2530()
	pcall(function()
		if delfile then
			pcall(function()
				delfile("autoexec/Sena_StealAnEgg.lua")
			end)
			pcall(function()
				delfile("autoexecute/Sena_StealAnEgg.lua")
			end)
		elseif writefile then
			pcall(function()
				writefile("autoexec/Sena_StealAnEgg.lua", "")
			end)
			pcall(function()
				writefile("autoexecute/Sena_StealAnEgg.lua", "")
			end)
		end
	end)
end

local u2531 = false

local function v2532()
	if u2531 then
		return
	end

	u2531 = true

	if v2526.autoExecute or getgenv and getgenv().SNE_AutoExecute then
		pcall(v2528)
	end

	task.wait(3)

	local TeleportService2 = t103.TeleportService or game:GetService("TeleportService")
	local PlaceId = game.PlaceId
	local JobId = game.JobId

	while true do
		pcall(function()
			if JobId then
				if not (#JobId > 0) then
					TeleportService2:Teleport(PlaceId, t103.LP)

					return
				end

				TeleportService2:TeleportToPlaceInstance(PlaceId, JobId, t103.LP)
			else
				TeleportService2:Teleport(PlaceId, t103.LP)
			end
		end)
		task.wait(6)
	end
end

pcall(function()
	game:GetService("GuiService").ErrorMessageChanged:Connect(function(p700)
		if v2526.autoReconnect and p700 and #p700 > 0 then
			v2532()
		end
	end)
end)
pcall(function()
	local LP = t103.LP or LocalPlayer

	LP = LP or Players.LocalPlayer

	if LP and LP.OnTeleport then
		LP.OnTeleport:Connect(function()
			if v2526.autoExecute or getgenv and getgenv().SNE_AutoExecute then
				pcall(v2528)
			end
		end)
	end
end)
task.spawn(function()
	while true do
		task.wait(2)

		if v2526.autoReconnect then
			pcall(function()
				local RobloxPromptGui = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
				local promptOverlay = RobloxPromptGui and RobloxPromptGui:FindFirstChild("promptOverlay")
				local ErrorPrompt = promptOverlay and promptOverlay:FindFirstChild("ErrorPrompt")

				if ErrorPrompt and ErrorPrompt.Visible then
					v2532()
				end
			end)
		end
	end
end)

local function v2540()
	local Remotes = require(ReplicatedStorage.Shared.Remotes)

	local function v2542(p701, p702, p703)
		local v2543 = (require(ReplicatedStorage.Shared.Save).Peek or require(ReplicatedStorage.Shared.Save).Get)()

		if not v2543 or type(v2543.Inventory) ~= "table" then
			return nil
		end

		local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
		local Directory = require(ReplicatedStorage.Data.Assets).Directory
		local t104 = {}
		local ipairs_ = ipairs
		local EquippedAssets = v2543.EquippedAssets or {}

		for _, EquippedAsset in ipairs_(EquippedAssets) do
			t104[EquippedAsset] = true
		end

		local t105 = {}

		for k, v in pairs(v2543.Inventory) do
			if not t104[k] then
				local u2554

				if AssetItems and type(AssetItems.Decode) == "function" then
					pcall(function()
						u2554 = AssetItems.Decode(v)
					end)
				end

				u2554 = u2554 or v

				if type(u2554) == "table" and not u2554.InFuse and not u2554.IsFavorite and u2554.Category then
					local v2555 = Directory[u2554.Category]
					local DisplayName = v2555 and v2555.Rarity and (v2555.Rarity.DisplayName or v2555.Rarity._id)
					local v2557 = true

					if p703 and #p703 > 0 and not table.find(p703, "All") then
						v2557 = DisplayName and table.find(p703, DisplayName) ~= nil
					end

					local v2558 = true

					if p701 and p702 and #p702 > 0 and not table.find(p702, "All") then
						v2558 = table.find(p702, u2554.Category) ~= nil or v2555 and table.find(p702, v2555.DisplayName) ~= nil
					end

					if v2557 and v2558 then
						t105[u2554.Category] = t105[u2554.Category] or {}
						table.insert(t105[u2554.Category], {
							uid = k,
							d = u2554
						})
					end
				end
			end
		end

		for _, v in pairs(t105) do
			if not (#v >= 3) then
				continue
			end

			return {
				v[1].uid,
				v[2].uid,
				v[3].uid
			}
		end

		return nil
	end

	local t106 = {
		equipBest = function()
			pcall(function()
				Remotes.Haul.WearBest:InvokeServer()
			end)
		end,
		claimOffline = function()
			local ok, result = pcall(function()
				return Remotes.AwayEarnings.FetchSummary:InvokeServer()
			end)

			if ok and type(result) == "table" then
				if (result.ClaimableAmount or 0) > 0 then
					pcall(function()
						Remotes.AwayEarnings.AskCollect:InvokeServer({
							Kind = "Claim"
						})
					end)
				end
			end
		end,
		favoriteSelected = function()
			local v2564 = (require(ReplicatedStorage.Shared.Save).Peek or require(ReplicatedStorage.Shared.Save).Get)()

			if not v2564 or type(v2564.Inventory) ~= "table" then
				return 0
			end

			local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
			local Directory = require(ReplicatedStorage.Data.Assets).Directory
			local n47 = 0

			for k, v in pairs(v2564.Inventory) do
				local u2570

				if AssetItems and type(AssetItems.Decode) == "function" then
					pcall(function()
						u2570 = AssetItems.Decode(v)
					end)
				end

				u2570 = u2570 or v

				if type(u2570) == "table" then
					if not u2570.IsFavorite and u2570.Category then
						local v2571 = Directory[u2570.Category]
						local DisplayName = v2571 and v2571.Rarity and (v2571.Rarity.DisplayName or v2571.Rarity._id)
						local v2573 = false

						if senaV4Config.FavMode == "Species" then
							local FavSpecies = senaV4Config.FavSpecies or {}

							if table.find(FavSpecies, "All") or table.find(FavSpecies, u2570.Category) or v2571 and table.find(FavSpecies, v2571.DisplayName) then
								v2573 = true
							end
						else
							local FavRarities = senaV4Config.FavRarities or {}

							if table.find(FavRarities, "All") or DisplayName and table.find(FavRarities, DisplayName) then
								v2573 = true
							end
						end

						if v2573 then
							pcall(function()
								Remotes.PetSatchel.WriteFavourite:FireServer(k, true)
							end)
							n47 += 1

							if n47 % 10 == 0 then
								task.wait(0.05)
							end
						end
					end
				end
			end

			return n47
		end,
		unfavoriteAll = function()
			local v2576 = (require(ReplicatedStorage.Shared.Save).Peek or require(ReplicatedStorage.Shared.Save).Get)()

			if not v2576 or type(v2576.Inventory) ~= "table" then
				return 0
			end

			local n48 = 0

			for k, v in pairs(v2576.Inventory) do
				local v2580 = v

				if type(v2580) == "table" and v2580.IsFavorite then
					pcall(function()
						Remotes.PetSatchel.WriteFavourite:FireServer(k, false)
					end)
					n48 += 1

					if n48 % 10 == 0 then
						task.wait(0.05)
					end
				end
			end

			return n48
		end,
		fuseOnePair = function()
			local v2581 = (require(ReplicatedStorage.Shared.Save).Peek or require(ReplicatedStorage.Shared.Save).Get)()

			if not v2581 then
				return false
			end

			if v2581.FusionLocked then
				return false, "Fusion locked"
			end

			local v2582 = v2542(senaV4Config.FuseSelectedOnly, senaV4Config.FuseSpecies, senaV4Config.FuseRarities)

			if not v2582 then
				return false, "No eligible group of 3"
			end

			pcall(function()
				Remotes.Fusery.ConfirmBriefing:InvokeServer()
			end)

			for _, v in ipairs(v2582) do
				local ok, result = pcall(function()
					return Remotes.Fusery.LoadPet:InvokeServer(v)
				end)

				if ok and result then
					task.wait(0.02)

					continue
				end

				return false, "Failed to load pet"
			end

			local ok, result = pcall(function()
				return Remotes.Fusery.BeginFuse:InvokeServer()
			end)

			if not ok or not result then
				return false, "Failed to begin fuse"
			end

			task.wait(0.06)
			pcall(function()
				Remotes.Fusery.FinishReveal:InvokeServer()
			end)

			return true
		end
	}

	task.spawn(function()
		local n49 = 0

		while v16() do
			local now = os.clock()

			if senaV4Config.AutoEquipBest and now - n49 > 6 then
				n49 = now
				pcall(t106.equipBest)
			end

			if senaV4Config.AutoClaimOffline then
				pcall(t106.claimOffline)
			end

			if senaV4Config.AutoFavorite then
				pcall(t106.favoriteSelected)
			end

			if senaV4Config.AutoFusePets then
				pcall(t106.fuseOnePair)
			end

			task.wait(2.5)
		end
	end)

	return t106
end

genv.__SenaV4PetBarn = v2540()

do
	local function v2591()
		local Remotes = require(ReplicatedStorage.Shared.Remotes)
		local t107 = {
			upgradeBase = function()
				local v2594 = (require(ReplicatedStorage.Shared.Save).Peek or require(ReplicatedStorage.Shared.Save).Get)()

				if not v2594 then
					return false
				end

				local v2595 = tonumber(v2594.BaseUpgradeLevel or 0) or 0
				local Bases = require(ReplicatedStorage.Data.Bases)
				local BASES = Bases and Bases.BASES and Bases.BASES[v2595 + 1]

				if not BASES then
					return false, "Max level"
				end

				local v2598 = tonumber(v2594.Money or 0) or 0

				if v2598 < (BASES.Cost or 0) then
					return false, "Not enough money"
				end

				local ok, result = pcall(function()
					return Remotes.Homestead.AskBaseTierRaise:InvokeServer()
				end)
				local v2601 = ok and result == true

				return v2601, result
			end,
			claimAlmanac = function()
				local ok, result = pcall(function()
					return Remotes.Codex.AskRedeemAll:InvokeServer()
				end)

				return ok, result
			end
		}

		task.spawn(function()
			while v16() do
				if senaV4Config.AutoBaseUpgrade then
					pcall(t107.upgradeBase)
				end

				if senaV4Config.AutoClaimAlmanac then
					pcall(t107.claimAlmanac)
				end

				task.wait(3)
			end
		end)

		return t107
	end

	genv.__SenaV4Upgrades = v2591()
end

local function v2604()
	local t108 = {
		noclipConn = nil
	}

	t108.setNoclip = function(p704)
		senaV4Config.Noclip = p704 == true

		if t108.noclipConn then
			pcall(function()
				t108.noclipConn:Disconnect()
			end)
			t108.noclipConn = nil
		end

		if senaV4Config.Noclip then
			t108.noclipConn = RunService.Stepped:Connect(function()
				if not senaV4Config.Noclip then
					return
				end

				local Character = LocalPlayer.Character

				if not Character then
					return
				end

				for _, descendant in ipairs(Character:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.CanCollide then
						descendant:SetAttribute("SenaNoclip", true)
						descendant.CanCollide = false
					end
				end
			end)

			return
		end

		local Character = LocalPlayer.Character

		if Character then
			for _, descendant in ipairs(Character:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant:GetAttribute("SenaNoclip") then
					descendant.CanCollide = true
					descendant:SetAttribute("SenaNoclip", nil)
				end
			end
		end
	end
	t108.waypointList = function()
		local t109 = { "Respawn Point" }
		local v2613 = v14()
		local Machines = v2613 and v2613:FindFirstChild("Machines")

		if Machines and Machines:FindFirstChild("FuseMachine") then
			table.insert(t109, "Fuse Machine")
		end

		local Areas = v2613 and v2613:FindFirstChild("Areas")
		local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")

		if GuardAreas then
			for _, child in ipairs(GuardAreas:GetChildren()) do
				table.insert(t109, child.Name)
			end
		end

		return t109
	end
	t108.teleportWaypoint = function(p705)
		local Character = LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return false
		end

		local Position
		local v2622 = v14()

		if p705 == "Respawn Point" then
			pcall(function()
				local PlotState2 = require(ReplicatedStorage.Client.PlotState)
				local ResolvePlot = PlotState2.ResolvePlot and PlotState2.ResolvePlot()

				if ResolvePlot and ResolvePlot.RespawnPointCFrame then
					Position = ResolvePlot.RespawnPointCFrame.Position
				elseif ResolvePlot and ResolvePlot.Model then
					if ResolvePlot.Model:FindFirstChild("Spawn") then
						Position = ResolvePlot.Model.Spawn.Position
					end
				end
			end)
		elseif p705 == "Fuse Machine" then
			local Machines = v2622 and v2622:FindFirstChild("Machines")
			local FuseMachine = Machines and Machines:FindFirstChild("FuseMachine")
			local Machine = FuseMachine and (FuseMachine:FindFirstChild("Machine") or FuseMachine.PrimaryPart)

			if Machine then
				Position = Machine.Position
			end
		else
			local Areas = v2622 and v2622:FindFirstChild("Areas")
			local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
			local v2630 = GuardAreas and GuardAreas:FindFirstChild(p705)
			local Guard = v2630 and v2630:FindFirstChild("Guard")

			if Guard and Guard:IsA("BasePart") then
				Position = Guard.Position
			end
		end

		if not Position then
			return false
		end

		HumanoidRootPart.CFrame = cFrameNew(Position + Vector3.new(0, 4, 0))
		HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero

		return true
	end
	t108.setBottingMode = function(p706)
		senaV4Config.BottingMode = p706 == true

		local __SenaV4BottingOverlay = genv.__SenaV4BottingOverlay

		if __SenaV4BottingOverlay and __SenaV4BottingOverlay.Parent then
			pcall(function()
				__SenaV4BottingOverlay:Destroy()
			end)
		end

		genv.__SenaV4BottingOverlay = nil

		if not senaV4Config.BottingMode then
			pcall(function()
				RunService:Set3dRenderingEnabled(true)
			end)

			return
		end

		pcall(function()
			RunService:Set3dRenderingEnabled(false)
		end)

		local CoreGui

		pcall(function()
			CoreGui = game:GetService("CoreGui")
		end)
		CoreGui = CoreGui or LocalPlayer:FindFirstChildOfClass("PlayerGui")

		if not CoreGui then
			return
		end

		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "SenaBottingOverlay"
		ScreenGui.ResetOnSpawn = false
		ScreenGui.IgnoreGuiInset = true
		ScreenGui.DisplayOrder = -1
		ScreenGui.Parent = CoreGui

		local Frame = Instance.new("Frame")

		Frame.Name = "Blackscreen"
		Frame.Size = UDim2.new(1, 0, 1, 0)
		Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Active = false
		Frame.Parent = ScreenGui
		genv.__SenaV4BottingOverlay = ScreenGui
	end
	task.spawn(function()
		while v16() do
			if senaV4Config.AntiCutscene then
				pcall(function()
					local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

					if PlayerGui then
						for _, child in ipairs(PlayerGui:GetChildren()) do
							if child:IsA("ScreenGui") and (string.find(string.lower(child.Name), "cutscene") or child.Name == "Intro") and child.Enabled then
								child.Enabled = false
							end
						end
					end
				end)
			end

			task.wait(0.2)
		end
	end)

	return t108
end

genv.__SenaV4Roaming = v2604()

do
	local function v2639()
		local t110 = {
			snapAt = 0,
			snap = nil,
			status = "Idle",
			lastBuy = 0,
			doneLost = {},
			active = false,
			token = 0
		}

		local function v2641()
			return require(ReplicatedStorage.Shared.Remotes).Scramble
		end

		t110.snapshot = function(p707)
			local now = os.clock()

			if not p707 and t110.snap and now - t110.snapAt < 1.5 then
				return t110.snap
			end

			local ok, snap = pcall(function()
				return v2641().Request:InvokeServer("Snapshot")
			end)

			if ok and type(snap) == "table" and snap.State then
				t110.snap = snap
				t110.snapAt = now
			end

			return t110.snap
		end
		t110.live = function()
			local v2645 = t110.snapshot()

			if not v2645 then
				return false
			end

			local v2646 = v2645.Ready == true and v2645.Enabled == true and v2645.WorldReady == true

			if v2646 then
				v2646 = workspace:GetServerTimeNow() < (v2645.EventEndsAt or 0)
			end

			return v2646
		end
		t110.windowActive = function()
			local v2647 = t110.snapshot()

			return v2647 and v2647.Window and v2647.Window.Active == true or false
		end
		t110.progress = function()
			local v2648 = t110.snapshot()
			local State = v2648 and v2648.State

			if State then
				return State.Samples or 0, State.TotalParts or 0, State.DroneParts or 0
			end

			return 0, 0, 0
		end
		t110.buyTick = function()
			local ScrambleBuyList = senaV4Config.ScrambleBuyList

			if not ScrambleBuyList or #ScrambleBuyList == 0 then
				return
			end

			if os.clock() - t110.lastBuy < 2 then
				return
			end

			local v2651 = t110.snapshot(true)

			if not v2651 or not v2651.State or not v2651.Shop then
				return
			end

			local Samples = v2651.State.Samples or 0

			for _, v in pairs(v2651.Shop) do
				if not senaV4Config.ScrambleAutoBuy then
					return
				end

				local v2655 = tostring(v.Label)
				local v2656 = false
				local v2657, v2658, v2659 = ipairs(ScrambleBuyList)
				local v2660 = geniter(v2657, v2658, v2659)
				local v2661 = table.pack(v2660())

				if v2661[1] then
					local v2662 = v2661[3]

					while true do
						if tostring(v2662) == v2655 then
							v2656 = true

							break
						end

						local v2663 = table.pack(v2660())

						if not v2663[1] then
							break
						end

						v2662 = v2663[3]
					end

					if not v2656 then
						continue
					end

					if not ((v.Price or 0) <= Samples) then
						continue
					end

					local v2664 = (v2651.State.ShopPurchases or {})[v.Id]
					local Count = v2664 and v2664.Period == v2651.ShopPeriod and (v2664.Count or 0) or 0

					if not v.PurchaseLimit then
						t110.lastBuy = os.clock()
						pcall(function()
							v2641().Request:InvokeServer("Shop", v.Id, {
								Quote = v.Quote,
								Sequence = v2651.State.ShopSequence
							})
						end)
						t110.status = "Bought " .. v2655
						t110.snapshot(true)

						return
					end

					if not (Count + (v.Quantity or 1) <= v.PurchaseLimit) then
						continue
					end

					t110.lastBuy = os.clock()
					pcall(function()
						v2641().Request:InvokeServer("Shop", v.Id, {
							Quote = v.Quote,
							Sequence = v2651.State.ShopSequence
						})
					end)
					t110.status = "Bought " .. v2655
					t110.snapshot(true)

					return
				end
			end
		end
		task.spawn(function()
			while v16() do
				t110.wantsCharacter = false
				t110.active = false

				if senaV4Config.ScrambleAutoBuy then
					pcall(function()
						if t110.live() then
							t110.buyTick()
						else
							t110.status = "Event not active"
						end
					end)
				end

				task.wait(senaV4Config.ScrambleAutoBuy and 0.5 or 1)
			end
		end)

		return t110
	end

	genv.__SenaV4ScrambleRuntime = v2639()
end

local function v2666()
	local t111 = {
		status = "Idle",
		active = false,
		wantsCharacter = false,
		lastSwing = 0,
		retryAt = {},
		cards = {},
		snap = {}
	}
	local t112 = {
		"Green",
		"Blue",
		"Purple",
		"Golden"
	}
	local t113 = {
		Green = 1,
		Blue = 2,
		Purple = 3,
		Golden = 4
	}
	local t114 = {
		TITLES = {
			auto_steal = "Auto Steal",
			mech_boss = "Mech Boss",
			auto_place = "Auto Place"
		},
		blocker = function()
			if LocalPlayer:GetAttribute("InScrambleArena") == true then
				return "mech_boss"
			end

			if senaV4Config.ScrambleBossAuto == true then
				local ScrambleArena = workspace:FindFirstChild("ScrambleArena")

				if workspace:FindFirstChild("ScrambleArenaPortal") or ScrambleArena and ScrambleArena:GetAttribute("Phase") ~= "Defeated" then
					return "mech_boss"
				end
			end

			local __SenaV4StealWantsCharacter = genv.__SenaV4StealWantsCharacter

			if __SenaV4StealWantsCharacter and __SenaV4StealWantsCharacter() then
				return "auto_steal"
			end

			return nil
		end,
		holder = function()
			if senaV4Config.IsPlacing == true then
				return "auto_place"
			end

			return nil
		end
	}

	local function v2673(p708, ...)
		for _, v in ipairs({ ... }) do
			if not p708 then
				return nil
			end

			p708 = p708:FindFirstChild(v)
		end

		return p708
	end

	local u2676

	local function v2677()
		if u2676 then
			return u2676
		end

		local function v2678(p709)
			if not p709 then
				return nil
			end

			local ok, result = pcall(require, p709)

			return ok and result or nil
		end

		local t115 = {
			Remotes = v2678(v2673(ReplicatedStorage, "Shared", "Remotes")),
			Save = v2678(v2673(ReplicatedStorage, "Shared", "Save")),
			Catalog = v2678(v2673(ReplicatedStorage, "Shared", "Modules", "ButterflyCatalog")),
			Flags = v2678(v2673(ReplicatedStorage, "Shared", "Flags", "ButterflyFlags")),
			Swarm = v2678(v2673(ReplicatedStorage, "Controllers", "Game", "AdminAbuseClientController", "Events", "ButterflyBloom", "Swarm"))
		}

		if not t115.Remotes or not t115.Save or not t115.Catalog then
			return nil
		end

		u2676 = t115

		return t115
	end
	local function v2682(p710, p711)
		local v2683 = v2677()
		local Flags = v2683 and v2683.Flags and v2683.Flags[p710]

		if not Flags then
			return p711
		end

		local ok, result = pcall(function()
			return Flags:Get()
		end)

		if not ok or result == nil then
			return p711
		end

		return result
	end
	local function v2687(p712, p713, ...)
		local v2688 = v2677()
		local v2689 = v2688 and v2688.Remotes[p712] and v2688.Remotes[p712][p713]

		if not v2689 then
			return false, p712 .. "." .. p713 .. " missing"
		end

		local v2690 = table.pack(pcall(v2689.InvokeServer, v2689, ...))

		if v2690[1] then
			return v2690[2] == true, type(v2690[3]) == "string" and v2690[3] or nil, v2690[2]
		end

		return false, tostring(v2690[2])
	end
	local function v2691(p714)
		return (t111.retryAt[p714] or 0) <= os.clock()
	end
	local function v2692(p715)
		t111.retryAt[p715] = os.clock() + 5
	end
	local function v2693()
		local Character = LocalPlayer.Character

		return Character and Character:FindFirstChild("HumanoidRootPart") or nil
	end

	t111.bloomLeft = function()
		local v2695 = v2677()
		local attribute = workspace:GetAttribute(v2695 and v2695.Catalog.EndsAtAttribute or "ButterflyBloomEndsAt")

		if typeof(attribute) == "number" then
			return math.max(0, attribute - workspace:GetServerTimeNow())
		end

		return 0
	end
	t111.nextBloom = function()
		local v2697 = tonumber(v2682("IntervalSeconds", 1800)) or 1800
		local v2698 = tonumber(v2682("OffsetSeconds", 900)) or 900
		local v2699 = tonumber(v2682("DurationSeconds", 300)) or 300

		if v2697 <= 0 then
			return nil
		end

		local serverTimeNow = workspace:GetServerTimeNow()
		local v2701 = v2677()
		local attribute = workspace:GetAttribute(v2701 and v2701.Catalog.EndsAtAttribute or "ButterflyBloomEndsAt")
		local v2703 = typeof(attribute) == "number" and attribute - v2699 or math.floor((serverTimeNow - v2698) / v2697) * v2697 + v2698
		local n50 = 0

		while v2703 <= serverTimeNow and n50 < 64 do
			v2703 += v2697
			n50 += 1
		end

		return v2703 > serverTimeNow and v2703 - serverTimeNow or nil
	end

	local function v2705(p716)
		if not p716 then
			return nil
		end

		for _, child in ipairs(p716:GetChildren()) do
			if child:IsA("Tool") and child:GetAttribute("ButterflyNet") == true then
				return child
			end
		end

		return nil
	end

	local u2708

	t111.tiers = function()
		if u2708 then
			return u2708
		end

		local v2709 = v2677()

		if not v2709 then
			return nil
		end

		local t116 = {}

		for i, v in ipairs(t112) do
			local Tiers = v2709.Catalog.Tiers and v2709.Catalog.Tiers[v]

			t116[v] = {
				name = (Tiers and tostring(Tiers.DisplayName) or v):gsub("%s*Butterfly$", ""),
				color = Tiers and typeof(Tiers.Color) == "Color3" and Tiers.Color or Color3.new(1, 1, 1),
				trade = i < 4 and (tonumber(v2682(("%sTo%sCost"):format(v, t112[i + 1]), 0)) or 0) or 0,
				essence = tonumber(v2682("Essence" .. v, 0)) or 0
			}
		end

		u2708 = t116

		return t116
	end
	t111.snapshot = function()
		local v2714 = v2677()
		local snap = t111.snap

		if not v2714 then
			return snap
		end

		snap.left = t111.bloomLeft()
		snap.active = snap.left > 0
		snap.enabled = v2682("Enabled", true) ~= false
		snap.nextIn = not snap.active and t111.nextBloom() or nil

		local ok, result = pcall(v2714.Save.Peek)
		local v2718 = ok and result or nil
		local Butterflies = v2718 and v2718.Butterflies

		snap.net = type(Butterflies) == "table" and Butterflies.NetClaimed == true
		snap.holding = v2705(LocalPlayer.Character) ~= nil
		snap.inBag = v2705(LocalPlayer:FindFirstChildOfClass("Backpack")) ~= nil
		snap.counts = snap.counts or {}

		for _, v in ipairs(t112) do
			snap.counts[v] = type(Butterflies) == "table" and Butterflies.Counts and tonumber(Butterflies.Counts[v]) or 0
		end

		snap.essence = type(Butterflies) == "table" and tonumber(Butterflies.Essence) or 0
		snap.caught = type(Butterflies) == "table" and tonumber(Butterflies.TotalCaught) or 0
		snap.treeUnlocked = LocalPlayer:GetAttribute("EnchantedTreeUnlocked") == true

		return snap
	end
	t111.smartNext = function(p717)
		local v2722 = t111.tiers()

		if not v2722 or not p717 then
			return nil
		end

		for i = 3, 1, -1 do
			local v2724 = t112[i]
			local v2725 = t112[i + 1]
			local trade = v2722[v2724].trade

			if not (trade > 0) then
				continue
			end

			if not ((p717[v2725] or 0) < v2722[v2725].essence) then
				continue
			end

			if trade <= (p717[v2724] or 0) - v2722[v2724].essence then
				return v2724
			end
		end

		return nil
	end
	t111.canTrade = function()
		local snap = t111.snap
		local v2728 = t111.tiers()

		if not v2728 or not snap.counts then
			return false
		end

		local ButterflyTradeRecipe = senaV4Config.ButterflyTradeRecipe

		if ButterflyTradeRecipe == "Smart" then
			return t111.smartNext(snap.counts) ~= nil
		end

		for i = 1, 3 do
			local v2731 = t112[i]

			if ButterflyTradeRecipe ~= nil and ButterflyTradeRecipe ~= "All" and ButterflyTradeRecipe ~= v2731 or not (v2728[v2731].trade > 0) then
				continue
			end

			if v2728[v2731].trade <= (snap.counts[v2731] or 0) then
				return true
			end
		end

		return false
	end
	t111.canCraft = function()
		local snap = t111.snap
		local v2733 = t111.tiers()

		if not v2733 or not snap.counts then
			return false
		end

		for _, v in ipairs(t112) do
			if not (v2733[v].essence > 0) then
				continue
			end

			if (snap.counts[v] or 0) < v2733[v].essence then
				return false, v
			end
		end

		return true
	end

	local function v2736()
		local ButterflyTiers = senaV4Config.ButterflyTiers

		if type(ButterflyTiers) ~= "table" or #ButterflyTiers == 0 then
			return nil
		end

		local t117 = {}

		for _, ButterflyTier in ipairs(ButterflyTiers) do
			t117[tostring(ButterflyTier)] = true
		end

		return t117
	end
	local function v2741()
		local ButterflyBloomSwarm = workspace:FindFirstChild("ButterflyBloomSwarm")

		if not ButterflyBloomSwarm then
			return {}
		end

		local t118 = {}

		for _, child in ipairs(ButterflyBloomSwarm:GetChildren()) do
			if t113[child.Name] and child:IsA("Model") then
				t118[#t118 + 1] = {
					pos = child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position,
					tier = child.Name
				}
			end
		end

		return t118
	end
	local function v2746()
		local Character = LocalPlayer.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local v2749 = v2705(LocalPlayer:FindFirstChildOfClass("Backpack"))

		if not Humanoid or not v2749 then
			return false
		end

		pcall(function()
			Humanoid:EquipTool(v2749)
		end)

		return v2705(Character) ~= nil
	end

	local t119 = {
		part = nil,
		y = 0
	}

	local function v2751()
		if t119.part then
			pcall(function()
				t119.part:Destroy()
			end)
		end

		t119.part = nil
	end
	local function v2752()
		local v2753 = v2693()

		if not v2753 then
			return
		end

		if not t119.part or not t119.part.Parent then
			local Part = Instance.new("Part")

			Part.Name = "SenaBloomPad"
			Part.Anchored = true
			Part.CanCollide = true
			Part.CanTouch = false
			Part.CastShadow = false
			Part.Transparency = 1
			Part.Size = Vector3.new(24, 1, 24)
			t119.y = v2753.Position.Y - 3.5
			Part.CFrame = cFrameNew(v2753.Position.X, t119.y, v2753.Position.Z)
			Part.Parent = workspace
			t119.part = Part
		end

		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = {
			LocalPlayer.Character,
			t119.part
		}

		local hit = workspace:Raycast(v2753.Position + Vector3.new(0, 4, 0), Vector3.new(0, -80, 0), raycastParams)

		if not hit then
			return
		end

		t119.y += math.clamp(hit.Position.Y - 0.5 + 6 - t119.y, -2, 2)
		t119.part.CFrame = cFrameNew(v2753.Position.X, t119.y, v2753.Position.Z)
	end
	local function v2757(p718, p719)
		local Character = LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or not Humanoid then
			return false
		end

		v2751()

		local v2761 = os.clock() + (p719 or 30)

		local function v2762()
			if not v16() or v2761 < os.clock() then
				return true
			end

			return t114.blocker("butterfly") ~= nil
		end

		if v612 and HumanoidRootPart.Position.Y < 16000 and p718.Y < 16000 and (HumanoidRootPart.Position - p718).Magnitude > 600 and not v612:_isInSafeArea(HumanoidRootPart) then
			local v2763 = v612:_resolveSafeCFrame(HumanoidRootPart)

			if v2763 and (v2763.Position - p718).Magnitude > 40 then
				local status = t111.status

				t111.status = "Heading to the safe zone first"
				pcall(v232, HumanoidRootPart, Humanoid, v2763, v2762)
				t111.status = status
				HumanoidRootPart = v2693()

				if not HumanoidRootPart or v2762() or not v612:_isInSafeArea(HumanoidRootPart) then
					return false
				end
			end
		end

		pcall(v232, HumanoidRootPart, Humanoid, cFrameNew(p718) * HumanoidRootPart.CFrame.Rotation, v2762)

		local v2765 = v2693()
		local v2766 = v2765 ~= nil and (v2765.Position - p718).Magnitude <= 12

		return v2766
	end
	local function v2767()
		if LocalPlayer:GetAttribute("InEnchantedTree") == true then
			return true
		end

		local v2768 = v2693()

		return v2768 ~= nil and v2768.Position.Y > 16000
	end
	local function v2769(p720)
		if not p720 or not p720:IsA("ProximityPrompt") or not p720.Enabled then
			return false
		end

		local v2770 = tonumber(p720.HoldDuration) or 0

		pcall(function()
			p720:InputHoldBegin()
			task.wait(v2770 > 0 and v2770 + 0.15 or 0.05)
			p720:InputHoldEnd()
		end)

		if typeof(fireproximityprompt) == "function" then
			pcall(fireproximityprompt, p720, v2770 > 0 and v2770 + 0.15 or 0)
		end

		return true
	end

	local EnchantedTreePrompt

	local function v2772()
		if v2767() then
			return nil
		end

		if LocalPlayer:GetAttribute("EnchantedTreeUnlocked") ~= true then
			return "Enchanted Tree is locked (finish the Wisp Event)"
		end

		if not EnchantedTreePrompt or not EnchantedTreePrompt.Parent then
			local world = v2673(workspace, "World", "Build", "EnchantedTreeInterior", "Markers", "EnterTrigger")

			EnchantedTreePrompt = world and world:FindFirstChild("EnchantedTreePrompt", true) or nil
		end

		local Parent = EnchantedTreePrompt and EnchantedTreePrompt.Parent
		local WorldPosition = Parent and (Parent:IsA("Attachment") and Parent.WorldPosition or Parent:IsA("BasePart") and Parent.Position)

		if not WorldPosition then
			return "tree entrance not found"
		end

		if v177() then
			return "night - the forest is sealed"
		end

		t111.status = "Flying to the Enchanted Tree"

		if not v2757(WorldPosition + Vector3.new(0, 3, 0), 60) then
			return "could not reach the tree entrance"
		end

		t111.status = "Entering the tree"
		v2769(EnchantedTreePrompt)

		local v2776 = os.clock() + 8

		while os.clock() < v2776 and not v2767() do
			task.wait(0.05)
		end

		if v2767() then
			return nil
		end

		return "entering the tree failed"
	end
	local function v2777()
		if not v2767() then
			return true
		end

		local world = v2673(workspace, "World", "Build", "EnchantedTreeInterior", "Markers", "ExitTrigger")

		if not world or typeof(firetouchinterest) ~= "function" then
			return false
		end

		t111.status = "Leaving the tree"

		local v2779 = os.clock() + 6

		while os.clock() < v2779 and v2767() do
			local v2780 = v2693()

			if v2780 then
				pcall(firetouchinterest, v2780, world, 0)
				pcall(firetouchinterest, v2780, world, 1)
			end

			task.wait(0.3)
		end

		return not v2767()
	end
	local function v2781(p721)
		local world = v2673(workspace, "World", "Machines", "ButterflyStation", p721, "Anchor")

		return world and world:IsA("BasePart") and world.Position or nil, world
	end
	local function v2783(p722)
		local v2784 = v2781(p722)

		if not v2784 then
			return false, p722 .. " not found"
		end

		local v2785 = v2693()

		if v2785 and (v2785.Position - v2784).Magnitude <= 10 then
			return true
		end

		local v2786 = v2772()

		if v2786 then
			return false, v2786
		end

		t111.status = "Walking to the " .. p722

		if v2757(v2784 + Vector3.new(0, 3, 0), 15) then
			return true
		end

		return false, "could not reach the " .. p722
	end
	local function v2787()
		local world = v2673(workspace, "World", "Areas", "ButterflyBloom", "Bounds")

		return world and world:IsA("BasePart") and world or nil
	end
	local function v2789()
		local v2790 = v2787()
		local v2791 = v2693()

		if not v2790 or not v2791 or v2767() then
			return false
		end

		local v2792 = v2790.CFrame:PointToObjectSpace(v2791.Position)

		return math.abs(v2792.X) <= v2790.Size.X / 2 + 20 and math.abs(v2792.Z) <= v2790.Size.Z / 2 + 20
	end
	local function v2793()
		local v2794 = v2787()

		return v2794 and v2794.Position + Vector3.new(0, 4, 0) or nil
	end
	local function v2795()
		local __SenaV4TreadmillManager = genv.__SenaV4TreadmillManager

		if not __SenaV4TreadmillManager or __SenaV4TreadmillManager.activeTreadmill == nil then
			return
		end

		t111.status = "Leaving the treadmill"

		local v2797 = os.clock() + 5

		while __SenaV4TreadmillManager.activeTreadmill ~= nil and os.clock() < v2797 do
			__SenaV4TreadmillManager:_requestUnequip()
			task.wait(0.3)
		end

		local v2798 = v2693()

		if v2798 and v2798.Anchored then
			pcall(function()
				v2798.Anchored = false
			end)
		end
	end
	local function v2799()
		local __SenaV4TreadmillManager = genv.__SenaV4TreadmillManager

		if not __SenaV4TreadmillManager or __SenaV4TreadmillManager.destroyed or not __SenaV4TreadmillManager.config.idleFarm then
			return false
		end

		if not __SenaV4TreadmillManager.busy and not __SenaV4TreadmillManager.idleRunning then
			task.defer(function()
				__SenaV4TreadmillManager:_startIdle()
			end)
		end

		return true
	end
	local function v2801()
		v2751()

		if v2767() then
			v2777()
		end

		if v2799() then
			return
		end

		local v2802 = v2693()

		if not v2802 or not v612 or v612:_isInSafeArea(v2802) then
			return
		end

		local v2803 = v612:_resolveSafeCFrame(v2802)

		if v2803 then
			t111.status = "Back to the safe zone"
			v2757(v2803.Position, 60)
		end
	end

	t111.claimNet = function()
		local NetStand, v2805 = v2783("NetStand")

		if not NetStand then
			return false, v2805
		end

		t111.status = "Claiming the net"

		local _, v2807 = v2781("NetStand")
		local Butterflies, v2809

		if v2807 then
			local ProximityPrompt = v2807:FindFirstChildWhichIsA("ProximityPrompt", true)

			if ProximityPrompt and ProximityPrompt.Enabled then
				v2769(ProximityPrompt)

				local v2811 = os.clock() + 2

				while true do
					if not (os.clock() < v2811) then
						Butterflies, v2809 = v2687("Butterflies", "AskClaimNet")

						return Butterflies, v2809
					end

					if not t111.snapshot().net then
						task.wait(0.1)

						continue
					end

					break
				end

				return true
			end
		end

		Butterflies, v2809 = v2687("Butterflies", "AskClaimNet")

		return Butterflies, v2809
	end
	t111.tradeUp = function()
		t111.snapshot()

		if not t111.canTrade() then
			return false, "nothing to trade up"
		end

		local ButterflyMachine, v2813 = v2783("ButterflyMachine")

		if not ButterflyMachine then
			return false, v2813
		end

		local v2814 = t111.tiers()
		local ButterflyTradeRecipe = senaV4Config.ButterflyTradeRecipe
		local n51 = 0

		if ButterflyTradeRecipe == "Smart" then
			local v2817 = table.clone(t111.snap.counts)
			local v2818

			while true do
				if n51 < 50 then
					local v2819 = t111.smartNext(v2817)

					if not v2819 then
						return true, n51
					end

					t111.status = "Trading up " .. v2814[v2819].name .. " for the essence"

					local Butterflies

					Butterflies, v2818 = v2687("Butterflies", "AskTradeUp", v2819)

					if not Butterflies then
						break
					end

					n51 += 1
					v2817[v2819] = (v2817[v2819] or 0) - v2814[v2819].trade

					local v2821 = t112[t113[v2819] + 1]

					v2817[v2821] = (v2817[v2821] or 0) + 1
					task.wait(0.12)
				else
					return true, n51
				end
			end

			if n51 == 0 then
				return false, v2818 or "the machine refused"
			end

			return true, n51
		end

		local v2822

		for i = 3, 1, -1 do
			local v2824 = t112[i]

			if ButterflyTradeRecipe ~= nil and ButterflyTradeRecipe ~= "All" and ButterflyTradeRecipe ~= v2824 then
				continue
			end

			local v2825 = t111.snap.counts[v2824] or 0
			local trade = v2814[v2824].trade
			local exitTo

			while trade > 0 and trade <= v2825 do
				t111.status = "Trading up " .. v2814[v2824].name

				local Butterflies

				Butterflies, v2822 = v2687("Butterflies", "AskTradeUp", v2824)

				if not Butterflies then
					exitTo = 1

					break
				end

				n51 += 1
				v2825 -= trade
				task.wait(0.12)
			end

			if exitTo == 1 then
				if n51 == 0 then
					return false, v2822 or "the machine refused"
				end
			end
		end

		return true, n51
	end
	t111.craft = function()
		t111.snapshot()

		local v2829, v2830 = t111.canCraft()

		if not v2829 then
			local v2831 = t111.tiers()

			return false, "need more " .. tostring(v2831 and v2831[v2830] and v2831[v2830].name or v2830)
		end

		local MutationShrine, v2833 = v2783("MutationShrine")

		if not MutationShrine then
			return false, v2833
		end

		local n52 = 0
		local v2835

		while true do
			if n52 < 10 and t111.canCraft() then
				t111.status = "Crafting Enchanted Essence"

				local Butterflies

				Butterflies, v2835 = v2687("Butterflies", "AskCraftEssence")

				if not Butterflies then
					break
				end

				n52 += 1
				task.wait(0.2)
				t111.snapshot()
			else
				return true, n52
			end
		end

		if n52 == 0 then
			return false, v2835 or "the shrine refused"
		end

		return true, n52
	end
	t111.tierOptions = function()
		local v2837 = t111.tiers()
		local t120 = {}

		for i = #t112, 1, -1 do
			local v2840 = t112[i]

			t120[#t120 + 1] = v2837 and v2837[v2840].name or v2840
		end

		return t120
	end
	t111.tierFromLabel = function(p723)
		local v2841 = t111.tiers()

		for _, v in ipairs(t112) do
			if p723 == v or v2841 and v2841[v].name == p723 then
				return v
			end
		end

		return nil
	end
	t111.setTiers = function(p724)
		local butterflyTiers = {}
		local ipairs_ = ipairs
		local v2846 = type(p724) == "table" and p724 or {}

		for _, v in ipairs_(v2846) do
			local v2849 = t111.tierFromLabel(tostring(v))

			if v2849 then
				butterflyTiers[#butterflyTiers + 1] = v2849
			end
		end

		senaV4Config.ButterflyTiers = butterflyTiers
	end

	local t121 = {
		"All Recipes",
		"For Essence (shortfall only)",
		"Emerald to Sapphire",
		"Sapphire to Amethyst",
		"Amethyst to Radiant"
	}
	local t122 = {
		["For Essence (shortfall only)"] = "Smart",
		["Emerald to Sapphire"] = "Green",
		["Sapphire to Amethyst"] = "Blue",
		["Amethyst to Radiant"] = "Purple"
	}

	t111.recipeOptions = function()
		return t121
	end
	t111.setRecipe = function(p725)
		senaV4Config.ButterflyTradeRecipe = t122[tostring(p725)] or "All"
	end

	local t123 = {
		"Tween to Butterfly",
		"Stand",
		"Zigzag",
		"Circle"
	}
	local t124 = {
		["Tween to Butterfly"] = "Tween",
		Stand = "Stand",
		Zigzag = "Zigzag",
		Circle = "Circle"
	}

	t111.modeOptions = function()
		return t123
	end
	t111.setMode = function(p726)
		senaV4Config.ButterflyCatchMode = t124[tostring(p726)] or "Tween"
	end

	local Folder

	local function v2855()
		for k, card in pairs(t111.cards) do
			pcall(function()
				card.part:Destroy()
			end)
			t111.cards[k] = nil
		end

		if Folder then
			pcall(function()
				Folder:Destroy()
			end)
			Folder = nil
		end
	end
	local function v2858()
		local CurrentCamera = workspace.CurrentCamera

		if not CurrentCamera then
			return
		end

		if not Folder or not Folder.Parent then
			Folder = Instance.new("Folder")
			Folder.Name = "SenaBloomEsp"
			Folder.Parent = CurrentCamera
		end

		local v2860 = t111.tiers() or {}
		local v2861 = v2693()
		local t125 = {}

		for _, v in ipairs(v2741()) do
			local v2865 = ("%d_%d_%d"):format(v.pos.X, v.pos.Y, v.pos.Z)

			t125[v2865] = true

			local v2866 = t111.cards[v2865]

			if not v2866 or not v2866.part.Parent then
				local Part = Instance.new("Part")

				Part.Size = Vector3.new(0.2, 0.2, 0.2)
				Part.Anchored = true
				Part.CanCollide = false
				Part.CanQuery = false
				Part.CanTouch = false
				Part.Transparency = 1
				Part.Parent = Folder

				local BillboardGui = Instance.new("BillboardGui")

				BillboardGui.Adornee = Part
				BillboardGui.Size = UDim2.fromOffset(120, 20)
				BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 1.6, 0)
				BillboardGui.AlwaysOnTop = true
				BillboardGui.MaxDistance = 260
				BillboardGui.Parent = Part

				local TextLabel = Instance.new("TextLabel")

				TextLabel.Size = UDim2.fromScale(1, 1)
				TextLabel.BackgroundTransparency = 1
				TextLabel.Font = Enum.Font.GothamBold
				TextLabel.TextSize = 13
				TextLabel.TextStrokeTransparency = 0.35
				TextLabel.Parent = BillboardGui
				v2866 = {
					part = Part,
					label = TextLabel
				}
				t111.cards[v2865] = v2866
			end

			v2866.part.CFrame = cFrameNew(v.pos)

			local v2870 = v2860[v.tier]

			v2866.label.TextColor3 = v2870 and v2870.color or Color3.new(1, 1, 1)

			local label = v2866.label
			local v2872 = v2861

			if v2872 then
				v2872 = ("%s  %dm"):format(v2870 and v2870.name or v.tier, math.floor((v.pos - v2861.Position).Magnitude))
			end

			label.Text = v2872 or v2870 and v2870.name or v.tier
		end

		for k, card in pairs(t111.cards) do
			if not t125[k] then
				pcall(function()
					card.part:Destroy()
				end)
				t111.cards[k] = nil
			end
		end
	end

	local t126

	t126 = {
		target = nil,
		since = 0,
		swinging = false,
		skip = setmetatable({}, {
			__mode = "k"
		}),
		pos = function(p727)
			if not p727 or not p727.Parent then
				return nil
			end

			local ok, result = pcall(function()
				return p727.PrimaryPart and p727.PrimaryPart.Position or p727:GetPivot().Position
			end)
			local v2878 = ok and result or nil

			return v2878
		end,
		pick = function(p728)
			local ButterflyBloomSwarm = workspace:FindFirstChild("ButterflyBloomSwarm")

			if not ButterflyBloomSwarm then
				return nil
			end

			local v2880 = v2736()
			local now = os.clock()
			local v2882
			local v2883

			for _, child in ipairs(ButterflyBloomSwarm:GetChildren()) do
				if child:IsA("Model") and t113[child.Name] and (not v2880 or v2880[child.Name]) then
					if (t126.skip[child] or 0) <= now then
						local v2886 = t126.pos(child)

						if v2886 then
							local v2887 = (t113[child.Name] == 4 and 1000000 or 0) - (v2886 - p728).Magnitude

							if not v2883 or v2883 < v2887 then
								v2882 = child
								v2883 = v2887
							end
						end
					end
				end
			end

			return v2882
		end,
		gain = function()
			local ok, result = pcall(v2677().Save.Peek)
			local v2890 = ok and result and result.Butterflies and tonumber(result.Butterflies.TotalCaught)

			return v2890 and t111.bloomBase and math.max(0, v2890 - t111.bloomBase) or 0
		end
	}
	t126.swing = function(p729, p730)
		if t126.swinging then
			return
		end

		local v2891 = tonumber(v2682("SwingCooldownSeconds", 0.45)) or 0.45

		if os.clock() - t111.lastSwing < v2891 then
			return
		end

		local v2892 = v2677()

		if not v2892 or not v2892.Swarm or not v2892.Swarm.Nearest then
			return
		end

		local ok, result = pcall(v2892.Swarm.Nearest, p730, Vector3.new(0, 0, -1), 4)
		local Flight = ok and result and result.Flight

		if not Flight or not Flight.Id then
			return
		end

		if Flight.Tier ~= nil and tostring(Flight.Tier) ~= p729.Name then
			return
		end

		t111.lastSwing = os.clock()
		t126.swinging = true
		task.spawn(function()
			local _, _, v2898 = v2687("Butterflies", "AskSwing", Flight.Id)

			t126.swinging = false

			if v2898 ~= "Caught" and v2898 ~= "Gone" then
				t126.skip[p729] = os.clock() + 1.5
			end

			if t126.target == p729 then
				t126.target = nil
			end

			local v2899 = t111.tiers()

			t111.status = ("%s %s  ·  +%d this Bloom"):format(v2898 == "Caught" and "Caught" or "Chasing", v2899 and v2899[p729.Name] and v2899[p729.Name].name or p729.Name, t126.gain())
		end)
	end
	t126.prepare = function()
		local Character = LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or not Humanoid then
			return nil
		end

		v2751()
		v215(Character)
		v33()
		v22()

		local AutoRotate = Humanoid.AutoRotate

		Humanoid.AutoRotate = false

		return Character, HumanoidRootPart, Humanoid, AutoRotate
	end
	t126.release = function(p731, p732, p733)
		t126.target = nil

		if p732.Parent and p733 ~= nil then
			p732.AutoRotate = p733
		end

		p731.AssemblyLinearVelocity = Vector3.zero
		p731.AssemblyAngularVelocity = Vector3.zero
		v23()
	end
	t126.keepGoing = function(p734, p735, p736)
		if not v16() or not senaV4Config.ButterflyAutoCatch or not (t111.bloomLeft() > 0) or not p734.Parent or not (p735.Health > 0) then
			return false
		end

		if (senaV4Config.ButterflyCatchMode or "Tween") == p736 then
			return not (t111.manual or v2767() or v177() or t114.blocker("butterfly") ~= nil)
		end

		return false
	end
	t126.moveStep = function(p737, p738, p739, p740, p741, p742, p743)
		v27(p737, p742 * t1.HEADROOM)

		local v2904 = v26()[t1.INTEGRITY_KEY]
		local State = type(v2904) == "table" and v2904.State or nil

		if not v30(State, p738, p739) then
			p739.AssemblyLinearVelocity = Vector3.zero
			p739.AssemblyAngularVelocity = Vector3.zero
			v21(p739.Position)

			if v29(State, p738, p739) then
				v28(State, p742 * t1.HEADROOM, Vector3.zero)
			else
				v31(p738, p739, p742)
			end

			return nil
		end

		local Position = p739.Position
		local v2907 = p740 - Position
		local v2908 = p742 * p743
		local v2909 = v2907.Magnitude <= v2908 and p740 or Position + v2907.Unit * v2908
		local v2910 = (p741 or p740) - v2909
		local vector32 = Vector3.new(v2910.X, 0, v2910.Z)

		if vector32.Magnitude <= 0.001 then
			vector32 = Vector3.new(v2907.X, 0, v2907.Z)
		end

		local Unit = vector32.Magnitude > 0.001 and vector32.Unit or p739.CFrame.LookVector
		local v2913 = (v2909 - Position) / p743

		v21(v2909)
		p739.CFrame = lookAt(v2909, v2909 + Unit)
		p739.AssemblyLinearVelocity = Vector3.zero
		p739.AssemblyAngularVelocity = Vector3.zero

		if not v32(p738, p739, p742, v2913) then
			v31(p738, p739, p742)
			v32(p738, p739, p742, v2913)
		end

		return v2909
	end
	t126.nearest = function(p744, p745)
		local ButterflyBloomSwarm = workspace:FindFirstChild("ButterflyBloomSwarm")

		if not ButterflyBloomSwarm then
			return nil
		end

		local v2915 = v2736()
		local now = os.clock()
		local v2917
		local v2918
		local v2919 = p745

		for _, child in ipairs(ButterflyBloomSwarm:GetChildren()) do
			if child:IsA("Model") and t113[child.Name] and (not v2915 or v2915[child.Name]) then
				if (t126.skip[child] or 0) <= now then
					local v2922 = t126.pos(child)
					local Magnitude = v2922 and (v2922 - p744).Magnitude

					if Magnitude and Magnitude <= v2919 then
						v2917 = child
						v2918 = v2922
						v2919 = Magnitude
					end
				end
			end
		end

		return v2917, v2918
	end
	t126.cluster = function(p746)
		local ButterflyBloomSwarm = workspace:FindFirstChild("ButterflyBloomSwarm")
		local t127 = {}
		local ipairs_ = ipairs
		local children = ButterflyBloomSwarm and ButterflyBloomSwarm:GetChildren() or {}

		for _, child in ipairs_(children) do
			if child:IsA("Model") and t113[child.Name] then
				local v2930 = t126.pos(child)

				if v2930 then
					t127[#t127 + 1] = v2930
				end
			end
		end

		if #t127 == 0 then
			return nil, 0, 0
		end

		local n53 = 0

		for _, v in ipairs(t127) do
			if p746 and (v - p746).Magnitude <= 24 then
				n53 += 1
			end
		end

		local v2934
		local v2935

		for _, v in ipairs(t127) do
			local vector32 = Vector3.zero
			local n54 = 0

			for _, v2 in ipairs(t127) do
				if (v - v2).Magnitude <= 24 then
					vector32 += v2
					n54 += 1
				end
			end

			local v2942 = vector32 / n54
			local v2943 = n54 * 100 - (p746 and (v2942 - p746).Magnitude or 0)

			if not v2935 or v2935 < v2943 then
				v2934 = v2942
				v2935 = v2943
			end
		end

		return v2934, #t127, n53
	end
	t126.route = function(p747, p748, p749)
		if p747 == "Circle" then
			local v2944 = p749 * 2.0833333333333335

			return p748 + Vector3.new(math.cos(v2944) * 24, 0, math.sin(v2944) * 24)
		end

		local v2945 = v2787()

		if not (p747 == "Zigzag" and v2945) then
			return p748
		end

		local v2946 = math.max(v2945.Size.X / 2 - 12, 20)
		local v2947 = math.clamp(v2945.Size.Z / 2 - 12, 8, 30)
		local v2948 = p749 * 80 / math.sqrt((2 * v2946 / 8) ^ 2 + (2 * v2947) ^ 2) % 16
		local v2949 = math.floor(v2948)
		local v2950 = v2948 - v2949
		local v2951 = v2949 <= 8 and v2949 or 16 - v2949
		local v2952 = v2949 + 1 <= 8 and v2949 + 1 or 16 - (v2949 + 1)
		local v2953 = -v2946 + v2951 * (2 * v2946 / 8)
		local v2954 = v2949 % 2 == 0 and -v2947 or v2947
		local v2955 = v2945.CFrame:VectorToWorldSpace(Vector3.new(v2953 + (-v2946 + v2952 * (2 * v2946 / 8) - v2953) * v2950, 0, v2954 + (((v2949 + 1) % 2 == 0 and -v2947 or v2947) - v2954) * v2950))

		return Vector3.new(v2945.Position.X + v2955.X, p748.Y, v2945.Position.Z + v2955.Z)
	end
	t126.patrol = function(p750)
		local v2956, v2957, v2958, v2959 = t126.prepare()

		if not v2956 then
			return false
		end

		local v2960 = tonumber(v2682("NetReach", 14)) or 14
		local v2961 = ({
			Stand = "Standing in the swarm",
			Zigzag = "Zigzag patrol",
			Circle = "Circling the swarm"
		})[p750] or p750
		local v2962
		local n55 = 0
		local now = os.clock()
		local v2965
		local v2966 = false
		local n56 = 0

		while t126.keepGoing(v2957, v2958, p750) do
			local v2968 = math.max(math.min(RunService.Heartbeat:Wait(), 0.15), 0.0041666666666666666)
			local now2 = os.clock()

			if n55 <= now2 then
				local v2970, v2971, v2972 = t126.cluster(v2962)

				n55 = now2 + 1.5

				if v2971 == 0 then
					v2965 = v2965 or now2
				else
					v2965 = nil

					if p750 == "Stand" then
						if not v2962 or v2972 < 3 then
							v2962 = v2970
						end
					else
						v2962 = v2962 and v2962:Lerp(v2970, 0.5) or v2970
					end
				end
			end

			if v2965 and now2 - v2965 > 2 then
				break
			end

			if v2962 then
				v2966 = true

				local v2973 = t126.route(p750, v2962, now2 - now)
				local huge = (v2973 - v2957.Position).Magnitude > 40 and math.huge or p750 == "Stand" and 60 or p750 == "Circle" and 70 or 110
				local v2975 = math.clamp(math.min(v20(), huge), t1.MIN_SPEED, t1.MAX_SPEED)
				local v2976, v2977 = t126.nearest(v2957.Position, v2960 + 6)
				local v2978 = t126.moveStep(v2956, v2958, v2957, v2973, v2977, v2975, v2968)

				if v2978 and v2976 and (v2977 - v2978).Magnitude <= v2960 - 1.5 then
					t126.swing(v2976, v2977)
				end

				if n56 <= now2 and not t126.swinging then
					n56 = now2 + 1
					t111.status = ("%s  ·  +%d this Bloom"):format(v2961, t126.gain())
				end
			else
				v2957.AssemblyLinearVelocity = Vector3.zero
				v2957.AssemblyAngularVelocity = Vector3.zero
				v21(v2957.Position)
			end
		end

		t126.release(v2957, v2958, v2959)

		return v2966
	end
	t126.run = function()
		local v2979, v2980, v2981, v2982 = t126.prepare()

		if not v2979 then
			return false
		end

		local v2983 = tonumber(v2682("NetReach", 14)) or 14
		local v2984 = math.min(v2983 - 3, (tonumber(v2682("DodgeRadius", 9)) or 9) + 1)
		local now
		local v2986 = false

		while t126.keepGoing(v2980, v2981, "Tween") do
			local v2987 = math.max(math.min(RunService.Heartbeat:Wait(), 0.15), 0.0041666666666666666)
			local target = t126.target
			local v2989 = t126.pos(target)

			if not v2989 or os.clock() - t126.since > 3 then
				if v2989 then
					t126.skip[target] = os.clock() + 2
				end

				target = t126.pick(v2980.Position)

				local now2 = os.clock()

				t126.target = target
				t126.since = now2
				v2989 = t126.pos(target)

				if target then
					local v2991 = t111.tiers()

					t111.status = ("Chasing %s  ·  +%d this Bloom"):format(v2991 and v2991[target.Name] and v2991[target.Name].name or target.Name, t126.gain())
				end
			end

			if v2989 then
				now = nil
				v2986 = true

				local v2992 = math.clamp(v20(), t1.MIN_SPEED, t1.MAX_SPEED)
				local v2993 = v2980.Position - v2989
				local v2994 = t126.moveStep(v2979, v2981, v2980, v2993.Magnitude > 0.001 and v2989 + v2993.Unit * v2984 or v2989 + Vector3.new(v2984, 0, 0), v2989, v2992, v2987)

				if v2994 and (v2989 - v2994).Magnitude <= v2983 - 1.5 then
					t126.swing(target, v2989)
				end

				continue
			else
				now = now or os.clock()

				if not (os.clock() - now > 2) then
					v2980.AssemblyLinearVelocity = Vector3.zero
					v2980.AssemblyAngularVelocity = Vector3.zero
					v21(v2980.Position)

					continue
				end
			end

			break
		end

		t126.release(v2980, v2981, v2982)

		return v2986
	end

	local function v2995(p751)
		if v2767() then
			v2777()

			return
		end

		if not v2789() then
			v2751()

			if v177() then
				t111.status = "Night - waiting to fly to the forest"

				return
			end

			if not v2691("area") then
				return
			end

			local v2996 = v2793()

			if not v2996 then
				t111.status = "Butterfly Bloom zone not found"
				v2692("area")

				return
			end

			t111.status = "Flying to the Butterfly Bloom"

			if not v2757(v2996, 60) then
				v2692("area")
				t111.status = "Could not reach the Enchanted Forest"
			end

			return
		end

		local __SenaV4TreadmillManager = genv.__SenaV4TreadmillManager

		if __SenaV4TreadmillManager and __SenaV4TreadmillManager.activeTreadmill ~= nil then
			v2795()
		end

		if not p751.holding and not v2746() then
			t111.status = "Butterfly Net is not in your backpack"

			return
		end

		local ButterflyCatchMode = senaV4Config.ButterflyCatchMode or "Tween"
		local v2999

		if ButterflyCatchMode == "Tween" then
			v2999 = t126.run()
		else
			v2999 = t126.patrol(ButterflyCatchMode)
		end

		if not v2999 then
			v2752()
			t111.status = ("Waiting for butterflies  ·  +%d this Bloom"):format(t126.gain())
		end
	end
	local function v3000(p752)
		if not p752.net then
			return p752.treeUnlocked and "No Butterfly Net yet" or "Enchanted Tree locked - finish the Wisp Event"
		end

		if p752.active then
			return "Bloom is live"
		end

		if p752.nextIn then
			return ("Next Bloom in %dm %02ds"):format(math.floor(p752.nextIn / 60), math.floor(p752.nextIn % 60))
		end

		return "Idle"
	end
	local function v3001()
		if t111.manual then
			return
		end

		local v3002 = t111.snapshot()

		if v3002.active then
			t111.bloomBase = t111.bloomBase or v3002.caught
		else
			t111.bloomBase = nil
		end

		if senaV4Config.ButterflyEsp and v3002.active then
			v2858()
		elseif next(t111.cards) or Folder then
			v2855()
		end

		local s7

		if senaV4Config.ButterflyAutoNet and not v3002.net and v3002.treeUnlocked and v2691("net") then
			s7 = "net"
		elseif senaV4Config.ButterflyAutoCatch and v3002.active and v3002.net then
			s7 = "catch"
		elseif not v3002.active and senaV4Config.ButterflyAutoTrade and v3002.net and t111.canTrade() and v2691("trade") then
			s7 = "trade"
		elseif not v3002.active and senaV4Config.ButterflyAutoCraft and v3002.net and t111.canCraft() and v2691("craft") then
			s7 = "craft"
		end

		t111.wantsCharacter = s7 ~= nil

		local butterfly = s7 and t114.blocker("butterfly") or nil
		local butterfly2 = s7 and not butterfly and t114.holder("butterfly") or nil
		local active = t111.active

		t111.active = s7 ~= nil and butterfly == nil and butterfly2 == nil

		if s7 and not t111.active then
			v2751()

			if butterfly and v2767() then
				t111.status = "Leaving the tree for " .. t114.TITLES[butterfly]
				v2777()
			end

			t111.status = butterfly and "Yielding to " .. t114.TITLES[butterfly] or "Waiting for " .. t114.TITLES[butterfly2] .. " to hand over"

			return
		end

		if not s7 then
			if active then
				v2801()
			end

			v2751()
			t111.status = v3000(v3002)

			return
		end

		if not active then
			v2795()
		end

		if s7 == "net" then
			local v3007, v3008 = t111.claimNet()
			local status = v3007 and "Butterfly Net claimed"

			if not status then
				status = "Net: " .. tostring(v3008 or "refused")
			end

			t111.status = status

			if not v3007 then
				v2692("net")
			end
		elseif s7 == "catch" then
			v2995(v3002)
		elseif s7 == "trade" then
			local status, v3011 = t111.tradeUp()

			if status then
				status = ("Traded up %d time(s)"):format(tonumber(v3011) or 0)
			end

			t111.status = status or "Trade: " .. tostring(v3011)
			v2692("trade")
		elseif s7 == "craft" then
			local status, v3013 = t111.craft()

			if status then
				status = ("Crafted %d Enchanted Essence"):format(tonumber(v3013) or 0)
			end

			t111.status = status or "Craft: " .. tostring(v3013)
			v2692("craft")
		end
	end

	task.spawn(function()
		while v16() do
			local ok, result = pcall(v3001)

			if not ok then
				t111.active = false
				t111.wantsCharacter = false
				v2751()
				t111.status = "Error: " .. tostring(result)
				task.wait(1)
			end

			task.wait(0.2)
		end

		v2751()
		v2855()
	end)
	genv.__SenaV4ButterflyRuntime = t111
end

v2666()

local function v3016()
	local u3017

	local function v3018()
		if u3017 then
			return u3017
		end

		local t128 = {}

		pcall(function()
			for _, child in ipairs(ReplicatedStorage.Data.Gears.Configs:GetChildren()) do
				local ok, result = pcall(require, child)

				if ok and type(result) == "table" and type(result.BatControllerData) == "table" then
					for _, v in ipairs({
						child.Name,
						result._id,
						result.DisplayName,
						result.ToolModel
					}) do
						if type(v) == "string" then
							t128[v:lower()] = true
						end
					end
				end
			end
		end)

		if next(t128) then
			u3017 = t128
		end

		return t128
	end
	local function v3026(p753)
		if not p753 or not p753:IsA("Tool") then
			return false
		end

		if p753:GetAttribute("IsBat") == true then
			return true
		end

		local attribute = p753:GetAttribute("ItemType")

		if attribute ~= nil and attribute ~= "Gear" then
			return false
		end

		local v3028 = v3018()
		local v3029 = tostring(p753:GetAttribute("GearName") or ""):lower()
		local v3030 = tostring(p753.Name or ""):gsub("%s*%[.-%]%s*$", ""):lower()

		if v3028[v3029] or v3028[v3030] then
			return true
		end

		return attribute == "Gear" and (v3029:find("bat", 1, true) ~= nil or v3030:find("bat", 1, true) ~= nil)
	end

	return v3026
end

genv.__SenaV4IsBatTool = v3016()

do
	local Players2 = game:GetService("Players")
	local RunService2 = game:GetService("RunService")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local LocalPlayer2 = Players2.LocalPlayer
	local t129 = {
		pinConn = nil,
		holding = false,
		status = "Idle"
	}

	local function v3036()
		local ok, result = pcall(require, ReplicatedStorage2.Client.EggState)

		return ok and result or nil
	end
	local function v3039()
		local ok, result = pcall(require, ReplicatedStorage2.Shared.Remotes)

		return ok and result or nil
	end
	local function v3042()
		local ok, result = pcall(require, ReplicatedStorage2.Shared.Types.AreaEggs)

		return ok and result and result.States or nil
	end
	local function v3045()
		local Character = LocalPlayer2.Character

		return Character and Character:FindFirstChild("HumanoidRootPart")
	end
	local function v3047()
		local Character = LocalPlayer2.Character

		return Character and Character:FindFirstChildOfClass("Humanoid")
	end
	local function v3049()
		return workspace:GetAttribute("Event_CaptureTheEggUid")
	end
	local function v3050(p754)
		if not p754 then
			return nil
		end

		local v3051 = v3036()

		if not v3051 then
			return nil
		end

		local ok, result = pcall(v3051.ReadFieldEgg, p754)

		return ok and result or nil
	end
	local function v3054(p755, p756)
		local v3055 = p756 or v3050(p755)
		local v3056 = v3042()

		if v3055 and v3056 then
			return v3055.State == v3056.Carried and v3055.CarrierUserId == LocalPlayer2.UserId
		end

		return false
	end
	local function v3057(p757)
		local v3058 = v3042()

		if p757 and v3058 then
			return p757.State == v3058.Slot or p757.State == v3058.Dropped
		end

		return false
	end
	local function v3059()
		local SenaCapturePlatform = workspace:FindFirstChild("SenaCapturePlatform")

		if SenaCapturePlatform then
			pcall(function()
				SenaCapturePlatform:Destroy()
			end)
		end
	end
	local function v3061(p758)
		local v3062 = p758 or v3045()

		if not v3062 then
			return
		end

		local SenaCapturePlatform = workspace:FindFirstChild("SenaCapturePlatform")

		if not SenaCapturePlatform then
			SenaCapturePlatform = Instance.new("Part")
			SenaCapturePlatform.Name = "SenaCapturePlatform"
			SenaCapturePlatform.Anchored = true
			SenaCapturePlatform.CanCollide = true
			SenaCapturePlatform.Size = Vector3.new(30, 1, 30)
			SenaCapturePlatform.Transparency = 0.5
			SenaCapturePlatform.Material = Enum.Material.Neon
			SenaCapturePlatform.Color = Color3.fromRGB(130, 90, 255)
			SenaCapturePlatform.TopSurface = Enum.SurfaceType.Smooth
			SenaCapturePlatform.BottomSurface = Enum.SurfaceType.Smooth
			SenaCapturePlatform.Parent = workspace
		end

		SenaCapturePlatform.CFrame = cFrameNew(v3062.Position.X, v3062.Position.Y - 3.4, v3062.Position.Z)
	end
	local function v3064()
		if t129.pinConn then
			return
		end

		t129.pinConn = RunService2.PreSimulation:Connect(function()
			if not senaV4Config.AutoStealCapture then
				return
			end

			local v3065 = v3045()

			if not v3065 then
				return
			end

			if v3065.Position.Y < 89 then
				v3065.CFrame = cFrameNew(v3065.Position.X, 90, v3065.Position.Z) * v3065.CFrame.Rotation
			end

			v3065.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v3065.AssemblyAngularVelocity = Vector3.zero
			v3061(v3065)
		end)
	end
	local function v3066()
		if t129.pinConn then
			pcall(function()
				t129.pinConn:Disconnect()
			end)
			t129.pinConn = nil
		end

		v3059()
	end
	local function v3067(p759, p760)
		local v3068 = v3045()
		local v3069 = v3047()

		if not v3068 or not v3069 or not p760 or not p760.BottomCFrame then
			return false
		end

		v3066()

		local v3070 = p760.BottomCFrame.Position + Vector3.new(0, 3, 0)

		t129.status = "Flying to capture egg"
		pcall(v232, v3068, v3069, cFrameNew(v3070) * v3068.CFrame.Rotation, function()
			return not senaV4Config.AutoStealCapture or v3049() ~= p759 or v3054(p759)
		end)

		local v3071 = v3045()

		if not v3071 then
			return false
		end

		pcall(function()
			v3071.AssemblyLinearVelocity = Vector3.zero
			v3071.AssemblyAngularVelocity = Vector3.zero
		end)

		local v3072 = v3039()

		if not v3072 or not v3072.EggWorld or not v3072.EggWorld.AskFieldEggCarry then
			return false
		end

		t129.status = "Grabbing capture egg"

		local ok, result = pcall(function()
			return v3072.EggWorld.AskFieldEggCarry:InvokeServer({
				Uid = p759
			})
		end)
		local v3075 = ok and result == true

		return v3075
	end

	task.spawn(function()
		while v16() do
			if senaV4Config.AutoStealCapture then
				if not pcall(function()
					local v3076 = v3049()
					local v3077 = v3050(v3076)

					if v3076 and v3054(v3076, v3077) then
						t129.holding = true
						t129.status = "Holding capture egg"
						v3064()
					elseif v3076 and v3057(v3077) then
						t129.holding = false
						v3067(v3076, v3077)
					elseif not v3076 then
						t129.holding = false

						if t129.pinConn or workspace:FindFirstChild("SenaCapturePlatform") then
							v3066()
						end

						t129.status = "No capture event"
					elseif t129.holding then
						v3064()
						t129.status = "Egg taken - holding position"
					else
						if t129.pinConn or workspace:FindFirstChild("SenaCapturePlatform") then
							v3066()
						end

						t129.status = "Waiting for capture egg"
					end
				end) then
					v3066()
				end

				task.wait(0.3)
			else
				if t129.pinConn or workspace:FindFirstChild("SenaCapturePlatform") then
					v3066()
				end

				t129.holding = false
				t129.status = "Idle"
				task.wait(0.5)
			end
		end
	end)
	genv.__SenaV4AutoCapture = t129
end

do
	local Players2 = game:GetService("Players")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local LocalPlayer2 = Players2.LocalPlayer

	local function v3081()
		local ok, result = pcall(require, ReplicatedStorage2.Shared.Save)

		return ok and result or nil
	end
	local function v3084()
		local ok, result = pcall(require, ReplicatedStorage2.Data.Assets)

		if ok then
			return result.Directory or result
		end

		return nil
	end
	local function v3087(p761)
		return "SENAVIS_" .. p761 .. "_" .. tostring(math.floor(os.clock() * 1000)) .. "_" .. tostring(math.random(1, 1000000))
	end

	local t130 = {
		held = {},
		categories = function(p762)
			local v3089 = v3084()
			local t131 = {}

			if not v3089 then
				return t131
			end

			for k, v in pairs(v3089) do
				if type(k) == "string" and type(v) == "table" and (p762 == "Pet" or v.Egg ~= nil) then
					t131[#t131 + 1] = k
				end
			end

			table.sort(t131)

			return t131
		end,
		spawnEgg = function(p763, p764)
			local v3093 = v3081()
			local v3094 = v3084()

			if not v3093 or not v3094 or not v3094[p763] then
				return nil
			end

			local v3095 = v3087("E")

			pcall(function()
				v3093.Amend("EggInventory", function(p765)
					p765[v3095] = {
						AssetCategory = p763,
						AssetScale = tonumber(p764) or 50,
						AssetColorIndex = 1,
						AssetColorSeed = math.random(1, 2e9),
						AssetEyeColor = "ffffff",
						HasParasite = false,
						Mutations = {}
					}
				end)
			end)

			return v3095
		end,
		spawnPet = function(p766, p767)
			local v3096 = v3081()
			local v3097 = v3084()

			if not v3096 or not v3097 or not v3097[p766] then
				return nil
			end

			local v3098 = v3087("P")

			pcall(function()
				v3096.Amend("Inventory", function(p768)
					p768[v3098] = {
						Category = p766,
						Scale = tonumber(p767) or 50,
						ColorIndex = 1,
						ColorSeed = math.random(1, 2e9),
						EyeColor = "ffffff",
						Gender = "Male",
						Personality = "Normal",
						InFuse = false,
						HasBeenFirstPlaced = false,
						Mutations = {}
					}
				end)
			end)

			return v3098
		end
	}

	local function v3099(p769)
		local Assets = ReplicatedStorage2:FindFirstChild("Assets")
		local Models = Assets and Assets:FindFirstChild("Models")
		local Eggs = Models and Models:FindFirstChild("Eggs")

		return Eggs and Eggs:FindFirstChild(p769)
	end
	local function v3103(p770)
		local AssetModels = ReplicatedStorage2:FindFirstChild("AssetModels")

		return AssetModels and AssetModels:FindFirstChild(p770)
	end
	local function v3105()
		for _, v in ipairs(t130.held) do
			pcall(function()
				v:Destroy()
			end)
		end

		t130.held = {}

		for _, v in ipairs({
			LocalPlayer2.Character,
			LocalPlayer2:FindFirstChild("Backpack")
		}) do
			if v then
				for _, child in ipairs(v:GetChildren()) do
					if child:IsA("Tool") then
						if child.Name:sub(1, 8) == "SENAVIS_" then
							pcall(function()
								child:Destroy()
							end)
						end
					end
				end
			end
		end
	end

	t130.hold = function(p771, p772, p773)
		local Character = LocalPlayer2.Character

		if not Character then
			return false
		end

		local v3113 = p772 and v3099(p771) or v3103(p771)

		if not v3113 then
			return false
		end

		local ok, result = pcall(function()
			return v3113:Clone()
		end)

		if not ok or not result or not result:IsA("Model") then
			return false
		end

		local PrimaryPart = result.PrimaryPart or result:FindFirstChildWhichIsA("BasePart")

		if not PrimaryPart then
			pcall(function()
				result:Destroy()
			end)

			return false
		end

		pcall(function()
			if not result.PrimaryPart then
				result.PrimaryPart = PrimaryPart
			end
		end)

		local v3117 = math.clamp(1 + (tonumber(p773) or 50) / 70, 1, 2.4) * (0.85 + math.random() * 0.4)

		pcall(function()
			if result.ScaleTo then
				result:ScaleTo(v3117)
			end
		end)

		local vector32 = Vector3.new(3, 3, 3)

		pcall(function()
			vector32 = result:GetExtentsSize()
		end)

		local Tool = Instance.new("Tool")

		Tool.Name = "SENAVIS_" .. p771
		Tool.RequiresHandle = true
		Tool.CanBeDropped = false

		local v3120 = v3084()
		local v3121 = v3120 and v3120[p771]
		local Icon = v3121 and (p772 and v3121.Egg and v3121.Egg.Icon or v3121.Icon)

		if type(Icon) == "string" then
			pcall(function()
				Tool.TextureId = Icon
			end)
		end

		PrimaryPart.Name = "Handle"

		for _, descendant in ipairs(result:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Massless = true
				descendant.CanCollide = false
				descendant.Anchored = false

				if descendant ~= PrimaryPart then
					local WeldConstraint = Instance.new("WeldConstraint")

					WeldConstraint.Part0 = PrimaryPart
					WeldConstraint.Part1 = descendant
					WeldConstraint.Parent = PrimaryPart
				end
			end
		end

		for _, child in ipairs(result:GetChildren()) do
			child.Parent = Tool
		end

		PrimaryPart.Parent = Tool
		pcall(function()
			result:Destroy()
		end)
		pcall(function()
			Tool.Grip = cFrameNew(0, -(vector32.Y * 0.55), math.max(vector32.X, vector32.Z) * 0.5 + 0.5)
		end)
		Tool.Parent = LocalPlayer2:FindFirstChild("Backpack") or Character

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			pcall(function()
				Humanoid:EquipTool(Tool)
			end)
		end

		t130.held[#t130.held + 1] = Tool

		return true
	end
	t130.spawn = function(p774, p775, p776, p777)
		if not p775 or p775 == "None" then
			return
		end

		local v3129 = tonumber(p776) or 50

		if p777 then
			pcall(t130.hold, p775, p774 ~= "Pet", v3129)
		elseif p774 == "Pet" then
			t130.spawnPet(p775, math.clamp(1 + v3129 / 25, 1.2, 5) * (0.85 + math.random() * 0.4))
		else
			t130.spawnEgg(p775, v3129 * (0.85 + math.random() * 0.5))
		end
	end
	t130.clear = function()
		local v3130 = v3081()

		if v3130 then
			pcall(function()
				v3130.Amend("EggInventory", function(p778)
					for k in pairs(p778) do
						if type(k) == "string" and k:sub(1, 8) == "SENAVIS_" then
							p778[k] = nil
						end
					end
				end)
			end)
			pcall(function()
				v3130.Amend("Inventory", function(p779)
					for k in pairs(p779) do
						if type(k) == "string" and k:sub(1, 8) == "SENAVIS_" then
							p779[k] = nil
						end
					end
				end)
			end)
			pcall(function()
				v3130.Amend("EquippedAssets", function(p780)
					for i = #p780, 1, -1 do
						local v3134 = p780[i]

						if type(v3134) == "string" and v3134:sub(1, 8) == "SENAVIS_" then
							table.remove(p780, i)
						end
					end
				end)
			end)
		end

		for _, v in ipairs(t130.held) do
			pcall(function()
				v:Destroy()
			end)
		end

		t130.held = {}

		for _, v in ipairs({
			LocalPlayer2.Character,
			LocalPlayer2:FindFirstChild("Backpack")
		}) do
			if v then
				for _, child in ipairs(v:GetChildren()) do
					if child:IsA("Tool") then
						if child.Name:sub(1, 8) == "SENAVIS_" then
							pcall(function()
								child:Destroy()
							end)
						end
					end
				end
			end
		end
	end
	genv.__SenaV4VisualSAE = t130
end

do
	local cameraMaxZoomDistance = (tonumber(game:GetService("StarterPlayer").CameraMaxZoomDistance) or 128) * 1.95

	local function v3142()
		if LocalPlayer.CameraMaxZoomDistance < cameraMaxZoomDistance then
			LocalPlayer.CameraMaxZoomDistance = cameraMaxZoomDistance
		end
	end

	pcall(v3142)
	LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
		if v16() then
			pcall(v3142)
		end
	end)
end

do
	local function v3143()
		local HttpService = game:GetService("HttpService")
		local t132 = {
			base = "http://56.10.112.179:8080/visual/",
			manifest = nil,
			status = "Idle",
			spawned = {},
			backs = {},
			backRod = nil,
			remote = {}
		}
		local Unit = Vector3.new(0.3, 0.75, 0.6).Unit
		local t133 = {
			RightShoulder = Angles(0.69813170079773179, 0, 0.17453292519943295),
			RightElbow = Angles(1.7453292519943295, 0, 0),
			RightWrist = cFrameNew(),
			LeftShoulder = cFrameNew(),
			LeftElbow = cFrameNew(),
			LeftWrist = cFrameNew()
		}
		local v3148 = cFrameNew(0.5, 1.3, 1, -0.7071, -0.7071, 0, -0.7071, 0.7071, 0, 0, 0, -1):Inverse()

		local function v3149(p781)
			local s8 = ""

			for match in string.gmatch(p781, "[^/]+") do
				s8 = s8 == "" and match or s8 .. "/" .. match

				if not isfolder(s8) then
					makefolder(s8)
				end
			end
		end
		local function v3152(p782)
			local ok, result = pcall(function()
				return game:HttpGet(p782, true)
			end)

			if not ok or type(result) ~= "string" or result == "" then
				return nil
			end

			return result
		end

		t132.loadManifest = function()
			if t132.manifest then
				return t132.manifest
			end

			v3149("SenaVisual/cache")

			local json = v3152(t132.base .. "manifest.json")

			if json then
				pcall(writefile, "SenaVisual/cache/manifest.json", json)
			elseif isfile("SenaVisual/cache/manifest.json") then
				json = readfile("SenaVisual/cache/manifest.json")
			end

			local ok, manifest = pcall(function()
				return HttpService:JSONDecode(json)
			end)

			if ok and type(manifest) == "table" then
				t132.manifest = manifest
			end

			return t132.manifest
		end
		t132.names = function(p783)
			local t134 = {}
			local v3159 = t132.loadManifest()
			local ipairs_ = ipairs
			local v3161 = v3159 and v3159[p783] or {}

			for _, v in ipairs_(v3161) do
				local name = v.name

				if v.tier then
					name = v.name .. " [" .. v.tier .. "]"
				end

				table.insert(t134, name)
			end

			return t134
		end

		local function v3165(p784, p785)
			local v3166 = t132.loadManifest()
			local ipairs_ = ipairs
			local v3168 = v3166 and v3166[p784] or {}

			for _, v in ipairs_(v3168) do
				if v.name == p785 or v.name .. " [" .. tostring(v.tier) .. "]" == p785 then
					return v
				end
			end

			return nil
		end
		local function v3171(p786, p787)
			local v3172 = "SenaVisual/cache" .. "/" .. p786

			v3149(v3172)

			local v3173 = v3172 .. "/" .. p787.file

			if not isfile(v3173) then
				t132.status = "Downloading " .. p787.name .. "..."

				local v3174 = v3152(t132.base .. p786 .. "/" .. p787.file)

				if not v3174 then
					return nil, "Download failed"
				end

				writefile(v3173, v3174)
			end

			local ok, result = pcall(function()
				return game:GetObjects(getcustomasset(v3173))
			end)

			if not ok or not (type(result) == "table" and result[1]) then
				pcall(delfile, v3173)

				return nil, "Could not load model"
			end

			return result[1]
		end

		t132.rodScale = 1
		t132.fishWeight = 0

		local function v3177(p788, p789, p790)
			local t135 = {}

			for _, descendant in ipairs(p788:GetDescendants()) do
				if descendant:IsA("JointInstance") or descendant:IsA("WeldConstraint") then
					descendant:Destroy()
				elseif descendant:IsA("BasePart") then
					table.insert(t135, descendant)
				elseif descendant:IsA("Script") or descendant:IsA("LocalScript") then
					descendant:Destroy()
				end
			end

			if #t135 == 0 then
				return nil
			end

			local Handle = p788:FindFirstChild("Handle", true)

			if not Handle or not Handle:IsA("BasePart") then
				Handle = t135[1]
			end

			if p789 or p790 and p790 ~= 1 then
				local boundingBox, v3183 = p788:GetBoundingBox()
				local v3184 = p790 or p789 / math.max(v3183.X, v3183.Y, v3183.Z, 0.01)

				if not p789 then
					boundingBox = Handle.CFrame
				end

				for _, v in ipairs(t135) do
					local v3187 = boundingBox:ToObjectSpace(v.CFrame)

					v.Size *= v3184
					v.CFrame = boundingBox * (cFrameNew(v3187.Position * v3184) * v3187.Rotation)
				end

				for _, descendant in ipairs(p788:GetDescendants()) do
					if descendant:IsA("Attachment") then
						if not descendant.Parent:IsA("Bone") then
							descendant.Position *= v3184
						end
					end
				end
			end

			for _, v in ipairs(t135) do
				v.Anchored = false
				v.CanCollide = false
				v.CanQuery = false
				v.CanTouch = false
				v.Massless = true

				if v ~= Handle then
					local Weld = Instance.new("Weld")

					Weld.Part0 = Handle
					Weld.Part1 = v
					Weld.C0 = Handle.CFrame:ToObjectSpace(v.CFrame)
					Weld.Parent = Handle
				end
			end

			Handle.Name = "Handle"

			return Handle, t135
		end
		local function v3193(p791, p792)
			local vector32 = Vector3.zero
			local vector33 = Vector3.zero

			for _, v in ipairs(p792) do
				if v ~= p791 and v.Transparency < 0.95 then
					local v3198 = v.Size / 2

					for _, v2 in ipairs({
						-1,
						1
					}) do
						for _, v3 in ipairs({
							-1,
							1
						}) do
							for _, v4 in ipairs({
								-1,
								1
							}) do
								local v3205 = p791.CFrame:PointToObjectSpace(v.CFrame:PointToWorldSpace(Vector3.new(v3198.X * v2, v3198.Y * v3, v3198.Z * v4)))

								vector32 = vector32:Min(v3205)
								vector33 = vector33:Max(v3205)
							end
						end
					end
				end
			end

			local v3206 = vector33 - vector32
			local vector34

			if v3206.Y <= v3206.X and v3206.Z <= v3206.X then
				vector34 = Vector3.new(vector33.X >= -vector32.X and 1 or -1, 0, 0)
			elseif v3206.Z <= v3206.Y then
				vector34 = Vector3.new(0, vector33.Y >= -vector32.Y and 1 or -1, 0)
			else
				vector34 = Vector3.new(0, 0, vector33.Z >= -vector32.Z and 1 or -1)
			end

			local vector35 = Vector3.xAxis

			if math.abs(vector34.X) > 0.5 then
				vector35 = v3206.Z >= v3206.Y and Vector3.zAxis or Vector3.yAxis
			elseif math.abs(vector34.Z) > 0.5 then
				vector35 = v3206.X >= v3206.Y and Vector3.xAxis or Vector3.yAxis
			end

			local v3209 = -math.min(vector32:Dot(vector34), vector33:Dot(vector34))

			return fromMatrix(Vector3.zero, vector35, vector34), math.max(0, v3209 - 0.6)
		end

		t132.updateBack = function()
			local Backpack = LocalPlayer:FindFirstChild("Backpack")

			for k, back in pairs(t132.backs) do
				back(k == t132.backRod and Backpack ~= nil and k.Parent == Backpack)
			end

			task.defer(t132.refreshQuality)
		end
		t132.refreshQuality = function()
			local v3213 = false
			local Character = LocalPlayer.Character

			if Character then
				for _, child in ipairs(Character:GetChildren()) do
					if child:IsA("Tool") and child:GetAttribute("SenaVisual") or child.Name == "SenaVisualBack" then
						v3213 = true

						break
					end
				end
			end

			if next(t132.remote) ~= nil then
				v3213 = true
			end

			pcall(function()
				if v3213 then
					settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
				elseif senaV4Config.StartupBoost then
					settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
				end
			end)
		end

		local function v3217(p793, p794, p795)
			local v3218 = Vector3.one * 1e9
			local v3219 = -Vector3.one * 1e9
			local v3220, v3221, v3222 = ipairs(p795)

			for _, v in v3220, v3221, v3222 do
				local v3225 = v.Size / 2

				for _, v2 in ipairs({
					-1,
					1
				}) do
					for _, v3 in ipairs({
						-1,
						1
					}) do
						for _, v4 in ipairs({
							-1,
							1
						}) do
							local v3232 = v.CFrame:PointToWorldSpace(Vector3.new(v3225.X * v2, v3225.Y * v3, v3225.Z * v4))

							v3218 = v3218:Min(v3232)
							v3219 = v3219:Max(v3232)
						end
					end
				end
			end

			local v3233 = v3219 - v3218
			local t136 = {}
			local n57 = 0
			local vector32 = Vector3.zero
			local v3237, v3238, v3239 = ipairs(p795)

			for _, v in v3237, v3238, v3239 do
				if v.Transparency < 0.95 then
					local v3242 = math.max(v.Size.X * v.Size.Y * v.Size.Z, 0.0001)
					local v3243 = v.Size / 2
					local huge = math.huge

					for _, v2 in ipairs({
						-1,
						1
					}) do
						for _, v3 in ipairs({
							-1,
							1
						}) do
							for _, v4 in ipairs({
								-1,
								1
							}) do
								huge = math.min(huge, v.CFrame:PointToWorldSpace(Vector3.new(v3243.X * v2, v3243.Y * v3, v3243.Z * v4)).Y)
							end
						end
					end

					table.insert(t136, {
						y = huge,
						vol = v3242
					})
					n57 += v3242
					vector32 += v.Position * v3242
				end
			end

			local v3251 = (v3218 + v3219) / 2 - Vector3.new(0, v3233.Y / 2, 0)

			if n57 > 0 then
				table.sort(t136, function(p796, p797)
					return p796.y < p797.y
				end)

				local n58 = 0
				local y = t136[1].y
				local v3254, v3255, v3256 = ipairs(t136)
				local v3257 = geniter(v3254, v3255, v3256)

				while true do
					local v3258 = table.pack(v3257())

					if v3258[1] then
						local v3259 = v3258[3]

						n58 += v3259.vol
						y = v3259.y

						if n57 * 0.1 <= n58 then
							break
						end
					else
						break
					end
				end

				local v3260 = vector32 / n57

				v3251 = Vector3.new(v3260.X, y, v3260.Z)
			end

			local function v3261(p798)
				for _, v in ipairs(p795) do
					if v.Transparency < 0.95 then
						local v3264 = v.CFrame:PointToObjectSpace(p798)
						local v3265 = v.Size / 2 + Vector3.new(0.6, 0.6, 0.6)

						if math.abs(v3264.X) <= v3265.X and math.abs(v3264.Y) <= v3265.Y and math.abs(v3264.Z) <= v3265.Z then
							return true
						end
					end
				end

				return false
			end

			local n59 = 0

			while true do
				if n59 < 150 then
					local v3267 = v3251 - Vector3.new(0, 1.6 + n59, 0)

					if v3261(v3267) or v3261(v3267 - Vector3.new(0, 1.8, 0)) then
						n59 += 1

						continue
					end

					break
				end

				break
			end

			local function v3268(p799)
				local vector33 = Vector3.new(p799.X, 0, p799.Z)

				return vector33.Magnitude > 0.05 and vector33.Unit or nil
			end

			local v3270
			local v3271, v3272, v3273 = ipairs(p795)
			local v3274 = geniter(v3271, v3272, v3273)

			while true do
				local v3275 = table.pack(v3274())

				if v3275[1] then
					local v3276 = v3275[3]

					if string.find(string.lower(v3276.Name), "eye", 1, true) then
						v3270 = v3268(v3276.Position - v3251)

						break
					end
				else
					break
				end
			end

			if not v3270 then
				local v3277, v3278, v3279 = ipairs(p793:GetDescendants())

				for _, v in v3277, v3278, v3279 do
					local v3282 = string.lower(v.Name)

					if not v:IsA("Attachment") or not v3282:find("head") and not v3282:find("eye") and not v3282:find("jaw") and not v3282:find("mouth") then
						continue
					end

					v3270 = v3268(v.WorldPosition - v3251)

					if v3270 then
						break
					end
				end
			end

			local vector33 = v3270 or v3268(p794.CFrame.LookVector) or Vector3.zAxis
			local t137 = {
				lift = n59,
				rootRel = cFrameNew(v3251):ToObjectSpace(p794.CFrame),
				turn = lookAt(Vector3.zero, vector33):Inverse()
			}

			return t137
		end
		local function v3285(p800, p801, p802, p803)
			local v3286, v3287 = v3171(p800, p801)

			if not v3286 then
				return nil, v3287
			end

			local v3288, v3289

			if p800 == "fish" then
				local v3290 = tonumber(p801.minKg)
				local v3291 = tonumber(p801.bigMaxKg) or tonumber(p801.maxKg)
				local n60 = 1

				if v3290 and v3290 > 0 and v3291 then
					n60 = math.max(1, (v3290 + (v3291 - v3290) * (p802 or 0)) / v3290)
				end

				if (tonumber(p801.nativeLen) or 0) > 50 then
					n60 *= 0.8
				end

				v3288, v3289 = v3177(v3286, nil, n60)
			else
				v3288, v3289 = v3177(v3286, nil, p803 or 1)
			end

			if not v3288 then
				v3286:Destroy()

				return nil, "Empty model"
			end

			v3288.Parent = v3286

			local t138 = {
				model = v3286,
				handle = v3288,
				kind = p800
			}

			if p800 == "fish" then
				t138.overhead = v3217(v3286, v3288, v3289)
				v3288.Name = "FishRoot"
			else
				local v3294, v3295 = v3193(v3288, v3289)

				t138.rodAxis = v3294
				t138.gripShift = v3295
				v3288.Name = "RodRoot"
			end

			return t138
		end
		local function v3296(p804)
			local clone = p804.model:Clone()

			clone.Name = "SenaVisualBack"

			for _, descendant in ipairs(clone:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.Size *= 0.8
				elseif descendant:IsA("Weld") then
					descendant.C0 = cFrameNew(descendant.C0.Position * 0.8) * descendant.C0.Rotation
				elseif descendant:IsA("Attachment") then
					if not descendant.Parent:IsA("Bone") then
						descendant.Position *= 0.8
					end
				end
			end

			return clone, clone:FindFirstChild("RodRoot", true)
		end
		local function createWeld(p805, p806, p807, p808)
			local UpperTorso = p805 and (p805:FindFirstChild("UpperTorso") or p805:FindFirstChild("Torso"))

			if not UpperTorso or not p807 then
				return nil
			end

			p806.Parent = p805

			local Weld = Instance.new("Weld")

			Weld.Part0 = UpperTorso
			Weld.Part1 = p807
			Weld.C0 = v3148 * cFrameNew(0, p808.gripShift * 0.8, 0) * p808.rodAxis:Inverse()
			Weld.Parent = p807

			return Weld
		end
		local function v3303(p809, p810, p811)
			local RightHand = p809 and p809:FindFirstChild("RightHand")
			local UpperTorso = p809 and p809:FindFirstChild("UpperTorso")

			if not RightHand or not UpperTorso then
				local function v3306()
				end

				return v3306
			end

			local t139 = {}

			for k, v in pairs(t133) do
				local v3310 = p809:FindFirstChild(k, true)

				if v3310 and v3310:IsA("Motor6D") then
					t139[v3310] = v
				end
			end

			local u3311 = true
			local Weld
			local connection = RunService.PreSimulation:Connect(function()
				for k, v in pairs(t139) do
					k.Transform = v
				end
			end)

			task.spawn(function()
				RunService.PostSimulation:Wait()
				RunService.PostSimulation:Wait()

				if not u3311 or not p810.Parent then
					return
				end

				local v3316 = UpperTorso.CFrame:PointToObjectSpace(RightHand.Position) + Vector3.new(0, 0, -0.1)
				local Unit2 = (Vector3.xAxis - Unit * Vector3.xAxis:Dot(Unit)).Unit

				Weld = Instance.new("Weld")
				Weld.Part0 = UpperTorso
				Weld.Part1 = p810
				Weld.C0 = fromMatrix(v3316, Unit2, Unit) * cFrameNew(0, p811.gripShift, 0) * p811.rodAxis:Inverse()
				Weld.Parent = p810
			end)

			local function v3318()
				u3311 = false
				connection:Disconnect()

				if Weld then
					Weld:Destroy()
				end
			end

			return v3318
		end
		local function v3319(p812, p813, p814)
			local Head = p812 and p812:FindFirstChild("Head")

			if not Head then
				local function v3321()
				end

				return v3321
			end

			local overhead = p814.overhead
			local Weld = Instance.new("Weld")

			Weld.Part0 = Head
			Weld.Part1 = p813
			Weld.C0 = cFrameNew(0, Head.Size.Y / 2 + 1 + overhead.lift, 0) * overhead.turn * overhead.rootRel
			Weld.Parent = p813

			local cFrame = Angles(3.1415926535897931, 0, 0)
			local RightShoulder = p812:FindFirstChild("RightShoulder", true)
			local LeftShoulder = p812:FindFirstChild("LeftShoulder", true)
			local RightElbow = p812:FindFirstChild("RightElbow", true)
			local LeftElbow = p812:FindFirstChild("LeftElbow", true)
			local connection = RunService.PreSimulation:Connect(function()
				if RightShoulder then
					RightShoulder.Transform = cFrame * Angles(0, 0, -0.20943951023931956)
				end

				if LeftShoulder then
					LeftShoulder.Transform = cFrame * Angles(0, 0, 0.20943951023931956)
				end

				if RightElbow then
					RightElbow.Transform = cFrameNew()
				end

				if LeftElbow then
					LeftElbow.Transform = cFrameNew()
				end
			end)

			local function v3330()
				connection:Disconnect()
				Weld:Destroy()
			end

			return v3330
		end
		local function createTool(p815, p816)
			local v3332, v3333 = v3285(p815, p816, t132.fishWeight, t132.rodScale)

			if not v3332 then
				return nil, v3333
			end

			local model = v3332.model
			local handle = v3332.handle
			local Tool = Instance.new("Tool")

			Tool.Name = p816.name
			Tool.CanBeDropped = false
			Tool.RequiresHandle = false
			Tool:SetAttribute("SenaVisual", p815)

			if p815 == "fish" then
				Tool:SetAttribute("ItemType", "Phone")
				Tool.ToolTip = tostring(p816.tier or "Fish")
			else
				Tool.ToolTip = "Rod"
			end

			if p816.icon then
				Tool.TextureId = p816.icon
			end

			local v3337
			local v3338

			if p815 == "rods" then
				v3337, v3338 = v3296(v3332)
			end

			for _, child in ipairs(model:GetChildren()) do
				child.Parent = Tool
			end

			model:Destroy()
			Tool.Equipped:Connect(function()
				task.defer(t132.refreshQuality)
			end)
			Tool.Unequipped:Connect(function()
				task.defer(t132.refreshQuality)
			end)

			local u3341

			if p815 == "rods" then
				local u3342

				t132.backs[Tool] = function(p817)
					local Character = LocalPlayer.Character

					if not p817 or not Character then
						v3337.Parent = nil
					elseif v3337.Parent ~= Character then
						if u3342 then
							u3342:Destroy()
						end

						u3342 = createWeld(Character, v3337, v3338, v3332)
					end
				end
				Tool.Destroying:Connect(function()
					t132.backs[Tool] = nil
					v3337:Destroy()
				end)
				Tool.Equipped:Connect(function()
					t132.backRod = Tool
					t132.updateBack()

					if u3341 then
						u3341()
					end

					u3341 = v3303(Tool.Parent, handle, v3332)
				end)
				Tool.Unequipped:Connect(function()
					if u3341 then
						u3341()
						u3341 = nil
					end

					t132.backRod = Tool
					task.defer(t132.updateBack)
				end)
			else
				Tool.Equipped:Connect(function()
					if u3341 then
						u3341()
					end

					u3341 = v3319(Tool.Parent, handle, v3332)
				end)
				Tool.Unequipped:Connect(function()
					if u3341 then
						u3341()
						u3341 = nil
					end
				end)
			end

			return Tool
		end

		t132.spawn = function(p818, p819)
			local v3344 = v3165(p818, p819)

			if not v3344 then
				t132.status = "Pick an item first"

				return false
			end

			local Backpack = LocalPlayer:FindFirstChild("Backpack")

			if not Backpack then
				t132.status = "Backpack not ready"

				return false
			end

			local v3346 = Backpack:FindFirstChild(v3344.name)

			if v3346 and v3346:GetAttribute("SenaVisual") then
				t132.status = v3344.name .. " is already in your backpack"

				return true
			end

			t132.status = "Loading " .. v3344.name .. "..."

			local v3347, v3348 = createTool(p818, v3344)

			if not v3347 then
				t132.status = v3344.name .. ": " .. tostring(v3348)

				return false
			end

			v3347.Parent = Backpack

			if p818 == "rods" then
				t132.backRod = v3347
				t132.updateBack()
			end

			t132.spawned[p818 .. "|" .. v3344.name] = {
				kind = p818,
				label = v3344.name
			}
			t132.status = v3344.name .. " added to your backpack"

			return true
		end
		t132.respawn = function(p820)
			local t140 = {}

			for k, v in pairs(t132.spawned) do
				if v.kind == p820 then
					t140[k] = v
				end
			end

			for _, v in pairs(t140) do
				local ipairs_ = ipairs
				local t141 = {
					LocalPlayer:FindFirstChild("Backpack"),
					LocalPlayer.Character
				}

				for _, v2 in ipairs_(t141) do
					local VLabel = v2 and v2:FindFirstChild(v.label)

					if VLabel and VLabel:IsA("Tool") and VLabel:GetAttribute("SenaVisual") then
						VLabel:Destroy()
					end
				end

				t132.spawn(v.kind, v.label)
			end
		end
		t132.clear = function()
			t132.spawned = {}

			local ipairs_ = ipairs
			local t142 = {
				LocalPlayer:FindFirstChild("Backpack"),
				LocalPlayer.Character
			}

			for _, v in ipairs_(t142) do
				if v then
					for _, child in ipairs(v:GetChildren()) do
						if child:IsA("Tool") and child:GetAttribute("SenaVisual") then
							child:Destroy()
						end
					end
				end
			end

			t132.status = "Removed all visual items"
			task.defer(t132.refreshQuality)
		end

		local function v3365(p821)
			local v3366 = t132.remote[p821]

			if not v3366 then
				return
			end

			t132.remote[p821] = nil

			for _, v in ipairs(v3366.cleanup) do
				pcall(v)
			end
		end
		local function v3369(p822)
			local v3370, v3371, v3372 = string.match(p822 or "", "^(%a+)|([^|]+)|?(.*)$")

			return v3370, v3371, tonumber(v3372)
		end
		local function v3373(p823, p824, p825)
			local playerByUserId = Players:GetPlayerByUserId(tonumber(p823) or 0)
			local Character = playerByUserId and playerByUserId.Character

			if not Character then
				v3365(p823)

				return
			end

			local v3376 = p824 .. "#" .. p825
			local v3377 = t132.remote[p823]

			if v3377 and v3377.key == v3376 and v3377.char == Character then
				return
			end

			v3365(p823)

			local t143 = {
				key = v3376,
				char = Character,
				cleanup = {}
			}

			t132.remote[p823] = t143

			local v3379, v3380, v3381 = v3369(p824)
			local v3382 = (v3379 == "rods" or v3379 == "fish") and v3165(v3379, v3380) or nil

			if v3382 then
				local v3383 = v3285(v3379, v3382, v3379 == "fish" and (v3381 or 0) or 0, v3379 == "rods" and (v3381 or 1) or 1)

				if v3383 and t132.remote[p823] == t143 and Character.Parent then
					v3383.model.Name = "SenaVisualRemote"
					v3383.model.Parent = Character
					table.insert(t143.cleanup, (v3379 == "rods" and v3303 or v3319)(Character, v3383.handle, v3383))
					table.insert(t143.cleanup, function()
						v3383.model:Destroy()
					end)
				elseif v3383 then
					v3383.model:Destroy()
				end
			end

			local v3384, v3385 = v3369(p825)
			local v3386 = v3384 == "rods" and v3165("rods", v3385) or nil

			if v3386 and t132.remote[p823] == t143 then
				local v3387 = v3285("rods", v3386, 0, 1)

				if v3387 and t132.remote[p823] == t143 and Character.Parent then
					local v3388, v3389 = v3296(v3387)

					v3387.model:Destroy()
					createWeld(Character, v3388, v3389, v3387)
					table.insert(t143.cleanup, function()
						v3388:Destroy()
					end)
				elseif v3387 then
					v3387.model:Destroy()
				end
			end

			task.defer(t132.refreshQuality)
		end

		task.spawn(function()
			while v16() do
				local n61 = 6

				pcall(function()
					if #Players:GetPlayers() <= 1 then
						for k in pairs(t132.remote) do
							v3365(k)
						end

						return
					end

					local SenaBackend = genv.SenaBackend or {}
					local Api = SenaBackend.Api or "http://56.10.112.179:8080"
					local s9 = ""
					local s10 = ""
					local Character = LocalPlayer.Character

					if Character then
						for _, child in ipairs(Character:GetChildren()) do
							local attribute = child:IsA("Tool") and child:GetAttribute("SenaVisual")

							if attribute then
								s9 = attribute .. "|" .. child.Name .. "|" .. tostring(attribute == "fish" and t132.fishWeight or t132.rodScale)

								break
							end
						end

						if Character:FindFirstChild("SenaVisualBack") and t132.backRod then
							s10 = "rods|" .. t132.backRod.Name
						end
					end

					local data = HttpService:JSONDecode(game:HttpGet(string.format("%s/vstate?key=%s&job=%s&uid=%d&held=%s&back=%s", Api, HttpService:UrlEncode(SenaBackend.Key or "sena_20VvixjHsd1OPPwgHYJAstpM"), HttpService:UrlEncode(game.JobId), LocalPlayer.UserId, HttpService:UrlEncode(s9), HttpService:UrlEncode(s10)), true))

					if type(data) ~= "table" or data.ok ~= true then
						return
					end

					n61 = tonumber(data.poll) or 4

					local t144 = {}
					local pairs_ = pairs
					local players = data.players or {}

					for k, player in pairs_(players) do
						local v3406 = tostring(k)

						t144[v3406] = true
						v3373(v3406, tostring(player.held or ""), tostring(player.back or ""))
					end

					for k in pairs(t132.remote) do
						if not t144[k] then
							v3365(k)
						end
					end
				end)
				task.wait(n61)
			end

			for k in pairs(t132.remote) do
				v3365(k)
			end
		end)
		LocalPlayer.CharacterAdded:Connect(function()
			if not v16() then
				return
			end

			task.wait(1.5)

			for _, v in pairs(t132.spawned) do
				pcall(t132.spawn, v.kind, v.label)
			end
		end)

		return t132
	end

	genv.__SenaV4Visual = v3143()
end

do
	local HttpService = game:GetService("HttpService")
	local t145 = {
		hopFailed = false,
		lastHopAt = 0
	}

	pcall(function()
		TeleportService.TeleportInitFailed:Connect(function(p826)
			if p826 == LocalPlayer then
				t145.hopFailed = true
			end
		end)
	end)
	t145.collectServers = function(p827)
		local t146 = {}
		local s11 = ""

		for i = 1, 3 do
			local ok, result = pcall(function()
				local v3418 = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"):format(game.PlaceId)

				if s11 ~= "" then
					v3418 ..= "&cursor=" .. s11
				end

				return HttpService:JSONDecode(game:HttpGet(v3418))
			end)

			if ok and type(result) == "table" then
				local ipairs_ = ipairs
				local data = result.data or {}

				for _, v in ipairs_(data) do
					if tostring(v.id) ~= game.JobId and v.playing and v.maxPlayers and v.playing < v.maxPlayers and (not p827 or v.playing <= p827) then
						t146[#t146 + 1] = {
							id = tostring(v.id),
							playing = v.playing
						}
					end
				end

				s11 = result.nextPageCursor or ""

				if s11 ~= "" then
					continue
				end
			end

			break
		end

		table.sort(t146, function(p828, p829)
			return p828.playing < p829.playing
		end)

		return t146
	end
	t145.hopToList = function(p830)
		if type(p830) ~= "table" or #p830 == 0 then
			return false
		end

		for _, v in ipairs(p830) do
			t145.hopFailed = false

			if pcall(function()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
			end) then
				local now = os.clock()

				while not t145.hopFailed and os.clock() - now < 6 do
					task.wait(0.25)
				end

				if not t145.hopFailed then
					return true
				end
			end

			task.wait(0.3)
		end

		return false
	end
	t145.hopEmptiest = function()
		return t145.hopToList(t145.collectServers(nil))
	end
	t145.privateStatus = "Pick a max player count, then Hop Server Now."
	t145.privateMax = function()
		return math.max(1, math.floor(tonumber(tostring(senaV4Config.PrivateServerMax or "2"):match("%d+")) or 2))
	end
	t145.findPrivateTargets = function()
		local v3426 = t145.privateMax()
		local v3427 = t145.collectServers(nil)

		if #v3427 == 0 then
			return nil
		end

		local t147 = {}

		for _, v in ipairs(v3427) do
			if v.playing + 1 <= v3426 then
				t147[#t147 + 1] = v
			end
		end

		local v3431 = t147

		if #v3431 == 0 then
			local playing = v3427[1].playing

			for _, v in ipairs(v3427) do
				if v.playing == playing then
					v3431[#v3431 + 1] = v
				end
			end
		end

		local t148 = {}

		while #v3431 > 0 and #t148 < 5 do
			t148[#t148 + 1] = table.remove(v3431, math.random(1, #v3431))
		end

		return t148
	end
	t145.hopPrivateOnce = function()
		local v3436 = t145.privateMax()
		local v3437 = #Players:GetPlayers()

		if v3437 <= v3436 then
			t145.privateStatus = "This server is good (" .. v3437 .. " player(s), max " .. v3436 .. ")."

			return false
		end

		if t145.hubBusy() then
			t145.privateStatus = "Waiting until you finish stealing..."

			return false
		end

		t145.privateStatus = "Searching for a quieter server..."

		local v3438 = t145.findPrivateTargets()

		if not v3438 or #v3438 == 0 then
			t145.privateStatus = "Could not load the server list. Try again."

			return false
		end

		t145.privateStatus = "Teleporting..."
		t145.lastHopAt = os.clock()

		if t145.hopToList(v3438) then
			return true
		end

		t145.privateStatus = "Teleport failed. Trying again soon."

		return false
	end
	t145.startPrivateAutoHop = function()
		if t145.privateAutoRunning then
			return
		end

		t145.privateAutoRunning = true
		task.spawn(function()
			while v16() and senaV4Config.PrivateServerAuto do
				local v3439 = t145.privateMax()

				if v3439 >= #Players:GetPlayers() then
					t145.privateStatus = "Good server found. Waiting..."
					task.wait(3)
				else
					t145.hopPrivateOnce()
					task.wait(5)
				end
			end

			t145.privateAutoRunning = false

			if not senaV4Config.PrivateServerAuto then
				t145.privateStatus = "Auto hop stopped."
			end
		end)
	end

	local function hubBusy()
		if senaV4Config.IsStealing or senaV4Config.IsPlacing then
			return true
		end

		local __SenaV4EggRuntime = genv.__SenaV4EggRuntime

		if __SenaV4EggRuntime and (__SenaV4EggRuntime.running or __SenaV4EggRuntime.travelBusy or __SenaV4EggRuntime.carry and __SenaV4EggRuntime.carry.active) then
			return true
		end

		local __SenaV4PlayerSteal = genv.__SenaV4PlayerSteal

		if __SenaV4PlayerSteal and __SenaV4PlayerSteal.running then
			return true
		end

		return false
	end

	t145.hubBusy = hubBusy
	t145.startHopLoop = function()
		if t145.hopLoopRunning then
			return
		end

		t145.hopLoopRunning = true
		task.spawn(function()
			while v16() do
				task.wait(2)

				if senaV4Config.HopNoMatch and not t145.hubBusy() then
					if (tonumber(senaV4Config.HopCooldown) or 5) < os.clock() - t145.lastHopAt then
						local __SenaV4EggRuntime = genv.__SenaV4EggRuntime

						if senaV4Config.AutoSteal and (__SenaV4EggRuntime and __SenaV4EggRuntime.stats and __SenaV4EggRuntime.stats.matching or 0) <= 0 and not v177() then
							t145.lastHopAt = os.clock()
							t145.hopEmptiest()
						end
					end
				end
			end

			t145.hopLoopRunning = false
		end)
	end
	t145.startAntiTreadmillLoop = function()
		if t145.antiTreadmillRunning then
			return
		end

		t145.antiTreadmillRunning = true
		task.spawn(function()
			while v16() do
				if senaV4Config.AntiTreadmill then
					local __SenaV4TreadmillManager = genv.__SenaV4TreadmillManager

					pcall(function()
						if __SenaV4TreadmillManager and __SenaV4TreadmillManager.activeTreadmill ~= nil then
							__SenaV4TreadmillManager:_cancelIdle(true)
							__SenaV4TreadmillManager:_requestUnequip()
						end
					end)

					local Character = LocalPlayer.Character
					local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

					if HumanoidRootPart and HumanoidRootPart.Anchored then
						pcall(function()
							HumanoidRootPart.Anchored = false
						end)
					end
				end

				task.wait(0.3)
			end

			t145.antiTreadmillRunning = false
		end)
	end
	t145.setBackpackRates = function(p831)
		senaV4Config.BackpackRateEsp = p831 == true

		if not t145.backpackRatesRunning then
			t145.backpackRatesRunning = true
			task.spawn(function()
				local EggRecords
				local Save

				pcall(function()
					EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
					Save = require(ReplicatedStorage.Shared.Save)
				end)

				while v16() do
					local ScrollingFrame

					pcall(function()
						ScrollingFrame = LocalPlayer.PlayerGui.BackpackGui.Backpack.Main.Inventory.ScrollingFrame
					end)

					local __SenaV4Webhook = genv.__SenaV4Webhook
					local SenaDiscord = ScrollingFrame and ScrollingFrame.Parent:FindFirstChild("SenaDiscord")

					if ScrollingFrame and senaV4Config.BackpackRateEsp and not SenaDiscord then
						local TextLabel = Instance.new("TextLabel")

						TextLabel.Name = "SenaDiscord"
						TextLabel.BackgroundTransparency = 1
						TextLabel.Position = UDim2.new(0.34, 0, 0.017, 0)
						TextLabel.Size = UDim2.new(0.3, 0, 0.09, 0)
						TextLabel.Font = Enum.Font.GothamBlack
						TextLabel.Text = "discord.gg/senahub"
						TextLabel.TextScaled = true
						TextLabel.TextXAlignment = Enum.TextXAlignment.Left
						TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						TextLabel.TextStrokeTransparency = 0
						TextLabel.ZIndex = 40
						TextLabel.Parent = ScrollingFrame.Parent
					elseif SenaDiscord and not senaV4Config.BackpackRateEsp then
						SenaDiscord:Destroy()
					end

					if ScrollingFrame then
						local t149 = {}

						if senaV4Config.BackpackRateEsp and EggRecords and Save and __SenaV4Webhook then
							local v3454 = (Save.Peek or Save.Get)()
							local pairs_ = pairs
							local EggInventory = v3454 and v3454.EggInventory or {}

							for _, v in pairs_(EggInventory) do
								local ok, result = pcall(EggRecords.DisplayNameWithWeight, v)

								if ok and type(result) == "string" then
									t149[result] = t149[result] or {}
									table.insert(t149[result], v)
								end
							end
						end

						local t150 = {}

						for _, child in ipairs(ScrollingFrame:GetChildren()) do
							local ToolName = child:IsA("GuiButton") and child:FindFirstChild("ToolName")

							if ToolName then
								local Text = ToolName.Text
								local v3466 = (t150[Text] or 0) + 1
								local v3467 = t149[Text] and t149[Text][v3466]
								local SenaRate = child:FindFirstChild("SenaRate")

								if v3467 then
									t150[Text] = v3466

									if not SenaRate then
										SenaRate = Instance.new("TextLabel")
										SenaRate.Name = "SenaRate"
										SenaRate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
										SenaRate.BackgroundTransparency = 0.35
										SenaRate.BorderSizePixel = 0
										SenaRate.Position = UDim2.new(0.04, 0, 0, 3)
										SenaRate.Size = UDim2.new(0.92, 0, 0.24, 0)
										SenaRate.Font = Enum.Font.GothamBlack
										SenaRate.TextScaled = true
										SenaRate.TextColor3 = Color3.fromRGB(73, 211, 31)
										SenaRate.TextStrokeTransparency = 0
										SenaRate.ZIndex = 40

										local UICorner = Instance.new("UICorner")

										UICorner.CornerRadius = UDim.new(0, 6)
										UICorner.Parent = SenaRate

										local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

										UITextSizeConstraint.MaxTextSize = 20
										UITextSizeConstraint.Parent = SenaRate
										SenaRate.Parent = child
									end

									SenaRate.Text = __SenaV4Webhook.compact(__SenaV4Webhook.rateOf(v3467)) .. "/s"
								elseif SenaRate then
									SenaRate:Destroy()
								end
							end
						end
					end

					if not senaV4Config.BackpackRateEsp then
						break
					end

					task.wait(1)
				end

				t145.backpackRatesRunning = false
			end)

			return
		end
	end

	local function v3471()
		local t151 = {
			status = "Disabled",
			banner = "Unknown",
			rotation = 0,
			pity = 0,
			pityMax = 100,
			free = 0,
			trades = 0,
			demands = "-",
			stock = "-",
			ready = 0,
			total = 3,
			missing = "None",
			cache = nil,
			cacheAt = 0,
			lastReroll = 0
		}
		local Directory
		local AssetItems
		local AssetEarnings
		local Save

		pcall(function()
			Directory = require(ReplicatedStorage.Data.Assets).Directory
		end)
		pcall(function()
			AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
		end)
		pcall(function()
			AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)
		end)
		pcall(function()
			Save = require(ReplicatedStorage.Shared.Save)
		end)

		local function v3477()
			local ok, result = pcall(function()
				return require(ReplicatedStorage.Shared.Remotes).ScrambleTradeIn
			end)
			local v3480 = ok and result or nil

			return v3480
		end
		local function v3481()
			return senaV4Config.ScrambleTradeInTrade or senaV4Config.ScrambleTradeInReroll
		end
		local function v3482(p832)
			return ((tostring(p832 or ""):lower():match("^%s*(.-)%s*$") or ""):gsub("%s*egg$", ""))
		end
		local function matches(p833, p834)
			local v3484 = v3482(p833)
			local v3485 = v3482(p834)

			if v3484 == "" or v3485 == "" then
				return false
			end

			if v3484 == v3485 then
				return true
			end

			if not Directory or Directory[p833] then
				return false
			end

			local v3486 = Directory[p834]

			return type(v3486) == "table" and type(v3486.DisplayName) == "string" and v3482(v3486.DisplayName) == v3484
		end

		t151.matches = matches

		local function v3487(p835)
			local v3488 = Directory and Directory[p835]
			local DisplayName = type(v3488) == "table" and v3488.DisplayName

			return type(DisplayName) == "string" and DisplayName ~= "" and DisplayName or tostring(p835)
		end
		local function v3490(p836, p837)
			local t152 = {}

			for i, v in ipairs(p836) do
				t152[i] = v3487(v)
			end

			return table.concat(t152, p837)
		end

		t151.state = function(p838)
			local now = os.clock()

			if not p838 and t151.cache and now - t151.cacheAt < 2.5 then
				return t151.cache
			end

			local v3495 = v3477()

			if not v3495 or not v3495.AskState then
				return t151.cache
			end

			local ok, cache = pcall(function()
				return v3495.AskState:InvokeServer()
			end)

			if ok and type(cache) == "table" then
				t151.cache = cache
				t151.cacheAt = now
			end

			return t151.cache
		end

		local function v3498(p839)
			local ScrambleTradeInBanners = senaV4Config.ScrambleTradeInBanners

			if type(ScrambleTradeInBanners) ~= "table" or #ScrambleTradeInBanners == 0 then
				return true
			end

			if not p839 or not p839.BannerId then
				return true
			end

			local v3500 = v3482(p839.BannerId)
			local v3501 = v3482(p839.BannerDisplayName)

			for _, ScrambleTradeInBanner in ipairs(ScrambleTradeInBanners) do
				local v3504 = v3482(ScrambleTradeInBanner)

				if v3504 == v3500 or v3501 ~= "" and v3504 == v3501 then
					return true
				end
			end

			return false
		end
		local function v3505(p840)
			return p840 and type(p840.Requirements) == "table" and p840.Requirements or {}
		end
		local function v3506()
			local u3507

			if Save then
				pcall(function()
					u3507 = (Save.Peek or Save.Get)()
				end)
			end

			return u3507
		end
		local function v3508(p841)
			local t153 = {}

			if not p841 or not AssetItems then
				return t153
			end

			local t154 = {}
			local ipairs_ = ipairs
			local EquippedAssets = p841.EquippedAssets or {}

			for _, EquippedAsset in ipairs_(EquippedAssets) do
				t154[EquippedAsset] = true
			end

			local t155 = {}

			pcall(function()
				for k in pairs(require(ReplicatedStorage.Client.AssetRoster).ReadOwnerPen(LocalPlayer.UserId)) do
					t155[k] = true
				end
			end)

			local pairs_ = pairs
			local Inventory = p841.Inventory or {}

			for k, v in pairs_(Inventory) do
				local ok, result = pcall(AssetItems.Decode, v)

				if ok and type(result) == "table" and result.Category and not result.IsFavorite and not result.InFuse and not t154[k] and not t155[k] then
					local huge = math.huge

					if AssetEarnings then
						local ok2, result2 = pcall(AssetEarnings.LiveRatePerSecond, {
							Category = result.Category,
							Scale = math.max(tonumber(result.Scale) or 1, 0.01),
							Mutations = type(result.Mutations) == "table" and result.Mutations or {}
						}, p841.Gamepasses, p841.Products)

						if ok2 and type(result2) == "number" then
							huge = result2
						end
					end

					t153[#t153 + 1] = {
						uid = k,
						category = result.Category,
						rate = huge
					}
				end
			end

			table.sort(t153, function(p842, p843)
				if p842.rate == p843.rate then
					return tostring(p842.uid) < tostring(p843.uid)
				end

				return p842.rate < p843.rate
			end)

			return t153
		end
		local function selectPets(p844, p845)
			local v3527 = v3508(p845)
			local t156 = {}
			local t157 = {}
			local t158 = {}

			for i, v in ipairs(p844) do
				local v3533

				for _, v2 in ipairs(v3527) do
					if not t156[v2.uid] and matches(v2.category, v) then
						v3533 = v2

						break
					end
				end

				if v3533 then
					t156[v3533.uid] = true
					t157[i] = v3533
				else
					t158[#t158 + 1] = v
				end
			end

			return t157, t158, v3527
		end

		t151.selectPets = selectPets

		local function v3536(p846, p847, p848)
			local t159 = {}
			local t160 = {}

			for _, v in ipairs(p846) do
				if not t159[v] then
					t160[#t160 + 1] = v
				end

				t159[v] = (t159[v] or 0) + 1
			end

			local t161 = {}

			for _, v in ipairs(t160) do
				local n62 = 0

				for _, v2 in ipairs(p848) do
					if matches(v2.category, v) then
						n62 += 1
					end
				end

				local pairs_ = pairs
				local EggInventory = p847 and p847.EggInventory or {}

				for _, v2 in pairs_(EggInventory) do
					if type(v2) == "table" and matches(v2.AssetCategory, v) then
						n62 += 1
					end
				end

				t161[#t161 + 1] = string.format("%s %d/%d", v3487(v), math.min(n62, t159[v]), t159[v])
			end

			return table.concat(t161, "  ")
		end
		local function teleport()
			local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				return false
			end

			local v3553 = v14()
			local Machines = v3553 and v3553:FindFirstChild("Machines")
			local RiftMachine = Machines and Machines:FindFirstChild("RiftMachine")
			local Machine = RiftMachine and RiftMachine:FindFirstChild("Machine")

			HumanoidRootPart.CFrame = Machine and Machine:IsA("BasePart") and Machine.CFrame * cFrameNew(0, Machine.Size.Y * 0.5 + 3, 4) or cFrameNew(533.4, 72, -330)
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero

			return true
		end

		t151.teleport = teleport
		t151.openUI = function()
			return (pcall(function()
				require(ReplicatedStorage.Client.Tabs).Activate("DrScrambleTradeIn")
			end))
		end

		local function v3557(p849, p850)
			local v3558 = v3477()

			if not v3558 or not v3558.AskTradeIn then
				return false, "Trade remote unavailable"
			end

			local t162 = {}

			for i = 1, #p849 do
				local v3561 = p850[i]

				if v3561 then
					t162[#t162 + 1] = v3561.uid

					continue
				end

				return false, "Requirements incomplete"
			end

			t151.status = "Trading pets into Dr Scramble"

			local ok, result = pcall(function()
				return v3558.AskTradeIn:InvokeServer(t162)
			end)

			if (not ok or result == false) and teleport() then
				task.wait(0.3)
				ok, result = pcall(function()
					return v3558.AskTradeIn:InvokeServer(t162)
				end)
			end

			if not ok or result == false then
				local v3564 = false
				local tostring_ = tostring
				local v3566 = result or "Trade rejected"

				return v3564, tostring_(v3566)
			end

			pcall(function()
				if v3558.AskFinishReveal then
					v3558.AskFinishReveal:InvokeServer()
				end
			end)
			t151.trades += 1
			t151.state(true)

			return true
		end

		t151.tradeOnce = function()
			local v3567 = v3505(t151.state(true))

			if #v3567 < 3 then
				return false, "Cannot read the recipe"
			end

			local v3568, v3569 = selectPets(v3567, v3506())

			if #v3569 > 0 then
				return false, "Missing: " .. v3490(v3569, ", ")
			end

			return v3557(v3567, v3568)
		end
		t151.reroll = function()
			local v3570 = t151.state(false)

			if (tonumber(v3570 and v3570.FreeRefreshesRemaining) or 0) <= 0 then
				return false, "No free rerolls left"
			end

			local v3571 = v3477()

			if not v3571 or not v3571.AskRefresh then
				return false, "Refresh remote unavailable"
			end

			if not pcall(function()
				return v3571.AskRefresh:InvokeServer()
			end) then
				return false, "Reroll failed"
			end

			t151.state(true)

			return true
		end
		t151.tick = function()
			local v3572 = t151.state(false)

			if not v3572 then
				t151.status = "Trade-In state unavailable"

				return
			end

			if v3572.Unlocked == false then
				t151.status = "Dr Scramble Trade-In is locked"

				return
			end

			t151.banner = tostring(v3572.BannerDisplayName or v3572.BannerId or "Unknown")
			t151.rotation = math.max(0, math.floor(tonumber(v3572.SecondsUntilRotation) or 0))
			t151.pity = tonumber(v3572.PityCount) or 0
			t151.pityMax = tonumber(v3572.PityThreshold) or 100
			t151.free = tonumber(v3572.FreeRefreshesRemaining) or 0

			if v3572.PendingReward then
				t151.status = "Finishing reward"

				local v3573 = v3477()

				pcall(function()
					if v3573 and v3573.AskFinishReveal then
						v3573.AskFinishReveal:InvokeServer()
					end
				end)
				t151.cache = nil

				return
			end

			if not v3498(v3572) then
				t151.status = "Waiting for banner (now: " .. t151.banner .. ")"
				t151.demands = "-"
				t151.stock = "-"
				t151.ready = 0
				t151.missing = "None"

				return
			end

			local v3574 = v3505(v3572)

			t151.total = #v3574
			t151.demands = #v3574 > 0 and v3490(v3574, " / ") or "-"

			if #v3574 < 3 then
				t151.status = "Waiting for requirements"

				return
			end

			local v3575 = v3506()
			local v3576, v3577, v3578 = selectPets(v3574, v3575)

			t151.stock = v3536(v3574, v3575, v3578)
			t151.ready = #v3574 - #v3577
			t151.missing = #v3577 > 0 and v3490(v3577, ", ") or "None"

			if #v3577 == 0 then
				if senaV4Config.ScrambleTradeInTrade then
					t151.status = "Requirements complete, submitting"

					local v3579, v3580 = v3557(v3574, v3576)

					t151.status = v3579 and "Trade complete" or "Trade: " .. tostring(v3580)
				else
					t151.status = "Ready to trade (Auto Trade-In is off)"
				end

				return
			end

			if senaV4Config.ScrambleTradeInReroll and t151.free > 0 and os.clock() - t151.lastReroll > 3 then
				t151.lastReroll = os.clock()
				t151.status = "Rerolling the recipe"
				t151.reroll()

				return
			end

			t151.status = #v3577 > 0 and "Waiting for " .. t151.missing or t151.status
		end
		task.spawn(function()
			while v16() do
				if v3481() then
					local ok, result = pcall(t151.tick)

					if not ok then
						t151.status = "Trade-In error: " .. tostring(result)
					end
				elseif t151.status ~= "Disabled" then
					t151.status = "Disabled"
				end

				task.wait(1)
			end
		end)
		genv.__SenaV4ScrambleTradeIn = t151
	end

	v3471()

	local function v3583()
		local LocalPlayer2 = game:GetService("Players").LocalPlayer
		local t163 = {
			status = "Disabled",
			inArena = false,
			joins = 0,
			hits = 0,
			dodges = 0
		}
		local ScrambleBossHazards

		pcall(function()
			ScrambleBossHazards = require(ReplicatedStorage.Shared.Util.ScrambleBossHazards)
		end)

		local function v3587()
			local ok, result = pcall(function()
				return require(ReplicatedStorage.Shared.Remotes)
			end)
			local v3590 = ok and result or nil

			return v3590
		end
		local function v3591()
			return workspace:FindFirstChild("ScrambleArena")
		end
		local function v3592()
			return workspace:FindFirstChild("ScrambleArenaPortal")
		end
		local function v3593()
			local Character = LocalPlayer2.Character

			if Character then
				return Character:FindFirstChild("HumanoidRootPart"), Character:FindFirstChildOfClass("Humanoid"), Character
			end

			return nil
		end
		local function amInArena()
			local v3596 = v3591()

			if not v3596 then
				return false
			end

			local v3597 = v3593()

			if not v3597 then
				return false
			end

			local attribute = v3596:GetAttribute("Center")

			if typeof(attribute) == "Vector3" then
				return (v3597.Position - attribute).Magnitude < (tonumber(v3596:GetAttribute("Radius")) or 500) + 80
			end

			return false
		end

		t163.amInArena = amInArena

		local function v3599()
			local __SenaV4StealWantsCharacter = genv.__SenaV4StealWantsCharacter

			return senaV4Config.AutoSteal == true and __SenaV4StealWantsCharacter ~= nil and __SenaV4StealWantsCharacter() == true
		end

		local t164 = {}

		pcall(function()
			local v3602 = v3587()

			if v3602 and v3602.ScrambleBoss and v3602.ScrambleBoss.Hazard then
				v3602.ScrambleBoss.Hazard.OnClientEvent:Connect(function(p851)
					if type(p851) == "table" and p851.Id then
						t164[p851.Id] = p851
						task.delay((p851.Warn or 0) + (ScrambleBossHazards and ScrambleBossHazards.ActiveSeconds(p851) or 0.25) + 1.5, function()
							if t164[p851.Id] == p851 then
								t164[p851.Id] = nil
							end
						end)
					end
				end)
			end
		end)

		local function v3603(p852, p853, p854)
			if not ScrambleBossHazards then
				return false
			end

			local v3604 = p854 - (p852.At or p854)
			local v3605 = ScrambleBossHazards.ActiveSeconds(p852)

			if not (v3604 >= 0) or not (v3604 <= v3605) then
				if v3604 < 0 and v3604 > -2.2 then
					for i = 0, 5 do
						if ScrambleBossHazards.Contains(p852, i / 5 * v3605, p853, false, 3.5) then
							return true
						end
					end
				end
			elseif ScrambleBossHazards.Contains(p852, v3604, p853, false, 3.5) then
				return true
			end

			return false
		end
		local function v3607(p855, p856)
			for _, v in pairs(t164) do
				if v3603(v, p855, p856) then
					return false
				end
			end

			return true
		end
		local function v3610(p857)
			local v3611 = v3593()

			if v3611 then
				return not v3607(v3611.Position, p857)
			end

			return false
		end
		local function v3612(p858)
			local v3613 = v3593()
			local v3614 = v3591()

			if not v3613 or not v3614 then
				return nil
			end

			local attribute = v3614:GetAttribute("Center")
			local v3616 = tonumber(v3614:GetAttribute("HubRadius")) or 88
			local Y = tonumber(v3614:GetAttribute("FloorY")) or v3613.Position.Y
			local Position = v3613.Position

			for _, v in ipairs({
				9,
				15,
				23,
				33,
				45
			}) do
				local v3621
				local v3622

				for i = 0, 11 do
					local v3624 = i / 12 * 3.1415926535897931 * 2
					local vector32 = Vector3.new(Position.X + math.cos(v3624) * v, Y + 3, Position.Z + math.sin(v3624) * v)

					if (typeof(attribute) ~= "Vector3" or Vector3.new(vector32.X - attribute.X, 0, vector32.Z - attribute.Z).Magnitude <= v3616 + 8) and v3607(vector32, p858) then
						local Magnitude = (vector32 - Position).Magnitude

						if not v3622 or Magnitude < v3622 then
							v3621 = vector32
							v3622 = Magnitude
						end
					end
				end

				if v3621 then
					return v3621
				end
			end

			return nil
		end
		local function v3627(p859)
			if not v3610(p859) then
				return false
			end

			local v3628 = v3612(p859)

			if not v3628 then
				return false
			end

			local v3629 = v3593()

			if v3629 then
				v3629.CFrame = cFrameNew(v3628)
				v3629.AssemblyLinearVelocity = Vector3.zero
				t163.dodges += 1
			end

			return true
		end

		local n63 = 0

		local function v3631()
			local _, v3633, v3634 = v3593()

			if not v3634 then
				return nil
			end

			local __SenaV4IsBatTool = genv.__SenaV4IsBatTool or function(p860)
				return p860:IsA("Tool") and p860:GetAttribute("IsBat") == true
			end

			for _, child in ipairs(v3634:GetChildren()) do
				if not __SenaV4IsBatTool(child) then
					continue
				end

				return child
			end

			local Backpack = LocalPlayer2:FindFirstChild("Backpack")

			if Backpack and v3633 then
				for _, child in ipairs(Backpack:GetChildren()) do
					if not __SenaV4IsBatTool(child) then
						continue
					end

					pcall(function()
						v3633:EquipTool(child)
					end)

					return child
				end
			end

			return nil
		end
		local function v3641(p861)
			local v3642 = v3631()

			if not v3642 then
				return
			end

			local serverTimeNow = workspace:GetServerTimeNow()

			if serverTimeNow - n63 < 0.22 then
				return
			end

			n63 = serverTimeNow
			pcall(function()
				v3642:Activate()
			end)

			local Handle = v3642:FindFirstChild("Handle") or v3642:FindFirstChildWhichIsA("BasePart", true)

			if Handle and p861 and type(firetouchinterest) == "function" then
				pcall(function()
					firetouchinterest(Handle, p861, 0)
					task.wait(0.02)
					firetouchinterest(Handle, p861, 1)
				end)
			end

			t163.hits += 1
			pcall(function()
				local v3645 = v3587()

				if v3645 and v3645.BatSwing then
					v3645.BatSwing.Trigger:FireServer(nil, string.format("%d:%d:%d", LocalPlayer2.UserId, t163.hits, math.floor(serverTimeNow * 1000)))
				end
			end)
		end

		local t165 = {
			Floor = true,
			Structure = true,
			Collision = true,
			Windows = true,
			BackgroundCrates = true,
			Crates = true,
			Cranes = true,
			VFX = true,
			Coils = true,
			Center = true,
			BossSpawn = true,
			PlayerSpawn = true,
			LeaveTeleport = true,
			HubBlocker = true,
			FloorSlime = true,
			Drones = true,
			ScrambleHazards = true
		}

		local function v3647(p862)
			if p862:IsA("BasePart") then
				return p862
			end

			return p862.PrimaryPart or p862:FindFirstChild("Core") or p862:FindFirstChild("Hitbox") or p862:FindFirstChild("HumanoidRootPart") or p862:FindFirstChildWhichIsA("BasePart", true)
		end
		local function v3648(p863)
			local v3649 = v3593()

			if not v3649 then
				return nil
			end

			local u3650
			local u3651
			local u3652

			local function v3653(p864, p865)
				local v3654 = v3647(p864)

				if not v3654 then
					return
				end

				local Magnitude = (v3654.Position - v3649.Position).Magnitude

				if not u3651 or p865 < u3651 or p865 == u3651 and Magnitude < u3652 then
					u3650 = v3654
					u3651 = p865
					u3652 = Magnitude
				end
			end

			for _, v in ipairs({
				"Mech",
				"Ball",
				"Croc",
				"Human",
				"DrScramble",
				"Pilot"
			}) do
				local v3658 = p863:FindFirstChild(v)

				if v3658 then
					v3653(v3658, 1)
				end
			end

			for _, child in ipairs(p863:GetChildren()) do
				if not t165[child.Name] and child:IsA("Model") and child.Name ~= "Mech" and child:FindFirstChildOfClass("Humanoid") then
					v3653(child, 1)
				end
			end

			local Drones = p863:FindFirstChild("Drones")

			if Drones then
				for _, child in ipairs(Drones:GetChildren()) do
					if child:IsA("Model") then
						local Hitbox = child:FindFirstChild("Hitbox") or child.PrimaryPart

						if Hitbox then
							v3653(Hitbox, 2)
						end
					end
				end
			end

			return u3650
		end
		local function v3665()
			if LocalPlayer2:GetAttribute("ScrambleGrabbed") == true then
				pcall(function()
					local v3666 = v3587()

					if v3666 and v3666.ScrambleBoss then
						v3666.ScrambleBoss.HazardHit:FireServer(-2)
					end
				end)

				return true
			end

			return false
		end
		local function v3667(p866, p867)
			local v3668 = v3593()

			if not v3668 then
				return
			end

			local v3669 = p866 - v3668.Position
			local Magnitude = v3669.Magnitude

			if Magnitude < 0.5 then
				return
			end

			v3668.CFrame = cFrameNew(v3668.Position + v3669.Unit * math.min(Magnitude, p867 or 40))
			v3668.AssemblyLinearVelocity = Vector3.zero
		end
		local function v3671(p868)
			local v3672 = v3593()

			if not v3672 then
				return
			end

			local Position = v3672.Position
			local v3674 = math.max(1, math.ceil((p868 - Position).Magnitude / 140))

			for i = 1, v3674 do
				local v3676 = v3593()

				if not v3676 then
					return
				end

				v3676.CFrame = cFrameNew(Position:Lerp(p868, i / v3674))
				v3676.AssemblyLinearVelocity = Vector3.zero
				task.wait(0.08)
			end
		end
		local function leaveArena()
			local v3678 = v3591()

			if not v3678 then
				return false
			end

			local v3679 = v3593()

			if not v3679 then
				return false
			end

			local LeaveTeleport = v3678:FindFirstChild("LeaveTeleport")
			local isBasePart = LeaveTeleport and (LeaveTeleport:IsA("BasePart") and LeaveTeleport or LeaveTeleport:FindFirstChildWhichIsA("BasePart", true))

			if not isBasePart then
				return false
			end

			v3679.CFrame = cFrameNew(isBasePart.Position + Vector3.new(0, 3, 0))
			v3679.AssemblyLinearVelocity = Vector3.zero

			return true
		end

		t163.leaveArena = leaveArena

		local n64 = 0

		task.spawn(function()
			while v16() do
				if not senaV4Config.ScrambleBossAuto or v3599() then
					if senaV4Config.ScrambleBossAuto and v3599() then
						t163.status = "Yielding to Auto Steal"

						if amInArena() and os.clock() - n64 > 3 then
							n64 = os.clock()
							leaveArena()
						end
					elseif t163.status ~= "Disabled" then
						t163.status = "Disabled"
					end

					task.wait(0.3)
				else
					local v3683 = v3591()

					if amInArena() then
						t163.inArena = true

						local serverTimeNow = workspace:GetServerTimeNow()

						if v3627(serverTimeNow) then
							t163.status = "Dodging"
						elseif v3665() then
							t163.status = "Breaking free"
						else
							v3631()

							local v3685 = v3648(v3683)

							if v3685 then
								local v3686 = v3593()

								if v3686 and (v3686.Position - v3685.Position).Magnitude > 12 then
									v3667(v3685.Position + Vector3.new(0, 2, 0), 42)
								end

								v3641(v3685)
								t163.status = "Fighting (" .. tostring(v3683:GetAttribute("Phase")) .. ")"
							else
								t163.status = "In arena (" .. tostring(v3683:GetAttribute("Phase")) .. ")"
							end
						end

						task.wait(0.06)
					elseif v3592() then
						t163.status = "Boss up - joining"

						local v3687 = v3592()
						local Position = v3687 and (v3687:IsA("Model") and select(1, v3687:GetPivot()).Position or v3687.Position)

						if Position then
							local v3689 = v3593()

							if v3689 and v612 and (v3689.Position - Position).Magnitude > 600 and not v612:_isInSafeArea(v3689) then
								local v3690 = v612:_resolveSafeCFrame(v3689)

								if v3690 then
									t163.status = "Heading to the safe zone first"
									v3671(v3690.Position)
								end
							end

							v3671(Position + Vector3.new(0, 3, 0))
							t163.joins += 1
						end

						task.wait(1.2)
					else
						t163.inArena = false
						t163.status = "Waiting for boss"
						task.wait(0.4)
					end
				end
			end
		end)
		task.spawn(function()
			while v16() do
				if senaV4Config.AutoSteal and not senaV4Config.ScrambleBossAuto and amInArena() then
					leaveArena()
					task.wait(0.5)
				end

				task.wait(0.25)
			end
		end)
		genv.__SenaV4ScrambleBoss = t163
	end

	v3583()

	local senaPanels = {}

	local function v3692()
		game:GetService("UserInputService")

		local Assets = require(ReplicatedStorage.Data.Assets)
		local EggState2 = require(ReplicatedStorage.Client.EggState)
		local Save = require(ReplicatedStorage.Shared.Save)
		local t166 = {
			strokeCol = Color3.fromRGB(36, 36, 42),
			accent = Color3.fromRGB(26, 147, 250),
			accentA = Color3.fromRGB(19, 96, 250),
			accentB = Color3.fromRGB(33, 198, 250),
			surface = Color3.fromRGB(22, 22, 27),
			surfaceHi = Color3.fromRGB(28, 28, 34),
			text = Color3.fromRGB(235, 236, 245),
			btnText = Color3.fromRGB(186, 184, 198),
			muted = Color3.fromRGB(156, 154, 170),
			shadow = Color3.fromRGB(4, 4, 8),
			obsTop = Color3.fromRGB(18, 18, 24),
			obsMid = Color3.fromRGB(12, 12, 16),
			obsLow = Color3.fromRGB(10, 14, 26),
			btnBg = Color3.fromRGB(30, 30, 36),
			btnHover = Color3.fromRGB(44, 44, 52),
			inputBg = Color3.fromRGB(14, 14, 18),
			switchOff = Color3.fromRGB(42, 42, 48),
			good = Color3.fromRGB(163, 230, 53)
		}
		local v3697 = t166

		local function v3698()
			pcall(function()
				if type(setthreadidentity) == "function" then
					setthreadidentity(8)
				elseif genv and type(genv.__SenaV4IdentitySetter) == "function" then
					genv.__SenaV4IdentitySetter(8)
				end
			end)
		end
		local function v3699()
			local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")

			if PlayerGui then
				return PlayerGui
			end

			local ok, result = pcall(function()
				return game:GetService("CoreGui")
			end)

			if not ok or not result then
				return game:GetService("CoreGui")
			end

			return result
		end
		local function v3703(p869)
			local v3704 = tonumber(p869) or 0

			if v3704 >= 1e12 then
				return string.format("%.2fT", v3704 / 1e12)
			end

			if v3704 >= 1e9 then
				return string.format("%.2fB", v3704 / 1e9)
			end

			if v3704 >= 1000000 then
				return string.format("%.2fM", v3704 / 1000000)
			end

			if v3704 >= 1000 then
				return string.format("%.2fK", v3704 / 1000)
			end

			return string.format("%d", v3704)
		end
		local function v3705(p870)
			return v3703(p870)
		end
		local function v3706(p871)
			if typeof(p871) == "Color3" then
				return string.format("#%02x%02x%02x", math.floor(p871.R * 255), math.floor(p871.G * 255), math.floor(p871.B * 255))
			end

			return "#ffffff"
		end
		local function v3707(p872)
			local Directory = Assets.Directory and Assets.Directory[p872]

			if not Directory or not Directory.Rarity then
				return 0, "?", nil
			end

			local DisplayName = Directory.Rarity.DisplayName or Directory.Rarity._id or "?"

			return v611.rarityRank(DisplayName), DisplayName, Directory.Rarity.Color
		end
		local function v3710(p873)
			local Directory = Assets.Directory and Assets.Directory[p873]

			if type(Directory) ~= "table" then
				return nil
			end

			local function v3712(p874)
				if type(p874) == "string" and p874 ~= "" then
					if p874:find("rbxassetid") or p874:find("rbxthumb") then
						return p874
					end

					if p874:match("^%d+$") then
						return "rbxassetid://" .. p874
					end
				elseif type(p874) == "number" and p874 > 0 then
					return "rbxassetid://" .. tostring(p874)
				end

				return nil
			end

			local t167 = {
				"Image",
				"Icon",
				"Thumbnail",
				"ImageId",
				"IconId",
				"Texture",
				"Asset",
				"DisplayImage"
			}

			for _, v in ipairs(t167) do
				local v3716 = v3712(Directory[v])

				if not v3716 then
					continue
				end

				return v3716
			end

			if type(Directory.Egg) == "table" then
				for _, v in ipairs(t167) do
					local v3719 = v3712(Directory.Egg[v])

					if not v3719 then
						continue
					end

					return v3719
				end
			end

			return nil
		end

		local t168 = {}
		local t169 = {}
		local pairs_ = pairs
		local Directory = Assets.Directory or {}

		for k, v in pairs_(Directory) do
			if type(v) == "table" and v.Rarity then
				local DisplayName = v.Rarity.DisplayName or v.Rarity._id or "?"
				local v3727 = v611.rarityRank(DisplayName)

				t169[DisplayName] = v3727
				table.insert(t168, {
					cat = k,
					rnum = v3727,
					rname = DisplayName
				})
			end
		end

		table.sort(t168, function(p875, p876)
			if p875.rnum == p876.rnum then
				return p875.cat < p876.cat
			end

			return p875.rnum > p876.rnum
		end)

		local function v3728()
			local t170 = {}
			local t171 = {}

			for _, v in ipairs(t168) do
				if not t170[v.rname] then
					t170[v.rname] = true
					table.insert(t171, {
						v.rname,
						v.rnum
					})
				end
			end

			table.sort(t171, function(p877, p878)
				return p877[2] > p878[2]
			end)

			local t172 = { "Any" }

			for _, v in ipairs(t171) do
				table.insert(t172, v[1])
			end

			return t172
		end
		local function v3736()
			local t173 = {}

			for _, v in ipairs(v3728()) do
				if v ~= "Any" then
					table.insert(t173, v)
				end
			end

			return t173
		end
		local function v3740(p879)
			local n65 = 0

			pcall(function()
				n65 = senaV4Config:getAreaEggValue(p879) or 0
			end)

			if n65 > 0 then
				return n65
			end

			pcall(function()
				local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)

				if AssetEarnings and type(AssetEarnings.LiveRatePerSecond) == "function" then
					n65 = AssetEarnings.LiveRatePerSecond(p879) or 0
				end
			end)

			local v3743 = n65 or 0

			return v3743
		end
		local function v3744(p880)
			local n66 = 0

			pcall(function()
				local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
				local AssetCategory = p880.AssetCategory or p880.Category

				n66 = EggRecords.WeightKgForScale(AssetCategory, p880.AssetScale or p880.Scale or 1)
			end)

			local v3748 = n66 or 0

			return v3748
		end
		local function v3749()
			local n67 = 0
			local n68 = 0

			pcall(function()
				local pairs_2 = pairs
				local v3753 = EggState2.ReadOwnerEggs(LocalPlayer.UserId) or {}

				for _, v in pairs_2(v3753) do
					if v.Placement == nil then
						n68 += 1
					else
						n67 += 1
					end
				end
			end)

			return n67, math.max(0, 50 - n67), n68
		end

		local t174 = {}

		local function v3757(p881)
			local AssetCategory = p881 and (p881.AssetCategory or p881.Category)

			if not AssetCategory then
				return
			end

			local v3759 = t174[AssetCategory]

			if not v3759 then
				local v3760, v3761, v3762 = v3707(AssetCategory)

				v3759 = {
					name = AssetCategory,
					rarity = v3761,
					rnum = v3760,
					color = v3762,
					count = 0,
					last = 0,
					image = v3710(AssetCategory)
				}
				t174[AssetCategory] = v3759
			end

			v3759.count += 1
			v3759.last = os.clock()
		end

		local windows = {}

		local function v3764(p882)
			local v3765 = windows[p882]

			return v3765 ~= nil and v3765.gui ~= nil and v3765.gui.Parent ~= nil and v3765.gui.Enabled or false
		end

		local v3766
		local v3767
		local v3768
		local t175 = {
			list = nil,
			headLbl = nil,
			countLbl = nil,
			statusBtn = nil,
			sel = nil,
			rows = {},
			picked = {},
			chips = {},
			sortBtns = {},
			modeBtns = {}
		}
		local t176 = {
			history = {},
			reportedUids = {},
			knownFieldUids = {},
			lastAlert = nil,
			lastReportTime = 0,
			lastSync = 0,
			onlineCount = 1,
			category = "targets",
			filter = "All"
		}

		local function v3771(p883)
			v3698()

			if p883 == "logs" then
				if v3766 then
					v3766()
				end
			elseif p883 == "eggs" then
				if v3767 then
					v3767()
				end
			elseif p883 == "inventory" then
				if v3768 then
					v3768()
				end
			elseif p883 == "checker" then
				if t175 and t175.refresh then
					t175.refresh()
				end
			elseif p883 == "eggdata" and t176 and t176.refresh then
				t176.refresh()
			end
		end

		local u3772
		local TextLabel
		local s12 = "rarity"
		local t177 = {}

		local function v3776()
			v3698()

			for k, v in pairs(t177) do
				local v3779 = k == s12

				v.BackgroundColor3 = v3779 and v3697.accent or Color3.fromRGB(255, 255, 255)
				v.BackgroundTransparency = v3779 and 0.15 or 0.88
				v.TextColor3 = v3779 and Color3.fromRGB(255, 255, 255) or v3697.btnText

				local UIStroke = v:FindFirstChildOfClass("UIStroke")

				if UIStroke then
					UIStroke.Transparency = v3779 and 0 or 1
				end
			end
		end

		v3766 = function()
			v3698()

			if not u3772 then
				return
			end

			for _, child in ipairs(u3772:GetChildren()) do
				if child:IsA("Frame") then
					child:Destroy()
				end
			end

			local t178 = {}
			local n69 = 0

			for _, v in pairs(t174) do
				table.insert(t178, v)
				n69 += v.count
			end

			if s12 == "count" then
				table.sort(t178, function(p884, p885)
					if p884.count == p885.count then
						return (p884.rnum or 0) > (p885.rnum or 0)
					end

					return p884.count > p885.count
				end)
			elseif s12 == "name" then
				table.sort(t178, function(p886, p887)
					return tostring(p886.name) < tostring(p887.name)
				end)
			else
				table.sort(t178, function(p888, p889)
					if p888.rnum == p889.rnum then
						return p888.count > p889.count
					end

					return (p888.rnum or 0) > (p889.rnum or 0)
				end)
			end

			for i, v in ipairs(t178) do
				local Frame = Instance.new("Frame")

				Frame.Size = UDim2.new(1, -6, 0, 34)
				Frame.BackgroundColor3 = v3697.surface
				Frame.BackgroundTransparency = 0.12
				Frame.BorderSizePixel = 0
				Frame.LayoutOrder = i
				Frame.Parent = u3772
				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

				local UIStroke = Instance.new("UIStroke", Frame)

				UIStroke.Color = v3697.strokeCol
				UIStroke.Thickness = 1
				UIStroke.Transparency = 0.72

				local Frame2 = Instance.new("Frame")

				Frame2.Size = UDim2.new(0, 3, 1, -10)
				Frame2.Position = UDim2.fromOffset(0, 5)
				Frame2.BorderSizePixel = 0
				Frame2.BackgroundColor3 = v.color or v3697.accent
				Frame2.Parent = Frame
				Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)

				local ImageLabel = Instance.new("ImageLabel")

				ImageLabel.Position = UDim2.fromOffset(10, 5)
				ImageLabel.Size = UDim2.fromOffset(24, 24)
				ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ImageLabel.BackgroundTransparency = v.image and 0.9 or 0.94
				ImageLabel.BorderSizePixel = 0
				ImageLabel.ScaleType = Enum.ScaleType.Fit
				ImageLabel.Image = v.image or ""
				ImageLabel.Parent = Frame
				Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 4)

				if not v.image then
					local Frame3 = Instance.new("Frame")

					Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
					Frame3.Position = UDim2.fromScale(0.5, 0.5)
					Frame3.Size = UDim2.fromOffset(9, 9)
					Frame3.BackgroundColor3 = v.color or v3697.accent
					Frame3.BorderSizePixel = 0
					Frame3.Parent = ImageLabel
					Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0)
				end

				local TextLabel2 = Instance.new("TextLabel")

				TextLabel2.BackgroundTransparency = 1
				TextLabel2.Position = UDim2.fromOffset(42, 0)
				TextLabel2.Size = UDim2.new(0.5, -42, 1, 0)
				TextLabel2.Font = Enum.Font.GothamBold
				TextLabel2.TextSize = 13
				TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd
				TextLabel2.TextColor3 = v3697.text
				TextLabel2.Text = tostring(v.name)
				TextLabel2.Parent = Frame

				local TextLabel3 = Instance.new("TextLabel")

				TextLabel3.BackgroundTransparency = 1
				TextLabel3.Position = UDim2.new(0.5, 0, 0, 0)
				TextLabel3.Size = UDim2.new(0.3, 0, 1, 0)
				TextLabel3.Font = Enum.Font.GothamBold
				TextLabel3.TextSize = 12
				TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel3.TextColor3 = v.color or v3697.muted
				TextLabel3.Text = tostring(v.rarity)
				TextLabel3.Parent = Frame

				local TextLabel4 = Instance.new("TextLabel")

				TextLabel4.BackgroundTransparency = 1
				TextLabel4.Position = UDim2.new(0.8, 0, 0, 0)
				TextLabel4.Size = UDim2.new(0.2, -12, 1, 0)
				TextLabel4.Font = Enum.Font.GothamBold
				TextLabel4.TextSize = 13
				TextLabel4.TextXAlignment = Enum.TextXAlignment.Right
				TextLabel4.TextColor3 = v3697.accent
				TextLabel4.Text = "x" .. tostring(v.count)
				TextLabel4.Parent = Frame
			end

			u3772.CanvasSize = UDim2.new(0, 0, 0, #t178 * 38 + 6)

			if TextLabel then
				TextLabel.Text = "Total: " .. tostring(n69)
			end
		end

		local function v3797(p890)
			TextLabel = Instance.new("TextLabel")
			TextLabel.BackgroundTransparency = 1
			TextLabel.Position = UDim2.new(1, -150, 0, 4)
			TextLabel.Size = UDim2.fromOffset(110, 22)
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.TextSize = 12
			TextLabel.TextXAlignment = Enum.TextXAlignment.Right
			TextLabel.TextColor3 = v3697.muted
			TextLabel.Text = "Total: 0"
			TextLabel.Parent = p890

			local Frame = Instance.new("Frame")

			Frame.Position = UDim2.fromOffset(14, 4)
			Frame.Size = UDim2.new(1, -28, 0, 28)
			Frame.BackgroundTransparency = 1
			Frame.Parent = p890

			local UIListLayout = Instance.new("UIListLayout", Frame)

			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.Padding = UDim.new(0, 6)
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

			local function v3800(p891, p892, p893)
				local TextButton = Instance.new("TextButton")

				TextButton.Size = UDim2.fromOffset(p893, 26)
				TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.BackgroundTransparency = 0.88
				TextButton.AutoButtonColor = false
				TextButton.Font = Enum.Font.GothamBold
				TextButton.TextSize = 12
				TextButton.TextColor3 = v3697.btnText
				TextButton.Text = p891
				TextButton.Parent = Frame
				Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 4)

				local UIStroke = Instance.new("UIStroke", TextButton)

				UIStroke.Color = v3697.accent
				UIStroke.Thickness = 1
				UIStroke.Transparency = 1
				TextButton.MouseButton1Click:Connect(function()
					s12 = p892
					v3776()
					v3766()
				end)
				t177[p892] = TextButton
			end

			v3800("Rarity", "rarity", 66)
			v3800("Amount", "count", 66)
			v3800("Name", "name", 58)

			local TextButton = Instance.new("TextButton")

			TextButton.Size = UDim2.fromOffset(54, 26)
			TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.BackgroundTransparency = 0.88
			TextButton.AutoButtonColor = false
			TextButton.Font = Enum.Font.GothamBold
			TextButton.TextSize = 12
			TextButton.TextColor3 = v3697.btnText
			TextButton.Text = "Clear"
			TextButton.Parent = Frame
			Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 4)

			local UIStroke = Instance.new("UIStroke", TextButton)

			UIStroke.Color = v3697.accent
			UIStroke.Thickness = 1
			UIStroke.Transparency = 1
			TextButton.MouseButton1Click:Connect(function()
				t174 = {}
				v3766()
			end)

			local Frame2 = Instance.new("Frame")

			Frame2.Position = UDim2.fromOffset(16, 38)
			Frame2.Size = UDim2.new(1, -32, 0, 18)
			Frame2.BackgroundTransparency = 1
			Frame2.Parent = p890

			local function v3806(p894, p895, p896, p897)
				local TextLabel2 = Instance.new("TextLabel")

				TextLabel2.BackgroundTransparency = 1
				TextLabel2.Position = p895
				TextLabel2.Size = p896
				TextLabel2.Font = Enum.Font.GothamBold
				TextLabel2.TextSize = 11
				TextLabel2.TextColor3 = v3697.muted
				TextLabel2.TextXAlignment = p897
				TextLabel2.Text = p894
				TextLabel2.Parent = Frame2
			end

			v3806("EGG", UDim2.fromOffset(26, 0), UDim2.new(0.5, -26, 1, 0), Enum.TextXAlignment.Left)
			v3806("RARITY", UDim2.new(0.5, 0, 0, 0), UDim2.new(0.3, 0, 1, 0), Enum.TextXAlignment.Left)
			v3806("AMOUNT", UDim2.new(0.8, 0, 0, 0), UDim2.new(0.2, -12, 1, 0), Enum.TextXAlignment.Right)

			local ScrollingFrame = Instance.new("ScrollingFrame")

			ScrollingFrame.Position = UDim2.fromOffset(14, 60)
			ScrollingFrame.Size = UDim2.new(1, -28, 1, -68)
			ScrollingFrame.BackgroundTransparency = 1
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.ScrollBarThickness = 3
			ScrollingFrame.ScrollBarImageColor3 = v3697.accent
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			ScrollingFrame.Parent = p890

			local UIListLayout2 = Instance.new("UIListLayout", ScrollingFrame)

			UIListLayout2.Padding = UDim.new(0, 4)
			UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			u3772 = ScrollingFrame
			v3776()
			v3766()
		end

		local u3810
		local TextLabel2
		local startPlacing
		local TextLabel3
		local s13 = "All"
		local t179 = {}
		local t180 = {}

		local function v3817()
			v3698()

			for k, v in pairs(t179) do
				local v3820 = k == s13

				v.BackgroundColor3 = v3820 and v3697.accent or Color3.fromRGB(255, 255, 255)
				v.BackgroundTransparency = v3820 and 0.15 or 0.88
				v.TextColor3 = v3820 and Color3.fromRGB(255, 255, 255) or v3697.btnText

				local UIStroke = v:FindFirstChildOfClass("UIStroke")

				if UIStroke then
					UIStroke.Transparency = v3820 and 0 or 1
				end
			end
		end

		v3767 = function()
			v3698()

			if not u3810 then
				return
			end

			for _, child in ipairs(u3810:GetChildren()) do
				if child:IsA("Frame") then
					child:Destroy()
				end
			end

			local ok, result = pcall(function()
				return EggState2.ReadOwnerEggs(LocalPlayer.UserId)
			end)

			if not ok or type(result) ~= "table" then
				if TextLabel3 then
					TextLabel3.Text = "Total: 0  ON: 0"
				end

				return
			end

			local t181 = {}
			local n70 = 0

			for k, v in pairs(result) do
				if v.Placement == nil then
					local v3830, v3831, v3832 = v3707(v.AssetCategory)

					if s13 == "All" or v3831 == s13 then
						local v3833 = t180[k] ~= false

						if v3833 then
							n70 += 1
						end

						local Directory2 = Assets.Directory and Assets.Directory[v.AssetCategory]

						table.insert(t181, {
							uid = k,
							name = Directory2 and Directory2.DisplayName or v.AssetCategory or tostring(k):sub(1, 8),
							rarity = v3831,
							rnum = v3830,
							color = v3832,
							image = v3710(v.AssetCategory),
							enabled = v3833
						})
					end
				end
			end

			table.sort(t181, function(p898, p899)
				if p898.rnum == p899.rnum then
					return p898.name < p899.name
				end

				return (p898.rnum or 0) > (p899.rnum or 0)
			end)

			for i, v in ipairs(t181) do
				local Frame = Instance.new("Frame")

				Frame.Size = UDim2.new(1, -6, 0, 34)
				Frame.BackgroundColor3 = v3697.surface
				Frame.BackgroundTransparency = 0.12
				Frame.BorderSizePixel = 0
				Frame.LayoutOrder = i
				Frame.Parent = u3810
				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

				local UIStroke = Instance.new("UIStroke", Frame)

				UIStroke.Color = v3697.strokeCol
				UIStroke.Thickness = 1
				UIStroke.Transparency = 0.72

				local Frame2 = Instance.new("Frame")

				Frame2.Size = UDim2.new(0, 3, 1, -10)
				Frame2.Position = UDim2.fromOffset(0, 5)
				Frame2.BorderSizePixel = 0
				Frame2.BackgroundColor3 = v.color or v3697.accent
				Frame2.Parent = Frame
				Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)

				local ImageLabel = Instance.new("ImageLabel")

				ImageLabel.Position = UDim2.fromOffset(10, 5)
				ImageLabel.Size = UDim2.fromOffset(24, 24)
				ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ImageLabel.BackgroundTransparency = 1
				ImageLabel.BorderSizePixel = 0
				ImageLabel.ScaleType = Enum.ScaleType.Fit
				ImageLabel.Image = v.image or ""
				ImageLabel.Parent = Frame
				Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 4)

				if not v.image then
					local Frame3 = Instance.new("Frame")

					Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
					Frame3.Position = UDim2.fromScale(0.5, 0.5)
					Frame3.Size = UDim2.fromOffset(9, 9)
					Frame3.BackgroundColor3 = v.color or v3697.accent
					Frame3.BorderSizePixel = 0
					Frame3.Parent = ImageLabel
					Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0)
				end

				local TextLabel4 = Instance.new("TextLabel")

				TextLabel4.BackgroundTransparency = 1
				TextLabel4.Position = UDim2.fromOffset(42, 0)
				TextLabel4.Size = UDim2.new(0.55, -42, 1, 0)
				TextLabel4.Font = Enum.Font.GothamBold
				TextLabel4.TextSize = 12
				TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel4.TextTruncate = Enum.TextTruncate.AtEnd
				TextLabel4.TextColor3 = v3697.text
				TextLabel4.Text = tostring(v.name)
				TextLabel4.Parent = Frame

				local TextLabel5 = Instance.new("TextLabel")

				TextLabel5.BackgroundTransparency = 1
				TextLabel5.Position = UDim2.new(0.55, 0, 0, 0)
				TextLabel5.Size = UDim2.new(0.23, 0, 1, 0)
				TextLabel5.Font = Enum.Font.GothamBold
				TextLabel5.TextSize = 11
				TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel5.TextColor3 = v.color or v3697.muted
				TextLabel5.Text = tostring(v.rarity)
				TextLabel5.Parent = Frame

				local TextButton = Instance.new("TextButton")

				TextButton.Position = UDim2.new(1, -62, 0, 5)
				TextButton.Size = UDim2.fromOffset(56, 24)
				TextButton.BackgroundColor3 = v.enabled and v3697.accent or Color3.fromRGB(78, 78, 96)
				TextButton.AutoButtonColor = false
				TextButton.Font = Enum.Font.GothamBold
				TextButton.TextSize = 11
				TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.Text = v.enabled and "ON" or "OFF"
				TextButton.Parent = Frame
				Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 5)

				local UIStroke2 = Instance.new("UIStroke", TextButton)

				UIStroke2.Color = v3697.strokeCol
				UIStroke2.Thickness = 1
				UIStroke2.Transparency = 0.6
				TextButton.MouseButton1Click:Connect(function()
					if t180[v.uid] == false then
						t180[v.uid] = nil
					else
						t180[v.uid] = false
					end

					v3767()
				end)
			end

			u3810.CanvasSize = UDim2.new(0, 0, 0, #t181 * 38 + 6)

			if TextLabel3 then
				TextLabel3.Text = string.format("Total: %d  ON: %d", #t181, n70)
			end

			if TextLabel2 then
				local v3846, v3847, v3848 = v3749()

				if v3847 <= 0 then
					TextLabel2.Text = string.format("Plot FULL - %d/50 placed, %d waiting", v3846, v3848)
				else
					TextLabel2.Text = string.format("Plot %d/50 - room for %d more, %d waiting", v3846, v3847, v3848)
				end
			end
		end

		local function v3849(p900)
			local Frame = Instance.new("Frame")

			Frame.Size = UDim2.fromScale(1, 1)
			Frame.BackgroundTransparency = 1
			Frame.BorderSizePixel = 0
			Frame.Parent = p900
			TextLabel3 = Instance.new("TextLabel")
			TextLabel3.BackgroundTransparency = 1
			TextLabel3.Position = UDim2.new(0, 236, 1, -60)
			TextLabel3.Size = UDim2.new(1, -250, 0, 26)
			TextLabel3.Font = Enum.Font.GothamBold
			TextLabel3.TextSize = 12
			TextLabel3.TextXAlignment = Enum.TextXAlignment.Right
			TextLabel3.TextColor3 = v3697.muted
			TextLabel3.Text = "Total: 0  ON: 0"
			TextLabel3.Parent = Frame

			local ScrollingFrame = Instance.new("ScrollingFrame")

			ScrollingFrame.Position = UDim2.fromOffset(14, 4)
			ScrollingFrame.Size = UDim2.new(1, -28, 0, 28)
			ScrollingFrame.BackgroundTransparency = 1
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.ScrollBarThickness = 3
			ScrollingFrame.ScrollBarImageColor3 = v3697.accent
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			ScrollingFrame.Parent = Frame

			local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)

			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.Padding = UDim.new(0, 6)
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			t179 = {}

			local n71 = 0

			local function v3854(p901)
				local TextButton = Instance.new("TextButton")
				local v3856 = math.max(42, #p901 * 6 + 12)

				TextButton.Size = UDim2.fromOffset(v3856, 24)
				TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.BackgroundTransparency = 0.88
				TextButton.AutoButtonColor = false
				TextButton.Font = Enum.Font.GothamBold
				TextButton.TextSize = 12
				TextButton.TextColor3 = v3697.btnText
				TextButton.Text = p901
				TextButton.Parent = ScrollingFrame
				Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 4)

				local UIStroke = Instance.new("UIStroke", TextButton)

				UIStroke.Color = v3697.accent
				UIStroke.Thickness = 1
				UIStroke.Transparency = 1
				TextButton.MouseButton1Click:Connect(function()
					s13 = p901
					v3817()
					v3767()
				end)
				t179[p901] = TextButton
				n71 = n71 + v3856 + 6
			end

			v3854("All")

			for _, v in ipairs(v3736()) do
				v3854(v)
			end

			ScrollingFrame.CanvasSize = UDim2.new(0, n71 + 4, 0, 0)
			v3817()

			local Frame2 = Instance.new("Frame")

			Frame2.Position = UDim2.fromOffset(16, 38)
			Frame2.Size = UDim2.new(1, -32, 0, 18)
			Frame2.BackgroundTransparency = 1
			Frame2.Parent = Frame

			local function v3861(p902, p903, p904, p905)
				local TextLabel4 = Instance.new("TextLabel")

				TextLabel4.BackgroundTransparency = 1
				TextLabel4.Position = p903
				TextLabel4.Size = p904
				TextLabel4.Font = Enum.Font.GothamBold
				TextLabel4.TextSize = 11
				TextLabel4.TextColor3 = v3697.muted
				TextLabel4.TextXAlignment = p905
				TextLabel4.Text = p902
				TextLabel4.Parent = Frame2
			end

			v3861("EGG", UDim2.fromOffset(26, 0), UDim2.new(0.55, -26, 1, 0), Enum.TextXAlignment.Left)
			v3861("RARITY", UDim2.new(0.55, 0, 0, 0), UDim2.new(0.23, 0, 1, 0), Enum.TextXAlignment.Left)
			v3861("PLACE", UDim2.new(1, -62, 0, 0), UDim2.fromOffset(56, 18), Enum.TextXAlignment.Center)

			local ScrollingFrame2 = Instance.new("ScrollingFrame")

			ScrollingFrame2.Position = UDim2.fromOffset(14, 60)
			ScrollingFrame2.Size = UDim2.new(1, -28, 1, -126)
			ScrollingFrame2.BackgroundTransparency = 1
			ScrollingFrame2.BorderSizePixel = 0
			ScrollingFrame2.ScrollBarThickness = 3
			ScrollingFrame2.ScrollBarImageColor3 = v3697.accent
			ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
			ScrollingFrame2.Parent = Frame

			local UIListLayout2 = Instance.new("UIListLayout", ScrollingFrame2)

			UIListLayout2.Padding = UDim.new(0, 4)
			UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			u3810 = ScrollingFrame2

			local function createTextButton(p906, p907, p908, p909)
				local TextButton = Instance.new("TextButton")

				TextButton.Size = UDim2.fromOffset(p907, 28)
				TextButton.BackgroundColor3 = p908 or v3697.accent
				TextButton.BackgroundTransparency = 0.15
				TextButton.AutoButtonColor = false
				TextButton.Font = Enum.Font.GothamBold
				TextButton.TextSize = 12
				TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.Text = p906
				TextButton.LayoutOrder = p909 or 1
				Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 4)

				local UIStroke = Instance.new("UIStroke", TextButton)

				UIStroke.Color = v3697.strokeCol
				UIStroke.Thickness = 1
				UIStroke.Transparency = 0.6

				return TextButton
			end

			local Frame3 = Instance.new("Frame")

			Frame3.Position = UDim2.new(0, 14, 1, -60)
			Frame3.Size = UDim2.new(0, 220, 0, 28)
			Frame3.BackgroundTransparency = 1
			Frame3.Parent = Frame

			local UIListLayout3 = Instance.new("UIListLayout", Frame3)

			UIListLayout3.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout3.Padding = UDim.new(0, 6)
			UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center

			local toggleAll = createTextButton("Toggle All", 80, Color3.fromRGB(60, 70, 95), 1)

			toggleAll.Parent = Frame3
			toggleAll.MouseButton1Click:Connect(function()
				local ok, result = pcall(function()
					return EggState2.ReadOwnerEggs(LocalPlayer.UserId)
				end)

				if not ok or type(result) ~= "table" then
					return
				end

				local v3873 = false
				local v3874, v3875, v3876 = pairs(result)
				local v3877 = geniter(v3874, v3875, v3876)

				while true do
					local v3878 = table.pack(v3877())

					if v3878[1] then
						if (v3878[3]).Placement == nil and t180[v3878[2]] == false then
							v3873 = true

							break
						end
					else
						break
					end
				end

				local v3879, v3880, v3881 = pairs(result)

				for k, v in v3879, v3880, v3881 do
					if v.Placement == nil then
						if v3873 then
							t180[k] = nil
						else
							t180[k] = false
						end
					end
				end

				v3767()
			end)
			startPlacing = createTextButton("Start Placing", 120, v3697.accent, 2)
			startPlacing.Parent = Frame3
			startPlacing.MouseButton1Click:Connect(function()
				pcall(function()
					if type(applyAutoPlace) == "function" then
						applyAutoPlace(true)
					elseif type(t24) == "table" and type(t24.AutoPlaceLoop) == "function" then
						senaV4Config.AutoPlace = true
						task.spawn(t24.AutoPlaceLoop)
					end
				end)
			end)
			TextLabel2 = Instance.new("TextLabel")
			TextLabel2.BackgroundTransparency = 1
			TextLabel2.Position = UDim2.new(0, 16, 1, -26)
			TextLabel2.Size = UDim2.new(1, -32, 0, 18)
			TextLabel2.Font = Enum.Font.GothamMedium
			TextLabel2.TextSize = 11
			TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel2.TextColor3 = v3697.muted
			TextLabel2.Text = ""
			TextLabel2.Parent = Frame
			v3767()
		end

		local u3884
		local TextLabel4
		local s14 = "backpack"
		local s15 = "moneys"
		local u3888 = false
		local t182 = {}
		local t183 = {}

		local function v3891()
			v3698()

			for k, v in pairs(t183) do
				local v3894 = k == s14

				v.BackgroundColor3 = v3894 and v3697.accent or Color3.fromRGB(255, 255, 255)
				v.BackgroundTransparency = v3894 and 0.15 or 0.88
				v.TextColor3 = v3894 and Color3.fromRGB(255, 255, 255) or v3697.btnText

				local UIStroke = v:FindFirstChildOfClass("UIStroke")

				if UIStroke then
					UIStroke.Transparency = v3894 and 0 or 1
				end
			end
		end
		local function v3896()
			v3698()

			for k, v in pairs(t182) do
				local v3899 = k == s15

				v.BackgroundColor3 = v3899 and v3697.accent or Color3.fromRGB(255, 255, 255)
				v.BackgroundTransparency = v3899 and 0.15 or 0.88
				v.TextColor3 = v3899 and Color3.fromRGB(255, 255, 255) or v3697.btnText

				local UIStroke = v:FindFirstChildOfClass("UIStroke")

				if UIStroke then
					UIStroke.Transparency = v3899 and 0 or 1
				end
			end
		end

		v3768 = function()
			v3698()

			if not u3884 then
				return
			end

			for _, child in ipairs(u3884:GetChildren()) do
				if child:IsA("Frame") then
					child:Destroy()
				end
			end

			local v3903 = (Save.Peek or Save.Get)() or {}
			local t184 = {}
			local n72 = 0

			local function v3906(p910)
				local AssetCategory = p910.AssetCategory or p910.Category
				local Directory2 = Assets.Directory and Assets.Directory[AssetCategory]
				local v3909, v3910, v3911 = v3707(AssetCategory)
				local v3912 = v3740({
					AssetCategory = AssetCategory,
					AssetScale = p910.Scale or p910.AssetScale or 1,
					Mutations = p910.Mutations or {}
				})
				local v3913 = v3744(p910)

				n72 += v3912
				table.insert(t184, {
					name = Directory2 and Directory2.DisplayName or tostring(AssetCategory),
					icon = v3710(AssetCategory),
					kg = v3913,
					kgS = string.format("%.1fKg", v3913),
					moneys = v3912,
					rnum = v3909,
					rarity = v3910,
					color = v3911
				})
			end

			if s14 == "inplot" then
				local ipairs_ = ipairs
				local EquippedAssets = v3903.EquippedAssets or {}

				for _, EquippedAsset in ipairs_(EquippedAssets) do
					local Inventory = v3903.Inventory and v3903.Inventory[EquippedAsset]

					if Inventory then
						v3906(Inventory)
					end
				end
			else
				local pairs_2 = pairs
				local Inventory = v3903.Inventory or {}

				for _, v in pairs_2(Inventory) do
					if type(v) == "table" and (v.AssetCategory or v.Category) then
						v3906(v)
					end
				end
			end

			local v3923 = s15 == "rarity" and "rnum" or s15

			table.sort(t184, function(p911, p912)
				if p911[v3923] == p912[v3923] then
					return p911.name < p912.name
				end

				if u3888 then
					return (p911[v3923] or 0) < (p912[v3923] or 0)
				end

				return (p911[v3923] or 0) > (p912[v3923] or 0)
			end)

			for i, v in ipairs(t184) do
				local Frame = Instance.new("Frame")

				Frame.Size = UDim2.new(1, -6, 0, 34)
				Frame.BackgroundColor3 = v3697.surface
				Frame.BackgroundTransparency = 0.12
				Frame.BorderSizePixel = 0
				Frame.LayoutOrder = i
				Frame.Parent = u3884
				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

				local UIStroke = Instance.new("UIStroke", Frame)

				UIStroke.Color = v3697.strokeCol
				UIStroke.Thickness = 1
				UIStroke.Transparency = 0.72

				local Frame2 = Instance.new("Frame")

				Frame2.Size = UDim2.new(0, 3, 1, -10)
				Frame2.Position = UDim2.fromOffset(0, 5)
				Frame2.BorderSizePixel = 0
				Frame2.BackgroundColor3 = v.color or v3697.accent
				Frame2.Parent = Frame
				Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)

				local ImageLabel = Instance.new("ImageLabel")

				ImageLabel.Position = UDim2.fromOffset(10, 5)
				ImageLabel.Size = UDim2.fromOffset(24, 24)
				ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ImageLabel.BackgroundTransparency = 1
				ImageLabel.BorderSizePixel = 0
				ImageLabel.ScaleType = Enum.ScaleType.Fit
				ImageLabel.Image = v.icon or ""
				ImageLabel.Parent = Frame
				Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 4)

				if not v.icon then
					local Frame3 = Instance.new("Frame")

					Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
					Frame3.Position = UDim2.fromScale(0.5, 0.5)
					Frame3.Size = UDim2.fromOffset(9, 9)
					Frame3.BackgroundColor3 = v.color or v3697.accent
					Frame3.BorderSizePixel = 0
					Frame3.Parent = ImageLabel
					Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0)
				end

				local TextLabel5 = Instance.new("TextLabel")

				TextLabel5.BackgroundTransparency = 1
				TextLabel5.Position = UDim2.fromOffset(42, 0)
				TextLabel5.Size = UDim2.new(0.42, -42, 1, 0)
				TextLabel5.Font = Enum.Font.GothamBold
				TextLabel5.TextSize = 12
				TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel5.TextTruncate = Enum.TextTruncate.AtEnd
				TextLabel5.TextColor3 = v3697.text
				TextLabel5.Text = tostring(v.name)
				TextLabel5.Parent = Frame

				local TextLabel6 = Instance.new("TextLabel")

				TextLabel6.BackgroundTransparency = 1
				TextLabel6.Position = UDim2.new(0.42, 0, 0, 0)
				TextLabel6.Size = UDim2.new(0.18, 0, 1, 0)
				TextLabel6.Font = Enum.Font.GothamBold
				TextLabel6.TextSize = 11
				TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel6.TextColor3 = v.color or v3697.muted
				TextLabel6.Text = tostring(v.rarity)
				TextLabel6.Parent = Frame

				local TextLabel7 = Instance.new("TextLabel")

				TextLabel7.BackgroundTransparency = 1
				TextLabel7.Position = UDim2.new(0.6, 0, 0, 0)
				TextLabel7.Size = UDim2.new(0.18, 0, 1, 0)
				TextLabel7.Font = Enum.Font.GothamBold
				TextLabel7.TextSize = 11
				TextLabel7.TextXAlignment = Enum.TextXAlignment.Right
				TextLabel7.TextColor3 = v3697.btnText
				TextLabel7.Text = tostring(v.kgS)
				TextLabel7.Parent = Frame

				local TextLabel8 = Instance.new("TextLabel")

				TextLabel8.BackgroundTransparency = 1
				TextLabel8.Position = UDim2.new(0.78, 0, 0, 0)
				TextLabel8.Size = UDim2.new(0.22, -12, 1, 0)
				TextLabel8.Font = Enum.Font.GothamBold
				TextLabel8.TextSize = 11
				TextLabel8.TextXAlignment = Enum.TextXAlignment.Right
				TextLabel8.TextColor3 = v.moneys > 0 and v3697.text or v3697.muted
				TextLabel8.Text = v3705(v.moneys) .. "/s"
				TextLabel8.Parent = Frame
			end

			u3884.CanvasSize = UDim2.new(0, 0, 0, #t184 * 38 + 6)

			if TextLabel4 then
				if s14 == "inplot" then
					TextLabel4.Text = string.format("%d equipped | %s/s", #t184, v3705(n72))
				else
					TextLabel4.Text = string.format("%d pets", #t184)
				end
			end
		end

		local function v3935(p913)
			TextLabel4 = Instance.new("TextLabel")
			TextLabel4.BackgroundTransparency = 1
			TextLabel4.Position = UDim2.new(1, -190, 0, 4)
			TextLabel4.Size = UDim2.fromOffset(180, 22)
			TextLabel4.Font = Enum.Font.GothamBold
			TextLabel4.TextSize = 12
			TextLabel4.TextXAlignment = Enum.TextXAlignment.Right
			TextLabel4.TextColor3 = v3697.muted
			TextLabel4.Text = "0 pets"
			TextLabel4.Parent = p913

			local Frame = Instance.new("Frame")

			Frame.Position = UDim2.fromOffset(14, 4)
			Frame.Size = UDim2.new(0, 180, 0, 28)
			Frame.BackgroundTransparency = 1
			Frame.Parent = p913

			local UIListLayout = Instance.new("UIListLayout", Frame)

			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.Padding = UDim.new(0, 6)
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			t183 = {}

			local function v3938(p914, p915, p916)
				local TextButton = Instance.new("TextButton")

				TextButton.Size = UDim2.fromOffset(p916, 26)
				TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.BackgroundTransparency = 0.88
				TextButton.AutoButtonColor = false
				TextButton.Font = Enum.Font.GothamBold
				TextButton.TextSize = 12
				TextButton.TextColor3 = v3697.btnText
				TextButton.Text = p914
				TextButton.Parent = Frame
				Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 4)

				local UIStroke = Instance.new("UIStroke", TextButton)

				UIStroke.Color = v3697.accent
				UIStroke.Thickness = 1
				UIStroke.Transparency = 1
				TextButton.MouseButton1Click:Connect(function()
					s14 = p915
					v3891()
					v3768()
				end)
				t183[p915] = TextButton
			end

			v3938("Backpack", "backpack", 78)
			v3938("Base", "inplot", 54)

			local Frame2 = Instance.new("Frame")

			Frame2.Position = UDim2.fromOffset(14, 36)
			Frame2.Size = UDim2.new(1, -28, 0, 28)
			Frame2.BackgroundTransparency = 1
			Frame2.Parent = p913

			local UIListLayout2 = Instance.new("UIListLayout", Frame2)

			UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout2.Padding = UDim.new(0, 6)
			UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
			t182 = {}

			local function v3943(p917, p918, p919)
				local TextButton = Instance.new("TextButton")

				TextButton.Size = UDim2.fromOffset(p919, 26)
				TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.BackgroundTransparency = 0.88
				TextButton.AutoButtonColor = false
				TextButton.Font = Enum.Font.GothamBold
				TextButton.TextSize = 12
				TextButton.TextColor3 = v3697.btnText
				TextButton.Text = p917
				TextButton.Parent = Frame2
				Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 4)

				local UIStroke = Instance.new("UIStroke", TextButton)

				UIStroke.Color = v3697.accent
				UIStroke.Thickness = 1
				UIStroke.Transparency = 1
				TextButton.MouseButton1Click:Connect(function()
					if s15 == p918 then
						u3888 = not u3888
					else
						s15 = p918
						u3888 = false
					end

					v3896()
					v3768()
				end)
				t182[p918] = TextButton
			end

			v3943("Money/s", "moneys", 86)
			v3943("Kg", "kg", 56)
			v3943("Rarity", "rarity", 76)
			v3943("Name", "name", 66)

			local Frame3 = Instance.new("Frame")

			Frame3.Position = UDim2.fromOffset(16, 66)
			Frame3.Size = UDim2.new(1, -32, 0, 18)
			Frame3.BackgroundTransparency = 1
			Frame3.Parent = p913

			local function v3947(p920, p921, p922, p923)
				local TextLabel5 = Instance.new("TextLabel")

				TextLabel5.BackgroundTransparency = 1
				TextLabel5.Position = p921
				TextLabel5.Size = p922
				TextLabel5.Font = Enum.Font.GothamBold
				TextLabel5.TextSize = 11
				TextLabel5.TextColor3 = v3697.muted
				TextLabel5.TextXAlignment = p923
				TextLabel5.Text = p920
				TextLabel5.Parent = Frame3
			end

			v3947("PET", UDim2.fromOffset(26, 0), UDim2.new(0.42, -26, 1, 0), Enum.TextXAlignment.Left)
			v3947("RARITY", UDim2.new(0.42, 0, 0, 0), UDim2.new(0.18, 0, 1, 0), Enum.TextXAlignment.Left)
			v3947("KG", UDim2.new(0.6, 0, 0, 0), UDim2.new(0.18, 0, 1, 0), Enum.TextXAlignment.Right)
			v3947("MONEY/S", UDim2.new(0.78, 0, 0, 0), UDim2.new(0.22, -12, 1, 0), Enum.TextXAlignment.Right)

			local ScrollingFrame = Instance.new("ScrollingFrame")

			ScrollingFrame.Position = UDim2.fromOffset(14, 88)
			ScrollingFrame.Size = UDim2.new(1, -28, 1, -96)
			ScrollingFrame.BackgroundTransparency = 1
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.ScrollBarThickness = 3
			ScrollingFrame.ScrollBarImageColor3 = v3697.accent
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			ScrollingFrame.Parent = p913

			local UIListLayout3 = Instance.new("UIListLayout", ScrollingFrame)

			UIListLayout3.Padding = UDim.new(0, 4)
			UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
			u3884 = ScrollingFrame
			v3891()
			v3896()
			v3768()
		end

		t175.sort = "value"
		t175.rarity = "All"
		t175.picked = {}
		t175.chips = {}
		t175.sortBtns = {}
		t175.modeBtns = {}
		t175.rows = {}
		t175.scan = function()
			local u3951

			pcall(function()
				u3951 = EggState2.ReadFieldEggs()
			end)

			local t185 = {}
			local ipairs_ = ipairs
			local Records = u3951 and u3951.Records or {}

			for _, Record in ipairs_(Records) do
				if Record.State ~= "Claimed" and Record.State ~= "Carried" and not Record.CarrierUserId and Record.BottomCFrame then
					if not tostring(Record.Uid):find("FirstAreaEgg") then
						local AssetCategory = Record.AssetCategory
						local Directory2 = AssetCategory and Assets.Directory and Assets.Directory[AssetCategory]
						local v3959, v3960, v3961 = v3707(AssetCategory)
						local v3962 = v3740({
							AssetCategory = AssetCategory,
							Category = AssetCategory,
							AssetScale = Record.AssetScale or Record.Scale or 1,
							Scale = Record.AssetScale or Record.Scale or 1,
							Mutations = Record.Mutations or {}
						})
						local v3963 = v3744(Record)
						local v3964 = #t185 + 1
						local t186 = {
							rec = Record,
							uid = Record.Uid
						}
						local DisplayName = Directory2 and Directory2.DisplayName

						if not DisplayName then
							DisplayName = tostring(AssetCategory or "Egg")
						end

						t186.name = DisplayName
						t186.rarity = v3960
						t186.rnum = v3959
						t186.color = v3961
						t186.area = tostring(Record.AreaId or "?")
						t186.rate = v3962
						t186.kg = v3963
						t186.icon = v3710(AssetCategory)
						t185[v3964] = t186
					end
				end
			end

			if t175.rarity ~= "All" then
				local t187 = {}

				for _, v in ipairs(t185) do
					if v.rarity == t175.rarity then
						t187[#t187 + 1] = v
					end
				end

				t185 = t187
			end

			table.sort(t185, function(p924, p925)
				if t175.sort == "rarity" then
					if p924.rnum == p925.rnum then
						return (p924.rate or 0) > (p925.rate or 0)
					end

					return (p924.rnum or 0) > (p925.rnum or 0)
				end

				if p924.rate == p925.rate then
					return (p924.rnum or 0) > (p925.rnum or 0)
				end

				return (p924.rate or 0) > (p925.rate or 0)
			end)

			return t185
		end
		t175.paintChips = function()
			for k, chip in pairs(t175.chips) do
				local v3972 = k == t175.rarity

				chip.BackgroundTransparency = v3972 and 0.1 or 0.9
				chip.TextColor3 = v3972 and Color3.fromRGB(255, 255, 255) or chip:GetAttribute("chipColor") and Color3.fromHex(chip:GetAttribute("chipColor")) or v3697.btnText

				local UIStroke = chip:FindFirstChildOfClass("UIStroke")

				if UIStroke then
					UIStroke.Transparency = v3972 and 0 or 0.65
				end
			end

			for k, sortBtn in pairs(t175.sortBtns) do
				local v3976 = k == t175.sort

				sortBtn.BackgroundColor3 = v3976 and v3697.accent or Color3.fromRGB(255, 255, 255)
				sortBtn.BackgroundTransparency = v3976 and 0.12 or 0.9
				sortBtn.TextColor3 = v3976 and Color3.fromRGB(255, 255, 255) or v3697.btnText
			end

			local __SenaV4StealMode = genv.__SenaV4StealMode or "Fly"
			local pairs_2 = pairs
			local modeBtns = t175.modeBtns or {}

			for k, modeBtn in pairs_2(modeBtns) do
				local v3982 = __SenaV4StealMode == k

				modeBtn.BackgroundColor3 = v3982 and v3697.accent or Color3.fromRGB(255, 255, 255)
				modeBtn.BackgroundTransparency = v3982 and 0.12 or 0.9
				modeBtn.TextColor3 = v3982 and Color3.fromRGB(255, 255, 255) or v3697.btnText

				local UIStroke = modeBtn:FindFirstChildOfClass("UIStroke")

				if UIStroke then
					UIStroke.Transparency = v3982 and 0 or 0.7
				end
			end
		end
		t175.paintRows = function()
			local n73 = 0

			for _, row in ipairs(t175.rows) do
				local v3987 = t175.picked[tostring(row.uid)] == true

				if v3987 then
					n73 += 1
				end

				row.frame.BackgroundTransparency = v3987 and 0.02 or 0.14

				local UIStroke = row.frame:FindFirstChildOfClass("UIStroke")

				if UIStroke then
					UIStroke.Transparency = v3987 and 0 or 0.78
				end

				if row.tick then
					row.tick.BackgroundTransparency = v3987 and 0.05 or 0.86
					row.tick.Text = v3987 and "OK" or ""
				end
			end

			if t175.statusBtn and not t175.running then
				t175.statusBtn.Text = n73 > 0 and "Steal Selected (" .. n73 .. ")" or "Steal Selected"
			end

			if t175.headLbl then
				t175.headLbl.Text = n73 > 0 and n73 .. " picked" or "Tap eggs to pick them"
			end
		end
		t175.refresh = function()
			v3698()

			if not t175.list then
				return
			end

			for _, child in ipairs(t175.list:GetChildren()) do
				if child:IsA("Frame") then
					child:Destroy()
				end
			end

			t175.rows = {}

			local v3991 = t175.scan()
			local t188 = {}

			for _, v in ipairs(v3991) do
				t188[tostring(v.uid)] = true
			end

			for k in pairs(t175.picked) do
				if not t188[k] then
					t175.picked[k] = nil
				end
			end

			for i, v in ipairs(v3991) do
				local Frame = Instance.new("Frame")

				Frame.Size = UDim2.new(1, -6, 0, 46)
				Frame.BackgroundColor3 = v3697.surface
				Frame.BackgroundTransparency = 0.14
				Frame.BorderSizePixel = 0
				Frame.LayoutOrder = i
				Frame.Parent = t175.list
				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 7)

				local UIStroke = Instance.new("UIStroke", Frame)

				UIStroke.Color = v.color or v3697.accent
				UIStroke.Thickness = 1
				UIStroke.Transparency = 0.78

				local Frame2 = Instance.new("Frame")

				Frame2.Size = UDim2.new(0, 3, 1, -12)
				Frame2.Position = UDim2.fromOffset(0, 6)
				Frame2.BorderSizePixel = 0
				Frame2.BackgroundColor3 = v.color or v3697.accent
				Frame2.Parent = Frame
				Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)

				local TextLabel5 = Instance.new("TextLabel")

				TextLabel5.Position = UDim2.fromOffset(10, 11)
				TextLabel5.Size = UDim2.fromOffset(24, 24)
				TextLabel5.BackgroundColor3 = v3697.accent
				TextLabel5.BackgroundTransparency = 0.86
				TextLabel5.Font = Enum.Font.GothamBold
				TextLabel5.TextSize = 11
				TextLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel5.Text = ""
				TextLabel5.Parent = Frame
				Instance.new("UICorner", TextLabel5).CornerRadius = UDim.new(0, 5)

				local UIStroke2 = Instance.new("UIStroke", TextLabel5)

				UIStroke2.Color = v3697.accent
				UIStroke2.Thickness = 1
				UIStroke2.Transparency = 0.6

				local ImageLabel = Instance.new("ImageLabel")

				ImageLabel.Position = UDim2.fromOffset(42, 7)
				ImageLabel.Size = UDim2.fromOffset(30, 30)
				ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ImageLabel.BackgroundTransparency = 1
				ImageLabel.BorderSizePixel = 0
				ImageLabel.ScaleType = Enum.ScaleType.Fit
				ImageLabel.Image = v.icon or ""
				ImageLabel.Parent = Frame
				Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 4)

				if not v.icon then
					local Frame3 = Instance.new("Frame")

					Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
					Frame3.Position = UDim2.fromScale(0.5, 0.5)
					Frame3.Size = UDim2.fromOffset(10, 10)
					Frame3.BackgroundColor3 = v.color or v3697.accent
					Frame3.BorderSizePixel = 0
					Frame3.Parent = ImageLabel
					Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0)
				end

				local TextLabel6 = Instance.new("TextLabel")

				TextLabel6.BackgroundTransparency = 1
				TextLabel6.Position = UDim2.fromOffset(78, 6)
				TextLabel6.Size = UDim2.new(1, -184, 0, 17)
				TextLabel6.Font = Enum.Font.GothamBold
				TextLabel6.TextSize = 13
				TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel6.TextTruncate = Enum.TextTruncate.AtEnd
				TextLabel6.TextColor3 = v3697.text
				TextLabel6.Text = tostring(v.name)
				TextLabel6.Parent = Frame

				local TextLabel7 = Instance.new("TextLabel")

				TextLabel7.BackgroundTransparency = 1
				TextLabel7.Position = UDim2.fromOffset(78, 24)
				TextLabel7.Size = UDim2.new(1, -184, 0, 17)
				TextLabel7.Font = Enum.Font.GothamBold
				TextLabel7.TextSize = 11
				TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel7.TextTruncate = Enum.TextTruncate.AtEnd
				TextLabel7.TextColor3 = v.color or v3697.muted
				TextLabel7.Text = string.format("%s  -  %s%s", tostring(v.rarity or "?"), tostring(v.area), v.kg and string.format("  -  %.1fkg", v.kg) or "")
				TextLabel7.Parent = Frame

				local TextLabel8 = Instance.new("TextLabel")

				TextLabel8.BackgroundTransparency = 1
				TextLabel8.AnchorPoint = Vector2.new(1, 0.5)
				TextLabel8.Position = UDim2.new(1, -12, 0.5, 0)
				TextLabel8.Size = UDim2.fromOffset(96, 20)
				TextLabel8.Font = Enum.Font.GothamBold
				TextLabel8.TextSize = 13
				TextLabel8.TextXAlignment = Enum.TextXAlignment.Right
				TextLabel8.TextColor3 = Color3.fromRGB(126, 224, 151)
				TextLabel8.Text = v3703(v.rate) .. "/s"
				TextLabel8.Parent = Frame

				local TextButton = Instance.new("TextButton")

				TextButton.Size = UDim2.fromScale(1, 1)
				TextButton.BackgroundTransparency = 1
				TextButton.Text = ""
				TextButton.AutoButtonColor = false
				TextButton.Parent = Frame

				local v4009 = tostring(v.uid)

				TextButton.MouseButton1Click:Connect(function()
					t175.picked[v4009] = not t175.picked[v4009] or nil
					t175.paintRows()
				end)
				t175.rows[#t175.rows + 1] = {
					uid = v.uid,
					frame = Frame,
					tick = TextLabel5
				}
			end

			if t175.countLbl then
				pcall(function()
					t175.countLbl.Text = #v3991 .. " eggs"
				end)
			end

			pcall(function()
				t175.list.CanvasSize = UDim2.new(0, 0, 0, #v3991 * 50 + 8)
			end)
			pcall(t175.paintChips)
			pcall(t175.paintRows)
		end
		t175.build = function(p926)
			local Frame = Instance.new("Frame")

			Frame.Size = UDim2.fromScale(1, 1)
			Frame.BackgroundTransparency = 1
			Frame.BorderSizePixel = 0
			Frame.Parent = p926
			t175.countLbl = Instance.new("TextLabel")
			t175.countLbl.BackgroundTransparency = 1
			t175.countLbl.AnchorPoint = Vector2.new(1, 0)
			t175.countLbl.Position = UDim2.new(1, -16, 0, 2)
			t175.countLbl.Size = UDim2.fromOffset(110, 18)
			t175.countLbl.Font = Enum.Font.GothamBold
			t175.countLbl.TextSize = 12
			t175.countLbl.TextXAlignment = Enum.TextXAlignment.Right
			t175.countLbl.TextColor3 = v3697.muted
			t175.countLbl.Text = "0 eggs"
			t175.countLbl.Parent = Frame
			t175.headLbl = Instance.new("TextLabel")
			t175.headLbl.BackgroundTransparency = 1
			t175.headLbl.Position = UDim2.fromOffset(14, 2)
			t175.headLbl.Size = UDim2.new(1, -135, 0, 18)
			t175.headLbl.Font = Enum.Font.GothamBold
			t175.headLbl.TextSize = 12
			t175.headLbl.TextXAlignment = Enum.TextXAlignment.Left
			t175.headLbl.TextTruncate = Enum.TextTruncate.AtEnd
			t175.headLbl.TextColor3 = v3697.muted
			t175.headLbl.Text = "Tap eggs to pick them"
			t175.headLbl.Parent = Frame

			local ScrollingFrame = Instance.new("ScrollingFrame")

			ScrollingFrame.Position = UDim2.fromOffset(14, 24)
			ScrollingFrame.Size = UDim2.new(1, -28, 0, 36)
			ScrollingFrame.BackgroundTransparency = 1
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.ScrollBarThickness = 3
			ScrollingFrame.ScrollBarImageColor3 = v3697.accent
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			ScrollingFrame.Parent = Frame

			local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)

			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.Padding = UDim.new(0, 6)
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

			local n74 = 0

			t175.chips = {}

			local function v4014(p927, p928)
				local TextButton = Instance.new("TextButton")
				local v4016 = math.max(48, #p927 * 7 + 16)

				TextButton.Size = UDim2.fromOffset(v4016, 24)
				TextButton.BackgroundColor3 = p928 or v3697.accent
				TextButton.BackgroundTransparency = 0.9
				TextButton.AutoButtonColor = false
				TextButton.Font = Enum.Font.GothamBold
				TextButton.TextSize = 12
				TextButton.TextColor3 = p928 or v3697.btnText
				TextButton.Text = p927

				if p928 then
					TextButton:SetAttribute("chipColor", p928:ToHex())
				end

				local UIStroke = Instance.new("UIStroke", TextButton)

				UIStroke.Color = p928 or v3697.accent
				UIStroke.Thickness = 1
				UIStroke.Transparency = 0.65
				TextButton.Parent = ScrollingFrame
				Instance.new("UICorner", TextButton).CornerRadius = UDim.new(1, 0)
				TextButton.MouseButton1Click:Connect(function()
					t175.rarity = p927
					t175.paintChips()
					t175.refresh()
				end)
				t175.chips[p927] = TextButton
				n74 = n74 + v4016 + 6
			end

			v4014("All", nil)

			for _, v in ipairs(v3736()) do
				local v4020

				for _, v2 in ipairs(t168) do
					if v2.rname == v then
						local _, _, v4025 = v3707(v2.cat)

						v4020 = v4025

						break
					end
				end

				v4014(v, v4020)
			end

			ScrollingFrame.CanvasSize = UDim2.new(0, n74 + 6, 0, 0)

			local Frame2 = Instance.new("Frame")

			Frame2.Position = UDim2.fromOffset(14, 66)
			Frame2.Size = UDim2.new(1, -28, 0, 26)
			Frame2.BackgroundTransparency = 1
			Frame2.Parent = Frame

			local UIListLayout2 = Instance.new("UIListLayout", Frame2)

			UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout2.Padding = UDim.new(0, 6)
			UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
			t175.sortBtns = {}

			local function v4028(p929, p930)
				local TextButton = Instance.new("TextButton")

				TextButton.Size = UDim2.fromOffset(96, 24)
				TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.BackgroundTransparency = 0.9
				TextButton.AutoButtonColor = false
				TextButton.Font = Enum.Font.GothamBold
				TextButton.TextSize = 12
				TextButton.TextColor3 = v3697.btnText
				TextButton.Text = p930
				TextButton.Parent = Frame2
				Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 5)
				TextButton.MouseButton1Click:Connect(function()
					t175.sort = p929
					t175.paintChips()
					t175.refresh()
				end)
				t175.sortBtns[p929] = TextButton
			end

			v4028("value", "Best Value")
			v4028("rarity", "Rarity")

			local TextButton = Instance.new("TextButton")

			TextButton.Size = UDim2.fromOffset(76, 24)
			TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.BackgroundTransparency = 0.9
			TextButton.AutoButtonColor = false
			TextButton.Font = Enum.Font.GothamBold
			TextButton.TextSize = 12
			TextButton.TextColor3 = v3697.btnText
			TextButton.Text = "Clear"
			TextButton.Parent = Frame2
			Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 5)
			TextButton.MouseButton1Click:Connect(function()
				t175.picked = {}
				t175.paintRows()
			end)

			local Frame3 = Instance.new("Frame")

			Frame3.Position = UDim2.fromOffset(14, 96)
			Frame3.Size = UDim2.new(1, -28, 0, 26)
			Frame3.BackgroundTransparency = 1
			Frame3.Parent = Frame

			local UIListLayout3 = Instance.new("UIListLayout", Frame3)

			UIListLayout3.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout3.Padding = UDim.new(0, 4)
			UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center

			local TextLabel5 = Instance.new("TextLabel")

			TextLabel5.Size = UDim2.fromOffset(38, 24)
			TextLabel5.BackgroundTransparency = 1
			TextLabel5.Font = Enum.Font.GothamBold
			TextLabel5.TextSize = 11
			TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel5.TextColor3 = v3697.muted
			TextLabel5.Text = "MOVE"
			TextLabel5.Parent = Frame3
			t175.modeBtns = {}

			local function v4034(p931, p932)
				local TextButton2 = Instance.new("TextButton")

				TextButton2.Size = UDim2.fromOffset(68, 24)
				TextButton2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextButton2.BackgroundTransparency = 0.9
				TextButton2.AutoButtonColor = false
				TextButton2.Font = Enum.Font.GothamBold
				TextButton2.TextSize = 12
				TextButton2.TextColor3 = v3697.btnText
				TextButton2.Text = p931
				TextButton2.Parent = Frame3
				Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 5)

				local UIStroke = Instance.new("UIStroke", TextButton2)

				UIStroke.Color = v3697.accent
				UIStroke.Thickness = 1
				UIStroke.Transparency = 0.7
				TextButton2.MouseButton1Click:Connect(function()
					v3698()
					genv.__SenaV4StealMode = p932
					pcall(function()
						if type(applyStealMode) == "function" then
							applyStealMode(p932)
						end
					end)
					t175.paintChips()
				end)
				t175.modeBtns[p932] = TextButton2
			end

			v4034("Low Speed User", "Instant")
			v4034("High Speed User", "Fly")

			local ScrollingFrame2 = Instance.new("ScrollingFrame")

			ScrollingFrame2.Position = UDim2.fromOffset(14, 128)
			ScrollingFrame2.Size = UDim2.new(1, -28, 1, -188)
			ScrollingFrame2.BackgroundTransparency = 1
			ScrollingFrame2.BorderSizePixel = 0
			ScrollingFrame2.ScrollBarThickness = 3
			ScrollingFrame2.ScrollBarImageColor3 = v3697.accent
			ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
			ScrollingFrame2.Parent = Frame

			local UIListLayout4 = Instance.new("UIListLayout", ScrollingFrame2)

			UIListLayout4.Padding = UDim.new(0, 4)
			UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
			t175.list = ScrollingFrame2

			local Frame4 = Instance.new("Frame")

			Frame4.Position = UDim2.new(0, 14, 1, -52)
			Frame4.Size = UDim2.new(1, -28, 0, 38)
			Frame4.BackgroundTransparency = 1
			Frame4.Parent = Frame

			local TextButton2 = Instance.new("TextButton")

			TextButton2.Size = UDim2.new(0.3, -4, 1, 0)
			TextButton2.BackgroundColor3 = Color3.fromRGB(90, 100, 140)
			TextButton2.BackgroundTransparency = 0.15
			TextButton2.AutoButtonColor = false
			TextButton2.Font = Enum.Font.GothamBold
			TextButton2.TextSize = 13
			TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton2.Text = "Refresh"
			TextButton2.Parent = Frame4
			Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6)
			TextButton2.MouseButton1Click:Connect(function()
				pcall(function()
					EggState2.SyncFieldEggs()
				end)
				t175.refresh()
			end)
			t175.statusBtn = Instance.new("TextButton")
			t175.statusBtn.AnchorPoint = Vector2.new(1, 0)
			t175.statusBtn.Position = UDim2.fromScale(1, 0)
			t175.statusBtn.Size = UDim2.new(0.69, -4, 1, 0)
			t175.statusBtn.BackgroundColor3 = v3697.accent
			t175.statusBtn.BackgroundTransparency = 0.12
			t175.statusBtn.AutoButtonColor = false
			t175.statusBtn.Font = Enum.Font.GothamBold
			t175.statusBtn.TextSize = 13
			t175.statusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			t175.statusBtn.Text = "Steal Selected"
			t175.statusBtn.Parent = Frame4
			Instance.new("UICorner", t175.statusBtn).CornerRadius = UDim.new(0, 6)
			t175.statusBtn.MouseButton1Click:Connect(function()
				if t175.running then
					return
				end

				local t189 = {}

				for k in pairs(t175.picked) do
					table.insert(t189, k)
				end

				if #t189 == 0 then
					t175.statusBtn.Text = "Pick an egg first"
					task.delay(1.5, function()
						if t175.statusBtn and not t175.running then
							t175.paintRows()
						end
					end)

					return
				end

				local __SenaV4EggRuntime = genv.__SenaV4EggRuntime

				if __SenaV4EggRuntime and type(__SenaV4EggRuntime.queueManual) == "function" then
					local v4044 = __SenaV4EggRuntime:queueManual(t189)

					t175.picked = {}
					t175.statusBtn.Text = "Queued " .. v4044
					task.delay(1.5, function()
						if t175.statusBtn and not t175.running then
							t175.paintRows()
						end
					end)
					t175.refresh()
				else
					t175.statusBtn.Text = "Runtime not ready"
					task.delay(1.5, function()
						if t175.statusBtn and not t175.running then
							t175.paintRows()
						end
					end)
				end
			end)
			t175.paintChips()
			t175.refresh()
		end

		local function v4045(p933)
			if not p933 or type(p933) ~= "string" then
				return "unknown"
			end

			local v4046 = p933:lower()

			if v4046:find("kong") or v4046:find("gorilla") then
				return "gorillaking"
			end

			if v4046:find("phoenix") then
				return "phoenix"
			end

			if v4046:find("lunar") or v4046:find("dragon.-lunar") then
				return "lunardragon"
			end

			if v4046:find("mosa") then
				return "mosasaurus"
			end

			if v4046:find("tiger") or v4046:find("oni") then
				return "onitiger"
			end

			if v4046:find("kitsune") then
				return "kitsune"
			end

			if v4046:find("unicorn") then
				return "unicorn"
			end

			if v4046:find("godzilla") then
				return "godzilla"
			end

			if v4046:find("pegasus") then
				return "pegasus"
			end

			if v4046:find("archangel") then
				return "archangel"
			end

			if v4046:find("ice.-dragon") then
				return "icedragon"
			end

			if v4046:find("lava.-dragon") or v4046:find("dragon") then
				return "lavadragon"
			end

			if v4046:find("cosmic.-dragon") or v4046:find("ember") then
				return "cosmicdragon"
			end

			if v4046:find("trex") or v4046:find("tyranno") or v4046:find("t%-rex") then
				return "trex"
			end

			if v4046:find("gargoyle") then
				return "gargoyle"
			end

			if v4046:find("cerberus") then
				return "cerberus"
			end

			if v4046:find("yeti") then
				return "yeti"
			end

			if v4046:find("dreadscale") then
				return "dreadscale"
			end

			if v4046:find("el.-maja") then
				return "elmaja"
			end

			return (v4046:gsub("eternal", ""):gsub("ascended", ""):gsub("vermilion", ""):gsub("divine", ""):gsub("secret", ""):gsub("egg", ""):gsub("[^%a%d]", ""))
		end
		local function v4047(p934)
			if not p934 or p934 <= 0 then
				return 0
			end

			return math.floor((p934 + 150) / 300) * 300
		end
		local function v4048(p935, p936)
			if not p935 or p935 <= 0 then
				return "--:--"
			end

			local now = os.time()
			local v4050 = os.date("*t", now)
			local v4051 = os.date("*t", p935)
			local s16

			if v4051.year == v4050.year and v4051.yday == v4050.yday then
				s16 = "Today"
			elseif v4051.year == v4050.year and v4051.yday == v4050.yday - 1 then
				s16 = "Yesterday"
			elseif v4051.year == v4050.year and v4051.yday == v4050.yday + 1 then
				s16 = "Tomorrow"
			else
				s16 = string.format("%02d/%02d", v4051.month, v4051.day)
			end

			if p936 then
				return string.format("%s %02d:%02d:%02d", s16, v4051.hour, v4051.min, v4051.sec)
			end

			return string.format("%s %02d:%02d", s16, v4051.hour, v4051.min)
		end
		local function v4053(p937)
			if not p937 or p937 <= 0 then
				return ""
			end

			local v4054 = os.time() - p937

			if v4054 < 0 then
				local v4055 = -v4054

				if v4055 < 60 then
					return "in <1m"
				end

				if v4055 < 3600 then
					return string.format("in %dm", math.floor(v4055 / 60))
				end

				return string.format("in %.1fh", v4055 / 3600)
			end

			if v4054 < 60 then
				return "Just now"
			end

			if v4054 < 3600 then
				return string.format("%dm ago", math.floor(v4054 / 60))
			end

			if v4054 < 86400 then
				return string.format("%.1fh ago", v4054 / 3600)
			end

			return string.format("%.1fd ago", v4054 / 86400)
		end
		local function v4056(p938, p939)
			local v4057 = v4047(p938)
			local v4058 = v4047(p939)
			local now = os.time()
			local v4060 = os.date("*t", now)
			local v4061 = os.date("*t", v4057)
			local v4062 = os.date("*t", v4058)

			local function v4063(p940)
				if p940.year == v4060.year and p940.yday == v4060.yday then
					return "Today"
				end

				if p940.year == v4060.year and p940.yday == v4060.yday + 1 then
					return "Tomorrow"
				end

				if p940.year == v4060.year and p940.yday == v4060.yday - 1 then
					return "Yesterday"
				end

				return string.format("%02d/%02d", p940.month, p940.day)
			end

			local v4064 = v4063(v4061)
			local v4065 = v4063(v4062)

			if v4064 == v4065 then
				return string.format("%s %02d:%02d - %02d:%02d", v4064, v4061.hour, v4061.min, v4062.hour, v4062.min)
			end

			return string.format("%s %02d:%02d - %s %02d:%02d", v4064, v4061.hour, v4061.min, v4065, v4062.hour, v4062.min)
		end

		local t190 = {
			Mosasaurus = "rbxassetid://124293259998827",
			["Oni Tiger"] = "rbxassetid://109908891899435",
			["Eternal Lunar Dragon"] = "rbxassetid://93762296316916",
			["Lunar Dragon"] = "rbxassetid://93762296316916",
			["King Kong"] = "rbxassetid://135650224014044",
			["Gorilla King"] = "rbxassetid://135650224014044",
			["Ice Dragon"] = "rbxassetid://101397684798718",
			Phoenix = "rbxassetid://118067990008425",
			["Ascended Vermilion Phoenix"] = "rbxassetid://118067990008425",
			Dragon = "rbxassetid://78935088838538",
			["Lava Dragon"] = "rbxassetid://78935088838538",
			["Dragon (Lava)"] = "rbxassetid://78935088838538",
			Pegasus = "rbxassetid://112830316982322",
			["El Maja"] = "rbxassetid://77518688092604",
			Kitsune = "rbxassetid://107842067813602",
			Unicorn = "rbxassetid://70463817382627",
			Godzilla = "rbxassetid://102979882140882",
			ArchAngel = "rbxassetid://113289118499426",
			["Cosmic Dragon"] = "rbxassetid://107923370723949",
			TRex = "rbxassetid://124293259998827",
			Gargoyle = "rbxassetid://137949993315884",
			["King Snake"] = "rbxassetid://77518688092604"
		}
		local t191 = {}

		local function v4068(p941)
			if not p941 then
				return ""
			end

			if t190[p941] then
				return t190[p941]
			end

			if t191[p941] ~= nil then
				return t191[p941]
			end

			t191[p941] = v3710(p941) or ""

			return t191[p941]
		end
		local function v4069(p942)
			local request_ = syn and syn.request or http and http.request or request or http_request

			if request_ then
				local u4071

				if pcall(function()
					u4071 = request_(p942)
				end) and u4071 then
					return u4071
				end
			end

			if p942.Method == "GET" and game and game.HttpGet then
				local response

				if pcall(function()
					response = game:HttpGet(p942.Url, true)
				end) and response then
					return {
						StatusCode = 200,
						Body = response
					}
				end
			end

			return nil
		end

		local t192 = {
			{
				id = "eternal_fast",
				title = "Eternal",
				cycleLabel = "45 - 90m",
				rarity = "Eternal",
				windowMin = 45,
				windowMax = 90,
				priority = 1,
				color = Color3.fromRGB(255, 215, 0),
				candidates = {
					{
						name = "Mosasaurus",
						area = "Prehistoric",
						chance = "10.85%",
						icon = "rbxassetid://124293259998827"
					},
					{
						name = "Oni Tiger",
						area = "Cherry Blossom",
						chance = "10.85%",
						icon = "rbxassetid://109908891899435"
					},
					{
						name = "Lunar Dragon",
						area = "Cosmic",
						chance = "10.85%",
						icon = "rbxassetid://93762296316916"
					},
					{
						name = "Gorilla King",
						area = "Titan Temple",
						chance = "10.85%",
						icon = "rbxassetid://135650224014044"
					},
					{
						name = "Ice Dragon",
						area = "Snow",
						chance = "10.85%",
						icon = "rbxassetid://101397684798718"
					},
					{
						name = "Phoenix",
						area = "Volcano",
						chance = "10.85%",
						icon = "rbxassetid://118067990008425"
					}
				}
			},
			{
				id = "divine_fast",
				title = "Divine",
				cycleLabel = "1.5 - 3h",
				rarity = "Divine",
				windowMinH = 1.5,
				windowMaxH = 3,
				priority = 2,
				color = Color3.fromRGB(255, 255, 255),
				candidates = {
					{
						name = "Kitsune",
						area = "Cherry Blossom",
						chance = "20%",
						icon = "rbxassetid://107842067813602"
					},
					{
						name = "ArchAngel",
						area = "Heaven",
						chance = "20%",
						icon = "rbxassetid://113289118499426"
					},
					{
						name = "Godzilla",
						area = "Prehistoric",
						chance = "20%",
						icon = "rbxassetid://102979882140882"
					},
					{
						name = "Pegasus",
						area = "Fantasy",
						chance = "20%",
						icon = "rbxassetid://112830316982322"
					},
					{
						name = "Unicorn",
						area = "Magical Forest",
						chance = "20%",
						icon = "rbxassetid://70463817382627"
					}
				}
			}
		}

		local function v4074(p943)
			if not p943 or not p943.name then
				return false
			end

			local now = tonumber(p943.ts) or os.time()

			p943.ts = now

			local v4076 = (p943.rarity or ""):lower()

			if v4076 ~= "eternal" and v4076 ~= "divine" then
				return false
			end

			local v4077 = v4045(p943.name)

			for _, v in ipairs(t176.history) do
				if v.uid and p943.uid and v.uid == p943.uid then
					return false
				end

				if v4045(v.name) ~= v4077 then
					continue
				end

				if not (math.abs((v.ts or 0) - now) < 600) then
					continue
				end

				return false
			end

			table.insert(t176.history, p943)
			table.sort(t176.history, function(p944, p945)
				return (p944.ts or 0) > (p945.ts or 0)
			end)

			if v4076 == "eternal" then
				if not t176.lastEternal then
					t176.lastEternal = p943
				elseif (t176.lastEternal.ts or 0) <= now then
					t176.lastEternal = p943

					return true
				end
			elseif v4076 == "divine" then
				if not t176.lastDivine then
					t176.lastDivine = p943
				elseif (t176.lastDivine.ts or 0) <= now then
					t176.lastDivine = p943

					return true
				end
			end

			return true
		end

		t176.getLatestSpawn = function(p946, p947)
			for _, v in ipairs(t176.history) do
				if p946 and (not v.rarity or v.rarity:lower() ~= p946:lower()) then
					continue
				end

				if not p947 or not (#p947 > 0) then
					return v
				end

				local v4082 = v4045(v.name)

				for _, v2 in ipairs(p947) do
					if v4045(v2.name) == v4082 then
						return v
					end
				end
			end

			return nil
		end

		for _, v in ipairs({
			{
				uid = "afad935fc39f4ad0a28d83d74dad60f8",
				name = "Ice Dragon",
				area = "Snow",
				rarity = "Eternal",
				ts = 1789738200,
				reporter = "Server Alert"
			},
			{
				uid = "aac1107e3c3a428c93ecc8d5c4c03296",
				name = "Mosasaurus",
				area = "Prehistoric",
				rarity = "Eternal",
				ts = 1789735200,
				reporter = "Server Alert"
			},
			{
				uid = "2f08670c03054614b5c088092e0eab9e",
				name = "Eternal Lunar Dragon",
				area = "Cosmic",
				rarity = "Eternal",
				ts = 1789733400,
				reporter = "Server Alert"
			},
			{
				uid = "d2c1c02c35224ca78eddeda7128643a6",
				name = "Skeleton Horse",
				area = "Light Dark",
				rarity = "Eternal",
				ts = 1789731600,
				reporter = "Server Alert"
			},
			{
				uid = "a9f84b4645bd4d23a2a8887923febe6e",
				name = "Gorilla King",
				area = "Titan Temple",
				rarity = "Eternal",
				ts = 1789729800,
				reporter = "Server Alert"
			},
			{
				uid = "seed_divine_1",
				name = "Kitsune",
				area = "Cherry Blossom",
				rarity = "Divine",
				ts = 1789678800,
				reporter = "Server Alert"
			}
		}) do
			v4074(v)
		end

		local function v4087(p948)
			if not p948 or type(p948) ~= "string" then
				return nil
			end

			if not p948:find("spawned in") then
				return nil
			end

			local v4088 = p948:gsub("<[^>]+>", ""):gsub("[%c]", "")
			local match, match2, v4091 = v4088:match("A%s+(%a+)%s+(.-)%s+Egg%s+spawned%s+in%s+([^!]+)")

			if not match or not match2 or not v4091 then
				match2, match, v4091 = v4088:match("([%w%s]+)%s*%((%a+)%)%s+has%s+spawned%s+in%s+([^!]+)")
			end

			if not match or not match2 or not v4091 then
				return nil
			end

			local v4092 = v4091:gsub("%s+$", ""):gsub("^%s+", "")
			local v4093 = match2:gsub("%s+$", ""):gsub("^%s+", "")

			return match:gsub("%s+$", ""):gsub("^%s+", ""), v4093, v4092
		end
		local function v4094(p949)
			local v4095, v4096, v4097 = v4087(p949)

			if not v4095 or not v4096 or not v4097 then
				return
			end

			local now = os.time()
			local v4099 = v4045(v4096)
			local v4100 = math.floor(now / 300)
			local v4101 = string.format("alert_%s_%s_%d", v4099, v4097:lower(), v4100)

			if t176.reportedUids[v4101] then
				return
			end

			t176.reportedUids[v4101] = now
			t176.lastAlert = {
				pet = v4096,
				area = v4097,
				rarity = v4095,
				ts = now,
				norm = v4099
			}

			if v4074({
				uid = v4101,
				name = v4096,
				area = v4097,
				rarity = v4095,
				ts = now,
				reporter = "Server Alert"
			}) then
				pcall(t176.paint)
			end
		end

		t176.reportSpawn = function(p950, p951, p952, p953, p954)
			if not p950 or t176.reportedUids[p950] then
				return
			end

			local now = os.time()
			local v4103 = tonumber(p954) or now

			if now - t176.lastReportTime < 3 then
				return
			end

			t176.reportedUids[p950] = v4103
			t176.lastReportTime = now

			local Name = LocalPlayer and LocalPlayer.Name or "Player"

			if v4074({
				uid = tostring(p950),
				name = p951,
				area = p952,
				rarity = p953,
				ts = v4103,
				reporter = Name
			}) then
				pcall(t176.paint)
			end
		end
		t176.syncBackend = function()
			local now = os.time()

			if now - t176.lastSync < 10 then
				return
			end

			t176.lastSync = now
			task.spawn(function()
				local SenaBackend = getgenv and getgenv().SenaBackend or {}
				local Api = SenaBackend.Api or "http://56.10.112.179:8080"
				local Key = SenaBackend.Key or ""
				local v4109 = LocalPlayer and tostring(LocalPlayer.UserId) or "0"
				local v4110 = v4069({
					Url = Api .. "/egg/latest?key=" .. tostring(Key) .. "&uid=" .. tostring(v4109) .. "&t=" .. tostring(now),
					Method = "GET"
				})

				if v4110 and (v4110.StatusCode == 200 or v4110.Status == 200) and v4110.Body then
					local HttpService2 = game:GetService("HttpService")
					local ok, result = pcall(function()
						return HttpService2:JSONDecode(v4110.Body)
					end)

					if ok and type(result) == "table" and result.ok then
						if result.last_eternal and type(result.last_eternal) == "table" and result.last_eternal.name then
							v4074(result.last_eternal)
						end

						if result.last_divine and type(result.last_divine) == "table" and result.last_divine.name then
							v4074(result.last_divine)
						end

						if type(result.recent_spawns) == "table" then
							for _, recentSpawn in ipairs(result.recent_spawns) do
								v4074(recentSpawn)
							end
						end

						pcall(t176.paint)
					end
				end
			end)
		end
		t176.scanField = function()
			local u4116

			pcall(function()
				u4116 = EggState2.ReadFieldEggs()
			end)

			if not u4116 or not u4116.Records then
				return
			end

			local now = os.time()

			if not t176._fieldInitialized then
				t176._fieldInitialized = true

				for _, record in ipairs(u4116.Records) do
					if record.Uid then
						t176.knownFieldUids[record.Uid] = true
					end
				end

				return
			end

			for _, record in ipairs(u4116.Records) do
				if record.Uid and not t176.knownFieldUids[record.Uid] then
					t176.knownFieldUids[record.Uid] = true

					if record.State ~= "Claimed" and record.BottomCFrame then
						local AssetCategory = record.AssetCategory
						local _, v4124 = v3707(AssetCategory)

						if v4124 == "Divine" or v4124 == "Eternal" then
							local v4125 = AssetCategory == "King Kong" and "Gorilla King" or AssetCategory == "Ascended Vermilion Phoenix" and "Phoenix" or AssetCategory
							local ts = now

							if t176.lastAlert then
								if now - (t176.lastAlert.ts or 0) <= 60 and v4045(t176.lastAlert.pet) == v4045(v4125) then
									if t176.lastAlert.area:lower() == (record.AreaId or ""):lower() then
										ts = t176.lastAlert.ts
									end
								end
							end

							t176.reportSpawn(record.Uid, v4125, record.AreaId or "Field", v4124, ts)
						end
					end
				end
			end
		end
		t176.paint = function()
			v3698()

			if not t176.list or not t176.list.Parent then
				return
			end

			for _, child in ipairs(t176.list:GetChildren()) do
				if child:IsA("Frame") then
					child:Destroy()
				end
			end

			local now = os.time()
			local eternal = t176.getLatestSpawn("eternal")
			local divine = t176.getLatestSpawn("divine")
			local ts = eternal and eternal.ts or 1789738200
			local ts2 = divine and divine.ts or 1789678800

			if t176.catBtnTargets and t176.catBtnHistory then
				local v4134 = t176.category == "targets"

				t176.catBtnTargets.BackgroundColor3 = v4134 and v3697.accent or Color3.fromRGB(24, 26, 36)
				t176.catBtnTargets.TextColor3 = v4134 and Color3.fromRGB(255, 255, 255) or v3697.btnText

				local UIStroke = t176.catBtnTargets:FindFirstChildOfClass("UIStroke")

				if UIStroke then
					UIStroke.Color = v4134 and v3697.accent or v3697.strokeCol
				end

				t176.catBtnHistory.BackgroundColor3 = not v4134 and v3697.accent or Color3.fromRGB(24, 26, 36)
				t176.catBtnHistory.TextColor3 = not v4134 and Color3.fromRGB(255, 255, 255) or v3697.btnText

				local UIStroke2 = t176.catBtnHistory:FindFirstChildOfClass("UIStroke")

				if UIStroke2 then
					UIStroke2.Color = not v4134 and v3697.accent or v3697.strokeCol
				end
			end

			if t176.noticeBox then
				t176.noticeBox.Visible = t176.category == "targets"
			end

			if t176.summaryBox then
				t176.summaryBox.Visible = t176.category == "history"

				if t176.summaryText and t176.category == "history" then
					local v4137 = eternal
					local name = v4137 and v4137.name or "Phoenix"
					local area = v4137 and v4137.area or "Volcano"
					local ts3 = v4137 and v4137.ts or ts
					local v4141 = v4048(ts3, true)
					local v4142 = v4053(ts3)
					local v4143 = divine
					local name2 = v4143 and v4143.name or "Kitsune"
					local area2 = v4143 and v4143.area or "Cherry Blossom"
					local ts4 = v4143 and v4143.ts or ts2
					local v4147 = v4048(ts4, true)
					local v4148 = v4053(ts4)

					t176.summaryText.Text = string.format("<b>LAST ETERNAL:</b> <font color='#ffd700'><b>%s</b></font> (%s) - %s <font color='#8899aa'>(%s)</font>\n<b>LAST DIVINE:</b> <font color='#ffffff'><b>%s</b></font> (%s) - %s <font color='#8899aa'>(%s)</font>", name, area, v4141, v4142, name2, area2, v4147, v4148)
				end
			end

			if t176.refreshBtn then
				t176.refreshBtn.Text = t176.category == "targets" and "Refresh Targets" or "Refresh History"
			end

			if t176.category == "targets" then
				local n75 = 0

				for i, v in ipairs(t192) do
					if t176.filter == "All" or t176.filter == v.rarity then
						n75 += 1

						local divine2 = t176.getLatestSpawn(v.rarity, v.candidates) or eternal

						if v.rarity == "Divine" then
							divine2 = t176.getLatestSpawn("divine") or divine
						end

						local ts3 = divine2 and divine2.ts or v.rarity == "Divine" and ts2 or ts
						local v4154 = v.windowMinH and v.windowMinH * 3600

						if not v4154 then
							v4154 = (v.windowMin or 45) * 60
						end

						local v4155 = v.windowMaxH and v.windowMaxH * 3600

						if not v4155 then
							v4155 = (v.windowMax or 90) * 60
						end

						local v4156 = v4155 - v4154
						local v4157 = ts3 + v4154
						local v4158 = ts3 + v4155

						if v.rarity == "Eternal" and v4154 * 0.75 < now - v4158 then
							while v4154 * 0.75 < now - v4158 do
								v4157 = v4158 + v4154
								v4158 = v4157 + v4156
							end
						end

						local v4159 = v4047(v4157)
						local v4160 = v4047(v4158)
						local text = "UPCOMING"
						local color3 = Color3.fromRGB(100, 200, 255)

						if v4160 < now then
							local v4163 = math.ceil((now - v4160) / 60)

							text = v4163 >= 60 and string.format("OVERDUE +%.1fh", v4163 / 60) or string.format("OVERDUE +%dm", v4163)
							color3 = Color3.fromRGB(255, 0, 128)
						elseif v4159 <= now and now <= v4160 then
							text = "IN WINDOW"
							color3 = Color3.fromRGB(0, 255, 136)
						else
							local v4164 = math.ceil((v4159 - now) / 60)

							if v4164 > 0 and v4164 < 60 then
								text = string.format("IN %dm", v4164)
								color3 = Color3.fromRGB(80, 210, 255)
							elseif v4164 >= 60 then
								text = string.format("IN %.1fh", v4164 / 60)
								color3 = Color3.fromRGB(80, 210, 255)
							end
						end

						local Frame = Instance.new("Frame")

						Frame.Size = UDim2.new(1, -6, 0, 122)
						Frame.BackgroundColor3 = v3697.surface
						Frame.BackgroundTransparency = 0.15
						Frame.BorderSizePixel = 0
						Frame.LayoutOrder = i
						Frame.Parent = t176.list
						Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

						local UIStroke = Instance.new("UIStroke", Frame)

						UIStroke.Color = v.color or v3697.accent
						UIStroke.Thickness = 1
						UIStroke.Transparency = 0.78

						local Frame2 = Instance.new("Frame")

						Frame2.Size = UDim2.new(0, 4, 1, -12)
						Frame2.Position = UDim2.fromOffset(0, 6)
						Frame2.BorderSizePixel = 0
						Frame2.BackgroundColor3 = v.color or v3697.accent
						Frame2.Parent = Frame
						Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)

						local TextLabel5 = Instance.new("TextLabel")

						TextLabel5.BackgroundTransparency = 1
						TextLabel5.Position = UDim2.fromOffset(12, 6)
						TextLabel5.Size = UDim2.new(0.5, 0, 0, 16)
						TextLabel5.Font = Enum.Font.GothamBold
						TextLabel5.TextSize = 13
						TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
						TextLabel5.TextColor3 = v.color or Color3.fromRGB(255, 255, 255)
						TextLabel5.Text = string.format("%s Window (%s)", v.title, v.cycleLabel)
						TextLabel5.Parent = Frame

						local TextLabel6 = Instance.new("TextLabel")

						TextLabel6.Position = UDim2.new(1, -12, 0, 6)
						TextLabel6.AnchorPoint = Vector2.new(1, 0)
						TextLabel6.Size = UDim2.fromOffset(math.max(76, #text * 7 + 14), 18)
						TextLabel6.BackgroundColor3 = color3
						TextLabel6.BackgroundTransparency = 0.2
						TextLabel6.Font = Enum.Font.GothamBold
						TextLabel6.TextSize = 10
						TextLabel6.TextColor3 = Color3.fromRGB(255, 255, 255)
						TextLabel6.Text = text
						TextLabel6.Parent = Frame
						Instance.new("UICorner", TextLabel6).CornerRadius = UDim.new(0, 4)

						local TextLabel7 = Instance.new("TextLabel")

						TextLabel7.BackgroundTransparency = 1
						TextLabel7.Position = UDim2.fromOffset(12, 24)
						TextLabel7.Size = UDim2.new(1, -24, 0, 14)
						TextLabel7.Font = Enum.Font.GothamMedium
						TextLabel7.TextSize = 10
						TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
						TextLabel7.TextColor3 = Color3.fromRGB(150, 180, 220)
						TextLabel7.Text = string.format("Window: %s", v4056(v4159, v4160))
						TextLabel7.Parent = Frame

						local ScrollingFrame = Instance.new("ScrollingFrame")

						ScrollingFrame.Position = UDim2.fromOffset(12, 42)
						ScrollingFrame.Size = UDim2.new(1, -24, 0, 72)
						ScrollingFrame.BackgroundTransparency = 1
						ScrollingFrame.BorderSizePixel = 0
						ScrollingFrame.ScrollBarThickness = 2
						ScrollingFrame.ScrollBarImageColor3 = v.color or v3697.accent
						ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
						ScrollingFrame.CanvasSize = UDim2.new(0, #v.candidates * 64 + 4, 0, 0)
						ScrollingFrame.Parent = Frame

						local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)

						UIListLayout.FillDirection = Enum.FillDirection.Horizontal
						UIListLayout.Padding = UDim.new(0, 6)

						for _, candidate in ipairs(v.candidates) do
							local Frame3 = Instance.new("Frame")

							Frame3.Size = UDim2.fromOffset(58, 68)
							Frame3.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
							Frame3.BackgroundTransparency = 0.3
							Frame3.BorderSizePixel = 0
							Frame3.Parent = ScrollingFrame
							Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 6)

							local UIStroke2 = Instance.new("UIStroke", Frame3)

							UIStroke2.Color = v.color or v3697.strokeCol
							UIStroke2.Thickness = 1
							UIStroke2.Transparency = 0.75

							local ImageLabel = Instance.new("ImageLabel")

							ImageLabel.Position = UDim2.fromOffset(15, 4)
							ImageLabel.Size = UDim2.fromOffset(28, 28)
							ImageLabel.BackgroundColor3 = Color3.fromRGB(30, 34, 46)
							ImageLabel.BackgroundTransparency = 0.4
							ImageLabel.BorderSizePixel = 0
							ImageLabel.ScaleType = Enum.ScaleType.Fit
							ImageLabel.Image = candidate.icon or v4068(candidate.name)
							ImageLabel.Parent = Frame3
							Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 4)

							local TextLabel8 = Instance.new("TextLabel")

							TextLabel8.Position = UDim2.new(0, 1, 0, 34)
							TextLabel8.Size = UDim2.new(1, -2, 0, 12)
							TextLabel8.BackgroundTransparency = 1
							TextLabel8.Font = Enum.Font.GothamBold
							TextLabel8.TextSize = 8
							TextLabel8.TextTruncate = Enum.TextTruncate.AtEnd
							TextLabel8.TextColor3 = Color3.fromRGB(230, 235, 245)
							TextLabel8.TextXAlignment = Enum.TextXAlignment.Center
							TextLabel8.Text = candidate.name
							TextLabel8.Parent = Frame3

							local TextLabel9 = Instance.new("TextLabel")

							TextLabel9.Position = UDim2.new(0, 1, 0, 46)
							TextLabel9.Size = UDim2.new(1, -2, 0, 11)
							TextLabel9.BackgroundTransparency = 1
							TextLabel9.Font = Enum.Font.GothamMedium
							TextLabel9.TextSize = 7
							TextLabel9.TextTruncate = Enum.TextTruncate.AtEnd
							TextLabel9.TextColor3 = v3697.muted
							TextLabel9.TextXAlignment = Enum.TextXAlignment.Center
							TextLabel9.Text = candidate.area
							TextLabel9.Parent = Frame3

							local TextLabel10 = Instance.new("TextLabel")

							TextLabel10.Position = UDim2.new(0, 1, 0, 58)
							TextLabel10.Size = UDim2.new(1, -2, 0, 11)
							TextLabel10.BackgroundTransparency = 1
							TextLabel10.Font = Enum.Font.GothamBold
							TextLabel10.TextSize = 8
							TextLabel10.TextColor3 = Color3.fromRGB(255, 185, 0)
							TextLabel10.TextXAlignment = Enum.TextXAlignment.Center
							TextLabel10.Text = candidate.chance
							TextLabel10.Parent = Frame3
						end
					end
				end

				t176.list.CanvasSize = UDim2.new(0, 0, 0, n75 * 128 + 10)
			else
				local t193 = {}

				for _, v in ipairs(t176.history) do
					if t176.filter == "All" or t176.filter == v.rarity then
						local _, _, v4186 = v3707(v.name)

						table.insert(t193, {
							name = v.name,
							area = v.area,
							rarity = v.rarity,
							subText1 = string.format("[%s] - %s", (v.rarity or "Eternal"):upper(), v.area or "Field"),
							subText2 = string.format("Source: %s", v.reporter or "Server Alert"),
							rateText = v4048(v.ts, false),
							badge = v4053(v.ts),
							badgeColor = Color3.fromRGB(0, 255, 136),
							color = v4186 or v.rarity == "Divine" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 215, 0),
							icon = v4068(v.name),
							order = 1e10 - (v.ts or 0)
						})
					end
				end

				for i, v in ipairs(t193) do
					local Frame = Instance.new("Frame")

					Frame.Size = UDim2.new(1, -6, 0, 54)
					Frame.BackgroundColor3 = v3697.surface
					Frame.BackgroundTransparency = 0.15
					Frame.BorderSizePixel = 0
					Frame.LayoutOrder = i
					Frame.Parent = t176.list
					Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

					local UIStroke = Instance.new("UIStroke", Frame)

					UIStroke.Color = v.color or v3697.accent
					UIStroke.Thickness = 1
					UIStroke.Transparency = 0.78

					local Frame2 = Instance.new("Frame")

					Frame2.Size = UDim2.new(0, 4, 1, -12)
					Frame2.Position = UDim2.fromOffset(0, 6)
					Frame2.BorderSizePixel = 0
					Frame2.BackgroundColor3 = v.color or v3697.accent
					Frame2.Parent = Frame
					Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)

					local ImageLabel = Instance.new("ImageLabel")

					ImageLabel.Position = UDim2.fromOffset(10, 8)
					ImageLabel.Size = UDim2.fromOffset(38, 38)
					ImageLabel.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
					ImageLabel.BackgroundTransparency = 0.4
					ImageLabel.BorderSizePixel = 0
					ImageLabel.ScaleType = Enum.ScaleType.Fit
					ImageLabel.Image = v.icon or ""
					ImageLabel.Parent = Frame
					Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, 6)

					local TextLabel5 = Instance.new("TextLabel")

					TextLabel5.BackgroundTransparency = 1
					TextLabel5.Position = UDim2.fromOffset(56, 6)
					TextLabel5.Size = UDim2.new(1, -165, 0, 16)
					TextLabel5.Font = Enum.Font.GothamBold
					TextLabel5.TextSize = 12
					TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
					TextLabel5.TextTruncate = Enum.TextTruncate.AtEnd
					TextLabel5.TextColor3 = v3697.text
					TextLabel5.Text = v.name
					TextLabel5.Parent = Frame

					local TextLabel6 = Instance.new("TextLabel")

					TextLabel6.BackgroundTransparency = 1
					TextLabel6.Position = UDim2.fromOffset(56, 22)
					TextLabel6.Size = UDim2.new(1, -165, 0, 14)
					TextLabel6.Font = Enum.Font.GothamMedium
					TextLabel6.TextSize = 10
					TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
					TextLabel6.TextTruncate = Enum.TextTruncate.AtEnd
					TextLabel6.TextColor3 = v3697.muted
					TextLabel6.Text = v.subText1
					TextLabel6.Parent = Frame

					local TextLabel7 = Instance.new("TextLabel")

					TextLabel7.BackgroundTransparency = 1
					TextLabel7.Position = UDim2.fromOffset(56, 36)
					TextLabel7.Size = UDim2.new(1, -165, 0, 13)
					TextLabel7.Font = Enum.Font.GothamMedium
					TextLabel7.TextSize = 9
					TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
					TextLabel7.TextTruncate = Enum.TextTruncate.AtEnd
					TextLabel7.TextColor3 = Color3.fromRGB(150, 180, 220)
					TextLabel7.Text = v.subText2
					TextLabel7.Parent = Frame

					local Frame3 = Instance.new("Frame")

					Frame3.BackgroundTransparency = 1
					Frame3.AnchorPoint = Vector2.new(1, 0.5)
					Frame3.Position = UDim2.new(1, -8, 0.5, 0)
					Frame3.Size = UDim2.fromOffset(105, 38)
					Frame3.Parent = Frame

					local TextLabel8 = Instance.new("TextLabel")

					TextLabel8.BackgroundTransparency = 1
					TextLabel8.Size = UDim2.new(1, 0, 0, 18)
					TextLabel8.Font = Enum.Font.GothamBold
					TextLabel8.TextSize = 11
					TextLabel8.TextXAlignment = Enum.TextXAlignment.Right
					TextLabel8.TextTruncate = Enum.TextTruncate.AtEnd
					TextLabel8.TextColor3 = v.badgeColor
					TextLabel8.Text = string.format("[%s]", v.badge)
					TextLabel8.Parent = Frame3

					local TextLabel9 = Instance.new("TextLabel")

					TextLabel9.BackgroundTransparency = 1
					TextLabel9.Position = UDim2.new(0, 0, 0, 18)
					TextLabel9.Size = UDim2.new(1, 0, 0, 16)
					TextLabel9.Font = Enum.Font.GothamBold
					TextLabel9.TextSize = 10
					TextLabel9.TextXAlignment = Enum.TextXAlignment.Right
					TextLabel9.TextTruncate = Enum.TextTruncate.AtEnd
					TextLabel9.TextColor3 = Color3.fromRGB(170, 185, 210)
					TextLabel9.Text = v.rateText
					TextLabel9.Parent = Frame3
				end

				t176.list.CanvasSize = UDim2.new(0, 0, 0, #t193 * 58 + 10)
			end
		end
		t176.build = function(p955)
			local Frame = Instance.new("Frame")

			Frame.Size = UDim2.fromScale(1, 1)
			Frame.BackgroundTransparency = 1
			Frame.BorderSizePixel = 0
			Frame.Parent = p955
			t176.headLbl = Instance.new("TextLabel")
			t176.headLbl.BackgroundTransparency = 1
			t176.headLbl.Position = UDim2.fromOffset(14, 2)
			t176.headLbl.Size = UDim2.new(1, -28, 0, 18)
			t176.headLbl.Font = Enum.Font.GothamBold
			t176.headLbl.TextSize = 12
			t176.headLbl.TextXAlignment = Enum.TextXAlignment.Left
			t176.headLbl.TextTruncate = Enum.TextTruncate.AtEnd
			t176.headLbl.TextColor3 = v3697.accent
			t176.headLbl.Text = "Global Egg Data & History"
			t176.headLbl.Parent = Frame

			local Frame2 = Instance.new("Frame")

			Frame2.Position = UDim2.fromOffset(14, 22)
			Frame2.Size = UDim2.new(1, -28, 0, 32)
			Frame2.BackgroundTransparency = 1
			Frame2.Parent = Frame

			local UIListLayout = Instance.new("UIListLayout", Frame2)

			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.Padding = UDim.new(0, 8)

			local TextButton = Instance.new("TextButton")

			TextButton.Size = UDim2.new(0.5, -4, 1, 0)
			TextButton.BackgroundColor3 = v3697.accent
			TextButton.AutoButtonColor = false
			TextButton.Font = Enum.Font.GothamBold
			TextButton.TextSize = 12
			TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.Text = "Egg Data (Targets)"
			TextButton.Parent = Frame2
			Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)

			local UIStroke = Instance.new("UIStroke", TextButton)

			UIStroke.Color = v3697.accent
			UIStroke.Thickness = 1
			t176.catBtnTargets = TextButton

			local TextButton2 = Instance.new("TextButton")

			TextButton2.Size = UDim2.new(0.5, -4, 1, 0)
			TextButton2.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
			TextButton2.AutoButtonColor = false
			TextButton2.Font = Enum.Font.GothamBold
			TextButton2.TextSize = 12
			TextButton2.TextColor3 = v3697.btnText
			TextButton2.Text = "Egg History"
			TextButton2.Parent = Frame2
			Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6)

			local UIStroke2 = Instance.new("UIStroke", TextButton2)

			UIStroke2.Color = v3697.strokeCol
			UIStroke2.Thickness = 1
			t176.catBtnHistory = TextButton2
			TextButton.MouseButton1Click:Connect(function()
				t176.category = "targets"
				t176.filter = "All"

				for k, chip in pairs(t176.chips) do
					local v4208 = k == "All"

					chip.BackgroundColor3 = v4208 and v3697.accent or Color3.fromRGB(255, 255, 255)
					chip.BackgroundTransparency = v4208 and 0.15 or 0.9
					chip.TextColor3 = v4208 and Color3.fromRGB(255, 255, 255) or v3697.btnText
				end

				t176.paint()
			end)
			TextButton2.MouseButton1Click:Connect(function()
				t176.category = "history"
				t176.filter = "All"

				for k, chip in pairs(t176.chips) do
					local v4211 = k == "All"

					chip.BackgroundColor3 = v4211 and v3697.accent or Color3.fromRGB(255, 255, 255)
					chip.BackgroundTransparency = v4211 and 0.15 or 0.9
					chip.TextColor3 = v4211 and Color3.fromRGB(255, 255, 255) or v3697.btnText
				end

				t176.paint()
			end)

			local Frame3 = Instance.new("Frame")

			Frame3.Position = UDim2.fromOffset(14, 58)
			Frame3.Size = UDim2.new(1, -28, 0, 44)
			Frame3.BackgroundColor3 = Color3.fromRGB(16, 20, 32)
			Frame3.BorderSizePixel = 0
			Frame3.Parent = Frame
			Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 6)

			local UIStroke3 = Instance.new("UIStroke", Frame3)

			UIStroke3.Color = Color3.fromRGB(50, 80, 130)
			UIStroke3.Thickness = 1
			t176.noticeBox = Frame3

			local TextLabel5 = Instance.new("TextLabel")

			TextLabel5.Position = UDim2.new(0, 8, 0, 4)
			TextLabel5.Size = UDim2.new(1, -16, 1, -8)
			TextLabel5.BackgroundTransparency = 1
			TextLabel5.Font = Enum.Font.GothamMedium
			TextLabel5.TextSize = 10
			TextLabel5.TextColor3 = Color3.fromRGB(180, 205, 235)
			TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel5.TextWrapped = true
			TextLabel5.RichText = true
			TextLabel5.Text = "<b>Note:</b> These are estimated spawn targets based on cycle timing, not 100% guaranteed predictions."
			TextLabel5.Parent = Frame3
			t176.noticeText = TextLabel5

			local Frame4 = Instance.new("Frame")

			Frame4.Position = UDim2.fromOffset(14, 58)
			Frame4.Size = UDim2.new(1, -28, 0, 44)
			Frame4.BackgroundColor3 = Color3.fromRGB(22, 18, 28)
			Frame4.BorderSizePixel = 0
			Frame4.Visible = false
			Frame4.Parent = Frame
			Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 6)

			local UIStroke4 = Instance.new("UIStroke", Frame4)

			UIStroke4.Color = Color3.fromRGB(130, 80, 40)
			UIStroke4.Thickness = 1
			t176.summaryBox = Frame4

			local TextLabel6 = Instance.new("TextLabel")

			TextLabel6.Position = UDim2.new(0, 8, 0, 4)
			TextLabel6.Size = UDim2.new(1, -16, 1, -8)
			TextLabel6.BackgroundTransparency = 1
			TextLabel6.Font = Enum.Font.GothamMedium
			TextLabel6.TextSize = 10
			TextLabel6.TextColor3 = Color3.fromRGB(240, 220, 200)
			TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel6.TextWrapped = true
			TextLabel6.RichText = true
			TextLabel6.Text = ""
			TextLabel6.Parent = Frame4
			t176.summaryText = TextLabel6

			local ScrollingFrame = Instance.new("ScrollingFrame")

			ScrollingFrame.Position = UDim2.fromOffset(14, 106)
			ScrollingFrame.Size = UDim2.new(1, -28, 0, 26)
			ScrollingFrame.BackgroundTransparency = 1
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.ScrollBarThickness = 2
			ScrollingFrame.ScrollBarImageColor3 = v3697.accent
			ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
			ScrollingFrame.CanvasSize = UDim2.new(0, 220, 0, 0)
			ScrollingFrame.Parent = Frame
			t176.chipBar = ScrollingFrame

			local UIListLayout2 = Instance.new("UIListLayout", ScrollingFrame)

			UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout2.Padding = UDim.new(0, 6)
			UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
			t176.chips = {}

			for _, v in ipairs({
				"All",
				"Eternal",
				"Divine"
			}) do
				local TextButton3 = Instance.new("TextButton")

				TextButton3.Size = UDim2.fromOffset(60, 24)
				TextButton3.BackgroundColor3 = t176.filter == v and v3697.accent or Color3.fromRGB(255, 255, 255)
				TextButton3.BackgroundTransparency = t176.filter == v and 0.15 or 0.9
				TextButton3.AutoButtonColor = false
				TextButton3.Font = Enum.Font.GothamBold
				TextButton3.TextSize = 11
				TextButton3.TextColor3 = t176.filter == v and Color3.fromRGB(255, 255, 255) or v3697.btnText
				TextButton3.Text = v
				TextButton3.Parent = ScrollingFrame
				Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(1, 0)

				local UIStroke5 = Instance.new("UIStroke", TextButton3)

				UIStroke5.Color = v3697.accent
				UIStroke5.Thickness = 1
				UIStroke5.Transparency = 0.65
				TextButton3.MouseButton1Click:Connect(function()
					t176.filter = v

					for k, chip in pairs(t176.chips) do
						local v4226 = k == v

						chip.BackgroundColor3 = v4226 and v3697.accent or Color3.fromRGB(255, 255, 255)
						chip.BackgroundTransparency = v4226 and 0.15 or 0.9
						chip.TextColor3 = v4226 and Color3.fromRGB(255, 255, 255) or v3697.btnText
					end

					t176.paint()
				end)
				t176.chips[v] = TextButton3
			end

			local ScrollingFrame2 = Instance.new("ScrollingFrame")

			ScrollingFrame2.Position = UDim2.fromOffset(14, 136)
			ScrollingFrame2.Size = UDim2.new(1, -28, 1, -180)
			ScrollingFrame2.BackgroundTransparency = 1
			ScrollingFrame2.BorderSizePixel = 0
			ScrollingFrame2.ScrollBarThickness = 4
			ScrollingFrame2.ScrollBarImageColor3 = v3697.accent
			ScrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y
			ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
			ScrollingFrame2.Parent = Frame

			local UIListLayout3 = Instance.new("UIListLayout", ScrollingFrame2)

			UIListLayout3.Padding = UDim.new(0, 6)
			UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
			t176.list = ScrollingFrame2

			local Frame5 = Instance.new("Frame")

			Frame5.Position = UDim2.new(0, 14, 1, -40)
			Frame5.Size = UDim2.new(1, -28, 0, 32)
			Frame5.BackgroundTransparency = 1
			Frame5.Parent = Frame

			local TextButton3 = Instance.new("TextButton")

			TextButton3.Size = UDim2.new(0.48, -4, 1, 0)
			TextButton3.BackgroundColor3 = Color3.fromRGB(60, 70, 95)
			TextButton3.BackgroundTransparency = 0.15
			TextButton3.AutoButtonColor = false
			TextButton3.Font = Enum.Font.GothamBold
			TextButton3.TextSize = 11
			TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton3.Text = "Refresh Targets"
			TextButton3.Parent = Frame5
			Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)
			TextButton3.MouseButton1Click:Connect(function()
				t176.scanField()
				t176.syncBackend()
				t176.paint()
			end)
			t176.refreshBtn = TextButton3

			local TextLabel7 = Instance.new("TextLabel")

			TextLabel7.AnchorPoint = Vector2.new(1, 0)
			TextLabel7.Position = UDim2.fromScale(1, 0)
			TextLabel7.Size = UDim2.new(0.5, -4, 1, 0)
			TextLabel7.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
			TextLabel7.BackgroundTransparency = 0.2
			TextLabel7.Font = Enum.Font.GothamBold
			TextLabel7.TextSize = 11
			TextLabel7.TextColor3 = Color3.fromRGB(0, 255, 136)
			TextLabel7.Text = "Online Synced"
			TextLabel7.Parent = Frame5
			Instance.new("UICorner", TextLabel7).CornerRadius = UDim.new(0, 6)
			t176.statusLbl = TextLabel7

			if not t176.bound then
				t176.bound = true
				pcall(function()
					local ExperienceChat = game:GetService("CoreGui"):FindFirstChild("ExperienceChat")

					if ExperienceChat then
						for _, descendant in ipairs(ExperienceChat:GetDescendants()) do
							if descendant:IsA("TextLabel") then
								if descendant.Text:find("spawned in") then
									local v4235, v4236, v4237 = v4087(descendant.Text)

									if v4235 and v4236 and v4237 then
										local v4238 = string.format("init_%s_%s", v4045(v4236), v4237:lower())

										if not t176.reportedUids[v4238] then
											t176.reportedUids[v4238] = os.time()
											v4074({
												uid = v4238,
												name = v4236,
												area = v4237,
												rarity = v4235,
												ts = os.time() - 120,
												reporter = "Server Alert"
											})
										end
									end
								end
							end
						end

						ExperienceChat.DescendantAdded:Connect(function(descendant)
							if descendant:IsA("TextLabel") then
								if descendant.Text:find("spawned in") then
									task.wait(0.05)
									v4094(descendant.Text)
								end
							end
						end)
					end
				end)
				pcall(function()
					game:GetService("TextChatService").MessageReceived:Connect(function(p956)
						if p956 and p956.Text then
							if p956.Text:find("spawned in") then
								v4094(p956.Text)
							end
						end
					end)
				end)
			end

			t176.scanField()
			t176.syncBackend()
			t176.paint()
		end
		t176.refresh = function()
			t176.scanField()
			t176.syncBackend()
			t176.paint()
		end

		local t194 = {
			"logs",
			"eggs",
			"inventory",
			"checker",
			"eggdata"
		}
		local t195 = {
			logs = {
				name = "Egg Logs",
				w = 420,
				h = 500,
				build = function(p957)
					return v3797(p957)
				end
			},
			eggs = {
				name = "Egg Board",
				w = 420,
				h = 500,
				build = function(p958)
					return v3849(p958)
				end
			},
			inventory = {
				name = "Inventory & Base",
				w = 440,
				h = 510,
				build = function(p959)
					return v3935(p959)
				end
			},
			checker = {
				name = "Egg Checker",
				w = 420,
				h = 500,
				build = function(p960)
					return t175.build(p960)
				end
			},
			eggdata = {
				name = "Egg Data & History",
				w = 380,
				h = 570,
				build = function(p961)
					return t176.build(p961)
				end
			}
		}

		local function v4241(p962)
			v3698()

			local v4242 = t195[p962]

			if not v4242 then
				return
			end

			local name = "__SNE_Panel_" .. p962

			local function v4244()
				local ok, result = pcall(function()
					return LocalPlayer:FindFirstChild("PlayerGui")
				end)
				local v4247 = ok and result or nil

				return v4247
			end

			for _, v in ipairs({
				game:GetService("CoreGui"),
				v4244()
			}) do
				if v then
					pcall(function()
						for _, descendant in ipairs(v:GetDescendants()) do
							if descendant.Name == name and descendant:IsA("ScreenGui") then
								pcall(function()
									descendant:Destroy()
								end)
							end
						end
					end)
				end
			end

			local v4252 = v3699()
			local ScreenGui = Instance.new("ScreenGui")

			ScreenGui.Name = name
			ScreenGui.ResetOnSpawn = false
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			ScreenGui.DisplayOrder = 99999
			ScreenGui.Parent = v4252

			local n76 = 0

			for i, v in ipairs(t194) do
				if v == p962 then
					n76 = i - 1
				end
			end

			local Frame = Instance.new("Frame")

			Frame.AnchorPoint = Vector2.new(0.5, 0.5)
			Frame.Size = UDim2.fromOffset(v4242.w, v4242.h)
			Frame.BackgroundTransparency = 1
			Frame.Active = true
			Frame.Parent = ScreenGui

			local UIScale = Instance.new("UIScale")

			UIScale.Name = "WindowScale"
			UIScale.Scale = 1
			UIScale.Parent = Frame

			local UserInputService = game:GetService("UserInputService")

			local function v4260(p963)
				local CurrentCamera = workspace.CurrentCamera
				local ViewportSize = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1024, 768)

				if ViewportSize.X <= 0 or ViewportSize.Y <= 0 then
					return
				end

				local v4263 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled or ViewportSize.Y < 550
				local v4264 = math.min(1, ViewportSize.X * (v4263 and 0.86 or 0.94) / v4242.w, ViewportSize.Y * (v4263 and 0.88 or 0.92) / v4242.h)

				if v4263 and v4264 > 0.82 then
					v4264 = 0.82
				end

				UIScale.Scale = math.clamp(v4264, 0.48, 1)

				local Scale = UIScale.Scale
				local v4266 = v4242.w * Scale
				local v4267 = v4242.h * Scale

				if p963 then
					if v4263 then
						local v4268 = ViewportSize.X - math.floor(v4266 / 2) - 14
						local v4269 = math.floor(ViewportSize.Y / 2)

						Frame.Position = UDim2.fromOffset(v4268, v4269)
					else
						local v4270 = n76 * 20

						Frame.Position = UDim2.fromOffset(math.floor(ViewportSize.X / 2 + n76 * 24), math.floor(ViewportSize.Y / 2 + v4270))
					end
				end

				local v4271 = v4266 / 2
				local v4272 = v4267 / 2
				local v4273 = math.min(v4271 + 8, ViewportSize.X / 2)
				local v4274 = math.max(ViewportSize.X - v4271 - 8, ViewportSize.X / 2)
				local v4275 = math.min(v4272 + 8, ViewportSize.Y / 2)
				local v4276 = math.max(ViewportSize.Y - v4272 - 8, ViewportSize.Y / 2)
				local v4277 = Frame.Position.Y.Scale * ViewportSize.Y + Frame.Position.Y.Offset
				local floor = math.floor

				Frame.Position = UDim2.fromOffset(math.floor(math.clamp(Frame.Position.X.Scale * ViewportSize.X + Frame.Position.X.Offset, v4273, v4274)), floor(math.clamp(v4277, v4275, v4276)))
			end

			local ImageLabel = Instance.new("ImageLabel")

			ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
			ImageLabel.Size = UDim2.new(1, 40, 1, 40)
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.Image = "rbxassetid://6015897843"
			ImageLabel.ImageColor3 = t166.shadow
			ImageLabel.ImageTransparency = 0.52
			ImageLabel.ScaleType = Enum.ScaleType.Slice
			ImageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
			ImageLabel.ZIndex = 0
			ImageLabel.Parent = Frame

			local Frame2 = Instance.new("Frame")

			Frame2.Size = UDim2.fromScale(1, 1)
			Frame2.Position = UDim2.fromScale(0, 0)
			Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame2.BackgroundTransparency = 0
			Frame2.BorderSizePixel = 0
			Frame2.ZIndex = 1
			Frame2.Parent = Frame
			Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 8)

			local UIGradient = Instance.new("UIGradient", Frame2)

			UIGradient.Rotation = 16
			UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, t166.obsTop),
				ColorSequenceKeypoint.new(0.52, t166.obsMid),
				ColorSequenceKeypoint.new(1, t166.obsLow)
			})

			local UIStroke = Instance.new("UIStroke", Frame2)

			UIStroke.Color = t166.strokeCol
			UIStroke.Thickness = 1
			UIStroke.Transparency = 0.72

			local TextLabel5 = Instance.new("TextLabel")

			TextLabel5.BackgroundTransparency = 1
			TextLabel5.Position = UDim2.fromOffset(42, 12)
			TextLabel5.Size = UDim2.fromOffset(200, 22)
			TextLabel5.Font = Enum.Font.GothamBold
			TextLabel5.TextSize = 16
			TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel5.TextColor3 = t166.text
			TextLabel5.Text = "Sena"
			TextLabel5.Parent = Frame2

			local ImageLabel2 = Instance.new("ImageLabel")

			ImageLabel2.AnchorPoint = Vector2.new(0, 0.5)
			ImageLabel2.Position = UDim2.fromOffset(11, 23)
			ImageLabel2.Size = UDim2.fromOffset(20, 20)
			ImageLabel2.BackgroundTransparency = 1
			ImageLabel2.Image = "rbxassetid://96240498384290"
			ImageLabel2.ScaleType = Enum.ScaleType.Fit
			ImageLabel2.Parent = Frame2

			local Frame3 = Instance.new("Frame")

			Frame3.Position = UDim2.fromOffset(14, 44)
			Frame3.Size = UDim2.fromOffset(math.max(90, #v4242.name * 8 + 26), 24)
			Frame3.BackgroundColor3 = t166.accent
			Frame3.BackgroundTransparency = 0.82
			Frame3.BorderSizePixel = 0
			Frame3.Parent = Frame2
			Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 6)

			local UIStroke2 = Instance.new("UIStroke", Frame3)

			UIStroke2.Color = t166.accent
			UIStroke2.Thickness = 1
			UIStroke2.Transparency = 0.45

			local TextLabel6 = Instance.new("TextLabel")

			TextLabel6.BackgroundTransparency = 1
			TextLabel6.Size = UDim2.fromScale(1, 1)
			TextLabel6.Font = Enum.Font.GothamBold
			TextLabel6.TextSize = 12
			TextLabel6.TextColor3 = t166.text
			TextLabel6.Text = v4242.name
			TextLabel6.Parent = Frame3

			local TextButton = Instance.new("TextButton")

			TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
			TextButton.Position = UDim2.new(0.5, 0, 1, -36)
			TextButton.Size = UDim2.fromOffset(176, 22)
			TextButton.BackgroundColor3 = t166.btnBg
			TextButton.BackgroundTransparency = 0.15
			TextButton.AutoButtonColor = false
			TextButton.Text = ""
			TextButton.Parent = Frame2
			Instance.new("UICorner", TextButton).CornerRadius = UDim.new(1, 6)

			local UIStroke3 = Instance.new("UIStroke", TextButton)

			UIStroke3.Color = t166.strokeCol
			UIStroke3.Thickness = 1
			UIStroke3.Transparency = 0.6

			local ImageLabel3 = Instance.new("ImageLabel")

			ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5)
			ImageLabel3.Position = UDim2.new(0, 12, 0.5, 0)
			ImageLabel3.Size = UDim2.fromOffset(12, 12)
			ImageLabel3.BackgroundTransparency = 1
			ImageLabel3.Image = "rbxassetid://94434236999817"
			ImageLabel3.ScaleType = Enum.ScaleType.Fit
			ImageLabel3.Parent = TextButton

			local TextLabel7 = Instance.new("TextLabel")

			TextLabel7.BackgroundTransparency = 1
			TextLabel7.Position = UDim2.fromOffset(24, 0)
			TextLabel7.Size = UDim2.new(1, -28, 1, 0)
			TextLabel7.Font = Enum.Font.GothamBold
			TextLabel7.TextSize = 12
			TextLabel7.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel7.TextColor3 = t166.text
			TextLabel7.Text = "discord.gg/senahub"
			TextLabel7.Parent = TextButton
			TextButton.MouseButton1Click:Connect(function()
				pcall(function()
					setclipboard("https://discord.gg/senahub")
				end)
			end)

			local TextButton2 = Instance.new("TextButton")

			TextButton2.Position = UDim2.new(1, -36, 0, 8)
			TextButton2.Size = UDim2.fromOffset(26, 26)
			TextButton2.BackgroundColor3 = t166.btnBg
			TextButton2.BackgroundTransparency = 0.15
			TextButton2.AutoButtonColor = false
			TextButton2.Font = Enum.Font.GothamBold
			TextButton2.TextSize = 13
			TextButton2.TextColor3 = t166.btnText
			TextButton2.Text = "X"
			TextButton2.ZIndex = 5
			TextButton2.Parent = Frame2
			Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 4)

			local UIStroke4 = Instance.new("UIStroke", TextButton2)

			UIStroke4.Color = t166.strokeCol
			UIStroke4.Thickness = 1
			UIStroke4.Transparency = 0.6
			TextButton2.MouseButton1Click:Connect(function()
				v3698()
				ScreenGui.Enabled = false
			end)

			local Frame4 = Instance.new("Frame")

			Frame4.Position = UDim2.fromOffset(0, 72)
			Frame4.Size = UDim2.new(1, 0, 1, -120)
			Frame4.BackgroundTransparency = 1
			Frame4.BorderSizePixel = 0
			Frame4.Parent = Frame2

			local u4295 = false
			local Position
			local Position2

			local function v4298(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					u4295 = true
					Position = input.Position
					Position2 = Frame.Position
				end
			end

			TextLabel5.InputBegan:Connect(v4298)
			Frame3.InputBegan:Connect(v4298)
			Frame2.InputBegan:Connect(function(input)
				if input.Position.Y - Frame.AbsolutePosition.Y <= 44 * (UIScale and UIScale.Scale or 1) then
					v4298(input)
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if u4295 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local v4299 = input.Position - Position

					Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v4299.X, Position2.Y.Scale, Position2.Y.Offset + v4299.Y)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and u4295 then
					u4295 = false
					pcall(v4260, false)
				end
			end)
			v4260(true)

			local CurrentCamera = workspace.CurrentCamera

			if CurrentCamera then
				CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					if ScreenGui and ScreenGui.Parent and ScreenGui.Enabled then
						pcall(v4260, false)
					end
				end)
			end

			windows[p962] = {
				gui = ScreenGui,
				page = Frame4,
				holder = Frame,
				fitScale = v4260
			}
			pcall(function()
				v4242.build(Frame4)
			end)
			pcall(function()
				v3771(p962)
			end)
		end
		local function v4301(p964)
			v3698()

			local v4302 = p964 or "logs"
			local v4303 = windows[v4302]

			if not v4303 or not v4303.gui or not v4303.gui.Parent then
				v4241(v4302)

				return
			end

			v4303.gui.Enabled = true

			if v4303.fitScale then
				pcall(v4303.fitScale, false)
			end

			pcall(function()
				v3771(v4302)
			end)
		end
		local function v4304()
			for _, v in ipairs(t194) do
				v4301(v)
			end
		end
		local function v4307()
			for _, window in pairs(windows) do
				if window and window.gui then
					window.gui.Enabled = false
				end
			end
		end

		task.spawn(function()
			while v16() do
				pcall(function()
					local v4310 = EggState2.ReadFieldEggs()

					if v4310 and v4310.Records then
						for _, record in ipairs(v4310.Records) do
							v3757(record)
						end
					end
				end)
				pcall(function()
					if t176 and type(t176.scanField) == "function" then
						t176.scanField()
					end
				end)

				for _, v in ipairs({
					"logs",
					"eggs",
					"inventory",
					"checker",
					"eggdata"
				}) do
					if v3764(v) then
						pcall(v3771, v)
					end
				end

				task.wait(2)
			end
		end)
		senaPanels.windows = windows
		senaPanels.openLogs = function()
			v4301("logs")
		end
		senaPanels.openBoard = function()
			v4301("eggs")
		end
		senaPanels.openInventory = function()
			v4301("inventory")
		end
		senaPanels.openChecker = function()
			v4301("checker")
		end
		senaPanels.openAnalyst = function()
			v4301("eggdata")
		end
		senaPanels.openAll = function()
			v4304()
		end
		senaPanels.closeAll = function()
			v4307()
		end
		pcall(function()
			getgenv().SenaPanels = senaPanels
		end)
	end

	v3692()

	local function v4315()
		pcall(function()
			local ChloeX_Instance = genv.ChloeX_Instance

			if type(ChloeX_Instance) == "table" and type(ChloeX_Instance.DestroyGui) == "function" then
				ChloeX_Instance:DestroyGui()
			end
		end)
		genv.ChloeX_Running = nil
		genv.ChloeX_ReopenPrompt = nil
		genv.ChloeX_Instance = nil

		local SenaLibOverride = genv.SenaLibOverride

		do
			if type(SenaLibOverride) ~= "table" then
				local ok, result = pcall(function()
					return loadstring(game:HttpGet("https://senahub.xyz/raw/libsenuy"))()
				end)

				SenaLibOverride = ok and type(result) == "table" and result or nil
			end
		end

		if not SenaLibOverride then
			warn("[Sena] UI library failed to load")

			return
		end

		local function v4320(p965)
			local t196 = {}
			local ipairs_ = ipairs
			local v4323 = type(p965) == "table" and p965 or {}

			for _, v in ipairs_(v4323) do
				if v ~= "None" and v ~= "" then
					t196[#t196 + 1] = v
				end
			end

			return t196
		end
		local function v4326()
			local t197 = {}

			pcall(function()
				for _, v in ipairs(v611.getRarities()) do
					t197[#t197 + 1] = v
				end
			end)

			if #t197 == 0 then
				t197 = {
					"Common",
					"Uncommon",
					"Rare",
					"Epic",
					"Legendary",
					"Mythic",
					"Cosmic",
					"Secret",
					"Eternal",
					"Divine"
				}
			end

			return t197
		end
		local function v4330(p966)
			local t198 = { "All" }

			for _, v in ipairs(p966) do
				if v ~= "All" then
					t198[#t198 + 1] = v
				end
			end

			return t198
		end

		local t199 = {}

		pcall(function()
			for _, v in ipairs(v611.getMutations()) do
				t199[#t199 + 1] = v
			end
		end)

		if #t199 == 0 then
			t199 = {
				"Golden",
				"Rainbow",
				"Shocked",
				"Frozen",
				"Burnt",
				"Boss"
			}
		end

		local t200 = { "None" }

		if not pcall(function()
			local Directory = require(game:GetService("ReplicatedStorage").Data.Areas).Directory
			local ok, result = pcall(function()
				return require(game:GetService("ReplicatedStorage").Data.Assets)
			end)

			if ok and result and result.Directory then
				local Directory2 = result.Directory
				local t201 = {}

				for _, v in pairs(Directory) do
					if type(v) == "table" and type(v.DropTable) == "table" then
						for _, v2 in ipairs(v.DropTable) do
							local v4347 = v2[1]

							if type(v4347) == "string" and not t201[v4347] then
								t201[v4347] = true

								local v4348 = Directory2[v4347]

								t200[#t200 + 1] = v4348 and v4348.DisplayName or v4347
							end
						end
					end
				end
			end
		end) or #t200 <= 1 then
			t200 = { "None" }
		end

		table.sort(t200, function(p967, p968)
			if p967 == "None" then
				return true
			end

			if p968 == "None" then
				return false
			end

			return p967 < p968
		end)

		local t202 = { "None" }

		do
			local t203 = {
				"Lake",
				"Jungle",
				"Desert",
				"Snow",
				"Volcano",
				"Abyss Ocean",
				"Prehistoric",
				"Cosmic",
				"Cherry Blossom",
				"Titan Temple"
			}
			local t204 = {}

			if not pcall(function()
				for k, v in pairs(require(game:GetService("ReplicatedStorage").Data.Areas).Directory) do
					if type(v) == "table" and type(v.DropTable) == "table" then
						t204[k] = true
					end
				end
			end) or next(t204) == nil then
				for _, v in ipairs(t203) do
					t204[v] = true
				end
			end

			local t205 = {
				None = true,
				Forest = true,
				["Titan Temple"] = true
			}

			for _, v in ipairs(t203) do
				if v ~= "Titan Temple" and t204[v] then
					table.insert(t202, v)
					t205[v] = true
				end
			end

			local t206 = {}

			for k in pairs(t204) do
				if not t205[k] then
					table.insert(t206, k)
				end
			end

			table.sort(t206)

			for _, v in ipairs(t206) do
				table.insert(t202, v)
			end

			if t204["Titan Temple"] then
				table.insert(t202, "Titan Temple")
			end
		end

		t24.AutoPlaceLoop = function()
			if senaV4Config.IsAutoPlaceWorkerRunning then
				return
			end

			senaV4Config.IsAutoPlaceWorkerRunning = true

			while senaV4Config.AutoPlace and v16() do
				task.wait(1.5)

				local ok, result = pcall(function()
					if senaV4Config.IsStealing then
						return
					end

					local ReplicatedStorage2 = game:GetService("ReplicatedStorage")

					game:GetService("HttpService")

					local EggState2 = require(ReplicatedStorage2.Client.EggState)
					local Assets = require(ReplicatedStorage2.Data.Assets)
					local v4368
					local Plots = workspace:FindFirstChild("Plots")

					if Plots then
						local v4370, v4371, v4372 = ipairs(Plots:GetChildren())
						local v4373 = geniter(v4370, v4371, v4372)

						while true do
							local v4374 = table.pack(v4373())

							if not v4374[1] then
								break
							end

							local v4375 = v4374[3]
							local PlotSign = v4375:FindFirstChild("PlotSign")

							if PlotSign then
								local PlayerPlotSign = PlotSign:FindFirstChild("PlayerPlotSign")

								if PlayerPlotSign and PlayerPlotSign:FindFirstChild("Frame") then
									if PlayerPlotSign.Frame:FindFirstChild("PlayerName") then
										local v4378 = string.gsub(PlayerPlotSign.Frame.PlayerName.Text, "<[^>]+>", "")

										if string.find(string.lower(v4378), string.lower(LocalPlayer.Name)) or string.find(string.lower(v4378), string.lower(LocalPlayer.DisplayName)) then
											v4368 = v4375

											break
										end
									end
								end
							end
						end
					end

					if not v4368 then
						return
					end

					local ToUpdate = v4368:FindFirstChild("ToUpdate")
					local PetArea = ToUpdate and ToUpdate:FindFirstChild("PetArea")
					local CenterPoint = v4368:FindFirstChild("CenterPoint") or PetArea

					if not PetArea then
						return
					end

					local t207 = {}
					local v4383 = EggState2.GetOwnerRuntimeRecords(LocalPlayer.UserId)
					local n77 = 0

					if type(v4383) == "table" then
						local v4385, v4386, v4387 = pairs(v4383)

						for k, v in v4385, v4386, v4387 do
							if v.Placement == nil then
								local AssetCategory = v.AssetCategory
								local v4391 = AssetCategory and Assets.Directory[AssetCategory]
								local s17 = "Unknown"

								if v4391 and v4391.Rarity then
									local Rarity = v4391.Rarity

									s17 = Rarity.DisplayName or Rarity._id or Rarity.Name or "Unknown"
								end

								local v4394

								if #senaV4Config.PlaceRarities == 0 or table.find(senaV4Config.PlaceRarities, "None") or table.find(senaV4Config.PlaceRarities, "All") then
									v4394 = true
								else
									v4394 = table.find(senaV4Config.PlaceRarities, s17) ~= nil
								end

								local v4395 = tonumber(v.Kg) or tonumber(v.Weight) or tonumber(v.kg)

								if not v4395 and v4391 then
									v4395 = tonumber(v4391.Kg) or tonumber(v4391.Weight) or tonumber(v4391.kg)
								end

								local v4396 = v4395 or 0

								if v4394 then
									table.insert(t207, {
										Uid = k,
										Rarity = s17,
										Kg = v4396
									})
								end
							else
								n77 += 1
							end
						end
					end

					table.sort(t207, function(p969, p970)
						return p969.Kg > p970.Kg
					end)

					local Character = LocalPlayer.Character

					if Character then
						Character:FindFirstChild("HumanoidRootPart")
					end

					if Character then
						Character:FindFirstChildOfClass("Humanoid")
					end

					local CFrame_2

					if #t207 == 0 or n77 >= 30 then
						return
					end

					local function v4399()
						local __SenaV4StealWantsCharacter = genv.__SenaV4StealWantsCharacter

						if __SenaV4StealWantsCharacter and __SenaV4StealWantsCharacter() then
							return true
						end

						local __SenaV4DronesWantCharacter = genv.__SenaV4DronesWantCharacter

						return __SenaV4DronesWantCharacter ~= nil and __SenaV4DronesWantCharacter() == true
					end

					if senaV4Config.IsStealing or v4399() then
						return
					end

					senaV4Config.IsPlacing = true

					local __SenaV4TreadmillManager = genv.__SenaV4TreadmillManager

					if __SenaV4TreadmillManager and __SenaV4TreadmillManager.activeTreadmill ~= nil then
						local v4403 = os.clock() + 5

						while __SenaV4TreadmillManager.activeTreadmill ~= nil and os.clock() < v4403 do
							pcall(function()
								__SenaV4TreadmillManager:_requestUnequip()
							end)
							task.wait(0.3)
						end
					end

					local Character2 = LocalPlayer.Character
					local HumanoidRootPart = Character2 and Character2:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")

					if HumanoidRootPart and HumanoidRootPart.Anchored then
						pcall(function()
							HumanoidRootPart.Anchored = false
						end)
					end

					if Humanoid then
						pcall(function()
							Humanoid:UnequipTools()
						end)
					end

					if HumanoidRootPart then
						CFrame_2 = HumanoidRootPart.CFrame
					end

					local function v4407()
						return not senaV4Config.AutoPlace or senaV4Config.IsStealing or v4399()
					end

					if HumanoidRootPart then
						local v4408 = PetArea.CFrame * cFrameNew(0, 3, 0)

						if not v588(HumanoidRootPart.Position + Vector3.new(0, 2, 0), v4408.Position + Vector3.new(0, 2, 0), Character2) then
							v232(HumanoidRootPart, Humanoid, cFrameNew(518.66, 70.57, -364.73) * Angles(3.1415926535897931, -1.5676547341413067, 3.1415926535897931), v4407)

							if v4407() then
								return
							end
						end

						v232(HumanoidRootPart, Humanoid, v4408, v4407)

						if v4407() then
							return
						end

						local n78 = 0

						while n78 < 0.5 and not v4407() do
							task.wait(0.05)
							n78 += 0.05
						end

						if v4407() then
							return
						end
					end

					local v4410 = false
					local t208 = {}
					local v4412, v4413, v4414 = pairs(v4383)

					for _, v in v4412, v4413, v4414 do
						if v.Placement then
							local Position

							if typeof(v.Placement) == "CFrame" then
								Position = v.Placement.Position
							elseif typeof(v.Placement) == "Vector3" then
								Position = v.Placement
							else
								Position = v.Placement.Position or Position
							end

							if Position then
								table.insert(t208, Position)
							end
						end
					end

					local n79 = 0
					local v4419, v4420, v4421 = ipairs(t207)

					for _, v in v4419, v4420, v4421 do
						if not senaV4Config.AutoPlace or v4410 then
							break
						end

						if n77 >= 30 then
							break
						end

						if v4407() then
							return
						end

						local Uid = v.Uid
						local v4425 = EggState2.GetOwnerRuntimeRecords(LocalPlayer.UserId)[Uid]
						local v4426 = EggState2.RequestEquipTool(Uid)

						if not v4426 then
							continue
						end

						if v4407() then
							return
						end

						task.wait(0.15)

						local v4428 = false

						while n79 < 30 and not v4428 do
							local v4429

							if CenterPoint then
								while n79 < 30 do
									local v4430 = PetArea.Size.X - 6
									local v4431 = v4430 / 10
									local v4432 = CenterPoint.CFrame:PointToObjectSpace(PetArea.CFrame * Vector3.new(-(v4430 / 2) + v4431 / 2 + n79 % 10 * v4431, 0, -((PetArea.Size.Z - 6) / 2) + 3 + math.floor(n79 / 10) * 6))
									local cFrame = cFrameNew(v4432.X, -0.5, v4432.Z)
									local v4434 = false

									for _, v2 in ipairs(t208) do
										if (v2 - cFrame.Position).Magnitude < 1 then
											v4434 = true

											break
										end
									end

									if not v4434 then
										v4429 = cFrame

										break
									end

									n79 += 1
								end
							end

							if not v4429 then
								v4410 = true

								break
							end

							if v4407() then
								return
							end

							local v4437, v4438 = EggState2.RequestPlaceEgg(Uid, v4429)

							if v4437 then
								table.insert(t208, v4429.Position)
								n77 += 1
								v4428 = true
								task.wait(0.15)

								continue
							end

							local v4439 = v4438 and string.lower(tostring(v4438)) or ""

							if not string.find(v4439, "full") and not string.find(v4439, "limit") and not string.find(v4439, "capacity") and not string.find(v4439, "maximum") then
								table.insert(t208, v4429.Position)
								n79 += 1
								task.wait(0.1)

								continue
							end

							if senaV4Config.AutoPlace then
								senaV4Config.AutoPlace = false
							end

							v4410 = true

							break
						end
					end

					if CFrame_2 and HumanoidRootPart and not v4407() then
						if not v588(HumanoidRootPart.Position + Vector3.new(0, 2, 0), CFrame_2.Position + Vector3.new(0, 2, 0), Character2) then
							v232(HumanoidRootPart, Humanoid, cFrameNew(518.66, 70.57, -364.73) * Angles(3.1415926535897931, -1.5676547341413067, 3.1415926535897931), v4407)
						end

						if v4407() then
							return
						end

						v232(HumanoidRootPart, Humanoid, CFrame_2, v4407)
						task.wait(0.2)
					end
				end)

				senaV4Config.IsPlacing = false

				if not ok then
					warn("Auto Place Error: " .. tostring(result))
				end
			end

			senaV4Config.IsAutoPlaceWorkerRunning = false
		end

		do
			t24.AutoHatchLoop = function()
				if senaV4Config.IsAutoHatchWorkerRunning then
					return
				end

				senaV4Config.IsAutoHatchWorkerRunning = true
				task.spawn(function()
					local t209 = {}

					while senaV4Config.AutoHatch and v16() do
						task.wait(1.5)
						pcall(function()
							local EggState2 = require(game:GetService("ReplicatedStorage").Client.EggState)
							local v4442 = EggState2.GetOwnerRuntimeRecords(LocalPlayer.UserId)

							if not v4442 then
								return
							end

							local t210 = {}

							for k, v in pairs(v4442) do
								if v.Placement ~= nil then
									table.insert(t210, k)
								end
							end

							local now = os.time()

							for _, v in ipairs(t210) do
								if not senaV4Config.AutoHatch then
									break
								end

								if not t209[v] or not (now < t209[v]) then
									local v4449 = v4442[v]
									local v4450 = false

									if type(EggState2.IsReadyToHatch) == "function" then
										local ok, result = pcall(EggState2.IsReadyToHatch, v)

										v4450 = ok and result == true
									end

									if v4450 or v4449.Ready == true or not t209[v] then
										if EggState2.RequestHatchEgg(v) then
											EggState2.RequestCompleteHatchEgg(v)
											t209[v] = nil
											task.wait(0.1)
										else
											t209[v] = now + 10
										end
									end
								end
							end
						end)
					end

					senaV4Config.IsAutoHatchWorkerRunning = false
				end)
			end
		end

		do
			local u4453 = false

			t24.mutationSweep = function()
				local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
				local EggState2 = require(ReplicatedStorage2.Client.EggState)
				local Remotes = require(ReplicatedStorage2.Shared.Remotes)
				local Directory

				pcall(function()
					local Assets = require(ReplicatedStorage2.Data.Assets)

					Directory = Assets.Directory or Assets
				end)

				local function v4459(p971)
					local Category = p971.Category or p971.AssetCategory
					local v4461 = Directory and Category and Directory[Category]

					return v4461 and v4461.DisplayName or Category
				end
				local function v4462(p972)
					local Category = p972.Category or p972.AssetCategory
					local v4464 = Directory and Category and Directory[Category]
					local Rarity = v4464 and v4464.Rarity

					return Rarity and (Rarity.DisplayName or Rarity._id) or nil
				end
				local function v4466()
					if senaV4Config.IsStealing == true or senaV4Config.IsPlacing == true then
						return true
					end

					local __SenaV4StealWantsCharacter = genv.__SenaV4StealWantsCharacter

					if __SenaV4StealWantsCharacter and __SenaV4StealWantsCharacter() then
						return true
					end

					local __SenaV4DronesWantCharacter = genv.__SenaV4DronesWantCharacter

					if __SenaV4DronesWantCharacter ~= nil and __SenaV4DronesWantCharacter() == true then
						return true
					end

					return false
				end

				local v4469 = senaV4Config.MutationChoice == "Fractured" and "Boss" or "Scrambled"

				local function v4470()
					for _, v in ipairs({
						LocalPlayer.Character,
						LocalPlayer:FindFirstChildOfClass("Backpack")
					}) do
						if not v then
							continue
						end

						for _, child in ipairs(v:GetChildren()) do
							if child:IsA("Tool") and child:GetAttribute("ItemType") == "MutationConsumable" and child:GetAttribute("MutationId") == v4469 then
								return child
							end
						end
					end

					return nil
				end
				local function v4475(p973)
					local Mutations = p973 and p973.Mutations

					if Mutations == nil then
						return false
					end

					if type(Mutations) ~= "table" then
						return tostring(Mutations):find(v4469) ~= nil
					end

					for _, Mutation in ipairs(Mutations) do
						if Mutation == v4469 then
							return true
						end
					end

					for k, Mutation in pairs(Mutations) do
						if k == v4469 or Mutation == v4469 then
							return true
						end
					end

					return false
				end

				if v4466() then
					return
				end

				local v4481 = v4470()

				if not v4481 then
					if not u4453 then
						warn("[AutoMutation] " .. tostring(senaV4Config.MutationChoice or "Scrambled") .. " consumable habis / gak ada di inventory - ronde di-skip.")
						u4453 = true
					end

					return
				end

				u4453 = false

				local Character = LocalPlayer.Character
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				if not Humanoid then
					return
				end

				if not Character:FindFirstChild(v4481.Name) then
					pcall(function()
						Humanoid:EquipTool(v4481)
					end)
					task.wait(0.15)
				end

				local v4484 = EggState2.GetOwnerRuntimeRecords(LocalPlayer.UserId)

				if type(v4484) ~= "table" then
					return
				end

				local MutationSpecies = senaV4Config.MutationSpecies
				local v4486 = type(MutationSpecies) == "table" and #MutationSpecies > 0
				local MutationRarities = senaV4Config.MutationRarities
				local v4488 = type(MutationRarities) == "table" and #MutationRarities > 0

				for k, v in pairs(v4484) do
					if not v4466() then
						if type(v) ~= "table" or v.Placement == nil or v4475(v) then
							continue
						end

						local Category = v.Category or v.AssetCategory
						local v4492 = v4459(v)
						local v4493 = true

						if v4486 then
							v4493 = false

							local v4494, v4495, v4496 = ipairs(MutationSpecies)
							local v4497 = geniter(v4494, v4495, v4496)

							while true do
								local v4498 = table.pack(v4497())

								if v4498[1] then
									local v4499 = v4498[3]

									if v4499 == v4492 or v4499 == Category then
										v4493 = true

										break
									end
								else
									break
								end
							end
						end

						if v4493 and v4488 then
							local v4500 = v4462(v)

							v4493 = false

							local v4501, v4502, v4503 = ipairs(MutationRarities)
							local v4504 = geniter(v4501, v4502, v4503)

							while true do
								local v4505 = table.pack(v4504())

								if v4505[1] then
									if v4505[3] == v4500 then
										v4493 = true

										break
									end
								else
									break
								end
							end
						end

						if not v4493 then
							continue
						end

						local v4506 = v4470()

						if v4506 then
							if not Character:FindFirstChild(v4506.Name) then
								pcall(function()
									Humanoid:EquipTool(v4506)
								end)
								task.wait(0.1)
							end

							local n80 = 0
							local v4508 = false

							while not v4466() and v4470() ~= nil do
								local ok, result = pcall(function()
									return Remotes.BossMastery.AskUseMutationConsumable:InvokeServer(k)
								end)

								n80 += 1

								if ok and type(result) == "table" then
									if result.Mutated == true then
										v4508 = true
									end

									if result.Success == true then
										task.wait(0.25)

										if not v4508 and senaV4Config.MutationRetry and not (n80 >= 40) then
											continue
										end
									end
								end

								break
							end

							continue
						end
					end

					break
				end
			end
		end

		do
			t24.AutoMutationLoop = function()
				if senaV4Config.IsAutoMutationWorkerRunning then
					return
				end

				senaV4Config.IsAutoMutationWorkerRunning = true
				task.spawn(function()
					while senaV4Config.AutoMutation and v16() do
						task.wait(1)
						pcall(t24.mutationSweep)
					end

					senaV4Config.IsAutoMutationWorkerRunning = false
				end)
			end
		end

		do
			t24.RingEventLoop = function()
				if not senaV4Config.IsRingEventRunning then
					senaV4Config.IsRingEventRunning = true
					task.spawn(function()
						local cFrame = cFrameNew(544.76, 71.5, -416.48)
						local cFrame2 = cFrameNew(602, 70.78, -372)
						local cFrame3 = cFrameNew(5573, 70.77, -363)

						local function v4514()
							return not senaV4Config.AutoRingEvent or not v16()
						end
						local function v4515(p974)
							if v4514() then
								return false
							end

							local Character = LocalPlayer.Character
							local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
							local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

							if not HumanoidRootPart or not Humanoid then
								task.wait(0.3)

								return not v4514()
							end

							v232(HumanoidRootPart, Humanoid, p974, v4514, false, nil, true)

							return not v4514()
						end

						while true do
							if not v4514() and v4515(cFrame) then
								if not v4515(cFrame2) then
									break
								elseif v4515(cFrame3) and v4515(cFrame2) then
									continue
								end

								break
							end

							break
						end

						senaV4Config.IsRingEventRunning = false
					end)

					return
				end
			end
		end

		local v4519
		local v4520
		local v4521
		local v4522, v4523, v4524, v4525, v4526, v4527, v4528, v4529, v4530, v4531
		local v4532, v4533, v4534, v4535, v4536, v4537, v4538, v4539, v4540, v4541
		local v4542, v4543, v4544, v4545, v4546, v4547, v4548, v4549, v4550, v4551
		local v4552, v4553, v4554, v4555, v4556, v4557, v4558, v4559, v4560, v4561
		local v4562, runOnce, v4564, v4565, v4566, v4567, v4568, v4569, v4570, v4571
		local v4572, v4573, v4574, v4575, v4576, v4577

		do
			local AssetEarnings

			local function v4579(p975)
				if AssetEarnings == nil then
					pcall(function()
						AssetEarnings = require(game:GetService("ReplicatedStorage").Shared.Util.AssetEarnings)
					end)
				end

				if not AssetEarnings then
					return 0
				end

				for _, v in ipairs({
					AssetEarnings.LiveRatePerSecond,
					AssetEarnings.RatePerSecond,
					AssetEarnings.CatalogRatePerSecond
				}) do
					if type(v) == "function" then
						local ok, result = pcall(v, p975)

						if not ok or not (type(result) == "number" and result > 0) then
							continue
						end

						return result
					end
				end

				return 0
			end
			local function v4584(p976)
				local v4585 = string.lower(tostring(p976 or "")):gsub("[%s,]", "")

				if v4585 == "" then
					return 0
				end

				local v4586, v4587 = string.match(v4585, "^([%d]+%.?[%d]*)([kmb]?)$")
				local v4588 = tonumber(v4586)

				if not v4588 then
					return 0
				end

				local n81 = 1

				if v4587 == "k" then
					n81 = 1000
				elseif v4587 == "m" then
					n81 = 1000000
				elseif v4587 == "b" then
					n81 = 1e9
				end

				return v4588 * n81
			end

			local u4590 = false

			t24.startAutoSellLoop = function()
				if u4590 then
					return
				end

				u4590 = true
				task.spawn(function()
					local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
					local Assets = require(ReplicatedStorage2.Data.Assets)
					local Save = require(ReplicatedStorage2.Shared.Save)
					local AssetRoster = require(ReplicatedStorage2.Client.AssetRoster)
					local Remotes = require(ReplicatedStorage2.Shared.Remotes)
					local LocalPlayer2 = game:GetService("Players").LocalPlayer

					local function v4597()
						local ok, result = pcall(function()
							return AssetRoster.ReadOwnerPen(LocalPlayer2.UserId)
						end)

						if not ok or type(result) ~= "table" then
							return nil
						end

						local t211 = {}

						for k, v in pairs(result) do
							if type(k) == "string" then
								t211[k] = true
							end

							if type(v) == "table" and v.UID then
								t211[v.UID] = true
							end
						end

						return t211
					end
					local function v4603(p977, p978)
						if not senaV4Config.AutoSell then
							return false, "toggle Auto Sell Pet udah OFF", "global"
						end

						if not v198() then
							return false, "Auto Steal lagi megang kendali", "global"
						end

						local v4604 = v205(v4519)
						local v4605 = v205(v4520)

						if not v4604 or not v4605 then
							return false, "filter dropdown gak bisa dibaca", "global"
						end

						if type(p978) ~= "table" then
							return false, "status pet dipajang gak bisa diverifikasi", "global"
						end

						if p978[p977.uid] then
							return false, "pet ini dipajang di plot", "pet"
						end

						if not v211(p977.petName, p977.rarity, v4604, v4605) then
							return false, "pet ini udah gak match filter yang sekarang", "pet"
						end

						local v4606 = (Save.Peek or Save.Get)()
						local Inventory = v4606 and v4606.Inventory and v4606.Inventory[p977.uid]

						if Inventory == nil then
							return false, "pet ini udah gak ada di inventory", "pet"
						end

						local SellPetMaxRate = senaV4Config.SellPetMaxRate or 0

						if SellPetMaxRate > 0 then
							if SellPetMaxRate < v4579({
								Category = Inventory.Category or Inventory.AssetCategory,
								Scale = Inventory.Scale or Inventory.AssetScale or 1,
								Mutations = Inventory.Mutations or {}
							}) then
								return false, "money/s pet ini di atas batas value", "pet"
							end
						end

						if Inventory.IsFavorite == true then
							return false, "pet ini di-favorite", "pet"
						end

						if Inventory.InFuse == true then
							return false, "pet ini sedang di-fuse", "pet"
						end

						if table.find(v4606.EquippedAssets or {}, p977.uid) == nil then
							return true
						end

						return false, "pet ini sedang dipasang", "pet"
					end

					while senaV4Config.AutoSell and v16() do
						local ok, result = pcall(function()
							if not v198() then
								return
							end

							local v4611 = v205(v4519)
							local v4612 = v205(v4520)

							if not v4611 or not v4612 then
								warn("[AutoSell] Filter dropdown gak bisa dibaca - ronde ini di-SKIP, gak ada yang dijual. Kalau ini terus-terusan, matiin Auto Sell Pet dan lapor.")

								return
							end

							local v4613 = (Save.Peek or Save.Get)()
							local Inventory = v4613 and v4613.Inventory or {}
							local v4615 = v4597()

							if not v4615 then
								warn("[AutoSell] Status pet yang dipajang gak bisa diverifikasi - ronde ini di-SKIP, gak ada yang dijual.")

								return
							end

							local t212 = {}
							local n82 = 0

							if type(Inventory) == "table" then
								for k, v in pairs(Inventory) do
									n82 += 1

									if n82 % 250 == 0 then
										RunService.Heartbeat:Wait()

										if not senaV4Config.AutoSell then
											return
										end
									end

									if type(v) == "table" then
										local v4620 = v4615[k] == true
										local v4621 = v.IsFavorite == true or v["Jadikan Favorit"] == true or v.Favorite == true
										local v4622 = table.find(v4613.EquippedAssets or {}, k) ~= nil
										local v4623 = v.InFuse == true
										local Category = v.Category or v.id or v.AssetCategory or v.ItemId
										local v4625 = Category and Assets.Directory[Category]
										local DisplayName = v4625 and (v4625.DisplayName or v4625._id or v4625.Name) or "Unknown"
										local Rarity = v4625 and v4625.Rarity
										local DisplayName2 = Rarity and (Rarity.DisplayName or Rarity._id or Rarity.Name) or "Unknown"
										local v4629 = v211(DisplayName, DisplayName2, v4611, v4612)
										local v4630 = true
										local SellPetMaxRate = senaV4Config.SellPetMaxRate or 0

										if SellPetMaxRate > 0 then
											v4630 = v4579({
												Category = Category,
												Scale = v.Scale or v.AssetScale or 1,
												Mutations = v.Mutations or {}
											}) <= SellPetMaxRate
										end

										if v4629 and v4630 and not v4621 and not v4620 and not v4622 and not v4623 then
											table.insert(t212, {
												uid = k,
												petName = DisplayName,
												rarity = DisplayName2
											})
										end
									end
								end
							end

							if #t212 > 0 then
								for _, v in ipairs(t212) do
									local v4634 = v4597()
									local v4635, v4636, v4637 = v4603(v, v4634)

									if not v4635 then
										warn("[AutoSell] Gak jual " .. tostring(v.petName) .. " - " .. tostring(v4636))

										if v4637 ~= "global" then
											continue
										end
									elseif v198() then
										local Character = LocalPlayer2.Character
										local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
										local v4640

										for _, v2 in ipairs({
											LocalPlayer2.Backpack,
											Character
										}) do
											if v2 then
												for _, child in ipairs(v2:GetChildren()) do
													if child:IsA("Tool") and child:GetAttribute("UID") == v.uid then
														v4640 = child

														break
													end
												end
											end

											if v4640 then
												break
											end
										end

										if not v4640 or not Humanoid then
											continue
										end

										Humanoid:EquipTool(v4640)
										task.wait(0.2)

										if v198() then
											local v4645 = v4597()
											local v4646, v4647, v4648 = v4603(v, v4645)

											if v4646 then
												Remotes.PetSatchel.SellPet:FireServer({ v.uid })
												task.wait(0.05)

												continue
											else
												warn("[AutoSell] Batal di detik terakhir, gak jual " .. tostring(v.petName) .. " - " .. tostring(v4647))

												if v4648 ~= "global" then
													continue
												end
											end
										end
									end

									break
								end
							end
						end)

						if not ok then
							warn("Auto Sell Error:", result)
						end

						task.wait(1.5)
					end

					u4590 = false
				end)
			end

			local u4649 = false
			local u4650 = false

			local function v4651()
				if not senaV4Config.AutoSellEgg then
					return false
				end

				local v4652 = v205(v4521)

				if not v4652 or #v4652 == 0 or table.find(v4652, "None") then
					return false
				end

				local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
				local ok, result = pcall(function()
					return require(ReplicatedStorage2.Shared.Save)
				end)

				if not ok or not result then
					return false
				end

				local v4656 = (result.Peek or result.Get)()
				local EggInventory = v4656 and v4656.EggInventory

				if type(EggInventory) ~= "table" then
					return false
				end

				local ok2, result2 = pcall(function()
					return require(ReplicatedStorage2.Data.Assets)
				end)
				local Directory = ok2 and result2 and result2.Directory

				if not Directory then
					return false
				end

				for _, v in pairs(EggInventory) do
					local v4663 = type(v) == "table" and Directory[v.AssetCategory]
					local DisplayName = v4663 and v4663.Rarity and (v4663.Rarity.DisplayName or v4663.Rarity._id)
					local v4665 = true
					local SellEggMaxRate = senaV4Config.SellEggMaxRate or 0

					if SellEggMaxRate > 0 and type(v) == "table" then
						v4665 = v4579({
							Category = v.AssetCategory,
							Scale = v.AssetScale or 1,
							Mutations = v.Mutations or {}
						}) <= SellEggMaxRate
					end

					if v.Placement == nil and v4665 then
						if not v214(DisplayName or "Unknown", v4652) then
							continue
						end

						return true
					end
				end

				return false
			end

			genv.__SenaV4IsAutoSellEggBusy = function()
				return u4650 or v4651()
			end
			t24.startAutoSellEggLoop = function()
				if not u4649 then
					u4649 = true
					task.spawn(function()
						local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
						local Directory = require(ReplicatedStorage2.Data.Assets).Directory
						local EggState2 = require(ReplicatedStorage2.Client.EggState)
						local Remotes = require(ReplicatedStorage2.Shared.Remotes)
						local Save = require(ReplicatedStorage2.Shared.Save)

						while senaV4Config.AutoSellEgg and v16() do
							local v4672 = v205(v4521)
							local v4673 = (Save.Peek or Save.Get)()
							local EggInventory = v4673 and v4673.EggInventory

							if v4672 and type(EggInventory) == "table" and v198() then
								for k, v in pairs(EggInventory) do
									if senaV4Config.AutoSellEgg and v198() then
										local v4677 = type(v) == "table" and Directory[v.AssetCategory]
										local DisplayName = v4677 and v4677.Rarity and (v4677.Rarity.DisplayName or v4677.Rarity._id)
										local v4679 = true
										local SellEggMaxRate = senaV4Config.SellEggMaxRate or 0

										if SellEggMaxRate > 0 and type(v) == "table" then
											v4679 = v4579({
												Category = v.AssetCategory,
												Scale = v.AssetScale or 1,
												Mutations = v.Mutations or {}
											}) <= SellEggMaxRate
										end

										if not (v.Placement == nil and v4679) then
											continue
										end

										if not v214(DisplayName or "Unknown", v4672) then
											continue
										end

										if v198() then
											u4650 = true

											if genv.__SenaV4TreadmillManager and genv.__SenaV4TreadmillManager.activeTreadmill ~= nil then
												genv.__SenaV4TreadmillManager:_cancelIdle(true)
												task.wait(0.25)
											end

											if not EggState2.WearEggTool(k) then
												continue
											end

											task.wait(0.2)

											if v198() then
												local v4681 = (Save.Peek or Save.Get)()
												local EggInventory2 = v4681 and v4681.EggInventory and v4681.EggInventory[k]

												if EggInventory2 and EggInventory2.Placement == nil then
													Remotes.PetSatchel.SellPet:FireServer({ k })
													task.wait(0.25)
												end

												continue
											end
										end
									end

									break
								end
							end

							u4650 = false
							task.wait(0.5)
						end

						u4650 = false
						u4649 = false
					end)

					return
				end
			end

			local t213 = {
				"None",
				"All"
			}

			pcall(function()
				local t214 = {}

				for _, v in pairs(require(game:GetService("ReplicatedStorage").Data.Assets).Directory) do
					if type(v) == "table" and (v.DisplayName or v._id or v.Name) then
						local DisplayName = v.DisplayName or v._id or v.Name

						if not t214[DisplayName] then
							t214[DisplayName] = true
							table.insert(t213, DisplayName)
						end
					end
				end

				table.sort(t213, function(p979, p980)
					if p979 == "None" then
						return true
					end

					if p980 == "None" then
						return false
					end

					if p979 == "All" then
						return true
					end

					if p980 == "All" then
						return false
					end

					return p979 < p980
				end)
			end)
			v4522 = v4320(t200)
			v4523 = v4320(t202)
			v4524 = v4326()
			v4525 = v4330(v4320(t213))
			v4526 = function(p981)
				senaV4Config.AutoSteal = p981 == true

				if v612 then
					v612:setEnabled(senaV4Config.AutoSteal)
				end

				if type(genv.__SenaV4SetStealDeclutter) == "function" then
					pcall(genv.__SenaV4SetStealDeclutter, senaV4Config.AutoSteal)
				end
			end
			v4527 = function(p982)
				senaV4Config.StealHoldSeconds = math.clamp(math.floor((tonumber(p982) or 5) + 0.5), 1, 10)
			end
			v4528 = function(p983)
				senaV4Config.GodMode = p983 == true

				if v615 then
					v615:setEnabled(senaV4Config.GodMode)
				end
			end

			local function v4688()
				return genv.__SenaV4TreadmillManager
			end

			v4529 = function(p984)
				senaV4Config.AutoTreadmillIdle = p984 == true

				local v4689 = v4688()

				if v4689 then
					v4689:setIdleFarm(senaV4Config.AutoTreadmillIdle and not senaV4Config.AntiTreadmill)
				end
			end
			v4530 = function(p985)
				senaV4Config.AntiTreadmill = p985 == true

				local v4690 = v4688()

				if senaV4Config.AntiTreadmill then
					if v4690 then
						v4690:setIdleFarm(false)
					end

					t145.startAntiTreadmillLoop()
				elseif v4690 then
					v4690:setIdleFarm(senaV4Config.AutoTreadmillIdle)
				end
			end
			v4531 = function(p986)
				senaV4Config.HopNoMatch = p986 == true

				if senaV4Config.HopNoMatch then
					t145.startHopLoop()
				end
			end
			v4532 = function(p987)
				if type(p987) == "table" then
					p987 = p987[1]
				end

				senaV4Config.PrivateServerMax = tostring(p987 or "2")
			end
			v4533 = function(p988)
				senaV4Config.PrivateServerAuto = p988 == true

				if senaV4Config.PrivateServerAuto then
					t145.startPrivateAutoHop()
				end
			end
			v4534 = function(p989)
				senaV4Config.HopCooldown = math.max(1, math.floor(tonumber(p989) or 5))
			end
			v4535 = function(p990)
				senaV4Config.AutoTreadmillUpgrade = p990 == true

				local v4691 = v4688()

				if v4691 then
					v4691:setAutoUpgrade(senaV4Config.AutoTreadmillUpgrade)
				end
			end
			v4536 = function(p991)
				local v4692 = type(p991) == "string" and p991 or ""
				local stealMode = (v4692:find("Fly") or v4692:find("High")) and "Fly" or "Instant"
				local flyAerial = stealMode == "Fly" and (v4692:find("%(Fly%)") ~= nil or v4692:lower():find("aerial") ~= nil)

				senaV4Config.StealMode = stealMode
				senaV4Config.FlyAerial = flyAerial

				if v612 then
					v612:setStealMode(stealMode, flyAerial)
				end
			end
			v4537 = function(p992)
				local v4695 = math.floor(math.clamp(math.floor((tonumber(p992) or 600) + 0.5), 500, 1000) / 10 + 0.5)

				v223(v4695)

				if v612 then
					v612:setSpeed(v4695)
				end
			end
			v4538 = function(p993, p994, p995)
				local v4696 = v4320(p995)

				if p993 == "names" then
					senaV4Config.StealNamesFilter = v4696
				elseif p993 == "areas" then
					senaV4Config.StealAreas = v4696
				elseif p993 == "rarities" then
					senaV4Config.StealRarities = v4696
				end

				if v612 then
					v612:setFilter(p993, v4696)
					v612:setFilterEnabled(p994, #v4696 > 0)
				end
			end
			v4539 = function(p996)
				senaV4Config:applyStealValueInput(p996)

				if v612 then
					v612:setMinValuePerSec(senaV4Config.StealMinValue or 0)
				end
			end
			v4540 = function(p997)
				local v4697 = v4320(p997)

				senaV4Config.StealMutations = v4697

				if v612 then
					v612:setFilter("mutations", v4697)
					v612:setFilterEnabled("mutation", #v4697 > 0)
				end
			end
			v4541 = function(p998)
				local tonumber_ = tonumber
				local v4699 = tostring(p998 or ""):gsub("[^%d%.]", "")
				local stealMinWeight = tonumber_(v4699) or 0

				senaV4Config.StealMinWeight = stealMinWeight

				if v612 then
					v612:setMinWeightKg(stealMinWeight)
				end
			end
			v4542 = function(p999)
				senaV4Config.StealPriority = tostring(p999 or "Rarity")

				if v612 then
					v612:setHighestValueFirst(senaV4Config.StealPriority == "Highest Value")
					v612:setHeaviestFirst(senaV4Config.StealPriority == "Heaviest")
				end
			end
			v4543 = function(p1000)
				senaV4Config.EggESP = p1000 == true

				if v612 then
					v612:setEggEsp(senaV4Config.EggESP)
				end
			end
			v4544 = function(p1001)
				local v4701 = v4320(p1001)

				senaV4Config.EspDetails = v4701

				if not v612 then
					return
				end

				local t215 = {}

				for _, v in ipairs(v4701) do
					t215[v] = true
				end

				v612:setEspOption("name", t215.Name == true)
				v612:setEspOption("rarity", t215.Rarity == true)
				v612:setEspOption("value", t215.Value == true)
				v612:setEspOption("kg", t215.Weight == true)
				v612:setEspOption("mutation", t215.Mutation == true)
				v612:setEspOption("placed", t215["Placed Eggs"] == true)
			end
			v4545 = function(p1002)
				senaV4Config.ScrambleTradeInBanners = v4320(p1002)
			end
			v4546 = function(p1003)
				t145.setBackpackRates(p1003 == true)
			end
			v4547 = function(p1004)
				senaV4Config.AntiGuardKnockback = p1004 == true

				local __SenaV4AntiGuard = genv.__SenaV4AntiGuard

				if __SenaV4AntiGuard and type(__SenaV4AntiGuard.setEnabled) == "function" then
					pcall(__SenaV4AntiGuard.setEnabled, __SenaV4AntiGuard, senaV4Config.AntiGuardKnockback)
				end
			end
			v4548 = function(p1005)
				senaV4Config.AutoFavorite = p1005 == true
			end
			v4549 = function(p1006)
				senaV4Config.FavMode = p1006 == "Species" and "Species" or "Rarity"
			end
			v4550 = function(p1007)
				senaV4Config.FavRarities = v4320(p1007)
			end
			v4551 = function(p1008)
				senaV4Config.FavSpecies = v4320(p1008)
			end
			v4552 = function(p1009)
				senaV4Config.AutoEquipBest = p1009 == true
			end
			v4553 = function(p1010)
				senaV4Config.AutoClaimOffline = p1010 == true
			end
			v4554 = function(p1011)
				senaV4Config.AutoBaseUpgrade = p1011 == true
			end
			v4555 = function(p1012)
				senaV4Config.AutoClaimAlmanac = p1012 == true
			end
			v4556 = function(p1013)
				senaV4Config.AutoFusePets = p1013 == true
			end
			v4557 = function(p1014)
				senaV4Config.FuseSelectedOnly = p1014 == "Selected Species"
			end
			v4558 = function(p1015)
				senaV4Config.FuseRarities = v4320(p1015)
			end
			v4559 = function(p1016)
				senaV4Config.FuseSpecies = v4320(p1016)
			end
			v4560 = function(p1017)
				local __SenaV4Roaming = genv.__SenaV4Roaming

				if __SenaV4Roaming and type(__SenaV4Roaming.setNoclip) == "function" then
					pcall(__SenaV4Roaming.setNoclip, p1017 == true)
				end
			end
			v4561 = function(p1018)
				local __SenaV4Roaming = genv.__SenaV4Roaming

				if __SenaV4Roaming and type(__SenaV4Roaming.setBottingMode) == "function" then
					pcall(__SenaV4Roaming.setBottingMode, p1018 == true)
				end
			end
			v4562 = function(p1019)
				senaV4Config.AntiCutscene = p1019 == true
			end
			runOnce = function(p1020, p1021, p1022)
				local v4708 = senaV4Config[p1020]

				senaV4Config[p1020] = true
				task.spawn(p1021)
				task.delay(2.4, function()
					local v4709 = os.clock() + 30

					while senaV4Config.IsPlacing and os.clock() < v4709 do
						task.wait(0.25)
					end

					senaV4Config[p1020] = v4708

					if p1022 then
						pcall(p1022)
					end
				end)
			end
			t24.runOnce = runOnce

			local function v4710(p1023)
				senaV4Config.ScrambleFarmDrones = p1023 == true
			end
			local function v4711(p1024)
				senaV4Config.ScrambleLostParts = p1024 == true
			end
			local function v4712(p1025)
				senaV4Config.ScrambleCollectSamples = p1025 == true
			end
			local function v4713(p1026)
				senaV4Config.ScrambleAutoVault = p1026 == true
			end

			v4564 = function(p1027)
				senaV4Config.ScrambleAutoBuy = p1027 == true
			end

			local function v4714(p1028)
				senaV4Config.ScrambleAreas = v4320(p1028)
			end
			local function v4715(p1029)
				senaV4Config.ScrambleDroneTypes = v4320(p1029)
			end

			v4565 = function(p1030)
				senaV4Config.ScrambleBuyList = v4320(p1030)
			end
			v4566 = function(p1031)
				senaV4Config.AutoPlace = p1031 == true

				if senaV4Config.AutoPlace then
					task.spawn(t24.AutoPlaceLoop)
				end
			end
			v4567 = function(p1032)
				senaV4Config.AutoHatch = p1032 == true

				if senaV4Config.AutoHatch then
					task.spawn(t24.AutoHatchLoop)
				end
			end
			v4568 = function(p1033)
				senaV4Config.AutoMutation = p1033 == true

				if senaV4Config.AutoMutation then
					task.spawn(t24.AutoMutationLoop)
				end
			end
			v4569 = function(p1034)
				senaV4Config.AutoRingEvent = p1034 == true

				if senaV4Config.AutoRingEvent then
					t24.RingEventLoop()
				end
			end
			v4570 = function(p1035)
				senaV4Config.MutationChoice = p1035 == "Fractured" and "Fractured" or "Scrambled"
			end
			v4571 = function(p1036)
				senaV4Config.MutationSpecies = v4320(p1036)
			end
			v4572 = function(p1037)
				senaV4Config.MutationRarities = v4320(p1037)
			end
			v4573 = function(p1038)
				senaV4Config.MutationRetry = p1038 == true
			end
			v4574 = function(p1039)
				senaV4Config.AutoSell = p1039 == true

				if senaV4Config.AutoSell then
					t24.startAutoSellLoop()
				end
			end
			v4575 = function(p1040)
				senaV4Config.AutoSellEgg = p1040 == true

				if senaV4Config.AutoSellEgg then
					t24.startAutoSellEggLoop()
				end
			end
			v4576 = function(p1041)
				senaV4Config.SellPetMaxRate = v4584(p1041)
			end
			v4577 = function(p1042)
				senaV4Config.SellEggMaxRate = v4584(p1042)
			end
		end

		local u4716 = false

		local function v4717(p1043)
			local v4718 = senaV4Config.StartupBoost == true

			senaV4Config.StartupBoost = p1043 == true

			if not senaV4Config.StartupBoost then
				u4716 = false

				if v4718 or t15.snapshot then
					task.spawn(t15.revert)
				end

				return
			end

			if senaV4Config.StartupBoost and not u4716 then
				u4716 = true
				task.spawn(function()
					task.wait(1.5)

					if v16() and senaV4Config.StartupBoost then
						v390()
					end

					task.wait(4)

					if v16() and senaV4Config.StartupBoost then
						v390()
					end
				end)
			end
		end
		local function v4719(p1044)
			if p1044 == true then
				task.spawn(v391)
			end
		end
		local function v4720(p1045)
			local __SenaV4SetCapFps = genv.__SenaV4SetCapFps

			if type(__SenaV4SetCapFps) == "function" then
				__SenaV4SetCapFps(p1045 == true and 240 or 60)
			end
		end

		local v4722, v4723, v4724, v4725, v4726, v4727, v4728, v4729, v4730, v4731
		local v4732, __SenaV4PlayerSteal, v4734, v4735, v4736, v4737, v4738, v4739, v4740, v4741
		local v4742, t216, t217, u4745, t218

		do
			local function v4747()
				return genv.__SenaV4MovementExtras
			end

			v4722 = function(p1046)
				senaV4Config.FlyForCapture = p1046 == true

				local v4748 = v4747()

				if v4748 then
					v4748:setFlyForCapture(senaV4Config.FlyForCapture)
				end
			end
			v4723 = function(p1047)
				senaV4Config.InstantGrab = p1047 == true

				local v4749 = v4747()

				if v4749 then
					v4749:setInstantGrab(senaV4Config.InstantGrab)
				end
			end

			local function v4750(p1048)
				genv.__SenaV4AdminBoost = p1048 == true

				if v612 then
					v612:setSpeed(senaV4Config.TweenSpeedMultiplier or 60)
				end

				genv.__SenaV4AdminBoostSpeedGen = (genv.__SenaV4AdminBoostSpeedGen or 0) + 1

				local __SenaV4AdminBoostSpeedGen = genv.__SenaV4AdminBoostSpeedGen

				if p1048 == true then
					task.spawn(function()
						local RunService2 = game:GetService("RunService")
						local v4753
						local v4754

						while genv.__SenaV4AdminBoostSpeedGen == __SenaV4AdminBoostSpeedGen and v16() do
							local Character = LocalPlayer.Character
							local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

							if Humanoid then
								local WalkSpeed = Humanoid.WalkSpeed

								if v4753 == nil or v4754 == nil or math.abs(WalkSpeed - v4754) > 0.5 then
									v4753 = WalkSpeed > 900 and WalkSpeed / 10 or WalkSpeed
								end

								if v4753 and v4753 > 0 then
									local walkSpeed = v4753 * 10

									Humanoid.WalkSpeed = walkSpeed
									v4754 = walkSpeed
								end
							else
								v4753 = nil
								v4754 = nil
							end

							RunService2.Heartbeat:Wait()
						end
					end)
				end
			end

			v4724 = function(p1049)
				senaV4Config.AutoStealCapture = p1049 == true
			end
			v4725 = function(p1050)
				senaV4Config.InfiniteJump = p1050 == true

				local v4759 = v4747()

				if v4759 then
					v4759:setInfiniteJump(senaV4Config.InfiniteJump)
				end
			end

			local function v4760(p1051)
				senaV4Config.WalkSpeedMultiplier = math.clamp(tonumber(p1051) or 1, 1, 2.1)

				local v4761 = v4747()

				if v4761 then
					v4761:setSpeedMultiplier(senaV4Config.WalkSpeedMultiplier)
				end
			end

			v4726 = function(p1052)
				senaV4Config.AntiHitGuard = p1052 == true

				local __SenaV4AntiHitGuard = genv.__SenaV4AntiHitGuard

				if __SenaV4AntiHitGuard then
					__SenaV4AntiHitGuard:setEnabled(senaV4Config.AntiHitGuard)
				end
			end
			v4727 = function(p1053)
				senaV4Config.AntiAFK = p1053 == true
				genv.__SenaV4AntiAfkEnabled = senaV4Config.AntiAFK

				if type(genv.__SenaV4SetAntiAfkEnabled) == "function" then
					genv.__SenaV4SetAntiAfkEnabled(senaV4Config.AntiAFK)
				end
			end
			v4728 = function(p1054)
				senaV4Config.AutoReconnect = p1054 == true
				v2526.autoReconnect = senaV4Config.AutoReconnect

				if getgenv then
					getgenv().SNE_AutoReconnect = senaV4Config.AutoReconnect
				end
			end
			v4729 = function(p1055)
				senaV4Config.AutoExecute = p1055 == true
				v2526.autoExecute = senaV4Config.AutoExecute

				if getgenv then
					getgenv().SNE_AutoExecute = senaV4Config.AutoExecute
				end

				if p1055 then
					pcall(v2528)
				else
					pcall(v2530)
				end
			end

			local function v4763()
				local __SenaV4IdentitySetter = genv.__SenaV4IdentitySetter or type(setthreadidentity) == "function" and setthreadidentity or type(set_thread_identity) == "function" and set_thread_identity or type(setidentity) == "function" and setidentity or type(syn) == "table" and type(syn.set_thread_identity) == "function" and syn.set_thread_identity
				local __SenaV4UICapabilityIdentity = genv.__SenaV4UICapabilityIdentity or 8

				local function v4766()
					if type(__SenaV4IdentitySetter) == "function" then
						pcall(__SenaV4IdentitySetter, __SenaV4UICapabilityIdentity)
					end
				end

				return v4766
			end

			v4730 = v4763()
			v4731 = true
			v4732 = function(p1056)
				local function v4767(p1057)
					if type(v4730) == "function" then
						v4730()
					end

					if v4731 then
						return
					end

					if type(p1056) == "function" then
						p1056(p1057)
					end
				end

				return v4767
			end
			__SenaV4PlayerSteal = genv.__SenaV4PlayerSteal
			v4734 = function(p1058)
				senaV4Config.StealPlayers = p1058 == true

				if __SenaV4PlayerSteal then
					__SenaV4PlayerSteal:setEnabled(senaV4Config.StealPlayers)
				end
			end
			v4735 = function(p1059)
				senaV4Config.StealPlayerRarities = v4320(p1059)
			end

			local function v4768(p1060)
				local v4769 = string.lower(tostring(p1060 or "")):gsub("[%s,]", "")

				if v4769 == "" then
					return 0
				end

				local v4770, v4771 = string.match(v4769, "^([%d]+%.?[%d]*)([kmb]?)$")
				local v4772 = tonumber(v4770)

				if not v4772 then
					return 0
				end

				if v4771 == "k" then
					return v4772 * 1000
				end

				if v4771 == "m" then
					return v4772 * 1000000
				end

				if v4771 == "b" then
					return v4772 * 1e9
				end

				return v4772
			end

			v4736 = function(p1061)
				senaV4Config.StealPlayerMinValue = v4768(p1061)
			end
			v4737 = function(p1062)
				senaV4Config.AutoIndex = p1062 == true

				if v612 then
					v612:setIndexObjective(senaV4Config.AutoIndex)
				end
			end
			v4738 = function(p1063)
				senaV4Config.WebhookEnabled = p1063 == true
			end
			v4739 = function(p1064)
				senaV4Config.WebhookURL = type(p1064) == "string" and p1064 or ""
			end
			v4740 = function(p1065)
				senaV4Config.WebhookRarities = v4320(p1065)
			end
			v4741 = function(p1066)
				senaV4Config.WebhookMinValue = v4768(p1066)
			end

			local t219 = {
				"Set",
				"SetValue",
				"LoadValue",
				"ResetValue",
				"SetContent",
				"SetTitle",
				"SetOptions",
				"Update",
				"Refresh",
				"Lock",
				"Unlock",
				"SetVisible"
			}

			local function v4774(p1067)
				if type(p1067) ~= "table" then
					return p1067
				end

				if rawget(p1067, "__senaElevated") then
					return p1067
				end

				for _, v in ipairs(t219) do
					local value = rawget(p1067, v)

					if type(value) == "function" then
						rawset(p1067, v, function(...)
							v4730()

							return value(...)
						end)
					end
				end

				rawset(p1067, "__senaElevated", true)

				return p1067
			end

			local t220 = {
				"AddToggle",
				"AddSlider",
				"AddDropdown",
				"AddInput",
				"AddButton",
				"AddParagraph",
				"AddKeybind",
				"AddColorPicker",
				"AddActionList",
				"AddLiveChat",
				"AddSupportCard",
				"AddSubSection",
				"AddSection",
				"AddTab",
				"AddForum"
			}

			local function v4779(p1068)
				if type(p1068) ~= "table" then
					return p1068
				end

				v4774(p1068)

				if rawget(p1068, "__senaFactoryGuarded") then
					return p1068
				end

				for _, v in ipairs(t220) do
					local value = rawget(p1068, v)

					if type(value) == "function" then
						rawset(p1068, v, function(...)
							v4730()

							local v4783 = table.pack(value(...))

							if v4783.n > 0 then
								v4783[1] = v4779(v4783[1])
							end

							return table.unpack(v4783, 1, v4783.n)
						end)
					end
				end

				rawset(p1068, "__senaFactoryGuarded", true)

				return p1068
			end

			v4730()
			v4742 = SenaLibOverride:Window({
				Title = "Sena BETA |",
				Footer = "Steal An Egg",
				Folder = "SenaSAEv4",
				Version = 1,
				Color = Color3.fromRGB(232, 232, 238),
				Image = "http://56.10.112.179:8080/visual/sena_bg.jpg"
			})
			v4779(v4742)
			t216 = {}
			t217 = { "Respawn Point" }

			local __SenaV4Roaming = genv.__SenaV4Roaming

			if __SenaV4Roaming and type(__SenaV4Roaming.waypointList) == "function" then
				local ok, result = pcall(__SenaV4Roaming.waypointList)

				if ok and type(result) == "table" and #result > 0 then
					t217 = result
				end
			end

			u4745 = t217[1]
			t218 = {}

			local __SenaV4ScrambleRuntime = genv.__SenaV4ScrambleRuntime

			if __SenaV4ScrambleRuntime and type(__SenaV4ScrambleRuntime.snapshot) == "function" then
				pcall(function()
					local v4788 = __SenaV4ScrambleRuntime.snapshot()

					if v4788 and type(v4788.Shop) == "table" then
						for _, v in pairs(v4788.Shop) do
							if v and v.Label then
								t218[#t218 + 1] = tostring(v.Label)
							end
						end
					end
				end)
			end

			local v4791 = v4742:AddTab({
				Name = "Admin Abuse",
				Icon = "flame"
			})

			t216.autoStealCapture = v4791:AddSection("Capture The Egg"):AddToggle({
				Title = "Auto Steal Capture",
				Content = "For the Capture The Egg event. Grabs the event egg for you and keeps you holding it in a safe spot so your time keeps going. Turn off normal Auto Steal while using this.",
				Default = false,
				Callback = v4732(v4724)
			})

			local Movement = v4791:AddSection("Movement")

			t216.adminBoost = Movement:AddToggle({
				Title = "Admin Abuse Boost",
				Content = "Only works during Admin Abuse. Do not use it when there is no Admin Abuse.",
				Default = false,
				Callback = v4732(v4750)
			})
			t216.flyForCapture = Movement:AddToggle({
				Title = "Fly For Capture",
				Content = "For the Capture The Egg event. After you pick up an egg, you fly up and stay still in the air so nobody can take it.",
				Default = false,
				Callback = v4732(v4722)
			})
			t216.instantGrab = Movement:AddToggle({
				Title = "Instant Grab",
				Content = "Picking up an egg only needs a quick tap instead of a long hold.",
				Default = false,
				Callback = v4732(v4723)
			})
			t216.infiniteJump = Movement:AddToggle({
				Title = "Infinite Jump",
				Content = "Jump again in mid-air, as often as you like.",
				Default = false,
				Callback = v4732(v4725)
			})
			t216.noclip = Movement:AddToggle({
				Title = "Noclip",
				Content = "Walk through walls and doors.",
				Default = false,
				Callback = v4732(v4560)
			})
			t216.autoRingEvent = v4791:AddSection("Ring Event"):AddToggle({
				Title = "Auto Ring Event",
				Content = "Starts at the safe zone, then glides Forest -> Angels & Demons -> back to Forest on a loop. Turn off Auto Steal while using this.",
				Default = false,
				Callback = v4732(v4569)
			})
		end

		do
			local v4793 = v4742:AddTab({
				Name = "Main",
				Icon = "home"
			})
			local v4794 = v4793:AddSection("Auto Steal")

			t216.autoSteal = v4794:AddToggle({
				Title = "Auto Steal",
				Content = "Steals eggs that match your filters and brings them home.",
				Default = false,
				Callback = v4732(v4526)
			})
			t216.helpFriend = v4794:AddToggle({
				Title = "Help Friend",
				Content = "Instead of banking a stolen egg, drops it just before the safe zone line so a friend can pick it up.",
				Default = false,
				Callback = v4732(function(p1069)
					senaV4Config.HelpFriend = p1069 == true
				end)
			})
			v4794:AddButton({
				Title = "Egg Checker",
				Content = "Every egg on the field right now, best money first. Pick one and steal it.",
				Callback = v4732(function()
					senaPanels.openChecker()
				end)
			})
			v4794:AddButton({
				Title = "Egg Spawn Analyst",
				Content = "Live global spawn tracker, timeline & forecast synced across active online players.",
				Callback = v4732(function()
					senaPanels.openAnalyst()
				end)
			})
			t216.godMode = v4794:AddToggle({
				Title = "Aura Bat",
				Content = "",
				Default = false,
				Callback = v4732(v4528)
			})
			t216.stealMode = v4794:AddDropdown({
				Title = "Steal Mode",
				Content = "If you have good speed better use High Speed User, but if you are newbie, use Low Speed User",
				Options = {
					"Low Speed User",
					"High Speed User",
					"High Speed User (Fly)"
				},
				MaxVisible = 3,
				Default = "High Speed User",
				Multi = false,
				Callback = v4732(v4536)
			})

			if (tonumber(senaV4Config.StealHoldSeconds) or 5) > 10 then
				senaV4Config.StealHoldSeconds = 5
			end

			t216.stealHold = v4794:AddSlider({
				Title = "Low Speed Multiplier",
				Content = "For Low Speed User. Higher = faster grab, lower = safer. Lower it if steals keep failing.",
				Min = 1,
				Max = 10,
				Default = 5,
				Increment = 1,
				Callback = v4732(v4527)
			})

			local v4795 = v4793:AddSection("Egg Filter")

			v4795:AddSubSection("Egg")
			t216.names = v4795:AddDropdown({
				Title = "Filter By Egg Name",
				Content = "Only steal these eggs. Leave empty for any egg.",
				Options = v4522,
				Multi = true,
				Default = {},
				Callback = v4732(function(p1070)
					v4538("names", "name", p1070)
				end)
			})
			t216.rarities = v4795:AddDropdown({
				Title = "Filter By Rarity",
				Content = "Only steal these rarities. Leave empty for any rarity.",
				Options = v4524,
				Multi = true,
				Default = {},
				Callback = v4732(function(p1071)
					v4538("rarities", "rarity", p1071)
				end)
			})
			v4795:AddSubSection("Area & Value")
			t216.areas = v4795:AddDropdown({
				Title = "Select Area",
				Content = "Only steal from these areas. Leave empty for every area.",
				Options = v4523,
				Multi = true,
				Default = {},
				Callback = v4732(function(p1072)
					v4538("areas", "area", p1072)
				end)
			})
			t216.value = v4795:AddInput({
				Title = "Steal By Value",
				Content = "Minimum money per second. Supports k, m and b.",
				Placeholder = "e.g. 500k, 2m, 1b",
				Default = "",
				Callback = v4732(v4539)
			})
			t216.mutations = v4795:AddDropdown({
				Title = "Filter By Mutation",
				Content = "Only steal eggs carrying one of these mutations. Leave empty for any egg.",
				Options = t199,
				Multi = true,
				Default = {},
				Callback = v4732(v4540)
			})
			t216.weight = v4795:AddInput({
				Title = "Steal By Weight",
				Content = "Minimum egg weight in kilograms. 0 accepts any weight.",
				Placeholder = "e.g. 12000",
				Default = "",
				Callback = v4732(v4541)
			})
			t216.priority = v4795:AddDropdown({
				Title = "Steal Priority",
				Content = "Which egg to go for first when more than one passes the filters.",
				Options = {
					"Rarity",
					"Highest Value",
					"Heaviest"
				},
				Default = "Rarity",
				Callback = v4732(v4542)
			})
			t216.autoIndex = v4795:AddToggle({
				Title = "Auto Index",
				Content = "Also steal eggs whose pet is still missing from your Pet Index, in any area, on top of the filters above. An egg you already hold counts as covered until it hatches.",
				Default = false,
				Callback = v4732(v4737)
			})

			local v4796 = v4793:AddSection("Egg ESP")

			t216.eggEsp = v4796:AddToggle({
				Title = "Egg ESP",
				Content = "Draws a label over every egg on the field so you can read it from across the map.",
				Default = false,
				Callback = v4732(v4543)
			})
			t216.espDetails = v4796:AddDropdown({
				Title = "ESP Details",
				Content = "What each label shows. Placed Eggs also labels the eggs sitting on plots.",
				Options = {
					"Name",
					"Rarity",
					"Value",
					"Weight",
					"Mutation",
					"Placed Eggs"
				},
				Multi = true,
				Default = {
					"Name",
					"Rarity",
					"Value"
				},
				Callback = v4732(v4544)
			})
			t216.backpackRates = v4796:AddToggle({
				Title = "Backpack Value/s",
				Content = "Shows how much money per second each egg in your backpack makes, right on its slot.",
				Default = false,
				Callback = v4732(v4546)
			})

			local v4797 = v4793:AddSection("Steal Webhook")

			t216.webhookEnabled = v4797:AddToggle({
				Title = "Steal Webhook",
				Content = "Posts a Discord embed the moment a stolen egg is banked, with its rarity, size, weight and cash per second.",
				Default = false,
				Callback = v4732(v4738)
			})
			t216.webhookUrl = v4797:AddInput({
				Title = "Webhook URL",
				Content = "Paste the Discord webhook URL for the channel you want.",
				Placeholder = "https://discord.com/api/webhooks/...",
				Default = "",
				Callback = v4732(v4739)
			})
			v4797:AddSubSection("Filter")
			t216.webhookRarities = v4797:AddDropdown({
				Title = "Notify Rarities",
				Content = "Only post these rarities. Empty = every egg you steal.",
				Options = v4524,
				Multi = true,
				Default = {},
				Callback = v4732(v4740)
			})
			t216.webhookValue = v4797:AddInput({
				Title = "Notify Minimum Value",
				Content = "Only post eggs worth at least this per second. Supports k, m and b.",
				Placeholder = "e.g. 500k, 2m, 1b",
				Default = "",
				Callback = v4732(v4741)
			})
			v4797:AddButton({
				Title = "Test Webhook",
				Content = "Sends one test embed so you can confirm the URL works.",
				Callback = v4732(function()
					local __SenaV4Webhook = genv.__SenaV4Webhook

					if not __SenaV4Webhook or not __SenaV4Webhook.test() then
						SenaLibOverride:Notify({
							Title = "Steal Webhook",
							Content = "Enter a webhook URL first",
							Duration = 3
						})

						return
					end

					SenaLibOverride:Notify({
						Title = "Steal Webhook",
						Content = "Test embed sent",
						Duration = 3
					})
				end)
			})
		end

		do
			local v4799 = v4742:AddTab({
				Name = "Auto",
				Icon = "repeat"
			})

			t216.privateTab = v4742:AddTab({
				Name = "Private Server",
				Icon = "users"
			})

			local v4800 = v4799:AddSection("Egg Automation")

			v4800:AddSubSection("Place")
			t216.autoPlace = v4800:AddToggle({
				Title = "Auto Place Egg",
				Content = "Places eggs from your inventory on your plot.",
				Default = false,
				Callback = v4732(v4566)
			})
			t216.placeRarity = v4800:AddDropdown({
				Title = "Place Egg Rarity",
				Content = "Only place these rarities. Leave empty for all.",
				Options = v4524,
				Multi = true,
				Default = {},
				Callback = v4732(function(p1073)
					senaV4Config.PlaceRarities = v4320(p1073)
				end)
			})
			v4800:AddSubSection("Hatch")
			t216.autoHatch = v4800:AddToggle({
				Title = "Auto Hatch Egg",
				Content = "Hatches your placed eggs when they are ready.",
				Default = false,
				Callback = v4732(v4567)
			})
			v4800:AddSubSection("Mutate")
			t216.mutationChoice = v4800:AddDropdown({
				Title = "Select Mutation",
				Content = "Which mutation to apply to your placed eggs.",
				Options = {
					"Scrambled",
					"Fractured"
				},
				Multi = false,
				Default = "Scrambled",
				Callback = v4732(v4570)
			})
			t216.mutationSpecies = v4800:AddDropdown({
				Title = "Mutate Egg Name",
				Content = "Only mutate these eggs by name. Leave empty for every placed egg.",
				Options = v4522,
				Multi = true,
				Default = {},
				Callback = v4732(v4571)
			})
			t216.mutationRarity = v4800:AddDropdown({
				Title = "Mutate Egg Rarity",
				Content = "Only mutate placed eggs of these rarities. Leave empty for every rarity.",
				Options = v4524,
				Multi = true,
				Default = {},
				Callback = v4732(v4572)
			})
			t216.mutationRetry = v4800:AddToggle({
				Title = "Retry Until Mutated",
				Content = "Keep applying to one egg until it mutates or charges run out (10% per use).",
				Default = true,
				Callback = v4732(v4573)
			})
			t216.autoMutation = v4800:AddToggle({
				Title = "Auto Apply Mutation",
				Content = "Equips the selected mutation consumable and applies it to your placed eggs.",
				Default = false,
				Callback = v4732(v4568)
			})
			v4800:AddButton({
				Title = "Apply Mutation Now",
				Content = "Run one mutation pass over your placed eggs right now.",
				Callback = v4732(function()
					task.spawn(function()
						pcall(t24.mutationSweep)
					end)
				end)
			})

			local v4801 = v4742:AddTab({
				Name = "Pets",
				Icon = "sparkles"
			})
			local v4802 = v4801:AddSection("Pet Selling")

			t216.autoSell = v4802:AddToggle({
				Title = "Auto Sell Pet",
				Content = "Sells pets that match a filter below. Favorite, placed and equipped pets are kept.",
				Default = false,
				Callback = v4732(v4574)
			})
			v4802:AddSubSection("Filter")
			v4519 = v4802:AddDropdown({
				Title = "Pet Name Filter",
				Content = "Pets to sell by name. Pick All for every name.",
				Options = v4525,
				Multi = true,
				Default = {},
				Callback = v4732(function(p1074)
					senaV4Config.SellNames = v4320(p1074)
				end)
			})
			v4520 = v4802:AddDropdown({
				Title = "Pet Rarity Filter",
				Content = "Pets to sell by rarity. Pick All for every rarity.",
				Options = v4330(v4524),
				Multi = true,
				Default = {},
				Callback = v4732(function(p1075)
					senaV4Config.SellRarities = v4320(p1075)
				end)
			})
			t216.sellPetValue = v4802:AddInput({
				Flag = "sellPetValue",
				Title = "Sell By Value (max money/s)",
				Content = "Only sell pets whose money per second is this or lower. Blank = no value limit. Supports k, m, b.",
				Placeholder = "e.g. 100k, 2m",
				Default = "",
				Callback = v4732(v4576)
			})

			local v4803 = v4801:AddSection("Egg Selling")

			t216.autoSellEgg = v4803:AddToggle({
				Title = "Auto Sell Egg",
				Content = "Sells unplaced eggs of the rarities below.",
				Default = false,
				Callback = v4732(v4575)
			})
			v4521 = v4803:AddDropdown({
				Title = "Egg Rarity Filter",
				Content = "Egg rarities to sell. Pick All for every rarity.",
				Options = v4330(v4524),
				Multi = true,
				Default = {},
				Callback = v4732(function(p1076)
					senaV4Config.SellEggRarities = v4320(p1076)
				end)
			})
			t216.sellEggValue = v4803:AddInput({
				Flag = "sellEggValue",
				Title = "Sell By Value (max money/s)",
				Content = "Only sell eggs whose money per second is this or lower. Blank = no value limit. Supports k, m, b.",
				Placeholder = "e.g. 100k, 2m",
				Default = "",
				Callback = v4732(v4577)
			})

			local v4804 = v4742:AddTab({
				Name = "Events",
				Icon = "flame"
			})
			local v4805 = v4801:AddSection("Pet Favorite")

			t216.autoFavorite = v4805:AddToggle({
				Title = "Auto Favorite",
				Content = "Marks every pet that matches the rule below as a favorite, so Auto Sell and Auto Fuse leave it alone.",
				Default = false,
				Callback = v4732(v4548)
			})
			t216.favoriteRule = v4805:AddDropdown({
				Title = "Favorite Rule",
				Content = "Match pets by rarity or by species.",
				Options = {
					"Rarity",
					"Species"
				},
				Default = "Rarity",
				Callback = v4732(v4549)
			})
			v4805:AddSubSection("Only when Rule = Rarity")
			t216.favoriteRarities = v4805:AddDropdown({
				Title = "Rarities to Keep",
				Content = "Pets of these rarities get favorited.",
				Options = v4524,
				Multi = true,
				Default = {},
				Callback = v4732(v4550)
			})
			v4805:AddSubSection("Only when Rule = Species")
			t216.favoriteSpecies = v4805:AddDropdown({
				Title = "Species to Keep",
				Content = "Pets of these species get favorited.",
				Options = v4522,
				Multi = true,
				Default = {},
				Callback = v4732(v4551)
			})
			t216.unfavoriteAll = v4805:AddButton({
				Title = "Unfavorite Everything",
				Content = "Clears the favorite flag on every pet you own.",
				Callback = v4732(function()
					local __SenaV4PetBarn = genv.__SenaV4PetBarn
					local n83 = 0

					if __SenaV4PetBarn and type(__SenaV4PetBarn.unfavoriteAll) == "function" then
						n83 = __SenaV4PetBarn.unfavoriteAll() or 0
					end

					SenaLibOverride:Notify({
						Title = "Pet Favorite",
						Content = n83 .. " pets unfavorited",
						Duration = 3
					})
				end)
			})

			local v4808 = v4801:AddSection("Pet Fusion")

			t216.autoFuse = v4808:AddToggle({
				Title = "Auto Fuse",
				Content = "Feeds three matching pets into the Fusion machine over and over. Favorited and equipped pets are never used.",
				Default = false,
				Callback = v4732(v4556)
			})
			t216.fuseRule = v4808:AddDropdown({
				Title = "Fusion Rule",
				Content = "Fuse anything that passes the rarity filter, or only the species you pick below.",
				Options = {
					"Any Species",
					"Selected Species"
				},
				Default = "Any Species",
				Callback = v4732(v4557)
			})
			t216.fuseRarities = v4808:AddDropdown({
				Title = "Rarities to Fuse",
				Content = "Only fuse pets of these rarities. Leave empty for any rarity.",
				Options = v4524,
				Multi = true,
				Default = {},
				Callback = v4732(v4558)
			})
			v4808:AddSubSection("Only when Rule = Selected Species")
			t216.fuseSpecies = v4808:AddDropdown({
				Title = "Species to Fuse",
				Content = "Only these species go into the machine.",
				Options = v4522,
				Multi = true,
				Default = {},
				Callback = v4732(v4559)
			})

			local v4809 = v4799:AddSection("Equip & Collect")

			t216.autoEquipBest = v4809:AddToggle({
				Title = "Auto Equip Best",
				Content = "Keeps your strongest pets equipped as better ones hatch.",
				Default = false,
				Callback = v4732(v4552)
			})
			t216.autoClaimOffline = v4809:AddToggle({
				Title = "Collect Offline Income",
				Content = "Claims the money your base earned while you were away, as soon as there is any.",
				Default = false,
				Callback = v4732(v4553)
			})
			t216.autoBaseUpgrade = v4809:AddToggle({
				Title = "Auto Upgrade Base",
				Content = "Buys the next base tier the moment you can afford it.",
				Default = false,
				Callback = v4732(v4554)
			})
			t216.autoClaimAlmanac = v4809:AddToggle({
				Title = "Auto Claim Almanac",
				Content = "Redeems every Pet Index reward that is ready. This is the reward claim, not the steal objective.",
				Default = false,
				Callback = v4732(v4555)
			})
			t216.upgradeBaseOnce = v4809:AddButton({
				Title = "Upgrade Base Now",
				Content = "Buys one base tier right away.",
				Callback = v4732(function()
					local __SenaV4Upgrades = genv.__SenaV4Upgrades
					local v4811 = false
					local s18 = "Upgrades not ready"

					if __SenaV4Upgrades and type(__SenaV4Upgrades.upgradeBase) == "function" then
						v4811, s18 = __SenaV4Upgrades.upgradeBase()
					end

					local v4813 = SenaLibOverride
					local Notify = SenaLibOverride.Notify
					local t221 = {
						Title = "Base"
					}
					local content = v4811 and "Base upgraded"

					if not content then
						content = tostring(s18 or "Could not upgrade")
					end

					t221.Content = content
					t221.Duration = 3
					Notify(v4813, t221)
				end)
			})

			local __SenaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime
			local v4818 = v4804:AddSection("Butterfly Bloom")
			local v4819 = v4818:AddParagraph({
				Title = "Bloom Status",
				Content = "Reading the Bloom schedule..."
			})

			t216.bloomAutoNet = v4818:AddToggle({
				Title = "Auto Claim Net",
				Content = "Goes into the Enchanted Tree and claims your free Butterfly Net once.",
				Default = false,
				Callback = v4732(function(p1077)
					senaV4Config.ButterflyAutoNet = p1077 == true
				end)
			})
			t216.bloomAutoCatch = v4818:AddToggle({
				Title = "Auto Catch",
				Content = "During every Bloom (every 30 min, 5 min long) flies to the Enchanted Forest, equips the net and catches with the Catch Mode below.",
				Default = false,
				Callback = v4732(function(p1078)
					senaV4Config.ButterflyAutoCatch = p1078 == true
				end)
			})

			local v4820 = __SenaV4ButterflyRuntime and __SenaV4ButterflyRuntime.modeOptions() or { "Tween to Butterfly" }

			t216.bloomMode = v4818:AddDropdown({
				Title = "Catch Mode",
				Content = "Tween to Butterfly chases one butterfly at a time. Stand waits in the thickest part of the swarm, Zigzag sweeps back and forth across the forest, Circle loops around the swarm.",
				Options = v4820,
				Multi = false,
				Default = v4820[1],
				Callback = v4732(function(p1079)
					if __SenaV4ButterflyRuntime then
						__SenaV4ButterflyRuntime.setMode(p1079)
					end
				end)
			})
			t216.bloomTiers = v4818:AddDropdown({
				Title = "Catch Tiers",
				Content = "Only swing at these butterflies. Leave empty to catch every tier.",
				Options = __SenaV4ButterflyRuntime and __SenaV4ButterflyRuntime.tierOptions() or {
					"Radiant",
					"Amethyst",
					"Sapphire",
					"Emerald"
				},
				Multi = true,
				Default = {},
				Callback = v4732(function(p1080)
					if __SenaV4ButterflyRuntime then
						__SenaV4ButterflyRuntime.setTiers(v4320(p1080))
					end
				end)
			})
			t216.bloomEsp = v4818:AddToggle({
				Title = "Butterfly ESP",
				Content = "Shows every butterfly's tier and distance while a Bloom is live.",
				Default = false,
				Callback = v4732(function(p1081)
					senaV4Config.ButterflyEsp = p1081 == true
				end)
			})
			v4818:AddSubSection("Trade & Craft")
			t216.bloomAutoTrade = v4818:AddToggle({
				Title = "Auto Trade Up",
				Content = "After each Bloom, trades your butterflies up at the machine inside the Enchanted Tree.",
				Default = false,
				Callback = v4732(function(p1082)
					senaV4Config.ButterflyAutoTrade = p1082 == true
				end)
			})

			local v4821 = __SenaV4ButterflyRuntime and __SenaV4ButterflyRuntime.recipeOptions() or { "All Recipes" }

			t216.bloomRecipe = v4818:AddDropdown({
				Title = "Trade Recipe",
				Content = "Which trade Auto Trade Up runs. For Essence only trades up what the essence recipe is still short of.",
				Options = v4821,
				Multi = false,
				Default = v4821[1],
				Callback = v4732(function(p1083)
					if __SenaV4ButterflyRuntime then
						__SenaV4ButterflyRuntime.setRecipe(p1083)
					end
				end)
			})
			t216.bloomAutoCraft = v4818:AddToggle({
				Title = "Auto Craft Essence",
				Content = "After each Bloom, crafts Enchanted Essence at the shrine once you hold the full recipe.",
				Default = false,
				Callback = v4732(function(p1084)
					senaV4Config.ButterflyAutoCraft = p1084 == true
				end)
			})

			local function v4822(p1085, p1086, p1087, p1088)
				v4818:AddButton({
					Title = p1085,
					Content = p1086,
					Callback = v4732(function()
						if not __SenaV4ButterflyRuntime then
							return
						end

						task.spawn(function()
							__SenaV4ButterflyRuntime.manual = true

							local ok, result, result2 = pcall(p1087)

							__SenaV4ButterflyRuntime.manual = false

							if not ok then
								local v4826 = result

								result = false
								result2 = v4826
							end

							local v4827 = SenaLibOverride
							local Notify = SenaLibOverride.Notify
							local t222 = {
								Title = "Butterfly Bloom"
							}
							local content = result and p1088(result2)

							if not content then
								content = tostring(result2 or "Could not do that")
							end

							t222.Content = content
							t222.Duration = 4
							Notify(v4827, t222)
						end)
					end)
				})
			end

			v4822("Claim Net Now", "Claims the Butterfly Net right now.", function()
				return __SenaV4ButterflyRuntime.claimNet()
			end, function()
				return "Butterfly Net claimed"
			end)
			v4822("Trade Up Now", "Runs the trade recipe once, even with Auto Trade Up off.", function()
				return __SenaV4ButterflyRuntime.tradeUp()
			end, function(p1089)
				return ("Traded up %d time(s)"):format(tonumber(p1089) or 0)
			end)
			v4822("Craft Essence Now", "Crafts Enchanted Essence right now if you hold the full recipe.", function()
				return __SenaV4ButterflyRuntime.craft()
			end, function(p1090)
				return ("Crafted %d Enchanted Essence"):format(tonumber(p1090) or 0)
			end)
			task.spawn(function()
				while v16() do
					if __SenaV4ButterflyRuntime then
						pcall(function()
							local snap = __SenaV4ButterflyRuntime.snap
							local v4832 = __SenaV4ButterflyRuntime.tiers() or {}
							local v4833

							if snap.active then
								local v4834 = math.floor(snap.left or 0)

								v4833 = ("LIVE - ends in %dm %02ds"):format(math.floor(v4834 / 60), v4834 % 60)
							elseif snap.enabled == false then
								v4833 = "Disabled on this server"
							elseif snap.nextIn then
								local v4835 = math.floor(snap.nextIn)

								v4833 = ("Next in %dm %02ds"):format(math.floor(v4835 / 60), v4835 % 60)
							else
								v4833 = "Not running"
							end

							local t223 = {}

							for _, v in ipairs({
								"Golden",
								"Purple",
								"Blue",
								"Green"
							}) do
								t223[#t223 + 1] = ("%s %d"):format(v4832[v] and v4832[v].name or v, snap.counts and snap.counts[v] or 0)
							end

							v4819:SetContent(("%s\n%s  ·  Essence %d  ·  Caught %d\n%s\n%s"):format(v4833, snap.net and (snap.holding and "Net equipped" or "Net owned") or "No Butterfly Net", snap.essence or 0, snap.caught or 0, table.concat(t223, "  ·  "), tostring(__SenaV4ButterflyRuntime.status or "Idle")))
						end)
					end

					task.wait(1)
				end
			end)

			local v4839 = v4804:AddSection("Dr Scramble Event")

			v4839:AddParagraph({
				Title = "About This Event",
				Content = "Dr Scramble's shop, trade-in and boss still run while the event is live. The drones, lost parts and vault are gone from the game."
			})
			t216.scrambleBuy = v4839:AddToggle({
				Title = "Auto Buy Shop",
				Content = "Spends samples on the shop items you pick below, as soon as you can afford them.",
				Default = false,
				Callback = v4732(v4564)
			})
			t216.scrambleBuyList = v4839:AddDropdown({
				Title = "Shop Buy List",
				Content = "Which shop items Auto Buy should purchase. This list fills in once the event shop is open.",
				Options = t218,
				Multi = true,
				Default = {},
				Callback = v4732(v4565)
			})
			v4839:AddSubSection("Trade-In (Experimental Pets)")
			t216.scrambleTradeInTrade = v4839:AddToggle({
				Title = "Auto Trade-In",
				Content = "When the recipe's three requirements are covered, sacrifices the cheapest pet that fits each slot. Favorited, equipped, placed and fusing pets are never spent.",
				Default = false,
				Callback = v4732(function(p1091)
					senaV4Config.ScrambleTradeInTrade = p1091 == true
				end)
			})
			t216.scrambleTradeInReroll = v4839:AddToggle({
				Title = "Auto Free Reroll",
				Content = "When pets are missing and a free reroll is left, rerolls the recipe instead of waiting.",
				Default = false,
				Callback = v4732(function(p1092)
					senaV4Config.ScrambleTradeInReroll = p1092 == true
				end)
			})
			t216.scrambleTradeInBanners = v4839:AddDropdown({
				Title = "Target Banners",
				Content = "Only work the trade-in while one of these banners is up. Leave empty to accept any banner.",
				Options = {
					"Biohazard Pets",
					"Experimental Pets",
					"Unstable DNA"
				},
				Multi = true,
				Default = {},
				Callback = v4732(v4545)
			})
			v4839:AddButton({
				Title = "Trade-In Once",
				Content = "Runs one sacrifice right now, even with Auto Trade-In off.",
				Callback = v4732(function()
					local __SenaV4ScrambleTradeIn = genv.__SenaV4ScrambleTradeIn
					local v4841 = false
					local s19 = "Trade-In not ready"

					if __SenaV4ScrambleTradeIn then
						v4841, s19 = __SenaV4ScrambleTradeIn.tradeOnce()
					end

					SenaLibOverride:Notify({
						Title = "Dr Scramble",
						Content = v4841 and "Sacrifice complete" or tostring(s19),
						Duration = 4
					})
				end)
			})
			v4839:AddButton({
				Title = "Use Free Reroll",
				Content = "Spends one of today's free rerolls on a new recipe.",
				Callback = v4732(function()
					local __SenaV4ScrambleTradeIn = genv.__SenaV4ScrambleTradeIn
					local v4844 = false
					local s20 = "Trade-In not ready"

					if __SenaV4ScrambleTradeIn then
						v4844, s20 = __SenaV4ScrambleTradeIn.reroll()
					end

					SenaLibOverride:Notify({
						Title = "Dr Scramble",
						Content = v4844 and "Recipe rerolled" or tostring(s20),
						Duration = 4
					})
				end)
			})
			v4839:AddButton({
				Title = "Open Trade-In UI",
				Content = "Opens Dr Scramble's Lab window so you can pick pets by hand.",
				Callback = v4732(function()
					if not pcall(function()
						require(ReplicatedStorage.Client.Tabs).Activate("DrScrambleTradeIn")
					end) then
						SenaLibOverride:Notify({
							Title = "Dr Scramble",
							Content = "Could not open the trade-in window",
							Duration = 3
						})
					end
				end)
			})

			local v4846 = v4839:AddParagraph({
				Title = "Trade-In Status",
				Content = "Turn a trade-in toggle on to start reading the recipe."
			})

			task.spawn(function()
				while v16() do
					local __SenaV4ScrambleTradeIn = genv.__SenaV4ScrambleTradeIn

					if __SenaV4ScrambleTradeIn then
						pcall(function()
							v4846:SetContent(string.format([[%s  ·  %s
Rotates in %02d:%02d  ·  Pity %d/%d  ·  Free rerolls %d  ·  Traded %d
Recipe (%d/%d): %s
Held: %s
Missing: %s]], __SenaV4ScrambleTradeIn.banner, __SenaV4ScrambleTradeIn.status, math.floor(__SenaV4ScrambleTradeIn.rotation / 60), __SenaV4ScrambleTradeIn.rotation % 60, __SenaV4ScrambleTradeIn.pity, __SenaV4ScrambleTradeIn.pityMax, __SenaV4ScrambleTradeIn.free, __SenaV4ScrambleTradeIn.trades, __SenaV4ScrambleTradeIn.ready, __SenaV4ScrambleTradeIn.total, __SenaV4ScrambleTradeIn.demands, __SenaV4ScrambleTradeIn.stock, __SenaV4ScrambleTradeIn.missing))
						end)
					end

					task.wait(1)
				end
			end)
			v4839:AddSubSection("Boss Fight")
			t216.scrambleBossAuto = v4839:AddToggle({
				Title = "Auto Boss",
				Content = "When Dr Scramble's boss is live, walks into the arena portal, joins the fight, hits the nearest target with your bat and breaks free from grabs. The clear reward lands automatically. While Auto Steal is on and this is off, an accidental touch on the arena portal is bounced back out so your steal is never hijacked.",
				Default = false,
				Callback = v4732(function(p1093)
					senaV4Config.ScrambleBossAuto = p1093 == true

					if v612 and type(v612._reconcileScramblePortal) == "function" then
						pcall(v612._reconcileScramblePortal, v612)
					end
				end)
			})

			local v4848 = v4839:AddParagraph({
				Title = "Boss Status",
				Content = "Turn Auto Boss on. It sits idle until the boss event goes live."
			})

			task.spawn(function()
				while v16() do
					local __SenaV4ScrambleBoss = genv.__SenaV4ScrambleBoss

					if __SenaV4ScrambleBoss then
						pcall(function()
							v4848:SetContent(string.format("%s  ·  joins %d  ·  hits %d", tostring(__SenaV4ScrambleBoss.status), __SenaV4ScrambleBoss.joins or 0, __SenaV4ScrambleBoss.hits or 0))
						end)
					end

					task.wait(1)
				end
			end)

			local Treadmill = v4799:AddSection("Treadmill")

			t216.autoTreadmill = Treadmill:AddToggle({
				Title = "Auto Treadmill",
				Content = "Walks to your treadmill and farms speed whenever nothing else is running.",
				Default = false,
				Callback = v4732(v4529)
			})
			t216.treadmillUpgrade = Treadmill:AddToggle({
				Title = "Auto Upgrade Treadmill",
				Content = "Buys the next treadmill tier with cash as soon as you can afford it.",
				Default = false,
				Callback = v4732(v4535)
			})
		end

		do
			local v4851 = v4742:AddTab({
				Name = "Misc",
				Icon = "settings"
			})
			local Performance = v4851:AddSection("Performance")

			t216.startupBoost = Performance:AddToggle({
				Title = "Startup Boost",
				Content = "Lowers graphics when the script starts. Turn it off to get the graphics back; hidden pets and eggs return after a rejoin.",
				Default = true,
				Callback = v4732(v4717)
			})
			t216.boostFps = Performance:AddToggle({
				Title = "Boost FPS",
				Content = "Removes extra map details and other players' plots for more FPS.",
				Default = false,
				Callback = v4732(v4719)
			})
			t216.uncapFps = Performance:AddToggle({
				Title = "Uncap FPS",
				Content = "Raises the FPS cap to 240.",
				Default = true,
				Callback = v4732(v4720)
			})

			local Guard = v4851:AddSection("Guard")

			t216.antiGuardKnockback = Guard:AddToggle({
				Title = "Anti Guard Knockback",
				Content = "Cancels the knockback the Forest guard puts on you, so a hit never throws you off the lane.",
				Default = true,
				Callback = v4732(v4547)
			})
			t216.antiHitGuard = Guard:AddToggle({
				Title = "Anti Hit Guard",
				Content = "For eggs you pick up by hand. Pins you in the safe zone behind a look-alike clone until the guard goes back to sleep. Auto Steal has its own guard handling and always wins.",
				Default = false,
				Callback = v4732(v4726)
			})

			local Windows = v4851:AddSection("Windows")

			Windows:AddButton({
				Title = "Egg Logs",
				Content = "Live feed of every egg that spawns on the server.",
				Callback = v4732(function()
					senaPanels.openLogs()
				end)
			})
			Windows:AddButton({
				Title = "Egg Board",
				Content = "Sortable list of the eggs currently up for grabs.",
				Callback = v4732(function()
					senaPanels.openBoard()
				end)
			})
			Windows:AddButton({
				Title = "Inventory & Base",
				Content = "Your pets, eggs and plot status in one window.",
				Callback = v4732(function()
					senaPanels.openInventory()
				end)
			})
			Windows:AddButton({
				Title = "Egg Checker",
				Content = "Pick eggs off the field by hand, then send them all to the steal queue.",
				Callback = v4732(function()
					senaPanels.openChecker()
				end)
			})
			Windows:AddButton({
				Title = "Egg Data & History",
				Content = "Drop-table values per area, plus what has actually spawned this session.",
				Callback = v4732(function()
					senaPanels.openAnalyst()
				end)
			})
			Windows:AddButton({
				Title = "Open All Windows",
				SubTitle = "Close All Windows",
				Content = "Opens every window at once, or hides them again.",
				Callback = v4732(function()
					senaPanels.openAll()
				end),
				SubCallback = v4732(function()
					senaPanels.closeAll()
				end)
			})
			t216.antiTreadmill = v4851:AddSection("Blocker"):AddToggle({
				Title = "Anti Treadmill",
				Content = "Never stay on a treadmill: any mount is dropped right away, and Auto Treadmill is held off while this is on.",
				Default = false,
				Callback = v4732(v4530)
			})

			local v4855 = v4851:AddSection("Server Hop")

			t216.hopNoMatch = v4855:AddToggle({
				Title = "Hop When Nothing Matches",
				Content = "Hop to the emptiest server when no egg matches your filters.",
				Default = false,
				Callback = v4732(v4531)
			})
			v4855:AddSubSection("Limits")
			t216.hopCooldown = v4855:AddSlider({
				Title = "Hop Cooldown",
				Content = "Seconds between auto hops and wait after rejoining.",
				Min = 1,
				Max = 60,
				Default = 5,
				Increment = 1,
				Callback = v4732(v4534)
			})

			local v4856 = t216.privateTab:AddSection("Find Private Server", true)
			local v4857 = v4856:AddParagraph({
				Title = "Current Server",
				Content = "Checking..."
			})

			t216.privateServerMax = v4856:AddDropdown({
				Title = "Max Players",
				Content = "The most players you want in your server, you included. 2 (you + 1) is the easiest to find.",
				Options = {
					"1",
					"2",
					"3",
					"4",
					"5"
				},
				Default = "2",
				Multi = false,
				Callback = v4732(v4532)
			})
			v4856:AddButton({
				Title = "Hop Server Now",
				Content = "Moves you to a quieter server right away.",
				Callback = v4732(function()
					task.spawn(function()
						t145.hopPrivateOnce()
					end)
				end)
			})
			t216.privateServerAuto = v4856:AddToggle({
				Title = "Auto Hop",
				Content = "Keeps moving you to quieter servers until the player count is at or under your max.",
				Default = false,
				Callback = v4732(v4533)
			})
			task.spawn(function()
				local v4858

				while v16() do
					local v4859 = "Now: " .. #Players:GetPlayers() .. " player(s)  ·  Max: " .. t145.privateMax() .. "\n" .. tostring(t145.privateStatus or "")

					if v4859 ~= v4858 then
						v4858 = v4859
						pcall(function()
							v4857:SetContent(v4859)
						end)
					end

					task.wait(1)
				end
			end)

			local Roaming = v4851:AddSection("Roaming")

			t216.waypoint = Roaming:AddDropdown({
				Title = "Waypoint",
				Content = "Pick a place, then hit Teleport below.",
				Options = t217,
				Default = t217[1],
				Callback = v4732(function(p1094)
					u4745 = p1094
				end)
			})
			Roaming:AddButton({
				Title = "Teleport To Waypoint",
				Content = "Moves you straight to the waypoint you picked.",
				Callback = v4732(function()
					local __SenaV4Roaming = genv.__SenaV4Roaming
					local v4862 = false

					if __SenaV4Roaming and type(__SenaV4Roaming.teleportWaypoint) == "function" then
						v4862 = __SenaV4Roaming.teleportWaypoint(u4745) == true
					end

					SenaLibOverride:Notify({
						Title = "Waypoint",
						Content = v4862 and "Moved to " .. tostring(u4745) or "That waypoint is not in this server",
						Duration = 3
					})
				end)
			})

			local v4863 = v4851:AddSection("Run Once")

			v4863:AddButton({
				Title = "Place Everything Now",
				Content = "Runs one pass of Auto Place, even while the toggle is off.",
				Callback = v4732(function()
					runOnce("AutoPlace", t24.AutoPlaceLoop)
				end)
			})
			v4863:AddButton({
				Title = "Hatch Everything Ready",
				Content = "Runs one pass of Auto Hatch, even while the toggle is off.",
				Callback = v4732(function()
					runOnce("AutoHatch", t24.AutoHatchLoop)
				end)
			})
			v4863:AddButton({
				Title = "Sell Pets Now",
				Content = "Runs one pass of Auto Sell Pet using the filters above.",
				Callback = v4732(function()
					runOnce("AutoSell", t24.startAutoSellLoop)
				end)
			})
			v4863:AddButton({
				Title = "Sell Eggs Now",
				Content = "Runs one pass of Auto Sell Egg using the filters above.",
				Callback = v4732(function()
					runOnce("AutoSellEgg", t24.startAutoSellEggLoop)
				end)
			})

			local Session = v4851:AddSection("Session")

			t216.bottingMode = Session:AddToggle({
				Title = "Botting Mode",
				Content = "Turns off 3D rendering and covers the screen in black. Everything keeps running, your GPU does not.",
				Default = false,
				Callback = v4732(v4561)
			})
			t216.antiCutscene = Session:AddToggle({
				Title = "Anti Cutscene",
				Content = "Closes event cutscenes and the intro as soon as the game opens them, so nothing locks your camera.",
				Default = false,
				Callback = v4732(v4562)
			})
			Session:AddButton({
				Title = "Rejoin This Server",
				Content = "Teleports you back into the exact server you are in now.",
				Callback = v4732(function()
					pcall(function()
						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
					end)
				end)
			})
			Session:AddButton({
				Title = "Stop & Unload",
				Content = "Turns every loop off and closes the hub. Run the script again to bring it back.",
				Callback = v4732(function()
					for _, v in ipairs({
						"AutoSteal",
						"AutoPlace",
						"AutoHatch",
						"AutoSell",
						"AutoSellEgg",
						"StealPlayers",
						"AutoFavorite",
						"AutoFusePets",
						"AutoEquipBest",
						"AutoClaimOffline",
						"AutoBaseUpgrade",
						"AutoClaimAlmanac",
						"Noclip",
						"BottingMode",
						"AntiCutscene"
					}) do
						senaV4Config[v] = false
					end

					v4560(false)
					v4561(false)

					if v612 then
						pcall(v612.setEnabled, v612, false)
					end

					local __SenaV4HubShutdown = genv.__SenaV4HubShutdown

					if type(__SenaV4HubShutdown) == "function" then
						task.delay(0.2, function()
							pcall(__SenaV4HubShutdown)
						end)
					end
				end)
			})

			local Player = v4851:AddSection("Player")

			t216.antiAfk = Player:AddToggle({
				Title = "Anti AFK",
				Content = "Blocks the game's idle kick while the script runs.",
				Default = true,
				Callback = v4732(v4727)
			})
			t216.autoReconnect = Player:AddToggle({
				Title = "Auto Reconnect",
				Content = "Automatically reconnects you back to the server upon kick or disconnect.",
				Default = true,
				Callback = v4732(v4728)
			})
			t216.autoExecute = Player:AddToggle({
				Title = "Auto Execute (Rejoin)",
				Content = "Prepares the bootstrapper so the script runs automatically after teleport or reconnect.",
				Default = false,
				Callback = v4732(v4729)
			})
		end

		do
			local v4869 = v4742:AddTab({
				Name = "Steal Players",
				Icon = "swords"
			})
			local v4870 = v4869:AddSection("Auto Steal")

			t216.stealPlayers = v4870:AddToggle({
				Title = "Auto Steal From Players",
				Content = "Chases anyone carrying an egg in the field, bats them until the egg drops, grabs it and banks it. A carrier is only chased when the egg clears the filters below.",
				Default = false,
				Callback = v4732(v4734)
			})
			t216.stealPlayerRarities = v4870:AddDropdown({
				Title = "Rarity Filter",
				Content = "Only chase eggs of these rarities. Empty = uses the Auto Steal rarity filter.",
				Options = v4524,
				Multi = true,
				Default = {},
				Callback = v4732(v4735)
			})
			t216.stealPlayerValue = v4870:AddInput({
				Title = "Minimum Value",
				Content = "Skip carriers holding less than this per second. Supports k, m and b.",
				Placeholder = "e.g. 500k, 2m, 1b",
				Default = "",
				Callback = v4732(v4736)
			})

			local v4871 = v4869:AddSection("Steal From Specific Player", true)
			local v4872 = v4869:AddSection("Steal History", true)
			local v4873
			local v4874

			if v4871.AddActionList then
				v4873 = v4871:AddActionList({
					Title = "Players in this server",
					EmptyText = "Nobody else is in this server.",
					VisibleRows = 6,
					ButtonWidth = 76
				})
				v4874 = v4872:AddActionList({
					Title = "History of stolen eggs from players",
					EmptyText = "No player steals yet.",
					VisibleRows = 5,
					ButtonWidth = 72
				})
			else
				v4871:AddParagraph({
					Title = "Update required",
					Content = "This Sena UI build has no player list yet. Rejoin to pull the latest version."
				})
			end

			v4872:AddButton({
				Title = "Clear History",
				Content = "Wipe the list above.",
				Callback = v4732(function()
					if __SenaV4PlayerSteal then
						__SenaV4PlayerSteal:clearHistory()
					end
				end)
			})

			if __SenaV4PlayerSteal and v4873 then
				local __SenaV4IdentitySetter = genv.__SenaV4IdentitySetter
				local __SenaV4UICapabilityIdentity = genv.__SenaV4UICapabilityIdentity or 8

				local function v4877(p1095)
					if __SenaV4IdentitySetter then
						pcall(__SenaV4IdentitySetter, __SenaV4UICapabilityIdentity)
					end

					if not v4874 or not v4874:Alive() then
						return
					end

					local t224 = {}

					for i, v in ipairs(p1095.history) do
						t224[i] = {
							id = tostring(i),
							name = v.player,
							sub = string.format("<font color=\"#A2A2AE\">%s</font>", os.date("!%H:%M:%S", v.at)),
							status = v.egg,
							statusSub = v.outcome,
							button = false
						}
					end

					v4874:Update(t224)
				end

				__SenaV4PlayerSteal:onChanged(v4877)
				v4877(__SenaV4PlayerSteal)
				task.spawn(function()
					while genv.__SenaV4PlayerSteal == __SenaV4PlayerSteal do
						local ok, result = pcall(function()
							local v4883 = __SenaV4PlayerSteal:listEntries()

							if __SenaV4IdentitySetter then
								pcall(__SenaV4IdentitySetter, __SenaV4UICapabilityIdentity)
							end

							if v4873:Alive() then
								v4873:Update(v4883)
							end
						end)

						if not ok then
							warn("[Sena Steal] Player list update loop error:", result)
						end

						task.wait(1)
					end
				end)
			end
		end

		v4742:AddTab({
			Name = "Live Chat",
			Icon = "chat"
		}):AddSection("Global Chat", true):AddLiveChat({
			Title = "Live Chat",
			Height = 300
		})

		if type(v4742.AddForum) == "function" then
			v4742:AddForum({
				Name = "Forum",
				Icon = "forum",
				Section = "Config Forum"
			})
		end

		do
			local __SenaV4Visual = genv.__SenaV4Visual
			local v4885 = v4742:AddTab({
				Name = "Visual",
				Icon = "eye"
			})
			local t225 = {
				rods = nil,
				fish = nil
			}
			local v4887

			local function v4888()
				if v4887 and __SenaV4Visual then
					pcall(function()
						v4887:SetContent(__SenaV4Visual.status)
					end)
				end
			end
			local function v4889(p1096)
				if not __SenaV4Visual then
					return
				end

				task.spawn(function()
					__SenaV4Visual.spawn(p1096, t225[p1096])
					v4888()
					SenaLibOverride:Notify({
						Title = "Visual",
						Content = __SenaV4Visual.status,
						Duration = 3
					})
				end)
				task.delay(0.1, v4888)
			end

			local v4890 = v4885:AddSection("Fish It")

			v4890:AddSubSection("Rods")

			local v4891 = v4890:AddDropdown({
				Title = "Select Rod",
				Content = "Rods and skins from Fish It. Loading list...",
				Options = {},
				Multi = false,
				Default = nil,
				Callback = v4732(function(p1097)
					t225.rods = p1097
				end)
			})

			v4890:AddButton({
				Title = "Spawn Rod",
				Content = "Downloads the rod and puts it in your backpack. Equip it like a bat. Only you can see it.",
				Callback = v4732(function()
					v4889("rods")
				end)
			})
			v4890:AddSlider({
				Title = "Rod Size",
				Content = "1 = the size it has in Fish It. Spawned rods update right away.",
				Min = 0.5,
				Max = 2,
				Default = 1,
				Increment = 0.1,
				Callback = v4732(function(p1098)
					if not __SenaV4Visual or __SenaV4Visual.rodScale == p1098 then
						return
					end

					__SenaV4Visual.rodScale = p1098
					task.spawn(__SenaV4Visual.respawn, "rods")
				end)
			})
			v4890:AddSubSection("Fish")

			local v4892 = v4890:AddDropdown({
				Title = "Select Fish",
				Content = "Secret and Forgotten fish from Fish It. Loading list...",
				Options = {},
				Multi = false,
				Default = nil,
				Callback = v4732(function(p1099)
					t225.fish = p1099
				end)
			})

			v4890:AddButton({
				Title = "Spawn Fish",
				Content = "Downloads the fish and puts it in your backpack under Pets. Only you can see it.",
				Callback = v4732(function()
					v4889("fish")
				end)
			})
			v4890:AddSlider({
				Title = "Fish Weight",
				Content = "0% = lightest catch, 100% = heaviest Big catch. Size follows Fish It: weight / min weight.",
				Min = 0,
				Max = 100,
				Default = 0,
				Increment = 5,
				Callback = v4732(function(p1100)
					local fishWeight = (tonumber(p1100) or 0) / 100

					if not __SenaV4Visual or __SenaV4Visual.fishWeight == fishWeight then
						return
					end

					__SenaV4Visual.fishWeight = fishWeight
					task.spawn(__SenaV4Visual.respawn, "fish")
				end)
			})
			v4890:AddSubSection("Manage")
			v4887 = v4890:AddParagraph({
				Title = "Status",
				Content = "Idle"
			})
			v4890:AddButton({
				Title = "Remove All Visual Items",
				Content = "Takes every spawned rod and fish out of your backpack.",
				Callback = v4732(function()
					if __SenaV4Visual then
						__SenaV4Visual.clear()
					end

					v4888()
				end)
			})
			task.spawn(function()
				if not __SenaV4Visual then
					return
				end

				local rods = __SenaV4Visual.names("rods")
				local fish = __SenaV4Visual.names("fish")

				pcall(function()
					v4891:Refresh(rods)
				end)
				pcall(function()
					v4892:Refresh(fish)
				end)
				__SenaV4Visual.status = #rods > 0 and string.format("%d rods and %d fish available", #rods, #fish) or "Could not load the item list. Try again later."
				v4888()
			end)

			local v4896 = v4885:AddSection("Steal an Egg")
			local s21 = "Egg"
			local n84 = 50
			local Egg = genv.__SenaV4VisualSAE and genv.__SenaV4VisualSAE.categories("Egg") or {}
			local u4900 = Egg[1]

			v4896:AddDropdown({
				Title = "Type",
				Content = "Egg shows in the Eggs tab, Pet under Pets. Both are fake and local-only.",
				Options = {
					"Egg",
					"Pet"
				},
				Multi = false,
				Default = "Egg",
				Callback = v4732(function(p1101)
					s21 = p1101 or "Egg"
				end)
			})
			v4896:AddDropdown({
				Title = "Select Egg / Pet",
				Content = "Which egg or pet to spawn.",
				Options = Egg,
				Multi = false,
				Default = Egg[1],
				MaxVisible = 8,
				Callback = v4732(function(p1102)
					u4900 = p1102
				end)
			})
			v4896:AddSlider({
				Title = "Size / Flex",
				Content = "Bigger = heavier Kg & higher value (Kg = base weight x scale^3) AND a bigger egg in your hand. 50 hits the billions.",
				Min = 1,
				Max = 100,
				Default = 50,
				Increment = 1,
				Callback = v4732(function(p1103)
					n84 = tonumber(p1103) or 50
				end)
			})
			v4896:AddButton({
				Title = "Hold in Hand",
				Content = "Spawns a model of it in your hand. Press again for more. (In-hand only - use the other button to also add it to All Items.)",
				Callback = v4732(function()
					local __SenaV4VisualSAE = genv.__SenaV4VisualSAE

					if __SenaV4VisualSAE then
						__SenaV4VisualSAE.spawn(s21, u4900, n84, true)
					end
				end)
			})
			v4896:AddButton({
				Title = "Add to Backpack (Kg)",
				Content = "Drops it in All Items (eggs) or Pets with a huge Kg for the inventory flex. Press again for more.",
				Callback = v4732(function()
					local __SenaV4VisualSAE = genv.__SenaV4VisualSAE

					if __SenaV4VisualSAE then
						__SenaV4VisualSAE.spawn(s21, u4900, n84, false)
					end
				end)
			})
			v4896:AddButton({
				Title = "Remove Egg / Pet Visuals",
				Content = "Takes every spawned fake egg/pet and held model out.",
				Callback = v4732(function()
					local __SenaV4VisualSAE = genv.__SenaV4VisualSAE

					if __SenaV4VisualSAE then
						__SenaV4VisualSAE.clear()
					end
				end)
			})
		end

		v4742:AddTab({
			Name = "Donate",
			Icon = "donator"
		}):AddSection("Support Sena", true):AddSupportCard({})

		do
			local function v4904(p1104, p1105)
				v4730()

				if type(p1104) == "table" and p1104.Value ~= nil then
					pcall(p1105, p1104.Value)
				end
			end

			v4731 = false
			v4904(t216.speed, v4537)
			v4904(t216.stealMode, v4536)
			v4904(t216.stealHold, v4527)
			v4904(t216.antiTreadmill, v4530)
			v4904(t216.autoTreadmill, v4529)
			v4904(t216.treadmillUpgrade, v4535)
			v4904(t216.hopCooldown, v4534)
			v4904(t216.hopNoMatch, v4531)
			v4904(t216.privateServerMax, v4532)
			v4904(t216.privateServerAuto, v4533)
			v4904(t216.names, function(p1106)
				v4538("names", "name", p1106)
			end)
			v4904(t216.areas, function(p1107)
				v4538("areas", "area", p1107)
			end)
			v4904(t216.rarities, function(p1108)
				v4538("rarities", "rarity", p1108)
			end)
			v4904(t216.value, v4539)
			v4904(t216.autoIndex, v4737)
			v4904(t216.scrambleBuy, v4564)
			v4904(t216.scrambleBuyList, v4565)
			v4904(t216.bloomAutoNet, function(p1109)
				senaV4Config.ButterflyAutoNet = p1109 == true
			end)
			v4904(t216.bloomAutoCatch, function(p1110)
				senaV4Config.ButterflyAutoCatch = p1110 == true
			end)
			v4904(t216.bloomEsp, function(p1111)
				senaV4Config.ButterflyEsp = p1111 == true
			end)
			v4904(t216.bloomAutoTrade, function(p1112)
				senaV4Config.ButterflyAutoTrade = p1112 == true
			end)
			v4904(t216.bloomAutoCraft, function(p1113)
				senaV4Config.ButterflyAutoCraft = p1113 == true
			end)
			v4904(t216.bloomTiers, function(p1114)
				local __SenaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime

				if __SenaV4ButterflyRuntime then
					__SenaV4ButterflyRuntime.setTiers(v4320(p1114))
				end
			end)
			v4904(t216.bloomRecipe, function(p1115)
				local __SenaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime

				if __SenaV4ButterflyRuntime then
					__SenaV4ButterflyRuntime.setRecipe(p1115)
				end
			end)
			v4904(t216.bloomMode, function(p1116)
				local __SenaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime

				if __SenaV4ButterflyRuntime then
					__SenaV4ButterflyRuntime.setMode(p1116)
				end
			end)
			v4904(t216.noclip, v4560)
			v4904(t216.bottingMode, v4561)
			v4904(t216.antiCutscene, v4562)
			v4904(t216.waypoint, function(p1117)
				u4745 = p1117
			end)
			v4904(t216.autoFavorite, v4548)
			v4904(t216.favoriteRule, v4549)
			v4904(t216.favoriteRarities, v4550)
			v4904(t216.favoriteSpecies, v4551)
			v4904(t216.autoFuse, v4556)
			v4904(t216.fuseRule, v4557)
			v4904(t216.fuseRarities, v4558)
			v4904(t216.fuseSpecies, v4559)
			v4904(t216.autoEquipBest, v4552)
			v4904(t216.autoClaimOffline, v4553)
			v4904(t216.autoBaseUpgrade, v4554)
			v4904(t216.autoClaimAlmanac, v4555)
			v4904(t216.mutations, v4540)
			v4904(t216.weight, v4541)
			v4904(t216.priority, v4542)
			v4904(t216.eggEsp, v4543)
			v4904(t216.espDetails, v4544)
			v4904(t216.backpackRates, v4546)
			v4904(t216.antiGuardKnockback, v4547)
			v4904(t216.placeRarity, function(p1118)
				senaV4Config.PlaceRarities = v4320(p1118)
			end)
			v4904(v4519, function(p1119)
				senaV4Config.SellNames = v4320(p1119)
			end)
			v4904(v4520, function(p1120)
				senaV4Config.SellRarities = v4320(p1120)
			end)
			v4904(v4521, function(p1121)
				senaV4Config.SellEggRarities = v4320(p1121)
			end)
			v4904(t216.sellPetValue, v4576)
			v4904(t216.sellEggValue, v4577)
			v4904(t216.godMode, v4528)
			v4904(t216.antiAfk, v4727)
			v4904(t216.autoReconnect, v4728)
			v4904(t216.autoExecute, v4729)
			v4904(t216.antiHitGuard, v4726)
			v4904(t216.flyForCapture, v4722)
			v4904(t216.autoStealCapture, v4724)
			v4904(t216.instantGrab, v4723)
			v4904(t216.infiniteJump, v4725)
			v4904(t216.uncapFps, v4720)
			v4904(t216.startupBoost, v4717)
			v4904(t216.autoPlace, v4566)
			v4904(t216.autoHatch, v4567)
			v4904(t216.mutationChoice, v4570)
			v4904(t216.mutationSpecies, v4571)
			v4904(t216.mutationRarity, v4572)
			v4904(t216.mutationRetry, v4573)
			v4904(t216.autoMutation, v4568)
			v4904(t216.autoRingEvent, v4569)
			v4904(t216.autoSell, v4574)
			v4904(t216.autoSellEgg, v4575)
			v4904(t216.stealPlayerRarities, v4735)
			v4904(t216.stealPlayerValue, v4736)
			v4904(t216.webhookUrl, v4739)
			v4904(t216.webhookRarities, v4740)
			v4904(t216.webhookValue, v4741)
			v4904(t216.webhookEnabled, v4738)
			v4904(t216.helpFriend, function(p1122)
				senaV4Config.HelpFriend = p1122 == true
			end)
			v4904(t216.autoSteal, v4526)
			v4904(t216.stealPlayers, v4734)
		end

		do
			genv.__SenaV4HubShutdown = function()
				if __SenaV4PlayerSteal then
					pcall(__SenaV4PlayerSteal.setEnabled, __SenaV4PlayerSteal, false)
				end

				for _, v in ipairs({
					"AutoSteal",
					"AutoPlace",
					"AutoHatch",
					"AutoMutation",
					"AutoRingEvent",
					"AutoSell",
					"AutoSellEgg",
					"StealPlayers",
					"ScrambleBossAuto",
					"ButterflyAutoCatch",
					"ButterflyAutoNet",
					"ButterflyAutoTrade",
					"ButterflyAutoCraft"
				}) do
					senaV4Config[v] = false
				end

				if v612 then
					pcall(v612.setEnabled, v612, false)
				end
			end
		end
	end

	v4315()
end
