require('NPCs/MainCreationMethods');

local function makeTraits()
	--TraitFactory.addTrait("InternalName","Display name",Cost,"Description",IsProfession,RemoveInMP)

	--[[
	local magnetizing = TraitFactory.addTrait("magnetizing", getText("UI_Trait_Magnetizing"), 4, getText("UI_Trait_MagnetizingDesc"), false, false)
	local charming = TraitFactory.addTrait("charming", getText("UI_Trait_Charming"), 3, getText("UI_Trait_CharmingDesc"), false, false)
	local ugly = TraitFactory.addTrait("ugly", getText("UI_Trait_Ugly"), -3, getText("UI_Trait_UglyDesc"), false, false)

	TraitFactory.setMutualExclusive("charming", "ugly")
	]]



end

Events.OnGameBoot.Remove(makeTraits)
Events.OnGameBoot.Add(makeTraits)

