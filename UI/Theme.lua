-- Themes for BeautifulAttune's own windows (options window) and the look it gives Attune's window. A theme is plain data.
-- Theme.Bind registers a paint function per object; it reruns on theme, accent, status-scheme or font changes, so open
-- windows follow without a reload.
-- The accent is a setting of its own (settings.accent = { mode, r, g, b }) and applies to every theme:
--   "theme"  the theme's own accent        "eui"     the host's accent (only while EllesmereUI is loaded)
--   "class"  the player's class color      "custom"  r, g, b
-- EllesmereUI is optional and only reached through ns.Env: the "eui" theme and the "eui" accent exist only while it is loaded.
local _, ns = ...
local L = ns.L

local Theme = {}
ns.Theme = Theme

local FALLBACK_ACCENT = { 0.047, 0.824, 0.616 } -- EUI's default accent, used when EUI gives none
local WHITE = "Interface\\Buttons\\WHITE8X8"
local ORDER = { "eui", "standard", "classic", "parchment", "midnight", "frost", "light" }
local MODES = { "theme", "eui", "class", "custom" }

local function Hex(hex, alpha)
    return { tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255,
        alpha or 1 }
end

-- Quick picks for an own accent (12 colors, warm to cool).
Theme.PALETTE = {
    Hex("e5484d"), Hex("f76b15"), Hex("ffb224"), Hex("f5d90a"), Hex("8ed05a"), Hex("30a46c"),
    Hex("12a594"), Hex("3d9bff"), Hex("3e63dd"), Hex("8e4ec6"), Hex("d6409f"), Hex("c8ccd2"),
}

-- Blizzard frame art for the classic theme (paths checked in V-N8; tooltip border is assumed alongside).
local function ClassicBackdrops()
    local dialog = {
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 26,
        insets = { left = 8, right = 8, top = 8, bottom = 8 },
    }
    local tooltip = {
        bgFile = WHITE,
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    }
    return {
        window = { def = dialog, color = { 1, 1, 1, 1 }, edge = { 1, 1, 1, 1 } },
        panel = { def = tooltip, color = { 0, 0, 0, 0.45 }, edge = { 0.62, 0.55, 0.42, 1 } },
        input = { def = tooltip, color = { 0, 0, 0, 0.6 }, edge = { 0.55, 0.55, 0.55, 1 } },
        button = { def = tooltip, color = { 0.42, 0.06, 0.03, 0.95 }, edge = { 0.75, 0.62, 0.38, 1 } },
        popup = { def = tooltip, color = { 0.08, 0.06, 0.035, 1 }, edge = { 0.62, 0.55, 0.42, 1 } },
    }
end

-- EUI-style tokens; used twice: as the selectable "EllesmereUI" theme and for the pages inside EllesmereUI's options window.
local function EUITokens(label)
    return {
        label = label, mode = "dark", live = true, inset = 1, pad = 8, borderSize = 1,
        bg = { 0.069, 0.058, 0.047, 0.97 }, bgAlt = { 0.094, 0.082, 0.070, 1 }, border = { 1, 1, 1, 0.08 },
        text = { 1, 1, 1, 0.92 }, textDim = { 1, 1, 1, 0.53 }, header = { 1, 1, 1, 0.78 },
        accent = { FALLBACK_ACCENT[1], FALLBACK_ACCENT[2], FALLBACK_ACCENT[3], 1 }, onAccent = Hex("0b0907"),
        danger = Hex("e5484d"), control = { 0.089, 0.080, 0.072, 0.9 }, inputBg = { 0.030, 0.023, 0.018, 0.8 },
        canvasBg = Hex("0e0c0a"),
    }
end

