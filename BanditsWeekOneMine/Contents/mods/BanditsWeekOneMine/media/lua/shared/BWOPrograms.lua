BanditPrograms = BanditPrograms or {}

-- this is a collection of universal subprograms that are shared by main npc programs.

BanditPrograms.Symptoms = function(bandit)
    local tasks = {}

    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()

    local pseudoRandom = ZombRand(100)

    if BWOScheduler.SymptomLevel == 1 then

        if pseudoRandom < 5 then
            local rn = ZombRand(2)
            if rn == 0 then
                local sound
                if bandit:isFemale() then
                    sound = "ZSCoughF" .. (1 + ZombRand(4))
                else
                    sound = "ZSCoughM" .. (1 + ZombRand(4))
                end
                local task = {action="Time", anim="Cough", sound=sound, time=100}
                table.insert(tasks, task)
                return tasks
            else
                local task = {action="Time", anim="Sneeze", time=100}
                table.insert(tasks, task)
                return tasks
            end
        end
    elseif BWOScheduler.SymptomLevel == 2 then
        if pseudoRandom < 11 then
            local rn = ZombRand(11)
            if rn < 7 then
                local sound
                if bandit:isFemale() then
                    sound = "ZSCoughF" .. (1 + ZombRand(4))
                else
                    sound = "ZSCoughM" .. (1 + ZombRand(4))
                end
                local task = {action="Time", anim="Cough", sound=sound, time=100}
                table.insert(tasks, task)
                return tasks
            elseif rn == 7 then
                local task = {action="Time", anim="PainTorso", time=100}
                table.insert(tasks, task)
                return tasks
            elseif rn == 8 then
                local task = {action="Time", anim="PainStomach1", time=100}
                table.insert(tasks, task)
                return tasks
            elseif rn == 9 then
                local task = {action="Time", anim="PainStomach2", time=100}
                table.insert(tasks, task)
                return tasks
            elseif rn == 10 then
                local sound = "ZSVomit" .. (1 + ZombRand(4))
                local task = {action="Vomit", anim="Vomit", sound=sound, time=100}
                table.insert(tasks, task)
            end
        end
    elseif BWOScheduler.SymptomLevel == 3 then
        if pseudoRandom < 15 then
            local rn = ZombRand(20)
            if rn < 14 then
                local sound 
                if bandit:isFemale() then
                    sound = "ZSCoughF" .. (1 + ZombRand(4))
                else
                    sound = "ZSCoughM" .. (1 + ZombRand(4))
                end
                local task = {action="Time", anim="Cough", sound=sound, time=100}
                table.insert(tasks, task)
                return tasks
            elseif rn == 14 then
                local task = {action="Time", anim="PainTorso", time=100}
                table.insert(tasks, task)
                return tasks
            elseif rn == 15 then
                local task = {action="Time", anim="PainStomach1", time=100}
                table.insert(tasks, task)
                return tasks
            elseif rn == 16 then
                local task = {action="Time", anim="PainStomach2", time=100}
                table.insert(tasks, task)
                return tasks
            elseif rn == 17 then
                local task = {action="Time", anim="FeelFeint", time=100}
                table.insert(tasks, task)
                return tasks
            elseif rn == 17 then
                Bandit.UpdateInfection(bandit, 200)
            else
                local sound = "ZSVomit" .. (1 + ZombRand(4))
                local task = {action="Vomit", anim="Vomit", sound=sound, time=100}
                table.insert(tasks, task)

                return tasks
            end
        end
    elseif BWOScheduler.SymptomLevel == 4 then
        if pseudoRandom < 20 then
            local rn = ZombRand(20)
            if rn < 10 then
                local sound 
                if bandit:isFemale() then
                    sound = "ZSCoughF" .. (1 + ZombRand(4))
                else
                    sound = "ZSCoughM" .. (1 + ZombRand(4))
                end
                local task = {action="Vomit", anim="Scramble", sound=sound, time=100}
                table.insert(tasks, task)
                return tasks
            elseif rn < 14 then
                -- let's get the party started!!!
                Bandit.UpdateInfection(bandit, 200)
            else
                local sound = "ZSVomit" .. (1 + ZombRand(4))
                local task = {action="Vomit", anim="Scramble", sound=sound, time=100}
                table.insert(tasks, task)
                return tasks
            end
        end
    elseif BWOScheduler.SymptomLevel == 5 then
        if ZombRand(6) == 0 then
            Bandit.UpdateInfection(bandit, 200)
        end
    end
    return tasks
end

