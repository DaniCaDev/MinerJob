-- ESX = nil

-- CreateThread(function()
--     while ESX == nil do
--         TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
--         Wait(0)
--     end
-- end)

local isMining = false
local isBusy   = false

-----------------------------------
--          MINING               --
-----------------------------------
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        for _, zone in pairs(Config.MiningZones) do
            local dist = #(coords - zone.coords)
            if dist < zone.radius then
                -- Show help notification
                ESX.ShowHelpNotification(Config.Locale.mining_help)
                if IsControlJustReleased(0, 38) then -- E key
                    StartMining(zone)
                end
            end
        end
    end
end)

function StartMining(zone)
    if isMining then return end
    isMining = true

    if Config.RequirePickaxe then
        ESX.TriggerServerCallback('miner:checkPickaxe', function(hasPickaxe)
            if hasPickaxe then
                DoMiningAnimation()
            else
                ESX.ShowNotification(Config.Locale.no_pickaxe)
                isMining = false
            end
        end)
    else
        DoMiningAnimation()
    end
end

function DoMiningAnimation()
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
    ESX.ShowNotification(Config.Locale.wait_message)

    Wait(Config.MineTime * 1000)  -- Mining animation time
    ClearPedTasks(playerPed)

    -- Request the server to give us the raw ore
    TriggerServerEvent("miner:giveMinedItem")
    isMining = false
end

-----------------------------------
--          PROCESSING           --
-----------------------------------
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local dist = #(coords - Config.ProcessingZone.coords)

        if dist < Config.ProcessingZone.radius then
            ESX.ShowHelpNotification(Config.Locale.processing_help)
            if IsControlJustReleased(0, 38) then
                StartProcessing()
            end
        end
    end
end)

function StartProcessing()
    if isBusy then return end
    isBusy = true

    ESX.TriggerServerCallback('miner:processOre', function(success, processedAmount)
        if success then
            ESX.ShowNotification(string.format(Config.Locale.processed_message, processedAmount))
        else
            ESX.ShowNotification(Config.Locale.no_mineral)
        end
        isBusy = false
    end)
end

-----------------------------------
--             SELLING           --
-----------------------------------
CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local dist = #(coords - Config.SellingZone.coords)

        if dist < Config.SellingZone.radius then
            ESX.ShowHelpNotification(Config.Locale.selling_help)
            if IsControlJustReleased(0, 38) then
                StartSelling()
            end
        end
    end
end)

function StartSelling()
    if isBusy then return end
    isBusy = true

    ESX.TriggerServerCallback('miner:sellOre', function(success, soldAmount, totalEarnings)
        if success then
            ESX.ShowNotification(string.format(Config.Locale.sold_message, soldAmount, totalEarnings))
        else
            ESX.ShowNotification(Config.Locale.no_mineral)
        end
        isBusy = false
    end)
end
