--[[RegisterNetEvent('fleet:getMileage')
AddEventHandler('fleet:getMileage', function(plate)
    MySQL.Async.fetchAll('SELECT * WHERE plate = @plate'{['@plate' = plate]}, function(data)
    TriggerClientEvent('fleet:math', data)
end)
end)]]