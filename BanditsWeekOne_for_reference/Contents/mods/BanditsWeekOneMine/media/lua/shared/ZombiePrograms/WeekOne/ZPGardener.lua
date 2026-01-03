ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Gardener = {}

ZombiePrograms.Gardener.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)
  
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Gardener.Main = function(bandit)

    local function predicateWateringCan(item)
        return item:getType() == "WateringCan"
    end

    local tasks = {}
    -- if true then return {status=true, next="Main", tasks=tasks} end
    local cell = bandit:getCell()
    local brain = BanditBrain.Get(bandit)
    local id = brain.id
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()

    local walkType = "Walk"
    local endurance = 0
    if   BWOScheduler.NPC.Run then 
        walkType = "Run"
        endurance = -0.06
    end
    
    local health = bandit:getHealth()
    if health < 0.8 then
        walkType = "Limp"
        endurance = 0
    end 

    -- if inside building change program
    if not bandit:isOutside() then
        Bandit.ClearTasks(bandit)
        Bandit.SetProgram(bandit, "Inhabitant", {})

        local brain = BanditBrain.Get(bandit)
        local syncData = {}
        syncData.id = brain.id
        syncData.program = brain.program
        Bandit.ForceSyncPart(bandit, syncData)
        return {status=true, next="Main", tasks=tasks}
    end

    -- ensure has watering can
    local npiList = ArrayList.new()
    local inventory = bandit:getInventory()
    inventory:getAllEvalRecurse(predicateWateringCan, npiList)
    local npiCnt = npiList:size()
    if npiCnt == 0 then
        local item = BanditCompatibility.InstanceItem("Bandits.WateringCan")
        inventory:AddItem(item)
        Bandit.UpdateItemsToSpawnAtDeath(bandit)
    end
    
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
    else
        if BWOScheduler.SymptomLevel >= 4 then walkType = "Run" end
    end
    
    -- react to events
    local subTasks = BanditPrograms.Events(bandit)
    if #subTasks > 0 then
        for _, subTask in pairs(subTasks) do
            table.insert(tasks, subTask)
        end
        return {status=true, next="Main", tasks=tasks}
    end

    -- interact with players and other npcs
    local subTasks = BanditPrograms.Talk(bandit)
    if #subTasks > 0 then
        for _, subTask in pairs(subTasks) do
            table.insert(tasks, subTask)
        end
        return {status=true, next="Main", tasks=tasks}
    end

    -- water the flowers
    if BWOScheduler.SymptomLevel < 3 and minute % 5 < 2 then
        local target = BWOObjects.FindGMD(bandit, "flowerbed")      
        if target.x and target.y and target.z and target.dist < 50 then
            local square = cell:getGridSquare(target.x, target.y, target.z)
            if square then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), square:getX() + 0.5, square:getY() + 0.5)
                if dist > 0.4 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, square:getX(), square:getY(), square:getZ(), "Walk", dist, false))
                    return {status=true, next="Main", tasks=tasks}
                else
                    local task = {action="TimeItem", item="Bandits.WateringCan", left=true, anim="PourWateringCan", sound="WaterCrops", x=target.x, y=target.y, z=target.z, time=200}
                    table.insert(tasks, task)
                    return {status=true, next="Main", tasks=tasks}
                end
            end
        end
    end

    -- fallback
    local rnd = math.abs(id) % 4

    local dx = 0
    local dy = 0
    if rnd == 0 then
        dx = 5
    elseif rnd == 1 then
        dy = 5
    elseif rnd == 2 then
        dx = -5
    elseif rnd == 3 then
        dy = -5
    end

    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    if hour % 2 == 0 then
        dx = -dx
        dy = -dy
    end

    local target = {}
    target.x = bx + dx
    target.y = by + dy
    target.z = 0
    
    table.insert(tasks, BanditUtils.GetMoveTask(endurance, target.x, target.y, target.z, walkType, 10, false))
    
    return {status=true, next="Main", tasks=tasks}
end
