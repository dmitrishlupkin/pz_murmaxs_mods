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

    local srcContainer = data.srcContainer
    local destContainer = data.destContainer
    if not srcContainer or not destContainer then return false end
    local object = srcContainer:getParent()
    if not object or not instanceof(object, "IsoPlayer") then return false end

    local item = data.item
    if not item then return false end
    local itemType = item:getFullType()
    local md = item:getModData()
    if not md.BWO then
        md.BWO = {}
        md.BWO.stolen = false
        md.BWO.bought = false
    end
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

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "lumberjack" then return nil end

    return {
        id = "lumberjack",
        text = text("UI_BWO_JobsOverhauled_Job_Lumberjack"),
        tasks = {
            {
                id = "lumberjack_task",
                text = text("UI_BWO_JobsOverhauled_Task_Lumberjack"),
                conditions = {
                    {
                        id = "lumberjack_items",
                        text = text("UI_BWO_JobsOverhauled_Cond_Lumberjack_Carrying"),
                        check = function()
                            return BWOJobsOverhauled.HasAnyItemTypes(player, { "Base.Log", "Base.Plank" })
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
BWOJobsOverhauled.RegisterJob(buildJob)
