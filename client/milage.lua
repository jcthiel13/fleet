local inveh = false
local vehnum
local plate
fleetveh = false
mileage = 0
local x = 0.01135
local y = 0.002
local player = GetPlayerServerId(PlayerId())

local pid = GetPlayerServerId(PlayerPedId())

--------Check if Ped is in Vehicle------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(250)
        if IsPedInAnyVehicle(PlayerPedId(), false) and not inVeh then
            Citizen.Wait(50)
            local veh = GetVehiclePedIsIn(PlayerPedId(),false)
            local driver = GetPedInVehicleSeat(veh, -1)
            if driver == PlayerPedId() and GetVehicleClass(veh) ~= 13 and GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 17 and GetVehicleClass(veh) ~= 21 then
                inveh = true
                Wait(50)
                plate = GetVehicleNumberPlateText(veh)
                --local fw = exports.framework:getClientFunctions()
                --local player = fw.serverId
                TriggerServerEvent('fleet:checkveh', player, plate)
                Wait(1)
                if fleetveh == true then
                    --print('in fleet vehicle')
                    local oldPos = GetEntityCoords(PlayerPedId())
                    Citizen.Wait(10000)
                    local curPos = GetEntityCoords(PlayerPedId())
                        if IsVehicleOnAllWheels(veh) then
                            dist = GetDistanceBetweenCoords(oldPos.x, oldPos.y, oldPos.z, curPos.x, curPos.y, curPos.z, true)
                        else
                            dist = 0
                        end
                    new = mileage + dist/1560
                    mileage = Round(new, 3)
                    TriggerServerEvent('fleet:addMileage', plate, mileage)
                else
                    Wait(10000)
                end
            end
        end
    end
end)

displayHud = true

Citizen.CreateThread(function()
    while true do
        if fleetveh == true then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                    local veh = GetVehiclePedIsIn(PlayerPedId(),false)
                    local driver = GetPedInVehicleSeat(veh, -1)
                    if driver == PlayerPedId() and GetVehicleClass(veh) ~= 13 and GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 17 and GetVehicleClass(veh) ~= 21 then
                DrawAdvancedText(0.270 - x, 0.97 - y, 0.005, 0.0028, 0.6, Round(mileage, 2), 255, 255, 255, 255, 6, 1)
                DrawAdvancedText(0.325 - x, 0.97 - y, 0.005, 0.0028, 0.6, "miles", 255, 255, 255, 255, 6, 1)
                end
            else
                Citizen.Wait(750)
            end
        end
        Citizen.Wait(0)
    end
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end


RegisterNetEvent('fleet:SetOld', function(old)
    --print(old)
    mileage = old
end)

RegisterNetEvent('fleet:SetStatus', function(status)
    --print(status)
    fleetveh = status
end)

