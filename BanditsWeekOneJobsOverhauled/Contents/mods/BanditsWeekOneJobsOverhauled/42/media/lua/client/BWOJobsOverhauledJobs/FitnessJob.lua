local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "fitnessInstructor" then return nil end

    return {
        id = "fitness",
        text = text("UI_BWO_JobsOverhauled_Job_Fitness"),
        tasks = {
            {
                id = "fitness_task",
                text = text("UI_BWO_JobsOverhauled_Task_Fitness"),
                conditions = {
                    {
                        id = "fitness_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fitness_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return profession == "fitnessInstructor"
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterJob(buildJob)
