fx_version 'cerulean'

game 'gta5'

dependency {
	'mysql-async'
}

client_scripts {
	'client/*.lua',
	'client/Drawables/*.lua',
	'client/Menu/*.lua',

	'menu.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}
