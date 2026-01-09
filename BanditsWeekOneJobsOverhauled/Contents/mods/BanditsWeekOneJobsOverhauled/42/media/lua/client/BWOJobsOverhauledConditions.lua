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

local function buildNameSet(names)
    if not names then return nil end
    local set = {}
    for _, name in ipairs(names) do
        set[name] = true
    end
    return set
end

local function findBuildingByKeyId(keyId)
    if not keyId then return nil end
    local cell = getCell()
    if not cell or not cell.getBuildingList then return nil end
    local buildings = cell:getBuildingList()
    if not buildings then return nil end
    for i = 0, buildings:size() - 1 do
        local building = buildings:get(i)
        local def = building and building:getDef()
        if def and def.getKeyId and def:getKeyId() == keyId then
            return building
        end
    end
    return nil
end

local function findRoomSquareInBuilding(building, roomNames)
    if not building then return nil end
    local def = getBuildingDef(building)
    if not def then return nil end
    local cell = getCell()
    if not cell then return nil end
    local rooms = cell:getRoomList()
    if not rooms then return nil end
    local nameSet = buildNameSet(roomNames)
    local candidates = {}

    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)
        if room and room.getBuilding and room:getBuilding() then
            local roomDef = getBuildingDef(room:getBuilding())
            if roomDef and roomDef.getKeyId and def.getKeyId and roomDef:getKeyId() == def:getKeyId() then
                local roomName = room:getName()
                if BWORooms and BWORooms.GetRealRoomName then
                    roomName = BWORooms.GetRealRoomName(room)
                end
                if not nameSet or nameSet[roomName] then
                    local squares
                    if room.getSquares then
                        local ok, res = pcall(room.getSquares, room)
                        if ok then
                            squares = res
                        end
                    end
                    if squares and squares:size() > 0 then
                        table.insert(candidates, { room = room, squares = squares, name = roomName })
                    end
                end
            end
        end
    end

    if #candidates == 0 then return nil end
    local pick = candidates[ZombRand(#candidates) + 1]
    local squares = pick.squares
    local square = squares:get(ZombRand(squares:size()))
    return square, pick.name
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

function Conditions.GetZoneLabelAt(x, y, z)
    return getZoneLabelAt(x, y, z)
end

function Conditions.FindBuildingByKeyId(keyId)
    return findBuildingByKeyId(keyId)
end

function Conditions.FindRoomSquareInBuilding(building, roomNames)
    return findRoomSquareInBuilding(building, roomNames)
end

function Conditions.RoomMatchesProfession(room, profession)
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

function Conditions.RoomDefMatchesProfession(roomDef, profession)
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

Conditions.PoliceRoomNames = {
    "policeoffice", "policehall", "policestorage", "interrogationroom", "cell", "prisoncell", "prisoncells"
}

Conditions.MunicipalRoomNames = {
    "bank", "post", "poststorage", "security"
}

Conditions.SecurityRoomNames = {
    "security", "securityoffice", "securityroom", "guardroom", "checkpoint"
}

Conditions.ArmoryRoomNames = {
    "armory", "armoury", "armystorage", "bankstorage", "policestorage", "prisonarmory", "weaponstorage", "gunstore"
}

Conditions.MedicalRoomNames = {
    "medclinic", "medical", "clinic", "hospitalstorage", "medicalstorage", "pharmacystorage", "pharmacy", "dentiststorage"
}

Conditions.GymRoomNames = {
    "gym", "fitness", "sportstore", "sportstorage"
}

Conditions.EntertainmentRoomNames = {
    "bar", "beergarden", "restaurant", "dining", "diner", "cafeteria", "cafe", "theatre", "bowlingalley",
    "stripclub", "recreation", "mall", "bandlivingroom", "bandkitchen"
}

Conditions.RestaurantRoomNames = {
    "restaurant", "dining", "diner", "cafeteria", "pizzawhirled", "pizzawhirledcounter", "pileocrepe",
    "sushidining", "spifforestaurant", "spiffo_dining", "bakerykitchen", "barkitchen", "burgerkitchen",
    "cafekitchen", "cafeteriakitchen", "pizzakitchen", "sushikitchen", "tacokitchen", "theatrekitchen",
    "spiffoskitchen", "arenakitchen", "bandkitchen"
}

Conditions.CafeRoomNames = {
    "cafe", "cafekitchen", "cafeteria", "cafeteriakitchen"
}

Conditions.BarRoomNames = {
    "bar", "beergarden", "barkitchen"
}

Conditions.FastFoodRoomNames = {
    "spifforestaurant", "spiffo_dining", "spiffoskitchen", "spiffosstorage",
    "burgerkitchen", "burgerstorage", "pizzawhirled", "pizzawhirledcounter", "pizzakitchen", "tacokitchen", "pileocrepe"
}

Conditions.ResidentialRoomNames = {
    "bedroom", "livingroom", "room1", "closet", "bathroom", "diningroom", "kitchen"
}

Conditions.LumberjackRoomNames = {
    "factorystorage"
}

Conditions.FishermanRoomNames = {
    "fishingstorage"
}

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

function Conditions.FindNearestWorkBuilding(player, profession)
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
        if room and Conditions.RoomMatchesProfession(room, profession) then
            local roomDef = room:getRoomDef()
            if roomDef then
                local cx, cy = getBuildingCenter(roomDef:getBuilding())
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

local function getItemType(item)
    if not item then return nil end
    if item.getFullType then
        return item:getFullType()
    end
    if item.getType then
        return item:getType()
    end
    return nil
end

function Conditions.IsItemRestricted(item, types)
    local itemType = getItemType(item)
    if not itemType then return false end
    return Conditions.IsItemTypeRestricted(itemType, types)
end

function Conditions.IsTransferToPlayer(data)
    if not data or not data.destContainer then return false end
    local parent = data.destContainer:getParent()
    return parent and instanceof(parent, "IsoPlayer")
end

function Conditions.IsTransferFromPlayer(data)
    if not data or not data.srcContainer then return false end
    local parent = data.srcContainer:getParent()
    return parent and instanceof(parent, "IsoPlayer")
end

function Conditions.IsRestrictedTake(data, types)
    if not Conditions.IsTransferToPlayer(data) then return false end
    return Conditions.IsItemRestricted(data.item, types)
end

function Conditions.IsRestrictedDrop(data, types)
    if not Conditions.IsTransferFromPlayer(data) then return false end
    return Conditions.IsItemRestricted(data.item, types)
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
BWOJobsOverhauled.FindNearestWorkBuilding = Conditions.FindNearestWorkBuilding
BWOJobsOverhauled.RoomMatchesProfession = Conditions.RoomMatchesProfession
BWOJobsOverhauled.RoomDefMatchesProfession = Conditions.RoomDefMatchesProfession
BWOJobsOverhauled.GetZoneLabelAt = Conditions.GetZoneLabelAt
BWOJobsOverhauled.FindBuildingByKeyId = Conditions.FindBuildingByKeyId
BWOJobsOverhauled.FindRoomSquareInBuilding = Conditions.FindRoomSquareInBuilding
BWOJobsOverhauled.PoliceRoomNames = Conditions.PoliceRoomNames
BWOJobsOverhauled.MunicipalRoomNames = Conditions.MunicipalRoomNames
BWOJobsOverhauled.SecurityRoomNames = Conditions.SecurityRoomNames
BWOJobsOverhauled.ArmoryRoomNames = Conditions.ArmoryRoomNames
BWOJobsOverhauled.MedicalRoomNames = Conditions.MedicalRoomNames
BWOJobsOverhauled.GymRoomNames = Conditions.GymRoomNames
BWOJobsOverhauled.EntertainmentRoomNames = Conditions.EntertainmentRoomNames
BWOJobsOverhauled.RestaurantRoomNames = Conditions.RestaurantRoomNames
BWOJobsOverhauled.CafeRoomNames = Conditions.CafeRoomNames
BWOJobsOverhauled.BarRoomNames = Conditions.BarRoomNames
BWOJobsOverhauled.FastFoodRoomNames = Conditions.FastFoodRoomNames
BWOJobsOverhauled.ResidentialRoomNames = Conditions.ResidentialRoomNames
BWOJobsOverhauled.LumberjackRoomNames = Conditions.LumberjackRoomNames
BWOJobsOverhauled.FishermanRoomNames = Conditions.FishermanRoomNames
