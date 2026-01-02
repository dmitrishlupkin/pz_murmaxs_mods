BWOFakeVehicle = BWOFakeVehicle or {}
BWOFakeVehicle.tab = {}

local floor, sin, cos, tan, deg = math.floor, math.sin, math.cos, math.tan, math.deg
local dbgTex = getTexture("media/textures/blast_w.png")
local ONE_PI = math.pi
local TWO_PI = math.pi * 2
local LIGHT_COLOR = {r = 1, g = 1, b = 0.8}
local LIGHT_RANGE = 14
local tickSkip = 1

------------------------------------------------
-- Vehicle registration
------------------------------------------------
function BWOFakeVehicle.Add(params)
    local vehicle = {}
    local start = BWORoutes.routes[params.routeId].start
    if not start then return end

    vehicle.parts = params.parts
    vehicle.routeId = params.routeId
    vehicle.x = start.x
    vehicle.y = start.y
    vehicle.z = 0
    vehicle.rot = (start.rot * ONE_PI / 180) % (2 * ONE_PI)
    vehicle.steer = 0
    vehicle.speed = 0

    vehicle.emitter = getWorld():getFreeEmitter(vehicle.x, vehicle.y, vehicle.z)
    vehicle.emitter2 = getWorld():getFreeEmitter(vehicle.x, vehicle.y, vehicle.z)

    table.insert(BWOFakeVehicle.tab, vehicle)
end

local function round(num, decimals)
    local mult = 10 ^ decimals
    return math.floor(num * mult + 0.5) / mult
end

local function normalizeAngle(a)
    a = (a + ONE_PI) % (2 * ONE_PI)   -- this ensures 0..2π
    if a < 0 then a = a + 2 * ONE_PI end
    return a - ONE_PI
end

--[[
local function normalizeAngle(a)
    return ((a + ONE_PI) % (2 * ONE_PI)) - ONE_PI
end
]]

------------------------------------------------
-- Part creation / lookup
------------------------------------------------
local function getOrCreatePart(part, vehicle, square)
    local obj, item
    local wobs = square:getWorldObjects()
    for i = 0, wobs:size() - 1 do
        local wobj = wobs:get(i)
        local it = wobj:getItem()
        if it:getFullType() == part.itemType then
            obj, item = wobj, it
            break
        end
    end

    if not obj then
        local it = BanditCompatibility.InstanceItem(part.itemType)
        square:AddWorldInventoryItem(it, 0, 0, 0)
        wobs = square:getWorldObjects()
        for i = 0, wobs:size() - 1 do
            local wobj = wobs:get(i)
            local it2 = wobj:getItem()
            if it2:getFullType() == part.itemType then
                obj, item = wobj, it2
                break
            end
        end
    end

    return obj, item
end

------------------------------------------------
-- Transform local offsets into world coordinates
------------------------------------------------
local function TransformPart(part, vehicle)
    local rot = vehicle.rot or 0
    local s, c = cos(rot), sin(rot)
    local lx, ly = part.xoffset or 0, part.yoffset or 0
    local wx = vehicle.x + (lx * c) + (ly * s)
    local wy = vehicle.y - (lx * s) + (ly * c)
    local wz = vehicle.z + (part.zoffset or 0)
    return wx, wy, wz
end

------------------------------------------------
-- Update a single part (spawn/move/rotate)
------------------------------------------------
local function UpdatePart(part, vehicle)
    local wx_raw, wy_raw, wz_raw = TransformPart(part, vehicle)

    -- integer square pos (stable carry method)
    local gx = floor(wx_raw)
    local gy = floor(wy_raw)
    local gz = floor(wz_raw)

    local offX = wx_raw - gx
    local offY = wy_raw - gy
    local offZ = wz_raw - gz

    -- force into [0,1)
    if offX < 0 then gx, offX = gx - 1, offX + 1 end
    if offY < 0 then gy, offY = gy - 1, offY + 1 end
    if offZ < 0 then gz, offZ = gz - 1, offZ + 1 end

    -- detect square change
    if part._gx ~= gx or part._gy ~= gy or part._gz ~= gz then
        if part._square and part._obj then
            part._square:removeWorldObject(part._obj)
        end
        part._obj, part._item, part._square = nil, nil, nil
    end

    local square = getCell():getGridSquare(gx, gy, gz)
    if not square then return end

    if not part._obj then
        part._obj, part._item = getOrCreatePart(part, vehicle, square)
        part._square = square
        part._gx, part._gy, part._gz = gx, gy, gz
    end

    local obj, item = part._obj, part._item
    if not (obj and item) then return end

    -- Apply offsets (no quantize, just stable carry)
    obj:setOffX(offX)
    obj:setOffY(offY)
    obj:setOffZ(offZ)

    -- Rotations
    item:setWorldXRotation(part.xrot or 0)
    item:setWorldYRotation(part.yrot or 0)

    local visualRot = round(vehicle.rot, 2) -- rounded copy for visuals
    local visualSteer = part.steerRot and round(vehicle.steer, 2) or 0

    local angleDeg = deg(visualRot + visualSteer)
    if part.zrot then
        angleDeg = angleDeg + part.zrot
    end
    local gameRot = (90 + angleDeg) % 360
    if gameRot == 360 then gameRot = 0 end
    item:setWorldZRotation(gameRot)

    if vehicle.debug then
        local player = getSpecificPlayer(0)
        if player then
            local pn = player:getPlayerNum()
            local sx = isoToScreenX(pn, wx_raw, wy_raw, 0)
            local sy = isoToScreenY(pn, wx_raw, wy_raw, 0)
            UIManager.DrawTexture(dbgTex, sx, sy, 5, 5, 1)
        end
    end
