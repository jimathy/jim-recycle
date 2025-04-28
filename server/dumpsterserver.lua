if Config.DumpsterDiving.Enable then
    onResourceStart(function()
        Wait(100)
        for i = 1, #Config.DumpsterDiving.DumpItems do
            if not Items[Config.DumpsterDiving.DumpItems[i].item] then
                print("^1Error^7: ^2DumpItems^7: ^2Missing Item from ^5Shared Items^7: '^6"..Config.DumpsterDiving.DumpItems[i].item.."^7'")
            end
        end
    end, true)


    function GetRandomItemByRarity(table)

    end

    RegisterServerEvent('jim-recycle:server:getDumpsterReward', function()
        local src = source
        local commonRoll = math.random(1, 100)
        local itemsOfRarity = {}

        if commonRoll <= 90 then
            -- Choose randomly between 'bottle' and 'can'
            if math.random(1, 2) == 1 then
                return 'bottle'
            else
                return 'can'
            end
        else
            -- For the remaining 10%, use the original rarity system
            local rarityRoll = math.random(1, 100)
            local rarityLevel

            if rarityRoll <= 5 then
                rarityLevel = 1 -- Super Rare (5% of the remaining 10%)
            elseif rarityRoll <= 15 then
                rarityLevel = 2 -- Rare (10% of the remaining 10%)
            elseif rarityRoll <= 35 then
                rarityLevel = 3 -- Uncommon (20% of the remaining 10%)
            else
                rarityLevel = 4 -- Common (65% of the remaining 10%)
            end

            for _, item in pairs(Config.DumpsterDiving.DumpItems) do
                if item.rarity == rarityLevel then
                    table.insert(itemsOfRarity, item.item)
                end
            end

            -- If no items found for the rolled rarity, default to a common item
            if #itemsOfRarity == 0 then
                if math.random(1, 2) == 1 then
                    return 'bottle'
                else
                    return 'can'
                end
            end
        end

        addItem(itemsOfRarity[math.random(1, #itemsOfRarity)], math.random(1, 3), nil, src)
        Wait(100)
    end)
end