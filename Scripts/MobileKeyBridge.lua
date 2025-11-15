local MobileHotkeyBridgeMod = GameMain:GetMod("Jai_MobileHotkeyBridge")

local Windows = GameMain:GetMod("Windows")
local tbWindow = Windows:CreateWindow("ModListWindow")

function MobileHotkeyBridgeMod:OnRender()
	-- Using OnRender() because the game 
	
	if self.lastCheck == nil or CS.UnityEngine.Time.time > self.lastCheck + 1.5 then -- Check every 1.5 seconds to reduce comprehensive checks with GetChild()
		self.lastCheck = CS.UnityEngine.Time.time -- Set check time first, OnRender() may be asynchronous and we don't want the next cycle to enter
		self:CheckAndAttachButton()
	end
end

function MobileHotkeyBridgeMod:CheckAndAttachButton()
	local mainWindow = CS.Wnd_GameMain.Instance
	local uiInfo = mainWindow and mainWindow.UIInfo
	local mainMenu = uiInfo and uiInfo.m_MainMenu

	if (mainMenu ~= nil and mainMenu:GetChild("Jai_MobileHotkeyBridge_Button") == nil) then
		local openButton = UIPackage.CreateObject("Jai_MobileHotkeyBridge", "OpenButton")
		openButton.name = "Jai_MobileHotkeyBridge_Button"
		openButton:GetChild("icon").url = "icon-bridge.png"
		openButton:GetChild("title").text = XT("快键桥")
		
		mainMenu:AddChild(openButton)
		openButton:GetChild("button").onClick:Add(
			function()
				tbWindow:Show()
			end
		)
	end
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
	frame.title = XT("手机版快捷键桥")
	
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
