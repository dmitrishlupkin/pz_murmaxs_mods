require "ISUI/ISButton"
require "ISUI/ISCollapsableWindow"
require "ISUI/BWOJobsOverhauledPanel"

BWOJobsOverhauled = BWOJobsOverhauled or {}
require "BWOJobsOverhauledJobManager"
require "BWOJobsOverhauledConditions"
require "BWOJobsOverhauledAssignments"
require "BWOJobsOverhauledAI"

BWOJobsOverhauled.window = nil
BWOJobsOverhauled.button = nil
BWOJobsOverhauled.Debug = true
BWOJobsOverhauled.deferButton = false
BWOJobsOverhauled.AllowEarn = BWOJobsOverhauled.AllowEarn or false
BWOJobsOverhauled.GameStartPending = false
BWOJobsOverhauled.GameStartApplied = false
BWOJobsOverhauled.LastPlayer = nil
BWOJobsOverhauled.WorkAssignmentPending = false

BWOJobsOverhauled.Text = function(key)
    return getTextOrNull(key) or getText(key)
end

BWOJobsOverhauled.IsWorldReady = function()
    local player = getSpecificPlayer(0)
    if not player or not player.getSquare or not player:getSquare() then
        return false
    end
    return getCell() ~= nil
end

BWOJobsOverhauled.Log = function(message)
    if not BWOJobsOverhauled.Debug then return end
    print("[BWOJobsOverhauled] " .. tostring(message))
end

local function setWorldMapWorkSymbol(player, work)
    if not player or not work or not work.x or not work.y then return end
    if not getWorld() or not getWorld():getCell() then return end
    if not ISWorldMap_instance or not ISWorldMap_instance.mapAPI then return end
    local mapAPI = ISWorldMap_instance.mapAPI
    if not mapAPI.getSymbolsAPIv2 then return end
    local symbolsAPI = mapAPI:getSymbolsAPIv2()
    if not symbolsAPI or not symbolsAPI.addTexture then return end
    local texture = "media/textures/worldMap/Map_On.png"
    local symbol = work.worldMapSymbol
    if symbol and symbol.setPosition then
        symbol:setPosition(work.x, work.y)
        return true
    else
        local ok, sym = pcall(symbolsAPI.addTexture, symbolsAPI, texture, work.x, work.y)
        if ok and sym then
            sym:setRGBA(0.3, 0.8, 1.0, 1.0)
            sym:setAnchor(0.5, 0.5)
            work.worldMapSymbol = sym
            return true
        end
    end
    return false
end

local function trySetWorldMapSymbol()
    local player = getSpecificPlayer(0)
    if not player then return end
    local work = BWOJobsOverhauled.GetWorkData(player)
    if not work or not work.x or not work.y then return end
    if setWorldMapWorkSymbol(player, work) then
        BWOJobsOverhauled.WorldMapSymbolPending = false
        Events.OnTick.Remove(trySetWorldMapSymbol)
    end
end

BWOJobsOverhauled.RequestWorldMapSymbol = function(player)
    if BWOJobsOverhauled.WorldMapSymbolPending then return end
    BWOJobsOverhauled.WorldMapSymbolPending = true
    Events.OnTick.Add(trySetWorldMapSymbol)
end

local function trySetWorkMarker()
    if not BanditEventMarkerHandler or not getCell() then return end
    local player = getSpecificPlayer(0)
    if not player then return end
    local work = BWOJobsOverhauled.GetWorkData(player)
    if not work or not work.keyId or not work.x or not work.y then return end
    BWOJobsOverhauled.WorkMarkerPending = false
    Events.OnTick.Remove(trySetWorkMarker)
    BWOJobsOverhauled.EnsureWorkMarker(player)
end

BWOJobsOverhauled.RequestWorkMarker = function(player)
    if BWOJobsOverhauled.WorkMarkerPending then return end
    BWOJobsOverhauled.WorkMarkerPending = true
    Events.OnTick.Add(trySetWorkMarker)
end

