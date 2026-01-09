--- @module BWOJobsOverhauledJobs.ErrandsJob
--- @summary Extra errands for all professions: debt to bandits and visit a friend.
--- @details Implemented: daily offers, neutral collector, payment tracking, friend visit, optional raid on failure.
--- @todo Expand dialogue variety and refine raid tuning/targeting.
local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local debtOfferId = "errand_bandit_debt"
local friendOfferId = "errand_visit_friend"
local debtChance = 0.95
local friendChance = 0.95
local debtMin = 100
local debtMax = 200
local debtDayStart = 6
local debtDayEnd = 21

local function getDebtOffer(player)
    return BWOJobsOverhauled.GetDailyOffer and BWOJobsOverhauled.GetDailyOffer(player, debtOfferId) or nil
end

local function getFriendOffer(player)
    return BWOJobsOverhauled.GetDailyOffer and BWOJobsOverhauled.GetDailyOffer(player, friendOfferId) or nil
end

local function getDebtData(player)
    local offer = getDebtOffer(player)
    return offer and offer.data or nil
end

local function getFriendData(player)
    local offer = getFriendOffer(player)
    return offer and offer.data or nil
end

local function isPlayerInSessionRoom(player, data)
    if not player or not data then return false end
    if data.roomName and data.roomName ~= "" then
        local room = player:getSquare() and player:getSquare():getRoom()
        if not room then return false end
        local name = room:getName()
        if BWORooms and BWORooms.GetRealRoomName then
            name = BWORooms.GetRealRoomName(room)
        end
        if name ~= data.roomName then
            return false
        end
    end
    if data.buildingKeyId then
        local building = player:getBuilding()
        local def = building and building:getDef()
        if not def or def:getKeyId() ~= data.buildingKeyId then
            return false
        end
    end
    return true
end

local function isPointInBase(data, x, y)
    if not data then return false end
    if not data.base then return false end
    return x >= data.base.x and x <= data.base.x2 and y >= data.base.y and y <= data.base.y2
end

local function isPlayerInBase(player, data)
    if not player or not data then return false end
    return isPointInBase(data, player:getX(), player:getY())
end

local function getBaseLabel(data)
    if not data or not data.base then return "" end
    if data.zoneLabel and data.zoneLabel ~= "" then
        return data.zoneLabel
    end
    local cx = (data.base.x + data.base.x2) / 2
    local cy = (data.base.y + data.base.y2) / 2
    return BWOJobsOverhauled.GetZoneLabelAt(cx, cy, 0) or ""
end

local function isDaytime()
    if not BWOJobsOverhauled.Conditions or not BWOJobsOverhauled.Conditions.IsWithinHours then
        return true
    end
    return BWOJobsOverhauled.Conditions.IsWithinHours(debtDayStart, debtDayEnd)
end

