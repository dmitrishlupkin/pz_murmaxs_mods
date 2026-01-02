BWOVehicles = BWOVehicles or {}

BWOVehicles.tab = {}

BWOVehicles.carChoices = {"Base.CarLights", "Base.CarLuxury", "Base.CarNormal", "Base.CarStationWagon", 
                          "Base.CarTaxi", "Base.ModernCar", "Base.PickUpTruck", "Base.PickUpTruckLights", 
                          "Base.PickUpVan", "Base.PickUpVanLights", "Base.SUV", "Base.SmallCar", 
                          "Base.SportsCar", "Base.StepVan", "Base.Van"}

-- order is important
BWOVehicles.burnMap = {}

BWOVehicles.burnMap["Base.CarLights"] = "Base.CarNormalBurnt"
BWOVehicles.burnMap["Base.CarLuxury"] = "Base.LuxuryCarBurnt"
BWOVehicles.burnMap["Base.NormalCarPolice"] = "Base.NormalCarBurntPolice"
BWOVehicles.burnMap["Base.CarNormal"] = "Base.CarNormalBurnt"
BWOVehicles.burnMap["Base.CarStationWagon"] = "Base.CarNormalBurnt"
BWOVehicles.burnMap["Base.ModernCar"] = "Base.ModernCar02Burnt"
BWOVehicles.burnMap["Base.ModernCar02"] = "Base.SmallCar02Burnt"
BWOVehicles.burnMap["Base.SmallCar02"] = "Base.SmallCar02Burnt"
BWOVehicles.burnMap["Base.CarSmall02"] = "Base.SmallCar02Burnt"
BWOVehicles.burnMap["Base.SmallCar"] = "Base.SmallCarBurnt"
BWOVehicles.burnMap["Base.CarSmall"] = "Base.SmallCarBurnt"
BWOVehicles.burnMap["Base.SportsCar"] = "Base.SportsCarBurnt"
BWOVehicles.burnMap["Base.OffRoad"] = "Base.OffRoadBurnt"
BWOVehicles.burnMap["Base.LuxuryCar"] = "Base.LuxuryCarBurnt"
BWOVehicles.burnMap["Base.SUV"] = "Base.SUVBurnt"
BWOVehicles.burnMap["Base.Taxi"] = "Base.TaxiBurnt"
BWOVehicles.burnMap["Base.CarTaxi"] = "Base.TaxiBurnt"
BWOVehicles.burnMap["Base.CarTaxi2"] = "Base.TaxiBurnt"
BWOVehicles.burnMap["Base.PickUpVanLights"] = "Base.PickUpVanLightsBurnt"
BWOVehicles.burnMap["Base.PickUpVan"] = "Base.PickUpVanBurnt"
BWOVehicles.burnMap["Base.VanAmbulance"] = "Base.AmbulanceBurnt"
BWOVehicles.burnMap["Base.VanRadio"] = "Base.VanRadioBurnt"
BWOVehicles.burnMap["Base.VanSeats"] = "Base.VanSeatsBurnt"
BWOVehicles.burnMap["Base.Van"] = "Base.VanBurnt"
BWOVehicles.burnMap["Base.StepVan"] = "Base.VanBurnt" -- has no better alternative
BWOVehicles.burnMap["Base.PickupSpecial"] = "Base.PickupSpecialBurnt"
BWOVehicles.burnMap["Base.PickUpTruck"] = "Base.PickupBurnt"
BWOVehicles.burnMap["Base.Pickup"] = "Base.PickupBurnt"

BWOVehicles.parts = {}
BWOVehicles.parts[1] = "HeadlightLeft"
BWOVehicles.parts[2] = "HeadlightRight"
BWOVehicles.parts[3] = "HeadlightRearLeft"
BWOVehicles.parts[4] = "HeadlightRight"
BWOVehicles.parts[5] = "Windshield"
BWOVehicles.parts[6] = "WindshieldRear"
BWOVehicles.parts[7] = "WindowFrontRight"
BWOVehicles.parts[8] = "WindowFrontLeft"
BWOVehicles.parts[9] = "WindowRearRight"
BWOVehicles.parts[10] = "WindowRearLeft"
BWOVehicles.parts[11] = "WindowMiddleLeft"
BWOVehicles.parts[12] = "WindowMiddleRight"
BWOVehicles.parts[13] = "DoorFrontRight"
BWOVehicles.parts[14] = "DoorFrontLeft"
BWOVehicles.parts[15] = "DoorRearRight"
BWOVehicles.parts[16] = "DoorRearLeft"
BWOVehicles.parts[17] = "EngineDoor"
BWOVehicles.parts[18] = "TireFrontRight"
BWOVehicles.parts[19] = "TireFrontLeft"
BWOVehicles.parts[20] = "TireRearLeft"
BWOVehicles.parts[21] = "TireRearRight"

