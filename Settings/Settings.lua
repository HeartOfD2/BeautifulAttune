-- Page registry and settings pages, described once as data and drawn by renderers: Settings.RenderKit (our own options
-- window, Kit form blocks); an EllesmereUI renderer can read the same rows (Integration/EUIPages.lua).
-- Row types (all may carry tip, cond = function() -> bool, evaluated when the page is built, and only = "standalone" |
-- "eui" for rows that belong to one host):
--   header { text }                               toggle { text, get, set }
--   slider { text, min, max, step, get, set }     dropdown { text, values() -> labels, order, get, set }
--   button { text, onClick }                      color { text, get() -> r, g, b, set(r, g, b) }
--   palette { text, colors, get() -> r, g, b | nil, set(r, g, b) }    text { text or get() -> text }
--   preview { text }  sample sentence in the chosen font
-- refresh = true: other rows may show a changed value afterwards (renderers re-read the page).
local _, ns = ...
local L = ns.L
local Theme, Kit = ns.Theme, ns.Kit

local Settings = {}
ns.Settings = Settings

---------------------------------------------------------------------------
-- Registry: modules (sidebar headings) and their pages
---------------------------------------------------------------------------

-- form = row set below. Built at call time (the locale is final only after ADDON_LOADED).
function Settings.Modules()
    return {
        { key = "Settings", title = L["Settings"], desc = L["Look, search, modules and information."], pages = {
            { key = "appearance", label = L["Appearance"], form = "appearance" },
            { key = "searchzoom", label = L["Search & zoom"], form = "searchzoom" },
            { key = "modules", label = L["Modules"], form = "modules" },
            { key = "info", label = L["Info"], form = "info" },
        } },
    }
end

-- page, module of a page key (nil when unknown).
function Settings.FindPage(key)
    for _, module in ipairs(Settings.Modules()) do
        for _, page in ipairs(module.pages) do
            if page.key == key then return page, module end
        end
    end
    return nil
end

---------------------------------------------------------------------------
-- Row sets
---------------------------------------------------------------------------

local function ThemeValues()
    local values, order = {}, {}
    for i, theme in ipairs(Theme.List()) do
        values[theme.key] = theme.label
        order[i] = theme.key
    end
    return values, order
end

local function LanguageValues()
    return { auto = L["Automatic"], enUS = "English", deDE = "Deutsch" }, { "auto", "enUS", "deDE" }
end

-- The palette marks a color only while the accent is an own color.
local function PaletteGet()
    if Theme.AccentMode() ~= "custom" then return nil end
    return Theme.CustomAccent()
end

local function Reload()
    if type(ReloadUI) == "function" then ReloadUI() end
end

