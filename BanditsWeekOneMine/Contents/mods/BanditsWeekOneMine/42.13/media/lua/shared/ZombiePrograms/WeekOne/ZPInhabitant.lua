ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Inhabitant = {}

ZombiePrograms.Inhabitant.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)
  
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Inhabitant.Main = function(bandit)
    local ts = getTimestampMs()
    local tasks = {}
    local brain = BanditBrain.Get(bandit)
    local id = brain.id
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()
    local world = getWorld()
    local cell = getCell()
    local cm = world:getClimateManager()
    local dls = cm:getDayLightStrength()
    local square = bandit:getSquare()
    local room = square:getRoom()
    local building = square:getBuilding()
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()

    local walkType = "Walk"
    local endurance = 0
    
    local health = bandit:getHealth()
    if health < 0.8 then
        walkType = "Limp"
        endurance = 0
    end 

    -- if outside building change program
    if bandit:isOutside() then
        Bandit.ClearTasks(bandit)
        Bandit.SetProgram(bandit, "Walker", {})

        local brain = BanditBrain.Get(bandit)
        local syncData = {}
        syncData.id = brain.id
        syncData.program = brain.program
        Bandit.ForceSyncPart(bandit, syncData)
        return {status=true, next="Main", tasks=tasks}
    end
    -- print ("INHABITANT 1: " .. (getTimestampMs() - ts))
    
    --[[local subTasks = BanditPrograms.FallbackAction(bandit)
    if #subTasks > 0 then
        for _, subTask in pairs(subTasks) do
            table.insert(tasks, subTask)
        end
    end
    if true then return {status=true, next="Main", tasks=tasks} end]]
    
    if room then

        -- leave player house
        local base = BanditPlayerBase.GetBase(bandit)
        if base then
            table.insert(tasks, BanditUtils.GetMoveTask(endurance, bandit:getX()-10, bandit:getY()-10, 0, "Run", 12, false))
            return {status=true, next="Defend", tasks=tasks}
        end
        
        local def = room:getRoomDef()
        local roomName = room:getName()

        -- global actions independent of room type
        
        -- symptoms
        if math.abs(id) % 4 > 0 then
            if BWOScheduler.SymptomLevel == 3 then
                walkType = "Limp"
            elseif BWOScheduler.SymptomLevel >= 4 then
                walkType = "Scramble"
            end

            local subTasks = BanditPrograms.Symptoms(bandit)
            if #subTasks > 0 then
                for _, subTask in pairs(subTasks) do
                    table.insert(tasks, subTask)
                end
                return {status=true, next="Main", tasks=tasks}
            end
        end

        -- instrusion
        ts = getTimestampMs()
        if BWOScheduler.SymptomLevel < 3 then
            local playerList = BanditPlayer.GetPlayers()
            for i=0, playerList:size()-1 do
                local player = playerList:get(i)
                if player and not BanditPlayer.IsGhost(player) then
                    local room = player:getSquare():getRoom()
                    
                    if room then
                        local roomName = room:getName()

                        if not player:isOutside() then
                            local dist = math.abs(bx - player:getX()) + math.abs(by - player:getY())
                            if dist < 30 and bandit:CanSee(player) and BWORooms.IsIntrusion(room) then
                                Bandit.Say(bandit, "DEFENDER_SPOTTED")
                                -- BWOScheduler.Add("CallCopsHostile", 1000)

                                if math.abs(id) % 2 == 0 then
                                    Bandit.SetHostileP(bandit, true)
                                    Bandit.SetProgramStage(bandit, "Defend")
                                    return {status=true, next="Defend", tasks=tasks}
                                end
                            end
                        end
                    end
                end
            end
        end

        -- print ("INHABITANT INTRUSION: " .. (getTimestampMs() - ts))

        -- react to events
        local subTasks = BanditPrograms.Events(bandit)
        if #subTasks > 0 then
            for _, subTask in pairs(subTasks) do
                table.insert(tasks, subTask)
            end
            return {status=true, next="Main", tasks=tasks}
        end
        -- print ("INHABITANT 3: " .. (getTimestampMs() - ts))

        -- atm
        local subTasks = BanditPrograms.ATM(bandit)
        if #subTasks > 0 then
            for _, subTask in pairs(subTasks) do
                table.insert(tasks, subTask)
            end
            return {status=true, next="Main", tasks=tasks}
        end
        -- print ("INHABITANT 4: " .. (getTimestampMs() - ts))

        -- house event actions
        local partyOn = false -- false
        if BWOScheduler.SymptomLevel < 3 then
            if BWOBuildings.IsEventBuilding(building, "party") then

                -- true music version
                -- local boombox = BWOObjects.Find(bandit, def, "Boombox")

                -- vanilla
                local boombox = BWOObjects.Find(bandit, def, "Radio")

                if boombox then

                    if hour >= 19 or hour < 7 then 
                        partyOn = true
                    end

                    if partyOn then
                        local dd = boombox:getDeviceData()
                        local ch = dd:getChannel()
                        local isPlaying = BWORadio.IsPlaying(boombox)

                        if not dd:getIsTurnedOn() or dd:getChannel() ~= 98600 or not isPlaying then -- true music version: or not boombox:getModData().tcmusic.isPlaying then
                            local square = boombox:getSquare()
                            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
                            if asquare then
                                local dist = math.sqrt(math.pow(bandit:getX() - (asquare:getX() + 0.5), 2) + math.pow(bandit:getY() - (asquare:getY() + 0.5), 2))
                                if dist > 0.70 then
                                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                                    return {status=true, next="Main", tasks=tasks}
                                else
                                    -- true music version
                                    -- local task = {action="BoomboxToggle", on=true, anim="Loot", x=square:getX(), y=square:getY(), z=square:getZ(), time=100}

                                    -- vanilla version

                                    local music = BanditUtils.Choice({"3fee99ec-c8b6-4ebc-9f2f-116043153195", 
                                                                      "0bc71c8a-f954-4dbf-aa09-ff09b015d6e2", 
                                                                      "a08b44db-b3cb-46a1-b04c-633e8e5b2a37", 
                                                                      "38fe9b5a-e932-477c-a6b5-96b9e7ea84da", 
                                                                      "2a379a08-4428-42b0-ae3d-0fb41c34f74c", 
                                                                      "2cc1e0e2-75ab-4ac3-9238-635813babc18", 
                                                                      "c688d4c8-dd7b-4d93-8e0f-c6cb5f488db2", 
                                                                      "22b4a025-6455-4c8d-b341-fd4f0f18836a"})

                                    -- music = "FlameTrapExplode"

                                    local task = {action="TelevisionToggle", on=true, channel=98600, volume=0.7, music=music, anim="Loot", x=square:getX(), y=square:getY(), z=square:getZ(), time=100}
                                    table.insert(tasks, task)
                                    return {status=true, next="Main", tasks=tasks}
                                end
                            end
                        end

                        local rnd = ZombRand(10)
                        if rnd == 0 then
                            local task = {action="Smoke", anim="Smoke", item="Bandits.Cigarette", left=true, time=100}
                            table.insert(tasks, task)
                            return {status=true, next="Main", tasks=tasks}
                        elseif rnd == 1 then
                            local task = {action="TimeItem", anim="Drink", item="Bandits.BeerBottle", left=true, time=100}
                            table.insert(tasks, task)
                            return {status=true, next="Main", tasks=tasks}
                        else
                            -- local anim = BanditUtils.Choice({"DanceHipHop3", "DanceLocking", "DanceShuffling", "DanceArmsHipHop", "DanceGandy", "DanceHouseDancing", "DanceRaiseTheRoof", "DanceRobotOne", "DanceRobotTwo", "DanceSnake"})
                            -- local anim = BanditUtils.Choice({"DanceHipHop1", "DanceHipHop2", "DanceHipHop3", "DanceRaiseTheRoof", "DanceBoogaloo", "DanceBodyWave", "DanceRibPops", "DanceShimmy"})
                            -- local anim = BanditUtils.Choice({"DanceHipHop3", "DanceRaiseTheRoof"})
                            local anim
                            if BanditCompatibility.GetGameVersion() >= 42 then
                                anim = BanditUtils.Choice({"DanceHipHop3", "DanceRaiseTheRoof", "Dance1", "Dance2", "Dance3", "Dance4"})
                            else
                                anim = BanditUtils.Choice({"DanceGandy", "DanceHouseDancing", "DanceShuffling", "DanceRaiseTheRoof", "Dance1", "Dance2", "Dance3", "Dance4"})
                            end

                            local task = {action="Time", anim=anim, time=500}
                            table.insert(tasks, task)
                            return {status=true, next="Main", tasks=tasks}
                        end
                    end
                end
            end
        end
        --  ("INHABITANT 5: " .. (getTimestampMs() - ts))

        -- light switch
        -- ts = getTimestampMs()
        if world:isHydroPowerOn() then
            local ls = BWOObjects.FindLightSwitch(bandit, room)
            if ls then

                local active = true
                --if (hour >= 6 and hour <= 8) or (hour >= 18 and hour <= 22) then
                if (hour < 6 or hour > 22) and roomName == "bedroom" then
                    active = false
                end

                if BWOBuildings.IsEventBuilding(building, "party") or BWOBuildings.IsEventBuilding(building, "home") then
                    active = false
                end

                if active ~= ls:isActivated() then
                    local square = ls:getSquare()
                    if not square:isFree(false) then
                        local asquare = AdjacentFreeTileFinder.Find(square, bandit)
                        if asquare then square = asquare end
                    end
                    if square then
                        local dist = math.sqrt(math.pow(bandit:getX() - (square:getX() + 0.5), 2) + math.pow(bandit:getY() - (square:getY() + 0.5), 2))
                        if dist > 0.70 then
                            table.insert(tasks, BanditUtils.GetMoveTask(0, square:getX(), square:getY(), square:getZ(), "Walk", dist, false))
                            return {status=true, next="Main", tasks=tasks}
                        else
                            local task = {action="LightToggle", anim="Loot", active=active, x=ls:getSquare():getX(), y=ls:getSquare():getY(), z=ls:getSquare():getZ()}
                            table.insert(tasks, task)
                            return {status=true, next="Main", tasks=tasks}
                        end
                    end
                end
            end
        end
        --print ("INHABITANT LS: " .. (getTimestampMs() - ts))

        --ts = getTimestampMs()
        local door = BWOObjects.FindExteriorDoor(bandit, def)
        if door then

            local unlock

            local hours = {}
            if BWOPopControl.ZombieMax > 0 then
                hours.open = -1
                hours.close = -1
            elseif BWORooms.IsShop(room) then
                hours.open = 8
                hours.close = 21
            elseif BWORooms.IsRestaurant(room) then
                hours.open = 8
                hours.close = 24
            else
                hours.open = -1
                hours.close = -1
            end
        
            if door:IsOpen() or not door:isLockedByKey() then
                if hour < hours.open or hour >= hours.close then
                    unlock = false -- lock doors
                end
            elseif door:isLockedByKey() or door:isLocked() then
                if (hour >= hours.open and hour < hours.close) or partyOn then
                    unlock = true -- unlock doors
                end
            end

            if unlock ~= nil then
                local standSquare = door:getSquare()
                if standSquare:isOutside() then
                    standSquare = door:getOppositeSquare()
                end

                local dist = math.sqrt(math.pow(bandit:getX() - (standSquare:getX() + 0.5), 2) + math.pow(bandit:getY() - (standSquare:getY() + 0.5), 2))
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, standSquare:getX(), standSquare:getY(), standSquare:getZ(), "Walk", dist, false))
                    return {status=true, next="Main", tasks=tasks}
                else
                    local task = {action="DoorLock", time=80, unlock=unlock, x=door:getX(), y=door:getY(), z=door:getZ()}
                    table.insert(tasks, task)
                    return {status=true, next="Main", tasks=tasks}
                end
            end
        end
        --print ("INHABITANT EXT-DOOR: " .. (getTimestampMs() - ts))
        -- print ("INHABITANT 7: " .. (getTimestampMs() - ts))

        -- barricade
        --ts = getTimestampMs()
        if BWOScheduler.NPC.Barricade and BWOBuildings.IsResidential(building) then
            local barricadable = BWOObjects.FindBarricadable(bandit, def)
            if barricadable then
                --local standSquare = barricadable:getIndoorSquare()
                local standSquare = barricadable:getSquare()
                if standSquare:isOutside() then
                    standSquare = barricadable:getOppositeSquare()
                end

                local dist = math.sqrt(math.pow(bandit:getX() - (standSquare:getX() + 0.5), 2) + math.pow(bandit:getY() - (standSquare:getY() + 0.5), 2))
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, standSquare:getX(), standSquare:getY(), standSquare:getZ(), "Walk", dist, false))
                    return {status=true, next="Main", tasks=tasks}
                else
                    local task1 = {action="Equip", itemPrimary="Base.Hammer"}
                    table.insert(tasks, task1)

                    local task2 = {action="Barricade", anim="Hammer", time=500, x=barricadable:getX(), y=barricadable:getY(), z=barricadable:getZ()}
                    table.insert(tasks, task2)
                    return {status=true, next="Main", tasks=tasks}
                end
            end
        end
        -- print ("INHABITANT 8: " .. (getTimestampMs() - ts))

        -- actions specific to room type
        if BWORoomPrograms[roomName] then
            local subTasks = BWORoomPrograms[roomName](bandit, def)
            if #subTasks > 0 then
                for _, subTask in pairs(subTasks) do
                    table.insert(tasks, subTask)
                end
                return {status=true, next="Main", tasks=tasks}
            end
        end
        --print ("INHABITANT RTYPE: " .. (getTimestampMs() - ts))
    end
    -- print ("INHABITANT 9: " .. (getTimestampMs() - ts))
    
    -- fallback
    local subTasks = BanditPrograms.FallbackAction(bandit)
    if #subTasks > 0 then
        for _, subTask in pairs(subTasks) do
            table.insert(tasks, subTask)
        end
    end

    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Inhabitant.Defend = function(bandit)
    local tasks = {}
    local cell = getCell()
    local bx, by, bz = bandit:getX(), bandit:getY(), bandit:getZ()
    local endurance = 0.00
 
    local config = {}
    config.mustSee = true
    config.hearDist = 5

    local target, enemy = BanditUtils.GetTarget(bandit, config)
    
    -- engage with target
    if target.x and target.y and target.z then
        local tx, ty, tz = target.x, target.y, target.z
    
        if enemy then
            if target.fx and target.fy and (enemy:isRunning()  or enemy:isSprinting()) then
                tx, ty = target.fx, target.fy
            end
        end

        local walkType = Bandit.GetCombatWalktype(bandit, enemy, target.dist)

        table.insert(tasks, BanditUtils.GetMoveTask(endurance, tx, ty, tz, walkType, target.dist))
        return {status=true, next="Defend", tasks=tasks}
    else
        Bandit.SetHostileP(bandit, false)
        Bandit.SetProgramStage(bandit, "Main")
        return {status=true, next="Main", tasks=tasks}
    end

    return {status=true, next="Defend", tasks=tasks}
end
