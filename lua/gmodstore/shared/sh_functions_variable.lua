function gmodstore:CreateAddon()
	return {}
end


function gmodstore:AddAddon(ADDON)
	if ADDON.Disabled then return end
	if string.len(ADDON.Name) <= 1 then
		MsgC(gmodstore.Colors.error, string.format("--- Issue with the config system for addon %s, contact the author ---\n", ADDON.ID))
		return
	end

	if ADDON.GlobalTable == nil then
		MsgC(gmodstore.Colors.error, string.format("--- Table specified for addon %s is incorrect, contact the author ---\n", ADDON.ID))
		return
	end

	ADDON.ID = gmodstore:GetCharID(ADDON.ID)

	local alreadySaved = gmodstore.Addons[ADDON.ID] != nil
	gmodstore.Addons[ADDON.ID] = ADDON
	if alreadySaved then
		-- Update the versioning again
		if SERVER then
			gmodstore:UpdateVersioning({[ADDON.ID] = ADDON})
		end
	end
end

/*---------------------------------------------------------------------------
precond: a table filled with the addon values
postcond: values of the global table have been set to the new value
---------------------------------------------------------------------------*/
function gmodstore:UpdateVariables(tableValues)

	for ID, variables in pairs(tableValues) do
		for varName, variable in pairs(variables) do
			if not variable then continue end


			local addonVariable = gmodstore.Addons[ID].Variables[varName]
			-- addonVariable could be set to nil if you had a variable in your JSON file which disappeared in a new addon version
			if not addonVariable then continue end

			if variable.Value != nil then
				addonVariable.Value = variable.Value -- set the value in the variables table (for gmodstore.Addons)

				gmodstore:SetVariable(ID, varName, variable.Value)
			end
		end

		local realID = gmodstore:GetRealID(ID)

		hook.Run("gmodstore:UpdateAddon", realID, variables)
	end
end


/*---------------------------------------------------------------------------
precond: the ID addon and the variable name
postcond: the variable is set to the global table
---------------------------------------------------------------------------*/
function gmodstore:SetVariable(ID, varName, varValue)
	local tab = gmodstore.Addons[ID]
	-- We set at the fixed table or the global addon table depending on the FixedTable parameter
	if tab.Variables[varName].FixedTable != nil then
		tab.Variables[varName].FixedTable[varName] = varValue
	else
		tab.GlobalTable[varName] = varValue -- set the value in the global table (for the real value...)
	end

end

/*---------------------------------------------------------------------------
precond: the variable with a valid default value
postcond: it will return the type depending on the default value type
---------------------------------------------------------------------------*/

function gmodstore:GetTypeOfVariable(variable)
	local variableType = type(variable.Default)
	if variable.Structure or variable.Elements then
		variableType = "table"
	elseif gmodstore:IsColor(variable.Default) then
		variableType = "color"
	end

	variableType = string.lower(variableType)

	return variableType
end

/*---------------------------------------------------------------------------
precond: the argument table is a valid table
postcond: it will return if it's a color or not depending on the IsColor verification + structure (a, r, g, b) verification
---------------------------------------------------------------------------*/

function gmodstore:IsColor(tab)
	local isColor = false
	if type(tab) == "table" then
		isColor = IsColor(tab) or (tab["a"] != nil and tab["r"] != nil and tab["g"] != nil and tab["b"] != nil)
	end
	return isColor
end

/*---------------------------------------------------------------------------
precond: the argument tab is a valid table of one dimension
postcond: returns a O(1) array
Example: {"banana", "apple"} becomes {["banana"] = true, ["apple"] = true}
---------------------------------------------------------------------------*/


function gmodstore:TransformToO1Array(tab)
	local newTab = {}
	for k, v in pairs(tab) do
		newTab[v] = true
	end
	return newTab
end

/*---------------------------------------------------------------------------
precond: the argument tab is a valid table of one dimension
postcond: returns a O(n) array, meaning an indexed table with values being values
Example: {["banana"] = true, ["apple"] = true} returns {"banana", "apple"}
---------------------------------------------------------------------------*/

function gmodstore:TransformToONArray(tab)
	local newTab = {}
	for k, v in pairs(tab) do
		table.insert(newTab, k)
	end
	return newTab
end

/*---------------------------------------------------------------------------
precond: 
	* element is a table from a specific list of gmodstore tables (InEnums, KeyEnums for example)
	* values are the values inserted in the table
postcond: returns the great values to use


On a des choix de type IN_ATTACK, IN_USE etc
Avec le getInterpretedValues on se retrouve avec le résultat "ATTACK", "USE"
---------------------------------------------------------------------------*/


