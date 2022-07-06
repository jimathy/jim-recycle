local QBCore = exports['qb-core']:GetCoreObject()

PlayerJob = {}
onDuty = false
peds = {}
Targets = {}
searchProps = {}
props = {}
scrapPool = {
	{ model = `prop_rub_scrap_06`, rot1 = 300.0, rot2 = 130.0 },
	{ model = `prop_cs_cardbox_01`, rot1 = 300.0, rot2 = 250.0 },
	{ model = `v_ret_gc_bag01`, rot1 = 300.0, rot2 = 130.0 },
}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job
		if PlayerData.job.name == Config.JobRole then if PlayerData.job.onduty then TriggerServerEvent("QBCore:ToggleDuty") end end end)
end)

RegisterNetEvent('QBCore:Client:SetDuty') AddEventHandler('QBCore:Client:SetDuty', function(duty) onDuty = duty end)

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job if PlayerData.job.name == Config.JobRole then onDuty = PlayerJob.onduty end end)
end)
--Don't even try to ask me how this works, found it on a tutorial site for organising tables
function pairsByKeys(t) local a = {} for n in pairs(t) do a[#a+1] = n end table.sort(a)	local i = 0	local iter = function () i = i + 1 if a[i] == nil then return nil else return a[i], t[a[i]]	end	end	return iter end
function loadAnimDict(dict) if Config.Debug then print("Debug: Loading Anim Dictionary: '"..dict.."'") end while not HasAnimDictLoaded(dict) do RequestAnimDict(dict) Wait(5) end end
function unloadAnimDict(dict) if Config.Debug then print("Debug: Removing Anim Dictionary: '"..dict.."'") end RemoveAnimDict(dict) end
function loadModel(model) if Config.Debug then print("Debug: Loading Model: '"..model.."'") end RequestModel(model) while not HasModelLoaded(model) do Wait(0) end end
function unloadModel(model) if Config.Debug then print("Debug: Removing Model: '"..model.."'") end SetModelAsNoLongerNeeded(model) end
function destroyProp(entity) if Config.Debug then print("Debug: Destroying Prop: '"..entity.."'") end SetEntityAsMissionEntity(entity) Wait(5) DetachEntity(entity, true, true) Wait(5) DeleteObject(entity) end

--- Blips + Peds
CreateThread(function()
	--if Config.Pedspawn then CreatePeds() end
	for k, v in pairs(Config.Locations) do
		for i = 1, #v do
			local v = v[i]
			if Config.Blips and v.blipTrue then
				local blip = AddBlipForCoord(v.coords)
				SetBlipAsShortRange(blip, true)
				SetBlipSprite(blip, v.sprite)
				SetBlipColour(blip, v.col)
				SetBlipScale(blip, 0.7)
				SetBlipDisplay(blip, 6)
				BeginTextCommandSetBlipName('STRING')
				if Config.BlipNamer then AddTextComponentString(v.name)
				else AddTextComponentString("Recycling") end
				EndTextCommandSetBlipName(blip)
			end
			if Config.Pedspawn then
				loadModel(v.model)
				peds[#peds+1] = CreatePed(0, v.model, v.coords.x, v.coords.y, v.coords.z-1.03, v.coords[4], false, false)
				SetEntityInvincible(peds[#peds], true)
				SetBlockingOfNonTemporaryEvents(peds[#peds], true)
				FreezeEntityPosition(peds[#peds], true)
				TaskStartScenarioInPlace(peds[#peds], v.scenario, 0, true)
				if Config.Debug then print("Debug: Ped Created") end
			end
		end
	end
	--Make Targets
	Targets["RecyclingEnter"] =
		exports['qb-target']:AddBoxZone("RecyclingEnter", vector3(746.82, -1398.93, 26.55), 0.4, 1.6, { name="RecyclingEnter", debugPoly=Config.Debug, minZ=25.2, maxZ=28.0 },
			{ options = { { event = "jim-recycle:TeleWareHouse", icon = "fas fa-recycle", label = "Enter Warehouse", enter = true, job = Config.Job }, },
			distance = 1.5 })

	Targets["RecyclingExit"] =
		exports['qb-target']:AddBoxZone("RecyclingExit", vector3(991.97, -3097.81, -39.0), 1.6, 0.4, { name="RecyclingExit", debugPoly=Config.Debug, useZ=true, },
    		{ options = { { event = "jim-recycle:TeleWareHouse", icon = "fas fa-recycle", label = "Exit Warehouse", enter =  false }, },
			distance = 1.5 })

	Targets["RecycleDuty"] =
   		exports['qb-target']:AddCircleZone("RecycleDuty", vector3(995.36, -3099.91, -39.2), 0.45, { name="RecycleDuty", debugPoly=Config.Debug, useZ=true, },
    		{ options = { { event = "jim-recycle:dutytoggle", icon = "fas fa-hard-hat", label = "Toggle Recycling Duty", job = Config.Job }, },
			distance = 1.5 })
	--Recyclable Material Trader
	for i = 1, #Config.Locations["Trade"] do
		Targets["Trade"..i] =
			exports['qb-target']:AddCircleZone("Trade"..i, Config.Locations["Trade"][i].coords, 1.1, { name="Trade"..i, debugPoly=Config.Debug, useZ=true, },
				{ options = { { event = "jim-recycle:Trade:Menu", icon = "fas fa-box", label = "Trade Materials"  }, },
				distance = 1.5 })
	end
	--Sell Materials
	for i = 1, #Config.Locations["Recycle"] do
		Targets["Recycle"..i] =
			exports['qb-target']:AddCircleZone("Recycle"..i, Config.Locations["Recycle"][i].coords, 1.1, { name="Recycle"..i, debugPoly=Config.Debug, useZ=true, },
				{ options = { { event = "jim-recycle:Selling:Menu", icon = "fas fa-box", label = "Sell Materials" }, },
				distance = 2.5 })
	end
	--Bottle Selling Third Eyes
	for i = 1, #Config.Locations["BottleBanks"] do
		Targets["BottleBank"..i] =
			exports['qb-target']:AddCircleZone("BottleBank"..i, Config.Locations["BottleBanks"][i].coords, 1.2,	{ name="BottleBank"..i, debugPoly=Config.Debug, useZ=true, },
				{ options = { { event = "jim-recycle:Bottle:Menu", icon = "fas fa-certificate", label = "Sell Bottles", job = Config.Job  }, },
				distance = 1.5 })
	end
end)
---- Render Props -------
function MakeProps()
	for _, v in pairs(searchProps) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
	for _, v in pairs(props) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
	--Floor Level Props (Using these for the selection pool)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Bull_SC_02`,		1003.63, -3108.50, -39.96, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_prop_crate_wlife_bc`,		1018.18, -3102.80, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_watch`,			1013.33, -3102.80, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_SHide`,			1018.18, -3096.95, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Oegg`,			1006.05, -3091.60, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_MiniG`,			1018.18, -3108.50, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_FReel`,			1008.48, -3102.80, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,		1015.75, -3102.80, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Jewels_BC`,		1018.18, -3091.60, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Jewels_BC`,		1003.63, -3091.60, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Art_02_SC`,		1010.90, -3108.50, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Bull_SC_02`,		1010.90, -3096.95, -39.86, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_clothing_BC`,		1008.48, -3096.95, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_biohazard_BC`,	1010.90, -3102.80, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Bull_BC_02`,		1006.05, -3108.50, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Art_BC`,			1015.75, -3108.50, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Money_BC`,		1003.63, -3096.95, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_clothing_SC`,		1013.33, -3091.60, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Art_02_BC`,		1013.33, -3108.50, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Money_SC`,		1010.90, -3091.60, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Med_SC`,			1008.48, -3091.60, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Bull_SC_02`,		1008.48, -3108.50, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Jewels_racks_BC`,	1003.63, -3102.80, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Money_SC`,		1006.05, -3096.95, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Money_SC`,		1015.75, -3091.60, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Bull_SC_02`,		1015.75, -3096.95, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Jewels_SC`,		1006.05, -3102.80, -39.99, 0, 0, 0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Bull_BC_02`,		1013.33, -3096.95, -39.99, 0, 0, 0)
	--These needed headings adjusting
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Bull_BC_02`,		1026.75, -3096.43, -39.99, 0, 0, 0) SetEntityHeading(searchProps[#searchProps], -90.0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Jewels_BC`,		1026.75, -3106.52, -39.99, 0, 0, 0) SetEntityHeading(searchProps[#searchProps], -90.0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Bull_BC_02`,		1026.75, -3091.59, -39.99, 0, 0, 0) SetEntityHeading(searchProps[#searchProps], -90.0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Jewels_racks_SC`,	1026.75, -3111.38, -39.99, 0, 0, 0) SetEntityHeading(searchProps[#searchProps], -90.0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Jewels_BC`,		1026.75, -3108.88, -39.99, 0, 0, 0) SetEntityHeading(searchProps[#searchProps], -90.0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_XLDiam`,			1026.75, -3094.01, -39.99, 0, 0, 0) SetEntityHeading(searchProps[#searchProps], -90.0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Art_02_BC`,		993.355, -3106.60, -39.99, 0, 0, 0) SetEntityHeading(searchProps[#searchProps], 90.0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Art_SC`,			993.355, -3111.30, -39.99, 0, 0, 0) SetEntityHeading(searchProps[#searchProps], 90.0)
	searchProps[#searchProps+1] = CreateObject(`ex_Prop_Crate_Art_BC`,			993.355, -3108.95, -39.99, 0, 0, 0) SetEntityHeading(searchProps[#searchProps], 90.0)

	--Second Level
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1006.05, -3096.95, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_prop_crate_wlife_sc`,			1003.63, -3102.80, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_prop_crate_jewels_racks_sc`,		1003.63, -3091.60, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_SC`,				1013.33, -3096.95, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_SC`,				1008.48, -3108.50, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Tob_SC`,				1018.18, -3096.95, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_SC`,				1013.33, -3108.50, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_biohazard_BC`,		1003.63, -3108.50, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_RW`,			1013.33, -3091.60, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Ammo_BC`,				1013.33, -3102.80, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_BC`,				1003.63, -3096.95, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_biohazard_SC`,		1006.05, -3108.50, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1015.75, -3096.95, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_HighEnd_pharma_SC`,	1015.75, -3091.60, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_SC`,				1018.18, -3102.80, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_BC`,				1018.18, -3108.50, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1008.48, -3102.80, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_HighEnd_pharma_BC`,	1018.18, -3091.60, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_BC`,				1015.75, -3102.80, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_furJacket_SC`,		1006.05, -3102.80, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Expl_bc`,				1010.90, -3102.80, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,				1010.90, -3108.50, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_BC`,				1010.90, -3096.95, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Tob_SC`,				1010.90, -3091.60, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_SC`,				1015.75, -3108.50, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1008.48, -3091.60, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1008.48, -3096.60, -37.81, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_SC`,			1006.05, -3091.60, -37.81, 0, 0, 0)
	--These needed headings adjusting
	props[#props+1] = CreateObject(`ex_Prop_Crate_Med_BC`,				1026.75, -3106.52, -37.81, 0, 0, 0) SetEntityHeading(props[#props], -90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1026.75, -3111.38, -37.81, 0, 0, 0) SetEntityHeading(props[#props], -90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Narc_BC`,				1026.75, -3091.59, -37.81, 0, 0, 0) SetEntityHeading(props[#props], -90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Narc_SC`,				1026.75, -3094.01, -37.81, 0, 0, 0) SetEntityHeading(props[#props], -90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Med_SC`,				1026.75, -3108.88, -37.81, 0, 0, 0) SetEntityHeading(props[#props], -90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_pharma_SC`,			1026.75, -3096.43, -37.81, 0, 0, 0) SetEntityHeading(props[#props], -90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_BC_02`,			993.355, -3106.60, -37.81, 0, 0, 0) SetEntityHeading(props[#props], 90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_BC_02`,			993.355, -3111.30, -37.81, 0, 0, 0) SetEntityHeading(props[#props], 90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Bull_SC_02`,			993.355, -3108.95, -37.81, 0, 0, 0) SetEntityHeading(props[#props], 90.0)

	--Third Level
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1013.33, -3102.80, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1015.75, -3102.80, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_BC`,				1013.33, -3108.50, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_BC`,				1015.75, -3108.50, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_clothing_BC`,			1018.18, -3096.95, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Gems_BC`,				1003.63, -3108.50, -35.61, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Wlife_BC`,			1018.18, -3091.60, -35.74, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Med_BC`,				1008.48, -3091.60, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Wlife_BC`,			1015.75, -3091.60, -35.74, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,				1008.48, -3096.95, -35.60, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,				1010.90, -3096.95, -35.60, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1010.90, -3091.60, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_furJacket_BC`,		1013.33, -3091.60, -35.74, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_HighEnd_pharma_BC`,	1003.63, -3091.60, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_02_BC`,			1013.33, -3096.95, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Tob_BC`,				1010.90, -3108.50, -35.75, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_02_BC`,			1018.18, -3108.50, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1003.63, -3096.95, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,				1006.05, -3096.95, -35.60, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,				1006.05, -3102.80, -35.60, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Art_BC`,				1015.75, -3096.95, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,				1010.90, -3102.80, -35.60, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,				1008.48, -3102.80, -35.60, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1006.05, -3091.60, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1006.05, -3108.50, -35.62, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Tob_BC`,				1018.18, -3102.80, -35.75, 0, 0, 0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Tob_BC`,				1008.48, -3108.50, -35.75, 0, 0, 0)
	--These needed headings adjusting
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1026.75, -3106.52, -35.62, 0, 0, 0) SetEntityHeading(props[#props], -90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1026.75, -3108.88, -35.62, 0, 0, 0) SetEntityHeading(props[#props], -90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Closed_BC`,			1026.75, -3111.38, -35.62, 0, 0, 0) SetEntityHeading(props[#props], -90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_furJacket_BC`,		1026.75, -3091.59, -35.74, 0, 0, 0) SetEntityHeading(props[#props], -90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_furJacket_BC`,		1026.75, -3094.01, -35.74, 0, 0, 0) SetEntityHeading(props[#props], -90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_furJacket_BC`,		1026.75, -3096.43, -35.74, 0, 0, 0) SetEntityHeading(props[#props], -90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,				993.355, -3106.60, -35.60, 0, 0, 0) SetEntityHeading(props[#props], 90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_BC`,				993.355, -3111.30, -35.60, 0, 0, 0) SetEntityHeading(props[#props], 90.0)
	props[#props+1] = CreateObject(`ex_Prop_Crate_Elec_SC`,				993.355, -3108.95, -35.62, 0, 0, 0) SetEntityHeading(props[#props], 90.0)

	--props[#props+1] = CreateObject(`prop_toolchest_05`,					1002.04, -3108.36, -39.99, 0, 0, 0) SetEntityHeading(props[#props], -90.0)

	TrollyProp = CreateObject(`prop_large_gold_empty`, 999.32, -3093.2, -39.78, 0, 0, 0) FreezeEntityPosition(TrollyProp, true) SetEntityHeading(TrollyProp, 346.38)
end
function EndJob()
	if Targets["Package"] then exports["qb-target"]:RemoveTargetEntity(randPackage, "Search") end
	if Targets["DropOff"] then exports["qb-target"]:RemoveTargetEntity(TrollyProp, "Drop Off") end
	unloadModel(GetEntityModel(TrollyProp)) DeleteObject(TrollyProp)
	for i = 1, #searchProps do SetEntityDrawOutline(searchProps[i], false) end
	randPackage = nil
	if scrapProp then
		destroyProp(scrapProp)
		scrapProp = nil
	end
end
--Pick one of the crates for the player to choose, generate outline + target
function PickRandomPackage()
	--If somehow already exists, remove target
	if Targets["Package"] then exports["qb-target"]:RemoveTargetEntity(randPackage, "Search") end
	--Pick random prop to use
	randPackage = searchProps[math.random(1, #searchProps)]
	SetEntityDrawOutline(randPackage, true)
	SetEntityDrawOutlineColor(255, 255, 255, 1.0)
	SetEntityDrawOutlineShader(1)
	--Generate Target Location on the selected package
	Targets["Package"] =
		exports['qb-target']:AddTargetEntity(randPackage,
			{ options = { { event = "jim-recycle:PickupPackage:Start", icon = 'fas fa-magnifying-glass', label = 'Search', } },
			distance = 2.5,	})
end
--Event to enter and exit warehouse
RegisterNetEvent("jim-recycle:TeleWareHouse", function(data)
	if data.enter then
		if Config.EnableOpeningHours then
			local ClockTime = GetClockHours()
			if ClockTime >= Config.OpenHour and ClockTime <= Config.CloseHour - 1 then
				if (ClockTime >= Config.OpenHour and ClockTime < 24) or (ClockTime <= Config.CloseHour -1 and ClockTime > 0) then
					MakeProps()
					DoScreenFadeOut(500)
					while not IsScreenFadedOut() do	Citizen.Wait(10) end
					SetEntityCoords(PlayerPedId(), Config.InsideTele)
					DoScreenFadeIn(500)
				else
					TriggerEvent("QBCore:Notify", "We're currently closed, we're open from "..Config.OpenHour..":00am till "..Config.CloseHour..":00pm", "error")
				end
			else
				TriggerEvent("QBCore:Notify", "We're currently closed, we're open from "..Config.OpenHour..":00 until "..Config.CloseHour..":00pm", "error")
			end
		else
			MakeProps()
			DoScreenFadeOut(500)
			while not IsScreenFadedOut() do	Citizen.Wait(10) end
			SetEntityCoords(PlayerPedId(), Config.InsideTele)
			DoScreenFadeIn(500)
		end
	else
		--When leaving building, deleteprops and clear prop tables
		for _, v in pairs(props) do unloadModel(GetEntityModel(v)) DeleteObject(v) end props = {}
		for _, v in pairs(searchProps) do unloadModel(GetEntityModel(v)) DeleteObject(v) end searchProps = {}
		EndJob() -- Resets outlines + targets if needed
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do	Citizen.Wait(10) end
		if onDuty then TriggerEvent('jim-recycle:dutytoggle') end
		SetEntityCoords(PlayerPedId(), Config.OutsideTele)
		DoScreenFadeIn(500)
	end
end)

RegisterNetEvent("jim-recycle:PickupPackage:Start", function()
	TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_KNEEL", 0, true)
	QBCore.Functions.Progressbar("open_locker_drill", "Searching", 5000, false, true, {
		disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
		ClearPedTasksImmediately(PlayerPedId())
		TriggerEvent("jim-recycle:PickupPackage:Hold")
	end, function() -- Cancel
	end, "fas fa-magnifying-glass")
end)
RegisterNetEvent("jim-recycle:PickupPackage:Hold", function()
	--Clear current target info
	exports["qb-target"]:RemoveTargetEntity(randPackage, "Search")
	SetEntityDrawOutline(randPackage, false)
	randPackage = nil

	--Make prop to put in hands
	loadAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
	randomScrap = scrapPool[math.random(1, #scrapPool)]
    loadModel(randomScrap.model)
    scrapProp = CreateObject(randomScrap.model, GetEntityCoords(PlayerPedId(), true), true, true, true)
    AttachEntityToEntity(scrapProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.05, 0.1, -0.3, randomScrap.rot1, randomScrap.rot2, 20.0, true, true, false, true, 1, true)
	--Create target for drop off location
	SetEntityDrawOutline(TrollyProp, true)
	SetEntityDrawOutlineColor(255, 255, 255, 1.0)
	SetEntityDrawOutlineShader(1)
	Targets["DropOff"] =
		exports['qb-target']:AddTargetEntity(TrollyProp,
			{ options = { { event = "jim-recycle:PickupPackage:Finish", icon = 'fas fa-recycle', label = 'Drop Off', } },
			distance = 2.5,	})

end)
RegisterNetEvent("jim-recycle:PickupPackage:Finish", function()
	--One this is triggered it can't be stopped, so remove the target
	exports["qb-target"]:RemoveTargetEntity(TrollyProp, "Drop Off")
	SetEntityDrawOutline(TrollyProp, false)
	--Load and Start animation
	local dict = "mp_car_bomb" loadAnimDict("mp_car_bomb")
	local anim = "car_bomb_mechanic"
    local isScrapping = true
	FreezeEntityPosition(PlayerPedId(), true)
	Wait(100)
	TaskPlayAnim(PlayerPedId(), dict, anim, 3.0, 3.0, -1, 2.0, 0, 0, 0, 0)
	Wait(3000)
	--When animation is complete
	--Empty hands
	destroyProp(scrapProp)
    scrapProp = nil
	ClearPedTasks(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), false)
	TriggerServerEvent('jim-recycle:getrecyclablematerial') -- Give rewards
	PickRandomPackage()
end)

RegisterNetEvent('jim-recycle:dutytoggle', function()
	if Config.JobRole then
		if onDuty then EndJob() else PickRandomPackage() end
		TriggerServerEvent("QBCore:ToggleDuty")
	else
		onDuty = not onDuty
		if onDuty then TriggerEvent('QBCore:Notify', 'You went on duty', 'success') PickRandomPackage()
		else TriggerEvent('QBCore:Notify', 'You went off duty', 'error') EndJob() end
	end
end)

RegisterNetEvent('jim-recycle:SellAnim', function(item)
	for _, v in pairs (peds) do
      	if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(v)) < 3 then
			loadAnimDict("mp_common")
			loadAnimDict("amb@prop_human_atm@male@enter")
			local model = `prop_paper_bag_small`
			loadModel(model)
			if bag == nil then bag = CreateObject(model, 0.0, 0.0, 0.0, true, false, false) end
			AttachEntityToEntity(bag, v, GetPedBoneIndex(v, 57005), 0.1, -0.0, 0.0, -90.0, 0.0, 0.0, true, true, false, true, 1, true)
			--Calculate if you're facing the ped--
			ClearPedTasksImmediately(v)
			if not IsPedHeadingTowardsPosition(PlayerPedId(), GetEntityCoords(v), 20.0) then TaskTurnPedToFaceCoord(PlayerPedId(), GetEntityCoords(v), 1500) Wait(1500) end
			TaskPlayAnim(PlayerPedId(), "amb@prop_human_atm@male@enter", "enter", 1.0, 1.0, 0.3, 16, 0.2, 0, 0, 0)	--Start animations
            TaskPlayAnim(v, "mp_common", "givetake2_b", 1.0, 1.0, 0.3, 16, 0.2, 0, 0, 0)
			Wait(1000)
			AttachEntityToEntity(bag, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.1, -0.0, 0.0, -90.0, 0.0, 0.0, true, true, false, true, 1, true)
            Wait(1000)
            StopAnimTask(PlayerPedId(), "amb@prop_human_atm@male@enter", "enter", 1.0)
			StopAnimTask(v, "mp_common", "givetake2_b", 1.0)
			TaskStartScenarioInPlace(v, "WORLD_HUMAN_CLIPBOARD", -1, true)
			unloadAnimDict("mp_common")
			unloadAnimDict("amb@prop_human_atm@male@enter")
			destroyProp(bag) unloadModel(model)
			bag = nil
			for k in pairs(Config.Prices) do
				if k == item then TriggerServerEvent('jim-recycle:Selling:Mat', item) return end
			end
			TriggerServerEvent("jim-recycle:TradeItems", item)
		end
	end
end)

RegisterNetEvent('jim-recycle:Selling:Menu', function()
	local sellMenu = {
		{ icon = "recyclablematerial", header = "Material Selling", txt = "Sell batches of materials", isMenuHeader = true },
		{ icon = "fas fa-circle-xmark", header = "", txt = "Close", params = { event = "jim-recycle:CloseMenu" } } }
	for k, v in pairsByKeys(Config.Prices) do
		local p = promise.new() QBCore.Functions.TriggerCallback("QBCore:HasItem", function(cb) p:resolve(cb) end, k)
		sellMenu[#sellMenu+1] = {
			hidden = not Citizen.Await(p),
			icon = k,
			header = "<img src=nui://"..Config.img..QBCore.Shared.Items[k].image.." width=30px onerror='this.onerror=null; this.remove();'> "..QBCore.Shared.Items[k].label,
			txt = "Sell All for $"..v.." each",
			params = { event = "jim-recycle:SellAnim", args = k } }
		Wait(10)
	end
    exports['qb-menu']:openMenu(sellMenu)
end)

--Recyclable Trader
RegisterNetEvent('jim-recycle:Trade:Menu', function()
	local p = promise.new() QBCore.Functions.TriggerCallback("jim-recycle:GetRecyclable", function(cb) p:resolve(cb) end) local amount = Citizen.Await(p)
	local tradeMenu = {
		{ icon = "recyclablematerial", header = "Material Trading", txt = "Amount held: "..amount, isMenuHeader = true },
		{ icon = "fas fa-circle-xmark", header = "", txt = "Close", params = { event = "jim-recycle:CloseMenu" } } }
	if amount >= 10 then tradeMenu[#tradeMenu+1] = { icon = "recyclablematerial", header = "Trade 10 Materials", params = { event = "jim-recycle:SellAnim", args = 1 } } end
	if amount >= 100 then tradeMenu[#tradeMenu+1] = { icon = "recyclablematerial", header = "Trade 100 Materials", params = { event = "jim-recycle:SellAnim", args = 2 } } end
	if amount >= 1000 then tradeMenu[#tradeMenu+1] = { icon = "recyclablematerial", header = "Trade 1000 Materials", params = { event = "jim-recycle:SellAnim", args = 3 } } end
    exports['qb-menu']:openMenu(tradeMenu)
end)

--Recyclable Trader
RegisterNetEvent('jim-recycle:Bottle:Menu', function()
    exports['qb-menu']:openMenu({
		{ header = "Material Selling", txt = "Sell batches of recyclables", isMenuHeader = true },
		{ icon = "fas fa-circle-xmark", header = "", txt = "Close", params = { event = "jim-recycle:CloseMenu" } },
		{ icon = "bottle", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["bottle"].image.." width=30px onerror='this.onerror=null; this.remove();'> "..QBCore.Shared.Items["bottle"].label, params = { event = "jim-recycle:SellAnim", args = 'bottle' } },
		{ icon = "can", header = "<img src=nui://"..Config.img..QBCore.Shared.Items["can"].image.." width=30px onerror='this.onerror=null; this.remove();'> "..QBCore.Shared.Items["can"].label, params = { event = "jim-recycle:SellAnim", args = 'can' } },
    })
end)

AddEventHandler('onResourceStop', function(resource) if resource ~= GetCurrentResourceName() then return end
	for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
	for _, v in pairs(peds) do unloadModel(GetEntityModel(v)) DeletePed(v) end
	for _, v in pairs(props) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
	for _, v in pairs(searchProps) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
	unloadModel(GetEntityModel(TrollyProp)) DeleteObject(TrollyProp)
	unloadModel(GetEntityModel(scrapProp)) DeleteObject(scrapProp)
	for _, v in pairs(searchProps) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
end)
