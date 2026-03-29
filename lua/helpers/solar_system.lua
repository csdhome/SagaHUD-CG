local ok, err = pcall(require, "autoconf/custom/saga/solar_system")
if not ok then system.print("[E] saga/solar_system: "..(err or "?")) end
