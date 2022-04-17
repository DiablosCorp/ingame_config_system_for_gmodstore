local COLOR = gmodstore.Colors

local PANEL = {}

function PANEL:Init()
    self.label = self:GetParent()
    self.variableContainer = self.label:GetParent()

    self.tip = ""

    self:SetWidth(500)
    self:SetHeight(50)


end

function PANEL:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, COLOR.basicframe)
    draw.RoundedBox(0, 2, 2, w - 4, h - 4, COLOR.basicframe)
end

function PANEL:GetTip()
    return self.tip
end

/*
    Set the variable tip
    We consider two different tips:
        - a basic tip with a long sentence that we'll wrap and auto stretch vertically using a label
            * for the height, we will calculate it approximately based on the number of characters
        - a tip with \n in it in some places
            * for the height, we can GetTextSize() the text and get its height size
        Then we take the higher size between the two possibilities
        We consider not using a mix between long sentences and \n, or the tip height could be weird anyway
*/

function PANEL:SetTipText(newTip)
    local defaultTip = false
    if not newTip or newTip == "" then
        defaultTip = true
        newTip = gmodstore:GetString("default_tip")
    end
    if IsValid(self.textTip) then
        self.textTip:Remove()
    end

    local fontName = "gmodstoreFont:25"
    if defaultTip then
        fontName = fontName .. ":I"
    end

    surface.SetFont(fontName)
    local sizex, sizey = surface.GetTextSize(newTip)

    sizex = sizex + 10
    sizey = sizey + 10


    local text = self:Add("DLabel")
    text:DockMargin(5, 5, 5, 5)
    text:Dock(FILL)
    text:SetFont(fontName)
    text:SetText(newTip)
    text:SetWrap(true)
    text:SetAutoStretchVertical(true)
    text:InvalidateLayout(true)
    self.textTip = text

    local sizeWithLabelCalc = 50 + ((#newTip - 50) / 50) * 25
    self:SetHeight(math.max(sizey, sizeWithLabelCalc))

    self.tip = newTip
end

vgui.Register("gmodstore.VariableTip", PANEL, "DPanel")