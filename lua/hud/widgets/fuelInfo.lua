
Widgets.fuelInfo = Widget:new{class = 'fuelInfo'}
function Widgets.fuelInfo:build()
    local strings = {}
    strings[#strings+1] = '<b>Fuel Tanks</b>'

    local fuelColors = {
        atmo = '#00dd00',
        space = '#00aaff',
        rocket = '#aa44ff'
    }

    for _, fuelType in ipairs({'atmo', 'space', 'rocket'}) do
        local tanks = fuels[fuelType]
        if tanks and #tanks > 0 then
            strings[#strings+1] = ''
            for i, tank in ipairs(tanks) do
                local pct = tank.percent or 0
                local color = fuelColors[fuelType]
                local barColor = color
                if pct <= 20 then barColor = '#ff4400'
                elseif pct <= 50 then barColor = '#ffaa00' end

                local timeStr = ''
                if tank.timeLeft and tank.timeLeft > 0 then
                    local t = tank.timeLeft
                    local days = math.floor(t / 86400)
                    local hours = math.floor((t % 86400) / 3600)
                    local mins = math.floor((t % 3600) / 60)
                    if days > 0 then
                        timeStr = ' (' .. days .. 'd ' .. hours .. 'h ' .. mins .. 'm)'
                    elseif hours > 0 then
                        timeStr = ' (' .. hours .. 'h ' .. mins .. 'm)'
                    else
                        local secs = math.floor(t % 60)
                        timeStr = ' (' .. mins .. 'm ' .. secs .. 's)'
                    end
                end

                local label = fuelType:upper() .. ' ' .. i .. ' ~' .. pct .. '%' .. timeStr
                strings[#strings+1] = '<div style="margin-bottom:2px">'
                    .. '<div style="font-size:1.1vh;color:ivory;margin-bottom:1px">' .. label .. '</div>'
                    .. '<div style="width:100%;height:1.4vh;background:rgba(255,255,255,0.15);border-radius:2px">'
                    .. '<div style="width:' .. math.min(pct,100) .. '%;height:100%;background:' .. barColor .. ';border-radius:2px"></div>'
                    .. '</div></div>'
            end
        end
    end

    self.rowCount = #strings + 8
    return table.concat(strings)
end