ZombieActions = ZombieActions or {}

ZombieActions.PlaceItem = {}
ZombieActions.PlaceItem.onStart = function(zombie, task)
    return true
end

ZombieActions.PlaceItem.onWorking = function(zombie, task)
    zombie:faceLocationF(task.x, task.y)
    if zombie:getBumpType() ~= task.anim then return true end
    return false
end

ZombieActions.PlaceItem.onComplete = function(zombie, task)
    if task.item and BanditUtils.IsController(zombie) then
        local item = BanditCompatibility.InstanceItem(task.item)
        if item then
            local square = getCell():getGridSquare(task.x, task.y, task.z)
            if square then
                local surfaceOffset = BanditUtils.GetSurfaceOffset(task.x, task.y, task.z)
                if not task.fx then task.fx = ZombRandFloat(0.2, 0.8) end
                if not task.fy then task.fy = ZombRandFloat(0.2, 0.8) end
                square:AddWorldInventoryItem(item, task.fx, task.fy, surfaceOffset)
            end
        end
    end
    
    return true
end

