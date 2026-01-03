require "ISUI/ISButton"
require "ISUI/ISCollapsableWindow"
require "ISUI/BWOJobsOverhauledPanel"

BWOJobsOverhauled = BWOJobsOverhauled or {}
BWOJobsOverhauled.window = nil
BWOJobsOverhauled.button = nil
BWOJobsOverhauled.dailyLimit = 100
BWOJobsOverhauled.Debug = true
BWOJobsOverhauled.deferButton = false

local function text(key)
    return getTextOrNull(key) or getText(key)
end

local function bwolog(message)
    if not BWOJobsOverhauled.Debug then return end
    print("[BWOJobsOverhauled] " .. tostring(message))
end

local function getDayStamp()
    local hours = getGameTime():getWorldAgeHours()
    return math.floor(hours / 24)
end

local function ensureDailyData(player)
    local md = player:getModData()
    md.BWOJobsOverhauled = md.BWOJobsOverhauled or {}
    local data = md.BWOJobsOverhauled
    local day = getDayStamp()
    if data.day ~= day then
        data.day = day
        data.trashPickups = 0
        data.trashEarnings = 0
    end
    return data
end

function BWOJobsOverhauled.RecordTrashPickup(player, amount)
    local data = ensureDailyData(player)
    data.trashPickups = (data.trashPickups or 0) + 1
    data.trashEarnings = (data.trashEarnings or 0) + (amount or 0)
    bwolog("Recorded trash pickup. Count=" .. tostring(data.trashPickups) .. " earnings=" .. tostring(data.trashEarnings))
end

function BWOJobsOverhauled.GetDailyTrashData(player)
    local data = ensureDailyData(player)
    return data.trashPickups or 0, data.trashEarnings or 0
end

local function hasNearbyFire(player)
    local cell = getCell()
    if not cell then return false end
    local px = math.floor(player:getX())
    local py = math.floor(player:getY())
    local pz = math.floor(player:getZ())
    for dx = -1, 1 do
        for dy = -1, 1 do
            local square = cell:getGridSquare(px + dx, py + dy, pz)
            if square then
                local objects = square:getObjects()
                for i = 0, objects:size() - 1 do
                    local object = objects:get(i)
                    if instanceof(object, "IsoFire") and not object:isPermanent() then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function hasNearbyVehicle(player)
    local cell = getCell()
    if not cell then return false end
    local px = math.floor(player:getX())
    local py = math.floor(player:getY())
    local pz = math.floor(player:getZ())
    for dx = -1, 1 do
        for dy = -1, 1 do
            local square = cell:getGridSquare(px + dx, py + dy, pz)
            if square and square:getVehicleContainer() then
                return true
            end
        end
    end
    return false
end

local function isInForestZone(player)
    local square = player:getSquare()
    if not square then return false end
    local zone = square:getZone()
    if not zone then return false end
    local zoneType = zone:getType()
    return zoneType == "Forest" or zoneType == "DeepForest"
end

local function hasAnyItemTypes(player, itemTypes)
    local inventory = player:getInventory()
    for _, itemType in ipairs(itemTypes) do
        if inventory:containsTypeRecurse(itemType) then
            return true
        end
    end
    return false
end

local function hasHostileBanditNearby(player)
    if not BanditZombie or not BanditZombie.GetAllB then return false end
    local bandits = BanditZombie.GetAllB()
    local px = player:getX()
    local py = player:getY()
    for _, bandit in pairs(bandits) do
        local brain = bandit.brain
        if brain and (brain.hostile or (brain.program and brain.program.name == "Vandal")) then
            if math.abs(bandit.x - px) < 20 or math.abs(bandit.y - py) < 20 then
                local dist = IsoUtils.DistanceTo(px, py, bandit.x, bandit.y)
                if dist <= 20 then
                    return true
                end
            end
        end
    end
    return false
end

