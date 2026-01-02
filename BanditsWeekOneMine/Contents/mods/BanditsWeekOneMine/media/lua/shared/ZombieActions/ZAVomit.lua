ZombieActions = ZombieActions or {}

ZombieActions.Vomit = {}
ZombieActions.Vomit.onStart = function(zombie, task)
    return true
end

ZombieActions.Vomit.onWorking = function(zombie, task)
    if ZombRand(7) == 0 then
        local bx = zombie:getX() - 0.5 + ZombRandFloat(0.1, 0.9)
        local by = zombie:getY() - 0.5 + ZombRandFloat(0.1, 0.9)
        zombie:getChunk():addBloodSplat(bx, by, 0, ZombRand(20))
    end

    if zombie:getBumpType() ~= task.anim then return true end
    return false
end

ZombieActions.Vomit.onComplete = function(zombie, task)
    return true
end