--- @module BWOJobsOverhauledJobs.PoliceJob
--- @summary Police job: earn bounties on hostile bandits, complete shifts, attend briefings.
--- @details Implemented: bounty payout on hostile bandits, shift tracking, daily briefing task with NPC meeting and speech.
--- @todo Add richer AI meeting animations/positions and tune briefing timing/payouts.
local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local shiftConfig = { hours = 4, pay = 50, taskId = "police_shift" }
local policeBounty = 5

local briefingOfferId = "police_briefing"
local briefingAiId = "police_briefing_ai"
local briefingPay = 25
local briefingDurationMinutes = 30
local briefingRequiredRatio = 0.7
local briefingOfferChance = 0.95
local briefingLineKeys = {
    "UI_BWO_JobsOverhauled_Police_Briefing_Line1",
    "UI_BWO_JobsOverhauled_Police_Briefing_Line2",
    "UI_BWO_JobsOverhauled_Police_Briefing_Line3",
}

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

local function getBriefingOffer(player)
    if not BWOJobsOverhauled.GetDailyOffer then return nil end
    return BWOJobsOverhauled.GetDailyOffer(player, briefingOfferId)
end

local function getBriefingData(player)
    local offer = getBriefingOffer(player)
    return offer and offer.data or nil
end

local function getBriefingRoomLabel(data)
    if data and data.roomName and data.roomName ~= "" then
        return data.roomName
    end
    return BWOJobsOverhauled.GetWorkBuildingName(getSpecificPlayer(0))
end

local function getBriefingAttendanceStatus(data)
    if not data then return "" end
    local done = math.floor(data.attendedMinutes or 0)
    local required = math.floor(data.requiredMinutes or 0)
    return string.format(text("UI_BWO_JobsOverhauled_Status_Police_Briefing_Attendance"), tostring(done), tostring(required))
end

local function isPlayerInBriefingRoom(player, data)
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

local function getBriefingChief(player)
    if not BWOJobsOverhauled.AI then return nil end
    local roleKey = BWOJobsOverhauled.AI.GetRoleKey("police", "police_briefing", briefingAiId, "chief")
    local members = BWOJobsOverhauled.AI.GetRoleMembers(player, roleKey)
    return members and members[1] or nil
end

local function updateBriefing(player)
    local data = getBriefingData(player)
    if not data then return end
    if BWOJobsOverhauled.IsTaskComplete(player, "police_briefing")
        or BWOJobsOverhauled.IsTaskFailed(player, "police_briefing") then
        return
    end
    local nowHours = getGameTime():getWorldAgeHours()
    local nowMinutes = math.floor(nowHours * 60)
    if data.lastMinuteStamp == nowMinutes then
        return
    end
    data.lastMinuteStamp = nowMinutes

    if nowHours < data.startHours then
        return
    end

    if nowHours <= data.endHours then
        data.started = true
        if isPlayerInBriefingRoom(player, data) then
            data.attendedMinutes = (data.attendedMinutes or 0) + 1
        end

        local lineInterval = data.lineInterval or data.durationMinutes
        if lineInterval > 0 then
            local elapsed = (nowHours - data.startHours) * 60
            local index = math.floor(elapsed / lineInterval) + 1
            if index > (data.spokenIndex or 0) and index <= #data.lineKeys then
                local chief = getBriefingChief(player)
                local lineKey = data.lineKeys[index]
                if chief and lineKey then
                    chief:addLineChatElement(tostring(text(lineKey)), 1, 1, 1)
                end
                data.spokenIndex = index
            end
        end
        return
    end

    if data.resolved then return end
    data.resolved = true
    local attended = data.attendedMinutes or 0
    if attended >= (data.requiredMinutes or 0) then
        BWOJobsOverhauled.MarkTaskComplete(player, "police_briefing")
        BWOJobsOverhauled.PayEarnings(player, briefingPay)
    else
        BWOJobsOverhauled.MarkTaskFailed(player, "police_briefing")
    end
end

