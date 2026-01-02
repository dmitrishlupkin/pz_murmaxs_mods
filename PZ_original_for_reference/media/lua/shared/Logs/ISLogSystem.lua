local function inBrackets(_string) return "["..tostring(_string).."]"; end;

local function findCharacter(_action)
    if _action.character then return _action.character; end;
    if _action.player and instanceof(_action.player, "IsoPlayer") then return _action.player; end;
    if _action.player and type(_action.player) == "number" then return getSpecificPlayer(_action.player); end;
    return getSpecificPlayer(0);
end;

ISLogSystem = {};

function ISLogSystem.getGenericLogText(_character, _actionType)
    local logText = "";
    --
    if ISLogSystem.steamID then
        logText = logText .. inBrackets(ISLogSystem.steamID);
    end;
    --
    if _actionType then
        logText = logText .. inBrackets(_actionType);
    end;
    --
    if _character then
        logText = logText .. inBrackets(_character:getUsername());
        logText = logText .. inBrackets(ISLogSystem.getObjectPosition(_character));
    end;
    --
    return logText;
end

function ISLogSystem.getObjectPosition(_object)
    if instanceof(_object, "IsoObject") then
        return math.floor(_object:getX()) ..","..math.floor(_object:getY())..","..math.floor(_object:getZ());
    else
        return "invalid object";
    end;
end

function ISLogSystem.logAction(_action)
    if isClient() then
        local actionType = _action.Type;
        if (not actionType) then return; end;
        --
        local logActions = getServerOptions():getOption("ClientActionLogs");
        if string.match(logActions, actionType) then
            --
            local character = findCharacter(_action);
            if (not character) then return; end;
            --
            local actionLog = {};
            if ISLogSystem.steamID then table.insert(actionLog, ISLogSystem.steamID); end;
            table.insert(actionLog, actionType);
            table.insert(actionLog, character:getUsername());
            table.insert(actionLog, ISLogSystem.getObjectPosition(character));
            --
            if _action.getExtraLogData then
                local extraLogData = _action:getExtraLogData();
                if type(extraLogData) == "table" then
                    for _, value in ipairs(extraLogData) do
                        table.insert(actionLog, value);
                    end;
                end;
            end;
            --
            local logText = "";
            for _, text in ipairs(actionLog) do
                logText = logText .. inBrackets(text);
            end;
            --
            ISLogSystem.sendLog(character, "ClientActionLog", logText);
        end;
    end;
end

function ISLogSystem.writeLog(_character, _packet)
    writeLog(_packet.loggerName, _packet.logText);
end

function ISLogSystem.sendLog(_character, _loggerName, _logText)
    if isClient() and _loggerName and _logText then
        sendClientCommand(_character, 'ISLogSystem', 'writeLog', {loggerName = _loggerName, logText = _logText});
    end;
end

function ISLogSystem.OnClientCommand(_module, _command, _plObj, _packet)
    if _module ~= "ISLogSystem" then return; end;
    if (not ISLogSystem[_command]) then
        print("aborted function call in ISLogSystem " .. (_command or "missing _command."));
    else
        ISLogSystem[_command](_plObj, _packet);
    end;
end

if isServer() then Events.OnClientCommand.Add(ISLogSystem.OnClientCommand); end;

function ISLogSystem.init()
    ISLogSystem.steamID = getCurrentUserSteamID();
end

if isClient() then ISLogSystem.init(); end;
