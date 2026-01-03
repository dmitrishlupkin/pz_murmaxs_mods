require("ISUI/ISInventoryPane")

BWOInventoryMarkers = BWOInventoryMarkers or {}

local function getContainerCustomName(object)
    if not object then return nil end
    local sprite = object:getSprite()
    if not sprite then return nil end
    local props = sprite:getProperties()
    if not props or not props:Is("CustomName") then return nil end
    return props:Val("CustomName")
end

BWOInventoryMarkers.GetItemPrefix = function(container, item)
    if not BWOScheduler or not BWOScheduler.Anarchy or not BWOScheduler.Anarchy.Transactions then
        return ""
    end

    if not container or not item then return "" end

    local object = container:getParent()
    if not object then return "" end

    local square = object:getSquare()
    if not square then return "" end

    local room = square:getRoom()
    if not room then return "" end

    local customName = getContainerCustomName(object)
    local canTake, shouldPay = BWORooms.TakeIntention(room, customName)

    if item:getType() == "Money" then
        canTake = false
        shouldPay = false
    end

    if shouldPay then
        return "$"
    end

    if not canTake then
        return "#"
    end

    return ""
end

local function wrapInventoryPaneMethod(methodName)
    local original = ISInventoryPane[methodName]
    if not original then
        return false
    end

    ISInventoryPane[methodName] = function(self, item, ...)
        local name = original(self, item, ...)
        if not name or name == "" then
            return name
        end

        local prefix = BWOInventoryMarkers.GetItemPrefix(self.inventory, item)
        if prefix == "" then
            return name
        end

        if string.sub(name, 1, 1) == prefix then
            return name
        end

        return prefix .. " " .. name
    end

    return true
end

local hooked = wrapInventoryPaneMethod("getItemName")
if not hooked then
    hooked = wrapInventoryPaneMethod("getItemText")
end
if not hooked then
    wrapInventoryPaneMethod("getItemDisplayName")
end
