BWOEffects2 = BWOEffects2 or {}

BWOEffects2.tab = {}
BWOEffects2.tick = 0

BWOEffects2.immuneList = {
    "cfccfa27-f256-47a0-bd7c-b2d12b369c6d", -- medic with hazmats
    "9bf4882b-0622-4e77-82c1-feee90b566b4", -- sweepers with hazmats
    "ce526bd8-a230-4d21-a1f8-5e30790b366f", -- army with gas masks
    "989f4faf-53f2-4f8f-9603-496fb3efcb6a", -- firemen
    "ba5733bd-938d-4320-b2f8-3e9c5832200e", -- late survivors
    "bafa6e46-bf40-4f46-a133-fae309e0dccc", -- sweepers military
}

BWOEffects2.Add = function(effect)
    table.insert(BWOEffects2.tab, effect)
end

BWOEffects2.Process = function()
    if not isIngameState() then return end
    if isServer() then return end

    local player = getSpecificPlayer(0)
    if player == nil then return end
    local playerNum = player:getPlayerNum()
    local zoom = getCore():getZoom(playerNum)
    local immuneList = BWOEffects2.immuneList

    local cell = getCell()
    for i = #BWOEffects2.tab, 1, -1 do
        local effect = BWOEffects2.tab[i]

        local square = cell:getGridSquare(effect.x, effect.y, effect.z)
        if square then

            if effect.repCnt == nil then effect.repCnt = 1 end
            if effect.rep == nil then effect.rep = 1 end
            if effect.offsetx == nil then effect.offsetx = 0 end
            if effect.offsety == nil then effect.offsety = 0 end

            if effect.movx then
                effect.offsetx = effect.offsetx + effect.movx
            end
            if effect.movy then
                effect.offsety = effect.offsety + effect.movy
            end
            
            local size = effect.size / zoom
            local offset = size / 2
            local tx = isoToScreenX(playerNum, effect.x + effect.offsetx, effect.y + effect.offsety, effect.z) - offset
            local ty = isoToScreenY(playerNum, effect.x + effect.offsetx, effect.y + effect.offsety, effect.z) - offset

            if not effect.frame then 
                if effect.frameRnd then
                    effect.frame = 1 + ZombRand(effect.frameCnt)
                else
                    effect.frame = 1
                end
            end

            if effect.frame > effect.frameCnt and effect.rep >= effect.repCnt then
                if effect.infinite then
                    effect.rep = 1
                    effect.offsetx = 0
                    effect.offsety = 0 
                else 
                    table.remove(BWOEffects2.tab, i)
                    return
                end
            end

            if effect.frame > effect.frameCnt then
                effect.rep = effect.rep + 1
                effect.frame = 1
            end

            local alpha 

            if effect.alpha then
                alpha = effect.alpha
            elseif effect.oscilateAlpha then
                local frameCnt = effect.frameCnt or 1
                local repCnt = effect.repCnt or 1
                local totalFrames = frameCnt * repCnt
                if totalFrames <= 0 then
                    alpha = 0
                else
                    -- number of full cycles across the total lifetime (default 1)
                    local cycles = effect.oscCycles or 1
            
                    -- progress in [0,1). Use (effect.frame - 1) so first frame => progress == 0
                    local currentFrame = ( (effect.rep - 1) * frameCnt ) + (effect.frame - 1)
                    local progress = currentFrame / totalFrames
                    -- clamp just in case
                    if progress < 0 then progress = 0 end
                    if progress > 1 then progress = 1 end
            
                    -- cosine-based oscillation that starts at 0, peaks at 1 at halfway, returns to 0 at end
                    alpha = (1 - math.cos(progress * 2 * math.pi * cycles)) / 2
                end
            else
                alpha = (1 + effect.repCnt - effect.rep) / effect.repCnt
            end

            local frameStr = string.format("%03d", effect.frame)
            local tex = getTexture("media/textures/FX/" .. effect.name .. "/" .. frameStr .. ".png")
            if tex then
                UIManager.DrawTexture(tex, tx, ty, size, size, alpha)
            end

            effect.frame = effect.frame + 1

            if effect.poison then
                -- effect.object:setCustomColor(0.1,0.7,0.2, alpha)
                if effect.frame % 10 == 1 then
                    local actors = BanditZombie.GetAll()
                    for _, actor in pairs(actors) do
                        local dx, dy = actor.x - effect.x, actor.y - effect.y
                        local distSq = dx * dx + dy * dy
                        if distSq < 9 then  -- 3^2
                            local character = BanditZombie.GetInstanceById(actor.id)
                            local immune = false
                            local brain = BanditBrain.Get(character)
                            if brain and brain.cid then
                                for _, cid in pairs(immuneList) do
                                    if brain.cid == cid then
                                        immune = true
                                        break
                                    end
                                end
                            end
                            if not immune then
                                character:setHealth(character:getHealth() - 0.12)

                                local sound
                                if character:isFemale() then
                                    sound = "ZSCoughF" .. (1 + ZombRand(4))
                                else
                                    sound = "ZSCoughM" .. (1 + ZombRand(4))
                                end
                                if not character:getEmitter():isPlaying(sound) then
                                    character:getEmitter():playSound(sound)
                                end
                            end
                        end
                    end
                    local immune = false
                    local mask = player:getWornItem(ItemBodyLocation.MASK_EYES)
                    if mask then
                        if mask:hasTag(ItemTag.GAS_MASK) then
                            immune = true
                        end
                    end
                    if not immune then
                        local dist = math.sqrt(math.pow(player:getX() - effect.x, 2) + math.pow(player:getY() - effect.y, 2))
                        if dist < 3 then
                            local stats = player:getStats()

                            local intoxication = stats:get(CharacterStat.INTOXICATION)
                            stats:set(CharacterStat.INTOXICATION, intoxication + 2)

                            local sickness = stats:get(CharacterStat.FOOD_SICKNESS)
                            stats:set(CharacterStat.FOOD_SICKNESS, sickness + 1)

                            local sound = player:getDescriptor():getVoicePrefix() .. "Cough"
                            if not player:getEmitter():isPlaying(sound) then
                                player:getEmitter():playVocals(sound)
                            end
                        end
                    end
                end
            end

        else
            table.remove(BWOEffects2.tab, i)
        end
    end
end

local onServerCommand = function(mod, command, args)
    if mod == "BWOEffects" then
        BWOEffects[command](args)
    end
end

Events.OnServerCommand.Add(onServerCommand)
Events.OnPreUIDraw.Add(BWOEffects2.Process)