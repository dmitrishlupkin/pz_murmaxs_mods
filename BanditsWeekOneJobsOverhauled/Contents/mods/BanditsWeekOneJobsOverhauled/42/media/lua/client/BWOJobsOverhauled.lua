require "ISUI/ISButton"
require "ISUI/ISCollapsableWindow"
require "ISUI/BWOJobsOverhauledPanel"

BWOJobsOverhauled = BWOJobsOverhauled or {}
BWOJobsOverhauled.window = nil
BWOJobsOverhauled.button = nil
BWOJobsOverhauled.dailyLimit = 100
BWOJobsOverhauled.Debug = true
BWOJobsOverhauled.deferButton = false
BWOJobsOverhauled.JobBuilders = BWOJobsOverhauled.JobBuilders or {}

BWOJobsOverhauled.Text = function(key)
    return getTextOrNull(key) or getText(key)
end

BWOJobsOverhauled.Log = function(message)
    if not BWOJobsOverhauled.Debug then return end
    print("[BWOJobsOverhauled] " .. tostring(message))
end

local function getDayStamp()
    local hours = getGameTime():getWorldAgeHours()
    return math.floor(hours / 24)
end

BWOJobsOverhauled.EnsureDailyData = function(player)
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

BWOJobsOverhauled.GetDailyTrashData = function(player)
    local data = BWOJobsOverhauled.EnsureDailyData(player)
    return data.trashPickups or 0, data.trashEarnings or 0
end

BWOJobsOverhauled.RegisterJob = function(builder)
    table.insert(BWOJobsOverhauled.JobBuilders, builder)
end

function BWOJobsOverhauled.GetJobs(player)
    local jobs = {}
    if not player then return jobs end
    for _, builder in ipairs(BWOJobsOverhauled.JobBuilders) do
        local job = builder(player)
        if job then
            table.insert(jobs, job)
        end
    end
    return jobs
end

BWOJobsOverhauled.GetProfessionName = function(player)
    if not player then return nil end
    local descriptor = player:getDescriptor()
    if not descriptor then return nil end
    local profession = descriptor:getCharacterProfession()
    if profession and profession.getName then
        return profession:getName()
    end
    return profession
end

BWOJobsOverhauled.AreTransactionsEnabled = function()
    return BWOScheduler and BWOScheduler.Anarchy and BWOScheduler.Anarchy.Transactions
end

BWOJobsOverhauled.HasNearbyFire = function(player)
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

BWOJobsOverhauled.HasNearbyVehicle = function(player)
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

BWOJobsOverhauled.IsInForestZone = function(player)
    local square = player:getSquare()
    if not square then return false end
    local zone = square:getZone()
    if not zone then return false end
    local zoneType = zone:getType()
    return zoneType == "Forest" or zoneType == "DeepForest"
end

BWOJobsOverhauled.HasAnyItemTypes = function(player, itemTypes)
    local inventory = player:getInventory()
    for _, itemType in ipairs(itemTypes) do
        if inventory:containsTypeRecurse(itemType) then
            return true
        end
    end
    return false
end

BWOJobsOverhauled.HasHostileBanditNearby = function(player)
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

function BWOJobsOverhauled.TogglePanel()
    BWOJobsOverhauled.Log("TogglePanel called")
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
    BWOJobsOverhauled.Log("Jobs panel created")
end

function BWOJobsOverhauled.UpdateButtonPosition()
    if not BWOJobsOverhauled.button then return end
    local playerNum = 0
    local x = getPlayerScreenLeft(playerNum) + 10
    local y = getPlayerScreenTop(playerNum) + 200
    BWOJobsOverhauled.button:setX(x)
    BWOJobsOverhauled.button:setY(y)
    BWOJobsOverhauled.Log("Updated button position to x=" .. tostring(x) .. " y=" .. tostring(y))
end

function BWOJobsOverhauled.CreateButton()
    if BWOJobsOverhauled.button then return end
    if type(ISButton) ~= "table" or type(ISButton.new) ~= "function" then
        BWOJobsOverhauled.Log("ISButton not ready; deferring button creation")
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

    local label = BWOJobsOverhauled.Text("UI_BWO_JobsOverhauled_Button")
    if type(label) ~= "string" then
        BWOJobsOverhauled.Log("Button label is not a string, got " .. tostring(type(label)))
        label = tostring(label)
    end

    local ok, button = pcall(ISButton.new, ISButton, x, y, size, size, label, BWOJobsOverhauled, BWOJobsOverhauled.TogglePanel)
    if not ok then
        BWOJobsOverhauled.Log("Failed to create button: " .. tostring(button))
        return
    end
    button:initialise()
    button:setAnchorLeft(true)
    button:setAnchorTop(true)
    button.borderColor = { r = 1, g = 1, b = 1, a = 0.2 }
    button.backgroundColor = { r = 0, g = 0, b = 0, a = 0.4 }
    button:addToUIManager()
    BWOJobsOverhauled.button = button
    BWOJobsOverhauled.Log("Jobs button created")

    if BWOJobsOverhauled.deferButton then
        BWOJobsOverhauled.deferButton = false
        Events.OnTick.Remove(BWOJobsOverhauled.CreateButton)
        BWOJobsOverhauled.Log("Deferred button creation resolved")
    end
end

local function onKeyPressed(key)
    local options = PZAPI.ModOptions:getOptions("BanditsWeekOneJobsOverhauled")
    local option = options and options:getOption("TOGGLE_PANEL")
    if not option then
        BWOJobsOverhauled.Log("Keybind option not available yet")
        return
    end
    if option and key == option.key then
        BWOJobsOverhauled.Log("Toggle panel keybind pressed")
        BWOJobsOverhauled.TogglePanel()
    end
end

local function onGameStart()
    BWOJobsOverhauled.Log("OnGameStart triggered")
    BWOJobsOverhauled.CreateButton()
    BWOJobsOverhauled.UpdateButtonPosition()
end

Events.OnGameStart.Add(onGameStart)
Events.OnResolutionChange.Add(BWOJobsOverhauled.UpdateButtonPosition)
if Events and Events.OnKeyPressed and Events.OnKeyPressed.Add then
    Events.OnKeyPressed.Add(onKeyPressed)
else
    BWOJobsOverhauled.Log("Events.OnKeyPressed not available; skipping keybind hook")
end

require "BWOJobsOverhauledJobs/CleaningJob"
require "BWOJobsOverhauledJobs/FireJob"
require "BWOJobsOverhauledJobs/MechanicJob"
require "BWOJobsOverhauledJobs/ParkRangerJob"
require "BWOJobsOverhauledJobs/FitnessJob"
require "BWOJobsOverhauledJobs/LumberjackJob"
require "BWOJobsOverhauledJobs/FishermanJob"
require "BWOJobsOverhauledJobs/PoliceJob"
