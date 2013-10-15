local T, C, L, G = unpack( Tukui )

local bar = TukuiBar5
bar:SetAlpha(1)
MultiBarRight:SetParent(bar)

for i= 1, 12 do
	local b = _G["MultiBarRightButton"..i]
	local b2 = _G["MultiBarRightButton"..i-1]
	b:SetSize(T.buttonsize, T.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("BACKGROUND")
	b:SetFrameLevel(15)
	
	if i == 1 then
		b:SetPoint("TOPRIGHT", bar, -T.buttonspacing, -T.buttonspacing)
	else
		b:SetPoint("TOP", b2, "BOTTOM", 0, -T.buttonspacing)
	end
	
	G.ActionBars.Bar5["Button"..i] = b
end
RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")