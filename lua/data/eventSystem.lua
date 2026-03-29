local ok, err = pcall(require, "autoconf/custom/saga/eventSystem")
if not ok then system.print("[W] saga/eventSystem: "..(err or "?")) end
