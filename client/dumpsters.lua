Dumpsters = {}

if Config.DumpsterDiving.Enable then
    debugPrint("^5Debug^7: ^2Loading^7: '^6Dumpster Diving^7'")
    local Searching = false -- No touch

    --Dumpster Third Eye
    onPlayerLoaded(function()
        createModelTarget(Config.DumpsterDiving.models, {
            {   action = function(data)
                    Dumpsters.StartSearch(type(data) == "table" and data.entity or data)
                end,
                icon = "fas fa-dumpster",
                label = Loc[Config.Lan].target["search_trash"],
            }
        }, 1.5)
    end, true)


    Dumpsters.StartSearch = function(entity)
        local Ped = PlayerPedId()
        local searchSuccess = nil
        if not Searching then Searching = true else return end
        local searched = false
        debugPrint("^5Debug^7: ^2Starting Search of entity^7: '^6"..entity.."^7'")

        if Config.DumpsterDiving.searched[entity] then
            triggerNotify(nil, Loc[Config.Lan].error["searched"], "error")
            searched = true
            Searching = false
            lockInv(false)
            return
        end

        if not searched then -- If hasn't been searched yet
            lookEnt(entity)
            playAnim("anim@amb@machinery@speed_drill@", "look_around_left_02_amy_skater_01", 35000, 1, Ped)

            if Config.System.skillCheck then
                searchSuccess = skillCheck()
            else
                searchSuccess = true
            end

            while searchSuccess == nil do
                Wait(1)
            end

            if searchSuccess then
                triggerNotify(nil, Loc[Config.Lan].success["get_trash"], "success")
                Dumpsters.searchAnim(GetEntityCoords(entity))
            else
                lockInv(false)
                triggerNotify(nil, Loc[Config.Lan].error["nothing"], "error")
            end
            Searching = false

            Config.DumpsterDiving.searched[entity] = true
            Wait(1000)
            stopAnim("anim@amb@machinery@speed_drill@", "look_around_left_02_amy_skater_01", Ped)
        end
    end

    --Search animations
    Dumpsters.searchAnim = function(coords)
        local Ped = PlayerPedId()

        --Calculate if you're facing the trash--
        if #(coords - GetEntityCoords(Ped)) > 1.5 then
            TaskGoStraightToCoord(Ped, coords, 0.4, 200, 0.0, 0)
            Wait(300)
        end
        lookEnt(coords)
        playAnim("amb@prop_human_bum_bin@base", "base", Config.DumpsterDiving.searchTime, 1, Ped)
        lockInv(true)

        if progressBar({
            label = Loc[Config.Lan].progressbar["search"],
            time = Config.DumpsterDiving.searchTime,
            cancel = true,
        }) then
            TriggerServerEvent("jim-recycle:server:getDumpsterReward")
        end

        stopAnim("amb@prop_human_bum_bin@base", "base", Ped)
        lockInv(false)
        Searching = false
    end
end