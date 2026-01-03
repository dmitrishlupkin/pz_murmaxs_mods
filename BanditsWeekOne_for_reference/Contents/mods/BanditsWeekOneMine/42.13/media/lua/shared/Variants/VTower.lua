require "BWOBandit"

BWOVariants = BWOVariants or {}

local tower = {}

tower.name = "The Tower"
tower.image = "media/textures/Variants/tower.png"
tower.desc = "<SIZE:large>The Tower <BR> "
tower.desc = tower.desc .. "<SIZE:medium> Difficulty: Pain Enthusiast <BR> "
tower.desc = tower.desc .. "<SIZE:medium>You waited for rescue, the chopper that never came. "
tower.desc = tower.desc .. "Standing at the top of your own Tower of Babel, you realize your pride."
tower.desc = tower.desc .. "Now with every floor down you will descend deeper into hell. "
tower.desc = tower.desc .. "Can you escape the vertical grave? <BR> "
tower.desc = tower.desc .. " - Begin at the rooftop of a skyscraper where evacuation never arrived. \n"
tower.desc = tower.desc .. " - The entire building is infested with zombies and panicked civilians. \n "
tower.desc = tower.desc .. " - Your only escape is to fight or sneak your way down, one deadly floor at a time. \n "
tower.desc = tower.desc .. " - Expect relentless tension and chaos, things unravel fast after the game starts. \n "

tower.timeOfWeek = 5
tower.timeOfDay = 21.90

tower.fadeIn = 3000

tower.fadeIn = 1000

tower.setup = function()
    local player = getSpecificPlayer(0)
    if not player then return end

    local sx, sy, sz = 12715, 1609, 12
    player:setX(sx)
    player:setY(sy)
    player:setZ(sz)
    player:setLastX(sx)
    player:setLastY(sy)
    player:setLastZ(sz)

    local axe = BanditCompatibility.InstanceItem("Base.Axe")
    player:getInventory():AddItem(axe)
    player:setPrimaryHandItem(axe)
end

-- delayed setup
tower.setup2 = function()
    local player = getSpecificPlayer(0)
    if not player then return end

    BWOScheduler.Add("SpawnGroupAt", {x = 12715, y=1609, z=12, size = 10, program="Companion", cid=Bandit.clanMap.Office}, 30)

    local building = getCell():getGridSquare(12715, 1609, 11):getBuilding()
    local def = building:getDef()
    local roomDefs = def:getRooms()
    local roomCount = roomDefs:size()
    for i=0, roomDefs:size()-1 do
        local roomDef = roomDefs:get(i)
        local square = roomDef:getFreeSquare()
        if square then
            local rnd = ZombRand(20)
            if rnd == 1 then
                BWOScheduler.Add("SpawnGroupAt", {x = square:getX(), y=square:getY(), z=square:getZ(), size = 2, program="BanditSimple", cid=Bandit.clanMap.PoliceBlue}, 100)
            elseif rnd < 6 then
                BWOScheduler.Add("SpawnGroupAt", {x = square:getX(), y=square:getY(), z=square:getZ(), size = 1 + ZombRand(5), program="BanditSimple", cid=Bandit.clanMap.Office}, 100)
            end
            --[[elseif rnd == 2 then
                cid=Bandit.clanMap.SuicideBomber, program="Shahid"
                BWOScheduler.Add("HordeAt",  {x = square:getX(), y=square:getY(), z=square:getZ(), size = 1 + ZombRand(3), outfit="OfficeWorker", femaleChance=0}, 200)
            elseif rnd == 3 then
                BWOScheduler.Add("HordeAt",  {x = square:getX(), y=square:getY(), z=square:getZ(), size = 1 + ZombRand(3), outfit="OfficeWorkerSkirt", femaleChance=100}, 200)
            ]]
        end
    end
end

tower.schedule = {
    [132] = {
        [56]  = {"StartDay", {day="thursday"}},
        [57] = {"ChopperAlert", {name="heli2", sound="BWOChopperCDC1", dir = 180, speed=1.2}},
        [58] = {"SetupNukes", {}},
        [59] = {"SetupPlaceEvents", {}},
    },
    [133] = {
        [0] = {"Siren", {}},
        [1]  = {"Arson", {}},
        [2] = {"SetHydroPower", {on=false}},
        [4] = {"SetHydroPower", {on=true}},
        [11]  = {"Arson", {}},
        [12] = {"SetHydroPower", {on=false}},
        [14] = {"SetHydroPower", {on=true}},
        [15]  = {"Arson", {}},
        [16]  = {"Arson", {}},
        [21]  = {"Arson", {}},
        [22] = {"SetHydroPower", {on=false}},
        [29] = {"SetHydroPower", {on=true}},
        [31]  = {"Arson", {}},
        [32] = {"SetHydroPower", {on=false}},
        [33] = {"SetHydroPower", {on=true}},
        [34]  = {"Arson", {}},
        [35]  = {"Arson", {}},
        [36]  = {"Arson", {}},
        [41]  = {"Arson", {}},
        [42] = {"SetHydroPower", {on=false}},
        [43]  = {"Arson", {}},
        [44]  = {"Arson", {}},
        [45]  = {"Arson", {}},
        [46]  = {"Arson", {}},
        [47]  = {"Arson", {}},
        [48]  = {"Arson", {}},
        [49]  = {"Arson", {}},
        [50] = {"SetHydroPower", {on=true}},
        [51]  = {"Arson", {}},
        [52] = {"SetHydroPower", {on=false}},
        [54] = {"SetHydroPower", {on=true}},
        [55]  = {"Arson", {}},
    },
    [134] = {
        [0] = {"Siren", {}},
        [1]  = {"Arson", {}},
        [2] = {"SetHydroPower", {on=false}},
        [4] = {"SetHydroPower", {on=true}},
        [11]  = {"Arson", {}},
        [12] = {"SetHydroPower", {on=false}},
        [14] = {"SetHydroPower", {on=true}},
        [15]  = {"Arson", {}},
        [16]  = {"Arson", {}},
        [21]  = {"Arson", {}},
        [22] = {"SetHydroPower", {on=false}},
        [28] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=46, intensity=12}},
        [29] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=46, intensity=12}},
        [30] = {"SetHydroPower", {on=true}},
        [31]  = {"Arson", {}},
        [32] = {"SetHydroPower", {on=false}},
        [33] = {"SetHydroPower", {on=true}},
        [34]  = {"Arson", {}},
        [35]  = {"Arson", {}},
        [36]  = {"Arson", {}},
        [41]  = {"Arson", {}},
        [42] = {"SetHydroPower", {on=false}},
        [43]  = {"Arson", {}},
        [44]  = {"Arson", {}},
        [45]  = {"Arson", {}},
        [46]  = {"Arson", {}},
        [47]  = {"Arson", {}},
        [48]  = {"Arson", {}},
        [49]  = {"Arson", {}},
        [51]  = {"Arson", {}},
        [54] = {"SetHydroPower", {on=true}},
        [55]  = {"Arson", {}},
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
        [45] = {"PlaneCrashSequence", {}},
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
        [22] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=50, intensity=5}},
        [24] = {"JetFighterRun", {arm="mg"}},
        [25] = {"JetFighterRun", {arm="mg"}},
        [26] = {"JetFighterRun", {arm="mg"}},
        [27] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=50, intensity=5}},
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

table.insert(BWOVariants, tower)
