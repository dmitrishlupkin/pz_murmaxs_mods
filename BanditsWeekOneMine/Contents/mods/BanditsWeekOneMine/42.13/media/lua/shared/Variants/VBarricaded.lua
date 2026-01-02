require "BWOBandit"

BWOVariants = BWOVariants or {}

local barricaded = {}

barricaded.name = "Barricaded"
barricaded.image = "media/textures/Variants/barricade.png"
barricaded.desc = "<SIZE:large>Barricaded <BR> "

barricaded.desc = barricaded.desc .. "<SIZE:medium>Difficulty: Hard<BR>"
barricaded.desc = barricaded.desc .. "<SIZE:medium>A S.W.A.T. team was tasked with protecting the city's mayor inside Louisville City Hall. "
barricaded.desc = barricaded.desc .. "The barricades were nearly complete when the mayor turned from a political beast into just a beast. "
barricaded.desc = barricaded.desc .. "Now the horde is already pounding at the doors. Let the last stand begin! <BR> "
barricaded.desc = barricaded.desc .. " - Start in Louisville City Hall, where windows have been barricaded. \n "
barricaded.desc = barricaded.desc .. " - You are part of a S.W.A.T. unit, equipped with tactical gear. \n "
barricaded.desc = barricaded.desc .. " - You're not alone wther officers are holding the line with you. \n "
barricaded.desc = barricaded.desc .. " - Expect a massive horde closing in fast. \n "

barricaded.timeOfWeek = 5
barricaded.timeOfDay = 23.90

barricaded.fadeIn = 1000

barricaded.setup = function()
    local player = getSpecificPlayer(0)
    if not player then return end

    local sx, sy, sz = 12554, 1534, 0
    player:setX(sx)
    player:setY(sy)
    player:setZ(sz)
    player:setLastX(sx)
    player:setLastY(sy)
    player:setLastZ(sz)

    local inv = player:getInventory()
    inv:clear()

    local wornItems = player:getWornItems()
    wornItems:clear()

    local clothes = {
        "Base.Belt2",
        "Base.Glasses_SafetyGoggles",
        "Base.Hat_SWAT",
        "Base.Boilersuit_SWAT",
        "Base.Vest_BulletSWAT",
        "Base.Shoes_ArmyBoots",
    }
    for _, itemType in ipairs(clothes) do
        local item = BanditCompatibility.InstanceItem(itemType)
        local itemLocation = item:getBodyLocation()
        inv:AddItem(suit)
        wornItems:setItem(itemLocation, item)
        player:setWornItems(wornItems)
    end
    
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

