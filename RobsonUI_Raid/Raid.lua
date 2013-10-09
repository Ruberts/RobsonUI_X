local T, C, L, G = unpack(Tukui)

T.RaidFrameAttributes = function()
	return
		"TukuiRaid",
		nil,
		"solo,raid,party",
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]],
		"initial-width", 100,
		"initial-height", 20,
		"showParty", true,
		"showRaid", true,
		"showPlayer", true,
		"showSolo", true,
		"xoffset", T.Scale(3),
		"yOffset", T.Scale(3),
		"point", "LEFT",
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", "GROUP",
		"maxColumns", 25,
		"unitsPerColumn", 1,
		"columnSpacing", T.Scale(3),
		"columnAnchorPoint", "BOTTOM"
end

T.PostUpdateRaidUnit = function(self)

	self.panel:Kill()
	self:SetBackdropColor( 0.0, 0.0, 0.0, 0.0 )
	self:SetFrameStrata("LOW")
	self:CreateBorder(false, true)

	-- Health

	self.Health:ClearAllPoints()
	self.Health:SetAllPoints(self)
	self.Health:SetStatusBarTexture(C["media"].normTex)
	self.Health:SetFrameLevel(self:GetFrameLevel())
	
	self.Health.colorDisconnected = false
	self.Health.colorClass = false
	self.Health:SetStatusBarColor(unpack(C["media"].unitframecolor))
	self.Health.bg:SetTexture(unpack(C["media"].backdropcolor))
	if C["unitframes"].unicolor == true then
		self.Health.bg:SetVertexColor(0.5, 0.5, 0.5)
	else
		self.Health.bg:SetVertexColor(0.05, 0.05, 0.05)
	end
	self.Health.value:Point("CENTER", self.Health, 0, 0)
	self.Health.value:SetFont(T.CreateFontString())
	self.Health.value:SetShadowOffset(0, 0)
	

	if(C["unitframes"].unicolor == true) then
		self.Health.colorDisconnected = false
		self.Health.colorClass = false
		self.Health:SetStatusBarColor(0.2, 0.2, 0.2, 1)
		self.Health.bg:SetVertexColor(0.05, 0.05, 0.05, 1)
	else
		self.Health.colorDisconnected = true
		self.Health.colorClass = true
		self.Health.colorReaction = true
	end
	
	if(C["unitframes"].unicolor == true) then
		self:HookScript("OnEnter", function(self)
			if( not UnitIsConnected( self.unit ) or UnitIsDead(self.unit) or UnitIsGhost(self.unit)) then return end
			local hover = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
			if(not hover) then return end
			self.Health:SetStatusBarColor(hover.r, hover.g, hover.b)
		end)

		self:HookScript("OnLeave", function(self)
			if(not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit)) then return end
			self.Health:SetStatusBarColor(0.2, 0.2, 0.2, 1)
		end)
	end

	if( C["unitframes"].gradienthealth == true and C["unitframes"].unicolor == true ) then
		self:HookScript("OnEnter", function(self)
			if(not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit)) then return end
			local hover = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
			if(not hover) then return end
			self.Health:SetStatusBarColor(hover.r, hover.g, hover.b)
		end)

		self:HookScript("OnLeave", function(self)
			if(not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit)) then return end
			local r, g, b = oUFTukui.ColorGradient(UnitHealth(self.unit) / UnitHealthMax(self.unit), unpack(C["unitframes"]["gradient"]))
			self.Health:SetStatusBarColor( r, g, b )
		end )
	end

	-- Power.

	self.Power:ClearAllPoints()
	self.Power:SetPoint("TOP", self, "BOTTOM", 0, -3)
	self.Power:SetHeight(2)
	self.Power:SetWidth(68)
	self.Power:SetFrameLevel(self:GetFrameLevel())
	self.Power:CreateBackdrop("Default")
	self.Power:Kill()
	
	-- Name
	
	self.Name:ClearAllPoints()
	self.Name:SetParent(self.Health)
	self.Name:SetPoint("LEFT", self.Health, "RIGHT", 4, 0)
	self.Name:SetShadowOffset(0, 0)
	self.Name:SetFont(T.CreateFontString())
	self.Name:SetAlpha(1)

	-- Debuffs
	
	if( C["unitframes"]["raidunitdebuffwatch"] == true ) then
		self.RaidDebuffs:Height(16 * C["unitframes"]["gridscale"])
		self.RaidDebuffs:Width(16 * C["unitframes"]["gridscale"])
		self.RaidDebuffs:Point("LEFT", self.Health, 2, 0)
		
		self.RaidDebuffs.icon:Point("TOPLEFT", 0, 0)
		self.RaidDebuffs.icon:Point("BOTTOMRIGHT", 0, 0)

		self.RaidDebuffs.count:ClearAllPoints()
		self.RaidDebuffs.count:SetPoint("BOTTOMRIGHT", self.RaidDebuffs, 0, 0)
		self.RaidDebuffs.count:SetFont(T.CreateFontString())
		self.RaidDebuffs.count:SetShadowOffset(0, 0)

		self.RaidDebuffs.time:ClearAllPoints()
		self.RaidDebuffs.time:SetPoint("CENTER", self.RaidDebuffs, 0, 0)
		self.RaidDebuffs.time:SetFont(T.CreateFontString())
		self.RaidDebuffs.time:SetShadowOffset(0, 0)
	end

	-- Icons

	local LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRole:Size(14)
	LFDRole:Point("RIGHT", -2, 0)
	LFDRole.Override = T.SetGridGroupRole
	self.LFDRole = LFDRole
	
	local ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Size(12)
	ReadyCheck:SetPoint("CENTER")
	self.ReadyCheck = ReadyCheck
	
	if C["unitframes"].showsymbols == true then
		local RaidIcon = health:CreateTexture(nil, "OVERLAY")
		RaidIcon:Height(18*T.raidscale)
		RaidIcon:Width(18*T.raidscale)
		RaidIcon:SetPoint("CENTER", self, "TOP")
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp")
		RaidIcon.SetTexture = T.dummy
		self.RaidIcon = RaidIcon
	end
end

local TukuiRaidPosition = CreateFrame("Frame")
TukuiRaidPosition:RegisterEvent("PLAYER_LOGIN")
TukuiRaidPosition:SetScript("OnEvent", function(self, event)
	local raid = G.UnitFrames.RaidUnits
	
	raid:ClearAllPoints()
	raid:SetPoint("BOTTOMLEFT", RobsonLeftChat, "TOPLEFT", 0, 23)
	
	if C["unitframes"].showraidpets == true then
	local pets = G.UnitFrames.RaidPets
		pets:ClearAllPoints()
	end

end)