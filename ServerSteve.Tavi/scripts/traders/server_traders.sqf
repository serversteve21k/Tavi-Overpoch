/*

	CUSTOM TRADERS FOR TAVIANA EPOCH
	(Credits: DayZ Epoch Devs for their original traders.)
	AUTHOR: AVendettaForYou
	Date: 12/11/2013

*/
serverTraders = [
	// Hero
	/*Hero Guns,Vehicles*/"Soldier_Sniper_PMC",
	/*"GUE_Woodlander3",
	"RU_Damsel5",
	"RU_Doctor",*/
	//Bandit
	/*Bandit Guns,Vehicles*/"GUE_Woodlander1",
	/*"RU_Worker1",
	"RU_Farmwife5",
	"Dr_Hladik_EP1",*/
	//Air
	/*Air*/"UN_CDF_Soldier_Pilot_EP1",
	//Wholesaler
	/*Wholesaler*/"Reynolds_PMC",
	//Trader City
	/*vehicles*/"RU_Woodlander4",
	/*Bags Food Drink*/"Citizen3",
	/*Ammo*/"Soldier_GL_PMC",
	/*Builder*/"RU_Worker4",
	/*Guns and Attachments*/"Soldier_Sniper_KSVK_PMC",
	/*Health*/"Doctor",
	/*Bank*///["Functionary1_EP1_DZ",
	//Boat
	/*Boat*/"Profiteer2_EP1",
	//Black Market
	/*Heli Armed*/"GUE_Worker2",
	/*Ammo*/"GUE_Soldier_CO",
	/*Guns and Attachments*/"GUE_Commander"
	
	];
