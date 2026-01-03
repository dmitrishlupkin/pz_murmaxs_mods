local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local shiftConfig = { hours = 4, pay = 50 }
local healPayout = 50

local function handleTimedAction(data)
    if not data or not data.character then return false end
    local player = data.character
    if not instanceof(player, "IsoPlayer") then return false end
    if data.action and data.action:getMetaType() == "TAHeal" then
        local profession = BWOJobsOverhauled.GetProfessionName(player)
        if profession == "doctor" or profession == "nurse" then
            if BWOJobsOverhauled.IsOnDutyAs(player, profession) then
                BWOJobsOverhauled.PayEarnings(player, healPayout)
            end
            return true
        end
    end
    return false
end

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "doctor" and profession ~= "nurse" then return nil end

    return {
        id = "medical",
        text = text("UI_BWO_JobsOverhauled_Job_Medical"),
        tasks = {
            {
                id = "medical_task",
                text = text("UI_BWO_JobsOverhauled_Task_Medical"),
                conditions = {
                    {
                        id = "medical_on_duty",
                        text = text("UI_BWO_JobsOverhauled_Cond_Medical_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.IsOnDutyAs(player, profession)
                        end,
                    },
                },
            },
            {
                id = "medical_shift",
                text = text("UI_BWO_JobsOverhauled_Task_WorkShift"),
                conditions = {
                    {
                        id = "medical_shift_location",
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
                        id = "medical_shift_time",
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
        },
    }
end

BWOJobsOverhauled.RegisterTimedActionHandler(handleTimedAction)
BWOJobsOverhauled.RegisterWorkShift("doctor", shiftConfig)
BWOJobsOverhauled.RegisterWorkShift("nurse", shiftConfig)
BWOJobsOverhauled.RegisterJob(buildJob)
