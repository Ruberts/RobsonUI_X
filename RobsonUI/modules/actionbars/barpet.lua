local T, C, L, G = unpack(Tukui)

if(C["actionbar"]["enable"] ~= true) then return end

local bar = G.ActionBars.Pet

bar:HookScript("OnEvent", function(self, event, unit)
	if(event == "PLAYER_ENTERING_WORLD" ) then

		local button
		for i = 1, 10 do
			button = _G["PetActionButton" .. i]
			button:ClearAllPoints()
			button:SetParent(bar)
			button:SetSize(T.petbuttonsize, T.petbuttonsize)
			if(i == 1) then
				button:SetPoint("TOPLEFT", 1, -1)
			else
				button:SetPoint("TOP", _G["PetActionButton" .. ( i - 1 )], "BOTTOM", 0, -T.buttonspacing)
			end
			button:Show()
			self:SetAttribute("addchild", button)
		end
		RegisterStateDriver(self, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")

	end
end )
RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")