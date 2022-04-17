local COLOR = gmodstore.Colors

local PANEL = {}

function PANEL:Init()
    self.rightSpace = self:GetParent()
    self.variableContainer = self.rightSpace:GetVariableContainer()

    self.structureFrame = nil

    self:Dock(RIGHT)
    -- self:DockMargin(8, 8, 8, 8)

    self:SetWidth(self.rightSpace:GetWide())
    self:SetTall(self.variableContainer:GetTall())

    self.openStruct = self:Add("DButton")
    self.openStruct:SetFont("gmodstoreFont:25")
    self.openStruct:SetText(gmodstore:GetString("open_structure"))
    self.openStruct:SetTextColor(color_white)

    self.openStruct:SetMinimumSize(400, nil)
    self.openStruct:Dock(RIGHT)
    self.openStruct:DockMargin(8, 8, 8, 8)

    self.openStruct.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, COLOR.buttonAction)
        local col = gmodstore.PaintFunctions(s)
        s:SetTextColor(col)
    end

    self.openStruct.DoClick = function(s)
        if IsValid(self.structureFrame) then
            self.structureFrame:MakePopup()
        else
            self.structureFrame = vgui.Create("gmodstore.VariableStructureFrame")
            self.structureFrame:SetStructParent(self)
            local variableContent = self.variableContainer:GetVariable()
            self.structureFrame:GenerateStructure(variableContent.Structure, variableContent.Value, variableContent.Default, variableContent.OneOccurence)
        end
    end
end



function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
end

function PANEL:UpdateStruct(newValues)
    self.variableContainer:UpdateVariable(newValues)
end

vgui.Register("gmodstore.VariableStructure", PANEL, "DPanel")


local PANEL = {}

function PANEL:Init()
    self.variableParent = nil
    self.structure = nil
    self.structureVariables = {}
    self.nbOccurence = 0
    self.occurences = {}
    self.values = {}
end

function PANEL:Close()
    self:AlphaTo(0, 0.2, 0, function()
        self:Remove()
    end)
end

function PANEL:GenerateStructure(struct, values, defaults, oneOccurence)
    self:SetSize(800, 450)
    self:MakePopup()
    self:Center()

    self.structure = struct
    self.oneOccurence = oneOccurence

    self.header = self:Add("gmodstore.Header")
    self.header:Dock(TOP)

    self.docker = self:Add("gmodstore.Docker")
    self.docker:Dock(FILL)
    -- self.docker:DockMargin(5, 5, 5, 5)

    self.bottomSpace = self:Add("DPanel")
    self.bottomSpace:Dock(BOTTOM)
    self.bottomSpace.Paint = function(s, w, h)

    end
    self.bottomSpace:SetTall(40)

    if not oneOccurence then

        self.addOccurence = self.bottomSpace:Add("DButton")
        self.addOccurence:Dock(LEFT)
        self.addOccurence:DockMargin(5, 5, 5, 5)
        self.addOccurence:SetFont("gmodstoreFont:25")
        self.addOccurence:SetText(gmodstore:GetString("add_occurence"))
        self.addOccurence:SetWide(200)

        self.addOccurence.Paint = function(s, w, h)
            local col = gmodstore.PaintFunctions(s)
            s:SetTextColor(col)

            draw.RoundedBox(8, 0, 0, w, h, COLOR.bl)
        end

        self.addOccurence.DoClick = function(s)
            self:CreateDefaultStructure()
        end

    end

    self.apply = self.bottomSpace:Add("DButton")
    self.apply:Dock(RIGHT)
    self.apply:DockMargin(5, 5, 5, 5)
    self.apply:SetFont("gmodstoreFont:25")
    self.apply:SetText(gmodstore:GetString("save"))
    self.apply:SetWide(200)

    self.apply.Paint = function(s, w, h)
        local col = gmodstore.PaintFunctions(s)
        s:SetTextColor(col)
        draw.RoundedBox(8, 0, 0, w, h, COLOR.g)
    end

    self.apply.DoClick = function(s)
        local result = self:GetResultStructure()

        if IsValid(self.variableParent) then
            self.variableParent:UpdateStruct(result)
        end
        self:Close()
    end

    -- self:CreateDefaultStructure()

    local tableToUse

    if values != nil then
        tableToUse = values
    elseif defaults != nil then
        tableToUse = defaults
    end

    if tableToUse != nil then
        local defaultAmountOccurences = table.Count(tableToUse)
        if defaultAmountOccurences >= 1 then
            timer.Simple(0, function()
                for key, value in pairs(tableToUse) do
                    self:CreateDefaultStructure()
                    for theVarName, theValue in pairs(tableToUse[key]) do
                        self.occurences[key][theVarName]:UpdateVariable(theValue, true)
                    end
                end
            end)
        end
    end
