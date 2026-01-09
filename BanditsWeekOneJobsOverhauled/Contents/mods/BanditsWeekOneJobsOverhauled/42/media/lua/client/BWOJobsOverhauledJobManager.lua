BWOJobsOverhauled = BWOJobsOverhauled or {}
BWOJobsOverhauled.JobManager = BWOJobsOverhauled.JobManager or {}

local Manager = BWOJobsOverhauled.JobManager
if Manager._initialized then return end
Manager._initialized = true

Manager.JobDefinitions = Manager.JobDefinitions or {}
Manager.JobDefinitionById = Manager.JobDefinitionById or {}
Manager.TimedActionHandlers = Manager.TimedActionHandlers or {}
Manager.InventoryTransferHandlers = Manager.InventoryTransferHandlers or {}
Manager.FriendlyFireHandlers = Manager.FriendlyFireHandlers or {}
Manager.ExerciseHandlers = Manager.ExerciseHandlers or {}
Manager.WorkShiftConfigs = Manager.WorkShiftConfigs or {}
Manager.DailyTaskOffers = Manager.DailyTaskOffers or {}
Manager.DailyTaskOfferById = Manager.DailyTaskOfferById or {}

-- Job definition structure:
-- def = {
--   id = "string", -- required for assignments
--   text = "string", -- default job title
--   professions = { "professionId", ... } or "professionId",
--   autoAssign = true|false, -- default true
--   requiresTransactions = true|false,
--   disableWhenAnarchy = true|false,
--   minDay = number, -- optional inclusive
--   maxDay = number, -- optional inclusive
--   ai = { ... }, -- optional AI block
--   build = function(player, def) -> job
-- }
--
-- job = {
--   id = "string",
--   text = "string",
--   tasks = { task, ... },
--   ai = { ... }
-- }
--
-- task = {
--   id = "string",
--   text = "string",
--   pay = number|table|function, -- optional
--   payOnComplete = true|false, -- default true
--   autoComplete = true|false, -- optional helper flag
--   isDaily = true|false, -- default true
--   hidden = true|false, -- never shown in UI
--   hideOnComplete = true|false, -- optional UI helper
--   highlightSeconds = number, -- optional UI helper
--   ai = { ... }, -- optional AI block (see BWOJobsOverhauledAI.lua)
--   issueConditions = { condition, ... }, -- optional, evaluated once
--   conditions = { condition, ... }
-- }
--
-- condition = {
--   id = "string",
--   text = "string",
--   check = function(player, task, condition) -> boolean,
--   isLongTerm = true|false, -- UI hint for status-style conditions
--   hidden = true|false,
--   isPersistent = true|false, -- lock result (one-time condition)
--   persistOnSuccess = true|false, -- default true when persistent
--   persistOnFail = true|false, -- default false
--   getStatusText = function(player, task, condition) -> string
-- }

local function getDayStamp()
    local hours = getGameTime():getWorldAgeHours()
    return math.floor(hours / 24)
end

local function getNowSeconds()
    return getGameTime():getWorldAgeHours() * 3600
end

local function getBuildingDef(building)
    local conditions = BWOJobsOverhauled and BWOJobsOverhauled.Conditions
    if conditions and conditions.GetBuildingDef then
        return conditions.GetBuildingDef(building)
    end
    if not building then return nil end
    if building.getDef then
        return building:getDef()
    end
    return building
end

local function getBuildingCenter(def)
    local conditions = BWOJobsOverhauled and BWOJobsOverhauled.Conditions
    if conditions and conditions.GetBuildingCenter then
        return conditions.GetBuildingCenter(def)
    end
    if not def then return nil, nil end
    return (def:getX() + def:getX2()) / 2, (def:getY() + def:getY2()) / 2
end

local function getZoneLabelAt(x, y, z)
    local conditions = BWOJobsOverhauled and BWOJobsOverhauled.Conditions
    if conditions and conditions.GetZoneLabelAt then
        return conditions.GetZoneLabelAt(x, y, z)
    end
    local world = getWorld()
    local meta = world and world:getMetaGrid()
    if meta and meta.getZonesAt then
        local zones = meta:getZonesAt(x, y, z or 0)
        if zones then
            for i = 0, zones:size() - 1 do
                local zone = zones:get(i)
                local name = zone and zone.getName and zone:getName()
                if name and name ~= "" then
                    return name
                end
            end
            for i = 0, zones:size() - 1 do
                local zone = zones:get(i)
                local zoneType = zone and zone.getType and zone:getType()
                if zoneType and zoneType ~= "" and zoneType ~= "Nav" then
                    return zoneType
                end
            end
        end
    end

    local cell = getCell()
    if not cell then return nil end
    local square = cell:getGridSquare(x, y, z or 0)
    if not square then return nil end
    local zone = square:getZone()
    if not zone then return nil end
    local name = zone.getName and zone:getName()
    if name and name ~= "" then
        return name
    end
    local zoneType = zone.getType and zone:getType()
    if zoneType and zoneType ~= "" and zoneType ~= "Nav" then
        return zoneType
    end
    return nil
end

local function resolveTask(taskOrId, isDaily)
    if type(taskOrId) == "table" then
        return taskOrId.id, taskOrId.isDaily ~= false
    end
    return taskOrId, isDaily ~= false
end

local function getTaskStateTable(player, isDaily)
    local data = Manager.EnsureDailyData(player)
    if isDaily then
        data.taskState = data.taskState or {}
        return data.taskState
    end
    data.taskStatePersistent = data.taskStatePersistent or {}
    return data.taskStatePersistent
