require "ISUI/ISButton"
require "ISUI/ISCollapsableWindow"
require "ISUI/BWOJobsOverhauledPanel"

BWOJobsOverhauled = BWOJobsOverhauled or {}
BWOJobsOverhauled.window = nil
BWOJobsOverhauled.button = nil
BWOJobsOverhauled.Debug = true
BWOJobsOverhauled.deferButton = false
BWOJobsOverhauled.JobBuilders = BWOJobsOverhauled.JobBuilders or {}
BWOJobsOverhauled.AllowEarn = false
BWOJobsOverhauled.TimedActionHandlers = BWOJobsOverhauled.TimedActionHandlers or {}
BWOJobsOverhauled.InventoryTransferHandlers = BWOJobsOverhauled.InventoryTransferHandlers or {}
BWOJobsOverhauled.FriendlyFireHandlers = BWOJobsOverhauled.FriendlyFireHandlers or {}
BWOJobsOverhauled.ExerciseHandlers = BWOJobsOverhauled.ExerciseHandlers or {}
BWOJobsOverhauled.WorkShiftConfigs = BWOJobsOverhauled.WorkShiftConfigs or {}

BWOJobsOverhauled.Text = function(key)
    return getTextOrNull(key) or getText(key)
end

BWOJobsOverhauled.Log = function(message)
    if not BWOJobsOverhauled.Debug then return end
    print("[BWOJobsOverhauled] " .. tostring(message))
end

local function getDayStamp()
    local hours = getGameTime():getWorldAgeHours()
    return math.floor(hours / 24)
end

local function getNowSeconds()
    return getGameTime():getWorldAgeHours() * 3600
end

BWOJobsOverhauled.EnsureDailyData = function(player)
    local md = player:getModData()
    md.BWOJobsOverhauled = md.BWOJobsOverhauled or {}
    local data = md.BWOJobsOverhauled
    local day = getDayStamp()
    if data.day ~= day then
        data.day = day
        data.trashPickups = 0
        data.trashEarnings = 0
        data.workOnDuty = false
        data.workShiftMinutes = 0
        data.workShiftLastUpdate = nil
        data.workShiftCompleted = false
        data.taskState = {}
    end
    data.work = data.work or {}
    data.taskState = data.taskState or {}
    return data
end

BWOJobsOverhauled.GetDailyTrashData = function(player)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    return data.trashPickups or 0, data.trashEarnings or 0
end

BWOJobsOverhauled.RegisterJob = function(builder)
    table.insert(BWOJobsOverhauled.JobBuilders, builder)
end

BWOJobsOverhauled.RegisterTimedActionHandler = function(handler)
    table.insert(BWOJobsOverhauled.TimedActionHandlers, handler)
end

BWOJobsOverhauled.RegisterInventoryTransferHandler = function(handler)
    table.insert(BWOJobsOverhauled.InventoryTransferHandlers, handler)
end

BWOJobsOverhauled.RegisterFriendlyFireHandler = function(handler)
    table.insert(BWOJobsOverhauled.FriendlyFireHandlers, handler)
end

BWOJobsOverhauled.RegisterExerciseHandler = function(handler)
    table.insert(BWOJobsOverhauled.ExerciseHandlers, handler)
end

BWOJobsOverhauled.RegisterWorkShift = function(profession, config)
    if not profession or not config then return end
    BWOJobsOverhauled.WorkShiftConfigs[profession] = config
end

BWOJobsOverhauled.GetWorkShiftConfig = function(profession)
    if not profession then return nil end
    return BWOJobsOverhauled.WorkShiftConfigs[profession]
end

function BWOJobsOverhauled.GetJobs(player)
    local jobs = {}
    if not player then return jobs end
    for _, builder in ipairs(BWOJobsOverhauled.JobBuilders) do
        local job = builder(player)
        if job then
            table.insert(jobs, job)
        end
    end
    return jobs
end

BWOJobsOverhauled.GetProfessionName = function(player)
    if not player then return nil end
    local descriptor = player:getDescriptor()
    if not descriptor then return nil end
    local profession = descriptor:getCharacterProfession()
    if profession and profession.getName then
        return profession:getName()
    end
    return profession
