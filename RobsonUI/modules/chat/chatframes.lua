local T, C, L, G = unpack(Tukui)

local function SetTabStyle(frame)
	local id = frame:GetID()
	local chat = frame:GetName()
	local tab = _G[chat .. "Tab"]

	_G[chat .. "TabText"]:Hide()

	tab:HookScript("OnEnter", function() _G[chat .. "TabText"]:Show() end )
	tab:HookScript("OnLeave", function() _G[chat .. "TabText"]:Hide() end )

	_G[chat .. "TabText"]:SetTextColor(unpack(C["media"]["datatextcolor1"]))
	_G[chat .. "TabText"]:SetFont(T.CreateFontString())
	_G[chat .. "TabText"]:SetShadowOffset(0,0)
	_G[chat .. "TabText"].SetTextColor = T.dummy
	_G[chat]:SetFont(C["media"].font, 12)
	_G[chat]:SetFading(true)

	_G[chat .. "EditBox"]:ClearAllPoints()
	_G[chat .. "EditBox"]:Point("TOPLEFT", RobsonEditBox, 2, -2)
	_G[chat .. "EditBox"]:Point("BOTTOMRIGHT", RobsonEditBox, -2, 2)
	_G[chat .. "EditBox"]:CreateBackdrop()
	_G[chat .. "EditBox"].backdrop:ClearAllPoints()
	_G[chat .. "EditBox"].backdrop:SetAllPoints(RobsonEditBox)
end

-- GeneralDockManager:ClearAllPoints()
-- GeneralDockManager:Width(TukuiInfoLeft:GetWidth())
-- GeneralDockManager:Point("BOTTOM", TukuiInfoLeft, 0, 0)
	-- --On bottom for undocked chat frames also
-- hooksecurefunc("FCF_SetTabPosition", function(chatFrame,x)
	-- local chatTab = _G[chatFrame:GetName().."Tab"];
	-- chatTab:ClearAllPoints()
	-- chatTab:Point("LEFT", TukuiInfoRight, 0, 6)
-- end)

local function SetupChatStyle(self)
	for i = 1, NUM_CHAT_WINDOWS do
	local frame = _G[format( "ChatFrame%s", i )]
		SetTabStyle(frame)
	end
end

TukuiChat:HookScript("OnEvent", function(self, event, ...)
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format( "ChatFrame%s", i )]
		SetupChatStyle(chat)
	end
end )

BNToastFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:Point("TOPLEFT", RobsonBar1, "BOTTOMLEFT", 0, -4)
	self:SetTemplate("Transparent")
	self:RobSkin()
end)

T.SetDefaultChatPosition = function(frame)
	if(frame) then
		local id = frame:GetID()
		local name = FCF_GetChatWindowInfo(id)
		local fontSize = select(2, frame:GetFont())

		if(fontSize < 12) then
			FCF_SetChatWindowFontSize(nil, frame, 12)
		else
			FCF_SetChatWindowFontSize(nil, frame, fontSize)
		end

		if(id == 1) then
			frame:ClearAllPoints()
			frame:Point("TOPLEFT", RobsonLeftChat, 4, -3)
			frame:Point("BOTTOMRIGHT", RobsonLeftChat, -4, 3)
			frame:SetFrameLevel(RobsonLeftChat:GetFrameLevel() + 1)
		elseif(id == 4 and name == LOOT) then
			if(not frame.isDocked) then
				frame:ClearAllPoints()
				frame:Point("TOPLEFT", RobsonRightChat, 4, -2)
				frame:Point("BOTTOMRIGHT", RobsonRightChat, -4, 2)
				frame:SetFrameLevel(RobsonRightChat:GetFrameLevel() + 1)
				frame:SetJustifyH("RIGHT")
				end
			end

		if(not frame.isLocked) then
			FCF_SetLocked(frame, 1)
		end
	end
end
hooksecurefunc("FCF_RestorePositionAndDimensions", T.SetDefaultChatPosition)

