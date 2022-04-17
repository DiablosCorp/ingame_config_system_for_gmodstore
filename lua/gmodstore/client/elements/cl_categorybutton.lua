local COLOR = gmodstore.Colors

local PANEL = {}

function PANEL:Init()
    self.categoryBar = self:GetParent():GetParent()
    self.base = self.categoryBar:GetParent()
    self:SetHeight(self.categoryBar:GetTall() * 0.8)
    self.isSelected = false
    self.categoryName = "Default"

    self:SetFont("gmodstoreFont:25")
    self:SetTextColor(color_white)
end

function PANEL:SetCategory(categoryName)
    self.categoryName = categoryName
end

function PANEL:GetCategory()
    return self.categoryName
end


function PANEL:Paint(w, h)
    local curColor = gmodstore.PaintFunctions(self)
    self:SetTextColor(curColor)
    if self.isSelected then
        draw.RoundedBox(8, 0, 0, w, h, COLOR.g)
    else
        draw.RoundedBox(8, 0, 0, w, h, COLOR.bl)
    end
end

function PANEL:DoClick()
    if not self.isSelected then
        self:Select()
    else
        self:Unselect()
    end
end

function PANEL:Select()
    self.base:UpdateVariablesShown(self:GetCategory())
    self.isSelected = true
end


function PANEL:Unselect()
    self.base:UpdateVariablesShown("")
    self.isSelected = false
end

vgui.Register("gmodstore.CategoryButton", PANEL, "DButton")