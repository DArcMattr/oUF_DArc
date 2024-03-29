local frame_width = 240
local frame_height = 72
local frame_pct_offset = 25
local extra_width = 0
local border_width = 3
local cp_height = 5
local alpha = 0.5

local bartexture = [[Interface\AddOns\SharedMedia\statusbar\minimalist.tga]]
local bufftexture = [[Interface\AddOns\oUF_DArc\texture\buff]]
local backdrop = {bgFile = [[Interface\ChatFrame\ChatFrameBackground]], tile=true, insets = {top = 0, left = 0, bottom = 0, right = 0}}
local back_edge = {
  bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
  insets = {top = -1 * border_width, left = -1 * border_width, bottom = -1 * border_width, right = -1 * border_width},
  tilesize = frame_height,
  edgeFile = [[Interface\AddOns\SharedMedia\border\roth.tga]],
  edgeSize = border_width,
}

local txt_font = 'SystemFont_Med1'
local num_font = 'SystemFont_Outline_Small'

local barheight = floor( frame_height * .3 )

local _, class = UnitClass( 'player' )

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
end

function oUF_DArc_AddPortrait(self)
  self.Portrait = CreateFrame('PlayerModel', nil, self)
  self.Portrait:SetParent(self)
  self.Portrait:SetPoint( 'TOPLEFT', -1 * border_width, -1 * border_width )
  self.Portrait:SetWidth( frame_height - ( 3 / 2 ) *  border_width )
  self.Portrait:SetHeight( frame_height - border_width )
  self.Portrait:SetFrameLevel(3)

  self.Portrait:SetBackdrop(back_edge)
  self.Portrait:SetBackdropColor( 0, 0, 0, alpha )
end

function oUF_DArc_AddNameBar(self, unit)
  self.Namebar = CreateFrame('StatusBar', nil, self)
  self.Namebar:SetParent(self)
  self.Namebar:SetPoint( 'TOPRIGHT', 0, -1 * border_width )
  self.Namebar:SetHeight( barheight - ( 2 * border_width ) )
  self.Namebar:SetWidth( ( frame_width + extra_width ) - frame_height )
  self.Namebar:SetFrameLevel(5)

  self.Namebar:SetStatusBarTexture( bartexture )
  self.Namebar:SetBackdrop( back_edge )
  self.Namebar:SetBackdropColor( 0, 0, 0, alpha )

  if ( unit == "target" or unit == "targettarget" and oUF_DArc_SavedVars.ShowReaction ) then
    self.Namebar.colorReaction = true
--    self.Namebar.bg:SetAlpha( alpha )
  else
    self.Namebar:SetStatusBarColor( 0, 0, 0, alpha )
  end

  local unitname = self.Namebar:CreateFontString(nil, 'OVERLAY', txt_font)
  self:Tag( unitname, '[DArc:name]' )
  unitname:SetPoint( 'CENTER', self.Namebar )
end

