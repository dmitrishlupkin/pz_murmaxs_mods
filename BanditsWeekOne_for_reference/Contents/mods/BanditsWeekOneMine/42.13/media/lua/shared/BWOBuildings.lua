BWOBuildings = BWOBuildings or {}

-- OpenHours defines opening hours for a given type of a building
BWOBuildings.OpenHours = {}

BWOBuildings.OpenHours.unknown = {}
BWOBuildings.OpenHours.unknown.open = 0
BWOBuildings.OpenHours.unknown.close = 0

BWOBuildings.OpenHours.commercial = {}
BWOBuildings.OpenHours.commercial.open = 8
BWOBuildings.OpenHours.commercial.close = 18

BWOBuildings.OpenHours.bank = BWOBuildings.OpenHours.commercial
BWOBuildings.OpenHours.mechanic = BWOBuildings.OpenHours.commercial
BWOBuildings.OpenHours.industrial = BWOBuildings.OpenHours.commercial
BWOBuildings.OpenHours.gunstore = BWOBuildings.OpenHours.commercial
BWOBuildings.OpenHours.office = BWOBuildings.OpenHours.commercial

BWOBuildings.OpenHours.residential = {}
BWOBuildings.OpenHours.residential.open = 0
BWOBuildings.OpenHours.residential.close = 0
BWOBuildings.OpenHours.prison = BWOBuildings.OpenHours.residential

BWOBuildings.OpenHours.motel = {}
BWOBuildings.OpenHours.motel.open = 0
BWOBuildings.OpenHours.motel.close = 24

BWOBuildings.OpenHours.dining = {}
BWOBuildings.OpenHours.dining.open = 9
BWOBuildings.OpenHours.dining.close = 24

BWOBuildings.OpenHours.education = {}
BWOBuildings.OpenHours.education.open = 0
BWOBuildings.OpenHours.education.close = 24

BWOBuildings.OpenHours.church = {}
BWOBuildings.OpenHours.church.open = 6
BWOBuildings.OpenHours.church.close = 20

BWOBuildings.OpenHours.police = {}
BWOBuildings.OpenHours.police.open = 0
BWOBuildings.OpenHours.police.close = 24

BWOBuildings.OpenHours.firestation = BWOBuildings.OpenHours.police
BWOBuildings.OpenHours.medical = BWOBuildings.OpenHours.police
BWOBuildings.OpenHours.gasstation = BWOBuildings.OpenHours.police

BWOBuildings.OpenHours.church = {}
BWOBuildings.OpenHours.church.open = 0
BWOBuildings.OpenHours.church.close = 24

BWOBuildings.IsResidential = function(building)

    -- if true then return false end
    -- this gives false positives when the building is large and there are apparments and offices in the same building
    --[[
    if building:containsRoom("bedroom") and building:containsRoom("bathroom") then -- and building:containsRoom("kitchen")
        return true
    end
    ]]

    local player = getSpecificPlayer(0)
    local def = building:getDef()
    local roomDefs = def:getRooms() -- returns roomDefs!

    if roomDefs:size() > 30 then return false end

    local hasBedroom = false
    local hasBathroom = false
    local hasKitchen = false
    for i = 0, roomDefs:size() - 1 do
        local roomDef = roomDefs:get(i)
        local room = roomDef:getIsoRoom()
        local name = BWORooms.GetRealRoomName(room)
        if roomDef:getZ() == player:getZ() then
            if name == "bedroom" then
                hasBedroom = true
            elseif name == "bathroom" then
                hasBathroom = true
            elseif name == "kitchen" then
                hasKitchen = true
            end
        end
    end

    if (hasBedroom or hasKitchen) and hasBathroom then
        return true
    end

    return false
end

BWOBuildings.GetSize = function(building)
    local def = building:getDef()
    local size = (def:getX2() - def:getX()) * (def:getY2() - def:getY())
    return size
end

BWOBuildings.IsEventBuilding = function(building, event)
    local gmd = GetBWOModData()
    local buildingDef = building:getDef()
    local id = buildingDef:getKeyId()
    if gmd.EventBuildings[id] then
        if gmd.EventBuildings[id].event == event then
            return true
        end
    end
    return false
