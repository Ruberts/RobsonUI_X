local T, C, L, G  = unpack(Tukui)

if not C["nameplate"].robson == true and C["nameplate"].enable ~= true then return end

local frames, numChildren, select = {}, -1, select
local noscalemult = T.mult * C["general"].uiscale

local NamePlates = CreateFrame("Frame", nil, UIParent)
NamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
if C["nameplate"].debuffs == true then
	NamePlates:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local function QueueObject(frame, object)
	frame.queue = frame.queue or {}
	frame.queue[object] = true
 end

local PlateBlacklist = {
	["Earth Elemental Totem"] = true,
	["Fire Elemental Totem"] = true,
	["Fire Resistance Totem"] = true,
	["Flametongue Totem"] = true,
	["Frost Resistance Totem"] = true,
	["Healing Stream Totem"] = true,
	["Magma Totem"] = true,
	["Mana Spring Totem"] = true,
	["Nature Resistance Totem"] = true,
	["Searing Totem"] = true,
	["Stoneclaw Totem"] = true,
	["Stoneskin Totem"] = true,
	["Strength of Earth Totem"] = true,
	["Windfury Totem"] = true,
	["Totem of Wrath"] = true,
	["Wrath of Air Totem"] = true,

	["Army of the Dead Ghoul"] = true,
}
local function HideObjects(frame)
 	for object in pairs(frame.queue) do
		if object:GetObjectType() == "Texture" then
			object:SetTexture(nil)
		elseif object:GetObjectType() == "FontString" then
			object:SetWidth(0.001)
		else
			object:Hide()
		end
	end
end

-- Create a fake backdrop frame using textures
local function CreateVirtualFrame(frame, point)
	if point == nil then point = frame end
	if point.backdrop then return end

	frame.backdrop = frame:CreateTexture(nil, "BORDER")
	frame.backdrop:SetDrawLayer("BORDER", -8)
	frame.backdrop:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult, noscalemult)
	frame.backdrop:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", noscalemult, -noscalemult)
	frame.backdrop:SetTexture(unpack(C["media"].backdropcolor))
end

local function SetVirtualBorder(frame, r, g, b, a)
	frame.backdrop:SetTexture(r, g, b)
end

-- Create aura icons
local function CreateAuraIcon(frame)
	local button = CreateFrame("Frame", nil, frame)
	button:SetParent(frame.hp)
	button:SetWidth(23)
	button:SetHeight(16)

	button.bg = button:CreateTexture(nil, "ARTWORK")
	button.bg:SetTexture(unpack(C["media"].backdropcolor))
	button.bg:SetPoint("TOPLEFT", button, "TOPLEFT", noscalemult * 2, -noscalemult * 2)
	button.bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -noscalemult * 2, noscalemult * 2)

	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", noscalemult * 3, -noscalemult * 3)
	button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -noscalemult * 3, noscalemult * 3)
	button.icon:SetTexCoord(0.07, 0.93, 0.23, 0.77)

	button.cd = CreateFrame("Cooldown", nil, button)
	button.cd:SetAllPoints(button.icon)
	button.cd:SetReverse(true)

	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:SetFont(C["media"].pixelfont, 9, "MONOCHROMEOUTLINE")
	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)

	return button
end

-- Update an aura icon
local function UpdateAuraIcon(button, unit, index, filter)
	local name, _, icon, count, debuffType, duration, expirationTime, _, _, _, spellID = UnitAura(unit, index, filter)

	button.icon:SetTexture(icon)
	button.cd:SetCooldown(expirationTime - duration, duration)
	button.expirationTime = expirationTime
	button.duration = duration
	button.spellID = spellID
	if count > 1 then
		button.count:SetText(count)
	else
		button.count:SetText("")
	end
	button.cd:SetScript("OnUpdate", function(self)
		if not button.cd.timer then
			self:SetScript("OnUpdate", nil)
			return
		end
		button.cd.timer.text:SetFont(C["media"].pixelfont, 9, "MONOCHROMEOUTLINE")
		button.cd.timer.text:SetPoint("TOPLEFT", button, "TOPLEFT", 3, 0)
		button.cd.timer.text:SetShadowOffset(0, 0)
	end)
	button:Show()
end