BanditPrograms.Events = function(bandit)
    local tasks = {}

    local player = getSpecificPlayer(0)
    if not player then return end

    if not BWOScheduler.NPC.ReactProtests then return tasks end

    local cell = bandit:getCell()
    local id = BanditUtils.GetCharacterID(bandit)

    local target = BWOObjects.FindGMD(bandit, "protest")
    if target.x and target.y and target.z then
        local square = cell:getGridSquare(target.x, target.y, target.z)
        if square and BanditUtils.LineClear(bandit, square) then
            if target.dist >= 9 and target.dist < 100 then
                local walkType = "Walk"
                table.insert(tasks, BanditUtils.GetMoveTask(0, target.x, target.y, target.z, walkType, target.dist, false))
                return tasks
            elseif target.dist < 9 then
                -- Bandit.Say(bandit, "ADMIRE")
                local rnd = math.abs(id) % 4

                local anim
                local sound
                local item
                if rnd == 0 then
                    anim = "Protest1"
                elseif rnd == 1 then
                    anim = "Protest2"
                    item = "Base.PaperSign"
                elseif rnd == 2 then
                    anim = "Protest3"
                    item = "Base.StopSign"
                elseif rnd == 3 then
                    anim = "Protest1"
                    -- anim = "Protest3"
                    -- item = "Base.TruthSign"
                else
                    anim = "Clap"
                end
                
                if ZombRand(3) == 0 then
                    if bandit:isFemale() then
                        local rn = 1 + ZombRand(9)
                        sound = "BWOTruthFemale" .. tostring(rn)
                    else
                        local rn = 1 + ZombRand(18)
                        sound = "BWOTruthMale" .. tostring(rn)
                    end
                end

                local task = {action="TimeItem", sound=sound, soundDistMax=12, anim=anim, left=true, item=item, x=target.x, y=target.y, z=target.z, time=200}
                table.insert(tasks, task)
                return tasks
            end
        end
    end

    if not BWOScheduler.NPC.ReactDeadBody then return tasks end

    local target = BWOObjects.FindDeadBody(bandit)
    if target.x and target.y and target.z then
        local square = cell:getGridSquare(target.x, target.y, target.z)
        if square and BanditUtils.LineClear(bandit, square) then
            if target.dist >= 5 and target.dist < 16 then
                local walkType = "Run"
                table.insert(tasks, BanditUtils.GetMoveTask(0, target.x, target.y, target.z, walkType, target.dist, false))
                return tasks
            elseif target.dist < 3 then
                if square then
                    deadbody = square:getDeadBody()
                    if deadbody then
                        Bandit.Say(bandit, "CORPSE")
                        local anim = BanditUtils.Choice({"SmellBad", "SmellGag", "PainHead", "ChewNails", "No", "No", "WipeBrow"})
                        local task = {action="FaceLocation", anim=anim, time=100, x=deadbody:getX(), y=deadbody:getY(), z=deadbody:getZ()}
                        table.insert(tasks, task)
                        return tasks
                    end
                end
            end
        end
    end

    if not BWOScheduler.NPC.ReactPreacher then return tasks end

    local target = BWOObjects.FindGMD(bandit, "preacher")
    if target.x and target.y and target.z then
        local square = cell:getGridSquare(target.x, target.y, target.z)
        if square and BanditUtils.LineClear(bandit, square) then
            if target.dist >= 4 and target.dist < 30 then
                local walkType = "Walk"
                table.insert(tasks, BanditUtils.GetMoveTask(0, target.x, target.y, target.z, walkType, target.dist, false))
                return tasks
            elseif target.dist < 4 then
                local ententainer = BanditUtils.GetClosestBanditLocationProgram(bandit, {"Entertainer"})

                if ententainer.id then
                    -- Bandit.Say(bandit, "ADMIRE")
                    local anim = "Yes"
                    local sound 
                    local task = {action="TimeEvent", sound=sound, soundDistMax=12, anim=anim, x=target.x, y=target.y, z=target.z, time=200}
                    table.insert(tasks, task)
                    return tasks
                else
                    local args = {x=target.x, y=target.y, z=target.z, otype="preacher"}
                    sendClientCommand(player, 'Commands', 'ObjectRemove', args)
                end
            end
        end
    end

    if not BWOScheduler.NPC.ReactEntertainers then return tasks end

    local target = BWOObjects.FindGMD(bandit, "entertainer")
    if target.x and target.y and target.z then
        local square = cell:getGridSquare(target.x, target.y, target.z)
        if square and BanditUtils.LineClear(bandit, square) then
            if target.dist >= 6 and target.dist < 30 then
                local walkType = "Walk"
                table.insert(tasks, BanditUtils.GetMoveTask(0, target.x, target.y, target.z, walkType, target.dist, false))
                return tasks
            elseif target.dist < 6 then
                local ententainer = BanditUtils.GetClosestBanditLocationProgram(bandit, {"Entertainer"})

                if ententainer.id then
                    Bandit.Say(bandit, "ADMIRE")
                    local anim = "Clap"
                    local sound = "BWOClap" .. tostring(1 + ZombRand(13))
                    local task = {action="TimeEvent", sound=sound, soundDistMax=12, anim=anim, x=target.x, y=target.y, z=target.z, time=200}
                    table.insert(tasks, task)
                    return tasks
                else
                    local args = {x=target.x, y=target.y, z=target.z, otype="entertainer"}
                    sendClientCommand(player, 'Commands', 'ObjectRemove', args)
                end
            end
        end
    end
    return tasks
