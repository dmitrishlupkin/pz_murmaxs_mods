BWOObjects = BWOObjects or {}

local function predicateAll(item)
    -- item:getType()
    return true
end

-- ram cache for found iso objects
BWOObjects.QueryCache = {}

-- this is a collection of functions resonsible for finding a particular map object that is required
-- by various npc programs

local isTaken = function(square, bid)
    -- skip objects that are already occupied by other character
    local taken = false
    local chrs = square:getMovingObjects()
    for i=0, chrs:size()-1 do
        local chr = chrs:get(i)
        if instanceof(chr, "IsoZombie") and BanditUtils.GetZombieID(chr) == bid then
            taken = false
        else
            taken = true
            break
        end
    end
    return taken
end

local getObj = function(square, objName)
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        local sprite = object:getSprite()
        if sprite then
            local props = sprite:getProperties()
            if props:Is("CustomName") then
                local name = props:Val("CustomName")
                if name == objName then
                    return object
                end
            end
        end
    end
end

local geFullContainer = function(square, objName)
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        local sprite = object:getSprite()
        if sprite then
            local props = sprite:getProperties()
            if props:Is("CustomName") then
                local name = props:Val("CustomName")
                if not objName or name == objName then
                    local container = object:getContainer()
                    if container and not container:isEmpty() then
                        return object
                    end
                end
            end
        end
    end
end

BWOObjects.Find = function (bandit, def, objName, mode)

    local cell = getCell()
    local bid = BanditUtils.GetZombieID(bandit)
    local bx, by, bz = bandit:getX(), bandit:getY(), bandit:getZ()

    local x1, x2 = def:getX(), def:getX2()
    local y1, y2 = def:getY(), def:getY2()
    local z = def:getZ()

    local dir = x1 .. "-" .. y1
    local query = x1 .. "-" .. x2 .. "-" .. y1 .. "-" .. y2 .. "-" .. z .. "-" .. tostring(objName) .. "-" .. tostring(mode)
    local cache = BWOObjects.QueryCache

    -- Check cache for previous results
    local cacheDir = cache[dir]
    if cacheDir then
        local cachedQuery = cacheDir[query]
        if cachedQuery and cachedQuery.valid >= getTimestampMs() then
            if cachedQuery.empty then return end  -- Cached empty result, return immediately

            local result = cachedQuery.result
            if result.x and result.y and result.z then
                local square = cell:getGridSquare(result.x, result.y, result.z)
                if square and not isTaken(square, bid) then
                    local obj = (mode == "ContainerFull") and geFullContainer(square, objName) or getObj(square, objName)
                    if obj then return obj end
                end
            end
        end
    end

    -- No valid cache, initializing new entry
    if not cacheDir then cache[dir] = {} end
    cache[dir][query] = { empty = true, valid = getTimestampMs() + 50000, result = {} }

    -- Limit search range for large rooms
    local size = (x2 - x1) * (y2 - y1)
    if size > 196 then
        x1, x2 = math.max(bx - 14, def:getX()), math.min(bx + 14, def:getX2())
        y1, y2 = math.max(by - 14, def:getY()), math.min(by + 14, def:getY2())
    end

    -- Search for the closest object
    local foundDist, foundObj = math.huge, nil
    for x = x1, x2 do
        for y = y1, y2 do
            local square = cell:getGridSquare(x, y, z)
            if square and not isTaken(square, bid) then
                local obj = (mode == "ContainerFull") and geFullContainer(square, objName) or getObj(square, objName)
                if obj then
                    local dx, dy = x - bx, y - by
                    local dist = dx * dx + dy * dy  -- Squared distance for efficiency
                    if dist < foundDist then
                        foundObj, foundDist = obj, dist
                        cache[dir][query].empty = false
                        cache[dir][query].result = { x = x, y = y, z = z }
                    end
                end
            end
        end
    end

    return foundObj
end

BWOObjects.FindAround = function (bandit, r, objName)
    local cell = getCell()
    local bid = BanditUtils.GetCharacterID(bandit)
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()
    local foundDist = math.huge
    local foundObj
    for x=bx-r, bx+r do
        for y=by-r, by+r do
            local square = cell:getGridSquare(x, y, bz)
            if square then
                local zombie = square:getZombie()
                if not zombie or BanditUtils.GetCharacterID(zombie) == bid then
                    local objects = square:getObjects()
                    for i=0, objects:size()-1 do
                        local object = objects:get(i)
                        local sprite = object:getSprite()
                        if sprite then
                            local props = sprite:getProperties()
                            if props:Is("CustomName") then
                                local name = props:Val("CustomName")
                                if name == objName then
                                    local dist = BanditUtils.DistTo(x, y, bx, by)
                                    if dist < foundDist then
                                        foundObj = object
                                        foundDist = dist
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return foundObj
end

BWOObjects.FindFire = function (bandit, r)
    local cell = getCell()
    local bid = BanditUtils.GetCharacterID(bandit)
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()
    local foundDist = math.huge
    local foundObj
    for x=bx-r, bx+r do
        for y=by-r, by+r do
            local square = cell:getGridSquare(x, y, bz)
            if square then
                if square:haveFire() then
                    local dist = BanditUtils.DistTo(x, y, bx, by)
                    if dist < foundDist then
                        foundObj = square
                        foundDist = dist
                    end
                end
            end
        end
    end
    return foundObj