end

local function getTaskIssueTable(player, isDaily)
    local data = Manager.EnsureDailyData(player)
    if isDaily then
        data.taskIssueState = data.taskIssueState or {}
        return data.taskIssueState
    end
    data.taskIssueStatePersistent = data.taskIssueStatePersistent or {}
    return data.taskIssueStatePersistent
end

local function getConditionStateTable(player, isDaily)
    local data = Manager.EnsureDailyData(player)
    if isDaily then
        data.conditionState = data.conditionState or {}
        return data.conditionState
    end
    data.conditionStatePersistent = data.conditionStatePersistent or {}
    return data.conditionStatePersistent
end

local function getConditionState(player, task, condition)
    if not player or not task or not condition then return nil end
    local taskId = task.id or "__task"
    local conditionId = condition.id or "__condition"
    local _, daily = resolveTask(task)
    local tableRef = getConditionStateTable(player, daily)
    local taskTable = tableRef[taskId]
    if not taskTable then
        taskTable = {}
        tableRef[taskId] = taskTable
    end
    local state = taskTable[conditionId]
    if not state then
        state = {}
        taskTable[conditionId] = state
    end
    return state
end

local function safeCheck(condition, player, task)
    if not condition or type(condition.check) ~= "function" then
        return false
    end
    local ok, result = pcall(condition.check, player, task, condition)
    if not ok then
        if BWOJobsOverhauled and BWOJobsOverhauled.Log then
            BWOJobsOverhauled.Log("Condition check error: " .. tostring(result))
        end
        return false
    end
    return result == true
end

local function safeCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, result = pcall(fn, ...)
    if not ok then
        if BWOJobsOverhauled and BWOJobsOverhauled.Log then
            BWOJobsOverhauled.Log("Call error: " .. tostring(result))
        end
        return nil
    end
    return result
end

local function shallowCopy(source)
    local dest = {}
    for k, v in pairs(source or {}) do
        dest[k] = v
    end
    return dest
end

function Manager.EnsureDailyData(player)
    local md = player:getModData()
    md.BWOJobsOverhauled = md.BWOJobsOverhauled or {}
    local data = md.BWOJobsOverhauled
    local day = getDayStamp()
    if data.day ~= day then
        data.day = day
        data.trashPickups = 0
        data.trashEarnings = 0
        data.trashDumped = false
        data.lumberjackTheft = false
        data.fishermanTheft = false
        data.workOnDuty = false
        data.workShiftMinutes = 0
        data.workShiftLastUpdate = nil
        data.workShiftCompleted = false
        data.taskState = {}
        data.taskIssueState = {}
        data.conditionState = {}
        data.dailyOffers = {}
        data.dailyOffersRolled = false
        data.visitBuildings = {}
    end
    data.work = data.work or {}
    data.taskState = data.taskState or {}
    data.taskIssueState = data.taskIssueState or {}
    data.conditionState = data.conditionState or {}
    data.taskStatePersistent = data.taskStatePersistent or {}
    data.taskIssueStatePersistent = data.taskIssueStatePersistent or {}
    data.conditionStatePersistent = data.conditionStatePersistent or {}
    data.assignedJobs = data.assignedJobs or {}
    data.dailyOffers = data.dailyOffers or {}
    data.visitBuildings = data.visitBuildings or {}
    return data
end

function Manager.GetDailyTrashData(player)
    local data = Manager.EnsureDailyData(player)
    return data.trashPickups or 0, data.trashEarnings or 0
end

function Manager.GetProfessionName(player)
    if not player then return nil end
    local descriptor = player:getDescriptor()
    if not descriptor then return nil end
    if descriptor.isCharacterProfession and CharacterProfession then
        if descriptor:isCharacterProfession(CharacterProfession.FITNESS_INSTRUCTOR) then return "fitnessInstructor" end
        if descriptor:isCharacterProfession(CharacterProfession.POLICE_OFFICER) then return "policeofficer" end
        if descriptor:isCharacterProfession(CharacterProfession.FIRE_OFFICER) then return "fireofficer" end
        if descriptor:isCharacterProfession(CharacterProfession.DOCTOR) then return "doctor" end
        if descriptor:isCharacterProfession(CharacterProfession.NURSE) then return "nurse" end
        if descriptor:isCharacterProfession(CharacterProfession.PARK_RANGER) then return "parkranger" end
        if descriptor:isCharacterProfession(CharacterProfession.LUMBERJACK) then return "lumberjack" end
        if descriptor:isCharacterProfession(CharacterProfession.FISHERMAN) then return "fisherman" end
        if descriptor:isCharacterProfession(CharacterProfession.REPAIRMAN) then return "repairman" end
        if descriptor:isCharacterProfession(CharacterProfession.MECHANICS) then return "mechanics" end
        if descriptor:isCharacterProfession(CharacterProfession.ELECTRICIAN) then return "electrician" end
        if descriptor:isCharacterProfession(CharacterProfession.METALWORKER) then return "metalworker" end
        if descriptor:isCharacterProfession(CharacterProfession.CONSTRUCTION_WORKER) then return "constructionworker" end
        if descriptor:isCharacterProfession(CharacterProfession.SECURITY_GUARD) then return "securityguard" end
        if descriptor:isCharacterProfession(CharacterProfession.CHEF) then return "chef" end
        if descriptor:isCharacterProfession(CharacterProfession.BURGER_FLIPPER) then return "burgerflipper" end
        if descriptor:isCharacterProfession(CharacterProfession.FARMER) then return "farmer" end
        if descriptor:isCharacterProfession(CharacterProfession.CARPENTER) then return "carpenter" end
        if descriptor:isCharacterProfession(CharacterProfession.BURGLAR) then return "burglar" end
        if descriptor:isCharacterProfession(CharacterProfession.VETERAN) then return "veteran" end
        if descriptor:isCharacterProfession(CharacterProfession.UNEMPLOYED) then return "unemployed" end
    end

    local profession = descriptor.getCharacterProfession and descriptor:getCharacterProfession() or nil
    if profession and profession.getName then
        profession = profession:getName()
    end
    if not profession and descriptor.getProfession then
        profession = descriptor:getProfession()
    end
    if type(profession) == "string" then
        local norm = profession:lower():gsub("%s+", ""):gsub("_", "")
        local map = {
            fitnessinstructor = "fitnessInstructor",
            policeofficer = "policeofficer",
            fireofficer = "fireofficer",
            parkranger = "parkranger",
            securityguard = "securityguard",
        }
        if map[norm] then
            return map[norm]
        end
    end
    return profession