/*---------------------------------------------------------------------------
			HERO VENDORS
---------------------------------------------------------------------------*/
//Hero Guns,vehicles
menu_Soldier_Sniper_PMC = [
	[["Attachments",693],["Ammunition",478],["Currency and gems",1100],["Clothes",476],["Helicopter Armed",493],["Military Armed",562],["Trucks Armed",479],["Weapons",477],["LMG Variants",1008],["Sniper Variants",1001]],
	[],
	"hero"
];
/*
//SUPPLIES
menu_GUE_Woodlander3 = [
	[["Building Supplies",678],["Currency and gems",1100],["Tools",679],["Vehicle Parts",677]],
	[],
	"hero"
];
//MEDICAL
menu_RU_Doctor = [
	[["Chem-lites/Flares",542],["Medical Supplies",541],["Smoke Grenades",543]],
	[["FoodBioMeat","ItemZombieParts",1,1,"buy","Zombie Parts","Bio Meat",101]],
	"hero"
];
//FOOD & DRINK
menu_RU_Damsel5 = [
	[["Backpacks",538],["Clothes",628],["Cooked Meats",630],["Currency and gems",1100],["Drinks",601],["Packaged Food",629]],
	[["ItemTinBar","TrashJackDaniels",1,1,"buy","Empty Whiskey Bottle","Tin Bar",101]],
	"hero"
];
*/
/*---------------------------------------------------------------------------
			BANDIT VENDORS
---------------------------------------------------------------------------*/
//Bandit Guns,vehicles
menu_GUE_Woodlander1 = [
	[["Attachments",693],["Ammunition",577],["Currency and gems",1100],["Clothing",575],["Helicopter Armed",512],["Military Armed",569],["Trucks Armed",534],["Weapons",627],["LMG Variants",1008],["Sniper Variants",1001]],
	[],
	"hostile"
];
/*
//SUPPLIES
menu_RU_Worker1 = [	
	[["Building Supplies",678],["Currency and gems",1100],["Tools",679],["Vehicle Parts",677]],
	[],
	"hostile"
];
//MEDICAl
menu_Dr_Hladik_EP1 = [
	[["Chem-lites/Flares",542],["Medical Supplies",541],["Smoke Grenades",543]],
	[["FoodBioMeat","ItemZombieParts",1,1,"buy","Zombie Parts","Bio Meat",101]],
	"hostile"
];
//FOOD & DRINK
menu_RU_Farmwife5 = [
	[["Backpacks",538],["Clothes",628],["Cooked Meats",630],["Currency and gems",1100],["Drinks",601],["Packaged Food",629]],
	[["ItemTinBar","TrashJackDaniels",1,1,"buy","Empty Whiskey Bottle","Tin Bar",101]],
	"hostile"
];
*/
/*---------------------------------------------------------------------------
			Trader City
---------------------------------------------------------------------------*/
//MEDICAL
menu_Doctor = [
	[["Chem-lites/Flares",542],["Medical Supplies",541],["Smoke Grenades",543]],
	[["FoodBioMeat","ItemZombieParts",1,1,"buy","Zombie Parts","Bio Meat",101]],
	"neutral"
];
//SUPPLIES
menu_RU_Worker4 = [
	[["Building Supplies",678],["Currency and gems",1100],["Tools",679],["Vehicle Parts",677]],
	[],
	"neutral"
];
//WEAPONS
menu_Soldier_Sniper_KSVK_PMC = [
	[["Attachments",693],["HK416 Variants",1004],["HK417 Variants",1002],["AK Variants",1003],["G3 Variants",1007],["Masada Variants",1009],["SCAR Variants",1011],["Assault Rifle",485],["Light Machine Gun",486],["Pistols",489],["Shotguns and Single-shot",574],["Sniper Rifle",487],["Submachine Guns",488]],
	[],
	"neutral"
];
//AMMUNITION
menu_Soldier_GL_PMC = [
	[["Assault Rifle Ammo",621],["Light Machine Gun Ammo",622],["Pistol Ammo",625],["Shotguns and Single-shot Ammo",623],["Sniper Rifle Ammo",624],["Submachine Gun Ammo",626]],
	[],
	"neutral"
];
//FOOD & DRINK
menu_Citizen3 = [
	[["Backpacks",538],["Clothes",628],["Cooked Meats",630],["Currency and gems",1100],["Drinks",601],["Packaged Food",629]],
	[["ItemTinBar","TrashJackDaniels",1,1,"buy","Empty Whiskey Bottle","Tin Bar",101]],
	"neutral"
];
//Vehicles
menu_RU_Woodlander4 = [
	[["Bikes and ATV",608],["Buses and Vans",563],["Cargo Trucks",564],["Fuel Trucks",492],["Military Unarmed",491],["Trucks",495],["Used Cars",585],["Utility Vehicles",565],["Cop cars",1012],["Nissan 350z",1013]],
	[],
	"neutral"
];
/*---------------------------------------------------------------------------
			Boat Trader
---------------------------------------------------------------------------*/
menu_Profiteer2_EP1 = [
	[["Boats Armed",673],["Boats Unarmed",672]],
	[],
	"neutral"
];
/*---------------------------------------------------------------------------
			Air Trader
---------------------------------------------------------------------------*/
menu_UN_CDF_Soldier_Pilot_EP1 = [
	[["Airplanes",517],["Currency and gems",1100],["Helicopter Unarmed",519],["Overwatch Camels (Armed)",1014]],
	[],
	"neutral"
];
/*---------------------------------------------------------------------------
			Black Market
---------------------------------------------------------------------------*/
//WEAPONS
menu_GUE_Commander = [
	[["ACR",412],["Attachments",693],["HK416 Variants",1004],["HK417 Variants",1002],["AK Variants",1003],["G3 Variants",1007],["Masada Variants",1009],["SCAR Variants",1011],["Assault Rifle",485],["Light Machine Gun",486],["Pistols",489],["Shotguns and Single-shot",574],["Sniper Rifle",487],["Submachine Guns",488]],
	[],
	"neutral"
];
//AMMUNITION
menu_GUE_Soldier_CO = [
	[["Assault Rifle Ammo",621],["Light Machine Gun Ammo",622],["Pistol Ammo",625],["Shotguns and Single-shot Ammo",623],["Sniper Rifle Ammo",624],["Submachine Gun Ammo",626]],
	[],
	"neutral"
];
//HELICOPTERS
menu_GUE_Worker2 = [
	[["Helicopter Armed",494]],
	[],
	"neutral"
];
/*---------------------------------------------------------------------------
			WHOLESALE VENDORS
---------------------------------------------------------------------------*/
menu_Reynolds_PMC = [
	[["Wholesale",675],["Currency and gems",1100]],
	[],
	"neutral"
];