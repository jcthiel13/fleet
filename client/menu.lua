--- MenuV Menu
---@type Menu

fw = exports.framework:getClientFunctions()
local fleetmenu = MenuV:CreateMenu(false, 'Fleet Menu', topleft, 255, 0, 0, 'size-150', 'none', 'menuv', 'fmm')
local vehmenu = MenuV:CreateMenu(false, 'Vehicle Selection Menu', topleft, 255, 0, 0, 'size-150', 'none', 'menuv', 'vsm')
local adminmenu = MenuV:CreateMenu(false, 'Vehicle Selection Menu', topleft, 255, 0, 0, 'size-150', 'none', 'menuv', 'am')
local create = MenuV:CreateMenu(false, 'Vehicle Creation Menu', topleft, 255, 0, 0, 'size-150', 'none', 'menuv', 'vcm')
local store = MenuV:CreateMenu(false, 'Vehicle Creation Menu', topleft, 255, 0, 0, 'size-150', 'none', 'menuv', 'store')
local loc
local player = GetPlayerServerId(PlayerId())

RegisterNetEvent('fleet:openmainmenu', function(coord)
    loc = coord
    local admin = CheckPerms(player)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        print('ped is in vehicle')
        MenuV:OpenMenu(store)
        store:ClearItems()
        store:AddButton({
            icon = '💾',
            label = ' Store Vehicle?',
            description = 'Would you like to store return this vehicle to the garage?',
            value = nil,
            select = function(btn)
                --local player = fw.serverId
                print('Storing Vehicle')
                plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()))
                TriggerServerEvent('fleet:checkdb', player, plate)
                MenuV:CloseAll()
            end
        })
        if (admin) then
            store:AddButton({
                icon = '🔆',
                label = ' New Vehicle',
                description = 'Add a new vehicle to the fleet menu.',
                value = nil,
                select = function(btn)
                    OpenCreationMenu()
                end
            })
        end
    else
        print('ped is not in vehicle')
        MenuV:OpenMenu(fleetmenu)
        fleetmenu:ClearItems()
        adminmenu:ClearItems()
        fleetmenu:AddButton({
            icon = '🚗',
            label = ' Select Vehicle',
            description = 'Select a Vehicle to Spawn.',
            value = nil,
            select = function(btn)
                --local player = fw.serverId
                TriggerServerEvent('fleet:lookup', player, fw.clientInfo[player].dept)
            end
        })
        if (admin) then
            fleetmenu:AddButton({
                icon = '⚙',
                label = ' Admin Menu',
                description = 'Add new vehicles to the fleet or adjust permissions.',
                value = nil,
                select = function(btn)
                    MenuV:OpenMenu(adminmenu)
                end
            })
            adminmenu:AddButton({
                icon = '🔆',
                label = ' New Vehicle',
                description = 'Add a new vehicle to the fleet menu.',
                value = nil,
                select = function(btn)
                    OpenCreationMenu()
                end
            })
        end
    end
end)

RegisterNetEvent('fleet:openvehmenu', function(data)
    vehmenu:ClearItems()
    MenuV:OpenMenu(vehmenu)
    for k, v in ipairs(data) do
        local hash = json.decode(v.hash)
        local meta = json.decode(v.metadata)
        local name = GetLabelText(GetDisplayNameFromVehicleModel(hash))
        if v.status == 'avail' then
            vehmenu:AddButton({
                label = v.vehnum .. ' | ' .. name .. ' (' .. Round(v.mileage, 1) .. ' miles)',
                description = 'Spawn Vehicle Number ' .. v.vehnum,
                select = function(_)
                    TriggerEvent('fleet:spawncar', v, loc)
                    MenuV:CloseAll()
                end
            })
        end
    end
end)

function OpenCreationMenu()
    local vehnum = 'Select Vehicle Number'
    local dept = cfg.dept[1]
    MenuV:OpenMenu(create)
    create:ClearItems()
    create:AddButton({
        icon = '',
        label = vehnum,
        value = "reason",
        description = 'Set the Vehicle Number',
        select = function(_)
            vehnum = LocalInput('Set Vehicle Number:', 255)
        end
    })
    create:AddSlider({
        icon = '',
        label = 'Department',
        description = 'What Department is the vehicle registered to?',
        value = cfg.dept[1],
        values = {
            { label = cfg.dept[1], value = cfg.dept[1], description = 'Register this vehicle with the ' .. cfg.dept[1] },
            { label = cfg.dept[2], value = cfg.dept[2], description = 'Register this vehicle with the ' .. cfg.dept[2] },
            { label = cfg.dept[3], value = cfg.dept[3], description = 'Register this vehicle with the ' .. cfg.dept[3] },
            { label = cfg.dept[4], value = cfg.dept[4], description = 'Register this vehicle with the ' .. cfg.dept[4] },
        },
        change = function(_, newValue, _)
            dept = cfg.dept[newValue]
        end
    })
    create:AddButton({
        icon = '',
        label = 'Create Vehicle',
        description = 'Confirm Vehicle Creation',
        select = function(_)
            --local player = fw.serverId
            print('Vehicle Number is: ' .. vehnum .. ' with the ' .. dept)
            TriggerEvent('fleet:newvehicle' , player, vehnum, dept)
            MenuV:CloseAll()
        end
    })
end


function LocalInput(text, number, windows)
    AddTextEntry("FMMC_MPM_NA", text)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", windows or "", "", "", "", number or 30)
    while (UpdateOnscreenKeyboard() == 0) do
    DisableAllControlActions(0)
    Wait(0)
    end

    if (GetOnscreenKeyboardResult()) then
    local result = GetOnscreenKeyboardResult()
        return result
    end
end
