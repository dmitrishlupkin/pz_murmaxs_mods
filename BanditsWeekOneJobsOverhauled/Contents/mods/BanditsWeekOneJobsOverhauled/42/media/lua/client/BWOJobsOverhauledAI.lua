BWOJobsOverhauled = BWOJobsOverhauled or {}
BWOJobsOverhauled.AI = BWOJobsOverhauled.AI or {}

local AI = BWOJobsOverhauled.AI
if AI._initialized then return end
AI._initialized = true

-- AI definition schema (job.ai or task.ai):
-- ai = {
--   id = "string",
--   enabled = true|false,
--   priority = number, -- higher runs first
--   cooldownMinutes = number, -- per-NPC throttle
--   stickyMinutes = number, -- keep assigned NPCs
--   allowHidden = true|false,
--   onlyWhenIssued = true|false, -- default true for task.ai
--   when = "always"|"incomplete"|"complete"|"conditionsMet"|"conditionsNotMet",
--   conditions = { condition, ... }, -- same structure as task conditions
--   selector = { ... }, -- shorthand for single role
--   actions = { action, ... }, -- shorthand for single role
--   behavior = { ... }, -- shorthand for single role
--   roles = { role, ... },
-- }
--
-- role = {
--   id = "string",
--   count = number|"all",
--   selector = { ... },
--   actions = { action, ... },
--   behavior = { ... },
--   cooldownMinutes = number,
--   stickyMinutes = number,
-- }
--
-- selector = {
--   center = "player"|"work"|"coords",
--   coords = { x=number, y=number, z=number },
--   radius = number,
--   programs = { "Police", "Medic" } or "Police",
--   excludePrograms = { ... },
--   occupations = { "Police", "Security" } or "Police",
--   requireFriendly = true|false,
--   requireHostile = true|false,
--   maxCandidates = number,
--   custom = function(npc, ctx) -> boolean,
-- }
--
-- behavior = {
--   clearTasks = true|false,
--   program = { name="Police", params={}, stage="Guard", capture=true, restore=false },
--   tasks = { action, ... },
-- }
--
-- action = {
--   type = "Program"|"ClearTasks"|"MoveTo"|"Wait"|"RawTask",
--   target = "player"|"work"|"coords",
--   coords = { x=number, y=number, z=number },
--   walkType = "Walk"|"Run",
--   closeSlow = true|false,
--   radius = number,
--   time = number,
--   anim = "Idle",
--   task = { action="Time", ... }, -- for RawTask
--   tag = "string", -- optional to prevent duplicates
-- }

AI.Settings = AI.Settings or {
    updateMinutes = 1,
    defaultRoleCount = 1,
    stickyMinutes = 10,
    debug = false,
}

local function log(msg)
    if BWOJobsOverhauled and BWOJobsOverhauled.Log then
        BWOJobsOverhauled.Log(msg)
    end
end

local function getNowMinutes()
    return getGameTime():getWorldAgeHours() * 60
end

local function safeCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, result = pcall(fn, ...)
    if not ok then
        log("AI error: " .. tostring(result))
        return nil
    end
    return result
end

local function normalizeList(value)
    if value == nil then return nil end
    if type(value) == "table" then return value end
    return { value }
end

local function getNpcId(npc)
    if npc and npc.id then
        return npc.id
    end
    if BanditUtils and BanditUtils.GetCharacterID then
        return BanditUtils.GetCharacterID(npc)
    end
    return tostring(npc)
end

local function getNpcBrain(npc)
    if npc and npc.brain then
        return npc.brain
    end
    if BanditBrain and BanditBrain.Get then
        return BanditBrain.Get(npc)
    end
    local md = npc and npc.getModData and npc:getModData() or nil
    return md and md.brain or nil
end

local function getNpcProgramName(npc, brain)
    if Bandit and Bandit.GetProgram then
        local program = Bandit.GetProgram(npc)
        if program and program.name then
            return program.name
        end
    end
    return brain and brain.program and brain.program.name or nil
