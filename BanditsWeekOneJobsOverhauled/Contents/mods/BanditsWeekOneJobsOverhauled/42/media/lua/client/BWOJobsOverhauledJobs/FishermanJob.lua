--- @module BWOJobsOverhauledJobs.FishermanJob
--- @summary Fisherman job: deliver fish to kitchen storage for pay, fail on theft.
--- @details Implemented: inventory-transfer payouts into restaurant/shop fridges, theft detection, on-duty checks.
--- @todo Add AI behavior block and validate fish list against base game items.
local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local fishTypes = {
    "Base.Bass",
    "Base.SmallmouthBass",
    "Base.LargemouthBass",
    "Base.SpottedBass",
    "Base.StripedBass",
    "Base.WhiteBass",
    "Base.Catfish",
    "Base.BlueCatfish",
    "Base.ChannelCatfish",
    "Base.FlatheadCatfish",
    "Base.Panfish",
    "Base.RedearSunfish",
    "Base.Crayfish",
    "Base.Crappie",
    "Base.BlackCrappie",
    "Base.WhiteCrappie",
    "Base.Perch",
    "Base.Paddlefish",
    "Base.YellowPerch",
    "Base.Pike",
    "Base.Trout",
}

local fishPriceMultiplier = 4

local function handleInventoryTransfer(data)
    if not data or not data.character then return false end
    local player = data.character
    if not instanceof(player, "IsoPlayer") then return false end
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "fisherman" then return false end
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
        local room = srcContainer:getSquare() and srcContainer:getSquare():getRoom()
        if room and BWORooms and BWORooms.IsKitchen and BWORooms.IsShop and BWORooms.IsRestaurant then
            if BWORooms.IsKitchen(room) and (BWORooms.IsRestaurant(room) or BWORooms.IsShop(room)) then
                local srcType = srcContainer:getType()
                if srcType == "fridge" or srcType == "freezer" then
                    for _, fishOption in pairs(fishTypes) do
                        if itemType == fishOption then
                            dailyData.fishermanTheft = true
                            if BWOJobsOverhauled.MarkTaskFailed then
                                BWOJobsOverhauled.MarkTaskFailed(player, "fisherman_task")
                            end
                            return true
                        end
                    end
                end
            end
        end
    end

    if dailyData.fishermanTheft then return false end

    if not srcParent or not instanceof(srcParent, "IsoPlayer") then return false end
    local md = item:getModData()
    if not md.BWO then
        md.BWO = {}
        md.BWO.stolen = false
        md.BWO.bought = false
    end
    if md.BWO.bought then return false end
    if md.BWO.stolen then return false end

    local room = destContainer:getSquare() and destContainer:getSquare():getRoom()
    if not (room and BWORooms and BWORooms.IsKitchen and BWORooms.IsShop and BWORooms.IsRestaurant) then return false end
    if not (BWORooms.IsKitchen(room) and (BWORooms.IsRestaurant(room) or BWORooms.IsShop(room))) then return false end

    local descContainerType = destContainer:getType()
    if descContainerType ~= "fridge" and descContainerType ~= "freezer" then return false end
    for _, fishOption in pairs(fishTypes) do
        if itemType == fishOption then
            local weight = item:getActualWeight()
            local price = math.floor(weight * SandboxVars.BanditsWeekOne.PriceMultiplier * fishPriceMultiplier)
            BWOJobsOverhauled.PayEarnings(player, price)
            md.BWO.stolen = true
            return true
        end
    end
    return false
end

local function buildJob(player, def)
    local payInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Fisherman"), tostring(fishPriceMultiplier))
    local taskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Fisherman"), payInfo)

    return {
        id = def.id,
        text = def.text,
        tasks = {
            {
                id = "fisherman_task",
                text = taskText,
                conditions = {
                    {
                        id = "fisherman_items",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fisherman_Carrying"),
                        check = function()
                            return BWOJobsOverhauled.HasAnyItemTypes(player, fishTypes)
                        end,
                    },
                    {
                        id = "fisherman_nosteal",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fisherman_NoTheft"),
                        isLongTerm = true,
                        check = function()
                            return not BWOJobsOverhauled.EnsureDailyData(player).fishermanTheft
                        end,
                    },
                    {
                        id = "fisherman_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fisherman_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.IsOnDutyAs(player, "fisherman")
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterInventoryTransferHandler(handleInventoryTransfer)
BWOJobsOverhauled.RegisterWorkShift("fisherman", { hours = 0, pay = 0 })
BWOJobsOverhauled.RegisterJob({
    id = "fisherman",
    text = text("UI_BWO_JobsOverhauled_Job_Fisherman"),
    professions = "fisherman",
    requiresTransactions = true,
    build = buildJob,
})