BWOVehicles.Register = function(vehicle)
    local id = vehicle:getId()
    BWOVehicles.tab[id] = vehicle
end

BWOVehicles.VehicleSpawn = function(x, y, dir, btype)
    local square = getCell():getGridSquare(x, y, 0)
    if square then

        if not square:isFree(false) then return end

        if square:isVehicleIntersecting() then return end

        local vehicle = BWOCompatibility.AddVehicle(btype, dir, square)
        if vehicle then
            for i = 0, vehicle:getPartCount() - 1 do
                local container = vehicle:getPartByIndex(i):getItemContainer()
                if container then
                    container:removeAllItems()
                end
            end
            vehicle:getModData().BWO = {}
            vehicle:getModData().BWO.wasRepaired = true
            BWOVehicles.Repair(vehicle)
            vehicle:setColor(ZombRandFloat(0, 1), ZombRandFloat(0, 1), ZombRandFloat(0, 1))
            vehicle:setAlarmed(false)
            vehicle:setGeneralPartCondition(100, 80)
            vehicle:setHeadlightsOn(true)
            vehicle:setPhysicsActive(true)

            -- NORTH x: -180 y: 0 z: 180
            -- SOUTH x: 0 y: 0 z: 0
            -- EAST x: -125 y: 90 z: 125
            -- WEST x: -125, y: -90, z: -125

            local md = vehicle:getModData()
            if not md.BWO then md.BWO = {} end

            if dir == IsoDirections.N then
                vehicle:setAngles(0, 180, 0)
                md.BWO.dir = "N"
            elseif dir == IsoDirections.S then
                vehicle:setAngles(0, 0, 0)
                md.BWO.dir = "S"
            elseif dir == IsoDirections.E then
                vehicle:setAngles(0, 90, 0)
                md.BWO.dir = "E"
            elseif dir == IsoDirections.W then
                -- vehicle:setAngles(-125, -90, -125)
                vehicle:setAngles(0, -90, 0)
                md.BWO.dir = "W"
            end

            local id = vehicle:getId()
            BWOVehicles.tab[id] = vehicle

            --[[
            if args.lightbar or args.siren or args.alarm then
                local newargs = {id=vehicle:getId(), lightbar=args.lightbar, siren=args.siren, alarm=args.alarm}
                sendServerCommand('Commands', 'UpdateVehicle', newargs)
            end
            ]]
        end
    end
end

BWOVehicles.Repair = function(vehicle)
    -- we cant use vehicle:replair() because it will add armor to ki5 vehicles

    for i = 0, vehicle:getPartCount() - 1 do
        local part = vehicle:getPartByIndex(i)
        local area = part:getArea()

        if area and not area:embodies("Armor") then
            local cond = 70 + ZombRand(40)
            if cond > 100 then cond = 100 end
            part:setCondition(cond)
        end
    end

    local gasTank = vehicle:getPartById("GasTank")
    if gasTank then
        local max = gasTank:getContainerCapacity() * 0.7
        gasTank:setContainerContentAmount(ZombRandFloat(0, max))
    end
end

BWOVehicles.Burn = function(vehicle)
    local burnMap = BWOVehicles.burnMap
    local scriptName = vehicle:getScriptName()
    if scriptName:embodies("Burnt") then return end

    for k, v in pairs(burnMap) do
        if scriptName:embodies(k) then
            local ax = vehicle:getAngleX()
            local ay = vehicle:getAngleY()
            local az = vehicle:getAngleZ()
            vehicle:permanentlyRemove()

            local vehicleBurnt = BWOCompatibility.AddVehicle(v, IsoDirections.S, vehicle:getSquare())
            if vehicleBurnt then
                for i = 0, vehicleBurnt:getPartCount() - 1 do
                    local container = vehicleBurnt:getPartByIndex(i):getItemContainer()
                    if container then
                        container:removeAllItems()
                    end
                end
                vehicleBurnt:getModData().BWO = {}
                vehicleBurnt:getModData().BWO.wasRepaired = true
                vehicleBurnt:setAngles(ax, ay, az)
            end
            break
        end
    end
end