end



------------------------------------------------
-- Collision check for body only
------------------------------------------------
local function inBoundary(body, vehicle, px, py)
    local halfW = body.width / 2
    local wheelbase = body.wheelbase or 4.0
    local frontOverhang = body.frontOverhang or 0.5
    local rearOverhang  = body.rearOverhang  or 0.5
    local rot = vehicle.rot or 0

    local s, c = cos(rot), sin(rot)
    local localCorners = {
        {-halfW, -rearOverhang},                -- rear-left
        { halfW, -rearOverhang},                -- rear-right
        { halfW, wheelbase + frontOverhang},    -- front-right
        {-halfW, wheelbase + frontOverhang},    -- front-left
    }

    local corners = {}
    for i = 1, 4 do
        local lx, ly = localCorners[i][1], localCorners[i][2]
        local wx = vehicle.x + (lx * c) + (ly * s)
        local wy = vehicle.y - (lx * s) + (ly * c)
        corners[i] = {wx, wy}
    end

    for i = 1, 4 do
        local j = (i % 4) + 1
        local x1, y1 = corners[i][1], corners[i][2]
        local x2, y2 = corners[j][1], corners[j][2]

        local ex, ey = x2 - x1, y2 - y1
        local pxv, pyv = px - x1, py - y1
        if (ex * pyv - ey * pxv) < 0 then
            return false
        end
    end

    return true
end

local function isBlockedAhead(vehicle, d, spread)
    local body = vehicle.parts.body
    if not body then return false end

    local vt = BWOFakeVehicle.tab
    local margin = 0.2
    local halfW = body.width / 2 + margin
    local rot = vehicle.rot
    local dirX, dirY = math.cos(rot), math.sin(rot)
    local sideX, sideY = -dirY, dirX
    local pz = vehicle.z or 0

    -- step forward up to distance d
    for step = 1, math.floor(d) do
        local cx = vehicle.x + dirX * step
        local cy = vehicle.y + dirY * step

        -- span across vehicle width
        for offset = -halfW, halfW, 0.5 do
            local px = cx + sideX * offset
            local py = cy + sideY * offset
            local gx, gy = math.floor(px), math.floor(py)

            local square = getCell():getGridSquare(gx, gy, pz)
            if square then
                local zombie = square:getZombie()
                -- solid obstacle
                if not square:isFree(false) then
                    return true
                end
                -- zombie
                if zombie and zombie:isAlive() then
                    if zombie:getVariableBoolean("Bandit") then
                        if Bandit.IsHostile(zombie) then
                            return false -- bandit
                        else
                            return true -- friendly
                        end
                    end
                    return false -- zombie
                end
                -- player
                if square:getPlayer() then
                    return true
                end
                -- vehicle
                if square:getVehicleContainer() then
                    return true
                end
            else
                return true
            end

            -- check against FakeVehicles
            for _, other in ipairs(vt) do
                if other ~= vehicle then
                    local dx, dy = other.x - px, other.y - py
                    if dx * dx + dy * dy < 1.0 then -- within 1 tile radius
                        return true
                    end
                end
            end
        end
    end

    return false 
end

