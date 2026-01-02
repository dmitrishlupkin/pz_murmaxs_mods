BWOScheduler = BWOScheduler or {}

-- queue of evenst added from schedule to be processed
BWOScheduler.Events = {}

-- general symptoms level 0 - 4
BWOScheduler.SymptomLevel = 0

-- how old is the world
BWOScheduler.WorldAge = 0

-- flags tables
BWOScheduler.World = {}
BWOScheduler.NPC = {}
BWOScheduler.Anarchy = {}

-- world age time shift depending on sandbox start date
waShiftMap = {}
table.insert(waShiftMap, 0) -- week before
table.insert(waShiftMap, 168) -- 2 weeks before
table.insert(waShiftMap, 504) -- 4 weeks before
table.insert(waShiftMap, 1848) -- 12 weeks before
table.insert(waShiftMap, 8760) -- year before
table.insert(waShiftMap, 87432) -- 10 years before
BWOScheduler.waShiftMap = waShiftMap

-- schedule 
local generateSchedule = function()
    local tab = {}
    for wa=0, 400 do
        tab[wa] = {}
        for m=0, 59 do
            tab[wa][m] = {}
        end
    end
    
    -- {eventName, {params}}
    -- DAY 1 09.00
    -- tab[0][1]   = {"Start", {}}
    tab[0][2]   = {"StartDay", {day="friday"}}
    tab[0][3]   = {"BuildingHome", {addRadio=true}}
    tab[0][4]   = {"SetupNukes", {}}
    tab[0][5]   = {"SetupPlaceEvents", {}}
    
    tab[2][22]  = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=30, intensity=8}}
    tab[4][15]  = {"Entertainer", {}}
    tab[5][44]  = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}}
    tab[6][35]  = {"Entertainer", {}}
    tab[7][15]  = {"Entertainer", {}}
    tab[8][5]   = {"Defenders", {profession="policeofficer"}}
    tab[8][5]   = {"Arson", {profession="fireofficer"}}

    tab[11][12] = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[12][30] = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[13][5]  = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[13][25] = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[15][5]  = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[15][25] = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[16][58] = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[19][42] = {"BuildingHome", {addRadio=false}}
    -- tab[19][43] = {"Thieves", {intensity=3}}
    
    -- DAY 2 09.00
    tab[24][0]  = {"StartDay", {day="saturday"}}
    tab[24][15] = {"Entertainer", {}}
    tab[25][44] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}}
    tab[26][20] = {"Entertainer", {}}
    tab[26][21] = {"SetHydroPower", {on=false}}
    tab[26][22] = {"SetHydroPower", {on=true}}
    tab[27][8]  = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}}
    tab[28][33] = {"Entertainer", {}}
    tab[30][33] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Patrol", d=40, intensity=8}}
    tab[35][20] = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[36][10] = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[37][5]  = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[37][25] = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[39][2]  = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[39][14] = {"Defenders", {profession="policeofficer"}}
    tab[39][14] = {"Arson", {profession="fireofficer"}}
    tab[42][6]  = {"BuildingHome", {addRadio=false}}
    -- tab[42][7]  = {"Thieves", {intensity=4}}

    -- DAY 3 09.00
    tab[48][0]  = {"StartDay", {day="sunday"}}
    tab[51][9]  = {"ChopperAlert", {sound="BWOChopper"}}
    tab[52][5]  = {"ChopperAlert", {sound="BWOChopper"}}
    tab[52][11] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=75, intensity=2}}
    tab[53][1]  = {"ChopperAlert", {sound="BWOChopper"}}
    tab[54][28] = {"ChopperAlert", {sound="BWOChopper"}}
    tab[54][30] = {"Arson", {}}
    tab[55][11] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=74, intensity=2}}
    tab[58][33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=73, intensity=3}}
    tab[59][44] = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[59][55] = {"BuildingParty", {roomName="bedroom", intensity=8}}
    tab[59][56] = {"SpawnGroup", {name="Suicide Bomber", cid=Bandit.clanMap.SuicideBomber, program="Shahid", d=45, intensity=2}}
    tab[63][30] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=72, intensity=4}}
    tab[66][39] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=71, intensity=3}}
    tab[66][41] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=70, intensity=3}}
    tab[69][14] = {"Defenders", {}}
    tab[71][21] = {"Defenders", {}}

    -- DAY 4 09.00
    tab[72][0]  = {"StartDay", {day="monday"}}
    tab[72][2]  = {"Defenders", {}}
    tab[76][7]  = {"Defenders", {}}
    tab[76][57] = {"Defenders", {}}
    tab[77][22] = {"SpawnGroup", {name="Suicide Bomber", cid=Bandit.clanMap.SuicideBomber, program="Shahid", d=41, intensity=2}}
    tab[77][33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=69, intensity=4}}
    tab[77][39] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=68, intensity=4}}
    tab[78][51] = {"Defenders", {}}
    tab[79][14] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=67, intensity=3}}
    tab[79][15] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=66, intensity=3}}
    tab[79][55] = {"Arson", {}}
    tab[80][41] = {"Defenders", {}}
    tab[83][35] = {"BuildingHome", {addRadio=false}}
    -- tab[83][36] = {"Thieves", {intensity=4}}
    tab[83][2]  = {"ChopperAlert", {sound="BWOChopper"}}
    tab[83][33] = {"ChopperAlert", {sound="BWOChopper"}}
    tab[87][27] = {"Arson", {}}
    tab[87][33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=65, intensity=4}}
    tab[87][50] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=64, intensity=5}}
    tab[88][44] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=63, intensity=6}}
    tab[88][46] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=62, intensity=7}}
    tab[88][47] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=61, intensity=6}}
    tab[89][35] = {"Defenders", {}}
    tab[89][52] = {"Arson", {}}
    tab[89][58] = {"BuildingHome", {addRadio=false}}
    -- tab[89][59] = {"Thieves", {intensity=5}}
    tab[90][6]  = {"Defenders", {}}
    tab[91][4]  = {"Arson", {}}
    tab[91][23] = {"SpawnGroup",{name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=65, intensity=4}}
    tab[94][31] = {"Defenders", {}}
    tab[94][33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=60, intensity=5}}
    tab[94][37] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=59, intensity=6}}
    tab[95][22] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=65, intensity=4}}
    tab[95][33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=58, intensity=5}}
    tab[95][37] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=57, intensity=4}}

    -- DAY 5 09.00
    tab[96][0]  = {"StartDay", {day="tuesday"}}
    tab[96][15] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreen, program="Police", d=45, intensity=10}}
    tab[97][2]  = {"Defenders", {}}
    tab[97][3]  = {"SpawnGroup", {name="Biker Gang", cid=Bandit.clanMap.Biker, program="Bandit", d=60, intensity=14}}
    tab[98][10] = {"Defenders", {}}
    tab[103][10] = {"Defenders", {}}
    tab[105][52] = {"Defenders", {}}
    tab[112][0]  = {"Arson", {}}
    tab[112][11] = {"Arson", {}}
    tab[112][12] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=64, intensity=6}}
    tab[112][44] = {"Arson", {}}
    tab[112][45] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=63, intensity=6}}
    tab[112][55] = {"Defenders", {}}
    tab[112][56] = {"SpawnGroup", {name="Biker Gang", cid=Bandit.clanMap.Biker, program="Bandit", d=60, intensity=14}}
    tab[113][31] = {"Defenders", {}}
    tab[113][22] = {"Arson", {}}
    tab[113][33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=57, intensity=4}}
    tab[113][35] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalWhite, program="Bandit", d=56, intensity=5}}
    tab[113][36] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=61, intensity=6}}
    tab[113][37] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalBlack, program="Bandit", d=55, intensity=5}}
    tab[113][38] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=60, intensity=5}}
    tab[113][39] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=59, intensity=2}}
    tab[116][15] = {"Defenders", {}}
    tab[116][16] = {"BuildingHome", {addRadio=false}}
    -- tab[116][17] = {"Thieves", {intensity=6}}
    -- tab[117][15] = {"Thieves", {intensity=6}}

    -- DAY 6 09.00
    tab[120][0]  = {"StartDay", {day="wednesday"}}
    
    tab[121][2]  = {"ProtestAll", {}}
    tab[121][16] = {"ChopperAlert", {sound="BWOChopperDisperse"}}
    tab[121][45] = {"ChopperAlert", {sound="BWOChopperDisperse"}}
    tab[122][0]  = {"Siren", {}}
    tab[122][11] = {"SpawnGroup", {name="Riot Police", cid=Bandit.clanMap.PoliceRiot, program="RiotPolice", d=30, intensity=12}}
    tab[122][12] = {"ChopperAlert", {sound="BWOChopperDisperse"}}
    tab[122][15] = {"SpawnGroup", {name="Riot Police", cid=Bandit.clanMap.PoliceRiot, program="RiotPolice", d=30, intensity=12}}
    tab[122][16] = {"Shahids", {intensity=1}}
    tab[122][17] = {"SpawnGroup", {name="Riot Police", cid=Bandit.clanMap.PoliceRiot, program="RiotPolice", d=30, intensity=12}}
    tab[122][44] = {"ChopperAlert", {sound="BWOChopperDisperse"}}
    tab[123][27] = {"Arson", {}}
    tab[123][33] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=54, intensity=4}}
    tab[123][39] = {"SpawnGroup", {name="Criminals", cid=Bandit.clanMap.CriminalClassy, program="Bandit", d=53, intensity=4}}
    tab[123][41] = {"ChopperAlert", {sound="BWOChopperDisperse"}}
    tab[123][45] = {"SpawnGroup", {name="Riot Police", cid=Bandit.clanMap.PoliceRiot, program="RiotPolice", d=30, intensity=12}}

    tab[124][1]  = {"ChopperFliers", {}}
    tab[125][2]  = {"Arson", {}}
    tab[125][3]  = {"SpawnGroup", {name="Asylum Escapes", cid=Bandit.clanMap.Mental, program="Bandit", d=34, intensity=16}}
    tab[125][5]  = {"Arson", {}}
    tab[128][16] = {"Arson", {}}
    tab[128][27] = {"Arson", {}}
    tab[130][0]  = {"Siren", {}}

    tab[132][0]  = {"Siren", {}}
    
    tab[133][6]  = {"Reanimate", {r=80, chance=100}}
    tab[134][40] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=46, intensity=12}}
    tab[135][0]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=58, intensity=4}}
    tab[135][1]  = {"SetHydroPower", {on=false}}
    tab[135][2]  = {"SetHydroPower", {on=true}}
    tab[135][8]  = {"SetHydroPower", {on=false}}
    tab[135][10] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=57, intensity=4}}
    tab[135][20] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=56, intensity=4}}
    tab[135][30] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=55, intensity=4}}
    tab[135][32] = {"SetHydroPower", {on=true}}
    tab[135][40] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=54, intensity=4}}
    tab[135][50] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=53, intensity=4}}
    tab[136][12] = {"SpawnGroup", {name="Veterans", cid=Bandit.clanMap.Veteran, program="Police", d=47, intensity=10}}
    tab[136][14] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=48, intensity=10}}
    tab[138][2]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditSpike, program="Bandit", d=52, intensity=3}}

    -- DAY 7 09.00
    tab[144][0]  = {"StartDay", {day="thursday"}}
    tab[145][6]  = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=49, intensity=5}}
    tab[145][17] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=50, intensity=5}}
    tab[146][0]  = {"Siren", {}}
    tab[146][5]  = {"JetFighterRun", {intensity=1}}
    tab[146][25] = {"JetFighterRun", {intensity=1}}
    tab[146][45] = {"JetFighterRun", {intensity=1}}
    tab[147][8]  = {"JetFighterRun", {intensity=1}}
    tab[147][24] = {"JetFighterRun", {intensity=1}}
    tab[147][28] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=51, intensity=5}}
    tab[147][49] = {"JetFighterRun", {intensity=1}}
    tab[150][8]  = {"JetFighterRun", {intensity=1}}
    tab[150][9]  = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=52, intensity=10}}
    tab[150][50] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=51, intensity=5}}
    tab[150][24] = {"JetFighterRun", {intensity=1}}
    tab[150][49] = {"JetFighterRun", {intensity=1}}
    tab[152][8]  = {"Defenders", {}}
    tab[152][12] = {"JetFighterRun", {intensity=1}}
    tab[152][24] = {"JetFighterRun", {intensity=1}}
    tab[153][44] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=53, intensity=5}}
    tab[153][45] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=50, intensity=5}}
    tab[153][46] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=54, intensity=2}}
    tab[153][50] = {"JetFighterRun", {intensity=1}}

    tab[154][25] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=55, intensity=4}}
    tab[154][26] = {"SpawnGroup", {name="Inmates", cid=Bandit.clanMap.Inmate, program="Police", d=55, intensity=14}}
    tab[154][27] = {"SpawnGroup", {name="Inmates", cid=Bandit.clanMap.Inmate, program="Police", d=59, intensity=13}}

    tab[155][5]  = {"JetFighterRun", {intensity=1}}
    tab[155][15] = {"JetFighterRun", {intensity=1}}
    tab[155][16] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=49, intensity=3}}
    tab[155][17] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=48, intensity=3}}
    tab[155][18] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=47, intensity=3}}
    tab[155][25] = {"JetFighterRun", {intensity=1}}
    tab[155][26] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=56, intensity=10}}

    tab[156][5]  = {"JetFighterRun", {intensity=1}}
    tab[156][10] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=46, intensity=12}}
    tab[156][15] = {"JetFighterRun", {intensity=1}}
    tab[156][25] = {"JetFighterRun", {intensity=1}}
    tab[156][26] = {"SpawnGroup", {name="Army", cid=Bandit.clanMap.ArmyGreenMask, program="Police", d=57, intensity=10}}

    tab[158][0]  = {"Siren", {}}
    tab[158][8]  = {"BombRun", {intensity=4}}
    tab[158][9]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.Mental, program="Bandit", d=45, intensity=12}}
    tab[158][24] = {"BombRun", {intensity=20}}
    tab[158][49] = {"BombRun", {intensity=18}}
    tab[158][51] = {"SetHydroPower", {on=false}}
    tab[158][52] = {"SetHydroPower", {on=true}}

    tab[159][8]  = {"BombRun", {intensity=6}}
    tab[159][9]  = {"SetHydroPower", {on=false}}
    tab[159][10] = {"SetHydroPower", {on=true}}
    tab[159][24] = {"BombRun", {intensity=20}}
    tab[159][25] = {"SetHydroPower", {on=false}}
    tab[159][27] = {"SetHydroPower", {on=true}}
    tab[159][49] = {"BombRun", {intensity=18}}

    tab[160][8]  = {"BombRun", {intensity=6}}
    tab[160][9]  = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=45, intensity=9}}
    tab[160][24] = {"BombRun", {intensity=20}}
    tab[160][25] = {"SetHydroPower", {on=false}}
    tab[160][26] = {"SetHydroPower", {on=true}}
    tab[160][49] = {"BombRun", {intensity=18}}
    tab[160][51] = {"SetHydroPower", {on=false}}
    tab[160][53] = {"SetHydroPower", {on=true}}

    tab[161][8]  = {"BombRun", {intensity=6}}
    tab[161][24] = {"BombRun", {intensity=20}}
    tab[161][49] = {"BombRun", {intensity=18}}
    tab[161][51] = {"SetHydroPower", {on=false}}
    tab[161][58] = {"SetHydroPower", {on=true}}

    tab[162][8]  = {"JetFighterRun", {intensity=1}}
    tab[162][24] = {"BombRun", {intensity=20}}
    tab[162][49] = {"BombRun", {intensity=18}}
    tab[162][68] = {"JetFighterRun", {intensity=1}}
    tab[162][50] = {"SetHydroPower", {on=false}}
    tab[162][51] = {"SetHydroPower", {on=true}}
    tab[163][8]  = {"BombRun", {intensity=6}}
    tab[163][15] = {"SpawnGroup", {name="Bandits", cid=Bandit.clanMap.BanditStrong, program="Bandit", d=45, intensity=5}}
    tab[163][24] = {"BombRun", {intensity=20}}
    tab[163][49] = {"BombRun", {intensity=18}}
    tab[164][8]  = {"BombRun", {intensity=6}}
    tab[164][10] = {"SetHydroPower", {on=false}}
    tab[164][13] = {"SetHydroPower", {on=true}}
    tab[164][24] = {"BombRun", {intensity=20}}
    tab[164][49] = {"BombRun", {intensity=18}}
    tab[165][2]  = {"ChopperFliers", {}}
    tab[167][4]  = {"SpawnGroup", {name="Hammer Brothers", cid=Bandit.clanMap.HammerBrothers, program="Bandit", d=50, intensity=3}}

    -- DAY 8 09.00
    tab[168][0]  = {"StartDay", {day="friday"}}
    tab[168][4]  = {"Siren", {}}
    tab[168][30] = {"FinalSolution", {}}
    tab[168][34] = {"SetHydroPower", {on=false}}

    -- late hazmat suit bandits will spawn only in fallout scenario
    tab[176][25] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=2}}
    tab[177][25] = {"SpawnGroup", {name="Hammer Brothers", cid=Bandit.clanMap.HammerBrothers, program="Bandit", d=30, intensity=3}}
    tab[189][12] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=3}}
    tab[211][44] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=4}}
    tab[235][3]  = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=3}}
    tab[236][12] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=3}}
    tab[253][42] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=7}}
    tab[315][30] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=3}}
    tab[315][11] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=4}}
    tab[333][4]  = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=8}}
    tab[376][4]  = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=8}}
    tab[400][32] = {"SpawnGroup", {name="Sweeper Squad", cid=Bandit.clanMap.Sweepers, program="Bandit", d=60, intensity=12}}

    return tab