end

local function getNpcProgramStage(npc, brain)
    if Bandit and Bandit.GetProgram then
        local program = Bandit.GetProgram(npc)
        if program and program.stage then
            return program.stage
        end
    end
    return brain and brain.program and brain.program.stage or nil
end

local function getNpcState(npc)
    local md = npc:getModData()
    md.BWOJobsOverhauledAI = md.BWOJobsOverhauledAI or {}
    return md.BWOJobsOverhauledAI
end

local function resolveAnchor(selector, ctx)
    if not selector then return nil end
    if type(selector.center) == "string" then
        local anchor = ctx[selector.center]
        if anchor and anchor.x and anchor.y then
            return anchor.x, anchor.y, anchor.z or ctx.player:getZ()
        end
    end
    if selector.center == "coords" and selector.coords then
        return selector.coords.x, selector.coords.y, selector.coords.z or ctx.player:getZ()
    end
    if selector.center == "work" then
        local work = ctx.work
        if work and work.x and work.y then
            return work.x, work.y, work.z or ctx.player:getZ()
        end
    end
    return ctx.player:getX(), ctx.player:getY(), ctx.player:getZ()
end

local function resolveTarget(action, ctx)
    if action.coords then
        if type(action.coords) == "function" then
            local coords = safeCall(action.coords, ctx)
            if coords and coords.x and coords.y then
                return coords.x, coords.y, coords.z or ctx.player:getZ()
            end
        else
            return action.coords.x, action.coords.y, action.coords.z or ctx.player:getZ()
        end
    end
    local target = action.target
    if target == "work" then
        local work = ctx.work
        if work and work.x and work.y then
            return work.x, work.y, work.z or ctx.player:getZ()
        end
    end
    if type(target) == "string" then
        local anchor = ctx[target]
        if anchor and anchor.x and anchor.y then
            return anchor.x, anchor.y, anchor.z or ctx.player:getZ()
        end
    end
    if target == "player" then
        return ctx.player:getX(), ctx.player:getY(), ctx.player:getZ()
    end
    return nil
end

local function applyRandomOffset(x, y, radius)
    if not radius or radius <= 0 then
        return x, y
    end
    local angle = math.rad(ZombRand(360))
    local dist = ZombRand(math.floor(radius * 1000) + 1) / 1000
    return x + math.cos(angle) * dist, y + math.sin(angle) * dist
end

local function hasTaskTag(npc, tag)
    if not tag then return false end
    local brain = getNpcBrain(npc)
    if not brain or not brain.tasks then return false end
    for _, task in pairs(brain.tasks) do
        if task.tag == tag then
            return true
        end
    end
    return false
end

local function addNpcTask(npc, task)
    if not task then return end
    local tag = task.tag
    if tag and hasTaskTag(npc, tag) then return end
    if Bandit and Bandit.AddTask then
        Bandit.AddTask(npc, task)
    end
end

AI.ActionHandlers = AI.ActionHandlers or {}

function AI.RegisterActionHandler(actionType, handler)
    if not actionType or type(handler) ~= "function" then return end
    AI.ActionHandlers[actionType] = handler
end

local function applyAction(npc, action, ctx)
    if not action or not action.type then return end
    local handler = AI.ActionHandlers[action.type]
    if handler then
        handler(npc, action, ctx)
    end
end

AI.RegisterActionHandler("Program", function(npc, action, ctx)
    if not Bandit or not Bandit.SetProgram then return end
    local name = action.name or (action.program and action.program.name)
    if not name then return end
    Bandit.SetProgram(npc, name, action.params or {})
    local stage = action.stage or (action.program and action.program.stage)
    if stage and Bandit.SetProgramStage then
        Bandit.SetProgramStage(npc, stage)
    end
end)

AI.RegisterActionHandler("ClearTasks", function(npc, action, ctx)
    if Bandit and Bandit.ClearTasks then
        Bandit.ClearTasks(npc)
    end
end)

