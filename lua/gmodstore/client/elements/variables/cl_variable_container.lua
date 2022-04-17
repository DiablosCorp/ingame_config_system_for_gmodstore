local COLOR = gmodstore.Colors

local PANEL = {}
function PANEL:Init()
    self.tblButtons = {}
    -- self:GetParent() returns the canvas the docker is attached to, not the docker frame
    self.docker = self:GetParent():GetParent()
    self.base = self.docker:GetParent()
    self:Dock(TOP)
    self:DockMargin(8, 8, 8, 0)
    self:SetHeight(self.docker:GetTall() / 15)
    self:SetMinimumSize(0, 50)

    self.variable = nil
    self.variableVGUI = nil
    self.category = "Default"

    self:InvalidateParent(true)

    local sizex = self:GetSize()

    -- TO TEST
    local dockerSize = self.docker:GetSize()

    self.leftSpace = self:Add("gmodstore.VariableLeftSpace")
    self.leftSpace:Dock(LEFT)
    self.leftSpace:SetWidth(dockerSize * 0.3)
    self.leftSpace:DockMargin(0, 0, 200, 0)

    self.label = self.leftSpace:Add("gmodstore.VariableLabel")
    self.label:SetFontSize(20)

    self.rightSpace = self:Add("gmodstore.VariableRightSpace")
    self.rightSpace:Dock(RIGHT)
    self.rightSpace:SetWidth(dockerSize * 0.65)
    self.rightSpace:DockMargin(5, 0, 0, 0)
end

function PANEL:Paint(w, h)
    -- draw.RoundedBox(8, 0, 0, w, h, COLOR.rndbox)
end

function PANEL:ShowResetButton(bool)
    if bool then
        self.reset = self.leftSpace:Add("gmodstore.VariableReset")
    end
end

function PANEL:SetVariable(variable)

    self.variable = variable

    self.label:SetTitle(variable.Name)
    local realTip = variable.Tip
    -- if the tip is a table, then we'll only take the good language for it
    if type(realTip) == "table" then
        local lang = gmodstore:GetLanguage()
        realTip = realTip[lang]
    end
    self.label.tip:SetTipText(realTip)

    local variableType = gmodstore:GetTypeOfVariable(variable)
    if variableType == "table" then
        if variable.Structure != nil then

            self:CreateComplexStructure()

        else

            self:CreateDropdown()

        end
    elseif variableType == "boolean" then

        self:CreateToggle()

    elseif variableType == "number" then

        self:CreateNumberWang(variable.MinRange or 0, variable.MaxRange or 4294967295)

    elseif variableType == "string" then

        self:CreateTextEntry()

    elseif variableType == "color" then

        self:CreateColor(variable.ShowAlpha)

    elseif variableType == "vector" then

        self:CreateVector()

    elseif variableType == "angle" then

        self:CreateAngle()

    end
end


function PANEL:GetVariable()
    return self.variable
end

function PANEL:GetVariableName()
    return self.variable.Name
end

function PANEL:GetVariableValue()
    return self.variable.Value
end

function PANEL:GetVariableElements()
    return self.variable.Elements
end

function PANEL:GetVariableDefault()
    return self.variable.Default
end

function PANEL:GetCategory()
    return self.variable.Category
end

-- Update the variable when sending data - if callback is set to true, then it will also update VGUI information

function PANEL:UpdateVariable(newValue, callback)
    self.variable.Value = newValue


    if callback then
        self.variableVGUI:UpdateValue(newValue)
    end

    -- We update the variable for the "Cond" parameter
    if not self.docker then return end
    if not self.docker.base then return end
     -- if self.docker.base == "gmodstore.VariableStructFrame", we don't call UpdateVariable
    if self.docker.base:GetName() == "gmodstore.Frame" then
        self.docker:UpdateVariable(self.variable)
    end
end

