ZombieActions = ZombieActions or {}

ZombieActions.TimeEvent = {}
ZombieActions.TimeEvent.onStart = function(zombie, task)
    local gmd = GetBWOModData()
    if task.event then
        local args = {x=math.floor(task.x), y=math.floor(task.y), z=task.z, otype=task.event, ttl=BanditUtils.GetTime()+100000}
        BWOServer.Commands.ObjectAdd(getSpecificPlayer(0), args)
    end

    if task.item then
        local fakeItem = BanditCompatibility.InstanceItem(task.item)
        if not task.left then
            zombie:setPrimaryHandItem(fakeItem)
        end
        if not task.right then
            zombie:setSecondaryHandItem(fakeItem)
        end
        
    end

    if task.sound then
        -- zombie:playSound(task.sound)
    end

    return true
end

ZombieActions.TimeEvent.onWorking = function(zombie, task)

    if task.x and task.y then
        zombie:faceLocation(task.x, task.y)
    end

    if task.lx and task.ly then
        zombie:setX(task.lx)
        zombie:setY(task.ly)
    end

    local bumpType = zombie:getBumpType()
    if bumpType ~= task.anim then 
        zombie:setBumpType(task.anim)
    end

    if task.sound then
        local emitter = zombie:getEmitter()
        if not emitter:isPlaying(task.sound) then
            return true
        end
    end

    return false
end

ZombieActions.TimeEvent.onComplete = function(zombie, task)
    if task.event then
        local args = {x=math.floor(task.x + 0.5), y=math.floor(task.y + 0.5), z=task.z, otype=task.event}
        BWOServer.Commands.ObjectRemove(getSpecificPlayer(0), args)
    end

    if task.item then
        if task.left then
            zombie:setSecondaryHandItem(nil)
        else
            zombie:setPrimaryHandItem(nil)
        end
    end

    if task.sound then
        local emitter = zombie:getEmitter()
        if emitter:isPlaying(task.sound) then
            emitter:stopSoundByName(task.sound)
        end
    end

    return true
end
