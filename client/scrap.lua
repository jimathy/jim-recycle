if Config.ScrapyardSearching.Enable then if Config.Debug then print("^5Debug^7: ^2Loading^7: '^6Scrapyard Searching^7'") end
    local Searching = false
	--Dumpster Third Eye
	exports['qb-target']:AddTargetModel(Config.ScrapyardSearching.models,
    { options = {
        { event = "jim-recycle:Scrap:Search",
        icon = "fas fa-dumpster",
        label = Loc[Config.Lan].target["search"],
    }, }, distance = 1.5 })

    --Search animations
    local function startSearching(coords) local Ped = PlayerPedId()
        --Calculate if you're facing the trash--
        if #(coords - GetEntityCoords(Ped)) > 1.5 then TaskGoStraightToCoord(Ped, coords.x, coords.y, coords.z, 0.4, 200, 0.0, 0) Wait(300) end
        lookEnt(coords)
        loadAnimDict('amb@prop_human_bum_bin@base')
        --Play Search animation
        TaskPlayAnim(Ped, 'amb@prop_human_bum_bin@base', 'base', 2.0, 2.0, Config.ScrapyardSearching.searchTime, 1, 1, 0, 0, 0)
        FreezeEntityPosition(Ped, true)
        Wait(Config.DumpsterDiving.searchTime)
        --Stop Animation
        ClearPedTasks(Ped)
        FreezeEntityPosition(Ped, false)
        --Allow a new search
        Searching = false
        unloadAnimDict('amb@prop_human_bum_bin@base')
        --Give rewards
        for i = 1, math.random(1, 2) do toggleItem(true, Config.ScrapItems[math.random(1, #Config.ScrapItems)], math.random(1, 4)) Wait(100) end
        --If two random numbers match, give bonus
        if math.random(1, 3) == math.random(1, 3) then toggleItem(true, "rubber", math.random(1, 3)) Wait(100) end
        lockInv(false)
    end

    RegisterNetEvent('jim-recycle:Scrap:Search', function(data) local Ped = PlayerPedId()
        local searchSuccess = nil
        if not Searching then Searching = true else print("test") return end
        lockInv(true)
        local searched = false
        if Config.Debug then print("^5Debug^7: ^2Starting Search of entity^7: '^6"..data.entity.."^7'") end
        for i = 1, #Config.ScrapyardSearching.searched do
            if Config.ScrapyardSearching.searched[i] == data.entity then
                triggerNotify(nil, Loc[Config.Lan].error["searched"], "error") searched = true Searching = false return
            end
        end
        if not searched then -- If hasn't been searched yet
            loadAnimDict("anim@amb@machinery@speed_drill@")
            TaskPlayAnim(Ped, "anim@amb@machinery@speed_drill@", "look_around_left_02_amy_skater_01", 1.0, 1.0, 3500, 1.5, 5, 0, 0, 0)
            if Config.ScrapyardSearching.skillcheck == "qb-lock" then
                local Skillbar = exports['qb-lock']:StartLockPickCircle(math.random(2,4), math.random(7,10), success)
                if Skillbar then searchSuccess = true else searchSuccess = false end
            elseif Config.ScrapyardSearching.skillcheck == "ps-ui" then
                exports['ps-ui']:Circle(function(Skillbar)
                    if Skillbar then searchSuccess = true else searchSuccess = false end
                end, 2, 20)
            elseif Config.ScrapyardSearching.skillcheck == "qb-skillbar" then
                local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
                Skillbar.Start({ duration = math.random(2500,5000), pos = math.random(10, 30), width = math.random(10, 20),	},
                function() searchSuccess = true end, function() searchSuccess = false end)
            elseif Config.ScrapyardSearching.skillcheck == "ox_lib" then
                local Skillbar = exports.ox_lib:skillCheck({'easy', 'easy', 'easy' }, {'1', '2', '3', '4'})
                if Skillbar then searchSuccess = true else searchSuccess = false end
            else
                searchSuccess = true
            end
            while searchSuccess == nil do Wait(1) end
            if searchSuccess then
                triggerNotify(nil, Loc[Config.Lan].success["get_scrap"], "success")
                startSearching(GetEntityCoords(data.entity))
            else
                triggerNotify(nil, Loc[Config.Lan].error["nothing"], "error")
                lockInv(false)
            end
            Config.ScrapyardSearching.searched[#Config.ScrapyardSearching.searched+1] = data.entity
            Wait(1000)
            ClearPedTasks(Ped)
        end
    end)
end