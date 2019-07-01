------------------------------------------------------------------
------------------------------------------------------------------
--FCOCraftFilter.lua
--Author: Baertram
--[[
Filter your crafting station items
]]
------------------------------------------------------------------
FCOCF = {}
local FCOCF = FCOCF

--Addon variables
FCOCF.addonVars = {}
FCOCF.addonVars.gAddonName					= "FCOCraftFilter"
FCOCF.addonVars.addonNameMenu				= "FCO CraftFilter"
FCOCF.addonVars.addonNameMenuDisplay		= "|c00FF00FCO |cFFFF00CraftFilter|r"
FCOCF.addonVars.addonAuthor 				= '|cFFFF00Baertram|r'
FCOCF.addonVars.addonVersion		   		= 0.10 -- Changing this will reset SavedVariables!
FCOCF.addonVars.addonVersionOptions 		= '0.2.6' -- version shown in the settings panel
FCOCF.addonVars.addonVersionOptionsNumber 	= 0.26
FCOCF.addonVars.addonSavedVariablesName		= "FCOCraftFilter_Settings"
FCOCF.addonVars.addonWebsite                = "http://www.esoui.com/downloads/info1104-FCOCraftFilter.html"
FCOCF.addonVars.gAddonLoaded				= false

--Create the filter object for addon libFilters 2.0
local libFilters = LibFilters3
if libFilters == nil and LibStub then libFilters = LibStub("LibFilters-3.0") end
--Initialize the libFilters filters
libFilters:InitializeLibFilters()
--Create the settings panel object of libAddonMenu 2.0
local LAM   = LibAddonMenu2
if LAM == nil and LibStub then LAM = LibStub('LibAddonMenu-2.0') end
--Loaded addons library
local LIBLA = LibLoadedAddons
if LIBLA == nil and LibStub then LIBLA = LibStub:GetLibrary("LibLoadedAddons") end

--Available languages
FCOCF.numVars = {}
FCOCF.numVars.languageCount = 7 --English, German, French, Spanish, Italian, Japanese, Russian
FCOCF.langVars = {}
FCOCF.langVars.languages = {}
--Build the languages array
for i=1, FCOCF.numVars.languageCount do
	FCOCF.langVars.languages[i] = true
end

--Array for all the variables
FCOCF.locVars = {}
--The last opened panel ID
FCOCF.locVars.gLastPanel        = nil
--The last opened crafting station type
FCOCF.locVars.gLastCraftingType = nil

--Uncolored "FCOCF" pre chat text for the chat output
FCOCF.locVars.preChatText = "FCO CraftFilter"
--Green colored "FCOCF" pre text for the chat output
FCOCF.locVars.preChatTextGreen = "|c22DD22"..FCOCF.locVars.preChatText.."|r "
--Red colored "FCOCF" pre text for the chat output
FCOCF.locVars.preChatTextRed = "|cDD2222"..FCOCF.locVars.preChatText.."|r "
--Blue colored "FCOCF" pre text for the chat output
FCOCF.locVars.preChatTextBlue = "|c2222DD"..FCOCF.locVars.preChatText.."|r "

--[[ The libFilters 3 filter types used in this addon
    LF_SMITHING_DECONSTRUCT  = 16
    LF_SMITHING_IMPROVEMENT  = 17
    LF_ENCHANTING_CREATION   = 20
    LF_ENCHANTING_EXTRACTION = 21
    LF_RETRAIT               = 28
]]

--Control names of ZO* standard controls etc.
FCOCF.zoVars = {}
--Smithing
----Deconstruction
FCOCF.zoVars.CRAFTSTATION_SMITHING_DECONSTRUCT_BUTTON                 = ZO_SmithingTopLevelModeMenuBarButton3
FCOCF.zoVars.CRAFTSTATION_SMITHING_DECONSTRUCTION_INVENTORY           = ZO_SmithingTopLevelDeconstructionPanelInventory
FCOCF.zoVars.CRAFTSTATION_SMITHING_DECONSTRUCTION_INVENTORY_BACKPACK  = ZO_SmithingTopLevelDeconstructionPanelInventoryBackpack
FCOCF.zoVars.CRAFTSTATION_SMITHING_DECONSTRUCTION_TABS                = ZO_SmithingTopLevelDeconstructionPanelInventoryTabs

----Improvement
FCOCF.zoVars.CRAFTSTATION_SMITHING_IMPROVEMENT_BUTTON                 = ZO_SmithingTopLevelModeMenuBarButton4
FCOCF.zoVars.CRAFTSTATION_SMITHING_IMPROVEMENT_INVENTORY              = ZO_SmithingTopLevelImprovementPanelInventory
FCOCF.zoVars.CRAFTSTATION_SMITHING_IMPROVEMENT_INVENTORY_BACKPACK     = ZO_SmithingTopLevelImprovementPanelInventoryBackpack
FCOCF.zoVars.CRAFTSTATION_SMITHING_IMPROVEMENT_TABS                   = ZO_SmithingTopLevelImprovementPanelInventoryTabs

--Enchanting
FCOCF.zoVars.CRAFTSTATION_ENCHANTING	                              = ZO_Enchanting
FCOCF.zoVars.CRAFTSTATION_ENCHANTING_INVENTORY                        = ZO_EnchantingTopLevelInventory
FCOCF.zoVars.CRAFTSTATION_ENCHANTING_INVENTORY_BACKPACK               = ZO_EnchantingTopLevelInventoryBackpack
FCOCF.zoVars.CRAFTSTATION_ENCHANTING_TABS                             = ZO_EnchantingTopLevelInventoryTabs

----Transmutation
FCOCF.zoVars.TRANSMUTATIONSTATION                                     = ZO_RETRAIT_STATION_KEYBOARD
FCOCF.zoVars.TRANSMUTATIONSTATION_RETRAIT_PANEL                       = FCOCF.zoVars.TRANSMUTATIONSTATION.retraitPanel
FCOCF.zoVars.TRANSMUTATIONSTATION_CONTROL                             = FCOCF.zoVars.TRANSMUTATIONSTATION_RETRAIT_PANEL.control
FCOCF.zoVars.TRANSMUTATIONSTATION_INVENTORY                           = ZO_RetraitStation_KeyboardTopLevelRetraitPanelInventory
FCOCF.zoVars.TRANSMUTATIONSTATION_INVENTORY_BACKPACK                  = ZO_RetraitStation_KeyboardTopLevelRetraitPanelInventoryBackpack
FCOCF.zoVars.TRANSMUTATIONSTATION_TABS                                = ZO_RetraitStation_KeyboardTopLevelRetraitPanelInventoryTabs

--Settings / SavedVars
FCOCF.settingsVars			    = {}
FCOCF.settingsVars.settings       = {}
FCOCF.settingsVars.defaultSettings= {}

--Preventer variables
FCOCF.preventerVars = {}
FCOCF.preventerVars.gLocalizationDone = false
FCOCF.preventerVars.gLockpickActive	= false
FCOCF.preventerVars.gOnLockpickChatState = false

--Localization
FCOCF.localizationVars = {}
FCOCF.localizationVars.FCOCF_loc = {}

--===================== FUNCTIONS ==============================================

-- Build the options menu
local function BuildAddonMenu()
    local addonVars = FCOCF.addonVars
    local settings = FCOCF.settingsVars.settings
    local localizationVars = FCOCF.localizationVars.FCOCF_loc

    local panelData = {
        type 				= 'panel',
        name 				= addonVars.addonNameMenu,
        displayName 		= addonVars.addonNameMenuDisplay,
        author 				= addonVars.addonAuthor,
        version 			= addonVars.addonVersionOptions,
        website             = addonVars.addonWebsite,
        registerForRefresh 	= true,
        registerForDefaults = true,
        slashCommand = "/fcocfs",
    }

