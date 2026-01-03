require "TimedActions/ISFitnessAction"

local perform = ISFitnessAction.exeLooped

function ISFitnessAction:exeLooped()
	perform(self)
    triggerEvent("OnFitnessActionExeLooped", self)
end

