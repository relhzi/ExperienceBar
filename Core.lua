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
            height = 50,
            positionX = 400,
            positionY = 400,
            isHidden = true,
            isLocked = true,
            isExtraEnabled = true,
            bgColor = { r = 1, g = 0.89, b = 0.67, a = 0.75 },
            barColor = { r = 0.98, g = 1, b = 0, a = 1 },
            textColor = { r = 0.89, g = 9.92, b = 0.86, a = 1 },
            borderColor = { r = 1, g = 0.67, b = 0.22, a = 1 },
            extraBarColor = { r = 1, g = 0.92, b = 0.25, a = 0.68 },
            extraTextColor = { r = 0.87, g = 1, b = 0.48, a = 1 },
            textSize = 20,
            textDisplayAs = "NUMBER",
            textFont = "Skurri",
            barTexture = "Blizzard",
            borderTexture = "Blizzard Tooltip"
        }
    }

    self.db = AceDB:New("ExperienceBarDB", defaults, true)
end