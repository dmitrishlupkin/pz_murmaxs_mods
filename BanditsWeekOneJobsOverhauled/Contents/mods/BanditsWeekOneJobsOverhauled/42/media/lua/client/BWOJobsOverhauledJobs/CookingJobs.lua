--- @module BWOJobsOverhauledJobs.CookingJobs
--- @summary Cooking jobs: chef and burger flipper manage budget and meal quotas.
--- @details Implemented: daily budget issuance, budget spend tracking, meal handoff tracking, on-duty/work checks.
--- @todo Add AI behavior block and validate room/container restrictions for kitchens.
local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local budgetSpendRatio = 0.75

local cookingConfigs = {
    chef = {
        budget = 100,
        budgetPay = 15,
        mealPay = 60,
        budgetTaskId = "chef_budget",
        mealTaskId = "chef_meals",
        requirements = {
            { id = "pizza", items = { "Base.Pizza", "Base.PizzaWhole" }, required = 10 },
            { id = "soup", items = { "Base.SoupBowl", "Base.StewBowl" }, required = 10 },
        },
    },
    burgerflipper = {
        budget = 60,
        budgetPay = 15,
        mealPay = 35,
        budgetTaskId = "burger_budget",
        mealTaskId = "burger_meals",
        requirements = {
            { id = "burger", items = { "Base.Burger", "Base.BurgerRecipe" }, required = 10 },
        },
    },
}

local function getCookingConfig(profession)
    return cookingConfigs[profession]
end

local function getCookingData(player, profession)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    data.cooking = data.cooking or {}
    local info = data.cooking[profession]
    if not info or info.day ~= data.day then
        info = {
            day = data.day,
            budgetIssued = false,
            budgetTotal = 0,
            budgetSpent = 0,
            budgetPaid = false,
            meals = {},
            mealsPaid = false,
            mealTaken = false,
        }
        data.cooking[profession] = info
    end
    return info
end

local function getContainerSquare(container)
    local conditions = BWOJobsOverhauled.Conditions
    if conditions and conditions.GetContainerSquare then
        return conditions.GetContainerSquare(container)
    end
    return nil
end

local function isFridgeContainer(container)
    if not container or not container.getType then return false end
    local ctype = tostring(container:getType()):lower()
    return ctype:find("fridge", 1, true) ~= nil or ctype:find("freezer", 1, true) ~= nil
end

local function isContainerInWorkBuilding(player, container)
    local work = BWOJobsOverhauled.GetWorkData(player)
    if not work or not work.keyId then return false end
    local square = getContainerSquare(container)
    if not square then return false end
    local building = square:getBuilding()
    if not building then return false end
    local def = building:getDef()
    if not def then return false end
    return def:getKeyId() == work.keyId
end

local function removeItemFromContainer(container, item)
    if container and container.Remove then
        container:Remove(item)
        return true
    end
    local itemContainer = item and item.getContainer and item:getContainer() or nil
    if itemContainer and itemContainer.Remove then
        itemContainer:Remove(item)
        return true
    end
    return false
end

local function getRequirementForItem(config, itemType)
    for _, req in ipairs(config.requirements) do
        for _, t in ipairs(req.items) do
            if itemType == t then
                return req
            end
        end
    end
    return nil
end

local function isFoodItem(item)
    if not item then return false end
    if instanceof(item, "Food") then return true end
    if item.getDisplayCategory then
        local category = item:getDisplayCategory()
        if category then
            local norm = tostring(category):lower()
            if norm:find("food", 1, true) or norm:find("cooking", 1, true) then
                return true
            end
        end
    end
    return false
end

local function getItemPrice(item)
    local weight = item.getActualWeight and item:getActualWeight() or item:getWeight() or 0
    local multiplier = 1
    if SandboxVars and SandboxVars.BanditsWeekOne and SandboxVars.BanditsWeekOne.PriceMultiplier then
        multiplier = SandboxVars.BanditsWeekOne.PriceMultiplier
    end
    local price = weight * multiplier * 10
    if BanditUtils and BanditUtils.AddPriceInflation then
        price = BanditUtils.AddPriceInflation(price)
    end
    if price == 0 then price = 1 end
    return price
end

local function issueBudgetIfNeeded(player, profession, config)
    local info = getCookingData(player, profession)
    if info.budgetIssued then return end
    if not BWOJobsOverhauled.IsOnDutyAs(player, profession) then return end
    if not BWOJobsOverhauled.IsAtWork(player) then return end
    info.budgetIssued = true
    info.budgetTotal = config.budget
    info.budgetSpent = 0
    info.budgetPaid = false
    info.meals = {}
    info.mealsPaid = false
    info.mealTaken = false
    if BWOJobsOverhauled.AreTransactionsEnabled() then
        BWOJobsOverhauled.PayEarnings(player, config.budget)
    end
