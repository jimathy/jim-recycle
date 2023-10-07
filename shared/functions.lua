Core = exports['qb-core']:GetCoreObject()

--Core = {}
if Config.Core == "qb" then
	local CoreConvert = exports['qb-core']:GetCoreObject()
	Core.Shared.Items = CoreConvert.Shared.Items
end
if Config.Core == "ox" then

end


function loadModel(model)
    local time = 1000
    if not HasModelLoaded(model) then if Config.Debug then print("^5Debug^7: ^2Loading Model^7: '^6"..model.."^7'") end
	while not HasModelLoaded(model) do if time > 0 then time = time - 1 RequestModel(model)
		else time = 1000 print("^5Debug^7: ^3LoadModel^7: ^2Timed out loading model ^7'^6"..model.."^7'") break end
		Wait(10) end
	end
end
function unloadModel(model) if Config.Debug then print("^5Debug^7: ^2Removing Model^7: '^6"..model.."^7'") end SetModelAsNoLongerNeeded(model) end
function loadAnimDict(dict)	if not HasAnimDictLoaded(dict) then if Config.Debug then print("^5Debug^7: ^2Loading Anim Dictionary^7: '^6"..dict.."^7'") end while not HasAnimDictLoaded(dict) do RequestAnimDict(dict) Wait(5) end end end
function unloadAnimDict(dict) if Config.Debug then print("^5Debug^7: ^2Removing Anim Dictionary^7: '^6"..dict.."^7'") end RemoveAnimDict(dict) end
function loadPtfxDict(dict)	if not HasNamedPtfxAssetLoaded(dict) then if Config.Debug then print("^5Debug^7: ^2Loading Ptfx Dictionary^7: '^6"..dict.."^7'") end while not HasNamedPtfxAssetLoaded(dict) do RequestNamedPtfxAsset(dict) Wait(5) end end end
function unloadPtfxDict(dict) if Config.Debug then print("^5Debug^7: ^2Removing Ptfx Dictionary^7: '^6"..dict.."^7'") end RemoveNamedPtfxAsset(dict) end

function makeProp(data, freeze, synced)
    loadModel(data.prop)
    local prop = CreateObject(data.prop, data.coords.x, data.coords.y, data.coords.z, synced or false, synced or false, false)
    SetEntityHeading(prop, data.coords.w+180.0)
    FreezeEntityPosition(prop, freeze or 0)
    if Config.Debug then
		local coords = { string.format("%.2f", data.coords.x), string.format("%.2f", data.coords.y), string.format("%.2f", data.coords.z), (string.format("%.2f", data.coords.w or 0.0)) }
		print("^5Debug^7: ^1Prop ^2Created^7: '^6"..prop.."^7' | ^2Hash^7: ^7'^6"..(data.prop).."^7' | ^2Coord^7: ^5vec4^7(^6"..(coords[1]).."^7, ^6"..(coords[2]).."^7, ^6"..(coords[3]).."^7, ^6"..(coords[4]).."^7)")
	end
	return prop
end

function getCoord(numA, numB) local base = 10^(numB or 0) return math.floor(numA * base + 0.5) / base end

function destroyProp(entity)
	if Config.Debug then print("^5Debug^7: ^2Destroying Prop^7: '^6"..entity.."^7'") end
	SetEntityAsMissionEntity(entity) Wait(5)
	DetachEntity(entity, true, true) Wait(5)
	DeleteObject(entity)
end

function makePed(model, coords, freeze, collision, scenario, anim)
	loadModel(model)
	local ped = CreatePed(0, model, coords.x, coords.y, coords.z-1.03, coords.w, false, false)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, freeze or true)
    if collision then SetEntityNoCollisionEntity(ped, PlayerPedId(), false) end
    if scenario then TaskStartScenarioInPlace(ped, scenario, 0, true) end
    if anim then
        loadAnimDict(anim[1])
        TaskPlayAnim(ped, anim[1], anim[2], 1.0, 1.0, -1, 1, 0.2, 0, 0, 0)
    end
	if Config.Debug then print("^5Debug^7: ^6Ped ^2Created for location^7: '^6"..model.."^7'") end
    return ped
end

function makeBlip(data)
	local blip = AddBlipForCoord(data.coords)
	SetBlipAsShortRange(blip, true)
	SetBlipSprite(blip, data.sprite or 1)
	SetBlipColour(blip, data.col or 0)
	SetBlipScale(blip, data.scale or 0.7)
	SetBlipDisplay(blip, (data.disp or 6))
	if data.category then SetBlipCategory(blip, data.category) end
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(tostring(data.name))
	EndTextCommandSetBlipName(blip)
	if Config.Debug then print("^5Debug^7: ^6Blip ^2created for location^7: '^6"..data.name.."^7'") end
	return blip
end

