lib.locale()


if Config.Framework == "ESX" then
    if Config.NewESX then
        ESX = exports["es_extended"]:getSharedObject()
    else
        ESX = nil
        CreateThread(function()
            while ESX == nil do
                TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
                Wait(100)
            end
        end)
    end
elseif Config.Framework == "QB" then
    QBCore = nil
    QBCore = exports["qb-core"]:GetCoreObject()
end



function AddCircleZone(name, coords, radius, options, eventOptions)
    if Config.Target == 'qtarget' then
        exports.qtarget:AddCircleZone(name, vec3(coords[1], coords[2], coords[3]), radius, options, eventOptions)
    elseif Config.Target == 'ox_target' then
        exports.qtarget:AddCircleZone(name, vec3(coords[1], coords[2], coords[3]), radius, options, eventOptions)
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:AddCircleZone(name, vec3(coords[1], coords[2], coords[3]), radius, options, eventOptions)
    end
end


function RemoveZone(name)
    if Config.Target == 'qtarget' then
        exports.qtarget:RemoveZone(name)
    elseif Config.Target == 'ox_target' then
        exports.qtarget:RemoveZone(name)
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:RemoveZone(name)
    end
end


function Display3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local scale = 0.35
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end
