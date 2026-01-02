ZombieActions = ZombieActions or {}

ZombieActions.SitInChair = {}
ZombieActions.SitInChair.onStart = function(zombie, task)
    -- print ("X:" .. zombie:getX() .. "Y:" .. zombie:getY())
    if task.item then
        local fakeItem = BanditCompatibility.InstanceItem(task.item)
        if not task.left then
            zombie:setPrimaryHandItem(fakeItem)
        end
        if not task.right then
            zombie:setSecondaryHandItem(fakeItem)
        end
    end

    if task.x and task.y and task.z then
        local dx = 0
        local dy = 0
        local fx = 0 
        local fy = 0
        if task.facing then
            if task.facing == "S" then
                dx = 0.4
                dy = 0.8 
                fy = 20
            elseif task.facing == "N" then
                dx = 0.5
                dy = 0.2
                fy = -20
            elseif task.facing == "E" then
                dx = 0.8
                dy = 0.4
                fx = 20
            elseif task.facing == "W" then
                dx = 0.2
                dy = 0.5
                fx = -20    
            end
        end

        zombie:setX(task.x + dx)
        zombie:setY(task.y + dy)
        zombie:setZ(task.z)
        zombie:faceLocationF(task.x + fx, task.y + fy)
    end

    if task.sound then
        local emitter = zombie:getEmitter()
        if not emitter:isPlaying(task.sound) then
            emitter:playSound(task.sound)
        end
    end

    zombie:setBumpType(task.anim)

    return true
end

ZombieActions.SitInChair.onWorking = function(zombie, task)
 
    local bumpType = zombie:getBumpType()
    if bumpType ~= task.anim then
        return true
    end

    return false
end

ZombieActions.SitInChair.onComplete = function(zombie, task)
    if task.item then
        if task.left then
            zombie:setSecondaryHandItem(nil)
        else
            zombie:setPrimaryHandItem(nil)
        end
    end
    return true
end