local QBCore = exports['qb-core']:GetCoreObject()

isLoggedIn = false
local PlayerJob = {}
local searched = {3423423424}
local canSearch = true
local dumpsters = { 218085040, 666561306, -58485588, -206690185, 1511880420, 682791951, 1437508529, 2051806701, -246439655, 74073934, -654874323, 651101403, 909943734, 1010534896, 1614656839, -130812911, -93819890,
                    1329570871, 1143474856, -228596739, -468629664, -1426008804, -1187286639, -1096777189, -413198204, 437765445, -1830793175, -329415894, -341442425, -2096124444, 122303831, 1748268526, 998415499,
                    -5943724, -317177646, 1380691550, -115771139, -85604259, 1233216915, 375956747, 673826957, 354692929, -14708062, 811169045, -96647174, 1919238784, 275188277, 16567861, -1224639730, -1414390795, }
local searchTime = 2000

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

--- blips here
Citizen.CreateThread(function()
    if Config.Blips == true then
		CreateBlips()
	end
end)
Citizen.CreateThread(function()
	if Config.Pedspawn == true then
		CreatePeds()
	end
end)

function CreateBlips()
	for k, v in pairs(Config.Locations) do
		if Config.Locations[k].blipTrue then
			local blip = AddBlipForCoord(v.location)
			SetBlipAsShortRange(blip, true)
			SetBlipSprite(blip, v.Sprite)
			SetBlipColour(blip, v.Colour)
			SetBlipScale(blip, v.Scale)
			SetBlipDisplay(blip, 6)

			BeginTextCommandSetBlipName('STRING')
			if Config.BlipNamer then
				AddTextComponentString(v.name)
			else
				AddTextComponentString("Recycling")
			end
			EndTextCommandSetBlipName(blip)
		end
	end
end

-----------------------------------------------------------------
--PedSpawning Locations
local peds = {}
local shopPeds = {}
function CreatePeds()
	while true do
		Citizen.Wait(500)
		for k = 1, #Config.PedList, 1 do
			v = Config.PedList[k]
			local playerCoords = GetEntityCoords(PlayerPedId())
			local dist = #(playerCoords - v.coords)
			if dist < Config.Distance and not peds[k] then
				local ped = nearPed(v.model, v.coords, v.heading, v.gender, v.animDict, v.animName, v.scenario)
				peds[k] = {ped = ped}
			end
			if dist >= Config.Distance and peds[k] then
				if Config.Fade then
					for i = 255, 0, -51 do
						Citizen.Wait(50)
						SetEntityAlpha(peds[k].ped, i, false)
					end
				end
				DeletePed(peds[k].ped)
				peds[k] = nil
			end
		end
	end
end

function nearPed(model, coords, heading, gender, animDict, animName, scenario)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(1)
	end
	if gender == 'male' then
		genderNum = 4
	elseif gender == 'female' then 
		genderNum = 5
	else
		print("No gender provided! Check your configuration!")
	end
	if Config.MinusOne then 
		local x, y, z = table.unpack(coords)
		ped = CreatePed(genderNum, GetHashKey(model), x, y, z - 1, heading, false, true)
		table.insert(shopPeds, ped)
	else
		ped = CreatePed(genderNum, GetHashKey(v.model), coords, heading, false, true)
		table.insert(shopPeds, ped)
	end
	SetEntityAlpha(ped, 0, false)
	if Config.Frozen then
		FreezeEntityPosition(ped, true) --Don't let the ped move.
	end
	if Config.Invincible then
		SetEntityInvincible(ped, true) --Don't let the ped die.
	end
	if Config.Stoic then
		SetBlockingOfNonTemporaryEvents(ped, true) --Don't let the ped react to his surroundings.
	end
	--Add an animation to the ped, if one exists.
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end
	if scenario then
		TaskStartScenarioInPlace(ped, scenario, 0, true) -- begins peds animation
	end
	if Config.Fade then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(ped, i, false)
		end
	end
	return ped
end


---- Render Props -------


