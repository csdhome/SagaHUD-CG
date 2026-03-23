local s, _ = pcall(require, "autoconf/custom/sagamenusystem")
if not s then
	MenuSystem = { addCategory = function() end, render = function() return "" end }
	system.print("[E] sagamenusystem not found")
end