end

local function isBudgetComplete(player, profession, config)
    local info = getCookingData(player, profession)
    if not info.budgetIssued then return false end
    if not BWOJobsOverhauled.AreTransactionsEnabled() then return true end
    return (info.budgetSpent or 0) >= (config.budget * budgetSpendRatio)
end

local function tryPayBudget(player, profession, config)
    local info = getCookingData(player, profession)
    if info.budgetPaid then return end
    if not BWOJobsOverhauled.IsOnDutyAs(player, profession) then return end
    if not isBudgetComplete(player, profession, config) then return end
    BWOJobsOverhauled.PayEarnings(player, config.budgetPay)
    info.budgetPaid = true
    BWOJobsOverhauled.MarkTaskComplete(player, config.budgetTaskId)
end

local function isMealsComplete(player, profession, config)
    local info = getCookingData(player, profession)
    for _, req in ipairs(config.requirements) do
        local done = info.meals[req.id] or 0
        if done < req.required then
            return false
        end
    end
    return true
end

local function tryPayMeals(player, profession, config)
    local info = getCookingData(player, profession)
    if info.mealsPaid then return end
    if info.mealTaken then return end
    if not BWOJobsOverhauled.IsOnDutyAs(player, profession) then return end
    if not isMealsComplete(player, profession, config) then return end
    BWOJobsOverhauled.PayEarnings(player, config.mealPay)
    info.mealsPaid = true
    BWOJobsOverhauled.MarkTaskComplete(player, config.mealTaskId)
end

local function getBudgetStatusText(player, profession, config)
    local info = getCookingData(player, profession)
    local spent = math.floor(info.budgetSpent or 0)
    local total = info.budgetIssued and info.budgetTotal or config.budget
    return string.format(text("UI_BWO_JobsOverhauled_Status_Cooking_Budget"), tostring(spent), tostring(total))
end

local function getMealsStatusText(player, profession, config)
    local info = getCookingData(player, profession)
    local parts = {}
    for _, req in ipairs(config.requirements) do
        local name = req.name
        if not name and getItemNameFromFullType then
            name = getItemNameFromFullType(req.items[1])
        end
        name = name or req.items[1]
        local done = info.meals[req.id] or 0
        table.insert(parts, string.format("%s: %d/%d", name, done, req.required))
    end
    return table.concat(parts, " | ")
end

local function handleInventoryTransfer(data)
    if not data or not data.character or not data.item then return false end
    local player = data.character
    if not instanceof(player, "IsoPlayer") then return false end
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    local config = getCookingConfig(profession)
    if not config then return false end

    issueBudgetIfNeeded(player, profession, config)

    local srcContainer = data.srcContainer
    local destContainer = data.destContainer
    if not srcContainer or not destContainer then return false end
    local srcParent = srcContainer:getParent()
    local destParent = destContainer:getParent()
    local item = data.item
    local itemType = item:getFullType()

    if destParent and instanceof(destParent, "IsoPlayer") then
        local srcIsPlayer = srcParent and instanceof(srcParent, "IsoPlayer")
        if not srcIsPlayer then
            local info = getCookingData(player, profession)
            if info.budgetIssued and BWOJobsOverhauled.AreTransactionsEnabled() and isFoodItem(item) then
                local shouldPay = false
                if BWORooms and BWORooms.TakeIntention then
                    local srcObject = srcContainer:getParent()
                    local square
                    local customName
                    if srcObject then
                        local sprite = srcObject.getSprite and srcObject:getSprite()
                        if sprite then
                            local props = sprite:getProperties()
                            if props and props:Is("CustomName") then
                                customName = props:Val("CustomName")
                            end
                        end
                        if srcObject.getSquare then
                            square = srcObject:getSquare()
                        end
                    end
                    if not square then
                        square = player:getSquare()
                    end
                    local room = square and square:getRoom()
                    if room then
                        local _, pay = BWORooms.TakeIntention(room, customName)
                        shouldPay = pay == true
                    end
                end

                local md = item:getModData()
                md.BWO = md.BWO or {}
                if (shouldPay or md.BWO.bought) and not md.BWO.budgetCounted then
                    md.BWO.budgetCounted = true
                    info.budgetSpent = (info.budgetSpent or 0) + getItemPrice(item)
                end
            end
        end

        local req = getRequirementForItem(config, itemType)
        if req and isContainerInWorkBuilding(player, srcContainer) and isFridgeContainer(srcContainer) then
            local info = getCookingData(player, profession)
            info.mealTaken = true
            if BWOJobsOverhauled.MarkTaskFailed then
                BWOJobsOverhauled.MarkTaskFailed(player, config.mealTaskId)
            end
        end
    elseif srcParent and instanceof(srcParent, "IsoPlayer") then
        local req = getRequirementForItem(config, itemType)
        if req
            and BWOJobsOverhauled.IsOnDutyAs(player, profession)
            and isBudgetComplete(player, profession, config)
            and isContainerInWorkBuilding(player, destContainer)
            and isFridgeContainer(destContainer) then
            if removeItemFromContainer(destContainer, item) then
                local info = getCookingData(player, profession)
                info.meals[req.id] = math.min((info.meals[req.id] or 0) + 1, req.required)
            end
        end
    end

    tryPayBudget(player, profession, config)
    tryPayMeals(player, profession, config)
    return false
