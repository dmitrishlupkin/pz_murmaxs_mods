local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local shiftConfig = { hours = 6, pay = 40, taskId = "security_shift" }

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "securityguard" then return nil end

    local shiftPayInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Shift"), tostring(shiftConfig.pay))
    local shiftTaskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_WorkShift"), shiftPayInfo)

    local tasks = {
        {
            id = "security_shift",
            text = shiftTaskText,
            hideOnComplete = true,
            highlightSeconds = 5,
            conditions = {
                {
                    id = "security_shift_location",
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
                    id = "security_shift_time",
                    text = string.format(text("UI_BWO_JobsOverhauled_Cond_Work_Time"), tostring(shiftConfig.hours)),
                    isLongTerm = true,
                    check = function()
                        return BWOJobsOverhauled.IsWorkShiftComplete(player)
                    end,
                    getStatusText = function()
                        return BWOJobsOverhauled.GetWorkShiftStatus(player)
                    end,
                },
            },
        },
    }

    return {
        id = "security",
        text = text("UI_BWO_JobsOverhauled_Job_Security"),
        tasks = tasks,
    }
end

BWOJobsOverhauled.RegisterWorkShift("securityguard", shiftConfig)
BWOJobsOverhauled.RegisterJob(buildJob)
