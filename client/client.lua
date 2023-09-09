PlayerJob, onDuty, Peds, Targets, searchProps, Props, randPackage = {}, false, {}, {}, {}, {}, nil
local TrollyProp = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	Core.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job if PlayerData.job.name == Config.JobRole then onDuty = PlayerJob.onduty end end)
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty) if Config.JobRole then if PlayerJob.name == Config.JobRole then onDuty = duty end end end)

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	Core.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job if PlayerData.job.name == Config.JobRole then onDuty = PlayerJob.onduty end end)
end)

--- Blips + Peds
CreateThread(function()
	for location in pairs(Config.Locations["Centres"]) do local loc = Config.Locations["Centres"][location]
		if loc.Enable then
			local JobLocation = PolyZone:Create(loc.Zone, { name = "Recycling", debugPoly = Config.Debug })
			JobLocation:onPlayerInOut(function(isPointInside)
				if not isPointInside then
					EndJob() ClearProps()
					if Config.Debug then print("^5Debug^7: ^3PolyZone^7: ^2Leaving Area^7. ^2Clocking out and cleaning up^7") end
					if loc.Job then
						if onDuty then TriggerServerEvent("QBCore:ToggleDuty") end
					elseif onDuty == true then
						onDuty = false
					end
				else MakeProps(location)
				end
			end)
			if loc.Blip.blipEnable then makeBlip(loc.Blip) end

			local nameEnter = "RecycleEnter"..location
			local jobLoc = loc.JobLocations
			Targets[nameEnter] =
				exports['qb-target']:AddBoxZone(nameEnter, jobLoc.Enter.coords.xyz, jobLoc.Enter.w, jobLoc.Enter.d, { name=nameEnter, heading = jobLoc.Enter.coords.w, debugPoly=Config.Debug, minZ=jobLoc.Enter.coords.z-1, maxZ=jobLoc.Enter.coords.z+2 },
					{ options = { { event = "jim-recycle:TeleWareHouse", icon = "fas fa-recycle", label = Loc[Config.Lan].target["enter"]..(Config.PayAtDoor and " ($"..Config.PayAtDoor..")" or ""), tele = jobLoc.Enter.tele, job = loc.Job, enter = true }, },
					distance = 1.5 })

			local nameExit = "RecycleExit"..location
			Targets[nameExit] =
				exports['qb-target']:AddBoxZone(nameExit, jobLoc.Exit.coords.xyz, jobLoc.Exit.w, jobLoc.Exit.d, { name=nameExit, heading = jobLoc.Exit.coords.w, debugPoly=Config.Debug, minZ=jobLoc.Exit.coords.z-1, maxZ=jobLoc.Exit.coords.z+2, },
					{ options = { { event = "jim-recycle:TeleWareHouse", icon = "fas fa-recycle", label = Loc[Config.Lan].target["exit"], tele = jobLoc.Exit.tele }, },
					distance = 1.5 })

			local nameDuty = "RecycleDuty"..location
			Targets[nameDuty] =
				exports['qb-target']:AddBoxZone(nameDuty, jobLoc.Duty.coords.xyz, jobLoc.Duty.w, jobLoc.Duty.d, { name=nameDuty, heading = jobLoc.Duty.coords.w, debugPoly=Config.Debug, minZ=jobLoc.Duty.coords.z-0.5, maxZ=jobLoc.Duty.coords.z+0.5, },
					{ options = { { event = "jim-recycle:dutytoggle", icon = "fas fa-hard-hat", label = Loc[Config.Lan].target["duty"], job = loc.Job, Trolly = jobLoc.Trolly }, },
					distance = 1.5 })

			if jobLoc.Trade then
				for i = 1, #jobLoc.Trade do
					local nameTrade = "RecycleTrade"..location..i
					Peds[nameTrade] = makePed(jobLoc.Trade[i].model, jobLoc.Trade[i].coords, true, false, jobLoc.Trade[i].scenario, nil)
					Targets[nameTrade] =
						exports['qb-target']:AddBoxZone(nameTrade, vec3(jobLoc.Trade[i].coords.x, jobLoc.Trade[i].coords.y, jobLoc.Trade[i].coords.z-1), jobLoc.Trade[i].w, jobLoc.Trade[i].d, { name=nameTrade, heading = jobLoc.Trade[i].coords.w, debugPoly=Config.Debug, minZ= jobLoc.Trade[i].coords.z-1, maxZ=jobLoc.Trade[i].coords.z+1 },
							{ options = { { event = "jim-recycle:Trade:Menu", icon = "fas fa-box", label = Loc[Config.Lan].target["trade"], job = loc.Job, Ped = Peds[nameTrade] }, },
							distance = 1.5 })
				end
			end
		end
	end

	--Sell Materials
	for i = 1, #Config.Locations["Recycle"] do local loc = Config.Locations["Recycle"][i]
		local nameSell = "Recycle"..i
		Peds[nameSell] = makePed(loc.Ped.model, loc.coords, true, false, loc.Ped.scenario, nil)
		if loc.Blip.blipEnable then makeBlip({ coords = loc.coords, sprite = loc.Blip.sprite, col = loc.Blip.col, name = loc.Blip.name } ) end
		Targets[nameSell] =
			exports['qb-target']:AddBoxZone(nameSell, vec3(loc.coords.x, loc.coords.y, loc.coords.z-1), 1.0, 1.0, { name=nameSell, heading = loc.coords.w, debugPoly = Config.Debug, minZ = loc.coords.z-1, maxZ=loc.coords.z+1 },
				{ options = { { event = "jim-recycle:Selling:Menu", icon = "fas fa-box", label = Loc[Config.Lan].target["sell"], Ped = Peds[nameSell], }, },
				distance = 2.5 })
	end
	--Bottle Selling Third Eyes
	for i = 1, #Config.Locations["BottleBanks"] do local loc = Config.Locations["BottleBanks"][i]
		local nameBank = "BottleBank"..i
		Peds[nameBank] = makePed(loc.Ped.model, loc.coords, true, false, loc.Ped.scenario, nil)
		if loc.Blip.blipEnable then makeBlip({ coords = loc.coords, sprite = loc.Blip.sprite, col = loc.Blip.col, name = loc.Blip.name } ) end
		Targets[nameBank] =
			exports['qb-target']:AddBoxZone(nameBank, vec3(loc.coords.x, loc.coords.y, loc.coords.z-1), 1.0, 1.0, { name=nameBank, heading = loc.coords.w, debugPoly = Config.Debug, minZ = loc.coords.z-1, maxZ=loc.coords.z+1 },
				{ options = { { event = "jim-recycle:Bottle:Menu", icon = "fas fa-certificate", label = Loc[Config.Lan].target["sell_bottles"], job = Config.JobRole, Ped = Peds[nameBank] }, },
				distance = 1.5 })
	end
end)

