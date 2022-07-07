local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	for k, v in pairs(Config.Prices) do if not QBCore.Shared.Items[k] then print("Missing Item from QBCore.Shared.Items: '"..k.."'") end end
	if not QBCore.Shared.Items["recyclablematerial"] then print("Missing Item from QBCore.Shared.Items: 'recyclablematerial'") end
	Config.TradeTable = {} for k in pairs(Config.Prices) do Config.TradeTable[#Config.TradeTable+1] = k end
end)
---ITEM REQUIREMENT CHECKS
QBCore.Functions.CreateCallback('jim-recycle:GetRecyclable', function(source, cb)
	if QBCore.Functions.GetPlayer(source).Functions.GetItemByName("recyclablematerial") then cb(QBCore.Functions.GetPlayer(source).Functions.GetItemByName("recyclablematerial").amount)
	else cb(0) end
end)

--- Event For Getting Recyclable Material----
RegisterServerEvent("jim-recycle:getrecyclablematerial", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = math.random(10, 30)
    Player.Functions.AddItem("recyclablematerial", amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["recyclablematerial"], 'add', amount)
    Wait(500)
end)

RegisterServerEvent("jim-recycle:TradeItems", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local remAmount, min, max
	if data == 1 then
		remAmount = 1
		itemAmount = 1
		min = 1
		max = 1
	elseif data == 2 then
		remAmount = 10
		itemAmount = 2
		min = Config.RecycleAmounts.tenMin
		max = Config.RecycleAmounts.tenMax
	elseif data == 3 then
		remAmount = 100
		itemAmount = 6
		min = Config.RecycleAmounts.hundMin
		max = Config.RecycleAmounts.hundMax
	elseif data == 4 then
		remAmount = 1000
		itemAmount = 8
		min = Config.RecycleAmounts.thouMin
		max = Config.RecycleAmounts.tenMax
	end
	Player.Functions.RemoveItem("recyclablematerial", remAmount)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["recyclablematerial"], 'remove', remAmount)
	Wait(1000)
	for i = 1, itemAmount do
		randItem = Config.TradeTable[math.random(1, #Config.TradeTable)]
		local amount = math.random(min, max)
		Player.Functions.AddItem(randItem, amount)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add', amount)
	end
end)

RegisterNetEvent("jim-recycle:Selling:Mat", function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item) ~= nil then
        local amount = Player.Functions.GetItemByName(item).amount
        local pay = (amount * Config.Prices[item])
        Player.Functions.RemoveItem(item, amount)
        Player.Functions.AddMoney('cash', pay)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove', amount)
        TriggerClientEvent("QBCore:Notify", src, "Payment received. Total: $"..pay, "success")
    end
end)