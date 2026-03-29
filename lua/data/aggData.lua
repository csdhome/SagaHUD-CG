local ok, err = pcall(require, "autoconf/custom/saga/aggData")
if not ok then system.print("[W] saga/aggData: "..(err or "?")); function getAggData() return {} end end