end

BWOObjects.FindBarricadable = function (bandit, def)
    local cell = getCell()
    local bid = BanditUtils.GetCharacterID(bandit)
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()

    local x1 = def:getX()
    local x2 = def:getX2()
    local y1 = def:getY()
    local y2 = def:getY2()
    local size = (x2 - x1) * (y2 - y1)

    if size > 144 then
        x1 = bx - 12
        x2 = bx + 12
        y1 = by - 12
        y2 = by + 12

        if x1 < def:getX() then x1 = def:getX() end
        if x2 > def:getX2() then x2 = def:getX2() end
        if y1 < def:getY() then y1 = def:getY() end
        if y2 > def:getY2() then y2 = def:getY2() end
    end

    local foundDist = math.huge
    local foundObj
    for x=x1, x2 + 1 do
        for y=y1, y2 + 1 do
            local square = cell:getGridSquare(x, y, def:getZ())
            if square then
                local zombie = square:getZombie()
                if not zombie or BanditUtils.GetCharacterID(zombie) == bid then
                    local objects = square:getObjects()
                    for i=0, objects:size()-1 do
                        local object = objects:get(i)
                        if instanceof(object, "IsoWindow") or instanceof(object, "IsoDoor") then
                            local oppositeSquare = object:getOppositeSquare()
                            if oppositeSquare then
                                if square:isOutside() ~= oppositeSquare:isOutside() then
                                    
                                    local numPlanks = 0
                                    local barricade = object:getBarricadeOnSameSquare()
                                    if barricade then
                                        numPlanks = numPlanks + barricade:getNumPlanks()
                                    end

                                    local barricade2 = object:getBarricadeOnOppositeSquare()
                                    if barricade2 then
                                        numPlanks = numPlanks + barricade2:getNumPlanks()
                                    end

                                    if numPlanks < 4 then
                                        local dist = math.sqrt(math.pow(x - bx, 2) + math.pow(y - by, 2))
                                        if dist < foundDist then
                                            foundObj = object
                                            foundDist = dist
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return foundObj
end

BWOObjects.FindExteriorDoor = function (bandit, def)
    local cell = getCell()
    local bid = BanditUtils.GetCharacterID(bandit)
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()
    local foundDist = math.huge
    local foundObj
    local cnt = 0

    local x1 = def:getX()
    local x2 = def:getX2()
    local y1 = def:getY()
    local y2 = def:getY2()
    local size = (x2 - x1) * (y2 - y1)
    if size > 144 then
        x1 = bx - 12
        x2 = bx + 12
        y1 = by - 12
        y2 = by + 12

        if x1 < def:getX() then x1 = def:getX() end
        if x2 > def:getX2() then x2 = def:getX2() end
        if y1 < def:getY() then y1 = def:getY() end
        if y2 > def:getY2() then y2 = def:getY2() end
    end

    for x=x1, x2 + 1 do
        for y=y1, y2 + 1 do
            local square = cell:getGridSquare(x, y, def:getZ())
            if square then
                local door = square:getIsoDoor()
                if door and door:isExterior() then
                    local dist = BanditUtils.DistTo(x, y, bx, by)
                    if dist < foundDist then
                        foundObj = door
                        foundDist = dist
                    end
                end
            end
            cnt = cnt + 1
        end
    end
    -- print ("EX DOOR CNT" .. cnt)
    return foundObj
end

BWOObjects.FindLightSwitch = function (bandit, room)
    local lss = room:getLightSwitches()
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()
    local foundDist = math.huge
    local foundObj

    for i=0, lss:size()-1 do
        local ls = lss:get(i)
        local x, y = ls:getX(), ls:getY()
        local dist = math.sqrt(math.pow(x - bx, 2) + math.pow(y - by, 2))
        if dist < foundDist then
            foundObj = ls
            foundDist = dist
        end
    end
    return foundObj
end

BWOObjects.FindDeadBody = function (bandit)
    local gmd = GetBWOModData()
    local bx, by = bandit:getX(), bandit:getY()

    local result = {}
    result.dist = math.huge
    result.x = false
    result.y = false
    result.z = false

    for id, deadBody in pairs(gmd.DeadBodies) do
        local dist = BanditUtils.DistToManhattan(bx, by, deadBody.x, deadBody.y)
        if dist < result.dist then
            result.dist = dist
            result.x = deadBody.x
            result.y = deadBody.y
            result.z = deadBody.z
        end
    end

    return result
end

BWOObjects.FindGMD = function (bandit, otype)
    local gmd = GetBWOModData()
    local bx, by = bandit:getX(), bandit:getY()

    local result = {}
    result.dist = math.huge
    result.x = false
    result.y = false
    result.z = false

    local cnt = 0
    if gmd.Objects[otype] then
        for id, object in pairs(gmd.Objects[otype]) do
            local dist = BanditUtils.DistToManhattan(bx, by, object.x, object.y)
            if dist < result.dist then
                result.dist = dist
                result.x = object.x
                result.y = object.y
                result.z = object.z
            end
            cnt = cnt + 1
        end
    end
    
    -- print ("scanned " .. otype .. ": " .. cnt)
    return result
end