onResourceStart(function()
	Wait(100)
	for k in pairs(Config.Other.Prices.Items) do
		if not Items[k] then
			print("^5Debug^7: ^6Prices^7: ^2Missing Item from ^5Shared Items^7: '^6"..k.."^7'")
		end
	end
	if not Items["recyclablematerial"] then
		print("^5Debug^7: ^2Missing Item from ^5Shared Items^7: '^6recyclablematerial^7'")
	end
end, true)

RegisterServerEvent("jim-recycle:Server:DoorCharge", function()
	local src = source
	chargePlayer(Config.RecyclingCenter.PayAtDoor, "cash", src)
end)

RegisterServerEvent("jim-recycle:Server:TradeItems", function(data)
    local src = source
	local table = {}
	for i = 1, #Config.Other.RecycleAmounts["Trade"] do
		if Config.Other.RecycleAmounts["Trade"][i].amount == data.amount then
			table = Config.Other.RecycleAmounts["Trade"][i]
			break
		end
	end
	removeItem("recyclablematerial", data.amount, src)
	Wait(1000)
	for i = 1, table.itemGive do
		addItem(data.item, math.random(table.Min, table.Max), nil, src)
		Wait(100)
	end
end)