local COLOR = gmodstore.Colors

local PANEL = {}

function PANEL:Init()
    self.variableContainer = self:GetParent()

    -- self:SetMinimumSize(self.variableContainer:GetWide() * 0.75, nil)
    -- self:SetHeight(self.variableContainer:GetTall())
end



function PANEL:Paint(w, h)
   --draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
end

function PANEL:GetVariableContainer()
    return self.variableContainer
end

vgui.Register("gmodstore.VariableRightSpace", PANEL, "DPanel")