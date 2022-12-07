local NDCore = exports['nd-core']:GetCoreObject()
local PlayerData = NDCore.Functions.GetPlayerData()

PlayerGang = {}
employees = {}
bank = 0
unemployed = {}

RegisterNetEvent('NDCore:Client:OnPlayerLoaded')
AddEventHandler('NDCore:Client:OnPlayerLoaded', function()
    PlayerGang = NDCore.Functions.GetPlayerData().gang
end)

RegisterNetEvent('NDCore:Client:OnGangUpdate')
AddEventHandler('NDCore:Client:OnGangUpdate', function(GangInfo)
    PlayerGang = GangInfo
end)

RegisterNetEvent('NDCore:Client:OnPlayerUnload', function()
    PlayerGang = {}
    bank = 0
    employees = {}
    unemployed = {}
end)

AddEventHandler('onClientResourceStart',function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    PlayerGang = NDCore.Functions.GetPlayerData().gang
end)

-- Functions
local function OpenWeaponCraftingMenu()
    local columns = {
        {
            header = "Weapon Crafting",
            isMenuHeader = true,
        },
    }
    for k, v in pairs(Config.Weapons) do
        local item = {}
        item.header = "<img src=nui://"..Config["Inv-Link"]..NDCore.Shared.Items[v.hash].image.." width=35px style='margin-right: 10px'> " .. v.label
        local text = ""
        for k, v in pairs(v.materials) do
            text = text .. "- " .. v.item .. ": " .. v.amount .. "<br>"
        end
        item.text = text
        item.params = {
            event = 'nd-craft:client:craftWeapon',
            args = {
            type = k
            }
        }
        table.insert(columns, item)
    end
    exports['nd-menu']:openMenu(columns)
end

local function OpenMiningCraftingMenu()
    local columns = {
        {
            header = "Mining Crafting",
            isMenuHeader = true,
        },
    }
    for k, v in pairs(Config.Mining) do
        local item = {}
        item.header = "<img src=nui://"..Config["Inv-Link"]..NDCore.Shared.Items[v.hash].image.." width=35px style='margin-right: 10px'> " .. v.label
        local text = ""
        for k, v in pairs(v.materials) do
            text = text .. "- " .. v.item .. ": " .. v.amount .. "<br>"
        end
        item.text = text
        item.params = {
            event = 'nd-craft:client:craftMining',
            args = {
                type = k
            }
        }
        table.insert(columns, item)
    end
    exports['nd-menu']:openMenu(columns)
end

local function OpenAttachmentCraftingMenu()
    local columns = {
        {
            header = "Attachment Crafting",
            isMenuHeader = true,
        },
    }
    for k, v in pairs(Config.Attachment) do
        local item = {}
        item.header = "<img src=nui://"..Config["Inv-Link"]..NDCore.Shared.Items[v.hash].image.." width=35px style='margin-right: 10px'> " .. v.label
        local text = ""
        for k, v in pairs(v.materials) do
            text = text .. "- " .. v.item .. ": " .. v.amount .. "<br>"
        end
        item.text = text
        item.params = {
            event = 'nd-craft:client:craftAttachment',
            args = {
                type = k
            }
        }
        table.insert(columns, item)
    end
    exports['nd-menu']:openMenu(columns)
end

local function OpenExplosiveCraftingMenu()
    local columns = {
        {
            header = "Еxplosive",
            isMenuHeader = true,
        },
    }
    for k, v in pairs(Config.Explosive) do
        local item = {}
        item.header = "<img src=nui://"..Config["Inv-Link"]..NDCore.Shared.Items[v.hash].image.." width=35px style='margin-right: 10px'> " .. v.label
        local text = ""
        for k, v in pairs(v.materials) do
            text = text .. "- " .. v.item .. ": " .. v.amount .. "<br>"
        end
        item.text = text
        item.params = {
            event = 'nd-craft:client:craftExplosive',
            args = {
                type = k
            }
        }
        table.insert(columns, item)
    end
    exports['nd-menu']:openMenu(columns)
end

local function CraftWeapon(weapon)
    NDCore.Functions.Progressbar('crafting_weapon', 'Изработка... '..Config.Weapons[weapon].label, 5000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        }, {}, {}, function() -- Success
        NDCore.Functions.Notify("Изработено "..Config.Weapons[weapon].label, 'success')
        TriggerServerEvent('nd-craft:server:craftWeapon', Config.Weapons[weapon].hash)
        for k, v in pairs(Config.Weapons[weapon].materials) do
             TriggerServerEvent('NDCore:Server:RemoveItem', v.item, v.amount)
             TriggerEvent("inventory:client:ItemBox", NDCore.Shared.Items[v.item], "remove")
        end
        --TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent('animations:client:EmoteCancel', {"c"})
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        NDCore.Functions.Notify('Отменихте процеса на изработка', 'error')
    end)
end

local function CraftMining(mining)
    NDCore.Functions.Progressbar('crafting_mining', 'Изработка... '..Config.Mining[mining].label, 5000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        }, {}, {}, function() -- Success
        NDCore.Functions.Notify("Изработи "..Config.Mining[mining].label, 'success')
        TriggerServerEvent('nd-craft:server:craftMining', Config.Mining[mining].hash)
        for k, v in pairs(Config.Mining[mining].materials) do
             TriggerServerEvent('NDCore:Server:RemoveItem', v.item, v.amount)
             TriggerEvent("inventory:client:ItemBox", NDCore.Shared.Items[v.item], "remove")
        end
        --TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent('animations:client:EmoteCancel', {"c"})
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        NDCore.Functions.Notify('Отменихте процеса на изработка', 'error')
    end)
