local COLOR = gmodstore.Colors

local PANEL = {}

function PANEL:Init()
    self.rightSpace = self:GetParent()
    self.variableContainer = self.rightSpace:GetVariableContainer()

    self.multiSelect = false
    self.freeWriting = false
    self.O1Table = false
    self.reinterpreted = false
    self.reverseReinterpretation = false


    self:Dock(FILL)
    self:DockMargin(0, 0, 0, 0)

    self:SetFont("gmodstoreFont:25")
    self:SetTextColor(color_white)

    self:SetWidth(self.variableContainer:GetWide() * 0.6)

    self.elements = {}
    self.values = {}
    self.valueString = ""

    self.launchPaint = true
end


function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)

    local menu = self.Menu
    if not IsValid(menu) then self.launchPaint = true return end
    if self.launchPaint then
        menu.Paint = function(s, m_w, m_h)
            surface.SetDrawColor(COLOR.g)
            surface.DrawRect(0, 0, m_w, m_h)
        end

        for k, v in pairs(menu:GetCanvas():GetChildren()) do
            if v:GetName() == "DMenuOption" then
                v:SetFont("gmodstoreFont:25")
                v:DockMargin(5, 5, 5, 5)
                v.Paint = function(s, m_w, m_h)
                    local curColor = gmodstore.PaintFunctions(s)
                    s:SetTextColor(curColor)
                    local color
                    if self:IsSelectedValue(v:GetText()) then
                        if self:IsFreeWriting() then
                            color = gmodstore.PaintFunctions(s, COLOR.rl, COLOR.rl2, COLOR.rl3)
                        else
                            color = gmodstore.PaintFunctions(s, COLOR.gl, COLOR.gl2, COLOR.gl3)
                        end
                    else
                        color = gmodstore.PaintFunctions(s, COLOR.bl, COLOR.bl2, COLOR.bl3)
                    end
                    surface.SetDrawColor(color)
                    surface.DrawRect(0, 0, m_w, m_h)
                end
            end
        end
        self.launchPaint = false
    end
end


function PANEL:IsMultiSelect()
    return self.multiSelect
end

function PANEL:SetMultiSelect(newValue)
    self.multiSelect = newValue
end

function PANEL:IsFreeWriting()
    return self.freeWriting
end


function PANEL:SetFreeWriting(newValue)
    self.freeWriting = newValue

    if newValue then
        -- If you can write free things, then it's for a table so it's multi select. If it's single select then it should be a string directly
        self:SetMultiSelect(true)
        self:Dock(TOP)
        self:DockMargin(0, 0, 0, 2)
        local freeEntry = self.rightSpace:Add("DTextEntry")
        freeEntry:Dock(BOTTOM)
        freeEntry:DockMargin(0, 2, 0, 0)

        self:SetFont("gmodstoreFont:20")
        freeEntry:SetFont("gmodstoreFont:20")
        freeEntry:SetTextColor(color_white)
        freeEntry:SetUpdateOnType(true)

        freeEntry:SetMinimumSize(250, 0)
        freeEntry:SetWidth(self.variableContainer:GetWide() * 0.6)

        self:SetMinimumSize(nil, self.rightSpace:GetTall() * 0.45)
        freeEntry:SetMinimumSize(nil, self.rightSpace:GetTall() * 0.45)

        freeEntry.Paint = function(s, w, h)
            draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
            s:DrawTextEntryText(color_white, COLOR.bl, color_white)
        end

        freeEntry.OnEnter = function(s, value)
            if not table.HasValue(self.elements, value) then
                table.insert(self.elements, value)
                self.values[value] = true
                self:RefreshChoices()
                self.variableContainer:UpdateVariable(self:GetMultiSelectRealValues())
                s:SetText("")
            end
        end

        self.freeEntryText = freeEntry

    end
end

function PANEL:IsO1Table()
    return self.O1Table
end

function PANEL:SetO1Table(newValue)
    self.O1Table = newValue
end

function PANEL:GetSelectedValues()
    if self:IsMultiSelect() then
        return self.values
    else
        local text, _ = self:GetSelected()
        return text
    end
end

function PANEL:IsSelectedValue(currentText)
    local selectedValues = self:GetSelectedValues()
    local result = false
    if self:IsMultiSelect() then
        result = selectedValues[currentText]
    else
        result = (currentText == selectedValues)
    end

    return result
end