-- !!! RU Patch Section START
--  Add english language description behind language descriptions in other languages
	local function nvl(val) if val == nil then return "..." end return val end
	local LV_Cur = localizationVars
	local LV_Eng = FCOCF.localizationVars.localizationAll[1]
	local languageOptions = {}
	for i=1, FCOCF.numVars.languageCount do
		local s="options_language_dropdown_selection"..i
		if LV_Cur==LV_Eng then
			languageOptions[i] = nvl(LV_Cur[s])
		else
			languageOptions[i] = nvl(LV_Cur[s]) .. " (" .. nvl(LV_Eng[s]) .. ")"
		end
	end
-- !!! RU Patch Section END

    local savedVariablesOptions = {
        [1] = localizationVars["options_savedVariables_dropdown_selection1"],
        [2] = localizationVars["options_savedVariables_dropdown_selection2"],
    }

    --The LAM settings panel
    FCOCF.LAMSettingsPanel = LAM:RegisterAddonPanel(addonVars.gAddonName, panelData)

    local optionsTable =
    {	-- BEGIN OF OPTIONS TABLE

        {
            type = 'description',
            text = localizationVars["options_description"],
        },

        --==============================================================================
        {
            type = 'header',
            name = localizationVars["options_header1"],
        },
        {
            type = 'dropdown',
            name = localizationVars["options_language"],
            tooltip = localizationVars["options_language_tooltip"],
            choices = languageOptions,
            getFunc = function() return languageOptions[FCOCF.settingsVars.defaultSettings.language] end,
            setFunc = function(value)
                for i,v in pairs(languageOptions) do
                    if v == value then
                        FCOCF.settingsVars.defaultSettings.language = i
                        --Tell the settings that you have manually chosen the language and want to keep it
                        --Read in function Localization() after ReloadUI()
                        settings.languageChoosen = true
                        --localizationVars			  	 = localizationVars[i]
                        --ReloadUI()
                    end
                end
            end,
           disabled = function() return settings.alwaysUseClientLanguage end,
           warning = localizationVars["options_language_description1"],
           requiresReload = true,
        },
		{
			type = "checkbox",
			name = localizationVars["options_language_use_client"],
			tooltip = localizationVars["options_language_use_client_tooltip"],
			getFunc = function() return settings.alwaysUseClientLanguage end,
			setFunc = function(value)
				settings.alwaysUseClientLanguage = value
                      --ReloadUI()
		            end,
            default = settings.alwaysUseClientLanguage,
            warning = localizationVars["options_language_description1"],
            requiresReload = true,
		},
        {
            type = 'dropdown',
            name = localizationVars["options_savedvariables"],
            tooltip = localizationVars["options_savedvariables_tooltip"],
            choices = savedVariablesOptions,
            getFunc = function() return savedVariablesOptions[FCOCF.settingsVars.defaultSettings.saveMode] end,
            setFunc = function(value)
                for i,v in pairs(savedVariablesOptions) do
                    if v == value then
                        FCOCF.settingsVars.defaultSettings.saveMode = i
                        ReloadUI()
                    end
                end
            end,
            warning = localizationVars["options_language_description1"],
        },
        --==============================================================================
        {
            type = 'header',
            name = localizationVars["options_header_crafting_stations"],
        },
        {
            type = "checkbox",
            name = localizationVars["options_enable_medium_filter"],
            tooltip = localizationVars["options_enable_medium_filter_tooltip"],
            getFunc = function() return settings.enableMediumFilters end,
            setFunc = function(value) settings.enableMediumFilters = not settings.enableMediumFilters
            end,
            default = settings.enableMediumFilters,
            width="full",
        },
    }
    -- END OF OPTIONS TABLE
    LAM:RegisterOptionControls(addonVars.gAddonName, optionsTable)

end

local function Localization()
--d("[FCOCF] Localization - Start, useClientLang: " .. tostring(FCOCF.settingsVars.settings.alwaysUseClientLanguage))
	--Was localization already done during keybindings? Then abort here
 	if FCOCF.preventerVars.gLocalizationDone == true then return end
    local settings = FCOCF.settingsVars.settings
    --Fallback to english variable
    local fallbackToEnglish = false
	--Always use the client's language?
    if not settings.alwaysUseClientLanguage then
		--Was a language chosen already?
	    if not settings.languageChosen then
--d("[FCOCF] Localization: Fallback to english. Language chosen: " .. tostring(settings.languageChosen) .. ", defaultLanguage: " .. tostring(FCOCF.settingsVars.defaultSettings.language))
			if FCOCF.settingsVars.defaultSettings.language == nil then
--d("[FCOCF] Localization: defaultSettings.language is NIL -> Fallback to english now")
		    	fallbackToEnglish = true
		    else
				--Is the languages array filled and the language is not valid (not in the language array with the value "true")?
				if FCOCF.langVars.languages ~= nil and #FCOCF.langVars.languages > 0 and not FCOCF.langVars.languages[FCOCF.settingsVars.defaultSettings.language] then
		        	fallbackToEnglish = true
--d("[FCOCF] Localization: defaultSettings.language is ~= " .. i .. ", and this language # is not valid -> Fallback to english now")
				end
		    end
		end
	end
--d("[FCOCF] localization, fallBackToEnglish: " .. tostring(fallbackToEnglish))
	--Fallback to english language now
    if (fallbackToEnglish) then FCOCF.settingsVars.defaultSettings.language = 1 end
	--Is the standard language english set?
    if settings.alwaysUseClientLanguage or (FCOCF.settingsVars.defaultSettings.language == 1 and not settings.languageChosen) then
--d("[FCOCF] localization: Language chosen is false or always use client language is true!")
		local lang = GetCVar("language.2")
		--Check for supported languages
		if(lang == "de") then
	    	FCOCF.settingsVars.defaultSettings.language = 2
	    elseif (lang == "en") then
	    	FCOCF.settingsVars.defaultSettings.language = 1
	    elseif (lang == "fr") then
	    	FCOCF.settingsVars.defaultSettings.language = 3
	    elseif (lang == "es") then
	    	FCOCF.settingsVars.defaultSettings.language = 4
	    elseif (lang == "it") then
	    	FCOCF.settingsVars.defaultSettings.language = 5
	    elseif (lang == "jp") then
	    	FCOCF.settingsVars.defaultSettings.language = 6
	    elseif (lang == "ru") then
	    	FCOCF.settingsVars.defaultSettings.language = 7
		else
	    	FCOCF.settingsVars.defaultSettings.language = 1
	    end
	end
--d("[FCOCF] localization: default settings, language: " .. tostring(FCOCF.settingsVars.defaultSettings.language))
    --Get the localized texts from the localization file
    FCOCF.localizationVars.FCOCF_loc = FCOCF.localizationVars.localizationAll[FCOCF.settingsVars.defaultSettings.language]
end

