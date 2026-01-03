ZombieActions = ZombieActions or {}

ZombieActions.RemoveObject = {}
ZombieActions.RemoveObject.onStart = function(zombie, task)
    return true
end

ZombieActions.RemoveObject.onWorking = function(zombie, task)
    zombie:faceLocation(task.x, task.y)
    if task.time <= 0 then
        return true
    else
        local bumpType = zombie:getBumpType()
        if bumpType ~= task.anim then 
            zombie:playSound("CleanBloodScrub")
            zombie:setBumpType(task.anim)
        end
    end
end

ZombieActions.RemoveObject.onComplete = function(zombie, task)
    zombie:getEmitter():stopAll()

    local square = zombie:getCell():getGridSquare(task.x, task.y, task.z)
    if not square then return true end

    square:removeBlood(false, false)

    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        local sprite = object:getSprite()
        if sprite then
            local props = sprite:getProperties()
            if props:Is("CustomName") then
                local customName = props:Val("CustomName")
                if customName == task.customName then
                    
                    if isClient() then
                        sledgeDestroy(object)
                    else
                        square:transmitRemoveItemFromSquare(object)
                    end

                    if BWOScheduler.Anarchy.Transactions then
                        BWOPlayer.Earn(zombie, 1)
                        Bandit.UpdateItemsToSpawnAtDeath(zombie)
                    end

                    break
                end
            end
        end
    end

    if task.otype then
        local args = {x=task.x, y=task.y, z=task.z, otype=task.otype}
        BWOServer.Commands.ObjectRemove(getSpecificPlayer(0), args)
    end

    return true
end