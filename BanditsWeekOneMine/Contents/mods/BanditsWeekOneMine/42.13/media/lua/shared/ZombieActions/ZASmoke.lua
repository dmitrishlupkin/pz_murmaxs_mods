ZombieActions = ZombieActions or {}

ZombieActions.Smoke = {}
ZombieActions.Smoke.onStart = function(zombie, task)
    local fakeItem = BanditCompatibility.InstanceItem("Bandits.Cigarette")
    zombie:setSecondaryHandItem(fakeItem)

    return true
end

ZombieActions.Smoke.onWorking = function(zombie, task)
    if task.time <= 0 then
        return true
    elseif math.floor(task.time) == 12 then
        local effect = {}
        effect.x = zombie:getX()
        effect.y = zombie:getY()
        effect.z = zombie:getZ()
        effect.size = 600
        effect.name = "mist"
        effect.frameCnt = 60
        effect.repCnt = 2
        effect.colors = {r=0.9, g=0.9, b=1.0, a=0.2}

        table.insert(BWOEffects2.tab, effect)
    else
        local bumpType = zombie:getBumpType()
        if bumpType ~= task.anim then 
            -- zombie:playSound("Smoke")
            zombie:setBumpType(task.anim)
        end
    end
end

ZombieActions.Smoke.onComplete = function(zombie, task)
    zombie:setSecondaryHandItem(nil)
    return true
end