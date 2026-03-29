-- SVG utility - only gradient() is used by static_css.lua

function gradient(id, data, vertical)
    local coords = ternary(vertical,'x1="0%" y1="0%" x2="0%" y2="100%"', 'x1="0%" y1="0%" x2="100%" y2="0%"')
    local def = '<linearGradient id="'..id..'"'..coords..'>'
    local stopKeys = table.keys(data)
    table.sort(stopKeys)
    for _,k in ipairs(stopKeys) do
        local stop, val = k, data[k]
        local pre = '<stop offset="'..stop..'%" stop-color="'
        if type(val) == 'table' then
            val = data[k][1]
            def = def..pre..val..'" stop-opacity="'..data[k][2]..'"/>'
        else
            def = def..pre..val..'"/>'
        end
    end
    def = def..'</linearGradient>'
    return def
end
