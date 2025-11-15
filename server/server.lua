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

    -- Register Sell Shops
    for i = 1, #Config.Locations["BottleBanks"] do
        local loc = Config.Locations["BottleBanks"][i]
        local nameBank = "BottleBank:"..i
        registerSellShop(nameBank, loc.coords)
    end

    for i = 1, #Config.Locations["Recycle"] do
        local loc = Config.Locations["Recycle"][i]
        local nameSell = "Recycle:"..i
        registerSellShop(nameSell, loc.coords)
    end

    local authCheck = {}
    createCallback(getScript()..":auth:requestReward", function(source, time)
        local src = source
        if authCheck[src] then
            print("^1Error^7: ^1User tried to collect but was already collecting")
            return false
        else
            authCheck[src] = {
                time = GetGameTimer() + (debugMode and 1000 or time),
            }
            debugPrint("^5Debug^7: ^2Registering recycle collection for source^7: "..src)
            return true
        end
    end)

    createCallback(getScript()..":auth:collectReward", function(source)
        local src = source
        if not authCheck[src] then
            print("^1Error^7: ^1User tried to collect without requesting first")
            return false
        else
            if authCheck[src].time < GetGameTimer() then
                debugPrint("^5Debug^7: ^2Completing recycle collection for source^7: "..src)
                debugPrint("^5Debug^7: ^2Time match^7 - ^2Saved^7: "..authCheck[src].time.." | ^2Current^7: "..GetGameTimer())
                authCheck[src] = nil
                addItem("recyclablematerial", math.random(Config.Other.RecycleAmounts["Recycle"].Min, Config.Other.RecycleAmounts["Recycle"].Max), nil, src)
                return true
            else
                print("^1Error^7: ^1Time mismatch^7 - ^1Saved^7: "..authCheck[src].time.." | ^1Current^7: "..GetGameTimer())
                authCheck[src] = nil
                return false
            end
        end
    end)

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