function lookEnt(entity) local Ped = PlayerPedId()
	if type(entity) == "vector3" then
		if not IsPedHeadingTowardsPosition(Ped, entity, 30.0) then
			TaskTurnPedToFaceCoord(Ped, entity, 1500)
			if Config.Debug then print("^5Debug^7: ^2Turning Player to^7: '^6"..json.encode(entity).."^7'") end
			Wait(1500)
		end
	else
		if DoesEntityExist(entity) then
			if not IsPedHeadingTowardsPosition(Ped, GetEntityCoords(entity), 30.0) then
				TaskTurnPedToFaceCoord(Ped, GetEntityCoords(entity), 1500)
				if Config.Debug then print("^5Debug^7: ^2Turning Player to^7: '^6"..entity.."^7'") end
				Wait(1500)
			end
		end
	end
end

function triggerNotify(title, message, type, src)
	if Config.Notify == "okok" then
		if not src then	exports['okokNotify']:Alert(title, message, 6000, type)
		else TriggerClientEvent('okokNotify:Alert', src, title, message, 6000, type) end
	elseif Config.Notify == "qb" then
		if not src then	TriggerEvent("QBCore:Notify", message, type)
		else TriggerClientEvent("QBCore:Notify", src, message, type) end
	elseif Config.Notify == "t" then
		if not src then exports['t-notify']:Custom({title = title, style = type, message = message, sound = true})
		else TriggerClientEvent('t-notify:client:Custom', src, { style = type, duration = 6000, title = title, message = message, sound = true, custom = true}) end
	elseif Config.Notify == "infinity" then
		if not src then TriggerEvent('infinity-notify:sendNotify', message, type)
		else TriggerClientEvent('infinity-notify:sendNotify', src, message, type) end
	elseif Config.Notify == "rr" then
		if not src then exports.rr_uilib:Notify({msg = message, type = type, style = "dark", duration = 6000, position = "top-right", })
		else TriggerClientEvent("rr_uilib:Notify", src, {msg = message, type = type, style = "dark", duration = 6000, position = "top-right", }) end
	elseif Config.Notify == "ox" then
		if not src then	exports.ox_lib:notify({title = title, description = message, type = type or "success"})
		else TriggerClientEvent('ox_lib:notify', src, { type = type or "success", title = title, description = message }) end
	end
end

function toggleItem(give, item, amount) TriggerServerEvent("jim-recycle:server:toggleItem", give, item, amount) end

function lockInv(toggle)
	if toggle then LocalPlayer.state:set("inv_busy", true, true) TriggerEvent('inventory:client:busy:status', true) TriggerEvent('canUseInventoryAndHotbar:toggle', false)
	else LocalPlayer.state:set("inv_busy", false, true) TriggerEvent('inventory:client:busy:status', false) TriggerEvent('canUseInventoryAndHotbar:toggle', true) end
end

function pairsByKeys(t)
	local a = {}
	for n in pairs(t) do a[#a+1] = n end
	table.sort(a)
	local i = 0
	local iter = function() i = i + 1 if a[i] == nil then return nil else return a[i], t[a[i]] end end
	return iter
end
function countTable(table) local i = 0 for keys in pairs(table) do i = i + 1 end return i end

if Config.Inv == "ox" then
	function HasItem(items, amount) local count = exports.ox_inventory:Search('count', items) local amount = amount or 1
        if count >= amount then if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^5FOUND^7 ^3"..count.."^7/^3"..amount.." "..tostring(items)) end return true
        else if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2"..tostring(items).." ^1NOT FOUND^7") end return false end
	end
else
    function HasItem(items, amount)
        local amount, count = amount or 1, 0
        for _, itemData in pairs(Core.Functions.GetPlayerData().items) do
            if itemData and (itemData.name == items) then
                if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Item^7: '^3"..tostring(items).."^7' ^2Slot^7: ^3"..itemData.slot.." ^7x(^3"..tostring(itemData.amount).."^7)") end
                count += (itemData.amount or 1)
            end
        end
        if count >= amount then if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^5FOUND^7 ^3"..count.."^7/^3"..amount.." "..tostring(items)) end return true
        else if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end return false end
    end
end

function progressBar(data)
	local result = nil
	if Config.ProgressBar == "ox" then
		if exports.ox_lib:progressBar({	duration = Config.Debug and 1000 or data.time, label = data.label, useWhileDead = data.dead or false, canCancel = data.cancel or true,
			anim = { dict = data.dict, clip = data.anim, flag = data.flag or 8, scenario = data.task }, disable = { combat = true }, }) then result = true
		else result = false	end
	else
		Core.Functions.Progressbar("mechbar", data.label, data.time, data.dead, data.cancel,
			{ disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
			{ animDict = data.dict, anim = data.anim, flags = data.flag, task = data.task }, {}, {}, function()
				result = true
		end, function()
			result = false
		end, data.icon)
	end
	while result == nil do Wait(10) end
	return result
end
