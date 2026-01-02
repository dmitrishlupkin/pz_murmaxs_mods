-- Locations must be declared in render-order.
-- Location IDs must match BodyLocation= and CanBeEquipped= values in items.txt.
local group = BodyLocations.getGroup("Human")

group:getOrCreateLocation(ItemBodyLocation.BANDAGE)
group:getOrCreateLocation(ItemBodyLocation.WOUND)
group:getOrCreateLocation(ItemBodyLocation.BELT_EXTRA) -- used for holster, empty texture items
group:getOrCreateLocation(ItemBodyLocation.BELT) -- empty texture items used for belt/utility belt
group:getOrCreateLocation(ItemBodyLocation.BELLY_BUTTON)
group:getOrCreateLocation(ItemBodyLocation.MAKE_UP_FULL_FACE)
group:getOrCreateLocation(ItemBodyLocation.MAKE_UP_EYES)
group:getOrCreateLocation(ItemBodyLocation.MAKE_UP_EYES_SHADOW)
group:getOrCreateLocation(ItemBodyLocation.MAKE_UP_LIPS)
group:getOrCreateLocation(ItemBodyLocation.MASK)
group:getOrCreateLocation(ItemBodyLocation.MASK_EYES)-- Masks that cover eyes, so shouldn't show glasses (Gasmask)
group:getOrCreateLocation(ItemBodyLocation.MASK_FULL)-- covers face fully (welders mask)
group:getOrCreateLocation(ItemBodyLocation.UNDERWEAR_BOTTOM)
group:getOrCreateLocation(ItemBodyLocation.UNDERWEAR_TOP)
group:getOrCreateLocation(ItemBodyLocation.UNDERWEAR)-- moved above 'top' and 'bottom' underwear
group:getOrCreateLocation(ItemBodyLocation.UNDERWEAR_EXTRA1)
group:getOrCreateLocation(ItemBodyLocation.UNDERWEAR_EXTRA2)
group:getOrCreateLocation(ItemBodyLocation.HAT)
group:getOrCreateLocation(ItemBodyLocation.FULL_HAT) -- NBC Mask.. Should unequip everything head related (masks, glasses..)
group:getOrCreateLocation(ItemBodyLocation.EARS) --mainly earrings
group:getOrCreateLocation(ItemBodyLocation.EAR_TOP) --earring at top of ear
group:getOrCreateLocation(ItemBodyLocation.NOSE) --Nosestud, nosering
group:getOrCreateLocation(ItemBodyLocation.TORSO1) -- Longjohns top
group:getOrCreateLocation(ItemBodyLocation.TORSO1LEGS1) -- Longjohns (top + bottom)
group:getOrCreateLocation(ItemBodyLocation.TANK_TOP) -- TankTop (goes under tshirt or shirt)
group:getOrCreateLocation(ItemBodyLocation.TSHIRT) -- TShirt/Vest (goes under shirt)
group:getOrCreateLocation(ItemBodyLocation.SHORT_SLEEVE_SHIRT) -- ShortSleeveShirt So watches can be worn with short sleeve Shirts
group:getOrCreateLocation(ItemBodyLocation.LEFT_WRIST) --Watches and Bracelets
group:getOrCreateLocation(ItemBodyLocation.RIGHT_WRIST) --Watches and Bracelets
group:getOrCreateLocation(ItemBodyLocation.SHIRT) -- Shirt
group:getOrCreateLocation(ItemBodyLocation.RIGHT_ARM) --chainmail sleeve
group:getOrCreateLocation(ItemBodyLocation.LEFT_ARM) --chainmail sleeve
group:getOrCreateLocation(ItemBodyLocation.NECK)-- neck model
group:getOrCreateLocation(ItemBodyLocation.NECK_TEXTURE)-- Neck-tie needs to be above any shirt
group:getOrCreateLocation(ItemBodyLocation.NECKLACE) --Necklace, Necklace_Stone
group:getOrCreateLocation(ItemBodyLocation.NECKLACE_LONG) -- Longer Necklaces, NecklaceLong
group:getOrCreateLocation(ItemBodyLocation.RIGHT_MIDDLE_FINGER)
group:getOrCreateLocation(ItemBodyLocation.LEFT_MIDDLE_FINGER)
group:getOrCreateLocation(ItemBodyLocation.LEFT_RING_FINGER)
group:getOrCreateLocation(ItemBodyLocation.RIGHT_RING_FINGER)
group:getOrCreateLocation(ItemBodyLocation.HANDS)
group:getOrCreateLocation(ItemBodyLocation.HANDS_LEFT)
group:getOrCreateLocation(ItemBodyLocation.HANDS_RIGHT)
group:getOrCreateLocation(ItemBodyLocation.CALF_LEFT_TEXTURE) --shinpad textures
group:getOrCreateLocation(ItemBodyLocation.CALF_RIGHT_TEXTURE) --shinpad textures
group:getOrCreateLocation(ItemBodyLocation.SOCKS)
group:getOrCreateLocation(ItemBodyLocation.LEGS1) -- Longjohns bottom and skinny trousers
group:getOrCreateLocation(ItemBodyLocation.SHOES)
group:getOrCreateLocation(ItemBodyLocation.CODPIECE)
group:getOrCreateLocation(ItemBodyLocation.SHORTS_SHORT) -- short shorts
group:getOrCreateLocation(ItemBodyLocation.SHORT_PANTS) --  long shorts,
group:getOrCreateLocation(ItemBodyLocation.PANTS_SKINNY) -- Skinny Pants
group:getOrCreateLocation(ItemBodyLocation.GAITER_RIGHT) -- Gaiter right texture
group:getOrCreateLocation(ItemBodyLocation.GAITER_LEFT) -- Gaiter left texture
group:getOrCreateLocation(ItemBodyLocation.PANTS) -- Pants
group:getOrCreateLocation(ItemBodyLocation.SKIRT) -- Skirt
group:getOrCreateLocation(ItemBodyLocation.DRESS) -- Dress (top + skirt) / Robe
group:getOrCreateLocation(ItemBodyLocation.LEGS5) -- Unused
group:getOrCreateLocation(ItemBodyLocation.FORE_ARM_LEFT) -- Left Vambraces
group:getOrCreateLocation(ItemBodyLocation.FORE_ARM_RIGHT) -- Right Vambraces
group:getOrCreateLocation(ItemBodyLocation.LONG_SKIRT) -- Skirt
group:getOrCreateLocation(ItemBodyLocation.LONG_DRESS) -- Dress (top + skirt) / Robe
group:getOrCreateLocation(ItemBodyLocation.VEST_TEXTURE) --waistcoats texture
group:getOrCreateLocation(ItemBodyLocation.BODY_COSTUME) -- Body Costume like spiffo suit or wedding dress
group:getOrCreateLocation(ItemBodyLocation.SPORT_SHOULDERPAD) --Football shoulderpads
group:getOrCreateLocation(ItemBodyLocation.GORGET) --Gorget
group:getOrCreateLocation(ItemBodyLocation.JERSEY) --Football Jersey
group:getOrCreateLocation(ItemBodyLocation.SWEATER) -- Sweater
group:getOrCreateLocation(ItemBodyLocation.SWEATER_HAT) -- Hoodie UP
group:getOrCreateLocation(ItemBodyLocation.PANTS_EXTRA) -- Dungarees
group:getOrCreateLocation(ItemBodyLocation.JACKET) -- Jacket
group:getOrCreateLocation(ItemBodyLocation.JACKET_DOWN) -- Poncho hood down
group:getOrCreateLocation(ItemBodyLocation.JACKET_BULKY) --SuitJacket, Padded Jacket hood down, wedding suit
group:getOrCreateLocation(ItemBodyLocation.JACKET_HAT) --  Poncho UP (can't wear hat with them)
group:getOrCreateLocation(ItemBodyLocation.JACKET_HAT_BULKY) --Padded jacket (hood up)(can't wear hat with them)
group:getOrCreateLocation(ItemBodyLocation.JACKET_SUIT) --Formal jackets (Jacket Suit and Wedding Jacket)
group:getOrCreateLocation(ItemBodyLocation.FULL_SUIT) -- Diverse full suit, head gear still can be wear with it (Spiffo suit and wedding dress)
group:getOrCreateLocation(ItemBodyLocation.BOILERSUIT) -- Coveralls
group:getOrCreateLocation(ItemBodyLocation.FULL_SUIT_HEAD) -- Cover everything (hazmat)
group:getOrCreateLocation(ItemBodyLocation.FULL_SUIT_HEAD_SCBA) -- Cover everything (hazmat)
group:getOrCreateLocation(ItemBodyLocation.KNEE_LEFT) -- Left Knee
group:getOrCreateLocation(ItemBodyLocation.KNEE_RIGHT) -- Right Knee
group:getOrCreateLocation(ItemBodyLocation.CALF_LEFT) -- Left Greaves
group:getOrCreateLocation(ItemBodyLocation.CALF_RIGHT) -- Right Greaves
group:getOrCreateLocation(ItemBodyLocation.THIGH_LEFT) --Left Thigh armour
group:getOrCreateLocation(ItemBodyLocation.THIGH_RIGHT) --Right Thigh armour
group:getOrCreateLocation(ItemBodyLocation.SPORT_SHOULDERPAD_ON_TOP) --Football shoulderpads on top of other clothes
group:getOrCreateLocation(ItemBodyLocation.SHOULDERPAD_RIGHT) --Right only shoulderpad
group:getOrCreateLocation(ItemBodyLocation.SHOULDERPAD_LEFT) --Left only shoulderpad
group:getOrCreateLocation(ItemBodyLocation.ELBOW_LEFT) --Left elbow pads
group:getOrCreateLocation(ItemBodyLocation.ELBOW_RIGHT) --Right elbow pads
group:getOrCreateLocation(ItemBodyLocation.FULL_TOP) -- unequip all top item (except tshirt/vest) (including hat/mask, for ghillie_top for example)
group:getOrCreateLocation(ItemBodyLocation.BATH_ROBE) -- Need to avoid having coat/any textured models on top of it
group:getOrCreateLocation(ItemBodyLocation.FANNY_PACK_FRONT)
group:getOrCreateLocation(ItemBodyLocation.FANNY_PACK_BACK)
group:getOrCreateLocation(ItemBodyLocation.WEBBING)
group:getOrCreateLocation(ItemBodyLocation.SCBA)
group:getOrCreateLocation(ItemBodyLocation.SCBANOTANK)
group:getOrCreateLocation(ItemBodyLocation.AMMO_STRAP)
group:getOrCreateLocation(ItemBodyLocation.SATCHEL)
group:getOrCreateLocation(ItemBodyLocation.SHOULDER_HOLSTER)
group:getOrCreateLocation(ItemBodyLocation.ANKLE_HOLSTER)
group:getOrCreateLocation(ItemBodyLocation.TORSO_EXTRA)
group:getOrCreateLocation(ItemBodyLocation.TORSO_EXTRA_VEST)
group:getOrCreateLocation(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:getOrCreateLocation(ItemBodyLocation.CUIRASS)
group:getOrCreateLocation(ItemBodyLocation.TAIL)
group:getOrCreateLocation(ItemBodyLocation.FULL_ROBE)
group:getOrCreateLocation(ItemBodyLocation.BACK)
group:getOrCreateLocation(ItemBodyLocation.LEFT_EYE) --currently for eyepatch left
group:getOrCreateLocation(ItemBodyLocation.RIGHT_EYE) --currently for eyepatch right
group:getOrCreateLocation(ItemBodyLocation.EYES) -- need to be on top because of special UV
group:getOrCreateLocation(ItemBodyLocation.SCARF) -- need to be on top of everything!
group:getOrCreateLocation(ItemBodyLocation.ZED_DMG)

-- can't wear glasses with a mask that cover eyes
group:setExclusive(ItemBodyLocation.MASK_EYES, ItemBodyLocation.EYES)
group:setExclusive(ItemBodyLocation.MASK_EYES, ItemBodyLocation.LEFT_EYE)
group:setExclusive(ItemBodyLocation.MASK_EYES, ItemBodyLocation.RIGHT_EYE)
group:setExclusive(ItemBodyLocation.MASK_FULL, ItemBodyLocation.EYES)
group:setExclusive(ItemBodyLocation.MASK_FULL, ItemBodyLocation.LEFT_EYE)
group:setExclusive(ItemBodyLocation.MASK_FULL,  ItemBodyLocation.RIGHT_EYE)

-- Can't wear hat, mask or earrings with a full hat 
group:setExclusive(ItemBodyLocation.FULL_HAT, ItemBodyLocation.HAT)
group:setExclusive(ItemBodyLocation.FULL_HAT, ItemBodyLocation.MASK)
group:setExclusive(ItemBodyLocation.FULL_HAT, ItemBodyLocation.MASK_EYES)
group:setExclusive(ItemBodyLocation.FULL_HAT, ItemBodyLocation.MASK_FULL)
group:setExclusive(ItemBodyLocation.FULL_HAT, ItemBodyLocation.RIGHT_EYE)
group:setExclusive(ItemBodyLocation.FULL_HAT, ItemBodyLocation.LEFT_EYE)
group:setExclusive(ItemBodyLocation.FULL_HAT, ItemBodyLocation.EYES)

-- Can't wear hat, mask or earrings with SCBA
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.FULL_HAT)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.MASK)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.MASK_EYES)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.MASK_FULL)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.RIGHT_EYE)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.LEFT_EYE)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.EYES)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.FULL_HAT)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.MASK)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.MASK_EYES)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.MASK_FULL)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.RIGHT_EYE)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.LEFT_EYE)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.EYES)

