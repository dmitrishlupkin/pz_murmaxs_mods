-- fix me, this is handled by server side now
--[[

function Recipe.OnCreate.ScratchTicket(craftRecipeData, character)
	local result = craftRecipeData:getAllCreatedItems():get(0);
    local mData = result:getModData();
    mData.Scratched = true
    local loser = getText("IGUI_Loser")
    local winner = getText("IGUI_Winner")
    local name = getText(result:getDisplayName())
    if ZombRand(5) == 0 then
        local rollMax = #Recipe.ScratchTicketWinnings
        local roll = ZombRand(rollMax)
        local roll2 = ZombRand(rollMax)
        if roll2 < roll then roll = roll2 end
        local roll2 = ZombRand(rollMax)
        if roll2 < roll then roll = roll2 end
        local roll2 = ZombRand(rollMax)
        if roll2 < roll then roll = roll2 end
        local roll2 = ZombRand(rollMax)
        if roll2 < roll then roll = roll2 end
        local roll2 = ZombRand(rollMax)
        if roll2 < roll then roll = roll2 end
        roll = roll + 1
        local sum = Recipe.ScratchTicketWinnings[roll]
        -- HaloTextHelper.addGoodText(character, sum)
        result:setName(name .. " - " .. winner .. " " .. sum)
        result:setTexture(getTexture("Item_ScratchTicket_Winner"))
        result:setWorldStaticModel("ScratchTicket_Winner")
        if BWOScheduler.Anarchy.Transactions then
            BWOPlayer.Earn(character, tonumber(sum:match("[%d%.]+")))
        end
    else
        result:setName(name .. " - " .. loser)
        result:setTexture(getTexture("Item_ScratchTicket_Loser"))
        result:setWorldStaticModel("ScratchTicket_Loser")
    end
end ]]