-- Filter auras on nameplate, and determine if we need to update them or not
local function OnAura(frame, unit)
	if not frame.icons or not frame.unit then return end
	local i = 1
	for index = 1, 10 do
		if i > 10 then return end
		local match
		local name, _, _, _, _, duration, _, caster, _, _, spellid = UnitAura(frame.unit, index, "HARMFUL")

		if C["nameplate"].debuffs == true then
			if caster == "player" then match = true end
		end

		if duration and match == true then
			if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame) end
			local icon = frame.icons[i]
			if i == 1 then icon:SetPoint("RIGHT", frame.icons, "RIGHT", 2, 0) end
			if i ~= 1 and i <= 5 then icon:SetPoint("RIGHT", frame.icons[i-1], "LEFT", 1, 0) end
			if i ~= 1 and i >= 6 then icon:SetPoint("RIGHT", frame.icons[i-1], "LEFT", 111, 16) end
			if i ~= 1 and i >= 7 then icon:SetPoint("RIGHT", frame.icons[i-1], "LEFT", 0, 0) end
			if i ~= 1 and i >= 8 then icon:SetPoint("RIGHT", frame.icons[i-1], "LEFT", 0, 0) end
			if i ~= 1 and i >= 9 then icon:SetPoint("RIGHT", frame.icons[i-1], "LEFT", 0, 0) end
			if i ~= 1 and i >= 10 then icon:SetPoint("RIGHT", frame.icons[i-1], "LEFT", 0, 0) end
			i = i + 1
			UpdateAuraIcon(icon, frame.unit, index, "HARMFUL")
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

-- Color the castbar depending on if we can interrupt or not
local function UpdateCastbar(frame)
	frame:ClearAllPoints()
	frame:SetSize(C["nameplate"].width * noscalemult, 3)
	frame:SetPoint("TOP", frame:GetParent().hp, "BOTTOM", 0, -3)
	frame:GetStatusBarTexture():SetHorizTile(true)
	if frame.shield:IsShown() then
		frame:SetStatusBarColor(0.78, 0.25, 0.25, 1)
	end
end

-- Determine whether or not the cast is Channelled or a Regular cast so we can grab the proper Cast Name
local function UpdateCastText(frame, curValue)
	local _, maxValue = frame:GetMinMaxValues()

	if UnitChannelInfo("target") then
		frame.time:SetFormattedText("%.1f ", curValue)
		if C["nameplate"].showcastbarname == true then
			frame.name:SetText(select(1, (UnitChannelInfo("target"))))
		end
	end

	if UnitCastingInfo("target") then
		frame.time:SetFormattedText("%.1f ", maxValue - curValue)
		if C["nameplate"].showcastbarname == true then
			frame.name:SetText(select(1, (UnitCastingInfo("target"))))
		end
	end
end

-- Sometimes castbar likes to randomly resize
local OnValueChanged = function(self, curValue)
	UpdateCastText(self, curValue)
	if self.needFix then
		UpdateCastbar(self)
		self.needFix = nil
	end
end

-- Sometimes castbar likes to randomly resize
local OnSizeChanged = function(self)
	self.needFix = true
end

-- We need to reset everything when a nameplate it hidden
local function OnHide(frame)
	frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.hp:SetScale(1)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.unit = nil
	frame.guid = nil
	frame.hasClass = nil
	frame.isFriendly = nil
	frame.isTagged = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil
	frame.hp.shadow:SetAlpha(0)
	if frame.icons then
		for _, icon in ipairs(frame.icons) do
			icon:Hide()
		end
	end

	frame:SetScript("OnUpdate", nil)
end

