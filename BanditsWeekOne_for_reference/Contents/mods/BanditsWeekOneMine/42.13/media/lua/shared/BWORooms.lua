require "BWOBandit"
BWORooms = BWORooms or {}

BWORooms.tab = {

    aesthetic = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Classy", "Young", "DressShort"},
        femaleChance = 100
    },

    aestheticstorage = {
        isStorage = true,
        outfits = {"Classy", "Young", "DressShort"},
        femaleChance = 100
    },

    antique = {
        isStorage = true,
        cids = {Bandit.clanMap.HammerBrothers}
    },

    arenakitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10,
        income = 1
    },

    arenakitchenstorage = {
        isStorage = true,
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10
    },

    armyhanger = {
        isStorage = true,
        cids = {Bandit.clanMap.ArmyGreen},
        occupations = {"veteran"},
        outfits = {"ArmyCamoGreen"},
        hairStyles = {"Bald", "Fresh", "Demi", "FlatTop", "MohawkShort"},
        femaleChance = 0,
        hasRifleChance = 70,
        hasPistolChance = 100,
        rifleMagCount = 4,
        pistolMagCount = 2,
        melee = {"Base.HuntingKnife"}
    },

    armystorage = {
        isStorage = true,
        cids = {Bandit.clanMap.ArmyGreen},
        occupations = {"veteran"},
        outfits = {"ArmyCamoGreen"},
        hairStyles = {"Bald", "Fresh", "Demi", "FlatTop", "MohawkShort"},
        femaleChance = 0,
        hasRifleChance = 70,
        hasPistolChance = 100,
        rifleMagCount = 4,
        pistolMagCount = 2,
        melee = {"Base.HuntingKnife"}
    },

    armysurplus = {
        isShop = true,
    },

    armytent = {
        isStorage = true,
        cids = {Bandit.clanMap.ArmyGreen},
        occupations = {"veteran"},
        outfits = {"ArmyCamoGreen"},
        hairStyles = {"Bald", "Fresh", "Demi", "FlatTop", "MohawkShort"},
        femaleChance = 0,
        hasRifleChance = 70,
        hasPistolChance = 100,
        rifleMagCount = 4,
        pistolMagCount = 2,
        melee = {"Base.HuntingKnife"}
    },

    artstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Classy", "Generic02", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    bakery = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Kitchen},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    bakerykitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan"},
        femaleChance = 30,
        income = 1
    },

    bandkitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan"},
        femaleChance = 30,
        income = 1
    },

    bandlivingroom = {
        isShop = true,
    },

    bandmerch = {
        isShop = true,
    },

    bank = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Security, Bandit.clanMap.Security},
        occupations = {"securityguard"},
        outfits = {"Classy", "Generic02", "Generic03", "Generic04", "Generic05", "Security", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    bankstorage = {
        isStorage = true,
        occupations = {"securityguard"},
        outfits = {"Security"},
        hasPistolChance = 100,
        pistolMagCount = 3,
        melee = {"Base.Nightstick"},
        income = 2
    },

    bar = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Biker", "Punk"},
    },

    barcountertwiggy = {
        isRestaurant = true,
        cids = {Bandit.clanMap.ShopAssistant},
        outfits = {"Waiter_Classy"}
    },

    barbecuestore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    barkitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        income = 1
    },

    barstorage = {
        isStorage = true,
    },

    baseballstore = {

    },

    batfactory = {
        isShop = true,
    },

    bathroom = {
        pop = 0
    },

    batstorage = {
        isStorage = true,
    },

    batteryfactory = {

    },

    batterystorage = {
        isStorage = true,
    },

    bedroom = {
        outfits = {"Naked", "Bedroom"}
    },

    beergarden = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05"},
        femaleChance = 50
    },

    bookstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"IT", "Student", "Teacher", "Generic04", "Generic05"},
        femaleChance = 45
    },

    bowlingalley = {

    },

    breakroom = {

    },

    brewery = {
        isShop = true,
    },

    brewerystorage = {
        isStorage = true,
    },

    burgerkitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 30,
        income = 1
    },

    burgerstorage = {
        isStorage = true,
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 30
    },

    butcher = {
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Kitchen},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    cabinetfactory = {

    },

    cabinetshipping = {

    },

    cafe = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Restaurant"},
        femaleChance = 50
    },

    cafekitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan"},
        femaleChance = 30,
        income = 1
    },

    cafeteria = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Restaurant"},
        femaleChance = 50
    },

    cafeteriakitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 30,
        income = 1
    },

    camerastore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    camping = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    campingstorage = {
        isShop = true,
    },

    candystorage = {
        isStorage = true,
    },

    candystore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    carsupply = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Mechanic", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    catfish_kitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10,
        income = 1
    },

    catfish_dining = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        isRestaurant = true,
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Dining"},
        femaleChance = 50
    },

    cell = {
        cids = {Bandit.clanMap.Inmate},
        occupations = {"securityguard", "policeofficer"},
        outfits = {"Inmate"},
        femaleChance = 0
    },

    changeroom = {

    },

    chinesekitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10,
        income = 1
    },

    chineserestaurant = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        isRestaurant = true,
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Dining"},
        femaleChance = 50
    },

    church = {

    },

    classroom = {
        outfits = {"Student", "Student", "Student", "Student", "Student", "Student", "Student", "Teacher"}
    },

    closet = {

    },

    clinic = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Medic, Bandit.clanMap.Medic},
        isMedical = true,
        outfits = {"Nurse", "Doctor", "HospitalPatient"},
        income = 1
    },

    clothesstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"OfficeWorkerSkirt", "DressShort", "DressNormal", "DressLong"},
        femaleChance = 100
    },

    clothesstorestorage = {
        isStorage = true,
        outfits = {"OfficeWorkerSkirt", "DressShort", "DressNormal", "DressLong"},
        femaleChance = 100
    },

    clothingstorage = {
        isStorage = true,
        outfits = {"OfficeWorkerSkirt", "DressShort", "DressNormal", "DressLong"},
        femaleChance = 100
    },

    clothingstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"OfficeWorkerSkirt", "DressShort", "DressNormal", "DressLong"},
        femaleChance = 100
    },

    communications = {

    },

    construction = {

    },

    controlroom = {

    },

    conveniencestore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    cornerstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    cornerstorestorage = {
        isStorage = true,
        outfits = {"MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    coroneroffice = {
        isStorage = true,
        cidBandit = {Bandit.clanMap.BanditStrong},
    },

    daycare = {
        outfits = {"OfficeWorkerSkirt"},
        femaleChance = 100
    },

    deepfry_kitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10,
        income = 1
    },

    dentiststorage = {
        isStorage = true,
        occupations = {"doctor", "nurse"}
    },

    departmentstorage = {
        isStorage = true,
    },

    departmentstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant, Bandit.clanMap.Security},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    depositboxes = {
        isStorage = true,
        cidBandit = {Bandit.clanMap.CriminalClassy}
    },

    detectiveoffice = {
        cids = {Bandit.clanMap.PoliceBlue},
        outfits = {"Detective"},
        occupations = {"policeofficer"},
        hasPistolChance = 100,
        pistolMagCount = 3,
        income = 1
    },

    diner = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        isRestaurant = true,
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Dining"},
        femaleChance = 50
    },

    dinerbackroom = {
        isShop = true,
    },

    dinercounter = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10,
        income = 1
    },

    dinerkitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10,
        income = 1
    },

    dining = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        isRestaurant = true,
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Dining"},
        femaleChance = 50
    },

    dining_crepe = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        isRestaurant = true,
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Dining"},
        femaleChance = 50
    },

    diningroom = {
        cids = {Bandit.clanMap.Resident},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04"},
        melee = {"Base.SmashedBottle", "Base.Fork"},
    },

    dogfoodfactory = {
        isShop = true,
    },

    dogfoodshipping = {
        isShop = true,

    },
    dogfoodstorage = {
        isStorage = true,
    },

    donut_dining = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Dining"},
        femaleChance = 50
    },

    donut_kitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10,
        income = 1
    },

    donut_kitchenstorage = {
        isStorage = true,
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10
    },

    dressingrooms = {
        outfits = {"DressShort", "Naked"},
    },

    druglab = {

    },

    drugshack = {

    },

    electronicsstorage = {
        isStorage = true,
        occupations = {"electrician"},
        income = 2
    },

    electronicsstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    elementaryclassroom = {
        outfits = {"Student", "Student", "Student", "Student", "Student", "Student", "Student", "Teacher"},
        cids = {Bandit.clanMap.Student},
        cidSpecial = {Bandit.clanMap.Teacher},
    },

    empty = {
        isEmpty = true,
    },

    emptyoutside = {
        isEmpty = true,
    },

    factory = {

    },

    factorystorage = {
        isStorage = true,
        occupations = {"lumberjack", "metalworker", "constructionworker", "carpenter"},
        income = 2
    },

    farmstorage = {
        isStorage = true,
        occupations = {"farmer"},
        outfits = {"Farmer"},
        income = 1
    },

    firestorage = {
        isStorage = true,
        cids = {Bandit.clanMap.Fireman},
        outfits = {"FiremanFullSuit", "Fireman"},
        melee = {"Base.BareHands", "Base.Axe"},
        femaleChance = 0,
        occupations = {"fireofficer"},
        income = 1
    },

    fishchipskitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10,
        income = 1
    },

    fishingstorage = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Fisherman},
        occupations = {"fisherman"}
    },

    fossoil = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Fossoil},
        twentyfour = true,
        outfits = {"Fossoil"}
    },

    fryshipping = {
        isShop = true,
    },

    furniturestorage = {
        isStorage = true,
        occupations = {"carpenter"},
        income = 2
    },

    furniturestore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50,
        income = 2
    },

    garage = {

    },

    garagestorage = {
        isStorage = true,
    },

    garage_storage = {
        isStorage = true,
    },

    gardenstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    gas2go = {
        isShop = true,
        outfits = {"Gas2Go"},
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Gas2Go},
    },

    gasstorage = {
        isStorage = true,
        outfits = {"Gas2Go"}
    },

    gasstore = {
        isShop = true,
        twentyfour = true,
        outfits = {"Gas2Go", "Generic01", "Generic02"}
    },

    generalstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant, Bandit.clanMap.Security},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    generalstorestorage = {
        isStorage = true,
    },

    giftstorage = {
        isStorage = true,
        outfits = {"OfficeWorkerSkirt", "DressShort", "DressNormal", "DressLong"},
        femaleChance = 100
    },

    giftstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"OfficeWorkerSkirt", "DressShort", "DressNormal", "DressLong"},
        femaleChance = 100
    },

    gigamart = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant, Bandit.clanMap.ShopAssistant, Bandit.clanMap.Security, Bandit.clanMap.Security},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "Waiter_Market", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    gigamartkitchen = {
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10,
        income = 1
    },

    grocery = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50,
    },

    grocerystorage = {
        isStorage = true,
    },

    gunstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Veteran},
        occupations = {"veteran"},
        outfits = {"Veteran", "PrivateMilitia", "Generic03", "Thug", "Redneck"},
        femaleChance = 0,
        
    },

    gunstorestorage = {
        isStorage = true,
        occupations = {"veteran"},
        outfits = {"Veteran"},
        femaleChance = 0,
    },

    gym = {
        outfits = {"StreetSports"},
        cids = {Bandit.clanMap.Runner},
    },

    hall = {

    },

    hallway = {

    },

    hospitalstorage = {
        isStorage = true,
        occupations = {"doctor", "nurse"},
        outfits = {"Nurse", "Doctor"},
    },

    housewarestore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    house_main = {
        isShop = true,
    },

    house_bedroom = {
        isShop = true,
    },

    house_kitchen = {
        isShop = true,
    },

    house_bathroom = {
        isShop = true,
    },

    hunting = {
        isShop = true,
    },

    icecream = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Dining"},
        femaleChance = 50
    },

    icecreamkitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife"},
        femaleChance = 10,
        income = 1
    },

    italiankitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10,
        income = 1
    },

    interrogationroom = {
        cids = {Bandit.clanMap.PoliceBlue},
        occupations = {"policeofficer"},
        outfits = {"Police", "Detective"},
        hasPistolChance = 100,
        pistolMagCount = 3,
        melee = {"Base.Nightstick"},
        income = 1
    }, 

    italianrestaurant = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        isRestaurant = true,
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Classy"},
        femaleChance = 50
    },

    janitor = {
        cids = {Bandit.clanMap.Janitor},
    },

    jayschicken_dining = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Jays"},
        femaleChance = 50
    },

    jayschicken_kitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10,
        income = 1
    },

    jewelrystorage = {
        isStorage = true,
    },

    jewelrystore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant, Bandit.clanMap.Security},
        outfits = {"Classy", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    kennels = {
        isShop = true,
        cids = {Bandit.clanMap.Sweepers}
    },

    kitchen = {
        isKitchen = true,
        cids = {Bandit.clanMap.Resident},
        outfits = {"Generic01", "Generic02", "Generic05"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 80
    },

    kitchenstorage = {
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        isStorage = true,
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 30
    },

    kitchen_crepe = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan"},
        femaleChance = 30,
        income = 1
    },

    kitchenwares = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    knifefactory = {
        isShop = true,
    },

    knifeshipping = {
        isShop = true,
    },

    knifestore = {
        isShop = true,
    },

    laboratory = {
        isStorage = true,
        cids = {Bandit.clanMap.Sweepers}
    },

    lasertag = {
        isShop = true,
    },

    laundry = {

    },

    leatherclothesstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Biker", "Generic02", "Generic03", "Thug", "Biker", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    library = {
        outfits = {"IT", "Student", "Teacher", "Generic04", "Generic05"},
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        femaleChance = 45
    },

    lingeriestore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"OfficeWorkerSkirt", "DressShort", "DressNormal", "DressLong", "Naked"},
        femaleChance = 100
    },

    liquorstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Redneck", "Generic01", "Generic02", "Punk"},
        melee = {"Base.SmashedBottle"}
    },

    livingroom = {
        cids = {Bandit.clanMap.Resident},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04"},
        melee = {"Base.SmashedBottle", "Base.Fork"},
    },

    lobby = {
        isShop = true,
    },

    locker = {

    },

    lockerroom = {

    },

    loggingfactory = {
        outfits = {"Woodcut"},
        melee = {"Base.WoodAxe"},
        income = 1
    },

    loggingwarehouse = {
        outfits = {"Woodcut"},
        melee = {"Base.WoodAxe"},
        income = 1
    },

    loggingtruck = {
        outfits = {"Woodcut"},
        melee = {"Base.WoodAxe"},
        income = 1
    },

    mapfactory = {

    },

    mechanic = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Mechanic, Bandit.clanMap.Mechanic, Bandit.clanMap.Mechanic},
        occupations = {"mechanic"},
        outfits = {"Mechanic"},
        femaleChance = 0,
        melee = {"Base.Wrench", "Base.Ratchet"},
        income = 1
    },

    medclinic = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Medic},
        isMedical = true,
        occupations = {"doctor", "nurse"},
        outfits = {"Nurse", "Doctor", "HospitalPatient"},
        income = 1
    },

    medical = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Medic},
        isMedical = true,
        occupations = {"doctor", "nurse"},
        outfits = {"Nurse", "Doctor", "HospitalPatient"},
        income = 1
    },

    medicaloffice = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Medic},
        isMedical = true,
        occupations = {"doctor", "nurse"},
        outfits = {"Nurse", "Doctor", "HospitalPatient"},
        income = 1
    },

    medicalclinic = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Medic},
        isMedical = true,
        occupations = {"doctor", "nurse"},
        outfits = {"Nurse", "Doctor", "HospitalPatient"},
        income = 1
    },

    medicalstorage = {
        isStorage = true,
        occupations = {"doctor", "nurse"},
        outfits = {"Nurse", "Doctor", "HospitalPatient"},
    },

    meeting = {
        outfits = {"OfficeWorker"},
        femaleChance = 0
    },

    meetingroom = {
        outfits = {"OfficeWorker"},
        femaleChance = 0
    },


    metalshipping = {

    },

    metalshop = {

    },

    mexicankitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.Pan", "Base.GridlePan", "Base.MeatCleaver"},
        femaleChance = 10,
        income = 1
    },

    motelroom = {
        cids = {Bandit.clanMap.Resident},
        outfits = {"Naked", "Bedroom", "Bedroom", "Bedroom", "Bedroom", "Bedroom", "StripperBlack", "StripperNaked", "StripperPink"}
    },

    motelroomoccupied = {
        cids = {Bandit.clanMap.Resident, Bandit.clanMap.Party},
        outfits = {"Naked", "Bedroom", "Bedroom", "Bedroom", "Bedroom", "Bedroom", "StripperBlack", "StripperNaked", "StripperPink"}
    },

    morgue = {
        isStorage = true,
        cidBandit = {Bandit.clanMap.BanditStrong}
    },

    movierental = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    movierentalxxx = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Thug"},
        femaleChance = 0
    },

    musicstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    newspaperprint = {

    },

    newspapershipping = {

    },

    newspaperstorage = {
        isStorage = true,
    },

    office = {
        outfits = {"OfficeWorkerSkirt"},
        cids = {Bandit.clanMap.Office},
        cidBandit = {Bandit.clanMap.CriminalWhite},
        femaleChance = 100
    },

    officestorage = {
        isStorage = true,
        cids = {Bandit.clanMap.Office},
        outfits = {"OfficeWorker"},
        femaleChance = 0
    },

    optometrist = {
        isShop = true,
    },

    paintershop = {

    },

    pawnshop = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant, Bandit.clanMap.Security},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    pawnshopcooking = {

    },

    pawnshopoffice = {

    },

    pawnshopstorage = {
        isStorage = true,
    },

    pharmacy = {
        isShop = true,
        isMedical = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Medic},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "Pharmacist"},
        femaleChance = 50
    },

    pharmacystorage = {
        isStorage = true,
        occupations = {"doctor", "nurse"},
        outfits = {"Pharmacist"},
        femaleChance = 70
    },

    photoroom = {
        isShop = true,
    },

    picnic = {

    },

    pileocrepe = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_PileOCrepe"},
        femaleChance = 50
    },

    pizzakitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.RollingPin", "Base.RollingPin", "Base.RollingPin"},
        femaleChance = 10,
        income = 1
    },

    pizzawhirled = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_PizzaWhirled"},
        femaleChance = 50
    },

    pizzawhirledcounter = {
        isRestaurant = true,
        cidSpecial = {Bandit.clanMap.Kitchen},
        outfits = {"Waiter_PizzaWhirled"},
        femaleChance = 50
    },

    plazastore1 = {

    },

    policearchive = {
        isStorage = true,
        cids = {Bandit.clanMap.PoliceBlue},
        occupations = {"policeofficer"},
        outfits = {"Police", "Detective"},
        hasPistolChance = 100,
        pistolMagCount = 3,
        melee = {"Base.Nightstick"},
        income = 1
    },

    policegarage = {
        isStorage = true,
        cids = {Bandit.clanMap.PoliceBlue},
        occupations = {"policeofficer"},
        outfits = {"Police", "Detective"},
        hasPistolChance = 100,
        pistolMagCount = 3,
        melee = {"Base.Nightstick"}
    },

    policegunstorage = {
        isStorage = true,
        cids = {Bandit.clanMap.SWAT},
        occupations = {"policeofficer"},
        outfits = {"Police"},
        hasRifleChance = 70,
        rifleMagCount = 2,
        hasPistolChance = 100,
        pistolMagCount = 3,
        melee = {"Base.Nightstick"}
    },

    policehall = {
        cids = {Bandit.clanMap.PoliceBlue},
        occupations = {"policeofficer"},
        outfits = {"Police"},
        hasPistolChance = 100,
        pistolMagCount = 3,
        melee = {"Base.Nightstick"}
    }, 

    policelocker = {
        isStorage = true,
        cids = {Bandit.clanMap.PoliceBlue},
        occupations = {"policeofficer"},
        outfits = {"Police"},
        hasPistolChance = 100,
        pistolMagCount = 3,
        melee = {"Base.Nightstick"}
    }, 

    policeoffice = {
        cids = {Bandit.clanMap.PoliceBlue},
        occupations = {"policeofficer"},
        outfits = {"Police", "Detective"},
        hasPistolChance = 100,
        pistolMagCount = 3,
        melee = {"Base.Nightstick"},
        income = 1
    }, 

    policestorage = {
        isStorage = true,
        cids = {Bandit.clanMap.PoliceBlue},
        occupations = {"policeofficer"},
        outfits = {"Police"},
        hasPistolChance = 100,
        pistolMagCount = 3,
        melee = {"Base.Nightstick"}
    },

    pool = {

    },

    post = {

    },

    poststorage = {
        isStorage = true,
    },

    potatostorage = {
        isStorage = true,
        occupations = {"farmer"},
        outfits = {"Farmer"},
        income = 1
    },

    prisoncells = {
        cids = {Bandit.clanMap.Inmate},
        occupations = {"securityguard", "policeofficer"},
        outfits = {"Inmate"},
        income = 1
    },

    prisoncell = {
        cids = {Bandit.clanMap.Inmate},
        occupations = {"securityguard", "policeofficer"},
        outfits = {"Inmate"},
        income = 1
    },

    producestorage = {
        isStorage = true,
        occupations = {"farmer"},
        outfits = {"Farmer"},
        income = 1
    },

    radiofactory = {
        isShop = true,
    },

    radioshipping = {
        isShop = true,
    },

    radiostorage = {
        isStorage = true,
        occupations = {"electrician"},
        income = 3
    },

    recreation = {

    },

    restaurant = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Classy"},
        femaleChance = 50
    },

    restaurant_dining = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Classy"},
        femaleChance = 50
    },

    restaurantdining = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Classy"},
        femaleChance = 50
    },

    restaurantkitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.RollingPin", "Base.RollingPin", "Base.RollingPin"},
        femaleChance = 10,
        income = 1
    },

    restaurantstorage = {
        isStorage = true,

    },

    room1 = {

    },

    schoolstorage = {
        isStorage = true,
        outfits = {"Student", "Student", "Student", "Student", "Student", "Student", "Student", "Teacher"},
        cids = {Bandit.clanMap.Student},
    },

    seafoodkitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.RollingPin", "Base.RollingPin", "Base.RollingPin"},
        femaleChance = 10,
        income = 1
    },

    secondaryclassroom = {
        outfits = {"Student", "Student", "Student", "Student", "Student", "Student", "Student", "Teacher"},
        cids = {Bandit.clanMap.Student},
        cidSpecial = {Bandit.clanMap.Teacher},
    },
    
    security = {
        isStorage = true,
        cids = {Bandit.clanMap.Security},
        occupations = {"securityguard", "policeofficer"},
        outfits = {"Security"},
        hasPistolChance = 100,
        pistolMagCount = 3,
        melee = {"Base.Nightstick"},
        income = 1
    },

    sewingstorage = {
        isStorage = true,
    },

    sewingstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"OfficeWorkerSkirt", "DressShort", "DressNormal", "DressLong"},
        femaleChance = 100
    },

    shed = {

    },

    shoestore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"OfficeWorkerSkirt", "DressShort", "DressNormal", "DressLong"},
        femaleChance = 100
    },

    shoestorage = {
        isStorage = true,
        outfits = {"OfficeWorkerSkirt", "DressShort", "DressNormal", "DressLong"},
        femaleChance = 100
    },

    sodatruck = {
        isShop = true,
    },

    spifforestaurant = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        outfits = {"Generic02", "Generic03", "Spiffo", "Young", "Waiter_Spiffo"},
        femaleChance = 50
    },

    spiffo_dining = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        outfits = {"Generic02", "Generic03", "Spiffo", "Young", "Waiter_Spiffo"},
        femaleChance = 50
    },

    spiffoskitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.RollingPin", "Base.RollingPin", "Base.RollingPin"},
        femaleChance = 10,
        income = 1
    },

    spiffosstorage = {
        isStorage = true,
        occupations = {"chef", "burgerflipper"},
    },

    sportstorage = {
        isShop = true,
        cids = {Bandit.clanMap.Walker, Bandit.clanMap.Runner},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"SportsFan", "StreetSports"},
        occupations = {"fitnessInstructor"}, -- yes, "I" should be capitalized
    },

    sportstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker, Bandit.clanMap.Runner},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"SportsFan", "StreetSports"},
    },

    storageunit = {
        isEmpty = true,
    },

    storage = {
        cids = {Bandit.clanMap.Walker, Bandit.clanMap.Runner},
        cidBandit = {Bandit.clanMap.BanditStrong},
        isStorage = true
    },

    storageclothes = {
        isStorage = true,

    },

    stripclub = {
        cids = {Bandit.clanMap.Walker, Bandit.clanMap.Party},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "StripperBlack", "StripperNaked", "StripperPink", "PoliceStripper", "FiremanStripper", "BWOAnimal"},
        femaleChance = 40
    },

    stripclubvip = {
        cids = {Bandit.clanMap.Walker, Bandit.clanMap.Party},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "StripperBlack", "StripperNaked", "StripperPink", "PoliceStripper", "FiremanStripper", "BWOAnimal"},
        femaleChance = 40
    },

    sushidining = {
        isRestaurant = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.Waiter, Bandit.clanMap.Waiter},
        outfits = {"Generic02", "Generic03", "Classy", "Young", "Waiter_Classy"},
        femaleChance = 50
    },

    sushikitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.RollingPin", "Base.RollingPin", "Base.RollingPin"},
        femaleChance = 0,
        income = 1
    },

    tacokitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.RollingPin", "Base.RollingPin", "Base.RollingPin"},
        femaleChance = 15,
        income = 1
    },

    theatre = {

    },

    theatrekitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.RollingPin", "Base.RollingPin", "Base.RollingPin"},
        femaleChance = 10,
        income = 1
    },

    theatrestorage = {
        isStorage = true,
    },

    thundergas = {
        isShop = true,
        twentyfour = true,
        outfits = {"ThunderGas"}
    },

    toolstorage = {
        isStorage = true,
        cidBandit = {Bandit.clanMap.BanditSpike},
        occupations = {"repairman"},
        income = 1
    },

    toolstore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "OfficeWorkerSkirt"},
        femaleChance = 20
    },

    toystore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "OfficeWorkerSkirt"},
        femaleChance = 70
    },

    toystorestorage = {
        isStorage = true,
    },

    vault = {
        isStorage = true,
        cidBandit = {Bandit.clanMap.CriminalClassy}
    },

    walletshop = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "OfficeWorkerSkirt"},
        femaleChance = 50
    },

    warehouse = {
        isStorage = true,
        outfits = {"Foreman", "Metalworker"}
    },

    westernkitchen = {
        isRestaurant = true,
        isKitchen = true,
        cids = {Bandit.clanMap.Kitchen},
        occupations = {"chef", "burgerflipper"},
        outfits = {"Cook_Generic", "Chef"},
        melee = {"Base.BareHands", "Base.RollingPin", "Base.KitchenKnife", "Base.BreadKnife", "Base.ButterKnife", "Base.RollingPin", "Base.RollingPin", "Base.RollingPin"},
        femaleChance = 10,
        income = 1
    },

    whiskeybottling = {
        isStorage = true,
    },

    wirefactory = {
        isStorage = true,

    },

    zippeestorage = {
        isStorage = true,
        outfits = {"MallSecurity", "OfficeWorker"},
        femaleChance = 0
    },

    zippeestore = {
        isShop = true,
        cids = {Bandit.clanMap.Walker},
        cidSpecial = {Bandit.clanMap.ShopAssistant},
        outfits = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "MallSecurity", "OfficeWorkerSkirt"},
        femaleChance = 50
    },
}

