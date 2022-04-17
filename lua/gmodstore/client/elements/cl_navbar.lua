local COLOR = gmodstore.Colors

local PANEL = {}

function PANEL:Init()
    self.nav = self:GetParent():GetParent() -- Panel is a child of gmodstore.Navbar
    self.base = self.nav:GetParent()

    self:Dock(TOP)
    self:DockMargin(0, 0, 0, 5)
    self:SetHeight(60)
    self:SetText("")

    self.addon = nil

    self.chosenColor = COLOR.bl


    self.beginAnimation = 0
    self.endAnimation = 0

    self.OnCursorEntered = function(s)
        self.beginAnimation = CurTime()
    end
    self.OnCursorExited = function(s)
        self.endAnimation = CurTime()
    end

    self.isEnabled = false
end

function PANEL:Paint(w, h)

    if self.isEnabled then
        draw.RoundedBox(8, 0, 0, 5, h, COLOR.gl)
        draw.RoundedBoxEx(8, 5, 0, w - 5, h, COLOR.basicheader, false, true, false, true)
    else
        draw.RoundedBoxEx(8, 0, 0, w, h, COLOR.rndbox, false, true, false, true)
    end


    draw.SimpleText(self:GetAddonName(), "gmodstoreFont:25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if not self.isEnabled then
        local curtime = CurTime()
        surface.SetDrawColor(self.chosenColor)

        if self.endAnimation != 0 then
            local val = curtime - self.endAnimation
            surface.DrawRect(0, 0, 5 - 20 * val, h)
            if val >= 0.25 then self.beginAnimation, self.endAnimation = 0, 0 end
        elseif self.beginAnimation != 0 then
            local val = math.min(curtime - self.beginAnimation, 1) * 5
            surface.DrawRect(0, 0, math.min(20 * val, 5), h)
        end
    end
end

function PANEL:DoClick()
    if not self.isEnabled then
        self.base:SetActiveAddon(self.addon)

        for _, buttons in pairs(self.nav.buttons) do
            buttons.isEnabled = false
        end

        self.isEnabled = true
    end
end

function PANEL:GetAddonName()
    return (self.addon != nil and self.addon.Name) or gmodstore:GetString("home")
end

function PANEL:SetAddon(addon)
    self.addon = addon
end
vgui.Register("gmodstore.NavbarButton", PANEL, "DButton")

local PANEL = {}
function PANEL:Init()
    self.buttons = {}
    self.base = self:GetParent()

    self.vbar = self:GetVBar()

    self:GetCanvas():DockPadding(5, 5, 5, 5)

    self.vbar.Paint = function(s, w, h) end
    self.vbar.btnGrip.Paint = function(s, w, h) end
    self.vbar.btnUp.Paint = function(s, w, h) end
    self.vbar.btnDown.Paint = function(s, w, h) end


    local w, _ = self.base:GetWide(), self.base:GetTall()

    self:SetWidth(w * 0.2)
end
function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
end

function PANEL:AddButton(addon)
    self.btn = self:Add("gmodstore.NavbarButton")
    self.btn:SetAddon(addon)

    table.insert(self.buttons, self.btn)
end
vgui.Register("gmodstore.Navbar", PANEL, "DScrollPanel")

