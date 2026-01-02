if isClient() then return end

SurvivorSwap = {
    --- if non empty, shown in world context menus [Debug] > Survivor Swap > Survivors
    Survivors = {},
    --- if non empty, shown in world context menus [Debug] > Survivor Swap > Inventory
    Loadouts = {},
    --- not used currently
    Vehicles = {},
}

SurvivorSwap.applyCharacter = function(playerObj, data)
    local desc = playerObj:getDescriptor()
    local visual = playerObj:getHumanVisual()
    local traits = playerObj:getCharacterTraits():getKnownTraits()
    desc:setForename(data.forename or desc:getForename())
    desc:setSurname(data.surname or desc:getSurname())
    desc:setCharacterProfession(data.profession or desc:getCharacterProfession())
    traits:clear()
    for _, trait in ipairs(data.traits or {}) do
        traits:add(trait)
    end
    if data.perks then
        for i=1,Perks.getMaxIndex() do
            local perk = PerkFactory.getPerk(Perks.fromIndex(i - 1));
            if perk and perk:getParent() ~= Perks.None then
                local default = 0;
                if perk == Perks.Strength or perk == Perks.Fitness then default = 5 end
                playerObj:setPerkLevelDebug(perk, data.perks[perk] or default)
            end
        end
    end
    
    playerObj:getNutrition():setWeight(data.weight or 80)
    playerObj:setFemale(data.female or false)
    desc:setFemale(data.female or false)
    desc:setVoicePrefix(data.female and "VoiceFemale" or "VoiceMale")
    desc:setVoiceType(data.voiceType or 0)
    desc:setVoicePitch(data.voicePitch or 0)

    -- set the look
    local immutableColor = ImmutableColor.new(unpack(data.hairColor or {0.2, 0.2, 0.2, 1}))
    visual:setHairColor(immutableColor)
    visual:setBeardColor(immutableColor)
    visual:setSkinTextureIndex(data.skinTexture or 1)
    visual:setBeardModel(data.beard or "")
    visual:setHairModel(data.hair or "")
    playerObj:resetModel()
    if playerObj:getPlayerNum() then
        getPlayerInfoPanel(playerObj:getPlayerNum()).charScreen.refreshNeeded = true
    end
end

SurvivorSwap.applyLoadout = function(playerObj, data)
    playerObj:clearWornItems()
    playerObj:setPrimaryHandItem(nil)
    playerObj:setSecondaryHandItem(nil)
    local inv = playerObj:getInventory()
    inv:clear()
    if playerObj:getPlayerNum() then
        getPlayerHotbar(playerObj:getPlayerNum()):update()
    end
    for _, value in pairs(data.worn or {}) do
        local item = inv:AddItem(value)
        playerObj:setWornItem(item:getBodyLocation(), item)
    end
    for _, value in pairs(data.inventory or {}) do
        inv:AddItem(value)
    end
    if data.setup then
        data.setup(playerObj, inv)
    end
    inv:setDrawDirty(true) -- dont forget this when messing with inventory
    playerObj:resetModel()
    if playerObj:getPlayerNum() then
        getPlayerHotbar(playerObj:getPlayerNum()):update()
    end
end

SurvivorSwap.applyVehicle = function(vehicle, data)
    vehicle:setScriptName(data.script)
    vehicle:setScript()
    vehicle:setColorHSV(unpack(data.color))
    for part, replacement in pairs(data.parts) do
        vehicle:getPartById(part):setInventoryItem(instanceItem(replacement))
    end
    vehicle:repair()

    for part, setup in pairs(data.containers) do
        local container = vehicle:getPartById(part):getItemContainer()
        container:clear()
        setup(container)
    end
    vehicle:addKeyToGloveBox()
end
