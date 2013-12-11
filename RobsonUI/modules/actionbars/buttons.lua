local T, C, L, G = unpack(Tukui)

local button_skin = {
					TukuiBar2Button,
					TukuiBar3Button,
					TukuiBar4Button,
					TukuiBar5ButtonTop,
					TukuiBar5ButtonBottom,
					TukuiExitVehicleButtonLeft,
					TukuiExitVehicleButtonRight,
					}
for _, button in pairs(button_skin) do
	button:RobSkin()
end

TukuiBar2Button:ClearAllPoints()
TukuiBar2Button:Point("RIGHT", TukuiBar2, "LEFT", -3, 0)
TukuiBar2Button:SetHeight(TukuiBar1:GetHeight())
TukuiBar2Button.text:SetFont(T.CreateFontString())
TukuiBar2Button:SetScript("OnEnter", function(self) self:FadeIn() end)
TukuiBar2Button:SetScript("OnLeave", function(self) self:FadeOut() end)
TukuiBar2Button.text:SetShadowOffset(0, 0)

TukuiBar3Button:ClearAllPoints()
TukuiBar3Button:Point("LEFT", TukuiBar3, "RIGHT", 3, 0)
TukuiBar3Button:SetHeight(TukuiBar1:GetHeight())
TukuiBar3Button.text:SetFont(T.CreateFontString())
TukuiBar3Button:SetScript("OnEnter", function(self) self:FadeIn() end)
TukuiBar3Button:SetScript("OnLeave", function(self) self:FadeOut() end)
TukuiBar3Button.text:SetShadowOffset(0, 0)

TukuiBar4Button:ClearAllPoints()
TukuiBar4Button:Size(TukuiBar1:GetWidth(), 19)
TukuiBar4Button:Point("BOTTOM", TukuiBar1, "TOP", 0, 3)
TukuiBar4Button.text:SetFont(T.CreateFontString())
TukuiBar4Button:SetScript("OnEnter", function(self) self:FadeIn() end)
TukuiBar4Button:SetScript("OnLeave", function(self) self:FadeOut() end)
TukuiBar4Button.text:SetShadowOffset(0, 0)

TukuiBar5ButtonTop:ClearAllPoints()
TukuiBar5ButtonTop:Point("BOTTOM", TukuiBar5, "TOP", 0, 3)
TukuiBar5ButtonTop.text:SetFont(T.CreateFontString())
TukuiBar5ButtonTop:SetScript("OnEnter", function(self) self:FadeIn() end)
TukuiBar5ButtonTop:SetScript("OnLeave", function(self) self:FadeOut() end)
TukuiBar5ButtonTop.text:SetShadowOffset(0, 0)

TukuiBar5ButtonBottom:ClearAllPoints()
TukuiBar5ButtonBottom:Point("TOP", TukuiBar5, "BOTTOM", 0, -3)
TukuiBar5ButtonBottom.text:SetFont(T.CreateFontString())
TukuiBar5ButtonBottom:SetScript("OnEnter", function(self) self:FadeIn() end)
TukuiBar5ButtonBottom:SetScript("OnLeave", function(self) self:FadeOut() end)
TukuiBar5ButtonBottom.text:SetShadowOffset(0, 0)

TukuiExitVehicleButtonLeft:ClearAllPoints()
TukuiExitVehicleButtonLeft:Size(TukuiBar1:GetWidth(), 20)
TukuiExitVehicleButtonLeft:Point("TOP", TukuiBar1, "BOTTOM", 0, - 3)
TukuiExitVehicleButtonLeft:SetFrameStrata("HIGH")
TukuiExitVehicleButtonLeft.text:SetFont(T.CreateFontString())

TukuiExitVehicleButtonRight:ClearAllPoints()
TukuiExitVehicleButtonRight:Hide()