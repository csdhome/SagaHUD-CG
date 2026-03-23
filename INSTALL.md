# SagaHUD v4.1.8-CG — The Consortium Edition

A modular flight HUD with autopilot, fuel monitoring, radar, warp tracking, AGG support, and a full in-game menu system. Customized for The Consortium MyDU server.

## Installation

SagaHUD requires the main script file plus several external Lua modules that are loaded at runtime.

### Step 1: Copy External Lua Files

Copy these 5 files to your DU autoconf directory:

```
sagatankdata.lua    -->  <DU Install>/Game/data/lua/autoconf/custom/sagatankdata.lua
sagastaticsvg.lua   -->  <DU Install>/Game/data/lua/autoconf/custom/sagastaticsvg.lua
sagastaticcss.lua   -->  <DU Install>/Game/data/lua/autoconf/custom/sagastaticcss.lua
sagamenusystem.lua  -->  <DU Install>/Game/data/lua/autoconf/custom/sagamenusystem.lua
atlas.lua           -->  <DU Install>/Game/data/lua/autoconf/custom/atlas.lua
```

The atlas file is located at: `FlightHuds/AtlasFile-main/AtlasFile-main/atlas.lua`

All four `saga*.lua` files are in this directory alongside this INSTALL.md.

### Step 2: Install the HUD (Choose One Method)

#### Method A: Autoconf (Recommended)

Copy the conf file:

```
SagaHud.conf  -->  <DU Install>/Game/data/lua/autoconf/custom/SagaHud.conf
```

Then in-game:
1. Right-click your cockpit or command seat
2. Go to **Advanced** > **Select autoconf**
3. Choose **SagaHUD 4.1.8-CG**

#### Method B: JSON Paste

1. Open `out/release/Saga.json` in a text editor
2. Select all and copy to clipboard
3. In-game, right-click your cockpit or command seat
4. Go to **Advanced** > **Paste Lua configuration from clipboard**

### Required Linked Elements

- **Core Unit** (required — must be linked to the control unit)
- Databank (for persistent settings — optional but recommended)
- Radar (optional)

### Default Install Path

The typical DU install path is:
```
C:\ProgramData\Dual Universe\Game\data\lua\autoconf\custom\
```

Your autoconf directory should look like this after installation:
```
autoconf/custom/
  SagaHud.conf
  atlas.lua
  sagatankdata.lua
  sagastaticsvg.lua
  sagastaticcss.lua
  sagamenusystem.lua
```

### Consortium-Specific Features

- All Consortium planets and moons in the atlas
- Fuel tank support for XS through XXL sizes, tiers T1-T5, Standard/Optimised/Gravity-Inverted
- Speed limits set to 50,000 km/h (server max)
- Safe zone data read from game API (automatic)
- Warp data read from game API (automatic)

### Troubleshooting

If you see error messages like `[E] sagatankdata not found`:
- Make sure all four `saga*.lua` files are in `autoconf/custom/`
- File names are case-sensitive — use the exact names listed above
- The HUD will still function with default/missing data but fuel readings may be inaccurate
