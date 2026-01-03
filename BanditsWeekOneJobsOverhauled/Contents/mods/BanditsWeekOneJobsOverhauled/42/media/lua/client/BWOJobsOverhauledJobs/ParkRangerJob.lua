local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "parkranger" then return nil end

    return {
        id = "parkranger",
        text = text("UI_BWO_JobsOverhauled_Job_ParkRanger"),
        tasks = {
            {
                id = "parkranger_task",
                text = text("UI_BWO_JobsOverhauled_Task_ParkRanger"),
                conditions = {
                    {
                        id = "parkranger_forest",
                        text = text("UI_BWO_JobsOverhauled_Cond_ParkRanger_Forest"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.IsInForestZone(player)
                        end,
                    },
                    {
                        id = "parkranger_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_ParkRanger_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return profession == "parkranger"
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterJob(buildJob)