end

BanditPrograms.Bench = function(bandit)
    local tasks = {}

    if not BWOScheduler.NPC.SitBench then return tasks end

    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local cell = bandit:getCell()

    local target = BWOObjects.FindGMD(bandit, "sittable")
    if target.x and target.y and target.z and target.dist < 14 then
        local square = cell:getGridSquare(target.x, target.y, target.z)
        if square and square:isOutside() and BanditUtils.LineClear(bandit, square) then
            local id = BanditUtils.GetCharacterID(bandit)
            local zombie = square:getZombie()
            if (not zombie or BanditUtils.GetCharacterID(zombie) == id) then
                local objects = square:getObjects()
                local bench
                local facing
                for i=0, objects:size()-1 do
                    local object = objects:get(i)
                    local sprite = object:getSprite()
                    if sprite then
                        local props = sprite:getProperties()
                        if props:Is("CustomName") then
                            local customName = props:Val("CustomName")
                            if customName == "Bench" or customName == "Chair" then
                                bench = object
                                facing = props:Val("Facing")
                                break
                            end
                        end
                    end
                end

                if bench then
                    local asquare = AdjacentFreeTileFinder.Find(square, bandit)
                    if asquare then
                        local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                        if dist > 1.6 then
                            table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX() + 0.5, asquare:getY() + 0.5, asquare:getZ(), "Walk", dist, false))
                            return tasks
                        else
                            local anim
                            local sound
                            local item
                            local smoke = false
                            local time = 200
                            local right = false
                            local left = false
                            local r = math.floor(math.abs(id) / hour) % 7
                            if r == 0 then
                                anim = "SitInChair1"
                            elseif r == 1 then
                                anim = "SitInChair2"
                            elseif r == 2 then
                                anim = "SitInChairTalk"
                            elseif r == 3 then
                                anim = "SitInChairDrink"
                                item = "Bandits.BeerBottle"
                                sound = "DrinkingFromBottle"
                                right = true
                            elseif r == 4 then
                                anim = "SitInChairEat"
                                right = true
                            elseif r == 5 then
                                anim = "SitInChairSmoke"
                                sound = "Smoke"
                                smoke = true
                                time = 400
                            elseif r == 6 then
                                anim = "SitInChairRead"
                                sound = "PageFlipBook"
                                item = "Bandits.Book"
                                left = true
                                time = 600
                            end

                            local task = {action="SitInChair", anim=anim, sound=sound, item=item, left=left, right=right, x=square:getX(), y=square:getY(), z=square:getZ(), facing=facing, time=100}
                            table.insert(tasks, task)
                            return tasks
                        end
                    end
                end
            end
        end
    end

    return tasks
end

BanditPrograms.ATM = function(bandit)
    local tasks = {}
    local cell = bandit:getCell()

    if not BWOScheduler.NPC.BankRun then return tasks end

    local target = BWOObjects.FindGMD(bandit, "atm")      
    if target.x and target.y and target.z and target.dist < 25 then
        local square = cell:getGridSquare(target.x, target.y, target.z)
        if square and BanditUtils.LineClear(bandit, square) then
            local objects = square:getObjects()
            local atm
            local standSquare
            local fx = 0
            local fy = 0
            for i=0, objects:size()-1 do
                local object = objects:get(i)
                local sprite = object:getSprite()
                if sprite then
                    local spriteName = sprite:getName()
                    if spriteName == "location_business_bank_01_67" then
                        atm = object
                        standSquare = square
                        fy = -1.5
                    elseif spriteName == "location_business_bank_01_66" then
                        atm = object
                        standSquare = square
                        fx = -1.5
                    elseif spriteName == "location_business_bank_01_65" then
                        atm = object
                        standSquare = square:getS()
                        fx = -1.5
                    elseif spriteName == "location_business_bank_01_64" then
                        atm = object
                        standSquare = square:getE()
                        fx = -1.5
                    end
                end
            end

            if atm then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), standSquare:getX() + 0.5, standSquare:getY() + 0.5)
                if dist > 0.4 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, standSquare:getX(), standSquare:getY(), standSquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    Bandit.Say(bandit, "ATMFAIL")
                    local task = {action="FaceLocation", anim="Loot", sound="ZSObjectATMFail", x=target.x+fx, y=target.y+fy, z=target.z, time=300}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    end
    return tasks
