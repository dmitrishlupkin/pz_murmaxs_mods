BWORoomPrograms = BWORoomPrograms or {}

local function predicateAll(item)
    -- item:getType()
    return true
end

-- this is a collection of subprograms that crerates tasks for npcs based on the room they are currently in.

BWORoomPrograms.livingroom = function(bandit, def)
    local tasks = {}
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()

    local piano = BWOObjects.Find(bandit, def, "Piano")
    local stool = BWOObjects.Find(bandit, def, "Stool")
    if piano and stool then
        if true then -- (hour > 5 and hour < 23) then
            local square = stool:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 1.20 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local anim = "InstrumentPiano"
                    local sound = "BWOInstrumentPiano1"
                    local sprite = stool:getSprite()
                    local spriteName = sprite:getName()
                    if spriteName == "recreational_01_11" then
                        local task = {action="TimeEvent", sound=sound, anim=anim, x=piano:getX(), y=piano:getY() - 1, z=piano:getZ(), lx=stool:getX() + 0.8, ly=stool:getY() + 0.25, time=3000}
                        table.insert(tasks, task)
                        return tasks
                    elseif spriteName == "recreational_01_14" then
                        local task = {action="TimeEvent", sound=sound, anim=anim, x=piano:getX() - 1, y=piano:getY(), z=piano:getZ(), lx=stool:getX() + 0.25, ly=stool:getY() - 0.2, time=3000}
                        table.insert(tasks, task)
                        return tasks
                    end
                end
            end
        end
    end

    local tv = BWOObjects.Find(bandit, def, "Television")
    if tv then
        local dd = tv:getDeviceData()
        if (hour > 5 and hour < 23 and not dd:getIsTurnedOn()) or ((hour < 6 or hour > 22) and dd:getIsTurnedOn()) then
            local square = tv:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="TelevisionToggle", on=true, channel=241, volume=0.2, anim="Loot", x=square:getX(), y=square:getY(), z=square:getZ(), time=100}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    end

    local radio = BWOObjects.Find(bandit, def, "Radio")
    if radio then
        local dd = radio:getDeviceData()
        if not dd:getIsTurnedOn() or dd:getChannel() ~= 98400 then
            local square = radio:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="TelevisionToggle", on=true, channel=98400, volume=0.4, anim="Loot", x=square:getX(), y=square:getY(), z=square:getZ(), time=100}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    end

    local sittable = BWOObjects.Find(bandit, def, "Couch")
    if not sittable then
        sittable = BWOObjects.Find(bandit, def, "Chair")
    end

    if sittable then
        local square = sittable:getSquare()
        local asquare = AdjacentFreeTileFinder.Find(square, bandit)
        if asquare then
            local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
            if dist > 1.20 then
                table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                return tasks
            else
                local anim
                local sound
                local item
                local smoke = false
                local time = 200
                local right = false
                local left = false
                local r = ZombRand(7)
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

                local facing = sittable:getSprite():getProperties():Val("Facing")

                local task = {action="SitInChair", anim=anim, left=left, right=right, sound=sound, item=item, x=sittable:getX(), y=sittable:getY(), z=sittable:getZ(), facing=facing, time=200}
                table.insert(tasks, task)
                return tasks
            end
        end
    end
    return tasks
end

BWORoomPrograms.hall = BWORoomPrograms.livingroom

BWORoomPrograms.bathroom = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()

    --[[local sittable = BWOObjects.Find(bandit, def, "Toilet")
    if sittable then
        local facing = sittable:getSprite():getProperties():Val("Facing")
        local task = {action="SitInChair", anim="SitInChair", x=sittable:getX(), y=sittable:getY(), z=sittable:getZ(), facing=facing, time=100}
        table.insert(tasks, task)
        return tasks
    end]]

    local sink = BWOObjects.Find(bandit, def, "Sink")
    if sink then
        local square = sink:getSquare()
        local asquare = AdjacentFreeTileFinder.Find(square, bandit)
        if asquare then
            local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
            if dist > 0.70 then
                table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                return tasks
            else
                local task = {action="Wash", anim="washFace", x=square:getX(), y=square:getY(), z=square:getZ(), time=400}
                table.insert(tasks, task)
                return tasks
            end
        end
    end

    return tasks
end

BWORoomPrograms.bedroom = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()

    local bed = BWOObjects.Find(bandit, def, "Bed")
    if bed then
        local square = bed:getSquare()
        local asquare = AdjacentFreeTileFinder.Find(square, bandit)
        if asquare then
            local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
            if dist > 2.20 then
                table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                return tasks
            else
                local facing = bed:getSprite():getProperties():Val("Facing")
                local anim = "AwakeBed"
                if hour < 6 or hour > 22 then
                    anim = "SleepBed"
                end
                local task = {action="Sleep", anim=anim, x=bed:getX(), y=bed:getY(), z=bed:getZ(), facing=facing, time=100}
                table.insert(tasks, task)
                return tasks
            end
        end
    end

    return tasks
end

BWORoomPrograms.motelroom = BWORoomPrograms.bedroom
BWORoomPrograms.motelroomoccupied = BWORoomPrograms.motelroom

