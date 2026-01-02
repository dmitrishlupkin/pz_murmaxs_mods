require "TimedActions/ISBaseTimedAction"

ISRemoveWeaponUpgrade = ISBaseTimedAction:derive("ISRemoveWeaponUpgrade");

local function predicateNotBroken(item)
    return not item:isBroken()
end

function ISRemoveWeaponUpgrade:isValid()
    if not self.weapon then return false end
    --if not self.character:getInventory():containsTagEval("Screwdriver", predicateNotBroken) then return false end
    if isClient() and self.weapon then
        -- The weapon part goes nil at the end of the action.
        return self.character:getInventory():containsID(self.weapon:getID())
    end
    if not self.character:getInventory():contains(self.weapon) then return false end
    local part = self.weapon:getWeaponPart(self.partType)
    return part ~= nil and part:canDetach(self.character, self.weapon)
end

function ISRemoveWeaponUpgrade:update()
    self.character:setMetabolicTarget(Metabolics.LightDomestic);
end

function ISRemoveWeaponUpgrade:start()

end

function ISRemoveWeaponUpgrade:stop()
    ISBaseTimedAction.stop(self);
end

function ISRemoveWeaponUpgrade:perform()
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function ISRemoveWeaponUpgrade:complete()
    local part = self.weapon:getWeaponPart(self.partType)
    self.weapon:detachWeaponPart(self.character, part)
    syncHandWeaponFields(self.character, self.weapon)
    self.character:getInventory():AddItem(part);
    sendAddItemToContainer(self.character:getInventory(), part);
    return true
end

function ISRemoveWeaponUpgrade:getDuration()
    if self.character:isTimedActionInstant() then
        return 1;
    end
    return 50
end

function ISRemoveWeaponUpgrade:new(character, weapon, partType)
    local o = ISBaseTimedAction.new(self, character)
    o.weapon = weapon;
    o.partType = partType;
    o.maxTime = o:getDuration();
    return o;
end
