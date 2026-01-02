TrapBO = ISBuildingObject:derive("TrapBO");

function TrapBO:create(x, y, z, north, sprite)
    if not self.character:getInventory():contains(self.trap) then
        return false
    end
    local cell = getWorld():getCell();
    self.sq = cell:getGridSquare(x, y, z);
    self.javaObject = IsoThumpable.new(cell, self.sq, sprite, north, self);
    buildUtil.setInfo(self.javaObject, self);
    --    self.player:getInventory():RemoveOneOf(self.trap:getType());
    self.javaObject:setMaxHealth(50);
    self.javaObject:setHealth(self.javaObject:getMaxHealth());

    if sprite == "constructedobjects_01_16" or sprite == "constructedobjects_01_18" then
        --snare traps
        self.javaObject:setCanPassThrough(true)
        self.javaObject:setBlockAllTheSquare(false)
        self.javaObject:setIsThumpable(false)
    else
        --all other traps
        self.javaObject:setBlockAllTheSquare(true)
        self.javaObject:setIsThumpable(true)
    end

    self.sq:AddSpecialObject(self.javaObject);
    self.sq:RecalcAllWithNeighbours(true);
--    buildUtil.addWoodXp();
--    print("created trap : " .. trap.x .. "," .. trap.y);
--    table.insert(TrapSystem.traps, trap);
    TrapSystem.initObjectModData(self.javaObject, self.trapDef, north, self.character)
    self.javaObject:transmitCompleteItemToClients();

    if self.trap == self.character:getPrimaryHandItem() then
        self.character:setPrimaryHandItem(nil)
    end
    if self.trap == self.character:getSecondaryHandItem() then
        self.character:setSecondaryHandItem(nil)
    end
    self.character:getInventory():Remove(self.trap);

    if not isServer() then
        getCell():setDrag(nil, self.player);
    else
        sendRemoveItemFromContainer(self.character:getInventory(), self.trap);
    end
    -- OnObjectAdded event will create the STrapGlobalObject on the server.
    -- This is only needed for singleplayer which doesn't trigger OnObjectAdded.
    triggerEvent("OnObjectAdded", self.javaObject)
    --[[
    if isClient() then
        sendClientCommand(self.character, 'trapping', 'add', { x = x, y = y, z = z })
    else
        TrapSystem.instance:loadIsoObject(self.javaObject)
    end
    --]]
end

function TrapBO:onTimedActionStart(action)
    getCell():setDrag(nil, self.player)
    if not self.character:getInventory():contains(self.trap) then
        ISTimedActionQueue.getTimedActionQueue(self.character):resetQueue();
        return false
    end
    ISBuildingObject.onTimedActionStart(self, action)
    action.character:SetVariable("LootPosition", "Low")
    action:setOverrideHandModels(nil, nil)
end

function TrapBO:new(player, trap)
    if not trap then
        return nil;
    end
    if not player:getInventory():contains(trap) then
        return nil
    end
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o:init();
    -- get the correct trap definition
    for i,v in ipairs(Traps) do
        if v.type == trap:getModule() .. "." .. trap:getType() then
            o.trapDef = v;
            break;
        end
    end
    if not o.trapDef then
        return nil;
    end
    o:setSprite(o.trapDef.sprite);
    if o.trapDef.northSprite then
        o:setNorthSprite(o.trapDef.northSprite);
    else
        o:setNorthSprite(o.trapDef.sprite);
    end
    o.name = "Trap";
    o.character = player;
    o.player = player:getPlayerNum()
    o.trap = trap;
    o.blockAllTheSquare = true;
    o.noNeedHammer = true;
    o.thumpDmg = 1;
    o.actionAnim = "Loot";
    return o;
end

function TrapBO:isValid(square, north)
    if square:getMovingObjects():size() > 0 then return false end
    if not self.character:getInventory():contains(self.trap) then return false end
    if CTrapSystem.instance:getLuaObjectAt(square:getX(), square:getY(), square:getZ()) then return false end
    if square:has(IsoObjectType.tree) then return false end
    if CTrapGlobalObject.checkForWallExploit(nil, square) then
        return false;
    end
    return not square:has(IsoFlagType.solid) and not square:has(IsoFlagType.solidtrans) and square:has(IsoFlagType.solidfloor)
end

function TrapBO:getAPrompt()
    if self.canBeBuild then
        return getText("ContextMenu_Place_Trap")
    end
end

function TrapBO:render(x, y, z, square)
    ISBuildingObject.render(self, x, y, z, square);
end
