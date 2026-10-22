-- BeautifulAttune core: namespace, locale choice, event dispatch, SavedVariables, combat queue, module registry with
-- error guard, slash command, diagnostics, compartment. Attune is reached only through ns.Attune (Adapters/Attune.lua).
local addonName, ns = ...
local L = ns.L

ns.name = addonName
BeautifulAttune = ns -- the only addon global besides SavedVariables, slash and compartment callbacks

local PREFIX = "|cff6fbfff[BeautifulAttune]|r "
local DB_VERSION = 1
local MAX_ERRORS = 3

local defaults = {
    version = DB_VERSION,
    settings = {
        language = "auto",      -- "auto" | "enUS" | "deDE", applied at load
        versionNotice = true,   -- one chat line per session when the Attune version is untested
        integrateEUI = true,    -- options section in the EllesmereUI options window, applied at load
        minimap = { hide = false, angle = 200 }, -- own minimap button: shown, position on the minimap edge (degrees)
        statusScheme = "modern", -- "modern" | "classic" (Attune's own tones)
        windowScale = 1,        -- scale of Attune's window, 0.7 - 1.3
        hideIconView = true,    -- hide Attune's icon grid and its switch, always show the list
        lineWeight = "normal",  -- chain connectors: "fine" | "normal" | "strong" (2 / 3 / 4 px at 100 %)
        dungeonArt = "banner",  -- dungeon picture: "banner" | "background" (Attune's faint one) | "off"
        zoomAbove100 = true,    -- allow zooming the chain up to 150 % (Attune stops at 100 %)
        -- zoom = <0.1-1.5>     -- last chain zoom, account wide (set by the zoom bar)
        search = {
            filter = "all",     -- chip of the result list: "all" | "attune" | "quest" | "npc" | "item" | "zone"
            onlyOpen = false,   -- hide what is done
            mark = true,        -- mark matching cards of the open chain and dim the others while a search is active
        },
        options = {},           -- options window geometry and last page
        -- skin modules, each can be switched off (takes effect after /reload)
        modules = { window = true, tree = true, graph = true, zoom = true, search = true, detail = true, results = true },
    },
}

local frame = CreateFrame("Frame")
local events = {}
local pending = {}
local readyCallbacks = {}

-- Secret values may not be compared, branched on or printed. Guard before use.
function ns.IsSecret(value)
    return type(issecretvalue) == "function" and issecretvalue(value) and true or false
end

function ns.SafeString(value, fallback)
    if value == nil or ns.IsSecret(value) then return fallback end
    return tostring(value)
end

function ns.Say(text)
    DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. text, 0.95, 0.92, 0.86)
end

function ns.Version()
    local getter = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    local version = type(getter) == "function" and getter(addonName, "Version") or nil
    return type(version) == "string" and version or "?"
end

-- Run an action now, or after combat ends when it touches protected frames.
function ns.Queue(action)
    if InCombatLockdown() then
        pending[#pending + 1] = action
    else
        action()
    end
end

-- Later files register work that needs the database and the final locale (runs at the end of ADDON_LOADED).
function ns.OnReady(callback)
    if ns.db then
        callback()
    else
        readyCallbacks[#readyCallbacks + 1] = callback
    end
end

---------------------------------------------------------------------------
-- Module registry and error guard.
-- ns.Modules.Register(id, { requires = { caps }, setting = "graph", Enable = fn, Disable = fn? })
-- After login (and again when Attune's window appears) every module whose capabilities are all present is enabled
-- once. A module whose handlers fail MAX_ERRORS times is switched off for the session; the first error goes to the
-- error handler (BugSack), Attune itself never sees it. Enable must also handle parts of Attune that already exist.
-- Status: registered, off (setting), missing (capability gone), waiting (needs the window), active, failed.
---------------------------------------------------------------------------

local Modules = { order = {}, byId = {} }
ns.Modules = Modules

function Modules.Register(id, def)
    if Modules.byId[id] then return Modules.byId[id] end
    def.id = id
    def.requires = def.requires or {}
    def.status = "registered"
    def.errors = 0
    def.time = { at = nil, burst = 0, calls = 0, max = 0, total = 0 }
    Modules.byId[id] = def
    Modules.order[#Modules.order + 1] = def
    return def
end

function Modules.IsActive(id)
    local def = Modules.byId[id]
    return def ~= nil and def.status == "active"
end

local function SwitchedOn(def)
    if not def.setting or not ns.db then return true end
    return ns.db.settings.modules[def.setting] ~= false
end

function Modules.Fail(id, err)
    local def = Modules.byId[id]
    if not def then
        geterrorhandler()(err)
        return
    end
    def.errors = def.errors + 1
    if def.errors == 1 then
        def.firstError = tostring(err)
        geterrorhandler()(("%s [%s]: %s"):format(addonName, id, tostring(err)))
    end
    if def.errors >= MAX_ERRORS and def.status == "active" then
        def.status = "failed"
        if def.Disable then pcall(def.Disable) end
    end
end

-- Time spent in our own handlers (never Attune's): per module the last frame in which it ran ("burst", e.g. all a view
-- switch costs us), the largest such frame (with its number of calls) and the sum; the same for all modules together.
-- A handler of another module that runs inside one (an enable during the adapter's check, say) counts for its own
-- module and not for the outer one; a nested handler of the same module counts with the outer call.
local frameTime = { at = nil, ms = 0, max = 0 }
local running = {}                                   -- modules timed right now, innermost last: { def, child ms }

local function Clock()
    return type(debugprofilestop) == "function" and debugprofilestop() or nil
end

local function FrameStamp()
    return type(GetTime) == "function" and GetTime() or 0
end

local function Account(def, ms)
    local t, stamp = def.time, FrameStamp()
    if t.at ~= stamp then t.at, t.burst, t.calls = stamp, 0, 0 end
    t.burst, t.calls, t.total = t.burst + ms, t.calls + 1, t.total + ms
    if t.burst > t.max then t.max, t.maxCalls = t.burst, t.calls end
    if frameTime.at ~= stamp then frameTime.at, frameTime.ms = stamp, 0 end
    frameTime.ms = frameTime.ms + ms
    if frameTime.ms > frameTime.max then frameTime.max = frameTime.ms end
end

-- pcall(fn, ...) with its time booked for the module def.
local function Timed(def, fn, ...)
    local outer = running[#running]
    if outer and outer.def == def then return pcall(fn, ...) end
    local entry = { def = def, child = 0 }
    running[#running + 1] = entry
    local start = Clock()
    local ok, err = pcall(fn, ...)
    local stop = Clock()
    running[#running] = nil
    if start and stop then
        Account(def, (stop - start) - entry.child)
        if outer then outer.child = outer.child + (stop - start) end
    end
    return ok, err
end

-- Runs a handler of a module through pcall; does nothing while the module is not active.
function Modules.Run(id, handler, ...)
    if not Modules.IsActive(id) then return end
    local ok, err = Timed(Modules.byId[id], handler, ...)
    if not ok then Modules.Fail(id, err) end
end

-- { modules = { { id, burst, calls, max, maxCalls, total } ... } (ms, only modules that ran), frame = last frame,
-- frameMax }
function Modules.Timing()
    local list = {}
    for _, def in ipairs(Modules.order) do
        local t = def.time
        if t.at ~= nil then
            list[#list + 1] = { id = def.id, burst = t.burst, calls = t.calls, max = t.max, maxCalls = t.maxCalls or 0,
                total = t.total }
        end
    end
    return { modules = list, frame = frameTime.ms, frameMax = frameTime.max }
end

local function Enable(def)
    def.status = "active"
    if not def.Enable then return end
    local ok, err = Timed(def, def.Enable)
    if not ok then
        Modules.Fail(def.id, err)
        def.status = "failed"
    end
end

local function Check(def)
    if def.status == "active" or def.status == "failed" or def.status == "off" then return end
    if not SwitchedOn(def) then
        def.status = "off"
        return
    end
    local missing, waiting = {}, false
    for _, cap in ipairs(def.requires) do
        local has = ns.Attune.Has(cap)
        if has == false then
            missing[#missing + 1] = cap
        elseif has == nil then
            waiting = true
        end
    end
    def.missing = #missing > 0 and missing or nil
    if def.missing then
        def.status = "missing"
    elseif waiting then
        def.status = "waiting"
    else
        Enable(def)
    end
end

function Modules.CheckAll()
    if not ns.Attune or not ns.db then return end
    for _, def in ipairs(Modules.order) do Check(def) end
end

---------------------------------------------------------------------------
-- Saved variables and locale
---------------------------------------------------------------------------

-- Fill missing keys of the saved table from the defaults, recursing into sub-tables.
local function MergeDefaults(db, source)
    for key, value in pairs(source) do
        if type(value) == "table" then
            if type(db[key]) ~= "table" then db[key] = {} end
            MergeDefaults(db[key], value)
        elseif db[key] == nil then
            db[key] = value
        end
    end
end

local function Migrate(db)
    -- Version 1 is the first layout; later versions upgrade here, one step at a time.
    db.version = DB_VERSION
end

-- Language: the setting, else a preferred locale offered by an integration (ns.PreferredLocale, optional), else the
-- client, else English.
local function ChooseLocale(choice)
    local locale
    if choice == "enUS" or choice == "deDE" then
        locale = choice
        ns.localeSource = "setting"
    else
        local preferred = type(ns.PreferredLocale) == "function" and ns.PreferredLocale() or nil
        if type(preferred) == "string" and preferred ~= "" then
            locale = preferred
            ns.localeSource = "integration"
        else
            locale = GetLocale()
            ns.localeSource = "client"
        end
    end
    if type(locale) ~= "string" or locale == "" or locale == "enGB" then locale = "enUS" end
    ns.locale = locale
    ns.activeLocale = ns.locales[locale] or ns.locales.enUS
end

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------

-- SavedVariables exist only from ADDON_LOADED on; never touch them at file scope.
function events:ADDON_LOADED(loaded)
    if loaded ~= addonName then return end
    self:UnregisterEvent("ADDON_LOADED")
    if type(BeautifulAttuneDB) ~= "table" then BeautifulAttuneDB = {} end
    MergeDefaults(BeautifulAttuneDB, defaults)
    Migrate(BeautifulAttuneDB)
    ns.db = BeautifulAttuneDB
    ChooseLocale(BeautifulAttuneDB.settings.language)
    for i = 1, #readyCallbacks do readyCallbacks[i]() end
    wipe(readyCallbacks)
end

local function VersionNotice()
    if not ns.db.settings.versionNotice or ns.Attune.IsTestedVersion() then return end
    ns.Say(L["Attune %s has not been tested with this version. If something looks wrong: /battune diag"]:format(
        ns.Attune.Version() or "?"))
end

-- Attune enables itself on PLAYER_LOGIN too; checking one frame later sees its finished setup.
function events:PLAYER_LOGIN()
    C_Timer.After(0, function()
        Modules.CheckAll()
        VersionNotice()
    end)
end

function events:PLAYER_REGEN_ENABLED()
    for i = 1, #pending do pending[i]() end
    wipe(pending)
end

frame:SetScript("OnEvent", function(self, event, ...)
    local handler = events[event]
    if handler then handler(self, ...) end
end)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")

---------------------------------------------------------------------------
-- Diagnostics (/battune diag)
---------------------------------------------------------------------------

local ICON_OK = "|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t"
local ICON_MISSING = "|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t"
local ICON_WAIT = "|TInterface\\RaidFrame\\ReadyCheck-Waiting:0|t"

-- Icon and text of a capability state (resolved at call time: the locale is chosen in ADDON_LOADED).
local function StateText(state)
    if state == "lazy" then return ICON_OK, L["not created yet"] end
    if state == "view" then return ICON_WAIT, L["needs the list view"] end
    if state == "window" then return ICON_WAIT, L["waiting for the Attune window"] end
    return ICON_MISSING, L["missing"]
end

local function ModuleText(status)
    if status == "registered" then return L["not checked yet"] end
    if status == "off" then return L["off (setting)"] end
    if status == "missing" then return L["off (Attune part missing)"] end
    if status == "waiting" then return L["waiting for the Attune window"] end
    if status == "active" then return L["on"] end
    if status == "failed" then return L["off (errors)"] end
    return tostring(status)
end

local function Joined(list)
    return table.concat(list, ", ")
end

-- One line per module: "  id: status (missing parts) · errors". Used by diag and the Info page.
function ns.ModuleLines()
    local lines = {}
    for _, def in ipairs(Modules.order) do
        local line = ("  %s: %s"):format(def.id, ModuleText(def.status))
        if def.missing then line = line .. " (" .. Joined(def.missing) .. ")" end
        if def.errors > 0 then
            line = line .. " · " .. L["errors: %d, first: %s"]:format(def.errors, def.firstError or "?")
        end
        lines[#lines + 1] = line
    end
    return lines
end

-- Version lines for the Info page.
function ns.InfoLines()
    local A = ns.Attune
    local lines = { ("%s %s"):format(addonName, ns.Version()) }
    lines[#lines + 1] = L["Attune %s · tested with: %s"]:format(A.Version() or "?", Joined(A.TestedVersions()))
    if ns.Env.HasEUI() then lines[#lines + 1] = L["EllesmereUI found: accent, font and language are followed."] end
    return lines
end

function ns.Diag()
    Modules.CheckAll()
    local A = ns.Attune
    local tested = A.IsTestedVersion()
    ns.Say(L["%s %s · Attune %s · tested with: %s %s"]:format(addonName, ns.Version(), A.Version() or "?",
        Joined(A.TestedVersions()), tested and ICON_OK or ICON_MISSING))

    -- capabilities: ok ones and not-yet-created ones in one line each, every other one with its names
    local okCaps, lazyCaps = {}, {}
    for _, row in ipairs(A.Report()) do
        if row.state == "ok" or row.state == "offline" then
            okCaps[#okCaps + 1] = row.cap
        elseif row.state == "lazy" then
            lazyCaps[#lazyCaps + 1] = row.cap
        else
            local icon, text = StateText(row.state)
            ns.Say(("  %s %s: %s (%s)"):format(icon, row.cap, text, Joined(row.names)))
        end
    end
    if #okCaps > 0 then ns.Say(("  %s %s"):format(ICON_OK, Joined(okCaps))) end
    if #lazyCaps > 0 then
        local icon, text = StateText("lazy")
        ns.Say(("  %s %s: %s"):format(icon, text, Joined(lazyCaps)))
    end

    ns.Say(L["Modules:"])
    for _, line in ipairs(ns.ModuleLines()) do ns.Say(line) end

    local unknown = A.UnknownStates()
    if #unknown == 0 then
        ns.Say(L["Unknown status colours: none"])
    else
        ns.Say(L["Unknown status colours:"])
        for _, entry in ipairs(unknown) do ns.Say(("  %s ×%d"):format(entry.key, entry.count)) end
    end
end

---------------------------------------------------------------------------
-- Slash command and compartment
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Options router: the same pages live in two hosts. "standalone" is our own options window (always there, works in
-- combat); "eui" is the section in the EllesmereUI options window (only when EllesmereUI is loaded and the integration
-- is on). A host registers ns.hosts[key] = { Open(pageKey) -> opened, IsShown(), Hide() }.
---------------------------------------------------------------------------

ns.hosts = {}

function ns.PreferredHost()
    return ns.hosts.eui and "eui" or "standalone"
end

-- Opens the options on pageKey (nil = the last page) in hostKey (nil = preferred; in combat our own window, since
-- EllesmereUI's may not open then). Returns true when a window opened.
function ns.OpenOptions(pageKey, hostKey)
    local explicit = hostKey ~= nil
    hostKey = hostKey or ns.PreferredHost()
    if hostKey == "eui" then
        if not ns.hosts.eui then
            if not ns.HasEUI() then
                ns.Say(L["EllesmereUI is not loaded. /battune options opens the BeautifulAttune window."])
            elseif ns.db and ns.db.settings.integrateEUI then
                ns.Say(L["The EllesmereUI section is not active (%s). Try /reload."]:format(tostring(ns.registerResult)))
            else
                ns.Say(L["The EllesmereUI integration is off. Turn it on under Modules, then /reload."])
            end
            return false
        end
        if InCombatLockdown() then
            if explicit then
                ns.Say(L["The EllesmereUI window cannot be opened in combat. /battune options works."])
                return false
            end
            hostKey = "standalone"
        end
    end
    local host = ns.hosts[hostKey]
    if not host then return false end
    return host.Open(pageKey) and true or false
end

-- Slash command without arguments: open the options; our own window closes again when it is already open.
function ns.ToggleOptions()
    local host = ns.hosts.standalone
    if ns.PreferredHost() == "standalone" and host and host.IsShown() then
        host.Hide()
        return true
    end
    return ns.OpenOptions()
end

---------------------------------------------------------------------------
-- Reset (asks first: a dialog, or the same command a second time when the dialog is missing)
---------------------------------------------------------------------------

local RESET_WINDOW = 10 -- seconds in which the second request confirms
local resetAskedAt

-- All settings back to the defaults, then a reload (every module and the language start fresh).
function ns.ResetSettings()
    wipe(ns.db.settings)
    MergeDefaults(ns.db, defaults)
    ReloadUI()
end

function ns.AskReset()
    if type(StaticPopup_Show) == "function" and type(StaticPopupDialogs) == "table" then
        StaticPopupDialogs.BEAUTIFULATTUNE_RESET = {
            text = L["Reset all BeautifulAttune options to their defaults? The interface reloads."],
            button1 = type(YES) == "string" and YES or L["Yes"],
            button2 = type(NO) == "string" and NO or L["No"],
            OnAccept = function() ns.ResetSettings() end,
            timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
        }
        StaticPopup_Show("BEAUTIFULATTUNE_RESET")
        return
    end
    local now = GetTime()
    if resetAskedAt and now - resetAskedAt <= RESET_WINDOW then
        resetAskedAt = nil
        ns.ResetSettings()
        return
    end
    resetAskedAt = now
    ns.Say(L["Repeat within 10 seconds to reset all options (the interface reloads)."])
end

function ns.ToggleAttune()
    if not ns.Attune.ToggleWindow() then
        ns.Say(L["Attune is not loaded or too old. /battune diag shows details."])
    end
end

local function Help()
    ns.Say(L["Commands:"])
    for _, line in ipairs(ns.CommandLines()) do ns.Say(line) end
end

-- One line per command (chat help and the Info page).
function ns.CommandLines()
    local lines = {
        L["/battune - options"],
        L["/battune options - the BeautifulAttune options window"],
    }
    if ns.HasEUI() then lines[#lines + 1] = L["/battune eui - the options in EllesmereUI"] end
    lines[#lines + 1] = L["/battune attune - open or close the Attune window"]
    lines[#lines + 1] = L["/battune minimap - show or hide the minimap button"]
    lines[#lines + 1] = L["/battune diag - versions, Attune parts and modules"]
    lines[#lines + 1] = L["/battune reset - reset the options"]
    return lines
end

SLASH_BEAUTIFULATTUNE1 = "/battune"
SLASH_BEAUTIFULATTUNE2 = "/beautifulattune"
SlashCmdList["BEAUTIFULATTUNE"] = function(msg)
    local cmd, rest = (msg or ""):match("^(%S*)%s*(.-)%s*$")
    cmd = cmd:lower()
    if cmd == "" then
        ns.ToggleOptions()
    elseif cmd == "options" then
        ns.OpenOptions(nil, "standalone")
    elseif cmd == "eui" then
        ns.OpenOptions(nil, "eui")
    elseif cmd == "attune" then
        ns.ToggleAttune()
    elseif cmd == "minimap" and ns.MinimapButton then
        ns.MinimapButton.Toggle()
    elseif cmd == "diag" then
        ns.Diag()
    elseif cmd == "reset" then
        ns.AskReset()
    elseif ns.devCommands and ns.devCommands[cmd] then -- registered by files of the development checkout only
        ns.devCommands[cmd](rest:lower())
    elseif cmd == "help" then
        Help()
    else
        ns.Say(L["Unknown command."])
        Help()
    end
end

-- Addon compartment callbacks must be real globals (named in the TOC).
-- Left-click toggles Attune's window, right-click opens the options (the EllesmereUI section when it is active).
function BeautifulAttune_OnCompartmentClick(_, mouseButton)
    if mouseButton == "RightButton" then
        ns.OpenOptions()
    else
        ns.ToggleAttune()
    end
end

function BeautifulAttune_OnCompartmentEnter(_, owner)
    GameTooltip:SetOwner(owner, "ANCHOR_LEFT")
    GameTooltip:SetText(addonName, 1, 0.82, 0.45)
    GameTooltip:AddLine(L["Left-click: open or close Attune"], 0.9, 0.9, 0.9)
    GameTooltip:AddLine(L["Right-click: options"], 0.9, 0.9, 0.9)
    GameTooltip:Show()
end

function BeautifulAttune_OnCompartmentLeave()
    GameTooltip:Hide()
end