--Show a help inside the chat
local function help()
	d(FCOCF.localizationVars.FCOCF_loc["chatcommands_info"])
	d("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	d(FCOCF.localizationVars.FCOCF_loc["chatcommands_help"])
end

--Check the commands ppl type to the chat
local function command_handler(args)
    --Parse the arguments string
	local options = {}
    local searchResult = { string.match(args, "^(%S*)%s*(.-)$") }
    for i,v in pairs(searchResult) do
        if (v ~= nil and v ~= "") then
            options[i] = string.lower(v)
        end
    end

	if(#options == 0 or options[1] == "" or options[1] == "help" or options[1] == "hilfe" or options[1] == "list") then
       	help()
    end
end

--==============================================================================
--============================== END SETTINGS ==================================
--==============================================================================

--[[
--Refresh the scroll list of the inventory, to update icons etc.
local function FCOCraftFilter_RefreshInventoryList(inventoryType)
    if inventoryType == nil then return end
    --Improvement
    if     (inventoryType == LF_SMITHING_IMPROVEMENT) then
        --Are we at an improvement panel?
        --Only refresh the scroll list
        ZO_ScrollList_RefreshVisible(FCOCF.zoVars.CRAFTSTATION_SMITHING_IMPROVEMENT_INVENTORY_BACKPACK)
    --Deconstruction
    elseif (inventoryType == LF_SMITHING_DECONSTRUCT) then
        --Are we at a deconstruction panel?
        --Only refresh the scroll list
        ZO_ScrollList_RefreshVisible(FCOCF.zoVars.CRAFTSTATION_SMITHING_DECONSTRUCTION_INVENTORY_BACKPACK)
    --Deconstruction
    elseif (inventoryType == LF_ENCHANTING_CREATION) then
        --Are we at a enchanting creation panel?
        --Only refresh the scroll list
        ZO_ScrollList_RefreshVisible(FCOCF.zoVars.CRAFTSTATION_ENCHANTING_INVENTORY_BACKPACK)
    elseif (inventoryType == LF_ENCHANTING_EXTRACTION) then
        --Are we at a enchanting extraction panel?
        --Only refresh the scroll list
        ZO_ScrollList_RefreshVisible(FCOCF.zoVars.CRAFTSTATION_ENCHANTING_INVENTORY_BACKPACK)
    end

end
]]

--Callback function for the filter: This function will hide/show the items at the crafting station panel
--Slot: the inventorySlot
--return false: hide the slot
--return true: show the slot
local function FCOCraftFilter_FilterCallbackFunctionDeconstruction(bagId, slotIndex, ...)
--d("FCOCraftFilter_FilterCallbackFunctionDeconstruction")
    if bagId == nil or slotIndex == nil or FCOCF.locVars.gLastPanel == nil or FCOCF.locVars.gLastCraftingType == nil then return false end
    local settings = FCOCF.settingsVars.settings
    local locVars = FCOCF.locVars
    --The result variable, predefined with true to show the item
    local resultVar = true
    --Check the bagId if it is the BANK or subscriber bank and react according to enabled settings
    if (bagId == BAG_BANK or bagId == BAG_SUBSCRIBER_BANK) and settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel] == true then
        resultVar = false
    elseif settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel] == -99 then
        resultVar = (bagId == BAG_BANK or bagId == BAG_SUBSCRIBER_BANK)
    else
        resultVar = true
    end
--d("BagId: " .. bagId .. ", slotIndex: " .. slotIndex .. ", resultVar: " .. tostring(resultVar))
    --Return the result variable now
    return resultVar
end

--Update inventory/refresh it
local function FCOCraftFilter_UpdateInventory(invType)
    if libFilters == nil or invType == nil then return end
    libFilters:RequestUpdate(invType)

    --Addon AdvancedFilters is enabled? RefreshTheSubfilterButton bar now to hide/show subfilters where no items are below
    if AdvancedFilters and AdvancedFilters.util and AdvancedFilters.util.RefreshSubfilterBar
        and AdvancedFilters.util.UpdateCraftingInventoryFilteredCount then
        local AF = AdvancedFilters
        local retraitPanel = FCOCF.zoVars.TRANSMUTATIONSTATION_RETRAIT_PANEL
        local libFiltersPanelId2CraftingInvFilterType = {
            [LF_RETRAIT]                = retraitPanel.inventory.filterType,
            [LF_SMITHING_REFINE]        = SMITHING.refinementPanel.inventory.filterType,
            [LF_SMITHING_DECONSTRUCT]   = SMITHING.deconstructionPanel.inventory.filterType,
            [LF_SMITHING_IMPROVEMENT]   = SMITHING.improvementPanel.inventory.filterType,
            [LF_JEWELRY_REFINE]         = SMITHING.refinementPanel.inventory.filterType,
            [LF_JEWELRY_DECONSTRUCT]    = SMITHING.deconstructionPanel.inventory.filterType,
            [LF_JEWELRY_IMPROVEMENT]    = SMITHING.improvementPanel.inventory.filterType,
            [LF_ENCHANTING_CREATION]    = ENCHANTING.inventory.filterType,
            [LF_ENCHANTING_EXTRACTION]  = ENCHANTING.inventory.filterType,
        }
        local invTypeAF = AF.currentInventoryType
        local craftingType = AF.util.GetCraftingType()
        local craftingInvFilterType = libFiltersPanelId2CraftingInvFilterType[invTypeAF] or nil
        if craftingInvFilterType == nil then return end
        local currentFilter = AF.util.MapCraftingStationFilterType2ItemFilterType(craftingInvFilterType, invTypeAF, craftingType)
--d("[FCOCF->AF]ChangeFilterCrafting, invTypeAF: " .. tostring(invTypeAF) .. ", craftingType: " .. tostring(craftingType) .. ", currentFilter: " .. tostring(currentFilter))
        local subfilterGroup = AF.subfilterGroups[invTypeAF]
        if not subfilterGroup then return end
        local currentSubfilterBar = subfilterGroup.currentSubfilterBar
        if not currentSubfilterBar then return end
        AF.util.ThrottledUpdate("RefreshSubfilterBar" .. invTypeAF .. "_" .. craftingType .. currentSubfilterBar.name, 10,
            AF.util.RefreshSubfilterBar, currentSubfilterBar, "FCOCraftFilter")
        AF.util.ThrottledUpdate("UpdateCraftingInventoryFilteredCount" .. invTypeAF .. "_" .. craftingType .. currentSubfilterBar.name, 25,
            AF.util.UpdateCraftingInventoryFilteredCount, invTypeAF)
    end
end

--Register the filter + callback function for the inventory type
local function FCOCraftFilter_RegisterFilter(filterName, libFiltersInventoryType, callbackFunction)
    if   libFilters == nil or filterName == nil or filterName == "" or libFiltersInventoryType == nil
      or callbackFunction == nil or type(callbackFunction) ~= "function" then return end
--d("[FCOCraftFilter_RegisterFilter] filterName: FCOCraftFilter_" .. filterName .. ", libFiltersInventoryType: " .. libFiltersInventoryType)
    if(not libFilters:IsFilterRegistered("FCOCraftFilter_" .. tostring(filterName))) then
--d("--> register now")
        libFilters:RegisterFilter("FCOCraftFilter_" .. tostring(filterName), libFiltersInventoryType, callbackFunction)
    end
end

--Unregister the filter for the inventory type
local function FCOCraftFilter_UnregisterFilter(filterName, libFiltersInventoryType)
    if   libFilters == nil or filterName == nil or filterName == "" or libFiltersInventoryType == nil then return end
--d("[FCOCraftFilter_UnregisterFilter] filterName: FCOCraftFilter_" .. filterName .. ", libFiltersInventoryType: " .. libFiltersInventoryType)
    libFilters:UnregisterFilter("FCOCraftFilter_" .. tostring(filterName), libFiltersInventoryType)
end


--==============================================================================
--==================== START EVENT CALLBACK FUNCTIONS===========================
--==============================================================================

--Get the "real" active panel.
local function FCOCraftFilter_CheckActivePanel(comingFrom)
    local locVars = FCOCF.locVars
    local zoVars = FCOCF.zoVars
    if comingFrom == nil then
        --Get the current filter panel id
        comingFrom = locVars.gLastPanel
        if comingFrom == nil then comingFrom = 0 end
    end

