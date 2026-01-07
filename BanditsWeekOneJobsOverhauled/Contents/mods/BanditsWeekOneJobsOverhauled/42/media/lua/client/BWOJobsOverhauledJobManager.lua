BWOJobsOverhauled = BWOJobsOverhauled or {}
BWOJobsOverhauled.JobManager = BWOJobsOverhauled.JobManager or {}

local Manager = BWOJobsOverhauled.JobManager
if Manager._initialized then return end
Manager._initialized = true

Manager.JobDefinitions = Manager.JobDefinitions or {}
Manager.JobDefinitionById = Manager.JobDefinitionById or {}
Manager.TimedActionHandlers = Manager.TimedActionHandlers or {}
Manager.InventoryTransferHandlers = Manager.InventoryTransferHandlers or {}
Manager.FriendlyFireHandlers = Manager.FriendlyFireHandlers or {}
Manager.ExerciseHandlers = Manager.ExerciseHandlers or {}

-- Job definition structure:
-- def = {
--   id = "string", -- required for assignments
--   text = "string", -- default job title
--   professions = { "professionId", ... } or "professionId",
--   autoAssign = true|false, -- default true
--   requiresTransactions = true|false,
--   disableWhenAnarchy = true|false,
--   minDay = number, -- optional inclusive
--   maxDay = number, -- optional inclusive
--   ai = { ... }, -- optional AI block
--   build = function(player, def) -> job
-- }
--
-- job = {
--   id = "string",
--   text = "string",
--   tasks = { task, ... },
--   ai = { ... }
-- }
--
-- task = {
--   id = "string",
--   text = "string",
--   pay = number|table|function, -- optional
--   payOnComplete = true|false, -- default true
--   autoComplete = true|false, -- optional helper flag
--   isDaily = true|false, -- default true
--   hidden = true|false, -- never shown in UI
--   issueConditions = { condition, ... }, -- optional, evaluated once
--   conditions = { condition, ... }
-- }
--
-- condition = {
--   id = "string",
--   text = "string",
--   check = function(player, task, condition) -> boolean,
--   isLongTerm = true|false,
--   hidden = true|false,
--   isPersistent = true|false, -- lock result
--   persistOnSuccess = true|false, -- default true when persistent
--   persistOnFail = true|false, -- default false
--   getStatusText = function(player, task, condition) -> string
-- }

local function getDayStamp()
    local hours = getGameTime():getWorldAgeHours()
    return math.floor(hours / 24)
end

local function getNowSeconds()
    return getGameTime():getWorldAgeHours() * 3600
end

local function resolveTask(taskOrId, isDaily)
    if type(taskOrId) == "table" then
        return taskOrId.id, taskOrId.isDaily ~= false
    end
    return taskOrId, isDaily ~= false
end

local function getTaskStateTable(player, isDaily)
    local data = Manager.EnsureDailyData(player)
    if isDaily then
        data.taskState = data.taskState or {}
        return data.taskState
    end
    data.taskStatePersistent = data.taskStatePersistent or {}
    return data.taskStatePersistent
end

local function getTaskIssueTable(player, isDaily)
    local data = Manager.EnsureDailyData(player)
    if isDaily then
        data.taskIssueState = data.taskIssueState or {}
        return data.taskIssueState
    end
    data.taskIssueStatePersistent = data.taskIssueStatePersistent or {}
    return data.taskIssueStatePersistent
end

local function getConditionStateTable(player, isDaily)
    local data = Manager.EnsureDailyData(player)
    if isDaily then
        data.conditionState = data.conditionState or {}
        return data.conditionState
    end
    data.conditionStatePersistent = data.conditionStatePersistent or {}
    return data.conditionStatePersistent
end

local function getConditionState(player, task, condition)
    if not player or not task or not condition then return nil end
    local taskId = task.id or "__task"
    local conditionId = condition.id or "__condition"
    local _, daily = resolveTask(task)
    local tableRef = getConditionStateTable(player, daily)
    local taskTable = tableRef[taskId]
    if not taskTable then
        taskTable = {}
        tableRef[taskId] = taskTable
    end
    local state = taskTable[conditionId]
    if not state then
        state = {}
        taskTable[conditionId] = state
    end
    return state
end

