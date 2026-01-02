require "TimedActions/ISInventoryTransferAction"

local perform = ISInventoryTransferAction.perform

function ISInventoryTransferAction:perform()
    perform(self)
    triggerEvent("OnInventoryTransferActionPerform", self)
end

