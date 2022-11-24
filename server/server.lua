framework = exports.framework:geteverything()


--!Command Not Needed
--[[RegisterCommand('returnveh', function(src, args, raw)
    
    --vehnum = table.concat(args)
    --TriggerClientEvent('fleet:newvehicle', src, vehnum, src)
end)]]

RegisterNetEvent('fleet:makenew')
AddEventHandler('fleet:makenew', function(player, info)
    local plate = info.metadata.plate
    local hash = json.encode(info.hash)
    local metadata = json.encode(info.metadata)
    MySQL.Async.fetchAll('SELECT * FROM fleet WHERE plate = @plate',{['@plate'] = plate}, function(result)
    if result[1] then
        print('Plate: ' .. plate .. ' is already in use')
        TriggerEvent('chatMessage', player, "[^3FLEET ADMIN^7]", 'Plate: ' .. plate .. ' is already in use')
    else 
        MySQL.Async.execute('INSERT INTO fleet (vehnum, plate, hash, metadata, dept) VALUES (@vehnum, @plate, @hash, @metadata, @dept)', {["vehnum"] = info.vehnum, ["plate"] = info.plate, ["hash"] = hash, ["metadata"] = metadata, ["dept"] = info.dept})
    end
end)
end)

RegisterNetEvent('fleet:lookup')
AddEventHandler('fleet:lookup', function(src, dept)
    MySQL.Async.fetchAll('SELECT * FROM fleet WHERE dept = @dept', {["@dept"] = dept}, function(data)
        print("ran sql")
        TriggerClientEvent('fleet:openvehmenu', src, data)
        print("shipped data to client menu")
    end)
end)

RegisterNetEvent('NAT2K15:CHECKSQL')
AddEventHandler('NAT2K15:CHECKSQL', function(steam, discord, first_name, last_name, twt, dept, dob, gender, data)
    local src = source
    TriggerClientEvent('fleet:setdept', src, dept)
    end)
RegisterNetEvent('fleet:updatestatus', function(plate, status)
    MySQL.Async.execute('UPDATE fleet SET status = ? WHERE plate = ?', {status, plate})
end)

RegisterNetEvent('fleet:resetallstatus', function()
    MySQL.Async.execute('UPDATE fleet SET status = ? WHERE id LIKE ?', {'avail', '%'})
end)

RegisterNetEvent('fleet:checkveh', function(src, plate)
    MySQL.Async.fetchAll('SELECT * FROM fleet WHERE plate = @plate',{["@plate"] = plate}, function(result)
        local status = false
        if result[1] ~= nil then
            mileage = result[1].mileage
            status = true
            TriggerClientEvent('fleet:SetOld', src, mileage)
        else
            status = false
        end
        TriggerClientEvent('fleet:SetStatus', src, status)
    end)
end)

RegisterNetEvent('fleet:addMileage', function(plate, mileage)
    MySQL.Async.execute('UPDATE fleet SET mileage = ? WHERE plate = ?', {mileage, plate})
end)

RegisterNetEvent('fleet:checkdb', function(player, plate)
    MySQL.Async.fetchAll('SELECT * FROM fleet WHERE plate = @plate', {["@plate"] = plate}, function(result)
        if result[1] then
            print('found vehicle with plate ' .. result[1].plate)
            local plate = result[1].plate
            TriggerClientEvent('fleet:updatevehicle', player, plate)
            TriggerClientEvent('fleet:delete', player)
        else
            print('could not find vehicle with plate ' .. result[1].plate)
        end
    end)
end)

RegisterNetEvent('fleet:save', function(meta, plate, dmg)
    print('saving vehicle')
    local damage = json.encode(dmg)
    local metadata = json.encode(meta)
    MySQL.Async.execute('UPDATE fleet SET metadata = ?, damage = ? where plate = ?', {metadata, damage, plate})
    TriggerEvent('fleet:updatestatus', plate, 'avail')
end)