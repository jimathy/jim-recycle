if Config.ScrapyardSearching.Enable then
    onResourceStart(function()
        Wait(100)
        for i = 1, #Config.ScrapyardSearching.ScrapItems do
            if not Items[Config.ScrapyardSearching.ScrapItems[i].item] then
                print("^1Error^7: ^2ScrapItems^7: ^2Missing Item from ^5Shared Items^7: '^6"..Config.ScrapyardSearching.ScrapItems[i].item.."^7'")
            end
        end
    end, true)

    RegisterServerEvent('jim-recycle:server:getScrapReward', function()
        local src = source
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
    end)
end

