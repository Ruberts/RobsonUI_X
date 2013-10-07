local T, C, L, G = unpack(Tukui)

T.RaidFrameAttributes = function()
	return
		"TukuiRaid",
		nil,
		"solo,raid,party",
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth( header:GetAttribute( "initial-width" ) )
			self:SetHeight( header:GetAttribute( "initial-height" ) )
		]],
		"initial-width", 69,
		"initial-height", 30,
		"showParty", true,
		"showRaid", true,
		"showPlayer", true,
		"showSolo", false,
		"xoffset", T.Scale(7),
		"yOffset", T.Scale(7),
		"point", "LEFT",
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", "GROUP",
		"maxColumns", 8,
		"unitsPerColumn", 5,
		"columnSpacing", T.Scale(7),
		"columnAnchorPoint", "BOTTOM"
end

T.PostUpdateRaidUnit = function( self )
	------------------------------
	-- misc
	------------------------------
	self.panel:Kill()
	self:SetBackdropColor( 0.0, 0.0, 0.0, 0.0 )

	------------------------------
	-- health
	------------------------------
	self.Health:ClearAllPoints()
	self.Health:SetAllPoints( self )
	self.Health:SetStatusBarTexture(C.media.normTex)
	self.Health:CreateBorder(false, true)
	self.Health:SetFrameStrata("LOW")

	self.Health.colorDisconnected = false
	self.Health.colorClass = false
	self.Health:SetStatusBarColor( 0.2, 0.2, 0.2, 1 )
	self.Health.bg:SetTexture( 0.2, 0.2, 0.2 )
	if C.unitframes.unicolor == true then
		self.Health.bg:SetVertexColor( 0.6, 0.5, 0.5 )
	else
		self.Health.bg:SetVertexColor( 0.05, 0.05, 0.05 )
	end

	self.Health.value:Point( "CENTER", self.Health, 1, -6 )
	self.Health.value:SetFont( T.CreateFontString() )
	self.Health.value:SetShadowOffset(0, 0)
	
	--Border for the health bar.
	local healthBG = CreateFrame("Frame", healthBG, self.Health)
	healthBG:SetTemplate("Default")
	healthBG:ClearAllPoints()
	healthBG:SetPoint("TOPLEFT", -2, 2)
	healthBG:SetPoint("BOTTOMRIGHT", 2, -2)
	healthBG:CreateBorder(true, true)
	healthBG:SetFrameStrata("Background")
	healthBG:CreateShadow("Default")
	healthBG:HideInsets()

	if( C["unitframes"]["unicolor"] == true ) then
		self.Health.colorDisconnected = false
		self.Health.colorClass = false
		self.Health:SetStatusBarColor( 0.2, 0.2, 0.2, 1 )
		self.Health.bg:SetVertexColor( 0.05, 0.05, 0.05, 1 )
	else
		self.Health.colorDisconnected = true
		self.Health.colorClass = true
		self.Health.colorReaction = true
	end

	if( C["unitframes"]["gradienthealth"] == true and C["unitframes"]["unicolor"] == true ) then
		self:HookScript( "OnEnter", function( self )
			if( not UnitIsConnected( self.unit ) or UnitIsDead( self.unit ) or UnitIsGhost( self.unit ) ) then return end
			local hover = RAID_CLASS_COLORS[select( 2, UnitClass( self.unit ) )]
			if( not hover ) then return end
			self.Health:SetStatusBarColor( hover.r, hover.g, hover.b )
		end)

		self:HookScript( "OnLeave", function( self )
			if( not UnitIsConnected( self.unit ) or UnitIsDead( self.unit ) or UnitIsGhost( self.unit ) ) then return end
			local r, g, b = oUFTukui.ColorGradient( UnitHealth( self.unit ) / UnitHealthMax( self.unit ), unpack( C["unitframes"]["gradient"] ) )
			self.Health:SetStatusBarColor( r, g, b )
		end )
	end

	------------------------------
	-- Power.
	------------------------------
	
	self.Power:ClearAllPoints()
	self.Power:SetPoint("BOTTOM", self.Health, "BOTTOM", 0, 1)
	self.Power:SetHeight(1)
	self.Power:SetWidth(69)
	self.Power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	self.Power:SetFrameStrata("MEDIUM")
	self.Power:CreateBorder(false, true)
	
	------------------------------
	-- name
	------------------------------
	self.Name:SetParent( self.Health )
	self.Name:ClearAllPoints()
	self.Name:SetPoint( "CENTER", 0, 6)
	self.Name:SetShadowOffset( 0, 0 )
	self.Name:SetFont( T.CreateFontString() )
	self.Name:SetAlpha(1)

	------------------------------
	-- debuffs
	------------------------------
	if( C["unitframes"]["raidunitdebuffwatch"] == true ) then
		self.RaidDebuffs:Height( 21 * C["unitframes"]["gridscale"] )
		self.RaidDebuffs:Width( 21 * C["unitframes"]["gridscale"] )
		self.RaidDebuffs:Point( "CENTER", self.Health, 2, 1 )

		self.RaidDebuffs.count:ClearAllPoints()
		self.RaidDebuffs.count:SetPoint( "CENTER", self.Health, -6, 6 )
		self.RaidDebuffs.count:SetFont( T.CreateFontString() )

		self.RaidDebuffs.time:ClearAllPoints()
		self.RaidDebuffs.time:SetPoint( "CENTER", self.Health, 2, 0 )
		self.RaidDebuffs.time:SetFont( T.CreateFontString() )
	end

	------------------------------
	-- icons
	------------------------------

	local LFDRole = self.Health:CreateTexture( nil, "OVERLAY" )
	LFDRole:Height( 5 )
	LFDRole:Width( 5 )
	LFDRole:Point( "RIGHT", -3, 0 )
	LFDRole:SetTexture( "Interface\\AddOns\\Tukui\\medias\\textures\\lfdicons.blp" )
	self.LFDRole = LFDRole

	local Resurrect = CreateFrame( "Frame", nil, self.Health )
	Resurrect:SetFrameLevel( self.Health:GetFrameLevel() + 1 )
	Resurrect:Size( 20 )
	Resurrect:SetPoint( "CENTER" )

	local ResurrectIcon = Resurrect:CreateTexture( nil, "OVERLAY" )
	ResurrectIcon:SetAllPoints()
	ResurrectIcon:SetDrawLayer( "OVERLAY", 7 )
	self.ResurrectIcon = ResurrectIcon