function renderPropsWhereHouse()
	CreateObject(GetHashKey("ex_prop_crate_bull_sc_02"),1003.63013,-3108.50415,-39.9669662,false,false,false)
	CreateObject(GetHashKey("ex_prop_crate_wlife_bc"),1018.18011,-3102.8042,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_prop_crate_closed_bc"),1006.05511,-3096.954,-37.8179666,false,false,false)
	CreateObject(GetHashKey("ex_prop_crate_wlife_sc"),1003.63013,-3102.8042,-37.81769,false,false,false)
	CreateObject(GetHashKey("ex_prop_crate_jewels_racks_sc"),1003.63013,-3091.604,-37.8179666,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1013.330000003,-3102.80400000,-35.62896000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1015.75500000,-3102.80400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1015.75500000,-3102.80400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Jewels_BC"),1018.18000000,-3091.60400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1026.75500000,-3111.38400000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Jewels_BC"),1003.63000000,-3091.60400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Jewels_BC"),1026.75500000,-3106.52900000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1026.75500000,-3106.52900000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Art_02_SC"),1010.90500000,-3108.50400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Art_BC"),1013.33000000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Art_BC"),1015.75500000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Bull_SC_02"),1010.90500000,-3096.95400000,-39.86697000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Art_SC"),993.35510000,-3111.30400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Art_BC"),993.35510000,-3108.95400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Gems_SC"),1013.33000000,-3096.95400000,-37.8177600,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_clothing_BC"),1018.180000000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_clothing_BC"),1008.48000000,-3096.95400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Gems_BC"),1003.63000000,-3108.50400000,-35.61234000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Narc_BC"),1026.75500000,-3091.59400000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Narc_BC"),1026.75500000,-3091.59400000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Elec_SC"),1008.48000000,-3108.50400000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Tob_SC"),1018.18000000,-3096.95400000,-37.81240000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Wlife_BC"),1018.18000000,-3091.60400000,-35.74857000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Med_BC"),1008.48000000,-3091.60400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Elec_SC"),1013.33000000,-3108.50400000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1026.75500000,-3108.88900000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_biohazard_BC"),1010.90500000,-3102.80400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Wlife_BC"),1015.75500000,-3091.60400000,-35.74857000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_biohazard_BC"),1003.63000000,-3108.50400000,-37.81561000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Elec_BC"),1008.48000000,-3096.954000000,-35.60529000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Bull_BC_02"),1006.05500000,-3108.50400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_RW"),1013.33000000,-3091.60400000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Narc_SC"),1026.75500000,-3094.014000000,-37.81684000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Art_BC"),1015.75500000,-3108.50400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Elec_BC"),1010.90500000,-3096.95400000,-35.60529000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Ammo_BC"),1013.33000000,-3102.80400000,-37.81427000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Money_BC"),1003.63000000,-3096.95400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Gems_BC"),1003.63000000,-3096.95400000,-37.81187000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1010.90500000,-3091.60400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_furJacket_BC"),1013.33000000,-3091.60400000,-35.74885000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_furJacket_BC"),1026.75500000,-3091.59400000,-35.74885000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_furJacket_BC"),1026.75500000,-3094.0140000,-35.74885000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_furJacket_BC"),1026.75500000,-3096.43400000,-35.74885000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_clothing_SC"),1013.33000000,-3091.604000000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_biohazard_SC"),1006.05500000,-3108.50400000,-37.81576000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Elec_BC"),993.35510000,-3106.60400000,-35.60529000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1026.75500000,-3111.38400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Bull_BC_02"),1026.75500000,-3096.4340000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1015.75500000,-3096.95400000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_HighEnd_pharma_BC"),1003.63000000,-3091.60400000,-35.62571000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_HighEnd_pharma_SC"),1015.75500000,-3091.60400000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Art_02_BC"),1013.330000000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Gems_SC"),1018.18000000,-3102.80400000,-37.81776000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Art_02_BC"),1013.33000000,-3108.50400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Gems_BC"),1018.18000000,-3108.50400000,-37.81234000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Tob_BC"),1010.90500000,-3108.50400000,-35.75240000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Med_SC"),1026.75500000,-3108.88900000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Money_SC"),1010.90500000,-3091.60400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Med_SC"),1008.48000000,-3091.60400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Art_02_BC"),1018.180000000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Bull_SC_02"),1008.48000000,-3108.50400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Art_02_BC"),993.35510000,-3106.60400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1008.480000000,-3102.804000000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Elec_BC"),993.35510000,-3111.30400000,-35.60529000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_HighEnd_pharma_BC"),1018.18000000,-3091.60400000,-37.81572000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Gems_BC"),1015.75500000,-3102.80400000,-37.81234000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Jewels_racks_BC"),1003.63000000,-3102.80400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Money_SC"),1006.05500000,-3096.95400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1003.630000000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_furJacket_SC"),1006.05500000,-3102.80400000,-37.81544000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Expl_bc"),1010.90500000,-3102.80400000,-37.81982000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Elec_BC"),1006.05500000,-3096.9540000,-35.60529000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Elec_BC"),1006.05500000,-3102.80400000,-35.60529000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Elec_BC"),1010.90500000,-3108.50400000,-37.81529000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Art_BC"),1015.75500000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Gems_BC"),1010.90500000,-3096.95400000,-37.81234000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Elec_BC"),1010.90500000,-3102.804000000,-35.60529000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Elec_BC"),1008.48000000,-3102.80400000,-35.60529000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Bull_BC_02"),993.35510000,-3106.60400000,-37.81342000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Money_SC"),1015.75500000,-3091.604000000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Med_BC"),1026.75500000,-3106.52900000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Bull_SC_02"),1015.75500000,-3096.95400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Tob_SC"),1010.905000000,-3091.60400000,-37.81240000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1006.05500000,-3091.60400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_pharma_SC"),1026.75500000,-3096.43400000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1006.05500000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Gems_SC"),1015.75500000,-3108.504000000,-37.81776000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Tob_BC"),1018.18000000,-3102.80400000,-35.75240000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Tob_BC"),1008.48000000,-3108.50400000,-35.75240000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Bull_BC_02"),993.35510000,-3111.30400000,-37.81342000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Jewels_racks_SC"),1026.75500000,-3111.384000000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Jewels_SC"),1006.05500000,-3102.80400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Bull_BC_02"),1013.33000000,-3096.95400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Gems_SC"),1013.33000000,1013.33000000,1013.33000000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Jewels_BC"),1026.75500000,-3108.889000000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Bull_SC_02"),993.35510000,-3108.95400000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_BC"),1008.48000000,-3091.60400000,-37.81797000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Elec_SC"),993.35510000,-3108.95400000,-35.62796000,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_XLDiam"),1026.75500000,-3094.01400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_watch"),1013.33000000,-3102.80400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_SHide"),1018.18000000,-3096.95400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Oegg"),1006.05500000,-3091.60400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_MiniG"),1018.18000000,-3108.50400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_FReel"),11008.48000000,-3102.80400000,-39.99757,false,false,false)
	CreateObject(GetHashKey("ex_Prop_Crate_Closed_SC"),1006.05500000,-3091.60400000,-37.81985000,false,false,false) 
	CreateObject(GetHashKey("ex_Prop_Crate_Bull_BC_02"),1026.75500000,-3091.59400000,-39.99757,false,false,false)

	local tool = CreateObject(-573669520,1002.0411987305,-3108.3645019531,-39.999897003174,false,false,false)

	SetEntityHeading(tool,GetEntityHeading(tool)-90)
