-- Minimap button (own code, no library): left-click opens or closes Attune's window, right-click opens the options
-- (the EllesmereUI section when it is active), drag moves it around the minimap edge. Position and visibility live in
-- settings.minimap = { hide, angle }.
local addonName, ns = ...
local L = ns.L

local MinimapButton = {}
ns.MinimapButton = MinimapButton

local ICON = "Interface\\AddOns\\BeautifulAttune\\Media\\Icon" -- same as the TOC icon
local button

local function Saved()
    return ns.db.settings.minimap
end

-- Round minimaps get a circle, square ones (GetMinimapShape "SQUARE", e.g. skinned UIs) the square's edge.
local function Place()
    if not button then return end
    local angle = math.rad(Saved().angle or 200)
    local cx, cy = math.cos(angle), math.sin(angle)
    local w = Minimap:GetWidth() / 2 + 5
    local h = Minimap:GetHeight() / 2 + 5
    local shape = type(GetMinimapShape) == "function" and GetMinimapShape() or "ROUND"
    local x, y
    if shape == "SQUARE" then
        x = math.max(-w, math.min(w, cx * w * 1.42))
        y = math.max(-h, math.min(h, cy * h * 1.42))
    else
        x, y = cx * w, cy * h
    end
    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

local function OnDragUpdate()
    local mx, my = Minimap:GetCenter()
    local px, py = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()
    -- GetCenter is nil until the minimap has been laid out
    if type(mx) ~= "number" or type(my) ~= "number" or type(px) ~= "number" or type(py) ~= "number"
        or type(scale) ~= "number" or scale <= 0 then return end
    px, py = px / scale, py / scale
    Saved().angle = math.floor(math.deg(math.atan2(py - my, px - mx)) + 0.5) % 360
    Place()
end

local function ShowTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText(addonName, 1, 0.82, 0.45)
    GameTooltip:AddLine(L["Left-click: open or close Attune"], 0.9, 0.9, 0.9)
    GameTooltip:AddLine(L["Right-click: options"], 0.9, 0.9, 0.9)
    GameTooltip:AddLine(L["Drag: move along the minimap"], 0.7, 0.7, 0.7)
    GameTooltip:Show()
end

local function Create()
    button = CreateFrame("Button", "BeautifulAttuneMinimapButton", Minimap)
    button:SetSize(31, 31)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(Minimap:GetFrameLevel() + 8)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:RegisterForDrag("LeftButton")
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local background = button:CreateTexture(nil, "BACKGROUND")
    background:SetSize(24, 24)
    background:SetPoint("CENTER")
    background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER")
    icon:SetTexture(ICON)
    if icon.SetMask then pcall(icon.SetMask, icon, "Interface\\CharacterFrame\\TempPortraitAlphaMask") end
    button.icon = icon
    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetSize(53, 53)
    border:SetPoint("TOPLEFT")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    button:SetScript("OnClick", function(_, mouse)
        GameTooltip:Hide()
        if mouse == "RightButton" then
            ns.OpenOptions()
        else
            ns.ToggleAttune()
        end
    end)
    button:SetScript("OnDragStart", function(self)
        GameTooltip:Hide()
        self:SetScript("OnUpdate", OnDragUpdate)
    end)
    button:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
    end)
    button:SetScript("OnEnter", ShowTooltip)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- Show or hide after the setting changed.
function MinimapButton.Apply()
    if not (Minimap and ns.db) then return end
    if Saved().hide then
        if button then button:Hide() end
        return
    end
    if not button then Create() end
    Place()
    button:Show()
end

function MinimapButton.Toggle()
    Saved().hide = not Saved().hide
    MinimapButton.Apply()
    ns.Say(Saved().hide and L["Minimap button hidden. /battune minimap shows it again."] or L["Minimap button shown."])
end

-- The button frame (tests and the probe), nil while it was never shown.
function MinimapButton.Frame()
    return button
end

ns.OnReady(MinimapButton.Apply)
