ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Active = {}

ZombiePrograms.Active.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)
  
    local player = getSpecificPlayer(0)
    local px, py = player:getX(), player:getY()
    local anim = BanditUtils.Choice({"Spooked1", "Spooked2"})
    local task2 = {action="TimeFace", anim=anim, x=px, y=py, time=100}
    table.insert(tasks, task2)
    
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Active.Main = function(bandit)
    local tasks = {}
    local brain = BanditBrain.Get(bandit)
    local id = brain.id
    local walkType = "Run"
    local endurance = 0

    local coward = math.abs(id) % 2 == 0
    if SandboxVars.Bandits.General_RunAway and coward then
        return {status=true, next="Escape", tasks=tasks}
    end

    local config = {}
    config.mustSee = false
    config.hearDist = 20

    local target, enemy = BanditUtils.GetTarget(bandit, config)

    -- relax and return to original program
    if target.dist > 30 then
        Bandit.SetProgram(bandit, brain.programFallback)
        return {status=true, next="Main", tasks=tasks}
    end

    local walkType = Bandit.GetCombatWalktype(bandit, enemy, target.dist)

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

    -- engage with target
    if target.x and target.y and target.z then
        local tx, ty, tz = target.x, target.y, target.z
    
        if enemy then
            if target.fx and target.fy and (enemy:isRunning()  or enemy:isSprinting()) then
                tx, ty = target.fx, target.fy
            end
        end

        local walkType = Bandit.GetCombatWalktype(bandit, enemy, target.dist)

        table.insert(tasks, BanditUtils.GetMoveTaskTarget(endurance, tx, ty, tz, target.id, target.player, walkType, target.dist))
        return {status=true, next="Main", tasks=tasks}
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

ZombiePrograms.Active.Escape = function(bandit)
    local tasks = {}
    local id = BanditUtils.GetCharacterID(bandit)
    local endurance = 0
    local walkType = "Run"

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
    end

    local config = {}
    config.mustSee = false
    config.hearDist = 40

    local closestPlayer = BanditUtils.GetClosestPlayerLocation(bandit, config)

    if closestPlayer.x and closestPlayer.y and closestPlayer.z then

        -- calculate random escape direction
        local deltaX = 100 + ZombRand(100)
        local deltaY = 100 + ZombRand(100)

        local rx = ZombRand(2)
        local ry = ZombRand(2)
        if rx == 1 then deltaX = -deltaX end
        if ry == 1 then deltaY = -deltaY end

        table.insert(tasks, BanditUtils.GetMoveTask(endurance, closestPlayer.x+deltaX, closestPlayer.y+deltaY, 0, walkType, 12, false))
    end
    return {status=true, next="Escape", tasks=tasks}
end

ZombiePrograms.Active.Wait = function(bandit)
    return {status=true, next="Main", tasks={}}
end

