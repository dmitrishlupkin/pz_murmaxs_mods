local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local shiftConfig = { hours = 4, pay = 50, taskId = "police_shift" }
local policeBounty = 5

local function handleFriendlyFire(bandit, attacker)
    local player = getSpecificPlayer(0)
    if not player or not bandit or not attacker then return false end
    local brain = BanditBrain and BanditBrain.Get and BanditBrain.Get(bandit)
    if brain and bandit:getVariableBoolean("Bandit") then
        if (brain.program and brain.program.name == "Vandal") or brain.hostile then
            if instanceof(attacker, "IsoPlayer") and not attacker:isNPC() then
                if BWOJobsOverhauled.IsOnDutyAs(player, "policeofficer") then
                    BWOJobsOverhauled.PayEarnings(player, policeBounty)
                end
            end
            return true
        end
    end
    return false
end

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "policeofficer" then return nil end

    local bountyInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Police"), tostring(policeBounty))
    local bountyTaskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Police"), bountyInfo)
    local shiftPayInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Shift"), tostring(shiftConfig.pay))
    local shiftTaskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_WorkShift"), shiftPayInfo)

    return {
        id = "police",
        text = text("UI_BWO_JobsOverhauled_Job_Police"),
        tasks = {
            {
                id = "police_task",
                text = bountyTaskText,
                conditions = {
                    {
                        id = "police_threat",
                        text = text("UI_BWO_JobsOverhauled_Cond_Police_Threat"),
                        check = function()
                            return BWOJobsOverhauled.HasHostileBanditNearby(player)
                        end,
                    },
                    {
                        id = "police_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Police_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.IsOnDutyAs(player, "policeofficer")
                        end,
                    },
                },
            },
            {
                id = "police_shift",
                text = shiftTaskText,
                hideOnComplete = true,
                highlightSeconds = 5,
                conditions = {
                    {
                        id = "police_shift_location",
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
                        id = "police_shift_time",
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

BWOJobsOverhauled.RegisterFriendlyFireHandler(handleFriendlyFire)
BWOJobsOverhauled.RegisterWorkShift("policeofficer", shiftConfig)
BWOJobsOverhauled.RegisterJob(buildJob)
