local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local function log(message)
    BWOJobsOverhauled.Log(message)
end

local function removeMoney(player, amount)
    if amount <= 0 then return end
    local inventory = player:getInventory()
    for i = 1, amount do
        inventory:RemoveOneOf("Money", true)
    end
end

local function recordTrashPickup(player, amount, paid)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    data.trashPickups = (data.trashPickups or 0) + 1
    if paid then
        data.trashEarnings = (data.trashEarnings or 0) + (amount or 0)
    end
end

local function onTimedActionPerform(data)
    if not data or not data.character then return end
    if not instanceof(data.character, "IsoPlayer") then return end
    if not BWOJobsOverhauled.AreTransactionsEnabled() then return end
    local action = data.action and data.action:getMetaType()
    if action ~= "ISMoveablesAction" then return end
    if data.mode ~= "pickup" then return end
    if not data.origSpriteName or not data.origSpriteName:embodies("trash") then return end

    local player = data.character
    local amount = 1
    local dailyData = BWOJobsOverhauled.EnsureDailyData(player)
    local current = dailyData.trashEarnings or 0
    local limit = BWOJobsOverhauled.dailyLimit or 0
    local canEarn = current + amount <= limit

    recordTrashPickup(player, amount, canEarn)
    if not canEarn then
        removeMoney(player, amount)
        log("Daily trash earnings limit reached; removing extra payment.")
    end
end

local function buildJob(player)
    local limit = BWOJobsOverhauled.dailyLimit or 0

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
                            return earnings <= limit
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

if Events and Events.OnTimedActionPerform and Events.OnTimedActionPerform.Add then
    Events.OnTimedActionPerform.Add(onTimedActionPerform)
else
    log("Events.OnTimedActionPerform not available; skipping cleaning earnings patch.")
end

BWOJobsOverhauled.RegisterJob(buildJob)
