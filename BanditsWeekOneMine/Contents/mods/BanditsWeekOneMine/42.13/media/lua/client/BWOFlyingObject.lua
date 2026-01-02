BWOFlyingObject = BWOFlyingObject or {}

BWOFlyingObject.tab = {}
BWOFlyingObject.tick = 0

-- Constants
BWOFlyingObject.dopplerCoeff = 46.66667
local DEG_TO_RAD = math.rad(1)  -- = 0.017453292519943295

local LIGHT_OFFSET = 16
local LIGHT_COLOR = {r = 1, g = 1, b = 1}
local LIGHT_RANGE = 14
local LIGHT_INTENSITY = 4
local LIGHTBAR_OFFSET = 8
local LIGHTBAR_COLOR = {r = 0.6, g = 0.6, b = 1}
local LIGHTBAR_RANGE = 32
local LIGHTBAR_INTENSITY = 1

function oppositeAngle(angle)
    local result = angle + 180
    if result > 180 then
        result = result - 360
    end
    return result
end

BWOFlyingObject.Add = function(effect)
    table.insert(BWOFlyingObject.tab, effect)
end

BWOFlyingObject.Process = function()
    if not isIngameState() then return end
    if isServer() then return end

    local world = getWorld()
    local cm = world:getClimateManager()
    local dls = cm:getDayLightStrength()

    local player = getSpecificPlayer(0)
    if player == nil then return end

    local px, py = player:getX(), player:getY()
    local playerNum = player:getPlayerNum()
    local zoom = getCore():getZoom(playerNum)
    local fr = 1 / (getCore():getOptionUIRenderFPS() / 20)
    local cell = getCell()

    -- Iterate backwards to safely remove effects
    for i = #BWOFlyingObject.tab, 1, -1 do
        local effect = BWOFlyingObject.tab[i]

        effect.cycles = effect.cycles or 1
        effect.rep = effect.rep or 1

        -- Initialize on first frame
        if not effect.frame then 
            effect.frame = 1
            local odir = oppositeAngle(effect.dir)
            local theta = odir * DEG_TO_RAD
            effect.x = effect.cx + (effect.initDist * math.cos(theta))
            effect.y = effect.cy + (effect.initDist * math.sin(theta))
            effect.z = 0
            effect.dist = math.sqrt((effect.x - px)^2 + (effect.y - py)^2)

            -- Init sound emitter if applicable
            if effect.sound then
                local emitter = getWorld():getFreeEmitter(effect.x, effect.y, effect.z)
                local sid = emitter:playSound(effect.sound)
                local sdiff = effect.speed / BWOFlyingObject.dopplerCoeff
                local pitch = 1 + sdiff
                emitter:setPitch(sid, pitch)
                emitter:setVolumeAll(1)
                effect.emitter = emitter
                effect.sid = sid
            end
        end

        if effect.frame > effect.frameCnt and effect.rep >= effect.cycles then
            if effect.sound and effect.emitter then
                effect.emitter:stopSoundByName(effect.sound)
            end
            table.remove(BWOFlyingObject.tab, i)
        else
            if effect.frame > effect.frameCnt then
                effect.rep = effect.rep + 1
                effect.frame = 1
            end

            if effect.sound and effect.emitter then
                -- Doppler pitch adjustment
                local dist = math.sqrt((effect.x - px)^2 + (effect.y - py)^2)
                if dist > effect.dist and not effect.passed then
                    local sdiff = effect.speed / BWOFlyingObject.dopplerCoeff
                    local pitch = 1 - sdiff
                    effect.emitter:setPitch(effect.sid, pitch)
                    effect.passed = true
                end
                effect.dist = dist
                effect.emitter:setPos(effect.x, effect.y, effect.z)
                -- print ("x: "..effect.x.." y:"..effect.y)
            end

            -- Visual rendering only if player outside
            if player:getSquare():isOutside() then
                local width = effect.width / zoom
                local offsetX = width / 2
                local height = effect.height / zoom
                local offsetY = height / 2

                local tx = isoToScreenX(playerNum, effect.x, effect.y, effect.z) - offsetX
                local ty = isoToScreenY(playerNum, effect.x, effect.y, effect.z) - offsetY

                local alpha = BanditUtils.Lerp(1 - dls, 0, 1, 0, 0.6)

                -- Main texture
                if not effect.tex1 then
                    effect.tex1 = getTexture("media/textures/FO/" .. effect.name .. "/" .. effect.dir .. "/base.png")
                end
                if effect.tex1 then
                    UIManager.DrawTexture(effect.tex1, tx, ty, width, height, 1)
                end

                -- Darkening mask
                if not effect.tex1Mask then
                    effect.tex1Mask = getTexture("media/textures/FO/" .. effect.name .. "/" .. effect.dir .. "/mask/base.png")
                end
                if effect.tex1Mask then
                    UIManager.DrawTexture(effect.tex1Mask, tx, ty, width, height, alpha)
                end

                if effect.rotors then
                    effect.tex2 = effect.tex2 or {}
                    if not effect.tex2[effect.frame] then
                        local frameStr = string.format("%03d", effect.frame)
                        effect.tex2[effect.frame] = getTexture("media/textures/FO/" .. effect.name .. "/" .. effect.dir .. "/" .. frameStr .. ".png")
                    end
                    if effect.tex2[effect.frame] then
                        UIManager.DrawTexture(effect.tex2[effect.frame], tx, ty, width, height, 1)
                    end

                    effect.tex2Mask = effect.tex2Mask or {}
                    if not effect.tex2Mask[effect.frame] then
                        local frameStr = string.format("%03d", effect.frame)
                        effect.tex2Mask[effect.frame] = getTexture("media/textures/FO/" .. effect.name .. "/" .. effect.dir .. "/mask/" .. frameStr .. ".png")
                    end
                    if effect.tex2Mask[effect.frame] then
                        UIManager.DrawTexture(effect.tex2Mask[effect.frame], tx, ty, width, height, alpha)
                    end
                end

                if effect.lights and dls < 0.8 then
                    local theta = effect.dir * DEG_TO_RAD
                    local lx = effect.x + (LIGHT_OFFSET * math.cos(theta))
                    local ly = effect.y + (LIGHT_OFFSET * math.sin(theta))
                    local lightSource = IsoLightSource.new(lx, ly, effect.z, LIGHT_COLOR.r, LIGHT_COLOR.g, LIGHT_COLOR.b, LIGHT_RANGE, LIGHT_INTENSITY)
                    if lightSource then
                        cell:addLamppost(lightSource)
                    end

                    if effect.frame == 1 and effect.rep % 7 == 0 then
                        local lx2 = effect.x + (LIGHTBAR_OFFSET * math.cos(theta))
                        local ly2 = effect.y + (LIGHTBAR_OFFSET * math.sin(theta))
                        local lightBar = IsoLightSource.new(lx2, ly2, effect.z, LIGHTBAR_COLOR.r, LIGHTBAR_COLOR.g, LIGHTBAR_COLOR.b, LIGHTBAR_RANGE, LIGHTBAR_INTENSITY)
                        if lightBar then
                            cell:addLamppost(lightBar)
                        end
                    end
                end
            end

            -- Update position
            local theta = effect.dir * DEG_TO_RAD
            effect.x = effect.x + (effect.speed * fr * math.cos(theta))
            effect.y = effect.y + (effect.speed * fr * math.sin(theta))
            effect.frame = effect.frame + 1
        end
    end
end

Events.OnPreUIDraw.Add(BWOFlyingObject.Process)
