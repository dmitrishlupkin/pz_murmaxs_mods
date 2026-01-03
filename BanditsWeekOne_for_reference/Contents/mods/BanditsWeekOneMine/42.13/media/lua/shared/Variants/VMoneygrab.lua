require "BWOBandit"

BWOVariants = BWOVariants or {}

local moneygrab = {}

moneygrab.name = "The Cash-Out"
moneygrab.image = "media/textures/Variants/moneygrab.png"

moneygrab.desc = "<SIZE:large> The Cash-Out <BR> "
moneygrab.desc = moneygrab.desc .. "<SIZE:medium> Difficulty: Normal <BR> "
moneygrab.desc = moneygrab.desc .. "<SIZE:medium>You knew the sickness would end the world, but you still trusted in paper and ink. "
moneygrab.desc = moneygrab.desc .. "Emptying your account in the middle of the night, you headed home with a briefcase full of money, believing it will buy you safety. "
moneygrab.desc = moneygrab.desc .. "But in a dying world, cash draws more wolves than bread or bullets. "
moneygrab.desc = moneygrab.desc .. "And some of those wolves already have your scent. <BR> "
moneygrab.desc = moneygrab.desc .. " - Begin with a briefcase packed with money. \n "
moneygrab.desc = moneygrab.desc .. " - Start earlier at night before the first day. \n "
moneygrab.desc = moneygrab.desc .. " - Local gansters saw you withdraw it - they will come looking soon and later. \n "
moneygrab.desc = moneygrab.desc .. " - Supplies and survival will cost more than dollars can buy. \n"

moneygrab.timeOfDay = 2.00

moneygrab.fadeIn = 800

moneygrab.setup = function()
    local player = getSpecificPlayer(0)
    if not player then return end

    local briefcase = BanditCompatibility.InstanceItem("Base.Briefcase")
    local container = briefcase:getItemContainer()
    for i = 1, 1000 do
        local money = BanditCompatibility.InstanceItem("Base.Money")
        container:AddItem(money)
    end

    player:getInventory():AddItem(briefcase)
    player:setSecondaryHandItem(briefcase)

    BWOScheduler.Add("Say", {txt="TIP: You are rich, but some people know about it"}, 900)
end

moneygrab.schedule = {
    [-7] = {
        [0] = {"Start", {party=true}},
        [1] = {"BuildingHome", {}},
        [2] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=35, intensity=10}},
        [3] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=45, intensity=10}},
        [4] = {"SetupNukes", {}},
        [5] = {"SetupPlaceEvents", {}},
    },
    [0] = {
        [1] = {"StartDay", {day="friday"}},
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
        -- DIFF
        [7] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=60, intensity=5}},
    },
    [11] = {
        [12] = {"BuildingParty", {roomName="bedroom", intensity=8}},
    },
    [12] = {
        [30] = {"BuildingParty", {roomName="bedroom", intensity=8}},
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
    },
    [25] = {
        [44] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}},
    },
    [26] = {
        [21] = {"SetHydroPower", {on=false}},
        [22] = {"SetHydroPower", {on=true}},
        -- DIFF
        [23] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=60, intensity=5}},
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
    },
    [48] = {
        [0]  = {"StartDay", {day="sunday"}},
        -- DIFF
        [10] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=60, intensity=12}},
        -- DIFF
        [11] = {"ChopperAlert", {name="heli2", sound="BWOChopperGeneric", dir = 90, speed=2.7}},
        [33] = {"SpawnGroup", {name="Hooligans", cid=Bandit.clanMap.Polish, program="Bandit", d=40, voice=101, intensity=14}},
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
        -- DIFF
        [11] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=74, intensity=12}},
    },
    [58] = {
        -- DIFF
        [33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=73, intensity=13}},
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
        -- DIFF
        [33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=69, intensity=7}},
        -- DIFF
        [39] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=68, intensity=7}},
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
        -- DIFF
        [33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=60, intensity=9}},
        -- DIFF
        [37] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=59, intensity=9}},
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
        [40] = {"PlaneCrashSequence", {}}, -- DIFF
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

table.insert(BWOVariants, moneygrab)
