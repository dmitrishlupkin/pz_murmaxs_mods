--- @module BWOJobsOverhauledJobs.FitnessJob
--- @summary Fitness instructor job: lead daily plans and extra sessions with NPCs.
--- @details Implemented: randomized daily plan tracking, group/personal sessions with AI participants, progress from exercise loop.
--- @todo Add richer exercise variety and tune session requirements/payouts.
local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local defaultMinRange = 5
local dailyPayout = 50
local planTotalMinutes = 30
local planMinPerTask = 10
local exercisePool = {
    { id = "squats", name = "Squats" },
    { id = "pushups", name = "Push-ups" },
    { id = "situp", name = "Sit-ups" },
    { id = "burpees", name = "Burpees" },
}

local groupOfferId = "fitness_group_session"
local personalOfferId = "fitness_personal_session"
local groupAiId = "fitness_group_ai"
local personalAiId = "fitness_personal_ai"
local extraOfferChance = 0.95
local groupPay = 30
local personalPay = 35
local groupRequiredMinutes = 20
local personalRequiredMinutes = 15

local function splitPlanMinutes(totalMinutes, count, minEach)
    local mins = {}
    local base = minEach or 0
    local remaining = totalMinutes - base * count
    if remaining < 0 then
        remaining = totalMinutes
        base = 0
    end
    for i = 1, count do
        mins[i] = base
    end
    local cuts = {}
    for i = 1, count - 1 do
        cuts[i] = ZombRand(remaining + 1)
    end
    table.sort(cuts)
    local prev = 0
    for i = 1, count - 1 do
        local add = cuts[i] - prev
        mins[i] = mins[i] + add
        prev = cuts[i]
    end
    mins[count] = mins[count] + (remaining - prev)
    return mins
end

local function hasNearbyParticipants(player, radius)
    if not BanditZombie or not BanditZombie.GetAllB then return false end
    local list = BanditZombie.GetAllB()
    local px, py = player:getX(), player:getY()
    for _, b in pairs(list) do
        local brain = b.brain
        if brain and not brain.hostile and brain.program and brain.program.name ~= "Vandal"
            and brain.program.name ~= "Fireman" and brain.program.name ~= "Police"
            and brain.program.name ~= "Medic" then
            local dist = IsoUtils.DistanceTo(px, py, b.x, b.y)
            if dist <= (radius or 10) then
                return true
            end
        end
    end
    return false
end

