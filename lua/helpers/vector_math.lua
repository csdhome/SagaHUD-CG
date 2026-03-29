-- Vector math helpers - loaded from autoconf/custom/saga/vector_math.lua
local ok, err = pcall(require, "autoconf/custom/saga/vector_math")
if not ok then system.print("[W] saga/vector_math: "..(err or "?")) end
