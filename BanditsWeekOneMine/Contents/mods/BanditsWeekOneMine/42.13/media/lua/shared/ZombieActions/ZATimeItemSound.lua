ZombieActions = ZombieActions or {}

ZombieActions.TimeItemSound = {}
ZombieActions.TimeItemSound.onStart = function(zombie, task)
    if task.item then
        local fakeItem = BanditCompatibility.InstanceItem(task.item)
        if not task.left then
            zombie:setPrimaryHandItem(fakeItem)
        end
        if not task.right then
            zombie:setSecondaryHandItem(fakeItem)
        end
        -- zombie:playSound(task.sound)
    end
    return true
end

ZombieActions.TimeItemSound.onWorking = function(zombie, task)
    local bumpType = zombie:getBumpType()
    if bumpType ~= task.anim then 
        zombie:setBumpType(task.anim)
    end

    local emitter = zombie:getEmitter()
    if not emitter:isPlaying(task.sound) then
        return true
    end

    return false
end

ZombieActions.TimeItemSound.onComplete = function(zombie, task)
    if task.item then
        if task.left then
            zombie:setSecondaryHandItem(nil)
        else
            zombie:setPrimaryHandItem(nil)
        end
    end
    return true
end