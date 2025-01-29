fx_version 'cerulean'
game 'gta5'

author 'AkiraaDev'
description 'Advanced Miner Job System (ESX + oxmysql)'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Reference to oxmysql
    'server.lua'
}