end

BWOScheduler.Schedule = generateSchedule()

function BWOScheduler.StoreSandboxVars()
    local gmd = GetBWOModData()
    local orig = gmd.Sandbox

    storeVars = {"KeyLootNew", "MaximumLooted", "FoodLootNew", "CannedFoodLootNew", "LiteratureLootNew", "SurvivalGearsLootNew",
                 "MedicalLootNew", "WeaponLootNew", "RangedWeaponLootNew", "AmmoLootNew", "MechanicsLootNew",
                 "OtherLootNew", "ClothingLootNew", "ContainerLootNew", "MementoLootNew", "MediaLootNew",
                 "CookwareLootNew", "MaterialLootNew", "FarmingLootNew", "ToolLootNew", "MaximumRatIndex",
                 "SurvivorHouseChance", "VehicleStoryChance", "MetaEvent", "LockedHouses", "ZoneStoryChance", "AnnotatedMapChance",
                 "MaxFogIntensity", "TrafficJam", "CarSpawnRate", "Helicopter", "FireSpread"}

    for _, k in pairs(storeVars) do
        gmd.Sandbox[k] = gmd.Sandbox[k] or SandboxVars[k]
    end
end

function BWOScheduler.RestoreRepeatingPlaceEvents()

    local addPlaceEvent = function(args)
        BWOServer.Commands.PlaceEventAdd(getSpecificPlayer(0), args)
    end

    -- building emitters
    addPlaceEvent({phase="Emitter", x=13458, y=3043, z=0, len=110000, sound="ZSBuildingGigamart"}) -- gigamart lousville 
    addPlaceEvent({phase="Emitter", x=6505, y=5345, z=0, len=110000, sound="ZSBuildingGigamart"}) -- gigamart riverside
    addPlaceEvent({phase="Emitter", x=12024, y=6856, z=0, len=110000, sound="ZSBuildingGigamart"}) -- gigamart westpoint

    addPlaceEvent({phase="Emitter", x=6472, y=5266, z=0, len=42000, sound="ZSBuildingPharmabug"}) -- pharmabug riverside
    addPlaceEvent({phase="Emitter", x=13235, y=1284, z=0, len=42000, sound="ZSBuildingPharmabug"}) -- pharmabug lv
    addPlaceEvent({phase="Emitter", x=13120, y=2126, z=0, len=42000, sound="ZSBuildingPharmabug"}) -- pharmabug lv
    addPlaceEvent({phase="Emitter", x=11932, y=6804, z=0, len=42000, sound="ZSBuildingPharmabug"}) -- pharmabug westpoint

    addPlaceEvent({phase="Emitter", x=12228, y=3029, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=12998, y=3115, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=13065, y=1923, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=12660, y=1366, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=13523, y=1670, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=12520, y=1482, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=12646, y=2290, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market lv
    addPlaceEvent({phase="Emitter", x=10604, y=9612, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market muldraugh
    addPlaceEvent({phase="Emitter", x=8088, y=11560, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market rosewood
    addPlaceEvent({phase="Emitter", x=13656, y=5764, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market valley station
    addPlaceEvent({phase="Emitter", x=11660, y=7067, z=0, len=62000, sound="ZSBuildingZippee"}) -- zippee market west point

    addPlaceEvent({phase="Emitter", x=10619, y=10527, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant muldraugh
    addPlaceEvent({phase="Emitter", x=10605, y=10112, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- pizza whirled muldraugh
    addPlaceEvent({phase="Emitter", x=10647, y=9927, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- cafeteria muldraugh
    addPlaceEvent({phase="Emitter", x=10615, y=9646, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- spiffos muldraugh
    addPlaceEvent({phase="Emitter", x=10616, y=9565, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- jays muldraugh
    addPlaceEvent({phase="Emitter", x=10620, y=9513, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- pileocrepe muldraugh
    addPlaceEvent({phase="Emitter", x=12078, y=7076, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- burgers westpoint
    addPlaceEvent({phase="Emitter", x=11976, y=6812, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- spiffos westpoint
    addPlaceEvent({phase="Emitter", x=11930, y=6917, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant westpoint
    addPlaceEvent({phase="Emitter", x=11663, y=7085, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- pizza whirled westpoint
    addPlaceEvent({phase="Emitter", x=6395, y=5303, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant riverside
    addPlaceEvent({phase="Emitter", x=6189, y=5338, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- fancy restaurant riverside
    addPlaceEvent({phase="Emitter", x=6121, y=5303, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- spiffos riverside
    addPlaceEvent({phase="Emitter", x=5422, y=5914, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- diner riverside
    addPlaceEvent({phase="Emitter", x=7232, y=8202, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- burger joint doe valley
    addPlaceEvent({phase="Emitter", x=10103, y=12749, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant march ridge 
    addPlaceEvent({phase="Emitter", x=8076, y=11455, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- restaurant rosewood
    addPlaceEvent({phase="Emitter", x=8072, y=11344, z=0, len=73700, sound="ZSBuildingRestaurant"}) -- spiffos rosewood

    -- LV strip club
    addPlaceEvent({phase="BuildingParty", x=12320, y=1279, z=0, intensity=10, roomName="stripclub"})

    -- alarm emitters (only if nukes are active)
    local gmd = GetBWOModData()
    local ncnt = 0
    for _, nuke in pairs(gmd.Nukes) do
        ncnt = ncnt + 1
    end

    if ncnt > 0 then
        addPlaceEvent({phase="Emitter", x=5572, y=12489, z=0, len=2460, sound="ZSBuildingBaseAlert", light={r=1, g=0, b=0, t=10}}) -- fake control room
        addPlaceEvent({phase="Emitter", x=5575, y=12473, z=0, len=2460, sound="ZSBuildingBaseAlert", light={r=1, g=0, b=0, t=10}}) -- entrance
        addPlaceEvent({phase="Emitter", x=5562, y=12464, z=0, len=2460, sound="ZSBuildingBaseAlert", light={r=1, g=0, b=0, t=10}}) -- back

        if BanditCompatibility.GetGameVersion() >= 42 then
            addPlaceEvent({phase="Emitter", x=5556, y=12446, z=-16, len=2460, sound="ZSBuildingBaseAlert", light={r=1, g=0, b=0, t=10}}) -- real control room
        end
    end
end

function BWOScheduler.MasterControl()

    local function daysInMonth(month)
        local daysPerMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
        return daysPerMonth[month]
    end
    
    local function calculateHourDifference(startHour, startDay, startMonth, startYear, hour, day, month, year)
        local startTotalHours = startHour + (startDay - 1) * 24
        for m = 1, startMonth - 1 do
            startTotalHours = startTotalHours + daysInMonth(m) * 24
        end
        startTotalHours = startTotalHours + (startYear * 365 * 24) 
    
        local totalHours = hour + (day - 1) * 24
        for m = 1, month - 1 do
            totalHours = totalHours + daysInMonth(m) * 24
        end
        totalHours = totalHours + (year * 365 * 24) 
    
        return totalHours - startTotalHours
    end

    local function adjustSandboxVar(k, v)

        -- b41
        -- Sandbox_Rarity_option1 = "None (not recommended)",
        -- Sandbox_Rarity_option2 = "Insanely Rare",
        -- Sandbox_Rarity_option3 = "Extremely Rare",
        -- Sandbox_Rarity_option4 = "Rare",
        -- Sandbox_Rarity_option5 = "Normal",
        -- Sandbox_Rarity_option6 = "Common",
        -- Sandbox_Rarity_option7 = "Abundant",


        getSandboxOptions():set(k, v)
        SandboxVars[k] = v
    end

    local function adjustSandboxVars()
        local gmd = GetBWOModData()
        local orig = gmd.Sandbox
        adjustSandboxVar("DamageToPlayerFromHitByACar", 3)
        if BWOScheduler.WorldAge <= 64 then
            adjustSandboxVar("SurvivorHouseChance", 1)
            adjustSandboxVar("VehicleStoryChance", 1)
            adjustSandboxVar("MetaEvent", 1)
            adjustSandboxVar("LockedHouses", 1)
            adjustSandboxVar("ZoneStoryChance", 1)
            adjustSandboxVar("AnnotatedMapChance", 1)
            adjustSandboxVar("MaxFogIntensity", 4)
            adjustSandboxVar("TrafficJam", false)
            adjustSandboxVar("CarSpawnRate", 5)
            adjustSandboxVar("Helicopter", 1)
            adjustSandboxVar("FireSpread", false)
            
            -- lerp
            if BanditCompatibility.GetGameVersion() >= 42 then
                local vars = BWOCompatibility.GetSandboxOptionVars()
                local t = BWOScheduler.WorldAge / 64
                for _, var in pairs(vars) do
                    local val = (var[3] - var[2]) * t + var[2]
                    adjustSandboxVar(var[1], val)
                end
            end
        else
            adjustSandboxVar("SurvivorHouseChance", gmd.Sandbox["SurvivorHouseChance"])
            adjustSandboxVar("VehicleStoryChance", gmd.Sandbox["VehicleStoryChance"])
            adjustSandboxVar("MetaEvent", gmd.Sandbox["MetaEvent"])
            adjustSandboxVar("LockedHouses", gmd.Sandbox["LockedHouses"])
            adjustSandboxVar("ZoneStoryChance", gmd.Sandbox["ZoneStoryChance"])
            adjustSandboxVar("AnnotatedMapChance", gmd.Sandbox["AnnotatedMapChance"])
            adjustSandboxVar("MaxFogIntensity", gmd.Sandbox["MaxFogIntensity"])
            adjustSandboxVar("TrafficJam", gmd.Sandbox["TrafficJam"])
            adjustSandboxVar("CarSpawnRate", gmd.Sandbox["CarSpawnRate"])
            adjustSandboxVar("Helicopter", gmd.Sandbox["Helicopter"])
            adjustSandboxVar("FireSpread", gmd.Sandbox["FireSpread"])
        end
        
        getSandboxOptions():applySettings()
        --IsoWorld.parseDistributions()
        ItemPickerJava.InitSandboxLootSettings()
    end

    local player = getSpecificPlayer(0)
    if not player then return end

    local gametime = getGameTime()
    -- local ts = getTimestampMs()

    local startHour = gametime:getStartTimeOfDay()
    local startDay = gametime:getStartDay()
    local startMonth = gametime:getStartMonth()
    local startYear = gametime:getStartYear()

    local hour = gametime:getHour()
    local day = gametime:getDay()
    local minute = gametime:getMinutes()
    local month = gametime:getMonth()
    local year = gametime:getYear()

    -- worldAge is counter in hours
    local worldAge = calculateHourDifference(startHour, startDay, startMonth, startYear, hour, day, month, year)

    -- adjust worldage depending on the start time
    local waShiftMap = BWOScheduler.waShiftMap
    local startTimeOption = SandboxVars.BanditsWeekOne.StartTime
    local waShift = waShiftMap[startTimeOption]
    if waShift then
        worldAge = worldAge - waShift

        -- need to manually insert start at the actual start
        BWOScheduler.Schedule[-waShift] = BWOScheduler.Schedule[-waShift] or {}
        BWOScheduler.Schedule[-waShift][1] = {"Start", {}}
    end 

    -- debug to jump to a certain hour
    -- worldAge = 131

    BWOScheduler.WorldAge = worldAge
    
    adjustSandboxVars()
    
    -- set flags based on world age that control various aspects of the game

    -- world flags
    BWOScheduler.World = {}

    -- removes objects that conflict stylistically with prepandemic world
    
    BWOScheduler.World.ObjectRemover = false
    if BWOScheduler.WorldAge <= 64 then 
        BWOScheduler.World.ObjectRemover = true
    end

    -- removed initial deadbodies
    BWOScheduler.World.DeadBodyRemover = false
    if BWOScheduler.WorldAge < 48 then BWOScheduler.World.DeadBodyRemover = true end

    -- registers certain exterior objects positions that npcs can interacts with
    BWOScheduler.World.GlobalObjectAdder = false
    if BWOScheduler.WorldAge < 90 then BWOScheduler.World.GlobalObjectAdder = true end

    -- adds human corpses to simulate struggles outside of player cell
    BWOScheduler.World.DeadBodyAdderDensity = 0
    if BWOScheduler.WorldAge > 2330 then
        BWOScheduler.World.DeadBodyAdderDensity = 0
    elseif BWOScheduler.WorldAge >= 1200 then
        BWOScheduler.World.DeadBodyAdderDensity = 0.01
    elseif BWOScheduler.WorldAge >= 170 then
        BWOScheduler.World.DeadBodyAdderDensity = 0.021
    elseif BWOScheduler.WorldAge >= 150 then
        BWOScheduler.World.DeadBodyAdderDensity = 0.018
    elseif BWOScheduler.WorldAge >= 130 then
        BWOScheduler.World.DeadBodyAdderDensity = 0.014
    elseif BWOScheduler.WorldAge >= 110 then
        BWOScheduler.World.DeadBodyAdderDensity = 0.005
    end

    BWOScheduler.World.Bombing = 0

    -- transforms the world appearance to simulate post-nuclear strike
    BWOScheduler.World.PostNuclearTransformator = false
    if SandboxVars.BanditsWeekOne.EventFinalSolution and BWOScheduler.WorldAge >= 169 and BWOScheduler.WorldAge < 2330 then BWOScheduler.World.PostNuclearTransformator = true end

    -- makes the player sick and drunk after nuclear explosions
    BWOScheduler.World.PostNuclearFallout = false
    if SandboxVars.BanditsWeekOne.EventFinalSolution and BWOScheduler.WorldAge >= 171 and BWOScheduler.WorldAge < 2330 then 
        BWOScheduler.World.PostNuclearFallout = true 
        if getWorld():isHydroPowerOn() then
            getWorld():setHydroPowerOn(false)
        end
    end
    
    -- either fixes the car or removes burned or smashed cars for prepademic world
    BWOScheduler.World.VehicleFixer = false
    if BWOScheduler.WorldAge < 90 then BWOScheduler.World.VehicleFixer = true end

    -- npc logic flags
    BWOScheduler.NPC = {}

    -- controls if npcs will react to protests events
    BWOScheduler.NPC.ReactProtests = false
    if BWOScheduler.WorldAge < 129 then BWOScheduler.NPC.ReactProtests = true end

    -- controls if npcs will react to protests events
    BWOScheduler.NPC.ReactDeadBody = false
    if BWOScheduler.WorldAge < 78 then BWOScheduler.NPC.ReactDeadBody = true end

    -- controls if npcs will react to street preachers
    BWOScheduler.NPC.ReactPreacher = false
    if BWOScheduler.WorldAge < 71 then BWOScheduler.NPC.ReactPreacher = true end

    -- controls if npcs will react to street entertainers
    BWOScheduler.NPC.ReactEntertainers = false
    if BWOScheduler.WorldAge < 65 then BWOScheduler.NPC.ReactEntertainers = true end

    -- controls if npcs will sit on exterior benches
    BWOScheduler.NPC.SitBench = false
    if BWOScheduler.WorldAge < 65 then BWOScheduler.NPC.SitBench = true end

    -- controls the period in which npc will run the atms
    BWOScheduler.NPC.BankRun = false
    if BWOScheduler.WorldAge > 67 and BWOScheduler.WorldAge < 87 then BWOScheduler.NPC.BankRun = true end

    -- controls if npcs will sit on exterior benches
    BWOScheduler.NPC.Talk = false
    if BWOScheduler.WorldAge < 58 then BWOScheduler.NPC.Talk = true end

    -- controls when npc start running instead of walking by default, also cars not stopping
    BWOScheduler.NPC.Run = false
    if BWOScheduler.WorldAge > 90 then BWOScheduler.NPC.Run = true end

    -- controls when npcbarricade their homes
    BWOScheduler.NPC.Barricade = false
    if BWOScheduler.WorldAge > 72 then BWOScheduler.NPC.Barricade = true end

    -- controls functionalities that diminish during the anarchy
    BWOScheduler.Anarchy = {}

    -- if buildings emit sounds like if they are operational (church / school)
    BWOScheduler.Anarchy.BuildingOperational = true
    if BWOScheduler.WorldAge > 72 then BWOScheduler.Anarchy.BuildingOperational = false end

    -- controls if buying and earning is still possible
    BWOScheduler.Anarchy.Transactions = true
    if BWOScheduler.WorldAge > 80 then BWOScheduler.Anarchy.Transactions = false end
    
    -- controls minor crime has consequences (breaking windows)
    BWOScheduler.Anarchy.IllegalMinorCrime = true
    if BWOScheduler.WorldAge > 110 then BWOScheduler.Anarchy.IllegalMinorCrime = false end

    -- building emmiters
    if BWOScheduler.Anarchy.BuildingOperational then

        -- church
        if hour >=6 and hour < 19 then
            if minute == 0 then
                local church = BWOBuildings.FindBuildingWithRoom("church")
                if church then
                    local def = church:getDef()
                    local x = (def:getX() + def:getX2()) / 2
                    local y = (def:getY() + def:getY2()) / 2
                    local emitter = getWorld():getFreeEmitter(x, y, 0)
                    emitter:setVolumeAll(0.5)
                    emitter:tick()
                    emitter:playSound("ZSBuildingChurch")
                end
            end
        end

        -- school
        if hour >=8 and hour < 17 then
            if minute == 10 or minute == 45 then
                local school = BWOBuildings.FindBuildingWithRoom("education")
                if school then
                    local def = school:getDef()
                    local emitter = getWorld():getFreeEmitter((def:getX() + def:getX2()) / 2, (def:getY() + def:getY2()) / 2, 0)
                    emitter:setVolumeAll(0.8)
                    emitter:tick()
                    emitter:playSound("ZSBuildingSchool")
                end
            end
        end
    end

    -- general sickness control
    if worldAge < 34 then 
        BWOScheduler.SymptomLevel = 0
    elseif worldAge < 60 then
        BWOScheduler.SymptomLevel = 1
    elseif worldAge < 100 then
        BWOScheduler.SymptomLevel = 2
    elseif worldAge < 132 then
        BWOScheduler.SymptomLevel = 3
    elseif worldAge == 132 then
        BWOScheduler.SymptomLevel = 4
    else    
        BWOScheduler.SymptomLevel = 5
    end

    -- general services control
    BWOPopControl.Police.On = false
    BWOPopControl.SWAT.On = false
    BWOPopControl.Security.On = false
    BWOPopControl.Medics.On = false
    BWOPopControl.Hazmats.On = false
    BWOPopControl.Fireman.On = false

    if worldAge < 90 then
        BWOPopControl.Medics.On = true
    end

    if worldAge < 120 then
        BWOPopControl.Hazmats.On = true
    end

    if worldAge < 110 then
        BWOPopControl.Police.On = true
        BWOPopControl.SWAT.On = true
        BWOPopControl.Security.On = true
        BWOPopControl.Fireman.On = true
    end

    -- schedule processing
    -- basic parameters for all events, will be enriched by event specific params
    local params ={}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()

    if worldAge < 400 then
        if BWOScheduler.Schedule[worldAge] then
            local event = BWOScheduler.Schedule[worldAge][minute]
            if event and event[1] and event[2] then
                local eventName = event[1]
                local eventParams = event[2]
                for k, v in pairs(eventParams) do
                    params[k] = v
                end
                BWOScheduler.Add(eventName, params, 100)
            end
        end
    end
end

function BWOScheduler.Add(eventName, params, delay)
    event = {}
    event.start = BanditUtils.GetTime() + delay
    event.phase = eventName
    event.params = params
    table.insert(BWOScheduler.Events, event)
end

-- event processor
function BWOScheduler.CheckEvents()
    local player = getSpecificPlayer(0)
    if not player then return end

    local ct = BanditUtils.GetTime()
    for i, event in pairs(BWOScheduler.Events) do
        if event.start < ct then
            if BWOEvents[event.phase] then
                local profession = player:getDescriptor():getProfession()
                if not event.params.profession or event.params.profession == profession then
                    BWOEvents[event.phase](event.params)
                end
            end
            table.remove(BWOScheduler.Events, i)
            break
        end
    end
end

Events.OnTick.Add(BWOScheduler.CheckEvents)
Events.EveryOneMinute.Add(BWOScheduler.MasterControl)
Events.OnGameStart.Add(BWOScheduler.StoreSandboxVars)
Events.OnGameStart.Add(BWOScheduler.RestoreRepeatingPlaceEvents)
