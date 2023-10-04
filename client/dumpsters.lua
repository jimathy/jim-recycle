local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)

local dumpsters = { -- The mighty list of dumpters/trash cans
    `prop_dumpster_01a`, `prop_dumpster_02a`, `prop_dumpster_02b`, `prop_dumpster_3a`, `prop_dumpster_4a`, `prop_dumpster_4b`,
    `prop_bin_05a`, `prop_bin_06a`, `prop_bin_07a`, `prop_bin_07b`, `prop_bin_07c`, `prop_bin_07d`, `prop_bin_08a`, `prop_bin_08open`,
    `prop_bin_09a`, `prop_bin_10a`, `prop_bin_10b`, `prop_bin_11a`, `prop_bin_12a`, `prop_bin_13a`, `prop_bin_14a`, `prop_bin_14b`,
    `prop_bin_beach_01d`, `prop_bin_delpiero`, `prop_bin_delpiero_b`, `prop_recyclebin_01a`, `prop_recyclebin_02_c`, `prop_recyclebin_02_d`,
    `prop_recyclebin_02a`, `prop_recyclebin_02b`, `prop_recyclebin_03_a`, `prop_recyclebin_04_a`, `prop_recyclebin_04_b`, `prop_recyclebin_05_a`,
    `zprop_bin_01a_old`, `hei_heist_kit_bin_01`, `ch_prop_casino_bin_01a`, `vw_prop_vw_casino_bin_01a`, `mp_b_kit_bin_01`, `prop_bin_01a`,
}

if Config.DumpsterDiving.Enable then if Config.Debug then print("^5Debug^7: ^2Loading^7: '^6Dumpster Diving^7'") end
    local Searching = false -- No touch
    --Dumpster Third Eye
    function getCoord(numA, numB) local base = 10^(numB or 0) return math.floor(numA * base + 0.5) / base end
    CreateThread(function()
	--Dumpster Third Eye
	if Config.DumpsterStash then
		exports['qb-target']:AddTargetModel(dumpsters, { options = { { event = "jim-recycle:Dumpsters:Search", icon = "fas fa-dumpster", label = Loc[Config.Lan].target["search_trash"], }, 
			{   icon = 'fas fa-dumpster', label = Loc[Config.Lan].target["dump_stash"], action = function(entity)
				local DumpsterCoords = GetEntityCoords(entity)
				if DumpsterCoords.x < 0 then DumpsterX = -DumpsterCoords.x else DumpsterX = DumpsterCoords.x end
				if DumpsterCoords.y < 0 then DumpsterY = -DumpsterCoords.y else DumpsterY = DumpsterCoords.y end
				DumpsterX = getCoord(DumpsterX, 1)
				DumpsterY = getCoord(DumpsterY, 1)
				TriggerEvent("inventory:client:SetCurrentStash", "Dumpster | "..DumpsterX.." | "..DumpsterY)
				TriggerServerEvent("inventory:server:OpenInventory", "stash", "Dumpster | "..DumpsterX.." | "..DumpsterY, {
				    maxweight = 100000,
				    slots = 10,
				})
			    end
			}
		}, distance = 1.5 })
	else
		exports['qb-target']:AddTargetModel(Config.DumpsterDiving.models,
        { options = {
            { event = "jim-recycle:Dumpsters:Search",
            icon = "fas fa-dumpster",
            label = Loc[Config.Lan].target["search_trash"],
        }, }, distance = 1.5 })
	end
end)
    --Search animations
    local function startSearching(coords) local Ped = PlayerPedId()
        --Calculate if you're facing the trash--
        if #(coords - GetEntityCoords(Ped)) > 1.5 then TaskGoStraightToCoord(Ped, coords, 0.4, 200, 0.0, 0) Wait(300) end
        lookEnt(coords)
        loadAnimDict('amb@prop_human_bum_bin@base')
        --Play Search animation
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
        for i = 1, math.random(1, 2) do toggleItem(true, Config.DumpItems[math.random(1, #Config.DumpItems)], math.random(1, 3)) Wait(100) end
        --If two random numbers match, give bonus
        if math.random(1, 3) == math.random(1, 3) then toggleItem(true, "rubber", math.random(1, 4)) Wait(100) end
        lockInv(false)
    end

    RegisterNetEvent('jim-recycle:Dumpsters:Search', function(data) local Ped = PlayerPedId()
        local searchSuccess = nil
        if not Searching then Searching = true else return end
        lockInv(true)
        local searched = false
        if Config.Debug then print("^5Debug^7: ^2Starting Search of entity^7: '^6"..data.entity.."^7'") end
        for i = 1, #Config.DumpsterDiving.searched do
            if Config.DumpsterDiving.searched[i] == data.entity then
                triggerNotify(nil, Loc[Config.Lan].error["searched"], "error")
                searched = true
                Searching = false
                lockInv(false)
                return
            end
        end
        if not searched then -- If hasn't been searched yet
            loadAnimDict("anim@amb@machinery@speed_drill@")
            TaskPlayAnim(Ped, "anim@amb@machinery@speed_drill@", "look_around_left_02_amy_skater_01", 1.0, 1.0, 3500, 1.5, 5, 0, 0, 0)
            if Config.DumpsterDiving.skillcheck == "qb-lock" then
                local Skillbar = exports['qb-lock']:StartLockPickCircle(math.random(2,4), math.random(7,10), success)
                if Skillbar then searchSuccess = true else searchSuccess = false end
            elseif Config.DumpsterDiving.skillcheck == "ps-ui" then
                exports['ps-ui']:Circle(function(Skillbar)
                    if Skillbar then searchSuccess = true else searchSuccess = false end
                end, 2, 20)
            elseif Config.DumpsterDiving.skillcheck == "qb-skillbar" then
                local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
                Skillbar.Start({ duration = math.random(2500,5000), pos = math.random(10, 30), width = math.random(10, 20),	},
                function() searchSuccess = true end, function() searchSuccess = false end)
            elseif Config.DumpsterDiving.skillcheck == "ox_lib" then
                local Skillbar = exports.ox_lib:skillCheck({'easy', 'easy', 'easy' }, {'1', '2', '3', '4'})
                if Skillbar then searchSuccess = true else searchSuccess = false end
            else
                searchSuccess = true
            end
            while searchSuccess == nil do Wait(1) end
            if searchSuccess then
                triggerNotify(nil, Loc[Config.Lan].success["get_trash"], "success")
                startSearching(GetEntityCoords(data.entity))
                Searching = false
            else
                lockInv(false)
                Searching = false
                triggerNotify(nil, Loc[Config.Lan].error["nothing"], "error")
            end
            Config.DumpsterDiving.searched[#Config.DumpsterDiving.searched+1] = data.entity
            Wait(1000)
            ClearPedTasks(Ped)
        end
    end)
end
