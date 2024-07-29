
local stamina = 100
local canExercise = true
local exercising = false
local shouldRegenerate = false
local usedPump = false
local exerciseZones = {}
lib.locale()
function PlayAnimation(ped, dict, anim, flag, duration)
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, duration, flag, 0, false, false, false)
end

function AttachBenchPropToPlayer()
    local hash = "prop_barbell_100kg"
    lib.requestModel(hash, 500)
    local prop = CreateObject(hash, GetEntityCoords(PlayerPedId()), true, true, true)
    AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.15, 0.3, 0.03, 0.0, -42.0, -104.0, true, true, false, false, 1, true)

    return {prop}
end

function AttachFreeWeightToPlayer()
    local hash = "prop_curl_bar_01"
    lib.requestModel(hash, 500)
local prop = CreateObject(hash, GetEntityCoords(PlayerPedId()), true, true, true)
AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.11, -0.09, 0.2, -209.0, -91.0, -28.0, true, true, false, false, 1, true)
return {prop}
end

function AttachDoubleFreeWeightToPlayer()
    local hash = "prop_barbell_01"
    lib.requestModel(hash, 500)

local prop = CreateObject(hash, GetEntityCoords(PlayerPedId()), true, true, true)
AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.1, 0.0, 0.02, -25.0, -75.0, -70.0, true, true, false, false, 1, true)

local prop2 = CreateObject(hash, GetEntityCoords(PlayerPedId()), true, true, true)
AttachEntityToEntity(prop2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.1, 0.02, -0.02, -27.0, -77.0, -118.0, true, true, false, false, 1, true)

