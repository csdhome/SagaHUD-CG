local s, svg = pcall(require, "autoconf/custom/sagastaticsvg")
if s and svg then
    HUD.staticSVG = svg
else
    HUD.staticSVG = {}
    system.print("[E] sagastaticsvg not found")
end
