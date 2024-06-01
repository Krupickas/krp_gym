local shopZones = {}
local shopPed = nil
lib.locale()
function CreateShopZones(gyms)
    for gymName, gymData in pairs(gyms) do
        local x, y, z, h = table.unpack(gymData.Shop.npcLocation)
        local model = 'a_m_y_musclbeac_02' -- Change this to the desired NPC model

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end

        shopPed = CreatePed(4, model, x, y, z, h, false, true)
        SetEntityHeading(shopPed, h)
        FreezeEntityPosition(shopPed, true)
        SetEntityInvincible(shopPed, true)
        SetBlockingOfNonTemporaryEvents(shopPed, true)

        if Config.Interaction == 'target' then
            AddCircleZone(gymName .. 'Shop', vector3(x, y, z +1), 1.0, {
                name = gymName .. 'Shop',
                debugPoly = false,
                useZ = true
            }, {
                options = {
                    {
                        action = function()
                            OpenShopMenu(gymData.Shop.shop.items)
                        end,
                        icon = 'fas fa-shopping-bag',
                        label = locale('open_shop')
                    }
                },
                distance = 2.5
            })
        else
            local zone = lib.zones.sphere({
                coords = vector3(x, y, z +1),
                radius = 1.0,
                debug = false,
                inside = function()
                    Display3DText(x, y, z +1, "[E] ".. locale('open_shop'))
                    if IsControlJustReleased(0, 38) then 
                        OpenShopMenu(gymData.Shop.shop.items)
                    end
                end,
                onEnter = function()
                end,
                onExit = function()
                end
            })
            table.insert(shopZones, zone)
        end
    end
end

function OpenShopMenu(items)
    PlayPedAmbientSpeechNative(shopPed, 'GENERIC_HI', 'Speech_Params_Force')
    local options = {}
    for _, item in ipairs(items) do
        table.insert(options, {
            title = item.itemText .. " - $" .. item.itemPrice,
            description = item.itemDescription,
            icon = 'fas fa-shopping-bag',
            onSelect = function()
                local dict = "misscarsteal4@actor"
                local clip = "actor_berating_loop"
                lib.requestAnimDict(dict, 500)
                PlayPedAmbientSpeechNative(shopPed, 'GENERIC_THANKS', 'SPEECH_PARAMS_FORCE')
                lib.progressBar({
                    duration = 4000,
                    label = locale('buying'),
                    useWhileDead = false,
                    canCancel = false,
                    disable = {
                        car = true,
                        move = true
                    },
                    anim = {
                        dict = dict,
                        clip = clip
                    },
                }) 
                TriggerServerEvent('krp_gym:buyItem', item.itemName, item.itemPrice)
            end
        })
    end
    
    lib.registerContext({
        id = 'gym_shop_menu',
        title = locale('gym_shop'),
        options = options
    })
    
    lib.showContext('gym_shop_menu')
end

function RemoveShopZones(gyms)
    if Config.Interaction == 'target' then
        for gymName, gymData in pairs(gyms) do
            RemoveZone(gymName .. 'Shop')
            DeletePed(shopPed)
        end
    else
        for _, zone in ipairs(shopZones) do
            zone:remove()
        end
        DeletePed(shopPed)
        shopZones = {}
    end
end