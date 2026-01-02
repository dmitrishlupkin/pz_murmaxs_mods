if isServer() then return; end;

local clientID = getRandomUUID();
forageClient = {};
forageData = {};

function forageClient.init()
	forageData = ModData.getOrCreate("forageData");
end
Events.OnInitGlobalModData.Add(forageClient.init)

function forageClient.getZones() return forageData; end;

function forageClient.updateData()
	--sendClientCommand("forageData", "updateData", {}, clientID);
	forageData = ModData.getOrCreate("forageData");
end

function forageClient.clearData()
	ModData.remove("forageData");
end

function forageClient.syncForageData()
	--ModData.request("forageData"); end;
end

function forageClient.addZone(_zoneData)
	--sendClientCommand("forageData", "addZone", _zoneData, clientID);
	forageData[_zoneData.id] = _zoneData;
end

function forageClient.removeZone(_zoneData)
	--sendClientCommand("forageData", "removeZone", _zoneData, clientID);
	forageData[_zoneData.id] = nil;
end

function forageClient.updateZone(_zoneData)
	forageClient.addZone(_zoneData);
end

function forageClient.updateIcon(_zoneData, _iconID, _icon)
	triggerEvent("onUpdateIcon", _zoneData, _iconID, _icon);
	--sendClientCommand("forageData", "updateIcon", _zoneData, clientID);
	forageData[_zoneData.id].forageIcons[_iconID] = _icon;
end