local function safeCheck(condition, player, task)
    if not condition or type(condition.check) ~= "function" then
        return false
    end
    local ok, result = pcall(condition.check, player, task, condition)
    if not ok then
        if BWOJobsOverhauled and BWOJobsOverhauled.Log then
            BWOJobsOverhauled.Log("Condition check error: " .. tostring(result))
        end
        return false
    end
    return result == true
end

local function shallowCopy(source)
    local dest = {}
    for k, v in pairs(source or {}) do
        dest[k] = v
    end
    return dest
end

function Manager.EnsureDailyData(player)
    local md = player:getModData()
    md.BWOJobsOverhauled = md.BWOJobsOverhauled or {}
    local data = md.BWOJobsOverhauled
    local day = getDayStamp()
    if data.day ~= day then
        data.day = day
        data.trashPickups = 0
        data.trashEarnings = 0
        data.trashDumped = false
        data.lumberjackTheft = false
        data.fishermanTheft = false
        data.workOnDuty = false
        data.workShiftMinutes = 0
        data.workShiftLastUpdate = nil
        data.workShiftCompleted = false
        data.taskState = {}
        data.taskIssueState = {}
        data.conditionState = {}
    end
    data.work = data.work or {}
    data.taskState = data.taskState or {}
    data.taskIssueState = data.taskIssueState or {}
    data.conditionState = data.conditionState or {}
    data.taskStatePersistent = data.taskStatePersistent or {}
    data.taskIssueStatePersistent = data.taskIssueStatePersistent or {}
    data.conditionStatePersistent = data.conditionStatePersistent or {}
    data.assignedJobs = data.assignedJobs or {}
    return data
end

function Manager.GetDailyTrashData(player)
    local data = Manager.EnsureDailyData(player)
    return data.trashPickups or 0, data.trashEarnings or 0
end

function Manager.HasJobDefinition(id)
    if not id then return false end
    return Manager.JobDefinitionById[id] ~= nil
end

function Manager.RegisterJob(def)
    if type(def) == "function" then
        def = { build = def }
    end
    if type(def) ~= "table" then return end
    if def.id then
        if Manager.JobDefinitionById[def.id] then
            return
        end
        Manager.JobDefinitionById[def.id] = def
    else
        if BWOJobsOverhauled and BWOJobsOverhauled.Log then
            BWOJobsOverhauled.Log("Job definition missing id")
        end
    end
    table.insert(Manager.JobDefinitions, def)
end

function Manager.RegisterTimedActionHandler(handler)
    table.insert(Manager.TimedActionHandlers, handler)
end

function Manager.RegisterInventoryTransferHandler(handler)
    table.insert(Manager.InventoryTransferHandlers, handler)
end

function Manager.RegisterFriendlyFireHandler(handler)
    table.insert(Manager.FriendlyFireHandlers, handler)
end

function Manager.RegisterExerciseHandler(handler)
    table.insert(Manager.ExerciseHandlers, handler)
end

function Manager.MarkTaskComplete(player, taskOrId, isDaily)
    if not player then return end
    local taskId, daily = resolveTask(taskOrId, isDaily)
    if not taskId then return end
    local tableRef = getTaskStateTable(player, daily)
    local state = tableRef[taskId] or {}
    state.completedAt = getNowSeconds()
    tableRef[taskId] = state
end

function Manager.MarkTaskFailed(player, taskOrId, isDaily)
    if not player then return end
    local taskId, daily = resolveTask(taskOrId, isDaily)
    if not taskId then return end
    local tableRef = getTaskStateTable(player, daily)
    local state = tableRef[taskId] or {}
    state.failedAt = getNowSeconds()
    tableRef[taskId] = state
end

function Manager.IsTaskFailed(player, taskOrId, isDaily)
    if not player then return false end
    local taskId, daily = resolveTask(taskOrId, isDaily)
    if not taskId then return false end
    local tableRef = getTaskStateTable(player, daily)
    local state = tableRef[taskId]
    return state and state.failedAt ~= nil
end

function Manager.IsTaskComplete(player, taskOrId, isDaily)
    if not player then return false end
    local taskId, daily = resolveTask(taskOrId, isDaily)
    if not taskId then return false end
    local tableRef = getTaskStateTable(player, daily)
    local state = tableRef[taskId]
    return state and state.completedAt ~= nil
end

