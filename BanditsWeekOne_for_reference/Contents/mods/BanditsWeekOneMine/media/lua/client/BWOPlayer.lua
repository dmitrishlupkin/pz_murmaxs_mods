BWOPlayer = BWOPlayer or {}

BWOPlayer.tick = 0

-- time spent on aiming after aim start
BWOPlayer.aimTime = 0

-- a flag that get set when the player is sleeping to be later used as a pseudo trigger
BWOPlayer.wasSleeping = false

-- make npcs react to actual crime
BWOPlayer.ActivateWitness = function(character, min)
    local activatePrograms = {"Patrol", "Inhabitant", "Walker", "Runner", "Postal", "Janitor", "Gardener", "Entertainer", "Vandal", "Medic", "Fireman"}
    local braveList = {
        Bandit.clanMap.PoliceBlue,
        Bandit.clanMap.PoliceGray,
        Bandit.clanMap.PoliceRiot,
        Bandit.clanMap.SWAT,
        Bandit.clanMap.SecretLab,
        Bandit.clanMap.ArmyGreen,
        Bandit.clanMap.ArmyGreenMask,
        Bandit.clanMap.Security
    }

    local witnessList = BanditZombie.GetAllB()
    for id, witness in pairs(witnessList) do 
        local dist = math.sqrt(math.pow(character:getX() - witness.x, 2) + math.pow(character:getY() - witness.y, 2))
        if dist < min then
            local actor = BanditZombie.GetInstanceById(witness.id)
            local canSee = actor:CanSee(character)
            if canSee or dist < 3 then
                -- witnessing civilians need to change peaceful behavior to active

                for _, prg in pairs(activatePrograms) do
                    if witness.brain.program.name == prg then
                        Bandit.ClearTasks(actor)
                        local brave = false
                        for _, v in pairs(braveList) do
                            if v == witness.brain.cid then
                                brave = true
                                break
                            end
                        end
                        if brave then
                            Bandit.SetProgram(actor, "Police", {})
                            Bandit.SetHostileP(actor, true)
                            Bandit.Say(actor, "SPOTTED")
                        else
                            local r = 4
                            if actor:isFemale() then r = 10 end

                            Bandit.SetProgram(actor, "Active", {})
                            if ZombRand(r) == 0 then
                                Bandit.SetHostileP(actor, true)
                            end
                            Bandit.Say(actor, "REACTCRIME")
                        end
                    end
                end
            end
        end
    end
end

-- make npcs react to threat possibility (player aiming or swinging weapon)
BWOPlayer.ActivateTargets = function(character, min, severity)
    local activatePrograms = {"Patrol", "Inhabitant", "Walker", "Runner", "Postal", "Janitor", "Gardener", "Entertainer", "Vandal", "Medic", "Fireman"}
    local braveList = {
        Bandit.clanMap.PoliceBlue,
        Bandit.clanMap.PoliceGray,
        Bandit.clanMap.PoliceRiot,
        Bandit.clanMap.SWAT,
        Bandit.clanMap.SecretLab,
        Bandit.clanMap.ArmyGreen,
        Bandit.clanMap.ArmyGreenMask,
        Bandit.clanMap.Security
    }

    local witnessList = BanditZombie.GetAllB()
    local wasLegal = false
    for id, witness in pairs(witnessList) do
        local dist = math.sqrt(math.pow(character:getX() - witness.x, 2) + math.pow(character:getY() - witness.y, 2))
        if dist < min then
            if witness.brain.hostile or witness.brain.program.name == "Vandal" then
                wasLegal = true
            else
                local actor = BanditZombie.GetInstanceById(witness.id)
                local canSee1 = actor:CanSee(character)
                local canSee2 = character:CanSee(actor)
                if canSee1 and canSee2 then
                    for _, prg in pairs(activatePrograms) do
                        if witness.brain.program.name == prg then
                            Bandit.ClearTasks(actor)
                            local brave = false
                            for _, v in pairs(braveList) do
                                if v == witness.brain.cid then
                                    brave = true
                                    break
                                end
                            end
                            if brave then
                                Bandit.SetProgram(actor, "Police", {})
                                if not wasLegal then
                                    if severity == 2 then
                                        Bandit.SetHostileP(actor, true)
                                    end
                                    Bandit.Say(actor, "SPOTTED")
                                end
                            else
                                Bandit.SetProgram(actor, "Active", {})
                                if not wasLegal then
                                    local r = 4
                                    if actor:isFemale() then r = 9 end
                                    if ZombRand(r) == 0 and severity == 2 then
                                        Bandit.SetHostileP(actor, true)
                                    end
                                    Bandit.Say(actor, "REACTCRIME")
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