function oUF_DArc_AddHealthPowerBar(self, unit)
  self.HealthPower = CreateFrame('Frame', nil, self)
  self.HealthPower:SetParent(self)
  self.HealthPower:SetHeight( frame_height - barheight - ( 5 / 3 * border_width ) )
  self.HealthPower:SetWidth( ( frame_width + extra_width ) - frame_height )
  self.HealthPower:SetBackdrop(back_edge)
  self.HealthPower:SetBackdropColor( 0, 0, 0, alpha )
  self.HealthPower:SetPoint( 'BOTTOMRIGHT' )

  self.Health = CreateFrame('StatusBar', nil, self)
  self.Health:SetParent(self)
  self.Health:SetStatusBarTexture( bartexture )
  self.Health:SetPoint( 'TOPLEFT', self.HealthPower )
  self.Health:SetHeight( floor( frame_height * .5 ) - ( 2 * border_width ) )
  self.Health:SetWidth( ( frame_width + extra_width ) - frame_height - frame_pct_offset - ( 2 * border_width ) )

  self.Health.colorTapping = true
  self.Health.colorDisconnected = true
  self.Health.colorSmooth = true
  self.Health:SetFrameLevel(5)

  local HealthBG = self.Health:CreateTexture( nil, 'BACKGROUND' )
  HealthBG:SetAllPoints(self.Health)
  HealthBG:SetTexture( 0, 0, 0, .25 )

  self.Health.bg = HealthBG

  local health = self.Health:CreateFontString(nil, 'OVERLAY', num_font)
  health:SetPoint('CENTER', self.Health)
  self:Tag(health,'[curhp]/[maxhp]' )

  local healthpercent = self.Health:CreateFontString(nil, 'OVERLAY', num_font)
  healthpercent:SetPoint('RIGHT', self.Health,  5 / 4 * frame_pct_offset + 1, 0)
  self:Tag(healthpercent,'[perhp]%')

  self.Health.PostUpdate = function( self, unit )
    if ( unit ~= nil ) then
      if ( UnitPowerMax( unit ) == 0 ) then
        self:SetHeight( frame_height - barheight - ( 2 * border_width ) )
      else
        self:SetHeight( floor( frame_height * .5 ) - ( 2 * border_width ) )
      end
    end
  end

  self.Power = CreateFrame( 'StatusBar', nil, self )
  self.Power:SetStatusBarTexture( bartexture )
  self.Power:SetParent( self )
  self.Power:SetPoint( 'TOPLEFT', self.Health, 'BOTTOMLEFT' )
  self.Power:SetHeight( frame_height * .2 + 2 )
  self.Power:SetWidth( ( frame_width + extra_width ) - frame_height - frame_pct_offset - ( 2 * border_width ) )

  self.Power.colorPower = true
  self.Power.Smooth = true
  self.Power:SetFrameLevel(5)
  self.Power.frequentUpdates = true

  local power_txt = self.Power:CreateFontString( nil, 'OVERLAY', num_font )
  power_txt:SetPoint( 'CENTER', self.Power )
  self:Tag( power_txt, '[curpp]/[maxpp]' )

  local PowerBG  = self.Power:CreateTexture( nil, 'BACKGROUND' )
  PowerBG:SetAllPoints(self.Power)
  PowerBG:SetTexture( 0, 0, 0, .25 )
  
  self.Power.bg = PowerBG

  local powerpercent = self.Power:CreateFontString( nil, 'OVERLAY', num_font )
  powerpercent:SetPoint( 'RIGHT', self.Power,  5 / 4 * frame_pct_offset + 1, 0)
  self:Tag( powerpercent, '[perpp]%' )

  self.Power.PostUpdate = function( self, unit )
    if ( unit ~= nil ) then
      if ( UnitPowerMax( unit ) == 0 ) then
        self:Hide()
      else
        self:Show()
      end
    end
  end
end

function oUF_DArc_AddLevelBlock(self, unit)
--  if( oUF_DArc_SavedVars.ShowLevel[unit] ) then
    self.Level = CreateFrame('Frame', nil, self)
    self.Level:SetHeight( barheight - ( 2 * border_width ) )
    self.Level:SetWidth( frame_pct_offset * 3 / 5 )
    self.Level:SetBackdrop( back_edge )
    self.Level:SetBackdropColor( 0, 0, 0, alpha )
    if ( unit == "target" or unit == "targettarget" ) then
      self.Level:SetPoint( 'TOPLEFT', self, 'TOPRIGHT', 2.5 * border_width, -border_width )
    else
      self.Level:SetPoint( 'TOPRIGHT', self, 'TOPLEFT', -3.5 * border_width, -border_width )
    end

    local unitlevel = self.Level:CreateFontString(nil, 'OVERLAY', num_font)
    self:Tag( unitlevel, '[DArc:level]' )
    unitlevel:SetPoint( 'CENTER', self.Level, 'CENTER' )
