local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local dailyLimit = 100
local trashPickupPay = 1

local function recordTrashPickup(player, amount, paid)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    data.trashPickups = (data.trashPickups or 0) + 1
    if paid then
        data.trashEarnings = (data.trashEarnings or 0) + (amount or 0)
    end
end

local function handleTimedAction(data)
    if not data or not data.character then return false end
    local player = data.character
    if not instanceof(player, "IsoPlayer") then return false end
    local action = data.action and data.action:getMetaType()
    if action ~= "ISMoveablesAction" then return false end
    if data.mode ~= "pickup" then return false end
    if not data.origSpriteName or not data.origSpriteName:embodies("trash") then return false end

    local _, earnings = BWOJobsOverhauled.GetDailyTrashData(player)
    local canEarn = earnings + trashPickupPay < dailyLimit
    recordTrashPickup(player, trashPickupPay, canEarn)
    if canEarn then
        BWOJobsOverhauled.PayEarnings(player, trashPickupPay)
    end
    return true
end

local function buildJob(player)
    return {
        id = "cleaning",
        text = text("UI_BWO_JobsOverhauled_Job_Cleaning"),
        tasks = {
            {
                id = "cleaning_task",
                text = text("UI_BWO_JobsOverhauled_Task_Cleaning"),
                conditions = {
                    {
                        id = "cleaning_pickup",
                        text = text("UI_BWO_JobsOverhauled_Cond_Cleaning_Pickup"),
                        check = function()
                            local pickups = BWOJobsOverhauled.GetDailyTrashData(player)
                            return pickups > 0
                        end,
                    },
                    {
                        id = "cleaning_limit",
                        text = text("UI_BWO_JobsOverhauled_Cond_Cleaning_Limit"),
                        isLongTerm = true,
                        check = function()
                            local _, earnings = BWOJobsOverhauled.GetDailyTrashData(player)
                            return earnings < dailyLimit
                        end,
                        getStatusText = function()
                            local _, earnings = BWOJobsOverhauled.GetDailyTrashData(player)
                            return string.format(text("UI_BWO_JobsOverhauled_Status_Cleaning_MadeToday"), tostring(earnings))
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterTimedActionHandler(handleTimedAction)
BWOJobsOverhauled.RegisterJob(buildJob)
