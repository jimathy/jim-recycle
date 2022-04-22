local QBCore = exports['qb-core']:GetCoreObject()

local searched = {3423423424}
local canSearch = true
local dumpsters = { 218085040, 666561306, -58485588, -206690185, 1511880420, 682791951, 1437508529, 2051806701, -246439655, 74073934, -654874323, 651101403, 909943734, 1010534896, 1614656839, -130812911, -93819890,
                    1329570871, 1143474856, -228596739, -468629664, -1426008804, -1187286639, -1096777189, -413198204, 437765445, -1830793175, -329415894, -341442425, -2096124444, 122303831, 1748268526, 998415499,
                    -5943724, -317177646, 1380691550, -115771139, -85604259, 1233216915, 375956747, 673826957, 354692929, -14708062, 811169045, -96647174, 1919238784, 275188277, 16567861, -1224639730, -1414390795, }
local searchTime = 2000

CreateThread(function()
	--Dumpster Third Eye
	exports['qb-target']:AddTargetModel(dumpsters, { options = { { event = "jim-recycle:Dumpsters:Search", icon = "fas fa-dumpster", label = "Search Trash", }, }, distance = 1.5 })
end)

--Search animations
function startSearching(time, dict, anim, cb)
    local animDict = dict
    local animation = anim
    local ped = PlayerPedId()
    local playerPed = PlayerPedId()
    canSearch = false
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
        TaskPlayAnim(ped, animDict, animation, 8.0, 8.0, time, 1, 1, 0, 0, 0)
    FreezeEntityPosition(playerPed, true)
    local ped = PlayerPedId()
    Wait(time)
    ClearPedTasks(ped)
    FreezeEntityPosition(playerPed, false)
    canSearch = true
    TriggerServerEvent("jim-recycle:Dumpsters:Reward")
end

--Remove dumpster from table after searching
RegisterNetEvent('jim-recycle:Dumpsters:Remove', function(object)
    for i = 1, #searched do
        if searched[i] == object then
            searched[i] = nil
        end
    end
end)

RegisterNetEvent('jim-recycle:Dumpsters:Search', function()
    local ped = PlayerPedId()
    local playerPed = PlayerPedId()
    --while true do
        local wait = 1000
        if canSearch then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dumpsterFound = false
            wait = 250
            for i = 1, #dumpsters do
                local dumpster = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, dumpsters[i], false, false, false)
                local dumpPos = GetEntityCoords(dumpster)
                local dist = #(vector3(pos.x, pos.y, pos.z) - vector3(dumpPos.x, dumpPos.y, dumpPos.z))
                local playerPed = PlayerPedId()
                if dist < 1.8 then
                    wait = 4
                    for i = 1, #searched do
                        if searched[i] == dumpster then
                            dumpsterFound = true
                        end
                        if i == #searched and dumpsterFound then
							TriggerEvent("QBCore:Notify", "Already Searched.", "error")
                            
                        elseif i == #searched and not dumpsterFound then
							TaskTurnPedToFaceEntity(ped, dumpster, 1000)
							Wait(1000)
                            loadAnimDict('amb@prop_human_bum_bin@base')
                            TaskPlayAnim(ped, 'amb@prop_human_bum_bin@base', 'base', 8.0, 8.0, 16000, 1, 1, 0, 0, 0)
							local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
							Skillbar.Start({
								duration = math.random(2500,5000),
								pos = math.random(10, 30),
								width = math.random(10, 20),
							}, function()
								TriggerEvent("QBCore:Notify", "You search the Trash!", "success")
                                startSearching(searchTime, 'amb@prop_human_bum_bin@base', 'base')
                                searched[i+1] = dumpster
                                Citizen.Wait(1000)
							end, function()
								TriggerEvent("QBCore:Notify", "You couldn't find anything.", "error")
                                searched[i+1] = dumpster
                                ClearPedTasks(ped)
                                Citizen.Wait(1000)
							end)						
                        end
                    end
                end
            end
        Wait(wait)
    end
end)