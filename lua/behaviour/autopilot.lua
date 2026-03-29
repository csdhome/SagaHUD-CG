local ok, err = pcall(require, "autoconf/custom/saga/autopilot")
if not ok then system.print("[E] saga/autopilot: "..(err or "?")) end
