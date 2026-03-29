local ok, err = pcall(require, "autoconf/custom/saga/radar")
if not ok then
    system.print("[W] saga/radar: "..(err or "?"))
    Radar = { init = function() end, toggleWidget = function() end, toggleBoxes = function() end }
end