end

RegisterNetEvent("jim-recycle:removeWarehouseProps")
AddEventHandler("jim-recycle:removeWarehouseProps", function()
    CleanUpArea()
end)

function CleanUpArea()
    local playerped = GetPlayerPed(-1)
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = GetDistanceBetweenCoords(plycoords, pos, true)
        if distance < 50.0 and ObjectFound ~= playerped then
        	if IsEntityAPed(ObjectFound) then
        		if IsPedAPlayer(ObjectFound) then
        		else
        			DeleteObject(ObjectFound)
        		end
        	else
        		if not IsEntityAVehicle(ObjectFound) and not IsEntityAttached(ObjectFound) then
	        		DeleteObject(ObjectFound)
	        	end
        	end            
        end
        success, ObjectFound = FindNextObject(handle)
    until not success
    SetEntityAsNoLongerNeeded(handle)
    DeleteEntity(handle)    
    EndFindObject(handle)
end

--Recycling Center thirdeye commands
Citizen.CreateThread(function()
	exports['qb-target']:AddBoxZone("RecyclingEnter", vector3(746.82, -1398.93, 26.55), 0.4, 1.6, { name="RecyclingEnter", debugPoly=false, minZ=25.2, maxZ=28.0 },
    { options = { { event = "expand:recyling:EnterTradeWarehouse", icon = "fas fa-recycle", label = "Enter Warehouse", }, },
					distance = 1.5
    })
	exports['qb-target']:AddBoxZone("RecyclingExit", vector3(991.97, -3097.81, -39.0), 1.6, 0.4, { name="RecyclingExit", debugPoly=false, useZ=true, },
    { options = { { event = "expand:recyling:ExitTradeWarehouse", icon = "fas fa-recycle", label = "Exit Warehouse", }, },
					distance = 1.5
    })
    exports['qb-target']:AddCircleZone("recycleduty", vector3(994.64,-3100.07,-39.0), 2.0, { name="recycleduty", debugPoly=false, useZ=true, },
    { options = { { event = "recycle:dutytoggle", icon = "fas fa-hard-hat", label = "Toggle Recycling Duty", }, },
					distance = 1.5
    })
    exports['qb-target']:AddCircleZone("tradeitems", Config.Locations['Trade'].location, 2.0, { name="tradeitems", debugPoly=false, useZ=true, },
    { options = { { event = "jim-recycle:Trade:Menu", icon = "fas fa-box", label = "Trade Materials", }, },
					distance = 1.5
    })
    exports['qb-target']:AddCircleZone("sellmats", Config.Locations['Recycle'].location, 2.0, { name="sellmats", debugPoly=false, useZ=true, },
    { options = { { event = "jim-recycle:Selling:Menu", icon = "fas fa-box", label = "Sell Materials", }, },
					distance = 2.5
    })
	--Dumpster Third Eye
	exports['qb-target']:AddTargetModel(dumpsters, { options = { { event = "jim-recycle:Dumpsters:Search", icon = "fas fa-dumpster", label = "Search Trash", }, },
					distance = 1.5
    })
	--Bottle Selling Third Eyes
    exports['qb-target']:AddCircleZone("BottleBuyer", Config.Locations['BottleBank'].location, 2.0, { name="BottleBuyer", debugPoly=false, useZ=true, }, 
    { options = { { event = "jim-recycle:Bottle:Menu", icon = "fas fa-certificate", label = "Sell Bottles", },	},
					distance = 2.5
    })
    exports['qb-target']:AddCircleZone("BottleBuyer2", Config.Locations['BottleBank2'].location, 2.0, { name="BottleBuyer", debugPoly=false, useZ=true, }, 
    { options = { { event = "jim-recycle:Bottle:Menu", icon = "fas fa-certificate", label = "Sell Bottles", },	},
					distance = 2.5
    })
    exports['qb-target']:AddCircleZone("BottleBuyer3", Config.Locations['BottleBank3'].location, 2.0, { name="BottleBuyer", debugPoly=false, useZ=true, }, 
    { options = { { event = "jim-recycle:Bottle:Menu", icon = "fas fa-certificate", label = "Sell Bottles", },	},
					distance = 2.5
    })
    exports['qb-target']:AddCircleZone("BottleBuyer4", Config.Locations['BottleBank4'].location, 2.0, { name="BottleBuyer", debugPoly=false, useZ=true, }, 
    { options = { { event = "jim-recycle:Bottle:Menu", icon = "fas fa-certificate", label = "Sell Bottles", },	},
					distance = 2.5
    })
    exports['qb-target']:AddCircleZone("BottleBuyer5", Config.Locations['BottleBank5'].location, 2.0, { name="BottleBuyer", debugPoly=false, useZ=true, }, 
    { options = { { event = "jim-recycle:Bottle:Menu", icon = "fas fa-certificate", label = "Sell Bottles", },	},
					distance = 2.5
    })
    exports['qb-target']:AddCircleZone("BottleBuyer6", Config.Locations['BottleBank6'].location, 2.0, { name="BottleBuyer", debugPoly=false, useZ=true, }, 
    { options = { { event = "jim-recycle:Bottle:Menu", icon = "fas fa-certificate", label = "Sell Bottles", },	},
					distance = 2.5
    })
end)

