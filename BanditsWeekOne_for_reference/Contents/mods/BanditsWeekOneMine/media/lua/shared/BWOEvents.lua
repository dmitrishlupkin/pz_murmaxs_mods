BWOEvents = BWOEvents or {}

-- these is a set of various event functions that are triggered by time based on a schedule

local isInCircle = function(x, y, cx, cy, r)
    local d2 = (x - cx) ^ 2 + (y - cy) ^ 2
    return d2 <= r ^ 2
end

local findVehicleSpot2 = function(sx, sy)
    local player = getSpecificPlayer(0)
    if not player then return end

    local px = player:getX()
    local py = player:getY()
    local rmin = 20
    local rmax = 65
    local cell = getCell()
    for x=sx-rmax, sx+rmax, 5 do
        for y=sy-rmax, sy+rmax, 5 do
            if isInCircle(x, y, sx, sy, rmax) then
                if BanditUtils.HasZoneType(x, y, 0, "Nav") then
                    local dist = BanditUtils.DistToManhattan(x, y, px, py)
                    if dist > rmin then
                        local square = getCell():getGridSquare(x, y, 0)
                        if square then
                            local gt = BanditUtils.GetGroundType(square)
                            if gt == "street" then
                                local allFree = true
                                for dx=x-4, x+4 do
                                    for dy=y-4, y+4 do
                                        local dsquare = getCell():getGridSquare(dx, dy, 0)
                                        if dsquare then
                                            if not square:isFree(false) or square:getVehicleContainer() then
                                                allFree = false
                                            end
                                        end
                                    end
                                end
                                if allFree then
                                    return x, y
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local findBombSpot = function (px, py, outside)
    local x
    local y

    local miss = true
    if ZombRand(5) > 1 then
        -- find targets
        local zombieList = BanditZombie.GetAll()
        for by=-6, 6 do
            for bx=-6, 6 do
                local y1 = py + by * 6 - 3
                local y2 = py + by * 6 + 3
                local x1 = px + bx * 6 - 3
                local x2 = px + bx * 6 + 3
                
                local cnt = 0
                local killList = {}
                for id, zombie in pairs(zombieList) do
                    if zombie.x >= x1 and zombie.x < x2 and zombie.y >= y1 and zombie.y < y2 then
                        if not zombie.isBandit then
                            cnt = cnt + 1
                        end
                    end
                end
                if cnt > 4 then
                    miss = false
                    x = x1 - 2 + ZombRand(5)
                    y = y1 - 2 + ZombRand(5)
                    break
                end
            end
        end
    end

    -- if no targets then random miss
    if miss then
        local offset = 2
        local r = 88
        if outside then
            offset = 6  
            r = 55
        end

        local ox = offset + ZombRand(r)
        local oy = offset + ZombRand(r)

        if ZombRand(2) == 1 then ox = -ox end
        if ZombRand(2) == 1 then oy = -oy end

        x = px + ox
        y = py + oy
    end

    return x, y
end

