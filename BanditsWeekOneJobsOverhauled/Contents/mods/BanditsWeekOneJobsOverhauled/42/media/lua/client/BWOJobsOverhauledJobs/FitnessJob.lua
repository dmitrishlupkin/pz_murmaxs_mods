local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local defaultMinRange = 5
local dailyPayout = 50
local planTotalMinutes = 30
local planMinPerTask = 10
local exercisePool = {
    { id = "squats", name = "Squats" },
    { id = "pushups", name = "Push-ups" },
    { id = "situp", name = "Sit-ups" },
    { id = "burpees", name = "Burpees" },
}

local function splitPlanMinutes(totalMinutes, count, minEach)
    local mins = {}
    local base = minEach or 0
    local remaining = totalMinutes - base * count
    if remaining < 0 then
        remaining = totalMinutes
        base = 0
    end
    for i = 1, count do
        mins[i] = base
    end
    local cuts = {}
    for i = 1, count - 1 do
        cuts[i] = ZombRand(remaining + 1)
    end
    table.sort(cuts)
    local prev = 0
    for i = 1, count - 1 do
        local add = cuts[i] - prev
        mins[i] = mins[i] + add
        prev = cuts[i]
    end
    mins[count] = mins[count] + (remaining - prev)
    return mins
end

local function hasNearbyParticipants(player, radius)
    if not BanditZombie or not BanditZombie.GetAllB then return false end
    local list = BanditZombie.GetAllB()
    local px, py = player:getX(), player:getY()
    for _, b in pairs(list) do
        local brain = b.brain
        if brain and not brain.hostile and brain.program and brain.program.name ~= "Vandal" and brain.program.name ~= "Fireman" and brain.program.name ~= "Police" and brain.program.name ~= "Medic" then
            local dist = IsoUtils.DistanceTo(px, py, b.x, b.y)
            if dist <= (radius or 10) then
                return true
            end
        end
    end
    return false
end

