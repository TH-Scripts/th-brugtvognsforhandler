ESX = exports["es_extended"]:getSharedObject()


CreateThread(function()
    while true do
        if Config.Target then
            exports.ox_target:addSphereZone({
                coords = vec3(Config.Demo.Target),
                radius = 1,
                debug = drawZones,
                options = {
                    {
                        icon = 'fa-solid fa-eye',
                        label = 'Fremvis et køretøj',
                        -- groups = 'brugtvogn',
                        onSelect = function()
                            showcaseveh()
                        end
                    },
                    {
                        icon = 'fa-solid fa-money-bill',
                        label = 'Sælg et køretøj',
                        onSelect = function()
                            sellveh()
                        end
                    }
                }
            })
            break
        end

        if Config.Menu then
            --if ESX.PlayerData.Job == 'brugtvogn' then
                if IsControlPressed(0, 38) then
                    lib.showContext('brugtvogn_menu')
                end
            --end
        end
        Wait(100)
    end
end)

lib.registerContext({
    id = 'brugtvogn_menu',
    title = 'Brugtvogns menu',
    options = {
      {
        title = 'Byd på køretøjet',
        description = 'Byd på et køretøj, ejet af en spiller',
        icon = 'dollar',
        onSelect = function()
            print('veh in direction med input')
        end
      },
    }
  })

  exports.ox_target:addGlobalVehicle({
    {
        icon = 'fa-solid fa-car',
        label = 'Byd på køretøjet',
        -- groups = 'brugtvogn',
        onSelect = function()
            print('byd input dialog')
        end
    }
})