# offmeta-gathering

A lightweight **QBCore** gathering/harvesting resource.

This is a fork of **qb-gathering** (credit to the original authors) with some quality-of-life improvements:

- ✅ **Key interaction (E)** by default (no qb-target required)
- 🔁 **Optional qb-target** support (toggle via config)
- ⛏️/🪓 Optional **pickaxe/axe** tool props while the animation plays
- 🧹 Optional **maintenance respawn** to recover props after entity cleanup
- 📨 Clean notifications + qb-inventory itembox

## Installation

1. Put the folder in your resources folder:
   - `[resources]/offmeta-gathering`
2. Add to `server.cfg`:
   - `ensure offmeta-gathering`
3. Make sure every configured item exists in your shared items file:
   - e.g. `qb-core/shared/items.lua`

## Config

Open `config.lua` and adjust:

- `Config.KeyInteraction.Enabled` (recommended: `true`)
- `Config.TargetOptions.label` (the text shown on prompt/target)
- `Config.Gatherables` (zones, models, rewards, animations)

## Credits

- Original concept & base: **qb-gathering**
- Fork & improvements: **OFFMETA**

## 🎬 Demo

- 🔗 Medal Video 1: https://medal.tv/pt/games/gta-v/clips/kYAD8onWOQRhNQPmn?invite=cr-MSxCZFEsNDM2NzU2NjA3&v=15
- 🔗 Medal Video 2: https://medal.tv/pt/games/gta-v/clips/kYAPQmQItpLaOwp1r?invite=cr-MSx1VlYsNDM2NzU2NjA3&v=15
