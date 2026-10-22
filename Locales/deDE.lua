-- German translations. Keys are the English source texts.
local _, ns = ...
ns.locales.deDE = {
    -- core and slash command
    ["Attune %s has not been tested with this version. If something looks wrong: /battune diag"] =
        "Attune %s wurde mit dieser Version nicht getestet. Falls etwas falsch aussieht: /battune diag",
    ["Attune is not loaded or too old. /battune diag shows details."] =
        "Attune ist nicht geladen oder zu alt. /battune diag zeigt Einzelheiten.",
    ["Commands:"] = "Befehle:",
    ["/battune - options"] = "/battune – Optionen",
    ["/battune attune - open or close the Attune window"] = "/battune attune – Attune-Fenster öffnen oder schließen",
    ["/battune diag - versions, Attune parts and modules"] = "/battune diag – Versionen, Attune-Teile und Module",
    ["/battune reset - reset the options"] = "/battune reset – Optionen zurücksetzen",
    ["Unknown command."] = "Unbekannter Befehl.",
    ["Left-click: open or close Attune"] = "Linksklick: Attune öffnen oder schließen",
    ["Right-click: options"] = "Rechtsklick: Optionen",
    -- diagnostics
    ["%s %s · Attune %s · tested with: %s %s"] = "%s %s · Attune %s · getestet mit: %s %s",
    ["ok"] = "ok",
    ["not created yet"] = "noch nicht erzeugt",
    ["needs the list view"] = "braucht die Listenansicht",
    ["waiting for the Attune window"] = "wartet auf das Attune-Fenster",
    ["missing"] = "fehlt",
    ["Modules:"] = "Module:",
    ["not checked yet"] = "noch nicht geprüft",
    ["off (setting)"] = "aus (Einstellung)",
    ["off (Attune part missing)"] = "aus (Attune-Teil fehlt)",
    ["on"] = "an",
    ["off (errors)"] = "aus (Fehler)",
    ["errors: %d, first: %s"] = "Fehler: %d, erster: %s",
    ["Unknown status colours: none"] = "Unbekannte Statusfarben: keine",
    ["Unknown status colours:"] = "Unbekannte Statusfarben:",
    -- UI kit
    ["Close"] = "Schließen",
    ["Sure?"] = "Sicher?",
    ["The color picker is not available in this client."] = "Die Farbauswahl ist in diesem Client nicht verfügbar.",
    -- themes
    ["Standard"] = "Standard",
    ["Classic"] = "Klassisch",
    ["Parchment"] = "Pergament",
    ["Midnight"] = "Mitternacht",
    ["Frost"] = "Frost",
    ["Light"] = "Hell",
    ["Theme default"] = "Theme-Standard",
    ["EllesmereUI accent"] = "EllesmereUI-Akzent",
    ["Class color"] = "Klassenfarbe",
    ["Own color"] = "Eigene Farbe",
    ["Modern"] = "Modern",
    ["Attune classic"] = "Attune klassisch",
    ["EllesmereUI font"] = "EllesmereUI-Schrift",
    ["Game font"] = "Spielschrift",
    -- options window
    ["Settings"] = "Einstellungen",
    ["Appearance"] = "Aussehen",
    ["Info"] = "Info",
    ["APPEARANCE"] = "AUSSEHEN",
    ["LANGUAGE"] = "SPRACHE",
    ["VERSIONS"] = "VERSIONEN",
    ["MODULES"] = "MODULE",
    ["Theme"] = "Theme",
    ["Look of the BeautifulAttune windows and of Attune's window."] =
        "Aussehen der BeautifulAttune-Fenster und des Attune-Fensters.",
    ["Font"] = "Schrift",
    ["Font of all BeautifulAttune texts. \"EllesmereUI font\" follows the font set in EllesmereUI (only while it is installed and enabled)."] =
        "Schrift aller BeautifulAttune-Texte. „EllesmereUI-Schrift“ folgt der in EllesmereUI eingestellten Schrift (nur wenn es installiert und aktiv ist).",
    ["The quick brown fox jumps over the lazy dog. 0123456789"] =
        "Zwölf Boxkämpfer jagen Viktor quer über den großen Sylter Deich. 0123456789",
    ["Accent color"] = "Akzentfarbe",
    ["Highlight color of every theme: buttons, switches, selections and the search."] =
        "Hervorhebungsfarbe aller Themes: Schaltflächen, Schalter, Auswahl und Suche.",
    ["Pick any color"] = "Beliebige Farbe wählen",
    ["Click a color to use it as the accent."] = "Klicke eine Farbe an, um sie als Akzent zu nutzen.",
    ["Opens the color picker. The chosen color becomes the accent."] =
        "Öffnet die Farbauswahl. Die gewählte Farbe wird zum Akzent.",
    ["Status colors"] = "Statusfarben",
    ["Colors of done, ready and locked steps. \"Attune classic\" keeps Attune's own tones."] =
        "Farben erledigter, bereiter und gesperrter Schritte. „Attune klassisch“ behält Attunes eigene Töne.",
    ["Language"] = "Sprache",
    ["Automatic"] = "Automatisch",
    ["Automatic uses the EllesmereUI language when it is installed, else the language of the game."] =
        "Automatisch nutzt die EllesmereUI-Sprache, wenn es installiert ist, sonst die Sprache des Spiels.",
    ["The language changes after a reload (/reload)."] = "Die Sprache ändert sich nach einem Neuladen (/reload).",
    ["Language changes take effect after a reload."] = "Sprachänderungen gelten nach einem Neuladen.",
    ["Reload now"] = "Jetzt neu laden",
    ["Attune %s · tested with: %s"] = "Attune %s · getestet mit: %s",
    ["EllesmereUI found: accent, font and language are followed."] =
        "EllesmereUI gefunden: Akzent, Schrift und Sprache werden übernommen.",
    ["Print the diagnostics to the chat"] = "Diagnose in den Chat ausgeben",
    ["Same as /battune diag."] = "Wie /battune diag.",
    -- window skin
    ["WINDOW"] = "FENSTER",
    ["Window scale"] = "Fensterskalierung",
    ["Scales Attune's whole window between 70 % and 130 %."] = "Skaliert das ganze Attune-Fenster zwischen 70 % und 130 %.",
    ["Hide the icon view"] = "Symbolansicht ausblenden",
    ["Always shows Attune's list and hides its switch between list and icons."] =
        "Zeigt immer Attunes Liste und blendet den Umschalter zwischen Liste und Symbolen aus.",
    ["BeautifulAttune options"] = "BeautifulAttune-Optionen",
    ["Attunes"] = "Einstimmungen",
    ["Results"] = "Ergebnisse",
    ["Survey"] = "Umfrage",
    -- chain skin
    ["Accept"] = "Annehmen",
    ["Hand in"] = "Abgeben",
    ["Quest"] = "Quest",
    ["Item"] = "Gegenstand",
    ["Required level"] = "Benötigtes Level",
    ["Reputation"] = "Ruf",
    ["Attunement or key"] = "Zugang oder Schlüssel",
    ["Kill"] = "Töten",
    ["Interact"] = "Interagieren",
    ["Click"] = "Anklicken",
    ["Alliance"] = "Allianz",
    ["Horde"] = "Horde",
    ["Both factions"] = "Beide Fraktionen",
    ["Level %s"] = "Level %s",
    ["%d players"] = "%d Spieler",
    ["%d of %d steps done"] = "%d von %d Schritten erledigt",
    ["CHAIN"] = "KETTE",
    ["Line weight"] = "Linienstärke",
    ["Fine"] = "Fein",
    ["Normal"] = "Normal",
    ["Strong"] = "Kräftig",
    ["Thickness of the connectors between the steps (2, 3 or 4 pixels at 100 %)."] =
        "Stärke der Verbindungslinien zwischen den Schritten (2, 3 oder 4 Pixel bei 100 %).",
    ["Dungeon picture"] = "Dungeon-Bild",
    ["Banner"] = "Banner",
    ["Background"] = "Hintergrund",
    ["Off"] = "Aus",
    ["Banner above the chain, a faint background as in Attune, or no picture."] =
        "Banner über der Kette, dezenter Hintergrund wie bei Attune oder kein Bild.",
    -- zoom
    ["Zoom above 100 %"] = "Über 100 % zoomen",
    ["Lets the zoom bar go up to 150 %. Attune itself stops at 100 %."] =
        "Erlaubt der Zoomleiste bis 150 %. Attune selbst endet bei 100 %.",
    ["Zoom"] = "Zoom",
    ["Zoom out"] = "Verkleinern",
    ["Zoom in"] = "Vergrößern",
    ["Fit the whole chain"] = "Ganze Kette einpassen",
    ["Click: 100 %. Ctrl+mouse wheel over the chain: zoom."] = "Klick: 100 %. Strg+Mausrad über der Kette: zoomen.",
    -- details
    ["Quest rewards"] = "Questbelohnungen",
    -- search
    ["Search: attunement, quest, item …"] = "Suchen: Zugang, Quest, Gegenstand …",
    ["Clear search"] = "Suche leeren",
    ["All"] = "Alles",
    ["Attunements"] = "Zugänge",
    ["Quests"] = "Quests",
    ["NPCs"] = "NPCs",
    ["Items"] = "Gegenstände",
    ["Zones"] = "Gebiete",
    ["Attunements & dungeons"] = "Zugänge & Dungeons",
    ["Other steps"] = "Sonstige Schritte",
    ["Zone"] = "Gebiet",
    ["%d steps"] = "%d Schritte",
    ["Only open"] = "Nur offene",
    ["%d results"] = "%d Treffer",
    ["No results"] = "Keine Treffer",
    ["+ %d more …"] = "+ %d weitere …",
    ["This entry is not in Attune's list."] = "Dieser Eintrag steht nicht in Attunes Liste.",
    ["Attune's window is not available."] = "Attunes Fenster ist nicht verfügbar.",
    -- options, integration, minimap (step 10)
    ["Look, search, modules and information."] = "Aussehen, Suche, Module und Infos.",
    ["Search & zoom"] = "Suche & Zoom",
    ["Modules"] = "Module",
    ["SEARCH"] = "SUCHE",
    ["ZOOM"] = "ZOOM",
    ["Mark matches in the chain"] = "Treffer in der Kette markieren",
    ["While you search, matching cards of the open chain get an accent frame and the others are dimmed."] =
        "Während einer Suche bekommen passende Karten der offenen Kette einen Rahmen in der Akzentfarbe, die übrigen werden abgedunkelt.",
    ["Only open steps"] = "Nur offene Schritte",
    ["Hides what is already done from the results. Same as the switch in the result list."] =
        "Blendet Erledigtes in den Treffern aus. Wie der Schalter in der Ergebnisliste.",
    ["Filter"] = "Filter",
    ["Which kind of entries the search shows. Same as the chips in the result list."] =
        "Welche Art von Einträgen die Suche zeigt. Wie die Filter-Chips in der Ergebnisliste.",
    ["Click into the search field above the list, or type and use the arrow keys, Enter and Esc."] =
        "Ins Suchfeld über der Liste klicken und tippen; Pfeiltasten, Eingabe und Esc steuern die Treffer.",
    ["The zoom bar sits at the top right of the chain: minus, percent, plus and \"fit the whole chain\". Ctrl + mouse wheel over the chain zooms as well (10 % steps, 5 % below 50 %)."] =
        "Die Zoomleiste steht oben rechts über der Kette: Minus, Prozent, Plus und „Ganze Kette einpassen“. Strg + Mausrad über der Kette zoomt ebenfalls (10-%-Schritte, unter 50 % 5 %).",
    ["SKIN MODULES"] = "SKIN-MODULE",
    ["Each part of the skin can be switched off. Changes take effect after a reload; Attune itself keeps working either way."] =
        "Jeder Teil des Skins lässt sich abschalten. Änderungen wirken nach dem Neuladen; Attune selbst funktioniert in jedem Fall weiter.",
    ["Window"] = "Fenster",
    ["Flat frame, header with the view switch, status bar and survey menu. The search needs it."] =
        "Flacher Rahmen, Kopfzeile mit Ansichtsumschalter, Statusleiste und Umfrage-Menü. Die Suche braucht dieses Modul.",
    ["List"] = "Liste",
    ["Rows of Attune's list: sections, icons, levels and progress."] =
        "Zeilen der Attune-Liste: Abschnitte, Symbole, Stufen und Fortschritt.",
    ["Chain"] = "Kette",
    ["Cards, connectors, the head card and the dungeon picture."] =
        "Karten, Verbindungslinien, Kopfkarte und Dungeon-Bild.",
    ["Zoom bar"] = "Zoomleiste",
    ["Zoom bar, fit button and Ctrl + mouse wheel; zoom from 10 % to 150 %."] =
        "Zoomleiste, Einpassen-Knopf und Strg + Mausrad; Zoom von 10 % bis 150 %.",
    ["Search"] = "Suche",
    ["Search field above the list with filters, result list and jump to the card."] =
        "Suchfeld über der Liste mit Filtern, Ergebnisliste und Sprung zur Karte.",
    ["Quest details"] = "Quest-Details",
    ["Quest detail panel, map, rewards and the quest giver hint."] =
        "Quest-Detailpanel, Karte, Belohnungen und der Quest-Geber-Hinweis.",
    ["The results table, its choices and the level slider."] =
        "Die Ergebnistabelle, ihre Auswahlkreise und der Stufenregler.",
    ["GENERAL"] = "ALLGEMEIN",
    ["Show the minimap button"] = "Minikarten-Knopf anzeigen",
    ["Left-click opens or closes Attune, right-click the options. Drag it to move it along the minimap."] =
        "Linksklick öffnet oder schließt Attune, Rechtsklick die Optionen. Ziehen verschiebt ihn am Rand der Minikarte.",
    ["Version notice"] = "Versionshinweis",
    ["One chat line per session when the installed Attune version has not been tested with BeautifulAttune."] =
        "Eine Chatzeile pro Sitzung, wenn die installierte Attune-Version nicht mit BeautifulAttune getestet ist.",
    ["Integrate into EllesmereUI"] = "In EllesmereUI einbinden",
    ["The EllesmereUI integration changes after a reload (/reload)."] =
        "Die EllesmereUI-Einbindung ändert sich nach dem Neuladen (/reload).",
    ["Adds the section \"Attune Skin\" to the EllesmereUI options window; the gear and /battune open it there. Takes effect after a reload."] =
        "Fügt dem EllesmereUI-Optionsfenster den Abschnitt „Attune-Skin“ hinzu; Zahnrad und /battune öffnen dann dort. Wirkt nach dem Neuladen.",
    ["RESET"] = "ZURÜCKSETZEN",
    ["Reset all options"] = "Alle Optionen zurücksetzen",
    ["Every BeautifulAttune option back to its default, then the interface reloads. Asks first."] =
        "Setzt jede BeautifulAttune-Option auf den Standard zurück, danach lädt die Oberfläche neu. Fragt vorher nach.",
    ["Reset all BeautifulAttune options to their defaults? The interface reloads."] =
        "Alle BeautifulAttune-Optionen auf den Standard zurücksetzen? Die Oberfläche wird neu geladen.",
    ["Repeat within 10 seconds to reset all options (the interface reloads)."] =
        "Innerhalb von 10 Sekunden wiederholen, um alle Optionen zurückzusetzen (die Oberfläche wird neu geladen).",
    ["Yes"] = "Ja",
    ["No"] = "Nein",
    ["COMMANDS"] = "BEFEHLE",
    ["Open in EllesmereUI"] = "In EllesmereUI öffnen",
    ["The same pages in the EllesmereUI options window (/battune eui)."] =
        "Dieselben Seiten im EllesmereUI-Optionsfenster (/battune eui).",
    ["Attune Skin"] = "Attune-Skin",
    ["EllesmereUI is missing or too old (no plugin API)."] = "EllesmereUI fehlt oder ist zu alt (keine Plugin-Schnittstelle).",
    ["EllesmereUI is not loaded. /battune options opens the BeautifulAttune window."] =
        "EllesmereUI ist nicht geladen. /battune options öffnet das BeautifulAttune-Fenster.",
    ["The EllesmereUI section is not active (%s). Try /reload."] = "Der EllesmereUI-Abschnitt ist nicht aktiv (%s). Versuche /reload.",
    ["The EllesmereUI integration is off. Turn it on under Modules, then /reload."] =
        "Die EllesmereUI-Einbindung ist aus. Unter „Module“ einschalten, dann /reload.",
    ["The EllesmereUI window cannot be opened in combat. /battune options works."] =
        "Das EllesmereUI-Fenster lässt sich im Kampf nicht öffnen. /battune options funktioniert.",
    ["/battune options - the BeautifulAttune options window"] = "/battune options – BeautifulAttune-Optionsfenster",
    ["/battune eui - the options in EllesmereUI"] = "/battune eui – die Optionen in EllesmereUI",
    ["/battune minimap - show or hide the minimap button"] = "/battune minimap – Minikarten-Knopf ein- oder ausblenden",
    ["Drag: move along the minimap"] = "Ziehen: am Rand der Minikarte verschieben",
    ["Minimap button hidden. /battune minimap shows it again."] = "Minikarten-Knopf ausgeblendet. /battune minimap zeigt ihn wieder.",
    ["Minimap button shown."] = "Minikarten-Knopf eingeblendet.",
    ["Font of all BeautifulAttune texts."] = "Schrift aller BeautifulAttune-Texte.",
    ["Automatic uses the language of the game."] = "Automatisch nutzt die Sprache des Spiels.",
}