BWORooms.GetRealRoomName = function(room)
    -- overwrites for buildings which are not zoned properly
    local name
    local building = room:getBuilding()
    if building:containsRoom("firestorage") then
        name = "firestorage"
    elseif building:containsRoom("church") then
        name = "church"
    elseif building:containsRoom("stripclub") then
        name = "stripclub"
    elseif building:containsRoom("bar") then
        name = "bar"
    else
        name = room:getName()
    end
    return name
end

BWORooms.Get = function(room)

    local name = BWORooms.GetRealRoomName(room)

    local data = BWORooms.tab[name]
    if data then data.name = name end
    return data
end

BWORooms.IsKitchen = function(room)
    local name = room:getName()
    local data = BWORooms.tab[name]
    if data and data.isKitchen then 
        return true
    else
        return false
    end 
end

BWORooms.IsShop = function(room)
    local name = room:getName()
    local data = BWORooms.tab[name]
    if data and data.isShop then 
        return true
    else
        return false
    end 
end

BWORooms.IsRestaurant = function(room)
    local name = room:getName()
    local data = BWORooms.tab[name]
    if data and data.isRestaurant then 
        return true
    else
        return false
    end 
end

BWORooms.IsStorage = function(room)
    local name = room:getName()
    local data = BWORooms.tab[name]
    if data and data.isStorage then 
        return true
    else
        return false
    end 
