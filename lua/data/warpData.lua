local ok, err = pcall(require, "autoconf/custom/saga/warpData")
if not ok then system.print("[W] saga/warpData: "..(err or "?")); function getWarpData() return {} end end
