ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Fireman = {}

ZombiePrograms.Fireman.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)
  
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Fireman.Main = function(bandit)
    local tasks = {}
    local cell = bandit:getCell()
    local brain = BanditBrain.Get(bandit)
    local id = brain.id
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()
    local walkType = "Run"
    local endurance = 0

    -- symptoms
    if math.abs(id) % 2 > 0 then
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
    
    -- extinguish
    local fireSquare = BWOObjects.FindFire(bandit, 30)
    if not firesquare then
        local target = BWOObjects.FindGMD(bandit, "fire")
        if target.x and target.y and target.z then
            local square = cell:getGridSquare(target.x, target.y, target.z)
            if square then
                fireSquare = square
            end
        end
    end

    if fireSquare then
        local asquare = AdjacentFreeTileFinder.Find(fireSquare, bandit)
        if asquare then
            local dist = BanditUtils.DistTo(bandit:getX(), bandit:getY(), asquare:getX() + 0.5, asquare:getY() + 0.5)
            if dist > 3 then
                table.insert(tasks, BanditUtils.GetMoveTask(endurance, asquare:getX(), asquare:getY(), asquare:getZ(), "Run", dist, false))
                return {status=true, next="Main", tasks=tasks}
            else
                local task = {action="Extinguish", anim="Extinguish", sound="BWOExtinguish", soundDistMax=6, time=120, item="Bandits.Extinguisher", right=true, x=fireSquare:getX(), y=fireSquare:getY(), z=fireSquare:getZ()}
                table.insert(tasks, task)
                return {status=true, next="Main", tasks=tasks}
            end
        end
    end
    
    -- fallback
    local subTasks = BanditPrograms.FallbackAction(bandit)
    if #subTasks > 0 then
        for _, subTask in pairs(subTasks) do
            table.insert(tasks, subTask)
        end
    end

    return {status=true, next="Main", tasks=tasks}
end
