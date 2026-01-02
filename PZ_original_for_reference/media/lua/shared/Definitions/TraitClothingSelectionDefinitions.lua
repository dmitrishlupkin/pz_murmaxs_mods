TraitClothingSelectionDefinitions = TraitClothingSelectionDefinitions or {};

TraitClothingSelectionDefinitions[CharacterTrait.GARDENER] = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Hat_SummerHat", "Base.Hat_SummerFlowerHat", },
		},

		Shirt = {
			chance = 10,
			items = {"Base.Shirt_Denim", },
		},
	},

	Male = {
		Shirt = {
			chance = 10,
			items = {"Base.Shirt_Denim", },
		},
	},
}

TraitClothingSelectionDefinitions[CharacterTrait.FISHING] = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_BucketHatFishing", "Base.Hat_BonnieHat", },
		},

		TorsoExtraVest = {
			chance = 10,
			items = {"Base.Vest_Hunting_Khaki",},
		},
	},
}

TraitClothingSelectionDefinitions[CharacterTrait.HIKER] = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_BonnieHat", },
		},
	},
}

TraitClothingSelectionDefinitions[CharacterTrait.HUNTER] = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_BaseballCapArmy", "Base.Hat_BaseballCap_HuntingCamo", "Base.Hat_BonnieHat_CamoGreen", },
		},

		Eyes = {
			chance = 10,
			items = {"Base.Glasses_Shooting", },
		},

		TorsoExtraVest = {
			chance = 10,
			items = {"Base.Vest_Hunting_Grey", "Base.Vest_Hunting_Orange", "Base.Vest_Hunting_Camo", "Base.Vest_Hunting_CamoGreen",},
		},

		Shirt = {
			chance = 10,
			items = {"Base.Shirt_CamoGreen", "Base.Tshirt_LongSleeve_HuntingCamo"},
		},

		Tshirt = {
			chance = 10,
			items = {"Base.Tshirt_CamoGreen", "Base.Tshirt_HuntingCamo"},
		},

		Pants = {
			chance = 10,
			items = {"Base.Shorts_CamoGreenLong", },
		},
	},
}

TraitClothingSelectionDefinitions[CharacterTrait.WILDERNESS_KNOWLEDGE] = TraitClothingSelectionDefinitions[CharacterTrait.HUNTER]

TraitClothingSelectionDefinitions[CharacterTrait.MECHANICS] = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_Bandana", },
		},
	},
}

TraitClothingSelectionDefinitions[CharacterTrait.OUTDOORSMAN] = {
	Female = {
		Hat = {
			chance = 10,
			items = {"Base.Hat_BonnieHat", },
		},
	},
}

TraitClothingSelectionDefinitions[CharacterTrait.SHORT_SIGHTED] = {
	Female = {
		Eyes = {
            chance = 100,
	        items = {"Base.Glasses_Normal", "Base.Glasses_Normal_HornRimmed", "Base.Glasses_CatsEye"},
		},
	},
	Male = {
		Eyes = {
			chance = 100,
			items = {"Base.Glasses_Normal", "Base.Glasses_Normal_HornRimmed" },
		},
	},
}
