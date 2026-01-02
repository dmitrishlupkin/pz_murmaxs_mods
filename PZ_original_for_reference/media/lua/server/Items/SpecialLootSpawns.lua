SpecialLootSpawns = SpecialLootSpawns or {}

SpecialLootSpawns.OnCreateCatalogue = function(item)
    if not item then return; end;
	local list = SpecialLootSpawns.Catalogues
	local title = list[ZombRand(#list)+1]
	item:setName(getText(item:getDisplayName()) .. ": ".. getText("IGUI_" .. title))
    item:getModData().literatureTitle = item:getType() .. "_" .. title
end

SpecialLootSpawns.OnCreateRPGmanual = function(item)
    if not item then return; end;
	local list = SpecialLootSpawns.RPGs
	local title = list[ZombRand(#list)+1]
	item:setName(getText(item:getDisplayName()) .. ": ".. getText("IGUI_RPG_" .. title))
    item:getModData().literatureTitle = item:getType() .. "_" .. title
end

SpecialLootSpawns.OnCreateGenericMail = function(item)
    if not item then return; end;
    local text = getText("IGUI_" .. SpecialLootSpawns.GenericMail[ZombRand(#SpecialLootSpawns.GenericMail)+1])
	item:setName(text)
end
-- LETTERS
SpecialLootSpawns.OnCreateLetterHandwritten = function(item)
    if not item then return; end;
-- 	if ZombRand(2) == 0 then
-- 		item:setTexture(getTexture("media/textures/Item_LetterHandwritten2.png"))
-- 		item:setWorldStaticModel("LetterHandwritten2")
-- 		item:setStaticModel("LetterHandwritten2")
-- 	end
--     item:getModData().literatureTitle = "LetterHandwritten_"  .. tostring(ZombRand(1000000))
    local text = getText("IGUI_" .. SpecialLootSpawns.LetterHandwritten[ZombRand(#SpecialLootSpawns.LetterHandwritten)+1])
	item:setName(text)
end
SpecialLootSpawns.OnCreateScarecrow = function(item)
	local spriteName = "location_shop_mall_01_68"
	local obj = IsoMannequin.new(getCell(), nil, getSprite(spriteName))
	obj:setMannequinScriptName("MannequinScarecrow02")
	obj:setCustomSettingsToItem(item)
end
SpecialLootSpawns.OnCreateSkeletonDisplay = function(item)
	local spriteName = "location_shop_mall_01_68"
	local obj = IsoMannequin.new(getCell(), nil, getSprite(spriteName))
	obj:setMannequinScriptName("MannequinSkeleton01")
	obj:setCustomSettingsToItem(item)
end
SpecialLootSpawns.OnCreateLocket = function(item)
    if not item then return end
-- L

	local list = SpecialLootSpawns.Locket
	local photo = list[ZombRand(#list)+1]
    local title = getText("IGUI_Photo_" .. photo)

-- 	local list = SpecialLootSpawns.VeryOldPhotos
-- 	local photo = list[ZombRand(#list)+1]
--     local title = getText("IGUI_Photo_" .. photo)
    local text = getText("IGUI_LocketText", getText(item:getScriptItem():getDisplayName()), title)
	item:setName(text)
    item:getModData().collectibleKey = text
end

SpecialLootSpawns.OnCreateDoodle = function(item)
    if not item then return; end;
	local list = SpecialLootSpawns.Doodle
	local photo = list[ZombRand(#list)+1]
    local title = getText("IGUI_Photo_" .. photo)
    local text = getText("IGUI_PhotoOf", getText(item:getScriptItem():getDisplayName()), title)
    item:setName(text)
    item:getModData().literatureTitle = "Doodle_" .. photo .. tostring(ZombRand(1000000))
    item:getModData().collectibleKey = text
end

SpecialLootSpawns.OnCreateDoodleKids = function(item)
    if not item then return; end;
	local list = SpecialLootSpawns.DoodleKids
	local photo = list[ZombRand(#list)+1]
    local title = getText("IGUI_Doodle_" .. photo)
    local text = getText("IGUI_PhotoOf", getText(item:getScriptItem():getDisplayName()), title)
    item:setName(text)
    item:getModData().literatureTitle = "Doodle_" .. photo .. tostring(ZombRand(1000000))
    item:getModData().collectibleKey = text
end

SpecialLootSpawns.OnCreateGasMask = function(item)
    if not item then return; end;
    local mData = item:getModData()
    mData.filterType = "Base.GasmaskFilter"
    local value = ZombRand(1000)/1000.0
    mData.usedDelta = value;
    item:setUsedDelta(ZombRand(1000)/1000.0)
--     mData.usedDelta = ZombRand(1000)/1000.0
--:getClothingItem()
end

SpecialLootSpawns.OnCreateRespirator = function(item)
    if not item then return; end;
    local mData = item:getModData()
    mData.filterType = "Base.RespiratorFilters"
    local value = ZombRand(1000)/1000.0
    mData.usedDelta = value;
    item:setUsedDelta(ZombRand(1000)/1000.0)
--     mData.usedDelta = ZombRand(1000)/1000.0
--:getClothingItem()
end

SpecialLootSpawns.OnCreateSCBA = function(item)
    if not item then return; end;
    local mData = item:getModData()
    mData.tankType = "Base.Oxygen_Tank"
    local value = ZombRand(1000)/1000.0
    mData.usedDelta = value;
    item:setUsedDelta(ZombRand(1000)/1000.0)
--     mData.usedDelta = ZombRand(1000)/1000.0
--:getClothingItem()
end

-- SpecialLootSpawns.OnCreateCanteenMilitary = function(item)
--     if not item then return; end;
--     local num = ZombRand(3)
--     if num == 0 then return
--     elseif num == 1 then
--         item:setStaticModel("CanteenMilitaryUS")
--         item:setWorldStaticModel("CanteenMilitaryUS_Ground")
-- 		item:setTexture(getTexture("media/textures/Item_Canteen_Military_Green.png"))
--     else
--         item:setStaticModel("CanteenMilitaryCamo")
--         item:setWorldStaticModel("CanteenMilitaryCamo_Ground")
-- 		item:setTexture(getTexture("media/textures/Item_Canteen_Military_Camo.png"))
--     end
-- end
--
-- SpecialLootSpawns.OnCreateCanteen = function(item)
--     if not item then return; end;
--     local num = ZombRand(5)
--     if num == 0 then return
--     elseif num == 1 then
--         item:setStaticModel("CanteenMilitaryUS")
--         item:setWorldStaticModel("CanteenMilitaryUS_Ground")
-- 		item:setTexture(getTexture("media/textures/Item_Canteen_Military_Green.png"))
--     elseif num == 2 then
--         item:setStaticModel("CanteenMilitaryCamo")
--         item:setWorldStaticModel("CanteenMilitaryCamo_Ground")
-- 		item:setTexture(getTexture("media/textures/Item_Canteen_Military_Camo.png"))
--     elseif num == 3 then
--         item:setStaticModel("CanteenMilitaryBlack")
--         item:setWorldStaticModel("CanteenMilitaryBlack_Ground")
-- 		item:setTexture(getTexture("media/textures/Item_Canteen_Black.png"))
--     elseif num == 4 then
--         item:setStaticModel("CanteenMilitaryMetal")
--         item:setWorldStaticModel("CanteenMilitaryMetal_Ground")
-- 		item:setTexture(getTexture("media/textures/Item_Canteen_Metal.png"))
--     end
-- end

SpecialLootSpawns.OnCreateHairDyeBottle = function(item)
    if not item then return; end;
	if not item:getFluidContainer() then return end;
	local fluid = item:getFluidContainer():getPrimaryFluid();
	if fluid then
		local color	= item:getFluidContainer():getColor();
		local r, g, b = color:getR(), color:getG(), color:getB();
		item:setColorRed(r);
		item:setColorGreen(g);
		item:setColorBlue(b);
	end
end

SpecialLootSpawns.OnCreatePopBottle = function(item)
    if not item then return; end;
	if not item:getFluidContainer() then return end;
	local fluid = item:getFluidContainer():getPrimaryFluid();
	if fluid:getFluidTypeString() == "SodaPop" then
		item:setModelIndex(1);	
	else
		item:setModelIndex(0);
	end

	local fluidColor = item:getFluidContainer():getColor();
	local r, g, b = fluidColor:getR(), fluidColor:getG(), fluidColor:getB();
	
	if fluid:getFluidTypeString() == "Cola" then
		r, g, b = 1.0, 0.0, 0.0;
	elseif fluid:getFluidTypeString() == "GingerAle" then
		r, g, b = 0.0, 0.0, 1.0;
	elseif fluid:getFluidTypeString() == "SodaLime" then
		r, g, b = 0.0, 1.0, 0.0;			
	elseif fluid:getFluidTypeString() == "SodaPop" then
		r, g, b = 1.0, 0.8, 0.0;	
	end

	item:setColorRed(r);
	item:setColorGreen(g);
	item:setColorBlue(b);
	item:setColor(Color.new(r, g, b));
	item:setCustomColor(true);
end

SpecialLootSpawns.OnCreatePopCan = function(item)
    if not item then return; end;
	if not item:getFluidContainer() then return end;
	local fluid = item:getFluidContainer():getPrimaryFluid();
	if fluid:getFluidTypeString() == "ColaDiet" then
		item:setModelIndex(0);
	elseif fluid:getFluidTypeString() == "Cola" then
		item:setModelIndex(1);	
	elseif fluid:getFluidTypeString() == "GingerAle" then
		item:setModelIndex(2);			
	else
		item:setModelIndex(0);
	end
end

SpecialLootSpawns.OnCreateColorFromDefinition = function(item)
    if not item then return; end;
	if not RandomTint[item:getType()] then return; end;
	
	local colorTable = RandomTint[item:getType()];
	if #colorTable == 0 then return; end;

	local rgbTable = colorTable[ZombRand(1, #RandomTint[item:getType()] + 1)];
	local r, g, b = rgbTable.r, rgbTable.g, rgbTable.b;

	item:setColorRed(r);
	item:setColorGreen(g);
	item:setColorBlue(b);
	item:setColor(Color.new(r, g, b));
	item:setCustomColor(true);
end

SpecialLootSpawns.OnCreateRandomColor = function(item)
    if not item then return; end;
	if item:isCustomColor() == true then return; end;

	local r, g, b = ZombRandFloat(0.0, 1.0), ZombRandFloat(0.0, 1.0), ZombRandFloat(0.0, 1.0);

	item:setColorRed(r);
	item:setColorGreen(g);
	item:setColorBlue(b);
	item:setColor(Color.new(r, g, b));
	item:setCustomColor(true);
end

SpecialLootSpawns.OnCreateSodaCan = function(item)
    if not item then return; end;
	if not item:getFluidContainer() then return end;
	local color = item:getFluidContainer():getColor();
	local r, g, b = color:getR(), color:getG(), color:getB();

	item:setColorRed(r);
	item:setColorGreen(g);
	item:setColorBlue(b);
	item:setColor(color);
	item:setCustomColor(true);
end

SpecialLootSpawns.OnCreateWaterBottle = function(item)
    if not item then return; end;
	if not item:getFluidContainer() then return end;
	local fluid = item:getFluidContainer():getPrimaryFluid();
	local r, g, b;
	
	if fluid:getFluidTypeString() == "Water" then
		r, g, b = 0.0, 0.0, 1.0;
	elseif fluid:getFluidTypeString() == "CarbonatedWater" then
		r, g, b = 0.0, 1.0, 1.0;
	end

	item:setColorRed(r);
	item:setColorGreen(g);
	item:setColorBlue(b);
	item:setColor(Color.new(r, g, b));
	item:setCustomColor(true);
end

SpecialLootSpawns.OnCreatePostcard = function(item)
    if not item then return; end;
    local card = SpecialLootSpawns.Postcards[ZombRand(#SpecialLootSpawns.Postcards)+1]
    local text = getText("IGUI_Photo_" .. card)
    text = getText("IGUI_PostcardFrom", getText(item:getScriptItem():getDisplayName()), text)
	item:setName(text)
    item:getModData().literatureTitle = "IGUI_Postcard_" .. card
    item:getModData().collectibleKey = text
end

SpecialLootSpawns.OnCreateSnowGlobe = function(item)
    if not item then return; end;
    local orb = SpecialLootSpawns.Postcards[ZombRand(#SpecialLootSpawns.Postcards)+1]
    local text = getText("IGUI_Photo_" .. orb)
    text = getText("IGUI_SnowGlobeOf", getText(item:getScriptItem():getDisplayName()), text)
	item:setName(text)
    item:getModData().collectibleKey = text
end

-- RECIPES
SpecialLootSpawns.OnCreateRecipeClipping = function(item)
    if not item then return; end;
	local list = SpecialLootSpawns.FoodRecipes
	local roll = ZombRand(#list)+1
	local recipe = list[roll]
	local recipeName = Translator.getRecipeName(recipe)
	local itemName = getText(item:getDisplayName())
    local recipes = ArrayList.new();
    recipes:add(recipe);
    item:setLearnedRecipes(recipes);
--     item:getModData().learnedRecipe = recipe
    local text = itemName .. ": " .. recipeName
	item:setName(text)
    item:getModData().collectibleKey = text
end

-- Modify a book to teach recipe according to a list, can have multiple leached recipes.
SpecialLootSpawns.CreateSchematic = function(item, list, multipleChance)
    if not item then return; end;
    if multipleChance and ZombRand(100) < multipleChance then
        local nb = ZombRand(2, #list+1);
        -- still limit the number of taught recipes for balance reason
        -- NOTE: looping from 0-5 below may result in 6 recipes.
        if nb > 5 then
            nb = 5;
        end
        local recipes = ArrayList.new();
        for i=0,nb do
            local recipe = list[ZombRand(#list)+1];
            if not recipes:contains(recipe) then
                recipes:add(recipe);
            end
        end
        item:setLearnedRecipes(recipes);
    else
        local roll = ZombRand(#list)+1
        local recipe = list[roll]
        local recipeName = Translator.getRecipeName(recipe)
        local itemName = getText(item:getDisplayName())
        local recipes = ArrayList.new();
        recipes:add(recipe);
        item:setLearnedRecipes(recipes);
--         item:getModData().learnedRecipe = recipe
        local text = itemName .. ": " .. recipeName
        item:setName(text)
        item:getModData().collectibleKey = text
    end
end
SpecialLootSpawns.OnCreateExplosivesSchematic = function(item)
    SpecialLootSpawns.CreateSchematic(item, SpecialLootSpawns.ExplosiveSchematics, 40);
end
SpecialLootSpawns.OnCreateMeleeWeaponSchematic = function(item)
    SpecialLootSpawns.CreateSchematic(item, SpecialLootSpawns.MeleeWeaponSchematics, 30);
end
SpecialLootSpawns.OnCreateBSToolsSchematic = function(item)
    SpecialLootSpawns.CreateSchematic(item, SpecialLootSpawns.BSToolsSchematics, 50);
end
SpecialLootSpawns.OnCreateArmorSchematic = function(item)
    SpecialLootSpawns.CreateSchematic(item, SpecialLootSpawns.ArmorSchematics, 30);
end
SpecialLootSpawns.OnCreateCookwareSchematic = function(item)
    SpecialLootSpawns.CreateSchematic(item, SpecialLootSpawns.CookwareSchematic, 40);
end
SpecialLootSpawns.OnCreateSurvivalSchematic = function(item)
    SpecialLootSpawns.CreateSchematic(item, SpecialLootSpawns.SurvivalSchematics, 40);
end
SpecialLootSpawns.OnCreateSewingPattern = function(item)
    SpecialLootSpawns.CreateSchematic(item, SpecialLootSpawns.SewingPatterns, 0);
end
SpecialLootSpawns.OnCreateRecipeMagazine = function(item)
    item:getModData().literatureTitle = item:getFullType()
end
