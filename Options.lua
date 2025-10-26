-- Copyright (c) 2025, Relhzi

local AceHook = LibStub("AceHook-3.0")
local AceAddon = LibStub("AceAddon-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceLocale  = LibStub("AceLocale-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfigDialog  = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local L = AceLocale:GetLocale("ExperienceBar")
local ExperienceBar = AceAddon:GetAddon("ExperienceBar")
local Options = ExperienceBar:GetModule("Options")

function Options: GetGeneralOptions ()
    local order = 10
    local options = {
        type = "group",
        name = L["OPTION_GENERAL"],
        args = {
            isLocked = {
                order = order + 1,
                type = "toggle",
                name = L["OPTION_LOCK"],
                get = Options.GetterOption,
                set = Options.SetterOption
            },
            isHidden = {
                order = order + 2,
                type = "toggle",
                name = L["OPTION_HIDE"],
                get = Options.GetterOption,
                set = Options.SetterOption
            },
            delim_1 = {
                order = order + 3,
                type = "header",
                name = ""
            },
            desc_extra = {
                order = order + 4,
                width = "full",
                type = "description",
                fontSize = "medium",
                name = L["DESC_EXTRA"]
            },
            isExtraEnabled = {
                order = order + 5,
                width = "full",
                type = "toggle",
                name = L["OPTION_EXTRA"],
                get = Options.GetterOption,
                set = Options.SetterOption
            },
            delim_2 = {
                order = order + 6,
                type = "header",
                name = ""
            },
            desc_commands = {
                order = order + 7,
                type = "description",
                fontSize = "medium",
                name = L["DESC_COMMANDS"]
            },
            desc_source = {
                order = order + 8,
                type = "description",
                fontSize = "medium",
                name = L["DESC_SOURCE"]
            }
        }
    }
    return options
end

function Options: GetDesignOptions ()
    local db = ExperienceBar.db.profile
    local order = 20
    
    local function isDisabled ()
        return not db.isExtraEnabled
    end
    
    local options = {
        type = "group",
        name = L["OPTION_DESIGN"],
        args = {
            colors = {
                order = order,
                type = "group",
                name = L["OPTION_COLORS"],
                inline = true,
                args = {
                    textColor = {
                        order = order + 1,
                        type = "color",
                        name = L["OPTION_TEXT_COLOR"],
                        hasAlpha = true,
                        get = Options.GetterOption,
                        set = Options.SetterOption
                    },
                    barColor = {
                        order = order + 2,
                        type = "color",
                        name = L["OPTION_BAR_COLOR"],
                        hasAlpha = true,
                        get = Options.GetterOption,
                        set = Options.SetterOption
                    },
                    borderColor = {
                        order = order + 3,
                        type = "color",
                        name = L["OPTION_BORDER_COLOR"],
                        hasAlpha = true,
                        get = Options.GetterOption,
                        set = Options.SetterOption
                    },
                    bgColor = {
                        order = order + 4,
                        type = "color",
                        name = L["OPTION_BG_COLOR"],
                        hasAlpha = true,
                        get = Options.GetterOption,
                        set = Options.SetterOption
                    },
                    extraTextColor = {
                        order = order + 5,
                        type = "color",
                        name = L["OPTION_EXTRA_TEXT_COLOR"],
                        hasAlpha = true,
                        disabled = isDisabled,
                        get = Options.GetterOption,
                        set = Options.SetterOption
                    },
                    extraBarColor = {
                        order = order + 6,
                        type = "color",
                        name = L["OPTION_EXTRA_BAR_COLOR"],
                        hasAlpha = true,
                        disabled = isDisabled,
                        get = Options.GetterOption,
                        set = Options.SetterOption
                    },
                }
            },
            textSize = {
                order = order + 8,
                type = "range",
                width = "full",
                name = L["OPTION_TEXT_SIZE"],
                min = 2, max = 28, step = 1,
                get = Options.GetterOption,
                set = Options.SetterOption
            },
            textFont = {
                order = order + 9,
                type = "select",
                width = "full",
                name = L["OPTION_TEXT_FONT"],
                values = Options.FONT,
                dialogControl = "LSM30_Font",
                get = Options.GetterOption,
                set = Options.SetterOption
            },
            textDisplayAs = {
                order = order + 10,
                type = "select",
                width = "full",
                name = L["OPTION_DISPLAY_AS"],
                values = Options.TEXT_DISPLAY,
                get = Options.GetterOption,
                set = Options.SetterOption
            },
            barTexture = {
                order = order + 11,
                type = "select",
                width = "full",
                name = L["OPTION_BAR_TEXTURE"],
                values = Options.STATUSBAR,
                dialogControl = "LSM30_Statusbar",
                get = Options.GetterOption,
                set = Options.SetterOption
            },
            borderTexture = {
                order = order + 12,
                width = "full",
                type = "select",
                name = L["OPTION_BORDER_TEXTURE"],
                values = Options.BORDER,
                dialogControl = "LSM30_Border",
                get = Options.GetterOption,
                set = Options.SetterOption
            },
        }
    }
    return options
end

function Options: GetPositionOptions ()
    local order = 30
    
    local function OptionValidate(info, value)
        return not (0 > tonumber(value))
    end
    
    local options = {
        type = "group",
        name = L["OPTION_POSITION"],
        args = {
            width = {
                order = order + 1,
                type = "input",
                width = "full",
                name = L["OPTION_WIDTH"],
                dialogControl = "Eb-NumberEditBox",
                get = Options.GetterOption,
                set = Options.SetterOption,
                validate = OptionValidate
            },
            height = {
                order = order + 2,
                type = "input",
                width = "full",
                name = L["OPTION_HEIGHT"],
                dialogControl = "Eb-NumberEditBox",
                get = Options.GetterOption,
                set = Options.SetterOption,
                validate = OptionValidate
            },
            positionX = {
                order = order + 3,
                type = "input",
                width = "full",
                name = L["OPTION_POSITION_X"],
                dialogControl = "Eb-NumberEditBox",
                get = Options.GetterOption,
                set = Options.SetterOption,
            },
            centerHorizontally = {
                order = order + 4,
                type = "execute",
                width = "full",
                name = L["OPTION_CENTER_HOR"],
                func = function () Options:SendMessage(Options.OPTION_CENTER_HOR_MESSAGE) end
            },
            positionY = {
                order = order + 5,
                type = "input",
                width = "full",
                name = L["OPTION_POSITION_Y"],
                dialogControl = "Eb-NumberEditBox",
                get = Options.GetterOption,
                set = Options.SetterOption,
            },
            centerVertically = {
                order = order + 6,
                type = "execute",
                width = "full",
                name = L["OPTION_CENTER_VER"],
                func = function () Options:SendMessage(Options.OPTION_CENTER_VER_MESSAGE) end
            },
        }
    }
    return options
end

function Options: SetupOptions ()
    self.options = {
        type = "group",
        name = "Experience Bar",
        args = {
            options = {
                order = 1,
                type = "group",
                name = L["OPTIONS"],
                childGroups = "tab",
                args = {
                    general = Options:GetGeneralOptions(),
                    design = Options:GetDesignOptions(),
                    position = Options:GetPositionOptions(),
                }
            }
        }
    }

    self.options.args.profiles = AceDBOptions:GetOptionsTable(ExperienceBar.db)
    AceConfig:RegisterOptionsTable("ExperienceBar", self.options)
    AceConfigDialog:SetDefaultSize("ExperienceBar", 600, 400)

    Options:RegisterChatCommand("eb", "Open")
    Options:RegisterChatCommand("expbar", "Open")
    Options:RegisterChatCommand("experiencebar", "Open")

    ExperienceBar.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
    ExperienceBar.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
    ExperienceBar.db.RegisterCallback(self, "OnProfileReset", "Refresh")
    ExperienceBar.db.RegisterCallback(self, "OnProfileDeleted", "Refresh")
end

function Options: Open ()

    AceConfigDialog:SetDefaultSize("ExperienceBar", 600, 400)
    AceConfigDialog:Open("ExperienceBar")

    local frame = AceConfigDialog.OpenFrames["ExperienceBar"] 
    
    local function OnHide ()
        local res = AceHook:Unhook(frame, "Hide")
        local isHooked, func = AceHook:IsHooked(frame, "Hide")
        Options:SendMessage(Options.OPTIONS_HIDE_MESSAGE)
    end

    if (frame and not AceHook:IsHooked(frame, "Hide")) then
        AceHook:Hook(frame, "Hide", OnHide)
        local isHooked, func = AceHook:IsHooked(frame, "Hide")
        Options:SendMessage(Options.OPTIONS_OPEN_MESSAGE)
    end

end

function Options: OnEnable ()
    self:SetupOptions()
    ExperienceBar:GetModule("Bar"):Enable()
end

function Options: Refresh ()
    AceConfigRegistry:NotifyChange("ExperienceBar")
    Options:SendMessage(Options.OPTION_CHANGED_MESSAGE)
end

Options.GetterOption = function (info)
    local db = ExperienceBar.db.profile
    local option = db[info[#info]]
    local type = info.option.type
    local isEditBox =  info.option.dialogControl == "Eb-NumberEditBox"

    if type == "color" then
        return option.r, option.g, option.b, option.a
    end

    if isEditBox then
        return tostring(option)
    end

    return option
end

Options.SetterOption = function (info, ...)

    local db = ExperienceBar.db.profile
    local option = info[#info]
    local type = info.option.type
    local isEditBox =  info.option.dialogControl == "Eb-NumberEditBox"

    if type == "color" then
        db[option].r = select(1, ...)
        db[option].g = select(2, ...)
        db[option].b = select(3, ...)
        db[option].a = select(4, ...)  
    elseif isEditBox then
        db[option] = tonumber(select(1, ...))
    else
        db[option] = select(1, ...)
        if option == "isExtraEnabled" then
            AceConfigRegistry:NotifyChange("ExperienceBar")
        end
    end

    Options:SendMessage(Options.OPTION_CHANGED_MESSAGE)
end