BWORoomPrograms.kitchen = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local m = (math.abs(id) % 3) * 2
    
    local radio = BWOObjects.Find(bandit, def, "Radio")
    if radio then
        local dd = radio:getDeviceData()
        if not dd:getIsTurnedOn() or dd:getChannel() ~= 98400 then
            local square = radio:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="TelevisionToggle", on=true, channel=98400, volume=0.4, anim="Loot", x=square:getX(), y=square:getY(), z=square:getZ(), time=100}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    end

    if (minute >= m and minute < m+3) or (minute >= m+20 and minute < m+23) or (minute >= m+40 and minute < m+43) then
        local fridge = BWOObjects.Find(bandit, def, "Fridge")
        if fridge then
            local square = fridge:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="FaceLocation", anim="Loot", sound="TIsnd_FoodM", x=square:getX(), y=square:getY(), z=square:getZ(), time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    elseif (minute >= m+3 and minute < m+6) or (minute >= m+23 and minute < m+26) or (minute >= m+43 and minute < m+46) then
        local sink = BWOObjects.Find(bandit, def, "Sink")
        if sink then
            local square = sink:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="FaceLocation", anim="Loot", sound="GetWaterFromTap", x=square:getX(), y=square:getY(), z=square:getZ(), time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    elseif (minute >= m+6 and minute < m+12) or (minute >= m+26 and minute < m+32) or (minute >= m+46 and minute < m+52) then
        local counter = BWOObjects.Find(bandit, def, "Counter")
        if counter then
            local square = counter:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local sound = BanditUtils.Choice({"TIsnd_Cooking", "TIsnd_CookingM"})
                    local task = {action="FaceLocation", anim="Loot", sound=sound, x=square:getX(), y=square:getY(), z=square:getZ(), time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    elseif (minute >= m+12 and minute < m+15) or (minute >= m+32 and minute < m+35) or (minute >= m+52 and minute < m+55) then
        local oven = BWOObjects.Find(bandit, def, "Oven")
        if oven then
            if (minute > 5 and minute < 15 and not oven:Activated()) or (minute > 45 and minute < 55 and oven:Activated()) then
                local square = oven:getSquare()
                local asquare = AdjacentFreeTileFinder.Find(square, bandit)
                if asquare then
                    local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                    if dist > 0.70 then
                        table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                        return tasks
                    else
                        local task = {action="StoveToggle", anim="Loot", x=square:getX(), y=square:getY(), z=square:getZ()}
                        table.insert(tasks, task)
                        return tasks
                    end
                end
            end
        end
    end

    return tasks
end

BWORoomPrograms.restaurantkitchen = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local m = (math.abs(id) % 3) * 2
    
    if (minute >= m and minute < m+3) or (minute >= m+20 and minute < m+23) or (minute >= m+40 and minute < m+43) then
        local fridge = BWOObjects.Find(bandit, def, "Fridge")
        if fridge then
            local square = fridge:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="FaceLocation", anim="Loot", sound="TIsnd_FoodM", x=square:getX(), y=square:getY(), z=square:getZ(), time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    elseif (minute >= m+3 and minute < m+6) or (minute >= m+23 and minute < m+26) or (minute >= m+43 and minute < m+46) then
        local sink = BWOObjects.Find(bandit, def, "Sink")
        if sink then
            local square = sink:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="FaceLocation", anim="Loot", sound="GetWaterFromTap", x=square:getX(), y=square:getY(), z=square:getZ(), time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    elseif (minute >= m+6 and minute < m+12) or (minute >= m+26 and minute < m+32) or (minute >= m+46 and minute < m+52) then
        local counter = BWOObjects.Find(bandit, def, "Counter")
        if counter then
            local square = counter:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local sound = BanditUtils.Choice({"TIsnd_Cooking", "TIsnd_CookingM"})
                    local task = {action="FaceLocation", anim="Loot", sound=sound, x=square:getX(), y=square:getY(), z=square:getZ(), time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    elseif (minute >= m+12 and minute < m+15) or (minute >= m+32 and minute < m+35) or (minute >= m+52 and minute < m+55) then
        local oven = BWOObjects.Find(bandit, def, "Oven")
        if oven then
            local square = oven:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="StoveToggle", anim="Loot", x=square:getX(), y=square:getY(), z=square:getZ()}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    end

    return tasks
end

BWORoomPrograms.spiffoskitchen = BWORoomPrograms.restaurantkitchen
BWORoomPrograms.pizzakitchen = BWORoomPrograms.restaurantkitchen
BWORoomPrograms.jayschicken_kitchen = BWORoomPrograms.restaurantkitchen
BWORoomPrograms.gigamartkitchen = BWORoomPrograms.restaurantkitchen
BWORoomPrograms.cafeteriakitchen = BWORoomPrograms.restaurantkitchen
BWORoomPrograms.dinerkitchen = BWORoomPrograms.restaurantkitchen
BWORoomPrograms.dinercounter = BWORoomPrograms.restaurantkitchen
BWORoomPrograms.kitchen_crepe = BWORoomPrograms.restaurantkitchen
BWORoomPrograms.burgerkitchen = BWORoomPrograms.restaurantkitchen

BWORoomPrograms.barcountertwiggy = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local m = (math.abs(id) % 3) * 2
    
    if (minute >= m and minute < m+3) or (minute >= m+20 and minute < m+23) or (minute >= m+40 and minute < m+43) then
        local bar = BWOObjects.Find(bandit, def, "Bar")
        if bar then
            local square = bar:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="FaceLocation", anim="Loot", sound="TIsnd_FoodM", x=square:getX(), y=square:getY(), z=square:getZ(), time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    elseif (minute >= m+3 and minute < m+6) or (minute >= m+23 and minute < m+26) or (minute >= m+43 and minute < m+46) then
        local sink = BWOObjects.Find(bandit, def, "Sink")
        if sink then
            local square = sink:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="FaceLocation", anim="Loot", sound="GetWaterFromTap", x=square:getX(), y=square:getY(), z=square:getZ(), time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    elseif (minute >= m+6 and minute < m+12) or (minute >= m+26 and minute < m+32) or (minute >= m+46 and minute < m+52) then
        local counter = BWOObjects.Find(bandit, def, "Counter")
        if counter then
            local square = counter:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 0.70 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local found = false
                    local wobs = square:getWorldObjects()
                    for i = 0, wobs:size()-1 do
                        local witem = wobs:get(i)
                        local item = witem:getItem()
                        local itemType = item:getFullType()
                        local category = item:getDisplayCategory()
                        -- print ("ITEM:" .. itemType .. "X: " .. x .. "Y: " .. y)
                        if itemType == "Base.BeerBottle" then 
                            found = true 
                            break
                        end
                    end

                    if not found then
                        -- local sound = BanditUtils.Choice({"TIsnd_Cooking", "TIsnd_CookingM"})
                        -- local task = {action="FaceLocation", anim="Loot", sound=sound, x=square:getX(), y=square:getY(), z=square:getZ(), time=200}
                        local task = {action="PlaceItem", x=square:getX(), fx=0.5, y=square:getY(), fy=0.5, z=square:getZ(), item="Base.BeerBottle", anim="Cashier"}
                        table.insert(tasks, task)

                        

                        return tasks
                    end
                end
            end
        end
    end

    return tasks
end

BWORoomPrograms.church = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local brain = BanditBrain.Get(bandit)

    if brain.cid == Bandit.clanMap.Priest then
        local altar = BWOObjects.Find(bandit, def, "Altar")
        if altar then
            local facing = altar:getSprite():getProperties():Val("Facing")
            local square
            if facing == "S" then square = altar:getSquare():getN() end
            if facing == "N" then square = altar:getSquare():getS() end
            if facing == "E" then square = altar:getSquare():getW() end
            if facing == "W" then square = altar:getSquare():getE() end
            if square then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 0.60 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, square:getX(), square:getY(), square:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="FaceLocation", anim="Yes", x=altar:getX(), y=altar:getY(), z=altar:getZ(), facing=facing, time=100}
                    table.insert(tasks, task)
                    return tasks
                end
            end

        end
    else
        local sittable = BWOObjects.Find(bandit, def, "Pew")
        if not sittable then
            sittable = BWOObjects.Find(bandit, def, "Bench")
        end
        if not sittable then
            sittable = BWOObjects.Find(bandit, def, "Chair")
        end

        if sittable then
            local square = sittable:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 1.20 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local anim
                    local sound
                    local item
                    local time = 200
                    local right = false
                    local left = false
                    local r = ZombRand(2)
                    if r == 0 then
                        anim = "SitInChair1"
                    elseif r == 1 then
                        anim = "SitInChair2"
                    end
    
                    local facing = sittable:getSprite():getProperties():Val("Facing")
    
                    local task = {action="SitInChair", anim=anim, left=left, right=right, sound=sound, x=sittable:getX(), y=sittable:getY(), z=sittable:getZ(), facing=facing, time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    end
    return tasks
end
BWORoomPrograms.meetingroom = BWORoomPrograms.church

BWORoomPrograms.office = function(bandit, def)
    local tasks = {}
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()

    local sittable = BWOObjects.Find(bandit, def, "Chair")
    if not sittable then
        sittable = BWOObjects.Find(bandit, def, "Couch")
    end

    if sittable then
        local square = sittable:getSquare()
        local asquare = AdjacentFreeTileFinder.Find(square, bandit)
        if asquare then
            local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
            if dist > 1.20 then
                table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                return tasks
            else
                local anim
                local sound
                local item
                local smoke = false
                local time = 200
                local right = false
                local left = false
                local r = ZombRand(4)
                if r == 0 then
                    anim = "SitInChair1"
                elseif r == 1 then
                    anim = "SitInChair2"
                elseif r == 2 then
                    anim = "SitInChairTalk"
                elseif r == 3 then
                    anim = "SitInChairRead"
                    sound = "PageFlipBook"
                    item = "Bandits.Book"
                    left = true
                    time = 600
                end

                local facing = sittable:getSprite():getProperties():Val("Facing")

                local task = {action="SitInChair", anim=anim, left=left, right=right, sound=sound, item=item, x=sittable:getX(), y=sittable:getY(), z=sittable:getZ(), facing=facing, time=200}
                table.insert(tasks, task)
                return tasks
            end
        end
    end
    return tasks
end

BWORoomPrograms.meeting = BWORoomPrograms.office
BWORoomPrograms.policeoffice = BWORoomPrograms.office

BWORoomPrograms.bookstore = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local brain = BanditBrain.Get(bandit)    

    if brain.cid == Bandit.clanMap.ShopAssistant then
        local register = BWOObjects.Find(bandit, def, "Register")
        if register then
            local facing = register:getSprite():getProperties():Val("Facing")
            local square
            if facing == "S" then square = register:getSquare():getS() end
            if facing == "N" then square = register:getSquare():getN() end
            if facing == "E" then square = register:getSquare():getE() end
            if facing == "W" then square = register:getSquare():getW() end
            if square then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 0.60 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, square:getX(), square:getY(), square:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="FaceLocation", anim="Yes", x=register:getX(), y=register:getY(), z=register:getZ(), facing=facing, time=100}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    else

        if math.abs(id) % 2 == 0 or (minute > 22 and minute < 36) then
            local shelves = BWOObjects.Find(bandit, def, "Shelves")

            if shelves then
                local square = shelves:getSquare()
                local asquare = AdjacentFreeTileFinder.Find(square, bandit)
                if asquare then
                    local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                    if dist > 0.50 then
                        table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                        return tasks
                    else
                        local anim = BanditUtils.Choice({"LootLow", "Loot", "LootHigh"})
                        local task = {action="FaceLocation", anim=anim, sound="TIsnd_Literature", x=square:getX(), y=square:getY(), z=square:getZ(), time=200}
                        table.insert(tasks, task)
                        return tasks
                    end
                end
            end
        else
            local task = {action="TimeItem", anim="ReadBook", sound="PageFlipBook", item="Bandits.Book", left=true, time=200}
            table.insert(tasks, task)
        end
    end
    return tasks
