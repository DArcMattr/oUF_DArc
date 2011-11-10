local bartexture = [[Interface\AddOns\SharedMedia\statusbar\minimalist.tga]]
local bufftexture = 'Interface\\AddOns\\oUF_DArc\\texture\\buff'
local backdrop = {bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = -2, left = -2, bottom = -2, right = -2}}
local font = 'GameFontHighlightSmallLeft'

local width = 300
-- local width = oUF_DArc_SavedVars.LargeFrameWidth
local barheight = 18

oUF.colors.power['MANA'] = {26/255, 139/255, 255/255}
oUF.colors.totems = {
	[FIRE_TOTEM_SLOT] = { 255/255, 165/255, 0/255 },
	[EARTH_TOTEM_SLOT] = { 074/255, 142/255, 041/255 },
	[WATER_TOTEM_SLOT] = { 057/255, 146/255, 181/255 },
	[AIR_TOTEM_SLOT] = { 132/255, 056/255, 231/255 }
}
local _, class = UnitClass('player')

local menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub('(.)', string.upper, 1)

	if(unit == 'party' or unit == 'partypet') then
		ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor', 0, 0)
	elseif(_G[cunit..'FrameDropDown']) then
		ToggleDropDownMenu(1, nil, _G[cunit..'FrameDropDown'], 'cursor', 0, 0)
	end
end

local function updateCombo(self, event, unit)
	if(unit == PlayerFrame.unit and unit ~= self.CPoints.unit) then
		self.CPoints.unit = unit
	end
end

local PostCreateIcon = function(Auras, button)
	button.icon:SetTexCoord(.07, .93, .07, .93)

	button.overlay:SetTexture(bufftexture)
	button.overlay:SetTexCoord(0,1,0,1)
	button.overlay.Hide = function(self) self:SetVertexColor(0.3, 0.3, 0.3) end
	
	button.cd:SetReverse()
	button.cd.noCooldownCount = not oUF_DArc_SavedVars.ShowIconCDCount
end

local PostUpdateIcon
do
	local playerUnits = {
		player = true,
		pet = true,
		vehicle = true,
	}

	PostUpdateIcon = function(icons, unit, icon, index, offset)
		if oUF_DArc_SavedVars.HideBuffsAndDebuffsFromOthers then
			local _, _, _, _, _, _, _, unitCaster, _ = UnitAura(unit, index, icon.filter)
			if not playerUnits[unitCaster] then
				icon:Hide()
			end
		end

		icon.first = true
	end
end

function oUF_DArc_SetupFrame(self)
	self.menu = menu
	self:RegisterForClicks('AnyDown')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self:SetAttribute('*type2', 'menu')
	
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0)
	
	self.backdrop2 = CreateFrame('StatusBar', nil, self)
	self.backdrop2:SetStatusBarTexture(bartexture)
	self.backdrop2:SetStatusBarColor(0, 0, 0)
	self.backdrop2:SetAllPoints(self)
	self.backdrop2:SetFrameLevel(3)
end

function oUF_DArc_AddNameBar(self)
	self.Name = CreateFrame('StatusBar', nil, self)
	self.Name:SetStatusBarTexture(bartexture)
	self.Name:SetHeight(barheight)

	self.Name:SetParent(self)
	self.Name:SetPoint'TOP'
	self.Name:SetPoint'LEFT'
	self.Name:SetPoint'RIGHT'
	
	self.Name.colorTapping = true
	self.Name:SetFrameLevel(5)

	local unitname = self.Name:CreateFontString(nil, 'OVERLAY', font)
	self:Tag(unitname,'[name]')
	unitname:SetPoint('LEFT', self.Name, 2, 0)
  unitname.colorReaction = true

	local level = self.Name:CreateFontString(nil, 'OVERLAY', font)
	self:Tag(level,'[level]')
	level:SetPoint('RIGHT', self.Name, -3, 0)
  level.colorClass = true
end

function oUF_DArc_AddHealthBar(self)
	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetStatusBarTexture(bartexture)
	self.Health:SetHeight(barheight)
	self.Health:SetPoint('TOP', self.Name, 'BOTTOM', 0, -1)

	self.Health:SetParent(self)
	self.Health:SetPoint'LEFT'
	self.Health:SetPoint'RIGHT'
	
	self.Health.colorSmooth = true
	self.Health.colorTapping = true
--	self.Health.colorReaction = true
	self.Health.Smooth = true
	self.Health:SetFrameLevel(5)
