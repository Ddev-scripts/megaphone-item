local function DisableSubmix()
    if IsEntityPlayingAnim(PlayerPedId(), "molly@megaphone", "megaphone_clip", 3) then
        StopEntityAnim(PlayerPedId(), "megaphone_clip", "molly@megaphone", -4.0)
    end
    TriggerServerEvent('megaphone:applySubmix', false)
end

local usingMegaphone = false
local megaphoneObject = ni

RegisterNetEvent('megaphone:use')
AddEventHandler('megaphone:use', function()
    if usingMegaphone then
        DisableSubmix()
        exports["pma-voice"]:setMegaphone(false, 2)
    end
    usingMegaphone = not usingMegaphone
    CreateThread(function()
        if usingMegaphone then
            TriggerServerEvent('megaphone:applySubmix', true)
            exports["pma-voice"]:setMegaphone(true, 1)
        end
        while usingMegaphone do
            if not IsEntityPlayingAnim(PlayerPedId(), "molly@megaphone", "megaphone_clip", 3) then
                local playerPed = PlayerPedId()
                local animDict = "molly@megaphone"
                local animName = "megaphone_clip"

                RequestAnimDict(animDict)
                while not HasAnimDictLoaded(animDict) do
                    Citizen.Wait(100)
                end

                TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)

                if not DoesEntityExist(megaphoneObject) then
                    RequestModel("prop_megaphone_01")
                    while not HasModelLoaded("prop_megaphone_01") do
                        Citizen.Wait(100)
                    end

                    local playerPos = GetEntityCoords(playerPed)

                    megaphoneObject = CreateObject(GetHashKey("prop_megaphone_01"), playerPos.x, playerPos.y, playerPos.z, true, true, true)
                    SetEntityCollision(megaphoneObject, false, false)

                    AttachEntityToEntity(megaphoneObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.050000, 0.054000, -0.006000, -71.885498, -13.088900, -16.024200, true, true, false, true, 1, true)
                    SetModelAsNoLongerNeeded("prop_megaphone_01")
                end

                RemoveAnimDict(animDict)
            end
            Wait(100)
        end

        if DoesEntityExist(megaphoneObject) then
            DeleteObject(megaphoneObject)
            megaphoneObject = nil
        end
    end)
end)

local data = {
    [`default`] = 0,
    [`freq_low`] = 0.0,
    [`freq_hi`] = 10000.0,
    [`rm_mod_freq`] = 300.0,
    [`rm_mix`] = 0.2,
    [`fudge`] = 0.0,
    [`o_freq_lo`] = 200.0,
    [`o_freq_hi`] = 5000.0,
}

local filter

CreateThread(function()
    filter = CreateAudioSubmix("Megaphone")
    SetAudioSubmixEffectRadioFx(filter, 0)
    for hash, value in pairs(data) do
        SetAudioSubmixEffectParamInt(filter, 0, hash, 1)
    end
    AddAudioSubmixOutput(filter, 0)
end)

RegisterNetEvent('megaphone:updateSubmixStatus', function(state, source)
    if state then
        MumbleSetSubmixForServerId(source, filter)
    else
        MumbleSetSubmixForServerId(source, -1)
    end
end)


-- TODO : ADD SAME FOR QBCORE
AddEventHandler('esx:onPlayerDeath', function()
    usingMegaphone = false
    DisableSubmix()
    exports["pma-voice"]:setMegaphone(false, 2)
end)