local function getFitnessPlan(player)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    data.fitnessPlan = data.fitnessPlan or {}
    if data.fitnessPlan.day ~= data.day then
        data.fitnessPlan = {
            day = data.day,
            paid = false,
            tasks = {},
            lastUpdateHours = nil,
            lastExerciseType = nil,
        }
        local count = math.min(ZombRand(3) + 1, #exercisePool) -- 1 to 3 tasks
        local options = {}
        for _, ex in ipairs(exercisePool) do
            table.insert(options, ex)
        end
        local minutes = splitPlanMinutes(planTotalMinutes, count, planMinPerTask)
        for i = 1, count do
            local idx = ZombRand(#options) + 1
            local ex = options[idx]
            table.remove(options, idx)
            local req = minutes[i]
            table.insert(data.fitnessPlan.tasks, { id = ex.id, name = ex.name, required = req, done = 0 })
        end
    end
    return data.fitnessPlan
end

local function normalizeExerciseType(exerciseType)
    if type(exerciseType) ~= "string" then return nil end
    local norm = exerciseType:lower()
    if norm == "situps" then
        return "situp"
    end
    return norm
end

local function getExerciseType(character, actionOrMin)
    local exerciseType
    if type(actionOrMin) == "table" then
        exerciseType = actionOrMin.exeDataType or actionOrMin.exercise
        if (not exerciseType or exerciseType == "") and actionOrMin.exeData and actionOrMin.exeData.type then
            exerciseType = actionOrMin.exeData.type
        end
    end
    if (not exerciseType or exerciseType == "") and character and character.getVariableString then
        exerciseType = character:getVariableString("ExerciseType")
    end
    return normalizeExerciseType(exerciseType)
end

local function updateFitnessProgress(player, actionOrMin)
    local plan = getFitnessPlan(player)
    if not plan or not plan.tasks then return end
    if not getGameTime then return end
    local nowHours = getGameTime():getWorldAgeHours()
    if not plan.lastUpdateHours then
        plan.lastUpdateHours = nowHours
    end
    local exerciseType = getExerciseType(player, actionOrMin)
    if not exerciseType then
        plan.lastUpdateHours = nowHours
        plan.lastExerciseType = nil
        return
    end
    if plan.lastExerciseType ~= exerciseType then
        plan.lastExerciseType = exerciseType
        plan.lastUpdateHours = nowHours
        return
    end
    local deltaMin = (nowHours - plan.lastUpdateHours) * 60
    if deltaMin <= 0 or deltaMin > 5 then
        plan.lastUpdateHours = nowHours
        return
    end
    plan.lastUpdateHours = nowHours
    for _, t in ipairs(plan.tasks) do
        if t.id == exerciseType then
            t.done = math.min((t.done or 0) + deltaMin, t.required)
        end
    end
end

local function isFitnessPlanComplete(player)
    local plan = getFitnessPlan(player)
    if not plan or not plan.tasks then return false end
    for _, t in ipairs(plan.tasks) do
        if (t.done or 0) < t.required then
            return false
        end
    end
    return true
end

local function getExerciseTaskStatus(player)
    local plan = getFitnessPlan(player)
    local status = {}
    for _, t in ipairs(plan.tasks or {}) do
        local done = tonumber(t.done) or 0
        table.insert(status, string.format("%s: %.1f/%d min", t.name, done, t.required))
    end
    return table.concat(status, " | ")
end

local function getGroupOffer(player)
    return BWOJobsOverhauled.GetDailyOffer and BWOJobsOverhauled.GetDailyOffer(player, groupOfferId) or nil
end

local function getPersonalOffer(player)
    return BWOJobsOverhauled.GetDailyOffer and BWOJobsOverhauled.GetDailyOffer(player, personalOfferId) or nil
end

local function getGroupData(player)
    local offer = getGroupOffer(player)
    return offer and offer.data or nil
end

local function getPersonalData(player)
    local offer = getPersonalOffer(player)
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

local function getGroupParticipants(player)
    if not BWOJobsOverhauled.AI then return {} end
    local roleKey = BWOJobsOverhauled.AI.GetRoleKey("fitness", "fitness_group_session", groupAiId, "participants")
    return BWOJobsOverhauled.AI.GetRoleMembers(player, roleKey)
end

local function hasGroupParticipantsInRoom(player, data)
    local members = getGroupParticipants(player)
    if not members or #members == 0 then return false end
    local room = player:getSquare() and player:getSquare():getRoom()
    if not room then return false end
    local roomName = room:getName()
    if BWORooms and BWORooms.GetRealRoomName then
        roomName = BWORooms.GetRealRoomName(room)
    end
    for _, npc in ipairs(members) do
        local npcRoom = npc:getSquare() and npc:getSquare():getRoom()
        if npcRoom then
            local npcName = npcRoom:getName()
            if BWORooms and BWORooms.GetRealRoomName then
                npcName = BWORooms.GetRealRoomName(npcRoom)
            end
            if npcName == roomName then
                return true
            end
        end
    end
    return false
end

local function getPersonalClient(player, data)
    if not data or not data.clientId then return nil end
    if BanditZombie and BanditZombie.GetInstanceById then
        return BanditZombie.GetInstanceById(data.clientId)
    end
    return nil
end

local function updateSessionProgress(session, nowHours, exerciseType)
    if not session then return 0 end
    if not session.lastUpdateHours then
        session.lastUpdateHours = nowHours
    end
    if not exerciseType then
        session.lastUpdateHours = nowHours
        session.lastExerciseType = nil
        return 0
    end
    if session.lastExerciseType ~= exerciseType then
        session.lastExerciseType = exerciseType
        session.lastUpdateHours = nowHours
        return 0
    end
    local deltaMin = (nowHours - session.lastUpdateHours) * 60
    if deltaMin <= 0 or deltaMin > 5 then
        session.lastUpdateHours = nowHours
        return 0
    end
    session.lastUpdateHours = nowHours
    session.progressMinutes = (session.progressMinutes or 0) + deltaMin
    return deltaMin
end

local function updateGroupSession(player, actionOrMin)
    local data = getGroupData(player)
    if not data or data.completed then return end
    if not BWOJobsOverhauled.IsOnDutyAs(player, "fitnessInstructor") then return end
    if not BWOJobsOverhauled.IsAtWork(player) then return end
    if not isPlayerInSessionRoom(player, data) then return end
    if not hasGroupParticipantsInRoom(player, data) then return end

    local exerciseType = getExerciseType(player, actionOrMin)
    local nowHours = getGameTime():getWorldAgeHours()
    updateSessionProgress(data, nowHours, exerciseType)

    if (data.progressMinutes or 0) >= (data.requiredMinutes or 0) then
        data.completed = true
        BWOJobsOverhauled.MarkTaskComplete(player, "fitness_group_session")
        BWOJobsOverhauled.PayEarnings(player, data.pay or groupPay)
    end
end

local function updatePersonalSession(player, actionOrMin)
    local data = getPersonalData(player)
    if not data or data.completed then return end
    if not isPlayerInSessionRoom(player, data) then return end

    local client = getPersonalClient(player, data)
    if not client then return end
    local dist = IsoUtils.DistanceTo(player:getX(), player:getY(), client:getX(), client:getY())
    if dist > 4 then return end

    local exerciseType = getExerciseType(player, actionOrMin)
    local nowHours = getGameTime():getWorldAgeHours()
    updateSessionProgress(data, nowHours, exerciseType)

    if (data.progressMinutes or 0) >= (data.requiredMinutes or 0) then
        data.completed = true
        BWOJobsOverhauled.MarkTaskComplete(player, "fitness_personal_session")
        BWOJobsOverhauled.PayEarnings(player, data.pay or personalPay)
    end
end

local function handleExercise(character, actionOrMin)
    if not character or not instanceof(character, "IsoPlayer") then return false end
    local profession = BWOJobsOverhauled.GetProfessionName(character)
    if profession ~= "fitnessInstructor" then return false end
    local onDuty = BWOJobsOverhauled.IsOnDutyAs(character, profession)
    local personalData = getPersonalData(character)
    local allowPersonal = personalData and not personalData.completed and isPlayerInSessionRoom(character, personalData)
    if not onDuty and not allowPersonal then return false end

    if BWOJobsOverhauled.UseFitnessLooped and type(actionOrMin) == "number" then
        return true
    end

    local atWork = BWOJobsOverhauled.IsAtWork(character)
    if atWork then
        updateFitnessProgress(character, actionOrMin)
    end

    if atWork then
        local plan = getFitnessPlan(character)
        if not plan.paid and isFitnessPlanComplete(character) and hasNearbyParticipants(character, defaultMinRange) then
            BWOJobsOverhauled.PayEarnings(character, dailyPayout)
            plan.paid = true
            BWOJobsOverhauled.MarkTaskComplete(character, "fitness_plan")
            BWOJobsOverhauled.MarkTaskComplete(character, "fitness_task")
        end
    end

    updateGroupSession(character, actionOrMin)
    updatePersonalSession(character, actionOrMin)
    return true
end

local function findFriendlyClients()
    local results = {}
    if not BanditZombie or not BanditZombie.GetAllB then return results end
    for _, bandit in pairs(BanditZombie.GetAllB()) do
        local npc = bandit
        if bandit and not bandit.getModData and BanditZombie.GetInstanceById and bandit.id then
            npc = BanditZombie.GetInstanceById(bandit.id)
        end
        if npc then
            local brain = npc.brain or (BanditBrain and BanditBrain.Get and BanditBrain.Get(npc))
            if brain and not brain.hostile then
                local program = brain.program and brain.program.name or ""
                if program ~= "Police" and program ~= "Medic" and program ~= "Fireman" and program ~= "Vandal" then
                    local building = npc:getSquare() and npc:getSquare():getBuilding()
                    if building then
                        table.insert(results, npc)
                    end
                end
            end
        end
    end
    return results
end

local function assignGroupOffer(player, offer)
    local conditions = BWOJobsOverhauled.Conditions
    local work = BWOJobsOverhauled.GetWorkData(player)
    local building
    if work and work.keyId and conditions and conditions.FindBuildingByKeyId then
        building = conditions.FindBuildingByKeyId(work.keyId)
    end
    if not building and conditions then
        building = conditions.FindNearestBuildingByRoomNames(player, conditions.GymRoomNames, 1200)
    end
    if not building then return nil end

    local roomSquare, roomName
    if conditions and conditions.FindRoomSquareInBuilding then
        roomSquare, roomName = conditions.FindRoomSquareInBuilding(building, conditions.GymRoomNames)
    end
    if not roomSquare then return nil end

    local def = building:getDef()
    local keyId = def and def:getKeyId() or nil
    return {
        buildingKeyId = keyId,
        roomName = roomName,
        room = { x = roomSquare:getX(), y = roomSquare:getY(), z = roomSquare:getZ() },
        requiredMinutes = groupRequiredMinutes,
        progressMinutes = 0,
        pay = groupPay,
    }
end

local function assignPersonalOffer(player, offer)
    local conditions = BWOJobsOverhauled.Conditions
    local candidates = findFriendlyClients()
    if #candidates == 0 then return nil end
    local client = candidates[ZombRand(#candidates) + 1]
    if not client then return nil end
    local building = client:getSquare() and client:getSquare():getBuilding()
    if not building then return nil end

    local roomSquare, roomName
    if conditions and conditions.FindRoomSquareInBuilding then
        roomSquare, roomName = conditions.FindRoomSquareInBuilding(building, conditions.ResidentialRoomNames)
    end
    if not roomSquare then return nil end

    if BWOJobsOverhauled.AddVisitBuilding then
        BWOJobsOverhauled.AddVisitBuilding(player, building, { allowTake = false })
    end

    local def = building:getDef()
    local keyId = def and def:getKeyId() or nil
    return {
        buildingKeyId = keyId,
        roomName = roomName,
        room = { x = roomSquare:getX(), y = roomSquare:getY(), z = roomSquare:getZ() },
        clientId = client.id or (BanditUtils and BanditUtils.GetCharacterID and BanditUtils.GetCharacterID(client)),
        requiredMinutes = personalRequiredMinutes,
        progressMinutes = 0,
        pay = personalPay,
    }
end

local function buildJob(player, def)
    local payInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Fitness"), tostring(dailyPayout))
    local taskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Fitness"), payInfo)
    local groupPayInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Fitness_Group"), tostring(groupPay))
    local groupText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Fitness_Group"), groupPayInfo)
    local personalPayInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_Fitness_Personal"), tostring(personalPay))
    local personalText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Fitness_Personal"), personalPayInfo)

    return {
        id = def.id,
        text = def.text,
        tasks = {
            {
                id = "fitness_task",
                text = taskText,
                conditions = {
                    {
                        id = "fitness_location",
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
                        id = "fitness_participants",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fitness_Participants"),
                        isLongTerm = true,
                        check = function()
                            return hasNearbyParticipants(player, defaultMinRange)
                        end,
                    },
                    {
                        id = "fitness_plan",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fitness_Plan"),
                        isLongTerm = true,
                        check = function()
                            return isFitnessPlanComplete(player)
                        end,
                        getStatusText = function()
                            return getExerciseTaskStatus(player)
                        end,
                    },
                    {
                        id = "fitness_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fitness_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.IsOnDutyAs(player, "fitnessInstructor")
                        end,
                    },
                },
            },
            {
                id = "fitness_group_session",
                text = groupText,
                isDaily = true,
                payOnComplete = false,
                issueConditions = {
                    {
                        id = "fitness_group_offer",
                        check = function()
                            return BWOJobsOverhauled.IsDailyOfferActive(player, groupOfferId)
                        end,
                    },
                },
                conditions = {
                    {
                        id = "fitness_group_room",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fitness_Group_Room"),
                        isLongTerm = true,
                        check = function()
                            return isPlayerInSessionRoom(player, getGroupData(player))
                        end,
                        getStatusText = function()
                            local data = getGroupData(player)
                            return data and data.roomName or ""
                        end,
                    },
                    {
                        id = "fitness_group_participants",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fitness_Group_Participants"),
                        isLongTerm = true,
                        check = function()
                            return hasGroupParticipantsInRoom(player, getGroupData(player))
                        end,
                    },
                    {
                        id = "fitness_group_progress",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fitness_Group_Progress"),
                        isLongTerm = true,
                        check = function()
                            local data = getGroupData(player)
                            return data and (data.progressMinutes or 0) >= (data.requiredMinutes or 0)
                        end,
                        getStatusText = function()
                            local data = getGroupData(player)
                            if not data then return "" end
                            return string.format(text("UI_BWO_JobsOverhauled_Status_Fitness_Group"), tostring(math.floor(data.progressMinutes or 0)), tostring(data.requiredMinutes or 0))
                        end,
                    },
                },
                ai = {
                    id = groupAiId,
                    priority = 40,
                    stickyMinutes = 30,
                    onlyWhenIssued = true,
                    allowHidden = true,
                    active = function(player)
                        local data = getGroupData(player)
                        return data ~= nil and not data.completed
                    end,
                    context = function(ctx)
                        local data = getGroupData(ctx.player)
                        if not data then return nil end
                        return {
                            session = data,
                            sessionRoom = data.room,
                        }
                    end,
                    roles = {
                        {
                            id = "participants",
                            count = "all",
                            selector = {
                                requireFriendly = true,
                                radius = 60,
                                center = "sessionRoom",
                                custom = function(npc, ctx)
                                    local brain = npc.brain or (BanditBrain and BanditBrain.Get and BanditBrain.Get(npc))
                                    if not brain or brain.hostile then return false end
                                    local program = brain.program and brain.program.name or ""
                                    return program ~= "Police" and program ~= "Medic" and program ~= "Fireman" and program ~= "Vandal"
                                end,
                            },
                            actions = {
                                { type = "MoveTo", target = "sessionRoom", radius = 3, tag = "fitness_group_move" },
                                { type = "Exercise", exerciseType = { "pushups", "squats", "situp", "burpees" }, time = 2000, tag = "fitness_group_exercise" },
                            },
                        },
                    },
                },
            },
            {
                id = "fitness_personal_session",
                text = personalText,
                isDaily = true,
                payOnComplete = false,
                issueConditions = {
                    {
                        id = "fitness_personal_offer",
                        check = function()
                            return BWOJobsOverhauled.IsDailyOfferActive(player, personalOfferId)
                        end,
                    },
                },
                conditions = {
                    {
                        id = "fitness_personal_room",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fitness_Personal_Room"),
                        isLongTerm = true,
                        check = function()
                            return isPlayerInSessionRoom(player, getPersonalData(player))
                        end,
                        getStatusText = function()
                            local data = getPersonalData(player)
                            return data and data.roomName or ""
                        end,
                    },
                    {
                        id = "fitness_personal_progress",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fitness_Personal_Progress"),
                        isLongTerm = true,
                        check = function()
                            local data = getPersonalData(player)
                            return data and (data.progressMinutes or 0) >= (data.requiredMinutes or 0)
                        end,
                        getStatusText = function()
                            local data = getPersonalData(player)
                            if not data then return "" end
                            return string.format(text("UI_BWO_JobsOverhauled_Status_Fitness_Personal"), tostring(math.floor(data.progressMinutes or 0)), tostring(data.requiredMinutes or 0))
                        end,
                    },
                },
                ai = {
                    id = personalAiId,
                    priority = 40,
                    stickyMinutes = 30,
                    onlyWhenIssued = true,
                    allowHidden = true,
                    active = function(player)
                        local data = getPersonalData(player)
                        return data ~= nil and not data.completed
                    end,
                    context = function(ctx)
                        local data = getPersonalData(ctx.player)
                        if not data then return nil end
                        return {
                            session = data,
                            sessionRoom = data.room,
                            playerExerciseType = getExerciseType(ctx.player),
                        }
                    end,
                    roles = {
                        {
                            id = "client",
                            count = 1,
                            selector = {
                                custom = function(npc, ctx)
                                    if not ctx.session or not ctx.session.clientId then return false end
                                    local npcId = npc.id
                                    if not npcId and BanditUtils and BanditUtils.GetCharacterID then
                                        npcId = BanditUtils.GetCharacterID(npc)
                                    end
                                    return npcId == ctx.session.clientId
                                end,
                            },
                            actions = {
                                { type = "SetHostile", hostile = false },
                                { type = "MoveTo", target = "sessionRoom", radius = 1, tag = "fitness_personal_move" },
                                { type = "Exercise", exerciseType = "player", time = 2000, tag = "fitness_personal_exercise" },
                            },
                        },
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterExerciseHandler(handleExercise)
BWOJobsOverhauled.RegisterWorkShift("fitnessInstructor", { hours = 0, pay = 0 })
BWOJobsOverhauled.RegisterDailyTaskOffer({
    id = groupOfferId,
    professions = "fitnessInstructor",
    chance = extraOfferChance,
    requiresTransactions = true,
    onAssign = assignGroupOffer,
})
BWOJobsOverhauled.RegisterDailyTaskOffer({
    id = personalOfferId,
    professions = "fitnessInstructor",
    chance = extraOfferChance,
    requiresTransactions = true,
    onAssign = assignPersonalOffer,
})
BWOJobsOverhauled.RegisterJob({
    id = "fitness",
    text = text("UI_BWO_JobsOverhauled_Job_Fitness"),
    professions = "fitnessInstructor",
    requiresTransactions = true,
    build = buildJob,
})