end

function oUF_DArc_AddHealthBarTextHealth(self)
	local health = self.Health:CreateFontString(nil, 'OVERLAY', font)
	health:SetPoint('RIGHT', self.Health, -3, 0)
	self:Tag(health,'[curhp]/[maxhp]')
end

function oUF_DArc_AddHealthBarTextNameLeft(self)
	local unitnames = self.Health:CreateFontString(nil, 'OVERLAY', font)
	self:Tag(unitnames,'[name]')
	unitnames:SetPoint('LEFT', self.Health, 2, 0)
end

function oUF_DArc_AddHealthBarTextNameCenter(self)
	local unitnames = self.Health:CreateFontString(nil, 'OVERLAY', font)
	self:Tag(unitnames,'[name]')
	unitnames:SetPoint('CENTER', self, 0, 0)
end

function oUF_DArc_AddHealthBarTextPercent(self)
	local healthpercent = self.Health:CreateFontString(nil, 'OVERLAY', font)
	healthpercent:SetPoint('CENTER', self.Health, 0, 0)
	self:Tag(healthpercent,'[perhp]%')
end

function oUF_DArc_AddPowerBar(self)
	self.Power = CreateFrame('StatusBar', nil, self)
	self.Power:SetStatusBarTexture(bartexture)
	self.Power:SetHeight(barheight)
	self.Power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1)

	self.Power:SetParent(self)
	self.Power:SetPoint'LEFT'
	self.Power:SetPoint'RIGHT'

	self.Power.colorPower = true
	self.Power.Smooth = true
	self.Power:SetFrameLevel(5)
	self.Power.frequentUpdates = true
end

function oUF_DArc_AddPowerBarTextPower(self)
	local power = self.Power:CreateFontString(nil, 'OVERLAY', font)
	power:SetPoint('RIGHT', self.Power, -3, 0)
	self:Tag(power,'[curpp]/[maxpp]')
end

function oUF_DArc_AddPowerBarTextPercent(self)
	local powerpercent = self.Health:CreateFontString(nil, 'OVERLAY', font)
	powerpercent:SetPoint('CENTER', self.Power, 0, 0)
	self:Tag(powerpercent,'[perpp]%')
end

function oUF_DArc_AddPowerBarTextLevel(self)
	local level = self.Power:CreateFontString(nil, 'OVERLAY', font)
	level:SetPoint('LEFT', self.Power, 2, 0)
	self:Tag(level,'[level]')
end

function oUF_DArc_AddRaidIcons(self)
	self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	self.RaidIcon:SetHeight(16)
	self.RaidIcon:SetWidth(16)
	self.RaidIcon:SetPoint('TOP', self, 0, 9)
	self.RaidIcon:SetTexture'Interface\\TargetingFrame\\UI-RaidTargetingIcons'
end

function oUF_DArc_AddBuffs(self)
	self.Buffs = CreateFrame('Frame', nil, self)
	self.Buffs.size = 21
	self.Buffs:SetHeight(self.Buffs.size)
	self.Buffs.num = 30
	self.Buffs.spacing = 0
	self.Buffs.PostCreateIcon = PostCreateIcon
	self.Buffs.PostUpdateIcon = PostUpdateIcon
end

function oUF_DArc_AddDebuffs(self)
	self.Debuffs = CreateFrame('Frame', nil, self)
	self.Debuffs.size = 21
	self.Debuffs:SetHeight(self.Debuffs.size)
	self.Debuffs.num = 30
	self.Debuffs.spacing = 0
	self.Debuffs.PostCreateIcon = PostCreateIcon
	self.Debuffs.PostUpdateIcon = PostUpdateIcon
end

function oUF_DArc_AddCombatIcon(self)
	self.CombatIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	self.CombatIcon:SetPoint('CENTER', self.Power, 'TOPLEFT', -20, 1)
	self.CombatIcon:SetHeight(26)
	self.CombatIcon:SetWidth(26)
	self.CombatIcon:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
	self.CombatIcon:SetTexCoord(0.58, 0.90, 0.08, 0.41)
	self.Combat = self.CombatIcon
end

function oUF_DArc_AddRestingIcon(self)
	self.RestingIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	self.RestingIcon:SetPoint('CENTER', self.Power, 'TOPLEFT', -20, 1)
	self.RestingIcon:SetHeight(26)
	self.RestingIcon:SetWidth(26)
	self.RestingIcon:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
	self.RestingIcon:SetTexCoord(0.09, 0.43, 0.08, 0.42)
	self.Resting = self.RestingIcon 
