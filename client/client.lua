onDuty, Peds, Targets, searchProps, Props, randPackage = false, {}, {}, {}, {}, nil
local TrollyProp = nil

Recycling = {
    Functions = {},
    Trade = {},
    PickUpPackage = {},
    Sell = {},
}

--- Blips + Peds
onPlayerLoaded(function()
    for location in pairs(Config.Locations["Centres"]) do
        local loc = Config.Locations["Centres"][location]
        if loc.Enable then
            createPoly({
                name = "Recycling:"..location,
                debug = debugMode,
                points = loc.Zone,
                onEnter = function()
                    Recycling.Functions.createProps(location)
                end,
                onExit = function()
                    Recycling.Functions.EndJob()
                    Recycling.Functions.CleanUpProps()
                    debugPrint("^5Debug^7: ^3PolyZone^7: ^2Leaving Area^7. ^2Clocking out and cleaning up^7")
                    if loc.Job then
                        if onDuty then TriggerServerEvent("QBCore:ToggleDuty") end
                    elseif onDuty == true then
                        onDuty = false
                    end
                end,
            })
            if loc.Blip.blipEnable then
                makeBlip(loc.Blip)
            end

            local jobLoc = loc.JobLocations
            local nameEnter = "RecycleEnter_"..location
            Targets[nameEnter] =
                createBoxTarget( { nameEnter, jobLoc.Enter.coords.xyz, jobLoc.Enter.w, jobLoc.Enter.d,
                    { 	name = nameEnter,
                        heading = jobLoc.Enter.coords.w,
                        debugPoly = debugMode,
                        minZ = jobLoc.Enter.coords.z-1,
                        maxZ = jobLoc.Enter.coords.z+2,
                    }, }, {
                    {
                        action = function()
                            Recycling.Functions.TeleLocation({ tele = jobLoc.Enter.tele, job = loc.Job, enter = true })
                        end,
                        icon = "fas fa-recycle",
                        job = loc.Job,
                        label = locale("target", "enter")..(Config.PayAtDoor and " ($"..Config.PayAtDoor..")" or ""),
                    },
                }, 1.5)

            local nameExit = "RecycleExit_"..location
            Targets[nameExit] =
                createBoxTarget( { nameExit, jobLoc.Exit.coords.xyz, jobLoc.Exit.w, jobLoc.Exit.d,
                    { 	name = nameExit,
                        heading = jobLoc.Exit.coords.w,
                        debugPoly = debugMode,
                        minZ = jobLoc.Exit.coords.z-1,
                        maxZ = jobLoc.Exit.coords.z+2,
                    }, }, {
                    {
                        action = function()
                            Recycling.Functions.TeleLocation({ tele = jobLoc.Exit.tele, })
                        end,
                        icon = "fas fa-recycle",
                        label = locale("target", "exit"),
                    },
                }, 1.5)

            local nameDuty = "RecycleDuty:"..location
            Targets[nameDuty] =
                createBoxTarget( { nameDuty, jobLoc.Duty.coords.xyz, jobLoc.Duty.w, jobLoc.Duty.d,
                    { 	name = nameDuty,
                        heading = jobLoc.Duty.coords.w,
                        debugPoly = debugMode,
                        minZ = jobLoc.Duty.coords.z-1,
                        maxZ = jobLoc.Duty.coords.z+1,
                    }, }, {
                    {
                        action = function()
                            Recycling.Functions.dutyToggle({ job = loc.Job, Trolly = jobLoc.Trolly })
                        end,
                        icon = "fas fa-recycle",
                        job = loc.Job,
                        label = locale("target", "duty"),
                    },
                }, 1.5)

            if jobLoc.Trade then
                for i = 1, #jobLoc.Trade do
                    local nameTrade = "RecycleTrade:"..location..i
                    makeDistPed(jobLoc.Trade[i].model, jobLoc.Trade[i].coords, true, false, jobLoc.Trade[i].scenario, false, false)

                    Targets[nameDuty] =
                        createBoxTarget( { nameTrade, vec3(jobLoc.Trade[i].coords.x, jobLoc.Trade[i].coords.y, jobLoc.Trade[i].coords.z-1), jobLoc.Trade[i].w, jobLoc.Trade[i].d,
                            { 	name = nameTrade,
                                heading = jobLoc.Trade[i].coords.w,
                                debugPoly = debugMode,
                                minZ = jobLoc.Trade[i].coords.z-0.5,
                                maxZ = jobLoc.Trade[i].coords.z+1,
                            }, }, {
                            {
                                action = function(data)
                                    Recycling.Trade.Menu({ Ped = type(data) == "table" and data.entity or data })
                                end,
                                icon = "fas fa-box",
                                job = loc.Job,
                                label = locale("target", "trade"),
                            },
                        }, 1.5)
                end
            end
        end
    end

    --Sell Materials
    for i = 1, #Config.Locations["Recycle"] do
        local loc = Config.Locations["Recycle"][i]
        local nameSell = "Recycle:"..i

        makePed(loc.Ped.model, loc.coords, true, false, loc.Ped.scenario, nil, nil)

        if loc.Blip.blipEnable then
            makeBlip({ coords = loc.coords, sprite = loc.Blip.sprite, col = loc.Blip.col, name = loc.Blip.name } )
        end
        Targets[nameSell] =
            createBoxTarget(
                { nameSell, vec3(loc.coords.x, loc.coords.y, loc.coords.z-1), 1.0, 1.0,
                    {
                        name = nameSell,
                        heading = loc.coords.w,
                        debugPoly = debugMode,
                        minZ = loc.coords.z-1,
                        maxZ=loc.coords.z+1
                    },
                }, {
                {
                    action = function(data)
                        sellMenu({ sellTable = Config.Other.Prices, ped = type(data) == "table" and data.entity or data })
                        lookEnt(loc.coords)
                    end,
                    icon = "fas fa-certificate",
                    label = locale("menu", "sell_mats"),
                },
            }, 1.5)
    end
    --Bottle Selling Third Eyes
    for i = 1, #Config.Locations["BottleBanks"] do
        local loc = Config.Locations["BottleBanks"][i]
        local nameBank = "BottleBank:"..i

        makeDistProp({ prop = "prop_recyclebin_04_b", coords = loc.coords }, true, false)

        if loc.Blip.blipEnable then
            makeBlip({ coords = loc.coords, sprite = loc.Blip.sprite, col = loc.Blip.col, name = loc.Blip.name } )
        end

        Targets[nameBank] =
            createBoxTarget(
                { nameBank, vec3(loc.coords.x, loc.coords.y, loc.coords.z-1), 1.3, 1.3,
                    {
                        name = nameBank,
                        heading = loc.coords.w,
                        debugPoly = debugMode,
                        minZ = loc.coords.z-1,
                        maxZ=loc.coords.z+1
                    },
                }, {
                {
                    action = function(data)
                        sellMenu({
                            sellTable = Config.Other.BottleBankTable,
                            ped = type(data) == "table" and data.entity or data
                        })
                        lookEnt(loc.coords)
                    end,
                    icon = "fas fa-certificate",
                    label = locale("target", "sell_bottles"),
                },
            }, 1.5)
    end
end, true)