end

local function CraftAttachment(attachment)
    NDCore.Functions.Progressbar('crafting_аttachment', 'Изработка... '..Config.Attachment[attachment].label, 5000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        }, {}, {}, function() -- Success
        NDCore.Functions.Notify("Изработи "..Config.Attachment[attachment].label, 'success')
        TriggerServerEvent('nd-craft:server:craftAttachment', Config.Attachment[attachment].hash)
        for k, v in pairs(Config.Attachment[attachment].materials) do
             TriggerServerEvent('NDCore:Server:RemoveItem', v.item, v.amount)
             TriggerEvent("inventory:client:ItemBox", NDCore.Shared.Items[v.item], "remove")
        end
        --TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent('animations:client:EmoteCancel', {"c"})
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        NDCore.Functions.Notify('Отменихте процеса на изработка', 'error')
    end)
end

local function CraftExplosive(explosive)
    NDCore.Functions.Progressbar('crafting_explosive', 'Изработка... '..Config.Explosive[explosive].label, 5000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        }, {}, {}, function() -- Success
        NDCore.Functions.Notify("Изработи "..Config.Explosive[explosive].label, 'success')
        TriggerServerEvent('nd-craft:server:craftExplosive', Config.Explosive[explosive].hash)
        for k, v in pairs(Config.Explosive[explosive].materials) do
             TriggerServerEvent('NDCore:Server:RemoveItem', v.item, v.amount)
             TriggerEvent("inventory:client:ItemBox", NDCore.Shared.Items[v.item], "remove")
        end
        --TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent('animations:client:EmoteCancel', {"c"})
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        NDCore.Functions.Notify('Отменихте процеса на изработка', 'error')
    end)
end

-- Events
RegisterNetEvent('nd-craft:client:craftWeapon', function(data)
    NDCore.Functions.TriggerCallback("nd-craft:server:enoughMaterials", function(hasMaterials)
        if (hasMaterials) then
            CraftWeapon(data.type)
        else
            NDCore.Functions.Notify("Нямате достатъчно материали", "error")
            return
        end
    end, Config.Weapons[data.type].materials)
end)

RegisterNetEvent('nd-craft:client:craftMining', function(data)
    NDCore.Functions.TriggerCallback("nd-craft:server:enoughMaterials", function(hasMaterials)
        if (hasMaterials) then
            CraftMining(data.type)
        else
            NDCore.Functions.Notify("Нямате достатъчно материали", "error")
            return
        end
    end, Config.Mining[data.type].materials)
end)

RegisterNetEvent('nd-craft:client:craftAttachment', function(data)
    NDCore.Functions.TriggerCallback("nd-craft:server:enoughMaterials", function(hasMaterials)
        if (hasMaterials) then
            CraftAttachment(data.type)
        else
            NDCore.Functions.Notify("Нямате достатъчно материали", "error")
            return
        end
    end, Config.Attachment[data.type].materials)
end)

RegisterNetEvent('nd-craft:client:craftExplosive', function(data)
    NDCore.Functions.TriggerCallback("nd-craft:server:enoughMaterials", function(hasMaterials)
        if (hasMaterials) then
            CraftExplosive(data.type)
        else
            NDCore.Functions.Notify("Нямате достатъчно материали", "error")
            return
        end
    end, Config.Explosive[data.type].materials)
end)

-- Threads
CreateThread(function()
    for k,v in pairs(Config.PublicLocation4) do
        for k, v in pairs(v) do
         exports['nd-target']:AddBoxZone(v.name, v.loc, v.length, v.width, {
            name = v.name,
            heading = v.heading,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ
    },{
            options = {
                {
                    label = '⚒ Craft Explosive',
                    action = function()
                        OpenExplosiveCraftingMenu()
                    end,
                },
            },
                distance = 1.5
            })
        end
    end
end)

CreateThread(function()
    for k,v in pairs(Config.PublicLocation3) do
        for k, v in pairs(v) do
         exports['nd-target']:AddBoxZone(v.name, v.loc, v.length, v.width, {
            name = v.name,
            heading = v.heading,
            debugPoly = false,
            minZ = v.minZ,
            maxZ = v.maxZ
    },{
            options = {
                {
                    label = '⚒ Craft Attachments',
                    action = function()
                        OpenAttachmentCraftingMenu()
                    end,
                },
            },
                distance = 1.5
            })
        end
    end
end)

CreateThread(function()
    for k,v in pairs(Config.PublicLocation2) do
        for k, v in pairs(v) do 
            exports['nd-target']:AddBoxZone(v.name, v.loc, v.length, v.width, {
                name = v.name,
                heading = v.heading,
                debugPoly = false,
                minZ = v.minZ,
                maxZ = v.maxZ
        },{
            options = {
                {
                    label = '⚒ Craft Mining',
                    action = function()
                        OpenMiningCraftingMenu()
                    end,
                },
            },
                distance = 1.5
            })
        end
    end
end)

CreateThread(function()
    for k,v in pairs(Config.PublicLocation) do
        for k, v in pairs(v) do 
            exports['nd-target']:AddBoxZone(v.name, v.loc, v.length, v.width, {
                name = v.name,
                heading = v.heading,
                debugPoly = false,
                minZ = v.minZ,
                maxZ = v.maxZ
        },{
            options = {
                {
                    label = '⚒ Craft Weapons',
                    action = function()
                        OpenWeaponCraftingMenu()
                    end,
                },
            },
                distance = 1.5
            })
        end
    end
end)