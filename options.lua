local addon = CreateFrame("Frame")

local oUF_Lure_Defaults = {
  ["ShowParty"] = true,
  ["ShowRaid"] = true,
  ["HideBlizzardRaid"] = true,
  ["HideBlizzardParty"] = true,
  ["NumRaidGroups"] = 8,
  ["ShowCombopoints"] = true,
  ["ShowHolyPower"] = true,
  ["ShowEclipse"] = true,
  ["ShowTotems"] = true,
  ["ShowSoulShards"] = true,
  ["ShowRunes"] = true,
  ["ShowRestingIcon"] = false,
  ["ShowCombatIcon"] = true,
  ["ShowPet"] = true,
  ["ShowPetCastbar"] = false,
  ["ShowFocus"] = true,
  ["ShowFocusCastbar"] = true,
  ["ShowCastbarIcons"] = true,
  ["RaidFrameWidth"] = 80,
  ["RaidFrameHeight"] = 18,
  ["RaidSpacingHorizontal"] = 8,
  ["RaidSpacingVertical"] = 8,
  ["RaidNameLength"] = 9,
  ["NumRaidGroups"] = 8,
  ["ShowPlayerCastbar"] = true,
  ["ShowTargetCastbar"] = true,
  ["PlayerCastbarPositionHorizontal"] = 0,
  ["PlayerCastbarPositionVertical"] = 250,
  ["TargetCastbarPositionHorizontal"] = 0,
  ["TargetCastbarPositionVertical"] = 550,
  ["CastbarColor"] = {0.5, 1, 0.5},
  ["ShowBuffsOnPlayer"] = false,
  ["ShowDebuffsOnPlayer"] = false,
  ["PlayerBuffsOnRight"] = false,
  ["ShowBuffsOnTarget"] = true,
  ["ShowDebuffsOnTarget"] = true,
  ["TargetBuffsOnRight"] = true,
  ["ShowBuffsOnFocus"] = false,
  ["ShowDebuffsOnFocus"] = false,
  ["FocusBuffsOnRight"] = false,
  ["ShowBuffsOnPet"] = false,
  ["ShowDebuffsOnPet"] = false,
  ["PetBuffsOnRight"] = false,
  ["ShowDebuffsOnTot"] = false,
  ["BuffsPerRow"] = 30,
  ["HideBuffsAndDebuffsFromOthers"] = false
};

local function SetDefaultOptions()
	oUF_Lure_SavedVars = {}

	for k, v in pairs(oUF_Lure_Defaults) do
		oUF_Lure_SavedVars[k] = v
	end
end

local function CheckAndFixSavedVars()
	if (oUF_Lure_SavedVars == nil) then
		SetDefaultOptions()
	else
		for k, v in pairs(oUF_Lure_Defaults) do
			if(oUF_Lure_SavedVars[k] == nil) then
				oUF_Lure_SavedVars[k] = v
			end
		end
	end
end

function oUF_Lure_SetDefaultOptionsAndApply()
	SetDefaultOptions()
	oUF_Lure_UpdateUI()
	oUF_Lure_ApplyOptions()
	oUF_Lure_ApplyPartyRaidOptions()
end

local function GetColor(restore)
	local newR, newG, newB, newA
	
	if restore then
		newR, newG, newB, newA = unpack(restore);
	else
		newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
	end
	
	return {newR, newG, newB}
end

function oUF_Lure_SaveCastbarColors(restore)
	oUF_Lure_SavedVars.CastbarColor = GetColor(restore)
	oUF_Lure_ApplyCastbarOptions()
end

local panels = {}
local checkbuttons = {}
local editboxes = {}
local sliders = {}
local colorpickers = {}

table.insert(panels, oUF_Lure_GeneratePanel(UIParent, "oUF_Lure", "oUF_Lure: General Options"))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowCombopoints', "Show combo points", 15, -50))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowHolyPower', "Show holy power", 15, -75))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowEclipse', "Show eclipse", 15, -100))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowSoulShards', "Show soul shards", 15, -125))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowRunes', "Show runes", 15, -150))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowTotems', "Show totems", 15, -175))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowRestingIcon', "Show resting icon", 15, -225))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowCombatIcon', "Show combat icon", 15, -250))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowPet', "Show pet", 15, -300))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowFocus', "Show focus", 15, -325))