BWOPlayer.ActivateExcercise = function(character, min)
    local activatePrograms = {"Walker", "Runner", "Inhabitant"}
    local witnessList = BanditZombie.GetAllB()
    local cnt = 0
    for id, witness in pairs(witnessList) do
        local dist = math.sqrt(math.pow(character:getX() - witness.x, 2) + math.pow(character:getY() - witness.y, 2))
        if dist < min then
            local actor = BanditZombie.GetInstanceById(witness.id)
            local canSee = actor:CanSee(character)
            if canSee or dist < 3 then
                for _, prg in pairs(activatePrograms) do
                    if witness.brain.program.name == prg then
                        if not Bandit.HasTaskType(actor, "PushUp") then
                            Bandit.ClearTasks(actor)
                            local task = {action="PushUp", time=2000}
                            Bandit.AddTask(actor, task)
                            cnt = cnt + 1
                        end
                    end
                end
            end
        end
    end

    if cnt > 0 then
        BWOPlayer.Earn(character, cnt)
    end
end

-- adds money from player inventory
BWOPlayer.Earn = function(character, cnt)
    local inventory = character:getInventory()
    for i=1, cnt do
        local item = BanditCompatibility.InstanceItem("Base.Money")
        inventory:AddItem(item)
    end
    character:addLineChatElement("Earn: +$" .. cnt .. ".00", 0, 1, 0)
end

-- substracts money from player inventory
BWOPlayer.Pay = function(character, cnt)

    local function predicateMoney(item)
        return item:getType() == "Money"
    end

    local inventory = character:getInventory()
    local items = ArrayList.new()

    inventory:getAllEvalRecurse(predicateMoney, items)
    if items:size() >= cnt then
        character:addLineChatElement("Paid: -$" .. cnt .. ".00", 0, 1, 0)
        for i=0, cnt do
            inventory:RemoveOneOf("Money", true)
        end
    else
        character:addLineChatElement("No money, item stolen!", 1, 0, 0)
        BWOPlayer.ActivateWitness(character, 18)
    end
end

-- controls npc reaction to player violence
BWOPlayer.CheckFriendlyFire = function(bandit, attacker)

    if not attacker then return end

    local player = getSpecificPlayer(0)
    if not player then return end

    -- attacking zombies is ok!
    local brain = BanditBrain.Get(bandit)
    if not bandit:getVariableBoolean("Bandit") or not brain then return end

    -- killing bandits is ok!
    if brain.program.name == "Vandal" then 
        if instanceof(attacker, "IsoPlayer") and not attacker:isNPC() then
            local profession = player:getDescriptor():getProfession()
            if BWOScheduler.Anarchy.Transactions and profession == "policeofficer" then
                BWOPlayer.Earn(player, 5)
            end
        end
        return
    end

    -- defending in your home is ok
    local base = BanditPlayerBase.GetBase(attacker)
    if base and instanceof(attacker, "IsoPlayer") and not attacker:isNPC() then return end
 
    -- to weak to respond
    -- local infection = Bandit.GetInfection(bandit)
    -- if infection > 0 then return end

    -- who saw this changes program
    local witnessList = BanditZombie.GetAllB()
    for id, witness in pairs(witnessList) do
        if not witness.brain.hostileP then
            local dist = math.sqrt(math.pow(bandit:getX() - witness.x, 2) + math.pow(bandit:getY() - witness.y, 2))
            if dist < 15 then
                local actor = BanditZombie.GetInstanceById(witness.id)
                if actor:CanSee(bandit) then

                    local params = {}
                    params.x = bandit:getX()
                    params.y = bandit:getY()
                    params.z = bandit:getZ()

                    local wasPlayerFault = false
                    if instanceof(attacker, "IsoPlayer") and not attacker:isNPC() then
                        wasPlayerFault = true
                        if brain.id ~= id then
                            if brain.occupation == "Police" then
                                if BWOPopControl.SWAT.On then
                                    params.hostile = true
                                    BWOScheduler.Add("CallSWAT", params, 19500)
                                end
                            else
                                if BWOPopControl.Police.On then
                                    params.hostile = true
                                    BWOScheduler.Add("CallCops", params, 12000)
                                end
                            end
                        end
                    else
                        -- call friendly police
                        if BWOPopControl.Police.On then
                            params.hostile = false
                            BWOScheduler.Add("CallCops", params, 12000)
                        end
                    end

                    -- call medics
                    if BWOPopControl.Medics.On then
                        BWOScheduler.Add("CallMedics", params, 15000)
                    elseif BWOPopControl.Hazmats.On then
                        BWOScheduler.Add("CallHazmats", params, 15500)
                    end

                    -- witnessing civilians need to change peaceful behavior to active
                    local activatePrograms = {"Patrol", "Police", "Inhabitant", "Walker", "Runner", "Postal", "Janitor", "Gardener", "Entertainer", "Vandal"}
                    for _, prg in pairs(activatePrograms) do
                        if witness.brain.program.name == prg then 
                            if witness.brain.occupation == "Police" or witness.brain.occupation == "Security" or witness.brain.occupation == "Army" then
                                Bandit.ClearTasks(actor)
                                Bandit.SetProgram(actor, "Police", {})
                                if wasPlayerFault then
                                    Bandit.SetHostileP(actor, true)
                                end
                            else
                                if ZombRand(4) > 0 then
                                    Bandit.ClearTasks(actor)
                                    Bandit.SetProgram(actor, "Active", {})
                                    if wasPlayerFault and ZombRand(2) == 0 then
                                        Bandit.SetHostileP(actor, true)
                                    end
                                    Bandit.Say(actor, "REACTCRIME")
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- force overwrite Bandits logic
BanditPlayer.CheckFriendlyFire = BWOPlayer.CheckFriendlyFire

