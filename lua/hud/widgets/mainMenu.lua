local ok, err = pcall(require, "autoconf/custom/saga/mainMenu")
if not ok then system.print("[E] saga/mainMenu: "..(err or "?")) end