-- Token set per theme. bg = window fill, bgAlt = header/raised areas, control = button fill, onAccent = text on an
-- accent fill, inset = border thickness, pad = inner spacing. Labels resolve through L when listed (locale is final
-- only in ADDON_LOADED).
local themes = {
    eui = EUITokens("EllesmereUI"),
    standard = { -- neutral graphite, fresh blue accent: the default without EllesmereUI
        label = "Standard", mode = "dark", inset = 1, pad = 8, borderSize = 1,
        bg = Hex("15171b", 0.97), bgAlt = Hex("1d2025"), border = { 1, 1, 1, 0.09 },
        text = Hex("eceef2"), textDim = Hex("959ca7"), header = Hex("d3d8df"),
        accent = Hex("3d9bff"), onAccent = Hex("06121f"),
        danger = Hex("f0524f"), control = Hex("22262c"), inputBg = Hex("0e1013"),
        canvasBg = Hex("111316"),
    },
    classic = {
        label = "Classic", mode = "dark", inset = 8, pad = 8, borderSize = 1, backdrop = ClassicBackdrops(),
        bg = { 0, 0, 0, 0.8 }, bgAlt = { 0, 0, 0, 0.3 }, border = { 0.62, 0.55, 0.42, 0.7 },
        sheet = Hex("0d0a07"), popup = Hex("140f09"), -- the see-through fills above would let the list shine through
        text = Hex("f4ecdc"), textDim = Hex("ada392"), header = { 1, 0.82, 0, 1 },
        accent = { 1, 0.82, 0, 1 }, onAccent = Hex("1a1206"),
        danger = Hex("ff4a3a"), control = Hex("6b0f07", 0.95), inputBg = { 0, 0, 0, 0.6 },
        canvasBg = Hex("17110a"),
    },
    parchment = { -- aged vellum, iron-gall ink, an oxblood seal as accent
        label = "Parchment", mode = "light", inset = 1, pad = 8, borderSize = 1,
        bg = Hex("d8c7a0", 0.98), bgAlt = Hex("c9b68b"), border = Hex("6f5434", 0.55),
        text = Hex("33241a"), textDim = Hex("54422f"), header = Hex("4e3420"), -- dim text >= 4.5:1 on every fill
        accent = Hex("80281a"), onAccent = Hex("f2e6c9"),
        danger = Hex("a3271b"), control = Hex("cdb98e"), inputBg = Hex("ebdfc2"),
        canvasBg = Hex("efe4c8"),
    },
    midnight = { -- deep indigo night sky, violet arcane accent
        label = "Midnight", mode = "dark", inset = 1, pad = 8, borderSize = 1,
        bg = Hex("0e0f24", 0.97), bgAlt = Hex("16173a"), border = Hex("6c6fd6", 0.22),
        text = Hex("e7e5ff"), textDim = Hex("9896c6"), header = Hex("cbbcff"),
        accent = Hex("9d7bff"), onAccent = Hex("120c2a"),
        danger = Hex("ff5c7a"), control = Hex("1b1c44"), inputBg = Hex("09091a"),
        canvasBg = Hex("0b0b1d"),
    },
    frost = { -- northern slate and rime, ice-blue accent
        label = "Frost", mode = "dark", inset = 1, pad = 8, borderSize = 1,
        bg = Hex("1b2228", 0.97), bgAlt = Hex("232d35"), border = Hex("9cc3d8", 0.2),
        text = Hex("e4eef3"), textDim = Hex("91a5b1"), header = Hex("bce6f6"),
        accent = Hex("7fd3f5"), onAccent = Hex("0c1a22"),
        danger = Hex("ff6b6b"), control = Hex("27323b"), inputBg = Hex("12181d"),
        canvasBg = Hex("151c22"),
    },
    light = { -- bright monitors: near-white paper, steel-blue accent
        label = "Light", mode = "light", inset = 1, pad = 8, borderSize = 1,
        bg = Hex("f5f6f8", 0.98), bgAlt = Hex("e7eaee"), border = Hex("aeb6c2", 0.8),
        text = Hex("1c2230"), textDim = Hex("5b6577"), header = Hex("2a3345"),
        accent = Hex("2a62c9"), onAccent = Hex("ffffff"), -- accent as text >= 4.5:1 on every fill
        danger = Hex("cf3434"), control = Hex("e2e6eb"), inputBg = Hex("ffffff"),
        canvasBg = Hex("ffffff"),
    },
}
-- The views inside EllesmereUI's own options window always keep EUI's look and accent, next to EUI's widgets.
-- Surfaces that lie over other content (search results, menus, the zoom bar, the detail panel) must never be see-through:
-- sheet = an opaque bg, popup = an opaque bgAlt, unless a theme names its own.
local function Opaque(T)
    T.sheet = T.sheet or { T.bg[1], T.bg[2], T.bg[3], 1 }
    T.popup = T.popup or { T.bgAlt[1], T.bgAlt[2], T.bgAlt[3], 1 }