AI.RegisterActionHandler("MoveTo", function(npc, action, ctx)
    local x, y, z = resolveTarget(action, ctx)
    if not x or not y then return end
    if action.radius then
        x, y = applyRandomOffset(x, y, action.radius)
    end
    local dist = IsoUtils.DistanceTo(npc:getX(), npc:getY(), x, y)
    local task
    if BanditUtils and BanditUtils.GetMoveTask then
        task = BanditUtils.GetMoveTask(action.endurance or 0.01, x, y, z or 0, action.walkType or "Walk", dist, action.closeSlow)
    else
        task = { action = "GoTo", x = x, y = y, z = z or 0, walkType = action.walkType or "Walk" }
    end
    task.tag = action.tag
    addNpcTask(npc, task)
end)

AI.RegisterActionHandler("Wait", function(npc, action, ctx)
    local task = {
        action = "Time",
        anim = action.anim or "Idle",
        time = action.time or 200,
        tag = action.tag,
    }
    addNpcTask(npc, task)
end)

AI.RegisterActionHandler("Speak", function(npc, action, ctx)
    local state = getNpcState(npc)
    if action.tag and state.lastSpeakTag == action.tag then
        return
    end
    local text = action.text
    if not text and action.lines then
        local idx = action.lineIndex or 1
        text = action.lines[idx]
    end
    if not text and action.getText then
        text = safeCall(action.getText, ctx, npc)
    end
    if text and npc.addLineChatElement then
        npc:addLineChatElement(tostring(text), 1, 1, 1)
        state.lastSpeakTag = action.tag or tostring(text)
    end
    if action.anim or action.time then
        local task = { action = "TimeEvent", anim = action.anim or "Talk4", time = action.time or 200, tag = action.tag }
        addNpcTask(npc, task)
    end
end)

AI.RegisterActionHandler("SetHostile", function(npc, action, ctx)
    if Bandit and Bandit.SetHostile then
        Bandit.SetHostile(npc, action.hostile == true)
    end
end)

AI.RegisterActionHandler("SetAlly", function(npc, action, ctx)
    if Bandit and Bandit.SetHostile then
        Bandit.SetHostile(npc, false)
    end
    if Bandit and Bandit.SetMaster and ctx.player then
        Bandit.SetMaster(npc, ctx.player)
    end
    if action.program and Bandit and Bandit.SetProgram then
        Bandit.SetProgram(npc, action.program, {})
    end
end)

