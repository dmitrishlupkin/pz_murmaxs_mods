BWOTrespass = BWOTrespass or {}
BWOTrespass.DEBUG = true --BWOItemTags.DEBUG or false

local MOODLE_ID = "BWO:trespassing"

local function bwoLog(msg)
    if not BWOTrespass.DEBUG then return end
    print("[BWOTrespass] " .. tostring(msg))
end

local function isTrespassing(player)
    if not player then
        return false
    end

    if player.isTrespassing then
        return player:isTrespassing()
    end

    return false
end

local function ensureMoodleType()
    if BWOTrespass.moodleType then
        return BWOTrespass.moodleType
    end

    if BWORegistries and BWORegistries.MoodleTypes and BWORegistries.MoodleTypes.TRESPASSING then
        BWOTrespass.moodleType = BWORegistries.MoodleTypes.TRESPASSING
        return BWOTrespass.moodleType
    end

    if MoodleType and MoodleType.register then
        BWORegistries = BWORegistries or {}
        BWORegistries.MoodleTypes = BWORegistries.MoodleTypes or {}
        BWORegistries.MoodleTypes.TRESPASSING = MoodleType.register(MOODLE_ID)
        BWOTrespass.moodleType = BWORegistries.MoodleTypes.TRESPASSING
        return BWOTrespass.moodleType
    end

    return nil
end

local function updateTrespassMoodle(player)
    bwoLog("updateTrespassMoodle LOG1")
    if not player then
        return
    end

    bwoLog("updateTrespassMoodle LOG2")
    local moodleType = ensureMoodleType()
    if not moodleType then
        return
    end

    bwoLog("updateTrespassMoodle LOG3")
    local moodles = player:getMoodles()
    if not moodles then
        return
    end

    bwoLog("updateTrespassMoodle LOG4")
    local level = isTrespassing(player) and 1 or 0
    if moodles:getMoodleLevel(moodleType) ~= level then
        moodles:setMoodleLevel(moodleType, level)
        bwoLog("Trespass moodle level set to " .. tostring(level))
    end
end

Events.OnPlayerUpdate.Add(updateTrespassMoodle)