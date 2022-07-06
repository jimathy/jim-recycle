print("Jim-Recycle v2.0 - Recycling Script by Jimathy")

Config = {
	Debug = false, -- Toggle Debug Mode
	Blips = true, -- Enable Blips?
	BlipNamer = false, -- Enable to Name Blips different things, disable if you already have too many blips as this will group them together
	Pedspawn = true, -- Do you want to spawn peds for main locations?
	img = "qb-inventory/html/images/", -- Set this to your inventory
	JimMenu = false, -- If using updated qb-menu icons, set this true
	JobRole = nil, -- Whats the job role you want to use this? "nil" for none
	EnableOpeningHours = true, -- Enable opening hours? If disabled you can always open the pawnshop.
	OpenHour = 9, -- From what hour should the pawnshop be open?
	CloseHour = 21, -- From what hour should the pawnshop be closed?
	useQBLock = false, -- Enable to use qb-lock instead of qb-skillbar when searching

	OutsideTele = vector4(746.83, -1399.66, 26.6, 230.732),
	InsideTele = vector4(993.16, -3097.61, -39.90, 82.95),
	DropLocation = vector4(999.02, -3112.98, -39.90, 90.0),

	Locations =  {
		['Recycle'] = {
			{ name = "Recycle Center", coords = vector4(744.68, -1401.77, 26.55, 248.73), blipTrue = true, sprite = 365, col = 2, model = `S_M_Y_Construct_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
		},
		['Trade'] ={
			{ name = "Recyclable Trader", coords = vector4(997.48, -3097.44, -39.0, 234.53), blipTrue = false, sprite = 365, col = 2, model = `S_M_Y_Construct_01`, scenario = "WORLD_HUMAN_CLIPBOARD", },
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
		['copper'] = 10,
		['plastic'] = 10,
		['metalscrap'] = 10,
		['steel'] = 10,
		['glass'] = 10,
		['iron'] = 10,
		['rubber'] = 10,
		['aluminum'] = 10,
		['bottle'] = 5,
		['can'] = 5,
	},
	DumpItems = {
		"bottle",
		"can",
		"sandwich",
	},
	ScrapItems = {
		"steel",
		"copper",
		"iron",
		"glass",
		"bottle",
		"can",
	},
	RecycleAmounts = {
		tenMin = "2",
		tenMax = "5",

		hundMin = "5",
		hundMax = "14",

		thouMin = "10",
		thouMax = "28",
	}
}