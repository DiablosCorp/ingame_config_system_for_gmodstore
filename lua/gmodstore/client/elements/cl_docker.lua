local COLOR = gmodstore.Colors

local PANEL = {}
AccessorFunc(PANEL, "title", "Title")
AccessorFunc(PANEL, "link", "Link")

function PANEL:Init()
    self.base = self:GetParent()
    self.variables = {}
    self.homePanels = {}

    self.vbar = self:GetVBar()
    self.vbar:DockMargin(0, 0, 4, 0)

    self.vbar.Paint = function(s, w, h)
        local size = w / 2
        draw.RoundedBoxEx(8, size / 2, 5, size, h - 10, COLOR.vbarBG, false, true, false, true)
    end
    self.vbar.btnGrip.Paint = function(s, w, h)
        local size = w / 2
        draw.RoundedBox(8, size / 2, 5, size, h - 10, COLOR.vbarGrip)
    end
    self.vbar.btnUp.Paint = function(s, w, h) end
    self.vbar.btnDown.Paint = function(s, w, h) end

    self.originalVariables = {}
    self.categoryName = ""
end

local col_square = Color(100, 100, 100, 50)

function PANEL:Paint(w, h)
    if self.base.isBase then
        local addonSelected = self.base:GetActiveAddon() != nil
        self:ShowHome(!addonSelected)
        -- If an addon is selected
        if addonSelected then
            draw.RoundedBox(8, 0, 0, w, h, COLOR.rndbox)
        -- If you are at home
        else
            draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
            -- Subtitle of the docker
            draw.SimpleText(gmodstore:GetString("home_title"), "gmodstoreFont:35", w / 2, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        end
    end
end

function PANEL:GetVariables()
    return self.variables
end

function PANEL:CreateHome(topHeight, bottomHeight, dockTop, spaceCreation)

    local totalHeight = topHeight + bottomHeight + 20

    local panel = self:Add("DPanel")
    panel:Dock(TOP)
    panel:DockMargin(10, dockTop, 10, 0)
    panel:SetHeight(totalHeight)
    panel.Paint = function(s, w, h)
        draw.RoundedBox(16, 0, 0, w, h, col_square)
    end

    local topSpace = panel:Add("DPanel")
    topSpace:Dock(TOP)
    topSpace:DockMargin(0, 0, 0, 0)
    topSpace:SetHeight(topHeight)
    topSpace.Paint = function(s, w, h)

    end

    local bottomSpace = panel:Add("DPanel")
    bottomSpace:Dock(BOTTOM)
    bottomSpace:DockMargin(0, 0, 0, 10)
    bottomSpace:SetHeight(bottomHeight)
    bottomSpace.Paint = function(s, w, h)

    end

    spaceCreation(panel, topSpace, bottomSpace)
    table.insert(self.homePanels, panel)
end

function PANEL:ShowHome(isHome)
    if isHome then
        if not self.HomeCreated then
            -- Create the gmodstore addon panel
            self:CreateHome(70, 365, 50, function(panel, topSpace, bottomSpace)

                topSpace.Paint = function(s, w, h)

                    local gmodstoreAddonStr = gmodstore:GetString("gmodstore_addon")
                    if self.base.AmountAddons > 1 then
                        gmodstoreAddonStr = gmodstore:GetString("gmodstore_addons")
                    end

                    surface.SetFont("gmodstoreFont:65")
                    local sizeTextX = surface.GetTextSize(gmodstoreAddonStr)

                    surface.SetFont("gmodstoreFont:80")
                    local sizeNumberX = surface.GetTextSize(self.base.AmountAddons)

                    local totalSize = sizeTextX + sizeNumberX

                    draw.SimpleText(self.base.AmountAddons, "gmodstoreFont:80", w / 2 - totalSize / 2, 35, COLOR.gl3, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(gmodstoreAddonStr, "gmodstoreFont:65", w / 2 - totalSize / 2 + sizeNumberX + 10, 35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                end

                local topTip = self:Add("gmodstore.VariableTip")
                topTip:SetVisible(false)
                local text = ""
                for k, v in pairs(self.base.addons) do
                    text = text .. v.Name .. "\n"
                end
                -- If no addons
                if text == "" then
                    text = gmodstore:GetString("no_addon")
                end
                topTip:SetTipText(text)

                topSpace:SetTooltipPanel(topTip)

                panel:InvalidateParent(true)
                local sizepanelx = panel:GetSize()

                local space = (sizepanelx - 350 * 3) / 4

                for i = 1, 3 do
                    local tab, str, col, mat
                    if i == 1 then
                        tab = self.base.UpdatedAddons
                        str = "updated_addon"
                        col = COLOR.gl
                        mat = gmodstore.Materials.updated
                    elseif i == 2 then
                        tab = self.base.OutdatedAddons
                        str = "outdated_addon"
                        col = COLOR.rl
                        mat = gmodstore.Materials.outdated
                    elseif i == 3 then
                        tab = self.base.UndetectedAddons
                        str = "unversioned_addon"
                        col = COLOR.bl
                        mat = gmodstore.Materials.unversioned
                    end

                    local addonStr = gmodstore:GetString(str)
                    if #tab > 1 then
                        addonStr = gmodstore:GetString(str .. "s")
                    end

                    local squareSpace = bottomSpace:Add("DPanel")
                    squareSpace:Dock(LEFT)
                    squareSpace:DockMargin(space, 0, 0, 0)
                    squareSpace:SetWidth(350)
                    squareSpace.Paint = function(s, w, h)
                        draw.RoundedBox(16, 0, 0, w, h, col_square)

                        local size = 140
                        surface.SetDrawColor(color_white)
                        surface.SetMaterial(mat)
                        surface.DrawTexturedRect(w / 2 - size / 2, 10, size, size)

                        draw.SimpleText(#tab, "gmodstoreFont:100", w / 2, h - 55, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

                        draw.SimpleText(addonStr, "gmodstoreFont:40", w / 2, h - 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    end

                    local squareTip = self:Add("gmodstore.VariableTip")
                    squareTip:SetVisible(false)
                    local tipText = ""
                    for k, v in pairs(tab) do
                        tipText = tipText .. v.Name .. " "
                    end
                    -- If no addons
                    if tipText == "" then
                        tipText = gmodstore:GetString("no_addon")
                    end
                    squareTip:SetTipText(tipText)

                    squareSpace:SetTooltipPanel(squareTip)
                end
            end)


            -- Create the sources & credits panel
            self:CreateHome(50, 235, 10, function(panel, topSpace, bottomSpace)

                topSpace.Paint = function(s, w, h)
                    draw.SimpleText(string.format("%s & %s", gmodstore:GetString("sources"), gmodstore:GetString("credits")), "gmodstoreFont:55", w / 2, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                end

                bottomSpace.Paint = function(s, w, h)
                    draw.SimpleText(gmodstore:GetString("any_issue"), "gmodstoreFont:15", w / 2, h, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                end

                panel:InvalidateParent(true)
                local sizepanelx = panel:GetSize()

                local sourceSpaceCalc = (sizepanelx - 500 * 2) / 3

                local sourceSpace = bottomSpace:Add("DPanel")
                sourceSpace:Dock(TOP)
                sourceSpace:DockMargin(0, 0, 0, 10)
                sourceSpace:SetHeight(100)
                sourceSpace.Paint = function(s, w, h)

                end

                for i = 1, 2 do
                    local ratio, mat
                    if i == 1 then
                        ratio = 1280 / 720
                        mat = gmodstore.Materials.github
                    elseif i == 2 then
                        ratio = 1280 / 720
                        mat = gmodstore.Materials.workshop
                    end

                    local squareSpace = sourceSpace:Add("DPanel")
                    squareSpace:Dock(LEFT)
                    squareSpace:DockMargin(sourceSpaceCalc, 0, 0, 0)
                    squareSpace:SetWidth(500)
                    squareSpace.Paint = function(s, w, h)
                        local sizeY = h
                        local sizeX = sizeY * ratio
                        surface.SetDrawColor(color_white)
                        surface.SetMaterial(mat)
                        surface.DrawTexturedRect(w / 2 - sizeX / 2, h - 10 - sizeY, sizeX, sizeY)
                    end

                    local btnUrl = squareSpace:Add("DButton")
                    btnUrl:SetText("")
                    btnUrl:Dock(FILL)
                    btnUrl.Paint = function(s) end


                    local url
                    if i == 1 then
                        url = gmodstore.URL.github
                    elseif i == 2 then
                        url = gmodstore.URL.workshop
                    end

                    btnUrl.DoClick = function(s)
                        gui.OpenURL(url)
                    end
                end

                local creditSpaceCalc = (sizepanelx - 550 * 2) / 3

                local creditSpace = bottomSpace:Add("DPanel")
                creditSpace:Dock(TOP)
                creditSpace:DockMargin(0, 0, 0, 10)
                creditSpace:SetHeight(100)
                creditSpace.Paint = function(s, w, h)

                end

                for i = 1, 2 do
                    local str
                    if i == 1 then
                        str = "made_by"
                    elseif i == 2 then
                        str = "not_affiliated_with"
                    end

                    local squareSpace = creditSpace:Add("DPanel")
                    squareSpace:Dock(LEFT)
                    squareSpace:DockMargin(creditSpaceCalc, 0, 0, 0)
                    squareSpace:SetWidth(550)
                    squareSpace.Paint = function(s, w, h)
                        draw.RoundedBox(16, 0, 0, w, h, col_square)
                        draw.SimpleText(gmodstore:GetString(str), "gmodstoreFont:40", w / 2, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

                        if i == 1 then
                            local size = 40

                            surface.SetFont("gmodstoreFont:35")
                            local posDiablosX = surface.GetTextSize("i a b l o s")

                            surface.SetDrawColor(color_white)
                            surface.SetMaterial(gmodstore.Materials.diablos)
                            surface.DrawTexturedRect(w / 2 - posDiablosX / 2 - 25, h - 10 - size, size, size)


                            draw.SimpleText("i a b l o s", "gmodstoreFont:35", w / 2 - posDiablosX / 2 + 25, h - 10 - size / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        elseif i == 2 then
                            local sizeY = 40
                            local sizeX = sizeY * (350 / 80)
                            surface.SetDrawColor(color_white)
                            surface.SetMaterial(gmodstore.Materials.gms)
                            surface.DrawTexturedRect(w / 2 - sizeX / 2, h - 10 - sizeY, sizeX, sizeY)
                        end

                        -- draw.SimpleText(gmodstore:GetString("any_issue"), "gmodstoreFont:30", w / 2, yPos + 235, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    end

                    local btnUrl = squareSpace:Add("DButton")
                    btnUrl:SetText("")
                    btnUrl:Dock(FILL)
                    btnUrl.Paint = function(s) end

                    local url
                    if i == 1 then
                        url = gmodstore.URL.diablos
                    elseif i == 2 then
                        url = gmodstore.URL.gmodstore
                    end

                    btnUrl.DoClick = function(s)
                        gui.OpenURL(url)
                    end
                end

            end)

            self.HomeCreated = true
        end
    end
    for k, panel in ipairs(self.homePanels) do
        if IsValid(panel) then
            panel:SetVisible(isHome)
        end
    end
    self:InvalidateParent(true)

end

function PANEL:SetAddon(addon)
    -- local previousAddon = self.base:GetActiveAddon()

    self:ResetClientVariables()
    table.Empty(self.originalVariables)

    -- Clearing variable containers but not the home panels
    for k, variableContainer in pairs(self.variables) do
        if IsValid(variableContainer) then
            variableContainer:Remove()
        end
    end

    table.Empty(self.variables)
    self.base.activeAddon = addon

    -- if we're back at home, then we have nothing to do
    if addon == nil then
        return
    end

    self.base.categoryBar:Reset()

    local categoriesName = {}
    local categories = {}
    local unknownCategories = 1

    for varName, variable in pairs(addon.Variables) do
        if variable.Category then
            variable.Category = string.Trim(variable.Category)
        else
            variable.Category = "Default"
        end
        local categoryIndex
        if addon.Categories then
            categoryIndex = addon.Categories[variable.Category]
        end
        if not categoryIndex then
            local tabCount = 0
            if addon.Categories then tabCount = table.Count(addon.Categories) end
            if categoriesName[variable.Category] then
                categoryIndex = categoriesName[variable.Category]
            else
                categoryIndex = tabCount + unknownCategories
                categoriesName[variable.Category] = categoryIndex
                unknownCategories = unknownCategories + 1
            end
        end

        if not categoryIndex then return end

        if not categories[categoryIndex] then
            categories[categoryIndex] = {}
            categories[categoryIndex][variable.Category] = {}
        end
        variable.Name = varName -- we consider this as a value and not the key otherwise we can't sort
        -- categories[variable.Category][varName] = variable
        local varCopy = table.Copy(variable)
        table.insert(categories[categoryIndex][variable.Category], varCopy)

    end

    -- sort data
    for catIndex, category in ipairs(categories) do
        for catName, variables in pairs(category) do
            table.SortByMember(variables, "Order", true)
        end
    end

    -- add indexes under categories

    self.CanUpdVarShown = false

    for catIndex, category in ipairs(categories) do
        for catName, variables in pairs(category) do
            self.base.categoryBar:AddCategory(catName)

            for index, variable in ipairs(variables) do
                local variableContainer = self:GetCanvas():Add("gmodstore.VariableContainer")
                variableContainer:SetVariable(variable)
                variableContainer:ShowResetButton(true)


                self.originalVariables[variableContainer:GetVariableName()] = variableContainer:GetVariableValue()

                table.insert(self.variables, variableContainer)
            end
        end
    end

    self.CanUpdVarShown = true


    if categories[1] and gmodstore.ShowFirstCategory then
        local catName
        for name, _ in pairs(categories[1]) do
            catName = name
        end
        -- Auto-click on the first category - this will update the variables shown (and also the conditional variables)
        self.base.categoryBar:SetDefaultCategory(catName)
    else
        -- Update the variables for the conditions
        self:UpdateVariablesShown()
    end

end

/*
    Update the variables for the "Cond" values on variables
    We'll update the variable clientside, which will be revoked if you don't apply
*/

function PANEL:UpdateVariable(variable)
    local addon = self.base:GetActiveAddon()
    if not addon then return end

    gmodstore:SetVariable(addon.ID, variable.Name, variable.Value)

    -- Update the variables shown on the scroll panel due to condition
    if self.CanUpdVarShown then
        self:UpdateVariablesShown()
    end
end

-- Reset client variables when you change the active addon (reset values)
function PANEL:ResetClientVariables()
    local addon = self.base:GetActiveAddon()
    if not addon then return end
    for _, varContainer in pairs(self.variables) do
        local varName = varContainer:GetVariableName()
        local originalValue = self.originalVariables[varName]
        -- local varVGUI = varContainer:GetVariableVGUI()

        gmodstore:SetVariable(addon.ID, varName, originalValue)
    end
end


/*
    Update the active category
    categoryName is set to "" if there is no category
*/

function PANEL:UpdateCategory(categoryName)
    -- Update variables with category stuff
    self.categoryName = categoryName

    self:UpdateVariablesShown()
end

/*
    Update the variables shown on the docker by only showing the variables with:
        - the category
        - a valid condition to be shown
*/

function PANEL:UpdateVariablesShown()

    -- Update variables with category stuff
    local categoryName = self.categoryName
    for _, panel in pairs(self:GetVariables()) do
        local toShow = false
        if panel:GetCategory() == categoryName then
            toShow = true
        end
        if categoryName == "" then
            toShow = true
        end

        -- If the variable should be shown, then see about the condition
        if toShow then
            local variable = panel:GetVariable()
            if isfunction(variable.Cond) then
                toShow = variable.Cond()
            end
        end

        panel:SetVisible(toShow)
    end

    self.base:InvalidateChildren(true)
end

vgui.Register("gmodstore.Docker", PANEL, "DScrollPanel")