-- delayed setup
barricaded.setup2 = function()

    BWOPopControl.ZombieMax = 1000
    local player = getSpecificPlayer(0)
    if not player then return end

    local cell = getCell()

    local building = player:getSquare():getBuilding()
    local buildingDef = building:getDef()
    local z = 0
    for y = buildingDef:getY()-1, buildingDef:getY2()+1 do
        for x = buildingDef:getX()-1, buildingDef:getX2()+1 do
            local square = cell:getGridSquare(x, y, z)
            if square then
                local objects = square:getObjects()
                for i=0, objects:size()-1 do
                    local object = objects:get(i)
                    if object then
                        if instanceof(object, "IsoLightSwitch") then
                            object:setActive(true)
                        elseif instanceof(object, "IsoWindow") then
                            local barricade = object:getBarricadeOnSameSquare()
                            if not barricade then
                                barricade = object:getBarricadeOnOppositeSquare()
                            end

                            if not barricade then
                                local barricade = IsoBarricade.AddBarricadeToObject(object, player)
                                if barricade then
                                    for i=1, 2 + ZombRand(3) do
                                        local plank = BanditCompatibility.InstanceItem("Base.Plank")
                                        plank:setCondition(200)
                                        barricade:addPlank(nil, plank)
                                    end
                                    barricade:transmitCompleteItemToClients()
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local i = 100
    BWOScheduler.Add("ClearZombies", {}, i)
    i = i + 1

    -- BWOScheduler.Add("ClearCorpse", {x1=buildingDef:getX()-1, y1=buildingDef:getY()-1, x2=buildingDef:getX2()+1, y2=buildingDef:getY2()+1, z1=0, z2=1}, i)
    i = i + 1

    BWOScheduler.Add("SpawnGroupArea", {x1=buildingDef:getX()+10, y1=buildingDef:getY()+10, x2=buildingDef:getX2()-10, y2=buildingDef:getY2()-10, z=1, cnt=16, program="BanditSimple", hostile=false, cid=Bandit.clanMap.Office}, i)
    i = i + 1
    
    BWOScheduler.Add("SpawnGroupArea", {x1=buildingDef:getX()+10, y1=buildingDef:getY()+10, x2=buildingDef:getX2()-10, y2=buildingDef:getY2()-10, z=0, cnt=9, program="BanditSimple", hostile=false, cid=Bandit.clanMap.PoliceBlue}, i)
    i = i + 1

    BWOScheduler.Add("SpawnGroupArea", {x1=buildingDef:getX()+10, y1=buildingDef:getY()+10, x2=buildingDef:getX2()-10, y2=buildingDef:getY2()-10, z=1, cnt=6, program="BanditSimple", hostile=false, cid=Bandit.clanMap.PoliceBlue}, i)
    i = i + 1
    
    local sx, sy, sz = 12565, 1535, 0
    BWOScheduler.Add("SpawnGroupAt", {x=sx, y=sy, z=sz, size=8, program="Companion", hostile=false, cid=Bandit.clanMap.SWAT}, i)
    i = i + 1

    BWOScheduler.Add("HordeAt", {x = 12582, y=1533, z=0, size = 20, outfit="Generic01", femaleChance=50}, i)
    BWOScheduler.Add("HordeAt", {x = 12583, y=1533, z=0, size = 30, outfit="Generic02", femaleChance=50}, i)
    BWOScheduler.Add("HordeAt", {x = 12588, y=1533, z=0, size = 50, outfit="Generic02", femaleChance=50}, i)

    BWOScheduler.Add("Horde", {x = 25, y=0, cnt=35}, 200)
    BWOScheduler.Add("Horde", {x = 25, y=10, cnt=30}, 300)
    BWOScheduler.Add("Horde", {x = 25, y=-10, cnt=25}, 400)
    BWOScheduler.Add("Horde", {x = -25, y=-10, cnt=20}, 500)
    BWOScheduler.Add("Horde", {x = -25, y=0, cnt=20}, 600)
    BWOScheduler.Add("Horde", {x = -25, y=10, cnt=20}, 700)
    BWOScheduler.Add("Horde", {x = 30, y=15, cnt=20}, 800)
    BWOScheduler.Add("Horde", {x = 30, y=-15, cnt=20}, 900)
end

