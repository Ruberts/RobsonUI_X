local T, C, L, G = unpack(Tukui)

local bar = TukuiBar4
bar:SetAlpha(1)
MultiBarLeft:SetParent(bar)

for i= 1, 12 do
	local b = _G["MultiBarLeftButton"..i]
	local b2 = _G["MultiBarLeftButton"..i-1]
	b:SetSize(T.buttonsize, T.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("BACKGROUND")
	b:SetFrameLevel(15)
	
	if i == 1 then
		b:SetPoint("TOPLEFT", bar, (T.buttonspacing - 1), (-T.buttonspacing + 1))
	else
		b:SetPoint("LEFT", b2, "RIGHT", (T.buttonspacing - 1), 0)
	end
	
	G.ActionBars.Bar4["Button"..i] = b
end
RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")