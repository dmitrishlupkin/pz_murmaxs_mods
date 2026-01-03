local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "policeofficer" then return nil end

    return {
        id = "police",
        text = text("UI_BWO_JobsOverhauled_Job_Police"),
        tasks = {
            {
                id = "police_task",
                text = text("UI_BWO_JobsOverhauled_Task_Police"),
                conditions = {
                    {
                        id = "police_threat",
                        text = text("UI_BWO_JobsOverhauled_Cond_Police_Threat"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.HasHostileBanditNearby(player)
                        end,
                    },
                    {
                        id = "police_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Police_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return profession == "policeofficer"
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterJob(buildJob)
