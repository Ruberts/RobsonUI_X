local T, C, L, G = unpack(Tukui)

if(C["unitframes"].enable ~= true) then return end


--------------------------------------------------------------
-- local Variables
--------------------------------------------------------------
local self = TukuiFocus

self:Size(200, 26)
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

self.Name:SetFont(T.CreateFontString())
self.Name:SetShadowOffset(0, 0)
self.Health.value = T.SetFontString(self.Health,T.CreateFontString())
self.Health.value:Point("LEFT", self.Health, "LEFT", 4, 1)
self.Health.PostUpdate = T.PostUpdateHealth

----------------------------------------------------------------
-- Power
----------------------------------------------------------------
self.Power:ClearAllPoints()	
self.Power:Size(self:GetWidth(), 3)
self.Power:Point("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -1)
self.Power:SetFrameLevel(self.Health:GetFrameLevel())
self.Power:CreateBorder(false, true)

self.Power.bg:SetVertexColor(0.5, 0.5, 0.5)

self.Power.value:SetFont(T.CreateFontString())
self.Power.value:SetShadowOffset(0, 0)

----------------------------------------------------------------
-- Castbar
----------------------------------------------------------------
if(C["unitframes"].unitcastbar == true) then
	self.Castbar:ClearAllPoints()
	self.Castbar:SetHeight(20)
	self.Castbar:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -9)
	self.Castbar:CreateBorder(false, true)
	
	self.Castbar.bg:Kill()

	self.Castbar.bg = self.Castbar:CreateTexture(nil, "BORDER")
	self.Castbar.bg:SetAllPoints(self.Castbar)
	self.Castbar.bg:SetTexture(C["media"].normTex)
	self.Castbar.bg:SetVertexColor(0.05, 0.05, 0.05, 0.7)

	self.Castbar.Time = T.SetFontString(self.Castbar, T.CreateFontString())
	self.Castbar.Time:Point("RIGHT", self.Castbar, "RIGHT", -4, 1)

	self.Castbar.Text = T.SetFontString(self.Castbar, T.CreateFontString())
	self.Castbar.Text:Point("LEFT", self.Castbar, "LEFT", 4, 1)

	self.Castbar.PostCastStart = T.PostCastStart
	self.Castbar.PostChannelStart = T.PostCastStart

	if(C["unitframes"].cbicons == true) then
		self.Castbar:Width(177)

		self.Castbar.button:ClearAllPoints()
		self.Castbar.button:SetPoint("LEFT", self.Castbar, "RIGHT", 3, 0)
		self.Castbar.button:Size(20)
		self.Castbar.icon:Point("TOPLEFT", self.Castbar.button, 0, 0)
		self.Castbar.icon:Point("BOTTOMRIGHT", self.Castbar.button, 0, 0)
	else
		self.Castbar:Width(self:GetWidth())
		self.Castbar.button:Kill()
	end

end
--------------------------------------------------------------------
-- Auras
--------------------------------------------------------------------
if(self.Debuffs or G.self.Buffs) then
	for _, frames in pairs({self.Debuffs, self.Buffs}) do
		if(not frames) then return end

		frames:Size(200, 26)
		frames.size = 26
		frames.num = 4
					
		hooksecurefunc(frames, "PostCreateIcon", T.SkinAura)
	end
end