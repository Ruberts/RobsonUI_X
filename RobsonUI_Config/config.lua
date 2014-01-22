local C = {}

-- Classcolors
local class = RAID_CLASS_COLORS[select(2,UnitClass("player"))]

C["general"] = {
	["uiscale"] = 0.71,
}

C["media"] = {
	-- Colors
	["datatextcolor1"] = {class.r, class.g, class.b},
	["datatextcolor2"] = {1, 1, 1},
	["backdropcolor"] = {0.05, 0.05, 0.05},
	["bordercolor"] = {0.15, 0.15, 0.15},
	["unitframecolor"] = {0.18, 0.18, 0.18},
	
	-- Fonts
	["dmgfont"] = [=[Interface\AddOns\RobsonUI\media\fonts\expresswayfree.ttf]=],
	["pixelfont"] = [=[Interface\AddOns\RobsonUI\media\fonts\visitor2.ttf]=],
	["expressway"] = [=[Interface\AddOns\RobsonUI\media\fonts\expresswayrg.ttf]=],
	
	["pixel"] = true,
	
	-- Textures
	["normTex"] = [=[Interface\AddOns\RobsonUI\media\textures\normTex.tga]=],
	["blank"] = [=[Interface\AddOns\RobsonUI\media\textures\blank.tga]=],
	["HalU"] = [=[Interface\AddOns\RobsonUI\media\textures\HalU.tga]=],
	["HalT"] = [=[Interface\AddOns\RobsonUI\media\textures\HalT.tga]=],
}

C["robson"] = {
	["testui"] = true,
}

C["unitframes"] = {
	["enable"] = true,
	["unicolor"] = true,
	["charportrait"] = false,
	["castbar"] = true,
	["cbicons"] = true,
	["cblatency"] = true,
	["combatfeedback"] = false,
	["manaflash"] = false,
	["targetpowerpvponly"] = false,
	["onlyselfdebuffs"] = false,
	["raidunitdebuffwatch"] = false,
	["debuffhighlight"] = true,
	["classbar"] = true,
	["focustarget"] = true,
	["showraidpets"] = false,
	["healcomm"] = false,
	["powerfade"] = true,
	["gridhealthvertical"] = false,
	["showsymbols"] = true,
}

C["classbar"] = {
    ["warlock"] = true,
	["deathknight"] = true,
	["paladin"] = true,
	["shaman"] = true,
	["priest"] = true,
	["druid"] = true,
	["monk"] = true,
	["mage"] = true,
	["combopoints"] = true,	
}

C["classtimer"] = {
	["enable"] = true,
	["disabledebuffs"] = false,	
	["playercolor"] = {0.18, 0.18, 0.18},
	["targetbuffcolor"] = {70/255, 150/255, 70/255, 1},
	-- ["targetdebuffcolor"] = {150/255, 30/255, 30/255, 1},		
	["targetdebuffcolor"] = {class.r, class.g, class.b, 1},		
	["trinketcolor"] = {0.38, 0.38, 0.38},				
	["spark"] = true,
	["barheight"] = 18,
}

C["nameplate"] = {
	["enable"] = false,
	["robson"] = true,
	["debuffs"] = true,
	["height"] = 12,
	["width"] = 150,
	["combat"] = false,
	["showhealth"] = false,
	["aurassize"] = 20,
	["goodcolor"] = {75/255,  175/255, 76/255},	
	["badcolor"] = {0.78, 0.25, 0.25},	
	["transitioncolor"] = {218/255, 197/255, 92/255},
	["healericon"] = false,
	["showcastbarname"] = false,
	["enhancethreat"] = false,
	["classicons"] = true,
}

C["scd"] = {
	["enable"] = true,
	["size"] = 22,
	["spacing"] = 5,
	["fade"] = 0,
	["direction"] = "HORIZONTAL",
	["display"] = "STATUSBAR",
}

C["skins"] = {
	["DBM"] = true,
	["TinyDPS"] = true,
}

C["actionbar"] = {
	["enable"] = true,
	["hotkey"] = true,
	["macrotext"] = true,
	["buttonsize"] = 27,
	["petbuttonsize"] = 27,
	["buttonspacing"] = 1,
}

C["auras"] = {
	["consolidate"] = false,
	["classictimer"] = true,
	["flash"] = false, 
}

C["datatext"] = {
	["fps_ms"] = 12,
	["system"] = 11,
	["bags"] = 0,
	["gold"] = 0,
	["wowtime"] = 7,
	["guild"] = 0,
	["dur"] = 13,
	["friends"] = 0,
	["dps_text"] = 0,
	["hps_text"] = 0,
	["power"] = 0,
	["haste"] = 0,
	["crit"] = 0,
	["avd"] = 0,
	["armor"] = 0,
	["currency"] = 0,
	["hit"] = 0,
	["mastery"] = 0, 
	["micromenu"] = 0,
	["regen"] = 0,
	["talent"] = 0,
	["calltoarms"] = 0,

	["battleground"] = false,
	["time24"] = true,
	["localtime"] = false,
	["fontsize"] = 12,
}

C["merchant"] = {
	["sellgrays"] = true,
	["autorepair"] = false,
	["sellmisc"] = true,
	["autoguildrepair"] = true,	
}

C["tooltip"] = {
	["enable"] = true,
	["ids"] = true,
}

TukuiEditedDefaultConfig = C