ZombieActions = ZombieActions or {}

ZombieActions.PushUp = {}
ZombieActions.PushUp.onStart = function(zombie, task)
    return true
end

ZombieActions.PushUp.onWorking = function(zombie, task)
    
    if not task.stage then task.stage = 1 end
    
    if not zombie:isBumped() then
        if task.stage == 1 then
            zombie:setBumpType("PushUpIn")
        elseif task.stage < 17 then
            zombie:setBumpType("PushUpLoop1")
        elseif task.stage < 19 then
            zombie:setBumpType("PushUpLoop2")
        else
            zombie:setBumpType("PushUpOut")
        end

        task.stage = task.stage + 1
        Bandit.UpdateTask(zombie, task)
    end

    if task.stage == 20 then
        return true
    end

    return false
end

ZombieActions.PushUp.onComplete = function(zombie, task)
    return true
end