end

BanditPrograms.FallbackAction = function(bandit)
    local tasks = {}
    local action = ZombRand(10)

    if action == 0 then
        local task = {action="Time", anim="ShiftWeight", time=200}
        table.insert(tasks, task)
    elseif action == 1 then
        local task = {action="Time", anim="ChewNails", time=200}
        table.insert(tasks, task)
    elseif action == 2 then
        local task = {action="Time", anim="Smoke", time=200}
        table.insert(tasks, task)
        table.insert(tasks, task)
        table.insert(tasks, task)
    elseif action == 3 then
        local task = {action="Time", anim="PullAtCollar", time=200}
        table.insert(tasks, task)
    elseif action == 4 then
        local task = {action="Time", anim="Sneeze", time=200}
        table.insert(tasks, task)
        addSound(getPlayer(), bandit:getX(), bandit:getY(), bandit:getZ(), 7, 60)
    elseif action == 5 then
        local task = {action="Time", anim="WipeBrow", time=200}
        table.insert(tasks, task)
    elseif action == 6 then
        local task = {action="Time", anim="WipeHead", time=200}
        table.insert(tasks, task)
    elseif action == 7 then
        if BWOScheduler.WorldAge < 34 then
            Bandit.Say(bandit, "STREETCHAT1")
        else
            Bandit.Say(bandit, "STREETCHAT2")
        end
        local anim = BanditUtils.Choice({"Talk1", "Talk2", "Talk3", "Talk4", "Talk5"})
        local task = {action="Time", anim=anim, time=200}
        table.insert(tasks, task)
    else
        local task = {action="Time", anim="ChewNails", time=200}
        table.insert(tasks, task)
    end

    return tasks
end

BanditPrograms.Talk = function(bandit)
    local tasks = {}

    if not BWOScheduler.NPC.Talk then return tasks end

    local config = {}
    config.mustSee = false
    config.hearDist = 40

    local neighborBandit = BanditUtils.GetClosestBanditLocation(bandit)
    local neighborPlayer = BanditUtils.GetClosestPlayerLocation(bandit, config)

    local neighbor = neighborBandit
    local minDist = 3
    local blood
    local health
    if neighborPlayer.dist < neighborBandit.dist then
        neighbor = neighborPlayer
        minDist = 5
        local player = BanditPlayer.GetPlayerById(neighbor.id)
        local bodyDamage = player:getBodyDamage()
        blood = player:getTotalBlood()
        health = bodyDamage:getOverallBodyHealth()

    end

    if neighbor.dist < minDist then
        local square = getCell():getGridSquare(neighbor.x, neighbor.y, neighbor.z)
        if square and BanditUtils.LineClear(bandit, square) then
            if ZombRand(2) == 0 then
                if health and health < 50 then
                    Bandit.Say(bandit, "STREETCHATHEALTH")
                elseif blood and blood > 0 then
                    Bandit.Say(bandit, "STREETCHATBLOOD")
                else
                    if BWOScheduler.WorldAge < 34 then
                        Bandit.Say(bandit, "STREETCHAT1")
                    else
                        Bandit.Say(bandit, "STREETCHAT2")
                    end
                end

                local anim = BanditUtils.Choice({"WaveHi", "Yes", "No", "Talk1", "Talk2", "Talk3", "Talk4", "Talk5"})
                local task = {action="FaceLocation", anim=anim, x=neighbor.x, y=neighbor.y, z=neighbor.z, time=100}
                table.insert(tasks, task)
                return tasks
            end
        end
    end
    return tasks
end

