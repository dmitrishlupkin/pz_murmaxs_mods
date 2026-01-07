BWOJobsOverhauled = BWOJobsOverhauled or {}
BWOJobsOverhauled.Assignments = BWOJobsOverhauled.Assignments or {}

local Assignments = BWOJobsOverhauled.Assignments
if Assignments._initialized then return end
Assignments._initialized = true

Assignments.Seeded = Assignments.Seeded or false
Assignments.State = Assignments.State or {}

local function getDayStamp()
    local hours = getGameTime():getWorldAgeHours()
    return math.floor(hours / 24)
end

local function getNowSeconds()
    return getGameTime():getWorldAgeHours() * 3600
end

local function isAnarchyActive()
    return BWOScheduler and BWOScheduler.Anarchy and BWOScheduler.Anarchy.Transactions == false
end

local function matchesProfession(player, professions)
    if not professions then return true end
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if type(professions) == "string" then
        return profession == professions
    end
    if type(professions) == "table" then
        for _, name in ipairs(professions) do
            if profession == name then
                return true
            end
        end
    end
    return false
end

function Assignments.GetAssignedJobs(player)
    if not player then return nil end
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    data.assignedJobs = data.assignedJobs or {}
    return data.assignedJobs
end

function Assignments.GetAssignedJobSet(player)
    if not Assignments.Seeded then return nil end
    local assigned = Assignments.GetAssignedJobs(player)
    if not assigned then return nil end
    local set = {}
    for id, info in pairs(assigned) do
        if info == true then
            set[id] = true
        elseif type(info) == "table" then
            if info.active ~= false then
                set[id] = true
            end
        end
    end
    return set
end

function Assignments.AssignJob(player, jobId, opts)
    if not player or not jobId then return end
    local assigned = Assignments.GetAssignedJobs(player)
    assigned[jobId] = {
        auto = opts and opts.auto == true or false,
        assignedAt = getNowSeconds(),
    }
end

function Assignments.RemoveJob(player, jobId, opts)
    if not player or not jobId then return end
    local assigned = Assignments.GetAssignedJobs(player)
    local entry = assigned[jobId]
    if not entry then return end
    if opts and opts.autoOnly and type(entry) == "table" and not entry.auto then
        return
    end
    assigned[jobId] = nil
end

function Assignments.IsJobEligible(player, def)
    if not player or not def then return false end
    if not matchesProfession(player, def.professions) then
        return false
    end
    local day = getDayStamp()
    if def.minDay and day < def.minDay then
        return false
    end
    if def.maxDay and day > def.maxDay then
        return false
    end
    if def.requiresTransactions and not BWOJobsOverhauled.AreTransactionsEnabled() then
        return false
    end
    if def.disableWhenAnarchy and isAnarchyActive() then
        return false
    end
    return true
end

function Assignments.RefreshAssignments(player)
    if not player then return end
    local assigned = Assignments.GetAssignedJobs(player)
    local now = getNowSeconds()
    local manager = BWOJobsOverhauled.JobManager
    local defs = manager and manager.JobDefinitions or {}

    for _, def in ipairs(defs) do
        local jobId = def.id
        if jobId then
            local autoAssign = def.autoAssign ~= false
            if autoAssign then
                if Assignments.IsJobEligible(player, def) then
                    local entry = assigned[jobId]
                    if not entry then
                        assigned[jobId] = { auto = true, assignedAt = now }
                    elseif type(entry) == "table" then
                        entry.auto = true
                    else
                        assigned[jobId] = { auto = true, assignedAt = now }
                    end
                else
                    local entry = assigned[jobId]
                    if entry == true or (type(entry) == "table" and entry.auto) then
                        assigned[jobId] = nil
                    end
                end
            end
        end
    end

    Assignments.Seeded = true
    Assignments.State.day = getDayStamp()
    Assignments.State.profession = BWOJobsOverhauled.GetProfessionName(player)
    Assignments.State.anarchy = isAnarchyActive()
    Assignments.State.player = player
end

function Assignments.Reset(player)
    Assignments.Seeded = false
    Assignments.State = { player = player }
end

function Assignments.EnsureAssignments(player)
    if not player then return end
    local day = getDayStamp()
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    local anarchy = isAnarchyActive()
    local state = Assignments.State

    if state.player ~= player then
        Assignments.Reset(player)
        Assignments.RefreshAssignments(player)
        return
    end

    if not Assignments.Seeded
        or state.day ~= day
        or state.profession ~= profession
        or state.anarchy ~= anarchy then
        Assignments.RefreshAssignments(player)
    end
end

function Assignments.Update(player)
    Assignments.EnsureAssignments(player)
end
