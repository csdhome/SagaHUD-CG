-- Kinematics - loaded from autoconf/custom/saga/kinematics.lua
local ok, err = pcall(require, "autoconf/custom/saga/kinematics")
if not ok then system.print("[W] saga/kinematics: "..(err or "?")) end