function Manager.ShouldHideTask(player, taskOrId, delaySeconds)
    if not player then return false end
    local taskId, daily = resolveTask(taskOrId)
    if not taskId then return false end
    local tableRef = getTaskStateTable(player, daily)
    local state = tableRef[taskId]
    if not state or not state.completedAt then return false end
    local delay = delaySeconds or 5
    return (getNowSeconds() - state.completedAt) >= delay
end

function Manager.ShouldHighlightTask(player, taskOrId, delaySeconds)
    if not player then return false end
    local taskId, daily = resolveTask(taskOrId)
    if not taskId then return false end
    local tableRef = getTaskStateTable(player, daily)
    local state = tableRef[taskId]
    if not state or not state.completedAt then return false end
    local delay = delaySeconds or 5
    return (getNowSeconds() - state.completedAt) < delay
end

function Manager.IsTaskIssued(player, task)
    if not player or not task then return true end
    if not task.issueConditions or #task.issueConditions == 0 then
        return true
    end
    local _, daily = resolveTask(task)
    local tableRef = getTaskIssueTable(player, daily)
    local state = tableRef[task.id]
    if state and state.issued then
        return true
    end
    for _, condition in ipairs(task.issueConditions) do
        if not safeCheck(condition, player, task) then
            return false
        end
    end
    tableRef[task.id] = { issued = true, issuedAt = getNowSeconds() }
    return true
end

function Manager.EvaluateCondition(player, task, condition)
    if not condition or type(condition.check) ~= "function" then
        return false
    end
    if not condition.isPersistent then
        return safeCheck(condition, player, task)
    end

    local state = getConditionState(player, task, condition)
    if state and state.locked then
        return state.value == true
    end

    local ok, result = pcall(condition.check, player, task, condition)
    if not ok then
        if BWOJobsOverhauled and BWOJobsOverhauled.Log then
            BWOJobsOverhauled.Log("Condition check error: " .. tostring(result))
        end
        return false
    end

    local value = result == true
    local lockOnSuccess = condition.persistOnSuccess ~= false
    local lockOnFail = condition.persistOnFail == true
    if (value and lockOnSuccess) or ((not value) and lockOnFail) then
        state.locked = true
        state.value = value
        if value then
            state.completedAt = getNowSeconds()
        else
            state.failedAt = getNowSeconds()
        end
    end
    return value
end

function Manager.AreTaskConditionsMet(player, task)
    if not player or not task then return false end
    for _, condition in ipairs(task.conditions or {}) do
        if not Manager.EvaluateCondition(player, task, condition) then
            return false
        end
    end
    return true
end

function Manager.ResolveTaskPay(player, task)
    if not task then return nil end
    local pay = task.pay
    if type(pay) == "number" then
        return pay
    end
    if type(pay) == "function" then
        return pay(player, task)
    end
    if type(pay) == "table" then
        if pay.min and pay.max then
            return ZombRand(math.floor(pay.max - pay.min + 1)) + pay.min
        end
        if pay.amount then
            return pay.amount
        end
    end
    return nil
end

function Manager.PayEarnings(player, amount)
    if not BWOJobsOverhauled.AreTransactionsEnabled() then return end
    if not player or not amount or amount <= 0 then return end
    local ok = true
    BWOJobsOverhauled.AllowEarn = true
    if BWOPlayer and BWOPlayer.Earn then
        local status, err = pcall(BWOPlayer.Earn, player, amount)
        ok = status
        if not status then
            if BWOJobsOverhauled and BWOJobsOverhauled.Log then
                BWOJobsOverhauled.Log("Earning error: " .. tostring(err))
            end
        end
    end
    BWOJobsOverhauled.AllowEarn = false
    return ok
end

function Manager.PayTask(player, task)
    local amount = Manager.ResolveTaskPay(player, task)
    if amount and amount > 0 then
        return Manager.PayEarnings(player, amount)
    end
    return false
end

function Manager.TryCompleteTask(player, task)
    if not player or not task then return false end
    if Manager.IsTaskComplete(player, task) or Manager.IsTaskFailed(player, task) then
        return false
    end
    if not Manager.AreTaskConditionsMet(player, task) then
        return false
    end
    Manager.MarkTaskComplete(player, task)
    if task.payOnComplete ~= false then
        Manager.PayTask(player, task)
    end
    return true
end

