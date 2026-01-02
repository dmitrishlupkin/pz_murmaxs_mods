BWOEventsPlace = BWOEventsPlace or {}

local spawnVehicle = function(x, y, dir, vtype)
    local cell = getCell()
    local square = getCell():getGridSquare(x, y, 0)
    if not square then return end

    if not square:isFree(false) then return end

    if square:getVehicleContainer() then return end

    local vehicle = addVehicleDebug(vtype, dir, nil, square)
    
    if not vehicle then return end

    --[[
    for i = 0, vehicle:getPartCount() - 1 do
        local container = vehicle:getPartByIndex(i):getItemContainer()
        if container then
            container:removeAllItems()
        end
    end]]

    vehicle:getModData().BWO = {}
    vehicle:getModData().BWO.wasRepaired = true
    vehicle:repair()
    vehicle:setColor(ZombRandFloat(0, 1), ZombRandFloat(0, 1), ZombRandFloat(0, 1))
    vehicle:setTrunkLocked(true)
    for i=0, vehicle:getMaxPassengers() -1 do 
        local part = vehicle:getPassengerDoor(i)
        if part then 
            local door = part:getDoor()
            if door then
                door:setLocked(true)
            end
        end
    end

    local gasTank = vehicle:getPartById("GasTank")
    if gasTank then
        local max = gasTank:getContainerCapacity() * 0.8
        gasTank:setContainerContentAmount(ZombRandFloat(0, max))
    end
end

function BWOEventsPlace.ArmyGuards(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local args = {
        cid = Bandit.clanMap.ArmyGreen,
        size = 3,
        program = "ArmyGuard",
        x = params.x,
        y = params.y,
        z = params.z
    }

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile then args.hostileP = true end

    sendClientCommand(player, 'Spawner', 'Clan', args)
end

function BWOEventsPlace.PolishHooligans(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local args = {
        cid = Bandit.clanMap.Polish,
        size = 4,
        program = "ArmyGuard",
        x = params.x,
        y = params.y,
        z = params.z,
        voice = 101,
        hostile = false, -- unless provoked
        hostileP = false
    }

    sendClientCommand(player, 'Spawner', 'Clan', args)
end

function BWOEventsPlace.GunshopGuard(params)
    local player = getSpecificPlayer(0)
    if not player then return end
        
    local args = {
        cid = Bandit.clanMap.Veteran,
        size = 1,
        program = "ArmyGuard",
        x = params.x,
        y = params.y,
        z = params.z
    }

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile then args.hostileP = true end

    sendClientCommand(player, 'Spawner', 'Clan', args)
end

function BWOEventsPlace.BaseDefenders(params)
    local player = getSpecificPlayer(0)
    if not player then return end
        
    local args = {
        cid = Bandit.clanMap.SecretLab,
        size = 4,
        program = "ArmyGuard",
        x = params.x,
        y = params.y,
        z = params.z
    }

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile then args.hostileP = true end

    sendClientCommand(player, 'Spawner', 'Clan', args)
end

function BWOEventsPlace.CarMechanic(params)

    local cell = getCell()
    local square = getCell():getGridSquare(params.x, params.y, 0)
    if not square then return end

    local vtype = BanditUtils.Choice(BWOVehicles.carChoices)

    local vehicle = addVehicleDebug(vtype, params.dir, nil, square)
    if not vehicle then return end

    --[[local vehicle = BaseVehicle.new(cell)
    vehicle:setScriptName(vtype)
    vehicle:setScript()
    vehicle:setDir(params.directions)
    vehicle:setX(params.x)
    vehicle:setY(params.y)
    vehicle:setZ(0)
    vehicle:setSquare(square)
    VehiclesDB2.instance:addVehicle(vehicle)
    -- vehicle:addToWorld()
    -- vehicle:setRust(0)]]

    if params.dir == IsoDirections.N then
        vehicle:setAngles(0, 180, 0)
    elseif params.dir == IsoDirections.S then
        vehicle:setAngles(0, 0, 0)
    elseif params.dir == IsoDirections.E then
        vehicle:setAngles(0, 90, 0)
    elseif params.dir == IsoDirections.W then
        -- vehicle:setAngles(-125, -90, -125)
        vehicle:setAngles(0, -90, 0)
    end

    for i = 0, vehicle:getPartCount() - 1 do
        local container = vehicle:getPartByIndex(i):getItemContainer()
        if container then
            container:removeAllItems()
        end
    end

    if params.dx then
        vehicle:setX(params.x + params.dx)
    end

    local md = vehicle:getModData()
    md.BWO = {}
    md.BWO.wasRepaired = true
    md.BWO.client = true
    md.BWO.parts = {}
    BWOVehicles.Repair(vehicle)
    vehicle:setColor(0, 0, 0)
    vehicle:setGeneralPartCondition(100, 100)
    local key = vehicle:createVehicleKey()
    vehicle:putKeyInIgnition(key, 1)

    for i = 1, 21 do
        md.BWO.parts[i] = 100
    end

    for i = 1, 10 do
        local partRandom = 1 + ZombRand(21)
        local vehiclePart = vehicle:getPartById(BWOVehicles.parts[partRandom])
        if vehiclePart then
            local cond = 20 + ZombRand(40)
            vehiclePart:setCondition(cond)
            md.BWO.parts[partRandom] = cond
        end
    end

end

function BWOEventsPlace.Emitter(params)
    local effect = {}
    effect.x = params.x
    effect.y = params.y
    effect.z = params.z
    effect.len = params.len --2460
    effect.sound = params.sound -- "ZSBuildingBaseAlert"
    effect.light = params.light -- {r=1, g=0, b=0, t=10}
    BWOEmitter.Add(effect)
end

function BWOEventsPlace.AbandonedVehicle(params)
    local vtype = BanditUtils.Choice(BWOVehicles.carChoices)
    spawnVehicle(params.x, params.y, params.dir, vtype)
end

function BWOEventsPlace.BuildingParty(params)
    BWOEvents.BuildingParty(params)
end