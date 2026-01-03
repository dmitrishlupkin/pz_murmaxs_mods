local function text(key)
    return BWOJobsOverhauled.Text(key)
end

local fishTypes = {
    "Base.Bass",
    "Base.SmallmouthBass",
    "Base.LargemouthBass",
    "Base.SpottedBass",
    "Base.StripedBass",
    "Base.WhiteBass",
    "Base.Catfish",
    "Base.BlueCatfish",
    "Base.ChannelCatfish",
    "Base.FlatheadCatfish",
    "Base.Panfish",
    "Base.RedearSunfish",
    "Base.Crayfish",
    "Base.Crappie",
    "Base.BlackCrappie",
    "Base.WhiteCrappie",
    "Base.Perch",
    "Base.Paddlefish",
    "Base.YellowPerch",
    "Base.Pike",
    "Base.Trout",
}

local function buildJob(player)
    local profession = BWOJobsOverhauled.GetProfessionName(player)
    if profession ~= "fisherman" then return nil end

    return {
        id = "fisherman",
        text = text("UI_BWO_JobsOverhauled_Job_Fisherman"),
        tasks = {
            {
                id = "fisherman_task",
                text = text("UI_BWO_JobsOverhauled_Task_Fisherman"),
                conditions = {
                    {
                        id = "fisherman_items",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fisherman_Carrying"),
                        isLongTerm = true,
                        check = function()
                            return BWOJobsOverhauled.HasAnyItemTypes(player, fishTypes)
                        end,
                    },
                    {
                        id = "fisherman_profession",
                        text = text("UI_BWO_JobsOverhauled_Cond_Fisherman_OnDuty"),
                        isLongTerm = true,
                        check = function()
                            return profession == "fisherman"
                        end,
                    },
                },
            },
        },
    }
end

BWOJobsOverhauled.RegisterJob(buildJob)