end

BWOBuildings.GetEventBuildingCoords = function(event)
    local gmd = GetBWOModData()
    for key, eb in pairs(gmd.EventBuildings) do
        if eb.event == event then
            return {x=eb.x, y=eb.y}
        end
    end
    return false
end

BWOBuildings.IsRecentlyVisited = function(building)
    local buildingDef = building:getDef()
    local bid = BanditUtils.GetBuildingID(buildingDef)
    local gmd = GetBanditModData()
    if gmd.VisitedBuildings and gmd.VisitedBuildings[bid] then
        local now = getGameTime():getWorldAgeHours()
        local lastVisit = gmd.VisitedBuildings[bid]
        local coolDown = 4 * 24
        if now - coolDown < lastVisit then
            return true
        end
    end
    return false
end

BWOBuildings.FindBuildingWithRoom = function(bsearch)
    local player = getSpecificPlayer(0)
    if not player then return end

    local cell = player:getCell()
    local rooms = cell:getRoomList()
    local buildings = {}
    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)

        local building = room:getBuilding()
        if building and building:containsRoom(bsearch) and not BWOBuildings.IsEventBuilding(building, "home") then
            local def = building:getDef()
            if math.abs(def:getX() - player:getX()) < 70 and math.abs(def:getX2() - player:getX()) < 70 and 
               math.abs(def:getY() - player:getY()) < 70 and math.abs(def:getY2() - player:getY()) < 70 then
                local key = def:getKeyId()

                if not buildings[key] then
                    buildings[key] = building
                end
            end
        end
    end

    -- shuffle (Fisher-Yates)
    for i = #buildings, 2, -1 do
        local j = ZombRand(i) + 1
        buildings[i], buildings[j] = buildings[j], buildings[i]
    end
    
    -- return first after shuffle
    for key, building in pairs(buildings) do
        return building
    end
end

BWOBuildings.FindBuildingDist = function(character, min, max)
    local px, py = character:getX(), character:getY()
    local cell = character:getCell()
    local rooms = cell:getRoomList()
    local buildings = {}
    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)

        local building = room:getBuilding()
        if building then
            local def = building:getDef()
            local key = def:getKeyId()

            if not buildings[key] then
                buildings[key] = building
            end
        end
    end

    -- shuffle (Fisher-Yates)
    for i = #buildings, 2, -1 do
        local j = ZombRand(i) + 1
        buildings[i], buildings[j] = buildings[j], buildings[i]
    end

    for key, building in pairs(buildings) do
        local def = building:getDef()
        local mx = (def:getX() + def:getX2()) / 2
        local my = (def:getY() + def:getY2()) / 2
        local dist = BanditUtils.DistTo(px, py, mx, my)

        if dist > min and dist < max then
            return building
        end
    end
end

BWOBuildings.DensityScoreCache = {}

BWOBuildings.GetDensityScore = function(character, radius)
    -- local ts = getTimestampMs()
    local px, py = character:getX(), character:getY()

    local sx = math.floor(px / 25)
    local sy = math.floor(py / 25)
    local id = sx .. "-" .. sy
    local cache = BWOBuildings.DensityScoreCache
    if cache[id] then return cache[id] end

    local cell = character:getCell()
    local rooms = cell:getRoomList()
    -- local buildings = cell:getBuildings():size()
    local total = 0
    print ("rooms: " .. rooms:size())

    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)
        if room then
            local roomDef = room:getRoomDef()
            if roomDef then
                local x1, y1, x2, y2 = roomDef:getX(), roomDef:getY(), roomDef:getX2(), roomDef:getY2()

                local cx = (x1 + x2) / 2
                local cy = (y1 + y2) / 2

                if math.abs(px - cx) + math.abs(py - cy) <= radius then
                    local size = (x2 - x1) * (y2 - y1)
                    total = total + size
                end
            end
        end
    end
    BWOBuildings.DensityScoreCache[id] = total
    -- print ("GetDensityScore: " .. (getTimestampMs() - ts))
    return total
end