end

function oUF_DArc_AddCastBar(self, x, y)
	self.Castbar = CreateFrame('StatusBar', nil, self)
	self.Castbar:SetBackdrop(backdrop)
	self.Castbar:SetBackdropColor(0, 0, 0)
	self.Castbar:SetWidth(width)
	self.Castbar:SetHeight(barheight)
	self.Castbar:SetStatusBarTexture(bartexture)

	self.Castbar:SetParent(self)
	self.Castbar:SetPoint'TOP'
	self.Castbar:SetPoint'LEFT'
	self.Castbar:SetPoint'RIGHT'
	self.Castbar:SetFrameLevel(6)
	
	self.Castbar.Text = self.Castbar:CreateFontString(nil, 'OVERLAY', font)
	self.Castbar.Text:SetPoint('LEFT', self.Castbar, 2, 0)
	self.Castbar.Text:SetTextColor(1, 1, 1)

	self.Castbar.Time = self.Castbar:CreateFontString(nil, 'OVERLAY', font)
	self.Castbar.Time:SetPoint('RIGHT', self.Castbar, -3, 0)
	self.Castbar.Time:SetTextColor(1, 1, 1)
	
	self.Castbar.Icon = self.Castbar:CreateTexture(nil, 'ARTWORK')
    self.Castbar.Icon:SetSize(21,21)
	self.Castbar.Icon:SetTexCoord(0, 1, 0, 1)
	self.Castbar.Icon:SetPoint('RIGHT', self.Castbar, 'LEFT', 0, 0)
	
	self.Castbar.Icon.bg = self.Castbar:CreateTexture(nil, 'OVERLAY')
	self.Castbar.Icon.bg:SetPoint("TOPLEFT", self.Castbar.Icon, "TOPLEFT")
	self.Castbar.Icon.bg:SetPoint("BOTTOMRIGHT", self.Castbar.Icon, "BOTTOMRIGHT")
	self.Castbar.Icon.bg:SetTexture(bufftexture)
	self.Castbar.Icon.bg:SetVertexColor(0.25, 0.25, 0.25)		
	
	self.Castbar:SetPoint('CENTER', self, x, y)
end

function oUF_DArc_AddRunes(self)
	if class == 'DEATHKNIGHT' then
		local runes = CreateFrame('Frame', nil, self)
		runes:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
		runes:SetSize(width, 5)
		runes:SetBackdrop(backdrop)
		runes:SetBackdropColor(0, 0, 0)
		
		for i = 1, 6 do
			local rune = CreateFrame('StatusBar', nil, runes)
			rune:SetStatusBarTexture(bartexture)

			if i > 1 then
				if i == 6 then
					rune:SetSize(49, 5)
				else
					rune:SetSize(48, 5)
				end
				rune:SetPoint('LEFT', runes[i - 1], 'RIGHT', 2, 0)
			else
				rune:SetSize(49, 5)
				rune:SetPoint('BOTTOMLEFT', runes, 'BOTTOMLEFT', 0, 0)
			end

			local runeBG = rune:CreateTexture(nil, 'BACKGROUND')
			runeBG:SetAllPoints(rune)
			runeBG:SetTexture(1 / 3, 1 / 3, 1 / 3)
			
			rune.bg = runeBG
			runes[i] = rune
		end
		self.Runes = runes
	end
end

function oUF_DArc_AddEclipse(self)
	if class == 'DRUID' then
		local eclipseBar = CreateFrame('Frame', nil, self)
		eclipseBar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
		eclipseBar:SetSize(width, 5)
		eclipseBar:SetBackdrop(backdrop)
		eclipseBar:SetBackdropColor(0, 0, 0)

		local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
		lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
		lunarBar:SetSize(width, 5)
		lunarBar:SetStatusBarTexture(bartexture)
		lunarBar:SetStatusBarColor(0, 0, 1)
		eclipseBar.LunarBar = lunarBar

		local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
		solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
		solarBar:SetSize(width, 5)
		solarBar:SetStatusBarTexture(bartexture)
		solarBar:SetStatusBarColor(1, 0.8, 0)
		eclipseBar.SolarBar = solarBar
		
		self.EclipseBar = eclipseBar
	end
end

