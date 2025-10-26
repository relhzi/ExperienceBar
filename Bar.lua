-- Copyright (c) 2025, Relhzi

local AceAddon = LibStub("AceAddon-3.0")
local ExperienceBar = AceAddon:GetAddon("ExperienceBar")
local Bar = ExperienceBar:GetModule("Bar")
local Options = ExperienceBar:GetModule("Options")

function Bar: OnEnable ()
    
    local container = CreateFrame("Frame", nil, UIParent)
    container:SetScript("OnDragStart", self.DragStart)
    container:SetScript("OnDragStop", self.DragStop)
    container:RegisterForDrag("LeftButton")

    container.bg = container:CreateTexture(nil, "BACKGROUND")
    container.bg:SetAllPoints()
    container.bg:SetTexture(0, 0, 1, 0.8)

    local status = CreateFrame("StatusBar", nil, container)
    status:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
    status:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", 0, 0)
    status:SetFrameLevel(container:GetFrameLevel() + 1)

    local extrastatus = CreateFrame("Frame", nil, container)
    extrastatus:SetPoint("TOP", status, "TOP", 0, 0)
    extrastatus:SetPoint("BOTTOM", status, "BOTTOM", 0, 0)
    extrastatus:SetFrameLevel(container:GetFrameLevel() + 2)
    extrastatus:Hide()

    extrastatus.bg = extrastatus:CreateTexture(nil, "BACKGROUND")
    extrastatus.bg:SetPoint("TOPLEFT", extrastatus, "TOPLEFT", 0, 0)
    extrastatus.bg:SetPoint("BOTTOMRIGHT", extrastatus, "BOTTOMRIGHT", 0, 0)

    extrastatus.animGroup = extrastatus:CreateAnimationGroup()

    local border = CreateFrame("Frame", nil, container)
    border:SetPoint("TOPLEFT", container, "TOPLEFT", -4, 4)
    border:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", 4, -4)
    border:SetFrameLevel(container:GetFrameLevel() + 3)

    local textcontainer = CreateFrame("Frame", nil, container)
    textcontainer:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
    textcontainer:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", 0, 0)
    textcontainer:SetFrameLevel(container:GetFrameLevel() + 4)

    local text = textcontainer:CreateFontString(nil, "OVERLAY")
    text:SetPoint("CENTER", 0, 0)

    local extratext = textcontainer:CreateFontString(nil, "OVERLAY")
    extratext:SetPoint("LEFT", text, "RIGHT", 0, 0)

    extratext.animGroup = extratext:CreateAnimationGroup()

    local lock = CreateFrame("Frame", nil, container)
    lock:SetPoint("TOPLEFT", container, "TOPLEFT", -8, 8)
    lock:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", 8, -8)
    lock:SetFrameLevel(container:GetFrameLevel() + 5)
    lock:EnableMouse(false)
    lock:Hide()

    lock.bg = lock:CreateTexture(nil, "BACKGROUND")
    lock.bg:SetPoint("TOPLEFT", lock, "TOPLEFT", 0, 0)
    lock.bg:SetPoint("BOTTOMRIGHT", lock, "BOTTOMRIGHT", 0, 0)
    lock.bg:SetTexture(0, 1, 0, 0.2)

    self.bar = {
        lock = lock,
        text = text,
        status = status,
        border = border,
        container = container,
        extratext = extratext,
        extrastatus = extrastatus
    }

    self:ApplyOptions()
    self:RegisterEvent("PLAYER_XP_UPDATE", "Update")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Update")
    self:RegisterMessage(Options.OPTION_CHANGED_MESSAGE, "ApplyOptions")
    self:RegisterMessage(Options.OPTION_CENTER_HOR_MESSAGE, "CenterHorizontally")
    self:RegisterMessage(Options.OPTION_CENTER_VER_MESSAGE, "CenterVertically")
    
    self.PREVIEW_XP = 500
    self.PREVIEW_XPMAX = 1000

    local function OnOptionsOpen() 
        print("OnOptionsOpen")
        Bar.isPreviewEnabled = true 
        Bar:Update()
        Bar.previewTimer = Bar:ScheduleRepeatingTimer(function () Bar:Update() end, 7)
    end
    
    local function OnOptionsHide() 
        print("OnOptionsHide")
        Bar.isPreviewEnabled = false 
        Bar:CancelTimer(Bar.previewTimer)
        Bar:StopAnimation()
        Bar:Update()
    end

    self:RegisterMessage(Options.OPTIONS_OPEN_MESSAGE, OnOptionsOpen)
    self:RegisterMessage(Options.OPTIONS_HIDE_MESSAGE, OnOptionsHide)
end

