-- Sound Manager - loaded from autoconf/custom/saga/soundManager.lua
local ok, sm = pcall(require, "autoconf/custom/saga/soundManager")
if ok and sm then
    SoundManager = sm
else
    SoundManager = {
        enabled = false,
        init = function() end,
        play = function() end,
        toggle = function() end,
    }
end
