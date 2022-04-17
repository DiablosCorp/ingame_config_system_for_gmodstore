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

    for i = 1, 3 do
        local label = self:Add("DLabel")
        label:SetFont("gmodstoreFont:25")
        label:SetTextColor(color_white)

        label:Dock(LEFT)
        label:DockMargin(2, 8, 10, 8)

        local vectorWang = self:Add("DNumberWang")
        vectorWang:SetFont("gmodstoreFont:25")
        vectorWang:SetTextColor(color_white)
        vectorWang:SetMinMax(-16777216, 16777216) -- 2^24
        vectorWang.Paint = function(s, w, h)
            draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
            s:DrawTextEntryText(color_white, COLOR.bl, color_white)
        end
        vectorWang.OnValueChanged = function(s)
            if not self.stackInWork then
                self.stackInWork = true
                self:VectorUpdate(Vector(self.vectorX:GetValue(), self.vectorY:GetValue(), self.vectorZ:GetValue()))
                self.stackInWork = false
            end
        end
        vectorWang:SetMinimumSize(60, nil)

        vectorWang:Dock(LEFT)
        vectorWang:DockMargin(0, 8, 10, 8)

        if i == 1 then
            label:SetText("X")
            self.vectorXLabel = label
            self.vectorX = vectorWang
        elseif i == 2 then
            label:SetText("Y")
            self.vectorYLabel = label
            self.vectorY = vectorWang
        elseif i == 3 then
            label:SetText("Z")
            self.vectorZLabel = label
            self.vectorZ = vectorWang
        end
        label:SizeToContentsX(10)
    end

    self.vectorButton = self:Add("DButton")
    self.vectorButton:SetFont("gmodstoreFont:25")
    self.vectorButton:SetText(gmodstore:GetString("vector_view"))
    self.vectorButton:SetTextColor(color_white)
    self.vectorButton:SetMinimumSize(250, nil)
    self.vectorButton:SizeToContentsX(20)
    self.vectorButton:Dock(RIGHT)
    self.vectorButton:DockMargin(5, 5, 5, 5)

    self.vectorButton.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, COLOR.buttonAction)
        local curColor = gmodstore.PaintFunctions(s)
        s:SetTextColor(curColor)
    end

    local ply = LocalPlayer()
    local renderFrame

    self.vectorButton.DoClick = function(s)
        if IsValid(self.renderViewFrame) then
            self.renderViewFrame:Remove()
        else
            self.renderViewFrame = vgui.Create("DFrame")
            self.renderViewFrame:ShowCloseButton(false)
            self.renderViewFrame:SetTitle("")
            self.renderViewFrame:SetSize(700, 700)
            self.renderViewFrame:SetPos(20, 20)
            self.renderViewFrame:DockMargin(0, 0, 0, 0)
            self.renderViewFrame:DockPadding(0, 0, 0, 0)
            self.renderViewFrame:MakePopup()
            self.renderViewFrame.Paint = function(ss, w, h)
                draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
            end
            renderFrame = self.renderViewFrame

            self.renderViewFrame.currentVector = self.variableContainer:GetVariableValue() or Vector(0, 0, 0)
            self.renderViewFrame.currentAngle = Angle(0, 0, 0)

            self.header = self.renderViewFrame:Add("gmodstore.Header")
            self.header:Dock(TOP)

            self.renderViewPanel = self.renderViewFrame:Add("DPanel")
            self.renderViewPanel:DockMargin(5, 5, 5, 5)
            self.renderViewPanel:Dock(TOP)
            self.renderViewPanel:SetTall(570)

            self.renderViewPanel.Paint = function(panel_s, w, h)
                if not IsValid(self) then if IsValid(renderFrame) then renderFrame:Remove() return end end

                if IsValid(ply) then
                    local frameX, frameY = self.renderViewFrame:GetPos()
                    local panelX, panelY = panel_s:GetPos()
                    local x, y = frameX + panelX, frameY + panelY

                    local vecOrig = self.renderViewFrame.currentVector
                    render.RenderView( {
                        origin = vecOrig,
                        angles = self.renderViewFrame.currentAngle,
                        x = x, y = y,
                        w = w, h = h
                    } )

                    local text = string.format("Vector (X: %d, Y: %d, Z: %d)", vecOrig.x, vecOrig.y, vecOrig.z)
                    surface.SetFont("gmodstoreFont:30")
                    local sizex, sizey = surface.GetTextSize(text)
                    draw.RoundedBox(16, w / 2 - sizex / 2 - 5, 0, sizex + 10, sizey + 10, COLOR.buttonAction)
                    draw.SimpleText(text, "gmodstoreFont:30", w / 2, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

                    local posY = 50
                    draw.RoundedBoxEx(16, 0, posY, 230, 120, COLOR.buttonAction, false, true, false, true)
                    draw.SimpleText(string.format("%s: %s (%s %s)", string.format(gmodstore:GetString("increase_value"), "X"), "W", string.format(gmodstore:GetString("or")), "Z"), "gmodstoreFont:20", 5, posY + 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%s: %s", string.format(gmodstore:GetString("decrease_value"), "X"), "S"), "gmodstoreFont:20", 5, posY + 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%s: %s (%s %s)", string.format(gmodstore:GetString("increase_value"), "Y"), "A", string.format(gmodstore:GetString("or")), "Q"), "gmodstoreFont:20", 5, posY + 35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%s: %s", string.format(gmodstore:GetString("decrease_value"), "Y"), "D"), "gmodstoreFont:20", 5, posY + 50, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%s: %s", string.format(gmodstore:GetString("increase_value"), "Z"), "SPACE"), "gmodstoreFont:20", 5, posY + 65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%s: %s", string.format(gmodstore:GetString("decrease_value"), "Z"), "CTRL"), "gmodstoreFont:20", 5, posY + 80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%s: %s", gmodstore:GetString("increase_speed"), "SHIFT"), "gmodstoreFont:20", 5, posY + 95, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                    local speed = 2

                    -- More speed action
                    if input.IsKeyDown(KEY_LSHIFT) then
                        speed = 20
                    end

                    -- Forward / backward actions
                    if input.IsKeyDown(KEY_W) or input.IsKeyDown(KEY_Z) then
                        vecOrig:Add(Vector(speed, 0, 0))
                    end
                    if input.IsKeyDown(KEY_S) then
                        vecOrig:Add(Vector(-speed, 0, 0))
                    end

                    -- Left / right actions
                    if input.IsKeyDown(KEY_A) or input.IsKeyDown(KEY_Q) then
                        vecOrig:Add(Vector(0, speed, 0))
                    end
                    if input.IsKeyDown(KEY_D) then
                        vecOrig:Add(Vector(0, -speed, 0))
                    end

                    -- Top / bottom actions
                    if input.IsKeyDown(KEY_SPACE) then
                        vecOrig:Add(Vector(0, 0, speed))
                    end
                    if input.IsKeyDown(KEY_LCONTROL) then
                        vecOrig:Add(Vector(0, 0, -speed))
                    end

                    self.renderViewPanel.currentVector = vecOrig
                end

            end


            self.renderViewEntryPanel = self.renderViewFrame:Add("DPanel")
            self.renderViewEntryPanel.Paint = function(ss, w, h)
                draw.RoundedBox(8, 0, 0, w, h, COLOR.buttonAction)
            end

            self.renderViewEntryPanel:Dock(BOTTOM)
            self.renderViewEntryPanel:DockMargin(5, 0, 5, 5)
            self.renderViewEntryPanel:SetTall(30)


            local function CreateLabel(str)
                local label = self.renderViewEntryPanel:Add("DLabel")
                label:SetFont("gmodstoreFont:25")
                label:SetTextColor(color_white)
                label:SetText(str)
                label:SizeToContents()
                label:Dock(LEFT)
            end

            for i = 1, 3 do
                if i == 1 then
                    CreateLabel(string.format(" %s:  ", gmodstore:GetString("custom_angle")))
                    CreateLabel("Angle(")
                end

                local entry = self.renderViewEntryPanel:Add("DNumberWang")
                entry:Dock(LEFT)
                entry:SetFont("gmodstoreFont:25")
                entry:SetMinMax(-180, 180)
                entry:SetDecimals(1)
                entry:SetValue(0)

                entry.Paint = function(ss, w, h)
                    draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
                    ss:DrawTextEntryText(color_white, COLOR.bl, color_white)
                end

                entry.OnValueChanged = function(ss, newVal)
                    local panelParent = self.renderViewEntryPanel
                    if IsValid(panelParent) and IsValid(panelParent.pAng) and IsValid(panelParent.yAng) and IsValid(panelParent.rAng) then
                        self.renderViewFrame.currentAngle = Angle(panelParent.pAng:GetValue(), panelParent.yAng:GetValue(), panelParent.rAng:GetValue())
                    end
                end

                if i == 1 then
                    self.renderViewEntryPanel.pAng = entry
                    CreateLabel(",")
                elseif i == 2 then
                    self.renderViewEntryPanel.yAng = entry
                    CreateLabel(",")
                elseif i == 3 then
                    self.renderViewEntryPanel.rAng = entry
                    CreateLabel(")")
                end

            end


            self.renderViewButton = self.renderViewFrame:Add("DButton")

            self.renderViewButton:SetFont("gmodstoreFont:25")
            self.renderViewButton:SetText(gmodstore:GetString("update_values"))
            self.renderViewButton:SetTextColor(color_white)

            self.renderViewButton:Dock(BOTTOM)
            self.renderViewButton:DockMargin(5, 5, 5, 5)
            self.renderViewButton:SetTall(30)

            self.renderViewButton.Paint = function(button_s, w, h)
                draw.RoundedBox(8, 0, 0, w, h, COLOR.bl)
                local curColor = gmodstore.PaintFunctions(button_s)
                button_s:SetTextColor(curColor)
            end

            self.renderViewButton.DoClick = function(button_s)
                if IsValid(self) then
                    if not self.stackInWork then
                        self.stackInWork = true
                        self:VectorUpdate(self.renderViewPanel.currentVector)
                        self.stackInWork = false
                        self.renderViewFrame:AlphaTo(0, 0.2, 0, function()
                            self.renderViewFrame:Remove()
                        end)
                    end
                end
            end
        end
    end
end



function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
end

function PANEL:VectorUpdate(vector)
    self.vectorX:SetValue(vector.x)
    self.vectorY:SetValue(vector.y)
    self.vectorZ:SetValue(vector.z)


    self.variableContainer:UpdateVariable(vector)
end

function PANEL:UpdateValue(newValue)
    self:VectorUpdate(newValue)
end

vgui.Register("gmodstore.VariableVector", PANEL, "DPanel")