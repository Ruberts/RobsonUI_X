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
		"showSolo", false,
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
	self:SetBackdropColor(0, 0, 0, 0)
	self:CreateBorder(false, true)
	
	local panel = CreateFrame("Frame", nil, self)
	panel:Point("TOPRIGHT", self, "TOPRIGHT", 0, 0)
	panel:Point("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
	panel:Size(100, 20)
	panel:SetFrameLevel(1)
	self.panel = panel

	--------------------------------------------------------------
	-- Health
	--------------------------------------------------------------
	self.Health:ClearAllPoints()
	self.Health:SetAllPoints(self)
	self.Health:SetStatusBarTexture(C["media"].normTex)
	
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
			if( not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit)) then return end
			local hover = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
			if(not hover) then return end
			self.Health:SetStatusBarColor(hover.r, hover.g, hover.b)
		end)
		self:HookScript("OnLeave", function(self)
			if(not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit)) then return end
			self.Health:SetStatusBarColor(0.2, 0.2, 0.2, 1)
		end)
	end

	if(C["unitframes"].gradienthealth == true and C["unitframes"].unicolor == true) then
		self:HookScript("OnEnter", function(self)
			if(not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit)) then return end
			local hover = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
			if(not hover) then return end
			self.Health:SetStatusBarColor(hover.r, hover.g, hover.b)
		end)
		self:HookScript("OnLeave", function(self)
			if(not UnitIsConnected(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit)) then return end
			local r, g, b = oUFTukui.ColorGradient(UnitHealth(self.unit) / UnitHealthMax(self.unit), unpack(C["unitframes"]["gradient"]))
			self.Health:SetStatusBarColor(r, g, b)
		end)
	end
	--------------------------------------------------------------
	-- Power
	--------------------------------------------------------------
	self.Power:Kill()
	
	--------------------------------------------------------------
	-- Name
	--------------------------------------------------------------
	self.Name:ClearAllPoints()
	self.Name:SetParent(self.Health)
	self.Name:SetPoint("LEFT", self.Health, "RIGHT", 4, 0)
	self.Name:SetShadowOffset(0, 0)
	self.Name:SetFont(T.CreateFontString())
	self.Name:SetAlpha(1)
	
	--------------------------------------------------------------
	-- Auras
	--------------------------------------------------------------
	if(C["unitframes"]["raidunitdebuffwatch"] == true) then
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
	
	if (C["unitframes"].debuffhighlight == true) then
		local dbh = self.Health:CreateTexture(nil, "OVERLAY")
		dbh:SetAllPoints(self.Health)
		dbh:SetTexture(C["media"].normTex)
		dbh:SetBlendMode("ADD")
		dbh:SetVertexColor(0, 0, 0, 0)
		self.DebuffHighlight = dbh
		
		self.DebuffHighlightFilter = true
	end
	
	--------------------------------------------------------------
	-- Icons
	--------------------------------------------------------------
	local LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRole:Size(14)
	LFDRole:Point("RIGHT", -2, 0)
	LFDRole.Override = T.SetGridGroupRole
	self.LFDRole = LFDRole
	
	local ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Size(12)
	ReadyCheck:SetPoint("CENTER")
	self.ReadyCheck = ReadyCheck
	
	self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
	self.Leader:SetSize(12, 12)
	self.Leader:SetPoint("TOPLEFT", self.Health, 1, 0)

	self.Assistant = self.Health:CreateTexture(nil, "OVERLAY")
	self.Assistant:SetSize(12, 12)
	self.Assistant:SetPoint("TOPLEFT", self.Health, 1, 0)

	self.MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
	self.MasterLooter:SetSize(12, 12)
	self.MasterLooter:SetPoint("RIGHT", self.Leader, 13, 0)

end
--------------------------------------------------------------
-- Position
--------------------------------------------------------------
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