local fishTypes = {
    "Base.Bass",
    "Base.SmallmouthBass",
    "Base.LargemouthBass",
    "Base.SpottedBass",
    "Base.StripedBass",
    "Base.WhiteBass",
    "Base.Catfish",
    "Base.BlueCatfish",
    "Base.ChannelCatfish",
    "Base.FlatheadCatfish",
    "Base.Panfish",
    "Base.RedearSunfish",
    "Base.Crayfish",
    "Base.Crappie",
    "Base.BlackCrappie",
    "Base.WhiteCrappie",
    "Base.Perch",
    "Base.Paddlefish",
    "Base.YellowPerch",
    "Base.Pike",
    "Base.Trout",
}

local function getProfession(player)
    return player:getDescriptor():getCharacterProfession()
end

function BWOJobsOverhauled.GetJobs(player)
    if not player then return {} end
    local profession = getProfession(player)
    local trashPickups, trashEarnings = BWOJobsOverhauled.GetDailyTrashData(player)
    bwolog("Building jobs list for profession=" .. tostring(profession))

    local jobs = {
        {
            id = "cleaning",
            text = text("UI_BWO_JobsOverhauled_Job_Cleaning"),
            tasks = {
                {
                    id = "cleaning_task",
                    text = text("UI_BWO_JobsOverhauled_Task_Cleaning"),
                    conditions = {
                        {
                            id = "cleaning_pickup",
                            text = text("UI_BWO_JobsOverhauled_Cond_Cleaning_Pickup"),
                            check = function()
                                return trashPickups > 0
                            end,
                        },
                        {
                            id = "cleaning_limit",
                            text = text("UI_BWO_JobsOverhauled_Cond_Cleaning_Limit"),
                            check = function()
                                return trashEarnings <= BWOJobsOverhauled.dailyLimit
                            end,
                        },
                    },
                },
            },
        },
    }

    if profession == "fireofficer" then
        table.insert(jobs, {
            id = "fire",
            text = text("UI_BWO_JobsOverhauled_Job_Fire"),
            tasks = {
                {
                    id = "fire_task",
                    text = text("UI_BWO_JobsOverhauled_Task_Fire"),
                    conditions = {
                        {
                            id = "fire_nearby",
                            text = text("UI_BWO_JobsOverhauled_Cond_Fire_Nearby"),
                            check = function()
                                return hasNearbyFire(player)
                            end,
                        },
                        {
                            id = "fire_profession",
                            text = text("UI_BWO_JobsOverhauled_Cond_Fire_OnDuty"),
                            check = function()
                                return profession == "fireofficer"
                            end,
                        },
                    },
                },
            },
        })
    end

    if profession == "mechanics" then
        table.insert(jobs, {
            id = "mechanic",
            text = text("UI_BWO_JobsOverhauled_Job_Mechanic"),
            tasks = {
                {
                    id = "mechanic_task",
                    text = text("UI_BWO_JobsOverhauled_Task_Mechanic"),
                    conditions = {
                        {
                            id = "mechanic_vehicle",
                            text = text("UI_BWO_JobsOverhauled_Cond_Mechanic_Nearby"),
                            check = function()
                                return hasNearbyVehicle(player)
                            end,
                        },
                        {
                            id = "mechanic_profession",
                            text = text("UI_BWO_JobsOverhauled_Cond_Mechanic_OnDuty"),
                            check = function()
                                return profession == "mechanics"
                            end,
                        },
                    },
                },
            },
        })
    end

    if profession == "parkranger" then
        table.insert(jobs, {
            id = "parkranger",
            text = text("UI_BWO_JobsOverhauled_Job_ParkRanger"),
            tasks = {
                {
                    id = "parkranger_task",
                    text = text("UI_BWO_JobsOverhauled_Task_ParkRanger"),
                    conditions = {
                        {
                            id = "parkranger_forest",
                            text = text("UI_BWO_JobsOverhauled_Cond_ParkRanger_Forest"),
                            check = function()
                                return isInForestZone(player)
                            end,
                        },
                        {
                            id = "parkranger_profession",
                            text = text("UI_BWO_JobsOverhauled_Cond_ParkRanger_OnDuty"),
                            check = function()
                                return profession == "parkranger"
                            end,
                        },
                    },
                },
            },
        })
    end

    if profession == "fitnessInstructor" then
        table.insert(jobs, {
            id = "fitness",
            text = text("UI_BWO_JobsOverhauled_Job_Fitness"),
            tasks = {
                {
                    id = "fitness_task",
                    text = text("UI_BWO_JobsOverhauled_Task_Fitness"),
                    conditions = {
                        {
                            id = "fitness_profession",
                            text = text("UI_BWO_JobsOverhauled_Cond_Fitness_OnDuty"),
                            check = function()
                                return profession == "fitnessInstructor"
                            end,
                        },
                    },
                },
            },
        })
    end

    if profession == "lumberjack" then
        table.insert(jobs, {
            id = "lumberjack",
            text = text("UI_BWO_JobsOverhauled_Job_Lumberjack"),
            tasks = {
                {
                    id = "lumberjack_task",
                    text = text("UI_BWO_JobsOverhauled_Task_Lumberjack"),
                    conditions = {
                        {
                            id = "lumberjack_items",
                            text = text("UI_BWO_JobsOverhauled_Cond_Lumberjack_Carrying"),
                            check = function()
                                return hasAnyItemTypes(player, {"Base.Log", "Base.Plank"})
                            end,
                        },
                        {
                            id = "lumberjack_profession",
                            text = text("UI_BWO_JobsOverhauled_Cond_Lumberjack_OnDuty"),
                            check = function()
                                return profession == "lumberjack"
                            end,
                        },
                    },
                },
            },
        })
    end

    if profession == "fisherman" then
        table.insert(jobs, {
            id = "fisherman",
            text = text("UI_BWO_JobsOverhauled_Job_Fisherman"),
            tasks = {
                {
                    id = "fisherman_task",
                    text = text("UI_BWO_JobsOverhauled_Task_Fisherman"),
                    conditions = {
                        {
                            id = "fisherman_items",
                            text = text("UI_BWO_JobsOverhauled_Cond_Fisherman_Carrying"),
                            check = function()
                                return hasAnyItemTypes(player, fishTypes)
                            end,
                        },
                        {
                            id = "fisherman_profession",
                            text = text("UI_BWO_JobsOverhauled_Cond_Fisherman_OnDuty"),
                            check = function()
                                return profession == "fisherman"
                            end,
                        },
                    },
                },
            },
        })
    end

    if profession == "policeofficer" then
        table.insert(jobs, {
            id = "police",
            text = text("UI_BWO_JobsOverhauled_Job_Police"),
            tasks = {
                {
                    id = "police_task",
                    text = text("UI_BWO_JobsOverhauled_Task_Police"),
                    conditions = {
                        {
                            id = "police_threat",
                            text = text("UI_BWO_JobsOverhauled_Cond_Police_Threat"),
                            check = function()
                                return hasHostileBanditNearby(player)
                            end,
                        },
                        {
                            id = "police_profession",
                            text = text("UI_BWO_JobsOverhauled_Cond_Police_OnDuty"),
                            check = function()
                                return profession == "policeofficer"
                            end,
                        },
                    },
                },
            },
        })
    end

    return jobs
