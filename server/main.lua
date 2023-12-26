DisplayVehicles = {}

AddEventHandler('onResourceStart', function()
    local displayed = 0
    local table = MySQL.update.await('UPDATE th_brugtvogn_lager SET displayed = ? WHERE displayed = 1', {
        displayed
    })
end)

TriggerEvent('esx_society:registerSociety', Config.Job.job, Config.Job.job, Config.Job.society, Config.Job.society, Config.Job.society, {type = 'public'})

ESX.RegisterServerCallback('th-brugtvogn:getDB', function(src, cb)
    local table = MySQL.query.await('SELECT model, nummerplade, pris, displayed FROM th_brugtvogn_lager')    
    cb(table)
end)

ESX.RegisterServerCallback('th-brugtvogn:GetDisplayedVehicles', function(source, cb)
    local table = MySQL.query.await('SELECT model, nummerplade, pris, displayed FROM th_brugtvogn_lager')
    cb(table)
end)

RegisterNetEvent('th-brugtvogn:SaveDisplayedVehicles', function(DisplayedVehicles)
    DisplayVehicles = DisplayedVehicles
    TriggerClientEvent('th-brugtvogn:GetDisplayedVehicles', -1, DisplayVehicles)
end)

RegisterNetEvent('th-brugtvogn:ChangeVehicleDisplay', function(CurrentDisplay, plate, displayedVehicles)
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


RegisterNetEvent('th-brugtvogn:AddVehicleToCurrentStock', function(model, plate, price, target)
    local xTarget = ESX.GetPlayerFromId(target)
    
    if not xTarget then
        return 
    end

    xTarget.addAccountMoney('bank', price)

    MySQL.insert('INSERT INTO th_brugtvogn_lager (model, nummerplade, pris) VALUES (?, ?, ?)', {
        model, plate, price
    })

    MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = ?', {
        plate
    })

    TriggerClientEvent('th-brugtvogn:NotifySellerOfVehiclePurchase', target, model, plate, price)


end)


ESX.RegisterServerCallback('th-brugtvogn:SellYourVehicle', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)


    local table = MySQL.Sync.fetchAll('SELECT plate, vehicle, type FROM owned_vehicles WHERE owner = ?', {
        xPlayer.identifier
    })
    cb(table)
end)

ESX.RegisterServerCallback('th-brugtvogn:GetBrugtvognPlayers', function(source, cb, navn, plate, price)

    local xTarget = source
    
    local GetAllPlayers = ESX.GetExtendedPlayers('job', Config.Job.job)

    for _, xPlayer in pairs(GetAllPlayers) do
        local buyer = xPlayer.source
        TriggerClientEvent('th-brugtvogn:NotifyBuyer', buyer, navn, plate, price, xTarget)
        cb(true)
    end 
end)

ESX.RegisterServerCallback('th-brugtvogn:CheckSocietyBalance', function(source, cb, amount)
    TriggerEvent('esx_addonaccount:getSharedAccount', Config.Job.society, function(account)
        if account.money >= amount then
            account.removeMoney(amount)
            cb(true)
        else
            cb(false)
        end
    end)
end)


ESX.RegisterServerCallback('th-brugtvogn:RemoveMoneyFromBuyer', function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    local PlayerBank = xPlayer.getAccount('bank')

    if PlayerBank.money >= amount then
        TriggerEvent('esx_addonaccount:getSharedAccount', Config.Job.society, function(account)
            account.addMoney(amount)
        end)
        xPlayer.removeAccountMoney('bank', amount)
        cb(true)
    else
        cb(false)
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