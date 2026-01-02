ZombieActions = ZombieActions or {}

ZombieActions.Heal = {}
ZombieActions.Heal.onStart = function(zombie, task)
    return true
end

ZombieActions.Heal.onWorking = function(zombie, task)
    zombie:faceLocationF(task.x, task.y)
    if not task.stage then task.stage = 1 end
    
    if not zombie:isBumped() then
        if task.stage == 1 then
            zombie:setBumpType("CPRStart")
        elseif task.stage < 20 then
            zombie:setBumpType("CPRLoop")
            -- zombie:addLineChatElement(tostring(task.stage - 1), 0, 1, 0)
        else
            zombie:setBumpType("CPREnd")
        end

        task.stage = task.stage + 1
        Bandit.UpdateTask(zombie, task)
    end

    if task.stage == 20 then
        return true
    end

    return false
end

ZombieActions.Heal.onComplete = function(zombie, task)
    local square = getCell():getGridSquare(task.x, task.y, task.z)
    if square then
        local corpse = square:getDeadBody()
        if corpse then
            Bandit.Say(zombie, "CPRFAILED")
            -- corpse:reanimateNow()
            -- square:removeCorpse(corpse, true)
            -- square:AddWorldInventoryItem(corpse:getItem(), 0.5, 0.5, 0)
            -- ISInventoryPage.dirtyUI()
            
            -- unregister dead body
            local args = {x=corpse:getX(), y=corpse:getY(), z=corpse:getZ()}
            -- sendClientCommand(getSpecificPlayer(0), 'Commands', 'DeadBodyRemove', args)
            BWOServer.Commands.DeadBodyRemove(getSpecificPlayer(0), args)
        end
    end
    return true
end