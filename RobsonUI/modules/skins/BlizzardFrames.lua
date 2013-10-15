local T, C, L, G = unpack(Tukui)

local frames = {
	CharacterFrame,
	FriendsFrame,
	SpellBookFrame.backdrop,
	QuestLogFrame,
	VideoOptionsFrame,
	InterfaceOptionsFrame,
	WorldMapFrame.backdrop,
	QuestFrame.backdrop,
	GossipFrame.backdrop,
	GameMenuFrame,
	WorldStateScoreFrame,
	MailFrame,
	OpenMailFrame,
	--PVPFrame.backdrop,
	PVEFrame.backdrop,
	MerchantFrame,
	MerchantBuyBackItem,
	TukuiInstallFrame,
	ItemTextFrame,
	LFGDungeonReadyPopup,
	QuestLogDetailFrame,
	GuildInviteFrame,
	DressUpFrame.backdrop,
	ChatConfigFrame,
	StaticPopup1,
	StaticPopup3,
	PetJournalParent,
	TukuiPopupDialog1,
	TukuiPopupDialogButtonAccept1,
	TukuiPopupDialogButtonCancel1,
	TradeFrame.backdrop,
	FriendsFriendsFrame.backdrop,
	BNConversationInviteDialog,
	AddFriendFrame,
	LootHistoryFrame,
	FriendsFrameBattlenetFrame.BroadcastFrame,
	RaidInfoFrame.backdrop,
	TukuiChatCopyFrame,
	RaidBrowserFrame.backdrop,
	RolePollPopup,
}

local OnLoad = CreateFrame("Frame")
OnLoad:RegisterEvent("PLAYER_ENTERING_WORLD")
OnLoad:SetScript("OnEvent", function()
	for _,f in pairs(frames) do
		f:RobSkin()
		if f.backdrop and f.backdrop.shadow then f.backdrop.shadow:Hide() elseif f.shadow then f.shadow:Hide() end
	end
end)

-- Since BNet Converstaion frame is Transparent in my UI give the List a Template so it looks nice.
BNConversationInviteDialogList:SetTemplate("Default")

WorldMapQuestRewardScrollFrameScrollBar:SkinScrollBar()

TokenFrame:HookScript("OnShow", function()
	TokenFramePopup:SetTemplate("Transparent")	
end)

local function UpdateFactionSkins()
	ReputationDetailFrame:SetTemplate("Transparent")
end
ReputationFrame:HookScript("OnShow", UpdateFactionSkins)

-----------------------------------------------
-- Method of Skinning other frames
-----------------------------------------------

