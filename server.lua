local QBCore = exports['qb-core']:GetCoreObject()

--[[
    OFFMETA Gathering (server)
    Forked from qb-gathering.

    Triggered after the client completes the progressbar.
    Grants the configured item and shows the inventory itembox.
]]

RegisterNetEvent('offmeta-gathering:server:giveItem', function(itemName, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then
        print(('[offmeta-gathering] Player not found (src=%s)'):format(src))
        return
    end

    if type(itemName) ~= 'string' or itemName == '' then
        print(('[offmeta-gathering] Invalid itemName from src=%s'):format(src))
        return
    end

    local amt = tonumber(amount) or 1
    if amt < 1 then amt = 1 end
    if amt > 100 then amt = 100 end -- safety clamp

    local itemData = QBCore.Shared.Items[itemName]
    if not itemData then
        print(('[offmeta-gathering] Unknown item "%s" from src=%s'):format(itemName, src))
        return
    end

    Player.Functions.AddItem(itemName, amt)
    TriggerClientEvent('inventory:client:ItemBox', src, itemData, 'add', amt)
end)
