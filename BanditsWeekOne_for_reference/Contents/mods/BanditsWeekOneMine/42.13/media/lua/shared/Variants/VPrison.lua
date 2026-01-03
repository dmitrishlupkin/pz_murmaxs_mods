require "BWOBandit"

BWOVariants = BWOVariants or {}

local prison = {}
prison.name = "The Convict"
prison.image = "media/textures/Variants/prison.png"
prison.desc = "<SIZE:large> The Convict <BR> "
prison.desc = prison.desc .. "<SIZE:medium> Difficulty: Insane <BR> "
prison.desc = prison.desc .. "<SIZE:medium>Five days since the first reports, and the walls still hold barely. "
prison.desc = prison.desc .. "You sit behind bars in Rosewood Prison, where the screams are starting to sound different. "
prison.desc = prison.desc .. "The other inmates are growing restless, shouting through the bars, sensing that something is about to break. "
prison.desc = prison.desc .. "You know what's coming, and this cell is about to become your tomb, unless you find a way out. <BR> "
prison.desc = prison.desc .. " - Begin as a prison inside Rosewood Prison on the fifth day of the outbreak. \n"
prison.desc = prison.desc .. " - Your clothing and equipment is forcefully adjusted. \n"
prison.desc = prison.desc .. " - Everything spirals fast after the game starts. \n "

prison.timeOfWeek = 5
prison.timeOfDay = 21.75

prison.fadeIn = 3500