local function cleanupUI()
    if BWOJobsOverhauled.window then
        BWOJobsOverhauled.window:removeFromUIManager()
        BWOJobsOverhauled.window = nil
    end
    if BWOJobsOverhauled.button then
        BWOJobsOverhauled.button:removeFromUIManager()
        BWOJobsOverhauled.button = nil
    end
    if BWOJobsOverhauled.deferButton then
        BWOJobsOverhauled.deferButton = false
        Events.OnTick.Remove(BWOJobsOverhauled.CreateButton)
    end
    if BWOJobsOverhauled.WorldMapSymbolPending then
        BWOJobsOverhauled.WorldMapSymbolPending = false
        Events.OnTick.Remove(trySetWorldMapSymbol)
    end
    if BWOJobsOverhauled.WorkMarkerPending then
        BWOJobsOverhauled.WorkMarkerPending = false
        Events.OnTick.Remove(trySetWorkMarker)
    end
    if BWOJobsOverhauled.WorkAssignmentPending then
        BWOJobsOverhauled.WorkAssignmentPending = false
        Events.OnTick.Remove(BWOJobsOverhauled.TryAssignWorkLocation)
    end
    if BWOJobsOverhauled.GameStartPending and BWOJobsOverhauled.TryGameStart then
        BWOJobsOverhauled.GameStartPending = false
        Events.OnTick.Remove(BWOJobsOverhauled.TryGameStart)
    end
    BWOJobsOverhauled.GameStartApplied = false
    BWOJobsOverhauled.LastPlayer = nil
end

BWOJobsOverhauled.EnsureWorkMarker = function(player)
    if not player then return end
    if not getCell() then return end
    if not BanditEventMarkerHandler then
        BWOJobsOverhauled.RequestWorkMarker(player)
        return
    end
    local work = BWOJobsOverhauled.GetWorkData(player)
    if not work or not work.keyId or not work.x or not work.y then return end
    local desc = BWOJobsOverhauled.Text("UI_BWO_JobsOverhauled_Work_Marker")
    local color = { r = 0.3, g = 0.8, b = 1.0 }
    local markerId = work.markerId or getRandomUUID()
    work.markerId = markerId
    BanditEventMarkerHandler.set(markerId, "media/ui/defend.png", 604800, work.x, work.y, color, desc)
end

function BWOJobsOverhauled.TogglePanel()
    BWOJobsOverhauled.Log("TogglePanel called")
    if not BWOJobsOverhauled.IsWorldReady() then
        BWOJobsOverhauled.Log("World not ready; cannot open panel")
        return
    end
    if type(BWOJobsOverhauledPanel) ~= "table" or type(BWOJobsOverhauledPanel.new) ~= "function" then
        local ok, err = pcall(require, "ISUI/BWOJobsOverhauledPanel")
        if not ok then
            BWOJobsOverhauled.Log("Failed to load panel: " .. tostring(err))
            return
        end
    end
    if type(BWOJobsOverhauledPanel) ~= "table" or type(BWOJobsOverhauledPanel.new) ~= "function" then
        BWOJobsOverhauled.Log("Panel class not available; cannot open window")
        return
    end
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
    if not BWOJobsOverhauled.IsWorldReady() then return end
    local playerNum = 0
    local x = getPlayerScreenLeft(playerNum) + 90
    local y = getPlayerScreenTop(playerNum) + 200
    BWOJobsOverhauled.button:setX(x)
    BWOJobsOverhauled.button:setY(y)
    BWOJobsOverhauled.Log("Updated button position to x=" .. tostring(x) .. " y=" .. tostring(y))
end

function BWOJobsOverhauled.CreateButton()
    if BWOJobsOverhauled.button then return end
    if not BWOJobsOverhauled.IsWorldReady() then
        if not BWOJobsOverhauled.deferButton then
            BWOJobsOverhauled.deferButton = true
            Events.OnTick.Add(BWOJobsOverhauled.CreateButton)
        end
        return
    end
    if type(ISButton) ~= "table" or type(ISButton.new) ~= "function" then
        BWOJobsOverhauled.Log("ISButton not ready; deferring button creation")
        if not BWOJobsOverhauled.deferButton then
            BWOJobsOverhauled.deferButton = true
            Events.OnTick.Add(BWOJobsOverhauled.CreateButton)
        end
        return
    end

    local playerNum = 0
    local x = getPlayerScreenLeft(playerNum) + 90
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

local function onFitnessActionExeLooped(data)
    if not data or not data.character then return end
    BWOJobsOverhauled.HandleExercise(data.character, data)
end