-- detecting crime based on who got killed by player
local onHitZombie = function(zombie, attacker, bodyPartType, handWeapon)
    local brain = BanditBrain.Get(zombie)
    if brain and brain.program.name == "Shahid" then
        zombie:Kill(nil)
        BWOEvents.Explode(zombie:getX(), zombie:getY())
    end
end

-- detecting crime based on who got hit by player
local onZombieDead = function(zombie)

    BWOPlayer.aimTime = -25

    -- register dead body
    local player = getSpecificPlayer(0)
    local args = {x=zombie:getX(), y=zombie:getY(), z=zombie:getZ()}
    sendClientCommand(player, 'Commands', 'DeadBodyAdd', args)
end

--INTERCEPTORS

-- intercepting player actions
local onTimedActionPerform = function(data)
   
    local character = data.character
    if not character then return end

    local profession = character:getDescriptor():getProfession()

    local action = data.action:getMetaType()
    if not action then return end

    -- illegal actions intercepted here
    if BWOScheduler.Anarchy.IllegalMinorCrime and action == "ISSmashWindow" or action == "ISSmashVehicleWindow" or action == "ISHotwireVehicle" or action == "ISTakeGasolineFromVehicle" then
        BWOPlayer.ActivateWitness(character, 18)
        return
    end

    if not BWOScheduler.Anarchy.Transactions then return end

    -- trash collecting and littering
    if action == "ISMoveablesAction" then
        local mode = data.mode
        local origSpriteName = data.origSpriteName
        if mode and origSpriteName then
            
            if origSpriteName:embodies("trash") then

                -- earn by collecting trash
                if mode == "pickup" then
                    BWOPlayer.Earn(character, 1)

                -- littering
                elseif mode == "place" then
                    BWOPlayer.Pay(character, 1)
                    BWOPlayer.ActivateWitness(character, 18)
                end
            end
        end
        return
    end

    -- fuel
    if action == "ISRefuelFromGasPump" then
        if data.tankStart and data.tankTarget then
            local amount = data.tankTarget - data.tankStart
            local price = BanditUtils.AddPriceInflation(1.11)
            local payment = math.floor(amount * price)
            BWOPlayer.Pay(character, payment)
        end
    end

    if action == "ISTakeFuel" then
        if data.itemStart and data.itemTarget then
            local amount = data.itemTarget - data.itemStart
            local price = BanditUtils.AddPriceInflation(1.11)
            local payment = math.floor(amount * price)
            BWOPlayer.Pay(character, payment)
        end
    end

    -- earning

    -- fireman
    if profession == "fireofficer" then
        if action == "ISPutOutFire" then
            BWOPlayer.Earn(character, 25)
        end
        return
    end

    -- mechanic
    if profession == "mechanics" then
        if action == "ISFixVehiclePartAction" then
        
            local vehiclePart = data.vehiclePart
            local vehicle = vehiclePart:getVehicle()
            local md = vehicle:getModData()
            if md.BWO and md.BWO.client then
                local skill = character:getPerkLevel(Perks.MetalWelding)
                BWOPlayer.Earn(character, skill * 5)
            end
        elseif action == "ISRepairEngine" then
            local vehicle = data.vehicle
            local md = vehicle:getModData()
            if md.BWO and md.BWO.client then
                local skill = character:getPerkLevel(Perks.Mechanics)
                BWOPlayer.Earn(character, skill * 20)
            end
        elseif action == "ISInstallVehiclePart" then
            local vehiclePart = data.part
            local vehicle = vehiclePart:getVehicle()
            local md = vehicle:getModData()
            if md.BWO and md.BWO.client then
                local id = vehiclePart:getScriptPart():getId()
                local idx
                for k, v in pairs(BWOVehicles.parts) do
                    if id == v then
                        idx = k
                    end
                end

                if idx then
                    local item = data.item
                    local oldCondition = md.BWO.parts[idx]
                    local newCondition = item:getCondition()
                    BWOPlayer.Earn(character, math.ceil((newCondition - oldCondition) * item:getWeight() / 5))
                    md.BWO.parts[idx] = newCondition
                end
            end
        end
        return
    end

    -- park ranger
    if profession == "parkranger" then
        if action == "ISForageAction" then
            if not data.discardItems then
                local junkCategories = {"Junk", "Trash", "Ammunition", "JunkFood", "JunkWeapons"}
                local categories = data.itemDef.categories
                local junk = false
                for _, c1 in pairs(categories) do
                    for _, c2 in pairs(junkCategories) do
                        if c1 == c2 then
                            junk = true
                            break
                        end
                    end
                end

                if junk then
                    BWOPlayer.Earn(character, 25)
                end
            end
        end
    end