-- Color Nameplate
local function Colorize(frame)
	local r, g, b = frame.healthOriginal:GetStatusBarColor()
	local texcoord = {0, 0, 0, 0}
	
	for class, _ in pairs(RAID_CLASS_COLORS) do
		local r, g, b = floor(r * 100 + 0.5)/100, floor(g * 100 + 0.5)/100, floor(b * 100 + 0.5)/100
		if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
			frame.hasClass = true
			frame.isFriendly = false
			if C["nameplate"].classicons == true then
				texcoord = CLASS_BUTTONS[class]
				frame.class.Glow:Show()
				frame.class:SetTexCoord(texcoord[1], texcoord[2], texcoord[3], texcoord[4])
			end
			frame.hp:SetStatusBarColor(unpack(oUFTukui.colors.class[class]))
			return
		end
	end
	
	if r + b + b > 2 then	-- Tapped
		r, g, b = 0.55, 0.57, 0.61
	elseif g + b == 0 then	-- Hostile
		r, g, b = 222/255, 95/255,  95/255
		frame.isFriendly = false
	elseif r + b == 0 then	-- Friendly npc
		r, g, b = 0.29, 0.69, 0.29
		frame.isFriendly = true
	elseif r + g > 1.95 then	-- Neutral
		r, g, b = 218/255, 197/255, 92/255
		frame.isFriendly = false
	elseif r + g == 0 then	-- Friendly player
		r, g, b = 75/255,  175/255, 76/255
		frame.isFriendly = true
	else	-- Enemy player
		frame.isFriendly = false
	end
	frame.hasClass = false

	if C["nameplate"].classicons == true then
		if frame.hasClass == true then
			frame.class.Glow:Show()
		else
			frame.class.Glow:Hide()
		end
		frame.class:SetTexCoord(texcoord[1], texcoord[2], texcoord[3], texcoord[4])
	end

	frame.hp:SetStatusBarColor(r, g, b)
	frame.hp.hpbg:SetTexture(unpack(C["media"].backdropcolor))
end

-- HealthBar OnShow, use this to set variables for the nameplate
local function UpdateObjects(frame)
	frame = frame:GetParent()
	
	SetVirtualBorder(frame.hp, 0, 0, 0)
	
	-- Set scale
	while frame.hp:GetEffectiveScale() < 1 do
		frame.hp:SetScale(frame.hp:GetScale() + 0.01)
	end

	-- Have to reposition this here so it doesnt resize after being hidden
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(C["nameplate"].width * noscalemult, C["nameplate"].height * noscalemult)
	frame.hp:SetPoint("TOP", frame, "TOP", 0, -15)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)

	-- Match values
	frame.hp:SetMinMaxValues(frame.healthOriginal:GetMinMaxValues())
	frame.hp:SetValue(frame.healthOriginal:GetValue() - 1) -- Blizzard bug fix
	frame.hp:SetValue(frame.healthOriginal:GetValue())

	-- Set the name text
	frame.hp.name:SetText(frame.hp.oldname:GetText())
	frame.hp.name:SetTextColor(1, 1, 1)

	-- Setup level text
	local level, elite, mylevel = tonumber(frame.hp.oldlevel:GetText()), frame.hp.elite:IsShown(), UnitLevel("player")
	frame.hp.level:ClearAllPoints()
	if C["nameplate"].classicons == true and frame.hasClass == true then
		frame.hp.level:SetPoint("RIGHT", frame.hp.name, "LEFT", -2, 0)
	else
		frame.hp.level:SetPoint("RIGHT", frame.hp, "RIGHT", 0, 11)
	end
	frame.hp.level:SetTextColor(frame.hp.oldlevel:GetTextColor())
	if frame.hp.boss:IsShown() then
		frame.hp.level:SetText("??")
		frame.hp.level:SetTextColor(0.8, 0.05, 0)
		frame.hp.level:Show()
	elseif not elite and level == mylevel then
		frame.hp.level:Hide()
	else
		frame.hp.level:SetText(level..(elite and "+" or ""))
		frame.hp.level:Show()
	end

	frame.overlay:ClearAllPoints()
	frame.overlay:SetAllPoints(frame.hp)

	HideObjects(frame)
end