end

function Manager.AreTransactionsEnabled()
    return BWOScheduler and BWOScheduler.Anarchy and BWOScheduler.Anarchy.Transactions
end

function Manager.HasJobDefinition(id)
    if not id then return false end
    return Manager.JobDefinitionById[id] ~= nil
end

function Manager.RegisterJob(def)
    if type(def) == "function" then
        def = { build = def }
    end
    if type(def) ~= "table" then return end
    if def.id then
        if Manager.JobDefinitionById[def.id] then
            return
        end
        Manager.JobDefinitionById[def.id] = def
    else
        if BWOJobsOverhauled and BWOJobsOverhauled.Log then
            BWOJobsOverhauled.Log("Job definition missing id")
        end
    end
    table.insert(Manager.JobDefinitions, def)
end

function Manager.RegisterTimedActionHandler(handler)
    table.insert(Manager.TimedActionHandlers, handler)
end

function Manager.RegisterInventoryTransferHandler(handler)
    table.insert(Manager.InventoryTransferHandlers, handler)
end

function Manager.RegisterFriendlyFireHandler(handler)
    table.insert(Manager.FriendlyFireHandlers, handler)
end

function Manager.RegisterExerciseHandler(handler)
    table.insert(Manager.ExerciseHandlers, handler)
end

-- Work shift config:
-- config = { hours = number, pay = number, taskId = "string" }
function Manager.RegisterWorkShift(profession, config)
    if not profession or not config then return end
    Manager.WorkShiftConfigs[profession] = config
end

-- Daily task offer definition:
-- offer = {
--   id = "string",
--   tasks = { "taskId", ... }, -- optional, informational only
--   professions = { "professionId", ... } or "professionId",
--   chance = 0..1 or 0..100, -- default 1.0
--   minDay = number, -- optional inclusive
--   maxDay = number, -- optional inclusive
--   requiresTransactions = true|false,
--   disableWhenAnarchy = true|false,
--   condition = function(player, offer) -> boolean,
--   onAssign = function(player, offer) -> table|nil|false -- return nil/false to skip
-- }
function Manager.RegisterDailyTaskOffer(offer)
    if type(offer) ~= "table" or not offer.id then return end
    if Manager.DailyTaskOfferById[offer.id] then
        return
    end
    Manager.DailyTaskOfferById[offer.id] = offer
    table.insert(Manager.DailyTaskOffers, offer)
end

local function matchesProfession(player, professions)
    if not professions then return true end
    local profession = Manager.GetProfessionName(player)
    if type(professions) == "string" then
        return profession == professions
    end
    if type(professions) == "table" then
        for _, name in ipairs(professions) do
            if profession == name then
                return true
            end
        end
    end
    return false
end

local function isAnarchyActive()
    return BWOScheduler and BWOScheduler.Anarchy and BWOScheduler.Anarchy.Transactions == false
end

local function isOfferEligible(player, offer)
    if not matchesProfession(player, offer.professions) then
        return false
    end
    local day = getDayStamp()
    if offer.minDay and day < offer.minDay then
        return false
    end
    if offer.maxDay and day > offer.maxDay then
        return false
    end
    if offer.requiresTransactions and not Manager.AreTransactionsEnabled() then
        return false
    end
    if offer.disableWhenAnarchy and isAnarchyActive() then
        return false
    end
    if offer.condition and safeCall(offer.condition, player, offer) ~= true then
        return false
    end
    return true
end

local function rollChance(chance)
    local value = chance
    if value == nil then value = 1 end
    if value > 1 then
        value = value / 100
    end
    if value >= 1 then
        return true
    end
    local roll = ZombRand(10000) / 10000
    return roll <= value
end

function Manager.RollDailyOffers(player)
    if not player then return end
    local data = Manager.EnsureDailyData(player)
    if data.dailyOffersRolled then return end
    data.dailyOffers = data.dailyOffers or {}

    for _, offer in ipairs(Manager.DailyTaskOffers) do
        if offer and offer.id and isOfferEligible(player, offer) then
            if rollChance(offer.chance) then
                local entry = { active = true, assignedAt = getNowSeconds() }
                if type(offer.onAssign) == "function" then
                    local custom = safeCall(offer.onAssign, player, offer)
                    if custom == false or custom == nil then
                        entry = nil
                    elseif type(custom) == "table" then
                        entry.data = custom
                    else
                        entry.data = {}
                    end
                else
                    entry.data = {}
                end
                if entry then
                    data.dailyOffers[offer.id] = entry
                end
            end
        end
    end

    data.dailyOffersRolled = true
