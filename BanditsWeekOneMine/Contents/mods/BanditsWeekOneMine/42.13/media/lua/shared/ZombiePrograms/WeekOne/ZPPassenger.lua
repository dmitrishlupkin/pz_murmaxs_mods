ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Passenger = {}

ZombiePrograms.Passenger.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)
  
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Passenger.Main = function(bandit)
    local tasks = {}
    local cell = bandit:getCell()
    local brain = BanditBrain.Get(bandit)
    local id = brain.id
    local bx = math.floor(bandit:getX())
    local by = math.floor(bandit:getY())
    local bz = math.floor(bandit:getZ())
    local walkType = "Walk"
    local endurance = 0

    -- symptoms
    --[[
    if math.abs(id) % 4 > 0 then
        if BWOScheduler.SymptomLevel == 3 then
            walkType = "Limp"
        elseif BWOScheduler.SymptomLevel >= 4 then
            walkType = "Scramble"
        end

        local subTasks = BanditPrograms.Symptoms(bandit)
        if #subTasks > 0 then
            for _, subTask in pairs(subTasks) do
                table.insert(tasks, subTask)
            end
            
            return {status=true, next="Main", tasks=tasks}
        end
    end
    ]]


    local anim = "SitInChair2"
    local sound
    local item
    local right = false
    local left = false
    local facing = "W"

    local task = {action="SitInChair", anim=anim, left=left, right=right, sound=sound, item=item, x=bz, y=by, z=bz, facing=facing, time=100}
    table.insert(tasks, task)
    return {status=true, next="Main", tasks=tasks}
end