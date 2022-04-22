print("Jim-Recycle - Recycling Script by Jimathy")

Config = {}

Config = {
	Debug = false, -- Toggle Debug Mode
	Blips = true, -- Enable Blips?
	BlipNamer = false, -- Enable to Name Blips different things, disable if you already have too many blips as this will group them together
	Pedspawn = true, -- Do you want to spawn peds for main locations?
	EnableOpeningHours = true, -- Enable opening hours? If disabled you can always open the pawnshop.
	OpenHour = 9, -- From what hour should the pawnshop be open?
	CloseHour = 21, -- From what hour should the pawnshop be closed?
	img = "qb-inventory/html/images/", -- Set this to your inventory
	RequireJob = false, -- Want this to be locked behind a job?
	JobRole = "mechanic", -- Whats the job role you want to use this?
}

Config['delivery'] = {
	OutsideLocation = vector4(746.83, -1399.66, 26.6, 230.732),
	InsideLocation = vector4(993.16, -3097.61, -39.9, 82.95),
	DropLocation = vector4(999.17, -3112.27, -39.0, 274.810),
	PackagePickupLocations = {
		[1] = vector4(1015.4642333984, -3110.4521484375, -38.99991607666, 342.39),
		[2] = vector4(1011.2679443359, -3110.8725585938, -38.99991607666, 356.53),
		[3] = vector4(1005.8571777344, -3108.6293945313, -38.99991607666, 184.81),
		[4] = vector4(1003.0407104492, -3104.7854003906, -38.999881744385, 359.02),
		[5] = vector4(1008.2990112305, -3106.9414062500, -38.999881744385, 0.95),
		[6] = vector4(1010.9890136719, -3104.5573730469, -38.999881744385, 347.64),
		[7] = vector4(1013.3607788086, -3106.8874511719, -38.999881744385, 180.26),
		[8] = vector4(1017.8317260742, -3104.5822753906, -38.999881744385, 180.46),
		[9] = vector4(1019.0430297852, -3098.9851074219, -38.999881744385, 174.22),
		[10] = vector4(1013.7381591797, -3100.9680175781, -38.999881744385, 189.44),
		[11] = vector4(1009.3251342773, -3098.8120117188, -38.999881744385, 182.11),
		[12] = vector4(1005.9111938477, -3100.9387207031, -38.999881744385, 176.23),
		[13] = vector4(1003.2393798828, -3093.9182128906, -38.999885559082, 188.28),
		[14] = vector4(1008.0280151367, -3093.384765625, -38.999885559082, 173.63),
		[15] = vector4(1010.8000488281, -3093.544921875, -38.999885559082, 179.46),
		[16] = vector4(1016.1090087891, -3095.3405761719, -38.999885559082, 174.32),
		[17] = vector4(1018.2312011719, -3093.1293945313, -38.999885559082, 177.77),
		[18] = vector4(1025.1221923828, -3091.4680175781, -38.999885559082, 183.88),
		[19] = vector4(1024.9321289063, -3096.4670410156, -38.999885559082, 181.36),
	},
}

Config.Locations =  {
	['Recycle'] = { name = "Recycle Center", location = vector4(744.68,-1401.77, 26.55-1.03, 248.73), blipTrue = true, Sprite = 365, Scale = 0.8, Colour = 2, }, -- The location where you enter the mine 
	['Trade'] = { name = "Recyclable Trader", location = vector4(996.58,-3098.45,-39.0-1.03, 230.0), blipTrue = false, Sprite = 365, Scale = 0.8, Colour = 2, }, -- The location where you enter the mine 
	['BottleBank1'] = { name = "Bottle Bank", location = vector4(757.06, -1399.68, 26.57-1.0, 178.1), blipTrue = true, Sprite = 642, Scale = 0.7, Colour = 2,}, -- The location where you enter the mine 
	['BottleBank2'] = { name = "Bottle Bank", location = vector4(84.01,-220.32,54.64-1.0, 337.89), blipTrue = true, Sprite = 642, Scale = 0.7, Colour = 2,}, -- The location where you enter the mine 
	['BottleBank3'] = { name = "Bottle Bank", location = vector4(31.88,-1315.58,29.52-1.0, 357.19), blipTrue = true, Sprite = 642, Scale = 0.7, Colour = 2,}, -- The location where you enter the mine 
	['BottleBank4'] = { name = "Bottle Bank", location = vector4(29.08,-1769.99,29.61-1.0, 50.0), blipTrue = true, Sprite = 642, Scale = 0.7, Colour = 2,}, -- The location where you enter the mine 
	['BottleBank5'] = { name = "Bottle Bank", location = vector4(394.08,-877.48,29.35-1.0, 310.12), blipTrue = true, Sprite = 642, Scale = 0.7, Colour = 2,}, -- The location where you enter the mine 
	['BottleBank6'] = { name = "Bottle Bank", location = vector4(-1267.97,-812.08,17.11-1.0, 128.12), blipTrue = true, Sprite = 642, Scale = 0.7, Colour = 2,}, -- The location where you enter the mine 

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
	['can'] = { name = 'bottle', amount = 5 },
}

Config.TradeTable = {
    [1] = "metalscrap",
    [2] = "plastic",
    [3] = "copper",
    [4] = "iron",
    [5] = "aluminum",
	[6] = "steel",
    [7] = "glass",
    [8] = "rubber",
	[9] = "bottle",
	[10] = "can",
}

Config.DumpItems = {
	[1] = "bottle",
	[2] = "can",
	[3] = "sandwich",
}

Config.tenmin = "2"
Config.tenmax = "5"

Config.bulkmin = "5"
Config.bulkmax = "14"

Config.PedList = { -- APPARENTLY You can call config locations IN the config, learn't that one today
	{ model = `S_M_Y_Construct_01`, coords = Config.Locations['Recycle'].location, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = `S_M_Y_Construct_01`, coords = Config.Locations['Trade'].location, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, --Trade
	{ model = `S_M_Y_Construct_01`, coords = Config.Locations['BottleBank1'].location, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = `S_M_Y_Construct_01`, coords = Config.Locations['BottleBank2'].location, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = `S_M_Y_Construct_01`, coords = Config.Locations['BottleBank3'].location, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = `S_M_Y_Construct_01`, coords = Config.Locations['BottleBank4'].location, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = `S_M_Y_Construct_01`, coords = Config.Locations['BottleBank5'].location, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = `S_M_Y_Construct_01`, coords = Config.Locations['BottleBank6'].location, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
}