local T, C, L, G = unpack(Tukui)

if(C["unitframes"].enable ~= true) then return end

--------------------------------------------------------------
-- local Variables
--------------------------------------------------------------
local self = TukuiTarget

self:Size(240, 26)
self.panel:Kill()
self.shadow:Kill()

self:SetBackdrop(nil)
self:SetBackdropColor(0, 0, 0)

---------------------------------------------------------------
-- Health
---------------------------------------------------------------
self.Health:SetHeight(26)
self.Health:SetFrameLevel(5)
self.Health:CreateBorder(false, true)

self.Health.bg:SetVertexColor(0.5, 0.5, 0.5)
		
if(C["unitframes"].unicolor == true) then
	self.Health.colorClass = false
	self.Health:SetStatusBarColor(unpack(C["media"].unitframecolor))
	self.Health.bg:SetTexture(unpack(C["media"].backdropcolor))
else
	self.Health.colorClass = true
end

self.Name:ClearAllPoints()
self.Name:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", -3, 1)
self.Name:SetFont(T.CreateFontString())

self.Health.value = T.SetFontString(self.Health, T.CreateFontString())
self.Health.value:Point("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", -3, 1)

self.Health.PostUpdate = T.PostUpdateHealth

---------------------------------------------------------------
-- Power
---------------------------------------------------------------	
self.Power:ClearAllPoints()
self.Power:Size(self:GetWidth(), 3)
self.Power:Point("TOP", self.Health, "BOTTOM", 0, -3)
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

---------------------------------------------------------------		
-- Portraits
---------------------------------------------------------------		
if C["unitframes"].charportrait == true then
	self.Portrait:ClearAllPoints()
	self.Portrait:CreateBackdrop("Default")
	self.Portrait:Size(60, 60)
	self.Portrait:Point("BOTTOMLEFT", self.Power, "BOTTOMRIGHT", 7, 0)
	self.Health:SetPoint("TOPLEFT", 0, 0)
	self.Health:SetPoint("TOPRIGHT")
end

---------------------------------------------------------------	
-- Castbar
---------------------------------------------------------------		
if C["unitframes"].castbar == true then
	self.Castbar:ClearAllPoints()
	self.Castbar:SetHeight(20)
	self.Castbar:Point("BOTTOM", self, "TOP", 0, 25)
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

		if(C["unitframes"].cbicons == true) then
			self.Castbar:SetWidth(self:GetWidth())
			self.Castbar:Point("BOTTOM", self, "TOP", 0, 150)
			self.Castbar.button:ClearAllPoints()
			self.Castbar.button:SetPoint("BOTTOM", self.Castbar, "TOP", 0, 5)
			self.Castbar.button:Size(20)
			self.Castbar.button.shadow:Kill()
			self.Castbar.icon:Point("TOPLEFT", self.Castbar.button, 0, 0)
			self.Castbar.icon:Point("BOTTOMRIGHT", self.Castbar.button, 0, 0)
		else
			self.Castbar:SetWidth(self:GetWidth())
		end

	self.Castbar.Time = T.SetFontString(self.Castbar, T.CreateFontString())
	self.Castbar.Time:Point("RIGHT", self.Castbar, "RIGHT", -4, 1)
		
	self.Castbar.Text = T.SetFontString(self.Castbar, T.CreateFontString())
	self.Castbar.Text:Point("LEFT", self.Castbar, "LEFT", 4, 0)

	self.Castbar.CustomTimeText = T.CustomCastTimeText
	self.Castbar.CustomDelayText = T.CustomCastDelayText
    self.Castbar.PostCastStart = T.PostCastStart
    self.Castbar.PostChannelStart = T.PostCastStart
end

---------------------------------------------------------------			
-- Combatfeedback
---------------------------------------------------------------			
if (C["unitframes"].combatfeedback == true) then 
	self.CombatFeedbackText:SetFont(T.CreateFontString())
end

---------------------------------------------------------------		
-- Auras
---------------------------------------------------------------		
self.Buffs:ClearAllPoints()		
self.Buffs:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
self.Buffs:Size(240, 24)
self.Buffs.size = 24
self.Buffs.num = 9
self.Buffs.numRow = 9
self.Buffs.spacing = 3	
self.Buffs.initialAnchor = "TOPLEFT"
self.Buffs.ClearAllPoints = T.dummy		
self.Buffs.SetPoint = T.dummy
self.Buffs.PostCreateAura = T.PostCreateAura
self.Buffs.PostUpdateAura = T.PostUpdateAura

self.Debuffs:ClearAllPoints()
self.Debuffs:Point("BOTTOMLEFT", self.Buffs, "TOPLEFT", 0, 3)
self.Debuffs:Size(240, 27)		
self.Debuffs.size = 24
self.Debuffs.num = 18
self.Debuffs.spacing = 3
self.Debuffs.initialAnchor = "TOPRIGHT"
self.Debuffs["growth-y"] = "UP"
self.Debuffs["growth-x"] = "LEFT"
self.Debuffs.ClearAllPoints = T.dummy
self.Debuffs.SetPoint = T.dummy
self.Debuffs.PostCreateAura = T.PostCreateAura
self.Debuffs.PostUpdateAura = T.PostUpdateAura

self.Debuffs.onlyShowPlayer = C["unitframes"].onlyselfdebuffs

if(self.Buffs or self.Debuffs) then
	for _, frames in pairs({self.Buffs, self.Debuffs}) do
		if(not frames) then return end
		if self.Debuffs then
			frames:Size(240, 24)
			frames.size = 24
			frames.num = 18
		elseif self.Buffs then
			frames:Size(240, 24)
			frames.size = 24
			frames.num = 9
		end
		hooksecurefunc(frames, "PostCreateIcon", T.SkinAura)
	end
end
