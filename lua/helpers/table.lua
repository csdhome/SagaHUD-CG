-- Table helpers - loaded from autoconf/custom/saga/table_helpers.lua
local ok, err = pcall(require, "autoconf/custom/saga/table_helpers")
if not ok then system.print("[W] saga/table_helpers: "..(err or "?")) end
