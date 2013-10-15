local T, C, L, G = unpack(Tukui)

TukuiRaidUtility:ClearAllPoints()
TukuiRaidUtility:Point("TOPLEFT", RobsonBar3, "TOPRIGHT", 4, 0)
TukuiRaidUtility:Width(RobsonBar3:GetWidth())
TukuiRaidUtility:CreateOverlay(self)

TukuiRaidUtilityShowButton:ClearAllPoints()
TukuiRaidUtilityShowButton:Point("LEFT", RobsonBar3, "RIGHT", 4, 0)
TukuiRaidUtilityShowButton:Height(RobsonBar3:GetHeight())
TukuiRaidUtilityShowButton:Width(RobsonBar3:GetWidth())
TukuiRaidUtilityShowButton:CreateOverlay(self)

TukuiRaidUtilityCloseButton:Width(RobsonBar3:GetWidth())
TukuiRaidUtilityCloseButton:Point("TOP", TukuiRaidUtility, "BOTTOM", 0, -4)
TukuiRaidUtilityCloseButton:CreateOverlay(self)

TukuiRaidUtilityRoleCheckButton:Width(RobsonBar3:GetWidth() * 0.95)
TukuiRaidUtilityReadyCheckButton:Width(RobsonBar3:GetWidth() * 0.67)
TukuiRaidUtilityDisbandRaidButton:Width(RobsonBar3:GetWidth() * 0.95)
TukuiRaidUtilityMainTankButton:Width((TukuiRaidUtilityDisbandRaidButton:GetWidth() / 2) - T.Scale(2))
TukuiRaidUtilityMainAssistButton:Width((TukuiRaidUtilityDisbandRaidButton:GetWidth() / 2) - T.Scale(2))

local Buttons = {
	TukuiRaidUtility,
	TukuiRaidUtilityShowButton,
	TukuiRaidUtilityCloseButton,
	TukuiRaidUtilityDisbandRaidButton,
	TukuiRaidUtilityRoleCheckButton,
	TukuiRaidUtilityMainTankButton,
	TukuiRaidUtilityMainAssistButton,
	TukuiRaidUtilityReadyCheckButton,
	CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton,
}

local NewOnEnter = function(self)
	
end

local NewOnLeave = function(self)
	self:SetBackdropBorderColor(0, 0, 0, 0)
end

for i = 1, #Buttons do
	local Button = Buttons[i]
	Buttons[i]:CreateOverlay(self)
	if text then
		local t = Buttons[i]:CreateFontString(nil, "OVERLAY")
		t:SetFont(C["media"].pixelfont, 12)
		t:SetPoint("CENTER")
		t:SetJustifyH("CENTER")
		t:SetText(text)
		Buttons[i]:SetFontString(t)
	end

	Button:HookScript("OnEnter", NewOnEnter)
	Button:HookScript("OnLeave", NewOnLeave)
end