return {prop, prop2}
end
function StartExercising(animInfo, pos, exerciseName)
    exercising = true
    local playerPed = PlayerPedId()

    lib.requestAnimDict(animInfo.Idle.Dict, 500)
    lib.requestAnimDict(animInfo.Enter.Dict, 500)
    lib.requestAnimDict(animInfo.Leave.Dict, 500)
    lib.requestAnimDict(animInfo.Action.Dict, 500)

    if pos.h ~= nil then
        FreezeEntityPosition(playerPed, true)
        SetEntityCoords(playerPed, pos.x, pos.y, pos.z)
        SetEntityHeading(playerPed, pos.h)
    end

    local BarbellProp = {}
    if exerciseName == 'Bench' then 
        BarbellProp = AttachBenchPropToPlayer()
    elseif exerciseName == 'FreeWeight' then
        BarbellProp = AttachFreeWeightToPlayer()
    elseif exerciseName == 'DoubleFreeWeight' then
        BarbellProp = AttachDoubleFreeWeightToPlayer()
    end

    PlayAnimation(playerPed, animInfo.Enter.Dict, animInfo.Enter.Anim, 0, animInfo.Enter.Wait)
    Citizen.Wait(animInfo.Enter.Wait)

    canExercise = true
    SendNUIMessage({action = "updateStamina", value = stamina})
    SendNUIMessage({action = "show"})
    lib.showTextUI('[BACKSPACE] - '.. locale('end_workout'))
    Citizen.CreateThread(function()
        while exercising and stamina > 0 do
            Wait(0)
            TaskPlayAnim(playerPed, animInfo.Idle.Dict, animInfo.Idle.Anim, 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
            if IsControlJustPressed(0, 22) then
                canExercise = false
                SendNUIMessage({action = "pressSpaceKey"})
                PlayAnimation(playerPed, animInfo.Action.Dict, animInfo.Action.Anim, 0, animInfo.Action.Wait)
                if Config.Skills.SkillSystem == 'gamz' then
                    exports["gamz-skillsystem"]:UpdateSkill(Config.Skills[exerciseName].skill, Config.Skills[exerciseName].add)
                else
                    exports["B1-skillz"]:UpdateSkill(Config.Skills[exerciseName].skill, Config.Skills[exerciseName].add)
                end
                Wait(animInfo.Action.Wait)
                stamina = stamina - 10
                SendNUIMessage({action = "updateStamina", value = stamina})
                canExercise = true
                TaskPlayAnim(playerPed, animInfo.Idle.Dict, animInfo.Idle.Anim, 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
                if stamina <= 0 then
                    FreezeEntityPosition(playerPed, false)
                    SendNUIMessage({action = "hide"})
                    lib.hideTextUI()
                    PlayAnimation(playerPed, animInfo.Leave.Dict, animInfo.Leave.Anim, 0, animInfo.Leave.Wait)
                    Wait(animInfo.Leave.Wait)
                    ClearPedTasks(playerPed)
                    if BarbellProp and #BarbellProp > 0 then
                        for _, prop in ipairs(BarbellProp) do
                            DeleteObject(prop)
                        end
                        BarbellProp = nil
                    end
                    exercising = false
                    canExercise = false
                    shouldRegenerate = true
                    RegenerateStamina()
                    TriggerServerEvent('gym:stopExercise', exerciseName, pos.x, pos.y, pos.z)
                end
            end
            if IsControlJustPressed(0, 177) then
                FreezeEntityPosition(playerPed, false)
                SendNUIMessage({action = "hide"})
                lib.hideTextUI()
                PlayAnimation(playerPed, animInfo.Leave.Dict, animInfo.Leave.Anim, 0, animInfo.Leave.Wait)
                Wait(animInfo.Leave.Wait)
                ClearPedTasks(playerPed)
                if BarbellProp and #BarbellProp > 0 then
                    for _, prop in ipairs(BarbellProp) do
                        DeleteObject(prop)
                    end
                    BarbellProp = nil
                end
                exercising = false
                canExercise = false
                shouldRegenerate = true
                RegenerateStamina()
                TriggerServerEvent('gym:stopExercise', exerciseName, pos.x, pos.y, pos.z)
            end
        end
    end)
end


function CreateExerciseZones(gymName, exercises)
    local gymConfig = Config.Gyms[gymName]

    for exerciseName, exerciseData in pairs(exercises) do
        local offset = exerciseData.offset or 0
        for posKey, posValue in pairs(exerciseData) do
            if posKey ~= "offset" then
                local x, y, z, h = table.unpack(posValue)
                local zone
                if Config.Interaction == 'target' then
                    AddCircleZone(exerciseName .. posKey, vector3(x, y, z + offset), 1.0, {
                        name = exerciseName .. posKey,
                        debugPoly = false,
                        useZ = true
                    }, {
                        options = {
                            {
                                action = function ()
                                    if gymConfig.requireMembership then
                                        lib.callback('krp_gym:getItem', false, function(hasMembership)
                                            if hasMembership then
                                                exerciseAction(exerciseName, x, y, z, h)
                                            else
                                                lib.notify({
                                                    title = 'Gym',
                                                    description = locale('you_need_membership'),
                                                    type = 'error'
                                                })
                                            end
                                        end)
                                    else
                                        exerciseAction(exerciseName, x, y, z, h)
                                    end
                                end,
                                icon = 'fas fa-dumbbell',
                                label = locale('start_excercise') .. exerciseName,
                            }
                        },
                        distance = 2.5
                    })
                else
                    zone = lib.zones.sphere({
                        coords = vector3(x, y, z + offset),
                        radius = 1.0,
                        debug = false,
                        inside = function()
                            Display3DText(x, y, z + offset, "[E]".. locale('start_excercise') .. exerciseName)
                            if IsControlJustReleased(0, 38) then
                                if gymConfig.requireMembership then
                                    lib.callback('krp_gym:getItem', false, function(hasMembership)
                                        if hasMembership then
                                            exerciseAction(exerciseName, x, y, z, h)
                                        else
                                            lib.notify({
                                                title = 'Gym',
                                                description = locale('you_need_membership'),
                                                type = 'error'
                                            })
                                        end
                                    end)
                                else
                                    exerciseAction(exerciseName, x, y, z, h)
                                end
                            end
                        end,
                        onEnter = function()
                        end,
                        onExit = function()
                        end
                    })
                    table.insert(exerciseZones, zone)
                end
            end
        end
    end
end


function exerciseAction(exerciseName, x, y, z, h)
    if not exercising then
        TriggerServerEvent('gym:tryStartExercise', exerciseName, x, y, z, h)
    else
        lib.notify({
            title = 'Gym',
            description = locale('you_are_exercising'),
            type = 'error'
        })
    end
end

RegisterNetEvent('gym:startExercise')
AddEventHandler('gym:startExercise', function(exerciseName, x, y, z, h)
    if stamina == 100 then
        StartExercising(Config.Animations[exerciseName], {x = x, y = y, z = z, h = h}, exerciseName)
    else
        lib.notify({
            title = 'Gym',
            description = locale('you_dont_have_stamina') .. stamina,
            type = 'info'
        })
    end
end)

RegisterNetEvent('gym:exerciseOccupied')
AddEventHandler('gym:exerciseOccupied', function()
    lib.notify({
        title = 'Gym',
        description = locale('exercise_occupied'),
        type = 'error'
    })
end)

function RemoveExerciseZones(exercises)
    if Config.Interaction == 'target' then
        for exerciseName, exerciseData in pairs(exercises) do
            local offset = exerciseData.offset or 0
            for posKey, posValue in pairs(exerciseData) do
                if posKey ~= "offset" then
                    RemoveZone(exerciseName .. posKey)
                end
            end
        end
    else
        for _, zone in ipairs(exerciseZones) do
            zone:remove()
        end
        exerciseZones = {}
    end
end


for gymName, gymData in pairs(Config.Gyms) do
    local zoneConfig = gymData.gymLibZone
    lib.zones.box({
        coords = zoneConfig.position,
        size = zoneConfig.size,
        rotation = zoneConfig.rotation,
        debug = zoneConfig.debug,
        inside = function()
        end,
        onEnter = function()
            CreateExerciseZones(gymName, gymData.Exercises) 
            CreateShopZones(Config.Gyms)
        end,
        onExit = function()
            RemoveExerciseZones(gymData.Exercises)
            RemoveShopZones(Config.Gyms)
        end
    })
end


function RegenerateStamina()
    Citizen.CreateThread(function()
        while shouldRegenerate do
            Wait(2000)
            if stamina < 100 then
                if not usedPump then
                    stamina = math.min(stamina + 5, 100)
                else
                    stamina = math.min(stamina + 15, 100)
                end
            end
            if stamina >= 100 then
                shouldRegenerate = false
            end
        end
    end)
end

    for gymName, gymData in pairs(Config.Gyms) do
        local blipPos = gymData.gymLibZone.position
        local blip = AddBlipForCoord(blipPos.x, blipPos.y, blipPos.z)

        SetBlipSprite(blip, gymData.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, gymData.blip.scale)
        SetBlipColour(blip, gymData.blip.colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(gymData.blip.name)
        EndTextCommandSetBlipName(blip)
    end

    RegisterNetEvent('krp_gym:usePreworkout')
    AddEventHandler('krp_gym:usePreworkout', function ()
        local playerPed = PlayerPedId()
        
        lib.progressBar({
            duration = 4000,
            label = locale('drinking_preworkout'),
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = {
                dict = 'mp_player_intdrink',
                clip = 'loop_bottle'
            },
            prop = {
                model = `prop_ld_flow_bottle`,
                pos = vec3(0.03, 0.03, 0.02),
                rot = vec3(0.0, 0.0, -1.5)
            },
        })
        usedPump = true
        Wait(300000)
        usedPump = false
    end)
