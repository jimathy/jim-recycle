print("Jim-Recycle - Recycling Script by Jimathy")

Config = {}

Config = {
	Blips = true, -- Enable Blips?
	BlipNamer = false, -- Enable to Name Blips different things, disable if you already have too many blips as this will group them together
	PropSpawn = true, -- Enable Ore Props
	Pedspawn = true, -- Do you want to spawn peds for main locations?
	Invincible = true, --Do you want the peds to be invincible?
	Frozen = true, --Do you want the peds to be unable to move? It's probably a yes, so leave true in there.
	Stoic = true, --Do you want the peds to react to what is happening in their surroundings?
	Fade = true, -- Do you want the peds to fade into/out of existence? It looks better than just *POP* its there.
	Distance = 40.0, --The distance you want peds to spawn at
	EnableOpeningHours = true, -- Enable opening hours? If disabled you can always open the pawnshop.
	OpenHour = 9, -- From what hour should the pawnshop be open?
	CloseHour = 21, -- From what hour should the pawnshop be closed?
	ThirdPartyStorageSystem = true, -- true for disc-inventory
	StorageSlots = 70, -- max slots.
	StorageWeight = 500,
}

Config['delivery'] = {
	OutsideLocation = {x=746.83,y=-1399.66,z=26.6,a=230.732},
	
	InsideLocation = {x=993.16,y=-3097.61,z=-39.9,a=82.95},

	SellLocation = {x=1157.49,y=-3197.64,z=-39.01,a=267.6},
	PersonalStash = {x=994.64,y=-3100.34,z=-39.0,a=267.42}, -- Company Stash (Only Recycle Job Employees Use)
	TradeItems = {x=1162.79,y=-3190.79,z=-39.01,a=267.42},
	
	officeOut = {x= 1173.77,y= -3196.58,z = -39.00,a = 91.61 },
	officeIn = {x= 997.76,y= -3091.90,z = -39.0,a = 270.76 },

	PackagePickupLocations = {
		[1] = {x=1015.4642333984,y=-3110.4521484375,z=-38.99991607666,a=342.39},
		[2] = {x=1011.2679443359,y=-3110.8725585938,z=-38.99991607666,a=356.53},
		[3] = {x=1005.8571777344,y=-3108.6293945313,z=-38.99991607666,a=184.81},
		[4] = {x=1003.0407104492,y=-3104.7854003906,z=-38.999881744385,a=359.02},
		[5] = {x=1008.2990112305,y=-3106.94140625,z=-38.999881744385,a=0.95},
		[6] = {x=1010.9890136719,y=-3104.5573730469,z=-38.999881744385,a=347.64},
		[7] = {x=1013.3607788086,y=-3106.8874511719,z=-38.999881744385,a=180.26},
		[8] = {x=1017.8317260742,y=-3104.5822753906,z=-38.999881744385,a=180.46},
		[9] = {x=1019.0430297852,y=-3098.9851074219,z=-38.999881744385,a=174.22},
		[10] = {x=1013.7381591797,y=-3100.9680175781,z=-38.999881744385,a=189.44},
		[11] = {x=1009.3251342773,y=-3098.8120117188,z=-38.999881744385,a=182.11},
		[12] = {x=1005.9111938477,y=-3100.9387207031,z=-38.999881744385,a=176.23},
		[13] = {x=1003.2393798828,y=-3093.9182128906,z=-38.999885559082,a=188.28},
		[14] = {x=1008.0280151367,y=-3093.384765625,z=-38.999885559082,a=173.63},
		[15] = {x=1010.8000488281,y=-3093.544921875,z=-38.999885559082,a=179.46},
		[16] = {x=1016.1090087891,y=-3095.3405761719,z=-38.999885559082,a=174.32},
		[17] = {x=1018.2312011719,y=-3093.1293945313,z=-38.999885559082,a=177.77},
		[18] = {x=1025.1221923828,y=-3091.4680175781,z=-38.999885559082,a=183.88},
		[19] = {x=1024.9321289063,y=-3096.4670410156,z=-38.999885559082,a=181.36},
		
	},
	
	DropLocation = {x =999.17, y =-3112.27, z =-39.0, a = 274.810},
	
	DropLocationop = {
		[1] =  {x =1022.26, y =-3095.89, z =-39.0, a = 274.810},
		
	},
	WareHouseObjects = {
		"prop_toolchest_05",
	},
}

