-- Attitude Indicator - loaded from autoconf/custom/saga/attitudeIndicator.lua
local ok, renderFn = pcall(require, "autoconf/custom/saga/attitudeIndicator")
if ok and renderFn then
    HUD.renderAttitudeIndicator = renderFn
else
    HUD.renderAttitudeIndicator = function() return '' end
end
