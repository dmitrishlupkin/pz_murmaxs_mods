BWOCompatibility = BWOCompatibility or {}

-- compatibility wrappers

local getGameVersion = function()
    return getCore():getGameVersion():getMajor()
end

BWOCompatibility.GetSandboxOptionVars = function(square)
    
    if getGameVersion()< 42 then return end
    local vars = {}
    local gmd = GetBWOModData()
    local orig = gmd.Sandbox

    table.insert (vars, {"KeyLootNew", 0, orig.KeyLootNew})
    table.insert (vars, {"FoodLootNew", 1.4, orig.FoodLootNew})
    table.insert (vars, {"CannedFoodLootNew", 1.2, orig.CannedFoodLootNew})
    table.insert (vars, {"LiteratureLootNew", 1.2, orig.LiteratureLootNew})
    table.insert (vars, {"SurvivalGearsLootNew", 1.2, orig.SurvivalGearsLootNew})
    table.insert (vars, {"MedicalLootNew", 1.2, orig.MedicalLootNew})
    table.insert (vars, {"WeaponLootNew", 1.2, orig.WeaponLootNew})
    table.insert (vars, {"RangedWeaponLootNew", 1.2, orig.RangedWeaponLootNew})
    table.insert (vars, {"AmmoLootNew", 1.6, orig.AmmoLootNew})
    table.insert (vars, {"MechanicsLootNew", 1.2, orig.MechanicsLootNew})
    table.insert (vars, {"OtherLootNew", 1.2, orig.OtherLootNew})
    table.insert (vars, {"ClothingLootNew", 1.2, orig.ClothingLootNew})
    table.insert (vars, {"ContainerLootNew", 1.2, orig.ContainerLootNew})
    table.insert (vars, {"MementoLootNew", 1.2, orig.MementoLootNew})
    table.insert (vars, {"MediaLootNew", 1.2, orig.MediaLootNew})
    table.insert (vars, {"CookwareLootNew", 1.2, orig.CookwareLootNew})
    table.insert (vars, {"MaterialLootNew", 1.2, orig.MaterialLootNew})
    table.insert (vars, {"FarmingLootNew", 1.2, orig.FarmingLootNew})
    table.insert (vars, {"ToolLootNew", 1.2, orig.ToolLootNew})
    table.insert (vars, {"MaximumRatIndex", 0, orig.MaximumRatIndex})
    return vars
end

BWOCompatibility.GetFlier = function()
    local item
    if getGameVersion() >= 42 then
        item = BanditCompatibility.InstanceItem("Base.Flier")
        item:setName("Flier: CDC URGENT PUBLIC NOTICE")
        local md = item:getModData()
        md.printMedia = "CDC1"
    else
        local txt = "URGENT PUBLIC NOTICE\nIMMEDIATE ACTION REQUIRED\n"
        txt = txt .. "The CDC has declared an imminent contamination hazard in your area. \n\n"
        txt = txt .. "To ensure your safety:\n"
        txt = txt .. "You required to wear approved hazmat suits at all times. \n"
        txt = txt .. "Proceed immediately to underground levels such as basements, shelters, or designated safe zones.\n\n"
        txt = txt .. "Stay alert. Stay protected. Together, we can ensure our safety.\n"
        item = BanditCompatibility.InstanceItem("Base.Notebook")
        item:setName("Flier: CDC URGENT PUBLIC NOTICE")
        item:setCustomName(true)
        item:addPage(1, txt)
    end
    return item
end

BanditCompatibility.HaveRoofFull = function(square)
    if getGameVersion() >= 42 then
        return square:haveRoofFull()
    else
        -- no implementation found
        return true
    end
end

BWOCompatibility.AddVehicle = function(btype, dir, square)
    local vehicle
    if getGameVersion() >= 42 then
        vehicle = addVehicle(btype, square:getX(), square:getY(), square:getZ())
    else
        vehicle = addVehicleDebug(btype, dir, nil, square)
    end
    return vehicle
end

BWOCompatibility.GetCarType = function(carType)
    if getGameVersion() < 42 then
        local map = {}
        map["Base.StepVan_LouisvilleSWAT"] = "Base.PickUpVanLightsPolice"
        if map[carType] then
            return map[carType]
        end
    end
    return carType
end