end

function BWOJobsOverhauled.TogglePanel()
    bwolog("TogglePanel called")
    if BWOJobsOverhauled.window then
        local visible = not BWOJobsOverhauled.window:getIsVisible()
        BWOJobsOverhauled.window:setVisible(visible)
        if visible then
            BWOJobsOverhauled.window:refreshList()
            BWOJobsOverhauled.window:bringToTop()
        end
        return
    end

    local playerNum = 0
    local x = getPlayerScreenLeft(playerNum) + 200
    local y = getPlayerScreenTop(playerNum) + 100

    local window = BWOJobsOverhauledPanel:new(x, y, 460, 420, playerNum)
    window:initialise()
    window:addToUIManager()
    window:refreshList()
    ISLayoutManager.RegisterWindow('bwojobsoverhauled', ISCollapsableWindow, window)

    BWOJobsOverhauled.window = window
    bwolog("Jobs panel created")
end

function BWOJobsOverhauled.UpdateButtonPosition()
    if not BWOJobsOverhauled.button then return end
    local playerNum = 0
    local x = getPlayerScreenLeft(playerNum) + 10
    local y = getPlayerScreenTop(playerNum) + 200
    BWOJobsOverhauled.button:setX(x)
    BWOJobsOverhauled.button:setY(y)
    bwolog("Updated button position to x=" .. tostring(x) .. " y=" .. tostring(y))
