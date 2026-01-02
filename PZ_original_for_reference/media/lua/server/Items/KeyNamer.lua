KeyNamer.clear()

-- dont use any of these zone names for keys
KeyNamer.badZones:add("Athletic");
KeyNamer.badZones:add("Rich");
KeyNamer.badZones:add("StreetSports");
KeyNamer.badZones:add("StreetPoor");
KeyNamer.badZones:add("StreetRich");
KeyNamer.badZones:add("Rocker");

-- check for a match here first. if the building has any of these rooms
KeyNamer.bigBuildingRooms:add("hospitalroom");
KeyNamer.bigBuildingRooms:add("Gallery");
KeyNamer.bigBuildingRooms:add("motelroom");
KeyNamer.bigBuildingRooms:add("armyhanger");
KeyNamer.bigBuildingRooms:add("batfactory");
KeyNamer.bigBuildingRooms:add("batteryfactory");
KeyNamer.bigBuildingRooms:add("brewery");
KeyNamer.bigBuildingRooms:add("cabinetfactory");
KeyNamer.bigBuildingRooms:add("dogfoodfactoryfactory");
KeyNamer.bigBuildingRooms:add("knifefactory");
KeyNamer.bigBuildingRooms:add("mapfactory");
KeyNamer.bigBuildingRooms:add("metalshop");
KeyNamer.bigBuildingRooms:add("potatostorage");
KeyNamer.bigBuildingRooms:add("producestorage");
KeyNamer.bigBuildingRooms:add("radiofactory");
KeyNamer.bigBuildingRooms:add("stripclub");
KeyNamer.bigBuildingRooms:add("theatre");
KeyNamer.bigBuildingRooms:add("warehouse");
KeyNamer.bigBuildingRooms:add("wirefactory");
KeyNamer.bigBuildingRooms:add("whiskeybottling");
KeyNamer.bigBuildingRooms:add("storageunit");
KeyNamer.bigBuildingRooms:add("church");

-- then check for any of these rooms
KeyNamer.rooms:add("armysurplus");
KeyNamer.rooms:add("artstore");
KeyNamer.rooms:add("bakery");
KeyNamer.rooms:add("baseballstore");
KeyNamer.rooms:add("bar");
KeyNamer.rooms:add("barbecuestore");
KeyNamer.rooms:add("barkitchen");
KeyNamer.rooms:add("barstorage");
KeyNamer.rooms:add("beergarden");
KeyNamer.rooms:add("bookstore");
KeyNamer.rooms:add("butcher");
KeyNamer.rooms:add("cafe");
KeyNamer.rooms:add("cafekitchen");
KeyNamer.rooms:add("camerastore");
KeyNamer.rooms:add("camping");
KeyNamer.rooms:add("conveniencestore");
KeyNamer.rooms:add("deepfry_kitchen");
KeyNamer.rooms:add("fishchipskitchen");
KeyNamer.rooms:add("gardenstore");
KeyNamer.rooms:add("generalstore");
KeyNamer.rooms:add("housewarestore");
KeyNamer.rooms:add("kitchenwares");
KeyNamer.rooms:add("knifestore");
KeyNamer.rooms:add("laboratory");
KeyNamer.rooms:add("leatherclothesstore");
KeyNamer.rooms:add("library");
KeyNamer.rooms:add("lingeriestore");
KeyNamer.rooms:add("liquorstore");
KeyNamer.rooms:add("movierental");
KeyNamer.rooms:add("musicstore");
KeyNamer.rooms:add("newspaper");
KeyNamer.rooms:add("optometrist");
KeyNamer.rooms:add("paintershop");
KeyNamer.rooms:add("pizzakitchen");
KeyNamer.rooms:add("restaurant");
KeyNamer.rooms:add("restaurantkitchen");
KeyNamer.rooms:add("seafoodkitchen");
KeyNamer.rooms:add("shed");
KeyNamer.rooms:add("shoestore");
KeyNamer.rooms:add("sodatruck");
KeyNamer.rooms:add("walletshop");
KeyNamer.rooms:add("warehouse");
KeyNamer.rooms:add("westernkitchen");

-- then check if any rooms in the building have any of these substrings
KeyNamer.roomSubstrings:add("aesthetic");
KeyNamer.roomSubstrings:add("bank");
KeyNamer.roomSubstrings:add("burger");
KeyNamer.roomSubstrings:add("cafeteria");
KeyNamer.roomSubstrings:add("chinese");
KeyNamer.roomSubstrings:add("clothingstore");
KeyNamer.roomSubstrings:add("cornerstore");
KeyNamer.roomSubstrings:add("departmentstore");
KeyNamer.roomSubstrings:add("donut_");
KeyNamer.roomSubstrings:add("electronicsstore");
KeyNamer.roomSubstrings:add("furniturestore");
KeyNamer.roomSubstrings:add("gasstore");
KeyNamer.roomSubstrings:add("generalstore");
KeyNamer.roomSubstrings:add("giftstore");
KeyNamer.roomSubstrings:add("grocery");
KeyNamer.roomSubstrings:add("gunstore");
KeyNamer.roomSubstrings:add("gym");
KeyNamer.roomSubstrings:add("icecream");
KeyNamer.roomSubstrings:add("italian");
KeyNamer.roomSubstrings:add("jayschicken_");
KeyNamer.roomSubstrings:add("jewelrystore");
KeyNamer.roomSubstrings:add("mexicankitchen");
KeyNamer.roomSubstrings:add("office");
KeyNamer.roomSubstrings:add("pawnshop");
KeyNamer.roomSubstrings:add("post");
KeyNamer.roomSubstrings:add("sewingstore");
KeyNamer.roomSubstrings:add("sportstore");
KeyNamer.roomSubstrings:add("sushi");
KeyNamer.roomSubstrings:add("toolstore");
KeyNamer.roomSubstrings:add("toystore");
KeyNamer.roomSubstrings:add("zippeestore");


-- Then check for these restaurant rooms
KeyNamer.restaurants:add("bar");
KeyNamer.restaurants:add("barbecuestore");
KeyNamer.restaurants:add("barkitchen");
KeyNamer.restaurants:add("barstorage");
KeyNamer.restaurants:add("beergarden");
KeyNamer.restaurants:add("cafe");
KeyNamer.restaurants:add("cafekitchen");
KeyNamer.restaurants:add("deepfry_kitchen");
KeyNamer.restaurants:add("fishchipskitchen");
KeyNamer.restaurants:add("pizzakitchen");
KeyNamer.restaurants:add("seafoodkitchen");
KeyNamer.restaurants:add("sodatruck");

-- Finally restaurant room substrings
KeyNamer.restaurantSubstrings:add("burger");
KeyNamer.restaurantSubstrings:add("cafeteria");
KeyNamer.restaurantSubstrings:add("chinese");
KeyNamer.restaurantSubstrings:add("donut_");
KeyNamer.restaurantSubstrings:add("icecream");
KeyNamer.restaurantSubstrings:add("italian");
KeyNamer.restaurantSubstrings:add("jayschicken_");
KeyNamer.restaurantSubstrings:add("mexicankitchen");
KeyNamer.restaurantSubstrings:add("sushi");