function PANEL:CreateDropdown()
    self.variableVGUI = self.rightSpace:Add("gmodstore.VariableDropdown")

    local multiSelect = not (self.variable.SingleRange == nil or self.variable.SingleRange)

    self.variableVGUI:SetMultiSelect(multiSelect)
    self.variableVGUI:SetFreeWriting(self.variable.FreeWriting)
    self.variableVGUI:SetO1Table(self.variable.O1Table)

    local choices = self:GetVariable().Elements or {}

    local needReinterpretation = gmodstore:IsReinterpretedElement(choices)
    self.variableVGUI:SetReinterpreted(needReinterpretation)

    local needReverseReinterpretation = gmodstore:NeedsReverseInterpretation(choices)
    self.variableVGUI:SetReverseReinterpretation(needReverseReinterpretation)

    if needReinterpretation then
        choices = gmodstore:GetReinterpretedElement(choices)
        if self.variable.O1Table then
            choices = gmodstore:TransformToO1Array(choices)
        end
    end

    self.variableVGUI:AddChoices(choices)

    self:InitValue()
end


function PANEL:CreateComplexStructure()
    self.variableVGUI = self.rightSpace:Add("gmodstore.VariableStructure")

    -- Update the variable to not be nil when saving!
    local var = self:GetVariable()
    if var.Value != nil then
        self:UpdateVariable(var.Value)
    elseif var.Default != nil then
        self:UpdateVariable(var.Default)
    end

    -- self:InitValue()
end

function PANEL:CreateToggle()
    self.variableVGUI = self.rightSpace:Add("gmodstore.VariableToggle")

    self:InitValue()
end


function PANEL:CreateNumberWang(minRange, maxRange)
    self.variableVGUI = self.rightSpace:Add("gmodstore.VariableNumberWang")

    self.variableVGUI:SetMinMax(minRange, maxRange)
    -- self.variableVGUI:HideWang()

    self:InitValue()
end

function PANEL:CreateTextEntry()
    self.variableVGUI = self.rightSpace:Add("gmodstore.VariableTextEntry")

    self:InitValue()
end


function PANEL:CreateColor(showAlpha)
    self.variableVGUI = self.rightSpace:Add("gmodstore.VariableColor")
    -- Init 3 or 4 buttons depending on the showAlpha variable
    if showAlpha == nil or showAlpha then
        self.variableVGUI:InitRGBA(4)
    else
        self.variableVGUI:InitRGBA(3)
    end

    self:InitValue()
end

function PANEL:CreateVector()
    self.variableVGUI = self.rightSpace:Add("gmodstore.VariableVector")

    self:InitValue()
end


function PANEL:CreateAngle()
    self.variableVGUI = self.rightSpace:Add("gmodstore.VariableAngle")

    self:InitValue()
end

function PANEL:GetVariableVGUI()
    return self.variableVGUI
end

/*
    Set the default value when creating the panel (the default value is the value on the server, or a default if value is unset)
    If the value is set and it needs to be a O1 Table, then we transform the Value table in a ON Array
*/

function PANEL:InitValue()
    local var = self:GetVariable()
    if var.Value != nil then
        local varVGUI = self:GetVariableVGUI()
        local val = var.Value
        if isfunction(varVGUI.NeedsReverseReinterpretation) and varVGUI:NeedsReverseReinterpretation() then
            val = gmodstore:GetTextValue(val, self:GetVariableElements())
        end
        if isfunction(varVGUI.IsO1Table) and varVGUI:IsO1Table() then
            val = gmodstore:TransformToONArray(val)
        end
        self.variableVGUI:UpdateValue(val)
    elseif var.Default != nil then
        self.variableVGUI:UpdateValue(var.Default)
    end
end

function PANEL:UpdateToDefaultValue()
    local var = self:GetVariable()
    if var.Default != nil then
        self.variableVGUI:UpdateValue(var.Default)
    end
end


vgui.Register("gmodstore.VariableContainer", PANEL, "DPanel")

