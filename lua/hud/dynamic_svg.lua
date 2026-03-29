-- Dynamic SVG - templates loaded from autoconf/custom/saga/hud_templates.lua
_hudTpl = nil
local ok, tplData = pcall(require, "autoconf/custom/saga/hud_templates")
if ok and tplData then
    _hudTpl = tplData
else
    system.print("[W] saga/hud_templates.lua not found")
    _hudTpl = {}
end

function dynamicSVG()
    local umap, uround = utils.map, utils.round
    local gCache, cD = globals, cData
    local conSpd, maxSpd = 0, 0
    local speedFill = 0
    local rColor, gColor, bColor = 150, 150, 150
    local curThrottle = cD.curThrottle
    local maxThrottle, throttleFill = 100, 0
    local curAlt, maxAlt = 0, 0
    local altFill = 0
    local tMode = 'Throttle'
    local trgtDistance = ''
    local sfmt = string.format

    if cD.position ~= nil and AutoPilot.target ~= nil then
        trgtDistance = printDistance((round2(vector.dist(AutoPilot.target, cD.position), 2)), true)
    end

    if cD.constructSpeed ~= nil then
        conSpd = round2((ship.landingMode or ship.vertical) and cD.zSpeedKPH or cD.speedKph, 1)
        if cD.inAtmo then
            maxSpd = math.ceil(uround(cD.burnSpeedKph))
        else
            maxSpd = math.ceil(uround(cD.maxSpeed * 3.6))
        end
        if conSpd ~= 0 and maxSpd ~= 0 then
            speedFill = clamp(conSpd / maxSpd * 200, 0, 200)
            rColor = uround(umap(clamp(speedFill, 170, 200), 170, 200, 150, 255))
            gColor = uround(umap(clamp(speedFill, 170, 200), 170, 200, 150, 40))
            bColor = uround(umap(clamp(speedFill, 170, 200), 170, 200, 150, 0))
        end
        if controlMode() == 'travel' then
            throttleFill = 200 * (abs(curThrottle) / 100)
        else
            if conSpd <= 1000 then maxThrottle = 1000
            elseif conSpd <= 5000 then maxThrottle = 5000
            elseif conSpd <= 10000 then maxThrottle = 10000
            elseif conSpd <= 20000 then maxThrottle = 20000
            else maxThrottle = 50000 end
            curThrottle = curThrottle / 100
            throttleFill = clamp(abs(curThrottle) / maxThrottle * 200, 0, 200)
        end
        if cD.body then
            curAlt, maxAlt = getAltitude(), 200000
            if cD.body and cD.inAtmo then
                maxAlt = uround(cD.body.atmoAltitude)
                altFill = clamp(curAlt / maxAlt * 200, 0, 200)
            elseif cD.body and cD.body.hasAtmosphere and gCache.collision ~= nil and curAlt <= maxAlt then
                altFill = clamp(((curAlt - cD.body.atmoAltitude) / maxAlt) * 200, 0, 200)
            elseif curAlt <= maxAlt then
                altFill = clamp((curAlt / maxAlt) * 200, 0, 200)
            end
        end
        tMode = 'Throttle'
    end

    local fnt = 'Bank'
    HUD.dynamicSVG = {
        targetReticle2 = _hudTpl.targetReticle2 and sfmt(_hudTpl.targetReticle2, trgtDistance) or '',
        speedBar = _hudTpl.speedBar and sfmt(_hudTpl.speedBar, speedFill, tonumber(rColor), tonumber(gColor), tonumber(bColor), fnt, conSpd, fnt, fnt, maxSpd) or '',
        throttleBar = _hudTpl.throttleBar and sfmt(_hudTpl.throttleBar, throttleFill, fnt, uround(curThrottle), fnt, tMode, fnt, maxThrottle) or '',
        altitudeBar = _hudTpl.altitudeBar and sfmt(_hudTpl.altitudeBar, altFill, fnt, curAlt, fnt, fnt, maxAlt) or ''
    }
end
