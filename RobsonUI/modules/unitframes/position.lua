local T, C, L, G = unpack(Tukui)

if(C["unitframes"].enable ~= true) then return end

local FramePositions = CreateFrame("Frame")
FramePositions:RegisterEvent("PLAYER_ENTERING_WORLD")
FramePositions:SetScript("OnEvent", function(self, event, addon)
	TukuiPlayer:ClearAllPoints()
	TukuiTarget:ClearAllPoints()
	TukuiTargetTarget:ClearAllPoints()
	TukuiPet:ClearAllPoints()
	TukuiFocus:ClearAllPoints()
	TukuiFocusTarget:ClearAllPoints()
	if IsAddOnLoaded("RobsonUI_Raid") then
		TukuiPlayer:SetPoint("TOP", UIParent, "BOTTOM", -224 , 190)
		TukuiTarget:SetPoint("TOP", UIParent, "BOTTOM", 224 , 190)
	elseif IsAddOnLoaded("RobsonUI_Raid_Healing") then
		TukuiPlayer:SetPoint("TOP", UIParent, "BOTTOM", -359 , 350)
		TukuiTarget:SetPoint("TOP", UIParent, "BOTTOM", 359 , 350)
	else
		TukuiPlayer:SetPoint("TOP", UIParent, "BOTTOM", -259 , 250)
		TukuiTarget:SetPoint("TOP", UIParent, "BOTTOM", 259 , 250)
	end

		TukuiTargetTarget:SetPoint("TOPRIGHT", TukuiTarget, "BOTTOMRIGHT", 0, -14)
		TukuiPet:SetPoint("TOPLEFT", TukuiPlayer, "BOTTOMLEFT", 0, -14)
		TukuiFocus:SetPoint("TOP", UIParent, "BOTTOM", -450, 600)
		TukuiFocusTarget:SetPoint("TOP", TukuiFocus, "BOTTOM", 0 , -43)

	for i = 1, MAX_BOSS_FRAMES do
		_G["TukuiBoss" .. i]:ClearAllPoints()
		if(i == 1) then
			_G["TukuiBoss" .. i]:SetPoint("TOP", UIParent, "BOTTOM", 600 , 600)
		else
			_G["TukuiBoss" .. i]:SetPoint("TOP", "TukuiBoss" .. i - 1, "BOTTOM", 0, -43)
		end
	end

	for i = 1, 5 do
		_G["TukuiArena" .. i]:ClearAllPoints()
		if(i == 1) then
			_G["TukuiArena" .. i]:SetPoint("TOP", UIParent, "BOTTOM", 600 , 800)
		else
			_G["TukuiArena" .. i]:SetPoint("TOP", "TukuiArena" .. i - 1, "BOTTOM", 0, -43)
		end
	end

end )