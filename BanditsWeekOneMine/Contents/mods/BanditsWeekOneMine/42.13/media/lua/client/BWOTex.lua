BWOTex = BWOTex or {}

BWOTex.tex = getTexture("media/textures/blast_n.png")
BWOTex.alpha = 0.4
BWOTex.speed = 0.05
BWOTex.mode = "full"
BWOTex.screenWidth = getCore():getScreenWidth()
BWOTex.screenHeight = getCore():getScreenHeight()

BWOTex.Blast = function()
    if not isIngameState() then return end
    if BWOTex.alpha == 0 then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    -- if not player:isOutside() then return end

    local speed = BWOTex.speed * getGameSpeed()
    -- local zoom = getCore():getZoom(player:getPlayerNum())
    -- zoom = PZMath.clampFloat(zoom, 0.0, 1.0)

    local alpha = BWOTex.alpha
    if alpha > 1 then alpha = 1 end

    if BWOTex.mode == "full" then
        UIManager.DrawTexture(BWOTex.tex, 0, 0, BWOTex.screenWidth, BWOTex.screenHeight, alpha)
    elseif BWOTex.mode == "center" then
        local xc = BWOTex.screenWidth / 2
        local x1 = xc - BWOTex.tex:getWidth()
        -- local x2 = xc + (BWOTex.tex:getWidth() / 2)

        local yc = BWOTex.screenHeight / 2
        local y1 = yc - BWOTex.tex:getHeight()
        -- local y2 = yc + (BWOTex.tex:getHeight() / 2)
        UIManager.DrawTexture(BWOTex.tex, x1, y1, BWOTex.tex:getWidth() * 2, BWOTex.tex:getHeight() * 2, alpha)
    end
    
    BWOTex.alpha = BWOTex.alpha - speed
    if BWOTex.alpha < 0 then BWOTex.alpha = 0 end
end

BWOTex.SizeChange = function (n, n2, x, y)
    BWOTex.screenWidth = x
    BWOTex.screenHeight = y
end

Events.OnPreUIDraw.Add(BWOTex.Blast)
Events.OnResolutionChange.Add(BWOTex.SizeChange)