end

function Manager.GetDailyOffer(player, offerId)
    if not player or not offerId then return nil end
    local data = Manager.EnsureDailyData(player)
    if not data.dailyOffersRolled then
        Manager.RollDailyOffers(player)
    end
    return data.dailyOffers and data.dailyOffers[offerId] or nil
end

function Manager.IsDailyOfferActive(player, offerId)
    local offer = Manager.GetDailyOffer(player, offerId)
    return offer and offer.active == true or false
end

function Manager.AddVisitBuilding(player, building, opts)
    if not player or not building then return end
    local def = getBuildingDef(building)
    if not def or not def.getKeyId then return end
    local keyId = def:getKeyId()
    if not keyId then return end
    local data = Manager.EnsureDailyData(player)
    data.visitBuildings = data.visitBuildings or {}
    data.visitBuildings[keyId] = {
        allowTake = opts and opts.allowTake == true,
    }
end

function Manager.GetVisitPermission(building)
    if not building then return nil end
    local player = getSpecificPlayer(0)
    if not player then return nil end
    local def = getBuildingDef(building)
    if not def or not def.getKeyId then return nil end
    local keyId = def:getKeyId()
    if not keyId then return nil end
    local data = Manager.EnsureDailyData(player)
    if not data.visitBuildings then return nil end
    return data.visitBuildings[keyId]
end

function Manager.IsVisitBuilding(building)
    return Manager.GetVisitPermission(building) ~= nil
end

function Manager.GetWorkShiftConfig(profession)
    if not profession then return nil end
    return Manager.WorkShiftConfigs[profession]
end

function Manager.RequiresWorkLocation(profession)
    return Manager.GetWorkShiftConfig(profession) ~= nil
end

function Manager.GetWorkData(player)
    local data = Manager.EnsureDailyData(player)
    data.work = data.work or {}
    return data.work
end

function Manager.GetWorkBuildingName(player)
    local work = Manager.GetWorkData(player)
    local name = work.name or BWOJobsOverhauled.Text("UI_BWO_JobsOverhauled_Work_Unknown")
    if work.x and work.y then
        local zoneLabel = getZoneLabelAt(math.floor(work.x), math.floor(work.y), 0)
        if zoneLabel and zoneLabel ~= "" then
            return string.format("%s (%s)", name, zoneLabel)
        end
    end
    return name
end

function Manager.PlayerHasKeyId(player, keyId)
    if not player or not keyId then return false end
    local inventory = player:getInventory()
    if not inventory then return false end
    local items
    if inventory.getItems then
        items = inventory:getItems()
    end
    if (not items or not items.size or items:size() == 0) and inventory.getAllItems then
        local ok, res = pcall(inventory.getAllItems, inventory, true, true)
        if ok then
            items = res
        end
    end
    if not items then return false end
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item and item.getKeyId and item:getKeyId() == keyId then
            return true
        end
    end
    return false
end

function Manager.IssueWorkKey(player, work)
    if not player or not work or not work.keyId then return end
    if work.keyIssued then return end
    if Manager.PlayerHasKeyId(player, work.keyId) then
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
        if BWOJobsOverhauled and BWOJobsOverhauled.Log then
            BWOJobsOverhauled.Log("Unable to create work key item")
        end
        return
    end
    keyItem:setKeyId(work.keyId)
    keyItem:setName(BWOJobsOverhauled.Text("UI_BWO_JobsOverhauled_Work_Key"))
    player:getInventory():AddItem(keyItem)
    work.keyIssued = true
    if BWOJobsOverhauled and BWOJobsOverhauled.Log then
        BWOJobsOverhauled.Log("Work key issued for keyId " .. tostring(work.keyId))
    end
end