end

BWOJobsOverhauled.AreTransactionsEnabled = function()
    return BWOScheduler and BWOScheduler.Anarchy and BWOScheduler.Anarchy.Transactions
end

BWOJobsOverhauled.RequiresWorkLocation = function(profession)
    return BWOJobsOverhauled.GetWorkShiftConfig(profession) ~= nil
end

BWOJobsOverhauled.GetWorkData = function(player)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    data.work = data.work or {}
    return data.work
end

BWOJobsOverhauled.GetWorkBuildingName = function(player)
    local work = BWOJobsOverhauled.GetWorkData(player)
    return work.name
end

BWOJobsOverhauled.PlayerHasKeyId = function(player, keyId)
    if not player or not keyId then return false end
    local inventory = player:getInventory()
    if not inventory then return false end
    local items = inventory.getAllItems and inventory:getAllItems() or inventory:getItems()
    if not items then return false end
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item and item.getKeyId and item:getKeyId() == keyId then
            return true
        end
    end
    return false
end

BWOJobsOverhauled.IssueWorkKey = function(player, work)
    if not player or not work or not work.keyId then return end
    if work.keyIssued then return end
    if BWOJobsOverhauled.PlayerHasKeyId(player, work.keyId) then
        work.keyIssued = true
        return
    end
    local keyItem
    if BanditCompatibility and BanditCompatibility.InstanceItem then
        keyItem = BanditCompatibility.InstanceItem("Base.Key1")
    else
        keyItem = InventoryItemFactory.CreateItem("Base.Key1")
    end
    if not keyItem then
        BWOJobsOverhauled.Log("Unable to create work key item")
        return
    end
    keyItem:setKeyId(work.keyId)
    keyItem:setName(BWOJobsOverhauled.Text("UI_BWO_JobsOverhauled_Work_Key"))
    player:getInventory():AddItem(keyItem)
    work.keyIssued = true
    BWOJobsOverhauled.Log("Work key issued for keyId " .. tostring(work.keyId))
end

BWOJobsOverhauled.IsOnDutyAs = function(player, profession)
    if not player then return false end
    local current = BWOJobsOverhauled.GetProfessionName(player)
    if current ~= profession then return false end
    if not BWOJobsOverhauled.RequiresWorkLocation(current) then
        return true
    end
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    return data.workOnDuty == true
end

BWOJobsOverhauled.IsAtWork = function(player)
    if not player then return false end
    local work = BWOJobsOverhauled.GetWorkData(player)
    if not work.keyId then return false end
    local building = player:getBuilding()
    if not building then return false end
    local buildingDef = building:getDef()
    if not buildingDef then return false end
    return buildingDef:getKeyId() == work.keyId
end

BWOJobsOverhauled.GetWorkShiftMinutes = function(player)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    return data.workShiftMinutes or 0
end

BWOJobsOverhauled.GetWorkShiftStatus = function(player)
    local minutes = BWOJobsOverhauled.GetWorkShiftMinutes(player)
    local hours = math.floor(minutes / 60)
    local mins = math.floor(minutes % 60)
    return string.format("%dh %dm", hours, mins)
end

