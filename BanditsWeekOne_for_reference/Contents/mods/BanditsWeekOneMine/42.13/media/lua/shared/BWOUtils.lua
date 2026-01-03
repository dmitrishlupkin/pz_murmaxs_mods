BanditUtils = BanditUtils or {}

BanditUtils.GetTime = function()
    local m = getSandboxOptions():getDayLengthMinutes()
    local coeff = 60 / m

    return getGameTime():getWorldAgeHours() * 2500000  / 24 / coeff
end

function BanditUtils.In(needle, haystack)
    for _, h in pairs(haystack) do
        if needle == h then return true end
    end
    return false
end

function BanditUtils.GetAllBanditByProgram(programs)
    local result = {}
    local zombieList = BanditZombie.GetAllB()
    for id, zombie in pairs(zombieList) do
        for _, program in pairs(programs) do
            if zombie.brain and zombie.brain.program and zombie.brain.program.name == program then
                table.insert(result, zombie)
            end
        end
    end
    return result
end

function BanditUtils.GetClosestBanditLocationProgram(character, programs)
    local result = {}
    local cid = BanditUtils.GetCharacterID(character)

    result.dist = math.huge
    result.x = false
    result.y = false
    result.z = false
    result.id = false

    local cx, cy = character:getX(), character:getY()

    local zombieList = BanditZombie.GetAllB()
    for id, zombie in pairs(zombieList) do
        for _, program in pairs(programs) do
            if zombie.brain.program.name == program then
                if math.abs(zombie.x - cx) < 30 or math.abs(zombie.y - cy) < 30 then
                    local dist = BanditUtils.DistTo(cx, cy, zombie.x, zombie.y)
                    if dist < result.dist and cid ~= id then
                        result.dist = dist
                        result.x = zombie.x
                        result.y = zombie.y
                        result.z = zombie.z
                        result.id = zombie.id
                    end
                end
            end
        end
    end

    return result
end

function BanditUtils.GetClosestBanditVehicle(vehicle)
    local result = {}

    result.dist = math.huge
    result.x = false
    result.y = false
    result.z = false
    result.id = false

    local vx, vy = vehicle:getX(), vehicle:getY()

    local zombieList = BanditZombie.GetAllB()
    for id, zombie in pairs(zombieList) do
        if math.abs(zombie.x - vx) < 60 or math.abs(zombie.y - vy) < 60 then
            local dist = BanditUtils.DistTo(vx, vy, zombie.x, zombie.y)
            if dist < result.dist then
                result.dist = dist
                result.x = zombie.x
                result.y = zombie.y
                result.z = zombie.z
                result.id = zombie.id
            end
        end
    end

    return result
end

function BanditUtils.LineClear(obj1, obj2)
    local cell = obj1:getCell()
    local x1, y1, z1 = obj1:getX(), obj1:getY(), obj1:getZ()
    local x2, y2, z2 = obj2:getX(), obj2:getY(), obj2:getZ()
    return tostring(LosUtil.lineClear(cell, x1, y1, z1, x2, y2, z2, false)) ~= "Blocked"
end

function BanditUtils.GetSurfaceOffset(x, y, z)
    local cell = getCell()
    local square = cell:getGridSquare(x, y, z)
    local tileObjects = square:getLuaTileObjectList()
    local squareSurfaceOffset = 0

    -- get the object with the highest offset
    for k, object in pairs(tileObjects) do
        local surfaceOffsetNoTable = object:getSurfaceOffsetNoTable()
        if surfaceOffsetNoTable > squareSurfaceOffset then
            squareSurfaceOffset = surfaceOffsetNoTable
        end

        local surfaceOffset = object:getSurfaceOffset()
        if surfaceOffset > squareSurfaceOffset then
            squareSurfaceOffset = surfaceOffset
        end
    end

    return squareSurfaceOffset / 96
end

function BanditUtils.HasZoneType(x, y, z, zoneType)
    local zones = getZones(x, y, z)
    if zones then
        for i=0, zones:size()-1 do
            local zone = zones:get(i)
            if zone:getType() == zoneType then
                return true
            end
        end
    end
    return false
end

function BanditUtils.GetZombieZone(x, y, z)
    local zones = getWorld():getMetaGrid():getZonesAt(x, y, z)
    for i=0, zones:size()-1 do
        local zone = zones:get(i)
        local ztype = zone:getType() -- ZombiesType
        if ztype == "ZombiesType" then
            return zone:getName()
        end
    end
end

function BanditUtils.AddPriceInflation(price)
    local wa = BWOScheduler.WorldAge
    if wa < 0 then wa = 0 end
    local day = math.floor(wa / 24)
    return math.floor(price * ((1 + SandboxVars.BanditsWeekOne.PriceInflation / 100) ^ day))
end