local generateSpawnPoint = function(px, py, pz, d, count)
    
    local cell = getCell()
 
    local spawnPoints = {}
    table.insert(spawnPoints, {x=px+d, y=py+d, z=pz})
    table.insert(spawnPoints, {x=px+d, y=py-d, z=pz})
    table.insert(spawnPoints, {x=px-d, y=py+d, z=pz})
    table.insert(spawnPoints, {x=px-d, y=py-d, z=pz})
    table.insert(spawnPoints, {x=px+d, y=py, z=pz})
    table.insert(spawnPoints, {x=px-d, y=py, z=pz})
    table.insert(spawnPoints, {x=px, y=py+d, z=pz})
    table.insert(spawnPoints, {x=px, y=py-d, z=pz})
 
    local validSpawnPoints = {}
    for i, sp in pairs(spawnPoints) do
        local square = cell:getGridSquare(sp.x, sp.y, sp.z)
        if square then
            if square:isFree(false) then
                table.insert(validSpawnPoints, sp)
            end
        end
    end
 
    if #validSpawnPoints >= 1 then
        local p = 1 + ZombRand(#validSpawnPoints)
        local spawnPoint = validSpawnPoints[p]
        local ret = {}
        for i=1, count do
            table.insert(ret, spawnPoint)
        end
        return ret
    end
 
    return {}
end

local explode = function(x, y)
    
    local sounds = {"BurnedObjectExploded", "FlameTrapExplode", "SmokeBombExplode", "PipeBombExplode", "DOExploClose1", "DOExploClose2", "DOExploClose3", "DOExploClose4", "DOExploClose5", "DOExploClose6", "DOExploClose7", "DOExploClose8"}
        
    local function getSound()
        return sounds[1 + ZombRand(#sounds)]
    end
    
    local player = getSpecificPlayer(0)
    if not player then return end

    -- bomb sound
    local sound = getSound()
    local emitter = getWorld():getFreeEmitter(x, y, 0)
    emitter:playSound(sound)
    emitter:setVolumeAll(0.9)
    addSound(player, x, y, 0, 120, 100)

    -- wake up players
    BanditPlayer.WakeEveryone()
    
    -- explosion and fire
    local square = getCell():getGridSquare(x, y, 0)
    if not square then return end

    if isClient() then
        local args = {x=x, y=y, z=0}
        sendClientCommand('object', 'addExplosionOnSquare', args)
    else
        IsoFireManager.explode(getCell(), square, 100)
    end
    
    -- blast tex

    --[[
    local effect = {}
    effect.x = square:getX()
    effect.y = square:getY()
    effect.z = square:getZ()
    effect.offset = 320
    effect.name = "explo_big_01"
    effect.frameCnt = 17
    table.insert(BWOEffects.tab, effect)]]

    local effect = {}
    effect.x = square:getX()
    effect.y = square:getY()
    effect.z = square:getZ()
    effect.size = 640
    effect.colors = {r=0.1, g=0.7, b=0.2, a=0.2}
    effect.name = "explobig"
    effect.frameCnt = 17
    table.insert(BWOEffects2.tab, effect)
    
    -- light blast
    local colors = {r=1.0, g=0.5, b=0.5}
    local lightSource = IsoLightSource.new(x, y, 0, colors.r, colors.g, colors.b, 60, 10)
    getCell():addLamppost(lightSource)
                
    local lightLevel = square:getLightLevel(0)
    if lightLevel < 0.95 and player:isOutside() then
        local px = player:getX()
        local py = player:getY()
        local sx = square:getX()
        local sy = square:getY()

        local dx = math.abs(px - sx)
        local dy = math.abs(py - sy)

        local tex
        local dist = math.sqrt(math.pow(sx - px, 2) + math.pow(sy - py, 2))
        if dist > 40 then dist = 40 end

        if dx > dy then
            if sx > px then
                tex = "e"
            else
                tex = "w"
            end
        else
            if sy > py then
                tex = "s"
            else
                tex = "n"
            end
        end

        BWOTex.tex = getTexture("media/textures/blast_" .. tex .. ".png")
        BWOTex.speed = 0.05
        BWOTex.mode = "full"
        local alpha = 1.2 - (dist / 40)
        if alpha > 1 then alpha = 1 end
        BWOTex.alpha = alpha
    end
    
    -- junk placement
    BanditBaseGroupPlacements.Junk (x-4, y-4, 0, 6, 8, 3)

    -- damage to zombies, players are safe
    local fakeItem = BanditCompatibility.InstanceItem("Base.RollingPin")
    local cell = getCell()
    for dx=x-3, x+5 do
        for dy=y-3, y+4 do
            local square = cell:getGridSquare(dx, dy, 0)
            if square then
                if ZombRand(4) == 1 then
                    BanditBasePlacements.IsoObject("floors_burnt_01_1", dx, dy, 0)
                end
                local zombie = square:getZombie()
                if zombie then
                    zombie:Hit(fakeItem, cell:getFakeZombieForHit(), 50, false, 1, false)
                end
            end
        end
    end
end

local addBoomBox = function(x, y, z, cassette)
    local cell = getCell()
    local square = cell:getGridSquare(x, y, z)
    if not square then return end

    local surfaceOffset = BanditUtils.GetSurfaceOffset(x, y, z)
    local radioItem = square:AddWorldInventoryItem("Tsarcraft.TCBoombox", 0.5, 0.5, surfaceOffset)

    local radio = IsoRadio.new(cell, square, getSprite(TCMusic.WorldMusicPlayer[radioItem:getFullType()]))
    square:AddTileObject(radio)
    radio:getModData().tcmusic = {}
    radio:getModData().tcmusic.itemid = x .. y .. z
    radio:getModData().tcmusic.deviceType = "IsoObject"
    radio:getModData().tcmusic.isPlaying = false
    radio:getModData().RadioItemID = radioItem:getID() .. "tm"
    radio:getDeviceData():setIsTurnedOn(false)
    radio:getDeviceData():setPower(radioItem:getDeviceData():getPower())
    radio:getDeviceData():setDeviceVolume(radioItem:getDeviceData():getDeviceVolume())
    if radioItem:getDeviceData():getIsBatteryPowered() and radioItem:getDeviceData():getHasBattery() then
        radio:getDeviceData():setPower(radioItem:getDeviceData():getPower())
    else
        radio:getDeviceData():setHasBattery(false)
    end

    -- local cassetteItem = InventoryItemFactory.CreateItem("Tsarcraft.CassetteDepecheModePersonalJesus(1989)")
    local cassetteItem = BanditCompatibility.InstanceItem(cassette)
    radio:getModData().tcmusic.mediaItem = cassetteItem:getType()
    radio:transmitModData()

    if isClient() then 
        radio:transmitCompleteItemToServer(); 
    end
end

local addRadio = function(x, y, z)
    local cell = getCell()
    local square = cell:getGridSquare(x, y, z)
    if not square then return end

    --local surfaceOffset = BanditUtils.GetSurfaceOffset(x, y, z)
    -- local radioItem = square:AddWorldInventoryItem("appliances_radio_01_0", 0.5, 0.5, surfaceOffset)

    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        if instanceof(object, "IsoRadio") then
            return
        end
    end

    local radio = IsoRadio.new(cell, square, getSprite("appliances_radio_01_0"))
    square:AddTileObject(radio)
    radio:getDeviceData():setIsTurnedOn(false)
    radio:getDeviceData():setPower(0.5)
    radio:getDeviceData():setDeviceVolume(4)
    radio:getDeviceData():setHasBattery(true)
    return radio
end

local arrivalSound = function(x, y, sound)
    local player = getSpecificPlayer(0)
    if not player then return end

    local arrivalSoundX
    local arrivalSoundY
    if x < player:getX() then 
        arrivalSoundX = player:getX() - 30
    else
        arrivalSoundX = player:getX() + 30
    end

    if y < player:getY() then 
        arrivalSoundY = player:getY() - 30
    else
        arrivalSoundY = player:getY() + 30
    end

    local emitter = getWorld():getFreeEmitter(arrivalSoundX, arrivalSoundY, 0)
    emitter:setVolumeAll(0.5)
    emitter:playSound(sound)
end

local spawnVehicle = function(x, y, vtype)
    local cell = getCell()
    local square = getCell():getGridSquare(x, y, 0)
    if not square then return end

    local vehicle = BWOCompatibility.AddVehicle(vtype, IsoDirections.S, square)
    if not vehicle then return end

    for i = 0, vehicle:getPartCount() - 1 do
        local container = vehicle:getPartByIndex(i):getItemContainer()
        if container then
            container:removeAllItems()
        end
    end

    BWOVehicles.Repair(vehicle)
    vehicle:setTrunkLocked(true)
    for i=0, vehicle:getMaxPassengers() - 1 do 
        local part = vehicle:getPassengerDoor(i)
        if part then 
            local door = part:getDoor()
            if door then
                door:setLocked(true)
            end
        end
    end

    vehicle:getModData().BWO = {}
    vehicle:getModData().BWO.wasRepaired = true
    vehicle:setColor(0, 0, 0)
    -- vehicle:setGeneralPartCondition(80, 100)
    -- vehicle:putKeyInIgnition(key)
    -- vehicle:tryStartEngine(true)
    -- vehicle:engineDoStartingSuccess()
    -- vehicle:engineDoRunning()

    local gasTank = vehicle:getPartById("GasTank")
    if gasTank then
        local max = gasTank:getContainerCapacity() * 0.6
        gasTank:setContainerContentAmount(ZombRandFloat(0, max))
    end

    vehicle:setHeadlightsOn(false)
    vehicle:setLightbarLightsMode(3)

    return vehicle
end

-- params: [headlight(opt), lightbar(opt), alarm(opt)]
BWOEvents.VehiclesUpdate = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local vehicleList = getCell():getVehicles()
    
    for i=0, vehicleList:size()-1 do
        local vehicle = vehicleList:get(i)
        if vehicle and not vehicle:getDriver() then

            if params.headlights then
                vehicle:setHeadlightsOn(true)
            end
            
            if params.lightbar then
                if vehicle:hasLightbar() then
                    local mode = vehicle:getLightbarLightsMode()
                    if mode == 0 then
                        vehicle:setLightbarLightsMode(3)
                        -- vehicle:setLightbarSirenMode(2)
                    end
                end
            end

            if params.alarm then
                if not vehicle:hasLightbar() then
                    addSound(player, vehicle:getX(), vehicle:getY(), vehicle:getZ(), 150, 100)
                    BanditPlayer.WakeEveryone()
                    vehicle:setAlarmed(true)
                    vehicle:triggerAlarm()
                end
            end
        end
    end
end

-- fixme
BWOEvents.Explode = function(x, y)
    explode(x, y)
end


-- params: [x, y, sound]
BWOEvents.Sound = function(params)
    local emitter = getWorld():getFreeEmitter(params.x, params.y, 0)
    emitter:playAmbientSound(params.sound)
    emitter:setVolumeAll(1)
end

-- params: [x, y]
BWOEvents.Siren = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local emitter = getWorld():getFreeEmitter(params.x + 10, params.y - 20, 0)
    emitter:playAmbientSound("DOSiren2")
    emitter:setVolumeAll(0.9)
    addSound(player, params.x, params.y, params.z, 150, 100)
end

-- params: [on]
BWOEvents.SetHydroPower = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local day = getSandboxOptions():getElecShutModifier()
    if day > 0 and day < 8 then return end

    getWorld():setHydroPowerOn(params.on)
    if params.on == false then
        BWOEmitter.tab = {}
        player:playSound("WorldEventElectricityShutdown")
    end
end

-- params: [len]
BWOEvents.WeatherStorm = function(params)
    if isClient() then
        getClimateManager():transmitTriggerStorm(params.len)
    else
        getClimateManager():triggerCustomWeatherStage(WeatherPeriod.STAGE_STORM, params.len)
    end
end

BWOEvents.Say = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local color = player:getSpeakColour()
    player:addLineChatElement(params.txt, color:getR(), color:getG(), color:getB())
end

BWOEvents.Dream = function(params)

    if not SandboxVars.BanditsWeekOne.EventFinalSolution then return end

    if params.night == 0 then
        BWOScheduler.Add("Say", {txt="I had a strange dream."}, 2000)
        BWOScheduler.Add("Say", {txt="I was fiddling with an old radio, and I caught fragments of a broadcast. "}, 4000)
        BWOScheduler.Add("Say", {txt="The voice was shaky, cutting in and out, "}, 6000)
        BWOScheduler.Add("Say", {txt="but I remember hearing words like ‘emergency’ and ‘stay indoors.’"}, 8000)
        BWOScheduler.Add("Say", {txt="The static grew louder, drowning out the rest."}, 10000)
        BWOScheduler.Add("Say", {txt="... "}, 12000)
    elseif params.night == 1 then
        BWOScheduler.Add("Say", {txt="I was dreaming again."}, 2000)
        BWOScheduler.Add("Say", {txt="I was walking through a park."}, 4000)
        BWOScheduler.Add("Say", {txt="I remember looking around, calling out, but my voice echoed back at me."}, 6000)
        BWOScheduler.Add("Say", {txt="Suddenly I saw a stranger, trying to tell me something important."}, 8000)
        BWOScheduler.Add("Say", {txt="... "}, 10000)
    elseif params.night == 2 then
        BWOScheduler.Add("Say", {txt="Another dream."}, 2000)
        BWOScheduler.Add("Say", {txt="The sky was overcast, and everything felt heavy, like before a storm."}, 4000)
        BWOScheduler.Add("Say", {txt="In the distance, I saw this faint, flickering glow—maybe a fire?"}, 6000)
        BWOScheduler.Add("Say", {txt="It didn’t feel comforting, though. I couldn’t tell why, but it made me want to walk the other way. "}, 8000)
        BWOScheduler.Add("Say", {txt="Still, I couldn’t stop staring at it."}, 10000)
    elseif params.night == 3 then
        BWOScheduler.Add("Say", {txt="Dream again."}, 2000)
        BWOScheduler.Add("Say", {txt="I found myself inside a big building I didn’t recognize."}, 4000)
        BWOScheduler.Add("Say", {txt="I saw red light flickering and heard a terrible noise."}, 6000)
        BWOScheduler.Add("Say", {txt="Then I saw a man from my first dream. "}, 8000)
        BWOScheduler.Add("Say", {txt="He took his sword and wanted to give it to me. "}, 10000)
    elseif params.night == 4 then
        BWOScheduler.Add("Say", {txt="His name is Michael... I saw him again in my dream."}, 2000)
        BWOScheduler.Add("Say", {txt="It didn’t feel like a dream at all this time. "}, 4000)
        BWOScheduler.Add("Say", {txt="He gave me clear instructions to follow."}, 6000)
        BWOScheduler.Add("Say", {txt="Military Base, that’s where I have to go. "}, 8000)
        BWOScheduler.Add("Say", {txt="In the control room, I have to stop it. "}, 10000)
    elseif params.night == 5 then
        BWOScheduler.Add("Say", {txt="Military Base, that’s where I have to go. "}, 3000)
        if BanditCompatibility.GetGameVersion() >= 42 then
            BWOScheduler.Add("Say", {txt="In the control room, floor -16, I have to stop it. "}, 6000)
        else
            BWOScheduler.Add("Say", {txt="In the control room, ground floor, I have to stop it. "}, 6000)
        end
    elseif params.night == 6 then
        BWOScheduler.Add("Say", {txt="Military Base, that’s where I have to go. "}, 4000)
        BWOScheduler.Add("Say", {txt="In the control room, I have to stop it. "}, 9000)
        BWOScheduler.Add("Say", {txt="I feel that it’s urgent. "}, 12000)
    end
end

BWOEvents.Reanimate = function(params)
    local cell = getCell()
    local age = getGameTime():getWorldAgeHours()
    for z = -1, 2 do
        for x = -params.r, params.r do
            for y = -params.r, params.r do
                local square = cell:getGridSquare(params.x + x, params.y + y, params.z + z)
                if square then
                    local body = square:getDeadBody()
                    if body then

                        -- we found one body, but there my be more bodies on that square and we need to check all
                        local objects = square:getStaticMovingObjects()
                        for i=0, objects:size()-1 do
                            local object = objects:get(i)
                            if instanceof (object, "IsoDeadBody") then
                                local r = ZombRand(100)
                                if r < params.chance then
                                    object:setReanimateTime(age + ZombRandFloat(0.1, 0.7)) -- now plus 6 - 42 minutes
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- params: [x, y, sound]
BWOEvents.ChopperAlert = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    BanditPlayer.WakeEveryone()
    local emitter = getWorld():getFreeEmitter(params.x, params.y, 0)
    emitter:playAmbientSound(params.sound)
    emitter:setVolumeAll(0.9)
    addSound(player, params.x, params.y, params.z, 150, 100)
end

-- params: [x, y, sound]
BWOEvents.ChopperFliers = function(params)
    
    if not SandboxVars.BanditsWeekOne.EventFinalSolution then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    BanditPlayer.WakeEveryone()
    local emitter = getWorld():getFreeEmitter(params.x, params.y, 0)
    emitter:playAmbientSound("ZSAttack_Chopper_1")
    emitter:setVolumeAll(0.9)
    addSound(player, params.x, params.y, params.z, 150, 100)
    BWOScheduler.Add("ChopperFliersStage2", params, 10000)
    BWOScheduler.Add("ChopperFliersStage2", params, 12000)
    BWOScheduler.Add("ChopperFliersStage2", params, 13600)
end

BWOEvents.ChopperFliersStage2 = function(params)

    if not SandboxVars.BanditsWeekOne.EventFinalSolution then return end

    local cell = getCell()
    for y=-80, 80 do
        for x=-80, 80 do
            if ZombRand(65) == 1 then
                for z=8, 0, -1 do
                    local square = cell:getGridSquare(params.x + x, params.y + y, z)
                    if square and square:isOutside() then
                        local item = BWOCompatibility.GetFlier()
                        square:AddWorldInventoryItem(item, ZombRandFloat(0.2, 0.8), ZombRandFloat(0.2, 0.8), 0)
                        break
                    end
                end
            end
        end
    end
end

-- params: [icon]
BWOEvents.RegisterBase = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local building = player:getBuilding()
    if building then
        local buildingDef = building:getDef()
        local x = buildingDef:getX()
        local y = buildingDef:getY()
        local x2 = buildingDef:getX2()
        local y2 = buildingDef:getY2()

        local args = {x=x, y=y, x2=x2, y2=y2}
        sendClientCommand(player, 'Commands', 'BaseUpdate', args)
    end
end

-- params: []
BWOEvents.Start = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local profession = player:getDescriptor():getProfession()
    local cell = getCell()
    local building = player:getBuilding()
    if building then
        local buildingDef = building:getDef()
        local keyId = buildingDef:getKeyId()

        -- register player home
        local args = {id=keyId, event="home", x=(buildingDef:getX() + buildingDef:getX2()) / 2, y=(buildingDef:getY() + buildingDef:getY2()) / 2}
        sendClientCommand(player, 'Commands', 'EventBuildingAdd', args)

        -- generate home key
        local item = BanditCompatibility.InstanceItem("Base.Key1")
        item:setKeyId(keyId)
        item:setName("Home Key")
        player:getInventory():AddItem(item)

        -- show home icon
        if SandboxVars.Bandits.General_ArrivalIcon then
            local x = buildingDef:getX()
            local y = buildingDef:getY()
            local x2 = buildingDef:getX2()
            local y2 = buildingDef:getY2()

            local icon = "media/ui/defend.png"
            local color = {r=0.5, g=1, b=0.5} -- GREEN
            local desc = "Home"
            BanditEventMarkerHandler.set(getRandomUUID(), icon, 604800, (x + x2) / 2, (y + y2) / 2, color, desc)
        end
    end

    -- give some starting cash
    for i=1, 25 + ZombRand(60) do
        local item = BanditCompatibility.InstanceItem("Base.Money")
        player:getInventory():AddItem(item)
    end
    
    -- profession items
    local professionItemTypeList
    local professionSubItemTypeList
    if profession == "fireofficer" then
        professionItemTypeList = {"Base.Axe", "Base.Extinguisher"}
    elseif profession == "parkranger" then
        professionItemTypeList = {"Base.Bag_SurvivorBag"}
    elseif profession == "mechanics" then
        professionSubItemTypeList = {"Base.Wrench", "Base.TireIron", "Base.Ratchet", "Base.Jack", "Base.LightBulbBox"}
        professionItemTypeList = {"Base.Toolbox_Mechanic"}
    elseif profession == "lumberjack" then
        professionItemTypeList = {"Base.Woodaxe"}
    elseif profession == "doctor" then
        professionSubItemTypeList = {"Base.Bandage", "Base.Bandage", "Base.Bandage", "Base.Bandage", "Base.AlcoholWipes", "Base.SutureNeedle", "Base.SutureNeedle", "Base.Tweezers"}
        professionItemTypeList = {"Base.Bag_Satchel_Medical"}
    elseif profession == "policeofficer" then
        professionItemTypeList = {"Base.Nightstick"}
    elseif profession == "veteran" then
        professionItemTypeList = {"Base.HuntingRifle", "Base.308Box"}
    end
    
    if professionItemTypeList then
        for _, professionItemType in pairs(professionItemTypeList) do
            local professionItem = BanditCompatibility.InstanceItem(professionItemType)
            if professionSubItemTypeList then
                local container = professionItem:getItemContainer()
                for _, professionSubItemType in pairs(professionSubItemTypeList) do
                    local professionSubItem = BanditCompatibility.InstanceItem(professionSubItemType)
                    container:AddItem(professionSubItem)
                end
            end
            player:getInventory():AddItem(professionItem)
        end
    end

    -- spawn babe
    if SandboxVars.BanditsWeekOne.StartBabe then

        local args = {
            cid = "a3bd90b9-aa08-44b2-8be3-a6dfcf15f9e1", 
            program = "Babe",
            permanent = 1,
            loyal = true,
            occupation = "Babe",
            size = 1,
            x = player:getX() + 1,
            y = player:getY() + 1,
            z = player:getZ()
        }

        if player:isFemale() then
            args.cid = "303cd279-a36a-4e4a-b448-ac1ef1c83b7d"
        end
                
        sendClientCommand(player, 'Spawner', 'Clan', args)
    end

    -- spawn vehicle if there is a spot
    if SandboxVars.BanditsWeekOne.StartRide then
        local px = player:getX()
        local py = player:getY()
        local zone
        local distMin = math.huge
        for x = -40, 40 do
            for y =-40, 40 do
                local testZone = getVehicleZoneAt(px + x, py + y, 0)
                if testZone then
                    local zx = testZone:getX()
                    local zy = testZone:getY()

                    local dist = BanditUtils.DistTo(px, py, zx, zy)
                    if dist < distMin then
                        zone = testZone
                        distMin = dist
                    end
                end
            end
        end

        -- check if vehicle is already there
        if zone then
            local x1 = zone:getX()
            local y1 = zone:getY()
            local w = zone:getWidth()
            local h = zone:getHeight()
            local x2 = x1 + w
            local y2 = y1 + h

            local vehicle
            for x=x1, x2 do
                for y=y1, y2 do
                    local square = cell:getGridSquare(x, y, 0)
                    if square then
                        local testVehicle = square:getVehicleContainer() 
                        if testVehicle then
                            vehicle = testVehicle
                        end
                    end
                end
            end

            if not vehicle then
                local sx
                local sy
                local dir
                if w > h then
                    sx = x1 + 3.5
                    sy = y1 + 2
                    dir = "E"
                else
                    sx = x1 + 2
                    sy = y1 + 3.5
                    dir = "S"
                end
                
                local carType = "Base.SmallCar"
                if profession == "fireofficer" then
                    carType = "PickUpTruckLightsFire"
                elseif profession == "policeofficer" then
                    carType = "PickUpVanLightsPolice"
                elseif profession == "mechanics" then
                    carType = "SportsCar"
                end

                vehicle = spawnVehicle(sx, sy, BWOCompatibility.GetCarType(carType))
                if vehicle then
                    if dir == "S" then
                        vehicle:setAngles(0, 0, 0)
                    elseif dir == "E" then
                        vehicle:setAngles(0, 90, 0)
                    end
                end
            end

            if vehicle then
                local key = vehicle:getCurrentKey()
                if not key then 
                    key = vehicle:createVehicleKey()
                end

                local inventory = player:getInventory()
                player:getInventory():AddItem(key)
            end
        end
    end
    BWOScheduler.Add("Say", {txt="TIP: Press \"T\" to chat with other people."}, 16000)
    BWOScheduler.Add("Say", {txt="TIP: Press \"T\" to chat with other people."}, 32000)
    -- BWOScheduler.Add("Say", {txt="TIP: Press \"T\" to chat with other people."}, 41000)
end

-- params: [day]
BWOEvents.StartDay = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    player:playSound("ZSDayStart")
    
    BWOTex.tex = getTexture("media/textures/day_" .. params.day .. ".png")
    BWOTex.speed = 0.011
    BWOTex.mode = "center"
    BWOTex.alpha = 2.4
end

-- params: [x, y]
BWOEvents.Jets = function(params)
    local sound = "DOJet"

    local jet1 = {}
    jet1.x = params.x - 8
    jet1.y = params.y + 8
    jet1.sound = sound
    BWOScheduler.Add("Sound", jet1, 1)

    local jet2 = {}
    jet2.x = params.x + 8
    jet2.y = params.y - 8
    jet2.sound = sound
    BWOScheduler.Add("Sound", jet2, 300)
end

-- params: []
BWOEvents.Arson = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local density = BWOBuildings.GetDensityScore(player, 120) / 6000
    if density < 0.3 then return end

    local building = BWOBuildings.FindBuildingDist(player, 35, 50)
    if not building then return end

    local room = building:getRandomRoom()
    if not room then return end

    local square = room:getRandomSquare()
    if not square then return end

    explode(square:getX(), square:getY())
    local vparams = {}
    vparams.alarm = true
    BWOScheduler.Add("VehiclesUpdate", vparams, 500)

    if SandboxVars.Bandits.General_ArrivalIcon then
        local icon = "media/ui/arson.png"
        local color = {r=1, g=0, b=0} -- red
        local desc = "Arson"
        BanditEventMarkerHandler.set(getRandomUUID(), icon, 3600, square:getX(), square:getY(), color, desc)
    end
end

-- params: [x, y, outside]
BWOEvents.BombDrop = function(params)
    local affectedZones = {}
    affectedZones.Forest = false
    affectedZones.DeepForest = false
    affectedZones.Nav = true
    affectedZones.Vegitation = false
    affectedZones.TownZone = true
    affectedZones.Ranch = false
    affectedZones.Farm = true
    affectedZones.TrailerPark = true
    affectedZones.ZombiesType = false
    affectedZones.FarmLand = false
    affectedZones.LootZone = true
    affectedZones.ZoneStory = true

    local function isAffectedZone(zoneType)
        for zt, zv in pairs(affectedZones) do
            if zoneType == zt and zv then return true end
        end

        return false
    end

    if BWOSquareLoader.IsInExclusion(params.x, params.y) then return end

    -- where it hits
    local x, y = findBombSpot(params.x, params.y, params.outside)
    -- local x, y = params.x, params.y
    -- strike only in urban area
    local zone = getWorld():getMetaGrid():getZoneAt(x, y, 0)
    if zone then
        local zoneType = zone:getType()
        if isAffectedZone(zoneType) then

            explode(x, y)

            -- junk placement
            BanditBaseGroupPlacements.Junk (x-4, y-4, 0, 6, 8, 3)

            -- damage to zombies, players are safe
            local fakeItem = BanditCompatibility.InstanceItem("Base.RollingPin")
            local cell = getCell()
            for dx=x-3, x+5 do
                for dy=y-3, y+4 do
                    local square = cell:getGridSquare(dx, dy, 0)
                    if square then
                        if ZombRand(4) == 1 then
                            BanditBasePlacements.IsoObject("floors_burnt_01_1", dx, dy, 0)
                        end
                        local zombie = square:getZombie()
                        if zombie then
                            zombie:Hit(fakeItem, cell:getFakeZombieForHit(), 50, false, 1, false)
                        end
                    end
                end
            end
        end
    end
end

-- params: [x, y, intensity, outside]
BWOEvents.BombRun = function(params)
    local jets = {}

    if BWOSquareLoader.IsInExclusion(params.x, params.y) then return end

    jets.x = params.x
    jets.y = params.y
    BWOScheduler.Add("Jets", jets, 1)

    if not params.intensity then params.intensity = 4 end

    local d = 15000
    for i = 0, params.intensity do
        local bomb = {}
        bomb.x = params.x
        bomb.y = params.y
        bomb.outside = params.outside

        d = d + 77 + ZombRand(254)
        BWOScheduler.Add("BombDrop", bomb, d)

        if i == 0 then
            local vparams = {}
            vparams.alarm = true
            BWOScheduler.Add("VehiclesUpdate", vparams, d + 10)
        end
    end
end

-- params: []
BWOEvents.SetupNukes = function(params)

    local addNuke = function(x, y, r)
        BWOServer.Commands.NukeAdd(getSpecificPlayer(0), {x=x, y=y, r=r})
    end

    addNuke(10800, 9800, 700) -- muldraugh
    addNuke(10040, 12760, 700) -- march ridge
    addNuke(8160, 11550, 700) -- rosewood
    addNuke(7267, 8320, 700) -- doe valley
    addNuke(6350, 5430, 700) -- riverside
    addNuke(11740, 6900, 700) -- westpoint
    addNuke(646, 9734, 600) -- ekron
    addNuke(12980, 2256, 1200) -- LV

    if BanditCompatibility.GetGameVersion() >= 42 then
        addNuke(2060, 5930, 700) -- brandenburg
        addNuke(2336, 14294, 800) -- irvington
    end

end

BWOEvents.SetupPlaceEvents = function(params)

    local addPlaceEvent = function(args)
        BWOServer.Commands.PlaceEventAdd(getSpecificPlayer(0), args)
    end

    -- muldrough road blocks
    addPlaceEvent({phase="ArmyGuards", x=10592, y=10675, z=0})

    for i = 0, 14 do
        addPlaceEvent({phase="AbandonedVehicle", x=10587, y=10660 - (i * 6), z=0, dir=IsoDirections.S})
    end

    for i = 0, 3 do
        addPlaceEvent({phase="AbandonedVehicle", x=10597, y=10685 + (i * 6), z=0, dir=IsoDirections.N})
    end

    addPlaceEvent({phase="ArmyGuards", x=10790, y=10706, z=0})
    addPlaceEvent({phase="ArmyGuards", x=11091, y=9317, z=0})
    addPlaceEvent({phase="ArmyGuards", x=10962, y=8932, z=0})
    addPlaceEvent({phase="ArmyGuards", x=10591, y=9152, z=0})

    for i = 0, 4 do
        addPlaceEvent({phase="AbandonedVehicle", x=10587, y=9140 - (i * 6), z=0, dir=IsoDirections.S})
    end

    for i = 0, 10 do
        addPlaceEvent({phase="AbandonedVehicle", x=10597, y=9153 + (i * 6), z=0, dir=IsoDirections.N})
    end

    addPlaceEvent({phase="ArmyGuards", x=10579, y=9736, z=0})

    -- march ridge road blocks
    addPlaceEvent({phase="ArmyGuards", x=10361, y=12419, z=0})
    addPlaceEvent({phase="ArmyGuards", x=10363, y=12397, z=0})

    -- dixie
    addPlaceEvent({phase="ArmyGuards", x=11405, y=8764, z=0})
    addPlaceEvent({phase="ArmyGuards", x=11643, y=8694, z=0})

    -- westpoint
    addPlaceEvent({phase="ArmyGuards", x=11753, y=7182, z=0})
    addPlaceEvent({phase="ArmyGuards", x=11708, y=7147, z=0})
    addPlaceEvent({phase="ArmyGuards", x=11094, y=6900, z=0})
    addPlaceEvent({phase="ArmyGuards", x=12165, y=7182, z=0})
    addPlaceEvent({phase="ArmyGuards", x=12166, y=6899, z=0})

    -- GUNSHOP GUARDS
    addPlaceEvent({phase="GunshopGuard", x=12085, y=6785, z=0})
    addPlaceEvent({phase="GunshopGuard", x=12088, y=6782, z=0})

    -- riverside
    -- fixme - we need other cities too

    -- mechanic cars - since b42 we can spawn cars in buildings - yay
    addPlaceEvent({phase="CarMechanic", x=5467, y=9652, z=0, dir=IsoDirections.E}) -- riverside
    addPlaceEvent({phase="CarMechanic", x=5467, y=9661, z=0, dir=IsoDirections.E}) -- riverside
    addPlaceEvent({phase="CarMechanic", x=10610, y=9405, z=0, dir=IsoDirections.E}) -- muldraugh
    addPlaceEvent({phase="CarMechanic", x=10610, y=9410, z=0, dir=IsoDirections.E}) -- muldraugh
    addPlaceEvent({phase="CarMechanic", x=10179, y=10936, z=0, dir=IsoDirections.W}) -- muldraugh
    addPlaceEvent({phase="CarMechanic", x=10179, y=10945, z=0, dir=IsoDirections.W}) -- muldraugh
    addPlaceEvent({phase="CarMechanic", x=5430, y=5960, z=0, dir=IsoDirections.E}) -- riverside
    addPlaceEvent({phase="CarMechanic", x=5430, y=5964, z=0, dir=IsoDirections.E}) -- riverside
    addPlaceEvent({phase="CarMechanic", x=8151, y=11322, z=0, dir=IsoDirections.W}) -- rosewood
    addPlaceEvent({phase="CarMechanic", x=8151, y=11331, z=0, dir=IsoDirections.W}) -- rosewood
    addPlaceEvent({phase="CarMechanic", x=11897, y=6809, z=0, dir=IsoDirections.N}) -- westpoint
    addPlaceEvent({phase="CarMechanic", x=12274, y=6927, z=0, dir=IsoDirections.W}) -- westpoint
    addPlaceEvent({phase="CarMechanic", x=12274, y=6934, z=0, dir=IsoDirections.W}) -- westpoint

    -- defender teams
    addPlaceEvent({phase="BaseDefenders", x=5572, y=12489, z=0, intensity = 2}) -- control room
    addPlaceEvent({phase="BaseDefenders", x=5582, y=12486, z=0, intensity = 3}) -- entrance in
    addPlaceEvent({phase="BaseDefenders", x=5582, y=12480, z=0, intensity = 3}) -- entrance in
    addPlaceEvent({phase="BaseDefenders", x=5586, y=12483, z=0, intensity = 2}) -- entrance out
    addPlaceEvent({phase="BaseDefenders", x=5573, y=12484, z=0, intensity = 1}) -- door
    addPlaceEvent({phase="BaseDefenders", x=5609, y=12483, z=0, intensity = 4}) -- gateway
    addPlaceEvent({phase="BaseDefenders", x=5833, y=12490, z=0, intensity = 2}) -- booth
    addPlaceEvent({phase="BaseDefenders", x=5831, y=12484, z=0, intensity = 4}) -- szlaban
    addPlaceEvent({phase="BaseDefenders", x=5530, y=12489, z=0, intensity = 5}) -- back
    -- addPlaceEvent({phase="BaseDefenders", x=5558, y=12447, z=-16, intensity = 3}) -- underground armory

end

-- params: []
BWOEvents.FinalSolution = function(params2)

    if not SandboxVars.BanditsWeekOne.EventFinalSolution then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    local px = player:getX()
    local py = player:getY()
    local params = {}
    params.x = px
    params.y = py
    params.r = 80

    local gmd = GetBWOModData()
    local nukes = gmd.Nukes
    
    local cnt = 0
    for _, nuke in pairs(nukes) do
        cnt = cnt + 1
    end

    if cnt > 0 then
        player:playSound("UIBWOMusic4")
        local ct = 100
        for _, nuke in pairs(nukes) do

            if isInCircle(px, py, nuke.x, nuke.y, nuke.r) then
                BWOScheduler.Add("Nuke", params, 50000)
            else
                BWOScheduler.Add("NukeDist", nuke, ct)
                ct = ct + 4000 + ZombRand(10000)
            end
        end

        BWOScheduler.Add("WeatherStorm", {len=1440}, 1000)
    end
end

-- params: [x, y, outside]
BWOEvents.Nuke = function(params)

    if not SandboxVars.BanditsWeekOne.EventFinalSolution then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    BWOTex.speed = 0.018
    BWOTex.tex = getTexture("media/textures/mask_white.png")
    BWOTex.mode = "full"
    BWOTex.alpha = 3
    player:playSound("DOKaboom")

    args = {}
    args.x = params.x
    args.y = params.y
    args.r = params.r
    sendClientCommand(player, 'Commands', 'Nuke', args)

    local zombieList = BanditZombie.GetAll()
    for id, z in pairs(zombieList) do
        local dist = math.sqrt(math.pow(z.x - params.x, 2) + math.pow(z.y - params.y, 2))
        if dist < params.r then
            local character = BanditZombie.GetInstanceById(id)
            if character and character:getZ() >= 0 then
                character:SetOnFire()
            end
        end
    end

    if player:getZ() >= 0 then
        player:SetOnFire()
    end
end

-- params: [x, y, outside]
BWOEvents.NukeDist = function(params)

    if not SandboxVars.BanditsWeekOne.EventFinalSolution then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    BWOTex.speed = 0.05
    BWOTex.tex = getTexture("media/textures/mask_white.png")
    BWOTex.mode = "full"
    BWOTex.alpha = 1.1
    player:playSound("BWOKaboomDist")

    local banditList = BanditZombie.GetAllB()
    for  id, _ in pairs(banditList) do
        local bandit = BanditZombie.GetInstanceById(id)
        Bandit.Say(bandit, "STREETCHATFINAL")
    end
end

-- params: [x, y, outside]
BWOEvents.JetFighter = function(params)

    if BWOSquareLoader.IsInExclusion(params.x, params.y) then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    local zombieList = BanditZombie.GetAll()
    for by=-1, 1 do
        for bx=-1, 1 do
            local y1 = params.y + by * 20 - 10
            local y2 = params.y + by * 20 + 10
            local x1 = params.x + bx * 20 - 10
            local x2 = params.x + bx * 20 + 10
            
            local cnt = 0
            local killList = {}
            for id, zombie in pairs(zombieList) do
                if zombie.x > x1 and zombie.x < x2 and zombie.y > y1 and zombie.y < y2 then
                    -- the strike is counting zombies only, but if threshold is reached all in the area will be affected
                    if not zombie.isBandit then
                        cnt = cnt + 1
                    end
                    killList[zombie.id] = zombie
                end
            end

            if cnt >= 10 then
                local fakeItem = BanditCompatibility.InstanceItem("Base.AssaultRifle")
                local fakeZombie = getCell():getFakeZombieForHit()
                for id, zombie in pairs(killList) do
                    local character = BanditZombie.GetInstanceById(id)
                    if character and character:isOutside() then
                        character:Hit(fakeItem, fakeZombie, 1 + ZombRand(20), false, 1, false)
                        -- SwipeStatePlayer.splash(character, fakeItem, fakeZombie)
                    end
                end

                if outside and params.x > x1 and params.x < x2 and params.y > y1 and params.y < y2 then
                    if ZombRand(4) == 0 then
                        player:Hit(fakeItem, fakeZombie, 0.8, false, 1, false)
                        -- SwipeStatePlayer.splash(player, fakeItem, fakeZombie)
                    end
                end

                local sound = "DOA10"
                local emitter = getWorld():getFreeEmitter(x1+10, y1+10, 0)
                emitter:playSound(sound)
                emitter:setVolumeAll(0.9)
                addSound(player, x1+10, y1+10, 0, 120, 100)
                return
            end
        end
    end
end

-- params: [x, y, intensity, outside]
BWOEvents.JetFighterRun = function(params)

    if BWOSquareLoader.IsInExclusion(params.x, params.y) then return end

    local jets = {}
    jets.x = params.x
    jets.y = params.y
    BWOScheduler.Add("Jets", jets, 1)

    if not params.intensity then params.intensity = 1 end

    local d = 14000
    for i = 0, params.intensity do
        local bomb = {}
        bomb.x = params.x
        bomb.y = params.y
        bomb.outside = params.outside

        d = d + 77 + ZombRand(254)
        BWOScheduler.Add("JetFighter", bomb, d)
    end
end

-- params: [x, y, intensity, outside]
BWOEvents.GasRun = function(params)

    if BWOSquareLoader.IsInExclusion(params.x, params.y) then return end

    local jets = {}
    jets.x = params.x
    jets.y = params.y
    BWOScheduler.Add("Jets", jets, 1)

    if not params.intensity then params.intensity = 1 end

    local d = 14000
    for i = 0, params.intensity do
        local bomb = {}
        bomb.x = params.x
        bomb.y = params.y
        bomb.outside = params.outside

        d = d + 79 + ZombRand(239)
        BWOScheduler.Add("GasDrop", bomb, d)
    end
end

-- params: [x, y, outside]
BWOEvents.GasDrop = function(params)

    if BWOSquareLoader.IsInExclusion(params.x, params.y) then return end

    local x, y = findBombSpot(params.x, params.y, params.outside)
    -- local x, y = params.x, params.y
    local svec = {}
    table.insert(svec, {x=-3, y=-1})
    table.insert(svec, {x=3, y=1})
    table.insert(svec, {x=-1, y=-3})
    table.insert(svec, {x=1, y=3})

    for _, v in pairs(svec) do
        --[[local effect = {}
        effect.x = x + v.x
        effect.y = y + v.y
        effect.z = 0
        effect.offset = 300
        effect.poison = true
        effect.colors = {r=0.1, g=0.7, b=0.2, a=0.2}
        effect.name = "mist_01"
        effect.frameCnt = 60
        effect.frameRnd = true
        effect.repCnt = 10
        table.insert(BWOEffects.tab, effect)]]

        local effect = {}
        effect.x = x + v.x
        effect.y = y + v.y
        effect.z = 0
        effect.size = 600
        effect.poison = true
        effect.colors = {r=0.1, g=0.7, b=0.2, a=0.2}
        effect.name = "mist"
        effect.frameCnt = 60
        effect.repCnt = 9
        table.insert(BWOEffects2.tab, effect)
    end

    local colors = {r=0.2, g=1.0, b=0.3}
    local lightSource = IsoLightSource.new(x, y, 0, colors.r, colors.g, colors.b, 60, 10)
    getCell():addLamppost(lightSource)

    local emitter = getWorld():getFreeEmitter(x, y, 0)
    emitter:playSound("DOGas")
    emitter:setVolumeAll(0.25)
end

-- params: [x, y, z]
BWOEvents.PlaneCrash = function(params)
    BWOScheduler.Add("PlaneCrashStage", {x=params.x, y=params.y, z=params.z, stageName="AddCockpit"}, 100)
end

-- params: [x, y, z, stageName]
BWOEvents.PlaneCrashStage = function(params)
    PPPlane[params.stageName](params.x, params.y, -1)
end

-- params: []
BWOEvents.ProtestAll = function(params)
    local cnt = 100
    for _, pcoords in pairs(BWOSquareLoader.protests) do 
        BWOScheduler.Add("Protest", {x=pcoords.x, y=pcoords.y, z=pcoords.z}, cnt)
        cnt = cnt + 200 + ZombRand(200)
    end
end

-- params: [x, y, z]
BWOEvents.Protest = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local args = {x=params.x, y=params.y, z=params.z, otype="protest"}
    sendClientCommand(player, 'Commands', 'ObjectAdd', args)

    if SandboxVars.Bandits.General_ArrivalIcon then
        local icon = "media/ui/protests.png"
        local color = {r=0, g=1, b=0} -- red
        local desc = "Protests"
        BanditEventMarkerHandler.set(getRandomUUID(), icon, 28800, params.x, params.y, color, desc)
    end
end

-- params: [eid(opt)]
BWOEvents.Entertainer = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local args = {
        program = "Entertainer",
    }

    local spawnPoint = generateSpawnPoint(player:getX(), player:getY(), player:getZ(), ZombRand(28, 35), 1)
    if #spawnPoint == 0 then return end

    args.x = spawnPoint[1].x
    args.y = spawnPoint[1].y
    args.z = spawnPoint[1].z
            
    local icon = "media/ui/concert.png"
    local color = {r=1, g=0.7, b=0.8} -- pink
    local desc = "Entertainment"

    local rnd
    if params.eid then
        rnd = params.eid
    else
        if BanditCompatibility.GetGameVersion() >= 42 then
            rnd = ZombRand(4)
        else
            rnd = ZombRand(4) --7
        end
    end

    -- rnd = 9
    if rnd == 0 then
        args.bid = "40b9340b-3310-40e9-b8a2-e925912590b6" -- fixme
        args.occupation = "Priest"
        icon = "media/ui/cross.png"
        desc = "Preacher"
    elseif rnd == 1 then
        args.bid = "40b9340b-3310-40e9-b8a2-e925912590b6" -- fixme
        args.occupation = "BassPlayer"
    elseif rnd == 2 then
        args.bid = "40b9340b-3310-40e9-b8a2-e925912590b6" -- fixme
        args.occupation = "ViolinPlayer"
    elseif rnd == 3 then
        args.bid = "40b9340b-3310-40e9-b8a2-e925912590b6" -- fixme
        args.occupation = "SaxPlayer"
    elseif rnd == 4 then
        args.bid = "40b9340b-3310-40e9-b8a2-e925912590b6" -- fixme
        args.occupation = "Breakdancer"
        local cassette = "Tsarcraft.CassetteBanditBreakdance01"
        addBoomBox(args.x, args.y, args.z, cassette)
    elseif rnd == 5 then
        args.bid = "40b9340b-3310-40e9-b8a2-e925912590b6" -- fixme
        args.occupation = "Clown"
    elseif rnd == 6 then
        args.bid = "40b9340b-3310-40e9-b8a2-e925912590b6" -- fixme
        args.occupation = "ClownObese"
    end

    sendClientCommand(player, 'Spawner', 'Individual', args)

    if SandboxVars.Bandits.General_ArrivalIcon then
        BanditEventMarkerHandler.set(getRandomUUID(), icon, 3600, args.x, args.y, color, desc)
    end
end

-- params: []
BWOEvents.BuildingHome = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local cell = getCell()
    local building = player:getBuilding()
    if not building then return end

    local def = building:getDef()
    local bx = def:getX()
    local bx2 = def:getX2()
    local by = def:getY()
    local by2 = def:getY2()

    -- register base
    local args = {x=bx, y=by, x2=bx2, y2=by2}
    sendClientCommand(player, 'Commands', 'BaseUpdate', args)

    -- add radio
    local otableNames = {"Low Table", "Counter", "Oak Round Table", "Light Round Table", "Table"}
    local otable
    local radio
    for x=bx, bx2 do
        for y=by, by2 do
            local square = cell:getGridSquare(x, y, 0)
            if square then
                local room = square:getRoom()
                if room then
                    local roomName = room:getName()
                    local objects = square:getObjects()
                    for i=0, objects:size()-1 do
                        local object = objects:get(i)

                        if roomName ~= "bathroom" and roomName ~= "bedroom" then
                            local sprite = object:getSprite()
                            if sprite then
                                local props = sprite:getProperties()
                                if props:Is("CustomName") then
                                    local name = props:Val("CustomName")
                                    if name == "Radio" then
                                        radio = object
                                    end
                                    for _, oTableName in pairs(otableNames) do
                                        if name ==  oTableName then
                                            counter = object
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

    if counter then
        if not radio and params.addRadio then
            local square = counter:getSquare()
            radio = addRadio(square:getX(), square:getY(), square:getZ())
        end

        if radio then
            local dd = radio:getDeviceData()
            if dd then
                dd:setIsTurnedOn(true)
                dd:setChannel(98400)
                dd:setDeviceVolume(0.7)
            end
        end
    end
end

-- params: [roomName, intensity]
BWOEvents.BuildingParty = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local house = BWOBuildings.FindBuildingWithRoom(params.roomName)
    if not house then return end

    local cell = getCell()
    local def = house:getDef()
    local id = def:getKeyId()

    -- replace light and find what we need
    local boombox
    local counter
    local fridge
    local otable
    local bx = def:getX()
    local bx2 = def:getX2()
    local by = def:getY()
    local by2 = def:getY2()

    local x1 = player:getX() - bx
    local x2 = player:getX() - bx2
    local y1 = player:getY() - by
    local y2 = player:getY() - by2
    for x=bx, bx2 do
        for y=by, by2 do
            local square = cell:getGridSquare(x, y, 0)
            if square then
                local room = square:getRoom()
                if room then
                    local roomName = room:getName()
                    local objects = square:getObjects()
                    for i=0, objects:size()-1 do
                        local object = objects:get(i)
                        if instanceof(object, "IsoLightSwitch") then
                            -- object:setCanBeModified(true) --b42
                            -- object:setActivated(false) --b42
                            object:setActive(false)
                            local lightList = object:getLights()
                            if lightList:size() > 0 then
                                object:setBulbItemRaw("Base.LightBulbRed")
                                object:setPrimaryR(1)
                                object:setPrimaryG(0)
                                object:setPrimaryB(0)
                                object:setActive(true)
                            end
                        end
                        if roomName ~= "bathroom" and roomName ~= "bedroom" then
                            local sprite = object:getSprite()
                            if sprite then
                                local props = sprite:getProperties()
                                if props:Is("CustomName") then
                                    local name = props:Val("CustomName")
                                    if name == "Radio" then
                                        boombox = object
                                    elseif name == "Low Table" then
                                        counter = object
                                    elseif name == "Counter" then
                                        counter = object
                                    elseif name == "Oak Round Table" then
                                        counter = object
                                    elseif name == "Light Round Table" then
                                        counter = object
                                    elseif name == "Table" then
                                        otable = object
                                    elseif name == "Fridge" then
                                        fridge = object
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if not counter then return end

    -- add boombox
    local square = counter:getSquare()
    if not boombox then

        -- true music version
        -- local cassette = BanditUtils.Choice({"Tsarcraft.CassetteBanditParty01", "Tsarcraft.CassetteBanditParty02", "Tsarcraft.CassetteBanditParty03", "Tsarcraft.CassetteBanditParty04", "Tsarcraft.CassetteBanditParty05"})
        -- addBoomBox(square:getX(), square:getY(), square:getZ(), cassette)

        -- vanilla version
        addRadio(square:getX(), square:getY(), square:getZ())
    end

    -- add beer to fridge
    if fridge then
        local container = fridge:getContainerByType("fridge")
        if container then
            for i=1, 20 + ZombRand(10) do
                local item = container:AddItem("Base.BeerBottle")
                if item then
                    container:addItemOnServer(item)
                end
            end
        end
    end

    -- add pizza on table
    if otable then
        local tableSquare = otable:getSquare()
        local surfaceOffset = BanditUtils.GetSurfaceOffset(tableSquare:getX(), tableSquare:getY(), tableSquare:getZ())
        local item1 = BanditCompatibility.InstanceItem("Base.PizzaWhole")
        tableSquare:AddWorldInventoryItem(item1, 0.6, 0.6, surfaceOffset)
        
        local item2 = BanditCompatibility.InstanceItem("Base.Wine2")
        tableSquare:AddWorldInventoryItem(item2, 0.2, 0.2, surfaceOffset)
    end

    local args = {id=id, event="party", x=(bx + bx2) / 2, y=(by + by2) / 2}
    sendClientCommand(player, 'Commands', 'EventBuildingAdd', args)

    -- inhabitants
    local args = {
        cid = Bandit.clanMap.Party,
        program = "Inhabitant"
    }

    args.spawnPoints = {}
    local room = square:getRoom()
    local roomDef = room:getRoomDef()
    local pop = params.intensity
    for i=1, pop do
        local spawnSquare = roomDef:getFreeSquare()
        if spawnSquare then
            local sp = {}
            sp.x = spawnSquare:getX()
            sp.y = spawnSquare:getY()
            sp.z = spawnSquare:getZ()
            table.insert(args.spawnPoints, sp)
        end
    end

    if #args.spawnPoints > 0 then
        args.size = #args.spawnPoints
        sendClientCommand(player, 'Spawner', 'Clan', args)
    end

    -- marker
    if SandboxVars.Bandits.General_ArrivalIcon then
        local icon = "media/ui/defend.png"
        local color = {r=1, g=0.7, b=0.8} -- PINK
        local desc = "Entertainment"
        BanditEventMarkerHandler.set(getRandomUUID(), icon, 3600, (bx + bx2) / 2, (by + by2) / 2, color, desc)
    end
end

-- spawn groups

-- emergency services spawn groups

-- params: [x, y, hostile]
BWOEvents.CallCops = function(params)

    if not BWOPopControl.Police.On then return end
    if BWOPopControl.Police.Cooldown > 0 then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    local x, y = findVehicleSpot2(params.x, params.y)
    if not x or not y then return end

    local vehicleCount = player:getCell():getVehicles():size()
    if vehicleCount < 8 then
        spawnVehicle (x, y, BWOCompatibility.GetCarType("Base.PickUpVanLightsPolice"))
        arrivalSound (x, y, "ZSPoliceCar1")

        local vparams = {}
        vparams.lightbar = true
        BWOScheduler.Add("VehiclesUpdate", vparams, 500)
    end

    local cids = {
        Bandit.clanMap.PoliceBlue,
        Bandit.clanMap.PoliceGray
    }

    local args = {
        cid = BanditUtils.Choice(cids),
        size = 2,
        program = "Police",
        occupation = "Police", 
        hostileP = params.hostile,
        x = x + 6,
        y = y + 6,
        z = z
    }
        
    sendClientCommand(player, 'Spawner', 'Clan', args)

    if SandboxVars.Bandits.General_ArrivalIcon then
        local icon = "media/ui/sheriff.png"
        local color
        if params.hostile then
            color = {r=1, g=0, b=0} -- red
        else
            color = {r=0, g=1, b=0} -- green
        end
        local desc = "Cops"
        BanditEventMarkerHandler.set(getRandomUUID(), icon, 3600, x, y, color, desc)
    end

    BWOPopControl.Police.Cooldown = SandboxVars.BanditsWeekOne.PoliceCooldown -- 30
end

-- params: [x, y, hostile]
BWOEvents.CallSWAT = function(params)

    if not BWOPopControl.SWAT.On then return end
    if BWOPopControl.SWAT.Cooldown > 0 then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    local x, y = findVehicleSpot2(params.x, params.y)
    if not x or not y then return end

    local vehicleCount = player:getCell():getVehicles():size()
    if vehicleCount < 8 then
        spawnVehicle (x, y, BWOCompatibility.GetCarType("Base.StepVan_LouisvilleSWAT"))
        arrivalSound(x, y, "ZSPoliceCar1")

        local vparams = {}
        vparams.lightbar = true
        BWOScheduler.Add("VehiclesUpdate", vparams, 500)
    end
    
    local args = {
        cid = Bandit.clanMap.SWAT,
        size = 6,
        program = "Police",
        occupation = "Police", 
        hostileP = params.hostile,
        x = x + 6,
        y = y + 6,
        z = z
    }
        
    sendClientCommand(player, 'Spawner', 'Clan', args)

    if SandboxVars.Bandits.General_ArrivalIcon then
        local icon = "media/ui/sheriff.png"
        local color
        if params.hostile then
            color = {r=1, g=0, b=0} -- red
        else
            color = {r=0, g=1, b=0} -- green
        end
        local desc = "SWAT"
        BanditEventMarkerHandler.set(getRandomUUID(), icon, 3600, x, y, color, desc)
    end

    BWOPopControl.SWAT.Cooldown = SandboxVars.BanditsWeekOne.SWATCooldown -- 120
end

-- params: [x, y]
BWOEvents.CallMedics = function(params)
    
    if not BWOPopControl.Medics.On then return end
    if BWOPopControl.Medics.Cooldown > 0 then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    local x, y = findVehicleSpot2(params.x, params.y)
    if not x or not y then return end

    local vehicleCount = player:getCell():getVehicles():size()
    if vehicleCount < 8 then
        spawnVehicle (x, y, BWOCompatibility.GetCarType("Base.VanAmbulance"))
        arrivalSound(x, y, "ZSPoliceCar1")

        local vparams = {}
        vparams.lightbar = true
        BWOScheduler.Add("VehiclesUpdate", vparams, 500)
    end
  
    local args = {
        cid = Bandit.clanMap.Medic,
        size = 2,
        program = "Medic",
        occupation = "Medic", 
        hostile = false,
        x = x + 6,
        y = y + 6,
        z = z
    }
        
    sendClientCommand(player, 'Spawner', 'Clan', args)

    if SandboxVars.Bandits.General_ArrivalIcon then
        local icon = "media/ui/medics.png"
        local color = {r=0, g=1, b=0} -- green
        local desc = "Paramedics"
        BanditEventMarkerHandler.set(getRandomUUID(), icon, 3600, x, y, color, desc)
    end

    BWOPopControl.Medics.Cooldown = SandboxVars.BanditsWeekOne.MedicsCooldown -- 45
end

-- params: [x, y]
BWOEvents.CallHazmats = function(params)

    if not BWOPopControl.Hazmats.On then return end
    if BWOPopControl.Hazmats.Cooldown > 0 then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    local x, y = findVehicleSpot2(params.x, params.y)
    if not x or not y then return end

    local vehicleCount = player:getCell():getVehicles():size()
    if vehicleCount < 8 then
        spawnVehicle (x, y, BWOCompatibility.GetCarType("Base.VanAmbulance"))
        arrivalSound(x, y, "ZSPoliceCar1")

        local vparams = {}
        vparams.lightbar = true
        BWOScheduler.Add("VehiclesUpdate", vparams, 500)
    end

    local args = {
        cid = Bandit.clanMap.MedicHazmat,
        size = 3,
        program = "Medic",
        occupation = "Medic", 
        hostileP = false,
        x = x + 6,
        y = y + 6,
        z = z
    }
        
    sendClientCommand(player, 'Spawner', 'Clan', args)

    BWOPopControl.Hazmats.Cooldown = SandboxVars.BanditsWeekOne.HazmatCooldown -- 50
end

-- params: [x, y]
BWOEvents.CallFireman = function(params)
    
    if not BWOPopControl.Fireman.On then return end
    if BWOPopControl.Fireman.Cooldown > 0 then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    local x, y = findVehicleSpot2(params.x, params.y)
    if not x or not y then return end

    local vehicleCount = player:getCell():getVehicles():size()
    if vehicleCount < 8 then
        spawnVehicle (x, y, BWOCompatibility.GetCarType("Base.PickUpTruckLightsFire"))
        arrivalSound(x, y, "ZSPoliceCar1")

        local vparams = {}
        vparams.lightbar = true
        BWOScheduler.Add("VehiclesUpdate", vparams, 500)
    end

    local args = {
        cid = Bandit.clanMap.Fireman,
        size = 6,
        program = "Fireman",
        hostile = false,
        x = x + 6,
        y = y + 6,
        z = z
    }
        
    sendClientCommand(player, 'Spawner', 'Clan', args)

    if SandboxVars.Bandits.General_ArrivalIcon then
        local icon = "media/ui/crew.png"
        local color = {r=1, g=0, b=0} -- red
        local desc = "Firemen"
        BanditEventMarkerHandler.set(getRandomUUID(), icon, 3600, x, y, color, desc)
    end

    BWOPopControl.Fireman.Cooldown = SandboxVars.BanditsWeekOne.FiremanCooldown -- 25
end

-- bandits spawn groups

-- params: []
BWOEvents.Defenders = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    -- fixme
    -- BanditScheduler.SpawnDefenders(player, 50, 70)
end

-- params: [intensity, cid, name]
BWOEvents.SpawnGroup = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local density = BWOBuildings.GetDensityScore(player, 120) / 6000
    if density > 1.5 then density = 1.5 end

    local occupation = "None"
    local intensity = math.floor(params.intensity * density * SandboxVars.BanditsWeekOne.BanditsPopMultiplier + 0.4)
    if params.name == "Army" then
        intensity = math.floor(params.intensity * density * SandboxVars.BanditsWeekOne.ArmyPopMultiplier + 0.4)
        occupation = "Army"
    end
    if intensity < 1 then return end

    local args = {
        cid = params.cid,
        size = intensity,
        occupation = occupation, 
        program = params.program
    }

    local spawnPoint = generateSpawnPoint(player:getX(), player:getY(), player:getZ(), ZombRand(params.d, params.d+10), 1)
    if #spawnPoint == 0 then return end

    local sp = spawnPoint[1]
    args.x = sp.x
    args.y = sp.y
    args.z = sp.z
    
    sendClientCommand(player, 'Spawner', 'Clan', args)

    if SandboxVars.Bandits.General_ArrivalIcon then
        local desc = params.name
        local icon = "media/ui/raid.png"
        local color = {r=1, g=0, b=0} -- red

        if params.name == "Army" or params.name == "Veterans" then
            color = {r=0, g=1, b=0} -- green
        end

        BanditEventMarkerHandler.set(getRandomUUID(), icon, 3600, sp.x, sp.y, color, desc)
    end
end