--  else
    -- do nothing
--  end
end

function oUF_DArc_AddSecondaryPowerBar(self, unit)
  self.Power = CreateFrame('StatusBar', nil, self)
  self.Power:SetStatusBarTexture(bartexture)
  self.Power:SetHeight( barheight - ( 2 * border_width ) )
  self.Power:SetBackdrop( back_edge )
  self.Power:SetBackdropColor( 0, 0, 0, alpha )
  self.Power:SetWidth( ( frame_width + extra_width ) - frame_height )

  self.Power:SetParent(self)
  self.Power:SetAllPoints()

  self.Power.colorPower = true
  self.Power.Smooth = true
  self.Power:SetFrameLevel(5)
  self.Power.frequentUpdates = true

  local power = self.Power:CreateFontString( nil, 'OVERLAY', num_font )
  power:SetPoint( 'CENTER', self.Power )
  self:Tag( power, '[curpp]/[maxpp]' )
end

function oUF_DArc_AddRaidIcons(self)
  self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
  self.RaidIcon:SetHeight(barheight)
  self.RaidIcon:SetWidth(barheight)
  self.RaidIcon:SetPoint('TOP', self, 0, 9)
  self.RaidIcon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
end

function oUF_DArc_AddBuffs(self, unit)
  self.Buffs = CreateFrame('Frame', nil, self)
  self.Buffs.size = oUF_DArc_SavedVars.BuffSize[unit]
  self.Buffs:SetHeight(self.Buffs.size)
  self.Buffs.num = oUF_DArc_SavedVars.BuffsPerRow 
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
  self.CombatIcon:SetPoint('CENTER', self, 'TOPRIGHT', 5, 1)
  self.CombatIcon:SetHeight(18)
  self.CombatIcon:SetWidth(18)
  self.CombatIcon:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
  self.CombatIcon:SetTexCoord(0.58, 0.90, 0.08, 0.41)
  self.Combat = self.CombatIcon
end

function oUF_DArc_AddRestingIcon(self)
  self.RestingIcon = self.Health:CreateTexture(nil, 'OVERLAY')
  self.RestingIcon:SetPoint('TOPRIGHT', self )
  self.RestingIcon:SetHeight(18)
  self.RestingIcon:SetWidth(18)
  self.RestingIcon:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
  self.RestingIcon:SetTexCoord(0.09, 0.43, 0.08, 0.42)
  self.Resting = self.RestingIcon
end

function oUF_DArc_AddCastBar(self, x, y)
  self.Castbar = CreateFrame('StatusBar', nil, self)
  self.Castbar:SetBackdrop( backdrop )
  self.Castbar:SetBackdropColor( 0, 0, 0 )
  self.Castbar:SetHeight( barheight )
  self.Castbar:SetStatusBarTexture( bartexture )
  self.Castbar:SetStatusBarColor( unpack(oUF_DArc_SavedVars.colors.castbar) )

  self.Castbar:SetParent(self.Namebar)
  self.Castbar:SetAllPoints()
  self.Castbar:SetFrameLevel(6)

  self.Castbar.Text = self.Castbar:CreateFontString(nil, 'OVERLAY', txt_font)
  self.Castbar.Text:SetPoint('LEFT', self.Castbar, barheight + 2, 0)
  self.Castbar.Text:SetTextColor(1, 1, 1)

  self.Castbar.Time = self.Castbar:CreateFontString(nil, 'OVERLAY', num_font)
  self.Castbar.Time:SetPoint('RIGHT', self.Castbar, -3, 0)
  self.Castbar.Time:SetTextColor(1, 1, 1)

  self.Castbar.Icon = self.Castbar:CreateTexture(nil, 'OVERLAY')
  self.Castbar.Icon:SetSize( barheight, barheight )
  self.Castbar.Icon:SetTexCoord(0, 1, 0, 1)
  self.Castbar.Icon:SetPoint('LEFT')

  self.Castbar.Icon.bg = self.Castbar:CreateTexture(nil, 'OVERLAY')
  self.Castbar.Icon.bg:SetPoint("TOPLEFT", self.Castbar.Icon, "TOPLEFT")
  self.Castbar.Icon.bg:SetPoint("BOTTOMRIGHT", self.Castbar.Icon, "BOTTOMRIGHT")
  self.Castbar.Icon.bg:SetTexture(bufftexture)
  self.Castbar.Icon.bg:SetVertexColor(0.25, 0.25, 0.25)

  self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, "OVERLAY")
  self.Castbar.SafeZone:SetTexture(1,0,0,.5)
