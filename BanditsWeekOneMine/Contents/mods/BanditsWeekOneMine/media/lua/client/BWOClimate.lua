function onClimateTick()
    local world = getWorld()
    local cm = world:getClimateManager()
    local temp = cm:getClimateFloat(4)
    local snow = cm:getClimateBool(0)

    temp:setEnableOverride(false)
    snow:setEnableOverride(false)

    if not BWOScheduler.World.PostNuclearFallout then return end

    local gmd = GetBWOModData()
    local ncnt = 0
    for _, nuke in pairs(gmd.Nukes) do
        ncnt = ncnt + 1
    end
    if ncnt == 0 then return end

    local wa = BWOScheduler.WorldAge
    local start = 170
    local ending = 2130
    local lerp = 60
    local step = 0.5

    local override
    if wa < start or wa > ending then
        override = 0
    elseif wa < start + (lerp / step)   then
        override = (start - wa) * step
    elseif wa > ending - (lerp / step)  then
        override = (wa - ending) * step
    else
        override = -lerp
    end

    if override == 0 then
        temp:setEnableOverride(false)
        snow:setEnableOverride(false)
    else
        local internalTemp = temp:getInternalValue()
        local newTemp = internalTemp + override
        temp:setEnableOverride(true)
        temp:setOverride(newTemp, 1)

        if wa < 190 or newTemp < 0 then -- should snow at wa=228
            snow:setEnableOverride(true)
            snow:setOverride(true)
        end
    end
end

Events.OnClimateTick.Add(onClimateTick)