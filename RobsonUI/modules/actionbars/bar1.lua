local T, C, L, G = unpack(Tukui)

local bar = TukuiBar1

bar:HookScript("OnEvent", function(self, event, unit)
	if(event == "PLAYER_ENTERING_WORLD") then
		local button

		for i = 1, 12 do
			button = _G["ActionButton" .. i]
			button:SetSize(T.buttonsize, T.buttonsize)
			button:ClearAllPoints()
			button:SetParent(bar)
			button:SetFrameStrata("BACKGROUND")
			button:SetFrameLevel(15)

			if(i == 1) then
					button:Point("BOTTOMLEFT", T.buttonspacing, T.buttonspacing)
			else
				local previous = _G["ActionButton" .. i - 1]
				button:SetPoint("LEFT", previous, "RIGHT", T.buttonspacing, 0)
			end
		end
	end
end)