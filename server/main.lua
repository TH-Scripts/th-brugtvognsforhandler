ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('tg-brugtvogn:sellveh')
AddEventHandler('tg-brugtvogn:sellveh', function(plate, price, model)
    local vehicles = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles', {})
    print(plate)
    for k,v in pairs(vehicles) do
        if plate == v.plate then
            MySQL.insert.await('INSERT INTO brugtvogn_lager (plate, model, pris) VALUES (?, ?, ?)', {
                plate, model, price
            })
        else
            return
        end
    end
end)

ESX.RegisterServerCallback('tg-brugtvogn:showcaseVeh', function(src, cb)
    local table = MySQL.Sync.fetchAll('SELECT plate,model,pris FROM brugtvogn_lager')
    
    cb(table)
end)