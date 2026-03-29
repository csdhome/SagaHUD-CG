local ok, err = pcall(require, "autoconf/custom/saga/electronics")
if not ok then system.print("[W] saga/electronics: "..(err or "?")) end