--[[
local function lookAheadRoadAngle(vehicle, maxDist, fanAngle, fanStep)
    local meta = getWorld():getMetaGrid()
    local x, y, z = vehicle.x, vehicle.y, vehicle.z
    local currentRot = vehicle.rot or 0
    local cell = getCell()

    maxDist = maxDist or 8       -- how many squares ahead to scan
    fanAngle = fanAngle or math.rad(90)  -- scan ±60° around current heading
    fanStep = fanStep or math.rad(15)     -- step between rays

    local bestAngle = currentRot
    local bestScore = -1

    -- Scan multiple directions within the fan
    for delta = -fanAngle, fanAngle, fanStep do
        local testAngle = currentRot + delta
        local score = 0

        for step = 1, maxDist do
            local nx = x + step * math.cos(testAngle)
            local ny = y + step * math.sin(testAngle)
            local zone = meta:getZoneAt(math.floor(nx), math.floor(ny), z)
            if zone and zone:getType() == "Nav" then
                local square = cell:getGridSquare(math.floor(nx), math.floor(ny), z)
                if square then
                    if not square:isFree(false) then
                        break
                    end
                end
                score = score + 1
            else
                break
            end
        end

        if score > bestScore then
            bestScore = score
            bestAngle = testAngle
        end
    end

    return bestAngle  -- in radians
end
]]

function getPitch(speed)
    -- Max speed per gear thresholds (end of gear speed)
    local maxSpeeds = {20, 40, 60, 80, 120}

    -- Base pitch at start of each gear
    local basePitches = {0.7, 1.4, 1.6, 1.85, 1.95}

    -- Max pitch at end of each gear
    local maxPitches = {2.0, 2.1, 2.15, 2.18, 3.2}

    -- Determine current gear based on speed
    local gear = #maxSpeeds  -- default gear (last)
    for i, maxSpeed in ipairs(maxSpeeds) do
        if speed <= maxSpeed then
            gear = i
            break
        end
    end

    -- Calculate gear start speed
    local gearStartSpeed = 0
    if gear > 1 then
        gearStartSpeed = maxSpeeds[gear - 1]
    end
    local gearEndSpeed = maxSpeeds[gear]

    -- Normalize speed within current gear [0..1]
    local normSpeed = (speed - gearStartSpeed) / (gearEndSpeed - gearStartSpeed)
    if normSpeed < 0 then normSpeed = 0 end
    if normSpeed > 1 then normSpeed = 1 end

    -- Interpolate pitch within gear
    local pitch = basePitches[gear] + normSpeed * (maxPitches[gear] - basePitches[gear])

    return pitch
end

local function getFrontPosition(vehicle, offset)
    local body = vehicle.parts.body
    local rot = vehicle.rot
    local dirX, dirY = math.cos(rot), math.sin(rot)

    -- distance from ref point to the front bumper
    local dist = (body.wheelbase or 3) + (body.frontOverhang or 0.5) + offset

    -- world coords of front center
    local fx = math.floor(vehicle.x + dirX * dist)
    local fy = math.floor(vehicle.y + dirY * dist)
    local fz = math.floor(vehicle.z + (body.zoffset or 0))

    return fx, fy, fz
end

