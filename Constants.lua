-- Copyright (c) 2025, Relhzi

local AceAddon = LibStub("AceAddon-3.0")
local AceLocale  = LibStub("AceLocale-3.0")

local L = AceLocale:GetLocale("ExperienceBar")
local Options = AceAddon:GetAddon("ExperienceBar"):GetModule("Options")

Options.TEXT_DISPLAY = {
    ["NUMBER"] = L["OPTION_DISPLAY_NUMBER"],
    ["PERCENT"] = L["OPTION_DISPLAY_PERCENT"],
    ["NONE"] = L["OPTION_DISPLAY_NONE"],
}

Options.FONT = AceGUIWidgetLSMlists['font']
Options.STATUSBAR = AceGUIWidgetLSMlists['statusbar']
Options.BORDER =  AceGUIWidgetLSMlists['border']

Options.OPTION_CHANGED_MESSAGE = "OPTION_CHANGED_MESSAGE"
Options.OPTION_CENTER_HOR_MESSAGE = "OPTION_CENTER_HOR_MESSAGE"
Options.OPTION_CENTER_VER_MESSAGE = "OPTION_CENTER_VER_MESSAGE"
Options.OPTIONS_OPEN_MESSAGE = "OPTIONS_OPEN_MESSAGE"
Options.OPTIONS_HIDE_MESSAGE = "OPTIONS_HIDE_MESSAGE"