end

local onTimedActionStop  = function(data)
    local character = data.character
    if not character then return end

    local action = data.action:getMetaType()
    if not action then return end

    -- fuel
    if action == "ISRefuelFromGasPump" then
        if data.tankStart and data.amountSent then
            local amount = data.amountSent - data.tankStart
            local price = BanditUtils.AddPriceInflation(1.11)
            local payment = math.floor(amount * price)
            BWOPlayer.Pay(character, payment)
        end
    end
end

local onFitnessActionExeLooped = function(data)
    if not BWOScheduler.Anarchy.Transactions then return end

    local character = data.character
    if not character then return end

    local profession = character:getDescriptor():getProfession()
    if profession == "fitnessInstructor" then
        BWOPlayer.ActivateExcercise(character, 5)
    end
end

-- inventory transfer player action needs to intercepted separately to have access the necessary data
local onInventoryTransferAction = function(data)

    if not BWOScheduler.Anarchy.Transactions then return end

    local character = data.character
    if not character then return end

    local profession = character:getDescriptor():getProfession()

    local srcContainer = data.srcContainer
    if not srcContainer then return end

    local destContainer = data.destContainer
    local descContainerType = destContainer:getType()

    local item = data.item
    local itemType = item:getFullType()
    local md = item:getModData()
    if not md.BWO then
        md.BWO = {} 
        md.BWO.stolen = false
        md.BWO.bought = false
    end

    -- item already bought in the past
    if md.BWO.bought then return end

    local object = srcContainer:getParent()

    local square
    local customName
    if object then 
        -- taking from trashcans is not buying
        local sprite = object:getSprite()
        if sprite then
            local props = sprite:getProperties()
            if props:Is("CustomName") then
                customName = props:Val("CustomName")
            end
        end

        -- selling
        if instanceof(object, "IsoPlayer") then 
            if not md.BWO.stolen then
                if profession == "lumberjack" then
                    if itemType == "Base.Log" and descContainerType == "logs" then
                        BWOPlayer.Earn(character, 10)
                        md.BWO.stolen = true
                    elseif itemType == "Base.Plank" and descContainerType == "crate" then
                        BWOPlayer.Earn(character, 6)
                        md.BWO.stolen = true
                    end
                elseif profession == "fisherman" then
                    local room = destContainer:getSquare():getRoom()
                    if room and BWORooms.IsKitchen(room) and (BWORooms.IsRestaurant(room) or BWORooms.IsShop(room)) then
                        if descContainerType == "fridge" or descContainerType == "freezer" then
                            local fishOptions = {"Base.Bass", "Base.SmallmouthBass", "Base.LargemouthBass", "Base.SpottedBass", "Base.StripedBass", "Base.WhiteBass", 
                                                 "Base.Catfish", "Base.BlueCatfish", "Base.ChannelCatfish", "Base.FlatheadCatfish", 
                                                 "Base.Panfish", "Base.RedearSunfish", "Base.Crayfish", 
                                                 "Base.Crappie", "Base.BlackCrappie", "Base.WhiteCrappie", 
                                                 "Base.Perch", "Base.Paddlefish", "Base.YellowPerch", 
                                                 "Base.Pike", "Base.Trout"}

                            for _, fishOption in pairs(fishOptions) do
                                if itemType == fishOption then
                                    local weight = item:getActualWeight()
                                    local price = math.floor(weight * SandboxVars.BanditsWeekOne.PriceMultiplier * 4)
                                    BWOPlayer.Earn(character, price)
                                    md.BWO.stolen = true
                                    break
                                end
                            end
                        end
                    end
                end
            end
            return
        end

        -- looting body
        if instanceof(object, "IsoDeadBody") then 
            return
        end

        square = object:getSquare()
    else
        square = character:getSquare()
    end

    -- transfering to non player containers is not buying
    local destCharacter = destContainer:getCharacter()
    if not destCharacter then return end

    -- transfering between player containers is not buying
    local srcCharacter = srcContainer:getCharacter()
    if instanceof(srcCharacter, "IsoPlayer") and instanceof(destCharacter, "IsoPlayer") then return end

    local room = square:getRoom()

    -- you can take outside buildings or from vehicles
    if not room then return end

    local canTake, shouldPay = BWORooms.TakeIntention(room, customName)

    -- taking money is not buying
    if data.item:getType() == "Money" then
        canTake = false
        shouldPay = false
    end

    if canTake then return end

    if shouldPay then
        local itemType = data.item:getFullType()
        local category = data.item:getDisplayCategory()
        local weight = data.item:getActualWeight()
        local price = BanditUtils.AddPriceInflation(weight * SandboxVars.BanditsWeekOne.PriceMultiplier * 10)
        if price == 0 then price = 1 end

        md.BWO.bought = true

        BWOPlayer.Pay(character, price)

    elseif not canTake then
        md.BWO.stolen = true
        BWOPlayer.ActivateWitness(character, 15)
    end