end

BWORoomPrograms.library = BWORoomPrograms.bookstore

BWORoomPrograms.zippeestore = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local brain = BanditBrain.Get(bandit)    

    if brain.cid == Bandit.clanMap.ShopAssistant or 
       brain.cid == Bandit.clanMap.Fossoil or 
       brain.cid == Bandit.clanMap.Gas2Go then

        local register = BWOObjects.Find(bandit, def, "Register")
        if register then
            local facing = register:getSprite():getProperties():Val("Facing")
            local square
            if facing == "S" then square = register:getSquare():getS() end
            if facing == "N" then square = register:getSquare():getN() end
            if facing == "E" then square = register:getSquare():getE() end
            if facing == "W" then square = register:getSquare():getW() end
            if square then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 0.60 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, square:getX(), square:getY(), square:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="FaceLocation", anim="Yes", x=register:getX(), y=register:getY(), z=register:getZ(), facing=facing, time=100}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    elseif brain.cid == Bandit.clanMap.Security then
        local anim = BanditUtils.Choice({"ShiftWeight", "ChewNails", "PullAtCollar", "WipeBrow", "WipeHead"})
        local task = {action="Time", anim=anim, time=100}
        table.insert(tasks, task)
        return tasks

    else
        local items = ArrayList.new()
        local inventory = bandit:getInventory()
        inventory:getAllEvalRecurse(predicateAll, items)
        local itemCnt = items:size()

        local walkType = "Walk"
        if BWOScheduler.SymptomLevel > 0 then
            walkType = "Run"
        end

        local enough
        if BWOScheduler.SymptomLevel == 0 then
            enough = 2
        elseif BWOScheduler.SymptomLevel == 1 then
            enough = 3
        elseif BWOScheduler.SymptomLevel == 2 then
            enough = 8
        elseif BWOScheduler.SymptomLevel == 3 then
            enough = 12
        else
            enough = 24
        end

        if itemCnt > enough then
            table.insert(tasks, BanditUtils.GetMoveTask(0, bandit:getX() + 8, bandit:getY() + 8, 0, walkType, 11, false))
            return tasks
        end

        -- local rack = BWOObjects.FindFull(bandit, def)
        local rack = BWOObjects.Find(bandit, def, nil, "ContainerFull")
        
        if rack then
            local items = ArrayList.new()
            local container = rack:getContainer()
            container:getAllEvalRecurse(predicateAll, items)
        
            -- analyze container contents
            for i=0, items:size()-1 do
                local item = items:get(i)
            end

            if items:size() > 0 then
                local item = items:get(0)
                local itemType = item:getFullType()
                local square = rack:getSquare()
                local asquare = AdjacentFreeTileFinder.Find(square, bandit)
                if asquare then
                    local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                    if dist > 0.70 then
                        table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), walkType, dist, false))
                        return tasks
                    else
                        local task = {action="TakeFromContainer", anim="Loot", sound="TIsnd_TakingM", itemType=itemType, x=square:getX(), y=square:getY(), z=square:getZ(), time=100}
                        table.insert(tasks, task)
                        return tasks
                    end
                end
            end
        end
    end
    return tasks
