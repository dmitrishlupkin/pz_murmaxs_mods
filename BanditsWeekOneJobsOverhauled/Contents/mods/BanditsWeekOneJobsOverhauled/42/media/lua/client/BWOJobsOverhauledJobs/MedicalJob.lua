--- @module BWOJobsOverhauledJobs.MedicalJob
--- @summary Medical job: heal patients for pay plus optional shift task.
--- @details Implemented: TAHeal payout for doctors/nurses on duty, shift task when work building assigned.
--- @todo Add AI behavior block and revisit payout values for medical actions.
local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local shiftConfig = { hours = 4, pay = 50, taskId = "medical_shift" }
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

local function buildJob(player, def)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    local healInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Medical"), tostring(healPayout))
    local healTaskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Medical"), healInfo)
    local shiftPayInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Shift"), tostring(shiftConfig.pay))
    local shiftTaskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_WorkShift"), shiftPayInfo)

    local tasks = {
        {
            id = "medical_task",
            text = healTaskText,
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
    }

    local work = BWOJobsOverhauled.GetWorkData(player)
    if work and work.keyId then
        table.insert(tasks, {
            id = "medical_shift",
            text = shiftTaskText,
            hideOnComplete = true,
            highlightSeconds = 5,
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
        })
    end

    return {
        id = def.id,
        text = def.text,
        tasks = tasks,
    }
end

BWOJobsOverhauled.RegisterTimedActionHandler(handleTimedAction)
BWOJobsOverhauled.RegisterWorkShift("doctor", shiftConfig)
BWOJobsOverhauled.RegisterWorkShift("nurse", shiftConfig)
BWOJobsOverhauled.RegisterJob({
    id = "medical",
    text = text("UI_BWO_JobsOverhauled_Job_Medical"),
    professions = { "doctor", "nurse" },
    requiresTransactions = true,
    build = buildJob,
})
