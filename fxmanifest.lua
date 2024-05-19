fx_version 'adamant'
game 'gta5'

description 'UKB-Marketplace'

version '1.10.1'

server_scripts {
	'Config/config.shop.lua',
	'Config/config.base.lua',
	'Source/server/server.lua'
}

client_scripts {
	'Config/config.shop.lua',
	'Config/config.base.lua',
	'Source/client/client.lua'
}

ui_page 'http://localhost:5173/'

files {
	'interface/index.html',
	'interface/*',
	'interface/public/*'
}

dependency 'esx_inventoryhud'


