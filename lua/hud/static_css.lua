-- Static CSS - templates loaded from autoconf/custom/saga/static_css.lua
local _cssTemplates
local ok, cssData = pcall(require, "autoconf/custom/saga/static_css")
if ok and cssData then
    _cssTemplates = cssData
else
    system.print("[W] saga/static_css.lua not found")
    _cssTemplates = { menuCssTemplate = '', widgetCssTemplate = '' }
end

function HUD.refreshStaticCss()
    local cnf, sat, hue = HUD.Config, HUD.Config.saturation, HUD.Config.mainHue
    local s3, s4, s5 = sat*30, sat*40, sat*50
    local scale = cnf.scaleMultiplier * 10
    local scaleP = cnf.scaleMultiplier * 5

    -- Build gradient defs (these depend on computed hue/saturation)
    local gradientDefs = '\n'
        ..gradient('mainBg', { [0] = 'hsl('..hue..','..s4..'%,10%)', [100] = 'hsl('..hue..','..s4..'%,5%)' }, true)..'\n'
        ..gradient('bg', { [0] = 'hsl('..hue..','..s3..'%,15%)', [100] = 'hsl('..hue..','..s3..'%,10%)' }, true)..'\n'
        ..gradient('bgTransparent', { [0] = {'hsl('..hue..','..s4..'%,15%)', 0.5}, [100] = {'hsl('..hue..','..s4..'%,10%)', 0.5} }, true)..'\n'
        ..gradient('bgStroke', { [10] = 'hsl('..hue..','..s5..'%,50%)', [90] = 'hsl('..hue..','..s4..'%,40%)' }, true)..'\n'
        ..gradient('fadeToBg', { [60] = 'hsl('..hue..','..s4..'%,20%)', [90] = 'hsl('..hue..','..s4..'%,15%)' }, true)..'\n'
        ..gradient('fadeToBgStroke', { [60] = 'hsl('..hue..','..s5..'%,50%)', [90] = 'hsl('..hue..','..s4..'%,15%)' }, true)..'\n'

    -- Substitute placeholders in templates
    local function sub(tmpl)
        return tmpl:gsub('%%HUE%%', hue):gsub('%%S3%%', s3):gsub('%%S4%%', s4):gsub('%%S5%%', s5)
            :gsub('%%SCALE%%', scale):gsub('%%SCALEP%%', scaleP)
    end

    HUD.staticCSS = {
        gradientDefs = gradientDefs,
        menuCss = sub(_cssTemplates.menuCssTemplate),
        css = sub(_cssTemplates.widgetCssTemplate)
    }
end
