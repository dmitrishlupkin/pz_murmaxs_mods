require("ISUI/ISInventoryPane")

BWOItemTags = BWOItemTags or {}
BWOItemTags.DEBUG = true --BWOItemTags.DEBUG or false

local function bwoLog(msg)
    if not BWOItemTags.DEBUG then return end
    print("[BWOItemTags] " .. tostring(msg))
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
    if not object then return nil end

    local sprite = (object.getSprite and object:getSprite()) or nil
    if not sprite then return nil end

    local props = (sprite.getProperties and sprite:getProperties()) or nil
    if not props then return nil end

    local val = safeCall(function()
        if props.Val then
            return props:Val("CustomName")
        end
        return nil
    end)

    if val and val ~= "" then
        return val
    end

    return nil
end

local function isPlayerOwnedContainer(container, player)
    if not container then return false end

    if player and player.getInventory and container == player:getInventory() then
        return true
    end

    local parent = (container.getParent and container:getParent()) or nil
    if parent and instanceof(parent, "IsoPlayer") then
        return true
    end

    local containingItem = (container.getContainingItem and container:getContainingItem()) or nil
    if containingItem then
        local ownerContainer = (containingItem.getContainer and containingItem:getContainer()) or nil
        if ownerContainer then
            if player and player.getInventory and ownerContainer == player:getInventory() then
                return true
            end
            local ownerParent = (ownerContainer.getParent and ownerContainer:getParent()) or nil
            if ownerParent and instanceof(ownerParent, "IsoPlayer") then
                return true
            end
        end
    end

    return false
end

BWOItemTags.GetItemMarker = function(container, item, player, totalWeight)
    if not container or not item then return nil end
    if not BWORooms or not BWORooms.TakeIntention then return nil end
    if container.getType and (container:getType() == "inventorymale" or container:getType() == "inventoryfemale") then
        return nil
    end
    if isPlayerOwnedContainer(container, player) then
        return nil
    end

    local object = (container.getParent and container:getParent()) or nil
    if not object then return nil end

    local square = (object.getSquare and object:getSquare()) or nil
    if not square then return nil end

    local room = (square.getRoom and square:getRoom()) or nil
    if not room then
        return nil
    end

    local customName = getContainerCustomName(object)

    local canTake, shouldPay = safeCall(function()
        return BWORooms.TakeIntention(room, customName)
    end)

    if canTake == nil and shouldPay == nil then
        return nil
    end

    --if item.getType and item:getType() == "Money" then
    --    canTake = false
    --    shouldPay = false
    --end

    if shouldPay then
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
        return {text = "#", color = {r = 1, g = 0, b = 0, a = 1}}
    end

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
                local marker = BWOItemTags.GetItemMarker(pane.inventory, item, player, totalWeight)
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

bwoLog("BWOItemTags loaded OK")