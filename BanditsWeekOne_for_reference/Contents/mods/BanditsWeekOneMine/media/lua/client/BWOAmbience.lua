BWOAmbience = BWOAmbience or {}

BWOAmbience.sounds = {}
BWOAmbience.tick = 0

radiation = {}
radiation.name = "BWOAmbientRadiation"
radiation.mode = "Radial"
radiation.fadeIn = 400
radiation.fadeOut = 400
radiation.fadeTo = 1
radiation.radius = 10
radiation.status = false
BWOAmbience.sounds.radiation = radiation

gunfight = {}
gunfight.name = "BWOAmbientGunsFar"
gunfight.mode = "Fixed"
gunfight.fadeIn = 100
gunfight.fadeOut = 100
gunfight.fadeTo = 1
gunfight.status = false
BWOAmbience.sounds.gunfight = gunfight

-- effect: name - name of the soundfile
-- fadeInTime: number of tick to fade in
-- fadeOutTime: number of ticks to fade out
-- fadeTo: peak volume
BWOAmbience.Enable = function(name)
    if BWOAmbience.sounds[name] then
        BWOAmbience.sounds[name].status = true
    end
end

BWOAmbience.Disable = function(name)
    if BWOAmbience.sounds[name] then
        BWOAmbience.sounds[name].status = false
    end
end

BWOAmbience.SetPos = function(name, x, y, z)
    if BWOAmbience.sounds[name] then
        BWOAmbience.sounds[name].x = x
        BWOAmbience.sounds[name].y = y
        BWOAmbience.sounds[name].z = z
    end
end

BWOAmbience.Process = function(player)

    if isServer() then return end

    local world = getWorld()
    local px, py, pz = player:getX(), player:getY(), player:getZ()

    for _, sound in pairs(BWOAmbience.sounds) do

        if not sound.volume then
            sound.volume = 0
        end

        if sound.mode == "Radial" then

            -- regiter emitter pair for deep stereo ambience
            local radius = sound.radius
            local lx = px - radius
            local ly = py + radius
            local rx = px + radius
            local ry = py - radius
            local left = sound.name .. "Left"
            local right = sound.name .. "Right"

            if sound.status then
                if not sound.emitter1 then
                    sound.emitter1 = world:getFreeEmitter(lx, ly, pz)
                end

                if not sound.emitter2 then
                    sound.emitter2 = world:getFreeEmitter(rx, ry, pz)
                end

                if sound.volume < sound.fadeTo then
                    local step = sound.fadeTo / sound.fadeIn
                    sound.volume = sound.volume + step

                    if sound.volume > sound.fadeTo then
                        sound.volume = sound.fadeTo
                    end
                end
            else
                if sound.volume > 0 then
                    local step = sound.fadeTo / sound.fadeOut
                    sound.volume = sound.volume - step

                    if sound.volume < 0 then
                        sound.volume = 0
                    end

                    if sound.volume == 0 then
                        sound.emitter1:stopAll()
                        sound.emitter2:stopAll()
                        sound.emitter1 = nil
                        sound.emitter2 = nil
                    end
                end
            end

            if sound.emitter1 and sound.emitter2 then

                sound.emitter1:setPos(lx, ly, pz)
                sound.emitter2:setPos(rx, ry, pz)

                sound.emitter1:setVolumeAll(sound.volume)
                sound.emitter2:setVolumeAll(sound.volume)

                if not sound.emitter1:isPlaying(left) then
                    sound.emitter1:playAmbientSound(left)
                end

                if not sound.emitter2:isPlaying(right) then
                    sound.emitter2:playAmbientSound(right)
                end

                sound.emitter1:tick()
                sound.emitter2:tick()
            end
        end

        if sound.mode == "Fixed" then
            if sound.status then
                if not sound.emitter then
                    sound.emitter = world:getFreeEmitter(sound.x, sound.y, sound.z)
                end

                if sound.volume < sound.fadeTo then
                    local step = sound.fadeTo / sound.fadeIn
                    sound.volume = sound.volume + step

                    if sound.volume > sound.fadeTo then
                        sound.volume = sound.fadeTo
                    end
                end
            else
                if sound.volume > 0 then
                    local step = sound.fadeTo / sound.fadeOut
                    sound.volume = sound.volume - step

                    if sound.volume < 0 then
                        sound.volume = 0
                    end

                    if sound.volume == 0 then
                        sound.emitter:stopAll()
                        sound.emitter = nil
                    end
                end
            end

            if sound.emitter then
                sound.emitter:setVolumeAll(sound.volume)

                if not sound.emitter:isPlaying(sound.name) then
                    sound.emitter1:playAmbientSound(sound.name)
                end

                sound.emitter:tick()
            end
        end
    end
end

Events.OnPlayerUpdate.Add(BWOAmbience.Process)
