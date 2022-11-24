info = {}
extras = {}

fw = exports.framework:getClientFunctions()

local dept

--*Set Department on Character Load
RegisterNetEvent('fleet:setdept', function(dept)
    print('Fleet Department Set: ' .. dept)
    current_dept = dept
end)

--*Main Loop, checks if level matches
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local deptgarage = cfg.garage[current_dept]
        if (deptgarage) then
            for loc, coord in pairs(deptgarage) do
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local dist = GetDistanceBetweenCoords(pos, coord.x, coord.y, coord.z, true)
                if dist <= 6.0 then
                    local marker ={
                        ['x'] = coord.x,
                        ['y'] = coord.y,
                        ['z'] = coord.z
                    }
                    DrawText3Ds(marker['x'], marker['y'], marker['z'], "[E] Open Garage")
                    if dist <= 1.5 then
                        if IsControlJustReleased(0, 46) then
                            TriggerEvent('fleet:openmainmenu', coord)
                        end
                    end
                end
            end
        end
    end
end)

DrawText3Ds = function(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local factor = #text / 370
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end


function getdept(player)
    local dept
    if cfg.framework == true then
        pldept = exports.framework:getclientdept(player)
    end
    return pldept
end

RegisterNetEvent('fleet:updatevehicle', function(plate)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local metadata = GetVehicleProperties(veh) 
    local damage = {
        body = math.ceil(GetVehicleBodyHealth(veh)),
        engine = math.ceil(GetVehicleEngineHealth(veh)),
        visual = CopyVehicleDamages(veh)
    }
    TriggerServerEvent('fleet:save', metadata, plate, damage)
end)

RegisterNetEvent('fleet:newvehicle')
AddEventHandler('fleet:newvehicle', function(player, num, dept)    
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, true)
    local vehhash = GetEntityModel(veh)
    local plate = GetVehicleNumberPlateText(veh)
    local vehnum = num
    local livery = GetVehicleLivery(veh)

    info = {
    metadata = GetVehicleProperties(veh),
    plate = plate,
    vehnum = vehnum,
    dept = dept,
    hash = vehhash,}
    TriggerServerEvent('fleet:makenew', player, info)
end)

RegisterNetEvent('fleet:spawncar', function(data, loc)
    local hash = json.decode(data.hash)
    local meta = json.decode(data.metadata)
    local extras = json.decode(data.extras)
    local damage = json.decode(data.damage)
    local vehicle = GetLabelText(GetDisplayNameFromVehicleModel(meta.hash))

    local plate = meta.plate
    local veh = SpawnVehicle(hash, loc, true)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    SetEntityHeading(veh, loc.h)
    SetVehicleNumberPlateText(veh, plate)
    SetVehicleProperties(veh, meta)
    DoDamage(veh, damage)
    TriggerServerEvent('fleet:updatestatus', plate, 'out')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    local ped = GetPlayerServerId(PlayerId())
    current_dept = fw.clientInfo[ped].dept
    TriggerServerEvent('fleet:resetallstatus')
end)

RegisterNetEvent('fleet:delete', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)
end)