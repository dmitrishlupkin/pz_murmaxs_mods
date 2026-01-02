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

    local validSpawnPoints = {}
    for i=d, d+6 do
        local spawnPoints = {}
        table.insert(spawnPoints, {x=px+i, y=py+i, z=pz})
        table.insert(spawnPoints, {x=px+i, y=py-i, z=pz})
        table.insert(spawnPoints, {x=px-i, y=py+i, z=pz})
        table.insert(spawnPoints, {x=px-i, y=py-i, z=pz})
        table.insert(spawnPoints, {x=px+i, y=py, z=pz})
        table.insert(spawnPoints, {x=px-i, y=py, z=pz})
        table.insert(spawnPoints, {x=px, y=py+i, z=pz})
        table.insert(spawnPoints, {x=px, y=py-i, z=pz})

        
        for i, sp in pairs(spawnPoints) do
            local square = cell:getGridSquare(sp.x, sp.y, sp.z)
            if square then
                if square:isFree(false) then
                    table.insert(validSpawnPoints, sp)
                end
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

local explode = function(x, y, z)

    local sounds = {"BurnedObjectExploded", "FlameTrapExplode", "SmokeBombExplode", "PipeBombExplode", "DOExploClose1", "DOExploClose2", "DOExploClose3", "DOExploClose4", "DOExploClose5", "DOExploClose6", "DOExploClose7", "DOExploClose8"}

    local function getSound()
        return sounds[1 + ZombRand(#sounds)]
    end

    local player = getSpecificPlayer(0)
    if not player then return end

    local cell = getCell()
    if not z then z = 0 end

    local square = cell:getGridSquare(x, y, z)
    if not square then return end

    --[[
    local item = instanceItem("Base.PipeBomb")
	local trap = IsoTrap.new(item, getCell(), square)
    square:explosion(trap)
    ]]

    -- this triggers ragdolls
    local attacker = cell:getFakeZombieForHit()

    
    local item = BanditCompatibility.InstanceItem("Base.PipeBomb")
    item:setExplosionPower(10)
    item:setTriggerExplosionTimer(0)
    item:setAttackTargetSquare(square)
    --[[
    local mc = IsoMolotovCocktail.new(cell, square:getX(), square:getY(), square:getZ() + 0.6, 10, 10, item, attacker)
    mc:setSquare(square)
    mc:collideCharacter()
    ]]

    if square:getChunk() then
        local trap = IsoTrap.new(player, item, cell, square)
        trap:triggerExplosion(false)
    end

    -- java: new IsoMolotovCocktail(this.getCell(), this.getX(), this.getY(), this.getZ() + 0.6F, float0 * 0.4F, float1 * 0.4F, weapon, this);

    -- IsoFireManager.explode(cell, square, 100)

    for dx = -7, 7 do
        for dy = -7, 7 do
            if isInCircle(x + dx, y + dy, x, y, 6) then
                local square = cell:getGridSquare(x + dx, y + dy, z)
                if square then
                    square:BurnWalls(false)
                    IsoFireManager.StartFire(cell, square, true, 1000, 100)
                end
            end
        end
    end

    -- details
    for dy=-2, 2 do
        for dx = -2, 2 do
            local vsquare = cell:getGridSquare(x + dx, y + dy, 0)
            if vsquare then
                -- vehicle burner
                local vehicle = vsquare:getVehicleContainer()
                if vehicle then
                    BWOVehicles.Burn(vehicle)
                end

                -- street destruction
                if BanditUtils.HasZoneType(vsquare:getX(), vsquare:getY(), vsquare:getZ(), "Nav") then
                    local objects = vsquare:getObjects()
                    for i=0, objects:size()-1 do
                        local object = objects:get(i)
                        local sprite = object:getSprite()
                        if sprite then
                            local spriteName = sprite:getName()
                            if spriteName and spriteName:embodies("street") then
                                local overlaySprite = "blends_streetoverlays_01_" .. ZombRand(32)
                                local attachments = object:getAttachedAnimSprite()
                                if not attachments or attachments:size() == 0 then
                                    object:setAttachedAnimSprite(ArrayList.new())
                                end
                                object:getAttachedAnimSprite():add(getSprite(overlaySprite):newInstance())
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    -- explosion effect
    local effect = {}
    effect.x = square:getX()
    effect.y = square:getY()
    effect.z = square:getZ()
    effect.size = 800
    effect.name = "explobig"
    effect.frameCnt = 17
    table.insert(BWOEffects2.tab, effect)

    -- smoke effect
    for i = 1, 2 do
        local effect2 = {}
        effect2.x = square:getX() + ZombRandFloat(-4.5, 4.5)
        effect2.y = square:getY() + ZombRandFloat(-4.5, 4.5)
        effect2.z = square:getZ()
        effect2.size = 1200
        effect2.poison = false
        effect2.name = "smoke"
        effect2.frameCnt = 60
        effect2.frameRnd = true
        effect2.repCnt = 17 + ZombRand(3)
        table.insert(BWOEffects2.tab, effect2)
    end

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

    -- bomb sound
    local sound = getSound()
    local emitter = getWorld():getFreeEmitter(x, y, 0)
    emitter:playSound(sound)
    emitter:setVolumeAll(0.9)

    addSound(player, math.floor(x), math.floor(y), 0, 100, 100)

    -- wake up players
    BanditPlayer.WakeEveryone()
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

local spawnVehicle = function(x, y, z, vtype)
    local cell = getCell()
    local square = getCell():getGridSquare(x, y, 0)
    if not square then return end

    local vehicle = BWOCompatibility.AddVehicle(vtype, IsoDirections.E, square)
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

            if params.headlights and vehicle:hasHeadlights() then
                vehicle:setHeadlightsOn(true)
            end

            if params.lightbar and vehicle:hasLightbar() then
                if vehicle:hasLightbar() then
                    local mode = vehicle:getLightbarLightsMode()
                    if mode == 0 then
                        vehicle:setLightbarLightsMode(3)
                        -- vehicle:setLightbarSirenMode(2)
                    end
                end
            end

            if params.alarm and vehicle:hasAlarm() then
                if not vehicle:hasLightbar() then
                    BanditPlayer.WakeEveryone()
                    vehicle:setAlarmed(true)
                    vehicle:triggerAlarm()
                end
            end
        end
    end
end

-- params
BWOEvents.VariantCall = function(params)
    local gmd = GetBWOModData()
    local func = BWOVariants[gmd.Variant][params.func]
    func()
end

-- params: time
BWOEvents.FadeOut = function(params)
    if true then return end 
    local player = getSpecificPlayer(0)
    if not player then return end

    local playerNum = player:getPlayerNum()
    player:setBlockMovement(true)
    player:setBannedAttacking(true)
    UIManager.setFadeBeforeUI(playerNum, false)
    UIManager.FadeOut(playerNum, params.time)
end

-- params: time
BWOEvents.FadeIn = function(params)
    if true then return end 
    local player = getSpecificPlayer(0)
    if not player then return end

    local playerNum = player:getPlayerNum()
    player:setBlockMovement(false)
    player:setBannedAttacking(false)
    UIManager.FadeIn(playerNum, params.time)
    UIManager.setFadeBeforeUI(playerNum, false)
end

-- params: x, y
BWOEvents.Explode = function(params)
    explode(params.x, params.y, params.z)
end

-- params: [x, y, sound]
BWOEvents.Sound = function(params)
    if params.atPlayer then
        local player = getSpecificPlayer(0)
        if not player then return end
        player:playSound(params.sound)
    elseif params.x and params.y and params.z then
        local emitter = getWorld():getFreeEmitter(params.x, params.y, params.z)
        emitter:playSound(params.sound)
        emitter:setVolumeAll(1)
    end
end

BWOEvents.Emitter = function(params)
    local effect = {}
    effect.x = params.x
    effect.y = params.y
    effect.z = params.z
    effect.len = params.len --2460
    effect.sound = params.sound -- "ZSBuildingBaseAlert"
    effect.light = params.light -- {r=1, g=0, b=0, t=10}
    BWOEmitter.Add(effect)
end

BWOEvents.Effect = function(params)
    local effect = params
    BWOEffects2.Add(effect)
end

-- params: [x, y]
BWOEvents.Siren = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local emitter = getWorld():getFreeEmitter(params.x + 10, params.y - 20, 0)
    emitter:playAmbientSound("DOSiren2")
    emitter:setVolumeAll(0.9)
    addSound(player, math.floor(params.x), math.floor(params.y), math.floor(params.z), 100, 100)

    BanditPlayer.WakeEveryone()
end

-- params: [on]
BWOEvents.SetHydroPower = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local sandboxOptions = getSandboxOptions()
    if params.on == true then
        sandboxOptions:getOptionByName("ElecShutModifier"):setValue(2147483646)
        sandboxOptions:toLua()
        getWorld():setHydroPowerOn(true)
    elseif params.on == false then
        BWOEmitter.tab = {}
        sandboxOptions:getOptionByName("ElecShutModifier"):setValue(0)
        sandboxOptions:toLua()
        getWorld():setHydroPowerOn(false)
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
    local t = 0 
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
                                    t = t + 1
                                    if t > 80 then
                                        print ("too many respawns")
                                        return
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

-- params: [x, y, sound]
BWOEvents.ChopperAlert = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end
    
    getCore():setOptionUIRenderFPS(60)
    BanditPlayer.WakeEveryone()

    local effect = {}
    effect.cx = player:getX() - 3 + ZombRand(4)
    effect.cy = player:getY() - 3 + ZombRand(4)
    effect.initDist = 200
    effect.width = 1243
    effect.height = 760
    effect.alpha = 1
    effect.speed = params.speed
    effect.name = params.name
    effect.dir = params.dir
    effect.sound = params.sound
    effect.rotors = true
    effect.lights = true
    effect.frameCnt = 3
    effect.cycles = 400
    table.insert(BWOFlyingObject.tab, effect)
end

-- params: [x, y, sound]
BWOEvents.ChopperFliers = function(params)
    
    if not SandboxVars.BanditsWeekOne.EventFinalSolution then return end
    getCore():setOptionUIRenderFPS(60)

    local player = getSpecificPlayer(0)
    if not player then return end
    local px, py = player:getX(), player:getY()

    local effect = {}
    effect.cx = px
    effect.cy = py
    effect.initDist = 200
    effect.width = 1243
    effect.height = 760
    effect.alpha = 1
    effect.speed = 1
    effect.name = "heli2"
    effect.dir = 90
    effect.rotors = true
    effect.lights = true
    effect.sound = "BWOChopperCDC2"
    effect.frameCnt = 3
    effect.cycles = 400
    table.insert(BWOFlyingObject.tab, effect)

    local params = {x=px, y=py}
    BWOScheduler.Add("ChopperFliersStage2", params, 9000)
    BWOScheduler.Add("ChopperFliersStage2", params, 11000)
    BWOScheduler.Add("ChopperFliersStage2", params, 12600)
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


BWOEvents.GetHelicopter = function(params)
    testHelicopter()
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

BWOEvents.ClearCorpse = function(params)
    local cell = getCell()
    for z = params.z1, params.z2 do
        for y = params.y1, params.y2 do
            for x = params.x1, params.x2 do
                local square = cell:getGridSquare(x, y, z)
                if square then
                    local corpse = square:getDeadBody()
                    if corpse then
                        square:removeCorpse(corpse, true)
                        if square:haveBlood() then
                            square:removeBlood(false, false)
                        end
                    end
                end
            end
        end
    end
end

BWOEvents.OpenDoors = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end
    local cell = getCell()
    player:playSound("PrisonMetalDoorOpen")
    for z = params.z1, params.z2 do
        for y = params.y1, params.y2 do
            for x = params.x1, params.x2 do
                local square = cell:getGridSquare(x, y, z)
                if square then
                    local door = square:getDoor(true)
                    if not door then
                        door = square:getDoor(false)
                    end

                    if door then
                        if not door:IsOpen() then
                            door:ToggleDoorSilent()
                            square:RecalcProperties()
                            square:RecalcAllWithNeighbours(true)
                            square:setSquareChanged()
                        end
                    end
                end
            end
        end
    end
end

BWOEvents.ClearZombies = function(params)
    local zombieList = BanditZombie.CacheLightZ
    for id, z in pairs(zombieList) do
        local zombie = BanditZombie.GetInstanceById(z.id)
        -- local id = BanditUtils.GetCharacterID(zombie)
        if zombie and zombie:isAlive() then
            -- fixme: zombie:canBeDeletedUnnoticed(float)
            zombie:removeFromSquare()
            zombie:removeFromWorld()
        end
    end

    local cell = getCell()
    local zombieList = cell:getZombieList()
    local zombieListSize = zombieList:size()
    for i = zombieListSize - 1, 0, -1 do
        local zombie = zombieList:get(i)
        if zombie then
            zombie:removeFromSquare()
            zombie:removeFromWorld()
        end
    end
end

-- params: []
BWOEvents.Start = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    -- clear initial zeds before sandbox adjustment kicks in
    local zombieList = BanditZombie.CacheLightZ
    for id, z in pairs(zombieList) do
        local zombie = BanditZombie.GetInstanceById(z.id)
        -- local id = BanditUtils.GetCharacterID(zombie)
        if zombie and zombie:isAlive() then
            -- fixme: zombie:canBeDeletedUnnoticed(float)
            zombie:removeFromSquare()
            zombie:removeFromWorld()
        end
    end

    local profession = player:getDescriptor():getCharacterProfession()
    local cell = getCell()
    local building = player:getBuilding()
    if building then
        local buildingDef = building:getDef()
        local keyId = buildingDef:getKeyId()

        -- register player home
        if params.party then
            local args = {id=keyId, event="party", x=(buildingDef:getX() + buildingDef:getX2()) / 2, y=(buildingDef:getY() + buildingDef:getY2()) / 2}
            sendClientCommand(player, 'Commands', 'EventBuildingAdd', args)
        else
            local args = {id=keyId, event="home", x=(buildingDef:getX() + buildingDef:getX2()) / 2, y=(buildingDef:getY() + buildingDef:getY2()) / 2}
            sendClientCommand(player, 'Commands', 'EventBuildingAdd', args)
        end

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
            permanent = true,
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
                
                local carType
                if BWOVehicles.playerCarChoicesOccupation[profession] then
                    carType = BWOCompatibility.GetCarType(BanditUtils.Choice(BWOVehicles.playerCarChoicesOccupation[profession]))
                else
                    carType = BWOCompatibility.GetCarType(BanditUtils.Choice(BWOVehicles.playerCarChoicesDefault))
                end

                vehicle = spawnVehicle(sx, sy, 0, BWOCompatibility.GetCarType(carType))
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

-- params: [x, y, z]
BWOEvents.ClearObjects = function(params)
    local cell = getCell()
    local square = cell:getGridSquare(params.x, params.y, params.z)
    if square then
        local objects = square:getObjects()
        local destroyList = {}

        for i=0, objects:size()-1 do
            local object = objects:get(i)
            if object then
                local sprite = object:getSprite()
                if sprite then 
                    local spriteProps = sprite:getProperties()

                    local isSolidFloor = spriteProps:has(IsoFlagType.solidfloor)
                    local isAttachedFloor = spriteProps:has(IsoFlagType.attachedFloor)

                    if not isSolidFloor and not isAttachedFloor then
                        table.insert(destroyList, object)
                    end
                end
            end
        end

        for k, obj in pairs(destroyList) do
            if isClient() then
                sledgeDestroy(obj);
            else
                square:transmitRemoveItemFromSquare(obj)
            end
            square:RecalcProperties()
            square:RecalcAllWithNeighbours(true)
            square:setSquareChanged()
        end
    end
end

-- params: [x, y, z]
BWOEvents.ArsonAt = function(params)
    explode(params.x, params.y, params.z)
    local vparams = {}
    vparams.alarm = true
    BWOScheduler.Add("VehiclesUpdate", vparams, 500)

    if SandboxVars.Bandits.General_ArrivalIcon then
        local icon = "media/ui/arson.png"
        local color = {r=1, g=0, b=0} -- red
        local desc = "Arson"
        BanditEventMarkerHandler.set(getRandomUUID(), icon, 3600, params.z, params.y, color, desc)
    end
end

-- params: []
BWOEvents.Arson = function(params)

    if not SandboxVars.BanditsWeekOne.EventArson then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    local building
    if params.home then
        building = player:getSquare():getBuilding()
    else
        local density = BWOBuildings.GetDensityScore(player, 120) / 6000
        if density < 0.3 then return end

        building = BWOBuildings.FindBuildingDist(player, 35, 50)
    end
    if not building then return end

    local room = building:getRandomRoom()
    if not room then return end

    local square = room:getRandomSquare()
    if not square then return end

    explode(square:getX(), square:getY(), 0)
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

    if not SandboxVars.BanditsWeekOne.EventBombing then return end

    for z=0, 20 do
        explode(params.x, params.y, z)
    end

    -- junk placement
    BanditBaseGroupPlacements.Junk (params.x-4, params.y-4, 0, 6, 8, 3)

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

     -- POLISH HOOLIGANS GUARDS
     addPlaceEvent({phase="PolishHooligans", x=10670, y=9995, z=0})
     addPlaceEvent({phase="PolishHooligans", x=10995, y=9644, z=0})
     addPlaceEvent({phase="PolishHooligans", x=11412, y=6785, z=0})
     addPlaceEvent({phase="PolishHooligans", x=2595, y=10911, z=0})
     addPlaceEvent({phase="PolishHooligans", x=13063, y=1646, z=0})
     addPlaceEvent({phase="PolishHooligans", x=6521, y=5344, z=0})
     addPlaceEvent({phase="PolishHooligans", x=13511, y=1286, z=0})

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

    addPlaceEvent({phase="BaseDefenders", x=5543, y=12466, z=-4, intensity = 1}) -- staircase
    addPlaceEvent({phase="BaseDefenders", x=5542, y=12475, z=-13, intensity = 5}) -- monitoring room -13
    addPlaceEvent({phase="BaseDefenders", x=5572, y=12493, z=-13, intensity = 2}) -- corridor
    addPlaceEvent({phase="BaseDefenders", x=5545, y=12481, z=-15, intensity = 3}) -- billard room
    addPlaceEvent({phase="BaseDefenders", x=5557, y=12447, z=-16, intensity = 3}) -- control room
    addPlaceEvent({phase="BaseDefenders", x=5562, y=12446, z=-16, intensity = 6}) -- control room

    
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
        BWOMusic.Play("BWOMusicOutro", 1)

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
BWOEvents.JetFighterStage1 = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    BanditPlayer.WakeEveryone()

    getCore():setOptionUIRenderFPS(60)

    local effect = {}
    effect.cx = params.cx
    effect.cy = params.cy
    effect.initDist = 200
    effect.width = 1024
    effect.height = 586
    effect.alpha = 1
    effect.speed = 12
    effect.name = "a10"
    effect.dir = params.dir
    effect.frameCnt = 3
    effect.cycles = 400
    table.insert(BWOFlyingObject.tab, effect)
end

-- params: [x, y, outside]
BWOEvents.JetFighterStage2 = function(params)

    local player = getSpecificPlayer(0)
    if not player then return end

    local px, py = player:getX(), player:getY()

    if params.arm == "mg" then

        if not SandboxVars.BanditsWeekOne.EventStrafe then return end

        local fakeItem = BanditCompatibility.InstanceItem("Base.AssaultRifle")
        local fakeZombie = getCell():getFakeZombieForHit()

        local sound = "DOA10"
        local emitter = getWorld():getFreeEmitter((params.x1 + params.x2) / 2, (params.y1 + params.y2) / 2, 0)
        emitter:playSound(sound)
        emitter:setVolumeAll(0.9)

        if px >= params.x1 and px < params.x2 and py >= params.y1 and py < params.y2 and player:isOutside() then
            player:Hit(fakeItem, fakeZombie, 0.8, false, 1, false)
        end

        local zombieList = BanditZombie.GetAll()
        for id, zombie in pairs(zombieList) do
            if zombie.x >= params.x1 and zombie.x < params.x2 and zombie.y >= params.y1 and zombie.y < params.y2 then
                local character = BanditZombie.GetInstanceById(id)
                if character and character:isOutside() then
                    character:Hit(fakeItem, fakeZombie, BanditUtils.Choice({1, 20, 20, 20, 20}), false, 1, false)
                end
            end
        end
    else

        local step
        local dropEvent
        if params.arm == "gas" then
            dropEvent = "GasDrop"
            step = 10
        elseif params.arm == "bomb" then
            dropEvent = "BombDrop"
            step = 8
        end

        if dropEvent then
            d = 100
            if params.dir == 0 then
                local y = (params.y1 + params.y2) / 2
                for x=params.x1, params.x2, step do
                    BWOScheduler.Add(dropEvent, {x=x, y=y}, d)
                    d = d + 160
                end
            elseif params.dir == 180 then
                local y = (params.y1 + params.y2) / 2
                for x=params.x2, params.x1, -step do
                    BWOScheduler.Add(dropEvent, {x=x, y=y}, d)
                    d = d + 160
                end
            elseif params.dir == 90 then
                local x = (params.x1 + params.x2) / 2
                for y=params.y1, params.y2, step do
                    BWOScheduler.Add(dropEvent, {x=x, y=y}, d)
                    d = d + 160
                end
            elseif params.dir == -90 then
                local x = (params.x1 + params.x2) / 2
                for y=params.y2, params.y1, -step do
                    BWOScheduler.Add(dropEvent, {x=x, y=y}, d)
                    d = d + 160
                end
            end
        end
    end
end

-- params: [x, y, intensity, outside]
BWOEvents.JetFighterRun = function(params)

    local player = getSpecificPlayer(0)
    if not player then return end

    local px, py = player:getX(), player:getY()

    -- stage 0 play incoming sound
    player:playSound("DOJet")

    -- find optimal strafing rectangle 80x10
    local chunk = {arm=params.arm}
    local best = 0
    local zombieList = BanditZombie.GetAll()

    -- NS lines
    for bx=-4, 4 do
        local y1 = py - 80
        local y2 = py + 80
        local x1 = px + bx * 10 - 5
        local x2 = px + bx * 10 + 5

        local cnt = 0
        for id, zombie in pairs(zombieList) do
            if zombie.x >= x1 and zombie.x < x2 and zombie.y >= y1 and zombie.y < y2 then
                cnt = cnt + 1
            end
        end

        if cnt > best then
            chunk.x1 = x1
            chunk.x2 = x2
            chunk.y1 = y1
            chunk.y2 = y2
            chunk.dir = BanditUtils.Choice({-90, 90})
            chunk.cx = (x1 + x2) / 2
            chunk.cy = py
            best = cnt
        end
    end

    -- EW lines
    for by=-4, 4 do
        local y1 = py + by * 10 - 5
        local y2 = py + by * 10 + 5
        local x1 = px - 80
        local x2 = px + 80

        local cnt = 0
        for id, zombie in pairs(zombieList) do
            if zombie.x >= x1 and zombie.x < x2 and zombie.y >= y1 and zombie.y < y2 then
                cnt = cnt + 1
            end
        end

        if cnt > best then
            chunk.x1 = x1
            chunk.x2 = x2
            chunk.y1 = y1
            chunk.y2 = y2
            chunk.dir = BanditUtils.Choice({0, 180})
            chunk.cx = px
            chunk.cy = (y1 + y2) / 2
            best = cnt
        end
    end

    local d = 0
    if params.arm == "mg" then
        d = 900
    else
        d = 1300
    end

    -- stage 1 display flying object
    BWOScheduler.Add("JetFighterStage1", chunk, 10000)

    -- stage 2 strike
    if best > 0 then
        BWOScheduler.Add("JetFighterStage2", chunk, 10000 + d)
    end

end

-- params: [x, y, outside]
BWOEvents.GasDrop = function(params)

    if not SandboxVars.BanditsWeekOne.EventGas then return end

    local svec = {}
    table.insert(svec, {x=-3, y=-1})
    table.insert(svec, {x=3, y=1})
    table.insert(svec, {x=-1, y=-3})
    table.insert(svec, {x=1, y=3})

    for _, v in pairs(svec) do

        local effect = {}
        effect.x = params.x + v.x
        effect.y = params.y + v.y
        effect.z = 0
        effect.size = 600 + ZombRand(600)
        effect.poison = true
        effect.colors = {r=0.1, g=0.7, b=0.2, a=0.2}
        effect.name = "gas"
        effect.frameCnt = 60
        effect.frameRnd = true
        effect.repCnt = 24
        table.insert(BWOEffects2.tab, effect)
    end

    local colors = {r=0.2, g=1.0, b=0.3}
    local lightSource = IsoLightSource.new(params.x, params.y, 0, colors.r, colors.g, colors.b, 60, 10)
    getCell():addLamppost(lightSource)

    local emitter = getWorld():getFreeEmitter(params.x, params.y, 0)
    emitter:playSound("DOGas")
    emitter:setVolumeAll(0.25)
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
        size = 1
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

    rnd = 0

    -- rnd = 9
    if rnd == 0 then
        args.cid = Bandit.clanMap.Priest
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
    elseif rnd == 5 then
        args.bid = "40b9340b-3310-40e9-b8a2-e925912590b6" -- fixme
        args.occupation = "Clown"
    elseif rnd == 6 then
        args.bid = "40b9340b-3310-40e9-b8a2-e925912590b6" -- fixme
        args.occupation = "ClownObese"
    end

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile then args.hostileP = true end

    sendClientCommand(player, 'Spawner', 'Clan', args)

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
    if not params.party then
        local args = {x=bx, y=by, x2=bx2, y2=by2}
        sendClientCommand(player, 'Commands', 'BaseUpdate', args)
    end

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
                                if props:has("CustomName") then
                                    local name = props:get("CustomName")
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

                        if params.party and instanceof(object, "IsoLightSwitch") then
                            -- object:setCanBeModified(true) --b42
                            -- object:setActivated(false) --b42
                            if object:hasLightBulb() and object:getCanBeModified() then
                                object:setBulbItemRaw("Base.LightBulbRed")
                                object:setPrimaryR(1)
                                object:setPrimaryG(0)
                                object:setPrimaryB(0)
                                object:setActive(true)
                            else
                                object:setActive(false)
                            end
                        end
                    end
                end
            end
        end
    end

    if counter then
        local square = counter:getSquare()
        if not radio and params.addRadio then
            radio = addRadio(square:getX(), square:getY(), square:getZ())
        end

        if radio then
            local dd = radio:getDeviceData()
            if dd then
                dd:setIsTurnedOn(true)
                dd:setChannel(98400)
                dd:setDeviceVolume(0.7)
            end

            if params.party then
                local args = {
                    cid = Bandit.clanMap.Party,
                    program = "Inhabitant"
                }

                local gmd = GetBWOModData()
                local variant = gmd.Variant
                if BWOVariants[variant].playerIsHostile then args.hostileP = true end
            
                args.spawnPoints = {}
                local room = square:getRoom()
                local roomDef = room:getRoomDef()
                local pop = 12
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
                            if object:hasLightBulb() and object:getCanBeModified() then
                                object:setBulbItemRaw("Base.LightBulbRed")
                                object:setPrimaryR(1)
                                object:setPrimaryG(0)
                                object:setPrimaryB(0)
                                object:setActive(true)
                            else
                                object:setActive(false)
                            end
                        end
                        if roomName ~= "bathroom" and roomName ~= "bedroom" then
                            local sprite = object:getSprite()
                            if sprite then
                                local props = sprite:getProperties()
                                if props:has("CustomName") then
                                    local name = props:get("CustomName")
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

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile then args.hostileP = true end

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
        local vtype = BWOCompatibility.GetCarType(BanditUtils.Choice(BWOVehicles.policeCarChoices))
        spawnVehicle (x, y, 0, vtype)
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

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile then args.hostileP = true end
        
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
        local vtype = BWOCompatibility.GetCarType(BanditUtils.Choice(BWOVehicles.SWATCarChoices))
        spawnVehicle (x, y, 0, vtype)
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

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile then args.hostileP = true end
        
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
        local vtype = BWOCompatibility.GetCarType(BanditUtils.Choice(BWOVehicles.medicalCarChoices))
        spawnVehicle (x, y, 0, vtype)
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

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile then args.hostileP = true end
        
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
        local vtype = BWOCompatibility.GetCarType(BanditUtils.Choice(BWOVehicles.hazmatsCarChoices))
        spawnVehicle (x, y, 0, vtype)
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

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile then args.hostileP = true end
        
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
        local vtype = BWOCompatibility.GetCarType(BanditUtils.Choice(BWOVehicles.firemanCarChoices))
        spawnVehicle (x, y, 0, vtype)
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

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile then args.hostileP = true end
        
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

-- params: [x, y, z, size, program, cid, loyal, hostile]
BWOEvents.SpawnGroupAt = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local args = {
        cid = params.cid,
        size = params.size,
        program = params.program,
        x = params.x,
        y = params.y,
        z = params.z,
        loyal = params.loyal,
        hostile = params.hostile
    }

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile and not params.loyal then args.hostileP = true else args.hostileP = false end

    sendClientCommand(player, 'Spawner', 'Clan', args)
end

BWOEvents.SpawnGroupArea = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local gmd = GetBWOModData()
    local variant = gmd.Variant

    for i = 1, params.cnt do
        local x = params.x1 + ZombRand(params.x2 - params.x1)
        local y = params.y1 + ZombRand(params.y2 - params.y1)
        local args = {
            cid = params.cid,
            size = 1,
            program = params.program,
            x = x,
            y = y,
            z = params.z,
            loyal = params.loyal,
            hostile = params.hostile
        }

        if BWOVariants[variant].playerIsHostile and not params.loyal then args.hostileP = true else args.hostileP = false end

        sendClientCommand(player, 'Spawner', 'Clan', args)
    end
end

-- params: [intensity, cid, name]
BWOEvents.SpawnGroup = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local density = BWOBuildings.GetDensityScore(player, 120) / 6000
    if density > 2 then density = 2 end
    if density < 0.5 then density = 0.5 end

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
        program = params.program,
        voice = params.voice
    }

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile and not params.loyal then args.hostileP = true else args.hostileP = false end

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

-- params: x, y
BWOEvents.Delete = function(params)
    BanditBaseGroupPlacements.ClearSpace (params.x-2, params.y-2, params.z, 5, 5)

end

-- params: x, y, itemType
BWOEvents.AddItems = function(params)
    local cell = getCell()
    local itemInsideChoices = {
        "Base.Toothbrush", "Base.Toothpaste", "Base.Socks_Ankle", "Base.Socks_Ankle", "Base.Socks_Long",
        "Base.Briefs", "Base.Shirt_Denim", "Base.Tshirt_WhiteTINT", "Base.Tshirt_WhiteTINT", "Base.Underpants_White",
        "Base.Trousers", "Base.Trousers", "Base.Dress_Short", "Base.Dress_Long", "Base.Dress_Normal",
        "Base.Tshirt_WhiteLongSleeveTINT", "Base.Shirt_HawaiianTINT", "Base.Shirt_HawaiianTINT", "Base.Shirt_HawaiianTINT", "Base.Hat_SummerHat",
        "Base.Brandy", "Base.CigarBox", "Base.Boxers_White", "Base.AntibioticsBox", "Base.Book",
    }
    for i = 1, params.cnt do
        local ix, iy = params.x, params.y - 20 + ZombRand(41)
        local square = cell:getGridSquare(ix, iy, 0)
        if square then
            local itemType = BanditUtils.Choice(params.itemTab)
            local item = BanditCompatibility.InstanceItem(itemType)
            if item then
                if instanceof(item, "InventoryContainer") then
                    local container = item:getItemContainer()
                    if container then
                        for i=1, 5 + ZombRand(10) do
                            local itemInside = BanditCompatibility.InstanceItem(BanditUtils.Choice(itemInsideChoices))
                            if itemInside then
                                container:AddItem(itemInside)
                            end
                        end
                    end
                end
                item:setWorldZRotation(ZombRand(360))
                square:AddWorldInventoryItem(item, ZombRandFloat(0.1, 0.9), ZombRandFloat(0.1, 0.9), 0)
            end
        end    
    end
    
end

BWOEvents.PlaneCrashPartEnd = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    for i=1, params.civs do
        local args = {}
        args.cid = Bandit.clanMap.Resident
        args.program = "Walker"
        args.size = 1
        args.x = params.x + ZombRandFloat(-5, 5)
        args.y = params.y + ZombRandFloat(-5, 5)
        args.z = params.z
        args.crawler = true
        BanditServer.Spawner.Clan(player, args)
    end
    -- sendClientCommand(player, 'Spawner', 'Clan', args)

    local vehicle = spawnVehicle(params.x, params.y, params.z, params.vtype)
    if vehicle then
        local dir = -86 + ZombRand(9)
        vehicle:setAngles(0, dir, 0)

        if params.engine then
            params.dir = dir
            BWOJetEngine.Add(params)
        end
    else
        print ("plane error")
    end

    if params.engine then

    end
    BanditBaseGroupPlacements.Junk (params.x-7, params.y-7, 0, 14, 14, 33)
    
end

BWOEvents.JetEngine = function(params)
    local vehicle = spawnVehicle(params.x, params.y, params.z, "Base.pzkPlaneEngine")
    if vehicle then
        vehicle:setAngles(0, params.dir, 0)
        BWOJetEngine.Add(params)
    end
end

BWOEvents.PlaneCrashPartSequence = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local emitter = player:getEmitter()
    if emitter:isPlaying("BWOBoeing") then
        emitter:stopSoundByName("BWOBoeing")
    end

    local px, py = player:getX(), player:getY()

    params.x = px + params.x
    params.y = py + params.y

    local bags = {"Base.Suitcase", "Base.Suitcase", "Base.Suitcase", "Base.Suitcase", "Base.Suitcase", "Base.Briefcase", 
                  "Base.Bag_DuffelBag", "Base.Purse", "Base.RippedSheets", "Base.RippedSheetsDirty", 
                  "Base.SheetMetal", "Base.SmallSheetMetal", "Base.ScrapMetal", "Base.MetalPipe"}

    local seats = {"Base.NormalCarSeat2"}

    local delay = 1
    for i = -24, 0 do
        local x, y = params.x + (i*2), params.y
        BWOScheduler.Add("Explode", {x=x, y=y}, delay)
        BWOScheduler.Add("Delete", {x=x, y=y, r=2, z=-i}, delay)

        if params.bags then
            BWOScheduler.Add("AddItems", {x=x, y=y, itemTab=bags, cnt=params.bags}, delay)
        end
        if params.seats then
            BWOScheduler.Add("AddItems", {x=x, y=y, itemTab=seats, cnt=params.seats}, delay)
        end

        delay = delay + 70

    end

    BWOScheduler.Add("PlaneCrashPartEnd", params, delay)

end

BWOEvents.Music = function(params)
    BWOMusic.Play(params.music, params.volume)
end

BWOEvents.PlaneCrashSequence = function(params)

    if not SandboxVars.BanditsWeekOne.EventBoeing then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    BanditPlayer.WakeEveryone()

    BWOScheduler.Add("Say", {txt="TIP: I can see an airplane flying very low in the sky."}, 10)

    getCore():setOptionUIRenderFPS(60)

    local start = 17600
    -- stage 1: init plane flyby sound 
    local emitter = player:getEmitter()
    local id = emitter:playSound("BWOBoeing")

    -- stage 2: play two plane explosions while the plane is still in the air
    local params = {x=player:getX(), y=player:getY(), z=player:getZ(), sound="BWOExploPlane"}
    BWOScheduler.Add("Sound", params, start)
    BWOScheduler.Add("Sound", params, start + 600)

    BWOScheduler.Add("Music", {music="BWOMusicPlane", volume=1}, 7000)

    -- step 3: place plane parts on ground
    local partMap = {
        {
            vtype = "Base.pzkPlaneSection1",
            x = 30 - ZombRand(5),
            y = 11,
            z = 0,
            delay = start + 2500,
            civs = 2,
            bags = 0,
            seats = 0
        },
        {
            vtype = "Base.pzkPlaneSection2",
            x = -20 + ZombRand(3),
            y = -10 + ZombRand(10),
            z = 0,
            delay = start + 3500,
            civs = 12,
            bags = 2,
            seats = 2
        },
        {
            vtype = "Base.pzkPlaneSection3",
            x = -11,
            y = 4,
            z = 0,
            delay = start + 4500,
            civs = 25,
            bags = 22,
            seats = 3
        },
        {
            vtype = "Base.pzkPlaneSection2",
            x = -25 + ZombRand(6),
            y = -21,
            z = 0,
            delay = start + 4700,
            civs = 12,
            bags = 2,
            seats = 2
        },
        {
            vtype = "Base.pzkPlaneSection4",
            x = -45 + ZombRand(10),
            y = 7,
            z = 0,
            delay = start + 5100,
            civs = 18,
            bags = 12,
            seats = 2
        },
        {
            vtype = "Base.pzkPlaneWingL2",
            x = 12 + ZombRand(5),
            y = 1,
            z = 0,
            delay = start + 5900,
            civs = 0,
            bags = 0,
            seats = 0
        },
        {
            vtype = "Base.pzkPlaneWingL1",
            x = -12 - ZombRand(7),
            y = 11 + ZombRand(4),
            z = 0,
            delay = start + 6600,
            civs = 0,
            bags = 0,
            seats = 0
        },
        {
            vtype = "Base.pzkPlaneEngine",
            x = -8,
            y = -23,
            z = 0,
            delay = start + 7300,
            civs = 1,
            bags = 0,
            seats = 0,
            engine = 1
        },
        {
            vtype = "Base.pzkPlaneWingR2",
            x = 12,
            y = 37,
            z = 0,
            delay = start + 7800,
            civs = 0,
            bags = 0,
            seats = 0
        },
        {
            vtype = "Base.pzkPlaneWingR1",
            x = -2,
            y = 31,
            z = 0,
            delay = start + 8800,
            civs = 0,
            bags = 0,
            seats = 0
        },
        {
            vtype = "Base.pzkPlaneEngine",
            x = -6,
            y = 0,
            z = 0,
            delay = start + 10000,
            civs = 0,
            bags = 0,
            seats = 0,
            engine = 1
        },
        {
            vtype = "Base.pzkPlaneSection2",
            x = 6,
            y = 11,
            z = 0,
            delay = start + 10800,
            civs = 12,
            bags = 2,
            seats = 2
        },
    }

    for _, part in pairs(partMap) do
        BWOScheduler.Add("PlaneCrashPartSequence", part, part.delay)
    end
    
end

BWOEvents.VehicleCrash = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local cx = player:getX() + params.x
    local cy = player:getY() + params.y

    BanditBaseGroupPlacements.ClearSpace (cx-4, cy-4, params.z, 8, 8)
    explode(cx, cy, 0)
    local vparams = {}
    vparams.alarm = true
    BWOScheduler.Add("VehiclesUpdate", vparams, 500)

    local vehicle = spawnVehicle(cx, cy, 0, params.vtype)
    if vehicle then
        vehicle:setGeneralPartCondition(0.1, 100)
        vehicle:setBloodIntensity("Front", 1)
        vehicle:setBloodIntensity("Rear", 1)
        vehicle:setBloodIntensity("Left", 1)
        vehicle:setBloodIntensity("Right", 1)
    end
end

-- params: size, x, y, z, outfit, femaleChance
BWOEvents.HordeAt = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    for j=1, params.size do
        local zombieList = BanditCompatibility.AddZombiesInOutfit(params.x, params.y, params.z, params.outfit, params.femaleChance, false, false, false, false, false, false, 1)
        for i=0, zombieList:size()-1 do
            local zombie = zombieList:get(i)
            zombie:spotted(player, true)
            zombie:setTarget(player)
            zombie:setAttackedBy(player)
            zombie:pathToLocationF(player:getX(), player:getY(), player:getZ())
        end
    end
end

BWOEvents.Horde = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local density = BWOBuildings.GetDensityScore(player, 120) / 6000
    -- if density < 0.5 then return end

    local zones = getZones(player:getX(), player:getY(), player:getZ())
    local cityName
    local zoneName
    if zones then
        for i=0, zones:size()-1 do
            local zone = zones:get(i)
            if zone:getType() == "Region" then
                cityName = zone:getName()
            else
                zoneName = zone:getType()
            end
        end
    end

    local outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Generic05", "Classy", "IT", "Student", "Teacher", "Police", "Young", "Bandit", "Tourist"}
    local femaleChance = 51
    if cityName and density > 0.3 then
        if cityName == "WestPoint" then
            outfits = {"Student", "Student", "Student", "Student", "Student", "Student", "Student", "Teacher"}
            femaleChance = 55
        elseif cityName == "Rosewood" then
            outfits = {"Inmate", "Inmate", "InmateEscaped"}
            femaleChance = 0
        elseif cityName == "Riverside" then
            outfits = {"Tourist"}
        elseif cityName == "Jefferson" then
            outfits = {"ArmyCamoGreen"}
            femaleChance = 10
        end
    elseif zoneName then
        if zoneName:embodies("Forest") then
            outfits = {"Survivalist"}
            femaleChance = 33
        elseif zoneName:embodies("Farm") then
            outfits = {"Farmer"}
        end
    end

    local cx = player:getX()
    local cy = player:getY()
    local cz = player:getZ()

    addSound(player, math.floor(cx), math.floor(cy), math.floor(cz), 100, 100)

    for j=1, params.cnt do
        local outfit = BanditUtils.Choice(outfits)
        local zombieList = BanditCompatibility.AddZombiesInOutfit(cx + params.x, cy + params.y, 0, outfit, femaleChance, false, false, false, false, false, false, 1)
        for i=0, zombieList:size()-1 do
            local zombie = zombieList:get(i)
            zombie:spotted(player, true)
            zombie:setTarget(player)
            zombie:setAttackedBy(player)
            zombie:pathToLocationF(cx, cy, cz)
        end
    end
end

BWOEvents.MetaSound = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    if ZombRand(3) > 0 then return end

    local density = BWOBuildings.GetDensityScore(player, 120) / 6000
    if density < 0.7 then return end

    local metaSounds = {
        "MetaAssaultRifle1",
        "MetaPistol1",
        "MetaShotgun1",
        "MetaPistol2",
        "MetaPistol3",
        "MetaShotgun1",
        "MetaScream",
        -- "VoiceFemaleDeathFall",
        -- "VoiceFemaleDeathEaten",
        -- "VoiceFemalePainFromFallHigh",
        -- "VoiceMalePainFromFallHigh",
        -- "VoiceMaleDeathAlone",
        -- "VoiceMaleDeathEaten",
    }

    local px, py = player:getX(), player:getY()
    local rx, ry = 50, 50
    if ZombRand(2) == 0 then rx = -rx end
    if ZombRand(2) == 0 then ry = -ry end
    local sx = px - rx
    local sy = py - ry

    local emitter = getWorld():getFreeEmitter(sx, sy, 0)
    if emitter then
        local id = emitter:playSound(BanditUtils.Choice(metaSounds), true)
    end
end