local function filterConditions(player, task, conditions)
    local filtered = {}
    for _, condition in ipairs(conditions or {}) do
        if not condition.hidden then
            table.insert(filtered, shallowCopy(condition))
        end
    end
    return filtered
end

local function filterTasks(player, tasks)
    local filtered = {}
    for _, task in ipairs(tasks or {}) do
        if not task.hidden and Manager.IsTaskIssued(player, task) then
            local taskCopy = shallowCopy(task)
            taskCopy.isDaily = task.isDaily ~= false
            taskCopy.conditions = filterConditions(player, task, task.conditions or {})
            table.insert(filtered, taskCopy)
        end
    end
    return filtered
end

function Manager.GetJobs(player)
    local jobs = {}
    if not player then return jobs end

    local assignments = BWOJobsOverhauled.Assignments
    if assignments and assignments.EnsureAssignments then
        assignments.EnsureAssignments(player)
    end
    local allowed = assignments and assignments.GetAssignedJobSet and assignments.GetAssignedJobSet(player) or nil

    for _, def in ipairs(Manager.JobDefinitions) do
        if not allowed or allowed[def.id] then
            local job = def.build and def.build(player, def) or def.job
            if job then
                job.id = job.id or def.id
                job.text = job.text or def.text
                job.ai = job.ai or def.ai or {}
                job.tasks = filterTasks(player, job.tasks or {})
                table.insert(jobs, job)
            end
        end
    end
    return jobs
end

function Manager.HandleFriendlyFire(bandit, attacker)
    for _, handler in ipairs(Manager.FriendlyFireHandlers) do
        if handler(bandit, attacker) then
            return true
        end
    end
    return false
end

function Manager.HandleExercise(character, min)
    for _, handler in ipairs(Manager.ExerciseHandlers) do
        if handler(character, min) then
            return true
        end
    end
    return false
end

function Manager.HandleTimedAction(data)
    if not BWOJobsOverhauled.AreTransactionsEnabled() then return end
    for _, handler in ipairs(Manager.TimedActionHandlers) do
        if handler(data) then
            return
        end
    end
end

function Manager.HandleInventoryTransfer(data)
    if not BWOJobsOverhauled.AreTransactionsEnabled() then return end
    for _, handler in ipairs(Manager.InventoryTransferHandlers) do
        if handler(data) then
            return
        end
    end
end

BWOJobsOverhauled.RegisterJob = Manager.RegisterJob
BWOJobsOverhauled.RegisterTimedActionHandler = Manager.RegisterTimedActionHandler
BWOJobsOverhauled.RegisterInventoryTransferHandler = Manager.RegisterInventoryTransferHandler
BWOJobsOverhauled.RegisterFriendlyFireHandler = Manager.RegisterFriendlyFireHandler
BWOJobsOverhauled.RegisterExerciseHandler = Manager.RegisterExerciseHandler
BWOJobsOverhauled.GetJobs = Manager.GetJobs
BWOJobsOverhauled.EnsureDailyData = Manager.EnsureDailyData
BWOJobsOverhauled.GetDailyTrashData = Manager.GetDailyTrashData
BWOJobsOverhauled.MarkTaskComplete = Manager.MarkTaskComplete
BWOJobsOverhauled.MarkTaskFailed = Manager.MarkTaskFailed
BWOJobsOverhauled.IsTaskFailed = Manager.IsTaskFailed
BWOJobsOverhauled.IsTaskComplete = Manager.IsTaskComplete
BWOJobsOverhauled.ShouldHideTask = Manager.ShouldHideTask
BWOJobsOverhauled.ShouldHighlightTask = Manager.ShouldHighlightTask
BWOJobsOverhauled.EvaluateCondition = Manager.EvaluateCondition
BWOJobsOverhauled.HandleFriendlyFire = Manager.HandleFriendlyFire
BWOJobsOverhauled.HandleExercise = Manager.HandleExercise
BWOJobsOverhauled.HandleTimedAction = Manager.HandleTimedAction
BWOJobsOverhauled.HandleInventoryTransfer = Manager.HandleInventoryTransfer
BWOJobsOverhauled.PayEarnings = Manager.PayEarnings
BWOJobsOverhauled.PayTask = Manager.PayTask
BWOJobsOverhauled.TryCompleteTask = Manager.TryCompleteTask