local function patchBWOPlayerEarnings()
    if not BWOPlayer or BWOJobsOverhauled.PatchedBWOPlayer then return end
    BWOJobsOverhauled.OriginalEarn = BWOJobsOverhauled.OriginalEarn or BWOPlayer.Earn
    BWOPlayer.Earn = function(character, cnt)
        if instanceof(character, "IsoPlayer") and not character:isNPC() then
            if not BWOJobsOverhauled.AllowEarn then
                return
            end
        end
        if BWOJobsOverhauled.OriginalEarn then
            return BWOJobsOverhauled.OriginalEarn(character, cnt)
        end
    end

    BWOJobsOverhauled.OriginalCheckFriendlyFire = BWOJobsOverhauled.OriginalCheckFriendlyFire or BWOPlayer.CheckFriendlyFire
    BWOPlayer.CheckFriendlyFire = function(bandit, attacker)
        BWOJobsOverhauled.HandleFriendlyFire(bandit, attacker)
        if BWOJobsOverhauled.OriginalCheckFriendlyFire then
            return BWOJobsOverhauled.OriginalCheckFriendlyFire(bandit, attacker)
        end
    end
    if BanditPlayer then
        BanditPlayer.CheckFriendlyFire = BWOPlayer.CheckFriendlyFire
    end

    BWOJobsOverhauled.OriginalActivateExcercise = BWOJobsOverhauled.OriginalActivateExcercise or BWOPlayer.ActivateExcercise
    BWOPlayer.ActivateExcercise = function(character, min)
        if BWOJobsOverhauled.HandleExercise(character, min) then
            return
        end
        if BWOJobsOverhauled.OriginalActivateExcercise then
            return BWOJobsOverhauled.OriginalActivateExcercise(character, min)
        end
    end

    BWOJobsOverhauled.PatchedBWOPlayer = true
end

local function patchBWORooms()
    if not BWORooms or BWOJobsOverhauled.PatchedBWORooms then return end
    if BWORooms.IsIntrusion then
        BWOJobsOverhauled.OriginalIsIntrusion = BWOJobsOverhauled.OriginalIsIntrusion or BWORooms.IsIntrusion
        BWORooms.IsIntrusion = function(room)
            if room then
                local building = room:getBuilding()
                if building and (BWOJobsOverhauled.IsWorkBuilding(building) or BWOJobsOverhauled.IsVisitBuilding(building)) then
                    return false
                end
            end
            if BWOJobsOverhauled.OriginalIsIntrusion then
                return BWOJobsOverhauled.OriginalIsIntrusion(room)
            end
            return false
        end
    end

    if BWORooms.TakeIntention then
        BWOJobsOverhauled.OriginalTakeIntention = BWOJobsOverhauled.OriginalTakeIntention or BWORooms.TakeIntention
        BWORooms.TakeIntention = function(room, customName)
            if room then
                local building = room:getBuilding()
                if building and BWOJobsOverhauled.IsWorkBuilding(building) then
                    return true, false
                end
                if building and BWOJobsOverhauled.IsVisitBuilding(building) then
                    local permission = BWOJobsOverhauled.GetVisitPermission(building)
                    if permission and permission.allowTake then
                        return true, false
                    end
                end
            end
            if BWOJobsOverhauled.OriginalTakeIntention then
                return BWOJobsOverhauled.OriginalTakeIntention(room, customName)
            end
            return false, false
        end
    end

    BWOJobsOverhauled.PatchedBWORooms = true
end

local function onTimedActionPerform(data)
    if BWOJobsOverhauled.HandleTimedAction then
        BWOJobsOverhauled.HandleTimedAction(data)
    end
end

local function onInventoryTransferAction(data)
    if BWOJobsOverhauled.HandleInventoryTransfer then
        BWOJobsOverhauled.HandleInventoryTransfer(data)
    end
end

local function onEveryOneMinute()
    if not BWOJobsOverhauled.IsWorldReady() then return end
    local player = getSpecificPlayer(0)
    if not player then return end
    if BWOJobsOverhauled.AreTransactionsEnabled() then
        BWOJobsOverhauled.UpdateWorkDuty(player)
    end
end

local function isGameStartApplied(player)
    return BWOJobsOverhauled.GameStartApplied and BWOJobsOverhauled.LastPlayer == player
end

local function applyGameStart(player)
    if not player then return false end
    if BWOJobsOverhauled.LastPlayer ~= player then
        BWOJobsOverhauled.LastPlayer = player
        BWOJobsOverhauled.GameStartApplied = false
    end
    if BWOJobsOverhauled.GameStartApplied then return false end
    BWOJobsOverhauled.CreateButton()
    BWOJobsOverhauled.UpdateButtonPosition()
    BWOJobsOverhauled.IssueWorkKey(player, BWOJobsOverhauled.GetWorkData(player))
    BWOJobsOverhauled.EnsureWorkMarker(player)
    BWOJobsOverhauled.IssueStarterGear(player)
    if BWOJobsOverhauled.Assignments and BWOJobsOverhauled.Assignments.RequestUpdate then
        BWOJobsOverhauled.Assignments.RequestUpdate()
    end
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    local work = BWOJobsOverhauled.GetWorkData(player)
    if BWOJobsOverhauled.RequiresWorkLocation(profession) and not work.assigned and not work.keyId then
        if not BWOJobsOverhauled.WorkAssignmentPending then
            BWOJobsOverhauled.WorkAssignmentPending = true
            Events.OnTick.Add(BWOJobsOverhauled.TryAssignWorkLocation)
        end
    end
    BWOJobsOverhauled.GameStartApplied = true
    return true