group:setExclusive(ItemBodyLocation.LEFT_EYE, ItemBodyLocation.RIGHT_EYE)

-- Can't wear skirt and pants.
group:setExclusive(ItemBodyLocation.SKIRT, ItemBodyLocation.PANTS)
group:setExclusive(ItemBodyLocation.SKIRT, ItemBodyLocation.PANTS_EXTRA)
group:setExclusive(ItemBodyLocation.SKIRT, ItemBodyLocation.SHORT_PANTS)
group:setExclusive(ItemBodyLocation.SKIRT, ItemBodyLocation.SHORTS_SHORT)
group:setExclusive(ItemBodyLocation.SKIRT, ItemBodyLocation.LEGS5)
group:setExclusive(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.PANTS)
group:setExclusive(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.PANTS_EXTRA)
group:setExclusive(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.SHORT_PANTS)
group:setExclusive(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.SHORTS_SHORT)
group:setExclusive(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.LEGS5)
group:setExclusive(ItemBodyLocation.SKIRT, ItemBodyLocation.PANTS_SKINNY)

--Can't wear Skirt and Dresses together
group:setExclusive(ItemBodyLocation.SKIRT, ItemBodyLocation.DRESS)
group:setExclusive(ItemBodyLocation.SKIRT, ItemBodyLocation.LONG_DRESS)
group:setExclusive(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.DRESS)
group:setExclusive(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.LONG_DRESS)

