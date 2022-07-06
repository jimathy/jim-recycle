local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	for _, v in pairs(Config.ScrapItems) do if not QBCore.Shared.Items[v] then print("ScrapItem: Missing Item from QBCore.Shared.Items: '"..v.."'") end end
end)

RegisterServerEvent('jim-recycle:Scrap:Reward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	for i = 1, math.random(1, 2) do
		local item = Config.ScrapItems[math.random(1, #Config.ScrapItems)]
		local amount = math.random(1, 4)
		Player.Functions.AddItem(item, amount)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', amount)
		Citizen.Wait(100)
	end
	--If two random numbers match, give reward
	if math.random(1, 3) == math.random(1, 3) then
		local random = math.random(1, 3)
		Player.Functions.AddItem("rubber", random)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["rubber"], 'add', random)
	end
end)
