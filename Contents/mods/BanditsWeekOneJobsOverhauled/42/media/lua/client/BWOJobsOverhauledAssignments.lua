BWOJobsOverhauled = BWOJobsOverhauled or {}
BWOJobsOverhauled.Assignments = BWOJobsOverhauled.Assignments or {}

local Assign = BWOJobsOverhauled.Assignments
local Conditions = BWOJobsOverhauled.Conditions

Assign.WorkShiftConfigs = Assign.WorkShiftConfigs or {}
Assign.GameStartPending = Assign.GameStartPending or false
Assign.GameStartApplied = Assign.GameStartApplied or false
Assign.LastPlayer = Assign.LastPlayer or nil
Assign.WorldMapSymbolPending = Assign.WorldMapSymbolPending or false
Assign.WorkMarkerPending = Assign.WorkMarkerPending or false
Assign.WorkAssignmentPending = Assign.WorkAssignmentPending or false

local function getWorldAgeDays()
    local hours = getGameTime():getWorldAgeHours()
    return math.floor(hours / 24)
end

local function getZoneLabelAt(x, y, z)
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

function Assign.GetProfessionName(player)
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

function Assign.RegisterWorkShift(profession, config)
    if not profession or not config then return end
    Assign.WorkShiftConfigs[profession] = config
end

function Assign.GetWorkShiftConfig(profession)
    if not profession then return nil end
    return Assign.WorkShiftConfigs[profession]
end

function Assign.RequiresWorkLocation(profession)
    return Assign.GetWorkShiftConfig(profession) ~= nil
end

function Assign.GetWorkData(player)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    data.work = data.work or {}
    return data.work
end

function Assign.GetWorkBuildingName(player)
    local work = Assign.GetWorkData(player)
    local name = work.name or BWOJobsOverhauled.Text("UI_BWO_JobsOverhauled_Work_Unknown")
    if work.x and work.y then
        local zoneLabel = getZoneLabelAt(math.floor(work.x), math.floor(work.y), 0)
        if zoneLabel and zoneLabel ~= "" then
            return string.format("%s (%s)", name, zoneLabel)
        end
    end
    return name
end

function Assign.PlayerHasKeyId(player, keyId)
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

function Assign.IssueWorkKey(player, work)
    if not player or not work or not work.keyId then return end
    if work.keyIssued then return end
    if Assign.PlayerHasKeyId(player, work.keyId) then
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

function Assign.IssueStarterGear(player)
    if not player then return end
    local md = player:getModData()
    md.BWOJobsOverhauled = md.BWOJobsOverhauled or {}
    local data = md.BWOJobsOverhauled
    data.gearIssued = data.gearIssued or {}

    local profession = Assign.GetProfessionName(player)
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

function Assign.IsOnDutyAs(player, profession)
    if not player then return false end
    local current = Assign.GetProfessionName(player)
    if current ~= profession then return false end
    if not Assign.RequiresWorkLocation(current) then
        return true
    end
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    if data.workOnDuty == true then
        return true
    end
    return Assign.IsAtWork(player)
end

function Assign.IsAtWork(player)
    if not player then return false end
    local work = Assign.GetWorkData(player)
    if not work.keyId then return false end
    local building = player:getBuilding()
    if not building then return false end
    local buildingDef = building:getDef()
    if not buildingDef then return false end
    return buildingDef:getKeyId() == work.keyId
end

function Assign.GetWorkShiftMinutes(player)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    return data.workShiftMinutes or 0
end

function Assign.GetWorkShiftStatus(player)
    local minutes = Assign.GetWorkShiftMinutes(player)
    local hours = math.floor(minutes / 60)
    local mins = math.floor(minutes % 60)
    return string.format("%dh %dm", hours, mins)
end

function Assign.IsWorkShiftComplete(player)
    local profession = Assign.GetProfessionName(player)
    local config = Assign.GetWorkShiftConfig(profession)
    if not config then return false end
    local minutes = Assign.GetWorkShiftMinutes(player)
    return minutes >= (config.hours * 60)
end

function Assign.IsWorkBuilding(building)
    if not building then return false end
    local player = getSpecificPlayer(0)
    if not player then return false end
    local work = Assign.GetWorkData(player)
    local def = building:getDef()
    if not def then return false end
    local keyId = def:getKeyId()
    if work.keyId and keyId == work.keyId then
        return true
    end
    if work.x and work.y then
        local cx, cy = Conditions.GetBuildingCenter(def)
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

function Assign.RoomMatchesProfession(room, profession)
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

function Assign.RoomDefMatchesProfession(roomDef, profession)
    if not roomDef or not profession or not BWORooms or not BWORooms.tab then return false end
    local data = BWORooms.tab[roomDef:getName()]
    if data and data.occupations then
        for _, occupation in pairs(data.occupations) do
            if occupation == profession then
                return true
            end
        end
    end
    if BWORooms.IsMedical and (profession == "doctor" or profession == "nurse") then
        return data and data.isMedical == true
    end
    return false
end
