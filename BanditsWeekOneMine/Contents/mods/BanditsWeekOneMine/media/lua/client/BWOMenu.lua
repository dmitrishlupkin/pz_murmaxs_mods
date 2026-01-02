local TAHeal = require("TimedActions/TAHeal")

BWOMenu = BWOMenu or {}

BWOMenu.HealPerson = function(player, square, bandit)
    local task = {action="TimeEvent", anim="Yes", x=bandit:getX(), y=bandit:getY(), time=400}
    Bandit.AddTask(bandit, task)
    if luautils.walkAdj(player, bandit:getSquare()) then
        ISTimedActionQueue.add(TAHeal:new(player, square, bandit))
    end
end

BWOMenu.DisableLaunchSequence = function(player, square)
    if luautils.walkAdj(player, square) then
        ISTimedActionQueue.add(TADisableNuke:new(player, square))
    end
end

BWOMenu.SpawnRoom = function(player, square, prgName)

    config = {}
    config.clanId = 0
    config.hasRifleChance = 0
    config.hasPistolChance = 0
    config.rifleMagCount = 0
    config.pistolMagCount = 0

    local event = {}
    event.hostile = false
    event.occured = false
    event.program = {}
    event.program.name = prgName
    event.program.stage = "Prepare"
    event.bandits = {}

    local room = square:getRoom()
    if room then
        local name = room:getName()
        local roomDef = room:getRoomDef()
        if roomDef then
            local spawnSquare = roomDef:getFreeSquare()
            if spawnSquare then
                event.x = spawnSquare:getX()
                event.y = spawnSquare:getY()
                event.z = spawnSquare:getZ()
                local bandit = BanditCreator.MakeFromRoom(room)
                if bandit then
                    table.insert(event.bandits, bandit)
                    sendClientCommand(player, 'Commands', 'SpawnGroup', event)
                end
            end
        end
    end
end

BWOMenu.SpawnWave = function(player, square, prgName)
    local args = {
        size = 1,
        program = prgName,
        x = square:getX(),
        y = square:getY(),
        z = square:getZ()
    }

    if prgName == "Babe" then
        args.permanent = true
        args.loyal = true
    end

    if prgName == "Walker" then
        args.cid = Bandit.clanMap.Walker
    elseif prgName == "Fireman" then
        args.cid = Bandit.clanMap.Fireman
    elseif prgName == "Gardener" then
        args.cid = Bandit.clanMap.Gardener
    elseif prgName == "Janitor" then
        args.cid = Bandit.clanMap.Janitor
    elseif prgName == "Medic" then
        args.cid = Bandit.clanMap.Medic
    elseif prgName == "Postal" then
        args.cid = Bandit.clanMap.Postal
    elseif prgName == "Runner" then
        args.cid = Bandit.clanMap.Runner
    elseif prgName == "Vandal" then
        args.cid = Bandit.clanMap.Vandal
    elseif prgName == "Shahid" then
        args.cid = Bandit.clanMap.SuicideBomber
    elseif prgName == "Babe" then
        if player:isFemale() then
            args.cid = Bandit.clanMap.BabeMale
        else
            args.cid = Bandit.clanMap.BabeFemale
        end
    end
    sendClientCommand(player, 'Spawner', 'Clan', args)
end

BWOMenu.FlushDeadbodies = function(player)
    local args = {a=1}
    sendClientCommand(getSpecificPlayer(0), 'Commands', 'DeadBodyFlush', args)
end

BWOMenu.Ambience = function(player, status)
    if status then
        BWOAmbience.Enable("radiation")
    else
        BWOAmbience.Disable("radiation")
    end
end

BWOMenu.AddEffect = function(player, square)
    --[[
    local effect = {}
    effect.x = square:getX()
    effect.y = square:getY()
    effect.z = square:getZ()
    effect.size = 600
    effect.poison = true
    effect.colors = {r=0.1, g=0.7, b=0.2, a=0.2}
    effect.name = "mist"
    effect.frameCnt = 60
    effect.repCnt = 2
    table.insert(BWOEffects2.tab, effect)
    ]]

    local effect = {}
    effect.x = square:getX()
    effect.y = square:getY()
    effect.z = square:getZ()
    effect.size = 640
    effect.colors = {r=0.1, g=0.7, b=0.2, a=0.2}
    effect.name = "explobig"
    effect.frameCnt = 17
    table.insert(BWOEffects2.tab, effect)