local carryPackage = nil

local onDuty = false

RegisterNetEvent('expand:recyling:EnterTradeWarehouse')
AddEventHandler('expand:recyling:EnterTradeWarehouse', function()
    if Config.EnableOpeningHours then
        local ClockTime = GetClockHours()
        if ClockTime >= Config.OpenHour and ClockTime <= Config.CloseHour - 1 then
            if (ClockTime >= Config.OpenHour and ClockTime < 24) or (ClockTime <= Config.CloseHour -1 and ClockTime > 0) then
                renderPropsWhereHouse()
                DoScreenFadeOut(500)
                while not IsScreenFadedOut() do
                    Citizen.Wait(10)
                end
                SetEntityCoords(GetPlayerPed(-1), Config['delivery'].InsideLocation.x, Config['delivery'].InsideLocation.y, Config['delivery'].InsideLocation.z)
                DoScreenFadeIn(500)
            else
                TriggerEvent("QBCore:Notify", "We're currently closed, we're open from "..Config.OpenHour..":00am till "..Config.CloseHour..":00pm", "error")
            end
        else
            TriggerEvent("QBCore:Notify", "We're currently closed, we're open from 9:00am till 21:00pm", "error")
        end
    else
        renderPropsWhereHouse()
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Citizen.Wait(10)
        end
        SetEntityCoords(GetPlayerPed(-1), Config['delivery'].InsideLocation.x, Config['delivery'].InsideLocation.y, Config['delivery'].InsideLocation.z)
        DoScreenFadeIn(500)
    end
end)