BWOVehicles.FindSpawnPoint = function(player)
    
    -- detects orientation and width of the road
    local getInfo = function(x, y)
        local res = {}
        res.valid = false
  
        -- check in x
        local xlen = 0
        local xmin = math.huge
        local xmax = 0
        for i = -14, 14 do
            local dx = x + i
            if BanditUtils.HasZoneType(dx, y, 0, "Nav") then 
                xlen = xlen + 1 
                if dx < xmin then
                    xmin = dx
                end
                if dx > xmax then
                    xmax = dx
                end
            end
        end

        --check in y
        local ylen = 0
        local ymin = math.huge
        local ymax = 0
        for i = -14, 14 do
            local dy = y + i
            if BanditUtils.HasZoneType(x, dy, 0, "Nav") then 
                ylen = ylen + 1
                if dy < ymin then
                    ymin = dy
                end
                if dy > ymax then
                    ymax = dy
                end
            end
        end

        -- width: 14 - intercity roads
        -- width: 8 - city main roads

        if xlen > 20 and ylen >= 8 then
            res.valid = true
            res.orientation = "X" -- EW
            res.min = ymin
            res.max = ymax
            res.width = ylen
        elseif ylen > 20 and xlen >= 8 then
            res.valid = true
            res.orientation = "Y" -- EW
            res.min = xmin
            res.max = xmax
            res.width = xlen
        end

        return res
    end

    -- validates if the point is good for vehicle spawn
    local checkPoint = function(x, y)
        local res = {}
        res.valid = false

        if BanditUtils.HasZoneType(x, y, 0, "Nav") then
            local roadInfo = getInfo(x, y)
            if roadInfo.valid then
                res.valid = true
                if roadInfo.orientation == "X" then
                    res.toEast = {}
                    res.toEast.x = x - 50
                    res.toEast.y = roadInfo.max - 1
                    res.toEast.dir = IsoDirections.E
                    
                    res.toWest = {}
                    res.toWest.x = x + 50
                    res.toWest.y = roadInfo.min + 2
                    res.toWest.dir = IsoDirections.W

                    for dx=x-50, x+50, 5 do
                        local roadInfo = getInfo(dx, y)
                        if not roadInfo.valid then
                            res.valid = false
                            break
                        end
                    end
                else
                    res.toNorth = {}
                    res.toNorth.x = roadInfo.max - 1
                    res.toNorth.y = y + 50
                    res.toNorth.dir = IsoDirections.N
                    
                    res.toSouth = {}
                    res.toSouth.x = roadInfo.min + 2
                    res.toSouth.y = y - 50
                    res.toSouth.dir = IsoDirections.S

                    for dy=y-50, y+50, 5 do
                        local roadInfo = getInfo(x, dy)
                        if not roadInfo.valid then
                            res.valid = false
                            break
                        end
                    end
                end
            end
        end
        return res
    end

    local px = math.floor(player:getX()+0.5)
    local py = math.floor(player:getY()+0.5)

    -- find all possible spawn points
    local list = {}
    for x=px-25, px+25, 5 do
        local res = checkPoint (x, py)
        if res.valid then 
            table.insert(list, res)
        end
    end

    for y=py-25, py+25, 5 do
        local res = checkPoint (px, y)
        if res.valid then 
            table.insert(list, res)
        end
    end

    if #list == 0 then return end

    for i = #list, 2, -1 do
        local j = ZombRand(i) + 1
        list[i], list[j] = list[j], list[i]
    end

    local res = list[1]
    if res.valid then
        local x, y, dir
        local btype = BWOCompatibility.GetCarType(BanditUtils.Choice(BWOVehicles.carChoices))
        if res.toNorth and res.toSouth then
            if ZombRand(2) == 0 then
                x = res.toNorth.x
                y = res.toNorth.y
                dir = res.toNorth.dir
            else
                x = res.toSouth.x
                y = res.toSouth.y
                dir = res.toSouth.dir
            end
        elseif res.toEast and res.toWest then
            if ZombRand(2) == 0 then
                x = res.toEast.x
                y = res.toEast.y
                dir = res.toEast.dir
            else
                x = res.toWest.x
                y = res.toWest.y
                dir = res.toWest.dir
            end
        end
        BWOVehicles.VehicleSpawn(x, y, dir, btype)
    end
end

local dirMap = {}
dirMap.N = {}
for y=-12, -4 do
    for x=-1, 1 do
        table.insert(dirMap.N, {x=x, y=y})
    end
end

dirMap.S = {}
for y=4, 12 do
    for x=-1, 1 do
        table.insert(dirMap.S, {x=x, y=y})
    end
end

dirMap.W = {}
for x=-20, -4 do
    for y=-1, -1 do
        table.insert(dirMap.W, {x=x, y=y})
    end
end

dirMap.E = {}
for x=4, 12 do
    for y=-1, 1 do
        table.insert(dirMap.E, {x=x, y=y})
    end
end

BWOVehicles.dirMap = dirMap

