local COLOR = gmodstore.Colors

local PANEL = {}
function PANEL:Init()
    self.base = self:GetParent()
    self.categories = {}

    self:SetHeight(50)
    self:GetCanvas():SetHeight(50)
    self:GetCanvas():DockPadding(0, 10, 0, 10)

    self.vbar = self:GetVBar()

    self.vbar.Paint = function(s, w, h) end
    self.vbar.btnGrip.Paint = function(s, w, h) end
    self.vbar.btnUp.Paint = function(s, w, h) end
    self.vbar.btnDown.Paint = function(s, w, h) end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, COLOR.rndbox)
end

function PANEL:AddCategory(categoryName)
    categoryName = string.Trim(categoryName)
    if not self.categories[categoryName] then
        local newButton = self:Add("gmodstore.CategoryButton")
        newButton:SetCategory(categoryName)
        newButton:SetText(categoryName)
        newButton:Dock(LEFT)
        newButton:DockMargin(8, 0, 0, 0)
        newButton:SizeToContentsX(20)

        self.categories[categoryName] = newButton
    end
end

function PANEL:Reset()
    self:Clear()
    table.Empty(self.categories)
end

function PANEL:SetDefaultCategory(categoryName)
    if self.categories[categoryName] then
        self.categories[categoryName]:Select()
    end
end


vgui.Register("gmodstore.CategoryBar", PANEL, "DScrollPanel")