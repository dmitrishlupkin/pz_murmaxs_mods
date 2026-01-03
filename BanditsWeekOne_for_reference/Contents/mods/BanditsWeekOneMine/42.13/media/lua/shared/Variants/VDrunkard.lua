require "BWOBandit"

BWOVariants = BWOVariants or {}

local drunkard = {}

drunkard.name = "The Drunkard"
drunkard.image = "media/textures/Variants/drunkard.png"
drunkard.desc = "<SIZE:large> The Drunkard <BR> "
drunkard.desc = drunkard.desc .. "<SIZE:medium> Difficulty: Normal <BR> "
drunkard.desc = drunkard.desc .. "<SIZE:medium>You saw the end coming, and instead of preparing, you drowned it in bottles. "
drunkard.desc = drunkard.desc .. "Now you wake with a skull-splitting hangover, surrounded by empties and the wreckage of last night's escape. "
drunkard.desc = drunkard.desc .. "The sickness is already here, the world is collapsing, and you can barely stand. "
drunkard.desc = drunkard.desc .. "Worse still, some remember the money you borrowed to fuel your drinking, and they're angry enough to collect. <BR> "
drunkard.desc = drunkard.desc .. " - Begin at home with a brutal hangover and a trashed house. \n "
drunkard.desc = drunkard.desc .. " - Supplies are scattered, broken, or wasted. \n "
drunkard.desc = drunkard.desc .. " - People you owe money to may come looking for you. \n "
drunkard.desc = drunkard.desc .. " - Survival won't wait for your head to clear. \n "

drunkard.timeOfDay = 9.00

drunkard.fadeIn = 400

drunkard.setup = function()
    local player = getSpecificPlayer(0)
    if not player then return end

    local stats = player:getStats()
    stats:set(CharacterStat.INTOXICATION, 80)
    stats:set(CharacterStat.THIRST, 90)
    stats:set(CharacterStat.FOOD_SICKNESS, 25)

    local bodyDamage = player:getBodyDamage()
    local head = bodyDamage:getBodyPart(BodyPartType.Head)
    head:setAdditionalPain(92)

    player:clearVariable("BumpFallType")
    player:setBumpType("stagger")
    player:setBumpFall(true)
    player:setBumpFallType("pushedBehind")

    local x = player:getX() - 3
    local y = player:getY() - 3
    local w = 6
    local h = 6
    BanditBaseGroupPlacements.Junk(x, y, 0, w, h, 12)
    BanditBaseGroupPlacements.Item(BanditCompatibility.GetLegacyItem("Base.BeerEmpty"), x, y, 0, w, h, 22)
    BanditBaseGroupPlacements.Item(BanditCompatibility.GetLegacyItem("Base.BeerEmpty"), x, y, 0, w, h, 22)
    BanditBaseGroupPlacements.Item(BanditCompatibility.GetLegacyItem("Base.BeerCanEmpty"), x, y, 0, w, h, 33)
end