-- This is where we create most 'Static' objects for the nameplate
local function SkinObjects(frame, nameFrame)
	local oldhp, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local oldname = nameFrame:GetRegions()
	local _, cbborder, cbshield, cbicon, cbname, cbshadow = cb:GetRegions()

	-- Health Bar
	frame.healthOriginal = oldhp
	local hp = CreateFrame("Statusbar", nil, frame)
	hp:SetFrameLevel(oldhp:GetFrameLevel())
	hp:SetFrameStrata(oldhp:GetFrameStrata())
	hp:SetStatusBarTexture(C["media"].normTex)
	hp:CreateShadow()
	hp.shadow:Point("TOPLEFT", hp, -4, 4)
	hp.shadow:Point("BOTTOMLEFT", hp, -4, -4)
	hp.shadow:Point("TOPRIGHT", hp, 4, 4)
	hp.shadow:Point("BOTTOMRIGHT", hp, 4, 4)
	hp.shadow:SetBackdropBorderColor(1, 1, 1, 0.60)
	hp.shadow:SetFrameLevel(0)
	hp.shadow:SetScale(noscalemult)
	hp.shadow:SetAlpha(0)
	CreateVirtualFrame(hp)

	-- Create Level
	hp.level = hp:CreateFontString(nil, "OVERLAY")
	hp.level:SetFont(C["media"].pixelfont, 9, "MONOCHROMEOUTLINE")
	hp.level:SetTextColor(1, 1, 1)
	hp.oldlevel = oldlevel
	hp.boss = bossicon
	hp.elite = elite

	--Create Health Text
	if C["nameplate"].showhealth == true then
		hp.value = hp:CreateFontString(nil, "OVERLAY")	
		hp.value:SetFont(C["media"].font, 9, "THINOUTLINE")
		hp.value:SetPoint("CENTER", hp, 0, -1)
		hp.value:SetTextColor(1,1,1)
		hp.value:SetShadowOffset(T.mult, -T.mult)
	end

	-- Create Name Text
	hp.name = hp:CreateFontString(nil, "OVERLAY")
	hp.name:SetPoint("LEFT", hp, "LEFT", 0, 11)
	hp.name:SetFont(C["media"].pixelfont, 9, "MONOCHROMEOUTLINE")
	hp.oldname = oldname

	hp.hpbg = hp:CreateTexture(nil, "BORDER")
	hp.hpbg:SetAllPoints(hp)
	hp.hpbg:SetTexture(1, 1, 1, 0.25)

	hp:HookScript("OnShow", UpdateObjects)
	frame.hp = hp
	
	if not frame.threat then
		frame.threat = threat
	end

	-- Create Cast Bar
	cb:SetStatusBarTexture(C["media"].normTex)
	CreateVirtualFrame(cb)

	cb.cbbg = cb:CreateTexture(nil, "BORDER")
	cb.cbbg:SetAllPoints(cb)
	cb.cbbg:SetTexture(0.75, 0.75, 0.25, 0.15)

	-- Create Cast Time Text
	cb.time = cb:CreateFontString(nil, "ARTWORK")
	cb.time:SetPoint("RIGHT", cb, "RIGHT", 3, 0)
	cb.time:SetFont(C["media"].pixelfont, 9, "MONOCHROMEOUTLINE")
	cb.time:SetTextColor(1, 1, 1)

	-- Create Cast Name Text
	if C["nameplate"].showcastbarname == true then
		cb.name = cb:CreateFontString(nil, "ARTWORK")
		cb.name:SetPoint("LEFT", cb, "LEFT", 3, 0)
		cb.name:SetFont(C["media"].font, 8, "THINOUTLINE")
		cb.name:SetTextColor(1, 1, 1)
	end

	cbname:Kill()
	cbshadow:SetTexture(nil)
		
		-- Create Class Icon
	if C["nameplate"].classicons == true then
		local cIconTex = hp:CreateTexture(nil, "OVERLAY")
		cIconTex:SetPoint("TOPRIGHT", hp, "TOPLEFT", -5, 1)
		cIconTex:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
		cIconTex:SetSize((C["nameplate"].height * 2)-1, (C["nameplate"].height * 2)-1)
		frame.class = cIconTex

		frame.class.Glow = CreateFrame("Frame", nil, frame)
		frame.class.Glow:SetTemplate("Transparent")
		frame.class.Glow:SetScale(noscalemult)
		frame.class.Glow:SetPoint("TOPLEFT", frame.class, "TOPLEFT", 0, 0)
		frame.class.Glow:SetPoint("BOTTOMRIGHT", frame.class, "BOTTOMRIGHT", 0, 0)
		frame.class.Glow:SetFrameLevel(hp:GetFrameLevel() -1 > 0 and hp:GetFrameLevel() -1 or 0)
		frame.class.Glow:Hide()
	end
	
	-- Create CastBar Icon
	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOPLEFT", hp, "TOPRIGHT", 3, 0)
	cbicon:SetSize((15 * noscalemult) + 4, (15 * noscalemult) + 4)
	cbicon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	cbicon:SetDrawLayer("OVERLAY")
	cb.icon = cbicon
	CreateVirtualFrame(cb, cb.icon)

	cb.shield = cbshield
	cbshield:ClearAllPoints()
	cbshield:SetPoint("TOP", cb, "BOTTOM")
	cb:HookScript("OnShow", UpdateCastbar)
	cb:HookScript("OnSizeChanged", OnSizeChanged)
	cb:HookScript("OnValueChanged", OnValueChanged)
	frame.cb = cb
	
		-- Aura tracking
	if C["nameplate"].debuffs == true then
		if not frame.icons then
			frame.icons = CreateFrame("Frame", nil, frame.hp)
			frame.icons:SetPoint("BOTTOMRIGHT", frame.hp, "TOPRIGHT", 0, 12)
			frame.icons:SetWidth(24)
			frame.icons:SetHeight(16)
			frame.icons:SetFrameLevel(frame.hp:GetFrameLevel() + 2)
			frame:RegisterEvent("UNIT_AURA")
			frame:HookScript("OnEvent", OnAura)
		end
	end

	-- Highlight texture
	if not frame.overlay then
		overlay:SetTexture(1, 1, 1, 0.15)
		overlay:SetParent(frame.hp)
		overlay:SetAllPoints()
		frame.overlay = overlay
	end
	
		-- Raid icon
	if not frame.raidicon then
		raidicon:SetParent(frame.hp)
		raidicon:ClearAllPoints()
		raidicon:SetPoint("BOTTOM", hp, "TOP", 0, C["nameplate"].debuffs == true and 38 or 16)
		raidicon:SetSize((C["nameplate"].height * 2) + 8, (C["nameplate"].height * 2) + 8)
		frame.raidicon = raidicon
	end

	-- Hide Old Stuff
	QueueObject(frame, oldhp)
	QueueObject(frame, oldlevel)
	QueueObject(frame, threat)
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, oldname)
	QueueObject(frame, bossicon)
	QueueObject(frame, elite)

	UpdateObjects(hp)
	UpdateCastbar(cb)

	frame:HookScript("OnHide", OnHide)
	frames[frame] = true
