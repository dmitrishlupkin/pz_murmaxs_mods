ZombieActions = ZombieActions or {}

ZombieActions.Graffiti = {}
ZombieActions.Graffiti.onStart = function(zombie, task)
    return true
end

ZombieActions.Graffiti.onWorking = function(zombie, task)
    if task.dir == "N" then
        zombie:faceLocationF(task.x, task.y - 1)
    elseif task.dir == "W" then
        zombie:faceLocationF(task.x - 1, task.y)
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
end

ZombieActions.Graffiti.onComplete = function(zombie, task)
    local cell = zombie:getCell()

    local gSprites = {}
    gSprites.N = {}
    table.insert (gSprites.N, {"overlay_graffiti_wall_01_16", "overlay_graffiti_wall_01_17", "overlay_graffiti_wall_01_18"})
    table.insert (gSprites.N, {"overlay_graffiti_wall_01_21", "overlay_graffiti_wall_01_22", "overlay_graffiti_wall_01_23"})
    table.insert (gSprites.N, {"overlay_graffiti_wall_01_24", "overlay_graffiti_wall_01_26", "overlay_graffiti_wall_01_26"})
    table.insert (gSprites.N, {"overlay_graffiti_wall_01_32", "overlay_graffiti_wall_01_33", "overlay_graffiti_wall_01_34"})
    table.insert (gSprites.N, {"overlay_graffiti_wall_01_37", "overlay_graffiti_wall_01_38", "overlay_graffiti_wall_01_39"})
    table.insert (gSprites.N, {"overlay_graffiti_wall_01_48", "overlay_graffiti_wall_01_49", "overlay_graffiti_wall_01_50"})
    table.insert (gSprites.N, {"overlay_graffiti_wall_01_96", "overlay_graffiti_wall_01_97", "overlay_graffiti_wall_01_98"})

    gSprites.W = {}
    table.insert (gSprites.W, {"overlay_graffiti_wall_01_2", "overlay_graffiti_wall_01_1", "overlay_graffiti_wall_01_0"})
    table.insert (gSprites.W, {"overlay_graffiti_wall_01_5", "overlay_graffiti_wall_01_4", "overlay_graffiti_wall_01_3"})
    table.insert (gSprites.W, {"overlay_graffiti_wall_01_43", "overlay_graffiti_wall_01_42", "overlay_graffiti_wall_01_41"})
    table.insert (gSprites.W, {"overlay_graffiti_wall_01_46", "overlay_graffiti_wall_01_45", "overlay_graffiti_wall_01_44"})
    table.insert (gSprites.W, {"overlay_graffiti_wall_01_58", "overlay_graffiti_wall_01_57", "overlay_graffiti_wall_01_56"})
    table.insert (gSprites.W, {"overlay_graffiti_wall_01_76", "overlay_graffiti_wall_01_75", "overlay_graffiti_wall_01_74"})
    table.insert (gSprites.W, {"overlay_graffiti_wall_01_82", "overlay_graffiti_wall_01_81", "overlay_graffiti_wall_01_80"})
    table.insert (gSprites.W, {"overlay_graffiti_wall_01_93", "overlay_graffiti_wall_01_92", "overlay_graffiti_wall_01_91"})

    local squareList = {}
    if task.dir == "N" then
        for x=-1, 1 do
            table.insert(squareList, cell:getGridSquare(task.x + x, task.y, task.z))
        end
    else
        
        for y=-1, 1 do
            table.insert(squareList, cell:getGridSquare(task.x, task.y + y, task.z))
        end
    end

    local rnd = 1 + ZombRand(#gSprites[task.dir])
    local spIdx = 1
    for _, square in pairs(squareList) do
        local wall
        if task.dir == "N" then
            wall = square:getWall(true)
        elseif task.dir == "W" then
            wall = square:getWall(false)
        end

        if wall then
            local spriteName = gSprites[task.dir][rnd][spIdx]
            local list = ArrayList.new()
            local attachments = wall:getAttachedAnimSprite()
            if not attachments or attachments:size() == 0 then
                wall:setAttachedAnimSprite(ArrayList.new())
            end
            wall:getAttachedAnimSprite():add(getSprite(spriteName):newInstance())
        end
        spIdx = spIdx + 1
    end

    return true
end