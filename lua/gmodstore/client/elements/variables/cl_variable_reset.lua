local COLOR = gmodstore.Colors

local PANEL = {}

function PANEL:Init()
    self.leftSpace = self:GetParent()
    self.variableContainer = self.leftSpace:GetParent()

    self:Dock(LEFT)
    self:DockMargin(0, 0, 0, 4)

    self:SetMinimumSize(30, 0)
    self:SetWidth(self.leftSpace:GetWide() * 0.1)

    self:SetFont("gmodstoreFont:25")
    self:SetText("  ♻")
end



function PANEL:Paint(w, h)
    local curColor = gmodstore.PaintFunctions(self)
    self:SetTextColor(curColor)
    draw.RoundedBoxEx(8, 0, 0, w, h, COLOR.basicframe, true, false, true, false)
end

function PANEL:DoClick()
    self.variableContainer:UpdateToDefaultValue()
end

function PANEL:GetVariableContainer()
    return self.variableContainer
end

vgui.Register("gmodstore.VariableReset", PANEL, "DButton")