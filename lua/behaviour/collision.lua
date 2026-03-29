-- Collision Avoidance System - loaded from autoconf/custom/saga/collision.lua
local ok, colData = pcall(require, "autoconf/custom/saga/collision")
if ok and colData then
    Collision = colData
else
    system.print("[W] saga/collision.lua not found, collision avoidance unavailable")
    Collision = {
        needsOrbitAvoidance = function() return false end,
        checkEmergencyBraking = function() return false end,
        getMaxVBrakeSpeedMs = function() return 300/3.6 end,
        checkPathIntersections = function() return false, nil, 0, false end,
        getAngleToTarget = function() return 0 end,
        lineSegmentIntersectsSphere = function() return false, nil, nil end,
    }
end
