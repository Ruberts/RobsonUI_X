local T, C, L, G = unpack(Tukui)

local DataTextPosition = function(f, t, o)
	local ileft = TukuiInfoLeft
	local iright = TukuiInfoRight
	local bar1 = RobsonBar1
	local bar2 = RobsonBar2
	local bar3 = RobsonBar3
	
	if o >= 1 and o <= 20 then	
		if o == 10 then
			t:ClearAllPoints()
			t:SetParent(tableft)
			t:SetHeight(tableft:GetHeight())
			t:SetPoint("RIGHT", -15, 0)
		elseif o == 11 then
			t:ClearAllPoints()
			t:SetParent(bar1)
			t:SetHeight(bar1:GetHeight())
			t:SetPoint("CENTER", 0, 0)
		elseif o == 12 then
			t:ClearAllPoints()
			t:SetParent(bar2)
			t:SetHeight(bar2:GetHeight())
			t:SetPoint("CENTER", 0, 0)
		elseif o == 13 then
			t:ClearAllPoints()
			t:SetParent(bar3)
			t:SetHeight(bar3:GetHeight())
			t:SetPoint("CENTER", 0, 0)
		elseif o == 14 then
			t:ClearAllPoints()
			t:SetParent(iright)
			t:SetHeight(iright:GetHeight())
			t:SetPoint("RIGHT", -15, 0)

		end
	else
		-- hide everything that we don't use and enabled by default on tukui
		f:Hide()
		t:Hide()
		end
	end


local datatext = {
	"Guild",
	"Friends",
	"Gold",
	"FPS",
	"System",
	"Bags",
	"Gold",
	"Time",
	"Durability",
	"Heal",
	"Damage",
	"Power",
	"Haste",
	"Crit",
	"Avoidance",
	"Armor",
	"Currency",
	"Hit",
	"Mastery",
	"MicroMenu",
	"Regen",
	"Talent",
	"CallToArms",
}


for _, data in pairs(datatext) do
	local t = "TukuiStat"
	local frame = _G[t..data]
	local text = _G[t..data.."Text"]

	if frame and frame.Option then
		text:SetFont(T.CreateFontString())
		DataTextPosition(frame, text, frame.Option)
	end
end

GameTooltip:SetTemplate( "Transparent" )