end

local function UpdateThreat(frame, elapsed)
	if frame.threat:IsShown() then
		if Role == "TANK" then
			frame.hp.name:SetTextColor(0, 1, 0)
		else
			frame.hp.name:SetTextColor(1, 0, 0)
		end
	else
		frame.hp.name:SetTextColor(1, 1, 1)
	end
end

-- Create our blacklist for nameplates
local function CheckBlacklist(frame, ...)
	if C["nameplate"].nameabbrev == true then return end
	if PlateBlacklist[frame.hp.name:GetText()] then
		frame:SetScript("OnUpdate", function() end)
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.hp.oldlevel:Hide()
	end
end

-- When becoming intoxicated blizzard likes to re-show the old level text, this should fix that
local function HideDrunkenText(frame, ...)
	if frame and frame.hp.oldlevel and frame.hp.oldlevel:IsShown() then
		frame.hp.oldlevel:Hide()
	end
end

-- Force the name text of a nameplate to be behind other nameplates unless it is our target
local function AdjustNameLevel(frame, ...)
	if UnitName("target") == frame.hp.name:GetText() and frame:GetParent():GetAlpha() == 1 then
		frame.hp.name:SetDrawLayer("OVERLAY")
	else
		frame.hp.name:SetDrawLayer("BORDER")
	end
end

