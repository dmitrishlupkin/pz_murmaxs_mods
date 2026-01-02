ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Entertainer = {}

ZombiePrograms.Entertainer.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)
  
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Entertainer.Main = function(bandit)
    local tasks = {}
    local brain = BanditBrain.Get(bandit)
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()

    local walkType = "Walk"
    local endurance = 0
    
    local health = bandit:getHealth()
    if health < 0.8 then
        walkType = "Limp"
        endurance = 0
    end 

    -- if outside of time change program
    if hour < 9 or hour > 22 then
        Bandit.ClearTasks(bandit)
        Bandit.SetProgram(bandit, "Walker", {})
        
        local syncData = {}
        syncData.id = brain.id
        syncData.program = brain.program
        Bandit.ForceSyncPart(bandit, syncData)
        return {status=true, next="Main", tasks=tasks}
    end

    -- ideas : soda machine, trashman
    -- bench sitters
    -- workshop hammering
    -- road block on roads instead of around the city, protest at the blockade with army and cars and a car crushing into it. 
    -- cheerloaders
    -- mime / clown on street
    -- breakdance on street

    -- musicians
    local musicianTab = {}
    musicianTab.BassPlayer             = {item="Base.GuitarElectric", anim="InstrumentGuitarBass",     sound="BWOInstrumentBassGuitar1"}
    musicianTab.ViolinPlayer           = {item="Base.Violin",                  anim="InstrumentViolin",         sound="BWOInstrumentViolinPaganini"}
    musicianTab.SaxPlayer           = {item="Base.Saxophone",               anim="InstrumentSaxophone",      sound="BWOInstrumentSax" .. tostring((math.abs(brain.id) % 3) + 1)}
    -- musicianTab.FlutePlayer           = {item="Base.Flute",                   anim="InstrumentFlute",          sound=nil}
    -- musicianTab.GuitarPlayer = {item="Base.GuitarElectricRed",       anim="InstrumentGuitarElectric", sound=nil}
    -- musicianTab.Dean           = {item="Base.GuitarElectric", anim="InstrumentGuitarBass",     sound="BWOInstrumentBassGuitar1"}
    -- musicianTab.Rocker         = {item="Base.GuitarAcoustic",          anim="InstrumentGuitarAcoustic", sound=nil}

    for o, tab in pairs(musicianTab) do
        if o == brain.occupation then
            local task = {action="TimeEvent", x=bx, y=by, z=bz, event="entertainer", item=tab.item, left=true, anim=tab.anim, sound=tab.sound}
            table.insert(tasks, task)
            return {status=true, next="Main", tasks=tasks}
        end
    end

    -- street performers
    --[[
    local performerTab = {}
    performerTab.AuthenticClown = {anim=BanditUtils.Choice({"DanceRocketteKick", "DanceHokeyPokey", "DanceChicken"})}
    performerTab.AuthenticClownObese = {anim=BanditUtils.Choice({"DanceRocketteKick", "DanceHokeyPokey", "DanceChicken"})}

    for o, tab in pairs(performerTab) do
        if o == brain.occupation then
            local task = {action="TimeEvent", x=bx, y=by, z=bz, event="entertainer", anim=tab.anim, time=500}
            table.insert(tasks, task)
            return {status=true, next="Main", tasks=tasks}
        end
    end
    ]]

    -- street speakers
    local textPriest = {}
    -- 2 Timothy 3:1-5 
    textPriest[0] = "But mark this: There will be terrible times in the last days. "
    textPriest[1] = "People will be lovers of themselves, lovers of money, "
    textPriest[2] = "boastful, proud, abusive, disobedient to their parents, ungrateful, "
    textPriest[3] = "unholy, without love, unforgiving, slanderous, without self-control, "
    textPriest[4] = "brutal, not lovers of the good, treacherous, rash, conceited, "
    textPriest[5] = "lovers of pleasure rather than lovers of God"
    textPriest[6] = "having a form of godliness but denying its power."
    textPriest[7] = "Have nothing to do with such people! "

    -- Mark 13:5-23 
    textPriest[10] = "Jesus said to them: Watch out that no one deceives you.  "
    textPriest[11] = "Many will come in my name, claiming, 'I am he,' and will deceive many. "
    textPriest[12] = "When you hear of wars and rumors of wars, do not be alarmed. "
    textPriest[13] = "Such things must happen, but the end is still to come. "
    textPriest[14] = "Nation will rise against nation, and kingdom against kingdom. "
    textPriest[15] = "There will be earthquakes in various places, and famines."
    textPriest[16] = "These are the beginning of birth pains. "
    textPriest[17] = "You must be on your guard. You will be handed over to the local councils"
    textPriest[18] = "and flogged in the synagogues."
    textPriest[19] = "On account of me you will stand before governors and kings as witnesses to them."
    textPriest[20] = "And the gospel must first be preached to all nations."
    textPriest[21] = "Whenever you are arrested and brought to trial, do not worry beforehand about what to say."
    textPriest[22] = "Just say whatever is given you at the time, for it is not you speaking, but the Holy Spirit. "
    textPriest[23] = "Brother will betray brother to death, and a father his child."
    textPriest[24] = "Children will rebel against their parents and have them put to death. "
    textPriest[25] = "Everyone will hate you because of me, but the one who stands firm to the end will be saved. "
    textPriest[26] = "When you see 'the abomination that causes desolation' standing where itoes not belong"
    textPriest[27] = "let the reader understand, then let those who are in Judea flee to the mountains. "
    textPriest[28] = "Let no one on the housetop go down or enter the house to take anything out. "
    textPriest[29] = "Let no one in the field go back to get their cloak.  "
    textPriest[30] = "How dreadful it will be in those days for pregnant women and nursing mothers!  "
    textPriest[31] = "Pray that this will not take place in winter,  "
    textPriest[32] = "because those will be days of distress unequaled from the beginning, when God created the world, "
    textPriest[33] = "until now and never to be equaled again. "
    textPriest[34] = "If the Lord had not cut short those days, no one would survive. "
    textPriest[35] = "But for the sake of the elect, whom he has chosen, he has shortened them. "
    textPriest[36] = "At that time if anyone says to you, 'Look, here is the Messiah!' "
    textPriest[37] = "or, 'Look, there he is!' do not believe it. "
    textPriest[38] = "For false messiahs and false prophets will appear "
    textPriest[39] = "and perform signs and wonders to deceive, if possible, even the elect. "
    textPriest[40] = "So be on your guard; "
    textPriest[41] = "I have told you everything ahead of time. "

    -- Peter 3:10-13 
    textPriest[45] = "But the day of the Lord will come like a thief. "
    textPriest[46] = "The heavens will disappear with a roar; the elements will be destroyed by fire, "
    textPriest[47] = "and the earth and everything done in it will be laid bare.  "
    textPriest[48] = "Since everything will be destroyed in this way, what kind of people ought you to be? "
    textPriest[49] = "You ought to live holy and godly lives  "
    textPriest[50] = "as you look forward to the day of God and speed its coming. "
    textPriest[51] = "That day will bring about the destruction of the heavens by fire, "
    textPriest[52] = "and the elements will melt in the heat.  "
    textPriest[53] = "But in keeping with his promise "
    textPriest[54] = "we are looking forward to a new heaven and a new earth,  "
    textPriest[55] = "where righteousness dwells. "

    local speakerTab = {}
    speakerTab.Priest = {anim="ReadBook", item="Bandits.Book", text=textPriest}
    for o, tab in pairs(speakerTab) do
        if o == brain.occupation then
            
            if tab.text[minute] then
                bandit:addLineChatElement(tab.text[minute], 1, 0, 1)
                local task = {action="TimeEvent", x=bx, y=by, z=bz, event="preacher", anim=tab.anim, left=true, item=tab.item, time=200}
                table.insert(tasks, task)
            else
                local task = {action="TimeEvent", x=bx, y=by, z=bz, event="preacher", anim="Talk4", left=true, item=tab.item, time=200}
                table.insert(tasks, task)
            end
            return {status=true, next="Main", tasks=tasks}
        end
    end

    -- street dancing
    --[[
    local dancerTab = {}
    dancerTab.Young = {cassette="CassetteBanditBreakdance01", anim="DanceBreakdance" .. tostring(1 + ZombRand(3))}
    for o, tab in pairs(dancerTab) do
        if o == brain.occupation then

            local boombox = BWOObjects.FindAround(bandit, 7, "Boombox")
            if boombox then
                local dd = boombox:getDeviceData()
                if not dd:getIsTurnedOn() or not boombox:getModData().tcmusic.isPlaying then
                    local square = boombox:getSquare()
                    local asquare = AdjacentFreeTileFinder.Find(square, bandit)
                    if asquare then
                        local dist = math.sqrt(math.pow(bandit:getX() - (asquare:getX() + 0.5), 2) + math.pow(bandit:getY() - (asquare:getY() + 0.5), 2))
                        if dist > 0.70 then
                            table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                            return {status=true, next="Main", tasks=tasks}
                        else
                            local task = {action="BoomboxToggle", on=true, anim="Loot", x=square:getX(), y=square:getY(), z=square:getZ(), time=100}
                            table.insert(tasks, task)
                            return {status=true, next="Main", tasks=tasks}
                        end
                    end
                end

                local task = {action="TimeEvent", x=bx, y=by, z=bz, event="entertainer", anim=tab.anim, time=500}
                table.insert(tasks, task)
                return {status=true, next="Main", tasks=tasks}

            end
        end
    end
    ]]
    
    -- fallback
    local subTasks = BanditPrograms.FallbackAction(bandit)
    if #subTasks > 0 then
        for _, subTask in pairs(subTasks) do
            table.insert(tasks, subTask)
        end
    end

    return {status=true, next="Main", tasks=tasks}
end

