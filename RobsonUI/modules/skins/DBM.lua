local T, C, L, G = unpack(Tukui)

if C["skins"].DBM ~= true then return end

if not IsAddOnLoaded("DBM-Core") or C["skins"].DBM ~= true then return end

local croprwicons = true
local rwiconsize = 18

local classcolor = RAID_CLASS_COLORS[T.myclass]
local buttonsize

local buttonsize = 20


local function SkinBars(self)
	for bar in self:GetBarIterator() do
		if not bar.injected then
			bar.ApplyStyle = function()
				local frame = bar.frame
				local tbar = _G[frame:GetName() .. "Bar"]
				local spark = _G[frame:GetName() .. "BarSpark"]
				local texture = _G[frame:GetName() .. "BarTexture"]
				local icon1 = _G[frame:GetName() .. "BarIcon1"]
				local icon2 = _G[frame:GetName() .. "BarIcon2"]
				local name = _G[frame:GetName() .. "BarName"]
				local timer = _G[frame:GetName() .. "BarTimer"]

				if not (icon1.overlay) then
					icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
					icon1.overlay:Size(buttonsize, buttonsize)
					icon1.overlay:SetPoint("RIGHT", tbar, "LEFT", -3, 0)
					icon1.overlay:SetTemplate("Transparent")
					icon1.overlay:SetFrameStrata("Low")
				end

				if not (icon2.overlay) then
					icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
					icon2.overlay:Size(buttonsize, buttonsize)
					icon2.overlay:SetPoint("LEFT", tbar, "RIGHT", -3, 0)
					icon2.overlay:SetTemplate("Transparent")
					icon2.overlay:SetFrameStrata("Low")
				end

				if bar.color then
					tbar:SetStatusBarColor(bar.color.r, bar.color.g, bar.color.b)
				else
					tbar:SetStatusBarColor(bar.owner.options.StartColorR, bar.owner.options.StartColorG, bar.owner.options.StartColorB)
				end

				if bar.enlarged then
					frame:Width(bar.owner.options.HugeWidth)
				else
					frame:Width(bar.owner.options.Width)
				end

				if bar.enlarged then
					tbar:Width(bar.owner.options.HugeWidth)
				else
					tbar:Width(bar.owner.options.Width)
				end

				if not frame.styled then
					frame:SetScale(1)
					frame.SetScale = T.dummy
					frame:SetHeight(buttonsize)
					frame.styled = true
				end

				if not spark.killed then
					spark:SetAlpha(0)
					spark:SetTexture(nil)
					spark.killed = true
				end

				if not icon1.styled then
					icon1:SetTexCoord(0.08, 0.92, 0.08, 0.92)
					icon1:ClearAllPoints()
					icon1:Point("TOPLEFT", icon1.overlay, 0, 0)
					icon1:Point("BOTTOMRIGHT", icon1.overlay, 0, 0)
					icon1.styled = true
				end

				if not icon2.styled then
					icon2:SetTexCoord(0.08, 0.92, 0.08, 0.92)
					icon2:ClearAllPoints()
					icon2:Point("TOPLEFT", icon2.overlay, 0, 0)
					icon2:Point("BOTTOMRIGHT", icon2.overlay, 0, 0)
					icon2.styled = true
				end

				if not texture.styled then
					texture:SetTexture(C["media"].normTex)
					texture.styled = true
				end

				if not tbar.styled then
					tbar:Point("TOPLEFT", frame, "TOPLEFT", 0, 0)
					tbar:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
					tbar:RobSkin()
					tbar.styled = true
				end

				if not name.styled then
					name:ClearAllPoints()
					name:Point("LEFT", frame, "LEFT", 4, 1)
					name:SetWidth(165)
					name:SetHeight(8)
					name:SetFont(T.CreateFontString())
					name:SetJustifyH("LEFT")
					name:SetShadowColor(0, 0, 0, 0)
					name.SetFont = T.dummy
					name.styled = true
				end
				
				if not timer.styled then
					timer:ClearAllPoints()
					timer:Point("RIGHT", frame, "RIGHT", -4, 1)
					timer:SetFont(T.CreateFontString())
					timer:SetJustifyH("RIGHT")
					timer:SetShadowColor(0, 0, 0, 0)
					timer.SetFont = T.dummy
					timer.styled = true
				end

				if bar.owner.options.IconLeft then
					icon1:Show()
					icon1.overlay:Show()
				else
					icon1:Hide()
					icon1.overlay:Hide()
				end

				if bar.owner.options.IconRight then
					icon2:Show()
					icon2.overlay:Show()
				else
					icon2:Hide()
					icon2.overlay:Hide()
				end

				tbar:SetAlpha(1)
				--frame:SetAlpha(1)
				texture:SetAlpha(1)
				frame:Show()
				bar:Update(0)
				bar.injected = true
			end
			bar:ApplyStyle()
		end
	end
