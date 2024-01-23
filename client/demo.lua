DisplayedVehicles = {}

function SpawnVehicle(veh, plate, price, model)
    local spawnedCar = false
  
    for _, spawnPoint in ipairs(Config.spawnPoints) do
        local spawnCoords = spawnPoint.coords
        local radius = spawnPoint.radius
        local isSpawnPointClear = ESX.Game.IsSpawnPointClear(spawnCoords, radius)
        local display = 1
  
        if isSpawnPointClear then
            ESX.Game.SpawnVehicle(veh, spawnCoords, spawnPoint.heading, function(vehicle)
                SetVehicleNumberPlateText(vehicle, plate)
                notifyBilHentet(plate)
                FreezeEntityPosition(vehicle, true)
                SetVehicleDoorsLocked(vehicle, 2)
                local VehicleData = {
                    model,
                    plate,
                    price
                }
                table.insert(DisplayedVehicles, VehicleData)
                TriggerServerEvent('th-brugtvogn:SaveDisplayedVehicles', DisplayedVehicles)
                TriggerServerEvent('th-brugtvogn:ChangeVehicleDisplay', display, plate)
            end)       
            spawnedCar = true
            break
        end
    end

    if not spawnedCar then
        notifyBilIkkePlads()
    end
end


function SpawnSoldVehicle(playerId, veh, plate)
	local spawnedCar = false
  
    for _, spawnPoint in ipairs(Config.SpawnSoldVehicle) do
        local spawnCoords = spawnPoint.coords
        local radius = spawnPoint.radius
        local isSpawnPointClear = ESX.Game.IsSpawnPointClear(spawnCoords, radius)
  
        if isSpawnPointClear then
            ESX.Game.SpawnVehicle(veh, spawnCoords, spawnPoint.heading, function(vehicle)
                SetVehicleNumberPlateText(vehicle, plate)
				local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
				TriggerServerEvent('th-brugtvogn:AddVehicleToPlayersGarage', playerId, plate, vehicleProps)
				if Config.VehicleDoorLockSystem == 't1ger' then
					exports['t1ger_keys']:UpdateKeysToDatabase(plate, true)
				elseif Config.VehicleDoorLockSystem == 'mono_carkeys' then 
					TriggerServerEvent('mono_carkeys:CreateKey', plate)
				elseif Config.VehicleDoorLockSystem == 'custom' then 
					-- skriv eget vehiclekey export her
				end
            end)
            spawnedCar = true
            break
        end
    end

    if not spawnedCar then
		notifyBilIkkePlads()
    end
end


function RemoveVehicle(nummerplade)
    local VehiclesInArea = ESX.Game.GetVehicles()

    for _, vehicle in pairs(VehiclesInArea) do
        if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
            local currentPlate = GetVehicleNumberPlateText(vehicle)
            currentPlate = string.gsub(currentPlate, " ", "")  -- Remove spaces
            nummerplade = string.gsub(nummerplade, " ", "")  -- Remove spaces

            if currentPlate == nummerplade then
                SetEntityAsNoLongerNeeded(vehicle)
                ESX.Game.DeleteVehicle(vehicle)
                break
            end
        end
    end
end


function ShowcasedStock()
	ESX.TriggerServerCallback('th-brugtvogn:GetDisplayedVehicles', function(data)
        local VehiclesOnDisplay = {}

		if next(data) == nil then
			notifyBilIngenFundet()
		else
			for _,v in pairs(data) do
				if v.displayed == 1 then
					table.insert(VehiclesOnDisplay, {
						title = 'Fjern: '..v.nummerplade.. '',
						description = "Fremviste model: " .. v.model .. '\n Klik for at fjerne køretøjet',
						onSelect = function()
							local display = 0
							TriggerServerEvent('th-brugtvogn:ChangeVehicleDisplay', display, v.nummerplade)
							RemoveVehicle(v.nummerplade)
						end
					})

					lib.registerContext({
						id = 'vehiclesondisplay',
						title = 'Brugtvogn - Lager',
						menu = 'vehiclestock_options',
						onBack = function()
						VehicleStockOptions()
						end,
						options = VehiclesOnDisplay
						})
				
					lib.showContext('vehiclesondisplay')
				end
			end
        end
    end)
end

function WatchStock()
    ESX.TriggerServerCallback('th-brugtvogn:getDB', function(data)
        local VehiclesInStock = {}
		if next(data) == nil then
			notifyBilIngenFundet()
		else
			for _,v in pairs(data) do
				if v.displayed == 0 then
					table.insert(VehiclesInStock, {
						title = 'NUMMERPLADE: '..v.nummerplade.. '',
						description = "Køretøjet's pris: " .. v.pris .. " DKK \n Køretøjet's model: "..v.model.. '\n Klik for at tilgå forskellige handlinger',
						onSelect = function()
							ChangeCarSettings(v.model, v.nummerplade, v.pris)
						end
					})

					lib.registerContext({
						id = 'vehiclesinstock',
						title = 'Brugtvogn - Lager',
						menu = 'vehiclestock_options',
						onBack = function()
							VehicleStockOptions()
						end,
						options = VehiclesInStock
						})
				
					lib.showContext('vehiclesinstock')
				end
			end
        end
    end)
end