end

BWORooms.IsMedical = function(room)
    local name = room:getName()
    local data = BWORooms.tab[name]
    if data and data.isMedical then 
        return true
    else
        return false
    end 
end

BWORooms.IsEmpty = function(room)
    local name = room:getName()
    local data = BWORooms.tab[name]
    if data and data.isEmpty then 
        return true
    else
        return false
    end 
end

BWORooms.IsIntrusion = function(room)

    -- available professions types: 
    -- unemployed, fireofficer, policeofficer, parkranger, constructionworker, securityguard, carpenter, burglar, chef, farmer, fisherman
    -- doctor, veteran, nurse, lumberjack, fitnessinstructor, burgerflipper, electrician, metalworker, mechanics
    local player = getSpecificPlayer(0)
    if not player then return end

    local profession = player:getDescriptor():getCharacterProfession()
    local building = room:getBuilding()

    -- instrusions
    local isIntrusion = false
    if BWOBuildings.IsResidential(building) then 
        isIntrusion = true
    end

    if BWORooms.IsStorage(room) then 
        isIntrusion = true
    end

    -- exceptions
    local name = BWORooms.GetRealRoomName(room)
    local tab = BWORooms.tab
    local data = BWORooms.tab[name]
    if data then
        if data.isStorage then
            if data.occupations then
                for _, occupation in pairs(data.occupations) do
                    if profession == occupation then
                        isIntrusion = false
                        break
                    end
                end
            end
        end
    end

    if BWOBuildings.IsEventBuilding(building, "party") then 
        isIntrusion = false 
    elseif BWOBuildings.IsEventBuilding(building, "home") then 
        isIntrusion = false 
    elseif BWORooms.IsEmpty(room) then  
        isIntrusion = false 
    elseif BWORooms.IsShop(room) then 
        isIntrusion = false 
    elseif BWORooms.IsRestaurant(room) then 
        isIntrusion = false 
    elseif BWORooms.IsMedical(room) then 
        isIntrusion = false 
    elseif roomName == "church" then 
        isIntrusion = false 
    end

    return isIntrusion
