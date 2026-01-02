BWOOptions = BWOOptions or {}

local options = PZAPI.ModOptions:create("BanditsWeekOne", getText("UI_optionscreen_BWO_WeekOne"))
options:addTitle(getText("UI_optionscreen_BWO_WeekOne"))

-- talk option
options:addKeyBind("TALK", getText("UI_optionscreen_BWO_Talk"), Keyboard.KEY_T, getText("UI_optionscreen_BWO_Talk"))

-- intro music option
BWOOptions.IntroMusic = {}
BWOOptions.IntroMusic["None"] = "None"
BWOOptions.IntroMusic["Random"] = "Random"
BWOOptions.IntroMusic["UIBWOMusic1"] = "Calm Before The Storm (Zach Beever)"
BWOOptions.IntroMusic["UIBWOMusic2"] = "Alone (Zach Beever)"
BWOOptions.IntroMusic["UIBWOMusic3"] = "Barricading (Zach Beever)"
BWOOptions.IntroMusic["UIBWOMusic4"] = "Inevitable (Slayer)"

BWOOptions.IntroMusicDefault = 2

local introMusicCombo = options:addComboBox("INTROMUSIC", getText("UI_optionscreen_BWO_IntroMusic"))

local i = 1
for k, v in pairs(BWOOptions.IntroMusic) do
    local default = false
    if i == BWOOptions.IntroMusicDefault then default = true end
    introMusicCombo:addItem(v, default)
    i = i + 1
end


