function HUD.constructDebug()
	local gC, rnd, cD, ap = globals, round2, cData, AutoPilot
	local bDist = cD.brakes.distance
	-- local textSize = 1

	updateTanksCo()

	--rdata = activeRadar.getWidgetData()
	--if not radarSpawn then
	--	radarWidgetCreate()
	--	radarSpawn = true
	--end

	local bColor, oRed, br, eDiv = 'ivory', 'orangered', '<br>', '</div>'
	local html = {}
	html[#html+1] = getTDiv("speedBar", 50, 50, HUD.dynamicSVG.speedBar)
	html[#html+1] = getTDiv("throttleBar", 50, 50, HUD.dynamicSVG.throttleBar)

	local bD2, planetStr = rnd(cD.brakes.distance*1.1,1), ''
	if cD.body then
		local dist = 0
		if cD.body.hasAtmosphere then -- planet
			dist = rnd(cD.body.atmoRadius - vector.dist(cD.body.center,cD.position),1)
			planetStr = 'Atmo Dist = '
		else -- moon
			dist = rnd(vector.dist(cD.body.center,cD.position)-(cD.body.radius*1.05))
			planetStr = 'Surf Dist ~ '
		end
		planetStr = br..planetStr..printDistance(dist)
		if bD2 > dist and dist > 0 then bColor = oRed end
		html[#html+1] = getTDiv("altBar", 50, 50, HUD.dynamicSVG.altitudeBar)
		-- html[#html+1] = [[<div class="altBar" style="transform:translate(50vw,50vh)">]]..HUD.dynamicSVG.altitudeBar..eDiv
	end
	html[#html+1] = [[<div class="atmoAlert">Brake Dist = ]]..
		colorSpan(bColor,printDistance(bD2, true))..planetStr..eDiv
	html[#html+1] = [[<div class="atmoAlert" style="transform:translate(30vw,0vh);text-align:right;">Vertical Speed: ]]..
		(rnd(cD.zSpeedKPH,1))..eDiv

	if ap.enabled and not gC.maneuverMode then
		html[#html+1] = getAPDiv("AUTOPILOT")
	elseif ap.landingMode or ship.landingMode or cD.isLanded then
		html[#html+1] = getAPDiv("PARKING MODE")
	elseif ship.takeoff then
		html[#html+1] = getAPDiv("TAKEOFF")
	elseif ship.vertical then
		html[#html+1] = getAPDiv("VERTICAL")
	elseif ship.gotoLock ~= nil then
		html[#html+1] = getAPDiv("TRAVEL")
	end

	if gC.safetyThrottle then
		html[#html+1] = getBrakeDiv("SAFETY THROTTLE", oRed)
	elseif gC.altitudeHold then
		html[#html+1] = getBrakeDiv("HODOR!   "..rnd(ship.holdAltitude or 0,1).."m", oRed)
	elseif inputs.brakeLock then
		html[#html+1] = getBrakeDiv("BRAKE LOCK", oRed)
	elseif inputs.brake == 1 then
		html[#html+1] = getBrakeDiv("BRAKE", oRed)
	end
	--html[#html+1] = getBrakeDiv(tostring(rnd(cD.velocity.z,5)), ored)
	---@TODO "heavy" message?
	--if 0.5 * cData.MaxKinematics.Forward / cData.G < cData.mass then msg("WARNING: Heavy Loads may affect autopilot performance.") end

	-- Collision avoidance: velocity-based emergency braking
	local collisionStatus = Collision.checkEmergencyBraking()

	-- Show collision alert for velocity-based detection
	if collisionStatus and gC.collision then
		html[#html+1] = getDiv("collision", "Collision Alert: "..tostring(gC.collision.name or "(unknown)"))
	end
	-- Show collision alert for path-based detection (AP orbit avoidance)
	if gC.collisionBody and not collisionStatus then
		html[#html+1] = getDiv("collision", "Avoiding: "..tostring(gC.collisionBody.name or "(unknown)"))
	end
	html[#html+1] = '<style>' .. HUD.staticCSS.css .. '></style>'

	local targetPoint = nil
	if ap.target ~= nil then
		targetPoint = library.getPointOnScreen(getXYZ(ap.target)) -- Target
	end

	-- Crosshair
	--local reticle1 = getReticle(cD.wFwd*cD.constructSpeed)
	local coord =  vec3(cD.wFwd) * 20 + vec3(cD.worldUp) * 2
	local reticle1 = getReticle(coord)
	local point1 = library.getPointOnScreen(reticle1)

	local vector2 = vectorRotated(targetAngularVelocity,cD.wFwd)
	local reticle2 = getReticle(vector2*10)
	-- ManeuverNode (AP/player input), for now just the current TAV
	local point2 = library.getPointOnScreen(reticle2)

	local predict = cD.wVelDir*cD.constructSpeed
	local reticle3 = getReticle(predict)
	local point3 = library.getPointOnScreen(reticle3) --Prograde
	local reticle4 = getReticle(-predict)
	local point4 = library.getPointOnScreen(reticle4) --ManeuverNode - predicted motion

	if point1[1] <= 1 and point1[2] <= 1 then
		local tpl = _hudTpl and _hudTpl.crosshair
		if tpl then
			html[#html+1] = string.format(tpl, point1[1]*98, point1[2]*101)
		end
	end

	if targetPoint ~= nil then
		html[#html+1] = getTDivP("dot", targetPoint, HUD.staticSVG.targetReticle)
		html[#html+1] = getTDivP("dottext", targetPoint, HUD.dynamicSVG.targetReticle2)
	end
	html[#html+1] = getTDivP("dot", point2, HUD.staticSVG.centerofMass)
	html[#html+1] = getTDivP("dot", point3, HUD.staticSVG.progradeReticle)
	html[#html+1] = getTDivP("dot", point4, HUD.staticSVG.retrogradeReticle)

	return table.concat(html)
end