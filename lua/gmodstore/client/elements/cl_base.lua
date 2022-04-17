local COLOR = gmodstore.Colors

local PANEL = {}

function PANEL:Init()
    local scrw, scrh = ScrW(), ScrH()
    local sizex = 1600 * scrw / 1920
    local sizey = 900 * scrh / 1080

    self:SetSize(sizex, sizey)
    self:Center()
    self:MakePopup()

    self.header = self:Add("gmodstore.Header")
    self.header:Dock(TOP)

    self.navbar = self:Add("gmodstore.Navbar")
    self.navbar:Dock(LEFT)
    self.navbar:DockMargin(10, 10, 0, 10)

    self.categoryBar = self:Add("gmodstore.CategoryBar")
    self.categoryBar:Dock(TOP)
    self.categoryBar:DockMargin(10, 10, 10, 0)

    self.docker = self:Add("gmodstore.Docker")
    self.docker:Dock(FILL)
    self.docker:DockMargin(10, 10, 10, 10)
    // self.docker:DockPadding(0, 10, 0, 10)
    self.docker:GetCanvas():DockPadding(0, 0, 0, 10)

    self.apply = self:Add("gmodstore.Apply")
    self.apply:Dock(BOTTOM)
    self.apply:DockMargin(10, 0, 10, 10)

    self.isBase = true
    self.addons = {}
    self.activeAddon = nil
    self.AmountAddons = 0
    self.UpdatedAddons = {}
    self.OutdatedAddons = {}
    self.UndetectedAddons = {}

    self:AlphaTo(255, 1, 0)
end

function PANEL:Close()
    self.docker:ResetClientVariables()
    self:AlphaTo(0, 0.2, 0, function()
        self:Remove()
    end)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
end

function PANEL:SetAddons(addonTable)
    self.addons = addonTable

    self.navbar:Clear()

    self.navbar:AddButton(nil) -- Add the home button
    self.navbar.buttons[1]:DoClick()
    local Addons = 0
    for ID, addon in pairs(self.addons) do
        local versioning = addon.Versioning
        if versioning and versioning.Detected then
            if versioning.Updated then
                table.insert(self.UpdatedAddons, addon)
            else
                table.insert(self.OutdatedAddons, addon)
            end
        else
            table.insert(self.UndetectedAddons, addon)
        end

        self.navbar:AddButton(addon)

        -- Functions can't be transferred using util.TableToJSON and util.JSONToTable, so we take them from gmodstore.Addons
        for varName, variable in pairs(addon.Variables) do
            variable.Cond = gmodstore.Addons[ID].Variables[varName].Cond
        end
        Addons = Addons + 1
    end
    self.AmountAddons = Addons
end

function PANEL:GetActiveAddon()
    return self.activeAddon
end

function PANEL:SetActiveAddon(addon)
    self.docker:SetAddon(addon)

    if addon != nil then
        self.header:SetActiveLink(addon)
        self.apply:SetVisible(true)
        self.categoryBar:SetVisible(true)
    else
        self.header:DisableLink()
        self.apply:SetVisible(false)
        self.categoryBar:SetVisible(false)
    end
end

function PANEL:UpdateVariablesShown(categoryName)
    -- Update variables with category stuff
    self.docker:UpdateCategory(categoryName)

    -- Update the buttons
    for _, panel in pairs(self.categoryBar:GetCanvas():GetChildren()) do
        panel.isSelected = false
    end
end


vgui.Register("gmodstore.Frame", PANEL, "EditablePanel")