end

-- other interceptors 
local onPlayerUpdate = function(player)

    local isInCircle = function(x, y, cx, cy, r)
        local d2 = (x - cx) ^ 2 + (y - cy) ^ 2
        return d2 <= r ^ 2
    end

    -- tick update
    if BWOPlayer.tick >= 32 then
        BWOPlayer.tick = 0
    end

    -- intercepting end of sleep
    if not player:isAsleep() and BWOPlayer.wasSleeping then
        BWOPlayer.wasSleeping = false
        local params = {}
        params.night = getGameTime():getNightsSurvived()
        BWOScheduler.Add("Dream", params, 600)
    end

    -- intercepting player aiming
    if BWOScheduler.Anarchy.IllegalMinorCrime and (BWOPlayer.tick == 0 or BWOPlayer.tick == 16) then
        if player:isAiming() and not BanditPlayer.IsGhost(player)  then 
            local primaryItem = player:getPrimaryHandItem()

            local max
            if primaryItem and primaryItem:IsWeapon() then
                local primaryItemType = WeaponType.getWeaponType(primaryItem)
                if primaryItemType == WeaponType.firearm then
                    max = 12
                elseif primaryItemType == WeaponType.handgun then
                    max = 8
                elseif primaryItemType == WeaponType.heavy then
                    max = 3
                elseif primaryItemType == WeaponType.onehanded then
                    max = 3
                elseif primaryItemType == WeaponType.knife then
                    max = 3
                elseif primaryItemType == WeaponType.spear then
                    max = 3
                elseif primaryItemType == WeaponType.twohanded then
                    max = 3
                elseif primaryItemType == WeaponType.throwing then
                    max = 12
                elseif primaryItemType == WeaponType.chainsaw then
                    max = 4
                end
            end

            if max then
                if BWOPlayer.aimTime > 11 then
                    BWOPlayer.ActivateTargets(player, max, 2)
                elseif BWOPlayer.aimTime > 4 then 
                    BWOPlayer.ActivateTargets(player, max, 1)
                end
                BWOPlayer.aimTime = BWOPlayer.aimTime + 1
            end
        else
            BWOPlayer.aimTime = 0
        end
    end

    -- fallout
    if BWOScheduler.World.PostNuclearFallout and BWOPlayer.tick == 1 and player:getZ() >= 0 then

        local immune = false
        local suit = player:getWornItem("FullSuitHead")
        if suit then
            if suit:getFullType() == "Base.HazmatSuit" then 
                immune = true 
            end
        end

        local gmd = GetBWOModData()
        local nukes = gmd.Nukes
        local isRadiation = false
        for _, nuke in pairs(nukes) do
            if isInCircle(player:getX(), player:getY(), nuke.x, nuke.y, nuke.r) then

                isRadiation = true
                break 
            end
        end

        if isRadiation then

            BWOTex.tex = getTexture("media/textures/fallout.png")
            BWOTex.speed = 0.0005
            BWOTex.mode = "full"

            local maxAlpha = 0.3
            if player:isOutside() then
                maxAlpha = 0.4
            end
            if BWOTex.alpha < maxAlpha then
                BWOTex.alpha = BWOTex.alpha + 0.02
            end

            if BWOTex.alpha > maxAlpha + 0.1 then
                BWOTex.alpha = 0.4
            end

            if not immune then
                local bodyDamage = player:getBodyDamage()
                local stats = player:getStats()
                local sick = bodyDamage:getFoodSicknessLevel()
                local drunk = stats:getDrunkenness()
                local incSick = 1
                local incDrunk = 2
                if player:isOutside() then
                    incSick = incSick * 2
                    incDrunk = incDrunk * 2
                end

                if sick < 170 then
                    bodyDamage:setFoodSicknessLevel(sick + incSick)
                end

                if drunk < 90 then
                    stats:setDrunkenness(drunk + incDrunk)
                end
            end

            BWOAmbience.Enable("radiation")
        else
            BWOAmbience.Disable("radiation")
        end
    end

    BWOPlayer.tick = BWOPlayer.tick + 1
