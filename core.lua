local frame_width = 240
local extra_width = 0 -- oUF_DArc_SavedVars.Extra_Width
local frame_height = 72
local border_width = 3
local barheight = floor( frame_height * .3 )
local cp_height = 5

-- from P3Lim http://www.wowinterface.com/forums/showpost.php?p=250227&postcount=6
for _, menu in pairs( UnitPopupMenus ) do
  for button, name in pairs(menu) do
    if( name == 'SET_FOCUS') then
      table.remove(menu, button)
    elseif( name == 'CLEAR_FOCUS') then
      table.remove(menu, button)
    elseif( name == 'MOVE_PLAYER_FRAME') then
      table.remove(menu, button)
    elseif( name == 'MOVE_TARGET_FRAME') then
      table.remove(menu, button)
    elseif( name == 'LOCK_FOCUS_FRAME') then
      table.remove(menu, button)
    elseif( name == 'UNLOCK_FOCUS_FRAME') then
      table.remove(menu, button)
    elseif( name == 'PET_DISMISS') then
      table.remove(menu, button)
    end
  end
end

local function LayoutPlayer(self, unit)
  oUF_DArc_SetupFrame(self)
  self:SetSize( ( frame_width + extra_width ), frame_height )
  self:SetPoint('CENTER', -210, -50, "BOTTOMLEFT")
  oUF_DArc_AddPortrait(self,unit)
  oUF_DArc_AddNameBar(self, unit)
  oUF_DArc_AddLevelBlock(self)
  oUF_DArc_AddHealthPowerBar(self, unit)
  oUF_DArc_AddRaidIcons(self)
  oUF_DArc_AddBuffs(self, unit)
  oUF_DArc_AddDebuffs(self)
  oUF_DArc_AddCastBar(self)
  oUF_DArc_AddHealPrediction(self)
  oUF_DArc_AddDebuffHighLight(self)
  oUF_DArc_AddCombatIcon(self)
  oUF_DArc_AddRestingIcon(self)
end

local function LayoutPlayer2(self, unit)
--  oUF_DArc_SetupFrame(self)
  self:SetSize(( frame_width + extra_width ) - frame_height, barheight / 2 )
  self:SetPoint('CENTER', 0, -115, 'CENTER')
  oUF_DArc_AddSecondaryPowerBar(self, unit)
  oUF_DArc_AddCombopoints(self, unit)
  oUF_DArc_AddAltPowerBar(self)
  oUF_DArc_AddRunes(self)
  oUF_DArc_AddEclipse(self)
  oUF_DArc_AddSoulShards(self)
  oUF_DArc_AddHolyPower(self)
  oUF_DArc_AddTotems(self)
end

local function LayoutTarget(self, unit)
  oUF_DArc_SetupFrame(self)
  self:SetSize(( frame_width + extra_width ), frame_height)
  self:SetPoint('CENTER', 210, -50, "BOTTOMRIGHT")
  oUF_DArc_AddPortrait(self, unit)
  oUF_DArc_AddNameBar(self, unit)
  oUF_DArc_AddLevelBlock(self, unit)
  oUF_DArc_AddHealthPowerBar(self, unit)
  oUF_DArc_AddRaidIcons(self)
  oUF_DArc_AddBuffs(self, unit)
  oUF_DArc_AddDebuffs(self)
  oUF_DArc_AddCastBar(self)
  oUF_DArc_AddHealPrediction(self)
  oUF_DArc_AddDebuffHighLight(self)
end

local function LayoutTot(self, unit)
  oUF_DArc_SetupFrame(self)
  self:SetSize(( frame_width + extra_width ), frame_height)
  self:SetPoint('CENTER', 0, -350)
  oUF_DArc_AddPortrait(self,unit)
  oUF_DArc_AddNameBar(self, unit)
  oUF_DArc_AddLevelBlock(self, unit)
  oUF_DArc_AddHealthPowerBar(self, unit)
  oUF_DArc_AddRaidIcons(self)
  oUF_DArc_AddBuffs(self, unit)
  oUF_DArc_AddDebuffs(self, unit)
  oUF_DArc_FixTotDebuffPosition(self)
  oUF_DArc_AddCastBar(self)
  oUF_DArc_AddHealPrediction(self)
  oUF_DArc_AddDebuffHighLight(self)
end

local function LayoutPet(self, unit)
  oUF_DArc_SetupFrame(self)
  self:SetSize(( frame_width + extra_width ), frame_height)
  self:SetPoint('CENTER', 310, -440)
  oUF_DArc_AddPortrait(self,unit)
  oUF_DArc_AddNameBar(self, unit)
  oUF_DArc_AddHealthPowerBar(self, unit)
  oUF_DArc_AddLevelBlock(self, unit)
  oUF_DArc_AddRaidIcons(self)
  oUF_DArc_AddBuffs(self, unit)
  oUF_DArc_AddDebuffs(self)
  oUF_DArc_AddCastBar(self)
  oUF_DArc_AddHealPrediction(self)
  oUF_DArc_AddDebuffHighLight(self)
end

local function LayoutFocus(self, unit)
  oUF_DArc_SetupFrame(self)
  self:SetSize(( frame_width + extra_width ), frame_height)
  self:SetPoint('CENTER', -310, -390)
  oUF_DArc_AddPortrait(self,unit)
  oUF_DArc_AddNameBar(self, unit)
  oUF_DArc_AddHealthPowerBar(self, unit)
  oUF_DArc_AddRaidIcons(self)
  oUF_DArc_AddLevelBlock(self, unit)
  oUF_DArc_AddBuffs(self, unit)
  oUF_DArc_AddDebuffs(self)
  oUF_DArc_AddCastBar(self)
  oUF_DArc_AddHealPrediction(self)
  oUF_DArc_AddDebuffHighLight(self)
end

function oUF_DArc_SpawnCore(self)
  oUF:RegisterStyle('DArcPlayer', LayoutPlayer)
  oUF:SetActiveStyle('DArcPlayer')
  oUF:Spawn('player', 'oUF_player')

  oUF:RegisterStyle('DArcPlayer2', LayoutPlayer2)
  oUF:SetActiveStyle('DArcPlayer2')
  oUF:Spawn('player', 'oUF_player2')

  oUF:RegisterStyle('DArcTarget', LayoutTarget)
  oUF:SetActiveStyle('DArcTarget')
  oUF:Spawn('target', 'oUF_target')

  oUF:RegisterStyle('DArcTot', LayoutTot)
  oUF:SetActiveStyle('DArcTot')
  oUF:Spawn('targettarget', 'oUF_targettarget')

  oUF:RegisterStyle('DArcPet', LayoutPet)
  oUF:SetActiveStyle('DArcPet')
  oUF:Spawn('pet', 'oUF_pet')

  oUF:RegisterStyle('DArcFocus', LayoutFocus)
  oUF:SetActiveStyle('DArcFocus')
  oUF:Spawn('focus', 'oUF_focus')
  --oUF:Spawn('boss1', 'oUF_focus')
  --oUF:Spawn('boss2', 'oUF_focus')
  --oUF:Spawn('boss3', 'oUF_focus')

  oUF_DArc_ApplyOptions()
end
