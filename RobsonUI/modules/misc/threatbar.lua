local T, C, L, G = unpack(Tukui)

TukuiThreatBar:ClearAllPoints()
TukuiThreatBar:Point("RIGHT", RobsonRightChatRight, "LEFT", -3, 0)
TukuiThreatBar:SetParent(UIParent)
TukuiThreatBar:Size(3, RobsonRightChat:GetHeight())
TukuiThreatBar:RobSkin()
TukuiThreatBar:SetOrientation("Vertical")
TukuiThreatBar.text:Hide()
TukuiThreatBar.Title:Hide()