RegisterNetEvent('expand:recyling:ExitTradeWarehouse')
AddEventHandler('expand:recyling:ExitTradeWarehouse', function()
	TriggerEvent('jim-recycle:removeWarehouseProps')
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(10)
	end
	SetEntityCoords(GetPlayerPed(-1), Config['delivery'].OutsideLocation.x, Config['delivery'].OutsideLocation.y, Config['delivery'].OutsideLocation.z + 1)
	DoScreenFadeIn(500)
end)

local packagePos = nil

--
Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(1)
        if onDuty then
            if packagePos ~= nil then
                local pos = GetEntityCoords(GetPlayerPed(-1), true)
                if carryPackage == nil then
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, packagePos.x,packagePos.y,packagePos.z, true) < 2.3 then
                        DrawText3D(packagePos.x,packagePos.y,packagePos.z+ 1, "~g~E~w~ - Grab Junk")
                        if IsControlJustReleased(0, 38) then
                            TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_BUM_BIN", 0, true)
                            QBCore.Functions.Progressbar("pickup_reycle_package", "Picking up the junk..", 5000, false, true, {}, {}, {}, {}, function() -- Done
                                ClearPedTasks(GetPlayerPed(-1))
                                PickupPackage()
                            end)
                        end
                    else
                        DrawText3D(packagePos.x, packagePos.y, packagePos.z + 1, "Pallet")
                    end
                else
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config['delivery'].DropLocation.x, Config['delivery'].DropLocation.y, Config['delivery'].DropLocation.z, true) < 2.0 then
                        DrawText3D(Config['delivery'].DropLocation.x, Config['delivery'].DropLocation.y, Config['delivery'].DropLocation.z, "~g~E~w~ - Transfer to Recyclable Box")
                        if IsControlJustReleased(0, 38) then
                            DropPackage()
                            ScrapAnim()
                            QBCore.Functions.Progressbar("deliver_reycle_package", "Packing into recyclable box..", 5000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                TriggerServerEvent('jim-recycle:getrecyclablematerial')
                                GetRandomPackage()
                            end)
                        end
                    else
                        DrawText3D(Config['delivery'].DropLocation.x, Config['delivery'].DropLocation.y, Config['delivery'].DropLocation.z, "Transfer")
                    end
                end
            else
                GetRandomPackage()
            end
        end
    end
end)

