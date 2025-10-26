-- Copyright (c) 2025, Relhzi
-- 
-- This file includes code from Ace-3.0 framework.
-- Copyright (c) 2007, Ace3 Development Team

local Type, Version = "Eb-NumberEditBox", 1
local AceGUI = LibStub ("AceGUI-3.0")

local function Control_OnEnter(editbox)
	editbox.obj:Fire("OnEnter")
end

local function Control_OnLeave(editbox)
	editbox.obj:Fire("OnLeave")
end

local function EditBox_OnEscapePressed(editbox)
	AceGUI:ClearFocus()
	editbox:ClearFocus()
end

local function EditBox_OnEnterPressed(editbox)
	local this = editbox.obj
	local value = tonumber(editbox:GetText()) or 0
	local cancel = this:Fire("OnEnterPressed", tostring(value))
	if not cancel then
		this:HideButton()
		PlaySound("igMainMenuOptionCheckBoxOn")
	end
end

local function EditBox_OnTextChanged(editbox)
	local this = editbox.obj
	local value = tonumber(editbox:GetText()) or 0
	
	if tostring(value) ~= tostring(this.lasttext) then
		this.lasttext = value
		this:ShowButton()
		this:Fire("OnTextChanged", value)
	end
end

local function ButtonOffset_OnClick(button)
	local editbox = button.obj.editbox
	
	local value = tonumber(editbox:GetText()) or 0
	value = value + button.offset
	
	editbox:SetText(value)
	editbox:ClearFocus()

	EditBox_OnEnterPressed(editbox)
end

local function ButtonSave_OnClick(button)
	button.obj.editbox:ClearFocus()
	EditBox_OnEnterPressed(button.obj.editbox)
end

local methods = {

	["ShowButton"] = function (self)
		self.buttonSave:Show()
		self.editbox:SetTextInsets(4, 24, 3, 3)
	end,

	["HideButton"] = function (self)
		self.buttonSave:Hide()
		self.editbox:SetTextInsets(4, 0, 3, 3)
	end,

	["OnAcquire"] = function(self)
		self:SetWidth(300)
		self:HideButton(self)
	end,

	["OnRelease"] = function(self)
		self:HideButton(self)
	end,

	["SetText"] = function(self, text)
		self.lasttext = tonumber(text) or 0
		self.editbox:SetText(self.lasttext)
		self.editbox:SetCursorPosition(0)
		self:HideButton(self)
	end,

	["GetText"] = function(self)
		return self.editbox:GetText()
	end,

	["SetLabel"] = function(self, text)
		if text and text ~= "" then
			self.label:SetText(text)
			self.label:Show()
			self.frame:SetHeight(40)
		else
			self.label:SetText("")
			self.label:Hide()
			self.frame:SetHeight(22)
		end
	end,
}

local function Constructor()
	local num  = AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local editbox = CreateFrame("EditBox", "AceGUI-3.0Eb-NumberEditBox"..num, frame, "InputBoxTemplate")
	editbox:SetAutoFocus(false)
	editbox:SetPoint("BOTTOMLEFT", 32, 0)
	editbox:SetPoint("BOTTOMRIGHT", -26, 0)
	editbox:SetScript("OnEnter", Control_OnEnter)
	editbox:SetScript("OnLeave", Control_OnLeave)
	editbox:SetScript("OnEscapePressed", EditBox_OnEscapePressed)
	editbox:SetScript("OnEnterPressed", EditBox_OnEnterPressed)
	editbox:SetScript("OnTextChanged",EditBox_OnTextChanged)
	editbox:SetTextInsets(4, 0, 3, 3)
	editbox:SetMaxLetters(256)
	editbox:SetHeight(22)

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	label:SetPoint("BOTTOMLEFT", editbox, "TOPLEFT", 0, 0)
	label:SetHeight(18)

	local buttonSave = CreateFrame("Button", nil, editbox, "UIPanelButtonTemplate")
	buttonSave:SetWidth(24)
	buttonSave:SetHeight(19)
	buttonSave:SetPoint("RIGHT", -4, 1)
	buttonSave:SetText(OKAY)
	buttonSave:SetScript("OnClick", ButtonSave_OnClick)
	buttonSave:Hide()

	local buttonNegative = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	buttonNegative:SetText("-")
	buttonNegative:SetWidth(24)
	buttonNegative:SetHeight(22)
	buttonNegative:SetPoint("BOTTOMLEFT", 0, 0)
	buttonNegative:SetScript("OnClick", ButtonOffset_OnClick)

	local buttonPositive = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	buttonPositive:SetText("+")
	buttonPositive:SetWidth(24)
	buttonPositive:SetPoint("BOTTOMRIGHT", 0, 0)
	buttonPositive:SetHeight(22)
	buttonPositive:SetScript("OnClick", ButtonOffset_OnClick)
	
	buttonPositive.offset = 1
	buttonNegative.offset = -1

	local widget = {
		alignoffset = 22,
		type        = Type,
		label       = label,
		frame       = frame,
		editbox     = editbox,
		buttonSave 	= buttonSave,
		buttonPositive 	= buttonPositive,
		buttonNegative 	= buttonNegative,
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	
	editbox.obj = widget
	buttonSave.obj = widget
	buttonPositive.obj = widget
	buttonNegative.obj = widget

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
