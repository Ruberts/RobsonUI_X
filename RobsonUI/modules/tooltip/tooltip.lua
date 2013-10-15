local T, C, L, G = unpack(Tukui)

if not C["tooltip"].enable then return end

local anchor = TukuiTooltipAnchor

TukuiAltPowerBar:HookScript("OnShow", function(self)
	anchor:Point("BOTTOMRIGHT", RobsonAltPower, "TOPRIGHT", 0, -24)
end)
TukuiAltPowerBar:HookScript("OnHide", function(self)	
	anchor:Point("BOTTOMRIGHT", RobsonRightChat, "TOPRIGHT", 0, -24)
end)

local TukuiTooltip = CreateFrame("Frame", "TukuiTooltip", UIParent)
local _G = getfenv(0)
local GameTooltip, GameTooltipStatusBar = _G["GameTooltip"], _G["GameTooltipStatusBar"]
local gsub, find, format = string.gsub, string.find, string.format
local Tooltips = {GameTooltip,ItemRefShoppingTooltip1,ItemRefShoppingTooltip2,ItemRefShoppingTooltip3,ShoppingTooltip1,ShoppingTooltip2,ShoppingTooltip3,WorldMapTooltip,WorldMapCompareTooltip1,WorldMapCompareTooltip2,WorldMapCompareTooltip3}
local ItemRefTooltip = ItemRefTooltip
local anchor = G.Tooltips.GameTooltip.Anchor

G.Tooltips.GameTooltip = GameTooltip
G.Tooltips.ShoppingTooltip1 = ShoppingTooltip1
G.Tooltips.ShoppingTooltip2 = ShoppingTooltip2
G.Tooltips.ShoppingTooltip3 = ShoppingTooltip3
G.Tooltips.WorldMapTooltip = WorldMapTooltip
G.Tooltips.WorldMapCompareTooltip1 = WorldMapCompareTooltip1
G.Tooltips.WorldMapCompareTooltip2 = WorldMapCompareTooltip2
G.Tooltips.GameTooltip = GameTooltip
G.Tooltips.WorldMapCompareTooltip3 = ItemRefTooltip

local linkTypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true}

local classification = {
	worldboss = "|cffAF5050Boss|r",
	rareelite = "|cffAF5050+ Rare|r",
	elite = "|cffAF5050+|r",
	rare = "|cffAF5050Rare|r",
}

local NeedBackdropBorderRefresh = true

TukuiTooltip:SetClampedToScreen(false)


TukuiTooltipAnchor:SetFrameLevel(20)
TukuiTooltipAnchor:SetClampedToScreen(false)

-- Update Tukui Tooltip Position on some specifics Tooltip
-- Also used because on Eyefinity, SetClampedToScreen doesn't work on left and right side of screen #1
local function UpdateTooltip(self)
	local owner = self:GetOwner()
	if not owner then return end	
	local name = owner:GetName()
	
	-- fix X-offset or Y-offset
	local x = T.Scale(4)
	
	-- mouseover
	if self:GetAnchorType() == "ANCHOR_CURSOR" then
		-- h4x for world object tooltip border showing last border color 
		-- or showing background sometime ~blue :x		
		if NeedBackdropBorderRefresh then
			self:ClearAllPoints()
			NeedBackdropBorderRefresh = false			
			self:SetBackdropBorderColor(0,0,0,0)
			self:HideInsets()
			self:CreateBorder(false, true)
			if not C["tooltip"].cursor then
				self:SetBackdropBorderColor(0,0,0,0)
				self:HideInsets()
				self:CreateBorder(false, true)
			end
		end
	elseif self:GetAnchorType() == "ANCHOR_NONE" and InCombatLockdown() and C["tooltip"].hidecombat == true then
		self:Hide()
		return
	end
	
	if name and (TukuiPlayerBuffs or TukuiPlayerDebuffs) then
		if (TukuiPlayerBuffs:GetPoint():match("LEFT") or TukuiPlayerDebuffs:GetPoint():match("LEFT")) and (name:match("TukuiPlayerBuffs") or name:match("TukuiPlayerDebuffs")) then
			self:SetAnchorType("ANCHOR_BOTTOMRIGHT", x, -x)
		end
	end
		
	if (owner == MiniMapBattlefieldFrame or owner == MiniMapMailFrame) and TukuiMinimap then
		if TukuiMinimap:GetPoint():match("LEFT") then 
			self:SetAnchorType("ANCHOR_TOPRIGHT", x, -x)
		end
	end
	
	if self:GetAnchorType() == "ANCHOR_NONE" and TukuiTooltipAnchor then
		local point = TukuiTooltipAnchor:GetPoint()
		if point == "TOPLEFT" then
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", TukuiTooltipAnchor, "BOTTOMLEFT", 0, -x)			
		elseif point == "TOP" then
			self:ClearAllPoints()
			self:SetPoint("TOP", TukuiTooltipAnchor, "BOTTOM", 0, -x)			
		elseif point == "TOPRIGHT" then
			self:ClearAllPoints()
			self:SetPoint("TOPRIGHT", TukuiTooltipAnchor, "BOTTOMRIGHT", 0, -x)			
		elseif point == "BOTTOMLEFT" or point == "LEFT" then
			self:ClearAllPoints()
			self:SetPoint("BOTTOMLEFT", TukuiTooltipAnchor, "TOPLEFT", 0, x)		
		elseif point == "BOTTOMRIGHT" or point == "RIGHT" then
			if TukuiBags and TukuiBags:IsShown() then
				self:ClearAllPoints()
				self:SetPoint("BOTTOMRIGHT", TukuiBags, "TOPRIGHT", 0, 3)			
			else
				self:ClearAllPoints()
				self:SetPoint("BOTTOMRIGHT", TukuiTooltipAnchor, "TOPRIGHT", 0, x)
			end
		else
			self:ClearAllPoints()
			self:SetPoint("BOTTOM", TukuiTooltipAnchor, "TOP", 0, x)		
		end
	end