-- Multi-item (for example: longjohns) takes two slots.
group:setExclusive(ItemBodyLocation.TORSO1LEGS1, ItemBodyLocation.TORSO1)
group:setExclusive(ItemBodyLocation.TORSO1LEGS1, ItemBodyLocation.LEGS1)

-- Multi-item (for example: a dress) takes two slots.
group:setExclusive(ItemBodyLocation.DRESS, ItemBodyLocation.SHIRT)
group:setExclusive(ItemBodyLocation.DRESS, ItemBodyLocation.SHORT_SLEEVE_SHIRT)
group:setExclusive(ItemBodyLocation.DRESS, ItemBodyLocation.PANTS)
group:setExclusive(ItemBodyLocation.DRESS, ItemBodyLocation.PANTS_SKINNY)
group:setExclusive(ItemBodyLocation.DRESS, ItemBodyLocation.PANTS_EXTRA)
group:setExclusive(ItemBodyLocation.DRESS, ItemBodyLocation.SHORT_PANTS)
group:setExclusive(ItemBodyLocation.DRESS, ItemBodyLocation.SHORTS_SHORT)
group:setExclusive(ItemBodyLocation.DRESS, ItemBodyLocation.SKIRT)
group:setExclusive(ItemBodyLocation.DRESS, ItemBodyLocation.LONG_SKIRT)
group:setExclusive(ItemBodyLocation.DRESS, ItemBodyLocation.FULL_TOP)
group:setExclusive(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.SHIRT)
group:setExclusive(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.SHORT_SLEEVE_SHIRT)
group:setExclusive(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.PANTS)
group:setExclusive(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.PANTS_SKINNY)
group:setExclusive(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.PANTS_EXTRA)
group:setExclusive(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.SHORT_PANTS)
group:setExclusive(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.SHORTS_SHORT)
group:setExclusive(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.SKIRT)
group:setExclusive(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.FULL_TOP)

-- Hazmat, can't be wear with anything (apart shirt/tshirt as they don't have models)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.SWEATER)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.HANDS)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.SWEATER_HAT)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.JERSEY)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.JACKET)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.JACKET_DOWN)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.JACKET_HAT)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.JACKET_BULKY)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.JACKET_HAT_BULKY)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.DRESS)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.LONG_DRESS)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.PANTS)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.PANTS_SKINNY)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.PANTS_EXTRA)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.SHORT_PANTS)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.SHORTS_SHORT)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.SKIRT)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.LONG_SKIRT)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.BATH_ROBE)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.FULL_ROBE)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.HAT)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.FULL_HAT);
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.EYES);
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.MASK)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.MASK_EYES)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.MASK_FULL)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.NECK)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.FULL_TOP)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.BODY_COSTUME)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.WEBBING)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.SCBA)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.SCBANOTANK)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.SHOULDER_HOLSTER)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.ANKLE_HOLSTER)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.BACK)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.SCARF)


-- Spiffo Suit and Wedding Dress. Can't wear with anything apart from head
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SWEATER)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SWEATER_HAT)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.JERSEY)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.JACKET)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.JACKET_DOWN)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.JACKET_SUIT)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.JACKET_HAT)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.JACKET_BULKY)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.JACKET_HAT_BULKY)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.DRESS)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.LONG_DRESS)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.PANTS)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.PANTS_SKINNY)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.PANTS_EXTRA)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SHORT_PANTS)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SHORTS_SHORT)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SKIRT)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.LONG_SKIRT)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.BATH_ROBE)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.FULL_ROBE)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.TORSO_EXTRA_VEST)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.CUIRASS)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.FULL_SUIT_HEAD)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.FULL_TOP)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.BODY_COSTUME)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.BOILERSUIT)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.WEBBING)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SCBA)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SCBANOTANK)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SHOULDER_HOLSTER)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.ANKLE_HOLSTER)


group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.SWEATER)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.SWEATER_HAT)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.JERSEY)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.JACKET)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.JACKET_DOWN)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.JACKET_SUIT)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.JACKET_HAT)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.JACKET_BULKY)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.JACKET_HAT_BULKY)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.NECK)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.DRESS)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.LONG_DRESS)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.BATH_ROBE)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.FULL_ROBE)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.HAT)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.FULL_HAT);
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.EYES);
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.MASK)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.NECK)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.TORSO_EXTRA_VEST)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.CUIRASS)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.BOILERSUIT)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.WEBBING)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.SCBA)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.SCBANOTANK)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.SHOULDER_HOLSTER)


