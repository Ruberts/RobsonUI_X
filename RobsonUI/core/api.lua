local T, C, L, G = unpack(Tukui)

if C["media"].pixel then
	-- Pixelfont
	T.CreateFontString = function()
			return C["media"].pixelfont, 12, "MONOCHROMEOUTLINE"
		end
else	
	-- Normalfont
	T.CreateFontString = function()
			return C["media"].expressway, 11, "THINOUTLINE"
		end
end

-- Datatextinfo Panels	
T.InfoLeftRightWidth = 372

local function CreateOverlay( frame )
	if( frame.overlay ) then return end

	local overlay = frame:CreateTexture(frame:GetName() and frame:GetName() .. "Overlay" or nil, "BORDER", frame)
	overlay:ClearAllPoints()
	overlay:Point("TOPLEFT", 0, 0)
	overlay:Point("BOTTOMRIGHT", 0, 0)
	overlay:SetTexture(C["media"].normTex)
	overlay:SetVertexColor(unpack(C["media"].unitframecolor))
	frame.overlay = overlay
end

local function CreateBorder(f, i, o)
	if i then
		if f.iborder then return end
		local border = CreateFrame("Frame", f:GetName() and f:GetName() .. "InnerBorder" or nil, f)
		border:Point("TOPLEFT", T.mult, -T.mult)
		border:Point("BOTTOMRIGHT", -T.mult, T.mult)
		border:SetBackdrop({
			edgeFile = C["media"].blank, 
			edgeSize = T.mult, 
			insets = { left = T.mult, right = T.mult, top = T.mult, bottom = T.mult }
		})
		border:SetBackdropBorderColor(0,0,0)
		f.iborder = border
	end
	
	if o then
		if f.oborder then return end
		local border = CreateFrame("Frame", f:GetName() and f:GetName() .. "OuterBorder" or nil, f)
		border:Point("TOPLEFT", -T.mult, T.mult)
		border:Point("BOTTOMRIGHT", T.mult, -T.mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:SetBackdrop({
			edgeFile = C["media"].blank, 
			edgeSize = T.mult, 
			insets = { left = T.mult, right = T.mult, top = T.mult, bottom = T.mult }
		})
		border:SetBackdropBorderColor(0,0,0)
		f.oborder = border
	end
end

local function SetBorder(f, i, o)
	if i then
		if f.iborder then return end
		local border = CreateFrame("Frame", f:GetName() and f:GetName() .. "InnerBorder" or nil, f)
		border:Point("TOPLEFT", T.mult, -T.mult)
		border:Point("BOTTOMRIGHT", -T.mult, T.mult)
		border:SetBackdrop({
			edgeFile = C.media.blank, 
			edgeSize = T.mult, 
			insets = { left = T.mult, right = T.mult, top = T.mult, bottom = T.mult }
		})
		border:SetBackdropBorderColor(0, 0, 0)
		f.iborder = border
	end

	if o then
		if f.oborder then return end
		local border = CreateFrame("Frame", f:GetName() and f:GetName() .. "OuterBorder" or nil, f)
		border:Point("TOPLEFT", -T.mult, T.mult)
		border:Point("BOTTOMRIGHT", T.mult, -T.mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:SetBackdrop({
			edgeFile = C.media.blank, 
			edgeSize = T.mult, 
			insets = { left = T.mult, right = T.mult, top = T.mult, bottom = T.mult }
		})
		border:SetBackdropBorderColor(0, 0, 0)
		f.oborder = border
	end
end

local function RobSkin(f)
	f:SetTemplate("Transparent")
	CreateBorder(f, false, true)
	f:HideInsets()
	f:SetBackdropBorderColor(0, 0, 0, 0)
end

local function FadeIn(frame)
	UIFrameFadeIn(frame, 0.4, frame:GetAlpha(), 1)
end

local function FadeOut(frame)
	UIFrameFadeOut(frame, 0.8, frame:GetAlpha(), 0)
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.CreateOverlay then mt.CreateOverlay = CreateOverlay end
	if not object.FadeIn then mt.FadeIn = FadeIn end
	if not object.FadeOut then mt.FadeOut = FadeOut end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
	if not object.SetBorder then mt.SetBorder = SetBorder end
	if not object.RobSkin then mt.RobSkin = RobSkin end
end

local handled = { ["Frame"] = true }
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if(not handled[object:GetObjectType()]) then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end