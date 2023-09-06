if Config.DumpsterDiving.Enable then if Config.Debug then print("^5Debug^7: ^2Loading^7: '^6Dumpster Diving^7'") end
    local Searching = false -- No touch
    --Dumpster Third Eye
    exports['qb-target']:AddTargetModel(Config.DumpsterDiving.models,
        { options = {
            { event = "jim-recycle:Dumpsters:Search",
            icon = "fas fa-dumpster",
            label = Loc[Config.Lan].target["search_trash"],
        }, }, distance = 1.5 })

    --Search animations
    local function startSearching(coords) local Ped = PlayerPedId()
        Searching = true
        lockInv(true)
        --Calculate if you're facing the trash--
        if #(coords - GetEntityCoords(Ped)) > 1.5 then TaskGoStraightToCoord(Ped, coords, 0.4, 200, 0.0, 0) Wait(300) end
        lookEnt(coords)
        --    if not IsPedHeadingTowardsPosition(Ped, coords, 20.0) then TaskTurnPedToFaceCoord(Ped, coords, 1500) Wait(1500) end
        loadAnimDict('amb@prop_human_bum_bin@base')
        --Play Serach animation
        TaskPlayAnim(Ped, 'amb@prop_human_bum_bin@base', 'base', 2.0, 2.0, Config.DumpsterDiving.searchTime, 1, 1, 0, 0, 0)
        FreezeEntityPosition(Ped, true)
        Wait(Config.DumpsterDiving.searchTime)
        --Stop Animation
        ClearPedTasks(Ped)
        FreezeEntityPosition(Ped, false)
        --Allow a new search
        Searching = false
        unloadAnimDict('amb@prop_human_bum_bin@base')
        --Give rewards
        --Give rewards
        for i = 1, math.random(1, 2) do toggleItem(true, Config.DumpItems[math.random(1, #Config.DumpItems)], math.random(1, 3)) Wait(100) end
        --If two random numbers match, give bonus
        if math.random(1, 3) == math.random(1, 3) then toggleItem(true, "rubber", math.random(1, 4)) Wait(100) end
        lockInv(false)
    end

    RegisterNetEvent('jim-recycle:Dumpsters:Search', function() local Ped = PlayerPedId()
        if not Searching then Searching = true else return end
        lockInv(true)
        local dumpsterFound = false
        local searched = Config.DumpsterDiving.searched
        local dumpsterModels = Config.DumpsterDiving.models
        for i = 1, #dumpsterModels do
            local toDumpster = GetClosestObjectOfType(GetEntityCoords(Ped), 1.0, dumpsterModels[i], false, false, false)
            if #(GetEntityCoords(Ped) - GetEntityCoords(toDumpster)) < 1.8 then
                if Config.Debug then print("^5Debug^7: ^2Starting Search of entity^7: '^6"..toDumpster.."^7'") end
                for i = 1, #searched do
                    if searched[i] == toDumpster then dumpsterFound = true end -- Theres a dumpster nearby
                    if i == #searched and dumpsterFound then triggerNotify(nil, Loc[Config.Lan].error["searched"], "error") return -- Let player know already searched
                    elseif i == #searched and not dumpsterFound then -- If hasn't been searched yet
                        lookEnt(GetEntityCoords(toDumpster))
                        loadAnimDict("anim@amb@machinery@speed_drill@")
                        TaskPlayAnim(Ped, "anim@amb@machinery@speed_drill@", "look_around_left_02_amy_skater_01", 1.0, 1.0, 3500, 1.5, 5, 0, 0, 0)
                        local searchSuccess = false
                        if Config.DumpsterDiving.skillcheck == "qb-lock" then
                            local Skillbar = exports['qb-lock']:StartLockPickCircle(math.random(2,4), math.random(7,10), success)
                            if Skillbar then searchSuccess = true end
                        elseif Config.DumpsterDiving.skillcheck == "ps-ui" then
                            exports['ps-ui']:Circle(function(Skillbar)
                                if Skillbar then searchSuccess = true end
                            end, 2, 20)
                        elseif Config.DumpsterDiving.skillcheck == "qb-skillbar" then
                            local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
                            Skillbar.Start({ duration = math.random(2500,5000), pos = math.random(10, 30), width = math.random(10, 20),	},	function()
                            -- On success
                                searchSuccess = true
                            end, function() -- On fail
                            end)
                        elseif Config.DumpsterDiving.skillcheck == "ox_lib" then
                            local Skillbar = exports.ox_lib:skillCheck({'easy', 'easy', 'easy' }, {'1', '2', '3', '4'})
                            if Skillbar then searchSuccess = true end
                        else
                            triggerNotify(nil, Loc[Config.Lan].success["get_trash"], "success")
                            startSearching(GetEntityCoords(toDumpster))
                        end

                        if searchSuccess then
                            triggerNotify(nil, Loc[Config.Lan].success["get_trash"], "success")
                            startSearching(GetEntityCoords(toDumpster))
                        else
                            triggerNotify(nil, Loc[Config.Lan].error["nothing"], "error")
                        end

                        Config.DumpsterDiving.searched[i+1] = toDumpster
                        Wait(1000)
                        ClearPedTasks(Ped)
                        Searching = false
                        break
                    end
                end
            end
        end
        lockInv(false)
    end)
end