local function getFitnessPlan(player)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    data.fitnessPlan = data.fitnessPlan or {}
    if data.fitnessPlan.day ~= data.day then
        data.fitnessPlan = {
            day = data.day,
            paid = false,
            tasks = {},
            lastUpdateHours = nil,
            lastExerciseType = nil,
        }
        local count = math.min(ZombRand(3) + 1, #exercisePool) -- 1 to 3 tasks
        local options = {}
        for _, ex in ipairs(exercisePool) do
            table.insert(options, ex)
        end
        local minutes = splitPlanMinutes(planTotalMinutes, count, planMinPerTask)
        for i = 1, count do
            local idx = ZombRand(#options) + 1
            local ex = options[idx]
            table.remove(options, idx)
            local req = minutes[i]
            table.insert(data.fitnessPlan.tasks, { id = ex.id, name = ex.name, required = req, done = 0 })
        end
    end
    return data.fitnessPlan
end

local function normalizeExerciseType(exerciseType)
    if type(exerciseType) ~= "string" then return nil end
    local norm = exerciseType:lower()
    if norm == "situps" then
        return "situp"
    end
    return norm
end

local function getExerciseType(character, actionOrMin)
    local exerciseType
    if type(actionOrMin) == "table" then
        exerciseType = actionOrMin.exeDataType or actionOrMin.exercise
        if (not exerciseType or exerciseType == "") and actionOrMin.exeData and actionOrMin.exeData.type then
            exerciseType = actionOrMin.exeData.type
        end
    end
    if (not exerciseType or exerciseType == "") and character and character.getVariableString then
        exerciseType = character:getVariableString("ExerciseType")
    end
    return normalizeExerciseType(exerciseType)
end

local function updateFitnessProgress(player, actionOrMin)
    local plan = getFitnessPlan(player)
    if not plan or not plan.tasks then return end
    if not getGameTime then return end
    local nowHours = getGameTime():getWorldAgeHours()
    if not plan.lastUpdateHours then
        plan.lastUpdateHours = nowHours
    end
    local exerciseType = getExerciseType(player, actionOrMin)
    if not exerciseType then
        plan.lastUpdateHours = nowHours
        plan.lastExerciseType = nil
        return
    end
    if plan.lastExerciseType ~= exerciseType then
        plan.lastExerciseType = exerciseType
        plan.lastUpdateHours = nowHours
        return
    end
    local deltaMin = (nowHours - plan.lastUpdateHours) * 60
    if deltaMin <= 0 or deltaMin > 5 then
        plan.lastUpdateHours = nowHours
        return
    end
    plan.lastUpdateHours = nowHours
    for _, t in ipairs(plan.tasks) do
        if t.id == exerciseType then
            t.done = math.min((t.done or 0) + deltaMin, t.required)
        end
    end
end

local function isFitnessPlanComplete(player)
    local plan = getFitnessPlan(player)
    if not plan or not plan.tasks then return false end
    for _, t in ipairs(plan.tasks) do
        if (t.done or 0) < t.required then
            return false
        end
    end
    return true
end

local function getExerciseTaskStatus(player)
    local plan = getFitnessPlan(player)
    local status = {}
    for _, t in ipairs(plan.tasks or {}) do
        local done = tonumber(t.done) or 0
        table.insert(status, string.format("%s: %.1f/%d min", t.name, done, t.required))
    end
    return table.concat(status, " | ")
end

local function handleExercise(character, actionOrMin)
    if not character or not instanceof(character, "IsoPlayer") then return false end
    local profession = BWOJobsOverhauled.GetProfessionName(character)
    if profession ~= "fitnessInstructor" then return false end
    if not BWOJobsOverhauled.IsOnDutyAs(character, profession) then return false end
    if not BWOJobsOverhauled.IsAtWork(character) then return false end

    if BWOJobsOverhauled.UseFitnessLooped and type(actionOrMin) == "number" then
        return true
    end

    updateFitnessProgress(character, actionOrMin)

    local plan = getFitnessPlan(character)
    if not plan.paid and isFitnessPlanComplete(character) and hasNearbyParticipants(character, defaultMinRange) then
        BWOJobsOverhauled.PayEarnings(character, dailyPayout)
        plan.paid = true
        BWOJobsOverhauled.MarkTaskComplete(character, "fitness_plan")
        BWOJobsOverhauled.MarkTaskComplete(character, "fitness_task")
    end
    return true
end

local function buildJob(player, def)
    local payInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Fitness"), tostring(dailyPayout))
    local taskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Fitness"), payInfo)

    return {
        id = def.id,
        text = def.text,
        tasks = {
            {
                id = "fitness_task",
                text = taskText,
                conditions = {
                    {
                        id = "fitness_location",
                        text = text("UI_BWO_JobsOverhauled_Cond_Work_Location"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.IsAtWork(player)
                        end,
                        getStatusText = function()
                            return BWOJobsOverhauled.GetWorkBuildingName(player)
                        end,
                    },
                    {
                        id = "fitness_participants",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fitness_Participants"),
                        isLongTerm = true,
                        check = function()
                            return hasNearbyParticipants(player, defaultMinRange)
                        end,
                    },
                    {
                        id = "fitness_plan",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fitness_Plan"),
                        isLongTerm = true,
                        check = function()
                            return isFitnessPlanComplete(player)
                        end,
                        getStatusText = function()
                            return getExerciseTaskStatus(player)
                        end,
                    },
                    {
                        id = "fitness_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fitness_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.IsOnDutyAs(player, "fitnessInstructor")
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterExerciseHandler(handleExercise)
BWOJobsOverhauled.RegisterWorkShift("fitnessInstructor", { hours = 0, pay = 0 })
BWOJobsOverhauled.RegisterJob({
    id = "fitness",
    text = text("UI_BWO_JobsOverhauled_Job_Fitness"),
    professions = "fitnessInstructor",
    requiresTransactions = true,
    build = buildJob,
})
