Scrapping = {}

if Config.ScrapyardSearching.Enable then
    debugPrint("^5Debug^7: ^2Loading^7: '^6Scrapyard Searching^7'")
    local Searching = false
	--Dumpster Third Eye
    onPlayerLoaded(function()
        createModelTarget(Config.ScrapyardSearching.models, {
            {
                action = function(data)
                    Scrapping.StartSearch(type(data) == "table" and data.entity or data)
                end,
                icon = "fas fa-dumpster",
                label = Loc[Config.Lan].target["search"],
            }
        }, 1.5)
    end, true)

    Scrapping.StartSearch = function(entity)
        local Ped = PlayerPedId()
        local searchSuccess = nil
        if not Searching then Searching = true else return end
        local searched = false

        debugPrint("^5Debug^7: ^2Starting Search of entity^7: '^6"..entity.."^7'")
        if Config.ScrapyardSearching.searched[entity] then
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
                triggerNotify(nil, Loc[Config.Lan].success["get_scrap"], "success")
                Scrapping.startSearching(GetEntityCoords(entity))
            else
                triggerNotify(nil, Loc[Config.Lan].error["nothing"], "error")
                lockInv(false)
            end
            Searching = false

            Config.ScrapyardSearching.searched[entity] = true
            Wait(1000)
            stopAnim("anim@amb@machinery@speed_drill@", "look_around_left_02_amy_skater_01", Ped)
        end
    end

    --Search animations
    Scrapping.startSearching = function(coords)
        local Ped = PlayerPedId()

        --Calculate if you're facing the scrap--
        if #(coords - GetEntityCoords(Ped)) > 1.5 then
            TaskGoStraightToCoord(Ped, coords, 0.4, 200, 0.0, 0)
            Wait(300)
        end
        lookEnt(coords)
        playAnim("amb@prop_human_bum_bin@base", "base", Config.ScrapyardSearching.searchTime, 17, Ped)
        lockInv(true)

        if progressBar({
            label = Loc[Config.Lan].progressbar["search"],
            time = Config.ScrapyardSearching.searchTime,
            cancel = true,
        }) then
            TriggerServerEvent("jim-recycle:server:getScrapReward")
        else

        end
        stopAnim("amb@prop_human_bum_bin@base", "base", Ped)
        lockInv(false)
        Searching = false
    end
end