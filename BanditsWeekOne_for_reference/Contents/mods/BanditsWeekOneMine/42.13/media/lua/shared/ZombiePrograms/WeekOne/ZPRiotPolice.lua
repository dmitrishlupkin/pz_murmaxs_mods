ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.RiotPolice = {}

ZombiePrograms.RiotPolice.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)
  
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.RiotPolice.Main = function(bandit)
    local tasks = {}

    local brain = BanditBrain.Get(bandit)
    local id = brain.id
    local world = getWorld()
    local cell = getCell()
     local walkType = "WalkAim"
    local closeSlow = false
    local endurance = 0

    local health = bandit:getHealth()
    if health < 0.8 then
        walkType = "Limp"
        endurance = 0
    end 

    local minDist = 2
    local target = BanditUtils.GetClosestBanditLocationProgram(bandit, {"Walker", "Runner", "Active"})
    if target.x and target.y and target.z and target.dist < 20 then
        if target.dist > minDist then

            local id = BanditUtils.GetCharacterID(bandit)

            local dx = 0
            local dy = 0
            local dxf = ((math.abs(id) % 10) - 5) / 10
            local dyf = ((math.abs(id) % 11) - 5) / 10

            table.insert(tasks, BanditUtils.GetMoveTask(endurance, target.x+dx+dxf, target.y+dy+dyf, target.z, walkType, target.dist, closeSlow))
            return {status=true, next="Main", tasks=tasks}
        end
    end

    local target = BWOObjects.FindGMD(bandit, "protest")
    if target.x and target.y and target.z then
        table.insert(tasks, BanditUtils.GetMoveTask(endurance, target.x, target.y, target.z, walkType, target.dist, closeSlow))
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
