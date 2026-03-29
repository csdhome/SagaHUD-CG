local ok, err = pcall(require, "autoconf/custom/saga/ship_maneuver")
if not ok then system.print("[E] saga/ship_maneuver: "..(err or "?")) end
