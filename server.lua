local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then 
		for k, v in pairs(Config.Prices) do if not QBCore.Shared.Items[k] then print("Missing Item from QBCore.Shared.Items: '"..k.."'") end end
		if not QBCore.Shared.Items["recyclablematerial"] then print("Missing Item from QBCore.Shared.Items: 'recyclablematerial'") end		
	end
end)

--- Event For Getting Recyclable Material----
RegisterServerEvent("jim-recycle:getrecyclablematerial", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = math.random(10, 30)
    Player.Functions.AddItem("recyclablematerial", amount, false, {["quality"] = nil})
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["recyclablematerial"], 'add', amount)
    Citizen.Wait(500)
end)

RegisterServerEvent("jim-recycle:TradeItems", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local randItem = ""
	local amount = 0
	if data == 1 then
		if Player.Functions.GetItemByName('recyclablematerial') ~= nil and Player.Functions.GetItemByName('recyclablematerial').amount >= 10 then
			Player.Functions.RemoveItem("recyclablematerial", 10)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["recyclablematerial"], 'remove', 10)
			Citizen.Wait(1000)
			for i = 1, 3 do
				randItem = Config.TradeTable[math.random(1, #Config.TradeTable)]
				amount = math.random(Config.tenmin, Config.tenmax)
				Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add', amount)
			end
		else
			TriggerClientEvent('QBCore:Notify', src, "You Don't Have Enough Items")
		end
	elseif data == 2 then
		if Player.Functions.GetItemByName('recyclablematerial') ~= nil and Player.Functions.GetItemByName('recyclablematerial').amount >= 100 then
			Player.Functions.RemoveItem("recyclablematerial", "100")
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["recyclablematerial"], 'remove', 100)
			Citizen.Wait(500)
			for i = 1, 8 do
				randItem = Config.TradeTable[math.random(1, #Config.TradeTable)]
				amount = math.random(Config.bulkmin, Config.bulkmax)
				Player.Functions.AddItem(randItem, amount, false, {["quality"] = nil})
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add', amount)
				Citizen.Wait(500)
			end
		else
			TriggerClientEvent('QBCore:Notify', src, "You Do Not Have Enough Items")
		end
    end
end)

RegisterServerEvent("jim-recycle:Selling:All", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local payment = 0
	for k, v in pairs(Config.Prices) do
        if Player.Functions.GetItemByName(v.name) ~= nil then
            item = Player.Functions.GetItemByName(v.name).amount
            pay = (item * v.amount)
            Player.Functions.RemoveItem(v.name, item)
            Player.Functions.AddMoney('cash', pay)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v.name], 'remove', item)
			payment = payment+pay
        end
    end
    Wait(100)
	TriggerClientEvent("QBCore:Notify", src, "Total: $"..payment, 'success')
end)

RegisterNetEvent("jim-recycle:Selling:Mat", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.GetItemByName(data) ~= nil then
        local amount = Player.Functions.GetItemByName(data).amount
        local pay = (amount * Config.Prices[data].amount)
        Player.Functions.RemoveItem(data, amount)
        Player.Functions.AddMoney('cash', pay)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data], 'remove', amount)
        TriggerClientEvent("QBCore:Notify", src, "Payment received. Total: $"..pay, "success")
    else
        TriggerClientEvent("QBCore:Notify", src, "You don't have any "..QBCore.Shared.Items[data].label.. "", "error")
    end
end)


RegisterServerEvent('jim-recycle:Dumpsters:Reward', function()
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
	for i = 1, math.random(1, 4) do
		local item = Config.DumpItems[math.random(1, #Config.DumpItems)]
		local amount = math.random(1, 3)
		Player.Functions.AddItem(item, amount)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', amount)
		Citizen.Wait(100)
	end
	local Luck = math.random(1, 4)
	local Odd = math.random(1, 4)
	if Luck == Odd then
		local random = math.random(1, 4)
		Player.Functions.AddItem("rubber", random)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["rubber"], 'add', random)
	end
end)
