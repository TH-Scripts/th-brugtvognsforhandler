function FindVehicleByPlate(plate)
    for _, displayedVehicle in ipairs(DisplayedVehicles) do
        displayedVehicle[2] = string.gsub(displayedVehicle[2], " ", "")  -- Remove spaces
        if displayedVehicle[2] == plate then
            return displayedVehicle
        end
    end
end

exports.ox_target:addSphereZone({
    coords = vec3(Config.Job.JobMenu),
    radius = 1,
    debug = drawZones,
    options = {
        {
            icon = 'fa-solid fa-bars',
            label = 'Åben menu',
            groups = Config.Job.job,
            onSelect = function()
                MainMenu()
            end
        }
    }
})

exports.ox_target:addSphereZone({
    coords = vec3(Config.Job.NPC.target),
    radius = 1,
    debug = drawZones,
    options = {
        {
            icon = 'fa-solid fa-tag',
            label = 'Sælg dit køretøj',
            onSelect = function()
                SellYourVehicle()
            end
        }
    }
})


for _, spawnPoint in ipairs(Config.spawnPoints) do
    exports.ox_target:addSphereZone({
        coords = spawnPoint.coords,
        radius = 1,
        debug = drawZones,
        options = {
            {
                icon = 'fa-solid fa-circle-info',
                label = 'Informationer',
                onSelect = function()
                    local vehicleInDirection = ESX.Game.GetVehicleInDirection()
                    local targetPlate = GetVehicleNumberPlateText(vehicleInDirection)
                    targetPlate = string.gsub(targetPlate, " ", "")  -- Remove spaces
                    
                    local VehicleData = FindVehicleByPlate(targetPlate)
                    
                    if VehicleData then
                        local model, plate, price = VehicleData[1], VehicleData[2], VehicleData[3]
                        StartUI(model, plate, price)
                    end
                end
            },
        }
    })
end
