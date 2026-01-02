require("ISUI/ISInventoryPane")

BWOInventoryMarkers = BWOInventoryMarkers or {}
BWOInventoryMarkers.DEBUG = true --BWOInventoryMarkers.DEBUG or false

local function bwoLog(msg)
    if not BWOInventoryMarkers.DEBUG then return end
    print("[BWOInventoryMarkers] " .. tostring(msg))
end

local function safeCall(fn, ...)
    local ok, a, b, c = pcall(fn, ...)
    if not ok then
        bwoLog("ERROR: " .. tostring(a))
        return nil
    end
    return a, b, c
end

local function getContainerCustomName(object)
        bwoLog("getContainerCustomName start " .. tostring(object))
    if not object then return nil end

        bwoLog("getContainerCustomName LOG1 " )
    local sprite = (object.getSprite and object:getSprite()) or nil
    if not sprite then return nil end

        bwoLog("getContainerCustomName LOG2 ")
    local props = (sprite.getProperties and sprite:getProperties()) or nil
    if not props then return nil end

        bwoLog("getContainerCustomName LOG3 ")
    local val = safeCall(function()
        if props.Val then
            return props:Val("CustomName")
        end
        return nil
    end)

        bwoLog("getContainerCustomName LOG4 ")
    if val and val ~= "" then
        bwoLog("getContainerCustomName LOG5 "..tostring(val))
        return val
    end

        bwoLog("getContainerCustomName LOG6 (nil)")
    return nil
end

BWOInventoryMarkers.GetItemMarker = function(container, item, player, totalWeight)
    -- Не убиваемся, если зависимости не готовы.
    bwoLog("BWOInventoryMarkers.GetItemMarker start " .. tostring(container) .. tostring(item))
    if not container or not item then return nil end
    if not BWORooms or not BWORooms.TakeIntention then return nil end
    if container.getType and (container:getType() == "inventorymale" or container:getType() == "inventoryfemale") then
        return nil
    end

    bwoLog("BWOInventoryMarkers.GetItemPrefix LOG1 ")
    local object = (container.getParent and container:getParent()) or nil
    if not object then return nil end

    bwoLog("BWOInventoryMarkers.GetItemPrefix LOG2 ")
    local square = (object.getSquare and object:getSquare()) or nil
    if not square then return nil end

    bwoLog("BWOInventoryMarkers.GetItemPrefix LOG3 ")
    local room = (square.getRoom and square:getRoom()) or nil
    if not room then
        -- Вне комнат (улица/часть зданий/особые контейнеры) пока просто не маркируем.
        return nil
    end

    bwoLog("BWOInventoryMarkers.GetItemPrefix LOG4 ")
    local customName = getContainerCustomName(object)

    bwoLog("BWOInventoryMarkers.GetItemPrefix LOG5 ")
    local canTake, shouldPay = safeCall(function()
        return BWORooms.TakeIntention(room, customName)
    end)

    -- Если функция вернула nil/nil — не гадим маркерами “по умолчанию”
    if canTake == nil and shouldPay == nil then
        return nil
    end

    bwoLog("BWOInventoryMarkers.GetItemPrefix LOG6 ")
    -- Деньги никогда не маркируем
    if item.getType and item:getType() == "Money" then
        canTake = false
        shouldPay = false
        return {text = "$", color = {r = 1, g = 1, b = 0, a = 1}}
    end

    if shouldPay then
		bwoLog("BWOInventoryMarkers.GetItemPrefix LOG7 ($) ")
        local weight = totalWeight
        if weight == nil then
            weight = item.getActualWeight and item:getActualWeight() or 0
        end
        local multiplier = SandboxVars and SandboxVars.BanditsWeekOne and SandboxVars.BanditsWeekOne.PriceMultiplier or 1
        local priceBase = weight * multiplier * 10
        local price = BanditUtils and BanditUtils.AddPriceInflation and BanditUtils.AddPriceInflation(priceBase) or math.floor(priceBase)
        if price == 0 then price = 1 end

        local moneyCount = 0
        if player and player.getInventory then
            local function predicateMoney(it)
                return it:getType() == "Money"
            end
            local inventory = player:getInventory()
            local items = ArrayList.new()
            inventory:getAllEvalRecurse(predicateMoney, items)
            moneyCount = items:size()
        end

        local canPay = moneyCount >= price
        local color = canPay and {r = 0, g = 1, b = 0, a = 1} or {r = 1, g = 0, b = 0, a = 1}
        return {text = "$" .. tostring(price), color = color}
    end

    if canTake == false then
		bwoLog("BWOInventoryMarkers.GetItemPrefix LOG7 (#) ")
        return {text = "#", color = {r = 1, g = 0, b = 0, a = 1}}
    end
    bwoLog("BWOInventoryMarkers.GetItemPrefix LOG8 (nothing) ")

    return nil
end

local function drawItemPrefixInDetails(pane)
    if not pane.items or not pane.inventory then return end

    local font = pane.font or UIFont.Small
    local textManager = getTextManager()
    local fh = textManager:getFontHeight(font)
    local textDY = (pane.itemHgt - fh) / 2
    local yScroll = pane.getYScroll and pane:getYScroll() or 0
    local height = pane.getHeight and pane:getHeight() or 0
    local player = getSpecificPlayer(pane.player)
    local padding = 6

    for index, entry in ipairs(pane.items) do
        local item = entry
        local totalWeight = nil
        if entry.items then
            item = entry.items[1]
            if entry.weight then
                totalWeight = entry.weight
            elseif entry.count and entry.count > 1 then
                local perItemWeight = item.getActualWeight and item:getActualWeight() or 0
                totalWeight = perItemWeight * math.max(1, entry.count - 1)
            end
        end
        if item then
            local topOfItem = (index - 1) * pane.itemHgt + yScroll
            if not ((topOfItem + pane.itemHgt < 0) or (topOfItem > height)) then
                local marker = BWOInventoryMarkers.GetItemMarker(pane.inventory, item, player, totalWeight)
                if marker and marker.text and marker.color then
                    local y = ((index - 1) * pane.itemHgt) + pane.headerHgt + textDY
                    local textWidth = textManager:MeasureStringX(font, marker.text)
                    local x = pane.column4 - textWidth - padding
                    pane:drawText(marker.text, x, y, marker.color.r, marker.color.g, marker.color.b, marker.color.a, font)
                end
            end
        end
    end
end

local function hookInventoryPaneRenderDetails()
    if not ISInventoryPane or not ISInventoryPane.renderdetails then return end
    if ISInventoryPane.__bwoHookedRenderDetails then return end

    ISInventoryPane.__bwoHookedRenderDetails = true
    local origRenderDetails = ISInventoryPane.renderdetails
    ISInventoryPane.renderdetails = function(self, doDragged)
        local result = origRenderDetails(self, doDragged)
        if doDragged == false then
            drawItemPrefixInDetails(self)
        end
        return result
    end

    bwoLog("hooked ISInventoryPane.renderdetails")
end

hookInventoryPaneRenderDetails()

bwoLog("BWOInventoryMarkers loaded OK")