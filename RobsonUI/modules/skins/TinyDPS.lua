local T, C, L, G = unpack(Tukui)

if (not IsAddOnLoaded("TinyDPS") or C["skins"].TinyDPS ~= true) then return end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event)
	local frame = tdpsFrame
	local anchor = tdpsAnchor
	local status = tdpsStatusBar
	local tdps = tdps
	local font = tdpsFont
	local position = tdpsPosition
	local button = TukuiRaidUtilityShowButton
	local class = RAID_CLASS_COLORS[select(2,UnitClass("player"))]

	if(tdps) then
		tdps.width = TukuiMinimap:GetWidth()
		tdps.spacing = 2
		tdps.barHeight = 16
		tdps.hideOOC = false
		tdps.showMinimapButton = false
		tdps.showRank = false
		font.name = C["media"].pixelfont
		font.size = 12
		font.outline = "MONOCHROMEOUTLINE"
		font.shadow = 0
	end

	anchor:ClearAllPoints()
	anchor:SetPoint("BOTTOMLEFT", TukuiMinimap, "BOTTOMLEFT", 0, -4)

	frame:SetWidth(TukuiMinimap:GetWidth())
	frame:SetFrameStrata("LOW")
	frame:SetFrameLevel(4)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	frame:HideInsets()
	frame:SetBackdrop(nil)
	
	noData:SetTextColor(class.r, class.g, class.b)
	
	-- Border
	local tdpsBG = CreateFrame("Frame", "tdpsBG", frame)
	tdpsBG:ClearAllPoints()
	tdpsBG:RobSkin()
	tdpsBG:SetPoint("TOPLEFT", 2, -2)
	tdpsBG:SetPoint("BOTTOMRIGHT", -2, 2)
	tdpsBG:SetFrameLevel(frame:GetFrameLevel() - 1)
	
	position = {x = 0, y = -6}

	if(status) then
		tdpsStatusBar:SetBackdrop({
			bgFile = C["media"].normTex,
			edgeFile = C["media"].blank,
			tile = false,
			tileSize = 0,
			edgeSize = 1,
			insets = {
				left = 0,
				right = 0,
				top = 0,
				bottom = 0
			}
		})
		tdpsStatusBar:SetStatusBarTexture(C["media"].normTex)
		tdpsStatusBar:SetFrameStrata("LOW")
		tdpsStatusBar:SetFrameLevel(4)
	end
end)