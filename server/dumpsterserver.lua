if Config.DumpsterDiving.Enable then
    onResourceStart(function()
        Wait(100)
        for i = 1, #Config.DumpsterDiving.DumpItems do
            if not Items[Config.DumpsterDiving.DumpItems[i].item] then
                print("^1Error^7: ^2DumpItems^7: ^2Missing Item from ^5Shared Items^7: '^6"..Config.DumpsterDiving.DumpItems[i].item.."^7'")
            end
        end
    end, true)

    RegisterServerEvent('jim-recycle:server:getDumpsterReward', function()
        local src = source
        local chosenItem
        local commonRoll = math.random(1, 100)

        if commonRoll <= 90 then
            -- 90% chance of basic item
            chosenItem = (math.random(1, 2) == 1) and 'bottle' or 'can'
        else
            -- 10% chance to use rarity system
            local rarityRoll = math.random(1, 100)
            local rarityLevel

            if rarityRoll <= 5 then
                rarityLevel = 1 -- Super Rare
            elseif rarityRoll <= 15 then
                rarityLevel = 2 -- Rare
            elseif rarityRoll <= 35 then
                rarityLevel = 3 -- Uncommon
            else
                rarityLevel = 4 -- Common
            end

            local itemsOfRarity = {}

            for _, item in pairs(Config.DumpsterDiving.DumpItems) do
                if item.rarity == rarityLevel then
                    table.insert(itemsOfRarity, item.item)
                end
            end

            if #itemsOfRarity > 0 then
                chosenItem = itemsOfRarity[math.random(1, #itemsOfRarity)]
            else
                -- fallback if no items for selected rarity
                chosenItem = (math.random(1, 2) == 1) and 'bottle' or 'can'
            end
        end

        addItem(chosenItem, math.random(1, 3), nil, src)
    end)
end