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

ui_page 'interface/dist/index.html'

files {
	'interface/dist/index.html',
	'interface/dist/index.js',
	'interface/dist/index.css',
	'interface/dist/assets/image/*.png',
	'interface/dist/assets/image/*.jpg',
	'interface/dist/assets/sounds/*.wav',
	'interface/dist/assets/sounds/*.ogg',
}

dependency 'esx_inventoryhud'


