if Config.ScrapyardSearching.Enable then
    onResourceStart(function()
        Wait(100)
        for i = 1, #Config.ScrapyardSearching.ScrapItems do
            if not Items[Config.ScrapyardSearching.ScrapItems[i].item] then
                print("^1Error^7: ^2ScrapItems^7: ^2Missing Item from ^5Shared Items^7: '^6"..Config.ScrapyardSearching.ScrapItems[i].item.."^7'")
            end
        end
    end, true)

    local authCheck = {}
    createCallback(getScript()..":auth:scrapRequestReward", function(source, time)
        local src = source
        if authCheck[src] then
            print("^1Error^7: ^1User tried to collect Scrap but was already collecting")
            return false
        else
            authCheck[src] = {
                time = GetGameTimer() + (debugMode and 1000 or time),
            }
            debugPrint("^5Debug^7: ^2Registering Scrap collection for source^7: "..src)
            return true
        end
    end)

    RegisterServerEvent('jim-recycle:server:getScrapReward', function()
        local src = source
        if not authCheck[src] then
            print("^1Error^7: ^1User tried to collect Scrap without requesting first")
        else
            if authCheck[src].time < GetGameTimer() then
                debugPrint("^5Debug^7: ^2Completing Scrap collection for source^7: "..src)
                debugPrint("^5Debug^7: ^2Time match^7 - ^2Saved^7: "..authCheck[src].time.." | ^2Current^7: "..GetGameTimer())
                for i = 1, math.random(1, 2) do
                    local totalRarity = 0
                    for _, item in ipairs(Config.ScrapyardSearching.ScrapItems) do
                        totalRarity += (101 - tonumber(item.rarity))
                    end

                    local randNum = math.random(1, totalRarity)

                    local selectedItem, amount = nil, 0
                    for _, item in ipairs(Config.ScrapyardSearching.ScrapItems) do
                        if randNum <= (101 - tonumber(item.rarity)) then
                            selectedItem = item.item
                            amount = math.random(item.min, item.max)
                            break
                        else
                            randNum = randNum - (101 - tonumber(item.rarity))
                        end
                    end

                    if selectedItem then
                        addItem(selectedItem, amount, nil, src)
                    else
                        print("No item selected due to rarity calculation or error.")
                    end
                end
                authCheck[src] = nil
            else
                print("^1Error^7: ^1Scrap Time mismatch^7 - ^1Saved^7: "..authCheck[src].time.." | ^1Current^7: "..GetGameTimer())
                authCheck[src] = nil
            end
        end
    end)
end

