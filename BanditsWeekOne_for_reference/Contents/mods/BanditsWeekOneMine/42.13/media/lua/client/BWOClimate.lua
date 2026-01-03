-- Nuclear Winter Climate Simulation
-- Simulates temperature drops and radioactive fallout using snow visual effects

-- Fallout configuration constants
local FALLOUT_START = 170     -- WorldAge when fallout begins
local FALLOUT_END = 2130      -- WorldAge when fallout ends
local TEMP_LERP = 60          -- Maximum temperature drop
local TEMP_STEP = 0.5         -- Rate of temperature change per day

function onClimateTick()
    local world = getWorld()
    local cm = world:getClimateManager()
    local temp = cm:getClimateFloat(4)  -- Temperature controller
    local snow = cm:getClimateBool(0)   -- Snow visibility controller (used as fallout)

    if not temp or not snow then return end

    -- Reset to default climate behavior
    temp:setEnableOverride(false)
    snow:setEnableOverride(false)

    if not BWOScheduler.World.PostNuclearFallout then return end

    local gmd = GetBWOModData()
    local hasNukes = false
    for _, _ in pairs(gmd.Nukes) do
        hasNukes = true
        break
    end
    if not hasNukes then return end

    local wa = BWOScheduler.WorldAge
    local overrideTemp

    -- Determine temperature override based on world age
    if wa < FALLOUT_START or wa > FALLOUT_END then
        overrideTemp = 0
    elseif wa < FALLOUT_START + (TEMP_LERP / TEMP_STEP) then
        overrideTemp = (FALLOUT_START - wa) * TEMP_STEP
    elseif wa > FALLOUT_END - (TEMP_LERP / TEMP_STEP) then
        overrideTemp = (wa - FALLOUT_END) * TEMP_STEP
    else
        overrideTemp = -TEMP_LERP
    end

    if overrideTemp == 0 then
        return  -- No override needed
    end

    -- Apply nuclear winter temperature offset
    local internalTemp = temp:getInternalValue()
    local newTemp = internalTemp + overrideTemp
    temp:setEnableOverride(true)
    temp:setOverride(newTemp, 1)

    -- Show fallout dust (using snow effect)
    if wa < 190 or newTemp < 0 then
        snow:setEnableOverride(true)
        snow:setOverride(true)
    end
end

Events.OnClimateTick.Add(onClimateTick)
