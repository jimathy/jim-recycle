
Config = {
	Lan = "en",
	System = {
		Debug = false, 			-- enable debug mode

		Menu = "ox",			-- "qb", "ox", "gta"
		ProgressBar = "gta",	-- "qb", "ox", "gta"
		Notify = "gta",			-- "qb", "ox", "gta"
		drawText = "gta",		-- "qb", "ox", "gta"

		skillCheck = "gta",		-- "qb", "ox", "gta"

		DontUseTarget = false,
	},
	Crafting = {
		showItemBox = true,
	},
}

Config.ScrapyardSearching = {
	Enable = true,
	searched = { }, -- No Touch
	models = { -- The mighty list of dumpters/trash cans
		`prop_wreckedcart`, `prop_snow_rub_trukwreck_2`, `prop_wrecked_buzzard`, `prop_rub_buswreck_01`, `prop_rub_buswreck_03`, `prop_rub_buswreck_06`, `prop_rub_carwreck_10`,
		`prop_rub_carwreck_11`, `prop_rub_carwreck_12`, `prop_rub_carwreck_13`, `prop_rub_carwreck_14`, `prop_rub_carwreck_15`, `prop_rub_carwreck_16`, `prop_rub_carwreck_17`,
		`prop_rub_carwreck_2`, `prop_rub_carwreck_3`, `prop_rub_carwreck_5`, `prop_rub_carwreck_7`, `prop_rub_carwreck_8`, `prop_rub_carwreck_9`, `prop_rub_railwreck_1`, `prop_rub_railwreck_2`,
		`prop_rub_railwreck_3`, `prop_rub_trukwreck_1`, `prop_rub_trukwreck_2`, `prop_rub_wreckage_3`, `prop_rub_wreckage_4`, `prop_rub_wreckage_5`, `prop_rub_wreckage_6`, `prop_rub_wreckage_7`,
		`prop_rub_wreckage_8`, `prop_rub_wreckage_9`, `ch1_01_sea_wreck_3`, `cs2_30_sea_ch2_30_wreck005`, `cs2_30_sea_ch2_30_wreck7`, `cs4_05_buswreck`,
	},
	searchTime = 5000,

	ScrapItems = {
		{item = "iron", 		rarity = 80, min = 3, max = 9},
		{item = "aluminum", 	rarity = 65, min = 3, max = 9},
		{item = "rubber", 		rarity = 70, min = 3, max = 7},
		{item = "glass",		rarity = 6, min = 1, max = 2},
		{item = "copper", 		rarity = 75, min = 2, max = 6},
		{item = "steel", 		rarity = 45, min = 3, max = 6},
		{item = "plastic", 		rarity = 75, min = 2, max = 9},
		{item = "metalscrap", 	rarity = 45, min = 2, max = 7},
	},
}

Config.DumpsterDiving = {
	Enable = true,
	searched = { }, -- No Touch
	models = { -- The mighty list of dumpters/trash cans
		`prop_dumpster_01a`, `prop_dumpster_02a`, `prop_dumpster_02b`, `prop_dumpster_3a`, `prop_dumpster_4a`, `prop_dumpster_4b`,
		`prop_bin_05a`, `prop_bin_06a`, `prop_bin_07a`, `prop_bin_07b`, `prop_bin_07c`, `prop_bin_07d`, `prop_bin_08a`, `prop_bin_08open`,
		`prop_bin_09a`, `prop_bin_10a`, `prop_bin_10b`, `prop_bin_11a`, `prop_bin_12a`, `prop_bin_13a`, `prop_bin_14a`, `prop_bin_14b`,
		`prop_bin_beach_01d`, `prop_bin_delpiero`, `prop_bin_delpiero_b`, `prop_recyclebin_01a`, `prop_recyclebin_02_c`, `prop_recyclebin_02_d`,
		`prop_recyclebin_02a`, `prop_recyclebin_02b`, `prop_recyclebin_03_a`, `prop_recyclebin_04_a`, --[[ `prop_recyclebin_04_b`, ]] `prop_recyclebin_05_a`,
		`zprop_bin_01a_old`, `hei_heist_kit_bin_01`, `ch_prop_casino_bin_01a`, `vw_prop_vw_casino_bin_01a`, `mp_b_kit_bin_01`,
	},
	searchTime = 3000,

	DumpItems = {
		{ item = 'can', 	rarity = 4 },
		{ item = 'bottle', 	rarity = 4 },
		{ item = 'plastic', rarity = 3 },
		{ item = 'glass', 	rarity = 2 },
		{ item = 'steel', 	rarity = 1 },
	},
}