end

function PANEL:SetStructParent(parent)
    self.variableParent = parent
end

function PANEL:CreateDefaultStructure()

    local content = {}

    self.nbOccurence = self.nbOccurence + 1

    self.structureVariables[self.nbOccurence] = {}
    local occurence = self.docker:Add("gmodstore.VariableOccurence")
    occurence:SetOccurenceNumber(self.nbOccurence)
    occurence:SetOccurenceIdentifier(self.nbOccurence) -- could be a string
    if self.nbOccurence > 1 then
        occurence:CreateDeleteOccurenceBtn()
    end

    content["$$~~"] = occurence -- $$~~ is the default occurence to have an origin to duplicate from

    self:InvalidateParent(true)

    if IsValid(self) then
        for varName, variable in pairs(self.structure) do
            local variableContainer = self.docker:Add("gmodstore.VariableContainer")
            local variableCopy = table.Copy(variable)
            variableCopy.Name = varName
            variableContainer:SetVariable(variableCopy) -- category??? :xxx

            content[varName] = variableContainer
        end

        table.insert(self.occurences, self.nbOccurence, content)
    end

end

function PANEL:DeleteOccurence(occurenceNumber)
    if occurenceNumber > table.Count(self.occurences) then return end

    for name, panel in pairs(self.occurences[occurenceNumber]) do
        panel:Remove()
    end

    self.occurences[occurenceNumber] = nil

    if self.nbOccurence > occurenceNumber then
        for i = occurenceNumber + 1, self.nbOccurence do
            local tab = self.occurences[i]
            local occurenceContent = tab["$$~~"]
            if IsValid(occurenceContent) then
                occurenceContent:SetOccurenceNumber(i-1)
                occurenceContent:SetOccurenceIdentifier(i-1) -- could be a string
            end
            self.occurences[i-1] = self.occurences[i]
            if i == self.nbOccurence then
                table.remove(self.occurences, i)
            end
        end
    end

    self.nbOccurence = self.nbOccurence - 1
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, COLOR.rndbox_opaque)
end

function PANEL:GetResultStructure()
    local result = {}
    if self.nbOccurence > 1 then
        for key, panels in pairs(self.occurences) do
            local content = {}

            for name, panel in pairs(panels) do
                if not IsValid(panel) then continue end
                if name != "$$~~" then
                    content[name] = panel:GetVariableValue()
                end
            end

            table.insert(result, key, content)
        end
    else
        local panels = self.occurences[1]

        for name, panel in pairs(panels) do
            if name != "$$~~" then
                result[name] = panel:GetVariableValue()
            end
        end
    end
    return result
end

vgui.Register("gmodstore.VariableStructureFrame", PANEL, "EditablePanel")



local PANEL = {}
AccessorFunc(PANEL, "occurencenumber", "OccurenceNumber")
AccessorFunc(PANEL, "occurenceidentifier", "OccurenceIdentifier")

function PANEL:Init()
    self.docker = self:GetParent()
    self.structFrame = self.docker:GetParent():GetParent()

    self:Dock(TOP)
    self:DockMargin(5, 5, 5, 0)

    self:SetMinimumSize(150, 0)
    self:SetWidth(self.docker:GetWide())
end

function PANEL:CreateDeleteOccurenceBtn()
    self.delete = self:Add("DButton")
    self.delete:Dock(RIGHT)
    self.delete:SetWide(40)
    self.delete:SetFont("gmodstoreFont:25")
    self.delete:SetText("X")

    self.delete.Paint = function(s, w, h)
        local col = gmodstore.PaintFunctions(s)
        s:SetTextColor(col)
        draw.RoundedBox(8, 0, 0, w, h, COLOR.rl)
    end

    self.delete.DoClick = function(s)
        self.structFrame:DeleteOccurence(self:GetOccurenceNumber())
    end

end

function PANEL:Paint(w, h)
    -- draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
    if self:GetOccurenceIdentifier() then
        draw.SimpleText(string.format("Occurence %s", self:GetOccurenceIdentifier()), "gmodstoreFont:25", 5, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end


vgui.Register("gmodstore.VariableOccurence", PANEL, "DPanel")