# SagaHUD v4.1.8-CG — The Consortium Edition

A modular flight HUD with autopilot, fuel monitoring, radar, warp tracking, AGG support, and a full in-game menu system. Customized for The Consortium MyDU server.

## Installation

SagaHUD requires the main script file plus two external Lua modules that are loaded at runtime.

### Step 1: Copy the Atlas File

Copy the atlas file to your DU autoconf directory:

```
atlas.lua  -->  <DU Install>/Game/data/lua/autoconf/custom/atlas.lua
```

Download the atlas file from: [https://github.com/csdhome/atlas-CG](https://github.com/csdhome/atlas-CG/blob/main/atlas.lua)

### Step 2: Copy the Tank Data File

Copy the tank data file to the saga subdirectory under autoconf:

```
autoconf/custom/saga/tankdata.lua  -->  <DU Install>/Game/data/lua/autoconf/custom/saga/tankdata.lua
```

Create the `saga` folder if it does not exist. This file contains fuel tank volumes and modifiers for all tank types and tiers.

### Step 3: Install the HUD (Choose One Method)

#### Method A: Autoconf (Recommended)

Copy the conf file:

```
out/release/Saga.conf  -->  <DU Install>/Game/data/lua/autoconf/custom/SagaHud.conf
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

### Linked Elements

When using **Method A (Autoconf)**, the following elements are automatically linked if present on your construct. No manual linking is required.

| Element | Required | Auto-linked | Notes |
|---------|----------|-------------|-------|
| **Core Unit** | Yes | Yes | Script will not start without it |
| **Databank** | Recommended | Manual | Must be linked manually — stores persistent settings and route data |
| **Radar** | No | Yes (all) | All linked radars detected (PVP or standard) |
| **Warp Drive** | No | Yes | Enables warp status display and activation |
| **Anti-Gravity Generator** | No | Yes | Enables AGG altitude control and status |
| **Shield Generator** | No | Yes | Enables shield status, venting, and resistance management |
| **Telemeter** | No | Yes | Improves ground distance detection |

Fuel tanks, hover engines, vertical boosters, gyros, weapons, transponders, and manual switches are detected automatically through the Core Unit and do not need to be linked to the control unit.

**Note:** If using **Method B (JSON Paste)**, you may need to manually link elements to the cockpit or command seat after pasting.

### Default Install Path

The typical DU install path is:
```
C:\ProgramData\Dual Universe\Game\data\lua\autoconf\custom\
```

Your autoconf directory should look like this after installation:
```
autoconf/custom/
  SagaHud.conf       (only if using Method A)
  atlas.lua
  saga/
    tankdata.lua
```

### Consortium-Specific Features

- All Consortium planets and moons in the atlas
- Fuel tank support for XS through XXL sizes, tiers T1-T5, Standard/Optimised/Gravity-Inverted
- Speed limits set to 50,000 km/h (server max)
- Safe zone data read from game API (automatic)
- Warp data read from game API (automatic)

### Troubleshooting

If you see error messages like `[E] atlas not found`:
- Make sure `atlas.lua` is in `autoconf/custom/`
- File names are case-sensitive — use the exact name listed above

If you see `[W] saga/tankdata.lua not found`:
- Make sure `tankdata.lua` is in `autoconf/custom/saga/`
- The HUD will still work with basic tank sizes, but tank capacities may be inaccurate for tiered or optimized tanks
