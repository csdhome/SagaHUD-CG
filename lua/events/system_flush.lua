_landingCompleted = false
_pendingGearDeploy = false
_prevIsLanded = false
_landingTargetAlt = 0
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
                deployLandingGears()
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
    -- Auto-clear landingCompleted once ship is clearly airborne (e.g. Space takeoff after G landing).
    if _landingCompleted and not cData.isLanded and (cData.GrndDist or 0) > 20 and cData.speedKph > 5 then
        _landingCompleted = false
    end
    -- Atmospheric landing descent: deactivate hover PID each tick so gravity pulls ship down.
    -- Brake + upward vertical thrust keep descent speed near landingDescentSpeed.
    if cData.inAtmo and not globals.maneuverMode and (AutoPilot.landingMode or ship.landingMode) and not _landingCompleted then
        local spdKph = landingDescentSpeed or 20
        navCom:deactivateGroundEngineAltitudeStabilization()
        local curKph = math.abs(cData.zSpeedKPH or 0)
        if not inputs.manualBrake then
            inputs.brake = 1
        end
        -- Apply upward vertical thrust to hold descent near target speed.
        -- verticalState=true lets applyShipInputs pass the navCom throttle through.
        if curKph > spdKph then
            globals.verticalState = true
            navCom:setThrottleCommand(axisCommandId.vertical, clamp((curKph - spdKph) / (spdKph * 0.5), 0, 1))
        else
            globals.verticalState = false
            navCom:setThrottleCommand(axisCommandId.vertical, 0)
        end
    end
    -- Atmospheric landing completion: fire when near ground OR physically touched down.
    -- No settling check — completion must fire even mid-bounce so we don't re-push down.
    if cData.inAtmo and not globals.maneuverMode and not _landingCompleted
        and (AutoPilot.landingMode or ship.landingMode) then
        local nearGround = cData.GrndDist and cData.GrndDist < 5
        if nearGround or cData.isLanded then
            ship.landingMode = false
            AutoPilot.landingMode = false
            globals.verticalState = false
            setThrottle()
            inputs.brake = 1
            inputs.brakeLock = true
            inputs.up = false
            inputs.down = false
            navCom:resetCommand(axisCommandId.vertical)
            navCom:deactivateGroundEngineAltitudeStabilization()
            navCom:setTargetGroundAltitude(AutoPilot.userConfig.hoverHeight)
            deployLandingGears()
            _landingCompleted = true
            P('[I] Landed')
        end
    end
    -- Parked guard: deactivate stabilization while landed or just-landed.
    -- Also blocks C key from re-activating hover until ship is clearly airborne.
    if cData.inAtmo and (cData.isLanded or (_landingCompleted and cData.speedKph < 5)) then
        navCom:deactivateGroundEngineAltitudeStabilization()
    end
    -- Deploy gear when ship first becomes parked after an AP landing.
    -- unit.deployLandingGears() works once the ship is stationary.
    -- Deploy gear once ship is stationary: fires on isLanded or speedKph < 1
    if _pendingGearDeploy and _landingCompleted
        and (cData.isLanded or cData.speedKph < 1) then
        _pendingGearDeploy = false
        deployLandingGears()
    end
    _prevIsLanded = cData.isLanded or false
    shipLandingTask(cData)
end
