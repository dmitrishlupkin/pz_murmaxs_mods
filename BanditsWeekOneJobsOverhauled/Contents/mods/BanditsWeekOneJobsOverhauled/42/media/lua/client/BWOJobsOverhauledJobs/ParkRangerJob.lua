local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local foragePayout = 25
local junkCategories = {"Junk", "Trash", "Ammunition", "JunkFood", "JunkWeapons"}

local function handleTimedAction(data)
    if not data or not data.character then return false end
    local player = data.character
    if not instanceof(player, "IsoPlayer") then return false end
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "parkranger" then return false end
    if not BWOJobsOverhauled.IsOnDutyAs(player, profession) then return false end
    if not data.action or data.action:getMetaType() ~= "ISForageAction" then return false end
    if data.discardItems or not data.itemDef or not data.itemDef.categories then return false end

    local junk = false
    for _, c1 in pairs(data.itemDef.categories) do
        for _, c2 in pairs(junkCategories) do
            if c1 == c2 then
                junk = true
                break
            end
        end
    end
    if junk then
        BWOJobsOverhauled.PayEarnings(player, foragePayout)
    end
    return true
end

local function buildJob(player, def)
    local payInfo = string.format(text("UI_BWO_JobsOverhauled_Pay_ParkRanger"), tostring(foragePayout))
    local taskText = string.format("%s (%s)", text("UI_BWO_JobsOverhauled_Task_ParkRanger"), payInfo)

    return {
        id = def.id,
        text = def.text,
        tasks = {
            {
                id = "parkranger_task",
                text = taskText,
                conditions = {
                    {
                        id = "parkranger_forest",
                        text = text("UI_BWO_JobsOverhauled_Cond_ParkRanger_Forest"),
                        check = function()
                            return BWOJobsOverhauled.IsInForestZone(player)
                        end,
                    },
                    {
                        id = "parkranger_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_ParkRanger_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.IsOnDutyAs(player, "parkranger")
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterTimedActionHandler(handleTimedAction)
BWOJobsOverhauled.RegisterJob({
    id = "parkranger",
    text = text("UI_BWO_JobsOverhauled_Job_ParkRanger"),
    professions = "parkranger",
    requiresTransactions = true,
    build = buildJob,
})