---- Render Props -------
function MakeProps(location)
	local loc = Config.Locations["Centres"][location]
	if Config.Debug then print("^5Debug^7: ^3MakeProps^7() ^2Spawning props for '"..location.."'") end
	for i = 1, #loc.SearchLocations do
		searchProps[#searchProps+1] = makeProp({prop = Config.propTable[math.random(1, #Config.propTable)], coords = loc.SearchLocations[i]}, 1, 0)
	end
	for i = 1, #loc.ExtraPropLocations do
		Props[#Props+1] = makeProp({prop = Config.propTable[math.random(1, #Config.propTable)], coords = loc.ExtraPropLocations[i]}, 1, 0)
	end
	for k in pairs(Config.scrapPool) do loadModel(Config.scrapPool[k].model) end
	if not TrollyProp then TrollyProp = makeProp(loc.JobLocations.Trolly, 1, 0) end
end

function EndJob()
	if Targets["Package"] then exports["qb-target"]:RemoveTargetEntity(randPackage) end
	if TrollyProp then destroyProp(TrollyProp) TrollyProp = nil end
	for i = 1, #searchProps do SetEntityDrawOutline(searchProps[i], false) end
	randPackage = nil
	if scrapProp then
		destroyProp(scrapProp)
		scrapProp = nil
	end
end

function ClearProps()
	if Config.Debug then print("^5Debug^7: ^3ClearProps^7() ^2Exiting building^7, ^2clearing previous props ^7(^2if any^7)") end
	for _, v in pairs(searchProps) do unloadModel(GetEntityModel(v)) DeleteObject(v) end searchProps = {}
	for _, v in pairs(Props) do unloadModel(GetEntityModel(v)) DeleteObject(v) end Props = {}
	for k in pairs(Config.scrapPool) do unloadModel(Config.scrapPool[k].model) end
	if Targets["DropOff"] then exports["qb-target"]:RemoveTargetEntity(TrollyProp) end
	unloadModel(GetEntityModel(TrollyProp)) DeleteObject(TrollyProp)
end

--Pick one of the crates for the player to choose, generate outline + target
function PickRandomPackage(Trolly)
	if not TrollyProp then TrollyProp = makeProp(Trolly, 1, 0) end
	--If somehow already exists, remove target
	if Targets["Package"] then exports["qb-target"]:RemoveTargetEntity(randPackage, "Search") end
	--Pick random prop to use
	randPackage = searchProps[math.random(1, #searchProps)]
	SetEntityDrawOutline(randPackage, true)
	SetEntityDrawOutlineColor(0, 255, 0, 1.0)
	SetEntityDrawOutlineShader(1)
	--Generate Target Location on the selected package
	Targets["Package"] =
		exports['qb-target']:AddTargetEntity(randPackage,
			{ options = { { event = "jim-recycle:PickupPackage:Start", icon = 'fas fa-magnifying-glass', label = Loc[Config.Lan].target["search"], Trolly = Trolly} },
			distance = 2.5,	})
end

--Event to enter and exit warehouse
RegisterNetEvent("jim-recycle:TeleWareHouse", function(data) local Ped = PlayerPedId()
	if data.enter then
		if Config.EnableOpeningHours then
			local ClockTime = GetClockHours()
			if (ClockTime >= Config.OpenHour and ClockTime < 24) or (ClockTime <= Config.CloseHour -1 and ClockTime > 0) then
				if Config.PayAtDoor then
					if Config.Inv == "ox" then
						if HasItem("money", Config.PayAtDoor) then toggleItem(false, "money", Config.PayAtDoor)
						else triggerNotify(nil, Loc[Config.Lan].error["no_money"], "error") return end
					else
						local cash = 0
						if Config.Inv == "ox" then
							if HasItem("money", Config.PayAtDoor) then cash = Config.PayAtDoor end
						else
							local p = promise.new()	Core.Functions.TriggerCallback("jim-recycle:GetCash", function(cb) p:resolve(cb) end)
							cash = Citizen.Await(p)
						end
						if cash >= Config.PayAtDoor then TriggerServerEvent("jim-recycle:DoorCharge")
						else triggerNotify(nil, Loc[Config.Lan].error["no_money"], "error") return end
					end
				end
			else
				triggerNotify(nil, Loc[Config.Lan].error["wrong_time"]..Config.OpenHour..":00am"..Loc[Config.Lan].error["till"]..Config.CloseHour..":00pm", "error") return
			end
			DoScreenFadeOut(500)
			while not IsScreenFadedOut() do Wait(10) end
			SetEntityCoords(Ped, data.tele.xyz)
			DoScreenFadeIn(500)
		else
			DoScreenFadeOut(500)
			while not IsScreenFadedOut() do Wait(10) end
			SetEntityCoords(Ped, data.tele.xyz)
			DoScreenFadeIn(500)
		end
	else
		EndJob() -- Resets outlines + targets if needed
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do Wait(10) end
		if onDuty then TriggerEvent('jim-recycle:dutytoggle') end
		SetEntityCoords(Ped, data.tele.xyz)
		DoScreenFadeIn(500)
	end
end)

RegisterNetEvent("jim-recycle:PickupPackage:Start", function(data) local Ped = PlayerPedId()
	TaskStartScenarioInPlace(Ped, "CODE_HUMAN_MEDIC_KNEEL", 0, true)
	if progressBar({label = Loc[Config.Lan].progressbar["search"], time = 5000, cancel = true, icon = "fas fa-magnifying-glass"}) then
		ClearPedTasksImmediately(Ped)
		TriggerEvent("jim-recycle:PickupPackage:Hold", data)
	end
end)

RegisterNetEvent("jim-recycle:PickupPackage:Hold", function(data) local Ped = PlayerPedId()
	--Clear current target info
	exports["qb-target"]:RemoveTargetEntity(randPackage, "Search")
	SetEntityDrawOutline(randPackage, false) randPackage = nil

	--Make prop to put in hands
	loadAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(Ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
	local v = Config.scrapPool[math.random(1, #Config.scrapPool)]
	local PedCoords = GetEntityCoords(Ped, true)
    scrapProp = makeProp({prop = v.model, coords = vec4(PedCoords.x, PedCoords.y, PedCoords.z, 0.0)}, 1, 1)
    AttachEntityToEntity(scrapProp, Ped, GetPedBoneIndex(Ped, 18905), v.xPos, v.yPos, v.zPos, v.xRot, v.yRot, v.zRot, 20.0, true, true, false, true, 1, true)

	--Create target for drop off location
	SetEntityDrawOutline(TrollyProp, true)
	SetEntityDrawOutlineColor(150, 1, 1, 1.0)
	SetEntityDrawOutlineShader(1)

	Targets["DropOff"] =
		exports['qb-target']:AddTargetEntity(TrollyProp,
			{ options = { { event = "jim-recycle:PickupPackage:Finish", icon = 'fas fa-recycle', label = Loc[Config.Lan].target["drop_off"], Trolly = data.Trolly } },
			distance = 2.5,	})
end)

RegisterNetEvent("jim-recycle:PickupPackage:Finish", function(data) local Ped = PlayerPedId()
	--Once this is triggered it can't be stopped, so remove the target and prop
	if Targets["DropOff"] then exports["qb-target"]:RemoveTargetEntity(TrollyProp, Loc[Config.Lan].target["drop_off"]) Targets["DropOff"] = nil end
	destroyProp(TrollyProp) SetEntityDrawOutline(TrollyProp, false) TrollyProp = nil
	--Remove target and the whole prop, seen as how no ones qb-target works and its my fault 😊
	TrollyProp = makeProp(data.Trolly, 1, 0)

	--Load and Start animation
	local dict = "mp_car_bomb"
	local anim = "car_bomb_mechanic"

	loadAnimDict(dict)
	FreezeEntityPosition(Ped, true)
	Wait(100)
	TaskPlayAnim(Ped, dict, anim, 3.0, 3.0, -1, 2.0, 0, 0, 0, 0)
	Wait(3000)
	--When animation is complete
	--Empty hands
	destroyProp(scrapProp) scrapProp = nil
	ClearPedTasks(Ped)
	FreezeEntityPosition(Ped, false)
	toggleItem(true, "recyclablematerial", math.random(Config.RecycleAmounts["Recycle"].Min, Config.RecycleAmounts["Recycle"].Max))
	PickRandomPackage(data.Trolly)
end)

RegisterNetEvent('jim-recycle:dutytoggle', function(data)
	if Config.JobRole then
		if onDuty then EndJob() else PickRandomPackage(data.Trolly) end
		TriggerServerEvent("QBCore:ToggleDuty")
	else
		onDuty = not onDuty
		if onDuty then triggerNotify(nil, Loc[Config.Lan].success["on_duty"], 'success') PickRandomPackage(data.Trolly)
		else triggerNotify(nil, Loc[Config.Lan].error["off_duty"], 'error') EndJob() end
	end
end)

local Selling = false
RegisterNetEvent('jim-recycle:SellAnim', function(data) local Ped = PlayerPedId()
	if Selling then return else Selling = true end
	lockInv(true)
	for k, v in pairs(GetGamePool('CObject')) do
		for _, model in pairs({`p_cs_clipboard`}) do
			if GetEntityModel(v) == model then	if IsEntityAttachedToEntity(data.Ped, v) then DeleteObject(v) DetachEntity(v, 0, 0) SetEntityAsMissionEntity(v, true, true)	Wait(100) DeleteEntity(v) end end
		end
	end
	loadAnimDict("mp_common")
	loadAnimDict("amb@prop_human_atm@male@enter")
	if bag == nil then bag = makeProp({prop = "prop_paper_bag_small", coords = vec4(0,0,0,0)}, 0, 1) end
	AttachEntityToEntity(bag, data.Ped, GetPedBoneIndex(data.Ped, 57005), 0.1, -0.0, 0.0, -90.0, 0.0, 0.0, true, true, false, true, 1, true)
	--Calculate if you're facing the ped--
	ClearPedTasksImmediately(data.Ped)
	lookEnt(data.Ped)
	TaskPlayAnim(Ped, "amb@prop_human_atm@male@enter", "enter", 1.0, 1.0, 0.3, 16, 0.2, 0, 0, 0)	--Start animations
	TaskPlayAnim(data.Ped, "mp_common", "givetake2_b", 1.0, 1.0, 0.3, 16, 0.2, 0, 0, 0)
	Wait(1000)
	AttachEntityToEntity(bag, Ped, GetPedBoneIndex(Ped, 57005), 0.1, -0.0, 0.0, -90.0, 0.0, 0.0, true, true, false, true, 1, true)
	Wait(1000)
	StopAnimTask(Ped, "amb@prop_human_atm@male@enter", "enter", 1.0)
	StopAnimTask(data.Ped, "mp_common", "givetake2_b", 1.0)
	TaskStartScenarioInPlace(data.Ped, "WORLD_HUMAN_CLIPBOARD", -1, true)
	unloadAnimDict("mp_common")
	unloadAnimDict("amb@prop_human_atm@male@enter")
	destroyProp(bag) unloadModel(`prop_paper_bag_small`)
	bag = nil
	for k in pairs(Config.Prices) do
		if k == data.item then TriggerServerEvent('jim-recycle:Selling:Mat', {item = data.item, Ped = data.Ped }) Selling = false lockInv(false) return end
	end
	TriggerServerEvent("jim-recycle:TradeItems", { item = data.item, amount = data.amount })
	Selling = false
	lockInv(false)
end)

RegisterNetEvent('jim-recycle:Selling:Menu', function(data)
	if Selling then return end
	local sellMenu = {}
	if Config.Menu == "qb" then
		sellMenu[#sellMenu+1] = { icon = "recyclablematerial", header = Loc[Config.Lan].menu["sell_mats"], txt = Loc[Config.Lan].menu["sell_mats_txt"], isMenuHeader = true }
		sellMenu[#sellMenu+1] = { icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].menu["close"], params = { event = "jim-recycle:CloseMenu" } }
	end
	for item, price in pairsByKeys(Config.Prices) do
		sellMenu[#sellMenu+1] = {
			disabled = not HasItem(item, 1),
			icon = "nui://"..Config.img..Core.Shared.Items[item].image,
			header = Core.Shared.Items[item].label,	txt = Loc[Config.Lan].menu["sell_all"]..price..Loc[Config.Lan].menu["each"],
			params = { event = "jim-recycle:SellAnim", args = { Ped = data.Ped, item = item } },
			title = Core.Shared.Items[item].label, description = Loc[Config.Lan].menu["sell_all"]..price..Loc[Config.Lan].menu["each"],
			event = "jim-recycle:SellAnim", args = { Ped = data.Ped, item = item },
		}
	end
	if Config.Menu == "ox" then	exports.ox_lib:registerContext({id = 'sellMenu', title = Loc[Config.Lan].menu["sell_mats"], position = 'top-right', options = sellMenu })	exports.ox_lib:showContext("sellMenu")
	elseif Config.Menu == "qb" then	exports['qb-menu']:openMenu(sellMenu) end
	lookEnt(data.Ped)
end)

--Recyclable Trader
RegisterNetEvent('jim-recycle:Trade:Menu', function(data)
	if Selling then return end
	local tradeMenu = {}
	local icon = "nui://"..Config.img..Core.Shared.Items["recyclablematerial"].image
	if Config.Menu == "qb" then
		tradeMenu[#tradeMenu+1] = { icon = icon, header = Loc[Config.Lan].menu["mats_trade"], isMenuHeader = true }
		tradeMenu[#tradeMenu+1] = { icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].menu["close"], params = { event = "jim-recycle:CloseMenu" } }
	end
	local tradeTable = {}
	for k, v in pairs(Config.RecycleAmounts) do
		if type(k) == "number" then
			tradeTable[#tradeTable+1] = v
			tradeTable[#tradeTable].amount = k
		end
	end
	for _, v in pairs(Config.RecycleAmounts["Trade"]) do
		tradeMenu[#tradeMenu+1] = {
			disabled = not HasItem("recyclablematerial", v.amount),
			icon = icon,
			header = v.amount.." "..Loc[Config.Lan].menu["trade"],
			title = v.amount.." "..Loc[Config.Lan].menu["trade"],
			params = { event = "jim-recycle:SellAnim", args = { item = "recyclablematerial", amount = v.amount, Ped = data.Ped } },
			event = "jim-recycle:SellAnim", args = { item = "recyclablematerial", amount = v.amount, Ped = data.Ped }
		}
		Wait(0)
	end
	if Config.Menu == "ox" then	exports.ox_lib:registerContext({id = 'tradeMenu', title = Loc[Config.Lan].menu["sell_mats"], position = 'top-right', options = tradeMenu })	exports.ox_lib:showContext("tradeMenu")
	elseif Config.Menu == "qb" then	exports['qb-menu']:openMenu(tradeMenu) end
	lookEnt(data.Ped)
end)

--Recyclable Trader
RegisterNetEvent('jim-recycle:Bottle:Menu', function(data)
	if Selling then return end
	local tradeMenu = {}
	if Config.Menu == "qb" then
		tradeMenu[#tradeMenu+1] = { icon = "recyclablematerial", header = Loc[Config.Lan].menu["sell_mats"], txt = Loc[Config.Lan].menu["sell_mats_txt"], isMenuHeader = true }
		tradeMenu[#tradeMenu+1] = { icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].menu["close"], params = { event = "jim-recycle:CloseMenu" } }
	end
	for _, item in pairsByKeys(Config.BottleBankTable) do
		tradeMenu[#tradeMenu+1] = {
			disabled = not HasItem(item, 1),
			icon = "nui://"..Config.img..Core.Shared.Items[item].image,
			header = Core.Shared.Items[item].label, txt = Loc[Config.Lan].menu["sell_all"]..Config.Prices[item]..Loc[Config.Lan].menu["each"],
			params = { event = "jim-recycle:SellAnim", args = { item = item, Ped = data.Ped } },
			title = Core.Shared.Items[item].label, description = Loc[Config.Lan].menu["sell_all"]..Config.Prices[item]..Loc[Config.Lan].menu["each"],
			event = "jim-recycle:SellAnim", args = { item = item, Ped = data.Ped },
		}
	end
	if Config.Menu == "ox" then	exports.ox_lib:registerContext({id = 'tradeMenu', title = Loc[Config.Lan].menu["sell_mats"], position = 'top-right', options = tradeMenu })	exports.ox_lib:showContext("tradeMenu")
	elseif Config.Menu == "qb" then	exports['qb-menu']:openMenu(tradeMenu) end
	lookEnt(data.Ped)
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
	for _, v in pairs(Peds) do unloadModel(GetEntityModel(v)) DeletePed(v) end
	for _, v in pairs(Props) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
	for _, v in pairs(searchProps) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
	unloadModel(GetEntityModel(TrollyProp)) DeleteObject(TrollyProp)
	unloadModel(GetEntityModel(scrapProp)) DeleteObject(scrapProp)
	for _, v in pairs(searchProps) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
end)