Config.RecyclingCenter = {
	EnableOpeningHours = true, -- if enabled, players can only access at a certain time of day
	OpenHour = 9, -- From what hour should the pawnshop be open? ( 9 = 9 am )
	CloseHour = 21, -- From what hour should the pawnshop be closed? ( 21 = 9pm )

	PayAtDoor = 100, -- Set to nil to disable charge for entering warehouse

	propTable = { -- Table of crates that will spawn
		"ex_Prop_Crate_Bull_SC_02",
		"ex_prop_crate_wlife_bc",
		"ex_Prop_Crate_watch",
		"ex_Prop_Crate_SHide",
		"ex_Prop_Crate_Oegg",
		"ex_Prop_Crate_MiniG",
		"ex_Prop_Crate_FReel",
		"ex_Prop_Crate_Closed_BC",
		"ex_Prop_Crate_Jewels_BC",
		"ex_Prop_Crate_Art_02_SC",
		"ex_Prop_Crate_clothing_BC",
		"ex_Prop_Crate_biohazard_BC",
		"ex_Prop_Crate_Bull_BC_02",
		"ex_Prop_Crate_Art_BC",
		"ex_Prop_Crate_Money_BC",
		"ex_Prop_Crate_clothing_SC",
		"ex_Prop_Crate_Art_02_BC",
		"ex_Prop_Crate_Money_SC",
		"ex_Prop_Crate_Med_SC",
		"ex_Prop_Crate_Jewels_racks_BC",
		"ex_Prop_Crate_Jewels_SC",
		"ex_Prop_Crate_Med_BC",
		"ex_Prop_Crate_Gems_SC",
		"ex_Prop_Crate_Elec_SC",
		"ex_Prop_Crate_Tob_SC",
		"ex_Prop_Crate_Gems_BC",
		"ex_Prop_Crate_biohazard_SC",
		"ex_Prop_Crate_furJacket_SC",
		"ex_Prop_Crate_Expl_bc",
		"ex_Prop_Crate_Elec_BC",
		"ex_Prop_Crate_Tob_SC",
		"ex_Prop_Crate_Closed_BC",
		"ex_Prop_Crate_Narc_BC",
		"ex_Prop_Crate_Narc_SC",
		"ex_Prop_Crate_Tob_BC",
		"ex_Prop_Crate_furJacket_BC",
		"ex_Prop_Crate_HighEnd_pharma_BC",
		"prop_boxpile_05a",
		"prop_boxpile_04a",
		"prop_boxpile_06b",
		"prop_boxpile_02c",
		"prop_boxpile_02b",
		"prop_boxpile_01a",
		"prop_boxpile_08a",
	},
	scrapPool = {
		--{ model = ``, xPos = , yPos = , zPos = , xRot = , yRot = , zRot = },
		--{ model = `sf_prop_sf_art_box_cig_01a`, xPos = 0.16, yPos = -0.06, zPos = 0.21, xRot = 52.0, yRot = 288.0, zRot = 175.0},
		{ model = "hei_prop_drug_statue_box_01", xPos = 0.08, yPos = 0.05, zPos = 0.06, xRot = 7.0, yRot = 198.0, zRot = 145.0},
		{ model = "prop_mat_box", xPos = 0.0, yPos = 0.28, zPos = 0.36, xRot = 136.0, yRot = 114.0, zRot = 181.0},
		{ model = "prop_box_ammo03a", xPos = -0.08, yPos = 0.04, zPos = 0.32, xRot = 76.0, yRot = 110.0, zRot = 185.0},
		{ model = "prop_rub_scrap_06", xPos = 0.01, yPos = 0.02, zPos = 0.27, xRot = 85.0, yRot = 371.0, zRot = 177.0 },
		{ model = "prop_cs_cardbox_01", xPos = 0.04, yPos = 0.04, zPos = 0.28, xRot = 52.0, yRot = 294.0, zRot = 177.0 },
		{ model = "v_ret_gc_bag01", xPos = 0.16, yPos = 0.08, zPos = 0.24, xRot = 68.0, yRot = 394.0, zRot = 141.0 },
		{ model = "prop_ld_suitcase_01", xPos = -0.04, yPos = 0.06, zPos = 0.31, xRot = -2.0, yRot = 21.0, zRot = 155.0 },
		{ model = "v_ind_cs_toolbox2", xPos = 0.04, yPos = 0.12, zPos = 0.29, xRot = 56.0, yRot = 287.0, zRot = 169.0 },
	},
}

Config.Other = {
	Prices = {
		Header = Loc[Config.Lan].menu["sell_mats"],
		Items = {
			copper = 10,
			plastic = 10,
			metalscrap = 10,
			steel = 10,
			glass = 10,
			iron = 10,
			rubber = 10,
			aluminum = 10,
			bottle = 5,
			can = 5,
		},
	},
	BottleBankTable = {
		Header = Loc[Config.Lan].menu["sell_bottles"],
		Items = {
			bottle = 1,
			can = 1,
		},
	},
	TradeTable = {
		"copper",
		"plastic",
		"metalscrap",
		"steel",
		"glass",
		"iron",
		"rubber",
		"aluminum",
	},
	RecycleAmounts = {
		["Recycle"] = {
			Min = 2,
			Max = 5,
		},
		["Trade"] = {
			{ amount = 1, itemGive = 1, Min = 1, Max = 1, },
			{ amount = 10, itemGive = 10, Min = 5, Max = 10, },
			{ amount = 50, itemGive = 50, Min = 40, Max = 50, },
			{ amount = 100, itemGive = 100, Min = 70, Max = 100, },
		},
	}
}