BWOJobsOverhauled.IsWorkShiftComplete = function(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    local config = BWOJobsOverhauled.GetWorkShiftConfig(profession)
    if not config then return false end
    local minutes = BWOJobsOverhauled.GetWorkShiftMinutes(player)
    return minutes >= (config.hours * 60)
end

BWOJobsOverhauled.MarkTaskComplete = function(player, taskId)
    if not player or not taskId then return end
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    data.taskState[taskId] = { completedAt = getNowSeconds() }
end

BWOJobsOverhauled.ShouldHideTask = function(player, taskId, delaySeconds)
    if not player or not taskId then return false end
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    local state = data.taskState[taskId]
    if not state or not state.completedAt then return false end
    local delay = delaySeconds or 5
    return (getNowSeconds() - state.completedAt) >= delay
end

BWOJobsOverhauled.ShouldHighlightTask = function(player, taskId, delaySeconds)
    if not player or not taskId then return false end
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    local state = data.taskState[taskId]
    if not state or not state.completedAt then return false end
    local delay = delaySeconds or 5
    return (getNowSeconds() - state.completedAt) < delay
end

BWOJobsOverhauled.IsWorkBuilding = function(building)
    if not building then return false end
    local player = getSpecificPlayer(0)
    if not player then return false end
    local work = BWOJobsOverhauled.GetWorkData(player)
    local def = building:getDef()
    if not def then return false end
    local keyId = def:getKeyId()
    if work.keyId and keyId == work.keyId then
        return true
    end
    if BWOBuildings and BWOBuildings.IsEventBuilding then
        return BWOBuildings.IsEventBuilding(building, "work")
    end
    return false
end

BWOJobsOverhauled.RoomMatchesProfession = function(room, profession)
    if not room or not profession then return false end
    if BWORooms and BWORooms.Get then
        local data = BWORooms.Get(room)
        if data and data.occupations then
            for _, occupation in pairs(data.occupations) do
                if occupation == profession then
                    return true
                end
            end
        end
    end
    if BWORooms and BWORooms.IsMedical and (profession == "doctor" or profession == "nurse") then
        return BWORooms.IsMedical(room)
    end
    return false
end

BWOJobsOverhauled.FindNearestWorkBuilding = function(player, profession)
    local cell = getCell()
    if not cell then return nil end
    local rooms = cell:getRoomList()
    if not rooms then return nil end
    local px, py = player:getX(), player:getY()
    local best
    local bestRoomName
    local bestDist
    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)
        if room and BWOJobsOverhauled.RoomMatchesProfession(room, profession) then
            local roomDef = room:getRoomDef()
            if roomDef then
                local cx = (roomDef:getX() + roomDef:getX2()) / 2
                local cy = (roomDef:getY() + roomDef:getY2()) / 2
                local dist = IsoUtils.DistanceTo(px, py, cx, cy)
                if not bestDist or dist < bestDist then
                    bestDist = dist
                    best = room:getBuilding()
                    if BWORooms and BWORooms.GetRealRoomName then
                        bestRoomName = BWORooms.GetRealRoomName(room)
                    else
                        bestRoomName = room:getName()
                    end
                end
            end
        end
    end
    return best, bestRoomName
end

BWOJobsOverhauled.EnsureWorkMarker = function(player)
    if not player then return end
    if not getCell() then return end
    if not SandboxVars or not SandboxVars.Bandits or not SandboxVars.Bandits.General_ArrivalIcon then return end
    if not BanditEventMarkerHandler then return end
    local work = BWOJobsOverhauled.GetWorkData(player)
    if not work or not work.keyId or not work.x or not work.y then return end
    local desc = BWOJobsOverhauled.Text("UI_BWO_JobsOverhauled_Work_Marker")
    local color = { r = 0.3, g = 0.8, b = 1.0 }
    local markerId = work.markerId or getRandomUUID()
    work.markerId = markerId
    BanditEventMarkerHandler.set(markerId, "media/ui/defend.png", 604800, work.x, work.y, color, desc)
end

BWOJobsOverhauled.RegisterWorkBuilding = function(player, building, roomName)
    if not building then return end
    local work = BWOJobsOverhauled.GetWorkData(player)
    local def = building:getDef()
    if not def then return end
    local newKeyId = def:getKeyId()
    if work.keyId ~= newKeyId then
        work.keyIssued = false
    end
    work.keyId = newKeyId
    work.x = (def:getX() + def:getX2()) / 2
    work.y = (def:getY() + def:getY2()) / 2
    work.name = roomName or work.name
    work.assigned = true
    if player then
        BWOJobsOverhauled.EnsureWorkMarker(player)
    end
    if player then
        local args = { id = work.keyId, event = "work", x = work.x, y = work.y }
        sendClientCommand(player, "Commands", "EventBuildingAdd", args)
        BWOJobsOverhauled.IssueWorkKey(player, work)
    end
end