barricaded.schedule = {
    [134] = {
        [56]  = {"StartDay", {day="thursday"}},
        [57] = {"Arson", {}},
        [58] = {"SetupNukes", {}},
        [59] = {"SetupPlaceEvents", {}},
    },
    [135] = {
        [0] = {"Siren", {}},
        [1]  = {"Arson", {}},
        [2]  = {"Arson", {}},
        [3]  =  {"Horde", {x = 0, y=-30, cnt=40}},
        [4]  =  {"Horde", {x = -30, y=-30, cnt=40}},
        [5]  = {"Arson", {}},
        [6]  = {"Arson", {}},
        [7]  = {"SpawnGroup", {name="Police", cid=Bandit.clanMap.SWAT, hostile=false, program="Companion", d=30, intensity=6}},
        [10]  = {"Horde", {x = -35, y=35, cnt=30}},
        [11]  =  {"Horde", {x = 0, y=35, cnt=30}},
        [12]  =  {"Horde", {x = -35, y=0, cnt=30}},
        [13]  =  {"Horde", {x = 35, y=-35, cnt=30}},
        [14]  =  {"Horde", {x = 35, y=0, cnt=30}},
        [15]  =  {"Horde", {x = 0, y=-35, cnt=30}},
        [16]  =  {"Horde", {x = -35, y=-35, cnt=30}},
        [17]  =  {"Horde", {x = 35, y=-20, cnt=30}},
        [18]  = {"Horde", {x = -35, y=35, cnt=30}},
        [19]  =  {"Horde", {x = 0, y=35, cnt=30}},
        [20]  =  {"Horde", {x = -35, y=0, cnt=30}},
        [21]  =  {"Horde", {x = 35, y=-35, cnt=30}},
        [22]  =  {"Horde", {x = 35, y=0, cnt=30}},
        [23]  =  {"Horde", {x = 0, y=-35, cnt=30}},
        [24]  =  {"Horde", {x = -35, y=-35, cnt=30}},
        [25]  =  {"Horde", {x = 35, y=-20, cnt=30}},
        [26]  = {"JetFighterRun", {arm="mg"}},
        [27]  = {"JetFighterRun", {arm="mg"}},
        [28]  = {"JetFighterRun", {arm="mg"}},
        [29]  = {"SpawnGroup", {name="Police", cid=Bandit.clanMap.SWAT, hostile=false, program="BanditSimple", d=30, intensity=6}},
        [30]  = {"Horde", {x = -35, y=35, cnt=30}},
        [31]  =  {"Horde", {x = 0, y=35, cnt=30}},
        [32]  =  {"Horde", {x = -35, y=0, cnt=30}},
        [33]  =  {"Horde", {x = 35, y=-35, cnt=30}},
        [34]  = {"SetHydroPower", {on=false}},
        [35]  = {"JetFighterRun", {arm="mg"}},
        [36]  = {"JetFighterRun", {arm="mg"}},
        [37]  = {"JetFighterRun", {arm="mg"}},
        [38]  = {"JetFighterRun", {arm="mg"}},
        [39]  = {"SetHydroPower", {on=true}},
        [40]  =  {"Horde", {x = -35, y=-35, cnt=30}},
        [41]  =  {"Horde", {x = 35, y=-20, cnt=30}},
        [42]  = {"Horde", {x = -35, y=35, cnt=30}},
        [43]  =  {"Horde", {x = 0, y=35, cnt=30}},
        [44]  =  {"Horde", {x = -35, y=0, cnt=20}},
        [45]  =  {"Horde", {x = 35, y=-35, cnt=20}},
        [46]  =  {"Horde", {x = 35, y=0, cnt=20}},
        [47]  =  {"Horde", {x = 0, y=-35, cnt=20}},
        [48]  =  {"Horde", {x = -35, y=-35, cnt=20}},
        [49]  =  {"Horde", {x = 35, y=-20, cnt=20}},
        [50]  = {"SetHydroPower", {on=false}},
        [51]  = {"JetFighterRun", {arm="gas"}},
        [52]  = {"JetFighterRun", {arm="gas"}},
        [53]  = {"JetFighterRun", {arm="gas"}},
        [54]  = {"JetFighterRun", {arm="gas"}},
        [55]  = {"SetHydroPower", {on=true}},
    },
    [136] = {
        [0]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=58, intensity=4}},
        [1]  = {"SetHydroPower", {on=false}},
        [2]  = {"SetHydroPower", {on=true}},
        [8]  = {"SetHydroPower", {on=false}},
        [10] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=57, intensity=4}},
        [42]  = {"JetFighterRun", {arm="bomb"}},
        [42]  = {"JetFighterRun", {arm="bomb"}},
        [42]  = {"JetFighterRun", {arm="bomb"}},
        [20] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=56, intensity=4}},
        [30] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=55, intensity=4}},
        [32] = {"SetHydroPower", {on=true}},
        [40] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=54, intensity=4}},
        [42]  = {"JetFighterRun", {arm="bomb"}},
        [44]  = {"JetFighterRun", {arm="bomb"}},
        [45]  = {"JetFighterRun", {arm="bomb"}},
        [50] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="BanditSimple", d=53, intensity=4}},
        [52]  = {"JetFighterRun", {arm="gas"}},
        [54]  = {"JetFighterRun", {arm="gas"}},
        [56]  = {"JetFighterRun", {arm="gas"}},
    },
    [137] = {
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
    [138] = {
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
    [139] = {
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

table.insert(BWOVariants, barricaded)
