local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local defaultMinRange = 5

local function activateExercise(character, min)
    if not BanditZombie or not Bandit then return end
    local activatePrograms = {"Walker", "Runner", "Inhabitant"}
    local witnessList = BanditZombie.GetAllB and BanditZombie.GetAllB() or {}
    local cnt = 0
    for _, witness in pairs(witnessList) do
        local dist = math.sqrt(math.pow(character:getX() - witness.x, 2) + math.pow(character:getY() - witness.y, 2))
        if dist < min then
            local actor = BanditZombie.GetInstanceById(witness.id)
            local canSee = actor and actor:CanSee(character)
            if canSee or dist < 3 then
                for _, prg in pairs(activatePrograms) do
                    if witness.brain and witness.brain.program and witness.brain.program.name == prg then
                        if not Bandit.HasTaskType(actor, "PushUp") then
                            Bandit.ClearTasks(actor)
                            local task = {action="PushUp", time=2000}
                            Bandit.AddTask(actor, task)
                            cnt = cnt + 1
                        end
                    end
                end
            end
        end
    end

    if cnt > 0 then
        BWOJobsOverhauled.PayEarnings(character, cnt)
    end
end

local function handleExercise(character, min)
    if not character or not instanceof(character, "IsoPlayer") then return false end
    local profession = BWOJobsOverhauled.GetProfessionName(character)
    if profession ~= "fitnessInstructor" then return false end
    if not BWOJobsOverhauled.IsOnDutyAs(character, profession) then return true end
    activateExercise(character, min or defaultMinRange)
    return true
end

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "fitnessInstructor" then return nil end

    local payInfo = text("UI_BWO_JobsOverhauled_Pay_Fitness")
    local taskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Fitness"), payInfo)

    return {
        id = "fitness",
        text = text("UI_BWO_JobsOverhauled_Job_Fitness"),
        tasks = {
            {
                id = "fitness_task",
                text = taskText,
                conditions = {
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
BWOJobsOverhauled.RegisterJob(buildJob)
