fx_version 'cerulean'

game 'gta5'
description 'Brugtvogn'
version '1.10.2'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    '@es_extended/imports.lua'
}

server_scripts {
	'server/*',
    '@oxmysql/lib/MySQL.lua'
}

client_scripts {
    'client/*'
}

ui_page { 'ui/index.html' }

files { 'ui/index.html', 'ui/index.css', 'ui/index.js', 'ui/debounce.min.js', 'ui/img/*'}