--d("[FCOCraftFilter_CheckActivePanel] comingFrom: " .. comingFrom)

    if locVars.gLastCraftingType ~= nil and locVars.gLastPanel ~= nil then
        --Unregister the filter for old panel
        if locVars.gLastPanel == nil then return end
        FCOCraftFilter_UnregisterFilter(locVars.gLastCraftingType .. "_" .. locVars.gLastPanel, locVars.gLastPanel)
    end

    --Enchanting creation mode
    if comingFrom == LF_ENCHANTING_CREATION then
        locVars.gLastPanel = LF_ENCHANTING_CREATION
        --Enchanting extraction mode
    elseif comingFrom == LF_ENCHANTING_EXTRACTION then
        locVars.gLastPanel = LF_ENCHANTING_EXTRACTION
    --Deconstruction
    elseif comingFrom == LF_SMITHING_DECONSTRUCT then
        locVars.gLastPanel = LF_SMITHING_DECONSTRUCT
    elseif comingFrom == LF_JEWELRY_DECONSTRUCT then
        locVars.gLastPanel = LF_JEWELRY_DECONSTRUCT
    --Improvement
    elseif comingFrom == LF_SMITHING_IMPROVEMENT then
        locVars.gLastPanel = LF_SMITHING_IMPROVEMENT
    elseif comingFrom == LF_JEWELRY_IMPROVEMENT then
        locVars.gLastPanel = LF_JEWELRY_IMPROVEMENT
    --Transmutation / Retrait
    elseif comingFrom == LF_RETRAIT then
        locVars.gLastPanel = LF_RETRAIT
    ---------------------------------------------------------------------------------
    --Alternative detection via the controls hidden state
    ---------------------------------------------------------------------------------
    --Deconstruction
    elseif not zoVars.CRAFTSTATION_SMITHING_DECONSTRUCTION_INVENTORY:IsHidden() then
        locVars.gLastPanel = LF_SMITHING_DECONSTRUCT
    --Improvement
    elseif not zoVars.CRAFTSTATION_SMITHING_IMPROVEMENT_INVENTORY:IsHidden() then
        locVars.gLastPanel = LF_SMITHING_IMPROVEMENT
    --Transmutation / Retrait
    elseif not zoVars.TRANSMUTATIONSTATION_CONTROL:IsHidden() then
        locVars.gLastPanel = LF_RETRAIT
    end

    if comingFrom == 0 or locVars.gLastPanel == nil then return end
end

--Add a button to an existing parent control
local function AddButton(parent, name, callbackFunction, text, font, tooltipText, tooltipAlign, textureNormal, textureMouseOver, textureClicked, textureMedium, width, height, left, top, alignMain, alignBackup, alignControl, hideButton)
--d("[AddButton] name: " .. name)
    --Abort needed?
    if (not hideButton and (parent == nil or name == nil or callbackFunction == nil
            or width <= 0 or height <= 0 or alignMain == nil or alignBackup == nil)
            and (textureNormal == nil or text == nil)) then
    elseif hideButton and name == nil then
        return nil
    end
    local settings = FCOCF.settingsVars.settings
    local locVars = FCOCF.locVars
    local localizationVars = FCOCF.localizationVars.FCOCF_loc

    local button
    --Does the button already exist?
    button = WINDOW_MANAGER:GetControlByName(name, "")
    if button == nil then
        --Button does not exist yet and it should be hidden? Abort here!
        if hideButton == true then return nil end
        --Create the button control at the parent
        button = WINDOW_MANAGER:CreateControl(name, parent, CT_BUTTON)
    end
    --Button was created?
    if button ~= nil then
        --Button should be hidden?
        if hideButton == false then

            --Set the button's size
            button:SetDimensions(width, height)

            --Align the button
            if alignControl == nil then
                alignControl = parent
            end

            --SetAnchor(point, relativeTo, relativePoint, offsetX, offsetY)
            button:SetAnchor(alignMain, alignControl, alignBackup, left, top)

            --Texture or text?
            if (text ~= nil) then
                --Text
                --Set the button's font
                if font == nil then
                    button:SetFont("ZoFontGameSmall")
                else
                    button:SetFont(font)
                end

                --Set the button's text
                button:SetText(text)

            else
                --Texture
                local texture

                --Check if texture exists
                texture = WINDOW_MANAGER:GetControlByName(name .. "Texture", "")
                if texture == nil then
                    --Create the texture for the button to hold the image
                    texture = WINDOW_MANAGER:CreateControl(name .. "Texture", button, CT_TEXTURE)
                end
                texture:SetAnchorFill()

                --Are the settings to hide items from your bank enabled?
                --Set the texture for normale state now
                local hideItemsFromBank = settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel]
                if hideItemsFromBank == true then
                    texture:SetTexture(textureClicked)
                elseif hideItemsFromBank == -99 then
                    texture:SetTexture(textureMedium)
                elseif not hideItemsFromBank then
                    texture:SetTexture(textureNormal)
                end

                --Do we have seperate textures for the button states?
                button.upTexture 	  = textureNormal
                button.downTexture 	  = textureMouseOver or textureNormal
                button.mediumTexture  = textureMedium or textureNormal
                button.clickedTexture = textureClicked or textureNormal
            end

            if tooltipAlign == nil then tooltipAlign = TOP end
            --Set a tooltip?
            button:SetHandler("OnMouseEnter", function(self)
                --Are the settings to hide items from your bank enabled?
                local hideItemsFromBank = settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel]
                if hideItemsFromBank == true then
                    self:GetChild(1):SetTexture(self.clickedTexture)
                    if tooltipText ~= nil then
                        if settings.enableMediumFilters then
                            tooltipText = localizationVars["button_FCO_currently_hide_bank_tooltip"] .. "\n" .. localizationVars["button_FCO_show_only_bank_tooltip"]
                        else
                            tooltipText = localizationVars["button_FCO_currently_hide_bank_tooltip"] .. "\n" .. localizationVars["button_FCO_show_bank_tooltip"]
                        end
                    end
                elseif hideItemsFromBank == -99 then
                    self:GetChild(1):SetTexture(self.mediumTexture)
                    if settings.enableMediumFilters and tooltipText ~= nil then
                        tooltipText = localizationVars["button_FCO_currently_show_only_bank_tooltip"] .. "\n" .. localizationVars["button_FCO_show_bank_tooltip"]
                    end
                elseif not hideItemsFromBank then
                    self:GetChild(1):SetTexture(self.downTexture)
                    if tooltipText ~= nil then
                        tooltipText = localizationVars["button_FCO_currently_show_bank_tooltip"] .. "\n" .. localizationVars["button_FCO_hide_bank_tooltip"]
                    end
                end
                if tooltipText ~= nil then
                    tooltipText = locVars.preChatTextGreen .. "\n" .. tooltipText
                    ZO_Tooltips_ShowTextTooltip(button, tooltipAlign, tooltipText)
                end
            end)
            button:SetHandler("OnMouseExit", function(self)
                --Are the settings to hide items from your bank enabled?
                local hideItemsFromBank = settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel]
                if hideItemsFromBank == true then
                    self:GetChild(1):SetTexture(self.clickedTexture)
                elseif hideItemsFromBank == -99 then
                    self:GetChild(1):SetTexture(self.mediumTexture)
                elseif not hideItemsFromBank then
                    self:GetChild(1):SetTexture(self.upTexture)
                end
                ZO_Tooltips_HideTextTooltip()
            end)
            --Set the callback function of the button
            button:SetHandler("OnClicked", function(...)
                callbackFunction(...)
            end)
            button:SetHandler("OnMouseDown", function(butn, ctrl, alt, shift, command)
                --Are the settings to hide items from your bank enabled?
                local hideItemsFromBank = settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel]
                if hideItemsFromBank == true then
                    butn:GetChild(1):SetTexture(butn.clickedTexture)
                elseif hideItemsFromBank == -99 then
                    butn:GetChild(1):SetTexture(butn.mediumTexture)
                elseif not hideItemsFromBank then
                    butn:GetChild(1):SetTexture(butn.upTexture)
                end
            end)
            button:SetHandler("OnMouseUp", function(butn, upInside)
                if upInside then
                    zo_callLater(function()
                        --Are the settings to hide items from your bank enabled?
                        local hideItemsFromBank = settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel]
                        if hideItemsFromBank == true then
                            butn:GetChild(1):SetTexture(butn.clickedTexture)
                        elseif hideItemsFromBank == -99 then
                            butn:GetChild(1):SetTexture(butn.mediumTexture)
                        elseif not hideItemsFromBank then
                            butn:GetChild(1):SetTexture(butn.upTexture)
                        end
                    end, 50)
                    ZO_Tooltips_HideTextTooltip()
                end
            end)

            --Show the button and make it react on mouse input
            button:SetHidden(false)
            button:SetMouseEnabled(true)

            --Return the button control
            return button
        else
