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

    self.circlePosX = 0
end

function PANEL:Paint(w, h)
    local state = self:GetChecked()
    local colBackground
    if state then
        colBackground = COLOR.bl
    else
        colBackground = COLOR.rl
    end

    draw.RoundedBox(16, 0, 0, w, h, colBackground)

    self.circlePosX = Lerp(0.05, self.circlePosX, state and w * 0.85 or w * 0.05)
    draw.RoundedBox(32, self.circlePosX, h * 0.05, w * 0.1, h * 0.9, COLOR.basicframe)

    if state then
        draw.SimpleText("TRUE", "gmodstoreFont:25", 20, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText("FALSE", "gmodstoreFont:25", w - 20, h / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
end

function PANEL:OnChange(newVal)
    self.variableContainer:UpdateVariable(newVal)
end


function PANEL:UpdateValue(newValue)
    self:SetValue(newValue)
end

vgui.Register("gmodstore.VariableToggle", PANEL, "DCheckBox")