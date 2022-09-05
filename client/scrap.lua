local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)

local searched = {34343435323} -- No Touch.
local canSearch = true -- No touch.
local searchTime = 3000 -- How long after successful skill check the serach takes
local scrap = { -- The mighty list of dumpters/trash cans
    `prop_wreckedcart`, `prop_snow_rub_trukwreck_2`, `prop_wrecked_buzzard`, `prop_rub_buswreck_01`, `prop_rub_buswreck_03`, `prop_rub_buswreck_06`, `prop_rub_carwreck_10`,
    `prop_rub_carwreck_11`, `prop_rub_carwreck_12`, `prop_rub_carwreck_13`, `prop_rub_carwreck_14`, `prop_rub_carwreck_15`, `prop_rub_carwreck_16`, `prop_rub_carwreck_17`,
    `prop_rub_carwreck_2`, `prop_rub_carwreck_3`, `prop_rub_carwreck_5`, `prop_rub_carwreck_7`, `prop_rub_carwreck_8`, `prop_rub_carwreck_9`, `prop_rub_railwreck_1`, `prop_rub_railwreck_2`,
    `prop_rub_railwreck_3`, `prop_rub_trukwreck_1`, `prop_rub_trukwreck_2`, `prop_rub_wreckage_3`, `prop_rub_wreckage_4`, `prop_rub_wreckage_5`, `prop_rub_wreckage_6`, `prop_rub_wreckage_7`,
    `prop_rub_wreckage_8`, `prop_rub_wreckage_9`, `ch1_01_sea_wreck_3`, `cs2_30_sea_ch2_30_wreck005`, `cs2_30_sea_ch2_30_wreck7`, `cs4_05_buswreck`,
}

--Loading/Unloading Asset Functions
local function loadAnimDict(dict) if Config.Debug then print("Debug: Loading Anim Dictionary: '"..dict.."'") end while not HasAnimDictLoaded(dict) do RequestAnimDict(dict) Wait(5) end end
local function unloadAnimDict(dict) if Config.Debug then print("Debug: Removing Anim Dictionary: '"..dict.."'") end RemoveAnimDict(dict) end

CreateThread(function()
	--Dumpster Third Eye
	exports['qb-target']:AddTargetModel(scrap, { options = { { event = "jim-recycle:Scrap:Search", icon = "fas fa-dumpster", label = Loc[Config.Lan].target["search"], }, }, distance = 1.5 })
end)

--Search animations
local function startSearching(coords)
    canSearch = false
    --Calculate if you're facing the trash--
    if #(coords - GetEntityCoords(PlayerPedId())) > 1.5 then TaskGoStraightToCoord(PlayerPedId(), coords, 0.4, 200, 0.0, 0) Wait(300) end
    lookEnt(coords)
    local dict = 'amb@prop_human_bum_bin@base'
    local anim = 'base'
    loadAnimDict(dict)
    --Play Serach animation
    TaskPlayAnim(PlayerPedId(), dict, anim, 2.0, 2.0, searchTime, 1, 1, 0, 0, 0)
    FreezeEntityPosition(PlayerPedId(), true)
    Wait(searchTime)
    --Stop Animation
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
    --Allow a new search
    canSearch = true
    unloadAnimDict(dict)
    --Give rewards
    TriggerServerEvent("jim-recycle:Scrap:Reward")
end

RegisterNetEvent('jim-recycle:Scrap:Search', function()
    if canSearch then
        local scrapFound = false
        for i = 1, #scrap do
            local scrapped = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 2.0, scrap[i], false, false, false)
            if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(scrapped)) < 2.0 then
                if Config.Debug then print("^5Debug^7: ^2Starting Search of entity^7: '^6"..scrapped.."^7'") end
                for i = 1, #searched do
                    if searched[i] == scrapped then scrapFound = true end -- Theres a dumpster nearby
                    if i == #searched and scrapFound then TriggerEvent("QBCore:Notify", Loc[Config.Lan].error["searched"], "error") return -- Let player know already searched
                    elseif i == #searched and not scrapFound then -- If hasn't been searched yet
                        local dict = "anim@amb@machinery@speed_drill@"
                        local anim = "look_around_left_02_amy_skater_01"
                        loadAnimDict(dict)
                        TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, 1.0, 3500, 1.5, 5, 0, 0, 0)
                        if Config.useQBLock then
                            local success = exports['qb-lock']:StartLockPickCircle(math.random(2,4), math.random(10,15), success)
                            if success then
                                TriggerEvent("QBCore:Notify", Loc[Config.Lan].success["get_scrap"], "success")
                                startSearching(GetEntityCoords(scrapped))
                                searched[i+1] = scrapped
                            else
                                TriggerEvent("QBCore:Notify", Loc[Config.Lan].error["nothing"], "error")
                                searched[i+1] = scrapped
                                ClearPedTasks(PlayerPedId())
                            end
                        else
                            local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
                            Skillbar.Start({
                                duration = math.random(2500,5000),
                                pos = math.random(10, 30),
                                width = math.random(10, 20),
                            }, function()
                                TriggerEvent("QBCore:Notify", Loc[Config.Lan].success["get_scrap"], "success")
                                startSearching(GetEntityCoords(scrapped))
                                searched[i+1] = scrapped
                                Citizen.Wait(1000)
                            end, function()
                                TriggerEvent("QBCore:Notify", Loc[Config.Lan].error["nothing"], "error")
                                searched[i+1] = scrapped
                                ClearPedTasks(PlayerPedId())
                                Citizen.Wait(1000)
                            end)
                        end
                        break
                    end
                end
            end
        end
    end
end)