local function SkinBlizzardFrames(self, event, addon)
	if(addon == "Blizzard_AchievementUI") then
	
		AchievementFrame.backdrop:RobSkin()
		
	elseif(addon == "Blizzard_ArchaeologyUI") then
	
		ArchaeologyFrame:RobSkin()
		
	elseif(addon == "Blizzard_AuctionUI") then
	
		AuctionFrame:RobSkin()
		AuctionFrame.shadow:Hide()
		SideDressUpFrame:RobSkin()

	elseif(addon == "Blizzard_BarbershopUI") then
	
		BarberShopFrame:RobSkin()
		
	elseif(addon == "Blizzard_BindingUI") then
	
		KeyBindingFrame:RobSkin()
		
	elseif(addon == "Blizzard_Calendar") then
	
		local frames = {
			CalendarFrame,
			CalendarCreateEventFrame,
			CalendarTexturePickerFrame,
			CalendarViewEventFrame,
			CalendarViewHolidayFrame,
			CalendarViewRaidFrame,
			CalendarMassInviteFrame,
		}
		
		for _,f in pairs(frames) do
			f:RobSkin()
			if f.shadow then f.shadow:Hide() end
		end
		
		CalendarMassInviteCloseButton:StripTextures()
		
	elseif(addon == "Blizzard_TimeManager") then
	
		TimeManagerFrame:RobSkin()
		
	elseif(addon == "Blizzard_TalentUI") then
	
		PlayerTalentFrame.backdrop:RobSkin()
		
	elseif(addon == "Blizzard_GuildUI") then
	
		local frames = {
			GuildFrame,
			GuildMemberDetailFrame,
			GuildLogFrame,
			GuildNewsFiltersFrame,
			GuildTextEditFrame,
		}
		
		for _,f in pairs(frames) do
			f:RobSkin()
			if f.shadow then f.shadow:Hide() end
		end
		
		GuildMemberDetailFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -28)
		
	elseif(addon == "Blizzard_GuildBankUI") then
	
		GuildBankFrame:RobSkin()
		
	elseif(addon == "Blizzard_MacroUI") then
	
		MacroFrame:RobSkin()
		
	elseif(addon == "Blizzard_VoidStorageUI") then
	
		VoidStorageFrame:RobSkin()
		
	elseif(addon == "Blizzard_ReforgingUI") then
	
		ReforgingFrame:RobSkin()
		
	elseif(addon == "Blizzard_TrainerUI") then
	
		ClassTrainerFrame.backdrop:RobSkin()
		
	elseif(addon == "Blizzard_InspectUI") then
	
		InspectFrame.backdrop:RobSkin()
		
	elseif(addon == "Blizzard_TradeSkillUI") then
	
		TradeSkillFrame:RobSkin()
		TradeSkillFrame.shadow:Hide()
		
	elseif(addon == "Blizzard_ItemAlterationUI") then
	
		TransmogrifyArtFrame:RobSkin()
		
	elseif(addon == "Blizzard_LookingForGuildUI") then
	
		LookingForGuildFrame:RobSkin()

	elseif(addon == "Blizzard_ItemSocketingUI") then
	
		ItemSocketingFrame:RobSkin()
		ItemSocketingScrollFrame:SetTemplate("Default")
		ItemSocketingScrollFrame:SetHeight(ItemSocketingScrollFrame:GetHeight() + 10)
		ItemSocketingScrollFrame:SetFrameLevel(ItemSocketingFrame:GetFrameLevel() + 4)
		
	elseif(addon == "Blizzard_ItemUpgradeUI") then
	
		ItemUpgradeFrame:RobSkin()
		ItemUpgradeFrame.shadow:Hide()
		
	end
end

local Init = CreateFrame("Frame")
Init:RegisterEvent("ADDON_LOADED")
Init:SetScript("OnEvent", SkinBlizzardFrames)

-- Skin the bag frames.
if C["bags"].enable ~= true then return end

local function BagsSlotUpdate(self, b)
	local scount = _G[b.frame:GetName().."Count"]
	scount:SetFont(T.CreateFontString())
	scount:Point("BOTTOMRIGHT", 0, 2)
end
hooksecurefunc(Stuffing, "SlotUpdate", BagsSlotUpdate)

local function BagsLayout(self, lb)
	local f

	if(lb) then
		f = self.bankFrame
	else
		f = self.frame

		f.gold:SetText(GetMoneyString(GetMoney(), 12))
		f.editbox:SetFont(T.CreateFontString())
		f.editbox:SetShadowOffset(0, 0)
		f.detail:SetFont(T.CreateFontString())
		f.detail:SetShadowOffset(0, 0)
		f.gold:SetFont(T.CreateFontString())
		f.gold:SetShadowOffset(0, 0)

		f.detail:ClearAllPoints()
		f.detail:Point("TOPLEFT", f, 12, -10)
		f.detail:Point("RIGHT", -(16 + 24), 0)
	end
	
	f:RobSkin()
	--f:CreateShadow()
end
hooksecurefunc(Stuffing, "Layout", BagsLayout)

TukuiBags:ClearAllPoints()
TukuiBags:SetPoint("BOTTOM", RobsonRightChat, "TOP", 0, 3)

local function BagsUpdateBankPosition(self, value)
local bag = _G["Tukui"..value]
if(value == "Bank") then
	bag:ClearAllPoints()
		bag:SetPoint("BOTTOM", RobsonLeftChat, "TOP", 0, 3)
	end	
end
hooksecurefunc(Stuffing, "CreateBagFrame", BagsUpdateBankPosition)

-- Move the Watch Frame.
TukuiWatchFrameAnchor:ClearAllPoints()
TukuiWatchFrameAnchor:Point("TOPLEFT", UIParent, 110, -110)
TukuiWatchFrameAnchor:SetClampedToScreen(false)
G.Tooltips.GameTooltip.Health.Background:Hide() -- Small hack. Don't remove. ;3