local COLOR = gmodstore.Colors


/*---------------------------------------------------------------------------
	Paint functions to paint a panel depending on the effect (none, hovered, down)
	If none of the colors are specified, then it means this is a "classic" label color scheme
	Returns the great color
---------------------------------------------------------------------------*/

function gmodstore.PaintFunctions(panel, panelNone, panelHover, panelDown)
	local panelColor = panelNone
	local panelHoverColor = panelHover
	local panelDownColor = panelDown
	if not panelColor then
		panelColor = COLOR.label
	end
	if not panelHoverColor then
		panelHoverColor = COLOR.labelHovered
	end
	if not panelDownColor then
		panelDownColor = COLOR.labelDown
	end

	local colorValue

	if panel:IsHovered() then
		if panel:IsDown() then
			colorValue = panelDownColor
		else
			colorValue = panelHoverColor
		end
	else
		colorValue = panelColor
	end

	return colorValue
end

/*---------------------------------------------------------------------------
	Open the gmodstore menu
	addons: the addons which are using the gmodstore system
---------------------------------------------------------------------------*/

function gmodstore:OpenPanel(addons)
	local configPanel = vgui.Create("gmodstore.Frame")
	configPanel:SetAddons(addons)
end