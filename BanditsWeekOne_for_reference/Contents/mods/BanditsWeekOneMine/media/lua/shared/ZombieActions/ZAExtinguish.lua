ZombieActions = ZombieActions or {}

ZombieActions.Extinguish = {}
ZombieActions.Extinguish.onStart = function(zombie, task)
    if task.item then
        local fakeItem = BanditCompatibility.InstanceItem(task.item)
        if not task.left then
            zombie:setPrimaryHandItem(fakeItem)
        end
        if not task.right then
            zombie:setSecondaryHandItem(fakeItem)
        end
    end

    local effect = {}
    effect.x = task.x
    effect.y = task.y
    effect.z = task.z
    effect.size = 600
    effect.name = "mist"
    effect.frameCnt = 60
    effect.repCnt = 2
    effect.colors = {r=0.9, g=0.9, b=1.0, a=0.2}

    table.insert(BWOEffects2.tab, effect)

    

    --[[
    local effect2 = {}
    effect2.x = zombie:getX()
    effect2.y = zombie:getY()
    effect2.z = zombie:getZ()
    effect2.offset = 300
    effect2.name = "mist"
    effect2.frameCnt = 60
    effect2.frameRnd = false
    effect2.repCnt = 2
    effect2.r = 0.82
    effect2.g = 0.94
    effect2.b = 0.97

    if isClient() then
        sendClientCommand(getSpecificPlayer(0), 'Schedule', 'AddEffect', effect2)
    else
        table.insert(BanditEffects.tab, effect2)
    end]]

    return true
end

ZombieActions.Extinguish.onWorking = function(zombie, task)

    local cell = getCell()
    local square = cell:getGridSquare(task.x, task.y, task.z)
    if not square:haveFire() then
        return true
    end

    zombie:faceLocation(task.x, task.y)
    if task.time <= 0 then
        return true
    else
        local bumpType = zombie:getBumpType()
        if bumpType ~= task.anim then 
            zombie:setBumpType(task.anim)

            if task.sound then
                local emitter = zombie:getEmitter()
                if not emitter:isPlaying(task.sound) then
                    emitter:playSound(task.sound)
                end
            end
            
        end
    end
    return false
end

ZombieActions.Extinguish.onComplete = function(zombie, task)
    local cell = getCell()
    local square = cell:getGridSquare(task.x, task.y, task.z)
    if square then
        square:stopFire()
        local args = {x=task.x, y=task.y, z=task.z, otype="fire"}
        -- bugged dunno why
        -- sendClientCommand(getSpecificPlayer(0), 'Commands', 'ObjectRemove', args)
        BWOServer.Commands.ObjectRemove(getSpecificPlayer(0), args)

        if BWOScheduler.Anarchy.Transactions then
            BWOPlayer.Earn(zombie, 20)
            Bandit.UpdateItemsToSpawnAtDeath(zombie)
        end
    end
    if task.item then
        if task.left then
            zombie:setSecondaryHandItem(nil)
        else
            zombie:setPrimaryHandItem(nil)
        end
    end
    return true
end