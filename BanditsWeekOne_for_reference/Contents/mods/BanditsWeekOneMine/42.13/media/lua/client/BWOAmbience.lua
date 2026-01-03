BWOAmbience = BWOAmbience or {}

BWOAmbience.sounds = {}
BWOAmbience.tick = 0

-- Radiation sound
local radiation = {
    name = "BWOAmbientRadiation",
    mode = "Radial",
    fadeIn = 400,
    fadeOut = 400,
    fadeTo = 1,
    radius = 10,
    status = false
}
BWOAmbience.sounds.radiation = radiation

-- Gunfight sound
local gunfight = {
    name = "BWOAmbientGunsFar",
    mode = "Fixed",
    fadeIn = 100,
    fadeOut = 100,
    fadeTo = 1,
    status = false
}
BWOAmbience.sounds.gunfight = gunfight

-- Enable a sound effect
function BWOAmbience.Enable(name)
    if BWOAmbience.sounds[name] then
        BWOAmbience.sounds[name].status = true
    end
end

-- Disable a sound effect
function BWOAmbience.Disable(name)
    if BWOAmbience.sounds[name] then
        BWOAmbience.sounds[name].status = false
    end
end

-- Set position for Fixed mode
function BWOAmbience.SetPos(name, x, y, z)
    if BWOAmbience.sounds[name] then
        BWOAmbience.sounds[name].x = x
        BWOAmbience.sounds[name].y = y
        BWOAmbience.sounds[name].z = z
    end
end

-- Main update function
function BWOAmbience.Process(player)
    if isServer() then return end

    local world = getWorld()
    local px, py, pz = player:getX(), player:getY(), player:getZ()

    for _, sound in pairs(BWOAmbience.sounds) do
        sound.volume = sound.volume or 0

        if sound.mode == "Radial" then
            local radius = sound.radius
            local lx, ly = px - radius, py + radius
            local rx, ry = px + radius, py - radius
            local left = sound.name .. "Left"
            local right = sound.name .. "Right"

            if sound.status then
                if not sound.emitter1 then
                    sound.emitter1 = world:getFreeEmitter(lx, ly, pz)
                end
                if not sound.emitter2 then
                    sound.emitter2 = world:getFreeEmitter(rx, ry, pz)
                end
                local step = sound.fadeTo / sound.fadeIn
                sound.volume = math.min(sound.volume + step, sound.fadeTo)
            else
                local step = sound.fadeTo / sound.fadeOut
                sound.volume = math.max(sound.volume - step, 0)
                if sound.volume == 0 then
                    if sound.emitter1 then sound.emitter1:stopAll(); sound.emitter1 = nil end
                    if sound.emitter2 then sound.emitter2:stopAll(); sound.emitter2 = nil end
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

        elseif sound.mode == "Fixed" then
            if sound.status then
                if not sound.emitter then
                    sound.emitter = world:getFreeEmitter(sound.x or px, sound.y or py, sound.z or pz)
                end
                local step = sound.fadeTo / sound.fadeIn
                sound.volume = math.min(sound.volume + step, sound.fadeTo)
            else
                local step = sound.fadeTo / sound.fadeOut
                sound.volume = math.max(sound.volume - step, 0)
                if sound.volume == 0 and sound.emitter then
                    sound.emitter:stopAll()
                    sound.emitter = nil
                end
            end

            if sound.emitter then
                sound.emitter:setVolumeAll(sound.volume)

                if not sound.emitter:isPlaying(sound.name) then
                    sound.emitter:playAmbientSound(sound.name)
                end

                sound.emitter:tick()
            end
        end
    end
end

Events.OnPlayerUpdate.Add(BWOAmbience.Process)