function gmodstore:GetReinterpretedElement(elements)

	local originalTable = gmodstore:GetElementsTable(elements)
	local tab = {}
	if gmodstore:NeedsReverseInterpretation(elements) then
		local equivalenceTable = gmodstore:GetElementsEquivalenceTable(elements)
		for k, v in ipairs(originalTable) do
			table.insert(tab, equivalenceTable[v])
		end
	elseif elements == "usergroups" or elements == "vehicles" then -- nothing changes, we put the direct values in tab
		for k, v in ipairs(originalTable) do
			table.insert(tab, v)
		end
	elseif elements == "darkrp_jobs" or elements == "darkrp_shipments" or elements == "darkrp_entities" then
		for k, v in ipairs(originalTable) do
			table.insert(tab, v.name)
		end
	end

	return tab
end

/*---------------------------------------------------------------------------
precond: values are the values chosen on the VGUI
postcond: returns the real values
Example:
values = {"ATTACK", "RELOAD"}
returns {IN_ATTACK, IN_RELOAD} with the reverse equivalence table
---------------------------------------------------------------------------*/

function gmodstore:GetRealValue(values, elements)
	if type(values) != "table" then values = {values} end
	local tab = {}
	local reverseTable = gmodstore:GetElementsEquivalenceReverseTable(elements)
	for k, v in pairs(values) do
		table.insert(tab, reverseTable[v])
	end
	return tab
end

/*---------------------------------------------------------------------------
precond: values are the real values
postcond: returns the text values for the VGUI
Example:
values = {IN_ATTACK, IN_RELOAD}
returns {"ATTACK", "RELOAD"} with the equivalence table
---------------------------------------------------------------------------*/

function gmodstore:GetTextValue(values, elements)
	if type(values) != "table" then values = {values} end
	local tab = {}
	local equivalenceTable = gmodstore:GetElementsEquivalenceTable(elements)
	for k, v in pairs(values) do
		table.insert(tab, equivalenceTable[v])
	end
	return tab
end

/*---------------------------------------------------------------------------
precond: the argument elementConstant is a string for a table
postcond: returns if the argument should be reinterpreted meaning it's a gmodstore fixed value
like InEnums / KeyEnums where you have the number interpretation (IN_ATTACK) versus the "visual string" value ("ATTACK")
---------------------------------------------------------------------------*/

function gmodstore:IsReinterpretedElement(elementConstant)
	if type(elementConstant) != "string" then return false end
	elementConstant = string.lower(elementConstant)
	local exists = gmodstore.InterpretedElements[elementConstant] != nil

	return exists
end

/*---------------------------------------------------------------------------
precond: the argument elementConstant is a string for a table
postcond: returns if it should be reversed reinterpreted
meaning that when you have a number value for a variable, you would need to get the "visual string" interpretation and vice versa
---------------------------------------------------------------------------*/

function gmodstore:NeedsReverseInterpretation(elementConstant)
	if type(elementConstant) != "string" then return false end
	elementConstant = string.lower(elementConstant)
	return gmodstore:IsReinterpretedElement(elementConstant) and gmodstore.InterpretedElements[elementConstant].reverseEquivalence != nil
end


/*---------------------------------------------------------------------------
precond: the argument elementConstant is a string for a table
postcond: returns the equivalence table
---------------------------------------------------------------------------*/

function gmodstore:GetElementsEquivalenceTable(elementConstant)
	elementConstant = string.lower(elementConstant)
	return gmodstore.InterpretedElements[elementConstant].equivalence
end

/*---------------------------------------------------------------------------
precond: the argument elementConstant is a string for a table
postcond: returns the equivalence reverse table
---------------------------------------------------------------------------*/

function gmodstore:GetElementsEquivalenceReverseTable(elementConstant)
	elementConstant = string.lower(elementConstant)
	return gmodstore.InterpretedElements[elementConstant].reverseEquivalence
end

/*---------------------------------------------------------------------------
precond: elementConstant is a valid string
postcond: returns the table according to the typeTable
---------------------------------------------------------------------------*/

function gmodstore:GetElementsTable(elementConstant)
	elementConstant = string.lower(elementConstant)
	if not gmodstore:IsReinterpretedElement(elementConstant) then return nil end
	return gmodstore.InterpretedElements[elementConstant].tab
end