local COLOR = gmodstore.Colors

local PANEL = {}

function PANEL:Init()
    self.rightSpace = self:GetParent()
    self.variableContainer = self.rightSpace:GetVariableContainer()


    self:Dock(FILL)
    self:DockMargin(0, 0, 0, 0)

    self:SetFont("gmodstoreFont:25")
    self:SetTextColor(color_white)

    self:SetMinimumSize(250, 0)
    self:SetWidth(self.variableContainer:GetWide() * 0.6)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
    self:DrawTextEntryText(color_white, COLOR.bl, color_white)
end

function PANEL:OnValueChanged(newVal)
    newVal = tonumber(newVal)
	if newVal > self:GetMax() then self:SetValue(self:GetMax()) end
    if newVal < self:GetMin() then self:SetValue(self:GetMin()) end
    self.variableContainer:UpdateVariable(newVal)
end


function PANEL:UpdateValue(newValue)
    self:SetValue(newValue)
end

vgui.Register("gmodstore.VariableNumberWang", PANEL, "DNumberWang")