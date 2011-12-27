-- local frame_width_small = oUF_DArc_SavedVars.SmallFrameWidth
local frame_width = 240 -- oUF_DArc_SavedVars.Frame_Width
local frame_height = 75
local frame_barheight = 18
local cp_height = 5

local function LayoutPlayer(self, unit)
  oUF_DArc_SetupFrame(self)
  self:SetSize( frame_width, frame_height )
  self:SetPoint('CENTER', -210, -50, "BOTTOMLEFT")
  oUF_DArc_AddPortrait(self)
  oUF_DArc_AddNameBar(self, unit)
  oUF_DArc_AddLevelBlock(self)
  oUF_DArc_AddHealthPowerBar(self, unit)
  oUF_DArc_AddRaidIcons(self)
  oUF_DArc_AddBuffs(self)
  oUF_DArc_AddDebuffs(self)
  oUF_DArc_AddCastBar(self)
  oUF_DArc_AddHealPrediction(self)
  oUF_DArc_AddDebuffHighLight(self)
  oUF_DArc_AddCombatIcon(self)
  oUF_DArc_AddRestingIcon(self)
end

local function LayoutPlayer2(self, unit)
  oUF_DArc_SetupFrame(self)
  self:SetSize(frame_width-frame_height, frame_barheight / 2 )
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
  self:SetSize(frame_width, frame_height)
  self:SetPoint('CENTER', 210, -50, "BOTTOMRIGHT")
  oUF_DArc_AddPortrait(self)
  oUF_DArc_AddNameBar(self, unit)
  oUF_DArc_AddLevelBlock(self, unit)
  oUF_DArc_AddHealthPowerBar(self, unit)
  oUF_DArc_AddRaidIcons(self)
  oUF_DArc_AddBuffs(self)
  oUF_DArc_AddDebuffs(self)
  oUF_DArc_AddCastBar(self)
  oUF_DArc_AddHealPrediction(self)
  oUF_DArc_AddDebuffHighLight(self)
end

local function LayoutTot(self, unit)
  oUF_DArc_SetupFrame(self)
  self:SetSize(frame_width, frame_height)
  self:SetPoint('CENTER', 0, -350)
  oUF_DArc_AddNameBar(self, unit)
  oUF_DArc_AddLevelBlock(self, unit)
  oUF_DArc_AddHealthPowerBar(self, unit)
  oUF_DArc_AddRaidIcons(self)
  oUF_DArc_AddDebuffs(self)
  oUF_DArc_FixTotDebuffPosition(self)
  oUF_DArc_AddHealPrediction(self)
  oUF_DArc_AddDebuffHighLight(self)
end

local function LayoutPet(self, unit)
  oUF_DArc_SetupFrame(self)
  self:SetSize(frame_width, frame_height)
  self:SetPoint('CENTER', 310, -440)
  oUF_DArc_AddNameBar(self, unit)
  oUF_DArc_AddHealthPowerBar(self, unit)
  oUF_DArc_AddRaidIcons(self)
  oUF_DArc_AddBuffs(self)
  oUF_DArc_AddDebuffs(self)
  oUF_DArc_AddCastBar(self)
  oUF_DArc_AddHealPrediction(self)
  oUF_DArc_AddDebuffHighLight(self)
end

local function LayoutFocus(self, unit)
  oUF_DArc_SetupFrame(self)
  self:SetSize(frame_width, frame_height)
  self:SetPoint('CENTER', -310, -390)
  oUF_DArc_AddNameBar(self, unit)
  oUF_DArc_AddHealthPowerBar(self, unit)
  oUF_DArc_AddRaidIcons(self)
  oUF_DArc_AddBuffs(self)
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

  oUF_DArc_ApplyOptions()
end
