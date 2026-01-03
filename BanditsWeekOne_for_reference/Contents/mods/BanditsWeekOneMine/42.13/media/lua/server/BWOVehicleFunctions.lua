require "Vehicles/Vehicles"


--------------------------
--------TRACKS------------
--------------------------

function Vehicles.Create.TRACK(vehicle, part)
	local item = VehicleUtils.createPartInventoryItem(part)
end

function Vehicles.Init.TRACK(vehicle, part)
	local parts = {"Track_2", "Tire"}
	for _, partId in ipairs(parts) do
		local part = vehicle:getPartById(partId)
		part:setModelVisible("Default", true) vehicle:doDamageOverlay()
		vehicle:playPartAnim(part, "Static")
	end
	Vehicles.Update.TRACK(vehicle, part)
end

function Vehicles.Update.TRACK(vehicle, part)

    local trackLeft = vehicle:getPartById("Track_1")
    local trackRight = vehicle:getPartById("Track_2")
    
    
    if trackLeft and trackRight then
		if math.abs(vehicle:getCurrentSpeedKmHour()) > 20 then
			
			if part:getCondition() > 0 then
				local chance = 1  
				local conditionReduction = ZombRandFloat(0, 100) < chance
				if conditionReduction then					
					local newCondition = part:getCondition() - 2
					part:setCondition(math.max(newCondition, 0))
				end
			end
		end
    end
end


function Vehicles.Use.TRACK(vehicle, part, character)

end

------------------------
------TANK-TIRE---------
------------------------

function Vehicles.Update.TANKTIRE(vehicle, elapsedMinutes)
    for _, partName in ipairs({
        "TireFrontLeft", 
        "TireFrontRight", 
        "TireRearLeft", 
        "TireRearRight"
    }) do
        local vehiclePart = vehicle:getPartById(partName)
        if vehiclePart then
            
            if not vehiclePart:getInventoryItem() then
                local item = VehicleUtils.createPartInventoryItem(vehiclePart) 
                if item then
                    vehiclePart:setInventoryItem(item)
                else
                    
                end
            end
            
            
            if vehiclePart:getCondition() < 100 then
                vehiclePart:setCondition(100)
            end            
            
            if vehiclePart:getContainerContentAmount() and vehiclePart:getContainerContentAmount() < 30 then
                vehiclePart:setContainerContentAmount(30)
            end
        end
    end
end



------------------------
------TORRENTA----------
------------------------

function Vehicles.Create.TORRENTA(vehicle, part)
	local item = VehicleUtils.createPartInventoryItem(part)
	vehicle:getPartById("Turrent"):setModelVisible("Default", true)
	vehicle:playPartAnim(vehicle:getPartById("Turrent") , "360")
	Vehicles.Init.TORRENTA(vehicle, part)
end
function Vehicles.Init.TORRENTA(vehicle, part)
	vehicle:getPartById("Turrent"):setModelVisible("Default", true)
	vehicle:playPartAnim(vehicle:getPartById("Turrent") , "360")
end
function Vehicles.Update.TORRENTA(vehicle, part)

end

--------------------------
------MACHINEGUN----------
--------------------------

function Vehicles.Create.MACHINEGUN(vehicle, part)
    --[[
    local item = VehicleUtils.createPartInventoryItem(part)
    part:setModelVisible("Default", true) 
    vehicle:doDamageOverlay()
    vehicle:playPartAnim(vehicle:getPartById("Browning_M2"), "Static")]]
end


function Vehicles.Init.MACHINEGUN(vehicle, part)    
    if part and part:getInventoryItem() then
        part:setModelVisible("Default", true)
        vehicle:doDamageOverlay()
        local mgPart = vehicle:getPartById("Browning_M2")
        if mgPart then
            vehicle:playPartAnim(mgPart, "Static")
        end
    else
        if part then
            part:setModelVisible("Default", false)
        end
    end
    
    Vehicles.Update.MACHINEGUN(vehicle, part)    
end


function Vehicles.Update.MACHINEGUN(vehicle, part)
-- need to remake it---
-----------------------
-----------------------
--[[]]
    if not part then return end
    part:setModelVisible("Default", true)
    vehicle:doDamageOverlay()
--    vehicle:playPartAnim(part, "Shooting")

    local browningPart = vehicle:getPartById("Browning_M2")
    local ammoBoxPart = vehicle:getPartById("MachinegunAmmoBox")
    local ammoPart = vehicle:getPartById("MachinegunAmmo")
--	print("____Update.MACHINEGUN____")

	part:setModelVisible("Default", true)
	vehicle:playPartAnim(browningPart, "Static")

	
    if browningPart and browningPart:getItemContainer() then
        if not browningPart:getItemContainer():FindAndReturn("Base.127x99mmClip") then
            if ammoBoxPart then
                ammoBoxPart:setModelVisible("Default", false)
            end
            if ammoPart then
                ammoPart:setModelVisible("Default", false)
            end
        end
    end
end

function Vehicles.UninstallTest.MACHINEGUN(vehicle, part, chr)
    local canDo = Vehicles.UninstallTest.Default(vehicle, part, chr)
    if not canDo then
        return false
    end

    local container = part:getItemContainer()
    if container == nil then
        return false 
    end

    if not container:isEmpty() then
        chr:Say("THE WEAPON IS LOAD YOOO")
		return false 
    end

    return true 
end

--------------------------
---------ANTENNA----------
--------------------------

function Vehicles.Create.ANTENNA(vehicle, part)
	local item = VehicleUtils.createPartInventoryItem(part)
end
function Vehicles.Init.ANTENNA(vehicle, part)	
	part:setModelVisible("Default", true) vehicle:doDamageOverlay()
	vehicle:playPartAnim(part, "Static")
	Vehicles.Update.ANTENNA(vehicle, part)
end
function Vehicles.Update.ANTENNA(vehicle, part)

end


--------------------------
-------AMMO-STOR----------
--------------------------


function Vehicles.ContainerAccess.AMMOSTOR(vehicle, part, chr)
	if not part:getInventoryItem() then return false; end
	if chr:getVehicle() == vehicle then
		local seat = vehicle:getSeat(chr)
		return seat == 1
	else
		return false
	end
end

--------------------------
-------DOOR-M113----------
--------------------------

function Vehicles.Use.DoorSEAT(vehicle, part, character)	
    local trunkDoor = vehicle:getPartById("TrunkDoor")
    local rearLeftDoor = vehicle:getPartById("DoorRearLeft")
    
    if trunkDoor then      
       
        if trunkDoor:getDoor():isOpen() then			
            if rearLeftDoor then
                rearLeftDoor:getDoor():setLocked(false) 
            end
        end
    elseif not trunkDoor then 
        if rearLeftDoor then
            rearLeftDoor:getDoor():setLocked(false)
        end
    end
	
	for seat=0,vehicle:getMaxPassengers()-1 do
		if vehicle:getPassengerDoor(seat) == part then
			ISVehicleMenu.onEnter(character, vehicle, seat)
			break
		end
		if vehicle:getPassengerDoor2(seat) == part then
			ISVehicleMenu.onEnter2(character, vehicle, seat)
			break
		end
	end
end

--------------------------
-------EXTRA-PART---------
--------------------------

function Vehicles.Init.EXTRA(vehicle, part)	
	part:setModelVisible("Default", true) vehicle:doDamageOverlay()
end