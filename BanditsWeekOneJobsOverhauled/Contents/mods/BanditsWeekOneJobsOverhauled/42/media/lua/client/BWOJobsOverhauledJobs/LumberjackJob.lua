local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "lumberjack" then return nil end

    return {
        id = "lumberjack",
        text = text("UI_BWO_JobsOverhauled_Job_Lumberjack"),
        tasks = {
            {
                id = "lumberjack_task",
                text = text("UI_BWO_JobsOverhauled_Task_Lumberjack"),
                conditions = {
                    {
                        id = "lumberjack_items",
                        text = text("UI_BWO_JobsOverhauled_Cond_Lumberjack_Carrying"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.HasAnyItemTypes(player, { "Base.Log", "Base.Plank" })
                        end,
                    },
                    {
                        id = "lumberjack_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Lumberjack_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return profession == "lumberjack"
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterJob(buildJob)
