local spawnped = false
local isBoss = nil

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if job.name == Config.Job.job then
        if job.grade_name == 'boss' then
            isBoss = false
        else
            isBoss = true
        end
    end
end)

function MainMenu()
  lib.registerContext({
      id = 'brugtvogn_menu',
      title = 'Hoved menu',
      options = {
      {
          title = 'Køretøjer',
          description = 'Se forskellige handlinger ift. lageret',
          icon = 'car',
          onSelect = function()
            VehicleStockOptions()
          end
      },
      {
          title = 'Bossmenu',
          description = 'Åben bossmenuen',
          icon = 'star',
          disabled = isBoss,
          onSelect = function()
            TriggerEvent('esx_society:openBossMenu', Config.Job.job, function (data, menu)
            end) 
          end
      },
      }
  })
  lib.showContext('brugtvogn_menu')
end

function VehicleStockOptions()
    lib.registerContext({
        id = 'vehiclestock_options',
        title = 'Lager muligheder',
        menu = 'brugtvogn_menu',
        onBack = function()
            MainMenu()
        end,
        options = {
        {
            title = 'Køretøjer',
            description = 'Få fremvist alle køretøjer som befinder sig i lageret',
            icon = 'bars',
            onSelect = function()
                WatchStock()
            end
        },
        {
            title = 'Fremviste køretøjer',
            description = 'Fjern køretøjer som står fremvist',
            icon = 'star',
            onSelect = function()
                ShowcasedStock()
            end
        },
        }
    })
    lib.showContext('vehiclestock_options')
end

function ChangeCarSettings(model, nummerplade, pris)
    lib.registerContext({
        id = 'vehicle_settings',
        title = 'Køretøj: '..model,
        menu = 'vehiclesinstock',
        onBack = function()
            WatchStock()
        end,
        options = {
            
        {
            title = 'Sælg køretøjet: '..model,
            description = 'Køretøjets pris: '..pris..' \nKøretøjets nummerplade: '..nummerplade..' \nTryk for at finde en køber',
            icon = 'tag',
            onSelect = function()
                local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestPlayerDistance > 3.0 then
                    notifyNoPlayers()
                else
                    getPlayers(model, nummerplade, pris)
                end
            end
        },
        {
            title = 'Nuværende pris: '..pris.. ' DKK',
            description = 'Ændre prisen på køretøjet',
            icon = 'tag',
            onSelect = function()
                local input = lib.inputDialog('Nummerplade: '..nummerplade, {
                    {type = 'number', label = 'Angiv en ny pris', icon = 'tag', required = true, min = Config.VehicleMinPrice, max = Config.VehicleMaxPrice}
                })
                if input ~= nil then
                    TriggerServerEvent('th-brugtvogn:ChangePrice', input[1], nummerplade)
                else
                    ChangeCarSettings(model, nummerplade, pris)
                end
            end
        },
        {
            title = 'Fremvis: '..nummerplade,
            description = 'Fremvis køretøjet på en ledig plads',
            icon = 'eye',
            onSelect = function()
                SpawnVehicle(model, nummerplade, pris, model)
            end
        },
        }
    })
    lib.showContext('vehicle_settings')
end

function SellYourVehicle()
    ESX.TriggerServerCallback('th-brugtvogn:SellYourVehicle', function(data)
        local elements = {}
        if next(data) ~= nil then
            for _,v in pairs(data) do 
                v.vehicle = json.decode(v.vehicle) 
                local vehicleHash = v.vehicle.model
                local HashKey = string.lower(GetDisplayNameFromVehicleModel(vehicleHash))
                table.insert(elements, {
                    title = 'Køretøj: '..HashKey,
                    description = 'Nummerplade: '..v.plate..' \nBiltype: '..v.type..' \nKlik for at sælge dit køretøj',
                    icon = 'car',
                    onSelect = function()
                        OpenSellVehicleDialogue(HashKey, v.plate)
                    end
                })

                lib.registerContext({
                    id = 'personal_vehicles',
                    title = 'Køretøjsliste',
                    options = elements
                })
        
                lib.showContext('personal_vehicles')
            end
        else
            notifyBilIngenFundet()
        end
    end)
end

function OpenSellVehicleDialogue(navn, plate)
    local CanSellVehicle = false
    local input = lib.inputDialog('Køretøjet: '..navn, {
        {type = 'number', label = 'Pris', description = 'Angiv en pris på '..plate, icon = tag, max = Config.VehicleMaxPrice, min = Config.VehicleMinPrice},
        {type = 'checkbox', label = 'Er du sikker?', required = true},
        {type = 'date', label = 'Dato', icon = 'calendar-days', format = 'DD/MM/YYYY', default = true, disabled = true, returnString = true},
    })

    if input == nil then
        return
    end

    local alert = lib.alertDialog({
        header = 'Salg af: '..navn,
        content = 'Ønsker du at sælge køretøjet for '..input[1]..' DKK \n\nKøretøjets nummerplade er: '..plate,
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Ja!',
            cancel = 'Nej, behold bilen'
        }
    })

    if alert == 'confirm' then
        CanSellVehicle = true
        ESX.TriggerServerCallback('th-brugtvogn:GetBrugtvognPlayers', function(data)
        end, navn, plate, input[1])
    else
        return
    end

