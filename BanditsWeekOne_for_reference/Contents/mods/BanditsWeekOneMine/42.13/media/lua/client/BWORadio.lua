BWORadio = BWORadio or {}
BWORadio.tick = 0
BWORadio.cache = {}

local function getGUID(codes)
    return codes:match("GUID:([%w%-]+)")
end

local function getEmitter(device)
    local deviceData = device:getDeviceData()

    local emitter, vehicle, id
    if deviceData:isVehicleDevice() then
        local vehiclePart = deviceData:getParent()
        if vehiclePart then
            vehicle = vehiclePart:getVehicle()
            if vehicle then
                local x, y, z = vehicle:getX(), vehicle:getY(), vehicle:getZ()
                id = x .. "-" .. y .. "-" .. z
                emitter = vehicle:getEmitter()
            end
        end
    end

    if not emitter then

        local x, y, z = device:getX(), device:getY(), device:getZ()
        id = x .. "-" .. y .. "-" .. z

        emitter = deviceData:getEmitter()

    end
    local wemitter = getWorld():getFreeEmitter()

    return emitter, wemitter, vehicle, id
end

BWORadio.PlaySound = function(device, sound)
    local emitter, wemitter, vehicle, id = getEmitter(device)
    if emitter and id then
        BWORadio.cache[id] = {
            device = device,
            vehicle = vehicle,
            wemitter = wemitter,
            emitter = emitter,
            sound = sound,
            ts = getTimestampMs(),
            started = false
        }
    end
end

BWORadio.IsPlaying = function(device)
    local x, y, z = device:getX(), device:getY(), device:getZ()
    local id = x .. "-" .. y .. "-" .. z
    return BWORadio.cache[id] ~= nil
end

BWORadio.IsPlayingSound = function(device, sound)
    local emitter = getEmitter(device)
    return emitter and sound and emitter:isPlaying(sound) or false
end

local function onDeviceText(guid, codes, x, y, z, text, device)
    local sound = getGUID(codes)
    if sound then
        BWORadio.PlaySound(device, sound)
    end
end

local function onTick()

    BWORadio.tick = (BWORadio.tick + 1) % 4
    if BWORadio.tick > 0 then return end

    local cache = BWORadio.cache
    local timeMultiplier = UIManager.getSpeedControls():getCurrentGameSpeed()
    local now = getTimestampMs()

    for id, v in pairs(cache) do
        repeat
            if not v.wemitter or not v.device then
                cache[id] = nil
                break
            end

            if now - v.ts > 120000 then
                v.wemitter:stopAll()
                getWorld():returnOwnershipOfEmitter(v.wemitter)
                cache[id] = nil
                break
            end

            local deviceData = v.device:getDeviceData()
            if not deviceData then
                cache[id] = nil
                break
            end

            if not v.started then
                if timeMultiplier > 1 then
                    if not v.wemitter:isPlaying("FastForward") then
                        v.wemitter:stopAll()
                        v.wemitter:playSound("FastForward")
                    end
                else
                    if v.wemitter:isPlaying("FastForward") then
                        v.wemitter:stopAll()
                    end
                    if not v.wemitter:isPlaying(v.sound) then
                        v.wemitter:stopAll()
                        v.wemitter:playSound(v.sound)
                        getWorld():takeOwnershipOfEmitter(v.wemitter)
                    end
                end
                v.started = true
            else
                if not v.wemitter:isPlaying(v.sound) then
                    v.wemitter:stopAll()
                    getWorld():returnOwnershipOfEmitter(v.wemitter)
                    cache[id] = nil
                    break
                end
            end

            if deviceData:isInventoryDevice() then
                v.wemitter:setVolumeAll(0)
                v.wemitter:tick()
                cache[id] = nil
                break
            end

            local volume = deviceData:getIsTurnedOn() and (deviceData:getDeviceVolume() / 3) or 0
            v.wemitter:setVolumeAll(volume)
            v.wemitter:tick()

            local x, y, z
            if v.vehicle then
                x, y, z = v.vehicle:getX(), v.vehicle:getY(), v.vehicle:getZ()
            else
                x, y, z = v.device:getX(), v.device:getY(), v.device:getZ()
            end

            if x and y and z then
                v.wemitter:setPos(x, y, z)
            end
        until true
    end
end

Events.OnDeviceText.Add(onDeviceText)
Events.OnTick.Add(onTick)
