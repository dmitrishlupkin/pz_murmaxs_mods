require "TimedActions/ISBaseTimedAction"

-- this intercepts all player actions and sends an event when they are performed

--[[ this one is already patched by Bandits mod
local actionPerform = ISBaseTimedAction.perform
function ISBaseTimedAction:perform()
    actionPerform(self)
    triggerEvent("OnTimedActionPerform", self)
end
]]

local actionStop = ISBaseTimedAction.stop
function ISBaseTimedAction:stop()
    actionStop(self)
    triggerEvent("OnTimedActionStop", self)
end