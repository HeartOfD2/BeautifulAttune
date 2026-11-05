-- Package description of the single package BeautifulAttune (written by the release build).
local _, ns = ...

ns.PACKAGE = {
    title = "BeautifulAttune",
    db = "BeautifulAttuneDB",
    slash = { "/beautifulattune" },
    color = "0cd29d",
    pluginLabel = "Attune Skin",
    defaultTheme = "midnight",
    packs = {
        { key = "Attune", addon = "BeautifulAttune_Skin", title = "Attune", requires = "Attune",
          imports = { addon = "BeautifulAttune", db = "BeautifulAttuneDB" } },
    },
    legacyPack = nil,
    -- the BeautifulSkins suite ships the same packs: when it runs them, this package steps back
    yieldTo = "BeautifulSkins",
}