end

local TukuiRaidPosition = CreateFrame( "Frame" )
TukuiRaidPosition:RegisterEvent( "PLAYER_LOGIN" )
TukuiRaidPosition:SetScript( "OnEvent", function( self, event )
	local raid = G.UnitFrames.RaidUnits
	local pets = G.UnitFrames.RaidPets
	raid:ClearAllPoints()
	pets:ClearAllPoints()

	raid:SetPoint( "BOTTOMLEFT", TukuiBar1, "TOPLEFT", 2, 23 )
	pets:SetPoint("LEFT", UIParent, "LEFT", -1000, 0)
end )





-------------------------------------------
-- Time to fix some UnitFrames stuff. :3
-------------------------------------------

-- Positions.
	local FramePositions = CreateFrame( "Frame" )
	FramePositions:RegisterEvent( "PLAYER_ENTERING_WORLD" )
	FramePositions:SetScript( "OnEvent", function( self, event, addon )
	G.UnitFrames.Player:ClearAllPoints()
	G.UnitFrames.Target:ClearAllPoints()
	G.UnitFrames.TargetTarget:ClearAllPoints()
	G.UnitFrames.Pet:ClearAllPoints()
	G.UnitFrames.Focus:ClearAllPoints()
	G.UnitFrames.FocusTarget:ClearAllPoints()

	G.UnitFrames.Player:SetPoint( "BOTTOMLEFT", TukuiBar1, "TOPLEFT", -254, 150 )
	G.UnitFrames.Target:SetPoint( "BOTTOMRIGHT", TukuiBar1, "TOPRIGHT", 254, 150 )

	G.UnitFrames.TargetTarget:SetPoint( "TOPRIGHT", G.UnitFrames.Target, "BOTTOMRIGHT", 0, -45)
	G.UnitFrames.Pet:SetPoint( "TOPLEFT", G.UnitFrames.Player, "BOTTOMLEFT", 0, -45 )
	G.UnitFrames.Focus:SetPoint( "BOTTOM", UIParent, "BOTTOM", -600, 400)
	G.UnitFrames.FocusTarget:SetPoint( "BOTTOM", G.UnitFrames.Focus, "TOP", 0 , 43)
	

	for i = 1, MAX_BOSS_FRAMES do
		G.UnitFrames["Boss" .. i]:ClearAllPoints()
		if( i == 1 ) then
			G.UnitFrames["Boss" .. i]:SetPoint( "BOTTOM", UIParent, "BOTTOM", 600, 400 )
		else
			G.UnitFrames["Boss" .. i]:SetPoint( "BOTTOM", G.UnitFrames["Boss" .. i - 1], "TOP", 0, 43 )
		end
	end

	for i = 1, 5 do
		G.UnitFrames["Arena" .. i]:ClearAllPoints()
		if( i == 1 ) then
			G.UnitFrames["Arena" .. i]:SetPoint( "BOTTOM", UIParent, "BOTTOM", 600, 400 )
		else
			G.UnitFrames["Arena" .. i]:SetPoint( "BOTTOM", G.UnitFrames["Arena" .. i - 1], "TOP", 0, 43 )
		end
	end	
end)
	

	
-- Player and Target castbars.

G.UnitFrames.Player.Castbar:Width(240)
G.UnitFrames.Player.Castbar:ClearAllPoints()
if C.unitframes.layout == 3 then
G.UnitFrames.Player.Castbar:SetPoint("TOP", G.UnitFrames.Player.Power, "BOTTOM", -6, -7)
else
G.UnitFrames.Player.Castbar:SetPoint("TOP", G.UnitFrames.Player.Power, "BOTTOM", 0, -7)
end

G.UnitFrames.Target.Castbar:Width(240)
G.UnitFrames.Target.Castbar:ClearAllPoints()
if C.unitframes.layout == 3 then
G.UnitFrames.Target.Castbar:SetPoint("TOP", G.UnitFrames.Target.Power, "BOTTOM", 6, -7)
else
G.UnitFrames.Target.Castbar:SetPoint("TOP", G.UnitFrames.Target.Power, "BOTTOM", 0, -7)
end