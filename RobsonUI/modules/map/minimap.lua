local T, C, L = unpack(Tukui)

TukuiMinimap:ClearAllPoints()
TukuiMinimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -10, -10)
TukuiMinimap:CreateBorder(true, false)
TukuiMinimap:HideInsets()
TukuiMinimap:SetBackdropBorderColor(0,0,0,0)
TukuiMinimap:SetBackdrop(nil)

TukuiMinimapCoord:ClearAllPoints()
TukuiMinimapCoord:SetPoint("BOTTOMRIGHT", TukuiMinimap, "BOTTOMRIGHT", -2, 2)
TukuiMinimapCoord:Size(35, 20)
TukuiMinimapCoord:RobSkin()
TukuiMinimapCoordText:SetFont(T.CreateFontString())
TukuiMinimapCoordText:Point("CENTER", 2, 0)

TukuiMinimapZone:RobSkin()
TukuiMinimapZoneText:SetFont(T.CreateFontString())

TukuiTicket:ClearAllPoints()
TukuiTicket:SetPoint("BOTTOMLEFT", TukuiMinimap, "BOTTOMLEFT", 2, 2)
TukuiTicket:Size(23)
TukuiTicket:RobSkin()
TukuiTicket.Text:SetText(T.RGBToHex(unpack(C["media"].datatextcolor1)).."T")
TukuiTicket.Text:SetFont(T.CreateFontString())