end

function oUF_DArc_AddRunes(self)
  if class == 'DEATHKNIGHT' then
    local cp_width = floor( ( ( frame_width + extra_width ) - frame_height ) / 6 )
    local runes = CreateFrame('Frame', nil, self)
    runes:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
    runes:SetSize( ( frame_width + extra_width ) - frame_height, cp_height )
    runes:SetBackdrop(backdrop)
    runes:SetBackdropColor(0, 0, 0)

    for i = 1, 6 do
      local rune = CreateFrame('StatusBar', nil, runes)
      rune:SetStatusBarTexture(bartexture)

      if i > 1 then
        if i == 6 then
          rune:SetSize( cp_width + 1, cp_height )
        else
          rune:SetSize( cp_width, cp_height )
        end
        rune:SetPoint('LEFT', runes[i - 1], 'RIGHT', 2, 0)
      else
        rune:SetSize( cp_width + 1, cp_height )
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
  if ( class == 'DRUID' and GetPrimaryTalentTree() == 1 ) then
    local eclipseBar = CreateFrame('Frame', nil, self)
    eclipseBar:SetPoint('BOTTOM', self, 'TOP', 1, 1)
    eclipseBar:SetSize(( frame_width + extra_width ) - frame_height, cp_height)
    eclipseBar:SetBackdrop(backdrop)
    eclipseBar:SetBackdropColor(0, 0, 0)

    local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
    lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
    lunarBar:SetSize(( frame_width + extra_width ) - frame_height, cp_height)
    lunarBar:SetStatusBarTexture(bartexture)
    lunarBar:SetStatusBarColor(0, 0, 1)
    eclipseBar.LunarBar = lunarBar

    local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
    solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
    solarBar:SetSize(( frame_width + extra_width ) - frame_height, cp_height)
    solarBar:SetStatusBarTexture(bartexture)
    solarBar:SetStatusBarColor(1, 0.8, 0)
    eclipseBar.SolarBar = solarBar

    self.EclipseBar = eclipseBar
  end
end

function oUF_DArc_AddCombopoints(self, unit)
  if (class == 'DRUID' or class == 'ROGUE') then
    local combopoints = CreateFrame('StatusBar', nil, self)
    local cp_width = floor( (( frame_width + extra_width ) - frame_height ) / 5 )
    combopoints:SetPoint('BOTTOM', self, 'TOP', 1, 1)
    combopoints:SetSize(( frame_width + extra_width ) - frame_height, cp_height)
    combopoints:SetBackdrop(backdrop)
    combopoints:SetBackdropColor(0, 0, 0)

    for id = 1, 5 do
      local point = combopoints:CreateTexture(nil, 'OVERLAY')
      point:SetTexture(1, 0.8, 0)

      if id > 1 then
        point:SetSize( cp_width - 2, 5)
        point:SetPoint('TOPLEFT', combopoints[id-1], 'TOPRIGHT', 2, 0)
      else
        point:SetSize( cp_width - 1, 5)
        point:SetPoint('TOPLEFT', combopoints, 'TOPLEFT', 0, 0)
      end

      combopoints[id] = point
    end

    self.CPoints = combopoints
  end
end

