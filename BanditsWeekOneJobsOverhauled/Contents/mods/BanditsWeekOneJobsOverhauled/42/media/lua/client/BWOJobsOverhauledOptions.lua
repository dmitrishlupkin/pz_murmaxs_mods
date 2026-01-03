BWOJobsOverhauledOptions = BWOJobsOverhauledOptions or {}

local function text(key)
    return getTextOrNull(key) or getText(key)
end

local options = PZAPI.ModOptions:create("BanditsWeekOneJobsOverhauled", text("UI_optionscreen_BWOJobsOverhauled"))
options:addTitle(text("UI_optionscreen_BWOJobsOverhauled"))
options:addKeyBind("TOGGLE_PANEL", text("UI_optionscreen_BWOJobsOverhauled_TogglePanel"), Keyboard.KEY_J, text("UI_optionscreen_BWOJobsOverhauled_TogglePanel"))
