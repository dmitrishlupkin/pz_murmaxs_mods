--- @module BWOJobsOverhauledJobs.MechanicJob
--- @summary Mechanic job: pay for vehicle repairs on duty in BWO vehicles.
--- @details Implemented: payouts for fixing parts, engine repair, and installing parts using BWO vehicle mod data.
--- @todo Add AI behavior block and review reward scaling vs base game repair costs.
local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local fixPartMultiplier = 5
local repairEngineMultiplier = 20
local installPartDivisor = 5

local function handleTimedAction(data)
    if not data or not data.character then return false end
    local player = data.character
    if not instanceof(player, "IsoPlayer") then return false end
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "mechanics" then return false end
    if not BWOJobsOverhauled.IsOnDutyAs(player, profession) then return false end

    local action = data.action and data.action:getMetaType()
    if not action then return false end

    if action == "ISFixVehiclePartAction" then
        local vehiclePart = data.vehiclePart
        local vehicle = vehiclePart and vehiclePart:getVehicle()
        local md = vehicle and vehicle:getModData()
        if md and md.BWO and md.BWO.client then
            local skill = player:getPerkLevel(Perks.MetalWelding)
            BWOJobsOverhauled.PayEarnings(player, skill * fixPartMultiplier)
        end
        return true
    end

    if action == "ISRepairEngine" then
        local vehicle = data.vehicle
        local md = vehicle and vehicle:getModData()
        if md and md.BWO and md.BWO.client then
            local skill = player:getPerkLevel(Perks.Mechanics)
            BWOJobsOverhauled.PayEarnings(player, skill * repairEngineMultiplier)
        end
        return true
    end

    if action == "ISInstallVehiclePart" then
        local vehiclePart = data.part
        local vehicle = vehiclePart and vehiclePart:getVehicle()
        local md = vehicle and vehicle:getModData()
        if md and md.BWO and md.BWO.client then
            local id = vehiclePart:getScriptPart():getId()
            local idx
            if BWOVehicles and BWOVehicles.parts then
                for k, v in pairs(BWOVehicles.parts) do
                    if id == v then
                        idx = k
                    end
                end
            end
            if idx then
                local item = data.item
                local oldCondition = md.BWO.parts[idx]
                local newCondition = item:getCondition()
                BWOJobsOverhauled.PayEarnings(player, math.ceil((newCondition - oldCondition) * item:getWeight() / installPartDivisor))
                md.BWO.parts[idx] = newCondition
            end
        end
        return true
    end

    return false
end

local function buildJob(player, def)
    local payInfo = string.format(
        text("UI_BWO_JobsOverhauled_Pay_Mechanic"),
        tostring(fixPartMultiplier),
        tostring(repairEngineMultiplier)
    )
    local taskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_Mechanic"), payInfo)

    return {
        id = def.id,
        text = def.text,
        tasks = {
            {
                id = "mechanic_task",
                text = taskText,
                conditions = {
                    {
                        id = "mechanic_vehicle",
                        text = text("UI_BWO_JobsOverhauled_Cond_Mechanic_Nearby"),
                        check = function()
                            return BWOJobsOverhauled.HasNearbyVehicle(player)
                        end,
                    },
                    {
                        id = "mechanic_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Mechanic_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.IsOnDutyAs(player, "mechanics")
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterTimedActionHandler(handleTimedAction)
BWOJobsOverhauled.RegisterJob({
    id = "mechanic",
    text = text("UI_BWO_JobsOverhauled_Job_Mechanic"),
    professions = "mechanics",
    requiresTransactions = true,
    build = buildJob,
})
