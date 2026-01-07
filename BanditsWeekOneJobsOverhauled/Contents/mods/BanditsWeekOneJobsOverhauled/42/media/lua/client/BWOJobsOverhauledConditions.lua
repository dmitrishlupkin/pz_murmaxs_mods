BWOJobsOverhauled = BWOJobsOverhauled or {}
BWOJobsOverhauled.Conditions = BWOJobsOverhauled.Conditions or {}

local Conditions = BWOJobsOverhauled.Conditions
if Conditions._initialized then return end
Conditions._initialized = true

local function getBuildingDef(building)
    if not building then return nil end
    if building.getDef then
        return building:getDef()
    end
    return building
end

local function getBuildingCenter(def)
    if not def then return nil, nil end
    return (def:getX() + def:getX2()) / 2, (def:getY() + def:getY2()) / 2
end

local function getContainerSquare(container)
    if not container then return nil end
    if container.getSquare then
        local square = container:getSquare()
        if square then return square end
    end
    if container.getParent then
        local parent = container:getParent()
        if parent and parent.getSquare then
            return parent:getSquare()
        end
    end
    return nil
end

local function buildNameSet(names)
    if not names then return nil end
    local set = {}
    for _, name in ipairs(names) do
        set[name] = true
    end
    return set
end

local function getFlagTable(player, isDaily)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    if isDaily then
        data.flags = data.flags or {}
        return data.flags
    end
    data.flagsPersistent = data.flagsPersistent or {}
    return data.flagsPersistent
end

function Conditions.GetBuildingDef(building)
    return getBuildingDef(building)
end

function Conditions.GetBuildingCenter(def)
    return getBuildingCenter(def)
end

function Conditions.GetContainerSquare(container)
    return getContainerSquare(container)
end

function Conditions.IsWithinHours(startHour, endHour, nowHour)
    local hour = nowHour
    if hour == nil then
        hour = getGameTime():getHour()
    end
    if startHour <= endHour then
        return hour >= startHour and hour < endHour
    end
    return hour >= startHour or hour < endHour
end

function Conditions.HasElapsedHoursSince(startHours, durationHours)
    if startHours == nil or durationHours == nil then return false end
    local now = getGameTime():getWorldAgeHours()
    return (now - startHours) >= durationHours
end

function Conditions.HasElapsedMinutesSince(startHours, durationMinutes)
    if startHours == nil or durationMinutes == nil then return false end
    local now = getGameTime():getWorldAgeHours()
    return ((now - startHours) * 60) >= durationMinutes
end

function Conditions.FindNearestBuildingByPredicate(player, predicate, maxDist)
    if not player or type(predicate) ~= "function" then return nil end
    local meta = getWorld() and getWorld():getMetaGrid()
    if not meta then return nil end
    local px, py = player:getX(), player:getY()
    local best, bestName, bestDist

    if meta.getRooms then
        local rooms = meta:getRooms()
        if rooms then
            for i = 0, rooms:size() - 1 do
                local roomDef = rooms:get(i)
                if roomDef and predicate(roomDef) then
                    local def = roomDef.getBuilding and roomDef:getBuilding()
                    local cx, cy = getBuildingCenter(def)
                    if cx and cy then
                        local dist = IsoUtils.DistanceTo(px, py, cx, cy)
                        if (not maxDist or dist <= maxDist) and (not bestDist or dist < bestDist) then
                            best = def
                            bestName = roomDef:getName()
                            bestDist = dist
                        end
                    end
                end
            end
        end
    elseif meta.getRoomAt then
        local step = 20
        local radius = maxDist or 300
        local seenBuildings = {}
        for x = math.floor(px - radius), math.floor(px + radius), step do
            for y = math.floor(py - radius), math.floor(py + radius), step do
                local roomDef = meta:getRoomAt(x, y, 0)
                if roomDef and predicate(roomDef) then
                    local def = roomDef.getBuilding and roomDef:getBuilding()
                    if def and def.getKeyId then
                        local keyId = def:getKeyId()
                        if not seenBuildings[keyId] then
                            seenBuildings[keyId] = true
                            local cx, cy = getBuildingCenter(def)
                            if cx and cy then
                                local dist = IsoUtils.DistanceTo(px, py, cx, cy)
                                if (not maxDist or dist <= maxDist) and (not bestDist or dist < bestDist) then
                                    best = def
                                    bestName = roomDef:getName()
                                    bestDist = dist
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return best, bestName
end

