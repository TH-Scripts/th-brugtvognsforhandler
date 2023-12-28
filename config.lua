Config = {}

Config.Job = {
    job = 'brugtvogn',

    society = 'society_brugtvogn',

    JobMenu = vec3(1230.8013, 2738.7827, 37.9634),

    NPC = {
        spawn = vec3(1224.7972, 2733.6318, 37.9767-1),
        target = vec3(1224.7972, 2733.6318, 37.9767),
        heading = 171.0834,
        hashmodel = 'a_f_m_eastsa_01'
    },
}

Config.VehicleMaxPrice = 10000000
Config.VehicleMinPrice = 1000

-- Notify styles
Config.Notify = {
    position = 'right-top',
    Style = {
        backgroundColor = '#141517',
        color = '#C1C2C5',
        ['.description'] = {
        color = '#909296'
        }
    },
}

Config.Blip = {
    pos = vec3(1224.6377, 2733.5757, 37.9767),
    sprite = 605,
    scale = 0.8,
    display = 4,
    text = 'Brugtvognsforhandler'
}

Config.spawnPoints = {
    {coords = vector3(1234.5754, 2712.5139, 38.0060), heading = 86.6078, radius = 6},
    {coords = vector3(1216.7134, 2712.4197, 38.0060), heading = 268.3345, radius = 6}
}

Config.SpawnSoldVehicle = {
    {coords = vector3(1247.0443, 2714.3398, 38.0060), heading =173.9332, radius = 3},
}