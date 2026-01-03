local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "mechanics" then return nil end

    return {
        id = "mechanic",
        text = text("UI_BWO_JobsOverhauled_Job_Mechanic"),
        tasks = {
            {
                id = "mechanic_task",
                text = text("UI_BWO_JobsOverhauled_Task_Mechanic"),
                conditions = {
                    {
                        id = "mechanic_vehicle",
                        text = text("UI_BWO_JobsOverhauled_Cond_Mechanic_Nearby"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.HasNearbyVehicle(player)
                        end,
                    },
                    {
                        id = "mechanic_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Mechanic_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return profession == "mechanics"
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterJob(buildJob)