-- Boilersuit (Coveralls) Can't wear with anything apart from head, and Bullet, hunting and high viz vests.
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.SWEATER)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.SWEATER_HAT)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.JERSEY)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.JACKET)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.JACKET_DOWN)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.JACKET_SUIT)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.JACKET_HAT)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.JACKET_BULKY)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.JACKET_HAT_BULKY)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.DRESS)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.LONG_DRESS)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.PANTS)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.PANTS_SKINNY)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.PANTS_EXTRA)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.SHORT_PANTS)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.SHORTS_SHORT)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.SKIRT)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.LONG_SKIRT)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.BATH_ROBE)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.FULL_SUIT_HEAD)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.FULL_TOP)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.BODY_COSTUME)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.FULL_SUIT)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.FULL_TOP)


-- apart from tanktop/tshirt/longjohns, you shouldn't add stuff on top of your bathrobe to avoid clipping
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.SWEATER)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.SWEATER_HAT)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.JERSEY)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.JACKET)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.JACKET_DOWN)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.JACKET_SUIT)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.JACKET_HAT)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.JACKET_BULKY)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.JACKET_HAT_BULKY)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.PANTS_EXTRA)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.TORSO_EXTRA_VEST)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.CUIRASS)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.BOILERSUIT)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.WEBBING)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.SCBA)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.SCBANOTANK)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.PANTS_EXTRA)


-- apart from tanktop/tshirt/longjohns, you shouldn't add stuff on top of your FullRobe to avoid clipping
group:setExclusive(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.SWEATER)
group:setExclusive(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.SWEATER_HAT)
group:setExclusive(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.JERSEY)
group:setExclusive(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.JACKET)
group:setExclusive(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.JACKET_DOWN)
group:setExclusive(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.JACKET_SUIT)
group:setExclusive(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.JACKET_HAT)
group:setExclusive(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.JACKET_BULKY)
group:setExclusive(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.JACKET_HAT_BULKY)
group:setExclusive(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.SCBA)
group:setExclusive(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.SCBANOTANK)


group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.SWEATER)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.SWEATER_HAT)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.TORSO_EXTRA_VEST)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.CUIRASS)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.BOILERSUIT)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.DRESS)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.LONG_DRESS)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.PANTS)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.PANTS_SKINNY)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.PANTS_EXTRA)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.SHORT_PANTS)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.SHORTS_SHORT)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.FULL_TOP)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.BATH_ROBE)
group:setExclusive(ItemBodyLocation.BODY_COSTUME, ItemBodyLocation.FULL_ROBE)


-- can't wear hats with padded jacket

group:setExclusive(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.HAT)
group:setExclusive(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.HAT)
group:setExclusive(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.FULL_HAT)
group:setExclusive(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.FULL_HAT)
group:setExclusive(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.JACKET)
group:setExclusive(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.JACKET_DOWN)
group:setExclusive(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.JACKET)

--can't wear these with sport shoulderpads (when pads worn under jersey)
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.JACKET, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.SWEATER, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.TORSO_EXTRA, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.TORSO_EXTRA_VEST, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.CUIRASS, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.SHOULDER_HOLSTER, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.SPORT_SHOULDERPAD_ON_TOP, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.WEBBING, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.BACK, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.SHOULDERPAD_RIGHT, ItemBodyLocation.SPORT_SHOULDERPAD)
group:setExclusive(ItemBodyLocation.SHOULDERPAD_LEFT, ItemBodyLocation.SPORT_SHOULDERPAD)


--can't wear these with sport shoulderpads on top
group:setExclusive(ItemBodyLocation.TORSO_EXTRA_VEST, ItemBodyLocation.SPORT_SHOULDERPAD_ON_TOP)
group:setExclusive(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET, ItemBodyLocation.SPORT_SHOULDERPAD_ON_TOP)
group:setExclusive(ItemBodyLocation.SHOULDER_HOLSTER, ItemBodyLocation.SPORT_SHOULDERPAD_ON_TOP)
group:setExclusive(ItemBodyLocation.WEBBING, ItemBodyLocation.SPORT_SHOULDERPAD_ON_TOP)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.SPORT_SHOULDERPAD_ON_TOP)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.SPORT_SHOULDERPAD_ON_TOP)
group:setExclusive(ItemBodyLocation.BACK, ItemBodyLocation.SPORT_SHOULDERPAD_ON_TOP)
group:setExclusive(ItemBodyLocation.SHOULDERPAD_RIGHT,ItemBodyLocation.SPORT_SHOULDERPAD_ON_TOP)
group:setExclusive(ItemBodyLocation.SHOULDERPAD_LEFT,ItemBodyLocation.SPORT_SHOULDERPAD_ON_TOP)

