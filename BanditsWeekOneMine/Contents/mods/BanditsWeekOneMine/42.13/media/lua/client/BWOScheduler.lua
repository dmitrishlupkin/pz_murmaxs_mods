BWOScheduler = BWOScheduler or {}

-- queue of evenst added from schedule to be processed
BWOScheduler.Events = {}

-- general symptoms level 0 - 4
BWOScheduler.SymptomLevel = 0

-- how old is the world
BWOScheduler.WorldAge = 0

-- flags tables
BWOScheduler.World = {}
BWOScheduler.NPC = {}
BWOScheduler.Anarchy = {}

-- world age time shift depending on sandbox start date
waShiftMap = {}
table.insert(waShiftMap, 0) -- week before
table.insert(waShiftMap, 168) -- 2 weeks before
table.insert(waShiftMap, 504) -- 4 weeks before
table.insert(waShiftMap, 1848) -- 12 weeks before
table.insert(waShiftMap, 8760) -- year before
table.insert(waShiftMap, 87432) -- 10 years before
BWOScheduler.waShiftMap = waShiftMap

-- schedule 
local generateSchedule = function()
    --[[
    local tab = {}
    for wa=-24, 400 do
        tab[wa] = {}
        for m=0, 59 do
            tab[wa][m] = {}
        end
    end
    ]]

    local gmd = GetBWOModData()
    local variant = gmd.Variant

    return BWOVariants[variant].schedule
end

function BWOScheduler.OverwriteSettings()
    getCore():setOptionUIRenderFPS(60)
    getCore():setOptionJumpScareVolume(0)
end

function BWOScheduler.PlayerStart()
    local gmd = GetBWOModData()
    local player = getSpecificPlayer(0)
    local hours = player:getHoursSurvived()
    
    if not gmd.Variant then 
        if SandboxVars.BanditsWeekOne.Variant then
            gmd.Variant = SandboxVars.BanditsWeekOne.Variant
        else
            gmd.Variant = "original"
        end
    end

    if hours < 0.1 then
        
        local conf = BWOVariants[gmd.Variant]

        local gt = getGameTime()
        if conf.timeOfDay then
            gt:setTimeOfDay(conf.timeOfDay)
        end

        if conf.timeOfWeek then
            gt:setDay(gt:getDay() + conf.timeOfWeek)
        end

        BWOScheduler.Add("FadeOut", {time=0}, 0)

        local setup = conf.setup
        if setup then
            setup()
            -- BWOScheduler.Add("VariantCall", {func="setup"}, 1)
        end

        local setup2 = conf.setup2
        if setup2 then
            BWOScheduler.Add("VariantCall", {func="setup2"}, 500)
        end
        
        BWOScheduler.Add("FadeIn", {time=4}, conf.fadeIn)
    end
end

function BWOScheduler.StoreSandboxVars()
    local gmd = GetBWOModData()
    local orig = gmd.Sandbox

    storeVars = {"KeyLootNew", "MaximumLooted", "FoodLootNew", "CannedFoodLootNew", "LiteratureLootNew", "SurvivalGearsLootNew",
                 "MedicalLootNew", "WeaponLootNew", "RangedWeaponLootNew", "AmmoLootNew", "MechanicsLootNew",
                 "OtherLootNew", "ClothingLootNew", "ContainerLootNew", "MementoLootNew", "MediaLootNew",
                 "CookwareLootNew", "MaterialLootNew", "FarmingLootNew", "ToolLootNew", "MaximumRatIndex",
                 "SurvivorHouseChance", "VehicleStoryChance", "MetaEvent", "LockedHouses", "ZoneStoryChance", "AnnotatedMapChance",
                 "MaxFogIntensity", "TrafficJam", "CarSpawnRate", "Helicopter", "FireSpread", "ZombieConfig.PopulationMultiplier"}

    for _, k in pairs(storeVars) do
        gmd.Sandbox[k] = gmd.Sandbox[k] or SandboxVars[k]
    end
end

