ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.ArmyGuard = {}

ZombiePrograms.ArmyGuard.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)
  
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.ArmyGuard.Main = function(bandit)
    local tasks = {}

    -- activated
    local closestZombie = BanditUtils.GetClosestZombieLocation(bandit)
    if closestZombie.dist < 15 then
        Bandit.Say(bandit, "SPOTTED")
        Bandit.ClearTasks(bandit)
        Bandit.SetProgram(bandit, "Bandit", {})
        Bandit.ForceStationary(bandit, false)
        return {status=true, next="Prepare", tasks=tasks}
    end

    local mindist = 1.9
    if Bandit.IsHostile(bandit) then
        mindist = 50
    end

    local config = {}
    config.mustSee = false
    config.hearDist = 20

    local closestPlayer = BanditUtils.GetClosestPlayerLocation(bandit, config)
    if closestPlayer.dist < mindist then
        Bandit.Say(bandit, "SPOTTED")
        Bandit.ClearTasks(bandit)
        Bandit.SetProgram(bandit, "Bandit", {})
        Bandit.SetHostileP(bandit, true)
        Bandit.ForceStationary(bandit, false)
        return {status=true, next="Prepare", tasks=tasks}
    end


    local subTasks = BanditPrograms.Idle(bandit)
    if #subTasks > 0 then
        for _, subTask in pairs(subTasks) do
            table.insert(tasks, subTask)
        end
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

