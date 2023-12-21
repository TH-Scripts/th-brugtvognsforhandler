ESX = exports["es_extended"]:getSharedObject()

function spawnCar(veh)
  local spawnedCar = false

  for _, spawnPoint in ipairs(Config.spawnPoints) do
    local spawnCoords = spawnPoint.coords
    local radius = spawnPoint.radius
    local isSpawnPointClear = ESX.Game.IsSpawnPointClear(spawnCoords, radius)

    if isSpawnPointClear then
      -- If the spawn point is clear, spawn the car using ESX's spawnVehicle function
      ESX.Game.SpawnVehicle('' .. veh .. '', spawnCoords, spawnPoint.heading, function(vehicle)
        lib.notify({
          title = 'Success',
          description = 'Køretøjet er blevet hentet fra lageret',
          type = 'success',
        })
      end)
      spawnedCar = true
      break
      -- Don't break, let it continue checking other spawn points
    end
  end

    if not spawnedCar then
      -- If all spawn points are occupied, handle as needed (e.g., inform the player)
      lib.notify({
        title = 'Fejl',
        description = 'Der er ikke plads til køretøjet',
        type = 'error',
      })
    end
end


function bydDialog()
    local input = lib.inputDialog('Byd på køretøjet', {
        {type = 'number', label = 'Pris', description = 'Angiv en pris, som du ønsker at købe køretøjet for', icon = 'hashtag'},
      })
end

local options = {}

function showcaseveh()
  ESX.TriggerServerCallback('tg-brugtvogn:showcaseVeh', function(data)
    options = {}
    for _,v in pairs(data) do
      table.insert(options, {
        title = 'NUMMERPLADE: '..v.plate.. '',
        description = 'PRISEN: ' .. v.pris .. '\n MODEL: '..v.model.. '\n KLIK FOR AT FREMVISE',
        onSelect = function()
          print("Selected vehicle:", v.model, "Plate:", v.plate)
          spawnCar(v.model)
          removeVehFromTable(v.plate)
        end
      })
    end

    lib.registerContext({
      id = 'test',
      title = 'Brugtvogn - Lager',
      options = options
    })

    lib.showContext('test')
  end)
end

function removeVehFromTable(plateToRemove)
  for i, v in ipairs(options) do
    if v.plate == plateToRemove then
      print("Removing vehicle:", v.model, "Plate:", v.plate)
      table.remove(options, i)
      break
    end
  end
end


function sellveh()
  local input = lib.inputDialog('Sælg dit køretøj', {
    {type = 'input', label = 'Nummerplade', description = 'Angiv nummerpladen på den bil du gerne vil sælge'},
    {type = 'number', label = 'Pris', description = 'Angiv prisen for dit køretøj', min = 10000, max = Config.maxPrice},
    {type = 'input', label = 'Model', description = 'Angiv bil modellen'}
  })

  TriggerServerEvent('tg-brugtvogn:sellveh', input[1], input[2], input[3])
end