end

-- de-hostile civs for new player
local function onPlayerDeath(player)
    local civList = BanditZombie.GetAllB()
    for id, civ in pairs(civList) do
        if civ.brain.hostileP then
            local actor = BanditZombie.GetInstanceById(civ.brain.id)
            if actor then
                Bandit.SetHostileP(actor, false)
            end
        end
    end
end

-- intercepting player swinging weapon
local onWeaponSwing = function(character, handWeapon)
    if not BWOScheduler.Anarchy.IllegalMinorCrime then return end
	if not instanceof(character, "IsoPlayer") then return end
    if BanditPlayer.IsGhost(character) then return end
    BWOPlayer.aimTime = 0

    local primaryItemType = WeaponType.getWeaponType(handWeapon)
    if primaryItemType == WeaponType.barehand then return end
    if not character:getPrimaryHandItem() then return end

    local severity = 1
    if primaryItemType == WeaponType.firearm or primaryItemType == WeaponType.handgun then
        severity = 2
    end

    BWOPlayer.ActivateTargets(character, 15, severity)
end

-- OTHER

-- sleep detector to init dreams
local everyHours = function()
	local player = getSpecificPlayer(0)
    if player and player:isAsleep() then
        BWOPlayer.wasSleeping = true
    end
end

-- time based jobs
local everyOneMinute = function()
    
    if not BWOScheduler.Anarchy.Transactions then return end

    local player = getSpecificPlayer(0)
    if not player then return end
    if player:isAsleep() then return end 

    local gametime = getGameTime()
    local minute = gametime:getMinutes()

    if minute % 5 > 0 then return end

    local profession = player:getDescriptor():getProfession()
    local px = player:getX()
    local py = player:getY()
    local pz = player:getZ()
    local payment

    if profession == "parkranger" then
        local zone = player:getSquare():getZone()
        if zone then
            local zoneType = zone:getType()
            if zoneType then
                if zoneType == "Forest" then
                    payment = 1
                elseif zoneType == "DeepForest" then
                    payment = 3
                end
            end
        end
    end

    -- room based time based income
    local square = player:getSquare()
    local room = square:getRoom()
    if room then
        local name = BWORooms.GetRealRoomName(room)
        local tab = BWORooms.tab
        local data = BWORooms.tab[name]
        if data then
            if data.income then
                if data.occupations then
                    for _, occupation in pairs(data.occupations) do
                        if profession == occupation then
                            payment = data.income
                            break
                        end
                    end
                end
            end
        end
    end

    if payment then
        BWOPlayer.Earn(player, payment)
    end

