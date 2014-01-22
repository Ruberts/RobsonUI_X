local T, C, L, G = unpack(Tukui)

local kill_panel = {
					TukuiLineToPetActionBarBackground,
					TukuiMinimapStatsRight,
					TukuiLineToABLeft,
					TukuiLineToABRight,
					TukuiInfoLeftLineVertical,
					TukuiInfoRightLineVertical,
					TukuiCubeLeft,
					TukuiCubeRight,
					TukuiLineToABLeftAlt,
					TukuiLineToABRightAlt,
					TukuiTabsLeftBackground,
					TukuiTabsRightBackground,
					TukuiChatBackgroundLeft,
					TukuiChatBackgroundRight,
					TukuiInfoLeft,
					TukuiInfoRight
					}					
for _, panel in pairs(kill_panel) do
	panel:Kill()
end

--------------------------------------------------------------
-- RobsonUI Panels
--------------------------------------------------------------
local robsonleftchatbg = CreateFrame("Frame", "RobsonLeftChat", UIParent)
robsonleftchatbg:Size(370, 120)
robsonleftchatbg:Point("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 10)
robsonleftchatbg:RobSkin()
robsonleftchatbg:SetFrameStrata("BACKGROUND")
robsonleftchatbg:SetFrameLevel(1)

local robsonrightchatbg = CreateFrame("Frame", "RobsonRightChat", UIParent)
robsonrightchatbg:Size(370, 120)
robsonrightchatbg:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 10)
robsonrightchatbg:RobSkin()
robsonrightchatbg:SetFrameStrata("BACKGROUND")
robsonrightchatbg:SetFrameLevel(1)

local robsonaltpowerbg = CreateFrame("Frame", "RobsonAltPower", UIParent)
robsonaltpowerbg:Size(RobsonRightChat:GetWidth(), 16)
robsonaltpowerbg:Point("BOTTOM", RobsonRightChat, "TOP", 0, 3)
robsonaltpowerbg:RobSkin()
robsonaltpowerbg:SetFrameLevel(2)
robsonaltpowerbg:Hide()

local robsoneditboxbg = CreateFrame("Frame", "RobsonEditBox", UIParent)
robsoneditboxbg:Size(RobsonLeftChat:GetWidth(), 16)
robsoneditboxbg:Point("BOTTOM", RobsonLeftChat, "TOP", 0, 3)
robsoneditboxbg:RobSkin()
robsoneditboxbg:SetFrameLevel(2)
robsoneditboxbg:Hide()

local bar1 = CreateFrame("Frame", "RobsonBar1", UIParent)
bar1:StripTextures()
bar1:Size(120, 20)
bar1:Point("TOPLEFT", UIParent, "TOPLEFT", 3, -3)

local bar2 = CreateFrame("Frame", "RobsonBar2", UIParent)
bar2:StripTextures()
bar2:Size(120, 20)
bar2:Point("LEFT", RobsonBar1, "RIGHT", 4, 0)

local bar3 = CreateFrame("Frame", "RobsonBar3", UIParent)
bar3:StripTextures()
bar3:Size(120, 20)
bar3:Point("LEFT", RobsonBar2, "RIGHT", 4, 0)
-- bar3:CreateOverlay(self)

-- local robsonab1 = CreateFrame("Frame", "RobsonActionBar1", UIParent)
-- robsonab1:SolidSkin()
-- robsonab1:Size((T.buttonsize * 12) + 2, 30)
-- robsonab1:Point("CENTER", UIParent, "CENTER", 0, 0)

--------------------------------------------------------------
-- Tukui Panels
--------------------------------------------------------------
TukuiBar1:ClearAllPoints()
TukuiBar1:Point("BOTTOM", UIParent, "BOTTOM", 0, 25)
TukuiBar1:SetWidth(T.buttonsize * 12)
TukuiBar1:SolidSkin()
if TukuiBar4:IsShown() then
TukuiBar1:Height(T.buttonsize * 2)
end

TukuiBar4:HookScript("OnHide", function()
TukuiBar1:SetHeight(T.buttonsize * 1)
end)

TukuiBar4:HookScript("OnShow", function()
TukuiBar1:SetHeight(T.buttonsize * 2)
end)

TukuiBar2:SolidSkin()
TukuiBar2:SetWidth(T.buttonsize * 6)
TukuiBar2:SetHeight(T.buttonsize * 2)

TukuiBar3:SolidSkin()
TukuiBar3:SetWidth(T.buttonsize * 6)
TukuiBar3:SetHeight(T.buttonsize * 2)

TukuiBar4:ClearAllPoints()
TukuiBar4:Point("BOTTOM", TukuiBar1, "BOTTOM", 0, 0)
TukuiBar4:SetHeight(T.buttonsize * 2)
TukuiBar4:SetWidth(T.buttonsize * 12)
TukuiBar4:StripTextures()

TukuiBar5:ClearAllPoints()
TukuiBar5:SetPoint("RIGHT", UIParent, "RIGHT", -10, 0)
TukuiBar5:SetWidth(T.buttonsize * 1)
TukuiBar5:SetHeight(T.buttonsize * 12)
TukuiBar5:SolidSkin()

TukuiPetBar:SetWidth(T.buttonsize * 1)
TukuiPetBar:SetHeight(T.buttonsize * 10)
TukuiPetBar:SolidSkin()

TukuiMinimapStatsLeft:ClearAllPoints()
TukuiMinimapStatsLeft:Point("BOTTOM", TukuiMinimap, "BOTTOM", 0, 0)
TukuiMinimapStatsLeft:StripTextures()