local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	for k in pairs(Config.DumpItems) do if not QBCore.Shared.Items[k] then print("Missing Item from QBCore.Shared.Items: '"..k.."'") end end
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