end

BWORooms.TakeIntention = function(room, customName)
    local player = getSpecificPlayer(0)
    if not player then return end
    
    local building = room:getBuilding()
    local def = room:getRoomDef()
    local profession = player:getDescriptor():getCharacterProfession()

    local canTake = false
    local shouldPay = false

    if def:getZ() < 0 then -- basements are separate buildings, it needs to be here to prevent player home basement to be treated as a a shop
        canTake = true
        shouldPay = false

    elseif BWOBuildings.IsEventBuilding(building, "party") then 
        canTake = true
        shouldPay = false

    elseif BWOBuildings.IsEventBuilding(building, "home") then 
        canTake = true
        shouldPay = false

    elseif BWORooms.IsShop(room) then
        canTake = false
        shouldPay = true

    elseif BWORooms.IsRestaurant(room) then
        canTake = false
        shouldPay = true

    elseif BWOBuildings.IsResidential(building) then 
        canTake = false
        shouldPay = false

    elseif customName == "Trash" or customName == "Garbage" or customName == "Bin" then
        canTake = true
        shouldPay = false

    elseif customName == "Machine" then
        canTake = false
        shouldPay = true

    end

    -- exceptions
    local name = BWORooms.GetRealRoomName(room)
    local tab = BWORooms.tab
    local data = BWORooms.tab[name]
    if data then
        if data.occupations then
            for _, occupation in pairs(data.occupations) do
                if profession == occupation then
                    canTake = true
                    break
                end
            end
        end
    end

    return canTake, shouldPay
