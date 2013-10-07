local T, C, L, G = unpack(Tukui)

if (not C["unitframes"].enable or not C["unitframes"].powerfade) then
	return
end

local oUF = oUFTukui

if not oUF then return end

local OnUpdate = function(self, elapsed)
	local FadeBar = self.FadeBar
	local Alpha = FadeBar.Alpha - elapsed

	FadeBar:SetAlpha(Alpha)
	FadeBar.Alpha = Alpha -- Am I doing too much work here? (FadeBar.Alpha = FadeBar.Alpha - elapsed) is the same result
	
	if (Alpha <= 0) then
		FadeBar:SetValue(self:GetValue())
		self:SetScript("OnUpdate", nil)
		FadeBar:SetAlpha(1)
		FadeBar.Alpha = 1
	end
end

local OnValueChanged = function(self, value)
	if (self.FadeBar.Alpha == 1) then
		if (value < self.FadeBar.Value) then -- Power was lost
			self:SetScript("OnUpdate", OnUpdate)
		elseif (value > self.FadeBar.Value) then -- Power was gained
			self.FadeBar:SetValue(value)
		end
	end
	
	self.FadeBar.Value = value
end

local Update = function(self, event, unit)
	local Power = self.Power
	local FadeBar = Power.FadeBar

	FadeBar.Alpha = 1
	FadeBar.Value = Power:GetValue()
	FadeBar:SetMinMaxValues(Power:GetMinMaxValues())
	FadeBar:SetStatusBarColor(Power:GetStatusBarColor())
end

local Path = function(self, ...)
	return (self.Power.FadeBar.Override or Update)(self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local Enable = function(self)
	if (not self.Power) then
		return
	end

	local FadeBar = self.Power.FadeBar
	
	if FadeBar then
		FadeBar.__owner = self
		FadeBar.ForceUpdate = ForceUpdate

		self.Power:SetScript("OnValueChanged", OnValueChanged)

		if (not FadeBar:GetStatusBarTexture()) then
			FadeBar:SetStatusBarTexture([=[Interface\AddOns\RobsonUI\media\textures\normTex.tga]=])
		end

		return true
	end
end

local Disable = function(self)
	if (self.Power and self.Power.FadeBar) then
		self.Power:SetScript("OnValueChanged", nil)
	end
end

oUF:AddElement("BarFade", Path, Enable, Disable)