end

BWORoomPrograms.clothesstore = BWORoomPrograms.zippeestore
BWORoomPrograms.lingeriestore = BWORoomPrograms.zippeestore
BWORoomPrograms.clothingstore = BWORoomPrograms.zippeestore
BWORoomPrograms.leatherclothesstore = BWORoomPrograms.zippeestore
BWORoomPrograms.grocery = BWORoomPrograms.zippeestore
BWORoomPrograms.pharmacy = BWORoomPrograms.zippeestore
BWORoomPrograms.pharmacystorage = BWORoomPrograms.pharmacy
BWORoomPrograms.gasstore = BWORoomPrograms.zippeestore
BWORoomPrograms.gas2go = BWORoomPrograms.zippeestore
BWORoomPrograms.fossoil = BWORoomPrograms.zippeestore
BWORoomPrograms.movierental = BWORoomPrograms.zippeestore
BWORoomPrograms.gigamart = BWORoomPrograms.zippeestore
BWORoomPrograms.liquorstore = BWORoomPrograms.zippeestore
BWORoomPrograms.generalstore = BWORoomPrograms.zippeestore
BWORoomPrograms.conveniencestore = BWORoomPrograms.zippeestore
BWORoomPrograms.jewelrystore = BWORoomPrograms.zippeestore
BWORoomPrograms.toolstore = BWORoomPrograms.zippeestore
BWORoomPrograms.artstore = BWORoomPrograms.zippeestore
BWORoomPrograms.barbecuestore = BWORoomPrograms.zippeestore
BWORoomPrograms.candystore = BWORoomPrograms.zippeestore
BWORoomPrograms.cornerstore = BWORoomPrograms.zippeestore
BWORoomPrograms.departmentstore = BWORoomPrograms.zippeestore
BWORoomPrograms.electronicsstore = BWORoomPrograms.zippeestore
BWORoomPrograms.furniturestore = BWORoomPrograms.zippeestore
BWORoomPrograms.gardenstore = BWORoomPrograms.zippeestore
BWORoomPrograms.giftstore = BWORoomPrograms.zippeestore
BWORoomPrograms.gunstore = BWORoomPrograms.zippeestore
BWORoomPrograms.musicstore = BWORoomPrograms.zippeestore
BWORoomPrograms.carsupply = BWORoomPrograms.zippeestore


