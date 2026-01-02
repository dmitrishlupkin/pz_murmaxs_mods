BWORadio = BWORadio or {}
BWORadio.tick = 0
BWORadio.cache = {}

local function onTick()

    BWORadio.tick = BWORadio.tick + 1
    if BWORadio.tick >= 4 then
        BWORadio.tick = 0
    end
    if BWORadio.tick > 0 then return end

    local cache = BWORadio.cache
    local timeMultiplier = UIManager.getSpeedControls():getCurrentGameSpeed()

    local done = {}
    for k, v in pairs(cache) do

        -- gc
        if v.ts + 120000 < getTimestampMs() then
            BWORadio.cache[k] = nil
            return
        end

        if v.device and v.emitter then
            if not v.started then
                if timeMultiplier > 1 then
                    if not v.emitter:isPlaying("FastForward") then
                        v.emitter:stopAll()
                        v.emitter:playSound("FastForward")
                    end
                else
                    if v.emitter:isPlaying("FastForward") then
                        v.emitter:stopAll()
                    end
                    if not v.emitter:isPlaying(v.sound) then
                        v.emitter:playSound(v.sound)
                        -- v.emitter:tick()
                    end
                end
                v.started = true
            else
                if not v.emitter:isPlaying(v.sound) then
                    BWORadio.cache[k] = nil
                    return
                end
            end

            local deviceData = v.device:getDeviceData()

            if deviceData:isInventoryDevice() then
                v.emitter:setVolumeAll(0)
                v.emitter:tick()
                BWORadio.cache[k] = nil
                return
            end

            local volume = deviceData:getDeviceVolume()
            if not deviceData:getIsTurnedOn() then
                volume = 0
            end
            v.emitter:setVolumeAll(volume / 3)
            v.emitter:tick()

            local x, y, z
            if v.vehicle then
                x, y, z = v.vehicle:getX(), v.vehicle:getY(), v.vehicle:getZ()
            else
                x, y, z = v.device:getX(), v.device:getY(), v.device:getZ()
            end
            if x and y and z then
                v.emitter:setPos(x, y, z)
            end
        end
    end
end

local function onDeviceText(guid, codes, x, y, z, text, device)
    
    function getGUID(codes)
        local guid = codes:match("GUID:([%w%-]+)")
        return guid
    end

    local sound = getGUID(codes)
    if not sound then return end

    BWORadio.PlaySound(device, sound)
end

local getEmitter = function(device)
    local world = getWorld()
    local deviceData = device:getDeviceData()

    local emitter
    local vehicle
    local id
    if deviceData:isVehicleDevice() then
        local vehiclePart = deviceData:getParent()
        if vehiclePart then
            local vehicle = vehiclePart:getVehicle()
            if vehicle then
                emitter = vehicle:getEmitter()
                id = vehicle:getId()
            end
        end
    end
               
    if not emitter then
        local x, y, z = device:getX(), device:getY(), device:getZ()
        -- emitter = world:getFreeEmitter(x, y, z)
        emitter = deviceData:getEmitter()
        id = x .. "-" .. y .. "-" .. z
    end

    return emitter, id
end

BWORadio.PlaySound = function(device, sound)
    local emitter, id = getEmitter(device)
    BWORadio.cache[id] = {device=device, vehicle=vehicle, emitter=emitter, sound=sound, ts=getTimestampMs()}
end

BWORadio.IsPlaying = function(device)
    local x, y, z = device:getX(), device:getY(), device:getZ()
    local id = x .. "-" .. y .. "-" .. z
    if BWORadio.cache[id] then
        return true
    else
        return false
    end
end

BWORadio.IsPlayingSound = function(device, sound)
    local emitter, id = getEmitter(device)
    if emitter and sound then 
        if emitter:isPlaying(sound) then
            return true
        else
            return false
        end
    else
        return false
    end
end

Events.OnDeviceText.Add(onDeviceText)
Events.OnTick.Add(onTick)