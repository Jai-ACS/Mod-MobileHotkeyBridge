[[阅读中文版信息](README-zh.md)]
<hr>

# Hotkey Adapter
Acts as an adapter/bridge for mods with hotkey(s). This mod provides a bridging interface where functionalities originally triggered by hotkeys could be activated on the mobile version of the game without using hotkeys.

# Interfacing
In order for a mod to be bridged, it has to be registered with this bridging mod.

```Lua
local Bridge = GameMain:GetMod("Jai_HotkeyAdapter")
...
...
if Bridge ~= nil then
	Bridge:register("Mod Name", "Function Name",
		function()
			-- This is executed when the user taps on this feature
		end
	)
end
```
## Guidelines
* It is also recommended for implementing mods to continue support hotkeys
* You should always check for `nil` before calling `register()`, as the user may not have downloaded and activated this bridging mod
