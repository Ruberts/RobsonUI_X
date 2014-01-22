local T, C, L, G = unpack(Tukui)

T.PostCastStart = function(self, unit, name, rank, castid)
if(unit == "vehicle") then unit = "player" end

if(name == "Opening") then
	self.Text:SetText("Opening")
end
	
self:SetStatusBarColor(unpack(oUFTukui.colors.class[select(2, UnitClass(unit))]))
	
local color
self.unit = unit
end

T.SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(0, 0)
	return fs
end

T.SkinAura = function (self, button)
	button.count:SetFont(T.CreateFontString())
	button.count:Point("BOTTOMRIGHT", button, 2, -2)
	button.remaining:SetFont(T.CreateFontString())
	button.Glow:Kill()
	button:CreateBorder(false, true)
	button.icon:Point("TOPLEFT", 0, 0)
	button.icon:Point("BOTTOMRIGHT", 0, 0)
	button.cd:Point("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.cd:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
end

hooksecurefunc(T, "PostNamePosition", function(self)
	self.Name:ClearAllPoints()
	
	if(self.Power.value:GetText() and UnitIsEnemy("player", "target") and C["unitframes"]["targetpowerpvponly"] == true) or (self.Power.value:GetText() and C["unitframes"]["targetpowerpvponly"] == false) then
		self.Name:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
	else
		self.Name:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 3, 1)
	end
end)

hooksecurefunc(T, "SetGridGroupRole", function(self)
	local lfdrole = self.LFDRole
	local role = UnitGroupRolesAssigned(self.unit)

	if role == "TANK" then
		lfdrole:SetTexture[[Interface\AddOns\RobsonUI\media\textures\tank.tga]]
		lfdrole:Show()
	elseif role == "HEALER" then
		lfdrole:SetTexture[[Interface\AddOns\RobsonUI\media\textures\healer.tga]]
		lfdrole:Show()
	elseif role == "DAMAGER" then
		lfdrole:SetTexture[[Interface\AddOns\RobsonUI\media\textures\dps.tga]]
		lfdrole:Show()
	else
		lfdrole:Hide()
	end
end)

shortenString = function(string, numChars, dots)
	local bytes = string:len()
	if (bytes <= numChars) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == numChars) then break end
		end

		if (len == numChars and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and '...' or '')
		else
			return string
		end
	end
end

T.CreatePopup["ROBSONUI_SELECT_RAID_LAYOUT"] = {
	question = L.Popups_SELECT_RAID_LAYOUT,
	answer1 = "DPS, Tank",
	answer2 = "Healing",
	function1 = function()
		DisableAddOn("RobsonUI_Raid_Healing")
		EnableAddOn("RobsonUI_Raid")
		ReloadUI()
	end,
	function2 = function()
		EnableAddOn("RobsonUI_Raid_Healing")
		DisableAddOn("RobsonUI_Raid")
		ReloadUI()
	end,
}

local RobsonUIOnLogon = CreateFrame("Frame")
RobsonUIOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
RobsonUIOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if(IsAddOnLoaded("RobsonUI_Raid") and IsAddOnLoaded("RobsonUI_Raid_Healing")) then
		T.ShowPopup("ROBSONUI_SELECT_RAID_LAYOUT")
	end
end)