table.insert(panels, oUF_Lure_GeneratePanel(panels[1], "Party & Raid", "oUF_Lure: Party & Raid"))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowParty', "Show party frames", 15, -50))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowRaid', "Show raid frames", 15, -75))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'HideBlizzardRaid', "Hide Blizzards raid stuff |cFFFF0000(needs ui reload)", 15, -100))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'HideBlizzardParty', "Hide Blizzards party frames |cFFFF0000(needs ui reload)", 15, -125))
table.insert(sliders, oUF_Lure_GenerateSlider(panels[#panels], 'NumRaidGroups', "Number of raid groups", 1, 8, 1, 25, -175))
table.insert(sliders, oUF_Lure_GenerateSlider(panels[#panels], 'RaidNameLength', "Raid name length", 2, 20, 1, 25, -225))
table.insert(sliders, oUF_Lure_GenerateSlider(panels[#panels], 'RaidSpacingVertical', "Raid spacing (vertical)", 1, 50, 1, 25, -275))
table.insert(sliders, oUF_Lure_GenerateSlider(panels[#panels], 'RaidFrameWidth', "Raid frame width", 80, 200, 1, 25, -325))
table.insert(sliders, oUF_Lure_GenerateSlider(panels[#panels], 'RaidFrameHeight', "Raid frame height", 18, 100, 1, 225, -325))

table.insert(panels, oUF_Lure_GeneratePanel(panels[1], "Castbars", "oUF_Lure: Castbars"))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowPlayerCastbar', "Show player castbar", 15, -50))
table.insert(editboxes, oUF_Lure_GenerateEditBox(panels[#panels], 'PlayerCastbarPositionHorizontal', "Player castbar horizontal (enter = apply)", 25, -75))
table.insert(editboxes, oUF_Lure_GenerateEditBox(panels[#panels], 'PlayerCastbarPositionVertical', "Player castbar vertical (enter = apply)", 25, -100))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowTargetCastbar', "Show target castbar", 15, -150))
table.insert(editboxes, oUF_Lure_GenerateEditBox(panels[#panels], 'TargetCastbarPositionHorizontal', "Target castbar horizontal (enter = apply)", 25, -175))
table.insert(editboxes, oUF_Lure_GenerateEditBox(panels[#panels], 'TargetCastbarPositionVertical', "Target castbar vertical (enter = apply)", 25, -200))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowPetCastbar', "Show pet castbar", 15, -250))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowFocusCastbar', "Show focus castbar", 15, -275))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowCastbarIcons', "Show castbar icons", 15, -325))
table.insert(colorpickers, oUF_Lure_GenerateColorPicker(panels[#panels], 'CastbarColor', oUF_Lure_SaveCastbarColors, "Castbar color", 20, -375))

table.insert(panels, oUF_Lure_GeneratePanel(panels[1], "Buffs & Debuffs", "oUF_Lure: Buffs & Debuffs"))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowBuffsOnPlayer', "Buffs on player", 15, -50))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOnPlayer', "Debuffs on player", 15, -75))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'PlayerBuffsOnRight', "Player buffs on right", 15, -100))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowBuffsOnTarget', "Buffs on target", 215, -50))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOnTarget', "Debuffs on target", 215, -75))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'TargetBuffsOnRight', "Target buffs on right", 215, -100))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowBuffsOnPet', "Buffs on pet", 15, -150))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOnPet', "Debuffs on pet", 15, -175))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'PetBuffsOnRight', "Pet buffs on right", 15, -200))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowBuffsOnFocus', "Buffs on focus", 215, -150))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOnFocus', "Debuffs on focus", 215, -175))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'FocusBuffsOnRight', "Focus buffs on right", 215, -200))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOnTot', "Show debuffs on target of target", 15, -250))
table.insert(checkbuttons, oUF_Lure_GenerateCheckbutton(panels[#panels], 'HideBuffsAndDebuffsFromOthers', "Hide buffs and debuffs from others", 15, -300))
table.insert(sliders, oUF_Lure_GenerateSlider(panels[4], 'BuffsPerRow', "Buffs per row |cFFFF0000(needs ui reload)|cFFFFFFFF", 1, 30, 1, 125, -380))

addon:RegisterEvent("ADDON_LOADED")

function oUF_Lure_UpdateUI(self)

	table.foreach(checkbuttons, 
		function(i)
			checkbuttons[i]:SetChecked(oUF_Lure_SavedVars[checkbuttons[i].var])
		end
	)
	
	table.foreach(editboxes, 
		function(i)
			editboxes[i]:SetText(oUF_Lure_SavedVars[editboxes[i].var])
			editboxes[i]:SetCursorPosition(0)
		end
	)
	
	table.foreach(sliders, 
		function(i)
			sliders[i]:SetValue(oUF_Lure_SavedVars[sliders[i].var])
		end
	)
end

function addon:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == 'oUF_Lure' then
	
		table.foreach(panels, 
		function(i)
			panels[i].default = oUF_Lure_SetDefaultOptionsAndApply
			InterfaceOptions_AddCategory(panels[i])
		end
	)
		
		CheckAndFixSavedVars()
		
		oUF_Lure_UpdateUI()
		
		oUF_Lure_SpawnCore()
		oUF_Lure_SpawnPartyRaid()
	end
end

addon:SetScript("OnEvent", addon.OnEvent)

SlashCmdList["OUFL"] = function() 
	InterfaceOptionsFrame_OpenToCategory("oUF_Lure") 
end
SLASH_OUFL1 = "/oufl"