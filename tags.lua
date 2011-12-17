oUF.TagEvents["DArc:unittype"] = "UNIT_NAME_UPDATE"
oUF.Tags["DArc:unittype"] = function(unit)
  return UnitReaction(unit, "player")
end

-- from oUF_Neav
oUF.TagEvents['DArc:name'] = 'UNIT_NAME_UPDATE'
oUF.Tags['DArc:name'] = function(unit)
  local r, g, b
  local colorA, colorB
  local unitName, unitRealm = UnitName(unit)
  local _, class = UnitClass(unit)

  if (unitRealm) and (unitRealm ~= '') then
    unitName = unitName..' (*)'
  end

  for i = 1, 4 do
    if (unit == 'party'..i) then
      colorA = oUF.colors.class[class]
    end
  end

  --if (unit == 'player' or not UnitIsFriend('player', unit) and UnitIsPlayer(unit) and UnitClass(unit)) then
    colorA = oUF.colors.class[class]
  --elseif (unit == 'targettarget' and UnitIsPlayer(unit) and UnitClass(unit)) then
  --  colorA = oUF.colors.class[class]
  --else
  --  colorB = {1, 1, 1}
  --end

  if (colorA) then
    r, g, b = colorA[1], colorA[2], colorA[3]
  elseif (colorB) then
    r, g, b = colorB[1], colorB[2], colorB[3]
  end

  --if (unitRealm) and (unitRealm ~= '') then
    return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, unitName)     -- no abbrev
  --else
  --  return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, string.gsub(unitName, '%s(.[\128-\191]*)%S+%S', ' %1.'))     -- abbrev all words except the first
  --end
  --return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, string.gsub(unitName, '%s?(.[\128-\191]*)%S+%s', '%1. '))   -- abbrev all words except the last
end

oUF.TagEvents["DArc:level"] = "UNIT_LEVEL PLAYER_TARGET_CHANGED PLAYER_LEVEL_UP"
oUF.Tags['DArc:level'] = function(unit)
    local r, g, b
    local level = UnitLevel(unit)
    local colorL = GetQuestDifficultyColor(level)

    if (level < 0) then
        r, g, b = 1, 0, 0
        level = '??'
    elseif (level == 0) then
        r, g, b = colorL.r, colorL.g, colorL.b
        level = '?'
    else
        r, g, b = colorL.r, colorL.g, colorL.b
        level = level
    end

    return format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, level)
end