AI.RegisterActionHandler("Exercise", function(npc, action, ctx)
    local exerciseType = action.exerciseType
    if type(exerciseType) == "table" then
        if #exerciseType > 0 then
            exerciseType = exerciseType[ZombRand(#exerciseType) + 1]
        else
            exerciseType = nil
        end
    elseif type(exerciseType) == "function" then
        exerciseType = safeCall(exerciseType, ctx, npc)
    end
    if exerciseType == "player" then
        exerciseType = ctx.playerExerciseType
    end
    if type(exerciseType) == "string" then
        exerciseType = exerciseType:lower()
    end
    local map = {
        pushups = "PushUp",
        pushup = "PushUp",
        squats = "PushUp",
        situp = "PushUp",
        situps = "PushUp",
        burpees = "PushUp",
    }
    local actionName = map[exerciseType] or action.actionName or "PushUp"
    if ZombieActions and ZombieActions[actionName] then
        local task = { action = actionName, time = action.time or 2000, tag = action.tag }
        addNpcTask(npc, task)
    else
        local task = { action = "Time", anim = action.anim or "WipeBrow", time = action.time or 200, tag = action.tag }
        addNpcTask(npc, task)
    end
end)

AI.RegisterActionHandler("RawTask", function(npc, action, ctx)
    local task = action.task
    if not task then return end
    if action.tag and not task.tag then
        task.tag = action.tag
    end
    addNpcTask(npc, task)
end)

local function normalizeRoles(ai, job, task)
    if ai.roles and #ai.roles > 0 then
        return ai.roles
    end
    return {
        {
            id = ai.id or (task and task.id) or (job and job.id) or "role",
            count = ai.count,
            selector = ai.selector,
            actions = ai.actions,
            behavior = ai.behavior,
            cooldownMinutes = ai.cooldownMinutes,
            stickyMinutes = ai.stickyMinutes,
        },
    }
end

local function buildBehaviorActions(behavior)
    local actions = {}
    if not behavior then return actions end
    if behavior.clearTasks then
        table.insert(actions, { type = "ClearTasks" })
    end
    if behavior.program then
        table.insert(actions, {
            type = "Program",
            name = behavior.program.name,
            params = behavior.program.params,
            stage = behavior.program.stage,
        })
    end
    for _, task in ipairs(behavior.tasks or {}) do
        table.insert(actions, task)
    end
    return actions
end

local function shouldActivateAI(player, job, task, ai)
    if not ai or ai.enabled == false then return false end
    local manager = BWOJobsOverhauled.JobManager
    if not manager then return false end

    if task and ai.onlyWhenIssued ~= false then
        if task.hidden and not ai.allowHidden then
            return false
        end
        if manager.IsTaskIssued and not manager.IsTaskIssued(player, task) then
            return false
        end
    end

    if task and ai.when then
        if ai.when == "complete" and not manager.IsTaskComplete(player, task) then
            return false
        elseif ai.when == "incomplete" then
            if manager.IsTaskComplete(player, task) or manager.IsTaskFailed(player, task) then
                return false
            end
        elseif ai.when == "conditionsMet" and not manager.AreTaskConditionsMet(player, task) then
            return false
        elseif ai.when == "conditionsNotMet" and manager.AreTaskConditionsMet(player, task) then
            return false
        end
    end

    for _, condition in ipairs(ai.conditions or {}) do
        if manager.EvaluateCondition and not manager.EvaluateCondition(player, task, condition) then
            return false
        end
    end

    if ai.active and type(ai.active) == "function" then
        if safeCall(ai.active, player, job, task, ai) ~= true then
            return false
        end
    end

    return true
end

local function isCandidate(npc, selector, ctx)
    if not npc or not selector then return false end
    local brain = getNpcBrain(npc)
    if not brain then return false end

    local ids = normalizeList(selector.ids or selector.id)
    if ids then
        local npcId = getNpcId(npc)
        local match = false
        for _, id in ipairs(ids) do
            if npcId == id then
                match = true
                break
            end
        end
        if not match then
            return false
        end
    end

    if selector.requireFriendly and brain.hostile then return false end
    if selector.requireHostile and not brain.hostile then return false end

    local programs = normalizeList(selector.programs)
    if programs then
        local current = getNpcProgramName(npc, brain)
        local match = false
        for _, name in ipairs(programs) do
            if current == name then
                match = true
                break
            end
        end
        if not match then
            return false
        end
    end

    local excludePrograms = normalizeList(selector.excludePrograms)
    if excludePrograms then
        local current = getNpcProgramName(npc, brain)
        for _, name in ipairs(excludePrograms) do
            if current == name then
                return false
            end
        end
    end

    local occupations = normalizeList(selector.occupations)
    if occupations then
        local current = brain.occupation
        local match = false
        for _, name in ipairs(occupations) do
            if current == name then
                match = true
                break
            end
        end
        if not match then
            return false
        end
    end

    if selector.buildingKeyId then
        local square = npc:getSquare()
        local building = square and square:getBuilding() or nil
        local def = building and building:getDef() or nil
        if not def or def:getKeyId() ~= selector.buildingKeyId then
            return false
        end
    end

    if selector.roomNames then
        local room = npc:getSquare() and npc:getSquare():getRoom()
        if not room then return false end
        local names = normalizeList(selector.roomNames)
        local current = room:getName()
        if BWORooms and BWORooms.GetRealRoomName then
            current = BWORooms.GetRealRoomName(room)
        end
        local match = false
        for _, name in ipairs(names) do
            if current == name then
                match = true
                break
            end
        end
        if not match then
            return false
        end
    end

    if selector.box then
        local x = npc:getX()
        local y = npc:getY()
        local box = selector.box
        if x < box.x1 or x > box.x2 or y < box.y1 or y > box.y2 then
            return false
        end
    end

    if selector.radius then
        local cx, cy = resolveAnchor(selector, ctx)
        if not cx or not cy then return false end
        local dist = IsoUtils.DistanceTo(npc:getX(), npc:getY(), cx, cy)
        if dist > selector.radius then
            return false
        end
    end

    if selector.custom and type(selector.custom) == "function" then
        if safeCall(selector.custom, npc, ctx) ~= true then
            return false
        end
    end

    return true
end

local function collectCandidates(selector, ctx)
    local list = {}
    if not BanditZombie or not BanditZombie.GetAllB then return list end
    local bandits = BanditZombie.GetAllB()
    for _, entry in pairs(bandits) do
        local npc = entry
        if entry and not entry.getModData and BanditZombie.GetInstanceById and entry.id then
            npc = BanditZombie.GetInstanceById(entry.id)
        end
        if npc and isCandidate(npc, selector, ctx) then
            local cx, cy = resolveAnchor(selector, ctx)
            local dist = 0
            if cx and cy then
                dist = IsoUtils.DistanceTo(npc:getX(), npc:getY(), cx, cy)
            end
            table.insert(list, { npc = npc, dist = dist })
        end
    end
    table.sort(list, function(a, b)
        return a.dist < b.dist
    end)
    return list
end

local function assignRole(npc, roleKey, role, ai, job, task, ctx)
    local state = getNpcState(npc)
    local now = getNowMinutes()
    local cooldown = role.cooldownMinutes or ai.cooldownMinutes or 0
    if state.roleKey == roleKey and cooldown > 0 and state.lastAppliedAt then
        if now - state.lastAppliedAt < cooldown then
            return
        end
    end

    local behavior = role.behavior or ai.behavior
    local actions = role.actions or ai.actions or buildBehaviorActions(behavior)

    if behavior and behavior.program and behavior.program.capture ~= false then
        if not state.originalProgram then
            state.originalProgram = getNpcProgramName(npc, getNpcBrain(npc))
            state.originalStage = getNpcProgramStage(npc, getNpcBrain(npc))
        end
        state.restoreProgramOnRelease = behavior.program.restore == true
    end

    for _, action in ipairs(actions or {}) do
        applyAction(npc, action, ctx)
    end

    state.active = true
    state.roleKey = roleKey
    state.jobId = job and job.id or nil
    state.taskId = task and task.id or nil
    state.lastAppliedAt = now
    state.assignedAt = state.assignedAt or now
end

local function releaseNpc(npc, state)
    if not state or not state.active then return end
    if state.restoreProgramOnRelease and state.originalProgram and Bandit and Bandit.SetProgram then
        Bandit.SetProgram(npc, state.originalProgram, {})
        if state.originalStage and Bandit.SetProgramStage then
            Bandit.SetProgramStage(npc, state.originalStage)
        end
    end
    state.active = false
    state.roleKey = nil
    state.jobId = nil
    state.taskId = nil
    state.assignedAt = nil
    state.lastAppliedAt = nil
    state.restoreProgramOnRelease = nil
end

local function roleKeyFor(ai, job, task, role)
    return table.concat({
        job and job.id or "job",
        task and task.id or "task",
        ai.id or "ai",
        role.id or "role",
    }, ":")
end

local function selectRoleMembers(role, ai, job, task, ctx, used)
    local selector = role.selector or ai.selector
    if not selector then return {} end
    local candidates = collectCandidates(selector, ctx)
    if selector.maxCandidates and #candidates > selector.maxCandidates then
        local trimmed = {}
        for i = 1, selector.maxCandidates do
            trimmed[i] = candidates[i]
        end
        candidates = trimmed
    end
    local roleKey = roleKeyFor(ai, job, task, role)
    local stickyMinutes = role.stickyMinutes or ai.stickyMinutes or AI.Settings.stickyMinutes
    local now = getNowMinutes()
    local selected = {}

    local desired = role.count or ai.count or AI.Settings.defaultRoleCount
    if desired == "all" then
        desired = #candidates
    end

    for _, entry in ipairs(candidates) do
        if #selected >= desired then
            break
        end
        local npc = entry.npc
        local npcId = getNpcId(npc)
        local state = getNpcState(npc)
        if state.active and state.roleKey == roleKey and state.assignedAt then
            if stickyMinutes <= 0 or (now - state.assignedAt) <= stickyMinutes then
                if not used[npcId] then
                    used[npcId] = true
                    table.insert(selected, npc)
                end
            end
        end
    end

    for _, entry in ipairs(candidates) do
        if #selected >= desired then
            break
        end
        local npc = entry.npc
        local npcId = getNpcId(npc)
        if not used[npcId] then
            used[npcId] = true
            table.insert(selected, npc)
        end
    end

    return selected
end

local function collectAIBlocks(player)
    local blocks = {}
    local manager = BWOJobsOverhauled.JobManager
    if not manager then return blocks end

    local assignments = BWOJobsOverhauled.Assignments
    if assignments and assignments.EnsureAssignments then
        assignments.EnsureAssignments(player)
    end
    local allowed = assignments and assignments.GetAssignedJobSet and assignments.GetAssignedJobSet(player) or nil

    for _, def in ipairs(manager.JobDefinitions or {}) do
        if not allowed or allowed[def.id] then
            local job = def.build and def.build(player, def) or def.job
            if job then
                job.id = job.id or def.id
                job.text = job.text or def.text
                job.ai = job.ai or def.ai
                if job.ai then
                    table.insert(blocks, { ai = job.ai, job = job, task = nil })
                end
                for _, task in ipairs(job.tasks or {}) do
                    if task.ai then
                        table.insert(blocks, { ai = task.ai, job = job, task = task })
                    end
                end
            end
        end
    end
    table.sort(blocks, function(a, b)
        local pa = a.ai and a.ai.priority or 0
        local pb = b.ai and b.ai.priority or 0
        return pa > pb
    end)
    return blocks
end

local function validateAIBlock(ai, jobId, taskId)
    if not ai then return end
    if ai.roles and type(ai.roles) ~= "table" then
        log("AI block roles must be table for " .. tostring(jobId) .. ":" .. tostring(taskId))
    end
    if not ai.roles and not ai.selector and not ai.behavior and not ai.actions then
        log("AI block missing roles/actions for " .. tostring(jobId) .. ":" .. tostring(taskId))
    end
    local roles = normalizeRoles(ai)
    for _, role in ipairs(roles) do
        if not (role.selector or ai.selector) then
            log("AI role missing selector for " .. tostring(jobId) .. ":" .. tostring(taskId))
        end
        local actions = role.actions or ai.actions
        local behavior = role.behavior or ai.behavior
        if not actions and not behavior then
            log("AI role missing behavior/actions for " .. tostring(jobId) .. ":" .. tostring(taskId))
        end
    end
end

function AI.ValidateAll(player)
    if not BWOJobsOverhauled.JobManager then return end
    local jobs = collectAIBlocks(player)
    if #jobs == 0 then
        return
    end
    for _, block in ipairs(jobs) do
        validateAIBlock(block.ai, block.job and block.job.id, block.task and block.task.id)
    end
end

function AI.Update(player)
    if not player then return end
    if not BWOJobsOverhauled.IsWorldReady or not BWOJobsOverhauled.IsWorldReady() then return end
    if not BanditZombie or not BanditZombie.GetAllB then return end

    local ctx = {
        player = player,
        work = BWOJobsOverhauled.GetWorkData and BWOJobsOverhauled.GetWorkData(player) or nil,
        assigned = {},
    }

    local blocks = collectAIBlocks(player)
    local used = {}

    for _, block in ipairs(blocks) do
        ctx.job = block.job
        ctx.task = block.task
        if block.ai and block.ai.context then
            local extra = safeCall(block.ai.context, ctx, player, block.job, block.task, block.ai)
            if type(extra) == "table" then
                for k, v in pairs(extra) do
                    ctx[k] = v
                end
            end
        end
        if shouldActivateAI(player, block.job, block.task, block.ai) then
            local roles = normalizeRoles(block.ai, block.job, block.task)
            for _, role in ipairs(roles) do
                local members = selectRoleMembers(role, block.ai, block.job, block.task, ctx, used)
                local roleKey = roleKeyFor(block.ai, block.job, block.task, role)
                for _, npc in ipairs(members) do
                    assignRole(npc, roleKey, role, block.ai, block.job, block.task, ctx)
                    ctx.assigned[roleKey] = ctx.assigned[roleKey] or {}
                    table.insert(ctx.assigned[roleKey], getNpcId(npc))
                end
            end
        end
    end

    if not BanditZombie or not BanditZombie.GetAllB then return end
    for _, npc in pairs(BanditZombie.GetAllB()) do
        local target = npc
        if npc and not npc.getModData and BanditZombie.GetInstanceById and npc.id then
            target = BanditZombie.GetInstanceById(npc.id)
        end
        if target then
            local npcId = getNpcId(target)
            local state = getNpcState(target)
            if state.active and not used[npcId] then
                releaseNpc(target, state)
            end
        end
    end

    local md = player:getModData()
    md.BWOJobsOverhauled = md.BWOJobsOverhauled or {}
    md.BWOJobsOverhauled.aiAssignments = ctx.assigned
end

local function tryUpdate()
    if not BWOJobsOverhauled.IsWorldReady or not BWOJobsOverhauled.IsWorldReady() then
        return
    end
    local player = getSpecificPlayer(0)
    if not player then return end
    AI.PendingUpdate = false
    Events.OnTick.Remove(tryUpdate)
    if AI.Settings.debug or BWOJobsOverhauled.Debug then
        AI.ValidateAll(player)
    end
    AI.Update(player)
end

function AI.RequestUpdate()
    if AI.PendingUpdate then return end
    AI.PendingUpdate = true
    Events.OnTick.Add(tryUpdate)
end

function AI.GetRoleKey(jobId, taskId, aiId, roleId)
    return table.concat({
        jobId or "job",
        taskId or "task",
        aiId or "ai",
        roleId or "role",
    }, ":")
end

function AI.GetRoleMembers(player, roleKey)
    if not player or not roleKey then return {} end
    local md = player:getModData()
    local data = md.BWOJobsOverhauled
    local assignments = data and data.aiAssignments or nil
    if not assignments or not assignments[roleKey] then
        return {}
    end
    local result = {}
    for _, npcId in ipairs(assignments[roleKey]) do
        if BanditZombie and BanditZombie.GetInstanceById then
            local npc = BanditZombie.GetInstanceById(npcId)
            if npc then
                table.insert(result, npc)
            end
        end
    end
    return result
end

local function onGameStart()
    AI.RequestUpdate()
end

local function onCreatePlayer(playerIndex)
    local player = getSpecificPlayer(playerIndex or 0)
    if not player then return end
    AI.RequestUpdate()
end

local function onEveryOneMinute()
    local player = getSpecificPlayer(0)
    if not player then return end
    AI.Update(player)
end

if Events and Events.OnGameStart and Events.OnGameStart.Add then
    Events.OnGameStart.Add(onGameStart)
end
if Events and Events.OnCreatePlayer and Events.OnCreatePlayer.Add then
    Events.OnCreatePlayer.Add(onCreatePlayer)
end
if Events and Events.EveryOneMinute and Events.EveryOneMinute.Add then
    Events.EveryOneMinute.Add(onEveryOneMinute)
end