local function AppearanceRows()
    local s = ns.db.settings
    return {
        { type = "header", text = L["APPEARANCE"] },
        { type = "dropdown", text = L["Theme"], values = ThemeValues, get = Theme.Current,
            set = function(key) Theme.Set(key) end,
            tip = L["Look of the BeautifulAttune windows and of Attune's window."] },
        { type = "dropdown", text = L["Font"], values = function() return ns.Fonts.Values() end,
            get = function() return ns.Fonts.Current() end,
            set = function(key) Theme.SetFontChoice(key) end,
            -- without EllesmereUI no word about it
            tip = ns.HasEUI()
                and L["Font of all BeautifulAttune texts. \"EllesmereUI font\" follows the font set in EllesmereUI (only while it is installed and enabled)."]
                or L["Font of all BeautifulAttune texts."] },
        { type = "preview", text = L["The quick brown fox jumps over the lazy dog. 0123456789"] },
        { type = "dropdown", text = L["Accent color"], values = Theme.AccentModes, get = Theme.AccentMode,
            set = function(mode) Theme.SetAccentMode(mode) end, refresh = true,
            tip = L["Highlight color of every theme: buttons, switches, selections and the search."] },
        { type = "palette", text = L["Own color"], colors = Theme.PALETTE, get = PaletteGet,
            set = function(r, g, b) Theme.SetCustomAccent(r, g, b) end, refresh = true,
            tip = L["Click a color to use it as the accent."] },
        { type = "color", text = L["Pick any color"], get = Theme.CustomAccent,
            set = function(r, g, b) Theme.SetCustomAccent(r, g, b) end, refresh = true,
            tip = L["Opens the color picker. The chosen color becomes the accent."] },
        { type = "dropdown", text = L["Status colors"], values = Theme.StatusSchemes, get = Theme.StatusScheme,
            set = function(key) Theme.SetStatusScheme(key) end,
            tip = L["Colors of done, ready and locked steps. \"Attune classic\" keeps Attune's own tones."] },

        { type = "header", text = L["WINDOW"] },
        { type = "slider", text = L["Window scale"], min = 70, max = 130, step = 5,
            get = function() return math.floor(ns.Skin.WindowScale() * 100 + 0.5) end,
            set = function(value) ns.Skin.SetWindowScale(value / 100) end,
            tip = L["Scales Attune's whole window between 70 % and 130 %."] },
        { type = "toggle", text = L["Hide the icon view"],
            get = function() return s.hideIconView ~= false end,
            set = function(value)
                s.hideIconView = value and true or false
                ns.Skin.ApplyIconView()
            end,
            tip = L["Always shows Attune's list and hides its switch between list and icons."] },

        { type = "header", text = L["CHAIN"] },
        { type = "dropdown", text = L["Line weight"],
            values = function()
                return { fine = L["Fine"], normal = L["Normal"], strong = L["Strong"] }, { "fine", "normal", "strong" }
            end,
            get = function() return s.lineWeight or "normal" end,
            set = function(key)
                s.lineWeight = key
                ns.Skin.GraphApplySettings()
            end,
            tip = L["Thickness of the connectors between the steps (2, 3 or 4 pixels at 100 %)."] },
        { type = "dropdown", text = L["Dungeon picture"],
            values = function()
                return { banner = L["Banner"], background = L["Background"], off = L["Off"] }, { "banner", "background", "off" }
            end,
            get = function() return s.dungeonArt or "banner" end,
            set = function(key)
                s.dungeonArt = key
                ns.Skin.GraphApplySettings()
            end,
            tip = L["Banner above the chain, a faint background as in Attune, or no picture."] },

        { type = "header", text = L["LANGUAGE"] },
        { type = "dropdown", text = L["Language"], values = LanguageValues,
            get = function() return s.language or "auto" end,
            set = function(key)
                s.language = key
                ns.Say(L["The language changes after a reload (/reload)."])
            end,
            tip = ns.HasEUI() and L["Automatic uses the EllesmereUI language when it is installed, else the language of the game."]
                or L["Automatic uses the language of the game."] },
        { type = "text", text = L["Language changes take effect after a reload."] },
        { type = "button", text = L["Reload now"], onClick = Reload },
    }
end

local function SearchZoomRows()
    local s = ns.db.settings
    local function Search() return s.search end
    local function Apply() ns.Skin.SearchApplySettings() end
    return {
        { type = "header", text = L["SEARCH"] },
        { type = "toggle", text = L["Mark matches in the chain"],
            get = function() return Search().mark ~= false end,
            set = function(value)
                Search().mark = value and true or false
                Apply()
            end,
            tip = L["While you search, matching cards of the open chain get an accent frame and the others are dimmed."] },
        { type = "toggle", text = L["Only open steps"],
            get = function() return Search().onlyOpen and true or false end,
            set = function(value)
                Search().onlyOpen = value and true or false
                Apply()
            end,
            tip = L["Hides what is already done from the results. Same as the switch in the result list."] },
        { type = "dropdown", text = L["Filter"], values = function() return ns.Skin.SearchFilters() end,
            get = function() return Search().filter or "all" end,
            set = function(key)
                Search().filter = key
                Apply()
            end,
            tip = L["Which kind of entries the search shows. Same as the chips in the result list."] },
        { type = "text", text = L["Click into the search field above the list, or type and use the arrow keys, Enter and Esc."] },

        { type = "header", text = L["ZOOM"] },
        { type = "toggle", text = L["Zoom above 100 %"],
            get = function() return s.zoomAbove100 ~= false end,
            set = function(value)
                s.zoomAbove100 = value and true or false
                ns.Skin.ZoomApplySettings()
            end,
            tip = L["Lets the zoom bar go up to 150 %. Attune itself stops at 100 %."] },
        { type = "text", text = L["The zoom bar sits at the top right of the chain: minus, percent, plus and \"fit the whole chain\". Ctrl + mouse wheel over the chain zooms as well (10 % steps, 5 % below 50 %)."] },
    }