prison.setup = function()
    local player = getSpecificPlayer(0)
    if not player then return end

    local sx, sy, sz = 7695, 11830, 1
    player:setX(sx)
    player:setY(sy)
    player:setZ(sz)
    player:setLastX(sx)
    player:setLastY(sy)
    player:setLastZ(sz)

    local suit = BanditCompatibility.InstanceItem("Base.Boilersuit_Prisoner")
    local suitLocation = suit:getBodyLocation()
    local inv = player:getInventory()
    local wornItems = player:getWornItems()
    inv:clear()
    wornItems:clear()
    inv:AddItem(suit)
    wornItems:setItem(suitLocation, suit)
    player:setWornItems(wornItems)

    local pipe = BanditCompatibility.InstanceItem("Base.MetalBar")
    player:getInventory():AddItem(pipe)
    player:setPrimaryHandItem(pipe)

    getWorld():update()

    local spawnList = {
        {x = 7679, y=11818, z=0, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11821, z=0, size=2, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11827, z=0, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11833, z=0, size=2, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11839, z=0, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11845, z=0, size=2, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11848, z=0, size=1, program="Companion", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11851, z=0, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},

        {x = 7679, y=11818, z=1, size=2, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11824, z=1, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11833, z=1, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11836, z=1, size=2, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11842, z=1, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11845, z=1, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11848, z=1, size=2, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11851, z=1, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7679, y=11854, z=1, size=2, program="BanditSimple", cid=Bandit.clanMap.Inmate},

        {x = 7695, y=11818, z=0, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11821, z=0, size=1, program="Companion", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11836, z=0, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11839, z=0, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11842, z=0, size=2, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11845, z=0, size=2, program="Companion", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11848, z=0, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11851, z=0, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11854, z=0, size=1, program="Companion", cid=Bandit.clanMap.Inmate},

        -- {x = 7695, y=11830, z=1, size=1, program="Babe", loyal=true, cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11833, z=1, size=2, program="Companion", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11836, z=1, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11839, z=1, size=2, program="Companion", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11842, z=1, size=1, program="Companion", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11845, z=1, size=2, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11848, z=1, size=1, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11851, z=1, size=2, program="BanditSimple", cid=Bandit.clanMap.Inmate},
        {x = 7695, y=11854, z=1, size=2, program="BanditSimple", cid=Bandit.clanMap.Inmate},
    }

    local hordeList = {
        {x = 7679, y=11818, z=0, size=1, outfit="Inmate", femaleChance=0},
        {x = 7679, y=11824, z=0, size=2, outfit="Inmate", femaleChance=0},
        {x = 7679, y=11827, z=0, size=1, outfit="Inmate", femaleChance=0},
        {x = 7679, y=11830, z=0, size=1, outfit="Inmate", femaleChance=0},
        {x = 7679, y=11842, z=0, size=1, outfit="Inmate", femaleChance=0},
        {x = 7679, y=11848, z=0, size=1, outfit="Inmate", femaleChance=0},
        {x = 7679, y=11854, z=0, size=2, outfit="Inmate", femaleChance=0},

        {x = 7679, y=11821, z=1, size=1, outfit="Inmate", femaleChance=0},
        {x = 7679, y=11824, z=1, size=1, outfit="Inmate", femaleChance=0},
        {x = 7679, y=11839, z=1, size=1, outfit="Inmate", femaleChance=0},
        {x = 7679, y=11842, z=1, size=1, outfit="Inmate", femaleChance=0},
        {x = 7679, y=11845, z=1, size=1, outfit="Inmate", femaleChance=0},

        {x = 7695, y=11824, z=0, size=2, outfit="Inmate", femaleChance=0},
        {x = 7695, y=11827, z=0, size=1, outfit="Inmate", femaleChance=0},
        {x = 7695, y=11839, z=0, size=1, outfit="Inmate", femaleChance=0},
        {x = 7695, y=11851, z=0, size=1, outfit="Inmate", femaleChance=0},
        {x = 7695, y=11854, z=0, size=1, outfit="Inmate", femaleChance=0},

        {x = 7695, y=11818, z=1, size=2, outfit="Inmate", femaleChance=0},
        {x = 7695, y=11821, z=1, size=2, outfit="Inmate", femaleChance=0},
        {x = 7695, y=11824, z=1, size=2, outfit="Inmate", femaleChance=0},
        {x = 7695, y=11827, z=1, size=2, outfit="Inmate", femaleChance=0},
        {x = 7695, y=11842, z=1, size=1, outfit="Inmate", femaleChance=0},
    }

    local i = 3000

    BWOScheduler.Add("ClearZombies", {}, i)
    i = i + 1

    BWOScheduler.Add("ClearCorpse", {x1=7623, y1=11814, x2=7715, y2=11948, z1=0, z2=1}, i)
    i = i + 1

    BWOScheduler.Add("SpawnGroupArea", {x1=7638, y1=11859, x2=7712, y2=11906, z=0, cnt=34, program="BanditSimple", hostile=true, cid=Bandit.clanMap.PrisonGuard}, i)
    i = i + 1

    for _, spawnData in pairs(spawnList) do
        BWOScheduler.Add("SpawnGroupAt", spawnData, i)
        i = i + 1
    end

    --[[
    for _, hordeData in pairs(hordeList) do
        BWOScheduler.Add("HordeAt", hordeData, i)
        i = i + 1
    end]]


    -- fences removal improves pathfinding (tradeoff)
    i = i + 1
    BWOScheduler.Add("ClearObjects", {x=7669, y=11817, z=0}, i)
    i = i + 1
    BWOScheduler.Add("ClearObjects", {x=7707, y=11843, z=0}, i)
    i = i + 1
    BWOScheduler.Add("ClearObjects", {x=7705, y=11843, z=0}, i)
end