BWOJobsOverhauled.EnsureWorkLocation = function(player)
    if not player then return end
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if not BWOJobsOverhauled.RequiresWorkLocation(profession) then return end
    local work = BWOJobsOverhauled.GetWorkData(player)
    if work.keyId then
        return
    end
    local building, roomName = BWOJobsOverhauled.FindNearestWorkBuilding(player, profession)
    if building then
        BWOJobsOverhauled.RegisterWorkBuilding(player, building, roomName)
        BWOJobsOverhauled.Log("Assigned work building for " .. tostring(profession))
    else
        BWOJobsOverhauled.Log("No work building found for " .. tostring(profession))
    end
end

BWOJobsOverhauled.TryAssignWorkLocation = function()
    local player = getSpecificPlayer(0)
    if not player then return end
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if not BWOJobsOverhauled.RequiresWorkLocation(profession) then
        BWOJobsOverhauled.WorkAssignmentPending = false
        Events.OnTick.Remove(BWOJobsOverhauled.TryAssignWorkLocation)
        return
    end
    local work = BWOJobsOverhauled.GetWorkData(player)
    if work.keyId then
        work.assigned = true
        BWOJobsOverhauled.WorkAssignmentPending = false
        Events.OnTick.Remove(BWOJobsOverhauled.TryAssignWorkLocation)
        return
    end
    if not getCell() then return end
    BWOJobsOverhauled.EnsureWorkLocation(player)
    if work.keyId then
        work.assigned = true
        BWOJobsOverhauled.WorkAssignmentPending = false
        Events.OnTick.Remove(BWOJobsOverhauled.TryAssignWorkLocation)
    end
end

BWOJobsOverhauled.UpdateWorkDuty = function(player)
    if not player then return end
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    local config = BWOJobsOverhauled.GetWorkShiftConfig(profession)
    if not config then return end
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    if BWOJobsOverhauled.IsAtWork(player) then
        if not data.workOnDuty then
            data.workOnDuty = true
        end
        if data.workShiftCompleted then
            data.workShiftLastUpdate = nil
            return
        end
        local now = getGameTime():getWorldAgeHours()
        if not data.workShiftLastUpdate then
            data.workShiftLastUpdate = now
        else
            local deltaMinutes = math.floor((now - data.workShiftLastUpdate) * 60)
            if deltaMinutes > 0 then
                data.workShiftMinutes = math.max((data.workShiftMinutes or 0) + deltaMinutes, 0)
                data.workShiftLastUpdate = now
            end
        end
        if BWOJobsOverhauled.IsWorkShiftComplete(player) then
            BWOJobsOverhauled.PayEarnings(player, config.pay)
            data.workShiftCompleted = true
            if config.taskId then
                BWOJobsOverhauled.MarkTaskComplete(player, config.taskId)
            end
            data.workShiftMinutes = 0
            data.workShiftLastUpdate = nil
        end
    else
        data.workShiftLastUpdate = nil
    end
end

BWOJobsOverhauled.PayEarnings = function(player, amount)
    if not BWOJobsOverhauled.AreTransactionsEnabled() then return end
    if not player or amount <= 0 then return end
    local ok = true
    BWOJobsOverhauled.AllowEarn = true
    if BWOPlayer and BWOPlayer.Earn then
        local status, err = pcall(BWOPlayer.Earn, player, amount)
        ok = status
        if not status then
            BWOJobsOverhauled.Log("Earning error: " .. tostring(err))
        end
    end
    BWOJobsOverhauled.AllowEarn = false
    return ok
end

BWOJobsOverhauled.HasNearbyFire = function(player)
    local cell = getCell()
    if not cell then return false end
    local px = math.floor(player:getX())
    local py = math.floor(player:getY())
    local pz = math.floor(player:getZ())
    for dx = -1, 1 do
        for dy = -1, 1 do
            local square = cell:getGridSquare(px + dx, py + dy, pz)
            if square then
                local objects = square:getObjects()
                for i = 0, objects:size() - 1 do
                    local object = objects:get(i)
                    if instanceof(object, "IsoFire") and not object:isPermanent() then
                        return true
                    end
                end
            end
        end
    end
    return false
end

