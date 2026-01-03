BWOJetEngine = BWOJetEngine or {}

BWOJetEngine.tab = {}
BWOJetEngine.tick = 0

function getSuctionCoords(x, y, tx, ty, triangle_dir_deg, tip_angle_deg, l)

    if math.abs(x-tx) > l then return end
    if math.abs(y-ty) > l then return end

    local tip_angle_rad = math.rad(tip_angle_deg)
    local half_angle = tip_angle_rad / 2
    local dir_rad = math.rad(triangle_dir_deg)

    -- Adjust for 180-degree rotated coordinate system:
    local function polarToXY(angle, length)
        local dx = -length * math.sin(angle) -- reversed X
        local dy = -length * math.cos(angle) -- reversed Y
        return dx, dy
    end

    -- Compute base corners
    local dx1, dy1 = polarToXY(dir_rad - half_angle, l)
    local dx2, dy2 = polarToXY(dir_rad + half_angle, l)

    local x1 = tx + dx1
    local y1 = ty + dy1
    local x2 = tx + dx2
    local y2 = ty + dy2

    -- Point-in-triangle test
    local function sign(px, py, qx, qy, rx, ry)
        return (px - rx) * (qy - ry) - (qx - rx) * (py - ry)
    end

    local b1 = sign(x, y, tx, ty, x1, y1) < 0
    local b2 = sign(x, y, x1, y1, x2, y2) < 0
    local b3 = sign(x, y, x2, y2, tx, ty) < 0

    if (b1 == b2) and (b2 == b3) then
        -- Inside triangle
        local dx = tx - x
        local dy = ty - y
        local dist2 = dx * dx + dy * dy
        local dist = math.sqrt(dist2)

        local epsilon = (l * l) / 9
        local A = 10 * epsilon
        local force = A / (dist2 + epsilon)

        -- Move toward tip
        local move_amount = 0.1 * force
        local dir_x = dx / dist
        local dir_y = dy / dist

        local new_x = x + dir_x * move_amount
        local new_y = y + dir_y * move_amount

        return new_x, new_y, force
    else
        return x, y, 0
    end
end

BWOJetEngine.Add = function(tab)
    table.insert(BWOJetEngine.tab, tab)
end

BWOJetEngine.Process = function()

    if isServer() then return end

    BWOJetEngine.tick = BWOJetEngine.tick + 1
    if BWOJetEngine.tick >= 16 then
        BWOJetEngine.tick = 0
    end

    if BWOJetEngine.tick % 2 == 0 then return end

    local cache = BanditZombie.CacheLight
    -- local killItem = item = BanditCompatibility.InstanceItem("Base.DoubleBarrelShotgun")
    local cell = getCell()
    for i, effect in pairs(BWOJetEngine.tab) do

        if not effect.emitter then
            local emitter = getWorld():getFreeEmitter(effect.x, effect.y, effect.z)
            emitter:playSound("BWOJetEngine")
            emitter:setVolumeAll(1)
            effect.emitter = emitter
        else
            if not effect.emitter:isPlaying("BWOJetEngine") then
                table.remove(BWOJetEngine.tab, i)
                local cell = getCell()
                local square = cell:getGridSquare(effect.x, effect.y, 0)
                if square then
                    local vehicle = square:getVehicleContainer()
                    if vehicle then
                        local trunkPart = vehicle:getPartById("TrunkDoor")
                        if trunkPart then
                            local trunkDoor = trunkPart:getDoor()
                            if trunkDoor then
                                trunkDoor:setOpen(true)
                            end
                        end
                    end
                end
                break
            end
        end

        for bid, czombie in pairs(cache) do
            if czombie.z == 0 then
                local nx, ny, force = getSuctionCoords(czombie.x, czombie.y, effect.x + 0.5, effect.y - 0.5, effect.dir, 60, 10)
                if nx and ny and force then
                    -- print ("nx: " .. nx .. " ny: " .. ny .. " f:" .. force)
                    
                    local zombie = BanditZombie.GetInstanceById(bid)
                    if zombie then
                        zombie:setX(nx)
                        zombie:setY(ny)
                        local dist = math.abs(effect.x-czombie.x) + math.abs(effect.y-czombie.y)
                        if dist < 0.9 then
                            zombie:splatBlood(3, 0.3)
                            zombie:splatBloodFloorBig()
                            zombie:splatBloodFloorBig()
                            zombie:splatBloodFloorBig()
                            zombie:removeFromSquare()
                            zombie:removeFromWorld()
                            effect.emitter:playSound("HeadSlice")
                            effect.emitter:playSound("BloodSplatter")
                            
                            args = {}
                            args.id = id
                            sendClientCommand(player, 'Commands', 'BanditRemove', args)
                        end
                    end
                end
            end
        end

        local player = getSpecificPlayer(0)
        local px, py, pz = player:getX(), player:getY(), player:getZ()
        if pz == 0 then
            local nx, ny, force = getSuctionCoords(px, py, effect.x - 0.5, effect.y - 0.5, effect.dir, 60, 10)
            if nx and ny and force then
                player:setX(nx)
                player:setY(ny)
                local dist = math.abs(effect.x-px) + math.abs(effect.y-py)
                if dist < 0.9 then
                    player:splatBloodFloorBig()
                    player:splatBloodFloorBig()
                    player:splatBloodFloorBig()
                    player:splatBloodFloorBig()
                    effect.emitter:playSound("HeadSlice")
                    effect.emitter:playSound("BloodSplatter")
                    player:setHealth(player:getHealth() - 0.1)
                    print ("should die")
                end
            end
        end
    end

    
end

Events.OnTick.Add(BWOJetEngine.Process)