function Manager.IssueStarterGear(player)
    if not player then return end
    local md = player:getModData()
    md.BWOJobsOverhauled = md.BWOJobsOverhauled or {}
    local data = md.BWOJobsOverhauled
    data.gearIssued = data.gearIssued or {}

    local profession = Manager.GetProfessionName(player)
    if not profession or data.gearIssued[profession] then return end

    local function createItem(itemType)
        if BanditCompatibility and BanditCompatibility.InstanceItem then
            return BanditCompatibility.InstanceItem(itemType)
        end
        return InventoryItemFactory.CreateItem(itemType)
    end

    if profession == "lumberjack" then
        local options = { "Base.Axe", "Base.WoodAxe", "Base.HandAxe", "Base.Axe_Old" }
        local itemType = options[ZombRand(#options) + 1]
        local item = createItem(itemType)
        if item then
            local max = item:getConditionMax()
            local min = math.max(1, math.floor(max * 0.5))
            item:setCondition(ZombRand(min, max + 1))
            player:getInventory():AddItem(item)
            data.gearIssued[profession] = true
        end
    elseif profession == "fisherman" then
        local item = createItem("Base.FishingRod")
        if item then
            player:getInventory():AddItem(item)
            data.gearIssued[profession] = true
        end
    end
end

function Manager.IsOnDutyAs(player, profession)
    if not player then return false end
    local current = Manager.GetProfessionName(player)
    if current ~= profession then return false end
    if not Manager.RequiresWorkLocation(current) then
        return true
    end
    local data = Manager.EnsureDailyData(player)
    if data.workOnDuty == true then
        return true
    end
    return Manager.IsAtWork(player)
end

function Manager.IsAtWork(player)
    if not player then return false end
    local work = Manager.GetWorkData(player)
    if not work.keyId then return false end
    local building = player:getBuilding()
    if not building then return false end
    local buildingDef = building:getDef()
    if not buildingDef then return false end
    return buildingDef:getKeyId() == work.keyId
end

function Manager.GetWorkShiftMinutes(player)
    local data = Manager.EnsureDailyData(player)
    return data.workShiftMinutes or 0
end

function Manager.GetWorkShiftStatus(player)
    local minutes = Manager.GetWorkShiftMinutes(player)
    local hours = math.floor(minutes / 60)
    local mins = math.floor(minutes % 60)
    return string.format("%dh %dm", hours, mins)
end

function Manager.IsWorkShiftComplete(player)
    local profession = Manager.GetProfessionName(player)
    local config = Manager.GetWorkShiftConfig(profession)
    if not config then return false end
    local minutes = Manager.GetWorkShiftMinutes(player)
    return minutes >= (config.hours * 60)
end

function Manager.UpdateWorkDuty(player)
    if not player then return end
    local profession = Manager.GetProfessionName(player)
    local config = Manager.GetWorkShiftConfig(profession)
    if not config then return end
    local data = Manager.EnsureDailyData(player)
    if Manager.IsAtWork(player) then
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
        if Manager.IsWorkShiftComplete(player) then
            Manager.PayEarnings(player, config.pay)
            data.workShiftCompleted = true
            if config.taskId then
                Manager.MarkTaskComplete(player, config.taskId)
            end
            data.workShiftMinutes = 0
            data.workShiftLastUpdate = nil
        end
    else
        data.workShiftLastUpdate = nil
    end
end

function Manager.IsWorkBuilding(building)
    if not building then return false end
    local player = getSpecificPlayer(0)
    if not player then return false end
    local work = Manager.GetWorkData(player)
    local def = building:getDef()
    if not def then return false end
    local keyId = def:getKeyId()
    if work.keyId and keyId == work.keyId then
        return true
    end
    if work.x and work.y then
        local cx, cy = getBuildingCenter(def)
        if cx and cy then
            local dist = IsoUtils.DistanceTo(work.x, work.y, cx, cy)
            if dist < 1.0 then
                return true
            end
        end
    end
    if BWOBuildings and BWOBuildings.IsEventBuilding then
        return BWOBuildings.IsEventBuilding(building, "work")
    end
    return false
end

local function findMetaWorkBuilding(player, profession, maxDist, roomNames)
    local conditions = BWOJobsOverhauled and BWOJobsOverhauled.Conditions
    if not player or not conditions then return nil end
    if roomNames then
        return conditions.FindNearestBuildingByRoomNames(player, roomNames, maxDist)
    end
    return conditions.FindNearestBuildingByPredicate(player, function(roomDef)
        return conditions.RoomDefMatchesProfession and conditions.RoomDefMatchesProfession(roomDef, profession)
    end, maxDist)
end

function Manager.RegisterWorkBuilding(player, building, roomName)
    if not building then return end
    local work = Manager.GetWorkData(player)
    local def = getBuildingDef(building)
    if not def or not def.getKeyId then return end
    local newKeyId = def:getKeyId()
    if work.keyId ~= newKeyId then
        work.keyIssued = false
    end
    work.keyId = newKeyId
    work.x, work.y = getBuildingCenter(def)
    work.name = roomName or work.name
    work.assigned = true
    if player then
        if BWOJobsOverhauled and BWOJobsOverhauled.EnsureWorkMarker then
            BWOJobsOverhauled.EnsureWorkMarker(player)
        end
        if BWOJobsOverhauled and BWOJobsOverhauled.RequestWorldMapSymbol then
            BWOJobsOverhauled.RequestWorldMapSymbol(player)
        end
    end
    if player then
        local args = { id = work.keyId, event = "work", x = work.x, y = work.y }
        sendClientCommand(player, "Commands", "EventBuildingAdd", args)
        Manager.IssueWorkKey(player, work)
    end
end

function Manager.EnsureWorkLocation(player)
    if not player then return end
    local profession = Manager.GetProfessionName(player)
    if not Manager.RequiresWorkLocation(profession) then return end
    local work = Manager.GetWorkData(player)
    if work.keyId then
        return
    end
    local conditions = BWOJobsOverhauled and BWOJobsOverhauled.Conditions
    local building, roomName
    if conditions and conditions.FindNearestWorkBuilding and profession ~= "policeofficer" then
        building, roomName = conditions.FindNearestWorkBuilding(player, profession)
    end

    local function tryMeta(dist, names)
        if building then return end
        building, roomName = findMetaWorkBuilding(player, profession, dist, names)
    end

    if conditions then
        if profession == "policeofficer" then
            tryMeta(300, conditions.PoliceRoomNames)
            tryMeta(2000, conditions.PoliceRoomNames)
            tryMeta(300, conditions.MunicipalRoomNames)
            tryMeta(2000, conditions.MunicipalRoomNames)
            if not building and conditions.FindNearestWorkBuilding then
                building, roomName = conditions.FindNearestWorkBuilding(player, profession)
            end
            tryMeta(300)
            tryMeta(2000)
        elseif profession == "doctor" or profession == "nurse" then
            tryMeta(300)
            tryMeta(1200, conditions.MedicalRoomNames)
            tryMeta(2000, conditions.MedicalRoomNames)
            tryMeta(2000)
        elseif profession == "fitnessInstructor" then
            tryMeta(300)
            tryMeta(800, conditions.GymRoomNames)
            tryMeta(1500, conditions.GymRoomNames)
            tryMeta(1200, conditions.EntertainmentRoomNames)
            tryMeta(2000, conditions.EntertainmentRoomNames)
            tryMeta(1500, conditions.ResidentialRoomNames)
            tryMeta(2000)
        elseif profession == "securityguard" then
            tryMeta(300)
            tryMeta(800, conditions.SecurityRoomNames)
            tryMeta(1200, conditions.ArmoryRoomNames)
            tryMeta(1500, conditions.EntertainmentRoomNames)
            tryMeta(1500, conditions.RestaurantRoomNames)
            tryMeta(1500, conditions.CafeRoomNames)
            tryMeta(1500, conditions.BarRoomNames)
            tryMeta(2000, conditions.MunicipalRoomNames)
            tryMeta(2000)
        elseif profession == "chef" then
            tryMeta(300)
            tryMeta(800, conditions.RestaurantRoomNames)
            tryMeta(1200, conditions.CafeRoomNames)
            tryMeta(1500, conditions.BarRoomNames)
            tryMeta(2000)
        elseif profession == "burgerflipper" then
            tryMeta(300)
            tryMeta(800, conditions.FastFoodRoomNames)
            tryMeta(1200, conditions.RestaurantRoomNames)
            tryMeta(1500, conditions.BarRoomNames)
            tryMeta(2000)
        elseif profession == "lumberjack" then
            tryMeta(300)
            tryMeta(1200, conditions.LumberjackRoomNames)
            tryMeta(2000, conditions.LumberjackRoomNames)
            tryMeta(2000)
        elseif profession == "fisherman" then
            tryMeta(300)
            tryMeta(1200, conditions.FishermanRoomNames)
            tryMeta(2000, conditions.FishermanRoomNames)
            tryMeta(2000)
        else
            tryMeta(300)
            tryMeta(2000)
        end
    end

    if building then
        Manager.RegisterWorkBuilding(player, building, roomName)
        if BWOJobsOverhauled and BWOJobsOverhauled.Log then
            BWOJobsOverhauled.Log("Assigned work building for " .. tostring(profession))
        end
    else
        local home = player:getBuilding()
        if home then
            Manager.RegisterWorkBuilding(player, home, roomName or "Home")
            if BWOJobsOverhauled and BWOJobsOverhauled.Log then
                BWOJobsOverhauled.Log("No work building found for " .. tostring(profession) .. ", using home")
            end
        else
            if BWOJobsOverhauled and BWOJobsOverhauled.Log then
                BWOJobsOverhauled.Log("No work building found for " .. tostring(profession))
            end
        end
    end
end

function Manager.TryAssignWorkLocation()
    if BWOJobsOverhauled and BWOJobsOverhauled.IsWorldReady and not BWOJobsOverhauled.IsWorldReady() then
        return
    end
    local player = getSpecificPlayer(0)
    if not player then return end
    local profession = Manager.GetProfessionName(player)
    if not Manager.RequiresWorkLocation(profession) then
        if BWOJobsOverhauled then
            BWOJobsOverhauled.WorkAssignmentPending = false
        end
        Events.OnTick.Remove(Manager.TryAssignWorkLocation)
        return
    end
    local work = Manager.GetWorkData(player)
    if work.keyId then
        work.assigned = true
        if BWOJobsOverhauled then
            BWOJobsOverhauled.WorkAssignmentPending = false
        end
        Events.OnTick.Remove(Manager.TryAssignWorkLocation)
        return
    end
    if not getCell() then return end
    Manager.EnsureWorkLocation(player)
    if work.keyId then
        work.assigned = true
        if BWOJobsOverhauled then
            BWOJobsOverhauled.WorkAssignmentPending = false
        end
        Events.OnTick.Remove(Manager.TryAssignWorkLocation)
    end
end

function Manager.MarkTaskComplete(player, taskOrId, isDaily)
    if not player then return end
    local taskId, daily = resolveTask(taskOrId, isDaily)
    if not taskId then return end
    local tableRef = getTaskStateTable(player, daily)
    local state = tableRef[taskId] or {}
    state.completedAt = getNowSeconds()
    tableRef[taskId] = state
end

function Manager.MarkTaskFailed(player, taskOrId, isDaily)
    if not player then return end
    local taskId, daily = resolveTask(taskOrId, isDaily)
    if not taskId then return end
    local tableRef = getTaskStateTable(player, daily)
    local state = tableRef[taskId] or {}
    state.failedAt = getNowSeconds()
    tableRef[taskId] = state
end

function Manager.IsTaskFailed(player, taskOrId, isDaily)
    if not player then return false end
    local taskId, daily = resolveTask(taskOrId, isDaily)
    if not taskId then return false end
    local tableRef = getTaskStateTable(player, daily)
    local state = tableRef[taskId]
    return state and state.failedAt ~= nil
end

function Manager.IsTaskComplete(player, taskOrId, isDaily)
    if not player then return false end
    local taskId, daily = resolveTask(taskOrId, isDaily)
    if not taskId then return false end
    local tableRef = getTaskStateTable(player, daily)
    local state = tableRef[taskId]
    return state and state.completedAt ~= nil
end

function Manager.ShouldHideTask(player, taskOrId, delaySeconds)
    if not player then return false end
    local taskId, daily = resolveTask(taskOrId)
    if not taskId then return false end
    local tableRef = getTaskStateTable(player, daily)
    local state = tableRef[taskId]
    if not state or not state.completedAt then return false end
    local delay = delaySeconds or 5
    return (getNowSeconds() - state.completedAt) >= delay
end

function Manager.ShouldHighlightTask(player, taskOrId, delaySeconds)
    if not player then return false end
    local taskId, daily = resolveTask(taskOrId)
    if not taskId then return false end
    local tableRef = getTaskStateTable(player, daily)
    local state = tableRef[taskId]
    if not state or not state.completedAt then return false end
    local delay = delaySeconds or 5
    return (getNowSeconds() - state.completedAt) < delay
end

function Manager.IsTaskIssued(player, task)
    if not player or not task then return true end
    if not task.issueConditions or #task.issueConditions == 0 then
        return true
    end
    local _, daily = resolveTask(task)
    local tableRef = getTaskIssueTable(player, daily)
    local state = tableRef[task.id]
    if state and state.issued then
        return true
    end
    for _, condition in ipairs(task.issueConditions) do
        if not safeCheck(condition, player, task) then
            return false
        end
    end
    tableRef[task.id] = { issued = true, issuedAt = getNowSeconds() }
    return true
end

function Manager.EvaluateCondition(player, task, condition)
    if not condition or type(condition.check) ~= "function" then
        return false
    end
    if not condition.isPersistent then
        return safeCheck(condition, player, task)
    end

    local state = getConditionState(player, task, condition)
    if state and state.locked then
        return state.value == true
    end

    local ok, result = pcall(condition.check, player, task, condition)
    if not ok then
        if BWOJobsOverhauled and BWOJobsOverhauled.Log then
            BWOJobsOverhauled.Log("Condition check error: " .. tostring(result))
        end
        return false
    end

    local value = result == true
    local lockOnSuccess = condition.persistOnSuccess ~= false
    local lockOnFail = condition.persistOnFail == true
    if (value and lockOnSuccess) or ((not value) and lockOnFail) then
        state.locked = true
        state.value = value
        if value then
            state.completedAt = getNowSeconds()
        else
            state.failedAt = getNowSeconds()
        end
    end
    return value
end

function Manager.AreTaskConditionsMet(player, task)
    if not player or not task then return false end
    for _, condition in ipairs(task.conditions or {}) do
        if not Manager.EvaluateCondition(player, task, condition) then
            return false
        end
    end
    return true
end

function Manager.ResolveTaskPay(player, task)
    if not task then return nil end
    local pay = task.pay
    if type(pay) == "number" then
        return pay
    end
    if type(pay) == "function" then
        return pay(player, task)
    end
    if type(pay) == "table" then
        if pay.min and pay.max then
            return ZombRand(math.floor(pay.max - pay.min + 1)) + pay.min
        end
        if pay.amount then
            return pay.amount
        end
    end
    return nil
end

function Manager.PayEarnings(player, amount)
    if not Manager.AreTransactionsEnabled() then return end
    if not player or not amount or amount <= 0 then return end
    local ok = true
    BWOJobsOverhauled.AllowEarn = true
    if BWOPlayer and BWOPlayer.Earn then
        local status, err = pcall(BWOPlayer.Earn, player, amount)
        ok = status
        if not status then
            if BWOJobsOverhauled and BWOJobsOverhauled.Log then
                BWOJobsOverhauled.Log("Earning error: " .. tostring(err))
            end
        end
    end
    BWOJobsOverhauled.AllowEarn = false
    return ok
end

function Manager.PayTask(player, task)
    local amount = Manager.ResolveTaskPay(player, task)
    if amount and amount > 0 then
        return Manager.PayEarnings(player, amount)
    end
    return false
end

function Manager.TryCompleteTask(player, task)
    if not player or not task then return false end
    if Manager.IsTaskComplete(player, task) or Manager.IsTaskFailed(player, task) then
        return false
    end
    if not Manager.AreTaskConditionsMet(player, task) then
        return false
    end
    Manager.MarkTaskComplete(player, task)
    if task.payOnComplete ~= false then
        Manager.PayTask(player, task)
    end
    return true
end

local function filterConditions(player, task, conditions)
    local filtered = {}
    for _, condition in ipairs(conditions or {}) do
        if not condition.hidden then
            table.insert(filtered, shallowCopy(condition))
        end
    end
    return filtered
end

local function filterTasks(player, tasks)
    local filtered = {}
    for _, task in ipairs(tasks or {}) do
        if not task.hidden and Manager.IsTaskIssued(player, task) then
            local taskCopy = shallowCopy(task)
            taskCopy.isDaily = task.isDaily ~= false
            taskCopy.conditions = filterConditions(player, task, task.conditions or {})
            table.insert(filtered, taskCopy)
        end
    end
    return filtered
end

function Manager.GetJobs(player)
    local jobs = {}
    if not player then return jobs end

    local assignments = BWOJobsOverhauled.Assignments
    if assignments and assignments.EnsureAssignments then
        assignments.EnsureAssignments(player)
    end
    local allowed = assignments and assignments.GetAssignedJobSet and assignments.GetAssignedJobSet(player) or nil

    for _, def in ipairs(Manager.JobDefinitions) do
        if not allowed or allowed[def.id] then
            local job = def.build and def.build(player, def) or def.job
            if job then
                job.id = job.id or def.id
                job.text = job.text or def.text
                job.ai = job.ai or def.ai or {}
                job.tasks = filterTasks(player, job.tasks or {})
                table.insert(jobs, job)
            end
        end
    end
    return jobs
end

function Manager.HandleFriendlyFire(bandit, attacker)
    for _, handler in ipairs(Manager.FriendlyFireHandlers) do
        if handler(bandit, attacker) then
            return true
        end
    end
    return false
end

function Manager.HandleExercise(character, min)
    for _, handler in ipairs(Manager.ExerciseHandlers) do
        if handler(character, min) then
            return true
        end
    end
    return false
end

function Manager.HandleTimedAction(data)
    if not Manager.AreTransactionsEnabled() then return end
    for _, handler in ipairs(Manager.TimedActionHandlers) do
        if handler(data) then
            return
        end
    end
end

function Manager.HandleInventoryTransfer(data)
    if not Manager.AreTransactionsEnabled() then return end
    for _, handler in ipairs(Manager.InventoryTransferHandlers) do
        if handler(data) then
            return
        end
    end
end

BWOJobsOverhauled.RegisterJob = Manager.RegisterJob
BWOJobsOverhauled.RegisterTimedActionHandler = Manager.RegisterTimedActionHandler
BWOJobsOverhauled.RegisterInventoryTransferHandler = Manager.RegisterInventoryTransferHandler
BWOJobsOverhauled.RegisterFriendlyFireHandler = Manager.RegisterFriendlyFireHandler
BWOJobsOverhauled.RegisterExerciseHandler = Manager.RegisterExerciseHandler
BWOJobsOverhauled.RegisterWorkShift = Manager.RegisterWorkShift
BWOJobsOverhauled.GetWorkShiftConfig = Manager.GetWorkShiftConfig
BWOJobsOverhauled.RequiresWorkLocation = Manager.RequiresWorkLocation
BWOJobsOverhauled.GetWorkData = Manager.GetWorkData
BWOJobsOverhauled.GetWorkBuildingName = Manager.GetWorkBuildingName
BWOJobsOverhauled.PlayerHasKeyId = Manager.PlayerHasKeyId
BWOJobsOverhauled.IssueWorkKey = Manager.IssueWorkKey
BWOJobsOverhauled.IssueStarterGear = Manager.IssueStarterGear
BWOJobsOverhauled.IsOnDutyAs = Manager.IsOnDutyAs
BWOJobsOverhauled.IsAtWork = Manager.IsAtWork
BWOJobsOverhauled.GetWorkShiftMinutes = Manager.GetWorkShiftMinutes
BWOJobsOverhauled.GetWorkShiftStatus = Manager.GetWorkShiftStatus
BWOJobsOverhauled.IsWorkShiftComplete = Manager.IsWorkShiftComplete
BWOJobsOverhauled.UpdateWorkDuty = Manager.UpdateWorkDuty
BWOJobsOverhauled.IsWorkBuilding = Manager.IsWorkBuilding
BWOJobsOverhauled.RegisterWorkBuilding = Manager.RegisterWorkBuilding
BWOJobsOverhauled.EnsureWorkLocation = Manager.EnsureWorkLocation
BWOJobsOverhauled.TryAssignWorkLocation = Manager.TryAssignWorkLocation
BWOJobsOverhauled.GetJobs = Manager.GetJobs
BWOJobsOverhauled.EnsureDailyData = Manager.EnsureDailyData
BWOJobsOverhauled.GetDailyTrashData = Manager.GetDailyTrashData
BWOJobsOverhauled.GetProfessionName = Manager.GetProfessionName
BWOJobsOverhauled.AreTransactionsEnabled = Manager.AreTransactionsEnabled
BWOJobsOverhauled.MarkTaskComplete = Manager.MarkTaskComplete
BWOJobsOverhauled.MarkTaskFailed = Manager.MarkTaskFailed
BWOJobsOverhauled.IsTaskFailed = Manager.IsTaskFailed
BWOJobsOverhauled.IsTaskComplete = Manager.IsTaskComplete
BWOJobsOverhauled.ShouldHideTask = Manager.ShouldHideTask
BWOJobsOverhauled.ShouldHighlightTask = Manager.ShouldHighlightTask
BWOJobsOverhauled.EvaluateCondition = Manager.EvaluateCondition
BWOJobsOverhauled.HandleFriendlyFire = Manager.HandleFriendlyFire
BWOJobsOverhauled.HandleExercise = Manager.HandleExercise
BWOJobsOverhauled.HandleTimedAction = Manager.HandleTimedAction
BWOJobsOverhauled.HandleInventoryTransfer = Manager.HandleInventoryTransfer
BWOJobsOverhauled.PayEarnings = Manager.PayEarnings
BWOJobsOverhauled.PayTask = Manager.PayTask
BWOJobsOverhauled.TryCompleteTask = Manager.TryCompleteTask
BWOJobsOverhauled.RegisterDailyTaskOffer = Manager.RegisterDailyTaskOffer
BWOJobsOverhauled.RollDailyOffers = Manager.RollDailyOffers
BWOJobsOverhauled.GetDailyOffer = Manager.GetDailyOffer
BWOJobsOverhauled.IsDailyOfferActive = Manager.IsDailyOfferActive
BWOJobsOverhauled.AddVisitBuilding = Manager.AddVisitBuilding
BWOJobsOverhauled.GetVisitPermission = Manager.GetVisitPermission
BWOJobsOverhauled.IsVisitBuilding = Manager.IsVisitBuilding
