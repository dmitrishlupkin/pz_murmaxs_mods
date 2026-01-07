--- @module BWOJobsOverhauledJobs.CleaningJob
--- @summary Cleaning job: earn for trash pickup, fail if dumping trash, daily cap.
--- @details Implemented: pickup/place moveables handler, floor-dump detection, daily counters,
---          task conditions for pickups/no dump/earnings cap.
--- @todo Add AI behavior block and revisit payout/limits tuning.
local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local dailyLimit = 100
local trashPickupPay = 1

local function markTrashDumped(player)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    data.trashDumped = true
    if BWOJobsOverhauled.MarkTaskFailed then
        BWOJobsOverhauled.MarkTaskFailed(player, "cleaning_task")
    end
end

local function canCleanToday(player)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    return data.trashDumped ~= true
end

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
    if not data.origSpriteName or not data.origSpriteName:embodies("trash") then return false end

    if data.mode == "place" then
        markTrashDumped(player)
        return true
    end

    if data.mode ~= "pickup" then return false end
    if not canCleanToday(player) then return true end

    local _, earnings = BWOJobsOverhauled.GetDailyTrashData(player)
    local canEarn = earnings + trashPickupPay < dailyLimit
    recordTrashPickup(player, trashPickupPay, canEarn)
    if canEarn then
        BWOJobsOverhauled.PayEarnings(player, trashPickupPay)
    end
    return true
end

local function isTrashItem(item)
    if not item then return false end
    if item.getTags then
        local ok, tags = pcall(item.getTags, item)
        if ok and tags then
            for i = 0, tags:size() - 1 do
                local tag = tags:get(i)
                if tag == "Trash" or tag == "Junk" then
                    return true
                end
            end
        end
    end
    if item.getDisplayCategory then
        local category = item:getDisplayCategory()
        if category then
            local norm = tostring(category):lower()
            if norm:find("junk", 1, true) or norm:find("trash", 1, true) then
                return true
            end
        end
    end
    if item.getType then
        local itemType = item:getType()
        if type(itemType) == "string" and itemType:lower():find("trash", 1, true) then
            return true
        end
    end
    if item.getWorldSprite then
        local sprite = item:getWorldSprite()
        if type(sprite) == "string" and sprite:embodies("trash") then
            return true
        end
    end
    return false
end

local function isFloorContainer(container)
    if not container then return false end
    local containerType = container:getType()
    if containerType == "floor" then return true end
    local parent = container:getParent()
    if parent and instanceof(parent, "IsoGridSquare") then
        return true
    end
    return false
end

local function handleInventoryTransfer(data)
    if not data or not data.character or not data.item then return false end
    local player = data.character
    if not instanceof(player, "IsoPlayer") then return false end
    if not isTrashItem(data.item) then return false end
    local destContainer = data.destContainer
    if not destContainer then return false end
    if not isFloorContainer(destContainer) then return false end
    markTrashDumped(player)
    return true
end

local function buildJob(player, def)
    local payInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Cleaning"), tostring(trashPickupPay), tostring(dailyLimit))
    local taskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Cleaning"), payInfo)
    return {
        id = def.id,
        text = def.text,
        tasks = {
            {
                id = "cleaning_task",
                text = taskText,
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
                        id = "cleaning_nodump",
                        text = text("UI_BWO_JobsOverhauled_Cond_Cleaning_NoDump"),
                        isLongTerm = true,
                        check = function()
                            return canCleanToday(player)
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
BWOJobsOverhauled.RegisterInventoryTransferHandler(handleInventoryTransfer)
BWOJobsOverhauled.RegisterJob({
    id = "cleaning",
    text = text("UI_BWO_JobsOverhauled_Job_Cleaning"),
    requiresTransactions = true,
    build = buildJob,
})
