function HUD.refreshStaticCss()
	local s, fn = pcall(require, "autoconf/custom/sagastaticcss")
	if s and fn then
		fn(HUD, gradient)
	else
		HUD.staticCSS = { gradientDefs = "", menuCss = "", css = "" }
		system.print("[E] sagastaticcss not found")
	end
end
