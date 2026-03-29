-- Static SVG assets - loaded from autoconf/custom/saga/static_svg.lua
local ok, svgData = pcall(require, "autoconf/custom/saga/static_svg")
if ok and svgData then
    HUD.staticSVG = svgData
else
    system.print("[W] saga/static_svg.lua not found, HUD reticles unavailable")
    HUD.staticSVG = {}
end
