BWONoJaywalking = BWONoJaywalking or {}
BWONoJaywalking.DEBUG = BWONoJaywalking.DEBUG or false
BWONoJaywalking.TreatGravelAsRoad = BWONoJaywalking.TreatGravelAsRoad or false
BWONoJaywalking._installed = BWONoJaywalking._installed or false
BWONoJaywalking._original = BWONoJaywalking._original or {}

local AVOID_PROGRAMS = {
    Walker = true,
    Runner = true,
    Inhabitant = true,
    Postal = true,
    Janitor = true,
    Gardener = true
}

local AVOID_OCCUPATIONS = {
    Police = true,
    Security = true,
    Army = true,
    Medic = true,
    Fireman = true,
    SWAT = true
}

local function log(msg)
    if not BWONoJaywalking.DEBUG then return end
    print("[BWONoJaywalking] " .. tostring(msg))
end

local function nameContains(value, token)
    if not value or not token then return false end
    if value.embodies then
        return value:embodies(token)
    end
    return string.find(value, token, 1, true) ~= nil
end

local function getGroundQuality(square)
    if not square then return nil end

    local objects = square.getObjects and square:getObjects() or nil
    if not objects or not objects.size then return nil end

    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        local sprite = object and object.getSprite and object:getSprite() or nil
        if sprite and sprite.getName then
            local name = sprite:getName()
            if name then
                if nameContains(name, "tilesandstone") then
                    return 1
                end
                if nameContains(name, "street") then
                    local props = sprite.getProperties and sprite:getProperties() or nil
                    local attachedFloor = IsoFlagType and IsoFlagType.attachedFloor or nil
                    if props and props.Is and attachedFloor and props:Is(attachedFloor) then
                        local material = props.Val and props:Val("FootstepMaterial") or nil
                        if material == "Gravel" then
                            return 2
                        end
                        return 4
                    end
                    return 3
                end
            end
        end
    end
    return nil
end

local function isRoadSquare(square)
    local quality = getGroundQuality(square)
    if quality == 2 then
        return BWONoJaywalking.TreatGravelAsRoad
    end
    return quality == 3 or quality == 4
end

local function isNeutralIdle(bandit)
    if not bandit then return false end
    if bandit.isDead and bandit:isDead() then return false end
    if bandit.getVehicle and bandit:getVehicle() then return false end
    if bandit.isOutside and not bandit:isOutside() then return false end
    if not BanditBrain or not BanditBrain.Get then return false end

    local brain = BanditBrain.Get(bandit)
    if not brain or not brain.program or not brain.program.name then return false end
    if brain.hostile or brain.hostileP then return false end
    if not AVOID_PROGRAMS[brain.program.name] then return false end
    if brain.occupation and AVOID_OCCUPATIONS[brain.occupation] then return false end

    return true
end

local function dist2d(x1, y1, x2, y2)
    if BanditUtils and BanditUtils.DistTo then
        return BanditUtils.DistTo(x1, y1, x2, y2)
    end
    local dx = x1 - x2
    local dy = y1 - y2
    return math.sqrt((dx * dx) + (dy * dy))
end

local function distTo(bandit, square)
    if not bandit or not square then return 0 end
    return dist2d(bandit:getX(), bandit:getY(), square:getX(), square:getY())
end

local function findExitSquare(bandit, radius)
    if not bandit or not radius then return nil end
    local square = bandit:getSquare()
    if not square then return nil end

    local cell = bandit:getCell()
    if not cell then return nil end

    local cx = square:getX()
    local cy = square:getY()
    local cz = square:getZ()

    local fx = 0
    local fy = 0
    local direction = bandit:getForwardDirection()
    if direction and direction.getX then
        fx = direction:getX()
        fy = direction:getY()
    end

    local bestScore = math.huge
    local bestSquare = nil

    for dx = -radius, radius do
        for dy = -radius, radius do
            if dx ~= 0 or dy ~= 0 then
                local target = cell:getGridSquare(cx + dx, cy + dy, cz)
                if target and target:isOutside() and target:isFree(false) and not isRoadSquare(target) then
                    local dist2 = (dx * dx) + (dy * dy)
                    local dot = (dx * fx) + (dy * fy)
                    local penalty = 0
                    if dot < 0 then
                        penalty = 1000
                    end
                    local score = (dist2 * 10) + penalty - dot
                    if score < bestScore then
                        bestScore = score
                        bestSquare = target
                    end
                end
            end
        end
    end

    return bestSquare
end

local function addMoveTask(tasks, bandit, targetSquare, walkType, forceRun)
    if not targetSquare or not BanditUtils or not BanditUtils.GetMoveTask then return false end
    local moveType = walkType or "Walk"
    if forceRun and moveType ~= "Run" then
        moveType = "Run"
    end
    local dist = distTo(bandit, targetSquare)
    table.insert(tasks, BanditUtils.GetMoveTask(0, targetSquare:getX(), targetSquare:getY(), targetSquare:getZ(), moveType, dist, false))
    return true