end

local SkinBossTitle = function()
	local anchor = DBMBossHealthDropdown:GetParent()

	if not anchor.styled then
		local header = { anchor:GetRegions() }
			if header[1]:IsObjectType("FontString") then
				header[1]:SetFont(T.CreateFontString())
				header[1]:SetTextColor(1, 1, 1, 1)
				header[1]:SetShadowColor(0, 0, 0, 0)
				anchor.styled = true
			end
		header = nil
	end
	anchor = nil
end

local SkinBoss=function()
	local count = 1
	while _G[format("DBM_BossHealth_Bar_%d", count)] do
		local bar = _G[format("DBM_BossHealth_Bar_%d", count)]
		local background = _G[bar:GetName() .. "BarBorder"]
		local progress = _G[bar:GetName() .. "Bar"]
		local name = _G[bar:GetName() .. "BarName"]
		local timer = _G[bar:GetName() .. "BarTimer"]
		local prev = _G[format("DBM_BossHealth_Bar_%d", count - 1)]

		if count == 1 then
			local _, anch, _, _, _ = bar:GetPoint()
			bar:ClearAllPoints()
			if DBM_SavedOptions.HealthFrameGrowUp then
				bar:Point("BOTTOM", anch, "TOP" , 0 , 12)
			else
				bar:Point("TOP", anch, "BOTTOM" , 0, -buttonsize)
			end
		else
			bar:ClearAllPoints()
			if DBM_SavedOptions.HealthFrameGrowUp then
				bar:Point("TOPLEFT", prev, "TOPLEFT", 0, buttonsize)
			else
				bar:Point("TOPLEFT", prev, "TOPLEFT", 0, -buttonsize)
			end
		end

		if not bar.styled then
			bar:SetHeight(5)
			bar:RobSkin()
			background:SetNormalTexture(nil)
			bar.styled = true
		end

		if not progress.styled then
			progress:SetStatusBarTexture(C["media"].normTex)
			progress.styled = true
		end
		progress:ClearAllPoints()
		progress:Point("TOPLEFT", bar, "TOPLEFT", 0, 0)
		progress:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)

		if not name.styled then
			name:ClearAllPoints()
			name:Point("BOTTOMLEFT", bar, "TOPLEFT", 1, 0)
			name:SetFont(T.CreateFontString())
			name:SetJustifyH("LEFT")
			name:SetShadowColor(0, 0, 0, 0)
			name.styled = true
		end

		if not timer.styled then
			timer:ClearAllPoints()
			timer:Point("BOTTOMRIGHT", bar, "TOPRIGHT", 0, 0)
			timer:SetFont(T.CreateFontString())
			timer:SetJustifyH("RIGHT")
			timer:SetShadowColor(0, 0, 0, 0)
			timer.styled = true
		end
		count = count + 1
	end
end

hooksecurefunc(DBT, "CreateBar", SkinBars)
hooksecurefunc(DBM.BossHealth, "Show", SkinBossTitle)
hooksecurefunc(DBM.BossHealth, "AddBoss", SkinBoss)
hooksecurefunc(DBM.BossHealth, "UpdateSettings", SkinBoss)
hooksecurefunc(DBM.RangeCheck, "Show", function()
	DBMRangeCheck:RobSkin()
	DBMRangeCheckRadar:RobSkin()
end)
hooksecurefunc(DBM.InfoFrame, "Show", function()
	DBMInfoFrame:RobSkin()
end)