local function assignBriefingOffer(player, offer)
    local conditions = BWOJobsOverhauled.Conditions
    local work = BWOJobsOverhauled.GetWorkData(player)
    local building
    if work and work.keyId and conditions and conditions.FindBuildingByKeyId then
        building = conditions.FindBuildingByKeyId(work.keyId)
    end
    if not building and conditions then
        building = conditions.FindNearestBuildingByRoomNames(player, conditions.PoliceRoomNames, 1200)
        if not building then
            building = conditions.FindNearestBuildingByRoomNames(player, conditions.MunicipalRoomNames, 2000)
        end
    end

    local roomSquare, roomName
    if conditions and conditions.FindRoomSquareInBuilding and building then
        roomSquare, roomName = conditions.FindRoomSquareInBuilding(building, conditions.PoliceRoomNames)
        if not roomSquare then
            roomSquare, roomName = conditions.FindRoomSquareInBuilding(building, conditions.MunicipalRoomNames)
        end
    end

    local room
    if roomSquare then
        room = { x = roomSquare:getX(), y = roomSquare:getY(), z = roomSquare:getZ() }
    elseif work and work.x and work.y then
        room = { x = math.floor(work.x), y = math.floor(work.y), z = 0 }
    end
    if not room then
        return nil
    end

    local keyId = work and work.keyId or nil
    if building and building.getDef then
        local def = building:getDef()
        if def and def.getKeyId then
            keyId = def:getKeyId()
        end
    end

    local nowHours = getGameTime():getWorldAgeHours()
    local startHours = math.floor(nowHours) + 1
    local durationHours = briefingDurationMinutes / 60
    local requiredMinutes = math.floor(briefingDurationMinutes * briefingRequiredRatio)
    local lineInterval = (#briefingLineKeys > 0) and (briefingDurationMinutes / #briefingLineKeys) or briefingDurationMinutes

    return {
        buildingKeyId = keyId,
        roomName = roomName,
        room = room,
        startHour = startHours % 24,
        startHours = startHours,
        endHours = startHours + durationHours,
        durationMinutes = briefingDurationMinutes,
        requiredMinutes = requiredMinutes,
        attendedMinutes = 0,
        lineKeys = briefingLineKeys,
        lineInterval = lineInterval,
        spokenIndex = 0,
    }
end

local function buildJob(player, def)
    local bountyInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Police"), tostring(policeBounty))
    local bountyTaskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Police"), bountyInfo)
    local shiftPayInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Shift"), tostring(shiftConfig.pay))
    local shiftTaskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_WorkShift"), shiftPayInfo)
    local briefingPayInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Police_Briefing"), tostring(briefingPay))
    local briefingTaskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Police_Briefing"), briefingPayInfo)

    local tasks = {
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
    }

    local work = BWOJobsOverhauled.GetWorkData(player)
    if work and work.keyId then
        table.insert(tasks, {
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
        })
    end

    table.insert(tasks, {
        id = "police_briefing",
        text = briefingTaskText,
        isDaily = true,
        payOnComplete = false,
        issueConditions = {
            {
                id = "police_briefing_offer",
                check = function()
                    return BWOJobsOverhauled.IsDailyOfferActive(player, briefingOfferId)
                end,
            },
        },
        conditions = {
            {
                id = "police_briefing_room",
                text = text("UI_BWO_JobsOverhauled_Cond_Police_Briefing_Room"),
                isLongTerm = true,
                check = function()
                    return isPlayerInBriefingRoom(player, getBriefingData(player))
                end,
                getStatusText = function()
                    return getBriefingRoomLabel(getBriefingData(player))
                end,
            },
            {
                id = "police_briefing_attendance",
                text = text("UI_BWO_JobsOverhauled_Cond_Police_Briefing_Attendance"),
                isLongTerm = true,
                check = function()
                    local data = getBriefingData(player)
                    return data and (data.attendedMinutes or 0) >= (data.requiredMinutes or 0)
                end,
                getStatusText = function()
                    return getBriefingAttendanceStatus(getBriefingData(player))
                end,
            },
        },
        ai = {
            id = briefingAiId,
            priority = 50,
            stickyMinutes = 30,
            onlyWhenIssued = true,
            allowHidden = true,
            active = function(player)
                local data = getBriefingData(player)
                if not data then return false end
                local nowHours = getGameTime():getWorldAgeHours()
                return nowHours >= data.startHours and nowHours <= data.endHours
            end,
            context = function(ctx)
                local data = getBriefingData(ctx.player)
                if not data then return nil end
                return {
                    briefing = data,
                    briefingRoom = data.room,
                }
            end,
            roles = {
                {
                    id = "chief",
                    count = 1,
                    selector = {
                        programs = "Police",
                        requireFriendly = true,
                        radius = 50,
                        center = "briefingRoom",
                        custom = function(npc, ctx)
                            if not ctx.briefing or not ctx.briefing.buildingKeyId then return true end
                            local building = npc:getSquare() and npc:getSquare():getBuilding()
                            local def = building and building:getDef()
                            return def and def:getKeyId() == ctx.briefing.buildingKeyId
                        end,
                    },
                    actions = {
                        { type = "MoveTo", target = "briefingRoom", radius = 1, tag = "police_briefing_move" },
                        { type = "Wait", anim = "Talk4", time = 200, tag = "police_briefing_wait" },
                    },
                },
                {
                    id = "officers",
                    count = "all",
                    selector = {
                        programs = "Police",
                        requireFriendly = true,
                        radius = 60,
                        center = "briefingRoom",
                        custom = function(npc, ctx)
                            if not ctx.briefing or not ctx.briefing.buildingKeyId then return true end
                            local building = npc:getSquare() and npc:getSquare():getBuilding()
                            local def = building and building:getDef()
                            return def and def:getKeyId() == ctx.briefing.buildingKeyId
                        end,
                    },
                    actions = {
                        { type = "MoveTo", target = "briefingRoom", radius = 2, tag = "police_briefing_move" },
                        { type = "Wait", anim = "Idle", time = 200, tag = "police_briefing_wait" },
                    },
                },
            },
        },
    })

    return {
        id = def.id,
        text = def.text,
        tasks = tasks,
    }
end

local function onEveryOneMinute()
    if not BWOJobsOverhauled.IsWorldReady() then return end
    local player = getSpecificPlayer(0)
    if not player then return end
    updateBriefing(player)
end

BWOJobsOverhauled.RegisterFriendlyFireHandler(handleFriendlyFire)
BWOJobsOverhauled.RegisterWorkShift("policeofficer", shiftConfig)
BWOJobsOverhauled.RegisterDailyTaskOffer({
    id = briefingOfferId,
    professions = "policeofficer",
    chance = briefingOfferChance,
    requiresTransactions = true,
    onAssign = assignBriefingOffer,
})
BWOJobsOverhauled.RegisterJob({
    id = "police",
    text = text("UI_BWO_JobsOverhauled_Job_Police"),
    professions = "policeofficer",
    requiresTransactions = true,
    build = buildJob,
})

if not BWOJobsOverhauled.PoliceBriefingUpdater then
    BWOJobsOverhauled.PoliceBriefingUpdater = true
    Events.EveryOneMinute.Add(onEveryOneMinute)
end