function PANEL:GetMultiSelectRealValues()
    local realValues = {}
    local values = self.values

    if self:NeedsReverseReinterpretation() then
        -- enter all the checked values in valuesToGet
        local valuesToGet = {}
        for text, bool in pairs(values) do
            if bool then
                table.insert(valuesToGet, text)
            end
        end

        -- get the real values from the VGUI values (for example {"F1", "F4"} would return {92, 95}
        values = gmodstore:GetRealValue(valuesToGet, self.variableContainer:GetVariableElements())


        -- Transform the values (we should consider the case where the table should be a O1 Table)
        for _, value in pairs(values) do
            if self:IsO1Table() then
                realValues[value] = true
            else
                table.insert(realValues, value)
            end
        end
    else
        for text, bool in pairs(values) do
            if bool then
                if self:IsO1Table() then
                    realValues[text] = true
                else
                    table.insert(realValues, text)
                end
            end
        end
    end

    return realValues
end

function PANEL:GetSelectedRealValue()

    local text, _ = self:GetSelected()
    local result = text
    if self:NeedsReverseReinterpretation() then
        result = gmodstore:GetRealValue(text, self.variableContainer:GetVariableElements())
        result = result[1] -- only one value
    end
    return result
end
function PANEL:IsReinterpreted()
    return self.interpreted
end

function PANEL:SetReinterpreted(newValue)
    self.reinterpreted = newValue
end

function PANEL:NeedsReverseReinterpretation()
    return self.reverseReinterpretation
end

function PANEL:SetReverseReinterpretation(newValue)
    self.reverseReinterpretation = newValue
end

function PANEL:OnSelect(index, text, data)

    if self:IsMultiSelect() then

        if self:IsFreeWriting() then

            -- If you select it then you want to remove it
            self.values[text] = false
            table.RemoveByValue(self.elements, text)

        else

            self.values[text] = not self.values[text]

        end

        self:RefreshChoices()

        local realValues = self:GetMultiSelectRealValues()

        self.variableContainer:UpdateVariable(realValues)

    else
        local realValue = self:GetSelectedRealValue()

        self.variableContainer:UpdateVariable(realValue)
    end
end


/*
precond: self.values has been changed to a new set of values
postcond: choices have been recreated from scratch

called each time you select something
*/

function PANEL:RefreshChoices()
    if self:IsMultiSelect() then
        self:Clear() -- delete all the choices

        self.valueString = ""
        for _, choice in pairs(self.elements) do
            if self.values[choice] then
                local icon = "icon16/tick.png"
                if self:IsFreeWriting() then
                    icon = "icon16/cross.png"
                end
                self:AddChoice(choice, nil, nil, icon) -- choice with icon
                if self.valueString == "" then
                    self.valueString = choice
                else
                    self.valueString = self.valueString .. ";" .. choice
                end
            else
                self:AddChoice(choice) -- basic choice not checked
            end
        end

        self:SetText(self.valueString)
    end
end

function PANEL:UpdateValue(newValue)
    table.Empty(self.values)

    if self:IsMultiSelect() then

        for _, txt in pairs(newValue) do
            -- If it's a free writing mode then we need to add the elements
            if self:IsFreeWriting() then
                if not table.HasValue(self.elements, txt) then -- Avoid duplication
                    table.insert(self.elements, txt)
                end
            end
            self.values[txt] = true
        end
        self:RefreshChoices()
    else
        if type(newValue) == "table" then newValue = newValue[1] end -- We take the first element if the argument is a table
        for id, txt in pairs(self.Choices) do
            if txt == newValue then
                self:ChooseOptionID(id)
                return
                -- break
            end
        end
    end
    self:UpdateVariableStartup()
end

-- Called when the dropdown is created and the values are set
function PANEL:UpdateVariableStartup()
    if self:IsMultiSelect() then
        local realValues = self:GetMultiSelectRealValues()
        self.variableContainer:UpdateVariable(realValues)
    else
        local realValue = self:GetSelectedRealValue()
        self.variableContainer:UpdateVariable(realValue)
    end
end

function PANEL:AddChoices(choices)
    local textChoices = {}
    if self:IsO1Table() then
        for choice, bool in pairs(choices) do
            self:AddChoice(choice)
            table.insert(textChoices, choice)
        end
    else
        for _, choice in pairs(choices) do
            self:AddChoice(choice)
            table.insert(textChoices, choice)
        end
    end
    self.elements = textChoices
end

vgui.Register("gmodstore.VariableDropdown", PANEL, "DComboBox")