--d("hiding button: " .. name)
            --Hide the button and make it not reacting on mouse input
            button:SetHidden(true)
            button:SetMouseEnabled(false)
        end
    else
        return nil
    end
end

--Function to change the bank items filter at crafting stations, according to the enabled settings (medium filter)
local function FCOCraftFilter_ChangeCraftingStationBankSettings(comingFrom)
    if comingFrom == nil then return false end
    local locVars = FCOCF.locVars
    local settings = FCOCF.settingsVars.settings

    if locVars.gLastCraftingType == nil then return false end
    --Is the "show only bank items" filter enabled?
    if settings.enableMediumFilters then
        if settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom] == true then
            settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom] = -99
        elseif settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom] == -99 then
            settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom] = false
        else
            settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom] = true
        end

    else
        if settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom] == -99 then
            settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom] = false
        end
        settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom] = not settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom]
    end
end

--Function to update the settings "hide/show bank items at crafting station", update the filter and refresh the visible items
local function FCOCraftFilter_CraftingStationUpdateBankItemOption(comingFrom, changeSettings)
    changeSettings = changeSettings or false
    if comingFrom == nil then return false end
    local settings = FCOCF.settingsVars.settings
    local locVars = FCOCF.locVars
    if locVars.gLastCraftingType == nil then return false end
--d("[FCOCraftFilter_CraftingStationUpdateBankItemOption] comingFrom: " .. comingFrom .. ", changeSettings: " .. tostring(changeSettings))
    if settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom] == nil then return false end

--d(">> settings.hideItemsFromBank[" .. tostring(locVars.gLastCraftingType) .. "][" .. tostring(comingFrom) .. "]: " .. tostring(settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom]))
    --Turn around the settings if wished
    if changeSettings then
        FCOCraftFilter_ChangeCraftingStationBankSettings(comingFrom)
    end
--d(">>> NEW: " .. tostring(settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom]))
    --Get the appropriate inventory type
    if comingFrom == nil then return end
    --Check settings then

    if settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom] == true or settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom] == -99 then
--d("Register filter")
        --Register the filter and hide bank items
        FCOCraftFilter_RegisterFilter(locVars.gLastCraftingType .. "_" .. comingFrom, comingFrom, FCOCraftFilter_FilterCallbackFunctionDeconstruction)
        --Refresh the inventory
        FCOCraftFilter_UpdateInventory(comingFrom)
    elseif not settings.hideItemsFromBank[locVars.gLastCraftingType][comingFrom] then
--d("Unregister filter")
        --Unregister the filter and show all items again
        FCOCraftFilter_UnregisterFilter(locVars.gLastCraftingType .. "_" .. comingFrom, comingFrom)
        --Refresh the inventory
        FCOCraftFilter_UpdateInventory(comingFrom)
    end

end

--Check if the retrait station is shown and add the button now
local function FCOCraftFilter_CheckIfRetraitStationIsShownAndAddButton(craftSkill)
    if craftSkill == nil then return end
    if craftSkill == CRAFTING_TYPE_INVALID then
        zo_callLater(function()
            --Check if the retrait station is shown
            if not FCOCF.zoVars.TRANSMUTATIONSTATION_CONTROL:IsHidden() then
                --Set the actual panel to transmutation/retrait
                FCOCF.locVars.gLastPanel = LF_RETRAIT
                --Add the button to the retrait station now
                local settings = FCOCF.settingsVars.settings
                local locVars = FCOCF.locVars
                local localizationVars = FCOCF.localizationVars.FCOCF_loc
                local zoVars = FCOCF.zoVars
                local tooltipVar = ""
                if settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel] == true then
                    tooltipVar = localizationVars["button_FCO_currently_hide_bank_tooltip"] .. "\n" .. localizationVars["button_FCO_show_only_bank_tooltip"]
                elseif settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel] == -99 then
                    tooltipVar = localizationVars["button_FCO_currently_show_only_bank_tooltip"] .. "\n" ..localizationVars["button_FCO_show_bank_tooltip"]
                elseif not settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel] then
                    tooltipVar = localizationVars["button_FCO_currently_show_bank_tooltip"] .. "\n" ..localizationVars["button_FCO_hide_bank_tooltip"]
                end
                AddButton(zoVars.TRANSMUTATIONSTATION_INVENTORY, zoVars.TRANSMUTATIONSTATION_TABS:GetName() .. "RetraitFCOCraftFilterHideBankButton", function(...) FCOCraftFilter_CraftingStationUpdateBankItemOption(LF_RETRAIT, true) end, nil, nil, tooltipVar, BOTTOM, "/EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds", "/EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds", "/esoui/art/mainmenu/menubar_inventory_up.dds", "/esoui/art/icons/servicemappins/servicepin_bank.dds", 32, 32, -458, 35, BOTTOMLEFT, TOPLEFT, zoVars.TRANSMUTATIONSTATION_TABS, false)
                --Update the filters for the Retrait staition now (again)
                FCOCraftFilter_CraftingStationUpdateBankItemOption(LF_RETRAIT, false)
            end
        end, 50) -- delayed in order to let the retrait panel show properly!
    end
end

--Event upon opening a crafting station
local function FCOCraftFilter_OnOpenCrafting(eventCode, craftSkill, sameStation)
--d("FCOCraftFilter_OnOpenCraftingStation")
    --Set crafting station type to invalid if not given (e.g. when coming from the retrait station)
    craftSkill = craftSkill or CRAFTING_TYPE_INVALID

    --Unregister old filters if the crafting type is unknown and the last panel was the retrait station
    local locVars = FCOCF.locVars
    if locVars.gLastPanel == LF_RETRAIT and locVars.gLastCraftingType == CRAFTING_TYPE_INVALID then
        FCOCraftFilter_UnregisterFilter(locVars.gLastCraftingType .. "_" .. locVars.gLastPanel, locVars.gLastPanel)
    end

    --Remember the current crafting station type
    FCOCF.locVars.gLastCraftingType = craftSkill

--d(">FCOCF.locVars.gLastCraftingType: " ..tostring(FCOCF.locVars.gLastCraftingType))
    --Is the craftSkill not valid then it could be the retrait station.
    --Check if the retrait station is shown and add the button now
    FCOCraftFilter_CheckIfRetraitStationIsShownAndAddButton(craftSkill)
end

--Event upon closing a crafting station
local function FCOCraftFilter_OnCloseCrafting(...)
--d("FCOCraftFilter_OnCloseCraftingStation")
    local locVars = FCOCF.locVars
    if locVars.gLastPanel == nil then return false end
    FCOCraftFilter_UnregisterFilter(locVars.gLastCraftingType .. "_" .. locVars.gLastPanel, locVars.gLastPanel)
    --Reset the last crafting station type
    FCOCF.locVars.gLastCraftingType = nil
