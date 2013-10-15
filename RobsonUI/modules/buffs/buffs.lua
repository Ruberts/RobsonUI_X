local T, C, L, G = unpack(Tukui)

TukuiAurasPlayerBuffs:ClearAllPoints()
TukuiAurasPlayerDebuffs:ClearAllPoints()

TukuiAurasPlayerBuffs:Point("TOPRIGHT", TukuiMinimap, "TOPLEFT", -3, -2)
TukuiAurasPlayerBuffs:SetAttribute("wrapAfter", 17)
TukuiAurasPlayerBuffs:SetAttribute("xOffset", -35)
TukuiAurasPlayerBuffs:SetAttribute("wrapYOffset", -38)

TukuiAurasPlayerDebuffs:Point("BOTTOMRIGHT", TukuiMinimap, "BOTTOMLEFT", -3, 2)
TukuiAurasPlayerDebuffs:SetAttribute("wrapAfter", 17)
TukuiAurasPlayerDebuffs:SetAttribute("xOffset", -35)

local HookFrames = {
	TukuiAurasPlayerBuffs,
	TukuiAurasPlayerDebuffs,
	TukuiAurasPlayerConsolidate,
}

local OnAttributeChanged = function( self )
	for i = 1, self:GetNumChildren() do
		local child = select( i, self:GetChildren() )

		if child then
			child:SetBackdrop(nil)
			child:CreateBorder(false, true)
			child:SetBackdropBorderColor(0 ,0 ,0 ,0)
			child:HideInsets()
		end
		
		if child.Duration then
			child.Duration:SetFont(T.CreateFontString())
			child.Duration:ClearAllPoints()
			child.Duration:SetPoint("BOTTOM", 0, -12)
			
		if C.auras.classictimer == false then
			child.Duration:Kill()
		end
	end
		
		if child.Icon then
			child.Icon:ClearAllPoints()
			child.Icon:Point("TOPLEFT", child, 0, 0)
			child.Icon:Point("BOTTOMRIGHT", child, 0, 0)
		end
		
		if child.Holder then
		child.Holder:CreateBorder(false, true)
		child.Holder:SetBackdropBorderColor(0 ,0 ,0 ,0)
		child.Holder:HideInsets()
		child.Holder:SetHeight(2)
		child.Holder:ClearAllPoints()
		child.Holder:Point("TOP", child, "BOTTOM", 0, -1)
		child.Holder:SetWidth(child:GetWidth() - 4)
		
		child.Bar:ClearAllPoints()
		child.Bar:Point("TOPLEFT", child.Holder, 0, 0)
		child.Bar:Point("BOTTOMRIGHT", child.Holder, 0, 0)
		end

		if child.Count then
			child.Count:SetFont(T.CreateFontString())
			child.Count:ClearAllPoints()
			child.Count:SetPoint("TOP", 0, -4)
		end
	end
end

for _, frame in pairs(HookFrames) do
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:HookScript("OnAttributeChanged", OnAttributeChanged)
	frame:HookScript("OnEvent", OnAttributeChanged)
end