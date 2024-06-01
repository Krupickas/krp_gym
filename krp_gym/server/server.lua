lib.locale()
RegisterNetEvent('krp_gym:buyItem')
AddEventHandler('krp_gym:buyItem', function(itemName, itemPrice, npcCoords)
    local src = source
    if GetMoney(itemPrice, src) then
        RemoveMoney(itemPrice, src)
        AddItem(itemName, 1, src)
        TriggerClientEvent('ox_lib:notify', source, ({
            title = 'Gym',
            description = locale('you_bought') .. itemName .. locale('for') .. itemPrice,
            type = 'error'
        }))
    else
            TriggerClientEvent('ox_lib:notify', source, ({
                title = 'Gym',
                description = locale('not_enough_money'),
                type = 'error'
            }))
    end
end)


lib.callback.register('krp_gym:getItem', function(source)
    local hasItem = GetItem('membership', 1, source)
    if hasItem then
        return true 
    else
        return false 
    end
end)

SetTimeout(1000, function()
    RegisterUsable('preworkout', function(source)
        RemoveItem('preworkout', 1, source)
        TriggerClientEvent('krp_gym:usePreworkout', source)
    end)
end)