function oUF_DArc_AddCombopoints(self)
	if (class == 'DRUID' or class == 'ROGUE') then
		local combopoints = CreateFrame('StatusBar', nil, self)
		combopoints:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -2)
		combopoints:SetSize(width, 5)
		combopoints:SetBackdrop(backdrop)
		combopoints:SetBackdropColor(0, 0, 0)

		for id = 1, 5 do
			local point = combopoints:CreateTexture(nil, 'OVERLAY')
			point:SetTexture(1, 0.8, 0)

			if id > 1 then
				point:SetSize(58, 5)
				point:SetPoint('BOTTOMLEFT', combopoints[id-1], 'BOTTOMRIGHT', 2, 0)
			else
				point:SetSize(59, 5)
				point:SetPoint('BOTTOMLEFT', combopoints, 'BOTTOMLEFT', 0, 0)
			end

			combopoints[id] = point
		end

		self.CPoints = combopoints
	end
end

function oUF_DArc_AddSoulShards(self)
	if class == 'WARLOCK' then
		local shards = CreateFrame('StatusBar', nil, self)
		shards:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -2)
		shards:SetSize(width, 5)
		shards:SetBackdrop(backdrop)
		shards:SetBackdropColor(0, 0, 0)

		for id = 1, 3 do
			local shard = shards:CreateTexture(nil, 'OVERLAY')
			shard:SetTexture(1, 0.8, 0)

			if id > 1 then
				shard:SetSize(99, 5)
				shard:SetPoint('BOTTOMLEFT', shards[id-1], 'BOTTOMRIGHT', 2, 0)
			else
				shard:SetSize(98, 5)
				shard:SetPoint('BOTTOMLEFT', shards, 'BOTTOMLEFT', 0, 0)
			end

			shards[id] = shard
		end

		self.SoulShards = shards
	end
end

function oUF_DArc_AddHolyPower(self)
	if class =='PALADIN' then
		local holypower = CreateFrame('StatusBar', nil, self)
		holypower:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -2)
		holypower:SetSize(width, 5)
		holypower:SetBackdrop(backdrop)
		holypower:SetBackdropColor(0, 0, 0)

		for id = 1, 3 do
			local hp = holypower:CreateTexture(nil, 'OVERLAY')
			hp:SetTexture(1, 0.8, 0)

			if id > 1 then
				hp:SetSize(99, 5)
				hp:SetPoint('BOTTOMLEFT', holypower[id-1], 'BOTTOMRIGHT', 2, 0)
			else
				hp:SetSize(98, 5)
				hp:SetPoint('BOTTOMLEFT', holypower, 'BOTTOMLEFT', 0, 0)
			end

			holypower[id] = hp
		end

		self.HolyPower = holypower
	end
end

function oUF_DArc_AddTotems(self)
	if class == 'SHAMAN' then
		local totems = CreateFrame('Frame', nil, self)
		totems:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
		totems:SetSize(width, 5)
		totems:SetBackdrop(backdrop)
		totems:SetBackdropColor(0, 0, 0)
		
		for i = 1, 4 do
			local totem = CreateFrame('StatusBar', nil, totems)
			totem:SetSize(73.5, 5)
			totem:SetStatusBarTexture(bartexture)
			totem:SetStatusBarColor(unpack(oUF.colors.totems[i]))
			
			totem.Cooldown = totem
			totem.Cooldown.SetCooldown = function(totem, start, duration)
				totem.start = start
				totem.duration = duration
				totem:SetMinMaxValues(1, duration)
			end
			
			totem:SetScript("OnUpdate", 
				function()
					totem:SetValue(totem.start+totem.duration-GetTime())
				end
			);
			
			if i > 1 then
				totem:SetPoint('LEFT', totems[i - 1], 'RIGHT', 2, 0)
			else
				totem:SetPoint('BOTTOMLEFT', totems, 'BOTTOMLEFT', 0, 0)
			end
			
			local totemBG = totems:CreateTexture(nil, 'BACKGROUND')
			totemBG:SetAllPoints(totem)
			totemBG:SetTexture(unpack(oUF.colors.totems[i]))
			totemBG:SetVertexColor(1/3, 1/3, 1/3)
			
			totems[i] = totem
		end

		self.Totems = totems
		--totems.PostUpdate = PostUpdateTotem
	end
end

