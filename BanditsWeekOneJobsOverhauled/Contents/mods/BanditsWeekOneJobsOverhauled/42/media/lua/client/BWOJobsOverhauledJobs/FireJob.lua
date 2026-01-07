local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local shiftConfig = { hours = 4, pay = 50, taskId = "fire_shift" }
local firePayout = 25

local function handleTimedAction(data)
    if not data or not data.character then return false end
    local player = data.character
    if not instanceof(player, "IsoPlayer") then return false end
    if data.action and data.action:getMetaType() == "ISPutOutFire" then
        if BWOJobsOverhauled.IsOnDutyAs(player, "fireofficer") then
            BWOJobsOverhauled.PayEarnings(player, firePayout)
        end
        return true
    end
    return false
end

local function buildJob(player, def)
    local firePayInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Fire"), tostring(firePayout))
    local fireTaskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Fire"), firePayInfo)
    local shiftPayInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Shift"), tostring(shiftConfig.pay))
    local shiftTaskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_WorkShift"), shiftPayInfo)

    local tasks = {
        {
            id = "fire_task",
            text = fireTaskText,
            conditions = {
                {
                    id = "fire_nearby",
                    text = text("UI_BWO_JobsOverhauled_Cond_Fire_Nearby"),
                    check = function()
                        return BWOJobsOverhauled.HasNearbyFire(player)
                    end,
                },
                {
                    id = "fire_profession",
                    text = text("UI_BWO_JobsOverhauled_Cond_Fire_OnDuty"),
                    isLongTerm = true,
                    check = function()
                        return BWOJobsOverhauled.IsOnDutyAs(player, "fireofficer")
                    end,
                },
            },
        },
    }

    local work = BWOJobsOverhauled.GetWorkData(player)
    if work and work.keyId then
        table.insert(tasks, {
            id = "fire_shift",
            text = shiftTaskText,
            hideOnComplete = true,
            highlightSeconds = 5,
            conditions = {
                {
                    id = "fire_shift_location",
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
                    id = "fire_shift_time",
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
BWOJobsOverhauled.RegisterWorkShift("fireofficer", shiftConfig)
BWOJobsOverhauled.RegisterJob({
    id = "fire",
    text = text("UI_BWO_JobsOverhauled_Job_Fire"),
    professions = "fireofficer",
    requiresTransactions = true,
    build = buildJob,
})