--can't wear these with single shoulderpad right
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setExclusive(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setExclusive(ItemBodyLocation.SHOULDER_HOLSTER, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setExclusive(ItemBodyLocation.WEBBING, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setExclusive(ItemBodyLocation.BACK, ItemBodyLocation.SHOULDERPAD_RIGHT)

--can't wear these with single shoulderpad left
group:setExclusive(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setExclusive(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setExclusive(ItemBodyLocation.FULL_TOP, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setExclusive(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setExclusive(ItemBodyLocation.SHOULDER_HOLSTER, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setExclusive(ItemBodyLocation.WEBBING, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setExclusive(ItemBodyLocation.BACK, ItemBodyLocation.SHOULDERPAD_LEFT)

-- can't wear hats with hoodieup
group:setExclusive(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.HAT)
group:setExclusive(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.FULL_HAT)
group:setExclusive(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.SWEATER)


-- can't wear maskfull with a hats, maskeyes or masks
group:setExclusive(ItemBodyLocation.MASK_FULL, ItemBodyLocation.HAT)
group:setExclusive(ItemBodyLocation.MASK_FULL, ItemBodyLocation.MASK_EYES)
group:setExclusive(ItemBodyLocation.MASK_FULL, ItemBodyLocation.MASK)
-- can't wear mask and other masks 
group:setExclusive(ItemBodyLocation.MASK, ItemBodyLocation.MASK_EYES)
group:setExclusive(ItemBodyLocation.MASK, ItemBodyLocation.MASK_FULL)

--can't wear TorsoExtra with TorsoExtraVests
group:setExclusive(ItemBodyLocation.TORSO_EXTRA_VEST, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.TORSO_EXTRA, ItemBodyLocation.TORSO_EXTRA_VEST)
group:setExclusive(ItemBodyLocation.TORSO_EXTRA, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setExclusive(ItemBodyLocation.TORSO_EXTRA_VEST, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setExclusive(ItemBodyLocation.SHOULDER_HOLSTER, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setExclusive(ItemBodyLocation.CUIRASS, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.CUIRASS, ItemBodyLocation.TORSO_EXTRA_VEST)
group:setExclusive(ItemBodyLocation.CUIRASS, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setExclusive(ItemBodyLocation.CUIRASS, ItemBodyLocation.SHOULDER_HOLSTER)


-- can't wear Jackets and Jacket_Hats with Jacket_Bulky or ItemBodyLocation.JACKET_HAT_BULKY or JacketSuits or sweaters
group:setExclusive(ItemBodyLocation.JACKET, ItemBodyLocation.JACKET_HAT)
group:setExclusive(ItemBodyLocation.JACKET, ItemBodyLocation.JACKET_DOWN)
group:setExclusive(ItemBodyLocation.JACKET, ItemBodyLocation.JACKET_HAT_BULKY)
group:setExclusive(ItemBodyLocation.JACKET, ItemBodyLocation.JACKET_BULKY)
group:setExclusive(ItemBodyLocation.JACKET, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.JACKET_BULKY)
group:setExclusive(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.JACKET_HAT_BULKY)
group:setExclusive(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.SWEATER)
group:setExclusive(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.SWEATER_HAT)
group:setExclusive(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.JACKET_BULKY)
group:setExclusive(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.JACKET_HAT_BULKY)
group:setExclusive(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.JACKET_HAT_BULKY)
group:setExclusive(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.SWEATER)
group:setExclusive(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.SWEATER_HAT)
group:setExclusive(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.JACKET)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.JACKET_DOWN)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.JACKET_BULKY)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.JACKET_HAT)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.JACKET_HAT_BULKY)


--can't wear Jacket Suits with Sweaters, Sweater Hats or TorsoExtraVests or Cuirass
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.SWEATER)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.SWEATER_HAT)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.TORSO_EXTRA_VEST)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.WEBBING)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.SCBA)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.SCBANOTANK)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.CUIRASS)
group:setExclusive(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.PANTS_EXTRA)

--can't wear Jacket_Bulky or ItemBodyLocation.JACKET_HAT_BULKY with TorsoExtra or TorsoExtraVests or webbing or Cuirass
group:setExclusive(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.TORSO_EXTRA)
group:setExclusive(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.TORSO_EXTRA_VEST)
group:setExclusive(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.TORSO_EXTRA_VEST)
group:setExclusive(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setExclusive(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setExclusive(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.WEBBING)
group:setExclusive(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.WEBBING)
group:setExclusive(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.SCBA)
group:setExclusive(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.SCBA)
group:setExclusive(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.SCBANOTANK)
group:setExclusive(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.SCBANOTANK)
group:setExclusive(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.CUIRASS)
group:setExclusive(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.CUIRASS)

-- webbing can't be worn with fanny packs (+ it's better)
group:setExclusive(ItemBodyLocation.FANNY_PACK_BACK, ItemBodyLocation.WEBBING)
group:setExclusive(ItemBodyLocation.FANNY_PACK_FRONT, ItemBodyLocation.WEBBING)
-- they're really the same body location, holster and webbing, but for hiding the model they need to be different
group:setExclusive(ItemBodyLocation.SHOULDER_HOLSTER, ItemBodyLocation.WEBBING)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.WEBBING)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.WEBBING)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.SHOULDER_HOLSTER)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.SHOULDER_HOLSTER)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.BACK)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.SCBA)
group:setExclusive(ItemBodyLocation.SCBA, ItemBodyLocation.CUIRASS)
group:setExclusive(ItemBodyLocation.SCBANOTANK, ItemBodyLocation.CUIRASS)

-- can't wear pants or skinny pants with short pants and pantsextra etc
group:setExclusive(ItemBodyLocation.PANTS, ItemBodyLocation.SHORT_PANTS)
group:setExclusive(ItemBodyLocation.PANTS_SKINNY, ItemBodyLocation.SHORT_PANTS)
group:setExclusive(ItemBodyLocation.PANTS, ItemBodyLocation.SHORTS_SHORT)
group:setExclusive(ItemBodyLocation.PANTS_SKINNY, ItemBodyLocation.SHORTS_SHORT)
group:setExclusive(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.PANTS)
group:setExclusive(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.PANTS_SKINNY)
group:setExclusive(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.SHORT_PANTS)
group:setExclusive(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.SHORTS_SHORT)
group:setExclusive(ItemBodyLocation.DRESS, ItemBodyLocation.LONG_DRESS)
group:setExclusive(ItemBodyLocation.SKIRT, ItemBodyLocation.LONG_SKIRT)
group:setExclusive(ItemBodyLocation.SHORT_PANTS, ItemBodyLocation.SHORTS_SHORT)
group:setExclusive(ItemBodyLocation.PANTS, ItemBodyLocation.PANTS_SKINNY)

-- can't wear PantsExtra with Sweater or SweaterHat
group:setExclusive(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.SWEATER)
group:setExclusive(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.SWEATER_HAT)

-- shin and knee armor
group:setExclusive(ItemBodyLocation.CALF_LEFT, ItemBodyLocation.CALF_LEFT_TEXTURE)
group:setExclusive(ItemBodyLocation.CALF_RIGHT, ItemBodyLocation.CALF_RIGHT_TEXTURE)
group:setExclusive(ItemBodyLocation.KNEE_LEFT, ItemBodyLocation.CALF_LEFT_TEXTURE)
group:setExclusive(ItemBodyLocation.KNEE_RIGHT, ItemBodyLocation.CALF_RIGHT_TEXTURE)
group:setExclusive(ItemBodyLocation.KNEE_LEFT, ItemBodyLocation.CALF_LEFT)
group:setExclusive(ItemBodyLocation.KNEE_RIGHT, ItemBodyLocation.CALF_RIGHT)