function oUF_DArc_AddHealPrediction(self)
	local mhpb = CreateFrame('StatusBar', nil, self.Health)
	mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
	mhpb:SetWidth(self.Health:GetWidth())
	mhpb:SetStatusBarTexture(bartexture)
	mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)
	mhpb:SetFrameLevel(4)
	
	local ohpb = CreateFrame('StatusBar', nil, self.Health)
	ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
	ohpb:SetWidth(self.Health:GetWidth())
	ohpb:SetStatusBarTexture(bartexture)
	ohpb:SetStatusBarColor(0, 1, 0, 0.25)
	ohpb:SetFrameLevel(4)
	
	self.HealPrediction = {
		myBar = mhpb,
		otherBar = ohpb,
		maxOverflow = 1,
	}
end

function oUF_DArc_AddDebuffHighLight(self)
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true
end

function oUF_DArc_AddAltPowerBar(self)
	self.AltPowerBar = CreateFrame('StatusBar', nil, self)
	self.AltPowerBar:SetStatusBarTexture(bartexture)
	
	self.AltPowerBar:SetHeight(self:GetHeight() + 4)
	self.AltPowerBar:SetWidth(self:GetWidth() + 4)
	self.AltPowerBar:SetPoint('TOP', self, 'TOP', 0, 2)

	self.AltPowerBar:SetParent(self)
	self.AltPowerBar:SetFrameLevel(2)
end

local function ApplyFrameVisibility(self, var)
	if oUF_DArc_SavedVars[var] then
		self:Enable()
	else
		self:Disable()
	end
end

local function ApplyVisibility()
	
	ApplyFrameVisibility(oUF_pet, 'ShowPet')
	ApplyFrameVisibility(oUF_focus, 'ShowFocus')
	
	if oUF_DArc_SavedVars.ShowRestingIcon then
		oUF_player.Resting:SetAlpha(1)
	else
		oUF_player.Resting:SetAlpha(0)
	end
	
	if oUF_DArc_SavedVars.ShowCombatIcon then
		oUF_player.Combat:SetAlpha(1)
	else
		oUF_player.Combat:SetAlpha(0)
	end
	
	if class == 'SHAMAN' then
		if oUF_DArc_SavedVars.ShowTotems then
			oUF_player.Totems:Show()
		else
			oUF_player.Totems:Hide()
		end
	end 
	
	if class == 'DEATHKNIGHT' then
		if oUF_DArc_SavedVars.ShowRunes then
			oUF_player.Runes:Show()
		else
			oUF_player.Runes:Hide()
		end
	end 
	
	if class == 'DRUID' then
		if oUF_DArc_SavedVars.ShowEclipse then
			oUF_player.EclipseBar:SetAlpha(1)
		else
			oUF_player.EclipseBar:SetAlpha(0)
		end
	end 
	
	if (class == 'DRUID' or class == 'ROGUE') then
		if oUF_DArc_SavedVars.ShowCombopoints then
			oUF_target.CPoints:Show()
		else
			oUF_target.CPoints:Hide()
		end
	end
	
	if class == 'WARLOCK' then
		if oUF_DArc_SavedVars.ShowSoulShards then
			oUF_player.SoulShards:Show()
		else
			oUF_player.SoulShards:Hide()
		end
	end
	
	if class == 'PALADIN' then
		if oUF_DArc_SavedVars.ShowHolyPower then
			oUF_player.HolyPower:Show()
		else
			oUF_player.HolyPower:Hide()
		end
	end
end

local function ApplyCastbarPositions(self, x, y)
	if oUF_DArc_SavedVars.ShowCastbarIcons then
		self.Castbar:SetPoint('LEFT', self, x+self.Castbar.Icon:GetWidth()-2, y)
		self.Castbar:SetWidth(281)
		self.Castbar.Icon:SetAlpha(1)
		self.Castbar.Icon.bg:SetAlpha(1)
	else
		self.Castbar:SetPoint('LEFT', self, x, y)
		self.Castbar:SetWidth(width)
		self.Castbar.Icon:SetAlpha(0)
		self.Castbar.Icon.bg:SetAlpha(0)
	end
	
	self.Castbar:SetStatusBarColor(unpack(oUF_DArc_SavedVars.CastbarColor))
end

function ApplyCastbarVisibility(self, var)
	if oUF_DArc_SavedVars[var] then
		self.Castbar:SetAlpha(1)
	else
		self.Castbar:SetAlpha(0)
	end
end

