local T, C, L, G = unpack(Tukui)

if(C["unitframes"].enable ~= true) then return end

--------------------------------------------------------------
-- local Variables
--------------------------------------------------------------
local self = TukuiPlayer

self:Size(240, 26)
self.panel:Kill()
self.shadow:Kill()

self:SetBackdrop(nil)
self:SetBackdropColor(0, 0, 0)

--------------------------------------------------------------
-- Health
--------------------------------------------------------------
self.Health:SetHeight(26)
self.Health:SetFrameLevel(5)
self.Health:CreateBorder(false, true)

self.Health.bg:SetVertexColor(0.5, 0.5, 0.5)

if(C["unitframes"].unicolor == true) then
	self.Health.colorClass = false
	self.Health:SetStatusBarColor(unpack(C["media"].unitframecolor))
	self.Health.bg:SetVertexColor(unpack(C["media"].backdropcolor))
else
	self.Health.colorClass = true
end
		
self.Health.value = T.SetFontString(self.Health, T.CreateFontString())
self.Health.value:Point("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", -3, 1)

self.Health.PostUpdate = T.PostUpdateHealth			

----------------------------------------------------------------
-- Power
----------------------------------------------------------------
self.Power:ClearAllPoints()	
self.Power:Size(self:GetWidth(), 3)
self.Power:Point("TOP", self.Health, "BOTTOM", 0, -1)
self.Power:SetFrameLevel(self.Health:GetFrameLevel())
self.Power:CreateBorder(false, true)

self.Power.bg:SetVertexColor(0.5, 0.5, 0.5)

self.Power.value = T.SetFontString(self.Health, T.CreateFontString())
self.Power.value:Point("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 3, 1)

self.Power.PreUpdate = T.PreUpdatePower
self.Power.PostUpdate = T.PostUpdatePower

if C["unitframes"].powerfade then
	local powerFade = CreateFrame("StatusBar", nil, self.Power)
	powerFade:SetAllPoints()
	powerFade:SetStatusBarTexture(normTex)
	self.Power.FadeBar = powerFade
	
	self:EnableElement("BarFade")
end

----------------------------------------------------------------
-- Portraits
----------------------------------------------------------------
if C["unitframes"].charportrait == true then
	self.Portrait:ClearAllPoints()
	self.Portrait:CreateBackdrop("Default")
	self.Portrait:Size(60, 60)
	self.Portrait:Point("BOTTOMRIGHT", self.Power, "BOTTOMLEFT", -7, 0)
	self.Health:SetPoint("TOPLEFT", 0, 0)
	self.Health:SetPoint("TOPRIGHT")
end

----------------------------------------------------------------
-- Castbar
----------------------------------------------------------------
if C["unitframes"].castbar == true then
	self.Castbar:ClearAllPoints()
	self.Castbar:SetHeight(20)
	self.Castbar:Point("BOTTOM", TukuiBar1, "TOP", 0, 3)
	self.Castbar:RobSkin()
	
	self.Castbar.bg:SetVertexColor(0.05, 0.05, 0.05, .2)
		
	local Spark = self.Castbar:CreateTexture(nil, "OVERLAY")
	Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	Spark:SetVertexColor(1, 1, 1)
	Spark:SetBlendMode("ADD")
	Spark:Width(14) 
	Spark:Height(self.Castbar:GetHeight() * 2)
	Spark:Point("LEFT", self.Castbar:GetStatusBarTexture(), "RIGHT", -6, 0)
	self.Castbar.Spark = Spark

	if( C["unitframes"].cbicons == true ) then
		self.Castbar:SetWidth(TukuiBar1:GetWidth() - 23)
		self.Castbar:Point("BOTTOM", TukuiBar1, "TOP", 12, 3)
		self.Castbar.button:ClearAllPoints()
		self.Castbar.button:Point("RIGHT", self.Castbar, "LEFT", -3, 0)
		self.Castbar.button:Size(20)
		self.Castbar.button.shadow:Kill()
		self.Castbar.icon:Point("TOPLEFT", self.Castbar.button, 0, 0)
		self.Castbar.icon:Point("BOTTOMRIGHT", self.Castbar.button, 0, 0)
	else
		self.Castbar:SetWidth(TukuiBar1:GetWidth()-4)
	end

	self.Castbar.Time = T.SetFontString(self.Castbar, T.CreateFontString())
	self.Castbar.Time:Point("RIGHT", self.Castbar, "RIGHT", -4, 0)
		
	self.Castbar.Text = T.SetFontString(self.Castbar, T.CreateFontString())
	self.Castbar.Text:Point("LEFT", self.Castbar, "LEFT", 4, 0)

	self.Castbar.CustomTimeText = T.CustomCastTimeText
	self.Castbar.CustomDelayText = T.CustomCastDelayText
    self.Castbar.PostCastStart = T.PostCastStart
    self.Castbar.PostChannelStart = T.PostCastStart
end

--------------------------------------------------------------------
-- Combatfeedback
--------------------------------------------------------------------
if (C["unitframes"].combatfeedback == true) then 
	self.CombatFeedbackText:SetFont(T.CreateFontString())
end

--------------------------------------------------------------------
-- Manaflash
--------------------------------------------------------------------	
if (C["unitframes"].manaflash == true) then
	self.FlashInfo:ClearAllPoints()
	self.FlashInfo:SetAllPoints(self.Health)
	self.FlashInfo:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	self.FlashInfo.ManaLevel:ClearAllPoints()
	self.FlashInfo.ManaLevel:SetPoint("CENTER", 0, 1)
	self.FlashInfo.ManaLevel:SetFont(T.CreateFontString())
else
	self.FlashInfo:Hide()
end

--------------------------------------------------------------------	
-- Combaticon
--------------------------------------------------------------------
self.Combat:ClearAllPoints()
self.Combat:Size(19)
self.Combat:SetPoint("CENTER", 0, 0)
self.Combat:SetVertexColor(0.69, 0.31, 0.31)

--------------------------------------------------------------------
-- Experience
--------------------------------------------------------------------
if T.level ~= MAX_PLAYER_LEVEL then
	self.Experience:ClearAllPoints()
	self.Experience:Point("LEFT", RobsonLeftChat, "RIGHT", 3, 0)
	self.Experience:Size(3, RobsonLeftChat:GetHeight())
	self.Experience:RobSkin()
	self.Experience:SetAlpha(1)
	self.Experience:HookScript("OnLeave", function(self) self:SetAlpha(1) end)
	self.Experience:SetFrameStrata("LOW")
	self.Experience:SetOrientation("Vertical")
	
	self.Resting:Kill()
end	

---------------------------------------------------------------------
-- Reputation
---------------------------------------------------------------------
if T.level == MAX_PLAYER_LEVEL then
	self.Reputation:ClearAllPoints()
	self.Reputation:Point("LEFT", RobsonLeftChat, "RIGHT", 3, 0)
	self.Reputation:Size(3, RobsonLeftChat:GetHeight())
	self.Reputation:RobSkin()
	self.Reputation:SetAlpha(1)
	self.Reputation:HookScript("OnLeave", function(self) self:SetAlpha(1) end)
	self.Reputation:SetFrameStrata("LOW")
	self.Reputation:SetOrientation("Vertical")
end