drunkard.schedule = {
    [0] = {
        [0] = {"Start", {}},
        [1] = {"StartDay", {day="friday"}},
        [3] = {"BuildingHome", {addRadio=true}},
        [4] = {"SetupNukes", {}},
        [5] = {"SetupPlaceEvents", {}},
        [12] = {"SpawnGroup", {name="Debt Collectors", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=48, intensity=3}},
    },
    [2] = {
        [22] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=30, intensity=8}},
    },
    [4] = {
        [15] = {"Entertainer", {}},
    },
    [5] = {
        [44] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}},
    },
    [8] = {
        [5] = {"Arson", {profession="fireofficer"}},
    },
    [11] = {
        [12] = {"BuildingParty", {roomName="bedroom", intensity=8}},
    },
    [12] = {
        [30] = {"BuildingParty", {roomName="bedroom", intensity=8}},
        -- DIFF
        [31] = {"SpawnGroup", {name="Debt Collectors", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=48, intensity=4}},
    },
    [13] = {
        [5]  = {"BuildingParty", {roomName="bedroom", intensity=8}},
        [25] = {"BuildingParty", {roomName="bedroom", intensity=8}},
    },
    [15] = {
        [5]  = {"BuildingParty", {roomName="bedroom", intensity=8}},
        [25] = {"BuildingParty", {roomName="bedroom", intensity=8}},
    },
    [16] = {
        [58] = {"BuildingParty", {roomName="bedroom", intensity=8}},
    },
    [19] = {
        [42] = {"BuildingHome", {addRadio=false}},
    },
    [24] = {
        [0] = {"StartDay", {day="saturday"}},
        -- DIFF
        [6] = {"SpawnGroup", {name="Debt Collectors", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=48, intensity=5}},
    },
    [25] = {
        [44] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}},
    },
    [26] = {
        [21] = {"SetHydroPower", {on=false}},
        [22] = {"SetHydroPower", {on=true}},
    },
    [27] = {
        [8] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}},
    },
    [28] = {
        [33] = {"Entertainer", {}},
    },
    [30] = {
        [33] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}},
    },
    [35] = {
        [20] = {"BuildingParty", {roomName="bedroom", intensity=8}},
    },
    [36] = {
        [10] = {"BuildingParty", {roomName="bedroom", intensity=8}},
    },
    [37] = {
        [5]  = {"BuildingParty", {roomName="bedroom", intensity=8}},
        [25] = {"BuildingParty", {roomName="bedroom", intensity=8}},
    },
    [39] = {
        [2]  = {"BuildingParty", {roomName="bedroom", intensity=8}},
        [14] = {"Arson", {profession="fireofficer"}},
    },
    [42] = {
        [6] = {"BuildingHome", {addRadio=false}},
        -- DIFF
        [8] = {"SpawnGroup", {name="Debt Collectors", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=48, intensity=6}},
    },
    [48] = {
        [0]  = {"StartDay", {day="sunday"}},
        [11] = {"ChopperAlert", {name="heli2", sound="BWOChopperGeneric", dir = 90, speed=2.7}},
        [33] = {"SpawnGroup", {name="Hooligans", voice=101, cid=Bandit.clanMap.Polish, program="Bandit", d=40, intensity=14}},
    },
    [51] = {
        [9]  = {"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 0, speed=2.2}},
        [11] = {"ChopperAlert", {name="heli2", sound="BWOChopperGeneric", dir = -90, speed=2.3}},
    },
    [52] = {
        [5]  = {"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 180, speed=1.8}},
        [11] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=75, intensity=2}},
    },
    [53] = {
        [1] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = -90, speed=2.2}},
    },
    [54] = {
        [28] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 90, speed=1.8}},
        [30] = {"Arson", {}},
    },
    [55] = {
        [11] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=74, intensity=2}},
    },
    [58] = {
        [33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=73, intensity=3}},
        [35] = {"PlaneCrashSequence", {}}, -- DIFF
    },
    [59] = {
        [56] = {"SpawnGroup", {name="Suicide Bomber", cid=Bandit.clanMap.SuicideBomber, program="Shahid", d=45, intensity=2}},
    },
    [62] = {
        [55] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 180, speed=1.7}},
    },
    [63] = {
        [30] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=72, intensity=4}},
    },
    [66] = {
        [39] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=71, intensity=3}},
        [40] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 0, speed=1.8}},
        [41] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=70, intensity=3}},
    },
    [67] = {
        [13] = {"ChopperAlert", {name="heli2", sound="BWOChopperGeneric", dir = 0, speed=2.9}},
    },
    [72] = {
        [0] = {"StartDay", {day="monday"}},
    },
    [77] = {
        [22] = {"SpawnGroup", {name="Suicide Bomber", cid=Bandit.clanMap.SuicideBomber, program="Shahid", d=41, intensity=2}},
        [33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=69, intensity=4}},
        [39] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=68, intensity=4}},
    },
    [79] = {
        [14] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=67, intensity=3}},
        [15] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=66, intensity=3}},
        [55] = {"Arson", {}},
    },
    [82] = {
        [31] = {"ChopperAlert", {name="heli2", sound="BWOChopperCDC1", dir = 0, speed=1.8}},
        [42] = {"ChopperAlert", {name="heli2", sound="BWOChopperCDC1", dir = 180, speed=2.1}},
    },
    [83] = {
        [35] = {"BuildingHome", {addRadio=false}},
    },
    [85] = {
        [33] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = -90, speed=1.7}},
    },
    [86] = {
        [40] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 90, speed=1.7}},
    },
    [87] = {
        [27] = {"Arson", {}},
        [33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=65, intensity=4}},
        [50] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=64, intensity=5}},
    },
    [88] = {
        [44] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=63, intensity=6}},
        [46] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=62, intensity=7}},
        [47] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=61, intensity=6}},
    },
    [89] = {
        [52] = {"Arson", {}},
        [58] = {"BuildingHome", {addRadio=false}},
    },
    [91] = {
        [4]  = {"Arson", {}},
        [23] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=65, intensity=4}},
    },
    [94] = {
        [33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=60, intensity=5}},
        [37] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=59, intensity=6}},
    },
    [95] = {
        [22] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=65, intensity=4}},
        [33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=58, intensity=5}},
        [37] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=57, intensity=4}},
    },
    [96] = {
        [0]  = {"StartDay", {day="tuesday"}},
        [15] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Police", d=45, intensity=10}},
    },
    [97] = {
        [3] = {"SpawnGroup", {name="Biker Gang", cid=Bandit.clanMap.Biker, program="Bandit", d=60, intensity=14}},
    },
    [112] = {
        [0]  = {"Arson", {}},
        [11] = {"Arson", {}},
        [12] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=64, intensity=6}},
        [44] = {"Arson", {}},
        [45] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=63, intensity=6}},
        [56] = {"SpawnGroup", {name="Biker Gang", cid=Bandit.clanMap.Biker, program="Bandit", d=60, intensity=14}},
    },
    [113] = {
        [22] = {"Arson", {}},
        [23] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 0, speed=1.9}},
        [33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=57, intensity=4}},
        [35] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=56, intensity=5}},
        [36] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=61, intensity=6}},
        [37] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=55, intensity=5}},
        [38] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=60, intensity=5}},
        [39] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=59, intensity=2}},
    },
    [116] = {
        [16] = {"BuildingHome", {addRadio=false}},
    },
    [120] = {
        [0] = {"StartDay", {day="wednesday"}},
    },
    [121] = {
        [2]  = {"ProtestAll", {}},
        [16] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice2", dir = -90, speed=1.6}},
        [45] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice2", dir = 90, speed=1.7}},
    },
    [122] = {
        [0]  = {"Siren", {}},
        [11] = {"SpawnGroup", {name="Riot Police", cid=Bandit.clanMap.PoliceRiot, program="RiotPolice", d=30, intensity=12}},
        [12] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice2", dir = -90, speed=1.8}},
        [15] = {"SpawnGroup", {name="Riot Police", cid=Bandit.clanMap.PoliceRiot, program="RiotPolice", d=30, intensity=12}},
        [16] = {"Shahids", {intensity=1}},
        [17] = {"SpawnGroup", {name="Riot Police", cid=Bandit.clanMap.PoliceRiot, program="RiotPolice", d=30, intensity=12}},
        [44] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice2", dir = 90, speed=1.6}},
    },
    [123] = {
        [27] = {"Arson", {}},
        [33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=54, intensity=4}},
        [39] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=53, intensity=4}},
        [41] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice2", dir = 180, speed=2.7}},
        [45] = {"SpawnGroup", {name="Riot Police", cid=Bandit.clanMap.PoliceRiot, program="RiotPolice", d=30, intensity=12}},
        [56] = {"VehicleCrash", {x=-70, y=0, vtype="pzkHeli350PoliceWreck"}},
    },
    [124] = {
        [1]  = {"ChopperFliers", {}},
    },
    [125] = {
        [2]  = {"Arson", {}},
        [3]  = {"SpawnGroup", {name="Asylum Escapes", cid=Bandit.clanMap.Mental, program="Bandit", d=34, intensity=16}},
        [5]  = {"Arson", {}},
    },
    [128] = {
        [27] = {"Arson", {}},
    },
    [130] = {
        [0] = {"Siren", {}},
    },
    [132] = {
        [0] = {"Siren", {}},
    },
    [133] = {
        [54] = {"Siren", {}},
        [56] = {"PlaneCrashSequence", {}},
    },
    [134] = {
        [40] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=46, intensity=12}},
    },
    [135] = {
        [0]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=58, intensity=4}},
        [1]  = {"SetHydroPower", {on=false}},
        [2]  = {"SetHydroPower", {on=true}},
        [8]  = {"SetHydroPower", {on=false}},
        [10] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=57, intensity=4}},
        [20] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=56, intensity=4}},
        [30] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=55, intensity=4}},
        [32] = {"SetHydroPower", {on=true}},
        [40] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=54, intensity=4}},
        [50] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=53, intensity=4}},
    },
    [136] = {
        [12] = {"SpawnGroup", {name="Veterans", cid=Bandit.clanMap.Veteran, program="Police", d=47, intensity=10}},
        [14] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=48, intensity=10}},
    },
    [138] = {
        [2]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=52, intensity=3}},
    },
    [144] = {
        [0] = {"StartDay", {day="thursday"}},
    },
    [145] = {
        [6]  = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=49, intensity=5}},
        [17] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=50, intensity=5}},
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
        [24] = {"JetFighterRun", {arm="mg"}},
        [25] = {"JetFighterRun", {arm="mg"}},
        [26] = {"JetFighterRun", {arm="mg"}},
        [49] = {"JetFighterRun", {arm="mg"}},
        [50] = {"Horde", {cnt=100, x=45, y=45}},
        [58] = {"JetFighterRun", {arm="mg"}},
    },
    [152] = {
        [12] = {"JetFighterRun", {arm="mg"}},
        [24] = {"JetFighterRun", {arm="mg"}},
    },
    [153] = {
        [44] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=53, intensity=5}},
        [45] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=50, intensity=5}},
        [46] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=54, intensity=2}},
        [50] = {"JetFighterRun", {arm="mg"}},
    },
    [154] = {
        [25] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=55, intensity=4}},
        [26] = {"SpawnGroup", {name="Inmates", cid=Bandit.clanMap.InmateFree, program="Bandit", d=55, intensity=14}},
        [27] = {"SpawnGroup", {name="Inmates", cid=Bandit.clanMap.InmateFree, program="Bandit", d=59, intensity=13}},
    },
    [155] = {
        [5]  = {"JetFighterRun", {arm="mg"}},
        [15] = {"JetFighterRun", {arm="mg"}},
        [16] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=49, intensity=3}},
        [17] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=48, intensity=3}},
        [18] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=47, intensity=3}},
        [25] = {"JetFighterRun", {arm="mg"}},
        [26] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=56, intensity=10}},
    },
    [156] = {
        [5]  = {"JetFighterRun", {arm="mg"}},
        [10] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=46, intensity=12}},
        [15] = {"JetFighterRun", {arm="mg"}},
        [25] = {"JetFighterRun", {arm="mg"}},
        [26] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=57, intensity=10}},
    },
    [158] = {
        [0]  = {"Siren", {}},
        [8]  = {"JetFighterRun", {arm="gas"}},
        [9]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.Mental, program="Bandit", d=45, intensity=12}},
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
        [9]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=45, intensity=9}},
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
        [15] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=45, intensity=5}},
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
        [4]  = {"SpawnGroup", {name="Hammer Brothers", cid=Bandit.clanMap.HammerBrothers, program="Bandit", d=50, intensity=3}},
    },
    [168] = {
        [0]  = {"StartDay", {day="friday"}},
        [4]  = {"Siren", {}},
        [30] = {"FinalSolution", {}},
        [34] = {"SetHydroPower", {on=false}},
        [35] = {"Horde", {cnt=100, x=-45, y=45}},
    },
    [176] = {
        [25] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=2}},
    },
    [177] = {
        [25] = {"SpawnGroup", {name="Hammer Brothers", cid=Bandit.clanMap.HammerBrothers, program="Bandit", d=30, intensity=3}},
    },
    [189] = {
        [12] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=3}},
    },
    [192] = {
        [33] = {"Horde", {cnt=100, x=45, y=-45}},
    },
    [211] = {
        [44] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=4}},
    },
    [235] = {
        [3] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=3}},
    },
    [236] = {
        [12] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=3}},
    },
    [253] = {
        [42] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=7}},
    },
    [315] = {
        [11] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=4}},
        [30] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=3}},
    },
    [333] = {
        [4] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=8}},
    },
    [376] = {
        [4] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=8}},
    },
    [400] = {
        [32] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=12}},
    },
}

table.insert(BWOVariants, drunkard)
