--[[ Umlauts & special characters list
	ä --> \195\164
	Ä --> \195\132
	ö --> \195\182
	Ö --> \195\150
	ü --> \195\188
	Ü --> \195\156
	ß --> \195\159

   à : \195\160    è : \195\168    ì : \195\172    ò : \195\178    ù : \195\185
   á : \195\161    é : \195\169    í : \195\173    ó : \195\179    ú : \195\186
   â : \195\162    ê : \195\170    î : \195\174    ô : \195\180    û : \195\187
      	 		   ë : \195\171    ï : \195\175
   æ : \195\166    ø : \195\184
   ç : \195\167                                    œ : \197\147
   Ä : \195\132    Ö : \195\150    Ü : \195\156    ß : \195\159
   ä : \195\164    ö : \195\182    ü : \195\188
   ã : \195\163    õ : \195\181  				   \195\177 : \195\177
]]
local FCOCF = FCOCF
FCOCF.localizationVars.localizationAll = {
	--English
    [1] = {
		-- Options menu
        ["options_description"] 				 = "FCO CraftFilter - filter your crafting station contents",
		["options_header1"] 			 		 = "General settings",
    	["options_language"] 					 = "Language",
		["options_language_tooltip"] 			 = "Choose the language",
		["options_language_use_client"] 		 = "Use client language",
		["options_language_use_client_tooltip"]  = "Always let the addon use the game client's language.",
		["options_language_dropdown_selection1"] = "English",
		["options_language_dropdown_selection2"] = "German",
		["options_language_dropdown_selection3"] = "French",
		["options_language_dropdown_selection4"] = "Spanish",
        ["options_language_dropdown_selection5"] = "Italian",
        ["options_language_dropdown_selection6"] = "Japanese",
        ["options_language_dropdown_selection7"] = "Russian",
		["options_language_description1"]		 = "CAUTION: Changing the language/save option will reload the user interface!",
        ["options_savedvariables"]				 = "Save settings",
        ["options_savedvariables_tooltip"]       = "Save the addon settings for all your characters of your account, or single for each character",
        ["options_savedVariables_dropdown_selection1"] = "Each character",
        ["options_savedVariables_dropdown_selection2"] = "Account wide",
        --Options crafting stations
        ["options_header_crafting_stations"]     = "Crafting stations",
        ["options_enable_medium_filter"]         = "Enable 'show only bank' filter",
        ["options_enable_medium_filter_tooltip"] = "Enable a third filter where you can only show the items located at your bank",
        ["options_header_research"] = GetString(SI_RESEARCH),
        ["options_enable_button_only_currently_researched"] = "Show 'Only researched' button",
        ["options_enable_button_only_currently_researched_tooltip"] = "Show a filter button at the research panel of crafting tables to switch between 'Currently researched' and 'All' items",
        ["button_FCO_show_all_researched_tooltip"] = "Currently: Show all researchable items",
        ["button_FCO_currently_show_only_researched_tooltip"] = "Currently: Show at the moment researched items",
        ["info_no_items_researched"] = "Currently nothing is researched",

        --Chat commands
        ["chatcommands_info"]					 = "|c00FF00FCO|cFFFF00CraftFilter|cFFFFFF",
        --Buttons
        ["button_FCO_hide_bank_tooltip"]         = "Next: Hide bank items",
        ["button_FCO_show_all_tooltip"]         = "Next: Show all items",
        ["button_FCO_show_only_bank_tooltip"]    = "Next: Only show bank items",
        ["button_FCO_currently_hide_bank_tooltip"]         = "Currently: Hiding bank items",
        ["button_FCO_currently_show_all_tooltip"]         = "Currently: Showing all items",
        ["button_FCO_currently_show_only_bank_tooltip"]    = "Currently: Only showing bank items",

        ["button_FCO_hide_craftbag_tooltip"]         = "Next: Hide Craftbag items",
        ["button_FCO_show_only_craftbag_tooltip"]    = "Next: Only show Craftbag items",
        ["button_FCO_currently_hide_craftbag_tooltip"]         = "Aktuell: Hiding Craftbag items",
        ["button_FCO_currently_show_only_craftbag_tooltip"]    = "Aktuell: Only showing Craftbag items",
    },
--==============================================================================
	--German / Deutsch
    [2] = {
		-- Options menu
        ["options_description"] 				 = "FCO CraftFilter - Filter deine Items an Handwerksstationen",
		["options_header1"] 			 		 = "Generelle Einstellungen",
    	["options_language"] 					 = "Sprache",
		["options_language_tooltip"] 			 = "Wählen Sie die Sprache aus",
		["options_language_use_client"] 		 = "Benutze Spiel Sprache",
		["options_language_use_client_tooltip"]  = "Lässt das AddOn immer die Sprache des Spiel Clients nutzen.",
		["options_language_dropdown_selection1"] = "Englisch",
		["options_language_dropdown_selection2"] = "Deutsch",
		["options_language_dropdown_selection3"] = "Französisch",
		["options_language_dropdown_selection4"] = "Spanisch",
        ["options_language_dropdown_selection5"] = "Italienisch",
        ["options_language_dropdown_selection6"] = "Japanisch",
        ["options_language_dropdown_selection7"] = "Russisch",
		["options_language_description1"]		 = "ACHTUNG: Veränderungen der Sprache/der Speicherart laden die Benutzeroberfläche neu!",
        ["options_savedvariables"]				 = "Einstellungen speichern",
        ["options_savedvariables_tooltip"]       = "Die Einstellungen dieses Addons werden für alle Charactere Ihres Accounts, oder für jeden Character einzeln gespeichert",
        ["options_savedVariables_dropdown_selection1"] = "Jeder Charakter",
        ["options_savedVariables_dropdown_selection2"] = "Ganzer Account",
        --Options crafting stations
        ["options_header_crafting_stations"]     = "Handwerksstationen",
        ["options_enable_medium_filter"]         = "Aktiviere 'nur Bank' Filter",
        ["options_enable_medium_filter_tooltip"] = "Aktiviert einen dritten Filter, welcher nur die Gegenstände anzeigt, die auf der Bank liegen",
        ["options_header_research"] = GetString(SI_RESEARCH),
        ["options_enable_button_only_currently_researched"] = "Zeige 'Nur gerade analysierte' Knopf",
        ["options_enable_button_only_currently_researched_tooltip"] = "Zeige einen Filter Knopf am Analyse Panel mit welchem du zwischen den 'Gerade analysierten' und 'Allen' Gegenständen umschalten kannst",
        ["button_FCO_show_all_researched_tooltip"] = "Aktuell: Zeige alle Analyse Gegenstände",
        ["button_FCO_currently_show_only_researched_tooltip"] = "Aktuell: Zeige nur gerade analysierte Gegenstände",
        ["info_no_items_researched"] = "Zur Zeit wird nichts analysiert",

        --Chat commands
        ["chatcommands_info"]					 = "|c00FF00FCO|cFFFF00CraftFilter|cFFFFFF",
        ["chatcommands_help"]					 = "|cFFFFFF'hilfe' / 'liste'|cFFFF00: Zeigt diese Information zum Addon an",
        --Buttons
        ["button_FCO_hide_bank_tooltip"]         = "N\195\164chste: Verstecke Bank Gegenstände",
        ["button_FCO_show_all_tooltip"]         = "N\195\164chste: Zeige alle Gegenstände an",
        ["button_FCO_show_only_bank_tooltip"]    = "N\195\164chste: Zeige NUR Bank Gegenstände an",
        ["button_FCO_currently_hide_bank_tooltip"]         = "Aktuell: Versteckt Bank Gegenstände",
        ["button_FCO_currently_show_all_tooltip"]         = "Aktuell: Zeigt alle Gegenstände",
        ["button_FCO_currently_show_only_bank_tooltip"]    = "Aktuell: Zeigt NUR Bank Gegenstände",
        ["button_FCO_hide_craftbag_tooltip"]         = "N\195\164chste: Verstecke Handwerksbeutel Gegenstände",
        ["button_FCO_show_only_craftbag_tooltip"]    = "N\195\164chste: Zeige NUR Handwerksbeutel Gegenstände an",
        ["button_FCO_currently_hide_craftbag_tooltip"]         = "Aktuell: Versteckt Handwerksbeutel Gegenstände",
        ["button_FCO_currently_show_only_craftbag_tooltip"]    = "Aktuell: Zeigt NUR Handwerksbeutel Gegenstände",
    },
--==============================================================================
--French / Französisch
	[3] = {
		-- Options menu
		["options_description"] 						 = "FCO CraftFilter",
		["options_header1"] 							 = "Général",
		["options_language"]							 = "Langue",
		["options_language_tooltip"]					 = "Choisir la langue",
		["options_language_use_client"] 		 		 = "Utilisez le langage client",
		["options_language_use_client_tooltip"]  		 = "Toujours laisser l'addon utiliser la langue du client de jeu.",
		["options_language_dropdown_selection1"]		 = "Anglais",
		["options_language_dropdown_selection2"]		 = "Allemand",
		["options_language_dropdown_selection3"]		 = "Français",
		["options_language_dropdown_selection4"] 		 = "Espagnol",
        ["options_language_dropdown_selection5"]	 	 = "Italien",
        ["options_language_dropdown_selection6"]         = "Japonais",
        ["options_language_dropdown_selection7"] 		 = "Russe",
		["options_language_description1"]				 = "ATTENTION : Modifier un de ces réglages provoquera un chargement",
		["options_savedvariables"]						 = "Sauvegarder",
		["options_savedvariables_tooltip"] 				 = "Sauvegarder les données de l'addon pour tous les personages du compte, ou individuellement pour chaque personage",
		["options_savedVariables_dropdown_selection1"]	 = "Individuellement",
		["options_savedVariables_dropdown_selection2"]	 = "Compte",
        --Options crafting stations
        ["options_header_crafting_stations"]     = "Station d'artisanat",
        ["options_enable_medium_filter"]         = "Activer 'Seuls les objets en banque' filtre",
        ["options_enable_medium_filter_tooltip"] = "Activer un troisième filtre que vous pouvez afficher seul les objects en banque",
		--Chat commands
		["chatcommands_info"]	 				 = "|c00FF00FCO|cFFFF00CraftFilter|cFFFFFF",
		["chatcommands_help"]	 				 = "|cFFFFFF'aide' / 'lister'|cFFFF00: Affiche cette information à propos de l'addon",
        --Buttons
		["button_FCO_hide_bank_tooltip"]         = "Cliquez pour masquer les objets en banque",
        ["button_FCO_show_all_tooltip"]         = "Cliquez pour afficher les objets en banque",
        ["button_FCO_show_only_bank_tooltip"]    = "Cliquez pour afficher uniquement les objets en banque",
        ["button_FCO_currently_hide_bank_tooltip"]         = "Les objets en banque ne sont pas affichés",
        ["button_FCO_currently_show_all_tooltip"]         = "Les objets en banque sont affichés",
        ["button_FCO_currently_show_only_bank_tooltip"]    = "Seuls les objets en banque sont affichés",
	},
--==============================================================================
--Spanish
	[4] = {
        -- Options menu
        ["options_description"] 				 = "FCO CraftFilter - filter your crafting station contents",
		["options_header1"] 							 = "General",
		["options_language"]							 = "Idioma",
		["options_language_tooltip"]					 = "Elegir idioma",
		["options_language_use_client"] 		 		 = "Utilizar el idioma del cliente",
		["options_language_use_client_tooltip"]  		 = "Deje siempre que el addon de utilizar el idioma del cliente de juego.",
		["options_language_dropdown_selection1"]		 = "Inglés",
		["options_language_dropdown_selection2"]		 = "Alemán",
		["options_language_dropdown_selection3"]		 = "Francés",
		["options_language_dropdown_selection4"]		 = "Espa\195\177ol",
        ["options_language_dropdown_selection5"] 		 = "Italiano",
        ["options_language_dropdown_selection6"]         = "Japonés",
        ["options_language_dropdown_selection7"] 		 = "Ruso",
		["options_language_description1"]				 = "CUIDADO: Modificar uno de esos parámetros recargará la interfaz",
		["options_savedvariables"]						 = "Guardar",
		["options_savedvariables_tooltip"] 				 = "Guardar los parámetros del addon para toda la cuenta o individualmente para cada personaje",
		["options_savedVariables_dropdown_selection1"]	 = "Individualmente",
		["options_savedVariables_dropdown_selection2"]	 = "Cuenta",
        --Options crafting stations
        ["options_header_crafting_stations"]     = "Crafting stations",
        ["options_enable_medium_filter"]         = "Enable 'show only bank' filter",
        ["options_enable_medium_filter_tooltip"] = "Enable a third filter where you can only show the items located at your bank",
        --Chat commands
        ["chatcommands_info"]					 = "|c00FF00FCO|cFFFF00CraftFilter|cFFFFFF",
        --Buttons
        ["button_FCO_hide_bank_tooltip"]         = "Next: Hide bank items",
        ["button_FCO_show_all_tooltip"]         = "Next: Show bank items",
        ["button_FCO_show_only_bank_tooltip"]    = "Next: Only show bank items",
        ["button_FCO_currently_hide_bank_tooltip"]         = "Currently: Hiding bank items",
        ["button_FCO_currently_show_all_tooltip"]         = "Currently: Showing bank items",
        ["button_FCO_currently_show_only_bank_tooltip"]    = "Currently: Only showing bank items",
	},
--==============================================================================
    --Italian
    [5] = {
        -- Options menu
        ["options_description"] 				 = "FCO CraftFilter - filter your crafting station contents",
        ["options_header1"] 			 		 = "Impostazioni generali",
        ["options_language"] 					 = "Lingua",
        ["options_language_tooltip"] 			 = "Scegli la lingua",
		["options_language_use_client"] 		 		 = "Utilizzare la lingua del client",
		["options_language_use_client_tooltip"]  		 = "Lasciate sempre l'addon usare il linguaggio del client di gioco.",
        ["options_language_dropdown_selection1"] = "Inglese",
        ["options_language_dropdown_selection2"] = "Germano",
        ["options_language_dropdown_selection3"] = "Francese",
        ["options_language_dropdown_selection4"] = "Spagnolo",
        ["options_language_dropdown_selection5"] = "Italiano",
        ["options_language_dropdown_selection6"] = "Giapponese",
        ["options_language_dropdown_selection7"] = "Russo",
        ["options_language_description1"]		 = "ATTENZIONE: modifica della lingua opzione / salvare ricaricherà l'interfaccia utente!",
        ["options_reloadui"]					 = "ATTENZIONE: La modifica di questa opzione ricaricherà l'interfaccia utente!",
        ["options_savedvariables"]				 = "Salvare le impostazioni",
        ["options_savedvariables_tooltip"]       = "Salvare le impostazioni addon per tutti i tuoi personaggi del tuo account, o unico per ogni carattere",
        ["options_savedVariables_dropdown_selection1"] = "Ogni personaggio",
        ["options_savedVariables_dropdown_selection2"] = "Tutto acconto",
        --Options crafting stations
        ["options_header_crafting_stations"]     = "Crafting stations",
        ["options_enable_medium_filter"]         = "Enable 'show only bank' filter",
        ["options_enable_medium_filter_tooltip"] = "Enable a third filter where you can only show the items located at your bank",
        --Chat commands
        ["chatcommands_info"]					 = "|c00FF00FCO|cFFFF00CraftFilter|cFFFFFF",
        --Buttons
        ["button_FCO_hide_bank_tooltip"]         = "Next: Hide bank items",
        ["button_FCO_show_all_tooltip"]         = "Next: Show bank items",
        ["button_FCO_show_only_bank_tooltip"]    = "Next: Only show bank items",
        ["button_FCO_currently_hide_bank_tooltip"]         = "Currently: Hiding bank items",
        ["button_FCO_currently_show_all_tooltip"]         = "Currently: Showing bank items",
        ["button_FCO_currently_show_only_bank_tooltip"]    = "Currently: Only showing bank items",
    },
--==============================================================================
    --Japanese
    [6] = {
        -- Options menu
        ["options_description"] 				 = "FCO CraftFilter - クラフト台の内容をフィルタリングします",
        ["options_header1"] 			 		 = "一般設定",
        ["options_language"] 					 = "言語",
        ["options_language_tooltip"] 			 = "言語の選択",
		["options_language_use_client"] 		 = "クライアントの言語を使用する",
		["options_language_use_client_tooltip"]  = "アドオンが常にクライアントの言語を使用するようにします。",
        ["options_language_dropdown_selection1"] = "英語",
        ["options_language_dropdown_selection2"] = "ドイツ語",
        ["options_language_dropdown_selection3"] = "フランス語",
        ["options_language_dropdown_selection4"] = "スペイン語",
        ["options_language_dropdown_selection5"] = "イタリア語",
        ["options_language_dropdown_selection6"] = "日本語",
        ["options_language_dropdown_selection7"] = "ロシア",
        ["options_language_description1"]		 = "注意: 言語の変更/設定の保存時にはUIがリロードされます！",
        ["options_savedvariables"]				 = "設定の保存",
        ["options_savedvariables_tooltip"]       = "アドオンの設定をアカウントの全キャラクターまたはキャラクター毎に保存します",
        ["options_savedVariables_dropdown_selection1"] = "キャラクター毎",
        ["options_savedVariables_dropdown_selection2"] = "アカウント全体",
        --Options crafting stations
        ["options_header_crafting_stations"]     = "クラフト台",
        ["options_enable_medium_filter"]         = "「銀行のアイテムのみ表示」フィルタの有効化",
        ["options_enable_medium_filter_tooltip"] = "銀行のアイテムのみを表示する3つ目のフィルタを有効にします",
        --Chat commands
        ["chatcommands_info"]					 = "|c00FF00FCO|cFFFF00CraftFilter|cFFFFFF",
        --Buttons
        ["button_FCO_hide_bank_tooltip"]         = "次: 銀行アイテム非表示",
        ["button_FCO_show_all_tooltip"]         = "次: 銀行アイテム表示",
        ["button_FCO_show_only_bank_tooltip"]    = "次: 銀行アイテムのみ表示",
        ["button_FCO_currently_hide_bank_tooltip"]         = "現在: 銀行アイテム非表示",
        ["button_FCO_currently_show_all_tooltip"]         = "現在: 銀行アイテム表示",
        ["button_FCO_currently_show_only_bank_tooltip"]    = "現在: 銀行アイテムのみ表示",
    },
--==============================================================================
	--Russian
    [7] = {
        -- Options menu
        ["options_description"]                  = "FCO CraftFilter - фильтрует предметы в окне ремесленной станции",
        ["options_header1"]                      = "Основные настройки",
        ["options_language"]                     = "Язык",
        ["options_language_tooltip"]             = "Выбepитe язык",
		["options_language_use_client"]          = "Использовать язык клиента",
		["options_language_use_client_tooltip"]  = "Всегда использовать аддоном язык клиента игры.",
        ["options_language_dropdown_selection1"] = "Aнглийcкий",
        ["options_language_dropdown_selection2"] = "Нeмeцкий",
        ["options_language_dropdown_selection3"] = "Фpaнцузcкий",
        ["options_language_dropdown_selection4"] = "Иcпaнcкий",
        ["options_language_dropdown_selection5"] = "Итaльянcкий",
        ["options_language_dropdown_selection6"] = "Япoнcкий",
        ["options_language_dropdown_selection7"] = "Pуccкий",
        ["options_language_description1"]        = "ВНИМAНИE: Измeнeниe языкa/нacтpoeк coxpaнeния пpивeдeт к пepeзaгpузкe интepфeйca!",
        ["options_savedvariables"]               = "Нacтpoйки coxpaнeния",
        ["options_savedvariables_tooltip"]     = "Coxpaнять oбщиe нacтpoйки для вcex пepcoнaжeй aккaунтa или oтдeльныe для кaждoгo пepcoнaжa",
        ["options_savedVariables_dropdown_selection1"] = "Для кaждoгo пepcoнaжa",
        ["options_savedVariables_dropdown_selection2"] = "Oбщиe нa aккaунт",
        --Options crafting stations
        ["options_header_crafting_stations"]     = "Ремесленная станция",
        ["options_enable_medium_filter"]         = "Вкл. фильтр 'показ только из банка'",
        ["options_enable_medium_filter_tooltip"] = "Включает третий фильтр который позволит вам показывать только предметы расположенные в вашем банке",
        --Chat commands
        ["chatcommands_info"]                    = "|c00FF00FCO|cFFFF00CraftFilter|cFFFFFF",
        --Buttons
        ["button_FCO_hide_bank_tooltip"]         = "Следующий: Скрыть предметы из банка",
        ["button_FCO_show_all_tooltip"]         = "Следующий: Показать все предметы",
        ["button_FCO_show_only_bank_tooltip"]    = "Следующий: Показать предметы только из банка",
        ["button_FCO_currently_hide_bank_tooltip"]       = "Текущий: Предметы из банка скрыты",
        ["button_FCO_currently_show_all_tooltip"]       = "Текущий: Показаны все предметы",
        ["button_FCO_currently_show_only_bank_tooltip"]  = "Текущий: Показаны предметы только из банка",
    },
}
--Meta table trick to use english localization for german and french values, which are missing
local fco_cfloc = FCOCF.localizationVars.localizationAll
setmetatable(fco_cfloc[2], {__index = fco_cfloc[1]})
setmetatable(fco_cfloc[3], {__index = fco_cfloc[1]})
setmetatable(fco_cfloc[4], {__index = fco_cfloc[1]})
setmetatable(fco_cfloc[5], {__index = fco_cfloc[1]})
setmetatable(fco_cfloc[6], {__index = fco_cfloc[1]})
setmetatable(fco_cfloc[7], {__index = fco_cfloc[1]})
