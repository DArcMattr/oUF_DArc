function oUF_DArc_GeneratePanel(parent, name, titletext)

  local panel = CreateFrame("Frame", nil, parent)
  panel.name = name

  if (parent ~= UIParent) then
    panel.parent = parent.name
  end

  local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 16, -16)
  title:SetText(titletext)

  return panel
end

function oUF_DArc_GenerateCheckbutton(parent, var, text, x, y)
  local checkbutton = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsBaseCheckButtonTemplate")
  checkbutton:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
  checkbutton:SetWidth("25")
  checkbutton:SetHeight("25")

  local fontstring = checkbutton:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  fontstring:SetHeight(25)
  fontstring:SetPoint("BOTTOMLEFT", checkbutton, "BOTTOMRIGHT", 3, 0)
  fontstring:SetText(text)

  checkbutton:SetScript("OnClick",
    function()
      oUF_DArc_SavedVars[var] = checkbutton:GetChecked() and true or false
      oUF_DArc_ApplyOptions()
      oUF_DArc_ApplyPartyRaidOptions()
    end
  );

  checkbutton.var = var

  return checkbutton
end

function oUF_DArc_GenerateEditBox(parent, var, text, x, y)
  local editbox = CreateFrame("EditBox", var, parent, "InputBoxTemplate")
  editbox:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
  editbox:SetWidth("50")
  editbox:SetHeight("25")
  editbox:SetAutoFocus(nil)
  editbox:SetMaxLetters(6)
  editbox.label = editbox:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  editbox.label:SetPoint("LEFT", editbox, "RIGHT", 6, 0)
  editbox.label:SetHeight(25)
  editbox.label:SetText(text)

  editbox:SetScript("OnEnterPressed",
    function()
      oUF_DArc_SavedVars[var] = editbox:GetText() + 0
      oUF_DArc_ApplyOptions()
      oUF_DArc_ApplyPartyRaidOptions()
    end
  );

  editbox.var = var

  return editbox
end

function oUF_DArc_GenerateSlider(parent, var, text, low, high, step, x, y)
  local slider = CreateFrame("Slider", var, parent, "OptionsSliderTemplate")
  slider:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
  slider:SetWidth("160")
  slider:SetHeight("20")
  slider:SetOrientation('HORIZONTAL')
  slider:SetMinMaxValues(low, high)
  slider:SetValueStep(step)
  slider:EnableMouseWheel(true)

  getglobal(slider:GetName() .. 'Low'):SetText(low)
  getglobal(slider:GetName() .. 'High'):SetText(high)
  getglobal(slider:GetName() .. 'Text'):SetText(text)

  slider:SetScript("OnValueChanged",
  function()
    getglobal(slider:GetName() .. 'Text'):SetText(text .. ": " .. floor(slider:GetValue()*100 + 0.5)/100)
  end)

  slider:SetScript("OnMouseWheel",
  function(self, delta)
    local step = self:GetValueStep() * delta
    local value = self:GetValue()
    local minVal, maxVal = self:GetMinMaxValues()

    if step > 0 then
      self:SetValue(min(value+step, maxVal))
    else
      self:SetValue(max(value+step, minVal))
    end
  end)

  slider:SetScript("OnMouseUp",
  function()
    oUF_DArc_SavedVars[var] = floor(slider:GetValue()*100 + 0.5)/100
    oUF_DArc_ApplyOptions()
    oUF_DArc_ApplyPartyRaidOptions()
  end)

  slider.var = var

  return slider
end

function oUF_DArc_GenerateColorPicker(parent, var, func, text, x, y)

  local button = CreateFrame("Button", nil, parent)
  button:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
  button:SetWidth("25")
  button:SetHeight("25")
  button:SetText(text)

  button.color_sample = button:CreateTexture(nil, "ARTWORK")
  button.color_sample:SetAllPoints(button)

  local fontstring = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  fontstring:SetHeight(25)
  fontstring:SetPoint("LEFT", button, "RIGHT", 10, 0)
  fontstring:SetText(text)

  button:SetScript("OnClick",
    function()
      if( var ~= nil ) then
        ColorPickerFrame:SetColorRGB(unpack(var))
        ColorPickerFrame.hasOpacity = false
        ColorPickerFrame.previousValues = var
        ColorPickerFrame.func = func
        ColorPickerFrame.cancelFunc = func
        ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG")
        ColorPickerFrame:Hide()
        ColorPickerFrame:Show()
      end
    end
  );

  button:SetScript("OnUpdate",
    function()
      if( var ~= nil ) then
--        button.color_sample:SetTexture(unpack(var))
      end
    end
  );

  return button
end