prison.schedule = {
    [132] = {
        [46]  = {"StartDay", {day="thursday"}},
        [47]  = {"Sound", {x=7687, y=11832, sound="BWOPrisonMegaphone1"}},
        [48] = {"SetupNukes", {}},
        [49] = {"SetupPlaceEvents", {}},
        [57]  = {"Sound", {x=7687, y=11832, sound="BWOPrisonMegaphone2"}},
    },
    [133] = {
        [3]  = {"Arson", {}},
        [4] = {"Sound", {x=7687, y=11832, sound="BWOPrisonMegaphone3"}},
        [5] = {"Siren", {}},
        [6] = {"Emitter", {x=7687, y=11832, z=0, len=2460, sound="BWOPrisonBuzz", light={r=1, g=0, b=0, t=10}}},
        [7] = {"Emitter", {x=7687, y=11852, z=0, len=2460, sound="BWOPrisonBuzz", light={r=1, g=0, b=0, t=10}}},
        [8] = {"SpawnGroupAt", {x = 7680, y=11857, z=0, size=8, program="BanditSimple", hostile=true, cid=Bandit.clanMap.PrisonGuard}},
        [9] = {"OpenDoors", {x1=7684, y1=11818, z1=0, x2=7693, y2=11857, z2=1}},
        [10] = {"OpenDoors", {x1=7676, y1=11856, z1=0, x2=7680, y2=11859, z2=0}},
        [11] = {"SpawnGroupAt", {x = 7686, y=11857, z=0, size=5, program="BanditSimple", hostile=true, cid=Bandit.clanMap.PrisonGuard}},
        [12] = {"SpawnGroupAt", {x = 7672, y=11857, z=0, size=5, program="BanditSimple", hostile=true, cid=Bandit.clanMap.PrisonGuard}},
        [13] = {"SpawnGroupAt", {x = 7678, y=11867, z=0, size=5, program="BanditSimple", hostile=true, cid=Bandit.clanMap.PrisonGuard}},
        --[13] = {"HordeAt", {x = 7678, y=11867, z=0, size=20, outfit="Inmate", femaleChance=0}},
        [14] = {"Arson", {}},
        -- [15] = {"OpenDoors", {x1=7645, y1=11843, z1=0, x2=7710, y2=11906, z2=0}},
        [16] = {"SpawnGroupAt", {x = 7694, y=11862, z=0, size=4, program="BanditSimple", hostile=true, cid=Bandit.clanMap.PrisonGuard}},
        [17] = {"SpawnGroupAt", {x = 7697, y=11879, z=0, size=3, program="BanditSimple", hostile=true, cid=Bandit.clanMap.PrisonGuard}},
        [27]  = {"HordeAt", {x = 7687, y=11901, z=0, size=40, outfit="Inmate", femaleChance=0}},
        [28]  = {"HordeAt", {x = 7669, y=11876, z=0, size=20, outfit="Inmate", femaleChance=0}},
        [29]  = {"HordeAt", {x = 7647, y=11868, z=0, size=20, outfit="Inmate", femaleChance=0}},
        [30]  = {"HordeAt", {x = 7659, y=11847, z=0, size=20, outfit="Inmate", femaleChance=0}},
        --[31]  = {"SpawnGroupAt", {x = 7706, y=11866, z=0, size=7, program="Police", hostile=true, cid=Bandit.clanMap.SWAT}},
        --[32]  = {"SpawnGroupAt", {x = 7679, y=11889, z=0, size=7, program="Police", hostile=true, cid=Bandit.clanMap.SWAT}},     
        [33] = {"SetHydroPower", {on=false}},
        [35] = {"SetHydroPower", {on=true}},
        [44] = {"SetHydroPower", {on=false}},
        [47] = {"SetHydroPower", {on=true}},
        [46] = {"Arson", {}},
        [55] = {"Arson", {}},
    },
    [134] = {
        [0] = {"Arson", {}},
        [2] = {"Siren", {}},
        [5]  = {"JetFighterRun", {arm="gas"}},
        [7]  = {"JetFighterRun", {arm="bomb"}},
        [9]  = {"JetFighterRun", {arm="mg"}},
        [11] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=46, intensity=12}},
        [13] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=46, intensity=12}},
        [16] = {"PlaneCrashSequence", {}},
    },
    [135] = {
        [0]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=58, intensity=4}},
        [1]  = {"SetHydroPower", {on=false}},
        [2]  = {"SetHydroPower", {on=true}},
        [8]  = {"SetHydroPower", {on=false}},
        [10] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=57, intensity=4}},
        [42]  = {"JetFighterRun", {arm="gas"}},
        [42]  = {"JetFighterRun", {arm="bomb"}},
        [42]  = {"JetFighterRun", {arm="mg"}},
        [20] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=56, intensity=4}},
        [30] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=55, intensity=4}},
        [32] = {"SetHydroPower", {on=true}},
        [40] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=54, intensity=4}},
        [42]  = {"JetFighterRun", {arm="bomb"}},
        [44]  = {"JetFighterRun", {arm="bomb"}},
        [45]  = {"JetFighterRun", {arm="bomb"}},
        [50] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=53, intensity=4}},
        [52]  = {"JetFighterRun", {arm="gas"}},
        [54]  = {"JetFighterRun", {arm="gas"}},
        [56]  = {"JetFighterRun", {arm="gas"}},
    },
    [136] = {
        [0]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=58, intensity=4}},
        [1]  = {"SetHydroPower", {on=false}},
        [2]  = {"SetHydroPower", {on=true}},
        [8]  = {"SetHydroPower", {on=false}},
        [10] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=57, intensity=4}},
        [20] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=56, intensity=4}},
        [30] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=55, intensity=4}},
        [32]  = {"JetFighterRun", {arm="gas"}},
        [34]  = {"JetFighterRun", {arm="gas"}},
        [36]  = {"JetFighterRun", {arm="gas"}},
        [32] = {"SetHydroPower", {on=true}},
        [40] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=54, intensity=4}},
        [50] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=53, intensity=4}},
    },
    [137] = {
        [12] = {"SpawnGroup", {name="Veterans", cid=Bandit.clanMap.Veteran, program="Police", d=47, intensity=10}},
        [14] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=48, intensity=10}},
        [16]  = {"JetFighterRun", {arm="bomb"}},
        [18]  = {"JetFighterRun", {arm="bomb"}},
        [20]  = {"JetFighterRun", {arm="bomb"}},
        [32]  = {"JetFighterRun", {arm="mg"}},
        [34]  = {"JetFighterRun", {arm="mg"}},
        [36]  = {"JetFighterRun", {arm="mg"}},
        [40]  = {"JetFighterRun", {arm="gas"}},
        [42]  = {"JetFighterRun", {arm="gas"}},
        [44]  = {"JetFighterRun", {arm="gas"}},
    },
    [138] = {
        [2]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=52, intensity=4}},
        [12]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=52, intensity=4}},
        [22]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=52, intensity=4}},
        [32]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="BanditSimple", d=52, intensity=4}},
    },
    [144] = {
        [6]  = {"JetFighterRun", {arm="bomb"}},
        [8]  = {"JetFighterRun", {arm="bomb"}},
        [10]  = {"JetFighterRun", {arm="bomb"}},
        [32]  = {"JetFighterRun", {arm="mg"}},
        [34]  = {"JetFighterRun", {arm="mg"}},
        [36]  = {"JetFighterRun", {arm="mg"}},
        [50]  = {"JetFighterRun", {arm="gas"}},
        [52]  = {"JetFighterRun", {arm="gas"}},
        [54]  = {"JetFighterRun", {arm="gas"}},
    },
    [145] = {
        [6]  = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=49, intensity=5}},
        [17] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=50, intensity=5}},
        [19]  = {"JetFighterRun", {arm="gas"}},
        [21]  = {"JetFighterRun", {arm="gas"}},
        [23]  = {"JetFighterRun", {arm="gas"}},
    },
    [146] = {
        [0]  = {"Siren", {}},
        [5]  = {"JetFighterRun", {arm="mg"}},
        [25] = {"JetFighterRun", {arm="mg"}},
        [45] = {"JetFighterRun", {arm="mg"}},
    },
    [147] = {
        [8]  = {"JetFighterRun", {arm="mg"}},
        [24] = {"JetFighterRun", {arm="mg"}},
        [28] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=51, intensity=5}},
        [47] = {"JetFighterRun", {arm="mg"}},
        [48] = {"Horde", {cnt=100, x=45, y=45}},
        [50] = {"JetFighterRun", {arm="mg"}},
        [51] = {"JetFighterRun", {arm="mg"}},
    },
    [150] = {
        [9]  = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=52, intensity=10}},
        [22] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=50, intensity=5}},
        [24] = {"JetFighterRun", {arm="mg"}},
        [25] = {"JetFighterRun", {arm="mg"}},
        [26] = {"JetFighterRun", {arm="mg"}},
        [27] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=50, intensity=5}},
        [49] = {"JetFighterRun", {arm="mg"}},
        [50] = {"Horde", {cnt=100, x=45, y=45}},
        [58] = {"JetFighterRun", {arm="mg"}},
    },
    [151] = {
        [33] = {"Horde", {cnt=100, x=45, y=45}},
    },
    [152] = {
        [12] = {"JetFighterRun", {arm="mg"}},
        [24] = {"JetFighterRun", {arm="mg"}},
    },
    [153] = {
        [40]  = {"SpawnGroup", {name="Old Friends", cid=Bandit.clanMap.Inmate, program="Companion", d=47, intensity=10}},
        [44] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=53, intensity=5}},
        [45] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=50, intensity=5}},
        [46] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=54, intensity=2}},
        [50] = {"JetFighterRun", {arm="mg"}},
    },
    [154] = {
        [25] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=55, intensity=4}},
        [26] = {"SpawnGroup", {name="Inmates", cid=Bandit.clanMap.InmateFree, program="BanditSimple", d=55, intensity=14}},
        [27] = {"SpawnGroup", {name="Inmates", cid=Bandit.clanMap.InmateFree, program="BanditSimple", d=59, intensity=13}},
    },
    [155] = {
        [5]  = {"JetFighterRun", {arm="mg"}},
        [15] = {"JetFighterRun", {arm="mg"}},
        [16] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=49, intensity=3}},
        [17] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=48, intensity=3}},
        [18] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=47, intensity=3}},
        [25] = {"JetFighterRun", {arm="mg"}},
        [26] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=56, intensity=10}},
    },
    [156] = {
        [5]  = {"JetFighterRun", {arm="mg"}},
        [10] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=46, intensity=12}},
        [15] = {"JetFighterRun", {arm="mg"}},
        [25] = {"JetFighterRun", {arm="mg"}},
        [26] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=57, intensity=10}},
    },
    [158] = {
        [0]  = {"Siren", {}},
        [8]  = {"JetFighterRun", {arm="gas"}},
        [9]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.Mental, program="BanditSimple", d=45, intensity=12}},
        [24] = {"JetFighterRun", {arm="mg"}},
        [31] = {"JetFighterRun", {arm="gas"}},
        [49] = {"JetFighterRun", {arm="gas"}},
        [51] = {"SetHydroPower", {on=false}},
        [52] = {"SetHydroPower", {on=true}},
        [53] = {"Horde", {cnt=100, x=45, y=45}},
    },
    [159] = {
        [8]  = {"JetFighterRun", {arm="bomb"}},
        [9]  = {"SetHydroPower", {on=false}},
        [10] = {"JetFighterRun", {arm="mg"}},
        [11] = {"SetHydroPower", {on=true}},
        [24] = {"JetFighterRun", {arm="bomb"}},
        [25] = {"SetHydroPower", {on=false}},
        [27] = {"SetHydroPower", {on=true}},
        [49] = {"JetFighterRun", {arm="bomb"}},
    },
    [160] = {
        [8]  = {"JetFighterRun", {arm="bomb"}},
        [9]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=45, intensity=9}},
        [24] = {"JetFighterRun", {arm="mg"}},
        [25] = {"SetHydroPower", {on=false}},
        [26] = {"SetHydroPower", {on=true}},
        [49] = {"JetFighterRun", {arm="bomb"}},
        [51] = {"SetHydroPower", {on=false}},
        [53] = {"SetHydroPower", {on=true}},
        [54] = {"Horde", {cnt=100, x=45, y=-45}},
    },
    [161] = {
        [8]  = {"JetFighterRun", {arm="gas"}},
        [24] = {"JetFighterRun", {arm="mg"}},
        [49] = {"JetFighterRun", {arm="gas"}},
        [51] = {"SetHydroPower", {on=false}},
        [58] = {"SetHydroPower", {on=true}},
    },
    [162] = {
        [8]  = {"JetFighterRun", {arm="mg"}},
        [24] = {"JetFighterRun", {arm="bomb"}},
        [49] = {"JetFighterRun", {arm="bomb"}},
        [50] = {"SetHydroPower", {on=false}},
        [51] = {"SetHydroPower", {on=true}},
        [68] = {"JetFighterRun", {arm="mg"}},
    },
    [163] = {
        [8]  = {"JetFighterRun", {arm="bomb"}},
        [15] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=45, intensity=5}},
        [24] = {"JetFighterRun", {arm="bomb"}},
        [30] = {"JetFighterRun", {arm="gas"}},
        [43] = {"JetFighterRun", {arm="gas"}},
        [45] = {"JetFighterRun", {arm="mg"}},
        [49] = {"JetFighterRun", {arm="bomb"}},
    },
    [164] = {
        [8]  = {"JetFighterRun", {arm="bomb"}},
        [9] = {"VehicleCrash", {x=22, y=-70, vtype="pzkA10wreck"}},
        [10] = {"SetHydroPower", {on=false}},
        [13] = {"SetHydroPower", {on=true}},
        [24] = {"JetFighterRun", {arm="bomb"}},
        [49] = {"JetFighterRun", {arm="bomb"}},
        [51] = {"VehicleCrash", {x=-32, y=60, vtype="pzkA10wreck"}},
    },
    [165] = {
        [2]  = {"ChopperFliers", {}},
        [18] = {"VehicleCrash", {x=2, y=70, vtype="pzkHeli350MedWreck"}},
    },
    [166] = {
        [4]  = {"SpawnGroup", {name="Hammer Brothers", cid=Bandit.clanMap.HammerBrothers, program="BanditSimple", d=50, intensity=3}},
    },
    [168] = {
        [0]  = {"StartDay", {day="friday"}},
        [4]  = {"Siren", {}},
        [30] = {"FinalSolution", {}},
        [34] = {"SetHydroPower", {on=false}},
        [35] = {"Horde", {cnt=100, x=-45, y=45}},
    },
    [176] = {
        [25] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="BanditSimple", d=60, intensity=2}},
    },
    [177] = {
        [25] = {"SpawnGroup", {name="Hammer Brothers", cid=Bandit.clanMap.HammerBrothers, program="BanditSimple", d=30, intensity=3}},
    },
    [189] = {
        [12] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="BanditSimple", d=60, intensity=3}},
    },
    [192] = {
        [33] = {"Horde", {cnt=100, x=45, y=-45}},
    },
    [211] = {
        [44] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="BanditSimple", d=60, intensity=4}},
    },
    [235] = {
        [3] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="BanditSimple", d=60, intensity=3}},
    },
    [236] = {
        [12] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="BanditSimple", d=60, intensity=3}},
    },
    [253] = {
        [42] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="BanditSimple", d=60, intensity=7}},
    },
    [315] = {
        [11] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="BanditSimple", d=60, intensity=4}},
        [30] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="BanditSimple", d=60, intensity=3}},
    },
    [333] = {
        [4] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="BanditSimple", d=60, intensity=8}},
    },
    [376] = {
        [4] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="BanditSimple", d=60, intensity=8}},
    },
    [400] = {
        [32] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="BanditSimple", d=60, intensity=12}},
    },
}

table.insert(BWOVariants, prison)
