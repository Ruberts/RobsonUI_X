local T, C, L, G = unpack(Tukui)

local bar = TukuiBar2
MultiBarBottomLeft:SetParent(bar)

for i=1, 12 do
	local b = _G["MultiBarBottomLeftButton"..i]
	local b2 = _G["MultiBarBottomLeftButton"..i-1]
	b:SetSize(T.buttonsize, T.buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("BACKGROUND")
	b:SetFrameLevel(15)
	
	if i == 1 then
		b:SetPoint("BOTTOMLEFT", bar, (T.buttonspacing - 1), (T.buttonspacing - 1))
	elseif i == 7 then
		b:SetPoint("TOPLEFT", bar, (T.buttonspacing - 1), (-T.buttonspacing + 1))
	else
		b:SetPoint("LEFT", b2, "RIGHT", (T.buttonspacing - 1), 0)
	end
	
	G.ActionBars.Bar2["Button"..i] = b
end

for i=7, 12 do
	local b = _G["MultiBarBottomLeftButton"..i]
	local b2 = _G["MultiBarBottomLeftButton1"]
	b:SetFrameLevel(b2:GetFrameLevel() - 2)
end
RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")