BanditPrograms.FollowRoad = function(bandit, walkType)

    local function getGroundQuality(square)
        local quality
        local objects = square:getObjects()
        for i=0, objects:size()-1 do
            local object = objects:get(i)
            if object then
                local sprite = object:getSprite()
                if sprite then
                    local spriteName = sprite:getName()
                    if spriteName then
                        
                        if spriteName:embodies("tilesandstone") then
                            -- best quality pedestrian pavements
                            quality = 1
                            break
                        elseif spriteName:embodies("street") then
                            local spriteProps = sprite:getProperties()
                            if spriteProps:Is(IsoFlagType.attachedFloor) then
                                local material = spriteProps:Val("FootstepMaterial")
                                if material == "Gravel" then
                                    -- gravel path
                                    quality = 1 -- 2
                                else
                                    -- probably main road
                                    quality = 4
                                end
                            else
                                -- probably parking
                                quality = 1 -- 3
                            end

                            break
                        end
                    end
                end
            end
        end
        return quality
    end

    local tasks = {}

    local player = getSpecificPlayer(0)
    if not player then return end

    local cell = bandit:getCell()
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()

    -- react to cars
    local vehicleList = {}
    local npcVehicles = BWOVehicles.tab
    for k, v in pairs(npcVehicles) do
        if v:getController() and not v:isStopped() then
            vehicleList[k] = v
        end
    end

    local playerVehicle = player:getVehicle()
    if playerVehicle and not playerVehicle:isStopped() then
        vehicleList[playerVehicle:getId()] = playerVehicle
    end

    for id, vehicle in pairs(vehicleList) do
        local vx = vehicle:getX()
        local vy = vehicle:getY()
        local dist = BanditUtils.DistTo(bx, by, vx, vy)
        if dist < 10 then
            local vay = vehicle:getAngleY()
            local ba = bandit:getDirectionAngle()

            -- angles of cars are 90 degrees rotated compared to character angles
            -- normalize this
            vay = vay - 90
            if vay < -180 then vay = vay + 360 end

            local escapeAngle = vay - 90
            if escapeAngle < 180 then escapeAngle = escapeAngle + 360 end 

            local theta = escapeAngle * math.pi * 0.00555555--/ 180
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
            
            -- print ("should escape to lx: " .. lx .. " ly: " .. ly)
            table.insert(tasks, BanditUtils.GetMoveTask(0, bx + lx, by + ly, 0, "Run", 10, false))
            return tasks
            
        end
    end

    local direction = bandit:getForwardDirection()
    local angle = direction:getDirection()
    direction:setLength(8)

    local options = {}
    options[1] = {} -- pavements
    options[2] = {} -- gravel roads
    options[3] = {} -- parkings
    options[4] = {} -- main roads
    options[5] = {} -- unused

    local step = 0.785398163 / 2 -- 22.5 deg
    for i = 0, 14 do
        for j=-1, 1, 2 do
            local newangle = angle + (i * j * step)
            if newangle > 6.283185304 then newangle = newangle - 6.283185304 end
            direction:setDirection(newangle)

            local vx = bx + direction:getX()
            local vy = by + direction:getY()
            local vz = bz
            local square = cell:getGridSquare(vx, vy, vz)
            if square and square:isOutside() then
                local groundQuality = getGroundQuality(square)
                if groundQuality then
                    table.insert(options[groundQuality], {x=vx, y=vy, z=vz})
                end
            end
        end
    end

    for _, opts in pairs(options) do
        for _, opt in pairs(opts) do
            table.insert(tasks, BanditUtils.GetMoveTask(0, opt.x, opt.y, opt.z, walkType, 2, false))
            return tasks
        end
    end
    
    return tasks
end

BanditPrograms.GoSomewhere = function(bandit, walkType)
    local tasks = {}
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()
    local id = BanditUtils.GetCharacterID(bandit)

    local rnd = math.abs(id) % 4
    local dx = 0
    local dy = 0
    if rnd == 0 then
        dx = 8 + ZombRand(5)
    elseif rnd == 1 then
        dy = 8 + ZombRand(5)
    elseif rnd == 2 then
        dx = -(8 + ZombRand(5))
    elseif rnd == 3 then
        dy = -(8 + ZombRand(5))
    end

    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    if hour % 2 == 0 then
        dx = -dx
        dy = -dy
    end

    table.insert(tasks, BanditUtils.GetMoveTask(0, bx + dx, by + dy, 0, walkType, 10, false))
    return tasks
end

BanditPrograms.Fallback = function(bandit)
    local tasks = {}
    local rnd = ZombRand(2)

    if rnd == 0 then
        local task = {action="Smoke", anim="Smoke", item="Bandits.Cigarette", left=true, time=100}
        table.insert(tasks, task)
    else
        local anim = BanditUtils.Choice({"WipeBrow", "WipeHead"})
        local task = {action="Time", anim=anim, time=100}
        table.insert(tasks, task)
    end
    return tasks
end