CreateThread(function()
	local forhandler = AddBlipForCoord(Config.Blip.pos) -- ændrer disse koordinater

	SetBlipSprite (forhandler, Config.Blip.sprite)
	SetBlipDisplay(forhandler, Config.Blip.display)
	SetBlipScale  (forhandler, Config.Blip.scale)
	SetBlipAsShortRange(forhandler, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName('Brugtvognsforhandler')
	EndTextCommandSetBlipName(forhandler)
end)
        