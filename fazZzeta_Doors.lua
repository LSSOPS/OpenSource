local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local userInputService = game:GetService("UserInputService")
local debris = game:GetService("Debris")
local proximityPromptService = game:GetService("ProximityPromptService")
local tweenService = game:GetService("TweenService")
local soundService = game:GetService("SoundService")
local statsService = game:GetService("Stats")
local httpService = game:GetService("HttpService")
local pathfindingService = game:GetService("PathfindingService")
local localPlayer = players.LocalPlayer
local currentCamera = workspace.CurrentCamera

while true do
  task.wait()

  if game:IsLoaded() then
    break
  end
end

local f1, f2, v1, v2, v3, espLibrary, save, load, options, toggles, v4, v5, v6, v7, f3, f4, f5,
  v8, f6, pathFolder, v9, v10, v11, v12, v13, v14, floor, latestRoom, mainGame, remoteListener,
  v15, motorReplication, collisionClone, pl, raycastParams, seekPath, v16, v17, esp, v18, v19,
  v20, v21, getMoveVector, v22, a90, v23, f7, customPhysicalProperties, v24, v25, f8, fogEnd,
  screech, v26, surgeRemote, v27, v28, f9, f10, v29, v30, v31, v32, v33, v34, v35, f11

if localPlayer:GetAttribute("fazZzetaLoaded") then
  if getgenv().Library then
    getgenv().Library:Notify("fazZzeta doors 『 Already Loaded 』", 4)
  else
    print("fazZzeta doors 『 Already Loaded 』")
  end

  return
