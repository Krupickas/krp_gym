fx_version 'adamant'

Author 'Krupickas'

game 'gta5'

version '3.0'

lua54 'yes'

ui_page 'html/index.html'

	files {
		'html/index.html',
		'html/script.js',
		'html/styles.css',
	  'locales/*.json'
}


shared_script {
  '@ox_lib/init.lua',
}

client_scripts {
  'Config.lua',
  'client/cl_utils.lua',
  'client/*.lua'
}
server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'Config.lua',
  'server/sv_utils.lua',
  'server/server.lua'
}