-- vambraces, can't wear vambraces and wrist watches or jewellery
group:setExclusive(ItemBodyLocation.FORE_ARM_LEFT,ItemBodyLocation.LEFT_WRIST)
group:setExclusive(ItemBodyLocation.FORE_ARM_RIGHT, ItemBodyLocation.RIGHT_WRIST)
-- Chainmail sleeves and single gloves aren't compatible with gloves
-- group:setExclusive(ItemBodyLocation.RIGHT_ARM, ItemBodyLocation.HANDS)
-- group:setExclusive(ItemBodyLocation.LEFT_ARM, ItemBodyLocation.HANDS)
-- group:setExclusive(ItemBodyLocation.HANDS_LEFT,ItemBodyLocation.HANDS)
-- group:setExclusive(ItemBodyLocation.HANDS_RIGHT, ItemBodyLocation.HANDS)
-- Chainmail sleeves and single gloves aren't compatible with  each other
group:setExclusive(ItemBodyLocation.HANDS_LEFT, ItemBodyLocation.LEFT_ARM)
group:setExclusive(ItemBodyLocation.HANDS_RIGHT, ItemBodyLocation.RIGHT_ARM)

--can't wear neck textures with neck models (2d and 3d ties)
group:setExclusive(ItemBodyLocation.NECK, ItemBodyLocation.NECK_TEXTURE)

-- Hide items in the second location when an item is in the first location.
-- The item will still be hidden if there is a hole in the outer item.
group:setHideModel(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.RIGHT_WRIST)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.RIGHT_WRIST)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.RIGHT_WRIST)
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.RIGHT_WRIST)
group:setHideModel(ItemBodyLocation.FULL_TOP, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.FULL_TOP, ItemBodyLocation.RIGHT_WRIST)
group:setHideModel(ItemBodyLocation.JACKET, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.JACKET, ItemBodyLocation.RIGHT_WRIST)
group:setHideModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.RIGHT_WRIST)
group:setHideModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.RIGHT_WRIST)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.RIGHT_WRIST)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.EARS)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.EAR_TOP)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.EARS)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.EAR_TOP)
group:setHideModel(ItemBodyLocation.SHIRT, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.SHIRT, ItemBodyLocation.RIGHT_WRIST)
group:setHideModel(ItemBodyLocation.SWEATER, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.SWEATER, ItemBodyLocation.RIGHT_WRIST)
group:setHideModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.RIGHT_WRIST)
group:setHideModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.EARS)
group:setHideModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.EAR_TOP)
group:setHideModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.LEFT_WRIST)
group:setHideModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.RIGHT_WRIST)
--hiding fanny pack front
group:setHideModel(ItemBodyLocation.JACKET, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA_VEST, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.CUIRASS, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.FULL_TOP, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.SWEATER, ItemBodyLocation.FANNY_PACK_FRONT)
group:setHideModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.FANNY_PACK_FRONT)
--hiding fanny pack back
group:setHideModel(ItemBodyLocation.JACKET, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA_VEST, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.CUIRASS, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.SWEATER, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.FANNY_PACK_BACK)
group:setHideModel(ItemBodyLocation.FULL_TOP, ItemBodyLocation.FANNY_PACK_BACK)

--hiding Necklace and Necklace_Long under these clothes
group:setHideModel(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.FULL_TOP, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.FULL_TOP, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.JACKET, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.JACKET, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.SWEATER, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.SWEATER, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.CUIRASS, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.CUIRASS, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA_VEST, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA_VEST, ItemBodyLocation.NECKLACE_LONG)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA, ItemBodyLocation.NECKLACE)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA, ItemBodyLocation.NECKLACE_LONG)

--hide neck models (ties) under these
group:setHideModel(ItemBodyLocation.SWEATER,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.SWEATER_HAT,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.JERSEY,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.JACKET,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.JACKET_DOWN,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.JACKET_HAT,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.JACKET_BULKY,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.BATH_ROBE,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.FULL_ROBE,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.FULL_TOP,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.BODY_COSTUME,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.SCBA,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.SCBANOTANK,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.SCARF,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA_VEST,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.BOILERSUIT,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.PANTS_EXTRA,ItemBodyLocation.NECK)
--group:setHideModel(ItemBodyLocation.JACKET_SUIT,ItemBodyLocation.NECK) --so 3d model Ties can be seen with suits
group:setHideModel(ItemBodyLocation.FULL_SUIT,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD,ItemBodyLocation.NECK)
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD_SCBA,ItemBodyLocation.NECK)


-- hiding shoulderholster
-- use the same attachment name as the body location so the holster and any holstered weapon is hidden as appropriate
group:setHideModel(ItemBodyLocation.JACKET, ItemBodyLocation.SHOULDER_HOLSTER)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.SHOULDER_HOLSTER)
group:setHideModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.SHOULDER_HOLSTER)
group:setHideModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.SHOULDER_HOLSTER)
-- group:setHideModel(ItemBodyLocation.TORSO_EXTRA, ItemBodyLocation.SHOULDER_HOLSTER)
group:setHideModel(ItemBodyLocation.TORSO_EXTRA_VEST, ItemBodyLocation.SHOULDER_HOLSTER)
group:setHideModel(ItemBodyLocation.BATH_ROBE,ItemBodyLocation.SHOULDER_HOLSTER)
group:setHideModel(ItemBodyLocation.FULL_ROBE,ItemBodyLocation.SHOULDER_HOLSTER)
-- group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SHOULDER_HOLSTER) -- shouldn't be worn with a shoulder holster inside as it's a hazmat suit
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.SHOULDER_HOLSTER)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY,ItemBodyLocation.SHOULDER_HOLSTER)
-- group:setHideModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.SHOULDER_HOLSTER)
-- group:setHideModel(ItemBodyLocation.SWEATER, ItemBodyLocation.SHOULDER_HOLSTER)
-- group:setHideModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.SHOULDER_HOLSTER)

-- hiding ankleholster
-- use the same attachment name as the body location so the holster and any holstered weapon is hidden as appropriate
group:setHideModel(ItemBodyLocation.PANTS, ItemBodyLocation.ANKLE_HOLSTER)
group:setHideModel(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.ANKLE_HOLSTER)
group:setHideModel(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.ANKLE_HOLSTER)
group:setHideModel(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.ANKLE_HOLSTER)

--hiding items with poncho hood up and down
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.SWEATER)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.SWEATER_HAT)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.SWEATER)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.SWEATER_HAT)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.TORSO_EXTRA_VEST)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.TORSO_EXTRA_VEST)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.CUIRASS)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.CUIRASS)

--hide hoodie when hood down with padded jacket
group:setHideModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.SWEATER)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.SWEATER_HAT)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.SWEATER)