end

function BWOJobsOverhauled.CreateButton()
    if BWOJobsOverhauled.button then return end
    if type(ISButton) ~= "table" or type(ISButton.new) ~= "function" then
        bwolog("ISButton not ready; deferring button creation")
        if not BWOJobsOverhauled.deferButton then
            BWOJobsOverhauled.deferButton = true
            Events.OnTick.Add(BWOJobsOverhauled.CreateButton)
        end
        return
    end

    local playerNum = 0
    local x = getPlayerScreenLeft(playerNum) + 10
    local y = getPlayerScreenTop(playerNum) + 200
    local size = 36

    local label = text("UI_BWO_JobsOverhauled_Button")
    if type(label) ~= "string" then
        bwolog("Button label is not a string, got " .. tostring(type(label)))
        label = tostring(label)
    end

    local ok, button = pcall(ISButton.new, ISButton, x, y, size, size, label, BWOJobsOverhauled, BWOJobsOverhauled.TogglePanel)
    if not ok then
        bwolog("Failed to create button: " .. tostring(button))
        return
    end
    button:initialise()
    button:setAnchorLeft(true)
    button:setAnchorTop(true)
    button.borderColor = { r = 1, g = 1, b = 1, a = 0.2 }
    button.backgroundColor = { r = 0, g = 0, b = 0, a = 0.4 }
    button:addToUIManager()
    BWOJobsOverhauled.button = button
    bwolog("Jobs button created")

    if BWOJobsOverhauled.deferButton then
        BWOJobsOverhauled.deferButton = false
        Events.OnTick.Remove(BWOJobsOverhauled.CreateButton)
        bwolog("Deferred button creation resolved")
    end
end

local function onTimedActionPerformed(data)
    if not data or not data.character then return end
    if not instanceof(data.character, "IsoPlayer") then return end
    local action = data.action and data.action:getMetaType()
    if action ~= "ISMoveablesAction" then return end

    if data.mode == "pickup" and data.origSpriteName and data.origSpriteName:embodies("trash") then
        bwolog("Trash pickup detected by timed action")
        BWOJobsOverhauled.RecordTrashPickup(data.character, 1)
    end
end

local function onKeyPressed(key)
    local options = PZAPI.ModOptions:getOptions("BanditsWeekOneJobsOverhauled")
    local option = options and options:getOption("TOGGLE_PANEL")
    if not option then
        bwolog("Keybind option not available yet")
        return
    end
    if option and key == option.key then
        bwolog("Toggle panel keybind pressed")
        BWOJobsOverhauled.TogglePanel()
    end
end

local function onGameStart()
    bwolog("OnGameStart triggered")
    BWOJobsOverhauled.CreateButton()
    BWOJobsOverhauled.UpdateButtonPosition()
end

Events.OnGameStart.Add(onGameStart)
Events.OnResolutionChange.Add(BWOJobsOverhauled.UpdateButtonPosition)
if Events and Events.OnTimedActionPerformed and Events.OnTimedActionPerformed.Add then
    Events.OnTimedActionPerformed.Add(onTimedActionPerformed)
else
    bwolog("Events.OnTimedActionPerformed not available; skipping trash pickup hook")
end

if Events and Events.OnKeyPressed and Events.OnKeyPressed.Add then
    Events.OnKeyPressed.Add(onKeyPressed)
else
    bwolog("Events.OnKeyPressed not available; skipping keybind hook")
end