BWOJobsOverhauled.HasNearbyVehicle = function(player)
    local cell = getCell()
    if not cell then return false end
    local px = math.floor(player:getX())
    local py = math.floor(player:getY())
    local pz = math.floor(player:getZ())
    for dx = -1, 1 do
        for dy = -1, 1 do
            local square = cell:getGridSquare(px + dx, py + dy, pz)
            if square and square:getVehicleContainer() then
                return true
            end
        end
    end
    return false
end

BWOJobsOverhauled.IsInForestZone = function(player)
    local square = player:getSquare()
    if not square then return false end
    local zone = square:getZone()
    if not zone then return false end
    local zoneType = zone:getType()
    return zoneType == "Forest" or zoneType == "DeepForest"
end

BWOJobsOverhauled.HasAnyItemTypes = function(player, itemTypes)
    local inventory = player:getInventory()
    for _, itemType in ipairs(itemTypes) do
        if inventory:containsTypeRecurse(itemType) then
            return true
        end
    end
    return false
end

BWOJobsOverhauled.HasHostileBanditNearby = function(player)
    if not BanditZombie or not BanditZombie.GetAllB then return false end
    local bandits = BanditZombie.GetAllB()
    local px = player:getX()
    local py = player:getY()
    for _, bandit in pairs(bandits) do
        local brain = bandit.brain
        if brain and (brain.hostile or (brain.program and brain.program.name == "Vandal")) then
            if math.abs(bandit.x - px) < 20 or math.abs(bandit.y - py) < 20 then
                local dist = IsoUtils.DistanceTo(px, py, bandit.x, bandit.y)
                if dist <= 20 then
                    return true
                end
            end
        end
    end
    return false
end

function BWOJobsOverhauled.TogglePanel()
    BWOJobsOverhauled.Log("TogglePanel called")
    if type(BWOJobsOverhauledPanel) ~= "table" or type(BWOJobsOverhauledPanel.new) ~= "function" then
        local ok, err = pcall(require, "ISUI/BWOJobsOverhauledPanel")
        if not ok then
            BWOJobsOverhauled.Log("Failed to load panel: " .. tostring(err))
            return
        end
    end
    if type(BWOJobsOverhauledPanel) ~= "table" or type(BWOJobsOverhauledPanel.new) ~= "function" then
        BWOJobsOverhauled.Log("Panel class not available; cannot open window")
        return
    end
    if BWOJobsOverhauled.window then
        local visible = not BWOJobsOverhauled.window:getIsVisible()
        BWOJobsOverhauled.window:setVisible(visible)
        if visible then
            BWOJobsOverhauled.window:refreshList()
            BWOJobsOverhauled.window:bringToTop()
        end
        return
    end

    local playerNum = 0
    local x = getPlayerScreenLeft(playerNum) + 200
    local y = getPlayerScreenTop(playerNum) + 100

    local window = BWOJobsOverhauledPanel:new(x, y, 460, 420, playerNum)
    window:initialise()
    window:addToUIManager()
    window:refreshList()
    ISLayoutManager.RegisterWindow('bwojobsoverhauled', ISCollapsableWindow, window)

    BWOJobsOverhauled.window = window
    BWOJobsOverhauled.Log("Jobs panel created")
end

function BWOJobsOverhauled.UpdateButtonPosition()
    if not BWOJobsOverhauled.button then return end
    local playerNum = 0
    local x = getPlayerScreenLeft(playerNum) + 90
    local y = getPlayerScreenTop(playerNum) + 200
    BWOJobsOverhauled.button:setX(x)
    BWOJobsOverhauled.button:setY(y)
    BWOJobsOverhauled.Log("Updated button position to x=" .. tostring(x) .. " y=" .. tostring(y))
end

