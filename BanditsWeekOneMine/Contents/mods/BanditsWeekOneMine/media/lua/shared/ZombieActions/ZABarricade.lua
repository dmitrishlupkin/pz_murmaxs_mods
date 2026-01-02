ZombieActions = ZombieActions or {}

ZombieActions.Barricade = {}
ZombieActions.Barricade.onStart = function(zombie, task)

    local fx, fy
    local square = zombie:getCell():getGridSquare(task.x, task.y, task.z)
    if square then
        local objects = square:getObjects()
        for i=0, objects:size()-1 do
            local object = objects:get(i)
            local properties = object:getProperties()

            if instanceof(object, "IsoWindow") then
                task.idx = object:getObjectIndex()
                if properties:Is(IsoFlagType.WindowN) then
                    fx = square:getX()
                    fy = square:getY() + 0.25
                else
                    fx = square:getX() + 0.25
                    fy = square:getY()
                end
                break
                
            elseif instanceof(object, "IsoDoor") then
                task.idx = object:getObjectIndex()
                if properties:Is(IsoFlagType.doorN) then
                    fx = square:getX()
                    fy = square:getY() + 0.25
                else
                    fx = square:getX() + 0.25
                    fy = square:getY()
                end

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
                end

                break
            end
            
        end
    end

    task.fx = fx
    task.fy = fy
    Bandit.UpdateTask(zombie, task)

    zombie:playSound("Hammering")

    return true
end

ZombieActions.Barricade.onWorking = function(zombie, task)
    if task.fx and task.fy then
        zombie:faceLocationF(task.fx, task.fy)
    end

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

ZombieActions.Barricade.onComplete = function(zombie, task)
    if task.idx then
        zombie:getEmitter():stopAll()
        zombie:playSound("RemoveBarricadePlank")

        local square = zombie:getCell():getGridSquare(task.x, task.y, task.z)
        if square then
            local objects = square:getObjects()
            for i=0, objects:size()-1 do
                local object = objects:get(i)
                if instanceof(object, "IsoDoor") and object:IsOpen() then
                    object:ToggleDoorSilent()

                    local args = {
                        x = object:getSquare():getX(),
                        y = object:getSquare():getY(),
                        z = object:getSquare():getZ(),
                        index = object:getObjectIndex()
                    }
                    sendClientCommand(getSpecificPlayer(0), 'Commands', 'ToggleDoor', args)

                elseif instanceof(object, "IsoDoor") or instanceof(object, "IsoWindow") then
                    if BanditUtils.IsController(zombie) then
                        local numPlanks = 0
                        local barricade = object:getBarricadeOnSameSquare()
                        if barricade then
                            numPlanks = numPlanks + barricade:getNumPlanks()
                        end

                        local barricade2 = object:getBarricadeOnOppositeSquare()
                        if barricade2 then
                            numPlanks = numPlanks + barricade2:getNumPlanks()
                        end

                        if numPlanks < 4 then
                            local args = {x=task.x, y=task.y, z=task.z, index=task.idx, condition=100}

                            if isClient() then
                                sendClientCommand(getSpecificPlayer(0), 'Commands', 'Barricade', args)
                            else
                                BanditServer.Commands.Barricade(getSpecificPlayer(0), args)
                            end
                        end
                    end
                end
            end
        end
    end

    return true
end