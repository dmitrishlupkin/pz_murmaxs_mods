local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "fireofficer" then return nil end

    return {
        id = "fire",
        text = text("UI_BWO_JobsOverhauled_Job_Fire"),
        tasks = {
            {
                id = "fire_task",
                text = text("UI_BWO_JobsOverhauled_Task_Fire"),
                conditions = {
                    {
                        id = "fire_nearby",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fire_Nearby"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.HasNearbyFire(player)
                        end,
                    },
                    {
                        id = "fire_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fire_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return profession == "fireofficer"
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterJob(buildJob)