function BWOJobsOverhauled.CreateButton()
    if BWOJobsOverhauled.button then return end
    if type(ISButton) ~= "table" or type(ISButton.new) ~= "function" then
        BWOJobsOverhauled.Log("ISButton not ready; deferring button creation")
        if not BWOJobsOverhauled.deferButton then
            BWOJobsOverhauled.deferButton = true
            Events.OnTick.Add(BWOJobsOverhauled.CreateButton)
        end
        return
    end

    local playerNum = 0
    local x = getPlayerScreenLeft(playerNum) + 90
    local y = getPlayerScreenTop(playerNum) + 200
    local size = 36

    local label = BWOJobsOverhauled.Text("UI_BWO_JobsOverhauled_Button")
    if type(label) ~= "string" then
        BWOJobsOverhauled.Log("Button label is not a string, got " .. tostring(type(label)))
        label = tostring(label)
    end

    local ok, button = pcall(ISButton.new, ISButton, x, y, size, size, label, BWOJobsOverhauled, BWOJobsOverhauled.TogglePanel)
    if not ok then
        BWOJobsOverhauled.Log("Failed to create button: " .. tostring(button))
        return
    end
    button:initialise()
    button:setAnchorLeft(true)
    button:setAnchorTop(true)
    button.borderColor = { r = 1, g = 1, b = 1, a = 0.2 }
    button.backgroundColor = { r = 0, g = 0, b = 0, a = 0.4 }
    button:addToUIManager()
    BWOJobsOverhauled.button = button
    BWOJobsOverhauled.Log("Jobs button created")

    if BWOJobsOverhauled.deferButton then
        BWOJobsOverhauled.deferButton = false
        Events.OnTick.Remove(BWOJobsOverhauled.CreateButton)
        BWOJobsOverhauled.Log("Deferred button creation resolved")
    end
end

local function onKeyPressed(key)
    local options = PZAPI.ModOptions:getOptions("BanditsWeekOneJobsOverhauled")
    local option = options and options:getOption("TOGGLE_PANEL")
    if not option then
        BWOJobsOverhauled.Log("Keybind option not available yet")
        return
    end
    if option and key == option.key then
        BWOJobsOverhauled.Log("Toggle panel keybind pressed")
        BWOJobsOverhauled.TogglePanel()
    end
end

local function patchBWOPlayerEarnings()
    if not BWOPlayer or BWOJobsOverhauled.PatchedBWOPlayer then return end
    BWOJobsOverhauled.OriginalEarn = BWOJobsOverhauled.OriginalEarn or BWOPlayer.Earn
    BWOPlayer.Earn = function(character, cnt)
        if instanceof(character, "IsoPlayer") and not character:isNPC() then
            if not BWOJobsOverhauled.AllowEarn then
                return
            end
        end
        if BWOJobsOverhauled.OriginalEarn then
            return BWOJobsOverhauled.OriginalEarn(character, cnt)
        end
    end

    BWOJobsOverhauled.OriginalCheckFriendlyFire = BWOJobsOverhauled.OriginalCheckFriendlyFire or BWOPlayer.CheckFriendlyFire
    BWOPlayer.CheckFriendlyFire = function(bandit, attacker)
        BWOJobsOverhauled.HandleFriendlyFire(bandit, attacker)
        if BWOJobsOverhauled.OriginalCheckFriendlyFire then
            return BWOJobsOverhauled.OriginalCheckFriendlyFire(bandit, attacker)
        end
    end

    BWOJobsOverhauled.OriginalActivateExcercise = BWOJobsOverhauled.OriginalActivateExcercise or BWOPlayer.ActivateExcercise
    BWOPlayer.ActivateExcercise = function(character, min)
        if BWOJobsOverhauled.HandleExercise(character, min) then
            return
        end
        if BWOJobsOverhauled.OriginalActivateExcercise then
            return BWOJobsOverhauled.OriginalActivateExcercise(character, min)
        end
    end

    BWOJobsOverhauled.PatchedBWOPlayer = true
end

