Config = {}

--[[
    OFFMETA Gathering  ✅
    Forked from qb-gathering.

    📌 Quick install
    1) Drop the folder in your resources:  [resources]/offmeta-gathering
    2) Ensure it in your server.cfg:       ensure offmeta-gathering
    3) Make sure your items exist in qb-core/shared/items.lua (or your item definition file)

    ✅ Default interaction: walk near a prop and press E
    🔁 Optional: set Config.KeyInteraction.Enabled = false to use qb-target
]]

-- 📨 Notifications shown on the right side (QBCore notify)
Config.Notifications = {
    Success  = '✅ Collected %sx %s',
    Canceled = '❌ You stopped gathering'
}

-- 🎯 qb-target settings (only used when Key Interaction is disabled)
Config.TargetDistance = 2.0
Config.TargetOptions = {
    icon  = 'fas fa-hand',
    label = 'Gather'
}

-- ⌨️ Key Interaction (alternative to qb-target "eye")
-- When enabled, players can gather by pressing a key near the prop.
-- TIP: If qb-target is not running, the script will automatically fallback to key mode.
Config.KeyInteraction = {
    Enabled      = true,  -- ✅ Recommended: true
    Control      = 38,    -- 38 = INPUT_CONTEXT (E)
    KeyLabel     = 'E',
    Prompt       = '~g~[%s]~s~ %s', -- string.format(KeyLabel, TargetOptions.label)
    Distance     = 2.0,   -- meters
    FloatingText = true
}

-- 🧹 Maintenance / auto-respawn (helps if props are cleaned up by other scripts)
Config.Maintenance = {
    Enabled       = true,
    CheckInterval = 30000 -- ms (30 seconds)
}

-- 🌿 Gatherable zones
-- Add as many as you want. Each entry spawns "spawnAmount" props around "centerCoords".
-- Fields explained (with emojis 😉):
--  🧾 name           = item id (must exist in your shared items)
--  🏷️ label          = text shown to players
--  🧱 model          = prop model spawned in the world
--  🎁 rewardAmount   = min/max amount per gather
--  🎬 animation      = dict/anim used while gathering
--  ⏳ progressText   = text shown in the progressbar
--  ⌛ progressTime   = duration in ms
--  🪓 spawnAxe / ⛏️ spawnPickaxe = attach a tool prop while anim plays
--  🗺️ blip           = optional map marker
Config.Gatherables = {

    -- 🌱 Cotton
    {
        name         = 'algodao',
        label        = 'Algodão',
        model        = 'prop_cs_plant_01',
        rewardAmount = { min = 1, max = 2 },
        animation    = { dict = 'amb@prop_human_parking_meter@male@idle_a', anim = 'idle_a' },
        spawnAxe     = false,
        spawnPickaxe = false,

        centerCoords = vector3(-67.34, 1903.26, 196.21),
        spawnRange   = 25.0,
        spawnAmount  = 15,

        progressText = 'A coletar...',
        progressTime = 5000,

        blip = {
            enabled = true,
            sprite  = 468,
            color   = 5,
            scale   = 0.8,
            name    = 'Algodão'
        }
    },

    -- 🍊 Oranges
    {
        name         = 'laranjas',
        label        = 'Laranjas',
        model        = 'prop_veg_crop_orange',
        rewardAmount = { min = 1, max = 2 },
        animation    = { dict = 'amb@prop_human_parking_meter@male@idle_a', anim = 'idle_a' },
        spawnAxe     = false,
        spawnPickaxe = false,

        centerCoords = vector3(678.36, 6471.92, 30.24),
        spawnRange   = 25.0,
        spawnAmount  = 15,

        progressText = 'A coletar...',
        progressTime = 5000,

        blip = {
            enabled = true,
            sprite  = 468,
            color   = 5,
            scale   = 0.8,
            name    = 'Laranjas'
        }
    },

    --[[
    -- 🪵 Wood (axe example)
    {
        name         = 'wood',
        label        = 'Madeira',
        model        = 'prop_tree_log_02',
        rewardAmount = { min = 1, max = 3 },
        animation    = { dict = 'melee@large_wpn@streamed_core', anim = 'ground_attack_on_spot' },
        spawnAxe     = true,
        spawnPickaxe = false,

        centerCoords = vector3(-642.03, 5478.71, 52.77),
        spawnRange   = 50.0,
        spawnAmount  = 20,

        progressText = 'Collecting...',
        progressTime = 9000,

        blip = {
            enabled = true,
            sprite  = 468,
            color   = 5,
            scale   = 0.8,
            name    = 'Madeira'
        }
    },

    -- ⛏️ Coal (pickaxe example)
    {
        name         = 'carvao',
        label        = 'Carvão',
        model        = 'prop_rock_4_d',
        rewardAmount = { min = 2, max = 3 },
        animation    = { dict = 'melee@large_wpn@streamed_core', anim = 'ground_attack_on_spot' },
        spawnAxe     = false,
        spawnPickaxe = true,

        centerCoords = vector3(2954.56, 2794.35, 40.82),
        spawnRange   = 30.0,
        spawnAmount  = 10,

        progressText = 'Mining...',
        progressTime = 15000,

        blip = {
            enabled = true,
            sprite  = 468,
            color   = 5,
            scale   = 0.8,
            name    = 'Carvão'
        }
    },
    ]]
}