--Health Text, also border coloring for certain plates depending on health
local function ShowHealth(frame, ...)
	-- show current health value
	local _, maxHealth = frame.healthOriginal:GetMinMaxValues()
	local valueHealth = frame.healthOriginal:GetValue()
	local d =(valueHealth/maxHealth)*100

	-- Match values
	frame.hp:SetValue(valueHealth - 1)	--Bug Fix 4.1
	frame.hp:SetValue(valueHealth)

	if C["nameplate"].showhealth == true then
		frame.hp.value:SetText(T.ShortValue(valueHealth).." - "..(string.format("%d%%", math.floor((valueHealth/maxHealth)*100))))
	end

	--Setup frame shadow to change depending on enemy players health, also setup targetted unit to have white shadow
	if frame.hasClass == true or frame.isFriendly == true then
		if(d <= 50 and d >= 20) then
			SetVirtualBorder(frame.hp, 1, 1, 0)
		elseif(d < 20) then
			SetVirtualBorder(frame.hp, 1, 0, 0)
		else
			SetVirtualBorder(frame.hp, 0, 0, 0)
		end
	elseif (frame.hasClass ~= true and frame.isFriendly ~= true) and C["nameplate"].enhancethreat == true then
		SetVirtualBorder(frame.hp, unpack(C["media"].bordercolor))
	end
end

-- Scan all visible nameplate for a known unit
local function CheckUnit_Guid(frame, ...)
	if UnitExists("target") and frame:GetParent():GetAlpha() == 1 and UnitName("target") == frame.hp.name:GetText() then
		frame.guid = UnitGUID("target")
		frame.unit = "target"
		OnAura(frame, "target")
		frame.hp.shadow:SetAlpha(1)
	elseif frame.overlay:IsShown() and UnitExists("mouseover") and UnitName("mouseover") == frame.hp.name:GetText() then
		frame.guid = UnitGUID("mouseover")
		frame.unit = "mouseover"
		OnAura(frame, "mouseover")
		frame.hp.shadow:SetAlpha(0)
	else
		frame.unit = nil
		frame.hp.shadow:SetAlpha(0)
	end
end

-- Attempt to match a nameplate with a GUID from the combat log
local function MatchGUID(frame, destGUID, spellID)
	if not frame.guid then return end

	if frame.guid == destGUID then
		for _, icon in ipairs(frame.icons) do
			if icon.spellID == spellID then
				icon:Hide()
			end
		end
	end
end

-- Run a function for all visible nameplates, we use this for the blacklist, to check unitguid, and to hide drunken text
local function ForEachPlate(functionToRun, ...)
	for frame in pairs(frames) do
		if frame and frame:GetParent():IsShown() then
			functionToRun(frame, ...)
		end
	end
end

-- Check if the frames default overlay texture matches blizzards nameplates default overlay texture
local select = select
local function HookFrames(...)
	for index = 1, select("#", ...) do
		local frame = select(index, ...)

		if frame:GetName() and not frame.isSkinned and frame:GetName():find("NamePlate%d") then
			local child1, child2 = frame:GetChildren()
			SkinObjects(child1, child2)
			frame.isSkinned = true
		end
	end
end

-- Core right here, scan for any possible nameplate frames that are Children of the WorldFrame
NamePlates:SetScript("OnUpdate", function(self, elapsed)
	if WorldFrame:GetNumChildren() ~= numChildren then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())
	end

	if self.elapsed and self.elapsed > 0.2 then
		ForEachPlate(UpdateThreat, self.elapsed)
		ForEachPlate(AdjustNameLevel)
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end

	ForEachPlate(ShowHealth)
	ForEachPlate(CheckBlacklist)
	ForEachPlate(CheckUnit_Guid)
	ForEachPlate(Colorize)
end)

function NamePlates:COMBAT_LOG_EVENT_UNFILTERED(_, event, ...)
	if event == "SPELL_AURA_REMOVED" then
		local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...

		if sourceGUID == UnitGUID("player") or arg4 == UnitGUID("pet") then
			ForEachPlate(MatchGUID, destGUID, spellID)
		end
	end
end

-- Only show nameplates when in combat
if C["nameplate"].combat == true then
	NamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
	NamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")

	function NamePlates:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end

	function NamePlates:PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
end

NamePlates:RegisterEvent("PLAYER_ENTERING_WORLD")
function NamePlates:PLAYER_ENTERING_WORLD()
	if C["nameplate"].combat == true then
		if InCombatLockdown() then
			SetCVar("nameplateShowEnemies", 1)
		else
			SetCVar("nameplateShowEnemies", 0)
		end
	end
	if C["nameplate"].enhancethreat == true then
		SetCVar("threatWarning", 3)
	end
end
