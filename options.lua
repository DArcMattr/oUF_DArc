local addon = CreateFrame("Frame")

local oUF_DArc_Defaults = {
  ["ShowReaction"] = true,
  ["ShowParty"] = true,
  ["HideBlizzardParty"] = true,
  ["NumRaidGroups"] = 8,
  ["ShowCombopoints"] = true,
  ["ShowHolyPower"] = true,
  ["ShowEclipse"] = true,
  ["ShowTotems"] = true,
  ["ShowSoulShards"] = true,
  ["ShowRunes"] = true,
  ["ShowRestingIcon"] = true,
  ["ShowCombatIcon"] = true,

  ["ShowRaid"] = true,
  ["HideBlizzardRaid"] = true,
  ["RaidFrameWidth"] = 80,
  ["RaidFrameHeight"] = 18,
  ["RaidSpacingHorizontal"] = 8,
  ["RaidSpacingVertical"] = 8,
  ["RaidNameLength"] = 9,
  ["NumRaidGroups"] = 8,
  ["ShowPortrait"] = {
    ["player"] = true,
    ["target"] = true,
    ["targettarget"] = true,
    ["pet"] = true,
    ["focus"] = true,
    ["party"] = true,
  },
  ["scale"] = {
    ["player"] = 1.0,
    ["target"] = 1.0,
    ["targettarget"] = 1.0,
    ["pet"] = 1.0,
    ["focus"] = 1.0,
    ["party"] = 1.0,
  },
  ["BuffSize"] = {
    ["player"] = 20,
    ["target"] = 20,
    ["targettarget"] = 20,
    ["pet"] = 20,
    ["focus"] = 20,
    ["party"] = 20,
  },
  ["ShowCastbar"] = {
    ["player"] = true,
    ["target"] = true,
    ["targettarget"] = true,
    ["pet"] = true,
    ["focus"] = true,
    ["party"] = true,
  },
  ["ShowCastbarIcon"] = {
    ["player"] = true,
    ["target"] = true,
    ["targettarget"] = true,
    ["pet"] = true,
    ["focus"] = true,
    ["party"] = true,
  },
  ["ShowBuffsOn"] = {
    ["player"] = true,
    ["target"] = true,
    ["targettarget"] = true,
    ["focus"] = true,
    ["party"] = true,
    ["pet"] = true,
  },
  ["ShowDebuffsOn"] = {
    ["player"] = true,
    ["target"] = true,
    ["targettarget"] = true,
    ["focus"] = true,
    ["party"] = true,
    ["pet"] = true,
  },
  ["ShowLevel"] = {
    ["player"] = true,
    ["target"] = true,
    ["targettarget"] = true,
    ["pet"] = true,
    ["focus"] = true,
    ["party"] = true,
  },
  ["BuffsOnRight"] = {
    ["player"] = true,
    ["target"] = true,
    ["targettarget"] = true,
    ["pet"] = true,
    ["focus"] = true,
    ["party"] = true,
  },
  ["PlayerBuffsOnRight"] = false,
  ["ShowIconCDCount"] = true,
  ["TargetBuffsOnRight"] = true,
  ["FocusBuffsOnRight"] = false,
  ["PetBuffsOnRight"] = false,
  ["BuffsPerRow"] = 30,
  ["HideBuffsAndDebuffsFromOthers"] = false,
  ["Extra_Width"] = 0,
  ["colors"] = {
    ["mana"] = {26/255, 139/255, 255/255},
    ["castbar"] = {0.5, 1, 0.5},
    ["fire_totem_slot"] = { 255/255, 165/255, 0/255 },
    ["earth_totem_slot"] = { 074/255, 142/255, 041/255 },
    ["water_totem_slot"] = { 057/255, 146/255, 181/255 },
    ["air_totem_slot"] = { 132/255, 056/255, 231/255 },
  },
};

local function SetDefaultOptions()
  oUF_DArc_SavedVars = {}

  for k, v in pairs(oUF_DArc_Defaults) do
    oUF_DArc_SavedVars[k] = v
  end
end

local function CheckAndFixSavedVars()
  if (oUF_DArc_SavedVars == nil) then
    SetDefaultOptions()
  else
    for k, v in pairs(oUF_DArc_Defaults) do
      if(oUF_DArc_SavedVars[k] == nil) then
        oUF_DArc_SavedVars[k] = v
      end
    end
  end
end

function oUF_DArc_SetDefaultOptionsAndApply()
  SetDefaultOptions()
  oUF_DArc_UpdateUI()
  oUF_DArc_ApplyOptions()
  oUF_DArc_ApplyPartyRaidOptions()
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

function oUF_DArc_SaveColors(restore)
  oUF_DArc_SavedVars.colors[restore] = GetColor(restore)
end

local panels = {}
local checkbuttons = {}
local editboxes = {}
local sliders = {}
local colorpickers = {}