--hide these under FullRobes
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.PANTS_EXTRA)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.TORSO_EXTRA)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.TORSO_EXTRA_VEST)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.CUIRASS)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.WEBBING)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.GORGET)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.THIGH_LEFT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.THIGH_RIGHT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.KNEE_LEFT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.KNEE_RIGHT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.ELBOW_LEFT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.ELBOW_RIGHT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.FORE_ARM_LEFT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.FORE_ARM_RIGHT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.CALF_LEFT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.CALF_RIGHT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.JERSEY)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.BOILERSUIT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.DRESS)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.SKIRT)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.LONG_DRESS)
group:setHideModel(ItemBodyLocation.FULL_ROBE, ItemBodyLocation.LONG_SKIRT)

--hide Gorget under these clothes
group:setHideModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.GORGET)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.GORGET)
group:setHideModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.GORGET)
group:setHideModel(ItemBodyLocation.SWEATER, ItemBodyLocation.GORGET)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.GORGET)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.GORGET)
group:setHideModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.GORGET)

--Hide Codpiece under these
group:setHideModel(ItemBodyLocation.SKIRT, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.DRESS, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.SWEATER, ItemBodyLocation.CODPIECE)
group:setHideModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.CODPIECE)


--hide calf, knee and thigh models (greaves) with long dresses and skirts
group:setHideModel(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.CALF_LEFT)
group:setHideModel(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.CALF_RIGHT)
group:setHideModel(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.CALF_LEFT)
group:setHideModel(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.CALF_RIGHT)
group:setHideModel(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.KNEE_LEFT)
group:setHideModel(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.KNEE_RIGHT)
group:setHideModel(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.KNEE_LEFT)
group:setHideModel(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.KNEE_RIGHT)
group:setHideModel(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.THIGH_LEFT)
group:setHideModel(ItemBodyLocation.LONG_DRESS, ItemBodyLocation.THIGH_RIGHT)
group:setHideModel(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.THIGH_LEFT)
group:setHideModel(ItemBodyLocation.LONG_SKIRT, ItemBodyLocation.THIGH_RIGHT)

--hide thigh models with shorter dresses and skirt
group:setHideModel(ItemBodyLocation.DRESS, ItemBodyLocation.THIGH_LEFT)
group:setHideModel(ItemBodyLocation.DRESS, ItemBodyLocation.THIGH_RIGHT)
group:setHideModel(ItemBodyLocation.SKIRT, ItemBodyLocation.THIGH_LEFT)
group:setHideModel(ItemBodyLocation.SKIRT, ItemBodyLocation.THIGH_RIGHT)

--hide calf, knee and thigh models (greaves) with FullSuits and FullSuitHead
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.CALF_LEFT)
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.CALF_RIGHT)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.CALF_LEFT)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.CALF_RIGHT)
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.KNEE_LEFT)
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.KNEE_RIGHT)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.KNEE_LEFT)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.KNEE_RIGHT)
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.THIGH_LEFT)
group:setHideModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.THIGH_RIGHT)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.THIGH_LEFT)
group:setHideModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.THIGH_RIGHT)

-- Multiple items at these locations are allowed.
group:setMultiItem(ItemBodyLocation.BANDAGE, true)
group:setMultiItem(ItemBodyLocation.WOUND, true)
group:setMultiItem(ItemBodyLocation.ZED_DMG, true)

--hide Sport Shoulderpads under Jersey
group:setHideModel(ItemBodyLocation.JERSEY, ItemBodyLocation.SPORT_SHOULDERPAD)

--hide Jersey under Jackets and Sweaters
group:setHideModel(ItemBodyLocation.SWEATER, ItemBodyLocation.JERSEY)
group:setHideModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.JERSEY)
group:setHideModel(ItemBodyLocation.JACKET, ItemBodyLocation.JERSEY)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.JERSEY)
group:setHideModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.JERSEY)
group:setHideModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.JERSEY)
group:setHideModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.JERSEY)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.JERSEY)
group:setHideModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.JERSEY)
group:setHideModel(ItemBodyLocation.FULL_TOP, ItemBodyLocation.JERSEY)

--hide Thigh armour models with Jacket Suits, Bathrobs and Ponchos
group:setHideModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.THIGH_RIGHT)
group:setHideModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.THIGH_LEFT)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.THIGH_RIGHT)
group:setHideModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.THIGH_LEFT)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.THIGH_RIGHT)
group:setHideModel(ItemBodyLocation.JACKET_DOWN, ItemBodyLocation.THIGH_LEFT)
group:setHideModel(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.THIGH_RIGHT)
group:setHideModel(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.THIGH_LEFT)

-- define alt models used to avoid clipping
-- use alternative models for the second location when an item is in the first location.

--use alternate bandana mask and balaclava when hoods up on clothes
group:setAltModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.MASK)
group:setAltModel(ItemBodyLocation.JACKET_HAT, ItemBodyLocation.MASK)
group:setAltModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.MASK)

