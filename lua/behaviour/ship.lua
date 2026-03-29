local ok, err = pcall(require, "autoconf/custom/saga/ship")
if not ok then system.print("[E] saga/ship: "..(err or "?")) end