end

local panel = EUITokens("EllesmereUI")
panel.success = Hex("30a46c")
panel.white = { 1, 1, 1, 1 }
Opaque(panel)

-- Each theme remembers its own accent; the effective accent is computed from the accent setting. success (done marks,
-- completed progress) is the same green in every theme and independent of the accent.
for _, T in pairs(themes) do
    T.success = Hex("30a46c")
    T.white = { 1, 1, 1, 1 } -- marks on status colours (check on a done card)
    Opaque(T)
    T.baseAccent = { T.accent[1], T.accent[2], T.accent[3] }
    T.baseOnAccent = { T.onAccent[1], T.onAccent[2], T.onAccent[3], T.onAccent[4] or 1 }
end

-- Tokens computed from the accent and the mode; rerun whenever the accent changes.
local function Derive(T)
    local a = T.accent
    T.accentSoft = { a[1], a[2], a[3], 0.22 }
    T.select = { a[1], a[2], a[3], 0.16 }
    T.thumb = { a[1], a[2], a[3], 0.6 }
    if T.mode == "light" then
        T.hover = { 0, 0, 0, 0.07 }
        T.track = { 0, 0, 0, 0.08 }
    else
        T.hover = { 1, 1, 1, 0.06 }
        T.track = { 1, 1, 1, 0.06 }
    end
end

Theme.signals = { repaints = 0 }
local liveSignature     -- host accent + panel + font as last painted
local bindings = setmetatable({}, { __mode = "k" })
local listeners = {}

-- Is the optional host (EllesmereUI) present?
local function EUI()
    return ns.Env.HasEUI() or nil
end

---------------------------------------------------------------------------
-- Accent
---------------------------------------------------------------------------

-- The host's accent, or nil without a host.
local function EUIAccent()
    if not EUI() then return nil end
    local r, g, b = ns.Env.Accent()
    if r then return r, g, b end
    return FALLBACK_ACCENT[1], FALLBACK_ACCENT[2], FALLBACK_ACCENT[3]
end

-- The player's class color (the own class is never a secret value, guarded anyway).
local function ClassAccent()
    if type(UnitClass) ~= "function" then return nil end
    local _, class = UnitClass("player")
    if class == nil or ns.IsSecret(class) then return nil end
    local c = RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
    if c and type(c.r) == "number" then return c.r, c.g, c.b end
    return nil
end

local function AccentSettings()
    local s = ns.db and ns.db.settings
    return s and s.accent or nil
end

-- Effective mode: "eui" falls back to "theme" while EllesmereUI is not loaded.
function Theme.AccentMode()
    local a = AccentSettings()
    local mode = a and a.mode or "theme"
    if mode == "eui" and not EUI() then mode = "theme" end
    if mode ~= "theme" and mode ~= "eui" and mode ~= "class" and mode ~= "custom" then mode = "theme" end
    return mode
end

function Theme.CustomAccent()
    local a = AccentSettings()
    if a and type(a.r) == "number" and type(a.g) == "number" and type(a.b) == "number" then return a.r, a.g, a.b end
    return 0.24, 0.61, 1
end