end 

local function onExitVehicle(character)
    if not instanceof(character, "IsoPlayer") then return end

    local gmd = GetBanditModData()
    if not gmd.Queue then return end

    local cache = BanditZombie.CacheLightB
    if not cache then return end

    local cell = character:getCell()
    local cx = character:getX()
    local cy = character:getY()

    local player = getSpecificPlayer(0)
    if not player then return end
    local px = player:getX()
    local py = player:getY()

    -- stupid trigger doesnt even have vehicle the player is exiting from
    -- need to look for it
    for x = cx - 5, cx + 5 do
        for y = cy - 5, cy + 5 do
            local square = cell:getGridSquare(x, y, 0)
            if square then
                local vehicle = square:getVehicleContainer()

                if vehicle then
                    local passenger = vehicle:getCharacter(1)
                    if passenger and instanceof(passenger, "IsoPlayer") and passenger:isNPC() then
                        local bid = passenger:getModData().BWOBID
                        for id, gmdBrain in pairs(gmd.Queue) do
                            if gmdBrain.id == bid and gmdBrain.permanent and gmdBrain.inVehicle then
                                if not cache[id] then
                                    local newx = px
                                    local newy = py
                                    local part = vehicle:getPartById("SeatFrontRight")
                                    if part then
                                        newx = part:getX()
                                        newy = part:getY()
                                    end

                                    local seat = vehicle:getSeat(passenger)
                                    vehicle:clearPassenger(seat)
                                    passenger:setVehicle(nil)
                                    passenger:setCollidable(true)
                                    passenger:setX(passenger:getX() + 20)
                                    passenger:setY(passenger:getY() + 20)
                                    passenger:removeFromSquare()
                                    passenger:removeFromWorld()
                                    passenger:removeSaveFile()
                                    -- passenger:Kill(nil)
                                    

                                    local doorPart = vehicle:getPartById("DoorFrontRight")
                                    if doorPart then
                                        local door = doorPart:getDoor()
                                        if door then
                                            door:setOpen(false)
                                        end
                                    end

                                    gmdBrain.bornCoords.x = newx
                                    gmdBrain.bornCoords.y = newy
                                    gmdBrain.bornCoords.z = 0
                                    gmdBrain.inVehicle = false
                                    sendClientCommand(player, 'Commands', 'SpawnRestore', gmdBrain)

                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


LuaEventManager.AddEvent("OnFitnessActionExeLooped")
LuaEventManager.AddEvent("OnInventoryTransferActionPerform")
-- LuaEventManager.AddEvent("OnTimedActionPerform")
LuaEventManager.AddEvent("OnTimedActionStop")

Events.OnHitZombie.Add(onHitZombie)
Events.OnZombieDead.Add(onZombieDead)
Events.OnTimedActionPerform.Add(onTimedActionPerform)
Events.OnTimedActionStop.Add(onTimedActionStop)
Events.OnFitnessActionExeLooped.Add(onFitnessActionExeLooped)
Events.OnInventoryTransferActionPerform.Add(onInventoryTransferAction)
Events.OnPlayerUpdate.Add(onPlayerUpdate)
Events.OnPlayerDeath.Add(onPlayerDeath)
Events.OnWeaponSwing.Add(onWeaponSwing)
Events.EveryHours.Add(everyHours)
Events.EveryOneMinute.Add(everyOneMinute)
Events.OnExitVehicle.Add(onExitVehicle)