table.insert(panels, oUF_DArc_GeneratePanel(UIParent, "oUF_DArc", "oUF_DArc: General Options"))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowCombopoints', "Show combo points", 15, -50))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowHolyPower', "Show holy power", 15, -75))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowEclipse', "Show eclipse", 15, -100))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowSoulShards', "Show soul shards", 15, -125))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowRunes', "Show runes", 15, -150))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowTotems', "Show totems", 15, -175))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowRestingIcon', "Show resting icon", 15, -200))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowCombatIcon', "Show combat icon", 15, -225))
table.insert(sliders,      oUF_DArc_GenerateSlider(     panels[#panels], 'Extra_Width', "Extra Width on Frames", 0, 100, 1, 25, -290)) -- sliders need 40 px of vertical space, 50 px is better

table.insert(panels, oUF_DArc_GeneratePanel(panels[1], "Player", "oUF_DArc: Player Frame Options"))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowBuffsOn.player', "Buffs on player", 15, -50))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOn.player', "Debuffs on player", 15, -75))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'BuffsOnRight.player', "Player buffs on right", 15, -100))
-- table.insert(sliders,      oUF_DArc_GenerateSlider(     panels[#panels], 'BuffSize.player', "Buff Size", 1, 40, 1, 15, -150))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowCastbar.player', "Show player castbar", 15, -175))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowCastbarIcon.player', "Show spell icon on player castbar", 15, -200))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowLevel.player', "Show level block", 15, -225))
-- table.insert(sliders,      oUF_DArc_GenerateSlider(     panels[#panels], 'scale.player', "Player Scale", 0, 1.0, .01, 25, -265))

table.insert(panels, oUF_DArc_GeneratePanel(panels[1], "Target and Target of Target", "oUF_DArc: Target & Target of Target Frame Options"))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowBuffsOn.target', "Buffs on target", 15, -75))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOn.target', "Debuffs on target", 15, -100))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'BuffsOnRight.target', "Target buffs on right", 15, -125))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowCastbar.target', "Show target castbar", 15, -150))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowCastbarIcon.target', "Show spell icon on target's castbar", 15, -175))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowLevel.target', "Show level block on target", 15, -200))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowReaction.target', "Show reaction colors on targets", 15, -225))
-- table.insert(sliders,      oUF_DArc_GenerateSlider(     panels[#panels], 'scale.target', "Target Scale", 0, 1.0, .01, 25, -275))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'Show.targettarget', "Show Target of Target", 265, -50))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowBuffsOn.targettarget', "Buffs on target of target", 265, -75))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOn.targettarget', "Debuffs on target of target", 265, -100))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'BuffsOnRight.targettarget', "Target of target buffs on right", 265, -125))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowCastbar.targettarget', "Show target of target castbar", 265, -150))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowCastbarIcon.targettarget', "Show spell icon on target of target's castbar", 265, -175))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowLevel.targettarget', "Show level block on Target of target", 265, -200))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowReaction.targettarget', "Show reaction Colors on target of target", 265, -225))
-- table.insert(sliders,      oUF_DArc_GenerateSlider(     panels[#panels], 'scale.targettarget', "Target of Target Scale", 0, 1.0, .01, 265, -275))

table.insert(panels, oUF_DArc_GeneratePanel(panels[1], "Focus", "oUF_DArc: Focus Frame Options"))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'Show.focus', "Show focus", 15, -50))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowBuffsOn.focus', "Buffs on focus", 15, -75))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOn.focus', "Debuffs on focus", 15, -100))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'BuffsOnRight.focus', "Focus buffs on right", 15, -125))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowCastbar.focus', "Show focus castbar", 15, -150))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowCastbarIcon.focus', "Show spell icon on focus' castbar", 15, -175))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowLevel.focus', "Show level block", 15, -200))
-- table.insert(sliders,      oUF_DArc_GenerateSlider(     panels[#panels], 'scale.focus', "Focus Scale", 0, 1.0, .01, 25, -240))

table.insert(panels, oUF_DArc_GeneratePanel(panels[1], "Pet & Pet Target", "oUF_DArc: Pet & Pet Target Frame Options"))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'Show.pet', "Show pet", 15, -50))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowBuffsOn.pet', "Buffs on pet", 15, -75))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOn.pet', "Debuffs on pet", 15, -100))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'BuffsOnRight.pet', "Pet buffs on right", 15, -125))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowCastbar.pet', "Show pet castbar", 15, -150))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowCastbarIcon.pet', "Show spell icon on pet's castbar", 15, -175))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowLevel.pet', "Show level block", 15, -200))
-- table.insert(sliders,      oUF_DArc_GenerateSlider(     panels[#panels], 'scale.pet', "Pet Scale", 0, 1.0, .01, 25, -240))

table.insert(panels, oUF_DArc_GeneratePanel(panels[1], "Party", "oUF_DArc: Party"))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowParty', "Show party frames", 15, -50))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'HideBlizzardParty', "Hide Blizzards party frames |cFFFF0000(needs ui reload)", 15, -125))

table.insert(panels, oUF_DArc_GeneratePanel(panels[1], "Raid", "oUF_DArc: Raid"))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowRaid', "Show raid frames", 15, -75))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'HideBlizzardRaid', "Hide Blizzards raid stuff |cFFFF0000(needs ui reload)", 15, -100))
table.insert(sliders, oUF_DArc_GenerateSlider(panels[#panels], 'NumRaidGroups', "Number of raid groups", 1, 8, 1, 25, -175))
table.insert(sliders, oUF_DArc_GenerateSlider(panels[#panels], 'RaidNameLength', "Raid name length", 2, 20, 1, 25, -225))
table.insert(sliders, oUF_DArc_GenerateSlider(panels[#panels], 'RaidSpacingVertical', "Raid spacing (vertical)", 1, 50, 1, 25, -275))
table.insert(sliders, oUF_DArc_GenerateSlider(panels[#panels], 'RaidFrameWidth', "Raid frame width", 80, 200, 1, 25, -325))
table.insert(sliders, oUF_DArc_GenerateSlider(panels[#panels], 'RaidFrameHeight', "Raid frame height", 18, 100, 1, 225, -325))

table.insert(panels, oUF_DArc_GeneratePanel(panels[1], "Colors", "oUF_DArc: Colors"))
table.insert(colorpickers, oUF_DArc_GenerateColorPicker(panels[#panels], 'castbar',          oUF_DArc_SaveColors, "Castbar color", 20, -50))
table.insert(colorpickers, oUF_DArc_GenerateColorPicker(panels[#panels], 'mana',             oUF_DArc_SaveColors, "Mana color", 20, -80))
table.insert(colorpickers, oUF_DArc_GenerateColorPicker(panels[#panels], 'fire_totem_slot',  oUF_DArc_SaveColors, "Fire Totem Color", 20, -110))
table.insert(colorpickers, oUF_DArc_GenerateColorPicker(panels[#panels], 'earth_totem_slot', oUF_DArc_SaveColors, "Earth Totem Color", 20, -140))
table.insert(colorpickers, oUF_DArc_GenerateColorPicker(panels[#panels], 'water_totem_slot', oUF_DArc_SaveColors, "Water Totem Color", 20, -170))
table.insert(colorpickers, oUF_DArc_GenerateColorPicker(panels[#panels], 'air_totem_slot',   oUF_DArc_SaveColors, "Air Totem Color", 20, -200))

table.insert(panels, oUF_DArc_GeneratePanel(panels[1], "Buffs & Debuffs", "oUF_DArc: Buffs & Debuffs"))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowBuffsOnPet', "Buffs on pet", 15, -150))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOnPet', "Debuffs on pet", 15, -175))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'PetBuffsOnRight', "Pet buffs on right", 15, -200))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowBuffsOnFocus', "Buffs on focus", 215, -150))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOnFocus', "Debuffs on focus", 215, -175))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'FocusBuffsOnRight', "Focus buffs on right", 215, -200))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowDebuffsOnTot', "Show debuffs on target of target", 15, -250))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'HideBuffsAndDebuffsFromOthers', "Hide buffs and debuffs from others", 15, -300))
table.insert(checkbuttons, oUF_DArc_GenerateCheckbutton(panels[#panels], 'ShowIconCDCount', "Show Cooldown Count |cFFFF0000(needs ui reload)", 15, -325))
-- table.insert(sliders,      oUF_DArc_GenerateSlider(     panels[#panels], 'BuffsPerRow', "Buffs per row |cFFFF0000(needs ui reload)|cFFFFFFFF", 1, 30, 1, 125, -380))

addon:RegisterEvent("ADDON_LOADED")

function oUF_DArc_UpdateUI(self)

  table.foreach(checkbuttons,
    function(i)
      checkbuttons[i]:SetChecked(oUF_DArc_SavedVars[checkbuttons[i].var])
      print(checkbuttons[i].var)
    end
  )

  table.foreach(editboxes,
    function(i)
      editboxes[i]:SetText(oUF_DArc_SavedVars[editboxes[i].var])
      editboxes[i]:SetCursorPosition(0)
      print(editboxes[i].var)
    end
  )

  table.foreach(sliders,
    function(i)
      sliders[i]:SetValue(oUF_DArc_SavedVars[sliders[i].var])
      print(sliders[i].var)
    end
  )
end

function addon:OnEvent(event, arg1)
  if event == "ADDON_LOADED" and arg1 == 'oUF_DArc' then

    table.foreach(panels,
    function(i)
      panels[i].default = oUF_DArc_SetDefaultOptionsAndApply
      InterfaceOptions_AddCategory(panels[i])
    end
  )

    CheckAndFixSavedVars()

    oUF_DArc_UpdateUI()

    oUF_DArc_SpawnCore()
    oUF_DArc_SpawnPartyRaid()
  end
end

addon:SetScript("OnEvent", addon.OnEvent)

SlashCmdList["OUFD"] = function()
  InterfaceOptionsFrame_OpenToCategory("oUF_DArc")
end
SLASH_OUFD1 = "/oufd"