local function findCollector(base)
    if not BanditZombie or not BanditZombie.GetAllB then return nil end
    local candidates = {}
    for _, bandit in pairs(BanditZombie.GetAllB()) do
        local npc = bandit
        if bandit and not bandit.getModData and BanditZombie.GetInstanceById and bandit.id then
            npc = BanditZombie.GetInstanceById(bandit.id)
        end
        if npc then
            local x, y = npc:getX(), npc:getY()
            if x >= base.x and x <= base.x2 and y >= base.y and y <= base.y2 then
                table.insert(candidates, npc)
            end
        end
    end
    if #candidates == 0 then return nil end
    return candidates[ZombRand(#candidates) + 1]
end

local function assignDebtOffer(player, offer)
    if not BanditPlayerBase or not BanditPlayerBase.GetBaseClosest then return nil end
    local baseId, base = BanditPlayerBase.GetBaseClosest(player)
    if not base or not base.x or not base.x2 then return nil end

    local collector = findCollector(base)
    if not collector then return nil end

    local amount = ZombRand(debtMax - debtMin + 1) + debtMin
    local cx = (base.x + base.x2) / 2
    local cy = (base.y + base.y2) / 2
    local zoneLabel = BWOJobsOverhauled.GetZoneLabelAt(cx, cy, 0)

    return {
        amount = amount,
        paidAmount = 0,
        talked = false,
        completed = false,
        base = { x = base.x, y = base.y, x2 = base.x2, y2 = base.y2 },
        collectorId = collector.id or (BanditUtils and BanditUtils.GetCharacterID and BanditUtils.GetCharacterID(collector)),
        collectorSpot = { x = math.floor(cx), y = math.floor(cy), z = 0 },
        zoneLabel = zoneLabel,
    }
end

local function findFriend()
    if not BanditZombie or not BanditZombie.GetAllB then return nil end
    local preferred = {}
    local fallback = {}
    for _, bandit in pairs(BanditZombie.GetAllB()) do
        local npc = bandit
        if bandit and not bandit.getModData and BanditZombie.GetInstanceById and bandit.id then
            npc = BanditZombie.GetInstanceById(bandit.id)
        end
        if npc then
            local brain = npc.brain or (BanditBrain and BanditBrain.Get and BanditBrain.Get(npc))
            if brain and not brain.hostile then
                local program = brain.program and brain.program.name or ""
                local building = npc:getSquare() and npc:getSquare():getBuilding()
                if building then
                    if program == "Companion" or program == "CompanionGuard" or program == "Babe" then
                        table.insert(preferred, npc)
                    else
                        table.insert(fallback, npc)
                    end
                end
            end
        end
    end
    local list = #preferred > 0 and preferred or fallback
    if #list == 0 then return nil end
    return list[ZombRand(#list) + 1]
end

local function assignFriendOffer(player, offer)
    local conditions = BWOJobsOverhauled.Conditions
    local friend = findFriend()
    if not friend then return nil end
    local building = friend:getSquare() and friend:getSquare():getBuilding()
    if not building then return nil end

    local roomSquare, roomName
    if conditions and conditions.FindRoomSquareInBuilding then
        roomSquare, roomName = conditions.FindRoomSquareInBuilding(building, conditions.ResidentialRoomNames)
    end
    if not roomSquare then return nil end

    if BWOJobsOverhauled.AddVisitBuilding then
        BWOJobsOverhauled.AddVisitBuilding(player, building, { allowTake = true })
    end

    local def = building:getDef()
    local keyId = def and def:getKeyId() or nil
    return {
        friendId = friend.id or (BanditUtils and BanditUtils.GetCharacterID and BanditUtils.GetCharacterID(friend)),
        buildingKeyId = keyId,
        roomName = roomName,
        room = { x = roomSquare:getX(), y = roomSquare:getY(), z = roomSquare:getZ() },
        talked = false,
        completed = false,
    }
end

local function getCollector(player, data)
    if not data or not data.collectorId then return nil end
    if BanditZombie and BanditZombie.GetInstanceById then
        return BanditZombie.GetInstanceById(data.collectorId)
    end
    return nil
end

local function getFriendNPC(player, data)
    if not data or not data.friendId then return nil end
    if BanditZombie and BanditZombie.GetInstanceById then
        return BanditZombie.GetInstanceById(data.friendId)
    end
    return nil
end

local function triggerDebtRaid(player, data)
    if data.raidTriggered then return end
    data.raidTriggered = true
    local params = {
        name = "Bandits",
        cid = Bandit and Bandit.clanMap and (Bandit.clanMap.CriminalBlack or Bandit.clanMap.BanditSpike) or nil,
        program = "Bandit",
        d = 60,
        intensity = 4,
    }
    if not params.cid then
        if BWOJobsOverhauled and BWOJobsOverhauled.Log then
            BWOJobsOverhauled.Log("Unable to trigger debt raid: clan id missing")
        end
        return
    end
    if BWOScheduler and BWOScheduler.Add then
        BWOScheduler.Add("SpawnGroup", params, 100)
    elseif BWOEvents and BWOEvents.SpawnGroup then
        BWOEvents.SpawnGroup(params)
    else
        if BWOJobsOverhauled and BWOJobsOverhauled.Log then
            BWOJobsOverhauled.Log("Unable to trigger debt raid: scheduler not available")
        end
    end
end

local function updateDebt(player)
    local data = getDebtData(player)
    if not data or data.completed then return end
    if BWOJobsOverhauled.IsTaskComplete(player, debtOfferId)
        or BWOJobsOverhauled.IsTaskFailed(player, debtOfferId) then
        data.completed = true
        return
    end

    local collector = getCollector(player, data)
    if collector and not data.talked then
        local dist = IsoUtils.DistanceTo(player:getX(), player:getY(), collector:getX(), collector:getY())
        if dist <= 2 and isPlayerInBase(player, data) then
            collector:addLineChatElement(tostring(text("UI_BWO_JobsOverhauled_Debt_Line1")), 1, 1, 1)
            data.talked = true
        end
    end

    if not isDaytime() and (data.paidAmount or 0) < (data.amount or 0) then
        triggerDebtRaid(player, data)
        BWOJobsOverhauled.MarkTaskFailed(player, debtOfferId)
        data.completed = true
    end

    if (data.paidAmount or 0) >= (data.amount or 0) and data.talked then
        BWOJobsOverhauled.MarkTaskComplete(player, debtOfferId)
        data.completed = true
    end
end

local function updateFriend(player)
    local data = getFriendData(player)
    if not data or data.completed then return end
    if BWOJobsOverhauled.IsTaskComplete(player, friendOfferId)
        or BWOJobsOverhauled.IsTaskFailed(player, friendOfferId) then
        data.completed = true
        return
    end

    local friend = getFriendNPC(player, data)
    if friend and not data.talked then
        local dist = IsoUtils.DistanceTo(player:getX(), player:getY(), friend:getX(), friend:getY())
        if dist <= 2 then
            friend:addLineChatElement(tostring(text("UI_BWO_JobsOverhauled_Friend_Line1")), 1, 1, 1)
            data.talked = true
            data.completed = true
            BWOJobsOverhauled.MarkTaskComplete(player, friendOfferId)
        end
    end
end

local function isMoneyItem(item)
    if not item then return false end
    local fullType = item.getFullType and item:getFullType() or nil
    if fullType == "Base.Money" then
        return true
    end
    local itemType = item.getType and item:getType() or nil
    return itemType == "Money"
end

local function handleInventoryTransfer(data)
    if not data or not data.character or not data.item then return false end
    local player = data.character
    if not instanceof(player, "IsoPlayer") then return false end
    if not isMoneyItem(data.item) then return false end
    if not BWOJobsOverhauled.Conditions or not BWOJobsOverhauled.Conditions.IsTransferFromPlayer then return false end
    if not BWOJobsOverhauled.Conditions.IsTransferFromPlayer(data) then return false end

    local debt = getDebtData(player)
    if not debt or debt.completed then return false end
    if not isDaytime() then return false end

    local square = BWOJobsOverhauled.Conditions.GetContainerSquare(data.destContainer)
    if not square then return false end
    if not isPointInBase(debt, square:getX(), square:getY()) then return false end

    debt.paidAmount = (debt.paidAmount or 0) + 1
    if (debt.paidAmount or 0) >= (debt.amount or 0) and debt.talked then
        BWOJobsOverhauled.MarkTaskComplete(player, debtOfferId)
        debt.completed = true
    end
    return true
end

local function buildJob(player, def)
    local debtText = text("UI_BWO_JobsOverhauled_Task_Debt")
    local friendText = text("UI_BWO_JobsOverhauled_Task_Friend")

    return {
        id = def.id,
        text = def.text,
        tasks = {
            {
                id = debtOfferId,
                text = debtText,
                isDaily = true,
                payOnComplete = false,
                issueConditions = {
                    {
                        id = "debt_offer",
                        check = function()
                            return BWOJobsOverhauled.IsDailyOfferActive(player, debtOfferId)
                        end,
                    },
                },
                conditions = {
                    {
                        id = "debt_location",
                        text = text("UI_BWO_JobsOverhauled_Cond_Debt_Location"),
                        isLongTerm = true,
                        check = function()
                            return isPlayerInBase(player, getDebtData(player))
                        end,
                        getStatusText = function()
                            return getBaseLabel(getDebtData(player))
                        end,
                    },
                    {
                        id = "debt_talk",
                        text = text("UI_BWO_JobsOverhauled_Cond_Debt_Talk"),
                        isLongTerm = true,
                        check = function()
                            local data = getDebtData(player)
                            return data and data.talked == true
                        end,
                    },
                    {
                        id = "debt_pay",
                        text = text("UI_BWO_JobsOverhauled_Cond_Debt_Pay"),
                        isLongTerm = true,
                        check = function()
                            local data = getDebtData(player)
                            return data and (data.paidAmount or 0) >= (data.amount or 0)
                        end,
                        getStatusText = function()
                            local data = getDebtData(player)
                            if not data then return "" end
                            return string.format(text("UI_BWO_JobsOverhauled_Status_Debt_Pay"), tostring(data.paidAmount or 0), tostring(data.amount or 0))
                        end,
                    },
                },
                ai = {
                    id = "errand_debt_ai",
                    priority = 30,
                    stickyMinutes = 60,
                    onlyWhenIssued = true,
                    allowHidden = true,
                    active = function(player)
                        local data = getDebtData(player)
                        return data ~= nil and not data.completed
                    end,
                    context = function(ctx)
                        local data = getDebtData(ctx.player)
                        if not data then return nil end
                        return {
                            debt = data,
                            debtSpot = data.collectorSpot,
                        }
                    end,
                    roles = {
                        {
                            id = "collector",
                            count = 1,
                            selector = {
                                custom = function(npc, ctx)
                                    if not ctx.debt or not ctx.debt.collectorId then return false end
                                    local npcId = npc.id
                                    if not npcId and BanditUtils and BanditUtils.GetCharacterID then
                                        npcId = BanditUtils.GetCharacterID(npc)
                                    end
                                    return npcId == ctx.debt.collectorId
                                end,
                            },
                            actions = {
                                { type = "SetHostile", hostile = false },
                                { type = "MoveTo", target = "debtSpot", radius = 2, tag = "debt_move" },
                                { type = "Wait", anim = "Idle", time = 200, tag = "debt_wait" },
                            },
                        },
                    },
                },
            },
            {
                id = friendOfferId,
                text = friendText,
                isDaily = true,
                payOnComplete = false,
                issueConditions = {
                    {
                        id = "friend_offer",
                        check = function()
                            return BWOJobsOverhauled.IsDailyOfferActive(player, friendOfferId)
                        end,
                    },
                },
                conditions = {
                    {
                        id = "friend_location",
                        text = text("UI_BWO_JobsOverhauled_Cond_Friend_Location"),
                        isLongTerm = true,
                        check = function()
                            local data = getFriendData(player)
                            return isPlayerInSessionRoom(player, data)
                        end,
                    },
                    {
                        id = "friend_talk",
                        text = text("UI_BWO_JobsOverhauled_Cond_Friend_Talk"),
                        isLongTerm = true,
                        check = function()
                            local data = getFriendData(player)
                            return data and data.talked == true
                        end,
                    },
                },
                ai = {
                    id = "errand_friend_ai",
                    priority = 30,
                    stickyMinutes = 60,
                    onlyWhenIssued = true,
                    allowHidden = true,
                    active = function(player)
                        local data = getFriendData(player)
                        return data ~= nil and not data.completed
                    end,
                    context = function(ctx)
                        local data = getFriendData(ctx.player)
                        if not data then return nil end
                        return {
                            friend = data,
                            friendRoom = data.room,
                        }
                    end,
                    roles = {
                        {
                            id = "friend",
                            count = 1,
                            selector = {
                                custom = function(npc, ctx)
                                    if not ctx.friend or not ctx.friend.friendId then return false end
                                    local npcId = npc.id
                                    if not npcId and BanditUtils and BanditUtils.GetCharacterID then
                                        npcId = BanditUtils.GetCharacterID(npc)
                                    end
                                    return npcId == ctx.friend.friendId
                                end,
                            },
                            actions = {
                                { type = "SetAlly" },
                                { type = "MoveTo", target = "friendRoom", radius = 2, tag = "friend_move" },
                                { type = "Wait", anim = "Idle", time = 200, tag = "friend_wait" },
                            },
                        },
                    },
                },
            },
        },
    }
end

local function onEveryOneMinute()
    if not BWOJobsOverhauled.IsWorldReady() then return end
    local player = getSpecificPlayer(0)
    if not player then return end
    updateDebt(player)
    updateFriend(player)
end

BWOJobsOverhauled.RegisterInventoryTransferHandler(handleInventoryTransfer)
BWOJobsOverhauled.RegisterDailyTaskOffer({
    id = debtOfferId,
    chance = debtChance,
    requiresTransactions = true,
    onAssign = assignDebtOffer,
})
BWOJobsOverhauled.RegisterDailyTaskOffer({
    id = friendOfferId,
    chance = friendChance,
    requiresTransactions = true,
    onAssign = assignFriendOffer,
})
BWOJobsOverhauled.RegisterJob({
    id = "errands",
    text = text("UI_BWO_JobsOverhauled_Job_Errands"),
    build = buildJob,
})

if not BWOJobsOverhauled.ErrandsUpdater then
    BWOJobsOverhauled.ErrandsUpdater = true
    Events.EveryOneMinute.Add(onEveryOneMinute)
end