function oUF_DArc_AddSoulShards(self)
  if class == 'WARLOCK' then
    local shards = CreateFrame('StatusBar', nil, self)
    local cp_width = floor( ( ( frame_width + extra_width ) - frame_height ) / 3 )
    shards:SetPoint('BOTTOM', self, 'TOP', 1, 1)
    shards:SetSize(( frame_width + extra_width ) - frame_height, cp_height)
    shards:SetBackdrop(backdrop)
    shards:SetBackdropColor(0, 0, 0)


    for id = 1, 3 do
      local shard = shards:CreateTexture(nil, 'OVERLAY')
      shard:SetTexture(1, 0.8, 0)

      if id > 1 then
        shard:SetSize(cp_width, cp_height)
        shard:SetPoint('TOPLEFT', shards[id-1], 'TOPRIGHT', 2, 0)
      else
        shard:SetSize(cp_width - 1, cp_height)
        shard:SetPoint('TOPLEFT', shards, 'TOPLEFT', 0, 0)
      end

      shards[id] = shard
    end

    self.SoulShards = shards
  end
end

function oUF_DArc_AddHolyPower(self)
  if class =='PALADIN' then
    local holypower = CreateFrame('StatusBar', nil, self)
    local cp_width = floor( ( ( frame_width + extra_width ) - frame_height ) / 3 )
    holypower:SetPoint('BOTTOM', self, 'TOP', 1, 1)
    holypower:SetSize(( frame_width + extra_width ) - frame_height, cp_height)
    holypower:SetBackdrop(backdrop)
    holypower:SetBackdropColor(0, 0, 0)

    for id = 1, 3 do
      local hp = holypower:CreateTexture(nil, 'OVERLAY')
      hp:SetTexture(1, 0.8, 0)

      if id > 1 then
        hp:SetSize(cp_width, cp_height)
        hp:SetPoint('TOPLEFT', holypower[id-1], 'TOPRIGHT', 2, 0)
      else
        hp:SetSize(cp_width - 1, cp_height)
        hp:SetPoint('TOPLEFT', holypower, 'TOPLEFT', 0, 0)
      end

      holypower[id] = hp
    end

    self.HolyPower = holypower
  end
end

function oUF_DArc_AddTotems(self)
  if ( class == 'SHAMAN' or class == 'DRUID' ) then
    local totems = CreateFrame('Frame', nil, self)
    local cp_width = floor( ( ( frame_width + extra_width ) - frame_height ) / 4 )
    totems:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, -1)
    totems:SetSize( ( frame_width + extra_width ) - frame_height, cp_height * 2 )
    totems:SetBackdrop(backdrop)
    totems:SetBackdropColor(0, 0, 0, .5)

    for i = 1, 4 do
      local totem = CreateFrame('StatusBar', nil, totems)
      totem:SetSize( cp_width - 2, cp_height * 2 )
      totem:SetStatusBarTexture(bartexture)
      totem:SetStatusBarColor(unpack(oUF_DArc_SavedVars.colors.totems[i]))

      totem.Cooldown = totem
      totem.Cooldown.SetCooldown = function(totem, start, duration)
        totem.start = start
        totem.duration = duration
        totem:SetMinMaxValues(1, duration)
      end

      totem:SetScript("OnUpdate",
        function()
          totem:SetValue( totem.start + totem.duration - GetTime() )
        end
      );

      if i > 1 then
        totem:SetPoint('LEFT', totems[i - 1], 'RIGHT', 2, 0)
      else
        totem:SetPoint('BOTTOMLEFT', totems, 'BOTTOMLEFT', 0, 0)
      end

      local totemBG = totems:CreateTexture(nil, 'BACKGROUND')
      totemBG:SetAllPoints(totem)
      totemBG:SetTexture(unpack(oUF_DArc_SavedVars.colors.totems[i]))
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
  if oUF_DArc_SavedVars.show[var] then
    if ( self ~= nil ) then
      self:Enable()
    end
  else
    if ( self ~= nil ) then
      self:Disable()
    end
  end
