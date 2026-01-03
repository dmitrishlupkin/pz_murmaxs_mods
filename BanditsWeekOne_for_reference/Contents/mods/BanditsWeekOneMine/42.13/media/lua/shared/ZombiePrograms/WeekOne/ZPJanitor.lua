ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Janitor = {}

ZombiePrograms.Janitor.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)
  
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Janitor.Main = function(bandit)
    local tasks = {}
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
    if BWOScheduler.NPC.Run then 
        walkType = "Run"
        endurance = -0.06
    end
    
    local health = bandit:getHealth()
    if health < 0.8 then
        walkType = "Limp"
        endurance = 0
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

    -- pickup trash
    if BWOScheduler.SymptomLevel < 3 then
        local target = BWOObjects.FindGMD(bandit, "trash")      
        if target.x and target.y and target.z and target.dist < 60 then
            local square = cell:getGridSquare(target.x, target.y, target.z)
            if square then
                local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), target.x + 0.5, target.y + 0.5)
                if dist > 0.4 then
                    table.insert(tasks, BanditUtils.GetMoveTask(0, target.x, target.y, square:getZ(), "Walk", dist, false))
                    return {status=true, next="Main", tasks=tasks}
                else
                    local task1 = {action="Equip", itemPrimary="Base.Broom"}
                    table.insert(tasks, task1)
        
                    local task2 = {action="RemoveObject", customName="Trash", otype="trash", anim="Rake", itemType=itemMopType, x=target.x, y=target.y, z=target.z, time=300}
                    table.insert(tasks, task2)

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
