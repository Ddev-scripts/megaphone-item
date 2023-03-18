local function EnableSubmix()
    SetAudioSubmixEffectRadioFx(0, 0)
    SetAudioSubmixEffectParamInt(0, 0, `default`, 1)
    SetAudioSubmixEffectParamFloat(0, 0, `freq_low`, 200.0)
    SetAudioSubmixEffectParamFloat(0, 0, `freq_hi`, 9000.0)
    SetAudioSubmixEffectParamFloat(0, 0, `fudge`, 0.5)
    SetAudioSubmixEffectParamFloat(0, 0, `rm_mix`, 19.0)
end

local function DisableSubmix()
    if IsEntityPlayingAnim(PlayerPedId(), "molly@megaphone", "megaphone_clip", 3) then
        StopEntityAnim(PlayerPedId(), "megaphone_clip", "molly@megaphone", -4.0)
    end
    SetAudioSubmixEffectRadioFx(0, 0)
end

local usingMegaphone = false
local megaphoneObject = nil

RegisterNetEvent('megaphone:use')
AddEventHandler('megaphone:use', function()
    if usingMegaphone then
        DisableSubmix()
    end
    usingMegaphone = not usingMegaphone
    CreateThread(function()
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
            EnableSubmix()
            Wait(100)
        end

        if DoesEntityExist(megaphoneObject) then
            DeleteObject(megaphoneObject)
            megaphoneObject = nil
        end

    end)
end)
