local T, C, L, G = unpack(Tukui)

if( C["unitframes"].enable ~= true ) then return end

--------------------------------------------------------------
-- local Variables
--------------------------------------------------------------
local self = TukuiPet

self:Size(130, 20)
self.panel:Kill()
self.shadow:Kill()

self:SetBackdrop(nil)
self:SetBackdropColor(0, 0, 0)

--------------------------------------------------------------
-- Health
--------------------------------------------------------------
self.Health:Size(self:GetWidth(), 20)
self.Health:SetFrameLevel(5)
self.Health:RobSkin()

self.Health.bg:SetVertexColor(0.5, 0.5, 0.5)		

if(C["unitframes"].unicolor == true) then
	self.Health:SetStatusBarColor(unpack(C["media"].unitframecolor))
	self.Health.bg:SetTexture(unpack(C["media"].backdropcolor))
end

self.Name:SetFont(T.CreateFontString())
self.Name:Point("CENTER", self, "CENTER", 0, 0)

--------------------------------------------------------------
-- Power
--------------------------------------------------------------
self.Power:Kill()
	
--------------------------------------------------------------
-- Castbar
--------------------------------------------------------------
self.Castbar:Kill()