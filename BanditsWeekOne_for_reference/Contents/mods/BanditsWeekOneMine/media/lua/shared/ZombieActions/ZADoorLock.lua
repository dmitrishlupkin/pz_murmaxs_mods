ZombieActions = ZombieActions or {}

ZombieActions.DoorLock = {}
ZombieActions.DoorLock.onStart = function(zombie, task)
    return true
end

ZombieActions.DoorLock.onWorking = function(zombie, task)

    zombie:faceLocationF(task.x, task.y)

    if task.time <= 0 then return true end
    return false
end

ZombieActions.DoorLock.onComplete = function(zombie, task)
    local square = zombie:getCell():getGridSquare(task.x, task.y, task.z)
    if square then
        local objects = square:getObjects()
        for i=0, objects:size()-1 do
            local object = objects:get(i)
            if instanceof(object, "IsoDoor") then
                if object:IsOpen() then
                    object:ToggleDoorSilent()
                    zombie:playSound("MetalDoorClose")
                    
                    local args = {
                        x = object:getSquare():getX(),
                        y = object:getSquare():getY(),
                        z = object:getSquare():getZ(),
                        index = object:getObjectIndex()
                    }
                    sendClientCommand(getSpecificPlayer(0), 'Commands', 'CloseDoor', args)
                else
                    if task.unlock then
                        object:setLockedByKey(false)
                        zombie:playSound("UnlockDoor")

                        local args = {
                            x = object:getSquare():getX(),
                            y = object:getSquare():getY(),
                            z = object:getSquare():getZ(),
                            index = object:getObjectIndex()
                        }
                        sendClientCommand(getSpecificPlayer(0), 'Commands', 'UnlockDoor', args)
                    else
                        object:setLockedByKey(true)
                        zombie:playSound("LockDoor")

                        local args = {
                            x = object:getSquare():getX(),
                            y = object:getSquare():getY(),
                            z = object:getSquare():getZ(),
                            index = object:getObjectIndex()
                        }
                        sendClientCommand(getSpecificPlayer(0), 'Commands', 'LockDoor', args)
                    end
                end
            end
        end
    end

    return true
end