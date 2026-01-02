ZombiePrograms = ZombiePrograms or {}

local function predicateAll(item)
    return true
end

ZombiePrograms.BanditSimple = {}
ZombiePrograms.BanditSimple.Stages = {}

ZombiePrograms.BanditSimple.Init = function(bandit)
end

ZombiePrograms.BanditSimple.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)
  
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.BanditSimple.Main = function(bandit)
    local tasks = {}
    local cell = getCell()
    local endurance = 0.00
    local walkType = "Run"

    local config = {}
    config.mustSee = false
    config.hearDist = 25

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

        table.insert(tasks, BanditUtils.GetMoveTaskTarget(endurance, tx, ty, tz, target.id, target.player, walkType, target.dist))
        return {status=true, next="Main", tasks=tasks}
    end

    local task = {action="Time", anim="Shrug", time=200}
    table.insert(tasks, task)

    return {status=true, next="Main", tasks=tasks}
end