if croprwicons then
	local replace = string.gsub
	local old = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
		if textString:find(" |T") then
			textString=replace(textString,"(:12:12)", ":" .. rwiconsize .. ":" .. rwiconsize .. ":0:0:64:64:5:59:5:59")
		end
		return old(noticeFrame, textString, colorInfo)
	end
end

local UploadDBM = function()
	DBM_SavedOptions.Enabled = true
	DBM_SavedOptions.WarningIconLeft = false
	DBM_SavedOptions.WarningIconRight = false
	DBM_SavedOptions["WarningColors"] = {
		{
			["b"] = classcolor.b,
			["g"] = classcolor.g,
			["r"] = classcolor.r,
		},
		{
			["b"] = classcolor.b,
			["g"] = classcolor.g,
			["r"] = classcolor.r,
		},
		{
			["b"] = classcolor.b,
			["g"] = classcolor.g,
			["r"] = classcolor.r,
		},
		{
			["b"] = classcolor.b,
			["g"] = classcolor.g,
			["r"] = classcolor.r,
		},
	}
	DBT_PersistentOptions["DBM"].StartColorR = classcolor.r
	DBT_PersistentOptions["DBM"].StartColorG = classcolor.g
	DBT_PersistentOptions["DBM"].StartColorB = classcolor.b
	DBT_PersistentOptions["DBM"].EndColorR = classcolor.r
	DBT_PersistentOptions["DBM"].EndColorG = classcolor.g
	DBT_PersistentOptions["DBM"].EndColorB = classcolor.b
	DBT_PersistentOptions["DBM"].Scale = 1
	DBT_PersistentOptions["DBM"].HugeScale = 1
	DBT_PersistentOptions["DBM"].HugeWidth = 300
	DBT_PersistentOptions["DBM"].Width = 347
	DBT_PersistentOptions["DBM"].BarXOffset = 0
	DBT_PersistentOptions["DBM"].BarYOffset = 3
	DBT_PersistentOptions["DBM"].IconLeft = true
	DBT_PersistentOptions["DBM"].ExpandUpwards = true
	DBT_PersistentOptions["DBM"].Texture = C["media"].normTex
	DBT_PersistentOptions["DBM"].IconRight = false
	DBT_PersistentOptions["DBM"].TimerPoint = "RIGHT"
	DBT_PersistentOptions["DBM"].TimerX = -183
	DBT_PersistentOptions["DBM"].TimerY = -400
	
	
end

local pr = function(msg)
	print("|cff1784d1RobsonUI DBM Skin|r:", tostring(msg))
end

local function rt(i)
	return
	function()
		return i
	end
end

local function healthdemo()
		DBM.BossHealth:Show("Scary bosses")
		DBM.BossHealth:AddBoss(rt(25), "Sinestra")
		DBM.BossHealth:AddBoss(rt(50), "Nefarian")
		DBM.BossHealth:AddBoss(rt(75), "Gamon")
		DBM.BossHealth:AddBoss(rt(100), "Hogger")
end

SLASH_ROBSONUIDBM1 = "/rdbm"
SlashCmdList["ROBSONUIDBM"] = function(msg)
	if msg == "apply" then
		T.ShowPopup("ROBSONUI_ENABLE_DBM_SKIN")
	elseif msg == "test" then
		DBM:DemoMode()
	elseif msg == "bh"then
		healthdemo()
	else
		pr("use |cff1784d1/rdbm apply|r to apply DBM settings.")
		pr("use |cff1784d1/rdbm test|r to launch DBM testmode.")
		pr("use |cff1784d1/rdbm bh|r to show test BossHealth frame.")
	end
end

T.CreatePopup["ROBSONUI_ENABLE_DBM_SKIN"] = {
	question = "Enable the DBM-Skin",
	answer1 = ACCEPT,
	answer2 = CANCEL,
	function1 = function()
		UploadDBM()

		if InCombatLockdown() then
			print(ERR_NOT_IN_COMBAT)
			print("Please reload your interface to apply DBM skin.")
		else
			ReloadUI()
		end
	end,
}