local AddVehicles = function()

    if BWOScheduler.WorldAge > 168 then return end
    
    local player = getSpecificPlayer(0)
    if not player then return end

    local gametime = getGameTime()
    local hour = gametime:getHour()
    local minute = gametime:getMinutes()

    if minute % 2 == 1 then return end

    local cnt = 0
    for _, _ in pairs(BWOVehicles.tab) do
        cnt = cnt + 1
    end
    
    local max = 0
    if hour == 5 then
        max = math.floor(SandboxVars.BanditsWeekOne.VehiclesMax / 3)
    elseif hour >= 6 and hour < 19 then
        max = SandboxVars.BanditsWeekOne.VehiclesMax
    elseif hour >= 20 and hour < 23 then
        max = math.floor(SandboxVars.BanditsWeekOne.VehiclesMax / 3)
    end
    
    if cnt < max then
        BWOVehicles.FindSpawnPoint(player)
    end
end

local ManageVehicles = function(ticks)
    -- if true then return end
    if ticks % 6 > 0 then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    local dirMap = BWOVehicles.dirMap
    local vehicleList = BWOVehicles.tab
    for id, vehicle in pairs(vehicleList) do
        local controller = vehicle:getController()
        if not controller then
            BWOVehicles.tab[id] = nil
            break
        end

        if not vehicle:isSeatInstalled(0) then
            BWOVehicles.tab[id] = nil
            break
        end

        local square = vehicle:getSquare()
        if square then

            local chunk = vehicle:getChunk()
            local cell = square:getCell()
            local vx = vehicle:getX()
            local vy = vehicle:getY()
            local driver = vehicle:getDriver()
            if driver then
                if driver:isNPC() then 
                    local dist = BanditUtils.DistToManhattan(player:getX(), player:getY(), vehicle:getX(), vehicle:getY())
                    if dist > 51 then
                        local seat = vehicle:getSeat(driver)
                        vehicle:clearPassenger(seat)
                        driver:setVehicle(nil)
                        driver:setCollidable(true)
                        --driver:setHealth(0)
                        driver:Kill(nil)
                        driver:removeSaveFile()
                        driver:removeFromSquare()
                        driver:removeFromWorld()
                        vehicle:permanentlyRemove()
                        BWOVehicles.tab[id] = nil
                        
                        break
                    end

                    local md = vehicle:getModData()
                    if not md.BWO then md.BWO = {} end

                    local dir = md.BWO.dir
                    if dir then
                        local vecs = dirMap[dir]
                        for _, vec in pairs(vecs) do
                            local asquare = cell:getGridSquare(vx + vec.x, vy + vec.y, 0)
                            if asquare then
                                local shouldStop = false
                                local shouldAbandon = false

                                if not asquare:isFree(false) or asquare:isVehicleIntersecting() then
                                    shouldStop = true
                                    -- shouldAbandon = true
                                elseif asquare:getZombie() or (asquare:getPlayer() and not asquare:getPlayer():isNPC()) then
                                    local emitter = vehicle:getEmitter()
                                    -- if not emitter:isPlaying("VehicleHornStandard") then
                                    if not emitter:isPlaying("BWOCarHorn1") and not emitter:isPlaying("BWOCarHorn2") and 
                                            not emitter:isPlaying("BWOCarHorn3") and not emitter:isPlaying("BWOCarHorn4") and 
                                            not emitter:isPlaying("BWOCarHorn5") then
                                        emitter:playSound("BWOCarHorn" .. (1 + ZombRand(5)))
                                    end
                                    if not BWOScheduler.NPC.Run then
                                        shouldStop = true
                                    end
                                end

                                if shouldStop then
                                    -- vehicle:setForceBrake()
                                    vehicle:setRegulatorSpeed(0)
                                    vehicle:setRegulator(false)
                                    -- vehicle:setBraking(true)
                                    -- vehicle:setBrakingForce(100)


                                    if shouldAbandon and vehicle:isStopped() then

                                        BWOVehicles.tab[id] = nil

                                        --[[
                                        local emitter = vehicle:getEmitter()
                                        if emitter:isPlaying("VehicleHornStandard") then
                                            emitter:stopSoundByName("VehicleHornStandard")
                                        end]]

                                        vehicle:shutOff()
                                        vehicle:setHeadlightsOn(false)
                                        vehicle:playPassengerSound(0, "exit")

                                        -- vehicle:setPassenger(0, nil)
                                        local seat = vehicle:getSeat(driver)
                                        vehicle:clearPassenger(seat)
                                        driver:setVehicle(nil)
                                        driver:setCollidable(true)

                                        driver:removeFromSquare()
                                        driver:removeFromWorld()

                                        local doorPart = vehicle:getPartById("DoorFrontLeft")
                                        local exitSquare = doorPart:getSquare()
                                        
                                        config = {}
                                        config.clanId = 0
                                        config.hasRifleChance = 0
                                        config.hasPistolChance = 3
                                        config.rifleMagCount = 0
                                        config.pistolMagCount = 1

                                        local event = {}
                                        event.hostile = false
                                        event.occured = false
                                        event.program = {}
                                        event.program.name = "Walker"
                                        event.program.stage = "Prepare"
                                        event.x = square:getX()
                                        event.y = square:getY()
                                        event.bandits = {}

                                        local bandit = BanditCreator.MakeFromWave(config)
                                        bandit.weapons.melee = "Base.BareHands"
                                        table.insert(event.bandits, bandit)
                                        sendClientCommand(player, 'Commands', 'SpawnGroup', event)

                                    end
                                    return
                                end
                            end
                        end
                        local emitter = vehicle:getEmitter()
                        if emitter:isPlaying("VehicleHornStandard") then
                            emitter:stopSoundByName("VehicleHornStandard")
                        end
                        if vehicle:isStopped() then
                            -- vehicle:setBraking(false)
                            vehicle:setRegulator(true)
                            vehicle:setRegulatorSpeed(30 * SandboxVars.BanditsWeekOne.VehiclesSpeed)
                            -- vehicle:setCurrentSteering(-72) -- does not work
                            local test = vehicle:getCurrentSteering()   
                        end
                    end
                end
            else
                local npcAesthetics = SurvivorFactory.CreateSurvivor(SurvivorType.Neutral, false)
                npcAesthetics:setForename("Driver")
                npcAesthetics:setSurname("Driver")
                npcAesthetics:dressInNamedOutfit("Police")

                local driver = IsoPlayer.new(cell, npcAesthetics, square:getX(), square:getY(), square:getZ())

                driver:setSceneCulled(false)
                driver:setNPC(true)
                driver:setGodMod(true)
                driver:setInvisible(true)
                driver:setGhostMode(true)

                local vx = driver:getForwardDirection():getX()
                local vy = driver:getForwardDirection():getY()
                local forwardVector = Vector3f.new(vx, vy, 0)
                
                if vehicle:getChunk() then
                    --vehicle:enter(0, driver)

                    vehicle:setPassenger(0, driver, forwardVector)
                    driver:setVehicle(vehicle)
                    driver:setCollidable(false)

                    -- driver:enterVehicle(vehicle, 0, forwardVector)
                end

                --vehicle:setAngles(-180, 0, 180)
                vehicle:tryStartEngine(true)
                vehicle:engineDoStartingSuccess()
                vehicle:engineDoRunning()

                local radioPart = vehicle:getPartById("Radio")
                if radioPart then
                    local dd = radioPart:getDeviceData()
                    if dd then
                        dd:setIsTurnedOn(true)
                        dd:setChannel(98400)
                        dd:setDeviceVolume(0.8)
                    end
                end
            end
        end
    end
