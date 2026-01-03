require "TimedActions/ISBaseTimedAction"

TAHeal = ISBaseTimedAction:derive("TAHeal");

function TAHeal:isValid()
	return true
end

function TAHeal:update()
end

function TAHeal:start()
    self.character:faceThisObject(self.bandit)
	self:setActionAnim("Loot")

    if not self.bandit:isCrawling() then
        Bandit.ClearTasks(self.bandit)
        local task = {action="TimeEvent", anim="Yes", x=self.character:getX(), y=self.character:getY(), time=200}
        Bandit.AddTask(self.bandit, task)
    end
end

function TAHeal:stop()
	ISBaseTimedAction.stop(self)
end

function TAHeal:perform()
    self.bandit:setHealth(2)
    self.bandit:setCrawler(false)

    BWOPlayer.Earn(self.character, 50)
	ISBaseTimedAction.perform(self)
end


function TAHeal:new(character, square, bandit)
	local o = {}
	setmetatable(o, self)
	self.__index = self

    o.character = character
    o.stopOnWalk = false
    o.stopOnRun = false
    o.maxTime = 260
	o.bandit = bandit
    o.square = square
	return o
end

return TAHeal;
