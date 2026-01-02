ZombieActions = ZombieActions or {}

ZombieActions.BarbecueLit = {}
ZombieActions.BarbecueLit.onStart = function(zombie, task)
    return true
end

ZombieActions.BarbecueLit.onWorking = function(zombie, task)
    zombie:faceLocationF(task.x, task.y)
    if zombie:getBumpType() ~= task.anim then return true end
    return false
end

ZombieActions.BarbecueLit.onComplete = function(zombie, task)
    local square = zombie:getCell():getGridSquare(task.x, task.y, task.z)
    if square then
        local objects = square:getObjects()
        for i=0, objects:size()-1 do
            local object = objects:get(i)
            if instanceof(object, "IsoBarbecue") then
                if not object:isLit() then
                    if object:isPropaneBBQ() and object:hasFuel() then
                        -- local args = {x=object:getX(), y=object:getY(), z=object:getZ()}
                        -- sendClientCommand(getSpecificPlayer(0), 'bbq', 'toggle', args)
                        object:toggle()
                        object:sendObjectChange('state')
                    else
                        -- local args = {x=object:getX(), y=object:getY(), z=object:getZ(), fuelAmt = 40}
                        -- sendClientCommand(getSpecificPlayer(0), 'bbq', 'light', args)
                        object:addFuel(40)
                        object:setLit(true)
                        object:sendObjectChange('state')
                        zombie:playSound("BBQRegularLight")
                    end
                end
            end
        end
    end

    return true
end