local COLOR = gmodstore.Colors

local PANEL = {}

function PANEL:Init()
    self.base = self:GetParent()
    self:Dock(TOP)
    self:DockMargin(0, 0, 0, 0)
    self:SetHeight(50)

    self.headerLineSize = 4

    self.close = self:Add("DButton")
    self.close:Dock(RIGHT)
    self.close:DockMargin(0, 5, 10, 5 + self.headerLineSize)
    self.close:SetFont("gmodstoreFont:30")
    self.close:SetColor(color_white)
    self.close:SetText("✕")
    self.close:SizeToContentsX(0)

    self.close.Paint = function(s)
        local curColor = gmodstore.PaintFunctions(s)
        s:SetTextColor(curColor)
    end
    self.close.DoClick = function(s)
        self.base:Close()
    end

    self.link = self:Add("DButton")
    self.link:Dock(RIGHT)
    self.link:DockMargin(10, 10, 10, 10 + self.headerLineSize)
    self.link:SetMinimumSize(300, 0)
    self.link:SetFont("gmodstoreFont:20")
    self.link:SetColor(color_white)
    self.link:SetText("")
    self.link.DoClick = function(s)

    end

    self.linkTip = self:Add("gmodstore.VariableTip")
    self.linkTip:SetVisible(false)

    self.link:SetTooltipPanel(self.linkTip)

    self:DisableLink()
end


function PANEL:SetActiveLink(addon)
    self.link:SetVisible(true)

    local versioning = addon.Versioning

    local linkTipText = gmodstore:GetString("gmodstore_url")
    if versioning then
        if versioning.Detected then
            if versioning.Updated then
                linkTipText = string.format("%s\n%s (%s)", linkTipText, gmodstore:GetString("have_last_version"), versioning.LastVersion)
            else
                linkTipText = string.format("%s\n%s: %s\n%s: %s", linkTipText, gmodstore:GetString("your_version"), addon.Version, gmodstore:GetString("last_version"), versioning.LastVersion)
            end
        else
            linkTipText = string.format("%s\n%s", linkTipText, gmodstore:GetString("versioning_not_enabled"))
        end
    else
        linkTipText = string.format("%s\n%s", linkTipText, gmodstore:GetString("website_not_detected"))
    end
    self.linkTip:SetTipText(linkTipText)


    self.link.Paint = function(s, w, h)
        if versioning then
            if versioning.Updated then
                draw.RoundedBox(8, 0, 0, w, h, gmodstore.PaintFunctions(s, COLOR.gl, COLOR.gl2, COLOR.gl3))
            else
                if versioning.Detected then
                    draw.RoundedBox(8, 0, 0, w, h, gmodstore.PaintFunctions(s, COLOR.rl, COLOR.rl2, COLOR.rl3))
                else
                    draw.RoundedBox(8, 0, 0, w, h, gmodstore.PaintFunctions(s, COLOR.bl, COLOR.bl2, COLOR.bl3))
                end
            end
        else
            draw.RoundedBox(8, 0, 0, w, h, gmodstore.PaintFunctions(s, COLOR.bl, COLOR.bl2, COLOR.bl3))
        end

        draw.SimpleText(addon.Name, "gmodstoreFont:25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.link.DoClick = function()
        gui.OpenURL(string.format("https://www.gmodstore.com/market/view/%s", gmodstore:GetRealID(addon.ID)))
    end
end

function PANEL:DisableLink()
    self.link:SetVisible(false)
end


function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)

    draw.RoundedBox(8, 0, h - self.headerLineSize, w, self.headerLineSize, COLOR.basicheader)

    draw.SimpleText(gmodstore:GetString("header"), "gmodstoreFont:30", 10, (h - self.headerLineSize) / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("gmodstore.Header", PANEL, "DPanel")