-- Dropdown data: values { key = label }, order { key, ... }.
function Theme.AccentModes()
    local values, order = {}, {}
    local labels = {
        theme = L["Theme default"], eui = L["EllesmereUI accent"], class = L["Class color"], custom = L["Own color"],
    }
    for _, key in ipairs(MODES) do
        if key ~= "eui" or EUI() then
            values[key] = labels[key]
            order[#order + 1] = key
        end
    end
    return values, order
end

-- Text color on an accent fill: dark on light accents, white on dark ones.
local function OnAccentFor(r, g, b)
    local lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
    if lum > 0.5 then return 0.05, 0.05, 0.06 end
    return 1, 1, 1
end

local function SetAccent(T, r, g, b, onAccent)
    T.accent[1], T.accent[2], T.accent[3], T.accent[4] = r, g, b, 1
    if onAccent then
        T.onAccent[1], T.onAccent[2], T.onAccent[3], T.onAccent[4] = onAccent[1], onAccent[2], onAccent[3], onAccent[4] or 1
    else
        T.onAccent[1], T.onAccent[2], T.onAccent[3] = OnAccentFor(r, g, b)
        T.onAccent[4] = 1
    end
    Derive(T)
end

-- Apply the accent setting to every theme and EUI's accent to the panel look.
local function Recompute()
    local mode = Theme.AccentMode()
    local er, eg, eb = EUIAccent()
    local cr, cg, cb
    if mode == "class" then cr, cg, cb = ClassAccent() end
    if mode == "custom" then cr, cg, cb = Theme.CustomAccent() end
    if mode == "eui" then cr, cg, cb = er, eg, eb end
    for key, T in pairs(themes) do
        local base = T.baseAccent
        local br, bg, bb = base[1], base[2], base[3]
        if key == "eui" and er then br, bg, bb = er, eg, eb end
        if cr then
            SetAccent(T, cr, cg, cb)
        elseif key == "eui" then
            SetAccent(T, br, bg, bb)
        else
            SetAccent(T, br, bg, bb, T.baseOnAccent)
        end
    end
    SetAccent(panel, er or FALLBACK_ACCENT[1], eg or FALLBACK_ACCENT[2], eb or FALLBACK_ACCENT[3])
end
Recompute()

---------------------------------------------------------------------------
-- Lookup
---------------------------------------------------------------------------

-- Context of a frame: "eui" inside EUI pages, "user" (the chosen theme) everywhere else.
function Theme.CtxOf(obj)
    local node = obj
    while node do
        if node.fnCtx then return node.fnCtx end
        node = node.GetParent and node:GetParent() or nil
    end
    return "user"
end

-- Key of the theme in use. A saved "eui" without EllesmereUI falls back to "standard" (the setting stays, so the
-- theme returns once EUI is enabled again).
function Theme.Current()
    local key = ns.db and ns.db.settings.theme
    if key == "eui" and not EUI() then key = "standard" end
    if themes[key] then return key end
    return EUI() and "eui" or "standard"
end

function Theme.Get(ctx)
    if ctx == "eui" and EUI() then return panel end
    return themes[Theme.Current()]
end

-- Ordered list for dropdowns: { { key = "standard", label = "Standard" }, ... }; "eui" only while EUI is loaded.
function Theme.List()
    local list = {}
    for _, key in ipairs(ORDER) do
        if key ~= "eui" or EUI() then
            list[#list + 1] = { key = key, label = key == "eui" and themes.eui.label or L[themes[key].label] }
        end
    end
    return list
end

---------------------------------------------------------------------------
-- Font: the choice in settings.font (UI/Fonts.lua); "eui" = EllesmereUI's font while it is loaded
---------------------------------------------------------------------------

-- Chosen bundled/game font, else for "eui": the host's font; last STANDARD_TEXT_FONT.
function Theme.FontPath()
    local key = ns.Fonts and ns.Fonts.Current() or "eui"
    if key ~= "eui" then
        return ns.Fonts.File(key) or STANDARD_TEXT_FONT, ""
    end
    local path, flag = ns.Env.FontPath()
    return path or STANDARD_TEXT_FONT, flag or ""
end

function Theme.SetFont(fontObject, size)
    local path, flag = Theme.FontPath()
    if fontObject:SetFont(path, size, flag) == false then
        fontObject:SetFont(STANDARD_TEXT_FONT, size, flag)
    end
end

---------------------------------------------------------------------------
-- Painting primitives
---------------------------------------------------------------------------

-- Color a texture, line, font string or edit box with a token ({r, g, b, a}); alpha multiplies.
function Theme.Paint(region, color, alpha)
    if not (region and color) then return end
    local a = (color[4] or 1) * (alpha or 1)
    local kind = region:GetObjectType()
    if kind == "FontString" or kind == "EditBox" then
        region:SetTextColor(color[1], color[2], color[3], a)
    else
        region:SetColorTexture(color[1], color[2], color[3], a)
    end
end

local function PixelSize(frame, size)
    if PixelUtil and type(PixelUtil.GetNearestPixelSize) == "function" then
        return PixelUtil.GetNearestPixelSize(size, frame:GetEffectiveScale(), size)
    end
    return size
end

-- Thin lines at fractional pixel positions come out 1 or 2 px thick; snapping them to the pixel grid keeps them even.
function Theme.Crisp(texture)
    if texture.SetSnapToPixelGrid then texture:SetSnapToPixelGrid(true) end
    if texture.SetTexelSnappingBias then texture:SetTexelSnappingBias(0) end
end

local function EnsureBox(frame)
    local box = frame.fnBox
    if box then return box end
    box = { edges = {} }
    box.bg = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
    box.bg:SetAllPoints()
    for i = 1, 4 do
        box.edges[i] = frame:CreateTexture(nil, "BORDER", nil, 7)
        Theme.Crisp(box.edges[i])
    end
    local top, bottom, left, right = box.edges[1], box.edges[2], box.edges[3], box.edges[4]
    top:SetPoint("TOPLEFT"); top:SetPoint("TOPRIGHT")
    bottom:SetPoint("BOTTOMLEFT"); bottom:SetPoint("BOTTOMRIGHT")
    left:SetPoint("TOPLEFT"); left:SetPoint("BOTTOMLEFT")
    right:SetPoint("TOPRIGHT"); right:SetPoint("BOTTOMRIGHT")
    frame.fnBox = box
    return box
end

-- Fill and 1px edge from tokens. With a role ("window", "panel", "input", "button") a theme may use Blizzard art
-- instead (classic); the frame then needs BackdropTemplate. bgKey/edgeKey nil = no fill/edge.
function Theme.Box(frame, T, bgKey, edgeKey, role)
    local box = EnsureBox(frame)
    local art = role and T.backdrop and T.backdrop[role]
    if art and frame.SetBackdrop then
        frame:SetBackdrop(art.def)
        frame:SetBackdropColor(unpack(art.color))
        frame:SetBackdropBorderColor(unpack(art.edge))
        box.art = art
        box.bg:Hide()
        for i = 1, 4 do box.edges[i]:Hide() end
        return
    end
    if box.art then
        frame:SetBackdrop(nil)
        box.art = nil
    end
    if bgKey and T[bgKey] then
        Theme.Paint(box.bg, T[bgKey])
        box.bg:Show()
    else
        box.bg:Hide()
    end
    local size = PixelSize(frame, T.borderSize or 1)
    for i = 1, 4 do
        local edge = box.edges[i]
        if edgeKey and T[edgeKey] then
            if i <= 2 then edge:SetHeight(size) else edge:SetWidth(size) end
            Theme.Paint(edge, T[edgeKey])
            edge:Show()
        else
            edge:Hide()
        end
    end
end

-- Recolor the edge only (focus, selection); nil restores the art's own edge color.
function Theme.Edge(frame, color)
    local box = frame.fnBox
    if not box then return end
    if box.art then
        frame:SetBackdropBorderColor(unpack(color or box.art.edge))
    elseif color then
        for i = 1, 4 do Theme.Paint(box.edges[i], color) end
    end
end

---------------------------------------------------------------------------
-- Bindings and live refresh
---------------------------------------------------------------------------

local function Run(obj, fn)
    local ok, err = pcall(fn, obj, Theme.Get(Theme.CtxOf(obj)))
    if not ok then geterrorhandler()(err) end
end

-- fn(obj, T) paints obj now and again on every change. Context is resolved at paint time (frames may move hosts).
function Theme.Bind(obj, fn)
    local list = bindings[obj]
    if not list then
        list = {}
        bindings[obj] = list
    end
    list[#list + 1] = fn
    Run(obj, fn)
end

-- Repaint one object (after a state change such as hover, selection, enable).
function Theme.Refresh(obj)
    local list = bindings[obj]
    if not list then return end
    for i = 1, #list do Run(obj, list[i]) end
end

local function RepaintAll(userOnly)
    Theme.signals.repaints = Theme.signals.repaints + 1
    for obj, list in pairs(bindings) do
        if not userOnly or Theme.CtxOf(obj) == "user" then
            for i = 1, #list do Run(obj, list[i]) end
        end
    end
end

local function Notify()
    local key = Theme.Current()
    for i = 1, #listeners do listeners[i](key) end
end

-- fn(key) after the user theme or the accent changed (code that caches colors).
function Theme.OnChange(fn)
    listeners[#listeners + 1] = fn
end

function Theme.Set(key)
    if not (themes[key] and ns.db) then return false end
    if key == "eui" and not EUI() then return false end
    if ns.db.settings.theme == key then return true end
    ns.db.settings.theme = key
    RepaintAll(true)
    Notify()
    return true
end

-- Font choice: store it and repaint every text (Kit texts set their font in their paint functions).
function Theme.SetFontChoice(key)
    if not (ns.db and ns.Fonts) then return false end
    if key == "eui" and not EUI() then return false end
    if key ~= "eui" and not ns.Fonts.File(key) then return false end
    ns.db.settings.font = key
    liveSignature = nil
    Theme.CheckLive()
    return true
end

-- Recompute every accent from the setting and repaint everything (accent setting, class color after login).
function Theme.RefreshAccent()
    Recompute()
    RepaintAll(false)
    Notify()
end

function Theme.SetAccentMode(mode)
    local a = AccentSettings()
    if not a then return false end
    if mode == "eui" and not EUI() then return false end
    if mode ~= "theme" and mode ~= "eui" and mode ~= "class" and mode ~= "custom" then return false end
    a.mode = mode
    Theme.RefreshAccent()
    return true
end

-- Picking an own color switches the mode to "custom".
function Theme.SetCustomAccent(r, g, b)
    local a = AccentSettings()
    if not (a and type(r) == "number" and type(g) == "number" and type(b) == "number") then return false end
    a.r = math.max(0, math.min(1, r))
    a.g = math.max(0, math.min(1, g))
    a.b = math.max(0, math.min(1, b))
    a.mode = "custom"
    Theme.RefreshAccent()
    return true
end

-- Re-read the host's accent, panel colour and font; repaint everything when any of them changed. Called by the host's
-- change callbacks (poll = false) and on every OnShow of our windows (poll = true: the host drops values it cached).
local function CheckLive(poll)
    if poll then ns.Env.Poll() end
    local er, eg, eb = EUIAccent()
    local pr, pg, pb = ns.Env.PanelColor()
    local path, flag = Theme.FontPath()
    local signature = ("%s %s %s|%s|%s|%s"):format(tostring(er), tostring(eg), tostring(eb), tostring(pr), path, flag)
    if signature == liveSignature then return end
    liveSignature = signature
    if type(pr) == "number" then
        themes.eui.bg[1], themes.eui.bg[2], themes.eui.bg[3] = pr, pg, pb
        panel.bg[1], panel.bg[2], panel.bg[3] = pr, pg, pb
    end
    Recompute()
    RepaintAll(false)
    if Theme.AccentMode() == "eui" or Theme.Current() == "eui" then Notify() end
end

function Theme.CheckLive()
    CheckLive(true)
end

ns.Env.OnChange(function() CheckLive(false) end)

---------------------------------------------------------------------------
-- Status palette: how the skin colours the states of Attune's cards and lines (see Adapters/Attune.lua NodeState).
-- Two schemes: "modern" (own palette) and "classic" (Attune's own tones). stripe = left card stripe and check mark,
-- fill / edge = card surface and border (nil = the theme's own bgAlt / border), edgeSize in px at 100 %,
-- line = connector colour, dim = muted title and desaturated icon, alpha = overall opacity.
---------------------------------------------------------------------------

local STATUS_ORDER = { "modern", "classic" }

local STATUS = {
    modern = {
        done = { stripe = Hex("30a46c"), line = Hex("30a46c") },
        ready = { stripe = Hex("ffb224"), fill = Hex("ffb224", 0.07), edge = Hex("ffb224", 0.55), line = Hex("ffb224") },
        locked = { stripe = Hex("4b5058"), line = Hex("4b5058"), dim = true },
        key_open = { stripe = Hex("e5484d"), fill = Hex("e5484d", 0.10), edge = Hex("e5484d"), edgeSize = 2,
            line = Hex("e5484d") },
        key_done = { stripe = Hex("3d9bff"), fill = Hex("3d9bff", 0.10), edge = Hex("3d9bff"), edgeSize = 2,
            line = Hex("3d9bff") },
        other_class = { stripe = Hex("4b5058"), line = Hex("4b5058"), dim = true, alpha = 0.5 },
        unknown = { stripeKey = "textDim", lineKey = "textDim" },
    },
    classic = {
        done = { stripe = Hex("5fba46"), fill = Hex("5fba46", 0.30), edge = Hex("5fba46"), line = Hex("63af63") },
        ready = { stripe = Hex("d99b00"), fill = Hex("d99b00", 0.30), edge = Hex("d99b00"), line = Hex("d99b00") },
        locked = { stripe = Hex("666666"), fill = Hex("1a1a1a", 0.5), edge = Hex("666666"), line = Hex("737373") },
        key_open = { stripe = Hex("8e0e13"), fill = Hex("8e0e13", 0.70), edge = Hex("ffffff"), line = Hex("8e0e13") },
        key_done = { stripe = Hex("0e4e93"), fill = Hex("0e4e93", 0.70), edge = Hex("ffffff"), line = Hex("0e4e93") },
        other_class = { stripe = Hex("666666"), fill = Hex("1a1a1a", 0.5), edge = Hex("666666"), line = Hex("737373"),
            alpha = 0.5 },
        unknown = { stripeKey = "textDim", lineKey = "textDim" },
    },
}

function Theme.StatusScheme()
    local key = ns.db and ns.db.settings.statusScheme
    return STATUS[key] and key or "modern"
end

-- Palette entry of a card/line state ("done", "ready", "locked", "key_open", "key_done", "other_class", "unknown").
-- Spacers have none. Unknown states get the neutral entry.
function Theme.Status(state)
    local scheme = STATUS[Theme.StatusScheme()]
    return scheme[state] or scheme.unknown
end

-- Dropdown data: values { key = label }, order { key, ... }.
function Theme.StatusSchemes()
    local labels = { modern = L["Modern"], classic = L["Attune classic"] }
    local values, order = {}, {}
    for _, key in ipairs(STATUS_ORDER) do
        values[key] = labels[key]
        order[#order + 1] = key
    end
    return values, order
end

function Theme.SetStatusScheme(key)
    if not (STATUS[key] and ns.db) then return false end
    if ns.db.settings.statusScheme == key then return true end
    ns.db.settings.statusScheme = key
    RepaintAll(false)
    Notify()
    return true
end

ns.OnReady(function()
    local s = ns.db.settings
    if not themes[s.theme] then s.theme = EUI() and "eui" or "standard" end
    if type(s.accent) ~= "table" then s.accent = { r = 0.24, g = 0.61, b = 1 } end
    local mode = s.accent.mode
    if mode ~= "theme" and mode ~= "eui" and mode ~= "class" and mode ~= "custom" then
        s.accent.mode = EUI() and "eui" or "theme"
    end
    if not STATUS[s.statusScheme] then s.statusScheme = "modern" end
    Recompute()
    CheckLive(true)
end)


-- The class color is certain only after login; repaint once then if the accent follows it.
local loginFrame = CreateFrame("Frame")
loginFrame:RegisterEvent("PLAYER_LOGIN")
loginFrame:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_LOGIN")
    if ns.db and Theme.AccentMode() == "class" then Theme.RefreshAccent() end
end)
