local COLOR = gmodstore.Colors

local PANEL = {}

function PANEL:Init()
    self.rightSpace = self:GetParent()
    self.variableContainer = self.rightSpace:GetVariableContainer()

    self.stackInWork = false


    self:Dock(FILL)
    -- self:DockMargin(5, 5, 5, 5)

    self:SetMinimumSize(250, 0)
    self:SetWidth(self.variableContainer:GetWide() * 0.6)
end

function PANEL:InitRGBA(amountButtons)

    for i = 1, amountButtons do
        local label = self:Add("DLabel")
        label:SetFont("gmodstoreFont:25")
        label:SetTextColor(color_white)

        label:Dock(LEFT)
        label:DockMargin(2, 8, 10, 8)

        local colorWang = self:Add("DNumberWang")
        colorWang:SetFont("gmodstoreFont:25")
        colorWang:SetTextColor(color_white)
        colorWang:SetMinMax(0, 255)
        colorWang.Paint = function(s, w, h)
            draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
            s:DrawTextEntryText(color_white, COLOR.bl, color_white)
        end
        colorWang.OnValueChanged = function(s)
            if not self.stackInWork then
                self.stackInWork = true
                self:ColorUpdate(Color(self.colorR:GetValue(), self.colorG:GetValue(), self.colorB:GetValue(), IsValid(self.colorA) && self.colorA:GetValue() || 255))
                self.stackInWork = false
            end
        end
        colorWang:SetMinimumSize(60, nil)

        colorWang:Dock(LEFT)
        colorWang:DockMargin(0, 8, 10, 8)

        if i == 1 then
            label:SetText("R")
            self.colorRLabel = label
            self.colorR = colorWang
        elseif i == 2 then
            label:SetText("G")
            self.colorGLabel = label
            self.colorG = colorWang
        elseif i == 3 then
            label:SetText("B")
            self.colorBLabel = label
            self.colorB = colorWang
        elseif i == 4 then -- optional
            label:SetText("A")
            self.colorALabel = label
            self.colorA = colorWang
        end
        label:SizeToContentsX(10)
    end

    self.colorPreview = self:Add("DColorButton")
    self.colorPreview:Dock(RIGHT)
    self.colorPreview:DockMargin(5, 5, 5, 5)

    self.colorButton = self:Add("DButton")
    self.colorButton:SetFont("gmodstoreFont:25")
    self.colorButton:SetText(gmodstore:GetString("open_color_palette"))
    self.colorButton:SetTextColor(color_white)
    self.colorButton:SetMinimumSize(250, nil)
    self.colorButton:SizeToContentsX(20)
    self.colorButton:Dock(RIGHT)
    self.colorButton:DockMargin(5, 5, 5, 5)

    self.colorButton.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, COLOR.buttonAction)
        local curColor = gmodstore.PaintFunctions(s)
        s:SetTextColor(curColor)
    end

    self.colorButton.DoClick = function(s)
        if IsValid(self.colorPaletteFrame) then
            self.colorPaletteFrame:Remove()
        else
            self.colorPaletteFrame = vgui.Create("DPanel")
            self.colorPaletteFrame:SetSize(200, 200)

            local xPos, yPos = self.colorButton:LocalToScreen(0, 0)

            yPos = yPos - 200

            self.colorPaletteFrame:SetPos(xPos, yPos)
            self.colorPaletteFrame:MakePopup()

            self.colorPaletteFrame.Paint = function(ss, w, h)
                local cursorPaletteX, cursorPaletteY = ss:CursorPos()
                if cursorPaletteX < -10 or cursorPaletteX > w or cursorPaletteY < -10 or cursorPaletteY > h then
                    local cursorButtonX, cursorButtonY = self.colorButton:CursorPos()
                    if cursorButtonX < -10 or cursorButtonY < -10 then
                        ss:Remove()
                    end
                end
            end

            self.colorPalette = self.colorPaletteFrame:Add("DColorMixer")
            self.colorPalette.ValueChanged = function(ss, col)
                if IsValid(self) then
                    if not self.stackInWork then
                        self.stackInWork = true
                        self:ColorUpdate(col)
                        self.stackInWork = false
                    end
                end
            end

        end
    end

end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
end

function PANEL:ColorUpdate(color)
    self.colorR:SetValue(color.r)
    self.colorG:SetValue(color.g)
    self.colorB:SetValue(color.b)
    if IsValid(self.colorA) then
        self.colorA:SetValue(color.a)
    end

    self.colorPreview:SetColor(color)

    self.variableContainer:UpdateVariable(color)
end

function PANEL:UpdateValue(newValue)
    self:ColorUpdate(newValue)
end


vgui.Register("gmodstore.VariableColor", PANEL, "DPanel")