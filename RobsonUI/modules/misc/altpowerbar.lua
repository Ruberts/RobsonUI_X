local T, C, L, G = unpack(Tukui)

local bar = TukuiAltPowerBar
local status = TukuiAltPowerBarStatus
local text = TukuiAltPowerBarText

bar:SetParent(UIParent)
bar:ClearAllPoints()
bar:Point("TOPLEFT", RobsonAltPower, "TOPLEFT", 0, 0)
bar:Point("BOTTOMRIGHT", RobsonAltPower, "BOTTOMRIGHT", 0, 0)
bar:Size(RobsonAltPower:GetWidth(), RobsonAltPower:GetHeight())
bar:RobSkin()

status:SetParent(bar)
status:ClearAllPoints()
status:Point("TOPLEFT", 0, 0)
status:Point("BOTTOMRIGHT", 0, 0)

text:SetFont(T.CreateFontString())
text:SetShadowOffset(0, 0)
