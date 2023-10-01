name "Jim-Recycle"
author "Jimathy"
version "v2.7.2"
description "Recycling Script By Jimathy"
fx_version "cerulean"
game "gta5"
this_is_a_map 'yes'
lua54 'yes'

shared_scripts { 'config.lua', 'shared/*.lua', 'locales/*.lua' }
client_scripts { '@PolyZone/client.lua', '@PolyZone/BoxZone.lua', '@PolyZone/EntityZone.lua', '@PolyZone/CircleZone.lua', '@PolyZone/ComboZone.lua', 'client/*.lua', }
server_scripts { 'server/*.lua' }