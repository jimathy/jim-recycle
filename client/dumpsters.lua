local QBCore = exports['qb-core']:GetCoreObject()

local searched = {34343435323} -- No Touch.
local canSearch = true -- No touch.
local searchTime = 3000 -- How long after successful skill check the serach takes
local dumpsters = { -- The mighty list of dumpters/trash cans
    `prop_dumpster_01a`, `prop_dumpster_02a`, `prop_dumpster_02b`, `prop_dumpster_3a`, `prop_dumpster_4a`, `prop_dumpster_4b`,
    `prop_bin_05a`, `prop_bin_06a`, `prop_bin_07a`, `prop_bin_07b`, `prop_bin_07c`, `prop_bin_07d`, `prop_bin_08a`, `prop_bin_08open`,
    `prop_bin_09a`, `prop_bin_10a`, `prop_bin_10b`, `prop_bin_11a`, `prop_bin_12a`, `prop_bin_13a`, `prop_bin_14a`, `prop_bin_14b`,
    `prop_bin_beach_01d`, `prop_bin_delpiero`, `prop_bin_delpiero_b`, `prop_recyclebin_01a`, `prop_recyclebin_02_c`, `prop_recyclebin_02_d`,
    `prop_recyclebin_02a`, `prop_recyclebin_02b`, `prop_recyclebin_03_a`, `prop_recyclebin_04_a`, `prop_recyclebin_04_b`, `prop_recyclebin_05_a`,
    `zprop_bin_01a_old`, `hei_heist_kit_bin_01`, `ch_prop_casino_bin_01a`, `vw_prop_vw_casino_bin_01a`, `mp_b_kit_bin_01`,
}

--Loading/Unloading Asset Functions
local function loadAnimDict(dict) if Config.Debug then print("Debug: Loading Anim Dictionary: '"..dict.."'") end while not HasAnimDictLoaded(dict) do RequestAnimDict(dict) Wait(5) end end
local function unloadAnimDict(dict) if Config.Debug then print("Debug: Removing Anim Dictionary: '"..dict.."'") end RemoveAnimDict(dict) end

CreateThread(function()
	--Dumpster Third Eye
	exports['qb-target']:AddTargetModel(dumpsters, { options = { { event = "jim-recycle:Dumpsters:Search", icon = "fas fa-dumpster", label = "Search Trash", }, }, distance = 1.5 })
end)

--Search animations
local function startSearching(coords)
    canSearch = false
    --Calculate if you're facing the trash--
    if #(coords - GetEntityCoords(PlayerPedId())) > 1.5 then TaskGoStraightToCoord(PlayerPedId(), coords, 0.4, 200, 0.0, 0) Wait(300) end
    if not IsPedHeadingTowardsPosition(PlayerPedId(), coords, 20.0) then TaskTurnPedToFaceCoord(PlayerPedId(), coords, 1500) Wait(1500) end
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
    TriggerServerEvent("jim-recycle:Dumpsters:Reward")
end

RegisterNetEvent('jim-recycle:Dumpsters:Search', function()
    if canSearch then
        local dumpsterFound = false
        for i = 1, #dumpsters do
            local dumpster = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.0, dumpsters[i], false, false, false)
            if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(dumpster)) < 1.8 then
                if Config.Debug then print("Debug: Starting Search of entity: '"..dumpster.."'") end
                for i = 1, #searched do
                    if searched[i] == dumpster then dumpsterFound = true end -- Theres a dumpster nearby
                    if i == #searched and dumpsterFound then TriggerEvent("QBCore:Notify", "Already Searched.", "error") return -- Let player know already searched
                    elseif i == #searched and not dumpsterFound then -- If hasn't been searched yet
                        local dict = "anim@amb@machinery@speed_drill@"
                        local anim = "look_around_left_02_amy_skater_01"
                        loadAnimDict(dict)
                        TaskPlayAnim(PlayerPedId(), dict, anim, 1.0, 1.0, 3500, 1.5, 5, 0, 0, 0)
                        if useQBLock then
                            local success = exports['qb-lock']:StartLockPickCircle(math.random(2,4), math.random(10,15), success)
                            if success then
                                TriggerEvent("QBCore:Notify", "You search the Trash!", "success")
                                startSearching(GetEntityCoords(dumpster))
                                searched[i+1] = dumpster
                            else
                                TriggerEvent("QBCore:Notify", "You couldn't find anything.", "error")
                                searched[i+1] = dumpster
                                ClearPedTasks(PlayerPedId())
                            end
                        else
                            local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
                            Skillbar.Start({
                                duration = math.random(2500,5000),
                                pos = math.random(10, 30),
                                width = math.random(10, 20),
                            }, function()
                                TriggerEvent("QBCore:Notify", "You search the Trash!", "success")
                                startSearching(GetEntityCoords(dumpster))
                                searched[i+1] = dumpster
                                Citizen.Wait(1000)
                            end, function()
                                TriggerEvent("QBCore:Notify", "You couldn't find anything.", "error")
                                searched[i+1] = dumpster
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