end

BWOMenu.EventArmy = function(player)
    local params = {}
    params.intensity = 12
    BWOScheduler.Add("Army", params, 100)
end

BWOMenu.EventArmyPatrol = function(player)
    local params = {}
    params.intensity = 9
    BWOScheduler.Add("ArmyPatrol", params, 100)
end

BWOMenu.EventArson = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    BWOScheduler.Add("Arson", params, 100)
end

BWOMenu.EventGasDrop = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    params.outside = player:isOutside()
    BWOScheduler.Add("GasDrop", params, 100)
end

BWOMenu.EventGasRun = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    params.outside = player:isOutside()
    params.intensity = 10
    BWOScheduler.Add("GasRun", params, 100)
end

BWOMenu.EventBombDrop = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    params.outside = player:isOutside()
    BWOScheduler.Add("BombDrop", params, 100)
end

BWOMenu.EventBombRun = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    params.intensity = 20
    params.outside = player:isOutside()
    BWOScheduler.Add("BombRun", params, 100)
end

BWOMenu.EventNuke = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.r = 80
    BWOScheduler.Add("Nuke", params, 100)
end

BWOMenu.EventFinalSolution = function(player)
    local params = {}
    BWOScheduler.Add("FinalSolution", params, 100)
end

BWOMenu.EventFliers = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    BWOScheduler.Add("ChopperFliers", params, 100)
end

BWOMenu.EventEntertainer = function(player, eid)
    local params ={}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    params.eid = eid
    BWOScheduler.Add("Entertainer", params, 100)
end

BWOMenu.EventHome = function (player)
    local params = {}
    params.addRadio = true
    BWOScheduler.Add("BuildingHome", params, 100)
end

BWOMenu.EventParty = function (player)
    local params = {}
    params.roomName = "bedroom"
    params.intensity = 8
    BWOScheduler.Add("BuildingParty", params, 100)
end

