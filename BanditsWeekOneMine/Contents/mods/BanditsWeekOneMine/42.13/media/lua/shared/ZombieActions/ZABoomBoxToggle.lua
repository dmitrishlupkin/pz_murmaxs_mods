ZombieActions = ZombieActions or {}

ZombieActions.BoomboxToggle = {}
ZombieActions.BoomboxToggle.onStart = function(zombie, task)
    return true
end

ZombieActions.BoomboxToggle.onWorking = function(zombie, task)
    zombie:faceLocationF(task.x, task.y)
    if zombie:getBumpType() ~= task.anim then return true end
    return false
end

ZombieActions.BoomboxToggle.onComplete = function(zombie, task)
    local square = zombie:getCell():getGridSquare(task.x, task.y, task.z)
    if square then
        local objects = square:getObjects()
        for i=0, objects:size()-1 do
            local object = objects:get(i)
            if instanceof(object, "IsoRadio") then
                local dd = object:getDeviceData()
                
                dd:setIsTurnedOn(task.on)

                local musicId = nil
                musicId = "#" .. object:getX() .. "-" .. object:getY() .. "-" .. object:getZ()

                local md = object:getModData()
                if not md.tcmusic then md.tcmusic = {} end

                if not task.on and md.tcmusic.isPlaying then -- dd:isPlayingMedia()
                    md.tcmusic.isPlaying = false 
                    if dd:getEmitter() then
                        dd:getEmitter():stopAll()
                    end
                    ModData.getOrCreate("trueMusicData")["now_play"][musicId] = nil
                end

                if (task.on and not md.tcmusic.isPlaying) then
                    getSoundManager():StopMusic()
                    md.tcmusic.isPlaying = true
                    -- print("playSound WO PLAYER")
                    -- print(dd:getParent())
                    dd:getEmitter():stopAll()
                    dd:setNoTransmit(false)
                    dd:playSound(md.tcmusic.mediaItem, dd:getDeviceVolume() * 0.4, false)
                    
                    ModData.getOrCreate("trueMusicData")["now_play"][musicId] = {
                        volume = dd:getDeviceVolume(),
                        headphone = dd:getHeadphoneType() >= 0,
                        timestamp = "update",
                        musicName = md.tcmusic.mediaItem,
                    }
                    if md.tcmusic.deviceType == "InventoryItem" then
                        ModData.getOrCreate("trueMusicData")["now_play"][musicId]["itemid"] = object:getID()
                    end
                end
                object:transmitModData()
                if isClient() then ModData.transmit("trueMusicData") end
                
            end
        end
    end
    return true
end