end

function getPlayers(model, nummerplade, pris)
    local closestplayer = ESX.Game.GetClosestPlayer()
    local closePlayer = GetPlayerServerId(closestplayer)
    local seller = GetPlayerServerId(PlayerId())

    ESX.TriggerServerCallback('th-brugtvogn:getNearestPlayers', function(players)
        local elements = {}
        for i=1, #players, 1 do
            if players[i].name ~= GetPlayerName(PlayerId()) then
                local playerId = players[i].source
                local firstName = players[i].firstname
                local lastName = players[i].lastname
                table.insert(elements, {
                    title = 'Navn: ' .. players[i].firstname..' '..players[i].lastname,
                    description = 'Tryk her for at sælge vedkommende '..nummerplade,
                    icon = 'user',
                    onSelect = function()
                      SellEventFunction(playerId, firstName, lastName, seller, model, nummerplade, pris)
                  end
                })
            end
        end


        lib.registerContext({
            id = 'sellveh_menu',
            title = 'Sælg: '..model,
            menu = 'main_menu',
            onBack = function()
            end,
            options = elements,
        })
        lib.showContext('sellveh_menu')
    end, closePlayer)
end

function SellEventFunction(playerId, firstName, lastName, seller, model, nummerplade, pris)
    local alert = lib.alertDialog({
        header = 'Salg af modellen '..model,
        content = 'Sælg køretøjet '..model..' med nummerpladen '..nummerplade.. '\n\nPersonen som vil modtage bilen er '..firstName..' '..lastName..'\n\nSalgsprisen for kørtøjet er '..pris..' DKK',
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Sælg bilen til '..firstName..' '..lastName,
            cancel = 'Fortryd'
        }
    })

    if alert == 'confirm' then
        TriggerServerEvent('th-brugtvogn:GetCustomerConfirm', playerId, seller, model, nummerplade, pris)
    else
        return
    end  
end

RegisterNetEvent('th-brugtvogn:NotifyBuyer', function(navn, plate, price, target)
    local alert = lib.alertDialog({
        header = 'Køb af køretøj!',
        content = 'Ønsker du at købe bil modellen '..navn..' med nummerpladen '..plate..'\n\n Prisen for køretøjet er '..price..' DKK' ,
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Ja, køb '..navn,
            cancel = 'Afbryd købet'
        }
    })    

    if alert == 'confirm' then
        ESX.TriggerServerCallback('th-brugtvogn:CheckSocietyBalance', function(money)
            if money then
                TriggerServerEvent('th-brugtvogn:AddVehicleToCurrentStock', navn, plate, price, target)
                notifyVehicleBoughtFromEmployee(navn, plate, price)
            else
                notifyNoMoney()
            end
        end, price)
    else
        return
    end
end)

RegisterNetEvent('th-brugtvogn:CustomerConfirmationAlert', function(playerId, sellerName, model, nummerplade, pris)
    local alert = lib.alertDialog({
        header = 'Køb af '..model..'!',
        content = 'Ønsker du at købe bil modellen '..model..' med nummerpladen '..nummerplade..'\n\nPrisen for køretøjet er: '..pris..' DKK \n\nMedarbejder: '..sellerName,
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Ja, køb '..model,
            cancel = 'Afbryd købet'
        }
    }) 

    if alert == 'confirm' then
        ESX.TriggerServerCallback('th-brugtvogn:RemoveMoneyFromBuyer', function(money)
            if money then
                SpawnSoldVehicle(playerId, model, nummerplade)
                notifyVehicleBought(model, nummerplade)
            else
                notifyNoMoney()
            end
        end, pris)
    else
        return
    end
end)

RegisterNetEvent('th-brugtvogn:NotifySellerOfVehiclePurchase', function(model, plate, price)
    notifyVehicleSoldFromPlayer(model, plate, price)
end)

CreateThread(function()
	local forhandler = AddBlipForCoord(Config.Blip.pos) -- ændrer disse koordinater

	SetBlipSprite (forhandler, Config.Blip.sprite)
	SetBlipDisplay(forhandler, Config.Blip.display)
	SetBlipScale  (forhandler, Config.Blip.scale)
	SetBlipAsShortRange(forhandler, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(Config.Blip.text)
	EndTextCommandSetBlipName(forhandler)
end)

Citizen.CreateThread(function()
    while true do
        if spawnped == false then
            spawnped = true
            RequestModel(GetHashKey(Config.Job.NPC.hashmodel))
            while not HasModelLoaded(GetHashKey(Config.Job.NPC.hashmodel)) do
                Wait(1)
            end

            local ped = CreatePed(4, GetHashKey(Config.Job.NPC.hashmodel), Config.Job.NPC.spawn, Config.Job.NPC.heading, false, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
        end
        Citizen.Wait(10000)
    end
end)