function openMenu() {
    $('.container').show();
}

function closeMenu() {
    $('.container').hide();
}

window.addEventListener('message', function (event) {
    const item = event.data;
    const modelElement = $('.model-h1');
    const priceElement = $('.price-h1');
    const plateElement = $('.plate-h1');
    const vehicleImage = $('.vehicle-image');

    if (item.display == true) {
        openMenu();
    }

    if (item.display == false) {
        closeMenu();
    }

    if (modelElement.length > 0) {
        modelElement.html('Model: ' + item.TargetVehicleModel)
    }

    if (plateElement.length > 0) {
        plateElement.html('Nummerplade: ' + item.TargetVehiclePlate)
    }

    if (priceElement.length > 0) {
        priceElement.html('Pris: ' + item.TargetVehiclePrice + ' DKK')
    }

    if (vehicleImage.length > 0) {
        const imagePath = 'img/' + item.TargetVehicleModel + '.png';
        vehicleImage.attr('src', imagePath);
    }
})


$(document).on('keyup', function (data) {
    if (data.which == 27) {
        closeMenu();
        $.post('https://th-brugtvognsforhandler/exit', JSON.stringify({}));
    }
});

$('.btn-close').click(function() {
    closeMenu();
    $.post('https://th-brugtvognsforhandler/exit', JSON.stringify({}));
})