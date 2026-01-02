ZombieActions = ZombieActions or {}

ZombieActions.TimeFace = {}
ZombieActions.TimeFace.onStart = function(zombie, task)
    return true
end

ZombieActions.TimeFace.onWorking = function(zombie, task)
    zombie:faceLocationF(task.x, task.y)
    if zombie:getBumpType() ~= task.anim then return true end
    return false
end

ZombieActions.TimeFace.onComplete = function(zombie, task)
    return true
end