end

--[[
-- Fires each time after addons were loaded and player is ready to move (after each zone change too)
local function FCOCraftFilter_Player_Activated(...)
	--Prevent this event to be fired again and again upon each zone change
	EVENT_MANAGER:UnregisterForEvent(FCOCF.addonVars.gAddonName, EVENT_PLAYER_ACTIVATED)

    FCOCF.addonVars.gAddonLoaded = false
end
]]

--==============================================================================
--===== HOOKS BEGIN ============================================================
--==============================================================================
--Hook function for the menu buttons
--PreHook function for the buttons at the top tabs of crafting stations
local function FCOCraftFilter_PreHookButtonHandler(comingFrom)
--d("FCOCraftFilter_PreHookButtonHandler, comingFrom: " ..tostring(comingFrom))
    local settings = FCOCF.settingsVars.settings
    local locVars = FCOCF.locVars
    local zoVars = FCOCF.zoVars
    local localizationVars = FCOCF.localizationVars.FCOCF_loc

    --Disable the medium filters if the settings for the medium filter is disabled
    if not settings.enableMediumFilters then
        if settings.hideItemsFromBank[LF_SMITHING_DECONSTRUCT] == -99 then
            settings.hideItemsFromBank[LF_SMITHING_DECONSTRUCT] = false
        end
        if settings.hideItemsFromBank[LF_SMITHING_IMPROVEMENT] == -99 then
            settings.hideItemsFromBank[LF_SMITHING_IMPROVEMENT] = false
        end
        if settings.hideItemsFromBank[LF_JEWELRY_DECONSTRUCT] == -99 then
            settings.hideItemsFromBank[LF_JEWELRY_DECONSTRUCT] = false
        end
        if settings.hideItemsFromBank[LF_JEWELRY_IMPROVEMENT] == -99 then
            settings.hideItemsFromBank[LF_JEWELRY_IMPROVEMENT] = false
        end
        if settings.hideItemsFromBank[LF_ENCHANTING_EXTRACTION] == -99 then
            settings.hideItemsFromBank[LF_ENCHANTING_EXTRACTION] = false
        end
        if settings.hideItemsFromBank[LF_ENCHANTING_CREATION] == -99 then
            settings.hideItemsFromBank[LF_ENCHANTING_CREATION] = false
        end
        if settings.hideItemsFromBank[LF_RETRAIT] == -99 then
            settings.hideItemsFromBank[LF_RETRAIT] = false
        end
    end

    --Check the filter buttons and create them if they are not there
    FCOCraftFilter_CheckActivePanel(comingFrom)

    --Add the button to the panel so enabling/disabling the option will be fast
    FCOCraftFilter_CraftingStationUpdateBankItemOption(locVars.gLastPanel, false)

    --Get the tooltip state text for the button
    local tooltipVar = ""

--d(">gLastCraftingType: " .. tostring(locVars.gLastCraftingType) .. ", gLastPanel: " ..tostring(locVars.gLastPanel))
    if settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel] == true then
        tooltipVar = localizationVars["button_FCO_currently_hide_bank_tooltip"] .. "\n" .. localizationVars["button_FCO_show_only_bank_tooltip"]
    elseif settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel] == -99 then
        tooltipVar = localizationVars["button_FCO_currently_show_only_bank_tooltip"] .. "\n" ..localizationVars["button_FCO_show_bank_tooltip"]
    elseif not settings.hideItemsFromBank[locVars.gLastCraftingType][locVars.gLastPanel] then
        tooltipVar = localizationVars["button_FCO_currently_show_bank_tooltip"] .. "\n" ..localizationVars["button_FCO_hide_bank_tooltip"]
    end

--1. /EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds
--2. /esoui/art/mainmenu/menubar_inventory_up.dds
--  or
--  /esoui/art/tooltips/icon_bank.dds
--3. /esoui/art/icons/servicemappins/servicepin_bank.dds

    --Add the button to the head line of the crafting station menu
    --DECONSTRUCTION
    if comingFrom == LF_SMITHING_DECONSTRUCT or comingFrom == LF_JEWELRY_DECONSTRUCT then
        AddButton(zoVars.CRAFTSTATION_SMITHING_DECONSTRUCTION_INVENTORY, zoVars.CRAFTSTATION_SMITHING_DECONSTRUCTION_TABS:GetName() .. "FCOCraftFilterHideBankButton", function(...) FCOCraftFilter_CraftingStationUpdateBankItemOption(comingFrom, true) end, nil, nil, tooltipVar, BOTTOM, "/EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds", "/EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds", "/esoui/art/mainmenu/menubar_inventory_up.dds", "/esoui/art/icons/servicemappins/servicepin_bank.dds", 32, 32, -458, 35, BOTTOMLEFT, TOPLEFT, zoVars.CRAFTSTATION_SMITHING_DECONSTRUCTION_TABS, false)
    --IMPROVEMENT
    elseif comingFrom == LF_SMITHING_IMPROVEMENT or comingFrom == LF_JEWELRY_IMPROVEMENT then
        AddButton(zoVars.CRAFTSTATION_SMITHING_IMPROVEMENT_INVENTORY, zoVars.CRAFTSTATION_SMITHING_IMPROVEMENT_TABS:GetName() .. "FCOCraftFilterHideBankButton", function(...) FCOCraftFilter_CraftingStationUpdateBankItemOption(comingFrom, true) end, nil, nil, tooltipVar, BOTTOM, "/EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds", "/EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds", "/esoui/art/mainmenu/menubar_inventory_up.dds", "/esoui/art/icons/servicemappins/servicepin_bank.dds", 32, 32, -458, 35, BOTTOMLEFT, TOPLEFT, zoVars.CRAFTSTATION_SMITHING_IMPROVEMENT_TABS, false)
    --ENCHANTING CREATION
    elseif comingFrom == LF_ENCHANTING_CREATION then
        --Hide the enchantment extraction button
        AddButton(nil, zoVars.CRAFTSTATION_ENCHANTING_TABS:GetName() .. "ExtFCOCraftFilterHideBankButton", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil, nil, nil, nil, nil, true)
        --Show the enchantment creation button
        AddButton(zoVars.CRAFTSTATION_ENCHANTING_INVENTORY, zoVars.CRAFTSTATION_ENCHANTING_TABS:GetName() .. "CreationFCOCraftFilterHideBankButton", function(...) FCOCraftFilter_CraftingStationUpdateBankItemOption(LF_ENCHANTING_CREATION, true) end, nil, nil, tooltipVar, BOTTOM, "/EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds", "/EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds", "/esoui/art/mainmenu/menubar_inventory_up.dds", "/esoui/art/icons/servicemappins/servicepin_bank.dds", 32, 32, -325, 35, BOTTOMLEFT, TOPLEFT, zoVars.CRAFTSTATION_ENCHANTING_TABS, false)
    --ENCHANTING EXTRACTION
    elseif comingFrom == LF_ENCHANTING_EXTRACTION then
        --Hide the enchantment creation button
        AddButton(nil, zoVars.CRAFTSTATION_ENCHANTING_TABS:GetName() .. "CreationFCOCraftFilterHideBankButton", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,nil, nil, nil, nil, nil, true)
        --Show the enchantment extraction button
        AddButton(zoVars.CRAFTSTATION_ENCHANTING_INVENTORY, zoVars.CRAFTSTATION_ENCHANTING_TABS:GetName() .. "ExtFCOCraftFilterHideBankButton", function(...) FCOCraftFilter_CraftingStationUpdateBankItemOption(LF_ENCHANTING_EXTRACTION, true) end, nil, nil, tooltipVar, BOTTOM, "/EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds", "/EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds", "/esoui/art/mainmenu/menubar_inventory_up.dds", "/esoui/art/icons/servicemappins/servicepin_bank.dds", 32, 32, -466, 35, BOTTOMLEFT, TOPLEFT, zoVars.CRAFTSTATION_ENCHANTING_TABS, false)
    --TRANSMUTATION / RETRAIT
    elseif comingFrom == LF_RETRAIT then
        AddButton(zoVars.TRANSMUTATIONSTATION_INVENTORY, zoVars.TRANSMUTATIONSTATION_TABS:GetName() .. "RetraitFCOCraftFilterHideBankButton", function(...) FCOCraftFilter_CraftingStationUpdateBankItemOption(LF_RETRAIT, true) end, nil, nil, tooltipVar, BOTTOM, "/EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds", "/EsoUI/Art/Inventory/inventory_tabIcon_items_up.dds", "/esoui/art/mainmenu/menubar_inventory_up.dds", "/esoui/art/icons/servicemappins/servicepin_bank.dds", 32, 32, -458, 35, BOTTOMLEFT, TOPLEFT, zoVars.TRANSMUTATIONSTATION_TABS, false)
    end
    --Return false to call the normal callback handler of the button afterwards
    return false
