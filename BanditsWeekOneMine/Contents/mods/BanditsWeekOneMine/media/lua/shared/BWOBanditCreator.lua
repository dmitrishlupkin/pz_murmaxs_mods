BanditCreator = BanditCreator or {}

function BanditCreator.MakeFromRoom(room)

    local building = room:getBuilding()
    local buildingDef = building:getDef()
    local keyId = buildingDef:getKeyId()

    local roomData = BWORooms.Get(room)
    if not roomData then return end

    local bandit = {}
    
    -- this always generates bandits of clan 0 - citizens
    local clan = BanditCreator.GroupMap[0]

    -- properties to be rewritten from clan file to bandit instance
    bandit.clan = clan.id
    bandit.health = clan.health
    bandit.eatBody = clan.eatBody
    bandit.accuracyBoost = clan.accuracyBoost

    -- default weapon config
    config = {}
    config.hasRifleChance = 0
    config.hasPistolChance = SandboxVars.BanditsWeekOne.InhabitantsPistolChance
    config.rifleMagCount = 0
    config.pistolMagCount = 3
    config.clanId = 0

    if BWOScheduler.SymptomLevel >= 3 then
        config.hasRifleChance = 5
        config.hasPistolChance = 40
        config.rifleMagCount = 2
        config.pistolMagCount = 3
    end

    bandit.femaleChance = clan.femaleChance
    if roomData.femaleChance then
        bandit.femaleChance = roomData.femaleChance
    end

    bandit.outfit = BanditUtils.Choice(clan.Outfits)
    if roomData.outfits then
        bandit.outfit = BanditUtils.Choice(roomData.outfits)

        if bandit.outfit == "MallSecurity" or bandit.outfit == "Security" then
            config.hasPistolChance = 100
            config.pistolMagCount = 2
            bandit.femaleChance = 0
        elseif bandit.outfit == "OfficeWorkerSkirt" then
            bandit.femaleChance = 100
        end
    end

    if roomData.hasPistolChance and roomData.pistolMagCount then
        config.hasPistolChance = roomData.hasPistolChance
        config.pistolMagCount = roomData.pistolMagCount
    end
    if roomData.hasRifleChance and roomData.rifleMagCount then
        config.hasRifleChance = roomData.hasRifleChance
        config.rifleMagCount = roomData.rifleMagCount
    end
    bandit.weapons = BanditCreator.MakeWeapons(config, clan)

    bandit.weapons.melee = "Base.BareHands" -- BanditUtils.Choice(clan.Melee)
    if roomData.melee then
        bandit.weapons.melee = BanditUtils.Choice(roomData.melee)
    end

    if clan.hairStyles then
        bandit.hairStyle = BanditUtils.Choice(clan.hairStyles)
    end

    if roomData.hairStyles then
        bandit.hairStyle = BanditUtils.Choice(roomData.hairStyles)
    end

    bandit.loot = BanditCreator.MakeLoot(clan.Loot)

    if not roomData.isShop and not roomData.isRestaurant then
        bandit.key = keyId
    end

    return bandit
end

function BanditCreator.MakeFromZombieZone(name)
    local defs = ZombiesZoneDefinition[name]
    if not defs then return end

    local selected
    local sum = 0
    for k, v in pairs(defs) do
        if v.chance then
            sum = sum + v.chance
        end
    end

    local r = 1 + ZombRand(sum)

    local csum = 0
    for k, v in pairs(defs) do
        if v.chance then
            csum = csum + v.chance
            if r <= csum then
                selected = k
                break
            end
        end
    end

    -- default config
    local bandit = {}
    
    -- this always generates bandits of clan 0 - citizens
    local clan = BanditCreator.GroupMap[0]

    -- properties to be rewritten from clan file to bandit instance
    bandit.clan = clan.id
    bandit.health = clan.health
    bandit.eatBody = clan.eatBody
    bandit.accuracyBoost = clan.accuracyBoost

    config = {}
    config.hasRifleChance = 0
    config.hasPistolChance = SandboxVars.BanditsWeekOne.InhabitantsPistolChance
    config.rifleMagCount = 0
    config.pistolMagCount = 3
    config.clanId = 0

    if selected then
        local def = defs[selected]
        if def.name then
            bandit.outfit = def.name
        end

        if def.gender then
            if def.gender == "male" then
                bandit.femaleChance = 0
            elseif def.gender == "female" then
                bandit.femaleChance = 100
            end
        end

        if name == "Army" then
            config.hasRifleChance = 80
            config.hasPistolChance = 100
            config.rifleMagCount = 2 + ZombRand(4)
            config.pistolMagCount = 2 + ZombRand(3)
            bandit.hairStyle = BanditUtils.Choice({"Bald", "Fresh", "Demi", "FlatTop", "MohawkShort"})
            bandit.accuracyBoost = 1.6
        end
    end

    bandit.weapons = BanditCreator.MakeWeapons(config, clan)
    bandit.weapons.melee = "Base.BareHands"

    bandit.loot = BanditCreator.MakeLoot(clan.Loot)

    return bandit
end
