require "TimedActions/ISBaseTimedAction"
require "ISUI/ISLayoutManager"

ISExtendedPlacementAction = ISBaseTimedAction:derive("ISExtendedPlacementAction")

function ISExtendedPlacementAction:isValid()
	return self.item:isExistInTheWorld()
end

function ISExtendedPlacementAction:waitToStart()
	self.character:faceThisObject(self.item)
	return self.character:shouldBeTurning()
end

function ISExtendedPlacementAction:perform()
    local oldX,oldY = nil,nil
    local old = ISExtendedPlacementUI.GetWindowForPlayer(self.playerNum)
    if old then
        oldX,oldY = old:getX(),old:getY()
        old:close()
    end

	local ui = ISExtendedPlacementUI:new(oldX, oldY, self.playerNum, self.item)
	ui:initialise()
	ui:addToUIManager()

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISExtendedPlacementAction:new(character, item)
	local o = ISBaseTimedAction.new(self, character)
	o.maxTime = 1
	o.playerNum = character:getPlayerNum()
	o.item = item
	return o
end