------------------------------------------------
-- Vehicle manager
------------------------------------------------
local function manageVehicles(ticks)
    --- if not isIngameState() or isServer() then return end
    --- if ticks % tickSkip > 0 then return end

    local cell = getCell()
    local volume = getSoundManager():getSoundVolume()
    local fakeItem = BanditCompatibility.InstanceItem("Base.AssaultRifle")
    local fakeZombie = cell:getFakeZombieForHit()
    local fakeVehicle = BaseVehicle.new(cell)
    local zombieList = BanditZombie.CacheLight
    local vehicleList = BWOFakeVehicle.tab
    local multiplier = 0.25 / ((getAverageFPS() + 0.5))

    for _, vehicle in ipairs(vehicleList) do
        local body = vehicle.parts.body
        if body then
            ------------------------------------------------
            -- ROUTE FOLLOWING
            ------------------------------------------------
            local route = BWORoutes.routes[vehicle.routeId]
            if route then
                vehicle.routeIndex = vehicle.routeIndex or 1
                local point = route.points[vehicle.routeIndex]

                if point then
                    -- target position (center of tile)
                    local tx, ty = point.x, point.y
                    local dx, dy = tx - vehicle.x, ty - vehicle.y

                    -- target angle to point
                    local targetAngle = math.atan2(dy, dx)

                    -- normalize both to [-π, π)
                    local currentRot = normalizeAngle(vehicle.rot)
                    targetAngle = normalizeAngle(targetAngle)

                    -- shortest signed difference
                    local angleDiff = normalizeAngle(targetAngle - currentRot)

                    -- steering value
                    local maxSteer = 1
                    local steerGain = 2.0
                    vehicle.steer = math.max(-maxSteer, math.min(maxSteer, angleDiff * steerGain))

                    -- adjust speed from route point
                    if not vehicle.speed then vehicle.speed = 0 end

                    if isBlockedAhead(vehicle, 9, 2) then
                        vehicle.speed = vehicle.speed - 0.5 -- emergency break

                        --[[
                        if vehicle.speed < 0 then
                            vehicle.steer = -0.5
                        elseif vehicle.speed <= 10 then
                            vehicle.steer = 0.5
                        end]]

                        local em = vehicle.emitter2

                        if em and not em:isPlaying("BWOCarHorn1") and not em:isPlaying("BWOCarHorn2") and 
                                not em:isPlaying("BWOCarHorn3") and not em:isPlaying("BWOCarHorn4") and 
                                not em:isPlaying("BWOCarHorn5") then
                            local snd = "BWOCarHorn" .. (1 + ZombRand(5))
                            em:playSound(snd)
                        end
                    else
                        if vehicle.speed < point.s then
                            vehicle.speed = vehicle.speed + 0.1
                        elseif vehicle.speed > point.s then
                            vehicle.speed = vehicle.speed - 0.2
                        end
                    end
                    --if vehicle.speed < -10 then vehicle.speed = -10 end
                    if vehicle.speed < 0 then vehicle.speed = 0 end
                    vehicle.speed = round(vehicle.speed, 1)
                    --print (vehicle.speed)

                    -- distance check → advance to next point
                    local distSq = dx * dx + dy * dy
                    if distSq < 2 then
                        vehicle.routeIndex = vehicle.routeIndex + 1
                        if vehicle.routeIndex > #route.points then
                            vehicle.routeIndex = 1 -- loop route
                        end
                    end
                end
            end

            ------------------------------------------------
            -- SOUND MANAGEMENT
            ------------------------------------------------

            if not vehicle.emitter:isPlaying("BWO_FV_Sport_Loop") then
                vehicle.sid = vehicle.emitter:playSoundLooped("BWO_FV_Sport_Loop")
                vehicle.emitter:setVolume(vehicle.sid, volume)
            end

            if vehicle.sid then
                local pitch = getPitch(math.abs(vehicle.speed))
                -- vehicle.emitter:setPitch(vehicle.sid, pitch)
            end

            vehicle.emitter:setPos(vehicle.x, vehicle.y, 0)
            vehicle.emitter2:setPos(vehicle.x, vehicle.y, 0)

            vehicle.emitter:tick()
            vehicle.emitter2:tick()

            ------------------------------------------------
            -- LIGHT MANAGEMENT
            ------------------------------------------------
            for i = 1, 4 do
                local lx, ly, lz = getFrontPosition(vehicle, i * i)
                if not vehicle.ls then vehicle.ls = {} end

                local addNew = false
                if vehicle.ls[i] then
                    if vehicle.ls[i]:getX() ~= lx or vehicle.ls[i]:getY() ~= ly or vehicle.ls[i]:getZ() ~= lz then
                        cell:removeLamppost(vehicle.ls[i])
                        local ls = cell:getLightSourceAt(vehicle.ls[i]:getX(), vehicle.ls[i]:getY(), vehicle.ls[i]:getZ())
                        if ls then
                            cell:removeLamppost(ls)
                        end
                        addNew = true
                    end
                else
                    addNew = true
                end

                if addNew then
                    local lightSource = IsoLightSource.new(lx, ly, lz, LIGHT_COLOR.r, LIGHT_COLOR.g, LIGHT_COLOR.b, i * i, 10)
                    if lightSource then
                        cell:addLamppost(lightSource)
                        vehicle.ls[i] = lightSource
                    end
                end
            end

            ------------------------------------------------
            -- MOVEMENT INTEGRATION
            ------------------------------------------------
            local step = vehicle.speed * multiplier * tickSkip
            vehicle.rot = (vehicle.rot + (step / body.wheelbase) * math.tan(vehicle.steer)) % TWO_PI
            --vehicle.rot = round(vehicle.rot, 2)

            vehicle.x = vehicle.x + step * cos(vehicle.rot)
            vehicle.y = vehicle.y + step * sin(vehicle.rot)
            -- vehicle.x = round(vehicle.x, 6)
            -- vehicle.y = round(vehicle.y, 6)

            ------------------------------------------------
            -- UPDATE PARTS
            ------------------------------------------------
            for _, part in pairs(vehicle.parts) do
                UpdatePart(part, vehicle)
            end

            ------------------------------------------------
            -- COLLISIONS (BODY ONLY)
            ------------------------------------------------
            for id, chr in pairs(zombieList) do
                if inBoundary(body, vehicle, chr.x, chr.y) then
                    local chr = BanditZombie.GetInstanceById(chr.id)
                    if chr:isAlive() and chr:getActionStateName() ~= "hitreaction" then
                        --chr:Hit(fakeItem, fakeZombie, 2, false, 1, false)
                        chr:Hit(fakeVehicle, vehicle.speed, false, -4, -4)
                    end
                end
            end
        end
    end

    fakeItem = nil
    fakeZombie = nil
end

-- run simulation every tick
Events.OnTick.Add(manageVehicles)
