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

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "fisherman" then return nil end

    return {
        id = "fisherman",
        text = text("UI_BWO_JobsOverhauled_Job_Fisherman"),
        tasks = {
            {
                id = "fisherman_task",
                text = text("UI_BWO_JobsOverhauled_Task_Fisherman"),
                conditions = {
                    {
                        id = "fisherman_items",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fisherman_Carrying"),
                        check = function()
                            return BWOJobsOverhauled.HasAnyItemTypes(player, fishTypes)
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
BWOJobsOverhauled.RegisterJob(buildJob)
