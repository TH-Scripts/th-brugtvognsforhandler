function notifyTomtLager()
    lib.notify({
        id = 'biler2',
        title = 'Lager tomt',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'list',
        iconColor = '#C53030'
    })
end

function notifyBilHentet(plate)
    lib.notify({
        id = 'biler2',
        title = 'Nummerpladen '..plate.. ' er blevet fremvist',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'circle-check',
        iconColor = '#0afc12'
    })
end

function notifyBilIkkePlads()
    lib.notify({
        id = 'biler2',
        title = 'Ikke plads',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'arrows-left-right',
        iconColor = '#C53030'
    })
end

function notifyBilIngenFremvist()
    lib.notify({
        id = 'biler2',
        title = 'Ingen fremviste køretøjet',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'circle-xmark',
        iconColor = '#C53030'
    })
end

function notifyBilIngenFundet()
    lib.notify({
        id = 'biler2',
        title = 'Ingen køretøjer fundet',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'car',
        iconColor = '#C53030'
    })
end

function notifyNoPlayers()
    lib.notify({
        id = 'biler5',
        title = 'Ingen i nærheden',
        position = Config.Notify.position,
        style = Config.Notify.Style,
        icon = 'circle-xmark',
        iconColor = '#C53030'
    })
end