oUF.TagEvents["DArc:unittype"] = "UNIT_NAME_UPDATE"
oUF.Tags["DArc:unittype"] = function(unit)
  return UnitReaction(unit, "player")
end

-- from oUF_Neav
oUF.TagEvents['DArc:name'] = 'UNIT_NAME_UPDATE'
oUF.Tags['DArc:name'] = function(unit)
  local r, g, b
  local color
  local unitName, unitRealm = UnitName(unit)
  local _, class = UnitClass(unit)

  if (unitRealm) and (unitRealm ~= '') then
    unitName = unitName..' (*)'
  end

  color = oUF.colors.class[class]

  r, g, b = color[1], color[2], color[3]

  return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, unitName)     -- no abbrev
end

oUF.TagEvents["DArc:level"] = "UNIT_LEVEL PLAYER_TARGET_CHANGED PLAYER_LEVEL_UP"
oUF.Tags['DArc:level'] = function(unit)
  local r, g, b
  local level = UnitLevel(unit)
  local colorL = GetQuestDifficultyColor(level)

  if (level < 0) then
    r, g, b = 1, 0, 0
    level = '|TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:15:15:0:0|t'
  elseif (level == 0) then
    r, g, b = colorL.r, colorL.g, colorL.b
    level = '?'
  else
    r, g, b = colorL.r, colorL.g, colorL.b
    level = level
  end

  return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, level)
end
