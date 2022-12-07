local NDCore = exports['nd-core']:GetCoreObject()

local weapons = {
    ['craft'] = {},
}

--Events
RegisterNetEvent('nd-craft:server:craftWeapon', function(data, weapon)
    local src = source
    local Player = NDCore.Functions.GetPlayer(src)
    local receiveAmount = 1
    Player.Functions.AddItem(data, receiveAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, NDCore.Shared.Items[data], "add")
end)

RegisterNetEvent('nd-craft:server:craftMining', function(data, mining)
    local src = source
    local Player = NDCore.Functions.GetPlayer(src)
    local receiveAmount = 1
    Player.Functions.AddItem(data, receiveAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, NDCore.Shared.Items[data], "add")
end)

RegisterNetEvent('nd-craft:server:craftAttachment', function(data, attachment)
    local src = source
    local Player = NDCore.Functions.GetPlayer(src)
    local receiveAmount = 1
    Player.Functions.AddItem(data, receiveAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, NDCore.Shared.Items[data], "add")
end)

RegisterNetEvent('nd-craft:server:craftExplosive', function(data, explosive)
    local src = source
    local Player = NDCore.Functions.GetPlayer(src)
    local receiveAmount = 1
    Player.Functions.AddItem(data, receiveAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, NDCore.Shared.Items[data], "add")
end)

--Callback
NDCore.Functions.CreateCallback('nd-craft:server:enoughMaterials', function(source, cb, materials)
    local src = source
    local hasItems = false
    local idk = 0
    local player = NDCore.Functions.GetPlayer(source)
    for k, v in pairs(materials) do
        if player.Functions.GetItemByName(v.item) and player.Functions.GetItemByName(v.item).amount >= v.amount then
            idk = idk + 1
            if idk == #materials then
                cb(true)
            end
        else
            cb(false)
            return
        end
    end
end)
