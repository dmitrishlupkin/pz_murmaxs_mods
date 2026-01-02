ISTrapMenu = {};
local isBait = function(itemType)
    for _, data in ipairs(TrapAnimals) do
        if data.baits and data.baits[itemType] then return true end
    end
    return false
end

local baitPredicate = function(item)
    return instanceof(item, "Food") and
            (item:getHungerChange() <= -0.05 or isBait(item:getFullType())) and
            not item:isCooked() and
            not item:haveExtraItems() and
            (item:getCustomMenuOption() ~= "Drink")
end


ISTrapMenu.doTrapMenu = function(player, context, worldobjects, test)
    local placedTrap = nil;
    local playerInv = getSpecificPlayer(player):getInventory();
    for i,v in ipairs(worldobjects) do
        placedTrap = CTrapSystem.instance:getLuaObjectAt(v:getX(), v:getY(), v:getZ());
        if placedTrap then break end
    end

    -- interact with the trap
    if placedTrap then
        local trapItem = instanceItem(placedTrap.trapType);
        local trapIcon = getTexture("Item_TrapBox");
        local trapName = getText("ContextMenu_Trap");
        if trapItem then
            trapIcon = trapItem:getTex();
            trapName = trapItem:getDisplayName();
        end
        local trapOption = context:addOption(trapName, worldobjects, nil);
        trapOption.iconTexture = trapIcon;
        local trapSubmenu = ISContextMenu:getNew(context);
        context:addSubMenu(trapOption, trapSubmenu);
        -- add bait
        if not placedTrap.bait and not placedTrap.animal.type and playerInv:contains("Type:Food") then
            local isBait = function(itemType)
                for _, data in ipairs(TrapAnimals) do
                    if data.baits and data.baits[itemType] then return true end
                end
                return false
            end

            local validItems = playerInv:getAllEval(baitPredicate)
            local alreadyAddedItems = {};
            local items = {}
            for i = 0, validItems:size() - 1 do
                local vItem = validItems:get(i);
                if not alreadyAddedItems[vItem:getName()]then
                    table.insert(items, vItem)
                    alreadyAddedItems[vItem:getName()] = true;
                end
            end
            if #items > 0 then
                if test then return ISWorldObjectContextMenu.setTest() end
                local baitOption = trapSubmenu:addOption(getText("ContextMenu_Add_Bait"), worldobjects, nil);
                local subMenuBait = trapSubmenu:getNew(trapSubmenu);
                trapSubmenu:addSubMenu(baitOption, subMenuBait);
                for _,vItem in ipairs(items) do
                    subMenuBait:addOption(vItem:getName(), worldobjects, ISTrapMenu.onAddBait, vItem, placedTrap, getSpecificPlayer(player));
                end
            end
        elseif placedTrap.bait then
            if test then return ISWorldObjectContextMenu.setTest() end
            trapSubmenu:addOption(getText("ContextMenu_Discard_Bait"), worldobjects, ISTrapMenu.onRemoveBait, placedTrap, getSpecificPlayer(player));
        end
        if placedTrap.animal.type then
            if test then return ISWorldObjectContextMenu.setTest() end
            trapSubmenu:addOption(getText("ContextMenu_Check_Trap"), worldobjects, ISTrapMenu.onCheckTrap, placedTrap, getSpecificPlayer(player));
        end
        if not placedTrap.animal.type then
            if test then return ISWorldObjectContextMenu.setTest() end
            trapSubmenu:addOption(getText("ContextMenu_Remove_Trap"), worldobjects, ISTrapMenu.onRemoveTrap, placedTrap, getSpecificPlayer(player));
        end
        if placedTrap and not placedTrap.animal.type and getDebug() then
            local addOption = trapSubmenu:addDebugOption("Add Animal");
            local subMenuAdd = ISContextMenu:getNew(trapSubmenu);
            trapSubmenu:addSubMenu(addOption, subMenuAdd);
            for i,v in ipairs(TrapAnimals) do
                if v.traps[placedTrap.trapType] then
                    subMenuAdd:addOption(v.type, placedTrap, ISTrapMenu.addAnimalDebug, getSpecificPlayer(player), v);
                end
            end
        end
    end
end

ISTrapMenu.onRemoveBait = function(worldobjects, trap, player)
    if luautils.walkAdj(player, trap:getSquare()) then
        ISTimedActionQueue.add(ISRemoveBaitAction:new(player, trap));
    end
end

ISTrapMenu.onAddBait = function(worldobjects, bait, trap, player)
    if luautils.walkAdj(player, trap:getSquare()) then
        ISTimedActionQueue.add(ISAddBaitAction:new(player, bait, trap));
    end
end

ISTrapMenu.onCheckTrap = function(worldobjects, trap, player)
    if luautils.walkAdj(player, trap:getSquare()) then
        if isClient() then
            local args = { x = trap:getSquare():getX(), y = trap:getSquare():getY(), z = trap:getSquare():getZ() };
            CTrapSystem.instance:sendCommand(player, 'checkTrap', args)
        else
            forceDropHeavyItems(player)
        end
        if not isServer() then
            ISTimedActionQueue.add(ISCheckTrapAction:new(player, trap));
        end
    end
end

ISTrapMenu.addAnimalDebug = function(trap, player, animal)
    local args = { x = trap:getSquare():getX(), y = trap:getSquare():getY(), z = trap:getSquare():getZ(), animal = animal };
    CTrapSystem.instance:sendCommand(player, 'addAnimalDebug', args)
end

ISTrapMenu.onRemoveTrap = function(worldobjects, trap, player)
    if luautils.walkAdj(player, trap:getSquare()) then
        ISTimedActionQueue.add(ISRemoveTrapAction:new(player, trap));
    end
end

ISTrapMenu.onPlaceTrap = function(worldobjects, trap, player)
    getCell():setDrag(TrapBO:new(player, trap), player:getPlayerNum());
end
