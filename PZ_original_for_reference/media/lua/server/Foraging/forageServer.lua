if not isServer() then return; end;

forageServer = {};

forageData = ModData.getOrCreate("forageData");

function forageServer.updateData()
    forageData = ModData.getOrCreate("forageData");
end

function forageServer.clearData()
    ModData.remove("forageData");
end

function forageServer.addZone(_zoneData)
    forageData[_zoneData.id] = _zoneData;
end

function forageServer.removeZone(_zoneData)
    forageData[_zoneData.id] = nil;
end

function forageServer.updateZone(_zoneData)
    forageServer.addZone(_zoneData);
end

function forageServer.syncForageData()
    ModData.transmit("forageData");
end

function forageServer.updateIcon(_zoneData, _iconID, _icon)
    forageData[_zoneData.id].forageIcons[_iconID] = _icon;
end

forageServer.OnClientCommand = function(_module, _command, _plObj, _packet, _clientID)
    if _module ~= "forageData" then return; end;
    if (not forageServer[_command]) or (not _packet) then
        print("aborted function call in forageServer "
                .. (_command or "missing _command.")
                .. (_packet or "missing _packet."));
    else
        sendServerCommand(_module, _command, _packet, _clientID);
        forageServer[_command](_packet, _clientID);
    end;
end

Events.OnClientCommand.Add(forageServer.OnClientCommand);
