require "BWOMusic"

BWOIntro = {}
BWOIntro.test = true

local function onGameBoot()
    local options = PZAPI.ModOptions:getOptions("BanditsWeekOne")
    local musicIdx = options:getOption("INTROMUSIC"):getValue()

    local soundName
    local musicList = BWOOptions.IntroMusic
    local musicCnt = -2 -- skip first 2 options: none and random
    for k, v in pairs(musicList) do
        musicCnt = musicCnt + 1
    end

    local sm = getSoundManager()
    local emitter = getSoundManager():getUIEmitter()
    if musicIdx == 2 then
        local r = 3 + ZombRand(musicCnt)
        local i = 1
        for k, v in pairs(musicList) do
            if i == r then
                soundName = k
                break
            end
            i = i + 1
        end
    else
        local i = 1
        for k, v in pairs(musicList) do
            if i == musicIdx then
                soundName = k
                break
            end
            i = i + 1
        end
    end

    if soundName then
        BWOMusic.Play(soundName, 1)
    end
end

local function onMainMenuEnter()
    -- BWOMusic.Play("BWOMusicOutro", 1)
end

local function onPreMapLoad()
    --[[
    local sm = getSoundManager()
    if sm:isPlayingMusic() then
        sm:StopMusic()
    end
    sm:setMusicVolume(0)]]
    -- sm:stopUISound(133824517)
    -- BWOMusic.Play("BWOMusicOutro", 1)
end

local function onGameStart()
    
    --[[
    local sm = getSoundManager()
    local emitter = sm:getUIEmitter()
    emitter:stopSoundByName("UIBWOMusic1")
    emitter:stopSoundByName("UIBWOMusic2")
    emitter:stopSoundByName("UIBWOMusic3")
    emitter:stopSoundByName("UIBWOMusic4")
    sm:stopUISound(133824517)]]
end

Events.OnGameBoot.Add(onGameBoot)
Events.OnMainMenuEnter.Add(onMainMenuEnter)
Events.OnPreMapLoad.Add(onPreMapLoad)
Events.OnGameStart.Add(onGameStart)