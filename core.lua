local frame_width = 300
local frame_width_small = 200
local frame_height = 37
local frame_height_small = 18

local function LayoutPlayer(self, unit)
	oUF_DArc_SetupFrame(self)
	self:SetSize(frame_width, frame_height)
	self:SetPoint('CENTER', 0, -440)
	oUF_DArc_AddHealthBar(self)
	oUF_DArc_AddHealthBarTextHealth(self)
	oUF_DArc_AddPowerBar(self)
	oUF_DArc_AddPowerBarTextPower(self)
	oUF_DArc_AddAltPowerBar(self)
	oUF_DArc_AddRaidIcons(self)
	oUF_DArc_AddBuffs(self)
	oUF_DArc_AddDebuffs(self)
	oUF_DArc_AddCastBar(self)
	oUF_DArc_AddRunes(self)
	oUF_DArc_AddEclipse(self)
	oUF_DArc_AddSoulShards(self)
	oUF_DArc_AddHolyPower(self)
	oUF_DArc_AddTotems(self)
	oUF_DArc_AddHealPrediction(self)
	oUF_DArc_AddDebuffHighLight(self)
	oUF_DArc_AddCombatIcon(self)
	oUF_DArc_AddRestingIcon(self)
end

local function LayoutTarget(self, unit)
	oUF_DArc_SetupFrame(self)
	self:SetSize(frame_width, frame_height)
	self:SetPoint('CENTER', 0, -390)
	oUF_DArc_AddHealthBar(self)
	oUF_DArc_AddHealthBarTextHealth(self)
	oUF_DArc_AddHealthBarTextNameLeft(self)
	oUF_DArc_AddHealthBarTextPercent(self)
	oUF_DArc_AddPowerBar(self)
	oUF_DArc_AddPowerBarTextPower(self)
	oUF_DArc_AddPowerBarTextPercent(self)
	oUF_DArc_AddPowerBarTextLevel(self)
	oUF_DArc_AddRaidIcons(self)
	oUF_DArc_AddBuffs(self)
	oUF_DArc_AddDebuffs(self)
	oUF_DArc_AddCastBar(self)
	oUF_DArc_AddCombopoints(self)
	oUF_DArc_AddHealPrediction(self)
	oUF_DArc_AddDebuffHighLight(self)
end

local function LayoutTot(self, unit)
	oUF_DArc_SetupFrame(self)
	self:SetSize(frame_width_small, frame_height_small)
	self:SetPoint('CENTER', 0, -350)
	oUF_DArc_AddHealthBar(self)
	oUF_DArc_AddHealthBarTextNameCenter(self)
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
	oUF_DArc_AddHealthBar(self)
	oUF_DArc_AddHealthBarTextHealth(self)
	oUF_DArc_AddHealthBarTextNameLeft(self)
	oUF_DArc_AddHealthBarTextPercent(self)
	oUF_DArc_AddAltPowerBar(self)
	oUF_DArc_AddPowerBar(self)
	oUF_DArc_AddPowerBarTextPower(self)
	oUF_DArc_AddPowerBarTextPercent(self)
	oUF_DArc_AddPowerBarTextLevel(self)
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
	oUF_DArc_AddHealthBar(self)
	oUF_DArc_AddHealthBarTextHealth(self)
	oUF_DArc_AddHealthBarTextNameLeft(self)
	oUF_DArc_AddHealthBarTextPercent(self)
	oUF_DArc_AddPowerBar(self)
	oUF_DArc_AddPowerBarTextPower(self)
	oUF_DArc_AddPowerBarTextPercent(self)
	oUF_DArc_AddPowerBarTextLevel(self)
	oUF_DArc_AddRaidIcons(self)
	oUF_DArc_AddBuffs(self)
	oUF_DArc_AddDebuffs(self)
	oUF_DArc_AddCastBar(self)
	oUF_DArc_AddHealPrediction(self)
	oUF_DArc_AddDebuffHighLight(self)
end

function oUF_DArc_SpawnCore(self)

	oUF:RegisterStyle('LurePlayer', LayoutPlayer)
	oUF:SetActiveStyle('LurePlayer')
	oUF:Spawn('player', 'oUF_player')
	
	oUF:RegisterStyle('LureTarget', LayoutTarget)
	oUF:SetActiveStyle('LureTarget')
	oUF:Spawn('target', 'oUF_target')
	
	oUF:RegisterStyle('LureTot', LayoutTot)
	oUF:SetActiveStyle('LureTot')
	oUF:Spawn('targettarget', 'oUF_targettarget')
	
	oUF:RegisterStyle('LurePet', LayoutPet)
	oUF:SetActiveStyle('LurePet')
	oUF:Spawn('pet', 'oUF_pet')

	oUF:RegisterStyle('LureFocus', LayoutFocus)
	oUF:SetActiveStyle('LureFocus')
	oUF:Spawn('focus', 'oUF_focus')
	
	oUF_DArc_ApplyOptions()
end
