local Mod = GameMain:GetMod("Jai_HotkeyAdapter")

local Windows = GameMain:GetMod("Windows")
local tbWindow = Windows:CreateWindow("ModListWindow")

function Mod:OnRender()
	-- Using OnRender() because the game seems to programmatically change the UI components when switching between sect and map exploration screens
	
	if self.lastCheck == nil or CS.UnityEngine.Time.time > self.lastCheck + 1.5 then -- Check every 1.5 seconds to reduce comprehensive checks with GetChild()
		self.lastCheck = CS.UnityEngine.Time.time -- Set check time first, OnRender() may be asynchronous and we don't want the next cycle to enter
		self:checkAndAttachButton()
	end
end

function Mod:checkAndAttachButton()
	local mainWindow = CS.Wnd_GameMain.Instance
	local uiInfo = mainWindow and mainWindow.UIInfo
	local mainMenu = uiInfo and uiInfo.m_MainMenu

	if (mainMenu ~= nil and mainMenu:GetChild("Jai_HotkeyAdapter_Button") == nil) then
		local openButton = UIPackage.CreateObject("Jai_HotkeyAdapter", "OpenButton")
		openButton.name = "Jai_HotkeyAdapter_Button"
		openButton:GetChild("title").text = XT("连接器")
		
		mainMenu:AddChild(openButton)
		openButton.onClick:Add(
			function()
				tbWindow:Show()
			end
		)
	end
end

-- Utility to create a table/map that retains insertion order
function Mod:createOrderedMap()
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

function Mod:register(modName, modFunction, onActivated)
	if (type(modName) == "string" and modName ~= "" and
		type(modFunction) == "string" and modFunction ~= "" and
		type(onActivated) == "function"
	) then
		self.data = self.data or self:createOrderedMap()
		
		if self.data:get(modName) == nil then
			self.data:set(modName, self:createOrderedMap())
		end
		
		local p = self.data:get(modName)
		p:set(modFunction, onActivated)
		return true
	end
	
	return false
end

function tbWindow:OnInit()
	self.window.contentPane = UIPackage.CreateObject("Jai_HotkeyAdapter", "ModListWindow")
	self.window.closeButton = self:GetChild("frame"):GetChild("n5")
	self.window:Center()
	
	local frame = self:GetChild("frame")
	frame.title = XT("快捷键连接器")

	if Mod.data == nil then
		return
	end

	local list = self:GetChild("list")
	
	for modName, p in Mod.data:getOrderedPairs() do
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

		item:GetChild("list"):ResizeToFit()
	end
end
