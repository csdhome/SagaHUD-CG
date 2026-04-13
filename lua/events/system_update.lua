function onSystemUpdate()
	if not links or links.core == nil or construct == nil then return end

	-- Navigator: poll all linked databanks for incoming waypoint from DU Starmap Navigator
	for _, db in ipairs(links.databanks) do
		local ok, raw = pcall(function() return db.getStringValue("nav_saga_dest") end)
		if ok and raw ~= nil and raw ~= "" then
			-- Clear immediately so it fires only once
			db.setStringValue("nav_saga_dest", "")
			local sep = string.find(raw, "|")
			if sep then
				local name   = string.sub(raw, 1, sep - 1)
				local posStr = string.sub(raw, sep + 1)
				if name ~= "" and string.find(posStr, "::pos") then
					local target = convertToWorldCoordinates(posStr)
					if target ~= nil then
						resetAP()
						AutoPilot:setTarget(target)
						system.print("[NAV] Target: " .. name)
						-- Auto-engage autopilot if Navigator's AutoFly is on
						local afOk, afVal = pcall(function()
							return db.getStringValue("autofly")
						end)
						if afOk and afVal == "1" and not AutoPilot.enabled then
							AutoPilot:toggleState(true)
						end
					end
				end
			end
			break
		end
	end

	cData = getConstructData(construct, links.core)
	playerData = getPlayerData()
	aggData = getAggData()
	warpData = getWarpData()
	scrnData = {}
	syncToG()

	-- Axis	Description				Dir
	-- Axis0	Roll				+
	-- Axis1	Pitch				+
	-- Axis2	Yaw					+
	-- Axis3	Throttle			-
	-- Axis4	Brake				-
	-- Axis5	Strafe Left/Right	?1
	-- Axis6	Vertical Up/Down	?1
	-- Axis7	Custom2	?1
	-- Axis8	Custom2	?1
	-- Axis9	Custom2	?1
	if AutoPilot.enabled or globals.followMode or globals.orbitalHold then
		Axis = {
			rollAxis = 0,
			pitchAxis = 0,
			yawAxis = 0,
			updownAxis = 0,
			leftrightAxis = 0,
			forwardbackAxis = 0,
			brakeAxis = 0,
			throttle1Axis = 0,
			throttle2Axis = 0,
			throttle3Axis = 0 }
	else
		Axis = {
			rollAxis = -system.getAxisValue(0),
			pitchAxis = -system.getAxisValue(1),
			yawAxis = system.getAxisValue(2),
			throttle1Axis = system.getAxisValue(3),
			brakeAxis = -system.getAxisValue(4),
			leftrightAxis = system.getAxisValue(5),
			updownAxis = system.getAxisValue(6),
			forwardbackAxis = system.getAxisValue(7),
			throttle2Axis = system.getAxisValue(8),
			throttle3Axis = system.getAxisValue(9) }
	end
	Nav:update()
	HUD:update()
	Electronics:update()
	-- Deploy landing gear from update context (unit.deployLandingGears does not work from flush).
	-- _pendingGearDeploy is set when landing mode starts; cleared once gear is confirmed deployed.
	if _pendingGearDeploy then
		deployLandingGears()
		if cData.isLanded or cData.speedKph < 1 then
			_pendingGearDeploy = false
		end
	end
end