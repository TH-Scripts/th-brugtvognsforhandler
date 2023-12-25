AddEventHandler('onResourceStart', function()
    local displayed = 0
    local table = MySQL.update.await('UPDATE th_brugtvogn_lager SET displayed = ? WHERE displayed = 1', {
        displayed
    })
end)

TriggerEvent('esx_society:registerSociety', Config.Job.job, Config.Job.job, Config.Job.Society, Config.Job.Society, Config.Job.Society, {type = 'public'})

ESX.RegisterServerCallback('th-brugtvogn:getDB', function(src, cb)
    local table = MySQL.query.await('SELECT model, nummerplade, pris, displayed FROM th_brugtvogn_lager')    
    cb(table)
end)

ESX.RegisterServerCallback('th-brugtvogn:GetVehicleOpportunities', function(src, cb)
    local table = MySQL.query.await('SELECT model, plate, pris, mileage, license, name FROM th_brugtvogn_buy')    
    cb(table)
end)

ESX.RegisterServerCallback('th-brugtvogn:GetDisplayedVehicles', function(source, cb)
    local table = MySQL.query.await('SELECT model, nummerplade, pris, displayed FROM th_brugtvogn_lager')
    cb(table)
end)

RegisterNetEvent('th-brugtvogn:ChangeVehicleDisplay', function(CurrentDisplay, plate)
    if not HasAccessToJob(source) then
        return
    end

    MySQL.update.await('UPDATE th_brugtvogn_lager SET displayed = ? WHERE nummerplade = ?', {
        CurrentDisplay, plate
    })
end)

RegisterNetEvent('th-brugtvogn:ChangePrice', function(NewPrice, plate)
    if not HasAccessToJob(source) then
        return
    end

    MySQL.update.await('UPDATE th_brugtvogn_lager SET pris = ? WHERE nummerplade = ?', {
        NewPrice, plate
    })

end)


RegisterNetEvent('th-brugtvogn:AddVehicleToCurrentStock', function(model, plate, price)
    MySQL.insert('INSERT INTO th_brugtvogn_lager (model, nummerplade, pris) VALUES (?, ?, ?)', {
        model, plate, price
    })

    MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = ?', {
        plate
    })
end)


ESX.RegisterServerCallback('th-brugtvogn:SellYourVehicle', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)


    local table = MySQL.Sync.fetchAll('SELECT plate, vehicle, type, mileage FROM owned_vehicles WHERE owner = ?', {
        xPlayer.identifier
    })
    cb(table)
end)

ESX.RegisterServerCallback('th-brugtvogn:GetBrugtvognPlayers', function(source, cb, navn, plate, mileage, price)

    local GetAllPlayers = ESX.GetExtendedPlayers('job', Config.Job.job)

    for _, xPlayer in pairs(GetAllPlayers) do
        local buyer = xPlayer.source
        TriggerClientEvent('th-brugtvogn:NotifyBuyer', buyer, navn, plate, mileage, price)
        cb(true)
    end 
end)

ESX.RegisterServerCallback('th-brugtvogn:getNearestPlayers', function(source, cb, closePlayer)
    if not HasAccessToJob(source) then
        return
    end

    local xPlayer = ESX.GetPlayerFromId(closePlayer)
	local players = {}

    if xPlayer.get('firstName') then
        table.insert(players, {
            source = xPlayer.source,
            identifier = xPlayer.identifier,
            name = xPlayer.name,
            firstname = xPlayer.get('firstName'),
            lastname = xPlayer.get('lastName'),
        })
    end

	cb(players)
end)

RegisterNetEvent('th-brugtvogn:AddVehicleToPlayersGarage', function(playerId, plate, vehicleProps)

    local xTarget = ESX.GetPlayerFromId(playerId)

    if not xTarget then
        return
    end

    MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (?, ?, ?)', {
         xTarget.identifier,
         plate,
         json.encode(vehicleProps)
    })

    MySQL.Async.execute('DELETE FROM th_brugtvogn_lager WHERE nummerplade = ?', {
         plate
    })

end)

RegisterNetEvent('th-brugtvogn:GetCustomerConfirm', function(playerId, seller, model, nummerplade, pris)
    local xPlayer = ESX.GetPlayerFromId(seller)
    local sellerName = xPlayer.getName()
    TriggerClientEvent('th-brugtvogn:CustomerConfirmationAlert', playerId, playerId, sellerName, model, nummerplade, pris)
end)


-- Function to check if player has access to the job
function HasAccessToJob(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if not xPlayer then
        return false
    end

    if xPlayer.job.name == Config.Job.job then
        return true
    end

    -- Probably a cheater, perfect place for a ban/log, but I'll leave that up to you
    -- DropPlayer(playerId, 'Cheating')
    print(('th-brugtvogn: %s attempted to trigger an action!'):format(xPlayer.identifier))

    return false
end