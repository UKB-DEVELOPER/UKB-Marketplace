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

ui_page 'interface/index.html'

files {
	'interface/index.html',
	'interface/index.js',
	'interface/index.css',
	'interface/assets/image/*.png',
	'interface/assets/image/*.jpg',
	'interface/assets/sounds/*.wav',
	'interface/assets/sounds/*.ogg',
}

dependency 'esx_inventoryhud'