function Conditions.FindNearestBuildingByRoomNames(player, roomNames, maxDist)
    local nameSet = buildNameSet(roomNames)
    if not nameSet then return nil end
    return Conditions.FindNearestBuildingByPredicate(player, function(roomDef)
        return nameSet[roomDef:getName()] == true
    end, maxDist)
end

function Conditions.FindNearestContainerByPredicate(player, predicate, maxDist)
    if not player or type(predicate) ~= "function" then return nil end
    local cell = getCell()
    if not cell then return nil end
    local radius = maxDist or 10
    local px = math.floor(player:getX())
    local py = math.floor(player:getY())
    local pz = math.floor(player:getZ())
    local best
    local bestDist

    for x = px - radius, px + radius do
        for y = py - radius, py + radius do
            local square = cell:getGridSquare(x, y, pz)
            if square then
                local objects = square:getObjects()
                for i = 0, objects:size() - 1 do
                    local object = objects:get(i)
                    local container = object and object.getContainer and object:getContainer() or nil
                    if container and predicate(container, object, square) then
                        local dist = IsoUtils.DistanceTo(px, py, x, y)
                        if not bestDist or dist < bestDist then
                            best = container
                            bestDist = dist
                        end
                    end
                end
            end
        end
    end

    return best
end

function Conditions.FindNearestContainerByType(player, types, maxDist)
    if not types then return nil end
    return Conditions.FindNearestContainerByPredicate(player, function(container)
        return Conditions.IsContainerType(container, types)
    end, maxDist)
end

function Conditions.IsContainerType(container, types)
    if not container or not types then return false end
    local ctype = container.getType and container:getType() or nil
    if not ctype then return false end
    for _, name in ipairs(types) do
        if ctype == name then
            return true
        end
    end
    return false
end

function Conditions.IsContainerInBuilding(container, building)
    if not container or not building then return false end
    local square = getContainerSquare(container)
    if not square then return false end
    local containerBuilding = square:getBuilding()
    if not containerBuilding then return false end
    local def = getBuildingDef(containerBuilding)
    local targetDef = getBuildingDef(building)
    if not def or not targetDef then return false end
    return def:getKeyId() == targetDef:getKeyId()
end

function Conditions.ItemTypeInList(itemType, types)
    if not itemType or not types then return false end
    for _, name in ipairs(types) do
        if itemType == name then
            return true
        end
    end
    return false
end

function Conditions.IsItemTypeRestricted(itemType, types)
    return Conditions.ItemTypeInList(itemType, types)
end

function Conditions.HasAnyItemTypes(player, itemTypes)
    if not player or not itemTypes then return false end
    local inventory = player:getInventory()
    for _, itemType in ipairs(itemTypes) do
        if inventory:containsTypeRecurse(itemType) then
            return true
        end
    end
    return false
end

function Conditions.HasNearbyFire(player)
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

function Conditions.HasNearbyVehicle(player)
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

function Conditions.IsInForestZone(player)
    local square = player:getSquare()
    if not square then return false end
    local zone = square:getZone()
    if not zone then return false end
    local zoneType = zone:getType()
    return zoneType == "Forest" or zoneType == "DeepForest"
end

function Conditions.HasHostileBanditNearby(player)
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

function Conditions.MarkDailyFlag(player, key)
    if not player or not key then return end
    local flags = getFlagTable(player, true)
    flags[key] = true
end

function Conditions.HasDailyFlag(player, key)
    if not player or not key then return false end
    local flags = getFlagTable(player, true)
    return flags[key] == true
end

function Conditions.ClearDailyFlag(player, key)
    if not player or not key then return end
    local flags = getFlagTable(player, true)
    flags[key] = nil
end

function Conditions.MarkPersistentFlag(player, key)
    if not player or not key then return end
    local flags = getFlagTable(player, false)
    flags[key] = true
end

function Conditions.HasPersistentFlag(player, key)
    if not player or not key then return false end
    local flags = getFlagTable(player, false)
    return flags[key] == true
end

function Conditions.ClearPersistentFlag(player, key)
    if not player or not key then return end
    local flags = getFlagTable(player, false)
    flags[key] = nil
end

BWOJobsOverhauled.HasNearbyFire = Conditions.HasNearbyFire
BWOJobsOverhauled.HasNearbyVehicle = Conditions.HasNearbyVehicle
BWOJobsOverhauled.IsInForestZone = Conditions.IsInForestZone
BWOJobsOverhauled.HasAnyItemTypes = Conditions.HasAnyItemTypes
BWOJobsOverhauled.HasHostileBanditNearby = Conditions.HasHostileBanditNearby