Config.Locations =  {
	['Recycle'] = { name = "Recycle Center", location = vector3(744.68,-1401.77, 26.55-1.03), heading = 248.73, blipTrue = true, Sprite = 365, Scale = 0.8, Colour = 2, }, -- The location where you enter the mine 
	['Trade'] = { name = "Recyclable Trader", location = vector3(996.58,-3098.45,-39.0-1.03), heading = 230.0, blipTrue = false, Sprite = 365, Scale = 0.8, Colour = 2, }, -- The location where you enter the mine 
	['BottleBank'] = { name = "Bottle Bank", location = vector3(757.06, -1399.68, 26.57-1.0), heading = 178.1, blipTrue = true, Sprite = 642, Scale = 0.8, Colour = 2,}, -- The location where you enter the mine 
	['BottleBank2'] = { name = "Bottle Bank", location = vector3(84.01,-220.32,54.64-1.0), heading = 337.89, blipTrue = true, Sprite = 642, Scale = 0.8, Colour = 2,}, -- The location where you enter the mine 
	['BottleBank3'] = { name = "Bottle Bank", location = vector3(31.88,-1315.58,29.52-1.0), heading = 357.19, blipTrue = true, Sprite = 642, Scale = 0.8, Colour = 2,}, -- The location where you enter the mine 
	['BottleBank4'] = { name = "Bottle Bank", location = vector3(29.08,-1769.99,29.61-1.0), heading = 50.0, blipTrue = true, Sprite = 642, Scale = 0.8, Colour = 2,}, -- The location where you enter the mine 
	['BottleBank5'] = { name = "Bottle Bank", location = vector3(394.08,-877.48,29.35-1.0), heading = 310.12, blipTrue = true, Sprite = 642, Scale = 0.8, Colour = 2,}, -- The location where you enter the mine 
	['BottleBank6'] = { name = "Bottle Bank", location = vector3(-1267.97,-812.08,17.11-1.0), heading = 128.12, blipTrue = true, Sprite = 642, Scale = 0.8, Colour = 2,}, -- The location where you enter the mine 

}


Config.ArmoryWhitelist = {
    "FUN28030",
    "HHV33808",
    "MWE31087",
    "UOH84809",
    "ONT04484",
    "SUC74168",
    "KGV59544",
    "OEJ87427",
}

Config.Prices = {
	['copper'] = { name = 'copper', amount = 10 },
	['plastic'] = { name = 'plastic', amount = 10 },
	['metalscrap'] = { name = 'metalscrap', amount = 10 },
	['steel'] = { name = 'steel', amount = 10 },
	['glass'] = { name = 'glass', amount = 10 },
	['iron'] = { name = 'iron', amount = 10 },
	['rubber'] = { name = 'rubber', amount = 10 },
	['aluminum'] = { name = 'aluminium', amount = 10 },
	['bottle'] = { name = 'bottle', amount = 5 },
}

Config.DumpItems = {
    "bottle", "bottle", "bottle", "bottle", "bottle", "bottle", "bottle", "bottle", "bottle", 
	"sandwich"
}

Config.tenmin = "2"
Config.tenmax = "5"

Config.bulkmin = "5"
Config.bulkmax = "14"

Config.PedList = { -- APPARENTLY You can call config locations IN the config, learn't that one today
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['Recycle'].location, heading = Config.Locations['Recycle'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = "u_m_y_militarybum", coords = Config.Locations['Trade'].location, heading = Config.Locations['Trade'].heading, gender = "male", }, --Trade
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['BottleBank'].location, heading = Config.Locations['BottleBank'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['BottleBank2'].location, heading = Config.Locations['BottleBank2'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['BottleBank3'].location, heading = Config.Locations['BottleBank3'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['BottleBank4'].location, heading = Config.Locations['BottleBank4'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['BottleBank5'].location, heading = Config.Locations['BottleBank5'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['BottleBank6'].location, heading = Config.Locations['BottleBank6'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
}