function BWOScheduler.RestoreRepeatingPlaceEvents()

    local addPlaceEvent = function(args)
        BWOServer.Commands.PlaceEventAdd(getSpecificPlayer(0), args)
    end

    -- building emitters
    addPlaceEvent({phase="Emitter", x=13458, y=3043, z=0, len=110000, sound="ZSBuildingGigamart"}) -- gigamart lousville 
    addPlaceEvent({phase="Emitter", x=6505, y=5345, z=0, len=110000, sound="ZSBuildingGigamart"}) -- gigamart riverside
    addPlaceEvent({phase="Emitter", x=12024, y=6856, z=0, len=110000, sound="ZSBuildingGigamart"}) -- gigamart westpoint

    addPlaceEvent({phase="Emitter", x=6472, y=5266, z=0, len=42000, sound="ZSBuildingPharmabug"}) -- pharmabug riverside
    addPlaceEvent({phase="Emitter", x=13235, y=1284, z=0, len=42000, sound="ZSBuildingPharmabug"}) -- pharmabug lv
    addPlaceEvent({phase="Emitter", x=13120, y=2126, z=0, len=42000, sound="ZSBuildingPharmabug"}) -- pharmabug lv
    addPlaceEvent({phase="Emitter", x=11932, y=6804, z=0, len=42000, sound="ZSBuildingPharmabug"}) -- pharmabug westpoint

    addPlaceEvent({phase="Emitter", x=12228, y=3029, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=12998, y=3115, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=13065, y=1923, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=12660, y=1366, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=13523, y=1670, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=12520, y=1482, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=12646, y=2290, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=10604, y=9612, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market muldraugh
    addPlaceEvent({phase="Emitter", x=8088, y=11560, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market rosewood
    addPlaceEvent({phase="Emitter", x=13656, y=5764, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market valley station
    addPlaceEvent({phase="Emitter", x=11660, y=7067, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market west point

    addPlaceEvent({phase="Emitter", x=10619, y=10527, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant muldraugh
    addPlaceEvent({phase="Emitter", x=10605, y=10112, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- pizza whirled muldraugh
    addPlaceEvent({phase="Emitter", x=10647, y=9927, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- cafeteria muldraugh
    addPlaceEvent({phase="Emitter", x=10615, y=9646, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- spiffos muldraugh
    addPlaceEvent({phase="Emitter", x=10616, y=9565, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- jays muldraugh
    addPlaceEvent({phase="Emitter", x=10620, y=9513, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- pileocrepe muldraugh
    addPlaceEvent({phase="Emitter", x=12078, y=7076, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- burgers westpoint
    addPlaceEvent({phase="Emitter", x=11976, y=6812, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- spiffos westpoint
    addPlaceEvent({phase="Emitter", x=11930, y=6917, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant westpoint
    addPlaceEvent({phase="Emitter", x=11663, y=7085, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- pizza whirled westpoint
    addPlaceEvent({phase="Emitter", x=6395, y=5303, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant riverside
    addPlaceEvent({phase="Emitter", x=6189, y=5338, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- fancy restaurant riverside
    addPlaceEvent({phase="Emitter", x=6121, y=5303, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- spiffos riverside
    addPlaceEvent({phase="Emitter", x=5422, y=5914, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- diner riverside
    addPlaceEvent({phase="Emitter", x=7232, y=8202, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- burger joint doe valley
    addPlaceEvent({phase="Emitter", x=10103, y=12749, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant march ridge 
    addPlaceEvent({phase="Emitter", x=8076, y=11455, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant rosewood
    addPlaceEvent({phase="Emitter", x=8072, y=11344, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- spiffos rosewood

    -- LV strip club
    addPlaceEvent({phase="BuildingParty", x=12320, y=1279, z=0, intensity=10, roomName="stripclub"})

    -- alarm emitters (only if nukes are active)
    local gmd = GetBWOModData()
    local ncnt = 0
    for _, nuke in pairs(gmd.Nukes) do
        ncnt = ncnt + 1
    end

    if ncnt > 0 then
        addPlaceEvent({phase="Emitter", x=5572, y=12489, z=0, len=2460, sound="ZSBuildingBaseAlert", light={r=1, g=0, b=0, t=10}}) -- fake control room
        addPlaceEvent({phase="Emitter", x=5575, y=12473, z=0, len=2460, sound="ZSBuildingBaseAlert", light={r=1, g=0, b=0, t=10}}) -- entrance
        addPlaceEvent({phase="Emitter", x=5562, y=12464, z=0, len=2460, sound="ZSBuildingBaseAlert", light={r=1, g=0, b=0, t=10}}) -- back

        if BanditCompatibility.GetGameVersion() >= 42 then
            addPlaceEvent({phase="Emitter", x=5556, y=12446, z=-16, len=2460, sound="ZSBuildingBaseAlert", light={r=1, g=0, b=0, t=10}}) -- real control room
        end
    end
end

function BWOScheduler.MasterControl()

    local function daysInMonth(month)
        local daysPerMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
        return daysPerMonth[month]
    end
    
    local function calculateHourDifference(startHour, startDay, startMonth, startYear, hour, day, month, year)
        local startTotalHours = startHour + (startDay - 1) * 24
        for m = 1, startMonth - 1 do
            startTotalHours = startTotalHours + daysInMonth(m) * 24
        end
        startTotalHours = startTotalHours + (startYear * 365 * 24) 
    
        local totalHours = hour + (day - 1) * 24
        for m = 1, month - 1 do
            totalHours = totalHours + daysInMonth(m) * 24
        end
        totalHours = totalHours + (year * 365 * 24) 
    
        return totalHours - startTotalHours
    end

    local function adjustSandboxVar(k, v)

        -- b41
        -- Sandbox_Rarity_option1 = "None (not recommended)",
        -- Sandbox_Rarity_option2 = "Insanely Rare",
        -- Sandbox_Rarity_option3 = "Extremely Rare",
        -- Sandbox_Rarity_option4 = "Rare",
        -- Sandbox_Rarity_option5 = "Normal",
        -- Sandbox_Rarity_option6 = "Common",
        -- Sandbox_Rarity_option7 = "Abundant",


        getSandboxOptions():set(k, v)
        SandboxVars[k] = v
    end

    local function adjustSandboxVars()
        local gmd = GetBWOModData()
        local orig = gmd.Sandbox
        adjustSandboxVar("DamageToPlayerFromHitByACar", 3)
        if BWOScheduler.WorldAge <= 64 then
            adjustSandboxVar("SurvivorHouseChance", 1)
            adjustSandboxVar("VehicleStoryChance", 1)
            adjustSandboxVar("MetaEvent", 1)
            adjustSandboxVar("LockedHouses", 1)
            adjustSandboxVar("ZoneStoryChance", 1)
            adjustSandboxVar("AnnotatedMapChance", 1)
            adjustSandboxVar("MaxFogIntensity", 4)
            adjustSandboxVar("TrafficJam", false)
            adjustSandboxVar("CarSpawnRate", 5)
            adjustSandboxVar("Helicopter", 1)
            adjustSandboxVar("FireSpread", false)
            
            
            
            -- lerp
            if BanditCompatibility.GetGameVersion() >= 42 then
                local vars = BWOCompatibility.GetSandboxOptionVars()
                local t = BWOScheduler.WorldAge / 64
                for _, var in pairs(vars) do
                    local val = (var[3] - var[2]) * t + var[2]
                    adjustSandboxVar(var[1], val)
                end
            end
        else
            adjustSandboxVar("SurvivorHouseChance", gmd.Sandbox["SurvivorHouseChance"])
            adjustSandboxVar("VehicleStoryChance", gmd.Sandbox["VehicleStoryChance"])
            adjustSandboxVar("MetaEvent", gmd.Sandbox["MetaEvent"])
            adjustSandboxVar("LockedHouses", gmd.Sandbox["LockedHouses"])
            adjustSandboxVar("ZoneStoryChance", gmd.Sandbox["ZoneStoryChance"])
            adjustSandboxVar("AnnotatedMapChance", gmd.Sandbox["AnnotatedMapChance"])
            adjustSandboxVar("MaxFogIntensity", gmd.Sandbox["MaxFogIntensity"])
            adjustSandboxVar("TrafficJam", gmd.Sandbox["TrafficJam"])
            adjustSandboxVar("CarSpawnRate", gmd.Sandbox["CarSpawnRate"])
            adjustSandboxVar("Helicopter", gmd.Sandbox["Helicopter"])
            adjustSandboxVar("FireSpread", gmd.Sandbox["FireSpread"])
            
        end

        --[[
        if BWOScheduler.WorldAge < 132 then
            adjustSandboxVar("ZombieConfig.PopulationMultiplier", 0)
            adjustSandboxVar("ZombieConfig.PopulationStartMultiplier", 0)
        elseif BWOScheduler.WorldAge == 132 then
            adjustSandboxVar("ZombieConfig.PopulationMultiplier", 0.15)
            adjustSandboxVar("ZombieConfig.PopulationStartMultiplier", 0.5)
        elseif BWOScheduler.WorldAge < 168 then
            adjustSandboxVar("ZombieConfig.PopulationMultiplier", 1.5)
            adjustSandboxVar("ZombieConfig.PopulationStartMultiplier", 1.5)
        else
            local r1 = gmd.Sandbox["ZombieConfig.PopulationMultiplier"] and gmd.Sandbox["ZombieConfig.PopulationMultiplier"] or 0.75
            adjustSandboxVar("ZombieConfig.PopulationMultiplier", r1)

            local r2 = gmd.Sandbox["ZombieConfig.PopulationStartMultiplier"] and gmd.Sandbox["ZombieConfig.PopulationMultiplier"] or 1
            adjustSandboxVar("ZombieConfig.PopulationStartMultiplier", r2)
        end]]
        
        getSandboxOptions():applySettings()
        --IsoWorld.parseDistributions()
        ItemPickerJava.InitSandboxLootSettings()
    end

    local player = getSpecificPlayer(0)
    if not player then return end

    local gametime = getGameTime()
    -- local ts = getTimestampMs()

    local startHour = gametime:getStartTimeOfDay()
    local startDay = gametime:getStartDay()
    local startMonth = gametime:getStartMonth()
    local startYear = gametime:getStartYear()

    local hour = gametime:getHour()
    local day = gametime:getDay()
    local minute = gametime:getMinutes()
    local month = gametime:getMonth()
    local year = gametime:getYear()

    -- worldAge is counter in hours
    local worldAge = calculateHourDifference(startHour, startDay, startMonth, startYear, hour, day, month, year)

    if not BWOScheduler.Schedule then
        BWOScheduler.Schedule = generateSchedule()
    end

    -- adjust worldage depending on the start time
    local waShiftMap = BWOScheduler.waShiftMap
    local startTimeOption = SandboxVars.BanditsWeekOne.StartTime
    local waShift = waShiftMap[startTimeOption]
    if waShift then
        worldAge = worldAge - waShift
    end 

    -- debug to jump to a certain hour
    -- worldAge = 136

    BWOScheduler.WorldAge = worldAge
    
    adjustSandboxVars()
    
    -- set flags based on world age that control various aspects of the game

    -- world flags
    BWOScheduler.World = {}

    -- removes objects that conflict stylistically with prepandemic world
    
    BWOScheduler.World.ObjectRemover = false
    if BWOScheduler.WorldAge <= 64 then 
        BWOScheduler.World.ObjectRemover = true
    end

    -- removed initial deadbodies
    BWOScheduler.World.DeadBodyRemover = false
    if BWOScheduler.WorldAge < 48 then BWOScheduler.World.DeadBodyRemover = true end

    -- registers certain exterior objects positions that npcs can interacts with
    BWOScheduler.World.GlobalObjectAdder = false
    if BWOScheduler.WorldAge < 90 then BWOScheduler.World.GlobalObjectAdder = true end

    -- adds human corpses to simulate struggles outside of player cell
    BWOScheduler.World.DeadBodyAdderDensity = 0
    if BWOScheduler.WorldAge > 2330 then
        BWOScheduler.World.DeadBodyAdderDensity = 0
    elseif BWOScheduler.WorldAge >= 1200 then
        BWOScheduler.World.DeadBodyAdderDensity = 0.01
    elseif BWOScheduler.WorldAge >= 170 then
        BWOScheduler.World.DeadBodyAdderDensity = 0.019
    elseif BWOScheduler.WorldAge >= 150 then
        BWOScheduler.World.DeadBodyAdderDensity = 0.016
    elseif BWOScheduler.WorldAge >= 130 then
        BWOScheduler.World.DeadBodyAdderDensity = 0.012
    elseif BWOScheduler.WorldAge >= 110 then
        BWOScheduler.World.DeadBodyAdderDensity = 0.004
    end

    -- meta gunfight
    if (BWOScheduler.WorldAge >= 135 and BWOScheduler.WorldAge < 138) or (BWOScheduler.WorldAge >= 146 and BWOScheduler.WorldAge < 169) then
        for i=1, ZombRand(4) do
            BWOScheduler.Add("MetaSound", {}, i * 100)
        end
    end

    BWOScheduler.World.Bombing = 0

    -- transforms the world appearance to simulate post-nuclear strike
    BWOScheduler.World.PostNuclearTransformator = false
    if SandboxVars.BanditsWeekOne.EventFinalSolution and BWOScheduler.WorldAge >= 169 and BWOScheduler.WorldAge < 2330 then BWOScheduler.World.PostNuclearTransformator = true end

    -- makes the player sick and drunk after nuclear explosions
    BWOScheduler.World.PostNuclearFallout = false
    if SandboxVars.BanditsWeekOne.EventFinalSolution and BWOScheduler.WorldAge >= 171 and BWOScheduler.WorldAge < 2330 then 
        BWOScheduler.World.PostNuclearFallout = true 
        if getWorld():isHydroPowerOn() then
            getWorld():setHydroPowerOn(false)
        end
    end
    
    -- either fixes the car or removes burned or smashed cars for prepademic world
    BWOScheduler.World.VehicleFixer = false
    if BWOScheduler.WorldAge < 90 then BWOScheduler.World.VehicleFixer = true end

    -- npc logic flags
    BWOScheduler.NPC = {}

    -- controls if npcs will react to protests events
    BWOScheduler.NPC.ReactProtests = false
    if BWOScheduler.WorldAge < 129 then BWOScheduler.NPC.ReactProtests = true end

    -- controls if npcs will react to protests events
    BWOScheduler.NPC.ReactDeadBody = false
    if BWOScheduler.WorldAge < 78 then BWOScheduler.NPC.ReactDeadBody = true end

    -- controls if npcs will react to street preachers
    BWOScheduler.NPC.ReactPreacher = false
    if BWOScheduler.WorldAge < 71 then BWOScheduler.NPC.ReactPreacher = true end

    -- controls if npcs will react to street entertainers
    BWOScheduler.NPC.ReactEntertainers = false
    if BWOScheduler.WorldAge < 65 then BWOScheduler.NPC.ReactEntertainers = true end

    -- controls if npcs will sit on exterior benches
    BWOScheduler.NPC.SitBench = false
    if BWOScheduler.WorldAge < 65 then BWOScheduler.NPC.SitBench = true end

    -- controls the period in which npc will run the atms
    BWOScheduler.NPC.BankRun = false
    if BWOScheduler.WorldAge > 67 and BWOScheduler.WorldAge < 87 then BWOScheduler.NPC.BankRun = true end

    -- controls if npcs will sit on exterior benches
    BWOScheduler.NPC.Talk = false
    if BWOScheduler.WorldAge < 58 then BWOScheduler.NPC.Talk = true end

    -- controls when npc start running instead of walking by default, also cars not stopping
    BWOScheduler.NPC.Run = false
    if BWOScheduler.WorldAge > 90 then BWOScheduler.NPC.Run = true end

    -- controls when npcbarricade their homes
    BWOScheduler.NPC.Barricade = false
    if BWOScheduler.WorldAge > 72 then BWOScheduler.NPC.Barricade = true end

    -- controls functionalities that diminish during the anarchy
    BWOScheduler.Anarchy = {}

    -- if buildings emit sounds like if they are operational (church / school)
    BWOScheduler.Anarchy.BuildingOperational = true
    if BWOScheduler.WorldAge > 72 then BWOScheduler.Anarchy.BuildingOperational = false end

    -- controls if buying and earning is still possible
    BWOScheduler.Anarchy.Transactions = true
    if BWOScheduler.WorldAge > 80 then BWOScheduler.Anarchy.Transactions = false end
    
    -- controls minor crime has consequences (breaking windows)
    BWOScheduler.Anarchy.IllegalMinorCrime = true
    if BWOScheduler.WorldAge > 110 then BWOScheduler.Anarchy.IllegalMinorCrime = false end

    -- building emmiters
    if BWOScheduler.Anarchy.BuildingOperational then

        -- church
        if hour >=6 and hour < 19 then
            if minute == 0 then
                local church = BWOBuildings.FindBuildingWithRoom("church")
                if church then
                    local def = church:getDef()
                    local x = (def:getX() + def:getX2()) / 2
                    local y = (def:getY() + def:getY2()) / 2
                    local emitter = getWorld():getFreeEmitter(x, y, 0)
                    emitter:setVolumeAll(0.5)
                    emitter:tick()
                    emitter:playSound("ZSBuildingChurch")
                end
            end
        end

        -- school
        if hour >=8 and hour < 17 then
            if minute == 10 or minute == 45 then
                local school = BWOBuildings.FindBuildingWithRoom("education")
                if school then
                    local def = school:getDef()
                    local emitter = getWorld():getFreeEmitter((def:getX() + def:getX2()) / 2, (def:getY() + def:getY2()) / 2, 0)
                    emitter:setVolumeAll(0.8)
                    emitter:tick()
                    emitter:playSound("ZSBuildingSchool")
                end
            end
        end
    end

    -- general sickness control
    if worldAge < 34 then 
        BWOScheduler.SymptomLevel = 0
    elseif worldAge < 60 then
        BWOScheduler.SymptomLevel = 1
    elseif worldAge < 100 then
        BWOScheduler.SymptomLevel = 2
    elseif worldAge < 132 then
        BWOScheduler.SymptomLevel = 3
    elseif worldAge == 132 then
        BWOScheduler.SymptomLevel = 4
    else    
        BWOScheduler.SymptomLevel = 5
    end

    -- general services control
    BWOPopControl.Police.On = false
    BWOPopControl.SWAT.On = false
    BWOPopControl.Security.On = false
    BWOPopControl.Medics.On = false
    BWOPopControl.Hazmats.On = false
    BWOPopControl.Fireman.On = false

    if worldAge < 90 then
        BWOPopControl.Medics.On = true
    end

    if worldAge < 120 then
        BWOPopControl.Hazmats.On = true
    end

    if worldAge < 110 then
        BWOPopControl.Police.On = true
        BWOPopControl.SWAT.On = true
        BWOPopControl.Security.On = true
        BWOPopControl.Fireman.On = true
    end

    -- schedule processing
    -- basic parameters for all events, will be enriched by event specific params
    local params ={}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()

    local test = BWOScheduler.Schedule

    if worldAge < 400 then
        if BWOScheduler.Schedule[worldAge] then
            local event = BWOScheduler.Schedule[worldAge][minute]
            if event and event[1] and event[2] then
                local eventName = event[1]
                local eventParams = event[2]
                for k, v in pairs(eventParams) do
                    params[k] = v
                end
                BWOScheduler.Add(eventName, params, 100)
            end
        end
    end
end

function BWOScheduler.Add(eventName, params, delay)
    event = {}
    event.start = BanditUtils.GetTime() + delay
    event.phase = eventName
    event.params = params
    table.insert(BWOScheduler.Events, event)
end

-- event processor
function BWOScheduler.CheckEvents()
    local player = getSpecificPlayer(0)
    if not player then return end

    local ct = BanditUtils.GetTime()
    for i, event in pairs(BWOScheduler.Events) do
        if event.start < ct then
            if BWOEvents[event.phase] then
                local profession = player:getDescriptor():getCharacterProfession()
                if not event.params.profession or event.params.profession == profession then
                    -- print ("INIT EVENT" .. event.phase)
                    setGameSpeed(1)
                    BWOEvents[event.phase](event.params)
                end
            end
            table.remove(BWOScheduler.Events, i)
            break
        end
    end
end

Events.OnTick.Add(BWOScheduler.CheckEvents)
Events.EveryOneMinute.Add(BWOScheduler.MasterControl)
Events.OnGameStart.Add(BWOScheduler.StoreSandboxVars)
Events.OnGameStart.Add(BWOScheduler.RestoreRepeatingPlaceEvents)
Events.OnGameStart.Add(BWOScheduler.OverwriteSettings)
Events.OnGameStart.Add(BWOScheduler.PlayerStart)
