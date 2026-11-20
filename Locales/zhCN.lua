-- Simplified Chinese texts of the host. Keys are the English source texts (Locales\enUS.lua). Packs keep their own
-- tables and fall back to this one for shared words.
local _, ns = ...

ns.locales.zhCN = {
    ["%s - options"] = "%s - 选项",
    ["%s eui - the options in EllesmereUI"] = "%s eui - EllesmereUI 中的选项",
    ["%s help lists all commands."] = "%s help 列出所有命令。",
    ["%s minimap - show or hide the minimap button"] = "%s minimap - 显示或隐藏小地图按钮",
    ["%s options - our own options window"] = "%s options - 打开内置选项窗口",
    ["%s reset - reset look and language"] = "%s reset - 重置外观和语言",
    ["%s status - state of every skin"] = "%s status - 查看各皮肤状态",
    ["%s: the former addon %s is still active. Switch it off in the addon list and /reload; its settings are taken over."] =
        "%s：旧版插件 %s 仍在启用。请在插件列表中关闭它并执行 /reload；其设置已被接管。",
    ["Accent"] = "强调色",
    ["Accent as text"] = "强调文本色",
    ["Accent color"] = "强调色",
    ["active"] = "已启用",
    ["addon not installed"] = "插件未安装",
    ["Adds our section to the EllesmereUI options window; the slash command and the minimap button open it there. Off: our own window. Takes effect after a reload."] =
        "将本插件设置项添加到 EllesmereUI 选项窗口中；斜杠命令和小地图按钮都会打开该页面。关闭则使用内置窗口，重载界面后生效。",
    ["All options are in our own window (or in the EllesmereUI options when the integration is on). Command: %s"] =
        "所有选项均在内置窗口中（启用集成后可在 EllesmereUI 选项中查看）。命令：%s",
    ["APPEARANCE"] = "外观",
    ["Appearance"] = "外观",
    ["Attune classic"] = "Attune 经典",
    ["Automatic"] = "自动",
    ["Automatic uses the EllesmereUI language when it is installed, else the language of the game."] =
        "自动模式下优先使用 EllesmereUI 的语言（如已安装），否则跟随游戏客户端语言。",
    ["Automatic uses the language of the game."] = "自动模式下跟随游戏客户端语言。",
    ["Borders"] = "边框",
    ["Buttons"] = "按钮",
    ["Class color"] = "职业颜色",
    ["Classic"] = "经典",
    ["Click a color to use it as the accent."] = "点击颜色将其设为强调色。",
    ["Close"] = "关闭",
    ["Code ready: Ctrl+C copies it. Import pastes it on another account or for a friend."] =
        "代码已生成：按 Ctrl+C 复制。在另一个账号或好友处点击“导入”并粘贴即可使用。",
    ["COLORS"] = "颜色",
    ["COMMANDS"] = "命令",
    ["Commands:"] = "命令：",
    ["CONTRAST"] = "对比度",
    ["Copies the colors of the theme in use into a new own theme and switches to it."] =
        "将当前主题的颜色复制为新的自定义主题并立即切换过去。",
    ["Dark"] = "深色",
    ["Dark or light: decides how hover and tracks are shaded."] =
        "深色或浅色：决定悬停高亮与轨道底色的明暗风格。",
    ["Delete"] = "删除",
    ["Drag: move along the minimap"] = "拖动：沿小地图边缘移动",
    ["Each pack skins one addon or a group of addons. A pack whose addon is not installed stays asleep. Changes take effect after a reload."] =
        "每个皮肤包美化一个或一组插件。对应插件未安装时皮肤包保持休眠。更改将在重载界面后生效。",
    ["EllesmereUI accent"] = "EllesmereUI 强调色",
    ["EllesmereUI font"] = "EllesmereUI 字体",
    ["EllesmereUI found: accent, font and language can follow it."] =
        "检测到 EllesmereUI：强调色、字体和语言均可跟随其设置。",
    ["EllesmereUI is missing or too old (no plugin API)."] =
        "未安装 EllesmereUI 或版本过旧（缺少插件接口）。",
    ["EllesmereUI is not loaded. %s options opens our own window."] =
        "EllesmereUI 未加载。%s options 将打开内置窗口。",
    ["EllesmereUI not found: own window and own look."] =
        "未检测到 EllesmereUI：使用内置窗口与独立外观。",
    ["Ember"] = "余烬",
    ["Emerald"] = "翡翠",
    ["Export"] = "导出",
    ["failed"] = "失败",
    ["Font"] = "字体",
    ["Font of all our texts."] = "所有界面文本使用的字体。",
    ["Font of all our texts. \"EllesmereUI font\" follows the font set in EllesmereUI (only while it is installed and enabled)."] =
        "所有界面文本使用的字体。“EllesmereUI 字体”会跟随 EllesmereUI 的字体设置（仅在安装并启用时有效）。",
    ["Frost"] = "冰霜",
    ["Game font"] = "游戏默认字体",
    ["GearQuest, SkillUp, Whisper, Waypoint"] = "GearQuest, SkillUp, Whisper, Waypoint",
    ["General"] = "常规",
    ["good"] = "良好",
    ["Graphite"] = "石墨",
    ["Header area"] = "顶部区域",
    ["Headings"] = "标题",
    ["Headings on the header area"] = "顶部区域的标题文本",
    ["High contrast"] = "高对比度",
    ["Highlight color of every theme and of every skin: headings, lines, arrows, buttons and switches."] =
        "所有主题与皮肤的高亮色：用于标题、连线、箭头、按钮和开关。",
    ["Import"] = "导入",
    ["Imported as a new own theme."] = "已导入为新的自定义主题。",
    ["Info"] = "信息",
    ["Input fields"] = "输入框",
    ["Integrate into EllesmereUI"] = "集成到 EllesmereUI",
    ["INTEGRATION"] = "集成",
    ["Kind"] = "类型",
    ["Language"] = "语言",
    ["LANGUAGE"] = "语言",
    ["Left-click opens the options, right-click the quick actions. Drag it to move it along the minimap."] =
        "左键打开选项，右键打开快捷菜单。拖动可沿小地图边缘移动位置。",
    ["Left-click: options"] = "左键：选项",
    ["Light"] = "浅色",
    ["Look of our own windows and of the skinned windows that follow a theme (Attune)."] =
        "内置窗口以及跟随主题的美化窗口（Attune）的整体外观。",
    ["Look, language, packs and information."] = "外观、语言、皮肤包与信息。",
    ["Make your own theme from any theme, change every color and share it as a code. The theme you edit is in use, so every window shows the change at once."] =
        "可基于任意主题创建自定义主题、修改每种颜色并导出代码分享。正在编辑的主题会实时生效。",
    ["Midnight"] = "午夜",
    ["Minimap button hidden. %s minimap shows it again."] =
        "小地图按钮已隐藏。输入 %s minimap 可重新显示。",
    ["Minimap button shown."] = "小地图按钮已显示。",
    ["Modern"] = "现代",
    ["Name"] = "名称",
    ["New from the current theme"] = "基于当前主题新建",
    ["No"] = "否",
    ["No own theme yet. \"New from the current theme\" copies the theme in use; then change any color."] =
        "还没有自定义主题。点击“基于当前主题新建”会复制当前主题，随后可自由调整颜色。",
    ["Nord"] = "北欧",
    ["not part of this installation"] = "未包含在当前安装中",
    ["off"] = "关闭",
    ["Open in EllesmereUI"] = "在 EllesmereUI 中打开",
    ["Open the options"] = "打开选项",
    ["Opens the color picker. The chosen color becomes the accent."] =
        "打开拾色器，所选颜色将作为强调色。",
    ["Options"] = "选项",
    ["Own color"] = "自定义颜色",
    ["Own theme"] = "自定义主题",
    ["OWN THEMES"] = "自定义主题",
    ["Parchment"] = "羊皮纸",
    ["Paste a theme code here"] = "在此粘贴主题代码",
    ["Pick any color"] = "选择任意颜色",
    ["Print the state to the chat"] = "在聊天框输出状态",
    ["Reload now"] = "立即重载",
    ["Repeat within 10 seconds to confirm."] = "10 秒内再次操作以确认。",
    ["RESET"] = "重置",
    ["Reset look and language"] = "重置外观与语言",
    ["Reset the look, language and window of %s to the defaults? The interface reloads."] =
        "确定将 %s 的外观、语言和窗口位置重置为默认值吗？界面将会重载。",
    ["Right-click: quick actions"] = "右键：快捷操作",
    ["Rosé"] = "玫瑰",
    ["runs in BeautifulSkins"] = "正运行于 BeautifulSkins 中",
    ["Secondary text"] = "次要文本",
    ["Secondary text on the window"] = "窗口上的次要文本",
    ["SHARE"] = "分享",
    ["Show the minimap button"] = "显示小地图按钮",
    ["SKIN PACKS"] = "皮肤包",
    ["Standard"] = "标准",
    ["Sure?"] = "确定吗？",
    ["Takes effect after /reload."] = "执行 /reload 后生效。",
    ["Text"] = "文本",
    ["Text on buttons"] = "按钮文本",
    ["Text on the accent"] = "强调色背景上的文本",
    ["Text on the window"] = "窗口文本",
    ["Text should reach 4.5 : 1 to stay easy to read."] =
        "文本对比度建议达到 4.5 : 1 以保持清晰易读。",
    ["That is no theme code (it starts with BT1:)."] = "这不是有效的主题代码（应以 BT1: 开头）。",
    ["The code is damaged or incomplete."] = "代码已损坏或不完整。",
    ["The color picker is not available in this client."] =
        "当前客户端不支持拾色器。",
    ["The EllesmereUI integration changes after a reload (/reload)."] =
        "EllesmereUI 集成设置将在重载界面（/reload）后生效。",
    ["The EllesmereUI integration is off. Turn it on under General, then /reload."] =
        "EllesmereUI 集成当前已关闭。请在“常规”中开启后执行 /reload。",
    ["The EllesmereUI section is not active (%s). Try /reload."] =
        "EllesmereUI 设置页当前未激活（%s），请尝试执行 /reload。",
    ["The EllesmereUI window cannot be opened in combat. %s options works."] =
        "战斗中无法打开 EllesmereUI 窗口，可使用 %s options 打开。",
    ["the former addon is still active: switch it off and /reload"] =
        "旧版插件仍在启用：请将其关闭并执行 /reload",
    ["The language changes after a reload (/reload)."] =
        "语言更改将在重载界面（/reload）后生效。",
    ["The quick brown fox jumps over the lazy dog. 0123456789"] =
        "敏捷的棕色狐狸跳过懒狗。天地玄黄宇宙洪荒 0123456789",
    ["Theme"] = "主题",
    ["Theme default"] = "主题默认",
    ["Theme editor"] = "主题编辑器",
    ["Theme, font, accent, language and window position back to the defaults, then the interface reloads. The options of the skins stay."] =
        "将主题、字体、强调色、语言和窗口位置恢复为默认值并重载界面，各皮肤选项会保留。",
    ["too low"] = "过低",
    ["Unknown command."] = "未知命令。",
    ["Unofficial skins. Not affiliated with the authors of the skinned addons or of EllesmereUI."] =
        "非官方皮肤，与被美化插件或 EllesmereUI 的作者无关。",
    ["Used while the accent color is set to \"Theme default\"."] =
        "当强调色设为“主题默认”时生效。",
    ["VERSIONS"] = "版本",
    ["waiting"] = "等待中",
    ["Warning"] = "警告",
    ["Warning on buttons"] = "按钮警告色",
    ["Window"] = "窗口",
    ["Without EllesmereUI every option lives in this window. With EllesmereUI installed the same pages can also appear in its options window."] =
        "未安装 EllesmereUI 时所有选项均显示在此窗口中；安装后相同设置页也可显示在 EllesmereUI 选项窗口里。",
    ["Yes"] = "是",
}