else
  localPlayer:SetAttribute("fazZzetaLoaded", true)

  while true do
    task.wait()

    if localPlayer.Character then
      break
    end
  end

  if getgenv().ScriptLibrary ~= "Linoria" then
    local v36 = getgenv()
    v36.ScriptLibrary = getgenv().ScriptLibrary or "Linoria"
  end

  v1 = nil

  if getgenv().ScriptLibrary == "Obsidian" then
    v1 = "https://raw.githubusercontent.com/mstudio45/Obsidian/main/"
  elseif getgenv().ScriptLibrary == "Linoria" then
    v1 = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
  end

  v2 = loadstring(game:HttpGet(v1 .. "Library.lua"))()
  task.wait()
  local v37 = nil
  v3 = nil
  pcall(function() v3 = loadstring(game:HttpGet(v1 .. "addons/SaveManager.lua"))() end)
  espLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/ESPLibrary"))()
  ESPShowText = false
  ESPShowEntityText = false
  AlmaEnabled = false
  DronesEnabled = false
  BashEnabled = false
  ScribbleEnabled = false
  InfiniteCrucifixEnabled = false

  InfiniteItemsSelected = {
    Lockpick = true,
    ["Skeleton Key"] = true,
    Shears = true,
    Multitool = true,
  }

  SelectedItems = {}
  SelectedEntities = {}
  TracerPosition = "Bottom"
  TracerThickness = 1
  ShowArrows = false
  CurrentLanguage = "English"

  if v3 then
    save = v3.Save

    function v3.Save(p1, p2)
      local v38

      if v2.KeybindFrame then
        local position = v2.KeybindFrame.Position
        v38 = { position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset }
        getgenv().FazZzetaDoors_KeybindPos = v38

        pcall(function()
          if writefile and p1.Folder then
            writefile(
              p1.Folder .. "/settings/" .. p2 .. "_keybindpos.json", httpService:JSONEncode(v38)
            )
          end
        end)
      end

      return save(p1, p2)
    end

    load = v3.Load

    function v3.Load(p3, p4)
      local v39 = load(p3, p4)

      pcall(function()
        if isfile and p3.Folder
          and isfile(p3.Folder .. "/settings/" .. p4 .. "_keybindpos.json") then
          local jsonDecode = httpService:JSONDecode(readfile(p3.Folder .. "/settings/" .. p4
            .. "_keybindpos.json"))

          if jsonDecode and v2.KeybindFrame then
            v2.KeybindFrame.Position = UDim2.new(
              jsonDecode[1], jsonDecode[2], jsonDecode[3], jsonDecode[4]
            )

            getgenv().FazZzetaDoors_KeybindPos = jsonDecode
          end
        end
      end)

      return v39
    end
  end

  options = v2.Options
  toggles = v2.Toggles
  v4 = {}

  local window = v2:CreateWindow({
    Title = "fazZzeta doors",
    Center = true,
    ToggleKeybind = Enum.KeyCode.RightControl,
    AutoShow = true,
    NotifySide = "Right",
    ShowCustomCursor = true,
  })

  if v2.KeybindFrame then
    if getgenv().FazZzetaDoors_KeybindPos then
      local fazZzetaDoorsKeybindPos = getgenv().FazZzetaDoors_KeybindPos

      v2.KeybindFrame.Position = UDim2.new(
        fazZzetaDoorsKeybindPos[1], fazZzetaDoorsKeybindPos[2], fazZzetaDoorsKeybindPos[3],
        fazZzetaDoorsKeybindPos[4]
      )
    end

    local position2 = v2.KeybindFrame:GetPropertyChangedSignal("Position")

    table.insert(v4, position2:Connect(function()
      local position3 = v2.KeybindFrame.Position

      getgenv().FazZzetaDoors_KeybindPos = {
        position3.X.Scale, position3.X.Offset, position3.Y.Scale, position3.Y.Offset,
      }
    end))
  end

  function f1(p5, p6)
    v2:Notify(p5, p6)

    if v5 then
      local instance = Instance.new("Sound", soundService)
      instance.SoundId = "rbxassetid://101511361468852"
      instance.PlaybackSpeed = 0.77
      instance.Volume = 2
      instance:Play()

      debris:AddItem(instance, 3)
    end
  end

  v5 = true

  function AddESP(object, p7, color)
    espLibrary:AddESP({ Object = object, Text = ESPShowText and p7 or "", Color = color })
  end

  function AddEntityESP(p8, p9, color2)
    if p8:IsA("Model") then
      while not p8.PrimaryPart do
        for key, value in pairs(p8:GetChildren()) do
          if value:IsA("BasePart") then
            p8.PrimaryPart = value
          end
        end

        task.wait()
      end

      if p8.PrimaryPart then
        p8.PrimaryPart.Transparency = 0.99
      end

      if not p8:FindFirstChildOfClass("Humanoid") then
        Instance.new("Humanoid", p8)
      end
    end

    if p8.Name == "FigureRig" or p8.Name == "FigureRagdoll" then
      p8:WaitForChild("Root").Size = Vector3.new(0.001, 0.001, 0.001)
    end

    espLibrary:AddESP({ Object = p8, Text = ESPShowEntityText and p9 or "", Color = color2 })
  end

  v6 = "Unknown"
  v7 = "N/A"

  if identifyexecutor then
    pcall(function()
      local v40, v41 = identifyexecutor()

      if v40 then
        v6 = v40
      end

      if v41 ~= nil then
        v7 = tostring(v41)
      end
    end)
  end

  function f3()
    local v42, v43 = pcall(function()
      return players:GetUserThumbnailAsync(
        localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420
      )
    end)

    if v42 then
      return v43
    end

    return nil
  end

  function GetLibraryCode()
    local v44 = table.create(replicatedStorage.GameData.Floor.Value == "Fools" and 10 or 5, "_")
    local libraryHintPaper

    for key2, value2 in pairs(players:GetPlayers()) do
      local character = value2.Character

      if character then
        libraryHintPaper = character:FindFirstChild("LibraryHintPaper")
          or character:FindFirstChild("LibraryHintPaperHard")
          or value2.Backpack:FindFirstChild("LibraryHintPaper")
          or value2.Backpack:FindFirstChild("LibraryHintPaperHard")

        if libraryHintPaper then
          break
        end
      end
    end

    if not libraryHintPaper then
      return table.concat(v44)
    else
      local getChildren = localPlayer.PlayerGui.PermUI.Hints:GetChildren()

      for key3, value3 in pairs(libraryHintPaper.UI:GetChildren()) do
        if value3:IsA("ImageLabel") and value3.Name ~= "Image" then
          local v45 = tonumber(value3.Name)

          if v45 and v44[v45] then
            for key4, value4 in pairs(getChildren) do
              if value4.Name == "Icon" and value4.ImageRectOffset.X == value3.ImageRectOffset.X then
                local textLabel = value4:FindFirstChild("TextLabel")

                if textLabel then
                  v44[v45] = textLabel.Text
                end

                break
              end
            end
          end
        end
      end

      return table.concat(v44)
    end
  end

  function f4(p10, p11)
    local lower = p10:lower()

    for index, value5 in ipairs(p11) do
      if lower:find(value5) then
        return true
      end
    end

    return false
  end

  function f5(p12)
    local count = 0
    local currentRooms = workspace:FindFirstChild("CurrentRooms")

    if currentRooms then
      for index2, value6 in ipairs(currentRooms:GetDescendants()) do
        local v46 = value6

        if f4(v46.Name, p12) then
          if v46:IsA("Model") or #v46:GetChildren() > 0 then
            pcall(function() v46:Destroy() end)
            count = count + 1
          end
        end
      end
    end

    for index3, value7 in ipairs(workspace:GetChildren()) do
      local v47 = value7

      if f4(v47.Name, p12) then
        pcall(function() v47:Destroy() end)
        count = count + 1
      end
    end

    return count
  end

  v8 = {
    { Flag = function() return AlmaEnabled end, Keywords = { "alma", "алма" } },
    {
      Flag = function() return DronesEnabled end,
      Keywords = { "drone", "бездельник" },
    },
    { Flag = function() return BashEnabled end, Keywords = { "bash", "бэш" } },
    { Flag = function() return ScribbleEnabled end, Keywords = { "scribble", "скрибл" } },
  }

  BaseItems = {}

  BaseEntities = {
    "Alma", "Ambush", "Bash", "Blitz", "Bob", "Bramble", "Creak", "Drone", "Dread", "Dupe",
    "El Goblino", "Eyes", "Figure", "Forget-Me-Not", "Giggle", "Glitch", "Glitch Ambush",
    "Glitch Rush", "Ground Keeper", "Grumble", "Halt", "Haste", "Hide", "Honcho", "Jack",
    "Jeff", "Lookman", "Louie", "Monument", "Noise", "Portrait", "Queen Grumble", "Rush",
    "Sally", "Scribbles", "Seek", "Snare", "Stem", "Teller", "Timothy",
  }

  Translations = {
    English = { Items = {}, Entities = {} },
    Russian = {
      Items = {
        ["Alarm Clock"] = "Будильник",
        Bandage = "Бинт",
        ["Bandage Pack"] = "Упаковка бинтов",
        Battery = "Батарейка",
        ["Battery Pack"] = "Батарейный блок",
        ["Big Shield"] = "Большой щит",
        Briefcase = "Портфель",
        ["Bulk Light"] = "Мощный фонарь",
        Candle = "Свеча",
        Candy = "Конфета",
        Chest = "Сундук",
        ["Chest Vine"] = "Лоза-сундук",
        ["Circuit Breaker"] = "Автоматический выключатель",
        Compass = "Компас",
        Crucifix = "Распятие",
        Drawer = "Ящик",
        ["Electrical Room Key"] = "Ключ от электрощитовой",
        ["Fih Food"] = "Еда для рыб",
        ["Flash light"] = "Фонарик",
        ["Glow Sticks"] = "Светящиеся палочки",
        Gold = "Золото",
        ["Golden Gun"] = "Золотой пистолет",
        ["Green Herb"] = "Зелёная трава",
        ["Gummy Flashlight"] = "Мармеладный фонарь",
        ["Gween Soda"] = "Зелёная газировка",
        ["Holy Grenade"] = "Святая граната",
        ["Hint Paper"] = "Бумага с подсказкой",
        ["Iron Key"] = "Железный ключ",
        ["Jug of Bottle"] = "Бутыль",
        Lantern = "Фонарь",
        ["Laser Pointer"] = "Лазерная указка",
        Lever = "Рычаг",
        Lighter = "Зажигалка",
        Lockpick = "Отмычка",
        ["Locked Chest"] = "Запертый сундук",
        ["Locked Toolbox"] = "Запертый ящик",
        ["Lotus Petal"] = "Лепесток лотоса",
        ["Louie Mouse"] = "Мышонок Луи",
        ["Lunch Box"] = "Ланчбокс",
        ["Mini Shield"] = "Малый щит",
        ["Moonlight Candle"] = "Лунная свеча",
        ["Moonlight Float"] = "Лунный плот",
        Mug = "Кружка",
        Multitool = "Мультитул",
        Note = "Записка",
        ["NVCS-3000"] = "НВКС-3000",
        ["Pack of Gween Soda"] = "Упаковка зелёной газировки",
        ["Paper Cup"] = "Бумажный стакан",
        ["Paper Plane"] = "Бумажный самолётик",
        Pizza = "Пицца",
        ["Pocket Mirror"] = "Карманное зеркало",
        ["Puzzle Painting"] = "Картина-пазл",
        ["Room Key"] = "Ключ от комнаты",
        ["Shake Light"] = "Фонарь-трясучка",
        Shears = "Ножницы",
        ["Skeleton Key"] = "Скелетный ключ",
        Smoothie = "Смузи",
        ["Solution Paper"] = "Бумага с решением",
        ["Star Bottle"] = "Звёздная бутылка",
        ["Star Vial"] = "Звёздный флакон",
        Stardust = "Звёздная пыль",
        ["Strap Light"] = "Ремешок-фонарь",
        Toolshed = "Сарай",
        ["Vine Lever"] = "Рычаг-лоза",
        Vitamin = "Витамин",
        ["Waiting Ticket"] = "Талон ожидания",
        ["Water Pump"] = "Водяной насос",
        Door = "Дверь",
        ["Gate Lever"] = "Рычаг ворот",
        Key = "Ключ",
        ["Electrical Key"] = "Электрический ключ",
        ["Library Book"] = "Книга библиотеки",
        Breaker = "Рубильник",
        Ladder = "Лестница",
        Fuse = "Предохранитель",
        Generator = "Генератор",
        ["Gate Button"] = "Кнопка ворот",
      },
      Entities = {
        Alma = "Альма",
        Ambush = "Амбуш",
        Bash = "Бэш",
        Blitz = "Блиц",
        Bob = "Боб",
        Bramble = "Брамбл",
        Creak = "Скрип",
        Drone = "Дрон",
        Dread = "Дред",
        Dupe = "Дюп",
        ["El Goblino"] = "Эль-Гоблино",
        Eyes = "Глаза",
        Figure = "Фигура",
        ["Forget-Me-Not"] = "Незабудка",
        Giggle = "Хихи",
        Glitch = "Глитч",
        ["Glitch Ambush"] = "Глитч-Амбуш",
        ["Glitch Rush"] = "Глитч-Раш",
        ["Ground Keeper"] = "Смотритель",
        Grumble = "Грамбл",
        Halt = "Халт",
        Haste = "Хейст",
        Hide = "Хайд",
        Honcho = "Хончо",
        Jack = "Джек",
        Jeff = "Джефф",
        Lookman = "Лукмен",
        Louie = "Луи",
        Monument = "Монумент",
        Noise = "Шум",
        Portrait = "Портрет",
        ["Queen Grumble"] = "Королева Грамбл",
        Rush = "Раш",
        Sally = "Салли",
        Scribbles = "Скриблз",
        Seek = "Сик",
        Snare = "Снар",
        Stem = "Стем",
        Teller = "Теллер",
        Timothy = "Тимоти",
      },
    },
    French = {
      Items = {
        ["Alarm Clock"] = "Réveil",
        Bandage = "Bandage",
        Battery = "Pile",
        Candle = "Bougie",
        Candy = "Bonbon",
        Chest = "Coffre",
        Compass = "Boussole",
        Crucifix = "Crucifix",
        ["Flash light"] = "Lampe torche",
        Gold = "Or",
        Lantern = "Lanterne",
        Lighter = "Briquet",
        Lockpick = "Crochet",
        Multitool = "Multi-outil",
        Shears = "Cisailles",
        ["Skeleton Key"] = "Passe-partout",
        Vitamin = "Vitamine",
        Door = "Porte",
        Key = "Clé",
        Ladder = "Échelle",
        Fuse = "Fusible",
        Generator = "Générateur",
      },
      Entities = {
        Rush = "Rush",
        Ambush = "Ambush",
        Seek = "Seek",
        Figure = "Figure",
        Eyes = "Yeux",
        Jack = "Jack",
        Halt = "Halt",
        Haste = "Hâte",
        Hide = "Cache",
        Jeff = "Jeff",
        Snare = "Piège",
        Alma = "Alma",
        Drone = "Drone",
      },
    },
    German = {
      Items = {
        ["Alarm Clock"] = "Wecker",
        Bandage = "Verband",
        Battery = "Batterie",
        Candle = "Kerze",
        Candy = "Bonbon",
        Chest = "Truhe",
        Compass = "Kompass",
        Crucifix = "Kruzifix",
        ["Flash light"] = "Taschenlampe",
        Gold = "Gold",
        Lantern = "Laterne",
        Lighter = "Feuerzeug",
        Lockpick = "Dietrich",
        Multitool = "Multitool",
        Shears = "Schere",
        ["Skeleton Key"] = "Dietrich",
        Vitamin = "Vitamin",
        Door = "Tür",
        Key = "Schlüssel",
        Ladder = "Leiter",
        Fuse = "Sicherung",
        Generator = "Generator",
      },
      Entities = {
        Rush = "Rush",
        Ambush = "Ambush",
        Seek = "Seek",
        Figure = "Figur",
        Eyes = "Augen",
        Jack = "Jack",
        Halt = "Halt",
        Haste = "Eile",
        Hide = "Versteck",
        Jeff = "Jeff",
        Snare = "Falle",
        Alma = "Alma",
        Drone = "Drohne",
      },
    },
    Chinese = {
      Items = {
        ["Alarm Clock"] = "闹钟",
        Bandage = "绷带",
        Battery = "电池",
        Candle = "蜡烛",
        Candy = "糖果",
        Chest = "箱子",
        Compass = "指南针",
        Crucifix = "十字架",
        ["Flash light"] = "手电筒",
        Gold = "黄金",
        Lantern = "灯笼",
        Lighter = "打火机",
        Lockpick = "开锁器",
        Multitool = "多功能工具",
        Shears = "剪刀",
        ["Skeleton Key"] = "万能钥匙",
        Vitamin = "维生素",
        Door = "门",
        Key = "钥匙",
        Ladder = "梯子",
        Fuse = "保险丝",
        Generator = "发电机",
      },
      Entities = {
        Rush = "冲击",
        Ambush = "伏击",
        Seek = "追猎者",
        Figure = "傀儡",
        Eyes = "眼睛",
        Jack = "杰克",
        Halt = "停止",
        Haste = "急速",
        Hide = "隐藏",
        Jeff = "杰夫",
        Snare = "陷阱",
        Alma = "阿尔玛",
        Drone = "无人机",
      },
    },
  }

  function GetItemName(p13)
    local v48 = Translations[CurrentLanguage]

    if v48 and v48.Items and v48.Items[p13] then
      return v48.Items[p13]
    end

    return p13
  end

  function GetEntityName(p14)
    local v49 = Translations[CurrentLanguage]

    if v49 and v49.Entities and v49.Entities[p14] then
      return v49.Entities[p14]
    end

    return p14
  end

  function GetLocalizedEntityList()
    local v50 = {}

    for index4, value8 in ipairs(BaseEntities) do
      table.insert(v50, GetEntityName(value8))
    end

    return v50
  end

  function RefreshLanguageUI()
    for key5, value9 in pairs(BaseItems) do
      Items[key5] = GetItemName(key5)
    end

    local v51 = {}

    for key6, value10 in pairs(Items) do
      table.insert(v51, value10)
    end

    table.sort(v51)

    if options.ItemESPSelect and options.ItemESPSelect.SetValues then
      pcall(function() options.ItemESPSelect:SetValues(v51) end)
    end

    local v52 = GetLocalizedEntityList()

    if options.EntityESPSelect and options.EntityESPSelect.SetValues then
      pcall(function() options.EntityESPSelect:SetValues(v52) end)
    end

    if options.ItemESPSelect then
      pcall(function() options.ItemESPSelect:SetValue({}) end)
    end

    if options.EntityESPSelect then
      pcall(function() options.EntityESPSelect:SetValue({}) end)
    end

    SelectedItems = {}
    SelectedEntities = {}

    if ESPHooks and ESPHooks.ClearAll and ESPHooks.UpdateAll then
      pcall(function() ESPHooks.ClearAll() end)
      task.defer(function() pcall(function() ESPHooks.UpdateAll() end) end)
    end
  end

  local function f12(p15)
    local account = p15:AddLeftGroupbox("Account")
    account:AddLabel("Username: " .. tostring(localPlayer.Name))
    account:AddLabel("Display Name: " .. tostring(localPlayer.DisplayName))
    account:AddLabel("User ID: " .. tostring(localPlayer.UserId))

    account:AddButton({
      Text = "Copy Avatar URL",
      Func = function()
        task.spawn(function()
          local v53 = f3()

          if v53 and setclipboard then
            pcall(function() setclipboard(v53) end)
            f1("Avatar URL copied to clipboard!", 3)
          elseif v53 then
            f1(v53, 6)
          else
            f1("Failed to fetch avatar URL", 3)
          end
        end)
      end,
    })

    local scriptInfo = p15:AddRightGroupbox("Script Info")
    scriptInfo:AddLabel("Version: 1.2.12-release")
    scriptInfo:AddLabel("Executor: " .. v6)
    scriptInfo:AddLabel("Executor Ver: " .. v7)
    scriptInfo:AddDivider()
    scriptInfo:AddLabel("Update Log v1.2.12:")
    scriptInfo:AddLabel("+ ESP Improvements")
    scriptInfo:AddLabel("+ Language translation (BETA)")
  end

  if workspace:FindFirstChild("Lobby") then
    local v54 = {
      Info = window:AddTab("Info", "info"),
      Main = window:AddTab("Game", "star"),
      Settings = window:AddTab("Settings", "settings"),
    }

    f12(v54.Info)

    local teleport = v54.Main:AddLeftGroupbox("Teleport")
    teleport:AddLabel("Main menu appears after teleport", true)

    function f11(destination, p16)
      local createElevator = replicatedStorage:FindFirstChild("RemotesFolder")
        and replicatedStorage.RemotesFolder:FindFirstChild("CreateElevator")

      if createElevator then
        createElevator:FireServer({
          Mods = {},
          Settings = p16 or {},
          Destination = destination,
          FriendsOnly = false,
          MaxPlayers = "1",
        })
      end
    end

    teleport:AddButton("Teleport to Hotel", function() f11("Hotel") end)
    teleport:AddButton("Teleport to Mines", function() f11("Mines") end)
    teleport:AddButton("Teleport to arhives (PRICE)", function() f11("arhives") end)
    teleport:AddButton("Teleport to Backdoors", function() f11("Backdoor") end)
    teleport:AddButton("Teleport to Outdoors", function() f11("Garden") end)
    teleport:AddButton("Teleport to Retro Mode", function() f11("Retro") end)
    teleport:AddButton("Teleport to Super Hard Mode", function() f11("SuperHardMode") end)
    teleport:AddButton("Teleport to Endless", function() f11("Endless") end)
    teleport:AddButton("Teleport to Rush Mode", function() f11("Fools26") end)
    teleport:AddButton("Teleport to Battle Mode", function() f11("Party") end)

    teleport:AddButton("Teleport to Chaos", function()
      f11("Curated", { youtube = "", twitch = "" })
    end)

    teleport:AddButton("Teleport to Daily Run", function() f11("Daily") end)
    teleport:AddButton("Teleport to Cringles Workshop", function() f11("CringlesWorkshop") end)
    teleport:AddButton("Teleport to Trick Or Treat", function() f11("Halloween25") end)
    teleport:AddButton("Teleport to Hotel-", function() f11("BeforePlus") end)

    local uiSettings = v54.Settings:AddLeftGroupbox("UI Settings")
    local hubUtilities = v54.Settings:AddRightGroupbox("Hub Utilities")

    uiSettings:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
      Default = "RightShift",
      NoUI = true,
      Text = "Menu keybind",
    })

    v2.ToggleKeybind = options.MenuKeybind

    uiSettings:AddToggle("ShowKeybinds", { Text = "Show Keybinds Overlay", Default = false }):OnChanged(function()
      v2.KeybindFrame.Visible = toggles.ShowKeybinds.Value
    end)

    uiSettings:AddToggle("ShowCustomCursor", {
      Text = "Custom Cursor",
      Default = true,
      Callback = function(value11) v2.ShowCustomCursor = value11 end,
    })

    uiSettings:AddDivider()

    uiSettings:AddToggle("PlayNotifySound", {
      Text = "Play Notification Sound",
      Default = true,
      Callback = function(value12) v5 = value12 end,
    })

    uiSettings:AddDropdown("NotificationSide", {
      Values = { "Left", "Right" },
      Default = "Right",
      Text = "Notification Side",
      Callback = function(value13) v2:SetNotifySide(value13) end,
    })

    uiSettings:AddButton("Test Notification", function() f1("Hello World", 2) end)

    uiSettings:AddDropdown("Library", {
      Values = { "Obsidian", "Linoria" },
      Default = 2,
      Text = "Library",
      Callback = function(value14)
        getgenv().ScriptLibrary = tostring(value14)
        f1("Please Unload Script and Execute Again to Take Effect", 4)
      end,
    })

    uiSettings:AddDivider()

    uiSettings:AddDropdown("DPIDropdown", {
      Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
      Default = "100%",
      Text = "DPI Scale",
      Callback = function(value15) v2:SetDPIScale(tonumber((value15:gsub("%%", "")))) end,
    })

    local language = v54.Settings:AddLeftGroupbox("Language")

    language:AddDropdown("LanguageSelect", {
      Text = "Select Language",
      Values = { "English", "Russian", "French", "German", "Chinese" },
      Default = 1,
      Multi = false,
      Callback = function(value16)
        CurrentLanguage = tostring(value16)
        task.defer(RefreshLanguageUI)
        f1("Language: " .. CurrentLanguage, 3)
      end,
    })

    language:AddLabel("Items & Entities will be translated", true)
    language:AddLabel("(BETA)", true)

    hubUtilities:AddButton({
      Text = "Unload Hub",
      Func = function()
        localPlayer:SetAttribute("fazZzetaLoaded", nil)

        if v2.KeybindFrame then
          local position4 = v2.KeybindFrame.Position

          getgenv().FazZzetaDoors_KeybindPos = {
            position4.X.Scale, position4.X.Offset, position4.Y.Scale, position4.Y.Offset,
          }
        end

        for key7, value17 in pairs(v4) do
        end

        v2:Unload()
        espLibrary:Unload()
      end,
    })

    if v37 then
      v37:SetLibrary(v2)
      v37:SetFolder("fazZzetaDoors")
    end

    if v3 then
      v3:SetLibrary(v2)
      v3:IgnoreThemeSettings()
      v3:SetIgnoreIndexes({ "MenuKeybind" })
      v3:SetFolder("fazZzetaDoors/Config")
      v3:BuildConfigSection(v54.Settings)
    end

    if v37 then
      v37:ApplyToTab(v54.Settings)
    end

    f1("fazZzeta doors loaded | Lobby", 4)
  else
    function f6(p17)
      return ((localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            and localPlayer.Character:FindFirstChild("HumanoidRootPart").Position
          or workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position
          or Vector3.new(0, 0, 0))
        - p17).Magnitude
    end

    pathFolder = Instance.new("Folder", workspace)
    pathFolder.Name = "PathFolder"

    v9 = fireproximityprompt
    v10 = require
    v11 = replicatesignal or typeof(replicatesignal) == "function" and replicatesignal
    v12 = firetouchinterest
    v13 = hookmetamethod
    v14 = isnetworkowner

    Items = {
      AlarmClock = "Alarm Clock",
      Bandage = "Bandage",
      BandagePack = "Bandage Pack",
      Battery = "Battery",
      BatteryPack = "Battery Pack",
      Briefcase = "Briefcase",
      Bulklight = "Bulk Light",
      Candle = "Candle",
      Candy = "Candy",
      ChestBox = "Chest",
      ChestBoxLocked = "Locked Chest",
      Chest_Vine = "Chest Vine",
      CircuitBreaker = "Circuit Breaker",
      Compass = "Compass",
      Crucifix = "Crucifix",
      CrucifixWall = "Crucifix",
      Drawer = "Drawer",
      ElectricalRoomKey = "Electrical Room Key",
      FihFood = "Fih Food",
      Flashlight = "Flash light",
      Glowsticks = "Glow Sticks",
      Gold = "Gold",
      GoldGun = "Golden Gun",
      GreenHerb = "Green Herb",
      GummyFlashlight = "Gummy Flashlight",
      GweenSoda = "Gween Soda",
      HolyGrenade = "Holy Grenade",
      KeyIron = "Iron Key",
      Lantern = "Lantern",
      LaserPointer = "Laser Pointer",
      LibraryHintPaper = "Hint Paper",
      Lighter = "Lighter",
      Lockpick = "Lockpick",
      LotusPetalPickup = "Lotus Petal",
      LunchBox = "Lunch Box",
      MoonlightCandle = "Moonlight Candle",
      MoonlightFloat = "Moonlight Float",
      MouseHole = "Louie Mouse",
      Mug = "Mug",
      Multitool = "Multitool",
      Note = "Note",
      NVCS3000 = "NVCS-3000",
      PackOfGweenSoda = "Pack of Gween Soda",
      PaperCup = "Paper Cup",
      PaperPlane = "Paper Plane",
      Pizza = "Pizza",
      PocketMirror = "Pocket Mirror",
      PuzzlePainting = "Puzzle Painting",
      RoomKey = "Room Key",
      Shakelight = "Shake Light",
      Shears = "Shears",
      ShieldBig = "Big Shield",
      ShieldMini = "Mini Shield",
      SkeletonKey = "Skeleton Key",
      Smoothie = "Smoothie",
      SolutionPaper = "Solution Paper",
      StarBottle = "Star Bottle",
      StardustPickup = "Stardust",
      StarJug = "Jug of Bottle",
      StarVial = "Star Vial",
      Straplight = "Strap Light",
      TimerLever = "Lever",
      Toolbox_Locked = "Locked Toolbox",
      Toolshed_Small = "Toolshed",
      VineGuillotine = "Vine Lever",
      Vitamins = "Vitamin",
      WaitingTicket = "Waiting Ticket",
      WaterPump = "Water Pump",
    }

    for key8, value18 in pairs(Items) do
      BaseItems[key8] = value18
    end

    floor = replicatedStorage:WaitForChild("GameData"):WaitForChild("Floor")
    latestRoom = replicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")
    mainGame = localPlayer:WaitForChild("PlayerGui"):WaitForChild("MainUI").Initiator:WaitForChild("Main_Game")
    remoteListener = mainGame:WaitForChild("RemoteListener")
    v15 = nil

    local modulesClient = replicatedStorage:FindFirstChild("ModulesClient")
      or replicatedStorage:FindFirstChild("ClientModules")

    local entityInfo = replicatedStorage:FindFirstChild("EntityInfo")
      or replicatedStorage:FindFirstChild("Bricks")
      or replicatedStorage:FindFirstChild("RemotesFolder")

    motorReplication = entityInfo:WaitForChild("MotorReplication")
    collisionClone = nil
    pl = entityInfo:WaitForChild("PL")

    raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = { localPlayer.Character }

    seekPath = Instance.new("Folder", workspace)
    seekPath.Name = "SeekPath"

    function ShowSeekPath(p18)
      local instance2 = Instance.new("Part", seekPath)
      instance2.Size = Vector3.new(1.5, 1.5, 1.5)
      instance2.Anchored = true
      instance2.Shape = "Ball"
      instance2.Position = p18.Position
      instance2.CanCollide = false
      instance2.Color = Color3.new(0, 1, 0)

      debris:AddItem(instance2, 60)
    end

    function FixBridge(p19)
      for key9, value19 in pairs(p19:GetChildren()) do
        if value19.Name == "PlayerBarrier" and value19.Rotation.X == 180 then
          local bridgeBarrier = value19:Clone()

          bridgeBarrier.CFrame = CFrame.new(
            value19.Position.X, value19.Position.Y, value19.Position.Z
          )

          bridgeBarrier.CFrame = bridgeBarrier.CFrame * CFrame.new(0, -7, 0)
          bridgeBarrier.Size = Vector3.new(40, 0.1, 40)
          bridgeBarrier.Transparency = 0.5
          bridgeBarrier.Color = Color3.new(0.5, 0, 0.5)
          bridgeBarrier.Material = "ForceField"
          bridgeBarrier.Parent = p19
          bridgeBarrier.Name = "BridgeBarrier"
          bridgeBarrier.Anchored = true
          bridgeBarrier.CanCollide = true
        end
      end
    end

    if v10 then
      v15 = require(mainGame)
    end

    v16 = getconnections or get_signal_cons or get_relative_connections

    if v16 then
      for key10, value20 in pairs(v16(localPlayer.Idled)) do
        if value20.Disable then
          value20:Disable()
        end
      end
    end

    local characterAdded = localPlayer.CharacterAdded

    table.insert(v4, characterAdded:Connect(function()
      task.wait(1.5)

      if localPlayer.Character then
        mainGame = localPlayer.PlayerGui.MainUI.Initiator:WaitForChild("Main_Game")
        remoteListener = mainGame.RemoteListener
        raycastParams.FilterDescendantsInstances = { localPlayer.Character }

        if toggles.NoScenes.Value then
          local cutscenes = remoteListener:FindFirstChild("Cutscenes")

          local cutscenes2 = cutscenes
          cutscenes2 = cutscenes or remoteListener:FindFirstChild("Cutscenes_")
          cutscenes2.Name = "Cutscenes_"
        end

        if v10 then
          v15 = require(mainGame)
        end
      end

      if toggles.Jamming.Value then
        if replicatedStorage:FindFirstChild("LiveModifiers")
          and replicatedStorage:FindFirstChild("LiveModifiers"):FindFirstChild("Jammin") then
          local initiator = localPlayer.PlayerGui.MainUI.Initiator
          initiator:FindFirstChild("Main_Game").Health.Jam.Playing = false
          soundService.Main.Jamming.Enabled = false
        end
      end

      if toggles.Godmode.Value and entityInfo.Name ~= "RemotesFolder" then
        local collision = localPlayer.Character.Collision
        collision.Position = collision.Position - Vector3.new(0, 4, 0)
      end

      if toggles.Dread.Value then
        local dread = localPlayer:FindFirstChild("Dread", true)
          or localPlayer:FindFirstChild("_Dread", true)

        if dread then
          dread.Name = "_Dread"
        end
      end

      if toggles.Halt.Value then
        local findFirstChild = modulesClient.EntityModules:FindFirstChild("Shade", true)

        local shade = findFirstChild
        shade = findFirstChild or modulesClient.EntityModules:FindFirstChild("_Shade", true)

        if shade then
          shade.Name = "_Shade"
        end
      end
    end))

    v17 = {
      Info = window:AddTab("Info", "info"),
      Main = window:AddTab("Player", "star"),
      Bypass = window:AddTab("Bypass", "ban"),
      Visuals = window:AddTab("Visuals", "eye"),
      Floor = window:AddTab("Floor", "sparkles"),
      Settings = window:AddTab("Settings", "settings"),
    }

    f12(v17.Info)
    local player = v17.Main:AddLeftGroupbox("Player")
    local gameManagement = v17.Main:AddLeftGroupbox("Game Management")
    local hotel = v17.Floor:AddLeftGroupbox("Hotel")
    local mines = v17.Floor:AddRightGroupbox("Mines")
    local fools = v17.Floor:AddRightGroupbox("Fools")
    local retro = v17.Floor:AddLeftGroupbox("Retro")
    local archives = v17.Floor:AddRightGroupbox("Archives")
    local auto = v17.Main:AddRightGroupbox("Auto")
    local reach = v17.Main:AddRightGroupbox("Reach")
    local camera = v17.Visuals:AddLeftGroupbox("Camera")
    local lighting2 = v17.Visuals:AddLeftGroupbox("Lighting")
    esp = v17.Visuals:AddRightGroupbox("ESP")
    local v55 = v17.Visuals:AddRightGroupbox("Settings")
    local notifying = v17.Visuals:AddRightGroupbox("Notifying")

    local bypassEntities = v17.Bypass:AddLeftGroupbox("Bypass Entities")
    bypassEntities:AddLabel("More bypasses in the Floor section", true)
    bypassEntities:AddDivider()

    local noDamageEntities = v17.Bypass:AddRightGroupbox("No Damage Entities")
    local infiniteItems = v17.Bypass:AddLeftGroupbox("Infinite Items")
    local bypass = v17.Bypass:AddRightGroupbox("Bypass")

    retro:AddToggle("AntiLava", {
      Text = "Anti Lava",
      Default = false,
      Callback = function(value21)
        for key11, value22 in pairs(workspace.CurrentRooms:GetDescendants()) do
          if value22.Name == "Lava" then
            value22.CanTouch = not value21
          end
        end
      end,
    })

    retro:AddToggle("AntiWall", {
      Text = "Anti SeekWall",
      Default = false,
      Callback = function(value23)
        for key12, value24 in pairs(workspace.CurrentRooms:GetDescendants()) do
          if value24.Name == "ScaryWall" then
            for key13, value25 in pairs(value24:GetChildren()) do
              if value25:IsA("BasePart") then
                value25.CanTouch = not value23
              end
            end
          end
        end
      end,
    })

    retro:AddToggle("RealBridge", {
      Text = "Show Real Bridge",
      Default = false,
      Callback = function(value26)
        for key14, value27 in pairs(workspace.CurrentRooms:GetDescendants()) do
          if value27.Name == "Bridge" and value27.CanCollide == false then
            value27.Transparency = value26 and 1 or 0
          end
        end
      end,
    })

    fools:AddToggle("AntiBanana", {
      Text = "Anti Banana",
      Default = false,
      Callback = function(value28)
        for key15, value29 in pairs(workspace:GetChildren()) do
          if value29.Name == "BananaPeel" then
            value29.CanTouch = not value28
          end
        end
      end,
    })

    fools:AddToggle("AntiJeff", {
      Text = "Anti Jeff",
      Default = false,
      Callback = function(value30)
        local jeffTheKiller = workspace:FindFirstChild("JeffTheKiller")
        local primaryPart

        if jeffTheKiller and jeffTheKiller.Name == "JeffTheKiller" then
          repeat
            task.wait()

            primaryPart = jeffTheKiller.PrimaryPart
              and isnetworkowner(jeffTheKiller.PrimaryPart)
          until primaryPart

          for key16, value31 in pairs(jeffTheKiller:GetChildren()) do
            if value31:IsA("BasePart") then
              value31.CanTouch = value30 and false or true
            end
          end

          jeffTheKiller.Humanoid.Health = value30 and 0 or 100
        end
      end,
    })

    fools:AddToggle("InfRevive", { Text = "Infinite Revive", Default = false })

    fools:AddToggle("DeleteSeekFE", {
      Text = "Delete Seek (FE)",
      Default = false,
      Callback = function(value32)
        if value32 then
          for key17, value33 in pairs(workspace.CurrentRooms:GetDescendants()) do
            if value33.Name == "TriggerEventCollision" then
              f1("Deleting Seek", 3)

              for key18, value34 in pairs(value33:GetChildren()) do
                if value34.Name == "Collision" and v12 then
                  firetouchinterest(localPlayer.Character.HumanoidRootPart, value34, 0)
                end
              end

              task.wait(0.5)

              if value33:FindFirstChild("Collision") then
                f1("Failed to remove Seek", 3)
              else
                f1("Deleted Seek Successfully", 3)
              end
            end
          end
        end
      end,
    })

    gameManagement:AddButton({
      Text = "Revive",
      DoubleClick = true,
      Func = function() entityInfo.Revive:FireServer() end,
    })

    gameManagement:AddButton({
      Text = "Play Again",
      DoubleClick = true,
      Func = function() entityInfo.PlayAgain:FireServer() end,
    })

    v18 = false

    gameManagement:AddButton({
      Text = "Reset",
      DoubleClick = true,
      Func = function()
        v18 = not v18

        if not v18 then
          if entityInfo:FindFirstChild("Underwater") then
            entityInfo.Underwater:FireServer(false)
          end

          return
        end

        if v11 then
          replicatesignal(localPlayer.Kill)
        else
          f1("Double Click to stop", 5)

          task.spawn(function()
            while v18 and localPlayer:GetAttribute("Alive") ~= false do
              if entityInfo:FindFirstChild("Underwater") then
                entityInfo.Underwater:FireServer(true)
              end

              task.wait()
            end

            if entityInfo:FindFirstChild("Underwater") then
              entityInfo.Underwater:FireServer(false)
            end

            v18 = false
          end)
        end
      end,
    })

    gameManagement:AddButton({
      Text = "Lobby",
      DoubleClick = true,
      Func = function() entityInfo.Lobby:FireServer() end,
    })

    v19 = {}

    mines:AddToggle("DeleteFigureFE", {
      Text = "Delete Figure (FE)",
      Default = false,
      Callback = function(value35)
        for key19, value36 in pairs(workspace.CurrentRooms:GetDescendants()) do
          if value36.Name == "FigureRig" or value36.Name == "FigureRagdoll" then
            table.insert(v19, value36)
          end
        end
      end,
    })

    mines:AddToggle("ShowPath", {
      Text = "Show Seek Path",
      Default = false,
      Callback = function(value37)
        if value37 then
          for key20, value38 in pairs(workspace.CurrentRooms:GetDescendants()) do
            if value38.Name == "SeekGuidingLight" then
              ShowSeekPath(value38)
            end
          end
        else
          seekPath:ClearAllChildren()
        end
      end,
    })

    mines:AddToggle("FixBrokenBridge", {
      Text = "Fix Broken Bridge",
      Default = false,
      Callback = function(value39)
        if value39 then
          for key21, value40 in pairs(workspace.CurrentRooms:GetDescendants()) do
            if value40.Name == "Bridge" then
              FixBridge(value40)
            end
          end
        else
          for key22, value41 in pairs(workspace.CurrentRooms:GetDescendants()) do
            if value41.Name == "BridgeBarrier" then
              value41:Destroy()
            end
          end
        end
      end,
    })

    v20 = {}
    v21 = {}
    getMoveVector = nil

    if v10 then
      getMoveVector = require(localPlayer.PlayerScripts.PlayerModule):GetControls().GetMoveVector
    end

    mines:AddToggle("AutoMinecart", {
      Text = "Auto Minecart",
      Risky = true,
      Default = false,
      Callback = function(value42)
        if value42 then
          for v56, v57 in workspace.CurrentRooms:GetDescendants() do
            if v57.Name == "DuckBoard" then
              table.insert(v20, v57)
            end

            if string.find(v57.Name, "MinecartNode") then
              table.insert(v21, v57)
            end
          end
        else
          local v58 = require(localPlayer.PlayerScripts.PlayerModule)
          v58:GetControls().GetMoveVector = getMoveVector

          table.clear(v21)
          table.clear(v20)
        end
      end,
    })

    v22 = {}

    mines:AddToggle("AutoAnchorSolver", {
      Text = "Auto Anchor Solver",
      Default = false,
      Callback = function(value43)
        if value43 then
          for key23, value44 in pairs(workspace.CurrentRooms:GetDescendants()) do
            if value44.Name == "MinesAnchor" then
              table.insert(v22, value44)
            end
          end
        end
      end,
    })

    mines:AddToggle("AntiSeekFlood", {
      Text = "Anti Seek Flood",
      Default = false,
      Callback = function(value45)
        for key24, value46 in pairs(workspace.CurrentRooms:GetDescendants()) do
          if value46.Name == "SeekFloodline" then
            value46.CanCollide = value45
          end
        end
      end,
    })

    archives:AddLabel("Entity Removers", true)
    archives:AddDivider()

    archives:AddToggle("BypassAlma", {
      Text = "Delete Alma",
      Default = false,
      Tooltip = "Deletes Alma when it spawns (optimized)",
      Callback = function(value47)
        AlmaEnabled = value47

        if value47 then
          task.defer(function()
            local v59 = f5({ "alma", "алма" })

            if v59 > 0 then
              f1("Removed " .. v59 .. " Alma object(s)", 3)
            end
          end)
        end
      end,
    })

    archives:AddToggle("BypassDrones", {
      Text = "Delete Drones",
      Default = false,
      Tooltip = "Deletes Drones when they spawn (optimized)",
      Callback = function(value48)
        DronesEnabled = value48

        if value48 then
          task.defer(function()
            local v60 = f5({ "drone", "бездельник" })

            if v60 > 0 then
              f1("Removed " .. v60 .. " drone(s)", 3)
            end
          end)
        end
      end,
    })

    archives:AddToggle("BypassBash", {
      Text = "Delete Bash",
      Default = false,
      Tooltip = "Deletes Bash when it spawns (optimized)",
      Callback = function(value49)
        BashEnabled = value49

        if value49 then
          task.defer(function()
            local v61 = f5({ "bash", "бэш" })

            if v61 > 0 then
              f1("Removed " .. v61 .. " Bash object(s)", 3)
            end
          end)
        end
      end,
    })

    archives:AddToggle("BypassScribble", {
      Text = "Delete Scribble",
      Default = false,
      Tooltip = "Deletes Scribbles when they spawn (optimized)",
      Callback = function(value50)
        ScribbleEnabled = value50

        if value50 then
          task.defer(function()
            local v62 = f5({ "scribble", "скрибл" })

            if v62 > 0 then
              f1("Removed " .. v62 .. " Scribble object(s)", 3)
            end
          end)
        end
      end,
    })

    archives:AddDivider()
    archives:AddLabel("Entity Bypasses", true)

    a90 = Instance.new("RemoteEvent", entityInfo)
    a90.Name = "A90_"

    v23 = false

    archives:AddToggle("AntiRansom", {
      Text = "Anti Ransom",
      Default = false,
      Tooltip = "Bypasses Ransom (A90) damage",
      Callback = function(value51)
        if value51 then
          v23 = true
          entityInfo.A90.Name = "A90_"
          a90.Name = "A90"
        elseif v23 then
          entityInfo.A90_.Name = "A90"
          a90.Name = "A90_"
        end
      end,
    })

    archives:AddDivider()

    function f7()
      if not (toggles.ShowTracers and toggles.ShowTracers.Value) then
        return
      end

      pcall(function()
        espLibrary:SetTracers(false)
        task.wait(0.05)
        espLibrary:SetTracers(true)

        if espLibrary.SetTracerPosition and TracerPosition then
          espLibrary:SetTracerPosition(TracerPosition)
        end

        if espLibrary.SetTracerThickness and TracerThickness then
          espLibrary:SetTracerThickness(TracerThickness)
        end
      end)
    end

    v55:AddDropdown("TracerPosition", {
      Text = "Tracer Position",
      Values = { "Bottom", "Center", "Top", "Mouse" },
      Default = "Bottom",
      Multi = false,
      Callback = function(value52)
        TracerPosition = value52

        if espLibrary.SetTracerPosition then
          pcall(function() espLibrary:SetTracerPosition(value52) end)
        end

        task.defer(f7)
      end,
    })

    v55:AddSlider("TracerThickness", {
      Text = "Tracer Thickness",
      Default = 1,
      Min = 1,
      Max = 5,
      Rounding = 1,
      Compact = false,
      Callback = function(value53)
        TracerThickness = value53

        if espLibrary.SetTracerThickness then
          pcall(function() espLibrary:SetTracerThickness(value53) end)
        end

        task.defer(f7)
      end,
    })

    v55:AddToggle("ShowArrows", {
      Text = "Show Arrows",
      Default = false,
      Callback = function(value54)
        ShowArrows = value54

        if espLibrary.SetArrows then
          pcall(function() espLibrary:SetArrows(value54) end)
        end
      end,
    })

    v55:AddDivider()

    v55:AddToggle("ShowDistance", {
      Text = "Show ESP Distance",
      Default = true,
      Callback = function(value55) espLibrary:SetShowDistance(value55) end,
    })

    v55:AddToggle("ShowTracers", {
      Text = "Show ESP Tracers",
      Default = false,
      Callback = function(value56)
        espLibrary:SetTracers(value56)

        if value56 then
          task.spawn(function()
            task.wait(0.1)

            if espLibrary.SetTracerPosition and TracerPosition then
              pcall(function() espLibrary:SetTracerPosition(TracerPosition) end)
            end

            if espLibrary.SetTracerThickness then
              pcall(function() espLibrary:SetTracerThickness(TracerThickness) end)
            end
          end)
        end
      end,
    })

    v55:AddToggle("ShowRainbow", {
      Text = "Show ESP Rainbow",
      Default = false,
      Callback = function(value57) espLibrary:SetRainbow(value57) end,
    })

    v55:AddDropdown("SetESPMode", {
      Text = "Set ESP Mode",
      Values = { "Highlight/Text", "Text", "Highlight" },
      Default = 1,
      Multi = false,
      Callback = function(value58) espLibrary:SetESPMode(value58) end,
    })

    v55:AddDropdown("SetFont", {
      Text = "Set Font",
      Values = {
        "Legacy", "Arial", "ArialBold", "SourceSans", "SourceSansBold", "SourceSansLight",
        "SourceSansItalic", "Bodoni", "Garamond", "Cartoon", "Code", "Highway", "SciFi",
        "Arcade", "Fantasy", "Antique", "Gotham", "GothamMedium", "GothamBold", "GothamBlack",
        "AmaticSC", "Bangers", "Creepster", "DenkOne", "FredokaOne", "IndieFlower",
        "LuckiestGuy", "Michroma", "Nunito", "Oswald", "PatrickHand", "PermanentMarker",
        "Roboto", "RobotoCondensed", "RobotoMono", "Sarpanch", "SpecialElite", "TitilliumWeb",
        "Ubuntu",
      },
      Default = "Legacy",
      Multi = false,
      Callback = function(value59) espLibrary:SetFont(value59) end,
    })

    v55:AddDivider()

    v55:AddToggle("ESPText", {
      Text = "Show ESP Text",
      Default = false,
      Tooltip = "Show text on item/door/objective ESP",
      Callback = function(value60)
        ESPShowText = value60

        if ESPHooks and ESPHooks.ClearAll and ESPHooks.UpdateAll then
          pcall(function() ESPHooks.ClearAll() end)
          task.defer(function() pcall(function() ESPHooks.UpdateAll() end) end)
        end
      end,
    })

    v55:AddToggle("ESPEntityText", {
      Text = "Show Entity Text",
      Default = false,
      Tooltip = "Show text on entity ESP",
      Callback = function(value61)
        ESPShowEntityText = value61

        if ESPHooks and ESPHooks.ClearAll and ESPHooks.UpdateAll then
          pcall(function() ESPHooks.ClearAll() end)
          task.defer(function() pcall(function() ESPHooks.UpdateAll() end) end)
        end
      end,
    })

    local v63 = {}

    for key25, value62 in pairs(Items) do
      table.insert(v63, value62)
    end

    table.sort(v63)

    v55:AddDivider()

    v55:AddDropdown("ItemESPSelect", {
      Text = "Select Items for ESP",
      Values = v63,
      Multi = true,
      Default = {},
      Callback = function(value63)
        SelectedItems = value63 or {}

        if ESPHooks and ESPHooks.ClearAll and ESPHooks.UpdateAll then
          pcall(function() ESPHooks.ClearAll() end)
          task.defer(function() pcall(function() ESPHooks.UpdateAll() end) end)
        end
      end,
    })

    v55:AddButton({
      Text = "Select All Items",
      Func = function()
        local v64 = {}

        for key26, value64 in pairs(Items) do
          v64[value64] = true
        end

        options.ItemESPSelect:SetValue(v64)
        SelectedItems = v64

        if ESPHooks and ESPHooks.ClearAll and ESPHooks.UpdateAll then
          pcall(function() ESPHooks.ClearAll() end)
          task.defer(function() pcall(function() ESPHooks.UpdateAll() end) end)
        end
      end,
    })

    v55:AddButton({
      Text = "Clear Item Selection",
      Func = function()
        options.ItemESPSelect:SetValue({})
        SelectedItems = {}

        if ESPHooks and ESPHooks.ClearAll and ESPHooks.UpdateAll then
          pcall(function() ESPHooks.ClearAll() end)
          task.defer(function() pcall(function() ESPHooks.UpdateAll() end) end)
        end
      end,
    })

    v55:AddDivider()

    v55:AddDropdown("EntityESPSelect", {
      Text = "Select Entities for ESP",
      Values = GetLocalizedEntityList(),
      Multi = true,
      Default = {},
      Callback = function(value65)
        SelectedEntities = value65 or {}

        if ESPHooks and ESPHooks.ClearAll and ESPHooks.UpdateAll then
          pcall(function() ESPHooks.ClearAll() end)
          task.defer(function() pcall(function() ESPHooks.UpdateAll() end) end)
        end
      end,
    })

    v55:AddButton({
      Text = "Select All Entities",
      Func = function()
        local v65 = {}

        for index5, value66 in ipairs(GetLocalizedEntityList()) do
          v65[value66] = true
        end

        options.EntityESPSelect:SetValue(v65)
        SelectedEntities = v65

        if ESPHooks and ESPHooks.ClearAll and ESPHooks.UpdateAll then
          pcall(function() ESPHooks.ClearAll() end)
          task.defer(function() pcall(function() ESPHooks.UpdateAll() end) end)
        end
      end,
    })

    v55:AddButton({
      Text = "Clear Entity Selection",
      Func = function()
        options.EntityESPSelect:SetValue({})
        SelectedEntities = {}

        if ESPHooks and ESPHooks.ClearAll and ESPHooks.UpdateAll then
          pcall(function() ESPHooks.ClearAll() end)
          task.defer(function() pcall(function() ESPHooks.UpdateAll() end) end)
        end
      end,
    })

    task.spawn(function()
      task.wait(0.1)
      espLibrary:SetTracers(false)
      espLibrary:SetFont("Legacy")
    end)

    player:AddSlider("MovementSpeed", {
      Text = "Movement Speed",
      Default = 15,
      Min = 15,
      Max = 21,
      Rounding = 1,
      Compact = false,
      Callback = function(value67) end,
      Tooltip = "Walking Speed",
    })

    player:AddToggle("EnableMovementSpeed", {
      Text = "Enable Movement Speed",
      Default = false,
      Callback = function(value68)
        if not value68 then
          localPlayer.Character.Humanoid.WalkSpeed = 15
        end
      end,
    })

    player:AddSlider("ClimbingSpeed", {
      Text = "Climbing Speed",
      Default = 15,
      Min = 15,
      Max = 30,
      Rounding = 1,
      Compact = false,
      Callback = function(value69) end,
      Tooltip = "Climbing Speed",
    })

    player:AddToggle("EnableClimbingSpeed", {
      Text = "Enable Climbing Speed",
      Default = false,
      Callback = function(value70)
        if not value70 then
          localPlayer.Character.Humanoid.WalkSpeed = 15
        end
      end,
    })

    player:AddDivider()

    customPhysicalProperties = nil

    player:AddToggle("NoAcc", {
      Text = "No Slipping",
      Default = false,
      Callback = function(value71)
        if value71 then
          customPhysicalProperties = localPlayer.Character.HumanoidRootPart.CustomPhysicalProperties
        elseif customPhysicalProperties then
          localPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = customPhysicalProperties
          customPhysicalProperties = nil
        end
      end,
    })

    player:AddToggle("NoClip", {
      Text = "No Clip",
      Default = false,
      Tooltip = "You Can Move Through Wall",
      Callback = function(value72)
        if not value72 then
          for key27, value73 in pairs(localPlayer.Character:GetChildren()) do
            if value73.Name ~= "CollisionClone" and value73:IsA("BasePart") then
              value73.CanCollide = true
            end
          end
        end
      end,
    }):AddKeyPicker("NoclipKeybind", {
      Default = "N",
      SyncToggleState = true,
      Mode = "Toggle",
      Text = "No Clip",
      NoUI = false,
      Callback = function(value74) end,
      ChangedCallback = function(p20, p21) end,
    })

    player:AddToggle("Flight", {
      Text = "Flight",
      Default = false,
      Callback = function(value75)
        if not value75 then
          if localPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity") then
            localPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity"):Destroy()
          end
        end
      end,
    }):AddKeyPicker("FlightKeybind", {
      Default = "F",
      SyncToggleState = true,
      Mode = "Toggle",
      Text = "Flight",
      NoUI = false,
      Callback = function(value76) end,
      ChangedCallback = function(p22, p23) end,
    })

    player:AddSlider("FlightSpeed", {
      Text = "Flight Speed",
      Default = 15,
      Min = 15,
      Max = 21,
      Rounding = 1,
      Compact = false,
      Callback = function(value77) end,
      Tooltip = "Flight Speed",
    })

    player:AddToggle("EnableJump", {
      Text = "Enable Jumping",
      Default = false,
      Tooltip = "You Can Move Jump",
      Callback = function(value78)
        if not value78 then
          localPlayer.Character:SetAttribute("CanJump", false)
        end
      end,
    })

    player:AddToggle("InstaInteract", {
      Text = "Instant Interact",
      Default = false,
      Tooltip = "Interactions are Instantly",
      Callback = function(value79)
        if value79 then
          for index6, value80 in ipairs(workspace:GetDescendants()) do
            if value80:IsA("ProximityPrompt") then
              value80:SetAttribute("Duration", value80.HoldDuration)
              value80.HoldDuration = 0
            end
          end
        else
          for index7, value81 in ipairs(workspace:GetDescendants()) do
            if value81:IsA("ProximityPrompt") then
              value81.HoldDuration = value81:GetAttribute("Duration") or 0
            end
          end
        end
      end,
    })

    player:AddToggle("InfJump", { Text = "Infinite Jump", Default = false })

    if userInputService.KeyboardEnabled then
      v24 = false
      local jumpRequest = userInputService.JumpRequest

      table.insert(v4, jumpRequest:Connect(function()
        if toggles.InfJump.Value and not v24 and localPlayer.Character then
          v24 = true
          localPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping, true)
          task.wait(0.1)
          v24 = false
        end
      end))
    elseif userInputService.TouchEnabled then
      local characterAdded2 = localPlayer.CharacterAdded

      table.insert(v4, characterAdded2:Connect(function()
        task.wait(1)

        if localPlayer.PlayerGui.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton") then
          local mouseButton1Click = localPlayer.PlayerGui.MainUI.MainFrame.MobileButtons.JumpButton.MouseButton1Click

          table.insert(v4, mouseButton1Click:Connect(function()
            if toggles.InfJump.Value and localPlayer.Character then
              localPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping, true)
            end
          end))
        end
      end))

      if localPlayer.PlayerGui.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton") then
        local mouseButton1Click2 = localPlayer.PlayerGui.MainUI.MainFrame.MobileButtons.JumpButton.MouseButton1Click

        table.insert(v4, mouseButton1Click2:Connect(function()
          if toggles.InfJump.Value and localPlayer.Character then
            localPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping, true)
          end
        end))
      end
    end

    player:AddToggle("Godmode", {
      Text = "Godmode",
      Default = false,
      Tooltip = "Can Lagback you or not work",
      Risky = true,
      Callback = function(value82)
        if value82 and entityInfo.Name ~= "RemotesFolder" then
          local collision2 = localPlayer.Character.Collision
          collision2.Position = collision2.Position - Vector3.new(0, 4, 0)
        end

        if value82 and entityInfo.Name == "RemotesFolder" then
          localPlayer.Character:PivotTo(localPlayer.Character.CollisionPart.CFrame
            * CFrame.new(0, -2, 0))
        end

        if not value82 and entityInfo.Name == "RemotesFolder" then
          localPlayer.Character.Humanoid.HipHeight = 2.4
          localPlayer.Character.Collision.Size = Vector3.new(5.5, 3, 3)
          localPlayer.Character.LowerTorso.Root.C1 = CFrame.new(Vector3.new(0, 0, 0))
          localPlayer.Character.Collision.CollisionCrouch.Size = Vector3.new(5.5, 3, 3)

          localPlayer.Character:PivotTo(localPlayer.Character.CollisionPart.CFrame
            * CFrame.new(0, 2, 0))
        end

        if not value82 and entityInfo.Name ~= "RemotesFolder" then
          localPlayer.Character.Collision.Position = localPlayer.Character.HumanoidRootPart.Position
        end
      end,
    }):AddKeyPicker("GodmodeKeybind", {
      Default = "G",
      SyncToggleState = true,
      Mode = "Toggle",
      Text = "Godmode",
      NoUI = false,
      Callback = function(value83) end,
      ChangedCallback = function(p24, p25) end,
    })

    v25 = {
      HidePrompt = true,
      ClimbPrompt = true,
      PropPrompt = true,
      InteractPrompt = true,
      RiftPrompt = true,
      StarRiftPrompt = true,
      NoHidingLilBro = true,
      AnimatePrompt = true,
      RevivePrompt = true,
    }

    Interactions = {}

    auto:AddToggle("AutoInteract", {
      Text = "Auto Interact",
      Default = false,
      Tooltip = "Automatically Interacts with things when near",
      Callback = function(value84)
        if value84 then
          for index8, value85 in ipairs(workspace.CurrentRooms:GetDescendants()) do
            if value85:IsA("ProximityPrompt") then
              if not (v25[value85.Name] or value85.Parent.Name == "Padlock"
                  or value85.Parent:GetAttribute("JeffShop"))
                or value85.Parent.Name == "RetroWardrobe"
                or value85.Parent.Name == "KeyObtainFake" then
                table.insert(Interactions, value85)
              end
            end
          end
        end
      end,
    }):AddKeyPicker("AutoInteractKeybind", {
      Default = "R",
      SyncToggleState = true,
      Mode = v2.IsMobile and "Toggle" or "Hold",
      Text = "Auto Interact",
      NoUI = false,
      Callback = function(value86) end,
      ChangedCallback = function(p26, p27) end,
    })

    HidingPlaces = {
      Backdoor_Wardrobe = "Closet",
      Bed = "Bed",
      CircularVent = "Vent",
      Double_Bed = "Double Bed",
      Drawer = "Drawer",
      Locker_Large = "Locker",
      Locker_Small = "Locker",
      Locker_Small_Locked = "Locked Locker",
      RetroWardrobe = "Closet",
      Rooms_Locker = "Locker",
      Rooms_Locker_Fridge = "Fridge",
      Toolshed = "Closet",
      Wardrobe = "Closet",
    }

    Closets = {}

    auto:AddSlider("AutoInteractDelay", {
      Text = "Auto Interact Delay",
      Default = 0.05,
      Min = 0,
      Max = 0.2,
      Rounding = 2,
      Compact = false,
      Callback = function(value87) end,
    })

    auto:AddSlider("AutoInteractreach", {
      Text = "Auto Interact Range",
      Default = 12,
      Min = 7,
      Max = 12,
      Rounding = 2,
      Compact = false,
      Callback = function(value88) end,
    })

    auto:AddDivider()
    auto:AddToggle("AutoLibraryCode", { Text = "Auto Library Code", Default = false })
    auto:AddToggle("BruteForceLibCode", { Text = "Bruteforce Library Code", Default = false })
    auto:AddToggle("AutoHeartbeat", { Text = "Auto Heartbeat Minigame", Default = false })

    function f8(p28)
      local code = p28:WaitForChild("SurfaceGui"):WaitForChild("Frame"):WaitForChild("Code")

      local function f13()
        task.wait(0.05)

        if not toggles.AutoBreaker.Value then
          return
        else
          local v66 = tonumber(code.Text)

          if v66 then
            for v67, v68 in p28:GetChildren() do
              if v68.Name == "BreakerSwitch" and v68:GetAttribute("ID") == v66 then
                local backgroundTransparency = p28:WaitForChild("SurfaceGui"):WaitForChild("Frame"):WaitForChild("Code"):WaitForChild("Frame").BackgroundTransparency
                local prismaticConstraint = v68:FindFirstChild("PrismaticConstraint")
                local light = v68:FindFirstChild("Light")
                local sound = v68:FindFirstChild("Sound")

                if backgroundTransparency == 0 then
                  if v68:GetAttribute("Enabled") then
                    return
                  end

                  v68:SetAttribute("Enabled", true)

                  if prismaticConstraint then
                    prismaticConstraint.TargetPosition = -0.2
                  end

                  if light then
                    light.Material = Enum.Material.Neon
                    local findFirstChild2 = light:FindFirstChild("Spark", true)

                    if findFirstChild2 then
                      findFirstChild2:Emit(1)
                    end
                  end

                  if sound then
                    sound:Play()
                  end
                elseif backgroundTransparency == 1 then
                  if not v68:GetAttribute("Enabled") then
                    return
                  end

                  v68:SetAttribute("Enabled", false)

                  if prismaticConstraint then
                    prismaticConstraint.TargetPosition = 0.2
                  end

                  if light then
                    light.Material = Enum.Material.Glass
                  end

                  if sound then
                    sound:Play()
                  end
                end

                break
              end
            end

            return
          end

          return
        end
      end

      code:GetPropertyChangedSignal("Text"):Connect(f13)
      f13()
    end

    auto:AddToggle("AutoBreaker", {
      Text = "Auto Breaker Minigame",
      Default = false,
      Callback = function(value89)
        if value89 then
          for key28, value90 in pairs(workspace.CurrentRooms:GetDescendants()) do
            if value90.Name == "ElevatorBreaker" then
              f8(value90)
            end
          end
        end
      end,
    })

    fogEnd = nil

    lighting2:AddToggle("NoFog", {
      Text = "No Fog",
      Default = false,
      Tooltip = "No fog",
      Callback = function(value91)
        if not value91 then
          for key29, value92 in pairs(lighting:GetChildren()) do
            if value92:IsA("Atmosphere") then
              value92.Density = 0.94
            end
          end
        end

        if value91 then
          fogEnd = lighting.FogEnd
        elseif fogEnd then
          lighting.FogEnd = fogEnd
          fogEnd = nil
        end
      end,
    })

    lighting2:AddToggle("FullBright", {
      Text = "Fullbright",
      Default = false,
      Tooltip = "Make you see in darkness",
      Callback = function(value93)
        if not value93 then
          lighting.Ambient = Color3.fromRGB(0, 0, 0)
          lighting.GlobalShadows = true

          for key30, value94 in pairs(workspace.CurrentRooms:GetChildren()) do
            value94:SetAttribute("Ambient", value94:GetAttribute("OldAmbient"))
          end
        end
      end,
    })

    lighting2:AddDivider()

    lighting2:AddToggle("AntiLag", {
      Text = "Anti Lag",
      Default = false,
      Tooltip = "Reduces material rendering lag (Plastic all parts)",
      Callback = function(value95)
        if value95 then
          for v69, v70 in workspace.CurrentRooms:GetDescendants() do
            if v70:IsA("BasePart") then
              v70:SetAttribute("Mat", v70.Material)
              v70.Material = "Plastic"
            end
          end
        else
          for v71, v72 in workspace.CurrentRooms:GetDescendants() do
            if v72:IsA("BasePart") and v72:GetAttribute("Mat") then
              v72.Material = v72:GetAttribute("Mat") or "Plastic"
            end
          end
        end
      end,
    })

    for key31, value96 in pairs(workspace.CurrentRooms:GetDescendants()) do
    end

    ESPHooks = {}

    task.spawn(function()
      local color3 = Color3.fromRGB(0, 200, 200)
      local color4 = Color3.fromRGB(0, 255, 0)
      local color5 = Color3.fromRGB(255, 255, 255)
      local color6 = Color3.fromRGB(0, 255, 0)
      local color7 = Color3.fromRGB(255, 255, 0)
      local color8 = Color3.fromRGB(0, 255, 0)
      local color9 = Color3.fromRGB(0, 50, 180)
      local color10 = Color3.fromRGB(255, 255, 0)
      local color11 = Color3.fromRGB(0, 191, 255)
      local color12 = Color3.fromRGB(255, 170, 0)
      local color13 = Color3.new(1, 0, 0)
      local v73 = {}
      local v74 = {}
      local v75 = {}
      local v76 = {}
      local v77 = {}
      local v78 = {}
      local v79 = {}
      local v80 = {}
      local v81 = {}
      local v82 = {}
      local v83 = {}
      local v84 = {}
      local v85 = {}
      local v86 = {}
      local v87 = {}
      local v88 = {}
      local v89 = {}
      local v90 = {}
      local v91 = {}
      local v92 = {}
      local v93 = {}
      local v94 = {}
      local v95 = {}
      local v96 = {}
      local v97 = {}
      local v98 = {}

      local function f14(p29)
        if p29 and v73[p29] then
          v73[p29] = nil
          espLibrary:RemoveESP(p29)
        end
      end

      local function f15(p30, p31, p32, p33)
        if not p30 then
          return
        else
          local v99 = v73[p30]

          if v99 and v99.text == p31 then
            return
          end

          if v99 then
            espLibrary:RemoveESP(p30)
          end

          v73[p30] = { text = p31, room = p33 }

          if p33 then
            local v100 = v74[p33]

            if not v100 then
              v100 = {}
              v74[p33] = v100
            end

            table.insert(v100, p30)
          end

          AddESP(p30, p31, p32)
          return
        end
      end

      local function f16(p34)
        local v101 = tonumber(p34) or 0

        for key32, value97 in pairs(v74) do
          if key32 < v101 or key32 > v101 + 1 then
            for i = 1, #value97 do
              f14(value97[i])
            end

            v74[key32] = nil
          end
        end
      end

      local function f17()
        for key33 in pairs(v73) do
          espLibrary:RemoveESP(key33)
        end

        table.clear(v73)
        table.clear(v74)
        table.clear(v75)
      end

      local function f18(p35, p36)
        if not p35 then
          return
        else
          local door = p35:FindFirstChild("Door")

          if door then
            local door2 = door:FindFirstChild("Door")

            if door2 then
              local roomID = door:GetAttribute("RoomID") or door2:GetAttribute("RoomID")
                or tostring(p36)

              local v102 = v75[roomID]

              if not v102 then
                v102 = GetItemName("Door") .. " " .. tostring(roomID)
                v75[roomID] = v102
              end

              f15(door2, v102, color3, p36)
              local crossBoards = door2:FindFirstChild("CrossBoards")

              if crossBoards then
                f15(crossBoards, "", color3, p36)
              end
            end
          end

          return
        end
      end

      local function f19()
        if not (toggles.Door and toggles.Door.Value) then
          return
        else
          local v103 = tonumber(localPlayer:GetAttribute("CurrentRoom")) or 0
          f16(v103)
          local currentRooms2 = workspace:FindFirstChild("CurrentRooms")

          if not currentRooms2 then
            return
          end

          f18(currentRooms2:FindFirstChild(tostring(v103)), v103)
          f18(currentRooms2:FindFirstChild(tostring(v103 + 1)), v103 + 1)

          return
        end
      end

      local function f20(p37)
        if p37 and v76[p37] then
          v76[p37] = nil
          espLibrary:RemoveESP(p37)
        end
      end

      local function f21(p38, p39, p40, p41)
        if not p38 then
          return
        else
          local v104 = v76[p38]

          if v104 and v104.text == p39 then
            return
          end

          if v104 then
            espLibrary:RemoveESP(p38)
          end

          v76[p38] = { text = p39, room = p41 }

          if p41 then
            local v105 = v77[p41]

            if not v105 then
              v105 = {}
              v77[p41] = v105
            end

            table.insert(v105, p38)
          end

          AddESP(p38, p39, p40)
          return
        end
      end

      local function f22(p42)
        local v106 = tonumber(p42) or 0

        for key34, value98 in pairs(v77) do
          if key34 < v106 or key34 > v106 + 1 then
            for j = 1, #value98 do
              f20(value98[j])
            end

            v77[key34] = nil
          end
        end
      end

      local function f23()
        for key35 in pairs(v76) do
          espLibrary:RemoveESP(key35)
        end

        table.clear(v76)
        table.clear(v77)
        table.clear(v78)
      end

      local function f24(p43)
        if not SelectedItems or next(SelectedItems) == nil then
          return true
        end

        for key36, value99 in pairs(SelectedItems) do
          if value99 and key36 == p43 then
            return true
          end
        end

        return false
      end

      local function f25(p44, p45)
        if not p44 then
          return
        end

        for index9, value100 in ipairs(p44:GetDescendants()) do
          if BaseItems[value100.Name] then
            local v107 = GetItemName(value100.Name)

            if f24(v107) then
              local v108 = v78[v107]

              if not v108 then
                v108 = v107
                v78[v107] = v108
              end

              f21(value100, v108, color4, p45)
            end
          elseif value100.Name == "MinesAnchor" then
            local sign = value100:FindFirstChild("Sign")

            local textLabel2 = sign
            textLabel2 = sign and sign:FindFirstChild("TextLabel")

            local v109 = "Anchor " .. (textLabel2 and textLabel2.Text or "")
            local v110 = v78[v109]

            if not v110 then
              v110 = v109
              v78[v109] = v110
            end

            f21(value100, v110, color4, p45)
          end
        end
      end

      local function f26()
        if not (toggles.Objective and toggles.Objective.Value) then
          return
        else
          local v111 = tonumber(localPlayer:GetAttribute("CurrentRoom")) or 0
          f22(v111)
          local currentRooms3 = workspace:FindFirstChild("CurrentRooms")

          if not currentRooms3 then
            return
          end

          f25(currentRooms3:FindFirstChild(tostring(v111)), v111)
          f25(currentRooms3:FindFirstChild(tostring(v111 + 1)), v111 + 1)

          return
        end
      end

      local function f27(p46)
        if p46 and v79[p46] then
          v79[p46] = nil
          espLibrary:RemoveESP(p46)
        end
      end

      local function f28(p47, p48, p49, p50)
        if not p47 then
          return
        else
          local v112 = v79[p47]

          if v112 and v112.text == p48 then
            return
          end

          if v112 then
            espLibrary:RemoveESP(p47)
          end

          v79[p47] = { text = p48, room = p50 }

          if p50 then
            local v113 = v80[p50]

            if not v113 then
              v113 = {}
              v80[p50] = v113
            end

            table.insert(v113, p47)
          end

          AddESP(p47, p48, p49)
          return
        end
      end

      local function f29(p51)
        local v114 = tonumber(p51) or 0

        for key37, value101 in pairs(v80) do
          if key37 < v114 or key37 > v114 + 1 then
            for k = 1, #value101 do
              f27(value101[k])
            end

            v80[key37] = nil
          end
        end
      end

      local function f30()
        for key38 in pairs(v79) do
          espLibrary:RemoveESP(key38)
        end

        table.clear(v79)
        table.clear(v80)
        table.clear(v81)
      end

      local function f31(p52, p53)
        if not p52 then
          return
        end

        for index10, value102 in ipairs(p52:GetDescendants()) do
          local v115 = HidingPlaces[value102.Name]

          if v115 then
            local v116 = v81[v115]

            if not v116 then
              v116 = v115
              v81[v115] = v116
            end

            f28(value102, v116, color5, p53)
          end
        end
      end

      local function f32()
        if not (toggles.HidingPlace and toggles.HidingPlace.Value) then
          return
        else
          local v117 = tonumber(localPlayer:GetAttribute("CurrentRoom")) or 0
          f29(v117)
          local currentRooms4 = workspace:FindFirstChild("CurrentRooms")

          if not currentRooms4 then
            return
          end

          f31(currentRooms4:FindFirstChild(tostring(v117)), v117)
          f31(currentRooms4:FindFirstChild(tostring(v117 + 1)), v117 + 1)

          return
        end
      end

      local function f33(p54)
        if p54 and v82[p54] then
          v82[p54] = nil
          espLibrary:RemoveESP(p54)
        end
      end

      local function f34(p55, p56, p57, p58)
        if not p55 then
          return
        else
          local v118 = v82[p55]

          if v118 and v118.text == p56 then
            return
          end

          if v118 then
            espLibrary:RemoveESP(p55)
          end

          v82[p55] = { text = p56, room = p58 }

          if p58 then
            local v119 = v83[p58]

            if not v119 then
              v119 = {}
              v83[p58] = v119
            end

            table.insert(v119, p55)
          end

          AddESP(p55, p56, p57)
          return
        end
      end

      local function f35(p59)
        local v120 = tonumber(p59) or 0

        for key39, value103 in pairs(v83) do
          if key39 < v120 or key39 > v120 + 1 then
            for m = 1, #value103 do
              f33(value103[m])
            end

            v83[key39] = nil
          end
        end
      end

      local function f36()
        for key40 in pairs(v82) do
          espLibrary:RemoveESP(key40)
        end

        table.clear(v82)
        table.clear(v83)
        table.clear(v84)
      end

      local function f37(p60, p61)
        if not p60 then
          return
        else
          local lever = v84.Lever

          if not lever then
            lever = GetItemName("Gate Lever")
            v84.Lever = lever
          end

          local key41 = v84.Key

          if not key41 then
            key41 = GetItemName("Key")
            v84.Key = key41
          end

          local ekey = v84.EKey

          if not ekey then
            ekey = GetItemName("Electrical Key")
            v84.EKey = ekey
          end

          for index11, value104 in ipairs(p60:GetDescendants()) do
            if value104.Name == "LeverForGate" then
              f34(value104, lever, color6, p61)
            elseif value104.Name == "KeyObtain" then
              f34(value104, key41, color8, p61)
            elseif value104.Name == "ElectrialKeyObtain" then
              f34(value104, ekey, color8, p61)
            end
          end

          return
        end
      end

      local function f38()
        if not (toggles.KeyBookESP and toggles.KeyBookESP.Value) then
          return
        else
          local v121 = tonumber(localPlayer:GetAttribute("CurrentRoom")) or 0
          f35(v121)
          local currentRooms5 = workspace:FindFirstChild("CurrentRooms")

          if not currentRooms5 then
            return
          end

          f37(currentRooms5:FindFirstChild(tostring(v121)), v121)
          f37(currentRooms5:FindFirstChild(tostring(v121 + 1)), v121 + 1)

          return
        end
      end

      local function f39(p62)
        if p62 and v85[p62] then
          v85[p62] = nil
          espLibrary:RemoveESP(p62)
        end
      end

      local function f40(p63, p64, p65, p66)
        if not p63 then
          return
        else
          local v122 = v85[p63]

          if v122 and v122.text == p64 then
            return
          end

          if v122 then
            espLibrary:RemoveESP(p63)
          end

          v85[p63] = { text = p64, room = p66 }

          if p66 then
            local v123 = v86[p66]

            if not v123 then
              v123 = {}
              v86[p66] = v123
            end

            table.insert(v123, p63)
          end

          AddESP(p63, p64, p65)
          return
        end
      end

      local function f41(p67)
        local v124 = tonumber(p67) or 0

        for key42, value105 in pairs(v86) do
          if key42 < v124 or key42 > v124 + 1 then
            local v125 = #value105
            local count2 = 0

            while true do
              count2 = 1 + count2

              if not (count2 <= v125) then
                break
              end

              f39(value105[count2])
            end

            v86[key42] = nil
          end
        end
      end

      local function f42()
        for key43 in pairs(v85) do
          espLibrary:RemoveESP(key43)
        end

        table.clear(v85)
        table.clear(v86)
        table.clear(v87)
      end

      local function f43(p68, p69)
        if not p68 then
          return
        elseif (tonumber(p69) or 0) ~= 50 then
          return
        else
          local book = v87.Book

          if not book then
            book = GetItemName("Library Book")
            v87.Book = book
          end

          for index12, value106 in ipairs(p68:GetDescendants()) do
            if value106.Name == "LiveHintBook" then
              f40(value106, book, color7, p69)
            end
          end

          return
        end
      end

      local function f44()
        if not (toggles.KeyBookESP and toggles.KeyBookESP.Value) then
          return
        else
          local v126 = tonumber(localPlayer:GetAttribute("CurrentRoom")) or 0
          f41(v126)
          local currentRooms6 = workspace:FindFirstChild("CurrentRooms")

          if not currentRooms6 then
            return
          end

          f43(currentRooms6:FindFirstChild(tostring(v126)), v126)
          f43(currentRooms6:FindFirstChild(tostring(v126 + 1)), v126 + 1)

          return
        end
      end

      local function f45(p70)
        if p70 and v88[p70] then
          v88[p70] = nil
          espLibrary:RemoveESP(p70)
        end
      end

      local function f46(p71, p72, p73, p74)
        if not p71 then
          return
        else
          local v127 = v88[p71]

          if v127 and v127.text == p72 then
            return
          end

          if v127 then
            espLibrary:RemoveESP(p71)
          end

          v88[p71] = { text = p72, room = p74 }

          if p74 then
            local v128 = v89[p74]

            if not v128 then
              v128 = {}
              v89[p74] = v128
            end

            table.insert(v128, p71)
          end

          AddESP(p71, p72, p73)
          return
        end
      end

      local function f47(p75)
        local v129 = tonumber(p75) or 0

        for key44, value107 in pairs(v89) do
          if key44 < v129 or key44 > v129 + 1 then
            local v130 = #value107
            local count3 = 0

            while true do
              count3 = 1 + count3

              if not (count3 <= v130) then
                break
              end

              f45(value107[count3])
            end

            v89[key44] = nil
          end
        end
      end

      local function f48()
        for key45 in pairs(v88) do
          espLibrary:RemoveESP(key45)
        end

        table.clear(v88)
        table.clear(v89)
        table.clear(v90)
      end

      local function f49(p76, p77)
        if not p76 then
          return
        elseif (tonumber(p77) or 0) ~= 100 then
          return
        else
          local breaker = v90.Breaker

          if not breaker then
            breaker = GetItemName("Breaker")
            v90.Breaker = breaker
          end

          for index13, value108 in ipairs(p76:GetDescendants()) do
            if value108.Name == "LiveBreakerPolePickup" then
              f46(value108, breaker, color9, p77)
            end
          end

          return
        end
      end

      local function f50()
        if not (toggles.Breakers and toggles.Breakers.Value) then
          return
        else
          local v131 = tonumber(localPlayer:GetAttribute("CurrentRoom")) or 0
          f47(v131)
          local currentRooms7 = workspace:FindFirstChild("CurrentRooms")

          if not currentRooms7 then
            return
          end

          f49(currentRooms7:FindFirstChild(tostring(v131)), v131)
          f49(currentRooms7:FindFirstChild(tostring(v131 + 1)), v131 + 1)

          return
        end
      end

      local function f51(p78)
        if p78 and v91[p78] then
          v91[p78] = nil
          espLibrary:RemoveESP(p78)
        end
      end

      local function f52(p79, p80, p81, p82)
        if not p79 then
          return
        else
          local v132 = v91[p79]

          if v132 and v132.text == p80 then
            return
          end

          if v132 then
            espLibrary:RemoveESP(p79)
          end

          v91[p79] = { text = p80, room = p82 }

          if p82 then
            local v133 = v92[p82]

            if not v133 then
              v133 = {}
              v92[p82] = v133
            end

            table.insert(v133, p79)
          end

          AddESP(p79, p80, p81)
          return
        end
      end

      local function f53(p83)
        local v134 = tonumber(p83) or 0

        for key46, value109 in pairs(v92) do
          if key46 < v134 or key46 > v134 + 1 then
            for n = 1, #value109 do
              f51(value109[n])
            end

            v92[key46] = nil
          end
        end
      end

      local function f54()
        for key47 in pairs(v91) do
          espLibrary:RemoveESP(key47)
        end

        table.clear(v91)
        table.clear(v92)
        table.clear(v93)
      end

      local function f55(p84, p85)
        if not p84 then
          return
        end

        for index14, value110 in ipairs(p84:GetDescendants()) do
          if value110.Name == "GoldPile" then
            local v135 = tonumber(value110:GetAttribute("GoldValue")) or 0
            local v136 = "G" .. v135
            local v137 = v93[v136]

            if not v137 then
              v137 = GetItemName("Gold") .. " " .. tostring(v135)
              v93[v136] = v137
            end

            f52(value110, v137, color10, p85)
          elseif value110.Name == "ChestBox" then
            local chest = v93.Chest

            if not chest then
              chest = GetItemName("Chest")
              v93.Chest = chest
            end

            f52(value110, chest, color10, p85)
          elseif value110.Name == "ChestBoxLocked" then
            local lockedChest = v93.LockedChest

            if not lockedChest then
              lockedChest = GetItemName("Locked Chest")
              v93.LockedChest = lockedChest
            end

            f52(value110, lockedChest, color10, p85)
          elseif value110.Name == "Chest_Vine" then
            local chestVine = v93.ChestVine

            if not chestVine then
              chestVine = GetItemName("Chest Vine")
              v93.ChestVine = chestVine
            end

            f52(value110, chestVine, color10, p85)
          elseif value110.Name == "Toolbox_Locked" then
            local lockedToolbox = v93.LockedToolbox

            if not lockedToolbox then
              lockedToolbox = GetItemName("Locked Toolbox")
              v93.LockedToolbox = lockedToolbox
            end

            f52(value110, lockedToolbox, color10, p85)
          elseif value110.Name == "Toolshed_Small" then
            local toolshed = v93.Toolshed

            if not toolshed then
              toolshed = GetItemName("Toolshed")
              v93.Toolshed = toolshed
            end

            f52(value110, toolshed, color10, p85)
          end
        end
      end

      local function f56()
        if not (toggles.Gold and toggles.Gold.Value) then
          return
        else
          local v138 = tonumber(localPlayer:GetAttribute("CurrentRoom")) or 0
          f53(v138)
          local currentRooms8 = workspace:FindFirstChild("CurrentRooms")

          if not currentRooms8 then
            return
          end

          f55(currentRooms8:FindFirstChild(tostring(v138)), v138)
          f55(currentRooms8:FindFirstChild(tostring(v138 + 1)), v138 + 1)

-- https://discord.gg/AwGHNh7Z7T
          return
        end
      end

      local function f57(p86)
        if p86 and v94[p86] then
          v94[p86] = nil
          espLibrary:RemoveESP(p86)
        end
      end

      local function f58(p87, p88, p89, p90)
        if not p87 then
          return
        else
          local v139 = v94[p87]

          if v139 and v139.text == p88 then
            return
          end

          if v139 then
            espLibrary:RemoveESP(p87)
          end

          v94[p87] = { text = p88, room = p90 }

          if p90 then
            local v140 = v95[p90]

            if not v140 then
              v140 = {}
              v95[p90] = v140
            end

            table.insert(v140, p87)
          end

          AddESP(p87, p88, p89)
          return
        end
      end

      local function f59(p91)
        local v141 = tonumber(p91) or 0

        for key48, value111 in pairs(v95) do
          if key48 < v141 or key48 > v141 + 1 then
            local v142 = #value111
            local count4 = 0

            while true do
              count4 = 1 + count4

              if not (v142 >= count4) then
                break
              end

              f57(value111[count4])
            end

            v95[key48] = nil
          end
        end
      end

      local function f60()
        for key49 in pairs(v94) do
          espLibrary:RemoveESP(key49)
        end

        table.clear(v94)
        table.clear(v95)
        table.clear(v96)
      end

      local function f61(p92, p93)
        if not p92 then
          return
        else
          local ladder = v96.Ladder

          if not ladder then
            ladder = GetItemName("Ladder")
            v96.Ladder = ladder
          end

          for index15, value112 in ipairs(p92:GetDescendants()) do
            if value112.Name == "Ladder" then
              f58(value112, ladder, color11, p93)
            end
          end

          return
        end
      end

      local function f62()
        if not (toggles.Ladder and toggles.Ladder.Value) then
          return
        else
          local v143 = tonumber(localPlayer:GetAttribute("CurrentRoom")) or 0
          f59(v143)
          local currentRooms9 = workspace:FindFirstChild("CurrentRooms")

          if not currentRooms9 then
            return
          end

          f61(currentRooms9:FindFirstChild(tostring(v143)), v143)
          f61(currentRooms9:FindFirstChild(tostring(v143 + 1)), v143 + 1)

          return
        end
      end

      local function f63(p94)
        if p94 and v97[p94] then
          v97[p94] = nil
          espLibrary:RemoveESP(p94)
        end
      end

      local function f64(p95, p96, p97, p98)
        if not p95 then
          return
        else
          local v144 = v97[p95]

          if v144 and v144.text == p96 then
            return
          end

          if v144 then
            espLibrary:RemoveESP(p95)
          end

          v97[p95] = { text = p96, room = p98 }

          if p98 then
            local v145 = v98[p98]

            if not v145 then
              v145 = {}
              v98[p98] = v145
            end

            table.insert(v145, p95)
          end

          AddESP(p95, p96, p97)
          return
        end
      end

      local function f65(p99)
        local v146 = tonumber(p99) or 0

        for key50, value113 in pairs(v98) do
          if key50 < v146 or key50 > v146 + 1 then
            for i6 = 1, #value113 do
              f63(value113[i6])
            end

            v98[key50] = nil
          end
        end
      end

      local function f66()
        for key51 in pairs(v97) do
          espLibrary:RemoveESP(key51)
        end

        table.clear(v97)
        table.clear(v98)
      end

      local function f67(p100, p101)
        if not p100 then
          return
        end

        for index16, value114 in ipairs(p100:GetDescendants()) do
          local name = value114.Name

          if name == "FuseObtain" then
            f64(value114, GetItemName("Fuse"), color12, p101)
          elseif name == "MinesGenerator" then
            f64(value114, GetItemName("Generator"), color12, p101)
          elseif name == "MinesGateButton" then
            f64(value114, GetItemName("Gate Button"), color12, p101)
          end
        end
      end

      local function f68()
        if not (toggles.Fuse and toggles.Fuse.Value) then
          return
        else
          local v147 = tonumber(localPlayer:GetAttribute("CurrentRoom")) or 0
          f65(v147)
          local currentRooms10 = workspace:FindFirstChild("CurrentRooms")

          if not currentRooms10 then
            return
          end

          f67(currentRooms10:FindFirstChild(tostring(v147)), v147)
          f67(currentRooms10:FindFirstChild(tostring(v147 + 1)), v147 + 1)

          return
        end
      end

      local v148 = {
        Alma = "Alma",
        BackdoorLookman = "Lookman",
        Creak = "Creak",
        Drone = "Drone",
        Eyes = "Eyes",
        ForgetMeNot = "Forget-Me-Not",
        Hide = "Hide",
        Jack = "Jack",
        JeffTheKiller = "Jeff",
        Lookman = "Eyes",
        Louie = "Louie",
        Noise = "Noise",
        Portrait = "Portrait",
        Sally = "Sally",
        Snare = "Snare",
        Stem = "Stem",
        Teller = "Teller",
        Timothy = "Timothy",
      }

      local v149 = {
        Bob = "Bob",
        ElGoblino = "El Goblino",
        FigureRagdoll = "Figure",
        FigureRig = "Figure",
        Groundskeeper = "Ground Keeper",
        Halt = "Halt",
        Haste = "Haste",
        Honcho = "Honcho",
        LiveEntityBramble = "Bramble",
        MonumentEntity = "Monument",
        QueenGrumble = "Queen Grumble",
        Seek = "Seek",
        SeekMoving = "Seek",
      }

      local v150 = {
        AmbushMoving = "Ambush",
        BackdoorRush = "Blitz",
        Bash = "Bash",
        Dread = "Dread",
        Glitch = "Glitch",
        GlitchAmbush = "Glitch Ambush",
        GlitchRush = "Glitch Rush",
        RushMoving = "Rush",
        Scribbles = "Scribbles",
      }

      local v151 = { GrumbleRig = "Grumble" }
      local v152 = {}

      for key52, value115 in pairs(v148) do
        v152[key52] = value115
      end

      for key53, value116 in pairs(v149) do
        v152[key53] = value116
      end

      for key54, value117 in pairs(v150) do
        v152[key54] = value117
      end

      for key55, value118 in pairs(v151) do
        v152[key55] = value118
      end

      v152.DoorFake = "Dupe"
      v152.GiggleCeiling = "Giggle"

      local v153 = {}
      local v154 = {}
      local v155 = {}

      local function f69(p102)
        if not SelectedEntities or next(SelectedEntities) == nil then
          return true
        else
          local v156 = GetEntityName(p102)

          for key56, value119 in pairs(SelectedEntities) do
            if value119 and (key56 == v156 or key56 == p102) then
              return true
            end
          end

          return false
        end
      end

      local function f70(p103)
        if not p103 then
          return false
        end

        local v157

        if p103:IsA("Model") then
          if not p103.PrimaryPart then
            local basePart = p103:FindFirstChildWhichIsA("BasePart")

            if not basePart then
              return false
            end

            p103.PrimaryPart = basePart
          end

          pcall(function() p103.PrimaryPart.Transparency = 0.99 end)

          if not p103:FindFirstChildOfClass("Humanoid") then
            Instance.new("Humanoid", p103)
          end

          v157 = p103.Name == "FigureRig"

          if v157 or p103.Name == "FigureRagdoll" then
            local root = p103:FindFirstChild("Root")

            if root then
              root.Size = Vector3.new(0.001, 0.001, 0.001)
            end
          end

          return true
        end

        v157 = p103.Name == "FigureRig"

        if v157 or p103.Name == "FigureRagdoll" then
          local root2 = p103:FindFirstChild("Root")

          if root2 then
            root2.Size = Vector3.new(0.001, 0.001, 0.001)
          end
        end

        return true
      end

      local function f71(p104)
        if p104 and v153[p104] then
          v153[p104] = nil
          espLibrary:RemoveESP(p104)
        end
      end

      local function f72(p105, p106, p107, p108)
        if not p105 then
          return
        elseif not f69(p106) then
          return
        else
          local v158 = GetEntityName(p106)
          local v159 = v153[p105]

          if v159 and v159.text == v158 then
            return
          end

          if v159 then
            espLibrary:RemoveESP(p105)
          end

          if not f70(p105) then
            return
          else
            local v160 = v155[v158]

            if not v160 then
              v160 = v158
              v155[v158] = v160
            end

            v153[p105] = { text = v160, room = p108 }

            if p108 then
              local v161 = v154[p108]

              if not v161 then
                v161 = {}
                v154[p108] = v161
              end

              table.insert(v161, p105)
            end

            AddEntityESP(p105, v160, p107)
            return
          end
        end
      end

      local function f73(p109)
        local v162 = tonumber(p109) or 0

        for key57, value120 in pairs(v154) do
          if key57 < v162 or key57 > v162 + 1 then
            local v163 = #value120
            local count5 = 0

            while true do
              count5 = 1 + count5

              if not (count5 <= v163) then
                break
              end

              f71(value120[count5])
            end

            v154[key57] = nil
          end
        end
      end

      local function f74()
        for key58 in pairs(v153) do
          espLibrary:RemoveESP(key58)
        end

        table.clear(v153)
        table.clear(v154)
        table.clear(v155)
      end

      local function f75(p110, p111)
        if not p110 then
          return
        else
          local v164 = tonumber(p111) or 0
          local v165 = tonumber(localPlayer:GetAttribute("CurrentRoom")) or 0
          local v166 = v164 == v165

          for index17, value121 in ipairs(p110:GetDescendants()) do
            local name2 = value121.Name
            local v167 = v148[name2]

            if v167 then
              if name2 ~= "Snare" or value121:FindFirstChild("Hitbox") then
                f72(value121, v167, color13, v164)
              end
            elseif name2 == "DoorFake" then
              if value121.Parent and value121.Parent.Name == "SideroomDupe" then
                local door3 = value121:FindFirstChild("Door")

                if door3 then
                  f72(door3, "Dupe", color13, v164)
                end
              end
            elseif name2 == "GiggleCeiling" then
              if value121:FindFirstChild("Hitbox") then
                f72(value121, "Giggle", color13, v164)
              end
            elseif v166 then
              local v168 = v149[name2]

              if v168 then
                f72(value121, v168, color13, v164)
              elseif v151[name2] and v165 == 150 then
                f72(value121, v151[name2], color13, v164)
              end
            end
          end

          return
        end
      end

      local function f76()
        if not (toggles.Entity and toggles.Entity.Value) then
          return
        else
          local v169 = tonumber(localPlayer:GetAttribute("CurrentRoom")) or 0

          for key59 in pairs(v153) do
            if not key59.Parent then
              f71(key59)
            end
          end

          f73(v169)
          local currentRooms11 = workspace:FindFirstChild("CurrentRooms")

          if currentRooms11 then
            f75(currentRooms11:FindFirstChild(tostring(v169)), v169)
            f75(currentRooms11:FindFirstChild(tostring(v169 + 1)), v169 + 1)
          end

          for index18, value122 in ipairs(workspace:GetChildren()) do
            local name3 = value122.Name
            local v170 = v150[name3]

            if v170 then
              f72(value122, v170, color13, nil)
            else
              local v171 = v148[name3]

              if v171 then
                f72(value122, v171, color13, v169)
              end
            end
          end

          return
        end
      end

      local v172 = {}

      local v173 = {
        Alma = "Alma",
        AmbushMoving = "Ambush",
        BackdoorLookman = "Lookman",
        BackdoorRush = "Blitz",
        Bash = "Bash",
        Bob = "Bob",
        Creak = "Creak",
        Drone = "Drone",
        Dread = "Dread",
        ElGoblino = "El Goblino",
        Eyes = "Eyes",
        ForgetMeNot = "Forget-Me-Not",
        Glitch = "Glitch",
        GlitchAmbush = "Glitch Ambush",
        GlitchRush = "Glitch Rush",
        Halt = "Halt",
        Haste = "Haste",
        Hide = "Hide",
        Honcho = "Honcho",
        Jack = "Jack",
        JeffTheKiller = "Jeff",
        Lookman = "Eyes",
        Louie = "Louie",
        MonumentEntity = "Monument",
        Noise = "Noise",
        Portrait = "Portrait",
        QueenGrumble = "Queen Grumble",
        RushMoving = "Rush",
        Sally = "Sally",
        Scribbles = "Scribbles",
        Seek = "Seek",
        SeekMoving = "Seek",
        Snare = "Snare",
        Stem = "Stem",
        Teller = "Teller",
        Timothy = "Timothy",
      }

      local v174 = {
        Alma = "Alma",
        AmbushMoving = "Ambush",
        BackdoorLookman = "Lookman",
        BackdoorRush = "Blitz",
        Bash = "Bash",
        Bob = "Bob",
        Creak = "Creak",
        Drone = "Drone",
        Dread = "Dread",
        ElGoblino = "ElGoblino",
        Eyes = "Eyes",
        ForgetMeNot = "ForgetMeNot",
        Glitch = "Glitch",
        GlitchAmbush = "GlitchAmbush",
        GlitchRush = "GlitchRush",
        Halt = "Halt",
        Haste = "Haste",
        Hide = "Hide",
        Honcho = "Honcho",
        Jack = "Jack",
        JeffTheKiller = "Jeff",
        Lookman = "Eyes",
        Louie = "Louie",
        MonumentEntity = "Monument",
        Noise = "Noise",
        Portrait = "Portrait",
        QueenGrumble = "QueenGrumble",
        RushMoving = "Rush",
        Sally = "Sally",
        Scribbles = "Scribbles",
        Seek = "Seek",
        SeekMoving = "Seek",
        Snare = "Snare",
        Stem = "Stem",
        Teller = "Teller",
        Timothy = "Timothy",
      }

      local function f77(p112)
        if not p112 then
          return
        end

        if v172[p112] then
          return
        end

        local connect

        if not (toggles.NotifySpawn and toggles.NotifySpawn.Value) then
          return
        else
          local v175 = v174[p112.Name]

          if not v175 then
            return
          else
            local value123 = options.Notify and options.Notify.Value

            if type(value123) ~= "table" or not value123[v175] then
              return
            end

            v172[p112] = true

            connect = nil

            connect = p112.AncestryChanged:Connect(function(p113, p114)
              if not p114 then
                v172[p112] = nil

                if connect then
                  connect:Disconnect()
                  connect = nil
                end
              end
            end)

            table.insert(v4, connect)
            f1(v173[p112.Name] .. " has Spawned", 5)
            return
          end
        end
      end

      local function f78()
        if not (toggles.NotifySpawn and toggles.NotifySpawn.Value) then
          return
        end

        for index19, value124 in ipairs(workspace:GetChildren()) do
          if v174[value124.Name] then
            f77(value124)
          end
        end
      end

      local function f79()
        f19()
        f26()
        f32()
        f38()
        f44()
        f50()
        f56()
        f62()
        f68()
        f76()
      end

      ESPHooks.UpdateAll = f79

      function ESPHooks.ClearAll()
        f17()
        f23()
        f30()
        f36()
        f42()
        f48()
        f54()
        f60()
        f66()
        f74()
        table.clear(v172)
      end

      ESPHooks.ScanNotify = f78
      ESPHooks.CheckNotify = f77

      esp:AddToggle("Door", {
        Text = "Door",
        Default = false,
        Callback = function(value125)
          if value125 then
            task.defer(f19)
          else
            f17()
          end
        end,
      }):AddColorPicker("ColorPickerDoor", {
        Default = color3,
        Title = "Door ESP Color",
        Callback = function(value126)
          color3 = value126

          if toggles.Door and toggles.Door.Value then
            f17()
            task.defer(f19)
          end
        end,
      })

      esp:AddToggle("Objective", {
        Text = "Objective (Items)",
        Default = false,
        Callback = function(value127)
          if value127 then
            task.defer(f26)
          else
            f23()
          end
        end,
      }):AddColorPicker("ColorPickerObjective", {
        Default = color4,
        Title = "Objective ESP Color",
        Callback = function(value128)
          color4 = value128

          if toggles.Objective and toggles.Objective.Value then
            f23()
            task.defer(f26)
          end
        end,
      })

      esp:AddToggle("HidingPlace", {
        Text = "Hiding Place",
        Default = false,
        Callback = function(value129)
          if value129 then
            task.defer(f32)
          else
            f30()
          end
        end,
      }):AddColorPicker("ColorPickerHiding", {
        Default = color5,
        Title = "Hiding Place ESP Color",
        Callback = function(value130)
          color5 = value130

          if toggles.HidingPlace and toggles.HidingPlace.Value then
            f30()
            task.defer(f32)
          end
        end,
      })

      esp:AddToggle("KeyBookESP", {
        Text = "Key & Book ESP",
        Default = false,
        Callback = function(value131)
          if value131 then
            task.defer(f38)
            task.defer(f44)
          else
            f36()
            f42()
          end
        end,
      }):AddColorPicker("ColorPickerKeyBook", {
        Default = color6,
        Title = "Key & Book ESP Color",
        Callback = function(value132)
          color6 = value132
          color7 = value132

          if toggles.KeyBookESP and toggles.KeyBookESP.Value then
            f36()
            f42()

            task.defer(f38)
            task.defer(f44)
          end
        end,
      })

      esp:AddToggle("Breakers", {
        Text = "Breaker",
        Default = false,
        Callback = function(value133)
          if value133 then
            task.defer(f50)
          else
            f48()
          end
        end,
      }):AddColorPicker("ColorPickerBreaker", {
        Default = color9,
        Title = "Breaker ESP Color",
        Callback = function(value134)
          color9 = value134

          if toggles.Breakers and toggles.Breakers.Value then
            f48()
            task.defer(f50)
          end
        end,
      })

      esp:AddToggle("Gold", {
        Text = "Gold / Chests",
        Default = false,
        Callback = function(value135)
          if value135 then
            task.defer(f56)
          else
            f54()
          end
        end,
      }):AddColorPicker("ColorPickerGold", {
        Default = color10,
        Title = "Gold / Chest ESP Color",
        Callback = function(value136)
          color10 = value136

          if toggles.Gold and toggles.Gold.Value then
            f54()
            task.defer(f56)
          end
        end,
      })

      esp:AddToggle("Entity", {
        Text = "Entity",
        Default = false,
        Callback = function(value137)
          if value137 then
            task.defer(f76)
          else
            f74()
          end
        end,
      }):AddColorPicker("ColorPickerEntity", {
        Default = color13,
        Title = "Entity ESP Color",
        Callback = function(value138)
          color13 = value138

          if toggles.Entity and toggles.Entity.Value then
            f74()
            task.defer(f76)
          end
        end,
      })

      esp:AddToggle("Ladder", {
        Text = "Ladder",
        Default = false,
        Callback = function(value139)
          if value139 then
            task.defer(f62)
          else
            f60()
          end
        end,
      }):AddColorPicker("ColorPickerLadder", {
        Default = color11,
        Title = "Ladder ESP Color",
        Callback = function(value140)
          color11 = value140

          if toggles.Ladder and toggles.Ladder.Value then
            f60()
            task.defer(f62)
          end
        end,
      })

      esp:AddToggle("Fuse", {
        Text = "Fuse",
        Default = false,
        Callback = function(value141)
          if value141 then
            task.defer(f68)
          else
            f66()
          end
        end,
      }):AddColorPicker("ColorPickerFuse", {
        Default = color12,
        Title = "Fuse ESP Color",
        Callback = function(value142)
          color12 = value142

          if toggles.Fuse and toggles.Fuse.Value then
            f66()
            task.defer(f68)
          end
        end,
      })

      local v176 = {
        Door = f19,
        KeyObtain = f38,
        ElectrialKeyObtain = f38,
        LeverForGate = f38,
        MinesAnchor = f26,
        LiveHintBook = f44,
        LiveBreakerPolePickup = f50,
        GoldPile = f56,
        Ladder = f62,
        FuseObtain = f68,
        MinesGenerator = f68,
        MinesGateButton = f68,
      }

      local currentRoom = localPlayer:GetAttributeChangedSignal("CurrentRoom")

      table.insert(v4, currentRoom:Connect(function()
        task.defer(f79)
        task.defer(f78)
      end))

      local descendantAdded = workspace.DescendantAdded

      table.insert(v4, descendantAdded:Connect(function(p115)
        local name4 = p115.Name
        local v177 = v176[name4]

        if v177 then
          task.defer(v177)
        end

        if BaseItems[name4] then
          task.defer(f26)
        end

        if HidingPlaces[name4] then
          task.defer(f32)
        end

        if v152[name4] then
          task.defer(f76)

          if v174[name4] then
            f77(p115)
          end
        end

        for index20, value143 in ipairs(v8) do
          if value143.Flag() and f4(name4, value143.Keywords) then
            task.defer(function()
              if p115 and p115.Parent then
                pcall(function() p115:Destroy() end)
              end
            end)

            break
          end
        end
      end))

      local childAdded = workspace.ChildAdded

      table.insert(v4, childAdded:Connect(function(p116)
        if v152[p116.Name] then
          task.defer(f76)

          if v174[p116.Name] then
            f77(p116)
          end
        end
      end))

      local childRemoved = workspace.ChildRemoved

      table.insert(v4, childRemoved:Connect(function(p117)
        if v152[p117.Name] and v153[p117] then
          v153[p117] = nil
          espLibrary:RemoveESP(p117)
        end
      end))
    end)

    camera:AddSlider("FOV", {
      Text = "FOV",
      Default = 70,
      Min = 70,
      Max = 120,
      Rounding = 1,
      Compact = false,
      Callback = function(value144) end,
      Tooltip = "Field of View",
    })

    camera:AddDivider()

    camera:AddToggle("ThirdPerson", { Text = "Third Person", Default = false }):AddKeyPicker("ThirdpersonKeybind", {
      Default = "T",
      SyncToggleState = true,
      Mode = "Toggle",
      Text = "Third Person",
      NoUI = false,
      Callback = function(value145) end,
      ChangedCallback = function(p118, p119) end,
    })

    camera:AddSlider("X", {
      Text = "X",
      Default = 2,
      Min = -10,
      Max = 10,
      Rounding = 1,
      Compact = false,
      Callback = function(value146) end,
      Tooltip = "X",
    })

    camera:AddSlider("Y", {
      Text = "Y",
      Default = 0,
      Min = -10,
      Max = 10,
      Rounding = 1,
      Compact = false,
      Callback = function(value147) end,
      Tooltip = "Y",
    })

    camera:AddSlider("Z", {
      Text = "Z",
      Default = 4,
      Min = -10,
      Max = 10,
      Rounding = 1,
      Compact = false,
      Callback = function(value148) end,
      Tooltip = "Z",
    })

    camera:AddToggle("NoCamShake", {
      Text = "No Camera Shake",
      Disabled = not require and true or false,
    })

    camera:AddToggle("Freecam", {
      Text = "Freecam",
      Default = false,
      Callback = function(value149)
        if not value149 then
          local freecamPart = workspace:FindFirstChild("FreecamPart")

          if freecamPart then
            freecamPart:Destroy()

            local humanoidRootPart = localPlayer.Character
              and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
              humanoidRootPart.Anchored = false
            end

            localPlayer.CameraMinZoomDistance = localPlayer:GetAttribute("fc_om") or 0.5
            localPlayer.CameraMaxZoomDistance = localPlayer:GetAttribute("fc_ox") or 128
          end
        end
      end,
    }):AddKeyPicker("FreecamKeybind", {
      Default = "B",
      SyncToggleState = true,
      Mode = "Toggle",
      Text = "Freecam",
      NoUI = false,
      Callback = function(value150) end,
      ChangedCallback = function(p120, p121) end,
    })

    camera:AddToggle("NoScenes", {
      Text = "No Cutscenes",
      Default = false,
      Callback = function(value151)
        local cutscenes3 = remoteListener:FindFirstChild("Cutscenes")
          or remoteListener:FindFirstChild("Cutscenes_")

        if value151 then
          cutscenes3.Name = "Cutscenes_"
        else
          cutscenes3.Name = "Cutscenes"
        end
      end,
    })

    notifying:AddDropdown("Notify", {
      Values = {
        "Alma", "Ambush", "Bash", "Blitz", "Bob", "Bramble", "Creak", "Drone", "Dread",
        "El Goblino", "Eyes", "Forget-Me-Not", "Glitch", "Glitch Ambush", "Glitch Rush", "Halt",
        "Haste", "Hide", "Honcho", "Jack", "Jeff", "Lookman", "Louie", "Monument", "Noise",
        "Portrait", "Queen Grumble", "Rush", "Sally", "Scribbles", "Seek", "Snare", "Stem",
        "Teller", "Timothy",
      },
      Default = 1,
      Multi = true,
      Text = "Choose to Notify",
      Callback = function(value152) end,
    })

    notifying:AddButton({
      Text = "Select All Notifications",
      Func = function()
        local v178 = {}

        for index21, value153 in ipairs({
          "Alma", "Ambush", "Bash", "Blitz", "Bob", "Bramble", "Creak", "Drone", "Dread",
          "El Goblino", "Eyes", "Forget-Me-Not", "Glitch", "Glitch Ambush", "Glitch Rush",
          "Halt", "Haste", "Hide", "Honcho", "Jack", "Jeff", "Lookman", "Louie", "Monument",
          "Noise", "Portrait", "Queen Grumble", "Rush", "Sally", "Scribbles", "Seek", "Snare",
          "Stem", "Teller", "Timothy",
        }) do
          v178[value153] = true
        end

        options.Notify:SetValue(v178)
      end,
    })

    notifying:AddButton({
      Text = "Clear Notifications",
      Func = function() options.Notify:SetValue({}) end,
    })

    notifying:AddToggle("NotifySpawn", {
      Text = "Notify Entity",
      Default = false,
      Tooltip = "Notify Entity In Spawn",
      Callback = function(value154)
        if value154 and ESPHooks and ESPHooks.ScanNotify then
          task.defer(ESPHooks.ScanNotify)
        end
      end,
    })

    screech = Instance.new("RemoteEvent", entityInfo)
    screech.Name = "Screech_"

    v26 = false

    bypassEntities:AddToggle("Dread", {
      Text = "Anti Dread",
      Default = false,
      Callback = function(value155)
        if value155 then
          local dread2 = localPlayer:FindFirstChild("Dread", true)
            or localPlayer:FindFirstChild("_Dread", true)

          if dread2 then
            dread2.Name = "_Dread"
          end
        else
          local dread3 = localPlayer:FindFirstChild("Dread", true)
            or localPlayer:FindFirstChild("_Dread", true)

          if dread3 then
            dread3.Name = "Dread"
          end
        end
      end,
    })

    bypassEntities:AddToggle("Halt", {
      Text = "Anti Halt",
      Default = false,
      Callback = function(value156)
        if value156 then
          local shade2 = modulesClient.EntityModules:FindFirstChild("Shade", true)
            or modulesClient.EntityModules:FindFirstChild("_Shade", true)

          if shade2 then
            shade2.Name = "_Shade"
          end
        else
          local shade3 = modulesClient.EntityModules:FindFirstChild("Shade", true)
            or modulesClient.EntityModules:FindFirstChild("_Shade", true)

          if shade3 then
            shade3.Name = "Shade"
          end
        end
      end,
    })

    bypassEntities:AddToggle("Jamming", {
      Text = "Anti Jammimg",
      Default = false,
      Callback = function(value157)
        if replicatedStorage:FindFirstChild("LiveModifiers")
          and replicatedStorage:FindFirstChild("LiveModifiers"):FindFirstChild("Jammin") then
          local initiator2 = localPlayer.PlayerGui.MainUI.Initiator
          initiator2:FindFirstChild("Main_Game").Health.Jam.Playing = not value157
          soundService.Main.Jamming.Enabled = not value157
        end
      end,
    })

    bypassEntities:AddToggle("Snare", {
      Text = "Anti Snare",
      Default = false,
      Callback = function(value158)
        local currentRooms12 = workspace.CurrentRooms
        local hitbox

        for key60, value159 in pairs(currentRooms12:GetDescendants()) do
          if value159.Name == "Snare" then
            local total = 0

            repeat
              task.wait(0.01)
              total = total + 0.01
              local v179 = total > 2

              hitbox = v179
              hitbox = v179 or value159:FindFirstChild("Hitbox")
            until hitbox

            if value159:FindFirstChild("Hitbox") then
              value159.Hitbox.CanTouch = not value158
            end
          end
        end
      end,
    })

    bypassEntities:AddToggle("Giggle", {
      Text = "Anti Giggle",
      Default = false,
      Callback = function(value160)
        local currentRooms13 = workspace.CurrentRooms
        local hitbox2

        for key61, value161 in pairs(currentRooms13:GetDescendants()) do
          if value161.Name == "GiggleCeiling" then
            local total2 = 0

            repeat
              task.wait(0.01)
              total2 = total2 + 0.01
              local v180 = total2 > 2

              hitbox2 = v180
              hitbox2 = v180 or value161:FindFirstChild("Hitbox")
            until hitbox2

            if value161:FindFirstChild("Hitbox") then
              value161.Hitbox.CanTouch = not value160
            end
          end
        end
      end,
    })

    bypassEntities:AddToggle("Dupe", {
      Text = "Anti Dupe",
      Default = false,
      Callback = function(value162)
        for key62, value163 in pairs(workspace.CurrentRooms:GetDescendants()) do
          if value163.Name == "DoorFake" and value163.Parent.Name == "SideroomDupe" then
            value163:WaitForChild("Hidden", 9000000000).CanTouch = not value162
          end
        end
      end,
    })

    bypassEntities:AddToggle("GloomEggDamage", {
      Text = "Anti Gloom Egg",
      Default = false,
      Callback = function(value164)
        for key63, value165 in pairs(workspace.CurrentRooms:GetDescendants()) do
          if value165.Name == "GloomEgg" then
            for key64, value166 in pairs(value165:GetChildren()) do
              if value166:IsA("BasePart") then
                value166.CanTouch = not value164
              end
            end
          end
        end
      end,
    })

    bypassEntities:AddToggle("FigureHearing", {
      Text = "Anti Figure Hearing",
      Default = false,
      Callback = function(value167)
        if not value167 then
          entityInfo.Crouch:FireServer(false)
        else
          entityInfo.Crouch:FireServer(true)
        end
      end,
    })

    surgeRemote = Instance.new("RemoteEvent", replicatedStorage)
    surgeRemote.Name = "SurgeRemote"

    noDamageEntities:AddToggle("ScreechDamage", {
      Text = "Anti Screech Damage",
      Default = false,
      Callback = function(value168)
        if value168 then
          v26 = true
          entityInfo.Screech.Name = "Screech_"
          screech.Name = "Screech"
        elseif v26 then
          entityInfo.Screech_.Name = "Screech"
          screech.Name = "Screech_"
        end
      end,
    })

    noDamageEntities:AddToggle("EyesDamage", { Text = "Anti Eyes Damage", Default = false })

    noDamageEntities:AddToggle("LookmanDamage", {
      Text = "Anti Lookman Damage",
      Default = false,
    })

    noDamageEntities:AddToggle("NoSurgeDamage", {
      Text = "No Surge Damage",
      Default = false,
      Callback = function(value169)
        if value169 then
          if entityInfo:FindFirstChild("SurgeRemote") then
            entityInfo.SurgeRemote.Parent = replicatedStorage
            surgeRemote.Parent = entityInfo
          end
        elseif entityInfo:FindFirstChild("SurgeRemote") then
          replicatedStorage.SurgeRemote.Parent = entityInfo
          surgeRemote.Parent = replicatedStorage
        end
      end,
    })

    infiniteItems:AddToggle("InfItems", {
      Text = "Infinite Items",
      Default = false,
      Tooltip = "Makes selected items infinite",
      Callback = function(value170)
        if value170 then
          for key65, value171 in pairs(workspace.CurrentRooms:GetDescendants()) do
            if IsInfItemTarget(value171) then
              table.insert(Stored, value171)
            end
          end
        else
          for key66, value172 in pairs(workspace.CurrentRooms:GetDescendants()) do
            if value172:IsA("ProximityPrompt") and value172:GetAttribute("InfItems") then
              RestorePrompt(value172)
            end
          end
        end
      end,
    })

    infiniteItems:AddDropdown("InfiniteItemsSelect", {
      Text = "Select Items",
      Values = { "Lockpick", "Skeleton Key", "Shears", "Multitool" },
      Multi = true,
      Default = { "Lockpick", "Skeleton Key", "Shears", "Multitool" },
      Callback = function(value173) InfiniteItemsSelected = value173 or {} end,
    })

    infiniteItems:AddDivider()

    infiniteItems:AddToggle("InfCrucifix", {
      Text = "Infinite Crucifix",
      Default = false,
      Tooltip = "⚠️ ONLY WORKS ON RUSH AND AMBUSH",
      Risky = true,
      Callback = function(value174) InfiniteCrucifixEnabled = value174 end,
    })

    bypass:AddToggle("BypassSpeed", {
      Text = "Speed Bypass",
      Default = false,
      Callback = function(value175)
        options.MovementSpeed:SetMax(value175 and 75 or 21)
        options.FlightSpeed:SetMax(value175 and 75 or 21)
      end,
    })

    bypass:AddDivider()

    bypass:AddDropdown("AntiCheatManiMethod", {
      Values = { "Velocity", "Anticheat" },
      Default = 1,
      Text = "Manipulation Method",
      Callback = function(value176) end,
    })

    bypass:AddToggle("AntiCheatMani", {
      Text = "Manipulation",
      Default = false,
      Callback = function(value177)
        if not value177 then
          if localPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityMani") then
            localPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityMani"):Destroy()
          end

          if toggles.NoClip.Value then
            toggles.NoClip:SetValue(false)
          end
        end
      end,
    }):AddKeyPicker("AntiCheatMan", {
      Default = "V",
      SyncToggleState = true,
      Mode = v2.IsMobile and "Toggle" or "Hold",
      Text = " Manipulation",
      NoUI = false,
      Callback = function(value178) end,
      ChangedCallback = function(p122, p123) end,
    })

    task.spawn(function()
      while task.wait() do
        if v2.Unloaded then
          break
        elseif toggles.BypassSpeed.Value then
          if collisionClone then
            collisionClone.Massless = true
          end

          entityInfo.Crouch:FireServer(true, true)
        end
      end
    end)

    local childAdded2 = workspace.ChildAdded

    table.insert(v4, childAdded2:Connect(function(p124)
      if toggles.AntiBanana.Value and p124.Name == "BananaPeel" then
        p124.CanTouch = false
      end

      local primaryPart2

      if toggles.AntiJeff.Value and p124.Name == "JeffTheKiller" then
        repeat
          task.wait()
          primaryPart2 = p124.PrimaryPart and isnetworkowner(p124.PrimaryPart)
        until primaryPart2

        for key67, value179 in pairs(p124:GetChildren()) do
          if value179:IsA("BasePart") then
            value179.CanTouch = false
          end
        end

        p124.Humanoid.Health = 0
      end
    end))

    hotel:AddToggle("NotifyLibraryCode", { Text = "Notify Library Code", Default = false })

    hotel:AddToggle("SeekObf", {
      Text = "Anti Seek Obstacles",
      Default = false,
      Callback = function(value180)
        for key68, value181 in pairs(workspace.CurrentRooms:GetDescendants()) do
          if value181.Name == "Seek_Arm" or value181.Name == "ChandelierObstruction" then
            for key69, value182 in pairs(value181:GetChildren()) do
              if value182:IsA("BasePart") then
                value182.CanTouch = not value180
              end
            end
          end
        end
      end,
    })

    reach:AddToggle("PromptReach", {
      Text = "Prompt Reach",
      Default = false,
      Callback = function(value183)
        if value183 then
          for key70, value184 in pairs(workspace:GetDescendants()) do
            if value184:IsA("ProximityPrompt") then
              value184:SetAttribute("Range", value184.MaxActivationDistance)
              value184.MaxActivationDistance = value184.MaxActivationDistance * 2
            end
          end
        else
          for key71, value185 in pairs(workspace:GetDescendants()) do
            if value185:IsA("ProximityPrompt") then
              value185.MaxActivationDistance = value185:GetAttribute("Range")
                or value185.MaxActivationDistance
            end
          end
        end
      end,
    })

    reach:AddToggle("PromptClip", {
      Text = "Prompt Clip",
      Default = false,
      Callback = function(value186)
        if value186 then
          for key72, value187 in pairs(workspace:GetDescendants()) do
            if value187:IsA("ProximityPrompt") then
              value187:SetAttribute("Clip", value187.RequiresLineOfSight)
              value187.RequiresLineOfSight = false
            end
          end
        else
          for key73, value188 in pairs(workspace:GetDescendants()) do
            if value188:IsA("ProximityPrompt") then
              value188.RequiresLineOfSight = value188:GetAttribute("Clip") or true
            end
          end
        end
      end,
    })

    reach:AddToggle("DoorReach", { Text = "Door Reach", Default = false })

    PlayerColor = Color3.fromRGB(150, 150, 150)

    esp:AddToggle("Player", {
      Text = "Player",
      Default = false,
      Callback = function(value189)
        for key74, value190 in pairs(players:GetPlayers()) do
          if value190 ~= localPlayer and value190.Character then
            espLibrary:RemoveESP(value190.Character)

            if value189 then
              local humanoid = value190.Character:FindFirstChildOfClass("Humanoid")

              if humanoid and humanoid.Health > 0 then
                AddESP(value190.Character, value190.Name .. " ["
                  .. math.floor(humanoid.Health / humanoid.MaxHealth * 100) .. "%]", PlayerColor)
              end
            end
          end
        end
      end,
    }):AddColorPicker("ColorPickerPlayer", {
      Default = PlayerColor,
      Title = "Player ESP Color",
      Callback = function(value191)
        PlayerColor = value191
        toggles.Player:SetValue(false)
        toggles.Player:SetValue(true)
      end,
    })

    bypass:AddDivider()
    v27 = {}

    v28 = {
      Lock = true,
      ChestBoxLocked = true,
      Cellar = true,
      Chest_Vine = true,
      CuttableVines = true,
      SkullLock = true,
      Toolbox_Locked = true,
      Lock1 = true,
      Lock2 = true,
    }

    function f9(p125)
      if not p125 or not p125:IsA("ProximityPrompt") then
        return false
      elseif p125.Name == "FusesPrompt" then
        return true
      else
        local parent = p125.Parent

        if not parent then
          return false
        else
          local name5 = parent.Name
          local name6 = parent.Parent and parent.Parent.Name

          if v28[name5] or name6 and v28[name6] then
            return true
          end

          if name6 == "Locker_Small_Locked" then
            return true
          end

          return false
        end
      end
    end

    function f2(p126)
      local character2 = localPlayer.Character
      local name7, infPrompt, connect2, connect3, f80

      if not character2 then
        return
      elseif not character2:FindFirstChild("HumanoidRootPart") then
        return
      else
        local lockpick = character2:FindFirstChild("Lockpick")
          or character2:FindFirstChild("SkeletonKey") or character2:FindFirstChild("Shears")
          or character2:FindFirstChild("Multitool")

        name7 = lockpick and lockpick.Name

        if lockpick and InfiniteItemsSelected then
          local v181 = nil

          if lockpick.Name == "Lockpick" then
            v181 = "Lockpick"
          elseif lockpick.Name == "SkeletonKey" then
            v181 = "Skeleton Key"
          elseif lockpick.Name == "Shears" then
            v181 = "Shears"
          elseif lockpick.Name == "Multitool" then
            v181 = "Multitool"
          end

          if v181 and not InfiniteItemsSelected[v181] then
            return
          end
        end

        local parent2 = p126.Parent
          and (p126.Parent:IsA("BasePart") and p126.Parent
            or p126.Parent:FindFirstChildWhichIsA("BasePart"))

        local v182 = parent2 and f6(parent2.Position) or 999

        if lockpick and v182 <= p126.MaxActivationDistance + 5 then
          if p126:GetAttribute("InfItems") and p126:GetAttribute("Tool") ~= name7 then
            f10(p126)
          end

          if p126:GetAttribute("InfItems") then
            local infTime = p126:GetAttribute("InfTime")

            if tick() - (infTime or 0) > 8 or v182 > p126.MaxActivationDistance + 7 then
              f10(p126)
            end

            return
          end

          if not p126:GetAttribute("InfItems") then
            p126.Enabled = false
            p126:SetAttribute("InfItems", true)
            p126:SetAttribute("Tool", name7)
            p126:SetAttribute("InfTime", tick())
            p126.ClickablePrompt = false

            infPrompt = p126:Clone()
            infPrompt.Name = "InfPrompt"
            infPrompt.MaxActivationDistance = p126.MaxActivationDistance
            infPrompt.Parent = p126.Parent
            infPrompt.Enabled = true
            infPrompt.ClickablePrompt = true

            connect2 = nil
            connect3 = nil

            function f80()
              if connect2 then
                connect2:Disconnect()
              end

              if connect3 then
                connect3:Disconnect()
              end

              f10(p126)
            end

            connect3 = infPrompt.PromptButtonHoldEnded:Connect(function()
              task.delay(0.15, function()
                if infPrompt and infPrompt.Parent then
                  f80()
                end
              end)
            end)

            connect2 = infPrompt.Triggered:Connect(function()
              if connect3 then
                connect3:Disconnect()
              end

              if connect2 then
                connect2:Disconnect()
              end

              if infPrompt and infPrompt.Parent then
                infPrompt:Destroy()
              end

              if character2:FindFirstChild(name7) then
                task.spawn(function()
                  local v183 = tick()
                  local v184, v185

                  repeat
                    entityInfo.DropItem:FireServer(lockpick)
                    task.wait(0.01)
                    local v186 = 15

                    if workspace:FindFirstChild("Drops") then
                      for index22, value192 in ipairs(workspace.Drops:GetChildren()) do
                        if value192.Name == name7 then
                          local v187 = f6(value192:GetPivot().Position)

                          if v187 < v186 then
                            v184 = value192
                            v186 = v187
                          end
                        end
                      end
                    end

                    v185 = v184
                    v185 = v184 or not character2:FindFirstChild(name7) or tick() - v183 > 2.5
                  until v185

                  local v188 = v9 or fireproximityprompt

                  if name7 == "Shears" then
                    if v188 then
                      v188(p126)
                    end

                    if v184 then
                      local findFirstChildWhichIsA = v184:FindFirstChildWhichIsA(
                        "ProximityPrompt", true
                      )

                      if findFirstChildWhichIsA and v188 then
                        v188(findFirstChildWhichIsA)
                      end
                    end
                  else
                    if v184 then
                      local findFirstChildWhichIsA2 = v184:FindFirstChildWhichIsA(
                        "ProximityPrompt", true
                      )

                      if findFirstChildWhichIsA2 and v188 then
                        v188(findFirstChildWhichIsA2)
                      end
                    end

                    if v188 then
                      v188(p126)
                    end
                  end

                  f10(p126)
                end)
              else
                f10(p126)
              end
            end)
          end

          return
        end

        if p126:GetAttribute("InfItems") then
          f10(p126)
        end

        return
      end
    end

    function f10(p127)
      if not p127 then
        return
      end

      if p127.Parent then
        local infPrompt2 = p127.Parent:FindFirstChild("InfPrompt")

        if infPrompt2 then
          infPrompt2:Destroy()
        end
      end

      p127:SetAttribute("InfItems", nil)
      p127:SetAttribute("Tool", nil)
      p127:SetAttribute("InfTime", nil)
      p127.Enabled = true
      p127.ClickablePrompt = true
    end

    v29 = 0
    v30 = 0
    v31 = 0
    v32 = 0
    v33 = 0
    v34 = 0
    local renderStepped = runService.RenderStepped

    table.insert(v4, renderStepped:Connect(function(p128)
      v29 = v29 + p128
      v31 = v31 + p128
      v30 = v30 + p128
      v32 = v32 + p128
      v33 = v33 + p128
      v34 = v34 + p128

      if not localPlayer:GetAttribute("Alive") then
        if toggles.InfRevive.Value then
          entityInfo.Revive:FireServer()
        end

        if collisionClone then
          collisionClone = nil
        end

        return
      end

      if currentCamera ~= workspace.CurrentCamera then
        currentCamera = workspace.CurrentCamera
      end

      if not localPlayer.Character:GetAttribute("Climbing")
        and toggles.EnableMovementSpeed.Value then
        if localPlayer.Character.Humanoid.WalkSpeed ~= options.MovementSpeed.Value then
          localPlayer.Character.Humanoid.WalkSpeed = options.MovementSpeed.Value
        end
      elseif localPlayer.Character:GetAttribute("Climbing")
        and toggles.EnableClimbingSpeed.Value then
        if localPlayer.Character.Humanoid.WalkSpeed ~= options.ClimbingSpeed.Value then
          localPlayer.Character.Humanoid.WalkSpeed = options.ClimbingSpeed.Value
        end
      end

      if toggles.ThirdPerson.Value then
        currentCamera.CFrame = currentCamera.CFrame
          * CFrame.new(options.X.Value, options.Y.Value, options.Z.Value)
      end

      for key75, value193 in pairs(localPlayer.Character:GetChildren()) do
        if value193:IsA("BasePart") and (value193.Name == "Head" or value193.Name == "FakeHead") then
          value193.Transparency = toggles.ThirdPerson.Value and 0 or 1
          value193.LocalTransparencyModifier = toggles.ThirdPerson.Value and 0 or 1
        end

        if value193:IsA("Accessory") then
          local handle = value193:FindFirstChild("Handle")

          if handle then
            handle.Transparency = toggles.ThirdPerson.Value and 0 or 1
            handle.LocalTransparencyModifier = toggles.ThirdPerson.Value and 0 or 1
          end
        end
      end

      currentCamera.FieldOfView = options.FOV.Value

      if toggles.Freecam.Value then
        local character3 = localPlayer.Character

        local humanoid2 = character3
        humanoid2 = character3 and character3:FindFirstChild("Humanoid")

        local humanoidRootPart2 = character3
        humanoidRootPart2 = character3 and character3:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart2 and not humanoidRootPart2.Anchored then
          humanoidRootPart2.Anchored = true
        end

        if not workspace:FindFirstChild("FreecamPart") then
          local freecamPart2 = Instance.new("Part")
          freecamPart2.Name = "FreecamPart"
          freecamPart2.Size = Vector3.new(0.01, 0.01, 0.01)
          freecamPart2.Transparency = 1
          freecamPart2.CanCollide = false
          freecamPart2.Anchored = true
          freecamPart2.CFrame = currentCamera.CFrame
          freecamPart2.Parent = workspace

          localPlayer:SetAttribute("fc_om", localPlayer.CameraMinZoomDistance)
          localPlayer:SetAttribute("fc_ox", localPlayer.CameraMaxZoomDistance)
          localPlayer.CameraMinZoomDistance = 0
          localPlayer.CameraMaxZoomDistance = 0

          local v189, v190 = currentCamera.CFrame:ToOrientation()

          localPlayer:SetAttribute("fc_p", math.deg(v189))
          localPlayer:SetAttribute("fc_y", math.deg(v190))
        end

        local freecamPart3 = workspace:FindFirstChild("FreecamPart")
        local v191 = currentCamera

        if freecamPart3 and v191 then
          local getMouseDelta = userInputService:GetMouseDelta()
          local keyboardEnabled = userInputService.KeyboardEnabled and 0.3 or 0.6
          local fcP = localPlayer:GetAttribute("fc_p")

          local v192 = (localPlayer:GetAttribute("fc_y") or 0)
            - getMouseDelta.X * keyboardEnabled

          local v193 = math.clamp((fcP or 0) - getMouseDelta.Y * keyboardEnabled, -80, 80)

          localPlayer:SetAttribute("fc_p", v193)
          localPlayer:SetAttribute("fc_y", v192)

          freecamPart3.CFrame = CFrame.new(freecamPart3.Position)
            * CFrame.fromOrientation(math.rad(v193), math.rad(v192), 0)

          v191.CFrame = freecamPart3.CFrame
          v191.Focus = v191.CFrame * CFrame.new(0, 0, -10)

          if humanoid2 and humanoid2.MoveDirection.Magnitude > 0 then
            local vectorToObjectSpace = v191.CFrame:VectorToObjectSpace(humanoid2.MoveDirection)

            freecamPart3.Position = freecamPart3.Position
              + (v191.CFrame.RightVector * vectorToObjectSpace.X
                  + v191.CFrame.LookVector * -vectorToObjectSpace.Z)
                * 75
                * p128
          end
        end
      end

      if toggles.DeleteFigureFE.Value and v19 then
        for key76, value194 in pairs(v19) do
          local root3 = value194:FindFirstChild("Root")

          if not v14 then
            f1("Sorry your executor wont support Delete Figure Because isnetworkowner", 5)
            toggles.DeleteFigureFE:SetValue(false)
          end

          if root3 and isnetworkowner(root3) then
            if root3:FindFirstChild("BodyForce") then
              root3.BodyForce.Force = Vector3.new(0, -50000, 0)
            else
              root3:PivotTo(CFrame.new(0, -50000, 0))
            end

            for key77, value195 in pairs(value194:GetDescendants()) do
              if value195:IsA("BasePart") and value195.CanCollide then
                value195.CanCollide = false
                value195.Anchored = false
              end
            end

            if root3.Position.Y < -1000 and not value194:GetAttribute("Deleted") then
              f1("Deleted Figure Successfully", 4)
              value194:SetAttribute("Deleted", true)
            end
          end
        end
      end

      if toggles.AutoAnchorSolver.Value and latestRoom.Value == 50 and v30 > 0.5 then
        v30 = 0
        local anchorHintFrame = localPlayer.PlayerGui.MainUI:FindFirstChild("AnchorHintFrame")

        if v22 and anchorHintFrame and anchorHintFrame.Visible then
          local text = anchorHintFrame.AnchorCode.Text

          for key78, value196 in pairs(v22) do
            if value196:FindFirstChild("Sign") and value196.Sign.TextLabel.Text == text then
              local text2 = anchorHintFrame.Code.Text
              local note = value196:FindFirstChild("Note")
              local text3 = note and note.SurfaceGui.TextLabel.Text or ""
              local v194 = tonumber(string.match(text3, "%d+")) or 0
              local text4 = ""
              local v195 = #text2
              local count6 = 0

              while true do
                count6 = 1 + count6

                if not (v195 >= count6) then
                  break
                end

                local v196 = count6
                local v197 = tonumber(string.sub(text2, v196, v196)) or 0

                local v198 = string.find(text3, "+") and (v197 + v194) % 10
                  or (v197 - v194) % 10

                text4 = text4 .. tostring(v198 < 0 and v198 + 10 or v198)
              end

              if (localPlayer.Character.HumanoidRootPart.Position - value196:GetPivot().Position).Magnitude
                < 20 then
                local remoteFunction = value196:FindFirstChildOfClass("RemoteFunction")

                if remoteFunction then
                  remoteFunction:InvokeServer(tostring(text2))
                end

                f1("Anchor " .. text4, 1)
              end
            end
          end
        end
      end

      local dot

      if toggles.AutoMinecart.Value and currentCamera:FindFirstChild("MinecartRig") then
        if latestRoom.Value < 49 then
          if not localPlayer:GetAttribute("NotifyMinecart") then
            f1("[Auto Minecart] DONT MOVE", 5)
            localPlayer:SetAttribute("NotifyMinecart", true)
          end

          local humanoidRootPart3 = localPlayer.Character.HumanoidRootPart
          local huge = math.huge

          for key79, value197 in pairs(v20) do
            local v199 = f6(value197:GetPivot().Position)

            if v199 < huge then
              huge = v199
            end
          end

          if v15.crouching ~= (huge < 30) then
            v15.crouching = huge < 30
          end

          local v200 = nil
          local huge2 = math.huge

          for key80, value198 in pairs(v21) do
            if value198:GetAttribute("ForceConnect") then
              local magnitude = (humanoidRootPart3.Position - value198.Position).Magnitude

              if magnitude < huge2 then
                huge2 = magnitude
                v200 = value198
              end
            end
          end

          if v200 then
            local v201 = tonumber(string.match(v200.Name, "%d+"))

            if v201 then
              local v202 = nil

              for key81, value199 in pairs(v21) do
                if value199.Name == "MinecartNode" .. tostring(v201 + 3) then
                  v202 = value199
                  break
                end
              end

              if v202 then
                if f6(v200.Position) > 30 then
                  local v203 = require(localPlayer.PlayerScripts.PlayerModule)
                  v203:GetControls().GetMoveVector = function() return Vector3.new(0, 0, -1) end
                else
                  dot = (v200.Position - v202.Position).Unit:Dot(v200.CFrame.RightVector)
                  local v204 = require(localPlayer.PlayerScripts.PlayerModule)

                  v204:GetControls().GetMoveVector = function()
                    if dot > 0.15 then
                      return Vector3.new(1, 0, 0)
                    end

                    if dot < -0.15 then
                      return Vector3.new(1, 0, 0)
                    end

                    return Vector3.new(0, 0, -1)
                  end
                end
              end
            end
          end
        elseif latestRoom.Value >= 50 then
          if localPlayer:GetAttribute("NotifyMinecart") then
            f1("[Auto Minecart] YOU CAN MOVE", 5)
            localPlayer:SetAttribute("NotifyMinecart", false)
          end

          toggles.AutoMinecart:SetValue(false)

          local v205 = require(localPlayer.PlayerScripts.PlayerModule)
          v205:GetControls().GetMoveVector = getMoveVector
        end
      end

      if toggles.InfItems.Value and v32 > 0.15 then
        v32 = 0

        for key82, value200 in pairs(v27) do
          f2(value200)
        end
      end

      if toggles.NotifyLibraryCode.Value and v31 > 5 then
        v31 = 0
        local v206 = GetLibraryCode()

        if v206 and latestRoom.Value == 50 then
          f1("Code " .. v206)
        end
      end

      if toggles.Flight.Value then
        if not localPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity") then
          local flightVelocity = Instance.new(
            "BodyVelocity", localPlayer.Character.HumanoidRootPart
          )

          flightVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
          flightVelocity.Velocity = Vector3.zero
          flightVelocity.Name = "FlightVelocity"
          flightVelocity.P = math.huge
        end

        if customPhysicalProperties then
          localPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = customPhysicalProperties
        end

        local moveDirection = localPlayer.Character.Humanoid.MoveDirection
        local v207 = currentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)

        if v207.Magnitude < 0.001 then
          v207 = currentCamera.CFrame.UpVector * Vector3.new(1, 0, 1)
            * math.sign(-currentCamera.CFrame.LookVector.Y)
        end

        local vectorToObjectSpace2 = CFrame.lookAt(Vector3.zero, v207):VectorToObjectSpace(moveDirection)

        local flightVelocity2 = localPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity")

        flightVelocity2.Velocity = currentCamera.CFrame:VectorToWorldSpace(vectorToObjectSpace2)
          * options.FlightSpeed.Value
      end

      if toggles.Godmode.Value then
        if entityInfo.Name == "RemotesFolder" then
          if not toggles.FigureHearing.Value then
            f1("Enabled Figure Hearing Automaticlly cause Godmode needs it", 3)
            toggles.FigureHearing:SetValue(true)
          end

          if localPlayer.Character.LowerTorso.Root.C1 ~= CFrame.new(0, -2.3, 0) then
            localPlayer.Character.LowerTorso.Root.C1 = CFrame.new(0, -2.3, 0)
          end

          if localPlayer.Character.Humanoid.HipHeight ~= 0.22 then
            localPlayer.Character.Humanoid.HipHeight = 0.22
          end

          if localPlayer.Character.Collision.Size ~= Vector3.new(1, 1, 4) then
            localPlayer.Character.Collision.Size = Vector3.new(1, 1, 4)
          end

          if localPlayer.Character.Collision.CollisionCrouch.Size ~= Vector3.new(1, 1, 4) then
            localPlayer.Character.Collision.CollisionCrouch.Size = Vector3.new(1, 1, 4)
          end
        end

        if (floor.Value == "Fools" or entityInfo.Name == "Bricks") and not toggles.NoClip.Value then
          toggles.NoClip:SetValue(true)
        end
      end

      if not localPlayer.Character:FindFirstChild("CollisionClone") then
        if localPlayer.Character:FindFirstChild("CollisionPart") then
          collisionClone = localPlayer.Character.CollisionPart:Clone()
          collisionClone.Parent = localPlayer.Character
          collisionClone.Name = "CollisionClone"
          collisionClone.RootPriority = 127
          collisionClone.Anchored = false
          collisionClone.CanCollide = false

          if collisionClone:FindFirstChild("CollisionCrouch") then
            collisionClone:FindFirstChild("CollisionCrouch"):Destroy()
          end
        end
      end

      if toggles.NoScenes.Value and latestRoom.Value == 100 then
        toggles.NoScenes:SetValue(false)
      end

      if not v13 then
        if toggles.FigureHearing.Value then
          if entityInfo:FindFirstChild("Crouch") then
            entityInfo.Crouch:FireServer(true)
          end
        end
      end

      if toggles.AutoLibraryCode.Value then
        if latestRoom.Value == 50 then
          local v208 = GetLibraryCode()

          if v208 then
            if toggles.BruteForceLibCode.Value and string.find(v208, "_") then
              local text5 = ""

              for i7 = 1, #v208 do
                local v209 = string.sub(v208, i7, i7)
                text5 = text5 .. (v209 == "_" and math.random(0, 9) or v209)
              end

              v208 = text5
            end

            pl:FireServer(v208)
          end
        end
      end

      if toggles.DoorReach.Value and v34 > 0.2 then
        v34 = 0
        local currentRooms14 = workspace:FindFirstChild("CurrentRooms")

        local findFirstChild3 = currentRooms14

        findFirstChild3 = currentRooms14
          and currentRooms14:FindFirstChild(tostring(tonumber(latestRoom.Value) or 0))

        local door4 = findFirstChild3
        door4 = findFirstChild3 and findFirstChild3:FindFirstChild("Door")

        if door4 and door4:FindFirstChild("Door") and door4.Parent
          and door4.Parent.Name ~= "101" and f6(door4.Door.Position) < 30 then
          door4.ClientOpen:FireServer()
        end
      end

      if toggles.NoAcc.Value then
        if not toggles.Flight.Value then
          if localPlayer.Character.HumanoidRootPart.CustomPhysicalProperties
            ~= PhysicalProperties.new(100, 0.1, 0.1, 0.1, 0.1) then
            localPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(
              100, 0.1, 0.1, 0.1, 0.1
            )
          end
        end
      end

      if toggles.EnableJump.Value then
        if not localPlayer.Character:GetAttribute("CanJump") then
          localPlayer.Character:SetAttribute("CanJump", true)
        end
      end

      if toggles.AutoInteract and toggles.AutoInteract.Value then
        v29 = v29 + (p128 or 0.016)

        if v29 > (options.AutoInteractDelay and options.AutoInteractDelay.Value or 0.05) then
          v29 = 0

          if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local position5 = localPlayer.Character.HumanoidRootPart.Position
            local value201 = options.AutoInteractreach and options.AutoInteractreach.Value or 12
            local v210 = v9 or fireproximityprompt

            for i8 = #Interactions, 1, -1 do
              local v211 = Interactions[i8]

              if not v211 or not v211.Parent then
                table.remove(Interactions, i8)
              elseif v211.Parent.Name == "GoldPile" and floor and floor.Value == "Fools"
                or v211.Parent.Name == "KeyObtainFake" then
              elseif v211.Parent.Parent and v211.Parent.Parent.Parent
                and v211.Parent.Parent.Parent.Name == "ItemSpawns" then
              elseif v211:GetAttribute("InfItems") and v211.Name ~= "InfPrompt" then
              elseif v211.Parent.Name == "Mandrake" then
              elseif v211:GetAttribute("Interactions")
                and v211:GetAttribute("Interactions") > 0 then
                table.remove(Interactions, i8)
              elseif v211.Parent:IsA("BasePart") or v211.Parent:IsA("Model") then
                local parent3 = v211.Parent:IsA("BasePart") and v211.Parent
                  or v211.Parent.PrimaryPart or v211.Parent:FindFirstChildWhichIsA("BasePart")

                if parent3 then
                  if (position5 - parent3.Position).Magnitude <= value201 then
                    if not v211.Enabled then
                      v211.Enabled = true
                    end

                    if v210 then
                      v210(v211)
                    else
                      v211:InputHoldBegin()
                      v211:InputHoldEnd(v211.HoldDuration or 0)
                    end
                  end
                end
              end
            end
          end
        end
      end

      if toggles.NoFog.Value then
        if lighting.FogEnd < 100000 then
          lighting.FogEnd = 100000
        end

        for key83, value202 in pairs(lighting:GetChildren()) do
          if value202:IsA("Atmosphere") and value202.Density > 0 then
            value202.Density = 0
          end
        end
      end

      if toggles.NoCamShake.Value then
        if v15 then
          v15.csgo = CFrame.new(0, 0, 0)
        end
      end

      if toggles.Player.Value and v33 > 1 then
        v33 = 0

        for key84, value203 in pairs(players:GetPlayers()) do
          if value203 ~= localPlayer and value203.Character then
            local humanoid3 = value203.Character:FindFirstChildOfClass("Humanoid")

            if humanoid3 then
              if humanoid3.Health > 0 then
                AddESP(value203.Character, value203.Name .. " ["
                  .. math.floor(humanoid3.Health / humanoid3.MaxHealth * 100) .. "%]", PlayerColor)
              else
                espLibrary:RemoveESP(value203.Character)
              end
            end
          end
        end
      end

      if toggles.EyesDamage.Value then
        if (workspace:FindFirstChild("Eyes") or workspace:FindFirstChild("Lookman"))
          and not localPlayer.Character:GetAttribute("Hiding") then
          if entityInfo.Name ~= "RemotesFolder" then
            motorReplication:FireServer(0, -650, 0, false)
          else
            motorReplication:FireServer(-650)
          end
        end
      end

      if toggles.LookmanDamage.Value then
        if workspace:FindFirstChild("BackdoorLookman") then
          if not localPlayer.Character:GetAttribute("Hiding") then
            motorReplication:FireServer(-650)
          end
        end
      end

      if toggles.FullBright.Value then
        if lighting.Ambient ~= Color3.new(1, 1, 1) then
          lighting.Ambient = Color3.new(1, 1, 1)
        end

        local currentRooms15 = workspace:FindFirstChild("CurrentRooms")
        local findFirstChild4 = currentRooms15
        local v212 = tonumber(localPlayer:GetAttribute("CurrentRoom")) or 0
        findFirstChild4 = currentRooms15 and currentRooms15:FindFirstChild(tostring(v212))

        if findFirstChild4 then
          if not findFirstChild4:GetAttribute("OldAmbient") then
            findFirstChild4:SetAttribute("OldAmbient", findFirstChild4:GetAttribute("Ambient"))
          end

          if findFirstChild4:GetAttribute("Ambient") ~= Color3.new(1, 1, 1) then
            findFirstChild4:SetAttribute("Ambient", Color3.new(1, 1, 1))
          end
        end

        if (tonumber(latestRoom.Value) or 0) < 100 then
          local findFirstChild5 = currentRooms15
          findFirstChild5 = currentRooms15 and currentRooms15:FindFirstChild(tostring(v212 + 1))

          if findFirstChild5 then
            if not findFirstChild5:GetAttribute("OldAmbient") then
              findFirstChild5:SetAttribute(
                "OldAmbient", findFirstChild5:GetAttribute("Ambient")
              )
            end

            if findFirstChild5:GetAttribute("Ambient") ~= Color3.new(1, 1, 1) then
              findFirstChild5:SetAttribute("Ambient", Color3.new(1, 1, 1))
            end
          end
        end
      end

      if toggles.AntiCheatMani.Value and localPlayer.Character
        and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if options.AntiCheatManiMethod.Value == "Velocity" then
          if not toggles.NoClip.Value then
            toggles.NoClip:SetValue(true)
          end

          local velocityMani = localPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityMani")

          local velocityMani2 = velocityMani

          velocityMani2 = velocityMani
            or Instance.new("BodyVelocity", localPlayer.Character.HumanoidRootPart)

          local v213 = localPlayer.Character.HumanoidRootPart.CFrame.LookVector * 2

          velocityMani2.Velocity = Vector3.new(v213.X, v213.Y, v213.Z)
          velocityMani2.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
          velocityMani2.Name = "VelocityMani"
        else
          local getPivot = localPlayer.Character:GetPivot()
          localPlayer.Character:PivotTo(getPivot * CFrame.new(0, 0, 10000))
        end
      end

      local crucifix

      if InfiniteCrucifixEnabled and localPlayer.Character
        and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        crucifix = localPlayer.Character:FindFirstChild("Crucifix")

        if crucifix then
          for key85, value204 in pairs(workspace:GetChildren()) do
            if value204.Name == "RushMoving" or value204.Name == "AmbushMoving" then
              if value204.PrimaryPart then
                if (localPlayer.Character.HumanoidRootPart.Position
                    - value204.PrimaryPart.Position).Magnitude
                  < 100 then
                  task.spawn(function()
                    entityInfo.DropItem:FireServer(crucifix)
                    local v214 = tick()
                    local crucifix2

                    repeat
                      task.wait(0.01)
                      local drops = workspace:FindFirstChild("Drops")
                      local crucifix3 = drops and drops:FindFirstChild("Crucifix")

                      local proximityPrompt = crucifix3
                        and crucifix3:FindFirstChildOfClass("ProximityPrompt")

                      if proximityPrompt and v9 then
                        v9(proximityPrompt)
                      end

                      crucifix2 = localPlayer.Character:FindFirstChild("Crucifix")
                        or tick() - v214 > 2
                    until crucifix2
                  end)

                  break
                end
              end
            end
          end
        end
      end

      if options.AutoInteractKeybind:GetState() and not toggles.AutoInteract.Value then
        toggles.AutoInteract:SetValue(true)
      end

      if not options.AutoInteractKeybind:GetState() and toggles.AutoInteract.Value then
        toggles.AutoInteract:SetValue(false)
      end

      if options.NoclipKeybind:GetState() and not toggles.NoClip.Value then
        toggles.NoClip:SetValue(true)
      end

      if not options.NoclipKeybind:GetState() and toggles.NoClip.Value then
        toggles.NoClip:SetValue(false)
      end

      if options.ThirdpersonKeybind:GetState() and not toggles.ThirdPerson.Value then
        toggles.ThirdPerson:SetValue(true)
      end

      if not options.ThirdpersonKeybind:GetState() and toggles.ThirdPerson.Value then
        toggles.ThirdPerson:SetValue(false)
      end

      if options.AntiCheatMan:GetState() and not toggles.AntiCheatMani.Value then
        toggles.AntiCheatMani:SetValue(true)
      end

      if not options.AntiCheatMan:GetState() and toggles.AntiCheatMani.Value then
        toggles.AntiCheatMani:SetValue(false)
      end

      if toggles.NoClip.Value then
        for index23, value205 in ipairs(localPlayer.Character:GetChildren()) do
          if value205:IsA("BasePart") and value205.Name ~= "CollisionClone"
            and value205.CanCollide then
            value205.CanCollide = false
          end
        end

        if localPlayer.Character:FindFirstChild("Collision") then
          localPlayer.Character.Collision.CanCollide = false

          if localPlayer.Character.Collision:FindFirstChild("CollisionCrouch") then
            localPlayer.Character.Collision.CollisionCrouch.CanCollide = false
          end
        end
      end

      if not toggles.NoClip.Value then
        for key86, value206 in pairs(localPlayer.Character:GetChildren()) do
          if value206.Name ~= "CollisionClone" and value206.Name ~= "Collision" then
            if value206:IsA("BasePart") and not value206.CanCollide then
              value206.CanCollide = true
            end
          end
        end

        if localPlayer.Character:FindFirstChild("Collision") then
          local collision3 = localPlayer.Character.Collision

          collision3.CanCollide = localPlayer.Character.Collision.CollisionGroup
                == "PlayerCrouching"
              and false
            or localPlayer.Character.Collision.CollisionGroup ~= "PlayerCrouching" and true

          if localPlayer.Character.Collision:FindFirstChild("CollisionCrouch") then
            localPlayer.Character.Collision.CollisionCrouch.CanCollide = localPlayer.Character.Collision.CanCollide
          end
        end
      end
    end))

    if v13 then
      v35 = nil

      v35 = hookmetamethod(game, "__namecall", function(p129, ...)
        if v2.Unloaded then
          return v35(p129, ...)
        else
          local v215 = getnamecallmethod()

          if v215 == "FireServer" or v215 == "InvokeServer" then
            if toggles.AutoHeartbeat.Value and p129.Name == "ClutchHeartbeat" then
              return v35(p129, true)
            end

            if v215 == "FireServer" and toggles.FigureHearing.Value and p129.Name == "Crouch" then
              return v35(p129, true, true)
            end

            return v35(p129, ...)
          end

          return v35(p129, ...)
        end
      end)
    end

    local descendantAdded2 = workspace.DescendantAdded

    table.insert(v4, descendantAdded2:Connect(function(p130)
      local total3 = 0
      local parent4

      repeat
        task.wait(0.03)
        total3 = total3 + 0.03
        parent4 = p130.Parent or total3 > 0.5
      until parent4

      local hitbox3

      if p130.Parent then
        if p130.Parent:FindFirstChildOfClass("Humanoid") then
          return
        end

        if p130.Name == "Candle" and p130.Parent.Name == "Candle"
          or p130.Parent.Parent and p130.Parent.Parent.Name == "Candle" then
          return
        end

        if HidingPlaces[p130.Name] then
          table.insert(Closets, p130)
        end

        if toggles.AntiLag.Value then
          if p130:IsA("BasePart") then
            p130:SetAttribute("Mat", p130.Material)
            p130.Material = "Plastic"
          end
        end

        if toggles.InfItems.Value and f9(p130) then
          table.insert(v27, p130)
        end

        if toggles.DeleteSeekFE.Value and p130.Name == "TriggerEventCollision" then
          f1("Deleting Seek", 3)

          if p130:FindFirstChild("Collision") or p130.ChildAdded:Wait() then
            f1("DONT OPEN NEXT DOOR", 1)
            task.wait(0.1)

            for key87, value207 in pairs(p130:GetChildren()) do
              if value207.Name == "Collision" and localPlayer.Character
                and localPlayer.Character:FindFirstChild("HumanoidRootPart") and v12 then
                firetouchinterest(localPlayer.Character.HumanoidRootPart, value207, 0)
                task.wait()
                firetouchinterest(localPlayer.Character.HumanoidRootPart, value207, 1)
              end
            end

            task.wait(0.5)
            local v216 = true

            for key88, value208 in pairs(p130:GetChildren()) do
              if value208.Name == "Collision" then
                v216 = false
                break
              end
            end

            if v216 then
              f1("Deleted Seek Successfully Open Next Door", 3)
            else
              f1("Failed To Delete Seek Open Next Door", 3)
            end
          end
        end

        if toggles.SeekObf.Value
          and (p130.Name == "Seek_Arm" or p130.Name == "ChandelierObstruction") then
          for key89, value209 in pairs(p130:GetChildren()) do
            if value209:IsA("BasePart") then
              value209.CanTouch = false
            end
          end
        end

        if toggles.AutoMinecart.Value then
          if p130.Name == "DuckBoard" then
            table.insert(v20, p130)
          end

          if string.find(p130.Name, "MinecartNode") then
            table.insert(v21, p130)
          end
        end

        if toggles.AntiSeekFlood.Value and p130.Name == "SeekFloodline" then
          p130.CanCollide = true
        end

        if toggles.ShowPath.Value and p130.Name == "SeekGuidingLight" then
          ShowSeekPath(p130)
        end

        if toggles.DeleteFigureFE.Value
          and (p130.Name == "FigureRig" or p130.Name == "FigureRagdoll") then
          table.insert(v19, p130)
        end

        if toggles.PromptClip.Value and p130:IsA("ProximityPrompt") then
          p130:SetAttribute("Clip", p130.RequiresLineOfSight)
          p130.RequiresLineOfSight = false
        end

        if toggles.AutoBreaker.Value and p130.Name == "ElevatorBreaker" then
          f8(p130)
        end

        if toggles.PromptReach.Value and p130:IsA("ProximityPrompt") then
          p130:SetAttribute("Range", p130.MaxActivationDistance)
          p130.MaxActivationDistance = p130.MaxActivationDistance * 2
        end

        if toggles.Snare.Value and p130.Name == "Snare" then
          local total4 = 0

          repeat
            task.wait(0.01)
            total4 = total4 + 0.01
            local v217 = total4 > 1

            hitbox3 = v217
            hitbox3 = v217 or p130:FindFirstChild("Hitbox")
          until hitbox3

          if p130:FindFirstChild("Hitbox") then
            p130.Hitbox.CanTouch = false
          end
        end

        if toggles.AntiLava.Value and p130.Name == "Lava" then
          p130.CanTouch = false
        end

        if toggles.AntiWall.Value and p130.Name == "ScaryWall" then
          for key90, value210 in pairs(p130:GetChildren()) do
            if value210:IsA("BasePart") then
              value210.CanTouch = false
            end
          end
        end

        if toggles.RealBridge.Value and p130.Name == "Bridge" and p130.CanCollide == false then
          p130.Transparency = 1
        end

        if toggles.Dupe.Value and p130.Name == "DoorFake" and p130.Parent.Name == "SideroomDupe" then
          p130:WaitForChild("Hidden", 9000000000).CanTouch = false
        end

        if toggles.FixBrokenBridge.Value and p130.Name == "Bridge" then
          FixBridge(p130)
        end

        if toggles.AutoAnchorSolver.Value and p130.Name == "MinesAnchor" then
          table.insert(v22, p130)
        end

        if toggles.GloomEggDamage.Value and p130.Name == "GloomEgg" then
          while true do
            task.wait()

            if p130:FindFirstChildWhichIsA("BasePart") then
              break
            end
          end

          for key91, value211 in pairs(p130:GetChildren()) do
            if value211:IsA("BasePart") then
              value211.CanTouch = false
            end
          end
        end

        if p130:IsA("ProximityPrompt") then
          if not (v25[p130.Name] or p130.Parent.Name == "Padlock"
              or p130.Parent:GetAttribute("JeffShop"))
            or p130.Parent.Parent.Name == "RetroWardrobe" then
            table.insert(Interactions, p130)
          end
        end

        if toggles.Giggle.Value and p130.Name == "GiggleCeiling" then
          while true do
            task.wait()

            if p130:FindFirstChild("Hitbox") then
              break
            end
          end

          p130.Hitbox.CanTouch = false
        end

        if p130:IsA("ProximityPrompt") and toggles.InstaInteract.Value then
          p130:SetAttribute("Duration", p130.HoldDuration)
          p130.HoldDuration = 0
        end

        return
      end
    end))

    local descendantRemoving = workspace.DescendantRemoving

    table.insert(v4, descendantRemoving:Connect(function(p131)
      for key92, value212 in pairs(v27) do
        if p131 == value212 then
          table.remove(v27, key92)
        end
      end
    end))

    task.spawn(function()
      local uiSettings2 = v17.Settings:AddLeftGroupbox("UI Settings")
      local hubUtilities2 = v17.Settings:AddRightGroupbox("Hub Utilities")

      uiSettings2:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
        Default = "RightShift",
        NoUI = true,
        Text = "Menu keybind",
      })

      v2.ToggleKeybind = options.MenuKeybind

      uiSettings2:AddToggle("ShowKeybinds", { Text = "Show Keybinds Overlay", Default = false }):OnChanged(function()
        v2.KeybindFrame.Visible = toggles.ShowKeybinds.Value
      end)

      uiSettings2:AddToggle("ShowCustomCursor", {
        Text = "Custom Cursor",
        Default = true,
        Callback = function(value213) v2.ShowCustomCursor = value213 end,
      })

      uiSettings2:AddDivider()

      uiSettings2:AddToggle("PlayNotifySound", {
        Text = "Play Notification Sound",
        Default = true,
        Callback = function(value214) v5 = value214 end,
      })

      uiSettings2:AddDropdown("NotificationSide", {
        Values = { "Left", "Right" },
        Default = "Right",
        Text = "Notification Side",
        Callback = function(value215) v2:SetNotifySide(value215) end,
      })

      uiSettings2:AddButton("Test Notification", function() f1("Hello World", 2) end)

      uiSettings2:AddDropdown("Library", {
        Values = { "Obsidian", "Linoria" },
        Default = getgenv().ScriptLibrary,
        Text = "Library",
        Callback = function(value216)
          getgenv().ScriptLibrary = tostring(value216)
          f1("Please Unload Script and Execute Again to Take Effect", 4)
        end,
      })

      uiSettings2:AddDropdown("RenderESPSpeed", {
        Values = { "10", "30", "60", "90", "120", "144", "240" },
        Default = v2.IsMobile and 2 or 6,
        Text = "ESP Rendering Speed",
        Callback = function(value217) espLibrary:SetRenderingSpeed(value217) end,
      })

      uiSettings2:AddDivider()

      uiSettings2:AddDropdown("DPIDropdown", {
        Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
        Default = "100%",
        Text = "DPI Scale",
        Callback = function(value218) v2:SetDPIScale(tonumber((value218:gsub("%%", "")))) end,
      })

      hubUtilities2:AddButton({
        Text = "Unload Hub",
        Func = function()
          localPlayer:SetAttribute("fazZzetaLoaded", nil)
          AlmaEnabled = false
          DronesEnabled = false
          BashEnabled = false
          ScribbleEnabled = false
          InfiniteCrucifixEnabled = false

          for key93, value219 in pairs(v4) do
          end

          if ESPHooks and ESPHooks.ClearAll then
            ESPHooks.ClearAll()
          end

          local dread4 = localPlayer:FindFirstChild("Dread", true)
            or localPlayer:FindFirstChild("_Dread", true)

          if dread4 then
            dread4.Name = "Dread"
          end

          local shade4 = modulesClient.EntityModules:FindFirstChild("Shade", true)
            or modulesClient.EntityModules:FindFirstChild("_Shade", true)

          if shade4 then
            shade4.Name = "Shade"
          end

          a90:Destroy()
          screech:Destroy()

          if replicatedStorage:FindFirstChild("Screech") then
            replicatedStorage:FindFirstChild("Screech").Parent = entityInfo
          end

          if v16 then
            for key94, value220 in pairs(v16(localPlayer.Idled)) do
              if value220.Enable then
                value220:Enable()
              end
            end
          end

          local freecamPart4 = workspace:FindFirstChild("FreecamPart")

          if freecamPart4 then
            freecamPart4:Destroy()
            local character4 = localPlayer.Character

            local humanoidRootPart4 = character4

            humanoidRootPart4 = character4
              and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart4 then
              humanoidRootPart4.Anchored = false
            end

            localPlayer.CameraMinZoomDistance = localPlayer:GetAttribute("fc_om") or 0.5
            localPlayer.CameraMaxZoomDistance = localPlayer:GetAttribute("fc_ox") or 128
          end

          if replicatedStorage:FindFirstChild("A90") then
            replicatedStorage:FindFirstChild("A90").Parent = entityInfo
          end

          for key95, value221 in pairs(workspace:GetDescendants()) do
            if value221:IsA("BasePart") then
              value221.CanTouch = true
            end

            if value221.Name == "BridgeBarrier" then
              value221:Destroy()
            end
          end

          if localPlayer.Character then
            localPlayer.Character.Humanoid.WalkSpeed = 16
            localPlayer.Character:SetAttribute("CanJump", false)

            for key96, value222 in pairs(localPlayer.Character:GetChildren()) do
              if not (value222.Name == "CollisionClone") and value222:IsA("BasePart") then
                value222.CanCollide = true
              end
            end

            if customPhysicalProperties then
              localPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = customPhysicalProperties
              customPhysicalProperties = nil
            end
          end

          for index24, value223 in ipairs(workspace:GetDescendants()) do
            if value223:IsA("ProximityPrompt") then
              value223.HoldDuration = value223:GetAttribute("Duration") or value223.HoldDuration
            end
          end

          if fogEnd then
            lighting.FogEnd = fogEnd
            fogEnd = nil
          end

          for key97, value224 in pairs(lighting:GetChildren()) do
            if value224:IsA("Atmosphere") then
              value224.Density = 0.94
            end
          end

          if localPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityMani") then
            localPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityMani"):Destroy()
          end

          lighting.Ambient = Color3.fromRGB(0, 0, 0)
          lighting.GlobalShadows = true

          for key98, value225 in pairs(workspace.CurrentRooms:GetChildren()) do
            value225:SetAttribute("Ambient", value225:GetAttribute("OldAmbient")
                and value225:GetAttribute("OldAmbient")
              or Color3.new(0, 0, 0))
          end

          task.wait()

          if entityInfo:FindFirstChild("A90_") then
            entityInfo:FindFirstChild("A90_").Name = "A90"
          end

          if entityInfo:FindFirstChild("Screech_") then
            local cutscenes4 = remoteListener:FindFirstChild("Cutscenes")

            local cutscenes5 = cutscenes4
            cutscenes5 = cutscenes4 or remoteListener:FindFirstChild("Cutscenes_")
            cutscenes5.Name = "Cutscenes"

            entityInfo:FindFirstChild("Screech_").Name = "Screech"
          end

          for key99, value226 in pairs(workspace:GetDescendants()) do
            if value226:IsA("ProximityPrompt") then
              value226.MaxActivationDistance = value226:GetAttribute("Range")
                or value226.MaxActivationDistance
            end

            if value226.Name == "SeekFloodline" then
              value226.CanCollide = false
            end
          end

          for key100, value227 in pairs(workspace.CurrentRooms:GetDescendants()) do
            if value227:IsA("ProximityPrompt") and value227:GetAttribute("InfItems") then
              f10(value227)
            end
          end

          for v218, v219 in workspace.CurrentRooms:GetDescendants() do
            if v219:IsA("BasePart") and v219:GetAttribute("Mat") then
              v219.Material = v219:GetAttribute("Mat") or "Plastic"
            end
          end

          if collisionClone then
            collisionClone:Destroy()
            collisionClone = nil
          end

          for key101, value228 in pairs(workspace:GetDescendants()) do
            if value228:IsA("ProximityPrompt") then
              value228.RequiresLineOfSight = value228:GetAttribute("Clip") or true
            end
          end

          if pathFolder then
            pathFolder:Destroy()
          end

          if localPlayer.Character then
            localPlayer.Character.Humanoid:MoveTo(localPlayer.Character.HumanoidRootPart.Position)
            localPlayer.Character.LowerTorso.Root.C1 = CFrame.new(Vector3.new(0, 0, 0))
          end

          if localPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity") then
            localPlayer.Character.HumanoidRootPart:FindFirstChild("FlightVelocity"):Destroy()
          end

          if entityInfo:FindFirstChild("Crouch") then
            entityInfo.Crouch:FireServer(false)
          end

          if localPlayer.Character then
            localPlayer.Character.Collision.Position = localPlayer.Character.HumanoidRootPart.Position
            localPlayer.Character.Humanoid.HipHeight = 2.4
          end

          if localPlayer.Character then
            for key102, value229 in pairs(localPlayer.Character:GetChildren()) do
              if value229.Name ~= "CollisionClone" and value229.Name ~= "Collision"
                and value229.Name ~= "HumanoidRootPart" and value229.Name ~= "CollisionPart" then
                if value229:IsA("BasePart") then
                  value229.Transparency = 0
                end
              end
            end
          end

          if replicatedStorage:FindFirstChild("LiveModifiers")
            and replicatedStorage:FindFirstChild("LiveModifiers"):FindFirstChild("Jammin") then
            local initiator3 = localPlayer.PlayerGui.MainUI.Initiator
            initiator3:FindFirstChild("Main_Game").Health.Jam.Playing = true
            soundService.Main.Jamming.Enabled = true
          end

          if v2.KeybindFrame then
            local position6 = v2.KeybindFrame.Position

            getgenv().FazZzetaDoors_KeybindPos = {
              position6.X.Scale, position6.X.Offset, position6.Y.Scale, position6.Y.Offset,
            }
          end

          v2:Unload()
          espLibrary:Unload()
          ShouldStop = true
        end,
      })
    end)

    local language2 = v17.Settings:AddLeftGroupbox("Language")

    language2:AddDropdown("LanguageSelect", {
      Text = "Select Language",
      Values = { "English", "Russian", "French", "German", "Chinese" },
      Default = 1,
      Multi = false,
      Callback = function(value230)
        CurrentLanguage = tostring(value230)
        task.defer(RefreshLanguageUI)
        f1("Language: " .. CurrentLanguage, 3)
      end,
    })

    language2:AddLabel("Items & Entities will be translated", true)
    language2:AddLabel("(BETA)", true)

    if v37 then
      v37:SetLibrary(v2)
      v37:SetFolder("fazZzetaDoors")
    end

    if v3 then
      v3:SetLibrary(v2)
      v3:IgnoreThemeSettings()
      v3:SetIgnoreIndexes({ "MenuKeybind" })
      v3:SetFolder("fazZzetaDoors/Config")
      v3:BuildConfigSection(v17.Settings)
    end

    if v37 then
      v37:ApplyToTab(v17.Settings)
    end

    f1("fazZzeta doors loaded | In-Game", 4)
  end

  return
end