function Bar: ApplyOptions ()
    local bar = self.bar
    local db = ExperienceBar.db.profile

    if db.isHidden then
        bar.container:Hide()
        return
    end
        
    bar.container:Show()

    if db.isLocked then
        bar.lock:Hide()
        bar.container:SetMovable(false)
        bar.container:EnableMouse(false)
    else
        bar.lock:Show()
        bar.container:SetMovable(true)
        bar.container:EnableMouse(true)
    end

    bar.container:ClearAllPoints()
    bar.container:SetSize(db.width, db.height)
    bar.container:SetPoint("BOTTOMLEFT", db.positionX , db.positionY)

    --- background
    -- bar.container.bg:SetVertexColor(db.bgColor.r, db.bgColor.g, db.bgColor.b, db.bgColor.a)
    bar.container.bg:SetTexture(db.bgColor.r, db.bgColor.g, db.bgColor.b, db.bgColor.a)
    
    --- border
    bar.border:SetBackdrop({
        edgeSize = 16,
        edgeFile = Options.BORDER[db.borderTexture],
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    bar.border:SetBackdropBorderColor(db.borderColor.r, db.borderColor.g, db.borderColor.b, db.borderColor.a)

    --- status
    local value = bar.status:GetValue()
    local min, max = bar.status:GetMinMaxValues()

    bar.status:SetStatusBarTexture(Options.STATUSBAR[db.barTexture])
    bar.status:GetStatusBarTexture():SetVertexColor(db.barColor.r, db.barColor.g, db.barColor.b, db.barColor.a)

    bar.status:SetMinMaxValues(min, max)
    bar.status:SetValue(value)

    --- text main
    bar.text:SetFont(Options.FONT[db.textFont], db.textSize, "OUTLINE")
    bar.text:SetTextColor(db.textColor.r, db.textColor.g, db.textColor.b, db.textColor.a)

    --- status anim
    bar.extrastatus.bg:SetTexture(db.extraBarColor.r, db.extraBarColor.g, db.extraBarColor.b, db.extraBarColor.a)

    --- text anim
    bar.extratext:SetFont(Options.FONT[db.textFont], db.textSize, "OUTLINE")
    bar.extratext:SetTextColor(db.extraTextColor.r, db.extraTextColor.g, db.extraTextColor.b, db.extraTextColor.a)

    if not db.isExtraEnabled then
        bar.extrastatus:Hide()
        bar.extratext:Hide()
    end

    self:Update()
end

function Bar: Update(event)
    
    local text
    local xp = nil
    local xpmax = nil
    local bar = self.bar
    local textDisplayAs = ExperienceBar.db.profile.textDisplayAs
    local isExtraEnabled = ExperienceBar.db.profile.isExtraEnabled

    if self.isPreviewEnabled then
        xp = self.PREVIEW_XP
        xpmax = self.PREVIEW_XPMAX
        -- bar.status.xpprev = bar.status:GetValue(xp)
        -- bar.status.xpmaxprev = select(2, bar.status:GetMinMaxValues())
    else
        xp = UnitXP("player")
        xpmax = UnitXPMax("player")
        -- bar.status:SetMinMaxValues(0, bar.status.xpmaxprev)
        -- bar.status:SetValue(bar.status.xpprev)
        -- bar.status.xpprev = nil
        -- bar.status.xpmaxprev = nil
    end

    text = ""

    if textDisplayAs == "NUMBER" then
        text = string.format("%d / %d", xp, xpmax)
    end
    
    if textDisplayAs == "PERCENT" then
        text = string.format("%.1f%%", xp * 100 / xpmax)
    end


    if event == "PLAYER_XP_UPDATE" or self.isPreviewEnabled then
        self:ExtraUpdate()
    end

    bar.text:SetText(text)
    bar.status:SetMinMaxValues(0, xpmax)
    bar.status:SetValue(xp)

end

function Bar: ExtraUpdate()

    if not ExperienceBar.db.profile.isExtraEnabled then return end

    local xp = nil
    local xpmax = nil
    local status = self.bar.status
    local extratext = self.bar.extratext
    local extrastatus = self.bar.extrastatus

    if not extrastatus.xpmax_prev then
        extrastatus.xpprev = status:GetValue()
        extrastatus.xpmax_prev = select(2, status:GetMinMaxValues())
    end

    if self.isPreviewEnabled then
        xp = self.PREVIEW_XP
        xpmax = self.PREVIEW_XPMAX
        extrastatus.xpprev = xp - 100
        extrastatus.xpmax_prev = self.PREVIEW_XPMAX
    else
        xp = UnitXP("player")
        xpmax = UnitXPMax("player")
    end

    local text = ""
    local extrastatus_offset = nil
    local extrastatus_width = nil
    local textDisplayAs = ExperienceBar.db.profile.textDisplayAs

    if extrastatus.xpmax_prev == xpmax then
        extrastatus_offset = status:GetWidth() * (extrastatus.xpprev / extrastatus.xpmax_prev)
        extrastatus_width = status:GetWidth() * ((xp - extrastatus.xpprev) / extrastatus.xpmax_prev)
    else
        extrastatus_offset = 0
        extrastatus_width = status:GetWidth() * (xp / xpmax)
        xp = xp + xpmax
    end

    if textDisplayAs == "PERCENT" then
        text = string.format("+ %.1f%%", (xp - extrastatus.xpprev) * 100 / extrastatus.xpmax_prev)
    end

    if textDisplayAs == "NUMBER" then
        text = string.format("+ %d", xp - extrastatus.xpprev)
    end

    extratext:SetText(text)
    extrastatus:SetPoint("LEFT", extrastatus_offset, 0)
    extrastatus:SetWidth(extrastatus_width)

    extratext:Show()
    extrastatus:Show()

    -- local function onAnimationEnd ()
    --     extratext:Hide()
    --     extrastatus:Hide()
    --     extrastatus.xpprev = nil
    --     extrastatus.xpmax_prev = nil
    --     extrastatus.timer = nil
    -- end

    local function onTimerEnd ()
        if not extrastatus.scaleAnim then
            extrastatus.scaleAnim = extrastatus.animGroup:CreateAnimation("Scale")
            extrastatus.scaleAnim:SetScale(0, 1)
            extrastatus.scaleAnim:SetOrigin("RIGHT", 0, 0)
            extrastatus.scaleAnim:SetDuration(3)
            extrastatus.scaleAnim:SetSmoothing("IN_OUT")
            extrastatus.scaleAnim:SetScript("OnFinished", Bar.StopAnimation)
        end
        if not extrastatus.alphaAnim then
            extrastatus.alphaAnim = extrastatus.animGroup:CreateAnimation("Alpha")
            extrastatus.alphaAnim:SetChange(-1)
            extrastatus.alphaAnim:SetStartDelay(2)
            extrastatus.alphaAnim:SetDuration(1)
            extrastatus.alphaAnim:SetSmoothing("IN_OUT")
        end
        if not extratext.alphaAnim then
            extratext.alphaAnim = extratext.animGroup:CreateAnimation("Alpha")
            extratext.alphaAnim:SetChange(-1)
            extratext.alphaAnim:SetDuration(3)
            extratext.alphaAnim:SetSmoothing("IN_OUT")
        end
        if not extratext.translationAnim then
            extratext.translationAnim = extratext.animGroup:CreateAnimation("Translation")
            extratext.translationAnim:SetOffset(10, 0)
            extratext.translationAnim:SetDuration(3)
            extratext.translationAnim:SetSmoothing("IN_OUT")
        end
        extratext.animGroup:Play()
        extrastatus.animGroup:Play()
    end
    
    if not extrastatus.timer then
        extrastatus.timer = self:ScheduleTimer(onTimerEnd, 3)
    else
        self:CancelTimer(extrastatus.timer, true)
        extrastatus.timer = self:ScheduleTimer(onTimerEnd, 3)
        if extrastatus.scaleAnim then 
            extratext.animGroup:Stop()
            extrastatus.animGroup:Stop()
        end
    end
      
end

function Bar: StopAnimation ()
    Bar.bar.extratext:Hide()
    Bar.bar.extrastatus:Hide()
    Bar.bar.extrastatus.xpprev = nil
    Bar.bar.extrastatus.xpmax_prev = nil
    Bar:CancelTimer(Bar.bar.extrastatus.timer, true)
    Bar.bar.extrastatus.timer = nil
    Bar.bar.extratext.animGroup:Stop()
    Bar.bar.extrastatus.animGroup:Stop()
end

function Bar: DragStart ()
    local bar = Bar.bar
    bar.container:StartMoving()
end

function Bar: DragStop ()
    local bar = Bar.bar
    bar.container:StopMovingOrSizing()
    local x = bar.container:GetLeft() 
    local y = bar.container:GetBottom() 
    ExperienceBar.db.profile.positionX = x
    ExperienceBar.db.profile.positionY = y
end

function Bar: CenterHorizontally ()
    local x = UIParent:GetWidth() / 2 - (self.bar.container:GetWidth() / 2)
    ExperienceBar.db.profile.positionX = x
    self:ApplyOptions()
end

function Bar: CenterVertically ()
    local y = UIParent:GetHeight() / 2 - (self.bar.container:GetHeight() / 2)
    ExperienceBar.db.profile.positionY = y
    self:ApplyOptions()
end