BWORoomPrograms.medical = function(bandit, def)
    local tasks = {}
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local brain = BanditBrain.Get(bandit)    
    
    local sittable
    if brain.cid == Bandit.clanMap.Medic then
        sittable = BWOObjects.Find(bandit, def, "Chair")
        if not sittable then
            sittable = BWOObjects.Find(bandit, def, "Medical Stool")
        end
    else
        sittable = BWOObjects.Find(bandit, def, "Chairs")
    end

    if sittable then
        local square = sittable:getSquare()
        local asquare = AdjacentFreeTileFinder.Find(square, bandit)
        if asquare then
            local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
            if dist > 1.20 then
                table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                return tasks
            else
                local anim
                local sound
                local item
                local smoke = false
                local time = 200
                local right = false
                local left = false
                local r = ZombRand(4)
                if r == 0 then
                    anim = "SitInChair1"
                elseif r == 1 then
                    anim = "SitInChair2"
                elseif r == 2 then
                    anim = "SitInChairTalk"
                elseif r == 3 then
                    anim = "SitInChairRead"
                    sound = "PageFlipBook"
                    item = "Bandits.Book"
                    left = true
                    time = 600
                end

                local facing = sittable:getSprite():getProperties():Val("Facing")

                local task = {action="SitInChair", anim=anim, left=left, right=right, sound=sound, item=item, x=sittable:getX(), y=sittable:getY(), z=sittable:getZ(), facing=facing, time=200}
                table.insert(tasks, task)
                return tasks
            end
        end
    end
    return tasks
end

BWORoomPrograms.medclinic = BWORoomPrograms.medical

