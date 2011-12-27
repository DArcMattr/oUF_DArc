oUF.TagEvents["DArc:unittype"] = "UNIT_NAME_UPDATE"
oUF.Tags["DArc:unittype"] = function(unit)
  return UnitReaction(unit, "player")
end

oUF.TagEvents["smartname"] = "UNIT_HEALTH PLAYER_FLAGS_CHANGED"
oUF.Tags['smartname'] = function(u) 
	return not UnitIsConnected(u) and 'Offline' or UnitIsAFK(u) and '<AFK>' or UnitIsGhost(u) and 'Ghost' or UnitIsDead(u) and 'Dead' or UnitName(u):sub(1, oUF_DArc_SavedVars.RaidNameLength)
end

-- from oUF_Neav
oUF.TagEvents['DArc:name'] = 'UNIT_NAME_UPDATE'
oUF.Tags['DArc:name'] = function(unit)
  local _, class = UnitClass(unit)
  local color = oUF.colors.class[class]
  local r, g, b = color[1], color[2], color[3]
  local unitName, unitRealm = UnitName(unit)

  if (unitRealm) and (unitRealm ~= '') then
    unitName = unitName..' (*)'
  end

  return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, unitName)     -- no abbrev
end

oUF.TagEvents["DArc:level"] = "UNIT_LEVEL PLAYER_TARGET_CHANGED PLAYER_LEVEL_UP"
oUF.Tags['DArc:level'] = function(unit)
  local level = UnitLevel(unit)
  local color = GetQuestDifficultyColor(level)
  local r, g, b = color.r, color.g, color.b

  if (level < 0) then
    level = [[|TInterface\TargetingFrame\UI-TargetingFrame-Skull:16:16:0:0|t]]
  elseif (level == 0) then
    level = '?'
  else
    level = level
  end

  return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, level)
end
