ESX.RegisterUsableItem('megaphone', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        TriggerClientEvent('megaphone:use', source)
    end
end)