BWORoomPrograms.restaurant = function(bandit, def)
    local tasks = {}
    local cell = getCell()
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local brain = BanditBrain.Get(bandit)  

    if brain.cid == Bandit.clanMap.Waiter then

        local register = BWOObjects.Find(bandit, def, "Register")
        if register and math.abs(id) % 2 == 0 then
            local facing = register:getSprite():getProperties():Val("Facing")
            local square
            if facing == "S" then square = register:getSquare():getS() end
            if facing == "N" then square = register:getSquare():getN() end
            if facing == "E" then square = register:getSquare():getE() end
            if facing == "W" then square = register:getSquare():getW() end
            if square then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 0.60 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, square:getX(), square:getY(), square:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="FaceLocation", anim="Yes", x=register:getX(), y=register:getY(), z=register:getZ(), facing=facing, time=100}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end

        -- find table to serve
        local serve = {}
        serve.dist = math.huge
        for x=def:getX(), def:getX2() do
            for y=def:getY(), def:getY2() do
                local square = cell:getGridSquare(x, y, def:getZ())
                if square then
                    local objects = square:getObjects()
                    for i=0, objects:size()-1 do
                        local object = objects:get(i)
                        local sprite = object:getSprite()
                        if sprite then
                            local props = sprite:getProperties()
                            if props:Is("CustomName") then
                                local name = props:Val("CustomName")
                                if name == "Table" or name == "Light Round Table" or name == "Oak Round Table" then
                                    -- who is seated at the table

                                    local nes = {}
                                    -- bits: o: occupied, p: plate, f: food item
                                    nes.N = {x=0, y=-1, o=false, p=false, f=false}
                                    nes.E = {x=1, y=0, o=false, p=false, f=false}
                                    nes.S = {x=0, y=1, o=false, p=false, f=false}
                                    nes.W = {x=-1, y=0, o=false, p=false, f=false}

                                    -- check who's seated
                                    for d, n in pairs(nes) do
                                        local test1 = square:getX() + n.x
                                        local test2 = square:getY() + n.y
                                        local nsquare = cell:getGridSquare(square:getX() + n.x, square:getY() + n.y, square:getZ())
                                        if nsquare and nsquare:getZombie() and BanditUtils.GetCharacterID(square:getZombie()) ~= id then
                                            nes[d].o = true
                                        end
                                    end

                                    -- find if the table has necessary utensils and food
                                    local wobs = square:getWorldObjects()
                                    for i = 0, wobs:size()-1 do
                                        local witem = wobs:get(i)
                                        local x = witem:getWorldPosX() - witem:getX()
                                        local y = witem:getWorldPosY() - witem:getY()
                                        local z = witem:getWorldPosZ() - witem:getZ()

                                        local d
                                        if x >= 0.70 then 
                                            d = "E"
                                        elseif x <= 0.30 then 
                                            d = "W"
                                        elseif y >= 0.70 then
                                            d = "S"
                                        elseif y <= 0.30 then 
                                            d = "N" 
                                        end

                                        if d then
                                            local item = witem:getItem()
                                            local itemType = item:getFullType()
                                            local category = item:getDisplayCategory()
                                            -- print ("ITEM:" .. itemType .. "X: " .. x .. "Y: " .. y)
                                            if itemType == "Base.Plate" then nes[d].p = true end
                                            if category == "Food" then nes[d].f = true end
                                        end
                                    end

                                    -- determine what needs to be served and exact locations
                                    local item
                                    local fx
                                    local fy
                                    for d, n in pairs(nes) do
                                        if n.o then
                                            fx = 0.5
                                            fy = 0.5
                                            
                                            if d == "E" then 
                                                fx = 0.80
                                            elseif d == "W" then 
                                                fx = 0.20
                                            elseif d == "N" then 
                                                fy = 0.20
                                            elseif d == "S" then 
                                                fy = 0.80
                                            end

                                            if not n.p then 
                                                item = "Base.Plate" 
                                                break
                                            end

                                            if not n.f then
                                                local room = square:getRoom()
                                                local roomName = room:getName()
                                                if roomName == "cafe" then
                                                    item = BanditUtils.Choice({"Base.PieApple", "Base.PiePumpkin", "Base.CakeChocolate", "Base.CakeCarrot", "Base.CakeCheeseCake"})
                                                elseif roomName == "donut_dining" then
                                                    item = BanditUtils.Choice({"Base.DoughnutJelly", "Base.DoughnutPlain", "Base.DoughnutFrosted"})
                                                elseif roomName == "donut_dining" then
                                                    item = BanditUtils.Choice({"Base.DoughnutJelly", "Base.DoughnutPlain", "Base.DoughnutFrosted"})
                                                elseif roomName == "icecream" then
                                                    item = BanditUtils.Choice({"Base.ConeIcecream"})
                                                elseif roomName == "jayschicken_dining" then
                                                    item = BanditUtils.Choice({"Base.ChickenFried", "Base.Fries", "farming.Salad"})
                                                elseif roomName == "pileocrepe" then
                                                    item = BanditUtils.Choice({"Base.Pancakes"})
                                                elseif roomName == "pizzawhirled" then
                                                    item = BanditUtils.Choice({"Base.Pizza"})
                                                elseif roomName == "pizzawhirled" then
                                                    item = BanditUtils.Choice({"Base.Pizza"})
                                                else
                                                    item = BanditUtils.Choice({"Base.Perogies", "Base.PotatoPancakes", "Base.EggOmlette", "Base.MeatDumpling", "Base.TofuFried", "Base.ShrimpFriedCraft", "Base.FriedOnionRings", "Base.FishFried", "Base.ChickenFried", "Base.Burrito", "Base.Burger", "Base.Fries", "farming.Salad", "Base.CakeChocolate", "Base.CakeCarrot", "Base.CakeCheeseCake"}) 
                                                end
                                                break
                                            end
                                        end
                                    end

                                    if item then
                                        local dist = math.sqrt(math.pow(x - bandit:getX(), 2) + math.pow(y - bandit:getY(), 2))
                                        if dist < serve.dist then
                                            serve.square = square
                                            serve.dist = dist
                                            serve.item = item
                                            serve.fx = fx
                                            serve.fy = fy
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if serve.square and serve.item then
            local asquare = AdjacentFreeTileFinder.Find(serve.square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
                if dist > 1 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX() + 0.5, asquare:getY() + 0.5, asquare:getZ(), "Walk", serve.dist, false))
                    return tasks
                else
                    local task = {action="PlaceItem", x=serve.square:getX(), fx=serve.fx, y=serve.square:getY(), fy=serve.fy, z=serve.square:getZ(), item=serve.item, anim="Cashier"}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end

        local task = {action="Time", anim="Yes", time=100}
        table.insert(tasks, task)
        return tasks

    elseif brain.cid == Bandit.clanMap.Spiffo then
        local anim = BanditUtils.Choice({"DanceHipHop3", "DanceRaiseTheRoof"})
        local task = {action="Time", anim=anim, time=500}
        table.insert(tasks, task)
        return tasks
    else
        local sittable
        sittable = BWOObjects.Find(bandit, def, "Seat")

        if not sittable then
            sittable = BWOObjects.Find(bandit, def, "Seating")
        end

        if not sittable then
            sittable = BWOObjects.Find(bandit, def, "Chair")
        end

        if not sittable then
            sittable = BWOObjects.Find(bandit, def, "Picknic Table")
        end
    
        if sittable then
            local square = sittable:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 1.50 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local anim
                    local sound
                    local item
                    local smoke = false
                    local time = 200
                    local right = false
                    local left = false
                    local r = ZombRand(6)
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
                        item = "Base.Fork"
                        right = true
                    elseif r == 5 then
                        anim = "SitInChairSmoke"
                        sound = "Smoke"
                        smoke = true
                        time = 400
                    end
    
                    local facing = sittable:getSprite():getProperties():Val("Facing")
    
                    local task = {action="SitInChair", anim=anim, left=left, right=right, sound=sound, item=item, x=sittable:getX(), y=sittable:getY(), z=sittable:getZ(), facing=facing, time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    end
    return tasks
end

BWORoomPrograms.dining = BWORoomPrograms.restaurant
BWORoomPrograms.dining_crepe = BWORoomPrograms.restaurant
BWORoomPrograms.spiffo_dining = BWORoomPrograms.restaurant
BWORoomPrograms.spifforestaurant = BWORoomPrograms.restaurant
BWORoomPrograms.pizzawhirled = BWORoomPrograms.restaurant
BWORoomPrograms.jayschicken_dining = BWORoomPrograms.restaurant
BWORoomPrograms.diningroom = BWORoomPrograms.restaurant
BWORoomPrograms.bakery = BWORoomPrograms.restaurant
BWORoomPrograms.cafe = BWORoomPrograms.restaurant
BWORoomPrograms.cafeteria = BWORoomPrograms.restaurant
BWORoomPrograms.icecream = BWORoomPrograms.restaurant
BWORoomPrograms.pileocrepe = BWORoomPrograms.restaurant
BWORoomPrograms.restaurant_dining = BWORoomPrograms.restaurant
BWORoomPrograms.restaurantdining = BWORoomPrograms.restaurant
BWORoomPrograms.diner = BWORoomPrograms.restaurant

BWORoomPrograms.classroom = function(bandit, def)
    local tasks = {}
    local cell = getCell()
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local brain = BanditBrain.Get(bandit)

    if brain.cid == Bandit.clanMap.Teacher then

        local task = {action="Time", anim="Yes", time=100}
        table.insert(tasks, task)
        return tasks

    else
        local sittable
        sittable = BWOObjects.Find(bandit, def, "Seat")

        if not sittable then
            sittable = BWOObjects.Find(bandit, def, "Chair")
        end

        if sittable then
            local square = sittable:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 1.20 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local anim
                    local sound
                    local item
                    local smoke = false
                    local time = 200
                    local right = false
                    local left = false
                    local r = ZombRand(4)
                    if r == 0 then
                        anim = "SitInChair1"
                    elseif r == 1 then
                        anim = "SitInChair2"
                    elseif r == 2 then
                        anim = "SitInChairTalk"
                    elseif r == 3 then
                        anim = "SitInChairRead"
                        sound = "PageFlipBook"
                        item = "Bandits.Book"
                        left = true
                        time = 600
                    end
    
                    local facing = sittable:getSprite():getProperties():Val("Facing")
    
                    local task = {action="SitInChair", anim=anim, left=left, right=right, sound=sound, item=item, x=sittable:getX(), y=sittable:getY(), z=sittable:getZ(), facing=facing, time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    end
    return tasks
end
BWORoomPrograms.daycare = BWORoomPrograms.classroom
BWORoomPrograms.secondaryclassroom = BWORoomPrograms.classroom
BWORoomPrograms.elementaryclassroom = BWORoomPrograms.classroom

BWORoomPrograms.bar = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local brain = BanditBrain.Get(bandit)

    if brain.cid == Bandit.clanMap.Waiter then
        local register = BWOObjects.Find(bandit, def, "Register")
        if register and math.abs(id) % 2 == 0 then
            local facing = register:getSprite():getProperties():Val("Facing")
            local square
            if facing == "S" then square = register:getSquare():getS() end
            if facing == "N" then square = register:getSquare():getN() end
            if facing == "E" then square = register:getSquare():getE() end
            if facing == "W" then square = register:getSquare():getW() end
            if square then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 0.60 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, square:getX(), square:getY(), square:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local task = {action="FaceLocation", anim="Yes", x=register:getX(), y=register:getY(), z=register:getZ(), facing=facing, time=100}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end


        local task = {action="Time", anim="Yes", time=100}
        table.insert(tasks, task)
        return tasks

    elseif brain.cid == Bandit.clanMap.Biker then
        local rnd = ZombRand(2)
        if rnd == 0 then
            local task = {action="Smoke", anim="Smoke", item="Bandits.Cigarette", left=true, time=100}
            table.insert(tasks, task)
        else
            local task = {action="TimeItem", anim="Drink", sound="DrinkingFromBottle", item="Bandits.BeerBottle", left=true, time=100}
            table.insert(tasks, task)
        end

        return tasks
    else
        local sittable
        sittable = BWOObjects.Find(bandit, def, "Seat")

        if not sittable then
            sittable = BWOObjects.Find(bandit, def, "Chair")
        end

        if not sittable then
            sittable = BWOObjects.Find(bandit, def, "Picknic Table")
        end
    
        if sittable then
            local square = sittable:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 1.20 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local anim
                    local sound
                    local item
                    local smoke = false
                    local time = 200
                    local right = false
                    local left = false
                    local r = ZombRand(6)
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
                    end
    
                    local facing = sittable:getSprite():getProperties():Val("Facing")
    
                    local task = {action="SitInChair", anim=anim, left=left, right=right, sound=sound, item=item, x=sittable:getX(), y=sittable:getY(), z=sittable:getZ(), facing=facing, time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    end
    return tasks
end

BWORoomPrograms.mechanic = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local shelves = BWOObjects.Find(bandit, def, "Shelves")

    if shelves then
        local square = shelves:getSquare()
        local asquare = AdjacentFreeTileFinder.Find(square, bandit)
        if asquare then
            local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
            if dist > 0.50 then
                table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                return tasks
            else
                local anim = BanditUtils.Choice({"LootLow", "Loot", "LootHigh"})
                local task = {action="FaceLocation", anim=anim, sound="TIsnd_Tool", x=square:getX(), y=square:getY(), z=square:getZ(), time=200}
                table.insert(tasks, task)
                return tasks
            end
        end
    end

    return tasks
end

BWORoomPrograms.gym = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()

    local task1 = {action="PushUp", time=2000}
    table.insert(tasks, task1)
    
    local anim2 = BanditUtils.Choice({"WipeBrow", "WipeHead"})
    local task2 = {action="Time", anim=anim, time=100}
    table.insert(tasks, task2)

    local anim3 = BanditUtils.Choice({"WipeBrow", "WipeHead"})
    local task3 = {action="Time", anim=anim, time=100}
    table.insert(tasks, task3)

    return tasks
end

BWORoomPrograms.aesthetic = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local brain = BanditBrain.Get(bandit)

    if brain.cid == Bandit.clanMap.ShopAssistant then

        local task = {action="Time", anim="Yes", time=100}
        table.insert(tasks, task)
        return tasks

    else
        local sittable
        sittable = BWOObjects.Find(bandit, def, "Seat")

        if not sittable then
            sittable = BWOObjects.Find(bandit, def, "Chair")
        end
    
        if sittable then
            local square = sittable:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 1.20 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local anim
                    local sound
                    local item
                    local smoke = false
                    local time = 200
                    local right = false
                    local left = false
                    local r = ZombRand(3)
                    if r == 0 then
                        anim = "SitInChair1"
                    elseif r == 1 then
                        anim = "SitInChair2"
                    elseif r == 2 then
                        anim = "SitInChairTalk"
                    end
    
                    local facing = sittable:getSprite():getProperties():Val("Facing")
    
                    local task = {action="SitInChair", anim=anim, left=left, right=right, sound=sound, item=item, x=sittable:getX(), y=sittable:getY(), z=sittable:getZ(), facing=facing, time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    end
    return tasks
end

BWORoomPrograms.breakroom = BWORoomPrograms.livingroom

BWORoomPrograms.stripclub = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local brain = BanditBrain.Get(bandit)
    local isDance = false
    
    if brain.cid == Bandit.clanMap.Party then
        isDance = true
    end

    if isDance then
        local anim = BanditUtils.Choice({"DanceHipHop3", "DanceRaiseTheRoof", "Dance1", "Dance2", "Dance3", "Dance4"})
        local task = {action="Time", anim=anim, time=500}
        table.insert(tasks, task)
    else

        local sittable = BWOObjects.Find(bandit, def, "Couch")

        if sittable then
            local square = sittable:getSquare()
            local asquare = AdjacentFreeTileFinder.Find(square, bandit)
            if asquare then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 1.20 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                    return tasks
                else
                    local anim
                    local sound
                    local item
                    local smoke = false
                    local time = 200
                    local right = false
                    local left = false
                    local r = ZombRand(3)
                    if r == 0 then
                        anim = "SitInChair1"
                    elseif r == 1 then
                        anim = "SitInChair2"
                    elseif r == 2 then
                        anim = "SitInChairTalk"
                    end

                    local facing = sittable:getSprite():getProperties():Val("Facing")

                    local task = {action="SitInChair", anim=anim, left=left, right=right, sound=sound, item=item, x=sittable:getX(), y=sittable:getY(), z=sittable:getZ(), facing=facing, time=200}
                    table.insert(tasks, task)
                    return tasks
                end
            end
        end
    end
    return tasks
end

BWORoomPrograms.stripclubvip = BWORoomPrograms.stripclub

--[[
BWORoomPrograms.breakroom = function(bandit, def)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    
    local outfit = bandit:getOutfitName()

    local task1 = {action="TimeItem", anim="Smoke", item="Bandits.Cigarette", left=true, time=500}
    table.insert(tasks, task1)
    
    local anim2 = BanditUtils.Choice({"WipeBrow", "WipeHead"})
    local task2 = {action="Time", anim=anim, time=100}
    table.insert(tasks, task2)

    local anim3 = BanditUtils.Choice({"WipeBrow", "WipeHead"})
    local task3 = {action="Time", anim=anim, time=100}
    table.insert(tasks, task3)

    return tasks
end
]]