end

local function buildJob(player, def, profession)
    local config = getCookingConfig(profession)
    if not config then return nil end

    local percent = math.floor(budgetSpendRatio * 100)
    local budgetInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Cooking_Budget"), tostring(config.budget), tostring(config.budgetPay))
    local budgetTaskText = string.format(text("UI_BWO_JobsOverhauled_Task_Cooking_Budget"), tostring(percent))
    budgetTaskText = string.format("%s (%s)", budgetTaskText, budgetInfo)

    local mealsInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Cooking_Meals"), tostring(config.mealPay))
    local mealsTaskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Cooking_Meals"), mealsInfo)

    return {
        id = def.id,
        text = def.text,
        tasks = {
            {
                id = config.budgetTaskId,
                text = budgetTaskText,
                conditions = {
                    {
                        id = def.id .. "_budget_location",
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
                        id = def.id .. "_budget_spend",
                        text = string.format(text("UI_BWO_JobsOverhauled_Cond_Cooking_Budget"), tostring(percent)),
                        isLongTerm = true,
                        check = function()
                            return isBudgetComplete(player, profession, config)
                        end,
                        getStatusText = function()
                            return getBudgetStatusText(player, profession, config)
                        end,
                    },
                    {
                        id = def.id .. "_budget_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Cooking_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.IsOnDutyAs(player, profession)
                        end,
                    },
                },
            },
            {
                id = config.mealTaskId,
                text = mealsTaskText,
                conditions = {
                    {
                        id = def.id .. "_meals_location",
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
                        id = def.id .. "_meals_budget",
                        text = string.format(text("UI_BWO_JobsOverhauled_Cond_Cooking_Budget"), tostring(percent)),
                        isLongTerm = true,
                        check = function()
                            return isBudgetComplete(player, profession, config)
                        end,
                    },
                    {
                        id = def.id .. "_meals_notake",
                        text = text("UI_BWO_JobsOverhauled_Cond_Cooking_NoTake"),
                        isLongTerm = true,
                        check = function()
                            local info = getCookingData(player, profession)
                            return not info.mealTaken
                        end,
                    },
                    {
                        id = def.id .. "_meals_done",
                        text = text("UI_BWO_JobsOverhauled_Cond_Cooking_Meals"),
                        isLongTerm = true,
                        check = function()
                            return isMealsComplete(player, profession, config)
                        end,
                        getStatusText = function()
                            return getMealsStatusText(player, profession, config)
                        end,
                    },
                    {
                        id = def.id .. "_meals_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Cooking_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.IsOnDutyAs(player, profession)
                        end,
                    },
                },
            },
        },
    }
end

local function buildChefJob(player, def)
    return buildJob(player, def, "chef")
end

local function buildBurgerJob(player, def)
    return buildJob(player, def, "burgerflipper")
end

local function onEveryOneMinute()
    if not BWOJobsOverhauled.IsWorldReady or not BWOJobsOverhauled.IsWorldReady() then return end
    local player = getSpecificPlayer(0)
    if not player then return end
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    local config = getCookingConfig(profession)
    if not config then return end
    issueBudgetIfNeeded(player, profession, config)
    tryPayBudget(player, profession, config)
    tryPayMeals(player, profession, config)
end

BWOJobsOverhauled.RegisterInventoryTransferHandler(handleInventoryTransfer)
BWOJobsOverhauled.RegisterWorkShift("chef", { hours = 0, pay = 0 })
BWOJobsOverhauled.RegisterWorkShift("burgerflipper", { hours = 0, pay = 0 })
BWOJobsOverhauled.RegisterJob({
    id = "chef",
    text = text("UI_BWO_JobsOverhauled_Job_Chef"),
    professions = "chef",
    requiresTransactions = true,
    build = buildChefJob,
})
BWOJobsOverhauled.RegisterJob({
    id = "burgerflipper",
    text = text("UI_BWO_JobsOverhauled_Job_BurgerFlipper"),
    professions = "burgerflipper",
    requiresTransactions = true,
    build = buildBurgerJob,
})
Events.EveryOneMinute.Add(onEveryOneMinute)
