-- Copyright (c) 2025, Relhzi

local AceDB = LibStub("AceDB-3.0")
local AceAddon = LibStub("AceAddon-3.0")

local ExperienceBar = AceAddon:NewAddon("ExperienceBar")
local Bar = ExperienceBar:NewModule("Bar", "AceEvent-3.0", "AceTimer-3.0")
local Options = ExperienceBar:NewModule("Options", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")

Bar:Disable()

function ExperienceBar: OnInitialize ()
    local defaults = {
        profile = {
            width = 400,
            height = 30,
            positionX = 400,
            positionY = 400,
            isHidden = true,
            isLocked = true,
            isExtraEnabled = true,
            bgColor = { r = 1, g = 1, b = 1, a = 0.6 },
            barColor = { r = 0.5, g = 0, b = 0, a = 1 },
            textColor = { r = 1, g = 1, b = 1, a = 1 },
            borderColor = { r = 0, g = 0, b = 0, a = 1 },
            extraBarColor = { r = 0.8, g = 0, b = 0, a = 0.7 },
            extraTextColor = { r = 0.8, g = 0, b = 0, a = 0.7 },
            textSize = 18,
            textDisplayAs = "NUMBER",
            textFont = "Arial Narrow",
            barTexture = "Eb-Ruby",
            borderTexture = "None"
        }
    }
    self.defaults = defaults.profile
    self.db = AceDB:New("ExperienceBarDB", defaults, true)
end