end

-- Module switches in the order of the window from top to bottom.
local function ModuleList()
    return {
        { key = "window", text = L["Window"],
            tip = L["Flat frame, header with the view switch, status bar and survey menu. The search needs it."] },
        { key = "tree", text = L["List"], tip = L["Rows of Attune's list: sections, icons, levels and progress."] },
        { key = "graph", text = L["Chain"], tip = L["Cards, connectors, the head card and the dungeon picture."] },
        { key = "zoom", text = L["Zoom bar"],
            tip = L["Zoom bar, fit button and Ctrl + mouse wheel; zoom from 10 % to 150 %."] },
        { key = "search", text = L["Search"],
            tip = L["Search field above the list with filters, result list and jump to the card."] },
        { key = "detail", text = L["Quest details"], tip = L["Quest detail panel, map, rewards and the quest giver hint."] },
        { key = "results", text = L["Results"], tip = L["The results table, its choices and the level slider."] },
    }
end

local function ModuleRows()
    local s = ns.db.settings
    local rows = {
        { type = "header", text = L["SKIN MODULES"] },
        { type = "text", text = L["Each part of the skin can be switched off. Changes take effect after a reload; Attune itself keeps working either way."] },
    }
    for _, m in ipairs(ModuleList()) do
        rows[#rows + 1] = { type = "toggle", text = m.text, tip = m.tip,
            get = function() return s.modules[m.key] ~= false end,
            set = function(value) s.modules[m.key] = value and true or false end }
    end
    rows[#rows + 1] = { type = "button", text = L["Reload now"], onClick = Reload }

    rows[#rows + 1] = { type = "header", text = L["GENERAL"] }
    rows[#rows + 1] = { type = "toggle", text = L["Show the minimap button"],
        get = function() return not s.minimap.hide end,
        set = function(value)
            s.minimap.hide = not value
            if ns.MinimapButton then ns.MinimapButton.Apply() end
        end,
        tip = L["Left-click opens or closes Attune, right-click the options. Drag it to move it along the minimap."] }
    rows[#rows + 1] = { type = "toggle", text = L["Version notice"],
        get = function() return s.versionNotice ~= false end,
        set = function(value) s.versionNotice = value and true or false end,
        tip = L["One chat line per session when the installed Attune version has not been tested with BeautifulAttune."] }
    rows[#rows + 1] = { type = "toggle", text = L["Integrate into EllesmereUI"], cond = ns.HasEUI,
        get = function() return s.integrateEUI ~= false end,
        set = function(value)
            s.integrateEUI = value and true or false
            ns.Say(L["The EllesmereUI integration changes after a reload (/reload)."])
        end,
        tip = L["Adds the section \"Attune Skin\" to the EllesmereUI options window; the gear and /battune open it there. Takes effect after a reload."] }

    rows[#rows + 1] = { type = "header", text = L["RESET"] }
    rows[#rows + 1] = { type = "button", text = L["Reset all options"], onClick = function() ns.AskReset() end,
        tip = L["Every BeautifulAttune option back to its default, then the interface reloads. Asks first."] }
    return rows
end

local function InfoRows()
    return {
        { type = "header", text = L["VERSIONS"] },
        { type = "text", get = function() return table.concat(ns.InfoLines(), "\n") end },
        { type = "header", text = L["MODULES"] },
        { type = "text", get = function() return table.concat(ns.ModuleLines(), "\n") end },
        { type = "button", text = L["Print the diagnostics to the chat"], onClick = function() ns.Diag() end,
            tip = L["Same as /battune diag."] },
        { type = "header", text = L["COMMANDS"] },
        { type = "text", get = function() return table.concat(ns.CommandLines(), "\n") end },
        { type = "button", text = L["Open in EllesmereUI"], only = "standalone",
            cond = function() return ns.hosts.eui ~= nil end,
            onClick = function()
                if ns.OpenOptions(nil, "eui") and ns.Options then ns.Options.Hide() end
            end,
            tip = L["The same pages in the EllesmereUI options window (/battune eui)."] },
    }
end

local FORMS = { appearance = AppearanceRows, searchzoom = SearchZoomRows, modules = ModuleRows, info = InfoRows }

-- Rows of a form page for a host ("eui" | "standalone"); rows whose cond fails or that belong to the other host are
-- left out.
function Settings.Rows(form, host)
    local make = FORMS[form]
    if not make then return {} end
    host = host or "standalone"
    local rows = {}
    for _, row in ipairs(make()) do
        if (not row.only or row.only == host) and (not row.cond or row.cond()) then rows[#rows + 1] = row end
    end
    return rows
end

---------------------------------------------------------------------------
-- Standalone renderer (Kit form blocks in a scroll area)
---------------------------------------------------------------------------

local PAD_X, GAP_Y = 6, 2

-- Builds rows into a scroll area filling parent; returns the area with :Refresh() (re-read every value).
function Settings.RenderKit(parent, rows)
    local area = Kit.ScrollArea(parent)
    area:SetAllPoints()
    area.rows = {}
    local child = area.child

    local function Wrap(fn)
        if not fn then return nil end
        return function(...)
            fn(...)
            area:Refresh()
        end
    end

    for _, r in ipairs(rows) do
        local row
        if r.type == "header" then
            row = Kit.SectionHeader(child, r.text)
        elseif r.type == "toggle" then
            row = Kit.ToggleRow(child, r.text, r.get, Wrap(r.set), r.tip)
        elseif r.type == "slider" then
            row = Kit.SliderRow(child, r.text, r.min, r.max, r.step, r.get, r.set, r.tip)
        elseif r.type == "dropdown" then
            row = Kit.DropdownRow(child, r.text, r.values, r.get, Wrap(r.set), r.tip)
        elseif r.type == "button" then
            row = Kit.ButtonRow(child, r.text, r.onClick, r.tip)
        elseif r.type == "color" then
            row = Kit.ColorRow(child, r.text, r.get, Wrap(r.set), r.tip)
        elseif r.type == "palette" then
            row = Kit.PaletteRow(child, r.text, r.colors, r.get, Wrap(r.set), r.tip)
        elseif r.type == "text" then
            row = Kit.TextRow(child, r.text, r.get)
        elseif r.type == "preview" then
            row = Kit.PreviewRow(child, r.text)
        end
        if row then area.rows[#area.rows + 1] = row end
    end

    function area:Layout()
        local y = 0
        for _, row in ipairs(self.rows) do
            if row.Measure then row:Measure() end
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", child, "TOPLEFT", PAD_X, -y)
            row:SetPoint("TOPRIGHT", child, "TOPRIGHT", -PAD_X, -y)
            y = y + (row.rowHeight or 44) + GAP_Y
        end
        self:SetContentHeight(y + 12)
    end

    function area:Refresh()
        for _, row in ipairs(self.rows) do row:Update() end
        self:Layout() -- dynamic texts change their height
    end

    -- wrapped text changes its height with the width
    child:HookScript("OnSizeChanged", function() area:Layout() end)
    area:Layout()
    area:Refresh()
    return area
end
