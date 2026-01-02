require "MainOptions"

local function onMainMenuEnter()
    local gameOptions = MainOptions.instance.gameOptions
    for _, option in pairs(gameOptions.options) do
        if option.name == "musicVolume" then
            option.apply = function (self)
                getCore():setOptionMusicVolume(self.control:getVolume())
                BWOMusic.OnMusicVolumeChange(self.control:getVolume())
            end
        end
    end
end

Events.OnMainMenuEnter.Add(onMainMenuEnter)
