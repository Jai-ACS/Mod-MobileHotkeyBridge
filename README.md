# Hotkey Adapter
Mod that acts as an adapter/bridge for mods with hotkey(s). This mod provides a bridging interface where functionalities originally triggered by hotkeys could be activated.

# Interfacing
In order for a mod to be bridged, it has to first interface with this bridging mod.

```Lua
local Bridge = GameMain:GetMod("Jai_MobileHotkeyBridge")
...
...
Bridge:register("Mod Name", "Function Name",
	function()
		-- This is executed when the user taps on this feature
	end
)
```
