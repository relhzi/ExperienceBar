-- Copyright (c) 2025, Relhzi

local AceAddon = LibStub("AceAddon-3.0")
local AceLocale  = LibStub("AceLocale-3.0")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local L = AceLocale:GetLocale("ExperienceBar")
local Options = AceAddon:GetAddon("ExperienceBar"):GetModule("Options")

Options.OPTION_CHANGED_MESSAGE = "OPTION_CHANGED_MESSAGE"
Options.OPTION_CENTER_HOR_MESSAGE = "OPTION_CENTER_HOR_MESSAGE"
Options.OPTION_CENTER_VER_MESSAGE = "OPTION_CENTER_VER_MESSAGE"
Options.OPTIONS_OPEN_MESSAGE = "OPTIONS_OPEN_MESSAGE"
Options.OPTIONS_HIDE_MESSAGE = "OPTIONS_HIDE_MESSAGE"

Options.TEXT_DISPLAY = {
    ["NUMBER"] = L["OPTION_DISPLAY_NUMBER"],
    ["PERCENT"] = L["OPTION_DISPLAY_PERCENT"],
    ["NONE"] = L["OPTION_DISPLAY_NONE"],
}

Options.FONT = AceGUIWidgetLSMlists["font"]
Options.BORDER =  AceGUIWidgetLSMlists["border"]

--- statusbar texture registration
LibSharedMedia:Register("statusbar", "Eb-Ruby", "Interface\\AddOns\\ExperienceBar\\Textures\\Eb-Ruby")
LibSharedMedia:Register("statusbar", "Eb-Frost", "Interface\\AddOns\\ExperienceBar\\Textures\\Eb-Frost")
LibSharedMedia:Register("statusbar", "Eb-Gold", "Interface\\AddOns\\ExperienceBar\\Textures\\Eb-Gold")
Options.STATUSBAR = AceGUIWidgetLSMlists["statusbar"]