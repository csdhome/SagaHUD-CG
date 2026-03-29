-- Collision Avoidance System
-- Ported from SagaHUD AP 4.2
-- Detects celestial bodies in the flight path and triggers orbit-around or emergency braking.

local Collision = (function()
    local this = {}

    --- Check if a line segment (startPos to endPos) intersects a sphere (body).
    --- Uses closest-point-on-segment approach with 1% safety margin on radius.
    --- @param startPos vec3
    --- @param endPos vec3
    --- @param body table with .center (vec3) and .radius (number)
    --- @return boolean hit
    --- @return number|nil t parameter [0..1] along segment
    --- @return number|nil distance from closest point to sphere center
    function this.lineSegmentIntersectsSphere(startPos, endPos, body)
        if body == nil then return false, nil, nil end
        local P = vec3(startPos)
        local Q = vec3(endPos)
        local C = vec3(body.center)
        local d = Q - P
        local segLenSq = d:dot(d)
        if segLenSq == 0 then
            local dist = (P - C):len()
            return (dist < (body.radius or 0)), 0, dist
        end
        local t = ((C - P):dot(d)) / segLenSq
        if t < 0 then t = 0 end
        if t > 1 then t = 1 end
        local closestPoint = P + (d * t)
        local distance = (closestPoint - C):len()
        local hit = distance < ((body.radius or 0) * 1.01)
        return hit, t, distance
    end

    --- Calculate angle between ship position and target relative to a body.
    --- Same-body: angle at body center between target and ship.
    --- Different body: angle at nearest body center between target dir and ship dir.
    --- @return number angle in degrees
    function this.getAngleToTarget()
        local ap = AutoPilot
        if not ap.target or not ap.targetBody then return 0 end
        local shipPos = cData.position
        local targetBody = ap.targetBody
        local body = cData.body
        if sameBody then
            local dirToTarget = (targetBody.center - ap.target):normalize()
            local dirToShip = (targetBody.center - shipPos):normalize()
            return round2(math.deg(dirToTarget:angle_between(dirToShip)), 0.01)
        else
            if not body then return 0 end
            local dirTarget = (ap.target - body.center):normalize()
            local dirShip = (shipPos - body.center):normalize()
            return round2(math.deg(dirTarget:angle_between(dirShip)), 0.01)
        end
    end

    --- Scan for celestial bodies blocking the path from ship to AP target.
    --- Builds candidate list from target body + satellites of nearest/target bodies.
    --- @return boolean pathBlocked
    --- @return table|nil collisionBody
    --- @return number collisionDist distance to collision point
    --- @return boolean collisionAlert true if collision is imminent
    function this.checkPathIntersections()
        local ap = AutoPilot
        local gC = globals
        local body = cData.body
        local targetBody = ap.targetBody
        local shipPos = cData.position

        if not ap.enabled or not ap.target or not targetBody then
            return false, nil, 0, false
        end
        -- Skip in-atmosphere same-body surface travel
        if sameBody and cData.inAtmo and ap.targetLoc == 'surface' then
            return false, nil, 0, false
        end

        local candidates = {}
        local safetyMargin = 50000 -- 50km extra for pre-filter
        local lsi = this.lineSegmentIntersectsSphere

        -- Add target body
        if targetBody then
            table.insert(candidates, targetBody)
        end

        -- Check satellites of nearest body (if target is on different body)
        if body and body.satellites and targetBody and targetBody.bodyId ~= body.bodyId then
            for _, satId in pairs(body.satellites) do
                local sat = atlas[systemId][satId]
                if sat then
                    local checkR = (sat.atmoRadius and sat.atmoRadius > 0) and sat.atmoRadius or sat.radius
                    local hit = lsi(shipPos, ap.target, {center = sat.center, radius = checkR + safetyMargin})
                    if hit then
                        table.insert(candidates, sat)
                    end
                end
            end
        end

        -- Check satellites of target body (if different from nearest)
        if targetBody and targetBody.satellites and body and targetBody.bodyId ~= body.bodyId then
            for _, satId in pairs(targetBody.satellites) do
                local sat = atlas[systemId][satId]
                if sat then
                    local checkR = (sat.atmoRadius and sat.atmoRadius > 0) and sat.atmoRadius or sat.radius
                    local hit = lsi(shipPos, ap.target, {center = sat.center, radius = checkR + safetyMargin})
                    if hit then
                        table.insert(candidates, sat)
                    end
                end
            end
        end

        local currentAngle = this.getAngleToTarget()
        local pathBlocked = false
        local colBody = nil
        local colDist = 0
        local colAlert = false

        for _, candidate in pairs(candidates) do
            if candidate then
                -- Determine check radius
                local checkRadius
                if sameBody and ap.targetLoc == 'surface' and targetBody and candidate.bodyId == targetBody.bodyId then
                    checkRadius = candidate.radius
                else
                    checkRadius = (candidate.atmoRadius and candidate.atmoRadius > 0) and candidate.atmoRadius or candidate.radius
                end

                -- Skip the body we're nearest to or targeting directly
                if not ((targetBody and candidate.bodyId == targetBody.bodyId)
                    or (body and candidate.bodyId == body.bodyId)) then

                    local hit, t, dist = lsi(shipPos, ap.target, {center = candidate.center, radius = checkRadius})

                    if hit then
                        -- If nearly aligned with target (small angle), don't flag
                        if currentAngle ~= nil and math.abs(currentAngle) < 10 then
                            -- skip
                        else
                            pathBlocked = true
                            colBody = candidate
                            colDist = t * vector.dist(ap.target, shipPos)

                            -- Check if collision is imminent
                            local distToBody = vector.dist(candidate.center, shipPos) - (checkRadius * 1.05)
                            if cData.brakes.distance * 1.4 >= distToBody
                                and getAltitude() > (candidate.atmoAltitude or 0) * 1.05 then
                                colAlert = true
                            end
                            break
                        end
                    end
                end
            end
        end

        -- Override: in space with small angle to target, clear collision
        if ap.targetLoc == 'space' and math.abs(currentAngle) < 15 then
            pathBlocked = false
        end

        return pathBlocked, colBody, colDist, colAlert
    end

    --- Determine if orbit avoidance is needed based on path and angle.
    --- Called from the AP update loop.
    --- @return boolean needsOrbit
    function this.needsOrbitAvoidance()
        local ap = AutoPilot
        local gC = globals
        local body = cData.body

        local pathBlocked, colBody, colDist, colAlert = this.checkPathIntersections()

        -- Store collision state in globals for HUD display
        gC.collisionBody = colBody
        gC.collisionDist = colDist
        gC.collisionAlert = colAlert

        if pathBlocked then
            return true
        end

        -- Even without path intersection, check angle-based avoidance
        local angle = this.getAngleToTarget()
        if sameBody and ap.targetLoc == 'surface' then
            if angle > 18 then return true end
        else
            if body and angle > 80 and vector.dist(body.center, cData.position) < body.radius * 2 then
                return true
            end
        end

        return false
    end

    --- Check for imminent collision and apply emergency braking.
    --- Uses velocity-based ray casting (existing castIntersections).
    --- @return boolean collisionImminent
    function this.checkEmergencyBraking()
        local gC = globals
        local ap = AutoPilot
        local collisionImminent = false

        if gC.collision and type(gC.collision) == 'table' then
            local brakeDist = round2(cData.brakes.distance * 1.2)
            local vSpeed = cData.zSpeedKPH

            if gC.collision.hasAtmosphere then
                local distToAtmo = round2(vector.dist(cData.body.center, cData.position) - gC.collision.atmoRadius)
                if brakeDist > distToAtmo and distToAtmo > 0
                    and vSpeed < 0 and cData.constructSpeed > cData.burnSpeed then
                    collisionImminent = true
                end
            else
                local distToSurface = round2(vector.dist(cData.body.center, cData.position) - (gC.collision.radius * 1.1))
                if brakeDist > distToSurface and distToSurface > 0 and vSpeed < 0 then
                    collisionImminent = true
                end
            end

            -- Emergency braking (requires throttleBurnProtection)
            if ap.userConfig.throttleBurnProtection then
                if not ap.enabled and not ap.landingMode and not gC.orbitalHold then
                    if collisionImminent then
                        gC.safetyThrottle = true
                        if controlMode() == 'cruise' then
                            swapControl()
                        end
                        navCom:setThrottleCommand(axisCommandId.longitudinal, 0)
                    end
                    if gC.safetyThrottle and collisionImminent then
                        gC.collisionBrake = true
                        brakeCtrl = 30
                        inputs.brake = 1
                    end
                end
            end
        end

        -- Clear emergency braking when safe
        if not collisionImminent and gC.collisionBrake then
            brakeCtrl = 31
            gC.collisionBrake = false
            if not gC.brakeState then
                inputs.brake = 0
            end
        end

        return collisionImminent
    end

    --- Get the max vertical brake speed in m/s, altitude-adjusted.
    --- @param altitude number|nil current altitude
    --- @return number speed limit in m/s
    function this.getMaxVBrakeSpeedMs(altitude)
        local maxVBS = tonumber(ap and ap.userConfig and ap.userConfig.maxVBrakeSpeed) or maxVBrakeSpeed or 300
        maxVBS = math.max(math.abs(maxVBS), 50)
        local speedMs = maxVBS / 3.6

        -- Taper speed near ground
        if altitude == nil or altitude < 0 then return speedMs end
        local safeSpeed = 50 / 3.6  -- ~14 m/s
        if altitude >= 500 then
            return speedMs
        elseif altitude >= 200 then
            return math.min(speedMs, safeSpeed)
        else
            local minSpeed = 5 / 3.6
            local factor = math.max(0, math.min(altitude / 200, 1))
            local limit = minSpeed + (safeSpeed - minSpeed) * factor
            return math.min(speedMs, limit)
        end
    end

    return this
end)()

return Collision
