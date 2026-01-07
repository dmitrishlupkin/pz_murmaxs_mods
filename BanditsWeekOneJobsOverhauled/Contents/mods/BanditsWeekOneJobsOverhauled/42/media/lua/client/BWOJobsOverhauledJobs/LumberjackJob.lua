--- @module BWOJobsOverhauledJobs.LumberjackJob
--- @summary Lumberjack job: deliver logs/planks for pay, fail on theft.
--- @details Implemented: inventory-transfer payouts into work storage, theft detection, on-duty checks.
--- @todo Add AI behavior block and confirm container types for intended depots.
local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local logPayout = 10
local plankPayout = 6

local function handleInventoryTransfer(data)
    if not data or not data.character then return false end
    local player = data.character
    if not instanceof(player, "IsoPlayer") then return false end
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "lumberjack" then return false end
    if not BWOJobsOverhauled.IsOnDutyAs(player, profession) then return false end

    local dailyData = BWOJobsOverhauled.EnsureDailyData(player)

    local srcContainer = data.srcContainer
    local destContainer = data.destContainer
    if not srcContainer or not destContainer then return false end
    local srcParent = srcContainer:getParent()
    local destParent = destContainer:getParent()

    local item = data.item
    if not item then return false end
    local itemType = item:getFullType()

    if destParent and instanceof(destParent, "IsoPlayer") then
        local srcType = srcContainer:getType()
        if (itemType == "Base.Log" and srcType == "logs") or (itemType == "Base.Plank" and srcType == "crate") then
            dailyData.lumberjackTheft = true
            if BWOJobsOverhauled.MarkTaskFailed then
                BWOJobsOverhauled.MarkTaskFailed(player, "lumberjack_task")
            end
            return true
        end
    end

    if dailyData.lumberjackTheft then return false end

    if not srcParent or not instanceof(srcParent, "IsoPlayer") then return false end

    local md = item:getModData()
    if not md.BWO then
        md.BWO = {}
        md.BWO.stolen = false
        md.BWO.bought = false
    end
    if md.BWO.bought then return false end
    if md.BWO.stolen then return false end

    local descContainerType = destContainer:getType()
    if itemType == "Base.Log" and descContainerType == "logs" then
        BWOJobsOverhauled.PayEarnings(player, logPayout)
        md.BWO.stolen = true
        return true
    elseif itemType == "Base.Plank" and descContainerType == "crate" then
        BWOJobsOverhauled.PayEarnings(player, plankPayout)
        md.BWO.stolen = true
        return true
    end

    return false
end

local function buildJob(player, def)
    local payInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Lumberjack"), tostring(logPayout), tostring(plankPayout))
    local taskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Lumberjack"), payInfo)

    return {
        id = def.id,
        text = def.text,
        tasks = {
            {
                id = "lumberjack_task",
                text = taskText,
                conditions = {
                    {
                        id = "lumberjack_items",
                        text = text("UI_BWO_JobsOverhauled_Cond_Lumberjack_Carrying"),
                        check = function()
                            return BWOJobsOverhauled.HasAnyItemTypes(player, { "Base.Log", "Base.Plank" })
                        end,
                    },
                    {
                        id = "lumberjack_nosteal",
                        text = text("UI_BWO_JobsOverhauled_Cond_Lumberjack_NoTheft"),
                        isLongTerm = true,
                        check = function()
                            return not BWOJobsOverhauled.EnsureDailyData(player).lumberjackTheft
                        end,
                    },
                    {
                        id = "lumberjack_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Lumberjack_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.IsOnDutyAs(player, "lumberjack")
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterInventoryTransferHandler(handleInventoryTransfer)
BWOJobsOverhauled.RegisterWorkShift("lumberjack", { hours = 0, pay = 0 })
BWOJobsOverhauled.RegisterJob({
    id = "lumberjack",
    text = text("UI_BWO_JobsOverhauled_Job_Lumberjack"),
    professions = "lumberjack",
    requiresTransactions = true,
    build = buildJob,
})