end

BWOJobsOverhauled.TryGameStart = function()
    if not BWOJobsOverhauled.IsWorldReady() then return end
    local player = getSpecificPlayer(0)
    if not player then return end
    if isGameStartApplied(player) then
        BWOJobsOverhauled.GameStartPending = false
        Events.OnTick.Remove(BWOJobsOverhauled.TryGameStart)
        return
    end
    if applyGameStart(player) then
        BWOJobsOverhauled.GameStartPending = false
        Events.OnTick.Remove(BWOJobsOverhauled.TryGameStart)
    end
end

local function onGameStart()
    BWOJobsOverhauled.Log("OnGameStart triggered")
    patchBWOPlayerEarnings()
    patchBWORooms()
    if not BWOJobsOverhauled.IsWorldReady() then
        if not BWOJobsOverhauled.GameStartPending then
            BWOJobsOverhauled.GameStartPending = true
            Events.OnTick.Add(BWOJobsOverhauled.TryGameStart)
        end
        return
    end
    local player = getSpecificPlayer(0)
    if not player then
        if not BWOJobsOverhauled.GameStartPending then
            BWOJobsOverhauled.GameStartPending = true
            Events.OnTick.Add(BWOJobsOverhauled.TryGameStart)
        end
        return
    end
    applyGameStart(player)
end

local function onCreatePlayer(playerIndex)
    local player = getSpecificPlayer(playerIndex or 0)
    if not player then return end
    if not BWOJobsOverhauled.IsWorldReady() then
        if not BWOJobsOverhauled.GameStartPending then
            BWOJobsOverhauled.GameStartPending = true
            Events.OnTick.Add(BWOJobsOverhauled.TryGameStart)
        end
        return
    end
    applyGameStart(player)
end

Events.OnGameStart.Add(onGameStart)
if Events and Events.OnCreatePlayer and Events.OnCreatePlayer.Add then
    Events.OnCreatePlayer.Add(onCreatePlayer)
end
if Events and Events.OnGameExit and Events.OnGameExit.Add then
    Events.OnGameExit.Add(cleanupUI)
end
if Events and Events.OnMainMenuEnter and Events.OnMainMenuEnter.Add then
    Events.OnMainMenuEnter.Add(cleanupUI)
end
Events.OnResolutionChange.Add(BWOJobsOverhauled.UpdateButtonPosition)
Events.OnTimedActionPerform.Add(onTimedActionPerform)
Events.OnInventoryTransferActionPerform.Add(onInventoryTransferAction)
Events.EveryOneMinute.Add(onEveryOneMinute)
if Events and Events.OnKeyPressed and Events.OnKeyPressed.Add then
    Events.OnKeyPressed.Add(onKeyPressed)
else
    BWOJobsOverhauled.Log("Events.OnKeyPressed not available; skipping keybind hook")
end
if Events and Events.OnFitnessActionExeLooped and Events.OnFitnessActionExeLooped.Add then
    BWOJobsOverhauled.UseFitnessLooped = true
    Events.OnFitnessActionExeLooped.Add(onFitnessActionExeLooped)
else
    BWOJobsOverhauled.UseFitnessLooped = false
    BWOJobsOverhauled.Log("Events.OnFitnessActionExeLooped not available; skipping fitness hook")
end

require "BWOJobsOverhauledJobs/CleaningJob"
require "BWOJobsOverhauledJobs/FireJob"
require "BWOJobsOverhauledJobs/MechanicJob"
require "BWOJobsOverhauledJobs/ParkRangerJob"
require "BWOJobsOverhauledJobs/FitnessJob"
require "BWOJobsOverhauledJobs/LumberjackJob"
require "BWOJobsOverhauledJobs/FishermanJob"
require "BWOJobsOverhauledJobs/PoliceJob"
require "BWOJobsOverhauledJobs/MedicalJob"
require "BWOJobsOverhauledJobs/SecurityJob"
require "BWOJobsOverhauledJobs/CookingJobs"
require "BWOJobsOverhauledJobs/ErrandsJob"