group:setAltModel(ItemBodyLocation.PANTS, ItemBodyLocation.CALF_LEFT)
group:setAltModel(ItemBodyLocation.PANTS, ItemBodyLocation.CALF_RIGHT)
group:setAltModel(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.CALF_LEFT)
group:setAltModel(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.CALF_RIGHT)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.CALF_LEFT)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.CALF_RIGHT)
--Vambraces
group:setAltModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.FORE_ARM_LEFT)
group:setAltModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.FORE_ARM_RIGHT)
group:setAltModel(ItemBodyLocation.JACKET, ItemBodyLocation.FORE_ARM_LEFT)
group:setAltModel(ItemBodyLocation.JACKET, ItemBodyLocation.FORE_ARM_RIGHT)
group:setAltModel(ItemBodyLocation.SWEATER, ItemBodyLocation.FORE_ARM_LEFT)
group:setAltModel(ItemBodyLocation.SWEATER, ItemBodyLocation.FORE_ARM_RIGHT)
group:setAltModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.FORE_ARM_LEFT)
group:setAltModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.FORE_ARM_RIGHT)
group:setAltModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.FORE_ARM_LEFT)
group:setAltModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.FORE_ARM_RIGHT)
group:setAltModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.FORE_ARM_LEFT)
group:setAltModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.FORE_ARM_RIGHT)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.FORE_ARM_LEFT)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.FORE_ARM_RIGHT)
group:setAltModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.FORE_ARM_LEFT)
group:setAltModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.FORE_ARM_RIGHT)
group:setAltModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.FORE_ARM_LEFT)
group:setAltModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.FORE_ARM_RIGHT)
group:setAltModel(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.FORE_ARM_LEFT)
group:setAltModel(ItemBodyLocation.BATH_ROBE, ItemBodyLocation.FORE_ARM_RIGHT)
--Football shoulderpads
group:setAltModel(ItemBodyLocation.SPORT_SHOULDERPAD, ItemBodyLocation.JERSEY)
--Kneepads
group:setAltModel(ItemBodyLocation.PANTS, ItemBodyLocation.KNEE_LEFT)
group:setAltModel(ItemBodyLocation.PANTS, ItemBodyLocation.KNEE_RIGHT)
group:setAltModel(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.KNEE_LEFT)
group:setAltModel(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.KNEE_RIGHT)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.KNEE_LEFT)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.KNEE_RIGHT)
group:setAltModel(ItemBodyLocation.SHORT_PANTS, ItemBodyLocation.KNEE_LEFT)
group:setAltModel(ItemBodyLocation.SHORT_PANTS, ItemBodyLocation.KNEE_RIGHT)
--Single shoulderpad
group:setAltModel(ItemBodyLocation.JACKET, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setAltModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setAltModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setAltModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setAltModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setAltModel(ItemBodyLocation.SWEATER, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setAltModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setAltModel(ItemBodyLocation.JERSEY, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setAltModel(ItemBodyLocation.TORSO_EXTRA_VEST, ItemBodyLocation.SHOULDERPAD_RIGHT)
group:setAltModel(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET, ItemBodyLocation.SHOULDERPAD_RIGHT)

group:setAltModel(ItemBodyLocation.JACKET, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setAltModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setAltModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setAltModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setAltModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setAltModel(ItemBodyLocation.SWEATER, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setAltModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setAltModel(ItemBodyLocation.JERSEY, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setAltModel(ItemBodyLocation.TORSO_EXTRA_VEST, ItemBodyLocation.SHOULDERPAD_LEFT)
group:setAltModel(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET, ItemBodyLocation.SHOULDERPAD_LEFT)

--Elbow Pads
group:setAltModel(ItemBodyLocation.JACKET, ItemBodyLocation.ELBOW_LEFT)
group:setAltModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.ELBOW_LEFT)
group:setAltModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.ELBOW_LEFT)
group:setAltModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.ELBOW_LEFT)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.ELBOW_LEFT)
group:setAltModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.ELBOW_LEFT)
group:setAltModel(ItemBodyLocation.SWEATER, ItemBodyLocation.ELBOW_LEFT)
group:setAltModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.ELBOW_LEFT)
group:setAltModel(ItemBodyLocation.JERSEY, ItemBodyLocation.ELBOW_LEFT)
group:setAltModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.ELBOW_LEFT)
group:setAltModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.ELBOW_LEFT)

group:setAltModel(ItemBodyLocation.JACKET, ItemBodyLocation.ELBOW_RIGHT)
group:setAltModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.ELBOW_RIGHT)
group:setAltModel(ItemBodyLocation.JACKET_BULKY, ItemBodyLocation.ELBOW_RIGHT)
group:setAltModel(ItemBodyLocation.JACKET_HAT_BULKY, ItemBodyLocation.ELBOW_RIGHT)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.ELBOW_RIGHT)
group:setAltModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.ELBOW_RIGHT)
group:setAltModel(ItemBodyLocation.SWEATER, ItemBodyLocation.ELBOW_RIGHT)
group:setAltModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.ELBOW_RIGHT)
group:setAltModel(ItemBodyLocation.JERSEY, ItemBodyLocation.ELBOW_RIGHT)
group:setAltModel(ItemBodyLocation.FULL_SUIT_HEAD, ItemBodyLocation.ELBOW_RIGHT)
group:setAltModel(ItemBodyLocation.FULL_SUIT, ItemBodyLocation.ELBOW_RIGHT)

--Thigh Armour
group:setAltModel(ItemBodyLocation.PANTS, ItemBodyLocation.THIGH_RIGHT)
group:setAltModel(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.THIGH_RIGHT)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.THIGH_RIGHT)
group:setAltModel(ItemBodyLocation.SHORT_PANTS, ItemBodyLocation.THIGH_RIGHT)
group:setAltModel(ItemBodyLocation.SHORTS_SHORT, ItemBodyLocation.THIGH_RIGHT)

group:setAltModel(ItemBodyLocation.PANTS, ItemBodyLocation.THIGH_LEFT)
group:setAltModel(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.THIGH_LEFT)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.THIGH_LEFT)
group:setAltModel(ItemBodyLocation.SHORT_PANTS, ItemBodyLocation.THIGH_LEFT)
group:setAltModel(ItemBodyLocation.SHORTS_SHORT, ItemBodyLocation.THIGH_LEFT)

--Cuirass
group:setAltModel(ItemBodyLocation.JACKET, ItemBodyLocation.CUIRASS)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.CUIRASS)
group:setAltModel(ItemBodyLocation.SWEATER, ItemBodyLocation.CUIRASS)
group:setAltModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.CUIRASS)
group:setAltModel(ItemBodyLocation.JACKET_SUIT, ItemBodyLocation.CUIRASS)

--Codpiece
group:setAltModel(ItemBodyLocation.PANTS, ItemBodyLocation.CODPIECE)
group:setAltModel(ItemBodyLocation.SHORTS_SHORT, ItemBodyLocation.CODPIECE)
group:setAltModel(ItemBodyLocation.SHORT_PANTS, ItemBodyLocation.CODPIECE)
group:setAltModel(ItemBodyLocation.BOILERSUIT, ItemBodyLocation.CODPIECE)
group:setAltModel(ItemBodyLocation.PANTS_EXTRA, ItemBodyLocation.CODPIECE)

--Webbing
group:setAltModel(ItemBodyLocation.JACKET, ItemBodyLocation.WEBBING)
group:setAltModel(ItemBodyLocation.SWEATER, ItemBodyLocation.WEBBING)
group:setAltModel(ItemBodyLocation.SWEATER_HAT, ItemBodyLocation.WEBBING)
group:setAltModel(ItemBodyLocation.CUIRASS, ItemBodyLocation.WEBBING)
group:setAltModel(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET, ItemBodyLocation.WEBBING)