require "BWOBandit"
require "BWOEvents"

BWOEvents = BWOEvents or {}

BWOEvents.DrawPlane = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    local x, y, z = params.x, params.y, params.z

    -- COCKPIT

    BanditBasePlacements.IsoObject ("bwo_airplane_01_101", x - 10, y + 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_100", x - 9, y + 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_99", x - 8, y + 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_98", x - 8, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_97", x - 7, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_96", x - 6, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_1", x - 5, y, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_32", x - 8, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_33", x - 7, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_34", x - 6, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_0", x - 5, y + 4, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_111", x - 8, y + 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_110", x - 8, y + 2, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_109", x - 8, y + 3, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_108", x - 7, y + 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_107", x - 7, y + 2, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_106", x - 7, y + 3, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_88", x - 7, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_89", x - 7, y + 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_89", x - 7, y + 2, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_87", x - 7, y + 3, z)

    -- TOILETS
    BanditBasePlacements.IsoObject ("bwo_airplane_01_60", x - 4, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_76", x - 4, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_47", x - 4, y + 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_78", x - 4, y + 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_48", x - 4, y + 2, z)
    BanditBasePlacements.IsoDoor ("bwo_airplane_01_56", x - 4, y + 2, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_47", x - 4, y + 3, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_46", x - 4, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_0", x - 4, y + 4, z)


    BanditBasePlacements.IsoObject ("bwo_airplane_01_20", x - 3, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_17", x - 3, y + 4, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_1", x - 2, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_0", x - 2, y + 4, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_1", x - 1, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_0", x - 1, y + 4, z)

    --[[
    BanditBasePlacements.IsoObject ("bwo_airplane_01_1", x - 2, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_1", x - 1, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_47", x + 0, y + 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_47", x + 0, y + 3, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_46", x + 0, y + 4, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_0", x - 3, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_0", x - 2, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_0", x - 1, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_47", x + 0, y + 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_47", x + 0, y + 3, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_46", x + 0, y + 4, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_51", x - 1, y + 2, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_51", x - 1, y + 3, z)
    ]]

    BanditBasePlacements.IsoObject ("bwo_airplane_01_61", x - 1, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_47", x - 1, y + 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_47", x - 1, y + 3, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_46", x - 1, y + 4, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_94", x - 1, y, z) -- toilet
    BanditBasePlacements.IsoObject ("bwo_airplane_01_51", x - 1, y + 2, z) -- doorframe
    BanditBasePlacements.IsoDoor ("bwo_airplane_01_73", x - 1, y + 2, z, true) -- door

    BanditBasePlacements.IsoObject ("bwo_airplane_01_51", x - 1, y + 3, z) -- doorframe
    BanditBasePlacements.IsoDoor ("bwo_airplane_01_73", x - 1, y + 3, z, true) -- door
    BanditBasePlacements.IsoObject ("bwo_airplane_01_54", x - 1, y + 4, z) -- toilet
    
    BanditBasePlacements.IsoObject ("bwo_airplane_01_61", x + 0, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_47", x + 0, y + 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_47", x + 0, y + 3, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_46", x + 0, y + 4, z)


    -- right wall
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 1, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 2, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 3, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 4, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 5, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 6, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 7, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 8, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 9, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 10, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 11, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_20", x + 12, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 13, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 14, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 15, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 16, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 17, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_10", x + 18, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_200", x + 19, y, z) -- tail starts here
    BanditBasePlacements.IsoObject ("bwo_airplane_02_201", x + 20, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_202", x + 21, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_203", x + 22, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_204", x + 23, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_197", x + 24, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_206", x + 25, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_207", x + 26, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_208", x + 27, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_209", x + 28, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_210", x + 29, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_211", x + 30, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_212", x + 31, y, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_213", x + 32, y, z)

    -- floor
    for nx = -6, 22 do
        BanditBasePlacements.IsoObject ("bwo_airplane_01_92", x + nx, y + 0, z)
        BanditBasePlacements.IsoObject ("bwo_airplane_01_89", x + nx, y + 1, z)
        BanditBasePlacements.IsoObject ("bwo_airplane_01_89", x + nx, y + 2, z)
        -- BanditBasePlacements.IsoObject ("bwo_airplane_01_68", x + nx, y + 2, z)
        BanditBasePlacements.IsoObject ("bwo_airplane_01_89", x + nx, y + 3, z)
        BanditBasePlacements.IsoObject ("bwo_airplane_01_28", x + nx, y + 4, z)
    end

    -- right seats
    for nx = 0, 22 do
        if nx ~= 12 then
            BanditBasePlacements.IsoObject ("bwo_airplane_01_27", x + nx, y, z)
            -- BWOScheduler.Add("SpawnGroupAt", {x=x+nx, y=y, z=z, size=1, program="Passenger", cid=Bandit.clanMap.Walker}, 100)
        end
    end
    for nx = 0, 22 do
        if nx ~= 12 then
            BanditBasePlacements.IsoObject ("bwo_airplane_01_26", x + nx, y + 1, z)
            BWOScheduler.Add("SpawnGroupAt", {x=x+nx, y=y+1, z=z, size=1, program="Passenger", cid=Bandit.clanMap.Walker}, 100)
        end
    end
    
    -- left seats
    for nx = 0, 22 do
        if nx ~= 12 then
            BanditBasePlacements.IsoObject ("bwo_airplane_01_25", x + nx, y + 3, z)
            BWOScheduler.Add("SpawnGroupAt", {x=x+nx, y=y+3, z=z, size=1, program="Passenger", cid=Bandit.clanMap.Walker}, 100)
        end
    end
    for nx = 0, 22 do
        if nx ~= 12 then
            BanditBasePlacements.IsoObject ("bwo_airplane_01_24", x + nx, y + 4, z)
            BWOScheduler.Add("SpawnGroupAt", {x=x+nx, y=y+4, z=z, size=1, program="Passenger", cid=Bandit.clanMap.Walker}, 100)
        end
    end

    -- left wall
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 0, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 1, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 2, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 3, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 4, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 5, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 6, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 7, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 8, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 9, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 10, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 11, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_17", x + 12, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 13, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 14, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 15, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 16, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 17, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_9", x + 18, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_128", x + 19, y + 4, z) -- tail starts here
    BanditBasePlacements.IsoObject ("bwo_airplane_02_129", x + 20, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_130", x + 21, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_131", x + 22, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_132", x + 23, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_193", x + 24, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_134", x + 25, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_135", x + 26, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_136", x + 27, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_137", x + 28, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_138", x + 29, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_139", x + 30, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_140", x + 31, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_141", x + 32, y + 4, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_142", x + 26, y + 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_143", x + 27, y + 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_144", x + 28, y + 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_145", x + 29, y + 5, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_146", x + 27, y + 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_147", x + 28, y + 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_148", x + 29, y + 6, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_149", x + 28, y + 7, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_150", x + 29, y + 7, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 0, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 1, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 2, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 3, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 4, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 5, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 6, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 7, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 8, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 9, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 10, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 11, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 12, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 13, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 14, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 15, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 16, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 17, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 18, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 19, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 20, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 21, y + 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_151", x + 22, y + 4, z - 1)

    -- left wing
    BanditBasePlacements.IsoObject ("bwo_airplane_01_112", x + 7, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_113", x + 8, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_114", x + 9, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_115", x + 10, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_116", x + 11, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_117", x + 12, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_118", x + 13, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_119", x + 14, y + 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_120", x + 15, y + 4, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_121", x + 8, y + 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_122", x + 9, y + 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_123", x + 10, y + 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_124", x + 11, y + 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_125", x + 12, y + 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_126", x + 13, y + 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_127", x + 14, y + 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_128", x + 15, y + 5, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_129", x + 8, y + 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_130", x + 9, y + 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_131", x + 10, y + 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_132", x + 11, y + 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_133", x + 12, y + 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_134", x + 13, y + 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_135", x + 14, y + 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_136", x + 15, y + 6, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_139", x + 9, y + 7, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_140", x + 10, y + 7, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_141", x + 11, y + 7, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_142", x + 12, y + 7, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_143", x + 13, y + 7, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_144", x + 14, y + 7, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_145", x + 15, y + 7, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_146", x + 6, y + 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_147", x + 7, y + 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_148", x + 8, y + 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_149", x + 9, y + 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_150", x + 10, y + 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_151", x + 11, y + 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_152", x + 12, y + 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_153", x + 13, y + 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_154", x + 14, y + 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_155", x + 15, y + 8, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_216", x + 6, y + 9, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_217", x + 7, y + 9, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_218", x + 8, y + 9, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_219", x + 9, y + 9, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_220", x + 10, y + 9, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_221", x + 11, y + 9, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_222", x + 12, y + 9, z - 1)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_156", x + 10, y + 9, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_157", x + 11, y + 9, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_158", x + 12, y + 9, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_159", x + 13, y + 9, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_160", x + 14, y + 9, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_161", x + 15, y + 9, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_162", x + 11, y + 10, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_163", x + 12, y + 10, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_164", x + 13, y + 10, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_165", x + 14, y + 10, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_166", x + 15, y + 10, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_167", x + 16, y + 10, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_168", x + 11, y + 11, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_169", x + 12, y + 11, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_170", x + 13, y + 11, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_171", x + 14, y + 11, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_172", x + 15, y + 11, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_173", x + 16, y + 11, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_174", x + 12, y + 12, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_175", x + 13, y + 12, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_176", x + 14, y + 12, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_177", x + 15, y + 12, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_178", x + 16, y + 12, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_179", x + 12, y + 13, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_180", x + 13, y + 13, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_181", x + 14, y + 13, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_182", x + 15, y + 13, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_183", x + 16, y + 13, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_184", x + 17, y + 13, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_185", x + 13, y + 14, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_186", x + 14, y + 14, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_187", x + 15, y + 14, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_188", x + 16, y + 14, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_189", x + 17, y + 14, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_190", x + 13, y + 15, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_191", x + 14, y + 15, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_192", x + 15, y + 15, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_193", x + 16, y + 15, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_194", x + 17, y + 15, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_195", x + 14, y + 16, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_196", x + 15, y + 16, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_197", x + 16, y + 16, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_198", x + 17, y + 16, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_199", x + 18, y + 16, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_200", x + 15, y + 17, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_201", x + 16, y + 17, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_202", x + 17, y + 17, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_203", x + 18, y + 17, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_204", x + 15, y + 18, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_205", x + 16, y + 18, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_206", x + 17, y + 18, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_207", x + 18, y + 18, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_208", x + 16, y + 19, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_209", x + 17, y + 19, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_210", x + 18, y + 19, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_211", x + 19, y + 19, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_01_212", x + 17, y + 20, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_213", x + 18, y + 20, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_214", x + 19, y + 20, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_01_215", x + 19, y + 20, z)


    -- right wing
    BanditBasePlacements.IsoObject ("bwo_airplane_02_0", x + 7, y - 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_1", x + 8, y - 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_2", x + 9, y - 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_3", x + 10, y - 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_4", x + 11, y - 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_5", x + 12, y - 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_6", x + 13, y - 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_7", x + 14, y - 1, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_8", x + 15, y - 1, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_9", x + 8, y - 2, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_10", x + 9, y - 2, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_11", x + 10, y - 2, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_12", x + 11, y - 2, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_13", x + 12, y - 2, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_14", x + 13, y - 2, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_15", x + 14, y - 2, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_16", x + 15, y - 2, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_17", x + 8, y - 3, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_18", x + 9, y - 3, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_19", x + 10, y - 3, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_20", x + 11, y - 3, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_21", x + 12, y - 3, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_22", x + 13, y - 3, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_23", x + 14, y - 3, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_24", x + 15, y - 3, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_25", x + 9, y - 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_26", x + 10, y - 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_27", x + 11, y - 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_28", x + 12, y - 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_29", x + 13, y - 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_30", x + 14, y - 4, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_31", x + 15, y - 4, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_32", x + 5, y - 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_33", x + 6, y - 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_34", x + 7, y - 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_35", x + 8, y - 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_36", x + 9, y - 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_37", x + 10, y - 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_38", x + 11, y - 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_39", x + 12, y - 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_40", x + 13, y - 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_41", x + 14, y - 5, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_42", x + 15, y - 5, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_112", x + 5, y - 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_113", x + 6, y - 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_114", x + 7, y - 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_115", x + 8, y - 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_116", x + 9, y - 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_117", x + 10, y - 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_118", x + 11, y - 4, z - 1)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_119", x + 12, y - 4, z - 1)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_46", x + 10, y - 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_47", x + 11, y - 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_48", x + 12, y - 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_49", x + 13, y - 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_50", x + 14, y - 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_51", x + 15, y - 6, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_52", x + 16, y - 6, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_53", x + 11, y - 7, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_54", x + 12, y - 7, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_55", x + 13, y - 7, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_56", x + 14, y - 7, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_57", x + 15, y - 7, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_58", x + 16, y - 7, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_59", x + 11, y - 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_60", x + 12, y - 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_61", x + 13, y - 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_62", x + 14, y - 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_63", x + 15, y - 8, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_64", x + 16, y - 8, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_65", x + 12, y - 9, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_66", x + 13, y - 9, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_67", x + 14, y - 9, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_68", x + 15, y - 9, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_69", x + 16, y - 9, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_70", x + 12, y - 10, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_71", x + 13, y - 10, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_72", x + 14, y - 10, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_73", x + 15, y - 10, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_74", x + 16, y - 10, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_75", x + 17, y - 10, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_76", x + 13, y - 11, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_77", x + 14, y - 11, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_78", x + 15, y - 11, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_79", x + 16, y - 11, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_80", x + 17, y - 11, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_81", x + 14, y - 12, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_82", x + 15, y - 12, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_83", x + 16, y - 12, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_84", x + 17, y - 12, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_85", x + 14, y - 13, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_86", x + 15, y - 13, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_87", x + 16, y - 13, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_88", x + 17, y - 13, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_89", x + 18, y - 13, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_90", x + 15, y - 14, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_91", x + 16, y - 14, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_92", x + 17, y - 14, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_93", x + 18, y - 14, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_95", x + 16, y - 15, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_96", x + 17, y - 15, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_97", x + 18, y - 15, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_98", x + 19, y - 15, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_99", x + 16, y - 16, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_100", x + 17, y - 16, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_101", x + 18, y - 16, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_102", x + 19, y - 16, z)

    BanditBasePlacements.IsoObject ("bwo_airplane_02_103", x + 17, y - 17, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_104", x + 18, y - 17, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_105", x + 19, y - 17, z)
    BanditBasePlacements.IsoObject ("bwo_airplane_02_106", x + 19, y - 17, z)

    BWOScheduler.Add("Emitter", {x=x+3, y=y+3, z=z, len=12000, sound="plane_inside"}, 100)
    BWOScheduler.Add("Emitter", {x=x+8, y=y+3, z=z, len=13000, sound="plane_inside"}, 100)
    BWOScheduler.Add("Emitter", {x=x+13, y=y+3, z=z, len=14000, sound="plane_inside"}, 100)
    BWOScheduler.Add("Emitter", {x=x+18, y=y+3, z=z, len=15000, sound="plane_inside"}, 100)

    BWOScheduler.Add("Effect", {x=x-30, y=y-8, z=0, size=13000, name="clouds", alpha=0.1, frameCnt=1, repCnt=311, movx=0.2, oscilateAlpha=true, infinite=true}, 500)
    BWOScheduler.Add("Effect", {x=x-31, y=y+8, z=0, size=14000, name="clouds", alpha=0.1, frameCnt=1, repCnt=397, movx=0.35, oscilateAlpha=true, infinite=true}, 600)

    player:setX(x + 1)
    player:setY(y + 1)
    player:setZ(z + 1)
    player:setLastX(x + 1)
    player:setLastY(y + 1)
    player:setLastZ(z + 1)

end

BWOVariants = BWOVariants or {}

local plane = {}
plane.name = "The Passenger"
plane.image = "media/textures/Variants/plane.png"
plane.desc = "<SIZE:large> The Passenger <BR> "
plane.desc = plane.desc .. "<SIZE:medium> Difficulty: Insane <BR> "
plane.desc = plane.desc .. "<SIZE:medium>You thought flying out was the smart move—put some distance between you and the chaos below. "
plane.desc = plane.desc .. "<SIZE:medium>The plane hums quietly above the clouds, passengers unaware that the world isn't ending. "
plane.desc = plane.desc .. "Then the coughing starts and the panic spreads faster than the air filters can handle. "
plane.desc = plane.desc .. "Up here, there's nowhere to run. If something can go wrong, it will, and it already has. <BR> "
plane.desc = plane.desc .. " - Begin mid-flight as a passenger on a commercial plane. \n"
plane.desc = plane.desc .. " - The infection has reached the aircraft, panic and chaos follow. \n"
plane.desc = plane.desc .. " - Limited space, limited options, no guns, and nowhere to escape. \n"
plane.desc = plane.desc .. " - Things escalate very quickly after the game starts. \n"

plane.timeOfWeek = 6
plane.timeOfDay = 4.50

plane.fadeIn = 1

plane.setup = function()
    local player = getSpecificPlayer(0)
    if not player then return end

    local x, y, z = 12000, 1000, 2

    player:setX(x)
    player:setY(y)
    player:setZ(z)
    player:setLastX(x)
    player:setLastY(y)
    player:setLastZ(z - z)

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

    BWOScheduler.Add("DrawPlane", {x=x, y=y, z=z}, 2000)
end

plane.schedule = {
    [139] = {
        [31] = {"SetupNukes", {}},
        [32] = {"SetupPlaceEvents", {}},
        [33] = {"StartDay", {day="thursday"}},
    },
    [144] = {
        [0] = {"StartDay", {day="thursday"}},
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

table.insert(BWOVariants, plane)