function oUF_DArc_ApplyCastbarOptions()
	ApplyCastbarPositions(oUF_player, oUF_DArc_SavedVars.PlayerCastbarPositionHorizontal, oUF_DArc_SavedVars.PlayerCastbarPositionVertical)
	ApplyCastbarPositions(oUF_target, oUF_DArc_SavedVars.TargetCastbarPositionHorizontal, oUF_DArc_SavedVars.TargetCastbarPositionVertical)
	ApplyCastbarPositions(oUF_pet, 0, 40)
	ApplyCastbarPositions(oUF_focus, 0, 40)
	ApplyCastbarVisibility(oUF_player, 'ShowPlayerCastbar')
	ApplyCastbarVisibility(oUF_target, 'ShowTargetCastbar')
	ApplyCastbarVisibility(oUF_pet, 'ShowPetCastbar')
	ApplyCastbarVisibility(oUF_focus, 'ShowFocusCastbar')
end

local function ApplyBuffPositions(self, var_buffside)
	self.Buffs:ClearAllPoints()
	if oUF_DArc_SavedVars[var_buffside] then
		self.Buffs:SetWidth(self.Buffs.size * oUF_DArc_SavedVars.BuffsPerRow)
		self.Buffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', 1, 2)
		self.Buffs.initialAnchor = 'TOPLEFT'
	else
		self.Buffs:SetWidth(304)
		self.Buffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', -2, 1)
		self.Buffs.initialAnchor = 'BOTTOMLEFT'
	end
	self.Buffs['growth-x'] = 'RIGHT'
	self.Buffs['growth-y'] = 'UP'
end

local function ApplyDebuffPositions(self, var_buffside)
	self.Debuffs:ClearAllPoints()
	if oUF_DArc_SavedVars[var_buffside] then
		self.Debuffs:SetWidth(self.Debuffs.size * oUF_DArc_SavedVars.BuffsPerRow)
		self.Debuffs:SetPoint('BOTTOMLEFT', self, 'BOTTOMRIGHT', 1, -2)
		self.Debuffs.initialAnchor = 'BOTTOMLEFT'
	else
		self.Debuffs:SetWidth(304)
		self.Debuffs:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -2, -1)
		self.Debuffs.initialAnchor = 'TOPLEFT'
	end
	self.Debuffs['growth-x'] = 'RIGHT'
	self.Debuffs['growth-y'] = 'DOWN'
end

local function ApplyBuffOptions(self, var_buffs, var_debuffs, var_buffside)
	if oUF_DArc_SavedVars[var_buffs] then
		self.Buffs:Show()
	else
		self.Buffs:Hide()
	end
	if oUF_DArc_SavedVars[var_debuffs] then
		self.Debuffs:Show()
	else
		self.Debuffs:Hide()
	end
	ApplyBuffPositions(self, var_buffside)
	ApplyDebuffPositions(self, var_buffside)
end

function oUF_DArc_FixTotDebuffPosition(self)
	self.Debuffs.size = 22
	self.Debuffs:SetHeight(self.Debuffs.size)
	self.Debuffs:ClearAllPoints()
	if oUF_DArc_SavedVars.BuffsOnRight then
		self.Debuffs:SetWidth(self.Debuffs.size * oUF_DArc_SavedVars.BuffsPerRow)
		self.Debuffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', 1, 2)
		self.Debuffs.initialAnchor = 'TOPLEFT'
	else
		self.Debuffs:SetWidth(204)
		self.Debuffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', -2, 1)
		self.Debuffs.initialAnchor = 'BOTTOMLEFT'
	end
	self.Debuffs['growth-x'] = 'RIGHT'
	self.Debuffs['growth-y'] = 'UP'
	if oUF_DArc_SavedVars.ShowDebuffsOnTot then
		self.Debuffs:Show()
	else
		self.Debuffs:Hide()
	end
end

function oUF_DArc_ApplyOptions()
	ApplyVisibility()
--	oUF_DArc_ApplyCastbarOptions()
	ApplyBuffOptions(oUF_player, 'ShowBuffsOnPlayer', 'ShowDebuffsOnPlayer', 'PlayerBuffsOnRight')
	ApplyBuffOptions(oUF_target, 'ShowBuffsOnTarget', 'ShowDebuffsOnTarget', 'TargetBuffsOnRight')
	ApplyBuffOptions(oUF_pet, 'ShowBuffsOnPet', 'ShowDebuffsOnPet', 'PetBuffsOnRight')
	ApplyBuffOptions(oUF_focus, 'ShowBuffsOnFocus', 'ShowDebuffsOnFocus', 'FocusBuffsOnRight')
	oUF_DArc_FixTotDebuffPosition(oUF_targettarget)
end

