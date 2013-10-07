local T, C, L, G = unpack(Tukui)

if(C["unitframes"].enable ~= true) then return end


for i = 1, MAX_BOSS_FRAMES do

--------------------------------------------------------------
-- local Variables
--------------------------------------------------------------
local self = G.UnitFrames["Boss" .. i]

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
		self.Health.bg:SetTexture(unpack(C["media"].backdropcolor))
	else
		self.Health.colorClass = true
	end

self.Name:SetPoint("LEFT", self, "LEFT", 4, 0)
self.Name:SetFont(T.CreateFontString())
self.Name:SetShadowOffset(0, 0)

self.Health.value:SetFont(T.CreateFontString())
self.Health.value = T.SetFontString(self.Health,T.CreateFontString())

self.Health.value:Point("RIGHT", self.Health, "RIGHT", -4, 1)
self.Health.PostUpdate = T.PostUpdateHealth

---------------------------------------------------------------
-- Power
---------------------------------------------------------------	
self.Power:ClearAllPoints()
self.Power:Size(self:GetWidth(), 3)
self.Power:Point("TOP", self.Health, "BOTTOM", 0, -3)
self.Power:SetFrameLevel(self.Health:GetFrameLevel())
self.Power:CreateBorder(false, true)
self.Power.frequentUpdates = true
self.Power.colorDisconnected = true
self.Power.colorTapping = true
			
	if(C["unitframes"].unicolor == true) then
		self.Power.colorClass = true
	else
		self.Power.colorPower = true
	end
			
self.Power.value:Kill()
				
self.Power.PreUpdate = T.PreUpdatePower
self.Power.PostUpdate = T.PostUpdatePower

---------------------------------------------------------------	
-- Castbar
---------------------------------------------------------------	
	if( C["unitframes"].unitcastbar == true ) then
		self.Castbar:ClearAllPoints()
		self.Castbar:SetHeight(16)
		self.Castbar:Point("TOPRIGHT", self.Power, "BOTTOMRIGHT", 0, -3)
		self.Castbar:CreateBorder(false, true)

		self.Castbar.bg:Kill()

		self.Castbar.bg = self.Castbar:CreateTexture(nil, "BORDER")
		self.Castbar.bg:SetAllPoints(self.Castbar)
		self.Castbar.bg:SetTexture(C["media"].normTex)
		self.Castbar.bg:SetVertexColor(0.05, 0.05, 0.05)

		self.Castbar.Time = T.SetFontString(self.Castbar,T.CreateFontString())
		self.Castbar.Time:Point("RIGHT", self.Castbar, "RIGHT", -4, 1)

		self.Castbar.Text = T.SetFontString(self.Castbar,T.CreateFontString())
		self.Castbar.Text:Point("LEFT", self.Castbar, "LEFT", 4, 1)

		self.Castbar.PostCastStart = T.PostCastStart
		self.Castbar.PostChannelStart = T.PostCastStart

		if( C["unitframes"].cbicons == true ) then
			self.Castbar:Width(181)
			self.Castbar.button:ClearAllPoints()
			self.Castbar.button:SetPoint("RIGHT", self.Castbar, "LEFT", -3, 0)
			self.Castbar.button:Size(16)
			self.Castbar.icon:Point("TOPLEFT", self.Castbar.button, 0, 0)
			self.Castbar.icon:Point("BOTTOMRIGHT", self.Castbar.button, 0, 0)
		else
			self.Castbar:Width(self:GetWidth())
			self.Castbar.button:Kill()
		end
	end
		
---------------------------------------------------------------		
-- Auras
---------------------------------------------------------------			
self.Debuffs:SetHeight(26)
self.Debuffs:SetWidth(200)
self.Debuffs.size = 26
self.Debuffs.num = 4
self.Debuffs.spacing = 3

self.Debuffs:ClearAllPoints()
self.Debuffs:Point("LEFT", self, "RIGHT", 3, 0)
self.Debuffs.ClearAllPoints = T.dummy
self.Debuffs.SetPoint = T.dummy

self.Buffs:SetHeight(26)
self.Buffs:SetWidth(200)
self.Buffs.size = 26
self.Buffs.num = 4
self.Buffs.spacing = 3

self.Buffs:ClearAllPoints()
self.Buffs:Point("RIGHT", self, "LEFT", -3, 0)
self.Buffs.ClearAllPoints = T.dummy
self.Buffs.SetPoint = T.dummy

self.Debuffs.initialAnchor = "LEFT"
self.Debuffs["growth-x"] = "RIGHT"

self.Buffs.initialAnchor = "RIGHT"
self.Buffs["growth-x"] = "LEFT"
			
self.Debuffs.onlyShowPlayer = true

	if(self.Debuffs or self.Buffs) then
		for _, frames in pairs({self.Debuffs, self.Buffs}) do
			if(not frames) then return end

			frames:Size(200, 26)
			frames.size = 26
			frames.num = 4
					
			hooksecurefunc(frames, "PostCreateIcon", T.SkinAura)
		end
	end
end