end

BWORooms.GetRoomSize = function(room)
    local roomDef = room:getRoomDef()
    local size = (roomDef:getX2() - roomDef:getX()) * (roomDef:getY2() - roomDef:getY())
    return size
end

BWORooms.GetRoomCurrPop = function(room)
    local roomDef = room:getRoomDef()
    local rx1 = roomDef:getX()
    local rx2 = roomDef:getX2()
    local ry1 = roomDef:getY()
    local ry2 = roomDef:getY2()

    local tab = {}
    local banditList = BanditZombie.GetAllB()
    for id, bandit in pairs(banditList) do
        if bandit.x >= rx1 and bandit.x <= rx2 and bandit.y >= ry1 and bandit.y <= ry2 then
            local cid = bandit.brain.cid
            if cid then
                if tab[cid] then
                    tab[cid] = tab[cid] + 1
                else
                    tab[cid] = 1
                end
            end
        end
    end
    return tab
end

BWORooms.GetRoomMaxPop = function(room)
    local size = BWORooms.GetRoomSize(room)
    size = size * BWORooms.GetRoomPopMod(room)
    if size < 20 then
        return 1
    else
        return math.floor(size / 20)
    end
end

BWORooms.GetRoomPopMod = function(room)
    local popMod = 1
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()
    local building = room:getBuilding()
    local roomName = room:getName()
    
    if BWOBuildings.IsResidential(building) then 
        if hour < 6 then
            popMod = 0.9
        elseif hour < 17 then
            popMod = 0.5
        elseif hour < 19 then
            popMod = 0.6
        elseif hour < 21 then
            popMod = 0.7
        else
            popMod = 0.8
        end
    elseif BWORooms.IsStorage(room) then
        popMod = 0.5
    elseif BWORooms.IsShop(room) then
        if hour < 7 then
            popMod = 0
        elseif hour < 10 then
            popMod = 1.5
        elseif hour < 19 then
            popMod = 2.0
        elseif hour < 20 then
            popMod = 1.75
        else
            popMod = 0
        end

    elseif BWORooms.IsRestaurant(room) then
        if hour < 8 then
            popMod = 0
        elseif hour < 12 then
            popMod = 2
        elseif hour < 14 then
            popMod = 2.5
        elseif hour < 19 then
            popMod = 2
        elseif hour < 23 then
            popMod = 2.5
        elseif hour < 24 then
            popMod = 1
        end
        if BWOScheduler.SymptomLevel >= 2 then
            popMod = popMod * 0.5
        end
    elseif BWORooms.IsEmpty(room) then
        popMod = 0
    elseif BWORooms.IsMedical(room) then
        if BWOScheduler.SymptomLevel == 1 then
            popMod = 1.5
        elseif BWOScheduler.SymptomLevel == 2 then
            popMod = 3
        elseif BWOScheduler.SymptomLevel == 3 then
            popMod = 4
        elseif BWOScheduler.SymptomLevel == 4 then
            popMod = 4.5
        end

    elseif roomName == "church" or roomName == "classroom" then
        if hour < 6 then
            popMod = 0
        elseif hour < 18 then
            popMod = 2
        else
            popMod = 0
        end
        if BWOScheduler.SymptomLevel >= 2 then
            popMod = popMod * 2
        end
    elseif roomName == "hall" then
        popMod = 0.2
    end
    return popMod
end