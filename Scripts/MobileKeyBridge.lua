local MobileHotkeyBridgeMod = GameMain:GetMod("Jai_MobileHotkeyBridge")

local Windows = GameMain:GetMod("Windows")
local tbWindow = Windows:CreateWindow("ModListWindow")

-- function MobileHotkeyBridgeMod:OnLoad() -- Using OnLoad() instead of OnInit()
-- 	local tbEventMod = GameMain:GetMod("_Event")
-- 	tbEventMod:RegisterEvent(g_emEvent.WindowEvent, self.OnWindowEvent, self)
-- end

-- function MobileHotkeyBridgeMod:OnWindowEvent(pThing, pObjs)
-- 	local pWnd = pObjs[0]
-- 	local iArg = pObjs[1]
-- 	if pWnd == CS.Wnd_GameMain.Instance and iArg == 1 then
-- 		local openButton = UIPackage.CreateObject("Jai_MobileHotkeyBridge", "OpenButton")
-- 		pWnd.UIInfo.m_MainMenu:AddChild(openButton)
		
-- 		openButton:GetChild("button").onClick:Add(
-- 			function()
-- 				tbWindow:Show()
-- 			end
-- 		)
-- 	end
-- end

function MobileHotkeyBridgeMod:OnInit()
	local openButton = UIPackage.CreateObject("Jai_MobileHotkeyBridge", "OpenButton")
	Wnd_GameMain._Instance.UIInfo.m_MainMenu:AddChild(openButton)
	
	openButton:GetChild("button").onClick:Add(
		function()
			tbWindow:Show()
		end
	)
end

-- Utility to create a table/map that retains insertion order
function MobileHotkeyBridgeMod:createOrderedMap()
    local map = {
        keys = {},
        data = {}
    }
	
	map.set = function(map, key, value)
		if map.data[key] == nil then
			table.insert(map.keys, key)
		end
		
		map.data[key] = value
	end
	
	map.get = function(map, key)
        return map.data[key]
    end
	
	map.getOrderedPairs = function(map)
		local i = 0
		local keys = map.keys
		local data = map.data

		local function iterator()
			i = i + 1
			local key = keys[i]
			if key then
				return key, data[key]
			end
		end

		return iterator
	end
	
	return map
end

function MobileHotkeyBridgeMod:register(modName, modFunction, onActivated)
	if (type(modName) == "string" and modName ~= "" and
		type(modFunction) == "string" and modFunction ~= "" and
		type(onActivated) == "function"
	) then
		self.data = self.data or self:createOrderedMap()
		
		if self.data:get(modName) == nil then
			self.data:set(modName, MobileHotkeyBridgeMod:createOrderedMap())
		end
		
		local p = self.data:get(modName)
		p:set(modFunction, onActivated)
		return true
	end
	
	return false
end

function tbWindow:OnInit()
	self.window.contentPane = UIPackage.CreateObject("Jai_MobileHotkeyBridge", "ModListWindow")
	self.window.closeButton = self:GetChild("frame"):GetChild("n5")
	self.window:Center()
	
	local frame = self:GetChild("frame")
	frame.title = "Mod" .. XT("手机版快捷键桥")
	local list = self:GetChild("list");
	
	for modName, p in MobileHotkeyBridgeMod.data:getOrderedPairs() do
		local item = list:AddItemFromPool()
		item:GetChild("name").text = modName
		
		for modFunction, onActivated in p:getOrderedPairs() do
			local button = item:GetChild("list"):AddItemFromPool()
			button.title = modFunction
			button.fontsize = 16 -- Making text bigger
			button.height = 35 -- Make the button taller too
			button.onClick:Add(
				function()
					onActivated()
				end
			)
		end
	end
end
