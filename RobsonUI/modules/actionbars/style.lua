local T, C, L, G = unpack(Tukui)

local function ActionBarStyleButtons(self)
	local Button = self
	local name = self:GetName()
	local Count = _G[name .. "Count"]
	local Btname = _G[name .. "Name"]
	local HotKey = _G[name .. "HotKey"]
	local Normal = _G[name.."NormalTexture"]
	local Icon = _G[name.."Icon"]
	local Border = _G[name.."Border"]
	local Flash = _G[name.."Flash"]

	if(name:match("MultiCast")) then return end

	if(name:match("ExtraActionButton")) then return end

	Count:ClearAllPoints()
	Count:Point("BOTTOMRIGHT", 0, 2)
	Count:SetFont(T.CreateFontString())

	if(C["actionbar"]["macrotext"] ~= true) then
		if(Btname) then
			Btname:SetText("")
			Btname:Kill()
		end
	else
		if(Btname) then
			Btname:SetAlphaGradient(0, Button:GetWidth())
			Btname:SetFont(T.CreateFontString())
		end
	end

	Icon:Point("TOPLEFT", Button, 2, -2)
	Icon:Point("BOTTOMRIGHT", Button, -2, 2)
	
	Button:CreateBorder(false, false)
	
	Button.backdrop:HideInsets()
	Button.backdrop:SetBackdropBorderColor(0,0,0,0)
	Button.backdrop:SetBackdropColor(0,0,0,0)

	HotKey:ClearAllPoints()
	HotKey:Point( "TOPRIGHT", 0, -3 )
	HotKey:SetFont( T.CreateFontString() )
	HotKey.ClearAllPoints = T.dummy
	HotKey.SetPoint = T.dummy
	
	--Border for the action bar.
	local buttonBG = CreateFrame("Frame", buttonBG, Button.backdrop)	
	buttonBG:ClearAllPoints()
	buttonBG:SetPoint("TOPLEFT", 2, -2)
	buttonBG:SetPoint("BOTTOMRIGHT", -2, 2)
	buttonBG:Size(1, 1)
	buttonBG:RobSkin()
	buttonBG:SetFrameLevel(Button.backdrop:GetFrameLevel() - 1)

	if( C["actionbar"]["hotkey"] ~= true ) then
		HotKey:SetText( "" )
		HotKey:Kill()
	end
end

hooksecurefunc( "ActionButton_Update", ActionBarStyleButtons )

function T.StyleActionBarPetButton(normal, button, icon, name, pet)
	button:SetNormalTexture("")
	
	-- bug fix when moving spell from bar
	button.SetNormalTexture = T.dummy
	
	local Flash	 = _G[name.."Flash"]
	Flash:SetTexture("")
	
	if name:match("Extra") then
		Button:RobSkin()
	end
	
	if not button.isSkinned then
		button:SetWidth(T.petbuttonsize)
		button:SetHeight(T.petbuttonsize)
		button:HideInsets()
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", button, 0, 0)
		icon:SetPoint("BOTTOMRIGHT", button, 0, 0)
		
		--Border for the action bar.
		local buttonBG = CreateFrame("Frame", buttonBG, button)	
		buttonBG:ClearAllPoints()
		buttonBG:SetPoint("TOPLEFT", 2, -2)
		buttonBG:SetPoint("BOTTOMRIGHT", -2, 2)
		buttonBG:Size(1, 1)
		buttonBG:RobSkin()
		buttonBG:SetFrameLevel(button:GetFrameLevel() - 1)
		if pet then			
			if T.petbuttonsize < 30 then
				local autocast = _G[name.."AutoCastable"]
				autocast:SetAlpha(0)
			end
			local shine = _G[name.."Shine"]
			shine:Size(T.petbuttonsize, T.petbuttonsize)
			shine:ClearAllPoints()
			shine:SetPoint("CENTER", button, 0, 0)
			icon:Point("TOPLEFT", button, 2, -2)
			icon:Point("BOTTOMRIGHT", button, -2, 2)
		end
		button.isSkinned = true
	end
	
	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
end

function T.StyleActionBarShiftButton(normal, button, icon, name, pet)
	button:SetNormalTexture("")
	
	-- bug fix when moving spell from bar
	button.SetNormalTexture = T.dummy
	
	local Flash	 = _G[name.."Flash"]
	Flash:SetTexture("")
	
	if not button.isSkinned then
		button:SetWidth(T.petbuttonsize)
		button:SetHeight(T.petbuttonsize)
		button:HideInsets()
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", button, 0, 0)
		icon:SetPoint("BOTTOMRIGHT", button, 0, 0)
		
		--Border for the action bar.
		local buttonBG = CreateFrame("Frame", buttonBG, button)	
		buttonBG:ClearAllPoints()
		buttonBG:SetPoint("TOPLEFT", 0, 0)
		buttonBG:SetPoint("BOTTOMRIGHT", 0, 0)
		buttonBG:Size(1, 1)
		buttonBG:RobSkin()
		buttonBG:SetFrameLevel(button:GetFrameLevel() - 1)
		if pet then			
			if T.petbuttonsize < 30 then
				local autocast = _G[name.."AutoCastable"]
				autocast:SetAlpha(0)
			end
			local shine = _G[name.."Shine"]
			shine:Size(T.petbuttonsize, T.petbuttonsize)
			shine:ClearAllPoints()
			shine:SetPoint("CENTER", button, 0, 0)
			icon:Point("TOPLEFT", button, 2, -2)
			icon:Point("BOTTOMRIGHT", button, -2, 2)
		end
		button.isSkinned = true
	end
	
	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
end

function T.StyleShift()
	for i=1, NUM_STANCE_SLOTS do
		local name = "StanceButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture"]
		T.StyleActionBarShiftButton(normal, button, icon, name)
	end
end

function T.StylePet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture2"]
		T.StyleActionBarPetButton(normal, button, icon, name, true)
	end
end