---- Render Location Props -------
Recycling.Functions.createProps = function(location)
    local loc = Config.Locations["Centres"][location]
    debugPrint("^5Debug^7: ^3createProps^7() ^2Spawning props for '"..location.."'")
    for i = 1, #loc.SearchLocations do
        searchProps[#searchProps+1] = makeProp({
            prop = Config.RecyclingCenter.propTable[math.random(1, #Config.RecyclingCenter.propTable)],
            coords = loc.SearchLocations[i] - vec4(0, 0, 1.03, 0)
        }, 1, 0)
    end
    for i = 1, #loc.ExtraPropLocations do
        Props[#Props+1] = makeProp({
            prop = Config.RecyclingCenter.propTable[math.random(1, #Config.RecyclingCenter.propTable)],
            coords = loc.ExtraPropLocations[i] - vec4(0, 0, 1.03, 0)
        }, 1, 0)
    end
    for k in pairs(Config.RecyclingCenter.scrapPool) do
        loadModel(Config.RecyclingCenter.scrapPool[k].model)
    end
    if not TrollyProp then
        TrollyProp = makeProp(loc.JobLocations.Trolly, 1, 0)
    end
end

Recycling.Functions.EndJob = function()
    if Targets["Package"] then
        removeEntityTarget(randPackage)
    end
    if TrollyProp then
        destroyProp(TrollyProp)
        TrollyProp = nil
    end
    for i = 1, #searchProps do
        SetEntityDrawOutline(searchProps[i], false)
    end
    randPackage = nil
    if scrapProp then
        destroyProp(scrapProp)
        scrapProp = nil
    end
end

Recycling.Functions.CleanUpProps = function()
    debugPrint("^5Debug^7: ^3CleanUpProps^7() ^2Exiting building^7, ^2clearing previous props ^7(^2if any^7)")
    for _, v in pairs(searchProps) do
        unloadModel(GetEntityModel(v))
        DeleteObject(v)
    end
    searchProps = {}
    for _, v in pairs(Props) do
        unloadModel(GetEntityModel(v))
        DeleteObject(v)
    end
    Props = {}
    for k in pairs(Config.RecyclingCenter.scrapPool) do
        unloadModel(Config.RecyclingCenter.scrapPool[k].model)
    end
    if Targets["DropOff"] then
        removeEntityTarget(TrollyProp)
    end
    unloadModel(GetEntityModel(TrollyProp))
    DeleteObject(TrollyProp)
end


--Event to enter and exit warehouse
Recycling.Functions.TeleLocation = function(data)
    local Ped = PlayerPedId()
    if data.enter then
        if Config.RecyclingCenter.EnableOpeningHours then
            local ClockTime = GetClockHours()
            if (ClockTime >= Config.RecyclingCenter.OpenHour and ClockTime < 24) or (ClockTime <= Config.RecyclingCenter.CloseHour -1 and ClockTime > 0) then

            else
                triggerNotify(nil, locale("error", "wrong_time")..Config.RecyclingCenter.OpenHour..":00am"..locale("error", "till")..Config.RecyclingCenter.CloseHour..":00pm", "error")
                return
            end
        end
        if Config.RecyclingCenter.PayAtDoor then
            if getPlayer().cash >= Config.RecyclingCenter.PayAtDoor then
                TriggerServerEvent("jim-recycle:Server:DoorCharge")
            else
                triggerNotify(nil, locale("error", "no_money"), "error")
                return
            end
        end
        useDoor({ telecoords = data.tele })
    else
        Recycling.Functions.EndJob() -- Resets outlines + targets if needed
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do Wait(10) end
        if onDuty then
            Recycling.Functions.dutyToggle()
        end
        SetEntityCoords(Ped, data.tele.xyz)
        DoScreenFadeIn(500)
    end
end

--Pick one of the crates for the player to choose, generate outline + target
Recycling.PickUpPackage.PickRandomEntity = function(Trolly)
    if not TrollyProp then
        TrollyProp = makeProp(Trolly, 1, 0)
    end
    --If somehow already exists, remove target
    if Targets["Package"] then
        removeEntityTarget(randPackage)
    end
    --Pick random prop to use
    randPackage = searchProps[math.random(1, #searchProps)]
    SetEntityDrawOutline(randPackage, true)
    SetEntityDrawOutlineColor(0, 255, 0, 1.0)
    SetEntityDrawOutlineShader(1)
    --Generate Target Location on the selected package
    Targets["Package"] =
        createEntityTarget(randPackage, { {
            action = function()
                Recycling.PickUpPackage.startPickup({ Trolly = Trolly })
            end,
            icon = 'fas fa-magnifying-glass',
            label = locale("target", "search"),
        } }, 2.5 )
end

Recycling.PickUpPackage.startPickup = function(data)
    local Ped = PlayerPedId()
    TaskStartScenarioInPlace(Ped, "CODE_HUMAN_MEDIC_KNEEL", 0, true)
    if progressBar({
        label = locale("progressbar", "search"),
        time = 5000,
        cancel = true,
        icon = "fas fa-magnifying-glass"
    }) then
        ClearPedTasksImmediately(Ped)
        Recycling.PickUpPackage.holdItem(data)
    end
end

-- Pick up prop and remove target from current location
Recycling.PickUpPackage.holdItem = function(data)
    local Ped = PlayerPedId()
    --Clear current target info
    debugPrint("^5Debug^7: ^2Removing target and outline from randPackage^7: ", randPackage)
    removeEntityTarget(randPackage)
    SetEntityDrawOutline(randPackage, false)
    randPackage = nil

    --Make prop to put in hands
    playAnim("anim@heists@box_carry@", "idle", -1, 50, Ped)

    local v = Config.RecyclingCenter.scrapPool[math.random(1, #Config.RecyclingCenter.scrapPool)]
    local PedCoords = GetEntityCoords(Ped, true)

    scrapProp = makeProp({
        prop = v.model,
        coords = vec4(PedCoords.x, PedCoords.y, PedCoords.z, 0.0)
    }, 1, 1)
    AttachEntityToEntity(scrapProp, Ped, GetPedBoneIndex(Ped, 18905), v.xPos, v.yPos, v.zPos, v.xRot, v.yRot, v.zRot, 20.0, true, true, false, true, 1, true)

    debugPrint("^5Debug^7: ^2Adding target and outline to ^3TrollyProp^7: ", TrollyProp)
    --Create target for drop off location
    SetEntityDrawOutline(TrollyProp, true)
    SetEntityDrawOutlineColor(150, 1, 1, 1.0)
    SetEntityDrawOutlineShader(1)

    createEntityTarget(TrollyProp, { {
        action = function()
            Recycling.PickUpPackage.collectReward({ Trolly = data.Trolly })
        end,
        icon = 'fas fa-recycle',
        label = locale("target", "drop_off"),
    } }, 2.5)
end

Recycling.PickUpPackage.collectReward = function(data)
    local Ped = PlayerPedId()
    lookEnt(TrollyProp)
    playAnim("mp_car_bomb", "car_bomb_mechanic", -1, 1, Ped)

    if progressBar({
        label = locale("progressbar", "search"),
        time = 3000,
        cancel = true,
    }) then
        --Once this is triggered it can't be stopped, so remove the target and prop
        debugPrint("^5Debug^7: ^2Clearing target and outline from ^3TrollyProp^7, ", TrollyProp)
        removeEntityTarget(TrollyProp)
        destroyProp(TrollyProp)
        SetEntityDrawOutline(TrollyProp, false)
        TrollyProp = nil
        TrollyProp = makeProp(data.Trolly, 1, 0)

        --Empty hands
        destroyProp(scrapProp)
        scrapProp = nil

        stopAnim("mp_car_bomb", "car_bomb_mechanic", Ped)
        currentToken = triggerCallback(AuthEvent)
        addItem("recyclablematerial", math.random(Config.Other.RecycleAmounts["Recycle"].Min, Config.Other.RecycleAmounts["Recycle"].Max))
        Recycling.PickUpPackage.PickRandomEntity(data.Trolly)
    end
end

Recycling.Functions.dutyToggle = function(data)
    if Config.JobRole then
        if onDuty then
            Recycling.Functions.EndJob()
        else
            Recycling.PickUpPackage.PickRandomEntity(data.Trolly)
        end
        TriggerServerEvent("QBCore:ToggleDuty")
    else
        onDuty = not onDuty
        if onDuty then
            triggerNotify(nil, locale("success", "on_duty"), 'success')
            Recycling.PickUpPackage.PickRandomEntity(data.Trolly)
        else
            triggerNotify(nil, locale("error", "off_duty"), 'error')
            Recycling.Functions.EndJob()
        end
    end
end

local Selling = false
--Recyclable Trader
Recycling.Trade.Menu = function(data)
    if not hasItem("recyclablematerial", 1) then
        triggerNotify(nil, locale("error", "no_mats"), "error")
        return
    end
    if Selling then return end
    local tradeMenu = {}
    for _, v in pairs(Config.Other.TradeTable) do
        tradeMenu[#tradeMenu+1] = {
            icon = invImg(v),
            header = Items[v] and Items[v].label or v .. "❌",
            onSelect = function()
                Recycling.Trade.selectMenu({ item = v, Ped = data.Ped })
            end,
        }
    end
    openMenu(tradeMenu,{ header = locale("menu", "mats_trade"), canClose = true, })
end

Recycling.Trade.selectMenu = function(data)
    if Selling then return end
    local hasAll, details = hasItem("recyclablematerial", 1)
    local count = details["recyclablematerial"].count or 0
    local tradeMenu = {}

    if count < 1 then
        triggerNotify(nil, locale("error", "no_mats"), "error")
        return
    end

    for _, v in pairs(Config.Other.RecycleAmounts["Trade"]) do
        if count >= v.amount then
            tradeMenu[#tradeMenu+1] = {
                icon = invImg("recyclablematerial"),
                header = v.amount.." "..locale("menu", "trade"),
                onSelect = function()
                    Recycling.Functions.sellAnim({
                        item = data.item,
                        amount = v.amount,
                        Ped = data.Ped
                    })
                end
            }
        else
            tradeMenu[#tradeMenu+1] = {
                isMenuHeader = true,
                icon = icon,
                header = v.amount.." "..locale("menu", "trade").." ❌"
            }
        end
        Wait(0)
    end

    openMenu(tradeMenu, {
        header = locale("menu", "mats_trade"),
        onBack = function()
            Recycling.Trade.Menu(data)
        end,
    })
    lookEnt(data.Ped)
end

Recycling.Functions.sellAnim = function(data)
    local Ped = PlayerPedId()
    if Selling then return else Selling = true end
    lockInv(true)
    for _, obj in pairs(GetGamePool('CObject')) do
        for _, model in pairs({ `p_cs_clipboard` }) do
            if GetEntityModel(obj) == model and IsEntityAttachedToEntity(data.Ped, obj) then
                DeleteObject(obj)
                DetachEntity(obj, 0, 0)
                SetEntityAsMissionEntity(obj, true, true)
                Wait(100)
                DeleteEntity(obj)
            end
        end
    end

    if bag == nil then
        bag = makeProp({prop = "prop_paper_bag_small", coords = vec4(0,0,0,0)}, 0, 1)
    end
    AttachEntityToEntity(bag, data.Ped, GetPedBoneIndex(data.Ped, 57005), 0.1, -0.0, 0.0, -90.0, 0.0, 0.0, true, true, false, true, 1, true)
    --Calculate if you're facing the ped--
    ClearPedTasksImmediately(data.Ped)
    lookEnt(data.Ped)

    playAnim("mp_common", "givetake2_a", 0.3, 16)
    playAnim("mp_common", "givetake2_b", 0.3, 16, data.Ped)

    Wait(1000)
    AttachEntityToEntity(bag, Ped, GetPedBoneIndex(Ped, 57005), 0.1, -0.0, 0.0, -90.0, 0.0, 0.0, true, true, false, true, 1, true)
    TriggerServerEvent("jim-recycle:Server:TradeItems", { item = data.item, amount = data.amount })
    Wait(1000)
    stopAnim("mp_common", "givetake2_a")
    stopAnim("mp_common", "givetake2_b", data.Ped)

    TaskStartScenarioInPlace(data.Ped, "WORLD_HUMAN_CLIPBOARD", -1, true)

    destroyProp(bag)
    unloadModel(`prop_paper_bag_small`)
    bag = nil

    Selling = false
    lockInv(false)
end

onResourceStop(function()
    for _, v in pairs(Peds) do unloadModel(GetEntityModel(v)) DeletePed(v) end
    for _, v in pairs(Props) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
    for _, v in pairs(searchProps) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
    unloadModel(GetEntityModel(TrollyProp)) DeleteObject(TrollyProp)
    unloadModel(GetEntityModel(scrapProp)) DeleteObject(scrapProp)
end, true)