end

local function SetTooltipDefaultAnchor(self, parent)
	if C["tooltip"].cursor == true then
		if parent ~= UIParent then
			self:SetOwner(parent, "ANCHOR_NONE")
		else
			self:SetOwner(parent, "ANCHOR_CURSOR")
		end
	else
		self:SetOwner(parent, "ANCHOR_NONE")
	end
	
	self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -111111, -111111) -- hack to update GameStatusBar instantly.
end
hooksecurefunc("GameTooltip_SetDefaultAnchor", SetTooltipDefaultAnchor)

GameTooltip:HookScript("OnUpdate", function(self, ...) UpdateTooltip(self) end)

local function Hex(color)
	return string.format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
end

local function GetColor(unit)
	if(UnitIsPlayer(unit) and not UnitHasVehicleUI(unit)) then
		local _, class = UnitClass(unit)
		local color = RAID_CLASS_COLORS[class]
		if not color then return end -- sometime unit too far away return nil for color :(
		local r,g,b = color.r, color.g, color.b
		return Hex(color), r, g, b, 0	
	else
		local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
		if not color then return end -- sometime unit too far away return nil for color :(
		local r,g,b = color.r, color.g, color.b		
		return Hex(color), r, g, b, 0		
	end
end

-- function to short-display HP value on StatusBar
local function ShortValue(value)
	if value >= 1e7 then
		return ('%.1fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif value >= 1e6 then
		return ('%.2fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif value >= 1e5 then
		return ('%.0fk'):format(value / 1e3)
	elseif value >= 1e3 then
		return ('%.1fk'):format(value / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return value
	end
end

-- update HP value on status bar
local function StatusBarOnValueChanged(self, value)
	if not value then
		return
	end
	local min, max = self:GetMinMaxValues()
	
	if (value < min) or (value > max) then
		return
	end
	local _, unit = GameTooltip:GetUnit()
	
	-- fix target of target returning nil
	if (not unit) then
		local GMF = GetMouseFocus()
		unit = GMF and GMF:GetAttribute("unit")
	end

	if not self.text then
		self.text = self:CreateFontString(nil, "OVERLAY")
		local position = TukuiTooltipAnchor:GetPoint()
		if position:match("TOP") then
			self.text:Point("CENTER", GameTooltipStatusBar, 0, -8)
		else
			self.text:Point("CENTER", GameTooltipStatusBar, 0, 8)
		end
		
		self.text:SetFont(T.CreateFontString())
		self.text:Show()
		if unit then
			min, max = UnitHealth(unit), UnitHealthMax(unit)
			local hp = ShortValue(min).." / "..ShortValue(max)
			if UnitIsGhost(unit) then
				self.text:SetText(L.unitframes_ouf_ghost)
			elseif min == 0 or UnitIsDead(unit) or UnitIsGhost(unit) then
				self.text:SetText(L.unitframes_ouf_dead)
			else
				self.text:SetText(hp)
			end
		end
	else
		if unit then
			min, max = UnitHealth(unit), UnitHealthMax(unit)
			self.text:SetFont(T.CreateFontString())
			self.text:Show()
			local hp = ShortValue(min).." / "..ShortValue(max)
			if UnitIsGhost(unit) then
				self.text:SetText(L.unitframes_ouf_ghost)
			elseif min == 0 or UnitIsDead(unit) or UnitIsGhost(unit) then
				self.text:SetText(L.unitframes_ouf_dead)
			else
				self.text:SetText(hp)
			end
		else
			self.text:Hide()
		end
	end
end
GameTooltipStatusBar:SetScript("OnValueChanged", StatusBarOnValueChanged)

local healthBar = GameTooltipStatusBar
healthBar:ClearAllPoints()
healthBar:Height(4)
healthBar:Point("BOTTOMLEFT", healthBar:GetParent(), "TOPLEFT", 0, 3)
healthBar:Point("BOTTOMRIGHT", healthBar:GetParent(), "TOPRIGHT", 0, 3)
healthBar:SetStatusBarTexture(C.media.normTex)
healthBar:RobSkin()
G.Tooltips.GameTooltip.Health = healthBar

local BorderColor = function(self)
	local GMF = GetMouseFocus()
	local unit = (select(2, self:GetUnit())) or (GMF and GMF:GetAttribute("unit"))
		
	local reaction = unit and UnitReaction(unit, "player")
	local player = unit and UnitIsPlayer(unit)
	local tapped = unit and UnitIsTapped(unit)
	local tappedbyme = unit and UnitIsTappedByPlayer(unit)
	local connected = unit and UnitIsConnected(unit)
	local dead = unit and UnitIsDead(unit)
	local r, g, b

	if player then
		local class = select(2, UnitClass(unit))
		local c = T.UnitColor.class[class]
		r, g, b = c[1], c[2], c[3]
		self:SetBackdropBorderColor(0, 0, 0, 0)
		self:HideInsets()
		self:CreateBorder(false, true)
		healthBar:SetStatusBarColor(r, g, b)
		healthBar:HideInsets()
		healthBar:CreateBorder(false, true)
	elseif reaction then
		local c = T.UnitColor.reaction[reaction]
		r, g, b = c[1], c[2], c[3]
		self:SetBackdropBorderColor(0, 0, 0, 0)
		self:HideInsets()
		self:CreateBorder(false, true)
		healthBar:SetStatusBarColor(r, g, b)
		healthBar:HideInsets()
		healthBar:CreateBorder(false, true)
	else
		local _, link = self:GetItem()
		local quality = link and select(3, GetItemInfo(link))
		if quality and quality >= 2 then
			local r, g, b = GetItemQualityColor(quality)
			self:SetBackdropBorderColor(0, 0, 0, 0)
			self:HideInsets()
			self:CreateBorder(false, true)
		else
			self:SetBackdropBorderColor(0,0,0,0)
			self:HideInsets()
			self:CreateBorder(false, true)
			healthBar:HideInsets()
			healthBar:CreateBorder(false, true)
		end
	end
	
	-- need this
	NeedBackdropBorderRefresh = true
end

local SetStyle = function(self)
	self:SetTemplate("Transparent")
	BorderColor(self)
end

TukuiTooltip:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiTooltip:RegisterEvent("ADDON_LOADED")
TukuiTooltip:SetScript("OnEvent", function(self, event, addon)
	if event == "PLAYER_ENTERING_WORLD" then
		for _, tt in pairs(Tooltips) do
			tt:HookScript("OnShow", SetStyle)
		end
		
		ItemRefTooltip:HookScript("OnTooltipSetItem", SetStyle)
		ItemRefTooltip:HookScript("OnShow", SetStyle)	
		FriendsTooltip:SetTemplate("Transparent")
		FriendsTooltip:SetBackdropBorderColor(0,0,0,0)
		FriendsTooltip:HideInsets()
		FriendsTooltip:CreateBorder(false, true)
		ItemRefCloseButton:SkinCloseButton()
			
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		
		-- move health status bar if anchor is found at top
		local position = TukuiTooltipAnchor:GetPoint()
		if position:match("TOP") then
			healthBar:ClearAllPoints()
			healthBar:Point("TOPLEFT", healthBar:GetParent(), "BOTTOMLEFT", 0, -3)
			healthBar:Point("TOPRIGHT", healthBar:GetParent(), "BOTTOMRIGHT", 0, -3)
		end
		
		-- Hide tooltips in combat for actions, pet actions and shapeshift
		if C["tooltip"].hidebuttons == true then
			local CombatHideActionButtonsTooltip = function(self)
				if not IsShiftKeyDown() then
					self:Hide()
				end
			end
		 
			hooksecurefunc(GameTooltip, "SetAction", CombatHideActionButtonsTooltip)
			hooksecurefunc(GameTooltip, "SetPetAction", CombatHideActionButtonsTooltip)
			hooksecurefunc(GameTooltip, "SetShapeshift", CombatHideActionButtonsTooltip)
		end
	else
		if addon ~= "Blizzard_DebugTools" then return end
		
		if FrameStackTooltip then
			FrameStackTooltip:SetScale(C.general.uiscale)
			
			-- Skin it
			FrameStackTooltip:HookScript("OnShow", function(self) 
			self:RobSkin()
			end)
		end
		
		if EventTraceTooltip then
			EventTraceTooltip:HookScript("OnShow", function(self) 
			self:RobSkin()
			end)
		end
	end
end)
G.Tooltips.Init = TukuiTooltip