end

function BWONoJaywalking.FollowRoadAvoid(bandit, walkType)
    local tasks = {}
    if not bandit or not BanditUtils or not BanditUtils.GetMoveTask then return tasks end

    local player = getSpecificPlayer(0)
    if not player then return tasks end

    local cell = bandit:getCell()
    if not cell then return tasks end

    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()

    local vehicleList = {}
    local npcVehicles = BWOVehicles and BWOVehicles.tab or nil
    if npcVehicles then
        for k, v in pairs(npcVehicles) do
            if v:getController() and not v:isStopped() then
                vehicleList[k] = v
            end
        end
    end

    local playerVehicle = player:getVehicle()
    if playerVehicle and not playerVehicle:isStopped() then
        vehicleList[playerVehicle:getId()] = playerVehicle
    end

    for id, vehicle in pairs(vehicleList) do
        local vx = vehicle:getX()
        local vy = vehicle:getY()
        local dist = dist2d(bx, by, vx, vy)
        if dist < 10 then
            local vay = vehicle:getAngleY()
            local ba = bandit:getDirectionAngle()

            vay = vay - 90
            if vay < -180 then vay = vay + 360 end

            local escapeAngle = vay - 90
            if escapeAngle < 180 then escapeAngle = escapeAngle + 360 end

            local theta = escapeAngle * math.pi * 0.00555555
            local lx = math.floor(10 * math.cos(theta) + 0.5)
            if bx > vx then
                lx = math.abs(lx)
            else
                lx = -math.abs(lx)
            end

            local ly = math.floor(10 * math.sin(theta) + 0.5)
            if by > vy then
                ly = math.abs(ly)
            else
                ly = -math.abs(ly)
            end

            table.insert(tasks, BanditUtils.GetMoveTask(0, bx + lx, by + ly, 0, "Run", 10, false))
            return tasks
        end
    end

    local currentSquare = bandit:getSquare()
    if currentSquare and isRoadSquare(currentSquare) then
        local exitSquare = findExitSquare(bandit, 3)
        if exitSquare then
            addMoveTask(tasks, bandit, exitSquare, walkType, true)
            return tasks
        end
    end

    local direction = bandit:getForwardDirection()
    if not direction then return tasks end
    local angle = direction:getDirection()
    direction:setLength(8)

    local options = {}
    options[1] = {}
    options[2] = {}
    options[3] = {}
    options[4] = {}

    local step = 0.785398163 / 2
    for i = 0, 14 do
        for j = -1, 1, 2 do
            local newangle = angle + (i * j * step)
            if newangle > 6.283185304 then newangle = newangle - 6.283185304 end
            direction:setDirection(newangle)

            local vx = bx + direction:getX()
            local vy = by + direction:getY()
            local square = cell:getGridSquare(vx, vy, bz)
            if square and square:isOutside() then
                local quality = getGroundQuality(square)
                if quality then
                    table.insert(options[quality], {x = vx, y = vy, z = bz, quality = quality})
                end
            end
        end
    end

    local function pick(qualities, forceRun)
        for _, quality in ipairs(qualities) do
            local opts = options[quality]
            for _, opt in ipairs(opts) do
                local moveType = walkType
                if forceRun and moveType ~= "Run" then
                    moveType = "Run"
                end
                table.insert(tasks, BanditUtils.GetMoveTask(0, opt.x, opt.y, opt.z, moveType, 2, false))
                return true
            end
        end
        return false
    end

    local safeQualities = BWONoJaywalking.TreatGravelAsRoad and {1} or {1, 2}
    if pick(safeQualities, false) then return tasks end
    if pick({3}, true) then return tasks end
    if pick({4}, true) then return tasks end

    return tasks
end

function BWONoJaywalking.Install()
    if BWONoJaywalking._installed then return true end
    if not BanditPrograms or not BanditPrograms.FollowRoad then return false end

    BWONoJaywalking._original.FollowRoad = BanditPrograms.FollowRoad
    BanditPrograms.FollowRoad = function(bandit, walkType)
        if isNeutralIdle(bandit) then
            local tasks = BWONoJaywalking.FollowRoadAvoid(bandit, walkType)
            if tasks and #tasks > 0 then
                return tasks
            end
        end
        return BWONoJaywalking._original.FollowRoad(bandit, walkType)
    end

    BWONoJaywalking._installed = true
    log("installed")
    return true
end

local function tryInstall()
    if BWONoJaywalking._installed then return end
    BWONoJaywalking.Install()
end

if Events and Events.OnGameStart then
    Events.OnGameStart.Add(tryInstall)
end

if Events and Events.OnTick then
    Events.OnTick.Add(function()
        if not BWONoJaywalking._installed then
            tryInstall()
        end
    end)
end

tryInstall()