local function patchBWORooms()
    if not BWORooms or BWOJobsOverhauled.PatchedBWORooms then return end
    if BWORooms.IsIntrusion then
        BWOJobsOverhauled.OriginalIsIntrusion = BWOJobsOverhauled.OriginalIsIntrusion or BWORooms.IsIntrusion
        BWORooms.IsIntrusion = function(room)
            if room then
                local building = room:getBuilding()
                if building and BWOJobsOverhauled.IsWorkBuilding(building) then
                    return false
                end
            end
            if BWOJobsOverhauled.OriginalIsIntrusion then
                return BWOJobsOverhauled.OriginalIsIntrusion(room)
            end
            return false
        end
    end

    if BWORooms.TakeIntention then
        BWOJobsOverhauled.OriginalTakeIntention = BWOJobsOverhauled.OriginalTakeIntention or BWORooms.TakeIntention
        BWORooms.TakeIntention = function(room, customName)
            if room then
                local building = room:getBuilding()
                if building and BWOJobsOverhauled.IsWorkBuilding(building) then
                    return true, false
                end
            end
            if BWOJobsOverhauled.OriginalTakeIntention then
                return BWOJobsOverhauled.OriginalTakeIntention(room, customName)
            end
            return false, false
        end
    end

    BWOJobsOverhauled.PatchedBWORooms = true
end

function BWOJobsOverhauled.HandleFriendlyFire(bandit, attacker)
    for _, handler in ipairs(BWOJobsOverhauled.FriendlyFireHandlers) do
        if handler(bandit, attacker) then
            return true
        end
    end
    return false
end

function BWOJobsOverhauled.HandleExercise(character, min)
    for _, handler in ipairs(BWOJobsOverhauled.ExerciseHandlers) do
        if handler(character, min) then
            return true
        end
    end
    return false
end

local function onTimedActionPerform(data)
    if not BWOJobsOverhauled.AreTransactionsEnabled() then return end
    for _, handler in ipairs(BWOJobsOverhauled.TimedActionHandlers) do
        if handler(data) then
            return
        end
    end
end

local function onInventoryTransferAction(data)
    if not BWOJobsOverhauled.AreTransactionsEnabled() then return end
    for _, handler in ipairs(BWOJobsOverhauled.InventoryTransferHandlers) do
        if handler(data) then
            return
        end
    end
end

local function onEveryOneMinute()
    local player = getSpecificPlayer(0)
    if not player then return end
    if BWOJobsOverhauled.AreTransactionsEnabled() then
        BWOJobsOverhauled.UpdateWorkDuty(player)
    end
end

local function onGameStart()
    BWOJobsOverhauled.Log("OnGameStart triggered")
    patchBWOPlayerEarnings()
    patchBWORooms()
    BWOJobsOverhauled.CreateButton()
    BWOJobsOverhauled.UpdateButtonPosition()
    local player = getSpecificPlayer(0)
    if player then
        BWOJobsOverhauled.IssueWorkKey(player, BWOJobsOverhauled.GetWorkData(player))
        BWOJobsOverhauled.EnsureWorkMarker(player)
        local profession = BWOJobsOverhauled.GetProfessionName(player)
        local work = BWOJobsOverhauled.GetWorkData(player)
        if BWOJobsOverhauled.RequiresWorkLocation(profession) and not work.assigned and not work.keyId then
            if not BWOJobsOverhauled.WorkAssignmentPending then
                BWOJobsOverhauled.WorkAssignmentPending = true
                Events.OnTick.Add(BWOJobsOverhauled.TryAssignWorkLocation)
            end
        end
    end
end

Events.OnGameStart.Add(onGameStart)
Events.OnResolutionChange.Add(BWOJobsOverhauled.UpdateButtonPosition)
Events.OnTimedActionPerform.Add(onTimedActionPerform)
Events.OnInventoryTransferActionPerform.Add(onInventoryTransferAction)
Events.EveryOneMinute.Add(onEveryOneMinute)
if Events and Events.OnKeyPressed and Events.OnKeyPressed.Add then
    Events.OnKeyPressed.Add(onKeyPressed)
else
    BWOJobsOverhauled.Log("Events.OnKeyPressed not available; skipping keybind hook")
end

require "BWOJobsOverhauledJobs/CleaningJob"
require "BWOJobsOverhauledJobs/FireJob"
require "BWOJobsOverhauledJobs/MechanicJob"
require "BWOJobsOverhauledJobs/ParkRangerJob"
require "BWOJobsOverhauledJobs/FitnessJob"
require "BWOJobsOverhauledJobs/LumberjackJob"
require "BWOJobsOverhauledJobs/FishermanJob"
require "BWOJobsOverhauledJobs/PoliceJob"
require "BWOJobsOverhauledJobs/MedicalJob"
