if Config.Framework == 'qb-core' then
    QBCore = exports['qb-core']:GetCoreObject()
    QBCore.Functions.CreateUseableItem('megaphone', function(source)
        TriggerClientEvent('megaphone:use', source)
    end)
elseif Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()

    ESX.RegisterUsableItem('megaphone', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            TriggerClientEvent('megaphone:use', source)
        end
    end)
end