BWOMenu.EventJetFighter = function (player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    params.outside = player:isOutside()
    BWOScheduler.Add("JetFighter", params, 100)
end

BWOMenu.EventJetFighterRun = function (player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    params.outside = player:isOutside()
    BWOScheduler.Add("JetFighterRun", params, 100)
end

BWOMenu.EventProtest = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    BWOScheduler.Add("Protest", params, 100)
end

BWOMenu.EventReanimate = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    params.r = 50
    params.chance = 100
    BWOScheduler.Add("Reanimate", params, 100)
end

BWOMenu.EventStart = function(player)
    local params = {}
    BWOScheduler.Add("Start", params, 100)
end

BWOMenu.EventStartDay = function(player)
    local params = {}
    params.day = "wednesday"
    BWOScheduler.Add("StartDay", params, 100)
end

BWOMenu.EventPoliceRiot = function(player)
    local params = {}
    params.intensity = 10
    params.hostile = true
    BWOScheduler.Add("PoliceRiot", params, 100)
end

BWOMenu.EventPlaneCrash = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    BWOScheduler.Add("PlaneCrash", params, 100)
end

BWOMenu.EventPower = function(player, on)
    local params = {}
    params.on = on
    BWOScheduler.Add("SetHydroPower", params, 100)
end

BWOMenu.EventBikers = function(player)
    local params = {}
    params.intensity = 5
    BWOScheduler.Add("Bikers", params, 100)
end

BWOMenu.EventCriminals = function(player)
    local params = {}
    params.intensity = 3
    BWOScheduler.Add("Criminals", params, 100)
end

BWOMenu.EventDream = function(player)
    local params = {}
    params.night = 5
    BWOScheduler.Add("Dream", params, 100)
end

BWOMenu.EventBandits = function(player)
    local params = {}
    params.intensity = 7
    BWOScheduler.Add("Bandits", params, 100)
end

BWOMenu.EventThieves = function(player)
    local params = {}
    params.intensity = 2
    BWOScheduler.Add("Thieves", params, 100)
end

BWOMenu.EventShahids = function(player)
    local params = {}
    params.intensity = 1
    BWOScheduler.Add("Shahids", params, 100)
end

BWOMenu.EventHammerBrothers = function(player)
    local params = {}
    params.intensity = 2
    BWOScheduler.Add("HammerBrothers", params, 100)
end

BWOMenu.EventStorm = function(player)
    local params = {}
    params.len = 1440
    BWOScheduler.Add("WeatherStorm", params, 1000)
end



function BWOMenu.WorldContextMenuPre(playerID, context, worldobjects, test)

    local player = getSpecificPlayer(playerID)
    if not player then return end

    local profession = player:getDescriptor():getProfession()
    -- print ("DIR: " .. player:getDirectionAngle())

    local square = BanditCompatibility.GetClickedSquare()

    local zombie = square:getZombie()
    if not zombie then
        local squareS = square:getS()
        if squareS then
            zombie = squareS:getZombie()
            if not zombie then
                local squareW = square:getW()
                if squareW then
                    zombie = squareW:getZombie()
                end
            end
        end
    end

    -- doctor healing
    if zombie and zombie:getVariableBoolean("Bandit") then
        local health = zombie:getHealth()
        if (profession == "doctor" or profession == "nurse") and health < 0.8 or zombie:isCrawling() then
            context:addOption("Heal Person", player, BWOMenu.HealPerson, square, zombie)
        end
    end

    if BanditCompatibility.GetGameVersion() >= 42 then
        if square:getZ() == -16 and square:getX() == 5556 and (square:getY() == 12445 or square:getY() == 12446 or square:getY() == 12447)  then
            context:addOption("Disable Launch Sequence", player, BWOMenu.DisableLaunchSequence, square)
        end
    else
        if square:getZ() == 0 and square:getX() == 5572 and square:getY() == 12486 then
            context:addOption("Disable Launch Sequence", player, BWOMenu.DisableLaunchSequence, square)
        end
    end

    if isDebugEnabled() or isAdmin() then

        local objects = square:getObjects()
        for i=0, objects:size()-1 do
            local object = objects:get(i)
            if instanceof(object, "IsoRadio") then
                local dd = object:getDeviceData()
                BWORadio.PlaySound(object, "197ddd73-7662-41d5-81e0-63b83a58ab60")
            end
        end

        -- local density = BanditScheduler.GetDensityScore(player, 120) * 1.4
        -- print ("DENSITY: " .. density)

        -- local density2 = BWOBuildings.GetDensityScore(player, 120) / 6000
        -- print ("DENSITY2: " .. density2)

        -- player:playSound("197ddd73-7662-41d5-81e0-63b83a58ab60")
        local eventsOption = context:addOption("BWO Event")
        local eventsMenu = context:getNew(context)

        context:addSubMenu(eventsOption, eventsMenu)

        eventsMenu:addOption("Army", player, BWOMenu.EventArmy)
        eventsMenu:addOption("Army Patrol", player, BWOMenu.EventArmyPatrol)
        eventsMenu:addOption("Arson", player, BWOMenu.EventArson)
        eventsMenu:addOption("Bandits", player, BWOMenu.EventBandits)
        eventsMenu:addOption("Bikers", player, BWOMenu.EventBikers)
        eventsMenu:addOption("Bomb Drop", player, BWOMenu.EventBombDrop)
        eventsMenu:addOption("Bomb Run", player, BWOMenu.EventBombRun)
        eventsMenu:addOption("Criminals", player, BWOMenu.EventCriminals)
        eventsMenu:addOption("Dream", player, BWOMenu.EventDream)

        local entertainerOption = eventsMenu:addOption("Entertainer")
        local entertainerMenu = context:getNew(context)
        eventsMenu:addSubMenu(entertainerOption, entertainerMenu)

        entertainerMenu:addOption("Priest", player, BWOMenu.EventEntertainer, 0)
        entertainerMenu:addOption("Guitarist", player, BWOMenu.EventEntertainer, 1)
        entertainerMenu:addOption("Violinist", player, BWOMenu.EventEntertainer, 2)
        entertainerMenu:addOption("Saxophonist", player, BWOMenu.EventEntertainer, 3)
        entertainerMenu:addOption("Breakdancer", player, BWOMenu.EventEntertainer, 4)
        entertainerMenu:addOption("Clown 1", player, BWOMenu.EventEntertainer, 5)
        entertainerMenu:addOption("Clown 2", player, BWOMenu.EventEntertainer, 6)

        eventsMenu:addOption("Final Solution", player, BWOMenu.EventFinalSolution)
        eventsMenu:addOption("Fliers", player, BWOMenu.EventFliers)
        eventsMenu:addOption("Gas Drop", player, BWOMenu.EventGasDrop)
        eventsMenu:addOption("Gas Run", player, BWOMenu.EventGasRun)
        eventsMenu:addOption("Hammer Brothers", player, BWOMenu.EventHammerBrothers)
        eventsMenu:addOption("House Register", player, BWOMenu.EventHome)
        eventsMenu:addOption("House Party", player, BWOMenu.EventParty)
        eventsMenu:addOption("Jetfighter", player, BWOMenu.EventJetFighter)
        eventsMenu:addOption("Jetfighter Run", player, BWOMenu.EventJetFighterRun)
        eventsMenu:addOption("Nuke", player, BWOMenu.EventNuke)
        eventsMenu:addOption("Rolice Riot", player, BWOMenu.EventPoliceRiot)
        eventsMenu:addOption("Plane Crash", player, BWOMenu.EventPlaneCrash, true)
        eventsMenu:addOption("Power On", player, BWOMenu.EventPower, true)
        eventsMenu:addOption("Power Off", player, BWOMenu.EventPower, false)
        eventsMenu:addOption("Protest", player, BWOMenu.EventProtest)
        eventsMenu:addOption("Reanimate", player, BWOMenu.EventReanimate)
        eventsMenu:addOption("Shahid", player, BWOMenu.EventShahids)
        eventsMenu:addOption("Start", player, BWOMenu.EventStart)
        eventsMenu:addOption("Start Day", player, BWOMenu.EventStartDay)
        eventsMenu:addOption("Storm", player, BWOMenu.EventStorm)
        eventsMenu:addOption("Thieves", player, BWOMenu.EventThieves)
        
        local spawnOption = context:addOption("BWO Spawn")
        local spawnMenu = context:getNew(context)
        context:addSubMenu(spawnOption, spawnMenu)
        
        spawnMenu:addOption("Babe", player, BWOMenu.SpawnWave, square, "Babe")
        spawnMenu:addOption("Fireman", player, BWOMenu.SpawnWave, square, "Fireman")
        spawnMenu:addOption("Gardener", player, BWOMenu.SpawnWave, square, "Gardener")
        spawnMenu:addOption("Inhabitant", player, BWOMenu.SpawnRoom, square, "Inhabitant")
        spawnMenu:addOption("Janitor", player, BWOMenu.SpawnWave, square, "Janitor")
        spawnMenu:addOption("Medic", player, BWOMenu.SpawnWave, square, "Medic")
        spawnMenu:addOption("Postal", player, BWOMenu.SpawnWave, square, "Postal")
        spawnMenu:addOption("Runner", player, BWOMenu.SpawnWave, square, "Runner")
        spawnMenu:addOption("Shahid", player, BWOMenu.SpawnWave, square, "Shahid")
        spawnMenu:addOption("Survivor", player, BWOMenu.SpawnWave, square, "Survivor")
        spawnMenu:addOption("Vandal", player, BWOMenu.SpawnWave, square, "Vandal")
        spawnMenu:addOption("Walker", player, BWOMenu.SpawnWave, square, "Walker")
        
        context:addOption("BWO Deadbodies: Flush", player, BWOMenu.FlushDeadbodies)
        context:addOption("BWO Ambience On", player, BWOMenu.Ambience, true)
        context:addOption("BWO Ambience Off", player, BWOMenu.Ambience, false)
        context:addOption("BWO Add Effect", player, BWOMenu.AddEffect, square)
        
        local room = square:getRoom()
        if room then
            local bid = room:getBuilding():getID()
            local roomName = room:getName()
            local def = room:getRoomDef()
            local roomSize = BWORooms.GetRoomSize(room)
            local popMod = BWORooms.GetRoomPopMod(room)
            local popMax = BWORooms.GetRoomMaxPop(room)
            print ("ROOM: " .. roomName)
            print ("SIZE: " .. roomSize)
            print ("POPMOD: " .. popMod)
            print ("POPMAX: " .. popMax)
            print ("HOME: " .. tostring(BWOBuildings.IsEventBuilding(room:getBuilding(), "home")))

        end
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(BWOMenu.WorldContextMenuPre)
