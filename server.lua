-- ESX = nil
-- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------------------
--       CHECK FOR PICKAXE       --
-----------------------------------
ESX.RegisterServerCallback('miner:checkPickaxe', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        cb(false)
        return
    end

    local pickaxeItem = xPlayer.getInventoryItem(Config.PickaxeItem)
    if pickaxeItem and pickaxeItem.count > 0 then
        cb(true)
    else
        cb(false)
    end
end)

-----------------------------------
--     GIVE RAW ORE WHEN MINED   --
-----------------------------------
RegisterNetEvent("miner:giveMinedItem")
AddEventHandler("miner:giveMinedItem", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    -- Random quantity between Config.MinedItemQuantity.min and max
    local quantity = math.random(Config.MinedItemQuantity.min, Config.MinedItemQuantity.max)

    local itemInfo = xPlayer.getInventoryItem(Config.MinedItem)
    if itemInfo.limit == -1 or (itemInfo.count + quantity) <= itemInfo.limit then
        xPlayer.addInventoryItem(Config.MinedItem, quantity)
        TriggerClientEvent('esx:showNotification', src, string.format(Config.Locale.mined_message, quantity))
    else
        TriggerClientEvent('esx:showNotification', src, Config.Locale.not_enough_space)
    end
end)

-----------------------------------
--     PROCESS RAW ORE -> REFINED --
-----------------------------------
ESX.RegisterServerCallback('miner:processOre', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        cb(false, 0)
        return 
    end

    local rawItem = xPlayer.getInventoryItem(Config.MinedItem)
    if rawItem.count < 1 then
        cb(false, 0)
        return
    end

    local amountToProcess = rawItem.count
    -- Simulate processing time per ore (server-side wait)
    Wait(Config.ProcessTime * 1000 * amountToProcess)

    -- Remove raw ore
    xPlayer.removeInventoryItem(Config.MinedItem, amountToProcess)

    -- Give refined ore
    local refinedItem = xPlayer.getInventoryItem(Config.ProcessedItem)
    if refinedItem.limit == -1 or (refinedItem.count + amountToProcess) <= refinedItem.limit then
        xPlayer.addInventoryItem(Config.ProcessedItem, amountToProcess)
        cb(true, amountToProcess)
    else
        -- If not enough space, you could partially process or handle it differently
        cb(true, 0)
    end
end)

-----------------------------------
--   SELL REFINED ORE FOR MONEY  --
-----------------------------------
ESX.RegisterServerCallback('miner:sellOre', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        cb(false, 0, 0)
        return
    end

    local refinedItem = xPlayer.getInventoryItem(Config.ProcessedItem)
    if refinedItem.count < 1 then
        cb(false, 0, 0)
        return
    end

    local amount = refinedItem.count
    local totalPay = amount * Config.SellPrice

    xPlayer.removeInventoryItem(Config.ProcessedItem, amount)
    xPlayer.addMoney(totalPay)

    cb(true, amount, totalPay)
end)
