_landingCompleted = false
function syncToG()
    _G.cData = cData; _G.links = links; _G.globals = globals
    _G.inputs = inputs; _G.ship = ship; _G.brakeCtrl = brakeCtrl
    _G.sameBody = sameBody; _G.targetAngularVelocity = targetAngularVelocity
end
function onSystemFlush()
	if not links or links.core == nil or construct == nil then return end
	cData = getConstructData(construct, links.core)
	syncToG()
    if globals.maneuverMode then
        ship.apply(cData)
    else
	    applyShipInputs()
    end
    -- Airless body: navCom ground stabilization handles vertical boosters
    if not cData.inAtmo and cData.nearPlanet then
        if ship.takeoff then
            -- Takeoff: complete when clearly off the ground
            local airborne = (cData.GrndDist and cData.GrndDist > 5) or
                (not cData.GrndDist and cData.speedKph > 1)
            if airborne then
                ship.takeoff = false
                inputs.brake = 0
                inputs.brakeLock = false
                inputs.up = false
                inputs.down = false
                -- Zero throttle to prevent residual engine commands from firing rockets
                setThrottle()
                P('[I] Takeoff complete')
            end
        elseif (ship.landingMode or AutoPilot.landingMode) and not globals.maneuverMode then
            -- Airless landing: complete when on the ground
            if cData.GrndDist and cData.GrndDist < 1 and cData.speedKph < 2 then
                ship.landingMode = false
                AutoPilot.landingMode = false
                navCom:deactivateGroundEngineAltitudeStabilization()
                inputs.brake = 1
                inputs.brakeLock = true
                inputs.up = false
                inputs.down = false
                unit.deployLandingGears()
                P('[I] Landed')
            end
        elseif cData.isLanded and cData.speedKph < 1 then
            -- Parked: deactivate ground stabilization
            navCom:deactivateGroundEngineAltitudeStabilization()
        end
    elseif not cData.inAtmo and not cData.nearPlanet then
        -- Deep space: no ground stabilization needed
        navCom:deactivateGroundEngineAltitudeStabilization()
    end
    -- Atmospheric landing completion: only when near ground and not ascending fast.
    -- Skip if already parked (isLanded) to avoid blocking takeoff.
    -- _landingCompleted flag prevents re-triggering (cleared on next G press).
    -- Atmospheric landing completion: use GrndDist directly (already AGL-adjusted).
    -- GrndDist < 1 means the ship is within 1m of its normal parking position.
    if cData.inAtmo and not cData.isLanded and not _landingCompleted
        and (AutoPilot.landingMode or ship.landingMode) then
        if cData.GrndDist and cData.GrndDist < 5 and cData.zSpeedKPH < 10 then
            ship.landingMode = false
            AutoPilot.landingMode = false
            setThrottle()
            inputs.brake = 1
            inputs.brakeLock = true
            inputs.up = false
            inputs.down = false
            unit.deployLandingGears()
            _landingCompleted = true
            P('[I] Landed')
        end
    end
    shipLandingTask(cData)
end