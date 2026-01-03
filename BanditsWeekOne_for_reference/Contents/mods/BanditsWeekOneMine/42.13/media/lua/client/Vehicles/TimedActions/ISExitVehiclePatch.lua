require('Vehicles/TimedActions/ISExitVehicle')

function ISExitVehicle:stop()
	self.character:clearVariable("bExitingVehicle")
	self.character:clearVariable("ExitAnimationFinished")
	local vehicle = self.character:getVehicle()
    if vehicle then 
        local seat = vehicle:getSeat(self.character)
        vehicle:playPassengerAnim(seat, "idle")
    end
	ISBaseTimedAction.stop(self)
end