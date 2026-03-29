airlessDbgTimer = 0
function onSystemFlush()
	if links.core == nil or construct == nil then return end
	cData = getConstructData(construct, links.core)
	--globals.dbgTxt = '' -- only for development!
    if globals.maneuverMode then
        ship.apply(cData)
    else
	    applyShipInputs()
    end
    -- Airless body: navCom ground stabilization handles vertical boosters
    if not cData.inAtmo and cData.nearPlanet then
        -- Debug: log state every 3 seconds (not every frame)
        airlessDbgTimer = airlessDbgTimer + system.getActionUpdateDeltaTime()
        if airlessDbgTimer > 3 then
            airlessDbgTimer = 0
            local tgt = Nav.axisCommandManager:getTargetGroundAltitude() or -1
            P('[DBG] mode='..(globals.maneuverMode and 'M' or 'S')
                ..' takeoff='..(ship.takeoff and 'Y' or 'N')
                ..' land='..(ship.landingMode and 'Y' or 'N')
                ..' GD='..(cData.GrndDist and round2(cData.GrndDist,1) or 'nil')
                ..' tgtAlt='..round2(tgt,1)
                ..' spd='..round2(cData.speedKph,1))
        end

        if ship.takeoff then
            -- Takeoff: complete when clearly off the ground
            local airborne = (cData.GrndDist and cData.GrndDist > 5) or
                (not cData.GrndDist and cData.speedKph > 1)
            if airborne then
                ship.takeoff = false
                inputs.brake = 0
                inputs.brakeLock = false
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
    shipLandingTask(cData)
end