end

--Create the hooks & pre-hooks
local function FCOCraftFilter_CreateHooks()
    --======== SMITHING =============================================================
--[[
    --Prehook the smithing function SetMode() which gets executed as the smithing tabs are changed
    ZO_PreHook(ZO_Smithing, "SetMode", function(smithing_obj, mode)
        --Deconstruction
        if     mode == SMITHING_MODE_DECONSTRUCTION then
            --Deconstruction
            zo_callLater(function()
                FCOCraftFilter_PreHookButtonHandler(LF_SMITHING_DECONSTRUCT)
            end, 10)
            --Improvement
        elseif mode == SMITHING_MODE_IMPROVEMENT then
            zo_callLater(function()
                FCOCraftFilter_PreHookButtonHandler(LF_SMITHING_IMPROVEMENT)
            end, 10)
        end
        --Go on with original function
        return false
    end)
]]
    local smithingSetModeOrig = ZO_Smithing.SetMode
    ZO_Smithing.SetMode = function(smithing_obj, mode, ...)
        smithingSetModeOrig(smithing_obj, mode, ...)
        --Deconstruction
        if     mode == SMITHING_MODE_DECONSTRUCTION then
            local craftingType = GetCraftingInteractionType()
            local filterPanelId = LF_SMITHING_DECONSTRUCT
            if craftingType == CRAFTING_TYPE_JEWELRYCRAFTING then
                filterPanelId = LF_JEWELRY_DECONSTRUCT
            end
        --Deconstruction
            zo_callLater(function()
                FCOCraftFilter_PreHookButtonHandler(filterPanelId)
            end, 10)
        --Improvement
        elseif mode == SMITHING_MODE_IMPROVEMENT then
            local craftingType = GetCraftingInteractionType()
            local filterPanelId = LF_SMITHING_IMPROVEMENT
            if craftingType == CRAFTING_TYPE_JEWELRYCRAFTING then
                filterPanelId = LF_JEWELRY_IMPROVEMENT
            end
            zo_callLater(function()
                FCOCraftFilter_PreHookButtonHandler(filterPanelId)
            end, 10)
        end
        --Go on with original function
        return false
    end

    --======== ENCHANTING ===========================================================
