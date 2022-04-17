local COLOR = gmodstore.Colors

local PANEL = {}
AccessorFunc(PANEL, "title", "Title")

function PANEL:Init()
    self.variableContainer = self:GetParent()
    self:SetFontSize(25)

    self:Dock(FILL)
    self:DockMargin(0, 0, 0, 0)

    self:SetMinimumSize(150, 0)
    self:SetWidth(self.variableContainer:GetWide() * 0.3)

    self.tip = self:Add("gmodstore.VariableTip")
    self.tip:SetVisible(false)

    self:SetTooltipPanel(self.tip)
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(8, 0, 0, w, h, COLOR.basicframe, false, true, false, true)
    draw.SimpleText(self:GetTitle(), self.font, 5, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:SetFontSize(newFontSize)
    self.font = "gmodstoreFont:" .. newFontSize
end


vgui.Register("gmodstore.VariableLabel", PANEL, "DPanel")