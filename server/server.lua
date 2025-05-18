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


RegisterServerEvent("jim-recycle:Server:TradeItems", function(data, token)
    local src = source
    if src then
        if not checkToken(src, token, "stash", getPlayer(src).name) then
            return
        end
    end
    local tradeInfo
    for _, v in pairs(Config.Other.RecycleAmounts["Trade"]) do
        if v.amount == data.amount then
            tradeInfo = v
            break
        end
    end

    if not tradeInfo then
        print("TradeInfo not found for amount: "..tostring(data.amount))
        return
    end

    local hasAll, _ = hasItem("recyclablematerial", data.amount, src)

    if hasAll then
        removeItem("recyclablematerial", data.amount, src)

        Wait(500)
        for i = 1, tradeInfo.itemGive do
            local count = math.random(tradeInfo.Min, tradeInfo.Max)
            if Config.RecyclingCenter.TradeForRandomItems then
                addItem(Config.Other.TradeTable[math.random(1, #Config.Other.TradeTable)], count, nil, src)
            else
                addItem(data.item, count, nil, src)
            end
            Wait(100)
        end
    else
        triggerNotify(nil, "Not Enough Items", "error", src)
    end
end)