local bartexture = 'Interface\\AddOns\\oUF_Lure\\texture\\plain'
local backdrop = {bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = -2, left = -2, bottom = -2, right = -2}}
local font = 'GameFontHighlightSmallLeft'
local raid

local function menu(self)
	if(self.unit:match('party')) then
		ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor')
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, 'cursor')
	end
end

local TargetChange = function(self)
	if UnitIsUnit('target', self.unit) then
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end

oUF.TagEvents["smartname"] = "UNIT_HEALTH PLAYER_FLAGS_CHANGED"
oUF.Tags['smartname'] = function(u) 
	return not UnitIsConnected(u) and 'Offline' or UnitIsAFK(u) and '<AFK>' or UnitIsGhost(u) and 'Ghost' or UnitIsDead(u) and 'Dead' or UnitName(u):sub(1, oUF_Lure_SavedVars.RaidNameLength) 
end

local function LayoutRaid(self, unit)
	self.menu = menu
	self.colors = colors
	self:RegisterForClicks('AnyDown')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetAttribute('*type2', 'menu')
	
	self:SetWidth(oUF_Lure_SavedVars.RaidFrameWidth)
	self:SetHeight(oUF_Lure_SavedVars.RaidFrameHeight)

	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0)
	
	self.backdrop2 = CreateFrame('StatusBar', nil, self)
	self.backdrop2:SetStatusBarTexture(bartexture)
	self.backdrop2:SetStatusBarColor(0, 0, 0)
	self.backdrop2:SetAllPoints(self)
	self.backdrop2:SetFrameLevel(3)

	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetAllPoints(self)
	self.Health:SetStatusBarTexture(bartexture)
	self.Health.colorDisconnected = true
	self.Health.colorClass = true
	self.Health.Smooth = true
	self.Health:SetFrameLevel(5)

	local name = self.Health:CreateFontString(nil, 'OVERLAY', font)
	name:SetPoint('CENTER', self, 'CENTER', 0, 0)
	self:Tag(name, '[smartname] [leader]')
	
	self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	self.RaidIcon:SetPoint('RIGHT', self, -2, 0)
	self.RaidIcon:SetHeight(15)
	self.RaidIcon:SetWidth(15)
	
	self.TargetBorder = CreateFrame("Frame", nil, self)
	self.TargetBorder:SetPoint("TOPLEFT", self, "TOPLEFT")
	self.TargetBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	self.TargetBorder:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = -3, left = -3, bottom = -3, right = -3}})
	self.TargetBorder:SetBackdropColor(1, 1, 1)
	self.TargetBorder:SetFrameLevel(0)
	self.TargetBorder:Hide()
	
	local mhpb = CreateFrame('StatusBar', nil, self.Health)
	mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
	mhpb:SetWidth(oUF_Lure_SavedVars.RaidFrameWidth-1)
	mhpb:SetStatusBarTexture(bartexture)
	mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)
	mhpb:SetFrameLevel(4)

	local ohpb = CreateFrame('StatusBar', nil, self.Health)
	ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
	ohpb:SetWidth(oUF_Lure_SavedVars.RaidFrameWidth-2)
	ohpb:SetStatusBarTexture(bartexture)
	ohpb:SetStatusBarColor(0, 1, 0, 0.25)
	ohpb:SetFrameLevel(4)

	self.HealPrediction = {
		myBar = mhpb,
		otherBar = ohpb,
		maxOverflow = 1,
	}
	
	self.AltPowerBar = CreateFrame('StatusBar', nil, self)
	self.AltPowerBar:SetStatusBarTexture(bartexture)
	self.AltPowerBar:SetHeight(self:GetHeight() + 4)
	self.AltPowerBar:SetWidth(self:GetWidth() + 4)
	self.AltPowerBar:SetPoint('TOP', self, 'TOP', 0, 2)
	self.AltPowerBar:SetParent(self)
	self.AltPowerBar:SetFrameLevel(2)
	
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true

	self.Range = {
			insideAlpha = 1.0,
			outsideAlpha = 0.4,
		}
	
	self:RegisterEvent('PLAYER_TARGET_CHANGED', TargetChange)
end

local function ApplyPositionsAndSizes()
	for i = 1, NUM_RAID_GROUPS do
		local raidgroup = _G['oUF_Raid'..i]
		
		if (raidgroup ~= nil) then
			raidgroup:SetAttribute("yOffSet", -oUF_Lure_SavedVars.RaidSpacingVertical)
			raidgroup:SetAttribute("showParty", oUF_Lure_SavedVars.ShowParty)
			raidgroup:SetAttribute("showRaid", oUF_Lure_SavedVars.ShowRaid)
			
			if i > oUF_Lure_SavedVars.NumRaidGroups then
				raidgroup:SetAttribute("showRaid", false)
			end
			
			for j = 1, 5 do
				local raidmember = _G['oUF_Raid'..i..'UnitButton'..j]
				if (raidmember) then
					raidmember:SetWidth(oUF_Lure_SavedVars.RaidFrameWidth)
					raidmember:SetHeight(oUF_Lure_SavedVars.RaidFrameHeight)
					raidmember.AltPowerBar:SetHeight(raidmember:GetHeight() + 4)
					raidmember.AltPowerBar:SetWidth(raidmember:GetWidth() + 4)
				end
			end
		end
	end
end

function oUF_Lure_ApplyPartyRaidOptions()
	ApplyPositionsAndSizes()
end

function oUF_Lure_SpawnPartyRaid(self)
	
	if oUF_Lure_SavedVars.HideBlizzardParty then
		for i = 1, 4 do
			local party = "PartyMemberFrame" .. i
			local frame = _G[party]

			frame:UnregisterAllEvents()
			frame.Show = frame.Hide
			frame:Hide()

			_G[party .. "HealthBar"]:UnregisterAllEvents()
			_G[party .. "ManaBar"]:UnregisterAllEvents()
		end
	end
	
	if oUF_Lure_SavedVars.HideBlizzardRaid then
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager.Show = CompactRaidFrameManager.Hide
		CompactRaidFrameManager:Hide()
		CompactRaidFrameContainer:UnregisterAllEvents()
		CompactRaidFrameContainer.Show = CompactRaidFrameContainer.Hide
		CompactRaidFrameContainer:Hide()
	end

	oUF:RegisterStyle('LureRaid', LayoutRaid)
	oUF:SetActiveStyle('LureRaid')
	
	raid = {}
	
	for i = 1, NUM_RAID_GROUPS do
		local raidgroup = oUF:SpawnHeader("oUF_Raid"..i, nil, "solo,party,raid",
			"groupFilter", tostring(i),  
			"showPlayer", true,
			"showSolo", false,
			"oUF-initialConfigFunction", ([[self:SetWidth(80) self:SetHeight(18)]])
		)
		raidgroup:SetPoint("TOP", UIParent, "TOPLEFT", ((i-1)*88)+60, -20)
		
		table.insert(raid, raidgroup)
	end

	
	oUF_Lure_ApplyPartyRaidOptions()
end