end

--[[
    local x = vehicle:getX()
    local y = vehicle:getY()
    local a = vehicle:getAngleY() - 90
    -- print ("VEH DEBUG: ID: " .. id .. " X: " .. x .. " Y: " .. y .. " A:" .. a)

    if a < -180 then a = a + 180 end

    local angle = a * math.pi * 0.00555555

    --- print ("VX: " .. vx .. " VY:" .. vy)

    local step = 0.2
    for i = 0, 14 do
        for j=-1, 1, 2 do
            local newangle = angle + (i * j * step)
            if newangle > 6.283185304 then newangle = newangle - 6.283185304 end

            local vx = x + math.floor(5 * math.cos(newangle) + 0.5)
            local vy = y + math.floor(5 * math.sin(newangle) + 0.5)
            local vz = 0

            local square = cell:getGridSquare(vx, vy, vz)
            if square then
                local groundType = BanditUtils.GetGroundType(square)
                if groundType == "street" then
                    local new = math.deg(newangle) + 90
                    if new > 180 then
                        new = new - 360
                    elseif new < -180 then
                        new = new + 360
                    end
                    if ticks % 200 == 0 then
                        -- print ("VX: " .. math.floor(vx) .. " VY:" .. math.floor(vy))
                        print ("A:" .. new)
                        vehicle:setAngles(vehicle:getAngleX(), new, vehicle:getAngleZ())
                    end
                    
                    return
                end
            end
        end
    end

    

]]

Events.OnTick.Add(ManageVehicles)
Events.EveryOneMinute.Add(AddVehicles)