function GetRandomPackage()
    local randSeed = math.random(1, #Config["delivery"].PackagePickupLocations)
    packagePos = {}
    packagePos.x = Config["delivery"].PackagePickupLocations[randSeed].x
    packagePos.y = Config["delivery"].PackagePickupLocations[randSeed].y
    packagePos.z = Config["delivery"].PackagePickupLocations[randSeed].z
end

--Third Eye Commands
RegisterNetEvent('recycle:dutytoggle')
AddEventHandler('recycle:dutytoggle', function()
    onDuty = not onDuty
    if onDuty then
		TriggerEvent('QBCore:Notify', 'You went on duty', 'success')
    else
        TriggerEvent('QBCore:Notify', 'You went on duty', 'error')
    end
end)

--Sell Anim small Test
RegisterNetEvent('jim-recycle:SellAnim')
AddEventHandler('jim-recycle:SellAnim', function(data)
	if data == -2 then
		exports['qb-menu']:closeMenu()
		return
	end	
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	if data == 1 then
		TriggerServerEvent('jim-recycle:Selling:All')
	else
		TriggerServerEvent('jim-recycle:Selling:Mat', data)
	end
	for k,v in pairs (shopPeds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
			if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			SetEntityRotation(v, 0,0,ppRot.z,0,0,false)
			break
		end
	end
end)

--Sell Anim small Test
RegisterNetEvent('jim-recycle:TradeAnim')
AddEventHandler('jim-recycle:TradeAnim', function(data)
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('jim-recycle:TradeItems', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (shopPeds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
			oldRot = GetEntityRotation(v)
			if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			SetEntityRotation(v, 0,0,ppRot.z,0,0,false)
			break
		end
	end
end)


--Material Buyer
RegisterNetEvent('jim-recycle:Selling:Menu', function()
    exports['qb-menu']:openMenu({
		{ header = "Material Selling", txt = "Sell batches of materials", isMenuHeader = true },
		{ header = "", txt = "✘ Close", params = { event = "jim-recycle:SellAnim", args = -2 } },
		{ header = QBCore.Shared.Items["copper"].label, params = { event = "jim-recycle:SellAnim", args = 'copper' } },
		{ header = QBCore.Shared.Items["plastic"].label, params = { event = "jim-recycle:SellAnim", args = 'plastic' } },
		{ header = QBCore.Shared.Items["aluminum"].label, params = { event = "jim-recycle:SellAnim", args = 'aluminum' } },
		{ header = QBCore.Shared.Items["metalscrap"].label, params = { event = "jim-recycle:SellAnim", args = 'metalscrap' }  },
		{ header = QBCore.Shared.Items["steel"].label, params = { event = "jim-recycle:SellAnim", args = 'steel' } },
		{ header = QBCore.Shared.Items["glass"].label, params = { event = "jim-recycle:SellAnim", args = 'glass' } },
		{ header = QBCore.Shared.Items["iron"].label, params = { event = "jim-recycle:SellAnim", args = 'iron' } },
		{ header = QBCore.Shared.Items["rubber"].label, params = { event = "jim-recycle:SellAnim", args = 'rubber' } },
		{ header = "ALL", params = { event = "jim-recycle:SellAnim", args = 1 } }, 
    })
end)

--Recyclable Trader
RegisterNetEvent('jim-recycle:Trade:Menu', function()
    exports['qb-menu']:openMenu({
		{ header = "Material Trading", txt = "Trade collected materials", isMenuHeader = true },
 		{ header = "", txt = "✘ Close", params = { event = "jim-recycle:SellAnim", args = -2 } },
		{ header = "Trade 10 Materials", params = { event = "jim-recycle:TradeAnim", args = 1 } },
		{ header = "Trade 100 Materials", params = { event = "jim-recycle:TradeAnim", args = 2 } },
    })
end)

--Recyclable Trader
RegisterNetEvent('jim-recycle:Bottle:Menu', function()
    exports['qb-menu']:openMenu({
		{ header = "Material Selling", txt = "Sell batches of recyclables", isMenuHeader = true },
		{ header = "", txt = "✘ Close", params = { event = "jim-recycle:SellAnim", args = -2 } },
		{ header = "Sell "..QBCore.Shared.Items["bottle"].label, params = { event = "jim-recycle:SellAnim", args = 'bottle' } },
		{ header = "Sell "..QBCore.Shared.Items["can"].label, params = { event = "jim-recycle:SellAnim", args = 'can' } },
    })
end)

--- 3D Text Shit---

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end


---Animations---

function ScrapAnim()
    local time = 5
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
            time = time - 1
            if time <= 0 then
                openingDoor = false
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end



function PickupPackage()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Citizen.Wait(7)
    end
    TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
	local randommodel = math.random(1,3)
	--if randommodel == 1 then model = GetHashKey("prop_cs_cardbox_01") rot1 = 300.0 rot2 = 250.0
	--elseif randommodel == 2 then model = GetHashKey("prop_rub_scrap_06") rot1 = 300.0 rot2 = 130.0
	--elseif randommodel == 3 then model = GetHashKey("v_ret_gc_bag01") rot1 = 300.0 rot2 = 130.0 end
	model = GetHashKey("prop_rub_scrap_06")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(object, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.05, 0.1, -0.3, 300.0, 130.0, 20.0, true, true, false, true, 1, true)
    carryPackage = object
end

function DropPackage()
    ClearPedTasks(GetPlayerPed(-1))
    DetachEntity(carryPackage, true, true)
    DeleteObject(carryPackage)
    carryPackage = nil
end



-----------------------------------------------------
--Dumpster Stuff



--Search animations
function startSearching(time, dict, anim, cb)
    local animDict = dict
    local animation = anim
    local ped = PlayerPedId()
    local playerPed = PlayerPedId()


    canSearch = false

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
        TaskPlayAnim(ped, animDict, animation, 8.0, 8.0, time, 1, 1, 0, 0, 0)
    FreezeEntityPosition(playerPed, true)

    local ped = PlayerPedId()

    Wait(time)
    ClearPedTasks(ped)
    FreezeEntityPosition(playerPed, false)
    canSearch = true
    TriggerServerEvent(cb)
end

--Remove dumpster from table after searching
RegisterNetEvent('jim-recycle:Dumpsters:Remove')
AddEventHandler('jim-recycle:Dumpsters:Remove', function(object)
    for i = 1, #searched do
        if searched[i] == object then
            table.remove(searched, i)
        end
    end
end)

RegisterNetEvent('jim-recycle:Dumpsters:Search')
AddEventHandler('jim-recycle:Dumpsters:Search', function()
    local ped = PlayerPedId()
    local playerPed = PlayerPedId()
    --while true do
        local wait = 1000
        if canSearch then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dumpsterFound = false
            wait = 250
            for i = 1, #dumpsters do
                local dumpster = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, dumpsters[i], false, false, false)
                local dumpPos = GetEntityCoords(dumpster)
                local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, dumpPos.x, dumpPos.y, dumpPos.z, true)
                local playerPed = PlayerPedId()

                if dist < 1.8 then
                    wait = 4
                    for i = 1, #searched do
                        if searched[i] == dumpster then
                            dumpsterFound = true
                        end
                        if i == #searched and dumpsterFound then
							QBCore.Functions.Notify('Already Searched.', 'error')
                            
                        elseif i == #searched and not dumpsterFound then
							TaskTurnPedToFaceEntity(ped, dumpster, 1000)
							Wait(1000)
                            loadAnimDict('amb@prop_human_bum_bin@base')
                            TaskPlayAnim(ped, 'amb@prop_human_bum_bin@base', 'base', 8.0, 8.0, 16000, 1, 1, 0, 0, 0)
							local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
							Skillbar.Start({
								duration = math.random(2500,5000),
								pos = math.random(10, 30),
								width = math.random(10, 20),
							}, function()
								TriggerEvent("QBCore:Notify", "You search the Trash!", "success")
                                startSearching(searchTime, 'amb@prop_human_bum_bin@base', 'base', 'jim-recycle:Dumpsters:Reward')
                                table.insert(searched, dumpster)           
                                Citizen.Wait(1000)
							end, function()
								QBCore.Functions.Notify('You couldn\'t find anything.','error')
                                table.insert(searched, dumpster)           
                                ClearPedTasks(ped)
                                Citizen.Wait(1000)
							end)						
                        end
                    end
                end
            end
        Citizen.Wait(wait)
    end
end)
