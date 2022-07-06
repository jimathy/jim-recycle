print("Jim-Recycle v2.0 - Recycling Script by Jimathy")

Config = {
	Debug = true, -- Toggle Debug Mode
	Blips = true, -- Enable Blips?
	BlipNamer = false, -- Enable to Name Blips different things, disable if you already have too many blips as this will group them together
	Pedspawn = true, -- Do you want to spawn peds for main locations?
	EnableOpeningHours = true, -- Enable opening hours? If disabled you can always open the pawnshop.
	OpenHour = 9, -- From what hour should the pawnshop be open?
	CloseHour = 21, -- From what hour should the pawnshop be closed?
	img = "qb-inventory/html/images/", -- Set this to your inventory
	RequireJob = false, -- Want this to be locked behind a job?
	JobRole = nil, -- Whats the job role you want to use this? "nil" for none

	OutsideTele = vector4(746.83, -1399.66, 26.6, 230.732),
	InsideTele = vector4(993.16, -3097.61, -39.90, 82.95),
	DropLocation = vector4(999.02, -3112.98, -39.90, 90.0),

	Locations =  {
		['Recycle'] = {
			{ name = "Recycle Center", coords = vector4(744.68, -1401.77, 26.55, 248.73), blipTrue = true, sprite = 365, col = 2, model = `S_M_Y_Construct_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
		},
		['Trade'] ={
			{ name = "Recyclable Trader", coords = vector4(996.58, -3098.45, -39.0, 230.0), blipTrue = false, sprite = 365, col = 2, model = `S_M_Y_Construct_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
		},
		['BottleBanks'] = {
			{ name = "Bottle Bank", coords = vector4(757.06, -1399.68, 26.57 , 178.1), blipTrue = true, sprite = 642, col = 2, model = `S_M_Y_Construct_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
			{ name = "Bottle Bank", coords = vector4(84.01, -220.32, 54.64 , 337.89), blipTrue = true, sprite = 642, col = 2, model = `S_M_Y_Construct_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
			{ name = "Bottle Bank", coords = vector4(31.88, -1315.58, 29.52 , 357.19), blipTrue = true, sprite = 642, col = 2, model = `S_M_Y_Construct_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
			{ name = "Bottle Bank", coords = vector4(29.08, -1769.99, 29.61 , 50.0), blipTrue = true, sprite = 642, col = 2, model = `S_M_Y_Construct_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
			{ name = "Bottle Bank", coords = vector4(394.08, -877.48, 29.35 , 310.12), blipTrue = true, sprite = 642, col = 2, model = `S_M_Y_Construct_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
			{ name = "Bottle Bank", coords = vector4(-1267.97, -812.08, 17.11 , 128.12), blipTrue = true, sprite = 642, col = 2, model = `S_M_Y_Construct_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
		},
	},

	Prices = {
		['copper'] = { amount = 10 },
		['plastic'] = { amount = 10 },
		['metalscrap'] = { amount = 10 },
		['steel'] = { amount = 10 },
		['glass'] = { amount = 10 },
		['iron'] = { amount = 10 },
		['rubber'] = { amount = 10 },
		['aluminum'] = { amount = 10 },
		['bottle'] = {amount = 5 },
		['can'] = { amount = 5 },
	},

	TradeTable = {
		"metalscrap",
		"plastic",
		"copper",
		"iron",
		"aluminum",
		"steel",
		"glass",
		"rubber",
		"bottle",
		"can",
	},
	DumpItems = {
		"bottle",
		"can",
		"sandwich",
	},
	RecycleAmounts = {
		tenmin = "2",
		tenmax = "5",

		bulkmin = "5",
		bulkmax = "14",
	}
}
