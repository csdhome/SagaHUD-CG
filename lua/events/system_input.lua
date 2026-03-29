local ok, err = pcall(require, "autoconf/custom/saga/system_input")
if not ok then system.print("[E] saga/system_input: "..(err or "?")) end
