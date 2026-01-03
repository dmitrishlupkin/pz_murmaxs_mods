BWOMusic = BWOMusic or {}
BWOMusic.tick = 0
BWOMusic.origReturnVolume = nil
BWOMusic.customId = nil
BWOMusic.customTargetVolume = 0
BWOMusic.customCurrentVolume = 0
BWOMusic.emitter = nil

BWOMusic.OnMusicVolumeChange = function(volume)
    print (volume)
    BWOMusic.origReturnVolume = volume
end

BWOMusic.Play = function(music, volume)
    if not volume then volume = 1 end

    local emitter
    local player = getSpecificPlayer(0)
    if player then
        emitter = player:getEmitter()
    else
        emitter = getSoundManager():getUIEmitter()
        -- in main menu this is necessary to have stereo effect
        emitter:setPos(0, 0, 0)
    end
    BWOMusic.emitter =  emitter

    -- stop previous custom music if there is one
    if BWOMusic.customId then
        emitter:stopSound(BWOMusic.customId)
        BWOMusic.customId = nil
        BWOMusic.customCurrentVolume = 0
    end

    -- start custom music
    local id = emitter:playSound(music)
    if id then
        emitter:setVolume(id, 0)
        BWOMusic.customId = id
        BWOMusic.customCurrentVolume = 0
        BWOMusic.customTargetVolume = volume
        BWOMusic.origReturnVolume = getSoundManager():getMusicVolume()
    end
end

BWOMusic.Process = function()
    
    if not BWOMusic.emitter then return end

    local max = 160
    if isIngameState() then
        max = 30
    end

    if BWOMusic.tick > 0 then
        BWOMusic.tick = BWOMusic.tick + 1
        if BWOMusic.tick >= max then
            BWOMusic.tick = 0
        end
        return
    end

    if getCore():getOptionUIRenderFPS() ~= 60 then
        getCore():setOptionUIRenderFPS(60)
    end

    if BWOMusic.customId then
        -- fade out orig
        local sm = getSoundManager()
        local origVolume = sm:getMusicVolume()
        local newVolume = origVolume - 0.1
        if newVolume < 0 then newVolume = 0 end
        sm:setMusicVolume(newVolume)
        getCore():setOptionMusicVolume(newVolume * 10)

        -- fade in custom
        local emitter = BWOMusic.emitter
        if emitter:isPlaying(BWOMusic.customId) then
            local newVolume = BWOMusic.customCurrentVolume + 0.1
            if newVolume > BWOMusic.customTargetVolume then newVolume = BWOMusic.customTargetVolume end
            BWOMusic.customCurrentVolume = newVolume
            emitter:setVolume(BWOMusic.customId, newVolume)
        else
            BWOMusic.customId = nil
            BWOMusic.customCurrentVolume = 0
        end
    else
        -- fade in orig
        local sm = getSoundManager()
        local origVolume = sm:getMusicVolume()
        local newVolume = origVolume + 0.1
        if newVolume <= BWOMusic.origReturnVolume then
            sm:setMusicVolume(newVolume)
            getCore():setOptionMusicVolume(newVolume * 10)
        end
    end

    BWOMusic.tick = 1
end

Events.OnPreUIDraw.Add(BWOMusic.Process)
