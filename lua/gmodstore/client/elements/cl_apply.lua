local COLOR = gmodstore.Colors

local PANEL = {}

function PANEL:Init()
    self.bChanging = false
    self.base = self:GetParent()
    self:SetHeight(30)

    self.apply = self:Add("DButton")
    self.apply:SetFont("gmodstoreFont:25")
    self.apply:SetText(gmodstore:GetString("apply_changes"))
    self.apply:Dock(FILL)
    self.apply.Paint = function(s, w, h)
        local curColor = gmodstore.PaintFunctions(s)
        s:SetTextColor(curColor)
        draw.RoundedBox(32, 0, 0, w, h, COLOR.basicframe)
        draw.RoundedBox(32, 0, 0, w, h, COLOR.g)
    end
    self.apply.DoClick = function(s)
        self:ApplyChanges()
    end
end


function PANEL:Paint(w, h)
    -- draw.RoundedBox(8, 0, 0, w, h, COLOR.basicframe)
end

/*
    Apply changes for a specific addon
    This will save the whole data (variables) from client to server
*/

function PANEL:ApplyChanges()

    if not self.base:GetActiveAddon() then return end

    local ADDON_ID = self.base:GetActiveAddon().ID
    local resultTable = {}
    resultTable[ADDON_ID] = {}
    for key, variableContainer in pairs(self.base.docker:GetVariables()) do
        local name = variableContainer:GetVariableName()
        local value = variableContainer:GetVariableValue()
        if value == nil then continue end

        resultTable[ADDON_ID][name] = {}
        resultTable[ADDON_ID][name]["Value"] = value
    end

    local content = util.TableToJSON(resultTable)
    local compressed = util.Compress(content)

    net.Start("gmodstore:SaveAddon")
        net.WriteUInt(#compressed, 32)
        net.WriteData(compressed, #compressed)
    net.SendToServer()
    self.base:Close()
end

vgui.Register("gmodstore.Apply", PANEL, "DPanel")