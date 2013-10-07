local T, C, L, G = unpack( Tukui )

if( C["actionbar"].enable ~= true ) then return end

G.ActionBars.Stance:ClearAllPoints()
G.ActionBars.Stance:Point("TOPLEFT", RobsonBar1, "BOTTOMLEFT", 1, -24)

-----------------------------------------------------------------------
-- Setup Shapeshift Bar
-----------------------------------------------------------------------

local bar = G.ActionBars.Stance
bar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		StanceBarFrame.ignoreFramePositionManager = true
		StanceBarFrame:StripTextures()
		StanceBarFrame:SetParent(bar)
		StanceBarFrame:ClearAllPoints()
		StanceBarFrame:SetPoint("BOTTOMLEFT", bar, "TOPLEFT", -11, -11)
		StanceBarFrame:EnableMouse(false)
		
		local sborder = CreateFrame("Frame", "StanceBorder", StanceButton1)
		sborder:Point("LEFT", -T.buttonspacing, 0)
		sborder:SetTemplate("Default")
		sborder:SetBackdropColor(.05, .05, .05, 0.6)
		sborder:SetFrameLevel(1)
		sborder:SetFrameStrata("BACKGROUND")
		
		G.ActionBars.Stance:HookScript( "OnEvent", function( self, event, ... )
		StanceBorder:Size((( StanceButton1:GetWidth() + T.buttonspacing) * GetNumShapeshiftForms()) + T.buttonspacing, StanceButton1:GetHeight() + 2 * T.buttonspacing)
		end)
		
		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["StanceButton"..i]
			button:CreateShadow("Default")
			button:SetFrameStrata("LOW")
			
			if i ~= 1 then
				button:ClearAllPoints()				
				local previous = _G["StanceButton"..i-1]
				button:Point("LEFT", previous, "RIGHT", T.buttonspacing, 0)
			end
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			else
				button:Hide()
			end
			
			G.ActionBars.Stance["Button"..i] = button
		end
		RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle] hide; show")
	elseif event == "UPDATE_SHAPESHIFT_FORMS" then
		-- Update Shapeshift Bar Button Visibility
		-- I seriously don't know if it's the best way to do it on spec changes or when we learn a new stance.
		if InCombatLockdown() then return end -- > just to be safe ;p
		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["StanceButton"..i]
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			else
				button:Hide()
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		T.ShiftBarUpdate(self)
		T.StyleShift(self)
	else
		T.ShiftBarUpdate(self)
	end
end)

RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")