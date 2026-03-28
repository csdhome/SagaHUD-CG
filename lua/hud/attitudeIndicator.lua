-- Attitude Indicator HUD element
-- Displays pitch ladders and rotating horizon line in center of screen
-- Color coded: cyan=level, yellow=slight deviation, orange=moderate, red=steep

function HUD.renderAttitudeIndicator()
    local constructData = cData
    local rpy = constructData.rpy
    local pitchDeg = utils.round(rpy.pitch, 0.1)
    local rollDeg  = utils.round(rpy.roll,  0.1)

    -- Color based on max deviation from level
    local dev = math.max(math.abs(pitchDeg), math.abs(rollDeg))
    local cr, cg, cb
    if     dev <= 2  then cr,cg,cb = 0,   229, 255  -- cyan  (level)
    elseif dev <= 10 then cr,cg,cb = 255, 210, 0    -- yellow
    elseif dev <= 25 then cr,cg,cb = 255, 120, 0    -- orange
    else                  cr,cg,cb = 255, 50,  50   -- red
    end

    local function c(a)
        return 'rgba(' .. cr .. ',' .. cg .. ',' .. cb .. ',' .. tostring(a) .. ')'
    end

    -- Layout constants (all in vw/vh units)
    local CX  = 53      -- horizontal center (vw) - offset right to clear altitude bar
    local CY  = 50      -- vertical center (vh)
    local LH  = 42      -- ladder height (vh)
    local LW  = 7       -- ladder width (vw)
    local GAP = 16      -- gap between ladders (vw)
    local PPD = LH / 36 -- pixels (vh) per degree
    local LXL = CX - GAP/2 - LW  -- left ladder left edge
    local LXR = CX + GAP/2       -- right ladder left edge
    local TOP = CY - LH/2
    local BOT = CY + LH/2
    local st  = 'position:fixed;'

    local out = {}

    -- Draw a single ladder (left or right)
    local function ladder(lx, isLeft)
        out[#out+1] = '<div style="' .. st .. 'left:' .. lx .. 'vw;top:' .. TOP .. 'vh;width:' .. LW .. 'vw;height:' .. LH .. 'vh;background:rgba(0,15,25,0.18);border:1px solid ' .. c(0.22) .. ';overflow:hidden;">'
        for deg = -90, 90, 5 do
            local y = CY + (deg - pitchDeg) * PPD
            if y >= TOP and y <= BOT then
                local major = (deg % 10 == 0)
                local tw    = major and 3.8 or 1.8
                local al    = major and 0.85 or 0.5
                local yp    = utils.round((y - TOP) / LH * 100, 0.01)
                local side  = isLeft and 'right' or 'left'
                out[#out+1] = '<div style="position:absolute;' .. side .. ':0;top:' .. yp .. '%;width:' .. tw .. 'vw;height:' .. (major and '2px' or '1.5px') .. ';background:' .. c(al) .. '"></div>'
                if major and deg ~= 0 then
                    local lbl = (deg > 0 and '+' or '') .. tostring(deg)
                    out[#out+1] = '<div style="position:absolute;' .. side .. ':' .. tw .. 'vw;top:calc(' .. yp .. '% - 1vh);font-size:1.6vh;font-weight:bold;font-family:monospace;color:' .. c(0.9) .. '">' .. lbl .. '</div>'
                end
            end
        end
        out[#out+1] = '</div>'
    end

    ladder(LXL, true)
    ladder(LXR, false)

    -- Horizon line: single container rotated around screen center
    local hy   = CY + pitchDeg * PPD
    local aw   = LW + 2.5
    local ox   = CX - GAP/2 - aw
    local totW = (GAP/2 + aw) * 2
    out[#out+1] = '<div style="' .. st .. 'left:' .. ox .. 'vw;top:' .. hy .. 'vh;width:' .. totW .. 'vw;height:3px;transform-origin:' .. (CX - ox) .. 'vw center;transform:rotate(' .. rollDeg .. 'deg);overflow:visible;">'
    out[#out+1] = '<div style="position:absolute;left:0;top:0;width:' .. aw .. 'vw;height:3px;background:' .. c(0.9) .. '"></div>'
    out[#out+1] = '<div style="position:absolute;right:0;top:0;width:' .. aw .. 'vw;height:3px;background:' .. c(0.9) .. '"></div>'
    out[#out+1] = '</div>'

    -- Aircraft symbol: fixed wing bars (no rotation)
    out[#out+1] = '<div style="' .. st .. 'left:' .. (CX-5.5) .. 'vw;top:' .. CY .. 'vh;width:4vw;height:3px;background:' .. c(0.95) .. '"></div>'
    out[#out+1] = '<div style="' .. st .. 'left:' .. (CX-1.5) .. 'vw;top:' .. CY .. 'vh;width:2px;height:1.4vh;background:' .. c(0.95) .. '"></div>'
    out[#out+1] = '<div style="' .. st .. 'left:' .. (CX+1.5) .. 'vw;top:' .. CY .. 'vh;width:4vw;height:3px;background:' .. c(0.95) .. '"></div>'
    out[#out+1] = '<div style="' .. st .. 'left:' .. (CX+1.5) .. 'vw;top:' .. CY .. 'vh;width:2px;height:1.4vh;background:' .. c(0.95) .. '"></div>'

    -- Roll pointer triangle at top (rotates with roll)
    out[#out+1] = '<div style="' .. st .. 'left:' .. (CX-0.5) .. 'vw;top:' .. (CY-LH/2-2.5) .. 'vh;width:0;height:0;border-left:0.5vw solid transparent;border-right:0.5vw solid transparent;border-top:1vh solid ' .. c(0.9) .. ';transform:rotate(' .. rollDeg .. 'deg);transform-origin:center bottom;"></div>'

    -- Pitch readout (left of left ladder)
    local pSign = pitchDeg >= 0 and '+' or ''
    out[#out+1] = '<div style="' .. st .. 'left:' .. (LXL-4.5) .. 'vw;top:' .. (CY-1) .. 'vh;font-size:1.6vh;font-weight:bold;font-family:monospace;color:' .. c(0.92) .. '">' .. pSign .. tostring(pitchDeg) .. '°</div>'

    -- Roll readout (below center)
    local rSign = rollDeg >= 0 and '+' or ''
    out[#out+1] = '<div style="' .. st .. 'left:' .. (CX-3.5) .. 'vw;top:' .. (BOT+0.8) .. 'vh;font-size:1.6vh;font-weight:bold;font-family:monospace;color:' .. c(0.92) .. '">R ' .. rSign .. tostring(rollDeg) .. '°</div>'

    return table.concat(out)
end