[[English version of README](README.md)]
<hr>

# 快捷键连接器
能为其他MOD的快捷键功能连接到手游版游戏，使这些功能有替代管道被激活。

# 对接
别的MOD如要对接此连接器，就需要先在连接器注册连接点。

```Lua
local Bridge = GameMain:GetMod("Jai_HotkeyAdapter")
...
...
if Bridge ~= nil then
	Bridge:register("Mod Name", "Function Name",
		function()
			-- 这在玩家点击后被执行
		end
	)
end
```
## 指南
* 建议对接的MOD继续支持快捷键
* 调用`register()`之前，必须检查是否`nil`，确保此MOD没被下载或激活的情况下，能继续依靠快捷键正常运行

## 更改日志
* 1.1: 修复MOD下载后更换语言时游戏进入中英混语模式的问题
