fx_version 'cerulean'
game 'gta5'

--[[
    OFFMETA Gathering
    Forked from: qb-gathering (credit to original authors)
    Improvements: key-based "E" interaction, optional qb-target, tool props (pickaxe/axe), and cleaner UX.
]]

author 'OFFMETA (fork of qb-gathering)'
description 'QBCore gathering / harvesting resource (key press or qb-target)'
version '1.1.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'qb-core',
    'progressbar'
    -- qb-target is optional (only needed if you disable Key Interaction)
}
