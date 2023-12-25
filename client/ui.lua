local display = false

function StartUI(TargetVehicleModel, TargetVehiclePlate, TargetVehiclePrice)
    display = true

    SendNUIMessage({
        display = true,
        TargetVehicleModel = TargetVehicleModel,
        TargetVehiclePlate = TargetVehiclePlate,
        TargetVehiclePrice = TargetVehiclePrice
    })

    ESX.SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)
end

function StopUI()
    display = false

    SendNUIMessage({
        display = false,
    })

    SetNuiFocus(false)
end

RegisterNUICallback('exit', function()
    StopUI()
end)