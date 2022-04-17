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

        local angleWang = self:Add("DNumberWang")
        angleWang:SetFont("gmodstoreFont:25")
        angleWang:SetTextColor(color_white)
        angleWang:SetMinMax(-180, 180) -- 2^9
        angleWang.Paint = function(s, w, h)
            draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
            s:DrawTextEntryText(color_white, COLOR.bl, color_white)
        end
        angleWang.OnValueChanged = function(s)
            if not self.stackInWork then
                self.stackInWork = true
                self:AngleUpdate(Angle(self.angleP:GetValue(), self.angleY:GetValue(), self.angleR:GetValue()))
                self.stackInWork = false
            end
        end
        angleWang:SetMinimumSize(60, nil)

        angleWang:Dock(LEFT)
        angleWang:DockMargin(0, 8, 10, 8)

        if i == 1 then
            label:SetText("P")
            self.anglePLabel = label
            self.angleP = angleWang
        elseif i == 2 then
            label:SetText("Y")
            self.angleYLabel = label
            self.angleY = angleWang
        elseif i == 3 then
            label:SetText("R")
            self.angleRLabel = label
            self.angleR = angleWang
        end
        label:SizeToContentsX(10)
    end

    self.angleButton = self:Add("DButton")
    self.angleButton:SetFont("gmodstoreFont:25")
    self.angleButton:SetText(gmodstore:GetString("angle_view"))
    self.angleButton:SetTextColor(color_white)
    self.angleButton:SetMinimumSize(250, nil)
    self.angleButton:SizeToContentsX(20)
    self.angleButton:Dock(RIGHT)
    self.angleButton:DockMargin(5, 5, 5, 5)

    self.angleButton.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, COLOR.buttonAction)
        local curColor = gmodstore.PaintFunctions(s)
        s:SetTextColor(curColor)
    end

    local ply = LocalPlayer()
    local renderFrame

    self.angleButton.DoClick = function(s)
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

            self.renderViewFrame.currentVector = ply:GetPos()
            self.renderViewFrame.currentAngle = self.variableContainer:GetVariableValue() or Angle(0, 0, 0)

            self.header = self.renderViewFrame:Add("gmodstore.Header")
            self.header:Dock(TOP)

            self.renderViewPanel = self.renderViewFrame:Add("DPanel")
            self.renderViewPanel:DockMargin(5, 5, 5, 5)
            self.renderViewPanel:Dock(TOP)
            self.renderViewPanel:SetTall(570)

            self:InvalidateParent(true)

            self.renderViewPanel.Paint = function(panel_s, w, h)
                if not IsValid(self) then if IsValid(renderFrame) then renderFrame:Remove() return end end

                draw.RoundedBox(8, 0, 0, w, h, COLOR.basicheader)

                if IsValid(ply) then
                    local frameX, frameY = self.renderViewFrame:GetPos()
                    local panelX, panelY = panel_s:GetPos()
                    local x, y = frameX + panelX, frameY + panelY

                    local angOrig = self.renderViewFrame.currentAngle
                    render.RenderView( {
                        origin = self.renderViewFrame.currentVector,
                        angles = angOrig,
                        x = x, y = y,
                        w = w, h = h
                    } )

                    local text = string.format("Angle (P: %d, Y: %d, R: %d)", angOrig.p, angOrig.y, angOrig.r)
                    surface.SetFont("gmodstoreFont:30")
                    local sizex, sizey = surface.GetTextSize(text)
                    draw.RoundedBox(16, w / 2 - sizex / 2 - 5, 0, sizex + 10, sizey + 10, COLOR.buttonAction)
                    draw.SimpleText(text, "gmodstoreFont:30", w / 2, 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)


                    local posY = 50
                    draw.RoundedBoxEx(16, 0, posY, 230, 120, COLOR.buttonAction, false, true, false, true)
                    draw.SimpleText(string.format("%s: %s (%s %s)", string.format(gmodstore:GetString("increase_value"), "P"), "W", string.format(gmodstore:GetString("or")), "Z"), "gmodstoreFont:20", 5, posY + 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%s: %s", string.format(gmodstore:GetString("decrease_value"), "P"), "S"), "gmodstoreFont:20", 5, posY + 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%s: %s (%s %s)", string.format(gmodstore:GetString("increase_value"), "Y"), "A", string.format(gmodstore:GetString("or")), "Q"), "gmodstoreFont:20", 5, posY + 35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%s: %s", string.format(gmodstore:GetString("decrease_value"), "Y"), "D"), "gmodstoreFont:20", 5, posY + 50, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%s: %s", string.format(gmodstore:GetString("increase_value"), "R"), "SPACE"), "gmodstoreFont:20", 5, posY + 65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%s: %s", string.format(gmodstore:GetString("decrease_value"), "R"), "CTRL"), "gmodstoreFont:20", 5, posY + 80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(string.format("%s: %s", gmodstore:GetString("increase_speed"), "SHIFT"), "gmodstoreFont:20", 5, posY + 95, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                    local speed = 2

                    -- More speed action
                    if input.IsKeyDown(KEY_LSHIFT) then
                        speed = 8
                    end

                    -- Forward / backward actions
                    if input.IsKeyDown(KEY_W) or input.IsKeyDown(KEY_Z) then
                        angOrig:Add(Angle(speed, 0, 0))
                        angOrig:Normalize()
                    end
                    if input.IsKeyDown(KEY_S) then
                        angOrig:Add(Angle(-speed, 0, 0))
                        angOrig:Normalize()
                    end

                    -- Left / right actions
                    if input.IsKeyDown(KEY_A) or input.IsKeyDown(KEY_Q) then
                        angOrig:Add(Angle(0, speed, 0))
                        angOrig:Normalize()
                    end
                    if input.IsKeyDown(KEY_D) then
                        angOrig:Add(Angle(0, -speed, 0))
                        angOrig:Normalize()
                    end

                    if input.IsKeyDown(KEY_SPACE) then
                        angOrig:Add(Angle(0, 0, speed))
                        angOrig:Normalize()
                    end
                    if input.IsKeyDown(KEY_LCONTROL) then
                        angOrig:Add(Angle(0, 0, -speed))
                        angOrig:Normalize()
                    end


                    self.renderViewPanel.currentAngle = angOrig
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
                    CreateLabel(string.format(" %s:  ", gmodstore:GetString("custom_vector")))
                    CreateLabel("Vector(")
                end

                local entry = self.renderViewEntryPanel:Add("DNumberWang")
                entry:Dock(LEFT)
                entry:DockMargin(0, 0, 8, 0)
                entry:SetFont("gmodstoreFont:25")
                entry:SetMinMax(-16777216, 16777216)
                entry:SetDecimals(1)


                entry.Paint = function(ss, w, h)
                    draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
                    ss:DrawTextEntryText(color_white, COLOR.bl, color_white)
                end

                entry.OnValueChanged = function(ss, newVal)
                    local panelParent = self.renderViewEntryPanel
                    if IsValid(panelParent) and IsValid(panelParent.xVec) and IsValid(panelParent.yVec) and IsValid(panelParent.zVec) then
                        self.renderViewFrame.currentVector = Vector(panelParent.xVec:GetValue(), panelParent.yVec:GetValue(), panelParent.zVec:GetValue())
                    end
                end

                if i == 1 then
                    self.renderViewEntryPanel.xVec = entry
                    entry:SetValue(ply:GetPos().x)
                    CreateLabel(",")
                elseif i == 2 then
                    self.renderViewEntryPanel.yVec = entry
                    entry:SetValue(ply:GetPos().y)
                    CreateLabel(",")
                elseif i == 3 then
                    self.renderViewEntryPanel.zVec = entry
                    entry:SetValue(ply:GetPos().z)
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
                        self:AngleUpdate(self.renderViewPanel.currentAngle)
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

function PANEL:AngleUpdate(angle)

    angle.p = math.Clamp(-180, angle.p, 180)
    angle.y = math.Clamp(-180, angle.y, 180)
    angle.r = math.Clamp(-180, angle.r, 180)

    self.angleP:SetValue(angle.p)
    self.angleY:SetValue(angle.y)
    self.angleR:SetValue(angle.r)

    self.variableContainer:UpdateVariable(angle)
end


function PANEL:UpdateValue(newValue)
    self:AngleUpdate(newValue)
end

vgui.Register("gmodstore.VariableAngle", PANEL, "DPanel")