require "BWOBandit"

BWOVariants = BWOVariants or {}

local thebandit = {}

thebandit.name = "Bandits"
thebandit.image = "media/textures/Variants/thebandit.png"
thebandit.desc = "<SIZE:large> You're the Bandit <BR> "
thebandit.desc = thebandit.desc .. "<SIZE:medium> Difficulty: Hard <BR> "
thebandit.desc = thebandit.desc .. "<SIZE:medium>Day 3. The world hasn't fallen yet, but the cracks are there, and through them, the gangs are crawling out.  "
thebandit.desc = thebandit.desc .. "You're not the hero of this story. You're the one mothers warned their kids about. "
thebandit.desc = thebandit.desc .. "With your crew at your back and everyone else against you, the city is your hunting ground. "
thebandit.desc = thebandit.desc .. "Survival won't be earned. It'll be taken. <BR> "
thebandit.desc = thebandit.desc .. " - Start as the leader of a classy mafia gang. \n "
thebandit.desc = thebandit.desc .. " - You begin on Day 3, as the first criminal groups rise. \n "
thebandit.desc = thebandit.desc .. " - Expect hostility from  everyone — civilians, police, army, survivors, and rival gangs. \n  "
thebandit.desc = thebandit.desc .. " - Reinforcements of other members of your gang may arrive later in the game. \n  "

thebandit.timeOfWeek = 3
thebandit.timeOfDay = 20.75

thebandit.fadeIn = 400

thebandit.playerIsHostile = true

thebandit.setup = function()
    local player = getSpecificPlayer(0)
    if not player then return end
    local px, py, pz = player:getX(), player:getY(), player:getZ()
    BWOScheduler.Add("SpawnGroupArea", {x1 = px - 10, y1 = py - 10, x2 = px + 10, y2 = py + 10, z=0, cnt=24, program="Babe", hostile=false, loyal=true, cid=Bandit.clanMap.CriminalClassy}, 2000)
    
    local inv = player:getInventory()

    local m16 = BanditCompatibility.InstanceItem("Base.AssaultRifle")
    inv:AddItem(m16)
    player:setPrimaryHandItem(m16)
    player:setSecondaryHandItem(m16)

    for i=1, 6 do
        local clip = BanditCompatibility.InstanceItem("Base.556Clip")
        local ammoCnt = clip:getMaxAmmo()
        clip:setCurrentAmmoCount(ammoCnt)
        inv:AddItem(clip)
    end

end

thebandit.schedule = {
    [84] = {
        [0] = {"Start", {}},
        [1] = {"StartDay", {day="monday"}},
        [3] = {"BuildingHome", {addRadio=false}},
        [4] = {"SetupNukes", {}},
        [5] = {"SetupPlaceEvents", {}},
        [7] = {"SpawnGroup", {name="Police", cid=Bandit.clanMap.PoliceBlue, program="Police", d=65, intensity=7}},
    },
    [85] = {
        [11] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = -90, speed=1.7}},
        [22] = {"SpawnGroup", {name="SWAT", cid=Bandit.clanMap.SWAT, program="Police", d=65, intensity=5}},
        [44] = {"SpawnGroup", {name="SWAT", cid=Bandit.clanMap.SWAT, program="Police", d=65, intensity=5}},
    },
    [86] = {
        [40] = {"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 90, speed=1.7}},
        [55] = {"SpawnGroup", {name="SWAT", cid=Bandit.clanMap.SWAT, program="Police", d=65, intensity=5}},
    },
    [87] = {
        [27] = {"Arson", {}},
        [33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, hostile=false, loyal=true, program="Bandit", d=65, intensity=4}},
        [50] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, hostile=false, loyal=true, program="Bandit", d=64, intensity=5}},
    },
    [88] = {
        [44] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=63, intensity=6}},
        [46] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=62, intensity=7}},
        [47] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=61, intensity=6}},
        [48] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=61, intensity=6}},
        [49] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=61, intensity=6}},
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
        [34] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=60, intensity=5}},
        [35] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=60, intensity=5}},
        [36] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=60, intensity=5}},
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
        [16] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Police", d=45, intensity=10}},
        [17] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Police", d=45, intensity=10}},
        [18] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Police", d=45, intensity=10}},
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
        [33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, hostile=false, loyal=true, program="Bandit", d=54, intensity=4}},
        [39] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, hostile=false, loyal=true, program="Bandit", d=53, intensity=4}},
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
        [9]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, hostile=false, program="Bandit", d=45, intensity=9}},
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
        [15] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, hostile=false, program="Bandit", d=45, intensity=5}},
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

table.insert(BWOVariants, thebandit)
