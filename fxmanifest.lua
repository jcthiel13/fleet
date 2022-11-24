fx_version 'cerulean'
game 'gta5'

author 'xXxTHE LAWxXx97'
description 'A resource for restricting your fleet to certain vehicles with loads of detailed options'
version '0.0.1'

client_scripts {
    '@menuv/menuv.lua',
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
    '@mysql-async/lib/MySQL.lua',
}

shared_scripts {
    'config.lua'
}

dependencies {
    'menuv'
}

--[[exports{
    'test',
}]]