--[[
    --Prehook the enchanting function SetEnchantingMode() which gets executed as the enchanting tabs are changed
    ZO_PreHook(ZO_Enchanting, "SetEnchantingMode", function(enchanting_obj, enchantingMode)
        --Creation
        if     enchantingMode == ENCHANTING_MODE_CREATION then
            zo_callLater(function()
                FCOCraftFilter_PreHookButtonHandler(LF_ENCHANTING_CREATION)
            end, 10)
            --Extraction
        elseif enchantingMode == ENCHANTING_MODE_EXTRACTION then
            zo_callLater(function()
                FCOCraftFilter_PreHookButtonHandler(LF_ENCHANTING_EXTRACTION)
            end, 10)
        end
        --Go on with original function
        return false
    end)
]]
    local enchantingSetEnchantingModeOrig = ZO_Enchanting.SetEnchantingMode
    ZO_Enchanting.SetEnchantingMode = function(enchanting_obj, enchantingMode, ...)
        enchantingSetEnchantingModeOrig(enchanting_obj, enchantingMode, ...)
        --Creation
        if     enchantingMode == ENCHANTING_MODE_CREATION then
            zo_callLater(function()
                FCOCraftFilter_PreHookButtonHandler(LF_ENCHANTING_CREATION)
            end, 10)
            --Extraction
        elseif enchantingMode == ENCHANTING_MODE_EXTRACTION then
            zo_callLater(function()
                FCOCraftFilter_PreHookButtonHandler(LF_ENCHANTING_EXTRACTION)
            end, 10)
        end
        --Go on with original function
        return false
    end

    --======== RETRAIT ===========================================================
    --Called as the retrait filters are changed (Armor, weapons, jewelry). But it's not called as the retrait station
    --was opened before and is re-opened later on at the same tab + same subfilter :-( (e.g. armor -> shields)
    --THis will be handled via the event EVENT_CRAFTING_STATION_INTERACT
    local function ChangeFilterRetraitPanel (self, filterTab)
        --Set the crafting panel type to none
        FCOCF.locVars.gLastCraftingType = CRAFTING_TYPE_INVALID
        --Update the visible buttons
        FCOCraftFilter_PreHookButtonHandler(LF_RETRAIT)
        --Update the LibFilters at the panel now so only the selected items from the button (bank, inv, both) are shown!
        FCOCraftFilter_CraftingStationUpdateBankItemOption(LF_RETRAIT, false)
    end
    local retraitPanel = FCOCF.zoVars.TRANSMUTATIONSTATION_RETRAIT_PANEL
    ZO_PreHook(retraitPanel.inventory, "ChangeFilter", ChangeFilterRetraitPanel)
end

--Register the slash commands
local function RegisterSlashCommands()
    -- Register slash commands
	SLASH_COMMANDS["/fcocraftfilter"] = command_handler
	SLASH_COMMANDS["/fcocf"] 		  = command_handler
end

--Addon loads up
local function FCOCraftFilter_Loaded(eventCode, addOnName)
	local addonVars = FCOCF.addonVars
    --Is this addon found?
	if(addOnName ~= addonVars.gAddonName) then
        return
    end
	--Unregister this event again so it isn't fired again after this addon has beend reckognized
    EVENT_MANAGER:UnregisterForEvent(addonVars.gAddonName, EVENT_ADD_ON_LOADED)

	addonVars.gAddonLoaded = false

    --The default values for the language and save mode
    local defaultsSettings = {
        language 	 		    = 1, --Standard: English
        saveMode     		    = 2, --Standard: Account wide settings
    }

    --Pre-set the deafult values
    local defaults = {
		alwaysUseClientLanguage			= true,
        languageChoosen				    = false,
        hideItemsFromBank               = {
            [CRAFTING_TYPE_BLACKSMITHING] = {
                [LF_SMITHING_DECONSTRUCT]   = false,
                [LF_SMITHING_IMPROVEMENT]   = false,
            },
            [CRAFTING_TYPE_CLOTHIER] = {
                [LF_SMITHING_DECONSTRUCT]   = false,
                [LF_SMITHING_IMPROVEMENT]   = false,
            },
            [CRAFTING_TYPE_ENCHANTING] = {
                [LF_ENCHANTING_EXTRACTION] 	= false,
                [LF_ENCHANTING_CREATION]   	= false,
            },
            [CRAFTING_TYPE_WOODWORKING] = {
                [LF_SMITHING_DECONSTRUCT]   = false,
                [LF_SMITHING_IMPROVEMENT]   = false,
            },
            [CRAFTING_TYPE_JEWELRYCRAFTING] = {
                [LF_JEWELRY_DECONSTRUCT]   = false,
                [LF_JEWELRY_IMPROVEMENT]   = false,
            },
            [CRAFTING_TYPE_INVALID] = {
                [LF_RETRAIT]                = false,
            }
        },
        enableMediumFilters             = false,
    }

--=============================================================================================================
--	LOAD USER SETTINGS
--=============================================================================================================
    --Load the user's settings from SavedVariables file -> Account wide of basic version 999 at first
    FCOCF.settingsVars.defaultSettings = ZO_SavedVars:NewAccountWide(addonVars.addonSavedVariablesName, 999, "SettingsForAll", defaultsSettings)

	--Check, by help of basic version 999 settings, if the settings should be loaded for each character or account wide
    --Use the current addon version to read the settings now
	if (FCOCF.settingsVars.defaultSettings.saveMode == 1) then
        FCOCF.settingsVars.settings = ZO_SavedVars:NewCharacterIdSettings(addonVars.addonSavedVariablesName, addonVars.addonVersion , "Settings", defaults )
	elseif (FCOCF.settingsVars.defaultSettings.saveMode == 2) then
        FCOCF.settingsVars.settings = ZO_SavedVars:NewAccountWide(addonVars.addonSavedVariablesName, addonVars.addonVersion, "Settings", defaults)
	else
        FCOCF.settingsVars.settings = ZO_SavedVars:NewAccountWide(addonVars.addonSavedVariablesName, addonVars.addonVersion, "Settings", defaults)
	end
--=============================================================================================================

	-- Set Localization
    Localization()

    --Build the LAM menu
    BuildAddonMenu()

	--Create the hooks
    FCOCraftFilter_CreateHooks()

    -- Register slash commands
    RegisterSlashCommands()

    addonVars.gAddonLoaded = true

	-- Registers addon to loadedAddon library
	LIBLA:RegisterAddon(addonVars.gAddonName, addonVars.addonVersionOptionsNumber)
end

-- Register the event "addon loaded" for this addon
local function FCOCraftFilter_Initialized()
	EVENT_MANAGER:RegisterForEvent(FCOCF.addonVars.gAddonName, EVENT_ADD_ON_LOADED, FCOCraftFilter_Loaded)
	--Register for the zone change/player ready event
	--EVENT_MANAGER:RegisterForEvent(FCOCF.addonVars.gAddonName, EVENT_PLAYER_ACTIVATED, FCOCraftFilter_Player_Activated)
	--Register the events for crafting stations
	EVENT_MANAGER:RegisterForEvent(FCOCF.addonVars.gAddonName, EVENT_CRAFTING_STATION_INTERACT, function(eventCode, craftSkill, sameStation) FCOCraftFilter_OnOpenCrafting(eventCode, craftSkill, sameStation) end)
    EVENT_MANAGER:RegisterForEvent(FCOCF.addonVars.gAddonName, EVENT_RETRAIT_STATION_INTERACT_START, function(eventCode) FCOCraftFilter_OnOpenCrafting(eventCode) end)
    EVENT_MANAGER:RegisterForEvent(FCOCF.addonVars.gAddonName, EVENT_END_CRAFTING_STATION_INTERACT, FCOCraftFilter_OnCloseCrafting)

    --Register the extra filters for AdvancedFilters Subfilterbar refresh function (to hide subfilter buttons as the bag types are filtered)
    if AdvancedFilters ~= nil and AdvancedFilters_RegisterSubfilterbarRefreshFilter ~= nil then
        --Deconstruction
        local subfilterRefreshFilterInformationTable = {
            inventoryType       = {INVENTORY_BACKPACK, INVENTORY_BANK},
            craftingType        = {CRAFTING_TYPE_CLOTHIER, CRAFTING_TYPE_BLACKSMITHING, CRAFTING_TYPE_WOODWORKING},
            filterPanelId       = LF_SMITHING_DECONSTRUCT,
            filterName          = "FCOCraftFilter_Deconstruction",
            callbackFunction    = function(slotData)
                return FCOCraftFilter_FilterCallbackFunctionDeconstruction(slotData.bagId, slotData.slotIndex)
            end,
        }
        AdvancedFilters_RegisterSubfilterbarRefreshFilter(subfilterRefreshFilterInformationTable)
        --Improvement
        subfilterRefreshFilterInformationTable.filterPanelId = LF_SMITHING_IMPROVEMENT
        subfilterRefreshFilterInformationTable.filterName    = "FCOCraftFilter_Improvement"
        AdvancedFilters_RegisterSubfilterbarRefreshFilter(subfilterRefreshFilterInformationTable)
        --Enchanting creation
        subfilterRefreshFilterInformationTable = {
            inventoryType       = {INVENTORY_BACKPACK, INVENTORY_BANK},
            craftingType        = {CRAFTING_TYPE_ENCHANTING},
            filterPanelId       = LF_ENCHANTING_CREATION,
            filterName          = "FCOCraftFilter_Enchanting_Creation",
            callbackFunction    = function(slotData)
                return FCOCraftFilter_FilterCallbackFunctionDeconstruction(slotData.bagId, slotData.slotIndex)
            end,
        }
        AdvancedFilters_RegisterSubfilterbarRefreshFilter(subfilterRefreshFilterInformationTable)
        --Enchanting extraction
        subfilterRefreshFilterInformationTable.filterPanelId = LF_ENCHANTING_EXTRACTION
        subfilterRefreshFilterInformationTable.filterName    = "FCOCraftFilter_Enchanting_Extraction"
        AdvancedFilters_RegisterSubfilterbarRefreshFilter(subfilterRefreshFilterInformationTable)
        --Jewelry deconstruction
        subfilterRefreshFilterInformationTable = {
            inventoryType       = {INVENTORY_BACKPACK, INVENTORY_BANK},
            craftingType        = {CRAFTING_TYPE_JEWELRYCRAFTING},
            filterPanelId       = LF_JEWELRY_DECONSTRUCT,
            filterName          = "FCOCraftFilter_Jewelry_Deconstruction",
            callbackFunction    = function(slotData)
                return FCOCraftFilter_FilterCallbackFunctionDeconstruction(slotData.bagId, slotData.slotIndex)
            end,
        }
        AdvancedFilters_RegisterSubfilterbarRefreshFilter(subfilterRefreshFilterInformationTable)
        --Jewelry improvement
        subfilterRefreshFilterInformationTable.filterPanelId = LF_JEWELRY_IMPROVEMENT
        subfilterRefreshFilterInformationTable.filterName    = "FCOCraftFilter_Jewelry_Improvement"
        AdvancedFilters_RegisterSubfilterbarRefreshFilter(subfilterRefreshFilterInformationTable)
        --Retrait
        subfilterRefreshFilterInformationTable = {
            inventoryType       = {INVENTORY_BACKPACK, INVENTORY_BANK},
            craftingType        = {CRAFTING_TYPE_NONE},
            filterPanelId       = LF_RETRAIT,
            filterName          = "FCOCraftFilter_Retrait",
            callbackFunction    = function(slotData)
                return FCOCraftFilter_FilterCallbackFunctionDeconstruction(slotData.bagId, slotData.slotIndex)
            end,
        }
        AdvancedFilters_RegisterSubfilterbarRefreshFilter(subfilterRefreshFilterInformationTable)
    end
end


--------------------------------------------------------------------------------
--- Call the start function for this addon to register events etc.
--------------------------------------------------------------------------------
FCOCraftFilter_Initialized()