end

local function ApplyVisibility()

  ApplyFrameVisibility(oUF_pet, 'pet')
  ApplyFrameVisibility(oUF_focus, 'focus')

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
      oUF_player2.Totems:Show()
    else
      oUF_player2.Totems:Hide()
    end
  end

  if class == 'DEATHKNIGHT' then
    if oUF_DArc_SavedVars.ShowRunes then
      oUF_player2.Runes:Show()
    else
      oUF_player2.Runes:Hide()
    end
  end

  if class == 'DRUID' then
    if oUF_DArc_SavedVars.ShowEclipse then
      oUF_player2.EclipseBar:SetAlpha(1)
    else
      oUF_player2.EclipseBar:SetAlpha(0)
    end
  end

  if (class == 'DRUID' or class == 'ROGUE') then
    if oUF_DArc_SavedVars.ShowCombopoints then
      oUF_player2.CPoints:Show()
    else
      oUF_player2.CPoints:Hide()
    end
  end

  if class == 'WARLOCK' then
    if oUF_DArc_SavedVars.ShowSoulShards then
      oUF_player2.SoulShards:Show()
    else
      oUF_player2.SoulShards:Hide()
    end
  end

  if class == 'PALADIN' then
    if oUF_DArc_SavedVars.ShowHolyPower then
      oUF_player2.HolyPower:Show()
    else
      oUF_player2.HolyPower:Hide()
    end
  end
end

local function ApplyCastbarPositions(self, x, y)
  self.Castbar:SetAllPoints()
  if oUF_DArc_SavedVars.ShowCastbarIcon[self.unit] then
    self.Castbar:SetPoint('LEFT', self, x+self.Castbar.Icon:GetWidth()-2, y)
    self.Castbar:SetWidth( ( frame_width + extra_width ) )
    self.Castbar.Icon:SetAlpha(1)
    self.Castbar.Icon.bg:SetAlpha(1)
  else
    self.Castbar:SetPoint('LEFT', self, x, y)
    self.Castbar:SetWidth( ( frame_width + extra_width ) )
    self.Castbar.Icon:SetAlpha(0)
    self.Castbar.Icon.bg:SetAlpha(0)
  end

end

function ApplyCastbarVisibility(self, var)
  if oUF_DArc_SavedVars.ShowCastbar[var] then
    self.Castbar:SetAlpha(1)
  else
    self.Castbar:SetAlpha(0)
  end
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

local function ApplyBuffOptions(self, unit )
  if ( self ~= nil ) then
    if oUF_DArc_SavedVars.ShowBuffsOn[unit] then
      self.Buffs:Show()
    else
      self.Buffs:Hide()
    end
    if oUF_DArc_SavedVars.ShowDebuffsOn[unit] then
      self.Debuffs:Show()
    else
      self.Debuffs:Hide()
    end
    ApplyBuffPositions(self, oUF_DArc_SavedVars.BuffsOnRight[unit])
    ApplyDebuffPositions(self, oUF_DArc_SavedVars.BuffsOnRight[unit])
  end
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
  ApplyBuffOptions(oUF_player, 'player' )
  ApplyBuffOptions(oUF_target, 'target' )
  ApplyBuffOptions(oUF_targettarget, 'targettarget' )
  ApplyBuffOptions(oUF_pet, 'pet' )
  ApplyBuffOptions(oUF_focus, 'focus' )

  ApplyCastbarVisibility(oUF_player, 'player')
  ApplyCastbarVisibility(oUF_target, 'target')
  ApplyCastbarVisibility(oUF_targettarget, 'targettarget')
  ApplyCastbarVisibility(oUF_pet,    'pet')
  ApplyCastbarVisibility(oUF_focus,  'focus')

--  oUF_DArc_FixTotDebuffPosition(oUF_targettarget)
end
