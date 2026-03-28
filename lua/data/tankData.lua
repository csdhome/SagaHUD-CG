-- Tank data loaded from autoconf/custom/saga/tankdata.lua
-- Keeps compiled script size smaller.
-- If file not found, basic fallback sizes are used.

local _tankLoaded = false
fuelmodifiers = {}
tankData = { ["xs"]=100,["s"]=400,["m"]=1600,["l"]=12800,["xl"]=25600,["xxl"]=51200 }

function loadTankData()
	if _tankLoaded then return end
	local ok, td = pcall(require, "autoconf/custom/saga/tankdata")
	if ok and td then
		tankData = td.tankData
		fuelmodifiers = td.fuelmodifiers
	else
		system.print("[W] saga/tankdata.lua not found, using basic tank sizes only")
	end
	_tankLoaded = true
end

function initializeTanks()
	loadTankData()
	local tankData = tankData
	local optimFactor = 1 - ((fuelTankOptimization + containerOptimization) * 0.04)
	fuelWeights = {
		['atmo'] = 4 * optimFactor,
		['space'] = 6 * optimFactor,
		['rocket'] = 0.8 * optimFactor
	}

	local curTime = system.getArkTime()
	local isInClass = system.isItemInClass
	local function GetMaxVolume(itemId, size)
		return tankData[itemId .. ""] or tankData[size .. ""] or 0
	end
	local function GetFuelTankModifier(itemId)
		return fuelmodifiers[itemId .. ""] or 1
	end
	local replacements = {
		{ "Optimized",   "Opt." },
		{ "Uncommon",    "Unc." },
		{ "Advanced",    "Adv." },
		{ "Exotic",      "Exo." },
		{ "Atmospheric", "Atmo." },
	}

	fuels = {
		['atmo'] = {},
		['space'] = {},
		['rocket'] = {}
	}

	elemIDs = links.core.getElementIdList()
	for i = 1, #elemIDs, 1 do
		local item = system.getItem(links.core.getElementItemIdById(elemIDs[i]))
		if isInClass(item.id, "FuelContainer") then
			elem = {
				uid = elemIDs[i],
				uMass = item.unitMass,
				name = links.core.getElementNameById(elemIDs[i]),
				mass = links.core.getElementMassById(elemIDs[i]) - item.unitMass,
				percent = 0,
				lastMass = 0,
				timeLeft = 0,
				lastTimeLeft = 0,
				lastTime = curTime
			}
			if isInClass(item.id, "AtmoFuelContainer") then
				elem.tankType = "atmo"
				elem.maxMass = GetMaxVolume(item.id, item.size) * (1 + (0.2 * atmoTankHandling)) * fuelWeights['atmo'] * GetFuelTankModifier(item.id)
				elem.percent = elem.maxMass > 0 and round2((elem.mass / elem.maxMass) * 100, 2) or 0
				table.insert(fuels['atmo'], elem)
			elseif isInClass(item.id, "RocketFuelContainer") then
				elem.tankType = "rocket"
				elem.maxMass = GetMaxVolume(item.id, item.size) * (1 + (0.1 * rocketTankHandling)) * fuelWeights['rocket'] * GetFuelTankModifier(item.id)
				elem.percent = elem.maxMass > 0 and round2((elem.mass / elem.maxMass) * 100, 2) or 0
				table.insert(fuels['rocket'], elem)
			elseif isInClass(item.id, "SpaceFuelContainer") then
				elem.tankType = "space"
				elem.maxMass = GetMaxVolume(item.id, item.size) * (1 + (0.2 * spaceTankHandling)) * fuelWeights['space'] * GetFuelTankModifier(item.id)
				elem.percent = elem.maxMass > 0 and round2((elem.mass / elem.maxMass) * 100, 2) or 0
				table.insert(fuels['space'], elem)
			end
			local ri = 1
			while ri <= #replacements and elem.name:len() > 30 do
				elem.name = elem.name:gsub(replacements[ri][1], replacements[ri][2])
				ri = ri + 1
			end
		end
	end
end

function updateTanks()
	local tankData, curTime, ii = tankData, system.getArkTime(), 0
	for key, list in pairs(fuels) do
		for _, tank in ipairs(list) do
			tank.name = tank.name
			tank.mass = links.core.getElementMassById(tank.uid) - tank.uMass
			if tank.mass ~= tank.lastMass then
				tank.percent = utils.round((tank.mass / tank.maxMass) * 100, 0.1)
				tank.lastTimeLeft = tank.timeLeft
				tank.timeLeft = math.floor(tank.mass / ((tank.lastMass - tank.mass) / (curTime - tank.lastTime)))
				tank.lastTime = curTime
			end
			tank.lastMass = tank.mass
			ii = ii + 1
			if ii > 5 then
				coroutine.yield()
			end
		end
	end
end

function updateTanksCo()
	local cont = coroutine.status(updTankCo)
	if cont == "dead" then
		updTankCo = coroutine.create(updateTanks)
	end
	coroutine.resume(updTankCo)
end

updTankCo = coroutine.create(updateTanks)
